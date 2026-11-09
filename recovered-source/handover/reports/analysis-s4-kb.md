# Biên bản S4 — Phím + kbstate/L8, phiên hl3 (chỉ-đọc)

- Phạm vi: `OmniCar.log.old` đoạn hl3 từ `2026-11-10 06:26:34` (dòng 6701 của file .old) tới cuối file .old + toàn bộ `OmniCar.log`. Tổng đoạn hl3: **6.891 dòng** (6.108 + 783). Mọi số dưới đây đếm bằng grep trên đúng đoạn này và đối chiếu 2 cách (grep / script) — khớp nhau.
- Quy ước app theo hash kbstate: `d3b4e0d` = YouTube (`com.google.ios.youtube`), `94d1ded` = Facebook (`com.facebook.Facebook`), `e42a484` = TikTok (`com.ss.iphone.ugc.Ame`).

## 1. Mode phím trên máy — native khoá cứng, drawn = 0 lần

- Dòng chứa `native-locked-hl3`: **13**, và cả 13 đều là dòng payload của SpringBoard, tất cả `drawnKeyboard=0 mode=native-locked-hl3`. Mẫu:
  - `2026-11-10 06:27:00.754 [SpringBoard:37965] AppBridge: [ytz5-k5] payload com.google.ios.youtube drawnKeyboard=0 mode=native-locked-hl3`
  - `2026-11-10 06:33:32.779 [SpringBoard:37965] AppBridge: [ytz5-k5] payload com.facebook.Facebook drawnKeyboard=0 mode=native-locked-hl3`
  - `2026-11-10 06:36:13.925 [SpringBoard:37965] AppBridge: [ytz5-k5] payload com.ss.iphone.ugc.Ame drawnKeyboard=0 mode=native-locked-hl3`
- Dòng cấu hình mode của hl3 (dạng `[ytz5-k5] cong ban phim ...` của các đời trước — chuỗi literal `cong ban phim`/`ban phim` trong hl3 = **0**; dòng tương đương của hl3 là dòng tuyên bố khoá cứng, 1 lần duy nhất):
  - `2026-11-10 06:26:57.925 [SpringBoard:37965] AppBridge: [ytz5-k5] hl3: native KHOA CUNG cho app hosted (lenh Nguyen 22:14, ghi de phan quyet drawn cua GPT); pref appBridgeNativeKeyboard + marker hl2 vo hieu`
- Phía app nhận: `gate nhan drawnKeyboard=0` = **5** (YouTube ×3, Facebook ×1, TikTok ×1); `responder became drawn=0` = **5**.
- Drawn có xuất hiện không: **KHÔNG**. `drawnKeyboard=1` = 0, `drawn=1` = 0, `mode=drawn` = 0, `responder became drawn=1` = 0. Tổng `drawnKeyboard=0` = 18.
- Kết luận mục 1: máy chạy **native khoá cứng 100%** trong hl3, không có lần nào drawn.

## 2. Episode gõ/tìm kiếm ở app hosted + chuỗi kbstate

### 2a. Có kbstate ACTIVE (state=1) — CÓ, ở cả YouTube và Facebook

Đếm phía owner (CarPlay, `[kbstate] accept ... state=1`): **33 dòng state=1**, gom thành các run liên tục theo (gen, session):

| # | App | Gen/session | Khoảng ACTIVE (accept state=1) | Seq | Số dòng |
|---|-----|-------------|----------------------------------|-----|---------|
| 1 | YouTube | gen=5, session=3447726160 | 06:29:13.609 → 06:29:27.674 | 41→54 | 14 |
| 2 | YouTube | gen=5, session=3447726160 | 06:29:59.345 → 06:30:00.679 | 85→87 | 3 |
| 3 | YouTube | gen=5, session=3447726160 | 06:30:02.422 (1 điểm) | 89 | 1 |
| 4 | Facebook | gen=16, session=1940228364 | 06:34:55.242 → 06:35:10.054 | 72→85 | 14 |
| 5 | TikTok (ngoài phạm vi hỏi, ghi kèm) | gen=17, session=483184917 | 06:37:00.499 (1 điểm) | 27 | 1 |

