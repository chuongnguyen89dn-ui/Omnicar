# HL2-ABHOST — Báo cáo strand phía host: bàn phím tự vẽ làm mặc định (K6)

- **Trạng thái: ĐẠT** (phạm vi 2 file được giao; chưa build — đồng bộ src→project + build do coordinator).
- Nguồn sự thật đã đọc trước khi sửa: `gpt-project-history/YTZ5HL1_GATE3_PINCH_RULING_20261109.md` §5; `gpt-project-history/YTZ5HL1_LOG_REVIEW_20261109.md` §4. Baseline main `bcf10e6` (theo đề bài; strand không chạy git).
- Cây đã sửa: `~/workspace/push9-clone/recovered-source/src/` — chỉ 2 file: `AppBridgeB/ABHostBMethods.m`, `AppBridgeB/ABHostGeometry.m`. Không sửa cây `project/`, không file nào khác.

---

## 1. BẢN ĐỒ THAY ĐỔI (lập trước khi sửa)

| # | Hàm / điểm hiện tại | Nguyên nhân | Điểm sửa | Trạng thái trước → sau | Phép kiểm |
|---|---|---|---|---|---|
| H1 | `ABNativeKeyboardEnabled()` — ABHostBMethods.m:64-68 (bản gốc). Điểm đọc pref `appBridgeNativeKeyboard` DUY NHẤT phía host: grep toàn `src/` xác nhận không còn `OMCPref(@"appBridgeNativeKeyboard")` nào khác; mọi consumer host (`ABPostOrientationToApp`, `ABKbSyncNoteEvent`, `ABKbSyncSnapshotForApp`, `ABNativeKbHandlePrefsChanged`, `ABKeyboardDispatch`) đều đi qua hàm này / `ABDrawnKeyboardEnabled()`. Phía app (ABInApp.m) chỉ đọc payload `drawnKeyboard`, không đọc pref. | Ruling §5 + LOG_REVIEW §4: phím native không hề hiện trên màn CarPlay (DEVICE FAIL tại tầng hình ảnh, dù kbstate ACTIVE đạt) → bản hồi phục phải mặc định DRAWN, native chỉ còn là opt-in. | Thân `ABNativeKeyboardEnabled()` + comment luật mặc định trong block [ytz5-k5] phía trên nó. | absent → `return YES` (native) → absent → `return NO` (drawn). `pref=1` → native: GIỮ NGUYÊN. `pref=0` → drawn: giữ nguyên. | Grep source: `if (!v) return NO; // [hl2] absent = drawn`. Runtime: máy không có pref → log payload phải ra `drawnKeyboard=1 mode=drawn`. |
| H2 | Pref cũ `appBridgeNativeKeyboard = 1` đã lưu trên máy người dùng (mọi bản pre-HL2 đều có thể để lại, vì absent từng = native và handler prefschanged từng chạy ở native). | LOG_REVIEW §4 chốt: "thay code default mà không đổi preference hiện hữu không đủ" — pref đã lưu thắng default mới, máy cũ sẽ kẹt native vĩnh viễn nếu chỉ làm H1. | Migration một lần đặt NGAY trong `ABNativeKeyboardEnabled()` — điểm chạy hợp lệ duy nhất phía host/AppBridge nằm trong 2 file được giao (hàm này được gọi từ mọi đường host: payload post, dispatch, funnel, prefschanged). Idiom sao đúng mẫu `bridgewake.pinchOffMigratedYtz5` (SCPCarSplit+BridgeWake.m:731-745): check marker bằng `OMCPref` → nếu stored==1 thì `CFPreferencesSetAppValue` ghi 0 + log discriminator → LUÔN đặt marker + `CFPreferencesAppSynchronize`, để native=1 đặt SAU migration được tôn trọng như lựa chọn tường minh. Guard kép: `static BOOL abKbDrawnRestoredChecked` (1 lần/process) + marker pref (chống lặp xuyên process). | Không có migration → có: pref=1 cũ + marker `appBridgeNativeKeyboardDrawnRestoredHl2` vắng ⇒ ghi pref=0, đặt marker=1, log `[ytz5-k5] hl2 migration: …`, và chính lần gọi đó đã trả drawn (`v = @0`). Mọi lần sau: marker có ⇒ block không chạy nữa. | Grep binary/source: chuỗi marker + chuỗi log migration (mục 3). Runtime: máy có pref=1 → sau lần host đọc cổng đầu tiên, pref phải = 0 và marker = 1; log có đúng 1 dòng migration. |
| H3 | `ABPostOrientationToApp` — ABHostGeometry.m:44-70 (bản gốc): stamp `drawnKeyboard` vào payload nhưng KHÔNG log giá trị đã gửi. | Chuỗi marker nghiệm thu ruling §5 thiếu mắt phía host "payload drawnKeyboard=1 được gửi" — build xanh không chứng minh được app đã nhận gate drawn. | Cùng hàm: hoist `ABDrawnKeyboardEnabled()` vào biến local `drawnKb` (payload và log không thể lệch nhau), giữ nguyên định dạng payload (chỉ trường `drawnKeyboard` sẵn có, giá trị 0/1 như cũ), thêm 1 dòng log sau post. Cập nhật comment relay: `0 = native (pref = 1 only)`. | Không log → log `[ytz5-k5] payload <bundle> drawnKeyboard=<0|1> mode=<drawn|native>` trên MỌI post (launch/layout/release/prefschanged re-post). | Grep log xe: `[ytz5-k5] payload` với `drawnKeyboard=1` xuất hiện trước thao tác mở ô nhập. |
| H4 | `ABKeyboardDispatch` — ABHostGeometry.m:302-333 (bản gốc): nhánh drawn gọi `[[ABKeyboard shared] showForApp:…]` nhưng không có log [ytz5-k5] dương; chỉ nhánh bị chặn native mới log. (Log `ban phim xe: hien cho …` của ABKeyboard.m:309-311 tồn tại nhưng không mang tag cổng, không chứng minh yêu cầu đã qua cổng drawn.) | Chuỗi nghiệm thu §5 thiếu mắt "host dispatch show panel khi có yêu cầu ở chế độ drawn". | Thêm log `[ytz5-k5] dispatch show panel drawn (<bundle>)` ngay trước `showForApp:` trong nhánh `else if (ABDrawnKeyboardEnabled())`. Logic dispatch, funnel `ABKbSyncNoteEvent`, nhánh hide và nhánh chặn native: GIỮ NGUYÊN từng dòng. | Chỉ log khi bị chặn → log cả khi show được chấp nhận ở drawn. | Grep log xe: `[ytz5-k5] dispatch show panel drawn` đi cặp với `ban phim xe: hien cho` của ABKeyboard. |
| — | Mắt pref/mode hiệu lực: `ABNativeKbHandlePrefsChanged` log `[ytz5-k5] cong ban phim doi: %@ (prefschanged)` (native/drawn) — ABHostGeometry.m:201-203 bản gốc. | Đã có sẵn và semantics VẪN ĐÚNG sau lật mặc định (hàm đọc lại qua `ABNativeKeyboardEnabled()`; "native" từ nay chỉ xuất hiện khi pref=1 tường minh hoặc trước migration trong cùng lần đọc — migration chạy ngay trong lần đọc đó nên giá trị trả về đã là drawn). | GIỮ NGUYÊN verbatim, không sửa. Bổ trợ: log payload ở H3 nay cũng mang `mode=` nên mắt mode có mặt cả khi không có prefschanged (cold start). | Không đổi. | Grep chuỗi còn nguyên tại ABHostGeometry.m:210 (sau sửa). |

