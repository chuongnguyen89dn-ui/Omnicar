# A1 — CỔNG SỐ MỘT CỦA PINCH: đích fullscreen QA20 có điều khiển được từ ngoài không?

> Strand chỉ-đọc/phân tích trên binary QA20 (không sửa source rebuilt, không build candidate,
> không thực thi binary). Mọi địa chỉ là offset trong chính dylib được phân tích.

## KẾT LUẬN BẮT BUỘC

**FULLSCREEN_ENTRY = BLOCKED.**

Không tồn tại đường hợp lệ nào để một adapter bên ngoài yêu cầu dylib fullscreen của QA20
bật/tắt fullscreen hoặc đọc trạng thái expanded của nó:

- Hàm toggle duy nhất `OMCToggleHost(SCPCarSplit*)` là **static** (ký hiệu local `t`,
  @0x4524) và có **đúng một điểm gọi trong toàn binary**: `-[OMCZoomAction pressed:]`
  @0x44a8.
- Đối tượng action đó do chính dylib tạo ra bên trong `OMCInstallTwoActionMenu`, được giữ
  duy nhất bằng associated object gắn trên nút zoom nội bộ; nút và state đều nằm sau
  associated object của split với **khóa là địa chỉ tĩnh nội bộ của dylib** (ô tại
  0x14ab8) — không accessor, không shared instance, không class method nào công bố.
- Kênh notification duy nhất của dylib (`com.anlai.omnicar.zoom.chrome.v1`) là kênh
  **phát trạng thái chrome một chiều ra ngoài** (CarPlayApp → SpringBoard), không phải
  kênh lệnh vào; không có observer nào trong binary lắng nghe lệnh toggle. Dylib **không
  import CFNotificationCenter** (không có kênh Darwin nào).
- Symbol toàn cục duy nhất liên quan, `_OMCChromeSetHidden` (@0xa798, exported `T`),
  điều khiển **chrome thanh trạng thái phía SpringBoard**, không phải toggle host —
  gọi riêng nó chỉ làm lệch đồng bộ chrome/fullscreen.

Chi tiết bằng chứng ở các mục dưới. Hệ quả theo work order: dừng tích hợp hành vi pinch,
chỉ bàn giao báo cáo này; không gọi offset tuyệt đối, không đoán selector.

## 1. Nhận dạng vật phân tích

- DEB nguồn: `com.anlai.omnicar_1.0.3-omnicar20-divider-knob-idle_iphoneos-arm64.deb`
  (bản tại `handover/` và bản tại `omnicar-pinch/unified/qa20.deb` cùng dung lượng
  1.347.488 B). SHA-256 của DEB (bản handover):
  `405faaafad91948796cf2578b5d8238a1466cd6f4fe3a5c3888a500ca8c6eb19`.
- File trích: `var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarDoubleTapFullscreen.dylib`
  - Dung lượng: **125.808 byte** ✓ (khớp dự kiến)
  - MD5: **`944d6f37c9ce327298dd6edd1d1a3bd8`** ✓ (khớp dự kiến)
  - SHA-256: `d532e70ed0e348327de50d4fea3f82fac1db82fb96b87a052d419b00c3271b55`
  - Kiến trúc: **thin arm64, KHÔNG phải FAT** (llvm-lipo: "Non-fat file … arm64") —
    không có slice arm64e. iPhone X (arm64) nạp được, nhưng đây là khác biệt cần ghi
    nhận so với 8 binary gốc 1.0.3 (đều FAT arm64+arm64e).
  - Filter (plist đi kèm): Bundles = `com.apple.CarPlayApp`, `com.apple.springboard`
    → dylib nạp vào **CarPlayApp và SpringBoard**.
  - Dependency (LC_LOAD_DYLIB): chỉ thư viện hệ thống — libobjc, Foundation,
    CoreFoundation, UIKit, QuartzCore, libc++, libSystem. Hook qua `MSHookMessageEx`
    (import từ substrate, không link trực tiếp).
  - Provenance trong binary: đường build `/Users/runner/work/Omnicar/Omnicar/.theos/obj/
    debug/arm64/src/` từ hai file nguồn `OmniCarDoubleTapFullscreen.xm` +
    `OmniCarChrome.xm` — bản **debug** (NSLog dày đặc, assertion còn nguyên).