- Run 2 và 3 của YouTube cách nhau 1,7 s (kẹp 1 nhịp state=0 ở seq=88); theo `[kb-sync] emit ... active=1` phía CarPlay thì active liên tục 06:29:59.345 → 06:30:03.574, nên tính theo kb-sync là **1 episode dùng**, theo accept state=1 là 2 run. Tổng kết episode ACTIVE: **YouTube 2 episode dùng** (06:29:13–06:29:27 và 06:29:59–06:30:03), **Facebook 1 episode** (06:34:55–06:35:10).
- Bằng chứng đây là mở tìm kiếm thật, không phải nhiễu: responder lên đúng ngay trước ACTIVE:
  - `2026-11-10 06:29:13.606 [YouTube:37999] AppBridge: [ytz5-k5] responder became drawn=0 class=YTSearchBarView` — 3 ms trước accept state=1 đầu tiên (06:29:13.609).
  - `2026-11-10 06:34:55.237 [Facebook:38006] AppBridge: [ytz5-k5] responder became drawn=0 class=FBSearchInternalTextField` — 5 ms trước accept state=1 đầu tiên (06:34:55.242).

### 2b. Chuỗi kbstate phía owner — khép ở mức reason, có 12 lỗ reject noassignment

- `[kbstate] accept` = **493**; `[kbstate] reject` = **12**; tổng `[kbstate]` = 524 (493 + 12 + 19 reporter-stop phía app, xem mục 3).
- Reject theo reason: **noassignment = 12; badgen = 0; badsession = 0; staleseq = 0; badhash = 0**. Không có bất kỳ reject nào thuộc 4 reason lỗi chuỗi (gen/session/seq/hash).
- Tính liên tục seq (accept): trong từng cặp (gen, session), seq accept **không đứt quãng nào**: gen1/session4141594545: 1→71; gen5/session3447726160: 1→93, nối gen7 seq=94, gen9 seq=95→129 (cùng session, seq chạy xuyên đổi gen); gen13/session3691272639: 1→14, nối gen15 seq=18→115; gen16/session1940228364: 1→130; gen17/session483184917: 1→46, nối gen19 seq=47→51.
- Các lỗ duy nhất trong chuỗi là đúng 12 seq bị reject noassignment: seq=130 (gen9/session3447726160), seq=15–17 (gen13/session3691272639), seq=116–119 (gen15/session3691272639), seq=131–134 (gen16/session1940228364) — tất cả đều ở **đuôi assignment đã chết** (mục 3), không phải mất gói giữa phiên sống.
- Kết luận mục 2: chuỗi kbstate **khép** — accept/reject khớp 1-1 với seq đã phát, không badgen/badsession/staleseq/badhash; phần không-khép duy nhất là 12 reject noassignment ở cuối các assignment đã tháo.

## 3. L8 — hiệu quả so với hl2

### 3a. Số reject noassignment

- hl3: **12** (hl2: 291) — giảm 279, còn ~4,1% của hl2. Cả 12 rơi vào 4 cụm, mỗi cụm đi ngay sau một mốc tháo ô/đổi assignment:
  - Cụm A: 1 reject — `06:30:55.742 ... reject reason=noassignment hash=d3b4e0d gen=9 session=3447726160 seq=130`
  - Cụm B: 3 reject — 06:31:37.713 → 06:31:39.714, gen=13 session=3691272639 seq=15–17
  - Cụm C: 4 reject — 06:33:29.716 → 06:33:32.715, gen=15 session=3691272639 seq=116–119
  - Cụm D: 4 reject — 06:36:08.054 → 06:36:11.055, gen=16 session=1940228364 seq=131–134

### 3b. `[kbstate] reporter-stop` — CÓ, 19 lần

