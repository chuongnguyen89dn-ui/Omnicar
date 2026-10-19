# Verified actual ORIGINAL class → method ownership for Titanium source-only modules

2026-10-19: method ownership decoded through original ARM64 Objective-C class metadata `__objc_classlist` → `class_ro_t` → `baseMethods`, not guessed names. No DEB built, no on-device tests.

| Original binary | Verified ObjC class | Native method and signature | Intended COLOR-only owner |
|---|---|---|---|
| OmniCarAppBridge.dylib | ABHost | `buildBarForPane:` returns object `@24@0:8@16` | ABPane.bar and bar returned by original method |
| OmniCarAppBridge.dylib | ABHost | `layoutBarForPane:` `v24@0:8@16` | Only existing ABPane.bar |
| OmniCarAppBridge.dylib | ABHost | `setupHandleForPane:` `v24@0:8@16` | Only existing ABPane.handle |
| OmniCarAppBridge.dylib | ABKeyboard | `buildPanel` `v16@0:8` | ABKeyboard.panel, glass only |
| OmniCarSpeedBubble.dylib | SPPBubbleView | `buildStyle:` `v24@0:8q16` | Native SPPBubbleView gradients and accent colors |
| OmniCarSpeedBubble.dylib | SPPBubbleView | `renderStyle` `v16@0:8` | Native SPPBubbleView native color layers |
| OmniCarStartupScreen.dylib | SSStartupView | `ss_buildScene` `v16@0:8` | Startup native backdrop/artboard layer colors, image content excluded |
| OmniCarStartupScreen.dylib | SSStartupView | `layoutSubviews` `v16@0:8` | Idempotent recoloring of existing layer colors after native layout |

Original class method lists confirmed additional ABPane getter names `bar`, `handle`; ABKeyboard getters `panel`, `glass`. Class method tree saved in local original analysis `/mnt/data/omnicar_forensic/all_modules/*-class_methods.csv` and owner log `/mnt/data/omnicar_forensic/all_modules/class_owner_log.txt` (temporary chat artifacts). Source re-generators `/mnt/data/omnicar_forensic/all_modules/map_objc_owner_classes.py` (temporary; script should be committed in future after reparameterization).

Native-only colors in staged `titanium/src/OmniCarGraphiteFeatureColors.xm` use owner whitelists; runtime hooks applied **only when verified classes exist** and only in CarPlayApp or SpringBoard process. They change existing colors/layers but do NOT edit geometry or any original Home/logo, system dock, third-party app images or media.

SpeedBubble guards: untouched actual red #FF5A5F / #E5262D, amber #FFB340 / #FFD58A and green status #5EDDB6, plus entire native `SPPSignView` subtree excluded. Startup decorative blue #3C5AC8 / #A0D2FF / #78DCFF maps into Titanium; uploaded user photo/image/video is NOT modified. AppBridge must not touch app frame/scene or keyboard action; native toolbar and keyboard panel colors only.

**Honest limitation**: new class hooks and module colors are SOURCE-ONLY; Theos/Logos compatibility and process injection not yet compiled/tested because USER EXPLICITLY SAID 'chưa đóng deb'. It is possible that a native class is loaded into a different process; the hook will then skip that module rather than modifying system-wide UI. Build and screen QA must be separately authorized.