# CÁC VẤN ĐỀ CHƯA GIẢI QUYẾT — CẦN GPT HỖ TRỢ / PHÁN QUYẾT

Ngày: 2026-11-09. Người viết: Muse (bên triển khai). Người test duy nhất: Nguyen.
Trạng thái bản: QA20 (của GPT) vẫn là bản dùng hằng ngày. Bản rebuilt đang test trên xe: **fs1 FAT** (SHA-256 `41bb5b8b…`, commit nguồn `5427920`) — phiên nghiệm thu gộp đang chạy, **LOG CHƯA VỀ**.
Lệnh Nguyen 14:39 hôm nay: mọi sửa tiếp theo gom vào **MỘT deb duy nhất**, không giao bản lẻ.

Quy ước bằng chứng: [XE] = Nguyen đã thấy trên xe · [LOG] = có trong log đã đọc · [TĨNH] = kiểm chứng tĩnh trên binary/source · [GIẢ THUYẾT] = chưa có bằng chứng.

## 1. Gọi lại controls sau khi mờ — GÃY TRÊN XE (vấn đề lớn nhất hiện tại)

**Hiện tượng [XE — Nguyen báo 14:39 khi test fs1]:** AutoHide mờ được toàn bộ controls kể cả logo sau idle. Nhưng chạm vào nội dung app **không** gọi controls hiện lại — phải bấm trúng đúng vị trí nút logo vô hình mới hiện.

**Đã có:** 4 đường activity — F1 hitTest của container (phía CarPlay), F2 callback handle/núm từ phía host, F3 `homeButtonTapped`, F4 gói `act` từ hook `sendEvent` trong ABInApp (chỉ phát khi `BWFresh()` = bản sao state bridgewake còn tươi ≤ 2,5 s). Owner nhận act tại `bwHandleActPacket:` → `ahNoteActivity:` → reveal (khôi phục opacity + đẩy `fade=NO` xuống gương host).

**Quan sát cấu trúc [XE + tiền lệ]:** OmniCar chạy app hosted **không có lớp phủ phía host như DuoFace** — chạm nội dung đi thẳng vào process app, host không thấy (Nguyen chỉ rõ khi báo cáo). F3 sống (chạm trúng logo thì hiện) chứng minh reveal và hit-target-khi-mờ đều nguyên; điểm gãy nằm ở đường activity từ chạm nội dung.

**Giả thuyết — chờ LOG phiên fs1 kết án:**
- (a) F4 bị cổng `BWFresh()` chặn: state chỉ phát khi có thay đổi hoặc bị query, nên lúc đang mờ phía app giữ state cũ → act không bao giờ được phát cho chính cú chạm cần reveal. [GIẢ THUYẾT — nghi nhất]
- (b) Act được phát nhưng owner loại vì hash/gen/điều kiện còn-hosted. [GIẢ THUYẾT]
- (c) F1 không bắn cho bề mặt Nguyen đã chạm (ô native / vùng ngoài container). [GIẢ THUYẾT]

**Cần GPT:**
1. Phán mức sửa sau khi Muse phân tích log: nới cổng phát act (bỏ điều kiện tươi / thêm heartbeat state) hay phải đổi kiến trúc.
2. Phán về lớp phủ: DuoFace bắt chạm đầu nhờ lớp phủ + relay trong app. Phía OmniCar, tiền lệ QA176 (chặn bề mặt phía SpringBoard) đã FAIL vì chạm scene đi thẳng vào app — có hướng lớp phủ nào khả thi trên stack AppBridge không, hay xác nhận đường trong-app là đường duy nhất.
3. ENFORCE (nuốt chạm đầu — ngữ nghĩa QA180) **chưa từng có bằng chứng xe** trên stack này: máy nuốt ở ABInApp mới chạy DRY_RUN. Cần GPT nêu điều kiện tiên quyết để mở Gate 3 sau khi reveal chạy được.

## 2. Pinch fullscreen — đã nối sống theo lệnh Nguyen, còn hai ẩn số

**Quyết định đã thực thi:** Nguyen **bỏ staging** (không công tắc test, không nghiệm thu controller trước) — pinch là cò kích hoạt đầu tiên của `SCPFullscreenController`; pinch mặc định ENFORCE, allowlist vắng = mọi ô. Việc này thay thế quy tắc staging trong WO — cần GPT ghi nhận/supersede.

**Ẩn số 1 — chờ LOG:** recognizer đặt trên container phía CarPlay; cặp hai ngón trên ô **hosted** có tới được recognizer không (chạm hosted đi đường scene vào thẳng app). Probe Gate 2 trong log fs1 đo đúng điều này (wouldPinch theo từng ô). Nếu không tới: pinch chỉ sống trên ô native và bề mặt CarPlay → cần GPT phán điểm đặt recognizer (trong-app như các bản saga từng chạy được pinch 21–35, hay giữ container).

