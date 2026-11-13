# D — Nhóm cài đặt (Prefs) & Gói — Lề 0.2.4 (`dev.bechou.le`)

Phạm vi: binary `LePrefs` (PreferenceBundle), `Info.plist` của bundle, `Le.plist` (PreferenceLoader), thư mục `CONTROL/` (control + postinst), đối chiếu chuỗi/kênh trong các dylib còn lại của gói. Phân tích tĩnh chỉ đọc, không chạy binary/script.

Nhãn: **[ĐÃ ĐO]** = có chuỗi/key/địa chỉ cụ thể trong binary hoặc file gói; **[SUY LUẬN]** = ghép từ nhiều bằng chứng; **[CHƯA RÕ]** = chưa tách được dứt điểm bằng phân tích tĩnh.

---

## 1. Kiến trúc lưu cài đặt — hai tầng

### 1.1 Tầng 1: file JSON `layout-v1.json` (cài đặt bubble nổi + nguồn dữ liệu)

- **[ĐÃ ĐO]** Đường dẫn: `~/Library/Preferences/dev.bechou.le.bubble/layout-v1.json` (chuỗi `Library/Preferences/dev.bechou.le.bubble` + `layout-v1.json`, hàm dựng đường dẫn tại `0x352e8`/`0x3533c` trong LePrefs).
- **[ĐÃ ĐO]** LePrefs ghi file theo kiểu nguyên tử qua file tạm `%@.%d.tmp` (hàm `0x35b20`), rồi đổi tên — tránh file hỏng khi ghi dở.
- **[ĐÃ ĐO]** Các hàm accessor đọc từng key nằm ở `0x34c98–0x35a08`; hàm dựng cấu trúc mặc định ở `0x33d10`; hàm chuẩn hoá/ghi ở `0x33f68`.
- **[ĐÃ ĐO]** Binary đọc file này: LePrefs, `LeBubble.dylib`, `LeGoogleRelay.dylib`, `LeSupervisor.dylib` (cùng chứa chuỗi `layout-v1.json` + đường dẫn thư mục trên).
- **[ĐÃ ĐO]** Mỗi lần lưu, LePrefs phát Darwin notify **`dev.bechou.le.bubble.layout-changed`** để các dylib kia nạp lại cấu hình (chuỗi có trong LePrefs, LeBubble, LeGoogleRelay, LeSupervisor).

### 1.2 Tầng 2: CFPreferences domain `dev.bechou.le.gmaps` (cài đặt thẻ trong Google Maps)

- **[ĐÃ ĐO]** LePrefs, `LeGoogleMaps.dylib`, `LeGoogleRelay.dylib` đều import `CFPreferencesCopyAppValue` / `CFPreferencesSetAppValue` / `CFPreferencesAppSynchronize`; LeGoogleRelay còn dùng `CFPreferencesCopyMultiple` / `CFPreferencesSetMultiple` / `CFPreferencesCopyKeyList` — tức đọc/ghi cả cụm key một lần.
- **[ĐÃ ĐO]** Chuỗi domain `dev.bechou.le.gmaps` đứng độc lập trong cả ba binary.
- **[ĐÃ ĐO]** Đồng bộ giữa process Google Maps (LeGoogleMaps) và process hiển thị (LeGoogleRelay/LeBubble) qua các kênh Darwin notify trùng tên key:
  `dev.bechou.le.gmaps.bubble-configuration`, `.bubble-modules`, `.placement-state`, `.size-state`, `.size-changed`, `.phone-placement-percent`, `.presentation-options`, `.interface-style`, `.overspeed.mode`, `.overspeed.lease`, `.bubble-visibility`, `.bubble-presence`.
  **[SUY LUẬN]** Cùng một chuỗi `dev.bechou.le.gmaps.*` vừa là key CFPreferences vừa là tên notify "key này vừa đổi" — suy ra từ việc chuỗi xuất hiện đồng thời cạnh import CFPreferences và cạnh `_notify_post`/`_notify_register_dispatch`.
- **[ĐÃ ĐO]** Các kênh `dev.bechou.le.gmaps.speed` / `.limit` / `.alert.first` / `.alert.second` / `.source.vietmap.request` / `.test.*` là kênh **dữ liệu runtime** (tốc độ, giới hạn, biển báo, yêu cầu nguồn, dữ liệu test của bản xem trước), không phải cài đặt.

### 1.3 Nhóm key tổng (trang gốc) — nơi lưu

