# HL27 — Khôi phục hành vi bàn phím HL11 có chọn lọc (2026-11-11)

## 1. Quyết định và trạng thái
Nguyen xác nhận lấy hành vi bàn phím HL11 từ video IMG_8191.mp4 (TikTok đã hiển thị và gõ được; chia tỷ lệ vẫn chưa hoàn thiện) làm mốc hồi quy. Không hoàn nguyên toàn bộ HL11 do lỗi pinch/zoom ở bản đó. Tiếp tục một nhánh chuyên biệt: `feature/duocar-hl27-hl11-keyboard-restore-20261111`. Repo chính `chuongnguyen89dn-ui/Omnicar`, worktree `recovered-source/`. Nhánh **đã tồn tại** khi kiểm, HEAD ban đầu đúng HL26 `140fcc276e5803906d3730fc328e83527dcbc8ca` (không tạo nhánh mới).

**Hiện trạng đã xác minh:** chỉnh source và commit vào GitHub, project/src ABInApp cùng blob `1f059390e01a21caa3be781fc96fb3a5e71f88a2`; HEAD nhánh bàn phím `04728bd52c9503573d30c6757132644a6ce69e3c` (4 commit sau HL26). **CHƯA CI/compile/DEB**, **CHƯA xe/iPhone test**, không sửa/merge main code, không phát Sileo. Không tuyên bố hết cắt phím. Ghi hồ sơ trên main là hành vi được Nguyen cho phép, không phải merge source.

## 2. Bằng chứng đọc source trực tiếp
- HL11 commit `b77e4b4d102ce9b73d4d1384afabccffe718c702`, `recovered-source/src/AppBridgeB/ABInApp.m` SHA `73557304be29f4b5b7f7a4301e199e3ec655c9c3`. `ABNativeKbBegin()` gọi `if (ABNativeKbFit(why,0)) return;` rồi chỉ lên lịch retry 0.3/0.6/1.2 s khi lần đầu chưa thấy keyboard window. `BWKbFrameNote()` chỉ ghi bằng chứng trạng thái, host-frame gọi một lần duy nhất trên keyboard đã có.
- HL26 commit `140fcc2...`, cùng file SHA `2ed27d3b6632b91989fc491a560e7cef2350b014`. `ABNativeKbBegin()` gọi fit đầu nhưng vẫn schedule 3 retry dù thành công; `BWKbFrameNote()` dispatch thêm `ABNativeKbFit(@"keyboard-frame",0)`; host-frame scheduling thêm 2 fit sau 0.12 và 0.35s. Đây là **3 nguồn refit bổ sung có thật trong source**, khả năng xung đột UIKit **chưa được chứng minh là nguyên nhân duy nhất**.
- HL24/Hl25 log và video trước đó: khung keyboard/window rộng phù hợp vẫn có thể có keycap bị che phía phải, nên `already-fit`/geometry không phải DEVICE PASS. Tầng z-order / keyplane / clip vẫn cần dữ liệu. `UIKeyboardLayoutStar.transform` đã read-only ở HL24; tuyệt đối không đưa lại phép scale chồng.

## 3. Những hunk đã commit, chỉ hai file AppBridge
1. `recovered-source/project/OmniCarAppBridge/ABInApp.m`
2. `recovered-source/src/AppBridgeB/ABInApp.m`

Áp dụng cùng nội dung trên cả hai file, không copy file HL11:
- `ABNativeKbBegin()`: khôi phục `if (ABNativeKbFit(why,0)) { log; return; }`; retry 0.3/0.6/1.2 chỉ khi keyboard window ban đầu chưa sẵn sàng. Vẫn giữ bảo vệ HL24: **không** gọi `reloadInputViews` và không scale `UIKeyboardLayoutStar`.
- `BWKbFrameNote()`: bỏ dispatch fit bổ sung lúc `UIKeyboardDidChangeFrame`; giữ đường ghi trạng thái ACTIVE trên real frame và chẩn đoán.
- `ABOrientationBlock()`: chỉ fit một lần khi host gửi geometry mới hợp lệ, revision không stale, orientation/width đổi và đã có cửa sổ keyboard/focus thật. Bỏ `host-frame-settled` 0.12/0.35. Giữ số revision, host epoch, geometry package, host-side `AB24FrameRevision` và `ABHostBMethods.m` nguyên trạng.
- `ABNativeKbBegin()` khi retry trễ thành công: tăng epoch để huỷ retry kế tiếp. `ABNativeKbWindowVisible()` tăng epoch khi đã tìm thấy keyboard, không tiếp tục fit từ lịch retry cũ.
- Không đụng Settings, Respring, Dock/Home, zoom/pinch, picker, YTZ/AutoHide/Wake, scene setter hay mã Muse.

