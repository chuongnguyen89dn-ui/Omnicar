# M4 — Bản đồ picker: placeholder `pane.picker` che trắng ô đích

Strand chỉ-đọc. Không sửa file nguồn trong vòng này.

- Cây nguồn: `~/workspace/push9-clone/recovered-source/src/`
- HEAD tự xác minh tại thời điểm đọc: `38735c5bef6dc22ca9cb11f4e894725ce494be41`
- Mọi `file:line` dưới đây là dòng của HEAD trên, đã đọc lại trực tiếp, không chép số của vòng trước.
- Đường dẫn viết tắt: `Picker.m` = `recovered-source/src/SplitScreenB/SCPCarSplit+Picker.m`; `Panel.m` = `recovered-source/src/SplitScreenB/SCPCarSplit+Panel.m`; `SplitA.m` = `recovered-source/src/SplitScreenA/SCPCarSplit.m`; `Chrome.m` = `recovered-source/src/SplitScreenB/SCPCarSplit+Chrome.m`; `Pane.h` = `recovered-source/src/SplitScreenB/SCPCarPane.h`.

---

## Tóm tắt một dòng

**Điểm hiện tại → nguyên nhân → điểm sẽ sửa:** placeholder được tạo tại đúng một chỗ, `Picker.m:155-205` (`showPickerForSlot:`), và được sơn nền đặc vô điều kiện tại `Picker.m:171-174`; vì nó được `addSubview` vào `pane.view` sau `pane.host` nên nó phủ toàn ô kể cả ô đã có app → sửa đúng tại phép gán đó: chụp trạng thái có-content **trước** khi gán `pane.picker` (sau `Picker.m:161`, trước `Picker.m:162-163`) bằng đúng biểu thức mà `pickerCancel:` dùng, rồi chỉ đổi `backgroundColor` thành `UIColor.clearColor` khi ô có content; ô trống giữ nguyên màu đặc.

---

## 1) Điểm tạo placeholder trên HEAD — xác minh lại

### 1.1 Thân của `showPickerForSlot:` (`Picker.m:155-205`)

| Việc | Dòng thật (HEAD) |
|---|---|
| Định nghĩa, guard `active`, chuẩn hoá slot, lấy pane, pane nil thì return | `Picker.m:155-159` |
| Gỡ placeholder cũ + gỡ loader | `Picker.m:160` `[self removePickerFromPane:pane];` · `Picker.m:161` `[self removeLoaderFromPane:pane animated:NO];` |
| Tạo view + gán vào pane **trước mọi styling** | `Picker.m:162` `UIView *picker = [[UIView alloc] init];` · `Picker.m:163` `pane.picker = picker;` |
| Frame: lấy `frameForSlot:` nhưng chỉ lấy **size**, origin zero (toạ độ trong `pane.view`) | `Picker.m:169-170` `picker.frame = CGRectMake(0, 0, slotFrame.size.width, slotFrame.size.height);` |
| **Màu nền đặc — điểm gây vùng trắng** | `Picker.m:171-174` `[UIColor colorWithRed:0.9333333333333333 green:0.9411764705882353 blue:0.984313725490196 alpha:1.0]` |
| Autoresizing | `Picker.m:175` `picker.autoresizingMask = 0x12;` |
| Border (màu lavender, **không** phải nền) | `Picker.m:179-182` `picker.layer.borderColor = …` |
| Nhãn `"+"` (màu secondary 60%, font 40 light, căn giữa) thêm vào picker | `Picker.m:183-194` |
| Tap recognizer → `pickerPaneTapped:` gắn **trên chính picker** | `Picker.m:195-198` |
| Gắn vào pane; đưa handle lên trước; relayout | `Picker.m:199` `[pane.view addSubview:picker];` · `Picker.m:200` `bringSubviewToFront:pane.handle` · `Picker.m:201` `relayoutAnimated:YES` |
| Fade-in 0 → 1 trong 0,25 s | `Picker.m:202-204` |
| Hàng đợi dựng sheet | `Picker.m:205` `[self refreshPickerSheetSoon];` |

Thứ tự z trong `pane.view`: `pane.host` được gắn từ lúc tạo pane (`SplitA.m:1435-1437`, trong `newPane`), picker gắn sau tại `Picker.m:199` nên nằm **trên** host — đó là lý do nền đặc của nó che được content thật (view của VC được gắn vào host tại `SplitA.m:1168` với native, `SplitA.m:1914` với hosted). Chỉ `pane.handle` được đưa lên trước picker (`Picker.m:200`).

Khẳng định về tính duy nhất: trong toàn cây chỉ có **một** phép gán `picker.backgroundColor` — `Picker.m:171` (grep `picker.backgroundColor` cho đúng 1 hit; các hit cùng hằng màu ở `Picker.m:120` và `Picker.m:1100` là cover/loader, không phải placeholder này).

### 1.2 Thứ tự so với dựng sheet — placeholder có trước, sheet là hệ quả