- **[ĐÃ ĐO]** Các key `presentation`, `bubbleEnabled`, `fullEnabled`, `phoneEnabled`, `interfaceStyle` được `CWLeRootPage`/`CWLeMapsPage` đọc/ghi qua cùng lớp store với file layout (ví dụ `-[CWLeRootPage reload]` đọc `presentation` với giá trị dự phòng `maps-home`; `-[CWLeMapsPage master]` đọc `bubbleEnabled`).
- **[CHƯA RÕ]** Chưa tách dứt điểm được 5 key này nằm trong chính `layout-v1.json` hay trong CFPreferences domain `dev.bechou.le.bubble`: LePrefs có import CFPreferences, nhưng các hàm accessor đã khoanh vùng (`0x34c98–0x35a08`) chỉ lộ key của nhóm bubble/nguồn. `interfaceStyle` chắc chắn còn tồn tại dạng key CFPreferences `dev.bechou.le.gmaps.interface-style` ở tầng thẻ Maps **[ĐÃ ĐO]**.
- **[ĐÃ ĐO]** Khi lưu thất bại, UI báo "Không lưu được — Bubble vẫn dùng cài đặt cũ." (`-[CWLeRootPage failed]`, `-[CWLeFloatingPage store:]`, `-[CWLeMapsPage failed]`) — tức runtime chỉ nhận bản ghi thành công, không có trạng thái nửa vời.

---

## 2. Đặc tả cài đặt đầy đủ

### 2.1 Key cấp cao nhất của `layout-v1.json`

| Key | Kiểu | Mặc định | Ý nghĩa / mục UI |
|---|---|---|---|
| `source` | string | `vietmap-live` **[ĐÃ ĐO]** | Nguồn dữ liệu duy nhất được nhận: `vietmap-live` (VietMap Live) / `gofa` (GOFA) / `waze` (Waze). Trang gốc, nhóm "Nguồn dữ liệu". Dữ liệu từ các app khác bị bỏ qua kể cả đang mở (footer trang gốc). |
| `wakeSource` | bool | **[CHƯA RÕ]** (hàm tại `0x3513c`, `0x355ac`) | "Tự đánh thức": giữ app nguồn chạy nền khi bubble/thẻ đang hiện, mở ngầm nếu đã tắt. Footer ghi rõ "Cần respring một lần sau khi cài hoặc cập nhật Lề" — vì cơ chế đánh thức dựa vào LeSupervisor. |
| `closeSource` | bool | **[CHƯA RÕ]** (hàm tại `0x351c8`, `0x356fc`) | "Tự đóng app nguồn khi rời CarPlay": 20 giây sau khi ngắt CarPlay thì đóng app nguồn đã chọn, trừ khi nó đang mở trên iPhone hoặc Google Maps trên iPhone đang dùng. |
| `bubble` | dict | xem 2.2 | Toàn bộ cấu hình bubble nổi. |
| `schemaVersion` | int | có mặt trong mọi bản ghi **[ĐÃ ĐO]** | Key kỹ thuật để migrate cấu trúc file; không có mục UI. |

### 2.2 Nhóm `bubble.*` — trang "Bubble nổi" (`CWLeFloatingPage`)

| Key | Kiểu | Mặc định | Ý nghĩa / mục UI |
|---|---|---|---|
| `arrangement` | string | `corner` **[ĐÃ ĐO]** (hàm dựng mặc định `0x33d10`, accessor `0x34e68`) | Kiểu xếp các mảnh quanh góc: `corner` = "Góc", `side` = "Lề đứng", `strip` = "Lề ngang", `compact` = "Gọn" (bảng nhãn hằng trong binary). |
| `background` | string | `asphalt` **[ĐÃ ĐO]** (accessor `0x34ef8`) | Nền bubble: `asphalt` = "Nhựa", `paint` = "Sơn", `glass` = "Kính", `haze` = "Sương", `bare` = "Trần". Ánh xạ theo giao diện: dark → asphalt, light → paint, gradient → haze, none → bare. |
| `backgroundOpacity` | double 0–1 | **[CHƯA RÕ]** con số (accessor `0x34f88`) | Mục "Độ đậm", hiển thị dạng %. **Không áp dụng khi nền = Trần (`bare`)** — `inertReason:` trả "Không áp dụng cho Trần" **[ĐÃ ĐO]**. |
| `scale` | double | 1.0 = 100% **[SUY LUẬN]** (accessor `0x35254`; UI hiển thị `%.0f%%`) | Mục "Kích thước" của bubble. |
| `overspeedBlink` | bool | **[CHƯA RÕ]** (accessor `0x3501c`) | Nhấp nháy/vệt sáng khi vượt giới hạn tốc độ (mục trong trang Bubble nổi; ở trang Maps có ghi "Vệt sáng toàn màn hình CarPlay nằm ở Bubble nổi › Khi vượt tốc độ"). |
| `modules` | array of `{id, enabled}` | 5 module, thứ tự: speed, limit, source, lanes, upcoming **[ĐÃ ĐO thứ tự qua hàm `0x27b3c`]** | Danh sách module của bubble; bật/tắt từng module và **kéo để đổi thứ tự** (`moveRowAtIndexPath:`). Ràng buộc: "Cần giữ ít nhất một module" — không tắt được module cuối cùng. Giá trị `enabled` mặc định từng module: **[CHƯA RÕ]** (hàm dựng mặc định phát 4 cặp `{id, enabled}` trong một nhánh — chưa gán chắc được cho từng id). |
| `schemaVersion` (trong bubble) | int | — | Key kỹ thuật, không có UI. |

