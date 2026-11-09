# PHÂN TÍCH PHIÊN YTZ4 — BẢN ĐỐI HOÀ (S1+S2+S3+S4)

Nguồn: OmniCar.log.old (2.183.174 B, sha ef801287…, 10.889 dòng) + OmniCar.log (719.813 B, sha 438701f9…, 1.678 dòng).
Biên bản thành phần: analysis-s1-frame-fs.md / analysis-s2-wakekb.md / analysis-s3-iconfade.md / analysis-s4-ytz-misc.md.
Biên bản nguồn đối chiếu: probe-fade-icon.md, probe-exit-fade.md, probe-kb-frame.md (work/wake-round/).

## CẢNH BÁO KHUNG — HAI THẾ HỆ BINARY TRONG CÙNG HAI FILE LOG (S1)

Hai file chứa **hai thế hệ binary**. Các tag chỉ-có-ở-ytz4 ([homelib], [kb-sync], [ytz-revoke-snap]; ytz3 = 0 theo ci-ytz4) xuất hiện lần đầu ở **CarPlay PID 35998 lúc 17:23:48**; các PID trước đó (35035/35411) có 0 dòng các loại này và mang chữ ký hành vi cũ (suspend khi expand, nâng HIDDEN->VISIBLE). Marker ytz4 đầu tiên:

`2026-11-09 17:23:48.836 [CarPlay:35998] SplitScreen: [fs1] fs controller installed (CarPlayApp)`

**Mọi verdict dưới đây lấy phạm vi binary ytz4 (17:23:48 → hết log 17:44:31)** trừ chỗ ghi rõ toàn file. Gộp hai thế hệ sẽ đảo ngược kết luận ở mục fade-expanded (khoảng expanded dài nhất toàn file, 820,2 s ở PID 35411, là của binary cũ với 0 fade — bức tranh ytz3 nguyên vẹn).

## BẢNG VERDICT

| Mục | Verdict | Con số quyết định |
|---|---|---|
| Khung phiên / nguyên nhân chuyển PID | NO DATA | crash grep sạch tuyệt đối (S1+S4 độc lập); PID CarPlay ytz4: 35998→36057→36136→36168 |
| Fullscreen controller + guard | **DEVICE PASS** | ON 9/OFF 10; expand confirmed 3; restore 3; refusal 13 toàn state-based |
| Ca guard ngược (picker mở → chặn) | **DEVICE PASS** | chuỗi khép trọn 17:28:14→17:28:20 (chi tiết §2) |
| Fade khi EXPANDED | **DEVICE PASS** | E3 136,6 s: fade+reveal khép; E2 74,0 s: 3 fade; suspend tại expand 0/3 (S2 độc lập khớp) |
| KB transport (host→owner→app) | **DEVICE PASS** | probe mới 48: kbKnown=1 ×36; kbSrc=owner ×42; kbAge max 3.131 ms, 0 ca >3.500 ms; 18/18 post mở/đóng khớp owner ≤3 ms |
| wouldSwallow dương | **DEVICE PASS (mức would)** | wouldSwallow=1 ×8 (ytz3: 0), 100% tổ hợp known=1/active=0/owner/state=H |
| Chuỗi suppression trọn (kb chặn / gõ / sau đóng) | **NO DATA — chưa khép** | 0 probe trong cửa sổ phím mở; gõ chữ 0 dòng; sau đóng 0 probe cùng assignment (§4) |
| Native wake feed (hồi quy) | **DEVICE PASS** | fired 86; chuỗi fade→fired→reveal 14/14 khép; hosted act 54/54 |
| W2 freshness (state >2,5 s) | ĐÃ XUẤT HIỆN | stateage max 8.092 ms, 12/54 ca >2.500 ms (hai phiên trước: 0) |
| Icon — tầng trong split | CHƯA PHÂN ĐỊNH (log); sơn mờ MINH OAN (source) | §5 |
| Icon — tầng sau thoát Home | TƯƠNG QUAN CƠ CHẾ ĐÃ KHỚP LOG; tầng cell dashboard CHƯA PHÂN ĐỊNH | thoát-lúc-mờ ⇒ goHome=NO 5/5; thư viện: remove = 0 toàn phiên (§5) |
| Phím — ảnh 2→3 bị bó | **KẾT ÁN: che khuất z-order** | giữa hai ảnh 0 show mới; khung đóng băng tại show (§6) |
| Pinch / hiệu chuẩn | NO DATA | active=2: 101 ca, duplicate 101/101, thật 0; hiệu chuẩn KHÔNG được thực hiện (0 episode chạm ≥2 s) |
| YTZ lease/ack | **DEVICE PASS** | applied 51/51 w=1 m=0 (ytz3: 38/38); mask 24 lọt 0 |
| YTZ OFF control | NO DATA | 0 ca pref revoke trong phiên (8/8 thu hồi là teardown) |
| Revoke-snap/nextlayout | PASS một phần | snap 7, nextlayout 3, cặp 3/7; lastDecl=unavailable 7/7 |
| Weather / Knob | NO DATA (như cũ) | req# = 0 (chỉ 5 chu kỳ warming); payload knob = 0 |
| Scenevis / lỗi toàn cục | PASS | verify 39/39; exception thật = 0 |