`showPickerForSlot:` **không** dựng sheet trực tiếp; nó chỉ xếp hàng `refreshPickerSheetSoon` (`Picker.m:205`; bản thân hàm đó ở `Picker.m:235-242`, dispatch async rồi gọi `refreshPickerSheet`).

`refreshPickerSheet` (`Picker.m:281-310`) dùng **sự tồn tại của placeholder** làm điều kiện hợp lệ của sheet:

- `Picker.m:284-285`: `pickerSheetPane` lưu sẵn bị vô hiệu nếu `sheetPane.picker == nil` hoặc pane không còn trong `allPanes`.
- `Picker.m:288-291`: fallback quét `panesInReadingOrder`, chỉ nhận pane đầu tiên có `pane.picker != nil`.
- `Picker.m:294-296`: không tìm được pane nào có picker → `removePickerSheet` và return.
- `Picker.m:305-307`: chỉ khi có `found` và (sheet chưa có hoặc state-key đổi) mới `buildPickerSheetForPane:found` (`Picker.m:321` trở đi).
- `Picker.m:309`: cuối cùng `markPickerPanes` (đặt `borderWidth` 3 pt cho picker của sheet-pane, 0 cho các picker còn lại — `Picker.m:639-642`).

Kết luận mục 1: vai trò của placeholder đối với sheet là **tín hiệu đủ tư cách (eligibility) bằng property `pane.picker != nil`**, không phải màu/độ mờ của nó. Đổi `backgroundColor` không đổi property, không đổi thứ tự tạo → không đổi đường dựng sheet. Ngược lại, nếu "sửa" bằng cách không tạo placeholder cho ô có app, sheet sẽ mất tư cách ở `Picker.m:284/290` — đó là lý do đặc tả giữ nguyên cấu trúc, chỉ đổi màu nền.

---

## 2) Phép thử "ô có app/content gắn thực tế" tại điểm tạo

### 2.1 Bốn ứng viên — định nghĩa thật

**(a) `pane.vc != nil`**

- Khai báo: `Pane.h:43` `@property (nonatomic, strong, nullable) UIViewController *vc;`
- Người ghi: native — `SplitA.m:1171-1172` (`adopt:slot:` gán `pane.vc = vc; pane.bundleID = bundle;` sau khi đã gắn `vc.view` vào `pane.host` ở `SplitA.m:1162-1168`); hosted — `SplitA.m:1915-1916` (`hostApp:inPane:` gán VC token `SCPHostedAppVC` + bundle, view của token đã gắn vào host ở `SplitA.m:1911-1914`). Hosted cũng qua được phép thử này.
- Người xoá: luôn xoá cặp vc+bundle cùng nhau — ví dụ `SplitA.m:1134`, `SplitA.m:1146` (evict trong adopt), `SplitA.m:1546-1547` (`removePaneAt:`), `SplitA.m:1746-1747` (`closeGoingHome:`), `SplitA.m:1906-1907` (evict trong hostApp), `SplitScreenB/SCPCarSplit+Zoom.m:204-205, 317-318, 375-376`.

**(b) `[self slotOccupied:slot]`**

Định nghĩa đầy đủ, `SplitA.m:471-479`:

```objc
- (BOOL)slotOccupied:(NSInteger)slot {
    SCPCarPane *pane = [self paneAtSlot:slot];
    if (!pane) return NO;
    if (pane.vc) return YES;
    if (pane.picker) return YES;                               // ← tự tham chiếu placeholder
    for (NSString *bundle in self.pending)
        if ([self pendingSlotForBundle:bundle] == slot) return YES;
    return NO;
}
```

Tầng thứ ba (pending) có hạn tuổi: `pendingSlotForBundle:` trả `-1` khi entry quá 12 s (`SplitA.m:445-450`).

**(c) `pane.host` có scene gắn**

- Khai báo: `Pane.h:45` (`UIView *host`). Host **luôn tồn tại** với mọi pane do `newPane` tạo (`SplitA.m:1435-1437`) — kể cả ô trống — nên `pane.host != nil` vô dụng (luôn YES).
- Không có property "scene" nào trên host/pane để đọc trực tiếp: content vào host chỉ qua `addSubview:` — native `SplitA.m:1168` (`vc.view`), hosted `SplitA.m:1914` (`hosted.view`), các đường zoom dời view giữa các host (`SplitScreenB/SCPCarSplit+Zoom.m:287-289, 313, 371`). Với hosted, comment tại `SplitA.m:1917` ghi rõ scene thật nằm phía SpringBoard, host chỉ giữ view token.
- Biến thể khả thi duy nhất là suy ra từ `pane.host.subviews`/`vc.view.superview == pane.host` — nhưng **không nơi nào trong cây dùng phép thử kiểu này để quyết occupied** (grep các điểm `pane.host` chỉ là gắn/dời view và publish frame), và nó đo *hình ảnh còn sót* chứ không đo *quyền sở hữu hiện tại* (xem ca biên 2.3b).

