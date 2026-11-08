; === _OMCPref @ 0x6534 size=104 ===
0x00006534  stp      x22, x21, [sp, #-0x30]!
0x00006538  stp      x20, x19, [sp, #0x10]
0x0000653c  stp      x29, x30, [sp, #0x20]
0x00006540  add      x29, sp, #0x20
0x00006544  mov      x19, x1
0x00006548  mov      x20, x0
0x0000654c  mov      x0, x1
0x00006550  bl       #0xd4c4 ; call stub:_objc_retain
0x00006554  adrp     x1, #0x14000
0x00006558  add      x1, x1, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x0000655c  mov      x0, x20
0x00006560  bl       #0xd0ec ; call stub:_CFPreferencesCopyAppValue
0x00006564  mov      x20, x0
0x00006568  cmp      x0, #0
0x0000656c  csel     x21, x19, x0, eq
0x00006570  mov      x0, x21
0x00006574  bl       #0xd4c4 ; call stub:_objc_retain
0x00006578  mov      x0, x19
0x0000657c  bl       #0xd4b8 ; call stub:_objc_release
0x00006580  mov      x0, x20
0x00006584  bl       #0xd4b8 ; call stub:_objc_release
0x00006588  mov      x0, x21
0x0000658c  ldp      x29, x30, [sp, #0x20]
0x00006590  ldp      x20, x19, [sp, #0x10]
0x00006594  ldp      x22, x21, [sp], #0x30
0x00006598  b        #0xd434 ; call stub:_objc_autoreleaseReturnValue
