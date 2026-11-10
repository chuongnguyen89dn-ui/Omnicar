# QUÉT SÂU PHẦN 1.0.5 MÀ 1.0.3 KHÔNG CÓ — MỤC LỤC

Quét 2026-11-10 (chỉ đọc, không chạy binary). Tổng quan so sánh ở
[../OMNICAR_1.0.5_SO_VOI_1.0.3.md](../OMNICAR_1.0.5_SO_VOI_1.0.3.md);
thư mục này là dữ liệu đào sâu + kho thô của đúng phần mới.

| File | Nội dung |
|---|---|
| [license.md](license.md) | Hồ sơ đầy đủ hệ bản quyền online: giao thức máy chủ (phong bì ký ECDSA P-256, không có path endpoint — POST gốc + trường JSON), giờ tin cậy qua apple.com, từ điển trường + 9 mã lỗi, trial 1 ngày do server giữ dấu theo UDID, ân hạn offline (cờ stale/cached, trạng thái GRACE — thời lượng không khôi phục được từ strings), điểm gác "(4.1)" trong từng module, định danh thiết bị, 2 controller Prefs (method/ivar), đầu mối mua (Zalo/Facebook/gmail, 99.000đ, key OMC- + 8 nhóm 4), phụ lục 71 khóa chữ EN/VI. Phát hiện thêm: cả 5 dylib ghim SHA-256 của `PackageIcon.png` + `logo@3x.png` (đã kiểm chứng khớp) — lớp tự kiểm tra toàn vẹn bundle Cài đặt. |
| [features.md](features.md) | 52 điểm [BẰNG CHỨNG]/[SUY RA]: tùy chọn từng app (cấu trúc `appBridgeAppOptions` = {zoom, orientation, phoneUI}, 7 khóa chữ, badge), ABWakeView/SCPCWakeView + cổng màn chào, tự-gác-crash hook chống trắng màn theo build stamp, assertion giữ màn xe sáng; 4 bố cục dọc mới + lưới Home + policy evaluator/declaration giả + nhận diện jailbreak 15 tiền tố; SPPSpeedGPS + hiệu chỉnh ±10 km/h + kênh car.area; Startup khớp khung DashBoard + dự phòng IP (ipwho.is, ipapi.co/json); Loại màn hình — chỉ có selector `screenKind`, không tìm thấy khóa prefs/khóa chữ riêng [kết quả âm, ghi rõ]; CrashGuard toàn hệ + tệp chung + bảng khóa Crashed/Pending theo module. |
| [strings-new-en-vi.md](strings-new-en-vi.md) | Kho thô: toàn văn **116 khóa strings mới** theo từng file (Localizable 71, WhatsNew 16, Onboarding 13, AppBridge 8, SpeedBubble 4, SplitScreen 4), EN và VI cạnh nhau + toàn bộ 8 trang Onboarding. |
| [whatsnew-full.md](whatsnew-full.md) | Toàn văn WhatsNew 1.0.5 (3 mục) + 1.0.4 (4 mục) EN/VI, 5 khóa WN_* mồ côi (gồm mục Ủng hộ bị ẩn), phụ lục mục 1.0.0. |
| [keys-channels-new.md](keys-channels-new.md) | 54 kênh Darwin của 1.0.5 (đánh dấu **10 kênh mới**, 0 mất), 140 khóa prefs ứng viên mới kèm binary chứa, 18 chuỗi dạng chấm mới. |
