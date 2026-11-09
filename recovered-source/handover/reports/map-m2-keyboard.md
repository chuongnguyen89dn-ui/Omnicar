# MAP M2 — BÀN PHÍM: 4 TUYẾN + CỔNG THỐNG NHẤT + KHẢ THI PHÍM HỆ THỐNG

- Loại việc: **chỉ-đọc, bản đồ + khả thi**. Không sửa file nguồn nào. Không build.
- Cây nguồn: `~/workspace/push9-clone/recovered-source/src/`, HEAD thật `38735c5` (đã kiểm `git log` trực tiếp). Mọi `file:line` dưới đây grep/read trực tiếp từ HEAD này.
- Hiệu chỉnh số dòng so với bối cảnh vòng trước: `ABSuppressSystemKeyboard` ở **ABInApp.m:1720** (khớp), thân blanking **:1720–1728** (bối cảnh cũ ghi ~1573–1615 — SAI số dòng ở HEAD này; vùng 1540–1615 là `ABOrientationBlock`/`ABKeyBlock`, không chứa inputView), phục hồi **:1741–1751**, `ABKeyboardPublish` khai báo ABInApp.m:86, định nghĩa **:1782**, consumer chết ABChannels.m:358 (khớp).

Quy ước nhãn bằng chứng: **[SOURCE-PROVEN]** = đọc nguyên văn tại file:line nêu kèm · **[SUY LUẬN]** = suy luận có căn cứ, ghi rõ căn cứ · **[CHỈ-XE-MỚI-BIẾT]** = nguồn không quyết được, cần đo trên xe.

---

## TUYẾN 1 — inputView: blank / thay / phục hồi + quyền sở hữu

### Điểm hiện tại (file:line)

Toàn cây chỉ có **3 điểm chạm `setInputView:`**, tất cả trong ABInApp.m (grep toàn cây xác nhận, không điểm nào ở ABHost*/ABKeyboard/SplitScreen):

| Điểm | Vị trí | Nội dung |
|---|---|---|
| Blank (thay) | ABInApp.m:1720–1728 `ABSuppressSystemKeyboard` | `if (ABForcedOrientation < 1) return;` (:1721) → `if (!respondsToSelector(setInputView:)) return;` (:1722) → `if ([responder inputView] != nil) return;` (:1723) → tạo `UIView` frame `CGRectZero` (:1724), `[responder setInputView:blank]` (:1725), gắn marker (:1726–1727) |
| Marker sở hữu | ABInApp.m:1718 + :1726–1727 | `static const void *ABBlankInputViewKey = &ABBlankInputViewKey;` — associated object `kCFBooleanTrue`, policy `OBJC_ASSOCIATION_ASSIGN`, gắn lên chính responder |
| Phục hồi (duy nhất) | ABInApp.m:1741–1751 `ABResponderResigned` | `if (objc_getAssociatedObject(responder, ABBlankInputViewKey))` (:1742) → xoá marker (:1743) → `[responder setInputView:nil]` (:1744) |

Các điểm GỌI suppress (chỉ 2 họ responder được hook):
- ABInApp.m:1756 `ABHook_TFBecome` (UITextField becomeFirstResponder): suppress TRƯỚC orig.
- ABInApp.m:1767 `ABHook_TVBecome` (UITextView): chỉ khi `self.isEditable`.

Các điểm GỌI phục hồi: phục hồi chỉ chạy qua `ABResponderResigned`, được gọi từ ABInApp.m:1761 (`ABHook_TFResign`, sau orig thành công) và :1773 (`ABHook_TVResign`). Đường gián tiếp: ABInApp.m:1566 — khi host thả app (orientation ≤ 0 trong `ABOrientationBlock`), code ép `[ABCurrentResponder resignFirstResponder]` → chạy qua hook resign → phục hồi + publish NO.

Không có điểm phục hồi nào khác: không `reloadInputViews` ở bất cứ đâu trong cây (grep = 0 kết quả); không phục hồi theo sự kiện close/closeall (ABInApp.m:1667–1678 chỉ gọi `BWResetAll`/`YZResetAll`, không đụng inputView).

### Nguyên nhân / kết luận sở hữu

**Kết luận dứt khoát: yêu cầu "chỉ phục hồi inputView do tweak thay" ĐÃ CÓ dữ kiện phân biệt trong nguồn [SOURCE-PROVEN].** Registry sở hữu chính là associated-object marker `ABBlankInputViewKey` trên từng responder (ABInApp.m:1718, 1726). Phục hồi hiện tại **không phải vô điều kiện, không phải theo class**: nó có điều kiện kép — (i) marker còn trên đúng responder đó (:1742), (ii) responder đó resign thành công qua hook TF/TV (:1761/:1773).

Ba hệ quả cấu trúc phải ghi rõ:

1. **Phục hồi = `setInputView:nil` là ĐÚNG nguyên gốc, không phải mất dữ kiện** [SOURCE-PROVEN]: suppress chỉ blank khi `inputView == nil` sẵn (:1723) — inputView gốc luôn là nil (phím hệ thống mặc định) tại thời điểm blank, nên không có "inputView gốc" nào bị lưu mất. Responder nào đã có inputView tuỳ biến (≠ nil) thì tweak **không bao giờ blank và không bao giờ phục hồi** — tự nó đã ngoài vòng.
2. **Lỗ hổng phục hồi theo thời gian** [SOURCE-PROVEN về cơ chế, hệ quả là SUY LUẬN]: nếu responder bị blank mà không bao giờ resign qua 2 hook trên (bị dealloc khi đang FR, app tự đổi FR nội bộ không qua TF/TV, hoặc responder thuộc class khác có `setInputView:` nhưng không được hook — vd UISearchTextField là subclass UITextField nên hưởng hook TF; một UIResponder tuỳ biến tự cài `inputView` thì không), marker + blank view ở lại tới khi responder chết. `ABCurrentResponder` là `__weak` (ABInApp.m:67) nên không giữ responder sống để phục hồi hộ.
3. **Thứ tự resign**: `ABResponderResigned` phục hồi inputView TRƯỚC, rồi mới — nếu responder là `ABCurrentResponder` — publish NO (:1746–1750). Khi lật cổng (mục Cổng), thứ tự này là mẫu để bắt chước.

