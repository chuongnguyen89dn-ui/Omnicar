# KIỂM ĐỘC LẬP — vòng sửa sau log (bản ytz3): guard FS, feed native, 2 strand instrument, gen của feed

Người kiểm: agent kiểm độc lập (chỉ-đọc, không sửa file nào ngoài biên bản này).
Đối tượng: cây `project/` hiện tại tại ~/workspace/omnicar-re (đã cmp identical với tree đã push ở commit `36135b8` cho mọi file liên quan).
Mốc so sánh mục (c): push9-clone, `81c6751` (trước vòng) → `36135b8` (source vòng này).

## (a) GUARD FULLSCREEN — KHẲNG ĐỊNH

**Vị từ mới chặn theo nội dung đang mở, không theo tồn tại window.** Chuỗi guard trong `fsExpandWithCompletion:` (SCPFullscreenController.m:344–353): `pickerSheet` (con trỏ nội dung) → `[split popupOpen]` → `[self fsTraySurfaceBusy:split]`. Trong đó:
- `popupOpen` (SCPCarSplit+Chrome.m:393) = `panelOpen || anyBarVisible`; `panelOpen` (:388) = `tray != nil || ratioMenu != nil || pickerSheet != nil` — tập con trỏ nội dung của chính module.
- `fsTraySurfaceBusy:` (:289) chỉ còn bắt phần dư của window tray: `dragGhost != nil` hoặc tray window đang chứa toast tag `0x5c9b` (đọc `split.trayWindow` để test tag — không test tồn tại window như điều kiện chặn).
- Cả ba con trỏ đều nil-hoá NGAY ĐẦU đường đóng, trước animation của view đã tách: `removePickerSheet` Picker.m:651 (`pickerSheet = nil`, fade 0,22 s sau đó), `collapseAppTray` Picker.m:999 (`tray = nil` đầu hàm), `hideRatioMenu` RatioMenu.m:469 (`ratioMenu = nil`, fade 0,15 s sau đó) → trạng thái "đang đóng chuyển cảnh" không cần hạng tử riêng: con trỏ là trạng thái, nhất quán với `panelOpen` và `hideTrayWindowIfIdle` (Picker.m:965–980, chỉ đặt `window.hidden = YES` khi mọi con trỏ nil + không toast; window không bao giờ bị nil ở đường đóng — nil chỉ ở teardown SCPCarSplit.m:278 và đổi screen Picker.m:888, tái dùng còn un-hide :884).

**trayOverlay đã rời đường guard.** Toàn module chỉ có ĐÚNG 1 điểm gán: Panel.m:188 `self.trayOverlay = (window != nil)` trong `showLayoutPanelForApp:` — không điểm reset nào (grep *.m). Trong controller, `trayOverlay` chỉ còn xuất hiện tại :305, là một trường BÁO CÁO trong `fsRefusalSnapshot:` — không tham gia quyết định.

**Snapshot: 6/6 điểm từ chối.** Controller có đúng 6 dòng log chứa "refused", cả 6 đều gắn `fsRefusalSnapshot:`: expand-busy (:325), expand state=EXPANDED (:333), gate reason= (:354), invalid-rect (:366), restore-busy (:458), restore state=SPLIT (:473). Snapshot gồm tw/twh/to/tray/picker/ratio/dg/toast/rz/fc/phase.
- Ranh giới phải nói rõ: các dòng KẾT QUẢ sau quyết định — `fs expand unconfirmed` (:393), `fs restore-unconfirmed` (:542), `fs rollback done` (:429), session-end (:~560), `fs external-override` (:593), `fs chrome FAILED` (:242) — KHÔNG mang snap{…} (chúng mang trường riêng: frame/target/active…). Chúng không phải điểm từ chối theo nghĩa cổng vào; nếu GPT muốn snap ở cả đường unconfirmed thì đó là việc cộng thêm, hiện chưa có.