## 2. Census: class/method/hook + đối chiếu ABI với SCPCarSplit của cây rebuilt

Dylib định nghĩa đúng **4 class** (không category, không class method nào):

| Class | Nội dung chính |
|---|---|
| `OMCZoomState` | State theo từng split: `expanded` (BOOL), `originalArea` (CGRect), `layoutParent`, `previousClipsToBounds`, `oldSubviewHidden`, `oldMenuGestures`, `nativeDivider`, `menu`, `menuCover`, `button`, `swapButton` |
| `OMCZoomAction` | Thuộc tính `split`; hành động `pressed:` — điểm gọi duy nhất của toggle |
| `OMCSwapAction` | Thuộc tính `split`, `divider`; `pressed:` → đường swap native riêng |
| `OMCChromeReceiver` | `received:` — observer của kênh chrome phía SpringBoard |

Hook cài bằng MSHookMessageEx / Logos:

- Trên **SCPCarSplit** (nhóm ungrouped): `setActive:`, `hideRatioMenu`,
  `appAreaInParent:`, `ratioPresetTapped:`, `dividerDoubleTapped:`,
  `showRatioMenuForDivider:`.
- Trên **DBStatusBarWindow** và **CARStatusBarWindow**: `layoutSubviews` (phần chrome
  phía SpringBoard, cài bởi `OMCTryInstallChrome` có retry dispatch_after ~0,5 s × 40).

Đối chiếu với cây rebuilt fixround7: cả 6 selector đều tồn tại trong class gốc
(census `metadata/raw/OmniCarSplitScreen/objc.json` có đủ, gồm `setActive:`) và trong
header rebuilt `SCPCarSplit.h` với chữ ký khớp: `appAreaInParent:(UIView*) → CGRect`
(dòng 276), `dividerDoubleTapped:(UITapGestureRecognizer*)` (330),
`showRatioMenuForDivider:(SCPCarDividerView*)` (341), `hideRatioMenu` (342),
`ratioPresetTapped:(UIButton*)` (343); `setActive:` đến từ
`@property (nonatomic) BOOL active` (dòng 31, setter tổng hợp `setActive:(BOOL)`).
→ **Tương thích ABI ở mức selector/chữ ký: ĐẠT.** Rào cản của cổng A1 không nằm ở hook
tương thích, mà ở entry điều khiển (mục 3).

_ctor_ của dylib rẽ theo bundle id process: `com.apple.carplay` / `com.apple.carplayapp`
→ phần zoom (OMCTryInstall, chờ class SCPCarSplit xuất hiện); `com.apple.springboard` /
`com.apple.dashboard` → phần chrome (OMCChromeEntry + OMCTryInstallChrome).

## 3. Săn entry điều khiển — mọi đường đã kiểm và vì sao không đường nào đạt

### 3.1. Hàm toggle: static, một điểm gọi nội bộ duy nhất

`__ZL13OMCToggleHostP11SCPCarSplit` @0x4524 là hàm C static (ký hiệu local). Quét toàn
binary: `bl OMCToggleHost` xuất hiện **đúng 1 lần**, tại 0x44a8 trong
`-[OMCZoomAction pressed:]` (hàm này chỉ log "zoom-pressed" rồi gọi
`OMCToggleHost([self split])`). Ngay cả đường double-tap lên divider cũng **không** gọi
toggle: hook `dividerDoubleTapped:` (@0x72d0) chỉ kiểm một cờ tĩnh (ô 0x14aba) rồi hoặc
chặn (log "legacy-doubletap-swapping-blocked") hoặc gọi IMP gốc — fullscreen trong QA20
thực tế được kích từ **nút zoom của menu hai nút** mà hook `showRatioMenuForDivider:`
cài vào (`OMCHideMenuControls` → IMP gốc → `OMCInstallTwoActionMenu` @0x6f30).

### 3.2. Đường nút/action: tồn tại nhưng không phải entry ổn định

Trong `OMCInstallTwoActionMenu` (đoạn @0x9054–0x90dc): tạo `OMCZoomAction` bằng
`objc_opt_new`, `setSplit:`, rồi `objc_setAssociatedObject(button, key, action)` @0x9094
để giữ action (vì UIControl không retain target), sau đó
`[button addTarget:action action:@selector(pressed:) forControlEvents:TouchUpInside]`
@0x90b4 và `[state setButton:button]`. Tức đường chạm tới toggle từ ngoài chỉ còn:
tìm được đúng nút zoom nội bộ trong cây view của menu → `sendActionsForControlEvents:`
hoặc lấy associated action → `pressed:`. Đường này **không đạt chuẩn cổng**:

- Nút/action **chỉ tồn tại sau khi menu tỉ lệ được mở ít nhất một lần** (menu được cài
  bởi hook showRatioMenu) — không gọi được "khi menu fullscreen không hiển thị" theo
  yêu cầu của GPT, và càng không gọi được lúc pinch cần (đang ở split bình thường).
- Nhận diện "đúng nút" buộc phải rình cấu trúc view nội bộ + associated object của
  dylib — đó là chi tiết cài đặt nội bộ, không phải ABI ổn định đã công bố.

### 3.3. Kênh notification: có, nhưng là kênh RA, không phải kênh lệnh

- Bên gửi — `OMCChromeSetHidden(BOOL)` @0xa798: nếu process hiện tại đã ghi nhận được
  cửa sổ chrome (phía SpringBoard) thì áp `OMCApplyChromeVisibility` tại chỗ; nếu không
  (phía CarPlayApp) thì lấy `NSClassFromString(@"NSDistributedNotificationCenter")` →
  `defaultCenter` → `postNotificationName:@"com.anlai.omnicar.zoom.chrome.v1"`
  object nil, userInfo = `{@"version": @1, @"hidden": @(BOOL)}` (hai khóa tại 0xe13f /
  0xe149, tên kênh tại 0xe11e, đã giải mã CFString).
- Bên nhận — `OMCChromeEntry` (phía SpringBoard) đăng ký đúng **một** observer trong
  toàn binary (điểm gọi addObserver duy nhất @0xaf8c): tạo `OMCChromeReceiver`, giữ ở ô
  tĩnh 0x14b00, `addObserver:selector:@selector(received:) name:@"com.anlai.omnicar.
  zoom.chrome.v1" object:nil` trên NSDistributedNotificationCenter.
  `-[OMCChromeReceiver received:]` @0x9d74 chỉ kiểm `userInfo[@"version"] == @1` và
  `userInfo[@"hidden"]` là NSNumber, rồi dispatch về main queue →
  `OMCApplyChromeVisibility([hidden boolValue])` — **chỉ hiện/ẩn chrome thanh trạng
  thái**, không hề chạm tới toggle/state của host.
- Không có import `CFNotificationCenter*` nào (quét undefined symbols: rỗng) → không
  kênh Darwin. Không có observer thứ hai nào khác.

→ Kênh này là **báo cáo trạng thái chrome** phục vụ đồng bộ SpringBoard. Gửi lệnh giả
vào kênh này từ adapter chỉ làm chrome ẩn/hiện, không mở/khôi phục được fullscreen.

### 3.4. Symbol exported duy nhất: đúng chrome, sai chức năng

`_OMCChromeSetHidden` là ký hiệu toàn cục (`T`) — về kỹ thuật một dylib cùng process
có thể dlsym/link tới nó. Nhưng như 3.3, nó chỉ điều khiển chrome (và NSDistributed
broadcast), không gọi toggle. Dùng nó để "giả vờ fullscreen" sẽ tạo lệch trạng thái:
chrome ẩn trong khi host không hề expanded, và lần toggle thật sau đó sẽ phát
`OMCChromeSetHidden` ngược lại. **Không phải entry của đích fullscreen.**

### 3.5. Đọc trạng thái expanded từ ngoài: không có đường

`OMCState(split)` @0x5df8 lấy state bằng `objc_getAssociatedObject(split, key)` với
**key là con trỏ tại ô tĩnh 0x14ab8 trong __DATA của chính dylib** (chưa có thì tạo
`OMCZoomState` mới và `objc_setAssociatedObject` với policy RETAIN_NONATOMIC). Danh
tính của khóa associated object là chính địa chỉ đó — bên ngoài không thể nêu tên khóa
mà không chép offset tuyệt đối từ binary (bị cấm bởi work order). Không có hàm getter
exported, không class method, không kênh truy vấn trạng thái nào. Kênh chrome ở 3.3 là
fire-and-forget về chrome, không phải API truy vấn `expanded` (nó cũng được phát trong
các tình huống không đổi expanded, vd quanh thao tác swap — xem mục 4).