**(d) `pane.bundleID != nil`**

- Khai báo: `Pane.h:42` (`NSString *bundleID`, copy). Trong các đường chính nó được gán/xoá **cùng lúc** với `vc` (các dòng ở (a)), nên phần lớn thời gian nó trùng (a).
- Nhưng gốc tự cảnh báo trạng thái lệch: `paneForBundle:` (`SplitA.m:412-422`) đọc `vc` trước và bỏ qua pane chỉ có bundle — comment `SplitA.m:415-418`: *"a pane carrying only a bundle id (loader/picker stage, no VC yet) must not match"*. Tức bundleID-đơn-độc là trạng thái thật (giai đoạn loader/picker) và gốc **không** coi đó là đã có app.

### 2.2 Phép thử được chọn — đúng biểu thức của `pickerCancel:`, chụp đúng cửa sổ thời gian

`pickerCancel:` (`Picker.m:831-850`) tự phân biệt ô có app như sau:

- `Picker.m:836`: `[self removePickerFromPane:pane];` — gỡ placeholder **trước**.
- `Picker.m:837`: `if (pane.vc != nil || [self slotOccupied:pane.slot]) { [self relayoutAnimated:YES]; }` — có app thì chỉ relayout.
- `Picker.m:839-843`: ngược lại — float pane thì `closeFloat:NO`, pane thường thì `removePaneAt:background:NO` + `afterPaneRemoved:`.

Điểm mấu chốt về thứ tự: `removePickerFromPane:` xoá property **đồng bộ** (`Picker.m:208-211`: `pane.picker = nil;` ngay trong thân; việc `removeFromSuperview` của view cũ bị hoãn vào completion của animation 0,15 s ở `Picker.m:212-215`). Vì vậy tại thời điểm `Picker.m:837` chạy, tầng `pane.picker` trong `slotOccupied:` đã tắt, và biểu thức ở 837 rút gọn thành:

```
pane.vc != nil  ||  có pending (≤12 s) nhắm vào slot này
```

**Phép thử M4 chọn: chính biểu thức đó, chụp tại cửa sổ tương đương trong `showPickerForSlot:` — sau `Picker.m:160-161` (placeholder cũ đã bị nil hoá đồng bộ bởi dòng 160, loader đã gỡ ở 161) và trước `Picker.m:162-163` (placeholder mới chưa được gán).** Tại cửa sổ này hai ngữ cảnh cho cùng một giá trị, từng trường hợp:

| Trạng thái ô tại điểm tạo | `vc` | pending→slot | Phép thử | Nền sau sửa | Khớp `pickerCancel:`? |
|---|---|---|---|---|---|
| Có app native/hosted đang gắn | ≠ nil | — | YES | `clearColor` | Có — cancel chỉ relayout (`Picker.m:837-838`) |
| Đang chờ launch (chưa có VC) | nil | có, ≤12 s | YES | `clearColor` | Có — cancel cũng coi là occupied qua tầng pending |
| Chỉ có bundleID (giai đoạn loader/picker, không VC, không pending) | nil | không | NO | giữ đặc | Có — và khớp cảnh báo `SplitA.m:415-418` |
| Trống thật | nil | không | NO | giữ đặc | Có — cancel đi nhánh gỡ pane (`Picker.m:841-843`) |

**Bẫy bắt buộc phải tránh (đây là phần quyết định của điểm sửa):** nếu viết phép thử ngay tại dòng gán màu `Picker.m:171` — tức **sau** `Picker.m:163` (`pane.picker = picker;`) — thì `slotOccupied:` luôn trả YES vì tầng `if (pane.picker) return YES;` (`SplitA.m:475`) tự bắt placeholder vừa tạo. Hệ quả: **mọi** placeholder thành trong suốt, kể cả ô trống → phá đúng yêu cầu "ô trống vẫn nền đặc". Vì vậy việc chụp `BOOL` cục bộ trước dòng 163 không phải tuỳ chọn phong cách; nó là điều kiện đúng/sai của bản sửa.

So với từng ứng viên đơn độc: chỉ-`vc` hụt ca pending (lệch khỏi `pickerCancel:`); chỉ-`bundleID` thừa ca bundle-đơn-độc; `host` không dùng được ở dạng property và mong manh ở dạng subviews; chỉ-`slotOccupied` đúng/sai hoàn toàn tuỳ **thời điểm** gọi. Biểu thức ghép + cửa sổ thời gian trên là phép thử duy nhất khớp cả bốn nguồn (định nghĩa `slotOccupied:`, cách dùng của `pickerCancel:`, cảnh báo của `paneForBundle:`, đường gắn view của adopt/hostApp).

### 2.3 Ca biên

**(a) Ô "đang có app" nhưng `vc` tạm nil.** Hai dạng đã thấy trong nguồn:

