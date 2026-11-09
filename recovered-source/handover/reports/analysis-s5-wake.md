# S5 — WAKE + HỒI QUY + PINCH — PHIÊN YTZ5HL1 (chỉ-đọc trên log)

Nguồn: `OmniCar.log` (5.112 dòng) + `OmniCar.log.old` (9.204 dòng), thư mục `session-ytz5hl1/`.
Mọi đếm bằng grep/python trên file gốc; dòng trích ghi số dòng của file chứa nó.
Nhãn: LOG-CONFIRMED = đếm/dòng trực tiếp; CONTRADICTS = log ngược với giả định nêu trước; NO-DATA = không có dòng nào ghi.

## 0. Mốc tách thế hệ (điều kiện tiên quyết của mọi đếm)

- Phần ytz4 trong `.old`: dòng 1–2477, 17:40:49.361–17:49:22.802, CarPlay 36057/36136/36168, SpringBoard 36056/36137/36167. Mọi dòng 17:xx thuộc ytz4, LOẠI khỏi mọi đếm dưới đây.
- Thế hệ mới bắt đầu trong `.old` tại dòng 2478: `2026-11-09 20:18:10.158 [SpringBoard:36658] AppBridge: loaded into SpringBoard`; CarPlay:36683 từ dòng 2499 (20:18:43.414). Tag mới xuất hiện từ đây: `[home-launch]` dòng 2500 (20:18:43.421), `[kbstate]` đầu tiên dòng 3415 (20:24:44.418, `source=app-input-session`). Ở phần ytz4, `[kb-sync]` mang `source=host-keyboard-session` và KHÔNG có `[kbstate]`/`[home-launch]`.
- Điểm gãy file 20:36:45 KHÔNG phải gãy tiến trình: `OmniCar.log` mở đầu vẫn là CarPlay:36683 (dòng 3, 20:36:46.120) và SpringBoard:36658; CarPlay:36712 chỉ bắt đầu tại dòng 1017 (20:39:56.347) sau khi 36683 chấm dứt ở dòng 1014 (20:39:50.871). SpringBoard:36711 từ ~20:39:57. Vì vậy "phiên mới" = đuôi `.old` từ dòng 2478 + toàn bộ `OmniCar.log`; hai nửa này là MỘT phiên liên tục.
- Kiểm chứng chéo wouldSwallow: `grep -c wouldSwallow` = 17 ở mỗi file, nhưng `grep "^2026-11-09 17:" OmniCar.log.old | grep -c wouldSwallow` = 0 — cả 17 dòng của `.old` đều ở 20:25:02–20:36:14 (thế hệ mới). Tổng thế hệ mới: 34 dòng probe. LOG-CONFIRMED.

## 1. Probe / wouldSwallow thế hệ mới (Đo, DRY_RUN) — LOG-CONFIRMED

Tổng 34 probe `[do] bw probe` (YouTube:36693, hosted=1 ở cả 34), seq 1–59 (không liên tục).
Phân bố tổ hợp (state / kbKnown / kbActive → wouldSwallow):

| Tổ hợp | Số ca | would=1 | Ghi chú |
|---|---|---|---|
| H / 1 / 0 | 9 | 4 | xem dưới |
| V / 1 / 0 | 11 | 0 | đúng kỳ vọng (đang hiện) |
| V / 1 / 1 | 2 | 0 | kb đang mở, state V |
| U / 0 / 0 | 12 | 0 | failopen=unknown, toàn bộ ở `OmniCar.log` seq 48–59 |

