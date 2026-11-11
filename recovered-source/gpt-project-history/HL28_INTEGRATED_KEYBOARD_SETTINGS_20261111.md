# HL28 — Một DEB DuoCar: bàn phím HL11 + Cài đặt UIKit/Respring HL27 (2026-11-11)

## Yêu cầu đang áp dụng
Nguyen: "Phím và cài đặt cho lần deb này" — tích hợp hai sửa lỗi vào **một** DEB FAT đã ký để test trực tiếp, không Sileo/merge main. Nền thực thi HL27 Settings/Respring; chỉ ghép hunk bàn phím vào source mới, giữ keyplane diagnostics. Không thay pinch/zoom toàn split, menu gốc, Home/Dock, AutoHide/Wake, YTZ5 hay phần Muse đang làm. Test iPhone/xe do Nguyen nghiệm thu.

## Repository, base, branch, source commits
- Repo chính `chuongnguyen89dn-ui/Omnicar`, work tree `recovered-source/`.
- Nhánh nền HL27: `feature/duocar-hl27-settings-respring-diagnostics-20261111`, exact HEAD `e5c2c51cde56d8cd2946b0c146e9db2cc8520142` (CI HL27 FAT run 43018591031 SUCCESS). Đừng nhầm DEB HL27 với bản sửa bàn phím mới.
- Source hunk bàn phím chuẩn: `feature/duocar-hl27-hl11-keyboard-restore-20261111`, exact HEAD `04728bd52c9503573d30c6757132644a6ce69e3c`; hồ sơ `HL27_HL11_KEYBOARD_REGRESSION_20261111.md`.
- Nhánh tích hợp **đã tạo GitHub và xác nhận** `feature/duocar-hl28-keyboard-settings-20261111` từ exact HL27 HEAD nêu trên. GitHub HEAD build sau cùng `5e842e7b7fe8ca03aea5663222a539b2993d93c5`, 9 commits ahead HL27, behind 0, **chỉ 7 file khác**: hai ABInApp.m, rebrand_duocar.py, verify_duocar_payload.py, verify_hl27_settings_respring.py, verifier HL28 mới, workflow FAT.
- Lệnh/thao tác thực tế thông qua GitHub connector `fetch` branches/actions, `fetch_file`, `compare_commits`, `create_branch`, `update_file`, `create_file`; **không có git checkout local, không biết local dirty state, không dùng đường VM của Muse**.

## Hunk source đã ghép và kiểm lại
- Cả `recovered-source/project/OmniCarAppBridge/ABInApp.m` và `recovered-source/src/AppBridgeB/ABInApp.m` có blob SHA cùng nhau `148e7e910922ff1a68e2b089c1b0c9e9aed0b758`. Không copy đè toàn file. Cơ chế `AB27FindKeyplane` + `[hl27-keyplane]` từ nhánh Settings vẫn sống cùng `[hl25-kb-surface]`.
- `ABNativeKbBegin()`: fit lần đầu thành công -> dừng, không schedule 0.3/0.6/1.2; chỉ retry khi chưa có keyboard window, và huỷ chuỗi khi retry đã thành công. `ABNativeKbWindowVisible()`: khi fit thành công huỷ retry đang chờ.
- `BWKbFrameNote()`: giữ báo trạng thái input, bỏ extra `ABNativeKbFit(@"keyboard-frame")` sau UIKit callback. `ABOrientationBlock()`: chỉ fit lại một lần với host packet mới hợp lệ và revision non-stale; bỏ 0.12/0.35 `host-frame-settled`.
- **Giữ nguyên** hồi quy HL24 no second LayoutStar scaling/no reloadInputViews, geometry revision và restore; giữ Cài đặt UIKit HL26, original-root card + language/Respring ack HL27, SpringBoard-only respring request receiver.
- Thêm runtime marker `[hl28-kbmerge]` vào callback early-success để xác định đúng generation. Tách khỏi `[hl27-keyplane]` marker chẩn đoán.
- **Không được tuyên bố sửa dứt điểm keycap clipping** chỉ vì cải thiện lịch fit; HL24 video từng cho thấy inner window full width vẫn bị che. Root cause H1 z-order/clip vs UIKit keyplane còn chờ xe đo.

