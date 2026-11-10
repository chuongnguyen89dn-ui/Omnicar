# HL8 — Một log hợp nhất cho bốn lỗi OmniCar (2026-11-10)

## Tình trạng đúng lúc checkpoint

**SOURCE-COMMITTED, chưa build DEB HL8, chưa chạy test tại xe, chưa compile Theos/Clang hay chạy unit test Python trong môi trường GPT.** Không tuyên bố sửa xong bốn triệu chứng. Đây là nhánh mã chẩn đoán và hai thay đổi thử sửa có thể rollback; việc kết án nguyên nhân cần log đúng PID của DEB được build và hình xe.

- Repository duy nhất: `chuongnguyen89dn-ui/Omnicar`, cây `recovered-source/`. Main tại lần kiểm gần nhất: `06fba1132bed45277d696a8f1114dabf70e53922`. Nhánh chuyên đề `feature/hl7-touch-lifecycle-gpt-20261110` từ main `06fba1132bed45277d696a8f1114dabf70e53922`.
- Commit mã đã kiểm: `3919c0b6` (đọc điểm cuối chạm trước cleanup), `9ff20959` (cổng nuốt native tap trước orig, fail-open), `da827f8b` (pair-at-Began dùng adapter fullscreen hiện có), `b040b398` và các commit tiếp sau (đo CarPlay, SpringBoard, app, layout, keyboard, logo), `b4e5945b` (script phân tích), `45701fa6` (phân biệt request thật với gate), `a0263bdb` (fixture tests), `21546dbb` (phân loại gate và lý do reject), `a47a1e2a` (cập nhật test).
- Không merge vào main; không chạy/dispatch CI, không build/ký, không publish Sileo, không gửi thông báo ngoài ứng dụng cho Muse.
- Nguồn đo trước khi sửa: `logs/OmniCar.log` upload commit `06fba113`, CarPlay HL7 PID 40787 (12:22–12:28), SpringBoard 40749, YouTube 40799, TikTok 40796. HL7: `[car-pinch] pair` 17 nhưng request 0; 16/17 cặp không ghi Moved, cặp còn lại chỉ một ngón có 1 Moved; Logo hitParent đã nằm góc trên-phải nhưng tap native còn lọt ứng dụng; publisher bàn phím hosted `native-locked`, `drawnKeyboard=0`; kích thước scene đã thay nhưng bàn phím không theo tỉ lệ. Đây là quan sát HL7, KHÔNG được gộp với PID HL8 chưa tồn tại.

## Mục tiêu và phạm vi

Yêu cầu của Nguyen: **thay các vòng sửa đoán mò bằng một log OmniCar có thể kết luận nguyên nhân** cho (1) pinch 2 ngón bung/thu **TOÀN BỘ SPLIT** + ẩn/hiện dock (không phải video YouTube), (2) Logo/AutoHide wake và đường sở hữu chạm native, (3) keyboard của app không hỗ trợ CarPlay, (4) bàn phím khi thay đổi tỷ lệ. Không thay YTZ, native feed, picker, scene sustain, geometry khác, controller fullscreen đã có. Muse chỉ tích hợp và build/ký một DEB nếu được giao triển khai.

## Instrumentation thực tế và file/hunk

Tất cả marker có tiền tố `[hl8diag]`, cùng OMCLogWrite/OmniCar.log sẵn có (không tạo file log khác và không ghi phím, nội dung tìm kiếm, text người dùng). `hl8.unifiedDiag` mặc định YES, có thể tắt qua pref nếu gặp tải log; trạng thái native keyboard/drawn KHÔNG thay đổi trong đợt instrumentation.

