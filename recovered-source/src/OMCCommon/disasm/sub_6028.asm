; === sub_6028 @ 0x6028 size=40 ===
0x00006028  stp      x20, x19, [sp, #-0x20]!
0x0000602c  stp      x29, x30, [sp, #0x10]
0x00006030  add      x29, sp, #0x10
0x00006034  mov      x19, x1
0x00006038  ldr      x0, [x1, #0x20]
0x0000603c  bl       #0xd4c4 ; call stub:_objc_retain
0x00006040  ldr      x0, [x19, #0x28]
0x00006044  ldp      x29, x30, [sp, #0x10]
0x00006048  ldp      x20, x19, [sp], #0x20
0x0000604c  b        #0xd4c4 ; call stub:_objc_retain
