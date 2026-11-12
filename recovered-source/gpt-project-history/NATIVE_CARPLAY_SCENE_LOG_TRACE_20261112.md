# 12/11/2026 — Đối chiếu log scene native CarPlay và bàn phím hosted HL36

## Ghi nhận nghiệm thu xe từ Nguyen (12/11/2026, ~16:38–16:45 GMT+7)

**Nguyen xác nhận trực tiếp:** “Tất cả các bàn phím của app hệ thống đều hiển thị đúng và resize đúng.”

Nhãn bằng chứng: **USER DEVICE OBSERVATION**, chưa phải kết quả do GPT tự tái hiện hoặc đo trên xe. Điều này thay đổi ưu tiên điều tra: bàn phím của app hệ thống đang hoạt động đúng, không sửa geometry/scene của chúng. Cần tìm chênh lệch ở luồng hosted app không được CarPlay hỗ trợ (YouTube/TikTok). Không được đồng nhất khái niệm app hệ thống với mọi app native bên thứ ba, và không được suy rằng Google Maps đã qua bài test gõ bàn phím riêng khi chưa có log/tường trình tương ứng.

## Nguồn đã trực tiếp đọc qua GitHub connector

Repository duy nhất `chuongnguyen89dn-ui/Omnicar`, `recovered-source/`, kho log trên `main`. Đã duyệt danh sách 26 commit tác động `logs/OmniCar.log` (8–11/11), kiểm nhiều revision theo `fetch_file`; khi connector trả nội dung rỗng cho blob lớn, dùng `fetch_blob` với SHA trả về. Đã đọc thêm `logs/OmniCar-log-20261107-1833.txt`, `logs/OmniCar.log.old`, `logs/DuoCar.log`. Chưa đối chiếu toàn bộ phiên bản lịch sử `.old`. Các thao tác này là GitHub connector, không phải shell/git checkout.

