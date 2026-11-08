; === sub_929c @ 0x929c size=96 ===
0x0000929c  stp      x20, x19, [sp, #-0x20]!
0x000092a0  stp      x29, x30, [sp, #0x10]
0x000092a4  add      x29, sp, #0x10
0x000092a8  adrp     x8, #0x18000
0x000092ac  ldr      x0, [x8, #0x400] ; -> [classref(NSBundle)]
0x000092b0  bl       #0xdd40 ; call objc_stub[mainBundle]
0x000092b4  mov      x29, x29
0x000092b8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000092bc  mov      x19, x0
0x000092c0  bl       #0xd800 ; call objc_stub[bundleIdentifier]
0x000092c4  mov      x29, x29
0x000092c8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000092cc  mov      x20, x0
0x000092d0  adrp     x2, #0x15000
0x000092d4  add      x2, x2, #0xd08 ; -> CFSTR("com.apple.springboard")
0x000092d8  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x000092dc  adrp     x8, #0x18000
0x000092e0  strb     w0, [x8, #0x5d0]
0x000092e4  mov      x0, x20
0x000092e8  bl       #0xd4b8 ; call stub:_objc_release
0x000092ec  mov      x0, x19
0x000092f0  ldp      x29, x30, [sp, #0x10]
0x000092f4  ldp      x20, x19, [sp], #0x20
0x000092f8  b        #0xd4b8 ; call stub:_objc_release
