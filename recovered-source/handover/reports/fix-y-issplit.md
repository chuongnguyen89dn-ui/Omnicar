# FIX-Y1 — Sửa nhận diện isSplit của YT-Zoom (GPT WO, mục Y1)

Mức đạt: **source complete / build PASS / static PASS** — chưa có bằng chứng xe.
Phạm vi file đã đụng: `project/OmniCarSplitScreen/SCPCarSplit.m` (chỉ trong
hàm dựng gói `hostFrameInfo:pane:live:handle:`), `project/OmniCarAppBridge/ABYTZoom.m`.
Không đụng ABHostBMethods.m / ABChannels.m / ABInApp.m / BridgeWake / AutoHide /
FullscreenController.

## Lỗi (GPT kết án, đã xác nhận trên source)

`ABYTZoom.m` (trước sửa, dòng 151): `if (host.panes.count <= 1) return NO;` —
isSplit suy từ số pane ABHost đang host. Split hỗn hợp (1 ô native + 1 ô
YouTube hosted): ABHost chỉ có 1 hosted pane nhưng xe ĐANG split → isSplit = NO
sai → bước đọc-lại orientation 0,12 s phía app (chỉ chạy khi split) không kích
hoạt đúng trường hợp.

## (1) Nguồn sự thật — trạng thái trình bày của SCPCarSplit

Verdict tính tại chính owner trình bày, trong hàm dựng gói, từ ba thành phần
đều là trạng thái thật của module (không suy từ key `single` của bar — WO cấm):

| Thành phần | Bằng chứng |
|---|---|
| Phiên split đang active | `SCPCarSplit.h:31` `@property BOOL active`; điểm đặt YES duy nhất `SCPCarSplit.m:132` trong `activateWithCount:` |
| ≥ 2 ô trong layout | `SCPCarSplit.m:445` `-paneCount { return self.slots.count; }`; `slots` = các pane theo slot, float pane không tính (`SCPCarSplit.h:48`) |
| Không có ô nào đang zoom | `SCPCarSplit+Zoom.m:8` — `zoomedSlot` nil = no zoom; khi một slot zoom, màn hình trình bày đúng MỘT ô |

Hai thành phần cuối là nguyên văn vị từ trình bày đã VERIFIED của chính module:
`-[SCPCarSplit dividersVisible]` (SCPCarSplit+Layout.m:270–273, IMP @0x11b50) =
`paneCount >= 2 && zoomedSlot == nil`. Biểu thức phát gói:
`self.active && self.paneCount >= 2 && self.zoomedSlot == nil`.

Lưu ý diễn giải: trạng thái EXPANDED của SCPFullscreenController không đặt
`zoomedSlot` (nó đổi nguồn vùng, không đổi layout) → `split` giữ YES trong khi
phình — đúng ngữ nghĩa: phiên split và divider vẫn tồn tại dưới lớp phình,
restore quay về split.

## (2) Vận chuyển — trường mới trong gói hostFrameInfo

`SCPCarSplit.m:2082–2083`, cộng ngay sau khoá `fade` (cùng khuôn additive của
AutoHide), trong builder `hostFrameInfo:pane:live:handle:` (`:2042`) — hàm mà
CẢ HAI điểm phát gói đều đi qua: gói open tại `:1896` (block +0,05 s trong
`hostApp:inPane:`) và gói frame tại `:2013` (`sendHostFrameForPane:live:`):

```objc
info[@"split"]    = @(self.active && self.paneCount >= 2 && self.zoomedSlot == nil);
info[@"splitver"] = @1;
```

Phía ABHost (ABYTZoom.m): observer sẵn có trên `appbridge.open` /
`appbridge.frame` trong `YZRegisterHostLease` ghi thêm hai khoá này vào kho
session `YZSessionSplit{Value,At,Ver}` qua `YZNoteSessionSplit` (`:167–172`,
observer `:540–541`) — giá trị split mới nhất THEO PHIÊN kèm mốc thời gian
nhận (`YZSessionSplitAt`). Giá trị là trạng thái-sự-kiện: không hết hạn theo
tuổi (trình bày tĩnh thì không có gói mới và cũng không đổi), và gói open đầu
tiên của mọi pane hosted tới trước khi pane đó launch xong → kho đã có dữ
liệu trước lần publish đầu tiên đọc nó.

Gói thiếu trường (sender cũ hơn tính năng) → unknown → fallback tạm (xem (3)).

## (3) ABYTZoom — YZComputeIsSplit dùng nguồn mới + Y4 instrument

