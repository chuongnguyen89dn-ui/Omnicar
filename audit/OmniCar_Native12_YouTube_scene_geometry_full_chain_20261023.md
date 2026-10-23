# OmniCar ↔ DuoFace Native12: nguồn kích thước UI YouTube qua scene settings thật

Ngày 2026-10-23 · **BẰNG CHỨNG MÃ MÁY GỐC/STATIC, THIẾT BỊ CHƯA TEST**

## Mục tiêu và ranh giới

Tiếp nối yêu cầu “Làm đi”: truy sâu `ABHost.layoutPane:`, `setSceneBox:`, `setTransform:` và luồng điều khiển scene iPhone của OmniCar, đối chiếu tính native size của DuoFace Native12. Không bịa UI Play/Next, không ghép trực tiếp DuoFace dylib vào OmniCar, không sửa gói QA12 đang phát hành.

## Nguồn và kiểm thử

- GitHub project: `chuongnguyen89dn-ui/Omnicar`, `main`; DuoFace tham chiếu read-only commit `6193b9e77337fd1e9d586da5e5bf39742d041d2d`.
- Original OmniCar package SHA256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`, AppBridge dylib SHA256 `d99b8d00dc60f69db7b54fc1addaec6b8cb866b8dcdde6f1d85e06ce5b7d6e79`.
- Original DuoFace Native12 package SHA256 `8b7dedf77b9ec05465b83fdb6e2d7127800eac232a34ecf12f2c08b3983a481a`, Dashboard dylib SHA256 `bc1df854ec7a2ddfeec4cb81b080ead34b54df80143d4a8f6254bb8b618003ce`.
- Các script đã thêm: `scripts/audit_omnicar_layout_geometry_policy.py`, `scripts/audit_omnicar_scene_private_selectors.py`, `scripts/audit_omnicar_scene_settings_block.py`. Reuse bộ SHA-pinned Capstone trước; không patch bất kỳ input binary nào.
- GHA run chính: [39928785419](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39928785419) geometry **SUCCESS**, [39929360557](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39929360557) decode 3 private selector **SUCCESS**, [39929670351](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39929670351) inspect scene block **SUCCESS**; [39929842147](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39929842147) archived decoded block selectors **SUCCESS**. Một số run thử decoder ban đầu thất bại `39929096968`/`39929241265` do pointer CFString có bit tag; đã sửa decode thành masked image offset; kết quả thành công đã so cùng original SHA. Run cuối kiểm các selector chính xác `39929982072` cần xác minh kết luận sau khi hoàn tất.
- Artifact báo cáo đã lưu trên chính repo: `audit/omnicar_native12_verified_layout_policy_20261023.json`, `audit/omnicar_original_private_scene_selectors_20261023.json`, `audit/omnicar_original_scene_settings_block_20261023.json`. Blob của ba báo cáo đã fetch/readback: `faee7ad96e2bb3ad896330aebf55a2f7a82ed89a`, `422c122039bb5032bda6ba2598da23a0ef36d54e`, `155be3a9923151839be957d3d07ce6266845abe9`. Các commit archive do bot push tự động ghi trong repo; lấy run cụ thể để đối chiếu phiên bản.

## Phát hiện 1 — Chính xác hình học của OmniCar

Hàm gốc `ABHost.layoutPane:` bắt đầu ARM64 `0xec80`:
- `0xecec` đọc `bounds` của iPhone-host UIView. `0xecf0/0xecf4` đưa hai chiều từ d2,d3 vào **d8,d9**, tương ứng kích thước bên ngoài mà AppBridge phải vừa.
- `0xed18` gọi `ABHost.zoom` (từ preference `appBridgeZoom/100`, clamp 0.6…1.0), lưu hệ số d12 tại `0xed1c`.
- `0xed74–0xed80`: **kích thước frame logic** của app view là `frinta(d8/d12)`, `frinta(d9/d12)`, lưu vào **d10,d11**. Tại `0xed94/0xed98` hai giá trị này được đưa vào `setFrame:` (PC `0xed9c`).
- `0xeda4/0xeda8` cho cùng d12 vào `_CGAffineTransformMakeScale` tại `0xedac`; transform được truyền vào `setTransform:` (PC `0xedc8`). `0xedd0/0xedd4` tính tâm bằng nửa kích thước d8,d9 rồi `setCenter:` (PC `0xeddc`). Không được nhầm phép nhân 0.5 tính **tâm** với scale 0.5 toàn màn hình.
- Cuối `layoutPane:`, `0xf06c/0xf070` đặt lại **d8,d9 (kích thước bounds gốc)**, rồi `0xf074` gọi `ABPane.setSceneBox:`. SceneBox **không được đưa cùng giá trị logic d10,d11** tại lệnh này.
- `ABHost.setFrame:forApp:live:handle:passInsets:` `0x100d8..0x1012c`: đọc `sceneBox`, so với hai kích thước mục tiêu; nếu đồng nhất, chọn nhánh chỉ đặt lại center (`0x1011c`); nếu một trong hai chiều thay đổi, gọi `layoutPane:` (`0x1012c`). **Đây là điều kiện hồi quy khi kéo tỷ lệ chia/switch Solo**. Ngoài các nhánh này còn điều kiện ô quá nhỏ (min dimension 2) và live/handle; không thể ép chạy layout từ ngoài một cách vô điều kiện.

## Phát hiện 2 — OmniCar thật sự tác động vào UIKit scene

Trong `layoutPane:`, không chỉ scale UIImageView. Sau khi lấy `appViewController` nó gọi các private selector bằng `NSSelectorFromString`. Bốn địa chỉ CFString gốc đã giải qua binary pointer bit-tag có tên chính xác:

| PC lời gọi | Selector private | Nguồn |
|---|---|---|
| `0xef08` | `sceneHandle` | `__cfstring` 0x36130 |
| `0xef60` | `sceneIfExists` | 0x36150 |
| `0xefec` | `updateSettingsWithBlock:` | 0x36170 |

Các lời gọi `respondsToSelector:` tại `0xef18`, `0xef70`, `0xeffc` chứng tỏ chương trình kiểm tra khả năng có mặt các private selector trước khi gọi. Đây **không** phải scene path phổ quát của mọi ứng dụng (có thể bỏ qua khi thiếu selector).

`0xf01c–0xf048`: dựng Objective-C block trên stack, đặt block implementation function pointer **0xf210**, descriptor **0x34920**, capture các register `d12,d12,d13,d10,x24`; gửi block tới `updateSettingsWithBlock:`. Đường nối **ABHost layout → private scene settings** đã xác thực bằng máy, không còn chỉ là giả thuyết.

## Phát hiện 3 — Nội dung chính xác block scene tại 0xf210

Từ 4 CFString còn lại trong binary gốc `0x36190,0x361b0,0x361d0,0x361f0`, block `0xf210` gửi các selector thật sau:

| PC | Scene settings selector | Tham số tĩnh quan sát được |
|---|---|---|
| `0xf248` | **`setFrame:`** | Dựng `CGRect` từ 4 double capture ở `[block+0x20]` và `[block+0x30]`, tương ứng d12,d12,d13,d10 |
| `0xf280` | **`setInterfaceOrientation:`** | x2 lấy từ `[block+0x40]`, tức tham số hướng x24 |
| `0xf2b8` | **`setBackgrounded:`** | truyền số nguyên 0 |
| `0xf30c` | **`setForeground:`** | truyền số nguyên 1 |

Các nhánh sau `0xf254`, `0xf294`, `0xf2e8` còn kiểm tra `respondsToSelector` trước khi ghi. Không được đồng nhất `setFrame:` trong scene settings với `ABPane.setSceneBox:`, vì hai đối tượng và hai bộ số khác nhau.

**Quan trọng:** lần này đã tìm được chỗ OmniCar thực sự thiết lập **khung logic và hướng cho iPhone scene**, không phải hook `SBSceneView._updateReferenceSize:andOrientation:` (hook kia chỉ can thiệp x2 và chuyển tiếp original IMP, như báo cáo trước).

## So sánh với DuoFace Native12

DuoFace `CBBridgedUIAppView.calculateNativeSizeForSlotRect:` tại `0xacc28` có đường nhân đôi hai chiều dương + làm tròn; `updateLayout` `0xad03c..0xad058` chọn tỷ lệ theo hai trục; `refreshSceneLayout` gọi cả layout và settings. OmniCar tính frame logic theo `pane bounds / global zoom`, transform cùng zoom, cập nhật scene settings bằng `setFrame:` sau khi xét orientation và `sceneBox` nguyên bounds. Đây là điểm khác biệt đã có PC + selector + dataflow xác minh.

**Chưa được chứng minh:** YouTube trên iPhone của người dùng chạy các nhánh nào; `appBridgeZoom` thiết bị; đối tượng YouTube size-class/safe-area/touch và vì sao các nút Play/Next bị phóng to. Không có bằng chứng DuoFace sở hữu một video-player riêng để cấy vào OmniCar. Mức độ tái tạo giao diện 100% chưa có test thực tế.

## Bước thực hiện tiếp theo, giữ tính an toàn

- Chuẩn bị logging **đúng chủ sở hữu AppBridge và chỉ với bundle YouTube**: pane bounds d8,d9; logical d10,d11; zoom d12; selected orientation x24; frame scene settings; sceneBox; split/ratio/solo và touch mapping. Chỉ log số liệu hình học, không log tài khoản, URL hay nội dung video.
- Khi có đo A/B DuoFace Native12 cùng phiên bản YouTube, viết **OmniCar YouTube-scoped scene sizing adapter** tại đường `ABHost.layoutPane:`/scene settings. Cần cập nhật nhất quán cả frame transform, orientation, scene settings và touch mapping; không hardcode 2×, không áp cho Maps/iPhone apps khác và không sửa native Solo/menu/timer/Zoom/Swap.
- Giữ gói public QA12 `1.0.3-omnicar12-timer-zoom-swap` byte-exact (SHA256 `f07c293a52882ab420aca49e4fe9e30d141d2cba412185938bf09ec9154685ba`). Chỉ build candidate riêng khi có giải pháp được kiểm thử; **chưa** có DEB mới, Sileo publish hoặc device PASS trong bước phân tích này.

## Lệnh tái lập đã thực hiện trên GitHub Actions

```sh
python3 -m venv "$RUNNER_TEMP/v12-geometry-venv"
"$RUNNER_TEMP/v12-geometry-venv/bin/python" -m pip install capstone==5.0.7
"$RUNNER_TEMP/v12-geometry-venv/bin/python" scripts/audit_omnicar_layout_geometry_policy.py \
  --duoface duoface-reference/dist/visual-1.0.3-12/com.duoface.app_1.0.3-12_visualtest_iphoneos-arm64.deb \
  --omnicar com.anlai.omnicar_1.0.3_iphoneos-arm64.deb \
  --output audit/omnicar_native12_verified_layout_policy_20261023.json
"$RUNNER_TEMP/v12-geometry-venv/bin/python" scripts/audit_omnicar_scene_private_selectors.py \
  --omnicar com.anlai.omnicar_1.0.3_iphoneos-arm64.deb \
  --output audit/omnicar_original_private_scene_selectors_20261023.json
"$RUNNER_TEMP/v12-geometry-venv/bin/python" scripts/audit_omnicar_scene_settings_block.py \
  --omnicar com.anlai.omnicar_1.0.3_iphoneos-arm64.deb \
  --output audit/omnicar_original_scene_settings_block_20261023.json
```

Working directory repo OmniCar checkout, `ubuntu-24.04`, `dpkg-deb --fsys-tarfile`, pinned packages. Câu trả lời cho câu hỏi cũ “Có làm được không?”: **Có thể viết bộ chuyển chính sách scene ở đây; không thể khẳng định đúng 100% trước khi test YouTube trên CarPlay thực tế.**
