# DuoCar — HL21 rebrand & Sileo release, 11/11/2026

## Quyết định người dùng
- Gói HL21 đã tạo từ HL11 keyboard, HL13 pinch, HL14 không nút icon dự phòng và legacy opaque picker được yêu cầu đổi tên **DuoCar**, không còn mang thương hiệu OmniCar ở phần cài đặt/DEB.
- Package mới `com.chuong.duocar`, version dự kiến `1.0.3-hl21duocar`. Đổi app, URL scheme `duocar://`, preference domain `com.chuong.duocar`, classes/symbols `OMC→DCR`, dylibs, PreferenceBundle, PreferenceLoader và địa chỉ IPC. Bắt buộc build lại **từ source** vì sửa nhị phân ký trực tiếp không bảo đảm.
- **Lệnh mới nhất**: Nguyen **tự gỡ OmniCar**. Tuyệt đối **không** thêm Conflicts/Breaks/Replaces để Sileo buộc gỡ `com.anlai.omnicar`; không tự sửa/gỡ gói này. Cũng không gỡ hay viết lại các package khác trên Sileo.

## Bằng chứng và thao tác
- HL21 nguồn cũ: `6b9a011b9e681aebf242b185bbba9c07be7e26ce`, CI `42960173185`, artifact `13828967080`, DEB `/mnt/data/OmniCar_HL21_restored.deb`, SHA256 `d7bdc04cae5cee01d2ce692851a704dff7ae3ee89b759c7bf5adcb32e9ca5021`. Không sửa/deploy artifact HL21 nguyên bản; chỉ dùng source cho build mới.
- Repo thi công `chuongnguyen89dn-ui/Omnicar`, `recovered-source/`. Nhánh mới `feature/duocar-hl21-rebrand-20261111` tạo từ HL21, commit chuẩn bị `aed35f53f09457c690f3f66afe1d747c5fff093e`.
- Script rename ở `recovered-source/gpt-project-history/rebrand_duocar.py`: chỉ chạy **trong CI checkout trước `make clean package`**, sửa source/project **input đang build**, binary/xml plist bằng `plistlib`, .strings, tên file/module, Makefile, source shared. Không làm biến dạng tư liệu pháp y/bản DEB gốc lưu trong `project/packages` hay `src/*/disasm`.
- `verify_duocar_payload.py`: sau khi build, mở chính DEB, đối chiếu package/version/arch, 8 Mach-O FAT và LC_CODE_SIGNATURE, app `Info.plist`, PreferenceBundle, scheme, quét **toàn payload** không còn path/string OmniCar UTF-8 và UTF-16; kiểm không có quan hệ tự gỡ gói cũ. Giao diện icon là hình Play không chứa chữ OmniCar.
- Workflow FAT `.github/workflows/build-fat-macos.yml` trên branch DuoCar: chạy HL8/HL21 source fixtures **trước khi rename**, áp script DuoCar, build/ký FAT, kiểm gói mới, upload artifact + GitHub Release bất biến `duocar-hl21-20261111`. Run sau commit chuẩn bị: `42963004255`, lúc ghi sớm **đang chạy**. Không được báo là build PASS hoặc phát hành trước khi step thực xanh và SHA kiểm.
- Kho Sileo đang hoạt động: `chuongnguyen89dn-ui/carplaydsp`, Pages `https://chuongnguyen89dn-ui.github.io/carplaydsp/`. Publisher `.github/workflows/build.yml` tạo `repo/debs`, `Packages`, `Packages.gz`, `Release` và deploy Pages. Muốn phát hành DuoCar phải pin SHA source Release immutable, thêm download vào `packages/` trước bước `Build APT repository`; sau deploy **đọc URL công khai** và xác nhận gói `com.chuong.duocar`, version, hash, và file tải được. Không chỉnh tài liệu hoặc tên package cũ.
- Môi trường GPT chỉ có checkout cục bộ tạm từ giải nén DEB trong `/mnt/data/hl21_rebrand_inspect`; GitHub connector có quyền sửa remote. Lệnh hoạt động thật là connector GitHub fetch_file/fetch_blob/create_blob/create_tree/create_commit/update_ref, không bịa lệnh git push. `container.exec` chỉ dùng kiểm local `dpkg-deb`/plist và ảnh gốc.

## Cổng hoàn tất
1. CI DuoCar source input rename PASS; package full-byte audit PASS; GitHub Release asset mới có SHA256.
2. GitHub carplaydsp build/deploy PASS, không mất các gói cũ; public Sileo APT Packages có đúng một entry DuoCar với SHA/Version đúng; DEB công khai khớp artifact.
3. Cung cấp link .deb trực tiếp cho Nguyen. **DEVICE PENDING**; không gọi đã sửa behavior bàn phím/zoom/menu chỉ vì đổi tên.

## Trạng thái checkpoint sớm
CODE PREPARED/COMMITTED; CI `42963004255` đang chạy; Sileo **CHƯA PUBLISH**. Tiếp theo: đọc job nếu FAIL, sửa đúng script, rebuild; khi PASS thì pin hash vào publisher; sau deploy verify public Packages và DEB. Không tự gỡ phiên OmniCar của Nguyen.

## 2026-11-11 12:05 ICT — lỗi CI bplist localization và sửa có bằng chứng
- GitHub Actions `42963004255` / job `130333709423` **FAIL ở Rebrand, chưa compile**. Đã đọc trực tiếp job log: `UnicodeDecodeError` trong `decode_text` rồi `RuntimeError: Unparsed binary with legacy identifier: recovered-source/project/OmniCarPrefs/Resources/ar.lproj/Car.strings`. Đây là file **binary property list bplist00**, dù phần mở rộng là `.strings`; không được bỏ qua vì chứa thương hiệu cũ.
- Xác minh trên DEB HL21 cũ bằng container `python3` + `plistlib.loads`: `ar.lproj/Car.strings` có 83 key, 2 giá trị chứa OmniCar; `plistlib.dumps(..., FMT_BINARY)` và roundtrip giữ đủ 83 key. Đây là fixture thực, không suy đoán.
- Đã sửa script trên branch DuoCar, commit **`6ab5bf7fe81ec15f9a8abd03b9448563667a3d33`**: mọi file có header `bplist00` (gồm `.strings`) phải thay bằng plistlib, cả XML `.stringsdict`; không bỏ qua binary localization. Đã fetch_file đọc lại script SHA `409905773c3da4417aeab5dd5fe57cfa94950707`.
- CI mới `42963372890` / job `130334885428` đã start trên commit sửa; ở checkpoint đang chạy Theos. Run cũ FAIL không tạo DEB; **chưa có phát hành Sileo**.
- Lệnh Nguyen mới nhất vẫn giữ nguyên: **không thêm Conflicts/Replaces yêu cầu gỡ OmniCar; Nguyen sẽ tự gỡ**. Kiểm script vẫn loại `Replaces:`, không thêm legacy package vào `Conflicts:`.
