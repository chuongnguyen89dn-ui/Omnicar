; === sub_6050 @ 0x6050 size=40 ===
0x00006050  stp      x20, x19, [sp, #-0x20]!
0x00006054  stp      x29, x30, [sp, #0x10]
0x00006058  add      x29, sp, #0x10
0x0000605c  mov      x19, x0
0x00006060  ldr      x0, [x0, #0x28]
0x00006064  bl       #0xd4b8 ; call stub:_objc_release
0x00006068  ldr      x0, [x19, #0x20]
0x0000606c  ldp      x29, x30, [sp, #0x10]
0x00006070  ldp      x20, x19, [sp], #0x20
0x00006074  b        #0xd4b8 ; call stub:_objc_release
