; ==== sub_1cc24 @ 0x1cc24..0x1cc64 (64 bytes) ====
0x0001cc24  mov      x0, x22
0x0001cc28  bl       #0x2480c   ; call _objc_release
0x0001cc2c  mov      x0, x21
0x0001cc30  bl       #0x28020   ; objc_msgSend: typed
0x0001cc34  mov      x29, x29
0x0001cc38  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001cc3c  mov      x22, x0
0x0001cc40  mov      x2, x20
0x0001cc44  bl       #0x24d60   ; objc_msgSend: appendString:
0x0001cc48  mov      x0, x22
0x0001cc4c  bl       #0x2480c   ; call _objc_release
0x0001cc50  mov      x0, x21
0x0001cc54  bl       #0x28220   ; objc_msgSend: word
0x0001cc58  mov      x29, x29
0x0001cc5c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001cc60  mov      x22, x0
