# S3 — Gate-3 trial: mổ xẻ lần thử nuốt trên YouTube (hl2, chỉ-đọc)

Phạm vi: chỉ thế hệ hl2 — CarPlay 37310 (22:03:25–~22:15) + 37334 (22:16:01–22:27), YouTube 37317/37370. Thế hệ 367xx/36808 loại. Verdict miệng (§29.15): chạm gọi logo vẫn dính app, video bị phát — KHỚP log dưới đây.

## 1. Mode ENFORCE cho ô YouTube: CÓ, cả host phát + app nhận

- Host scope: `22:03:25.099 [CarPlay:37310] [gate3] trial bundle=com.google.ios.youtube enabled=1 packetPinch=2` (lặp 22:15:48; 37334: 22:16:01.254).
- Host packet: 125 dòng `[gate3] trial packet … wm=ENFORCE (global 1)` — đầu 22:03:31.902 slot=1 state=UNKNOWN gen=1 count=1; cuối 22:27:17.018 slot=0 state=VISIBLE gen=6 count=641; HIDDEN 21 packet.
- Emit: 1.096 dòng `bw emit com.google.ios.youtube … wm=2 pm=2` (2=ENFORCE; ô khác wm=1=DRY_RUN, vd Maps). Ô: bundle `com.google.ios.youtube`, hash28 `d3b4e0d` (`bw renew panes=1 hashes=d3b4e0d`), slot=1 ở 37310, slot=0 cuối 37334.
- App nhận: probe mang `stateSeq` khớp seq host phát kèm wm=2 — seq=7 dùng stateSeq=110 = host `22:04:09.731 emit … HIDDEN gen=3 seq=110 wm=2 pm=2`; seq=56/100 dùng 815/1555 = emit 22:21:02.133/22:24:44.129 wm=2. App còn tự log `pinchMode=enforce` (mục 2) ⇒ packet mode ĐÃ tới và latch trong app.

## 2. Episode: chạm lên YouTube lúc HIDDEN (probe phía app, hl2)

hl2: 157 probe YouTube (V=146, H=9, U=2), wouldSwallow=0 tất cả. 9 episode H — tất cả hosted=1, kbKnown=1, kbActive=0 (kb KHÔNG phải lý do):

| Đóng (probe) | PID/seq | B | stateSeq/ageMs | failopen | Ghi chú |
|---|---|---|---|---|---|
| 22:04:12.377 | 37317/7 | 1 | 110 / 2605 | stale | 1 ngón — ứng viên cú verdict |
| 22:04:22.968 | 37317/10 | 1 | 144 / 3567 | stale | 1 ngón — ứng viên |
| 22:05:10.068 | 37317/12 | 2 | 230 / 24167 | stale | pinch; kèm pinch2 blocked reason=stale |
| 22:05:47.873 | 37317/36 | 1 | 406 / 9009 | stale | 1 ngón — ứng viên |
| 22:19:28.097 | 37370/10 | 2 | 492 / 2678 | stale | pinch; pinch2 blocked stale |
| 22:19:40.027 | 37370/15 | 1 | 524 / 5816 | stale | 1 ngón — ứng viên |
| 22:21:03.279 | 37370/56 | 2 | 815 / 659 | pinchin | gate yield, pinch2 began committed=expanded |
| 22:21:50.834 | 37370/71 | 2 | 960 / 3501 | stale | pinch; pinch2 blocked stale |
| 22:24:44.892 | 37370/100 | 2 | 1555 / 467 | pinchin | gate yield, began committed=expanded |

Dòng yield: `22:21:02.793 [YouTube:37370] [gate3] bw gate yield pinch-in: state=H pinchAllowed=1 pinchMode=enforce stateSeq=815` (+22:24:44.597, seq=1555). Không episode nào failopen=nokeywindow/kb/unknown/mode/phone/notarget/mixed.
Ngưỡng stale tách sạch: stale ⇔ stateAgeMs ≥ 2605; không-stale ≤ 2198 ms ⇒ veto freshness 2,5 s của hl2 là điểm quyết định (source push9-clone nay là hl3 đã GỠ veto này khỏi BWGatePass — log hl2 chưa có).

## 3. Wake / swallowed

- Nuốt thật (enforce): **0 lần** — `bw nuot day` = 0, `bw ack` = 0 trong CẢ hai file log (không riêng hl2).
- wouldSwallow (đánh giá như-ENFORCE): **0/157** ở hl2 — cổng không pass nổi một lần nào ở state H.
- Wake vẫn phát, bằng đường activity AutoHide chứ không phải giao dịch nuốt: ở CẢ 9 episode, ngay tại Began (trước probe đóng 40–490 ms) đều có `act-posted` → `act-accepted bundle=com.google.ios.youtube kb=0 seq=<đúng seq probe> -> ahNoteActivity` → host `HIDDEN->VISIBLE` + `reveal-applied reason=activity views=4` trong ~3 ms (vd seq=7: act 22:04:12.337/.339, flip .340, probe đóng .377). Host HIDDEN->VISIBLE YouTube: 21 lần/hl2. Controls hiện NHƯNG cú chạm đã qua cổng fail-open tới view app ⇒ video bị phát — đúng verdict.

## 4. Kết luận cơ chế — điểm lọt

**App gate cho qua vì `stale` (freshness veto trên snapshot latch)** — 7/9 episode H, gồm 4/4 episode 1-ngón ứng viên cú verdict. Snapshot HIDDEN app giữ quá 2,5 s tại Began (2.605–24.167 ms) nên BWGatePass fail-open trước khi xét ENFORCE; chạm đi thẳng vào app, đồng thời activity feed làm host reveal controls.
Hai episode còn lại lọt theo thiết kế: `pinchin` — HIDDEN+pinchAllowed=1+pinchMode=ENFORCE ở ô EXPANDED, cổng nhường ngón 1 của pinch-in (2-ngón, không phải cú gọi logo).
Loại trừ bằng log: host không cấp ENFORCE (sai — mục 1); packet không tới app (sai — stateSeq khớp + pinchMode latch); hook không chạy trên surface video (sai — probe sendEvent chạy, hosted=1, có quyết định từng episode).

## NO-DATA

- Cú chạm cụ thể nào trong 4 episode 1-ngón đã phát video: log không có mốc phát video; cả 4 cùng cơ chế stale.
- Vì sao snapshot app tụt sau host: host vẫn emit HIDDEN ~1/s (seq=113, 116 lúc 22:04:10–11) nhưng stateSeq app giữ ở 110 tới Began 22:04:12.337 — log không ghi lý do không latch.
- App latch wakeMode: không có dòng app riêng; suy từ stateSeq↔packet wm=2 + dòng pinchMode=enforce phía app.
