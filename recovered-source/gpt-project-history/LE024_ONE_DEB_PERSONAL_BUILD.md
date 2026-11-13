# DuoCar + Lề 0.2.4 — private one-DEB merge

Scope: personal-use packaging of an original, signed Lề 0.2.4, a rebuilt
signed DuoCar, and one separately compiled, signed DuoCar-specific Le
extension. The extension is merged into ONE final package and is not
installed as a separate package. No unverified runtime is called complete.

Original Le DEB SHA-256:
98a234f404987d5958bc80a19e0ed62d34ca2b39d4ef6e798bfd3314e2cb4770

Files:
- merge_le024_personal_deb.py: exact original-vendor hash gate and byte-for-byte
  preservation, stage and merge; rejects collisions and missing source pieces.
- project/OmniCarLeExtension: experimental source with ABI checks for moving
  speed numeric text, GPS offset (-5..+5) and free X/Y bubble positioning.
- project/OmniCarApp/OMCLePrefsHost.m: opens original vendor settings from
  the retained LePrefs.bundle inside DuoCar's UIKit Settings.
- tests/test_merge_le024_personal.py: synthetic package fixture test only.

From the repository root, test packaging:

    python3 recovered-source/gpt-project-history/tests/test_merge_le024_personal.py

Once real signed inputs are available, use locally:

    python3 recovered-source/gpt-project-history/merge_le024_personal_deb.py \
      --duocar /path/to/duocar-base.deb \
      --le /path/to/dev.bechou.le_0.2.4_iphoneos-arm64.deb \
      --extension /path/to/duocar-leextension.deb \
      --output /path/to/duocar.deb --personal-use

The old DuoCarSpeedBubble dylib/filter are removed from staging, while all
9 original Le runtime dylibs + filters, LePrefs executable, fonts, artwork
and any other original vendor assets are preserved byte-identically. The
old independent Le PreferenceLoader link is excluded because the original
settings page is accessed inside DuoCar. No vendor postinst is executed.
The DEB declares Conflicts/Replaces with the independently installed
dev.bechou.le to prevent overlapping package ownership; package managers
may ask to uninstall standalone Lề. No other installed package is removed
by this script. Original Lề is iOS 15..26 only; firmware <27 is retained.

Licensing: the vendor's binaries have no confirmed redistribution license.
The Saira font OFL does not license the tweak binary. Never publish this
combined package publicly without explicit rights.

Unproven: actual Le DEB source bytes unavailable in this session; not yet
compiled/ldid-signed against iPhoneOS SDK; no on-car verification of the
source renderer's km/h suffix, corrected overspeed state, cast overlay or
free X/Y pan; vendor LePrefs loaded into DuoCar UIKit is not device-proven.
Synthetic fixture checks are NOT a device or exact final DEB PASS.
