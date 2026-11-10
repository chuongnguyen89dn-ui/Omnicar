# LỊCH SỬ DỰ ÁN GPT — OmniCar mã nguồn

## 2026-11-10 — HL11: native keyboard repaired from DuoFace source; one integrated build
- **Đã sửa source:** `ABInApp.m` app-side keyboard native in YouTube/TikTok: tìm `UIRemoteKeyboardWindow` trong chính process theo DuoFace QA179–181, căn vào key window của app, retry có giới hạn, restore khi rời session, đo theo PID mà không log chữ gõ. Commit `faa7502`, `b77e4b4`. Hai cây `src/project` cùng byte.
- **Một DEB tích hợp:** nền HL9 Logo + HL10 picker same-window + HL11 keyboard, Version `1.0.3-hl11nativekb`; CI branch `ci-fat-test` tip `5f7d4a0`, [run 42781775810](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/42781775810) đã khởi động. **Chưa DEVICE PASS** cho keyboard/native Logo/picker; pinch HL8 giữ nguyên. Không trộn build trước.
- Bằng chứng DuoFace/OmniCar, hunk, đường hoàn nguyên và phép thử: [HL11_DUOFACE_KEYBOARD_INTEGRATION_20261110.md](HL11_DUOFACE_KEYBOARD_INTEGRATION_20261110.md). Không tự merge/publish.

## 2026-11-10 — HL10 SOURCE-COMMITTED: picker/scene same-window; keyboard native pending
- **Đã sửa source** trên nhánh `feature/hl10-surface-owner-gpt-20261110` từ HL9 CI `c5a437f`: `1f7ee4a` đưa picker và touch shield vào chung UIWindow của split thay vì cửa sổ phụ cấp 1065 khi có pane live; `42c9bb3` giữ mặt sheet trong suốt cả khi đè pane native, đúng hệ tọa độ; `4e35190` stage Version `1.0.3-hl10surface`, CI kiểm markers để tránh dùng DEB cũ. **Không build, không device pass; không đổi pinch**. [Checkpoint và đường rollback](HL10_PICKER_SAME_WINDOW_20261110.md).
- **Vẫn mở:** Logo trên app CarPlay native chạm vào app (HL8 chứng minh, HL9 mới BUILD PASS chưa xe), keyboard **CarPlay hệ thống** ở app không hỗ trợ bị native-lock + không có pixel (không tự bật custom `ABKeyboard`), và mất hình khi đổi app phải xác minh bằng video/test HL10. Không tự coi `hostStructPresent=1` là có hình. Không phát hành Sileo.

## 2026-11-10 — HL9 SOURCE-COMMITTED: Logo native sau fullscreen, pinch HL8 giữ nguyên
- Nguyen báo thử HL8: pinch **33/33 request/applied** (17 expand, 16 restore) đã hoạt động; Logo trên native Maps/Music/Calendar lọt chạm xuống app và YouTube/TikTok không có keyboard. Log mới upload `8b1f4b0`, CarPlay PID `41247` chạm đúng Logo `inLogo=1` nhưng `hidden=1`/forward; nguồn fullscreen assert hidden không hoàn nguyên. 
- GPT trực tiếp sửa phần **Logo**, hai commit source `cc3269b` và `6833299`, nhánh `feature/hl9-logo-native-fs-gpt-20261110` từ HL8 CI `b3da0d5`, 4 file src/project: restore `homeButton.hidden` theo nút sau fullscreen, định tuyến duy nhất single Began đúng 44×44 Logo native tới controller sẵn có, chặn mirror, giữ nguyên pinch. Chưa DEVICE PASS. Điểm nối/từng hunk/rollback ở [HL9_NATIVE_LOGO_FS_RESTORE_20261110.md](HL9_NATIVE_LOGO_FS_RESTORE_20261110.md).
- Keyboard giữ nguyên chính sách **native-only HL3**; nguồn YTZ5 do Muse phụ trách; log xác nhận responder focus 5 lần, native mode lock 17, show publish-blocked 10; không tự bật panel vẽ thay bàn phím hệ thống mà người dùng yêu cầu. Chờ test chủ thể trình bày ở CarPlayTemplateUIHost hoặc quyết định fallback tường minh.