1. *Pending launch:* `openApp:slot:` nhánh fresh native ghi `self.pending[bundleID] = @[@(slot), date]` và dựng loader **trước** khi VC về (`SplitA.m:622-623`); `pane.vc`/`pane.bundleID` vẫn nil cho tới `adopt:`. Phép thử chọn vẫn bắt được nhờ tầng pending → nền trong. Đánh đổi phải ghi rõ: lúc đó **chưa có hình app thật** sau lớp trong — thứ hiện ra là nền của chính `pane.view` (màu `colorWithWhite:0.08 alpha:1`, `SplitA.m:1430`) cộng nhãn `"+"` của placeholder, và loader vừa bị gỡ ở `Picker.m:161`. Đây là hệ quả của việc bám đúng ngữ nghĩa occupied của gốc, không phải lỗi lệch: `pickerCancel:` cũng giữ pane này lại.
2. *Đang đổi app giữa chừng:* các chuỗi xoá-rồi-gán vc trong `adopt:` (`SplitA.m:1146` → `1171`) và trong Zoom (gán cả hai phía của swap, `SCPCarSplit+Zoom.m:290-294`) không có lời gọi `showPickerForSlot:` nào xen giữa trong các caller đã kiểm kê (§3.3) — nên cửa sổ nil này không bị điểm tạo quan sát thấy trong nguồn hiện tại. Nếu tương lai có caller mới gọi từ giữa một chuỗi như vậy, phép thử sẽ trả NO → nền đặc (hướng an toàn: che, không lộ trạng thái dở dang).

**(b) Ô trống nhưng `host` còn view sót.** Đường dọn chuẩn không để sót: `detachVC:background:` tự gỡ view (`SplitA.m:1217` `[vc.view removeFromSuperview]`) và mọi caller xoá cặp vc+bundle (liệt kê ở 2.1a). Nếu một view sót vẫn nằm trong host do lỗi ở nơi khác, phép thử chọn (đo theo **quyền sở hữu**: vc/pending) trả NO → nền đặc **che phủ** view sót đó. Đây là hướng fail-safe và là lý do không chọn phép thử `host.subviews`: phép thử theo hình ảnh sẽ trả YES và phơi đúng view ma ra sau lớp trong.

**(c) Ngược lại — `vc != nil` nhưng view của nó không hiện hữu ích** (scene chết/view bị detach bởi tác nhân ngoài): phép thử trả YES → nền trong, người dùng thấy nền tối của `pane.view` + `"+"` thay vì một ô trắng. Không có phép thử nào trong bốn ứng viên phân biệt được ca này tại điểm tạo (nó cần đo scene sống — ngoài phạm vi strand này); ghi nhận là rủi ro còn lại ở §5.3.

**(d) Pending quá hạn:** entry pending >12 s bị `pendingSlotForBundle:` coi như không có (`SplitA.m:448`) → phép thử trả NO → nền đặc, và `pickerCancel:` cũng đối xử ô đó là trống. Tính nhất quán với gốc được giữ nguyên cả ở ca biên này.

---

## 3) Bốn đường qua điểm tạo

### 3.1 Mở picker cho ô **có app**

Đường chính: `paneChoose:` (`Panel.m:156-169`):

- `Panel.m:159` ẩn bar của pane; `Panel.m:160-163` ô đang ghim thì toast và return (không tới điểm tạo).
- `Panel.m:164` `[self showPickerForSlot:pane.slot];` — **không** có guard occupied ở đây; đó chính là lý do ô có app cũng tới được điểm tạo và bị phủ trắng.
- `Panel.m:165-168`: nếu `pane.picker != nil` thì đặt `pickerSheetPane = pane` + `refreshPickerSheetSoon`.

Đường tương đương phía bridge: `bridgeBarAction:` action `replace` — `SplitA.m:2567-2569` ẩn bar rồi gọi cùng `showPickerForSlot:`.

Hiện trạng ở ô đích: placeholder (nền đặc, fade-in tới alpha 1) nằm trên `pane.host` → content của app bị thay bằng mặt trắng + dấu `"+"`, trong khi sheet chọn app vẫn dựng bình thường phía trên (§1.2). Đây là triệu chứng "vùng trắng ở ô đích" của vòng trước, đối chiếu khớp từng dòng trên HEAD.

### 3.2 Mở picker cho ô **trống**

Cùng `paneChoose:` ở trên, hoặc đường hàng loạt `showPickersForEmptySlots` (`Picker.m:219-223`): chỉ gọi `showPickerForSlot:` cho slot **chưa** occupied (`Picker.m:221` `if (![self slotOccupied:i])`). Chú ý bất đối xứng: đường hàng loạt tự lọc occupied, còn đường `paneChoose:`/bridge thì không — nên mọi lập luận "placeholder chỉ dành cho ô trống" đều sai ở đường chọn-từ-bar; tên/marketing của tính năng ("empty-slot placeholder", comment `Picker.m:153`) không phải guard.