Danh mục 5 module (bảng hằng tên + mô tả trong binary) **[ĐÃ ĐO]**:

| id | Tên hiển thị | Mô tả trong binary |
|---|---|---|
| `speed` | Tốc độ | "Hổ phách khi còn 5 km/h, đỏ khi vượt" |
| `limit` | Biển giới hạn | "Ngồi ở góc trong của mảnh tốc độ" |
| `source` | Icon nguồn | "Icon ứng dụng nguồn, phía trên biển giới hạn" |
| `lanes` | Bảng làn | "Mũi tên sơn đường, khoảng cách ở mũi bảng". **Chết/không áp dụng khi nguồn là Waze**: "Waze không có bảng làn" **[ĐÃ ĐO]** |
| `upcoming` | Biển báo | "Biển hiệu lực trước, rồi tối đa ba biển sắp tới" |

Trang Bubble nổi còn có mục **"Đặt lại mặc định"** (xoá cấu hình bubble về bản dựng mặc định của hàm `0x33d10`) **[ĐÃ ĐO]**.

### 2.3 Nhóm key tổng — trang gốc "Lề" (`CWLeRootPage`)

| Key | Kiểu | Mặc định | Ý nghĩa / mục UI |
|---|---|---|---|
| `presentation` | string | `maps-home` **[ĐÃ ĐO]** | "Cách hiện trên CarPlay", 4 giá trị (bảng nhãn hằng): `maps-home` = "Maps + bubble nổi", `maps-only` = "Chỉ Google Maps", `bubble-only` = "Chỉ bubble nổi", `except-dashboard` = "Maps + bubble nổi, trừ Dashboard". |
| `bubbleEnabled` | bool | **[CHƯA RÕ]** | Công tắc chính của bubble nổi (hàng "Bubble nổi" ở trang gốc, kèm dòng trạng thái kiểu "… · … · 3/5 module"). |
| `fullEnabled` | bool | **[CHƯA RÕ]** | Bubble nổi trên màn hình toàn màn hình CarPlay — một trong ba "màn" của trạng thái "Lề" (toàn màn hình / Dashboard / iPhone). |
| `phoneEnabled` | bool | **[CHƯA RÕ]** | Bubble/thẻ trên iPhone. |
| `interfaceStyle` | string | **[CHƯA RÕ]** giữa `halo`/`classic` | Kiểu hiển thị dùng chung: `halo` (kiểu "Lề", đồng hồ halo — `haloDial`) hoặc `classic` ("Classic"). Trang gốc cho chọn qua hàng có chi tiết "Classic"; trang Maps đọc cùng key (`-[CWLeMapsPage classic]`). |

Ba hàng trạng thái ở trang gốc ánh xạ trực tiếp: "Lề — toàn màn hình", "Lề — Dashboard", "Lề — iPhone", mỗi hàng hiện Đang tắt / Đang bật / "Không hiện ở cách hiện này" / "Cần cài Google Maps" tuỳ tổ hợp `presentation` + các công tắc + việc Google Maps có được cài hay không **[ĐÃ ĐO qua chuỗi trong `cellForRowAtIndexPath:`]**.

### 2.4 Nhóm thẻ Google Maps — CFPreferences domain `dev.bechou.le.gmaps`, trang "Trong Google Maps" (`CWLeMapsPage`)

