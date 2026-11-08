; ==== sub_1becc @ 0x1becc..0x1c0c0 (500 bytes) ====
0x0001becc  bl       #0x2480c   ; call _objc_release
0x0001bed0  b        #0x1bf54   ; call sub_1bf54
0x0001bed4  mov      x20, x0
0x0001bed8  b        #0x1bf08   ; call sub_1bf08
0x0001bedc  mov      x20, x0
0x0001bee0  mov      x0, x19
0x0001bee4  bl       #0x2480c   ; call _objc_release
0x0001bee8  mov      x0, x24
0x0001beec  bl       #0x2480c   ; call _objc_release
0x0001bef0  mov      x0, x27
0x0001bef4  bl       #0x2480c   ; call _objc_release
0x0001bef8  mov      x0, x26
0x0001befc  bl       #0x2480c   ; call _objc_release
0x0001bf00  mov      x0, x25
0x0001bf04  bl       #0x2480c   ; call _objc_release
0x0001bf08  ldr      x0, [sp, #0x28]
0x0001bf0c  bl       #0x2480c   ; call _objc_release
0x0001bf10  mov      x0, x22
0x0001bf14  bl       #0x2480c   ; call _objc_release
0x0001bf18  b        #0x1bf44   ; call sub_1bf44
0x0001bf1c  b        #0x1bf30   ; call sub_1bf30
0x0001bf20  mov      x20, x0
0x0001bf24  mov      x0, x24
0x0001bf28  bl       #0x2480c   ; call _objc_release
0x0001bf2c  b        #0x1bf34   ; call sub_1bf34
0x0001bf30  mov      x20, x0
0x0001bf34  mov      x0, x19
0x0001bf38  bl       #0x2480c   ; call _objc_release
0x0001bf3c  ldr      x0, [sp, #0x28]
0x0001bf40  bl       #0x2480c   ; call _objc_release
0x0001bf44  ldr      x0, [sp, #0x10]
0x0001bf48  bl       #0x2480c   ; call _objc_release
0x0001bf4c  b        #0x1bf54   ; call sub_1bf54
0x0001bf50  mov      x20, x0
0x0001bf54  mov      x0, x20
0x0001bf58  bl       #0x24470   ; call __Unwind_Resume
0x0001bf5c  stp      d15, d14, [sp, #-0xa0]!
0x0001bf60  stp      d13, d12, [sp, #0x10]
0x0001bf64  stp      d11, d10, [sp, #0x20]
0x0001bf68  stp      d9, d8, [sp, #0x30]
0x0001bf6c  stp      x28, x27, [sp, #0x40]
0x0001bf70  stp      x26, x25, [sp, #0x50]
0x0001bf74  stp      x24, x23, [sp, #0x60]
0x0001bf78  stp      x22, x21, [sp, #0x70]
0x0001bf7c  stp      x20, x19, [sp, #0x80]
0x0001bf80  stp      x29, x30, [sp, #0x90]
0x0001bf84  add      x29, sp, #0x90
0x0001bf88  sub      sp, sp, #0x1a0
0x0001bf8c  mov      x19, x0
0x0001bf90  adrp     x8, #0x34000
0x0001bf94  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0001bf98  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0001bf9c  stur     x8, [x29, #-0xa0]
0x0001bfa0  bl       #0x26560   ; objc_msgSend: panel
0x0001bfa4  mov      x29, x29
0x0001bfa8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001bfac  mov      x20, x0
0x0001bfb0  bl       #0x24f40   ; objc_msgSend: bounds
0x0001bfb4  mov      v9.16b, v2.16b
0x0001bfb8  mov      v8.16b, v3.16b
0x0001bfbc  mov      x0, x20
0x0001bfc0  bl       #0x2480c   ; call _objc_release
0x0001bfc4  fmov     d0, #-5.00000000
0x0001bfc8  fadd     d0, d9, d0
0x0001bfcc  mov      x8, #-0x3fbf000000000000
0x0001bfd0  fmov     d1, x8
0x0001bfd4  fadd     d10, d0, d1
0x0001bfd8  mov      x0, x19
0x0001bfdc  bl       #0x258e0   ; objc_msgSend: hideButton
0x0001bfe0  mov      x29, x29
0x0001bfe4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001bfe8  mov      x20, x0
0x0001bfec  mov      x8, #0x4041000000000000
0x0001bff0  fmov     d2, x8
0x0001bff4  fmov     d1, #5.00000000
0x0001bff8  fmov     d3, #24.00000000
0x0001bffc  mov      v0.16b, v10.16b
0x0001c000  bl       #0x26f80   ; objc_msgSend: setFrame:
0x0001c004  mov      x0, x20
0x0001c008  bl       #0x2480c   ; call _objc_release
0x0001c00c  mov      x0, x19
0x0001c010  bl       #0x258e0   ; objc_msgSend: hideButton
0x0001c014  mov      x29, x29
0x0001c018  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c01c  mov      x20, x0
0x0001c020  bl       #0x257c0   ; objc_msgSend: frame
0x0001c024  bl       #0x24398   ; call _CGRectGetMinX
0x0001c028  mov      v10.16b, v0.16b
0x0001c02c  mov      x0, x19
0x0001c030  bl       #0x25e80   ; objc_msgSend: langButton
0x0001c034  mov      x29, x29
0x0001c038  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c03c  mov      x21, x0
0x0001c040  fmov     d0, #-4.00000000
0x0001c044  fadd     d0, d10, d0
0x0001c048  fmov     d1, #-26.00000000
0x0001c04c  fadd     d0, d0, d1
0x0001c050  fmov     d1, #9.00000000
0x0001c054  fmov     d2, #26.00000000
0x0001c058  fmov     d3, #16.00000000
0x0001c05c  bl       #0x26f80   ; objc_msgSend: setFrame:
0x0001c060  mov      x0, x21
0x0001c064  bl       #0x2480c   ; call _objc_release
0x0001c068  mov      x0, x20
0x0001c06c  bl       #0x2480c   ; call _objc_release
0x0001c070  mov      x0, x19
0x0001c074  bl       #0x25e80   ; objc_msgSend: langButton
0x0001c078  mov      x29, x29
0x0001c07c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c080  mov      x20, x0
0x0001c084  bl       #0x257c0   ; objc_msgSend: frame
0x0001c088  bl       #0x24398   ; call _CGRectGetMinX
0x0001c08c  mov      v10.16b, v0.16b
0x0001c090  mov      x0, x19
0x0001c094  bl       #0x256e0   ; objc_msgSend: field
0x0001c098  mov      x29, x29
0x0001c09c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c0a0  mov      x21, x0
0x0001c0a4  fmov     d0, #-8.00000000
0x0001c0a8  fadd     d0, d10, d0
0x0001c0ac  fmov     d1, #-5.00000000
0x0001c0b0  fadd     d2, d0, d1
0x0001c0b4  fmov     d0, #5.00000000
0x0001c0b8  fmov     d1, #5.00000000
0x0001c0bc  fmov     d3, #24.00000000
