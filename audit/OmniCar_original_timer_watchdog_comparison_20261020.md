# OmniCar 1.0.3: toàn bộ nhóm TIMER, expiry/time guard và so sánh DuoFace

Ngày kiểm tra: 2026-10-20. **CHỈ PHÂN TÍCH nguyên bản, không sửa source/binary/DEB/Sileo.** Input thực tế `/mnt/data/com.anlai.omnicar_1.0.3_iphoneos-arm64.deb`, SHA256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`.

## 1. TIMER ẩn giao diện trong bản gốc — chính xác 4 giây

| Native owner | Địa chỉ ARM64 | Thời gian/hành động |
|---|---|---|
| `OmniCarSplitScreen.dylib` `SCPCarSplit showRatioMenuForDivider:` | `0x2ff78: fmov d0,#4`; `0x2ff88` calls `scheduledTimerWithTimeInterval:repeats:block:`; `0x2ffa0 setRatioTimer:` | 4 giây **không lặp**, callback `0x30ca0` → `0x30cb8 hideRatioMenu` |
| `OmniCarSplitScreen.dylib` `setBarVisible:forPane:` | `0x24424: fmov d0,#4`; `0x24434` scheduled NSTimer; `0x2444c setBarTimer:` | 4 giây **không lặp**; block `0x24bac` → `0x24bf8 setBarVisible:NO forPane:` |
| `OmniCarSplitScreen.dylib` `restartTrayTimer` | `0x3bca4: fmov d0,#4`; `0x3bcb4` scheduled NSTimer; `0x3bccc setTrayTimer:` | 4 giây **không lặp**; block `0x3bd38` → `0x3bd50 collapseAppTray` |

Trong cả ba trường hợp lệnh `mov w2,#0` trước `scheduledTimer` thể hiện repeats=NO. Phải phân biệt **menu/thanh/khay** với **nút ba chấm/pill tay nắm**: timer chỉ trực tiếp đóng view tương ứng; `handle` là view khác có logic `layoutBarForPane:` / `setBarVisible:forPane:`. 4 giây trôi qua **không bảo đảm** icon `•••` sẽ tự ẩn. Khi `handleTapped:` gọi `setBarVisible:forPane:` có thể tái mở toolbar; timer cũ bị `invalidate` mỗi lần đặt trạng thái.

## 2. Timer của Startup Screen

Chính file **`var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/FeatureStartupScreen.plist`** xác định khóa `startupScreenDuration`: mặc định **5 giây**, cho chỉnh **1–30 giây**. Original splash binary `OmniCarStartupScreen.dylib` chứa các ký hiệu `SSSplashWindow`, `SSSplash`, `startCountdown`, `startTime`, `%.0fs timer`. Ngoài ra có `startupScreenPlayFull` default NO và `startupScreenTapToSkip` default YES. Đây là timer hiển thị **màn hình khởi động** và độc lập với 4s split toolbar và Core expiry timer. Không thể kết luận bản cài hiện tại đang ở mức 5 giây nếu prefs trên iPhone đã được người dùng chỉnh.

## 3. Timer thời hạn/watcher từ Core — quan trọng với so sánh DuoFace

`OmniCarCore.dylib` có `OMCExpired` (IMP `0xc414`), `_OMCTrustedTimeStart` (IMP `0x44a8`) và cờ trạng thái hết hạn trong tiến trình; đọc ưu tiên cả thời gian hiện tại và khóa CFPreferences **`trustedTime`** ở miền `com.anlai.omnicar` (`_OMCExpired` load cfstrings tại 0x14a08/0x14a28), so sánh với giới hạn hiệu lực rồi có thể ghi nhớ trạng thái hết hạn. `OMCEnabled` tại `0x659c` gọi `_OMCExpired` qua `0x65a8` và trả FALSE nếu đã hết hạn. Dữ liệu **mốc tuyệt đối** nhúng trong binary là **`2027-04-30`**, với các log `free period over (%s)` và `free period over (%s): features off`.

