# S1 — KHUNG PHIÊN + FULLSCREEN — phiên ytz4

Nguồn: `OmniCar.log.old` (10.889 dòng) + `OmniCar.log` (1.678 dòng),
tổng 12.567 dòng. Số thứ tự "idx" trong biên bản này = vị trí trong
chuỗi ghép old→new (0-based); idx < 10889 thuộc log.old (dòng file =
idx+1), idx ≥ 10889 thuộc log (dòng file = idx−10888). Mốc giờ là
danh tính chính. Đối chiếu: integration-ytz4.md, verify-ytz4.md,
fix-hb-kb-host-autohide.md, ci-ytz4.md.

## PHÁT HIỆN KHUNG QUYẾT ĐỊNH (đọc trước mọi con số)

Hai file log chứa HAI thế hệ binary, không phải một phiên ytz4 liền:

- Chuỗi chỉ có ở ytz4 (ci-ytz4 §5.2: ytz3 = 0): `[homelib]`,
  `[kb-sync]`/kênh `appbridge.kbsync`, `[ytz-revoke-snap]`.
  Trong toàn bộ log, các chuỗi này xuất hiện LẦN ĐẦU ở tiến trình
  CarPlay 35998 (17:23:48) — xem §1. Mọi dòng trước đó (PID 35035,
  35411) có `[kb-sync]` = 0, `[homelib]` = 0, và mang chữ ký hành vi
  bản cũ (§4.3). Chuỗi "build 1.0.3 (fbebb21)" giống nhau ở mọi PID
  nên KHÔNG phân biệt được thế hệ; chỉ instrument mới phân biệt được.
- Hệ quả: mọi đếm ở §2–§4 tách hai phạm vi: TOÀN FILE và RIÊNG YTZ4
  (idx ≥ 3401, PID CarPlay 35998/36057/36136/36168). Verdict lấy
  phạm vi YTZ4 làm chuẩn; số toàn file chỉ để đối chiếu.

## 1) KHUNG PHIÊN

### 1.1 Marker đầu tiên của bản ytz4

Dòng đầu tiên của tiến trình CarPlay chạy bản ytz4 (nguyên văn):

> `2026-11-09 17:23:48.836 [CarPlay:35998] SplitScreen: [fs1] fs controller installed (CarPlayApp)` (idx3401)

Dòng marker CHỈ ytz4 mới có, sớm nhất trong log (nguyên văn):

> `2026-11-09 17:23:49.525 [CarPlay:35998] SplitScreen: [homelib] proc=CarPlay(com.apple.CarPlayApp) decision=skip-not-chosen bundle=com.apple.mobilecal` (idx3405)

Marker kb đầu tiên (nguyên văn):

> `2026-11-09 17:23:56.498 [SpringBoard:35973] AppBridge: [kb-sync] host post com.google.ios.youtube active=0 session=0 source=host-keyboard-session` (idx3663)

Lưu ý: KHÔNG có chuỗi "ytz4" nào trong log (grep = 0). SpringBoard
reload mở đầu thế hệ ytz4 lúc 17:22:28.428 (PID 35973,
`AppBridge: loaded into SpringBoard`, idx3371) — trước CarPlay
35998 ~80 s. [Đang giả định] khoảng 17:09→17:22 là cửa sổ
cài/respring ytz4: log không có dòng nào ghi việc cài đặt.

### 1.2 PID CarPlay + mốc chuyển

| PID CarPlay | Khoảng sống | Ghi chú |
|---|---|---|
| 35035 (trước ytz4) | 16:35:41→16:54:07 | log mở giữa phiên (seq=505); ngắt màn 16:42:18, nối lại 16:53:36 |
| 35411 (trước ytz4) | 16:54:31→17:09:01 | kết thúc bằng `screen disconnected` 17:09:01.955 |
| — trống — | 17:09:02→17:23:48 (886,9 s) | SB reload 17:22:28 (PID 35973) |
| 35998 (ytz4) | 17:23:48→17:40:12 (983,7 s) | phiên ytz4 chính |
| 36057 (ytz4) | 17:40:26→17:42:27 | SB đi kèm 36056 |
| 36136 (ytz4) | 17:42:36→17:43:37 | SB đi kèm 36137 |
| 36168 (ytz4) | 17:43:40→17:44:26+ | SB đi kèm 36167; log cắt lúc còn sống |

