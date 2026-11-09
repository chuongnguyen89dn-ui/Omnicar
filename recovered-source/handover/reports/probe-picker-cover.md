# Điều tra: bảng chọn app che trắng nội dung ô đích (chỉ-đọc)

Dữ kiện xe (ytz4): mở bảng chọn app cho ô 1 (YouTube hosted) → vùng ô 1 quanh
bảng trắng trơn; ô phải (GOFA native) vẫn hiện nội dung ở phần không bị che.
Đóng X → app ô 1 trở lại nguyên vẹn ngay. Lệnh Nguyen: mở menu thì nội dung
bên dưới phải vẫn hiện như phía GOFA.

## Kết luận 1 dòng

Vùng trắng là `pane.picker` của chính ô đích — một UIView **đặc, phủ kín
toàn bộ ô**, được tạo vô điều kiện ngay khi bấm "Đổi app", trước cả khi bảng
chọn app (sheet) hiện. Không phải sheet, không phải cửa sổ tray, không phải
popupShield. App bên dưới không bị dừng/tháo — chỉ bị che khuất.

## 1) Phần tử tạo vùng trắng

Đường mở (đúng thứ tự chạy):

- `paneChoose:` — action "Đổi app" của thanh bar ô —
  `SCPCarSplit+Panel.m:155`, gọi `[self showPickerForSlot:pane.slot]` tại
  `Panel.m:164`, rồi đặt `pickerSheetPane` + `refreshPickerSheetSoon` tại
  `Panel.m:165–168`.
- `showPickerForSlot:` — `SCPCarSplit+Picker.m:155` (gốc 0x31530, VERIFIED):
  - `Picker.m:170` — `picker.frame = CGRectMake(0, 0, slotFrame.size.width,
    slotFrame.size.height)`: kích thước = **toàn bộ ô**, gốc (0,0) trong
    toạ độ pane-local (picker nằm trong `pane.view`).
  - `Picker.m:171–176` — `picker.backgroundColor = colorWithRed:0.9333
    green:0.9412 blue:0.9843 alpha:1.0`: màu gần trắng/lavender, **alpha
    1.0 = đặc hoàn toàn**.
  - `Picker.m:199` — `[pane.view addSubview:picker]` (thêm sau `pane.host`
    trong cùng `pane.view` → nằm trên host; chỉ `pane.handle` được đưa lên
    trên nó). Bên trong chỉ có nhãn "+" 40 pt (`Picker.m:180–196`).
  - Không có kiểm tra ô trống/có app: ô đang chạy app vẫn bị phủ như ô trống.
- Sau đó sheet mới dựng ở `buildPickerSheetForPane:`
  (`Picker.m:315`), neo giữa **toàn vùng chứa** (không phải theo ô đích),
  host = tray window nếu có (`Picker.m:324–336`), nền là
  `UIVisualEffectView` mờ xuyên (`Picker.m:428–437`) — phần sheet che thì cả
  hai phía đều mờ như nhau; vùng trắng chỉ nằm ở **phần ô đích ngoài sheet**,
  khớp đúng khung toàn-ô của `pane.picker`.

Các ứng viên đã loại bằng bằng chứng:

- **popupShield** (`SCPCTouchWatch`): `SCPCarSplit+Chrome.m:440` —
  background trắng alpha **0.02**, trong suốt thực tế; không thể tạo trắng đặc.
- **Cửa sổ tray**: `Picker.m:955–956` — `windowLevel = StatusBar + 65`,
  `backgroundColor = clearColor`.
- **`pane.cover`** (`addCoverToPane:`, `Picker.m:106–141`, màu giống hệt
  0.9333/0.9412/0.9843 tại `Picker.m:120–124`, cũng phủ kín ô phía trên
  `pane.host`): cùng họ màu nhưng **không chạy trên đường mở picker** — nó
  chỉ được gọi từ Divider.m:60 (resize), RatioMenu.m:446, Panel.m:401
  (tray trong container). Đường "Đổi app" không qua các điểm đó.

## 2) Vì sao ô native (GOFA) không trắng

- Placeholder chỉ được tạo cho **ô đích**: `paneChoose:` truyền đúng
  `pane.slot` của ô bấm "Đổi app" (`Panel.m:164`). Ô còn lại không nhận
  `pane.picker` nào → nội dung của nó ở phần ngoài sheet vẫn hiện nguyên, và
  qua nền sheet mờ thì mờ đi như thường. Đảo vai (chọn app cho ô GOFA) thì
  theo đúng code này ô GOFA sẽ trắng và ô YouTube sẽ hiện — tính đối xứng
  nằm ở slot đích, không nằm ở loại app.
- Khác biệt tầng trình bày chỉ là phụ trợ: nội dung hosted nằm trong
  `pane.host` thuộc `pane.view` (placeholder là anh em nằm trên nó), còn
  scene native là scene CarPlay riêng được compose vào cùng `pane.view` —
  nhưng cả hai đều bị phủ như nhau nếu ô của chúng là ô đích. Yếu tố quyết
  định là "có placeholder hay không", không phải hosted/native.

