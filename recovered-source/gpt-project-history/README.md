# LỊCH SỬ DỰ ÁN GPT — OmniCar mã nguồn

## Checkpoint mới nhất — Home launcher nguồn đã thi công (2026-11-09)
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
