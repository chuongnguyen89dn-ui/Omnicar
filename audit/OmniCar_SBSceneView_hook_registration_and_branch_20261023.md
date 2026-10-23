# Kết quả mới: xác minh hook `SBSceneView._updateReferenceSize:andOrientation:` của OmniCar gốc

Ngày 2026-10-23. **Bằng chứng gốc ARM64 và Mach-O đã xác minh. KHÔNG thử trên thiết bị.**

## Tại sao kiểm tra

Audit DuoFace Native12 ↔ OmniCar trước đó chưa định danh chính xác implementation private hook `SBSceneView -_updateReferenceSize:andOrientation:` trong `OmniCarAppBridge.dylib`. Phương thức có tên `referenceSize` nên từng được xếp là một nhánh *cần điều tra*, **chưa** được xác nhận có xử lý kích thước video/YouTube.

## Đầu vào và CI kiểm chứng

- Original `com.anlai.omnicar_1.0.3_iphoneos-arm64.deb` SHA256 `d9297b010cdc08e401439b7332413f79cb1a056a05159a5deb673e218d76d9fd`; original `OmniCarAppBridge.dylib` SHA256 `d99b8d00dc60f69db7b54fc1addaec6b8cb866b8dcdde6f1d85e06ce5b7d6e79`.
- Script `scripts/audit_omnicar_sbscene_reference_hook.py`; source commits `44d6f951412582ff5f132d7d0e96b58db97e896b`, `bf60b1c24f0a5840bfca84cf81f66b0185da37e3`, `d99e1e03f3d30c83de3cb04385c1218a7cfd17b2`. Reuse `scripts/audit_v12_omnicar_geometry_machine.py` + `scripts/audit_v12_omnicar_scene_calls.py`.
- Github workflow `.github/workflows/audit-v12-omnicar-yt-scene-machine.yml` revision `5524defdca3f80f9f08c62fcb1ca85ac97069128`.
- **GitHub Actions SUCCESS**: https://github.com/chuongnguyen89dn-ui/Omnicar/actions/runs/39927208157 job `120326430960`, logs `OMNICAR_SHA_LOCKED_SBSCENE_REFERENCE_STATIC_AUDIT_PASS__DEVICE_UNTESTED`, `OMNICAR_SBSCENE_XREF_REPORT_INTEGRITY_PASS`, `READONLY_AUDIT_REPORT_COMMITTED_TO_OMNICAR`.
- Machine report `audit/omnicar_original_sbscene_reference_hook_20261023.json`, blob `a62097dedcc78cccee9a2f5cc46cc52bf7b8a993`, source archive commit `79f7d8567e625f37b793a9ec5b137cc6ec2e9123`. Đã đọc lại theo GitHub.
- Repo DuoFace reference không thay đổi; OmniCar QA12 public `1.0.3-omnicar12-timer-zoom-swap`, SHA256 `f07c293a52882ab420aca49e4fe9e30d141d2cba412185938bf09ec9154685ba`, không thay đổi. Không đóng DEB, không triển khai.

## 1. Đã truy được đường đăng ký hook thật, không còn là string đoán

Tại vùng mã ARM64 `0x6f14..0x6f38` của **original** AppBridge:

```asm
0x6f14 adrp x0, #0x29000
0x6f18 add  x0, x0, #0x326      ; string SBSceneView @0x29326
0x6f1c bl   #0x24788             ; imported _objc_getClass
0x6f20 adrp x8, #0x3d000
0x6f24 ldr  x1, [x8, #0x248]    ; ObjC SEL ref @0x3d248
                                      ; "_updateReferenceSize:andOrientation:"
0x6f28 adrp x2, #0x7000
0x6f2c add  x2, x2, #0x764      ; replacement function @0x7764
0x6f30 adrp x3, #0x3e000
0x6f34 add  x3, x3, #0xa08      ; saved original IMP slot @0x3ea08
0x6f38 bl   #0x243ec             ; imported _MSHookMessageEx
```