## 2026-11-10 — GPT SOURCE-COMMITTED: HL6 Logo/Wake và pinch fullscreen TOÀN BỘ OmniCar
- Nguyen giao GPT tự sửa Logo, Wake, pinch (đổi phân công ba mục trước Muse); Muse chỉ tích hợp và build/ký một DEB. **Pinch nghĩa là bung/thu cả split + ẩn/hiện dock, không phải zoom video YouTube.**
- Hồ sơ: [HL6_GPT_SOURCE_FIX_LOGO_WAKE_FULLSPLIT_PINCH_20261110.md](HL6_GPT_SOURCE_FIX_LOGO_WAKE_FULLSPLIT_PINCH_20261110.md); nhánh code feature/hl6-logo-wake-gpt-20261110, base main 817bf872, ba commit 58539895 -> 0581d232 -> 234c5207, 10 path src/project, ahead=3/behind=0.
- Log HL6 cũ PID 40220/40229 có marker mới; source patch mới **CHƯA build, CHƯA CI, CHƯA test xe**. Không merge main hay phát hành. Bắt buộc bump control Version cho DEB vòng tới.


## Kiểm tra trực tiếp hai log HL5 — 2026-11-10
- **Đã đọc log gốc và tách đúng 2 phiên HL5 theo PID/time:** [HL5_TWO_LOGS_GPT_REVIEW_20261110.md](HL5_TWO_LOGS_GPT_REVIEW_20261110.md). Nguồn 2 blob ở `logs/OmniCar.log.old` + `logs/OmniCar.log`, upload `d94d6c9`. Kết quả 21/21 nuốt có ACK app, 0 timeout; act 133/133; feed 454/454; YouTube pinch A 2/2 (bung+thu), B 0 toggle (186 probe B đều 1 Began). P0: logo split tạo thoáng rồi bị dock placement retire, guard `transition-250ms` gây lọt chạm sớm có mẫu, reporter không revoke khi đổi A→B. Picker clear-face 4/4 nhưng close-done slot=-1 4/4 do ghim slot quá muộn. Home grid 6/6 route; Home hệ thống là đường khác. Native keyboard/video pixel chưa có log đủ kết án. GPT chỉ rà log/source, không build/test/sửa source Muse.

## Phán quyết mới nhất — HL4 → HL5 (2026-11-10)
- **Kết quả đối chiếu trực tiếp log HL4 + source và toa xử lý cho Muse:** [HL4_TO_HL5_VERDICT_20261110.md](HL4_TO_HL5_VERDICT_20261110.md). Pinch TikTok 22/22 (11 bung + 11 thu), nuốt 4, picker sheet effect là vật che ưu tiên sửa, logo trong split chết do cổng grid-only chặn trước placement, kbstate reporter cần phản hồi xác nhận assignment độc lập kb-known/STATE last-value, không rút ngắn timeout mù; act bad-hash sau teardown 184 s, ACK timeout 1 ca chưa rõ điểm nhận. Native pinch tách giai đoạn. Chưa sửa source Muse, chưa build/CI/xe ở lượt GPT; verdict là log/source, không tự gọi device pass.

## Phán quyết mới nhất — log hl3 → sửa hl4 (2026-11-10)
- **Đối chiếu trực tiếp hồ sơ/log/source, work order cho Muse:** [HL3_HL4_L1_L8_RULING_20261110.md](HL3_HL4_L1_L8_RULING_20261110.md). L1: dedup `bwHandledSeq[slot]` không reset theo gen khi re-host, khớp 7/7 ACK timeout; đề nghị reset theo gen trước đóng gói hl4. L2: ca 123 ms khớp guard transition 250 ms; gap seq toàn owner không phải bằng chứng mất state. L3/L4: `dir=0` đã SOURCE-COMMITTED nhưng còn cần test xe và rà OFF. L5/L6: measure3 đã bổ sung, cancel còn thiếu quan sát hậu animation. L7: silence 5 s không chứng minh teardown. L8: weather NO-DATA. GPT chỉ phán/quyết định và lưu hồ sơ; không sửa mã Muse, không build/CI hay xác nhận xe.

