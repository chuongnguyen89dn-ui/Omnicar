# S2 — PINCH PHIÊN HL3: CENSUS TRỌNG TÀI (chỉ-đọc, đếm bằng grep trên file gốc)

- Ngày đếm: 2026-11-10. Nguồn: `OmniCar.log.old` CHỈ đoạn hl3 (từ dòng 6701, `2026-11-10 06:26:34.436` tới cuối file; phần trước là hl2, đã bỏ) + `OmniCar.log` toàn bộ (06:36:03.490 – 06:37:43.804, toàn hl3).
- Tổng dòng hl3 đã đếm: 6.108 (old) + 783 (new) = 6.891 dòng. Dòng `[pinch2]`: 98 (63 old + 35 new), trùng lặp giữa 2 file = 0 (đã kiểm `comm`).
- PID theo đề bài: CarPlay 37987, YouTube 37993/37999/38003, Facebook 38006.

## LƯU Ý PHẠM VI — TikTok 38009 nằm trong file hl3 nhưng ngoài danh sách PID đề bài

`OmniCar.log` chứa thêm một app pinch trong cùng cửa sổ hl3: TikTok PID 38009 (attached 06:36:33.890, gen=17), sau khi slot 0 chuyển từ Facebook sang TikTok lúc ~06:36:07. Mọi bảng dưới đây ghi HAI cột: **STRICT** = đúng PID đề bài (YouTube + Facebook + owner gen=16) và **FULL** = toàn bộ hl3 trong file (cộng TikTok). Kết luận không đổi ở cả hai phạm vi.

## VERDICT S2

- So với báo cáo của Nguyen "bung được đúng 1 lần, thu 0 lần, rất khó dùng": **LOG-CONFIRMED** — log có đúng 1 lần FS expand `provenance=pinch`, đúng 1 lần owner expand applied, 0 lần restore do pinch, và tỉ lệ thất bại 21/22 cặp (STRICT) / 33/34 cặp (FULL).
- So với giả thuyết "lớp trọng tài (blocked phía app) giết pinch": **CONTRADICTS như nguyên nhân chính** — trọng tài chỉ giết thiểu số (xem mục 6); kẻ giết chính là owner phía CarPlay với `reason=badstate`.

---

## 1. CENSUS [pinch2] PHÍA APP — cặp hình thành và kết cục tại trọng tài

Định nghĩa đếm: một "cặp hình thành" = một `gid` xuất hiện ở dòng `blocked` HOẶC dòng `began`. Mỗi `began` có đúng 1 dòng `recognized` đi kèm (26/26). Dòng `attached`/`detached` không phải cặp.

| Chỉ số | STRICT | FULL |
|---|---|---|
| Tổng cặp hình thành (blocked + began) | **22** | **34** |
| `blocked` (chết tại trọng tài) | 7 | 8 |
| `began` (qua trọng tài) | 15 | 26 |
| `recognized` | 15 | 26 |
| `trigger=began` | 15/15 (100%) | 26/26 (100%) |
| `trigger` khác (changed/ended/…) | 0 | 0 |

Blocked theo TỪNG reason (đếm trên dòng `[pinch2] blocked`):

| reason | STRICT | FULL |
|---|---|---|
| kbunknown | **7** | **8** |
| latch-missing | 0 | 0 |
| state | 0 | 0 |
| split-hidden | 0 | 0 |
| notallowed | 0 | 0 |
| modeoff | 0 | 0 |
| kbactive | 0 | 0 |
| stale | 0 | 0 |

Toàn bộ 8 dòng blocked (FULL) — trích nguyên văn:

```text
2026-11-10 06:27:31.928 [YouTube:37993] AppBridge: [pinch2] blocked gid=1 reason=kbunknown state=V stateSeq=91
2026-11-10 06:27:32.838 [YouTube:37993] AppBridge: [pinch2] blocked gid=2 reason=kbunknown state=V stateSeq=91
2026-11-10 06:27:33.624 [YouTube:37993] AppBridge: [pinch2] blocked gid=3 reason=kbunknown state=V stateSeq=109
2026-11-10 06:27:34.521 [YouTube:37993] AppBridge: [pinch2] blocked gid=4 reason=kbunknown state=V stateSeq=109
2026-11-10 06:27:35.374 [YouTube:37993] AppBridge: [pinch2] blocked gid=5 reason=kbunknown state=V stateSeq=109
2026-11-10 06:27:36.011 [YouTube:37993] AppBridge: [pinch2] blocked gid=6 reason=kbunknown state=V stateSeq=109
2026-11-10 06:27:39.245 [YouTube:37993] AppBridge: [pinch2] blocked gid=7 reason=kbunknown state=V stateSeq=109
2026-11-10 06:36:46.458 [TikTok:38009] AppBridge: [pinch2] blocked gid=1 reason=kbunknown state=H stateSeq=1699
```

Phân bố `recognized` theo dir: `dir=1` = 26/26 (100%, FULL) và 15/15 (STRICT); dir khác = 0. Mọi `recognized` đều có `ratio=1.000` (26/26) — hướng được chốt ngay tại `trigger=began`, trước mọi thay đổi khoảng cách.

