# GPT — ĐỐI CHIẾU TRỰC TIẾP HAI LOG HL5 (2026-11-10)

## Định danh phiên, giới hạn và nguồn thật
- Repo duy nhất: `chuongnguyen89dn-ui/Omnicar`, tree `recovered-source/`. Source chính HL5 `784957093a979f4680c63d43458bd76d7fa82504`; hồ sơ Muse §29.27–29.28 main HEAD tại lần đọc `edf95f10007deb89498d442d8941abd760ba5f81`. Muse ghi CI run `42733761359` SUCCESS và FAT SHA-256 `d40eb77b3945f1ce86499135e4ea155a75e801d22c597ae5e3f5bc863ec0e600`; GPT không tự tải/kiểm hash của DEB. Video verdict 10 mục ở §29.28 là lời kể/màn hình, phân biệt với phép đo log.
- Hai file tại commit upload `d94d6c990565880aa2a270cad0ca60f630203b0f`: `logs/OmniCar.log.old` blob `ac25342a0ac48c13170460bec37d13400a8536cb` (~2.097 MB, ~9.467 dòng dữ liệu); `logs/OmniCar.log` blob `49f9a1d9804b0fa1fbff327e9f51b448626fe2b2` (~888 KB, ~5.970 dòng dữ liệu). Đọc toàn văn trực tiếp qua GitHub `fetch_blob`; lọc **chỉ 08: và 10: 10/11**, khử dòng trùng tuyệt đối qua hai file; bỏ hoàn toàn phiên 06–07 giờ HL3/HL4.
- Hai phiên HL5: **A** 08:22:01–08:25:27 CarPlay PID `38735`, YouTube `38741`, TikTok `38746`, màn 640×360 pt/60fps; **B** 10:15:15–10:31:15 CarPlay PID `38790`, SpringBoard `38752`, YouTube `38799`→`38879`→`38884`, TikTok `38800`, màn 427×240 pt/30fps. B cắt tại 10:18:03 qua ranh giới log; KHÔNG coi là phiên thứ ba. Không cộng dữ liệu của các thế hệ PID khác.
- Trạng thái: **LOG/SOURCE VERIFIED theo nguồn đọc**, không thể kết luận video pixels hoặc DEVICE PASS của những nhánh chưa thử; không sửa source Muse, không CI, không build/ký/publish.

## Census độc lập, tách phiên
| Chỉ số | Phiên A (08h) | Phiên B (10h) | Kết luận |
|---|---:|---:|---|
| `[do] bw nuot day` | 4 | 17 | 21 lần nuốt có sự kiện app |
| Owner `[ack0] posted` | 4 | 17 | 21/21, tất cả set=0 post=0 |
| App `[do] bw ack seq` | 4 | 17 | 21/21 nhận về |
| `bw ack timeout` | 0 | 0 | không tái diễn; có rehost YouTube B |
| `act-posted` / `act-accepted` | 15/15 | 118/118 | 133/133, không bad-hash owner |
| `probe(-foreign) began` / `probe-feed` | 33/33 | 421/421 | match 1:1 theo timestamp, không miss |
| Native `probe-feed fired` | 13 | 23 | 36; chỉ ghi activity, không nuốt native |
| AutoHide `fade` / `reveal` | 6/6 | 23/21 | các reveal có `views=4`; không chứng minh logo có trong 4 |
| Picker `[picker-face] mode=clear` | 1 | 3 | 4/4 effectNil=1 meshPresent=0 |
| Picker `phase=close-done` | 1 | 3 | 4/4 sheetGone=1 **nhưng slot=-1 cả 4** |
| Pinch hosted toggle-sent/applied | YouTube **2/2** (1 expand + 1 restore) | **0/0** | thất bại riêng phiên B; không phải badstate |
| `[kbstate] reporter-stop` | 1 owner-inactive | 5 owner-inactive, 2 query-unanswered unverified | direct bundle swap chưa revoke |
| `[kbstate] noassignment` | 4 (hậu teardown phiên) | 7 (5 TikTok + 2 YouTube sau swap) | direct swap còn rò |
| YTZ `mismatch` khác 0 | 0 (6 mẫu) | 0 (72 mẫu) | chưa thấy lệch |
| FS refused | 0 | 3 `provenance=diag` khi inactive | không phải pinch badstate |
| Crash/NSException hiện trong corpus | 0 | 0 | không tự chứng minh mọi process không crash |

