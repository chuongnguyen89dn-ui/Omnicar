# HL21 — HL11 native keyboard + HL13 pinch + bỏ nút phụ + picker gốc che nền (11/11/2026)

## Chỉ thị hiện tại
Nguyen yêu cầu **một DEB hoàn chỉnh duy nhất** từ chức năng đã thấy trên video bàn phím HL11; chữa pinch zoom toàn OmniCar (không zoom video), xóa biểu tượng OmniCar phụ nổi khi Dock/Home chính đã có theo tiền lệ HL14 và hoàn nguyên menu chọn app **che nội dung bên dưới** về kiểu giao diện DEB gốc. Không tiếp tục các vá keyboard HL14–HL20, không sửa cài đặt iPhone khi chưa yêu cầu lại. Không tự quyết định giao Muse đóng gói; user giao GPT làm DEB ở lượt này. Không merge main, không publish Sileo.

## Nguồn và căn cứ từng chức năng
- Video thiết bị `IMG_8191.mp4`, ngày 10/11 khoảng 15:33–15:38: bàn phím hệ thống xuất hiện/gõ được ở HL11, nhưng chưa resize theo ô. HL11 CI SHA `5f7d4a09607f4af3531c520d2ab1609b0444f367`, artifact `13746456934`, DEB SHA256 `6d6211bd56c9d3cc688e430d533fd9f3d628b63e73ec99e89eb691b465297952`. **Không nhầm keyboard HIỂN THỊ với keyboard RESIZE PASS**.
- HL8 xe CarPlay PID 41247: 33/33 fullscreen applied (17 bung/16 thu); sau HL8 có hồi quy. HL13 source commit `b6f2411e7f1f45eb4ab0862571d7579e0347cf05` đã sửa hosted fallback mode và popup veto không tính bar; HL13 giữ nguyên `ABInApp.m` blob của HL11 `73557304be29f4b5b7f7a4301e199e3ec655c9c3`. HL14 có một số fullscreen applied nhưng chưa chứng minh toàn bộ DEVICE PASS.
- HL12 cung cấp đường Dock OwnID `SCPHomeLauncher.m`, kế thừa HL11; không thay keyboard. HL14 source commit `5d9280ee104ca462a6bbb32ab07c03059b8950d8` có hunk `-refreshHomeButton` bỏ `SCPCButton` supplementary khi `SCPHomeLauncherEnabled()`; không xóa icon Home/Dock thật. Rủi ro: cũng ảnh hưởng nút Logo recall khi split active; cần device check, không gọi pass vì có hunk.
- Picker: HL10 đưa `SCPCarSplit+Picker.m` và `SCPCarSplit+Chrome.m` sang same-window và shield. Phiên trước HL10 (HL9) là cơ chế `trayWindowForParent`, cache theo container, grid hai vùng + face nền original. Người dùng yêu cầu **menu che nội dung phía dưới** nên mặt `faceClear` (HL5) phải bị tắt trên chính đường này, không dùng transparent overlay; không ép pane-local sheet hay engine khác.

## Source thực hiện (GitHub connector, không có checkout macOS local)
- Nhánh `feature/hl21-from-hl11-pinch-legacy-picker-20261111`, tạo từ source/build HL13 `b6f2411e7f1f45eb4ab0862571d7579e0347cf05` thay vì chép ngược nguyên file HL11. Lý do: HL13 đã bao gồm HL11 keyboard + HL12 Dock + pinch fix, không kéo toàn bộ HL14–HL20 vào.
- Commit `1af5a9658b7bf2719d695aeda2947628d0aced79`: trả 4 file picker/chrome project/src về blob trước HL10 (Picker `d1d77955ee131b84a98fa2fb4918658e7339687a`, Chrome `f63714e6956917ef8dc90cfff0821fa7c7f1f4e6`). Đã so diff: mỗi file có một hunk liên tục khác, ngoài hunk giống byte-for-byte nên hoàn nguyên theo hunk không làm mất thay đổi sau.
- Commit `9fd66c37292452d5d30e6ee65cb1cf81c9dfb416`: (a) `SCPCarSplit.m` project/src chỉ thêm guard HL14 riêng ở `refreshHomeButton`, marker `[hl21-floating]`; (b) `SCPCarSplit+Picker.m` project/src khóa `faceClear=NO` và dùng `SCPApplyMeshBackdrop` gốc, marker `[hl21-legacy-picker] ev=opaque-tray-face`; (c) project/control Version `1.0.3-hl21restored`; (d) workflow build FAT arm64/arm64e kiểm marker phiên này và chạy fixture script; (e) `verify_hl21_regression.py` kiểm checksum keyboard HL11, pinch mode, parity và menu/Dock code.
- Commit `6b9a011b9e681aebf242b185bbba9c07be7e26ce` chỉ sửa đường root trong fixture: `Path(__file__).resolve().parents[1]` (recovered-source). Build dùng **commit cuối**, không nhận artifact build commit cũ `9fd66c...` nếu fixture lỗi.
- Giữ `OmniCarAppBridge/ABInApp.m` nguyên bản HL11; không sửa biến viewport/refsize/keyplane, native feed, scene sustain, YTZ, AutoHide, Settings iPhone hay Home/Dock thật.
- Workflow GitHub Actions có `push` trên nhánh chuyên đề này (không push `ci-fat-test` hoặc `main`); chạy hai run do hotfix fixture nhanh: `42960153812` HEAD `9fd66c...` (không chọn), `42960173185` HEAD `6b9a011...` (build mục tiêu). Tại checkpoint sớm cả hai còn chạy; phải kiểm kết quả và hash DEB cuối trước khi giao; CI xanh vẫn chưa phải DEVICE PASS.

## Cổng nghiệm thu và hoàn nguyên
- CI: script regression fixtures **thật** (không chỉ marker), Theos/ldid FAT, 8 Mach-O nếu gói app + Prefs, Package/Version/Architecture, `LC_CODE_SIGNATURE`, SHA256, chỉ upload **một .deb** đúng Version, kiểm thật artifact.
- Xe: bàn phím hệ thống HL11 phải hiện/gõ được; pinch toàn split + dock ẩn/hiện với hosted và native; menu kiểu gốc có mặt che nội dung, chọn/huỷ/đổi app vẫn hoạt động, không mất scene ngoài lúc menu che; icon dự phòng không nổi khi Home/Dock đã có, OwnID Home/Dock gốc vẫn truy cập được và không icon trùng. Kiểm ngay tình huống logo wake/recall trước đó; không gọi DEVICE PASS khi chưa có bằng chứng.
- Rủi ro mở: bàn phím HL11 chưa resize theo tỷ lệ ô; Cài đặt iPhone HL11 vẫn cũ; UX Logo recall có thể bị ảnh hưởng khi xóa nút phụ. Không tuyên bố những phần ngoài lệnh đã hoàn thiện.
- Quay lại nhanh: nhánh nguồn ban đầu HL13 `b6f2411e` vẫn giữ, chỉ revert hunk hai commit trong nhánh HL21; không force push/rewrite main. Không có sửa root ngoài hồi quy CI workflow.

## Tiếp nối
Đọc job `42960173185`, xác định mọi step PASS và artifact. Nếu thất bại: đọc chính job log, vá đúng hunk/fixture, chạy CI có đúng version/commit mới; không giao nhầm run. Nếu thành công: tải ZIP artifact, trích DEB trực tiếp, đo hash/metadata/cấu trúc ký từ chính DEB, đưa link .deb cho Nguyen, cập nhật kết quả+SHA dưới đây và README.

### Kết quả CI/DEB
Chưa chốt tại checkpoint sớm.
