# S3 — BIÊN BẢN PICKER PHIÊN HL3, KẾT ÁN BẰNG [picker-measure2]

- Phạm vi: CHỈ thế hệ hl3. File `OmniCar.log.old`: chỉ đoạn từ `2026-11-10 06:26:34` (dòng file 6701, `AppBridge: loaded into SpringBoard`) tới cuối file; đoạn hl2 trước đó BỎ. File `OmniCar.log`: toàn bộ thuộc hl3 (06:36:03.490 – 06:37:43.804).
- Đếm kiểm chứng: `OmniCar.log.old` có tổng 8 dòng `[picker-measure2]` và CẢ 8 đều nằm trong đoạn hl3 (0 dòng bị loại ở đoạn hl2). `OmniCar.log` có 2 dòng. **Tổng phân tích: 10 dòng = 5 lần mở (phase=presented) + 5 lần đóng (3 close-choose, 2 close-cancel).**
- Phương pháp: trích nguyên dòng + timestamp, không suy diễn. Số dòng ghi theo số dòng của file gốc (`.old` = số dòng toàn file; `.log` = số dòng toàn file).

---

## 1. MỌI DÒNG [picker-measure2] — NGUYÊN VĂN

### Lần mở P1 — OLD L9921 / đóng C1 — OLD L9970

```
2026-11-10 06:30:48.632 [CarPlay:37987] SplitScreen: [picker-measure2] phase=presented slot=0 hosted=1 hasContent=1 picker{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {297, 360}} bg=0.000,0.000,0.000,0.000 subs=1} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{71.5, 59}, {542, 242}} bg=?} cover{nil} scene{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {297, 360}} bg=?} trayWin{hidden=0 alpha=1.00 frame={{0, 0}, {640, 360}} level=1065 bg=0.000,0.000,0.000,0.000 root{nil}}
2026-11-10 06:30:53.507 [CarPlay:37987] SplitScreen: [picker-measure2] phase=close-cancel slot=0 paneBundle=com.google.ios.youtube paneHasVC=1 picker{nil} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{71.5, 59}, {542, 242}} bg=?} sceneSuper=UIView
```

Dòng kề ngay trước P1 (OLD):
- L9918 `2026-11-10 06:30:48.630 [CarPlay:37987] SplitScreen: CarSplit: man xe ban (an lop phu)`
- L9920 `2026-11-10 06:30:48.632 [CarPlay:37987] SplitScreen: CarSplit: popup chon 19 app cho o 0 (cua so rieng, 0 o cho)`

### Lần mở P2 — OLD L10430 / đóng C2 — OLD L10472

```
2026-11-10 06:31:54.390 [CarPlay:37987] SplitScreen: [picker-measure2] phase=presented slot=1 hosted=0 hasContent=1 picker{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {297, 360}} bg=0.000,0.000,0.000,0.000 subs=1} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{71.5, 59}, {542, 242}} bg=?} cover{nil} scene{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {297, 360}} bg=?} trayWin{hidden=0 alpha=1.00 frame={{0, 0}, {640, 360}} level=1065 bg=0.000,0.000,0.000,0.000 root{nil}}
2026-11-10 06:31:57.173 [CarPlay:37987] SplitScreen: [picker-measure2] phase=close-choose slot=1 chosen=com.google.Maps paneBundle=com.lumi.GOFA paneHasVC=1 picker{nil} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{71.5, 59}, {542, 242}} bg=?} sceneSuper=UIView
```

Dòng kề ngay trước P2 (OLD):
- L10427 `2026-11-10 06:31:54.388 [CarPlay:37987] SplitScreen: CarSplit: [do] shield host SCPCPass_UIRootSceneWindow superview SCPCPass_UIRootSceneWindow`
- L10428 `2026-11-10 06:31:54.388 [CarPlay:37987] SplitScreen: CarSplit: man xe ban (an lop phu)`
- L10429 `2026-11-10 06:31:54.390 [CarPlay:37987] SplitScreen: CarSplit: popup chon 19 app cho o 1 (cua so rieng, 0 o cho)`

