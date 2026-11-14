# APEX — CHECKPOINT TASK1 (M3-0) + TASK2 (D5-B), 2026-11-14

Nhánh `feature/duocar-apex-ui-muse-20261114`, nền HL61 `298b7b4a`. Phán quyết mở cổng: GPT #issuecomment-6875586688; lệnh giao: #issuecomment-6875604560.

## TASK1 — M3-0 (commit `d256a3e`)
Thay artwork mesh logo cũ bằng skin Graphite/Titanium vẽ bằng code tại đúng 3 điểm DuoCar sở hữu:
`SCPApplyMeshBackdrop` (Chrome.m — tác động Panel/Picker/RatioMenu), điểm mesh trong `-buildBarForPane:` (ABHostBMethods.m), điểm mesh trong `-buildPanel` (ABKeyboard.m). Giữ nguyên class UIImageView, frame/autoresize/thứ tự view/blur. `OMCCommon.c`, `OMCLogoMeshImage`, `SPPBubbleView` nguyên vẹn từng byte. Gương: Chrome chỉ sang `src/SplitScreenA/` (bản SplitScreenB là bản cũ lệch — không đụng).

## TASK2 — D5 phần B (3 commit)
- `580421b` (a) route: root thành 5 tab (Bảng điều khiển / Bố cục / Ứng dụng / Thiết bị / Tùy chỉnh), `selectedIndex=0`, log tabs=5; `-chooseLanguage` cập nhật đủ 5 tiêu đề; kind 5/6 có tiêu đề riêng.
- `fa48bf4` (b) phân vùng: kind 5/6 dùng chung bộ dựng kind 0 rồi phân vùng theo NỘI DUNG hàng (không theo chỉ số): Thiết bị = section chứa khóa `duocarThermalTest37Enabled` + hàng `leCompat` (nhóm "Lề" riêng); Tùy chỉnh = phần còn lại. Thẻ master + nút Respring/Ngôn ngữ theo kind 6 (mở cổng chrome ở viewDidLoad/refreshMasterCard/cellForRow).
- `477263b` (c) dashboard: section Trạng thái đọc 4 key (enabled, duocarVitalsEnabled, duocarFullscreenVitalsEnabled, duocarThermalTest37Enabled — chỉ đọc, không ghi) + 7 lối tắt đẩy đúng controller sẵn có; tab Bố cục có header preview tỉ lệ minh họa 55/45 + tên app ghim đọc từ pref thật.

## Bảng đối chiếu hàng TRƯỚC → SAU (kind 0 gốc: 8 section, 2 có điều kiện)
| Section gốc | Hàng (type/key) | Đích |
|---|---|---|
| RESCUE_GROUP (điều kiện) | RESCUE_RESTORE (rescue) | Tùy chỉnh |
| CONFLICTS_GROUP (điều kiện) | conflicts | Tùy chỉnh |
| APPS_GROUP | APPS (apps), HOME_SCREEN (home) | Tùy chỉnh |
| FEATURES_GROUP | STARTUPSCREEN (startup), SPEEDBUBBLE (bubble), SPLITSCREEN (split) | Tùy chỉnh |
| FEATURES_GROUP | Tùy chỉnh riêng DuoCar cho Lề (leCompat) | Thiết bị (nhóm Lề) |
| (không tiêu đề) | PROFILES (profiles) | Tùy chỉnh |
| Thiết bị | vitals; switch duocarVitalsEnabled; switch duocarFullscreenVitalsEnabled; switch duocarThermalTest37Enabled | Thiết bị (nguyên section) |
| SUPPORT_GROUP | ONB_SHOW_AGAIN (guide), WN_ROW (whatsnew) | Tùy chỉnh |
| DEV_GROUP | SEND_LOG (logs) | Tùy chỉnh |

Kết quả kiểm: mỗi hàng gốc xuất hiện đúng 1 lần ở đúng 1 tab — không trùng, không mất. Subpage kind 2/3/4 và deep-link giữ nguyên (handler `didSelectRowAtIndexPath` không sửa dòng nào; `OMCNativePref`/`OMCNativeSetPref`/notify nhiệt không sửa). Công tắc master + Respring + Ngôn ngữ: còn nguyên ở tab Tùy chỉnh.

