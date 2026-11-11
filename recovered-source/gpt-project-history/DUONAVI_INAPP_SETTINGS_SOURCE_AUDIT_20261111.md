# DuoNavi -> DuoCar: cài đặt nằm trong ứng dụng iPhone (đối chiếu 2026-11-11)

## Yêu cầu và phạm vi
Nguyen tạm ngừng test bàn phím HL25. Nhiệm vụ lượt này: tìm thật kỹ cơ chế cài đặt bên trong ứng dụng DuoNavi, đối chiếu DEB DuoCar mới nhất và hai lần thất bại HL19/HL20, đưa ra thiết kế chuyển đúng. CHỈ NGHIÊN CỨU, không đổi source, không tạo nhánh, không build, không Sileo, không động vào YTZ5/keyboard/picker/Home/Dock/pinch/Muse.

Repo chính chuongnguyen89dn-ui/Omnicar, cây recovered-source/. HEAD main được kiểm: 5816513cdf7f9d1c3845916fec526aa9159041ef; nhánh HL25 hiện bfc619254f2a3109a2b3e592e3a0bbd9ade38e49; HL25 package 1.0.3-hl25duocar, SHA256 b51958e36ef1cff4e0d43efe3d571f1c482ebd749f6b4f6bcb4adb48a0259880. Chưa test HL25 trên xe.

## 1. DuoNavi gốc: bằng chứng đã có từ chính binary

Đã đọc trực tiếp báo cáo giải mã byte-pinned (báo cáo Muse, KHÔNG tự dịch ngược byte DuoNavi ở lượt này):
- Duoface/spec-main/sideplay/deb-duonavi-1.0.3-12/HO_SO.md, Git blob e7af015ab6774364adb2ff29248d19ef28e18c26, đặc biệt mục 3.1, 4.1 và hậu cài.
- Duoface/spec-main/sideplay/deb-duonavi-1.0.3-12/HO_SO_02.md blob 1aad388091e7c216ec7ef7901ded5f747b84cf91, mục 8.1–8.2.
- Duoface/spec-main/sideplay/spec-knowledge/BAO_CAO_QUET_AZ_PHU_LUC.md blob 6eeb6f8268180468426899ffc28035b9a240bd5a, các lớp 27 class trong DuoFaceUI.
- Duoface/spec-main/sideplay/spec-knowledge/BAO_CAO_QUET_AZ_DUONAVI_VS_QA185.md blob a90b52ec0c518f7004b11daf1c2c31cd9738e593, so sánh app/engine.
- Duoface/main/docs/duoface-settings-pro-hop-nhat-duodash-20261016.md blob 011f5aef830594ac9c3b0e373e5d47c9ea77ad24 và docs/duoface-native17-restore-native12-license-ui-20261016.md blob 03ce2a78e3edf77625b9e12d27e66877d0d82178: nguồn bổ sung, không phải chương trình gốc.

ĐỐI TƯỢNG CHÍNH XÁC: gói khảo sát sâu là com.duonavi.app 1.0.3-12+border-focus-red3 (bản thử dòng DuoNavi); KHÔNG gán các class offset này cho binary 1.0.4 genuine. DuoNavi 1.0.4 đã audit riêng, nhưng chưa có ở đây body viewDidLoad của ứng dụng 1.0.4.

- /var/jb/Applications/DuoFaceUI.app/DuoFaceUI, CFBundleIdentifier = com.duoface.duofaceui, LC_MAIN, app UIKit thông thường, 27 lớp/522 method trên mỗi slice. Không có CFBundleURLTypes trong Info.plist. Không phải PreferenceBundle mở qua Settings.app.
- XXAppDelegate : UIResponder; application:didFinishLaunchingWithOptions:; có window và rootViewController.
- XXRootViewController : UITabBarController; có ba property/ivar appsNav, splitNav, settingsNav thuộc UINavigationController. Kết cấu tab Ứng dụng / Chia màn / Cài đặt được suy ra từ vai trò property và các controller đi kèm; cần giải body viewDidLoad để chốt thứ tự và cụ thể nhãn/icon.
- CBAppsManagerViewController : UIViewController (danh sách app, bộ lọc/search, bật/tắt, update); CBAppManager : NSObject có loadInstalledAppsWithCompletion:, setApp:enabled:, reloadPreferences, savePreferences.
- CBSplitViewController : UITableViewController (chia màn, preset, vị trí/slot 1–4; loadSettings, saveSettings).
- CBGeneralSettingsViewController : UITableViewController (30 method): viewDidLoad / viewWillAppear / loadPreferences / savePreferences; autoLaunchToggleChanged:, screenBlankToggleChanged:, dockMonitorToggleChanged:, hideLabelsToggleChanged:, showLanguageSelectionSheet, performResetDefaults, performRespring, openSubscriptionScreen.
- CBAssistantAboutViewController : UITableViewController cho tính năng trợ lý/giới thiệu; CBLocalization quản lý ngôn ngữ. Các lớp subscription/license/optimizer của gốc KHÔNG thuộc phạm vi học theo.
- Shared settings: dashboard có CBDashboardSettings : NSObject 56 instance+5 class methods với bridgedApps/split*/autoLaunch*/hideIconLabels..., reload; app có CBAppManager và các controller load/save. Hậu cài tạo /var/mobile/Library/Preferences/com.duoface.plist lần đầu, migrate com.tiz.carbridge.plist nếu có; class app và Dashboard dùng chung domain com.duoface. Báo cáo ghi app và dashboard có Darwin/CFNotificationCenter API, nhưng KHÔNG đủ bằng chứng method-local để khẳng định notify cụ thể cho mọi setter. KHÔNG sao chép scripts sudoers, setuid helper, license, TCC hoặc system optimizer của bản thương mại.