SpringBoard đổi PID đồng bộ với CarPlay ở mọi mốc (35036→35412→
35973→36056→36137→36167): mẫu restart CẢ SpringBoard+CarPlay, và
ba lần cuối dồn dập cách nhau ~1–2 phút.

### 1.3 Crash / respring — bằng chứng

Grep toàn 12.567 dòng: `exception` 0, `SIGBUS` 0, `SIGSEGV` 0,
`SIGABRT` 0, `EXC_` 0, `backtrace` 0, `respring` 0, `jetsam` 0.
Các hit của `crash` (5), `fault` (95), `terminat` (5), `watchdog`
(10) đều là nhiễu trong các dòng dump lớp `DIAG ...` (tên
selector/ivar như `_blocked`, `refusesRecipientStatus`) — đã đọc
tận nơi, không dòng nào là báo cáo crash thật.

**Kết luận mục này: chưa rõ nguyên nhân** (đúng quy ước các phiên
trước). Log cho thấy PID CarPlay+SpringBoard thay đồng loạt nhưng
không mang bất kỳ chữ ký crash/signal/backtrace nào; không kết án
crash, cũng không kết án respring chủ động, từ log này được.

### 1.4 Thời lượng + split bật/tắt áng chừng

- Toàn hai file: 16:35:40.244 → 17:44:31.969 = 4.131,7 s
  (~68 phút 52 giây), gồm cả phần trước ytz4 và khoảng trống 886,9 s.
- Riêng ytz4: SB reload 17:22:28.428 → hết log = 1.323,5 s
  (~22 phút 04 giây); CarPlay 35998 load → hết log = 1.243,1 s.
- Split bật/tắt (áng chừng theo dòng có sẵn): `[autohide] session
  start` ×12 toàn file (×10 ở phần ytz4, riêng PID 35998 đã ×7 —
  mỗi lần gán lại app là một session); `[scenevis] going-home`
  ×20 dòng = 10 đợt (mỗi đợt 2 dòng/2 ô), trong đó 9 đợt thuộc
  ytz4; `dong o` ×8. Ước lượng: ~9–10 lần split đóng/mở trong
  phần ytz4. Đây là đếm theo dòng assign/going-home như đề bài,
  không phải bộ đếm sự kiện công tắc riêng.

**Verdict §1: NO DATA** (khung phiên đã dựng đủ bằng số, nhưng
nguyên nhân chuyển PID dồn dập ở cuối phiên không có bằng chứng
trong log — chưa rõ nguyên nhân).

## 2) FULLSCREEN (SCPFullscreenController, pref fullscreenDiagExpand)

Đường expand duy nhất ngoài pinch-DRY_RUN; mọi dòng dưới đều
`provenance=diag`.

### 2.1 Đếm (phạm vi YTZ4 / toàn file)

| Sự kiện | YTZ4 | Toàn file |
|---|---|---|
| `[fs-diag] fullscreenDiagExpand -> ON` | 9 | 10 |
| `[fs-diag] fullscreenDiagExpand -> OFF` | 10 | 11 |
| `[fs1] fs expand confirmed` | 3 (txn=1,3,5 của PID 35998) | 4 (+1 ở PID 35411) |
| `[fs1] fs restore confirmed` | 3 (txn=2,4,6) | 3 |
| `[fs1] fs session-end abbreviated restore` (teardown) | 0 | 2 (35035, 35411) |
| expand refused | 6 | 6 |
| restore refused | 7 | 8 |

Chênh ON/OFF ở phần ytz4: có 4 OFF là restore-thử khi đang SPLIT
(bị refused, không phải restore thật) và OFF cuối ở PID 36136
không có expand nào trước nó trong tiến trình đó — xem §2.2.

### 2.2 Refusals theo reason (toàn bộ là state-based, như baseline ytz3)

