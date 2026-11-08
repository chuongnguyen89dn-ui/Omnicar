; ==== sub_1b4f4 @ 0x1b4f4..0x1b538 (68 bytes) ====
0x0001b4f4  ldr      x0, [x8, x23, lsl #3]
0x0001b4f8  bl       #0x26840   ; objc_msgSend: removeFromSuperview
0x0001b4fc  add      x23, x23, #1
0x0001b500  cmp      x21, x23
0x0001b504  b.ne     #0x1b4d8
0x0001b508  add      x2, sp, #0xb0
0x0001b50c  sub      x3, x29, #0x100
0x0001b510  mov      x0, x19
0x0001b514  mov      w4, #0x10
0x0001b518  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001b51c  mov      x21, x0
0x0001b520  cbnz     x0, #0x1b4d4
0x0001b524  mov      x0, x19
0x0001b528  bl       #0x2480c   ; call _objc_release
0x0001b52c  adrp     x8, #0x3e000
0x0001b530  ldr      x0, [x8, #0x318]   ; -> [class(NSMutableArray)]
0x0001b534  bl       #0x24dc0   ; objc_msgSend: array
