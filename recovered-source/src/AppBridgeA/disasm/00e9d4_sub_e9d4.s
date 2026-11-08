; ==== sub_e9d4 @ 0xe9d4..0xe9e8 (20 bytes) ====
0x0000e9d4  bl       #0x2480c   ; call _objc_release
0x0000e9d8  ldr      x0, [x19, #0x20]
0x0000e9dc  ldp      x29, x30, [sp, #0x10]
0x0000e9e0  ldp      x20, x19, [sp], #0x20
0x0000e9e4  b        #0x2480c   ; call _objc_release
