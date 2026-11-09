# ACCEPTANCE — ytz4 (bản FAT từ CI macOS; vòng sửa theo phán quyết GPT sau phiên ytz3)

Mọi số liệu dưới đây đo trên CHÍNH file được giao hoặc
trích từ biên bản CI của chính bản này (ci-ytz4), không
lấy từ candidate của các vòng trước. Phán quyết phiên
ytz3 là căn cứ của vòng này nằm ở PATCH_NOTES §26;
phán quyết của GPT sau phiên đó và việc của vòng này
nằm ở §27.1–27.4.

## Ngữ nghĩa fullscreen của bản này (ghi rõ theo lệnh GPT)

Fullscreen hiện tại là: **toàn bộ mặt split phủ kín
phần màn hình trước đây dành cho dock/status bar, hai
ô GIỮ TỈ LỆ chia** (container được kéo phủ kín và xác
nhận bằng đọc lại khung ±0,5 pt; dock, nút Home và
status bar ẩn đi). Đây **không phải** một ô bung kín
màn hình — một ô bung kín là chức năng khác, chưa làm.
Mọi bước test fullscreen ở dưới chấm theo đúng ngữ
nghĩa này.

## Định danh bản giao

- File: `com.anlai.omnicar_1.0.3-rebuilt-ytz4-fat_iphoneos-arm64.deb`
- Kích thước: 1.229.512 byte
- SHA-256: `53caff295b29c277a3db31c102f7817284345e573d0be3169ce4a6fccfe8a3a2`
- Package: com.anlai.omnicar, Version (control trong DEB): 1.0.3,
  Architecture: iphoneos-arm64; member debian-binary +
  control.tar.gz + data.tar.lzma; Installed-Size 5964.
- CI: workflow build-fat-macos.yml (id 410962367), run **42599165348**
  (workflow_dispatch), conclusion **success** (xác minh foreground
  bằng jobs API + `gh run view` sau khi job hoàn tất),
  head ci-fat-test `aff33ed4328170ecca35eaa1b2b774da950cab71`;
  nguồn main `237098ca4aca17a1b997db6b7ea5a1a87a024849`.
- Provenance: candidate local
  `com.anlai.omnicar_1.0.3-ytz4_iphoneos-arm64.deb`,
  1.031.204 byte, SHA-256
  `27ecedd4039c986262a051ad459d8dfe49881d1981ded82f7d27fd1fd98b9bbb`
  (chỉ để truy vết).
- Baseline bất biến: ytz3 FAT `c1872b93…`. Bản **ytz1 vẫn CÁCH LY**
  (PATCH_NOTES §24.1) — KHÔNG cài bản này.
- Nội dung vòng (PATCH_NOTES §27.2–27.4): (HB) nguồn kb xác thực
  phía host — phiên phím hosted thật qua funnel
  `ABKbSyncNoteEvent`, kênh mới `appbridge.kbsync`, bản ghi ba
  trạng thái phía owner, gói kb type 6 (bit9=kbKnown,
  bit8=kbActive) chung token/seq với gói state; (K2) phía app
  tiêu thụ ba trạng thái (`BWKbEffective`, ngưỡng tươi 3,5 s,
  act-flag chỉ phát bằng chứng ACTIVE dương, instrument probe
  kbKnown/kbActive/kbSrc/kbAge); gỡ đủ **BA** ràng buộc
  AutoHide-EXPANDED (suspend trong `bwSetExpandedActive:`,
  hạng tử "expanded" trong `ahFadeBlockedReason`, phép nâng
  HIDDEN→VISIBLE trong `bwRecomputeForPane:` — hosted-solo giữ
  nguyên); (I2) instrument `[homelib]` trên đường Home thật
  (chạy trong CarPlayApp); (Y2S) snapshot `[ytz-revoke-snap]` +
  one-shot `[ytz-nextlayout]` cho đường revoke YTZ (giữ nguyên
  hành vi revoke, không layout cưỡng bức).

## Bảng cổng