### Điểm sẽ sửa (cho vòng triển khai sau — bản đồ chỉ vị trí, không sửa ở vòng này)

- Cổng bọc tại `ABSuppressSystemKeyboard` ABInApp.m:1720: thêm early-return khi cổng NATIVE bật → không blank, không gắn marker. Mọi responder trở thành FR sau đó giữ `inputView == nil` tự nhiên = phím hệ thống.
- Điểm phục hồi-khi-lật-cổng: tái dùng đúng khối :1742–1744 áp lên `ABCurrentResponder` (ABInApp.m:67) tại handler chuyển chế độ phía app (xem mục Cổng) — KHÔNG viết cơ chế phục hồi thứ hai.

### Trạng thái trước / sau

- Trước: hosted + FR (TF/editable TV) → inputView = blank view + marker; resign → inputView = nil + marker xoá.
- Sau (cổng NATIVE): hosted + FR → inputView giữ nil từ đầu, không marker; resign → khối phục hồi no-op tự nhiên (marker không có).

### Cách kiểm tra

- Tĩnh: grep `setInputView` toàn cây vẫn đúng 3 điểm; cổng chỉ thêm 1 early-return tại :1720 và 1 lời gọi khối phục hồi hiện có.
- Xe: theo kịch bản 3 bước ở cuối biên bản (mở phím hosted → hiện trên xe → gõ được → đóng được), cộng log `ban phim xe:` phía host phải KHÔNG xuất hiện khi cổng NATIVE bật (xem Tuyến 2).

**Nhãn tuyến 1: SOURCE-PROVEN** (cả bản đồ điểm và kết luận sở hữu).

---

## TUYẾN 2 — Phát yêu cầu: `ABKeyboardPublish` + toàn cây publisher/consumer của `appbridge.keyboard`

### Điểm hiện tại (file:line)

Định dạng đóng gói đã chứng minh (AppBridgeB.h:39–44, khớp thân hàm):

```
bit 0        shown
bits 1..7    UIKeyboardType
bits 8..15   UIReturnKeyType
bits 24..55  FNV-1a-32(bundleID) << 24
```

Publisher duy nhất toàn cây: `ABKeyboardPublish` ABInApp.m:1782–1799 — `notify_register_check(ABNotifyKeyboard, &ABKeyboardToken)` (:1783–1784; token static ABInApp.m:70), `notify_set_state` (:1795 trong thân — state dựng :1786–1794), `notify_post(ABNotifyKeyboard)` (:1795). Tên kênh: ABChannelNames.m:40 `com.anlai.omnicar/appbridge.keyboard`.

Hai điểm gọi publisher (toàn cây, grep đủ):

| Điểm gọi | Vị trí | Giá trị |
|---|---|---|
| FR thành công | ABInApp.m:1734 trong `ABResponderBecame` | `ABKeyboardPublish(YES, responder)` — traits lấy từ responder |
| FR resign (đúng current) | ABInApp.m:1748 trong `ABResponderResigned` | `ABKeyboardPublish(NO, nil)` — chỉ khi `ABCurrentResponder == responder` (:1746) |

Bảng publisher → consumer toàn cây (grep cả AppBridgeA, AppBridgeB, SplitScreenA/B/C, App: chỉ 2 consumer đăng ký kênh này):

| Consumer | Vị trí | Giải mã | Trạng thái |
|---|---|---|---|
| `ABKeyboardDispatch` (host, SpringBoard) | đăng ký ABHostGeometry.m:187–189; thân :209–232 | `bundleForHash:(state >> 24)` (:213) — **khớp packing**; bit 0 = 0 → `hideForApp:` (:220), = 1 → `showForApp:keyboardType:returnType:` với `(state>>1)&0x7F`, `(state>>8)&0xFF` (:224–226) | **SỐNG** — consumer thật duy nhất |
| Consumer trong ABChannels.m | ABChannels.m:358–368 | `bundleForHash:(uint32_t)state` (:363) — lấy **32 bit thấp** (shown/type/return + 8 bit thấp của hash) đem so với hash đầy đủ → gần như không bao giờ khớp; và kể cả khi khớp, nó **chỉ gọi `hideForApp:`** (:366), bất kể bit shown | **CHẾT KÉP**: (1) nằm trong khối `#if 0` bắt đầu ABChannels.m:219 ("dead duplicate installer… kept as reference text only", :217–219) — không biên dịch, không đăng ký; (2) giải hash sai như trên |

SplitScreen/App: **không** có publisher/consumer nào của `appbridge.keyboard` (grep toàn cây xác nhận) — owner CarPlayApp không nghe kênh này trực tiếp; nó chỉ nhận kb qua kb-sync (Tuyến 3/4).

### Nguyên nhân + hệ quả nếu "sửa packing" ở :358 (ĐẶC TẢ CẤM — ghi để khoá)

Nếu ai sửa :363 thành `(state >> 24)` và/hoặc gỡ `#if 0`: consumer này thành hide-only **sống** — mọi publish, kể cả `shown=1` vừa mở panel, sẽ kéo theo một `hideForApp:` cho cùng app trên cùng main queue. Panel vừa `showForApp:` (consumer sống, ABHostGeometry.m:224) vừa bị hide bởi consumer hồi sinh: thứ tự chạy phụ thuộc thứ tự đăng ký notify — hành vi thành "panel chớp/tắt ngẫu nhiên theo thứ tự registrar", và vì nó không qua funnel kb-sync (Tuyến 3), bản ghi session phía host/owner còn lệch thêm một tầng. **Giữ nguyên :358 như văn bản tham chiếu chết; mọi sửa cho cổng phải làm ở publisher (ABInApp) và consumer sống (ABHostGeometry), không đụng ABChannels.m.**

### Điểm sẽ sửa

