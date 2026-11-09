# FIX-Y2S — Snapshot lúc revoke YTZ (WO GPT vòng ytz4, mục YTZ)

Mức đạt: source complete / build PASS / static PASS (chỉ instrument, giữ
nguyên hành vi — chưa có bằng chứng xe).

Phạm vi: CHỈ `project/OmniCarAppBridge/ABYTZoom.m` + mirror
`src/AppBridgeB/ABYTZoom.m` (cmp identical sau chép). Không đụng
ABHostBMethods.m (chỉ đọc để chốt ngữ nghĩa trường), không thêm layout
cưỡng bức ở revoke theo đúng lệnh GPT: giữ revoke hiện tại, chỉ bổ sung
snapshot; chỉ sửa thật khi snapshot cho thấy sai lệch thực tế.

## 1) Điểm log mới

| Marker | Vị trí | Khi nào |
|---|---|---|
| `[ytz-revoke-snap]` | cuối thân `yzLeaseRevokeForPane:reason:` (ABYTZoom.m:516), sau dòng `lease thu hoi` sẵn có | MỌI revoke qua hàm này — cả hai caller hiện hữu: `reason=@"teardown"` (ABHostBMethods.m:1574, teardownPane:) và `reason=@"pref"` (YZHandlePrefChanged trong cùng file) |
| `[ytz-revoke-snap]` (đường mồ côi) | nhánh pane-đã-mất trong YZHandlePrefChanged (ABYTZoom.m:617) | pref OFF khi pane đã biến mất — đường này trước đây flip + publish trực tiếp, KHÔNG đi qua yzLeaseRevokeForPane: và không có dòng log revoke nào; nay có snapshot với các trường hình học = unavailable |
| `[ytz-nextlayout]` | đuôi `YZPublish` (ABYTZoom.m:349) — điểm phát DUY NHẤT của module | one-shot: lần republication đầu tiên của record kể từ revoke (cờ `revokeSnapPending` gắn ở revoke SAU khi post thu hồi của chính nó đã trả về, nên post thu hồi không tự kích); kèm `dt=%.3f` = giây từ revoke tới republication đó |
| `prevRevoke=%.2fs` | trường cộng thêm vào dòng grant tươi sẵn có `[ytz] lease cap ...` (ABYTZoom.m:489) | grant đầu tiên sau một revoke còn pending: khoảng cách revoke→grant |

## 2) Bộ trường snapshot (hàm chung YZSnapshotFields, ABYTZoom.m:272)

| Trường | Nguồn đọc tại điểm log | Ghi chú trung thực |
|---|---|---|
| `bundle` | `rec.bundleID` | — |
| `hash` | `ABBundleIDHash(bundle)` — FNV-1a-32 (ABHostLaunch.m:18, khai báo ở cuối ABHost.h) | đúng giá trị `-bundleForHash:` dùng để khớp ô |
| `gen` | `rec.generation` | ở revoke-snap là generation SAU post thu hồi (snapshot chạy sau flip + publish) |
| `logical` | `rec.width × rec.height` | cỡ logical ứng viên đã commit gần nhất, do hook layout của issuer ghi |
| `pub` | `rec.pubWidth × rec.pubHeight` | cỡ đã publish gần nhất |
| `box` | `pane.sceneBox` | cỡ trên-màn-hình mà `layoutPane:` commit gần nhất |
| `frame` | `pane.frame` (x,y,w×h, tọa độ cửa sổ) | — |
| `reqOrient` | `pane.requestedOrientation` | kết quả tuyên bố gần nhất mà `appWithHash:` đã LƯU. Trong kỳ lease các tuyên bố bị tiêu thụ tại đó và không lưu, nên lúc revoke đây là giá trị TRƯỚC lease, đóng băng từ lúc grant — đọc phải hiểu như vậy |
| `paneOrient` | `pane.orientation` | baseline lúc dựng ô từ pref `appBridgeOrientation` (gán một lần ở ABHostLaunch.m:179); là nửa fallback của `-effectiveOrientation:` |
| `settingsOrient` | đọc NGƯỢC từ settings đã commit của scene qua `YZSettingsOrientationString` (ABYTZoom.m:223) | đường đọc: `pane.appViewController` → `-sceneHandle` → `-sceneIfExists` → scene → `-settings` → `-interfaceOrientation` — cùng chuỗi guard mà đường commit dùng (ABSceneOfPane + ABSceneSettingsApply trong ABHostBMethods.m). Mọi mắt xích đều qua respondsToSelector + @try; thiếu mắt nào thì `settingsOrient=unavailable`, không bịa giá trị |
| `lastDecl` | — | `lastDecl=unavailable` CỐ ĐỊNH: tuyên bố hướng gần nhất của app KHÔNG đọc được từ TU này. Trong kỳ lease tuyên bố bị tiêu thụ ở `appWithHash:` (ABHostBMethods.m), nơi chỉ chuyển hash gói sang `yzLogAppOrientBlockedForPane:` — giá trị changed/mask không bao giờ vào ABYTZoom.m. Không trường nào khác được đóng vai trường này |