B app-probes: YouTube PID38799 `56` (H16/V40, wouldSwallow16, **B=1 ở cả 56**); TikTok PID38800 `29` (V29); YouTube PID38879 `65` (U65, identity chưa được xác nhận); YouTube PID38884 `36` (U17/V17/H2, wouldSwallow1, failopen transition250ms 1). Tất cả **186/186** probes B là `ph B=1`; `wouldPinch=0` toàn bộ B. `[touchset] active=2` trong CarPlay KHÔNG đủ chứng minh hai ngón: nhiều cặp là một chạm được quan sát qua hai window với cùng evB/vị trí.

## Quyết định kỹ thuật / lỗi cụ thể

### P0 — Logo trong split: vá HL5 mới chỉ tạo thoáng qua, sau đó vẫn bị dọn
- A: `08:23:11.144` `[GPT-F] Dock gate created`, `launcherWhere=goc`, active=1, nhưng `frameWin={{-17,-17},{34,34}}` (ngoài màn); `08:23:12.298` placement lật `tren nut Home,30pt`, `Dock gate removed gate=native Home grid only` dù **active=1**. Các reveal A 6/6 chỉ `views=4`.
- B: `10:15:16.988` button created tạm active=0 với frame off-screen `-17,-17`, `10:15:17.125` retired ở dock placement; không có created tiếp ở B, reveal 21 lần cũng chỉ `views=4`. **SOURCE+LOG FAIL** đối với logo split.
- `src/SplitScreenA/SCPCarSplit.m:refreshHomeButton` nay `gridOnly && !bare` retirement, nhưng tính `bare` từ placement theo Dock luôn đổi khi geometry layout ổn định, ngay cả `self.active=YES`. Cách sửa: **giữ nút gọi lại bên trong split khi active**, phân biệt với nút bổ sung trên dock ngoài split theo owner/location/role; không chỉ theo `bare` hoặc host pointer. Không dựng nút off-screen khi geometry chưa hợp lệ; clamp frame tới vùng dùng được, đo actual hit rect+superview; không tái tạo custom dock khi inactive. Giữ riêng icon grid `SCPHomeLauncher` và đường panel hiện có.
- Complaints chạm X YouTube/POI Maps khiến controls hiện: vì logo thực tế bị remove, cần ưu tiên điều tra **cổng wake toàn pane**, không vội quy vào UIButton 34pt. `BWGatePass` (hosted) chặn 1 finger bất cứ đâu trong pane HIDDEN; `SCPTouchProbe:SCPProbeFeedEvaluate` (native) gọi `ahNoteActivity:AHSourceContainer` với mọi native Began **nhưng không swallow**. Cần định lại chính sách target-qualified wake (logo handle/dock) để không cướp nút X hay Maps POI; không tự đổi global khi chưa có nghiệm thu.

### P0 — Race 250ms sau HIDDEN: đây là lỗi hành vi có mẫu, không còn NO-DATA
- B `10:30:32.794` owner VISIBLE→HIDDEN do fade; `10:30:32.946` YouTube PID38884 Began, owner act reveals; `10:30:33.355` probe kết thúc có `state=H stateAgeMs=151 wouldSwallow=0 failopen=transition-250ms`. Touch đã vào app dù UI vừa ẩn. **Đúng triệu chứng video**: chạm ngay sau khi ẩn đi vào app; sau một lúc mới nuốt.
- Source `src/AppBridgeB/ABInApp.m:BWGatePass` veto mọi state-change trong 250ms. Phán quyết cũ giữ guard nay phải rà lại theo mẫu: khi nhận positive verified HIDDEN và không WAKING/mixed/kb ACTIVE, cho phép swallow ngay hoặc đặt guard chỉ lên chuyển-state chưa chốt; đừng bỏ failopen cho phiên khác mù. Cần test 0–250ms, 250–500ms, >500ms, 1 finger vs pinch khi EXPANDED, kb ACTIVE, no false-swallow.

