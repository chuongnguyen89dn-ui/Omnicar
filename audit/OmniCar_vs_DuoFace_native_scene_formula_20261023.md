# Bằng chứng mã máy gốc: DuoFace Native12 ↔ OmniCar AppBridge YouTube (23/10/2026)

## Trạng thái
**CONFIRMED static ARM64 analysis; DEVICE UNTESTED.** Báo cáo này nối tiếp checkpoint `f5360c9` và audit khả thi tại `audit/OmniCar_vs_DuoFace_YouTube_player_host_comparison_20261023.md`. Đã chạy pipeline phân tích gói chính xác, **không thay đổi 1 byte bản QA12, không có DEB phát hành mới, không cập nhật Sileo**.

- Script: `scripts/audit_v12_omnicar_geometry_machine.py`, commit `381c0e507d5cf6b0052ca2af34da80030a4cda26`.
- Workflow: `.github/workflows/audit-v12-omnicar-yt-scene-machine.yml`, commit `242b23ae4da9d617b0d1fc8a983c0e9dda93335e`.
- GitHub Actions: [run 39923813881](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39923813881), job `120315194603` **SUCCESS**, verified `NATIVE12_OMNICAR_ORIGINAL_SHA_PINNED_MACHINE_CODE_AUDIT_PASS__DEVICE_UNTESTED` và `NATIVE12_OMNI_MACHINE_AUDIT_JSON_INTEGRITY_PASS`.
- Báo cáo đầy đủ: `audit/native12_vs_omnicar_yt_scene_arm64_20261023.json` (blob `b47937215395afd9a31e1063159c28700cb5696e`), commit do workflow đẩy `27bddea8f9ae6d4a1854783a0ba85c882339f158`. GitHub Actions artifact `omnicar-v12-yt-static-geometry`, id `12488846113`.
- Dữ liệu nguồn khớp SHA256: DuoFace v12 DEB `8b7dedf77b9ec05465b83fdb6e2d7127800eac232a34ecf12f2c08b3983a481a`, `DuoFaceDashboard.dylib` `bc1df854ec7a2ddfeec4cb81b080ead34b54df80143d4a8f6254bb8b618003ce`; OmniCar 1.0.3 DEB `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`, `OmniCarAppBridge.dylib` `d99b8d00dc60f69db7b54fc1addaec6b8cb866b8dcdde6f1d85e06ce5b7d6e79`.
- Chỉ checkout repo DuoFace **read-only** tại commit `6193b9e77337fd1e9d586da5e5bf39742d041d2d`, không ghi vào DuoFace.

## Kết luận trực tiếp từ lệnh ARM64

### 1. DuoFace tính reference/native content size theo từng ô

Trong `-[CBBridgedUIAppView calculateNativeSizeForSlotRect:]`, 17 instruction `0xacc28..0xacc68`:

```asm
0xacc28 fcmp d2, #0.0
0xacc2c b.ls  #0xacc5c
0xacc30 fcmp d3, #0.0
0xacc34 b.ls  #0xacc5c
0xacc38 fadd d0, d2, d2
0xacc3c fcvt s0, d0
0xacc40 frinta s0, s0
0xacc44 fcvt d0, s0
0xacc48 fadd d1, d3, d3
0xacc4c fcvt s1, d1
0xacc50 frinta s1, s1
0xacc54 fcvt d1, s1
0xacc58 ret
0xacc5c adrp x8, #0x344000
0xacc60 ldr  x8, [x8, #0x28]
0xacc64 ldp  d0, d1, [x8]
0xacc68 ret
```

Hai input kích thước `d2, d3` dương được **nhân đôi rồi làm tròn qua precision float32** trước khi trả về `d0,d1`; nếu không dương thì trả về một CGSize từ vị trí dữ liệu khác (cần định danh hằng và con trỏ, không mặc định là số 0). Công thức *của phương thức này* tương đương `round(float32(2 * width))`, `round(float32(2 * height))` với rounding của ARM64 `frinta`. **Không đồng nghĩa** YouTube cuối cùng nhất thiết dùng 2× ở mọi tình huống: caller có thể chọn source khác hoặc scale lại.

### 2. DuoFace có scale tự động sau native size

`CBBridgedUIAppView.updateLayout`, instruction `0xad03c..0xad058`:

```asm
fdiv d0, d8, d12
fdiv d1, d11, d13
fminnm d0, d0, d1
ldr d1, [x8, #0xc60]
fcmp d0, d1
fmov d1, #0.50000000
fcsel d12, d0, d1, hi
```

