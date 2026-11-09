# ACCEPTANCE — fixround7 (bản FAT từ CI macOS)

Mọi số liệu dưới đây đo trên CHÍNH file được giao, không lấy từ
candidate local hay biên bản của các vòng trước.

## Định danh bản giao

- File: `com.anlai.omnicar_1.0.3-rebuilt-fixround7-fat_iphoneos-arm64.deb`
- Kích thước: 1.159.010 byte
- SHA-256: `f2cc8ffe59e15993eb8d8704f712638a8cce6874d3201786c46e8c83daa38133`
- Package: com.anlai.omnicar, Version (control trong DEB): 1.0.3,
  Architecture: iphoneos-arm64; member debian-binary +
  control.tar.gz + data.tar.lzma.
- CI: workflow build-fat-macos.yml (id 410962367), run **42564680212**
  (workflow_dispatch, dispatch đúng một lần), conclusion **success**
  (truy vấn API trực tiếp), head ci-fat-test `ce6f2db`; nguồn main
  `cee2d21`.
- Nội dung vòng 7 (PATCH_NOTES §21): (1) WEATHER TRỌN CỤM —
  đường trả lời phía SpringBoard hết chết ở yêu cầu đầu tiên
  (cổng trạng thái {3,4}, one-shot giữ bằng slot tĩnh mạnh,
  timeout 6s kết thúc đúng một lần — W5a/b/c), cache có
  maxAge 43200 ở cả hai điểm đọc (W1), đường cache temp +
  fallback ghi (W2), parse trả nil khi thiếu nhiệt độ +
  coerce NSNumber-only + cổng HTTP 200 (W3), refresh phía
  CarPlay: cổng {0,1,2} hỏi SpringBoard, retry @[@2,@5] +
  bộ đếm thế hệ, bỏ cuộc gọi completion(nil), apply có
  transition CrossDissolve 0.35s (W4a/b/c), cửa sổ stored
  location 86400s (W6), IP fallback timeout 4.0/4.0 (W7),
  refresh chỉ khi style 3/8 (W8), và gradient theo
  category ở style 3 (đủ bảng màu 16 giá trị — trước đó
  0). (2) Bộ lọc hướng {3,4} ở hook setOrientation phía
  app (ca biên FaceUp; tách bạch khỏi vụ xoay YouTube).
- ĐIỂM NGHIỆM THU BẮT BUỘC (GPT): khi quyền vị trí = 0,
  yêu cầu thời tiết phải đi đúng nhánh dự phòng, không
  kẹt in-flight, yêu cầu tiếp theo vẫn hoạt động; mọi
  nhánh kết thúc giao dịch đúng một lần. Trạng thái:
  cấu trúc đạt + cổng binary đạt (§21.3/§21.5) — CHỜ XE.
- YOUTUBE: điều tra tĩnh ĐÃ ĐÓNG — cơ chế khớp gốc
  (§21.4); VISUAL_ORIGINAL_COMPARISON = PENDING, vòng
  xoay thị giác KHÔNG thuộc mục chấm của vòng này.
- Provenance: candidate local
  `com.anlai.omnicar_1.0.3-rebuilt-fixround7_iphoneos-arm64.deb`,
  975.618 byte, SHA-256
  `f4f84555ede9c239165a4c4edccb158b4fbd36771a1e904dcfc31c4c5cde9e14`
  (chỉ để truy vết). Cổng tĩnh trên candidate — đo trên
  binary trích từ chính candidate: (w-sb) ĐẠT (hàm answer
  dựng 6.0s bằng mov/movk 0x165A0BC00, không còn 10s
  trong hàm; cổng status truy vết phân hoạch {3,4} ở cả
  hai trường hợp có/không last-fix; block timeout nguyên
  dạng sub_a00c — loadWeak + so slot + finish:; hai điểm
  gọi LoadCache đều nạp 43200.0; StoredOrIP có -86400.0
  và fmov 4.0 vào cả hai setter timeout), (w-car) ĐẠT
  (16/16 giá trị gradient; apply có 0.35 + immediate
  0x500000 + transitionWithView; strings retry/bỏ cuộc
  có mặt), (f) ĐẠT (hook setOrientation biên dịch thành
  nguyên dạng gốc `sub #3; cmp #2; csel lo` — truy vết
  3->3, 4->4, 5->0), (h) hồi quy host-bar ĐẠT (guard
  @0xb0f8, entrance block setAlpha: 1.0 trước
  setTransform:), (g1)/(g2) hồi quy hai cổng hướng vòng
  6 ĐẠT (địa chỉ không đổi), (m) ĐẠT (marker [fixround7]
  đủ 3 binary, không còn marker vòng cũ; selector parity
  vs gốc giống hệt baseline vòng 6 ở 3 binary, riêng
  StartupScreen hội tụ thêm đúng 1 selector
  transitionWithView: do W4c). Diff payload vs candidate
  vòng 6: chỉ StartupScreen + AppBridge đổi nội dung,
  SplitScreen + Prefs chỉ đổi byte marker. Đây là 'đã
  kiểm tra tĩnh', không phải PASS hành vi.

## UUID từng slice (đo trên bản FAT)

Cả 8 binary đều FAT arm64 (subtype 0x0) + arm64e (subtype
0x80000002, PAC00), min iOS 15.0 (LC_BUILD_VERSION).

