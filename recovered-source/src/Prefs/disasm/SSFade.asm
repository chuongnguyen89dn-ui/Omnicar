=== -[SSFade applyTime:]  va=0x45d6c size=428 types=v24@0:8d16
0x00045d6c  sub      sp, sp, #0xb0
0x00045d70  stp      d13, d12, [sp, #0x60]
0x00045d74  stp      d11, d10, [sp, #0x70]
0x00045d78  stp      d9, d8, [sp, #0x80]
0x00045d7c  stp      x20, x19, [sp, #0x90]
0x00045d80  stp      x29, x30, [sp, #0xa0]
0x00045d84  add      x29, sp, #0xa0
0x00045d88  mov      v8.16b, v0.16b
0x00045d8c  mov      x19, x0
0x00045d90  bl       #0x58280   ; CALL objc_msgSend$inA
0x00045d94  mov      v9.16b, v0.16b
0x00045d98  mov      x0, x19
0x00045d9c  bl       #0x582a0   ; CALL objc_msgSend$inB
0x00045da0  fsub     d1, d8, d9
0x00045da4  fsub     d0, d0, d9
0x00045da8  fdiv     d0, d1, d0
0x00045dac  fmov     d10, #1.00000000
0x00045db0  fcmp     d0, d10
0x00045db4  fcsel    d1, d10, d0, gt
0x00045db8  fcmp     d0, #0.0
0x00045dbc  fmov     d12, xzr
0x00045dc0  fcsel    d11, d12, d1, mi
0x00045dc4  mov      x0, x19
0x00045dc8  bl       #0x562e0   ; CALL objc_msgSend$alpha
0x00045dcc  mov      v9.16b, v0.16b
0x00045dd0  mov      x0, x19
0x00045dd4  bl       #0x59500   ; CALL objc_msgSend$outEase
0x00045dd8  mov      v0.16b, v11.16b
0x00045ddc  cbz      w0, #0x45df8
0x00045de0  fsub     d0, d10, d11
0x00045de4  fmov     d1, #3.00000000
0x00045de8  bl       #0x55e14   ; CALL _pow
0x00045dec  fsub     d0, d10, d0
0x00045df0  fcmp     d11, #0.0
0x00045df4  fcsel    d0, d12, d0, mi
0x00045df8  fmul     d9, d9, d0
0x00045dfc  mov      x0, x19
0x00045e00  bl       #0x594e0   ; CALL objc_msgSend$outB
0x00045e04  mov      v10.16b, v0.16b
0x00045e08  mov      x0, x19
0x00045e0c  bl       #0x594c0   ; CALL objc_msgSend$outA
0x00045e10  fcmp     d10, d0
0x00045e14  b.le     #0x45e54
0x00045e18  mov      x0, x19
0x00045e1c  bl       #0x594c0   ; CALL objc_msgSend$outA
0x00045e20  mov      v10.16b, v0.16b
0x00045e24  mov      x0, x19
0x00045e28  bl       #0x594e0   ; CALL objc_msgSend$outB
0x00045e2c  fsub     d1, d8, d10
0x00045e30  fsub     d0, d0, d10
0x00045e34  fdiv     d0, d1, d0
0x00045e38  fmov     d1, #1.00000000
0x00045e3c  fcmp     d0, d1
0x00045e40  fcsel    d2, d1, d0, gt
0x00045e44  fsub     d2, d1, d2
0x00045e48  fcmp     d0, #0.0
0x00045e4c  fcsel    d0, d1, d2, mi
0x00045e50  fmul     d9, d9, d0
0x00045e54  mov      x0, x19
0x00045e58  bl       #0x5df60   ; CALL objc_msgSend$view
0x00045e5c  mov      x29, x29
0x00045e60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045e64  mov      x20, x0
0x00045e68  mov      v0.16b, v9.16b
0x00045e6c  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x00045e70  mov      x0, x20
0x00045e74  bl       #0x55d78   ; CALL _objc_release
0x00045e78  mov      x0, x19
0x00045e7c  bl       #0x59f40   ; CALL objc_msgSend$rise
0x00045e80  fcmp     d0, #0.0
0x00045e84  b.eq     #0x45efc
0x00045e88  mov      x0, x19
0x00045e8c  bl       #0x59f40   ; CALL objc_msgSend$rise
0x00045e90  mov      v8.16b, v0.16b
0x00045e94  fmov     d9, #1.00000000
0x00045e98  fsub     d0, d9, d11
0x00045e9c  fmov     d1, #3.00000000
0x00045ea0  bl       #0x55e14   ; CALL _pow
0x00045ea4  fmov     d1, #-1.00000000
0x00045ea8  fadd     d0, d0, d1
0x00045eac  fadd     d0, d0, d9
0x00045eb0  fcmp     d11, #0.0
0x00045eb4  fcsel    d0, d9, d0, mi
0x00045eb8  fmul     d1, d0, d8
0x00045ebc  add      x8, sp, #0x30
0x00045ec0  fmov     d0, xzr
0x00045ec4  bl       #0x55898   ; CALL _CGAffineTransformMakeTranslation
0x00045ec8  mov      x0, x19
0x00045ecc  bl       #0x5df60   ; CALL objc_msgSend$view
0x00045ed0  mov      x29, x29
0x00045ed4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045ed8  mov      x19, x0
0x00045edc  ldp      q0, q1, [sp, #0x30]
0x00045ee0  stp      q0, q1, [sp]
0x00045ee4  ldr      q0, [sp, #0x50]
0x00045ee8  str      q0, [sp, #0x20]
0x00045eec  mov      x2, sp
0x00045ef0  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x00045ef4  mov      x0, x19
0x00045ef8  bl       #0x55d78   ; CALL _objc_release
0x00045efc  ldp      x29, x30, [sp, #0xa0]
0x00045f00  ldp      x20, x19, [sp, #0x90]
0x00045f04  ldp      d9, d8, [sp, #0x80]
0x00045f08  ldp      d11, d10, [sp, #0x70]
0x00045f0c  ldp      d13, d12, [sp, #0x60]
0x00045f10  add      sp, sp, #0xb0
0x00045f14  ret      

=== -[SSFade view]  va=0x45f18 size=8 types=@16@0:8
0x00045f18  ldr      x0, [x0, #0x10]
0x00045f1c  ret      

=== -[SSFade setView:]  va=0x45f20 size=48 types=v24@0:8@16
0x00045f20  stp      x20, x19, [sp, #-0x20]!
0x00045f24  stp      x29, x30, [sp, #0x10]
0x00045f28  add      x29, sp, #0x10
0x00045f2c  mov      x19, x2
0x00045f30  mov      x20, x0
0x00045f34  mov      x0, x2
0x00045f38  bl       #0x55d84   ; CALL _objc_retain
0x00045f3c  ldr      x0, [x20, #0x10]
0x00045f40  str      x19, [x20, #0x10]
0x00045f44  ldp      x29, x30, [sp, #0x10]
0x00045f48  ldp      x20, x19, [sp], #0x20
0x00045f4c  b        #0x55d78   ; CALL _objc_release

=== -[SSFade inA]  va=0x45f50 size=8 types=d16@0:8
0x00045f50  ldr      d0, [x0, #0x18]
0x00045f54  ret      

=== -[SSFade setInA:]  va=0x45f58 size=8 types=v24@0:8d16
0x00045f58  str      d0, [x0, #0x18]
0x00045f5c  ret      

=== -[SSFade inB]  va=0x45f60 size=8 types=d16@0:8
0x00045f60  ldr      d0, [x0, #0x20]
0x00045f64  ret      

=== -[SSFade setInB:]  va=0x45f68 size=8 types=v24@0:8d16
0x00045f68  str      d0, [x0, #0x20]
0x00045f6c  ret      

=== -[SSFade outA]  va=0x45f70 size=8 types=d16@0:8
0x00045f70  ldr      d0, [x0, #0x28]
0x00045f74  ret      

=== -[SSFade setOutA:]  va=0x45f78 size=8 types=v24@0:8d16
0x00045f78  str      d0, [x0, #0x28]
0x00045f7c  ret      

=== -[SSFade outB]  va=0x45f80 size=8 types=d16@0:8
0x00045f80  ldr      d0, [x0, #0x30]
0x00045f84  ret      

=== -[SSFade setOutB:]  va=0x45f88 size=8 types=v24@0:8d16
0x00045f88  str      d0, [x0, #0x30]
0x00045f8c  ret      

=== -[SSFade alpha]  va=0x45f90 size=8 types=d16@0:8
0x00045f90  ldr      d0, [x0, #0x38]
0x00045f94  ret      

=== -[SSFade setAlpha:]  va=0x45f98 size=8 types=v24@0:8d16
0x00045f98  str      d0, [x0, #0x38]
0x00045f9c  ret      

=== -[SSFade rise]  va=0x45fa0 size=8 types=d16@0:8
0x00045fa0  ldr      d0, [x0, #0x40]
0x00045fa4  ret      

=== -[SSFade setRise:]  va=0x45fa8 size=8 types=v24@0:8d16
0x00045fa8  str      d0, [x0, #0x40]
0x00045fac  ret      

=== -[SSFade outEase]  va=0x45fb0 size=8 types=B16@0:8
0x00045fb0  ldrb     w0, [x0, #8]
0x00045fb4  ret      

=== -[SSFade setOutEase:]  va=0x45fb8 size=8 types=v20@0:8B16
0x00045fb8  strb     w2, [x0, #8]
0x00045fbc  ret      

=== -[SSFade .cxx_destruct]  va=0x45fc0 size=12 types=v16@0:8
0x00045fc0  add      x0, x0, #0x10
0x00045fc4  mov      x1, #0
0x00045fc8  b        #0x55dcc   ; CALL _objc_storeStrong
