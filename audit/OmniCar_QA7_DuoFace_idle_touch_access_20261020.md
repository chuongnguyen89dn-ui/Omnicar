# QA7 OmniCar ↔ DuoFace v12 — ẩn nút, phục hồi chạm và khả năng mở menu

Ngày 2026-10-20. **So sánh chỉ đọc từ GitHub và disassembly nguyên bản. Không sửa mã chạy, không xây DEB, không thay nguồn Sileo.**

## Mới từ kiểm thử thiết bị người dùng

QA7 mở OmniCar và chia 2 bản đồ được; các nút biến mất khi hết giờ nhưng **rất khó gọi lại**, bấm menu bản đồ hầu như không phản hồi. Chạm một lần đôi khi mở **menu Zoom/Swap** ở divider thay vì menu của ô bản đồ. Trên YouTube, nút không biến mất nên dễ sử dụng hơn; đồng thời YouTube có lỗi hiển thị/fit riêng.

## Đối chiếu chính xác trên mã QA7

Đã lấy trực tiếp blob GitHub ngày 20/10 và kiểm tra tự động trong lượt này (các chuỗi cần thiết đều hiện diện):
- `idle/src/OmniCarIdleControls.xm` Git blob `20f8bd5aa99d72453ec5f0c0839c8e0410ef3827`: `OMCIdleApply` áp `layer.opacity=0.0f` cho **hai đối tượng độc lập**: `SCPCarPane.handle` (nút ba chấm menu mỗi ô) và `SCPCarDividerView.knob` (nút tròn divider).
- `OMCIdlePaintControl` cố tình **giữ UIView.userInteractionEnabled, hidden, alpha, frame và native gesture**. Vì thế khi nút nhìn như đã mất, vùng hit-test ban đầu vẫn có thể được nhấn; không có quy tắc «lần chạm đầu chỉ hiện nút» tại bản thân target.
- `OMCIdleWakeGesture.touchesBegan`: `OMCIdleWake(split)` rồi `UIGestureRecognizerStateFailed`; `cancelsTouchesInView=NO`, `delaysTouchesBegan=NO`; gắn vào `SCPCarSplit.container`, điều kiện thêm `tabParent` chỉ nếu cùng cửa sổ. **Không đảm bảo** mọi touch bên trong scene/hosted window đi qua gesture này, nhất là nội dung map/YouTube.
- `SCPCarSplit.hideRatioMenu` đang hook sang `OMCIdleHideWithNativeMenu` làm **cả ba chấm và knob biến mất ngay sau khi native ratioMenu đóng**, ngoài timer 4 giây. Sự tương tác/ưu tiên của callback trên máy cần log để xác nhận.
- `src/OmniCarDoubleTapFullscreen.xm` Git blob `93d8fa2e912029e33391e9834f07463bef39d037`: `showRatioMenuForDivider:` mở native ratio menu rồi thay nội dung bằng cover và hai nút **Zoom/Swap**. Đây là *menu của knob trên divider*, **KHÔNG phải** menu theo `SCPCarPane.handle`. Không có bằng chứng source rằng cover của Zoom/Swap đè lên handle của bản đồ khi menu chưa hiện.

## So sánh native DuoFace (tham chiếu READ ONLY, KHÔNG nối class DuoFace vào OmniCar)