Key (tiền tố đầy đủ là `dev.bechou.le.gmaps.` khi làm key/notify; trong LePrefs các hàm của trang Maps dùng tên rút gọn) **[ĐÃ ĐO]**:

| Key | Kiểu | Mặc định | Ý nghĩa / mục UI |
|---|---|---|---|
| `Enabled` × 3 màn hình | bool | **[CHƯA RÕ]** | "Hiện thẻ" riêng cho: Google Maps toàn màn hình CarPlay (`full`), ô bản đồ Dashboard (`dashboard`), Google Maps trên iPhone (`phone`). Hàng UI: "Khi Google Maps mở toàn màn hình CarPlay", "Khi Google Maps mở trên iPhone"… |
| `Position` (`fullPosition`, `dashboardPosition`) | string | `top-right` xuất hiện làm giá trị dùng trong `refresh` **[ĐÃ ĐO một phần]** | Góc đặt thẻ: `top-left` / `top-right` / `bottom-left` / `bottom-right`. Đặt bằng cách "Chạm một góc trên bản xem trước để đặt thẻ". |
| `phonePosition` | string | **[CHƯA RÕ]** | Vị trí thẻ trên iPhone. |
| `Scale` (`fullScale`, `dashboardScale`, `phoneScale`) | double | 1.0 **[ĐÃ ĐO qua footer: "100% là cỡ mặc định"]** | Cỡ thẻ theo từng màn hình. |
| `phoneXPercent`, `phoneYPercent` | double 0–100 | **[CHƯA RÕ]** | Lệch vị trí thẻ iPhone theo %: "Trái/phải và Lên/xuống ở 0% giữ thẻ sát góc đã chọn" (footer). |
| `Layout` (`phoneLayout`) | string | `auto` **[ĐÃ ĐO qua `layoutChoice`/`vertical`]** | Bố cục thẻ: `auto` / `horizontal` (Ngang) / `vertical`. |
| `bubble-modules` (thứ tự + bật/tắt mảnh thẻ) | array | **[CHƯA RÕ]** chi tiết mặc định | Các mảnh trên thẻ: `speed` (Góc tốc độ), `limit` (Biển giới hạn), `alerts`/`signs` (Biển báo), `dial`. Kéo ≡ để đổi thứ tự ba ô. Ràng buộc: "Tốc độ và biển giới hạn không tắt cùng lúc; tắt tốc độ thì biển giới hạn đứng một mình, cỡ lớn". Mảnh `signs` ghi "Chỉ cho kiểu Lề" — **chết ở kiểu Classic**; "Classic chỉ theo công tắc Biển báo" **[ĐÃ ĐO]**. |
| `overspeed.mode` / `overspeedScope` | string | **[CHƯA RÕ]** | "Vệt sáng khi vượt": giá trị thấy trong code: `off`, `map`…; nhãn UI: "Chỉ trên CarPlay". Footer: "Áp dụng cho cả ba màn hình". |
| `interface-style` | string | dùng chung key 2.3 | Kiểu halo/Classic cho thẻ. |
| `bubble-configuration`, `bubble-presence`, `bubble-visibility`, `placement-state`, `size-state` | — | — | Key/notify **trạng thái runtime** hai process Maps ↔ relay dùng để khớp cấu hình và vị trí thẻ, không phải lựa chọn người dùng. |

Trang Maps cũng có **"Đặt lại mặc định"** riêng **[ĐÃ ĐO]**.

### 2.5 Key/chuỗi kỹ thuật không phải cài đặt người dùng

- **[ĐÃ ĐO]** `dev.bechou.le.bubble.carplay-fresh`, `.gofa-events`, `.waze-events`, `.vietmap-shown`, `.carplay-heartbeat`, `.cast`, `.state`, `.alive`, `.place`: kênh sự kiện/trạng thái runtime của bubble (nguồn sự kiện, heartbeat CarPlay, trạng thái đã hiện…).
- **[ĐÃ ĐO]** `dev.bechou.le.source-icons.changed` + thư mục cache `/var/mobile/Library/Caches/dev.bechou.le.source-icons`: LePrefs tự trích icon của app nguồn (qua `ISIcon`/`LSApplicationRecord`) để vẽ mảnh "Icon nguồn"; đổi nguồn thì phát notify này.
- **[ĐÃ ĐO]** `dev.bechou.le.gmaps.debug.v1.%@.%@`, `dev.bechou.le.gmaps.caught-exception`: kênh log/debug nội bộ giữa các process.

