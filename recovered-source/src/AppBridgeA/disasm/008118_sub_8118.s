; ==== sub_8118 @ 0x8118..0x8170 (88 bytes) ====
0x00008118  mov      x22, x1
0x0000811c  mov      x21, x0
0x00008120  mov      x0, x27
0x00008124  bl       #0x2480c   ; call _objc_release
0x00008128  b        #0x8134   ; call sub_8134
0x0000812c  mov      x22, x1
0x00008130  mov      x21, x0
0x00008134  mov      x0, x26
0x00008138  bl       #0x2480c   ; call _objc_release
0x0000813c  b        #0x8148   ; call sub_8148
0x00008140  mov      x22, x1
0x00008144  mov      x21, x0
0x00008148  mov      x0, x25
0x0000814c  bl       #0x2480c   ; call _objc_release
0x00008150  b        #0x815c   ; call sub_815c
0x00008154  mov      x22, x1
0x00008158  mov      x21, x0
0x0000815c  mov      x0, x24
0x00008160  bl       #0x2480c   ; call _objc_release
0x00008164  mov      x0, x23
0x00008168  bl       #0x2480c   ; call _objc_release
0x0000816c  cmp      w22, #1