### Lần mở P3 — OLD L11301 / đóng C3 — OLD L11338

```
2026-11-10 06:33:27.465 [CarPlay:37987] SplitScreen: [picker-measure2] phase=presented slot=0 hosted=1 hasContent=1 picker{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {396, 360}} bg=0.000,0.000,0.000,0.000 subs=1} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{71.5, 59}, {542, 242}} bg=?} cover{nil} scene{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {396, 360}} bg=?} trayWin{hidden=0 alpha=1.00 frame={{0, 0}, {640, 360}} level=1065 bg=0.000,0.000,0.000,0.000 root{nil}}
2026-11-10 06:33:28.880 [CarPlay:37987] SplitScreen: [picker-measure2] phase=close-choose slot=0 chosen=com.facebook.Facebook paneBundle=com.facebook.Facebook paneHasVC=1 picker{nil} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{71.5, 59}, {542, 242}} bg=?} sceneSuper=UIView
```

Dòng kề ngay trước P3 (OLD):
- L11298 `2026-11-10 06:33:27.463 [CarPlay:37987] SplitScreen: CarSplit: man xe ban (an lop phu)`
- L11300 `2026-11-10 06:33:27.465 [CarPlay:37987] SplitScreen: CarSplit: popup chon 19 app cho o 0 (cua so rieng, 0 o cho)`

### Lần mở P4 — OLD L12283 / đóng C4 — OLD L12506

```
2026-11-10 06:35:22.257 [CarPlay:37987] SplitScreen: [picker-measure2] phase=presented slot=0 hosted=1 hasContent=1 picker{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {396, 360}} bg=0.000,0.000,0.000,0.000 subs=1} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{71.5, 59}, {542, 242}} bg=?} cover{nil} scene{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {396, 360}} bg=?} trayWin{hidden=0 alpha=1.00 frame={{0, 0}, {640, 360}} level=1065 bg=0.000,0.000,0.000,0.000 root{nil}}
2026-11-10 06:35:46.143 [CarPlay:37987] SplitScreen: [picker-measure2] phase=close-cancel slot=0 paneBundle=com.facebook.Facebook paneHasVC=1 picker{nil} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{71.5, 59}, {542, 242}} bg=?} sceneSuper=UIView
```

Dòng kề ngay trước P4 (OLD):
- L12280 `2026-11-10 06:35:22.253 [CarPlay:37987] SplitScreen: CarSplit: man xe ban (an lop phu)`
- L12282 `2026-11-10 06:35:22.257 [CarPlay:37987] SplitScreen: CarSplit: popup chon 19 app cho o 0 (cua so rieng, 0 o cho)`

### Lần mở P5 — NEW L55 / đóng C5 — NEW L94

```
2026-11-10 06:36:06.504 [CarPlay:37987] SplitScreen: [picker-measure2] phase=presented slot=0 hosted=1 hasContent=1 picker{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {426, 360}} bg=0.000,0.000,0.000,0.000 subs=1} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{18, 87}, {604, 186}} bg=?} cover{nil} scene{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {426, 360}} bg=?} trayWin{hidden=0 alpha=1.00 frame={{0, 0}, {640, 360}} level=1065 bg=0.000,0.000,0.000,0.000 root{nil}}
2026-11-10 06:36:07.546 [CarPlay:37987] SplitScreen: [picker-measure2] phase=close-choose slot=0 chosen=com.ss.iphone.ugc.Ame paneBundle=com.ss.iphone.ugc.Ame paneHasVC=1 picker{nil} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{18, 87}, {604, 186}} bg=?} sceneSuper=UIView
```

Dòng kề ngay trước P5 (NEW):
- L52 `2026-11-10 06:36:06.501 [CarPlay:37987] SplitScreen: CarSplit: man xe ban (an lop phu)`
- L54 `2026-11-10 06:36:06.503 [CarPlay:37987] SplitScreen: CarSplit: popup chon 19 app cho o 0 (cua so rieng, 0 o cho)`

### 1b. Trích máy nguyên văn 10 dòng (đối chiếu từng ký tự, không qua gõ lại)

