; ==== sub_12910 @ 0x12910..0x12944 (52 bytes) ====
0x00012910  cbz      x0, #0x12974
0x00012914  ldr      x8, [sp, #0x10]
0x00012918  ldr      x23, [x8]
0x0001291c  mov      x24, #0
0x00012920  ldr      x8, [sp, #0x10]
0x00012924  ldr      x8, [x8]
0x00012928  cmp      x8, x23
0x0001292c  b.eq     #0x12938
0x00012930  mov      x0, x19
0x00012934  bl       #0x24770   ; call _objc_enumerationMutation
0x00012938  ldr      x8, [sp, #8]
0x0001293c  ldr      x3, [x8, x24, lsl #3]
0x00012940  mov      x0, x21
