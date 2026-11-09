# PHÂN TÍCH A3 — YT-ZOOM + PINCH + WEATHER + NÚM (phiên ytz2)

Nguồn: `OmniCar.log.old` (5.248 dòng, 13:49–15:33; fs1 ~13:49–15:19, ytz2 ~15:19–15:33) + `OmniCar.log` (1.896 dòng, 15:33–15:42, ytz2). Phương pháp: `grep -c` đếm trước, trích đoạn ≤40 dòng. Mọi kết luận chỉ từ log; mục log không có ghi rõ "KHÔNG CÓ TRONG LOG".

## 1) YT-ZOOM — KẾT LUẬN: LEASE/ACK CHẠY ĐÚNG TOÀN DIỆN TRONG PHIÊN; VIRTUALIZATION CHẶN ĐƯỢC GÓI XOAY DUY NHẤT

### Bảng đếm (cả hai file)
| Mục | Số | Ghi chú |
|---|---|---|
| `[ytz]` tổng | 46 (44 old + 2 new) | new chỉ có 2 dòng owner (2 phiên host sau không cấp lease nào) |
| Lease cấp (`lease cap`) | **2** | gen=0 (15:27:42) + gen=1 (15:29:35, sau revoke pref) — cả hai `size=318x300 split=1` |
| `lease nhan` phía app | 7 | gen 0,2,3,4,5,6 — các gen giữa là cập nhật nội dung (đổi size khi kéo divider: 318→325→318→224→238, cao 300 giữ nguyên), không log `lease cap` riêng |
| Ack `applied` | **6** | **cả 6 đều `windows=1 mismatch=0`** — KHÔNG ca nào mismatch≠0, KHÔNG ca nào windows=0 |
| Ack `request` | 5 | 1 sau revoke-pref (15:29:35.5) + 4 sau teardown (15:30:57–15:31:04, app xin lại nhưng host đã thu hồi — self-heal phía host không cấp lại vì phiên đã teardown) |
| Ack `revoked` | 2 | khớp 2 lần thu hồi |
| Ack `expired` | **0** | không có ack hết hạn nào |
| `lease thu hoi` (revoke) | 2 | `ly do=pref` 15:29:35.101 (Nguyen tắt công tắc YTZ ở Chẩn đoán — đối chứng Y2) + `ly do=teardown` 15:30:56.817 |
| `lease-lapse` | **0** | không lapse nào trong cả hai file |
| `owner phien host` | 5 | 3 owner UUID ở old + 2 ở new — mỗi lần SpringBoard/host khởi động lại là owner mới; trong một phiên lease chỉ 1 owner (4663CD28…) |
| `isSplit-fallback` | **0 / 0** | đúng kỳ vọng phiên ytz2 thuần — đường fallback đếm-pane KHÔNG chạy lần nào |
| `chan apporient` | 1 | xem dưới |
| `tieu thu tuyen bo (lease song)` | 4 | app tiêu thụ tuyên bố hướng trong lúc lease sống |

### Ca YouTube + Maps native (ca isSplit quyết định)
- 15:27:41–15:27:44: YouTube hosted mở (pane 0x2852a0160), `bw renew panes=1` (chỉ 1 pane HOSTED), đồng thời DIAG icon `com.apple.Maps` hiện diện — split hỗn hợp **YouTube hosted + Maps native**.
- Lease cấp cho ca này: `split=1` ✓ — **đúng**: nguồn isSplit mới (trạng thái trình bày của SCPCarSplit) cho 1 trong khi phép đếm hosted-pane cũ (`panes.count<=1`) sẽ cho 0. Đây là bằng chứng log trực tiếp là sửa Y1 hoạt động đúng ca mục tiêu.
- Cả 2 lease cấp đều `split=1`; phía app `ao hoa BAT hooks=6 match=single` ×2.

