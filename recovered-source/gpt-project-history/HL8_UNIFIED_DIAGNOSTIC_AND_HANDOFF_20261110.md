# HL8 — Một log chẩn đoán bốn lỗi OmniCar (10/11/2026)

**Trạng thái: SOURCE COMMITTED; STATIC/PARITY REVIEW. CHƯA BUILD / KÝ DEB HL8, CHƯA CI HL8, CHƯA DEVICE PASS.** Muse chỉ tích hợp/biên dịch/ký một DEB tổng hợp theo phân công, không giao lại lỗi Logo/Pinch cho Muse. GPT không merge main, dispatch CI, deploy hay publish Sileo.

## 1. Lý do đổi hướng, nguồn và PID

Nguyen yêu cầu một phiên log đủ thấy nơi hỏng thay vì sửa mò mỗi vòng. Bốn verdict HL7 trên xe: (1) bàn phím hệ thống cho app không hỗ trợ CarPlay chưa hiển thị đúng, (2) gọi lại Logo vẫn có chạm lọt vào app native, (3) không pinch hai ngón bung/thu toàn bộ OmniCar và ẩn/hiện dock, (4) bàn phím không bám geometry khi đổi tỷ lệ.

Nguồn HL7 thực: main log commit 06fba1132bed45277d696a8f1114dabf70e53922; logs/OmniCar.log. Phiên ~12:22–12:28 ngày 10/11: CarPlay PID 40787; SpringBoard 40749; YouTube 40799; TikTok 40796. Không trộn với HL6 PID 40220.
- Pinch HL7: 17 cặp hai ngón thật, có cả hai ô; 0 request / 0 applied; 16/17 cặp không ghi Moved, cặp còn lại một Moved ở một ngón.
- Logo: hitParent {{590,6},{44,44}} ở appArea {{45,0},{595,360}}, khác vị trí HL6 sai; 9 logo-hit reveal, 6 ACK0 already-visible, 6 host ACK state=2; không có wake-ui. Hit rect và ACK không chứng minh callback, cần đo độc lập.
- Keyboard: YouTube có responder became (YTSearchBarView); drawnKeyboard=0, native-locked-hl3; ABKeyboardPublish trong app bị chặn cứng khi native. Bàn phím hệ thống CarPlay có hiển thị/đúng geometry hay không vẫn BLIND từ reader cũ.
- Kéo ratio: 50/50, 67/33, 33/67 được log; native Maps scene yêu cầu/confirm các chiều rộng 297, 198, 396pt, nhưng chưa có bằng chứng pixel phím theo scene.

## 2. Các thay đổi đã commit

Repository duy nhất: chuongnguyen89dn-ui/Omnicar; cây thi công recovered-source. Branch GPT: feature/hl7-touch-lifecycle-gpt-20261110, tạo từ main 06fba113. Trước commit hồ sơ: compare ahead 13, behind 0, không merge main.

Ba commit thay đổi hành vi (chưa device-proven):
1. 3919c0b6acae5aaa841ef6f90807899ca4d2e0a6 — tính touch terminal trước khi xóa record (không giả tạo chuyển động).
2. 9ff2095951dd10c8794612647966292b5c3cb3cf — cổng giữ first-tap native khi controls thật sự faded chạy TRƯỚC original sendEvent, giữ cả dãy đã nhận; chạm khác vẫn original. Cần đặc biệt kiểm không cướp tap không liên quan.
3. da827f8b0be71203c14229a0adb13d39b6fc11b8 — pair-at-Began toggle toàn split bằng fullscreen adapter duy nhất; không zoom video; tái sử dụng tiền lệ HL4 thành công trên TikTok. Pref bridgewake.carHostPinchPairToggle=NO phục hồi đường đo ratio/direction.