| Cổng | Trạng thái | Căn cứ / số liệu |
|---|---|---|
| 0 — Phán quyết GPT sau phiên ytz3 | **PASS** | GPT đọc trực tiếp log ytz3 + source tại `9be396b`: bắt lỗi giặt kb (ABInApp.m:297 + BridgeWake.m:652–654) và bác phương án chở kb của owner; AutoHide EXPANDED phải gỡ BA ràng buộc (thêm điểm `bwRecomputeForPane:`); chấp nhận đối chứng OFF của YTZ, không layout cưỡng bức khi revoke, chỉ cộng snapshot; ca guard ngược là bắt buộc ở vòng tới; duyệt mở instrument đường Home; hiệu chuẩn pinch có chủ đích; Gate 3 + ENFORCE tiếp tục khoá |
| 1 — Static integration (candidate) | **PASS** | Candidate 1.031.204 B `27ecedd4…`: Cổng số 1 tương thích kb hai phía KHỚP TUYỆT ĐỐI bằng C core dùng chung (5 word kb tái lập đúng; hai bộ vector chỉ khác tham số seq/gen); parity 0 mất ở 8/8, AppBridge +9 (Y2S), SplitScreen +3 (HB); g1/g2/h/f diff = 0; knob 1 eor; 4 hash cấm MATCH; hostFrameInfo 30 key không đổi; hook 31 không tăng; diff I2 thuần cộng, Y2S +134/−2 đúng ngoại lệ format-string (integration-ytz4) |
| 1 — Static integration (FAT, hai lát) | **PASS** | FAT 1.229.512 B `53caff29…`: kênh bridgewake 5/5 × 2 binary × 2 lát; ytlease 2 kênh phía AppBridge × 2 lát; kênh mới `appbridge.kbsync` ×1 trong SplitScreen VÀ AppBridge × 2 lát; chuỗi mới đúng số format mỗi lát ([homelib] ×5, [kb-sync] owner ×3 + host ×1, [ytz-revoke-snap] ×2, [ytz-nextlayout] ×1, prevRevoke ×1); fullscreenTestExpand = 0 toàn gói; 3 khoá chẩn đoán trong binary Prefs × 2 lát; knob đúng 1 eor × 2 lát tại đúng địa chỉ ytz3; g1 idiom nguyên vẹn × 2 lát; parity vs FAT ytz3: SplitScreen 1394 → 1397, AppBridge 797 → 806, mất 0 (ci-ytz4) |
| Kiểm độc lập | **PASS kèm 2 lệch phụ** | verify-ytz4: (a) ba ràng buộc khẳng định đã gỡ đủ + truy vết state tới được HIDDEN khi EXPANDED + pinch-in độc lập fade; (b) kb xác thực khẳng định (funnel là đường duy nhất có hiệu lực; `BWKbEffective` không nhánh mặc định UNKNOWN→INACTIVE; layout gói khớp bằng C core); (c) I2/Y2S thuần cộng; (d) YZ hai phía không đổi hành vi ngoài instrument. Hai lệch phụ ghi nguyên ở PATCH_NOTES §27.5: consumer `appbridge.keyboard` thứ hai ở ABChannels.m:358 chết trong thực tế (rác tái tạo có từ trước — chờ GPT quyết dọn/giữ); reset UNKNOWN phía owner kích theo chuỗi bundle đổi (gán lại cùng bundle cùng slot không reset — giảm nhẹ bằng snapshot re-post khi app mở lại + hết tươi 3,5 s) |
| 2–5 — Xe (fullscreen fade / ca guard ngược / chuỗi suppression / hiệu chuẩn pinch / hồi quy) | **PENDING** | Chưa chạy phiên nào trên bản này — kịch bản 5 bước ở dưới |

## Bảng verdict từng track

