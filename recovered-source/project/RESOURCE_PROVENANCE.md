# Resource Provenance — OmniCar 1.0.3 scaffold project

Every non-executable file in this project was copied byte-for-byte from the
verified original payload (`~/workspace/omnicar-re/payload/`, DEB SHA-256
`d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`).
Each SHA-256 below was recomputed during the copy and checked against
`inventory/manifest.tsv` (wave-1 inventory); all matched.

The 8 Mach-O binaries were **not** copied — they are rebuilt from the
reconstructed sources under `src/<Module>/`.

The package `control` file at the project root is a byte copy of the
original `DEBIAN/control` (SHA-256 `296ceaf49faaea1723f5d994f6cf670f2bcf05671bd4c06bc9035af50e8b8f5f`). Theos regenerates
`Installed-Size` at package time; all other fields are used verbatim.

| Original payload path | Project path | Bytes | SHA-256 |
|---|---|---:|---|
| `var/jb/Applications/OmniCar.app/Info.plist` | `OmniCarApp/Resources/Info.plist` | 897 | `058136b8e31515de8b7368e80af989c67cea64d80fb99a122e6851c83ca6b541` |
| `var/jb/Applications/OmniCar.app/AppIcon60x60@2x.png` | `OmniCarApp/Resources/AppIcon60x60@2x.png` | 24659 | `b304145f7002c44d0e33b43c30886510ce6c97c6e215cad36f938f63827fb164` |
| `var/jb/Applications/OmniCar.app/AppIcon60x60@3x.png` | `OmniCarApp/Resources/AppIcon60x60@3x.png` | 44470 | `bab820c8bd04975393d268ac3ea9e1dd8665a317a0eab4dbe9a6d1f62381da00` |
| `var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarCore.plist` | `OmniCarCore/OmniCarCore.plist` | 93 | `86345479d62d39c2b9fc6f879bbed191913b153deefa1aa486ca1e19c8664304` |
| `var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarAppBridge.plist` | `OmniCarAppBridge/OmniCarAppBridge.plist` | 87 | `023eb9e22181a840bc7ead9806b70b33e6ebb5822adb1ffe5afda3873459c35b` |
| `var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarCarProbe.plist` | `OmniCarCarProbe/OmniCarCarProbe.plist` | 92 | `9fbf4a476ff57470977adc2b30c7c7052d0434d1b713895b82fe44e71a8d58b0` |
| `var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarSpeedBubble.plist` | `OmniCarSpeedBubble/OmniCarSpeedBubble.plist` | 194 | `f31137da54adf6860904581cd1db44a8addda023b857550d9ef21361217788fe` |
| `var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarSplitScreen.plist` | `OmniCarSplitScreen/OmniCarSplitScreen.plist` | 118 | `9503d73445cec4a57d8210637028a5730d587551d457e70e448b9f974fc04e14` |
| `var/jb/Library/MobileSubstrate/DynamicLibraries/OmniCarStartupScreen.plist` | `OmniCarStartupScreen/OmniCarStartupScreen.plist` | 118 | `9503d73445cec4a57d8210637028a5730d587551d457e70e448b9f974fc04e14` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/FeatureSpeedBubble.plist` | `OmniCarPrefs/Resources/FeatureSpeedBubble.plist` | 438 | `6d34c6447f0dde63b0589a50cacbdb01c6237a5dd4222b4b8533276975210a13` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/FeatureSplitScreen.plist` | `OmniCarPrefs/Resources/FeatureSplitScreen.plist` | 453 | `26e7f57d6953f48ec008157eb0b0acb5d7e6d52caf51b163311680ba8c4f15e1` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/FeatureStartupScreen.plist` | `OmniCarPrefs/Resources/FeatureStartupScreen.plist` | 4055 | `368e27c2309d2f793a47e45b9ae194b9b3c903950b995f8df222602ff71fbb9c` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/Info.plist` | `OmniCarPrefs/Resources/Info.plist` | 402 | `96f58b1cb9f43708a487bad46ab9382b7b55b854f529c01435df18960492f2e2` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/PackageIcon.png` | `OmniCarPrefs/Resources/PackageIcon.png` | 74767 | `e8663a8b360c85c9b151e354d7bc62262e5b18edada7bc80c52cb32095ee972c` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/Root.plist` | `OmniCarPrefs/Resources/Root.plist` | 1033 | `9b44aadf58c92e1aae94567c5b49545865ce958255dc3c24276c8a797e56df24` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/SpeedBubbleIcon.png` | `OmniCarPrefs/Resources/SpeedBubbleIcon.png` | 2092 | `3b63f8510689c9393936b96eb85f67dd9a36591af6a5000958d67b80a9b33156` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/SpeedBubbleIcon@2x.png` | `OmniCarPrefs/Resources/SpeedBubbleIcon@2x.png` | 4963 | `615f6f8beea12ddb419ba850e31696fc8d9d8cf023fc9e1d77d489e80c7dfc18` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/SpeedBubbleIcon@3x.png` | `OmniCarPrefs/Resources/SpeedBubbleIcon@3x.png` | 7688 | `ecc7e132e77729c009c11153afa2fad2bd7832e44f9271c80f98076b35b0c43b` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/StartupScreenIcon.png` | `OmniCarPrefs/Resources/StartupScreenIcon.png` | 1567 | `8912542026dd6b1d8af665721cb71550a225d0c9a3e3f6096878ca91811ffe90` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/StartupScreenIcon@2x.png` | `OmniCarPrefs/Resources/StartupScreenIcon@2x.png` | 3150 | `02068cf8c3a7cae437f16cb40eeba7e284f276dd8b2a98382e4a3982da43fda8` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/StartupScreenIcon@3x.png` | `OmniCarPrefs/Resources/StartupScreenIcon@3x.png` | 4912 | `1bfc0b7305f3ec4c1e12252329ed0da12d6c956d0fce76eae41381639d3c86cf` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/WhatsNew.plist` | `OmniCarPrefs/Resources/WhatsNew.plist` | 334 | `6f787826422ae62820f1329008bf9f5b3bea1567e20d6d0a21e07bc2ede02160` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ar.lproj/AppBridge.strings` | `OmniCarPrefs/Resources/ar.lproj/AppBridge.strings` | 663 | `a8ad9b1624e730d073659c2ddc8367d965e1e30ba33279fa06ad2833b2224b27` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ar.lproj/Car.strings` | `OmniCarPrefs/Resources/ar.lproj/Car.strings` | 5582 | `ac89ccda57c694534af23d5d397d4d9af6b67cccd0b7b0c7817aac757cc4e8b8` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ar.lproj/HomeScreen.strings` | `OmniCarPrefs/Resources/ar.lproj/HomeScreen.strings` | 3835 | `acc1a301de2e1dbdc269744f1504690dd8dc7d88cb42ae2e797263b8d3f37bf5` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ar.lproj/Localizable.strings` | `OmniCarPrefs/Resources/ar.lproj/Localizable.strings` | 15237 | `21d5d285959a5c9650af40704b5d83fa3b2091394561acd17d4f5c3b45fb3497` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ar.lproj/Onboarding.strings` | `OmniCarPrefs/Resources/ar.lproj/Onboarding.strings` | 2515 | `ffc0f6b30ad53003e63929862fca18964dd2ac6630343b632688bcc79561d10f` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ar.lproj/Profiles.strings` | `OmniCarPrefs/Resources/ar.lproj/Profiles.strings` | 893 | `907f12fc267f1d0de2700edd029ac95fafc829e219129e5a8c4a6d3bbfbda5a0` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ar.lproj/SpeedBubble.strings` | `OmniCarPrefs/Resources/ar.lproj/SpeedBubble.strings` | 5182 | `283332c39a210c56eb543c4ea3a98e511a027ccf67ad943d296819a089e50647` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ar.lproj/SplitScreen.strings` | `OmniCarPrefs/Resources/ar.lproj/SplitScreen.strings` | 4587 | `468c1e102283a463f9f91f5c00226306463b3e0d0c3f44f100ec1dd3d4e74172` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ar.lproj/StartupScreen.strings` | `OmniCarPrefs/Resources/ar.lproj/StartupScreen.strings` | 4995 | `7b34faaae2f2373d545f9727a47dbe5e648b3ba6fd659c0d804383e42056fef7` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ar.lproj/WhatsNew.strings` | `OmniCarPrefs/Resources/ar.lproj/WhatsNew.strings` | 1120 | `a52973587c7075916123873fc28175358e0fc7d4a8524c7fb8044612d41b92c3` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/de.lproj/AppBridge.strings` | `OmniCarPrefs/Resources/de.lproj/AppBridge.strings` | 553 | `fbaa5e74d2ed0c19c3808a48261987c6168382d77ecbf8069c16187f61f20be8` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/de.lproj/Car.strings` | `OmniCarPrefs/Resources/de.lproj/Car.strings` | 5723 | `19e634ab081e55557f8c27b791ab0eab00839d3b60cb345388e6017280a6b7e7` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/de.lproj/HomeScreen.strings` | `OmniCarPrefs/Resources/de.lproj/HomeScreen.strings` | 3970 | `bb4ff9eeb9a876a0179128ea4c88e1db71c3e4751efe4d38c71e27d835fd7404` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/de.lproj/Localizable.strings` | `OmniCarPrefs/Resources/de.lproj/Localizable.strings` | 15344 | `82c93e18c1e9573b90668a0327a8b7396b3904556b299b14c3e0fafdb7a1397a` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/de.lproj/Onboarding.strings` | `OmniCarPrefs/Resources/de.lproj/Onboarding.strings` | 2799 | `70065b75d7a34acea5296421fa3024c06db2ba28f342508506f00ef2731a9aec` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/de.lproj/Profiles.strings` | `OmniCarPrefs/Resources/de.lproj/Profiles.strings` | 920 | `4a8f1fb995fc4ae2d07f2904949cf419dcfd8bbaf913bff025eae558ea4d4167` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/de.lproj/SpeedBubble.strings` | `OmniCarPrefs/Resources/de.lproj/SpeedBubble.strings` | 5070 | `d4a5a0fdb7267d0a762cddedc4bcab46ca275ec26629a5514279a3fa0ea0a112` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/de.lproj/SplitScreen.strings` | `OmniCarPrefs/Resources/de.lproj/SplitScreen.strings` | 4509 | `bbec305189bf3286c1053ccb346a321bcc22684bfd39ce3a2bd11661351981c9` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/de.lproj/StartupScreen.strings` | `OmniCarPrefs/Resources/de.lproj/StartupScreen.strings` | 4975 | `f8bf9782c59afc94fd5ca4bd0c6e342b37ec75755f2bd055d43b695a9fc67c26` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/de.lproj/WhatsNew.strings` | `OmniCarPrefs/Resources/de.lproj/WhatsNew.strings` | 1156 | `6ab861e93354be16e1f08ebb577d9290e2a35988f2b076d3ebb2ba9e03826a1d` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/en.lproj/AppBridge.strings` | `OmniCarPrefs/Resources/en.lproj/AppBridge.strings` | 462 | `cb4f92cfde6ce4cb70770d80ea3ba165700affda4e4aae1417ff49c3eea944f2` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/en.lproj/Car.strings` | `OmniCarPrefs/Resources/en.lproj/Car.strings` | 3245 | `abc121162e1e0e68ff2c1145f75550d38a2ed5cbb7f132f119d25b9a4280295e` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/en.lproj/HomeScreen.strings` | `OmniCarPrefs/Resources/en.lproj/HomeScreen.strings` | 2609 | `0d81a36b27bbd5ac64f67051f54f254ee3390265664cbc340ffd3b5ce712261c` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/en.lproj/Localizable.strings` | `OmniCarPrefs/Resources/en.lproj/Localizable.strings` | 10556 | `4e98adc62dd47a0c9c163cbb224ad0e38470ce9a65e9f8981b043478f30a4289` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/en.lproj/Onboarding.strings` | `OmniCarPrefs/Resources/en.lproj/Onboarding.strings` | 2063 | `aa42901451df45a5a0794e6da6710181c01c1ed7b30e64ad58f06c0c61ef6c5c` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/en.lproj/Profiles.strings` | `OmniCarPrefs/Resources/en.lproj/Profiles.strings` | 594 | `23ed744cad8f4a53f282978f38ed1a99fab1ccd4ab3068337718d924ae62c388` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/en.lproj/SpeedBubble.strings` | `OmniCarPrefs/Resources/en.lproj/SpeedBubble.strings` | 4134 | `8a6b8fe60831247a8770feb343e4c1736b3454288f61475faebe1692375d4f23` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/en.lproj/SplitScreen.strings` | `OmniCarPrefs/Resources/en.lproj/SplitScreen.strings` | 3741 | `09ebad422b7a35053e14b704c1c0ae88330bd61cd3f6d1ee999b48481efd22f0` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/en.lproj/StartupScreen.strings` | `OmniCarPrefs/Resources/en.lproj/StartupScreen.strings` | 5452 | `1327a9d41b9b5965ac2360383cf41556819e1f7a16cc80567969aeb6d43a3e56` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/en.lproj/WhatsNew.strings` | `OmniCarPrefs/Resources/en.lproj/WhatsNew.strings` | 834 | `7acab7025e860564e4a52e9112aa97311e2f884c0d59b1f659048679b2cd4861` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/es.lproj/AppBridge.strings` | `OmniCarPrefs/Resources/es.lproj/AppBridge.strings` | 503 | `18c0dd41655d4f35bd4e5576af145aa397c436fb25aa168f2454e0922683c7d0` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/es.lproj/Car.strings` | `OmniCarPrefs/Resources/es.lproj/Car.strings` | 5259 | `d90796edbe26af4475370f90d7c71039041dec71945becabd67e9f1e2bad641b` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/es.lproj/HomeScreen.strings` | `OmniCarPrefs/Resources/es.lproj/HomeScreen.strings` | 3885 | `39e07a462619a250b76d59c1bb4cea710230802ef2ba5810bb8ef85c752e199d` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/es.lproj/Localizable.strings` | `OmniCarPrefs/Resources/es.lproj/Localizable.strings` | 15568 | `cfc2fe0f326b7d2d9f59ad2730c910118d4ccc63022b59247278b9b18321cfb6` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/es.lproj/Onboarding.strings` | `OmniCarPrefs/Resources/es.lproj/Onboarding.strings` | 2903 | `2d1ca70650fc80ff787615985a8389e963fa7bea2378e313ad4ec2431be76fa3` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/es.lproj/Profiles.strings` | `OmniCarPrefs/Resources/es.lproj/Profiles.strings` | 959 | `3b32914a863734e3b32bc01f7f4d1ee11dc8d8319ffbbd8a22a7e0e43460b090` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/es.lproj/SpeedBubble.strings` | `OmniCarPrefs/Resources/es.lproj/SpeedBubble.strings` | 5369 | `9f93b12aaad3d1c340f1b0be3c0b0cb04cd83ddc42b60ba0dfd2b7a5dd860ce5` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/es.lproj/SplitScreen.strings` | `OmniCarPrefs/Resources/es.lproj/SplitScreen.strings` | 4465 | `0f652f3f6ba191fd68877d21f855089712ed8116f86c806c66c8588bbe770fbd` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/es.lproj/StartupScreen.strings` | `OmniCarPrefs/Resources/es.lproj/StartupScreen.strings` | 5225 | `2777d22136dcaca6474e9e519cf8ec8f4b8c34101b8094dfac22cd0f6496c180` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/es.lproj/WhatsNew.strings` | `OmniCarPrefs/Resources/es.lproj/WhatsNew.strings` | 1150 | `b381dd87da9cd33a2159827639a9c3df9e929535c8c62c8df842fc380815d0dc` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/fr.lproj/AppBridge.strings` | `OmniCarPrefs/Resources/fr.lproj/AppBridge.strings` | 691 | `5b8949c66efb54efef77a14a0886c786d4f32808b92090ac9f3efc3812811315` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/fr.lproj/Car.strings` | `OmniCarPrefs/Resources/fr.lproj/Car.strings` | 6013 | `dbb504a22f2ceb7717b0e4a51c0920fddbd910ea89c43e3c452b51060892797e` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/fr.lproj/HomeScreen.strings` | `OmniCarPrefs/Resources/fr.lproj/HomeScreen.strings` | 4434 | `d5fe308f7ccbf9b083d4865b02770c1750cfd4cbc56313f7b4668e1baf85e1f1` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/fr.lproj/Localizable.strings` | `OmniCarPrefs/Resources/fr.lproj/Localizable.strings` | 16972 | `58fbb0e2bebef69d7e78b79b428c9b366b8320bb80b49998593bdfd19197639c` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/fr.lproj/Onboarding.strings` | `OmniCarPrefs/Resources/fr.lproj/Onboarding.strings` | 3076 | `2d6355cb7c1c9e834b8a9c34fef68dcb1e6f4764d5b5c1800e68605846ed5aa7` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/fr.lproj/Profiles.strings` | `OmniCarPrefs/Resources/fr.lproj/Profiles.strings` | 1046 | `b689058594ddc8167182f5baa95659739ac5fc48f673108e4b8758d34da13c85` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/fr.lproj/SpeedBubble.strings` | `OmniCarPrefs/Resources/fr.lproj/SpeedBubble.strings` | 5494 | `7e0ee6c83d73fb8d7bd0316c582719ec2ae6c0fab358a149a20e68785909e5f5` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/fr.lproj/SplitScreen.strings` | `OmniCarPrefs/Resources/fr.lproj/SplitScreen.strings` | 4797 | `f8670b7249bd5fad6ed4359c1a6f2b5de5d1b19efe597a3cd5122611998e32aa` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/fr.lproj/StartupScreen.strings` | `OmniCarPrefs/Resources/fr.lproj/StartupScreen.strings` | 5611 | `be216d9dc47880b253e281e211f83cba475c6714f2836980c8488dd78a5ebc6d` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/fr.lproj/WhatsNew.strings` | `OmniCarPrefs/Resources/fr.lproj/WhatsNew.strings` | 1408 | `262782b33f073fcd14be796459bd4da3a4bbcfdc70ad4e8cc36cb703fbde884f` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/icon.png` | `OmniCarPrefs/Resources/icon.png` | 2481 | `db186260d10b29bcfcf48d8fb2e1ecd346fd60c13eb31c7a4130b29ee58450bd` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/icon@2x.png` | `OmniCarPrefs/Resources/icon@2x.png` | 7968 | `473c7dc85b502977bd4d5b19b672ed30ad76e6d2a219a66abf416b66804dc073` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/icon@3x.png` | `OmniCarPrefs/Resources/icon@3x.png` | 14988 | `0d4e4682b382861ef68b2cf48cc33ee12b8b9fad1357d6299aef6bd7227d6360` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/id.lproj/AppBridge.strings` | `OmniCarPrefs/Resources/id.lproj/AppBridge.strings` | 478 | `780e53099897332de1458497a940c8d54e8c8772d0246fb5dd588457e4c96593` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/id.lproj/Car.strings` | `OmniCarPrefs/Resources/id.lproj/Car.strings` | 4438 | `99068a638ecf876d99f12472442152211fb2b27dc81b147190abc0fc46674ddb` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/id.lproj/HomeScreen.strings` | `OmniCarPrefs/Resources/id.lproj/HomeScreen.strings` | 2826 | `ca6814192d39bd6e6756ad6b926db19df4a292024b2370fd0de33ee1591b5f6e` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/id.lproj/Localizable.strings` | `OmniCarPrefs/Resources/id.lproj/Localizable.strings` | 11228 | `d196207c4af7b5decbf6cebed227ea8dce428be6ea4ad2f348f2cd9616b50d6f` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/id.lproj/Onboarding.strings` | `OmniCarPrefs/Resources/id.lproj/Onboarding.strings` | 2213 | `e833c8a30564c4cacd6a9049f353e947cb9c45f64d1127267e880f3777ba56b8` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/id.lproj/Profiles.strings` | `OmniCarPrefs/Resources/id.lproj/Profiles.strings` | 697 | `c8988f956bf8f4b686b752790d7b4b8405d1bc2477cf561980248975cfc9d386` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/id.lproj/SpeedBubble.strings` | `OmniCarPrefs/Resources/id.lproj/SpeedBubble.strings` | 4273 | `fa6105e34a829de316e99b977509695e026c4bd0e8c7c5ab2bbeaea79b3560d0` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/id.lproj/SplitScreen.strings` | `OmniCarPrefs/Resources/id.lproj/SplitScreen.strings` | 3929 | `8bc4d97c2d405bd62cfdaabdffc41e2665d8a477535bf76f1c3eeefa1b864337` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/id.lproj/StartupScreen.strings` | `OmniCarPrefs/Resources/id.lproj/StartupScreen.strings` | 3885 | `5634449cb23ad3a476b4e9ac6d6b01dc203f0a19702ecc438de0313dc9bc0a84` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/id.lproj/WhatsNew.strings` | `OmniCarPrefs/Resources/id.lproj/WhatsNew.strings` | 846 | `bf976dc5521f6760752f680345a477c47d2de043ee7576a6b2131b606393dfd6` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/it.lproj/AppBridge.strings` | `OmniCarPrefs/Resources/it.lproj/AppBridge.strings` | 500 | `8bb54fe193c970d1fa77d5c8d426a6ef1dd95179267d8eddb89926e50e0b6409` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/it.lproj/Car.strings` | `OmniCarPrefs/Resources/it.lproj/Car.strings` | 5370 | `d2c6928f0038768e3b4c4fceba657627d7cf35e6a1b5d44bd904cefb05f37d1b` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/it.lproj/HomeScreen.strings` | `OmniCarPrefs/Resources/it.lproj/HomeScreen.strings` | 3588 | `db4531b794ca17eebf70d627671c361919f7ba9cec0ce3e08f8d8f457ace6a73` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/it.lproj/Localizable.strings` | `OmniCarPrefs/Resources/it.lproj/Localizable.strings` | 13854 | `045572ef73469b8b30f18a23dc61dd2bc3721294cc7bf9f1d783cee459eaaa41` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/it.lproj/Onboarding.strings` | `OmniCarPrefs/Resources/it.lproj/Onboarding.strings` | 2726 | `4a81affb80fabe6a13d5662cea03d2873fc9ab0f9b1ea01a34583ab6d9910785` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/it.lproj/Profiles.strings` | `OmniCarPrefs/Resources/it.lproj/Profiles.strings` | 881 | `6bb37712721d6acfbd243f356077bd1aadd921944e123b2ce60796121cf50e5d` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/it.lproj/SpeedBubble.strings` | `OmniCarPrefs/Resources/it.lproj/SpeedBubble.strings` | 4910 | `4de2471b9538ab1b56a31405f25e1ed0f92a915169666c21c673ec8b0ff05444` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/it.lproj/SplitScreen.strings` | `OmniCarPrefs/Resources/it.lproj/SplitScreen.strings` | 4115 | `52796f49d72a7c9171d4ab4529d263aea7500e490ad05ea9f73041550f236389` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/it.lproj/StartupScreen.strings` | `OmniCarPrefs/Resources/it.lproj/StartupScreen.strings` | 4206 | `2986f13641f5a19db5faac8f938f1a7013220f60a37c1c3b8df879b2948b570a` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/it.lproj/WhatsNew.strings` | `OmniCarPrefs/Resources/it.lproj/WhatsNew.strings` | 990 | `2a792f27f50fa9843f3deb5ba80d73f669057763375ca3a13f978939465ba0f4` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ja.lproj/AppBridge.strings` | `OmniCarPrefs/Resources/ja.lproj/AppBridge.strings` | 495 | `98e3dd2b53b319a9b2217bfe81ad0ad732fec7594df8bea7993254c8dd7136b2` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ja.lproj/Car.strings` | `OmniCarPrefs/Resources/ja.lproj/Car.strings` | 4431 | `9300848252e85bbd6dedd0312978c97fd02ce791537e3eef8343f917fa27d83a` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ja.lproj/HomeScreen.strings` | `OmniCarPrefs/Resources/ja.lproj/HomeScreen.strings` | 2662 | `c29f3471a33c2fb8a7fc4e840383b96b13e1184689a1a1b5145ceca4d04a8a08` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ja.lproj/Localizable.strings` | `OmniCarPrefs/Resources/ja.lproj/Localizable.strings` | 11304 | `0b04b48ff71890ce05cd6d1ce524087945f81927d340ca41ec396b8d245d0f41` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ja.lproj/Onboarding.strings` | `OmniCarPrefs/Resources/ja.lproj/Onboarding.strings` | 1712 | `dde0139df218bf7dbfd5cdef96aa870b4883bdf5eb77164e9e6b576ae561c3de` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ja.lproj/Profiles.strings` | `OmniCarPrefs/Resources/ja.lproj/Profiles.strings` | 569 | `e29e87436759dfa83bde364262f4c4b2fe5d62513c6da730e4d7f015c536f487` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ja.lproj/SpeedBubble.strings` | `OmniCarPrefs/Resources/ja.lproj/SpeedBubble.strings` | 3989 | `f8756c87c2ccb7b80c726b13ecc0cbca8721b0a59061342b716ed5a6f57e4a16` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ja.lproj/SplitScreen.strings` | `OmniCarPrefs/Resources/ja.lproj/SplitScreen.strings` | 3564 | `2818da9d20571eaba40faaf67fb27852715b66327635c5d60121751eb867b071` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ja.lproj/StartupScreen.strings` | `OmniCarPrefs/Resources/ja.lproj/StartupScreen.strings` | 3932 | `2da5dfb079a489e09305d09b278a212a251e9ac8eadd69150e399c3711162e36` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ja.lproj/WhatsNew.strings` | `OmniCarPrefs/Resources/ja.lproj/WhatsNew.strings` | 724 | `290f3cded8e18dc4cee35d9ec4bea5adf30b9fbd19b1bb706525fad38155cd48` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ko.lproj/AppBridge.strings` | `OmniCarPrefs/Resources/ko.lproj/AppBridge.strings` | 489 | `2dfdfa91c520b31e0e77e550a2fed41e133b02d5c8581bb383f49cba9a2e8b76` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ko.lproj/Car.strings` | `OmniCarPrefs/Resources/ko.lproj/Car.strings` | 4433 | `6028599aa58f1c511c577cd051cfd55deedd181dff39be37bf362a97edcb8c0f` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ko.lproj/HomeScreen.strings` | `OmniCarPrefs/Resources/ko.lproj/HomeScreen.strings` | 2697 | `f2e5349fc15a347ba4af43550e54d3a856a2d13c39b4748d7dfdc247cb429e31` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ko.lproj/Localizable.strings` | `OmniCarPrefs/Resources/ko.lproj/Localizable.strings` | 11245 | `6562ea038926c004a7b11e38ee7930d8a6fd7c9afce705309554a89e730fb555` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ko.lproj/Onboarding.strings` | `OmniCarPrefs/Resources/ko.lproj/Onboarding.strings` | 1818 | `9109dcc057292b6beb7ab37b194cbad8a4e74843bd11782b12d404f56a591895` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ko.lproj/Profiles.strings` | `OmniCarPrefs/Resources/ko.lproj/Profiles.strings` | 613 | `58735a80021841503938b429c9ac489d044038d76a401d62f0e6d8d62575e0e3` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ko.lproj/SpeedBubble.strings` | `OmniCarPrefs/Resources/ko.lproj/SpeedBubble.strings` | 4059 | `9f9f2a970a4ec80288493c1136998e35bc4afceaadb481b834274d001bab7d57` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ko.lproj/SplitScreen.strings` | `OmniCarPrefs/Resources/ko.lproj/SplitScreen.strings` | 3552 | `b1b5ec04213c88f924e4cc0827ef6da4f498b9f1d54b0cc662d50a19c8274aa4` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ko.lproj/StartupScreen.strings` | `OmniCarPrefs/Resources/ko.lproj/StartupScreen.strings` | 4048 | `9a674fdaaeb01855f197470cb7002c08fa815e271752c477296ebfd49e561f6f` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ko.lproj/WhatsNew.strings` | `OmniCarPrefs/Resources/ko.lproj/WhatsNew.strings` | 812 | `5d7373c07f86dca2cfe9fbd7ec4562f2abcce30e36b510c0be633e8f5855aec2` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/logo.png` | `OmniCarPrefs/Resources/logo.png` | 9406 | `7077849cb7ce87b43a56bf52cceacf6ebd28f79837d12c16beaae3838a92b27a` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/logo@2x.png` | `OmniCarPrefs/Resources/logo@2x.png` | 27891 | `9e234f6a399cd603e34050d5b623ae68c31e352b63dbaeb57aaa5a82ece1c232` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/logo@3x.png` | `OmniCarPrefs/Resources/logo@3x.png` | 48665 | `d6407325dca6ec9f864dfc7b0906930015a702318f851a9d7c30782fdfd4ba08` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/pt-BR.lproj/AppBridge.strings` | `OmniCarPrefs/Resources/pt-BR.lproj/AppBridge.strings` | 612 | `94cc9e39fe9665d8826a33a6a6d7e078c4c37345ade41a36e98215e68b6d31b0` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/pt-BR.lproj/Car.strings` | `OmniCarPrefs/Resources/pt-BR.lproj/Car.strings` | 5629 | `83479ec69145f64595a6ed70ca843e154d0fdb4a7536ea1a7f255c450cd909e6` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/pt-BR.lproj/HomeScreen.strings` | `OmniCarPrefs/Resources/pt-BR.lproj/HomeScreen.strings` | 3943 | `d32b4232ede988a3058b3f016c4cfddaba7321c7ed5e7fef570c52ece3aa2444` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/pt-BR.lproj/Localizable.strings` | `OmniCarPrefs/Resources/pt-BR.lproj/Localizable.strings` | 15011 | `2a07506a72b8d842be2e7736478809d4f68785c9952077ae9df68254192b9a17` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/pt-BR.lproj/Onboarding.strings` | `OmniCarPrefs/Resources/pt-BR.lproj/Onboarding.strings` | 2747 | `6cbd4f394d6052915b168a3d9ec6a988a4a2f08f713682150fbd53a88e72a7c2` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/pt-BR.lproj/Profiles.strings` | `OmniCarPrefs/Resources/pt-BR.lproj/Profiles.strings` | 925 | `d4defcf200894b651359f9415904c925a083d73634d3d54ebeec30363293cdce` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/pt-BR.lproj/SpeedBubble.strings` | `OmniCarPrefs/Resources/pt-BR.lproj/SpeedBubble.strings` | 4819 | `724e19328bf393389aaf30eb83322eb717081c70b700de864c04bb36867fc147` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/pt-BR.lproj/SplitScreen.strings` | `OmniCarPrefs/Resources/pt-BR.lproj/SplitScreen.strings` | 4323 | `c46e6006836968a1e667f542ad52177328ed9d1f2d51d4de00faacf5a0452ea0` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/pt-BR.lproj/StartupScreen.strings` | `OmniCarPrefs/Resources/pt-BR.lproj/StartupScreen.strings` | 5383 | `7b357d5a017311fc3417f65b0ba229922f7aa58a1e26778298bcc134dcee9608` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/pt-BR.lproj/WhatsNew.strings` | `OmniCarPrefs/Resources/pt-BR.lproj/WhatsNew.strings` | 1054 | `f0d2dc3f3fc49d8a269ae483840f42abccea004267781d5da79b42c47b9d6811` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ru.lproj/AppBridge.strings` | `OmniCarPrefs/Resources/ru.lproj/AppBridge.strings` | 715 | `5188257a24afe6d8c26c1fca280716fad8195915151382fa11e9ee2df7558602` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ru.lproj/Car.strings` | `OmniCarPrefs/Resources/ru.lproj/Car.strings` | 6315 | `1f24197c5695f14524f138060bc8c7535f96d4e26ae59352d9c79ecc70546f10` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ru.lproj/HomeScreen.strings` | `OmniCarPrefs/Resources/ru.lproj/HomeScreen.strings` | 4264 | `e90f0a5e698da145cf2dfa9fc933b46df2ae8415e8298fb113e0194701e4f7c2` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ru.lproj/Localizable.strings` | `OmniCarPrefs/Resources/ru.lproj/Localizable.strings` | 17450 | `cb6915a824562a4a7028a224339b96692e247a44f53714b5d08365f033157e8a` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ru.lproj/Onboarding.strings` | `OmniCarPrefs/Resources/ru.lproj/Onboarding.strings` | 3107 | `660f436235deb82b3c8dbff46a3e18ec0bee05fde743aaa8131dc6a80b1ffa14` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ru.lproj/Profiles.strings` | `OmniCarPrefs/Resources/ru.lproj/Profiles.strings` | 1093 | `4bb1e97ca1880f1f258310335b4b10871721b6559035afe8e095719f64e3dfb7` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ru.lproj/SpeedBubble.strings` | `OmniCarPrefs/Resources/ru.lproj/SpeedBubble.strings` | 5960 | `2fd29db769fa496cdf7335b966b5c66bab982b16d89354fec48c76f284ad8ac1` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ru.lproj/SplitScreen.strings` | `OmniCarPrefs/Resources/ru.lproj/SplitScreen.strings` | 5157 | `b40a7b357df7ae64d6f637d0418250803ea9d5599f400d3f7f4a787741367b04` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ru.lproj/StartupScreen.strings` | `OmniCarPrefs/Resources/ru.lproj/StartupScreen.strings` | 5617 | `49f8d3f132ef8c620c54072510736091ec13b2baccc7b1f254697a3210b17169` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/ru.lproj/WhatsNew.strings` | `OmniCarPrefs/Resources/ru.lproj/WhatsNew.strings` | 1338 | `5389679d6c71a4b467d678ac0b82595db2decda59286b2cfe26265fe1196e4ac` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/th.lproj/AppBridge.strings` | `OmniCarPrefs/Resources/th.lproj/AppBridge.strings` | 577 | `48f10d3f7f10c9ad363e398de8caa05c9c2b73cc6efa8e6cc46a0cf83595c186` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/th.lproj/Car.strings` | `OmniCarPrefs/Resources/th.lproj/Car.strings` | 5477 | `9f9814681f2471cf4653cbc21f1b2c43cb127fc6f87beb6dd5c4569fdeffc566` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/th.lproj/HomeScreen.strings` | `OmniCarPrefs/Resources/th.lproj/HomeScreen.strings` | 3475 | `176c36c34341751f794b7ab413432d224b8f8e2dc84b2a79b339d0276e0e8be9` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/th.lproj/Localizable.strings` | `OmniCarPrefs/Resources/th.lproj/Localizable.strings` | 14455 | `661f7db0b7cad9d5d7e153202689f968ed1269776cdf956915af478647d8517c` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/th.lproj/Onboarding.strings` | `OmniCarPrefs/Resources/th.lproj/Onboarding.strings` | 2375 | `41d392644fc1838b461881332f0b6c67d336370db63e82b4355e167d19dce14e` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/th.lproj/Profiles.strings` | `OmniCarPrefs/Resources/th.lproj/Profiles.strings` | 849 | `084ebc341c1e57608fa592dfcabe394e0a9f04ac34bf3eea03c85f83bcfcb923` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/th.lproj/SpeedBubble.strings` | `OmniCarPrefs/Resources/th.lproj/SpeedBubble.strings` | 5179 | `0717604c99a423035a8cea74f1584374445ec7810fb40286c729db7658687774` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/th.lproj/SplitScreen.strings` | `OmniCarPrefs/Resources/th.lproj/SplitScreen.strings` | 4283 | `2f0541901b3b472e388ac19941e93117f4c4e56628e6f75317ef8729f6834e93` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/th.lproj/StartupScreen.strings` | `OmniCarPrefs/Resources/th.lproj/StartupScreen.strings` | 5029 | `ab43c82328b1073d6bf909dc349e1fbe00d5ed1cdaced2dd619f4686b1c116d7` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/th.lproj/WhatsNew.strings` | `OmniCarPrefs/Resources/th.lproj/WhatsNew.strings` | 1102 | `880c0f2d1f6bea0c2ada5ccdd46a93c18eb50a266ccea884641a93030ae6a2e5` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/vi.lproj/AppBridge.strings` | `OmniCarPrefs/Resources/vi.lproj/AppBridge.strings` | 572 | `73cd243b98aa14d3c8248e616e5aa33ba9360ef9eb40b07ed78a9ab0ef976d23` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/vi.lproj/HomeScreen.strings` | `OmniCarPrefs/Resources/vi.lproj/HomeScreen.strings` | 3588 | `32f4da7542f158fd0b5680df7154ef1c3428d407d7aed5a1bf74bd4e447fb223` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/vi.lproj/Localizable.strings` | `OmniCarPrefs/Resources/vi.lproj/Localizable.strings` | 14526 | `0ac8f2c805ec20c88caf7cdf90989206f5b5ea7738c8aa519b12d727921d2814` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/vi.lproj/Onboarding.strings` | `OmniCarPrefs/Resources/vi.lproj/Onboarding.strings` | 2479 | `fef6a75b605ac251162f25c7bc27cf3d1612bc739c3e555c0a1e0b8be2036e81` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/vi.lproj/Profiles.strings` | `OmniCarPrefs/Resources/vi.lproj/Profiles.strings` | 853 | `e2459569d52d3bfaf52397714622761d0de0dfeff57b806e524fb733227178d7` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/vi.lproj/SpeedBubble.strings` | `OmniCarPrefs/Resources/vi.lproj/SpeedBubble.strings` | 5233 | `455b1f62e4bc0fa5d38a4829d822dcac17beebf4c81a0362f9d287383a8798fb` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/vi.lproj/SplitScreen.strings` | `OmniCarPrefs/Resources/vi.lproj/SplitScreen.strings` | 4302 | `9baa87703adb19354f5fe7b5f41f6cc56e8869e500c7f8e6174a208b343b1767` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/vi.lproj/StartupScreen.strings` | `OmniCarPrefs/Resources/vi.lproj/StartupScreen.strings` | 7408 | `9cd4f4164859244008a6c5d37f74339a8095b00576bbd7b8ef3cc84de1f3d50e` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/vi.lproj/WhatsNew.strings` | `OmniCarPrefs/Resources/vi.lproj/WhatsNew.strings` | 1212 | `c563e97234502d0d3c49840f331f374b12fcf4ca26e503d761ed3b561ebe9c46` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/zh-Hans.lproj/AppBridge.strings` | `OmniCarPrefs/Resources/zh-Hans.lproj/AppBridge.strings` | 469 | `e20270fe2c5780c8ec6c7d3a19f08f1e0daf4cb263488f35e1be91866e161474` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/zh-Hans.lproj/Car.strings` | `OmniCarPrefs/Resources/zh-Hans.lproj/Car.strings` | 3778 | `548bdc77c20192586a89a9a809aa4f4ecffdbd684963f26f3da0d71c2c15f806` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/zh-Hans.lproj/HomeScreen.strings` | `OmniCarPrefs/Resources/zh-Hans.lproj/HomeScreen.strings` | 2398 | `965b64d7e0be54583cf69a0393eee2b215029bd9fed09fbc6aa62273e112697c` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/zh-Hans.lproj/Localizable.strings` | `OmniCarPrefs/Resources/zh-Hans.lproj/Localizable.strings` | 9498 | `6fdce63afbdb981a39b7b565f8e5d2de5ebb70c673e65ba3774fed6824fcfa7c` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/zh-Hans.lproj/Onboarding.strings` | `OmniCarPrefs/Resources/zh-Hans.lproj/Onboarding.strings` | 1410 | `92a2e5421cdf9508986f9d697d4cb759c1405390eb87e48311e523f9ae9695cb` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/zh-Hans.lproj/Profiles.strings` | `OmniCarPrefs/Resources/zh-Hans.lproj/Profiles.strings` | 477 | `1cf22acb55ef08600be61e59c2398b95e525d5cd407c127783bb7b3c24d63f6f` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/zh-Hans.lproj/SpeedBubble.strings` | `OmniCarPrefs/Resources/zh-Hans.lproj/SpeedBubble.strings` | 3634 | `cd2686ce09ba95bd4f53e442d06d86a4e0d69a9e4318064bcb2cbf2e50be10fa` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/zh-Hans.lproj/SplitScreen.strings` | `OmniCarPrefs/Resources/zh-Hans.lproj/SplitScreen.strings` | 3243 | `ee43d699f9bca7aad40cfd8efc24777602a9e3831d0b1986ddc186e55d328800` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/zh-Hans.lproj/StartupScreen.strings` | `OmniCarPrefs/Resources/zh-Hans.lproj/StartupScreen.strings` | 3354 | `ff81e90c0086ffe4073f88b47f8b07b435198369b8ac12e946d412e5e391aabe` |
| `var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/zh-Hans.lproj/WhatsNew.strings` | `OmniCarPrefs/Resources/zh-Hans.lproj/WhatsNew.strings` | 620 | `b432a03f4ec2985ce1babc5685e47a4a9efb0cef5e23eabbd9d13b6cbc7a6d99` |
| `var/jb/Library/PreferenceLoader/Preferences/OmniCarPrefs.plist` | `layout/Library/PreferenceLoader/Preferences/OmniCarPrefs.plist` | 186 | `577dc46878a58aa6cd1f068f84a73f86e31dcd6313ec4eaf0b5960b25ea91f8e` |

Total copied resources: 168 files.
