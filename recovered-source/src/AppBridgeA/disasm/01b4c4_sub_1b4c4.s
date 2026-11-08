; ==== sub_1b4c4 @ 0x1b4c4..0x1b4f4 (48 bytes) ====
0x0001b4c4  mov      x21, x0
0x0001b4c8  cbz      x0, #0x1b524
0x0001b4cc  ldr      x8, [sp, #0xc0]
0x0001b4d0  ldr      x22, [x8]
0x0001b4d4  mov      x23, #0
0x0001b4d8  ldr      x8, [sp, #0xc0]
0x0001b4dc  ldr      x8, [x8]
0x0001b4e0  cmp      x8, x22
0x0001b4e4  b.eq     #0x1b4f0
0x0001b4e8  mov      x0, x19
0x0001b4ec  bl       #0x24770   ; call _objc_enumerationMutation
0x0001b4f0  ldr      x8, [sp, #0xb8]