- Phía app: khi cổng NATIVE bật, `ABResponderBecame` ABInApp.m:1731–1738 **không gọi** `ABKeyboardPublish(YES, …)` nữa (bọc tại điểm gọi :1734 hoặc đầu `ABKeyboardPublish` :1782 — bọc tại điểm gọi giữ nguyên hàm cho đường panel). Nếu không bọc: host vẫn mở panel phủ lên phím hệ thống vừa hiện → hai phím cùng lúc [SUY LUẬN từ cấu trúc hai đường độc lập, không có khoá lẫn nhau trong nguồn].
- Phía host (phòng thủ hai lớp): `ABKeyboardDispatch` ABHostGeometry.m:209 đọc cổng trước nhánh show (:223–228) — cổng NATIVE thì không show, và nếu panel đang sống cho app đó thì hide + phát kb-sync NO qua funnel (Tuyến 3).

### Trạng thái trước / sau

- Trước: FR become → publish YES → dispatch show panel; FR resign → publish NO → dispatch hide panel.
- Sau (NATIVE): FR become/resign → **không publish nào trên kênh keyboard**; dispatch (nếu nhận publish lạ/stale) → không show.

### Cách kiểm tra

- Tĩnh: bảng trên là toàn bộ bề mặt kênh; vòng sửa không được thêm publisher/consumer mới, không sửa ABChannels.m:358–368.
- Xe: cổng NATIVE — log host không có dòng `ban phim xe: hien cho …` (ABKeyboard.m:307–309) khi chạm ô chữ trong app hosted; log app không có `ban phim xe: hien` của `ABKeyboardPublish` (ABInApp.m:1796–1798).

**Nhãn tuyến 2: SOURCE-PROVEN.**

---

## TUYẾN 3 — Host hiện/ẩn panel + funnel kb-sync

### Điểm hiện tại (file:line)

Panel là `ABKeyboard` (SpringBoard): `showForApp:keyboardType:returnType:` ABKeyboard.m:276–311 (điều kiện: `carWindow != nil` :277–281; panel gắn vào carWindow :294, `bringSubviewToFront` :296), `hideForApp:` ABKeyboard.m:323–342 (nil = force; app khác → no-op :324–325).

Mọi điểm show/hide panel toàn cây:

| # | Điểm | Vị trí | Qua funnel kb-sync? |
|---|---|---|---|
| S1 | Dispatch show | ABHostGeometry.m:224–228 | Có — `ABKbSyncNoteEvent(bundleID, YES)` :228 |
| H1 | Dispatch hide (publish NO) | ABHostGeometry.m:220–222 | Có — `ABKbSyncNoteEvent(bundleID, NO)` :222 |
| H2 | `closeApp:terminate:` teardown | ABHostLaunch.m:254–261: `hideForApp:` :257 + `ABKbSyncNoteEvent(bundleID, NO)` :261 (comment :258–260 tự ghi "bypass ABKeyboardDispatch nên phải tự sync") | Có (tự phát bù) |
| H3 | Ngắt CarPlay — `ABCarPlayChanged` | ABHostGeometry.m:256–259: chụp `abKbLiveBundle` :256, `hideForApp:nil` (force) :258, `if (kbBundle) ABKbSyncNoteEvent(kbBundle, NO)` :259; sau đó `carDisconnected` :260 (thân ABHostBMethods.m:924–935 — tự nó KHÔNG ẩn panel, chỉ teardown pane + ẩn/thả window) | Có |
| H4 | Nút ẩn trên panel — `hideTapped` | ABKeyboard.m:435–438: `send:@"dismiss"` (app resign FR → publish NO → H1 chạy) + `hideForApp:nil` :437 | **Chỉ gián tiếp**: kb-sync NO đến từ H1 *nếu* app còn FR và resign chạy qua hook; bản thân `hideForApp:nil` tại :437 không phát kb-sync và **không xoá `abKbLiveBundle`** — nếu chuỗi resign không xảy ra (app đã mất FR trước đó), bản ghi session sống sót tới snapshot kế tiếp (xem (d) ở phần Khả thi) **[SOURCE-PROVEN về thiếu funnel; kịch bản sót là SUY LUẬN]** |
| S2 | — | Không có điểm show thứ hai: grep `showForApp` toàn cây chỉ ABHostGeometry.m:224 gọi thật (còn lại là khai báo ABKeyboardDecl.h:32 / ABKeyboard.m:88) | — |

Funnel kb-sync (máy [ytz4-hb], MỚI, không thuộc binary gốc — ABHostGeometry.m:66–82):
- Bản ghi session sống duy nhất phía host: `abKbLiveBundle` / `abKbLiveSession` / `abKbSessionCounter` ABHostGeometry.m:84–86.
- `ABKbSyncNoteEvent(bundleID, active)` ABHostGeometry.m:99–114: active → counter++, ghi live bundle/session; inactive + khớp live bundle → lấy session id rồi xoá live (:107–111); luôn kết bằng `ABKbSyncPost` (:113).
- `ABKbSyncPost` ABHostGeometry.m:88–97: NSDistributed `ABChanKbSync` = `com.anlai.omnicar/appbridge.kbsync` (ABChannelNames.m:38), object nil, userInfo `{identifier, kbactive, kbsession, kbsource: "host-keyboard-session"}` + log `[kb-sync] host post …`.
- Snapshot lúc mở pane: `ABKbSyncSnapshotForApp` ABHostGeometry.m:121–127 (active chỉ khi app sở hữu live session), gọi từ `ABOpenBlock` ABHostGeometry.m:390 — post **trực tiếp qua `ABKbSyncPost`**, không qua NoteEvent (không đổi bản ghi, chỉ phát lại sự thật hiện có).
- Đầu nhận phía owner (CarPlayApp): SCPCarSplit+BridgeWake.m — observer đăng ký :888–891, `bwHandleKbSyncNote:` :302–340 lưu theo slot (`bwKbKnownBySlot/bwKbActiveBySlot/bwKbSessionBySlot`, :82–90), phát lại cho app bằng packet type 6 qua `BWEmitKbPacket` :189–205.

### Nguyên nhân

