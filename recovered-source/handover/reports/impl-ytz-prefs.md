# YT-ZOOM — Strand Prefs: công tắc staging `youtubeVirtualize` trong Prefs

Trạng thái: **XONG** (chỉ phía Prefs; không sửa source AppBridge/SplitScreen).
Thiết kế nguồn: `design-ytzoom.md` §8.1 (công tắc) + §9 (specifier thuộc strand
riêng theo mẫu FS1-C). Khuôn: `impl-fs-prefs.md` (FS1 strand C, cùng trang).

## 1. File đã sửa (3 file, đều dưới `project/OmniCarPrefs/Resources/`)

### 1.1 `FeatureSplitScreen.plist` (binary plist, giữ nguyên định dạng `bplist00`)

`items` từ 4 → 6 phần tử; `items[0..3]` (gồm cặp FS1 `fullscreenTestExpand`)
và top-level giữ nguyên từng giá trị (đọc lại đối chiếu bản sao lưu: identical).

Thêm ở cuối (không xáo trộn chỉ số của specifier cũ):

```
items[4]  PSGroupCell
            label      = SPLITSCREEN_YTZ_TEST_GROUP
            footerText = SPLITSCREEN_YTZ_TEST_FOOTER
items[5]  PSSwitchCell
            label            = SPLITSCREEN_YTZ_TEST_VIRTUALIZE
            key              = youtubeVirtualize
            default          = false        (bool)
            defaults         = com.anlai.omnicar
            PostNotification = com.anlai.omnicar/prefschanged
```

Chỗ đặt: nhóm TEST **riêng** ngay sau cặp FS1 ở cuối trang — đúng §8.1 "đặt ở
trang FeatureSplitScreen nhóm TEST cạnh `fullscreenTestExpand`": công tắc nằm
trong khu TEST của trang, sát công tắc FS1; tách nhóm riêng để footer của FS1
(nói về phình fullscreen/ẩn dock) không lẫn sang tính năng này, và nhãn/footer
của nhóm mới ghi đúng YT-ZOOM như §8.1 yêu cầu.

### 1.2 `en.lproj/SplitScreen.strings` + `vi.lproj/SplitScreen.strings` (binary plist)

Mỗi file 49 → 52 khoá; 49 khoá cũ nguyên vẹn từng giá trị (đã đối chiếu).
Ba khoá mới:

| Khoá | en | vi |
|---|---|---|
| `SPLITSCREEN_YTZ_TEST_GROUP` | `TEST — YT-ZOOM (acceptance only)` | `TEST — YT-ZOOM (chỉ dùng nghiệm thu)` |
| `SPLITSCREEN_YTZ_TEST_FOOTER` | `Acceptance testing only: ON virtualizes hosted YouTube to portrait so fullscreen fills the pane without rotating; OFF restores normal orientation handling. This test switch is removed after acceptance.` | `Chỉ dùng nghiệm thu: BẬT = ảo hoá YouTube được host về hướng dọc để fullscreen lấp ô mà không xoay; TẮT = trả lại xử lý hướng bình thường. Công tắc test này sẽ bị gỡ sau nghiệm thu.` |
| `SPLITSCREEN_YTZ_TEST_VIRTUALIZE` | `Virtualize YouTube orientation (test)` | `Ảo hoá hướng YouTube (test)` |

Đường bản địa hoá giống hệt FS1 (xem `impl-fs-prefs.md` §1.2):
`OMCLocalizeSpecifiers` → `L()` → `OMCLoadStrings()` gộp mọi `*.strings` của
`en.lproj` (luôn fallback) + locale hiện tại — để khoá ở en + vi là đủ mọi
locale; máy của Nguyen (vi) hiện đúng nhãn TEST tiếng Việt.

## 2. So khuôn với switch/group cũ

- Switch mới có tập keys **identical** với switch mẫu `splitScreenEnabled`
  trong cùng file (và mọi switch trong cả 3 `Feature*.plist`): đúng 6 keys
  `{cell, label, key, default, defaults, PostNotification}` (đã assert bằng
  script). Chỉ khác giá trị: `key = youtubeVirtualize`,
  `label = SPLITSCREEN_YTZ_TEST_VIRTUALIZE`, `default = false` — cùng tiền lệ
  `false` của `fullscreenTestExpand` ngay phía trên.
- Group mới có tập keys identical với group FS1: `{cell, label, footerText}`.

## 3. Đường ống pref cho khoá mới — TỰ ĐỘNG, không cần khai báo thêm

Cùng trang, cùng cơ chế đã chứng minh ở `impl-fs-prefs.md` §3 (không lặp lại
toàn văn): `OMCFeatureListController` nạp mọi specifier trong plist bằng
`loadSpecifiersFromPlistName:target:` — không có danh sách khoá cho phép;
framework ghi giá trị vào domain theo `defaults` + `key` của specifier và
phát Darwin notification theo `PostNotification` của chính specifier sau khi
ghi. Khoá vắng trong domain = đọc ra NO = **TẮT**, khớp §8.1 "vắng = TẮT"
(đây là staging switch mặc định tắt, khác AutoHide mặc định bật).

Phía nhận thuộc strand ABYTZoom, strand này chỉ ghi đối chiếu theo §8.1:
**chỉ ABHost đọc `youtubeVirtualize`** (điểm cấp lease, sự kiện prefschanged,
mỗi lần nhận ack `request`) và đăng ký nghe Darwin
`com.anlai.omnicar/prefschanged` để bật/tắt lease giữa phiên không cần cắm
lại xe; phía app không bao giờ đọc pref này.

## 4. Mirror hai cây

Như `impl-fs-prefs.md` §4: `FeatureSplitScreen.plist` và các `.strings`
**chỉ tồn tại ở cây build** `project/OmniCarPrefs/Resources/`; cây `src/`
không có bản mirror cho Resources của Prefs. Strand này chỉ có một vị trí
sửa. Các bản trong `payload/` và `metadata/raw/` là bản gốc trích xuất
(chỉ-đọc) — không đụng.

## 5. Kiểm chứng sau ghi (đã chạy, đạt toàn bộ)

- Ba file giữ magic `bplist00`; nạp lại bằng plistlib thành công (VM không
  có `plutil` — plistlib round-trip + assert từng trường như FS1).
- Top-level + `items[0..3]` identical với bản trước sửa; `items[4..5]` đúng
  từng giá trị như mục 1.1; tập keys của switch mới == khuôn 6 keys của
  switch mẫu; tập keys của group mới == khuôn group FS1; `default` là bool
  `False` (kiểm cả kiểu, không phải số 0).
- 49/49 khoá strings cũ nguyên vẹn ở cả en và vi; đúng 3 khoá mới được thêm,
  giá trị như bảng mục 1.2.
- Sao lưu trước sửa: `/tmp/ytz-prefs-backup/` (giữ cấu trúc locale vì hai
  file strings trùng tên): plist `cb52147a…`, strings en `fb62b03f…`,
  strings vi `40c54320…`.

## 6. Gỡ bỏ / lật mặc định sau nghiệm thu

Sau nghiệm thu: xoá `items[4]` + `items[5]` khỏi `FeatureSplitScreen.plist`
(ba khoá strings giữ hay xoá kèm đều vô hại vì `L()` fallback trả lại chính
khoá). Lưu ý §8.1: việc lật mặc định của `youtubeVirtualize` thành BẬT sau
nghiệm thu là quyết định riêng của Nguyen/GPT — thiết kế không tự làm;
strand này giữ `default = false` đúng staging.
