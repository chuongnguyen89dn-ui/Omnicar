; ==== sub_ec84 @ 0xec84..0xee20 (412 bytes) ====
0x0000ec84  stp      d13, d12, [sp, #0xd0]
0x0000ec88  stp      d11, d10, [sp, #0xe0]
0x0000ec8c  stp      d9, d8, [sp, #0xf0]
0x0000ec90  stp      x28, x27, [sp, #0x100]
0x0000ec94  stp      x26, x25, [sp, #0x110]
0x0000ec98  stp      x24, x23, [sp, #0x120]
0x0000ec9c  stp      x22, x21, [sp, #0x130]
0x0000eca0  stp      x20, x19, [sp, #0x140]
0x0000eca4  stp      x29, x30, [sp, #0x150]
0x0000eca8  add      x29, sp, #0x150
0x0000ecac  mov      x19, x2
0x0000ecb0  mov      x24, x0
0x0000ecb4  mov      x0, x2
0x0000ecb8  bl       #0x24818   ; call _objc_retain
0x0000ecbc  mov      x0, x19
0x0000ecc0  bl       #0x24d00   ; objc_msgSend: appViewController
0x0000ecc4  mov      x29, x29
0x0000ecc8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000eccc  mov      x20, x0
0x0000ecd0  bl       #0x2480c   ; call _objc_release
0x0000ecd4  cbz      x20, #0xf0a0
0x0000ecd8  mov      x0, x19
0x0000ecdc  bl       #0x24f60   ; objc_msgSend: box
0x0000ece0  mov      x29, x29
0x0000ece4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ece8  mov      x20, x0
0x0000ecec  bl       #0x24f40   ; objc_msgSend: bounds
0x0000ecf0  mov      v8.16b, v2.16b
0x0000ecf4  mov      v9.16b, v3.16b
0x0000ecf8  mov      x0, x20
0x0000ecfc  bl       #0x2480c   ; call _objc_release
0x0000ed00  fmov     d0, #2.00000000
0x0000ed04  fcmp     d8, d0
0x0000ed08  b.mi     #0xf0a0
0x0000ed0c  fcmp     d9, d0
0x0000ed10  b.mi     #0xf0a0
0x0000ed14  mov      x0, x24
0x0000ed18  bl       #0x28260   ; objc_msgSend: zoom
0x0000ed1c  mov      v12.16b, v0.16b
0x0000ed20  mov      x0, x19
0x0000ed24  bl       #0x24d00   ; objc_msgSend: appViewController
0x0000ed28  mov      x29, x29
0x0000ed2c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ed30  mov      x21, x0
0x0000ed34  bl       #0x28140   ; objc_msgSend: view
0x0000ed38  mov      x29, x29
0x0000ed3c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ed40  mov      x20, x0
0x0000ed44  add      x25, sp, #0x90
0x0000ed48  mov      x0, x21
0x0000ed4c  bl       #0x2480c   ; call _objc_release
0x0000ed50  adrp     x27, #0x34000
0x0000ed54  ldr      x27, [x27, #0x4b0]   ; -> [got:_CGAffineTransformIdentity]
0x0000ed58  ldp      q0, q1, [x27]
0x0000ed5c  str      q0, [sp, #0x90]
0x0000ed60  ldr      q0, [x27, #0x20]   ; -> [got:_class_getClassMethod]
0x0000ed64  stp      q1, q0, [x25, #0x10]
0x0000ed68  add      x2, sp, #0x90
0x0000ed6c  mov      x0, x20
0x0000ed70  bl       #0x279a0   ; objc_msgSend: setTransform:
0x0000ed74  fdiv     d0, d8, d12
0x0000ed78  frinta   d10, d0
0x0000ed7c  fdiv     d0, d9, d12
0x0000ed80  frinta   d11, d0
0x0000ed84  fmov     d13, xzr
0x0000ed88  fmov     d0, xzr
0x0000ed8c  fmov     d1, xzr
0x0000ed90  mov      x0, x20
0x0000ed94  mov      v2.16b, v10.16b
0x0000ed98  mov      v3.16b, v11.16b
0x0000ed9c  bl       #0x26f80   ; objc_msgSend: setFrame:
0x0000eda0  add      x8, sp, #0x60
0x0000eda4  mov      v0.16b, v12.16b
0x0000eda8  mov      v1.16b, v12.16b
0x0000edac  bl       #0x242e4   ; call _CGAffineTransformMakeScale
0x0000edb0  ldp      q0, q1, [sp, #0x60]
0x0000edb4  str      q0, [sp, #0x90]
0x0000edb8  ldr      q0, [sp, #0x80]
0x0000edbc  stp      q1, q0, [x25, #0x10]
0x0000edc0  add      x2, sp, #0x90
0x0000edc4  mov      x0, x20
0x0000edc8  bl       #0x279a0   ; objc_msgSend: setTransform:
0x0000edcc  fmov     d1, #0.50000000
0x0000edd0  fmul     d0, d8, d1
0x0000edd4  fmul     d1, d9, d1
0x0000edd8  mov      x0, x20
0x0000eddc  bl       #0x26d60   ; objc_msgSend: setCenter:
0x0000ede0  mov      x28, #0
0x0000ede4  mov      x21, #0
0x0000ede8  mov      x0, x19
0x0000edec  bl       #0x24d00   ; objc_msgSend: appViewController
0x0000edf0  mov      x29, x29
0x0000edf4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000edf8  mov      x22, x0
0x0000edfc  adrp     x2, #0x36000
0x0000ee00  add      x2, x2, #0xd0   ; -> @"_deviceAppViewController"
0x0000ee04  bl       #0x28100   ; objc_msgSend: valueForKey:
0x0000ee08  mov      x29, x29
0x0000ee0c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ee10  mov      x21, x0
0x0000ee14  mov      x0, x22
0x0000ee18  bl       #0x2480c   ; call _objc_release
0x0000ee1c  cbz      x21, #0xee68
