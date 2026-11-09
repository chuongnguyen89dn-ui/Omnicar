# FIX-K2 — KB ba trạng thái phía app + instrument suppression (WO GPT vòng ytz4)

**Mức đạt: source complete / build PASS / static PASS + harness PASS (16/16).**
File sửa duy nhất: `project/OmniCarAppBridge/ABInApp.m` (+ mirror
`src/AppBridgeB/ABInApp.m`, cmp identical). Không đụng BridgeWakePack.h,
không đụng đường ENFORCE.

## 1. Giao diện gói kb (khớp strand host)

- Kênh: `bridgewake.v1.state` (điều phối cũ `BWOnStatePacket` rẽ nhánh
  theo type trước khi xử lý state). Header nguyên: valid/hash28/seq/gen.
- **type = 6** — giá trị chưa dùng đầu tiên (pack header gán 1=state,
  2=query, 3=wake, 4=ack, 5=act; 6–7 reserved). Hằng số giữ local trong
  ABInApp.m (`enum { BWTypeKbState = 6 }`) để không fork header dùng
  chung từ phía này; header nhận cùng giá trị ở bản SplitScreen.
- Payload: bit9 = kbKnown, bit8 = kbActive (vị trí trường pinchMode).
  bit8 chỉ có nghĩa khi bit9 = 1; gói known=0 mà bit8=1 bị bỏ bit active.

## 2. Phía app đã làm

- **Giải mã + kỷ luật nhận** (`BWOnKbPacket`): hash28 phải là bundle của
  chính app + `BWGenAccept` (đúng kỷ luật gói state §3.2: bằng gen đã
  biết, hoặc tiến modulo-4096 trong [1, 0x7FF]). Lệch hash/gen → bỏ gói,
  snapshot cũ (hoặc sự vắng mặt của nó) đứng nguyên. Gói kb KHÔNG đụng
  state chrome, danh tính phiên act (BWActSessionVerified), hay hai latch
  mở khoá §5.4 — các thứ đó thuộc gói state.
- **Snapshot owner**: `kbOwner {BWKbOwnerKnown, BWKbOwnerActive,
  BWKbOwnerRxAt}`; xoá sạch trong `BWResetAll` cùng phiên.
- **Trạng thái hiệu dụng** (`BWKbEffective`): ACTIVE nếu BẤT KỲ nguồn
  hợp lệ nào nói active — nguồn cục bộ (phiên first-responder = bằng
  chứng chính §5.5 + thông báo khung phím, giữ nguyên đường theo dõi cũ,
  nay qua một setter duy nhất `BWKbLocalSet` để có tuổi thông tin) hoặc
  snapshot owner còn tươi nói active. Ngược lại snapshot owner còn tươi
  quyết định (INACTIVE của nó, hoặc UNKNOWN của chính nó — sync sống
  nhưng nội dung "chưa biết" vẫn ghi kbSrc=owner). Hết tươi → UNKNOWN.
- **Ngưỡng tươi = 3,5 s**: owner phát kb khi mở/đóng phiên phím, khi
  query, và kèm renew 1 s vốn xoay vòng qua các ô hosted → worst case
  cho một bundle trong split 2 ô là ~2 s/emission. 3,5 s = 2,0 (xoay
  vòng worst case) + 1,0 (một tick mất trọn) + 0,5 (lệch lịch). Quá
  ngưỡng thì UNKNOWN — không bao giờ là INACTIVE được nhớ lại.
- **Loại biểu thức hai trạng thái cũ**: điểm :297 (flag của gói act) nay
  phát theo trạng thái hiệu dụng (`BWKbEffective(...) == BWKbActive` —
  bit chỉ là 1 khi có bằng chứng ACTIVE dương tính) + ghi chú tại chỗ:
  UNKNOWN không đội lốt inactive ở đây nữa; bản thân ba trạng thái đi
  vào log probe. Mọi gán kb cục bộ đi qua `BWKbLocalSet` (responder
  became/resigned, frame note, hide note, reset).
- **Cổng** (`BWGatePass`): đọc `BWKbEffective` — ACTIVE → fail "kb",
  UNKNOWN → fail "kbunknown", chỉ known-inactive mới qua. Thứ tự và mọi
  điều kiện khác không đổi; kỷ luật DRY_RUN nguyên vẹn (cổng chỉ nuôi
  wouldSwallow; ENFORCE không được mở ở bất kỳ điểm nào của strand này).