## §1 KHUNG PHIÊN

Toàn file 4.131,7 s; phần ytz4 1.323,5 s; split đóng/mở ~9–10 lần ở phần ytz4. Nguyên nhân các lần chuyển PID (kể cả dồn dập cuối phiên, SpringBoard reload đồng bộ) **chưa rõ** — hai strand quét độc lập đều 0 crash signature. Giữ nguyên trạng thái của hai phiên trước: ghi nhận, không kết án.

## §2 FULLSCREEN — GUARD NGƯỢC ĐÃ ĐẠT, FADE-EXPANDED ĐÃ ĐẠT

Ca bắt buộc từ ytz3, chuỗi khép trọn trong 7 giây (PID 35998):
- Mở picker: `2026-11-09 17:28:14.216 [CarPlay:35998] SplitScreen: CarSplit: popup chon 18 app cho o 0 (cua so rieng, 0 o cho)`
- Bị chặn: `2026-11-09 17:28:15.785 [CarPlay:35998] SplitScreen: [fs1] fs expand refused reason=picker provenance=diag snap{tw=1 twh=0 to=0 tray=0 picker=1 ratio=0 dg=0 toast=0 rz=0 fc=0 phase=0}` (lặp lại 17:28:17.819)
- Đóng picker bằng chạm 17:28:19.955 → `2026-11-09 17:28:20.989 [CarPlay:35998] SplitScreen: [fs1] fs expand confirmed txn=5 provenance=diag`

Fade khi EXPANDED (sau gỡ 3 khoá): E3 (136,6 s, dài nhất của ytz4): fade 17:26:51.589 → reveal 17:27:08.550 khép (+17,0 s); nửa sau E3 bị deferred (surface-open) ×14 vì picker đang mở — khoá giữ có chủ đích, không phải lỗi. E2 (74,0 s): 3 fade (kèm ->HIDDEN + host applied), 2 chuỗi fade→reveal khép. Tại expand của ytz4: 0 suspend, 0 nâng HIDDEN->VISIBLE (state vào đã HIDDEN thì giữ HIDDEN — phép nâng đã gỡ đúng thiết kế). Mục fullscreen của GPT coi như **đóng nghiệm thu** ở các ca đã chạy.

## §3 WAKE + KB — TRANSPORT ĐẠT, WOULD ĐẠT, GATE 3 CÒN 3 MẮT NO DATA

KB (vấn đề giặt nguồn của ytz3) **đã đóng ở tầng transport**: owner phát gói type 6, app nhận với kbSrc=owner ×42/48 probe mới; kbAge max 3.131 ms < ngưỡng tươi 3.500 ms ở mọi ca. UNKNOWN-reset khi đổi gán có xảy ra ×2 (gen 2/3 và gen 15) nhưng là reset CÂM trong source — không có dòng log riêng (khoảng trống instrument, ghi nhận cho GPT).

wouldSwallow=1 xuất hiện lần đầu tiên trong dự án: ×8, mọi ca đều known=1 / kbActive=0 / kbSrc=owner / state=H. Mắt "kb ACTIVE chặn nuốt" vẫn **chưa có dữ kiện**: toàn phiên chỉ 1 probe có kbActive=1 và ca đó ở state=V nên cổng thoát ở mắt state trước khi tới mắt kb (reason kb = 0 lần).