Bằng chứng **SCENE (không phải KEYBOARD)**:
- **07/11 15:01:39.856**, CarPlay PID 9572: Google Maps `DBApplicationSceneViewController` gắn ô 0, scene thực `297×360` lúc 15:01:40.797; **15:02:07.537** gắn Google Maps ô 1, xác nhận scene `297×360` lúc 15:02:08.471. [Log 07/11 L832–837](https://github.com/chuongnguyen89dn-ui/Omnicar/blob/8169c94c81e474767945edca8d620d5d23b1cad3/logs/OmniCar-log-20261107-1833.txt#L832-L837) / [L892–896](https://github.com/chuongnguyen89dn-ui/Omnicar/blob/8169c94c81e474767945edca8d620d5d23b1cad3/logs/OmniCar-log-20261107-1833.txt#L892-L896).
- **09/11 09:34:25**, CarPlay PID 31330: Google Maps vào ô 0; **09:34:55** Waze vào ô 0; **09:35:59** GOFA; **09:36:14** Apple Music UI service, dùng `DBApplicationSceneViewController`. [Log revision](https://github.com/chuongnguyen89dn-ui/Omnicar/blob/16f31259e9371670684b6c6e419a99a093bfbbbd/logs/OmniCar.log#L380-L685).
- **10/11 17:30:32.853**, CarPlay PID 42552: `[scenevis] attach bundle=com.google.Maps slot=1 scene=Car[2-3]:com.apple.CarPlayTemplateUIHost:com.google.Maps attached=1 inHost=1 hidden=0 alpha=1.00 window=1`. `DBApplicationSceneViewController` ở ô 1; kích thước `198×360`. [Log L202–206](https://github.com/chuongnguyen89dn-ui/Omnicar/blob/3e6e17f59e8af9a1a588dbcfeaad22925e81b2d1/logs/OmniCar.log#L202-L206).
- **10/11 17:30:52.250**, trong phiên đó, **YouTube PID 42559** chứ không phải Google Maps ghi `[hl11kb] ev=native-fit ... result=applied ... kb=UIRemoteKeyboardWindow kbFrame={{0,0},{495,450}}`. SpringBoard PID 42528 có `UIKeyboardWillShowNotification` 17:30:52.278. Log **không chứng minh Maps mở keyboard**, cũng không chứng minh fit YouTube cho đủ phím. [L721–722](https://github.com/chuongnguyen89dn-ui/Omnicar/blob/3e6e17f59e8af9a1a588dbcfeaad22925e81b2d1/logs/OmniCar.log#L721-L722).
- **11/11 09:59:36.565–09:59:37.495**, CarPlay PID 45354: `scenevis attach` Google Maps ô 1, `CarPlayTemplateUIHost`, `attached=1`, `inHost=1`, `297×360` verify. **09:59:46.268** có touch begin trong pane native, chưa chứng minh Maps xử lý xong sự kiện. [Log L1094–1111](https://github.com/chuongnguyen89dn-ui/Omnicar/blob/b7e7fbbc87f87b4de70ed8b50fac3b0c3b225531/logs/OmniCar.log#L1094-L1111) / [L1452](https://github.com/chuongnguyen89dn-ui/Omnicar/blob/b7e7fbbc87f87b4de70ed8b50fac3b0c3b225531/logs/OmniCar.log#L1452).
- **12/11 13:16**, Waze trong `logs/DuoCar.log` được định tuyến `kind=native`, `scenevis verify` ô 1, trong khi YouTube ô còn lại `hosted`. [DuoCar log L21–29](https://github.com/chuongnguyen89dn-ui/Omnicar/blob/b7a115d19d594813eeaa3ff5560c25995bee03ac/logs/DuoCar.log#L21-L29).

Bằng chứng **KEYBOARD HL36 (lỗi)**:
- **12/11 15:35:29.728**, YouTube PID 4013: `[hl36-native-only] native session accepted; inputView owned by UIKit`. **15:35:34.368** `event=focus owner=UIKit drawnPanel=unlinked`. [L1834](https://github.com/chuongnguyen89dn-ui/Omnicar/blob/b7a115d19d594813eeaa3ff5560c25995bee03ac/logs/DuoCar.log#L1834).
- **15:35:34.953**, `UIRemoteKeyboardWindow` **371×450**, `UIKeyboardLayoutStar` bắt đầu x=25,5 và rộng 371, vì vậy cạnh phải 396,5 > 371, `rightInsideClip=NO`. [L1949–1954](https://github.com/chuongnguyen89dn-ui/Omnicar/blob/b7a115d19d594813eeaa3ff5560c25995bee03ac/logs/DuoCar.log#L1949-L1954).
- **15:35:38.946**, `[hl34-keyboard] native-window-placed` đổi `UIRemoteKeyboardWindow` từ **495×450** thành **371×450**, nhưng `UIKeyboardLayoutStar` vẫn x=7,5, width **495**; cạnh phải 502,5 > 371, tràn **131,5 pt**; `rightInsideClip=NO`, `keycapRaster=UNKNOWN`, `keycapTouch=UNKNOWN`. [L2261–2269](https://github.com/chuongnguyen89dn-ui/Omnicar/blob/b7a115d19d594813eeaa3ff5560c25995bee03ac/logs/DuoCar.log#L2261-L2269). Đúng PID/marker HL36, không gộp với binary HL11.

## Phán quyết và điểm tiếp

1. **USER-DEVICE PROVEN:** theo test của Nguyen, bàn phím các app CarPlay hệ thống hiển thị và resize đúng. Không sửa chúng.
2. **LOG PROVEN:** native CarPlay map có scene trong ô chia; KHÔNG ĐỒNG NGHĨA log chứng minh bàn phím map đã nhập được.
3. **LOG PROVEN + DEVICE VISUAL FAIL:** trong YouTube hosted HL36 có keyboard-window/keyplane không cùng hình học. Việc đã gỡ drawn keyboard không giải quyết UIKit keyplane reflow.
4. **GIẢ THUYẾT CẦN KIỂM:** khác chủ scene/window và thời điểm relayout giữa template-native và hosted phone UI; không kết luận chắc nguyên nhân khi chưa đối chiếu code và UIKit hierarchy.
5. **Bước sửa đúng phạm vi:** đọc `project/OmniCarAppBridge/ABKeyboardTraits104.m` và caller `ABHostGeometry`/host-frame ở HEAD HL36; đối chiếu luồng native scene trong `SCPCarSplit` chỉ để học cơ chế phối hợp geometry, không ép hosted đi đường `CarPlayTemplateUIHost`; sửa đúng một owner/revision để keyboard window và UIKit keyplane cùng cập nhật. Đo bằng log PID/revision, chụp màn hình thử phím QWERTY, xóa, return, split 50/50/solo. Giữ dock/YTZ/picker/scene sustain, không dựng bàn phím vẽ hoặc writer thứ hai.

## Trạng thái lưu
Checkpoint log và xác nhận mới của người dùng. **Không sửa source, không dispatch CI, không build/ký DEB, không merge main, không triển khai Sileo, không device test bởi GPT.**


## Bổ sung kiểm source HL36 sau xác nhận của Nguyen

Đã đọc trực tiếp branch `feature/duocar-hl36-native-only-retire-drawn-20261112` bằng GitHub `fetch_file` tại:
- `recovered-source/project/OmniCarAppBridge/ABKeyboardTraits104.m` (blob `d655090e46bf673cbb7155dbeeba5b4f1217c73b`), đoạn 38–45, 85–115, 126–156, 316–374. `KB104ReferenceWidth()` ưu tiên **logicalWidth của packet**, `KB104WriteTraits()` set `UIKBScreenTraits.keyboardWidth`, nhưng `ABKB104PlaceKeyboardWindow()` **thay `keyboard.frame=sceneWindow.frame` ở dòng 363**. Đây là sự kiện có khả năng làm `UIRemoteKeyboardWindow` đổi width trước khi UIKit keyplane được tái bố trí; HL36 log thực xác nhận một trường hợp window 371 / keyplane 495 tại 15:35:38.946.
- `recovered-source/project/OmniCarAppBridge/ABInApp.m` (blob `1c32158d428928b159ce10d523b78cda062bf667`), 1176–1205: `ABNativeKbObserve()` gọi `ABKB104PlaceKeyboardWindow(keyboard,key,when)` rồi đo surface. Comment ở đầu nhóm nói “ONLY observes”/“writeFrame=0” **không mô tả đầy đủ tác dụng liên module**: helper được gọi có tác dụng ghi frame. Tránh lấy `writeFrame=0` của chính diagnostic làm bằng chứng writer không hoạt động. Chỉ có **một writer** tìm được trong module traits, không nói là writer thứ hai.
- `recovered-source/project/OmniCarAppBridge/ABHostGeometry.m` (blob `e7f79a0f9f54d626cc1ed85c336aa7225c556681`), AB24 revision tăng sau sceneBox commit, truyền vào packet; không suy ra UIKit đã relayout keyplane theo cùng revision.
- **Cơ sở mạnh nhất hiện tại:** gọi setter frame cửa sổ trong helper HL34 có thể tạo trạng thái tạm không đồng bộ với layout UIKit; đây là cơ chế nguồn phù hợp log, **chưa chứng minh nhân quả duy nhất** vì chưa đọc toàn bộ UIKit internal callback hoặc thử bản loại riêng setter. Không được vá bằng cách scale keyplane hoặc tạo bàn phím vẽ.

Không sửa code, không chạy CI, không có DEB/DEVICE PASS từ lượt bổ sung.
