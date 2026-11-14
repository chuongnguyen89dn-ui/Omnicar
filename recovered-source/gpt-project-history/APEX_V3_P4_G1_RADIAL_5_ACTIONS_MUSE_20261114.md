# DuoCar V3 · P4/G1 → Muse G2 · BẢN VẼ VÒNG TRÒN NĂM LỆNH THẬT
**Ngày chốt:** 2026-11-14 · **Tình trạng:** G1 DESIGN + CODE HANDOFF, CHƯA BUILD/CHƯA DEVICE PASS  
**Repo:** chuongnguyen89dn-ui/Omnicar · **nhánh:** feature/duocar-apex-ui-muse-20261114 · **source audited:** 19a619eb04a2960b9bdc3e622e2ebda370be9719  
**Phân vai:** GPT thiết kế & đặc tả; Muse thực hiện module/móc nối, compile thử phù hợp; Nguyen kiểm hình và kết quả DEB trên xe. Không tạo split engine thứ hai, không tự CI/DEB, merge, publish.

## A. Nguyên tắc sản phẩm CHỐT từ Nguyen (ưu tiên các yêu cầu muộn hơn)
1. Hai ảnh **IMG_8236.jpeg** và **IMG_8237.jpeg** do Nguyen đưa trong chat là **concept để thay đổi**, không phải ảnh màn hình DuoCar chạy thật. Tuyệt đối không lấy các nút tưởng tượng của ảnh đầu (HUD/Cài đặt/Bố cục/Ẩn điều khiển) thay cho các chức năng gốc.
2. Vòng tròn mới có **chính xác 5 sector 72°** quanh **logo D nghiêng tím GỐC**: **Đổi ứng dụng; Toàn màn; Cửa sổ nổi; Chạy nền; Tắt ứng dụng**. Chỉ đổi UI hiển thị; gọi action/scene owner có thật.
3. **Mọi sector áp dụng cùng thứ tự ACTION-FIRST**: bấm một sector → phía dưới vòng tròn hiện các thẻ **Ô 1 + app thực tế** / **Ô 2 + app thực tế** → người dùng chạm thẻ → thực thi cho đúng pane. Không tự thao tác ngay khi bấm sector; không có hai bản sao app.
4. Ô1 và Ô2 dùng **cùng màu/material**, mặt sheet cố định #100923 alpha 1.0, viền #DBB9FF, chọn #A16EFF; hai menu ở native/hosted đồng nhất. Ngoài popup vẫn thấy app chạy, không blank/đen/lộ logo, tương tác với nội dung không bị lớp vô hình chặn.
5. **Khi fullscreen thực sự, Home logo/vòng/Dock BỊ ẨN.** Trở về bằng **pinch-in** từ chính nội dung fullscreen; không yêu cầu bấm lại logo. Không được coi zoom ô (\`zoomedSlot\`) là fullscreen ẩn Dock (\`SCPFullscreenController\`), hai cơ chế khác nhau và có guard xung đột.
6. Chọn X không có thêm bước xác nhận: chọn thẻ app chính là quyết định đóng. **X phải gọi hàm tắt app, không phải chỉ chạy nền**. Các thao tác khác vẫn giữ semantics gốc.
7. Chỉ triển khai **giao diện chính** vòng/menu/picker và điểm nối bắt buộc. Không sửa Lề, bong bóng, nhiệt, bàn phím, autoHide/Wake, scene owner hoặc logic app bên thứ ba ngoài một điểm nối có phân tích và bằng chứng.

## B. Bộ bản vẽ kỹ thuật G1 (SOURCE VECTOR, không phải ảnh chạy xe)
- [RADIAL_WHEEL](APEX_V3_P4_G1_RADIAL_WHEEL_20261114.svg): mặt wheel 5 sector và trạng thái nhấn một lệnh/2 thẻ app. **D mark được tham chiếu từ file logo chính thức đang trong repo, không tự vẽ lại.**
- [5_FLOW_AND_TARGET_STATES](APEX_V3_P4_G1_RADIAL_5_FLOWS_20261114.svg): cả 5 luồng thao tác, caption kết quả và trạng thái chuẩn.
- [Bản ảnh concept đầu của Nguyen](https://github.com/chuongnguyen89dn-ui/Omnicar/issues/1#issuecomment-6879397423) chỉ là hướng hình thức; bản vector G1 này THAY thế nút bịa trong IMG_8236. Tên app trên SVG là **VÍ DỤ** để hiểu luồng; runtime phải lấy từ dữ liệu đang chạy.
- SVG viewBox là **lưới thiết kế minh hoạ**, KHÔNG phải pixel/PT thực của màn xe và KHÔNG phải screenshot device. Muse phải dựng UIView/CALayer thật; không phát hành SVG/tấm poster làm bitmap giả tương tác.

## C. Interaction contract bất biến

### C1. Nguồn mở & lifecycle
- Từ nút **logo DuoCar trong split** hoặc icon **DuoCar trên CarPlay Home/dock**: một tap → S1 wheel; dùng đúng singleton \`SCPCarSplit shared\`, giữ tap coalesce 0.65s; không mở app điện thoại/iPhone Settings.
- Từ tay nắm của pane native hay hosted: một tap mở S1 wheel, **không thay đổi double-tap handle = zoom**, pan/drag handle = di chuyển; target có thể được gợi ý nhưng action-first vẫn phải cho người dùng chọn thẻ. Các wheel cùng owner; mỗi lúc chỉ **một** instance.
- S0 CLOSED → S1 WHEEL_IDLE → S2 ACTION_SELECTED+TARGET_CARDS → S3 DISPATCHING hoặc PICKER → S4 CLOSED; tại bất kỳ S1/S2, chạm tâm D/chạm ngoài khu vực visible → S0, **không đóng hay chạy nền app**.
- Khi bố cục/slot/bundle đổi trong lúc wheel mở: re-resolve thẻ theo snapshot hiện hành; chỉ thực thi nếu [slot,bundle,scene] vẫn khớp. Không dùng \`focusedSlot\` cũ hoặc cell index sau reindex.
- Không trộm Home hệ thống Apple. Không che nội dung app bên ngoài vùng interactive wheel/target cards. Chỉ tạo hitbox cho sector, center và thẻ đang hiện.

### C2. Bảng năm hành động thực
| Sector | Sau khi chạm sector | Khi chọn Ô n | Existing handler cần tái sử dụng | Điều kiện / kết quả |
|---|---|---|---|---|
| Đổi ứng dụng | thẻ Ô1 / Ô2 | đi vào picker V3, chỉ đặt mục tiêu ô | \`showPickerForSlot:\` / \`openApp:slot:\` & kiểm pin \`slotIsPinned:\` | không chọn thẻ thì không thay app; picker có X huỷ; app mới chỉ mở khi \`Áp dụng\` |
| Toàn màn | thẻ Ô1 / Ô2 | fullscreen **đúng app đã chọn**; ẩn logo/Dock/vòng | thống nhất \`SCPFullscreenController\` + lựa chọn đúng pane, không tạo engine zoom #2 | **G2 BLOCKING GATE**: source \`runSoloForPane:\` chỉ \`toggleZoomForPane:\` khi chia 2 ô; FS1 hiện từ chối khi \`zoomedSlot\` khác nil. Muse phải chứng minh giao dịch đồng bộ mở + đóng + pinch-in, rollback, native/hosted trước khi bật nút này. Nếu chưa an toàn, hiển thị disabled cùng lý do, không giả thành fullscreen |
| Cửa sổ nổi | thẻ Ô1 / Ô2 | đưa app của thẻ đó ra một \`floatPane\`; nếu đã nổi, hoán đổi theo source | \`popOutPane:\` / \`floatDockBack\` / \`popOutBlockReason:\` | chỉ **một** cửa sổ nổi; ô nguồn bị giải phóng và phần còn lại có thể relayout; không vẽ hai bản sao app; native support chưa chứng minh, cần probe trước khi enable |
| Chạy nền | thẻ Ô1 / Ô2 | gỡ slot với \`background:YES\`, báo toast | \`runBackgroundForPane:\` → \`closeSlot:background:YES\` | app có thể chạy nền, **không gửi kill**; một pane còn lại có thể thành solo do \`afterPaneRemoved:\` |
| Tắt ứng dụng (X) | thẻ Ô1 / Ô2 | đóng ô và yêu cầu kết thúc app | \`runCloseForPane:\` → \`closeSlot:background:YES\` → \`killAppSoon:\` | có trì hoãn 0.6s, nếu app đã mở lại trong split thì hủy kill; nếu không, SpringBoard \`SCPKillAppBlock\` xử lý. **Không nhầm với Chạy nền.** |

### C3. Thẻ chọn đích / trường hợp đặc biệt
- Mỗi thẻ: chỉ số Ô; icon và \`localizedDisplayName\` thực của bundle trong \`self.slots\`; trạng thái enabled/disabled + lý do (pinned khi Đổi, không có app, không thể pop hoặc fullscreen chưa chứng minh). Màu và border giống hệt cho cả native và hosted.
- Hai ô: **2 thẻ** nằm dưới wheel như hình yêu cầu. Có 1 ô: một thẻ đúng; có 3 ô layout13/31: **3 thẻ cuộn/thu gọn**, không âm thầm bỏ Ô3; \`floatPane\` đang tồn tại: một thẻ **Nổi · app** để lệnh hiện hữu có thể đưa app về chia qua \`floatDockBack\` (subject to popup path). Empty slot là disabled, không nhân bản app.
- Đối với **Đổi ứng dụng**, bấm thẻ đi vào picker riêng theo hình 2, dùng segmented Ô1/Ô2 tương ứng nếu đủ chỗ; active card + footer \`Áp dụng\`, X cancel; không có bí mật hoặc UI giả. \`Áp dụng\` phải thực thi đúng \`openApp:slot:\`; cần adapter giữ selection pending vì source gốc \`pickerAppTapped:\` mở ngay.
- \`Toàn màn\` khi đã EXPANDED: wheel **không tồn tại**; pinch-in được ưu tiên để trở về. Nếu user đã vào riêng zoom nội bộ \`zoomedSlot\`, nhãn \`Chia màn\` của bar cũ vẫn là cơ chế riêng; Muse phải mô tả guard/tương tác, không tạo lối thoát phụ thuộc logo đang ẩn.
- Không tự thêm các nút nhạc/play, HUD hay Settings từ tấm ảnh AI. Thanh dock Apple/native còn nguyên, không tạo giả một media dock mới.
- Kiểm tra thao tác khi ô đã đổi vị trí, reconnect, AutoHide, closing khi picker hiện; tránh view tồn dư/window trên app content.

## D. Hình học & theme: các thông số được phép và phải đo
- **Hình học gốc không đổi**: handle native **34×12 pt**, hosted visual **34×12** trong hit **44×24**; bar cũ **259×52 pt** (đây là kích thước BAR, KHÔNG phải trần đường kính wheel); app-area/slot/scene/resize/keyplane không bị đụng. Sheet picker gốc có \`sheetW=cols×62+20\`, outer thêm 150, radius 24, app pitch 62×56, icon 38. G0 còn 5 UNKNOWN; không tự lấp bằng số đoán.
- **Wheel mới là popup transient theo \`tabParent\`/safe display area**, không thay frame pane. Quy tắc đề xuất G1, Muse phải đo lại trên màn thật:
  - \`available = appArea ∩ window.safeArea\` TRỪ dock và chrome hiện hữu; chọn tâm cục bộ an toàn, không đè hệ thống;
  - S1: \`diameter ≤ min(0.83 * available.height, 0.60 * available.width, 380pt)\`;
  - S2 có thẻ phía dưới: \`diameter ≤ min(0.66 * available.height, 0.60 * available.width, 360pt)\`; **để chỗ cho thẻ**, chiều cao thẻ target 48–60pt + gap 8–12pt, tối thiểu hitbox 44×44pt;
  - bán kính lõi tâm khoảng 0.34R; năm sector mỗi góc **72°**, khe 2°; mọi vùng chạm thực phải đạt **≥44×44pt hữu hiệu** và không lấn nhau; d nhỏ thì giảm nhãn/icon, KHÔNG tăng view vượt safe area. Đây là **công thức thiết kế đề xuất, không phải bằng chứng hình học DEB**.
- Token chung: ROOT \`#070416\`, INNER SHEET \`#100923\` alpha1, FACE \`#1B1138\`, RAISED \`#28194D\`, ACTIVE \`#A16EFF\`, RIM \`#DBB9FF\`, PRIMARY \`#F5F0FF\`, SECONDARY \`#C7B8E4\`. Nút X dùng màu cảnh báo UI #FF4757; nhiệt đỏ **#FF0610** nằm ngoài scope, không sửa.
- Logo D gốc: runtime lấy trực tiếp **asset hiện có** (\`project/OmniCarPrefs/Resources/logo@3x.png\` là một bản nguồn tham chiếu đã có; Muse kiểm xem asset/runtime đúng logo đã Nguyen chốt). **Không vẽ/đổi lại logo D**. SVG dùng \`<image href>\` tham chiếu asset để không sinh glyph giả.
- Mặt picker Ô1=Ô2 và native=hosted pixel token đồng nhất; Không lấy màu qua app video phía dưới bằng blur làm lệch màu.

## E. Hợp đồng kỹ thuật/source, đề xuất module để Muse triển khai
| Điểm nối thực ở P3 | Trách nhiệm G2 / điều cấm |
|---|---|
| \`project/OmniCarSplitScreen/SCPCarSplit.m:3348–3394\` \`homeButtonTappedUnsafe\` và \`SCPHomeLauncher.m:466–505\` | route đến **cùng** presenter wheel, giữ tap-gate, AutoHide activity và fallback Home; không mở iPhone Settings hay tạo controller split khác |
| \`SCPCarSplit+Zoom.m:63\` native \`handleTapped:\`; \`SCPCarSplit.m:2720+\` hosted \`bridgeHandleTapped:\` | mở wheel cho pane nguồn; **double-tap zoom/pan giữ nguyên**; một owner duy nhất tránh bar cũ + wheel cùng bật |
| \`SCPCarSplit+Chrome.m:204–213\` và \`AppBridge/ABHostBMethods.m:1175–1192\` | 5 lệnh gốc là source-of-truth; **không để hai bộ bar nhận hit song song**. Hosted vẫn dùng bridge events đã có, không tạo IPC/hook mới nếu không bắt buộc |
| \`AppBridge/ABHostLaunch.m:335–350\` → \`SCPCarSplit.m:2699–2715\` | map \`replace,full,pop,bg,close\` về một dispatcher owner theo slot/bundle; validate app đang sống trước action |
| \`SCPCarSplit+Panel.m:paneChoose:\`; \`SCPCarSplit+Picker.m:buildPickerSheetForPane:/pickerAppTapped:\` | Giao diện picker mới phải thật (thẻ+segmented+filter X/\`Áp dụng\`) nhưng giữ \`openApp:slot:\`, guards, pane slot, scene/keyboard; ĐỪNG tự đổi Picker windowLevel/HL49–HL51 để thử màu |
| \`SCPCarSplit.m:runSoloForPane:/runBackgroundForPane:/runCloseForPane:\`; \`SCPCarSplit+Zoom.m:popOutPane:\` | gọi lại hàm có sẵn, không chép code kill/pop/split; không nghĩ rằng đóng Ô1 xong Ô2 ở nguyên khung vì \`afterPaneRemoved\` có thể solo |
| \`SCPPinchController.m\`, \`SCPFullscreenController.m\` | thiết kế restore/transaction an toàn, **FS1 expand refuses zoomedSlot**; nếu cần thay guard, phải báo bằng chứng và hunk trước; không tự phá F/C contract |
| \`SCPCarSplit+Chrome.m:updatePopupShield\` / \`SCPCarSplit+Picker.m\` | proof stacking layer native vs hosted + pass-through, shield/tap ngoài/invalid window; đầu tiên làm **visibility proof** hai mode, không phán đoán |

Module đề nghị: \`SCPRadialControlView.{h,m}\` (chỉ vẽ 5 sector + animation), \`SCPRadialTargetStrip.{h,m}\` (thẻ đích/empty), \`SCPCarSplit+Radial.m\` (presenter + action→pane dispatcher, reload model). Quyền sở hữu ở \`SplitScreen\`, **không tạo popup/split engine mới ở AppBridge**. Tên chỉ là đề nghị; Muse đối chiếu Makefile, kiểm \`recovered-source/src\` gương tương ứng, báo hunk ở file chung. Không chạm classes khác khi không bắt buộc.

## F. Phân lô giao Muse, có cổng dừng
| Lô | Công việc cụ thể | Evidence / điều kiện qua |
|---|---|---|
| R0 (baseline) | Ghi branch/HEAD/local-dirty/job, G0 112 hàng, 5 unknown; đối chiếu thật window ownership, priority giữa native popup và AB hosted window | bảng điểm nối + điều kiện layer, không runtime patch |
| R1 (wheel thật) | Dựng native UIView/CAShapeLayer 5 sector + logo asset gốc + auto geometry + thẻ Ô1/2/3, trạng thái idle/pressed/selected/disabled, tap cancel/outside | source/test xác minh 5 hit sectors khác nhau, no image-only mockup, widget không che content |
| R2 (kết nối) | route Home/dock/handle native+hosted sang ONE presenter, 5 hành động action-first→thẻ→existing handler | kiểm 5×2 đúng bundle/slot, bridge event once, cancel không side effects; old bar fallback rollback |
| R3 (picker hình 2) | xài một sheet-face token cho hai pane, card app/categorization nếu mapping dữ liệu thật, target Ô1/2, pending selection + Apply/cancel, responsive trong geometry gốc | native/hosted/2 pane pixel parity, không blank app, lựa chọn đúng app; không vượt sheet bounds |
| R4 (FS blocker) | chứng minh transaction fullscreen app được chọn + dock/logo hidden + pinch-in restore đúng split/ratio; hoặc báo BLOCKED và để Full disabled | log FS expanded/restore same session, no zoomedSlot/FS1 guard conflict, no stuck state |
| R5 (stabilize) | mirror project/src, local compile/link (không DEB), nguồn dependency list, rollback, test geometry/scroll/reconnect/wake/scene/keyboard | compile evidence + hunk/commit + known device-pending tests; đưa G1 thực thi để Nguyen duyệt |

**Muse được giao chuẩn bị và thực hiện các lô G2 có giới hạn theo yêu cầu hiện tại.** Không được tự build/ký DEB, CI, merge hay publish; sau khi chốt bản UI thật/điểm blocker, GPT rà soát và Nguyen có quyền duyệt mẫu cuối. Nếu R0 chứng minh overlay không nổi trên hosted hoặc không safe, DỪNG & nộp bằng chứng thay vì vá phỏng đoán.

## G. Ma trận nghiệm thu (thiết bị mới chứng minh UI)
- Tối thiểu **5 lệnh × 2 ô = 10 kết quả** trên cùng DEB, có app native + hosted cả hai phía; thẻ chỉ lấy app thực, case Ô1/Ô2 đảo vị trí.
- Thử **pinch-in restore** khi fullscreen đã ẩn logo/Dock; pinch nội bộ zoom thì không nhầm FS1; trạng thái Full không cho kẹt.
- Ứng dụng nổi: khi 2 pane và chưa có float; có float rồi swap; về chia; ô không hỗ trợ/empty phải disabled; một float duy nhất.
- Chạy nền khác X: kiểm logger \`SCPNoteKillApp\` chỉ đi từ X (có 0.6s re-open guard); đóng app cuối và dock/reconnect.
- Chọn app: filter/cancel/Apply/target, native+hosted mặt sheet cùng màu, app bên dưới không blank hay mất touch, không avatar app giả.
- Close S1/S2 bằng tâm D/tap ngoài **không làm thay đổi pane**, AutoHide ẩn nhưng tay nắm vẫn đánh thức được, không để invisible shield; keyboard/scene/bố cục/touch không regression.
- Dữ kiện phải kèm source commit, phiên bản/hash **chính artifact cài**, PID/marker và video trên xe. Local compile PASS ≠ device pass.

## H. Checkpoint ngay lần bàn giao
- **Đã:** khảo sát source đúng nhánh HEAD nêu trên; đối chiếu G0 báo cáo Muse (23 geometry match, 5 UNKNOWN); chốt phương án 5-sector/action-first/target cards; vẽ 2 SVG source, lập hợp đồng source + QA; phân lô R0-R5.
- **Chưa:** sửa runtime, lập branch mới, kiểm thử local build, CI, tạo DEB hoặc thử xe. Muse chưa xác nhận đã nhận công việc mới trong lượt này.
- **Điểm mở:** Hành vi \`Toàn màn\` đúng full-dock-hide đang xung đột \`zoomedSlot\`/FS1; xếp **gating R4**, tuyệt đối không đánh tráo bằng local zoom. Stacking native/hosted popup là cổng R0.
- **Tham chiếu:** G0 \`APEX_V3_P4_G0_AUDIT_20261114.md\`; P0 \`APEX_V3_P0_BANG_PHU_20261114.md\`; Issue #1 comments 6878846745, 6878935751, 6879084608, 6879117968, 6879596244, 6879676620, 6879738074, 6879853819.
- **Bước tiếp:** Muse xác nhận nhận việc trên Issue #1; R0 nộp layered hit-route chứng cứ và danh sách shared hunks; R1/R2/R3 triển khai theo spec; R4 giải blocker FS; R5 compile. Không gán DEVICE PASS trước Nguyen test.
