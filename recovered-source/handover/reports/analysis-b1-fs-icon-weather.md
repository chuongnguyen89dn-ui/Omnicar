# Phân tích log phiên YTZ3 — Cụm B1: Fullscreen + App-library/Icon + Scenevis + Weather

Chỉ-đọc; mọi con số đếm bằng lệnh trên file gốc, trích dòng kèm timestamp + PID.

## 0. File và cửa sổ phân tích

| File | Byte | Dòng | SHA-256 | Khoảng thời gian |
|---|---|---|---|---|
| `OmniCar.log.old` | 2.100.219 | 6.957 | `ea0b20bab8458f545f52c3dd276a966e743a4c10fdf9a031472671d6253b9f3e` | 15:33:22 → 16:35:40.027 |
| `OmniCar.log` | 107.094 | 879 | `7c14140d45b712476d9f20c62bc3ae161fa6da623c0ea482995302c10c771290` | 16:35:40.244 → 16:50:44.741 |

- **Mốc mở cửa sổ ytz3**: dòng `[probe-feed]` đầu tiên của toàn bộ dữ liệu — `OmniCar.log.old` dòng 2332: `2026-11-09 16:18:14.148 [CarPlay:34964] [probe-feed] t=292493.740 epoch=1 fired pane=slot0(com.google.Maps)`. Phần trước mốc này trong `.old` là đuôi phiên ytz2, ngoài phạm vi.
- Cửa sổ phân tích = `.old` dòng 2332→6957 (4.626 dòng, 16:18:14.148 → 16:35:40.027) + toàn bộ `OmniCar.log` (phần nối tiếp).
- **PID CarPlay trong cửa sổ: 3** — 34964 (16:18:14 → 16:19:08.891), 34985 (nạp 16:19:13.435, `loaded into CarPlay [fixround7]` + `[fs1] fs controller installed` 16:19:13.454 → 16:27:15.089), 35035 (16:27:19.763 → ngắt 16:42:18.552). PID SpringBoard đổi đồng bộ: 34934 → 34986 → 35036. Hai lần đổi PID là hai lần process CarPlay/SpringBoard khởi động lại giữa các đoạn test; **log không có chữ ký crash** (mục 4) — nguyên nhân đổi PID không xác định được từ log này (cùng mẫu phiên ytz2).
- Ký hiệu đếm: "đếm được" = có dòng log tương ứng; "không có trong log" = grep toàn cửa sổ = 0.

## 1. Fullscreen — [fs-diag] + [fs1]

### 1.1 Số đếm tổng (toàn cửa sổ, cả hai file)

| Sự kiện | Số lần |
|---|---|
| `[fs-diag] fullscreenDiagExpand -> ON` (gạt bật) | **20** |
| `[fs-diag] fullscreenDiagExpand -> OFF` (gạt tắt) | **20** |
| `[fs1] fs expand confirmed` | **13** (34985: txn 1,3,5,7,9,11,13 — 7 lần; 35035: txn 1,3,5,7,9,11 — 6 lần) |
| `[fs1] fs restore confirmed` | **11** (34985: 6; 35035: 5) |
| `[fs1] fs session-end abbreviated restore` (teardown) | **2** (16:25:58.882 PID 34985; 16:42:18.462 PID 35035 — dòng `[fs1]` duy nhất trong `OmniCar.log`) |
| `[fs1] fs expand refused` | **7** — tất cả `reason=inactive` |
| `[fs1] fs restore refused` | **9** — tất cả `state=SPLIT` |
| Refusal với `reason=tray` / `picker` / `popup` / `solo` / `zoom` | **0** |

Kiểm tra chéo sổ sách: 13 expand = 11 restore confirmed + 2 session-end restore ✓. 20 ON = 13 chạy + 7 bị từ chối inactive ✓. 20 OFF = 11 restore + 9 refused state=SPLIT ✓.

### 1.2 Refusals và snapshot của chúng

Cả **16/16 refusal mang snapshot GIỐNG HỆT NHAU**:
`snap{tw=1 twh=1 to=1 tray=0 picker=0 ratio=0 dg=0 toast=0 rz=0 fc=0 phase=0}`

Đọc snapshot: `tw=1` trayWindow còn tồn tại (giữ lại), `twh=1` trayWindow đang hidden, `to=1` cờ trayOverlay dính vẫn bật, nhưng `tray=0 picker=0 ratio=0 dg=0 toast=0` — **không một bề mặt popup nào đang hoạt động** tại bất kỳ lần từ chối nào.

