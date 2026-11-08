# OmniCar 1.0.3 — Payload Inventory (wave 1, INVENTORY agent)

Canonical inventory of the original DEB. Every number below comes from a command run against the
verified input file; every plist dump is the parsed content of the real file (all plists in this
package are **binary plists**; dumps are rendered as JSON with key order preserved).

Companion file: `manifest.tsv` (177 rows: 176 payload files + 1 DEBIAN control row).

## 1. DEB facts

| Item | Value |
|---|---|
| File | `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb` |
| SHA-256 | `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd` (matches the project reference hash) |
| `file` | `Debian binary package (format 2.0), with control.tar.gz, data compression lzma` |
| ar members | `debian-binary`, `control.tar.gz`, `data.tar.lzma` |
| Package | `com.anlai.omnicar` |
| Name | `OmniCar` |
| Version | `1.0.3` |
| Architecture | `iphoneos-arm64` |
| Installed-Size | `6160` (KiB, = 6,307,840 bytes; actual payload file bytes sum to 5,909,467) |
| Maintainer | `OmniCar <omnicartweak@gmail.com>` |
| Author | `OmniCar <omnicartweak@gmail.com>` |
| Section | `Tweaks` |
| Depends | `mobilesubstrate (>= 0.9.5000), preferenceloader, firmware (>= 15.0)` |
| Conflicts | `carsplash-rootless, carspeed, com.anlai97.speedpop, com.anlai97.carduo, com.anpham.splitcarplay` |
| Replaces | `carsplash-rootless, carspeed, com.anlai97.speedpop, com.anlai97.carduo, com.anpham.splitcarplay` |
| Icon | `file:///var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/PackageIcon.png` |

Full Description (from `control`): feature list covering APP BRIDGE, SPEED BUBBLE (Vietmap Live /
GOFA / Waze / Wyn sources, 9 styles, over-speed warning), STARTUP SCREEN (custom video on CarPlay
connect), SPLIT SCREEN (2/3 panes, layouts, divider drag, `omnicar://` URL scheme for Siri/Shortcuts),
SETTINGS (per-feature pages under Settings > OmniCar), COMPATIBILITY (iOS 15 and 16, rootless
Dopamine / palera1n).

### Extraction verification

- `dpkg-deb -c` lists **202** entries (176 files + 25 subdirectories + the `./` root entry).
- Fresh `dpkg-deb -x` into a clean scratch dir produced **176 files, 26 directories (incl. root),
  0 symlinks**; its path list matches `dpkg-deb -c` exactly (only difference: the root `.` entry line).
- The project-provided `payload/` tree was hash-compared file-by-file against the fresh extraction:
  **all 176 SHA-256 identical** — the provided extraction is complete and untampered.
- The tar ownership warnings during extraction (`Cannot change ownership to uid 0, gid 20`) are a
  sandbox artifact only; file contents and paths are unaffected.

## 2. Maintainer scripts

`control.tar.gz` contains exactly **one** file: `control` (1,932 bytes).
The following are **all absent** — there are no maintainer scripts in this package at all:

- `postinst` — absent
- `preinst` — absent
- `postrm` — absent
- `prerm` — absent
- `conffiles` — absent
- (`md5sums` is absent too)

Consequence: installation runs no code; nothing is created, migrated or cleaned up by dpkg scripts.
All activation is via MobileSubstrate filters + PreferenceLoader.

## 3. App bundle — `var/jb/Applications/OmniCar.app`

| File | Size (bytes) | SHA-256 |
|---|---:|---|
| `OmniCar` | 168880 | `8e7dc4ddaf98a73b80910c0d5d00e38a084bfef2e9f97084f8bbdf76313807c8` |
| `Info.plist` | 897 | `058136b8e31515de8b7368e80af989c67cea64d80fb99a122e6851c83ca6b541` |
| `AppIcon60x60@2x.png` | 24659 | `b304145f7002c44d0e33b43c30886510ce6c97c6e215cad36f938f63827fb164` |
| `AppIcon60x60@3x.png` | 44470 | `bab820c8bd04975393d268ac3ea9e1dd8665a317a0eab4dbe9a6d1f62381da00` |

Notes: the bundle contains **only** these 4 files — no storyboards, nibs, asset catalogs,
localizations or embedded frameworks. The UI is necessarily built in code.

### `Info.plist` — full dump