Mọi đường hide "có kỷ luật" đều đã funnel hoá, trừ H4 (nút ẩn tự thân của panel) — nó dựa vào chuỗi resign của app để H1 phát kb-sync thay. Đây là điểm yếu có sẵn, độc lập với cổng: cổng NATIVE **không được** bắt chước H4; điểm đóng panel khi lật cổng phải đi qua đúng mẫu H3 (chụp live bundle → force-hide → NoteEvent NO).

### Điểm sẽ sửa

- Khi cổng lật sang NATIVE (phía host, handler pref-changed — mục Cổng): nếu `abKbLiveBundle != nil`: `[[ABKeyboard shared] hideForApp:nil]` + `ABKbSyncNoteEvent(abKbLiveBundle, NO)` — chép đúng mẫu ABHostGeometry.m:256–259.
- Khi cổng lật về PANEL: không cần hành động host (panel sẽ tự mở ở publish YES kế tiếp); phía app tự khôi phục chế độ suppress ở FR become kế tiếp (Tuyến 1).

### Trạng thái trước / sau

- Trước: 4 đường hide (H1–H4), 3/4 qua funnel; 1 đường show duy nhất (S1) qua funnel.
- Sau: thêm 1 đường hide H5 (lật cổng) — bắt buộc qua funnel như H3; H4 giữ nguyên (không thuộc phạm vi cổng, nhưng ghi nợ rõ ở đây).

### Cách kiểm tra

- Tĩnh: grep `hideForApp` — mọi điểm gọi mới phải đứng cạnh một `ABKbSyncNoteEvent(…, NO)` trong cùng khối.
- Xe: lật cổng khi panel đang hiện → log có `[kb-sync] host post <bundle> active=0 … source=host-keyboard-session` (ABHostGeometry.m:95–96) ngay tại thời điểm lật, panel biến mất, owner phát packet kb type 6 known=1 active=0 cho app đó.

**Nhãn tuyến 3: SOURCE-PROVEN** (riêng kịch bản sót kb-sync của H4 khi app đã mất FR: SUY LUẬN CÓ CĂN CỨ — cơ chế thiếu funnel là proven, tần suất xảy ra chưa đo).

---

## TUYẾN 4 — FR tracking phía app + kb-sync vào `BWKbEffective`

### Điểm hiện tại (file:line)

**Theo dõi first-responder (toàn bộ bề mặt):**

| Thành phần | Vị trí | Vai trò |
|---|---|---|
| Biến tracked | ABInApp.m:67 `__weak id ABCurrentResponder` | responder FR hiện tại của app hosted |
| Hook become | ABInApp.m:1754–1758 (TF), :1765–1770 (TV editable) | suppress trước orig; orig OK → `ABResponderBecame` |
| `ABResponderBecame` | ABInApp.m:1731–1738 | cổng `ABForcedOrientation < 1` → return (:1732); `ABCurrentResponder = responder` (:1733); publish YES (:1734); `BWKbLocalSet(BWKbActive)` (:1735) |
| Hook resign | ABInApp.m:1759–1763 (TF), :1771–1775 (TV) | orig OK → `ABResponderResigned` |
| `ABResponderResigned` | ABInApp.m:1741–1752 | phục hồi inputView (Tuyến 1); nếu là current: nil hoá (:1747), publish NO (:1748), `BWKbLocalSet(BWKbInactive)` (:1749) |
| Ép resign khi host thả app | ABInApp.m:1566 | orientation ≤ 0 → resign current → toàn chuỗi trên chạy |
| Reset phiên | ABInApp.m:901 `BWResetAll` | `BWKbLocalSet(BWKbUnknown)` + xoá owner snapshot (:904–907) |

**Nguồn phụ (notification) — đăng ký ABInApp.m:867–872 trong `BWInstallBridgeWake`:**
- `UIKeyboardWillShowNotification` + `UIKeyboardDidChangeFrameNotification` → `BWKbFrameNote` ABInApp.m:566–572: chỉ `BWKbLocalSet(BWKbActive)` khi frame end có `0 < origin.y < chiều cao màn hình` (frame "đậu" bị bỏ qua).
- `UIKeyboardWillHideNotification` → `BWKbHideNote` ABInApp.m:573–577 (xem dưới).

**Mọi điểm gán kb local** — tất cả qua setter duy nhất `BWKbLocalSet` ABInApp.m:436–440 (gán `BWKb` + đóng dấu `BWKbLocalChangedAt`, no-op khi trùng giá trị):

| Điểm gán | Vị trí | Giá trị |
|---|---|---|
| `ABResponderBecame` | :1735 | Active |
| `ABResponderResigned` (chỉ current) | :1749 | Inactive |
| `BWKbFrameNote` | :571 | Active |
| `BWKbHideNote` | :576 | Inactive — **có điều kiện** (dưới) |
| `BWResetAll` | :901 | Unknown |

**Điểm Unknown→Inactive duy nhất** [SOURCE-PROVEN]: ABInApp.m:576 trong `BWKbHideNote`:

```objc
if (!ABCurrentResponder && BWKb == BWKbUnknown) BWKbLocalSet(BWKbInactive);
```

Ngoài điểm này, KHÔNG đường nào biến Unknown thành Inactive phía local: resign chỉ hạ từ phiên FR thật (mà become đã đặt Active trước), frame-note chỉ nâng Active, reset đưa về Unknown. Comment :573–575 ghi đúng ý đồ: hide-notification một mình không hạ Active — chỉ là "definitive not shown" khi không còn phiên responder nào và trạng thái chưa từng biết.

**`BWKbEffective` — ĐỌC NGUYÊN VĂN** (ABInApp.m:465–485, trích nguyên khối):

