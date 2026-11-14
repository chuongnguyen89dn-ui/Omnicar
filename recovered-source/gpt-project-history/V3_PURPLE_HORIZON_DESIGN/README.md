# DuoCar V3 — Purple Horizon (review package)

**Status: Visual review draft only. Not approved for code integration.**

This folder contains **23 compact SVG visual screens**, a source-backed specification and a handoff map for Muse. Generated in the current ChatGPT conversation from Nguyen's purple-night road style and the preceding D-shaped purple identity. **These are lightweight previews, not byte-identical exports of the 13 MB conversation ZIP, and not runtime/device screenshots.**

Source-of-truth: [Muse P0 112 items](../APEX_V3_P0_BANG_PHU_20261114.md). Design constraints: [SPEC_V3_DESIGN.txt](SPEC_V3_DESIGN.txt). Per-screen-to-source map: [MUSE_HANDOFF.txt](MUSE_HANDOFF.txt).

The *exact original source PNG* for the purple italic D and the full 23-PNG/23-SVG ZIP are still in the conversation artifact; only a small non-shipping D reference thumbnail is saved here at [assets/logo_D_purple_reference_preview.webp](assets/logo_D_purple_reference_preview.webp). Do not substitute white/cyan V2 D, car silhouette, infinity mark, or screenshot art for DuoCar-owned assets.

Review CarPlay screens: [01 Split](screens/01_carplay_split_native_hosted.svg), [02 Picker native](screens/02_picker_native.svg), [03 Picker hosted](screens/03_picker_hosted.svg), [04 Ratio](screens/04_ratio_menu.svg), [05 Controls native](screens/05_controls_native.svg), [06 Controls hosted](screens/06_controls_hosted.svg), [07 Fullscreen](screens/07_fullscreen_status.svg), [08 Keyboard](screens/08_keyboard_hosted.svg), [09 Startup](screens/09_startup.svg), [10 Thermal](screens/10_thermal_alarm.svg), [11 Home](screens/11_home_duocar_tile.svg), [12 Empty](screens/12_empty_pane.svg), [13 Handle](screens/13_handle_states.svg).

Review iPhone screens: [14 Dashboard](screens/14_iphone_dashboard.svg), [15 Layout](screens/15_iphone_layout.svg), [16 Apps](screens/16_iphone_apps.svg), [17 Device](screens/17_iphone_device.svg), [18 Customize](screens/18_iphone_customize.svg), [19 Startup](screens/19_iphone_startup.svg), [20 Vitals](screens/20_iphone_vitals.svg), [21 Lề](screens/21_iphone_le.svg), [22 Legacy Prefs](screens/22_iphone_prefs_legacy.svg), [23 Guide](screens/23_iphone_guide_whatsnew.svg).

**Muse action now:** read source and report exact implementation hunk mapping, touched files, UX discrepancies, risks and rollback to Issue #1. **Do not start P2 visual code or CI/DEB until Nguyen explicitly approves the finished V3 design.**