- File `audit/duoface-idle-controls/DuoFace_v12_native_idle_and_control_owner.txt` (blob `f1960191d1a490e34c8f351c6079dc6f5cbd5c54`) từ DuoFaceDashboard v12, SHA `bc1df854ec7a2ddfeec4cb81b080ead34b54df80143d4a8f6254bb8b618003ce`: `CBBridgedUIAppView.touchesBegan:withEvent:` (0xaca6c) gọi `CBBridgeManager.currentApp.noteUserActivity` khi có selector (0xacae8–0xacb2c). Như vậy **tương tác tại view của chính ứng dụng host** được đưa về chủ sở hữu split; không chỉ phụ thuộc một gesture trên container.
- `CBBridgedSplitApp.noteUserActivity` (0x10c378) kiểm main-thread, `CACurrentMediaTime`, bỏ báo hoạt động lặp cách nhau ít hơn **0,25 giây** (0x10c3d8) và gọi `startBlinkingSession` (0x10c3ec–0x10c400). `_lastActivityTime` và `_blinkingIdleTimer` tồn tại; `startBlinkingSession` vận hành các `slotPills`/các thành phần độc lập, `stopBlinkingSession` có vòng dừng `stopBlinking`. **Thời lượng tự ẩn cụ thể DuoFace v12 chưa được xác minh**, không tự gán 4 giây.
- DuoFace `audit/v12-split-pill-button-chain-20261014.txt` blob `9179adc463bd7171902db62b9d3850c7538c5382`: `CBSlotPillHitButton` (0x845c0), `onPillTapped` (0x8551c), `onExpandTapped`, `onRestoreTapped`, `noteUserActivity`. DuoFace tách vùng nhận chạm/dispatch của nút khỏi đồng bộ activity. `CBWindow.multitaskingPill` là chủ UI menu SOLO khác với split.
- Kết luận chắc chắn: **hai mô hình hoạt động khác nhau**. DuoFace có chủ activity ở app-host và các nút riêng; Omni QA7 chỉ phục hồi trên container/tabParent và làm nút gốc trong suốt nhưng vẫn nhấn được. Việc nguyên nhân chính xác của một lần nhấn hụt trên map thuộc hit-test, window remote hay timer vẫn **cần log thiết bị**, không tuyên bố đã đo.

## Phân tích hiện tượng và quyết định cải tiến

1. **Đã xác minh theo source:** biến nút về opacity=0 nhưng giữ hit target → ẩn thị giác, **không ẩn hành động**. Nếu người dùng chạm vị trí knob vô hình, hệ thống vẫn có thể mở Zoom/Swap ngay lần chạm đầu. Đây là lỗi thiết kế UX gây khó tìm menu, không nhất thiết là lỗi chuyển lệnh menu.
2. **Rủi ro đã được chứng minh thiết bị:** phương pháp QA6 quét `hostedPanes`, `hostHandle`, `homeButton` gây OmniCar văng khi mở và mất divider. **Cấm tái sử dụng QA6**.
3. **Hướng sửa tối thiểu cần phát triển:** một owner điều phối activity riêng cho split-pane, có báo chạm hợp lệ từ đúng view; bảo đảm **chạm khi ẩn = phục hồi rõ ràng, không vô tình kích hoạt Zoom/Swap**, sau đó nhấn ba chấm mở menu pane. Cần tìm và mở rộng vùng bấm thông qua *native owner-specific hit button* sau khi đo rect hiện tại; tuyệt đối không che lên CarPlay dock, không tạo `UIWindow` overlay chung.
4. **Không sửa trực tiếp `userInteractionEnabled` khi nút ẩn** vì có thể phá native divider pan/handle và chạm trên scene host mà không nhận được sự kiện phục hồi. Không sửa lớp bố cục YouTube để chữa lỗi menu.
5. **Bằng chứng cần trước QA sửa:** ghi event trước/sau `handleTapped:` (0x253e4), `dividerTapped:` (0x2eb64), `showRatioMenuForDivider:`, `hideRatioMenu`, trạng thái `OMCIdleWake`, hit-tested view/frame/window cho **một lần bấm khi ẩn** trên bản đồ và một lần trên YouTube. Kiểm thực tế trình tự đầu tiên chạm làm hiện, lần sau mở **đúng menu**; kiểm Zoom/Swap riêng.
6. **Tiêu chí đạt:** các nút thực sự ẩn sau thời gian chờ; chạm 1 lần có vùng phục hồi dễ nhìn và predictable; ba chấm mở menu đúng ngay khi hiển thị; nút chia mở đúng Zoom/Swap; không mất divider, không crash, map+map, YouTube+map, kéo tỉ lệ, Zoom/Swap và CarPlay dock không hồi quy.

**Trạng thái:** chỉ đọc / đã kiểm tra mã nguồn, chưa viết bản sửa thực thi; QA7 trên Sileo là mốc khôi phục đang hoạt động, không đụng vào DuoFace.