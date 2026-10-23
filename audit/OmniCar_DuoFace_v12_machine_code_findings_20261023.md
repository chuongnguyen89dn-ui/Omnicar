# 2026-10-23 — Máy mã ARM64 thực: DuoFace Native12 vs OmniCar YouTube AppBridge

## Bằng chứng mới (không phải dự đoán từ tên selector)

Mã audit **read-only**: `scripts/audit_v12_omnicar_geometry_machine.py`, git blob `ac24065643e3d5f730aee2af57259f1c014b75ed`. CI GitHub Actions run [39923813881](https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39923813881), job 120315194603, **completed success** 2026-10-23 UTC. Bản ghi đầy đủ 274,166 ký tự: `audit/native12_vs_omnicar_yt_scene_arm64_20261023.json` blob `b47937215395afd9a31e1063159c28700cb5696e`, archive commit [27bddea8f9ae6d4a1854783a0ba85c882339f158](https://github.com/chuongnguyen89dn-ui/Omnicar/commit/27bddea8f9ae6d4a1854783a0ba85c882339f158). GitHub Actions artifact ID 12488846113 `omnicar-v12-yt-static-geometry`. Không tạo DEB mới.

Bảo vệ đầu vào bằng SHA256:
- DuoFace v12 DEB `8b7dedf77b9ec05465b83fdb6e2d7127800eac232a34ecf12f2c08b3983a481a`; dylib Dashboard `bc1df854ec7a2ddfeec4cb81b080ead34b54df80143d4a8f6254bb8b618003ce`.
- OmniCar gốc 1.0.3 DEB `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`; AppBridge `d99b8d00dc60f69db7b54fc1addaec6b8cb866b8dcdde6f1d85e06ce5b7d6e79`.
- Chạy Ubuntu 24.04, `dpkg-deb --fsys-tarfile`, `capstone==5.0.7`; cả hai checksum đầu vào `OK`, JSON integrity `PASS`, toàn bộ 11 vùng hàm giải mã đúng số lệnh ARM64.

## Chứng cứ cụ thể mới tìm được

1. **DuoFace `CBBridgedUIAppView.calculateNativeSizeForSlotRect:`, 0xacc28–0xacc68, 17 lệnh.** Khi hai kích thước trong `d2`, `d3` dương: `fadd d0,d2,d2`; chuyển về `s0`; `frinta`; chuyển lại `d0`. Tương tự `d3` → `d1`. Tức **hai đầu vào được nhân đôi và làm tròn số nguyên** (với một bước float32). Nếu kích thước không dương, nhảy `0xacc5c` trả về một hằng kích thước có sẵn. Đây là arithmetic thực sự, không chứng minh giá trị pixel YouTube ngoài đời.
2. **DuoFace `CBBridgedUIAppView.updateLayout`, 0xacc6c–0xad5bc, 596 lệnh.** Tại `0xad03c–0xad058`: hai `fdiv` giữa cặp kích thước, `fminnm` lấy tỷ lệ nhỏ hơn, `fcsel` đưa tỷ lệ dưới ngưỡng lên **0.5**. Bằng chứng về tính scale theo 2 trục và clamp; nguồn từng toán hạng (target/source, đảo orientation) cần liên kết callsites/selector rồi kiểm tra runtime.
3. **DuoFace `CBBridgeManager.renderSizeForBundleID:`, 0x24c920–0x24d118, 510 lệnh.** Có nhiều nhánh chọn kích thước theo bundle, các nhánh `0x24ce88–0x24cea4`, `0x24cf44–0x24cf58`, `0x24d034–0x24d048` nhân đôi rồi làm tròn; không thể coi logic này là một hằng zoom chung cho mọi app.
4. **OmniCar `ABHost.layoutPane:`, 0xec80–0xf0a0, 264 lệnh.** `0xed74–0xed80` lấy kích thước chia bởi giá trị scale và làm tròn; `0xedd0–0xedd4` dùng hệ số **0.5** để tính tâm khung. Bản audit trước đã chứng minh `ABHost.zoom` lấy `appBridgeZoom/100` và clamp **0.6–1.0**. Chưa chứng minh prefs thực tế của người dùng.
5. **OmniCar `ABHost.setFrame:forApp:live:handle:passInsets:`, 0xfe68–0x101b0, 210 lệnh.** `0xfee8` kiểm min dimension với ngưỡng 2; `0xfff8–0xfffc` nhân kích thước với 0.5; `0x100dc–0x100e8` so kích thước cũ/mới trước khi tiếp tục. Đường update hướng/scene cần decode ObjC stubs và thử nghiệm kiểm soát trên xe.

## Kết luận thực nghiệm và phần cấm suy diễn

**Đã chứng minh** hai binary xử lý native size và ratio khác nhau: DuoFace có đường trả về kích thước native gấp đôi theo hai trục và tỷ lệ fit tối thiểu 0.5; OmniCar chia frame cho zoom toàn AppBridge với ngưỡng 0.6–1.0. Điều này có thể lý giải vì sao kích thước điều khiển YouTube khác nhau, **nhưng chưa phải kết luận nguyên nhân chính xác trên thiết bị**. Chưa tìm thấy bằng chứng DuoFace xây một media-player UI riêng để "chuyển nguyên trình phát". Các nút Play/Next của YouTube phải được giữ nguyên để YouTube tự vẽ.

**Không tạo patch vô căn cứ:** nếu áp số 2 hoặc 0.5 vào mọi app hay toàn bộ SpringBoard, có nguy cơ phá mapping chạm/size class/Google Maps, nút ba chấm và native Solo. Bản Sileo QA12 **không thay đổi**.

## Bước tiếp theo có thể thực thi

- Giải mã ngược các ObjC selref/stub cho callsites nằm trong `CBBridgedUIAppView.updateLayout`, `updateSceneSettingsFrame`, `CBBridgeManager.renderSizeForBundleID:` và trong `ABHost.layoutPane:` / `setFrame:forApp:live:handle:passInsets:` để xác định **chính xác tác động vào scene referenceSize, content transform và hit-test**.
- Nếu có log hai sản phẩm đang chạy trên cùng iPhone/YouTube, đối chiếu slot frame, referenceSize, orientation, renderSize, touch event; phân tách layout của YouTube khỏi nút ba chấm AppBridge và Solo.
- Chỉ sau đó mới viết **OmniCar-only YouTube-scoped adapter** rồi static test/ARM64 build trên candidate độc lập; giữ bản QA12 + 176 file gốc + Zoom/Swap/timer/Solo, **không phát hành Sileo khi chưa có kiểm chứng thiết bị**.
