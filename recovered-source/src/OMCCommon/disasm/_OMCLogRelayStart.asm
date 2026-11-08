; === _OMCLogRelayStart @ 0x7088 size=132 ===
0x00007088  stp      x20, x19, [sp, #-0x20]!
0x0000708c  stp      x29, x30, [sp, #0x10]
0x00007090  add      x29, sp, #0x10
0x00007094  adrp     x8, #0x18000
0x00007098  ldr      x8, [x8, #0x5d8] ; -> [__DATA,__bss+0xd8]
0x0000709c  cmn      x8, #1
0x000070a0  b.ne     #0x7104
0x000070a4  adrp     x8, #0x18000
0x000070a8  ldrb     w8, [x8, #0x5d0]
0x000070ac  cmp      w8, #1
0x000070b0  b.ne     #0x70f8
0x000070b4  bl       #0x705c ; call sub_705c
0x000070b8  mov      x29, x29
0x000070bc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000070c0  mov      x19, x0
0x000070c4  adrp     x2, #0x15000
0x000070c8  add      x2, x2, #0x888 ; -> CFSTR("com.anlai.omnicar/log")
0x000070cc  adrp     x5, #0x14000
0x000070d0  add      x5, x5, #0x688 ; -> __DATA_CONST,__const+0x280 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x000070d4  mov      x3, #0
0x000070d8  mov      x4, #0
0x000070dc  bl       #0xd6e0 ; call objc_stub[addObserverForName:object:queue:usingBlock:]
0x000070e0  mov      x29, x29
0x000070e4  bl       #0xd500 ; call stub:_objc_unsafeClaimAutoreleasedReturnValue
0x000070e8  mov      x0, x19
0x000070ec  ldp      x29, x30, [sp, #0x10]
0x000070f0  ldp      x20, x19, [sp], #0x20
0x000070f4  b        #0xd4b8 ; call stub:_objc_release
0x000070f8  ldp      x29, x30, [sp, #0x10]
0x000070fc  ldp      x20, x19, [sp], #0x20
0x00007100  ret      
0x00007104  bl       #0xd080 ; call sub_d080
0x00007108  b        #0x70a4
