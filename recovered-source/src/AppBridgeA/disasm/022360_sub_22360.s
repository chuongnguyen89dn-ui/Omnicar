; ==== sub_22360 @ 0x22360..0x22384 (36 bytes) ====
0x00022360  mov      x29, sp
0x00022364  adrp     x8, #0x3e000
0x00022368  ldr      w8, [x8, #0xc1c]
0x0002236c  cbnz     w8, #0x2237c
0x00022370  adrp     x0, #0x3e000
0x00022374  add      x0, x0, #0xc18
0x00022378  bl       #0x246b0   ; call _mach_timebase_info
0x0002237c  bl       #0x2468c   ; call _mach_absolute_time
0x00022380  ucvtf    d0, x0