| Nơi | Hai file/cây | Marker + thông tin |
|---|---|---|
| CarPlay touch/pinch/wake | `src/SplitScreenA/SCPTouchProbe.m` ↔ `project/OmniCarSplitScreen/SCPTouchProbe.m` | touch begin + vị trí, pane, faded, vùng Logo + dispatch forwarded/swallowed; native-wake gate accept/reject kèm reason; pinch pair ID, tọa độ ban đầu, veto, fs-gate, **fs-request riêng**, callback applied/frame, terminal movement; kb-car thông báo và scan CarPlayApp |
| CarPlay Logo/bridge | `src/SplitScreenA/SCPCarSplit.m` ↔ `project/OmniCarSplitScreen/SCPCarSplit.m` | logo callback/action vs tap vùng Logo; frame-send seq/bundle/rect/scene expected, không đổi geometry |
| CarPlay layout | `src/SplitScreenB/handoff/SCPCarSplit+Layout_A-owned.m` ↔ `project/OmniCarSplitScreen/SCPCarSplit+Relayout.m` | car-relayout frame các ô, sceneSize, scan CarPlay keyboard; **hai file không byte-identical do file src có thêm method khác — chỉ hunk relayout mới phải đối chiếu** |
| SpringBoard | `src/AppBridgeB/ABHostGeometry.m` ↔ `project/OmniCarAppBridge/ABHostGeometry.m` | kb mode push, Darwin dispatch, window/notification scope SpringBoard; frame-recv/ -applied/-settled seq với owner readback sau ~350 ms |
| Hosted apps | `src/AppBridgeB/ABInApp.m` ↔ `project/OmniCarAppBridge/ABInApp.m` | focus-become/resign, app/keyboard window geometry, mode-recv, publish-allowed/blocked native-locked; không log text |

**Đã kiểm Github blobs tại HEAD trước checkpoint:** 4 cặp trùng byte (TouchProbe, ABHostGeometry, ABInApp; riêng SCPCarSplit có đúng 2 dòng include khác giữa cây), layout method có hunk đo tại cả 2 cây và không copy file src đè project.

## Script và phép kiểm

- Script mới: `recovered-source/gpt-project-history/analyze_hl8_unified_log.py`.
- Unit test fixture: `recovered-source/gpt-project-history/test_analyze_hl8_unified_log.py` (**9 test được viết nhưng CHƯA chạy Python trong lượt này**). Test gồm BLIND, phân biệt gate/request, phản hồi adapter, PID CarPlay khác nhau, native wake forward, lý do gate, keyboard native gate, layout sender/receiver/settled. Đã sửa fixture theo verdict mới.
- Lệnh cần chạy trên môi trường có checkout (không bịa là đã chạy): `cd recovered-source/gpt-project-history && python3 -m unittest -v test_analyze_hl8_unified_log.py`.
- Sau khi có log HL8: `cd recovered-source/gpt-project-history && python3 analyze_hl8_unified_log.py --json ../../logs/OmniCar.log ../../logs/OmniCar.log.old`. Thêm `--car-pid <PID>` để cố định incarnation khi cần. Script dedup dòng log.old trùng, phân tích theo PID CarPlay và cửa sổ thời gian các peer, **không** đồng nhất BLIND với ABSENT.
- Thực tế dùng GitHub connector (`fetch_file`, `fetch`, `compare_commits`, `create_branch`, `create_blob`, `create_tree`, `create_commit`, `update_ref`, `update_file`) để sửa và kiểm hunk. Thử `curl` raw.githubusercontent.com qua container thất bại `Could not resolve host`; không có Theos/iOS SDK hoặc checkout đầy đủ tại container trong lượt này; vì vậy không báo static QA thay build hay unit test xanh.

## Đo thế nào để kết án trong MỘT lần thử xe

1. Kiểm control Version **phải khác HL7**, ví dụ `1.0.3-hl8diag`; artifact DEB 1 file, SHA256/architecture, marker xuất hiện ở cả arm64/arm64e. Mã có marker không đồng nghĩa nhánh runtime đã chạy.
2. Cài, restart/khởi tạo tiến trình và chụp 1 phiên kiểm khoảng vài phút: pinch bung/thu toàn split và dock; AutoHide → tap native vị trí Logo/POI; chọn text YouTube và một app không có CarPlay; kéo divider 50/50→67/33→33/67 khi keyboard đang hiện. Video ngắn để chốt pixels với đúng thời gian.
3. Khi lỗi, truy theo một trace/cùng PID: `eye=pinch formed→fs-gate→fs-request→fs-result` (reject nêu reason); `eye=touch begin→native-wake gate→dispatch→logo callback/action`; `eye=kb-app focus→mode/publish→kb-spring Darwin→window`; `eye=layout frame-send→frame-recv→applied→settled`. Nếu mắt nhận không ghi log, phân biệt `BLIND`, `not registered`, `missing delivery` theo bằng chứng runtime, không vội kết án.
4. Chỉ kết luận DEVICE PASS sau cả log **và** quan sát xe; log CarPlay/SpringBoard không chứng minh pixel bàn phím trong CarPlayTemplateUIHost, và callback fullscreen applied=1 chưa chứng minh dock đã ẩn về mặt hình.