```json
{
  "CFBundleName": "OmniCar",
  "CFBundleIdentifier": "com.anlai.omnicar.app",
  "CFBundleInfoDictionaryVersion": "6.0",
  "CFBundleIcons": {
    "CFBundlePrimaryIcon": {
      "CFBundleIconFiles": [
        "AppIcon60x60"
      ],
      "UIPrerenderedIcon": true
    }
  },
  "CFBundleVersion": "1",
  "UIRequiresFullScreen": true,
  "CFBundleExecutable": "OmniCar",
  "LSRequiresIPhoneOS": true,
  "UISupportedInterfaceOrientations": [
    "UIInterfaceOrientationPortrait"
  ],
  "CFBundleDisplayName": "OmniCar",
  "MinimumOSVersion": "15.0",
  "CFBundleSupportedPlatforms": [
    "iPhoneOS"
  ],
  "CFBundleURLTypes": [
    {
      "CFBundleURLName": "com.anlai.omnicar",
      "CFBundleURLSchemes": [
        "omnicar"
      ]
    }
  ],
  "CFBundlePackageType": "APPL",
  "CFBundleSignature": "????",
  "UIDeviceFamily": [
    1
  ],
  "CFBundleDevelopmentRegion": "English",
  "UIUserInterfaceStyle": "Dark",
  "CFBundleShortVersionString": "1.0.3"
}
```

Key facts and **absences** (checked explicitly):

- Bundle id: `com.anlai.omnicar.app`; executable `OmniCar`; version `1.0.3` / build `1`.
- URL schemes: one URL type, scheme **`omnicar`** (name `com.anlai.omnicar`).
- Orientations: `UISupportedInterfaceOrientations` = **Portrait only**; `UIRequiresFullScreen` = true.
- Background modes: **no `UIBackgroundModes` key at all**.
- Usage descriptions: **no `NS*UsageDescription` keys at all** (no camera/mic/location/photo strings).
- Scene manifest: **no `UIApplicationSceneManifest` key** — classic AppDelegate lifecycle.
- `MinimumOSVersion` 15.0; `UIDeviceFamily` [1] (iPhone only); `UIUserInterfaceStyle` = Dark;
  `CFBundleSignature` = `????`.

## 4. Substrate dylibs — `var/jb/Library/MobileSubstrate/DynamicLibraries`

6 dylibs, each paired with a same-name filter plist. All are FAT Mach-O (arm64 + arm64e slices,
filetype DYLIB). Filter contents are dumped in full under each entry.

### `OmniCarAppBridge`

| File | Size (bytes) | SHA-256 |
|---|---:|---|
| `OmniCarAppBridge.dylib` | 613376 | `d99b8d00dc60f69db7b54fc1addaec6b8cb866b8dcdde6f1d85e06ce5b7d6e79` |
| `OmniCarAppBridge.plist` (filter) | 87 | `023eb9e22181a840bc7ead9806b70b33e6ebb5822adb1ffe5afda3873459c35b` |

Filter plist — full dump:

```json
{
  "Filter": {
    "Bundles": [
      "com.apple.UIKit"
    ]
  }
}
```

### `OmniCarCarProbe`

| File | Size (bytes) | SHA-256 |
|---|---:|---|
| `OmniCarCarProbe.dylib` | 242784 | `85db0c33e9a918e9dfd944dcdc53e3326fb83259554d5c1a3fd976fcb9c6026f` |
| `OmniCarCarProbe.plist` (filter) | 92 | `9fbf4a476ff57470977adc2b30c7c7052d0434d1b713895b82fe44e71a8d58b0` |

Filter plist — full dump:

```json
{
  "Filter": {
    "Bundles": [
      "com.apple.CarPlayApp"
    ]
  }
}
```

### `OmniCarCore`

| File | Size (bytes) | SHA-256 |
|---|---:|---|
| `OmniCarCore.dylib` | 276832 | `c95c66f46d960702e2f7f4ea930b85fd96d01709c2733a14373b37eaca9ed0a5` |
| `OmniCarCore.plist` (filter) | 93 | `86345479d62d39c2b9fc6f879bbed191913b153deefa1aa486ca1e19c8664304` |

Filter plist — full dump:

```json
{
  "Filter": {
    "Bundles": [
      "com.apple.springboard"
    ]
  }
}
```

### `OmniCarSpeedBubble`

| File | Size (bytes) | SHA-256 |
|---|---:|---|
| `OmniCarSpeedBubble.dylib` | 649808 | `f9531a646d5ce11f70cba34d1b30c6ffed3311d347922b890e41b9b330b8a836` |
| `OmniCarSpeedBubble.plist` (filter) | 194 | `f31137da54adf6860904581cd1db44a8addda023b857550d9ef21361217788fe` |

Filter plist — full dump:

```json
{
  "Filter": {
    "Bundles": [
      "com.apple.springboard",
      "com.apple.CarPlayApp",
      "vn.vietmap.live",
      "com.lumi.GOFA",
      "com.waze.iphone",
      "com.wynauto.wyn"
    ]
  }
}
```

### `OmniCarSplitScreen`

