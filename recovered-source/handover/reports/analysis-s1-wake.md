# S1 — WAKE PHIÊN HL3 — Biên bản phân tích chỉ-đọc

## 0. Phạm vi, nguồn, phương pháp

- File gốc 1: `OmniCar.log.old` (12.808 dòng) — CHỈ lấy đoạn thế hệ hl3: từ dòng 6701 (dòng đầu chứa `2026-11-10 06:26:34`) tới cuối file = 6.108 dòng. Các dòng 1–6700 là thế hệ hl2, BỎ hoàn toàn.
  - Dòng mốc: `2026-11-10 06:26:34.436 [SpringBoard:37965] AppBridge: loaded into SpringBoard`
- File gốc 2: `OmniCar.log` (783 dòng) — toàn bộ đều thuộc hl3.
- Corpus hl3 hợp nhất = 6.108 + 783 = **6.891 dòng**, phiên 06:26:34 → 06:37:43 (2026-11-10).
- Thế hệ hl3: SpringBoard PID 37965, CarPlay PID 37987, YouTube PID 37993 / 37999 / 38003, Facebook PID 38006, GOFA PID 37991. (TikTok PID 38009 xuất hiện thêm ở phần `OmniCar.log`, bundle `com.ss.iphone.ugc.Ame`.)
- Mọi con số dưới đây đếm bằng `grep -c` / pipeline grep trên corpus hl3 hợp nhất (tái tạo bằng `sed -n '6701,$p' OmniCar.log.old` + `cat OmniCar.log`), đối chiếu chéo bằng parser regex trên cùng corpus. Không ước lượng.
- Thuật ngữ trong log: `bw nuot day` = app nuốt (giữ) dãy chạm; `bw ack seq=` = app nhận ack của owner; `bw ack timeout ... fail-open` = app chờ ack quá hạn rồi fail-open; `wouldSwallow` = quyết định của cổng phía app (chưa phải nuốt thật); `wm` trong `[wake1] bw emit` phía host: YouTube `wm=2`, mọi app khác `wm=1`; phía owner, `[gate3] trial packet ... wm=ENFORCE` chỉ xuất hiện cho YouTube.

## Tóm tắt verdict S1

**LOG-CONFIRMED** cho phát biểu "nuốt YouTube ĐẠT, app khác click do trial" — ở tầng nuốt khởi phát + host chuyển trạng thái; kèm 1 lưu ý cứng ở tầng ack (xem §1.3):

- Nuốt thật phía YouTube: **12 ca `bw nuot day`** (3 PID), cả 12/12 đều có phía owner, tại cùng mili-giây (±11 ms), dòng `[wake1] bw state com.google.ios.youtube HIDDEN->VISIBLE` + `[gate3] trial packet ... wm=ENFORCE ... state=VISIBLE`.
- Ack phía app: chỉ **5/12 ca có `bw ack seq=`** (toàn bộ ở PID 37993, trễ 4–18 ms); **7/12 ca `bw ack timeout`** (PID 37999: 3, PID 38003: 4; trễ 1,575–1,763 s) rồi fail-open tới state tươi kế tiếp. Host vẫn đã chuyển HIDDEN->VISIBLE ở cả 7 ca timeout, nên wake trên màn hình không bị undo trong log; phần không đạt là vòng ack app↔owner ở 2 PID sau.
- **Nuốt nhầm: 0 ca** theo tiêu chí state=V / kbActive=1 / ngoài ô YouTube (xem §3; có 1 ca thiếu dòng probe để đối chiếu, ghi riêng ở §3.2).
- App khác sẵn sàng cho mở rộng ENFORCE (wouldSwallow=1 nhưng bị giữ ở wm=1/trial): **5 ca, toàn bộ Facebook** (`com.facebook.Facebook`); TikTok 0, GOFA 0 (xem §4).
- L7 lệch seq tối đa quan sát được (stateSeq phía app vs seq emit gần nhất phía host): **18** (xem §5).
- Fail-open dạng probe (wouldSwallow=0 khi state=H trên YouTube): **đúng 1 ca**, trường phân biệt duy nhất là `stateAgeMs=123` (xem §6).

---

## 1. Swallowed THẬT trên YouTube

### 1.1 Đếm theo loại dòng (grep trên corpus hl3)

