# HỒ SƠ — Lề 0.2.4 (`dev.bechou.le`)

> Quét sâu tĩnh (chỉ đọc, không chạy binary/script) ngày 13/11/2026, đội 4 investigator + tổng hợp.
> Báo cáo chi tiết từng nhóm nằm cùng thư mục: `A_HIEN_THI_RELAY.md`, `B_NGUON_GOFA_WAZE.md`,
> `C_NGUON_VIETMAP_GMAPS.md`, `D_PREFS_GOI.md`, kiểm kê Mach-O ở `KIEM_KE_MACHO.md`.
> Quy ước nhãn: **[ĐÃ ĐO]** = có bằng chứng trong binary (class/method/chuỗi/disassembly);
> **[SUY LUẬN]** = suy ra từ bằng chứng; **[CHƯA RÕ]** = phân tích tĩnh chưa chốt được.

## 1. Định danh gói

| Hạng mục | Giá trị |
|---|---|
| Package | `dev.bechou.le` |
| Tên hiển thị | Lề |
| Version | 0.2.4 |
| Tác giả / Maintainer | bechou |
| File gốc | `dev.bechou.le_0.2.4_iphoneos-arm64.deb`, 1.677.842 byte |
| SHA-256 | `98a234f404987d5958bc80a19e0ed62d34ca2b39d4ef6e798bfd3314e2cb4770` |
| Nén | control.tar.gz + data gzip |
| Architecture | iphoneos-arm64 (rootless, `/var/jb`); các Mach-O đều FAT arm64 + arm64e |
| Section / Depiction | Tweaks / https://repo.bechou.dev/le-traffic |
| Depends | firmware >= 15.0, < 27.0; mobilesubstrate; preferenceloader |
| Installed-Size | 5216 KB |
| Chức năng (Description) | "Tốc độ, biển giới hạn, biển báo và làn đường trên CarPlay, từ VietMap Live, GOFA hoặc Waze: bubble nổi trên mọi màn hình và thẻ trong Google Maps." |

**Dòng dõi [ĐÃ ĐO]:** Lề là hậu thân đổi tên của **CarWidget Traffic** — control khai
`Conflicts` + `Replaces` với `org.carwidget.traffic-bubble` và `org.carwidget.traffic-runtime`
(dpkg tự gỡ bản cũ khi nâng cấp), `Conflicts` với `com.chou.googlemaps.vietmap`; bên trong,
toàn bộ class vẫn giữ tiền tố **CW** (vd `CWTrafficBubblePrefsController`, `CWTrafficWindow`).
Bản ≤ 0.2.4~beta8 từng chạy một **LaunchDaemon relay ở quyền root** (`dev.bechou.le.relay`);
0.2.4 đã bỏ hẳn daemon — postinst chỉ còn nhiệm vụ `launchctl bootout` daemon cũ và
`rm -rf` đúng 4 đường dẫn của chính nó (mọi lệnh `|| true`, không thể làm hỏng cài đặt).

## 2. Cấu trúc gói — 10 Mach-O, 3 vai

| File | Kích thước | Nạp vào (filter Bundles) | Vai |
|---|---|---|---|
| LeBubble.dylib | 704.064 | `com.apple.CarPlayApp`, `com.apple.springboard` | Hiển thị bubble giao thông trên xe + bản "cast" phía SpringBoard |
| LeSupervisor.dylib | 205.056 | `com.apple.springboard` | Watchdog: tự mở app nguồn ở nền khi CarPlay nối, đóng sau khi ngắt 20 s |
| LeGoogleRelay.dylib | 328.880 | `com.apple.springboard`, `com.apple.CarPlayApp` | Trạm trung chuyển cấu hình + trọng tài chọn 1 nguồn dữ liệu |
| LeGuidanceRelay.dylib | 167.424 | `com.apple.CarPlayTemplateUIHost` | Đo hình học thẻ dẫn đường CarPlay gốc, phát cho bubble né chỗ |
| LeGofaSource.dylib | 399.632 | `com.lumi.GOFA` (app GOFA) | Trích xuất dữ liệu từ GOFA |
| LeWazeSource.dylib | 342.720 | `com.waze.iphone` (Waze) | Trích xuất dữ liệu từ Waze |
| LeGoogleSource.dylib | 477.584 | `vn.vietmap.live` (VietMap Live) | Trích xuất dữ liệu từ VietMap Live |
| LeSourceShown.dylib | 166.256 | `vn.vietmap.live` | Beacon hiện diện: báo "VietMap đang hiện" kèm PID |
| LeGoogleMaps.dylib | 826.896 | `com.google.Maps` (Google Maps) | Dựng thẻ tốc độ/giới hạn/làn ngay trong Google Maps |
| LePrefs (bundle) | 1.282.064 | PreferenceLoader | Trang cài đặt + engine vẽ để xem trước + trang Chẩn đoán |