---

## 3. Cấu trúc trang cài đặt

- **[ĐÃ ĐO]** `Le.plist` (PreferenceLoader): entry `PSLinkCell`, label "Lề", bundle `LePrefs`, detail `CWTrafficBubblePrefsController`. Info.plist của bundle: `CFBundleIdentifier = dev.bechou.le.bubble.preferences`, `NSPrincipalClass = CWTrafficBubblePrefsController`, vùng phát triển `vi`.
- **[ĐÃ ĐO]** Controller gốc chỉ là vỏ chứa (`CWLePageHost` + 3 trang con); giao diện tự dựng bằng UITableView thường, không dùng PSSpecifier cho phần chính (chỉ trang Chẩn đoán mới dùng `specifiers` kiểu PSListController).
- **Trang gốc "Lề"** (`CWLeRootPage`, slogan "Liếc là biết."):
  - Nhóm **"Nguồn dữ liệu"**: 3 ô chọn VietMap Live / GOFA / Waze (`CWLePresentationCell`), kèm nút **"Cài đặt <app>"** khi app nguồn chưa được cài.
  - Nhóm **"Cách hiện trên CarPlay"**: chọn 1 trong 4 cách hiện; footer thay đổi theo lựa chọn để giải thích thẻ/bubble sẽ hiện ở đâu.
  - Các hàng điều hướng: "Bubble nổi" (sang trang Floating), "Trong Google Maps" (sang trang Maps), "Chẩn đoán" (sang trang Diagnostics); các công tắc `wakeSource`, `closeSource`; footer cuối trang: "Lề 0.2.4".
  - Cảnh báo ngữ cảnh (`updateNotice`): "Cách hiện Chỉ Google Maps cần cài Google Maps", "Không có gì hiện trên CarPlay", …
- **Trang "Bubble nổi"** (`CWLeFloatingPage`): trên cùng là **bản xem trước trực tiếp** (`CWLeFloatingStage`, vẽ bằng đúng engine runtime với dữ liệu mẫu "32 km/h, giới hạn 50"…), dưới là các mục ở bảng 2.2 + Đặt lại mặc định.
- **Trang "Trong Google Maps"** (`CWLeMapsPage`): bản xem trước thẻ trên từng màn hình (`CWLeMapsStage`), các nhóm: "Kích thước và vị trí", "Module", "Thứ tự", "Kiểu thẻ", các mục ở bảng 2.4.
- **Trang "Chẩn đoán"** (`GVMDiagnosticsController`): xem §4.3.
- **Link/hướng dẫn**: không có URL web trong binary (xem §4.4). "Hướng dẫn" duy nhất là các footer giải thích ngay trong trang (đã trích ở §2) và trang Depiction trên repo (§5.1). Nút cài app nguồn mở App Store bằng `itms-apps://apps.apple.com/app/id%@` qua `SKStoreProductViewController` (`-[CWLeRootPage openStore:]`, app id lấy theo bundle id `vn.vietmap.live`, `com.lumi.GOFA`, `com.waze.iphone`, `com.google.Maps`) **[ĐÃ ĐO]**.

---

## 4. LePrefs chứa gì ngoài UI cài đặt

Binary LePrefs nặng 1.282.064 byte, 28 class — lớn bất thường cho một preference bundle. Thành phần ngoài UI:

### 4.1 Nguyên engine vẽ của runtime (để xem trước trung thực)

- **[ĐÃ ĐO]** Các class `CWTrafficBubbleView`, `CWTrafficBubbleContent`, `CWTrafficBubbleArrangement`, `CWTrafficBubblePiece`, `CWTrafficBubbleSign`, `CWTrafficBubbleLane`, `CWTrafficBubbleCanvas` và `GVMHaloSpeedCard`, `GVMClassicSpeedCard`, `GVMLeTileCard`, `GVMHaloLaneStrip`, `GVMOutputEndpoint` nằm ngay trong LePrefs. Đây là cùng mã vẽ bubble/thẻ mà các dylib runtime dùng; trang cài đặt dùng chúng để vẽ bản xem trước (preview) giống hệt khi chạy thật. Hệ quả: LePrefs không phải "UI thuần" — nó là một bản sao đầy đủ của tầng trình bày.

### 4.2 Dữ liệu biển báo + đối chiếu hash ảnh

