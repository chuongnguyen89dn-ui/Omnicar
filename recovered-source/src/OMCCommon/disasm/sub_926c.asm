; === sub_926c @ 0x926c size=48 ===
0x0000926c  stp      x29, x30, [sp, #-0x10]!
0x00009270  mov      x29, sp
0x00009274  adrp     x0, #0xf000
0x00009278  add      x0, x0, #0x2b9 ; -> "com.anlai.omnicar.log"
0x0000927c  mov      x1, #0
0x00009280  bl       #0xd290 ; call stub:_dispatch_queue_create
0x00009284  adrp     x9, #0x18000
0x00009288  ldr      x8, [x9, #0x5c0] ; -> [__DATA,__bss+0xc0]
0x0000928c  str      x0, [x9, #0x5c0]
0x00009290  mov      x0, x8
0x00009294  ldp      x29, x30, [sp], #0x10
0x00009298  b        #0xd4b8 ; call stub:_objc_release
