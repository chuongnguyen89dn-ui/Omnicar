# HL52 — Lề nguyên bản trong DuoCar; Dock pin/nhiệt trong suốt, không che giờ
Ngày: 2026-11-13 (Asia/Ho_Chi_Minh). SOURCE CHANGED, **CHƯA BUILD, CHƯA DEVICE PASS**.

## Phạm vi sau test DuoCar51
Nguyen cung cấp ảnh CarPlay với DuoCar51, xác nhận:
- Menu chọn app đã giữ được nội dung bên dưới (DEVICE PASS cho hiện tượng không đen theo người dùng; không suy rộng sang native hay toàn vòng đời).
- Pin và nhiệt đã hiển thị nhưng che giờ Dock. Cần đặt thấp hơn, ở khoảng trống **sau cụm 3 icon ứng dụng** và trước Home; **hiển thị chữ/icon hoàn toàn trong suốt, không nền mờ, không khung**.
- Bong bóng Lề 0.2.4 vẫn bám lề, chưa kéo/thả tùy ý. Mã HL51 đã có hook sau original -panned nhưng **device fail**, không coi mã hiện hành đã giải quyết.
- "Cài đặt của Lề vẫn chưa sửa lại nguyên bản": bắt buộc dùng đúng giao diện LePrefs.bundle có bản xem trước, nguồn và Maps, không mô phỏng lại bằng bảng DCLLeConfigPage. Kết quả sau build cần kiểm cả việc lưu thật.

Bản đang được Nguyen thử: DuoCar51 v1.0.3-le0244, CI 43408145791, artifact 14027424331, SHA256 `5698fd781567af4fbfe1f8d7bddff0145137629a1408308951539b06dcaf76f3`. `logs/DuoCar.log` trên main SHA `345c6b84311ae8acff184bda0b9570aa21387b9b` chỉ tới 16:26:19 phiên **DuoCar50**, không có marker `[hl51-dock]` hoặc `[le024-ext]` thuộc bản 51. Đừng trộn PID hoặc coi không có log là không chạy.

Repository `chuongnguyen89dn-ui/Omnicar`; cây thi công `recovered-source/`; nhánh độc lập `feature/duocar-hl52-leoriginal-dock-freepos-20261113` từ HL51 HEAD `35447e78fb1f4364020c924d521083d8b8422954`. Không merge main, không dispatch CI, không publish Sileo, không sửa zoom (để đợt sau).

## Kết quả sửa SOURCE đã ghi lên GitHub / xác nhận read-back
1. `c736d56067a054d794730d412ad550de1a5e8a4e`:
   - `project/OmniCarApp/OMCLePrefsHost.m`, `src/App/OMCLePrefsHost.m`: `OMCLeOriginalPreferencesController` thử nạp runtime bundle thật `/var/jb/Library/PreferenceBundles/LePrefs.bundle` (fallback `/Library/...`) bằng `NSBundle loadAndReturnError:`, `bundle.principalClass` và `[[cls alloc]init]`, chỉ nếu là UIViewController. Marker `[hl52-le-original] ORIGINAL LOADED` / LOAD FAILED / BAD PRINCIPAL / EXCEPTION. Không copy binary gốc vào app, giữ vendor LePrefs nguyên gói.
   - `project/OmniCarApp/OMCLePrefsHost.h` + mirror, `OMCNativeSettings.m` + mirror: tách `OMCLeCompatiblePreferencesController` cho tùy chỉnh riêng.
   - **Bằng chứng binary trực tiếp** từ final DuoCar51 DEB tại `/mnt/data/duocar51_readonly/var/jb/Library/PreferenceBundles/LePrefs.bundle/LePrefs`: FAT arm64+arm64e, Info.plist có `CFBundleIdentifier=dev.bechou.le.bubble.preferences`, `NSPrincipalClass=CWTrafficBubblePrefsController`, bundle là Mach-O dylib phụ thuộc `Preferences.framework`; không phải nguồn giả.