## Trạng thái
SOURCE COMPLETE (toàn bộ D1–D14 + A1) / COMPILE PENDING — toolchain VM Muse hỏng (clang-18 bị rollback), không tuyên bố BUILD PASS / DEVICE PENDING — U3, U8, U10, U11 chờ test xe. Không merge main, không CI, không DEB.

## BỔ SUNG — GPT REVIEW 6875732000 + ĐỢT SỬA (14/11)
GPT phán: M3-0 SOURCE SCOPE PASS; D5-B SOURCE REVIEW FAIL (3 điểm). Nhãn "SOURCE COMPLETE" Muse tự ghi ở trên CHƯA được GPT xác nhận — trạng thái đúng sau review: FIX APPLIED / GPT RE-REVIEW PENDING.
- Rò CF: 3 helper graphite thiếu `CGColorSpaceRelease` → đã sửa, commit `5ec2f36`.
- Lỗi 1 (điều hướng): lối tắt Startup của Dashboard trỏ `initWithKind:2` (trang Home) → sửa dùng `OMCNativeStartupController()` sẵn có, commit `4ed1733`.
- Lỗi 2 (stale): nhãn app ghim ở tab Bố cục chỉ set 1 lần → refresh trong `viewWillAppear` qua hàm chung `omcPinnedCaptionText`, commit `d3f9cdc`.
- Lỗi 3 (thiếu preview): Dashboard thêm thẻ preview chia màn (minh họa tĩnh 55/45, gắn nhãn "Minh họa"); nhãn ở tab Bố cục cũng thêm chữ "Minh họa —", commit `8cc471c`.
- Bộ kiểm tĩnh nhắm đúng 3 lớp lỗi + rò CF + gương: 19/19 PASS (kịch bản kiểm lưu trong báo cáo Issue #1; đây là kiểm tĩnh, không phải bằng chứng build).

## BỔ SUNG 2 — GPT RE-REVIEW 6875837461 (14/11)
GPT xác nhận 4/4 lỗi cũ SOURCE FIX PASS; còn 1 điểm locale: Dashboard không làm mới tiêu đề/nhãn preview khi đổi ngôn ngữ, và phụ đề thẻ master ở Tùy chỉnh không cập nhật ngay trong chooseLanguage. Đã sửa (commit ngay trên đầu checkpoint này): Dashboard giữ tham chiếu 2 nhãn preview và làm mới cả 3 chuỗi trong `viewWillAppear`; `chooseLanguage` gọi `refreshMasterCard` ngay sau khi lưu. Kịch bản kiểm tĩnh đã NỘP VÀO REPO: `gpt-project-history/APEX_FIX_CHECKS_20261114.py` (chạy từ thư mục `recovered-source/`).

## BỔ SUNG 3 — M4: GPT SOURCE GATE PASS + COMPILE PASS (14/11)
- GPT comment 6875888201: **SOURCE GATE PASS** (độc lập đối chiếu 16/16 điều kiện của kịch bản kiểm, 4 cặp SHA khớp; ahead 32/behind 0 so HL61; 11 đường dẫn bảo vệ không nằm trong diff). Mở M4 preflight.
- Preflight Muse (comment 6875921633): hợp đồng build Theos aggregate (rootless, arm64 trên VM, TARGET 16.5:15.0); toolchain VM hỏng do rollback.
- Nguyen duyệt trực tiếp tại chat (17:30): chạy `~/bin/fix-toolchain.sh` → exit 0, smoke test đạt.
- Compile-check (comment 6875967464): `make -j2` trên HEAD `3107d0e`, cwd `recovered-source/project/` → **exit 0, 0 error**, 132 warning cũ; 7/7 subproject linking; 4 file APEX sửa đều biên dịch; hash sản phẩm trung gian đã ghi tại comment. Chưa đóng DEB ở bước này.
- Tiếp theo: Nguyen lệnh riêng (17:38) — xuất MỘT DEB thử nghiệm APEX (M5).