| Mẫu dòng | Số lượng |
|---|---|
| `[do] bw nuot day` (app nuốt dãy) | **12** |
| `[do] bw ack seq=` (app nhận ack) | **5** |
| `[do] bw ack timeout` (app chờ ack quá hạn) | **7** |
| `swallowed` (toàn corpus, mọi tiến trình) | **0** |
| `held` (toàn corpus, mọi tiến trình) | **0** |
| `[do] bw mixed touch giua day nuot` | 2 |

Phía owner (SplitScreen/CarPlay) KHÔNG có dòng nào chứa chữ `swallowed`, `held`, hay ack dạng từ độc lập cho từng ca nuốt (các hit "ack" phía CarPlay đều là chuỗi con trong `packet`/`back` của dòng `[gate3] trial packet` và DIAG). Bằng chứng owner cho từng ca nuốt là cặp dòng đồng thời ở §1.2: `[wake1] bw state ... HIDDEN->VISIBLE` + `[gate3] trial packet bundle=com.google.ios.youtube slot=0 wm=ENFORCE (global 1) state=VISIBLE ...`. Tổng số dòng `[gate3] trial packet` trong phiên: 95, toàn bộ cho `com.google.ios.youtube`, toàn bộ `wm=ENFORCE`.

### 1.2 Liệt kê từng ca nuốt (12 ca)

`probe=` là seq của dãy chạm phía app (khóa nối sang dòng probe ở §2); `txn=`/`ack seq=` là bộ đếm giao dịch riêng theo từng PID. 11/12 ca nối được sang dòng probe có `wouldSwallow=1, state=H, kbKnown=1, kbActive=0, kbSrc=owner, hosted=1`; ca ngoại lệ duy nhất ghi ở hàng 10.