| Track | STATIC | RUNTIME | DEVICE | Căn cứ / điều kiện còn thiếu |
|---|---|---|---|---|
| FS controller + guard | **STATIC_PASS** | PENDING | **DEVICE PASS** (phiên ytz3, guard vị từ nội dung) | Bước 2 đóng nốt ca guard NGƯỢC còn thiếu: popup đang mở → expand bị từ chối kèm snapshot picker=1 (phiên ytz3 không có ca FS trực tiếp; `drop-popup` của feed không thay nghiệm thu controller) |
| AutoHide khi EXPANDED | **STATIC_PASS** | PENDING | PENDING | Bước 1: sau gỡ ba ràng buộc, vào EXPANDED để yên ≥10 s — controls phải tự mờ như ở split, chạm hiện lại. Phiên ytz3 là baseline FAIL (0 fade / ≈961 s) |
| Wake — ô native (feed) | **STATIC_PASS** (kế thừa) | — | **DEVICE PASS** (phiên ytz3) | Bước 5 chấm hồi quy nhanh: fade → chạm ô native → `[probe-feed] fired` → reveal |
| Wake — suppression (kb ba trạng thái) | **STATIC_PASS** | PENDING | PENDING | Bước 3: chuỗi ở mức wouldSwallow — wouldSwallow=1 với kbKnown=1/kbSrc=owner ở các ca kb đóng; wouldSwallow=0 vì kb ACTIVE khi phím hosted mở trong lúc controls ẩn; nhập liệu không kẹt; teardown sạch. Gate 3 vẫn KHOÁ — đây là vòng THU BẰNG CHỨNG, không phải vòng mở cổng |
| Pinch (hiệu chuẩn) | **STATIC_PASS** | PENDING | PENDING | Bước 4 chỉ THU DỮ KIỆN có chủ đích: dãy động tác đánh dấu (1 ngón yên / 1 ngón kéo / 2 ngón yên cùng ô / tách / chụm) để đội phân tích tìm hai contact độc lập trong `[touchset]`; kiến trúc ghép cặp chờ GPT sau dữ kiện này |
| YT-Zoom | **STATIC_PASS** (kế thừa) | — | **DEVICE PASS** (phiên ytz2 + đối chứng OFF phiên ytz3) | Bước 5 chấm hồi quy nhanh (video phóng đúng). Đối chiếu `[ytz-revoke-snap]` ↔ `[ytz-nextlayout]` chỉ khi có tắt công tắc giữa phiên: lệch box/logical/settingsOrient mới là sai lệch thực tế cần sửa; `lastDecl=unavailable` là sự thật cố định của instrument, không phải lỗi |
| Mất icon (instrument [homelib]) | **STATIC_PASS** | PENDING | PENDING | Bước 5: nếu icon lại mất, ghi mốc thời gian; sau phiên đọc `[homelib]` — kỳ vọng mọi dòng `proc=CarPlay(com.apple.CarPlayApp)`; có dòng OMNI `decision=remove` cho `com.anlai.omnicar.app` → kết án tại chỗ; không có dòng OMNI nào → điểm mất nằm hạ nguồn của đường inject/remove |
| Weather | **STATIC_PASS** (kế thừa) | PENDING | PENDING | Vẫn thiếu một phiên có request thật để khép chuỗi req#→ans#→applied→display; hai warming không tính (PATCH_NOTES §26.9, §27.1(vii)) |
| Núm divider | **STATIC_PASS** (kế thừa) | PENDING | PENDING | Vẫn NO DATA (0 dòng payload); chấm bằng quan sát ở bước 5 |

Không mục nào được gọi là PASS ở cấp cao hơn bằng chứng hiện có.
ENFORCE (wake lẫn pinch) vẫn đóng theo phán quyết GPT.

## UUID từng slice (đo trên bản FAT)

Cả 8 binary đều FAT arm64 (subtype 0x0) + arm64e (subtype
0x80000002, PAC00), min iOS 15.0.

