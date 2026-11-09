# FS1 — Strand C: công tắc test `fullscreenTestExpand` trong Prefs

Trạng thái: **XONG** (chỉ phía Prefs; không sửa source SplitScreen/AppBridge).
Thiết kế nguồn: `design-fullscreen-fs1.md` §8 (staging) + §10 (bảng strand C).

## 1. File đã sửa (3 file, đều dưới `project/OmnicarPrefs/Resources/`)

### 1.1 `FeatureSplitScreen.plist` (binary plist, giữ nguyên định dạng `bplist00`)

`items` từ 2 → 4 phần tử; hai phần tử cũ giữ nguyên từng giá trị
(đọc lại đối chiếu bản sao lưu: identical về ngữ nghĩa), top-level
(`featureLabel/featureSymbol/title/featureOrder/featureController`) không đổi.

Thêm ở cuối (không xáo trộn chỉ số của specifier cũ):

```
items[2]  PSGroupCell
            label      = SPLITSCREEN_FS_TEST_GROUP
            footerText = SPLITSCREEN_FS_TEST_FOOTER
items[3]  PSSwitchCell
            label            = SPLITSCREEN_FS_TEST_EXPAND
            key              = fullscreenTestExpand
            default          = false        (bool)
            defaults         = com.anlai.omnicar
            PostNotification = com.anlai.omnicar/prefschanged
```

Khuôn nhóm có `label`+`footerText` lấy theo các PSGroupCell trong
`FeatureStartupScreen.plist` cùng cây.

### 1.2 `en.lproj/SplitScreen.strings` + `vi.lproj/SplitScreen.strings` (binary plist)

Mỗi file 46 → 49 khoá; 46 khoá cũ nguyên vẹn từng giá trị (đã đối chiếu).
Ba khoá mới:

| Khoá | en | vi |
|---|---|---|
| `SPLITSCREEN_FS_TEST_GROUP` | `TEST — Fullscreen (acceptance only)` | `TEST — Fullscreen (chỉ dùng nghiệm thu)` |
| `SPLITSCREEN_FS_TEST_FOOTER` | `Acceptance testing only: ON expands the split to full screen and hides the dock; OFF restores. This test switch is removed after acceptance.` | `Chỉ dùng nghiệm thu: BẬT = phình split lên toàn màn và ẩn dock; TẮT = phục hồi. Công tắc test này sẽ bị gỡ sau nghiệm thu.` |
| `SPLITSCREEN_FS_TEST_EXPAND` | `Expand fullscreen (test)` | `Phình fullscreen (test)` |

Nhãn hiển thị đi qua `OMCLocalizeSpecifiers` → `L()` →
`OMCLoadStrings()` (OMCCommon.m:143/178): hàm này gộp **mọi** file
`*.strings` (trừ `Car.strings`) của `en.lproj` (luôn có trong chuỗi
fallback) + thư mục ngôn ngữ hiện tại, thiếu khoá thì trả lại chính
khoá. Để khoá ở en + vi là đủ cho mọi locale; nhóm hiện đúng dòng
chữ TEST của thiết kế §8 trên máy của Nguyen (vi).

## 2. So khuôn với switch cũ

Switch mẫu `splitScreenEnabled` ngay trong cùng file (và mọi switch
trong cả 3 `Feature*.plist`: `speedBubbleEnabled`,
`startupScreenEnabled`, `startupScreenPlayFull`, …) có đúng 6 keys:

`{cell, label, key, default, defaults, PostNotification}`

Switch mới có **tập keys identical** (đã assert bằng script), chỉ
khác giá trị: `key = fullscreenTestExpand`, `default = false`
(các switch "enable" chính để `true`; `startupScreenPlayFull`/
`startupScreenSound` là tiền lệ `false` trong cùng cây).

## 3. Đường ống pref cho khoá mới — TỰ ĐỘNG, không cần khai báo thêm

Kết luận: **cơ chế phát là tự động theo specifier; không phải sửa
một dòng code nào phía Prefs.** Bằng chứng:

1. **Nạp:** `OMCFeatureListController.m:23` —
   `_specifiers = [self loadSpecifiersFromPlistName:plist target:self]`
   (Preferences.framework, `PSListController`), sau đó
   `OMCLocalizeSpecifiers(_specifiers)`. Trang Split Screen đi qua
   lớp con `OMCCardPage` của chính controller này. Không có danh
   sách khoá cho phép ở bất cứ đâu — plist có specifier nào thì
   trang hiện specifier đó.
