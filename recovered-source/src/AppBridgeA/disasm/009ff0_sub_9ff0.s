; ==== sub_9ff0 @ 0x9ff0..0xa028 (56 bytes) ====
0x00009ff0  fadd     d4, d11, d12
0x00009ff4  fmul     d4, d4, d13
0x00009ff8  fcmp     d4, #0.0
0x00009ffc  fcsel    d5, d14, d4, gt
0x0000a000  mov      v4.16b, v10.16b
0x0000a004  bl       #0x243b0   ; call _CGRectInset
0x0000a008  mov      v4.16b, v9.16b
0x0000a00c  mov      v5.16b, v8.16b
0x0000a010  ldp      x29, x30, [sp, #0x50]
0x0000a014  ldp      x20, x19, [sp, #0x40]
0x0000a018  ldp      d9, d8, [sp, #0x30]
0x0000a01c  ldp      d11, d10, [sp, #0x20]
0x0000a020  ldp      d13, d12, [sp, #0x10]
0x0000a024  ldp      d15, d14, [sp], #0x60
