; === sub_97e4 @ 0x97e4 size=48 ===
0x000097e4  stp      x29, x30, [sp, #-0x10]!
0x000097e8  mov      x29, sp
0x000097ec  mov      x0, #0
0x000097f0  mov      w1, #0x2800
0x000097f4  movk     w1, #0xee6b, lsl #16
0x000097f8  bl       #0xd2d8 ; call stub:_dispatch_time
0x000097fc  adrp     x1, #0x14000
0x00009800  ldr      x1, [x1, #0x1d0] ; -> [got(__dispatch_main_q)]
0x00009804  adrp     x2, #0x14000
0x00009808  add      x2, x2, #0x768 ; -> __DATA_CONST,__const+0x360 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x0000980c  ldp      x29, x30, [sp], #0x10
0x00009810  b        #0xd260 ; call stub:_dispatch_after
