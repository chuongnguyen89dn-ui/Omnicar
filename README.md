# OmniCar — Circular-knob double-tap fullscreen candidate

**Independent repo / no Sileo publishing.** Source baseline: user-provided \`com.anlai.omnicar_1.0.3_iphoneos-arm64.deb\`. Original OmniCar is **not repacked or modified** by this candidate; the generated DEB is an **optional addon** depending on \`com.anlai.omnicar >= 1.0.3\`.

Goal: single tap on the circular divider knob still selects a pane; drag still adjusts the split ratio; first double-tap enlarges the whole split host area (both panes), second double-tap restores the original split. This **does not use OmniCar's per-pane zoom function**, nor the floating-window mode.

Current implementation: Logos hook into \`SCPCarSplit.newDividerAt:\` installs an opt-in 2-tap recognizer scoped to the native knob bounds; associated state selects the enlarged app region from its live host window, and invokes the native relayout to propagate sizes to scenes. \`appAreaInParent:\` is temporarily overridden only on the active split owner. Other native divider gestures are not changed; original divider-swap callback is suppressed on circular knob only.

**Important limitation:** This is an experimental geometry hook. A larger app region does **not** prove Apple CarPlay dock/status chrome is hidden. It is not yet proven that OmniCar calls \`appAreaInParent:\` in every host layout path, nor that the second double-tap remains accessible when fullscreen. Passing CI means *compile + package only*, **never device functionality PASS**. Test on a separate candidate setup, not while driving.

Build: GitHub Actions \`.github/workflows/build-candidate.yml\` on push (macos-15, Theos, arm64, rootless). The CI saves \`dist/candidates/\` only in this repo and uploads an Actions artifact. It never uploads a Sileo apt index or changes the original package.

Rollback: uninstall \`com.anlai.omnicar.doubletapfullscreen\` via a package manager or \`dpkg -r com.anlai.omnicar.doubletapfullscreen\`, then respring. Original \`com.anlai.omnicar\` should remain installed. For safety, confirm the \`apt\` removal plan before approving any uninstall.

Evidence and continuation: [tiep tuc du an.md](tiep%20tuc%20du%20an.md), [static audit](audit/OmniCar_1.0.3_doubletap_fullscreen_20261019.md). Any change must be confined to this repo and reviewed against the single-tap/pan regression checklist.
