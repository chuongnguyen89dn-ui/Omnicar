# OmniCar original 1.0.3 UI reverse engineering: static-first checkpoint

Date 2026-10-19. **Do not require the user to install SkinProbe to continue.** User explicitly directs extracting original UI colors, dimensions and drawing layer logic from the native DEB first. SkinProbe stays optional fallback; no color/style DEB compiled in this checkpoint.

Original DEB: com.anlai.omnicar_1.0.3_iphoneos-arm64.deb; SHA256 d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd.
Original arm64 OmniCarSplitScreen.dylib SHA256 3dba3bdffc8c3487c7a5127d2fcad0c71b950acd2e98ad0c6bf6066b19d00885.
Source proof files in current conversation runtime: /mnt/data/omnicar103/arm64-disasm.txt and /mnt/data/omnicar103/methods-full.txt. Recreate by extracting the original package and running llvm-objdump --macho --disassemble on its ARM64 library.

## Confirmed original instructions and candidates (not finished visible UI metrics)

| Owner method | Instruction evidence (addresses from original ARM64) | What is proven |
|---|---|---|
| newDividerAt: | 0x2c5b0/0x2c5b8/0x2c5c0 then 0x2c5c8 bl 0x576e0 | Color channel literal RGB(110,100,200), d3=1.0; target selector and exact colored view require resolution |
| newDividerAt: | 0x2c8e4/0x2c8e8 d0=d1=0, 0x2c8ec/0x2c8f0 d2=d3=14, then bl 0x5a920 at 0x2c8f8 | 14 by 14 are actual numeric arguments to a native view geometry call; not proof the displayed divider circle diameter is 14 pt |
| newDividerAt: | 0x2ccc8/0x2ccd0/0x2ccd8 | Literal channel triplet RGB(74,79,128), object to identify |
| showRatioMenuForDivider: | 0x2f858 d0=22 then call 0x46a64 at 0x2f864 | Original size-related numeric argument 22; don't call it width/height until callee mapped |
| showRatioMenuForDivider: | 0x2fa14 and 0x2fac0 =21 | Two original sizing numeric loads |
| showRatioMenuForDivider: | 0x2fb34/0x2fb38/0x2fb3c values 12/1/18 then 0x2fb44 call 0x5ae20 | Original parameters, exact role requires mapping |
| showRatioMenuForDivider: | 0x30388/0x30390/0x30398 | RGB(74,79,128) original literal |
| showRatioMenuForDivider: | 0x306a8/0x306b0/0x306b8 | RGB(94,221,182) original literal |
| showRatioMenuForDivider: | 0x306ec/0x306f4/0x306fc | RGB(245,154,192) original literal |
| showRatioMenuForDivider: | 0x3097c/0x30984/0x3098c | RGB(155,135,248) original literal |

Confirmed counts of ARM64 direct fmov floating literal instructions in selected original method address windows (not number of colors or UI objects): newDividerAt: 22; showRatioMenuForDivider: 42; setupBarForPane: 36; layoutBarForPane: 8; refreshPickerSheet: 0; buildPickerSheetForPane: 85. `refreshPickerSheet` zero here means no matched fmov immediate instructions only, not absence of UI properties.

## Why scanning DEB instead of measuring first is correct

- The DEB is a compiled binary, **not** a convenient editable theme table or fully materialized runtime view hierarchy. Colors/layout constants, Objective-C class metadata and sizing formulas are present, but some displayed dimensions depend on UIScreen, window bounds, scale, selection state, blur compositing and safe areas.
- To reproduce accurate owner mapping: decode ObjC call stubs `bl`, map selectors/callees, follow layer creation order and assignment, identify fill/stroke/gradient per control and state. Reconstruct three native choice buttons, native handle and toolbar separately. Only then derive Zoom size from verified original constructor/layout formulas. The existing `circleDiameter=MAX(29,MIN(36,nativeHeight*.43))` in Zoom 0.7 was an arbitrary approximation, never derived from the original ratio menu; its lavender/cyan layer is not part of the Titanium native theme.
- The failing Titanium 0.2 OMTSurface method indiscriminately inserts a gradient at sublayer index 0, potentially behind original drawing. It does not prove a visible color change. Never reintroduce theme changes to OmniCar Home/logo, Apple CarPlay dock or hosted app contents.
- Runtime SkinProbe can remain an optional final cross-check for dynamic values that cannot be determined solely from compiled code, but user should NOT be asked to install it before exhausting static analysis.

## Accurate next technical steps

1. Map method stubs/ObjC selectors in original newDividerAt: and showRatioMenuForDivider: to UIKit setters and constructors, along with each value's liveness.
2. Continue literal+expression tracing for setupBarForPane: and layoutBarForPane:, native 3-choice sizing and border/gradient values; publish per-component mapping with evidence addresses and uncertainty.
3. Confirm all three ratio selection states and native knob. Remove generic view-parent gradient approach and write narrowly-scoped hooks only on the actual original render owners.
4. Keep original package, Home/logo/dock/scene content, Zoom 0.5 behavior and no-rescue requirement. No new user DEB or Sileo action until verified technical basis.

Actual work completed this turn: original DEB and extracted dylib checksums verified; native disassembly read for original function windows; numeric immediate frequency counted in Python; report and handoff saved. No Sileo, no code patch, no new DEB and no device runtime verification.