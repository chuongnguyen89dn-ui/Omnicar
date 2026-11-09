# S4 — PINCH: giải phẫu điểm chết (hl2, chỉ-đọc)

Nguồn: `OmniCar.log`+`.old` (liền nhau, không trùng dòng [pinch2];
gid=1/37370 bị cắt ở ranh giới xoay file). Đơn vị đếm = (process,
gid): YouTube 37317 gid1–46 + 37370 gid1–119 = **165 cặp**, tất cả
trong YouTube hosted. TikTok: attached ×2, **0 cặp**.

## 1–2. Bảng attempt → kết cục (165 cặp)

| Tầng chết | Số | Bằng chứng |
|---|---|---|
| Chết lúc hình thành cặp — `blocked reason=stale` | 63 | state=V58/H3/I2 (vd 22:20:02.005 gid13–16 stateSeq=612) |
| Chết lúc hình thành — `blocked reason=state` (state=U) | 2 | 22:25:59.472 gid101, .997 gid102 |
| Qua formation (`began`) | 100 | committed=split 98, expanded 2 |
| → `cancelled wrong-dir` | **76** | ratio 0.728–0.900, TẤT CẢ committed=split |
| → `cancelled committed-flip` | 2 | cả 2 cặp committed=expanded (mục 4) |
| → `cancelled stale` | 1 | 22:20:07.638 gid21 ratio=0.974 |
| → began rồi mất hút (không terminal log) | 4 | 37317 gid22/23/24 (22:12:36–39), 37370 gid100 (22:25:54.725) |
| → `recognized dir=1` (out) | 17 | ratio 1.104–1.349, TẤT CẢ committed=split |
| →→ owner `reject badstate` | 13 | vd 22:13:00.429 gid35; 22:25:47.134 gid83 |
| →→ owner accept → FS | **4** | mục 3 |

Ô yêu cầu mà log hl2 **không hề phát** (0 dòng): drift, degenerate,
kb-block, hidden-block (split-hidden), owner-reject khác badstate,
FS từ chối (`applied=0`=0). Drift nếu có chỉ nằm trong 4 cặp "mất
hút" — log hl2 không có pair-end nên không tách khỏi tan-dưới-ngưỡng.

## 3. Bung THÀNH CÔNG: log có 4, không phải 1–2

Cả 4 trọn đường began→recognized→accept→`expand applied=1`→
`[fs1] fs expand confirmed provenance=pinch`, d0 đều nhỏ (76–89):

1. 22:05:10.377 began gid5/37317 d0=78.5 → .438 recognized 1.185
   → .442 accept slot=1 SPLIT → .455 applied + confirm txn=1.
2. 22:12:51.855 began gid25 d0=80.9 → .911 recognized 1.190 →
   .913 accept → .921 applied + confirm txn=3.
3. 22:18:39.930 began gid1/37370 d0=76.0 → 22:18:40.002
   recognized 1.118 → .006 accept → .027 applied + confirm txn=1.
4. 22:25:15.931 began gid54 d0=89.0 → .980 recognized 1.213 →
   .983 accept → .986 applied + confirm txn=3.

Trước = SPLIT (owner khớp); sau = FS EXPANDED thật, nhưng
app-side KHÔNG cập nhật tương ứng (mục 4).
Tỉ lệ: 165 cặp → 4 bung = **41 cặp/lần**; began→recognized 17%;
recognized→accept 4/17 (13 relay bị badstate vì FS đã expanded).

## 4. Thu (pinch-in): chết ở recognizer, 0 ở mọi tầng sau

- `recognized dir=2` = **0**; relay dir=in = 0; owner restore = 0;
  FS restore provenance=pinch = 0 (restore chỉ teardown ×2, diag ×1).
- Thu KHÔNG thiếu attempt: 76 cặp wrong-dir có hình học thu rõ —
  d0 trung vị 312.4 (min 157.6), ratio co xuống ≤0.900. Đối chiếu:
  17 cặp recognized có d0 ≤121.9 (đặt gần, xoè ra). Hai nhóm tách
  bạch hoàn toàn theo d0.
- Nhưng **cả 76/76 cặp thu đều nằm trong cửa sổ FS đang EXPANDED**
  (4 cửa sổ: 22:05:10–22:07:21, 22:12:51–22:15:48,
  22:18:40–22:25:03, 22:25:15–hết log) mà committed vẫn ghi
  `split` → dir khoá = out → cử chỉ thu bị xử `wrong-dir`.
- Trong các cửa sổ expanded: 93 began, chỉ **2** mang
  committed=expanded, **91** mang committed=split (state=V). Tức
  snapshot app-side gần như không bao giờ phản ánh EXPANDED.
- 2 cặp expanded duy nhất (đều EXPANDED + chrome mờ state=H):
  gid29 22:21:02.793 d0=87.3 → cancelled committed-flip sau 39 ms,
  ratio=1.000; gid49 22:24:44.598 d0=108.2 → committed-flip sau
  21 ms, ratio=1.000. Chết trước khi kịp dịch chuyển — committed
  lật ngay đầu cử chỉ. Attempt H khác: blocked stale ×3
  (22:05:09.708 gid4, 22:19:27.814 gid6, 22:21:50.635 gid40).

## 5. Đối chiếu verdict miệng §29.15

- "Rất nhiều lần mới bung được": ĐÚNG theo số — 165 cặp/4 lần
  (2,4%); cộng thêm 65/165 (39%) chết stale ngay khi đặt ngón 2.
- "Bung tổng 1–2 lần": log ghi **4** expand confirm (2/đời app)
  — miệng đếm thiếu; log là chuẩn.
- "Thu 0 lần": ĐÚNG tuyệt đối — 0 ở tầng recognized, không phải
  0 ở owner/FS. Thu chết 100% tại recognizer.

## Kết luận — tầng nghẽn chính

1. **Nhãn committed app-side không theo FS thật** (nghẽn quyết
   định cho thu): FS expanded mà 91/93 began vẫn split → dir-lock
   biến mọi cử chỉ thu thành wrong-dir (76) và mọi cử chỉ bung
   thừa thành relay bị owner reject badstate (13).
2. **Freshness lúc formation**: blocked stale/state = 65/165
   (39%) — điểm chết lớn nhất theo số lượng cho cả hai hướng.
3. Owner + FS adapter KHÔNG nghẽn: accept 4/4 applied + confirm,
   reject 13/13 đều badstate đúng sự thật (đã expanded).
