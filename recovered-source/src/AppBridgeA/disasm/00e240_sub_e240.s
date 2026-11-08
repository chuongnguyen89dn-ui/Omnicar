; ==== sub_e240 @ 0xe240..0xe270 (48 bytes) ====
0x0000e240  mov      x0, x23
0x0000e244  bl       #0x2480c   ; call _objc_release
0x0000e248  b        #0xe250   ; call sub_e250
0x0000e24c  mov      x21, x0
0x0000e250  ldr      x0, [sp, #8]
0x0000e254  bl       #0x2480c   ; call _objc_release
0x0000e258  mov      x0, x26
0x0000e25c  bl       #0x2480c   ; call _objc_release
0x0000e260  mov      x0, x25
0x0000e264  bl       #0x2480c   ; call _objc_release
0x0000e268  mov      x0, x24
0x0000e26c  bl       #0x2480c   ; call _objc_release
