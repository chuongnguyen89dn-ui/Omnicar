; ==== sub_9888 @ 0x9888..0x98c0 (56 bytes) ====
0x00009888  adrp     x9, #0x3e000
0x0000988c  ldr      x8, [x9, #0xa20]
0x00009890  str      x0, [x9, #0xa20]
0x00009894  mov      x0, x8
0x00009898  ldp      x29, x30, [sp], #0x10
0x0000989c  b        #0x2480c   ; call _objc_release
0x000098a0  sub      sp, sp, #0x80
0x000098a4  stp      d13, d12, [sp, #0x10]
0x000098a8  stp      d11, d10, [sp, #0x20]
0x000098ac  stp      d9, d8, [sp, #0x30]
0x000098b0  stp      x24, x23, [sp, #0x40]
0x000098b4  stp      x22, x21, [sp, #0x50]
0x000098b8  stp      x20, x19, [sp, #0x60]
0x000098bc  stp      x29, x30, [sp, #0x70]
