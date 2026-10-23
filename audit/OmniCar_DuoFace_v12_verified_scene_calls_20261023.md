# Đối chiếu chain gọi scene thật DuoFace Native12 ↔ OmniCar (2026-10-23)

**Tình trạng:** Phân tích tĩnh từ 2 DEB gốc được SHA256 pin, Github CI PASS; **không** có patch runtime hay kiểm thử trên iPhone/CarPlay.

## Đầu vào, công cụ và bằng chứng kiểm thử
- Source pin DuoFace Native12: `duoface-reference/dist/visual-1.0.3-12/com.duoface.app_1.0.3-12_visualtest_iphoneos-arm64.deb`, DEB SHA256 `8b7dedf77b9ec05465b83fdb6e2d7127800eac232a34ecf12f2c08b3983a481a`; `DuoFaceDashboard.dylib` SHA256 `bc1df854ec7a2ddfeec4cb81b080ead34b54df80143d4a8f6254bb8b618003ce`; reference repo SHA `6193b9e77337fd1e9d586da5e5bf39742d041d2d`.
- Source pin OmniCar original: `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb`, DEB SHA256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`; `OmniCarAppBridge.dylib` SHA256 `d99b8d00dc60f69db7b54fc1addaec6b8cb866b8dcdde6f1d85e06ce5b7d6e79`.
- Read-only source: `scripts/audit_v12_omnicar_scene_calls.py`; chiếu cùng `scripts/audit_v12_omnicar_geometry_machine.py`. Script đọc LC_SYMTAB, LC_DYSYMTAB và `__objc_stubs`, khôi phục x1/`__objc_selrefs` ở vị trí call bằng Capstone, giữ `unresolved` khi không thể xác định. Fix giải mã terminal `br` commit `0635e2a6a292b4a709d0216869636ffa25ce6853`.
- CI: `https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39925450545`, job `120320587394`, **SUCCESS**, logs `NATIVE12_OMNI_SHA_LOCKED_SELECTOR_CALLSITE_STATIC_AUDIT_PASS__DEVICE_UNTESTED`, `NATIVE12_OMNI_SELECTOR_MAP_JSON_INTEGRITY_PASS` và `READONLY_AUDIT_REPORT_COMMITTED_TO_OMNICAR`; preceding run `39925321142` also SUCCESS. Report machine `audit/native12_vs_omnicar_scene_selector_calls_20261023.json`, blob `be57be31de81aa2df3a63595304a368f05b8ad23` (final second run; earlier readback confirmed).
- Full ARM64 geometry listing: `audit/native12_vs_omnicar_yt_scene_arm64_20261023.json`; see `audit/OmniCar_DuoFace_v12_machine_code_findings_20261023.md`.

## Proven *static* call edges (PC / selector)

**DuoFace Native12, hosting branch:**
1. `CBBridgedSplitApp.updateScale:forSlot:` at `0x108e40` sends `refreshSceneLayout` (x1 selector candidate, `_objc_msgSend` call).
2. `CBBridgedUIAppView.refreshSceneLayout`: `0xade74 updateLayout` → `0xade84 updateSceneSettingsFrame`; at `0xadedc setNeedsLayout` and `0xadf08 layoutIfNeeded`.
3. `CBBridgedUIAppView.updateLayout`: at `0xacd00 calculateNativeSizeForSlotRect:`. ARM64 arithmetic of callee `0xacc28` shows 2× dimensions then float32 round when positive; the layout branch also has 2-axis ratio with select/clamp around `0xad03c..0xad058`.
4. `CBBridgedUIAppView.updateSceneSettingsFrame`: `0xad5fc bounds` → `0xad620 carPlayUsableBounds` → `0xad638 calculateNativeSizeForSlotRect:` static call sequence. **Do not interpret this as guaranteed execution order across runtime branches.**
5. `CBBridgeManager.renderSizeForBundleID:`: `0x24cb78 renderSize`, many `carPlayUsableBounds` callsites, distinct 2× rounding paths (per previous math report).

**OmniCar original, hosting branch:**
1. `ABHost.setFrame:forApp:live:handle:passInsets:`: `0xff90 setFrame:`, `0xffbc setFrame:`, `0x10010 layoutBarForPane:`, `0x100d8 sceneBox`, `0x1012c layoutPane:`, `0x10160 effectiveOrientation:`.
2. `ABHost.layoutPane:`: `0xecec bounds`, `0xed70 setTransform:`, `0xed9c setFrame:`, `0xedc8 setTransform:`, `0xeddc setCenter:`, `0xeee8 setTransform:`, `0xefbc effectiveOrientation:`, `0xf074 setSceneBox:`. The earlier verified math at `0xed74..0xed80` divides dimensions by the global `ABHost.zoom` (preference /100 clamped 0.6–1.0).
3. `ABHost.effectiveOrientation:`: two accesses `requestedOrientation` at `0xf380,0xf390`, `orientation` at `0xf39c`, `ensureWindow` and `window` at `0xf3e0,0xf3ec`.
4. ObjC `SBSceneView -_updateReferenceSize:andOrientation:` literal exists in the original binary (previous audit), **but call-target/actual hook→YouTube referenceSize is still not resolved here**.

**Crucial difference (evidence-supported):** DuoFace explicitly calls per-slot `refreshSceneLayout`, then separately computes native size and scene frame. Original OmniCar advances per-pane `setFrame → layoutPane → setSceneBox` and shared zoom transform. The *bridged scene policy* is the right comparison layer, **not** copying a claimed YouTube player UI. This does **not** prove the active YouTube scene uses either path at runtime or that the displayed Play/Next sizes will exactly match.

## Implementation boundary and next reproducible step

1. Keep public **QA12** `1.0.3-omnicar12-timer-zoom-swap` untouched; SHA256 `f07c293a52882ab420aca49e4fe9e30d141d2cba412185938bf09ec9154685ba`. Its original Solo/Zoom/Swap/4s timer/split/divider may not be disturbed.
2. Resolve original OmniCar's `SBSceneView -_updateReferenceSize:andOrientation:` sender/receiver with read-only original metadata/calls, then instrument **bundle-scoped log-only diagnostic** for YouTube: bundle ID, pane and sceneBox/referenceSize/scale/orientation, split→solo changes and touch mapping (no video or account metadata).
3. Only after A/B runtime evidence, implement narrow YouTube-only geometry adapter under OmniCar AppBridge (`ABHost.layoutPane:` / `setSceneBox:` owner), never globally force 2× or copy DuoFace dylib/replace YouTube application UI. Build isolated candidate, verify maps+maps, YouTube+map, Solo, wake timer, Zoom/Swap, 3-dot and no crash **on parked device**.

## Reproduce exact run

```sh
python3 -m venv /tmp/omni-scene-audit
/tmp/omni-scene-audit/bin/pip install capstone==5.0.7
/tmp/omni-scene-audit/bin/python scripts/audit_v12_omnicar_scene_calls.py \
  --duoface duoface-reference/dist/visual-1.0.3-12/com.duoface.app_1.0.3-12_visualtest_iphoneos-arm64.deb \
  --omnicar com.anlai.omnicar_1.0.3_iphoneos-arm64.deb \
  --output audit/native12_vs_omnicar_scene_selector_calls_20261023.json
```

The pinned binaries are checked before disassembly; GitHub Actions checks exact DEB SHA before invoking script. The JSON also retains unresolved callsites and neighboring instruction context, preventing invented selector ownership.
