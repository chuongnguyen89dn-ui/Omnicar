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

Bổ sung vòng wake1 (2026-11-09): hai thiết kế, audit cổng A1, bốn biên bản cài đặt và biên bản tích hợp của vòng Bridge Wake / Pinch (PATCH_NOTES §22).

| File | Nội dung |
|---|---|
| `design-bridgewake.md` | Thiết kế Bridge Wake (QA180 Port) + tầng phân xử Pinch/Wake: chốt Q2/Q3/Q4 của audit, định nghĩa HIDDEN trung thực (hàm tổng hợp mới, bar.isHidden không bao giờ đủ), giao thức bridgewake.v1 (4 kênh Darwin, layout uint64, phân tích collision, 8 test vector), hai mode độc lập, thiết kế ABInApp/ABHost và kế hoạch cài đặt theo file. |
| `design-pinch.md` | Thiết kế phần A Pinch Fullscreen: điểm gắn recognizer custom trên SCPCarSplitView (không giữ cặp, cấu hình NO bắt buộc), nhận diện phiên/scene/allowlist theo (bundle, loại scene), máy nhận dạng + 5 cổng phát lệnh, giao diện adapter SCPFullscreenControlling, đường thoát EXPANDED và khoá cứng A6, probe Gate 2. |
| `a1-fullscreen-entry.md` | Audit cổng số một của Pinch trên dylib fullscreen QA20 (MD5 `944d6f37…`): kết luận **FULLSCREEN_ENTRY = BLOCKED** — OMCToggleHost static một điểm gọi nội bộ, action chỉ tồn tại sau khi mở menu, kênh chrome một chiều không phải kênh lệnh, không đường đọc expanded; điều kiện mở lại cổng. |
| `impl-carplay.md` | Biên bản cài đặt Wake phía CarPlay: owner + phân xử trong SCPCarSplit+BridgeWake.m (521 dòng), BridgeWakePack.h của module, các điểm gọi recompute, cổng tĩnh §7.1 và harness test vector 19/19; 8 quyết định diễn giải (gồm assigned gồm self.active, wake ở VISIBLE ack ngay). |
| `impl-abhost.md` | Biên bản cài đặt Wake phía ABHost: accessor bwAppliedSnapshotForBundle:, ô chờ xác nhận + ack role=1 exactly-once trong ABChannels.m, cổng §7.2 (thân 4 hàm áp frame/host-bar khớp SHA-256 trước/sau, diff thêm thuần); điểm lệch handler sống ở ABHostGeometry + giải pháp observer/hop. |
| `impl-abapp.md` | Biên bản cài đặt Wake phía ABInApp: hook sendEvent lười, state client, probe gộp wouldSwallow/wouldPinch, suppression engine + keyboard guard trong ABInApp.m (585 → 1.132 dòng, 8 điểm chạm), cổng tĩnh §7.3, harness codec 17/17; luật targetVerified chặt chờ Gate 2 phán. |
| `impl-pinch.md` | Biên bản cài đặt Pinch: SCPPinchController + SCPFullscreenAdapter (adapter thân rỗng là trạng thái cuối vì A1 BLOCKED, ENFORCE tự khoá), recognizer quan sát-không-giữ-cặp, 5 cổng phát lệnh, probe [pinch1]; bốn lệch L1–L4 và điểm keo để lại cho tích hợp. |
| `integration-wake1.md` | Biên bản tích hợp wake1: keo pinch (Makefile, seam SCPHooks, 2 dòng SCPCarSplit, arbiter phía owner, externalChainSuppressed suy từ giao dịch WAKING), chuẩn hoá BridgeWakePack.h lệch API về bản SplitScreen (harness cuối 38/38), candidate local + toàn bộ bảng Gate 1 trên DEB đã bung, 5 câu hỏi runtime để lại cho Gate 2. |
