[APEX M0] TRẠNG THÁI: SOURCE — khóa nền + ma trận kiểm kê xong. M0 không code, không build, đúng phạm vi mốc.

Baseline SHA: 298b7b4a8432037d71db441d0975aca1db1f6e04

Nhánh/HEAD SHA thực: `feature/duocar-apex-ui-muse-20261114`, HEAD tại thời điểm lập báo cáo = `7580bf46821c097321aa29a85fa65e623e6181b6` (commit ma trận dưới đây); chính báo cáo này cũng được commit thành file `APEX_M0_BAO_CAO_20261114.md` trên cùng nhánh ngay sau đó — cả hai đều là commit tài liệu [skip ci], không đụng source.

Commit mới + link: [7580bf4 — docs(apex-m0): ma tran kiem ke UI tai HL61 + diff DC58-HL61](https://github.com/chuongnguyen89dn-ui/Omnicar/commit/7580bf46821c097321aa29a85fa65e623e6181b6) — file đầy đủ: [APEX_M0_MA_TRAN_20261114.md](https://github.com/chuongnguyen89dn-ui/Omnicar/blob/feature/duocar-apex-ui-muse-20261114/recovered-source/gpt-project-history/APEX_M0_MA_TRAN_20261114.md)

PR Draft + link: chưa có (theo lộ trình thuộc M4)

Bề mặt đã xử lý / còn thiếu (ID D1–D14): ĐÃ KIỂM KÊ đủ 14/14 nhóm D của audit DC58 + 3 bề mặt mới của trục HL59–HL61 (A1 viền cảnh báo nhiệt HL61, A2 cổng nhiệt 37°C + công tắc giả lập HL60, A3 lớp nâng bong bóng Lề HL59) = **17 hàng ma trận**, mỗi hàng đủ: trạng thái HL61 kèm file/class/method/số dòng, khác gì so với DC58, hướng APEX, file chủ sở hữu ở cả `project/` và `src/`, ràng buộc F/C, U liên quan, rủi ro + lô dự kiến. Chưa bề mặt nào được sửa ở M0.

File/method/hunk sửa (cả project/src): KHÔNG sửa source. Chỉ thêm 1 file tài liệu ở trên.

Screenshot BEFORE/AFTER: chưa có — thuộc M1 (mockup trình Nguyen duyệt trước khi viết code UI).

Test/lệnh thực + kết quả: `git diff 630e50c..298b7b4a` = 21 file, +1347/−318, 16 commit; `cmp` từng file cho các bề mặt không đổi; grep đo số dòng trực tiếp trên cây HL61. Đội hình đã chốt với Nguyen: 1 điều phối + 4 tuyến chỉ-đọc cho giai đoạn phân tích; Muse là người tổng duyệt cuối và tự kiểm chứng lại các số khóa (`SCPThermalEdgeWarning.h:58` đúng dòng chữ cảnh báo, `ABInApp.m:549` đúng cờ phím vẽ, grep `FF4757` trong cây = 0, chỉ tồn tại workflow `build-hl59-quick-arm64.yml`).

Phát hiện chính của vòng diff DC58→HL61:
- **HL59:** `DCLLeExtension` có thêm chức năng thứ ba — nâng `windowLevel` bong bóng hãng (peer +2, chỉ nâng). Mục F9 của audit DC58 ("shim đúng 2 chức năng, không can thiệp windowLevel") đã lỗi thời; comment đầu file còn ghi ngược với chính code. Theo mục C của Issue này, DCLLeExtension của HL59 KHÔNG được đổi — hàng A3 chỉ kiểm kê để biết, không thuộc phạm vi thiết kế lại. DC59CL PASS xe riêng lớp này theo hồ sơ.
- **HL60:** cổng nhiệt viết lại — cảnh báo liên tục ở ≥37,0°C, bỏ hẳn ngưỡng 39°C/2 mẫu/5 giây; thêm pref `duocarThermalTest37Enabled` + kênh Darwin `thermaltest37.changed` (mở rộng hợp đồng F10). DC60CL build được nhưng visual FAIL trên xe (rèm đỏ đục 87% + chữ thừa).
- **HL61** (commit [skip ci], CHƯA build, CHƯA test xe): chỉ đổi hình thức cảnh báo — viền đỏ phát sáng nhấp nháy + chữ duy nhất "LÀM MÁT THIẾT BỊ CỦA BẠN"; giữ nguyên cửa sổ (+64.5/+64.0), hitTest xuyên chạm và logic cổng.
- **Không đổi (cmp IDENTICAL):** bàn phím hosted vẫn là PHÍM VẼ (`ABDrawnKb = YES`) nên U3 chưa được giải quyết; startup, picker, thanh lệnh/handle/divider, logo/AutoHide/BridgeWake, pinch HL53 đều đứng yên.
- **Nguồn build thật = cây `project/`** (workflow `build-hl59-quick-arm64.yml:106`); cây `src/` là bản gương (215 file giống hệt từng byte, 7 file khác). Không tồn tại workflow HL61 — không được suy ra HL61 đã build.

Phạm vi F1–F14 và C1–C12 có đụng không? KHÔNG — M0 chỉ đọc và đo. Ma trận Mục 3 gắn cờ 40 mục file+method dùng chung (tiêu biểu: `SCPCarSplit.m`, `+Chrome.m`, `+Picker.m`, `+AutoHide.m`, `+BridgeWake.m`, `ABHostBMethods.m`, `ABInApp.m`, `ABKeyboard.m`, `OMCNativeSettings.m`, hai file vitals): mọi hunk đổi skin chạm các file này ở M2/M3 sẽ được nêu chi tiết tại Issue này và chờ Nguyen/GPT duyệt TRƯỚC khi sửa, đúng mục C.

Rủi ro / xung đột / cách rollback: rollback M0 = revert commit tài liệu `7580bf4`. Xung đột đã ghi trong ma trận Mục 4: comment đầu file `DCLLeExtension.m` mâu thuẫn chính code của nó; F9/F14 của audit lỗi thời tại HL61; `HUONG_DAN_GPT.txt` không tồn tại trên cây HL61 dù hồ sơ cũ trỏ tới; `TIEP_TUC_DU_AN.md` chưa có mục HL59–61.

Phần chưa xác minh (ma trận Mục 5): toàn trục HL59–HL61 ngoài ca DC59CL chưa có kết quả xe nào; HL61 chưa build; hệ quả việc bỏ điều kiện nguồn battery cho mẫu nhiệt; đường merge companion Lề vào DEB HL61; `ABNativeDrawnTA` có tự chạy độc lập cho app CarPlay gốc hay không; điều kiện runtime `SCPHL49SameWindowPicker`; các U còn nguyên: U1, U3, U6, U7, U8, U10–U17 (U5/U9 đã giải một phần nhờ đo lại tại HL61).

Bước tiếp theo + điều kiện đạt: **M1 — thiết kế bằng hình**: mockup iPhone (Bảng điều khiển / Bố cục / Ứng dụng / Thiết bị / Tùy chỉnh + preview split + chọn app), mockup CarPlay (split / native / hosted / picker / fullscreen / keyboard / startup), bảng token màu + bộ icon/logo, trạng thái tương tác, BEFORE/AFTER. Nguyen duyệt mockup thì mới sang M2 viết code; chưa duyệt thì không viết code UI. Giai đoạn code M2/M3 theo đội hình đã chốt: tối đa 3 người chạm code, mỗi người một nhóm file riêng không chồng lấn, 1 người rà soát chỉ-đọc đối chiếu F/C, Muse tổng duyệt cuối và là người duy nhất commit/đẩy/báo cáo.