| File | Size (bytes) | SHA-256 |
|---|---:|---|
| `OmniCarSplitScreen.dylib` | 1229920 | `f696b518579266cf99cfd46f85cb54931d18e679c793a563ee2fcc9bf8115754` |
| `OmniCarSplitScreen.plist` (filter) | 118 | `9503d73445cec4a57d8210637028a5730d587551d457e70e448b9f974fc04e14` |

Filter plist — full dump:

```json
{
  "Filter": {
    "Bundles": [
      "com.apple.CarPlayApp",
      "com.apple.springboard"
    ]
  }
}
```

### `OmniCarStartupScreen`

| File | Size (bytes) | SHA-256 |
|---|---:|---|
| `OmniCarStartupScreen.dylib` | 567792 | `2cd8b29434f7f81e07a222298952696a0fced9139e543c6877aaa7f8b0d72037` |
| `OmniCarStartupScreen.plist` (filter) | 118 | `9503d73445cec4a57d8210637028a5730d587551d457e70e448b9f974fc04e14` |

Filter plist — full dump:

```json
{
  "Filter": {
    "Bundles": [
      "com.apple.CarPlayApp",
      "com.apple.springboard"
    ]
  }
}
```

Filter summary (injection surface):

| Dylib | Filter Bundles |
|---|---|
| OmniCarCore | `com.apple.springboard` |
| OmniCarAppBridge | `com.apple.UIKit` (loads into **every** UIKit process) |
| OmniCarCarProbe | `com.apple.CarPlayApp` |
| OmniCarSpeedBubble | `com.apple.springboard`, `com.apple.CarPlayApp`, `vn.vietmap.live`, `com.lumi.GOFA`, `com.waze.iphone`, `com.wynauto.wyn` |
| OmniCarSplitScreen | `com.apple.CarPlayApp`, `com.apple.springboard` |
| OmniCarStartupScreen | `com.apple.CarPlayApp`, `com.apple.springboard` |

All filters use `Bundles` only — no `Executables` key anywhere.

## 5. Preference bundle — `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle`

Principal binary `OmniCarPrefs` (Mach-O filetype **DYLIB** — PreferenceLoader loads it as a dylib;
`NSPrincipalClass` = `OMCRootListController`). Non-localization files:

| File | Size (bytes) | SHA-256 |
|---|---:|---|
| `OmniCarPrefs` | 1303344 | `15bca4bee19bd9e04300e2c8070f665869df93c0f8913278e87b147ebf895a76` |
| `Info.plist` | 402 | `96f58b1cb9f43708a487bad46ab9382b7b55b854f529c01435df18960492f2e2` |
| `Root.plist` | 1033 | `9b44aadf58c92e1aae94567c5b49545865ce958255dc3c24276c8a797e56df24` |
| `FeatureSpeedBubble.plist` | 438 | `6d34c6447f0dde63b0589a50cacbdb01c6237a5dd4222b4b8533276975210a13` |
| `FeatureSplitScreen.plist` | 453 | `26e7f57d6953f48ec008157eb0b0acb5d7e6d52caf51b163311680ba8c4f15e1` |
| `FeatureStartupScreen.plist` | 4055 | `368e27c2309d2f793a47e45b9ae194b9b3c903950b995f8df222602ff71fbb9c` |
| `WhatsNew.plist` | 334 | `6f787826422ae62820f1329008bf9f5b3bea1567e20d6d0a21e07bc2ede02160` |
| `PackageIcon.png` | 74767 | `e8663a8b360c85c9b151e354d7bc62262e5b18edada7bc80c52cb32095ee972c` |
| `SpeedBubbleIcon.png` | 2092 | `3b63f8510689c9393936b96eb85f67dd9a36591af6a5000958d67b80a9b33156` |
| `SpeedBubbleIcon@2x.png` | 4963 | `615f6f8beea12ddb419ba850e31696fc8d9d8cf023fc9e1d77d489e80c7dfc18` |
| `SpeedBubbleIcon@3x.png` | 7688 | `ecc7e132e77729c009c11153afa2fad2bd7832e44f9271c80f98076b35b0c43b` |
| `StartupScreenIcon.png` | 1567 | `8912542026dd6b1d8af665721cb71550a225d0c9a3e3f6096878ca91811ffe90` |
| `StartupScreenIcon@2x.png` | 3150 | `02068cf8c3a7cae437f16cb40eeba7e284f276dd8b2a98382e4a3982da43fda8` |
| `StartupScreenIcon@3x.png` | 4912 | `1bfc0b7305f3ec4c1e12252329ed0da12d6c956d0fce76eae41381639d3c86cf` |
| `icon.png` | 2481 | `db186260d10b29bcfcf48d8fb2e1ecd346fd60c13eb31c7a4130b29ee58450bd` |
| `icon@2x.png` | 7968 | `473c7dc85b502977bd4d5b19b672ed30ad76e6d2a219a66abf416b66804dc073` |
| `icon@3x.png` | 14988 | `0d4e4682b382861ef68b2cf48cc33ee12b8b9fad1357d6299aef6bd7227d6360` |
| `logo.png` | 9406 | `7077849cb7ce87b43a56bf52cceacf6ebd28f79837d12c16beaae3838a92b27a` |
| `logo@2x.png` | 27891 | `9e234f6a399cd603e34050d5b623ae68c31e352b63dbaeb57aaa5a82ece1c232` |
| `logo@3x.png` | 48665 | `d6407325dca6ec9f864dfc7b0906930015a702318f851a9d7c30782fdfd4ba08` |