KẾT LUẬN KIẾN TRÚC: app tự sở hữu UIKit navigation + UIKit table pages + data store dùng chung; không lồng PSRootController/PSListController làm cốt lõi.

## 2. DuoCar HL25 — trực tiếp kiểm trên đúng DEB đã phát hành trong cuộc trò chuyện
Đầu vào nguyên byte /mnt/data/DuoCar_HL25.deb (chỉ runtime của lượt hiện tại), đã được hash và package metadata đối chiếu ở checkpoint HL25. Lệnh chạy trực tiếp bằng container, cwd /:
  dpkg-deb -x /mnt/data/DuoCar_HL25.deb /mnt/data/hl25_settings_inspect
  dpkg-deb -f /mnt/data/DuoCar_HL25.deb Package Version Architecture
  python3 - <<'PY' ... plistlib.load(s) ...
  strings /mnt/data/hl25_settings_inspect/var/jb/Applications/DuoCar.app/DuoCar
  strings /mnt/data/hl25_settings_inspect/var/jb/Library/PreferenceBundles/DuoCarPrefs.bundle/DuoCarPrefs

Kết quả trực tiếp:
- Package com.chuong.duocar, Version 1.0.3-hl25duocar, Architecture iphoneos-arm64.
- App /var/jb/Applications/DuoCar.app/DuoCar, CFBundleIdentifier com.chuong.duocar.app, CFBundlePackageType APPL; có URL scheme duocar; app binary chứa "Open DuoCar Settings" và "prefs:root=DuoCar" hai bản (cả hai FAT slices) => BẤM vẫn chuyển sang Settings.app, không có màn settings UIKit độc lập.
- /var/jb/Library/PreferenceBundles/DuoCarPrefs.bundle, Info.plist: CFBundlePackageType BNDL, NSPrincipalClass DCRRootListController; Root.plist có 15 items.
- /var/jb/Library/PreferenceLoader/Preferences/DuoCarPrefs.plist vẫn còn, entry PSLinkCell, bundle DuoCarPrefs, detail DCRRootListController. Khả năng đăng ký trong Settings vẫn còn độc lập với app.
- DuoCarPrefs Mach-O có "com.chuong.duocar" và "com.chuong.duocar/prefschanged"; domain đã rebrand. Không ghi domain thứ hai khi port.
- Các page resources có thật: Root.plist, FeatureSplitScreen.plist, FeatureSpeedBubble.plist, FeatureStartupScreen.plist, WhatsNew.plist. Trong Root items: APPS -> DCRAppBridgeAppsController, HOME_SCREEN -> DCRHomeScreenController, PROFILES -> DCRCarProfilesController, buttons rescueRestore/showGuide/showWhatsNew/sendLog. Root master enabled, menu language, respring và các feature-order link được tạo bằng code, không thể suy chỉ từ Root.plist.

Source pin:
- recovered-source/project/OmniCarApp/OMCAppDelegate.m (blob 9f7db2c4fd0d9f2994e22aa28a9e5cc575d01459) có root UILabel + nút openSettings dùng prefs:root=OmniCar, được rebrand trước compile thành DuoCar; Shortcuts handler openURL là chức năng khác, phải giữ.
- recovered-source/project/OmniCarPrefs/OMCRootListController.h blob e4dd810d24626d58db9d0d188beb6e7236027a88 cho biết PSListController.
- OMCCardPage.h blob 9e09142b227a3cc2daaeffcbf459bbdfad62ed06: PSViewController, nhưng tự quản lý UITableView, switch/segment/slider.
- OMCCardPage.m blob 0bab8b4fa0685ff89f15f1468d5916d23f8c7b5e: CFPreferencesCopyAppValue -> SetAppValue -> AppSynchronize -> notify_post(OMC_PREFS_CHANGED_NOTIFICATION). Source macro OMCCommon.h 2fd1edb3dd757bb2d581427640c35cdb09b57094; được rebrand thành com.chuong.duocar/prefschanged.
- OMCAppBridgeAppsController / OMCHomeScreenController, OMCCarProfilesController kế thừa PSViewController nhưng tự dựng UITableView; hợp lý tách model + UI UIKit. OMCSplitScreenController và OMCSpeedBubbleController kế thừa OMCCardPage, 7 và 6 section code-built; plist chỉ 2 items mỗi trang, không mô tả toàn bộ UI. OMCStartupScreenController kế thừa OMCFeatureListController : PSListController và có 44 specifiers cùng gallery, media picker/import/delete/preview, birthday UI; không thể chuyển bằng cách dựng switch tĩnh.

