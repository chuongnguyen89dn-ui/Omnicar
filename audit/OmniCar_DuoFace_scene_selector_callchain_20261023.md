# Đối chiếu chuỗi lời gọi ObjC/ARM64: DuoFace Native12 ↔ OmniCar (23/10/2026)

**VERIFIED STATIC CALLSITE; DEVICE UNTESTED.** Mọi phép đọc thực hiện trên DEB gốc đã xác minh SHA256. Chưa chỉnh sửa runtime, chưa build DEB, chưa phát hành Sileo.

## Nguồn thực thi đã kiểm chứng

- Script: scripts/audit_v12_omnicar_scene_calls.py, commits 5b9fd834cb5df73589395b6bf0683c9baa2f3478 và 0635e2a6a292b4a709d0216869636ffa25ce6853.
- Workflow: .github/workflows/audit-v12-omnicar-yt-scene-machine.yml, commit b0af13d2f339965ebb1f6421c873f7a89de1f6c7.
- **GitHub Actions SUCCESS:** run 39925450545, job 120320587394, https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39925450545.
- Artifact lưu bền vững: audit/native12_vs_omnicar_scene_selector_calls_20261023.json, blob be57be31de81aa2df3a63595304a368f05b8ad23, commit 888d6a84b1a404676849c18699094c391c2c34ba, đã đọc lại. Kết quả: 7 vùng method DuoFace, 4 vùng OmniCar, 154 external imports mỗi dylib; giữ nguyên mọi callsite chưa giải mã được.
- DuoFace v12 DEB SHA256 8b7dedf77b9ec05465b83fdb6e2d7127800eac232a34ecf12f2c08b3983a481a; DuoFaceDashboard SHA bc1df854ec7a2ddfeec4cb81b080ead34b54df80143d4a8f6254bb8b618003ce.
- OmniCar original DEB SHA256 d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd; OmniCarAppBridge SHA d99b8d00dc60f69db7b54fc1addaec6b8cb866b8dcdde6f1d85e06ce5b7d6e79. DuoFace checkout read-only ref 6193b9e77337fd1e9d586da5e5bf39742d041d2d.

## Chuỗi thực sự đọc được trong DuoFace

1. CBBridgedSplitApp.updateScale:forSlot: tại **0x108e40** gọi selector **refreshSceneLayout** qua _objc_msgSend.
2. CBBridgedUIAppView.refreshSceneLayout tại **0xade74** gọi **updateLayout**, tại **0xade84** gọi **updateSceneSettingsFrame**, sau đó gọi **setNeedsLayout** (0xadedc) và **layoutIfNeeded** (0xadf08). **Thay đổi tỷ lệ có đường kích hoạt cả layout và scene settings**, không chỉ thay zoom.
3. CBBridgedUIAppView.updateSceneSettingsFrame gọi **carPlayUsableBounds** ở **0xad620**, **calculateNativeSizeForSlotRect:** ở **0xad638**; đồng thời có lời gọi động **performSelector:** (0xad738, 0xad780, 0xad918, 0xad958). Chưa xác minh receiver/private selector được thực thi ở các lời gọi động đó.
4. calculateNativeSizeForSlotRect: **0xacc28–0xacc68** có đường kích thước dương nhân đôi và làm tròn (bằng chứng toán học ở audit/OmniCar_vs_DuoFace_native_scene_formula_20261023.md). CBBridgeManager.renderSizeForBundleID: cũng có **carPlayUsableBounds** ở 0x24cbc4, 0x24cc04, 0x24ce4c, 0x24ce84, 0x24d008, 0x24d02c, 0x24d08c, 0x24d0c8; chưa biết đường nào được chọn cho YouTube cụ thể.

## Chuỗi thực sự đọc được trong OmniCar