### Bundle `Info.plist` — full dump

```json
{
  "CFBundleShortVersionString": "1.0.3",
  "CFBundleIdentifier": "com.anlai.omnicar.prefs",
  "CFBundleSignature": "????",
  "CFBundleInfoDictionaryVersion": "6.0",
  "CFBundleDevelopmentRegion": "English",
  "CFBundleExecutable": "OmniCarPrefs",
  "CFBundlePackageType": "BNDL",
  "CFBundleVersion": "1.0",
  "NSPrincipalClass": "OMCRootListController"
}
```

### `Root.plist` — full dump (Settings root surface)

```json
{
  "title": "OmniCar",
  "items": [
    {
      "omcGroup": "rescue",
      "cell": "PSGroupCell",
      "id": "rescueGroup",
      "label": "RESCUE_GROUP"
    },
    {
      "omcGroup": "rescue",
      "cell": "PSButtonCell",
      "label": "RESCUE_RESTORE",
      "symbol": "arrow.uturn.backward",
      "action": "rescueRestore"
    },
    {
      "omcGroup": "conflicts",
      "cell": "PSGroupCell",
      "id": "conflictsGroup",
      "label": "CONFLICTS_GROUP"
    },
    {
      "omcGroup": "conflicts",
      "cell": "PSStaticTextCell",
      "id": "conflictsRow",
      "label": "CONFLICTS_GROUP",
      "symbol": "exclamationmark.triangle.fill"
    },
    {
      "label": "APPS_GROUP",
      "cell": "PSGroupCell"
    },
    {
      "cell": "PSLinkCell",
      "label": "APPS",
      "detail": "OMCAppBridgeAppsController",
      "symbol": "square.grid.2x2.fill",
      "cellClass": "OMCAppBridgeAppsLinkCell"
    },
    {
      "cell": "PSLinkCell",
      "label": "HOME_SCREEN",
      "detail": "OMCHomeScreenController",
      "symbol": "apps.iphone"
    },
    {
      "cell": "PSGroupCell",
      "id": "features",
      "label": "FEATURES_GROUP",
      "footerText": "FEATURES_FOOTER"
    },
    {
      "cell": "PSGroupCell"
    },
    {
      "cell": "PSLinkCell",
      "label": "PROFILES",
      "detail": "OMCCarProfilesController",
      "symbol": "car.2.fill"
    },
    {
      "label": "SUPPORT_GROUP",
      "cell": "PSGroupCell"
    },
    {
      "cell": "PSButtonCell",
      "id": "showGuide",
      "label": "ONB_SHOW_AGAIN",
      "symbol": "lightbulb",
      "action": "showGuide"
    },
    {
      "cell": "PSButtonCell",
      "id": "whatsNew",
      "label": "WN_ROW",
      "symbol": "sparkles",
      "action": "showWhatsNew"
    },
    {
      "label": "DEV_GROUP",
      "cell": "PSGroupCell",
      "footerText": "SUPPORT_FOOTER"
    },
    {
      "cell": "PSButtonCell",
      "id": "sendLog",
      "label": "SEND_LOG",
      "symbol": "square.and.arrow.up",
      "action": "sendLog"
    }
  ]
}
```

Root references controllers `OMCAppBridgeAppsController`, `OMCHomeScreenController`,
`OMCCarProfilesController`, link cell class `OMCAppBridgeAppsLinkCell`, and actions
`rescueRestore`, `showGuide`, `showWhatsNew`, `sendLog`. Feature pages themselves are **not** in
Root.plist — the `features` group is populated from the `Feature*.plist` files below.

### `FeatureSpeedBubble.plist` — full dump

```json
{
  "featureLabel": "SPEEDBUBBLE",
  "featureSymbol": "speedometer",
  "title": "Speed Bubble",
  "featureOrder": 20,
  "items": [
    {
      "cell": "PSGroupCell"
    },
    {
      "cell": "PSSwitchCell",
      "label": "SPEEDBUBBLE_ENABLE",
      "key": "speedBubbleEnabled",
      "default": true,
      "defaults": "com.anlai.omnicar",
      "PostNotification": "com.anlai.omnicar/prefschanged"
    }
  ],
  "featureController": "OMCSpeedBubbleController"
}
```

