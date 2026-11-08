; ==== sub_1d2ec @ 0x1d2ec..0x1d35c (112 bytes) ====
0x0001d2ec  str      x19, [x20, #0x20]
0x0001d2f0  ldp      x29, x30, [sp, #0x10]
0x0001d2f4  ldp      x20, x19, [sp], #0x20
0x0001d2f8  b        #0x2480c   ; call _objc_release
0x0001d2fc  ldr      x0, [x0, #0x28]
0x0001d300  ret      
0x0001d304  stp      x20, x19, [sp, #-0x20]!
0x0001d308  stp      x29, x30, [sp, #0x10]
0x0001d30c  add      x29, sp, #0x10
0x0001d310  mov      x19, x2
0x0001d314  mov      x20, x0
0x0001d318  mov      x0, x2
0x0001d31c  bl       #0x24818   ; call _objc_retain
0x0001d320  ldr      x0, [x20, #0x28]
0x0001d324  str      x19, [x20, #0x28]
0x0001d328  ldp      x29, x30, [sp, #0x10]
0x0001d32c  ldp      x20, x19, [sp], #0x20
0x0001d330  b        #0x2480c   ; call _objc_release
0x0001d334  ldr      x0, [x0, #0x30]
0x0001d338  ret      
0x0001d33c  stp      x20, x19, [sp, #-0x20]!
0x0001d340  stp      x29, x30, [sp, #0x10]
0x0001d344  add      x29, sp, #0x10
0x0001d348  mov      x19, x2
0x0001d34c  mov      x20, x0
0x0001d350  mov      x0, x2
0x0001d354  bl       #0x24818   ; call _objc_retain
0x0001d358  ldr      x0, [x20, #0x30]