## Checkpoint hiện hành — đã đọc log xe YTZ5HL1 (2026-11-09)
- **Đã kiểm log xe YTZ5HL1 ngày 09/11 (blob GitHub):** [YTZ5HL1_LOG_REVIEW_20261109.md](YTZ5HL1_LOG_REVIEW_20261109.md). Nguồn commit upload `5e745bc`, hai phần `logs/OmniCar.log.old` (9.205 dòng) và `logs/OmniCar.log` (5.113 dòng). Theo PID: Home 11/11 callback→panel; picker hasContent=1 ×2 nhưng xe vẫn che hình; native keyboard 75 ACTIVE và 148 emit ACTIVE nhưng **không xuất hiện trên màn xe**; Gate 3 4/17 wouldSwallow, ENFORCE chưa bật; pm=0 trên PID có Home, pinch chưa test; AutoHide fade/reveal có log. Hồ sơ ghi điểm nối, khuyến nghị có điều kiện, ranh giới chứng cứ; GPT chưa đổi mã/CI ở vòng kiểm log này.

## Checkpoint mới nhất — Home launcher nguồn đã thi công (2026-11-09)
- **Phán quyết YTZ5HL1/Gate 3/Pinch/Keyboard/Picker (2026-11-09):** [YTZ5HL1_GATE3_PINCH_RULING_20261109.md](YTZ5HL1_GATE3_PINCH_RULING_20261109.md) — source/IPC/gesture arbitration, năm câu trả lời cho Muse, ranh giới test xe và đường sửa. Chốt thiết kế, **chưa thi công mã Muse/chưa DEB mới**. Bản ytz5hl1 CI 42622552103 đã thành công theo hồ sơ Muse; Nguyen báo Home tile/tap đạt, native keyboard và picker thất bại ở mức nhìn màn hình, log phiên chờ đối chiếu.

- **Quy tắc truy cập GitHub mới (Nguyen, 2026-11-09):** GPT chủ động đọc, đối chiếu và cập nhật hồ sơ/source trong phạm vi quyền đã cấp, **không hỏi lại quyền truy cập GitHub ở từng lượt**. Quy tắc này không cho phép tự merge code vào main, tự chạy CI/build/deploy/Sileo, xóa dữ liệu hoặc liên hệ Muse ngoài ứng dụng nếu chưa được giao. Xác nhận bắt buộc của nền tảng (nếu có) vẫn do nền tảng kiểm soát.

- **Quyền truy cập GitHub (chỉ thị mới 2026-11-09):** GPT chủ động truy cập GitHub đã kết nối để đọc, đối chiếu, sửa mã đúng nhánh được phân công và cập nhật checkpoint; không hỏi lại Nguyen về quyền truy cập mỗi lần. Không coi điều này là quyền tự merge main, dispatch CI, deploy, phát hành Sileo, xóa dữ liệu hay liên hệ Muse bên ngoài. Nếu nền tảng yêu cầu thao tác xác nhận kết nối, đó là cơ chế cấp quyền riêng.

- **Làm việc GitHub theo chỉ thị Nguyen 2026-11-09:** GPT chủ động truy cập GitHub đã kết nối để đọc/đối chiếu source, commit phần GPT trên nhánh thuộc phạm vi được giao và lưu/kiểm checkpoint; không hỏi xin phép truy cập lại mỗi lượt. Quyền này KHÔNG mở rộng thành tự merge vào main, dispatch CI, build/đóng gói giao xe, phát hành Sileo, xóa dữ liệu hoặc liên lạc Muse ngoài ứng dụng. Nếu nền tảng yêu cầu xác nhận kết nối ở cấp hệ thống thì cơ chế xác nhận thuộc nền tảng, không phải bước GPT tự xin lại.

