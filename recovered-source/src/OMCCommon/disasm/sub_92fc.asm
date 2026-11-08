; === sub_92fc @ 0x92fc size=96 ===
0x000092fc  stp      x20, x19, [sp, #-0x20]!
0x00009300  stp      x29, x30, [sp, #0x10]
0x00009304  add      x29, sp, #0x10
0x00009308  adrp     x8, #0x18000
0x0000930c  ldr      x0, [x8, #0x400] ; -> [classref(NSBundle)]
0x00009310  bl       #0xdd40 ; call objc_stub[mainBundle]
0x00009314  mov      x29, x29
0x00009318  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000931c  mov      x19, x0
0x00009320  bl       #0xd800 ; call objc_stub[bundleIdentifier]
0x00009324  mov      x29, x29
0x00009328  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000932c  mov      x20, x0
0x00009330  adrp     x2, #0x15000
0x00009334  add      x2, x2, #0xd68 ; -> CFSTR("com.apple.CarPlayApp")
0x00009338  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x0000933c  adrp     x8, #0x18000
0x00009340  strb     w0, [x8, #0x5e0]
0x00009344  mov      x0, x20
0x00009348  bl       #0xd4b8 ; call stub:_objc_release
0x0000934c  mov      x0, x19
0x00009350  ldp      x29, x30, [sp, #0x10]
0x00009354  ldp      x20, x19, [sp], #0x20
0x00009358  b        #0xd4b8 ; call stub:_objc_release
