; ==== sub_a12c @ 0xa12c..0xa1d0 (164 bytes) ====
0x0000a12c  add      x8, sp, #0x30
0x0000a130  mov      v1.16b, v0.16b
0x0000a134  bl       #0x242e4   ; call _CGAffineTransformMakeScale
0x0000a138  b        #0xa154   ; call sub_a154
0x0000a13c  adrp     x8, #0x34000
0x0000a140  ldr      x8, [x8, #0x4b0]   ; -> [got:_CGAffineTransformIdentity]
0x0000a144  ldp      q0, q1, [x8]
0x0000a148  stp      q0, q1, [sp, #0x30]
0x0000a14c  ldr      q0, [x8, #0x20]   ; -> [got:_class_getClassMethod]
0x0000a150  str      q0, [sp, #0x50]
0x0000a154  ldp      q0, q1, [sp, #0x30]
0x0000a158  stp      q0, q1, [sp]
0x0000a15c  ldr      q0, [sp, #0x50]
0x0000a160  str      q0, [sp, #0x20]
0x0000a164  ldr      x0, [x19, #0x20]
0x0000a168  mov      x2, sp
0x0000a16c  bl       #0x279a0   ; objc_msgSend: setTransform:
0x0000a170  ldp      x29, x30, [sp, #0x70]
0x0000a174  ldp      x20, x19, [sp, #0x60]
0x0000a178  add      sp, sp, #0x80
0x0000a17c  ret      
0x0000a180  ldr      x0, [x0, #0x10]
0x0000a184  ret      
0x0000a188  mov      w3, #0x10
0x0000a18c  b        #0x24854   ; call _objc_setProperty_nonatomic_copy
0x0000a190  ldr      x0, [x0, #0x18]
0x0000a194  ret      
0x0000a198  stp      x20, x19, [sp, #-0x20]!
0x0000a19c  stp      x29, x30, [sp, #0x10]
0x0000a1a0  add      x29, sp, #0x10
0x0000a1a4  mov      x19, x2
0x0000a1a8  mov      x20, x0
0x0000a1ac  mov      x0, x2
0x0000a1b0  bl       #0x24818   ; call _objc_retain
0x0000a1b4  ldr      x0, [x20, #0x18]
0x0000a1b8  str      x19, [x20, #0x18]
0x0000a1bc  ldp      x29, x30, [sp, #0x10]
0x0000a1c0  ldp      x20, x19, [sp], #0x20
0x0000a1c4  b        #0x2480c   ; call _objc_release
0x0000a1c8  ldr      x0, [x0, #0x20]
0x0000a1cc  ret      