- **[ĐÃ ĐO]** Bảng ánh xạ mã biển → tên file ảnh (camera, no-passing, railway, residential-area, toll, tunnel, restriction…, cả biến thể Waze `waze_*` và tên tiếng Việt: "Khu dân cư", "Cấm vượt", "Trạm thu phí"…).
- **[ĐÃ ĐO]** Một bảng dài các chuỗi SHA-256 (hơn 80 mục) đi cặp với tên ảnh biển (`speed_limit_10.png` … `speed_limit_120.png`, `limit_80.png`, `khu_dan_cu.png`…) cùng các trường `imageSHA256`, `recognizedAsset`, `imageCharacters`, `imageBytes`: cơ chế **đối chiếu hash ảnh biển nhận diện được** (ảnh do nguồn VietMap chụp/nhận diện) để khớp về đúng loại biển trước khi hiển thị.

### 4.3 Trang Chẩn đoán (`GVMDiagnosticsController`)

- **[ĐÃ ĐO]** Tự dựng báo cáo text gồm: trạng thái các kênh ("card channel", "over bubble"), loại jailbreak (chuỗi `roothide (jbroot)`, `rootless (/var/jb)`, `roothide Dopamine`, kiểm tra `basebin/bsctl`, `basebin/jbctl`), tiến trình CarPlay (`/System/Library/CoreServices/CarPlay.app/CarPlay`, `hw.machine`), phiên bản các app nguồn, nội dung các file trạng thái `/var/mobile/Library/Caches/dev.bechou.le.bubble/host.txt`, `presence.log`, `cast.log` và log `/var/mobile/Library/Logs/le-supervisor.log`.
- **[ĐÃ ĐO]** Tuỳ chọn **"Đính kèm báo cáo sự cố liên quan"**: quét `/var/mobile/Library/Logs/CrashReporter` và `/Library/Logs/CrashReporter`, lọc crash liên quan (trường `crash`, `jetsamevent`, `excuserfault`…).
- **[ĐÃ ĐO]** Ba thao tác: Làm mới (`refreshReport`), Sao chép (`copyReport`), Xuất file `Le-diagnostics.txt` (`exportReport:`, tiền tố tên `Le-diagnostics-`). Văn bản trong trang ghi rõ: "Sao chép hoặc xuất để gửi hỗ trợ; **không tự gửi dữ liệu**" và cảnh báo crash đính kèm "có thể chứa thông tin thiết bị và ứng dụng; xem lại trước khi gửi".

### 4.4 License / mạng / telemetry / quảng cáo — kết luận phủ định có bằng chứng

- **License/bản quyền: KHÔNG CÓ** trong LePrefs. **[ĐÃ ĐO]** Không chuỗi license/serial/trial/receipt/activate; StoreKit chỉ được link để dùng `SKStoreProductViewController` (mở trang App Store của app nguồn — `llvm-nm -u` chỉ thấy `SKStoreProductViewController`, `SKStoreProductParameterITunesItemIdentifier`, `loadProductWithParameters:completionBlock:`; không có `SKPaymentQueue`, `SKProduct`, product identifier mua hàng). Không có paywall.
- **Gọi mạng: KHÔNG CÓ**. **[ĐÃ ĐO]** Toàn bộ dump chuỗi của LePrefs không chứa bất kỳ URL `http://`/`https://` nào (0 kết quả); không import NSURLSession/NSURLConnection/CFNetwork; symbol `NSURL` chỉ phục vụ file URL cục bộ. URL web duy nhất của cả gói nằm ở trường `Depiction` trong control (§5.1), không nằm trong binary.
- **Telemetry/analytics: KHÔNG CÓ**. **[ĐÃ ĐO]** Không chuỗi/SDK dạng Firebase, Crashlytics, Sentry, Amplitude, Mixpanel; báo cáo chẩn đoán không tự gửi (§4.3).
- **Quảng cáo: KHÔNG CÓ** dấu vết framework quảng cáo hay vùng chứa quảng cáo trong LePrefs **[ĐÃ ĐO qua danh sách class + chuỗi]**.
- Lưu ý phạm vi: các kết luận phủ định trên là cho **binary LePrefs**; chúng không tự động áp cho 9 dylib còn lại của gói.
- **[ĐÃ ĐO]** Lệch version nội bộ: chuỗi version trong LePrefs là `0.2.4` (khớp gói), nhưng Info.plist của bundle vẫn ghi `CFBundleShortVersionString = 0.1.0`, `CFBundleVersion = 1` — dấu vết bundle được giữ nguyên từ thời 0.1.0.