| Binary | arm64 | arm64e |
|---|---|---|
| OmniCar (app) | F5D89BD4-ECC2-360B-8C09-F1BF4FF18774 | 6708B147-F17D-30AE-9201-B72D64747522 |
| OmniCarAppBridge | 619B0A9A-D6B0-3D5F-A8EC-FC2F11F0099E | EF5B12F3-AF3A-3EDC-93E8-3EB302C8A2AC |
| OmniCarCarProbe | C0A9772A-801A-331A-A350-772C5BE2A3E9 | E6C46A44-CCEB-3A79-BF93-C0446A1CBE24 |
| OmniCarCore | CAC95506-92A2-3A0B-82E8-7597671B193E | 5AFCBF85-C5B5-3041-86C3-22D2F90839A1 |
| OmniCarPrefs | 1E88933B-2FB9-34B2-8BCD-D983C57EB041 | FBCC574B-B266-3907-BCDA-0183E5381D5C |
| OmniCarSpeedBubble | DD5FCE15-750D-3E4D-A53D-DF5771D7F2EB | B2244376-6D02-3916-B852-19A4E043DF88 |
| OmniCarSplitScreen | CEFDC89E-6DBD-3AF1-9A25-2CC8BE9B3EFB | 52D6F48D-A599-304C-AC15-FAAC71D100C2 |
| OmniCarStartupScreen | 72425650-9A99-3AE3-9097-D1198524AF17 | 6716BBD1-5CCF-3A8F-A49E-3B556D4857D9 |

## Tag log của vòng (để đối chiếu trong phiên)

- `[kb-sync]` — đường đồng bộ kb xác thực: phía host
  `host post … source=host-keyboard-session` (mở/đóng
  phiên, teardown, disconnect, snapshot lúc open); phía
  owner `change …` / `drop not-assigned` kèm cùng source.
  Gói kb trên kênh state: type 6, bit9=kbKnown,
  bit8=kbActive (không phải tag log — đọc qua probe).
- `kbKnown=%d kbActive=%d kbSrc=%s kbAge=%ld` — trường
  trong dòng close của probe phía app: kbKnown/kbActive
  là trạng thái hiệu dụng BA trạng thái tại đầu sequence;
  kbSrc ∈ owner/local/none (nguồn thắng); kbAge = tuổi
  của nguồn thắng (ms; −1 = không có thông tin kb nào).
  Đây là bản ghi chính cho bước 3.
- `[homelib]` — instrument đường Home (mọi dòng kèm
  `proc=<processName>(<mainBundleID>)`, kỳ vọng luôn là
  CarPlayApp): `event=new-library libclass= count=
  chosen=`; `event=loadFromProxy bundle= injected=`;
  `decision=<...>` theo bundle (chỉ log khi quyết định
  ĐỔI; các giá trị: skip-not-chosen / skip-already-ours /
  skip-real-declaration / skip-no-decl-class / inject /
  lib-skip-present / lib-skip-no-proxy / lib-add /
  remove-skip-no-proxy / remove); dòng riêng
  `OMNI decision=<...>` cho `com.anlai.omnicar.app`
  (MIỄN throttle — kể cả skip); `event=apply-published
  count= omni=` (trạng thái lưới hậu-áp-dụng).
- `[ytz-revoke-snap]` — snapshot tại MỌI revoke YTZ
  (pref + teardown) và ở đường mồ côi pref-khi-pane-mất:
  bundle / hash / gen / logical / pub / box / frame /
  reqOrient (giá trị TRƯỚC lease, đóng băng từ lúc
  grant) / paneOrient / settingsOrient (hoặc
  `unavailable` khi chuỗi đọc gãy) / `lastDecl=unavailable`
  (cố định — tuyên bố gần nhất không đọc được từ TU này).
- `[ytz-nextlayout]` — one-shot: republication đầu tiên
  của record kể từ revoke, kèm `dt=` (giây từ revoke tới
  republication — KHÔNG phải tới layout thô đầu tiên);
  dòng grant cộng trường `prevRevoke=%.2fs`. Vắng mặt =
  chưa có republication nào, không phải lỗi instrument.
- Các tag của các vòng trước giữ nguyên: `[autohide]`,
  `[wake1]`, `[probe]` / `[probe-foreign]`, `[probe-feed]`,
  `[touchset]`, `snap{…}`, `[fs-diag]`, `[fs1]`, `[pinch1]`,
  `[ytz]`, `[applib]`, `[scenevis]`, `[weather]`.