## Build version / existing verification gates
- `recovered-source/gpt-project-history/rebrand_duocar.py` và `verify_duocar_payload.py`: Version/expected version `1.0.3-hl28duocar`; package `com.chuong.duocar`, app UIKit `com.chuong.duocar.app`, arch `iphoneos-arm64` with two binary slices arm64 + arm64e. Verifier payload yêu cầu marker `[hl28-kbmerge]` và `[hl27-keyplane]` trong AppBridge.
- `verify_hl27_settings_respring.py`: giữ lại tất cả gate HL27 đối với Settings owner/Respring và scene-keyplane; cập nhật version HL28.
- `verify_hl28_keyboard_settings.py`: source parity (3 cặp), early-stop, retry cancellation, no extra UIKit/host fit, no double keyplane scale, preserving HL27 settings/respring, geometry generation, independent four no-window/late-window timing counterexamples. Run trước rebrand. **Không gọi source verifier là device proof.**
- Workflow `.github/workflows/build-fat-macos.yml` cập nhật branch trigger **chỉ một lần ở commit cuối** `5e842e7...`; đã giữ các source/payload gates HL8/22/24/25/26/27, thêm HL28, Theos/ldid macOS FAT. Package path `recovered-source/project/packages/com.chuong.duocar_1.0.3-hl28duocar_iphoneos-arm64.deb`; artifact `duocar-hl28-fat-deb`. **Không tạo public Release/Sileo**.
- GitHub source/CI preflight readback: HEAD chính xác `5e842e7...`, project/src ABInApp cùng SHA, marker HL28 + HL27, no host-frame-settled, compare HL27..HL28 đúng 7 đường dẫn. Actual local Python/clang **chưa chạy** khi checkpoint đầu.

## CI hiện tại, kiểm build và đường bàn giao
- Run `43021840020`, job `130526672762`, event push, exact head `5e842e7b7fe8ca03aea5663222a539b2993d93c5`, started 2026-11-11 12:36:44 UTC. Truy vấn GitHub trực tiếp lần gần nhất: **IN_PROGRESS**, checkout PASS, Install Theos IN_PROGRESS, các gate sau chưa chạy. Đây là **run duy nhất** của nhánh HL28. Không dispatch trùng.
- Cần xem job steps `fetch_workflow_run_jobs`, logs khi lỗi. Khi SUCCESS lấy exact artifact `duocar-hl28-fat-deb` thuộc run 43021840020; xác nhận từ output real DEB control Package/Version/Architecture; 8/8 FAT Mach-O arm64+arm64e ký, HL28 and Settings/Respring marker, no legacy name, app APPL + Root15/Startup44 + preferences. Tính SHA256 trên **chính .deb**, không nhầm ZIP. Chỉ giao link file sandbox nếu container xác nhận chính xác local path của artifact sau khi materialize/download; nếu không phải trung thực và đưa artifact URL GitHub, không bịa direct file.
- Khi lỗi source verifier/clang: đọc log và sửa đúng hunk trên cùng nhánh, tạo run mới có kiểm soát. Giữ workflow không merge main / Sileo.
- **Device gate pending:** Nguyen cài HL28 trên iPhone, mở app Settings/Respring xác nhận; trên xe thử TikTok/YouTube/Facebook gõ/Return/Delete, full right keycaps ở nhiều ratio, drag divider, focus change, hide/reopen, reconnect; đối chiếu log `[hl28-kbmerge]`, `[hl27-keyplane]`, `[hl25-kb-surface]`, phiên PID/time đúng artifact. Hồi quy logo, Dock/Home, pinch và menu. Build xanh KHÔNG phải device pass.
- Rollback code: HL27 source `e5c2c51...`, signed HL27 artifact ID `13853648459` (keyboard not fixed). Rollback hunk riêng: revert two ABInApp files commit patches; không hoàn nguyên cả HL11.

## Lưu bền vững
Được ghi trên GitHub main theo quyền tài liệu GPT. Sau khi build hoàn tất, cập nhật mục CI này với status thật, artifact ID, sha, size, links và readback; sửa README liên kết. Nếu không có DEB cuối hoặc chưa test, ghi rõ PACKAGE/DEVICE PENDING.
