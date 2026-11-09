# PROBE-KB-FRAME — Bàn phím tự vẽ ABKeyboard: đường hosting + khung panel bị bó (ảnh 3, phiên ytz4)

Điều tra chỉ-đọc, 09/11/2026. Nguồn: `src/AppBridgeB/`, `src/SplitScreenA/B/` (bản recovered-source, khớp bản build), diff git `36135b8..237098c` trong push9-clone. Dữ kiện xe: 3 ảnh 17:32–17:33, YouTube hosted (ô trái) đang tìm kiếm — ảnh 1 panel lớn gần kín màn; ảnh 2 panel nhỏ gọn góc dưới-phải của ô phải; ảnh 3 panel bị bó ~1/4 diện tích, lọt giữa vùng trống ô phải.

## A. CÂU HỎI CHÍNH — ABKeyboard thuộc đường hosting nào

**(a) Một đường duy nhất cho mọi app hosted — solo hay chia ô đều qua ABKeyboard của ABHost. SCPCarSplit không có đường bàn phím riêng.**
Chuỗi đầy đủ: app có first responder → `ABKeyboardPublish` (ABInApp.m:1782–1799) phát Darwin `appbridge.keyboard` (notify `ABNotifyKeyboard`, gói `shown | keyboardType<<1 | returnKeyType<<8 | FNV1a(bundleID)<<24`) → `ABKeyboardDispatch` (ABHostGeometry.m:209–235) giải mã hash → `-[ABKeyboard showForApp:keyboardType:returnType:]` (ABKeyboard.m:277) → panel dựng trong cửa sổ xe của ABHost.
Grep toàn bộ SplitScreenA/B/C: không inputView, không panel, không show/hide phím. SplitScreen chỉ *tiêu thụ trạng thái* phím cho hai việc khác: AutoHide kb-hold đọc cờ trong gói act (SCPCarSplit+AutoHide.m:248) và BridgeWake kb-sync — đồng bộ trạng thái cho cổng wake, không trình bày phím (SCPCarSplit+BridgeWake.m:77–99, 295–330).
App **native** trong ô thì không có ABInApp bên trong → không bao giờ publish → dùng phím hệ thống trong scene của chính nó (đã chứng minh ở phiên ytz3, kết án H2). Không cơ chế nào của SCPCarSplit/ABHost đụng vào phím của app native.

**(b) Phía app (ABInApp): KHÔNG rẽ nhánh theo split trên đường phím.**
- `ABSuppressSystemKeyboard` (ABInApp.m:1718–1726) — chèn inputView trắng zero-size để phím hệ thống không hiện: điều kiện duy nhất là `ABForcedOrientation < 1` (app đang được host hay đã bị thả). Không biến split nào.
- Các hook become/resign (ABInApp.m:1753–1773) gọi thẳng suppress/publish; `ABKeyboardPublish` (ABInApp.m:1782–1799) không mang trường split, không mang trường hình học nào.
- Tri thức split duy nhất trong ABInApp thuộc nhánh orientation YTZ: `YZLeaseIsSplit` (ABInApp.m:937), nạp từ lease info (ABInApp.m:1306–1321), dùng ở re-read 0,12 s (ABInApp.m:1135–1142) — đường phím không đọc nó. (Cặp `split`/`splitver` trong hostFrameInfo do ABHost tiêu thụ cho YZ/isSplit, không chảy vào quyết định phím của app.)

**(c) Khi split đang bật, khung panel tính theo VÙNG APP TOÀN XE — không theo ô. Panel nằm nửa phải: không có đường code theo thiết kế.**
`layoutPanelIn:` (ABKeyboard.m:561–576) chỉ đọc `[ABHost shared].carAppArea` — một biến toàn cục phía host. Giá trị của nó do owner gửi trong mọi gói hostFrameInfo: `ax/ay/aw/ah = [tabParent convertRect:[self appAreaInParent:tabParent] toView:nil]` (SCPCarSplit.m:2146–2154), trong đó `appAreaInParent:` (SCPCarSplit+Layout.m:409; R = content.bounds của dashboard đổi sang parent tại :433) là **toàn bộ vùng content của dashboard — cả hai ô** — và giống hệt nhau trong gói của mọi ô. Công thức panel không chứa số hạng nào của ô (không frame ô, không slot, không divider). Hệ quả: x của panel chỉ có thể lớn khi chính `carAppArea` tại thời điểm show đã là rect lệch phải/nhỏ — xem mục 1 và 4.

## 1. Khung panel tính từ đâu tại thời điểm show — mọi nguồn số

**Container:** `showForApp:` lấy `carWindow = [ABHost shared].carWindow` (ABKeyboard.m:278) và gọi `[self layoutPanelIn:carWindow]` (ABKeyboard.m:295). carWindow là UIRootSceneWindow trên CADisplay của CarPlay, tạo một lần bởi `-ensureWindow` (ABHostBMethods.m:950–999; `carWindow` tại :1004–1007) → bounds = toàn bộ màn hình xe.

