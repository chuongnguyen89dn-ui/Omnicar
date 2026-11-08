; ==== sub_1cb84 @ 0x1cb84..0x1cbc4 (64 bytes) ====
0x0001cb84  bl       #0x2480c   ; call _objc_release
0x0001cb88  mov      x0, x22
0x0001cb8c  bl       #0x2480c   ; call _objc_release
0x0001cb90  cmp      x23, x25
0x0001cb94  b.lo     #0x1cc2c
0x0001cb98  mov      x0, x21
0x0001cb9c  bl       #0x28020   ; objc_msgSend: typed
0x0001cba0  mov      x29, x29
0x0001cba4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001cba8  mov      x22, x0
0x0001cbac  mov      x0, x21
0x0001cbb0  bl       #0x28020   ; objc_msgSend: typed
0x0001cbb4  mov      x29, x29
0x0001cbb8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001cbbc  mov      x23, x0
0x0001cbc0  bl       #0x25fa0   ; objc_msgSend: length
