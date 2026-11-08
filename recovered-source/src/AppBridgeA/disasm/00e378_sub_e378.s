; ==== sub_e378 @ 0xe378..0xe3a8 (48 bytes) ====
0x0000e378  add      x9, x9, #0x8c0
0x0000e37c  stp      x8, x9, [sp, #0x20]
0x0000e380  add      x23, sp, #0x10
0x0000e384  add      x0, x23, #0x20
0x0000e388  add      x1, x21, #0x30
0x0000e38c  bl       #0x2474c   ; call _objc_copyWeak
0x0000e390  add      x0, x23, #0x28
0x0000e394  add      x1, x21, #0x38
0x0000e398  bl       #0x2474c   ; call _objc_copyWeak
0x0000e39c  add      x0, sp, #0x10
0x0000e3a0  bl       #0x2483c   ; call _objc_retainBlock
0x0000e3a4  mov      x21, x0