**Tuân thủ giới hạn:** không xoá bất kỳ code native nào (đường pref=1: dispatch chặn show, funnel kb-sync chặn ACTIVE, snapshot bỏ qua, prefschanged đóng panel — tất cả giữ nguyên); không đụng kênh `bridgewake.v1.kbstate` hay định dạng `appbridge.kbsync` (chỉ giữ nguyên các gate sẵn có quanh chúng); không đổi định dạng payload ngoài trường `drawnKeyboard` hiện hữu (cùng key, cùng kiểu NSNumber 0/1); không `@available` (grep 2 file: 0 kết quả); phong cách log `[ytz5-k5] …` + guard static theo codebase hiện tại.

---

## 2. DIFF TÓM TẮT TỪNG HUNK (số dòng = sau khi sửa)

### ABHostBMethods.m
1. **:8** — thêm `#import <CoreFoundation/CoreFoundation.h>` (comment `[hl2] … BridgeWake ytz5 idiom`) — điều kiện để dùng `CFPreferencesSetAppValue`/`CFPreferencesAppSynchronize` trong migration, đúng dòng import BridgeWake dùng cho migration ytz5 của nó. ABKeyboard.m dùng các hàm này không import tường minh (dựa vào Foundation chuyển tiếp); ở đây import tường minh cho chắc.
2. **:54-63** — comment luật mặc định trong block [ytz5-k5]: `pref ABSENT or = 1 -> NATIVE / pref = 0 -> DRAWN` → `pref = 1 -> NATIVE / pref ABSENT or = 0 -> DRAWN`, kèm đoạn [hl2] dẫn ruling §5 + LOG_REVIEW §4 và lý do phải có migration.
3. **:73-110** — `ABNativeKeyboardEnabled()`: chèn block migration [hl2] giữa lần đọc pref và return (nguyên văn hành vi: sync → read → static-guard → marker-check → [stored==1: ghi 0, log, `v=@0`] → đặt marker → sync) và đổi dòng cuối absent: `if (!v) return YES; // absent = native` → `if (!v) return NO; // [hl2] absent = drawn (was: absent = native)`. `return [v boolValue];` và `ABDrawnKeyboardEnabled()` giữ nguyên.

