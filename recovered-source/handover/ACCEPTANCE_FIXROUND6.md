# ACCEPTANCE — fixround6 (bản FAT từ CI macOS)

Mọi số liệu dưới đây đo trên CHÍNH file được giao, không lấy từ
candidate local hay biên bản của các vòng trước.

## Định danh bản giao

- File: `com.anlai.omnicar_1.0.3-rebuilt-fixround6-fat_iphoneos-arm64.deb`
- Kích thước: 1.155.606 byte
- SHA-256: `0ce8a4f7a6b7d3403ed95e495db8eabbf6b6c5547881a6b013f6c153ad6afbb9`
- Package: com.anlai.omnicar, Version (control trong DEB): 1.0.3,
  Architecture: iphoneos-arm64; member debian-binary +
  control.tar.gz + data.tar.lzma.
- CI: workflow build-fat-macos.yml (id 410962367), run **42560546579**
  (workflow_dispatch), conclusion **success** (truy vấn API trực
  tiếp), head ci-fat-test `7aaaa76`; nguồn main `278129f`.
- Nội dung vòng 6 (PATCH_NOTES §20): cổng suy hướng bit-2 bị đảo
  ở CẢ HAI phía đã sửa về đúng gốc — phía host
  `-[ABHost appWithHash:changedOrientation:supportedMask:]`
  (lệnh quyết định của gốc: arm64 0xf864 / arm64e 0x100b8,
  `csel x8, xzr, x9, ne` trên mask & 2; verdict "khớp" trước đó
  của audit-zoomrotate ở cổng này bị thu hồi), và phía app
  `ABOrientationDerivedFromMask` (gốc sub_5734
  @0x57c0–0x57c4). Truy vết (changed = 255): mask 24 → 4
  (trước: 0), mask 26 → 0 (trước: 4), mask 30 → 0 (trước: 4).
  Hook hình học phía app đã kiểm (audit-inapphook): nghi vấn
  hạ — đăng ký khớp gốc, vắng dòng 'app xin huong' là bình
  thường theo điều kiện nhánh; KHÔNG sửa hook.
- KỶ LUẬT DIỄN ĐẠT (GPT chốt, §20.6): sửa cổng mask là sửa
  SAI LỆCH ĐÃ CHỨNG MINH so với gốc — KHÔNG khẳng định nó
  khép toàn bộ hiện tượng xoay 180° nhịp đầu khi phóng to;
  chỉ nghiệm thu trên xe mới quyết định hiện tượng đó hết
  hay chưa.
- Provenance: candidate local
  `com.anlai.omnicar_1.0.3-rebuilt-fixround6_iphoneos-arm64.deb`,
  974.666 byte, SHA-256
  `934e76df768be646ec272279c1bdd95247549f71d176a9f6d8b797896944ce15`
  (chỉ để truy vết). Cổng tĩnh trên candidate — đo trên binary
  trích từ chính candidate: (g1) cổng host ĐẠT
  (binary-structure: appWithHash imp 0x6b64, dãy csel
  0x6ce8–0x6d20, quyết định `cmp x8,#0` @0x6d0c +
  `csel x8, xzr, x9, ne` @0x6d10; truy vết 24→4 / 26→0 /
  30→0), (g2) cổng app ĐẠT (binary-structure: phép suy tại
  0x14d84–0x14da8, `tst x0, #2` @0x14da4 +
  `csel x9, x8, xzr, eq` @0x14da8 — hằng 0 nằm ở nhánh
  bit-2-có-mặt; truy vết như trên), (h) hồi quy host-bar
  ĐẠT (guard equality @0xb0f8 → epilogue 0xb258; block
  entrance 0xba88 setAlpha: fmov 1.0 trước setTransform:),
  marker [fixround6] đủ 3 binary, 'cham thanh' còn trong
  AppBridge. Đây là 'đã kiểm tra tĩnh', không phải PASS
  hành vi.

## UUID từng slice (đo trên bản FAT)

Cả 8 binary đều FAT arm64 (subtype 0x0) + arm64e (subtype
0x80000002, PAC00), min iOS 15.0 (LC_BUILD_VERSION).

| Binary | arm64 | arm64e |
|---|---|---|
| OmniCar (app) | 6B981AD3-F197-311E-AA77-4C6152A276B9 | BF7E1FDC-94D6-386E-BE30-0AE607DA25B2 |
| OmniCarPrefs | D9C1CF0D-D1C4-3386-B0DF-D982C904A8C9 | DE51D337-5C3E-3F7C-9D15-A784362A7386 |
| OmniCarAppBridge.dylib | EAFDC89A-F590-3673-8695-3B0606B08127 | A4569BA4-E4A2-3428-8138-90FB349F0DD1 |
| OmniCarCarProbe.dylib | 81801F8C-82CA-3CB1-9C3B-EAD556DFC656 | 0C7B7723-8950-3081-9EB7-ACFA8F085FC4 |
| OmniCarCore.dylib | 49FE7BC4-C63C-33BE-AC35-D5029EED68EF | 0A7C5BFE-03F3-3C38-A83F-82799F40C34D |
| OmniCarSpeedBubble.dylib | D6FB0C99-C111-3BD1-B54A-A5F5D6E9B676 | 7655F490-366E-35F8-9185-2B2206660D0E |
| OmniCarSplitScreen.dylib | 4578CA02-FD3E-3243-BCA8-FDCE7FDAB0EF | 9083F21A-47C5-39F4-903A-C43987F99DD1 |
| OmniCarStartupScreen.dylib | 5891E461-4C95-3B3C-80C9-6E70170455A2 | 45489B68-A63C-31B4-A665-A9674608B513 |

## Marker build [fixround6] (đo trên bản FAT, có ở cả hai slice)

- SplitScreen: `loaded into CarPlay [fixround6]`
- Prefs: `[GPT-F] specifiers build [fixround6]: controller=%@ total=%lu features=[%@]`
- AppBridge: `build %s (%s) loaded into %@ [fixround6]`

## Còn mở (không thuộc nghiệm thu vòng này)

- Núm vách ngăn publishKnobsNow (kết tội ở audit-roundlogo,
  PATCH_NOTES §20.5): CHƯA sửa — chờ lệnh riêng của Nguyen,
  giữ chờ bằng chứng theo thứ tự đã chốt (§20.6).
- Đuôi !logoView của playIntro phía XE (slot ivar
  0xcb0/0xcc0/0xcc8 chưa ánh xạ chắc) — vòng branch-fidelity
  riêng.
- cellClass: giữ nhãn CHƯA XÁC MINH — UUID crash chưa ghép
  được đúng binary (§20.6).

## Trạng thái

DEVICE_TEST = PENDING. Bản này đã sửa và build — chưa được
gọi là hoàn thiện cho tới khi nghiệm thu trên xe theo kịch
bản gộp một phiên, trọng tâm: (1) YouTube (hosted) phóng to
solo từ split — quan sát nhịp xoay đầu còn ngược 180° hay
không, và log phải cho thấy yêu cầu mask 24 được đáp khác
trước (không còn kẹt 'scene huong 1' do fallback); (2) hồi
quy xoay: TikTok (mask 30/26) và Facebook (mask 2) vào/ra
solo không đổi hành vi; (3) hồi quy thanh "..." hosted vẫn
mở đủ 5 nút như fixround5 đã đạt; (4) menu tỉ lệ, swap,
picker giữ nguyên. Log + .ips (nếu có) up vào `logs/` của
repo sau phiên.
