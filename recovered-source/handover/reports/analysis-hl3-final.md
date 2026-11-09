# PHÂN TÍCH PHIÊN HL3 — ĐỐI HOÀ (bản hl3, SHA deb 6fe29160)

Nguồn: OmniCar.log.old (đoạn hl3 từ dòng 6701, 06:26:34.436) + OmniCar.log (toàn bộ) = **6.891 dòng hl3, 06:26:34 → 06:37:43, không mất đoạn** (vết nối xoay log khớp tuyệt đối tại 06:36:03.490; file .log 109 KB chỉ là đoạn cuối phiên sau điểm xoay — không phải phiên riêng). 5 biên bản strand: analysis-s1-wake.md, analysis-s2-pinch.md, analysis-s3-picker.md, analysis-s4-kb.md, analysis-s5-frame.md. Mọi số đếm bằng grep trên file gốc; nhãn so với verdict miệng §29.21.

## (a) VERDICT TỪNG MỤC

**1. Wake / nuốt YouTube — LOG-CONFIRMED (ĐẠT, kèm 1 vết ở vòng ack).** 12 ca nuốt thật `bw nuot day` trên YouTube (PID 37993 ×5, 37999 ×3, 38003 ×4); cả 12/12 khớp phía owner cùng mili-giây: HIDDEN->VISIBLE + trial packet wm=ENFORCE. Quyết định cổng: 74/74 probe `dsrc=local-push`; wouldSwallow=1 chỉ khi state=H (V: 0/50, kbActive=1: 0/5). **Nuốt nhầm = 0 ca** theo tiêu chí (11/12 ca nối được probe đều H + kbActive=0 + trong YouTube; 1 ca thiếu dòng probe — lỗ hổng log, không phải nuốt nhầm; nuốt ngoài YouTube = 0). Vết: ack chỉ sạch ở PID YouTube đầu (5/5, 4–18 ms); 7/12 ca ở hai PID re-host sau bị `bw ack timeout` 1,6–1,8 s rồi fail-open sang state kế tiếp — host đã VISIBLE nên kết quả wake không bị undo.

**2. App hosted khác — LOG-CONFIRMED (trial scope).** 5 ca wouldSwallow=1 bị giữ ở DRY_RUN (wm=1), toàn bộ Facebook, đều H + kbActive=0 — sẵn sàng cho mở rộng. TikTok: 3 ca H bị failopen=pinchin (nhường pinch, đúng thiết kế); GOFA không có probe phía app.

**3. Pinch — LOG-CONFIRMED triệu chứng (bung 1 / thu 0 / khó dùng); giả thuyết "lớp trọng tài giết pinch" CONTRADICTS như nguyên nhân chính.** Census toàn phiên (FULL): 34 cặp hình thành → 8 blocked (toàn bộ `kbunknown`; reason khác = 0 từng loại), 26 recognized (toàn bộ dir=1, ratio=1.000), owner accept 1, **owner reject 25 — toàn bộ `badstate`**, FS expand applied do pinch = 1, restore do pinch = 0. Chết-tại-trọng-tài 23,5% (STRICT theo PID đề bài: 31,8%); chết tại owner 73,5%; trong số cặp qua được trọng tài, owner giết 96,2%.

**4. Phím native + kbstate — LOG-CONFIRMED (khoá cứng giữ; chuỗi KHÉP; L8 hiệu quả).** `native-locked-hl3` ×13, drawn = 0 lần. Episode ACTIVE thật: YouTube search ×2, Facebook search ×1. kbstate accept 493 / reject 12 — **reject toàn bộ noassignment (291 ở hl2 → 12, −95,9%)**; badgen/badsession/staleseq/badhash = 0; seq không đứt. AutoHide: 6 lần fade deferred vì kb, **0 lần fade trong cửa sổ kb ACTIVE**.

**5. Picker — NO-DATA kết án (measure2 vẫn thiếu trường quyết định).** 5 lần mở (4 hosted, 1 native — mẫu native duy nhất là GOFA, log ghi GOFA hosted=0/native, đính chính cách gom nhóm của đề bài). Mọi trường đã ghi giống hệt hai nhóm: picker bg alpha=0 (5/5), trayWin bg alpha=0 (5/5) → cả hai được minh oan ở trường bg; cover = nil; scene alpha/hidden như nhau; hasContent=1 cả 5/5. Ứng viên duy nhất còn đứng là **sheet** (alpha=1, hidden=0) — nhưng bg của sheet không có trong 10/10 dòng đo.

**6. Khung / hồi quy — LOG-CONFIRMED sạch.** 0 crash/exception/fatal. AutoHide: ca thoát-lúc-mờ → mở lại **restored sau 29 ms** (fade 06:31:35.511 → teardown faded=1 → session start 06:31:49.870 → restored 06:31:49.899). FS ngoài pinch: 0 lần thử. YTZ mismatch = 0 (161 dòng). Home icon routed 6/6; dock cũ vắng. Native feed act posted 106 / accepted 106 — **lệch 0** (hl2 lệch 1). SB/CP giữ 1 PID suốt phiên (không tái diễn đổi PID của hl2); YouTube 3 PID do 2 lần re-host có trật tự. Weather/knob: NO-DATA (0 request; chỉ warming-cache).