| # | Nuốt (timestamp + dòng) | Probe nối | Ack phía app | Owner cùng thời điểm |
|---|---|---|---|---|
| 1 | `2026-11-10 06:27:18.481 [YouTube:37993] AppBridge: [do] bw nuot day: txn=1 probe=1` | seq=1, state=H, stateSeq=52, wouldSwallow=1 | `2026-11-10 06:27:18.499 [YouTube:37993] AppBridge: [do] bw ack seq=1` (+18 ms) | `06:27:18.482 [CarPlay:37987] SplitScreen: [wake1] bw state com.google.ios.youtube HIDDEN->VISIBLE gen=1` + gate3 VISIBLE count=25 |
| 2 | `2026-11-10 06:27:23.385 [YouTube:37993] AppBridge: [do] bw nuot day: txn=2 probe=2` | seq=2, state=H, stateSeq=73, wouldSwallow=1 | `2026-11-10 06:27:23.392 [YouTube:37993] AppBridge: [do] bw ack seq=2` (+7 ms) | `06:27:23.390 ... HIDDEN->VISIBLE gen=1` + gate3 VISIBLE count=34 |
| 3 | `2026-11-10 06:27:44.066 [YouTube:37993] AppBridge: [do] bw nuot day: txn=3 probe=10` | seq=10, state=H, stateSeq=142, wouldSwallow=1 | `2026-11-10 06:27:44.075 [YouTube:37993] AppBridge: [do] bw ack seq=3` (+9 ms) | `06:27:44.069 ... HIDDEN->VISIBLE gen=1` + gate3 VISIBLE count=62 |
| 4 | `2026-11-10 06:27:54.299 [YouTube:37993] AppBridge: [do] bw nuot day: txn=4 probe=12` | seq=12, state=H, stateSeq=175, wouldSwallow=1 | `2026-11-10 06:27:54.313 [YouTube:37993] AppBridge: [do] bw ack seq=4` (+14 ms) | `06:27:54.310 ... HIDDEN->VISIBLE gen=1` + gate3 VISIBLE count=76 |
| 5 | `2026-11-10 06:28:20.254 [YouTube:37993] AppBridge: [do] bw nuot day: txn=5 probe=15` | seq=15, state=H, stateSeq=260, wouldSwallow=1 | `2026-11-10 06:28:20.258 [YouTube:37993] AppBridge: [do] bw ack seq=5` (+4 ms) | `06:28:20.254 ... HIDDEN->VISIBLE gen=1` + gate3 VISIBLE count=112 |
| 6 | `2026-11-10 06:28:54.294 [YouTube:37999] AppBridge: [do] bw nuot day: txn=1 probe=4` | seq=4, state=H, stateSeq=354, wouldSwallow=1 | `2026-11-10 06:28:55.875 [YouTube:37999] AppBridge: [do] bw ack timeout seq=1: fail-open toi state tuoi ke tiep` (+1,581 s) | `06:28:54.294/295 ... HIDDEN->VISIBLE gen=5` + gate3 VISIBLE count=150 |
| 7 | `2026-11-10 06:30:30.806 [YouTube:37999] AppBridge: [do] bw nuot day: txn=2 probe=28` | seq=28, state=H, stateSeq=644, wouldSwallow=1 | `2026-11-10 06:30:32.417 [YouTube:37999] AppBridge: [do] bw ack timeout seq=2: fail-open toi state tuoi ke tiep` (+1,611 s) | `06:30:30.811/812 ... HIDDEN->VISIBLE gen=9` + gate3 VISIBLE count=262 |
| 8 | `2026-11-10 06:30:37.417 [YouTube:37999] AppBridge: [do] bw nuot day: txn=3 probe=29` | seq=29, state=H, stateSeq=665, wouldSwallow=1 | `2026-11-10 06:30:39.033 [YouTube:37999] AppBridge: [do] bw ack timeout seq=3: fail-open toi state tuoi ke tiep` (+1,616 s) | `06:30:37.418 ... HIDDEN->VISIBLE gen=9` + gate3 VISIBLE count=270 |
| 9 | `2026-11-10 06:31:31.504 [YouTube:38003] AppBridge: [do] bw nuot day: txn=1 probe=1` | seq=1, state=H, stateSeq=761, wouldSwallow=1 | `2026-11-10 06:31:33.201 [YouTube:38003] AppBridge: [do] bw ack timeout seq=1: fail-open toi state tuoi ke tiep` (+1,697 s) | `06:31:31.506/507 ... HIDDEN->VISIBLE gen=13` + gate3 VISIBLE count=313 |
| 10 | `2026-11-10 06:32:03.714 [YouTube:38003] AppBridge: [do] bw nuot day: txn=2 probe=2` | **KHÔNG có dòng probe seq=2 của PID 38003 trong corpus** (xem §3.2) | `2026-11-10 06:32:05.289 [YouTube:38003] AppBridge: [do] bw ack timeout seq=2: fail-open toi state tuoi ke tiep` (+1,575 s) | `06:32:03.715/716 ... HIDDEN->VISIBLE gen=15` + gate3 VISIBLE count=339 |
| 11 | `2026-11-10 06:32:59.998 [YouTube:38003] AppBridge: [do] bw nuot day: txn=3 probe=3` | seq=3, state=H, stateSeq=1023, wouldSwallow=1 | `2026-11-10 06:33:01.653 [YouTube:38003] AppBridge: [do] bw ack timeout seq=3: fail-open toi state tuoi ke tiep` (+1,655 s) | `06:33:00.000/001 ... HIDDEN->VISIBLE gen=15` + gate3 VISIBLE count=417 |
| 12 | `2026-11-10 06:33:25.608 [YouTube:38003] AppBridge: [do] bw nuot day: txn=4 probe=4` | seq=4, state=H, stateSeq=1104, wouldSwallow=1 | `2026-11-10 06:33:27.371 [YouTube:38003] AppBridge: [do] bw ack timeout seq=4: fail-open toi state tuoi ke tiep` (+1,763 s) | `06:33:25.610 ... HIDDEN->VISIBLE gen=15` + gate3 VISIBLE count=445 |

Ghi chú phụ: 2 ca đầu của PID 37993 có thêm dòng khóa suppression cho chạm pinch lẫn trong dãy nuốt:
- `2026-11-10 06:27:18.486 [YouTube:37993] AppBridge: [do] bw mixed touch giua day nuot: khoa suppression toi state tuoi ke tiep`
- `2026-11-10 06:27:23.419 [YouTube:37993] AppBridge: [do] bw mixed touch giua day nuot: khoa suppression toi state tuoi ke tiep`

### 1.3 Đọc kết quả §1

- Nuốt khởi phát: 12/12 ca đều là dãy chạm khi state=H (11 ca chứng minh bằng dòng probe; ca 10 chứng minh gián tiếp bằng chuyển HIDDEN->VISIBLE của host tại cùng mili-giây, vì chỉ dãy nuốt mới phát chuyển này trong phiên — mọi chuyển HIDDEN->VISIBLE khác trong phiên đều khớp 1-1 với 11 ca còn lại).
- Vòng ack sạch chỉ ở PID 37993 (5/5, 4–18 ms). Ở PID 37999 và 38003, 7/7 ca đều timeout ở ~1,6 s. Đây là ranh giới theo PID/đợt chạy app, không phải theo ca chạm.
- Vì vậy "nuốt ĐẠT" đúng ở tầng hành vi (dãy bị giữ + logo/controls hiện, host xác nhận chuyển VISIBLE 12/12), nhưng vòng xác nhận ack app↔owner chưa đạt ở 7/12 ca.


