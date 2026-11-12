# MultiTA Plus rh15 1.2 — TRỌN BỘ HỒ SƠ QUÉT (lưu 2026-11-12)

Deb gốc: `com.sushibta.multita.rh15_1.2_iphoneos-arm64.deb` (dpkg-repack
từ máy đã cài), SHA-256 ở `raw/deb-sha256.txt`. Quét chỉ đọc.

| File | Nội dung |
|---|---|
| [HO_SO.md](HO_SO.md) | Hồ sơ hợp nhất: bản đồ 10 binary, cơ chế bản quyền (authority độc lập + challenge–response Ed25519 + lease tách quyền theo tính năng), toàn vẹn integrity.json + phát hiện khóa test `0.1tester-keytest3-base26`, script cài đặt, an toàn/riêng tư, khớp–lệch quảng cáo |
| [agent-a-shell.md](agent-a-shell.md) | Đường rà vỏ gói: DEBIAN scripts toàn văn, AI-NOTICE nguyên văn, cấu trúc integrity.json, bảng dylib→process |
| [agent-b-binary.md](agent-b-binary.md) | Đường rà binary: class/method/khóa/kênh theo từng binary, hồ sơ bản quyền chi tiết, đối sánh OmniCar/DuoNavi |
| [agent-c-safety.md](agent-c-safety.md) | Đường rà hành vi/an toàn: endpoint, bề mặt đặc quyền, dữ liệu rời máy, đối chiếu quảng cáo |
| raw/control.txt · raw/DEBIAN/ | Control + maintainer scripts nguyên văn (postinst/prerm/postrm) |
| raw/files-sha256.txt | Toàn bộ 33 file kèm SHA-256 |
| raw/AI-NOTICE.txt | Thông báo của TAstore gửi người phân tích/AI (nguyên văn) |
| raw/integrity-decoded.json | Giải mã đủ 8 manifest toàn vẹn (payload + độ dài chữ ký) |
| raw/substrate-filters.txt | Bộ lọc nạp dylib của cả 7 dylib |
