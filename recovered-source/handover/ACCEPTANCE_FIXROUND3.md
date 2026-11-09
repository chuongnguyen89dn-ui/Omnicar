# ACCEPTANCE — fixround3 (bản FAT từ CI macOS)

Mọi số liệu dưới đây đo trên CHÍNH file được giao, không lấy từ
candidate local hay biên bản của các vòng trước.

## Định danh bản giao

- File: `com.anlai.omnicar_1.0.3-rebuilt-fixround3-fat_iphoneos-arm64.deb`
- Kích thước: 1.151.806 byte
- SHA-256: `77230019b2a4bf3b89f213ca2b6489a5f290555e3e012eb2a8fe9a069afdcc50`
- Package: com.anlai.omnicar, Version (control trong DEB): 1.0.3,
  Architecture: iphoneos-arm64
- CI: workflow build-fat-macos.yml (id 410962367), run **42543315243**,
  conclusion **success** (truy vấn API trực tiếp), head ci-fat-test
  `0cb4bb67b6c0602f04e8dbe16385fd6d12881440`; nguồn main
  `3202cb8ca523cf8ed30fe2ec4f0283738e61075d`.
- Provenance: candidate local
  `com.anlai.omnicar_1.0.3-rebuilt-fixround3_iphoneos-arm64.deb`,
  970.286 byte, SHA-256
  `752e39118354563cf65d4882a379619a70a634f274b8bfe05522cbbee16ae07a`
  (chỉ để truy vết; mọi cổng dưới đây chạy trên bản FAT ở trên).

## UUID từng slice (đo trên bản FAT)

| Binary | arm64 | arm64e |
|---|---|---|
| OmniCar (app) | 90E317EC-B3A9-35C1-9105-01C6B1EE1A7F | AE1FAB20-22BE-3260-ADC5-B01B7D4AEEAB |
| OmniCarPrefs | 3FDE39B6-1C58-3995-9CDF-DB86DEACBA2E | FBFB1FAD-F17E-318E-9A2E-81F59C8AF665 |
| OmniCarAppBridge.dylib | 4604C341-5ACC-335D-BB9E-6263D366EDAC | B1BDE707-496E-325D-B480-E2554E131CB7 |
| OmniCarCarProbe.dylib | AC299C28-E3B0-3D91-845B-2036102E239E | B3721EE1-3690-34E3-8CFB-22A57982D295 |
| OmniCarCore.dylib | 1996A4D8-85A1-3E2B-9412-4B66D903EC82 | E0B91625-022C-3FB9-B47B-06E7F9F060C8 |
| OmniCarSpeedBubble.dylib | 61555933-4047-30C4-B975-6DA00E8214F1 | 0D053D90-326F-3EBA-81D0-06EAD82A5A46 |
| OmniCarSplitScreen.dylib | D4FE6696-E695-39CE-99B4-080003772957 | 7547F32C-F8D7-3F26-8616-DD3A5F1EF3E5 |
| OmniCarStartupScreen.dylib | AF15B807-85ED-370F-9559-E537E6DA21EE | B9C89533-60B0-37F8-BB56-047ED8726D6D |

## Kết quả cổng kiểm trên bản FAT (kiểm tra tĩnh)

| Cổng | Kết quả |
|---|---|
| lipo: đủ arm64 + arm64e ở cả 8 Mach-O | ĐẠT |
| Thành viên DEB: control.tar.gz + data.tar.lzma | ĐẠT |
| Version trong control = 1.0.3 | ĐẠT |
| paneSize encoding `B32@0:8^{CGSize=dd}16@24` (SplitScreen, cả 2 slice) | ĐẠT (×1/slice) |
| homePressedDuringSplit encoding `v20@0:8B16` (cả 2 slice) | ĐẠT (×1/slice) |
| Marker CarPlay `loaded into CarPlay [fixround3]` (cả 2 slice) | ĐẠT (×1/slice) |
| Marker Prefs `specifiers build [fixround3]` (cả 2 slice) | ĐẠT (×1/slice) |
| `isDescendantOfView:` trong SplitScreen (cả 2 slice) | ĐẠT (×1/slice) |

Các cổng tầng sâu của vòng (applyUnit không còn arrayWithObjects:count:,
thứ tự hook Home bằng disassembly, bốn ma trận truy vết, parity selector
61/66 với 0 selector thiếu) ghi ở PATCH_NOTES §17 + §17G — tất cả là
"đã kiểm tra tĩnh", KHÔNG phải PASS hành vi. Sổ P2 (GPT §8): cả 6 mục
P2-A…P2-F đều ĐÃ SỬA (chi tiết §17G mục G7).

## Điểm còn mở sau vòng G (không chặn bản giao)

- P2-E quan sát dispatch ss_drawCanvas (gate bằng ivar BOOL + 2 ivar
  object thay vì proxy _sceneStyle) — để vòng fidelity, chưa kết tội.
- Factory nhãn Prefs SSStartupView.m:147-148 [INFERRED placement] — chờ
  bằng chứng dump Prefs riêng.
- Phần kẹp bề rộng theo bounds khi maxWidth ≤ 0 ở ss_label phía Prefs
  (ngoài phạm vi ghi chú D6) — chưa đụng.
- Mọi ma trận ở §17G là "đã kiểm tra tĩnh"; hành vi thật chờ phiên test
  xe gộp theo tiêu chí nghiệm thu §17 + GPT §10.

## Nghiệm thu thiết bị — MỘT phiên gộp (DEVICE_TEST = PENDING)

1. Trang Khởi động trong Cài đặt mở đi mở lại không văng; thử các style.
2. Facebook/GOFA/Waze vào được hai ô, có nội dung và chạm được; đổi app
   trong từng ô; thanh nắm "..." của ô hiện và mở được thanh 5 nút.
3. Hủy loader bằng nút X ở CẢ HAI ô; chờ qua timeout — loader biến mất,
   không chồng picker lên app đã có VC.
4. Chạm ô trống mở picker; chọn app từ khay; kéo divider; đóng/mở lại
   split; bấm Home rồi mở lại — không còn lớp solo/loader cũ.
5. Mở một app NGOÀI split: frame/safe-area gốc được giữ nguyên.
6. Splash: ngắt/kết nối lại CarPlay; dòng "Sức mạnh của CarPlay" đúng
   cỡ và đúng vị trí; hàng "Hiện trong bảng" hiện hai chip Gần
   đây/Yêu thích.
7. Sau phiên: up OmniCar.log + mọi .ips mới lên repo logs/, đọc theo
   marker [fixround3] và UUID ở bảng trên.

"Chỉ hiện biểu tượng đang tải" KHÔNG tính là đạt. Bản này chỉ được gọi
là "đã sửa và build"; "hoàn thiện" chờ kết quả phiên test trên xe.
