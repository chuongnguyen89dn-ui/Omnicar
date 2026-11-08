; === sub_8f7c @ 0x8f7c size=68 ===
0x00008f7c  stp      x20, x19, [sp, #-0x20]!
0x00008f80  stp      x29, x30, [sp, #0x10]
0x00008f84  add      x29, sp, #0x10
0x00008f88  adrp     x19, #0x18000
0x00008f8c  ldr      x0, [x19, #0x5f0] ; -> [__DATA,__bss+0xf0]
0x00008f90  cbnz     x0, #0x8fb4
0x00008f94  adrp     x0, #0xf000
0x00008f98  add      x0, x0, #0x301 ; -> "OMC_CRASHGUARD"
0x00008f9c  bl       #0xd344 ; call stub:_getenv
0x00008fa0  cbz      x0, #0x8fb4
0x00008fa4  mov      x1, #0
0x00008fa8  mov      w2, #0x10
0x00008fac  bl       #0xd5d8 ; call stub:_strtoull
0x00008fb0  str      x0, [x19, #0x5f0]
0x00008fb4  ldp      x29, x30, [sp, #0x10]
0x00008fb8  ldp      x20, x19, [sp], #0x20
0x00008fbc  ret      