```objc
static NSInteger BWKbEffective(NSInteger *srcOut, long *ageMsOut) {
    NSTimeInterval now = BWNow();
    NSInteger src = BWKbSrcNone;
    long age = -1;
    NSInteger eff = BWKbUnknown;
    if (BWKb == BWKbActive) {
        eff = BWKbActive;
        src = BWKbSrcLocal;
        age = (long)((now - BWKbLocalChangedAt) * 1000.0);
    } else if (BWKbOwnerRxAt > 0
               && (now - BWKbOwnerRxAt) <= BWKbOwnerFreshWindow) {
        // A fresh sync governs even when its content is "owner does
        // not know": the sync is live, the state is honestly UNKNOWN.
        src = BWKbSrcOwner;
        age = (long)((now - BWKbOwnerRxAt) * 1000.0);
        if (BWKbOwnerKnown)
            eff = BWKbOwnerActive ? BWKbActive : BWKbInactive;
    }
    if (srcOut) *srcOut = src;
    if (ageMsOut) *ageMsOut = age;
    return eff;
}
```

**Chốt dứt khoát — local INACTIVE có tự thắng owner snapshot không: KHÔNG.** [SOURCE-PROVEN từ nguyên văn trên] Nhánh đầu chỉ kiểm `BWKb == BWKbActive`. Khi local = Inactive: rơi thẳng xuống nhánh owner — owner snapshot còn tươi (≤ 3.5 s) thì **owner quyết** (kể cả owner nói Active → effective = Active, src = Owner); owner stale/chưa từng có → effective = **Unknown** (src = None, age = −1), local Inactive bị bỏ qua hoàn toàn, không để lại dấu vết nào trong kết quả. Nói cách khác: local chỉ có quyền *nâng* lên Active; quyền *kết luận Inactive* thuộc về owner snapshot tươi, hoặc không thuộc về ai (Unknown).

**`kbSrc` được gán ở các điểm nào:**
- Định nghĩa enum: ABInApp.m:177 `enum { BWKbSrcNone = 0, BWKbSrcLocal = 1, BWKbSrcOwner = 2 };`
- Trong `BWKbEffective`: khởi `BWKbSrcNone` (:468), `BWKbSrcLocal` khi local Active thắng (:471), `BWKbSrcOwner` khi snapshot tươi quyết (:479) — xuất qua `srcOut` (:483).
- Điểm tiêu thụ/chốt mẫu cho log: `BWStartSequence` latch vào `BWSeqKbSrcAtStart` ABInApp.m:744–749; in ra ở `BWCloseSequence` :681–694 (chuỗi `"owner"/"local"/"none"` :681–682). Cờ act: `BWPostAct` dùng `BWKbEffective(NULL, NULL) == BWKbActive` (ABInApp.m:328) — chỉ Active thật mới đặt bit kb trong act packet.

**Ngưỡng tươi owner 3.5 s nằm ở:** ABInApp.m:432 `static const NSTimeInterval BWKbOwnerFreshWindow = 3.5;` (lý giải :424–431: vòng renew 1 s × tối đa 2 pane ≈ 2 s + 1 s lỡ nhịp + 0.5 s slack; quá hạn → Unknown, không bao giờ "nhớ Inactive"). Dùng tại :476. Snapshot owner vào tại `BWOnKbPacket` ABInApp.m:449–458 (packet type 6 trên kênh state: bit 9 = known, bit 8 = active; qua cổng hash28 + gen như state packet).

### Nguyên nhân

Thiết kế ytz4 K2 cố ý tước quyền kết luận Inactive của local để tránh lỗi cũ (Unknown giả danh "đã đo inactive"). Hệ quả cho cổng: khi panel tắt vì lật cổng, **app không tự biết** — bằng chứng Inactive phải đi đường owner: host phát kb-sync NO (Tuyến 3) → owner lưu + phát type 6 → `BWOnKbPacket` → `BWKbEffective` mới cho Inactive. Thiếu mắt này, cổng tạo ra INACTIVE giả kiểu ngược: panel đã tắt mà effective vẫn Active/Unknown dựa trên snapshot cũ (chi tiết ở (d) phần Khả thi).

### Điểm sẽ sửa

Không sửa `BWKbEffective`/setter ở vòng cổng. Điểm sửa duy nhất liên quan: bảo đảm đường phát kb-sync NO khi lật cổng (Tuyến 3, H5) để owner snapshot được làm tươi đúng sự thật.

### Trạng thái trước / sau

- Trước/sau như nhau về máy trạng thái: local {Unknown, Active, Inactive-có-điều-kiện}, effective = local-Active thắng tuyệt đối → owner-tươi quyết phần còn lại → Unknown.
- Sau lật cổng đúng quy trình: owner snapshot = known=1 active=0 còn tươi → effective Inactive (src=owner) — cổng logo thấy "kb inactive" thật, không phải giả.

### Cách kiểm tra

- Tĩnh: đối chiếu nguyên văn `BWKbEffective` ở trên với ABInApp.m:465–485 từng dòng trước khi triển khai; cấm sửa hàm này trong vòng cổng.
- Xe: probe log `[do] bw probe … kbKnown=1 kbActive=0 kbSrc=owner kbAge=<nhỏ>` (ABInApp.m:686–694) sau khi lật cổng — nếu thấy `kbSrc=local` hoặc `kbAge` lớn/−1 kéo dài, chuỗi kb-sync đã đứt.

**Nhãn tuyến 4: SOURCE-PROVEN.**

---

## CỔNG THỐNG NHẤT — cơ chế cả hai tiến trình cùng đọc được

### Mẫu sẵn trong cây (hai mẫu, chọn một chủ đạo)