### P0 — Thay app A→B không revoke; nguyên nhân source xác định
- `src/SplitScreenA/SCPCarSplit+BridgeWake.m:bwApplyAssignmentForSlot:bundle:`: `if (!bundle.length && bwPrevBundle.length)` mới phát INACTIVE. **Không phát khi `oldBundle != newBundle` mà cả hai nonnil**. A→B là teardown cho old app dù new pane vẫn sống; comment code hứa phát ở bundle swap nhưng thực thi bỏ sót.
- B `10:15:50` TikTok→Maps slot1, TikTok 5 noassignment seq21..25 rồi `10:16:02.566` `query-unanswered class=unverified`; `10:17:23` YouTube→TikTok slot0, YouTube 2 noassignment seq113..114 rồi `10:17:34.565` stop query. Contrast true revoke `10:21:07.106` owner → `10:21:07.109` app stop `owner-inactive` gần 3 ms. A session 08 teardown 4 noassignment YouTube dù TikTok owner-inactive immediately. Rà session-level teardown broadcasts/emission overwrite.
- **Toa Muse:** khi `bwPrevBundle.length` và khác bundle mới (bao gồm nil), send INACTIVE to old hash using new gen, đúng assignment identity; preserve ordering sao cho queued STATE/KBSYNC của new bundle không overwrite reply old BEFORE app callback; match gen, prevent duplicate and stale revokes, do not revoke if unchanged same bundle by identity semantics. Test direct swap both directions + nil teardown + rehost/reconnect, no late kb/act.

### P1 — Pinch YouTube: A PASS 2/2; B no formation sample, không phải owner badstate
- A YouTube:38741 `08:23:11.138` dir0 → owner `08:23:11.159` expand=1; `08:23:12.282` dir0 → owner `08:23:12.304` restore=1, probes `ph B=2 wouldPinch=1`. Như vậy HL5 không 'YouTube vĩnh viễn chết'.
- B attached 5 lần ở PID38799 và 1 lần ở PID38884 khi host, nhưng **0 `toggle-sent`**, 0 owner accept/reject, tất cả AppBridge probes chỉ `B=1`. PID38879 unhosted `state=U` 65 probes không hợp lệ làm bằng chứng hosted pinch failure. 3 fs refusal around 10:29:39/43 are **`provenance=diag` while inactive**, not associated with pinch.
- Gắn đo **tại hosted UIWindow recognizer** `touchesBegan`: recognizer.view/window, distinct touch IDs (không nội dung/ngón tọa độ riêng tư), count, state, cancellation/overlay scene, sender type; correlation với CarPlay mirrored hit. Không restore `ABPinchPairDecision` và không đụng fullscreen owner đang tốt.

### P1 — Picker: clear-face chạy; nhưng close-done đo hỏng 4/4 và pixels còn NO-DATA
- Bốn `[picker-face]` (08:23:48;10:15:48;10:17:21;10:20:36) đều `mode=clear, effectNil=1, meshPresent=0`, sheetGone=1 sau close. Nhưng **4/4 close-done `slot=-1, preBundle=null, hostStructPresent=0`** dù presented targetSlot=1/0 và close-choose/cancel nhận slot đúng.
- **Lỗi source** `src/SplitScreenB/SCPCarSplit+Picker.m`: `refreshPickerSheet` gán `self.pickerSheetPane=found`; khi `found=nil` rồi gọi `removePickerSheet`. Tại đầu remove mới ghim `measureSlot=self.pickerSheetPane?.slot:-1`, quá muộn. Ghim scalar `targetSlot/preBundle` trực tiếp tại `buildPickerSheetForPane:` (chính sheet hoặc thuộc tính tied to sheet), đọc ở remove từ snapshot đã ghim, **sau** callback tra `[self paneAtSlot:targetSlot]`. `hostStructPresent` chỉ là điều kiện view structure, không thể chứng minh video pixel.
- Video nói mở menu mất ảnh tiếng còn. `effectNil` không chứng minh media compositor trên UIWindow level 1065 còn hiển thị; owner scenevis `inHost=1` cũng không chứng minh player surface. Thực hiện native/hosted A/B khi sheet present, record window hierarchy + preview/scene surface/snapshot lifecycle, bảo lưu rollback `splitScreenPickerSheetClearFaceOff`; không sửa menu engine/scene ngẫu nhiên.