Từ mã máy: lấy **tỉ lệ nhỏ hơn của hai tỉ lệ kích thước** và rẽ nhánh chọn hệ số hoặc literal `0.5`. Giá trị hằng ở `#0xc60`, nguồn các thanh ghi `d8,d11,d12,d13`, semantics chính xác của cảnh/slot và giới hạn cao vẫn cần truy dòng register; không được gắn `0.5` thành thiết lập mặc định trên thiết bị.

`CBBridgeManager.renderSizeForBundleID:` (510 instructions) cũng có đường `fadd(d8,d8)`, `frinta` tại `0x24ce88..0x24cea4`. Có **đường 2× được phát hiện độc lập** trong render size manager, nhưng chưa chứng minh một nhánh cụ thể thuộc YouTube bằng trace live.

### 3. OmniCar AppBridge tính geometry khác

`ABHost.zoom` có `fdiv d8,d0,d1`, `fmaxnm`, `fcsel` (xem static audit 19/10: preference / 100, clamp 0.6–1.0).

`ABHost.layoutPane:` tại `0xed74..0xed80`:

```asm
fdiv   d0, d8, d12
frinta d10, d0
fdiv   d0, d9, d12
frinta d11, d0
```

Với `d12` là đường zoom hiện tại, bản gốc tính reference/logical frame chia theo zoom, làm tròn. Đồng thời `0xedd0..0xedd4` có `fmul` với literal `0.5`; `setFrame:forApp:live:handle:passInsets:` cũng lặp đường trung điểm hình chữ nhật ở `0xfff4..0xfffc` và `0x10110..0x10118`. Các phép nhân `0.5` đó **không được xem là tỷ lệ render 0.5**: code nhiều khả năng liên quan tính center, chưa có chứng cứ mapping toàn bộ thanh ghi.

### 4. Phạm vi so sánh thực tế

Đã disassemble chính xác 7 method DuoFace (17, 596, 548, 3, 54, 510, 84 instructions) và 4 method OmniCar (29, 264, 122, 210 instructions). Báo cáo JSON chứa tất cả instruction, số PC, phép toán floating/int và call/branch để tiếp tục dataflow, không chỉ metadata selectors.

**Khác biệt có chứng cứ:** DuoFace cung cấp phương thức native size theo slot **nhân đôi** và scale bằng min(widthRatio,heightRatio); OmniCar có đường scene logical size **chia zoom chung**. Đây là hướng điều tra hợp lý cho YouTube phóng to/méo bố cục. **Chưa xác định** nguyên nhân crash hay 3 chấm Solo, chưa có cùng YouTube trên 2 thiết bị để chứng minh cách bố trí video cuối cùng.

## Quyết định kỹ thuật & bước tiếp theo

- **Không copy trực tiếp** `DuoFaceDashboard.dylib`, `CBBridgedUIAppView` hoặc chủ quản scene từ DuoFace vào OmniCar.
- Không thay QA12 `1.0.3-omnicar12-timer-zoom-swap` đang Sileo, không sửa menu/Zoom/Swap/4-second timer/Solo/divider hoặc app khác chỉ dựa vào phép tính static.
- Tiếp theo cần **read-only bridge diagnostic** có scope đúng app YouTube: log bundleID (không log account/video), pane bounds, sceneBox, referenceSize, orientation, preference zoom, transitions split/solo và touch/frame updates; đồng thời ghi cùng các trường tương ứng từ Native12 nếu có thiết bị tham chiếu đang chạy. Chỉ khi biết owner + actual size cần chọn logic per-app/layout adapter, không global patch.
- Test bắt buộc nếu thực thi adapter sau này: cùng YouTube build và màn CarPlay khi đỗ; map+map, YouTube+map, YouTube Solo, playback/touch, split ratio kéo, Zoom/Swap, timer hide/wake, nút ba chấm, crash log. CI ARM64 và artifact riêng; **không publish Sileo khi chưa có device acceptance**.

## Tái tạo đã chạy

Workflow checkout chính xác OmniCar main và DuoFace SHA đã pin, tạo Python venv + `pip install capstone==5.0.7`, `python -m py_compile`, kiểm `sha256sum -c` trên cả hai DEB, chạy:
```bash
python scripts/audit_v12_omnicar_geometry_machine.py \
 --duoface duoface-reference/dist/visual-1.0.3-12/com.duoface.app_1.0.3-12_visualtest_iphoneos-arm64.deb \
 --omnicar com.anlai.omnicar_1.0.3_iphoneos-arm64.deb \
 --output audit/native12_vs_omnicar_yt_scene_arm64_20261023.json
```
GitHub Actions run/job/commit nêu ở đầu là bằng chứng thực thi. Không có hành động trên thiết bị trong lượt này.