### `FeatureSplitScreen.plist` — full dump

```json
{
  "featureLabel": "SPLITSCREEN",
  "featureSymbol": "rectangle.split.2x1.fill",
  "title": "Split Screen",
  "featureOrder": 30,
  "items": [
    {
      "cell": "PSGroupCell"
    },
    {
      "cell": "PSSwitchCell",
      "label": "SPLITSCREEN_ENABLE",
      "key": "splitScreenEnabled",
      "default": true,
      "defaults": "com.anlai.omnicar",
      "PostNotification": "com.anlai.omnicar/prefschanged"
    }
  ],
  "featureController": "OMCSplitScreenController"
}
```

### `FeatureStartupScreen.plist` — full dump

```json
{
  "featureLabel": "STARTUPSCREEN",
  "featureSymbol": "play.rectangle.fill",
  "title": "Startup Screen",
  "featureOrder": 10,
  "items": [
    {
      "cell": "PSGroupCell"
    },
    {
      "cell": "PSSwitchCell",
      "label": "STARTUPSCREEN_ENABLE",
      "key": "startupScreenEnabled",
      "default": true,
      "defaults": "com.anlai.omnicar",
      "PostNotification": "com.anlai.omnicar/prefschanged"
    },
    {
      "cell": "PSGroupCell",
      "label": "STARTUPSCREEN_VIDEO_GROUP",
      "footerText": "STARTUPSCREEN_VIDEO_FOOTER",
      "ssStyles": [
        0
      ]
    },
    {
      "detail": "PSListItemsController",
      "id": "videoName",
      "defaults": "com.anlai.omnicar",
      "cell": "PSLinkListCell",
      "dynamicTitles": true,
      "label": "STARTUPSCREEN_CURRENT_VIDEO",
      "key": "startupScreenVideoName",
      "ssStyles": [
        0
      ],
      "PostNotification": "com.anlai.omnicar/prefschanged"
    },
    {
      "cell": "PSButtonCell",
      "label": "STARTUPSCREEN_ADD",
      "ssStyles": [
        0
      ],
      "action": "addVideo"
    },
    {
      "cell": "PSButtonCell",
      "label": "STARTUPSCREEN_PREVIEW",
      "ssStyles": [
        0
      ],
      "action": "previewVideo"
    },
    {
      "cell": "PSButtonCell",
      "label": "STARTUPSCREEN_DELETE",
      "ssStyles": [
        0
      ],
      "isDestructive": true,
      "action": "deleteVideo"
    },
    {
      "cell": "PSGroupCell",
      "label": "STARTUPSCREEN_DISPLAY_GROUP",
      "footerText": "STARTUPSCREEN_DISPLAY_FOOTER",
      "ssStyles": [
        0
      ]
    },
    {
      "validValues": [
        0,
        1
      ],
      "validTitles": [
        "STARTUPSCREEN_SCALE_FILL",
        "STARTUPSCREEN_SCALE_FIT"
      ],
      "defaults": "com.anlai.omnicar",
      "cell": "PSSegmentCell",
      "key": "startupScreenScaleMode",
      "ssStyles": [
        0
      ],
      "PostNotification": "com.anlai.omnicar/prefschanged",
      "default": 0
    },
    {
      "defaults": "com.anlai.omnicar",
      "cell": "PSSwitchCell",
      "label": "STARTUPSCREEN_PLAY_FULL",
      "key": "startupScreenPlayFull",
      "ssStyles": [
        0
      ],
      "PostNotification": "com.anlai.omnicar/prefschanged",
      "default": false
    },
    {
      "defaults": "com.anlai.omnicar",
      "cell": "PSSwitchCell",
      "label": "STARTUPSCREEN_SOUND",
      "key": "startupScreenSound",
      "ssStyles": [
        0
      ],
      "PostNotification": "com.anlai.omnicar/prefschanged",
      "default": false
    },
    {
      "cell": "PSGroupCell",
      "label": "STARTUPSCREEN_LOGO_GROUP",
      "footerText": "STARTUPSCREEN_LOGO_FOOTER",
      "ssStyles": [
        1
      ]
    },
    {
      "validValues": [
        0,
        1,
        2
      ],
      "validTitles": [
        "STARTUPSCREEN_EFFECT_FADE",
        "STARTUPSCREEN_EFFECT_ZOOM",
        "STARTUPSCREEN_EFFECT_GLOW"
      ],
      "defaults": "com.anlai.omnicar",
      "cell": "PSSegmentCell",
      "key": "startupScreenLogoEffect",
      "ssStyles": [
        1
      ],
      "PostNotification": "com.anlai.omnicar/prefschanged",
      "default": 0
    },
    {
      "cell": "PSButtonCell",
      "label": "STARTUPSCREEN_LOGO_CHOOSE",
      "ssStyles": [
        1
      ],
      "action": "chooseLogo"
    },
    {
      "cell": "PSButtonCell",
      "label": "STARTUPSCREEN_LOGO_DELETE",
      "ssStyles": [
        1
      ],
      "isDestructive": true,
      "action": "deleteLogo"
    },
    {
      "cell": "PSGroupCell",
      "id": "nameGroup",
      "label": "STARTUPSCREEN_GREETING_GROUP",
      "footerText": "STARTUPSCREEN_GREETING_FOOTER",
      "ssStyles": [
        2,
        3,
        6,
        8
      ]
    },
    {
      "placeholder": "STARTUPSCREEN_NAME_PLACEHOLDER",
      "defaults": "com.anlai.omnicar",
      "cell": "PSEditTextCell",
      "label": "STARTUPSCREEN_NAME",
      "key": "startupScreenGreetingName",
      "ssStyles": [
        2,
        3,
        6,
        8
      ],
      "PostNotification": "com.anlai.omnicar/prefschanged"
    },
    {
      "cell": "PSGroupCell",
      "id": "carGroup",
      "footerText": "STARTUPSCREEN_CAR_NAME_FOOTER",
      "ssStyles": [
        4,
        7
      ]
    },
    {
      "id": "carName",
      "defaults": "com.anlai.omnicar",
      "cell": "PSEditTextCell",
      "label": "STARTUPSCREEN_CAR_NAME",
      "key": "startupScreenCarName",
      "ssStyles": [
        4,
        7
      ],
      "PostNotification": "com.anlai.omnicar/prefschanged"
    },
    {
      "cell": "PSGroupCell",
      "id": "tempoGroup",
      "footerText": "STARTUPSCREEN_TEMPO_FOOTER",
      "ssStyles": [
        5
      ]
    },
    {
      "validValues": [
        0,
        1,
        2
      ],
      "validTitles": [
        "STARTUPSCREEN_TEMPO_SLOW",
        "STARTUPSCREEN_TEMPO_NORMAL",
        "STARTUPSCREEN_TEMPO_FAST"
      ],
      "defaults": "com.anlai.omnicar",
      "cell": "PSSegmentCell",
      "key": "startupScreenTempo",
      "ssStyles": [
        5
      ],
      "PostNotification": "com.anlai.omnicar/prefschanged",
      "default": 1
    },
    {
      "cell": "PSGroupCell",
      "label": "STARTUPSCREEN_RANDOM_GROUP",
      "footerText": "STARTUPSCREEN_RANDOM_FOOTER",
      "ssStyles": [
        9
      ]
    },
    {
      "cell": "PSButtonCell",
      "label": "STARTUPSCREEN_STYLE_VIDEO",
      "symbol": "film",
      "ssRandomStyle": 0,
      "ssStyles": [
        9
      ],
      "action": "toggleRandomStyle:"
    },
    {
      "cell": "PSButtonCell",
      "label": "STARTUPSCREEN_STYLE_LOGO",
      "symbol": "seal",
      "ssRandomStyle": 1,
      "ssStyles": [
        9
      ],
      "action": "toggleRandomStyle:"
    },
    {
      "cell": "PSButtonCell",
      "label": "STARTUPSCREEN_STYLE_GREETING",
      "symbol": "hand.wave",
      "ssRandomStyle": 2,
      "ssStyles": [
        9
      ],
      "action": "toggleRandomStyle:"
    },
    {
      "cell": "PSButtonCell",
      "label": "STARTUPSCREEN_STYLE_WEATHER",
      "symbol": "cloud.sun.rain",
      "ssRandomStyle": 3,
      "ssStyles": [
        9
      ],
      "action": "toggleRandomStyle:"
    },
    {
      "cell": "PSButtonCell",
      "label": "STARTUPSCREEN_STYLE_ENGINE",
      "symbol": "speedometer",
      "ssRandomStyle": 4,
      "ssStyles": [
        9
      ],
      "action": "toggleRandomStyle:"
    },
    {
      "cell": "PSButtonCell",
      "label": "STARTUPSCREEN_STYLE_WELCOME",
      "symbol": "car.fill",
      "ssRandomStyle": 5,
      "ssStyles": [
        9
      ],
      "action": "toggleRandomStyle:"
    },
    {
      "cell": "PSButtonCell",
      "label": "STARTUPSCREEN_STYLE_PARTICLES",
      "symbol": "sparkles",
      "ssRandomStyle": 6,
      "ssStyles": [
        9
      ],
      "action": "toggleRandomStyle:"
    },
    {
      "cell": "PSButtonCell",
      "label": "STARTUPSCREEN_STYLE_HUD",
      "symbol": "scope",
      "ssRandomStyle": 7,
      "ssStyles": [
        9
      ],
      "action": "toggleRandomStyle:"
    },
    {
      "cell": "PSButtonCell",
      "label": "STARTUPSCREEN_STYLE_BRIEFING",
      "symbol": "rectangle.grid.2x2",
      "ssRandomStyle": 8,
      "ssStyles": [
        9
      ],
      "action": "toggleRandomStyle:"
    },
    {
      "label": "STARTUPSCREEN_DURATION_GROUP",
      "cell": "PSGroupCell",
      "footerText": "STARTUPSCREEN_DURATION_FOOTER"
    },
    {
      "showValue": true,
      "min": 1.0,
      "defaults": "com.anlai.omnicar",
      "cell": "PSSliderCell",
      "isSegmented": true,
      "key": "startupScreenDuration",
      "max": 30.0,
      "segmentCount": 29,
      "PostNotification": "com.anlai.omnicar/prefschanged",
      "default": 5.0
    },
    {
      "cell": "PSSwitchCell",
      "label": "STARTUPSCREEN_TAP_TO_SKIP",
      "key": "startupScreenTapToSkip",
      "default": true,
      "defaults": "com.anlai.omnicar",
      "PostNotification": "com.anlai.omnicar/prefschanged"
    },
    {
      "cell": "PSGroupCell",
      "id": "soundGroup",
      "label": "STARTUPSCREEN_STARTUP_SOUND_GROUP",
      "footerText": "STARTUPSCREEN_STARTUP_SOUND_FOOTER"
    },
    {
      "label": "STARTUPSCREEN_SOUND_CHOOSE",
      "cell": "PSButtonCell",
      "action": "chooseSound"
    },
    {
      "label": "STARTUPSCREEN_SOUND_PREVIEW",
      "cell": "PSButtonCell",
      "action": "previewSound"
    },
    {
      "cell": "PSButtonCell",
      "label": "STARTUPSCREEN_SOUND_DELETE",
      "isDestructive": true,
      "action": "deleteSound"
    },
    {
      "showValue": true,
      "min": 0.0,
      "defaults": "com.anlai.omnicar",
      "cell": "PSSliderCell",
      "isSegmented": true,
      "key": "startupScreenSoundVolume",
      "max": 100.0,
      "segmentCount": 20,
      "PostNotification": "com.anlai.omnicar/prefschanged",
      "default": 100.0
    },
    {
      "cell": "PSSwitchCell",
      "label": "STARTUPSCREEN_SOUND_SKIP_CALL",
      "key": "startupScreenSoundSkipCall",
      "default": true,
      "defaults": "com.anlai.omnicar",
      "PostNotification": "com.anlai.omnicar/prefschanged"
    },
    {
      "label": "STARTUPSCREEN_OCCASIONS_GROUP",
      "cell": "PSGroupCell",
      "footerText": "STARTUPSCREEN_OCCASIONS_FOOTER"
    },
    {
      "cell": "PSSwitchCell",
      "label": "STARTUPSCREEN_OCCASIONS",
      "key": "startupScreenOccasions",
      "default": true,
      "defaults": "com.anlai.omnicar",
      "PostNotification": "com.anlai.omnicar/prefschanged"
    },
    {
      "id": "birthday",
      "cell": "PSStaticTextCell",
      "label": "STARTUPSCREEN_BIRTHDAY"
    },
    {
      "cell": "PSButtonCell",
      "id": "occasionPreview",
      "label": "STARTUPSCREEN_PREVIEW",
      "action": "previewOccasion"
    }
  ],
  "featureController": "OMCStartupScreenController"
}
```