## Kịch bản nghiệm thu một phiên

Chuẩn bị: cài bản FAT này (thay ytz3 như mọi vòng; KHÔNG
cài ytz1 cách ly). Mặc định khi cài: wake/pinch DRY_RUN,
AutoHide BẬT, YT-Zoom BẬT. Nhóm **Chẩn đoán** ở cuối
trang Cài đặt → OmniCar → Chia màn hình (section 6):
công tắc `fullscreenDiagExpand` (tắt), công tắc
`youtubeVirtualize` (bật), segment `bridgewake.pinchMode`
(nấc giữa = Đo). Toàn bộ năm bước chạy trong MỘT phiên
kết nối (trừ các bước ngắt–nối lại có chủ đích), log +
.ips (nếu có) up vào logs/ của repo sau phiên. Ngữ nghĩa
fullscreen chấm theo đúng định nghĩa ở đầu văn bản này:
mặt split phủ kín phần màn trước đây dành cho
dock/status bar, hai ô giữ tỉ lệ.

**Bước 1 — Fullscreen phải tự mờ như split (gỡ ba ràng
buộc AutoHide-EXPANDED).**
1. Vào split hai ô, segment pinchMode để **Đo (1)** hoặc
   **Off (0)** đều được. Gạt `fullscreenDiagExpand` ON:
   expand chạy (log `fs expand confirmed`), mặt split
   phủ kín, hai ô giữ tỉ lệ.
2. **Để yên ≥ 10 giây không chạm gì:** controls (logo,
   tay nắm, divider) phải **tự mờ** đúng như ở split —
   log kỳ vọng `[autohide] fade` + gói state về HIDDEN
   **giữa hai marker** expanded, và `[wake1] bw expanded
   ON` **không còn** `[autohide] suspend` đi kèm vì
   expanded (cặp suspend/resume chỉ còn hợp lệ quanh
   chuyển hosted-solo). Đây là ca đã FAIL ở phiên ytz3
   (0 fade trong ≈961 s expanded).
3. Chạm vào màn hình: controls hiện lại
   (`reveal-applied reason=activity`).
4. Gạt công tắc OFF: `fs restore confirmed`, khung về
   đúng split, không `unconfirmed`/`rollback`.

**Bước 2 — Ca guard NGƯỢC (BẮT BUỘC theo GPT — ca còn
thiếu của nghiệm thu controller).**
1. Đang ở split, **mở picker chọn app và ĐỂ NGUYÊN nó
   đang mở** (sheet còn hiện trên màn hình). Gạt
   `fullscreenDiagExpand` ON: expand **PHẢI BỊ TỪ
   CHỐI** — log refusal với reason picker/popup và
   snapshot `snap{…}` mang **picker=1** (trạng thái
   popup mở thật tại đúng thời điểm từ chối).
   `drop-popup` của feed KHÔNG tính thay ca này —
   đây là nghiệm thu của chính guard controller.
2. **Đóng picker hoàn toàn** (chờ sheet biến mất hẳn).
   Gạt công tắc OFF rồi ON lại (hoặc gạt lại ON):
   expand phải **chạy** (`fs expand confirmed`) — ca
   đóng-hẳn-đã-chạy đã đạt 2 lần ở phiên ytz3, chấm
   lại nhanh để khép cặp hai chiều trong cùng phiên.
3. Gạt OFF thu về split sạch.

**Bước 3 — Chuỗi suppression ở mức wouldSwallow (thu
bằng chứng cho Gate 3 — cổng vẫn KHOÁ, không nuốt
thật ở bất kỳ điểm nào).**
1. Mở app **hosted** (YouTube) trong split. Chờ
   controls ẩn hẳn (fade, trạng thái HIDDEN).
2. Chạm vào nội dung app: đọc log sau phiên — dòng
   probe của sequence đó phải ghi **wouldSwallow=1**
   với **kbKnown=1, kbSrc=owner** (kb đóng, tri thức
   đến từ snapshot owner còn tươi) ở **ít nhất các ca
   kb đóng**. So với baseline ytz3 (wouldSwallow 0/38,
   kb không xác định 38/38): đây là ca phân định của
   tín hiệu kb mới. Chạm vẫn đi qua app như DRY_RUN —
   ĐÚNG thiết kế vòng này.
