# FIX-G — Sửa guard fullscreen: chặn theo popup ĐANG HOẠT ĐỘNG, không theo tồn tại window

Mức đạt: **source complete / TU compile PASS / static PASS**. Build toàn module đang bị chặn bởi TU của strand khác (xem §5) — không thuộc phạm vi file của vòng này. Chưa có bằng chứng xe.

## 1. Bảng trạng thái thật của popup (đọc từ source, không suy đoán)

| Tín hiệu | Đặt ở | Xoá ở | Nghĩa thật |
|---|---|---|---|
| `trayWindow` (UIWindow*, SCPCarSplit.h:35) | `trayWindowForParent:` Picker.m:878–961 (tạo 1 lần, tái dùng) | CHỈ ở teardown SCPCarSplit.m:243–244 và khi đổi screen Picker.m:888 | Vật chứa dùng chung cho tray/sheet/menu/ghost/toast. **Tồn tại ≠ đang mở.** Tái dùng còn tự un-hide (Picker.m:884) nên cả `hidden` cũng không phải bằng chứng đóng/mở. |
| `tray` (UIView*) | showLayoutPanelForApp: (Panel.m) / mở app tray | nil ngay đầu `collapseAppTray` Picker.m:995 | View tray/panel đang trình bày. |
| `pickerSheet` (UIView*) | showPicker (Picker.m) | nil ngay đầu `removePickerSheet` Picker.m:647–653 (trước animation 0,22 s) | Picker sheet đang trình bày. |
| `ratioMenu` (UIView*) | RatioMenu.m:~437 | nil ngay đầu `hideRatioMenu` RatioMenu.m:465–469 (trước animation 0,15 s) | Menu tỉ lệ đang mở. |
| `dragGhost` (UIView*) | Drag.m khi kéo | nil khi drag kết thúc/teardown | Drag đang bay (ghost nằm trong tray window). |
| toast tag `0x5c9b` | showBackgroundToastFor:slot: | view bị gỡ trước khi gọi hideTrayWindowIfIdle (Picker.m:968–980) | Toast "Mở lại" đang hiện trong tray window. |
| `panelOpen` (Chrome.m:388) | — | — | Vị từ hoạt động CỦA CHÍNH MODULE: `tray \|\| ratioMenu \|\| pickerSheet`. `popupOpen` (:393) = panelOpen \|\| bar đang hiện (anyBarVisible kiểm `!bar.isHidden`). |
| `hideTrayWindowIfIdle` (Picker.m:965–981) | — | — | Định nghĩa "window rảnh" của module: `tray==nil && ratioMenu==nil && pickerSheet==nil && dragGhost==nil && không toast` → mới ẩn window. |

**`trayOverlay` — kiểm riêng theo lệnh GPT:** chỉ có ĐÚNG MỘT điểm gán trong toàn module: Panel.m:188 `self.trayOverlay = (window != nil)` trong `showLayoutPanelForApp:` — nó ghi lại layout panel đang được host trong tray window (chế độ overlay) hay trong container, phục vụ triệt diện tích app tại SCPCarSplit.m:2120 và cổng surface của AutoHide (AutoHide.m:149). **Không có điểm nào reset nó về NO** (teardown cũng không), tức là cờ DÍNH: từng mở panel kèm window một lần là YES vĩnh viễn trong đời process. Nó không mang nghĩa "popup đang mở" — đã loại khỏi guard. (`ratioOverlay` ở RatioMenu.m:430 cùng một mẫu cờ hosting, không nằm trên đường guard.)

**Chuyển cảnh đóng:** module KHÔNG có trạng thái "đang đóng" — mọi đường đóng đều nil hoá con trỏ trạng thái TRƯỚC, rồi mới animate view đã tách ra (picker 0,22 s, tray 0,22 s, ratio 0,15 s). Guard bám theo đúng mô hình trạng thái này, nhất quán với panelOpen và hideTrayWindowIfIdle.

## 2. Sửa đã làm (chỉ SCPFullscreenController.m, mirror src/SplitScreenA identical)

- **Helper mới `fsTraySurfaceBusy:` (:287):** trả YES chỉ khi `dragGhost != nil` (drag đang bay) hoặc tray window đang chứa toast `0x5c9b`. Đây là phần DƯ của tập nội dung window sau khi tray/ratioMenu/pickerSheet đã bị các nhánh guard trước bắt chính xác hơn (`picker`/`popup`). Không cần helper phía Picker — mọi trạng thái đều đọc được qua property sẵn có của SCPCarSplit; hằng tag toast chép từ chính phép thử idleness Picker.m:977.
- **Guard (:351):** `else if ([self fsTraySurfaceBusy:split]) refuse = @"tray";` — grep vị từ trần cũ (`trayWindow || …trayOverlay`) = **0** trong toàn file.
- **Snapshot khi từ chối — helper `fsRefusalSnapshot:` (:299):** chuỗi một dòng `snap{tw twh to tray picker ratio dg toast rz fc phase}` (tw = window tồn tại, twh = hidden (`-` nếu không có window), to = trayOverlay, dg = dragGhost, rz = resizing, fc = floatClosing, phase = pha của FS machine). Đã gắn vào **cả 6 điểm log từ chối** của controller: expand-busy (:327), expand state=EXPANDED (:334), gate refuse (:355), invalid-rect (:369), restore-busy (:460), restore state=SPLIT (:474).
- Header `.h` không đổi (helper là private trong .m). Không sửa file nào khác.