**Truy vết 3 ca (tĩnh, trên vị từ hiện tại):**
1. Mở picker → đóng hoàn toàn → expand CHẠY: sau removePickerSheet + collapseAppTray: pickerSheet/tray/ratioMenu/dragGhost = nil, không toast; trạng thái giữ lại trayWindow≠nil (hidden=YES), trayOverlay=YES (dính). Vị từ cũ chắc chắn refuse `tray` vĩnh viễn; vị từ mới: picker NO → popup: panelOpen=NO (anyBarVisible mà đúng thì refuse `popup` — reason khác, hợp lệ) → tray: NO → QUA cổng. ✓
2. Popup mở thật → CHẶN: picker mở ⇒ refuse `picker`; tray panel mở ⇒ tray≠nil ⇒ panelOpen ⇒ refuse `popup`; ratio mở ⇒ refuse `popup`. ✓
3. Tray từng mở rồi ẩn → KHÔNG chặn: tray=nil, window retained hidden; nhánh tray mới không test tồn tại window → NO. ✓ Đây đúng ca 4 lần reason=tray ở log ytz2 mà kết luận cũ không phân định được.

## (b) FEED NATIVE (SCPTouchProbe.m) — KHẲNG ĐỊNH, một khác biệt thứ tự cần ghi

**Thứ tự cổng trong code** (`SCPProbeFeedEvaluate`, :268–329) — đọc thực tế:
1. `!split.active` → drop-inactive
2. touch không quy đổi được (không window/screen) → drop-unconverted
3. `touchScreen != carWindow.screen` (màn chứa container) → drop-display
4. vùng hệ thống: class window == `DBStatusBarWindow` hoặc góc Home 48×48 screen-space → drop-systemregion
5. popup đang hoạt động (`SCPProbePopupSub`: picker → tray → traywindow-visible → ratio → drag → resize) → drop-popup(sub)
6. điểm thuộc ô theo screen-space từ gán ô LIVE (`SCPProbePaneAtScreenPoint`), pane có bundle → không thuộc: drop-notassigned
7. ô hosted → drop-hosted (F4 sở hữu)
8. ô native → **fired**: đúng 1 lời gọi `[split ahNoteActivity:AHSourceContainer]` (:324)

Lệch mô tả duy nhất: thứ tự liệt kê trong đề bài đặt "màn CarPlay" trước "active", code đặt active trước (và chèn cổng unconverted ở giữa). Cả hai đều là drop cứng trước mọi cổng sau; cổng display về kỹ thuật không chạy được trước quy đổi (cần touchScreen). Không có đường nào tới fired mà thiếu một trong hai. Ghi nguyên trạng, không coi là lỗi hành vi.

**Quy đổi:** feed chỉ dùng 2 phép qua coordinateSpace CÓ TÊN — điểm chạm: `locationInView:touch.window` → `window.coordinateSpace` → `window.screen.coordinateSpace` (:154); hình ô: `convertRect:toView:nil` vào CHÍNH window của view đó (cùng window theo cấu trúc) → coordinateSpace của window đó → screen space (:165). Đếm `fromView:nil` xuyên window trên đường QUYẾT ĐỊNH của feed = **0**. Ranh giới: classifier [probe] cũ (chỉ ghi log, không nuôi quyết định nào) vẫn dùng `locationInView:nil` + `convertPoint:fromView:nil` (:106/:110), và trường `raw` của [touchset] khi touch không có window rơi về `locationInView:nil` (:356) — cả hai đều ngoài đường feed.

**Kỷ luật lời gọi (grep toàn file):** `ahNoteActivity:` = đúng **1** điểm gọi; lời gọi reveal/swallow/cancel = **0** (mọi hit của "cancel" là khoá đếm phase `cancelled` trong record chuỗi chạm và chữ trong comment). Feed chỉ chạy ở pha Began (điểm gọi duy nhất trong nhánh Began của SCPProbeObserveEvent). Nhãn `foreign` KHÔNG phải cổng loại: FeedEvaluate không hề đọc nhãn scene của classifier — ứng viên được quyết bởi screen identity + hình học; loại theo window chỉ có `DBStatusBarWindow` (định danh vùng hệ thống, không phải nhãn foreign).

**[touchset] (Phần B):** mỗi record có đủ `win` (class window), `raw` (điểm trong window), `scr` (điểm screen-space, "-" khi không quy đổi được), `pane` (slotK(bundle)/none/n/a), `evB` (event.timestamp của Began) + evL/tB/tL; dòng flush in ptr/win/raw/scr/pane/evB theo thứ tự tB. Logic ghép cặp/bắn lệnh = **0**: tập là dictionary theo con trỏ touch, chỉ thêm/cập nhật/gỡ + in mô tả; grep Expand/fsRequest/pinch-command trong file = 0 ngoài comment tuyên bố không làm.

