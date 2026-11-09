# ACCEPTANCE — fixround5 (bản FAT từ CI macOS)

Mọi số liệu dưới đây đo trên CHÍNH file được giao, không lấy từ
candidate local hay biên bản của các vòng trước.

## Định danh bản giao

- File: `com.anlai.omnicar_1.0.3-rebuilt-fixround5-fat_iphoneos-arm64.deb`
- Kích thước: 1.158.270 byte
- SHA-256: `03010edc13f314356493f703d867cc93693476f5bba953e5e20c556e90e30d02`
- Package: com.anlai.omnicar, Version (control trong DEB): 1.0.3,
  Architecture: iphoneos-arm64; member debian-binary +
  control.tar.gz + data.tar.lzma.
- CI: workflow build-fat-macos.yml (id 410962367), run **42556431536**
  (workflow_dispatch), conclusion **success** (truy vấn API trực
  tiếp), head ci-fat-test `8680bec`; nguồn main `860c8b6`.
- Nội dung vòng 5 (PATCH_NOTES §19): C-A cực điều kiện + C-B alpha
  trong `-[ABHost setBarVisible:pop:dim:single:forApp:]` phía host
  (thanh "..." của app hosted không hiện ở fixround4 dù trạng thái
  đã mở — chuỗi chạm minh oan 73/73 bằng log); playIntro phía xe
  khôi phục đủ 3 nhánh logoEffect; playIntro phía PREFS khôi phục
  theo dump @0x493a4 gồm cả đuôi !logoView (bảng ivar Prefs ánh xạ
  được, khác phía xe).
- Provenance: candidate local ship
  `com.anlai.omnicar_1.0.3-rebuilt-fixround5_iphoneos-arm64.deb`,
  974.214 byte, SHA-256
  `146e26572fbd040de4bc0e5dee1429a00cbe166d0152ab3a9cde5d22d0a51437`
  (chỉ để truy vết; candidate lượt 1 `bf1a1438…` bị thay thế vì
  build trước khi fix Prefs đáp). Cổng tĩnh trên candidate ship —
  đo trên binary trích từ chính candidate: (a) host-bar ĐẠT,
  (b) playIntro xe ĐẠT, (b2) playIntro Prefs ĐẠT, (c) marker ĐẠT,
  (d) hồi quy ĐẠT — tổng 29/29 (PATCH_NOTES §19.6). Đây là
  'đã kiểm tra tĩnh', không phải PASS hành vi.

## UUID từng slice (đo trên bản FAT)

Cả 8 binary đều FAT arm64 (subtype 0x0) + arm64e (subtype
0x80000002, PAC00), min iOS 15.0 (LC_BUILD_VERSION, đo trên
slice SplitScreen đại diện và khớp cây nguồn).

| Binary | arm64 | arm64e |
|---|---|---|
| OmniCar (app) | B5E91DE5-FB61-387A-8E24-30BCD4A99B7E | 984CAF39-57DE-3088-8CC5-51C8BF0E6E31 |
| OmniCarPrefs | 2B966BC6-2048-384B-8FE0-DE652B1AF5AE | 2BEDED02-EF12-3E1D-899D-A2B75A01567C |
| OmniCarAppBridge.dylib | 963AFDD8-DBF0-31F1-84BC-471111737F13 | 96D3ED4C-D06E-30F6-96B0-EB7CCC77BB5E |
| OmniCarCarProbe.dylib | 5995AF85-01E6-3478-8DF1-6D7BD57197C7 | B1730B51-A5A0-387A-A11F-557F65680168 |
| OmniCarCore.dylib | 508B0D48-B240-3886-AAFD-BEBBEEAB5916 | 713FCC2D-3AF8-36E5-9CBA-EDEB3DBCA3C3 |
| OmniCarSpeedBubble.dylib | 0326094F-416C-35FD-A6CF-833E3F1E13ED | 2C1F1ABA-55B7-337C-89FC-5652848ACF54 |
| OmniCarSplitScreen.dylib | 2D8ECB8B-D6B2-357C-A4D3-40711518D30B | 81A973C9-A312-3434-B962-9DDDBDBFD4C2 |
| OmniCarStartupScreen.dylib | 659DE610-1F9A-310D-88F6-5155512AFBFA | E710B151-D4C5-337B-98C3-12C220CE9CDA |

## Marker build [fixround5] (đo trên bản FAT, có ở cả hai slice)

- SplitScreen: `loaded into CarPlay [fixround5]`
- Prefs: `[GPT-F] specifiers build [fixround5]: controller=%@ total=%lu features=[%@]`
- AppBridge: `build %s (%s) loaded into %@ [fixround5]`

## Còn mở (không thuộc nghiệm thu vòng này)

- Đuôi !logoView của playIntro phía XE (slot ivar 0xcb0/0xcc0/
  0xcc8 chưa ánh xạ chắc) — vòng branch-fidelity riêng
  (PATCH_NOTES §19.6).
- Phần tử tròn ở mép phải màn hình (ảnh phiên fixround4) —
  chưa định danh được từ log; không sửa máy trạng thái bong
  bóng khi chưa đủ căn cứ.

## Trạng thái

DEVICE_TEST = PENDING. Bản này đã sửa và build — chưa được gọi là
hoàn thiện cho tới khi nghiệm thu trên xe theo kịch bản gộp một
phiên, trọng tâm: (1) thanh "..." trên ô HOSTED (Facebook / Nuvio
/ TikTok) hiện đủ 5 nút, chạm lần hai ẩn đúng cơ chế toggle của
gốc, chạm ngoài dismiss; thanh ô native giữ nguyên; (2) splash
Lời chào: hiệu ứng mở đầu không còn quầng trắng ghi chết, logo
bung theo đúng nhánh logoEffect đang chọn; bản xem trước trong
Cài đặt (Prefs) chạy cùng hiệu ứng; (3) hồi quy: menu tỉ lệ từ
núm vách ngăn, panel bố cục + popup chọn app giữ ô đã chọn, swap
hai ô, loader hủy/timeout dọn sạch. Log + .ips (nếu có) up vào
`logs/` của repo sau phiên.