**Công thức** (`layoutPanelIn:`, ABKeyboard.m:561–576):
- `bounds = container.bounds` (:562); `area = [ABHost shared].carAppArea` (:563).
- `rect = bounds`; chỉ khi `area.width > 100` mới `rect = CGRectIntersection(area, bounds)` (:565); rect rỗng → quay về `bounds` (:566).
- `panelW = MAX(rect.width − 12, 200)` (:567) — **sàn cứng 200 pt**.
- `panelH = MIN(floor(bounds.height × 0.78), 280)` (:568) — chiều cao CHỈ từ chiều cao cửa sổ, không từ rect/area.
- `x = MIN(MAX(rect.minX + 6, 0), bounds.width − panelW)` (:569); `y = bounds.maxY − panelH − 6` (:570) — **neo đáy cửa sổ tuyệt đối**; gán frame :571.

**carAppArea:** đúng 2 điểm ghi, cả hai từ gói hostFrameInfo của owner, chỉ khi `aw > 0`: ABFrameBlock (ABHostGeometry.m:303–306) và ABOpenBlock (ABHostGeometry.m:359–363). Phía owner, nếu `tabParent` nil thì gói không mang ax..ah (SCPCarSplit.m:2147) → ABHost giữ giá trị cũ (stale theo thiết kế gốc). Không ai khác ghi biến này (grep toàn AppBridgeB).

**Đóng băng tại show:** `layoutPanelIn:` có đúng MỘT điểm gọi (ABKeyboard.m:295). Không có relayout khi frame/area đổi sau show — panel giữ hình học của thời điểm show cho tới lần show kế tiếp.

**Điểm nào sinh được khung nhỏ lệch phải như ảnh 3:** chỉ hai cửa, đều qua rect —
(i) `rect.width ≤ 212` → panelW bị kẹp ở sàn 200 (ABKeyboard.m:567);
(ii) `rect.minX` lớn → x lớn (ABKeyboard.m:569).
Cả hai đồng nghĩa carAppArea tại thời điểm show là một rect nhỏ/lệch phải. Ngược lại, **chiều cao nhỏ không có đường nào sinh**: panelH luôn ≥ min(0,78 × chiều cao cửa sổ, 280). Phần "lọt giữa" theo chiều dọc của ảnh 3 cũng không có công thức nào tạo ra (y luôn neo đáy). Hai cơ chế phụ đã rà: transform trượt-mở của fresh show chỉ tịnh tiến panel XUỐNG (ABKeyboard.m:300–307) — loại; che khuất z-order thì có bằng chứng code: panel chỉ được `bringSubviewToFront:` tại show (ABKeyboard.m:296), trong khi ABHost đưa `pane.box` lên trước cửa sổ ở đường setFront/layout (ABHostBMethods.m:1441) — một box cộng/nâng SAU khi phím hiện có thể che phần dưới panel, phần còn lộ trông như rect nhỏ lơ lửng giữa ô.

## 2. Ba trạng thái ảnh ↔ điều kiện hình học trong code

- **Ảnh 1 (panel gần kín bề ngang, neo đáy): ĐÚNG THIẾT KẾ.** carAppArea = toàn vùng app (solo hay split đều cho cùng một appArea — mục A.c), panelW = area.width − 12, panelH = min(0,78 × H cửa sổ, 280). Nhánh fallback rect = bounds (area chưa có, width ≤ 100, hoặc giao rỗng — ABKeyboard.m:565–566) cho cùng hình này.
- **Ảnh 2 (panel gọn, góc dưới-phải của ô): KHÔNG có đường thiết kế.** Muốn vậy phải có carAppArea tại lúc show = rect cỡ một ô, lệch phải: panelW = rect.width − 12, x = rect.minX + 6, còn y vẫn neo đáy cửa sổ nên trùng với đáy ô về mặt thị giác.
- **Ảnh 3 (bó nhỏ, lọt giữa ô phải): cùng họ input sai như ảnh 2, mức nặng hơn.** Bề rộng chạm sàn 200 (rect.width ≤ 212). Riêng thành phần "lơ lửng giữa ô" theo chiều dọc thì code frame không tạo được — chỉ giải thích được bằng che khuất z-order sau show (mục 1) hoặc bounds cửa sổ tại lúc layout khác kích thước hiển thị thật. Không tồn tại trạng thái layout nào trong code đặt panel lưng chừng theo chiều dọc.

## 3. Log sẵn có ghi khung lúc show + delta hình học của ytz4

