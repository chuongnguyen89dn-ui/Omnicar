; === sub_cbcc @ 0xcbcc size=268 ===
0x0000cbcc  sub      sp, sp, #0x70
0x0000cbd0  stp      d9, d8, [sp, #0x30]
0x0000cbd4  stp      x22, x21, [sp, #0x40]
0x0000cbd8  stp      x20, x19, [sp, #0x50]
0x0000cbdc  stp      x29, x30, [sp, #0x60]
0x0000cbe0  add      x29, sp, #0x60
0x0000cbe4  mov      x19, x0
0x0000cbe8  ldrb     w8, [x0, #0x24]
0x0000cbec  cmp      w8, #0
0x0000cbf0  adrp     x8, #0xf000
0x0000cbf4  ldr      d0, [x8, #0xb00] ; -> [__TEXT,__const+0x50 [u64=0x3fee666666666666 f64=0.95]]
0x0000cbf8  fmov     d1, #1.00000000
0x0000cbfc  fcsel    d8, d1, d0, ne
0x0000cc00  adrp     x8, #0x18000
0x0000cc04  ldr      x0, [x8, #0x4d8] ; -> [classref(UIGraphicsImageRendererFormat)]
0x0000cc08  bl       #0xe000 ; call objc_stub[preferredFormat]
0x0000cc0c  mov      x29, x29
0x0000cc10  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000cc14  mov      x20, x0
0x0000cc18  fmov     d0, #1.00000000
0x0000cc1c  bl       #0xe2e0 ; call objc_stub[setScale:]
0x0000cc20  ldrb     w2, [x19, #0x24]
0x0000cc24  mov      x0, x20
0x0000cc28  bl       #0xe2c0 ; call objc_stub[setOpaque:]
0x0000cc2c  adrp     x8, #0x18000
0x0000cc30  ldr      x0, [x8, #0x4e0] ; -> [classref(UIGraphicsImageRenderer)]
0x0000cc34  bl       #0xd404 ; call stub:_objc_alloc
0x0000cc38  mov      x8, #0x4058000000000000
0x0000cc3c  fmov     d0, x8
0x0000cc40  mov      v1.16b, v0.16b
0x0000cc44  mov      x2, x20
0x0000cc48  bl       #0xdc00 ; call objc_stub[initWithSize:format:]
0x0000cc4c  mov      x21, x0
0x0000cc50  adrp     x8, #0x14000
0x0000cc54  ldr      x8, [x8, #0x1a0] ; -> [got(__NSConcreteStackBlock)]
0x0000cc58  str      x8, [sp]
0x0000cc5c  adrp     x8, #0xf000
0x0000cc60  ldr      d0, [x8, #0xac8] ; -> [__TEXT,__const+0x18 [u64=0xc0000000 f64=1.591496843e-314]]
0x0000cc64  adrp     x8, #0xc000
0x0000cc68  add      x8, x8, #0xcd8 ; -> __TEXT,__text+0x8cd8
0x0000cc6c  adrp     x9, #0x14000
0x0000cc70  add      x9, x9, #0x828 ; -> __DATA_CONST,__const+0x420 [u64=0x0 f64=0.0]
0x0000cc74  str      d0, [sp, #8]
0x0000cc78  stp      x8, x9, [sp, #0x10]
0x0000cc7c  ldrb     w8, [x19, #0x24]
0x0000cc80  strb     w8, [sp, #0x28]
0x0000cc84  str      d8, [sp, #0x20]
0x0000cc88  mov      x2, sp
0x0000cc8c  bl       #0xdbe0 ; call objc_stub[imageWithActions:]
0x0000cc90  mov      x29, x29
0x0000cc94  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000cc98  ldrsw    x9, [x19, #0x20]
0x0000cc9c  adrp     x10, #0x18000
0x0000cca0  add      x10, x10, #0x708 ; -> __DATA,__bss+0x208
0x0000cca4  ldr      x8, [x10, x9, lsl #3] ; -> [__DATA,__bss+0x208]
0x0000cca8  str      x0, [x10, x9, lsl #3]
0x0000ccac  mov      x0, x8
0x0000ccb0  bl       #0xd4b8 ; call stub:_objc_release
0x0000ccb4  mov      x0, x21
0x0000ccb8  bl       #0xd4b8 ; call stub:_objc_release
0x0000ccbc  mov      x0, x20
0x0000ccc0  ldp      x29, x30, [sp, #0x60]
0x0000ccc4  ldp      x20, x19, [sp, #0x50]
0x0000ccc8  ldp      x22, x21, [sp, #0x40]
0x0000cccc  ldp      d9, d8, [sp, #0x30]
0x0000ccd0  add      sp, sp, #0x70
0x0000ccd4  b        #0xd4b8 ; call stub:_objc_release