---

## 5. Về gói (CONTROL)

### 5.1 `control` — đọc nguyên văn

```
Package: dev.bechou.le
Name: Lề
Description: Tốc độ, biển giới hạn, biển báo và làn đường trên CarPlay, từ VietMap Live, GOFA hoặc Waze: bubble nổi trên mọi màn hình và thẻ trong Google Maps.
Maintainer: bechou
Author: bechou
Section: Tweaks
Depiction: https://repo.bechou.dev/le-traffic
Depends: firmware (>= 15.0), firmware (<< 27.0), mobilesubstrate, preferenceloader
Conflicts: org.carwidget.traffic-bubble, org.carwidget.traffic-runtime, com.chou.googlemaps.vietmap
Replaces: org.carwidget.traffic-bubble, org.carwidget.traffic-runtime
Architecture: iphoneos-arm64
Version: 0.2.4
Installed-Size: 5216
```

- **[ĐÃ ĐO]** `Depends`: iOS >= 15.0 và < 27.0 (tức iOS 15–26), `mobilesubstrate`, `preferenceloader`. Không phụ thuộc tweak nào khác.
- **[ĐÃ ĐO]** `Architecture: iphoneos-arm64` — bản rootless (cây file nằm dưới `/var/jb`).
- **[ĐÃ ĐO]** `Depiction: https://repo.bechou.dev/le-traffic` — trang mô tả sản phẩm trên repo riêng của tác giả (bechou.dev); đây là nơi chứa hướng dẫn/screenshot chính thức thay cho depiction trong app.
- **[ĐÃ ĐO]** Thư mục CONTROL của bản 0.2.4 chỉ có `control` và `postinst` — **không có prerm/preinst**.

### 5.2 `postinst` — phân tích từng lệnh

Toàn văn logic (script `#!/bin/sh`, `set -eu`):

1. `launchctl print system/dev.bechou.le.relay` — kiểm tra LaunchDaemon relay của bản cũ còn đăng ký không; nếu còn: `launchctl bootout system/dev.bechou.le.relay || true` — dừng và hủy đăng ký daemon.
2. `rm -rf` bốn đường dẫn (mọi lệnh đều có `|| true`):
   - `/var/jb/Library/LeRelay` — thư mục dữ liệu của relay cũ.
   - `/var/jb/Library/LeRelaySummary` — thư mục dữ liệu tổng hợp của relay cũ.
   - `/var/mobile/Library/Caches/dev.bechou.le.relay` — cache/socket của relay trong home mobile thật.
   - `/rootfs/var/mobile/Library/Caches/dev.bechou.le.relay` — cùng thư mục đó nhưng qua đường rootfs mà script của jailbreak **roothide** dùng để chạm tới `/var/mobile` thật (comment trong script giải thích đúng điều này).

Nhận xét:

- **[ĐÃ ĐO]** Comment đầu script tự nói rõ lịch sử: "Up to 0.2.4~beta8 Lề ran a root relay as a LaunchDaemon. The earlier package's prerm stops it on upgrade, and dpkg removes its files; this stops it should it still run and removes what it wrote. Nothing here can fail the install." — Tức tới bản beta8 của 0.2.4, Lề vẫn chạy **một relay với quyền root dưới dạng LaunchDaemon** (`dev.bechou.le.relay`); prerm của gói cũ dừng nó khi nâng cấp, còn postinst này là lớp dọn dự phòng.
- **[ĐÃ ĐO]** Gói 0.2.4 cuối cùng **không còn LaunchDaemon**: trong cây file trích ra không có plist daemon nào, và kiến trúc hiện tại dùng các dylib relay chạy trong process (`LeGoogleRelay`, `LeGuidanceRelay`) thay cho daemon root riêng. **[SUY LUẬN]** Việc bỏ daemon root là một thay đổi kiến trúc có chủ đích ở 0.2.4 (giảm bề mặt đặc quyền: không còn tiến trình root thường trực của bên thứ ba), đồng thời là lý do postinst phải dọn "vết" của bản cũ.
- **[ĐÃ ĐO]** Về quyền: postinst chạy bằng quyền root (maintainer script của dpkg) và có `rm -rf`, nhưng phạm vi xoá giới hạn đúng 4 đường dẫn thuộc về chính sản phẩm (2 thư mục `LeRelay*` trong `/var/jb/Library`, 2 bản của thư mục cache `dev.bechou.le.relay`); mọi thao tác đều `|| true` nên không thể làm hỏng quá trình cài đặt — kể cả khi `set -eu` đang bật.
- **[ĐÃ ĐO]** postinst **không** respring, không kill process nào khác, không đụng tới file của app/tweak khác, không tải gì từ mạng.

