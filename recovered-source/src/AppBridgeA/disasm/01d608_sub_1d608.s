; ==== sub_1d608 @ 0x1d608..0x1d664 (92 bytes) ====
0x0001d608  mov      x0, x19
0x0001d60c  ldp      x29, x30, [sp, #0x10]
0x0001d610  ldp      x20, x19, [sp], #0x20
0x0001d614  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x0001d618  bl       #0x24204   ; call sub_24204
0x0001d61c  b        #0x1d5f8   ; call sub_1d5f8
0x0001d620  adrp     x8, #0x3e000
0x0001d624  ldr      x0, [x8, #0xa60]
0x0001d628  adrp     x9, #0x39000
0x0001d62c  add      x9, x9, #0x498
0x0001d630  str      x9, [x8, #0xa60]
0x0001d634  b        #0x2480c   ; call _objc_release
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