- Ca HIDDEN + kb INACTIVE (điều kiện nuốt đầy đủ): CÓ 9 ca. wouldSwallow=1 ở 4 ca: seq=1 (20:25:02.102, `.old` L3523, kbAge=625), seq=8 (20:25:45.294, L4100, kbAge=623), seq=17 (20:26:36.426, L4591, kbAge=235), seq=20 (20:30:25.943, L6298, kbAge=9) — cả 4 đều failopen=`-`. wouldSwallow=0 ở 5 ca: 4 ca failopen=stale (seq=18 20:27:23.402 kbAge=277; seq=31 20:35:22.955 kbAge=504; seq=32 20:35:37.120 kbAge=681; seq=46 20:38:10.381 kbAge=14) và 1 ca failopen=`-` bất thường: seq=45 (20:37:23.977, `OmniCar.log` L341, kbAge=527) — cùng chữ ký với 4 ca would=1 mà kết quả 0. Bối cảnh dòng kề: fade applied 20:37:23.917–.927, `[autohide] act-posted stateage=24` 20:37:23.943 (L333), reveal-applied 20:37:23.948 (L335), host fade restored 20:37:23.949 (L337) — tại thời điểm chạm, phía host đang trong nhịp reveal. Giả thuyết (chưa chứng minh): snapshot state=H của probe chụp trước nhịp reveal vài chục ms. Đây là ca duy nhất phá vỡ tương quan would=1 ↔ (H + known + inactive + failopen=`-`).
- Ca chạm trong cửa sổ HIDDEN + kb ACTIVE: KHÔNG CÓ. Chỉ 2 probe có kbActive=1 (seq=38 20:35:47.329; seq=40 20:36:14.012) và cả hai đều state=V.
- Sâu hơn: tổ hợp HIDDEN + kb ACTIVE không hề đồng tồn tại trong phiên. `[kbstate]` (CarPlay:36683) ghi state=1 tổng 75 accept, gom thành 3 cửa sổ kb ACTIVE: 20:25:46.499–20:25:49.856 (gen=3), 20:25:51.122–20:26:31.130 (gen=3→4), 20:35:46.138–20:36:14.074 (gen=20); `[kb-sync] active=1` = 148 dòng, toàn bộ nằm trong 3 cửa sổ này (ở `OmniCar.log` = 0). Trong cả 3 cửa sổ, `[wake1] bw emit` phía owner đều là state=VISIBLE (mẫu: 20:25:46.134 seq=229; 20:35:46.120 seq=1788; 20:36:13.120 seq=1872). → Mắt xích Gate 3 "chạm lúc HIDDEN+kb ACTIVE" vẫn THIẾU ở thế hệ mới, và thiếu theo cách mạnh hơn ytz4: điều kiện tiền đề (HIDDEN trong lúc kb mở) chưa từng xảy ra, không phải chỉ thiếu chạm. LOG-CONFIRMED.
- Bằng chứng gõ phím (mắt xích 2 của ytz4): vẫn NO-DATA. Trong 3 cửa sổ kb ACTIVE chỉ có đúng 2 probe (seq=38: ph B=1 M=0 E=1; seq=40: ph B=1 M=0 E=1) — mỗi ca là 1 chạm đơn, không có chuỗi chạm kiểu gõ phím; cửa sổ dài nhất (40 giây, 20:25:51–20:26:31) có 0 probe. `[kbstate]` seq chạy đều ~1/giây (heartbeat session), không phải sự kiện phím.
- Chạm sau khi đóng phím trên cùng assignment (mắt xích 3): CÓ một phần. Cửa sổ 3 đóng lúc 20:36:14.074 (`[kbstate]` 1→0, gen=20; `[autohide] kb hold released` L9002 cùng timestamp). Sau đó, cùng YouTube:36693 / cùng kb session 2089400554 / gen=20: seq=42 (20:37:17.176, V), seq=43 (V), seq=45 (H — ca bất thường ở trên), seq=46 (H, stale), seq=47 (V). Tức mắt xích "có chạm sau đóng phím trên cùng assignment" đã có dữ kiện; riêng ca H trên assignment đó (seq=45) lại cho would=0 — xem cảnh báo ở trên.

