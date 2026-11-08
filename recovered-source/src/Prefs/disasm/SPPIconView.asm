=== -[SPPIconView initWithFrame:]  va=0x2ce24 size=612 types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
0x0002ce24  sub      sp, sp, #0x50
0x0002ce28  stp      x24, x23, [sp, #0x10]
0x0002ce2c  stp      x22, x21, [sp, #0x20]
0x0002ce30  stp      x20, x19, [sp, #0x30]
0x0002ce34  stp      x29, x30, [sp, #0x40]
0x0002ce38  add      x29, sp, #0x40
0x0002ce3c  adrp     x8, #0x8e000
0x0002ce40  ldr      x8, [x8, #0xd70]   ; @SUPER SPPIconView
0x0002ce44  stp      x0, x8, [sp]
0x0002ce48  adrp     x8, #0x8c000
0x0002ce4c  ldr      x1, [x8, #0x8c8]   ; @SEL "initWithFrame:"
0x0002ce50  mov      x0, sp
0x0002ce54  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0002ce58  mov      x19, x0
0x0002ce5c  cbz      x0, #0x2d06c
0x0002ce60  mov      x0, x19
0x0002ce64  mov      w2, #0
0x0002ce68  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x0002ce6c  adrp     x8, #0x8e000
0x0002ce70  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x0002ce74  bl       #0x55c88   ; CALL _objc_alloc_init
0x0002ce78  adrp     x8, #0x8e000
0x0002ce7c  ldrsw    x23, [x8, #0xec8]
0x0002ce80  ldr      x8, [x19, x23]
0x0002ce84  str      x0, [x19, x23]
0x0002ce88  mov      x0, x8
0x0002ce8c  bl       #0x55d78   ; CALL _objc_release
0x0002ce90  ldr      x0, [x19, x23]
0x0002ce94  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002ce98  mov      x29, x29
0x0002ce9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002cea0  mov      x20, x0
0x0002cea4  mov      w2, #1
0x0002cea8  bl       #0x5b520   ; CALL objc_msgSend$setMasksToBounds:
0x0002ceac  mov      x0, x20
0x0002ceb0  bl       #0x55d78   ; CALL _objc_release
0x0002ceb4  ldr      x0, [x19, x23]
0x0002ceb8  mov      w2, #2
0x0002cebc  bl       #0x5aa40   ; CALL objc_msgSend$setContentMode:
0x0002cec0  adrp     x8, #0x74000
0x0002cec4  ldr      x8, [x8, #0x658]   ; @GOT _kCAFilterTrilinear
0x0002cec8  ldr      x20, [x8]   ; @GOT ___objc_personality_v0
0x0002cecc  ldr      x0, [x19, x23]
0x0002ced0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002ced4  mov      x29, x29
0x0002ced8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002cedc  mov      x21, x0
0x0002cee0  mov      x2, x20
0x0002cee4  bl       #0x5b600   ; CALL objc_msgSend$setMinificationFilter:
0x0002cee8  mov      x0, x21
0x0002ceec  bl       #0x55d78   ; CALL _objc_release
0x0002cef0  ldr      x0, [x19, x23]
0x0002cef4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002cef8  mov      x29, x29
0x0002cefc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002cf00  mov      x20, x0
0x0002cf04  fmov     d0, #0.75000000
0x0002cf08  bl       #0x5a740   ; CALL objc_msgSend$setBorderWidth:
0x0002cf0c  mov      x0, x20
0x0002cf10  bl       #0x55d78   ; CALL _objc_release
0x0002cf14  adrp     x24, #0x8e000
0x0002cf18  ldr      x0, [x24, #0x910]   ; @CLASS UIColor
0x0002cf1c  adrp     x8, #0x65000
0x0002cf20  ldr      d1, [x8, #0x608]
0x0002cf24  fmov     d0, #1.00000000
0x0002cf28  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0002cf2c  mov      x29, x29
0x0002cf30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002cf34  mov      x20, x0
0x0002cf38  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002cf3c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002cf40  mov      x21, x0
0x0002cf44  ldr      x0, [x19, x23]
0x0002cf48  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002cf4c  mov      x29, x29
0x0002cf50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002cf54  mov      x22, x0
0x0002cf58  mov      x2, x21
0x0002cf5c  bl       #0x5a700   ; CALL objc_msgSend$setBorderColor:
0x0002cf60  mov      x0, x22
0x0002cf64  bl       #0x55d78   ; CALL _objc_release
0x0002cf68  mov      x0, x20
0x0002cf6c  bl       #0x55d78   ; CALL _objc_release
0x0002cf70  adrp     x8, #0x74000
0x0002cf74  ldr      x8, [x8, #0x648]   ; @GOT _kCACornerCurveContinuous
0x0002cf78  ldr      x20, [x8]   ; @GOT ___objc_personality_v0
0x0002cf7c  ldr      x0, [x19, x23]
0x0002cf80  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002cf84  mov      x29, x29
0x0002cf88  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002cf8c  mov      x21, x0
0x0002cf90  mov      x2, x20
0x0002cf94  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x0002cf98  mov      x0, x21
0x0002cf9c  bl       #0x55d78   ; CALL _objc_release
0x0002cfa0  ldr      x2, [x19, x23]
0x0002cfa4  mov      x0, x19
0x0002cfa8  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002cfac  ldr      x0, [x24, #0x910]   ; @CLASS UIColor
0x0002cfb0  bl       #0x56940   ; CALL objc_msgSend$blackColor
0x0002cfb4  mov      x29, x29
0x0002cfb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002cfbc  mov      x20, x0
0x0002cfc0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002cfc4  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002cfc8  mov      x21, x0
0x0002cfcc  mov      x0, x19
0x0002cfd0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002cfd4  mov      x29, x29
0x0002cfd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002cfdc  mov      x22, x0
0x0002cfe0  mov      x2, x21
0x0002cfe4  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x0002cfe8  mov      x0, x22
0x0002cfec  bl       #0x55d78   ; CALL _objc_release
0x0002cff0  mov      x0, x20
0x0002cff4  bl       #0x55d78   ; CALL _objc_release
0x0002cff8  mov      x0, x19
0x0002cffc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002d000  mov      x29, x29
0x0002d004  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d008  mov      x20, x0
0x0002d00c  adrp     x8, #0x65000
0x0002d010  ldr      s0, [x8, #0xd04]
0x0002d014  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x0002d018  mov      x0, x20
0x0002d01c  bl       #0x55d78   ; CALL _objc_release
0x0002d020  mov      x0, x19
0x0002d024  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002d028  mov      x29, x29
0x0002d02c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d030  mov      x20, x0
0x0002d034  fmov     d0, #2.50000000
0x0002d038  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x0002d03c  mov      x0, x20
0x0002d040  bl       #0x55d78   ; CALL _objc_release
0x0002d044  mov      x0, x19
0x0002d048  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002d04c  mov      x29, x29
0x0002d050  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d054  mov      x20, x0
0x0002d058  fmov     d0, xzr
0x0002d05c  fmov     d1, #1.50000000
0x0002d060  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x0002d064  mov      x0, x20
0x0002d068  bl       #0x55d78   ; CALL _objc_release
0x0002d06c  mov      x0, x19
0x0002d070  ldp      x29, x30, [sp, #0x40]
0x0002d074  ldp      x20, x19, [sp, #0x30]
0x0002d078  ldp      x22, x21, [sp, #0x20]
0x0002d07c  ldp      x24, x23, [sp, #0x10]
0x0002d080  add      sp, sp, #0x50
0x0002d084  ret      

=== -[SPPIconView setShape:]  va=0x2d088 size=16 types=v24@0:8q16
0x0002d088  adrp     x8, #0x8e000
0x0002d08c  ldrsw    x8, [x8, #0xecc]
0x0002d090  str      x2, [x0, x8]
0x0002d094  b        #0x5b7a0   ; CALL objc_msgSend$setNeedsLayout

=== -[SPPIconView layoutSubviews]  va=0x2d098 size=664 types=v16@0:8
0x0002d098  sub      sp, sp, #0x70
0x0002d09c  stp      d13, d12, [sp, #0x10]
0x0002d0a0  stp      d11, d10, [sp, #0x20]
0x0002d0a4  stp      d9, d8, [sp, #0x30]
0x0002d0a8  stp      x22, x21, [sp, #0x40]
0x0002d0ac  stp      x20, x19, [sp, #0x50]
0x0002d0b0  stp      x29, x30, [sp, #0x60]
0x0002d0b4  add      x29, sp, #0x60
0x0002d0b8  mov      x19, x0
0x0002d0bc  adrp     x8, #0x8e000
0x0002d0c0  ldr      x8, [x8, #0xd70]   ; @SUPER SPPIconView
0x0002d0c4  stp      x0, x8, [sp]
0x0002d0c8  adrp     x8, #0x8b000
0x0002d0cc  ldr      x1, [x8, #0xe28]   ; @SEL "layoutSubviews"
0x0002d0d0  mov      x0, sp
0x0002d0d4  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0002d0d8  mov      x0, x19
0x0002d0dc  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0002d0e0  mov      v8.16b, v2.16b
0x0002d0e4  mov      v9.16b, v3.16b
0x0002d0e8  mov      x0, x19
0x0002d0ec  bl       #0x5c940   ; CALL objc_msgSend$shape
0x0002d0f0  cmp      x0, #1
0x0002d0f4  b.ne     #0x2d10c
0x0002d0f8  fcmp     d8, d9
0x0002d0fc  fcsel    d0, d8, d9, mi
0x0002d100  fmov     d1, #0.50000000
0x0002d104  fmul     d8, d0, d1
0x0002d108  b        #0x2d144
0x0002d10c  mov      x0, x19
0x0002d110  bl       #0x5c940   ; CALL objc_msgSend$shape
0x0002d114  cmp      x0, #2
0x0002d118  b.ne     #0x2d138
0x0002d11c  mov      x0, x19
0x0002d120  bl       #0x5da40   ; CALL objc_msgSend$tileCorner
0x0002d124  mov      v8.16b, v0.16b
0x0002d128  mov      x0, x19
0x0002d12c  bl       #0x5da60   ; CALL objc_msgSend$tileMask
0x0002d130  mov      x20, x0
0x0002d134  b        #0x2d148
0x0002d138  adrp     x8, #0x65000
0x0002d13c  ldr      d0, [x8, #0x730]
0x0002d140  fmul     d8, d8, d0
0x0002d144  mov      w20, #0xf
0x0002d148  mov      x0, x19
0x0002d14c  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0002d150  mov      v9.16b, v0.16b
0x0002d154  mov      v10.16b, v1.16b
0x0002d158  mov      v11.16b, v2.16b
0x0002d15c  mov      v12.16b, v3.16b
0x0002d160  mov      x0, x19
0x0002d164  bl       #0x58120   ; CALL objc_msgSend$imageView
0x0002d168  mov      x29, x29
0x0002d16c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d170  mov      x21, x0
0x0002d174  mov      v0.16b, v9.16b
0x0002d178  mov      v1.16b, v10.16b
0x0002d17c  mov      v2.16b, v11.16b
0x0002d180  mov      v3.16b, v12.16b
0x0002d184  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0002d188  mov      x0, x21
0x0002d18c  bl       #0x55d78   ; CALL _objc_release
0x0002d190  mov      x0, x19
0x0002d194  bl       #0x58120   ; CALL objc_msgSend$imageView
0x0002d198  mov      x29, x29
0x0002d19c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d1a0  mov      x21, x0
0x0002d1a4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002d1a8  mov      x29, x29
0x0002d1ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d1b0  mov      x22, x0
0x0002d1b4  mov      v0.16b, v8.16b
0x0002d1b8  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0002d1bc  mov      x0, x22
0x0002d1c0  bl       #0x55d78   ; CALL _objc_release
0x0002d1c4  mov      x0, x21
0x0002d1c8  bl       #0x55d78   ; CALL _objc_release
0x0002d1cc  mov      x0, x19
0x0002d1d0  bl       #0x58120   ; CALL objc_msgSend$imageView
0x0002d1d4  mov      x29, x29
0x0002d1d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d1dc  mov      x21, x0
0x0002d1e0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002d1e4  mov      x29, x29
0x0002d1e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d1ec  mov      x22, x0
0x0002d1f0  mov      x2, x20
0x0002d1f4  bl       #0x5b500   ; CALL objc_msgSend$setMaskedCorners:
0x0002d1f8  mov      x0, x22
0x0002d1fc  bl       #0x55d78   ; CALL _objc_release
0x0002d200  mov      x0, x21
0x0002d204  bl       #0x55d78   ; CALL _objc_release
0x0002d208  mov      x0, x19
0x0002d20c  bl       #0x5c940   ; CALL objc_msgSend$shape
0x0002d210  cmp      x0, #2
0x0002d214  fmov     d0, #0.75000000
0x0002d218  fmov     d1, xzr
0x0002d21c  fcsel    d9, d1, d0, eq
0x0002d220  mov      x0, x19
0x0002d224  bl       #0x58120   ; CALL objc_msgSend$imageView
0x0002d228  mov      x29, x29
0x0002d22c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d230  mov      x20, x0
0x0002d234  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002d238  mov      x29, x29
0x0002d23c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d240  mov      x21, x0
0x0002d244  mov      v0.16b, v9.16b
0x0002d248  bl       #0x5a740   ; CALL objc_msgSend$setBorderWidth:
0x0002d24c  mov      x0, x21
0x0002d250  bl       #0x55d78   ; CALL _objc_release
0x0002d254  mov      x0, x20
0x0002d258  bl       #0x55d78   ; CALL _objc_release
0x0002d25c  mov      x0, x19
0x0002d260  bl       #0x5c940   ; CALL objc_msgSend$shape
0x0002d264  cmp      x0, #2
0x0002d268  b.ne     #0x2d2b0
0x0002d26c  mov      x0, x19
0x0002d270  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002d274  mov      x29, x29
0x0002d278  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d27c  mov      x20, x0
0x0002d280  fmov     s0, wzr
0x0002d284  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x0002d288  mov      x0, x20
0x0002d28c  bl       #0x55d78   ; CALL _objc_release
0x0002d290  mov      x0, x19
0x0002d294  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002d298  mov      x29, x29
0x0002d29c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d2a0  mov      x20, x0
0x0002d2a4  mov      x2, #0
0x0002d2a8  bl       #0x5c020   ; CALL objc_msgSend$setShadowPath:
0x0002d2ac  b        #0x2d308
0x0002d2b0  adrp     x8, #0x8e000
0x0002d2b4  ldr      x20, [x8, #0xac0]   ; @CLASS UIBezierPath
0x0002d2b8  mov      x0, x19
0x0002d2bc  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0002d2c0  mov      x0, x20
0x0002d2c4  mov      v4.16b, v8.16b
0x0002d2c8  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x0002d2cc  mov      x29, x29
0x0002d2d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d2d4  mov      x20, x0
0x0002d2d8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002d2dc  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x0002d2e0  mov      x21, x0
0x0002d2e4  mov      x0, x19
0x0002d2e8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002d2ec  mov      x29, x29
0x0002d2f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d2f4  mov      x19, x0
0x0002d2f8  mov      x2, x21
0x0002d2fc  bl       #0x5c020   ; CALL objc_msgSend$setShadowPath:
0x0002d300  mov      x0, x19
0x0002d304  bl       #0x55d78   ; CALL _objc_release
0x0002d308  mov      x0, x20
0x0002d30c  bl       #0x55d78   ; CALL _objc_release
0x0002d310  ldp      x29, x30, [sp, #0x60]
0x0002d314  ldp      x20, x19, [sp, #0x50]
0x0002d318  ldp      x22, x21, [sp, #0x40]
0x0002d31c  ldp      d9, d8, [sp, #0x30]
0x0002d320  ldp      d11, d10, [sp, #0x20]
0x0002d324  ldp      d13, d12, [sp, #0x10]
0x0002d328  add      sp, sp, #0x70
0x0002d32c  ret      

=== -[SPPIconView imageView]  va=0x2d330 size=16 types=@16@0:8
0x0002d330  adrp     x8, #0x8e000
0x0002d334  ldrsw    x8, [x8, #0xec8]
0x0002d338  ldr      x0, [x0, x8]
0x0002d33c  ret      

=== -[SPPIconView setImageView:]  va=0x2d340 size=64 types=v24@0:8@16
0x0002d340  stp      x22, x21, [sp, #-0x30]!
0x0002d344  stp      x20, x19, [sp, #0x10]
0x0002d348  stp      x29, x30, [sp, #0x20]
0x0002d34c  add      x29, sp, #0x20
0x0002d350  mov      x19, x2
0x0002d354  mov      x20, x0
0x0002d358  adrp     x8, #0x8e000
0x0002d35c  ldrsw    x21, [x8, #0xec8]
0x0002d360  mov      x0, x2
0x0002d364  bl       #0x55d84   ; CALL _objc_retain
0x0002d368  ldr      x0, [x20, x21]
0x0002d36c  str      x19, [x20, x21]
0x0002d370  ldp      x29, x30, [sp, #0x20]
0x0002d374  ldp      x20, x19, [sp, #0x10]
0x0002d378  ldp      x22, x21, [sp], #0x30
0x0002d37c  b        #0x55d78   ; CALL _objc_release

=== -[SPPIconView shape]  va=0x2d380 size=16 types=q16@0:8
0x0002d380  adrp     x8, #0x8e000
0x0002d384  ldrsw    x8, [x8, #0xecc]
0x0002d388  ldr      x0, [x0, x8]
0x0002d38c  ret      

=== -[SPPIconView tileCorner]  va=0x2d390 size=16 types=d16@0:8
0x0002d390  adrp     x8, #0x8e000
0x0002d394  ldrsw    x8, [x8, #0xed0]
0x0002d398  ldr      d0, [x0, x8]
0x0002d39c  ret      

=== -[SPPIconView setTileCorner:]  va=0x2d3a0 size=16 types=v24@0:8d16
0x0002d3a0  adrp     x8, #0x8e000
0x0002d3a4  ldrsw    x8, [x8, #0xed0]
0x0002d3a8  str      d0, [x0, x8]
0x0002d3ac  ret      

=== -[SPPIconView tileMask]  va=0x2d3b0 size=16 types=Q16@0:8
0x0002d3b0  adrp     x8, #0x8e000
0x0002d3b4  ldrsw    x8, [x8, #0xed4]
0x0002d3b8  ldr      x0, [x0, x8]
0x0002d3bc  ret      

=== -[SPPIconView setTileMask:]  va=0x2d3c0 size=16 types=v24@0:8Q16
0x0002d3c0  adrp     x8, #0x8e000
0x0002d3c4  ldrsw    x8, [x8, #0xed4]
0x0002d3c8  str      x2, [x0, x8]
0x0002d3cc  ret      

=== -[SPPIconView .cxx_destruct]  va=0x2d3d0 size=20 types=v16@0:8
0x0002d3d0  adrp     x8, #0x8e000
0x0002d3d4  ldrsw    x8, [x8, #0xec8]
0x0002d3d8  add      x0, x0, x8
0x0002d3dc  mov      x1, #0
0x0002d3e0  b        #0x55dcc   ; CALL _objc_storeStrong
