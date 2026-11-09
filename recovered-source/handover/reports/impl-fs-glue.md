# IMPL FS1 — STRAND B: điểm tham vấn duy nhất + keo vòng đời

Trạng thái: **XONG** — keo hoàn tất cả hai cây, module SplitScreen build sạch
trọn vẹn (link + ký). Baseline chụp tại `/tmp/fs1-baseline/` trước khi sửa;
cả ba file đều identical giữa hai cây trước sửa (SHA-256 khớp từng cặp).

## 1. Các thay đổi (file:line theo cây project/)

### `OmniCarSplitScreen/SCPCarSplit+Layout.m` (mirror: `src/SplitScreenB/`)
- `:21` — thêm `#import "SCPFullscreenController.h"`.
- `:513–521` — **đúng một dòng tham vấn** tại return duy nhất của
  `appAreaInParent:` (thân gốc :407–512): `return area;` →
  `return [[SCPFullscreenController shared] fsAreaForParent:parent nativeArea:area split:self];`
  kèm comment §4.3. Diff toàn file so với baseline = chỉ 2 hunk này;
  mọi câu lệnh còn lại của thân hàm khớp trước/sau từng dòng. Khi
  controller không trả target, `area` gốc được trả nguyên vẹn (kỷ luật
  của chính `fsAreaForParent:` theo thiết kế §4.3).
- Cổng: `grep -c SCPFullscreenController` trong Layout.m = 2 (1 import +
  1 điểm gọi); số lần gọi controller từ thân hàm = **1**.

### `OmniCarSplitScreen/SCPHooks.m` (mirror: `src/SplitScreenA/`)
- `:19` — thêm import controller.
- `:329–334` — seam `Hook_RootVC_viewDidLayoutSubviews`: cộng khối
  `@try { [[SCPFullscreenController shared] fsDidLayout]; } @catch ...`
  ngay sau khối `syncArming` của pinch (§4.8). Hai khối wake/pinch sẵn
  có không đổi một ký tự.
- `:797–803` — cuối `__init_1`, ngay sau `[[SCPCarSplit shared] bwInstallOwner];`:
  cộng `[[SCPFullscreenController shared] fsInstallIfNeeded];` (§4.1).
- Cổng: số `MSHookMessageEx` trước = sau = 31 → **không hook runtime mới**.

### `OmniCarSplitScreen/SCPCarSplit.m` (mirror: `src/SplitScreenA/`)
- `:28` — thêm import controller.
- `:251` — trong `dashboardInvalidated`, tại đúng điểm `self.active = NO`
  (cùng điểm "setActive:NO" của wake1): cộng một dòng
  `[[SCPFullscreenController shared] fsSessionDidEnd];` ngay sau dòng
  pinch `detach`. Dòng `bwSessionTeardown` và pinch giữ nguyên (§4.6 —
  restore rút gọn: hạ cờ, khôi phục clips/chrome, phát NO, không relayout).

### `OmniCarSplitScreen/Makefile` (chỉ cây project — cây src không có Makefile)
- FILES: thêm `SCPFullscreenController.m` (đặt cạnh `SCPFullscreenAdapter.m`).
  Đếm: controller TU = 1, adapter TU = 1 (adapter đã có từ wake1, không trùng).

## 2. Giao diện controller — giả định → đối chiếu THẬT

Khi bắt đầu, `impl-fs-controller.md` và file controller đều chưa tồn tại;
keo được cài theo thiết kế §4. Trong lúc làm, Strand A land
`SCPFullscreenController.h/.m` (cây project) — đã đối chiếu trực tiếp:

| Tên keo dùng | Thiết kế | Header thật (Strand A) | Kết quả |
|---|---|---|---|
| `+shared` | §4.3 (nguyên văn) | `+ (instancetype)shared` | khớp |
| `fsAreaForParent:nativeArea:split:` | §4.3 (nguyên văn) | giống hệt | khớp |
| `fsDidLayout` | §4.8 | giống hệt | khớp |
| `fsSessionDidEnd` | §4.6 | giống hệt | khớp |
| `fsInstall` (giả định ban đầu) | §4.1 không đặt tên | **`fsInstallIfNeeded`** | **đã sửa keo theo tên thật** (SCPHooks.m cả hai cây) + mirror lại |