Theo app:

| App | Hình thành | blocked | began/recognized | Thành công |
|---|---|---|---|---|
| YouTube 37993 | 7 | 7 (kbunknown) | 0 | 0 |
| YouTube 37999 | 0 (chỉ attached/detached) | 0 | 0 | 0 |
| YouTube 38003 | 0 (chỉ attached) | 0 | 0 | 0 |
| Facebook 38006 | 15 | 0 | 15 | 1 (gid=1) |
| TikTok 38009 (ngoài STRICT) | 12 | 1 (kbunknown) | 11 | 0 |

## 2. PHÍA OWNER (CarPlay:37987)

| Chỉ số | STRICT (gen=16, Facebook) | FULL |
|---|---|---|
| `owner accept` | **1** | **1** |
| `owner reject` tổng | **14** | **25** |
| — reject `reason=badstate` | 14 | 25 |
| — reject reason khác | 0 | 0 |
| `owner expand applied=1` | **1** | **1** |
| `owner restore` (mọi dạng) | 0 | 0 |
| FS applied `provenance=pinch`: `[fs1] fs expand confirmed` | **1** | **1** |
| FS `restore confirmed` do pinch | 0 | 0 |

Đối chiếu 1:1: 26 `began` (FULL) ↔ 26 verdict owner (1 accept + 25 reject). Không cặp nào qua trọng tài mà mất hút không verdict. Dòng FS `provenance` duy nhất còn lại trong hl3 là teardown: `2026-11-10 06:37:29.518 [fs1] fs session-end abbreviated restore provenance=teardown` — không phải pinch.

## 3. LẦN BUNG THÀNH CÔNG DUY NHẤT — truy trọn đường

Log cho **đúng 1** lần applied trong toàn hl3 (không có lần thứ hai để đối chiếu). Chuỗi đầy đủ, Facebook gid=1:

```text
2026-11-10 06:35:47.467 [Facebook:38006] AppBridge: [pinch2] began gid=1 state=V committed=split stateSeq=1535 d0=101.6
2026-11-10 06:35:47.467 [Facebook:38006] AppBridge: [pinch2] recognized trigger=began dir=1 ratio=1.000 state=V committed=split seq=1 gid=1 gen=16 stateSeq=1535
2026-11-10 06:35:47.481 [CarPlay:37987] SplitScreen: [pinch2] owner accept slot=0 bundle=com.facebook.Facebook dir=out gid=1 seq=1 gen=16 session=1940228364 sessrc=store state=SPLIT
2026-11-10 06:35:47.503 [CarPlay:37987] SplitScreen: [wake1] bw expanded ON (-)
2026-11-10 06:35:47.503 [CarPlay:37987] SplitScreen: [fs1] fs expand confirmed txn=1 provenance=pinch
2026-11-10 06:35:47.504 [CarPlay:37987] SplitScreen: [pinch2] owner expand applied=1 gid=1
```

- Timestamp bung: **06:35:47.467 → 06:35:47.504** (37 ms từ began tới applied). Dir: app `dir=1`, owner dịch thành `dir=out`. Trạng thái lúc hình thành: `committed=split`, `state=V`, owner `state=SPLIT` — cặp hình thành khi đang split, đúng điều kiện bung. Đây là cặp Facebook đầu tiên của phiên (gid=1) và là cặp duy nhất được accept.

## 4. CÁC LẦN THU — cặp hình thành khi FS đang EXPANDED

Cửa sổ EXPANDED xác định từ log: **06:35:47.503** (`bw expanded ON` + `fs expand confirmed`) → **06:37:29.518** (`bw expanded OFF` + `fs session-end abbreviated restore provenance=teardown`). Trong cửa sổ này KHÔNG có `fs restore confirmed` nào; FS chỉ tắt khi phiên CarPlay teardown.

### 4a. Cùng phiên/app với lần bung (Facebook gen=16) — phạm vi chính

**14 cặp** hình thành sau lần bung, khi FS vẫn EXPANDED: gid=2–15, từ 06:35:48.628 tới 06:36:03.117. Điểm chết theo số:

| Điểm chết | Số cặp |
|---|---|
| blocked tại trọng tài | 0 |
| recognized nhưng dir thu (dir≠1) | 0 — cả 14 đều `dir=1` (hướng bung) |
| qua tới owner, bị `owner reject reason=badstate` | **14/14 (100%)** |
| không có dòng nào sau began (mất hút) | 0 |
| restore thành công | **0** |

Ví dụ trích (cặp đầu và cuối của chùm):