Các caller khác của cùng điểm tạo (kiểm kê grep toàn cây, tất cả đều dẫn về §3.3): `showPickerForFocusedPane` (`Picker.m:1050-1054`), `launchFailed:` cho pane vừa mất app (`SplitA.m:791-792`, điều kiện `!pane.vc && ![self slotOccupied:pane.slot]` tại `SplitA.m:791`), đuôi `adopt:` cho pane bị evict (`SplitA.m:1192`), `layoutChosenID:` (`SplitA.m:1708`), `openAppsInOrder:` khi slot không có app (`SplitA.m:866`).

### 3.3 Huỷ — `pickerCancel:` (`Picker.m:831-850`)

Chuỗi thật: resolve pane (`pickerSheetPane`, fallback `paneForView:` — `Picker.m:833-835`) → `removePickerFromPane:` (`Picker.m:836`) → rẽ theo occupied/empty (`Picker.m:837-843`, đã phân tích §2.2) → `@catch` chỉ log (`Picker.m:845-849`). Nút huỷ trong sheet trỏ vào đây: chip cancel tạo ở `Picker.m:474-475` (`SCPWrapRatioChip(…, @selector(pickerCancel:))`).

`removePickerFromPane:` gỡ những gì (`Picker.m:208-217`): nil hoá property đồng bộ, fade view xuống alpha 0 trong 0,15 s, `removeFromSuperview` trong completion, và xếp hàng `refreshPickerSheetSoon` (`Picker.m:216`). Sheet tự đóng **gián tiếp** qua hàng đợi đó: `refreshPickerSheet` thấy sheet-pane không còn picker → fallback sang pane còn picker khác nếu có; không còn ai thì `removePickerSheet` (`Picker.m:294-296`; thân teardown ở `Picker.m:647` trở đi). Hệ quả phụ cần biết khi test xe: nếu còn ô khác đang có picker, huỷ ở ô này **không** đóng sheet — sheet đổi đích. Đó là hành vi gốc, không phải tồn dư của bản sửa.

**Có điểm nào kiểm tra lớp phủ tồn dư sau huỷ không? Không.** Trong thân `pickerCancel:` (831-850) không có assert/verify/`superview == nil` check nào sau `removePickerFromPane:`; trong `removePickerFromPane:` cũng chỉ có guard đầu vào `if (picker == nil) return;` (`Picker.m:210`). "Đã gỡ" về mặt property là tức thời (dòng 211), còn về mặt view là bất đồng bộ (completion ở dòng 215) và không nơi nào xác minh lại. Rủi ro tồn dư duy nhất vì thế là cửa sổ 0,15 s của animation — áp dụng như nhau cho bản trước và sau sửa (bản sửa không đụng đường này).

### 3.4 Chọn app — `pickerAppTapped:` → `openApp:slot:`

- `pickerAppTapped:` (`Picker.m:809-826`): lấy pane từ `pickerSheetPane`/`paneForView:` (`Picker.m:811-813`), bundle từ `sender.accessibilityIdentifier` (`Picker.m:814`), gọi `[self openApp:bundle slot:pane.slot]` (`Picker.m:818`), sau đó nếu `pane.picker != nil` thì `refreshPickerSheetSoon` (`Picker.m:819-820`).
- Việc dọn placeholder nằm **bên trong** `openApp:slot:`: ngay sau khi resolve pane đích, `SplitA.m:599-601` `[self removePickerFromPane:pane];` — chạy trước cả hai nhánh fresh/existing. Nhánh existing: move/swap (`SplitA.m:603-613`). Nhánh fresh hosted: `hostApp:inPane:` (`SplitA.m:617-618`). Nhánh fresh native: ghi pending + loader (`SplitA.m:622-623`) rồi launch; khi VC về, `adopt:slot:` lại gọi `removePickerFromPane:` lần nữa (`SplitA.m:1122`, thừa nhưng vô hại — guard nil ở `Picker.m:210`) rồi mới gắn `vc.view` vào host (`SplitA.m:1168`) và gán vc/bundle (`SplitA.m:1171-1172`).
- Sheet sau khi chọn: vì property `pane.picker` đã nil đồng bộ từ `SplitA.m:601`, lần refresh tiếp theo (từ `Picker.m:820` hoặc từ chính `removePickerFromPane:` ở `Picker.m:216`) sẽ không còn thấy pane này đủ tư cách; còn picker ở ô khác thì sheet ở lại cho ô đó, hết picker thì sheet bị gỡ (§3.3).

Kết luận mục 3: cả bốn đường (mở-có-app, mở-trống, huỷ, chọn) đều **đi qua cùng một thân hàm tạo duy nhất** và một phép gán màu duy nhất (`Picker.m:171`); huỷ/chọn dọn placeholder bằng cùng `removePickerFromPane:`. Sửa một chỗ tại phép gán màu là đủ và là chỗ sửa duy nhất cần thiết cho strand này.

---

## 4) Phạm vi KHÔNG đụng — khẳng định theo đặc tả