Expand refused ×6 (chỉ ở phần ytz4):
- `reason=picker` ×2 — chi tiết ở §3.
- `reason=inactive` ×4 — cả bốn ở PID 36136, 17:43:26–17:43:32,
  khi tiến trình vừa lên và split chưa active. Mẫu nguyên văn:

> `2026-11-09 17:43:26.287 [CarPlay:36136] SplitScreen: [fs1] fs expand refused reason=inactive provenance=diag snap{tw=1 twh=1 to=1 tray=0 picker=0 ratio=0 dg=0 toast=0 rz=0 fc=0 phase=0}` (idx11957)

Restore refused ×8 toàn file (×7 ytz4), TẤT CẢ `state=SPLIT`
(tức restore khi chưa hề expanded — công tắc OFF dư). Hai mẫu
nguyên văn:

> `2026-11-09 17:24:41.027 [CarPlay:35998] SplitScreen: [fs1] fs restore refused state=SPLIT provenance=diag snap{tw=1 twh=1 to=0 tray=0 picker=0 ratio=0 dg=0 toast=0 rz=0 fc=0 phase=0}` (idx3992)

> `2026-11-09 17:28:17.318 [CarPlay:35998] SplitScreen: [fs1] fs restore refused state=SPLIT provenance=diag snap{tw=1 twh=0 to=0 tray=0 picker=1 ratio=0 dg=0 toast=0 rz=0 fc=0 phase=0}` (idx5290)

Không có refusal nào thuộc loại khác (không tray/ratio/drag/
toast/phase trong bất kỳ snapshot nào của các refusal).

**Verdict §2: DEVICE PASS** — công tắc chẩn đoán chạy đủ chu
trình ở ytz4: 3 expand confirmed / 3 restore confirmed khép cặp
trong PID 35998; 13 refusal ở phần ytz4 đều state-based và đọc
được lý do từ snapshot (picker 2, inactive 4, SPLIT-restore 7).

## 3) CA GUARD NGƯỢC — picker đang mở mà xin expand (mục còn thiếu từ ytz3)

**CÓ CA ĐẦY ĐỦ, và chuỗi sau chặn khép trọn.** Tất cả trong PID
35998, sau khi restore txn=4 đóng expanded lúc 17:28:13.892.

Dòng mở picker gần nhất trước refusal (nguyên văn):

> `2026-11-09 17:28:14.216 [CarPlay:35998] SplitScreen: CarSplit: popup chon 18 app cho o 0 (cua so rieng, 0 o cho)` (idx5269)

Hai lần expand bị chặn, `picker=1` trong snapshot (nguyên văn):

> `2026-11-09 17:28:15.785 [CarPlay:35998] SplitScreen: [fs1] fs expand refused reason=picker provenance=diag snap{tw=1 twh=0 to=0 tray=0 picker=1 ratio=0 dg=0 toast=0 rz=0 fc=0 phase=0}` (idx5283)

> `2026-11-09 17:28:17.819 [CarPlay:35998] SplitScreen: [fs1] fs expand refused reason=picker provenance=diag snap{tw=1 twh=0 to=0 tray=0 picker=1 ratio=0 dg=0 toast=0 rz=0 fc=0 phase=0}` (idx5296)

(Giữa hai lần này còn một restore-thử lúc 17:28:17.317 cũng bị
refused state=SPLIT với `picker=1` — idx5290, đã trích ở §2.2.
Bằng chứng phụ picker đang mở suốt quãng: `[autohide] fade
deferred (surface-open)` lúc 17:28:15.130 và 17:28:19.132.)

Sau ca bị chặn — đóng picker → expand chạy, CÓ đủ chuỗi:
chạm đóng/ngoài picker lúc 17:28:19.955
(`[probe-feed] ... drop-popup(picker)`, idx5312 và idx5331);
state về `UNKNOWN->VISIBLE` 17:28:20.971; công tắc ON
17:28:20.971 và expand chạy ngay (nguyên văn):

> `2026-11-09 17:28:20.989 [CarPlay:35998] SplitScreen: [fs1] fs expand confirmed txn=5 provenance=diag` (idx5357)

