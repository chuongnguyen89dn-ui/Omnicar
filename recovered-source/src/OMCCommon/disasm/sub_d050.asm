; === sub_d050 @ 0xd050 size=20 ===
0x0000d050  adrp     x0, #0x18000
0x0000d054  add      x0, x0, #0x568 ; -> __DATA,__bss+0x68
0x0000d058  adrp     x1, #0x14000
0x0000d05c  add      x1, x1, #0x668 ; -> __DATA_CONST,__const+0x260 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x0000d060  b        #0xd284 ; call stub:_dispatch_once
