; ==== sub_1b494 @ 0x1b494..0x1b4c4 (48 bytes) ====
0x0001b494  mov      x22, x0
0x0001b498  bl       #0x253e0   ; objc_msgSend: copy
0x0001b49c  mov      x19, x0
0x0001b4a0  mov      x0, x22
0x0001b4a4  bl       #0x2480c   ; call _objc_release
0x0001b4a8  mov      x0, x21
0x0001b4ac  bl       #0x2480c   ; call _objc_release
0x0001b4b0  add      x2, sp, #0xb0
0x0001b4b4  sub      x3, x29, #0x100
0x0001b4b8  mov      x0, x19
0x0001b4bc  mov      w4, #0x10
0x0001b4c0  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
