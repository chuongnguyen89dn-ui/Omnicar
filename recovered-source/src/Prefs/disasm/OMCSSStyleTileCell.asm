=== -[OMCSSStyleTileCell initWithFrame:]  va=0x3be94 size=1476 types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
0x0003be94  sub      sp, sp, #0x90
0x0003be98  stp      d13, d12, [sp, #0x10]
0x0003be9c  stp      d11, d10, [sp, #0x20]
0x0003bea0  stp      d9, d8, [sp, #0x30]
0x0003bea4  stp      x26, x25, [sp, #0x40]
0x0003bea8  stp      x24, x23, [sp, #0x50]
0x0003beac  stp      x22, x21, [sp, #0x60]
0x0003beb0  stp      x20, x19, [sp, #0x70]
0x0003beb4  stp      x29, x30, [sp, #0x80]
0x0003beb8  add      x29, sp, #0x80
0x0003bebc  mov      v8.16b, v2.16b
0x0003bec0  adrp     x8, #0x8e000
0x0003bec4  ldr      x8, [x8, #0xda8]   ; @SUPER OMCSSStyleTileCell
0x0003bec8  stp      x0, x8, [sp]
0x0003becc  adrp     x8, #0x8c000
0x0003bed0  ldr      x1, [x8, #0x8c8]   ; @SEL "initWithFrame:"
0x0003bed4  mov      x0, sp
0x0003bed8  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0003bedc  mov      x19, x0
0x0003bee0  cbz      x0, #0x3c42c
0x0003bee4  adrp     x8, #0x8e000
0x0003bee8  ldr      x0, [x8, #0x918]   ; @CLASS UIView
0x0003beec  bl       #0x55c7c   ; CALL _objc_alloc
0x0003bef0  mov      x8, #-0x3fb1000000000000
0x0003bef4  fmov     d0, x8
0x0003bef8  fadd     d0, d8, d0
0x0003befc  fmov     d1, #0.50000000
0x0003bf00  fmul     d0, d0, d1
0x0003bf04  frinta   d0, d0
0x0003bf08  mov      x8, #0x404f000000000000
0x0003bf0c  fmov     d2, x8
0x0003bf10  fmov     d1, #10.00000000
0x0003bf14  mov      v3.16b, v2.16b
0x0003bf18  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0003bf1c  mov      x20, x0
0x0003bf20  mov      x0, x19
0x0003bf24  mov      x2, x20
0x0003bf28  bl       #0x5a7e0   ; CALL objc_msgSend$setCard:
0x0003bf2c  mov      x0, x20
0x0003bf30  bl       #0x55d78   ; CALL _objc_release
0x0003bf34  mov      x0, x19
0x0003bf38  bl       #0x56c00   ; CALL objc_msgSend$card
0x0003bf3c  mov      x29, x29
0x0003bf40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003bf44  mov      x20, x0
0x0003bf48  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003bf4c  mov      x29, x29
0x0003bf50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003bf54  mov      x21, x0
0x0003bf58  fmov     d0, #18.00000000
0x0003bf5c  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0003bf60  mov      x0, x21
0x0003bf64  bl       #0x55d78   ; CALL _objc_release
0x0003bf68  mov      x0, x20
0x0003bf6c  bl       #0x55d78   ; CALL _objc_release
0x0003bf70  adrp     x8, #0x74000
0x0003bf74  ldr      x8, [x8, #0x648]   ; @GOT _kCACornerCurveContinuous
0x0003bf78  ldr      x20, [x8]   ; @GOT ___objc_personality_v0
0x0003bf7c  mov      x0, x19
0x0003bf80  bl       #0x56c00   ; CALL objc_msgSend$card
0x0003bf84  mov      x29, x29
0x0003bf88  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003bf8c  mov      x21, x0
0x0003bf90  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003bf94  mov      x29, x29
0x0003bf98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003bf9c  mov      x22, x0
0x0003bfa0  mov      x2, x20
0x0003bfa4  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x0003bfa8  mov      x0, x22
0x0003bfac  bl       #0x55d78   ; CALL _objc_release
0x0003bfb0  mov      x0, x21
0x0003bfb4  bl       #0x55d78   ; CALL _objc_release
0x0003bfb8  adrp     x8, #0x8e000
0x0003bfbc  ldr      x22, [x8, #0xac0]   ; @CLASS UIBezierPath
0x0003bfc0  mov      x0, x19
0x0003bfc4  bl       #0x56c00   ; CALL objc_msgSend$card
0x0003bfc8  mov      x29, x29
0x0003bfcc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003bfd0  mov      x21, x0
0x0003bfd4  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0003bfd8  fmov     d4, #18.00000000
0x0003bfdc  mov      x0, x22
0x0003bfe0  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x0003bfe4  mov      x29, x29
0x0003bfe8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003bfec  mov      x22, x0
0x0003bff0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0003bff4  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x0003bff8  mov      x23, x0
0x0003bffc  mov      x0, x19
0x0003c000  bl       #0x56c00   ; CALL objc_msgSend$card
0x0003c004  mov      x29, x29
0x0003c008  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c00c  mov      x24, x0
0x0003c010  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003c014  mov      x29, x29
0x0003c018  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c01c  mov      x25, x0
0x0003c020  mov      x2, x23
0x0003c024  bl       #0x5c020   ; CALL objc_msgSend$setShadowPath:
0x0003c028  mov      x0, x25
0x0003c02c  bl       #0x55d78   ; CALL _objc_release
0x0003c030  mov      x0, x24
0x0003c034  bl       #0x55d78   ; CALL _objc_release
0x0003c038  mov      x0, x22
0x0003c03c  bl       #0x55d78   ; CALL _objc_release
0x0003c040  mov      x0, x21
0x0003c044  bl       #0x55d78   ; CALL _objc_release
0x0003c048  mov      x0, x19
0x0003c04c  bl       #0x57280   ; CALL objc_msgSend$contentView
0x0003c050  mov      x29, x29
0x0003c054  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c058  mov      x21, x0
0x0003c05c  mov      x0, x19
0x0003c060  bl       #0x56c00   ; CALL objc_msgSend$card
0x0003c064  mov      x29, x29
0x0003c068  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c06c  mov      x22, x0
0x0003c070  mov      x0, x21
0x0003c074  mov      x2, x22
0x0003c078  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0003c07c  mov      x0, x22
0x0003c080  bl       #0x55d78   ; CALL _objc_release
0x0003c084  mov      x0, x21
0x0003c088  bl       #0x55d78   ; CALL _objc_release
0x0003c08c  adrp     x8, #0x8e000
0x0003c090  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x0003c094  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003c098  mov      x29, x29
0x0003c09c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c0a0  mov      x21, x0
0x0003c0a4  mov      x0, x19
0x0003c0a8  mov      x2, x21
0x0003c0ac  bl       #0x5ae20   ; CALL objc_msgSend$setFill:
0x0003c0b0  mov      x0, x21
0x0003c0b4  bl       #0x55d78   ; CALL _objc_release
0x0003c0b8  mov      x0, x19
0x0003c0bc  bl       #0x56c00   ; CALL objc_msgSend$card
0x0003c0c0  mov      x29, x29
0x0003c0c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c0c8  mov      x21, x0
0x0003c0cc  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0003c0d0  mov      v9.16b, v0.16b
0x0003c0d4  mov      v10.16b, v1.16b
0x0003c0d8  mov      v11.16b, v2.16b
0x0003c0dc  mov      v12.16b, v3.16b
0x0003c0e0  mov      x0, x19
0x0003c0e4  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0003c0e8  mov      x29, x29
0x0003c0ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c0f0  mov      x22, x0
0x0003c0f4  mov      v0.16b, v9.16b
0x0003c0f8  mov      v1.16b, v10.16b
0x0003c0fc  mov      v2.16b, v11.16b
0x0003c100  mov      v3.16b, v12.16b
0x0003c104  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0003c108  mov      x0, x22
0x0003c10c  bl       #0x55d78   ; CALL _objc_release
0x0003c110  mov      x0, x21
0x0003c114  bl       #0x55d78   ; CALL _objc_release
0x0003c118  mov      x0, x19
0x0003c11c  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0003c120  mov      x29, x29
0x0003c124  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c128  mov      x21, x0
0x0003c12c  fmov     d0, #18.00000000
0x0003c130  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0003c134  mov      x0, x21
0x0003c138  bl       #0x55d78   ; CALL _objc_release
0x0003c13c  mov      x0, x19
0x0003c140  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0003c144  mov      x29, x29
0x0003c148  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c14c  mov      x21, x0
0x0003c150  mov      x2, x20
0x0003c154  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x0003c158  mov      x0, x21
0x0003c15c  bl       #0x55d78   ; CALL _objc_release
0x0003c160  mov      x0, x19
0x0003c164  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0003c168  mov      x29, x29
0x0003c16c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c170  mov      x20, x0
0x0003c174  mov      w2, #1
0x0003c178  bl       #0x5b520   ; CALL objc_msgSend$setMasksToBounds:
0x0003c17c  mov      x0, x20
0x0003c180  bl       #0x55d78   ; CALL _objc_release
0x0003c184  mov      x0, x19
0x0003c188  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0003c18c  mov      x29, x29
0x0003c190  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c194  mov      x20, x0
0x0003c198  fmov     d0, xzr
0x0003c19c  fmov     d1, xzr
0x0003c1a0  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x0003c1a4  mov      x0, x20
0x0003c1a8  bl       #0x55d78   ; CALL _objc_release
0x0003c1ac  mov      x0, x19
0x0003c1b0  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0003c1b4  mov      x29, x29
0x0003c1b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c1bc  mov      x20, x0
0x0003c1c0  fmov     d0, #1.00000000
0x0003c1c4  fmov     d1, #1.00000000
0x0003c1c8  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x0003c1cc  mov      x0, x20
0x0003c1d0  bl       #0x55d78   ; CALL _objc_release
0x0003c1d4  mov      x0, x19
0x0003c1d8  bl       #0x56c00   ; CALL objc_msgSend$card
0x0003c1dc  mov      x29, x29
0x0003c1e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c1e4  mov      x20, x0
0x0003c1e8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003c1ec  mov      x29, x29
0x0003c1f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c1f4  mov      x21, x0
0x0003c1f8  mov      x0, x19
0x0003c1fc  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0003c200  mov      x29, x29
0x0003c204  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c208  mov      x22, x0
0x0003c20c  mov      x0, x21
0x0003c210  mov      x2, x22
0x0003c214  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0003c218  mov      x0, x22
0x0003c21c  bl       #0x55d78   ; CALL _objc_release
0x0003c220  mov      x0, x21
0x0003c224  bl       #0x55d78   ; CALL _objc_release
0x0003c228  mov      x0, x20
0x0003c22c  bl       #0x55d78   ; CALL _objc_release
0x0003c230  adrp     x8, #0x8e000
0x0003c234  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x0003c238  bl       #0x55c7c   ; CALL _objc_alloc
0x0003c23c  mov      x20, x0
0x0003c240  mov      x0, x19
0x0003c244  bl       #0x56c00   ; CALL objc_msgSend$card
0x0003c248  mov      x29, x29
0x0003c24c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c250  mov      x21, x0
0x0003c254  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0003c258  mov      x0, x20
0x0003c25c  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0003c260  mov      x20, x0
0x0003c264  mov      x0, x19
0x0003c268  mov      x2, x20
0x0003c26c  bl       #0x5af80   ; CALL objc_msgSend$setGlyph:
0x0003c270  mov      x0, x20
0x0003c274  bl       #0x55d78   ; CALL _objc_release
0x0003c278  mov      x0, x21
0x0003c27c  bl       #0x55d78   ; CALL _objc_release
0x0003c280  mov      x0, x19
0x0003c284  bl       #0x57e40   ; CALL objc_msgSend$glyph
0x0003c288  mov      x29, x29
0x0003c28c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c290  mov      x20, x0
0x0003c294  mov      w2, #4
0x0003c298  bl       #0x5aa40   ; CALL objc_msgSend$setContentMode:
0x0003c29c  mov      x0, x20
0x0003c2a0  bl       #0x55d78   ; CALL _objc_release
0x0003c2a4  mov      x0, x19
0x0003c2a8  bl       #0x56c00   ; CALL objc_msgSend$card
0x0003c2ac  mov      x29, x29
0x0003c2b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c2b4  mov      x20, x0
0x0003c2b8  mov      x0, x19
0x0003c2bc  bl       #0x57e40   ; CALL objc_msgSend$glyph
0x0003c2c0  mov      x29, x29
0x0003c2c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c2c8  mov      x21, x0
0x0003c2cc  mov      x0, x20
0x0003c2d0  mov      x2, x21
0x0003c2d4  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0003c2d8  mov      x0, x21
0x0003c2dc  bl       #0x55d78   ; CALL _objc_release
0x0003c2e0  mov      x0, x20
0x0003c2e4  bl       #0x55d78   ; CALL _objc_release
0x0003c2e8  adrp     x8, #0x8e000
0x0003c2ec  ldr      x0, [x8, #0x940]   ; @CLASS UILabel
0x0003c2f0  bl       #0x55c7c   ; CALL _objc_alloc
0x0003c2f4  adrp     x8, #0x65000
0x0003c2f8  ldr      d1, [x8, #0x9f8]
0x0003c2fc  fmov     d0, xzr
0x0003c300  fmov     d3, #30.00000000
0x0003c304  mov      v2.16b, v8.16b
0x0003c308  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0003c30c  mov      x20, x0
0x0003c310  mov      x0, x19
0x0003c314  mov      x2, x20
0x0003c318  bl       #0x5c5e0   ; CALL objc_msgSend$setTitle:
0x0003c31c  mov      x0, x20
0x0003c320  bl       #0x55d78   ; CALL _objc_release
0x0003c324  mov      x0, x19
0x0003c328  bl       #0x5db40   ; CALL objc_msgSend$title
0x0003c32c  mov      x29, x29
0x0003c330  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c334  mov      x20, x0
0x0003c338  mov      w2, #1
0x0003c33c  bl       #0x5c4e0   ; CALL objc_msgSend$setTextAlignment:
0x0003c340  mov      x0, x20
0x0003c344  bl       #0x55d78   ; CALL _objc_release
0x0003c348  mov      x0, x19
0x0003c34c  bl       #0x5db40   ; CALL objc_msgSend$title
0x0003c350  mov      x29, x29
0x0003c354  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c358  mov      x20, x0
0x0003c35c  mov      w2, #2
0x0003c360  bl       #0x5b820   ; CALL objc_msgSend$setNumberOfLines:
0x0003c364  mov      x0, x20
0x0003c368  bl       #0x55d78   ; CALL _objc_release
0x0003c36c  mov      x0, x19
0x0003c370  bl       #0x5db40   ; CALL objc_msgSend$title
0x0003c374  mov      x29, x29
0x0003c378  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c37c  mov      x20, x0
0x0003c380  mov      w2, #1
0x0003c384  bl       #0x5a380   ; CALL objc_msgSend$setAdjustsFontSizeToFitWidth:
0x0003c388  mov      x0, x20
0x0003c38c  bl       #0x55d78   ; CALL _objc_release
0x0003c390  mov      x0, x19
0x0003c394  bl       #0x5db40   ; CALL objc_msgSend$title
0x0003c398  mov      x29, x29
0x0003c39c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c3a0  mov      x20, x0
0x0003c3a4  adrp     x8, #0x65000
0x0003c3a8  ldr      d0, [x8, #0x670]
0x0003c3ac  bl       #0x5b660   ; CALL objc_msgSend$setMinimumScaleFactor:
0x0003c3b0  mov      x0, x20
0x0003c3b4  bl       #0x55d78   ; CALL _objc_release
0x0003c3b8  mov      x0, x19
0x0003c3bc  bl       #0x5db40   ; CALL objc_msgSend$title
0x0003c3c0  mov      x29, x29
0x0003c3c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c3c8  mov      x20, x0
0x0003c3cc  mov      x2, #0
0x0003c3d0  bl       #0x5b300   ; CALL objc_msgSend$setLineBreakMode:
0x0003c3d4  mov      x0, x20
0x0003c3d8  bl       #0x55d78   ; CALL _objc_release
0x0003c3dc  mov      x0, x19
0x0003c3e0  bl       #0x57280   ; CALL objc_msgSend$contentView
0x0003c3e4  mov      x29, x29
0x0003c3e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c3ec  mov      x20, x0
0x0003c3f0  mov      x0, x19
0x0003c3f4  bl       #0x5db40   ; CALL objc_msgSend$title
0x0003c3f8  mov      x29, x29
0x0003c3fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c400  mov      x21, x0
0x0003c404  mov      x0, x20
0x0003c408  mov      x2, x21
0x0003c40c  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0003c410  mov      x0, x21
0x0003c414  bl       #0x55d78   ; CALL _objc_release
0x0003c418  mov      x0, x20
0x0003c41c  bl       #0x55d78   ; CALL _objc_release
0x0003c420  mov      x0, x19
0x0003c424  mov      w2, #1
0x0003c428  bl       #0x5b180   ; CALL objc_msgSend$setIsAccessibilityElement:
0x0003c42c  mov      x0, x19
0x0003c430  ldp      x29, x30, [sp, #0x80]
0x0003c434  ldp      x20, x19, [sp, #0x70]
0x0003c438  ldp      x22, x21, [sp, #0x60]
0x0003c43c  ldp      x24, x23, [sp, #0x50]
0x0003c440  ldp      x26, x25, [sp, #0x40]
0x0003c444  ldp      d9, d8, [sp, #0x30]
0x0003c448  ldp      d11, d10, [sp, #0x20]
0x0003c44c  ldp      d13, d12, [sp, #0x10]
0x0003c450  add      sp, sp, #0x90
0x0003c454  ret      

=== -[OMCSSStyleTileCell showStyle:chosen:dark:]  va=0x3c458 size=1000 types=v32@0:8q16B24B28
0x0003c458  sub      sp, sp, #0x170
0x0003c45c  stp      x28, x27, [sp, #0x110]
0x0003c460  stp      x26, x25, [sp, #0x120]
0x0003c464  stp      x24, x23, [sp, #0x130]
0x0003c468  stp      x22, x21, [sp, #0x140]
0x0003c46c  stp      x20, x19, [sp, #0x150]
0x0003c470  stp      x29, x30, [sp, #0x160]
0x0003c474  add      x29, sp, #0x160
0x0003c478  mov      x19, x4
0x0003c47c  mov      x20, x3
0x0003c480  mov      x23, x2
0x0003c484  mov      x21, x0
0x0003c488  adrp     x8, #0x74000
0x0003c48c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0003c490  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003c494  stur     x8, [x29, #-0x60]
0x0003c498  tbnz     x2, #0x3f, #0x3c4b4
0x0003c49c  adrp     x0, #0x7f000
0x0003c4a0  add      x0, x0, #0xc90
0x0003c4a4  bl       #0x573c0   ; CALL objc_msgSend$count
0x0003c4a8  cmp      x23, x0
0x0003c4ac  csel     x2, x23, xzr, lt
0x0003c4b0  b        #0x3c4b8
0x0003c4b4  mov      x2, #0
0x0003c4b8  adrp     x0, #0x7f000
0x0003c4bc  add      x0, x0, #0xc90
0x0003c4c0  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0003c4c4  mov      x29, x29
0x0003c4c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c4cc  mov      x24, x0
0x0003c4d0  bl       #0x18080   ; CALL _OMCColorFromHex
0x0003c4d4  mov      x29, x29
0x0003c4d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c4dc  mov      x22, x0
0x0003c4e0  mov      x0, x24
0x0003c4e4  bl       #0x55d78   ; CALL _objc_release
0x0003c4e8  stp      xzr, xzr, [sp, #0x20]
0x0003c4ec  mov      x8, #0x3ff0000000000000
0x0003c4f0  stp      x8, xzr, [sp, #0x10]
0x0003c4f4  add      x2, sp, #0x28
0x0003c4f8  add      x3, sp, #0x20
0x0003c4fc  add      x4, sp, #0x18
0x0003c500  add      x5, sp, #0x10
0x0003c504  mov      x0, x22
0x0003c508  bl       #0x57e00   ; CALL objc_msgSend$getHue:saturation:brightness:alpha:
0x0003c50c  adrp     x8, #0x8e000
0x0003c510  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0003c514  ldp      d1, d0, [sp, #0x20]
0x0003c518  fmov     d2, #0.75000000
0x0003c51c  fmul     d1, d1, d2
0x0003c520  ldr      d2, [sp, #0x18]
0x0003c524  adrp     x8, #0x65000
0x0003c528  ldr      d3, [x8, #0xe80]
0x0003c52c  fmul     d2, d2, d3
0x0003c530  fmov     d3, #1.00000000
0x0003c534  fcmp     d2, d3
0x0003c538  fcsel    d2, d3, d2, gt
0x0003c53c  bl       #0x56ec0   ; CALL objc_msgSend$colorWithHue:saturation:brightness:alpha:
0x0003c540  mov      x29, x29
0x0003c544  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c548  mov      x24, x0
0x0003c54c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0003c550  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0003c554  str      x0, [sp, #0x70]
0x0003c558  mov      x0, x22
0x0003c55c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0003c560  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0003c564  str      x0, [sp, #0x78]
0x0003c568  adrp     x8, #0x8e000
0x0003c56c  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0003c570  add      x2, sp, #0x70
0x0003c574  mov      w3, #2
0x0003c578  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0003c57c  mov      x29, x29
0x0003c580  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c584  mov      x25, x0
0x0003c588  mov      x0, x21
0x0003c58c  mov      x2, x25
0x0003c590  bl       #0x5c400   ; CALL objc_msgSend$setStyleColors:
0x0003c594  mov      x0, x25
0x0003c598  bl       #0x55d78   ; CALL _objc_release
0x0003c59c  tbnz     x23, #0x3f, #0x3c690
0x0003c5a0  adrp     x0, #0x7f000
0x0003c5a4  add      x0, x0, #0xdb0
0x0003c5a8  bl       #0x573c0   ; CALL objc_msgSend$count
0x0003c5ac  cmp      x23, x0
0x0003c5b0  b.ge     #0x3c690
0x0003c5b4  adrp     x8, #0x8e000
0x0003c5b8  ldr      x0, [x8, #0xa70]   ; @CLASS UIImageSymbolConfiguration
0x0003c5bc  fmov     d0, #28.00000000
0x0003c5c0  mov      w2, #6
0x0003c5c4  bl       #0x57100   ; CALL objc_msgSend$configurationWithPointSize:weight:
0x0003c5c8  mov      x29, x29
0x0003c5cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c5d0  mov      x25, x0
0x0003c5d4  movi     v0.16b, #0
0x0003c5d8  stp      q0, q0, [sp, #0x30]
0x0003c5dc  stp      q0, q0, [sp, #0x50]
0x0003c5e0  adrp     x0, #0x7f000
0x0003c5e4  add      x0, x0, #0xdb0
0x0003c5e8  mov      x2, x23
0x0003c5ec  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0003c5f0  mov      x29, x29
0x0003c5f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c5f8  mov      x26, x0
0x0003c5fc  add      x2, sp, #0x30
0x0003c600  add      x3, sp, #0x80
0x0003c604  mov      w4, #0x10
0x0003c608  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0003c60c  mov      x27, x0
0x0003c610  cbz      x0, #0x3c6c0
0x0003c614  str      x24, [sp]
0x0003c618  stp      w20, w19, [sp, #8]
0x0003c61c  ldr      x8, [sp, #0x40]
0x0003c620  ldr      x19, [x8]   ; @SEL "whatsNewNavigationController"
0x0003c624  adrp     x20, #0x8e000
0x0003c628  mov      x24, #0
0x0003c62c  ldr      x8, [sp, #0x40]
0x0003c630  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0003c634  cmp      x8, x19
0x0003c638  b.eq     #0x3c644
0x0003c63c  mov      x0, x26
0x0003c640  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0003c644  ldr      x8, [sp, #0x38]
0x0003c648  ldr      x2, [x8, x24, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0003c64c  ldr      x0, [x20, #0xa78]   ; @CLASS UIImage
0x0003c650  mov      x3, x25
0x0003c654  bl       #0x5d840   ; CALL objc_msgSend$systemImageNamed:withConfiguration:
0x0003c658  mov      x29, x29
0x0003c65c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c660  cbnz     x0, #0x3c698
0x0003c664  add      x24, x24, #1
0x0003c668  cmp      x27, x24
0x0003c66c  b.ne     #0x3c62c
0x0003c670  add      x2, sp, #0x30
0x0003c674  add      x3, sp, #0x80
0x0003c678  mov      x0, x26
0x0003c67c  mov      w4, #0x10
0x0003c680  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0003c684  mov      x27, x0
0x0003c688  cbnz     x0, #0x3c628
0x0003c68c  b        #0x3c6b8
0x0003c690  mov      x27, #0
0x0003c694  b        #0x3c6d0
0x0003c698  mov      x28, x0
0x0003c69c  mov      w2, #2
0x0003c6a0  bl       #0x581e0   ; CALL objc_msgSend$imageWithRenderingMode:
0x0003c6a4  mov      x29, x29
0x0003c6a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c6ac  mov      x27, x0
0x0003c6b0  mov      x0, x28
0x0003c6b4  bl       #0x55d78   ; CALL _objc_release
0x0003c6b8  ldp      w20, w19, [sp, #8]
0x0003c6bc  ldr      x24, [sp]
0x0003c6c0  mov      x0, x26
0x0003c6c4  bl       #0x55d78   ; CALL _objc_release
0x0003c6c8  mov      x0, x25
0x0003c6cc  bl       #0x55d78   ; CALL _objc_release
0x0003c6d0  mov      x0, x21
0x0003c6d4  bl       #0x57e40   ; CALL objc_msgSend$glyph
0x0003c6d8  mov      x29, x29
0x0003c6dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c6e0  mov      x25, x0
0x0003c6e4  mov      x2, x27
0x0003c6e8  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x0003c6ec  mov      x0, x25
0x0003c6f0  bl       #0x55d78   ; CALL _objc_release
0x0003c6f4  mov      x0, x27
0x0003c6f8  bl       #0x55d78   ; CALL _objc_release
0x0003c6fc  mov      x0, x23
0x0003c700  bl       #0x3c7f0
0x0003c704  mov      x29, x29
0x0003c708  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c70c  mov      x23, x0
0x0003c710  bl       #0x17e20   ; CALL _L
0x0003c714  mov      x29, x29
0x0003c718  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c71c  mov      x25, x0
0x0003c720  mov      x0, x21
0x0003c724  bl       #0x5db40   ; CALL objc_msgSend$title
0x0003c728  mov      x29, x29
0x0003c72c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c730  mov      x26, x0
0x0003c734  mov      x2, x25
0x0003c738  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0003c73c  mov      x0, x26
0x0003c740  bl       #0x55d78   ; CALL _objc_release
0x0003c744  mov      x0, x25
0x0003c748  bl       #0x55d78   ; CALL _objc_release
0x0003c74c  mov      x0, x23
0x0003c750  bl       #0x55d78   ; CALL _objc_release
0x0003c754  mov      x0, x21
0x0003c758  bl       #0x5db40   ; CALL objc_msgSend$title
0x0003c75c  mov      x29, x29
0x0003c760  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c764  mov      x23, x0
0x0003c768  bl       #0x5d980   ; CALL objc_msgSend$text
0x0003c76c  mov      x29, x29
0x0003c770  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c774  mov      x25, x0
0x0003c778  mov      x0, x21
0x0003c77c  mov      x2, x25
0x0003c780  bl       #0x5a240   ; CALL objc_msgSend$setAccessibilityLabel:
0x0003c784  mov      x0, x25
0x0003c788  bl       #0x55d78   ; CALL _objc_release
0x0003c78c  mov      x0, x23
0x0003c790  bl       #0x55d78   ; CALL _objc_release
0x0003c794  mov      x0, x21
0x0003c798  mov      x2, x20
0x0003c79c  mov      x3, x19
0x0003c7a0  bl       #0x5a860   ; CALL objc_msgSend$setChosen:dark:
0x0003c7a4  mov      x0, x24
0x0003c7a8  bl       #0x55d78   ; CALL _objc_release
0x0003c7ac  mov      x0, x22
0x0003c7b0  bl       #0x55d78   ; CALL _objc_release
0x0003c7b4  ldur     x8, [x29, #-0x60]
0x0003c7b8  adrp     x9, #0x74000
0x0003c7bc  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0003c7c0  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0003c7c4  cmp      x9, x8
0x0003c7c8  b.ne     #0x3c7ec
0x0003c7cc  ldp      x29, x30, [sp, #0x160]
0x0003c7d0  ldp      x20, x19, [sp, #0x150]
0x0003c7d4  ldp      x22, x21, [sp, #0x140]
0x0003c7d8  ldp      x24, x23, [sp, #0x130]
0x0003c7dc  ldp      x26, x25, [sp, #0x120]
0x0003c7e0  ldp      x28, x27, [sp, #0x110]
0x0003c7e4  add      sp, sp, #0x170
0x0003c7e8  ret      
0x0003c7ec  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0003c7f0  stp      x20, x19, [sp, #-0x20]!
0x0003c7f4  stp      x29, x30, [sp, #0x10]
0x0003c7f8  add      x29, sp, #0x10
0x0003c7fc  tbnz     x0, #0x3f, #0x3c81c
0x0003c800  mov      x19, x0
0x0003c804  adrp     x0, #0x7f000
0x0003c808  add      x0, x0, #0xdc8
0x0003c80c  bl       #0x573c0   ; CALL objc_msgSend$count
0x0003c810  cmp      x19, x0
0x0003c814  csel     x2, x19, xzr, lt
0x0003c818  b        #0x3c820
0x0003c81c  mov      x2, #0
0x0003c820  adrp     x0, #0x7f000
0x0003c824  add      x0, x0, #0xdc8
0x0003c828  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0003c82c  mov      x29, x29
0x0003c830  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c834  ldp      x29, x30, [sp, #0x10]
0x0003c838  ldp      x20, x19, [sp], #0x20
0x0003c83c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCSSStyleTileCell setChosen:dark:]  va=0x3c840 size=1380 types=v24@0:8B16B20
0x0003c840  sub      sp, sp, #0xf0
0x0003c844  stp      d11, d10, [sp, #0x80]
0x0003c848  stp      d9, d8, [sp, #0x90]
0x0003c84c  stp      x26, x25, [sp, #0xa0]
0x0003c850  stp      x24, x23, [sp, #0xb0]
0x0003c854  stp      x22, x21, [sp, #0xc0]
0x0003c858  stp      x20, x19, [sp, #0xd0]
0x0003c85c  stp      x29, x30, [sp, #0xe0]
0x0003c860  add      x29, sp, #0xe0
0x0003c864  mov      x20, x2
0x0003c868  mov      x19, x0
0x0003c86c  adrp     x8, #0x74000
0x0003c870  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0003c874  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003c878  stur     x8, [x29, #-0x68]
0x0003c87c  adrp     x25, #0x8e000
0x0003c880  ldr      x0, [x25, #0xab8]   ; @CLASS CATransaction
0x0003c884  bl       #0x567a0   ; CALL objc_msgSend$begin
0x0003c888  ldr      x0, [x25, #0xab8]   ; @CLASS CATransaction
0x0003c88c  mov      w2, #1
0x0003c890  bl       #0x5ad00   ; CALL objc_msgSend$setDisableActions:
0x0003c894  cbz      w20, #0x3c904
0x0003c898  adrp     x0, #0x78000
0x0003c89c  add      x0, x0, #0xf28   ; STR "#8B7CFF"
0x0003c8a0  bl       #0x18080   ; CALL _OMCColorFromHex
0x0003c8a4  mov      x29, x29
0x0003c8a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c8ac  mov      x21, x0
0x0003c8b0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0003c8b4  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0003c8b8  str      x0, [sp, #0x68]
0x0003c8bc  adrp     x0, #0x78000
0x0003c8c0  add      x0, x0, #0xf08   ; STR "#5AB8FF"
0x0003c8c4  bl       #0x18080   ; CALL _OMCColorFromHex
0x0003c8c8  mov      x29, x29
0x0003c8cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c8d0  mov      x22, x0
0x0003c8d4  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0003c8d8  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0003c8dc  str      x0, [sp, #0x70]
0x0003c8e0  adrp     x8, #0x8e000
0x0003c8e4  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0003c8e8  add      x2, sp, #0x68
0x0003c8ec  mov      w3, #2
0x0003c8f0  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0003c8f4  mov      x29, x29
0x0003c8f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c8fc  mov      x23, x0
0x0003c900  b        #0x3c918
0x0003c904  mov      x0, x19
0x0003c908  bl       #0x5d640   ; CALL objc_msgSend$styleColors
0x0003c90c  mov      x29, x29
0x0003c910  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c914  mov      x23, x0
0x0003c918  mov      x0, x19
0x0003c91c  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0003c920  mov      x29, x29
0x0003c924  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c928  mov      x24, x0
0x0003c92c  mov      x2, x23
0x0003c930  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0003c934  mov      x0, x24
0x0003c938  bl       #0x55d78   ; CALL _objc_release
0x0003c93c  cbz      w20, #0x3c954
0x0003c940  mov      x0, x23
0x0003c944  bl       #0x55d78   ; CALL _objc_release
0x0003c948  mov      x0, x22
0x0003c94c  bl       #0x55d78   ; CALL _objc_release
0x0003c950  mov      x23, x21
0x0003c954  mov      x0, x23
0x0003c958  bl       #0x55d78   ; CALL _objc_release
0x0003c95c  ldr      x0, [x25, #0xab8]   ; @CLASS CATransaction
0x0003c960  bl       #0x56f40   ; CALL objc_msgSend$commit
0x0003c964  adrp     x25, #0x8e000
0x0003c968  ldr      x0, [x25, #0x910]   ; @CLASS UIColor
0x0003c96c  bl       #0x56de0   ; CALL objc_msgSend$clearColor
0x0003c970  mov      x29, x29
0x0003c974  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c978  mov      x21, x0
0x0003c97c  mov      x0, x19
0x0003c980  bl       #0x56c00   ; CALL objc_msgSend$card
0x0003c984  mov      x29, x29
0x0003c988  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c98c  mov      x22, x0
0x0003c990  mov      x2, x21
0x0003c994  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0003c998  mov      x0, x22
0x0003c99c  bl       #0x55d78   ; CALL _objc_release
0x0003c9a0  mov      x0, x21
0x0003c9a4  bl       #0x55d78   ; CALL _objc_release
0x0003c9a8  ldr      x0, [x25, #0x910]   ; @CLASS UIColor
0x0003c9ac  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0003c9b0  mov      x29, x29
0x0003c9b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c9b8  mov      x21, x0
0x0003c9bc  mov      x0, x19
0x0003c9c0  bl       #0x57e40   ; CALL objc_msgSend$glyph
0x0003c9c4  mov      x29, x29
0x0003c9c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003c9cc  mov      x22, x0
0x0003c9d0  mov      x2, x21
0x0003c9d4  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x0003c9d8  mov      x0, x22
0x0003c9dc  bl       #0x55d78   ; CALL _objc_release
0x0003c9e0  mov      x0, x21
0x0003c9e4  bl       #0x55d78   ; CALL _objc_release
0x0003c9e8  cbz      w20, #0x3ca1c
0x0003c9ec  adrp     x0, #0x7c000
0x0003c9f0  add      x0, x0, #0x248   ; STR "#6E78FF"
0x0003c9f4  bl       #0x18080   ; CALL _OMCColorFromHex
0x0003c9f8  mov      x29, x29
0x0003c9fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ca00  mov      x21, x0
0x0003ca04  fmov     d9, #5.00000000
0x0003ca08  fmov     d10, #12.00000000
0x0003ca0c  fmov     s11, #0.50000000
0x0003ca10  adrp     x8, #0x65000
0x0003ca14  ldr      d8, [x8, #0x6e8]
0x0003ca18  b        #0x3ca64
0x0003ca1c  ldr      x0, [x25, #0x910]   ; @CLASS UIColor
0x0003ca20  adrp     x8, #0x65000
0x0003ca24  ldr      d0, [x8, #0x648]
0x0003ca28  adrp     x8, #0x65000
0x0003ca2c  ldr      d1, [x8, #0x650]
0x0003ca30  adrp     x8, #0x65000
0x0003ca34  ldr      d2, [x8, #0x658]
0x0003ca38  fmov     d3, #1.00000000
0x0003ca3c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0003ca40  mov      x29, x29
0x0003ca44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ca48  mov      x21, x0
0x0003ca4c  fmov     d9, #2.00000000
0x0003ca50  fmov     d10, #5.00000000
0x0003ca54  adrp     x8, #0x65000
0x0003ca58  ldr      d8, [x8, #0x608]
0x0003ca5c  adrp     x8, #0x65000
0x0003ca60  ldr      s11, [x8, #0xeb0]
0x0003ca64  mov      x0, x21
0x0003ca68  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0003ca6c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0003ca70  mov      x22, x0
0x0003ca74  mov      x0, x19
0x0003ca78  bl       #0x56c00   ; CALL objc_msgSend$card
0x0003ca7c  mov      x29, x29
0x0003ca80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ca84  mov      x23, x0
0x0003ca88  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003ca8c  mov      x29, x29
0x0003ca90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ca94  mov      x24, x0
0x0003ca98  mov      x2, x22
0x0003ca9c  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x0003caa0  mov      x0, x24
0x0003caa4  bl       #0x55d78   ; CALL _objc_release
0x0003caa8  mov      x0, x23
0x0003caac  bl       #0x55d78   ; CALL _objc_release
0x0003cab0  mov      x0, x21
0x0003cab4  bl       #0x55d78   ; CALL _objc_release
0x0003cab8  mov      x0, x19
0x0003cabc  bl       #0x56c00   ; CALL objc_msgSend$card
0x0003cac0  mov      x29, x29
0x0003cac4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003cac8  mov      x21, x0
0x0003cacc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003cad0  mov      x29, x29
0x0003cad4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003cad8  mov      x22, x0
0x0003cadc  mov      v0.16b, v11.16b
0x0003cae0  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x0003cae4  mov      x0, x22
0x0003cae8  bl       #0x55d78   ; CALL _objc_release
0x0003caec  mov      x0, x21
0x0003caf0  bl       #0x55d78   ; CALL _objc_release
0x0003caf4  mov      x0, x19
0x0003caf8  bl       #0x56c00   ; CALL objc_msgSend$card
0x0003cafc  mov      x29, x29
0x0003cb00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003cb04  mov      x21, x0
0x0003cb08  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003cb0c  mov      x29, x29
0x0003cb10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003cb14  mov      x22, x0
0x0003cb18  mov      v0.16b, v10.16b
0x0003cb1c  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x0003cb20  mov      x0, x22
0x0003cb24  bl       #0x55d78   ; CALL _objc_release
0x0003cb28  mov      x0, x21
0x0003cb2c  bl       #0x55d78   ; CALL _objc_release
0x0003cb30  mov      x0, x19
0x0003cb34  bl       #0x56c00   ; CALL objc_msgSend$card
0x0003cb38  mov      x29, x29
0x0003cb3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003cb40  mov      x21, x0
0x0003cb44  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003cb48  mov      x29, x29
0x0003cb4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003cb50  mov      x22, x0
0x0003cb54  fmov     d0, xzr
0x0003cb58  mov      v1.16b, v9.16b
0x0003cb5c  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x0003cb60  mov      x0, x22
0x0003cb64  bl       #0x55d78   ; CALL _objc_release
0x0003cb68  mov      x0, x21
0x0003cb6c  bl       #0x55d78   ; CALL _objc_release
0x0003cb70  mov      x0, x19
0x0003cb74  bl       #0x56c00   ; CALL objc_msgSend$card
0x0003cb78  mov      x29, x29
0x0003cb7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003cb80  mov      x21, x0
0x0003cb84  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003cb88  mov      x29, x29
0x0003cb8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003cb90  mov      x22, x0
0x0003cb94  fmov     d0, #0.50000000
0x0003cb98  bl       #0x5a740   ; CALL objc_msgSend$setBorderWidth:
0x0003cb9c  mov      x0, x22
0x0003cba0  bl       #0x55d78   ; CALL _objc_release
0x0003cba4  mov      x0, x21
0x0003cba8  bl       #0x55d78   ; CALL _objc_release
0x0003cbac  ldr      x0, [x25, #0x910]   ; @CLASS UIColor
0x0003cbb0  fmov     d0, #1.00000000
0x0003cbb4  mov      v1.16b, v8.16b
0x0003cbb8  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0003cbbc  mov      x29, x29
0x0003cbc0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003cbc4  mov      x21, x0
0x0003cbc8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0003cbcc  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0003cbd0  mov      x22, x0
0x0003cbd4  mov      x0, x19
0x0003cbd8  bl       #0x56c00   ; CALL objc_msgSend$card
0x0003cbdc  mov      x29, x29
0x0003cbe0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003cbe4  mov      x23, x0
0x0003cbe8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003cbec  mov      x29, x29
0x0003cbf0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003cbf4  mov      x24, x0
0x0003cbf8  mov      x2, x22
0x0003cbfc  bl       #0x5a700   ; CALL objc_msgSend$setBorderColor:
0x0003cc00  mov      x0, x24
0x0003cc04  bl       #0x55d78   ; CALL _objc_release
0x0003cc08  mov      x0, x23
0x0003cc0c  bl       #0x55d78   ; CALL _objc_release
0x0003cc10  mov      x0, x21
0x0003cc14  bl       #0x55d78   ; CALL _objc_release
0x0003cc18  cbz      w20, #0x3cc34
0x0003cc1c  adrp     x8, #0x65000
0x0003cc20  ldr      d0, [x8, #0xe88]
0x0003cc24  add      x8, sp, #0x30
0x0003cc28  mov      v1.16b, v0.16b
0x0003cc2c  bl       #0x5588c   ; CALL _CGAffineTransformMakeScale
0x0003cc30  b        #0x3cc4c
0x0003cc34  adrp     x8, #0x74000
0x0003cc38  ldr      x8, [x8, #0x498]   ; @GOT _CGAffineTransformIdentity
0x0003cc3c  ldp      q0, q1, [x8]
0x0003cc40  stp      q0, q1, [sp, #0x30]
0x0003cc44  ldr      q0, [x8, #0x20]   ; @GOT _objc_autoreleasePoolPop
0x0003cc48  str      q0, [sp, #0x50]
0x0003cc4c  mov      x0, x19
0x0003cc50  bl       #0x56c00   ; CALL objc_msgSend$card
0x0003cc54  mov      x29, x29
0x0003cc58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003cc5c  mov      x21, x0
0x0003cc60  ldp      q0, q1, [sp, #0x30]
0x0003cc64  stp      q0, q1, [sp]
0x0003cc68  ldr      q0, [sp, #0x50]
0x0003cc6c  str      q0, [sp, #0x20]
0x0003cc70  mov      x2, sp
0x0003cc74  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x0003cc78  mov      x0, x21
0x0003cc7c  bl       #0x55d78   ; CALL _objc_release
0x0003cc80  adrp     x8, #0x8e000
0x0003cc84  adrp     x9, #0x74000
0x0003cc88  ldr      x9, [x9, #0x260]   ; @GOT _UIFontWeightSemibold
0x0003cc8c  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x0003cc90  adrp     x8, #0x74000
0x0003cc94  ldr      x8, [x8, #0x250]   ; @GOT _UIFontWeightMedium
0x0003cc98  cmp      w20, #0
0x0003cc9c  csel     x8, x9, x8, ne
0x0003cca0  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x0003cca4  fmov     d0, #11.00000000
0x0003cca8  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x0003ccac  mov      x29, x29
0x0003ccb0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ccb4  mov      x21, x0
0x0003ccb8  mov      x0, x19
0x0003ccbc  bl       #0x5db40   ; CALL objc_msgSend$title
0x0003ccc0  mov      x29, x29
0x0003ccc4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ccc8  mov      x22, x0
0x0003cccc  mov      x2, x21
0x0003ccd0  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x0003ccd4  mov      x0, x22
0x0003ccd8  bl       #0x55d78   ; CALL _objc_release
0x0003ccdc  mov      x0, x21
0x0003cce0  bl       #0x55d78   ; CALL _objc_release
0x0003cce4  ldr      x0, [x25, #0x910]   ; @CLASS UIColor
0x0003cce8  cbz      w20, #0x3ccfc
0x0003ccec  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x0003ccf0  mov      x29, x29
0x0003ccf4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ccf8  b        #0x3cd08
0x0003ccfc  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x0003cd00  mov      x29, x29
0x0003cd04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003cd08  mov      x21, x0
0x0003cd0c  mov      x0, x19
0x0003cd10  bl       #0x5db40   ; CALL objc_msgSend$title
0x0003cd14  mov      x29, x29
0x0003cd18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003cd1c  mov      x22, x0
0x0003cd20  mov      x2, x21
0x0003cd24  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0003cd28  mov      x0, x22
0x0003cd2c  bl       #0x55d78   ; CALL _objc_release
0x0003cd30  mov      x0, x21
0x0003cd34  bl       #0x55d78   ; CALL _objc_release
0x0003cd38  adrp     x8, #0x74000
0x0003cd3c  ldr      x8, [x8, #0x1f0]   ; @GOT _UIAccessibilityTraitButton
0x0003cd40  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003cd44  adrp     x9, #0x74000
0x0003cd48  ldr      x9, [x9, #0x1f8]   ; @GOT _UIAccessibilityTraitSelected
0x0003cd4c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0003cd50  cmp      w20, #0
0x0003cd54  csel     x9, x9, xzr, ne
0x0003cd58  orr      x2, x9, x8
0x0003cd5c  mov      x0, x19
0x0003cd60  bl       #0x5a260   ; CALL objc_msgSend$setAccessibilityTraits:
0x0003cd64  ldur     x8, [x29, #-0x68]
0x0003cd68  adrp     x9, #0x74000
0x0003cd6c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0003cd70  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0003cd74  cmp      x9, x8
0x0003cd78  b.ne     #0x3cda0
0x0003cd7c  ldp      x29, x30, [sp, #0xe0]
0x0003cd80  ldp      x20, x19, [sp, #0xd0]
0x0003cd84  ldp      x22, x21, [sp, #0xc0]
0x0003cd88  ldp      x24, x23, [sp, #0xb0]
0x0003cd8c  ldp      x26, x25, [sp, #0xa0]
0x0003cd90  ldp      d9, d8, [sp, #0x90]
0x0003cd94  ldp      d11, d10, [sp, #0x80]
0x0003cd98  add      sp, sp, #0xf0
0x0003cd9c  ret      
0x0003cda0  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCSSStyleTileCell card]  va=0x3cda4 size=16 types=@16@0:8
0x0003cda4  adrp     x8, #0x8e000
0x0003cda8  ldrsw    x8, [x8, #0xf64]
0x0003cdac  ldr      x0, [x0, x8]
0x0003cdb0  ret      

=== -[OMCSSStyleTileCell setCard:]  va=0x3cdb4 size=64 types=v24@0:8@16
0x0003cdb4  stp      x22, x21, [sp, #-0x30]!
0x0003cdb8  stp      x20, x19, [sp, #0x10]
0x0003cdbc  stp      x29, x30, [sp, #0x20]
0x0003cdc0  add      x29, sp, #0x20
0x0003cdc4  mov      x19, x2
0x0003cdc8  mov      x20, x0
0x0003cdcc  adrp     x8, #0x8e000
0x0003cdd0  ldrsw    x21, [x8, #0xf64]
0x0003cdd4  mov      x0, x2
0x0003cdd8  bl       #0x55d84   ; CALL _objc_retain
0x0003cddc  ldr      x0, [x20, x21]
0x0003cde0  str      x19, [x20, x21]
0x0003cde4  ldp      x29, x30, [sp, #0x20]
0x0003cde8  ldp      x20, x19, [sp, #0x10]
0x0003cdec  ldp      x22, x21, [sp], #0x30
0x0003cdf0  b        #0x55d78   ; CALL _objc_release

=== -[OMCSSStyleTileCell fill]  va=0x3cdf4 size=16 types=@16@0:8
0x0003cdf4  adrp     x8, #0x8e000
0x0003cdf8  ldrsw    x8, [x8, #0xf68]
0x0003cdfc  ldr      x0, [x0, x8]
0x0003ce00  ret      

=== -[OMCSSStyleTileCell setFill:]  va=0x3ce04 size=64 types=v24@0:8@16
0x0003ce04  stp      x22, x21, [sp, #-0x30]!
0x0003ce08  stp      x20, x19, [sp, #0x10]
0x0003ce0c  stp      x29, x30, [sp, #0x20]
0x0003ce10  add      x29, sp, #0x20
0x0003ce14  mov      x19, x2
0x0003ce18  mov      x20, x0
0x0003ce1c  adrp     x8, #0x8e000
0x0003ce20  ldrsw    x21, [x8, #0xf68]
0x0003ce24  mov      x0, x2
0x0003ce28  bl       #0x55d84   ; CALL _objc_retain
0x0003ce2c  ldr      x0, [x20, x21]
0x0003ce30  str      x19, [x20, x21]
0x0003ce34  ldp      x29, x30, [sp, #0x20]
0x0003ce38  ldp      x20, x19, [sp, #0x10]
0x0003ce3c  ldp      x22, x21, [sp], #0x30
0x0003ce40  b        #0x55d78   ; CALL _objc_release

=== -[OMCSSStyleTileCell styleColors]  va=0x3ce44 size=16 types=@16@0:8
0x0003ce44  adrp     x8, #0x8e000
0x0003ce48  ldrsw    x8, [x8, #0xf6c]
0x0003ce4c  ldr      x0, [x0, x8]
0x0003ce50  ret      

=== -[OMCSSStyleTileCell setStyleColors:]  va=0x3ce54 size=12 types=v24@0:8@16
0x0003ce54  adrp     x8, #0x8e000
0x0003ce58  ldrsw    x3, [x8, #0xf6c]
0x0003ce5c  b        #0x55dc0   ; CALL _objc_setProperty_nonatomic_copy

=== -[OMCSSStyleTileCell glyph]  va=0x3ce60 size=16 types=@16@0:8
0x0003ce60  adrp     x8, #0x8e000
0x0003ce64  ldrsw    x8, [x8, #0xf70]
0x0003ce68  ldr      x0, [x0, x8]
0x0003ce6c  ret      

=== -[OMCSSStyleTileCell setGlyph:]  va=0x3ce70 size=64 types=v24@0:8@16
0x0003ce70  stp      x22, x21, [sp, #-0x30]!
0x0003ce74  stp      x20, x19, [sp, #0x10]
0x0003ce78  stp      x29, x30, [sp, #0x20]
0x0003ce7c  add      x29, sp, #0x20
0x0003ce80  mov      x19, x2
0x0003ce84  mov      x20, x0
0x0003ce88  adrp     x8, #0x8e000
0x0003ce8c  ldrsw    x21, [x8, #0xf70]
0x0003ce90  mov      x0, x2
0x0003ce94  bl       #0x55d84   ; CALL _objc_retain
0x0003ce98  ldr      x0, [x20, x21]
0x0003ce9c  str      x19, [x20, x21]
0x0003cea0  ldp      x29, x30, [sp, #0x20]
0x0003cea4  ldp      x20, x19, [sp, #0x10]
0x0003cea8  ldp      x22, x21, [sp], #0x30
0x0003ceac  b        #0x55d78   ; CALL _objc_release

=== -[OMCSSStyleTileCell title]  va=0x3ceb0 size=16 types=@16@0:8
0x0003ceb0  adrp     x8, #0x8e000
0x0003ceb4  ldrsw    x8, [x8, #0xf74]
0x0003ceb8  ldr      x0, [x0, x8]
0x0003cebc  ret      

=== -[OMCSSStyleTileCell setTitle:]  va=0x3cec0 size=64 types=v24@0:8@16
0x0003cec0  stp      x22, x21, [sp, #-0x30]!
0x0003cec4  stp      x20, x19, [sp, #0x10]
0x0003cec8  stp      x29, x30, [sp, #0x20]
0x0003cecc  add      x29, sp, #0x20
0x0003ced0  mov      x19, x2
0x0003ced4  mov      x20, x0
0x0003ced8  adrp     x8, #0x8e000
0x0003cedc  ldrsw    x21, [x8, #0xf74]
0x0003cee0  mov      x0, x2
0x0003cee4  bl       #0x55d84   ; CALL _objc_retain
0x0003cee8  ldr      x0, [x20, x21]
0x0003ceec  str      x19, [x20, x21]
0x0003cef0  ldp      x29, x30, [sp, #0x20]
0x0003cef4  ldp      x20, x19, [sp, #0x10]
0x0003cef8  ldp      x22, x21, [sp], #0x30
0x0003cefc  b        #0x55d78   ; CALL _objc_release

=== -[OMCSSStyleTileCell .cxx_destruct]  va=0x3cf00 size=124 types=v16@0:8
0x0003cf00  stp      x20, x19, [sp, #-0x20]!
0x0003cf04  stp      x29, x30, [sp, #0x10]
0x0003cf08  add      x29, sp, #0x10
0x0003cf0c  mov      x19, x0
0x0003cf10  adrp     x8, #0x8e000
0x0003cf14  ldrsw    x8, [x8, #0xf74]
0x0003cf18  add      x0, x0, x8
0x0003cf1c  mov      x1, #0
0x0003cf20  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0003cf24  adrp     x8, #0x8e000
0x0003cf28  ldrsw    x8, [x8, #0xf70]
0x0003cf2c  add      x0, x19, x8
0x0003cf30  mov      x1, #0
0x0003cf34  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0003cf38  adrp     x8, #0x8e000
0x0003cf3c  ldrsw    x8, [x8, #0xf6c]
0x0003cf40  add      x0, x19, x8
0x0003cf44  mov      x1, #0
0x0003cf48  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0003cf4c  adrp     x8, #0x8e000
0x0003cf50  ldrsw    x8, [x8, #0xf68]
0x0003cf54  add      x0, x19, x8
0x0003cf58  mov      x1, #0
0x0003cf5c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0003cf60  adrp     x8, #0x8e000
0x0003cf64  ldrsw    x8, [x8, #0xf64]
0x0003cf68  add      x0, x19, x8
0x0003cf6c  mov      x1, #0
0x0003cf70  ldp      x29, x30, [sp, #0x10]
0x0003cf74  ldp      x20, x19, [sp], #0x20
0x0003cf78  b        #0x55dcc   ; CALL _objc_storeStrong