### 4.1 Cấu trúc placeholder: vẫn tạo nguyên vẹn

Alloc/gán (`Picker.m:162-163`), frame (`Picker.m:170`), autoresizing (`Picker.m:175`), border (`Picker.m:179-182`), nhãn `"+"` (`Picker.m:183-194`), gắn vào `pane.view` (`Picker.m:199`), fade-in (`Picker.m:202-204`) — tất cả giữ nguyên. Hệ quả phải chấp nhận và ghi rõ: sau sửa, ô có content vẫn còn **dấu `"+"`** (font 40 light, secondary 60%) và **border** (3 pt khi là sheet-pane — `Picker.m:639-642`) vẽ đè lên content; chỉ **nền** trở nên trong. "Thấy nội dung xuyên" nghĩa là xuyên qua nền, không phải placeholder biến mất.

### 4.2 Recognizer trên placeholder: giữ nguyên

`Picker.m:195-198`: `UITapGestureRecognizer` với action `pickerPaneTapped:` gắn trên chính picker; handler ở `Picker.m:225-231` (đòi `pane.picker != nil`, đặt `pickerSheetPane`, refresh sheet). Bản sửa không đổi dòng nào trong đoạn này và không đổi `userInteractionEnabled` của picker (trong `Picker.m` không hề có lệnh set property này cho picker — nó giữ mặc định YES của `UIView`).

### 4.3 Lifecycle sheet: giữ nguyên

`refreshPickerSheetSoon` (`Picker.m:235-242`), `refreshPickerSheet` (`Picker.m:281-310`), `buildPickerSheetForPane:` (`Picker.m:321` trở đi), `markPickerPanes` (`Picker.m:639-642`), `removePickerSheet` (`Picker.m:647` trở đi) — không hàm nào đọc `backgroundColor` của placeholder (grep trong `Picker.m`: phép gán ở dòng 171 là nơi duy nhất chạm `picker.backgroundColor`, và không có phép đọc/so sánh nào). Điều kiện sống/chết của sheet vẫn là property `pane.picker` (§1.2) — bất biến trước thay đổi màu.

### 4.4 Vị từ popup của guard fullscreen: `pane.picker` không thuộc vị từ nào

- `panelOpen` — `Chrome.m:388-391`: `self.tray != nil || self.ratioMenu != nil || self.pickerSheet != nil`.
- `popupOpen` — `Chrome.m:393-395`: `panelOpen || anyBarVisible` (bar của pane, `Chrome.m:366-370`).
- Guard fullscreen — `SplitScreenA/SCPFullscreenController.m:345-351`: từ chối theo `split.pickerSheet` (dòng 348) rồi `[split popupOpen]` (dòng 350); AutoHide cũng chặn theo `popupOpen`/`pickerSheet`/`ratioMenu`/`tray` (`SplitScreenA/SCPCarSplit+AutoHide.m:151-154`).

Cả ba nơi đều đọc **`pickerSheet`** (cái sheet lưới app, property của `SCPCarSplit`) — **không** đọc `pane.picker` (placeholder từng ô). Hai property khác nhau; bản sửa không đổi cả hai.

Một chỗ liên quan nhưng khác bản chất: `shieldExemptRects` (`Chrome.m:472-485`) có đưa `pickerSheetPane.picker` vào danh sách rect được miễn trừ của popup-shield (`Chrome.m:478-479`), và vòng lọc ở `Chrome.m:488` bỏ qua view có `window == nil || isHidden || alpha == 0`. Đây là danh sách miễn trừ hit của shield, không phải vị từ popup; nó đọc **rect/tồn tại/alpha** của placeholder, không đọc màu nền — đổi sang `clearColor` (màu trong, `view.alpha` vẫn 1 sau fade-in) không đổi rect miễn trừ, không đổi hành vi shield.

Tương tự, hai nơi khác đọc `pane.picker` theo **tồn tại** chứ không theo màu: tầng tự tham chiếu trong `slotOccupied:` (`SplitA.m:475`) và các guard `pane.picker != nil` rải rác (`Picker.m:227, 284, 290, 469, 703, 747, 757, 819, 1056`; `Panel.m:165`; `Chrome.m:478`). Tất cả bất biến với thay đổi màu nền.

### 4.5 Chạm không xuyên qua placeholder kể cả khi nền là `clearColor`

Lập luận theo cơ chế hit-test của UIKit đối chiếu với trạng thái thật của view này (phần "cơ chế UIKit" là ngữ nghĩa nền tảng, phần "trạng thái" là dòng nguồn):

