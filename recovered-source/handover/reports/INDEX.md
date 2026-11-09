# Reports — hồ sơ điều tra / thiết kế / audit (Gate 0)

Các báo cáo nền của dự án OmniCar RE, được cố định lên repo theo yêu cầu GPT để khóa kết luận Gate 0.
Ngày đưa lên: 2026-11-09.

| File | Nội dung |
|---|---|
| `invest-duoface-logo.md` | Điều tra cơ chế nút logo của DuoFace bản đạt QA180: chủ trạng thái host, hook `-[UIApplication sendEvent:]` trong process app, cổng known/hidden/kb, kênh Darwin hidden/shown/query, bằng chứng xe QA177–QA180 và các tiền lệ chết. |
| `invest-ytzoom.md` | Điều tra zoom fullscreen của YouTube: app tuyên bố hướng qua máy VC (mask 24/2), bản đồ hàm OmniCar gốc hai phía (VC hook, hook hình học, appWithHash:, nudgePane:), dòng thời gian một chu kỳ phóng ở iOS gốc và khi bị host. |
| `study-pinch-fullscreen.md` | Nghiên cứu pinch 2 ngón → fullscreen cho OmniCar: ba nghĩa fullscreen, nghi thức solo/zoom gốc nội bộ CarPlayApp, điểm gắn recognizer và xung đột cử chỉ theo nhóm app, đối chiếu saga pinch 21–46 (đóng băng 36/38 chưa xác định). |
| `design-logo-transfer.md` | Thiết kế chuyển cơ chế gọi lại QA180 sang OmniCar: máy trạng thái đầy đủ hai phía, bảng ánh xạ 13 thành phần DuoFace → OmniCar, điểm phát trạng thái tương đương layoutControls, kế hoạch probe chỉ-đọc và các quyết định treo D1–D4. |
| `audit-knob-layer.md` | Truy tĩnh vị trí lớp của gương núm ABKnobView so với bề mặt scene native: khả năng "bị che" bị loại trên giấy — triệu chứng mất hiển thị ở split hỗn hợp quy về lỗi đảo cực publishKnobsNow. |
| `audit-runtime.md` | Gate 0 audit cho work order Bridge Wake QA180 Port: kiểm kê dylib trong DEB r6/r7 và QA19/QA20, bản đồ 5 đối tượng chrome, phân định tranh chấp bằng chứng sendEvent (bản 44), xác minh lại publishKnobsNow trên cả hai slice gốc. |
| `fix-knob-polarity.md` | Biên bản sửa cực publishKnobsNow (`@(!scaled)` → `@(scaled)`): trước/sau, build module SplitScreen, cổng object truy vết IsIdentity → numberWithBool:, bảng test tĩnh identity/non-identity. |
