# FIX-I2 — INSTRUMENT ĐƯỜNG HOME ([homelib]) — WO GPT ytz4, strand I2

Mức đạt: **source complete / build PASS / static PASS** (bằng chứng xe là thứ instrument này tạo ra ở phiên sau).
Phạm vi: CHỈ cộng log vào `SCPHooks.m`, `SCPAppIcons.m`, `SCPHomeApply.m` (cả hai cây project/ + src/). Không đổi hành vi inject/remove/apply; không hook mới.

## 1) Sự thật về process (trả lời thẳng yêu cầu của GPT)

Dylib có filter nạp vào cả `com.apple.CarPlayApp` và `com.apple.springboard`, nhưng **toàn bộ họ Home/library này chỉ tới được qua các constructor gated `SCPHostIsCarPlayApp()`** trong SCPHooks.m (`__init_0`) và các caller từ đó: hai hook thư viện, `SCPHandlePrefsChanged` (notify đăng ký trong `__init_0`), hook vòng đời HomeVC. Trong SpringBoard các điểm đo dưới đây **không bao giờ thực thi**. Mọi dòng [homelib] đều in `proc=<processName>(<mainBundleID>)` đọc tại runtime — phiên sau đối chiếu trực tiếp, không suy đoán: kỳ vọng mọi dòng đều là `CarPlay(com.apple.CarPlayApp)`.

## 2) Bản đồ điểm đo (số dòng theo cây project/ sau sửa; cây src/ trùng hệt, trừ dòng import có từ trước của SCPHomeApply.m)

### SCPHooks.m — sự kiện thư viện (log mọi lần)
| Dòng | Điểm | Nội dung |
|---|---|---|
| ~:99 | `Hook_newApplicationLibrary`, sau orig + sau lần inject | `event=new-library libclass= count= chosen=` — count = số phần tử của `allInstalledApplications` trên chính object thư viện vừa dựng (đúng accessor mà `SCPDumpAppLibraryOnce` dùng; −1 khi không đọc được an toàn), chosen = cỡ tập app đã chọn |
| ~:120 | `Hook_loadFromProxy`, sau orig + sau `SCPInjectDeclarationIfChosen` | `event=loadFromProxy bundle= injected=` — bundle đọc bằng mẫu guarded của chính file; injected = tư cách thành viên của tập đã tiêm SAU lời gọi inject |

### SCPAppIcons.m — nhật ký quyết định (qua `SCPHomeLibLogDecision`, helper :141; dòng OMNI :145)
| Dòng | Hàm | decision |
|---|---|---|
| :156 | SCPInjectDeclarationIfChosen | `skip-not-chosen` |
| :167 / :169 | SCPInjectDeclarationIfChosen | `skip-already-ours` / `skip-real-declaration` |
| :181 | SCPInjectDeclarationIfChosen | `skip-no-decl-class` |
| :213 | SCPInjectDeclarationIfChosen | `inject` (ghi declaration thành công — điểm ngay sau guard ghi) |
| :280 / :286 / :293 | SCPAddChosenAppsToLibrary | `lib-skip-present` / `lib-skip-no-proxy` / `lib-add` |
| :347 / :352 | SCPRefreshAppIconsBlock | `remove-skip-no-proxy` / `remove` — điểm `removeApplicationProxy:` **duy nhất** của module (grep toàn module: 1 điểm gọi) |

Bundle `com.anlai.omnicar.app`: mọi quyết định chạm tới nó đều log **và** cộng một dòng riêng `[homelib] OMNI decision=...` (kể cả skip), không bị throttle.

### SCPHomeApply.m — trạng thái lưới sau áp dụng
| Dòng | Điểm | Nội dung |
|---|---|---|
| :266 | Trong vòng walk icon của `SCPPublishCarAppsBlock` | lấy mẫu `homelibOmniOnGrid` **trước** các bộ lọc seen/injected — icon OmniCar dù thuộc tập đã tiêm vẫn tính là có mặt trên lưới |
| :324 | Cuối khối @try của `SCPPublishCarAppsBlock` | `event=apply-published count= omni=` — count = `found.count` (số icon thật walk thu được từ icon model đang sống; app điện thoại đã tiêm bị loại bởi chính bộ lọc của walk), omni từ mẫu ở :266 |

