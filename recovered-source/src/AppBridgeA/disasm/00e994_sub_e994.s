; ==== sub_e994 @ 0xe994..0xe9d4 (64 bytes) ====
0x0000e994  add      x1, x19, #0x30
0x0000e998  bl       #0x2474c   ; call _objc_copyWeak
0x0000e99c  add      x0, x20, #0x38
0x0000e9a0  add      x1, x19, #0x38
0x0000e9a4  ldp      x29, x30, [sp, #0x10]
0x0000e9a8  ldp      x20, x19, [sp], #0x20
0x0000e9ac  b        #0x2474c   ; call _objc_copyWeak
0x0000e9b0  stp      x20, x19, [sp, #-0x20]!
0x0000e9b4  stp      x29, x30, [sp, #0x10]
0x0000e9b8  add      x29, sp, #0x10
0x0000e9bc  mov      x19, x0
0x0000e9c0  add      x0, x0, #0x38
0x0000e9c4  bl       #0x24758   ; call _objc_destroyWeak
0x0000e9c8  add      x0, x19, #0x30
0x0000e9cc  bl       #0x24758   ; call _objc_destroyWeak
0x0000e9d0  ldr      x0, [x19, #0x28]