---

## 2. Phân bố quyết định cổng (dòng probe)

Tổng dòng `[do] bw probe seq=` trong corpus hl3: **74**. Đếm `dsrc=local-push`: **74/74 (100%)** — không có probe nào từ nguồn khác.

Tổng theo quyết định: `wouldSwallow=1`: **16**; `wouldSwallow=0`: **58**.

### 2.1 Theo app × state

| App (PID) | Probe | state=H: w1/w0 | state=V: w1/w0 | state=U: w1/w0 | Tổng w1/w0 |
|---|---|---|---|---|---|
| YouTube (37993/37999/38003) | 33 | 12 dòng: **11/1** | 17 dòng: 0/17 | 4 dòng: 0/4 | **11/22** |
| Facebook (38006) | 31 | 5 dòng: **5/0** | 26 dòng: 0/26 | — | **5/26** |
| TikTok (38009) | 10 | 3 dòng: 0/3 | 7 dòng: 0/7 | — | **0/10** |
| GOFA (37991) | 0 | — | — | — | 0/0 |
| **Tổng** | **74** | 20 dòng: **16/4** | 50 dòng: **0/50** | 4 dòng: **0/4** | **16/58** |

Quy luật quyết định quan sát được: `wouldSwallow=1` chỉ xảy ra khi state=H; state=V và state=U cho 0/54 ca w1. 4 ca state=H mà w0 gồm 1 ca YouTube (§6) + 3 ca TikTok bị `failopen=pinchin` (§4.3).

### 2.2 Theo trường kb (toàn bộ 74 probe)

| Trường | Phân bố | w1 trong nhóm |
|---|---|---|
| kbKnown=1 | 73 | 16 |
| kbKnown=0 | 1 (Facebook seq=23) | 0 |
| kbActive=0 | 69 | 16 |
| kbActive=1 | 5 (YouTube 3 + Facebook 2) | 0 |
| kbSrc=owner | 69 | 16 |
| kbSrc=local | 5 (trùng đúng 5 ca kbActive=1) | 0 |
| kbAge, nhóm w1 (16 ca) | min 9 ms, max 737 ms, trung vị 320,5 ms | — |
| kbAge, nhóm w0 (58 ca) | min 9 ms, max 14.803 ms, trung vị 386 ms | — |

Theo app: YouTube kbKnown=1 ở 33/33 probe, kbActive=1 ở 3/33 (cả 3 đều state=V, kbSrc=local, w0). Facebook kbActive=1 ở 2/31 (đều state=V, w0), kbKnown=0 ở 1/31. TikTok kbKnown=1 và kbActive=0 ở 10/10.

Kết luận §2: cổng quyết định nhất quán — w1 ⟺ (state=H ∧ kbActive=0 ∧ kbSrc=owner) trên dữ liệu phiên này, trừ 4 ca H bị chặn bởi lý do khác (§4.3, §6). Không ca w1 nào có kbActive=1 hoặc kbSrc=local.

---

## 3. RÀ NUỐT NHẦM

Tiêu chí (theo nhiệm vụ): ca nuốt THẬT (`bw nuot day`) mà (a) state=V, hoặc (b) kbActive=1, hoặc (c) xảy ra ngoài ô YouTube.

### 3.1 Kết quả

**0 ca nuốt nhầm theo tiêu chí.**

Căn cứ:
- 11/12 ca nuốt nối được dòng probe: cả 11 đều `state=H`, `kbKnown=1`, `kbActive=0`, `kbSrc=owner`, `hosted=1`, trong tiến trình YouTube (PID 37993/37999/38003). Không ca nào state=V, không ca nào kbActive=1.
- Ngoài ô YouTube: grep `bw nuot day` theo tiến trình cho Facebook = 0, TikTok = 0, GOFA = 0, Maps = 0; toàn bộ 12 ca đều ở `[YouTube:*]`.
- Nhóm Facebook có 5 ca `wouldSwallow=1` nhưng 0 dòng nuốt/ack (§4) — quyết định "would" ở chế độ trial không biến thành nuốt thật, nên không tính là nuốt nhầm.

