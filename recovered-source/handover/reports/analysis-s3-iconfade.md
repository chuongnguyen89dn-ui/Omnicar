# S3 — ICON + FADE + PHÍM + PINCH, phiên ytz4 (chỉ đọc)

Log: `OmniCar.log.old` + `OmniCar.log`, phủ 16:35:40–**17:44:31 (hết log)**. Mốc A/B 17:48 KHÔNG có trong log → NO DATA phần đó.

## (a1) Cửa sổ 17:41–17:44 — CHƯA PHÂN ĐỊNH (tiêu chí probe-fade-icon §4)

Nguyên văn quyết định:
- `2026-11-09 17:41:07.153 [CarPlay:36057] SplitScreen: [autohide] fade last=home idle=4.00`
- `2026-11-09 17:41:07.159 [SpringBoard:36056] AppBridge: [autohide] host fade applied bundle=com.google.ios.youtube` (sơn handle pane, không phải icon dock — probe §4)
- [homelib] youtube trong cửa sổ chỉ có inject: `17:42:37.339 decision=inject bundle=com.google.ios.youtube` (+`injected=1`); cặp tương tự 17:43:41.217. Fade khác: 17:43:00.268, 17:44:00.030.
- Toàn phiên: `remove*` = **0** (mọi bundle); `injected=0` cho youtube = **0/204**. Không remove/không-inject sát mốc mất → họ thư viện KHÔNG bị kết án, fade chỉ trùng idle; mất icon thuộc tầng hiển thị cell của dashboard — CHƯA PHÂN ĐỊNH, cần instrument riêng.

## (a2) "Gọi logo → icon hiện lại" — log KHÔNG giải thích được

Reveal: `2026-11-09 17:41:00.359 [CarPlay:36057] SplitScreen: [autohide] reveal-applied reason=activity views=5`, kèm `host fade restored bundle=com.google.ios.youtube` (.362) và `bw state ... HIDDEN->VISIBLE` cùng ms. Quanh ±10 s: **0** [homelib], **0** apply-published, **0** DIAG/re-layout dock đi kèm reveal (layout gần nhất 17:41:03.151 `bam nut Split Screen tren dock` — thao tác người dùng).
Đang giả định: dashboard tự layout lại khi cây dock đổi trạng thái hiện/ẩn nên cell được dựng lại lúc reveal.

## (a3) Sau thoát Home — 0 chuyển 1→0

- apply-published cuối: `2026-11-09 17:43:53.935 [homelib] event=apply-published count=0 omni=0` — theo SCPHomeApply.m:319–325 count loại trừ app injected, không đọc được presence của youtube từ đây.
- Mọi chuyển 1→0 của youtube toàn phiên: **0**; decision cuối = `inject` 17:43:41.217.

## (a4) Phân loại A/B lúc thoát — 11 sự kiện, ĐỦ CẢ HAI LỚP

Lớp = fade/reveal gần nhất trước `tat split` (`fade deferred` = chưa mờ); bw state khớp mọi mốc.

- ĐÃ MỜ (5, goHome=0): 16:54:00.200 (fade 16:53:45); 17:40:07.624 (17:39:52); 17:41:11.007 (17:41:07); 17:43:04.001 (17:43:00); 17:44:20.347 (17:44:00).
- HIỆN (6): 17:33:38.362 (reveal 17:33:36); 17:34:06.367 (17:33:36); 17:35:47.890 goHome=1 (17:35:45); 17:36:03.968 goHome=1 (reveal unsuspend 17:36:03.967, trước 1 ms); 17:36:39.738 (17:36:15); 17:38:19.133 (17:38:15).

Khớp báo cáo xe, nguyên văn: `2026-11-09 17:44:20.347 [CarPlay:36168] SplitScreen: CarSplit: tat split (goHome=0)`; `17:44:20.349 [scenevis] going-home bundle=com.google.ios.youtube slot=0 scene=nil attached=0 inHost=1 hidden=0 alpha=1.00 window=1` — lớp ĐÃ MỜ.
Đối chiếu thư viện (tương quan; nhân quả = giả định): lớp ĐÃ MỜ — 4/5 nối bằng PID CarPlay MỚI + inject lại youtube (17:40:27, 17:42:37, 17:43:41; 17:44 log hết trước khi ghi; 16:54 nối config PID mới 16:54:31); lớp HIỆN — 6/6 giữ nguyên PID, 0 dựng lại thư viện. Cả hai lớp 0 remove → khác biệt không ở họ thư viện. Đối chiếu đường thoát: xem (a4+).
ytz3: going-home `16:21:19.322 bundle=com.google.ios.youtube` (+Maps slot=1) = lớp **HIỆN** (fade 16:21:15.619 → reveal 16:21:17.223); ytz3 không có [homelib] → apply-state: NO DATA.
Verdict (a4): A/B được hậu thuẫn về phân loại (sự kiện mất icon 17:44 rơi đúng lớp ĐÃ MỜ); cơ chế mất icon vẫn CHƯA PHÂN ĐỊNH như (a1).

## (b) Phím tự vẽ — ảnh 3 = CHE KHUẤT z-order (PASS theo probe-kb-frame)