3. Mở tìm kiếm **ngay trong app hosted đó** để **phím
   tự vẽ** của app hiện lên **trong lúc controls vẫn
   đang ẩn**, rồi chạm: probe phải ghi **wouldSwallow
   = 0 vì kb ACTIVE** (fail `kb`; kbSrc=owner hoặc
   local, kbKnown=1 kbActive=1). Bất kỳ bằng chứng
   ACTIVE hợp lệ nào cũng phải chặn suppression —
   đây là ca dương tính bắt buộc của tín hiệu ba
   trạng thái.
4. **Gõ vài chữ** vào ô tìm kiếm: nhập liệu phải chạy
   bình thường, không kẹt, không mất chữ (đây là mắt
   "nhập liệu" của chuỗi GPT yêu cầu đo).
5. Đóng bàn phím, thoát split (**teardown**): phiên
   đóng sạch, không treo controls, không lỗi khi mở
   lại split ngay sau đó (mắt "teardown" của chuỗi).

**Bước 4 — Hiệu chuẩn pinch có chủ đích (chỉ thu dữ
kiện; đánh dấu bằng thao tác rõ ràng, làm CHẬM từng
động tác, mỗi động tác cách nhau ~5 giây để log tách
được).** Segment pinchMode = **Đo (1)**. Tất cả trong
**ô TRÁI**:
1. **Một ngón đặt đứng yên 3 giây** trong ô trái rồi
   nhấc lên.
2. **Một ngón kéo ngang** chậm qua ô trái rồi nhấc lên.
3. **Hai ngón đặt đứng yên 3 giây trong CÙNG ô trái**
   rồi nhấc lên.
4. **Hai ngón tách ra** (từ gần nhau kéo giãn ra) rồi
   nhấc lên.
5. **Hai ngón chụm vào** (từ xa kéo lại gần) rồi nhấc
   lên.
Mục đích duy nhất: đội phân tích đọc `[touchset]` tìm
**hai contact độc lập thật** (hai điểm bắt đầu phân
biệt, timestamp event phân biệt) giữa biển biểu diễn
trùng đã đo ở hai phiên trước (62/62 trùng). KHÔNG
chấm lệnh pinch nào ở bước này (DRY_RUN không bắn
lệnh); nếu pinch tình cờ trông như có tác dụng thị
giác, ghi mốc thời gian, không kết luận.

**Bước 5 — Hồi quy.**
1. **Native wake:** split có ô native (Maps/Music/
   GOFA), chờ mờ, chạm ô native → controls hiện
   (`[probe-feed] fired` → reveal) như phiên ytz3.
2. **YTZ:** bật video YouTube fullscreen trong split:
   phóng đúng như các phiên đã PASS. (Nếu trong phiên
   có tắt công tắc YouTube giữa chừng: sau phiên đội
   phân tích đối chiếu `[ytz-revoke-snap]` ↔
   `[ytz-nextlayout]` — chỉ lệch hình học mới tính là
   sai lệch cần sửa; không bắt buộc tắt trong phiên
   này.)
3. **Icon OmniCar:** trong và sau phiên (đặc biệt sau
   các lần thoát Home / dựng phiên toàn-native), kiểm
   icon OmniCar còn trên lưới/dock gốc không; **nếu
   lại mất, ghi lại MỐC THỜI GIAN** càng chính xác
   càng tốt. Sau phiên đọc `[homelib]`: dòng OMNI
   `decision=remove` = kết án tại chỗ; hoàn toàn
   không có dòng OMNI cho bundle đó = điểm mất nằm
   hạ nguồn của đường inject/remove.
4. Hồi quy chung: thanh "..." của app hosted mở/đóng
   bình thường; solo/split/swap; nút Home; núm
   divider trở về kích thước thường khi thả, phình
   đúng khi bấm, chạm cách vạch vài cm phải vào được
   app (chấm quan sát — log vẫn NO DATA cho núm);
   splash chào (phần nhiệt độ chỉ chấm khi phiên có
   request thời tiết thật khép chuỗi ở log).

