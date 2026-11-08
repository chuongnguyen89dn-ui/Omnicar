; === sub_ccd8 @ 0xccd8 size=544 ===
0x0000ccd8  sub      sp, sp, #0x140
0x0000ccdc  stp      d11, d10, [sp, #0xc0]
0x0000cce0  stp      d9, d8, [sp, #0xd0]
0x0000cce4  stp      x28, x27, [sp, #0xe0]
0x0000cce8  stp      x26, x25, [sp, #0xf0]
0x0000ccec  stp      x24, x23, [sp, #0x100]
0x0000ccf0  stp      x22, x21, [sp, #0x110]
0x0000ccf4  stp      x20, x19, [sp, #0x120]
0x0000ccf8  stp      x29, x30, [sp, #0x130]
0x0000ccfc  add      x29, sp, #0x130
0x0000cd00  mov      x19, x0
0x0000cd04  adrp     x8, #0x14000
0x0000cd08  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x0000cd0c  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x0000cd10  stur     x8, [x29, #-0x78]
0x0000cd14  mov      x0, x1
0x0000cd18  bl       #0xd640 ; call objc_stub[CGContext]
0x0000cd1c  mov      x20, x0
0x0000cd20  movi     v0.16b, #0
0x0000cd24  stp      q0, q0, [sp, #0x90]
0x0000cd28  mov      x8, #0x4058000000000000
0x0000cd2c  dup      v1.2d, x8
0x0000cd30  stp      q1, q0, [sp, #0x70]
0x0000cd34  stur     q1, [sp, #0x88]
0x0000cd38  ldrb     w8, [x19, #0x28]
0x0000cd3c  adrp     x9, #0x18000
0x0000cd40  ldr      x0, [x9, #0x4e8] ; -> [classref(UIColor)]
0x0000cd44  tbz      w8, #0, #0xcd68
0x0000cd48  adrp     x8, #0xf000
0x0000cd4c  ldr      d0, [x8, #0xb28] ; -> [__TEXT,__const+0x78 [u64=0x3fec5c5c5c5c5c5c f64=0.8862745098039215]]
0x0000cd50  adrp     x8, #0xf000
0x0000cd54  ldr      d1, [x8, #0xb30] ; -> [__TEXT,__const+0x80 [u64=0x3fec9c9c9c9c9c9d f64=0.8941176470588236]]
0x0000cd58  adrp     x8, #0xf000
0x0000cd5c  ldr      d2, [x8, #0xb38] ; -> [__TEXT,__const+0x88 [u64=0x3feededededededf f64=0.9647058823529412]]
0x0000cd60  fmov     d3, #1.00000000
0x0000cd64  b        #0xcd88
0x0000cd68  adrp     x8, #0xf000
0x0000cd6c  ldr      d0, [x8, #0xb08] ; -> [__TEXT,__const+0x58 [u64=0x3fed1d1d1d1d1d1d f64=0.9098039215686274]]
0x0000cd70  adrp     x8, #0xf000
0x0000cd74  ldr      d1, [x8, #0xb10] ; -> [__TEXT,__const+0x60 [u64=0x3fed5d5d5d5d5d5d f64=0.9176470588235294]]
0x0000cd78  adrp     x8, #0xf000
0x0000cd7c  ldr      d2, [x8, #0xb18] ; -> [__TEXT,__const+0x68 [u64=0x3fef5f5f5f5f5f5f f64=0.9803921568627451]]
0x0000cd80  adrp     x8, #0xf000
0x0000cd84  ldr      d3, [x8, #0xb20] ; -> [__TEXT,__const+0x70 [u64=0x3fe999999999999a f64=0.8]]
0x0000cd88  bl       #0xd860 ; call objc_stub[colorWithRed:green:blue:alpha:]
0x0000cd8c  mov      x29, x29
0x0000cd90  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000cd94  mov      x21, x0
0x0000cd98  bl       #0xe240 ; call objc_stub[setFill]
0x0000cd9c  mov      x8, #0x4058000000000000
0x0000cda0  fmov     d2, x8
0x0000cda4  fmov     d0, xzr
0x0000cda8  fmov     d1, xzr
0x0000cdac  mov      x0, x20
0x0000cdb0  mov      v3.16b, v2.16b
0x0000cdb4  bl       #0xd128 ; call stub:_CGContextFillRect
0x0000cdb8  adrp     x24, #0xf000
0x0000cdbc  add      x24, x24, #0xb60 ; -> __TEXT,__const+0xb0 [u64=0xfec4d800a0f1d9 f64=7.010623654806434e-304]
0x0000cdc0  bl       #0xd104 ; call stub:_CGColorSpaceCreateDeviceRGB
0x0000cdc4  mov      x22, x0
0x0000cdc8  mov      x25, #0
0x0000cdcc  adrp     x8, #0xf000
0x0000cdd0  ldr      d9, [x8, #0xb40] ; -> [__TEXT,__const+0x90 [u64=0x406fe00000000000 f64=255.0]]
0x0000cdd4  adrp     x8, #0xf000
0x0000cdd8  ldr      d10, [x8, #0xb48] ; -> [__TEXT,__const+0x98 [u64=0xfffffff8fffffff0 f64=nan]]
0x0000cddc  movi     d11, #0x0000ff000000ff
0x0000cde0  mov      x8, #0xe00000000000
0x0000cde4  movk     x8, #0x406f, lsl #48
0x0000cde8  dup      v4.2d, x8
0x0000cdec  adrp     x8, #0xf000
0x0000cdf0  add      x8, x8, #0xb70 ; -> __TEXT,__const+0xc0 [u64=0x0 f64=0.0]
0x0000cdf4  ldr      q0, [x8] ; -> [__TEXT,__const+0xc0 [u64=0x0 f64=0.0]]
0x0000cdf8  stp      q0, q4, [sp]
0x0000cdfc  add      x26, sp, #0x70
0x0000ce00  adrp     x8, #0xf000
0x0000ce04  ldr      d8, [x8, #0xb50] ; -> [__TEXT,__const+0xa0 [u64=0x4057c23feb9f31fe f64=95.035151391472]]
0x0000ce08  ldr      w8, [x24], #4
0x0000ce0c  and      w9, w8, #0xff
0x0000ce10  ucvtf    d0, w9
0x0000ce14  dup      v1.2s, w8
0x0000ce18  ushl     v1.2s, v1.2s, v10.2s
0x0000ce1c  and      v1.8b, v1.8b, v11.8b
0x0000ce20  ushll    v1.2d, v1.2s, #0
0x0000ce24  ucvtf    v1.2d, v1.2d
0x0000ce28  ldr      q2, [sp, #0x10]
0x0000ce2c  fdiv     v1.2d, v1.2d, v2.2d
0x0000ce30  ldr      d2, [x19, #0x20]
0x0000ce34  fdiv     d0, d0, d9
0x0000ce38  stp      d0, d2, [sp, #0x40]
0x0000ce3c  str      q1, [sp, #0x50]
0x0000ce40  str      d0, [sp, #0x60]
0x0000ce44  str      xzr, [sp, #0x68]
0x0000ce48  ldr      q0, [sp]
0x0000ce4c  stp      q0, q1, [sp, #0x20]
0x0000ce50  add      x1, sp, #0x30
0x0000ce54  add      x2, sp, #0x20
0x0000ce58  mov      x0, x22
0x0000ce5c  mov      w3, #2
0x0000ce60  bl       #0xd134 ; call stub:_CGGradientCreateWithColorComponents
0x0000ce64  mov      x23, x0
0x0000ce68  add      x8, x26, x25
0x0000ce6c  ldp      d0, d1, [x8]
0x0000ce70  fmov     d2, xzr
0x0000ce74  mov      x0, x20
0x0000ce78  mov      x1, x23
0x0000ce7c  mov      v3.16b, v0.16b
0x0000ce80  mov      v4.16b, v1.16b
0x0000ce84  mov      v5.16b, v8.16b
0x0000ce88  mov      w2, #0
0x0000ce8c  bl       #0xd11c ; call stub:_CGContextDrawRadialGradient
0x0000ce90  mov      x0, x23
0x0000ce94  bl       #0xd140 ; call stub:_CGGradientRelease
0x0000ce98  add      x25, x25, #0x10
0x0000ce9c  cmp      x25, #0x40
0x0000cea0  b.ne     #0xce08
0x0000cea4  mov      x0, x22
0x0000cea8  bl       #0xd110 ; call stub:_CGColorSpaceRelease
0x0000ceac  mov      x0, x21
0x0000ceb0  bl       #0xd4b8 ; call stub:_objc_release
0x0000ceb4  ldur     x8, [x29, #-0x78]
0x0000ceb8  adrp     x9, #0x14000
0x0000cebc  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x0000cec0  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x0000cec4  cmp      x9, x8
0x0000cec8  b.ne     #0xcef4
0x0000cecc  ldp      x29, x30, [sp, #0x130]
0x0000ced0  ldp      x20, x19, [sp, #0x120]
0x0000ced4  ldp      x22, x21, [sp, #0x110]
0x0000ced8  ldp      x24, x23, [sp, #0x100]
0x0000cedc  ldp      x26, x25, [sp, #0xf0]
0x0000cee0  ldp      x28, x27, [sp, #0xe0]
0x0000cee4  ldp      d9, d8, [sp, #0xd0]
0x0000cee8  ldp      d11, d10, [sp, #0xc0]
0x0000ceec  add      sp, sp, #0x140
0x0000cef0  ret      
0x0000cef4  bl       #0xd1b8 ; call stub:___stack_chk_fail