- **Hồ sơ bàn giao và bằng chứng:** [HOME_LAUNCHER_HANDOVER.md](HOME_LAUNCHER_HANDOVER.md). Đây là hồ sơ chi tiết, có file/hunk, 4 commit, test và bước cho Muse; không tạo đầu mối thứ hai.
- Repo duy nhất `chuongnguyen89dn-ui/Omnicar`; cây `recovered-source/`. Nhánh code **đã xác minh tồn tại**: `feature/omnicar-home-launcher`, nền main `3e25499d62cb471e0aa468871535182eb7abaec8` (đã có YTZ5 `e6b50a4`), tip mã `050eddb0ada8be356dc61ccb27852dd5c837b97c`.
- **SOURCE-COMMITTED / STATIC-CHECK PASS**, 5 commit chỉ trên nhánh feature; chưa merge code main, chưa build Theos/ldid, chưa CI mới, chưa có DEB cuối hoặc device test. GitHub compare base..feature: ahead=5/behind=0, 14 file path đã đổi (trong đó 4 file mới là cặp src/project).
- Thành quả nguồn: đăng ký đúng `com.anlai.omnicar.app` không phụ thuộc `appBridgeApps`; synthetic `DBApplicationInfo` declaration; visibility own-icon; hook icon-tap `DBDashboardHomeViewController iconManager:launchIconForIconView:` ABI iOS16.7.16 `v32@0:8@16@24`, original pass-through cho mọi app khác; route vào **panel layout hiện hữu** trên `SCPCarSplit` (giữ dock, không mở Settings), log presence/model/cell/tap; hook đo close YTZ5. Chưa gọi là runtime/device PASS.
- Muse YTZ5 đã source-complete ở main; run CI 42615117251 hoàn tất trước phân công nhưng **không** lấy làm artifact bàn giao; DEB tổng hợp hoãn tới lúc Muse tích hợp nhánh GPT. **Cần làm tiếp:** Muse ghép hunk với YTZ5 và đồng bộ build staging `src → project`, biên dịch/kiểm định rồi build/ký **một DEB**; Nguyen test xe theo kịch bản trong handover. Không giao DEB từ phía GPT.
- **Cảnh báo có căn cứ:** `src/SplitScreenC/SCPHomeApply.m` YTZ5 khác bản `project/OmniCarSplitScreen/SCPHomeApply.m` trên main; không copy bản project cũ đè src. GPT không chỉnh phần lõi YTZ5/AutoHide/keyboard/picker/scene. Không có checkout local được xác nhận; gọi thử GitHub qua shell bị lỗi DNS, các thao tác repo thực tế dùng GitHub connector.

## Hồ sơ nền trước khi triển khai — 2026-11-09 (giữ để truy lịch sử)
- Repo: chuongnguyen89dn-ui/Omnicar. Dự án thi công: recovered-source/.
- Đầu mối chung hiện có: recovered-source/TIEP_TUC_DU_AN.md. File này là hồ sơ CHUYÊN ĐỀ GPT, không thay thế đầu mối chung.
- HEAD đã kiểm trước khi ghi hồ sơ: 38735c5bef6dc22ca9cb11f4e894725ce494be41.
- Phân công mới của Nguyen: GPT trực tiếp triển khai icon của CHÍNH OmniCar trên lưới CarPlay Home; Muse tiếp tục YTZ5 và là đầu mối tích hợp/build/ký một DEB tổng hợp.
- Nhánh dự kiến cho code: feature/omnicar-home-launcher. CHƯA TẠO. Không ghi rằng code hoặc build đã bắt đầu.
- Chưa sửa source, chưa build, chưa khởi động CI trong phần việc Home launcher. Không có thay đổi code chưa commit do GPT tạo trong nhiệm vụ này.
- Các đường dẫn VM ghi trong hồ sơ Muse không phải môi trường GPT đã xác minh.

## Mục tiêu và phạm vi
1. Icon OmniCar có trên lưới CarPlay Home, không chỉ là nút UIButton trên dock.
2. Chạm icon mở giao diện bố cục/split hiện có; không mở nhầm app cài đặt iPhone hoặc tạo controller split độc lập.
3. Giữ nút dock; nghiệm thu icon sau đóng split lúc hiện/mờ, đổi app, ngắt–nối và khởi động lại process.
4. Chỉ sửa trong recovered-source/; đọc logs/ của repo để lấy bằng chứng được phép. Không sửa phần dự án gốc ngoài phạm vi.
5. Không tự sửa AutoHide, bàn phím, YTZ, native feed hoặc các hạng mục Muse đang làm.

## Dữ kiện đã kiểm trực tiếp
- SCPAppIcons.m: SCPChosenPhoneApps lấy appBridgeApps; SCPAddChosenAppsToLibrary thêm proxy; SCPInjectDeclarationIfChosen ghép CRCarPlayAppDeclaration cho app được chọn.
- SCPHooks.m: hook _newApplicationLibrary / _loadFromProxy:; các hook launch chuyển app injected sang AppBridge.
- SCPCarSplit.m: nút launcher hiện tại là UIButton gắn bằng addSubview, homeButtonTappedUnsafe mở panel bố cục.
- Chưa chứng minh có đường tự đăng ký riêng chính com.anlai.omnicar.app trên Home. Đưa bundle vào AppBridge không tự chứng minh đúng hành động launch.
- Log đã đọc ở logs/OmniCar.log và logs/OmniCar.log.old tại HEAD trên; cuối log hiện tại 2026-11-09 17:44:31.969. Đây là dữ kiện nền, không phải nghiệm thu tính năng Home mới.

