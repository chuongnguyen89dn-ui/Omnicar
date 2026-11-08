; === sub_6dd0 @ 0x6dd0 size=68 ===
0x00006dd0  stp      x20, x19, [sp, #-0x20]!
0x00006dd4  stp      x29, x30, [sp, #0x10]
0x00006dd8  add      x29, sp, #0x10
0x00006ddc  adrp     x8, #0x18000
0x00006de0  ldr      x8, [x8, #0x5c8] ; -> [__DATA,__bss+0xc8]
0x00006de4  cmn      x8, #1
0x00006de8  b.ne     #0x6e0c
0x00006dec  adrp     x8, #0x18000
0x00006df0  ldr      x19, [x8, #0x5c0] ; -> [__DATA,__bss+0xc0]
0x00006df4  mov      x0, x19
0x00006df8  bl       #0xd4c4 ; call stub:_objc_retain
0x00006dfc  mov      x0, x19
0x00006e00  ldp      x29, x30, [sp, #0x10]
0x00006e04  ldp      x20, x19, [sp], #0x20
0x00006e08  b        #0xd434 ; call stub:_objc_autoreleaseReturnValue
0x00006e0c  bl       #0xd064 ; call sub_d064
0x00006e10  b        #0x6dec