## (b) DANH SÁCH LỖI ĐẦY ĐỦ

**L1 — Vòng ack của cổng nuốt không khép ở các incarnation YouTube được re-host (7/12 ca nuốt).**
Bằng chứng: 5 ca ở PID 37993 `bw ack seq=` trễ 4–18 ms; 7 ca ở PID 37999/38003 `bw ack timeout seq=` trễ 1.575–1.763 ms (điển hình: `2026-11-10 06:28:55.875 [YouTube:37999] bw ack timeout seq=1: fail-open toi state tuoi ke tiep`) rồi fail-open. Host đã chuyển VISIBLE từ tín hiệu wake nên kết quả gọi logo không hỏng; phần chưa đạt là ack quay về app ở 2 PID sau (PID đầu sạch 5/5). Chưa rõ ack chết ở đường phát phía host, đường nhận phía app sau re-host, hay token đăng ký của incarnation mới.
Tầng: **CHƯA SỬA — cần GPT phán** (sửa đường ack theo incarnation trước hay cùng đợt mở rộng ENFORCE; không chặn mở rộng vì 0 nuốt nhầm — xem mục (c)).

**L2 — Latch trạng thái phía app vẫn tụt sau host tối đa 18 seq (L7 chưa đóng hẳn) + 1 ca H fail-open nghịch thường.**
Bằng chứng: probe YouTube `stateSeq=91` lúc 06:27:33.225 trong khi host đã emit seq=109; phân bố lệch: 25/33 ca lệch 2–8, 3 ca (PID 38003) lệch 12–14, 0 ca lệch âm. Latch không còn veto quyết định nên không ca nào sai kết quả kỳ này; ca fail-open H duy nhất (seq=5, PID 37999, 06:29:03.206, would=0, kb vô tội) có `stateAgeMs=123` — THẤP bất thường so với tối thiểu 812 ms của 11 ca H đã nuốt (nghịch đảo của ca seq=45 stale ở hl2).
Tầng: **CHƯA SỬA — cần GPT phán** (cơ chế bắt kịp seq khi latch tụt; ca stateAgeMs=123 cần truy nguồn flip).

**L3 — Pinch phía YouTube chết 100% tại cổng `kbunknown` của hàm trọng tài cặp (7/7 cặp).**
Bằng chứng: YouTube 37993 hình thành 7 cặp, blocked `kbunknown` cả 7, began = 0; YouTube 37999/38003 không hình thành cặp nào. Cùng phiên, Facebook kb INACTIVE thì cặp qua cổng bình thường — cổng kb của trọng tài là nguyên nhân toàn phần cho pinch-trên-YouTube (app chưa từng có phiên gõ → kb local UNKNOWN → chặn, theo bất biến GPT đặt cho pinch).
Tầng: **ĐANG SỬA ở vòng gỡ trọng tài** (đặc tả dir=0 toggle: recognizer bắn thẳng, không qua ABPinchPairDecision — cổng này biến mất theo cấu trúc).

**L4 — Pinch chiều thu chết 100% tại owner `badstate`: nhãn committed phía app không bao giờ lật sang EXPANDED nên mọi cặp hậu-bung đều bắn dir=1 (bung) và bị owner từ chối đúng.**
Bằng chứng: toàn hl3 **52/52 dòng began+recognized ghi `committed=split`, `committed=expanded` = 0** — kể cả 50/50 dòng sau thời điểm bung confirmed 06:35:47.503. Lần bung duy nhất: Facebook gid=1 (began 06:35:47.467 → accept `state=SPLIT` .481 → `fs expand confirmed txn=1 provenance=pinch` .503). Trong cửa sổ EXPANDED (06:35:47.503 → 06:37:29.518, kết thúc bằng restore provenance=teardown): 14 cặp Facebook gid=2–15, blocked 0, **reject badstate 14/14**; tính cả TikTok: 25/26 recognized toàn phiên bị reject badstate. **0 yêu cầu dir=2 nào từng tới owner** → restore do pinch = 0. Owner/FS vô tội (accept 1/1 applied+confirmed; reject đúng trạng thái thật).
Tầng: **ĐANG SỬA ở vòng gỡ trọng tài** (app không gửi dir nữa; owner lật toggle theo trạng thái FS thật của nó — cơ chế L4 biến mất theo cấu trúc; điều kiện kiểm chứng phiên sau: toggle trong cửa sổ EXPANDED phải ra restore applied, reject badstate trên đường pinch phải về 0).