## 3. Vì sao các bản trước thất bại, KHÔNG lặp lại
- HL15 checkpoint recovered-source/gpt-project-history/HL15_UNIFIED_DEB_KB_PICKER_INAPP_SETTINGS_20261110.md: nhúng OMCRootListController : PSListController vào PSRootController, load Prefs bundle, gỡ PreferenceLoader thử nghiệm; CI PACKAGE PASS, chưa phải thiết bị.
- HL19 checkpoint HL19_PICKER_NATIVE_KB_INAPP_PREFS_CHECKPOINT_20261111.md: lại wire PSRootController + PSListController, init/push, fallback. iPhone báo "Không tải được cài đặt OmniCar" / "Thử lại" ở ảnh trước đây.
- HL20 checkpoint HL20_SETTINGS_DUOFACE_KEYBOARD_RESTORE_20261111.md: dùng OMCInAppSettingsNavigationController kế thừa UINavigationController nhưng root vẫn OMCRootListController : PSListController. Đã build FAT (run 42953228288, artifact 13825482988, SHA DEB 3ebdb301...) và HL20 DEVICE FAIL ở cài đặt/keyboard. Không có log chi tiết để kết án một exception runtime cụ thể; nhưng đã chắc kiểu adapter PS không đáp ứng đích.
- HL25 kế thừa lại đường AppDelegate kiểu original/single UILabel + prefs:root, nên tính năng cài đặt trong app hiện CHƯA CÓ; không thể lấy PACKAGE PASS làm kết quả cài đặt.

## 4. Hướng triển khai theo DuoNavi — CHƯA SỬA
1. Trong OmniCarApp tạo root UIKit độc lập do app sở hữu: UITabBarController với ba UINavigationController (Ứng dụng, Chia màn, Cài đặt) hoặc tương đương UI app-native mà Nguyen duyệt. Không gọi prefs:root trong hành vi cài đặt. Giữ route Shortcuts "duocar://" và cơ chế ứng dụng launch hiện đã ổn; không đụng CarPlay Home launcher.
2. Page model: chiếu đủ 15 Root items + ba feature-order links động; các action header/guide/whatsNew/diagnostics/language/respring và condition groups phải có callback thật. UIKit UITableView/UIViewController thực; KHÔNG lồng PSListController/PSRootController. Các feature app bridge/home/profiles/split/bubble nên tái sử dụng logic models/data/cell code sau khi tách phụ thuộc PSViewController; không copy nguyên compiled commercial class.
3. StartupScreen là khối port phức tạp riêng: 44 specifiers + gallery + 11 styles/video/logo/sound imports + preview/delete + birthday accessory. Cần chuyển sang UIViewController/table datasource thật, giữ exact key/action semantics; không biến thành hàng hiển thị giả. Không làm một tab giả với vài toggle rồi gọi đã xong.
4. Tầng lưu dùng duy nhất CFPreferences domain com.chuong.duocar (được rebrand từ source macro com.anlai.omnicar), hiện notify com.chuong.duocar/prefschanged. Tạo provider chung đọc / validate typed values, ghi -> sync -> post notify; backend đọc lại. Không tạo state song song/migration tự ý, không reset dữ liệu user.
5. Packaging: app APPL + URL scheme duocar, UIKit source module mới, bundle resource đúng chỗ; giữ Prefs.bundle cũ trong quá trình chuyển đổi nếu cần rollback/trao đổi code, nhưng chỉ bỏ entry PreferenceLoader ở bản app-native đã được QA và có rollback, tránh xóa sớm gây mất UI cài đặt trên thiết bị.
6. Cổng độc lập: compile iOS 16 FAT; app binary có root UIViewController/UITabBarController và controller mới, không có prefs:root; Root+Feature schema/action map; thử lần đầu và mở lại app, mọi trang đều có điều hướng thật, key value tồn tại qua restart, backend phản hồi đúng notify; kiểm không mở Settings.app, không fallback, không crash khi vào Startup/media. Bất biến: Shortcuts URL duocar, pinch/Home/Dock/menu, YTZ/keyboard không thay. Sau build/đóng DEB mới chờ Nguyen DEVICE TEST; không Sileo.

## Trạng thái và bước tiếp nối
RESEARCH/DEB INSPECTION PASSED. Không code edits, không branch mới, không local source checkout/dirty state; chỉ trích xuất byte DEB HL25 vào /mnt/data/hl25_settings_inspect để đọc; địa chỉ này tạm thời không là lưu bền. Chưa chạy compiler, CI hoặc thao tác triển khai. Bước tiếp: thiết kế source-owned native UIKit app trên nhánh riêng từ nền được quyết định, đối chiếu ba model dữ liệu + Startup actions trước khi chỉnh; src/App và project/OmniCarApp phải đồng bộ, đồng thời bảo toàn app identity từ rebrand pipeline. Các phần Muse không tự sửa.