### 3.2 Ca không đối chiếu được (không tính là nuốt nhầm, nhưng phải ghi)

Ca #10 ở §1.2 — `2026-11-10 06:32:03.714 [YouTube:38003] AppBridge: [do] bw nuot day: txn=2 probe=2` — không tồn tại dòng `[do] bw probe seq=2` của PID 38003 trong corpus (PID này chỉ có probe seq=1, 3, 4). Do đó state/kb của đúng ca này không kiểm chứng được từ dòng probe. Các dấu hiệu gián tiếp: ca nằm trong tiến trình YouTube (không ngoài ô), và host phát `HIDDEN->VISIBLE gen=15` tại `06:32:03.715` (chuyển này chỉ xảy ra khi trước đó controls đang HIDDEN, tức state=H ở phía host). Kết luận cho ca này: không có bằng chứng nuốt nhầm; thiếu 1 dòng probe tổng kết là lỗ hổng log duy nhất của phiên.

---

## 4. App hosted khác — wouldSwallow=1 bị giữ ở DRY_RUN (wm=1 / ngoài trial scope)

Phía host, `[wake1] bw emit` tổng 738 dòng, phân bố wm:

| Bundle | Emit | wm |
|---|---|---|
| `com.google.ios.youtube` | 450 | wm=2 (ENFORCE) |
| `com.google.ios.youtube` | 1 (`state=INACTIVE gen=14 seq=793`, 06:31:36.755) | wm=1 |
| `com.facebook.Facebook` | 183 | wm=1 |
| `com.ss.iphone.ugc.Ame` (TikTok) | 95 | wm=1 |
| `com.lumi.GOFA` | 6 | wm=1 |
| `com.google.Maps` | 3 | wm=1 |

`[gate3] trial` phía owner chỉ khai 1 bundle: `2026-11-10 06:26:51.147 [CarPlay:37987] SplitScreen: [gate3] trial bundle=com.google.ios.youtube enabled=1 packetPinch=2`. Chữ `dry`/`DRY_RUN` không xuất hiện trong log (grep = 0); chế độ dry-run của app khác được thể hiện bằng wm=1 + vắng mặt khỏi trial bundle + 0 dòng nuốt.

### 4.1 Facebook — 5 ca sẵn sàng cho mở rộng ENFORCE

Facebook: 31 probe, `wouldSwallow=1` = **5**, `bw nuot day` = 0, `bw ack` = 0. Cả 5 ca đều state=H, kbKnown=1, kbActive=0, kbSrc=owner, hosted=1 — tức cùng điều kiện với 11 ca YouTube đã nuốt thật, chỉ khác trial scope. Đây là 5 ca "sẵn sàng cho mở rộng ENFORCE":

1. `2026-11-10 06:33:48.047 [Facebook:38006] AppBridge: [do] bw probe seq=1 ph B=1 M=0 E=1 C=0 dur=0.02 hosted=1 kbKnown=1 kbActive=0 kbSrc=owner kbAge=129 state=H stateSeq=1174 stateAgeMs=1130 stateFlips=1 wouldSwallow=1 wouldPinch=0 failopen=- dsrc=local-push`
2. `2026-11-10 06:33:58.142 [Facebook:38006] AppBridge: [do] bw probe seq=5 ph B=1 M=0 E=1 C=0 dur=0.05 hosted=1 kbKnown=1 kbActive=0 kbSrc=owner kbAge=21 state=H stateSeq=1207 stateAgeMs=188 stateFlips=3 wouldSwallow=1 wouldPinch=0 failopen=- dsrc=local-push`
3. `2026-11-10 06:34:15.483 [Facebook:38006] AppBridge: [do] bw probe seq=11 ph B=1 M=0 E=1 C=0 dur=0.05 hosted=1 kbKnown=1 kbActive=0 kbSrc=owner kbAge=370 state=H stateSeq=1259 stateAgeMs=1537 stateFlips=5 wouldSwallow=1 wouldPinch=0 failopen=- dsrc=local-push`
4. `2026-11-10 06:34:20.966 [Facebook:38006] AppBridge: [do] bw probe seq=12 ph B=1 M=3 E=1 C=0 dur=0.05 hosted=1 kbKnown=1 kbActive=0 kbSrc=owner kbAge=9 state=H stateSeq=1279 stateAgeMs=1016 stateFlips=7 wouldSwallow=1 wouldPinch=0 failopen=- dsrc=local-push`
5. `2026-11-10 06:34:53.698 [Facebook:38006] AppBridge: [do] bw probe seq=14 ph B=1 M=5 E=1 C=0 dur=0.10 hosted=1 kbKnown=1 kbActive=0 kbSrc=owner kbAge=539 state=H stateSeq=1376 stateAgeMs=706 stateFlips=9 wouldSwallow=1 wouldPinch=0 failopen=- dsrc=local-push`

