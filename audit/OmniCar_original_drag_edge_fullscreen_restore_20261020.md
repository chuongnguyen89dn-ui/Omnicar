# OmniCar 1.0.3 — Kéo divider sát mép → mất nút ba chấm/không thể thu nhỏ lại

**2026-10-20 — Read-only ARM64 forensic, bản DEB GỐC, chưa sửa/build DEB.**

## Yêu cầu mới và hiện tượng do người dùng mô tả

OmniCar cho phép kéo đường chia đến sát mép để một ô chiếm màn hình mà không cần nhấn Zoom. Nhưng khi thả tay, **nút ba chấm của bố cục chia không còn**, nên không thể dùng chính nút đó để thu nhỏ về hai ô. Người dùng yêu cầu **tìm mục xử lý trong binary**, chưa yêu cầu thay đổi hành vi.

**Kết luận có bằng chứng:** đường kéo mép GỐC được thiết kế để **CLOSE một SCPCarPane**, không phải native reversible zoom. Khi còn 1 pane, hệ thống có thể chuyển sang **soloBundle/fullscreen**; các divider và nút gắn với pane đã mất không còn để mở toolbar. Hiện tượng user thấy phù hợp chính xác với mã gốc; **chưa thể gọi là lỗi lập trình không chủ ý**. Đây là hạn chế trải nghiệm khi user muốn kéo full rồi quay lại tức thời.

## Bằng chứng binary

Original DEB `/mnt/data/com.anlai.omnicar_1.0.3_iphoneos-arm64.deb`, SHA256
`d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`.

Binary `var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarSplitScreen.dylib`, FAT arm64/arm64e. Extract original arm64 slice (FAT arch offset 0x4000) to avoid mixing addresses. Parse actual Objective-C `__objc_classlist` / relative `__objc_methlist` to ground IMPs:

| Real ObjC owner selector `SCPCarSplit` | ARM64 IMP | Verified key calls |
|---|---:|---|
| `dividerPanned:` | `0x2d05c` | Dispatch to `dividerPan:state:location:translation:` |
| `dividerPan:state:location:translation:` | `0x2d210` | `closeSlot:background:` @ **0x2d6b4** |
| `mainStackDividerPan:state:location:translation:ended:` | `0x2db68` | `closeSlot:background:` @ **0x2e08c** |
| `closeSlot:background:` | `0x1d9b8` | `removePaneAt:background:` @ 0x1da78, then `afterPaneRemoved:` @ 0x1dad0 |
| `removePaneAt:background:` | `0x149a8` | Removes slot, `normalizeFractions` @ 0x14bf0, `reindexPanes` @ 0x14e40, `rebuildDividers` @ 0x14e48 |
| `rebuildDividers` | `0x14600` | Removes original divider subviews, clears `dividers`; `paneCount` @ 0x14708, **`cmp w0,#2` @ 0x1470c, `b.lt` @ 0x14710**, so recreates divider via `newDividerAt:` @ 0x14734 **only if at least 2 panes remain** |
| `afterPaneRemoved:` | `0x1db48` | `paneCount` @ 0x1db8c, branches for 0/1+ pane; `soloBundle:` @ 0x1dc0c or 0x1de90, depending content |
| `soloBundle:` | `0x1e33c` | Fullscreen/solo transition, `hostSolo:` @ 0x1e3e4, `closeGoingHome:` as relevant |
| `layoutBarForPane:` | `0x23b9c` | Access `pane.handle` @ 0x23c50; conditional `setHidden:` @ 0x23c68 |
| `toggleZoomForPane:` | `0x251b0` | **Distinct NON-destructive path:** stores `setZoomedSlot:` @ 0x252e4 and `relayoutAnimated:` @ 0x2538c, not a closeSlot call |
| `switchToLayout:` | `0x15000` | Can recreate layout `setPaneCount:` and `rebuildDividers` @ 0x154dc |
| `openRememberedPair` | `0x43cdc` | Can reopen saved pair via `openSetupLayout:apps:` @ 0x43f38 (distinct from a guaranteed visible pane restore control) |

**Thresholds from original machine code:** `dividerPan:` near-edge comparison loads IEEE-754 `0.12` at ARM64 code 0x2d524 from `__TEXT,__const` at 0x6f018, compared against computed adjacent fractions 0x2d528/0x2d534; close path goes 0x2d6b4. Pan clamping uses positive 0.04 from 0x6f1c8 and -0.04 from 0x6f1c0; these do **not** mean a reversible 4%-width pane survives after commit. MainStack variant also uses 0.12 at 0x2dee4 and the close branch 0x2e08c; it contains 0.96 from 0x6f1d8, and independent geometric constraints including 0.75 at 0x2e120, all context dependent. Do not label 0.75 a user slider close limit.

Original strings reinforce intentional design:
- `Tip: drag a divider to the edge to close that pane`.
- `CarSplit: keo vach %d sat mep -> dong o %d (%@)`.
- `CarSplit: keo vach sat mep (1 lon + 2) -> dong o %d (%@)`.
- `CarSplit: chi giu %@ -> mo toan man`.
- `CarSplit: bo phong to o %d` (separate zoom path).

## Root cause of no three-dot restore control

**Not the 4-second auto-hide timer and not the custom Zoom addon.** `closeSlot` really removes the pane, and `rebuildDividers` creates ZERO divider when `paneCount < 2`. The native `pane.handle` belongs to a pane view and is laid out through `layoutBarForPane:`; when that view is removed/transferred to solo fullscreen, the split toolbar/3-dot is no longer a reliable accessible restore affordance. The original pipeline does not retain an explicit 'previous split restoration button' in that same handle path. A separate `openRememberedPair` / layout launcher exists, but this is a different re-open flow, not an in-pane shrink action.

## Distinction from the approved idle-hide work

`idle/src/OmniCarIdleControls.xm` only changes visual **opacity** of existing knobs/three-dot handles during split. When a pane is actually removed, the idle source cannot revive the deleted `pane.handle`; it must never be used to fake a restore button. The additional Zoom 0.7 uses `appAreaInParent` scene sizing and an independent button; it does not alter the original 12% drag-edge close decision.

## Candidate fix, not yet authorized or implemented

**Preferred architecture if the user wants drag-to-full BUT restore to split:** intercept just the edge-completion branch **before `closeSlot:background:`** and map it to a reversible `toggleZoomForPane:` / saved `zoomedSlot` state rather than deleting pane. Preserve the two SCPCarPane instances, app hosting, original fractional layout, gestures. A restore affordance must remain reachable in fullscreen (reveal original controls on a tap or via an OmniCar-owned unobtrusive control) and must not touch Apple's native dock or app content. Merely forcing 3-dot alpha to 1 cannot resurrect a removed pane. Needs careful verification because native toggleZoom may use different insets/chrome from draggable full, and any edge gesture listener must not swallow app gestures.

Alternative: retain original destructive close semantics and provide a **separate** restore-last-split route using `openRememberedPair` — potentially relaunches/recreates scenes, less reliable and not equivalent to resizing back.

**No code changes were made to the original package or custom Zoom/idle/Titanium. No DEB, no Sileo, no test on a real CarPlay screen in this inspection.**
