=== -[SSGauge arc]  va=0x45fcc size=8 types=@16@0:8
0x00045fcc  ldr      x0, [x0, #0x10]
0x00045fd0  ret      

=== -[SSGauge setArc:]  va=0x45fd4 size=48 types=v24@0:8@16
0x00045fd4  stp      x20, x19, [sp, #-0x20]!
0x00045fd8  stp      x29, x30, [sp, #0x10]
0x00045fdc  add      x29, sp, #0x10
0x00045fe0  mov      x19, x2
0x00045fe4  mov      x20, x0
0x00045fe8  mov      x0, x2
0x00045fec  bl       #0x55d84   ; CALL _objc_retain
0x00045ff0  ldr      x0, [x20, #0x10]
0x00045ff4  str      x19, [x20, #0x10]
0x00045ff8  ldp      x29, x30, [sp, #0x10]
0x00045ffc  ldp      x20, x19, [sp], #0x20
0x00046000  b        #0x55d78   ; CALL _objc_release

=== -[SSGauge fill]  va=0x46004 size=8 types=@16@0:8
0x00046004  ldr      x0, [x0, #0x18]
0x00046008  ret      

=== -[SSGauge setFill:]  va=0x4600c size=48 types=v24@0:8@16
0x0004600c  stp      x20, x19, [sp, #-0x20]!
0x00046010  stp      x29, x30, [sp, #0x10]
0x00046014  add      x29, sp, #0x10
0x00046018  mov      x19, x2
0x0004601c  mov      x20, x0
0x00046020  mov      x0, x2
0x00046024  bl       #0x55d84   ; CALL _objc_retain
0x00046028  ldr      x0, [x20, #0x18]
0x0004602c  str      x19, [x20, #0x18]
0x00046030  ldp      x29, x30, [sp, #0x10]
0x00046034  ldp      x20, x19, [sp], #0x20
0x00046038  b        #0x55d78   ; CALL _objc_release

=== -[SSGauge needle]  va=0x4603c size=8 types=@16@0:8
0x0004603c  ldr      x0, [x0, #0x20]
0x00046040  ret      

=== -[SSGauge setNeedle:]  va=0x46044 size=48 types=v24@0:8@16
0x00046044  stp      x20, x19, [sp, #-0x20]!
0x00046048  stp      x29, x30, [sp, #0x10]
0x0004604c  add      x29, sp, #0x10
0x00046050  mov      x19, x2
0x00046054  mov      x20, x0
0x00046058  mov      x0, x2
0x0004605c  bl       #0x55d84   ; CALL _objc_retain
0x00046060  ldr      x0, [x20, #0x20]
0x00046064  str      x19, [x20, #0x20]
0x00046068  ldp      x29, x30, [sp, #0x10]
0x0004606c  ldp      x20, x19, [sp], #0x20
0x00046070  b        #0x55d78   ; CALL _objc_release

=== -[SSGauge number]  va=0x46074 size=8 types=@16@0:8
0x00046074  ldr      x0, [x0, #0x28]
0x00046078  ret      

=== -[SSGauge setNumber:]  va=0x4607c size=48 types=v24@0:8@16
0x0004607c  stp      x20, x19, [sp, #-0x20]!
0x00046080  stp      x29, x30, [sp, #0x10]
0x00046084  add      x29, sp, #0x10
0x00046088  mov      x19, x2
0x0004608c  mov      x20, x0
0x00046090  mov      x0, x2
0x00046094  bl       #0x55d84   ; CALL _objc_retain
0x00046098  ldr      x0, [x20, #0x28]
0x0004609c  str      x19, [x20, #0x28]
0x000460a0  ldp      x29, x30, [sp, #0x10]
0x000460a4  ldp      x20, x19, [sp], #0x20
0x000460a8  b        #0x55d78   ; CALL _objc_release

=== -[SSGauge max]  va=0x460ac size=8 types=d16@0:8
0x000460ac  ldr      d0, [x0, #0x30]
0x000460b0  ret      

=== -[SSGauge setMax:]  va=0x460b4 size=8 types=v24@0:8d16
0x000460b4  str      d0, [x0, #0x30]
0x000460b8  ret      

=== -[SSGauge red]  va=0x460bc size=8 types=d16@0:8
0x000460bc  ldr      d0, [x0, #0x38]
0x000460c0  ret      

=== -[SSGauge setRed:]  va=0x460c4 size=8 types=v24@0:8d16
0x000460c4  str      d0, [x0, #0x38]
0x000460c8  ret      

=== -[SSGauge shown]  va=0x460cc size=8 types=q16@0:8
0x000460cc  ldr      x0, [x0, #0x40]
0x000460d0  ret      

=== -[SSGauge setShown:]  va=0x460d4 size=8 types=v24@0:8q16
0x000460d4  str      x2, [x0, #0x40]
0x000460d8  ret      

=== -[SSGauge hot]  va=0x460dc size=8 types=B16@0:8
0x000460dc  ldrb     w0, [x0, #8]
0x000460e0  ret      

=== -[SSGauge setHot:]  va=0x460e4 size=8 types=v20@0:8B16
0x000460e4  strb     w2, [x0, #8]
0x000460e8  ret      

=== -[SSGauge .cxx_destruct]  va=0x460ec size=72 types=v16@0:8
0x000460ec  stp      x20, x19, [sp, #-0x20]!
0x000460f0  stp      x29, x30, [sp, #0x10]
0x000460f4  add      x29, sp, #0x10
0x000460f8  mov      x19, x0
0x000460fc  add      x0, x0, #0x28
0x00046100  mov      x1, #0
0x00046104  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00046108  add      x0, x19, #0x20
0x0004610c  mov      x1, #0
0x00046110  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00046114  add      x0, x19, #0x18
0x00046118  mov      x1, #0
0x0004611c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00046120  add      x0, x19, #0x10
0x00046124  mov      x1, #0
0x00046128  ldp      x29, x30, [sp, #0x10]
0x0004612c  ldp      x20, x19, [sp], #0x20
0x00046130  b        #0x55dcc   ; CALL _objc_storeStrong