1. ABHost.setFrame:forApp:live:handle:passInsets: tại **0x1012c** gọi selector **layoutPane:**; trong cùng vùng có **setFrame:** (0xff90, 0xffbc), **layoutBarForPane:** (0x10010), **sceneBox** (0x100d8), **effectiveOrientation:** (0x10160).
2. ABHost.layoutPane: tại **0xed18** gọi **zoom**, tại **0xed70, 0xedc8, 0xeee8** gọi **setTransform:**, tại **0xed9c** gọi **setFrame:**, **0xeddc** gọi **setCenter:**, **0xefbc** gọi **effectiveOrientation:**, tại **0xf074** gọi **setSceneBox:**. Đây là chuỗi **host frame → zoom + transform → sceneBox**; không phải chức năng tùy biến các nút Play/Pause của YouTube.
3. ABHost.effectiveOrientation: tại **0xf380, 0xf390** gọi **requestedOrientation**, **0xf39c** gọi **orientation**, **0xf3e0/0xf3ec** gọi **ensureWindow / window**. Phải giữ nguyên owner/lifecycle khi đổi hướng, không tùy tiện ép orientation.
4. ABHost.zoom có giá trị chung appBridgeZoom / 100 clamp 0.6…1.0 (audit static trước) và nay đã giải được lời gọi **doubleValue**. Khác Native12, chưa có bằng chứng original OmniCar có scale per-slot tự động giống DuoFace.

## Kết luận có giới hạn

- **Đã có liên kết hàm cụ thể hai bên**, vượt qua việc chỉ so tên class: Native12 scale slot → refresh → layout + scene settings → native slot size; OmniCar host frame → layout pane → zoom/transform + sceneBox.
- Hai cơ chế scene/geometry có thể khiến YouTube sắp xếp và hiển thị Play/Pause/Next khác nhau. Nhưng đó **chưa phải kết luận nguyên nhân trên iPhone**, do thiếu cùng YouTube version, source scene kích thước và quan sát CarPlay.
- Trong OmniCar có literal hook private SBSceneView -_updateReferenceSize:andOrientation: (audit original trước). Callsite, tham số runtime và liên hệ từ sceneBox đến private hook **chưa được chứng minh bằng log**. Không được sao chép DuoFace dylib, mặc định nhân đôi toàn màn hình, hoặc áp scale 0.5.
- Phân biệt host AppBridge ABPane và split SCPCarPane; timer/menu 3 chấm YouTube là phạm vi owner khác player geometry. **Giữ QA12 Sileo nguyên trạng**; không xóa Zoom, Swap, Solo, divider, 4s timer, dock.

## Thao tác tiếp theo, tiêu chuẩn xác nhận

1. Tiếp tục giải mã metadata hook SBSceneView và ABI callsite, đặc biệt các tham số referenceSize/orientation, không tự nhận đã kiểm chứng live.
2. Chỉ khi có căn cứ mới tạo mô-đun **diagnostic log-only**: bundleID, pane frame, SBSceneView referenceSize, sceneBox, appBridgeZoom, requested/effectiveOrientation và frame/hit-test; ghi khi split → kéo ratio → solo → phục hồi, tránh ghi video/tài khoản.
3. Nếu đo thực tế cùng YouTube trên DuoFace Native12 và OmniCar xác nhận nguyên nhân, xây adapter chỉ áp YouTube trong AppBridge, kiểm hồi quy map+map, YouTube+map, YouTube solo, video/touch, 3-dot, Zoom/Swap/timer và crash. Giữ candidate độc lập chưa thay QA12 công khai cho tới khi thiết bị PASS.

## Lệnh tái tạo đã chạy ở GitHub Actions

~~~bash
python scripts/audit_v12_omnicar_scene_calls.py \
 --duoface duoface-reference/dist/visual-1.0.3-12/com.duoface.app_1.0.3-12_visualtest_iphoneos-arm64.deb \
 --omnicar com.anlai.omnicar_1.0.3_iphoneos-arm64.deb \
 --output audit/native12_vs_omnicar_scene_selector_calls_20261023.json
~~~

Ubuntu 24.04, Python venv, Capstone 5.0.7, dpkg-deb; KHÔNG sử dụng iPhone hoặc thay đổi UI.
