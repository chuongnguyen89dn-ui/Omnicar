; === sub_4080 @ 0x4080 size=64 ===
0x00004080  stp      x29, x30, [sp, #-0x10]!
0x00004084  mov      x29, sp
0x00004088  adrp     x8, #0x18000
0x0000408c  ldr      x8, [x8, #0x528] ; -> [__DATA,__bss+0x28]
0x00004090  cmn      x8, #1
0x00004094  b.ne     #0x40a8
0x00004098  adrp     x8, #0x18000
0x0000409c  ldr      x0, [x8, #0x510] ; -> [__DATA,__bss+0x10]
0x000040a0  ldp      x29, x30, [sp], #0x10
0x000040a4  br       x0
0x000040a8  adrp     x0, #0x18000
0x000040ac  add      x0, x0, #0x528 ; -> __DATA,__bss+0x28
0x000040b0  adrp     x1, #0x14000
0x000040b4  add      x1, x1, #0x428 ; -> __DATA_CONST,__const+0x20 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x000040b8  bl       #0xd284 ; call stub:_dispatch_once
0x000040bc  b        #0x4098
