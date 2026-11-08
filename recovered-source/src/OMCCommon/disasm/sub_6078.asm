; === sub_6078 @ 0x6078 size=108 ===
0x00006078  stp      x20, x19, [sp, #-0x20]!
0x0000607c  stp      x29, x30, [sp, #0x10]
0x00006080  add      x29, sp, #0x10
0x00006084  mov      x20, x1
0x00006088  mov      x19, x0
0x0000608c  bl       #0xd4c4 ; call stub:_objc_retain
0x00006090  mov      x0, x20
0x00006094  bl       #0xd170 ; call stub:_NSSelectorFromString
0x00006098  mov      x20, x0
0x0000609c  mov      x0, x19
0x000060a0  mov      x1, x20
0x000060a4  bl       #0xd4a0 ; call stub:_objc_opt_respondsToSelector
0x000060a8  tbz      w0, #0, #0x60c8
0x000060ac  mov      x0, x19
0x000060b0  mov      x1, x20
0x000060b4  bl       #0xd470 ; call stub:_objc_msgSend
0x000060b8  mov      x29, x29
0x000060bc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000060c0  mov      x20, x0
0x000060c4  b        #0x60cc
0x000060c8  mov      x20, #0
0x000060cc  mov      x0, x19
0x000060d0  bl       #0xd4b8 ; call stub:_objc_release
0x000060d4  mov      x0, x20
0x000060d8  ldp      x29, x30, [sp, #0x10]
0x000060dc  ldp      x20, x19, [sp], #0x20
0x000060e0  b        #0xd434 ; call stub:_objc_autoreleaseReturnValue