Mã chẩn đoán sau đó:
- b040b398: CarPlay touch id/dispatch, pinch pair/gates/result, kb scan/notification
- db264e13: Logo callback và panel action, hl8seq kèm frame-send
- 67f103a1: relayout/scene-size theo tỷ lệ, keyboard scan lúc layout
- 7f327c39: SpringBoard keyboard native gate + frame-recv/applied/settled sau 350ms, hl8seq
- 6d1f7c4a: app hosted focus/mode-recv/publish-blocked và geometry phím
- 3648246a: native-wake gate accept/reject reason
- b4e5945b: analyzer chọn PID và tạo verdict
- d844960d: phân biệt fs-gate với lệnh fs-request thật
- 45701fa6: parser đếm request thật, không nhầm gate
- a0263bdb: 7 unit fixtures parser

## 3. Hợp đồng một log và nơi đọc

Đều ghi bằng OMCLogWrite đang có vào OmniCar.log, không tạo log riêng. Marker chung [hl8diag] eye=... ev=..., đồng hồ/PID từ logger. Giữa các process dùng dấu thời gian, bundle, pair, touch id, hl8seq để đối chiếu. Prefix theo pref hl8.unifiedDiag (vắng=YES); tắt log không hoàn nguyên các thay đổi hành vi.

- eye=car ev=installed: xác định CarPlay PID có mã HL8.
- eye=touch ev=begin/dispatch: vị trí, pane hosted/native, inLogo, faded, opacity và liệu touch forwarded-to-orig hay swallowed-before-orig.
- eye=native-wake ev=gate: consume/forward, reason (hosted-pane, popup, controls-visible, no-live-pane...).
- eye=logo ev=callback/action: bằng chứng callback thật của nút; phân biệt chạm gần Logo, chạm nút và hành động mở layout panel.
- eye=pinch ev=formed/fs-gate/fs-request/fs-result/terminal/drop: nhận 2 ngón thật → điều kiện → adapter → kết quả; pair=...; fs-gate KHÔNG có nghĩa lệnh đã gửi. Marker [fs1] cũ vẫn chứa lý do controller từ chối.
- eye=layout ev=car-relayout/frame-send/frame-recv/frame-applied/frame-settled: kích thước pane, native scene expected, gói host với hl8seq và readback sau 350ms; so sánh theo bundle + seq + PID.
- eye=kb-app/kb-relay/kb-spring/kb-car: focus, mode-push/recv, publish-blocked, frame notification, UIWindow class/frame trong process thật, nhận định phạm vi owner.

**Giới hạn không được nói quá:** nếu iOS vẽ phím trong CarPlayTemplateUIHost hoặc process khác, scan từ SpringBoard/CarPlayApp/hosted-app không chứng minh pixel hay vị trí bàn phím của process đó. 0 window trong reader ngoại vi = BLIND, không phải ABSENT. Không tự inject thêm vào process Apple chưa kiểm để tránh hồi quy. Log không chứa chữ đã gõ, keypress, mật khẩu hay nội dung tìm kiếm.

## 4. File source và kiểm tra đã làm

- SCPTouchProbe.m: src/SplitScreenA và project/OmniCarSplitScreen trùng byte (chạm/pinch/wake/gate).
- SCPCarSplit.m: src/SplitScreenA và project/OmniCarSplitScreen cùng logic; chỉ hai import khác do cấu trúc cây.
- ABHostGeometry.m và ABInApp.m: src/AppBridgeB và project/OmniCarAppBridge trùng byte; đo SpringBoard/hosted app.
- Relayout: project/OmniCarSplitScreen/SCPCarSplit+Relayout.m là BUILD UNIT; thân phương thức mirror trong src/SplitScreenB/handoff/SCPCarSplit+Layout_A-owned.m. Handoff chỉ là đối chiếu, KHÔNG biên dịch để tránh duplicate selector.
- Source parity và commit compare đã FETCH kiểm trực tiếp sau ghi. Không thay YTZ, picker, keyboard-renderer, fullscreen engine hay Home icon bằng các commit log.

Script báo cáo: recovered-source/gpt-project-history/analyze_hl8_unified_log.py
7 tests: recovered-source/gpt-project-history/test_analyze_hl8_unified_log.py