## Điều kiện mở ENFORCE (sau phiên này)

- **Wake ENFORCE (nuốt chạm đầu, Gate 3):** vẫn KHOÁ
  theo GPT. Vòng này mới sửa tín hiệu kb có xác thực;
  theo đúng phán quyết GPT, sửa tín hiệu xong **vẫn
  chưa** được coi là suppression đã có bằng chứng
  trọn — cần phiên này đo đủ chuỗi ở mức wouldSwallow
  (bước 3: ca kb đóng ra wouldSwallow=1 với tri thức
  owner, ca kb ACTIVE chặn về 0, nhập liệu không kẹt,
  teardown sạch) rồi GPT mới phán mở cổng.
- **Pinch ENFORCE:** mặc định DRY_RUN. Chỉ bàn khi:
  controller khép đủ hai chiều guard (bước 2), dữ
  kiện hiệu chuẩn ở bước 4 tìm được hai contact độc
  lập, và GPT phán kiến trúc ghép cặp. Không tự bật
  segment Enforce trong phiên này.

## Còn mở (không thuộc nghiệm thu phiên này)

- Hai lệch phụ của kiểm độc lập (PATCH_NOTES §27.5):
  consumer `appbridge.keyboard` thứ hai ở
  ABChannels.m:358 (chết trong thực tế — chờ GPT
  quyết dọn hay giữ); biên reset UNKNOWN khi gán
  lại cùng bundle cùng slot (chờ GPT quyết có đóng
  ở tầng owner không).
- Đối xứng revoke YTZ: GPT đã phán KHÔNG layout
  cưỡng bức; chỉ sửa nếu cặp snapshot ở bước 5.2
  cho thấy sai lệch thực tế.
- Weather: chờ một phiên có request thật; đề xuất
  chở generation qua notify state (PATCH_NOTES
  §25.5(iii)) vẫn mở.
- Accessor gen chỉ-đọc ở BridgeWake.h (PATCH_NOTES
  §25.5(i)): vẫn mở — feed native tiếp tục dùng
  epoch của probe.
- Snapshot ở đường unconfirmed của FS controller
  (ngoài 6 điểm refuse ở cổng vào): chưa có — cộng
  thêm nếu GPT yêu cầu.
- Bản sao Weather phía Prefs (OMCCommon.m): GPT
  phán chỉ audit đọc. ahForgetView: chờ GPT phán.
- VISUAL_ORIGINAL_COMPARISON: vẫn PENDING.

## Kết quả phiên xe ytz4 (2026-11-09; log upload `8db6471`, PATCH_NOTES §28)

Phạm vi verdict: binary ytz4 từ 17:23:48 (PID 35998)
tới hết log 17:44:31 — hai file log chứa hai thế hệ
binary, phần trước mốc là binary cũ (§28.0).

- **Bước 1 (fullscreen fade): DEVICE PASS.** Fade chạy
  trong EXPANDED: E3 136,6 s fade+reveal khép; E2
  74,0 s 3 fade; suspend tại expand 0/3 (ytz3: 13/13).
- **Bước 2 (ca guard ngược): DEVICE PASS.** Chuỗi
  khép trọn 17:28:14→17:28:20.989: picker mở → expand
  bị từ chối với snapshot `picker=1` → đóng hẳn →
  expand confirmed. Guard đủ hai chiều; mục fullscreen
  đóng nghiệm thu ở các ca đã chạy.