2. `ddb84d17ead2164d544e44ce3529c4fff030d6e4`: `OMCNativeSettings.m` + mirror: chạm **SPEEDBUBBLE** trong DuoCar mở trực tiếp controller gốc ngay lần chạm đầu; thêm riêng mục `Tuỳ chỉnh riêng DuoCar cho Lề` vào Features để truy cập GPS ±5 và kéo X/Y. Không bắt người dùng qua mock page.
3. `94356fe164e7a3b6e62ef525b915425621a8c908`: `project/OmniCarSplitScreen/SCPDeviceVitalsHUD.m` + `src/SplitScreenA/SCPDeviceVitalsHUD.m`: HUD thật trên native Dock, bố trí side rail chỉ quét dưới `CGRectGetMaxY(cluster)+7pt`, không bắt đầu ở đầu thanh (nơi có giờ). Cao panel 2 dòng giảm 43→29pt, compact 21pt để vào khoảng trống, ưu tiên 2 dòng pin/nhiệt. Gỡ `colorWithWhite:0 alpha:0.28`, corner 6, clipping; nền panel/label đều clear, chỉ shadow chữ nhẹ để đọc. Giữ `userInteractionEnabled=NO`, tránh 3 icon, Home/launcher và status; không tạo UIWindow, không động menu/zoom/bong bóng fullscreen.
4. `293a0c4227c034241591d2203926c4b4da87b854`: giới hạn trang `DCLLeConfigPage` **chỉ 2 tùy chỉnh riêng** (GPS offset 27 / free drag 28) khi `extrasOnly=YES` và chỉ đọc 2 key bridge. Nếu bản gốc không tải được, hiện thông báo `Chưa mở được Lề gốc` thay vì gắn nhãn sai cho 29 hàng tự viết. Ghi log lỗi để khoanh vùng, không tự nhận nguyên bản.

## Rủi ro, sự thật nghiệm thu
- **Native LePrefs chưa được load/test trong tiến trình DuoCar trên iPhone**; việc `NSBundle` có mở được private Preferences.framework, và vendor UI có ghi vào global `/var/mobile/Library/Preferences` khi chạy trong app sandbox, **CHƯA PROVEN**. Hiển thị UI nguyên bản không tương đương ghi cấu hình nguyên bản. Cần log marker + sửa một mục, đọc lại sau đóng/mở để chứng minh; nếu lỗi ghi phải làm bridge chứ không viết giả thành công.
- **HUD dưới icon chưa đo lại chính xác Home/status trên xe**, nên nếu thiếu 29pt phải fallback chỉ pin hoặc log NO SAFE RAIL; ưu tiên tuyệt đối không che giờ hoặc 3 icon hơn là xuất widget sai.
- **Bong bóng Lề kéo tự do CHƯA SỬA** trong HL52 hiện tại: `DCLLeExtension.m` còn hook gốc panned/place, người dùng xác nhận snap. Chưa có log mới để biết target là CWTrafficWindow hay bubble subview và khả năng `geometry` trả NO; không tự sửa window level/recognizer bằng suy đoán. Thu log mới cho PID và các marker `[le024-ext] vendor pan began`, `[le024-ext] free XY BLIND`, `[le024-ext] free XY complete`, `saveXY`, `place` trước khi thiết kế đổi chính xác native owner.
- Chưa build CI, ký DEB hoặc test trong CarPlay. Cần cổng HL52 riêng bảo vệ file nguồn menu, zoom, fullscreen bubble, bridge Lề; kiểm mirror project/src; sau đó CI FAT một lần khi được yêu cầu và Nguyen test.

## Hướng hoàn nguyên
Quay lại branch/commit HL51 `35447e78fb1f4364020c924d521083d8b8422954` hoặc revert từng commit HL52 nêu ở trên, không copy đè file song song; HEAD riêng được kiểm trước mỗi ghi. Dùng GitHub connector để lưu (không bịa shell/VM), snapshot local chỉ tham khảo.