## §4 CHUỖI SUPPRESSION 17:32–17:33 — KHÔNG KHÉP, VÀ THỨ TỰ NGƯỢC KỊCH BẢN

Dòng quyết định:
- `2026-11-09 17:32:24.119 [YouTube:35999] AppBridge: [do] bw probe seq=29 … kbKnown=1 kbActive=0 kbSrc=owner kbAge=663 state=H wouldSwallow=1 wouldPinch=0 failopen=-`
- `2026-11-09 17:32:24.190 [SpringBoard:35973] AppBridge: [kb-sync] host post com.google.ios.youtube active=1 session=3 source=host-keyboard-session`

Tức cú chạm gọi (wouldSwallow=1, kb known-inactive) xảy ra **71–118 ms TRƯỚC khi phím mở** — cú chạm đó chính là cú chạm mở tìm kiếm, không phải một cú chạm bị chặn khi phím đang mở. Sau đó tồn tại một cửa sổ overlap THẬT (fade lại 17:32:28.079 khi phím còn mở tới 17:32:34.326) nhưng **0 probe / 0 act-posted trong cửa sổ đó** — Nguyen không chạm trong ~6 s phím mở, nên không probe nào có thể cháy. Gõ chữ: 0 dòng nhập liệu toàn phiên. Sau khi phím đóng: 0 probe trên cùng assignment gen=3. Teardown đầy đủ (17:33:38.369).

Kết luận đối hoà: đây là **NO DATA do hành vi phiên, không phải FAIL cơ chế**. Gate 3 còn thiếu đúng 3 mắt: (i) probe khi phím đang mở + controls ẩn; (ii) gõ chữ khi controls ẩn; (iii) probe sau khi đóng phím trên cùng assignment. Kịch bản phiên sau phải ép ba mắt này (chạm MỘT lần vào vùng app trong lúc phím đang mở; gõ vài chữ; đóng phím rồi chạm lại) — các mắt còn lại của chuỗi đã có bằng chứng.

Hồi quy native feed: fired 86 (GOFA 44, Maps 21, VLC 10, SMS 7, Cal 4 — 100% native; lưu ý S2 đếm mục này trên toàn file, chưa tách thế hệ), chuỗi 14/14 khép, 4 fade mồ côi đều do teardown/hết phiên. W2: stateage vượt 2,5 s ở 12/54 ca (max 8.092 ms) — ca phân định hai phiên trước chưa từng có nay đã có số; các quyết định wouldSwallow=1 trong phiên đều ở stateage tươi (không ca nào trong 8 ca dương dựa trên state già) — phần này S2 ghi theo phân bố, GPT đọc biên bản S2 để phán mức.

## §5 ICON YOUTUBE — TRẢ LỜI HAI TẦNG

### Tầng 1 — trong split (mất ~17:41, gọi logo thì hiện lại)

- Tầng source (probe-fade-icon.md): lớp sơn mờ **minh oan** — danh sách sơn đóng (handle/divider/knob/homeButton), icon là cell SBIconView thuộc nhánh dockView, không tổ tiên bị sơn chung; opacity không lan sang nhánh anh em.
- Tầng log: cửa sổ có `17:41:07.153 [autohide] fade last=home idle=4.00` sát mốc mất, nhưng dòng reveal tương ứng `17:41:00.359 reveal-applied reason=activity views=5` **không kéo theo bất kỳ dòng [homelib]/apply/re-layout dock nào** trong log. Theo đúng tiêu chí kết án của biên bản nguồn (có [homelib] remove/không-inject sát mốc thì kết án thư viện; không có thì ghi tầng cell dashboard CHƯA PHÂN ĐỊNH): [homelib] cho youtube trong cửa sổ chỉ có **inject** (`17:42:37.339 decision=inject bundle=com.google.ios.youtube`), toàn phiên dòng remove = 0.
- Kết luận tầng 1: sự trùng thời gian với fade là có thật nhưng **cơ chế không nằm ở lớp sơn** (source minh oan) và log không ghi được sự kiện nào giải thích cả chiều mất lẫn chiều hiện-lại-khi-reveal. Phần hiện lại được ghi là **đang giả định**: dashboard tự layout lại cây dock khi trạng thái hiện/ẩn đổi. → **CHƯA PHÂN ĐỊNH ở tầng hiển thị cell của dashboard; cần instrument riêng nếu GPT muốn đóng mắt này.** (apply-published count=0 không đọc được presence của app injected — SCPHomeApply.m:319–325 — nên đường apply cũng mù với app injected, cùng họ mù với live-grid-read ở ytz3.)