- Tổng **19**: YouTube ×8 (pid 37993 ×1, 37999 ×4, 38003 ×3), Facebook ×8 (pid 38006), TikTok ×3 (pid 38009). Dạng dòng: `[kbstate] reporter-stop: state im lang 5.xs (assignment presumed gone)`.
- Điểm quan trọng: **16/19 lần là dừng "oan" theo nghĩa tín hiệu** — assignment vẫn còn sống, accept của cùng session/app **nối lại sau stop** từ +0,775 s đến +11,017 s, seq chạy tiếp không đứt (stop kích hoạt vì state không *đổi* trong ~5–5,8 s, không phải vì mất assignment). Ví dụ:
  - `2026-11-10 06:27:38.396 [YouTube:37993] reporter-stop: state im lang 5.5s` → accept seq=31 của chính session đó quay lại lúc 06:27:41.402 (+3,006 s), trong khi mốc tháo ô thật của YouTube mãi tới 06:28:22.937 — tức stop **trước tháo ô 44,5 s** mà app vẫn đang trong ô.
  - `2026-11-10 06:29:18.671 [YouTube:37999] reporter-stop` rơi **giữa episode ACTIVE** (06:29:13.609–06:29:27.674); accept state=1 vẫn tiếp tục sau đó (+2,006 s).
- Chỉ 3/19 là stop "chung thuỷ" (không còn accept nào của session đó sau stop): YouTube 06:33:33.712, Facebook 06:36:12.051, TikTok 06:37:34.923 — cả 3 đều là stop cuối sau tháo ô thật (bảng 3c).

### 3c. Độ trễ dừng sau tháo ô (các assignment chết hẳn)

| Assignment chết | Mốc tháo ô | Reject rò đầu → cuối | reporter-stop gần nhất sau tháo | Trễ stop sau tháo ô | Trễ stop sau reject cuối |
|---|---|---|---|---|---|
| YouTube session=3447726160 (gen9) | 06:30:55.650 `MILESTONE teardown bundle=com.google.ios.youtube` | 1 reject: 06:30:55.742 (+0,092 s) → hết | **không có dòng reporter-stop** của YouTube:37999 sau mốc này | — | — |
| YouTube session=3691272639 (gen13) | 06:31:36.756 `[wake1] bw session teardown -> INACTIVE` | 3 reject: 06:31:37.713 (+0,957 s) → 06:31:39.714 (+2,958 s) | 06:31:40.710 [YouTube:38003] | **+3,954 s** | +0,996 s |
| YouTube session=3691272639 (gen15) | 06:33:28.863 `MILESTONE teardown bundle=com.google.ios.youtube` | 4 reject: 06:33:29.716 (+0,853 s) → 06:33:32.715 (+3,852 s) | 06:33:33.712 [YouTube:38003] | **+4,849 s** | +0,997 s |
| Facebook session=1940228364 (gen16) | 06:36:07.539 `MILESTONE teardown bundle=com.facebook.Facebook` | 4 reject: 06:36:08.054 (+0,515 s) | 06:36:12.051 [Facebook:38006] | **+4,512 s** | +0,996 s |
| TikTok session=483184917 (gen19) | 06:37:29.516 `[wake1] bw session teardown -> INACTIVE` | 0 reject | 06:37:34.923 [TikTok:38009] | **+5,407 s** | — |

- Trường hợp YouTube session=3447726160: rò đúng 1 reject rồi im — không nhờ reporter-stop; phía app có `2026-11-10 06:30:55.668 [YouTube:37999] AppBridge: [ytz] ao hoa TAT ly do=revoke` và `[pinch2] detached` 06:30:55.770, tức app bị revoke/detach ngay tại teardown nên reporter chết theo tiến trình gắn ô.
- Các `MILESTONE teardown` còn lại (YouTube 06:28:22.937, 06:30:08.248, 06:30:17.476) là tháo pane rồi **gán lại ngay** (gen/session kb mới tiếp nối): reject đi kèm = **0** cho cả 3, không áp dụng độ trễ stop.
- Cụm B có điểm cần lưu ý: sau reporter-stop 06:31:40.710, app được gán lại và accept gen15 seq=18 nối lại lúc 06:31:50.715 — stop chỉ kết thúc assignment đã chết, không giết reporter vĩnh viễn.

### 3d. Kết luận L8