### `WhatsNew.plist` — full dump

```json
{
  "1.0.0": [
    {
      "textKey": "WN_KEYBOARD_TEXT",
      "titleKey": "WN_KEYBOARD_TITLE",
      "symbol": "keyboard"
    },
    {
      "textKey": "WN_ZOOM_TEXT",
      "titleKey": "WN_ZOOM_TITLE",
      "symbol": "arrow.up.left.and.arrow.down.right"
    },
    {
      "textKey": "WN_LANG_TEXT",
      "titleKey": "WN_LANG_TITLE",
      "symbol": "globe"
    },
    {
      "textKey": "WN_GUIDE_TEXT",
      "titleKey": "WN_GUIDE_TITLE",
      "symbol": "lightbulb"
    }
  ]
}
```

### PreferenceLoader entry — `var/jb/Library/PreferenceLoader/Preferences/OmniCarPrefs.plist`

| File | Size (bytes) | SHA-256 |
|---|---:|---|
| `OmniCarPrefs.plist` | 186 | `577dc46878a58aa6cd1f068f84a73f86e31dcd6313ec4eaf0b5960b25ea91f8e` |

```json
{
  "entry": {
    "cell": "PSLinkCell",
    "bundle": "OmniCarPrefs",
    "detail": "OMCRootListController",
    "icon": "icon.png",
    "label": "OmniCar",
    "isController": true
  }
}
```