- 7 expand refused `reason=inactive`: 16:19:08.507 (34964 — PID sắp chết, split chưa active); cụm 6 lần 16:26:15.418 / 16:26:30.384 / 16:26:31.655 / 16:26:33.966 / 16:26:58.978 / 16:27:15.089 (34985) — toàn bộ nằm SAU session-end 16:25:58 (split đã tắt), Nguyen vẫn gạt công tắc trong Cài đặt nên listener vẫn ghi nhận nhưng controller từ chối vì split inactive. Khớp đúng bản chất "inactive" như hai lần 15:39 ở phiên ytz2.
- 9 restore refused `state=SPLIT`: các lần gạt OFF khi chưa từng expand trong phiên/PID đó (16:19:08.090, 16:22:03.749, 16:26:09.075, 16:26:16.029, 16:26:31.103, 16:26:32.616, 16:26:58.429, 16:27:14.659 — 34985/34964; 16:27:49.518 — 35035). Nhất quán, vô hại.

**Bằng chứng trực tiếp cho sửa guard (ytz3)**: tại 16:19:08.506–.507 (34964), yêu cầu expand mang `tw=1 twh=1 to=1` — đúng tổ hợp mà vị từ cũ của ytz2 (`trayWindow || trayOverlay`) sẽ kết án `reason=tray`. Ở ytz3 nó bị từ chối **chỉ** vì `inactive`. Và trong toàn cửa sổ **không có refusal nào mang reason=tray** — nhánh tray của guard mới không chặn một lần nào, trong khi điều kiện tồn-tại-window (tw=1/to=1) hiện diện ở 16/16 snapshot.

### 1.3 Ca kiểm bắt buộc của GPT: mở picker → đóng hoàn toàn → expand phải chạy

Picker mở thật được chứng minh độc lập bởi feed: `[probe-feed] drop-popup(picker)` tại 16:21:08.435/.443, 16:21:11.013/.019 (34985) và 16:25:49.870/.877 — chạm bị loại vì popup picker đang hoạt động; kèm `[applib] build reason=picker-*` tại các mốc mở (mục 3). **Hai lần trình tự đầy đủ xuất hiện trong log:**

- **(a) PID 34985**: picker mở ~16:21:06.580 (build picker-native/chosen) + đang mở tại 16:21:08–16:21:11 (drop-popup) → snapshot `picker=0` lúc 16:22:03.749 (đã đóng hẳn) → **expand confirmed 16:22:04.454**.
- **(b) PID 35035**: picker mở 16:27:30.396 (build) → snapshot `picker=0` lúc 16:27:49.518 → **expand confirmed 16:27:50.015**.

Chiều ngược (popup đang mở thì vẫn phải chặn): trong phiên này **guard FS không đối mặt một popup đang mở nào** (picker=0 ở 16/16 snapshot, không expand-request nào rơi vào lúc picker=1) — tính chặn-khi-mở chỉ có bằng chứng ở tầng feed (6 dòng drop-popup(picker)), chưa có ca FS trực tiếp. Ghi đúng phạm vi: không suy diễn thêm.

### 1.4 Khớp báo cáo của Nguyen + sổ phiên expanded

- Nguyen báo "công tắc fullscreen có hoạt động" — **log khớp hoàn toàn**: mọi lần gạt đều có dòng [fs-diag] tương ứng trong cùng PID; mọi expand lúc split đang active đều confirmed (13/13 khi qua cổng), mọi restore tương ứng đều confirmed hoặc khép bằng session-end.
- 13 khoảng expanded (expand confirmed → restore/session-end): 4,1 s; 41,2 s; 0,8 s; 0,9 s; 1,4 s; 10,3 s; **77,6 s** (16:24:41.248→16:25:58.882); 3,6 s; **226,8 s** (16:28:06.340→16:31:53.100); 53,6 s; 19,0 s; 0,8 s; **521,3 s** (16:33:37.123→16:42:18.462). Tổng ≈ 961 giây ở trạng thái expanded.

## 2. AutoHide khi EXPANDED — xác nhận báo cáo "logo không tự ẩn khi fullscreen"

Số đếm được:

- `[autohide] suspend` = **13**, `[autohide] resume` = **12** (+ phiên expanded cuối khép bằng teardown 16:42:18, không có resume). Ghép cặp theo timestamp: **mỗi expand confirmed có một suspend cùng mili-giây** (13/13), mỗi restore confirmed có một resume cùng mili-giây (11/11), session-end 16:25:58.882 cũng có resume cùng mốc. Hai khóa treo được thiết kế đã nhắc (suspend qua `bwSetExpandedActive` + cổng fade `expanded`) vận hành đúng như source mô tả.
- `[autohide] fade` (không tính deferred/teardown) = **14** trong toàn cửa sổ: 16:18:21.117, 16:18:31.943, 16:19:29.562, 16:19:37.607, 16:19:42.484, 16:19:53.153, 16:20:08.590, 16:21:15.619, 16:21:38.229, 16:23:11.230 (idle=97.00 — fade bù ngay sau restore txn12), 16:27:36.200, 16:28:00.197, 16:33:18.997, 16:33:25.840. **Số fade rơi vào bên trong 13 khoảng expanded: 0.**
- `reveal-applied` = 13: 9 lần `reason=activity` (đều ở trạng thái split) + 4 lần `reason=unsuspend views=6` rơi đúng mili-giây expand (16:22:04.454, 16:27:50.015, 16:28:06.340, 16:33:33.848) — là reveal lúc VÀO suspend, không phải reveal do chạm giữa phiên expanded.

Kết luận đếm được: ba khoảng expanded dài 77,6 s / 226,8 s / 521,3 s — gấp 19×/57×/130× ngưỡng idle 4,00 s — **không sinh một fade nào**. AutoHide bị treo trọn thời gian expanded. Báo cáo của Nguyen (16:25, nằm trong khoảng 77,6 s) được log xác nhận bằng số, không phải lỗi cảm nhận.

## 3. Icon / Dock — [applib]

Số đếm được: **26 dòng [applib]**, gom thành **5 cụm build** (16:19:23.862, 16:21:06.580, 16:21:09.881 — PID 34985; 16:25:47.964 — 34985; 16:27:30.396 — PID 35035). Mỗi cụm: 1 live-grid-read + 1 drop + build picker-native (count=13) + picker-chosen (count=5); bridged-rebuild (count=5) ở 4/5 cụm; publish-for-settings (count=13) ở 2/5 cụm.

- **live-grid-read: `count=0 omni=0` ở cả 5/5 lần.** Đầu đọc lưới-đang-sống trả về RỖNG tại mọi lần đọc trong cửa sổ. Hệ quả trung thực: omni=0 ở đây **không phân biệt được** "icon đã bị gỡ khỏi lưới" với "lưới không đọc được từ process/ngữ cảnh này" — đầu dò không quan sát được một lưới có dữ liệu nào trong suốt phiên để làm mốc so sánh.
- **`com.anlai.omnicar.app` xuất hiện 0 lần trong toàn cửa sổ** (grep cả hai file = 0): không ở live-grid-read, không ở picker-native (`omni=0`, `omniFromGrid=0` ×5), không ở bridged-rebuild (`omni=0` ×4), không ở publish-for-settings (`omni=0` ×2), và **không nằm trong danh sách drop**. Tức: trong cửa sổ này không tồn tại mốc chuyển 1→0 nào của icon OmniCar trong log — icon vắng mặt một cách hằng định ở mọi danh sách được dựng, ngay từ cụm đầu tiên 16:19:23.862. Cơ chế mất icon (vụ ytz2) **không có trong log này** để kết án; phần đếm được chỉ khẳng định các danh sách picker/settings không hề chứa app OmniCar tại bất kỳ thời điểm nào của phiên.
- **Drop**: 5 dòng, nội dung giống hệt nhau, tất cả `source=library-walk`, 12 bundle, **tất cả cùng một lý do `(no-carplay-ui)`**: com.nuvio.app, com.apple.CarPlayTemplateUIHost, com.apple.Home, com.apple.CarPlaySettings, com.apple.CarPlayApp, com.google.ios.youtube, com.apple.siri, com.apple.springboard, com.facebook.Facebook, com.apple.InCallService, com.apple.CarPlayWallpaper, com.ss.iphone.ugc.Ame. Không có drop vì lý do duplicate/not-installed; YouTube/Facebook/TikTok bị loại khỏi picker-native vì không có CarPlay UI — chúng vào qua đường bridged (picker-chosen count=5).
- **Tương quan sự kiện**: `tat split` = 4 (16:18:40.018 goHome=0; 16:21:19.321 goHome=0; 16:25:58.826 goHome=1 — cùng mili-giây với fs session-end; 16:33:08.602 goHome=0), mỗi lần kèm going-home snapshot + teardown lease YouTube phía SpringBoard. Không cụm build [applib] nào rơi ngay sau một tat split ngoài cụm 16:21:06 (trước tat split 16:21:19) và 16:27:30 (sau đổi PID) — không có tương quan thời gian nào giữa dựng danh sách và thoát Home/respring trong log này. Hai lần đổi PID (16:19:13, 16:27:19) không kèm dòng [applib] bất thường nào; cụm build đầu tiên của mỗi PID mới đều cho cùng một kết quả hằng định (13/5/omni=0).

