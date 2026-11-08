; === sub_4000 @ 0x4000 size=64 ===
0x00004000  stp      x29, x30, [sp, #-0x10]!
0x00004004  mov      x29, sp
0x00004008  adrp     x8, #0x18000
0x0000400c  ldr      x8, [x8, #0x528] ; -> [__DATA,__bss+0x28]
0x00004010  cmn      x8, #1
0x00004014  b.ne     #0x4028
0x00004018  adrp     x8, #0x18000
0x0000401c  ldr      x0, [x8, #0x500] ; -> [__DATA,__bss+0x0]
0x00004020  ldp      x29, x30, [sp], #0x10
0x00004024  br       x0
0x00004028  adrp     x0, #0x18000
0x0000402c  add      x0, x0, #0x528 ; -> __DATA,__bss+0x28
0x00004030  adrp     x1, #0x14000
0x00004034  add      x1, x1, #0x428 ; -> __DATA_CONST,__const+0x20 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x00004038  bl       #0xd284 ; call stub:_dispatch_once
0x0000403c  b        #0x4018