- Hiệu quả rò reject: **đạt** — 291 (hl2) → **12** (hl3); mỗi assignment chết rò tối đa 4 reject trong ≤ ~4 s rồi bị cắt.
- Cơ chế cắt: reporter-stop đến sau reject cuối đúng ~1,0 s ở 3/4 cụm có stop (cụm còn lại app bị revoke tại chỗ). Độ trễ stop tuyệt đối sau tháo ô: **3,954–5,407 s**.
- Nhược điểm còn nguyên trong log: reporter-stop **không phải tín hiệu mất assignment đáng tin** — 16/19 lần nổ khi assignment còn sống (kể cả giữa episode ACTIVE) vì tiêu chí là "state im lặng 5.x s". Nó vô hại ở hl3 (accept nối lại, seq không đứt) nhưng không được dùng làm bằng chứng "app đã rời ô".

## 4. AutoHide theo kb local

- Có defer/hold vì kb — **CÓ, đủ cả hai loại**:
  - `fade deferred (kb)` = **6**: YouTube episode 1: 06:29:19.762, 06:29:23.764, 06:29:27.765; Facebook episode: 06:35:00.330, 06:35:04.331, 06:35:08.332. Cả 6 đều nằm trong cửa sổ kb ACTIVE tương ứng (dòng 06:29:27.765 chậm hơn accept state=1 cuối 0,091 s nhưng kb-sync còn active tới 06:29:28.022 và `kb hold released` tới 06:29:28.429 mới nổ).
  - `fade deferred (kbunknown)` = **16**, `hold reason=kbunknown` = **16**, `kb hold released -> idle reset` = **15**. (Ngoài kb còn `fade deferred (surface-open)` = 7, không tính vào mục này.)
  - Phía nhận activity cũng thấy kb: `[autohide] act-accepted ... kb=1` = 10 (YouTube ×8, Facebook ×2) so với kb=0 ×96.
- Có fade nào xảy ra **trong lúc kb ACTIVE** không: **KHÔNG — 0**. Đối chiếu toàn bộ dòng fade thực thi (`[autohide] fade last=...`, `host fade applied`, `host knob fade applied`; tổng host fade applied = 32: YouTube 24, Facebook 5, TikTok 3) với 5 cửa sổ ACTIVE của mục 2a: giao nhau = **0 dòng**.
  - Fade gần nhất quanh episode YouTube 1: trước — 06:29:02.916 `host fade applied bundle=com.google.ios.youtube`; sau — 06:29:49.424 (sau `kb hold released` 06:29:28.429 hơn 20 s).
  - Episode Facebook: fade trước — 06:34:26.295; trong episode chỉ có 3 `fade deferred (kb)`, không có fade applied nào; `kb hold released` 06:35:10.254 ngay khi ACTIVE kết thúc (accept state=1 cuối 06:35:10.054).
  - Điểm ACTIVE đơn của TikTok 06:37:00.499 kẹp giữa hai fade 06:36:50.463 và 06:37:05.067 — không trùng.

## Verdict S4

- **Phím: PASS** — native khoá cứng (`native-locked-hl3` ×13, drawnKeyboard=0 ×18), drawn = 0 lần trong toàn hl3.
- **kbstate ACTIVE: CÓ THẬT** — YouTube 2 episode dùng (đỉnh là search 06:29:13.609–06:29:27.674, responder YTSearchBarView), Facebook 1 episode (06:34:55.242–06:35:10.054, responder FBSearchInternalTextField); tổng 33 accept state=1.
- **Chuỗi kbstate: KHÉP** — accept 493 / reject 12; badgen = badsession = staleseq = badhash = 0; seq accept không đứt trong từng (gen, session); 12 lỗ duy nhất đều là noassignment ở đuôi assignment đã tháo.
- **L8: HIỆU QUẢ RÕ** — reject noassignment **12 so với 291 của hl2** (−95,9%); reporter-stop **CÓ, 19 lần**; độ trễ dừng sau tháo ô thật **3,954–5,407 s** (sau reject cuối ~1,0 s), rò tối đa 4 reject/assignment chết. Lưu ý: 16/19 reporter-stop là dừng sớm khi assignment còn sống (tiêu chí im-lặng-state 5.x s) — vô hại trong hl3 nhưng không dùng làm mốc "đã rời ô" được; 1 cụm (YouTube session=3447726160) tắt nhờ revoke app chứ không có reporter-stop.
- **AutoHide/kb: ĐÚNG** — `fade deferred (kb)` ×6 + `hold reason=kbunknown` ×16, và **0 fade thực thi nào rơi vào cửa sổ kb ACTIVE**.
