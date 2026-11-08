; === sub_d0ac @ 0xd0ac size=20 ===
0x0000d0ac  adrp     x0, #0x18000
0x0000d0b0  add      x0, x0, #0x730 ; -> __DATA,__bss+0x230
0x0000d0b4  adrp     x1, #0x14000
0x0000d0b8  add      x1, x1, #0x868 ; -> __DATA_CONST,__const+0x460 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x0000d0bc  b        #0xd284 ; call stub:_dispatch_once
