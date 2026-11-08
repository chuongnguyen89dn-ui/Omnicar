; block literal @0x34b60 desc @0x34610 sig=v8@?0 flags=0x50000000
; ==== sub_1d638 @ 0x1d638..0x1d664 (44 bytes) ====
0x0001d638  stp      x29, x30, [sp, #-0x10]!
0x0001d63c  mov      x29, sp
0x0001d640  adrp     x8, #0x3e000
0x0001d644  ldr      x0, [x8, #0xa70]
0x0001d648  adrp     x9, #0x39000
0x0001d64c  add      x9, x9, #0x630
0x0001d650  str      x9, [x8, #0xa70]
0x0001d654  bl       #0x2480c   ; call _objc_release
0x0001d658  adrp     x8, #0x3e000
0x0001d65c  ldr      x0, [x8, #0xa78]
0x0001d660  adrp     x9, #0x39000

