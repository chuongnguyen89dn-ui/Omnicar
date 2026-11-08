; ==== sub_98c0 @ 0x98c0..0x98f8 (56 bytes) ====
0x000098c0  add      x29, sp, #0x70
0x000098c4  mov      x19, x2
0x000098c8  mov      v8.16b, v1.16b
0x000098cc  mov      v9.16b, v0.16b
0x000098d0  mov      x20, x0
0x000098d4  mov      x0, x2
0x000098d8  bl       #0x24818   ; call _objc_retain
0x000098dc  adrp     x8, #0x3e000
0x000098e0  ldr      x8, [x8, #0x460]
0x000098e4  stp      x20, x8, [sp]
0x000098e8  adrp     x8, #0x3d000
0x000098ec  ldr      x1, [x8, #0x250]   ; -> [@selector(pointInside:withEvent:)]
0x000098f0  mov      x0, sp
0x000098f4  mov      v0.16b, v9.16b
