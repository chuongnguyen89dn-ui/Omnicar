# fix-p-diag — Đường kiểm thử fullscreen độc lập (P2) + đường thoát (P4) + nhóm Chẩn đoán Prefs

Lệnh: WO GPT khắc phục tổng hợp sau fs1, mục P2/P4 + nhóm chẩn đoán. Mức đạt: **source complete / build PASS / static PASS** (chưa DEVICE). Không đụng `SCPCarSplit+BridgeWake.m`; chữ ký `bwSetExpandedActive:forBundle:` giữ nguyên.

## 1. Controller — listener [fs-diag] khôi phục

`project/OmniCarSplitScreen/SCPFullscreenController.m` (mirror `src/SplitScreenA/` identical):

- Ivar mới :84–87 — `_fsDiagPrefsToken`, `_fsDiagWant` (giá trị pref cuối đã hành động, làm nền edge).
- `fsInstallIfNeeded` :119–135 — đọc nền ban đầu `OMCPref(@"fullscreenDiagExpand", @NO)` (không hành động lúc cài), đăng ký `notify_register_dispatch` trên `SCPNotePrefsChanged` (kênh `com.anlai.omnicar/prefschanged` sẵn có, main queue — đúng idiom của bw owner), log `[fs-diag] diag listener installed want=%d`.
- `fsDiagPrefsChanged` :149–167 — handler: đọc lại pref mỗi lần kênh kêu. Đổi cạnh → ON gọi `fsRequestExpandWithCompletion:nil provenance:@"diag"`, OFF gọi `fsRequestRestoreWithCompletion:nil provenance:@"diag"` — **đúng đường nội bộ của pinch** (cùng cổng vào/txn/đọc-lại-xác-nhận trong `fsExpandWithCompletion:`/`fsRestoreWithCompletion:`), controller log nội bộ mang provenance `diag`. An toàn mức (level safety): post nào thấy pref OFF trong khi máy đang EXPANDED vẫn restore dù không có cạnh đổi — tắt pref từ bất kỳ đâu khi đang EXPANDED luôn là đường thoát, không phụ thuộc recognizer.
- Controller **chỉ đọc** pref: grep `CFPreferencesSetAppValue|storeValue` trong SCPFullscreenController.m = **0** — trạng thái pref không bao giờ bị controller tự sửa.
- Header `.h`: ghi chú fs-diag tại `fsInstallIfNeeded` + provenance list thêm `"diag"`.

## 2. Prefs — nhóm "Chẩn đoán" (section 6, cuối trang Chia màn hình)

`project/OmniCarPrefs/OMCSplitScreenController.m` (mirror `src/Prefs/OMCPrefs/` identical), dựng 100% bằng code theo idiom trang (plist không được nạp — bài học vòng trước). Diff thuần cộng + điểm đăng ký section:

- Đăng ký: `numberOfSections` 6→7 (:145), `case 6: return 3` (:154), header (:170) + footer (:178) section 6, chiều cao hàng 60 cho section 6 (:215). Sections 0–5 giữ nguyên số/khuôn; hàng section 6 tự rơi vào luật mờ-khi-tắt-master sẵn có (`ip.section >= 2`) như sections 2–5, không sửa điều kiện đó.
- Ba control tại nhánh cell :363–407, tất cả persist qua idiom OMCCardPage (`switchForKey:`/`segmentForKey:` → `storeValue:forKey:` = ghi domain `com.anlai.omnicar` + synchronize + `notify_post("com.anlai.omnicar/prefschanged")`, kèm hook `prefChanged:`):
  - (a) :373–379 — switch `fullscreenDiagExpand`, `def:NO`.
  - (b) :384–390 — switch `youtubeVirtualize`, `def:YES` (vắng = ON, khớp reader `YZPrefEnabled` phía ABYTZoom) → GPT/Nguyen tắt ngay trên máy làm đối chứng Y2.
  - (c) :396–407 — `segmentForKey:@"bridgewake.pinchMode"` 3 nấc ghi số nguyên 0/1/2 (Off / Dry run / Enforce — segment lưu index nguyên văn, đúng số owner đọc), `def:1` (Đo).

## 3. Strings

`Resources/{en,vi}.lproj/SplitScreen.strings` (bplist, chỉ ở project/): **46 → 56 khoá**, 46 khoá cũ nguyên giá trị (đã assert round-trip). 10 khoá mới nhóm DIAG: `SPLITSCREEN_DIAG_GROUP`, `_FOOTER`, `_FS`, `_FS_SUB`, `_YT`, `_YT_SUB`, `_PINCH`, `_MODE_OFF`, `_MODE_DRY`, `_MODE_ENFORCE` (en + vi đầy đủ).

## 4. Cổng

- Build từ sạch: OmniCarSplitScreen exit 0; OmniCarPrefs exit 0 (2 warning performSelector-leak ở OMCSplitScreenController.m:65/68 là pre-existing, không thuộc code mới).
- `fullscreenDiagExpand` trong CODE: Prefs controller ×2, FS controller ×5, cả hai mirror khớp; trong `FeatureSplitScreen.plist` = **0**.
- Binary Prefs (`.theos/obj/debug/OmniCarPrefs.bundle/OmniCarPrefs`): chứa cả 3 khoá `fullscreenDiagExpand` / `youtubeVirtualize` / `bridgewake.pinchMode` (mỗi khoá 1).
- Binary SplitScreen dylib: `fullscreenDiagExpand` ×2, chuỗi `[fs-diag]` ×3.
- Mirror cmp: SCPFullscreenController.{h,m} + OMCSplitScreenController.m identical hai cây.

## 5. Điểm diễn giải để lại cho GPT/parent — LỆCH DEFAULT CỦA PINCH

Control (c) hiển thị **Đo (1)** khi pref vắng — theo thế P4 của WO. Nhưng owner `bwReloadModesAndRepublish` trong `SCPCarSplit+BridgeWake.m` (file không thuộc strand này) hiện đọc **vắng = ENFORCE** (quyết định "nối pinch luôn" 2026-11-09). Hệ quả: nếu Nguyen chưa từng chạm segment, trang Chẩn đoán hiện "Đo" trong khi pinch thực tế ENFORCE. Cần strand sở hữu BridgeWake đổi default vắng → DRY_RUN (một dòng) để hiển thị và hành vi khớp nhau trước nghiệm thu controller; sau khi user chọn bất kỳ nấc nào, giá trị đã lưu chi phối cả hai phía và lệch này biến mất.