Lý do dòng trạng thái nằm ở publish block chứ không ở thân `SCPHomeApply`: thân apply không nắm dữ liệu lưới nào; publish block (chạy +1 s sau apply, guard theo generation nên tự dồn nhịp) là điểm hậu-áp-dụng duy nhất walk icon model đang sống. Đây cũng là chống ngập theo cấu trúc, không cần throttle thêm.

## 3) Throttle chống ngập

- Quyết định theo bundle: cache trong bộ nhớ `bundle -> decision` gần nhất (@synchronized); chỉ log khi quyết định **đổi** so với lần trước cho bundle đó. Lần dựng thư viện đầu tiên cho tối đa một dòng mỗi bundle; các lần load/refresh lặp lại im lặng trừ khi quyết định đổi.
- Ngoại lệ: `com.anlai.omnicar.app` không bao giờ bị nén (WO yêu cầu đánh dấu mỗi lần nó xuất hiện trong quyết định).
- Sự kiện thư viện (`new-library`, `loadFromProxy`) và `apply-published`: log mọi lần theo WO mục 4. `loadFromProxy` bùng theo số app info lúc dựng thư viện — có giới hạn tự nhiên, cùng bậc với chính sự kiện dựng.

## 4) Khoảng trống đã khai (không giấu)

- Quyết định **ghi declaration thất bại** (`SCPHomeSafeSet` trả NO → return trần trong `SCPInjectDeclarationIfChosen`) không có token [homelib] riêng: chặn nó bắt buộc phải viết lại đúng dòng guard đó (một dòng bị sửa), phá cổng diff thuần cộng. Thất bại này **đã có log sẵn** của chính `SCPHomeSafeSet` ("AppIcons: khong dat duoc _carPlayDeclaration ..."). Đánh đổi có chủ ý, ghi tại đây để kiểm độc lập không phải đoán.
- Hai nhánh missing-selector của `addApplicationProxy:withOverrideURL:` / `removeApplicationProxy:` không journal riêng — `SCPMissingSelector` tự bề mặt chúng.
- `count=` của `new-library` là cỡ mảng `allInstalledApplications` của object thư viện (khác `count=` của `apply-published` là số icon trên lưới Home) — hai con số đo hai thứ khác nhau, đọc log phải phân biệt.

## 5) Cổng

- Diff vs pristine (tự đối chiếu cả hai cây): SCPHooks.m **+48/−0**, SCPAppIcons.m **+58/−0**, SCPHomeApply.m **+20/−0**; mirror src/: Hooks/AppIcons cmp identical với project/, HomeApply chỉ lệch dòng import `../SplitScreenB/` có từ trước (diff của chính nó cũng +20/−0). Mọi hunk là log/helper thuần; không hunk nào tách một `if` không ngoặc sẵn có (các điểm cạnh `return`/`continue` trần đều là câu lệnh độc lập đặt trước, dùng lại biến đã tính).
- Số lần xuất hiện hook-installer trong SCPHooks.m: 31 → 31 (không hook mới; log nằm bên trong hook sẵn có).
- Build module SplitScreen `make clean && make`: exit 0, link + ký xong. Warning: 4, truy hết về dòng cũ (OMCCheckHooks nil ở SCPHooks — pristine :776; performSelector ×2 + lời gọi nil-override ở SCPAppIcons — đều có từ trước), **0 warning trên dòng mới**.
- Dylib 1.319.248 B chứa đủ 5/5 format `[homelib]`: new-library, loadFromProxy, decision, OMNI, apply-published.

## 6) Bằng chứng kỳ vọng ở phiên sau

- `[homelib] proc=CarPlay(com.apple.CarPlayApp) event=new-library ... count=<số app cài>` ngay khi DashBoard dựng thư viện — nếu count vẫn 0/−1 ở ĐÂY thì object thư viện khác hẳn giả định (điểm mù cũ đọc ở SCPCarApps, ngữ cảnh khác).
- Chuỗi quyết định cho từng bundle đã chọn: `lib-add` hoặc `lib-skip-present` → `inject`/`skip-*`.
- Nếu icon OmniCar mất mà **không** có bất kỳ dòng OMNI/decision nào cho `com.anlai.omnicar.app`: điểm mất nằm HẠ nguồn của đường inject/remove này (icon model/lưới), thu hẹp đúng như GPT yêu cầu; nếu có dòng `remove` cho nó — kết án tại chỗ kèm proc + mốc thời gian.