## Phối hợp và tích hợp
- Code ở nhánh riêng; checkpoint đầu mối này trên main theo yêu cầu người dùng.
- Không ghi đè file Muse. Nếu chung file, bàn giao từng hunk/commit và đọc lại phiên bản mới trước tích hợp.
- Đồng bộ src/project theo cấu trúc build thật.
- Muse ghép commit, build/ký bản cuối. GPT không tự publish/Sileo/merge code khi chưa được giao.
- Không tự gửi tin nhắn bên ngoài cho Muse. Bàn giao qua repo và người dùng.

## Quyết định YTZ5 được báo ban đầu (trạng thái thi công mới xem checkpoint trên)
- Muse báo đã lập CHANGE_MAP_YTZ5.md, chưa build ở thời điểm báo.
- GPT đã duyệt thiết kế vận chuyển trạng thái phiên nhập liệu app→owner có assignment/gen/session/seq; không được coi first-responder là chứng minh phím hiện trên xe.
- UNKNOWN không được biến thành INACTIVE; reset cùng-bundle/cùng-slot; chống renewal làm tươi giả nguồn cũ.
- Tắt panel cũ phải vô hiệu nguồn panel, không phát INACTIVE giả cho phiên nhập liệu còn sống.
- AutoHide theo bảng assignment; cleanup không phá suspend của chế độ hosted-solo đích.
- Pinch mặc định OFF; icon instrument model/dock chưa phải cell; không thêm event-1 vô điều kiện ở goHome=NO.
Các mục này thuộc Muse; phải đọc hồ sơ mới của Muse để biết trạng thái hiện hành.

## Bước tiếp theo dự kiến ban đầu (đã được thay thế bởi checkpoint ở trên)
1. Đọc file này, hướng dẫn GPT và TIEP_TUC_DU_AN.md bản mới nhất.
2. Kiểm tra main/nhánh, commit và job đang chạy trước khi tạo nhánh feature/omnicar-home-launcher.
3. Đọc app bundle/Info.plist, launcher và hooks Home/launch; xác định danh tính và hợp đồng launch riêng cho icon OmniCar.
4. Lập bảng file/hunk thuộc GPT, điểm chung với Muse; triển khai ở nhánh riêng sau khi đủ căn cứ.
5. Kiểm tại chỗ, bàn giao commit và kịch bản xe. Chỉ chấm DEVICE PASS khi có test xe đúng artifact.

## Nhật ký
- 2026-11-09: Nguyen xác nhận phạm vi mã nguồn là URL repo/main/recovered-source, không phải một repo khác. Sửa nhầm lẫn trước đó: cùng repo nhưng khác cây thư mục.
- 2026-11-09: Nguyen yêu cầu tạo mục lịch sử GPT trong recovered-source/ và lưu hướng dẫn đầy đủ trước khi thi công code.
- 2026-11-09: Đã đọc cây main và recovered-source/TIEP_TUC_DU_AN.md qua GitHub. Đầu mối chung tồn tại; tạo hồ sơ GPT chuyên đề, giữ nguyên lịch sử Muse.
- Các thao tác của checkpoint này dùng GitHub connector: fetch tree main recursive; fetch_file TIEP_TUC_DU_AN.md; create_file hai hồ sơ GPT; update_file thêm liên kết đầu mối; fetch_file đọc lại. Không chạy lệnh shell/build/job. Commit xác nhận nằm trong lịch sử GitHub của các file, không bịa ID trong nội dung trước khi tạo commit.

- 2026-11-09: Theo Nguyen, xóa file hướng dẫn ChatGPT đã lưu thừa khỏi repo; hướng dẫn Project do người dùng lưu trong ChatGPT. Giữ hồ sơ lịch sử GPT tại đây.
- Phối hợp build: Muse hoàn tất/commit YTZ5 và ghi HEAD + file chung; chưa dispatch build DEB tổng hợp. GPT làm Home launcher ở nhánh riêng dự kiến feature/omnicar-home-launcher (hiện chưa tạo, chưa code). Sau khi GPT bàn giao commit thật, Muse ghép vào nền YTZ5 ở nhánh tích hợp, xử lý hunk chung, đồng bộ src/project, kiểm tra và chỉ build một DEB cuối khi cả hai phần đã sẵn sàng. Không chép đè nguyên thư mục hoặc ghép hai DEB. Tên vòng/bản tích hợp chốt sau, không coi đây là artifact đã có.

