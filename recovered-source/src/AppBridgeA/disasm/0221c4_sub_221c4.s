; ==== sub_221c4 @ 0x221c4..0x221f0 (44 bytes) ====
0x000221c4  adrp     x8, #0x2b000
0x000221c8  ldr      d10, [x8, #0x438]
0x000221cc  str      w21, [sp, #0x28]
0x000221d0  ldr      x8, [sp, #0x30]
0x000221d4  ldr      w0, [x8, x20, lsl #2]
0x000221d8  add      x2, sp, #0x38
0x000221dc  add      x3, sp, #0x28
0x000221e0  mov      w1, #3
0x000221e4  bl       #0x249a4   ; call _thread_info
0x000221e8  cbnz     w0, #0x2220c
0x000221ec  ldrb     w8, [sp, #0x54]