- **Instrument probe**: latch tại đầu sequence đổi từ một chữ kb sang
  `BWSeqKb{Known,Active,Src,Age}AtStart`; dòng close in
  `kbKnown=%d kbActive=%d kbSrc=%s kbAge=%ld` (src ∈ owner/local/none,
  age = tuổi của nguồn thắng, ms; −1 = không có thông tin kb nào).
  Đây là bản ghi để phiên sau đo chuỗi suppression theo lệnh GPT ở mức
  wouldSwallow (nuốt → chạm kế vào app → nhập liệu → teardown).

## 3. Truy vết tĩnh — kb ACTIVE trong lúc controls ẩn (mục 4 của WO)

Điều kiện: state HIDDEN + tươi, phiên phím hosted đang mở →
owner phát kb {known=1, active=1} → `BWOnKbPacket` nhận (hash/gen khớp)
→ tới Began của sequence: `BWGatePass` qua known/fresh/latch/state →
`BWKbEffective` = ACTIVE (src=owner; nếu responder cục bộ đang sống thì
src=local, cùng kết luận) → reason=@"kb", trả NO →
`BWSeqWouldSwallow = NO` → `BWBeginSwallow` không thể chạy ở mọi mode
→ event đi nguyên xuống orig. Dòng probe chốt: `kbKnown=1 kbActive=1
kbSrc=owner kbAge=<ms> ... wouldSwallow=0 failopen=kb`. Chiều dương:
owner {known=1, active=0} còn tươi → kbEff = INACTIVE → cổng qua được
mắt kb (wouldSwallow theo các điều kiện còn lại). Không sync + cục bộ
unknown → UNKNOWN/none/−1 → fail "kbunknown" — đúng căn bệnh ytz3,
nay phân biệt được nguồn trong log.

## 4. Vector kiểm chứng (harness C, dùng BridgeWakePack.h thật)

Logic giải mã/nhận/hiệu dụng transcribe nguyên văn sang C (kiểu
Foundation → kiểu C, BWNow → đồng hồ giả), chạy trên VM: **16/16 PASS**.
- K1: yt hash28=0xD3B4E0D, gen=7, seq=1, known=1, active=1 → raw
  `0xE9DA706800803B06` (khớp tính tay) → ACTIVE src=owner.
- K2: known=1, active=0, seq=2 → raw `0xE9DA706801003A06` → INACTIVE.
- K3: known=0 + bit active=1 (gói lỗi) → bit active bị bỏ → UNKNOWN,
  kbSrc=owner (sync tươi, nội dung unknown).
- **K4: hash lệch (vietmap) → bỏ gói, không snapshot, UNKNOWN/none/−1.**
- **K5: gen stale (6 < 7 đã biết) → bỏ gói.** K9: gen tiến (8) → nhận.
- K6: hết tươi: +3,4 s còn INACTIVE; +3,6 s → UNKNOWN (không nhớ inactive).
- K7: cục bộ ACTIVE thắng owner INACTIVE còn tươi (src=local).
- K8: owner ACTIVE còn tươi thắng cục bộ unknown (src=owner).

## 5. Cổng tự kiểm

- Build module AppBridge (`make clean && make`, THEOS + SDK 16.5):
  exit 0; dylib chứa format `kbKnown=%d kbActive=%d kbSrc=%s kbAge=%ld`.
- grep biểu thức sụp hai trạng thái trên đường cổng/log: điểm phát flag
  act cũ và latch một-chữ cũ đã hết. Hai hit code còn lại là phép ĐỌC ba
  trạng thái trung thực, không phải phép sụp: phép thử nguồn cục bộ
  ACTIVE nằm trong chính `BWKbEffective`, và điều kiện §5.5 cũ trong
  `BWKbHideNote` (hide chỉ được hạ Unknown→Inactive, không hạ Active).
- Mirror project/ ↔ src/: identical sau chép.
- Chưa có bằng chứng xe (mức device PENDING như mọi vòng).

## 6. Điểm để lại cho coordinator/GPT

- Phía owner (strand host) không được đọc flag=0 của gói act như một
  phép đo "kb inactive" — đó là phía đã bị GPT kết án
  (SCPCarSplit+BridgeWake.m:652–654); phía app nay chỉ phát bằng chứng
  ACTIVE dương tính ở bit đó, và sự thật ba trạng thái đi theo gói kb
  + log probe.
- Gen của gói kb được kiểm bằng BWGenAccept nhưng KHÔNG cho gói kb tự
  nâng BWGen/BWKnown — danh tính gen vẫn do gói state định nghĩa.