| Binary | arm64 | arm64e |
|---|---|---|
| OmniCar (app) | 8CD2ED58-C58C-33C6-BA4B-00041C18D4E2 | 818DE033-6359-39E8-80FC-5B91BF970167 |
| OmniCarPrefs | F83C9A41-8043-336C-894F-FEAFB213DD77 | 8F221176-2394-3C81-86B5-73BBEFEA772D |
| OmniCarAppBridge.dylib | FA7516CE-99E3-3846-8874-C6AC895E20B9 | 1614CA0A-EFE3-3967-B9EA-012BF09C017C |
| OmniCarCarProbe.dylib | 7BDA69F6-49CF-3B12-9B6A-205D7B1649AB | 8B7C4CB9-C4D8-36A7-8DB7-768AF3B3E200 |
| OmniCarCore.dylib | EDA8C8B7-F42B-32BE-B648-CB83F6D45C4A | 890AAB36-CC28-3B5B-9E7B-066382A2FF0B |
| OmniCarSpeedBubble.dylib | 70B00008-389C-3360-8186-6D53C6F96D57 | 19ADEDAD-E290-3008-A489-5B67173CBBF9 |
| OmniCarSplitScreen.dylib | 8DFB17B6-73BC-3C06-B174-6D6464AAE931 | C63B18AC-672D-3C9C-9B4F-9186797109B4 |
| OmniCarStartupScreen.dylib | 836D96E9-84E9-360D-ADBB-F2B3DDAFAE8B | 6A3B8535-7E44-3B12-A587-8AF774564575 |

## Marker build [fixround7] (đo trên bản FAT, có ở cả hai slice)

- SplitScreen: `loaded into CarPlay [fixround7]`
- Prefs: `[GPT-F] specifiers build [fixround7]: controller=%@ total=%lu features=[%@]`
- AppBridge: `build %s (%s) loaded into %@ [fixround7]`

## Kịch bản nghiệm thu gộp một phiên (trọng tâm Weather)

Chuẩn bị trên điện thoại TRƯỚC khi kết nối xe: mở Cài đặt >
OmniCar > StartupScreen, đặt style hiển thị là kiểu THỜI
TIẾT (style 3 hoặc 8 — kiểu có nhiệt độ/biểu tượng thời
tiết), giữ nguyên quyền Vị trí của OmniCar như hiện tại
(máy đang ở trạng thái quyền 0 — KHÔNG cần đổi gì).

1. Kết nối CarPlay: màn hình khởi động phải CHẠY HẾT và
   tự kết thúc, không treo ở splash. (Đây là điểm nghiệm
   thu bắt buộc của GPT: với quyền vị trí = 0, yêu cầu
   thời tiết phải đi nhánh dự phòng stored/IP, giao dịch
   kết thúc đúng một lần — không còn chết ở yêu cầu đầu
   tiên như các vòng trước.)
2. Ngắt CarPlay rồi kết nối LẠI: splash lần hai cũng
   phải hoàn tất bình thường. (Yêu cầu thời tiết thứ hai
   vẫn hoạt động — kiểm chứng cờ in-flight không kẹt.)
3. Nếu có dữ liệu thời tiết: splash style thời tiết hiển
   thị nhiệt độ + nền gradient theo điều kiện trời (màu
   nền đổi theo category ngày/đêm thay vì giữ một màu cố
   định như trước). Không có dữ liệu cũng chấp nhận được
   nếu splash vẫn kết thúc đúng — phần cần chốt là KHÔNG
   TREO và KHÔNG kẹt cho lần sau.
4. Trả style về Lời chào (greeting) sau khi test xong,
   kết nối lại một lần để xác nhận splash Lời chào vẫn
   như cũ.

Hồi quy (gộp trong cùng phiên):
- Thanh "..." của app hosted (YouTube/TikTok/Facebook):
  bấm núm ba chấm vẫn mở đủ 5 nút như fixround5/6 đã đạt.
- YouTube (hosted) vào/ra fullscreen trong player: đáp
  số hướng trong log giữ nguyên như fixround6 (mask 24
  -> huong 4). Vòng xoay thị giác KHÔNG thuộc mục chấm
  của vòng này — VISUAL_ORIGINAL_COMPARISON vẫn PENDING,
  chỉ phân định khi có footage DEB gốc cùng kịch bản.
- Menu tỉ lệ, swap hai ô, picker chọn app: giữ nguyên
  như các vòng trước.

Log + .ips (nếu có) up vào logs/ của repo sau phiên.

## Còn mở (không thuộc nghiệm thu vòng này)

- Bản sao weather phía Prefs (OMCCommon.m) chưa rà —
  module riêng, cần audit riêng (PATCH_NOTES §21.6).
- Núm vách ngăn publishKnobsNow (§20.5/§21.6): chưa sửa
  — chờ lệnh riêng.
- Đuôi !logoView của playIntro phía XE — vòng
  branch-fidelity riêng.
- cellClass: giữ nhãn CHƯA XÁC MINH.
- VISUAL_ORIGINAL_COMPARISON = PENDING (§21.4).

## Trạng thái

DEVICE_TEST = PENDING. Bản này đã sửa và build — chưa được
gọi là hoàn thiện cho tới khi nghiệm thu trên xe theo kịch
bản gộp một phiên ở trên, trọng tâm: (1) splash style thời
tiết với quyền vị trí = 0 phải hoàn tất không treo ở cả hai
lần kết nối liên tiếp; (2) gradient style 3 đổi theo
category; (3) hồi quy thanh "..." hosted, đáp số hướng
YouTube, menu tỉ lệ/swap/picker giữ nguyên.