- 2026-11-09 (checkpoint mã Home): GPT đọc trực tiếp main/Muse YTZ5, hồ sơ DuoFace QA135–146 và nguồn `recovered-source/`; commit source ở nhánh feature: `81e4b23` → `c4641f7` → `14404b2` → `1479711` → `050eddb`; so source và verify GitHub ref, không chạy build/CI. Hồ sơ chi tiết `HOME_LAUNCHER_HANDOVER.md` (main docs commit `bd51eed4aa304ad81b5db6ba87103fda8e284813`). Kết quả: source committed, runtime/car pending; bước tiếp Muse hợp nhất một DEB, Nguyen thử xe. Đường VM Muse không mặc định tồn tại ở GPT.

- 2026-11-09 (mở rộng cổng reentry Home): commit `050eddb0ada8be356dc61ccb27852dd5c837b97c` sửa đúng tình huống app-info **đã có** nhưng declaration **mới được bổ sung**: yêu cầu refresh icon model thay vì chỉ làm khi mới thêm proxy. Đã cập nhật và đọc lại `HOME_LAUNCHER_HANDOVER.md`. Trạng thái vẫn source-only, chưa build/chưa test xe.

- 2026-11-09 20:41 ICT: Nguyen xác nhận không cần hỏi lại quyền truy cập GitHub ở dự án OmniCar; chủ động truy cập và đối chiếu như luồng DuoFace, giữ nguyên giới hạn hành động nhạy cảm. Bản vá rút nút dock tùy biến ở nhánh `feature/omnicar-home-grid-only`, commit `39a42f2812c1b79d5dd425317ffb8a44eb1089aa` đã có; chưa build DEB mới. Handover đã cập nhật ở `HOME_LAUNCHER_HANDOVER.md`, commit hồ sơ `8fc27419aa08b923bacb1489abbd91191847a2c1`.

- 2026-11-09 (quy trình): Nguyen yêu cầu không xin phép lại khi dùng GitHub trong dự án, áp dụng quyền truy cập hiện có tương tự DuoFace. Việc loại nút OmniCar tùy biến trên dock hiện ở nhánh `feature/omnicar-home-grid-only`, commit `39a42f2812c1b79d5dd425317ffb8a44eb1089aa`, chưa có DEB mới hay test xe riêng cho thay đổi này.

- 2026-11-09: GPT đã tham vấn trực tiếp nguồn `integrate/ytz5-home-launcher` commit `8a2c7aa`: **pinch recognizer trong app hosted, `cancelsTouchesInView=YES`, `delaysTouchesBegan=NO`**, không overlay; SPLIT+HIDDEN wake ưu tiên, SPLIT+VISIBLE pinch-out, EXPANDED+HIDDEN pinch-in được ưu tiên (phải sửa conflict `BWGatePass`), hai chiều qua FS controller; Gate 3 chỉ GO theo cổng kiểm scoped hosted, không bật blanket mặc định khi thiếu log; keyboard DRAWN làm fallback mặc định bản sau; picker cần đọc `hasContent` và cover/sheet/shield. Bản quyết định có bằng chứng dòng source, kịch bản kiểm và log gaps ở [YTZ5HL1_GATE3_PINCH_RULING_20261109.md](YTZ5HL1_GATE3_PINCH_RULING_20261109.md). Không sửa src/module Muse.

- 2026-11-09 (review log upload): commit `5e745bc` đưa lên `logs/OmniCar.log.old` + `logs/OmniCar.log`; GPT tải lại qua GitHub fetch_blob theo SHA, đếm markers theo PID/gen, đối chiếu source tích hợp `8a2c7aa`. Đã lập báo cáo tại `YTZ5HL1_LOG_REVIEW_20261109.md` (docs commit `7b6e5d05a088ff64c5441273a71db4eebe48d8aa`). Đầu việc Muse và cổng test xe trong file; không có commit sửa source hoặc build từ GPT.
