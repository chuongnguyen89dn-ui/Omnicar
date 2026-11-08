=== -[SPPGlassView initWithFrame:]  va=0x2c6fc size=892 types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
0x0002c6fc  sub      sp, sp, #0x90
0x0002c700  stp      d9, d8, [sp, #0x30]
0x0002c704  stp      x26, x25, [sp, #0x40]
0x0002c708  stp      x24, x23, [sp, #0x50]
0x0002c70c  stp      x22, x21, [sp, #0x60]
0x0002c710  stp      x20, x19, [sp, #0x70]
0x0002c714  stp      x29, x30, [sp, #0x80]
0x0002c718  add      x29, sp, #0x80
0x0002c71c  adrp     x8, #0x74000
0x0002c720  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0002c724  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002c728  str      x8, [sp, #0x28]
0x0002c72c  adrp     x8, #0x8e000
0x0002c730  ldr      x8, [x8, #0xd68]   ; @SUPER SPPGlassView
0x0002c734  stp      x0, x8, [sp, #8]
0x0002c738  adrp     x8, #0x8c000
0x0002c73c  ldr      x1, [x8, #0x8c8]   ; @SEL "initWithFrame:"
0x0002c740  add      x0, sp, #8
0x0002c744  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0002c748  mov      x19, x0
0x0002c74c  cbz      x0, #0x2ca38
0x0002c750  mov      x0, x19
0x0002c754  mov      w2, #0
0x0002c758  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x0002c75c  adrp     x21, #0x8e000
0x0002c760  ldr      x0, [x21, #0xab0]   ; @CLASS CAGradientLayer
0x0002c764  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002c768  mov      x29, x29
0x0002c76c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c770  adrp     x8, #0x8e000
0x0002c774  ldrsw    x24, [x8, #0xebc]
0x0002c778  ldr      x8, [x19, x24]
0x0002c77c  str      x0, [x19, x24]
0x0002c780  mov      x0, x8
0x0002c784  bl       #0x55d78   ; CALL _objc_release
0x0002c788  ldr      x0, [x19, x24]
0x0002c78c  mov      w2, #1
0x0002c790  bl       #0x5b520   ; CALL objc_msgSend$setMasksToBounds:
0x0002c794  ldr      x0, [x19, x24]
0x0002c798  fmov     d0, #1.00000000
0x0002c79c  bl       #0x5a740   ; CALL objc_msgSend$setBorderWidth:
0x0002c7a0  adrp     x23, #0x8e000
0x0002c7a4  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0002c7a8  adrp     x8, #0x65000
0x0002c7ac  ldr      d1, [x8, #0x6d0]
0x0002c7b0  fmov     d0, #1.00000000
0x0002c7b4  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0002c7b8  mov      x29, x29
0x0002c7bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c7c0  mov      x20, x0
0x0002c7c4  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002c7c8  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002c7cc  mov      x2, x0
0x0002c7d0  ldr      x0, [x19, x24]
0x0002c7d4  bl       #0x5a700   ; CALL objc_msgSend$setBorderColor:
0x0002c7d8  mov      x0, x20
0x0002c7dc  bl       #0x55d78   ; CALL _objc_release
0x0002c7e0  adrp     x8, #0x74000
0x0002c7e4  ldr      x8, [x8, #0x648]   ; @GOT _kCACornerCurveContinuous
0x0002c7e8  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0002c7ec  ldr      x0, [x19, x24]
0x0002c7f0  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x0002c7f4  mov      x0, x19
0x0002c7f8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002c7fc  mov      x29, x29
0x0002c800  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c804  mov      x20, x0
0x0002c808  ldr      x2, [x19, x24]
0x0002c80c  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0002c810  mov      x0, x20
0x0002c814  bl       #0x55d78   ; CALL _objc_release
0x0002c818  ldr      x0, [x21, #0xab0]   ; @CLASS CAGradientLayer
0x0002c81c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002c820  mov      x29, x29
0x0002c824  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c828  adrp     x8, #0x8e000
0x0002c82c  ldrsw    x25, [x8, #0xec0]
0x0002c830  ldr      x8, [x19, x25]
0x0002c834  str      x0, [x19, x25]
0x0002c838  mov      x0, x8
0x0002c83c  bl       #0x55d78   ; CALL _objc_release
0x0002c840  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0002c844  fmov     d0, #1.00000000
0x0002c848  fmov     d1, #0.50000000
0x0002c84c  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0002c850  mov      x29, x29
0x0002c854  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c858  mov      x20, x0
0x0002c85c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002c860  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002c864  str      x0, [sp, #0x18]
0x0002c868  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0002c86c  fmov     d0, #1.00000000
0x0002c870  fmov     d1, xzr
0x0002c874  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0002c878  mov      x29, x29
0x0002c87c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c880  mov      x21, x0
0x0002c884  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002c888  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002c88c  str      x0, [sp, #0x20]
0x0002c890  adrp     x8, #0x8e000
0x0002c894  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0002c898  add      x2, sp, #0x18
0x0002c89c  mov      w3, #2
0x0002c8a0  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0002c8a4  mov      x29, x29
0x0002c8a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c8ac  mov      x22, x0
0x0002c8b0  ldr      x0, [x19, x25]
0x0002c8b4  mov      x2, x22
0x0002c8b8  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0002c8bc  mov      x0, x22
0x0002c8c0  bl       #0x55d78   ; CALL _objc_release
0x0002c8c4  mov      x0, x21
0x0002c8c8  bl       #0x55d78   ; CALL _objc_release
0x0002c8cc  mov      x0, x20
0x0002c8d0  bl       #0x55d78   ; CALL _objc_release
0x0002c8d4  ldr      x0, [x19, x24]
0x0002c8d8  ldr      x2, [x19, x25]
0x0002c8dc  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0002c8e0  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0002c8e4  adrp     x8, #0x65000
0x0002c8e8  ldr      d8, [x8, #0x708]
0x0002c8ec  fmov     d0, #1.00000000
0x0002c8f0  fmov     d1, #1.00000000
0x0002c8f4  fmov     d2, #1.00000000
0x0002c8f8  mov      v3.16b, v8.16b
0x0002c8fc  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002c900  mov      x29, x29
0x0002c904  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c908  mov      x20, x0
0x0002c90c  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0002c910  adrp     x8, #0x65000
0x0002c914  ldr      d0, [x8, #0xa60]
0x0002c918  adrp     x8, #0x65000
0x0002c91c  ldr      d1, [x8, #0xa68]
0x0002c920  adrp     x8, #0x65000
0x0002c924  ldr      d2, [x8, #0xa70]
0x0002c928  mov      v3.16b, v8.16b
0x0002c92c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002c930  mov      x29, x29
0x0002c934  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c938  mov      x21, x0
0x0002c93c  mov      x0, x19
0x0002c940  mov      x2, x20
0x0002c944  mov      x3, x21
0x0002c948  bl       #0x5c680   ; CALL objc_msgSend$setTop:bottom:
0x0002c94c  mov      x0, x21
0x0002c950  bl       #0x55d78   ; CALL _objc_release
0x0002c954  mov      x0, x20
0x0002c958  bl       #0x55d78   ; CALL _objc_release
0x0002c95c  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0002c960  adrp     x8, #0x65000
0x0002c964  ldr      d0, [x8, #0x648]
0x0002c968  adrp     x8, #0x65000
0x0002c96c  ldr      d1, [x8, #0x650]
0x0002c970  adrp     x8, #0x65000
0x0002c974  ldr      d2, [x8, #0x658]
0x0002c978  fmov     d3, #1.00000000
0x0002c97c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002c980  mov      x29, x29
0x0002c984  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c988  mov      x20, x0
0x0002c98c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002c990  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002c994  mov      x21, x0
0x0002c998  mov      x0, x19
0x0002c99c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002c9a0  mov      x29, x29
0x0002c9a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c9a8  mov      x22, x0
0x0002c9ac  mov      x2, x21
0x0002c9b0  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x0002c9b4  mov      x0, x22
0x0002c9b8  bl       #0x55d78   ; CALL _objc_release
0x0002c9bc  mov      x0, x20
0x0002c9c0  bl       #0x55d78   ; CALL _objc_release
0x0002c9c4  mov      x0, x19
0x0002c9c8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002c9cc  mov      x29, x29
0x0002c9d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c9d4  mov      x20, x0
0x0002c9d8  adrp     x8, #0x65000
0x0002c9dc  ldr      s0, [x8, #0xd00]
0x0002c9e0  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x0002c9e4  mov      x0, x20
0x0002c9e8  bl       #0x55d78   ; CALL _objc_release
0x0002c9ec  mov      x0, x19
0x0002c9f0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002c9f4  mov      x29, x29
0x0002c9f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c9fc  mov      x20, x0
0x0002ca00  fmov     d0, #10.00000000
0x0002ca04  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x0002ca08  mov      x0, x20
0x0002ca0c  bl       #0x55d78   ; CALL _objc_release
0x0002ca10  mov      x0, x19
0x0002ca14  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002ca18  mov      x29, x29
0x0002ca1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ca20  mov      x20, x0
0x0002ca24  fmov     d0, xzr
0x0002ca28  fmov     d1, #4.00000000
0x0002ca2c  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x0002ca30  mov      x0, x20
0x0002ca34  bl       #0x55d78   ; CALL _objc_release
0x0002ca38  ldr      x8, [sp, #0x28]
0x0002ca3c  adrp     x9, #0x74000
0x0002ca40  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0002ca44  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0002ca48  cmp      x9, x8
0x0002ca4c  b.ne     #0x2ca74
0x0002ca50  mov      x0, x19
0x0002ca54  ldp      x29, x30, [sp, #0x80]
0x0002ca58  ldp      x20, x19, [sp, #0x70]
0x0002ca5c  ldp      x22, x21, [sp, #0x60]
0x0002ca60  ldp      x24, x23, [sp, #0x50]
0x0002ca64  ldp      x26, x25, [sp, #0x40]
0x0002ca68  ldp      d9, d8, [sp, #0x30]
0x0002ca6c  add      sp, sp, #0x90
0x0002ca70  ret      
0x0002ca74  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[SPPGlassView setTop:bottom:]  va=0x2ca78 size=228 types=v32@0:8@16@24
0x0002ca78  sub      sp, sp, #0x50
0x0002ca7c  stp      x22, x21, [sp, #0x20]
0x0002ca80  stp      x20, x19, [sp, #0x30]
0x0002ca84  stp      x29, x30, [sp, #0x40]
0x0002ca88  add      x29, sp, #0x40
0x0002ca8c  mov      x19, x3
0x0002ca90  mov      x20, x2
0x0002ca94  mov      x21, x0
0x0002ca98  adrp     x8, #0x74000
0x0002ca9c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0002caa0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002caa4  str      x8, [sp, #0x18]
0x0002caa8  mov      x0, x2
0x0002caac  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002cab0  mov      x0, x19
0x0002cab4  bl       #0x55d84   ; CALL _objc_retain
0x0002cab8  mov      x0, x20
0x0002cabc  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002cac0  str      x0, [sp, #8]
0x0002cac4  mov      x0, x19
0x0002cac8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002cacc  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002cad0  mov      x20, x0
0x0002cad4  mov      x0, x19
0x0002cad8  bl       #0x55d78   ; CALL _objc_release
0x0002cadc  str      x20, [sp, #0x10]
0x0002cae0  adrp     x8, #0x8e000
0x0002cae4  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0002cae8  add      x2, sp, #8
0x0002caec  mov      w3, #2
0x0002caf0  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0002caf4  mov      x29, x29
0x0002caf8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002cafc  mov      x19, x0
0x0002cb00  mov      x0, x21
0x0002cb04  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0002cb08  mov      x29, x29
0x0002cb0c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002cb10  mov      x20, x0
0x0002cb14  mov      x2, x19
0x0002cb18  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0002cb1c  mov      x0, x20
0x0002cb20  bl       #0x55d78   ; CALL _objc_release
0x0002cb24  mov      x0, x19
0x0002cb28  bl       #0x55d78   ; CALL _objc_release
0x0002cb2c  ldr      x8, [sp, #0x18]
0x0002cb30  adrp     x9, #0x74000
0x0002cb34  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0002cb38  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0002cb3c  cmp      x9, x8
0x0002cb40  b.ne     #0x2cb58
0x0002cb44  ldp      x29, x30, [sp, #0x40]
0x0002cb48  ldp      x20, x19, [sp, #0x30]
0x0002cb4c  ldp      x22, x21, [sp, #0x20]
0x0002cb50  add      sp, sp, #0x50
0x0002cb54  ret      
0x0002cb58  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[SPPGlassView setCorner:]  va=0x2cb5c size=16 types=v24@0:8d16
0x0002cb5c  adrp     x8, #0x8e000
0x0002cb60  ldrsw    x8, [x8, #0xec4]
0x0002cb64  str      d0, [x0, x8]
0x0002cb68  b        #0x5b7a0   ; CALL objc_msgSend$setNeedsLayout

=== -[SPPGlassView layoutSubviews]  va=0x2cb6c size=456 types=v16@0:8
0x0002cb6c  sub      sp, sp, #0x60
0x0002cb70  stp      d11, d10, [sp, #0x10]
0x0002cb74  stp      d9, d8, [sp, #0x20]
0x0002cb78  stp      x22, x21, [sp, #0x30]
0x0002cb7c  stp      x20, x19, [sp, #0x40]
0x0002cb80  stp      x29, x30, [sp, #0x50]
0x0002cb84  add      x29, sp, #0x50
0x0002cb88  mov      x19, x0
0x0002cb8c  adrp     x8, #0x8e000
0x0002cb90  ldr      x8, [x8, #0xd68]   ; @SUPER SPPGlassView
0x0002cb94  stp      x0, x8, [sp]
0x0002cb98  adrp     x8, #0x8b000
0x0002cb9c  ldr      x1, [x8, #0xe28]   ; @SEL "layoutSubviews"
0x0002cba0  mov      x0, sp
0x0002cba4  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0002cba8  adrp     x21, #0x8e000
0x0002cbac  ldr      x0, [x21, #0xab8]   ; @CLASS CATransaction
0x0002cbb0  bl       #0x567a0   ; CALL objc_msgSend$begin
0x0002cbb4  ldr      x0, [x21, #0xab8]   ; @CLASS CATransaction
0x0002cbb8  mov      w2, #1
0x0002cbbc  bl       #0x5ad00   ; CALL objc_msgSend$setDisableActions:
0x0002cbc0  mov      x0, x19
0x0002cbc4  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0002cbc8  mov      v8.16b, v0.16b
0x0002cbcc  mov      v9.16b, v1.16b
0x0002cbd0  mov      v10.16b, v2.16b
0x0002cbd4  mov      v11.16b, v3.16b
0x0002cbd8  mov      x0, x19
0x0002cbdc  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0002cbe0  mov      x29, x29
0x0002cbe4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002cbe8  mov      x20, x0
0x0002cbec  mov      v0.16b, v8.16b
0x0002cbf0  mov      v1.16b, v9.16b
0x0002cbf4  mov      v2.16b, v10.16b
0x0002cbf8  mov      v3.16b, v11.16b
0x0002cbfc  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0002cc00  mov      x0, x20
0x0002cc04  bl       #0x55d78   ; CALL _objc_release
0x0002cc08  mov      x0, x19
0x0002cc0c  bl       #0x573a0   ; CALL objc_msgSend$corner
0x0002cc10  mov      v8.16b, v0.16b
0x0002cc14  mov      x0, x19
0x0002cc18  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0002cc1c  mov      x29, x29
0x0002cc20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002cc24  mov      x20, x0
0x0002cc28  mov      v0.16b, v8.16b
0x0002cc2c  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0002cc30  mov      x0, x20
0x0002cc34  bl       #0x55d78   ; CALL _objc_release
0x0002cc38  mov      x0, x19
0x0002cc3c  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0002cc40  mov      v8.16b, v2.16b
0x0002cc44  mov      x0, x19
0x0002cc48  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0002cc4c  adrp     x8, #0x65000
0x0002cc50  ldr      d0, [x8, #0x838]
0x0002cc54  fmul     d9, d3, d0
0x0002cc58  mov      x0, x19
0x0002cc5c  bl       #0x5c9a0   ; CALL objc_msgSend$sheen
0x0002cc60  mov      x29, x29
0x0002cc64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002cc68  mov      x20, x0
0x0002cc6c  fmov     d0, xzr
0x0002cc70  fmov     d1, xzr
0x0002cc74  mov      v2.16b, v8.16b
0x0002cc78  mov      v3.16b, v9.16b
0x0002cc7c  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0002cc80  mov      x0, x20
0x0002cc84  bl       #0x55d78   ; CALL _objc_release
0x0002cc88  ldr      x0, [x21, #0xab8]   ; @CLASS CATransaction
0x0002cc8c  bl       #0x56f40   ; CALL objc_msgSend$commit
0x0002cc90  adrp     x8, #0x8e000
0x0002cc94  ldr      x20, [x8, #0xac0]   ; @CLASS UIBezierPath
0x0002cc98  mov      x0, x19
0x0002cc9c  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0002cca0  mov      v8.16b, v0.16b
0x0002cca4  mov      v9.16b, v1.16b
0x0002cca8  mov      v10.16b, v2.16b
0x0002ccac  mov      v11.16b, v3.16b
0x0002ccb0  mov      x0, x19
0x0002ccb4  bl       #0x573a0   ; CALL objc_msgSend$corner
0x0002ccb8  mov      v4.16b, v0.16b
0x0002ccbc  mov      x0, x20
0x0002ccc0  mov      v0.16b, v8.16b
0x0002ccc4  mov      v1.16b, v9.16b
0x0002ccc8  mov      v2.16b, v10.16b
0x0002cccc  mov      v3.16b, v11.16b
0x0002ccd0  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x0002ccd4  mov      x29, x29
0x0002ccd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ccdc  mov      x20, x0
0x0002cce0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002cce4  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x0002cce8  mov      x21, x0
0x0002ccec  mov      x0, x19
0x0002ccf0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002ccf4  mov      x29, x29
0x0002ccf8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ccfc  mov      x19, x0
0x0002cd00  mov      x2, x21
0x0002cd04  bl       #0x5c020   ; CALL objc_msgSend$setShadowPath:
0x0002cd08  mov      x0, x19
0x0002cd0c  bl       #0x55d78   ; CALL _objc_release
0x0002cd10  mov      x0, x20
0x0002cd14  bl       #0x55d78   ; CALL _objc_release
0x0002cd18  ldp      x29, x30, [sp, #0x50]
0x0002cd1c  ldp      x20, x19, [sp, #0x40]
0x0002cd20  ldp      x22, x21, [sp, #0x30]
0x0002cd24  ldp      d9, d8, [sp, #0x20]
0x0002cd28  ldp      d11, d10, [sp, #0x10]
0x0002cd2c  add      sp, sp, #0x60
0x0002cd30  ret      

=== -[SPPGlassView fill]  va=0x2cd34 size=16 types=@16@0:8
0x0002cd34  adrp     x8, #0x8e000
0x0002cd38  ldrsw    x8, [x8, #0xebc]
0x0002cd3c  ldr      x0, [x0, x8]
0x0002cd40  ret      

=== -[SPPGlassView setFill:]  va=0x2cd44 size=64 types=v24@0:8@16
0x0002cd44  stp      x22, x21, [sp, #-0x30]!
0x0002cd48  stp      x20, x19, [sp, #0x10]
0x0002cd4c  stp      x29, x30, [sp, #0x20]
0x0002cd50  add      x29, sp, #0x20
0x0002cd54  mov      x19, x2
0x0002cd58  mov      x20, x0
0x0002cd5c  adrp     x8, #0x8e000
0x0002cd60  ldrsw    x21, [x8, #0xebc]
0x0002cd64  mov      x0, x2
0x0002cd68  bl       #0x55d84   ; CALL _objc_retain
0x0002cd6c  ldr      x0, [x20, x21]
0x0002cd70  str      x19, [x20, x21]
0x0002cd74  ldp      x29, x30, [sp, #0x20]
0x0002cd78  ldp      x20, x19, [sp, #0x10]
0x0002cd7c  ldp      x22, x21, [sp], #0x30
0x0002cd80  b        #0x55d78   ; CALL _objc_release

=== -[SPPGlassView sheen]  va=0x2cd84 size=16 types=@16@0:8
0x0002cd84  adrp     x8, #0x8e000
0x0002cd88  ldrsw    x8, [x8, #0xec0]
0x0002cd8c  ldr      x0, [x0, x8]
0x0002cd90  ret      

=== -[SPPGlassView setSheen:]  va=0x2cd94 size=64 types=v24@0:8@16
0x0002cd94  stp      x22, x21, [sp, #-0x30]!
0x0002cd98  stp      x20, x19, [sp, #0x10]
0x0002cd9c  stp      x29, x30, [sp, #0x20]
0x0002cda0  add      x29, sp, #0x20
0x0002cda4  mov      x19, x2
0x0002cda8  mov      x20, x0
0x0002cdac  adrp     x8, #0x8e000
0x0002cdb0  ldrsw    x21, [x8, #0xec0]
0x0002cdb4  mov      x0, x2
0x0002cdb8  bl       #0x55d84   ; CALL _objc_retain
0x0002cdbc  ldr      x0, [x20, x21]
0x0002cdc0  str      x19, [x20, x21]
0x0002cdc4  ldp      x29, x30, [sp, #0x20]
0x0002cdc8  ldp      x20, x19, [sp, #0x10]
0x0002cdcc  ldp      x22, x21, [sp], #0x30
0x0002cdd0  b        #0x55d78   ; CALL _objc_release

=== -[SPPGlassView corner]  va=0x2cdd4 size=16 types=d16@0:8
0x0002cdd4  adrp     x8, #0x8e000
0x0002cdd8  ldrsw    x8, [x8, #0xec4]
0x0002cddc  ldr      d0, [x0, x8]
0x0002cde0  ret      

=== -[SPPGlassView .cxx_destruct]  va=0x2cde4 size=64 types=v16@0:8
0x0002cde4  stp      x20, x19, [sp, #-0x20]!
0x0002cde8  stp      x29, x30, [sp, #0x10]
0x0002cdec  add      x29, sp, #0x10
0x0002cdf0  mov      x19, x0
0x0002cdf4  adrp     x8, #0x8e000
0x0002cdf8  ldrsw    x8, [x8, #0xec0]
0x0002cdfc  add      x0, x0, x8
0x0002ce00  mov      x1, #0
0x0002ce04  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0002ce08  adrp     x8, #0x8e000
0x0002ce0c  ldrsw    x8, [x8, #0xebc]
0x0002ce10  add      x0, x19, x8
0x0002ce14  mov      x1, #0
0x0002ce18  ldp      x29, x30, [sp, #0x10]
0x0002ce1c  ldp      x20, x19, [sp], #0x20
0x0002ce20  b        #0x55dcc   ; CALL _objc_storeStrong