- OLD L9921: `2026-11-10 06:30:48.632 [CarPlay:37987] SplitScreen: [picker-measure2] phase=presented slot=0 hosted=1 hasContent=1 picker{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {297, 360}} bg=0.000,0.000,0.000,0.000 subs=1} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{71.5, 59}, {542, 242}} bg=?} cover{nil} scene{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {297, 360}} bg=?} trayWin{hidden=0 alpha=1.00 frame={{0, 0}, {640, 360}} level=1065 bg=0.000,0.000,0.000,0.000 root{nil}}`
- OLD L9970: `2026-11-10 06:30:53.507 [CarPlay:37987] SplitScreen: [picker-measure2] phase=close-cancel slot=0 paneBundle=com.google.ios.youtube paneHasVC=1 picker{nil} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{71.5, 59}, {542, 242}} bg=?} sceneSuper=UIView`
- OLD L10430: `2026-11-10 06:31:54.390 [CarPlay:37987] SplitScreen: [picker-measure2] phase=presented slot=1 hosted=0 hasContent=1 picker{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {297, 360}} bg=0.000,0.000,0.000,0.000 subs=1} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{71.5, 59}, {542, 242}} bg=?} cover{nil} scene{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {297, 360}} bg=?} trayWin{hidden=0 alpha=1.00 frame={{0, 0}, {640, 360}} level=1065 bg=0.000,0.000,0.000,0.000 root{nil}}`
- OLD L10472: `2026-11-10 06:31:57.173 [CarPlay:37987] SplitScreen: [picker-measure2] phase=close-choose slot=1 chosen=com.google.Maps paneBundle=com.lumi.GOFA paneHasVC=1 picker{nil} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{71.5, 59}, {542, 242}} bg=?} sceneSuper=UIView`
- OLD L11301: `2026-11-10 06:33:27.465 [CarPlay:37987] SplitScreen: [picker-measure2] phase=presented slot=0 hosted=1 hasContent=1 picker{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {396, 360}} bg=0.000,0.000,0.000,0.000 subs=1} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{71.5, 59}, {542, 242}} bg=?} cover{nil} scene{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {396, 360}} bg=?} trayWin{hidden=0 alpha=1.00 frame={{0, 0}, {640, 360}} level=1065 bg=0.000,0.000,0.000,0.000 root{nil}}`
- OLD L11338: `2026-11-10 06:33:28.880 [CarPlay:37987] SplitScreen: [picker-measure2] phase=close-choose slot=0 chosen=com.facebook.Facebook paneBundle=com.facebook.Facebook paneHasVC=1 picker{nil} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{71.5, 59}, {542, 242}} bg=?} sceneSuper=UIView`
- OLD L12283: `2026-11-10 06:35:22.257 [CarPlay:37987] SplitScreen: [picker-measure2] phase=presented slot=0 hosted=1 hasContent=1 picker{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {396, 360}} bg=0.000,0.000,0.000,0.000 subs=1} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{71.5, 59}, {542, 242}} bg=?} cover{nil} scene{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {396, 360}} bg=?} trayWin{hidden=0 alpha=1.00 frame={{0, 0}, {640, 360}} level=1065 bg=0.000,0.000,0.000,0.000 root{nil}}`
- OLD L12506: `2026-11-10 06:35:46.143 [CarPlay:37987] SplitScreen: [picker-measure2] phase=close-cancel slot=0 paneBundle=com.facebook.Facebook paneHasVC=1 picker{nil} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{71.5, 59}, {542, 242}} bg=?} sceneSuper=UIView`
- NEW L55: `2026-11-10 06:36:06.504 [CarPlay:37987] SplitScreen: [picker-measure2] phase=presented slot=0 hosted=1 hasContent=1 picker{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {426, 360}} bg=0.000,0.000,0.000,0.000 subs=1} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{18, 87}, {604, 186}} bg=?} cover{nil} scene{alpha=1.00 hidden=0 super=UIView frame={{0, 0}, {426, 360}} bg=?} trayWin{hidden=0 alpha=1.00 frame={{0, 0}, {640, 360}} level=1065 bg=0.000,0.000,0.000,0.000 root{nil}}`
- NEW L94: `2026-11-10 06:36:07.546 [CarPlay:37987] SplitScreen: [picker-measure2] phase=close-choose slot=0 chosen=com.ss.iphone.ugc.Ame paneBundle=com.ss.iphone.ugc.Ame paneHasVC=1 picker{nil} sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame={{18, 87}, {604, 186}} bg=?} sceneSuper=UIView`