- Hit-test của `UIView` quyết định bởi: view không `hidden`, `userInteractionEnabled == YES`, `alpha` của **view** trên ngưỡng bị bỏ qua (0,01), và điểm nằm trong bounds (`pointInside:`). Nó **không** kiểm tra `backgroundColor` — một view có nền trong suốt hoàn toàn vẫn nhận hit như thường. `clearColor` đổi kết quả *vẽ*, không đổi kết quả *hit*.
- Trạng thái của placeholder sau tạo: frame phủ toàn ô (`Picker.m:170`), `alpha` được animate về 1 (`Picker.m:202-204` — không phải 0), không bị set `userInteractionEnabled = NO` ở bất cứ đâu trong `Picker.m`, được gắn sau host vào `pane.view` (`Picker.m:199`, so với host ở `SplitA.m:1437`) nên thắng hit-test trong pane (chỉ `pane.handle` ở trên nó). Nhãn `"+"` con của nó là `UILabel` (mặc định không nhận tương tác) nên hit rơi xuống chính picker.
- Trên picker có sẵn tap recognizer (`Picker.m:195-198`): chạm vào vùng ô khi sheet đang mở sẽ đi vào `pickerPaneTapped:` (§4.2) thay vì rơi xuống content trong host ở dưới.

Vì vậy sau sửa: **nhìn xuyên được, chạm không xuyên** — đúng yêu cầu. Cảnh báo cho người implement: **không** được "sửa" bằng cách đặt `picker.alpha = 0`, `hidden = YES` hay `userInteractionEnabled = NO` để đạt độ trong — ba cách đó phá lần lượt shield-exempt (§4.4, lọc `alpha == 0`), tư cách sheet và đường chạm mở sheet. Chỉ `backgroundColor` là vô hại với cả ba.

---

## 5) Điểm sửa chính xác

### 5.1 Trước / sau

**Chỗ 1 — chụp phép thử (chèn 1 dòng mới sau `Picker.m:161`, trước `Picker.m:162`):**

```objc
    [self removePickerFromPane:pane];              // Picker.m:160 (giữ nguyên)
    [self removeLoaderFromPane:pane animated:NO];  // Picker.m:161 (giữ nguyên)
    // [M4] chụp TRƯỚC khi placeholder mới được gán (dòng pane.picker = …):
    // tại đây pane.picker đang nil đồng bộ nên slotOccupied: rút gọn thành
    // vc || pending — đúng biểu thức pickerCancel: dùng tại Picker.m:837.
    BOOL hasContent = (pane.vc != nil || [self slotOccupied:pane.slot]);
    UIView *picker = [[UIView alloc] init];        // Picker.m:162 (giữ nguyên)
    pane.picker = picker;                          // Picker.m:163 (giữ nguyên)
```

**Chỗ 2 — điều kiện hoá phép gán màu (`Picker.m:171-174`):**

Trước (HEAD):

```objc
    picker.backgroundColor = [UIColor colorWithRed:0.9333333333333333
                                             green:0.9411764705882353
                                              blue:0.984313725490196
                                             alpha:1.0];
```

Sau (đặc tả):

```objc
    picker.backgroundColor = hasContent
        ? UIColor.clearColor
        : [UIColor colorWithRed:0.9333333333333333
                          green:0.9411764705882353
                           blue:0.984313725490196
                          alpha:1.0];
```

Không dòng nào khác thay đổi. Tổng diff dự kiến: +1 dòng chụp biến (kèm comment) và 1 phép gán thành ternary, tất cả trong `showPickerForSlot:`.

### 5.2 Bảng trạng thái trước/sau

| Ô | Trước sửa | Sau sửa |
|---|---|---|
| Có app (vc ≠ nil) | Nền đặc rgb(0.9333, 0.9412, 0.9843) alpha 1 phủ toàn ô; content trong host bị che; sheet vẫn mở | Placeholder vẫn tạo đủ cấu trúc; nền `clearColor` → content trong `pane.host` hiện xuyên qua nền; còn dấu `"+"` + border đè lên; chạm vào ô vẫn vào `pickerPaneTapped:`, không xuyên xuống app; sheet/guard/shield như cũ |
| Đang pending launch | Đặc (che cả loader-stage) | `clearColor` (parity với `pickerCancel:`); thấy nền tối `pane.view` + `"+"`, chưa có hình app |
| Chỉ bundleID / trống thật | Đặc | **Đặc — không đổi** (đây là regression guard chính) |

### 5.3 Rủi ro còn lại nếu phép thử chọn sai ở ca biên

1. **Sai vị trí chụp (rủi ro lớn nhất, đã nêu §2.2):** đánh giá `slotOccupied:` tại/sau dòng gán màu → luôn YES do tự tham chiếu (`SplitA.m:475`) → ô trống cũng trong → mất nền đặc cho ô trống, dấu `"+"` trôi trên nền tối của pane, và kịch bản xe "ô trống vẫn nền đặc" fail. Kiểm soát: diff phải cho thấy dòng chụp nằm **trên** dòng `pane.picker = picker;`.
2. **Chỉ dùng `pane.vc`:** ca pending bị sơn đặc — lệch khỏi `pickerCancel:` (cancel giữ pane, màu lại nói trống). Mức hại thấp, khu trú ở giai đoạn launch.
3. **Chỉ dùng `pane.bundleID`:** ca bundle-đơn-độc bị sơn trong khi không có gì sau nó — mâu thuẫn cảnh báo của chính gốc ở `SplitA.m:415-418`.
4. **Dùng `host.subviews`:** ô trống còn view sót bị phơi ra (§2.3b) — hướng hại ngược với mục tiêu che phủ an toàn.
5. **Rủi ro chấp nhận (không do chọn sai mà do giới hạn phép thử trạng thái):** vc còn nhưng scene/view chết (§2.3c) → nền trong trên một ô không có hình; pending quá 12 s → nền đặc dù launch có thể vẫn đang chạy (§2.3d). Cả hai đều giữ parity với cách gốc tự phán occupied, nên bản sửa không tạo ra phân kỳ mới giữa màu nền và quyết định huỷ/chọn.

