# Đối chiếu thực tế AppBridge OmniCar ↔ DuoFace Native12: scene geometry (23/10/2026)

**Trạng thái:** Đã chạy audit tĩnh từ hai DEB gốc SHA-pinned trong GitHub Actions. **Chưa** chỉnh AppBridge runtime, chưa build DEB mới, chưa đo bằng YouTube trên CarPlay.

## Dữ liệu chính

- OmniCar original DEB: `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb` SHA256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`.
- DuoFace Native12 original reference DEB: `duoface-reference/dist/visual-1.0.3-12/com.duoface.app_1.0.3-12_visualtest_iphoneos-arm64.deb` SHA256 `8b7dedf77b9ec05465b83fdb6e2d7127800eac232a34ecf12f2c08b3983a481a`.
- Audit script: `scripts/audit_omnicar_layout_geometry_policy.py`, `scripts/audit_omnicar_scene_private_selectors.py`, `scripts/audit_omnicar_scene_settings_block.py`, called from workflow `.github/workflows/audit-v12-omnicar-yt-scene-machine.yml`. Raw results:
  - `audit/omnicar_native12_verified_layout_policy_20261023.json` blob `faee7ad96e2bb3ad896330aebf55a2f7a82ed89a`.
  - `audit/omnicar_original_private_scene_selectors_20261023.json` blob `422c122039bb5032bda6ba2598da23a0ef36d54e`.
  - `audit/omnicar_original_scene_settings_block_20261023.json` blob `155be3a9923151839be957d3d07ce6266845abe9`, read back and verified 2026-10-23.
- CI final read-back: run [39929982072](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39929982072), job `120335560833`, completed **SUCCESS**. Prior `39928785419`, `39929360557` and `39929670351` SUCCESS; `39929096968` and `39929241265` FAILED on first attempts to decode tagged CFString fixup pointer, later corrected in original-read-only decoder. `39929826754` CANCELLED; never treat cancelled/failed CI as acceptance.

## Những gì đã chứng minh bằng mã máy nguyên bản

### A. Kích thước và transform OmniCar

`ABHost.layoutPane:` copies content view bounds size to `d8,d9`. From PC `0xed74..0xed80`, it computes a logical frame as `FRINTA(boundsWidth/zoom)` and `FRINTA(boundsHeight/zoom)` in `d10,d11`. `0xeda4..0xedc8` constructs `CGAffineTransformMakeScale(zoom,zoom)` for the hosted content view; `0xedcc..0xeddc` centers the content at half the physical bounds. These are original native behaviors, not suggested patches.

`0xf068..0xf074` calls `ABPane.setSceneBox:` with the original physical bounds dimensions in `d8,d9`, **not** the expanded logical frame in `d10,d11`. Within `ABHost.setFrame...`, PCs `0x100d8..0x1012c` compare the saved sceneBox dimension against new bounds; matching dimensions take a center/reposition path; differing dimensions trigger `layoutPane:` again. Thus changing ONLY UIView transform could leave scene settings/native app reference size inconsistent. This mismatch is a **hypothesis** for the different YouTube controls, not confirmed cause.

DuoFace Native12 independently performs slot native-size `2×` plus round (`CBBridgedUIAppView.calculateNativeSizeForSlotRect:`) and per-axis minimum fit calculation in `updateLayout`, and refreshes both `updateLayout` and `updateSceneSettingsFrame` through `refreshSceneLayout`. Never globally copy the `2×` constant into OmniCar without scene/touch evidence.

### B. Private scene owner: exact selectors, not guesses

`ABHost.layoutPane:` obtains hosted application `appViewController`, then dynamically looks for:
- `sceneHandle` (CFString `0x36130`), callsites `0xef08,0xef18,0xef28`.
- `sceneIfExists` (CFString `0x36150`), callsites `0xef60,0xef70,0xef80`.
- `updateSettingsWithBlock:` (CFString `0x36170`), `0xefec,0xeffc,0xf048`.

All three are decoded directly from original Mach-O `__cfstring` and verified via `NSSelectorFromString`, `respondsToSelector` and `objc_msgSend`. Each dynamic branch may be bypassed when the receiver does not respond. This confirms OmniCar **does** include a private scene settings path; it does not prove the path executes when YouTube is playing.

### C. Scene settings block content (newest evidence)

The block passed to `updateSettingsWithBlock:` at `0xf048` is constructed at `0xf01c..0xf03c`. Its invoke pointer is `0xf210` and it captures `d12,d12,d13,d10,x24` in its stack block.

The exact selectors decoded from four different original `__cfstring` objects inside its invoke function are:
- `setFrame:` object `0x36190`, `NSSelectorFromString` `0xf234`, message send `0xf248`. The block loads vector data at `[x20+#0x20]` and `[x20+#0x30]` immediately before this message send.
- `setInterfaceOrientation:` object `0x361b0`, `NSSelectorFromString` `0xf254/0xf270`, guarded by `respondsToSelector` at `0xf260`, message send at `0xf280`; it loads `x2=[x20+#0x40]`.
- `setBackgrounded:` object `0x361d0`, `NSSelectorFromString` `0xf294`, guarded at `0xf2a4`, sends `w2=0` at `0xf2b8`.
- `setForeground:` object `0x361f0`, `NSSelectorFromString` `0xf2e8`, guarded at `0xf2f8`, sends `w2=1` at `0xf30c`.

This demonstrates the native OmniCar AppBridge **sends both scene frame, interface orientation and foreground/background policy** in one host layout call. It is not enough to modify only `UIView.bounds` or its `CGAffineTransform`. It remains unproven whether/when this route is used by an actual YouTube build or if the user's player display issue comes from this chain.

The separate `SBSceneView._updateReferenceSize:andOrientation:` replacement at `0x7764..0x7778` is just an `x2 > 4 ? 3 : x2` pass-through to original IMP. It is **not** the geometry owner here (see `audit/OmniCar_SBSceneView_hook_registration_and_branch_20261023.md`).

## Decision and next required test

Do NOT patch the global scaling factor or inject DuoFace dylib. Instead gather **YouTube-bundle-scoped log-only** frame/orientation/sceneBox/zoom values at `ABHost.layoutPane:` and this block's actual invocation, both split and solo; compare DuoFace `CBBridgedUIAppView.updateLayout/updateSceneSettingsFrame` with same version and app/device resolution. Include touch coordinate mapping and 3-dot menu owner. Only after corroboration implement *single owner* app-specific adapter in OmniCar, with no changes to map+map, native Solo, Zoom/Swap, 4-second timer, divider or Sileo public QA12.

**Known unchanged publication:** QA12 `com.anlai.omnicar 1.0.3-omnicar12-timer-zoom-swap`, SHA256 `f07c293a52882ab420aca49e4fe9e30d141d2cba412185938bf09ec9154685ba`; no new DEB build or iPhone test in this work.