## 2. Native feed (SCPTouchProbe / `[probe-feed]`) + chuỗi act/ack — LOG-CONFIRMED

- `[probe-feed]` thế hệ mới: 229 dòng (200 ở đuôi `.old` + 29 ở `OmniCar.log`). Kết quả: fired=31 (28 + 3), drop-hosted=60, drop-inactive=110, drop-systemregion=16, drop-popup=10 (picker 6, traywindow 3, tray 1), drop-unconverted=2.
- Cả 31 lần fired đều trên pane `com.google.Maps` native (slot0/slot1), cửa sổ `_UISystemGestureWindow` (30) / `UIWindow` (1). Ví dụ: 20:25:18.008 (`.old` L3729, epoch=3, slot1 Maps), cụm 12 lần 20:27:53.624–20:27:59.097 (epoch=7, slot0 Maps), 20:38:16.943 + 20:38:16.948 (log L686/L689 — cùng 1 chạm, 2 cửa sổ, epoch=16). Không có lần fired nào trên pane hosted (mọi chạm hosted rơi vào drop-hosted=60).
- Chuỗi act phía app → ack phía owner: `[autohide] act-posted` (YouTube) = 47 (40 + 7); `[autohide] act-accepted ... -> ahNoteActivity` (CarPlay) = 46 (39 + 7). LỆCH ĐÚNG 1: dãy seq của act-accepted ở đuôi `.old` là 1–18, 20–40 — thiếu seq=19; act-posted thứ 19 là dòng 5272 (20:27:50.617, gen=8, stateage=6981) và không có dòng act-accepted seq=19 ở cả hai file. Ở `OmniCar.log`, 7 act-posted (seq 41–47 theo bộ đếm act) đều có accepted tương ứng — đoạn này khép. Mọi act-posted đều set=0 post=0 setfail=0 postfail=0.
- Ngoài chuỗi trên còn 12 dòng `act-drop-nosession` (toàn bộ ở `OmniCar.log`, 20:38:22.012–20:39:50.835, stateage=-1): app vẫn post act sau khi session phía owner đã hết (khớp thời điểm probe chuyển sang state=U/kbKnown=0 từ seq=48, 20:38:22.055). Đây là drop có ghi lý do, không phải ack thất lạc.
- stateage tối đa trên act-posted: 42546 tại 20:32:18.162 (`.old` L7081, gen=12). Riêng trong `OmniCar.log`: tối đa 6015 tại 20:38:10.135 (L593, gen=20). (Đơn vị như log ghi; các act-drop mang stateage=-1, không tính.)

## 3. FS1 / guard (txn expand/restore) — LOG-CONFIRMED

`[fs1]` thế hệ mới: 11 dòng (5 + 6), trừ 2 dòng `fs controller installed` (20:18:43.430 cho 36683; 20:39:56.372 cho 36712) còn 9 lần thao tác, toàn bộ provenance=diag:

| Loại | Số | Chi tiết |
|---|---|---|
| expand confirmed | 2 | txn=1 (20:27:39.622, `.old` L5107); txn=3 (20:36:06.775, `.old` L8940) |
| restore refused | 3 | 20:36:06.319 (`.old` L8922); 20:39:33.969 (log L891); 20:39:43.161 (log L974) — đều `state=SPLIT` |
| expand refused | 2 | 20:39:35.140 (log L905); 20:39:44.857 (log L990) — đều `reason=inactive` |
| session-end abbreviated restore | 2 | 20:27:43.259 (`.old` L5146); 20:38:20.199 (log L811) — provenance=teardown |