---

## 6) Cách kiểm tra

### 6.1 Tĩnh (trên bản đã implement, trước khi lên xe)

1. `git diff` chỉ chạm `Picker.m`, chỉ trong thân `showPickerForSlot:`: đúng 2 chỗ ở §5.1; không đổi `Picker.m:183-204` (label/recognizer/addSubview/fade), không đổi `Picker.m:208-217`, `281-310`, `321+`, `831-850`, không đổi `Chrome.m:388-395`.
2. Đọc thứ tự trong diff: dòng chụp `hasContent` đứng **trước** dòng `pane.picker = picker;`; biểu thức chụp giống hệt `Picker.m:837` (`pane.vc != nil || [self slotOccupied:…]`).
3. Grep lại: vẫn đúng 1 phép gán `picker.backgroundColor` trong cây; hằng màu đặc vẫn xuất hiện ở nhánh `:` của ternary (ô trống không bị mất màu gốc); không xuất hiện `picker.alpha = 0` / `picker.hidden` / `picker.userInteractionEnabled` mới nào.
4. Bảng chân trị §2.2 đối chiếu tay với 4 trạng thái (vc / pending / bundle-only / trống) — kỳ vọng YES, YES, NO, NO.

### 6.2 Xe — bước 2 của kịch bản GPT (một lần gộp)

1. **Ô có app:** mở một app vào ô đích → từ bar của ô (hoặc action thay app phía bridge) mở picker. Kỳ vọng: sheet hiện; vùng ô đích **không còn trắng** — thấy nội dung app xuyên qua nền placeholder; vẫn thấy dấu `"+"` và border của ô đang được chọn; chạm vào vùng ô đích làm sheet refresh/đổi đích (đường `pickerPaneTapped:`), **không** thao tác trúng app bên dưới.
2. **Huỷ:** bấm chip huỷ trên sheet ở ô có app → placeholder biến mất (sau fade 0,15 s), app và pane còn nguyên, chỉ relayout. Lặp lại ở ô trống → placeholder biến mất và pane trống bị gỡ (hoặc cửa sổ nổi đóng) như hành vi gốc; chờ quá 0,15 s rồi nhìn lại: không còn lớp phủ/`"+"` sót trên ô.
3. **Chọn app:** mở picker ở ô đích, chạm một app khác → placeholder được gỡ qua `openApp:`, app mới vào ô (qua loader nếu native), sheet đóng khi không còn ô nào giữ picker.
4. **Ô trống (regression guard):** mở picker cho ô chưa có app → nền ô vẫn **đặc** đúng màu cũ, không thấy xuyên ra phía sau. Nếu bước này fail trong khi bước 1 pass, nghi ngờ đầu tiên là bẫy vị trí chụp ở §5.3.1 (đánh giá sau khi gán `pane.picker`).

---

## Nhãn kết luận

**SOURCE-PROVEN** — cho: điểm tạo và phép gán màu duy nhất (`Picker.m:155-205`, gán tại 171-174), thứ tự placeholder-trước-sheet và vai trò eligibility của `pane.picker` (`Picker.m:281-310`), định nghĩa cả bốn ứng viên và phép thử được chọn kèm cửa sổ thời gian bắt buộc (parity từng dòng với `pickerCancel:` tại `Picker.m:836-837` và `slotOccupied:` tại `SplitA.m:471-479`), bốn đường qua điểm tạo, và việc `pane.picker` không thuộc vị từ popup/fullscreen nào (`Chrome.m:388-395`; `SCPFullscreenController.m:348-350`). Tất cả đã đọc lại trên HEAD `38735c5`.

**PENDING-DEVICE** — cho: hiệu quả nhìn xuyên trên xe thật (content native và hosted hiện qua nền `clearColor`), cảm giác chạm không xuyên trên phần cứng CarPlay, và không còn lớp phủ sót sau huỷ/chọn — chỉ chốt được bằng kịch bản §6.2.

Không có mục nào STUCK: mọi ẩn số quyết định kết quả đều nằm trong nguồn đã đọc ở HEAD này; ẩn số duy nhất còn lại là hành vi hiển thị trên xe, vốn là nghiệm thu, không phải thiết kế.