**Rà các reason còn lại — không reason nào khác mắc bệnh tồn-tại-thay-hoạt-động:** `inactive` (cờ active sống), `host-unavailable` (tiền điều kiện cấu trúc của chính expand), `zoomed`/`solo` (trạng thái tính năng đang chiếm trình bày), `picker` (con trỏ nil hoá đầu đường đóng), `popup` (panelOpen/anyBarVisible — vị từ hoạt động), `invalid-rect` (hình học), busy/state (pha máy trạng thái).

## 3. Truy vết tĩnh bắt buộc

**(a) Mở picker → đóng hoàn toàn → expand CHẠY:** sau `removePickerSheet`, trạng thái: pickerSheet=nil, tray=nil, ratioMenu=nil, dragGhost=nil, không toast; trạng thái giữ lại: trayWindow≠nil (hidden=YES), trayOverlay=YES (dính). Vị từ cũ → refuse `tray` vĩnh viễn. Vị từ mới: nhánh picker NO → popup (panelOpen=NO; bar đang hiện thì refuse `popup` — reason khác, hợp lệ, không phải `tray`) → nhánh tray: dragGhost=nil ∧ không toast → **qua guard**, đi tiếp tới kiểm rect/snapshot. ✓
**(b) Popup đang mở thật → vẫn bị chặn:** picker sheet mở ⇒ pickerSheet≠nil ⇒ refuse `picker` (:349); tray panel mở ⇒ tray≠nil ⇒ panelOpen ⇒ refuse `popup`; ratio menu mở ⇒ ratioMenu≠nil ⇒ refuse `popup`. ✓ (Bị chặn bởi reason chính xác hơn ở nhánh trước — nhánh `tray` nay chỉ bắt phần dư drag-ghost/toast.)
**(c) Tray từng mở rồi ẩn → không chặn:** sau `collapseAppTray`: tray=nil ngay đầu hàm; window bị ẩn ở completion khi rảnh; trạng thái giữ lại tw=1, twh=1, to=1 — nhánh tray mới cho NO → không refuse. ✓ Chính ca này là 4 lần `reason=tray` trong log ytz2: log cũ không phân định được popup mở thật hay trạng thái giữ lại; từ nay snapshot `snap{…}` trong dòng refuse sẽ phân định được ngay.

## 4. Cổng

- TU `SCPFullscreenController.m` biên dịch bằng đúng bộ flag của module (Makefile: `-fobjc-arc`, shims include, bộ `-Wno-error=…`) cộng `-Wall`: **exit 0, 0 diagnostic**, ra .o 58.464 B.
- Mirror: `src/SplitScreenA/SCPFullscreenController.m` identical (cmp); `.h` không đổi nên mirror sẵn identical.
- Diff chỉ trong controller (+ mirror của nó).

## 5. Chặn ngoài phạm vi — phải báo coordinator

Build TOÀN module `make clean && make` hiện **fail ở TU không thuộc vòng này**: `SCPTouchProbe.m:207–208` — 2 lỗi ARC bridged-cast (`(const void *)split.container` và `(const void *)(split.container.window)` cần `__bridge`). File này đã có thêm máy feed (sFeedEpoch…) vượt quá bản probe chỉ-đọc mà strand E từng giao — dấu hiệu strand mục-2 (native feed) đang sửa dở cùng module. Tôi không đụng vào file của strand khác; chủ file sửa 2 cast đó xong thì build module mới thông. Toolchain VM bị rollback đầu phiên (clang-18/ld.lld/ldid mất) — đã khôi phục bằng `~/bin/fix-toolchain.sh` foreground, smoke test đạt, mới biên dịch được như trên.

## 6. Điểm để lại cho GPT

- Hai lần `reason=inactive` 15:39 trong log ytz2: khớp split đã tắt 15:37:57 — không sửa, đúng như GPT nhận định.
- Nhánh `tray` sau sửa chỉ còn bắt drag-ghost + toast nền; nếu GPT muốn toast KHÔNG được chặn expand (nó chỉ sống ~2 s), bỏ một hạng tử trong `fsTraySurfaceBusy:` là xong — hiện giữ theo định nghĩa "overlay đang hoạt động" của chính module (hideTrayWindowIfIdle cũng coi toast là bận).