### Quanh cú chạm fullscreen YouTube
- 15:27:44.789: `relay ap: windows=1 mismatch=0`, `ao hoa BAT hooks=6`.
- 15:27:45.036 (YouTube): `bao SpringBoard: ma 255, mask 2` — app PHÁT tuyên bố ngang (mask 2); **cùng millisecond** phía host: `[ytz] chan apporient: pane dang ao hoa (hash=3551846623)` — gói bị CHẶN tại cổng tiêu thụ.
- Trong toàn cửa sổ lease 15:27–15:31: **0 dòng `doi yeu cau xoay`** (dòng host yêu cầu scene xoay). Hai dòng `doi yeu cau xoay` ở file new (15:33:36 Ame, 15:33:42 Facebook) là app KHÁC, ngoài cửa sổ lease, và đều kết `-> scene huong 1`.
- Đối chiếu: các cửa sổ fs1 (13:49–15:18) có 51 dòng `doi yeu cau xoay` — hành vi cũ còn nguyên ngoài lease, đúng thiết kế (chỉ pane có lease mới bị ghim).
- Khoảng đối chứng pref-OFF chỉ kéo dài 0,5 s (15:29:35.101→15:29:35.604) — quá ngắn để kết luận hành vi OFF từ log; ghi nhận là KHÔNG ĐỦ DỮ KIỆN cho mục đối chứng OFF trong phiên này.

**Kết luận câu 1:** grant/ack/revoke/heartbeat chạy đúng; applied 6/6 sạch (windows=1, mismatch=0); split=1 đúng ca hỗn hợp; fallback không chạy; không lapse/expired; cơ chế chặn gói xoay có bằng chứng 1 ca trọn vẹn. Khớp báo cáo xe của Nguyen (video phóng to hoàn chỉnh).

## 2) PINCH — KẾT LUẬN: KHÔNG HÌNH THÀNH ĐƯỢC CẶP NÀO; FS CHỈ CÓ LỆNH DIAG VÀ BỊ TỪ CHỐI 100%

### Bảng đếm
| Mục | fs1 (old, tới 15:19) | ytz2 (old 15:19+ + new) |
|---|---|---|
| `[pinch1] recognizer attached` | 5 | 6 |
| `[pinch1] session end` summaries | 3 | 0 |
| Pairs trong summaries | `split complete=0 truncated=0, expanded complete=0 truncated=0` (cả 3) | không có summary |
| `wouldPinch=1` (probe phía app) | **0 / 105 bản ghi** | **0 / 19 bản ghi** |
| FS expand/restore TỪ PINCH | 0 | 0 |
| Lệnh `[fs-diag]` ON | — | 5 (15:29:03→15:29:46 ×4 + 15:39:09 ×1) |
| Kết quả expand diag | — | **từ chối 5/5**: `reason=tray` ×4, `reason=inactive` ×1 |
| Restore diag | — | từ chối `state=SPLIT` (chưa từng expand nên không có gì để restore — đúng) |

### Bằng chứng bổ sung
- `[probe] began` phía CarPlayApp: **38 lần** (25 old + 13 new), phân bố theo ô: native — Maps ×10, GOFA ×6, Music ×7; hosted — YouTube ×7, Ame ×2, Facebook ×1. → Tầng CarPlayApp THẤY Began trên cả ô native lẫn hosted (dữ kiện W4), nhưng recognizer trên container KHÔNG ghép được cặp nào từ các chạm đó (mọi summary pairs = 0; app-side probe 124/124 bản ghi là dãy đơn ngón, `wouldPinch=0`).
- Cờ pinch trong gói state: mọi dòng `bw emit` đều `pinch=0`, `pm=1` (DRY_RUN theo P4) — kể cả khi có cặp, chế độ Đo cũng chỉ ghi log, không bắn. Từ "disposition"/"BlockedHidden" KHÔNG xuất hiện trong log (0 dòng) — đường pinch không đi tới tầng phân xử; nó chết ở tầng hình thành cặp.
- Ca 15:39 (file new): diag ON bị `reason=inactive` — phiên split không active tại thời điểm đó (sau các lần ngắt/nối), khớp trạng thái phiên đã teardown.

