; === sub_d02c @ 0xd02c size=36 ===
0x0000d02c  stp      x29, x30, [sp, #-0x10]!
0x0000d030  mov      x29, sp
0x0000d034  adrp     x0, #0x18000
0x0000d038  add      x0, x0, #0x548 ; -> __DATA,__bss+0x48
0x0000d03c  adrp     x1, #0x14000
0x0000d040  add      x1, x1, #0x648 ; -> __DATA_CONST,__const+0x240 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x0000d044  bl       #0xd284 ; call stub:_dispatch_once
0x0000d048  ldp      x29, x30, [sp], #0x10
0x0000d04c  ret      
