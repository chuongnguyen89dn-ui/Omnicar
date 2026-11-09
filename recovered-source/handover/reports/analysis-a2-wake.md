# PHÂN TÍCH A2 — WAKE / AUTOHIDE / PROBE / ACT (log phiên ytz2 + fs1)

Nguồn: `OmniCar.log.old` (13:49:29–15:33:22) + `OmniCar.log` (15:33:22–15:42:17). Tổng 7.144 dòng.
**Ranh giới cửa sổ theo dấu code trong log** (build tag đều ghi [fixround7] ở cả hai bản, không dùng được): fs1 = trước **15:27:28** (không có [probe]/renew/reason act); ytz2 = từ **15:27:28** (dòng đầu `[probe] sendEvent probe installed pid=34376`). CarPlay PID ytz2: 34376 (15:27), 34413 (15:31), 34442 (15:33), 34490 (15:37), 34521 (15:39); ngắt hẳn 15:42:00.

## Câu 1 — YTZ2: đường act + renewal + owner

### 1a. Phía app (ABInApp) → owner: khép kín 32/32

| Mục | Đếm |
|---|---|
| `act-posted` (YouTube ×12, Facebook ×18, TikTok ×2 — toàn app hosted) | **32** |
| `act-accepted` phía owner | **32** |
| Owner drop: decode-fail / bad-hash / bad-gen / session-inactive / not-assigned / split-inactive | **0 / 0 / 0 / 0 / 0 / 0** |
| `act-drop-nosession` (app) | 1 — TikTok 15:33:15.805, `stateage=-1` (chưa có gói state nào được chấp nhận → cơ chế session-verified hoạt động đúng thiết kế, có log) |
| `act-drop-scene` / `act-drop-target-unknown` | 0 / 0 |

Mẫu: `15:27:54.047 [YouTube:34399] act-posted t=289473644 stateage=3 gen=1 set=0 post=0 setfail=0 postfail=0` → `15:27:54.055 act-accepted … seq=1 -> ahNoteActivity` → `15:27:54.057 reveal-applied`. notify_set_state/notify_post: fail tích luỹ = 0 trong mọi dòng act-posted.

### 1b. stateage trong act-posted — KHÔNG có ca phân định >2,5 s

Phân bố 32 giá trị: 3…883 ms (31 ca) + một ca **2056 ms**; **không ca nào > 2500 ms**. Kết luận trung thực: cửa sổ này **không chứa bằng chứng phân định** cho sửa W2 (mọi act đều vẫn qua được cả cổng tươi cũ) — vì renewal giữ state luôn trẻ (xem 1c). Bằng chứng W2 chạy được chỉ là gián tiếp: act phát theo session-verified (ca drop-nosession ở trên cho thấy cổng mới tồn tại và có tác dụng) và 32/32 act tới nơi trong khi ở fs1 đường này bị cổng freshness chặn (Câu 4).

### 1c. bw renew — chạy đều, chu kỳ đo thực 1,00 s

`bw renew start` ×2, `stop` ×2, tick `bw renew panes=` **362** dòng. Đo trên PID 34376: 15:27:42.042 → 43.041 → 44.041 → 45.041… (Δ = 0,999–1,001 s). PID 34442: Δ = 1,00 s đều, một khoảng lệch pha duy nhất 1,325 s (15:33:32.496 → 33.821, tick kế bù 0,674 s). Mọi tick kèm `bw emit … seq=N` tăng đều, gen giữ nguyên. Độ cũ state tối đa lý thuyết ~1,03 s — khớp phân bố stateage ở 1b.

### 1d. Reveal phía owner

`reveal-applied` **17** lần, **100% reason=activity, 100% views=5**. Độ trễ act-accepted → reveal-applied: 0–3 ms ở cả 17 ca. Phía host (SpringBoard): `host fade applied` ×17 + `host knob fade applied` ×17 (chỉ tồn tại khi có gương của ô hosted; các phiên toàn native không có đường này).

