; ==== sub_1cc74 @ 0x1cc74..0x1ccb4 (64 bytes) ====
0x0001cc74  add      x2, x2, #0x190
0x0001cc78  mov      x0, x21
0x0001cc7c  mov      x3, #0
0x0001cc80  mov      x4, x19
0x0001cc84  bl       #0x26a80   ; objc_msgSend: send:del:text:
0x0001cc88  mov      x0, x21
0x0001cc8c  bl       #0x28020   ; objc_msgSend: typed
0x0001cc90  mov      x29, x29
0x0001cc94  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001cc98  mov      x23, x0
0x0001cc9c  mov      x2, x19
0x0001cca0  bl       #0x24d60   ; objc_msgSend: appendString:
0x0001cca4  mov      x0, x23
0x0001cca8  bl       #0x2480c   ; call _objc_release
0x0001ccac  cbz      w22, #0x1ccd0
0x0001ccb0  mov      x0, x21