**GitHub commit chính xác:** project initial `0fbbe79d95918600657f209654fb5055d7a15d66`; src initial `ead521cfe45b0bc5cba5fc68ce91761988cf323b`; project retry-cancel `0c8bedfcdb58c6f17d341646a5d31a5ad915e952`; src retry-cancel `04728bd52c9503573d30c6757132644a6ce69e3c`. 4 commit do contents API cập nhật từng file, không có checkout/working tree local nên **dirty state local = UNKNOWN/not applicable**. Cả hai file đọc lại sau ghi có cùng SHA blob, size 166081 UTF-8 chars; compare HL26..HL27-kb `ahead=4, behind=0`, đúng hai đường dẫn.

## 4. Điểm nối với nhánh HL27 Settings/Respring đang có
Nhánh song song **khác nhau trong cùng repo**: `feature/duocar-hl27-settings-respring-diagnostics-20261111` HEAD kiểm `e5c2c51cde56d8cd2946b0c146e9db2cc8520142` (so HL26 ahead=15, 10 files). Nhánh này đã build FAT run `43018591031` SUCCESS, artifact `13853648459`, DEB SHA256 `af78d07326e3d2d0f0d8cfa971709281169a8dd74651f2e7fa43ab3dd64f7401`; keyboard vẫn chưa được sửa, chỉ thêm **read-only `[hl27-keyplane]`** trong chính `ABInApp.m`, cùng các thay đổi UIKit Settings/Respring ngoài file này. **Đây không phải kết quả build của patch bàn phím trên nhánh này.**

**CẢNH BÁO ĐIỂM XUNG ĐỘT:** `ABInApp.m` của nhánh Settings/Respring có blob `70d259a3ce7cc686832338484f82b49e16355274` khác nhánh keyboard blob `1f059390...`. Khi tích hợp một DEB, mở **file hiện hành trên nhánh đích**, giữ các dòng đo `[hl27-keyplane]`, chỉ ghép 4 hunk keyboard nêu trên theo hàm, rồi đồng bộ project/src. **Không copy đè nguyên file từ nhánh keyboard** (sẽ xóa chẩn đoán HL27). Không build DEB keyboard độc lập và Settings độc lập rồi ghép hai DEB. Người dùng chưa giao run CI ở lượt này; không dispatch workflows, publish hay merge main. Các nhóm trách nhiệm Muse không bị thay đổi.

## 5. Kiểm tra đã làm và còn thiếu
Đã dùng GitHub connector `fetch_file`, `fetch_commit`, `compare_commits`, `fetch` (branches/workflow runs) để kiểm trạng thái trước sửa; `update_file` với **SHA blob guard**, rồi `fetch_file` và `compare_commits` xác nhận. **Không có shell checkout/clang/iOS SDK trong thao tác này**; không gọi đã chạy Python verifier, compiler hoặc thiết bị.
- Source checks đọc lại: `ABNativeKbBegin` có early-exit; lịch retry vẫn có khi initial fail; retry success + window-visible success tăng epoch; không có `host-frame-settled` hay `ABNativeKbFit(@"keyboard-frame")`; không gọi `reloadInputViews`/layout transform; `revision < ABNativeKbGeometryRevision`, `ABNativeKbRestore(@"host-release")`, `ABNativeKbRestore(@"will-hide")` được giữ. Project/src cùng SHA.
- Phải xác nhận integration giữ `[hl27-keyplane]` của nhánh HL27 Settings, các kiểm tra tĩnh hiện có `verify_hl24_keyboard.py`, `verify_hl25_scene_keyboard.py` + build clang/ldid cho đúng package mới. Nếu user giao build, chỉ **một** workflow/DEB FAT sau hợp nhất source, không chạy song song với Muse.
- Cổng xe (Nguyen): TikTok/YouTube/Facebook focus 10 lần mỗi app, giữ phím đủ hai mép, nhập/xóa/Return, kéo divider qua các tỷ lệ khi phím đang mở, đóng/mở ô, đổi app, reconnect; đồng thời kiểm fullscreen pinch, Dock/Home, menu gốc, Settings/Respring đã ổn. Đối chiếu video + log đúng **PID/build marker/time**; `[hl27-kbreg]`, `[hl11kb]`, `[hl24-geometry]`, `[hl25-kb-surface]`, `[hl27-keyplane]` từ **cùng** thế hệ binary. Không có log không chứng minh phím không hiện.
- Nếu vẫn bị cắt mép phải dù window frame trùng, phải phân định host z-window/clip vs UIKit keyplane/scene contract từ log và video; không tăng thêm timer hoặc scale theo suy đoán.

## 6. Đường lui, checkpoint, bước kế tiếp
Rollback keyboard-only: revert **4 commit trong nhánh keyboard theo thứ tự ngược**, hoặc bỏ 4 hunk keyboard trong bản tích hợp. Không rollback toàn HL26/HL11 làm mất tính năng khác.
Bước kế: đối chiếu `ABInApp.m` của nhánh Settings/Respring, ghép chọn lọc cả diagnostics và 4 hunk keyboard vào nhánh tích hợp **chỉ sau khi có phân công tích hợp**; xác minh source parity, source verifier, build FAT đúng artifact, rồi nghiệm thu thiết bị. Hoàn tất lượt này: **source committed, readback PASS, CI=NOT RUN, DEB=NOT BUILT, DEVICE=NOT TESTED**.