```text
2026-11-10 06:35:48.628 [Facebook:38006] AppBridge: [pinch2] began gid=2 state=V committed=split stateSeq=1535 d0=355.9
2026-11-10 06:35:48.628 [Facebook:38006] AppBridge: [pinch2] recognized trigger=began dir=1 ratio=1.000 state=V committed=split seq=2 gid=2 gen=16 stateSeq=1535
2026-11-10 06:35:48.632 [CarPlay:37987] SplitScreen: [pinch2] owner reject reason=badstate slot=0 hash=94d1ded gen=16 session=1940228364 seq=2 gid=2 dir=1
2026-11-10 06:36:03.117 [Facebook:38006] AppBridge: [pinch2] began gid=15 state=V committed=split stateSeq=1585 d0=101.2
2026-11-10 06:36:03.117 [Facebook:38006] AppBridge: [pinch2] recognized trigger=began dir=1 ratio=1.000 state=V committed=split seq=15 gid=15 gen=16 stateSeq=1585
2026-11-10 06:36:03.127 [CarPlay:37987] SplitScreen: [pinch2] owner reject reason=badstate slot=0 hash=94d1ded gen=16 session=1940228364 seq=15 gid=15 dir=1
```

### 4b. Mở rộng theo đồng hồ (cộng TikTok gen=17, vẫn trong cửa sổ ON→OFF)

Thêm 12 cặp TikTok: 1 blocked `kbunknown` lúc 06:36:46.458 (`state=H`) + 11 began/recognized gid=2–12 lúc 06:37:12.136–06:37:19.143, cả 11 đều bị owner reject `badstate`. Tổng trong cửa sổ EXPANDED theo đồng hồ: **26 cặp hình thành — chết tại trọng tài 1, chết tại owner 25, thu thành công 0**. Lưu ý diễn giải: 12 cặp TikTok thuộc phiên/app mới (slot đã chuyển app lúc ~06:36:07), không phải nỗ lực thu của chính Facebook; chúng chỉ chứng thêm rằng mọi pinch sau thời điểm bung đều vô hiệu.

### 4c. Giới hạn bằng chứng về "wrong-dir"

Mọi `recognized` hậu-bung đều mang `dir=1, ratio=1.000, trigger=began`. Log không có dòng diễn biến khoảng cách/ratio về sau, nên từ log KHÔNG phân biệt được (a) người dùng véo vào nhưng code vẫn gán dir bung ngay tại began, hay (b) người dùng lặp lại véo ra. Điều log chứng minh được: **không một yêu cầu hướng-thu nào từng tới owner, và mọi yêu cầu tới owner đều bị reject badstate** — đường thu không tồn tại trong dữ liệu hl3 ở cả hai cách đọc.

## 5. NHÃN committed PHÍA APP SAU LẦN BUNG

Đếm trường `committed=` trên mọi dòng `[pinch2] began` + `recognized`:

| Phạm vi | committed=split | committed=expanded |
|---|---|---|
| Toàn hl3 (26 cặp × 2 dòng = 52 dòng) | **52** | **0** |
| Sau thời điểm bung 06:35:47.503 (25 cặp = 50 dòng) | **50** | **0** |
| Chỉ Facebook sau bung (14 cặp = 28 dòng) | **28** | **0** |

Tức là: sau khi host đã `fs expand confirmed`, phía app vẫn ghi `committed=split` trên 100% dòng pinch2 cho tới cuối phiên; nhãn `committed=expanded` không xuất hiện lần nào trong hl3. [LOG-CONFIRMED ở mức nhãn log; suy luận cơ chế — latch phía app không được cập nhật nên các lần véo sau vẫn phát yêu cầu hướng-bung vào một FS đã bung, và owner đáp badstate — là diễn giải khớp cả ba dữ kiện trên, không phải dòng log trực tiếp.]

## 6. KẾT LUẬN ĐỊNH LƯỢNG — GIẢ THUYẾT "LỚP TRỌNG TÀI GIẾT PINCH"

| Điểm chết | STRICT (22 cặp) | FULL (34 cặp) |
|---|---|---|
| Chết tại trọng tài (`blocked`) | 7 = **31,8%** | 8 = **23,5%** |
| Chết tại owner/FS (`reject badstate`) | 14 = **63,6%** | 25 = **73,5%** |
| Thành công (expand applied) | 1 = **4,5%** | 1 = **2,9%** |

Trong số cặp ĐÃ QUA trọng tài: owner giết 14/15 = 93,3% (STRICT) / 25/26 = 96,2% (FULL).

Kết luận:

1. Trọng tài phía app có giết thật nhưng chỉ ở một mặt trận hẹp: 7/7 cặp YouTube (37993) chết `kbunknown` ngay đầu phiên (06:27:31–06:27:39, `stateSeq=91/109`); YouTube không có nổi một cặp qua trọng tài trong hl3. Với Facebook, trọng tài giết 0/15.
2. Mặt trận chết chính là owner: sau lần bung duy nhất, trạng thái hai phía lệch nhau trong log (host EXPANDED vs app `committed=split` trên 50/50 dòng), và 100% cặp hậu-bung chết tại `owner reject reason=badstate`. "Rất khó dùng" theo số: tỉ lệ thành công 1/22 (STRICT) — và thành công đó chỉ xảy ra ở cặp đầu tiên của app; mọi lần thử sau đều thất bại.
3. Vì vậy giả thuyết "lớp trọng tài giết pinch" bị **CONTRADICTS như lời giải thích chính** cho hl3: bỏ trọng tài đi vẫn còn 93–96% số cặp qua được sẽ chết tại owner. Trọng tài chỉ là nguyên nhân toàn phần cho riêng YouTube.