## 3) Giới hạn của one-shot [ytz-nextlayout] (ghi rõ theo đề bài)

- Marker khóa theo REPUBLICATION, không theo layout thô: `YZPublish` là
  điểm phát duy nhất của module nên mọi republication (grant lại qua
  hook layout, grant trực tiếp, ack-request republish, heartbeat đầu
  sau grant) đều bị bắt; nhưng một layout không đổi nội dung thì
  không post (throttle 0,30 s/chưa đổi → heartbeat ≤1 s gánh khi lease
  sống) — và khi lease đã chết, `yzLeaseNoteLayoutForPane:` trở về
  sớm (!active) nên không tồn tại điểm phát nào trong module để gắn
  marker. Layout của ô cũ trong lúc lease chết sẽ KHÔNG sinh dòng.
- Nếu ô không bao giờ được publish lại sau revoke (app đóng, phiên
  kết thúc, pref vẫn OFF khi ack-request tới), `[ytz-nextlayout]`
  không bao giờ xuất hiện — sự vắng mặt của nó là dữ kiện "chưa có
  republication", không phải lỗi instrument.
- `dt` đo revoke → republication đầu tiên, KHÔNG đo revoke → layout
  thô đầu tiên (hai mốc có thể khác nhau tối đa ~1 nhịp heartbeat
  trong ca grant-không-đổi-nội-dung).

## 4) Cổng đã kiểm

- **Build**: `make clean && make` trong project/OmniCarAppBridge —
  exit 0; ABYTZoom.m biên dịch không warning mới (chỉ warning
  ld64.lld `-multiply_defined` có từ trước). Kiểm dương tính trên
  dylib: `[ytz-revoke-snap]` ×2 format, `[ytz-nextlayout]` ×1,
  `prevRevoke=%.2fs` ×1, `lastDecl=unavailable` ×1.
- **Diff thuần cộng log**: so với baseline (mirror trước khi chép):
  +134/−2 dòng; cả 2 dòng "−" là hai dòng format-string cũ của CHÍNH
  lời gọi log grant (nới `split=%d` → `split=%d%@` và dòng đóng của
  nó). Mọi câu lệnh của thân revoke/grant — `rec.active` flip,
  `YZPublish`, `[self layoutPane:pane]`, `YZStopHeartbeatIfIdle`,
  các cổng pref/bundle/panes — đều là dòng ngữ cảnh không đổi.
  Bookkeeping duy nhất cộng thêm: 2 property trên ABYTLeaseRecord
  (`revokeSnapPending`, `revokeSnapAt`) và phép gán chúng trong các
  điểm log — không logic nào đọc chúng ngoài chính instrument
  (YZPublish one-shot + trường prevRevoke của grant).
- **Mirror**: project/ ↔ src/AppBridgeB/ cmp identical.
- **Không mở file ngoài phạm vi**: ABHostBMethods.m chỉ đọc; điểm
  phát hostFrameInfo nằm ở module đó không bị đụng — marker
  nextlayout gắn ở điểm phát của CHÍNH ABYTZoom (YZPublish) như đề
  bài cho phép ("điểm phát hostFrameInfo/lease-update sẵn có trong
  ABYTZoom").

## 5) Cách đọc ở phiên xe sau

- Tắt công tắc giữa phiên → kỳ vọng cặp: `[ytz-revoke-snap] ly
  do=pref ... settingsOrient=<đã commit>` rồi, khi bật lại,
  `[ytz-nextlayout] ... dt=<giây>` + dòng grant có `prevRevoke=`.
  So `box`/`logical`/`settingsOrient` giữa hai dòng: lệch nhau mới
  là sai lệch thực tế cần sửa theo lệnh GPT; khớp nhau thì khoảng
  OFF là bệnh gốc thuần túy, giữ revoke như hiện tại.
- Teardown (ngắt xe/rút ô) → `[ytz-revoke-snap] ly do=teardown`.