### P1 — Native gọi logo, Home và bàn phím
- Native: feed nhận Began/Native fired 13 A +23 B, nhưng `SCPProbeFeedEvaluate` chỉ `ahNoteActivity`, **không swallow**, nên Google Maps vẫn nhận chạm; đây là khoảng trống kiến trúc owner wake, không phải mất touch. Không hijack toàn bộ native gestures. Nếu muốn logo từ native, làm target-gated surface/gesture, phân biệt ý định người dùng.
- Home icon `com.anlai.omnicar.app` B **6/6** callback own=1 → consumed → `routed-existing-panel`; YouTube own=0 x5 để nguyên. Cú bấm **Home vật lý/system** làm scene `going-home` sang stock dashboard là một cơ chế KHÁC; không gọi 6/6 Home launcher hỏng. Cần chốt UX riêng: giữ Home gốc hay có lối trở lại OmniCar, không hijack phím Home toàn cục.
- Native Maps keyboard rendering méo (video §29.28) **chưa thể kết án** bởi log này: màn B 427×240 và pane ~191×240; không có keyboard window geometry/transform/focus/scene px trong corpus. Không nhầm với hosted `drawnKeyboard=0 native-locked-hl3`. Thu thập keyboard popup class/frame/scene/scale/coordinate-space tại lỗi, không đổi keyboard tùy tiện.
- Video mất hình khi mở menu chỉ chứng minh từ lời kể §29.28, log không có compositor pixel; cần target evidence.
- ACK 21/21 + act 133/133 và native feed 454/454 đều sạch trong 2 phiên; không sửa đường này. No crashes explicit, no YTZ mismatch (6+72 reported records). Weather chưa có request CarPlay cho bài toán thời tiết.

## Thứ tự công việc Muse cho DEB tiếp theo
1. **P0** phục hồi logo split với placement/hit target đúng và giữ Home-grid, sửa policy wake làm hỏng thao tác app, đặc biệt guard 250ms theo mẫu thực.
2. **P0** sửa bundle-swap INACTIVE revoke và xác nhận packet không bị ghi đè; giữ cả nil/true teardown và rehost. Không kéo timeout mù.
3. **P1** picker đo close-done từ scalar ghim khi create, kiểm pixel/media sheet transparent, không giả định compositing đã sửa; bàn phím native cần phép đo riêng.
4. **P1** chẩn đoán YouTube pinch B=1 tại recognizer dù A 2/2; không thêm arbitration hoặc thêm native pinch vào DEB hồi quy.
5. **Regression** end-to-end ACK+act, Home grid icon, AutoHide, YTZ, native-feed, split lifecycle/reconnect; Muse chịu trách nhiệm một FAT DEB, không GPT build/CI/deploy/Sileo.

## Điểm khôi phục
- Dùng GitHub connector `mcp__GitHub__fetch_blob` với hai blob SHA nêu trên; `mcp__GitHub__fetch_file` để đọc source path hiện tại; filter theo date 10/11 và hour 08/10 + PID, de-dupe overlap by full line, count marker regex; không có local checkout/command shell tương đương đã chạy.
- Bằng chứng mốc log: `logs/OmniCar.log.old` line 5459/5501 (YouTube pinch 2 chiều), 5783 (clear picker), 5864 (close-done -1), 6932/7022 (logo tạo rồi loại), 7699/7869 (TikTok reporter swap), 8672/8919 (YouTube→TikTok swap); `logs/OmniCar.log` line 1595/1789 (picker clear/close), 2015 (direct owner-inactive), 5559/5593 (HIDDEN→transition-250ms), 5396 (ACK rehost), 4943 (Home grid route).
- Lần sau: kiểm Muse đã nhận work order và commit mới, source/HEAD, artifact, log PID, không gộp thế hệ binaries. Quan sát video gốc chưa được GPT xem trong lượt này (đọc hồ sơ Muse §29.28), vì thế các lời kể màn hình ghi rõ provenance.