- Tỉ lệ: confirmed 2/9 thao tác (22%); refused 5/9 (56%); abbreviated-teardown 2/9 (22%). Nếu chỉ tính cặp expand: 2 confirmed / 4 lần thử (50%).
- snap ở 5 lần refused: `picker=0 ratio=0 dg=0 toast=0 tray=0` ở CẢ 5 — tức popup/picker/ratioMenu/dragGhost/toast đều KHÔNG sống tại thời điểm refused; cờ sống là `to=1` (5/5) và thêm `tw=1 twh=1` ở 3 lần trong `OmniCar.log` (lần ở `.old` có tw=0 twh=-). Điểm này CONTRADICTS với mô tả "refusals khi popup/picker/ratioMenu/dragGhost/toast đang sống": log cho thấy refused xảy ra khi các thành phần đó đều tắt, với to=1 là điểm chung duy nhất. (Không có dòng `[fs1]` nào ghi frame đọc lại riêng; chữ "confirmed" nằm trong chính dòng txn.)
- Lỗ hổng đánh số: txn nhảy 1 → 3, không có dòng confirmed mang txn=2 ở cả hai file. Ứng viên duy nhất theo thời gian là abbreviated restore 20:27:43.259 (3,6 giây sau txn=1) nhưng dòng đó không mang số txn — NO-DATA, không tự gán.

## 4. YTZ lease (appbridge.ytlease) — LOG-CONFIRMED

- Grant: `lease cap` = 8 (7 ở đuôi `.old`: gen=0 20:24:36.490 size=495x450; gen=5/9/11/13/15/18 kèm prevRevoke=10.46/3.40/8.87/3.02/2.42/72.38s; 1 ở log: gen=0 20:40:18.867, SpringBoard:36711, size=371x428). `lease gia han` = 8 (7 + 1). `lease nhan` phía app = 23 (16 + 7).
- Ack: `ack phase=applied windows=1 mismatch=0` = 23 (16 + 7). Một ack khác duy nhất: `ack phase=request windows=0 mismatch=0` (log L1450, 20:40:24.464) — 55ms sau có ngay applied windows=1 (L1452, 20:40:24.519). Toàn phiên: `mismatch=` khác 0 = 0 dòng (grep cả hai file). w/m khép hoàn toàn ở trạng thái applied.
- Revoke: `lease thu hoi ly do=teardown` = 6, toàn bộ ở đuôi `.old`, mỗi lần kèm `[ytz-revoke-snap]` (logical=pub=box khớp nhau, frame giữ nguyên `244,0,396x360` — revoke không layout cưỡng bức) và `ao hoa TAT ly do=close` phía app; `[ytz-nextlayout]` 6 lần sau re-grant. Ở `OmniCar.log`: revoke = 0 (lease của 36683 kết thúc bằng việc tiến trình CarPlay chết 20:39:50, không có dòng thu hồi).
- Mask 24: 29 dòng phía app ở đuôi `.old` (0 ở log), gồm `bo qua su kien xoay gia: app dang chi cho mask 24` (ví dụ L4845, 20:27:01.349), `bao SpringBoard: ma 255, mask 24` (L4855), `bo qua ep xoay 1: app chi cho mask 24` (L6676). Không có dòng nào ghi mask khác 24 cho app hosted, và không có dòng mask rời app. LOG-CONFIRMED (trong phạm vi các dòng đã ghi).
- OFF-control: NO-DATA — không có ca nào lease bị từ chối/không cấp vì pref tắt trong phiên; mọi lần xin đều được cấp (8/8 grant, hooks=6 mỗi lần `ao hoa BAT`). Phiên không chứa tình huống đối chứng pref-OFF cho YTZ.

## 5. Weather / knob trong phiên — LOG-CONFIRMED