rồi restore confirmed txn=6 lúc 17:28:22.052 đóng chu trình.

Ghi chú phân biệt: picker cũng mở lúc 17:27:16.191 (idx5057)
NHƯNG lúc đó đang EXPANDED sẵn nên không phát sinh yêu cầu
expand nào — không phải ca guard; hệ quả của nó là fade bị
deferred (surface-open) ở §4, đúng khoá popup còn giữ.

**Verdict §3: DEVICE PASS** — ca guard ngược bắt buộc đã có dữ
liệu thật: mở picker 17:28:14.216 → 2 expand refused
reason=picker, picker=1 (17:28:15.785, 17:28:17.819) → đóng
picker → expand confirmed txn=5 (17:28:20.989).

## 4) FADE KHI EXPANDED (sau gỡ 3 khoá ở ytz4)

Định nghĩa đếm: "fade" = dòng timer phía CarPlay
`[autohide] fade last=...` (kèm cặp phía host `host fade applied`
+ `host knob fade applied` cùng nhịp). Khoảng EXPANDED =
`fs expand confirmed` → restore confirmed / session-end restore.

### 4.1 Mọi khoảng EXPANDED

| # | Khoảng | Độ dài | fade last= | Kết |
|---|---|---|---|---|
| E1 (trước ytz4, PID 35411) | 16:55:21.727 → 17:09:01.879 (session-end) | 820,2 s | 0 | §4.3 |
| E2 (ytz4, PID 35998) | 17:24:41.776 → 17:25:55.822 | 74,0 s | 3 | fade + reveal khép |
| E3 (ytz4, PID 35998) | 17:25:57.307 → 17:28:13.892 | 136,6 s | 1 (+14 deferred) | fade + reveal khép |
| E4 (ytz4, PID 35998) | 17:28:20.989 → 17:28:22.052 | 1,1 s | 0 | quá ngắn (< ngưỡng idle 4 s) — không giá trị |

Khoảng expanded DÀI NHẤT của ytz4 là E3 (136,6 s) — CÓ fade
trong nó (xem 4.2). Khoảng dài nhất toàn file là E1 (820,2 s)
nhưng thuộc binary trước ytz4, không tính cho ytz4 (§4.3).

### 4.2 Chuỗi fade → reveal trong expanded ytz4 (bằng chứng)

E2 — 3 fade, mỗi fade đều kèm `->HIDDEN` + host applied:
- 17:25:10.386 `fade last=hostknob idle=4.00` (trước đó
  `UNKNOWN->HIDDEN` 17:25:10.385) → reveal khi chạm:
  17:25:12.674 `reveal-applied reason=activity views=5` kèm
  `HIDDEN->VISIBLE` + host fade restored. KHÉP (+2,3 s).
- 17:25:16.678 `fade last=container idle=4.01`
  (`VISIBLE->HIDDEN` 17:25:16.677) → reveal 17:25:22.525
  `reveal-applied reason=activity`. KHÉP (+5,8 s).
- 17:25:53.593 `fade last=container idle=4.00`
  (`VISIBLE->HIDDEN` 17:25:53.592) → không reveal vì restore
  đóng khoảng ngay sau (17:25:55.822) — fade là trạng thái cuối
  của khoảng, đúng kỳ vọng.

E3 — 1 fade: 17:26:51.589 `fade last=dragend idle=4.00`
(`UNKNOWN->HIDDEN` cùng ms, host applied 17:26:51.595) →
reveal 17:27:08.550 `reveal-applied reason=activity views=5`
kèm `HIDDEN->VISIBLE` + host restored. KHÉP (+17,0 s).
Nửa sau E3 (17:27:19→17:28:11): fade bị `deferred
(surface-open)` ×14 vì picker mở từ 17:27:16 — đây là khoá
popup CỐ Ý GIỮ (fix-hb chỉ gỡ hạng tử expanded), không phải lỗi.