- **Bước 3 (chuỗi wouldSwallow): PASS ở mức would,
  chuỗi trọn NO DATA.** KB transport DEVICE PASS —
  giặt nguồn đã đóng: kbSrc=owner 42/48 probe,
  kbAge max 3131 ms, 18/18 post mở/đóng khớp owner
  ≤3 ms. wouldSwallow=1 ×8, 100% đúng tổ hợp
  known=1/active=0/owner/state=H. Nhưng chuỗi trọn
  thiếu đúng 3 mắt do thứ tự phiên: probe quyết định
  (17:32:24.119) xảy ra TRƯỚC khi phím mở
  (17:32:24.190); cửa sổ overlap HIDDEN + kb ACTIVE
  (17:32:28–34) có 0 probe; gõ chữ 0 dòng; sau đóng
  phím 0 probe cùng assignment. NO DATA hành vi
  phiên, không phải FAIL — Gate 3 chờ 3 mắt này +
  phán quyết GPT, kịch bản phiên sau phải ép chúng.
- **Bước 4 (hiệu chuẩn pinch): NO DATA.** Hiệu chuẩn
  đánh dấu KHÔNG được thực hiện (0 episode chạm
  ≥2 s); [touchset] active=2 101 ca, duplicate
  101/101 — mẫu thứ ba liên tiếp toàn trùng. Kiến
  trúc ghép cặp vẫn chưa quyết được.
- **Bước 5 (hồi quy): PASS.** Native feed fired 86,
  chuỗi fade→fired→reveal 14/14, act 54/54. YTZ ack
  51/51, mask 24 lọt 0 (DEVICE PASS); OFF control
  NO DATA (phiên này không tắt pref); revoke-snap 7 /
  nextlayout 3, cặp 3/7 (4 vắng khớp giới hạn
  instrument đã khai). W2 xuất hiện lần đầu:
  stateage max 8092 ms, 12/54 ca >2500 ms.
- **Phát sinh trong phiên (ngoài kịch bản):** (i) bàn
  phím bị bó ở ảnh 3 — KẾT ÁN che khuất z-order (giữa
  hai ảnh chỉ 1 hide 17:32:34.308, 0 show mới; khung
  đóng băng tại show). (ii) Icon YouTube: trong-split
  CHƯA PHÂN ĐỊNH ở tầng cell dashboard (lớp sơn mờ
  minh oan ở source; [homelib] remove = 0); sau-thoát
  tương quan đường thoát đã khớp log — ĐÃ MỜ ⇒
  goHome=NO 5/5, goHome=1 ⇒ đang HIỆN 2/2, thư viện
  không bị kết án (decision cuối vẫn inject); bước
  dashboard làm rớt cell chưa chứng minh.
  (iii) Weather/knob NO DATA lần thứ ba (req# = 0;
  payload knob = 0).
- **Chuyển sang vòng sau:** Gate 3 ép 3 mắt (mục 1 ở
  §28.12); icon — instrument phía cell/apply cho app
  injected hoặc chấp nhận tương quan đường thoát;
  pinch — hiệu chuẩn vẫn phải làm mới quyết kiến
  trúc; `ahFadedState` rò phiên (khiếm khuyết riêng,
  chờ duyệt sửa); weather/knob (instrument hay bỏ
  tiêu chí — chờ GPT). Cộng hai thay đổi theo lệnh
  trực tiếp của Nguyen chờ gộp deb sau (§28.11): tấm
  nền bảng chọn app ở ô đích thành trong suốt khi ô
  có app (customisation vượt gốc — gốc cũng trắng);
  cộng 1 dòng log rect phím (carAppArea + panel
  frame) tại lúc show.

## Trạng thái

- ytz4: SOURCE HOÀN THIỆN + STATIC PASS (candidate +
  FAT hai lát). **Phiên xe ĐÃ chạy (2026-11-09) và
  phân tích xong** — verdict từng mục ở mục "Kết quả
  phiên xe ytz4" trên đây và PATCH_NOTES §28. DEVICE
  PASS: FS + guard ngược, fade-EXPANDED, kb
  transport, wouldSwallow mức would, feed native,
  YTZ. Gate 3 vẫn ĐÓNG (còn 3 mắt NO DATA); ENFORCE
  pinch vẫn khoá.
- QA20 vẫn là bản dùng hằng ngày của Nguyen. ytz1
  CÁCH LY — không cài. Rollback: ytz3 FAT / ytz2 FAT /
  fs1 FAT / fixround7 FAT / gói hợp nhất QA20.
