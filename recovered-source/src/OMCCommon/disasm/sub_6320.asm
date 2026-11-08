; === sub_6320 @ 0x6320 size=464 ===
0x00006320  sub      sp, sp, #0x140
0x00006324  stp      x28, x27, [sp, #0xe0]
0x00006328  stp      x26, x25, [sp, #0xf0]
0x0000632c  stp      x24, x23, [sp, #0x100]
0x00006330  stp      x22, x21, [sp, #0x110]
0x00006334  stp      x20, x19, [sp, #0x120]
0x00006338  stp      x29, x30, [sp, #0x130]
0x0000633c  add      x29, sp, #0x130
0x00006340  mov      x20, x0
0x00006344  adrp     x8, #0x14000
0x00006348  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x0000634c  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x00006350  stur     x8, [x29, #-0x58]
0x00006354  adrp     x8, #0x18000
0x00006358  ldr      x0, [x8, #0x458] ; -> [classref(NSMutableArray)]
0x0000635c  bl       #0xd740 ; call objc_stub[array]
0x00006360  mov      x29, x29
0x00006364  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006368  mov      x19, x0
0x0000636c  movi     v0.16b, #0
0x00006370  stp      q0, q0, [sp, #0x10]
0x00006374  stp      q0, q0, [sp, #0x30]
0x00006378  bl       #0x60e4 ; call sub_60e4
0x0000637c  mov      x29, x29
0x00006380  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006384  mov      x21, x0
0x00006388  add      x2, sp, #0x10
0x0000638c  add      x3, sp, #0x58
0x00006390  mov      w4, #0x10
0x00006394  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00006398  cbz      x0, #0x6434
0x0000639c  mov      x23, x0
0x000063a0  ldr      x8, [sp, #0x20]
0x000063a4  ldr      x25, [x8] ; -> [selref(CGContext)]
0x000063a8  adrp     x22, #0x14000
0x000063ac  add      x22, x22, #0xd08 ; -> CFSTR("bundleIdentifier")
0x000063b0  mov      x26, #0
0x000063b4  ldr      x8, [sp, #0x20]
0x000063b8  ldr      x8, [x8] ; -> [selref(CGContext)]
0x000063bc  cmp      x8, x25
0x000063c0  b.eq     #0x63cc
0x000063c4  mov      x0, x21
0x000063c8  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x000063cc  ldr      x8, [sp, #0x18]
0x000063d0  ldr      x0, [x8, x26, lsl #3] ; -> [selref(CGContext)]
0x000063d4  mov      x1, x22
0x000063d8  bl       #0x6078 ; call sub_6078
0x000063dc  mov      x29, x29
0x000063e0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000063e4  mov      x24, x0
0x000063e8  ldr      x0, [x20, #0x20]
0x000063ec  mov      x2, x24
0x000063f0  bl       #0xd900 ; call objc_stub[containsObject:]
0x000063f4  cbz      w0, #0x6404
0x000063f8  mov      x0, x19
0x000063fc  mov      x2, x24
0x00006400  bl       #0xd6a0 ; call objc_stub[addObject:]
0x00006404  mov      x0, x24
0x00006408  bl       #0xd4b8 ; call stub:_objc_release
0x0000640c  add      x26, x26, #1
0x00006410  cmp      x23, x26
0x00006414  b.ne     #0x63b4
0x00006418  add      x2, sp, #0x10
0x0000641c  add      x3, sp, #0x58
0x00006420  mov      x0, x21
0x00006424  mov      w4, #0x10
0x00006428  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000642c  mov      x23, x0
0x00006430  cbnz     x0, #0x63b0
0x00006434  mov      x0, x21
0x00006438  bl       #0xd4b8 ; call stub:_objc_release
0x0000643c  mov      x0, x19
0x00006440  bl       #0xd960 ; call objc_stub[count]
0x00006444  cbz      x0, #0x64ac
0x00006448  adrp     x8, #0x18000
0x0000644c  ldr      x20, [x8, #0x3f0] ; -> [classref(NSString)]
0x00006450  adrp     x2, #0x14000
0x00006454  add      x2, x2, #0xa68 ; -> CFSTR(", ")
0x00006458  mov      x0, x19
0x0000645c  bl       #0xd880 ; call objc_stub[componentsJoinedByString:]
0x00006460  mov      x29, x29
0x00006464  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006468  mov      x21, x0
0x0000646c  str      x0, [sp]
0x00006470  adrp     x2, #0x14000
0x00006474  add      x2, x2, #0xe28 ; -> CFSTR("don RAM: van con chay sau 2s: %@")
0x00006478  mov      x0, x20
0x0000647c  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00006480  mov      x29, x29
0x00006484  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006488  mov      x20, x0
0x0000648c  adrp     x0, #0x14000
0x00006490  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x00006494  mov      x1, x20
0x00006498  bl       #0x6be4 ; call _OMCLogWrite
0x0000649c  mov      x0, x20
0x000064a0  bl       #0xd4b8 ; call stub:_objc_release
0x000064a4  mov      x0, x21
0x000064a8  bl       #0xd4b8 ; call stub:_objc_release
0x000064ac  mov      x0, x19
0x000064b0  bl       #0xd4b8 ; call stub:_objc_release
0x000064b4  ldur     x8, [x29, #-0x58]
0x000064b8  adrp     x9, #0x14000
0x000064bc  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x000064c0  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x000064c4  cmp      x9, x8
0x000064c8  b.ne     #0x64ec
0x000064cc  ldp      x29, x30, [sp, #0x130]
0x000064d0  ldp      x20, x19, [sp, #0x120]
0x000064d4  ldp      x22, x21, [sp, #0x110]
0x000064d8  ldp      x24, x23, [sp, #0x100]
0x000064dc  ldp      x26, x25, [sp, #0xf0]
0x000064e0  ldp      x28, x27, [sp, #0xe0]
0x000064e4  add      sp, sp, #0x140
0x000064e8  ret      
0x000064ec  bl       #0xd1b8 ; call stub:___stack_chk_fail
