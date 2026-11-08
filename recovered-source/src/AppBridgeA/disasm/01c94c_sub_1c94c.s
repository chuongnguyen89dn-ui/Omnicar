; ==== sub_1c94c @ 0x1c94c..0x1c9c8 (124 bytes) ====
0x0001c94c  mov      x4, x21
0x0001c950  bl       #0x26620   ; objc_msgSend: postNotificationName:object:userInfo:
0x0001c954  mov      x0, x22
0x0001c958  bl       #0x2480c   ; call _objc_release
0x0001c95c  mov      x0, x23
0x0001c960  bl       #0x2480c   ; call _objc_release
0x0001c964  mov      x0, x21
0x0001c968  bl       #0x2480c   ; call _objc_release
0x0001c96c  mov      x0, x20
0x0001c970  bl       #0x2480c   ; call _objc_release
0x0001c974  mov      x0, x19
0x0001c978  bl       #0x2480c   ; call _objc_release
0x0001c97c  ldr      x8, [sp, #0x28]
0x0001c980  adrp     x9, #0x34000
0x0001c984  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x0001c988  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0001c98c  cmp      x9, x8
0x0001c990  b.ne     #0x1c9ac
0x0001c994  ldp      x29, x30, [sp, #0x60]
0x0001c998  ldp      x20, x19, [sp, #0x50]
0x0001c99c  ldp      x22, x21, [sp, #0x40]
0x0001c9a0  ldp      x24, x23, [sp, #0x30]
0x0001c9a4  add      sp, sp, #0x70
0x0001c9a8  ret      
0x0001c9ac  bl       #0x24488   ; call ___stack_chk_fail
0x0001c9b0  mov      x1, x22
0x0001c9b4  mov      x22, x0
0x0001c9b8  mov      x0, x1
0x0001c9bc  bl       #0x2480c   ; call _objc_release
0x0001c9c0  b        #0x1c9c8   ; call sub_1c9c8
0x0001c9c4  mov      x22, x0
