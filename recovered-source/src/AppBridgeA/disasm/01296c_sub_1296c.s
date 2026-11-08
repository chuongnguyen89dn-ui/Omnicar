; ==== sub_1296c @ 0x1296c..0x129b0 (68 bytes) ====
0x0001296c  mov      x22, x0
0x00012970  cbnz     x0, #0x1291c
0x00012974  mov      x0, x19
0x00012978  bl       #0x2480c   ; call _objc_release
0x0001297c  ldur     x8, [x29, #-0x48]
0x00012980  adrp     x9, #0x34000
0x00012984  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00012988  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0001298c  cmp      x9, x8
0x00012990  b.ne     #0x129b0
0x00012994  ldp      x29, x30, [sp, #0x110]
0x00012998  ldp      x20, x19, [sp, #0x100]
0x0001299c  ldp      x22, x21, [sp, #0xf0]
0x000129a0  ldp      x24, x23, [sp, #0xe0]
0x000129a4  ldp      x28, x27, [sp, #0xd0]
0x000129a8  add      sp, sp, #0x120
0x000129ac  ret      
