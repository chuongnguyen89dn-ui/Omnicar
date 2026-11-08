; === sub_d084 @ 0xd084 size=20 ===
0x0000d084  adrp     x0, #0x18000
0x0000d088  add      x0, x0, #0x580 ; -> __DATA,__bss+0x80
0x0000d08c  adrp     x1, #0x14000
0x0000d090  add      x1, x1, #0x6a8 ; -> __DATA_CONST,__const+0x2a0 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x0000d094  b        #0xd284 ; call stub:_dispatch_once