**Ẩn số 2:** controller chưa có bằng chứng xe nào; ma trận crash (10 chu kỳ phình/phục hồi, ngắt CarPlay giữa EXPANDED, app chết giữa EXPANDED, đổi app trong fullscreen) chưa chạy. Cần GPT định ngưỡng bằng chứng tối thiểu ở phiên pinch đầu tiên để quyết giữ hay lùi về staging.

## 3. YouTube zoom (YTZ) — đã cài xong, chưa có bằng chứng xe

**Cơ chế [TĨNH]:** ảo hoá hướng theo kết luận điều tra DuoFace, cài clean-room — lease NSDistributed `appbridge.ytlease` (TTL 3 s, heartbeat 1 s) + ghim portrait tại `appWithHash:`/`layoutPane:`/`nudgePane:` + 6 điểm chặn trong ABInApp + relay đặt lại cửa sổ theo lease. Mặc định BẬT theo lệnh bỏ công tắc của Nguyen; pref `youtubeVirtualize` chỉ còn vai trò kill-switch. Tài liệu: `design-ytzoom.md`, `invest-duoface-ytzoom.md`.

**Rủi ro đã ghi trong thiết kế:** player có thể đọc hướng từ bề mặt ngoài bộ 6 điểm chặn (YouTube là binary đóng, không đọc tĩnh được) — chỉ log xe mới kết án được; ack `applied` (số cửa sổ + mismatch) là phép đo đã thiết kế sẵn cho phiên đầu.

**Cần GPT:** duyệt các điểm diễn giải trong `design-ytzoom.md` §10, và chuẩn bị phán thang leo theo kết quả phiên đo: (a) thêm điểm `statusBarOrientation` / biến attemptRotation thành điểm tiêu thụ; (b) chế độ host-đơn-độc (hết lộn nhưng không nở lấp); (c) đóng track.

## 4. Weather fixround7 — chờ nghiệm thu

[TĨNH xong — XE chưa] Cụm sửa W1–W8 đã ship từ fixround7, nằm trong FAT fs1 đang test. Tiêu chí nghiệm thu bắt buộc của GPT (perm = 0 → nhánh fallback, không kẹt in-flight, request sau chạy được; mọi nhánh kết thúc đúng một lần) nằm trong kịch bản phiên gộp đang chạy. **Mở thêm:** bản sao weather phía Prefs (`OMCCommon.m`) chưa từng được audit theo cụm W — cần GPT phán có mở audit này không.

## 5. Núm divider — sửa cực đã ship, chờ xe kết án

[TĨNH] `publishKnobsNow` đảo cực đã sửa, đo trên FAT: đúng 1 `eor` ở cả hai lát, payload = `!IsIdentity`. Kiểm xe (chấm về kích thước thường, chạm gần vạch vào được app) nằm trong phiên fs1. Nếu vẫn lỗi: hai giả thuyết che khuất/z-order đã bị loại ở mức tĩnh trong `audit-knob-layer.md` — cần GPT cho giả thuyết mới từ log/ảnh phiên này.

## 6. Việc nhỏ / đang đỗ

- **VISUAL_ORIGINAL_COMPARISON** (bản gốc 1.0.3 có lộn hình YouTube như bản rebuilt không) vẫn PENDING — cần footage deb gốc cùng kịch bản. Nếu YTZ thay hẳn hành vi này, GPT phán đóng hay giữ.
- **ahForgetView:** khe hở lý thuyết khi `removeHomeButton` chạy giữa lúc đang mờ (không có method gỡ bản lưu opacity theo view). Đã đánh giá rủi ro thực tế gần 0 (bản lưu chết theo view, registry yếu, nút luôn tạo lại qua đường có áp-lại sơn). GPT phán làm hay bỏ hẳn.
- **playIntro phía xe:** 3 ô ivar chưa map (`0xcb0/0xcc0/0xcc8`, nhánh không tới được sau reload thường) + `SSSplash contentView.userInteractionEnabled` [INFERRED] — đang đỗ.
- **Comment tồn dư** trong SCPPinchController còn mô tả adapter thời A1-BLOCKED — code đúng, chữ cũ; chờ một vòng dọn.
- **DuoFace — phần bản đồ:** phép đo calibration audit2 (ON → OFF → ON, mỗi pha một lần mở Maps) vẫn chờ một phiên riêng. Dự án riêng, không thuộc deb này.

## 7. Khung làm việc tiếp (để GPT xác nhận)

- **Một deb duy nhất** chứa: pinch sống (mục 2) + YTZ (mục 3) + sửa reveal (mục 1) + mọi sửa rút ra từ log fs1. Không giao bản lẻ nữa.
- Log phiên fs1 là đầu vào quyết định cho các mục 1, 2, 4, 5: Muse phân tích và báo cáo số liệu trước, GPT phán trên bằng chứng đó.
- Kiến trúc/tiêu chí nghiệm thu do GPT quyết; Muse triển khai; Nguyen là người test xe duy nhất.
