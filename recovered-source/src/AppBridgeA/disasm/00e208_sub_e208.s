; ==== sub_e208 @ 0xe208..0xe238 (48 bytes) ====
0x0000e208  b        #0xe270   ; call sub_e270
0x0000e20c  mov      x21, x0
0x0000e210  b        #0xe260   ; call sub_e260
0x0000e214  b        #0xe24c   ; call sub_e24c
0x0000e218  mov      x21, x0
0x0000e21c  ldr      x0, [sp, #0x18]
0x0000e220  bl       #0x2480c   ; call _objc_release
0x0000e224  b        #0xe240   ; call sub_e240
0x0000e228  b        #0xe23c   ; call sub_e23c
0x0000e22c  mov      x21, x0
0x0000e230  mov      x0, x27
0x0000e234  b        #0xe244   ; call sub_e244