### Tầng 2 — sau thoát Home (mất hẳn ngoài Home)

Phép phân loại A/B áp trên **11 sự kiện thoát trong log** (cặp A/B gốc 17:48 nằm ngoài log — log hết 17:44:31 — nên mắt 17:48 là NO DATA trong log, chỉ có lời Nguyen):
- Lớp ĐÃ MỜ: 5 sự kiện; lớp HIỆN: 6 sự kiện. Sự kiện mất icon 17:44 thuộc lớp ĐÃ MỜ.
- Đối chiếu trường goHome (bổ sung probe-exit-fade): **ĐÃ MỜ ⇒ goHome=NO đủ 5/5**, gồm đúng sự kiện mất icon: `2026-11-09 17:44:20.347 [CarPlay:36168] SplitScreen: CarSplit: tat split (goHome=0)` (fade gần nhất 17:44:00.030). Cả 2 lần goHome=1 toàn phiên đều thuộc lớp HIỆN (`17:35:47.890` và `17:36:03.968`, đều [CarPlay:35998], sát reveal trước đó). Chiều ngược không tuyệt đối: 4/6 lần thoát lớp HIỆN vẫn goHome=0 (thoát bằng sự kiện Home/dismiss khi đang hiện) — nên phát biểu đúng mức là: YES ⇒ đang HIỆN (2/2) và ĐÃ MỜ ⇒ NO (5/5), **0 phản ví dụ ở hai chiều quyết định**.
- Cơ chế khớp (probe-exit-fade, source): đường thoát không quyết định nào đọc trạng thái mờ; khôi phục sơn vắng mặt khỏi đường thoát (chỉ có ở reveal + ngắt kết nối); bất đối xứng tweak-side duy nhất là `SCPSendDashboardEvent(1)` chỉ gửi khi closeGoingHome:YES (SCPCarSplit.m:1771) — đường goHome=NO không gửi. Log khớp cơ chế hạng 1 này.
- Họ thư viện **không bị kết án** ở tầng 2: youtube có **0 chuyển trạng thái 1→0** toàn phiên; decision cuối của phiên vẫn là inject (`17:43:41.217`).
- Kết luận tầng 2 (mức bằng chứng log cho phép): biến quyết định thực tế là **đường thoát** — thoát lúc đã mờ luôn đi đường goHome=NO (hook Home/dismiss của dashboard), đường này bỏ qua cả sự kiện dashboard type 1 lẫn mọi khôi phục; icon mất ngoài Home nằm ở phía dashboard/cell sau đường thoát đó. mắt chưa chứng minh được: bước cụ thể phía dashboard làm rớt cell, và event-1 là nguyên nhân hay chỉ là dấu hiệu của đường đi. **Đang giả định** (một câu, ghi rõ): lúc controls đã mờ, thao tác Home của người dùng chỉ còn chạm được affordance Home của dashboard nên thoát rơi vào đường NO — log không ghi trực tiếp mắt này.
- Phát hiện phụ, KHÔNG kết án là nguyên nhân icon: `ahFadedState` rò sang phiên sau (không reset ở ahSessionStarted; thoát lúc mờ để ahFaded=YES kẹt tới reveal/teardown kế). Khiếm khuyết riêng, bán kính chỉ tới chrome (homeButton/handle, fadedEffective của BridgeWake) — sửa độc lập khi GPT duyệt.

## §6 PHÍM TỰ VẼ — ẢNH 3 LÀ CHE KHUẤT, KHÔNG PHẢI KHUNG MỚI

Giữa mốc ảnh 2 (17:32) và ảnh 3 (17:33) chỉ có MỘT sự kiện ẩn `17:32:34.308 ban phim xe: an (com.google.ios.youtube)` và **0 show mới** (show kế tiếp 17:33:52.718). Theo probe-kb-frame.md (khung panel tính một lần tại show rồi đóng băng, cạnh dưới luôn neo đáy cửa sổ), khung trong ảnh 3 buộc là cùng khung của lần show trước bị một khung ô đè lên che phần lớn (z-order) — **kết án che khuất**, khớp phân tích nguồn. (Khung panel/carAppArea vẫn không có dòng log ghi rect — muốn kết án tầng input của ảnh 2 vẫn cần dòng log rect đã đề xuất ở vòng trước.)

