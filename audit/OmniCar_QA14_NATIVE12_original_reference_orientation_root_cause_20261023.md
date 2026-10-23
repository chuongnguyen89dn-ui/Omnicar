# Đã tìm được đường khác biệt QUYẾT ĐỊNH: DuoFace Native12 đặt content reference size và orientation, OmniCar QA13/14 không làm

Ngày 23/10/2026 — **đối chiếu trực tiếp mã ARM64 từ hai DEB gốc**. Phạm vi tĩnh; user đã xác nhận lỗi xoay tiếp diễn trên QA14.

## Các đầu vào đã xác minh SHA, không sửa nhị phân

- DuoFace Native12 gốc: repo `chuongnguyen89dn-ui/Duoface` commit `6193b9e77337fd1e9d586da5e5bf39742d041d2d`, `dist/visual-1.0.3-12/com.duoface.app_1.0.3-12_visualtest_iphoneos-arm64.deb`, SHA256 `8b7dedf77b9ec05465b83fdb6e2d7127800eac232a34ecf12f2c08b3983a481a`, `DuoFaceDashboard.dylib` SHA256 `bc1df854ec7a2ddfeec4cb81b080ead34b54df80143d4a8f6254bb8b618003ce`.
- OmniCar original `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb` SHA256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`; `OmniCarAppBridge.dylib` SHA256 `d99b8d00dc60f69db7b54fc1addaec6b8cb866b8dcdde6f1d85e06ce5b7d6e79`.
- **MỚI:** `scripts/audit_original_duoface_orientation_policy.py`; original selector cross-refs and fail-closed ARM64 assertions are stored in `audit/omnicar_vs_duoface_native12_orientation_selector_evidence_20261023.json` (GitHub blob `18392e3a9347ec057bc4e43c04f5c26568919dfe`). GitHub Actions run `39937793283`, job `120361496144` **SUCCESS**, report committed to OmniCar as archive commit `1f1547e84f78dbc841341319522752513660f9c1`. Previous run `39937483139` SUCCESS verified all selector references; latest verifies numeric orientation arguments too.
- This audit is **read-only static machine code**. Success is not a CarPlay/iPhone QA15 test, not proof YouTube takes a particular branch.

## PHÁT HIỆN GỐC MỚI: Bộ ba iPhone app reference-size của DuoFace

`CBBridgedUIAppView.updateSceneSettingsFrame` (original 0xad5bc–0xade4c):

1. Reads `bounds`, with fallback `carPlayUsableBounds` if invalid at `0xad620`; `calculateNativeSizeForSlotRect:` at `0xad638` computes native target size.
2. **Gets native device app view controller directly**: `0xad644..0xad664` sends `valueForKey:` with original `__cfstring` at `0x370c28`. The exact CFString content is `_deviceAppViewController` (bytes decoded directly from Mach-O at `0x308d57`). The returned object is in `x19`.
3. `0xad66c` loads selector **`setContentReferenceSize:withInterfaceOrientation:`** from original `__objc_selrefs[0x37e308]`. `0xad688` guards via `respondsToSelector:`. When supported, `0xad690..0xad6a4` sends to the device controller with the calculated native size in `d0,d1` and **`w2=1`** for interface orientation.
4. `0xad6ac` loads selector **`setContentReferenceSize:withContentOrientation:andContainerOrientation:`** from `__objc_selrefs[0x37e310]`; after `respondsToSelector:`, `0xad6c4..0xad6dc` sends native size in `d0,d1` and **`w2=1, w3=1`**, i.e. both content and container orientation parameters explicitly passed numeric 1.
5. The same reference-size selector family is attempted against the enclosing app view at `0xad6e0..0xad708` where supported, then sceneHandle/sceneIfExists, `updateSettingsWithBlock:` and other guarded lifecycle/frame setters are checked.
6. This is **native app content reference size/orientation control**, not the CarPlay screen orientation. For the public `UIInterfaceOrientation` enum, 1 = portrait, 3 = landscape right, 4 = landscape left; do not confuse different orientation domains or treat a video view rotation as the CarPlay global window rotation.

`CBBridgedUIAppView.updateLayout` (original 0xacc6c–0xad5bc) does **the SAME operation again**, independently of scene refresh:

- `0xacf9c` loads `setContentReferenceSize:withInterfaceOrientation:`, guard `0xacfb0`, sends native `d0,d1` and **`w2=1`** at **`0xacfcc`**.
- `0xacfd4` loads `setContentReferenceSize:withContentOrientation:andContainerOrientation:`, guard `0xacfe4`, sends native `d0,d1` and **`w2=1, w3=1`** at **`0xad004`**.
- This means DuoFace applies consistent reference-size/orientation policy in BOTH `updateLayout` AND `updateSceneSettingsFrame`. The parent `CBBridgedUIAppView.refreshSceneLayout` calls them in succession at **`0xade74`**, **`0xade84`**.

These selectors, their slot addresses, actual argument registers and instructions are asserted against ORIGINAL ARM64; they are not guessed method names.

## Vì sao QA13 và QA14 thất bại so với chính binary gốc

| | DuoFace Native12 GỐC | OmniCar GỐC | QA13/QA14 đã phát hành |
|---|---|---|---|
| iPhone native controller | Lookup `_deviceAppViewController` | `ABHost` uses `appViewController` / sceneHandle | Không tiếp cận `_deviceAppViewController` |
| Native reference-size | `calculateNativeSizeForSlotRect:` 2× rồi gọi `setContentReferenceSize...` | `ABHost.layoutPane:` dùng `bounds / zoom`, `CGAffineTransform` và `setSceneBox:` | Hook `zoom=0.50`; **chưa gọi reference-size setter** |
| Content/container orientation | Explicit private selector calls with value 1 (both parameters) in two paths | `effectiveOrientation:` prioritizes pane requestedOrientation; scene update writes `setInterfaceOrientation:` | QA14 pins first landscape 3/4 trong `effectiveOrientation:`; **không tái tạo 2 setter** |
| Scene refresh | `refreshSceneLayout` always connects `updateLayout` + `updateSceneSettingsFrame` | `setFrame` chooses fast path center-only or full relayout | QA13/14 only wraps original single `layoutPane:` |

- Literal selectors `setContentReferenceSize:withInterfaceOrientation:` and `setContentReferenceSize:withContentOrientation:andContainerOrientation:` **DO NOT occur in OmniCar original AppBridge dylib bytes** according to SHA-pinned binary search. This search applies to that dylib ONLY (not all of iOS or other tweaks).
- **Source-verifiable design defect:** QA14 locking *the first* landscape 3/4, without checking actual iPhone scene content reference orientation, cannot reliably reconstruct DuoFace behavior. Forcing 0.50 is not equivalent to the native 2× scene reference call. This is a stronger, source-backed explanation for the failure; the precise runtime cause of each 180° video flip is still unproven without device logs.

## Required correction approach (NOT a manufactured QA15 success)

1. In the existing OmniCar AppBridge context, find the actual hosted app controller and, when available, its `_deviceAppViewController` counterpart. Require exact YouTube bundle identity, valid method signatures and finite scene/native sizes. **Do not blindly KVC** or call an unverified private selector on an arbitrary object.
2. Port the verified *policy* from DuoFace: update native content reference size and interface/content/container orientation together with UIView frame/transform, at BOTH pane resize and scene refresh. Compare the actual reference-size convention on the device before assuming 1 always fits iOS 16/YouTube. Guard feature availability; do not modify Maps/Dock/native split.
3. Remove the brittle QA14 first-landscape lock once a scene-correct policy is proven. Keep original Solo/Zoom/Swap, divider, timer, menu, and a rollback gói QA12/QA14.
4. Measure on the real device at transition YouTube page→video fullscreen→playlist: `requestedOrientation`, ref-size, actual `_deviceAppViewController` availability, interface/content/container orientation, pane logical/physical dimensions, screen/view transform. If missing, produce trace-only candidate; avoid claiming a video fix based solely on CI.
5. Release through the existing `carplaydsp` Sileo source only when there is a specifically validated candidate and test conditions for user; never call it “đã fix 100%” until user video stays upright with normal split/solo/touch and no crash.

Current public Sileo is still **QA14** and is reported **device FAIL**, sha256 `b29108a568b96ed7447a2000bc26d451d3399c16175a966a08d3b8d09fb808ac`. **No QA15 DEB or deployment** in this evidence-gathering turn.
