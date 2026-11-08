; ==== sub_19ca0 @ 0x19ca0..0x1a0ec (1100 bytes) ====
0x00019ca0  mov      x0, x22
0x00019ca4  bl       #0x2480c   ; call _objc_release
0x00019ca8  cmp      x22, x23
0x00019cac  b.eq     #0x19cd4
0x00019cb0  mov      x0, x20
0x00019cb4  bl       #0x26560   ; objc_msgSend: panel
0x00019cb8  mov      x29, x29
0x00019cbc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019cc0  mov      x22, x0
0x00019cc4  mov      x2, x21
0x00019cc8  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x00019ccc  mov      x0, x22
0x00019cd0  bl       #0x2480c   ; call _objc_release
0x00019cd4  mov      x0, x20
0x00019cd8  bl       #0x26560   ; objc_msgSend: panel
0x00019cdc  mov      x29, x29
0x00019ce0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019ce4  mov      x22, x0
0x00019ce8  mov      x0, x19
0x00019cec  bl       #0x24f40   ; objc_msgSend: bounds
0x00019cf0  mov      x0, x22
0x00019cf4  mov      x2, x19
0x00019cf8  bl       #0x253c0   ; objc_msgSend: convertRect:fromView:
0x00019cfc  mov      v8.16b, v0.16b
0x00019d00  mov      v9.16b, v1.16b
0x00019d04  mov      v12.16b, v2.16b
0x00019d08  mov      v13.16b, v3.16b
0x00019d0c  mov      x0, x22
0x00019d10  bl       #0x2480c   ; call _objc_release
0x00019d14  mov      v0.16b, v8.16b
0x00019d18  mov      v1.16b, v9.16b
0x00019d1c  mov      v2.16b, v12.16b
0x00019d20  mov      v3.16b, v13.16b
0x00019d24  bl       #0x24380   ; call _CGRectGetMidX
0x00019d28  mov      v10.16b, v0.16b
0x00019d2c  mov      x0, x19
0x00019d30  bl       #0x24f40   ; objc_msgSend: bounds
0x00019d34  mov      v11.16b, v2.16b
0x00019d38  mov      v0.16b, v8.16b
0x00019d3c  mov      v1.16b, v9.16b
0x00019d40  mov      v2.16b, v12.16b
0x00019d44  mov      v3.16b, v13.16b
0x00019d48  bl       #0x2438c   ; call _CGRectGetMidY
0x00019d4c  mov      v12.16b, v0.16b
0x00019d50  mov      x0, x19
0x00019d54  bl       #0x24f40   ; objc_msgSend: bounds
0x00019d58  mov      v13.16b, v3.16b
0x00019d5c  mov      x0, x19
0x00019d60  bl       #0x24f40   ; objc_msgSend: bounds
0x00019d64  mov      v9.16b, v2.16b
0x00019d68  mov      x0, x19
0x00019d6c  bl       #0x24f40   ; objc_msgSend: bounds
0x00019d70  mov      v8.16b, v3.16b
0x00019d74  fmov     d0, #-0.50000000
0x00019d78  fmul     d0, d11, d0
0x00019d7c  fadd     d11, d10, d0
0x00019d80  fmov     d0, #-0.50000000
0x00019d84  fmul     d0, d13, d0
0x00019d88  fadd     d12, d12, d0
0x00019d8c  mov      v0.16b, v11.16b
0x00019d90  mov      v1.16b, v12.16b
0x00019d94  mov      v2.16b, v9.16b
0x00019d98  bl       #0x24380   ; call _CGRectGetMidX
0x00019d9c  adrp     x8, #0x2b000
0x00019da0  ldr      d1, [x8, #0x3b8]
0x00019da4  fmul     d1, d9, d1
0x00019da8  frinta   d10, d1
0x00019dac  fmov     d1, #-0.50000000
0x00019db0  fmul     d1, d10, d1
0x00019db4  fadd     d0, d0, d1
0x00019db8  fmov     d1, #2.00000000
0x00019dbc  fcmp     d0, d1
0x00019dc0  fcsel    d13, d1, d0, mi
0x00019dc4  mov      x0, x20
0x00019dc8  bl       #0x26560   ; objc_msgSend: panel
0x00019dcc  mov      x29, x29
0x00019dd0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019dd4  mov      x22, x0
0x00019dd8  bl       #0x24f40   ; objc_msgSend: bounds
0x00019ddc  fsub     d0, d2, d10
0x00019de0  fmov     d1, #-2.00000000
0x00019de4  fadd     d14, d0, d1
0x00019de8  mov      x0, x22
0x00019dec  bl       #0x2480c   ; call _objc_release
0x00019df0  fcmp     d13, d14
0x00019df4  fcsel    d13, d13, d14, mi
0x00019df8  adrp     x8, #0x34000
0x00019dfc  ldr      x8, [x8, #0x4b0]   ; -> [got:_CGAffineTransformIdentity]
0x00019e00  ldp      q0, q1, [x8]
0x00019e04  stp      q0, q1, [sp, #0x60]
0x00019e08  ldr      q0, [x8, #0x20]   ; -> [got:_class_getClassMethod]
0x00019e0c  str      q0, [sp, #0x80]
0x00019e10  add      x2, sp, #0x60
0x00019e14  mov      x0, x21
0x00019e18  bl       #0x279a0   ; objc_msgSend: setTransform:
0x00019e1c  mov      x0, x21
0x00019e20  bl       #0x25f00   ; objc_msgSend: layer
0x00019e24  mov      x29, x29
0x00019e28  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019e2c  mov      x22, x0
0x00019e30  fmov     d0, #0.50000000
0x00019e34  fmov     d1, #1.00000000
0x00019e38  bl       #0x26b60   ; objc_msgSend: setAnchorPoint:
0x00019e3c  mov      x0, x22
0x00019e40  bl       #0x2480c   ; call _objc_release
0x00019e44  mov      v0.16b, v11.16b
0x00019e48  mov      v1.16b, v12.16b
0x00019e4c  mov      v2.16b, v9.16b
0x00019e50  mov      v3.16b, v8.16b
0x00019e54  bl       #0x243a4   ; call _CGRectGetMinY
0x00019e58  adrp     x8, #0x2b000
0x00019e5c  ldr      d1, [x8, #0x3c0]
0x00019e60  fmul     d1, d8, d1
0x00019e64  frinta   d3, d1
0x00019e68  fsub     d0, d0, d3
0x00019e6c  fmov     d1, #2.00000000
0x00019e70  fadd     d1, d0, d1
0x00019e74  mov      x0, x21
0x00019e78  mov      v0.16b, v13.16b
0x00019e7c  mov      v2.16b, v10.16b
0x00019e80  bl       #0x26f80   ; objc_msgSend: setFrame:
0x00019e84  adrp     x8, #0x3e000
0x00019e88  ldr      x22, [x8, #0x300]   ; -> [class(UIBezierPath)]
0x00019e8c  mov      x0, x21
0x00019e90  bl       #0x24f40   ; objc_msgSend: bounds
0x00019e94  fmov     d4, #9.00000000
0x00019e98  mov      x0, x22
0x00019e9c  bl       #0x24ee0   ; objc_msgSend: bezierPathWithRoundedRect:cornerRadius:
0x00019ea0  mov      x29, x29
0x00019ea4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019ea8  mov      x22, x0
0x00019eac  bl       #0x24824   ; call _objc_retainAutorelease
0x00019eb0  bl       #0x24a20   ; objc_msgSend: CGPath
0x00019eb4  mov      x24, x0
0x00019eb8  mov      x0, x21
0x00019ebc  bl       #0x25f00   ; objc_msgSend: layer
0x00019ec0  mov      x29, x29
0x00019ec4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019ec8  mov      x23, x0
0x00019ecc  mov      x2, x24
0x00019ed0  bl       #0x27740   ; objc_msgSend: setShadowPath:
0x00019ed4  mov      x0, x23
0x00019ed8  bl       #0x2480c   ; call _objc_release
0x00019edc  mov      x0, x22
0x00019ee0  bl       #0x2480c   ; call _objc_release
0x00019ee4  adrp     x8, #0x3e000
0x00019ee8  ldr      x0, [x8, #0x3e0]   ; -> [class(UIFont)]
0x00019eec  adrp     x8, #0x2b000
0x00019ef0  ldr      d0, [x8, #0x258]
0x00019ef4  fmul     d0, d8, d0
0x00019ef8  frinta   d0, d0
0x00019efc  bl       #0x27e60   ; objc_msgSend: systemFontOfSize:
0x00019f00  mov      x29, x29
0x00019f04  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019f08  mov      x22, x0
0x00019f0c  mov      x0, x21
0x00019f10  mov      x2, x22
0x00019f14  bl       #0x26f60   ; objc_msgSend: setFont:
0x00019f18  mov      x0, x22
0x00019f1c  bl       #0x2480c   ; call _objc_release
0x00019f20  mov      x0, x19
0x00019f24  mov      x2, #0
0x00019f28  bl       #0x27fa0   ; objc_msgSend: titleForState:
0x00019f2c  mov      x29, x29
0x00019f30  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019f34  mov      x22, x0
0x00019f38  mov      x0, x21
0x00019f3c  mov      x2, x22
0x00019f40  bl       #0x278c0   ; objc_msgSend: setText:
0x00019f44  mov      x0, x22
0x00019f48  bl       #0x2480c   ; call _objc_release
0x00019f4c  mov      x0, x20
0x00019f50  bl       #0x26560   ; objc_msgSend: panel
0x00019f54  mov      x29, x29
0x00019f58  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019f5c  mov      x22, x0
0x00019f60  mov      x2, x21
0x00019f64  bl       #0x24f80   ; objc_msgSend: bringSubviewToFront:
0x00019f68  mov      x0, x22
0x00019f6c  bl       #0x2480c   ; call _objc_release
0x00019f70  fmov     d0, #1.00000000
0x00019f74  mov      x0, x21
0x00019f78  bl       #0x26b40   ; objc_msgSend: setAlpha:
0x00019f7c  adrp     x8, #0x2b000
0x00019f80  ldr      d0, [x8, #0x200]
0x00019f84  add      x8, sp, #0x30
0x00019f88  mov      v1.16b, v0.16b
0x00019f8c  bl       #0x242e4   ; call _CGAffineTransformMakeScale
0x00019f90  ldp      q0, q1, [sp, #0x30]
0x00019f94  stp      q0, q1, [sp, #0x60]
0x00019f98  ldr      q0, [sp, #0x50]
0x00019f9c  str      q0, [sp, #0x80]
0x00019fa0  add      x2, sp, #0x60
0x00019fa4  mov      x0, x21
0x00019fa8  bl       #0x279a0   ; objc_msgSend: setTransform:
0x00019fac  adrp     x8, #0x3e000
0x00019fb0  ldr      x20, [x8, #0x2d0]   ; -> [class(UIView)]
0x00019fb4  adrp     x8, #0x34000
0x00019fb8  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x00019fbc  str      x8, [sp, #8]
0x00019fc0  adrp     x8, #0x2b000
0x00019fc4  ldr      d0, [x8, #0x1d0]
0x00019fc8  str      d0, [sp, #0x10]
0x00019fcc  adrp     x8, #0x1a000
0x00019fd0  add      x8, x8, #0x1c4
0x00019fd4  adrp     x9, #0x34000
0x00019fd8  add      x9, x9, #0x890
0x00019fdc  stp      x8, x9, [sp, #0x18]
0x00019fe0  mov      x0, x21
0x00019fe4  bl       #0x24818   ; call _objc_retain
0x00019fe8  str      x21, [sp, #0x28]
0x00019fec  adrp     x8, #0x2b000
0x00019ff0  ldr      d0, [x8, #0x2b8]
0x00019ff4  adrp     x8, #0x2b000
0x00019ff8  ldr      d2, [x8, #0x3c8]
0x00019ffc  fmov     d1, xzr
0x0001a000  fmov     d3, #0.50000000
0x0001a004  add      x3, sp, #8
0x0001a008  mov      x0, x20
0x0001a00c  mov      w2, #4
0x0001a010  mov      x4, #0
0x0001a014  bl       #0x24ca0   ; objc_msgSend: animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
0x0001a018  ldr      x0, [sp, #0x28]
0x0001a01c  bl       #0x2480c   ; call _objc_release
0x0001a020  mov      x0, x21
0x0001a024  bl       #0x2480c   ; call _objc_release
0x0001a028  b        #0x1a074   ; call sub_1a074
0x0001a02c  adrp     x8, #0x3e000
0x0001a030  adrp     x9, #0x34000
0x0001a034  ldr      x9, [x9, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x0001a038  ldr      x0, [x8, #0x2d0]   ; -> [class(UIView)]
0x0001a03c  str      x9, [sp, #0x98]
0x0001a040  adrp     x8, #0x2b000
0x0001a044  ldr      d0, [x8, #0x1d0]
0x0001a048  adrp     x8, #0x1a000
0x0001a04c  add      x8, x8, #0x178
0x0001a050  str      d0, [sp, #0xa0]
0x0001a054  adrp     x9, #0x34000
0x0001a058  add      x9, x9, #0x890
0x0001a05c  stp      x8, x9, [sp, #0xa8]
0x0001a060  str      x20, [sp, #0xb8]
0x0001a064  adrp     x8, #0x2b000
0x0001a068  ldr      d0, [x8, #0x1f8]
0x0001a06c  add      x2, sp, #0x98
0x0001a070  bl       #0x24c40   ; objc_msgSend: animateWithDuration:animations:
0x0001a074  mov      x0, x19
0x0001a078  bl       #0x2480c   ; call _objc_release
0x0001a07c  ldp      x29, x30, [sp, #0x140]
0x0001a080  ldp      x20, x19, [sp, #0x130]
0x0001a084  ldp      x22, x21, [sp, #0x120]
0x0001a088  ldp      x24, x23, [sp, #0x110]
0x0001a08c  ldp      x28, x27, [sp, #0x100]
0x0001a090  ldp      d9, d8, [sp, #0xf0]
0x0001a094  ldp      d11, d10, [sp, #0xe0]
0x0001a098  ldp      d13, d12, [sp, #0xd0]
0x0001a09c  ldp      d15, d14, [sp, #0xc0]
0x0001a0a0  add      sp, sp, #0x150
0x0001a0a4  ret      
0x0001a0a8  b        #0x1a13c   ; call sub_1a13c
0x0001a0ac  b        #0x1a13c   ; call sub_1a13c
0x0001a0b0  b        #0x1a13c   ; call sub_1a13c
0x0001a0b4  b        #0x1a0f0   ; call sub_1a0f0
0x0001a0b8  b        #0x1a13c   ; call sub_1a13c
0x0001a0bc  b        #0x1a13c   ; call sub_1a13c
0x0001a0c0  b        #0x1a13c   ; call sub_1a13c
0x0001a0c4  b        #0x1a13c   ; call sub_1a13c
0x0001a0c8  b        #0x1a13c   ; call sub_1a13c
0x0001a0cc  b        #0x1a150   ; call sub_1a150
0x0001a0d0  b        #0x1a13c   ; call sub_1a13c
0x0001a0d4  b        #0x1a13c   ; call sub_1a13c
0x0001a0d8  mov      x20, x0
0x0001a0dc  ldr      x0, [sp, #0x28]
0x0001a0e0  b        #0x1a144   ; call sub_1a144
0x0001a0e4  b        #0x1a13c   ; call sub_1a13c
0x0001a0e8  b        #0x1a13c   ; call sub_1a13c