Dấu hiệu gỡ khoá ở chính thời điểm expand ytz4: tại E2/E3
KHÔNG có `[autohide] suspend` đi kèm `bw expanded ON` và KHÔNG
có phép nâng `HIDDEN->VISIBLE` — state lúc expand của E2/E3 vào
đã là HIDDEN và giữ HIDDEN (E2: emit HIDDEN liên tục từ
17:24:41.776; đối chiếu E1 ở 4.3 bị nâng ngay). Toàn phần ytz4
chỉ có 3 dòng `[autohide] suspend` (17:35:47, 17:36:03,
17:37:23) và cả ba đều trùng chuyển hosted-solo ("chi giu ...
-> App Bridge toan man" / pane-remove còn 1 ô) — đúng đường
solo được giữ nguyên theo thiết kế, không dòng nào trùng expand.

### 4.3 E1 — khoảng 820,2 s không fade, và vì sao không tính cho ytz4

E1 vẫn mang NGUYÊN chữ ký cũ mà ytz4 đã gỡ (nguyên văn, cả hai
dòng cùng mốc 16:55:21.727):

> `2026-11-09 16:55:21.727 [CarPlay:35411] SplitScreen: [wake1] bw state com.google.ios.youtube HIDDEN->VISIBLE gen=1` (idx1565)

> `2026-11-09 16:55:21.727 [CarPlay:35411] SplitScreen: [autohide] suspend` (idx1568)

Trong E1: 820 dòng emit đều `state=VISIBLE` (HIDDEN = 0), fade
= 0, kết thúc `[autohide] teardown faded=0` (idx3321). Đây là
hành vi của binary TRƯỚC ytz4 (PID 35411 không có bất kỳ dòng
[kb-sync]/[homelib] nào, và nhịp renew của nó không phát gói kb
như PID 35998 phát mỗi giây). Nó tái lập đúng bức tranh ytz3
(0 fade trong ~961 s expanded) — ở binary cũ, không phải bằng
chứng ytz4 còn khoá. Nếu gộp toàn file mà không tách thế hệ sẽ
kết luận sai ngược.

**Verdict §4: DEVICE PASS** (phạm vi ytz4) — expanded dài nhất
136,6 s có fade; tổng 4 fade timer trong expanded ytz4, 3 chuỗi
fade→reveal khép bằng chạm, 1 fade là trạng thái cuối trước
restore; không còn suspend/nâng-HIDDEN tại expand; phần fade bị
chặn còn lại duy nhất là deferred (surface-open) khi picker mở
— khoá được giữ có chủ đích. E4 (1,1 s) là NO DATA theo độ dài
nhưng không ảnh hưởng verdict vì E2/E3 đã đủ dữ liệu.

## TỔNG KẾT VERDICT S1

- §1 Khung phiên: **NO DATA** về nguyên nhân chuyển PID (khung
  đã dựng: ytz4 thật bắt đầu 17:23:48, PID 35998; toàn file
  4.131,7 s, phần ytz4 1.323,5 s; crash grep sạch — chưa rõ
  nguyên nhân).
- §2 Fullscreen: **DEVICE PASS** (ytz4: ON 9 / OFF 10, expand
  confirmed 3, restore confirmed 3, refusal 13 đều state-based).
- §3 Guard ngược picker: **DEVICE PASS** (ca đầy đủ + chuỗi
  đóng picker → expand confirmed txn=5).
- §4 Fade khi EXPANDED: **DEVICE PASS** (E2 74,0 s: 3 fade;
  E3 136,6 s: 1 fade; fade→reveal khép 3/3 ca có chạm sau fade).

Có bằng chứng (đếm trực tiếp trên log, trích nguyên văn ở trên):
mọi con số §1–§4, ranh giới hai thế hệ binary (instrument
ytz4-only = 0 trước idx3401, xuất hiện từ idx3401/3405/3663),
chữ ký cũ ở E1 so với chữ ký mới ở E2/E3.
Đang giả định (không có dòng log trực tiếp): khoảng trống
17:09→17:22 là cửa sổ cài/respring ytz4; việc đóng picker trước
expand txn=5 được suy từ dòng chạm `drop-popup(picker)` +
expand thành công ngay sau, không có dòng "picker closed"
tường minh.