### Localization

14 locales, each a `<locale>.lproj` directory inside the prefs bundle, containing binary-plist
`.strings` files (all 139 are `Apple binary property list`):

| Locale | .strings files |
|---|---:|
| ar, de, en, es, fr, id, it, ja, ko, pt-BR, ru, th, zh-Hans (13 locales) | 10 each |
| vi | **9** (see Anomalies) |

The 10 tables per full locale: `AppBridge`, `Car`, `HomeScreen`, `Localizable`, `Onboarding`,
`Profiles`, `SpeedBubble`, `SplitScreen`, `StartupScreen`, `WhatsNew`.

## 6. Summary counts

| Kind | Count | Notes |
|---|---:|---|
| macho-exec | 1 | `OmniCar.app/OmniCar` |
| macho-dylib | 7 | 6 substrate dylibs + `OmniCarPrefs` (header filetype is DYLIB, not BUNDLE) |
| macho-bundle | **0** | no file in this package has Mach-O filetype `MH_BUNDLE` |
| plist-binary | 153 | 14 functional plists + 139 `.strings`; **zero** XML plists in the package |
| plist-xml | 0 | |
| png | 15 | 2 app icons + 13 prefs-bundle images |
| script | 0 | no shell scripts anywhere (payload or control) |
| deb-control | 1 | `control` only |
| **Total manifest rows** | **177** | 176 payload files + 1 control file |

