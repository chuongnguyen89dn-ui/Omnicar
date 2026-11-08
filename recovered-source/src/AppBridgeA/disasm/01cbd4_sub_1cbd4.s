; ==== sub_1cbd4 @ 0x1cbd4..0x1cc14 (64 bytes) ====
0x0001cbd4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001cbd8  mov      x24, x0
0x0001cbdc  bl       #0x25fa0   ; objc_msgSend: length
0x0001cbe0  mov      x27, x0
0x0001cbe4  mov      x0, x21
0x0001cbe8  bl       #0x28220   ; objc_msgSend: word
0x0001cbec  mov      x29, x29
0x0001cbf0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001cbf4  mov      x26, x0
0x0001cbf8  bl       #0x25fa0   ; objc_msgSend: length
0x0001cbfc  mov      x3, x0
0x0001cc00  sub      x2, x25, x27
0x0001cc04  mov      x0, x22
0x0001cc08  bl       #0x25540   ; objc_msgSend: deleteCharactersInRange:
0x0001cc0c  mov      x0, x26
0x0001cc10  bl       #0x2480c   ; call _objc_release