## 4. Scenevis — truy ca "ô trắng"

Số đếm được: **64 dòng [scenevis]** — verify 25, detach-bg 11, going-home 7, attach 7 (kèm 1 detach đơn), host-state-ready 5, host-attach 5, invalidate 2, pane-remove 1, scene-destroyed 0.

- **Verify: 25/25 dòng khỏe tuyệt đối** — `attached=1 inHost=1 hidden=0 alpha=1.00 window=1` (com.google.Maps ×14: slot0 ×1, slot1 ×13; com.lumi.GOFA ×11: slot1). Không một dòng verify nào mang attached=0 / hidden=1 / alpha=0.00 / window=0.
- Mọi dòng scenevis mang `attached=0` (19 dòng) đều thuộc **ô hosted YouTube slot0 với `scene=nil`** tại các điểm host-attach / host-state-ready / going-home / detach-bg / invalidate — trạng thái cấu trúc bình thường của ô hosted (không có FBScene trong process CarPlay), và ngay cả các dòng này vẫn `hidden=0 alpha=1.00 window=1`. Đây không phải chữ ký ô trắng.
- **Going-home snapshots** (4 sự kiện, 7 dòng): 16:18:40.018 (YouTube slot0 scene=nil + Maps slot1 attached khỏe), 16:21:19.322 (tương tự), 16:25:58.827 (chỉ YouTube — mốc session-end), 16:33:08.603/.604 (YouTube + GOFA attached khỏe). Không snapshot nào cho thấy ô native bị detach/hidden tại thời điểm thoát Home. Các attach của ô native (Maps 16:18:21.558/16:18:33.077/16:19:25.941/16:21:25.264; GOFA 16:25:49.952/16:27:32.618/16:33:17.065) đều attached=1 ngay tại điểm gắn; pane-remove duy nhất (GOFA 16:25:58.821) cũng attached=1, xảy ra trong teardown của session-end.
- **Crash**: grep exception/SIGBUS/abort/EXC_/unrecognized-selector toàn cửa sổ chỉ trúng 2 dòng DIAG dump ivar của DBDashboardHomeViewController (chuỗi "exception" nằm trong tên thuộc tính dump) — **0 chữ ký crash thật**. Hai lần đổi PID (mục 0) vì vậy vẫn không rõ nguyên nhân từ log này.
- Kết luận: **phiên ytz3 không có ca ô trắng nào khớp scenevis** (Nguyen cũng không phàn nàn ô trắng ở phiên này). Vụ ô trắng ytz2 vẫn chưa có bằng chứng trạng thái tại thời điểm trắng; instrument đã chạy đúng nhưng phiên này không tái hiện.

## 5. Weather — chuỗi request → answer → display

Số đếm được: **8 dòng [weather]** (kèm 8 dòng legacy cùng nội dung) — **toàn bộ thuộc 2 giao dịch warming-cache phía SpringBoard**, mỗi giao dịch ngay sau một lần SpringBoard khởi động lại:

| # | PID | begin | fetch | kết thúc | Nguồn vị trí | Kết quả |
|---|---|---|---|---|---|---|
| W1 | SpringBoard:34986 | 16:19:28.943 `ans#1 begin` | 16:19:28.969 `fetch-begin source=nav app's (0 min old)`; legacy: `location status 0, last fix none` → fallback vị trí app dẫn đường | 16:19:30.128 `ans#1 ready-posted`; legacy `updated in 1.2s (http 200, no error)` | warming | ✅ kết thúc |
| W2 | SpringBoard:35036 | 16:27:35.514 `ans#1 begin` | 16:27:35.539 (cùng mẫu) | 16:27:36.663 `ans#1 ready-posted`; `updated in 1.1s (http 200, no error)` | warming | ✅ kết thúc |