### 1c. Trường của phase=presented (tách từ 5 dòng presented)

| Trường | P1 (OLD 9921) | P2 (OLD 10430) | P3 (OLD 11301) | P4 (OLD 12283) | P5 (NEW 55) |
|---|---|---|---|---|---|
| slot / hosted / hasContent | 0 / 1 / 1 | 1 / 0 / 1 | 0 / 1 / 1 | 0 / 1 / 1 | 0 / 1 / 1 |
| picker alpha / hidden | 1.00 / 0 | 1.00 / 0 | 1.00 / 0 | 1.00 / 0 | 1.00 / 0 |
| picker super | UIView | UIView | UIView | UIView | UIView |
| picker frame | {{0,0},{297,360}} | {{0,0},{297,360}} | {{0,0},{396,360}} | {{0,0},{396,360}} | {{0,0},{426,360}} |
| picker bg (RGBA) | 0.000,0.000,0.000,0.000 | giống P1 | giống P1 | giống P1 | giống P1 |
| picker subs (số subviews) | 1 | 1 | 1 | 1 | 1 |
| sheet alpha / hidden | 1.00 / 0 | 1.00 / 0 | 1.00 / 0 | 1.00 / 0 | 1.00 / 0 |
| sheet super | SCPCPass_UIRootSceneWindow | giống P1 | giống P1 | giống P1 | giống P1 |
| sheet frame | {{71.5,59},{542,242}} | giống P1 | giống P1 | giống P1 | {{18,87},{604,186}} |
| sheet bg | ? (không đọc được) | ? | ? | ? | ? |
| cover | {nil} | {nil} | {nil} | {nil} | {nil} |
| scene alpha / hidden | 1.00 / 0 | 1.00 / 0 | 1.00 / 0 | 1.00 / 0 | 1.00 / 0 |
| scene super | UIView | UIView | UIView | UIView | UIView |
| scene frame | {{0,0},{297,360}} | {{0,0},{297,360}} | {{0,0},{396,360}} | {{0,0},{396,360}} | {{0,0},{426,360}} |
| scene bg | ? (không đọc được) | ? | ? | ? | ? |
| trayWin hidden / alpha | 0 / 1.00 | 0 / 1.00 | 0 / 1.00 | 0 / 1.00 | 0 / 1.00 |
| trayWin frame / level | {{0,0},{640,360}} / 1065 | giống P1 | giống P1 | giống P1 | giống P1 |
| trayWin bg (RGBA) | 0.000,0.000,0.000,0.000 | giống P1 | giống P1 | giống P1 | giống P1 |
| trayWin root | {nil} | {nil} | {nil} | {nil} | {nil} |

Trường của phase=close (cả 5 dòng đóng): chỉ có `picker{nil}`, `sheet{alpha=1.00 hidden=0 super=SCPCPass_UIRootSceneWindow frame=<giống lúc presented của lần mở tương ứng> bg=?}`, `sceneSuper=UIView`, cộng `slot`, và (choose) `chosen=...` / (cả hai) `paneBundle=... paneHasVC=1`. Dòng đóng KHÔNG có: trayWin, cover, scene alpha/hidden/frame/bg, hasContent, hosted.

---

## 2. ĐỐI CHIẾU TỪNG LẦN MỞ: Ô ĐÍCH HOSTED HAY NATIVE

Căn cứ phân loại lấy từ chính log (trường `hosted=` của measure2 + nhãn `(… hosted)` / `(… native)` trong `[probe-foreign]` + loại scene trong `[scenevis]`), không lấy theo tên app.