Bundle: `com.facebook.Facebook` — 5 ca.

### 4.2 GOFA — 0 ca

GOFA (PID 37991) có 83 dòng trong corpus nhưng 0 dòng `[do] bw probe`, 0 dòng `bw cai sendEvent probe` (chỉ YouTube ×3, Facebook ×1, TikTok ×1 có dòng cài probe), 0 nuốt. Phía host chỉ có 6 emit `com.lumi.GOFA ... wm=1`. Kết luận: GOFA chưa được gắn cổng phía app trong phiên này → số ca sẵn sàng = 0, và đây là "chưa có dữ liệu cổng" chứ không phải "cổng quyết định không nuốt".

### 4.3 TikTok — 0 ca wouldSwallow=1

TikTok: 10 probe, w1 = 0. Cả 3 ca state=H đều bị chặn với `failopen=pinchin` và có dòng nhường pinch phía app (`[gate3] bw gate yield pinch-in: state=H pinchAllowed=1 pinchMode=enforce`):
- `2026-11-10 06:36:47.176 [TikTok:38009] AppBridge: [do] bw probe seq=1 ... state=H stateSeq=1699 stateAgeMs=564 ... wouldSwallow=0 wouldPinch=1 failopen=pinchin dsrc=local-push`
- `2026-11-10 06:36:53.874 [TikTok:38009] AppBridge: [do] bw probe seq=2 ... state=H stateSeq=1722 stateAgeMs=975 ... wouldSwallow=0 wouldPinch=0 failopen=pinchin dsrc=local-push`
- `2026-11-10 06:37:09.121 [TikTok:38009] AppBridge: [do] bw probe seq=4 ... state=H stateSeq=1772 stateAgeMs=1187 ... wouldSwallow=0 wouldPinch=0 failopen=pinchin dsrc=local-push`

TikTok cũng wm=1 (95 emit), nhưng 0 ca chạm ngưỡng w1 nên không đóng góp vào số "sẵn sàng ENFORCE".

### 4.4 Tổng §4

**Số ca wouldSwallow=1 bị giữ ở DRY_RUN (wm=1) vì ngoài trial scope: 5 ca — toàn bộ Facebook (`com.facebook.Facebook`).** TikTok 0, GOFA 0, Maps 0 probe.


---

## 5. L7 — stateSeq phía app vs seq phía host

Phương pháp: với từng dòng probe của YouTube (33 dòng, trường `stateSeq`), lấy dòng host `[wake1] bw emit com.google.ios.youtube ... seq=` gần nhất theo thời gian (cả trước/sau) và dòng emit cuối cùng trước thời điểm probe; độ lệch = hostSeq − stateSeq. Bộ đếm seq phía host là bộ đếm dùng chung cho cả `bw emit` và `[kb-sync] emit` (hai loại xen kẽ, cùng tăng), nên seq host luôn chạy trước stateSeq (stateSeq là seq tại thời điểm state được chốt phía app).

### 5.1 Mẫu đối chiếu (toàn bộ 33 probe YouTube)

