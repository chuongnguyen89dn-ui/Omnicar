; === sub_71e8 @ 0x71e8 size=36 ===
0x000071e8  stp      x20, x19, [sp, #-0x20]!
0x000071ec  stp      x29, x30, [sp, #0x10]
0x000071f0  add      x29, sp, #0x10
0x000071f4  mov      x19, x0
0x000071f8  bl       #0x6f2c ; call sub_6f2c
0x000071fc  ldr      x0, [x19, #0x20]
0x00007200  ldp      x29, x30, [sp, #0x10]
0x00007204  ldp      x20, x19, [sp], #0x20
0x00007208  b        #0x6fec ; call sub_6fec
