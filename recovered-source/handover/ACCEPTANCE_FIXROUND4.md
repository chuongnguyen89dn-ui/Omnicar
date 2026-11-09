# ACCEPTANCE — fixround4 (bản FAT từ CI macOS)

Mọi số liệu dưới đây đo trên CHÍNH file được giao, không lấy từ
candidate local hay biên bản của các vòng trước.

## Định danh bản giao

- File: `com.anlai.omnicar_1.0.3-rebuilt-fixround4-fat_iphoneos-arm64.deb`
- Kích thước: 1.157.608 byte
- SHA-256: `6ab47eab81e0aae9d31e3995e093b139ab6c4a76cc1ec84e58298dc8df34b349`
- Package: com.anlai.omnicar, Version (control trong DEB): 1.0.3,
  Architecture: iphoneos-arm64; member control.tar.gz + data.tar.lzma.
- CI: workflow build-fat-macos.yml (id 410962367), run **42550858598**
  (workflow_dispatch), conclusion **success** (truy vấn API trực tiếp),
  head ci-fat-test `cc678e3`; nguồn main `89981a9` (fixround4 đầy đủ
  gồm nhóm N7–N14).
- Ghi chú thay thế: hai run 42549096386 + 42549107670 đã dispatch
  trên cây CHƯA có N7–N14 (main 84cd742) — artifact của chúng bị
  thay thế, không dùng. Run push-triggered 42550844340 trên cùng
  SHA cc678e3 cũng không dùng; bản giao lấy từ run dispatch trên.
- Provenance: candidate local
  `com.anlai.omnicar_1.0.3-rebuilt-fixround4_iphoneos-arm64.deb`,
  974.398 byte, SHA-256
  `fffbf0216f45437cd4ceaa2323fce2056dc97272d225445ac8584747f36c935b`
  (chỉ để truy vết; các cổng kiểm tra tĩnh của vòng — A–I, N1–N6,
  N7, N8, N10–N14, splash, marker — đã chạy lại toàn bộ trên
  candidate này, xem PATCH_NOTES §18 + §18 bổ sung).

## UUID từng slice (đo trên bản FAT)

Cả 8 binary đều FAT arm64 (subtype 0x0) + arm64e (subtype
0x80000002, PAC00), min iOS 15.0 theo cây nguồn.

| Binary | arm64 | arm64e |
|---|---|---|
| OmniCar (app) | 37996BCC-9D75-3F82-972B-13BDFE30567B | BFDB0289-AD13-38E5-A899-56D1B9B21458 |
| OmniCarPrefs | EC71C2E6-60AA-34C3-A882-1BE355B76EA2 | 5303865E-2DBA-3749-9E67-82CC12AD128D |
| OmniCarAppBridge.dylib | 654F9FBB-F093-38D3-A0BB-95B874E373D9 | 1F5FEDD9-DC6E-34D8-898F-50C6DD39224B |
| OmniCarCarProbe.dylib | 4016A4A4-857F-3B21-BDF7-577AF2363AE5 | 8FBCF0C9-2843-32D6-B8A6-C29AFC6D8456 |
| OmniCarCore.dylib | A75F7B89-2A76-3972-B19C-A8DEC93912C9 | ADA5CEBB-B3E9-39FE-ACFA-AACE6D14F8AC |
| OmniCarSpeedBubble.dylib | 13C9A88D-D5BB-34C1-97E9-8778350234A2 | B3E559FD-950F-38B7-A5E3-5F178F50584D |
| OmniCarSplitScreen.dylib | D535E0CB-9995-308C-B469-23B7E33CC70B | 705024F9-5122-3377-9B28-1B25D96744C3 |
| OmniCarStartupScreen.dylib | 2BE0AFDF-8E4A-36EB-8493-08ADF3A15476 | 0D65DFF0-1FC9-35D0-A0E3-80A685A5F340 |

## Marker build [fixround4] (đo trên bản FAT, có ở cả hai slice)

- SplitScreen: `loaded into CarPlay [fixround4]`
- Prefs: `[GPT-F] specifiers build [fixround4]: controller=%@ total=%lu features=[%@]`
- AppBridge: `build %s (%s) loaded into %@ [fixround4]`

## Trạng thái

DEVICE_TEST = PENDING. Bản này đã sửa và build — chưa được gọi là
hoàn thiện cho tới khi nghiệm thu trên xe theo kịch bản gộp một
phiên (PATCH_NOTES §18): icon độc lập hosted + native, solo
mở/giữ/đổi, Maps/Waze/GOFA vào hai ô có nội dung + chạm thật,
chuyển app giữa ô, swap lúc pending, hủy/timeout loader kết thúc
rõ, thanh "..." trên ô native VÀ ô hosted (chuỗi hosted nếu còn
chết đã có instrumentation [do] + log gốc khôi phục để log chỉ
đúng mắt gãy), menu tỉ lệ mở và ở lại sau một chạm núm, splash
chế độ Lời chào chỉ có phần tử lời chào. Log + .ips (nếu có) up
vào `logs/` của repo sau phiên.