| Lịch Core | Lệnh bằng chứng ARM64 | Tác dụng theo callback |
|---|---|---|
| **21.600 giây = 6 giờ**, lặp | `0x4524 ldr d0,[x8,#0xab0]` (mẫu double ở địa chỉ `0xfab0`, 21600.0); `0x452c scheduledTimer`; repeats=YES. Block invoke pointer `0x4648`. | `0x4648` chuyển sang `0x456c` — nhánh yêu cầu/đồng bộ thời gian. Binary có URL `https://www.apple.com/`, network request timeout 15s (không suy luận server trả ngày gì nếu chưa có log). |
| **60 giây**, lặp | `0x4544 mov x8,#0x404e000000000000`, `0x4548 fmov d0,x8`, `0x4550 scheduledTimer`; repeats=YES. Block invoke `0x464c`. | `0x4674` gọi `_OMCExpired`; khi trạng thái mới thành hết hạn, ghi log `free period over (2027-04-30): features off`, phát `notify_post("com.anlai.omnicar/prefschanged")` tại `0x46cc`–`0x46d0`. |

**Tại sao trạng thái vẫn tồn tại?** Nếu nói về **hết hạn/tính năng tắt**, `_OMCExpired` xét `trustedTime` đã lưu (có thể muộn hơn giờ đang hiển thị) và giữ cờ trong bộ nhớ; việc thay đổi thời gian hệ thống hoặc đóng thanh UI không tự xóa trạng thái. Không có bằng chứng từ DEB rằng Core vẽ một banner đếm thời gian cụ thể lên CarPlay; log free-period không đồng nghĩa một UIView đang hiện. Ở ngày 2026-10-20, mốc **2027-04-30 vẫn ở tương lai** nếu đồng hồ/trustedTime ở thời gian đúng, nên không được tuyên bố đã hết hạn trên thiết bị người dùng. Nếu chữ timer/splash còn hiện quá 5s, cần kiểm tra prefs `startupScreenPlayFull` và logic đóng splash. Nếu **nút ba chấm** còn hiện, bản gốc chỉ dùng barTimer để đóng menu, không phải cùng cơ chế ẩn nút idle như DuoFace.

## 4. Đối chiếu đúng với DuoFace

- DuoFace **Native12** (`CBBridgedSplitApp`) có `noteUserActivity`, `startBlinkingSession`, `stopBlinkingSession`, `_blinkingIdleTimer`, `_lastActivityTime`; dùng trạng thái hoạt động/idle để điều khiển viền/nút. Tham chiếu verified `Duoface/tiep tuc du an.md` checkpoint 2026-10-14 và `Duoface/audit/v12-picker-header-20261014.txt`. Độ dài timer idle native DuoFace **chưa xác minh là 4 giây**, không gán bừa.
- DuoFace **cơ chế thời hạn** có lịch watchdog trong `CBBridgeManager` và sync/license lease của `com.duonavi.sync.plist`; việc hết hạn có thể liên quan trạng thái cấp quyền CarPlay. OmniCar Core cũng kiểm tra hết hạn lặp, nhưng dùng `trustedTime` và deadline nhúng trong binary; đó là **tương đồng về nguyên lý**, không phải cùng source, cùng lease hoặc cùng logic.
- DuoFace adapter menu **Airaw staged** có giá trị auto-hide **5 giây** tại `Duoface/audit/airaw-restore-control-20261014.txt`, nhưng là module thử nghiệm khác, không chứng minh Native12 dùng đúng 5s.

## 5. Đã làm/tiếp theo

- THỰC THI: đọc đúng DEB gốc bằng `dpkg-deb -x`, kiểm plist bằng Python `plistlib`, `llvm-objdump --macho --arch=arm64 --disassemble`, kiểm timer callsites và block-callback; chạy `python /mnt/data/omnicar_timer_audit/audit_original_omnicar_timers.py /mnt/data/com.anlai.omnicar_1.0.3_iphoneos-arm64.deb --out /mnt/data/omnicar_timer_audit/original_timer_results.json` PASS. Kèm script có thể chạy lại trong repo `scripts/audit_original_omnicar_timers.py`.
- CHƯA thực hiện: không chỉnh giao diện, timer, entitlement, expired state, source hoặc binary; không đóng DEB, không cập nhật Sileo, không chạy job. Cần user xác định rõ thứ `vẫn hiện` là **nút ba chấm/thanh menu**, **màn khởi động đếm giây** hay **thông báo hết hạn**, nếu muốn kết luận UI cụ thể thay vì ba cơ chế khác nhau.
