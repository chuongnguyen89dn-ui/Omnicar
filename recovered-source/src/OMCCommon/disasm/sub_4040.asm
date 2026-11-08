; === sub_4040 @ 0x4040 size=64 ===
0x00004040  stp      x29, x30, [sp, #-0x10]!
0x00004044  mov      x29, sp
0x00004048  adrp     x8, #0x18000
0x0000404c  ldr      x8, [x8, #0x528] ; -> [__DATA,__bss+0x28]
0x00004050  cmn      x8, #1
0x00004054  b.ne     #0x4068
0x00004058  adrp     x8, #0x18000
0x0000405c  ldr      x0, [x8, #0x508] ; -> [__DATA,__bss+0x8]
0x00004060  ldp      x29, x30, [sp], #0x10
0x00004064  br       x0
0x00004068  adrp     x0, #0x18000
0x0000406c  add      x0, x0, #0x528 ; -> __DATA,__bss+0x28
0x00004070  adrp     x1, #0x14000
0x00004074  add      x1, x1, #0x428 ; -> __DATA_CONST,__const+0x20 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x00004078  bl       #0xd284 ; call stub:_dispatch_once
0x0000407c  b        #0x4058
