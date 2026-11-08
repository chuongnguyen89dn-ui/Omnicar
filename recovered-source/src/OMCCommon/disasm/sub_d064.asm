; === sub_d064 @ 0xd064 size=20 ===
0x0000d064  adrp     x0, #0x18000
0x0000d068  add      x0, x0, #0x5c8 ; -> __DATA,__bss+0xc8
0x0000d06c  adrp     x1, #0x14000
0x0000d070  add      x1, x1, #0x6c8 ; -> __DATA_CONST,__const+0x2c0 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x0000d074  b        #0xd284 ; call stub:_dispatch_once