- Cả hai đều có nhãn tường minh `source=warming-cache (internal startup call, NOT a CarPlay request)`.
- **Request thật từ CarPlay: 0.** Grep toàn cửa sổ: `req#` = 0 dòng; `answer-received` = 0; `applied` phía weather = 0; `display` phía weather = 0; `timeout-no-answer` = 0. Timeout trong cửa sổ: **0 lần** (cả hai giao dịch warming đều HTTP 200 trong ~1,1–1,2 s, location status 0 → fallback chạy đúng thiết kế).
- Phán đúng phạm vi GPT yêu cầu: **chưa có bằng chứng chuỗi request-từ-CarPlay → answer → display trọn vẹn** — vì phiên này không phát sinh request thật nào trong log để truy. Phần đếm được chỉ xác nhận lại nhánh warming/fetch/fallback kết thúc đúng ở cả hai lần khởi động lại. Nguyen không phàn nàn weather phiên này; trạng thái mục này giữ nguyên: THIẾU DỮ KIỆN, không phải PASS.

## 6. Rà phần nối tiếp — OmniCar.log (16:35:40 → 16:50:44)

- 879 dòng: 808 dòng CarPlay:35035 SplitScreen (áp đảo là `bw renew`/`bw emit`), 66 dòng GOFA SpeedBubble, lác đác StartupScreen/Core. **[fs-diag] = 0, [applib] = 0, [scenevis] verify = 0, [weather] = 0, fade = 0** trong file này.
- Sự kiện phiên duy nhất: cụm kết thúc 16:42:18.459–.552 — `DashBoard invalidate -> bo split` (xuất hiện đúng 1 lần trong cả phiên, tại teardown cuối), scenevis invalidate ×2, `bw session teardown -> INACTIVE`, `[autohide] teardown faded=0`, `[fs1] fs session-end abbreviated restore`, `bw expanded OFF`, rồi `screen disconnected` 16:42:18.552 (ngắt CarPlay hẳn). Khoảng expanded cuối (từ 16:33:37.123) bắc qua cả hai file và khép ở đây.
- Sau 16:42:18.552 đến hết file (16:50:44.741): chỉ còn SpeedBubble phía điện thoại (GOFA) — không sự kiện CarPlay nào nữa.

## 7. Tóm tắt: đếm được / không có trong log

**Đếm được (có bằng chứng):**
1. FS: công tắc hoạt động đúng như Nguyen báo — 20 ON/20 OFF ghi nhận, 13 expand confirmed, 11 restore confirmed + 2 session-end; mọi refusal đều state-based (inactive ×7, state=SPLIT ×9), **0 refusal vì tray/picker/popup**; snapshot 16/16 giống hệt, popup=0 ở tất cả.
2. Ca bắt buộc của GPT (picker mở → đóng hẳn → expand chạy) xuất hiện **2 lần đầy đủ** trong log (16:21→16:22:04.454; 16:27:30→16:27:50.015). Chiều chặn-khi-mở chưa có ca FS trực tiếp (chỉ có bằng chứng feed drop-popup ×6).
3. AutoHide treo trọn thời gian expanded: 13 suspend khớp 13 expand; **0/14 fade rơi trong khoảng expanded**; 3 khoảng dài 77,6/226,8/521,3 s không fade — báo cáo của Nguyen được xác nhận bằng số.
4. Icon: `com.anlai.omnicar.app` **0 lần xuất hiện** trong mọi danh sách/dòng của cửa sổ; drop chỉ có 12 bundle `(no-carplay-ui)` từ library-walk, giống hệt ở 5/5 cụm.
5. Scenevis: verify **25/25 khỏe**; không ca ô trắng nào trong phiên; 0 crash signature.
6. Weather: 2/2 warming kết thúc HTTP 200 (~1,1–1,2 s, fallback vị trí chạy); timeout 0.

**Không có trong log (không kết án được):**
1. Cơ chế mất icon OmniCar: live-grid-read trả rỗng 5/5 lần nên đầu dò không có mốc lưới-đầy để đối chiếu; icon vắng hằng định từ đầu cửa sổ, không có mốc chuyển trạng thái.
2. Chuỗi weather request-thật → answer → display: phiên không phát sinh request thật nào.
3. Nguyên nhân hai lần đổi PID CarPlay/SpringBoard (16:19:13, 16:27:19).
4. Ca FS bị chặn khi popup đang mở thật (guard chưa đối mặt trong phiên này).