| Lần | Ô đích trước khi mở | Loại theo log | Dòng căn cứ |
|---|---|---|---|
| P1 06:30:48.632 slot=0 | com.google.ios.youtube | HOSTED (measure2 hosted=1) | OLD L9888 `pane=slot0 (com.google.ios.youtube hosted)`; OLD L9970 (close-cancel) `paneBundle=com.google.ios.youtube` |
| P2 06:31:54.390 slot=1 | com.lumi.GOFA | NATIVE (measure2 hosted=0) | OLD L10363 `[scenevis] attach bundle=com.lumi.GOFA slot=1 scene=Car[2-5]:com.apple.CarPlayTemplateUIHost:com.lumi.GOFA`; OLD L10376 `pane=slot1 (com.lumi.GOFA native)`; OLD L10472 (close-choose) `paneBundle=com.lumi.GOFA` |
| P3 06:33:27.465 slot=0 | com.google.ios.youtube | HOSTED (hosted=1) | OLD L11279 `pane=slot0 (com.google.ios.youtube hosted)` |
| P4 06:35:22.257 slot=0 | com.facebook.Facebook | HOSTED (hosted=1) | OLD L12263 `pane=slot0 (com.facebook.Facebook hosted)`; OLD L12506 (close-cancel) `paneBundle=com.facebook.Facebook` |
| P5 06:36:06.504 slot=0 | com.facebook.Facebook | HOSTED (hosted=1) | NEW L36 `pane=slot0 (com.facebook.Facebook hosted)` |

Kết quả đối chiếu: **4 lần hosted (P1, P3, P4, P5 — đều slot=0) và 1 lần native (P2 — slot=1)**.

Lệch nhãn cần ghi rõ: đề bài gom GOFA vào nhóm ví dụ hosted, nhưng trong log hl3 này GOFA bị ghi nhãn **native** ở mọi dòng liên quan (`hosted=0`, `(... native)`, scene `CarPlayTemplateUIHost`). Biên bản này theo log: P2 là lần native duy nhất, và là mẫu đối chứng native duy nhất (n=1).

Báo cáo của Nguyen (đầu vào, không phải kết luận của log): ô hosted bị che trắng khi picker mở, ô native bình thường.

---

## 3. KẾT ÁN

### 3a. Tuyên bố kết án: CHƯA ĐỦ TRƯỜNG KẾT ÁN

Ở phase=presented, **không có bất kỳ trường nào đã ghi trong [picker-measure2] khác nhau giữa 4 lần hosted và 1 lần native**. Mọi phần tử đều ở cùng một trạng thái đo được ở cả hai nhóm:

- `picker`: alpha=1.00, hidden=0, frame phủ đúng toàn ô (frame bằng frame ô: 297/396/426 × 360 tại {0,0}) ở CẢ hosted lẫn native; bg alpha thành phần = 0.000 (trong suốt) ở cả hai nhóm.
- `sheet`: alpha=1.00, hidden=0 ở cả hai nhóm; frame KHÔNG phủ toàn ô (542×242 tại {71.5,59} cho P1–P4 — cùng một frame cho cả P1 hosted và P2 native; 604×186 tại {18,87} chỉ ở P5 hosted, đi cùng layout ô rộng 426 — khác biệt này đi theo kích thước ô, không đi theo hosted/native vì P1 hosted và P2 native dùng chung frame sheet).
- `scene` (ô đích): alpha=1.00, hidden=0, frame = frame ô ở cả hai nhóm.
- `trayWin`: hidden=0, alpha=1.00, frame toàn màn {640,360}, level=1065 ở cả hai nhóm; bg alpha = 0.000 (trong suốt) ở cả hai nhóm.
- `cover`: {nil} — không tồn tại — ở cả 5 lần.

Vì vậy theo đúng tiêu chí của đề bài (phần tử đặc/toàn vùng đúng lúc presented tại ô hosted mà KHÔNG như vậy ở ô native): **không chỉ đích danh được phần tử nào từ các trường đã ghi.** Không có trường nào thỏa điều kiện "có ở hosted, không có ở native".

### 3b. Phần tử được minh oan bởi trường đã ghi (chỉ trong giới hạn trường đó)

