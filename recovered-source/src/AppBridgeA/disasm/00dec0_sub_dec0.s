; ==== sub_dec0 @ 0xdec0..0xded8 (24 bytes) ====
0x0000dec0  mov      x0, x23
0x0000dec4  bl       #0x2480c   ; call _objc_release
0x0000dec8  mov      x0, x21
0x0000decc  bl       #0x2480c   ; call _objc_release
0x0000ded0  ldr      x0, [sp, #0x40]
0x0000ded4  bl       #0x2480c   ; call _objc_release