## 3. Đăng ký controller ↔ pinch adapter: KHÔNG cần keo

Thiết kế §4.9 + header thật xác nhận: adapter tự đặt
`controller.fsStateDidChange` tại init của chính nó; pinch controller sở
hữu instance adapter của nó. Không có bước đăng ký nào ở keo — không thêm.

## 4. Build + cổng

- Toolchain kiểm trước: clang-18 ✓, ldid ✓, `/usr/bin/ld.lld` → ld.lld-18 ✓,
  SDK iPhoneOS16.5 ✓ — không phải khôi phục.
- Lần build đầu: Theos chặn ở pre-check "File SCPFullscreenController.m
  does not exist" (Strand A chưa land) — đúng phụ thuộc đã dự kiến.
- Ba TU keo biên dịch riêng chống header THẬT: Layout 0 lỗi, SCPHooks 0 lỗi,
  SCPCarSplit 0 lỗi (chỉ các lớp warning có sẵn của module).
- Sau khi Strand A land + tự sửa lỗi `-Werror deprecated-declarations`
  (`UIApplication.windows` tại controller :208 — file của Strand A, ngoài
  phạm vi B): `make clean && make` module SplitScreen **thành công trọn
  vẹn** — Linking + Signing, dylib 1.241.080 B. Bốn selector FS có mặt
  trong dylib: `fsAreaForParent:nativeArea:split:`, `fsDidLayout`,
  `fsInstallIfNeeded`, `fsSessionDidEnd`.
- Mirror cuối: cả ba file identical giữa project/ và src/ (cmp).
- Grep cấm trong các file keo: `OMCChromeSetHidden` = 0; không đụng điểm
  gọi BridgeWake nào (diff chứng minh chỉ cộng, không sửa).

## 5. Đối chiếu cuối với giao diện CHÍNH THỨC (impl-fs-controller.md)

Sau khi B hoàn tất, Strand A chốt giao diện tại mục "Giao diện công khai
cho strand B dùng" của `impl-fs-controller.md` — đối chiếu từng điểm:

| Điểm keo | Tên chính thức | Keo B đã dùng | Kết quả |
|---|---|---|---|
| `__init_1` cạnh bwInstallOwner | `fsInstallIfNeeded` | `fsInstallIfNeeded` (SCPHooks.m:803) | khớp — tên giả định ban đầu `fsInstall` đã sửa trước khi chốt |
| Return `appAreaInParent:` | `fsAreaForParent:parent nativeArea:area split:self` | giống hệt (Layout.m:520–521) | khớp |
| Seam rootDidLayout | `fsDidLayout` | giống hệt (SCPHooks.m:333) | khớp |
| `dashboardInvalidated` | `fsSessionDidEnd` | giống hệt (SCPCarSplit.m:251) | khớp |
| Makefile | +1 TU `SCPFullscreenController.m` | đã thêm, đếm = 1 | khớp |
| Adapter | không cần keo (tự đăng ký `fsStateDidChange` lúc `-init`) | không thêm | khớp |

Ngữ nghĩa tham vấn theo đặc tả chính thức: controller trả target CHỈ
KHI cờ nội bộ đã lật + phase ∈ {Expanding, Expanded} + parent == parent
snapshot + `split.active` + target hợp lệ; ngoài ra trả `nativeArea`
nguyên vẹn — đúng kỷ luật keo B đã ghi ở comment §4.3.
Grep kiểm cuối: `] fsInstall]` (tên sai) = 0 ở cả hai cây; mirror keo
identical; controller cũng đã mirror sang `src/SplitScreenA/` identical;
dylib module 1.241.080 B đứng vững trên các source hiện tại.
