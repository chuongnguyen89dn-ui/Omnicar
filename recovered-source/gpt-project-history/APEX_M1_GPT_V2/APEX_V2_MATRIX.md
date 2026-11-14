# M1 GPT V2 — MA TRẬN PHỦ DUOCAR APEX

Nguồn: Muse [M0 matrix](../APEX_M0_MA_TRAN_20261114.md), [audit DC58](../DUOCAR_UI_AUDIT_GPT_REVIEW_20261114.txt) và Issue #1. Dựng từ bản HL61 baseline `298b7b4a...`, chưa chạy trên xe.

| ID | Bề mặt | Visual mới (trong `visual/`) | File chủ sở hữu nguồn build (tiền tố `project/`) | Hợp đồng | Gate |
|---|---|---|---|---|---|
| D1 | Thanh lệnh split/hosted | carplay-01-split.svg | SCPCarSplit+Chrome.m; ABHostBMethods.m | C2/F2 | CHỜ NGUYEN DUYỆT |
| D2 | Handle 3 chấm | carplay-01-split.svg | SCPCarSplit+Chrome.m; ABHostBMethods.m | C1/F2 | CHỜ NGUYEN DUYỆT |
| D3 | Picker native/hosted | carplay-03-picker-native.svg + carplay-04-picker-hosted.svg | SCPCarSplit+Picker.m | C3/F2/F3; U11 | CHỜ NGUYEN DUYỆT |
| D4 | Divider/knob/tỷ lệ | carplay-01-split.svg; iphone-02-layout.svg | SCPCarDividerView.m; SCPCarSplit+Divider.m; +RatioMenu.m; +Layout.m | C4/F10 | CHỜ NGUYEN DUYỆT |
| D5 | App iPhone 5 mục | iphone-01-dashboard.svg đến iphone-05-customize.svg | OmniCarApp/OMCNativeSettings.m | C5/F10/F11; U8 | CHỜ NGUYEN DUYỆT |
| D6 | Trang chọn startup iPhone | iphone-06-startup.svg | OmniCarApp/OMCNativeStartup.m | C5/F12 | CHỜ NGUYEN DUYỆT |
| D7 | Lề GPS ±10 + công tắc | iphone-04-device.svg | OmniCarApp/OMCLePrefsHost.m | F9; U2/U7 | CHỜ NGUYEN DUYỆT |
| D8 | Vitals app iPhone | iphone-04-device.svg | OmniCarApp/OMCDeviceVitalsController.m | F10; U10 | CHỜ NGUYEN DUYỆT |
| D9 | Startup CarPlay | carplay-08-startup.svg | OmniCarStartupScreen/SSStartupView*.m; SSSplash.m | C8/F12 | CHỜ NGUYEN DUYỆT |
| D10 | HUD + fullscreen giờ–pin–nhiệt | carplay-05-fullscreen.svg | OmniCarSplitScreen/SCPDeviceVitalsHUD.m; SCPFullscreenVitalsBubble.m | C9/F14; U8/U10 | CHỜ NGUYEN DUYỆT |
| D11 | Icon Home DuoCar | carplay-07-home.svg | OmniCarSplitScreen/SCPHomeLauncher.m; SCPAppIcons.m | C10/F4 | CHỜ NGUYEN DUYỆT |
| D12 | Assets/brand/icon | 00-brand-system.svg; assets/* | OmniCarApp/Resources; OmniCarPrefs/Resources | F12/C7 | CHỜ NGUYEN DUYỆT |
| D13 | Keyboard hosted tự vẽ | carplay-06-keyboard.svg | OmniCarAppBridge/ABKeyboard.m | C11/F8; U3 | CHỜ NGUYEN DUYỆT |
| D14 | Prefs bundle | iphone-05-customize.svg | OmniCarPrefs/OMCCommon.m; OMCHeaderCard.m | C7/F12 | CHỜ NGUYEN DUYỆT |
| A1 | Cảnh báo viền đỏ HL61 | carplay-09-thermal.svg | OmniCarSplitScreen/SCPThermalEdgeWarning.h | F14/HL61 | CHỜ NGUYEN DUYỆT |

**A2 khóa cứng:** `SCPThermalAlarm.h` ngưỡng >=37°C, xử lý liên tục; `duocarThermalTest37Enabled` + Darwin notify từ `OMCNativeSetPref`; chỉ trình bày hàng UI ở D5. **A3 khóa cứng:** `OmniCarLeExtension/DCLLeExtension.m` nâng windowLevel vendor theo HL59, tuyệt đối không redesign hoặc đụng code. Lề riêng của hãng là ngoài phạm vi thiết kế.

**U3 / U8 / U10 / U11 = DEVICE PENDING** theo M0; không được tự ghi PASS bằng ảnh. D9 splash và D11 Home giữ nguyên vòng đời, registration và dock; hình minh họa Home chỉ đổi ô DuoCar.

**Nguồn build thật:** `recovered-source/project/`. `src/` là gương; tại HL61 có 7 file khác giữa hai cây, xử lý từng method/hunk, không copy đè toàn file. F1–F14 / C1–C12 ở Issue #1 vẫn áp dụng, hunk F/C phải nêu trước và chờ duyệt. Ký hiệu ảnh 390×844 / 1280×720 KHÔNG là lệnh đổi geometry runtime.