### 5.3 Conflicts / Replaces — lịch sử sản phẩm

- **[ĐÃ ĐO]** `Conflicts` + `Replaces` cùng lúc với `org.carwidget.traffic-bubble` và `org.carwidget.traffic-runtime`: dpkg sẽ tự gỡ hai gói cũ này khi cài Lề (Replaces = thay thế êm, không bắt người dùng gỡ tay).
- **[ĐÃ ĐO]** `Conflicts` (nhưng **không** Replaces) với `com.chou.googlemaps.vietmap`: cài Lề thì không được để gói kia tồn tại, nhưng dpkg không tự thay thế nó.
- **[SUY LUẬN — bằng chứng mạnh]** Lề là **bản kế nhiệm đổi tên của dòng "CarWidget Traffic"**: (1) hai gói bị thay thế mang tên `org.carwidget.traffic-*`; (2) toàn bộ mã nguồn của Lề vẫn giữ tiền tố class **CW** (CarWidget): class điều khiển cài đặt tên nguyên `CWTrafficBubblePrefsController`, các class vẽ `CWTrafficBubbleView/Content/Arrangement/Sign/Lane/Piece`, họ trang cài đặt `CWLe*`; (3) tác giả các gói cũ và Lề cùng một người ("bechou" / "chou" — gói xung đột thứ ba là `com.chou.googlemaps.vietmap`, một tweak đưa dữ liệu VietMap vào Google Maps của cùng tác giả, bị Lề thay thế về chức năng nên phải xung đột để tránh hai tweak cùng can thiệp vào Google Maps).

---

## 6. Font Saira kèm gói

- **[ĐÃ ĐO]** Thư mục `/var/jb/usr/share/le/gmaps/fonts/` chứa 4 file: `Saira-Bold.ttf`, `Saira-Medium.ttf`, `Saira-SemiBold.ttf`, `SairaCondensed-Bold.ttf` và file giấy phép `OFL.txt`.
- **[ĐÃ ĐO]** Nội dung đầu `OFL.txt`: "Copyright 2016 The Saira Project Authors (omnibus.type@gmail.com), with reserved font name "Saira"" — font được phát hành theo **SIL Open Font License, Version 1.1** (toàn văn license nằm trong chính file OFL.txt).
- **[ĐÃ ĐO]** Mã của LePrefs/LeGoogleMaps nạp font từ đường dẫn `/usr/share/le/gmaps/fonts` với các tên `Saira-Medium`, `Saira-SemiBold`, `Saira-Bold`, `SairaCondensed-Bold` để vẽ số tốc độ/giới hạn trên thẻ và bubble (kèm `SFProCondensed-Semibold` của hệ thống trong một số biến thể thẻ).
- Nhận xét: việc đóng gói kèm nguyên văn OFL.txt đáp ứng đúng điều kiện phân phối lại của SIL OFL 1.1 (giữ thông báo bản quyền + license, không bán riêng font); "Saira" là reserved font name theo khai báo trong license. **[ĐÃ ĐO]**

---

## 7. Tóm tắt đếm key

- File `layout-v1.json`: **3 key người dùng cấp cao nhất** (`source`, `wakeSource`, `closeSource`) + **6 key trong nhóm `bubble`** (`arrangement`, `background`, `backgroundOpacity`, `scale`, `overspeedBlink`, `modules`) + key kỹ thuật `schemaVersion` (×2 vị trí).
- Nhóm tổng trang gốc: **5 key** (`presentation`, `bubbleEnabled`, `fullEnabled`, `phoneEnabled`, `interfaceStyle`).
- Nhóm thẻ Google Maps (CFPreferences `dev.bechou.le.gmaps`): **≈13 key/nhóm key** (Enabled ×3 màn hình, Position ×3, Scale ×3, phoneXPercent, phoneYPercent, Layout, overspeedScope/mode, bubble-modules) — chưa tính các key trạng thái runtime.
- **Tổng cộng ≈ 27 key cài đặt người dùng** (không tính key kỹ thuật, kênh notify và trạng thái runtime).