| Probe (giờ, PID, seq) | state / stateSeq | Emit gần nhất (hostSeq, Δt) | Lệch |
|---|---|---|---|
| 06:27:18.726, 37993, seq=1 | H / 52 | seq=59, +0,123 s | +7 |
| 06:27:24.358, 37993, seq=2 | H / 73 | seq=81, +0,493 s | +8 |
| 06:27:33.225, 37993, seq=4 | V / 91 | seq=109, −0,378 s | **+18** |
| 06:27:34.110, 37993, seq=5 | V / 109 | seq=112, −0,262 s | +3 |
| 06:27:34.894, 37993, seq=6 | V / 109 | seq=115, −0,045 s | +6 |
| 06:27:44.167, 37993, seq=10 | H / 142 | seq=146, −0,098 s | +4 |
| 06:27:49.108, 37993, seq=11 | V / 160 | seq=162, −0,260 s | +2 |
| 06:27:54.371, 37993, seq=12 | H / 175 | seq=179, −0,061 s | +4 |
| 06:27:58.855, 37993, seq=13 | V / 192 | seq=195, −0,007 s | +3 |
| 06:27:59.877, 37993, seq=14 | V / 192 | seq=198, −0,029 s | +6 |
| 06:28:20.332, 37993, seq=15 | H / 260 | seq=267, −0,078 s | +7 |
| 06:28:33.997, 37999, seq=1 | U / 290 | seq=296, +0,023 s | +6 |
| 06:28:35.287, 37999, seq=2 | U / 296 | seq=299, −0,267 s | +3 |
| 06:28:37.918, 37999, seq=3 | U / 305 | seq=308, +0,102 s | +3 |
| 06:28:54.371, 37999, seq=4 | H / 354 | seq=362, −0,076 s | +8 |
| 06:29:03.206, 37999, seq=5 | H / 391 | seq=393, −0,059 s | +2 |
| 06:29:10.461, 37999, seq=10 | V / 413 | seq=416, −0,440 s | +3 |
| 06:29:13.357, 37999, seq=11 | V / 425 | seq=425, −0,337 s | 0 |
| 06:29:14.807, 37999, seq=12 | V / 425 | seq=432, +0,213 s | +7 |
| 06:29:15.307, 37999, seq=13 | V / 425 | seq=432, −0,287 s | +7 |
| 06:29:28.378, 37999, seq=15 | V / 471 | seq=471, −0,357 s | 0 |
| 06:29:59.213, 37999, seq=16 | V / 569 | seq=571, −0,192 s | +2 |
| 06:30:22.317, 37999, seq=22 | U / 613 | seq=618, +0,207 s | +5 |
| 06:30:22.933, 37999, seq=23 | V / 620 | seq=620, −0,366 s | 0 |
| 06:30:23.867, 37999, seq=24 | V / 623 | seq=623, −0,345 s | 0 |
| 06:30:24.586, 37999, seq=25 | V / 623 | seq=626, −0,063 s | +3 |
| 06:30:25.652, 37999, seq=26 | V / 629 | seq=629, −0,129 s | 0 |
| 06:30:26.298, 37999, seq=27 | V / 629 | seq=632, +0,225 s | +3 |
| 06:30:30.848, 37999, seq=28 | H / 644 | seq=648, −0,036 s | +4 |
| 06:30:37.465, 37999, seq=29 | H / 665 | seq=668, −0,047 s | +3 |
| 06:31:31.627, 38003, seq=1 | H / 761 | seq=775, −0,089 s | +14 |
| 06:33:00.077, 38003, seq=3 | H / 1023 | seq=1035, −0,045 s | +12 |
| 06:33:25.797, 38003, seq=4 | H / 1104 | seq=1116, +0,101 s | +12 |

### 5.2 Kết quả L7

- **Độ lệch seq tối đa quan sát được: 18** (cả theo cách "emit gần nhất" và "emit cuối cùng trước probe" đều cho max = 18, cùng một ca).
- Ca lệch tối đa, trích nguyên dòng:
  - App: `2026-11-10 06:27:33.225 [YouTube:37993] AppBridge: [do] bw probe seq=4 ph B=2 M=44 E=2 C=0 dur=0.39 hosted=1 kbKnown=1 kbActive=0 kbSrc=owner kbAge=433 state=V stateSeq=91 stateAgeMs=5258 stateFlips=9 wouldSwallow=0 wouldPinch=1 failopen=- dsrc=local-push`
  - Host: `2026-11-10 06:27:32.847 [CarPlay:37987] SplitScreen: [wake1] bw emit com.google.ios.youtube state=VISIBLE gen=1 seq=109 wm=2 pm=2 pinch=1`
  - Lệch = 109 − 91 = 18. Bối cảnh: stateSeq=91 là seq tại lần flip sang VISIBLE lúc 06:27:27.576; probe chốt sau đó 5,258 ms (`stateAgeMs=5258`), trong lúc host tiếp tục phát emit/kb-sync làm seq chạy tới 109. Lệch này là hệ quả bộ đếm chung chạy liên tục, không phải mất đồng bộ state (state hai phía cùng VISIBLE ở ca này).
- Phân bố lệch: 33 ca — lệch 0 ở 5 ca, 2–8 ở 25 ca, 10–14 ở 3 ca (đều PID 38003: +14, +12, +12), 18 ở 1 ca. Không ca nào lệch âm (stateSeq không bao giờ vượt seq host tại thời điểm probe).

---