**Khẳng định nền (đã grep toàn AppBridgeB + SplitScreen): KHÔNG có dòng log nào ghi rect của panel hay giá trị carAppArea.** Các dòng liên quan, nguyên văn + vị trí:
- Host lúc show: `ban phim xe: hien cho %@ (kieu %ld, phim enter %ld)` (ABKeyboard.m:309–311) — chỉ bundle/loại phím/phím enter, **không rect**.
- Host lúc ẩn/lỗi: `ban phim xe: an (%@)` (ABKeyboard.m:326); `ban phim xe: khong co cua so (%@)` (ABKeyboard.m:279); `ban phim xe: loi phim %@` (ABKeyboard.m:429); `ban phim: khong co o cho hash %llu` (ABHostGeometry.m:215); `ban phim loi %@` (ABHostGeometry.m:231).
- Phía app lúc publish: `ban phim xe: hien (%@)` / `ban phim xe: an (%@)` — %@ là tên class của responder (ABInApp.m:1796–1798).
- [kb-sync] của ytz4 — chỉ mang bundle/active/session, không hình học: host post `[kb-sync] host post %@ active=%d session=%u source=host-keyboard-session` (ABHostGeometry.m:95–97); owner emit `[kb-sync] emit %@ gen=%u seq=%u known=%d active=%d source=host-keyboard-session` (SCPCarSplit+BridgeWake.m:201–204); owner change `[kb-sync] change %@ known=1 active=%d session=%u source=host-keyboard-session` (SCPCarSplit+BridgeWake.m:327–330); dòng probe phía app in `kbKnown/kbActive/kbSrc/kbAge` (ABInApp.m:681–694, 744–750).
- Rect log gần nhất, dùng làm mốc đối chiếu gián tiếp: `cua so tren man xe %@ (%@)` với `NSStringFromCGRect(win.bounds)` — bounds cửa sổ ABHost, ghi lúc tạo cửa sổ (ABHostBMethods.m:996–997); phía owner: `AppBridge: %@ toan man %@` — frame khi đưa app lên toàn màn (SCPCarSplit.m:2022), không phải rect phím.

**ytz4 có đổi hình học bàn phím không: KHÔNG, ở bất kỳ điểm nào** (git diff `36135b8..237098c`, push9-clone):
- `ABKeyboard.m`: **0 dòng thay đổi** — `layoutPanelIn:`/`showForApp:` nguyên vẹn.
- `ABHostGeometry.m`: 4 hunk, toàn bộ là kb-sync (khối ABKbSync* mới; `ABKeyboardDispatch` cộng 2 lời gọi `ABKbSyncNoteEvent`; `ABCarPlayChanged` cộng sync khi force-hide; `ABOpenBlock` cộng `ABKbSyncSnapshotForApp`) — không hunk nào chạm ABFrameBlock/carAppArea.
- `ABInApp.m`: các hunk nằm ở BridgeWake/kb-guard (gồm `BWKbLocalSet` trong ABResponderBecame/Resigned); `ABSuppressSystemKeyboard` và `ABKeyboardPublish` không đổi, và ABInApp vốn không chứa số hình học nào (gói publish không có trường rect).

## 4. Kết luận xếp hạng + cách phân định khi có log ytz4

**Xếp hạng 1 (khả nghi nhất): carAppArea tại thời điểm show là rect nhỏ/lệch phải.** Hai đường con: (a) *tạm thời* — owner đẩy frame liên tục qua `pushHostFramesLive:` (SCPCarSplit.m:2246) trong các chuyển trạng thái (kích hoạt split, expand/restore FS, kéo divider, gán lại ô); một gói chụp giữa chuyển động có thể mang appArea chưa ổn định, và vì panel đóng băng tại show (mục 1) nên sai lệch giữ nguyên suốt phiên phím; (b) *stale* — giá trị từ trạng thái hosting trước không được làm mới vì gói thiếu tabParent thì không mang ax..ah (SCPCarSplit.m:2147) và ABHost chỉ ghi khi `aw > 0` (ABHostGeometry.m:303).
**Xếp hạng 2 (chỉ cho thành phần "lơ lửng" của ảnh 3): che khuất z-order sau show** — pane.box của ô phải được cộng/nâng lên trước panel trong cùng cửa sổ ABHost (ABHostBMethods.m:1441 đối lại ABKeyboard.m:296).
**Loại trừ:** chiều cao panel bị bó bởi công thức (không thể — ABKeyboard.m:568); panel tự đổi khung giữa phiên (không thể — một điểm gọi layout duy nhất); ytz4 gây ra (không — mục 3).

**Phân định bằng log phiên ytz4 khi được up:**
1. Đếm cặp `ban phim xe: hien` (app, ABInApp.m:1796) → `ban phim xe: hien cho` (host, ABKeyboard.m:310) và các lần `an` ở giữa: ảnh 2 và ảnh 3 cách nhau ~1 phút — **nếu giữa hai ảnh không có hide/show mới, khung không thể tự thay đổi** → ảnh 3 buộc phải là cùng khung với ảnh 2 bị che khuất (xếp hạng 2 thắng); nếu có show mới, đối chiếu sự kiện layout ngay trước show đó (xếp hạng 1).
2. Ngay trước mỗi `hien cho`: có sự kiện kích hoạt split / expand / restore / kéo divider / gán ô / `toan man` (SCPCarSplit.m:2022) không → phân biệt 1(a) tạm thời với 1(b) stale (stale = show xảy ra sau một khoảng dài không có gói frame nào mang ax..ah).
3. Có dòng `cua so tren man xe` xuất hiện lại giữa phiên không → cửa sổ ABHost bị tạo lại với bounds khác (giải thích được cả chiều dọc).
4. Sau `hien cho` có sự kiện open/frame của ô PHẢI không → củng cố nghi vấn che khuất cho ảnh 3.
