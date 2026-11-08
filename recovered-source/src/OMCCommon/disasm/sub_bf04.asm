; === sub_bf04 @ 0xbf04 size=148 ===
0x0000bf04  ldr      x8, [x0, #0x20]
0x0000bf08  adrp     x9, #0x18000
0x0000bf0c  ldr      x9, [x9, #0x608] ; -> [__DATA,__bss+0x108]
0x0000bf10  cmp      x8, x9
0x0000bf14  b.ne     #0xbf94
0x0000bf18  stp      x20, x19, [sp, #-0x20]!
0x0000bf1c  stp      x29, x30, [sp, #0x10]
0x0000bf20  add      x29, sp, #0x10
0x0000bf24  adrp     x19, #0x18000
0x0000bf28  ldr      x0, [x19, #0x590] ; -> [__DATA,__bss+0x90]
0x0000bf2c  bl       #0xdc40 ; call objc_stub[invalidate]
0x0000bf30  ldr      x0, [x19, #0x590] ; -> [__DATA,__bss+0x90]
0x0000bf34  str      xzr, [x19, #0x590]
0x0000bf38  bl       #0xd4b8 ; call stub:_objc_release
0x0000bf3c  adrp     x8, #0x18000
0x0000bf40  ldr      d0, [x8, #0x628] ; -> [__DATA,__bss+0x128]
0x0000bf44  adrp     x8, #0x18000
0x0000bf48  ldr      d1, [x8, #0x6a0] ; -> [__DATA,__bss+0x1a0]
0x0000bf4c  fsub     d0, d0, d1
0x0000bf50  mov      x8, #0x4059000000000000
0x0000bf54  fmov     d1, x8
0x0000bf58  fcmp     d0, d1
0x0000bf5c  ldp      x29, x30, [sp, #0x10]
0x0000bf60  ldp      x20, x19, [sp], #0x20
0x0000bf64  b.lt     #0xbf94
0x0000bf68  adrp     x8, #0x18000
0x0000bf6c  ldr      d1, [x8, #0x620] ; -> [__DATA,__bss+0x120]
0x0000bf70  adrp     x8, #0x18000
0x0000bf74  ldr      d2, [x8, #0x698] ; -> [__DATA,__bss+0x198]
0x0000bf78  fsub     d1, d1, d2
0x0000bf7c  mov      x8, #0x4059000000000000
0x0000bf80  fmov     d2, x8
0x0000bf84  fmul     d1, d1, d2
0x0000bf88  fdiv     d0, d1, d0
0x0000bf8c  adrp     x8, #0x18000
0x0000bf90  str      d0, [x8, #0x6a8]
0x0000bf94  ret      