2. **Ghi + phát:** với `PSSwitchCell` mang `defaults` + `key`,
   framework ghi giá trị vào domain `com.anlai.omnicar` và phát
   Darwin notification đặt trong `PostNotification` của chính
   specifier sau khi ghi. Mọi switch hiện hữu đều vận hành đúng
   như vậy với cùng một template 6 keys.
3. **Không có code hậu thuẫn cho từng khoá:**
   `grep notify_post|prefschanged` trên `OMCSplitScreenController.m`
   và `OMCFeatureListController.m` = **0 kết quả** — trang Split
   Screen không hề tự phát thông báo cho `splitScreenEnabled`, mà
   phía SplitScreen vẫn nhận được thay đổi. Các điểm
   `notify_post("com.anlai.omnicar/prefschanged")` thủ công trong
   Prefs (`OMCAppBridgeAppsController.m:37,433`,
   `OMCCarProfilesController.m:21`, `OMCOnboardingController.m:326`,
   `OMCSplitScreenAppPickerController.m:209`,
   `OMCStartupScreenController.m:39` qua CFNotificationCenter) chỉ
   xuất hiện ở các controller **ghi pref bằng code tự chế** (không
   qua specifier) — tức code chỉ phải tự phát đúng ở nơi framework
   không phát hộ. Khoá mới đi qua specifier nên thuộc diện framework
   phát hộ.
4. **Domain khớp:** `OMCFeatureListController -viewWillAppear:`
   gọi `CFPreferencesAppSynchronize(OMC_PREFS_DOMAIN)`; `defaults`
   trong specifier = `com.anlai.omnicar` như mọi specifier khác.
5. **Phía nhận (đã có sẵn, thuộc strand A/B — chỉ ghi đối chiếu):**
   `SCPShared.m:10` ở cả hai cây (`project/OmniCarSplitScreen/` và
   `src/SplitScreenA/`):
   `SCPNotePrefsChanged = @"com.anlai.omnicar/prefschanged"` —
   đúng kênh thiết kế §8 chỉ định cho controller nghe
   (`bwReloadModesAndRepublish` đã dùng cùng kênh này ở wake1).
   Khoá vắng trong domain = đọc ra NO, khớp yêu cầu "mặc định
   vắng = NO" của thiết kế.

## 4. Mirror hai cây

`FeatureSplitScreen.plist` và các `.strings` **chỉ tồn tại ở cây
build** `project/OmniCarPrefs/Resources/`. Cây `src/` không có bản
mirror cho Resources của Prefs: `find src -name '*.plist'` cho
đúng 1 kết quả (`src/App/Info.plist`); `src/Prefs/` chỉ chứa code
`.h/.m` + `generated/` + `disasm/` + `tools/`. Vì vậy strand này
chỉ có **một** vị trí sửa; không có file src nào cần (hay có thể)
mirror. Các bản trong `payload/` và `metadata/raw/` là bản gốc
trích xuất (chỉ-đọc) — không đụng. Các bản sao trong `.theos/obj/`
là sản phẩm build cũ, vòng build sau tự chép lại Resources mới.

## 5. Kiểm chứng sau ghi (đã chạy, đạt toàn bộ)

- Ba file giữ magic `bplist00`; nạp lại bằng plistlib thành công
  (môi trường VM không có `plutil` — dùng plistlib round-trip làm
  phép kiểm cấu trúc tương đương `plutil -lint`, cộng assert từng
  trường).
- `items[0..1]` và top-level identical với bản trước sửa;
  `items[2..3]` đúng như mục 1.1.
- Tập keys của switch mới == tập keys của switch mẫu; `default`
  là bool `False`; `defaults`/`PostNotification` đúng chuỗi.
- 46/46 khoá strings cũ nguyên vẹn ở cả en và vi; đúng 3 khoá mới
  được thêm, giá trị như bảng mục 1.2.
- Sao lưu trước sửa: `/tmp/fs1-prefs-backup/` (sha256:
  plist `26e7f57d…`, strings en `09ebad42…`, strings vi
  `9baa8770…`).

## 6. Gỡ bỏ sau staging (theo thiết kế §8)

Xoá `items[2]` + `items[3]` khỏi `FeatureSplitScreen.plist` (ba
khoá strings có thể giữ hoặc xoá kèm — vô hại vì `L()` fallback);
phía controller gỡ nhánh quan sát khoá tại điểm đánh dấu
`// [fs1-test]` (strand A). Candidate sau staging không chứa
specifier này.