## 4. Cơ chế trạng thái của dylib (bằng chứng tĩnh)

- **Nơi lưu**: `OMCZoomState` gắn associated object lên từng instance SCPCarSplit
  (mục 3.5). Hoàn toàn **trong bộ nhớ**: binary không import NSUserDefaults /
  CFPreferences / writeToFile / NSKeyedArchiver (quét undefined symbols: rỗng) → không
  có gì tồn tại qua restart process.
- **Expand** (nhánh `expanded == NO` của OMCToggleHost, từ @0x4708): kiểm `split.active`
  và container có window (không đạt → log "skip reason=inactive/host-unavailable" và
  thoát); chụp snapshot: `originalArea = [split appAreaInParent:superview]` + bounds
  cửa sổ trong parent (OMCWindowBoundsInParent), kiểm OMCAreaValid; lưu `layoutParent`
  và `previousClipsToBounds`; ẩn controls của menu (OMCHideMenuControls), set
  `expanded = YES`, gọi `OMCChromeSetHidden(YES)` @0x4a0c, cuối hàm `OMCRefreshButton`.
- **Restore** (nhánh từ @0x4bc8): đọc lại `originalArea`/`layoutParent`, gọi
  `[split relayoutAnimated:pushScenes:]` + `rootDidLayout` (đường relayout của chính
  class gốc), khôi phục `layoutParent.clipsToBounds = previousClipsToBounds`,
  `setExpanded:NO`, `setLayoutParent:nil`, `OMCChromeSetHidden(NO)` @0x4c98,
  `OMCRefreshButton`. → Cả hai chiều đều nằm **bên trong** toggle; không chiều nào có
  điểm vào riêng từ ngoài.
- **Teardown**: hook `setActive:` (từ @0x7384) khi deactivate tự gỡ một phần ngay trong
  hook: lấy associated state (getAssociatedObject @0x73c4) → nếu `expanded` thì
  `setExpanded:NO`, khôi phục clipsToBounds từ `previousClipsToBounds`,
  `setLayoutParent:nil`, `OMCChromeSetHidden(NO)` @0x7500, log
  "split-deactivate-chrome-restored". (Bản restore rút gọn này không relayout frame —
  split đang tắt nên không cần.)
- **Swap**: `OMCSwapUsingNativeCallback` phát `OMCChromeSetHidden(YES)` @0x5394 trước
  và `(NO)` @0x54fc sau thao tác swap native, kèm log "internal-native-swap-requested
  wasFullscreen=%d remainsFullscreen=%d" — fullscreen được giữ qua swap bằng chính
  state nội bộ; đây cũng là bằng chứng kênh chrome không đồng nhất 1-1 với `expanded`.
- **Reconnect**: state chết cùng instance split/process; phiên CarPlay mới = split mới
  = state mới với `expanded = NO`, và setActive:NO của phiên cũ đã phát chrome restore.
  Không có cơ chế "đọc lại trạng thái expanded sau reconnect" — theo thiết kế của
  chính dylib, sau reconnect hệ luôn ở trạng thái chưa expanded. (Mức bằng chứng: tĩnh
  — suy từ vòng đời associated object + vắng mặt persistence; chưa kiểm trên xe.)

## 5. Hệ quả cho work order

- **A1 = BLOCKED** theo đúng điều kiện dừng của GPT: không có callable fullscreen
  entry an toàn, không có đường đọc trạng thái expanded từ ngoài. Không tích hợp hành
  vi pinch điều khiển đích này; không dùng offset tuyệt đối, không đoán selector,
  không sửa binary QA20 (MD5 phải giữ nguyên).
- Muốn mở lại cổng này cần thay đổi **ở phía nguồn của GPT** (nơi có source
  `OmniCarDoubleTapFullscreen.xm`): ví dụ công bố một entry điều khiển có kiểm chứng
  (exported function hoặc selector trên class của dylib + đường đọc `expanded`) rồi
  đóng lại dylib — khi đó MD5 là của bản mới do GPT phát hành, không còn là
  `944d6f37…` nữa, và strand A1 phải kiểm lại từ đầu trên binary mới.
- Các phần không phụ thuộc đích fullscreen (Wake theo WO QA180 PORT, sửa cực núm đã
  tách patch riêng) không bị kết luận này chặn.