- `cover`: {nil} ở 5/5 presented — không tồn tại lúc presented, cả hai nhóm.
- `picker` (bản thân container): bg = 0.000,0.000,0.000,0.000 ở 5/5 — nền trong suốt hoàn toàn dù alpha=1.00 và frame phủ toàn ô. (Không bao gồm subview của nó — xem 3c.)
- `trayWin` (bản thân window): bg alpha = 0.000 ở 5/5 dù hidden=0, alpha=1.00, frame toàn màn, level=1065. (Không bao gồm nội dung bên trong nó — root={nil}, xem 3c.)

### 3c. Trường còn thiếu — quyết định mà log không có

1. **bg của `sheet` = `?` ở 10/10 dòng measure2** (5 presented + 5 close). Sheet là phần tử duy nhất có alpha=1.00 + hidden=0 + nằm trong `SCPCPass_UIRootSceneWindow` mà độ đặc của nền không đọc được. Thiếu trường này thì không kết án được sheet, cũng không minh oan được sheet.
2. **bg của `scene` ô đích = `?` ở 5/5 presented.** Scene của ô hosted và ô native có thể khác nhau ở nền (vd nền đặc trắng của scene hosted chưa có nội dung render) nhưng log không ghi được giá trị — không phân biệt được.
3. **Subview duy nhất của picker: chỉ có `subs=1` (số lượng).** Không có class, frame, alpha, hidden, bg của subview đó. Picker frame phủ toàn ô và có đúng 1 subview — nếu subview đó phủ toàn ô và đặc thì nó là ứng viên che trắng, nhưng log không có bất kỳ trường nào của nó, ở cả hai nhóm.
4. **Không có thứ tự lớp (z-order)**: không có level/zPosition cho picker, sheet, scene riêng lẻ; chỉ trayWin có level=1065. Không xác định được phần tử nào nằm trên cùng trước mặt ô đích lúc presented.
5. **`shield` / `pshield` hoàn toàn vắng trong measure2** (0/10 dòng có trường này). Ngay trước presented có dòng `CarSplit: man xe ban (an lop phu)` (cả 5 lần; riêng P2 còn có OLD L10427 `[do] shield host SCPCPass_UIRootSceneWindow superview SCPCPass_UIRootSceneWindow` 2ms trước) nhưng không có alpha/hidden/frame/bg của shield tại thời điểm presented trong measure2.
6. **Nội dung trong trayWin: `root{nil}` ở 5/5** — không đo được cây view bên trong trayWin ngoài bg của chính window.
7. **Mẫu native chỉ n=1** (P2). Kể cả khi có trường khác biệt, một mẫu native duy nhất cũng là căn cứ mỏng — ghi rõ để vòng sau bổ sung mẫu.

Đo bổ sung tối thiểu để kết án được: bg thật của sheet và của scene tại presented; class+frame+bg+alpha của subview duy nhất của picker; trạng thái shield/pshield tại cùng thời điểm presented; z-order/level của picker, sheet, scene so với nhau.

---

## 4. PHASE CLOSE (L6): SAU ĐÓNG, NỘI DUNG Ô ĐƯỢC GẮN LẠI LÀ GÌ

Bản thân dòng close của measure2 KHÔNG xác nhận nội dung cũ hiện lại: nó chỉ ghi `picker{nil}`, sheet vẫn `alpha=1.00 hidden=0` (sheet chưa được đo là đã biến mất tại thời điểm đóng), `sceneSuper=UIView`, `paneHasVC=1`. Việc gắn lại nội dung chỉ đọc được từ các dòng xung quanh:

Chung cho cả 5 lần đóng: ngay sau dòng close (≤2ms) có `CarSplit: man xe ranh` (OLD L9973, L10475, L11344, L12509; NEW L97).

### Cancel (2 lần) — không có dòng gắn lại, pane cũ còn nguyên theo bằng chứng gián tiếp