## Câu 2 — YTZ2: probe CarPlayApp vs ô native (câu hỏi quyết định)

Tổng `began` = **381**, `chain` = 381, **complete=1: 381/381** (không chuỗi cụt nào được ghi; Moved thường = 0 — chuỗi đủ Began+Ended).

| Phân loại scene (began) | Đếm |
|---|---|
| scene=carplay | 22 |
| scene=carplay-aux | 16 |
| scene=foreign | 209 |
| scene=unknown | 134 |

| Theo ô (began) | Đếm | Trong đó scene=carplay(-aux) | scene=foreign |
|---|---|---|---|
| Ô **native** (slot0/1: com.apple.Music, com.google.Maps, com.lumi.GOFA*) | **140** | 23 | 117 |
| Ô **hosted** (Facebook, YouTube, TikTok/Ame) | 81 | 10 (toàn aux) | 71 |
| pane=none (ngoài mọi ô: chrome/dashboard) | 155 | — | — |
| pane=outside | 5 | — | — |

\* GOFA bị probe tự phân loại "native" (theo SCPVCIsHosted trên VC của ô) — ghi đúng nhãn của log.

**Trả lời câu hỏi quyết định: CÓ — tầng CarPlayApp THẤY Began trên ô native** (140 dòng began gán đúng ô native + bundle). Nhưng **117/140 dòng đó mang scene=foreign** vì cửa sổ chạm là `_UISystemGestureWindow`, không phải cửa sổ container của split — probe thấy chạm nhưng lớp phân loại scene hiện tại xếp chúng ra ngoài "carplay". Hệ quả cho thiết kế feed: dữ kiện thô (điểm chạm + ô + bundle) đã có sẵn ở CarPlayApp; muốn dùng làm feed gọi-lại cho ô native thì phải dựa trên **gán ô theo hình học** (pane=slotN + bundle) chứ không dựa được vào scene=carplay như hiện tại. Đây là dữ kiện cho GPT quyết W4, log không tự kết luận thiết kế.

## Câu 3 — YTZ2: fade nào không có reveal?

Tổng fade thật (`fade last=`, idle=4.00/8.0x): **22**; `fade deferred (surface-open)`: 8 (đúng thiết kế, không tính). Đối chiếu từng fade với act/reveal/probe gần nhất:

- **17/22 fade được reveal bởi cú chạm hosted tiếp theo** — mọi act-accepted tới trong lúc đang mờ đều sinh reveal-applied sau 0–3 ms. Không có ca nào act tới mà reveal không chạy.
- **5/22 fade không có reveal**, chia hai nhóm rõ rệt:
  - **3 ca mồ côi vì phiên chết trước cú chạm kế:** fade 15:30:57 (sau đó CarPlay PID đổi 15:31:42), fade 15:31:58 (PID đổi ~15:33), fade 15:35:57 (PID đổi 15:37:29). Không có chạm nào sau fade trong cùng phiên — không phải lỗi reveal.
  - **2 ca là chính lỗi Nguyen báo (gọi lại chết ở app hệ thống):**
    - Fade **15:37:49.590** (PID 34490) → từ 15:37:50.358 có **16 began trên ô native** (slot1 GOFA + slot0 Maps, toàn bộ win=_UISystemGestureWindow) — **không act nào** (app native không có ABInApp), **không reveal nào**; phiên sống tới 15:39:17 mà controls không trở lại.
    - Fade **15:39:33.323** (PID 34521) → từ 15:40:00 có **25 began trên ô native** — không act, không reveal, tới khi ngắt 15:42:00.
  - `reveal-applied` theo PID: 34376 ×7, 34442 ×10, **34490 ×0, 34521 ×0** — hai phiên toàn-native: mờ được, gọi lại không.

## Câu 4 — FS1 (13:49–15:19, code cũ): bằng chứng cho verdict còn nợ

### 4a. AutoHide mờ những gì