## §7 YTZ — PASS; OFF KHÔNG CÓ DỮ KIỆN PHIÊN NÀY

Ack 51/51 applied w=1 m=0; mask 24 bị chặn 5/5, lọt 0 (mẫu: `2026-11-09 16:36:34.196 [YouTube:35060] AppBridge: bo qua su kien xoay gia: app dang chi cho mask 24`). Revoke-snap đầu tiên đầy đủ: `2026-11-09 17:33:38.370 [SpringBoard:35973] AppBridge: [ytz-revoke-snap] ly do=teardown bundle=com.google.ios.youtube hash=d3b4e0df gen=11 logical=248x428 pub=248x428 box=198x342.667 frame=45,0,198x342.667 reqOrient=0 paneOrient=1 settingsOrient=1 lastDecl=unavailable`. 4 snap không có nextlayout: grant kế tiếp là gen=0 ở SpringBoard pid mới — khớp giới hạn instrument đã khai (nextlayout khoá theo republication). **Đối hoà S4↔S1:** ca thu hồi 16:54:00.206 thiếu snap mà S4 ghi "chưa rõ" được S1 giải thích trọn: mốc đó thuộc binary cũ (trước 17:23:48), binary đó chưa có tag [ytz-revoke-snap] — kỳ vọng vắng, không phải ytz4 làm rơi. OFF control: phiên này Nguyen không tắt pref YTZ (0 ca `ly do=pref`) → NO DATA, khác ytz3 (có OFF 11,121 s đạt).

## §8 LINH TINH + MÂU THUẪN GIỮA CÁC STRAND

- Weather: req# = 0 lần thứ ba liên tiếp; 5 chu kỳ warming-cache updated 5/5 HTTP 200 — `[weather] source=warming-cache (internal startup call, NOT a CarPlay request)`. Chuỗi request→answer→display vẫn PENDING.
- Knob: payload = 0 lần thứ ba liên tiếp; 69 dòng chứa "knob" toàn là sổ fade (applied ×36 / restored ×31). Vẫn cần GPT phán: instrument hay nghiệm thu bằng mắt.
- Scenevis: verify 39/39 khoẻ; 2 dòng sentinel `going-home bundle=?` (17:34:06.367, 17:38:19.133) là mốc hết-phiên không bundle — cấu trúc, không phải bất thường.
- Mâu thuẫn giữa các strand: **không có mâu thuẫn số liệu**. Ba điểm lệch bề mặt đã hoà: (i) snap thiếu 16:54 (S4) ← thế hệ binary (S1); (ii) suspend-at-expand: S1 đếm trong khoảng expanded = 0, S2 đếm kèm act = 0/3 — hai phép đếm độc lập cùng kết quả, đối lại ytz3 13/13; (iii) số feed fired của S2 là toàn file chưa tách thế hệ — verdict feed không đổi vì chuỗi khép được đếm trên từng chuỗi, nhưng con số tuyệt đối 86 không nên so trực tiếp với 41 của ytz3 (phiên đó một thế hệ).

## VIỆC CÒN MỞ (chờ GPT / phiên sau)

1. Gate 3: còn 3 mắt NO DATA của §4 — kịch bản phiên sau ép chạm-trong-lúc-phím-mở + gõ + chạm-sau-đóng cùng assignment. Ngoài 3 mắt đó, mọi điều kiện tiên quyết (kb transport, would dương, feed native, freshness) đều đã có số đạt.
2. Icon tầng 1 + bước dashboard ở tầng 2: cần instrument phía cell/apply cho app injected (apply hiện mù với injected) hoặc chấp nhận mức tương quan đường-thoát hiện có.
3. Pinch: hiệu chuẩn đánh dấu **chưa được thực hiện** phiên này → kiến trúc vẫn chưa quyết được; 101/101 duplicate là mẫu thứ ba liên tiếp toàn trùng.
4. ahFadedState rò phiên: khiếm khuyết riêng đã định danh, chờ duyệt sửa.
5. Weather/knob: NO DATA ba phiên liên tiếp — cần quyết định instrument hay bỏ tiêu chí.