**Mẫu A — CFPreferences domain `com.anlai.omnicar` (CHỦ ĐẠO, đề xuất dùng):**
- Domain: `kOMCPrefsDomain = CFSTR("com.anlai.omnicar")` OMCCommon/OMCCommon.h:36; `OMCPref` = `CFPreferencesCopyAppValue(key, domain)` không cache, đọc tươi mỗi lần gọi (OMCCommon/OMCCommon.c:122–125; khai báo OMCCommon.h:53–55); `OMCPrefsSync` = `CFPreferencesAppSynchronize(domain)` (OMCCommon.c:117–118).
- Cả hai phía đều đã link máy này: host đọc pref tại điểm cấp phát — `YZPrefEnabled` ABYTZoom.m:107–114 (`OMCPrefsSync()` rồi `OMCPref(ABYTPrefVirtualize, @YES)`, key khai báo ABYTZoom.m:37); phía panel tự ghi/đọc key của nó — `appBridgeKeyboardLang`: ghi bằng `CFPreferencesSetAppValue(…, CFSTR("com.anlai.omnicar"))` + `OMCPrefsSync()` ABKeyboard.m:417–419, đọc bằng `OMCPref` ABKeyboard.m:285.
- Tín hiệu đổi chế độ sẵn có: Darwin notify `com.anlai.omnicar/prefschanged` (OMCCommon.h:40; các controller Prefs `notify_post` sau khi ghi — vd Prefs/OMCPrefs/OMCAppBridgeAppsController.m:37,433). Phía host đã có handler mẫu hoàn chỉnh: `YZPrefsChangedCallback` ABYTZoom.m:628–632 (Darwin callback → hop main queue → đọc lại pref → grant/revoke ngay giữa phiên) + đăng ký `CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), …, CFSTR("com.anlai.omnicar/prefschanged"), …, DeliverImmediately)` ABYTZoom.m:676–680, wired từ ABChannels.m (mô tả :695–714).
- Phía app hosted: **chưa có** observer prefschanged nào trong ABInApp.m [SOURCE-PROVEN — Darwin/notify đăng ký trong file chỉ có BW state/ack ABInApp.m:859–865 và các NSDistributed observer :1652–1678]. Nhưng cùng TU đã có đủ idiom để thêm: `notify_register_dispatch` (Darwin, main queue) tại :859–865, và mẫu lease NSDistributed hai phía (Mẫu B) chứng minh app nhận lệnh host giữa phiên được.

**Mẫu B — NSDistributed lease kiểu ytlease (tham chiếu, không chọn làm cổng chính):** kênh `com.anlai.omnicar/appbridge.ytlease` ABYTLease.h:21, host phát (ABYTZoom.m, TTL 3.0 s ABYTLease.h:60, heartbeat 1 s), app nhận tại ABInApp.m:1660–1663 → `YZOnLease` :1249, hiệu lực qua `YZActive()` :976. Mạnh về "chết thì tự hết hạn" nhưng là kênh host→app một chiều theo bundle, không phải "cả hai phía cùng đọc một sự thật" như pref; và đặc tả vòng này yêu cầu mẫu pref/Darwin cả hai phía đọc được → Mẫu A là đáp án, Mẫu B chỉ là bằng chứng phụ rằng app hosted nhận thay đổi giữa phiên là việc cây đã làm được.

### Đề xuất cụ thể

- **Tên key:** `appBridgeNativeKeyboard` — theo đúng quy ước sẵn có: tiền tố `appBridge` + CamelCase như `appBridgeKeyboardLang`, `appBridgeOrientation`, `appBridgeFps`, `appBridgeZoom` (grep toàn cây). Giá trị BOOL; **vắng mặt = NO = chế độ panel hiện tại** (mặc định an toàn kiểu `YZPrefEnabled` nhưng giữ nguyên hành vi cũ khi chưa ai đặt key — cổng chỉ có tác dụng khi được bật tường minh).
- **Điểm đọc mỗi phía:**
  - App hosted: đầu `ABSuppressSystemKeyboard` ABInApp.m:1720 và điểm gọi publish ABInApp.m:1734 — đọc bằng `OMCPref(@"appBridgeNativeKeyboard", @NO)` sau `OMCPrefsSync()` theo đúng mẫu ABYTZoom.m:112–113. (Lưu ý hiện trạng: ABInApp.m **chưa gọi `OMCPref` ở đâu cả** — grep = 0 — nên đây là lần đầu TU này đọc pref; không có cache nào phải lo.)
  - Host (SpringBoard): đầu nhánh show của `ABKeyboardDispatch` ABHostGeometry.m:223 và trong handler pref-changed phía host (dưới).
- **Điểm quan sát chuyển chế độ mỗi phía:**
  - Host: đăng ký Darwin `prefschanged` mới theo nguyên mẫu ABYTZoom.m:676–680, cạnh registrar `ABSpringBoardReady` ABHostGeometry.m:159–195; handler theo mẫu `YZHandlePrefChanged` ABYTZoom.m:596–626: đọc lại pref → nếu NATIVE: đóng panel còn sống qua mẫu H3 (ABHostGeometry.m:256–259: force-hide + `ABKbSyncNoteEvent(live, NO)`); nếu về PANEL: không làm gì (publish YES kế tiếp tự mở lại).
  - App: thêm `notify_register_dispatch("com.anlai.omnicar/prefschanged", …)` trong `ABInstallInAppObservers`/khối cài hook (cạnh ABInApp.m:859–865); handler: nếu NATIVE → phục hồi inputView của `ABCurrentResponder` bằng đúng khối marker ABInApp.m:1742–1744 (responder vẫn là FR, phím hệ thống sẽ dựng lại trên inputView nil — việc dựng lại có cần `reloadInputViews` hay không: cây không có tiền lệ, xem (b)/(c) phần Khả thi) và từ đó suppress/publish ngừng hoạt động theo điểm đọc trên; nếu về PANEL → không ép phục hồi ngược (blank áp lại ở become kế tiếp; responder đang FR giữa chừng giữ phím hệ thống tới resign — hành vi suy ra từ cấu trúc hook, chấp nhận được và phải ghi vào hướng dẫn test).
- **Code phím cũ giữ nguyên bằng cách nào:** cổng chỉ **bọc** tại 4 điểm — (1) early-return đầu `ABSuppressSystemKeyboard` :1720, (2) bọc điểm gọi publish YES :1734, (3) bọc nhánh show `ABKeyboardDispatch` :223, (4) hai handler pref-changed mới. Không xoá, không sửa: `ABKeyboardPublish` :1782, panel ABKeyboard.m, consumer chết ABChannels.m:358, funnel kb-sync, `BWKbEffective`. Lật key về NO/absent → hành vi trở lại nguyên trạng vòng hiện tại, từng điểm bọc đều rơi về đường cũ.

