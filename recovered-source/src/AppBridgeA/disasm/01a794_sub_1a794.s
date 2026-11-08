; ==== sub_1a794 @ 0x1a794..0x1a7dc (72 bytes) ====
0x0001a794  adrp     x8, #0x2b000
0x0001a798  ldr      d10, [x8, #0x228]
0x0001a79c  fmov     d3, #1.00000000
0x0001a7a0  mov      v0.16b, v8.16b
0x0001a7a4  mov      v1.16b, v9.16b
0x0001a7a8  mov      v2.16b, v10.16b
0x0001a7ac  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001a7b0  mov      x29, x29
0x0001a7b4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a7b8  mov      x26, x0
0x0001a7bc  mov      x0, x25
0x0001a7c0  mov      x2, x26
0x0001a7c4  mov      x3, #0
0x0001a7c8  bl       #0x27980   ; objc_msgSend: setTitleColor:forState:
0x0001a7cc  mov      x0, x26
0x0001a7d0  bl       #0x2480c   ; call _objc_release
0x0001a7d4  mov      x0, x25
0x0001a7d8  bl       #0x25f00   ; objc_msgSend: layer
