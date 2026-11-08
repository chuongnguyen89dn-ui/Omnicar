; === sub_d0c0 @ 0xd0c0 size=20 ===
0x0000d0c0  adrp     x0, #0x18000
0x0000d0c4  add      x0, x0, #0x740 ; -> __DATA,__bss+0x240
0x0000d0c8  adrp     x1, #0x14000
0x0000d0cc  add      x1, x1, #0x888 ; -> __DATA_CONST,__const+0x480 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x0000d0d0  b        #0xd284 ; call stub:_dispatch_once