## 6. Các ca fail-open còn lại: wouldSwallow=0 khi state=H trên YouTube

Tổng probe YouTube state=H: 12; w1 = 11; **w0 = đúng 1 ca**:

`2026-11-10 06:29:03.206 [YouTube:37999] AppBridge: [do] bw probe seq=5 ph B=1 M=0 E=1 C=0 dur=0.06 hosted=1 kbKnown=1 kbActive=0 kbSrc=owner kbAge=123 state=H stateSeq=391 stateAgeMs=123 stateFlips=8 wouldSwallow=0 wouldPinch=0 failopen=- dsrc=local-push`

Phân loại theo trường trong dòng:
- **kb? KHÔNG phải lý do hiển thị trong dòng**: `kbKnown=1`, `kbActive=0`, `kbSrc=owner` — cùng giá trị với 11 ca w1. `kbAge=123` thấp nhưng kbAge của nhóm w1 trải 9–737 ms nên kbAge=123 nằm trong vùng w1.
- **failopen=?**: `failopen=-` (không có mã fail-open). Khác hẳn 3 ca TikTok có `failopen=pinchin` tường minh. Dòng này không tự khai lý do.
- **stateAge? Trường phân biệt duy nhất**: `stateAgeMs=123`. Toàn bộ 11 ca YouTube state=H còn lại có stateAgeMs lần lượt: 812, 880, 893, 897, 1207, 1628, 2107, 2273, 2708, 3080, 3466 — tối thiểu 812 ms. Ca w0 duy nhất thấp hơn hẳn (123 ms, đồng thời `kbAge=123` và `stateFlips` nhảy tới 8, tức state H vừa được chốt ~123 ms trước dãy chạm). Phân loại: **fail-open do state quá tươi (fresh-state) — suy ra từ đối chiếu trường stateAgeMs giữa 12 ca H, log không ghi lý do tường minh (failopen=-)**. Mức ngưỡng cụ thể nằm ở khoảng (123, 812] ms theo dữ kiện phiên; log không cho con số ngưỡng.
- Hệ quả của ca này: dãy chạm không bị nuốt, không có `bw nuot day` tương ứng (đối chiếu §1: PID 37999 chỉ nuốt ở probe=4, 28, 29), và cũng không có ack/timeout cho seq=5.

Ngoài phạm vi §6 nhưng liên quan fail-open, ghi để không lẫn:
- 7 ca `bw ack timeout ... fail-open toi state tuoi ke tiep` ở §1.2 là fail-open ở tầng ack SAU khi đã nuốt (txn của PID 37999/38003), không phải fail-open ở tầng quyết định probe.
- 4 ca YouTube state=U (UNKNOWN) đều w0 với `failopen=-`: cổng không nuốt khi state chưa rõ — hành vi fail-open theo thiết kế, không tính vào nhóm state=H của §6.
- 3 ca TikTok state=H w0 có `failopen=pinchin` tường minh (§4.3) — thuộc pinch, không thuộc wake YouTube.

---

## Phụ lục — Số đếm grep tái lập (corpus hl3 = 6.891 dòng)

| Lệnh đếm (trên corpus hợp nhất) | Kết quả |
|---|---|
| `grep -c "bw probe seq="` | 74 |
| `grep -c "dsrc=local-push"` | 74 |
| `grep "bw probe seq=" \| grep -c "wouldSwallow=1"` | 16 |
| `grep "bw probe seq=" \| grep -c "wouldSwallow=0"` | 58 |
| `grep -c "bw nuot day"` | 12 |
| `grep -c "bw ack seq="` | 5 |
| `grep -c "bw ack timeout"` | 7 |
| `grep -c "swallowed"` | 0 |
| `grep -c "held"` | 0 |
| `grep -c "[gate3] trial packet bundle=com.google.ios.youtube"` | 95 |
| Probe theo tiến trình: YouTube / Facebook / TikTok / GOFA | 33 / 31 / 10 / 0 |
| wouldSwallow=1 theo tiến trình: YouTube / Facebook / TikTok | 11 / 5 / 0 |

Verdict cuối của strand S1: **LOG-CONFIRMED** (nuốt YouTube đạt ở tầng nuốt + host chuyển VISIBLE 12/12; app khác bị giữ ở trial/wm=1) — với lưu ý ack timeout 7/12 ca ở PID 37999/38003 và 1 ca probe thiếu dòng tổng kết (PID 38003, probe=2), chi tiết ở §1.3 và §3.2.
