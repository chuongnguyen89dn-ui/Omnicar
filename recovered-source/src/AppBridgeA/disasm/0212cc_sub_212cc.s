; ==== sub_212cc @ 0x212cc..0x212fc (48 bytes) ====
0x000212cc  adrp     x3, #0x38000
0x000212d0  add      x3, x3, #0x1b0   ; -> @"points"
0x000212d4  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x000212d8  mov      x0, x19
0x000212dc  bl       #0x2480c   ; call _objc_release
0x000212e0  ldr      x0, [sp, #0x70]
0x000212e4  bl       #0x26220   ; objc_msgSend: nativeBounds
0x000212e8  adrp     x8, #0x3e000
0x000212ec  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x000212f0  stp      d2, d3, [sp]
0x000212f4  adrp     x2, #0x38000
0x000212f8  add      x2, x2, #0x670   ; -> @"%.0fx%.0f"