## Điểm nối/hoàn nguyên

- Sửa thử logic pinch: pair-at-Began một lần/cặp, dùng `SCPPinchController.shared.adapter`; pref `bridgewake.carHostPinchPairToggle=NO` trả về thuật toán dựa chuyển động, `bridgewake.carHostPinch=NO` quay về đường app legacy. Đây là TOGGLE toàn split theo cặp, cần xác nhận UX bung/thu thực tế chứ chưa chứng minh cử chỉ hướng pinch-in/pinch-out.
- Native wake gate chạy trước `UIApplication sendEvent:` chỉ khi controls faded + pane native + nguồn chạm hợp lệ, các đường khác fail-open. Có rủi ro UIKit touch delivery qua đường khác/hit-test; chú ý counter false-swallow và Home corner.
- Hoàn nguyên riêng instrumentation bằng revert các commit `diag(hl8)` khi tích hợp; giữ baseline HL7, không force main. Không sửa mô-đun Muse chỉ để làm log.
- Bước tiếp theo: (a) chạy test syntax/fixtures trên máy build có checkout, (b) kiểm hunk source/project và compile 2 module; (c) Muse tích hợp/build/ký **một** HL8 DEB sau khi kiểm workflow/job để không chạy CI trùng; (d) Nguyen thử một phiên, upload log cùng video và hash; (e) GPT chạy analyzer, chốt nguyên nhân từng mắt rồi sửa theo bằng chứng. **Không tự tạo/khởi chạy job**.


## Kiểm tra hiện trạng DEB và CI — 2026-11-10 13:34 ICT

- **HL8 vẫn CHƯA CÓ DEB.** GitHub Actions `GET /repos/chuongnguyen89dn-ui/Omnicar/actions/runs?per_page=30` trả về run mới nhất `42759723768`, workflow `build-fat-macos`, branch `ci-fat-test`, HEAD `5e7e301e2bcc79b23f6f750e31f2917d3ba2d9cc`, chạy 2026-11-10 05:03:47–05:07:45 UTC, kết quả SUCCESS. Không có job `in_progress` tại lần kiểm (`total_count=0`).
- Job `129642317955` có log đóng gói `com.anlai.omnicar_1.0.3-hl7_iphoneos-arm64.deb` (1,263,168 bytes), xác nhận FAT arm64 + arm64e trên các component, upload artifact `omnicar-fat-deb` ID `13736992542` (ZIP 1,263,717 bytes), URL https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/42759723768/artifacts/13736992542. **Đây là HL7, không phải HL8; không dùng để nghiệm thu HL8.** SHA256 `d71f77ae...` được Actions ghi cho ZIP, KHÔNG phải hash DEB.
- Docs HL8 commit `4b3dfdaf7090b989549db624b75a6204fd1e7885` có timestamp 2026-11-10 06:17:44 UTC, **muộn hơn** build HL7; file checkpoint còn ghi SOURCE-COMMITTED, chưa compile/CI/DEB; không có chứng cứ build HL8. Chưa dispatch job, chưa tải artifact để kiểm hash DEB, không có test xe.
- **Điểm tiếp tục:** hợp nhất branch HL8 đã source-commit vào staging build mới theo hunk, chạy fixture/compile, bump control Version khác HL7 (ví dụ `1.0.3-hl8diag`), dispatch một lần trên branch CI đúng hợp đồng, xác minh DEB cuối (file/hash/version/FAT/marker), rồi gửi Nguyen. Không chọn nhầm artifact HL7 vừa phát hiện; không phát hành Sileo.