Lệnh tại checkout (cwd repo root):
  python3 -m py_compile recovered-source/gpt-project-history/analyze_hl8_unified_log.py recovered-source/gpt-project-history/test_analyze_hl8_unified_log.py
  cd recovered-source/gpt-project-history
  python3 -m unittest -v test_analyze_hl8_unified_log
  cd ../..
  python3 recovered-source/gpt-project-history/analyze_hl8_unified_log.py logs/OmniCar.log logs/OmniCar.log.old

Thêm --car-pid <PID> để chọn phiên, --json để xuất máy đọc. Các test và py_compile CHƯA chạy được phía GPT: container curl đến raw.githubusercontent.com thất bại DNS (curl: 6). Không nhận test đã chạy. Không có Theos/iOS SDK local để compile dylib. Muse cần chạy compiler/tests trước đóng gói, không tuyên bố compile PASS trên code chỉ được kiểm tĩnh.

## 5. Một DEB, một phiên xe: checklist

Muse tích hợp từng hunk từ branch lên main mới nhất (giữ thay đổi mới của chính Muse), đọc workflow/job thật trước CI, build/ký MỘT DEB FAT. Version trong control phải KHÁC 1.0.3-hl7, ví dụ 1.0.3-hl8diag; workflow upload/verify tính đúng filename. Kiểm Package, Version, Architecture, SHA256, size, arm64+arm64e, CodeDirectory và marker trong cả hai lát. Chưa được phép merge/publish/deploy. Sau giao artifact, Nguyen thực hiện trong CÙNG một PID CarPlay:

1. Mở OmniCar từ Home tile, vào split YouTube hosted + Maps native, quay màn lúc dock bình thường.
2. Thử 2–3 cặp hai ngón ở ô YouTube, ô Maps và một cặp qua hai ô; kiểm CẢ hai ô bung/thu và dock ẩn/hiện. Log cần formed → fs-request → fs-result; nếu không thì báo lần đầu không qua cổng nào.
3. Chờ AutoHide mờ, chạm một điểm nội dung Maps, sau đó bấm nút Logo đang HIỆN; thử một lần trên YouTube. Phân biệt wake ở nội dung, callback logo và lỗi app nhận tap.
4. Mở tìm kiếm trong YouTube rồi Maps; khi phím đang hiện đổi tỷ lệ 50/50 → 67/33 → 33/67 → 50/50. Đo frame send/recv/settled và keyboard view; quay hình bàn phím để đối chiếu pixel.
5. Đóng split; lấy logs/OmniCar.log và .old (nếu xoay file) trên repo, không trộn với log HL7 PID 40787.

**Tiêu chí:** không build thêm nhiều vòng trước khi chạy analyzer và chốt lý do ở từng mắt. Build xanh chỉ cho phép thử xe; runtime marker có mặt chưa đủ DEVICE PASS; nếu parser ghi BLIND thì bổ sung reader đúng process, không đoán nguyên nhân.

## 6. Checkpoint / hoàn nguyên

Lệnh GitHub thực đã chạy: fetch_file + fetch branch/tree/commit/log + compare_commits; create_branch từ main 06fba113; create_blob/create_tree/create_commit/update_ref có expected_sha cho source, update_file có file SHA cho parser; đọc lại tip và các cặp file. Không có local checkout bền vững hoặc job nền do GPT khởi động. Chưa sửa main hoặc dispatch workflow.

Rollback: tắt chỉ logging theo hl8.unifiedDiag=NO; quay lại cách đọc ratio bằng bridgewake.carHostPinchPairToggle=NO; quay về recognizer app cũ bằng bridgewake.carHostPinch=NO. Nếu first-tap native gate gây hồi quy, revert đúng hunk commit 9ff2095; không force reset/merge main. Tiến trình tiếp: Muse compile/test/build một artifact, Nguyen test một phiên, GPT đọc analyzer/verdict/PID/video sau khi có dữ liệu; giữ tách biệt source-fixed / compiled / artifact-verified / runtime / device-pass.
