# Audit — vị trí lớp của gương ABKnobView vs bề mặt native trong split hỗn hợp: giả thuyết "bị che" có đứng được trên giấy?

Chỉ-đọc; không sửa code/build/git. Phạm vi: CHỈ thứ tự lớp/clip của gương núm.
Cực "active" đảo ở publishKnobsNow đã kết tội riêng (audit-roundlogo §2) —
strand này không xét lại. Mọi khẳng định kèm offset dump hoặc dòng source;
source dẫn ở đây đã đối chiếu dump tương ứng (ghi rõ từng điểm).

## KẾT LUẬN NGẮN — (A): OCCLUSION BỊ LOẠI TRÊN GIẤY

Trong toàn bộ thiết kế gốc, **không tồn tại bề mặt nào của ô native ở phía
SpringBoard** — không trong cửa sổ AB, không ở cửa sổ/lớp nào khác — nên không
có tác nhân nào có thể che nửa gương phía native. Gương là subview trực tiếp,
nằm trước nhất trong cửa sổ AB (windowLevel StatusBar + 60 trên màn xe);
không tổ tiên nào clip nó; frame của nó tính theo tọa độ cửa sổ, không theo ô
hosted. Phần "mất" phía native chỉ còn có thể là lệch cỡ/độ sáng của giả
thuyết 1 (gương phình 1.6× + accent sáng vs núm local 14 pt kính mờ — cùng tâm
nhưng hai bản vẽ ở hai process), đúng như audit vòng 5 đã xếp hạng.


## 1) Gương gắn vào đâu, trên/dưới bề mặt nào (câu hỏi 1)

**Cửa sổ chứa:** `-[ABHost ensureWindow]` (gốc @0xAEA8) tạo MỘT
`UIRootSceneWindow` trên CADisplay của CarPlay qua
`initWithDisplayConfiguration:` (source ABHostBMethods.m:929–930), class con
pass-through (hitTest IMP @0x167DC — chạm trượt mọi subview thì xuyên cửa sổ).
`win.windowLevel = UIWindowLevelStatusBar + 60.0` (ABHostBMethods.m:949;
dump m_ABHost_ensureWindow.txt @0xb278 nạp `_UIWindowLevelStatusBar` — hằng
60.0 đã kiểm ở dump, phần BASE StatusBar trong source ghi INFERRED).
`backgroundColor = clearColor`, `hidden = NO`. Đây là cửa sổ DUY NHẤT phía
AppBridge trên màn xe: grep toàn project chỉ có một điểm tạo UIWindow phía SB
(ABHostBMethods.m:929); cửa sổ SB còn lại trên màn xe là splash của
StartupScreen (`UIWindowLevelAlert + kSSWindowLevelOffset`, SSSplash.m:174)
— chỉ tồn tại lúc kết nối, không hiện diện khi đang split.

**Gương gắn thẳng vào cửa sổ đó, trước nhất:**
- `-[ABHost setKnobs:]` (gốc @0x13ABC): knob mới được
  `[self.window addSubview:knob]` rồi `[self.window bringSubviewToFront:knob]`
  cho TỪNG knob trong mỗi lần reconcile (source ABHostBMethods.m:1275–1276;
  dump m_ABHost_setKnobs.txt: `addSubview:` @0x13fb4/0x141c4/0x14270,
  `bringSubviewToFront:` @0x14294).
- Mọi điểm làm thay đổi thứ tự lớp của cửa sổ đều nâng núm lại lên đầu:
  `-raiseKnobs` (@0x13918; dump m_ABHost_raiseKnobs.txt: `bringSubviewToFront:`
  @0x13a00 sau khi kiểm `superview == window`) được gọi sau khi thêm box lúc
  host app (ABHostLaunch.m:188) và trong `-setFront:forApp:` (@0x151A8) ngay
  sau `bringSubviewToFront:pane.box` (ABHostBMethods.m:1211–1213). Bất biến
  thiết kế: **núm luôn trước nhất trong cửa sổ AB**.
- Subview cửa sổ duy nhất khác được bringToFront là panel bàn phím
  (ABKeyboard.m:294–296) — chỉ khi bàn phím hiện, panel ngang ở đáy, không
  liên quan đĩa nửa cắt tại vách ngăn trong lúc dùng split bình thường.

**(a) So với surface của scene hosted:** scene hosted nằm trong `pane.box`
(box thêm vào cửa sổ ở ABHostLaunch.m:186; scene view chèn trong box, thanh
"..." trên scene trong cùng box). Box là subview thường của cửa sổ, luôn nằm
DƯỚI núm (núm được raise sau mọi lần thêm/nâng box). Gương ở TRÊN surface
hosted — khớp việc nửa hosted luôn nhìn rõ.

