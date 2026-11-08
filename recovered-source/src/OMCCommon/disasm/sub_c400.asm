; === sub_c400 @ 0xc400 size=20 ===
0x0000c400  adrp     x0, #0x18000
0x0000c404  add      x0, x0, #0x5d8 ; -> __DATA,__bss+0xd8
0x0000c408  adrp     x1, #0x14000
0x0000c40c  add      x1, x1, #0x6e8 ; -> __DATA_CONST,__const+0x2e0 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x0000c410  b        #0xd284 ; call stub:_dispatch_once