Kèm gói: font **Saira** (4 TTF: Bold/Medium/SemiBold/Condensed-Bold) ở
`/var/jb/usr/share/le/gmaps/fonts/` kèm `OFL.txt` (SIL Open Font License 1.1 — đóng gói đúng phép),
được LeGoogleMaps đăng ký lúc chạy bằng `CTFontManagerRegisterFontsForURL`.

## 3. Kiến trúc tổng thể [ĐÃ ĐO]

```
[app nguồn: GOFA / Waze / VietMap Live]          [CarPlayTemplateUIHost]
   Le*Source trích xuất dữ liệu                     LeGuidanceRelay đo hình học
            │  Darwin notify (state 64-bit)                │  thẻ dẫn đường gốc
            ▼                                              ▼
   [SpringBoard] LeGoogleRelay: dịch cấu hình, chọn 1 nguồn thắng
   [SpringBoard] LeSupervisor: giữ app nguồn sống ở nền (mở/đóng theo CarPlay)
            │
            ▼  Darwin notify (state 64-bit) + file trạng thái dùng chung
   [CarPlayApp] LeBubble: CWTrafficWindow trên scene CarPlay → bubble nổi
   [Google Maps] LeGoogleMaps: thẻ trong UI Google Maps (cả trên xe và trên iPhone)
```

Ba quyết định kiến trúc đáng chú ý:

1. **Phía hiển thị KHÔNG hook một method nào [ĐÃ ĐO].** Cả 4 dylib hiển thị/relay đều không
   link CydiaSubstrate, không `MSHookMessageEx`, không swizzle. Chúng tự tạo cửa sổ
   (`CWTrafficWindow` trên scene có `UIWindowSceneSessionRoleCarPlay`, window level tính động
   cao hơn cửa sổ DashBoard) và duyệt cây view bằng `NSClassFromString` trên class riêng của
   Apple (`DBDashboard*`, `CPSManeuversCardView`…). Đổi lại, điểm giòn là iOS đổi tên class
   riêng thì mất hiển thị — mã có sẵn log "private interface changed" để tự vô hiệu hoá thay vì crash.
2. **Toàn bộ dữ liệu thời gian thực đi qua state 64-bit của Darwin notify [ĐÃ ĐO].**
   Không socket, không XPC, không file cho dữ liệu chạy: mỗi trường dữ liệu là một kênh
   notify riêng, giá trị được **đóng gói số học vào uint64 state** của kênh, thêm một notify
   `.changed` đóng vai commit. Cả hai đầu đều có cặp hàm `GVMEncode…/GVMDecode…`.
3. **Phía nguồn thì ngược lại — hook sâu vào app chủ [ĐÃ ĐO]** (xem §5): hook CLLocationManager,
   giữ phiên GPS nền bằng "wake lease" với `CLBackgroundActivitySession`, thậm chí khởi động
   lại GPS của app nguồn khi nó im lặng quá lâu. LeSupervisor phía SpringBoard phối hợp:
   CarPlay vừa nối là tự mở app nguồn ở nền (FBSOpenApplicationService + RBSAssertion
   `Workspace-BackgroundActive` + `CLInUseAssertion`), có thử lại/đếm lượt; CarPlay ngắt thì
   chờ đúng 20 giây rồi terminate đúng PID mình đã mở (trừ khi Google Maps trên iPhone
   đang dùng dữ liệu) — đây là lý do bubble luôn có dữ liệu dù người dùng không mở app bản đồ.

## 4. Giao thức IPC — Darwin notify + đóng gói bit [ĐÃ ĐO]

Họ kênh chính (tiền tố `dev.bechou.le.*`):

- Nguồn → hệ thống: `dev.bechou.le.gmaps.speed`, `.limit`, `.alert.first`, `.alert.second`;
  khung riêng theo nguồn `dev.bechou.le.gmaps.output.v1.<providerID>.<field>` + `.changed`;
  sự kiện `dev.bechou.le.bubble.gofa-events` / `.waze-events` / `dev.bechou.le.bubble.vietmap-shown` (state = PID).
- Cấu hình: `dev.bechou.le.bubble.layout-changed` (kèm file `~/Library/Preferences/dev.bechou.le.bubble/layout-v1.json`),
  domain CFPreferences `dev.bechou.le.gmaps` cho thẻ Google Maps (notify trùng tên key để đồng bộ Maps ↔ relay).
- Guidance: `dev.bechou.le.gmaps.carplay.guidance` (kênh duy nhất của LeGuidanceRelay).

Công thức đóng gói đã giải tới từng bit (chi tiết ở `B_NGUON_GOFA_WAZE.md` §6.4):

- Mẫu tốc độ/giới hạn: `state = (ms << 10) | (1 << 9) | value` — value là km/h, 0–400; ms là mốc thời gian.
- Cảnh báo: các trường nhỏ ghép theo ca số `A | B<<14 | C<<21 | D<<24`.
- Guidance: 5 trường hình học × 12 bit + bit hiệu lực; LeGuidanceRelay quét cây view của
  CarPlayTemplateUIHost bằng timer 100 ms, chỉ đo MinY/MaxY của thẻ maneuver/ETA sau quy đổi
  toạ
...[truncated 6158 chars]