**(b) So với surface của pane native:** phía SpringBoard **không có** surface
nào của pane native. Registry `panes` của ABHost chỉ nhận pane từ đường launch
app hosted (ABHostLaunch.m:190 `addObject:pane` trong luồng host) — app native
không bao giờ có pane, box hay view đại diện trong cửa sổ AB. App native được
process CarPlay tự trình chiếu trong cửa sổ của chính nó trên màn xe, nằm
dưới toàn bộ cửa sổ AB (bằng chứng vận hành: các ô hosted — nằm trong cửa sổ
AB, DƯỚI núm — hiển thị trọn vẹn trên xe; nếu có surface native nào nổi trên
cửa sổ AB ở mức > StatusBar+60 thì phải có mã tạo/đăng ký nó, và không có).


## 2) Clip và hệ tọa độ của gương (câu hỏi 2)

- **Tổ tiên của gương chỉ có cửa sổ.** Gương là subview trực tiếp của window
  (mục 1), KHÔNG nằm trong pane.box. `clipsToBounds = YES` duy nhất trên
  đường liên quan là của **box** (ABHostBMethods.m:983, ABHostLaunch.m:184) —
  nó chỉ cắt các con của box (scene/bar/shield), không cắt được sibling là
  núm. Không dòng nào đặt clipsToBounds/masksToBounds lên cửa sổ hay lên
  chính ABKnobView (grep toàn module: chỉ box, blur trong dot, glass của bàn
  phím); UIWindow mặc định clipsToBounds = NO. Lớp blur `clipsToBounds = YES`
  (ABHostBMethods.m:1254) nằm BÊN TRONG dot 14×14, cắt blur theo hình tròn
  của dot — đúng thiết kế gốc, không đụng tới đĩa 66.
- **Frame theo tọa độ cửa sổ, không theo ô:** phía CarPlay,
  `publishKnobsNow` (@0x3ed84) tính tâm bằng
  `[divider convertPoint:knob.center toView:nil]` — toView:nil = tọa độ cửa
  sổ (SCPCarSplit.m:2613); phía SB, setKnobs gán thẳng `knob.center` bằng
  cặp [x, y] đó trong cửa sổ AB (ABHostBMethods.m:1283; dump
  m_ABHost_setKnobs.txt `setCenter:` @0x14384). Frame gương = hình vuông
  66×66 quanh tâm vách ngăn trong không gian cửa sổ, bắc qua cả hai ô; bounds
  của ô hosted không tham gia bất kỳ phép tính nào, và transform scale (khi
  active) nở quanh tâm về cả hai phía như nhau — không cơ chế clip nào trong
  thiết kế cắt riêng phần phía native.

## 3) Phía CarPlay: núm local nằm trên surface của app native (câu hỏi 3)

- Divider (chứa knob là subview) được `[self.container addSubview:divider]`
  (SCPCarSplit+Layout.m:565) và cuối `layoutKnobOf:` (@0x2c848) luôn chạy
  `[self.container bringSubviewToFront:divider]` (Layout.m:645) — divider
  trên mọi pane view trong container, gồm cả view của VC native (nằm trong
  pane.host thuộc container). Chỉ ratioMenu được nâng trên divider, có chủ
  đích (Layout.m:646–647), và không phải một đĩa tại vị trí núm. Vậy nửa
  native có núm local 14×14 kính mờ vẽ ĐÈ lên surface app native, đúng tâm
  vách ngăn — nó không bị surface native che; nó chỉ nhỏ và mờ hơn hẳn bản
  gương phình sáng ở phía hosted, tạo đường "cắt" tại biên ô cho mắt nhìn.

## 4) Đối chiếu runtime đã có (ủng hộ loại occlusion)

Log fixround5 (đã phân tích ở các vòng trước): 118 dòng "cham tron vach",
điểm chạm lệch tới ~96 pt khỏi tâm vách — tức các chạm rơi trên phần lãnh thổ
phía native vẫn bị gương bắt và relay thành chạm núm. Hit-test và trình chiếu
dùng cùng một cây lớp: nếu một surface native che gương ở nửa đó, các chạm ở
đó đã xuống app native thay vì thành chạm núm. Gương vừa nhìn-thấy-được (nửa
hosted) vừa chạm-được trên cả hai nửa — không tương thích với occlusion.

## 5) Giới hạn của kết luận

- Thứ tự composite liên-process do render server quyết theo windowLevel; mức
  StatusBar + 60 lấy từ dump phía AB (hằng 60.0 chắc; BASE StatusBar trong
  source ghi INFERRED). Strand không đọc được binary của chính hệ thống
  CarPlay — nhưng giả thuyết bị xét là "surface native TRONG THIẾT KẾ NÀY che
  gương", và thiết kế này không tạo bất kỳ surface native nào phía SB để mà
  che. Kết luận (A) đứng ở mức dump + source hai phía của dự án.
- Hệ quả cho lộ trình: không cần strand truy vết lớp/clip nữa. Sau khi sửa
  cực publishKnobsNow (bản sửa đang giữ), test mixed lại: theo kết luận này,
  đĩa phải liền — gương về 14 pt mờ khớp núm local. Nếu khi đó VẪN nửa vòng,
  nguyên nhân nằm ngoài hai giả thuyết hiện tại (không phải occlusion theo
  thiết kế này) và phải lấy dữ kiện mới (log/ảnh phiên đó) thay vì đào tiếp
  lớp/clip theo cảm tính.