## (c) HAI STRAND INSTRUMENT — KHẲNG ĐỊNH thuần cộng log, 0 đổi hành vi

Phương pháp: `git diff 81c6751 36135b8` trong push9-clone trên đúng 5 file; trước đó cmp từng file với cây project/ đang kiểm — **identical cả 5** (tức diff git chính là delta thật của vòng trên source hiện tại).

| File | Thêm | Xoá |
|---|---|---|
| SCPCarApps.m | 57 | 0 |
| SCPCarSplit.m | 55 | 0 |
| SSSplash.m | 26 | 0 |
| SSStartupScreen.m | 18 | 0 |
| SSStartupView.m | 7 | 0 |
| **Tổng** | **163** | **0** |

Phân loại mọi hunk: (i) OMCLogWrite [applib]/[scenevis]/[weather] chèn cạnh code cũ; (ii) 2 hàm phụ mới thuần đọc (SCPAppLibInfosContainSelf; SCPSceneVisLog — `return` sớm của nó chỉ bỏ qua LOG khi throttle, nằm trọn trong hàm log); (iii) biến đếm phụ chỉ để log (applibDrops/applibFromGrid…, các static SSWeather*LogSeq — mọi tham chiếu tới chúng đều nằm trong dòng cộng; chúng không nuôi SSWeatherGeneration/pending/guard nào); (iv) tra cứu visPane phục vụ log (vòng for thuần đọc trong SCPCarSplit.m).
Ba điểm đã soi kỹ vì là nơi "cộng thuần" hay giấu đổi hành vi nhất:
- Hunk feature-off trong SCPChosenPhoneAppInfos: dòng cộng là một `if (!OMCFeatureEnabled) OMCLogWrite(...);` TRỌN VẸN, chèn TRƯỚC dòng gốc `if (!OMCFeatureEnabled(@"appBridge")) return out;` — return gốc giữ nguyên, không bị nuốt vào if mới.
- Hai `if` tally trong vòng walk thư viện (duplicate / no-carplay-ui): thân if chỉ là addObject vào mảng tally; vị từ được đánh giá lại là thuần đọc ([seen containsObject:], SCPAppHasCarPlayUI — thân hàm ở SCPShared.m chỉ gồm guarded send + so chuỗi, không ghi).
- Cân bằng ngoặc của phần cộng theo file: 3/3, 3/3, 0/0, 0/0, 0/0 — không có `{`/`}` cộng nào ôm lại code cũ.
Kết luận (c): **163 cộng / 0 xoá, mọi dòng cộng thuộc 4 loại trên; 0 thay đổi điều kiện, 0 thay đổi luồng, 0 thay đổi hành vi.**

## (d) GEN CỦA FEED — phán mức rủi ro: CHỨC NĂNG ≈ 0; NHÃN/ĐỐI CHIẾU là thật và đã được đặt tên trung thực

**Hai hệ "generation" khác nhau bản chất:**
- Gen của owner (`bwGenBySlot[10]`, SCPCarSplit+BridgeWake.m:31): theo TỪNG SLOT, 1..4095 wrap (BWGenNext); tăng CHỈ khi (i) bundle của slot đổi — gán mới hoặc teardown về nil (:351) — hoặc (ii) vòng teardown phiên tăng mọi slot đang có bundle (:443). Nó là khoá kiểm cho gói XUYÊN PROCESS: `bwHandleActPacket:` loại gói khi `pkt.gen != bwGenBySlot[slot]` (:526), phía app cũng đối chiếu gen khi nhận state. Header `SCPCarSplit+BridgeWake.h` KHÔNG phơi biến này (chỉ nhắc trong comment :7/:61) → khẳng định của strand "TU này không đọc được" là ĐÚNG.
- Epoch của probe (`SCPProbeFeedEpoch`, SCPTouchProbe.m:206–219): MỘT biến đếm toàn cục; tăng khi con trỏ container đổi, con trỏ window của container đổi, hoặc cạnh rơi `active` ĐƯỢC LẤY MẪU (sFeedWasActive chỉ cập nhật bên trong hàm epoch, mà hàm này chỉ chạy từ FeedEvaluate tại Began). Bằng chứng grep: sau khi tính, `epoch` chỉ xuất hiện trong các format string `[probe-feed]` — nó KHÔNG cổng, KHÔNG so sánh, KHÔNG nuôi quyết định nào. Quyết định fired/drop đọc mọi đầu vào LIVE trong cùng một pass (active, screen, vị từ popup, gán ô + bundle tại thời điểm chạm).

