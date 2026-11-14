## 2026-11-14 — G1 VÒNG TRÒN 5 LỆNH THẬT → giao Muse triển khai G2 có giới hạn
- **[Spec+handoff R0–R5](APEX_V3_P4_G1_RADIAL_5_ACTIONS_MUSE_20261114.md)**: 5 sector đúng 5 action gốc, action-first→thẻ Ô1/Ô2→handler, popup/vòng không là ảnh giả; fullscreen ẩn logo/dock + pinch-in restore, source/guards/10 ca QA và các blocker đã khai báo.
- **[Bản vẽ vòng + chọn ô](APEX_V3_P4_G1_RADIAL_WHEEL_20261114.svg)** và **[5 luồng chức năng](APEX_V3_P4_G1_RADIAL_5_FLOWS_20261114.svg)**: vector review source, không phải runtime/device screenshot; logo D dùng asset gốc không vẽ lại. Muse nhận việc trên Issue #1; không CI/DEB/merge/publish trước các cổng thực tế.

## 2026-11-14 — V3 Purple Horizon master ZIP upload verified
- Tệp master thiết kế 13.200.777 byte, SHA-256 `934747e09e3bb0d339f999558e543708227c59e8b88433b6c9cca4137009f73d`, đã được chia 18 mảnh binary trong [V3_PURPLE_HORIZON_DESIGN/master-zip-parts/](V3_PURPLE_HORIZON_DESIGN/master-zip-parts/) vì giới hạn connector; có `reassemble_zip.py` + manifest để Muse tái tạo ZIP gốc và tự xác minh CRC/SHA-256. 23 SVG review trong thư mục `screens/` chỉ là bản nhẹ; **ZIP master có ảnh, SVG và logo nguyên bản**. Chưa phê duyệt UI cuối, không đụng source/CI/DEB.