- C1 (06:30:53.507, slot=0, paneBundle=com.google.ios.youtube): KHÔNG có dòng `[scenevis]` attach/reveal/host-state-ready nào cho YouTube sau khi đóng (dòng host-state-ready gần nhất của YouTube là OLD L9607 lúc 06:30:20.625, TRƯỚC khi mở picker). Bằng chứng pane vẫn được gán cho slot=0: OLD L9985 (06:30:54.681) `[probe-foreign] ... pane=slot0 (com.google.ios.youtube hosted)`; các dòng `[wake1] bw emit com.google.ios.youtube ... gen=9` tiếp tục với cùng hash d3b4e0d. Việc YouTube rời ô ở OLD L10008 (06:30:55.645) `[scenevis] pane-remove bundle=com.google.ios.youtube slot=0` + OLD L10009 `dong o 0 (com.google.ios.youtube), con 1 o` là hành động đóng ô riêng, 2,138s SAU cancel, không phải hệ quả của picker.
- C4 (06:35:46.143, slot=0, paneBundle=com.facebook.Facebook): tương tự — KHÔNG có dòng `[scenevis]` gắn lại. Bằng chứng pane còn sống: OLD L12512 (06:35:46.743, +0,600s) `[probe-foreign] ... pane=slot0 (com.facebook.Facebook hosted)`; OLD L12517 (06:35:46.753) `[wake1] bw state com.facebook.Facebook UNKNOWN->VISIBLE gen=16`; sau đó còn có `[pinch2] owner accept slot=0 bundle=com.facebook.Facebook` (OLD L12536). Không có teardown/request nào cho Facebook quanh lần đóng này.

### Choose (3 lần) — nội dung ô bị THAY bằng app đã chọn, có dòng xác nhận trực tiếp

- C2 (06:31:57.173, slot=1, chosen=com.google.Maps, paneBundle tại lúc đóng vẫn = com.lumi.GOFA): OLD L10471 `mo com.google.Maps vao ngan 1 sau 0.0s`; OLD L10477 `[scenevis] detach-bg bundle=com.lumi.GOFA slot=1 ...`; OLD L10478 `[scenevis] attach bundle=com.google.Maps slot=1 scene=Car[2-5]:com.apple.CarPlayTemplateUIHost:com.google.Maps attached=1 inHost=1 hidden=0 alpha=1.00 window=1`; OLD L10479 `dua com.google.Maps (DBApplicationSceneViewController) vao o 1`; OLD L10501 `[scenevis] verify bundle=com.google.Maps slot=1 ... hidden=0 alpha=1.00`.
- C3 (06:33:28.880, slot=0, chosen=com.facebook.Facebook; paneBundle tại lúc đóng đã = com.facebook.Facebook): OLD L11341 (SpringBoard) `MILESTONE teardown bundle=com.google.ios.youtube`; OLD L11352 `MILESTONE request bundle=com.facebook.Facebook`; OLD L11354 `MILESTONE scene-attached bundle=com.facebook.Facebook ... viewClass=UIView`; OLD L11369 `MILESTONE revealPane bundle=com.facebook.Facebook ... readySource=timer`; OLD L11370 `[scenevis] host-state-ready bundle=com.facebook.Facebook slot=0 scene=nil attached=0 inHost=1 hidden=0 alpha=1.00 window=1`.
- C5 (NEW L94, 06:36:07.546, slot=0, chosen=com.ss.iphone.ugc.Ame; paneBundle tại lúc đóng đã = com.ss.iphone.ugc.Ame): NEW L100 `MILESTONE request bundle=com.ss.iphone.ugc.Ame`; NEW L102 `MILESTONE scene-attached bundle=com.ss.iphone.ugc.Ame ... viewClass=UIView`; NEW L119 `MILESTONE revealPane bundle=com.ss.iphone.ugc.Ame ... readySource=timer`; NEW L120 `[scenevis] host-state-ready bundle=com.ss.iphone.ugc.Ame slot=0 scene=nil attached=0 inHost=1 hidden=0 alpha=1.00 window=1`.

### Choose vs cancel khác nhau ở điểm nào (theo log)