**L5 — Picker: [picker-measure2] vẫn không kết án được lớp phủ — thiếu đúng các trường quyết định; giả thuyết "tray window nền đặc" bị BÁC ở trường bg.**
Bằng chứng: 5 presented (06:30:48.632 YouTube slot0; 06:31:54.390 GOFA slot1 — native duy nhất; 06:33:27.465 YouTube slot0; 06:35:22.257 Facebook slot0; 06:36:06.504 Facebook slot0): picker bg alpha=0.000 (5/5), trayWin hidden=0 alpha=1.00 frame 640×360 level=1065 **bg alpha=0.000 (5/5)**, cover={nil} (5/5), scene ô đích alpha=1.00 hidden=0 — không trường nào phân biệt hosted/native. Trường THIẾU: (1) **bg của sheet** — vắng ở 10/10 dòng, trong khi sheet là ứng viên duy nhất còn đứng (alpha=1.00, hidden=0, frame 542×242, nằm ở cửa sổ scene gốc CarPlay); (2) bg của scene; (3) class/frame/bg/alpha/hidden của **subview duy nhất của picker** (chỉ có subs=1); (4) trạng thái shield/pshield tại presented (vắng hoàn toàn trong measure2); (5) z-order/level của picker/sheet/scene; (6) mẫu native n=1.
Tầng: **CHƯA SỬA — cần GPT phán** phép đo bổ sung tối thiểu (sheet bg + subview picker + shield tại presented) trước khi sửa bất kỳ view nào.

**L6 — Picker đóng bằng cancel: không có ghi nhận trực tiếp nội dung ô cũ hiện lại.**
Bằng chứng: 2 ca cancel (YouTube 06:30:53.507; Facebook 06:35:46.143) — không teardown/request/attach/scenevis nào sau đóng; bằng chứng chỉ gián tiếp (probe-foreign vẫn gán pane cũ sau +0,60–1,17 s). Dòng close cũng không bắt được lúc sheet biến mất (sheet vẫn alpha=1.00/hidden=0 tại dòng close, cả choose lẫn cancel). Choose thì nội dung bị THAY và có xác nhận trực tiếp (detach-bg/attach/scenevis).
Tầng: **CHƯA SỬA — gộp vào phép đo của L5.**

**L7 — kbstate reporter-stop dừng sớm oan 16/19 lần (tiêu chí "state im lặng > 5 s" bắn giữa assignment đang sống).**
Bằng chứng: reporter-stop ×19 (YouTube 8, Facebook 8, TikTok 3); 16 lần assignment còn sống — accept nối lại sau +0,775 → +11,017 s, seq không đứt; 1 lần rơi giữa episode ACTIVE (06:29:18.671, trong episode search YouTube 06:29:13–06:29:27). Mục tiêu chính của L8 vẫn đạt: reject noassignment 291 (hl2) → **12**, gom 4 cụm ngay sau tháo ô, độ trễ dừng thật 3,954–5,407 s. Nhưng reporter-stop không dùng làm mốc "đã rời ô" được và việc dừng giữa ACTIVE là vết thiết kế.
Tầng: **CHƯA SỬA — cần GPT phán** (chỉ dừng khi có tín hiệu teardown/assignment-loss thật thay vì im lặng 5 s, hay nới ngưỡng).

**L8 — Weather/knob: NO-DATA phiên thứ 5 liên tiếp.**
Bằng chứng: 0 request CarPlay trong 6.891 dòng; chỉ ans#1 warming-cache lúc khởi động (06:26:49.679–06:26:50.877, log tự ghi "NOT a CarPlay request"). Knob chỉ có cặp fade applied/restored 32/32 đi cùng AutoHide, không payload nào.
Tầng: **PENDING theo phán quyết cũ** (không chặn các gói khác, không xoá tiêu chí; cần một phiên vào splash + thao tác núm).

**Đã loại trừ kỳ này (không phải lỗi):** lệch act native feed = 0 (106/106, lỗi lệch 1 của hl2 không tái diễn); đổi PID giữa phiên không tái diễn (SB/CP 1 PID suốt phiên; YouTube re-host ×2 có teardown đàng hoàng); FS refused = 0 nên nhãn snap `trayOverlay` (F6) tiếp tục không có mẫu để kiểm — giữ PENDING, không phải lỗi mới; act drop vì session-inactive không xuất hiện dạng lỗi.

## (c) PHÁN QUYẾT MỞ RỘNG ENFORCE

**Nuốt nhầm = 0 ca. ĐIỀU KIỆN MỞ RỘNG ENFORCE CHO MỌI APP HOSTED: ĐẠT.** Căn cứ: 12/12 ca nuốt đều trong ô YouTube + state=H + kbActive=0; 0 ca nuốt khi VISIBLE; 0 ca nuốt khi kb ACTIVE; 0 ca nuốt ngoài phạm vi trial; 5 ca Facebook wouldSwallow=1 (H, kbActive=0) đang bị giữ ở DRY_RUN chỉ vì wm=1 — chính là dân số đích của mở rộng. Hai điểm kèm theo khi mở rộng: (i) L1 (ack timeout ở incarnation re-host) sẽ nhân lên theo số app — nên sửa cùng đợt hoặc chấp nhận ghi nhận; (ii) 1 ca nuốt (06:32:03.714, txn=2 probe=2) thiếu dòng probe đối chiếu — lỗ hổng log nhỏ, không đổi phán quyết.