**Nhãn cổng: cơ chế + điểm đọc/quan sát = SOURCE-PROVEN (mẫu đang chạy trong cây); tên key + vị trí bọc = ĐỀ XUẤT (chưa có trong nguồn).**

---

## CÂU HỎI KHẢ THI TRUNG TÂM — app hosted KHÔNG còn bị suppress thì sao?

### (a) Code gốc suppress CHÍNH XÁC cái gì?

**[SOURCE-PROVEN]** Chỉ một thứ duy nhất: **`inputView` của first responder** — thay bằng `UIView` rỗng `CGRectZero` tại ABInApp.m:1724–1725, chỉ với UITextField / UITextView-editable, chỉ khi đang hosted (`ABForcedOrientation >= 1`, :1721) và inputView đang nil (:1723).

Không suppress thêm gì cả [SOURCE-PROVEN bằng grep toàn cây]:
- Không đụng keyboard window, không hook/nuốt `UIKeyboard*Notification` nào trong đường suppress (các observer keyboard ở ABInApp.m:867–872 thuộc máy BridgeWake đo trạng thái, không chặn thông báo).
- Không đụng `inputAccessoryView`, `inputViewController`, `reloadInputViews` (0 kết quả toàn cây).
- Không chặn becomeFirstResponder: orig vẫn chạy sau suppress (ABInApp.m:1756–1757) — app vẫn thành FR bình thường, chỉ là FR đó mang inputView rỗng nên UIKit không dựng phím hệ thống.

### (b) Phím hệ thống của app hosted thuộc scene/cửa sổ nào, dự kiến hiện ở màn nào?

Căn cứ cấu trúc [SOURCE-PROVEN từng ý]:
1. Scene được host là scene của chính app, lấy qua **mainDisplaySceneManager**: `setupLiveAppViewForPane:` ABHostBMethods.m:1624–1626 (`SBSceneManagerCoordinator mainDisplaySceneManager`), tạo scene identity/handle/entity, `SBAppViewController` :1663–1670, view của VC được chèn vào `pane.box` trong cửa sổ SpringBoard trên màn xe (cửa sổ do `ensureWindow` dựng là `UIRootSceneWindow` trên CADisplay CarPlay — ABHostBMethods.m, khối `ensureWindow` ngay trước `carWindow` :1004–1007; panel phím vẽ cũng sống trong chính cửa sổ này, ABKeyboard.m:294).
2. App hosted chạy trong tiến trình của nó với scene đó là scene hiển thị; FR/inputView là việc của UIKit **trong tiến trình app**, gắn với cửa sổ FR thuộc scene đang active của app — tức cùng scene đang bị host.

**Dự kiến [SUY LUẬN CÓ CĂN CỨ]:** bỏ suppress → UIKit của app dựng phím hệ thống trong tiến trình app, trong cửa sổ phím thuộc scene hosted đó → hình phím được合成 qua FBScene vào `pane.box` → **hiện trên màn xe, bị kẹp trong khung pane** (không tràn cả màn xe như panel vẽ, panel vốn là subview của carWindow toàn màn). Khả năng hiện ở màn điện thoại: thấp theo cấu trúc — scene đang được trình diễn qua đường host xe, app không có scene điện thoại riêng nào được code dựng song song trong cây.

**Phần không quyết được [CHỈ-XE-MỚI-BIẾT / STUCK-PENDING-DEVICE]:** nguồn không chứa bất kỳ đường nào từng để phím hệ thống của app hosted xuất hiện, nên ba ẩn số sau **không có dữ kiện trong cây** và cấm kết luận thay:
- (i) iOS có dựng keyboard window cho một scene đang bị SpringBoard host chéo display như vậy không, hay phím bị hệ thống treo vì display identity của scene (main display) lệch với nơi scene thực trình diễn (màn xe)?
- (ii) Hình học phím: scene hosted bị ép hướng/zoom bởi máy orientation của ABInApp (ABForcedOrientation, fake device) — khung phím có khớp khung pane không, có bị xoay/co sai không?
- (iii) Chạm: phím nằm **bên trong** scene app (khác panel vẽ nằm ở cửa sổ SpringBoard) — chạm tới phím đi đường scene như chạm app thường, nhưng vùng phím có bị các lớp chrome/shield của host phủ không?
→ Muốn trả lời phải đo trên xe bằng đúng kịch bản 3 bước dưới đây. **Không gọi trạng thái này là "đã về phím CarPlay gốc"**: phím hệ thống của app hosted qua scene host — kể cả khi hiện và gõ được — là phím iOS của app trong khung pane, không phải phím CarPlay native của template hệ thống; nguồn không chứng minh được nó tương đương phím gốc ở bất kỳ điểm nào.

### (c) Nguồn trong cây quan sát được trạng thái phím HỆ THỐNG của app hosted?

- **Phía app — CÓ, sẵn [SOURCE-PROVEN]:** `BWKbFrameNote`/`BWKbHideNote` (ABInApp.m:566–577) đang nghe `UIKeyboardWillShowNotification`, `UIKeyboardDidChangeFrameNotification`, `UIKeyboardWillHideNotification` trong chính tiến trình app (đăng ký :867–872). Đây là thông báo phím **hệ thống** — hiện tại, khi suppress còn chạy, chúng gần như câm (comment :560–565 tự ghi: phím xe sống ở SpringBoard sau blank inputView nên thông báo hệ thống "may not fire at all in this process"). Khi bỏ suppress, đây là nguồn quan sát đầu tiên sẽ có dữ kiện thật — nhưng việc chúng **có thực sự bắn** trong scene hosted hay không thuộc ẩn số (i) ở (b): **[CHỈ-XE-MỚI-BIẾT]**.
- **Phía host (SpringBoard/ABHost) — KHÔNG [SOURCE-PROVEN bằng vắng mặt]:** không observer keyboard-notification nào, không đọc scene/keyboard state của app trong ABHostBMethods/ABHostGeometry/ABHostLaunch; host chỉ biết panel của chính nó (funnel kb-sync) và kênh Darwin do app phát. Bỏ suppress mà app không phát gì thay thế thì host mù hoàn toàn về phím hệ thống của app.
- **Phía owner (CarPlayApp/SplitScreen) — KHÔNG có nguồn phím hệ thống:** owner chỉ có kb-sync từ host (panel) → packet type 6 (SCPCarSplit+BridgeWake.m:302–340, :189–205). Không đường nào đưa trạng thái phím hệ thống của app lên owner.