**Kết luận câu 2:** Lý do chặn chính KHÔNG phải BlockedHidden/allowlist/mode — mà là **recognizer không hình thành được cặp hai ngón nào** trong cả hai cửa sổ (0 pair/124 bản ghi app + 0 pair ở mọi summary container), cộng thêm pm=DRY_RUN (pinch=0) theo thiết kế P4. FS controller chưa từng expand thành công trong cả phiên: 5/5 lệnh diag bị từ chối (tray đang mở ×4 — Nguyen gạt công tắc lúc tray/picker còn mở; inactive ×1). Khớp báo cáo xe "công tắc fullscreen không hoạt động" — kênh pref→controller SỐNG (lệnh tới, có log), điểm chết là cổng từ chối `tray`.

## 3) WEATHER — KẾT LUẬN: ĐẠT TIÊU CHÍ GPT (perm=0 → fallback; không kẹt in-flight; mọi transaction kết thúc đúng 1 lần)

### Bảng 10 transaction (8 old + 2 new, tất cả đều là SpringBoard cache-warming khi khởi động)
| # | Mốc | Location status | Nhánh | Kết thúc |
|---|---|---|---|---|
| 1 | 13:56:46 | 0 | fallback: vị trí app dẫn đường (1 phút) | updated 1.1s, http 200 |
| 2 | 14:30:07 | 0 | fallback (34 phút) | **failed 3.0s, http 0, timeout** |
| 3 | 14:33:15 | 0 | fallback (37 phút) | updated 1.0s, http 200 |
| 4 | 14:40:07 | 0 | fallback (1 phút) | updated 1.0s, http 200 |
| 5 | 15:16:11 | 0 | fallback (0 phút) | updated 1.3s, http 200 |
| 6 | 15:27:43 | 0 | fallback (0 phút) | updated 1.1s, http 200 |
| 7 | 15:31:57 | 0 | fallback (0 phút) | updated 1.1s, http 200 |
| 8 | 15:33:06 | 0 | fallback (0 phút) | **failed 3.0s, http 0, timeout** |
| 9 | 15:37:44 | 0 | fallback (0 phút) | updated 1.1s, http 200 |
| 10 | 15:39:32 | 0 | fallback (0 phút) | updated 1.1s, http 200 |

- Quyền location: **status 0 ở cả 10/10** — nhánh fallback (dùng vị trí cached của app dẫn đường) chạy 10/10, đúng tiêu chí "permission=0 → fallback".
- In-flight kẹt: **KHÔNG**. Sau mỗi failure (14:30, 15:33), transaction tiếp theo hoàn thành updated bình thường — cờ in-flight tự nhả.
- Kết thúc đúng một lần: 10 bắt đầu (`warming the cache`) ↔ 10 kết thúc (8 updated + 2 failed), không transaction nào treo hay kết thúc hai lần. Hai failure là timeout mạng http 0 ở 3.0s — timeout có hiệu lực (không phải 10s như bản lỗi cũ), tự kết thúc sạch.
- Nhiệt độ/gradient: **KHÔNG CÓ TRONG LOG** — log chỉ ghi `updated (http 200)`, không ghi giá trị nhiệt độ hay cặp màu gradient; không kết luận được phần hiển thị từ log.
- `SSAnswerWeatherRequest`/đường answer phía xe: **0 dòng trong cả hai file** — build này không log riêng đường answer; phần đo được là đường fetch SpringBoard ở trên.

## 4) NÚM — KẾT LUẬN: LOG KHÔNG CHỨA PAYLOAD publishKnobsNow — KHÔNG KẾT ÁN ĐƯỢC TỪ LOG

- `publishKnobs` / payload `scaled=`: **0 dòng** trong cả hai file. Từ vựng log của build này KHÔNG ghi payload núm gương (scaled/active). Các đếm `active=1/active=0` (256/142) thuộc dòng `[probe]` (trạng thái phiên split), không phải núm.
- Mọi dòng chứa "knob" (67 old + 19 new) đều là AutoHide: cặp `host knob fade applied` ↔ `host knob fade restored` — luôn đi cặp, không có applied nào thiếu restored tương ứng trong các đoạn đã trích; `fade last=hostknob idle=4.00` là mốc nguồn activity.
- Hệ quả: câu hỏi "núm gương có kẹt active=1 khi transform identity không" — **log không có dữ kiện**; cần hoặc instrument thêm ở vòng sau, hoặc chấm bằng quan sát xe (mục núm trong kịch bản). KHÔNG suy diễn từ dữ kiện fade.
