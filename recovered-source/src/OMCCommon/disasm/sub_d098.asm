; === sub_d098 @ 0xd098 size=20 ===
0x0000d098  adrp     x0, #0x18000
0x0000d09c  add      x0, x0, #0x5e8 ; -> __DATA,__bss+0xe8
0x0000d0a0  adrp     x1, #0x14000
0x0000d0a4  add      x1, x1, #0x708 ; -> __DATA_CONST,__const+0x300 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x0000d0a8  b        #0xd284 ; call stub:_dispatch_once