### ABHostGeometry.m
4. **:56, :61-71** — `ABPostOrientationToApp`: thêm `BOOL drawnKb = ABDrawnKeyboardEnabled();` trước dictionary; trường payload đổi từ `@(ABDrawnKeyboardEnabled() ? 1 : 0)` inline thành `@(drawnKb ? 1 : 0)` (giá trị không đổi); comment relay sửa `0 = native (pref absent or = 1)` → `1 = … (pref = 0, or pref ABSENT since the hl2 default flip), 0 = native (pref = 1 only)`.
5. **:76-79** — cùng hàm, sau `postNotificationName:`: thêm log `[ytz5-k5] payload %@ drawnKeyboard=%d mode=%@`.
6. **:330-334** — `ABKeyboardDispatch`, nhánh drawn: thêm comment [hl2] + log `[ytz5-k5] dispatch show panel drawn (%@)` ngay trước `showForApp:`. Mọi nhánh khác (hide, chặn native, funnel) không đổi.

Không hunk nào khác. Tổng: BMethods +1 import, ~+10 dòng comment, +~28 dòng migration; Geometry ~+12 dòng.

---

## 3. DISCRIMINATOR (coordinator grep trong binary / log xe)

Mới (chỉ xuất hiện sau HL2):
- `appBridgeNativeKeyboardDrawnRestoredHl2` — marker pref (CFString trong binary + key trong domain `com.anlai.omnicar` trên máy sau lần chạy đầu).
- `[ytz5-k5] hl2 migration: appBridgeNativeKeyboard 1 -> 0 (drawn restored), marker appBridgeNativeKeyboardDrawnRestoredHl2 set` — log, tối đa 1 lần/máy.
- `[ytz5-k5] payload %@ drawnKeyboard=%d mode=%@` — format string trong binary; log xe dạng `[ytz5-k5] payload <bundle> drawnKeyboard=1 mode=drawn`.
- `[ytz5-k5] dispatch show panel drawn (%@)` — format string trong binary; log xe khi panel được show ở drawn.

