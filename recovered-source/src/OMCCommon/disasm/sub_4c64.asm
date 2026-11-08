; === sub_4c64 @ 0x4c64 size=52 ===
0x00004c64  stp      x29, x30, [sp, #-0x10]!
0x00004c68  mov      x29, sp
0x00004c6c  mov      x1, #0x5000
0x00004c70  movk     x1, #0xdcd6, lsl #16
0x00004c74  movk     x1, #1, lsl #32
0x00004c78  mov      x0, #0
0x00004c7c  bl       #0xd2d8 ; call stub:_dispatch_time
0x00004c80  adrp     x1, #0x14000
0x00004c84  ldr      x1, [x1, #0x1d0] ; -> [got(__dispatch_main_q)]
0x00004c88  adrp     x2, #0x14000
0x00004c8c  add      x2, x2, #0x528 ; -> __DATA_CONST,__const+0x120 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x00004c90  ldp      x29, x30, [sp], #0x10
0x00004c94  b        #0xd260 ; call stub:_dispatch_after
