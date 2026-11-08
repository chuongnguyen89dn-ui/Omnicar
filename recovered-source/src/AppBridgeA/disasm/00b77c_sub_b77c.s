; ==== sub_b77c @ 0xb77c..0xb83c (192 bytes) ====
0x0000b77c  mov      x0, x21
0x0000b780  mov      w4, #0x10
0x0000b784  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0000b788  mov      x24, x0
0x0000b78c  cbnz     x0, #0xb6b0
0x0000b790  mov      x22, #0
0x0000b794  b        #0xb7a0   ; call sub_b7a0
0x0000b798  mov      x0, x22
0x0000b79c  bl       #0x24818   ; call _objc_retain
0x0000b7a0  mov      x0, x21
0x0000b7a4  bl       #0x2480c   ; call _objc_release
0x0000b7a8  mov      x0, x20
0x0000b7ac  bl       #0x2480c   ; call _objc_release
0x0000b7b0  ldr      x0, [sp, #8]
0x0000b7b4  bl       #0x2480c   ; call _objc_release
0x0000b7b8  ldur     x8, [x29, #-0x60]
0x0000b7bc  adrp     x9, #0x34000
0x0000b7c0  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x0000b7c4  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0000b7c8  cmp      x9, x8
0x0000b7cc  b.ne     #0xb7f4
0x0000b7d0  mov      x0, x22
0x0000b7d4  ldp      x29, x30, [sp, #0x130]
0x0000b7d8  ldp      x20, x19, [sp, #0x120]
0x0000b7dc  ldp      x22, x21, [sp, #0x110]
0x0000b7e0  ldp      x24, x23, [sp, #0x100]
0x0000b7e4  ldp      x26, x25, [sp, #0xf0]
0x0000b7e8  ldp      x28, x27, [sp, #0xe0]
0x0000b7ec  add      sp, sp, #0x140
0x0000b7f0  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x0000b7f4  bl       #0x24488   ; call ___stack_chk_fail
0x0000b7f8  b        #0xb858   ; call sub_b858
0x0000b7fc  b        #0xb858   ; call sub_b858
0x0000b800  b        #0xb818   ; call sub_b818
0x0000b804  b        #0xb80c   ; call sub_b80c
0x0000b808  b        #0xb828   ; call sub_b828
0x0000b80c  mov      x23, x0
0x0000b810  b        #0xb87c   ; call sub_b87c
0x0000b814  b        #0xb838   ; call sub_b838
0x0000b818  mov      x23, x0
0x0000b81c  mov      x0, x22
0x0000b820  bl       #0x2480c   ; call _objc_release
0x0000b824  b        #0xb87c   ; call sub_b87c
0x0000b828  mov      x23, x0
0x0000b82c  ldr      x0, [sp, #8]
0x0000b830  bl       #0x2480c   ; call _objc_release
0x0000b834  b        #0xb884   ; call sub_b884
0x0000b838  mov      x23, x0
