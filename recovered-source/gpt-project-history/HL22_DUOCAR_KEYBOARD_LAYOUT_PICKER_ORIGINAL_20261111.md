# HL22 DuoCar — chỉnh sửa phần phím bị cắt và lớp picker gốc (2026-11-11)

## Yêu cầu
Nguyen báo bàn phím DuoCar `1.0.3-hl21duocar` **có xuất hiện, nhưng nội dung phím bị cắt giữa chừng**. Yêu cầu GPT tự tìm nguyên nhân và khắc phục; menu phải che nội dung bên dưới theo đúng DEB OmniCar gốc. Giữ chức năng pinch toàn OmniCar/DuoCar, Home/Dock native, loại nút nổi dự phòng, AutoHide/Wake và bàn phím **native UIKit**. Không tự triển khai bản thử mới lên Sileo, không merge main, không gỡ OmniCar cũ (Nguyen tự làm).

## Bằng chứng đã đối chiếu
- Đường picker gốc: `recovered-source/src/SplitScreenB/disasm/SCPCarSplit__showPickerForSlot_.txt` @`0x315ec..0x31624`: gọi `UIColor colorWithRed:green:blue:alpha:` với 0.933333/0.941176/0.984313/**1.0** rồi `setBackgroundColor:`. HL21 còn `picker.backgroundColor = hasContent ? [UIColor clearColor] : lavender`; đây là phần rollback chưa hoàn chỉnh SOURCE-PROVEN.
- App bridge HL11 và HL21 cùng blob `ABInApp.m=73557304be29f4b5b7f7a4301e199e3ec655c9c3`. `ABNativeKbFit` chỉ gán `keyboard.frame=key.frame`; return success khi thấy keyboard window/key frame, **không quan sát layout con**, nên có thể coi đã fit dù `UIKeyboardLayoutStar` bị cắt. HL14 thử ép frame/bounds/root layout; log có star width thay đổi nhưng người dùng vẫn báo bị cắt. Không mang nguyên bản vá HL14 vào.
- Host `ABHostBMethods.m:layoutPane:` dùng `round(boxSize.width / zoom)` cho kích thước scene logic, không đồng bộ trực tiếp keyplane; `ABOrientationBlock` host-frame của app HL11 chỉ refit nếu đã lưu original keyboard. Đường `hostFrameForPane` trả `CGRectZero` khi picker được mở, có thể gây hình học lệch khi đóng. Chưa có log DuoCar mới cùng PID xác định lớp cắt chính xác. **Đây là thiết kế sửa theo điểm yếu source đã xác định, chưa phải runtime-proven root cause.**

## Source/CI đã thực hiện
- Repo duy nhất `chuongnguyen89dn-ui/Omnicar` phần `recovered-source/`, nhánh code mới `feature/duocar-hl22-keyplane-menu-original-20261111`, nền đúng DuoCar HL21 `055950de091e18e6cab8180379e2558949d2ac9a`.
- Source commit **`ee684e1cefce6652927c67ff7dc426295d686854`**, tạo tree có 9 file/hunk:
  1. `recovered-source/project/OmniCarSplitScreen/SCPCarSplit+Picker.m` và `recovered-source/src/SplitScreenB/SCPCarSplit+Picker.m` byte identical, picker màu lavender alpha=1 theo DEB gốc ngay cả khi slot đã có app; `hasContent` vẫn giữ chỉ cho log.
  2. `recovered-source/project/OmniCarAppBridge/ABInApp.m` và `recovered-source/src/AppBridgeB/ABInApp.m` byte identical, giữ UIKit native HL11 nhưng thêm helper `ABNativeKbFindLayout` tìm `UIKeyboardLayoutStar` theo view tree (depth max14); `ABNativeKbFitLayout` đo `convertRect:toView:keyboard`, nếu nội dung rộng hơn viewport thì tạm dùng transform scale chiều ngang và chỉnh center cho nằm trong khung. Guard `ratio in [0.4,1]`, nguồn frame là keyboard window; phép biến đổi UIKit UIView transform ảnh hưởng visual/hit coordinate. `ABNativeKbRestoreLayout` khôi phục transform/center khi hide, resign, keyboard replaced. `ABNativeKbFit` từ chối trả success chỉ dựa vào thấy window, thêm yêu cầu bố cục không vượt khung; listener `keyboardDidChangeFrame` và orientation frame retry có epoch/firstResponder gate. Cơ chế private UIKit phải test device trước khi gọi pass; không hook `keyboardScreenReferenceSize`, không tạo keyplane mới, không chuyển drawn keyboard.
  3. `recovered-source/gpt-project-history/verify_hl21_regression.py` nâng invariant sang HL22 (giữ pinch/Dock, kiểm layout helper và picker).
  4. `recovered-source/gpt-project-history/rebrand_duocar.py` nâng Version `1.0.3-hl22duocar`; không đổi tên package mới, không thêm Conflicts/Replaces.
  5. `recovered-source/gpt-project-history/verify_duocar_payload.py` nâng version & kiểm marker mới trong binary FAT.
  6. `recovered-source/gpt-project-history/verify_hl22_geometry.py` thêm kiểm trường hợp tỉ lệ 414→238/371/414/495, guard hẹp; đây chỉ là unit/formula, **không mô phỏng UIKit thật**.
  7. `.github/workflows/build-fat-macos.yml` thêm branch HL22 + test trước khi compile, build FAT signed artifact `duocar-hl22-fat-deb`, **xóa step tạo GitHub Release công khai**, không publish Sileo. Không có merge/push sang main code.
- CI run được khởi động **tự động bởi push branch** `42969536072` / job `130354519424`. Lần kiểm đầu đang `Install Theos`. Cần đọc cổng compile/verify, không giao DEB từ source chưa qua CI.
- Trạng thái checkpoint: **SOURCE COMMITTED, CI IN PROGRESS, DEVICE UNKNOWN**. Phiên DuoCar HL21 trên Sileo vẫn DEVICE FAIL keyboard. Trước khi báo DONE phải tải đúng artifact run HL22, kiểm metadata/sha/payload signatures, và bàn giao DEB trực tiếp; nếu CI FAIL thì sửa đúng hunk trên branch theo log.

## Tiêu chí xe
1. Bàn phím native hiện đủ hàng phím hai mép; các phím ngoài cùng có hit target, nhập được; thử ô hẹp, kéo divider khi keyboard còn focus, đóng/mở và đổi app; không chụp nội dung gõ.
2. Menu trên ô đã có app phải che nội dung như DEB gốc, có thể chọn/hủy, background app trở lại không mất scene.
3. Pinch fullscreen toàn DuoCar và ẩn/hiện Dock, Home own icon, không nút phụ nổi, Logo recall, reconnect/restart không hồi quy.
4. Nếu screen/video lỗi vẫn còn, cần log đúng DuoCar binary/PID với `[hl22-keyplane]` để phân biệt `layoutMeasured=0` hay ratio, không đoán nguyên nhân.

## 2026-11-11 — CI fail test-order trước compile, đã sửa, retry
- First HL22 run **`42969536072`**, job `130354519424`, HEAD `ee684e1c`: fail **sau Verify HL22 source invariants PASS và rebrand 476 files PASS**, nhưng trước make/ldid. Đã đọc GitHub job log: `FileNotFoundError` của fixture `verify_hl22_geometry.py` tìm `project/OmniCarAppBridge/ABInApp.m` **sau khi rebrand module name thành DuoCar**. Đây là lỗi **thứ tự CI**, không phải lỗi compiler hay lỗi UIKit.
- Sửa đúng một hunk thứ tự workflow: chuyển step `Verify HL22 keyboard geometry and DEB-original menu source fixtures` lên trước `Rebrand the complete source/build tree`, giữ nguyên source code và marker. Commit **`c1b3cc75c21747c5483366472b1375bd6a12ba53`**, đã fetch_file đọc lại đúng thứ tự + không có `gh release create`.
- Retry CI do branch push **`42969820723`**, job `130355416880`, lúc ghi checkpoint đang cài Theos. DEB **chưa có** từ run thất bại; source actual HL22 commit `ee684e1c`, workflow final HEAD `c1b3cc75`. Cần lấy đúng DEB từ run mới khi các gate hoàn thành.
