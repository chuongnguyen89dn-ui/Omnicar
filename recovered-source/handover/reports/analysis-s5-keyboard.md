# S5 — BÀN PHÍM Ở HL2 (drawn mặc định, K6) — CHỈ-ĐỌC

Phạm vi hl2: `.old` từ dòng 1081 (`22:02:59.603 [SpringBoard:37287]
loaded`) + toàn bộ `OmniCar.log`; 22:02:59→22:27:21; SB 37287→37335
(respring 22:16:01), CarPlay 37310→37334. Đoạn trước 22:02 loại.

## 1. Mode thật: DRAWN toàn phiên, không lật, migration NO-DATA

- Payload host: 14/14 `[ytz5-k5] payload … drawnKeyboard=1 mode=drawn`
  (đầu `22:03:35.980` SB:37287; cuối `22:27:17.036` SB:37335).
  `drawnKeyboard=0`/`mode=native`/`cong … doi: native` = **0**.
- App nhận: `gate nhan drawnKeyboard=1 (explicit, cached=1)` ×4
  (YouTube:37317 22:03:40.840; TikTok:37332 22:15:10.457; TikTok:37363
  22:16:46.307; YouTube:37370 22:18:21.582). `=0` ×0.
- `cong ban phim doi:` ×1 cũng drawn: `22:15:48.028 … doi: drawn
  (prefschanged)` — xác nhận lại, không phải lật mode.
- Migration: `grep -ci migration` = **0** — NO-DATA: không phân biệt
  được "pref đã 0/absent sẵn" với "migration không chạy". Nhưng
  payload drawn ra từ post đầu 22:03:35, trước mọi prefschanged →
  máy hiệu lực drawn từ đầu phiên bất kể migration.

## 2. Episode panel: 3 mở / 3 đóng, khớp 1-1, không kẹt

| # | App / responder | Mở (shown=1 + dispatch + `hien`) | Đóng (shown=0) | Dài |
|---|---|---|---|---|
| 1 | YouTube:37317, YTSearchBarView | 22:05:48.147/.149/.225 | 22:09:39.083 | ~231s |
| 2 | TikTok:37332, UITextField | 22:15:37.777/.779/.865 | 22:15:38.158 | ~0,4s |
| 3 | TikTok:37363, UITextField | 22:17:05.797/.908 | 22:17:08.678 | ~2,9s |

Đếm: `responder became drawn=1` ×3 = `dispatch show` ×3 = `shown=1`
×3 = `shown=0` ×3 = host post active=1 ×3. Ba cửa sổ kbstate ACTIVE
(§3) khớp đúng 3 episode — không episode nào thiếu show; mọi shown=1
đều có shown=0, không panel kẹt. Ep2 đóng sau 0,4s (quá ngắn để gõ)
nhưng chuỗi mở/đóng khép kín. Gõ phím: **NO-DATA** — `insertText`/
phím-nhấn = 0 dòng; panel tự vẽ xử lý chạm nội bộ host, không log
theo phím. Ep1 mở 231s chỉ chứng minh panel sống, không chứng minh
được ký tự đã nhập.

## 3. Chuỗi kbstate: khép ở ACTIVE; reject chỉ hậu-teardown

- Accept **1153** (state=1: 234; state=0: 919); 4 session seq liền
  không đứt: YT 3432613922 (1–532), YT 3260345557 (1–523), TikTok
  3681141906 (1–29), TikTok 2717987785 (1–69).
- ACTIVE: ep1 = 232 báo cáo liền `22:05:48.153 seq=122 → 22:09:38.872
  seq=353` (3260345557, gen 3→5), kết state=0 `22:09:39.094 seq=354`
  (11ms sau shown=0). Ep2/ep3 mỗi episode 1 state=1 (22:15:37.782
  seq=7; 22:17:05.809 seq=4) vì panel ngắn hơn nhịp heartbeat ~1s.
  Trong ACTIVE: reject = 0. Emit `known=1 active=1` = 193.
- Reject **291, tất cả `noassignment`** (badgen/badhash/badsession/
  staleseq = 0), đều SAU khi ô đóng, app cũ còn heartbeat: YT
  seq524–559 (22:14:56.871→22:15:35.960, 36) + TikTok seq70–324
  (22:18:15.309→22:27:18.329, 255). Owner từ chối đúng; vết phụ là
  app không ngừng báo cáo tới hết log, không chạm episode thật.
- AutoHide giữ vì kb: `fade deferred (kb)` ×24 (23 trong ep1:
  22:05:51.811→22:07:19.843 nhịp ~4s; 1 sát đóng ep3 22:17:08.685).
  `hold/deferred (kbunknown)` ×16 cặp, toàn ngoài cửa sổ panel.
  **Fade khi panel mở = 0**: `fade last`/`host fade applied` không
  rơi vào cả 3 cửa sổ (kề nhất: 22:05:38.785 trước ep1 10s;
  22:15:36.518 trước ep2 1,3s; 22:17:28.289 sau ep3 20s).
- Nhả sau đóng: `kb hold released` ep2 22:15:38.211 (+53ms), ep3
  22:17:08.746 (+68ms). Fade lại: ep1 đóng 22:09:39.083 → session
  mới start 22:09:42.046 → `fade last idle=4.00` 22:09:46.048, đúng
  4,0s sau session start (7,0s sau đóng). Ep3 fade hoãn tới
  22:17:28.289 bởi `fade deferred (surface-open)` ×3 — do surface,
  không do kb. Lưu ý ep1: `22:07:21.404 teardown faded=0` + hold
  released xảy ra GIỮA episode (kb ACTIVE tới 22:09:38); sau đó tới
  22:09:42 không còn lượt xét autohide — hold mất sổ nhưng 0 fade lọt.

## 4. Đối chiếu ytz5hl1 (native) + verdict

hl1: native 7/7, app báo ACTIVE thật nhưng panel hệ thống không hiện
trên xe; mắt "gõ phím" NO-DATA vì không panel nào mở. hl2 drawn: mắt
đó ĐÃ có dữ kiện ở tầng panel — became → shown=1 → dispatch → `hien`
đủ 3/3, kbstate ACTIVE phủ đúng cửa sổ panel. Vẫn NO-DATA ở tầng ký
tự (xem §2).

**VERDICT:** mode hl2 = drawn thật, toàn phiên, không lật. Panel
3 mở/3 đóng khép kín, không thiếu show, không kẹt. Chuỗi kbstate
KHÉP: ACTIVE accept toàn bộ, emit/host-post khớp episode, AutoHide
giữ bằng deferred (kb), 0 fade lọt khi panel mở, nhả hold ≤68ms sau
đóng. Vết phụ: migration NO-DATA (không ảnh hưởng mode hiệu lực);
291 reject noassignment hậu-teardown. Giới hạn đo còn lại duy nhất:
ký tự gõ thực tế.
