; === sub_705c @ 0x705c size=44 ===
0x0000705c  stp      x29, x30, [sp, #-0x10]!
0x00007060  mov      x29, sp
0x00007064  adrp     x0, #0x15000
0x00007068  add      x0, x0, #0xd48 ; -> CFSTR("NSDistributedNotificationCenter")
0x0000706c  bl       #0xd14c ; call stub:_NSClassFromString
0x00007070  cbz      x0, #0x7080
0x00007074  bl       #0xda20 ; call objc_stub[defaultCenter]
0x00007078  mov      x29, x29
0x0000707c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007080  ldp      x29, x30, [sp], #0x10
0x00007084  b        #0xd434 ; call stub:_objc_autoreleaseReturnValue