9 show/9 hide toàn phiên (host `hien cho`/`an`; [kb-sync] khớp, session 1–9): YT 17:29:12→17:29:15; YT 17:31:18→17:31:24; YT 17:32:24→17:32:34; YT 17:33:52→17:33:54; Ame 17:34:38→17:34:38; Ame 17:35:08→17:35:12; FB 17:35:27→17:35:35; YT 17:37:35→17:37:39; YT 17:38:43→17:38:44. Sau 17:40: 0 lần hiện phím.
Ảnh 2→3, nguyên văn: `2026-11-09 17:32:24.190 [SpringBoard:35973] AppBridge: ban phim xe: hien cho com.google.ios.youtube (kieu 0, phim enter 6)`; `2026-11-09 17:32:34.308 [SpringBoard:35973] AppBridge: ban phim xe: an (com.google.ios.youtube)`; show kế tiếp 17:33:52.718. Giữa hai mốc: 1 hide, **0 show mới** → khung đóng băng tại show → ảnh 3 = cùng khung bị che khuất z-order.

## (c) Pinch [touchset] — 0 ca THẬT; hiệu chuẩn KHÔNG có

- 250 dòng `active=2` = **101 ca**: duplicate **101/101**, THẬT **0**. Duplicate = cùng evB + cùng điểm bắt đầu, một bản đóng băng ở `_UISystemGestureWindow` (245 dòng cặp; 5 dòng bản ghi hai `win=(nil) raw={0,0}`, vẫn cùng evB).
- Mẫu: `2026-11-09 17:44:20.276 [touchset] t=297659.909 ev=297659.897 active=2 [ptr=0xde683d830 win=_UISystemGestureWindow raw={29,319} scr={29,319} pane=none evB=297659.897] [ptr=0xde683c5a0 win=DBStatusBarWindow raw={29,319} scr={29,319} pane=none evB=297659.897]`
- Chuỗi hiệu chuẩn (giữ 1 ngón ~3 s → kéo → 2 ngón giữ ~3 s → tách → chụm, một ô): **KHÔNG** — toàn phiên 0 episode chạm ≥2 s; cửa sổ 17:20–17:40 dài nhất = kéo 0,82 s (slot1 GOFA, 17:37:47); 0 ca 2 ngón thật nên mắt "2 ngón giữ yên" không tồn tại trong log.

## (a4+) Bổ sung phân định theo probe-exit-fade

1. Đường thoát KHÔNG quyết định nào đọc trạng thái mờ: `closeGoingHome:` + hai hook thoát dashboard + họ SCPAppIcons/SCPHomeApply/SCPHomeVisibility chỉ đọc pref + trạng thái cấu trúc. Khôi phục sơn (`ahRestoreAllPainted`) VẮNG MẶT trên đường thoát — chỉ tồn tại ở reveal (`ahRevealBody:`) và ngắt kết nối (`ahSessionTeardown` ← `dashboardInvalidated`).
2. Bất đối xứng tweak-side duy nhất chứng minh được: `SCPSendDashboardEvent(1)` CHỈ gửi khi `closeGoingHome:YES` (SCPCarSplit.m:1771); các điểm vào goHome=NO (hook Home/dismiss của dashboard) KHÔNG gửi — cơ chế hạng 1 của biên bản nguồn.
3. Đối chiếu log ytz4 (goHome × lớp mờ/hiện của (a4)):
   - Thoát-lúc-MỜ ~17:44: `2026-11-09 17:44:20.347 [CarPlay:36168] SplitScreen: CarSplit: tat split (goHome=0)` — lớp ĐÃ MỜ (fade 17:44:00.030). Toàn lớp MỜ: goHome=NO **5/5**.
   - Thoát-lúc-HIỆN đi đường YES: cả 2 lần goHome=1 toàn phiên đều thuộc lớp HIỆN — `2026-11-09 17:35:47.890 [CarPlay:35998] SplitScreen: CarSplit: tat split (goHome=1)` (reveal gần nhất 17:35:45.525) và `17:36:03.968 ... tat split (goHome=1)` (reveal unsuspend 17:36:03.967). Nhưng 4/6 lần thoát lớp HIỆN vẫn goHome=0 → chiều "hiện ⇒ YES" không tuyệt đối.
   - Mức khớp: cơ chế hạng 1 **KHỚP ở hai chiều quyết định** — ĐÃ MỜ ⇒ goHome=NO (5/5, gồm đúng sự kiện mất icon 17:44) và goHome=YES ⇒ đang HIỆN (2/2); **0 phản ví dụ**. Cặp A/B gốc lúc 17:48 nằm ngoài log (hết 17:44:31) → mắt đối tác "thoát-lúc-hiện" của chính cặp đó: NO DATA, không suy.
4. Phát hiện phụ (ghi nhận, KHÔNG kết án): `ahFadedState` rò sang phiên sau — `ahSessionStarted` không reset nó, thoát lúc mờ để `ahFaded=YES` kẹt (chỉ reset ở reveal/teardown). Khiếm khuyết riêng, bán kính chỉ tới chrome (homeButton/handle, `fadedEffective` của BridgeWake) — KHÔNG được kết án là nguyên nhân mất icon.