Payload totals: 176 files, 5,909,467 bytes; 25 subdirectories; 0 symlinks.

### Canonical list of ALL Mach-O binaries (module assignment source of truth)

All 8 are FAT, 2 slices each: **arm64 + arm64e (PAC00)**.

| # | Binary | Filetype | Size (bytes) | Filter / host |
|---|---|---|---:|---|
| 1 | `var/jb/Applications/OmniCar.app/OmniCar` | EXECUTE | 168,880 | the app itself |
| 2 | `DynamicLibraries/OmniCarCore.dylib` | DYLIB | 276,832 | SpringBoard |
| 3 | `DynamicLibraries/OmniCarAppBridge.dylib` | DYLIB | 613,376 | all UIKit processes |
| 4 | `DynamicLibraries/OmniCarCarProbe.dylib` | DYLIB | 242,784 | CarPlayApp |
| 5 | `DynamicLibraries/OmniCarSpeedBubble.dylib` | DYLIB | 649,808 | SpringBoard, CarPlayApp, 4 nav apps |
| 6 | `DynamicLibraries/OmniCarSplitScreen.dylib` | DYLIB | 1,229,920 | CarPlayApp, SpringBoard |
| 7 | `DynamicLibraries/OmniCarStartupScreen.dylib` | DYLIB | 567,792 | CarPlayApp, SpringBoard |
| 8 | `PreferenceBundles/OmniCarPrefs.bundle/OmniCarPrefs` | DYLIB | 1,303,344 | PreferenceLoader (Settings) |

## 7. Anomalies and unusual findings

1. **No maintainer scripts at all** (see §2) — unusual for a package of this complexity; also no
   `md5sums` file in control.tar.gz.
2. **`vi.lproj` is missing `Car.strings`** — 9 files vs 10 in every other locale (139 .strings
   total instead of 140). Vietnamese UI will fall back for the Car table.
3. **data.tar is LZMA** (`data.tar.lzma`), not the xz used by most modern rootless packages;
   control.tar is gzip.
4. **`OmniCarPrefs` is Mach-O filetype DYLIB**, not MH_BUNDLE, despite living in a `.bundle` and
   being the Settings principal class host. (So the project's `macho-bundle` kind has zero members.)
5. **App bundle is bare**: 4 files, no nibs/storyboards/asset catalogs — all UI is programmatic.
   Info.plist declares **portrait-only** orientations and has **no background modes, no usage
   descriptions, no scene manifest**.
6. **AppBridge's filter is `com.apple.UIKit`** — it injects into every UIKit process on the device,
   the broadest possible substrate filter.
7. **Duplicate basenames are only localization artifacts**: the 10 `.strings` names repeat across
   the 14 `.lproj` dirs, and `Info.plist` exists twice (app + prefs bundle). No other duplicates.
8. **No symlinks, no empty files, no empty directories, no embedded `.framework`/`.app`/archives**
   anywhere in the payload. Every file without an extension is one of the 8 Mach-O binaries
   (`OmniCar`, `OmniCarPrefs`); there are no extension-less non-Mach-O files.
9. Installed-Size (6,307,840 B) exceeds the true payload byte sum (5,909,467 B) by ~398 KB —
   normal dpkg accounting (directories/rounding), not missing content; the `dpkg-deb -c` ↔
   extraction comparison above is exact.
