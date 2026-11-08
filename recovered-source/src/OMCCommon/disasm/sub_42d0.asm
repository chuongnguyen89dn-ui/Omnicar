; === sub_42d0 @ 0x42d0 size=180 ===
0x000042d0  stp      x20, x19, [sp, #-0x20]!
0x000042d4  stp      x29, x30, [sp, #0x10]
0x000042d8  add      x29, sp, #0x10
0x000042dc  cbz      x0, #0x4344
0x000042e0  mov      x19, x1
0x000042e4  mov      x20, x0
0x000042e8  cbnz     x1, #0x42f8
0x000042ec  mov      w0, #0x400
0x000042f0  bl       #0xd3bc ; call stub:_malloc
0x000042f4  mov      x19, x0
0x000042f8  adrp     x8, #0x18000
0x000042fc  ldr      x8, [x8, #0x528] ; -> [__DATA,__bss+0x28]
0x00004300  cmn      x8, #1
0x00004304  b.ne     #0x436c
0x00004308  adrp     x8, #0x18000
0x0000430c  ldr      x8, [x8, #0x508] ; -> [__DATA,__bss+0x8]
0x00004310  blr      x8
0x00004314  ldrb     w8, [x20]
0x00004318  cmp      w8, #0x2f
0x0000431c  b.ne     #0x434c
0x00004320  mov      x1, x0
0x00004324  mov      x0, x19
0x00004328  mov      w2, #0x400
0x0000432c  bl       #0xd59c ; call stub:_strlcpy
0x00004330  mov      x0, x19
0x00004334  mov      x1, x20
0x00004338  mov      w2, #0x400
0x0000433c  bl       #0xd590 ; call stub:_strlcat
0x00004340  b        #0x435c
0x00004344  mov      x19, #0
0x00004348  b        #0x435c
0x0000434c  mov      x0, x19
0x00004350  mov      x1, x20
0x00004354  mov      w2, #0x400
0x00004358  bl       #0xd59c ; call stub:_strlcpy
0x0000435c  mov      x0, x19
0x00004360  ldp      x29, x30, [sp, #0x10]
0x00004364  ldp      x20, x19, [sp], #0x20
0x00004368  ret      
0x0000436c  adrp     x0, #0x18000
0x00004370  add      x0, x0, #0x528 ; -> __DATA,__bss+0x28
0x00004374  adrp     x1, #0x14000
0x00004378  add      x1, x1, #0x428 ; -> __DATA_CONST,__const+0x20 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x0000437c  bl       #0xd284 ; call stub:_dispatch_once
0x00004380  b        #0x4308
