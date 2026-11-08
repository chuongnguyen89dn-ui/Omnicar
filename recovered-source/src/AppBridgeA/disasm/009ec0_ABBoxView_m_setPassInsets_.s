; ==== ABBoxView_m_setPassInsets_ @ 0x9ec0..0x9ff0 (304 bytes) ====
0x00009ec0  adrp     x8, #0x3e000
0x00009ec4  ldrsw    x8, [x8, #0x47c]
0x00009ec8  add      x8, x0, x8
0x00009ecc  stp      d0, d1, [x8]
0x00009ed0  stp      d2, d3, [x8, #0x10]
0x00009ed4  ret      
0x00009ed8  stp      x29, x30, [sp, #-0x10]!
0x00009edc  mov      x29, sp
0x00009ee0  adrp     x8, #0x3e000
0x00009ee4  ldrsw    x8, [x8, #0x480]
0x00009ee8  add      x0, x0, x8
0x00009eec  bl       #0x247a0   ; call _objc_loadWeakRetained
0x00009ef0  ldp      x29, x30, [sp], #0x10
0x00009ef4  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x00009ef8  mov      x1, x2
0x00009efc  adrp     x8, #0x3e000
0x00009f00  ldrsw    x8, [x8, #0x480]
0x00009f04  add      x0, x0, x8
0x00009f08  b        #0x2486c   ; call _objc_storeWeak
0x00009f0c  stp      x29, x30, [sp, #-0x10]!
0x00009f10  mov      x29, sp
0x00009f14  adrp     x8, #0x3e000
0x00009f18  ldrsw    x8, [x8, #0x484]
0x00009f1c  add      x0, x0, x8
0x00009f20  bl       #0x247a0   ; call _objc_loadWeakRetained
0x00009f24  ldp      x29, x30, [sp], #0x10
0x00009f28  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x00009f2c  mov      x1, x2
0x00009f30  adrp     x8, #0x3e000
0x00009f34  ldrsw    x8, [x8, #0x484]
0x00009f38  add      x0, x0, x8
0x00009f3c  b        #0x2486c   ; call _objc_storeWeak
0x00009f40  adrp     x8, #0x3e000
0x00009f44  ldrsw    x8, [x8, #0x478]
0x00009f48  add      x8, x0, x8
0x00009f4c  ldp      d0, d1, [x8]
0x00009f50  ldp      d2, d3, [x8, #0x10]
0x00009f54  ret      
0x00009f58  stp      x20, x19, [sp, #-0x20]!
0x00009f5c  stp      x29, x30, [sp, #0x10]
0x00009f60  add      x29, sp, #0x10
0x00009f64  mov      x19, x0
0x00009f68  adrp     x8, #0x3e000
0x00009f6c  ldrsw    x8, [x8, #0x484]
0x00009f70  add      x0, x0, x8
0x00009f74  bl       #0x24758   ; call _objc_destroyWeak
0x00009f78  adrp     x8, #0x3e000
0x00009f7c  ldrsw    x8, [x8, #0x480]
0x00009f80  add      x0, x19, x8
0x00009f84  ldp      x29, x30, [sp, #0x10]
0x00009f88  ldp      x20, x19, [sp], #0x20
0x00009f8c  b        #0x24758   ; call _objc_destroyWeak
0x00009f90  stp      d15, d14, [sp, #-0x60]!
0x00009f94  stp      d13, d12, [sp, #0x10]
0x00009f98  stp      d11, d10, [sp, #0x20]
0x00009f9c  stp      d9, d8, [sp, #0x30]
0x00009fa0  stp      x20, x19, [sp, #0x40]
0x00009fa4  stp      x29, x30, [sp, #0x50]
0x00009fa8  add      x29, sp, #0x50
0x00009fac  mov      v8.16b, v1.16b
0x00009fb0  mov      v9.16b, v0.16b
0x00009fb4  mov      x19, x0
0x00009fb8  bl       #0x24f40   ; objc_msgSend: bounds
0x00009fbc  mov      x8, #-0x3fba000000000000
0x00009fc0  fmov     d12, x8
0x00009fc4  fadd     d0, d2, d12
0x00009fc8  fmov     d13, #0.50000000
0x00009fcc  fmul     d0, d0, d13
0x00009fd0  fcmp     d0, #0.0
0x00009fd4  fmov     d14, xzr
0x00009fd8  fcsel    d10, d14, d0, gt
0x00009fdc  mov      x0, x19
0x00009fe0  bl       #0x24f40   ; objc_msgSend: bounds
0x00009fe4  mov      v11.16b, v3.16b
0x00009fe8  mov      x0, x19
0x00009fec  bl       #0x24f40   ; objc_msgSend: bounds
