; ==== sub_e1d0 @ 0xe1d0..0xe200 (48 bytes) ====
0x0000e1d0  ldp      x22, x21, [sp, #0x50]
0x0000e1d4  ldp      x24, x23, [sp, #0x40]
0x0000e1d8  ldp      x26, x25, [sp, #0x30]
0x0000e1dc  ldp      x28, x27, [sp, #0x20]
0x0000e1e0  add      sp, sp, #0x80
0x0000e1e4  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x0000e1e8  b        #0xe24c   ; call sub_e24c
0x0000e1ec  b        #0xe20c   ; call sub_e20c
0x0000e1f0  mov      x21, x0
0x0000e1f4  b        #0xe268   ; call sub_e268
0x0000e1f8  b        #0xe1fc   ; call sub_e1fc
0x0000e1fc  str      x25, [sp]