- Weather: chỉ có đúng 2 chu trình `ans#1`, mỗi chu trình ở thời điểm SpringBoard khởi động: 20:18:25.610–20:18:26.687 (SpringBoard:36658, `.old` L2491–L2498) và 20:40:12.574–20:40:13.653 (SpringBoard:36711, log L1247–L1258). Cả hai đều tự ghi `source=warming-cache (internal startup call, NOT a CarPlay request)`, fetch xong `updated in 1.1s (http 200, no error)` rồi `ans#1 ready-posted`.
- Không có ans#2 trở đi ở cả hai file (grep `ans#` thế hệ mới chỉ ra 6 dòng, thuộc 2 chu trình #1 trên). Không có dòng request từ CarPlay, không có dòng display/payload mang giá trị thời tiết (nhiệt độ/điều kiện) nào trong phiên — phần payload là NO-DATA, phần "chỉ có warming-cache lúc startup" là LOG-CONFIRMED.
- Knob (host knob của AutoHide, phía SpringBoard): `host knob fade applied` = 23 (20 + 3), `host knob fade restored` = 22 (19 + 3) trên toàn phiên — lệch 1 applied chưa có restored tương ứng ở cuối chuỗi 36683 (điểm chi tiết thuộc strand AutoHide; ở đây chỉ ghi nhận vì knob là bề mặt wake).

## 6. Pinch — [pinch1] migration + bằng chứng hai ngón trong app

- Dòng migration riêng cho pinch: NO-DATA. Grep `migration`/`migrat` = 0 dòng ở cả hai file; toàn bộ `[pinch1]` thế hệ mới chỉ gồm 11 dòng: `recognizer attached to split container` ×10 (20:18:50.650 `.old` L2766 → 20:40:14.274 log L1266) và 1 dòng tổng kết `session end pairs` (20:27:43.258, `.old` L5143) ghi split complete=0, expanded complete=0, cờ bị-cắt = 0 ở cả hai phía. Không dòng nào ghi giá trị pref trước/sau.
- Giá trị pinch hiệu lực thì có bằng chứng gián tiếp nhất quán: `[wake1] bw modes wake=1 pinch=0 allowlist=all autohide=1` ở cả 9 lần in modes (đầu tiên ngay tại startup 20:18:43.429, `.old` L2506; cuối cùng 20:39:56.372, log L1024), và wouldPinch=0 ở cả 34/34 probe. Tức pinch ở trạng thái OFF suốt phiên — LOG-CONFIRMED cho trạng thái, NO-DATA cho sự kiện migration.
- Bằng chứng hai ngón PHÍA TRONG APP: có đúng 1 ca, bằng tag `[do] bw probe` phía YouTube: seq=49 (20:38:23.821, log L835) với `ph B=2 M=17 E=2 C=0 dur=0.21` — 2 vòng đời chạm bắt đầu/kết thúc và 17 moved được chính tiến trình app ghi lại (state=U, kbKnown=0 nên ca này không liên quan wake). Đây là ca B=2 duy nhất trong 34 probe (33 ca còn lại B=1, trừ seq=49). Ngoài tag này, không tiến trình app nào (YouTube/GOFA) có dòng gesture/pinch riêng trong phiên.
- Lưu ý kỷ luật đo: các dòng `[touchset]` (590 dòng thế hệ mới) là vị trí đo phía CarPlayApp và có các ca active=2 — theo quy tắc đã chốt, KHÔNG dùng chúng để kết luận gì về pinch trong app, và biên bản này không đếm chúng làm bằng chứng hai ngón.

## 7. Bước 2 — đối chiếu phần wake (thoát lúc mờ → mở lại) — LOG-CONFIRMED