`YZComputeIsSplit` (`ABYTZoom.m:189`): kho session đã có dữ liệu → trả giá trị
đó, KHÔNG tham chiếu `panes.count`. Chỉ khi chưa từng nhận trường `split` mới
rơi vào fallback (công thức cũ: đếm pane + `single`), và mọi lần fallback đều
ghi log `[ytz] isSplit-fallback: ...` (throttle 5 s theo khuôn
`yzLogAppOrientBlockedForPane:`) để log xe kết án được đường nào đang chạy.
`panes.count` trong toàn file còn đúng 1 chỗ — `:199`, trong nhánh fallback
có log. Toàn bộ logic lease/ack/heartbeat còn lại giữ nguyên.

Y4 (chỉ instrument, không đổi hành vi):
- **Lease-lapse**: nhánh ack `expired` trong `YZHandleAck` (`:456`) ghi thêm
  dòng tường minh `[ytz] lease-lapse: app khai het han bundle=… gen=… heal=…`
  TRƯỚC các guard — cả trường hợp host không heal được (record inactive / pane
  đã mất / pref off) cũng lên sổ. (Dòng ack generic cũ không phân biệt được
  sự kiện này.)
- **Owner-change**: tại `YZRegisterHostLease` (`:517`) ghi
  `[ytz] owner phien host: <uuid>` — đổi owner nhìn từ phía app chính là thời
  điểm này (process host mới đúc UUID phiên mới). Mọi dòng log đều có timestamp
  do `OMCLogWrite` tự đóng (`yyyy-MM-dd HH:mm:ss.SSS` + process/pid).
- Quyết định KHÔNG restore snapshot khi lease hết hạn/đổi owner (phía app)
  giữ nguyên — vòng này không đụng ABInApp.m và không đảo quyết định đó.

## Cổng

| Cổng | Kết quả |
|---|---|
| Build AppBridge từ sạch (`make clean && make`) | **PASS** — exit 0, ABYTZoom.m compile/link/sign sạch, 0 warning ở file đã sửa |
| Build SplitScreen từ sạch | **PASS** — exit 0; các warning hiện có đều ở vùng không đụng (SCPHooks.m:776, SCPCarSplit+Chrome.m, SCPCarSplit.m:273/614/1714 — tồn tại trước vòng này) |
| 4 hash cấm ABHost (SHA-256 signature → `^}$`, đối chiếu lập trình với giá trị đã công bố) | **PASS — MATCH cả 4**: setFrame `8606f40a…`, setBarVisible `3044b10d…`, setHandleVisible `409cfb1447cb…`, setKnobs `b98a9f2611e0…` (ABHostBMethods.m không bị đụng ở vòng này) |
| `panes.count` trên đường quyết định isSplit | **PASS** — còn đúng 1 hit (ABYTZoom.m:199) nằm trong nhánh fallback có log `[ytz] isSplit-fallback` |
| hostFrameInfo superset | **PASS** — builder chỉ CỘNG 2 khoá `split`/`splitver` (gán tại :2082–2083); mọi khoá cũ giữ nguyên tên/công thức (base 11 + hostBarInfo + fade, r, corners, hx, front, ox/oy/ow/oh, ax/ay/aw/ah) |
| Chuỗi trong binary vừa build | **PASS** — SplitScreen.dylib chứa `split` + `splitver`; AppBridge.dylib chứa cả 3 chuỗi log mới (`isSplit-fallback…`, `lease-lapse…`, `owner phien host…`) |
| `@available` trong 2 file đã sửa | 0 (grep) — giữ luật cấm của codebase |

## Điểm diễn giải để lại

1. **ABChannels.m §7 (comment đầu mục YT-ZOOM)** còn một câu mô tả observer
   "track the `single` key for the lease's isSplit field" — nay `single` chỉ
   còn nuôi fallback. Không sửa ở vòng này (phạm vi ABChannels chỉ cộng code
   mới; comment nằm ngoài các file được giao) — ghi lại để vòng dọn comment
   xử lý cùng comment SCPPinchController.
2. **Mirror src/**: vòng này chỉ sửa cây `project/` đúng phạm vi file được
   giao; đồng bộ sang `src/` (SplitScreen/AppBridge) để bước tích hợp xử lý
   như các vòng trước.
3. Trường hợp nghiệm thu tương ứng trên xe (WO Y2): YouTube hosted + Maps
   native — log phải cho thấy lease mang `split=1` và KHÔNG có dòng
   `isSplit-fallback`; đó là bằng chứng xe của sửa này, chưa có ở vòng này.