Chuỗi `objc_getClass`→SEL từ `__objc_selrefs`→`MSHookMessageEx` đã có xref thực ở cùng một code path. Không cần coi chuỗi log `"SBSceneView -_updateReferenceSize..."` là bằng chứng độc lập về hành vi.

## 2. Quan trọng: thay thế hook này **không hề tự tính lại kích thước video**

Hàm replacement tại `0x7764` có **chính xác 6 instruction**, kết thúc tại `0x7778` bằng branch không điều kiện `br x3`; code tiếp sau `0x777c` là hàm khác, **không** thuộc hook:

```asm
0x7764 adrp x8, #0x3e000
0x7768 ldr  x3, [x8, #0xa08]    ; original IMP đã lưu
0x776c cmp  x2, #4
0x7770 mov  w8, #3
0x7774 csel x2, x8, x2, gt       ; if signed x2 > 4, x2 := 3
0x7778 br   x3                  ; tail-call original IMP
```

**Kết luận đúng phạm vi của mã máy:** wrapper so sánh giá trị số nguyên register **x2** với 4; khi `x2 > 4` theo signed compare thì chuyển thành 3; các giá trị khác giữ nguyên. Sau đó nó chuyển điều khiển về original IMP. Không có phép sửa frame, `CGSize`, `sceneBox`, transform hoặc các thanh ghi FP trong **chính wrapper này**. Theo tên selector, `x2` nhiều khả năng là tham số định hướng (`orientation`); chưa có live ABI trace để khẳng định tuyệt đối về semantic. Hook **không phải** bộ máy sizing/YouTube-player của OmniCar.

Cần phân biệt: khẳng định này chỉ áp dụng **wrapper 0x7764–0x7778**. Bản gốc hoặc `ABHost.layoutPane:` và các hook khác vẫn có thể thay scene size sau khi nhận sự kiện. Không suy từ đây rằng OmniCar tuyệt đối không thay `referenceSize` ở nơi khác.

## 3. Quyết định kỹ thuật mới

- **Loại khỏi danh sách ứng viên sao chép thuật toán video:** không dùng `SBSceneView._updateReferenceSize:andOrientation:` wrapper này để thay DuoFace geometry. Gắn hook mới vào đây dựa trên tên gọi có thể làm lỗi định hướng nhưng không tái hiện Native12.
- Tập trung `ABHost.setFrame:forApp:live:handle:passInsets:` → `ABHost.layoutPane:` → `setTransform:` / `setFrame:` / `setSceneBox:`. Liên hệ với DuoFace Native12 `CBBridgedUIAppView.updateLayout/updateSceneSettingsFrame` (xem `audit/OmniCar_DuoFace_scene_selector_callchain_20261023.md`).
- Tiếp theo: đánh dấu và kiểm chứng tại runtime đúng **YouTube bundle**: host pane bounds, source sceneBox, effective orientation, referenceSize, zoom, touch map, split/solo. Chỉ xây app-scoped size adapter sau khi đối chiếu 2 sản phẩm. Không thay trình phát YouTube hay owner pane menu.
- Bảo toàn QA12 (original Solo, menu 3 chấm, timer 4s, Zoom/Swap, divider), không phát hành trên Sileo khi chưa có build/candidate + test thiết bị.

## Lệnh tái tạo thực sự chạy trong workflow

```sh
python3 -m venv "$RUNNER_TEMP/v12-geometry-venv"
"$RUNNER_TEMP/v12-geometry-venv/bin/python" -m pip install capstone==5.0.7
"$RUNNER_TEMP/v12-geometry-venv/bin/python" scripts/audit_omnicar_sbscene_reference_hook.py \
  --omnicar com.anlai.omnicar_1.0.3_iphoneos-arm64.deb \
  --output audit/omnicar_original_sbscene_reference_hook_20261023.json
```

Các script dùng `dpkg-deb --fsys-tarfile` và so SHA256 DEB/dylib trước phân tích; machine report giữ danh sách selector refs/callsite và từng lệnh (chỉ 6 lệnh thuộc replacement), không xuất thông tin cá nhân.