### (d) Snapshot kb nào phải vô hiệu khi panel tắt vì cổng?

**[SOURCE-PROVEN về chuỗi, áp dụng là hệ quả trực tiếp]** Snapshot kb hiện tại phản ánh **panel vẽ**, theo chuỗi: funnel `ABKbSyncNoteEvent` (ABHostGeometry.m:99) → NSDistributed kb-sync → owner lưu theo slot (SCPCarSplit+BridgeWake.m:82–90) → type 6 → `BWOnKbPacket` (ABInApp.m:449) → `BWKbEffective` nhánh owner. Khi lật cổng NATIVE và đóng panel, **bắt buộc** phát `ABKbSyncNoteEvent(<live bundle>, NO)` tại thời điểm đóng (mẫu H3, ABHostGeometry.m:256–259) để:
- host xoá `abKbLiveBundle/abKbLiveSession` (:107–111) — nếu không, snapshot mở-pane kế tiếp `ABKbSyncSnapshotForApp` (ABHostGeometry.m:121–127, gọi :390) sẽ báo **active=YES giả** cho app vừa mở lại;
- owner cập nhật slot thành known=1 active=0 và phát type 6 mới — nếu không, owner giữ ACTIVE cũ và còn **phát lại** nó trong vòng renew, làm `BWKbOwnerRxAt` phía app luôn tươi: `BWKbEffective` trả Active (src=owner) vô thời hạn → cổng logo (BWGatePass, ABInApp.m:604–607) chặn nuốt chạm với lý do `kb` mãi mãi — "panel tắt" biến thành **ACTIVE giả**, đúng lỗi phải tránh (chiều ngược của INACTIVE giả thời ytz3).
Điểm phát kb-sync từ funnel panel là **điểm vô hiệu duy nhất cần chạm**: không sửa `BWKbEffective`, không sửa owner — chỉ cần sự kiện NO đi qua funnel đúng lúc lật cổng, như H3 đã làm cho ngắt xe.

### Kịch bản kiểm tra trên xe (gộp một lần, theo đúng 3 bước GPT)

1. **Mở phím hosted:** cổng NATIVE bật → mở app hosted có ô chữ (vd ô tìm kiếm), chạm vào ô → tiêu chí qua: phím **hiện trên màn xe** trong khung app, log app có `UIKeyboardWillShow` được `BWKbFrameNote` nuốt thành local Active (probe log `kbSrc=local`), log host **không** có `ban phim xe: hien cho`.
2. **Gõ được:** gõ vài ký tự (kể cả tiếng Việt bằng phím hệ thống) → chữ vào đúng ô của app, xoá được; đối chứng: tắt cổng (về panel) → cùng ô chữ mở panel vẽ như cũ, gõ qua panel vẫn vào chữ (đường ABChanKey nguyên trạng).
3. **Đóng được:** bấm nút đóng phím của app / chạm ngoài / resign → phím biến mất khỏi màn xe; ngay sau đó chạm một lần vào vùng controls đang ẩn → cổng logo nuốt đúng 1 chạm (không bị chặn bởi kb giả): log có `[kb-sync] host post … active=0` tại thời điểm lật cổng và probe `kbKnown=1 kbActive=0 kbSrc=owner`.

Nếu bước 1 không hiện phím ở bất kỳ màn nào → ẩn số (i) ở (b) ngã về "hệ thống không dựng phím cho scene hosted": ghi verdict PENDING-DEVICE tiếp cho hướng này, quay về panel (key về NO) — không có đường nguồn nào khác trong cây để ép phím hệ thống hiện.

---

## NHÃN TỔNG KẾT

| Hạng mục | Nhãn |
|---|---|
| Tuyến 1 — inputView + sở hữu (marker phân biệt được) | **SOURCE-PROVEN** |
| Tuyến 2 — publisher/consumer `appbridge.keyboard` (consumer :358 chết kép; cấm sửa packing) | **SOURCE-PROVEN** |
| Tuyến 3 — show/hide panel + funnel kb-sync (H4 thiếu funnel trực tiếp đã ghi nợ) | **SOURCE-PROVEN** (kịch bản sót của H4: SUY LUẬN) |
| Tuyến 4 — FR tracking + `BWKbEffective` (local Inactive KHÔNG tự thắng; Unknown→Inactive duy nhất :576; tươi owner 3.5 s :432) | **SOURCE-PROVEN** |
| Cổng thống nhất — mẫu pref `com.anlai.omnicar` + `prefschanged` hai phía | Cơ chế **SOURCE-PROVEN**; tên key `appBridgeNativeKeyboard` + 4 điểm bọc là **ĐỀ XUẤT** |
| Khả thi (a) suppress đúng cái gì | **SOURCE-PROVEN** — chỉ inputView |
| Khả thi (b) phím hệ thống hiện ở màn nào | **SUY LUẬN CÓ CĂN CỨ** (màn xe, trong khung pane) + **STUCK/PENDING-DEVICE** cho 3 ẩn số dựng/hình-học/chạm — thiếu dữ kiện xe, không lấp |
| Khả thi (c) quan sát được phím hệ thống | Phía app: có nguồn sẵn, việc nó có bắn hay không **CHỈ-XE-MỚI-BIẾT**; phía host/owner: **SOURCE-PROVEN là KHÔNG** |
| Khả thi (d) vô hiệu snapshot khi tắt panel | **SOURCE-PROVEN** — phát `ABKbSyncNoteEvent(live, NO)` qua funnel tại thời điểm lật cổng |

*Hết biên bản M2. Không file nguồn nào bị sửa; biên bản này là file duy nhất được ghi.*
