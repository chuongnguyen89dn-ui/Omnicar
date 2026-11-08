; ==== sub_aad4 @ 0xaad4..0xad50 (636 bytes) ====
0x0000aad4  ldp      x20, x19, [sp], #0x20
0x0000aad8  ret      
0x0000aadc  mov      x20, x0
0x0000aae0  mov      x0, x19
0x0000aae4  bl       #0x2480c   ; call _objc_release
0x0000aae8  mov      x0, x20
0x0000aaec  bl       #0x24470   ; call __Unwind_Resume
0x0000aaf0  sub      sp, sp, #0x120
0x0000aaf4  stp      x26, x25, [sp, #0xd0]
0x0000aaf8  stp      x24, x23, [sp, #0xe0]
0x0000aafc  stp      x22, x21, [sp, #0xf0]
0x0000ab00  stp      x20, x19, [sp, #0x100]
0x0000ab04  stp      x29, x30, [sp, #0x110]
0x0000ab08  add      x29, sp, #0x110
0x0000ab0c  mov      x19, x2
0x0000ab10  mov      x20, x0
0x0000ab14  adrp     x8, #0x34000
0x0000ab18  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0000ab1c  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0000ab20  stur     x8, [x29, #-0x48]
0x0000ab24  mov      x0, x2
0x0000ab28  bl       #0x24818   ; call _objc_retain
0x0000ab2c  cbz      x19, #0xabf8
0x0000ab30  movi     v0.16b, #0
0x0000ab34  stp      q0, q0, [sp, #0x20]
0x0000ab38  stp      q0, q0, [sp]
0x0000ab3c  mov      x0, x20
0x0000ab40  bl       #0x26580   ; objc_msgSend: panes
0x0000ab44  mov      x29, x29
0x0000ab48  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ab4c  mov      x20, x0
0x0000ab50  mov      x2, sp
0x0000ab54  add      x3, sp, #0x48
0x0000ab58  mov      w4, #0x10
0x0000ab5c  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0000ab60  mov      x21, x0
0x0000ab64  cbz      x0, #0xabec
0x0000ab68  ldr      x8, [sp, #0x10]
0x0000ab6c  ldr      x24, [x8]   ; -> [got:___objc_personality_v0]
0x0000ab70  mov      x25, #0
0x0000ab74  ldr      x8, [sp, #0x10]
0x0000ab78  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0000ab7c  cmp      x8, x24
0x0000ab80  b.eq     #0xab8c
0x0000ab84  mov      x0, x20
0x0000ab88  bl       #0x24770   ; call _objc_enumerationMutation
0x0000ab8c  ldr      x8, [sp, #8]
0x0000ab90  ldr      x0, [x8, x25, lsl #3]   ; -> [got:___objc_personality_v0]
0x0000ab94  bl       #0x25020   ; objc_msgSend: bundleID
0x0000ab98  mov      x29, x29
0x0000ab9c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000aba0  mov      x22, x0
0x0000aba4  mov      x2, x19
0x0000aba8  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0000abac  mov      x23, x0
0x0000abb0  mov      x0, x22
0x0000abb4  bl       #0x2480c   ; call _objc_release
0x0000abb8  tbnz     w23, #0, #0xabe8
0x0000abbc  add      x25, x25, #1
0x0000abc0  cmp      x21, x25
0x0000abc4  b.ne     #0xab74
0x0000abc8  mov      x2, sp
0x0000abcc  add      x3, sp, #0x48
0x0000abd0  mov      x0, x20
0x0000abd4  mov      w4, #0x10
0x0000abd8  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0000abdc  mov      x21, x0
0x0000abe0  cbnz     x0, #0xab70
0x0000abe4  b        #0xabec   ; call sub_abec
0x0000abe8  mov      w21, #1
0x0000abec  mov      x0, x20
0x0000abf0  bl       #0x2480c   ; call _objc_release
0x0000abf4  b        #0xabfc   ; call sub_abfc
0x0000abf8  mov      w21, #0
0x0000abfc  mov      x0, x19
0x0000ac00  bl       #0x2480c   ; call _objc_release
0x0000ac04  ldur     x8, [x29, #-0x48]
0x0000ac08  adrp     x9, #0x34000
0x0000ac0c  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x0000ac10  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0000ac14  cmp      x9, x8
0x0000ac18  b.ne     #0xac3c
0x0000ac1c  mov      x0, x21
0x0000ac20  ldp      x29, x30, [sp, #0x110]
0x0000ac24  ldp      x20, x19, [sp, #0x100]
0x0000ac28  ldp      x22, x21, [sp, #0xf0]
0x0000ac2c  ldp      x24, x23, [sp, #0xe0]
0x0000ac30  ldp      x26, x25, [sp, #0xd0]
0x0000ac34  add      sp, sp, #0x120
0x0000ac38  ret      
0x0000ac3c  bl       #0x24488   ; call ___stack_chk_fail
0x0000ac40  b        #0xac60   ; call sub_ac60
0x0000ac44  b        #0xac60   ; call sub_ac60
0x0000ac48  mov      x21, x0
0x0000ac4c  b        #0xac6c   ; call sub_ac6c
0x0000ac50  mov      x21, x0
0x0000ac54  mov      x0, x22
0x0000ac58  bl       #0x2480c   ; call _objc_release
0x0000ac5c  b        #0xac64   ; call sub_ac64
0x0000ac60  mov      x21, x0
0x0000ac64  mov      x0, x20
0x0000ac68  bl       #0x2480c   ; call _objc_release
0x0000ac6c  mov      x0, x19
0x0000ac70  bl       #0x2480c   ; call _objc_release
0x0000ac74  b        #0xac7c   ; call sub_ac7c
0x0000ac78  mov      x21, x0
0x0000ac7c  mov      x0, x21
0x0000ac80  bl       #0x24470   ; call __Unwind_Resume
0x0000ac84  sub      sp, sp, #0x130
0x0000ac88  stp      x28, x27, [sp, #0xd0]
0x0000ac8c  stp      x26, x25, [sp, #0xe0]
0x0000ac90  stp      x24, x23, [sp, #0xf0]
0x0000ac94  stp      x22, x21, [sp, #0x100]
0x0000ac98  stp      x20, x19, [sp, #0x110]
0x0000ac9c  stp      x29, x30, [sp, #0x120]
0x0000aca0  add      x29, sp, #0x120
0x0000aca4  mov      x19, x2
0x0000aca8  mov      x20, x0
0x0000acac  adrp     x8, #0x34000
0x0000acb0  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0000acb4  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0000acb8  stur     x8, [x29, #-0x58]
0x0000acbc  mov      x0, x2
0x0000acc0  bl       #0x24818   ; call _objc_retain
0x0000acc4  movi     v0.16b, #0
0x0000acc8  stp      q0, q0, [sp]
0x0000accc  stp      q0, q0, [sp, #0x20]
0x0000acd0  mov      x0, x20
0x0000acd4  bl       #0x26580   ; objc_msgSend: panes
0x0000acd8  mov      x29, x29
0x0000acdc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ace0  mov      x20, x0
0x0000ace4  mov      x2, sp
0x0000ace8  add      x3, sp, #0x48
0x0000acec  mov      w4, #0x10
0x0000acf0  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0000acf4  mov      x21, x0
0x0000acf8  cbz      x0, #0xad7c
0x0000acfc  ldr      x8, [sp, #0x10]
0x0000ad00  ldr      x25, [x8]   ; -> [got:___objc_personality_v0]
0x0000ad04  mov      x26, #0
0x0000ad08  ldr      x8, [sp, #0x10]
0x0000ad0c  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0000ad10  cmp      x8, x25
0x0000ad14  b.eq     #0xad20
0x0000ad18  mov      x0, x20
0x0000ad1c  bl       #0x24770   ; call _objc_enumerationMutation
0x0000ad20  ldr      x8, [sp, #8]
0x0000ad24  ldr      x22, [x8, x26, lsl #3]   ; -> [got:___objc_personality_v0]
0x0000ad28  mov      x0, x22
0x0000ad2c  bl       #0x25020   ; objc_msgSend: bundleID
0x0000ad30  mov      x29, x29
0x0000ad34  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ad38  mov      x23, x0
0x0000ad3c  mov      x2, x19
0x0000ad40  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0000ad44  mov      x24, x0
0x0000ad48  mov      x0, x23
0x0000ad4c  bl       #0x2480c   ; call _objc_release
