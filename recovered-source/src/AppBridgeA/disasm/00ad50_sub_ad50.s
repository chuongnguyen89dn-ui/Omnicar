; ==== sub_ad50 @ 0xad50..0xae08 (184 bytes) ====
0x0000ad50  tbnz     w24, #0, #0xad84
0x0000ad54  add      x26, x26, #1
0x0000ad58  cmp      x21, x26
0x0000ad5c  b.ne     #0xad08
0x0000ad60  mov      x2, sp
0x0000ad64  add      x3, sp, #0x48
0x0000ad68  mov      x0, x20
0x0000ad6c  mov      w4, #0x10
0x0000ad70  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0000ad74  mov      x21, x0
0x0000ad78  cbnz     x0, #0xad04
0x0000ad7c  mov      x22, #0
0x0000ad80  b        #0xad8c   ; call sub_ad8c
0x0000ad84  mov      x0, x22
0x0000ad88  bl       #0x24818   ; call _objc_retain
0x0000ad8c  mov      x0, x20
0x0000ad90  bl       #0x2480c   ; call _objc_release
0x0000ad94  mov      x0, x19
0x0000ad98  bl       #0x2480c   ; call _objc_release
0x0000ad9c  ldur     x8, [x29, #-0x58]
0x0000ada0  adrp     x9, #0x34000
0x0000ada4  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x0000ada8  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0000adac  cmp      x9, x8
0x0000adb0  b.ne     #0xadd8
0x0000adb4  mov      x0, x22
0x0000adb8  ldp      x29, x30, [sp, #0x120]
0x0000adbc  ldp      x20, x19, [sp, #0x110]
0x0000adc0  ldp      x22, x21, [sp, #0x100]
0x0000adc4  ldp      x24, x23, [sp, #0xf0]
0x0000adc8  ldp      x26, x25, [sp, #0xe0]
0x0000adcc  ldp      x28, x27, [sp, #0xd0]
0x0000add0  add      sp, sp, #0x130
0x0000add4  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x0000add8  bl       #0x24488   ; call ___stack_chk_fail
0x0000addc  b        #0xadfc   ; call sub_adfc
0x0000ade0  b        #0xadfc   ; call sub_adfc
0x0000ade4  mov      x21, x0
0x0000ade8  b        #0xae08   ; call sub_ae08
0x0000adec  mov      x21, x0
0x0000adf0  mov      x0, x23
0x0000adf4  bl       #0x2480c   ; call _objc_release
0x0000adf8  b        #0xae00   ; call sub_ae00
0x0000adfc  mov      x21, x0
0x0000ae00  mov      x0, x20
0x0000ae04  bl       #0x2480c   ; call _objc_release
