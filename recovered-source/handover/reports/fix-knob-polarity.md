# FIX — cực publishKnobsNow (WO §VII, sửa riêng)

Ngày: 2026-11-09. Phạm vi: chỉ cực của phần tử 3 trong payload `appbridge.knobs`.
Không đổi kích thước knob, gesture, hitbox, frame, z-order. Không đóng candidate, không đẩy git.

## Cơ sở (audit-runtime.md §4 — dump lại độc lập từ DEB gốc)
- arm64: `eor w2, w27, #0x1` @0x3eff8 → stub numberWithBool: @0x3effc. w27 = kết quả IsIdentity.
- arm64e: `eor w2, w27, #0x1` @0x413ac → stub @0x413b0.
- Payload gốc = **!IsIdentity** trên cả hai slice (YES chỉ khi núm đang bấm, scale 1.6).

## Trước → sau (cả project/OmniCarSplitScreen/SCPCarSplit.m và src/SplitScreenA/SCPCarSplit.m — cmp IDENTICAL sau sửa)
Trước (dòng 2616–2617 cũ):
```objc
BOOL scaled = !CGAffineTransformIsIdentity(knob.transform);
[knobs addObject:@[ @(center.x), @(center.y), @(!scaled), @(divider.index) ]];
```
Payload phát ra = !scaled = IsIdentity — NGƯỢC gốc: gương kẹt "active" khi núm nghỉ.

Sau (dòng 2615–2620):
```objc
// Element 3 = !CGAffineTransformIsIdentity(transform), as the
// original computes it: eor w2, w27, #1 on the IsIdentity
// result (arm64 @0x3eff8, arm64e @0x413ac) feeding
// numberWithBool: directly — publish `scaled`, no 2nd negation.
BOOL scaled = !CGAffineTransformIsIdentity(knob.transform);
[knobs addObject:@[ @(center.x), @(center.y), @(scaled), @(divider.index) ]];
```
Kèm sửa chữ trong comment đầu hàm: "unscaled flag" → "scaled/active flag".
grep `@(!scaled)` toàn cây = 0.

## Build
Toolchain kiểm trước: clang-18 ✓, ldid ✓, /usr/bin/ld.lld → ld.lld-18 ✓ (không phải khôi phục).
Module OmniCarSplitScreen: `make clean; make` (umask 022, THEOS=~/theos) — compile/link/ký sạch.
Object mới `.theos/obj/debug/arm64/SCPCarSplit.m.c57501ed.o`: 559.624 B, 06:09:01 UTC
(bản cũ 559.632 B, 04:51:27 UTC — nhỏ hơn 8 B, khớp việc mất 2 lệnh).

## Cổng object — truy vết IsIdentity → numberWithBool:

BẢN CŨ (object 04:51, disasm lưu /tmp buổi làm việc):
- 0x18784 `bl _CGAffineTransformIsIdentity` → w0
- 0x18790 `eor w8, w0, #0x1` → scaled = !IsIdentity; strb → [sp,#0x157]
- 0x18810 `ldrb w8, [sp,#0x157]` → 0x18814 `eor w8, w8, w9` (w9=1) → **đảo lần 2**
- 0x18818 `and w2, w8, #0x1` → payload = IsIdentity. HAI phép đảo trên đường đi.

BẢN MỚI (object 06:09):
- 0x18784 `bl _CGAffineTransformIsIdentity` → w0
- 0x1878c `eor w8, w0, #0x1` → scaled (phép đảo DUY NHẤT, chính là định nghĩa scaled); strb → [sp,#0x147]
- 0x18808 `ldrb w8, [sp,#0x147]` → 0x18814 `and w2, w8, #0x1` → msgSend đóng hộp bool.
- Toàn hàm publishKnobsNow bản mới chứa đúng **1 lệnh eor**.

DYLIB đã link (OmniCarSplitScreen.dylib 06:09:04 UTC) — cùng dãy, có chú thích selector:
- 0x1c784 bl IsIdentity → 0x1c78c `eor w8, w0, #0x1` → 0x1c808 `ldrb w8, [sp,#0x147]`
  → 0x1c810 selref `numberWithBool:` → 0x1c814 `and w2, w8, #0x1` → 0x1c818 bl numberWithBool:.
Không còn phép đảo nào giữa return của IsIdentity và đối số của numberWithBool: ngoài
phép phủ định định nghĩa `scaled` (khớp đúng 1 eor của gốc).

## Bảng test tĩnh
| transform của knob | IsIdentity | GỐC (dump) | CŨ: !scaled | MỚI: scaled |
|---|---|---|---|---|
| identity (nghỉ) | 1 | **0** | 1 ✗ | **0** ✓ |
| scale 1.6 (đang bấm) | 0 | **1** | 0 ✗ | **1** ✓ |

Kết luận cổng: ĐẠT ở mức object/dylib local (arm64). Bản FAT hai slice qua CI sẽ kiểm lại
khi gom vòng wake.