Giữ nguyên từ YTZ5 (phải còn trong binary sau build HL2):
- `[ytz5-k5] cong ban phim doi: %@ (prefschanged)` (ABHostGeometry.m:210).
- `[ytz5-k5] dispatch show bi chan o cong native (%@)` — chỉ còn xuất hiện khi pref=1 tường minh.
- `[ytz5-k5] kb-sync ACTIVE bi chan o cong native (%@)`.

Chuỗi nghiệm thu phía host trên xe (ruling §5, phần host): `payload … drawnKeyboard=1 mode=drawn` → (app publish — strand khác) → `[ytz5-k5] dispatch show panel drawn` → `ban phim xe: hien cho …` (ABKeyboard, sẵn có). Mắt panel visible / keypress thuộc nghiệm thu thiết bị, không phải log host mới.

---

## 4. ĐIỂM NẰM NGOÀI PHẠM VI 2 FILE (chỉ ghi nhận, không tự sửa)

1. **Phía app — ABInApp.m (strand khác):** cache mặc định `static BOOL ABDrawnKb = NO; // NO = native` (ABInApp.m:505) và đường flip native→drawn không kích hoạt lại keyboard đang focus (ruling §5 dẫn ABInApp.m:505-529): app chỉ hội tụ về drawn ở payload post kế tiếp / responder kế tiếp. Host đã đảm bảo payload đúng ngay từ post đầu tiên sau lật; việc app áp dụng giữa phiên thuộc strand app.
2. **Đồng bộ src → project/:** strand bị cấm sửa cây `project/` — coordinator cần chép 2 file này sang bản project tương ứng trước khi build, nếu pipeline không tự sync.
3. **Prefs UI:** grep toàn `src/` không thấy nơi nào khác đọc/ghi `appBridgeNativeKeyboard` (không có toggle tường minh trong src). Nếu bản build có control ở nơi khác (bundle Prefs ngoài src) ghi pref=1 sau migration, migration sẽ KHÔNG ghi đè nữa (marker đã đặt) — đó là chủ đích (tôn trọng lựa chọn tường minh), coordinator lưu ý khi nghiệm thu: máy test phải hoặc chưa từng đặt marker, hoặc xoá marker để kiểm lại đường migration.

## 5. RỦI RO CÒN MỞ

- **Chưa build/chưa test máy trong strand này** (đúng phạm vi được giao): cú pháp đã rà bằng mắt theo idiom codebase (CFPreferences bridge cast chép nguyên mẫu BridgeWake/ABKeyboard); coordinator build sẽ xác nhận. `OMCLogWrite` đã được TU này dùng sẵn (ABHostBMethods qua AppBridgeB.h; ABHostGeometry dùng khắp file) — không thêm dependency mới ngoài import CoreFoundation.
- **Threading:** `static BOOL` guard không khoá — khớp tiền lệ `ABRegistrarRegistered` trong chính ABHostGeometry.m; mọi caller thực tế của cổng đều ở main queue / Darwin dispatch main. Nếu sau này có caller off-main, hai luồng đầu tiên có thể cùng vào block marker-check — hậu quả tối đa là ghi marker/pref=0 hai lần (idempotent) và log migration trùng; không có đường nào ghi sai giá trị.
- **Log payload (H3) tăng dung lượng log:** một dòng cho mỗi orientation post (open/layout/release/prefschanged) — cùng mật độ với log `[kb-sync] host post` sẵn có; chấp nhận được cho bản nghiệm thu, có thể gỡ sau DEVICE PASS nếu muốn.
- **Máy đã có marker từ bản test HL2 dở dang** (nếu coordinator từng chạy build thử chứa marker này) sẽ bỏ qua migration — xem mục 4.3.
