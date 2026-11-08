# FAT (arm64+arm64e) macOS build — executed evidence (2026-11-08)

Workflow: `build-fat-macos` (file: `recovered-source/ci/build-fat-macos.yml`,
placed at `.github/workflows/build-fat-macos.yml` on branch `ci-fat-test`).
Source tree under test: main commit `fcfc202747a7d0f6824363e3a6adb33d52d4c375`
(the branch adds only CI commits on top of it).

## Run history

| Run | Commit | Result | Note |
|-----|--------|--------|------|
| 42458768317 (#1) | 57724a9 | cancelled at 2 s | Runner-level: annotation "The configuration 'macos-14-arm64-us-default' is not supported". Fixed by switching `runs-on` to macos-15. |
| 42458792284 (#2) | ac5164c | failure at link | The ARCHS override engaged arm64e (dry run: 256 arm64e mentions, `THEOS_CURRENT_ARCH="arm64e"`), but the first link died: `clang: error: invalid linker name in argument '-fuse-ld=lld'`. The `-fuse-ld=lld` in the project Makefiles is a workaround for the Ubuntu analysis VM (GNU ld default); Xcode clang rejects it. The workflow now strips it in the CI checkout only; the shipped tree is unchanged. |
| 42459179466 (#3) | b35f8cc | **success** | Full build + FAT acceptance + artifact upload. |

## Run #3 acceptance evidence (from the run's own logs)

`lipo -info` on the binaries extracted from the produced DEB —
every line reads "are: arm64 arm64e":

- OmniCarCore.dylib — arm64 arm64e
- OmniCarAppBridge.dylib — arm64 arm64e
- OmniCarCarProbe.dylib — arm64 arm64e
- OmniCarSpeedBubble.dylib — arm64 arm64e
- OmniCarSplitScreen.dylib — arm64 arm64e
- OmniCarStartupScreen.dylib — arm64 arm64e
- OmniCarPrefs (PreferenceBundles binary) — arm64 arm64e
- OmniCar.app/OmniCar (informational) — arm64 arm64e

Final step line: "All required component binaries are FAT (arm64 + arm64e)."
Build step contained 100 `Compiling … (arm64e)` lines.
Produced DEB: `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb`, 1,121,484 bytes,
uploaded as run artifact `omnicar-fat-deb` (Actions run 42459179466).

Conclusion: the recovered source builds FAT arm64+arm64e on macOS with the
same Theos path the original used. Gap G1 (arm64-only local builds on the
Ubuntu VM, whose clang silently degrades arm64e) is closed by execution.