**Các ca lệch có thể xảy ra (epoch ↔ gen owner):**
1. **Đổi app trong ô giữa phiên** (reassignment): gen của slot đó tăng (:351); container/window/active không đổi → epoch KHÔNG tăng. Dòng [probe-feed] trước và sau reassignment mang cùng epoch trong khi gen owner đã khác.
2. **Teardown + dựng lại phiên mà không có Began nào ở giữa, với container/window được tái dùng nguyên con trỏ**: cạnh rơi active không được lấy mẫu (hàm epoch không chạy lúc không có Began) → epoch có thể không tăng qua ranh giới phiên, trong khi vòng teardown của owner (:443) đã tăng gen mọi slot. Ca này CÓ ĐIỀU KIỆN: nếu phiên mới dựng container mới (đường ensureContainer như strand mô tả) thì đổi con trỏ tự bắt được ở Began đầu tiên của phiên mới — và vì epoch tính ở đầu FeedEvaluate, quyết định đầu tiên của phiên mới đã mang epoch mới. Lỗ hổng chỉ mở khi identity container/window đều giữ nguyên qua teardown.
3. **Churn container/window giữa phiên** (đổi screen, dựng lại container): epoch tăng trong khi gen owner đứng yên — một khoảng gen owner bị cắt thành hai epoch trong log.
4. **Mất hạt theo slot**: gen là 10 giá trị độc lập, epoch là 1 — chuyển động gen của từng ô không thể hiện trong dòng [probe-feed].
5. **Không thể so trị số**: gen wrap 4095 và reset theo đời slot; epoch đơn điệu theo đời process probe. Hai số không bao giờ đối chiếu 1-1 được — đối chiếu chéo chỉ bằng timestamp.

**Phán:** Vì epoch không tham gia quyết định nào, việc thay thế này **không tạo rủi ro chức năng** cho feed: không tồn tại gói tin để gen làm mất hiệu lực — feed là lời gọi trong cùng process trên trạng thái đọc tại chỗ, và đường có kiểm gen thật (F4 act, :526) không bị đụng. Rủi ro THẬT nằm ở tầng đọc log/diễn giải: ai đối chiếu `epoch=` với gen trong state packet sẽ thấy lệch ở các ca 1–4 mà không có cảnh báo trong chính dòng log. Giảm nhẹ đã có sẵn: trường trong log được đặt tên `epoch=` (không phải `gen=`), và biên bản strand ghi rõ đây là epoch của probe. Khoảng trống API còn lại cho GPT quyết: muốn tương quan gen thật thì phải phơi accessor chỉ-đọc trong SCPCarSplit+BridgeWake.h (vd bwGenerationForSlot:) — strand đã không tự ý sửa header khác chủ sở hữu; cho tới lúc đó, phát biểu đúng là "feed xác nhận gán-ô-hiện-hành đọc tại chỗ", KHÔNG phải "feed xác nhận generation của owner".

## Lệch / ghi chú tổng hợp (không tự hoà giải)
1. (b) Thứ tự hai cổng đầu trong code là active → (unconverted) → display, khác thứ tự liệt kê trong đề bài (màn CarPlay trước active) — đã ghi ở mục (b); không ảnh hưởng tập quyết định.
2. (a) Snapshot chỉ bao phủ 6 điểm REFUSE ở cổng vào; các dòng kết quả unconfirmed/rollback/session-end không mang snap — ranh giới đã ghi ở mục (a) để GPT biết phạm vi thật của "mọi điểm từ chối".
3. Số dòng trong biên bản fix-g-fsguard lệch vài dòng so với file hiện tại (vd strand ghi removePickerSheet nil tại :647–653, thực tế :651; collapseAppTray nil tại :995, thực tế :999) — lệch do file còn được chạm sau khi strand viết; nội dung khẳng định khớp toàn bộ.
4. (d) ca lệch 2 là có điều kiện (phụ thuộc identity container có được giữ qua teardown hay không) — ghi dạng điều kiện, không khẳng định đã xảy ra.