## 3) Scene hosted có còn render bên dưới không — CÓ, chỉ bị che

- `showPickerForSlot:` (`Picker.m:155–207`) chỉ làm: gỡ picker/loader cũ,
  tạo placeholder, addSubview, đưa handle lên trước, `relayoutAnimated:YES`,
  fade-in placeholder, hẹn refresh sheet. **Không** một dòng nào đụng
  `pane.host`, `pane.vc`, scene: không hidden, không alpha=0, không detach,
  không pause.
- Điểm phát khung host duy nhất trên đường này, `pushHostFramesLive:NO`
  (`SCPCarSplit.m:2246–2250`), chỉ gửi lại frame info cho các ô hosted +
  việc sổ sách shield — không dừng render.
- Đường đóng khẳng định ngược: `pickerCancel:` (`Picker.m:831–848`) cho ô
  có app chỉ gọi `removePickerFromPane:` (`Picker.m:208–218`, fade 0.15 s
  rồi gỡ view) + relayout — **không** openApp, không attach lại scene. App
  hiện lại ngay trên xe (dữ kiện Nguyen) chỉ hợp với "vẫn render bên dưới,
  gỡ lớp che là thấy".

## 4) Thay đổi tối thiểu để nội dung ô đích hiện qua như phía native

**Sửa đúng một điểm tạo duy nhất**: `showPickerForSlot:`,
`SCPCarSplit+Picker.m:171–176` — khi ô **đang có app**
(`pane.vc != nil || [self slotOccupied:pane.slot]` — đúng phép thử
`pickerCancel:` đang dùng tại `Picker.m:837`), đặt
`picker.backgroundColor = UIColor.clearColor` thay vì màu đặc. Ô trống giữ
nguyên màu đặc (không có gì bên dưới; nền đặc + dấu "+" chính là giao diện
ô trống).

Bắt buộc giữ nguyên, nếu không sẽ gãy cơ chế:

- **Đối tượng placeholder phải vẫn được tạo.** `refreshPickerSheet`
  (`Picker.m:284–286`) coi ô có `picker == nil` là không-phải-sheet-pane và
  loại nó → sheet không mở/đứng cho ô đó. "Không tạo placeholder cho ô có
  app" không phải một cách sửa hợp lệ; chỉ được đổi nền của nó.
- Viền 3 pt đánh dấu ô đích do `markPickerPanes` (`Picker.m:639–642`) vẽ
  trên chính placeholder — giữ nguyên, vẫn hoạt động với nền trong.

Rủi ro tương tác đã rà:

- **Chạm xuyên qua: không đổi.** Placeholder vẫn là UIView thường,
  `userInteractionEnabled` mặc định YES, mang tap recognizer
  (`Picker.m:197–198`); UIView nền trong vẫn hit-test bình thường → chạm
  trên ô vẫn rơi vào placeholder (`pickerPaneTapped:`), không lọt xuống app
  đang phát. Đổi màu nền không đổi hit-testing.
- **Bấm ngoài để đóng: không đổi.** Cơ chế đó là popupShield +
  `shieldExemptRects` (`SCPCarSplit+Chrome.m:466–495`), trong đó
  placeholder của sheet-pane là vùng miễn trừ (`Chrome.m:478–479`) theo
  khung, không theo màu.
- **Vị từ popup của guard fullscreen: không lệch.** `panelOpen`
  (`SCPCarSplit+Chrome.m:388–390`) đọc `tray || ratioMenu || pickerSheet`;
  vị từ guard (vòng fix-g) đọc các con trỏ tray/pickerSheet/ratioMenu/
  dragGhost — `pane.picker` **không thuộc** vị từ nào trong hai. Đổi nền
  placeholder không làm guard tưởng popup đã đóng hay đang mở ở bất kỳ ca
  nào.
- Phụ (mỹ thuật, không bắt buộc): nhãn "+" 40 pt màu secondary 0.6
  (`Picker.m:180–196`) sẽ nằm trên nội dung đang phát ở giữa ô — phần lớn
  bị sheet (neo giữa toàn vùng) che; có thể giữ nguyên trong bản sửa tối
  thiểu.

## 5) Đối chiếu bản gốc 1.0.3 — gốc CŨNG trắng y hệt

Có bằng chứng binary, không suy đoán:

- Disasm gốc `src/SplitScreenB/disasm/SCPCarSplit__showPickerForSlot_.txt`:
  tại `0x315f4` binary gốc nạp hằng `double 0.9333333333333333` rồi gọi
  `colorWithRed:green:blue:alpha:` — cùng hằng màu của placeholder.
- Biên bản tái tạo ghi `showPickerForSlot:` là `0x31530 VERIFIED` và giá
  trị màu `VERIFIED @0x315ec–0x3160c` (`Picker.m:155, 171–176`).

Tức lớp trắng phủ kín ô đích là **hành vi gốc 1.0.3**, không phải lỗi tái
tạo. Yêu cầu của Nguyen là một thay đổi vượt gốc (customisation), và điểm
sửa tối thiểu ở mục 4 là đủ để thực hiện nó mà không đụng cơ chế nào khác.