- Choose: có teardown app cũ (C3) hoặc detach-bg app cũ (C2) + request/attach/reveal app MỚI; ô nhận nội dung mới. Riêng `paneBundle` trong dòng close không nhất quán: với app native được chọn (C2/Maps) nó vẫn là app cũ (com.lumi.GOFA) vì attach xảy ra sau; với app hosted được chọn (C3/Facebook, C5/Ame) nó đã là app mới ngay tại dòng close.
- Cancel: không teardown, không request, không attach; paneBundle = app đang có trước khi mở; pane giữ nguyên gán (bằng chứng probe/wake ở trên) nhưng KHÔNG có dòng scenevis nào xác nhận "nội dung cũ hiện lại" sau đóng — ở cả 2 lần cancel.
- Trạng thái sheet ghi trong dòng close giống hệt nhau giữa choose và cancel (vẫn alpha=1.00 hidden=0, frame như lúc presented): measure2 không ghi được thời điểm sheet biến mất ở cả hai nhánh.

---

## 5. ĐỐI CHIẾU [picker] hasContent (DÒNG CŨ) TẠI CÁC LẦN MỞ NÀY

Cả 5 lần mở đều có đúng 1 dòng `[picker] hasContent=1` ngay trước presented, và dòng `[picker-measure]` (bản đo v1) đi kèm cũng `hasContent=1`:

| Lần | [picker] (OLD/NEW) | [picker-measure] v1 | measure2 presented |
|---|---|---|---|
| P1 | OLD L9898 `2026-11-10 06:30:48.277 [picker] hasContent=1` | OLD L9899 `... [picker-measure] slot=0 hasContent=1 cover{nil} picker{alpha=1.00 hidden=0 super=nil frame={{0, 0}, {297, 360}} bg=0.000,0.000,0.000,0.000} sheet{nil} shield{nil} pshield{nil} trayWin{frame={{0, 0}, {640, 360}} level=1065 hidden=1}` | hasContent=1 |
| P2 | OLD L10417 `2026-11-10 06:31:54.049 [picker] hasContent=1` | OLD L10418 `... slot=1 hasContent=1 cover{nil} picker{... super=nil frame={{0, 0}, {297, 360}} ...} sheet{nil} shield{nil} pshield{nil} trayWin{frame=nil level=-1 hidden=-1}` | hasContent=1 |
| P3 | OLD L11289 `2026-11-10 06:33:27.136 [picker] hasContent=1` | OLD L11290 `... slot=0 hasContent=1 ... picker frame={{0, 0}, {396, 360}} ... trayWin{frame={{0, 0}, {640, 360}} level=1065 hidden=1}` | hasContent=1 |
| P4 | OLD L12272 `2026-11-10 06:35:21.696 [picker] hasContent=1` | OLD L12273 `... slot=0 hasContent=1 ... picker frame={{0, 0}, {396, 360}} ... trayWin{... hidden=1}` | hasContent=1 |
| P5 | NEW L45 `2026-11-10 06:36:06.295 [picker] hasContent=1` | NEW L46 `... slot=0 hasContent=1 ... picker frame={{0, 0}, {426, 360}} ... trayWin{... hidden=1}` | hasContent=1 |

Kết luận mục 5: `hasContent=1` ở 5/5 lần mở, ở cả ba dòng đo ([picker], [picker-measure], [picker-measure2]) và ở cả hosted lẫn native — trường này không phân biệt được hai nhóm; mọi ô được mở picker trong phiên này đều có nội dung.

Khác biệt thời điểm đo cần lưu ý (không phải khác biệt hosted/native): bản đo v1 `[picker-measure]` được ghi sớm hơn measure2 khoảng 0,21–0,56s, khi picker còn `super=nil`, `sheet{nil}`, `shield{nil}`, `pshield{nil}` và trayWin còn `hidden=1` (riêng P2 là `frame=nil level=-1 hidden=-1`). Tới thời điểm measure2 (presented) thì picker đã có `super=UIView`, sheet đã xuất hiện và trayWin đã `hidden=0`. Hai bản đo chụp hai thời điểm khác nhau của cùng một lần mở; không được lấy trường của v1 (vd shield{nil}) gán cho thời điểm presented của measure2.