Owner `fade last=` **25** lần; phía host áp đủ cả hai kênh ở **25/25**: `host fade applied bundle=` ×25 + `host knob fade applied` ×25. Log fs1 không liệt kê từng view phía CarPlay nên "tập sơn" phía CarPlay chỉ chứng minh được qua: fade event + hai kênh gương host (handle + knob) + `teardown faded=` ×3. Không có `fade deferred` trong fs1 (0).

### 4b. Reveal ở fs1 — có chạy, nhưng log không gán được nguồn

`[autohide] reveal reason=activity` **22** lần (100% reason=activity); host `fade restored` ×23 + `knob fade restored` ×23; `HIDDEN->VISIBLE` ×23. 25 fade → 22 reveal/23 restore: phần thiếu nằm ở các phiên kết thúc bằng teardown.
Giới hạn bằng chứng của fs1 (nói rõ): code cũ **không log act receipt, không log homeButtonTapped (0 dòng trong toàn cửa sổ)** — nên từ log **không thể gán** 22 lần reveal cho F1/F2/F3/F4. Đối chiếu thời gian cho thấy reveal trùng khít với chuyển trạng thái HIDDEN->VISIBLE và ngay sau các dãy chạm phía app (vd 14:35:54.226 dãy probe trong YouTube → 14:35:54.713 HIDDEN->VISIBLE + reveal cùng mili-giây) — tương thích với đường act-khi-state-tươi, nhưng đó là suy luận từ mốc thời gian, không phải dòng log trực tiếp. **Câu hỏi "F3 có phải đường reveal duy nhất sống ở fs1" — log không trả lời được** (F3 không hề được log); phát biểu của Nguyen trên xe (chỉ bấm trúng logo mới gọi lại được) cũng không bị log bác bỏ: 26/91 dãy probe phía app ở fs1 mang `failopen=stale` — đúng điều kiện cổng BWFresh chặn act khi state đã cũ, tức reveal chỉ chạy ở các lần state còn tươi.

### 4c. Pinch probe fs1 ([do] bw probe, DRY_RUN)

**91 dãy** (YouTube ×86, TikTok ×3, còn lại ×2): `wouldPinch=1` trong **0/91**; `wouldSwallow=0` toàn bộ. failopen: stale ×26, kbunknown ×26, unknown ×17, kb ×1, trống ×21. Không dãy nào hội đủ điều kiện cặp pinch ở phía app trong suốt cửa sổ fs1 — dữ kiện Gate 2 cho ô hosted: probe phía app không ghi nhận được cặp pinch hoàn chỉnh nào (mọi dãy đều gãy ở cổng freshness/kb hoặc không thành cặp).

## Kết luận A2

1. **Đường act ytz2 khép kín hoàn toàn ở phía hosted**: 32 posted → 32 accepted → 0 drop có reason; renewal 1,00 s đều; reveal chạy 17/17 khi act tới lúc đang mờ, trễ ≤3 ms. Sửa W1/W2 có hiệu lực vận hành; riêng ca phân định stateage>2,5 s thì phiên này không phát sinh (do renewal giữ state trẻ) — không khẳng định quá dữ kiện.
2. **Lỗi "gọi lại chết ở app hệ thống" được log kết án**: 2 phiên toàn-native (PID 34490/34521) mờ bình thường, sau đó 16 + 25 cú Began rơi đúng ô native mà không sinh act/reveal nào. Phía hosted cùng phiên chạy hoàn hảo — gãy đúng ở biên native.
3. **Probe CarPlayApp nhìn thấy chạm native** (140 began gán ô native) nhưng 117/140 bị phân loại scene=foreign (cửa sổ _UISystemGestureWindow) — dữ kiện hình học (ô + bundle) dùng được, nhãn scene hiện tại thì không.
4. **fs1 (code cũ)**: mờ đủ 25/25 cả hai kênh host; reveal activity 22 lần nhưng **không gán nguồn được từ log** (không log act/F3); wouldPinch 0/91. Verdict fs1 còn nợ chỉ chốt được tới mức này.