- `close-cleanup faded=1` có 3 lần (thoát trong lúc controls đang mờ): 20:26:49.740 (`.old` L4693), 20:31:14.391 (L6651), 20:33:49.843 (L8029). (4 lần khác faded=0: 20:18:53.357, 20:32:19.111, 20:32:30.195 ở `.old` và 20:38:20.163 ở log L793 — lần cuối này là thoát hẳn, sau đó không mở lại YouTube nữa, khớp act-drop-nosession ở §2.)
- Cả 3 lần mở lại sau cleanup faded=1 đều cho cùng một nhịp đúng: `session start` (20:26:59.971 / 20:31:17.575 / 20:35:02.089) → `host knob fade restored` trong vòng 44–42–37ms (20:27:00.015 / 20:31:17.617 / 20:35:02.126), kèm MILESTONE revealPane readySource=launch-callback → controls hiện đủ khi mở lại. Sau đó ẩn lại đúng nhịp idle 4s: lần 1 có act cuối 20:27:01.853 rồi `fade last=app idle=4.00` lúc 20:27:05.864; lần 2 `fade last=container idle=4.01` lúc 20:31:21.581 (≈4,0s sau session start 20:31:17.575). Lần 3 bị chen bởi hoạt động liên tục (reveal 20:35:22.929, 20:35:27.177) nên fade kế tiếp rơi ở 20:35:18.614/20:35:26.931 với idle=4.00 — vẫn đúng quy tắc 4s tính từ activity cuối.
- Toàn phiên: `fade last` = 23 dòng, idle ghi trong log là 4.00 ở 20 dòng, 4.01 ở 2 dòng, và 1 ngoại lệ idle=8.00 (20:25:44.004, `.old` L4067, `last=hosthandle`). `reveal-applied reason=activity views=5` = 18 (15 + 3).
- Rò trạng thái mờ sang phiên mới (ahFadedState): chuỗi ký tự `ahFaded`/`fadedState` KHÔNG xuất hiện ở cả hai file (grep = 0) — NO-DATA cho trường đó theo đúng tên. Bằng chứng hành vi thay thế: không lần mở lại nào bắt đầu ở trạng thái mờ — cả 3 lần sau cleanup faded=1 đều có fade restored ngay khi session start (xem trên), và `[autohide] session start` (10 dòng thế hệ mới: 9 + 1 của CarPlay:36712 lúc 20:40:14.275) không mang theo cờ faded nào. Kết luận trong phạm vi log: không có dấu hiệu rò faded-state qua cleanup. LOG-CONFIRMED (hành vi) / NO-DATA (trường ahFadedState theo tên).

## Tổng kết S5

1. Gate 3: điều kiện nuốt đầy đủ (H + known + kb inactive) ĐÃ có 9 ca, 4 ca would=1 sạch; nhưng mắt xích quyết định "chạm lúc HIDDEN + kb ACTIVE" vẫn thiếu vì tổ hợp đó không đồng tồn tại (kb mở ⇒ owner luôn VISIBLE), bằng chứng gõ phím vẫn NO-DATA, và ca H sau-đóng-phím trên cùng assignment (seq=45) cho would=0 bất thường giữa nhịp reveal — điểm cần GPT soi tiếp.
2. Native feed fired 31 lần, toàn bộ trên Maps native; act/ack lệch đúng 1 (seq=19, act-posted 20:27:50.617 không có accepted), cộng 12 act-drop-nosession có lý do; stateage max 42546.
3. FS1: 2 expand confirmed / 5 refused / 2 abbreviated restore; snap ở refused cho thấy popup/picker/ratio/dragGhost/toast đều tắt (to=1 là cờ chung) — CONTRADICTS với mô tả refusal theo các thành phần đó.
4. YTZ: 8 grant, ack applied khép 23/23 phía app nhận, mismatch=0 toàn phiên, 6 revoke teardown không layout cưỡng bức, mask 24 giữ nguyên; không có ca OFF-control.
5. Weather: chỉ 2 chu trình ans#1 warming-cache lúc SpringBoard startup, không request CarPlay, không payload hiển thị. Pinch: không có dòng migration (NO-DATA), trạng thái OFF nhất quán (bw modes pinch=0 ×9, wouldPinch=0 ×34); bằng chứng hai ngón trong app duy nhất: probe seq=49 ph B=2 M=17 E=2.
6. Bước 2 (phần wake): thoát-lúc-mờ → mở lại hiện đủ → ẩn lại sau 4s đúng ở cả 3 lần; không dấu hiệu rò faded-state.