## 2026-11-14 — V3 P1: BẢN ĐỒ HUNK BL-01..BL-12 (Muse nộp, chờ duyệt thiết kế + master)
- Theo giao việc GPT (#6877408566): Muse nộp [APEX_V3_P1_BAN_DO_HUNK_20261114.md](APEX_V3_P1_BAN_DO_HUNK_20261114.md) — đối chiếu 23 màn kit ↔ P0 ↔ source HEAD `8af9e78`, phủ đủ 12/12 BL ở mức file:method:dòng (BL-10/11/12 = 0 hunk: quyết định của Nguyen / giữ nguyên có bằng chứng / việc đo), 13 quyết định cần chốt D-01..D-13, 11 nhóm commit đề xuất cho P2. Chỉ tài liệu — không sửa code. Cổng P2 giữ nguyên: Nguyen duyệt hình bản cuối + master asset gốc lên repo.

## 2026-11-14 — V3 Purple Horizon review kit (GPT, 23 SVG screens)
- Review-only handoff: [V3_PURPLE_HORIZON_DESIGN/README.md](V3_PURPLE_HORIZON_DESIGN/README.md), [SPEC](V3_PURPLE_HORIZON_DESIGN/SPEC_V3_DESIGN.txt), [MUSE map](V3_PURPLE_HORIZON_DESIGN/MUSE_HANDOFF.txt). Current repo assets: 23 lightweight SVGs + **lossy logo-D reference thumbnail**; original master PNG/ZIP remain in conversation and have not been transferred byte-for-byte. Nguyen visual approval **pending**; Muse preflight/source-hunk mapping only; no P2, CI, DEB or merge.

# LỊCH SỬ DỰ ÁN GPT — OmniCar mã nguồn

## 2026-11-14 — DUOCAR V3 P0: BẢNG PHỦ 100% (Muse nộp, chờ GPT thiết kế V3)
- Theo chỉ đạo V3 của Nguyen (#6876443778) và giao việc GPT (#6876562736): Muse nộp [APEX_V3_P0_BANG_PHU_20261114.md](APEX_V3_P0_BANG_PHU_20261114.md) — 112 dòng kiểm kê A–E có bằng chứng file:method:dòng, trả lời thẳng vì sao APEX1 vẫn giống OmniCar (7 nguyên nhân từ source), kiểm độc lập DEB APEX1, bảng phân biệt native/hosted (chốt nguyên nhân glyph hosted đen: AlwaysOriginal + UIImageView con vs AlwaysTemplate), vision gate (phần lớn UNKNOWN trung thực), backlog BL-01..BL-12 và danh sách identifier tuyệt đối giữ K1–K12. APEX1 giữ làm reference/rollback, nhãn VISUAL FAIL.

## 2026-11-14 — APEX: SOURCE GATE PASS (GPT) + M4 COMPILE PASS, Nguyen lệnh xuất DEB thử nghiệm
- GPT chốt **SOURCE GATE PASS** (comment 6875888201, đối chiếu độc lập 16/16 + 4 cặp SHA). Muse khôi phục toolchain theo duyệt trực tiếp của Nguyen và compile-check `make` trên HEAD `3107d0e`: **exit 0, 0 lỗi**, 7/7 subproject linking (chi tiết + hash tại comment 6875967464). Nguyen lệnh xuất một DEB thử nghiệm APEX — xem checkpoint TASK1+TASK2, bổ sung 3.

## 2026-11-14 — APEX TASK1 + TASK2 XONG Ở MỨC SOURCE (M3-0 mesh + D5-B 5 mục)
- GPT duyệt mở 2 cổng có giới hạn (Issue #1, comment 6875586688) và giao việc trực tiếp (6875604560); Muse thực hiện xong: TASK1 commit `d256a3e` (bỏ mesh cũ ở đúng 3 mặt DuoCar, lõi C giữ nguyên), TASK2 ba commit `580421b`/`fa48bf4`/`477263b` (route 5 tab → phân vùng Thiết bị/Tùy chỉnh theo nội dung hàng → dashboard + preview). Bảng đối chiếu hàng trước/sau: không trùng, không mất hàng nào. [Checkpoint TASK1+TASK2](APEX_TASK1_TASK2_CHECKPOINT_20261114.md), [bản đồ + trạng thái D1–D14/A1](APEX_M2_BAN_DO_TRIEN_KHAI_20261114.md).
- Nhãn: **SOURCE COMPLETE / COMPILE PENDING / DEVICE PENDING**. Không merge main, không CI/DEB.

## 2026-11-14 — GPT DESIGN V2 (M1): gói DuoCar APEX Stealth đã giao repo, CHỜ NGUYEN DUYỆT
- Nhận trách nhiệm thiết kế 100% từ Nguyen sau khi M1 Muse cũ bị bác. Nhánh Muse `feature/duocar-apex-ui-muse-20261114` trên baseline HL61 `298b7b4a8432037d71db441d0975aca1db1f6e04`; commit tài liệu/asset **`eab80668aa8d9e61efaeff1260ae5e77015e66d7`** thêm **31 file (27 SVG + 4 tài liệu)**, không sửa mã runtime. [Mở bộ thiết kế GPT APEX V2](APEX_M1_GPT_V2/README.md), [spec](APEX_M1_GPT_V2/APEX_V2_SPEC.md), [ma trận D1–D14/A1](APEX_M1_GPT_V2/APEX_V2_MATRIX.md).
- Bộ hình gồm 6 giao diện iPhone, 9 trạng thái CarPlay, 1 bảng nhận diện; 11 SVG logo/icon. So sánh với 46 PNG của Muse M1 v1 trong cùng nhánh; tất cả là **mockup/sản phẩm thiết kế**, không phải ảnh chụp thiết bị hoặc bằng chứng runtime. Giữ Home hệ thống và nội dung native/hosted app khác nguyên dạng, thermal HL61, window +64/+65, C/F, phím/Telex, dock, shim Lề đã đạt.
- **M1 GPT V2 giao để xem và duyệt, chưa được Nguyen duyệt; M2/M3 CHƯA ĐƯỢC PHÉP; không chạy CI/build/DEB/PR.** Muse là người triển khai code chỉ sau khi được duyệt, từng hunk theo ma trận, không tự vẽ lại. Điểm kiểm tiếp: Nguyen duyệt logo/visual/picker/fullscreen/thermal; sau đó Muse nộp mapping method/hunk trước code. Issue #1 là đầu mối cập nhật, không tạo Issue khác.


## 2026-11-14 — HL61 giao diện cảnh báo nhiệt và rà Muse UI
- Cảnh báo nhiệt chia/fullscreen có **viền đỏ nhấp nháy trong suốt**, chính giữa chỉ hiện **“LÀM MÁT THIẾT BỊ CỦA BẠN”**. Không chữ mô phỏng, không nhiệt độ/nguồn trên cảnh báo; giữ gate 37°C và công tắc thử. Không đụng Lề DC59CL. [Checkpoint](HL58_EXTERNAL_LE_OPTIONAL_DETACH_20261114.md).
- Đã kiểm báo cáo UI/UX Muse tại nhánh `audit/duocar-ui-full-audit-20261114` commit `94859141`. [Đánh giá GPT](DUOCAR_UI_AUDIT_GPT_REVIEW_20261114.txt): 5 nhóm nội dung có báo cáo, 17 khoảng trống U1–U17, chỉ điều tra DC58, không phải mã UI mới.



## 2026-11-14 — DC58 FAT thành công: tháo toàn bộ Lề gốc khỏi DuoCar, giữ GPS±10 và ON/OFF optional
- **DEB cuối** \`DC58.deb 1.0.4-hl58\`, build run **43553319919 SUCCESS**, artifact **14096254418**, SHA256 \`7b22f302fba395ce858112d378dacb6b217f7dbc04d21595bd3920374735ce56\`, **1,257,484 bytes**. Đã kiểm **trực tiếp**: 297 file, 8 binary FAT/16 signed slices, KHÔNG có 9 Lề dylibs/LePrefs/font/vendor, KHÔNG còn \`Conflicts\`/\`Replaces\`/\`Depends\` với \`dev.bechou.le\`. Ứng dụng + shim DuoCar 2 chức năng chỉ giữ GPS ±10 và công tắc bong bóng; không can thiệp drag/windowLevel. **Cài độc lập 2 gói hợp lệ về manifest, nhưng 2 chức năng nối với Lề riêng CHƯA DEVICE PASS**. Cài DC58 thay DC57 trước, rồi Lề gốc riêng, respring; giữ JSON Waze người dùng. Workflow restored manual-only. [HL58 checkpoint](HL58_EXTERNAL_LE_OPTIONAL_DETACH_20261114.md).


## 2026-11-14 — HL58: tách Lề gốc khỏi DuoCar, chỉ giữ GPS ±10 + bật/tắt (Lề cài riêng)
- Nguyen yêu cầu hoàn nguyên Lề embedded vì hosted overlay vẫn lỗi. Source: xoá 9 vendor Le dylibs, LePrefs và fonts khỏi quy trình merge; bỏ Conflicts/Replaces `dev.bechou.le`, app chỉ còn hai điều khiển có ACK, optional extension chỉ can thiệp số speedText và mask/unmask bubble Lề, không chạm pan/windowLevel/scene, iOS bundle vẫn có thể cài không cần vendor. Package `dev.bechou.le 0.2.4` theo scan main không xung đột tên gói DuoCar; tương thích metadata ≠ đã test runtime. Target `DC58.deb` `1.0.4-hl58` (tăng version qua DC57). No build yet at this checkpoint. [Hồ sơ HL58](HL58_EXTERNAL_LE_OPTIONAL_DETACH_20261114.md).



## 2026-11-14 — DC57 FAT DEB built, binary independently verified; CI stale HL55 marker
- One **\`DC57.deb\` v\`1.0.3-le0249\`**, 2,380,020 bytes, SHA256 \`665d567ee05f3a9e18b0dbfc31bd50b00666750069a9a490c0395717a6131c51\`, source commit \`dfd53193\`, run \`43550513176\`, artifact \`14096090713\` archived as \`DC57-failed-binary\`. App/ext build, merge, source tests, vendor re-sign all PASS; CI overall **failure** due legacy \`[hl55-vendor-save]\` verifier, corrected to shipped \`[hl56-config-source]\` without re-build. Exact DEB independently verified 18 FAT binaries, 36 nonempty signatures, 10 Lề vendor Mach-O without \`km/h\`, fixed passive top-left status, native menu sheet markers, owner/LePrefs/zoom/Dock. Manual-only workflow restored. **Device test pending.** [HL57 full checkpoint](HL57_FULLSCREEN_STATIC_STATUS_AND_NATIVE_MENU_20261114.md).


## 2026-11-14 — HL57: HUD fullscreen không nhận chạm, hàng giờ–pin–nhiệt góc trái; menu native nguyên nền hosted
- Nguyen thay thế thiết kế bubble tự do bằng status `giờ  🔋pin 🌡nhiệt` **một hàng cố định ở top-left**, chữ kiểu Dock, không nền, 4pt clock→pin; **window hitTest luôn nil**, tất cả UI/thermal con `userInteractionEnabled=NO`, không nhận tap/scroll/pinch; chỉ hiện khi fullscreen. Menu occupied native chuyển về original blur/mesh như hosted thay vì alpha 0.32 của HL49 gây lộ logo. Code commits `0852b159`, `99f72e88` + source gates/checkpoint. **CHƯA build/deb/DEVICE PASS**; giữ nguyên Lề HL56. [Biên bản HL57](HL57_FULLSCREEN_STATIC_STATUS_AND_NATIVE_MENU_20261114.md).


## 2026-11-14 — HL56: corrected clock-to-pin visible spacing
- Found fixed 74pt clock slot in DC55 despite reducing bubble to 208pt. HL56 source narrows it to 180pt and measures actual local-time text, aligns time right / battery left with adjacent frames. Scoped change only to fullscreen clock view + test; **NOT BUILT / NOT device-proven**. [Checkpoint](HL56_DC55_DEVICE_REGRESSIONS_SOURCE_ROOT_CAUSE_20261114.md).


## 2026-11-14 — HL56: DC55 test xe FAIL; truy nguyên Waze/VietMap, kéo lần đầu và Lề dưới hosted
- Nguyen xác nhận **Lề master ON/OFF đạt**, nhưng menu Lề hiện VietMap dù CarPlay vẫn lấy Waze; bubble bị che dưới hosted, lần kết nối đầu không kéo/cặp mép được. Soát LePrefs arm64 thực: original đọc qua `NSHomeDirectory()` của DuoCar iPhone app, khác JSON canon của SpringBoard → stale/default; DC55 chỉ broker GHI. Mã HL56 đã thêm canonical READ CRC+nonce owner, hydrate LePrefs trước mở UI, chặn mặc định VietMap và bảo vệ Waze; bỏ ép windowLevel, tái gọi vendor -place khi hosted window thay, reset pan khi lần đầu attach lỗi, giữ master ON/OFF. Source commits `0dd7d660` → `36b96c52`; **CHƯA CI/build/DEVICE PASS**. [Biên bản HL56](HL56_DC55_DEVICE_REGRESSIONS_SOURCE_ROOT_CAUSE_20261114.md).


## 2026-11-14 — DC55 integrated FAT DEB: artifact verified; CI final stale marker corrected
- One signed \`DC55.deb\` \`1.0.3-le0248\`, SHA256 \`ef61abb1608a0334fefcd112a81eb06d351c9fd306473268f85aa1c590d9b775\`, 2,374,124 bytes, build source \`adad8a3dd1387f9bd8c19ea7276b224ad58bb4a0\`, run \`43539194236\`, artifact \`14091340439\` (\`DC55-failed-binary\` archived because legacy verifier still checked HL52 END). App/ext FAT compiled+signed, merged+signed vendor and patch PASS; independent **actual artifact replay** verified 18 signed FAT executables, 10 vendor FAT clean of \`km/h\`, broker/master/window/thermal/zoom/menu/Dock markers, byte-identical vendor assets vs DC54. Updated outdated validator and restored manual-only CI without rebuilding. **NOT DEVICE PROVEN**. [Full checkpoint](HL54_LE_ORIGINAL_SAVE_AND_LAYER_FORENSIC_20261114.md).


## 2026-11-14 — HL55 đang tích hợp đủ lỗi trước khi một DEB
- Nguyen yêu cầu **không build dở dang**. Đã lưu source cho snap/free Lề, visibility switch thật, original LePrefs owner-broker, window probe/layer cho YouTube, thu ngắn bubble giờ–pin–nhiệt và cảnh báo pin ~39°C toàn màn ở split/fullscreen. Commits \`e0462c88\` → \`d41c2b16\` trên nhánh HL54. **CHƯA build/ký DEB mới, CHƯA device pass**. Nguồn Lề chỉ có evidence cảnh báo đỏ **vượt tốc**, không chứng minh bản gốc có cảnh báo 39°C; logic 39°C của DuoCar riêng. Cổng còn: source gates, host C tests, broker/ABI, one DEB final, device test. [Checkpoint chính](HL54_LE_ORIGINAL_SAVE_AND_LAYER_FORENSIC_20261114.md).


## 2026-11-14 — HL54: DuoCar54 DEB FAT built, source QA + final 20/20 Mach-O signed/no km/h
- Build on branch feature/duocar-hl54-le-original-integrity-20261114 commit \`6c0c4d48\`, GitHub Actions run **43534370456** SUCCESS, artifact **14089327077** \`DuoCar54.deb\` v\`1.0.3-le0247\`, **2,360,612 bytes**, SHA256 \`8d4c95b46aed2e45713cc0d4aaa21950285593ac01a4c44586d312ce47956ef7\`. Verified extracted DEB: Lề 10 executables × arm64/arm64e each signed, **NO UTF-8/UTF-16LE km/h**. Clock near-edge/free + GPS ±10 code compiled in CI. Workflow restored manual-only; **NOT device-proven**; Lề save/ON-OFF/YouTube layer/Lề snap remains open. [HL54 checkpoint](HL54_LE_ORIGINAL_SAVE_AND_LAYER_FORENSIC_20261114.md).



## 2026-11-14 — HL54: gỡ toàn bộ \`km/h\` Lề; bong bóng giờ cặp mép + di chuyển tự do
- Theo lệnh Nguyen, đã **commit source** để hậu xử lý toàn bộ Lề 0.2.4 FAT: quét 10 Mach-O cả arm64/arm64e, thay chữ \`km/h\` ở các chuỗi UTF-8/UTF-16LE (bao gồm LeBubble, Maps, relay, source, LePrefs), không sửa số liệu giao thông, ký lại 6 dylib + LePrefs có thay chữ; độc lập kiểm final DEB không còn literal unit. Trên **DuoCar53 đã build** còn 33 occurrence/arch (LeBubble hậu tố ngắn đã bị patch trước); thử dry-run trên bản sao đạt 33/33 per arch. Vendor LePrefs nay được phép khác byte **chỉ ở chữ**, không còn tuyên bố toàn bộ binary vendor identical.
- Bong bóng fullscreen giờ–pin–nhiệt trên CarPlay **nguồn đã sửa**: gần mép trái/phải thì cặp, thả ở giữa giữ X/Y, lưu normalized position + dock flag; migration vị trí cũ, không tạo window/gesture mới, giữ Dock HUD ở split. Test fixture C chạy \`HL54_CLOCK_DOCK_GEOMETRY_PASS cases=30014\`; test source thực được thêm trong repo để chạy khi checkout. Workflow \`build-hl54-le-units-clock-dock-fat.yml\` **chỉ chuẩn bị manual, KHÔNG dispatch**; chưa build/ký DuoCar54, chưa nghiệm thu xe. [Hồ sơ, điểm rollback và kiểm chứng](HL54_LE_ORIGINAL_SAVE_AND_LAYER_FORENSIC_20261114.md).


## 2026-11-14 — HL54 SOURCE: slider GPS -10 đến +10 km/h, bước 1
- Nguyen chốt thay nút tăng/giảm bằng thanh kéo toàn ngang, mốc -10 / 0 / +10 và số có dấu khi kéo; chỉ gửi lệnh khi thả / VoiceOver điều chỉnh. Đã sửa và lưu project/src của UI, bridge key 27 raw 0..20, core bù GPS ±10 (không sửa biển giới hạn), Settings row, test và source gates; giá trị prefs cũ có dấu không đổi nghĩa. Host fixture mapping 2032 cases PASS; chưa build iOS/CI/DEB/device test. Không thay LePrefs gốc, pinch, menu, Dock, keyboard. [Checkpoint HL54](HL54_LE_ORIGINAL_SAVE_AND_LAYER_FORENSIC_20261114.md).


## 2026-11-14 — HL54 GPS ±10: slider đã ghi source, QA/DEB chưa build
- Slider **−10…0…+10 km/h**, 21 mức 1 km/h, giá trị động khi kéo, gửi ACK khi thả tay/VoiceOver; key27 raw 0..20 ↔ signed −10..+10, vẫn giữ cấu hình cũ, không sửa biển giới hạn. Các source+mirror commit từ \`c64b024c\` tới \`789e572d\`, bổ sung gates tới \`859d84f2\`. **SOURCE COMMITTED, chưa iOS build/DEB/device pass**. [Checkpoint HL54](HL54_LE_ORIGINAL_SAVE_AND_LAYER_FORENSIC_20261114.md).


## 2026-11-14 — HL54 bổ sung: giữ cặp mép + kéo X/Y tự do; cần master ON/OFF Lề thật
- Nguyen yêu cầu **hai chế độ đồng thời**: kéo giữa màn đứng yên, đưa sát mép thì cặp mép như Lề gốc; hiện `freePan` END ghi đè vị trí `-panned:` gốc và `margin=6` ngăn flush mép. Đồng thời phải có **công tắc ON/OFF bong bóng Lề hoạt động**, không chỉ bật/tắt hình giả: `bubbleEnabled` có trong `layout-v1.json` và bridge extras nhưng UI gốc chưa lưu được, cần owner broker + kiểm đường live visibility vendor. Không sửa `traffic-bubble-state-v1.json` khi chưa chứng minh ý nghĩa, không đụng pinch/menu/Dock/keyboard. **DESIGN/BINARY AUDIT; CHƯA SỬA SOURCE/CHƯA BUILD/CHƯA DEVICE PASS**. [Chi tiết HL54](HL54_LE_ORIGINAL_SAVE_AND_LAYER_FORENSIC_20261114.md).

## 2026-11-14 — HL54: 'cài đặt cũ' là lỗi lưu Lề gốc, KHÔNG chứng minh trùng gói
- Nguyen test DuoCar53 `1.0.3-le0246` (ảnh iPhone và CarPlay): **LePrefs gốc hiển thị nhưng báo `Không lưu được / Bubble vẫn dùng cài đặt cũ`**; đây là giá trị cấu hình trước đó được giữ vì save fail, **không phải** phát hiện hai bản Lề. DEB `com.chuong.duocar` khai báo Conflicts/Replaces `dev.bechou.le`, nhưng chưa kiểm dpkg/file dư trên máy nên không kết luận chắc không tồn dư. Trực tiếp trích final DEB/binary LePrefs, writer `CWStoreTrafficBubbleLayout→CWWriteOwnedStateFile` có kiểm owner `st_uid==geteuid`, mkdir/open/fsync/rename; DuoCar gọi UI gốc trong app sandbox trong khi cầu nối ghi owner ở SpringBoard chỉ dành cho trang extras, **chưa route save gốc**. Bubble dưới YouTube còn chưa biết owner/window layer cụ thể; cần log PID/scene. HL54 mới **điều tra, chưa vá code, chưa build/CI**. [Hồ sơ chứng cứ](HL54_LE_ORIGINAL_SAVE_AND_LAYER_FORENSIC_20261114.md).


## 2026-11-14 — DuoCar53 1.0.3-le0246: FAT signed, delivered; DEVICE PENDING
- Build cuối [CI #43523818233](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/43523818233), **SUCCESS** từ commit `7423e284917a73b3ed24251660980e1b563357d6`: `HL53_SOURCE_GATE_PASS` 15 mirrors, test pinch 360°/2540 ca PASS, build+ký DuoCar/Lề arm64+arm64e, merge, verify vendor, `DUOCAR53_FINAL_FAT_PASS`. Artifact `DuoCar53` ID `14083488733`, DEB trực tiếp `dc53.deb` 2.344.324 B, package `com.chuong.duocar`, version `1.0.3-le0246`, SHA-256 `aa1f620a3e2c84d011f5663401eec347927d25f0ebd21ced2ad8e8acded26c8b`; ZIP được kiểm toàn vẹn, trích đúng 1 DEB. **DEVICE PENDING**: cần Nguyen test zoom OUT→fullscreen, IN→split, Dock pin/nhiệt, Lề gốc, kéo bong bóng, menu trên xe. Không merge main/Sileo. [Checkpoint HL53](HL53_DIRECTIONAL_PINCH_ALL_ANGLES_20261114.md).


## 2026-11-14 — DuoCar53 1.0.3-le0246 SIGNED FAT PASS, DEVICE PENDING
- Nguyen đã ra lệnh build. CI SUCCESS [43523818233](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/43523818233), job `132224488839`, **build commit `7423e284917a73b3ed24251660980e1b563357d6`**. Artifact **DuoCar53** ID `14083488733`, đúng một `DuoCar53.deb` size **2.344.324 bytes**, **SHA-256 `aa1f620a3e2c84d011f5663401eec347927d25f0ebd21ced2ad8e8acded26c8b`**, Version `1.0.3-le0246`, Package `com.chuong.duocar`. CI validated source 15 mirrors, pinch 2540 cases, vendor Le 0.2.4 identical, two signed slices arm64+arm64e and final FAT. Đã download và **giao trực tiếp `sandbox:/mnt/data/DuoCar53.deb`**; không có xe nên **DEVICE PENDING**, không phát biểu zoom/Le/Dock/menu hoàn tất runtime. Workflow trở lại manual-only; không merge/main/Sileo. Lịch sử 4 CI attempt lỗi và sửa root-cause [checkpoint HL53](HL53_DIRECTIONAL_PINCH_ALL_ANGLES_20261114.md).


## 2026-11-14 — HL53: xòe/chụm mọi góc, 2540 ca toán PASS (source)
- **Lệnh mới của Nguyen yêu cầu SỬA zoom**, thay vì chỉ ghi hồ sơ hoặc hoãn: xòe hai ngón **ở mọi hướng/tư thế** = phóng to fullscreen; chụm mọi hướng = thu nhỏ về split; chỉ đặt hai ngón không toggle. Nhánh độc lập `feature/duocar-hl53-directional-pinch-20261114` từ HL52 HEAD `997a453e`, code commits `574e2157` shared Euclidean direction, `2340804` CarPlay host, `3528207` hosted ABInApp, `d458f3b` reject legacy dir=0 owner. Một fullscreen adapter duy nhất; menu, Dock, Lề, fullscreen engine không sửa. Test 360 góc nguyên × 7 ca + 20 biên = **2.540 ca pure C PASS thực chạy với `cc -std=c11 -Wall -Wextra -Werror -pedantic`**; test assert đếm thật, không dùng số PASS ước lượng; gate `verify_hl53_source.py` có bảo vệ. **CHƯA build DEB/CI/device test**; chưa có chứng cứ từ xe. [Checkpoint HL53](HL53_DIRECTIONAL_PINCH_ALL_ANGLES_20261114.md). Lệnh "HL52 hoãn zoom" chỉ áp dụng cho HL52, không áp dụng HL53.


## 2026-11-14 — ĐÍNH CHÍNH QUY TẮC PINCH: XÒE = FULLSCREEN, CHỤM = SPLIT
- Nguyen đính chính GPT đã đảo chiều. **XÒE 2 ngón (OUT, khoảng cách tăng) → phóng to, vào fullscreen, ẩn Dock; CHỤM 2 ngón (IN, khoảng cách giảm) → thu nhỏ, về chia đôi, hiện Dock**. Hai ngón chỉ đặt xuống KHÔNG được toggle. Branch directional hiện tại ở `SCPTouchProbe.m` và `SCPPinchController.m` đã map đúng; lỗi nằm ở hai đường mặc định fire bare toggle ngay khi nhận đủ 2 ngón (`SCPTouchProbe.m` và `ABInApp.m`). **BỎ yêu cầu đảo chiều đã ghi ở 2026-11-14 ngay phía dưới; giữ lại chỉ làm lịch sử sai.** Chưa sửa zoom trong HL52, chưa build/CI, không thay đổi source. [Đính chính và đối chiếu mã](HL52_ZOOM_DIRECTION_AUDIT_20261114.md).


## 2026-11-14 — Zoom đang hoạt động nhưng nhận 2 chạm = TOGGLE, chưa nhận hướng
- Nguyen cập nhật **zoom đang hoạt động** trên bản hiện tại nhưng cử chỉ không phân biệt chụm/xòe; yêu cầu **chụm hai ngón = vào fullscreen**, **xòe hai ngón = thoát fullscreen/về chia đôi**. Đã đọc trực tiếp `ABInApp.m`, `SCPTouchProbe.m`, `SCPCarSplit+BridgeWake.m`, `SCPPinchController.m`: đường hosted gửi `dir=0` tại ngón thứ hai Began; đường host mặc định `carHostPinchPairToggle=YES` kích hoạt theo trạng thái trước khi xét di chuyển. Nhánh directional phụ hiện tại lại map OUT→expand và IN→restore (ngược yêu cầu); phải đổi **cả hai nhánh** trong đợt zoom riêng, không tạo bộ fullscreen thứ hai. **Chỉ phân tích/thiết kế, KHÔNG sửa zoom vào HL52; chưa build/CI, chưa test xe**. [Hồ sơ truy mã và hướng sửa](HL52_ZOOM_DIRECTION_AUDIT_20261114.md).


## 2026-11-13 — HL52 tiếp tục: Lề free XY theo native window, chờ build/test
- Source `feature/duocar-hl52-leoriginal-dock-freepos-20261113`: commit `013799a` sửa Lề free XY theo kích thước màn CarPlay, di chuyển chính `CWTrafficWindow` khi là native window nhỏ, giữ gốc `-panned:`/ABI và lưu X/Y; đã đọc binary LeBubble từ DEB DuoCar51. `42758ae` / `ce19acd` kiểm tra source/final signed binary HL52; `f6f6cc` chuẩn bị workflow `build-hl52-original-leprefs-dock-free-xy-fat.yml` chỉ chạy thủ công. QA connector: 8 cặp project/src SHA trùng, 4 file menu/zoom/bridge không đổi. Trang Lề gốc và HUD trong suốt dưới icon từ các commit HL52 trước giữ nguyên. **SOURCE QA ONLY — chưa build DEB, chưa chạy iPhone; Lề còn bám lề ở bản DuoCar51 đang cài, chưa tuyên bố hết lỗi.** Zoom vẫn hoãn. [Checkpoint + bằng chứng](HL52_LE_ORIGINAL_DOCK_LAYOUT_20261113.md).


## 2026-11-13 — HL52: original LePrefs + Dock pin/nhiệt trong suốt, bong bóng Lề drag chưa đạt
- DuoCar51 DEVICE: menu không đen (Nguyen xác nhận qua ảnh); pin/nhiệt có hiện nhưng đè giờ; Lề vẫn bám lề, Lề settings chưa nguyên bản. HL52 source branch `feature/duocar-hl52-leoriginal-dock-freepos-20261113`: `OMCLePrefsHost` nạp thực `CWTrafficBubblePrefsController` từ LePrefs.bundle, `SPEEDBUBBLE` mở thẳng gốc, trang extras riêng; HUD native Dock không nền, chỉ tìm dưới 3 icon, giữ giờ/Home; **kéo tự do vẫn chưa sửa, chưa có log HL51 mới**. Chưa CI/DEB/DEVICE PASS. [Hồ sơ HL52](HL52_LE_ORIGINAL_DOCK_LAYOUT_20261113.md).


## 2026-11-13 — DuoCar51: BUILD/ARTIFACT PASS, DEVICE PENDING (zoom hoãn)
- CI [43408145791](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/43408145791) job 131827503274 **SUCCESS**; source `5d201b7`; artifact **DuoCar51** ID `14027424331`, DEB `1.0.3-le0244`, SHA256 `5698fd781567af4fbfe1f8d7bddff0145137629a1408308951539b06dcaf76f3` (2.343.864 bytes), đã tải và giao thẳng người dùng. Chỉ sửa menu + native Dock rail, bubble giữ nguyên; **pinch/zoom không sửa**. Checkpoint: [HL51_MENU_DOCK_PINCH_RECOVERY_20261113.md](HL51_MENU_DOCK_PINCH_RECOVERY_20261113.md). CI PASS != DEVICE PASS, không merge/main/Sileo.


## 2026-11-13 — CẬP NHẬT PHẠM VI HL51: HOÃN ZOOM
- **Yêu cầu mới nhất từ Nguyen:** chưa xử lý pinch/zoom trong DuoCar51. Giữ sửa menu quay về bản trước và widget pin/nhiệt ngoài ba icon Dock. Bỏ thay đổi HL8-exclusive khỏi source HL51, phục hồi BridgeWake project/src đúng blob HL50; verifier/CI gate phải kiểm zoom code nguyên trạng, không thử sửa. **Zoom ở DuoCar50 DEVICE FAIL và sẽ xử lý sau**, không báo HL51 zoom PASS.
- Chi tiết và checkpoint: [HL51_MENU_DOCK_PINCH_20261113.md](HL51_MENU_DOCK_PINCH_20261113.md) / [HL51_MENU_DOCK_PINCH_RECOVERY_20261113.md](HL51_MENU_DOCK_PINCH_RECOVERY_20261113.md). **Chưa build hoặc test xe**, không CI dispatch, main merge hay Sileo.

## 2026-11-13 — HL51: DuoCar50 DEVICE FAIL, menu/Dock source fixes, pinch pending
- Điểm tiếp nối: [HL51_MENU_DOCK_PINCH_20261113.md](HL51_MENU_DOCK_PINCH_20261113.md). Source commits `15475c0` menu hosted image/old tray, `7c591d2` Dock rail outside 3 app icons; **NOT BUILT; pinch still NOT FIXED; DEVICE FAIL of HL50**, bubble remains successful per Nguyen. No main merge/Sileo.


## 2026-11-13 — HL51: giữ ảnh hosted dưới menu, pin/nhiệt ngoài cụm 3 icon, pinch theo HL8
- **DuoCar50 DEVICE FAIL** theo Nguyen: menu hosted còn đen/lộ logo ở nền, pin không hiện Dock, zoom pinch không bung/thu; bong bóng Lề đã trở lại. Log `CarPlay:9447` 16:19–16:21 cho thấy menu gửi frame 0×0, Dock chỉ quét 45×111 của cụm ba icon, và HL13 đang chia pinch cho in-app (không có pair).
- **HL51 SOURCE-COMMITTED, STATIC QA; CHƯA BUILD/DEB/DEVICE PASS**: nhánh `feature/duocar-hl51-gesture-dock-menu-20261113` từ HL50, sửa giữ khung hosted và trả bảng chọn về cửa sổ menu riêng, dò toàn rail Dock với tránh status/Home/icon, trả quyền pinch duy nhất về host theo đường HL8 từng đạt 33/33. Không sửa core fullscreen, keyboard, YTZ5 migration hay Lề đang hoạt động. Đối chiếu 11/11 cặp project/src và 4 file protected giống HL50. Có `verify_hl51_source.py`, `verify_duocar51.py` và workflow FAT **chỉ thủ công, chưa chạy** `.github/workflows/build-hl51-gesture-dock-menu-fat.yml`.
- [Checkpoint/đường sửa/hoàn nguyên HL51](HL51_MENU_DOCK_PINCH_RECOVERY_20261113.md). Cần compile và ký **DuoCar51.deb** rồi Nguyen test cùng log/version mới; CI xanh không chứng minh menu/zoom/Dock hiện đúng trên xe.

## 2026-11-13 — HL50: phục hồi lỗi DuoCar49 DEVICE FAIL
- Mốc phục hồi: [HL50_DEVICE_RUNTIME_RECOVERY_20261113.md](HL50_DEVICE_RUNTIME_RECOVERY_20261113.md). Test xe xác nhận DuoCar49 **DEVICE FAIL**: mất zoom fullscreen, menu đen, Lề không dữ liệu/không kéo, pin–nhiệt sai vị trí. Đã kiểm **hai DEB gốc** qua CI forensic 43395844302; đã sửa đường panned gốc, schema Lề `{id,enabled}`, Dock native view và menu hosted trên nhánh `feature/duocar-hl50-restore-runtime-20261113`.
- CI DuoCar50 ký một DEB FAT: run [43398566381](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/43398566381) — **BUILD/ARTIFACT PASS**; artifact 14023643354; DuoCar50.deb SHA256 aca585fdd3fea80556aa7d94388b451c88fc58f9f59b61076e2b4ebcb5cd2793; **DEVICE PENDING**. Cảnh báo đỏ 39°C để đợt sau. Không merge main, không publish Sileo.

## 2026-11-13 — DuoCar49: sửa hồi quy HL48, BUILD/ARTIFACT PASS, DEVICE PENDING
- Nguyen đã DEVICE FAIL DuoCar48: picker đen, Dock không có pin/nhiệt, Lề còn km/h và hít lề, Cài đặt không lưu, SpeedBubble cũ chưa loại đủ. Nhánh `feature/duocar-hl48-device-regression-20261113`, build source `5d1347408904eaf934b629dc07810eff759e1880` sửa đúng vị trí `picker.opaque=NO`, đưa HUD vào Dock UIWindow, bridge ACKed lưu Lề qua SpringBoard, hook kéo owner Lề, bỏ chuỗi km/h trên LeBubble FAT và loại mã/tài nguyên SpeedBubble cũ (giữ một row cấu hình DuoCar).
- **CI BUILD PASS** run [43392091835](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/43392091835), artifact `DuoCar49` ID `14020779162`; bản DEB đã tải và kiểm trực tiếp: Package `com.chuong.duocar`, version `1.0.3-le0242`, **2.331.264 bytes**, SHA-256 `839730f7d2562fe8da2f21d972d6a7be2debbdc7b8da289f7878dc0ae26fa42b`. Đã xác minh 18 Mach-O có arm64/arm64e + code signatures, 9 Le vendor dylib, menu/Dock markers, không có SpeedBubble files. **Còn chờ Nguyen nghiệm thu xe**, không khẳng định runtime/icon/picker đã hoạt động. Không có overlay nhiệt 39°C ở bản này.
- Điểm khôi phục và cổng xe: [HL48_DEVICE_FAIL_FORENSIC_20261113.md](HL48_DEVICE_FAIL_FORENSIC_20261113.md) (phần HL49 cuối file). Chưa merge main, không publish Sileo hay phân phối vendor công khai.

## 2026-11-13 — Lề 0.2.4 nguyên gói, tích hợp qua DuoCar (source staging)
- Nguyen yêu cầu dùng nguyên bộ binary vendor Lề 0.2.4 thay vì viết lại feature. Source nhánh `feature/duocar-le024-full-20261113` đã nối Cài đặt Lề gốc vào DuoCar UIKit (`OMCLePrefsHost`), giữ stepper GPS -5..+5 và soạn extension ABI-guarded sửa speedText + kéo X/Y. Bộ trộn ba input DEB ký sẵn thành **một `duocar.deb` cá nhân** giữ nguyên 9 Le dylib, LePrefs + fonts và loại old SpeedBubble, kiểm SHA vendor và firmware <27; có fixture test. **Source chưa được build iOS, extension chưa nghiệm thu, DEB thật chưa được trộn do connector không tải được raw file .deb và container DNS không tới GitHub.** Không có single-DEB final hay device PASS.
- Điểm khôi phục đầy đủ: [LE024_DUOCAR_MIGRATION_20261113.md](LE024_DUOCAR_MIGRATION_20261113.md). Lệnh gói/test: [LE024_ONE_DEB_PERSONAL_BUILD.md](LE024_ONE_DEB_PERSONAL_BUILD.md). Chưa xác minh quyền phân phối mã vendor; chỉ dùng thử cá nhân.


## 2026-11-13 — Lề 0.2.4 traffic migration + hiệu chỉnh tốc độ GPS của xe
- Theo yêu cầu Nguyen, thay toàn bộ runtime SpeedBubble cũ bằng tính năng bong bóng giao thông Lề 0.2.4; giữ lại entry Cài đặt > Bong bóng tốc độ trong **DuoCar UIKit** để làm giao diện cấu hình mới. Đặc biệt `leTrafficGpsOffsetKph` -5..+5 bước 1 hiệu chỉnh **tốc độ GPS xe đang đi**, tuyệt đối không đổi tốc độ giới hạn hay tốc độ tối đa ứng dụng. Bong bóng GPS chỉ hiện số, kéo tự do như bong bóng giờ-pin-nhiệt; Lề còn nguyên biển báo, làn đường, thẻ Google Maps và nguồn VietMap/GOFA/Waze.
- Nhánh `feature/duocar-le024-full-20261113` từ HL47, đã bỏ target cũ khỏi aggregate Makefile, thay trang cấu hình với UIStepper ± và đồng bộ src/project; **mới UI+build-graph, CHƯA có runtime Lề, CHƯA nối consumer offset, CHƯA build hay device-pass**. [Checkpoint LE024_DUOCAR_MIGRATION_20261113.md](LE024_DUOCAR_MIGRATION_20261113.md). Đừng nhầm số GPS đã hiệu chỉnh với posted speed limit.


## 2026-11-12 — HL40 restored original ABKeyboard for hosted + MultiTA-style native drawn bridge (SOURCE ONLY)
- Nguyen explicitly superseded the hosted/native split from 18:xx: **both hosted unsupported apps AND native CarPlay apps must display a drawn keyboard**. This does not mean original OmniCar already drew for native. The native extension is NEW; its presenter runs in CarPlayApp and its client in the actual first-responder process, with distinct focus/command/ACK channels. Do not present as original binary behavior or claim device PASS without testing.
- Original OmniCar 1.0.3 `ABKeyboard.m`, `ABTelex.m` and `appbridge.keyboard`/`appbridge.key` are restored for hosted; the keyboard's original painting/layout/Telex is preserved with four tiny native adapter hunks (host window, send path, declaration, layout area). Reverse those four adapters against original `ABKeyboard.m` and byte compare is exact.
- Native new `ABNativeDrawnTA.m` (src/project): injected via existing `com.apple.UIKit` filter (verified locally from signed HL37 DEB); `AppBridgeEntry.m` starts CarPlayApp presenter and native responder clients incl. CarPlayTemplateUIHost. A transparent touch-through, non-key `UIWindow` is attached to the active CarPlay scene and displays the SAME `ABKeyboard`; clients scan scene responders every 200ms and subscribe to text-focus notifications, use zero-sized `inputView` + `reloadInputViews`, send `nonce+seq+ACK` commands to `UIKeyInput` first responder. No native `UIRemoteKeyboardWindow` resize; older `ABKeyboardTraits104` module remains linked but inactive for hosted. This is our independent implementation of the architecture, NOT a copy of MultiTA code.
- Original `-[ABHost zoom]` default 80%, menus, dock, picker, pinch and voice-off kept; explicit hosted/native discriminant remains. Only approved launch/connectors touched. Branch target `feature/duocar-hl40-drawn-all-20261112` created from baseline `4c317cfcf73a1c9c8ef762aec457b176c5e15322`; staging is via Git trees, NOT yet a commit unless update_ref confirms. Version `1.0.3-hl40drawall1`; no CI/FAT per Nguyen. Local environment has `dpkg-deb` and host clang but **no iPhoneOS SDK/Theos/ldid**, so binary compile and signed installer cannot be verified here. **NO runnable HL40 DEB produced** yet. Do not relabel HL37/HL39.
- Required next gates: compile and sign ONE arm64 DEB on a valid toolchain, verify UIKit symbol linkage and installability, test original keyboard hosted YouTube/TikTok, native Maps/Music/Google Maps template host, focus return/delete, onscreen touch, transitions, reconnect, suppression of native system keyboard, and no double overlays; logs same PID/revision. Only Nguyen can grant on-vehicle PASS.
- Detailed source patch and limitations: [HL40_DRAWN_ALL_20261112.md](HL40_DRAWN_ALL_20261112.md).


## HL40 original-hosted keyboard source restored — 2026-11-12
- Nguyen orders original OmniCar 1.0.3 split: **hosted unsupported apps use drawn ABKeyboard, native CarPlay apps use their own system keyboard**; keep original 80% `appBridgeZoom`, ratio menu, Dock, pinch, settings and voice-off. From base `4c317cfcf73a1c9c8ef762aec457b176c5e15322` on branch `feature/duocar-hl36-original-zoom-20261112`. This supersedes HL36 native-only for hosted apps only.
- Host: restore `ABKeyboard.m`/`ABTelex.m` compilation, Darwin `appbridge.keyboard` dispatch and `appbridge.key` channel. `ABKeyboardDispatch` checks `ABHost.paneFor:bundleID` before any show and feeds existing kb-sync lifecycle. Host mode returns native=NO/drawn=YES only for AppBridge-hosted pane path; native CarPlay views are separate.
- App: restore original zero-size `inputView` on hosted first-responder before become, restore on resign, publish original Darwin focus packet, restore original `ABKeyBlock` text/return/dismiss and register receiver by bundle. Retain BW wake/kbstate and YT orientation code but disable native UIKit keyplane path via `ABDrawnKb=YES`. Original `ABKeyboard.m` and `ABTelex.m` blobs unchanged. Menu/zoom untouched.
- Package candidate `1.0.3-hl40origkb1`, **SOURCE ONLY**, no native Theos/iOS SDK/ldid locally, no CI per Nguyen direct request, no actual DEB compiled, no device PASS. Do not claim solved. Verify source full branch commit and new isolated static checker before offering binary. Later builder must sign and verify actual arm64 DEB.
- Work details and exact paths: [HL40_RESTORE_ORIGINAL_HOSTED_KEYBOARD_20261112.md](HL40_RESTORE_ORIGINAL_HOSTED_KEYBOARD_20261112.md).


## 2026-11-12 — HL36 keyplane/window sync cho hosted app (SOURCE COMMITTED / DEVICE PENDING)
- Nguyen xác nhận trên xe **bàn phím các app CarPlay hệ thống hoạt động đúng**. Sửa riêng đồng bộ `UIRemoteKeyboardWindow` ↔ UIKit keyplane của app hosted trên nhánh `feature/duocar-hl36-keyplane-sync-20261112` từ HL36 `fa21883e`: defer viewport khi keyplane còn tràn; dùng `reloadInputViews` có focus/revision/epoch guards; giữ native apps, YTZ/Dock/picker/zoom/voice-off và không hồi sinh drawn keyboard. 3 cặp `project/src` đồng nhất, kiểm connector tĩnh 21/21, **chưa chạy Python/CI/build/DEB, chưa device PASS**. [Checkpoint chuyên đề](HL36_KEYPLANE_SYNC_20261112.md).



## 2026-11-10 — HL12 BUILD PASS + SIGNED DEB VERIFIED (GPT tự đóng theo lệnh Nguyen)
- **Đã đóng/ký/kiểm chính DEB**: `com.anlai.omnicar_1.0.3-hl12dock_iphoneos-arm64.deb` (1,288,178 bytes, SHA256 `eb5bedc061d5bf75b1a77d1e4ea3a2b95b9661cb6fee8bef76c7d94436b33c7e`); ZIP GitHub artifact ID **13752542228**, [CI run 42793083818](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/42793083818) **SUCCESS**. Source build HEAD `fb14c99`, 9 fixture HL8 + FAT arm64/arm64e + ký/HL8–HL12 marker PASS; Python kiểm độc lập trên chính DEB xác nhận 6 dylib/12 slices và LC_CODE_SIGNATURE. **DEVICE PENDING**; Maps trắng khi gõ vẫn chưa sửa. Nguyen giao GPT tự đóng vòng này; không chờ Muse, không Sileo/merge main. [Biên bản và hash](HL12_HOME_DOCK_20261110.md).

## 2026-11-10 — HL12 SOURCE-COMMITTED: OmniCar Home có, Dock chưa nhận active
- Nguyen xác nhận phiên xe HL11 15:33–15:38: icon Home xuất hiện, tap mở đúng panel; **Dock trái thiếu icon OmniCar**. TikTok keyboard window 238×300 có pixel, nhưng Maps có lúc trắng khi gõ nên UI **CHƯA ĐẠT**. Log trực tiếp CarPlay PID 41737 15:37 chỉ chứng minh Home route, không chứng minh Dock.
- GPT thêm đồng bộ AppHistory/active Dock/refresh + Dock tap vào panel sẵn có, category OwnID=Other bảo vệ Maps và observer lifecycle, **6 file src/project**, nhánh `feature/hl12-home-dock-gpt-20261110` commit `7f24fa79b538690f7d2e0ff7d336d7f7cb87e832`, nền HL11 `1722cfe`. Đối xứng code và review tĩnh đạt; **CHƯA BUILD HL12/CHƯA DEVICE PASS**. Muse vẫn tích hợp/ký **một DEB**, không CI/merge/Sileo do GPT. Hồ sơ: [HL12_HOME_DOCK_20261110.md](HL12_HOME_DOCK_20261110.md).

## 2026-11-10 — HL11 BUILD PASS: native keyboard, native Logo, picker same-window
- **CI thật:** `ci-fat-test` HEAD `5f7d4a0`, [run 42781775810](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/42781775810) SUCCESS. FAT arm64/arm64e, 9/9 analyzer fixtures và HL8→HL11 binary markers PASS. **DEB đã tải về, giải nén và kiểm độc lập**: `com.anlai.omnicar_1.0.3-hl11nativekb_iphoneos-arm64.deb`, 1,284,808 bytes, SHA256 `6d6211bd56c9d3cc688e430d533fd9f3d628b63e73ec99e89eb691b465297952`; ZIP artifact `13746456934` [lấy tại đây](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/42781775810/artifacts/13746456934).
- **Chưa nghiệm thu xe:** chỉ pinch đã DEVICE PASS từ HL8. Bàn phím native học từ DuoFace QA179–181, Logo native HL9, picker HL10 đều **PENDING** trên xe. Không gọi build xanh là pixel PASS. Chưa merge main, chưa Sileo. Checkpoint đầy đủ [HL11_DUOFACE_KEYBOARD_INTEGRATION_20261110.md](HL11_DUOFACE_KEYBOARD_INTEGRATION_20261110.md); dòng "CI đang chạy" dưới đây là lịch sử trước khi build hoàn tất.

## 2026-11-10 — HL11: native keyboard repaired from DuoFace source; one integrated build
- **Đã sửa source:** `ABInApp.m` app-side keyboard native in YouTube/TikTok: tìm `UIRemoteKeyboardWindow` trong chính process theo DuoFace QA179–181, căn vào key window của app, retry có giới hạn, restore khi rời session, đo theo PID mà không log chữ gõ. Commit `faa7502`, `b77e4b4`. Hai cây `src/project` cùng byte.
- **Một DEB tích hợp:** nền HL9 Logo + HL10 picker same-window + HL11 keyboard, Version `1.0.3-hl11nativekb`; CI branch `ci-fat-test` tip `5f7d4a0`, [run 42781775810](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/42781775810) đã khởi động. **Chưa DEVICE PASS** cho keyboard/native Logo/picker; pinch HL8 giữ nguyên. Không trộn build trước.
- Bằng chứng DuoFace/OmniCar, hunk, đường hoàn nguyên và phép thử: [HL11_DUOFACE_KEYBOARD_INTEGRATION_20261110.md](HL11_DUOFACE_KEYBOARD_INTEGRATION_20261110.md). Không tự merge/publish.

## 2026-11-10 — HL10 SOURCE-COMMITTED: picker/scene same-window; keyboard native pending
- **Đã sửa source** trên nhánh `feature/hl10-surface-owner-gpt-20261110` từ HL9 CI `c5a437f`: `1f7ee4a` đưa picker và touch shield vào chung UIWindow của split thay vì cửa sổ phụ cấp 1065 khi có pane live; `42c9bb3` giữ mặt sheet trong suốt cả khi đè pane native, đúng hệ tọa độ; `4e35190` stage Version `1.0.3-hl10surface`, CI kiểm markers để tránh dùng DEB cũ. **Không build, không device pass; không đổi pinch**. [Checkpoint và đường rollback](HL10_PICKER_SAME_WINDOW_20261110.md).
- **Vẫn mở:** Logo trên app CarPlay native chạm vào app (HL8 chứng minh, HL9 mới BUILD PASS chưa xe), keyboard **CarPlay hệ thống** ở app không hỗ trợ bị native-lock + không có pixel (không tự bật custom `ABKeyboard`), và mất hình khi đổi app phải xác minh bằng video/test HL10. Không tự coi `hostStructPresent=1` là có hình. Không phát hành Sileo.

## 2026-11-10 — HL9 SOURCE-COMMITTED: Logo native sau fullscreen, pinch HL8 giữ nguyên
- Nguyen báo thử HL8: pinch **33/33 request/applied** (17 expand, 16 restore) đã hoạt động; Logo trên native Maps/Music/Calendar lọt chạm xuống app và YouTube/TikTok không có keyboard. Log mới upload `8b1f4b0`, CarPlay PID `41247` chạm đúng Logo `inLogo=1` nhưng `hidden=1`/forward; nguồn fullscreen assert hidden không hoàn nguyên. 
- GPT trực tiếp sửa phần **Logo**, hai commit source `cc3269b` và `6833299`, nhánh `feature/hl9-logo-native-fs-gpt-20261110` từ HL8 CI `b3da0d5`, 4 file src/project: restore `homeButton.hidden` theo nút sau fullscreen, định tuyến duy nhất single Began đúng 44×44 Logo native tới controller sẵn có, chặn mirror, giữ nguyên pinch. Chưa DEVICE PASS. Điểm nối/từng hunk/rollback ở [HL9_NATIVE_LOGO_FS_RESTORE_20261110.md](HL9_NATIVE_LOGO_FS_RESTORE_20261110.md).
- Keyboard giữ nguyên chính sách **native-only HL3**; nguồn YTZ5 do Muse phụ trách; log xác nhận responder focus 5 lần, native mode lock 17, show publish-blocked 10; không tự bật panel vẽ thay bàn phím hệ thống mà người dùng yêu cầu. Chờ test chủ thể trình bày ở CarPlayTemplateUIHost hoặc quyết định fallback tường minh.

## 2026-11-10 — GPT SOURCE-COMMITTED: HL6 Logo/Wake và pinch fullscreen TOÀN BỘ OmniCar
- Nguyen giao GPT tự sửa Logo, Wake, pinch (đổi phân công ba mục trước Muse); Muse chỉ tích hợp và build/ký một DEB. **Pinch nghĩa là bung/thu cả split + ẩn/hiện dock, không phải zoom video YouTube.**
- Hồ sơ: [HL6_GPT_SOURCE_FIX_LOGO_WAKE_FULLSPLIT_PINCH_20261110.md](HL6_GPT_SOURCE_FIX_LOGO_WAKE_FULLSPLIT_PINCH_20261110.md); nhánh code feature/hl6-logo-wake-gpt-20261110, base main 817bf872, ba commit 58539895 -> 0581d232 -> 234c5207, 10 path src/project, ahead=3/behind=0.
- Log HL6 cũ PID 40220/40229 có marker mới; source patch mới **CHƯA build, CHƯA CI, CHƯA test xe**. Không merge main hay phát hành. Bắt buộc bump control Version cho DEB vòng tới.


## Kiểm tra trực tiếp hai log HL5 — 2026-11-10
- **Đã đọc log gốc và tách đúng 2 phiên HL5 theo PID/time:** [HL5_TWO_LOGS_GPT_REVIEW_20261110.md](HL5_TWO_LOGS_GPT_REVIEW_20261110.md). Nguồn 2 blob ở `logs/OmniCar.log.old` + `logs/OmniCar.log`, upload `d94d6c9`. Kết quả 21/21 nuốt có ACK app, 0 timeout; act 133/133; feed 454/454; YouTube pinch A 2/2 (bung+thu), B 0 toggle (186 probe B đều 1 Began). P0: logo split tạo thoáng rồi bị dock placement retire, guard `transition-250ms` gây lọt chạm sớm có mẫu, reporter không revoke khi đổi A→B. Picker clear-face 4/4 nhưng close-done slot=-1 4/4 do ghim slot quá muộn. Home grid 6/6 route; Home hệ thống là đường khác. Native keyboard/video pixel chưa có log đủ kết án. GPT chỉ rà log/source, không build/test/sửa source Muse.

## Phán quyết mới nhất — HL4 → HL5 (2026-11-10)
- **Kết quả đối chiếu trực tiếp log HL4 + source và toa xử lý cho Muse:** [HL4_TO_HL5_VERDICT_20261110.md](HL4_TO_HL5_VERDICT_20261110.md). Pinch TikTok 22/22 (11 bung + 11 thu), nuốt 4, picker sheet effect là vật che ưu tiên sửa, logo trong split chết do cổng grid-only chặn trước placement, kbstate reporter cần phản hồi xác nhận assignment độc lập kb-known/STATE last-value, không rút ngắn timeout mù; act bad-hash sau teardown 184 s, ACK timeout 1 ca chưa rõ điểm nhận. Native pinch tách giai đoạn. Chưa sửa source Muse, chưa build/CI/xe ở lượt GPT; verdict là log/source, không tự gọi device pass.

## Phán quyết mới nhất — log hl3 → sửa hl4 (2026-11-10)
- **Đối chiếu trực tiếp hồ sơ/log/source, work order cho Muse:** [HL3_HL4_L1_L8_RULING_20261110.md](HL3_HL4_L1_L8_RULING_20261110.md). L1: dedup `bwHandledSeq[slot]` không reset theo gen khi re-host, khớp 7/7 ACK timeout; đề nghị reset theo gen trước đóng gói hl4. L2: ca 123 ms khớp guard transition 250 ms; gap seq toàn owner không phải bằng chứng mất state. L3/L4: `dir=0` đã SOURCE-COMMITTED nhưng còn cần test xe và rà OFF. L5/L6: measure3 đã bổ sung, cancel còn thiếu quan sát hậu animation. L7: silence 5 s không chứng minh teardown. L8: weather NO-DATA. GPT chỉ phán/quyết định và lưu hồ sơ; không sửa mã Muse, không build/CI hay xác nhận xe.

## Checkpoint hiện hành — đã đọc log xe YTZ5HL1 (2026-11-09)
- **Đã kiểm log xe YTZ5HL1 ngày 09/11 (blob GitHub):** [YTZ5HL1_LOG_REVIEW_20261109.md](YTZ5HL1_LOG_REVIEW_20261109.md). Nguồn commit upload `5e745bc`, hai phần `logs/OmniCar.log.old` (9.205 dòng) và `logs/OmniCar.log` (5.113 dòng). Theo PID: Home 11/11 callback→panel; picker hasContent=1 ×2 nhưng xe vẫn che hình; native keyboard 75 ACTIVE và 148 emit ACTIVE nhưng **không xuất hiện trên màn xe**; Gate 3 4/17 wouldSwallow, ENFORCE chưa bật; pm=0 trên PID có Home, pinch chưa test; AutoHide fade/reveal có log. Hồ sơ ghi điểm nối, khuyến nghị có điều kiện, ranh giới chứng cứ; GPT chưa đổi mã/CI ở vòng kiểm log này.

## Checkpoint mới nhất — Home launcher nguồn đã thi công (2026-11-09)
- **Phán quyết YTZ5HL1/Gate 3/Pinch/Keyboard/Picker (2026-11-09):** [YTZ5HL1_GATE3_PINCH_RULING_20261109.md](YTZ5HL1_GATE3_PINCH_RULING_20261109.md) — source/IPC/gesture arbitration, năm câu trả lời cho Muse, ranh giới test xe và đường sửa. Chốt thiết kế, **chưa thi công mã Muse/chưa DEB mới**. Bản ytz5hl1 CI 42622552103 đã thành công theo hồ sơ Muse; Nguyen báo Home tile/tap đạt, native keyboard và picker thất bại ở mức nhìn màn hình, log phiên chờ đối chiếu.

- **Quy tắc truy cập GitHub mới (Nguyen, 2026-11-09):** GPT chủ động đọc, đối chiếu và cập nhật hồ sơ/source trong phạm vi quyền đã cấp, **không hỏi lại quyền truy cập GitHub ở từng lượt**. Quy tắc này không cho phép tự merge code vào main, tự chạy CI/build/deploy/Sileo, xóa dữ liệu hoặc liên hệ Muse ngoài ứng dụng nếu chưa được giao. Xác nhận bắt buộc của nền tảng (nếu có) vẫn do nền tảng kiểm soát.

- **Quyền truy cập GitHub (chỉ thị mới 2026-11-09):** GPT chủ động truy cập GitHub đã kết nối để đọc, đối chiếu, sửa mã đúng nhánh được phân công và cập nhật checkpoint; không hỏi lại Nguyen về quyền truy cập mỗi lần. Không coi điều này là quyền tự merge main, dispatch CI, deploy, phát hành Sileo, xóa dữ liệu hay liên hệ Muse bên ngoài. Nếu nền tảng yêu cầu thao tác xác nhận kết nối, đó là cơ chế cấp quyền riêng.

- **Làm việc GitHub theo chỉ thị Nguyen 2026-11-09:** GPT chủ động truy cập GitHub đã kết nối để đọc/đối chiếu source, commit phần GPT trên nhánh thuộc phạm vi được giao và lưu/kiểm checkpoint; không hỏi xin phép truy cập lại mỗi lượt. Quyền này KHÔNG mở rộng thành tự merge vào main, dispatch CI, build/đóng gói giao xe, phát hành Sileo, xóa dữ liệu hoặc liên lạc Muse ngoài ứng dụng. Nếu nền tảng yêu cầu xác nhận kết nối ở cấp hệ thống thì cơ chế xác nhận thuộc nền tảng, không phải bước GPT tự xin lại.

- **Hồ sơ bàn giao và bằng chứng:** [HOME_LAUNCHER_HANDOVER.md](HOME_LAUNCHER_HANDOVER.md). Đây là hồ sơ chi tiết, có file/hunk, 4 commit, test và bước cho Muse; không tạo đầu mối thứ hai.
- Repo duy nhất `chuongnguyen89dn-ui/Omnicar`; cây `recovered-source/`. Nhánh code **đã xác minh tồn tại**: `feature/omnicar-home-launcher`, nền main `3e25499d62cb471e0aa468871535182eb7abaec8` (đã có YTZ5 `e6b50a4`), tip mã `050eddb0ada8be356dc61ccb27852dd5c837b97c`.
- **SOURCE-COMMITTED / STATIC-CHECK PASS**, 5 commit chỉ trên nhánh feature; chưa merge code main, chưa build Theos/ldid, chưa CI mới, chưa có DEB cuối hoặc device test. GitHub compare base..feature: ahead=5/behind=0, 14 file path đã đổi (trong đó 4 file mới là cặp src/project).
- Thành quả nguồn: đăng ký đúng `com.anlai.omnicar.app` không phụ thuộc `appBridgeApps`; synthetic `DBApplicationInfo` declaration; visibility own-icon; hook icon-tap `DBDashboardHomeViewController iconManager:launchIconForIconView:` ABI iOS16.7.16 `v32@0:8@16@24`, original pass-through cho mọi app khác; route vào **panel layout hiện hữu** trên `SCPCarSplit` (giữ dock, không mở Settings), log presence/model/cell/tap; hook đo close YTZ5. Chưa gọi là runtime/device PASS.
- Muse YTZ5 đã source-complete ở main; run CI 42615117251 hoàn tất trước phân công nhưng **không** lấy làm artifact bàn giao; DEB tổng hợp hoãn tới lúc Muse tích hợp nhánh GPT. **Cần làm tiếp:** Muse ghép hunk với YTZ5 và đồng bộ build staging `src → project`, biên dịch/kiểm định rồi build/ký **một DEB**; Nguyen test xe theo kịch bản trong handover. Không giao DEB từ phía GPT.
- **Cảnh báo có căn cứ:** `src/SplitScreenC/SCPHomeApply.m` YTZ5 khác bản `project/OmniCarSplitScreen/SCPHomeApply.m` trên main; không copy bản project cũ đè src. GPT không chỉnh phần lõi YTZ5/AutoHide/keyboard/picker/scene. Không có checkout local được xác nhận; gọi thử GitHub qua shell bị lỗi DNS, các thao tác repo thực tế dùng GitHub connector.

## Hồ sơ nền trước khi triển khai — 2026-11-09 (giữ để truy lịch sử)
- Repo: chuongnguyen89dn-ui/Omnicar. Dự án thi công: recovered-source/.
- Đầu mối chung hiện có: recovered-source/TIEP_TUC_DU_AN.md. File này là hồ sơ CHUYÊN ĐỀ GPT, không thay thế đầu mối chung.
- HEAD đã kiểm trước khi ghi hồ sơ: 38735c5bef6dc22ca9cb11f4e894725ce494be41.
- Phân công mới của Nguyen: GPT trực tiếp triển khai icon của CHÍNH OmniCar trên lưới CarPlay Home; Muse tiếp tục YTZ5 và là đầu mối tích hợp/build/ký một DEB tổng hợp.
- Nhánh dự kiến cho code: feature/omnicar-home-launcher. CHƯA TẠO. Không ghi rằng code hoặc build đã bắt đầu.
- Chưa sửa source, chưa build, chưa khởi động CI trong phần việc Home launcher. Không có thay đổi code chưa commit do GPT tạo trong nhiệm vụ này.
- Các đường dẫn VM ghi trong hồ sơ Muse không phải môi trường GPT đã xác minh.

## Mục tiêu và phạm vi
1. Icon OmniCar có trên lưới CarPlay Home, không chỉ là nút UIButton trên dock.
2. Chạm icon mở giao diện bố cục/split hiện có; không mở nhầm app cài đặt iPhone hoặc tạo controller split độc lập.
3. Giữ nút dock; nghiệm thu icon sau đóng split lúc hiện/mờ, đổi app, ngắt–nối và khởi động lại process.
4. Chỉ sửa trong recovered-source/; đọc logs/ của repo để lấy bằng chứng được phép. Không sửa phần dự án gốc ngoài phạm vi.
5. Không tự sửa AutoHide, bàn phím, YTZ, native feed hoặc các hạng mục Muse đang làm.

## Dữ kiện đã kiểm trực tiếp
- SCPAppIcons.m: SCPChosenPhoneApps lấy appBridgeApps; SCPAddChosenAppsToLibrary thêm proxy; SCPInjectDeclarationIfChosen ghép CRCarPlayAppDeclaration cho app được chọn.
- SCPHooks.m: hook _newApplicationLibrary / _loadFromProxy:; các hook launch chuyển app injected sang AppBridge.
- SCPCarSplit.m: nút launcher hiện tại là UIButton gắn bằng addSubview, homeButtonTappedUnsafe mở panel bố cục.
- Chưa chứng minh có đường tự đăng ký riêng chính com.anlai.omnicar.app trên Home. Đưa bundle vào AppBridge không tự chứng minh đúng hành động launch.
- Log đã đọc ở logs/OmniCar.log và logs/OmniCar.log.old tại HEAD trên; cuối log hiện tại 2026-11-09 17:44:31.969. Đây là dữ kiện nền, không phải nghiệm thu tính năng Home mới.

## Phối hợp và tích hợp
- Code ở nhánh riêng; checkpoint đầu mối này trên main theo yêu cầu người dùng.
- Không ghi đè file Muse. Nếu chung file, bàn giao từng hunk/commit và đọc lại phiên bản mới trước tích hợp.
- Đồng bộ src/project theo cấu trúc build thật.
- Muse ghép commit, build/ký bản cuối. GPT không tự publish/Sileo/merge code khi chưa được giao.
- Không tự gửi tin nhắn bên ngoài cho Muse. Bàn giao qua repo và người dùng.

## Quyết định YTZ5 được báo ban đầu (trạng thái thi công mới xem checkpoint trên)
- Muse báo đã lập CHANGE_MAP_YTZ5.md, chưa build ở thời điểm báo.
- GPT đã duyệt thiết kế vận chuyển trạng thái phiên nhập liệu app→owner có assignment/gen/session/seq; không được coi first-responder là chứng minh phím hiện trên xe.
- UNKNOWN không được biến thành INACTIVE; reset cùng-bundle/cùng-slot; chống renewal làm tươi giả nguồn cũ.
- Tắt panel cũ phải vô hiệu nguồn panel, không phát INACTIVE giả cho phiên nhập liệu còn sống.
- AutoHide theo bảng assignment; cleanup không phá suspend của chế độ hosted-solo đích.
- Pinch mặc định OFF; icon instrument model/dock chưa phải cell; không thêm event-1 vô điều kiện ở goHome=NO.
Các mục này thuộc Muse; phải đọc hồ sơ mới của Muse để biết trạng thái hiện hành.

## Bước tiếp theo dự kiến ban đầu (đã được thay thế bởi checkpoint ở trên)
1. Đọc file này, hướng dẫn GPT và TIEP_TUC_DU_AN.md bản mới nhất.
2. Kiểm tra main/nhánh, commit và job đang chạy trước khi tạo nhánh feature/omnicar-home-launcher.
3. Đọc app bundle/Info.plist, launcher và hooks Home/launch; xác định danh tính và hợp đồng launch riêng cho icon OmniCar.
4. Lập bảng file/hunk thuộc GPT, điểm chung với Muse; triển khai ở nhánh riêng sau khi đủ căn cứ.
5. Kiểm tại chỗ, bàn giao commit và kịch bản xe. Chỉ chấm DEVICE PASS khi có test xe đúng artifact.

## Nhật ký
- 2026-11-09: Nguyen xác nhận phạm vi mã nguồn là URL repo/main/recovered-source, không phải một repo khác. Sửa nhầm lẫn trước đó: cùng repo nhưng khác cây thư mục.
- 2026-11-09: Nguyen yêu cầu tạo mục lịch sử GPT trong recovered-source/ và lưu hướng dẫn đầy đủ trước khi thi công code.
- 2026-11-09: Đã đọc cây main và recovered-source/TIEP_TUC_DU_AN.md qua GitHub. Đầu mối chung tồn tại; tạo hồ sơ GPT chuyên đề, giữ nguyên lịch sử Muse.
- Các thao tác của checkpoint này dùng GitHub connector: fetch tree main recursive; fetch_file TIEP_TUC_DU_AN.md; create_file hai hồ sơ GPT; update_file thêm liên kết đầu mối; fetch_file đọc lại. Không chạy lệnh shell/build/job. Commit xác nhận nằm trong lịch sử GitHub của các file, không bịa ID trong nội dung trước khi tạo commit.

- 2026-11-09: Theo Nguyen, xóa file hướng dẫn ChatGPT đã lưu thừa khỏi repo; hướng dẫn Project do người dùng lưu trong ChatGPT. Giữ hồ sơ lịch sử GPT tại đây.
- Phối hợp build: Muse hoàn tất/commit YTZ5 và ghi HEAD + file chung; chưa dispatch build DEB tổng hợp. GPT làm Home launcher ở nhánh riêng dự kiến feature/omnicar-home-launcher (hiện chưa tạo, chưa code). Sau khi GPT bàn giao commit thật, Muse ghép vào nền YTZ5 ở nhánh tích hợp, xử lý hunk chung, đồng bộ src/project, kiểm tra và chỉ build một DEB cuối khi cả hai phần đã sẵn sàng. Không chép đè nguyên thư mục hoặc ghép hai DEB. Tên vòng/bản tích hợp chốt sau, không coi đây là artifact đã có.

- 2026-11-09 (checkpoint mã Home): GPT đọc trực tiếp main/Muse YTZ5, hồ sơ DuoFace QA135–146 và nguồn `recovered-source/`; commit source ở nhánh feature: `81e4b23` → `c4641f7` → `14404b2` → `1479711` → `050eddb`; so source và verify GitHub ref, không chạy build/CI. Hồ sơ chi tiết `HOME_LAUNCHER_HANDOVER.md` (main docs commit `bd51eed4aa304ad81b5db6ba87103fda8e284813`). Kết quả: source committed, runtime/car pending; bước tiếp Muse hợp nhất một DEB, Nguyen thử xe. Đường VM Muse không mặc định tồn tại ở GPT.

- 2026-11-09 (mở rộng cổng reentry Home): commit `050eddb0ada8be356dc61ccb27852dd5c837b97c` sửa đúng tình huống app-info **đã có** nhưng declaration **mới được bổ sung**: yêu cầu refresh icon model thay vì chỉ làm khi mới thêm proxy. Đã cập nhật và đọc lại `HOME_LAUNCHER_HANDOVER.md`. Trạng thái vẫn source-only, chưa build/chưa test xe.

- 2026-11-09 20:41 ICT: Nguyen xác nhận không cần hỏi lại quyền truy cập GitHub ở dự án OmniCar; chủ động truy cập và đối chiếu như luồng DuoFace, giữ nguyên giới hạn hành động nhạy cảm. Bản vá rút nút dock tùy biến ở nhánh `feature/omnicar-home-grid-only`, commit `39a42f2812c1b79d5dd425317ffb8a44eb1089aa` đã có; chưa build DEB mới. Handover đã cập nhật ở `HOME_LAUNCHER_HANDOVER.md`, commit hồ sơ `8fc27419aa08b923bacb1489abbd91191847a2c1`.

- 2026-11-09 (quy trình): Nguyen yêu cầu không xin phép lại khi dùng GitHub trong dự án, áp dụng quyền truy cập hiện có tương tự DuoFace. Việc loại nút OmniCar tùy biến trên dock hiện ở nhánh `feature/omnicar-home-grid-only`, commit `39a42f2812c1b79d5dd425317ffb8a44eb1089aa`, chưa có DEB mới hay test xe riêng cho thay đổi này.

- 2026-11-09: GPT đã tham vấn trực tiếp nguồn `integrate/ytz5-home-launcher` commit `8a2c7aa`: **pinch recognizer trong app hosted, `cancelsTouchesInView=YES`, `delaysTouchesBegan=NO`**, không overlay; SPLIT+HIDDEN wake ưu tiên, SPLIT+VISIBLE pinch-out, EXPANDED+HIDDEN pinch-in được ưu tiên (phải sửa conflict `BWGatePass`), hai chiều qua FS controller; Gate 3 chỉ GO theo cổng kiểm scoped hosted, không bật blanket mặc định khi thiếu log; keyboard DRAWN làm fallback mặc định bản sau; picker cần đọc `hasContent` và cover/sheet/shield. Bản quyết định có bằng chứng dòng source, kịch bản kiểm và log gaps ở [YTZ5HL1_GATE3_PINCH_RULING_20261109.md](YTZ5HL1_GATE3_PINCH_RULING_20261109.md). Không sửa src/module Muse.

- 2026-11-09 (review log upload): commit `5e745bc` đưa lên `logs/OmniCar.log.old` + `logs/OmniCar.log`; GPT tải lại qua GitHub fetch_blob theo SHA, đếm markers theo PID/gen, đối chiếu source tích hợp `8a2c7aa`. Đã lập báo cáo tại `YTZ5HL1_LOG_REVIEW_20261109.md` (docs commit `7b6e5d05a088ff64c5441273a71db4eebe48d8aa`). Đầu việc Muse và cổng test xe trong file; không có commit sửa source hoặc build từ GPT.
