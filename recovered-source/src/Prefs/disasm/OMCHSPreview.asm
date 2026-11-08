=== -[OMCHSPreview initWithFrame:]  va=0x1b588 size=232 types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
0x0001b588  sub      sp, sp, #0x40
0x0001b58c  stp      x22, x21, [sp, #0x10]
0x0001b590  stp      x20, x19, [sp, #0x20]
0x0001b594  stp      x29, x30, [sp, #0x30]
0x0001b598  add      x29, sp, #0x30
0x0001b59c  adrp     x8, #0x8e000
0x0001b5a0  ldr      x8, [x8, #0xd50]   ; @SUPER OMCHSPreview
0x0001b5a4  stp      x0, x8, [sp]
0x0001b5a8  adrp     x8, #0x8c000
0x0001b5ac  ldr      x1, [x8, #0x8c8]   ; @SEL "initWithFrame:"
0x0001b5b0  mov      x0, sp
0x0001b5b4  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0001b5b8  mov      x19, x0
0x0001b5bc  cbz      x0, #0x1b658
0x0001b5c0  adrp     x8, #0x8e000
0x0001b5c4  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0001b5c8  bl       #0x56940   ; CALL objc_msgSend$blackColor
0x0001b5cc  mov      x29, x29
0x0001b5d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b5d4  mov      x20, x0
0x0001b5d8  mov      x0, x19
0x0001b5dc  mov      x2, x20
0x0001b5e0  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0001b5e4  mov      x0, x20
0x0001b5e8  bl       #0x55d78   ; CALL _objc_release
0x0001b5ec  mov      x0, x19
0x0001b5f0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0001b5f4  mov      x29, x29
0x0001b5f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b5fc  mov      x20, x0
0x0001b600  fmov     d0, #12.00000000
0x0001b604  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0001b608  mov      x0, x20
0x0001b60c  bl       #0x55d78   ; CALL _objc_release
0x0001b610  adrp     x8, #0x74000
0x0001b614  ldr      x8, [x8, #0x648]   ; @GOT _kCACornerCurveContinuous
0x0001b618  ldr      x20, [x8]   ; @GOT ___objc_personality_v0
0x0001b61c  mov      x0, x19
0x0001b620  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0001b624  mov      x29, x29
0x0001b628  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b62c  mov      x21, x0
0x0001b630  mov      x2, x20
0x0001b634  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x0001b638  mov      x0, x21
0x0001b63c  bl       #0x55d78   ; CALL _objc_release
0x0001b640  mov      x0, x19
0x0001b644  mov      w2, #1
0x0001b648  bl       #0x5a8a0   ; CALL objc_msgSend$setClipsToBounds:
0x0001b64c  mov      x0, x19
0x0001b650  mov      w2, #3
0x0001b654  bl       #0x5aa40   ; CALL objc_msgSend$setContentMode:
0x0001b658  mov      x0, x19
0x0001b65c  ldp      x29, x30, [sp, #0x30]
0x0001b660  ldp      x20, x19, [sp, #0x20]
0x0001b664  ldp      x22, x21, [sp, #0x10]
0x0001b668  add      sp, sp, #0x40
0x0001b66c  ret      

=== -[OMCHSPreview drawIcon:in:]  va=0x1b670 size=1496 types=v56@0:8@16{CGRect={CGPoint=dd}{CGSize=dd}}24
0x0001b670  stp      d11, d10, [sp, #-0x50]!
0x0001b674  stp      d9, d8, [sp, #0x10]
0x0001b678  stp      x22, x21, [sp, #0x20]
0x0001b67c  stp      x20, x19, [sp, #0x30]
0x0001b680  stp      x29, x30, [sp, #0x40]
0x0001b684  add      x29, sp, #0x40
0x0001b688  mov      v8.16b, v3.16b
0x0001b68c  mov      v9.16b, v2.16b
0x0001b690  mov      v10.16b, v1.16b
0x0001b694  mov      v11.16b, v0.16b
0x0001b698  mov      x21, x2
0x0001b69c  mov      x0, x2
0x0001b6a0  bl       #0x55d84   ; CALL _objc_retain
0x0001b6a4  bl       #0x55b20   ; CALL _UIGraphicsGetCurrentContext
0x0001b6a8  mov      x19, x0
0x0001b6ac  bl       #0x55970   ; CALL _CGContextSaveGState
0x0001b6b0  adrp     x22, #0x8e000
0x0001b6b4  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0001b6b8  adrp     x8, #0x65000
0x0001b6bc  ldr      d1, [x8, #0x608]
0x0001b6c0  fmov     d0, xzr
0x0001b6c4  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0001b6c8  mov      x29, x29
0x0001b6cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b6d0  mov      x20, x0
0x0001b6d4  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0001b6d8  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0001b6dc  mov      x1, x0
0x0001b6e0  fmov     d0, xzr
0x0001b6e4  fmov     d1, #3.00000000
0x0001b6e8  fmov     d2, #6.00000000
0x0001b6ec  mov      x0, x19
0x0001b6f0  bl       #0x559b8   ; CALL _CGContextSetShadowWithColor
0x0001b6f4  mov      x0, x20
0x0001b6f8  bl       #0x55d78   ; CALL _objc_release
0x0001b6fc  mov      x0, x21
0x0001b700  mov      v0.16b, v9.16b
0x0001b704  bl       #0x1b7cc
0x0001b708  mov      x29, x29
0x0001b70c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b710  mov      x20, x0
0x0001b714  mov      x0, x21
0x0001b718  bl       #0x55d78   ; CALL _objc_release
0x0001b71c  cbz      x20, #0x1b73c
0x0001b720  mov      x0, x20
0x0001b724  mov      v0.16b, v11.16b
0x0001b728  mov      v1.16b, v10.16b
0x0001b72c  mov      v2.16b, v9.16b
0x0001b730  mov      v3.16b, v8.16b
0x0001b734  bl       #0x578e0   ; CALL objc_msgSend$drawInRect:
0x0001b738  b        #0x1b7a8
0x0001b73c  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0001b740  adrp     x8, #0x65000
0x0001b744  ldr      d1, [x8, #0x728]
0x0001b748  fmov     d0, #1.00000000
0x0001b74c  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0001b750  mov      x29, x29
0x0001b754  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b758  mov      x21, x0
0x0001b75c  bl       #0x5ae00   ; CALL objc_msgSend$setFill
0x0001b760  mov      x0, x21
0x0001b764  bl       #0x55d78   ; CALL _objc_release
0x0001b768  adrp     x8, #0x8e000
0x0001b76c  ldr      x0, [x8, #0xac0]   ; @CLASS UIBezierPath
0x0001b770  adrp     x8, #0x65000
0x0001b774  ldr      d0, [x8, #0x730]
0x0001b778  fmul     d4, d9, d0
0x0001b77c  mov      v0.16b, v11.16b
0x0001b780  mov      v1.16b, v10.16b
0x0001b784  mov      v2.16b, v9.16b
0x0001b788  mov      v3.16b, v8.16b
0x0001b78c  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x0001b790  mov      x29, x29
0x0001b794  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b798  mov      x21, x0
0x0001b79c  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0001b7a0  mov      x0, x21
0x0001b7a4  bl       #0x55d78   ; CALL _objc_release
0x0001b7a8  mov      x0, x19
0x0001b7ac  bl       #0x55958   ; CALL _CGContextRestoreGState
0x0001b7b0  mov      x0, x20
0x0001b7b4  ldp      x29, x30, [sp, #0x40]
0x0001b7b8  ldp      x20, x19, [sp, #0x30]
0x0001b7bc  ldp      x22, x21, [sp, #0x20]
0x0001b7c0  ldp      d9, d8, [sp, #0x10]
0x0001b7c4  ldp      d11, d10, [sp], #0x50
0x0001b7c8  b        #0x55d78   ; CALL _objc_release
0x0001b7cc  sub      sp, sp, #0xf0
0x0001b7d0  stp      d9, d8, [sp, #0x80]
0x0001b7d4  stp      x28, x27, [sp, #0x90]
0x0001b7d8  stp      x26, x25, [sp, #0xa0]
0x0001b7dc  stp      x24, x23, [sp, #0xb0]
0x0001b7e0  stp      x22, x21, [sp, #0xc0]
0x0001b7e4  stp      x20, x19, [sp, #0xd0]
0x0001b7e8  stp      x29, x30, [sp, #0xe0]
0x0001b7ec  add      x29, sp, #0xe0
0x0001b7f0  mov      v8.16b, v0.16b
0x0001b7f4  mov      x19, x0
0x0001b7f8  bl       #0x55d84   ; CALL _objc_retain
0x0001b7fc  adrp     x24, #0x90000
0x0001b800  ldr      x8, [x24, #0x28]
0x0001b804  cbnz     x8, #0x1b824
0x0001b808  adrp     x8, #0x8e000
0x0001b80c  ldr      x0, [x8, #0xb18]   ; @CLASS NSCache
0x0001b810  bl       #0x55d60   ; CALL _objc_opt_new
0x0001b814  ldr      x8, [x24, #0x28]
0x0001b818  str      x0, [x24, #0x28]
0x0001b81c  mov      x0, x8
0x0001b820  bl       #0x55d78   ; CALL _objc_release
0x0001b824  adrp     x8, #0x8e000
0x0001b828  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0001b82c  str      d8, [sp, #8]
0x0001b830  str      x19, [sp]
0x0001b834  adrp     x2, #0x79000
0x0001b838  add      x2, x2, #0xb08   ; STR "%@/%.0f"
0x0001b83c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0001b840  mov      x29, x29
0x0001b844  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b848  mov      x20, x0
0x0001b84c  ldr      x0, [x24, #0x28]
0x0001b850  mov      x2, x20
0x0001b854  bl       #0x593a0   ; CALL objc_msgSend$objectForKey:
0x0001b858  mov      x29, x29
0x0001b85c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b860  mov      x21, x0
0x0001b864  cbz      x0, #0x1b878
0x0001b868  mov      x0, x21
0x0001b86c  bl       #0x55d84   ; CALL _objc_retain
0x0001b870  mov      x26, x21
0x0001b874  b        #0x1bc08
0x0001b878  mov      x0, x19
0x0001b87c  bl       #0x1e0c4
0x0001b880  adrp     x25, #0x8e000
0x0001b884  cbz      w0, #0x1b96c
0x0001b888  ldr      x0, [x25, #0xa78]   ; @CLASS UIImage
0x0001b88c  adrp     x8, #0x8b000
0x0001b890  ldr      x1, [x8, #0xf88]   ; @SEL "_applicationIconImageForBundleIdentifier:format:scale:"
0x0001b894  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x0001b898  tbz      w0, #0, #0x1b96c
0x0001b89c  ldr      x22, [x25, #0xa78]   ; @CLASS UIImage
0x0001b8a0  adrp     x8, #0x8e000
0x0001b8a4  ldr      x0, [x8, #0xb40]   ; @CLASS UIScreen
0x0001b8a8  bl       #0x58f00   ; CALL objc_msgSend$mainScreen
0x0001b8ac  mov      x29, x29
0x0001b8b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b8b4  mov      x23, x0
0x0001b8b8  bl       #0x5a060   ; CALL objc_msgSend$scale
0x0001b8bc  mov      x0, x22
0x0001b8c0  mov      x2, x19
0x0001b8c4  mov      w3, #2
0x0001b8c8  bl       #0x55f60   ; CALL objc_msgSend$_applicationIconImageForBundleIdentifier:format:scale:
0x0001b8cc  mov      x29, x29
0x0001b8d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b8d4  mov      x22, x0
0x0001b8d8  mov      x0, x23
0x0001b8dc  bl       #0x55d78   ; CALL _objc_release
0x0001b8e0  cbz      x22, #0x1b96c
0x0001b8e4  adrp     x8, #0x8e000
0x0001b8e8  ldr      x0, [x8, #0xb00]   ; @CLASS UIGraphicsImageRenderer
0x0001b8ec  bl       #0x55c7c   ; CALL _objc_alloc
0x0001b8f0  mov      v0.16b, v8.16b
0x0001b8f4  mov      v1.16b, v8.16b
0x0001b8f8  bl       #0x58540   ; CALL objc_msgSend$initWithSize:
0x0001b8fc  mov      x23, x0
0x0001b900  adrp     x8, #0x74000
0x0001b904  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x0001b908  str      x8, [sp, #0x10]
0x0001b90c  adrp     x8, #0x65000
0x0001b910  ldr      d0, [x8, #0x600]
0x0001b914  str      d0, [sp, #0x18]
0x0001b918  adrp     x8, #0x24000
0x0001b91c  add      x8, x8, #0xd10
0x0001b920  adrp     x9, #0x74000
0x0001b924  add      x9, x9, #0xb00
0x0001b928  stp      x8, x9, [sp, #0x20]
0x0001b92c  str      d8, [sp, #0x38]
0x0001b930  str      x22, [sp, #0x30]
0x0001b934  mov      x0, x22
0x0001b938  bl       #0x55d84   ; CALL _objc_retain
0x0001b93c  add      x2, sp, #0x10
0x0001b940  mov      x0, x23
0x0001b944  bl       #0x58140   ; CALL objc_msgSend$imageWithActions:
0x0001b948  mov      x29, x29
0x0001b94c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b950  mov      x26, x0
0x0001b954  ldr      x0, [x24, #0x28]
0x0001b958  mov      x2, x26
0x0001b95c  mov      x3, x20
0x0001b960  bl       #0x5b880   ; CALL objc_msgSend$setObject:forKey:
0x0001b964  ldr      x24, [sp, #0x30]
0x0001b968  b        #0x1bbf0
0x0001b96c  adrp     x2, #0x79000
0x0001b970  add      x2, x2, #0xb28   ; STR "NowPlaying"
0x0001b974  mov      x0, x19
0x0001b978  mov      w3, #1
0x0001b97c  bl       #0x59b60   ; CALL objc_msgSend$rangeOfString:options:
0x0001b980  mov      x22, #0x7fffffffffffffff
0x0001b984  cmp      x0, x22
0x0001b988  b.ne     #0x1b9d0
0x0001b98c  adrp     x2, #0x79000
0x0001b990  add      x2, x2, #0xb68   ; STR "Settings"
0x0001b994  mov      x0, x19
0x0001b998  bl       #0x59b40   ; CALL objc_msgSend$rangeOfString:
0x0001b99c  cmp      x0, x22
0x0001b9a0  b.ne     #0x1b9dc
0x0001b9a4  adrp     x2, #0x79000
0x0001b9a8  add      x2, x2, #0xba8   ; STR "com.apple.CarPlay"
0x0001b9ac  mov      x0, x19
0x0001b9b0  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x0001b9b4  adrp     x8, #0x79000
0x0001b9b8  add      x8, x8, #0xbc8   ; STR "app.fill"
0x0001b9bc  adrp     x9, #0x75000
0x0001b9c0  add      x9, x9, #0x228   ; STR "car.fill"
0x0001b9c4  cmp      w0, #0
0x0001b9c8  csel     x22, x9, x8, ne
0x0001b9cc  b        #0x1b9e4
0x0001b9d0  adrp     x22, #0x79000
0x0001b9d4  add      x22, x22, #0xb48   ; STR "play.fill"
0x0001b9d8  b        #0x1b9e4
0x0001b9dc  adrp     x22, #0x79000
0x0001b9e0  add      x22, x22, #0xb88   ; STR "gearshape.fill"
0x0001b9e4  mov      x0, x22
0x0001b9e8  bl       #0x55d84   ; CALL _objc_retain
0x0001b9ec  adrp     x2, #0x79000
0x0001b9f0  add      x2, x2, #0xb48   ; STR "play.fill"
0x0001b9f4  mov      x0, x22
0x0001b9f8  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0001b9fc  tbz      w0, #0, #0x1ba0c
0x0001ba00  adrp     x0, #0x79000
0x0001ba04  add      x0, x0, #0x528   ; STR "#FF8A65"
0x0001ba08  b        #0x1ba34
0x0001ba0c  adrp     x2, #0x75000
0x0001ba10  add      x2, x2, #0x228   ; STR "car.fill"
0x0001ba14  mov      x0, x22
0x0001ba18  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0001ba1c  adrp     x8, #0x79000
0x0001ba20  add      x8, x8, #0xbe8   ; STR "#9AA0A8"
0x0001ba24  adrp     x9, #0x78000
0x0001ba28  add      x9, x9, #0xf08   ; STR "#5AB8FF"
0x0001ba2c  cmp      w0, #0
0x0001ba30  csel     x0, x9, x8, ne
0x0001ba34  bl       #0x18080   ; CALL _OMCColorFromHex
0x0001ba38  mov      x29, x29
0x0001ba3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ba40  mov      x23, x0
0x0001ba44  adrp     x2, #0x79000
0x0001ba48  add      x2, x2, #0xb48   ; STR "play.fill"
0x0001ba4c  mov      x0, x22
0x0001ba50  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0001ba54  tbz      w0, #0, #0x1ba64
0x0001ba58  adrp     x0, #0x79000
0x0001ba5c  add      x0, x0, #0xc08   ; STR "#FF3D71"
0x0001ba60  b        #0x1ba8c
0x0001ba64  adrp     x2, #0x75000
0x0001ba68  add      x2, x2, #0x228   ; STR "car.fill"
0x0001ba6c  mov      x0, x22
0x0001ba70  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0001ba74  adrp     x8, #0x79000
0x0001ba78  add      x8, x8, #0xc48   ; STR "#636A73"
0x0001ba7c  adrp     x9, #0x79000
0x0001ba80  add      x9, x9, #0xc28   ; STR "#2E7CF6"
0x0001ba84  cmp      w0, #0
0x0001ba88  csel     x0, x9, x8, ne
0x0001ba8c  bl       #0x18080   ; CALL _OMCColorFromHex
0x0001ba90  mov      x29, x29
0x0001ba94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ba98  mov      x24, x0
0x0001ba9c  ldr      x25, [x25, #0xa78]   ; @CLASS UIImage
0x0001baa0  adrp     x8, #0x8e000
0x0001baa4  ldr      x0, [x8, #0xa70]   ; @CLASS UIImageSymbolConfiguration
0x0001baa8  adrp     x8, #0x65000
0x0001baac  ldr      d0, [x8, #0x738]
0x0001bab0  fmul     d0, d8, d0
0x0001bab4  mov      w2, #6
0x0001bab8  bl       #0x57100   ; CALL objc_msgSend$configurationWithPointSize:weight:
0x0001babc  mov      x29, x29
0x0001bac0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001bac4  mov      x26, x0
0x0001bac8  mov      x0, x25
0x0001bacc  mov      x2, x22
0x0001bad0  mov      x3, x26
0x0001bad4  bl       #0x5d840   ; CALL objc_msgSend$systemImageNamed:withConfiguration:
0x0001bad8  mov      x29, x29
0x0001badc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001bae0  mov      x27, x0
0x0001bae4  adrp     x8, #0x8e000
0x0001bae8  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0001baec  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0001baf0  mov      x29, x29
0x0001baf4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001baf8  mov      x28, x0
0x0001bafc  mov      x0, x27
0x0001bb00  mov      x2, x28
0x0001bb04  mov      w3, #1
0x0001bb08  bl       #0x58200   ; CALL objc_msgSend$imageWithTintColor:renderingMode:
0x0001bb0c  mov      x29, x29
0x0001bb10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001bb14  mov      x25, x0
0x0001bb18  mov      x0, x28
0x0001bb1c  bl       #0x55d78   ; CALL _objc_release
0x0001bb20  mov      x0, x27
0x0001bb24  bl       #0x55d78   ; CALL _objc_release
0x0001bb28  mov      x0, x26
0x0001bb2c  bl       #0x55d78   ; CALL _objc_release
0x0001bb30  adrp     x8, #0x8e000
0x0001bb34  ldr      x0, [x8, #0xb00]   ; @CLASS UIGraphicsImageRenderer
0x0001bb38  bl       #0x55c7c   ; CALL _objc_alloc
0x0001bb3c  mov      v0.16b, v8.16b
0x0001bb40  mov      v1.16b, v8.16b
0x0001bb44  bl       #0x58540   ; CALL objc_msgSend$initWithSize:
0x0001bb48  mov      x27, x0
0x0001bb4c  adrp     x8, #0x74000
0x0001bb50  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x0001bb54  str      x8, [sp, #0x40]
0x0001bb58  adrp     x8, #0x65000
0x0001bb5c  ldr      d0, [x8, #0x600]
0x0001bb60  str      d0, [sp, #0x48]
0x0001bb64  adrp     x8, #0x24000
0x0001bb68  add      x8, x8, #0xb48
0x0001bb6c  adrp     x9, #0x74000
0x0001bb70  add      x9, x9, #0xad0
0x0001bb74  stp      x8, x9, [sp, #0x50]
0x0001bb78  str      d8, [sp, #0x78]
0x0001bb7c  stp      x23, x24, [sp, #0x60]
0x0001bb80  str      x25, [sp, #0x70]
0x0001bb84  mov      x0, x25
0x0001bb88  bl       #0x55d84   ; CALL _objc_retain
0x0001bb8c  mov      x0, x24
0x0001bb90  bl       #0x55d84   ; CALL _objc_retain
0x0001bb94  mov      x0, x23
0x0001bb98  bl       #0x55d84   ; CALL _objc_retain
0x0001bb9c  add      x2, sp, #0x40
0x0001bba0  mov      x0, x27
0x0001bba4  bl       #0x58140   ; CALL objc_msgSend$imageWithActions:
0x0001bba8  mov      x29, x29
0x0001bbac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001bbb0  mov      x26, x0
0x0001bbb4  mov      x0, x27
0x0001bbb8  bl       #0x55d78   ; CALL _objc_release
0x0001bbbc  adrp     x8, #0x90000
0x0001bbc0  ldr      x0, [x8, #0x28]
0x0001bbc4  mov      x2, x26
0x0001bbc8  mov      x3, x20
0x0001bbcc  bl       #0x5b880   ; CALL objc_msgSend$setObject:forKey:
0x0001bbd0  ldr      x0, [sp, #0x70]
0x0001bbd4  bl       #0x55d78   ; CALL _objc_release
0x0001bbd8  ldr      x0, [sp, #0x68]
0x0001bbdc  bl       #0x55d78   ; CALL _objc_release
0x0001bbe0  ldr      x0, [sp, #0x60]
0x0001bbe4  bl       #0x55d78   ; CALL _objc_release
0x0001bbe8  mov      x0, x25
0x0001bbec  bl       #0x55d78   ; CALL _objc_release
0x0001bbf0  mov      x0, x24
0x0001bbf4  bl       #0x55d78   ; CALL _objc_release
0x0001bbf8  mov      x0, x23
0x0001bbfc  bl       #0x55d78   ; CALL _objc_release
0x0001bc00  mov      x0, x22
0x0001bc04  bl       #0x55d78   ; CALL _objc_release
0x0001bc08  mov      x0, x21
0x0001bc0c  bl       #0x55d78   ; CALL _objc_release
0x0001bc10  mov      x0, x20
0x0001bc14  bl       #0x55d78   ; CALL _objc_release
0x0001bc18  mov      x0, x19
0x0001bc1c  bl       #0x55d78   ; CALL _objc_release
0x0001bc20  mov      x0, x26
0x0001bc24  ldp      x29, x30, [sp, #0xe0]
0x0001bc28  ldp      x20, x19, [sp, #0xd0]
0x0001bc2c  ldp      x22, x21, [sp, #0xc0]
0x0001bc30  ldp      x24, x23, [sp, #0xb0]
0x0001bc34  ldp      x26, x25, [sp, #0xa0]
0x0001bc38  ldp      x28, x27, [sp, #0x90]
0x0001bc3c  ldp      d9, d8, [sp, #0x80]
0x0001bc40  add      sp, sp, #0xf0
0x0001bc44  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCHSPreview drawRect:]  va=0x1bc48 size=2876 types=v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
0x0001bc48  stp      d15, d14, [sp, #-0xa0]!
0x0001bc4c  stp      d13, d12, [sp, #0x10]
0x0001bc50  stp      d11, d10, [sp, #0x20]
0x0001bc54  stp      d9, d8, [sp, #0x30]
0x0001bc58  stp      x28, x27, [sp, #0x40]
0x0001bc5c  stp      x26, x25, [sp, #0x50]
0x0001bc60  stp      x24, x23, [sp, #0x60]
0x0001bc64  stp      x22, x21, [sp, #0x70]
0x0001bc68  stp      x20, x19, [sp, #0x80]
0x0001bc6c  stp      x29, x30, [sp, #0x90]
0x0001bc70  add      x29, sp, #0x90
0x0001bc74  sub      sp, sp, #0x160
0x0001bc78  mov      x19, x0
0x0001bc7c  adrp     x8, #0x74000
0x0001bc80  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0001bc84  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001bc88  stur     x8, [x29, #-0xa0]
0x0001bc8c  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0001bc90  mov      v8.16b, v3.16b
0x0001bc94  mov      x8, #0x4089000000000000
0x0001bc98  fmov     d0, x8
0x0001bc9c  fdiv     d9, d2, d0
0x0001bca0  bl       #0x55b20   ; CALL _UIGraphicsGetCurrentContext
0x0001bca4  mov      x20, x0
0x0001bca8  mov      v0.16b, v9.16b
0x0001bcac  mov      v1.16b, v9.16b
0x0001bcb0  bl       #0x5597c   ; CALL _CGContextScaleCTM
0x0001bcb4  fdiv     d15, d8, d9
0x0001bcb8  mov      x0, x19
0x0001bcbc  bl       #0x5e060   ; CALL objc_msgSend$wallpaper
0x0001bcc0  mov      x29, x29
0x0001bcc4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001bcc8  mov      x21, x0
0x0001bccc  bl       #0x55d78   ; CALL _objc_release
0x0001bcd0  adrp     x27, #0x8e000
0x0001bcd4  adrp     x26, #0x8e000
0x0001bcd8  adrp     x24, #0x74000
0x0001bcdc  ldr      x24, [x24, #0x1e0]   ; @GOT _NSForegroundColorAttributeName
0x0001bce0  adrp     x25, #0x8e000
0x0001bce4  cbz      x21, #0x1bf6c
0x0001bce8  mov      x0, x19
0x0001bcec  bl       #0x5e060   ; CALL objc_msgSend$wallpaper
0x0001bcf0  mov      x29, x29
0x0001bcf4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001bcf8  mov      x21, x0
0x0001bcfc  bl       #0x5cba0   ; CALL objc_msgSend$size
0x0001bd00  mov      v11.16b, v0.16b
0x0001bd04  mov      v12.16b, v1.16b
0x0001bd08  mov      x0, x21
0x0001bd0c  bl       #0x55d78   ; CALL _objc_release
0x0001bd10  mov      x8, #0x4087000000000000
0x0001bd14  fmov     d9, x8
0x0001bd18  fdiv     d0, d9, d11
0x0001bd1c  fdiv     d1, d15, d12
0x0001bd20  fcmp     d0, d1
0x0001bd24  fcsel    d8, d1, d0, mi
0x0001bd28  mov      x8, #0x4050000000000000
0x0001bd2c  fmov     d10, x8
0x0001bd30  fmov     d1, xzr
0x0001bd34  mov      v0.16b, v10.16b
0x0001bd38  mov      v2.16b, v9.16b
0x0001bd3c  mov      v3.16b, v15.16b
0x0001bd40  bl       #0x55a60   ; CALL _CGRectGetMidX
0x0001bd44  fmul     d11, d11, d8
0x0001bd48  fmov     d14, #0.50000000
0x0001bd4c  fmul     d1, d11, d14
0x0001bd50  fsub     d13, d0, d1
0x0001bd54  fmov     d1, xzr
0x0001bd58  mov      v0.16b, v10.16b
0x0001bd5c  mov      v2.16b, v9.16b
0x0001bd60  mov      v3.16b, v15.16b
0x0001bd64  bl       #0x55a6c   ; CALL _CGRectGetMidY
0x0001bd68  fmul     d12, d12, d8
0x0001bd6c  fmul     d1, d12, d14
0x0001bd70  fsub     d14, d0, d1
0x0001bd74  mov      x0, x20
0x0001bd78  bl       #0x55970   ; CALL _CGContextSaveGState
0x0001bd7c  fmov     d1, xzr
0x0001bd80  mov      x0, x20
0x0001bd84  mov      v0.16b, v10.16b
0x0001bd88  mov      v2.16b, v9.16b
0x0001bd8c  mov      v3.16b, v15.16b
0x0001bd90  bl       #0x55910   ; CALL _CGContextClipToRect
0x0001bd94  mov      x0, x19
0x0001bd98  bl       #0x5e060   ; CALL objc_msgSend$wallpaper
0x0001bd9c  mov      x29, x29
0x0001bda0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001bda4  mov      x21, x0
0x0001bda8  mov      v0.16b, v13.16b
0x0001bdac  mov      v1.16b, v14.16b
0x0001bdb0  mov      v2.16b, v11.16b
0x0001bdb4  mov      v3.16b, v12.16b
0x0001bdb8  bl       #0x578e0   ; CALL objc_msgSend$drawInRect:
0x0001bdbc  mov      x0, x21
0x0001bdc0  bl       #0x55d78   ; CALL _objc_release
0x0001bdc4  mov      x0, x19
0x0001bdc8  bl       #0x56960   ; CALL objc_msgSend$blur
0x0001bdcc  cmp      x0, #1
0x0001bdd0  b.lt     #0x1be44
0x0001bdd4  mov      x0, x19
0x0001bdd8  bl       #0x5df20   ; CALL objc_msgSend$video
0x0001bddc  tbnz     w0, #0, #0x1be44
0x0001bde0  ldr      x21, [x27, #0x910]   ; @CLASS UIColor
0x0001bde4  mov      x0, x19
0x0001bde8  bl       #0x56960   ; CALL objc_msgSend$blur
0x0001bdec  scvtf    d0, x0
0x0001bdf0  mov      x8, #0x405e000000000000
0x0001bdf4  fmov     d1, x8
0x0001bdf8  fdiv     d0, d0, d1
0x0001bdfc  fmov     d1, #0.25000000
0x0001be00  fcmp     d0, d1
0x0001be04  fcsel    d1, d1, d0, gt
0x0001be08  fmov     d0, #1.00000000
0x0001be0c  mov      x0, x21
0x0001be10  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0001be14  mov      x29, x29
0x0001be18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001be1c  mov      x21, x0
0x0001be20  bl       #0x5ae00   ; CALL objc_msgSend$setFill
0x0001be24  mov      x0, x21
0x0001be28  bl       #0x55d78   ; CALL _objc_release
0x0001be2c  fmov     d1, xzr
0x0001be30  mov      v0.16b, v10.16b
0x0001be34  mov      v2.16b, v9.16b
0x0001be38  mov      v3.16b, v15.16b
0x0001be3c  mov      w0, #0
0x0001be40  bl       #0x55b68   ; CALL _UIRectFillUsingBlendMode
0x0001be44  ldr      x21, [x27, #0x910]   ; @CLASS UIColor
0x0001be48  mov      x0, x19
0x0001be4c  bl       #0x57800   ; CALL objc_msgSend$dim
0x0001be50  scvtf    d0, x0
0x0001be54  mov      x8, #0x4059000000000000
0x0001be58  fmov     d1, x8
0x0001be5c  fdiv     d1, d0, d1
0x0001be60  fmov     d0, xzr
0x0001be64  mov      x0, x21
0x0001be68  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0001be6c  mov      x29, x29
0x0001be70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001be74  mov      x21, x0
0x0001be78  bl       #0x5ae00   ; CALL objc_msgSend$setFill
0x0001be7c  mov      x0, x21
0x0001be80  bl       #0x55d78   ; CALL _objc_release
0x0001be84  fmov     d1, xzr
0x0001be88  mov      v0.16b, v10.16b
0x0001be8c  mov      v2.16b, v9.16b
0x0001be90  mov      v3.16b, v15.16b
0x0001be94  mov      w0, #0
0x0001be98  bl       #0x55b68   ; CALL _UIRectFillUsingBlendMode
0x0001be9c  mov      x0, x20
0x0001bea0  bl       #0x55958   ; CALL _CGContextRestoreGState
0x0001bea4  mov      x0, x19
0x0001bea8  bl       #0x5df20   ; CALL objc_msgSend$video
0x0001beac  adrp     x8, #0x74000
0x0001beb0  ldr      x8, [x8, #0x1d8]   ; @GOT _NSFontAttributeName
0x0001beb4  ldr      x23, [x8]   ; @GOT ___objc_personality_v0
0x0001beb8  cbz      w0, #0x1bfd0
0x0001bebc  stur     x23, [x29, #-0xc0]
0x0001bec0  ldr      x0, [x26, #0x948]   ; @CLASS UIFont
0x0001bec4  adrp     x8, #0x74000
0x0001bec8  ldr      x8, [x8, #0x260]   ; @GOT _UIFontWeightSemibold
0x0001becc  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x0001bed0  fmov     d0, #12.00000000
0x0001bed4  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x0001bed8  mov      x29, x29
0x0001bedc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001bee0  mov      x20, x0
0x0001bee4  ldr      x8, [x24]   ; @GOT ___objc_personality_v0
0x0001bee8  stp      x8, x0, [x29, #-0xb8]
0x0001beec  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x0001bef0  adrp     x8, #0x65000
0x0001bef4  ldr      d1, [x8, #0x6d0]
0x0001bef8  fmov     d0, #1.00000000
0x0001befc  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0001bf00  mov      x29, x29
0x0001bf04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001bf08  mov      x21, x0
0x0001bf0c  stur     x0, [x29, #-0xa8]
0x0001bf10  ldr      x0, [x25, #0x970]   ; @CLASS NSDictionary
0x0001bf14  sub      x2, x29, #0xb0
0x0001bf18  sub      x3, x29, #0xc0
0x0001bf1c  mov      w4, #2
0x0001bf20  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0001bf24  mov      x29, x29
0x0001bf28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001bf2c  mov      x22, x0
0x0001bf30  mov      x0, x21
0x0001bf34  bl       #0x55d78   ; CALL _objc_release
0x0001bf38  mov      x0, x20
0x0001bf3c  bl       #0x55d78   ; CALL _objc_release
0x0001bf40  fmov     d0, #-20.00000000
0x0001bf44  fadd     d1, d15, d0
0x0001bf48  adrp     x0, #0x79000
0x0001bf4c  add      x0, x0, #0xc8   ; STR "▶︎ video"
0x0001bf50  adrp     x8, #0x65000
0x0001bf54  ldr      d0, [x8, #0x740]
0x0001bf58  mov      x2, x22
0x0001bf5c  bl       #0x578a0   ; CALL objc_msgSend$drawAtPoint:withAttributes:
0x0001bf60  mov      x0, x22
0x0001bf64  bl       #0x55d78   ; CALL _objc_release
0x0001bf68  b        #0x1bfd0
0x0001bf6c  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x0001bf70  adrp     x8, #0x65000
0x0001bf74  ldr      d0, [x8, #0x748]
0x0001bf78  adrp     x8, #0x65000
0x0001bf7c  ldr      d1, [x8, #0x750]
0x0001bf80  adrp     x8, #0x65000
0x0001bf84  ldr      d2, [x8, #0x758]
0x0001bf88  fmov     d3, #1.00000000
0x0001bf8c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0001bf90  mov      x29, x29
0x0001bf94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001bf98  mov      x20, x0
0x0001bf9c  bl       #0x5ae00   ; CALL objc_msgSend$setFill
0x0001bfa0  mov      x0, x20
0x0001bfa4  bl       #0x55d78   ; CALL _objc_release
0x0001bfa8  mov      x8, #0x4050000000000000
0x0001bfac  fmov     d0, x8
0x0001bfb0  mov      x8, #0x4087000000000000
0x0001bfb4  fmov     d2, x8
0x0001bfb8  fmov     d1, xzr
0x0001bfbc  mov      v3.16b, v15.16b
0x0001bfc0  bl       #0x55b5c   ; CALL _UIRectFill
0x0001bfc4  adrp     x8, #0x74000
0x0001bfc8  ldr      x8, [x8, #0x1d8]   ; @GOT _NSFontAttributeName
0x0001bfcc  ldr      x23, [x8]   ; @GOT ___objc_personality_v0
0x0001bfd0  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x0001bfd4  adrp     x8, #0x65000
0x0001bfd8  ldr      d0, [x8, #0x760]
0x0001bfdc  adrp     x8, #0x65000
0x0001bfe0  ldr      d1, [x8, #0x768]
0x0001bfe4  adrp     x8, #0x65000
0x0001bfe8  ldr      d2, [x8, #0x770]
0x0001bfec  fmov     d3, #1.00000000
0x0001bff0  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0001bff4  mov      x29, x29
0x0001bff8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001bffc  mov      x20, x0
0x0001c000  bl       #0x5ae00   ; CALL objc_msgSend$setFill
0x0001c004  mov      x0, x20
0x0001c008  bl       #0x55d78   ; CALL _objc_release
0x0001c00c  mov      x8, #0x4050000000000000
0x0001c010  fmov     d2, x8
0x0001c014  fmov     d0, xzr
0x0001c018  fmov     d1, xzr
0x0001c01c  mov      v3.16b, v15.16b
0x0001c020  bl       #0x55b5c   ; CALL _UIRectFill
0x0001c024  stur     x23, [x29, #-0xe0]
0x0001c028  ldr      x0, [x26, #0x948]   ; @CLASS UIFont
0x0001c02c  fmov     d0, #12.00000000
0x0001c030  bl       #0x569a0   ; CALL objc_msgSend$boldSystemFontOfSize:
0x0001c034  mov      x29, x29
0x0001c038  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001c03c  mov      x21, x0
0x0001c040  ldr      x26, [x24]   ; @GOT ___objc_personality_v0
0x0001c044  stp      x26, x0, [x29, #-0xd8]
0x0001c048  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x0001c04c  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0001c050  mov      x29, x29
0x0001c054  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001c058  mov      x22, x0
0x0001c05c  stur     x0, [x29, #-0xc8]
0x0001c060  ldr      x0, [x25, #0x970]   ; @CLASS NSDictionary
0x0001c064  sub      x2, x29, #0xd0
0x0001c068  sub      x3, x29, #0xe0
0x0001c06c  mov      w4, #2
0x0001c070  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0001c074  mov      x29, x29
0x0001c078  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001c07c  mov      x20, x0
0x0001c080  mov      x0, x22
0x0001c084  bl       #0x55d78   ; CALL _objc_release
0x0001c088  mov      x0, x21
0x0001c08c  bl       #0x55d78   ; CALL _objc_release
0x0001c090  adrp     x0, #0x79000
0x0001c094  add      x0, x0, #0xe8   ; STR "9:41"
0x0001c098  fmov     d0, #17.00000000
0x0001c09c  fmov     d1, #8.00000000
0x0001c0a0  str      x20, [sp, #8]
0x0001c0a4  mov      x2, x20
0x0001c0a8  bl       #0x578a0   ; CALL objc_msgSend$drawAtPoint:withAttributes:
0x0001c0ac  movi     v0.16b, #0
0x0001c0b0  stp      q0, q0, [sp, #0x50]
0x0001c0b4  stp      q0, q0, [sp, #0x30]
0x0001c0b8  adrp     x0, #0x7f000
0x0001c0bc  add      x0, x0, #0x948
0x0001c0c0  add      x2, sp, #0x30
0x0001c0c4  add      x3, sp, #0x90
0x0001c0c8  mov      w4, #0x10
0x0001c0cc  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001c0d0  cbz      x0, #0x1c168
0x0001c0d4  mov      x21, x0
0x0001c0d8  ldr      x8, [sp, #0x40]
0x0001c0dc  ldr      x20, [x8]   ; @CSTR "m.fill"
0x0001c0e0  mov      x8, #0x4041000000000000
0x0001c0e4  fmov     d9, x8
0x0001c0e8  mov      x8, #0x4045000000000000
0x0001c0ec  fmov     d10, x8
0x0001c0f0  mov      x8, #0x4049000000000000
0x0001c0f4  fmov     d8, x8
0x0001c0f8  adrp     x22, #0x7f000
0x0001c0fc  add      x22, x22, #0x948
0x0001c100  mov      x24, #0
0x0001c104  ldr      x8, [sp, #0x40]
0x0001c108  ldr      x8, [x8]   ; @CSTR "m.fill"
0x0001c10c  cmp      x8, x20
0x0001c110  b.eq     #0x1c11c
0x0001c114  mov      x0, x22
0x0001c118  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0001c11c  ldr      x8, [sp, #0x38]
0x0001c120  ldr      x2, [x8, x24, lsl #3]
0x0001c124  fmov     d0, #11.00000000
0x0001c128  mov      x0, x19
0x0001c12c  mov      v1.16b, v9.16b
0x0001c130  mov      v2.16b, v10.16b
0x0001c134  mov      v3.16b, v10.16b
0x0001c138  bl       #0x578c0   ; CALL objc_msgSend$drawIcon:in:
0x0001c13c  fadd     d9, d9, d8
0x0001c140  add      x24, x24, #1
0x0001c144  cmp      x21, x24
0x0001c148  b.ne     #0x1c104
0x0001c14c  add      x2, sp, #0x30
0x0001c150  add      x3, sp, #0x90
0x0001c154  mov      x0, x22
0x0001c158  mov      w4, #0x10
0x0001c15c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001c160  mov      x21, x0
0x0001c164  cbnz     x0, #0x1c100
0x0001c168  mov      w20, #0
0x0001c16c  fmov     d0, #-30.00000000
0x0001c170  fadd     d10, d15, d0
0x0001c174  adrp     x8, #0x65000
0x0001c178  ldr      d9, [x8, #0x670]
0x0001c17c  mov      w22, #0xa
0x0001c180  mov      w24, #0x12
0x0001c184  mov      w25, #9
0x0001c188  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x0001c18c  fmov     d1, #1.00000000
0x0001c190  mov      v0.16b, v9.16b
0x0001c194  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0001c198  mov      x29, x29
0x0001c19c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001c1a0  mov      x21, x0
0x0001c1a4  bl       #0x5ae00   ; CALL objc_msgSend$setFill
0x0001c1a8  mov      x0, x21
0x0001c1ac  bl       #0x55d78   ; CALL _objc_release
0x0001c1b0  subs     w8, w20, #3
0x0001c1b4  csel     w8, w20, w8, lo
0x0001c1b8  madd     w8, w8, w22, w24
0x0001c1bc  ucvtf    d0, w8
0x0001c1c0  cmp      w20, #2
0x0001c1c4  csel     w8, w25, wzr, hi
0x0001c1c8  ucvtf    d1, w8
0x0001c1cc  fadd     d1, d10, d1
0x0001c1d0  fmov     d2, #7.00000000
0x0001c1d4  fmov     d3, #6.00000000
0x0001c1d8  bl       #0x55b5c   ; CALL _UIRectFill
0x0001c1dc  add      w20, w20, #1
0x0001c1e0  cmp      w20, #6
0x0001c1e4  b.ne     #0x1c188
0x0001c1e8  mov      x0, x19
0x0001c1ec  bl       #0x56f20   ; CALL objc_msgSend$cols
0x0001c1f0  cmp      x0, #0
0x0001c1f4  b.le     #0x1c208
0x0001c1f8  mov      x0, x19
0x0001c1fc  bl       #0x56f20   ; CALL objc_msgSend$cols
0x0001c200  mov      x22, x0
0x0001c204  b        #0x1c20c
0x0001c208  mov      w22, #5
0x0001c20c  mov      x0, x19
0x0001c210  bl       #0x59fa0   ; CALL objc_msgSend$rows
0x0001c214  cmp      x0, #1
0x0001c218  str      d15, [sp, #0x28]
0x0001c21c  b.lt     #0x1c230
0x0001c220  mov      x0, x19
0x0001c224  bl       #0x59fa0   ; CALL objc_msgSend$rows
0x0001c228  mov      x24, x0
0x0001c22c  b        #0x1c234
0x0001c230  mov      w24, #2
0x0001c234  mul      x20, x24, x22
0x0001c238  mov      x0, x19
0x0001c23c  bl       #0x5cba0   ; CALL objc_msgSend$size
0x0001c240  mov      x25, x0
0x0001c244  mov      x0, x19
0x0001c248  bl       #0x58980   ; CALL objc_msgSend$items
0x0001c24c  mov      x29, x29
0x0001c250  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001c254  mov      x21, x0
0x0001c258  bl       #0x573c0   ; CALL objc_msgSend$count
0x0001c25c  add      x8, x20, x0
0x0001c260  sub      x8, x8, #1
0x0001c264  sdiv     x28, x8, x20
0x0001c268  mov      x0, x21
0x0001c26c  bl       #0x55d78   ; CALL _objc_release
0x0001c270  cmp      x28, #1
0x0001c274  csinc    x8, x28, xzr, gt
0x0001c278  str      x8, [sp]
0x0001c27c  str      x23, [sp, #0x70]
0x0001c280  adrp     x8, #0x8e000
0x0001c284  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x0001c288  adrp     x8, #0x74000
0x0001c28c  ldr      x8, [x8, #0x250]   ; @GOT _UIFontWeightMedium
0x0001c290  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x0001c294  fmov     d0, #12.00000000
0x0001c298  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x0001c29c  mov      x29, x29
0x0001c2a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001c2a4  mov      x23, x0
0x0001c2a8  stp      x26, x0, [sp, #0x78]
0x0001c2ac  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x0001c2b0  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0001c2b4  mov      x29, x29
0x0001c2b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001c2bc  mov      x26, x0
0x0001c2c0  str      x0, [sp, #0x88]
0x0001c2c4  adrp     x8, #0x8e000
0x0001c2c8  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x0001c2cc  add      x2, sp, #0x80
0x0001c2d0  add      x3, sp, #0x70
0x0001c2d4  mov      w4, #2
0x0001c2d8  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0001c2dc  mov      x29, x29
0x0001c2e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001c2e4  mov      x21, x0
0x0001c2e8  mov      x0, x26
0x0001c2ec  bl       #0x55d78   ; CALL _objc_release
0x0001c2f0  mov      x0, x23
0x0001c2f4  bl       #0x55d78   ; CALL _objc_release
0x0001c2f8  mov      x0, x19
0x0001c2fc  bl       #0x58980   ; CALL objc_msgSend$items
0x0001c300  mov      x29, x29
0x0001c304  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001c308  mov      x23, x0
0x0001c30c  bl       #0x573c0   ; CALL objc_msgSend$count
0x0001c310  mov      x26, x0
0x0001c314  mov      x0, x23
0x0001c318  bl       #0x55d78   ; CALL _objc_release
0x0001c31c  cmp      x20, x26
0x0001c320  csel     x8, x20, x26, lt
0x0001c324  cmp      x8, #1
0x0001c328  b.lt     #0x1c4e0
0x0001c32c  mov      x23, #0
0x0001c330  adrp     x8, #0x65000
0x0001c334  ldr      d0, [x8, #0x778]
0x0001c338  scvtf    d1, x22
0x0001c33c  scvtf    d2, x24
0x0001c340  fdiv     d3, d0, d1
0x0001c344  fdiv     d2, d10, d2
0x0001c348  lsl      x8, x25, #6
0x0001c34c  scvtf    d0, x8
0x0001c350  mov      x8, #0x4059000000000000
0x0001c354  fmov     d1, x8
0x0001c358  fdiv     d0, d0, d1
0x0001c35c  frinta   d9, d0
0x0001c360  mov      x9, #0x4087000000000000
0x0001c364  mov      x8, #0x4050000000000000
0x0001c368  stp      x8, x9, [sp, #0x18]
0x0001c36c  fmov     d0, #0.50000000
0x0001c370  fmul     d1, d3, d0
0x0001c374  str      d1, [sp, #0x10]
0x0001c378  mov      v8.16b, v2.16b
0x0001c37c  fmul     d12, d2, d0
0x0001c380  fmul     d15, d9, d0
0x0001c384  fmov     d0, #-6.00000000
0x0001c388  mov      v11.16b, v3.16b
0x0001c38c  fadd     d14, d3, d0
0x0001c390  mov      x0, x19
0x0001c394  bl       #0x58980   ; CALL objc_msgSend$items
0x0001c398  mov      x29, x29
0x0001c39c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001c3a0  mov      x25, x0
0x0001c3a4  mov      x2, x23
0x0001c3a8  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0001c3ac  mov      x29, x29
0x0001c3b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001c3b4  mov      x24, x0
0x0001c3b8  mov      x0, x25
0x0001c3bc  bl       #0x55d78   ; CALL _objc_release
0x0001c3c0  sdiv     x25, x23, x22
0x0001c3c4  msub     x26, x22, x25, x23
0x0001c3c8  fmov     d1, xzr
0x0001c3cc  ldp      d0, d2, [sp, #0x18]
0x0001c3d0  ldr      d3, [sp, #0x28]
0x0001c3d4  bl       #0x55a78   ; CALL _CGRectGetMinX
0x0001c3d8  fmov     d1, #12.00000000
0x0001c3dc  fadd     d0, d0, d1
0x0001c3e0  ucvtf    d1, x26
0x0001c3e4  fmadd    d0, d1, d11, d0
0x0001c3e8  ldr      d1, [sp, #0x10]
0x0001c3ec  fadd     d13, d1, d0
0x0001c3f0  scvtf    d0, x25
0x0001c3f4  fmov     d1, #6.00000000
0x0001c3f8  fmadd    d0, d0, d8, d1
0x0001c3fc  fadd     d10, d12, d0
0x0001c400  mov      x0, x19
0x0001c404  bl       #0x59140   ; CALL objc_msgSend$names
0x0001c408  cmp      w0, #0
0x0001c40c  fmov     d0, xzr
0x0001c410  fmov     d1, #10.00000000
0x0001c414  fcsel    d0, d1, d0, ne
0x0001c418  fsub     d10, d10, d0
0x0001c41c  fsub     d0, d13, d15
0x0001c420  fsub     d1, d10, d15
0x0001c424  mov      x0, x19
0x0001c428  mov      x2, x24
0x0001c42c  mov      v2.16b, v9.16b
0x0001c430  mov      v3.16b, v9.16b
0x0001c434  bl       #0x578c0   ; CALL objc_msgSend$drawIcon:in:
0x0001c438  mov      x0, x19
0x0001c43c  bl       #0x59140   ; CALL objc_msgSend$names
0x0001c440  cbz      w0, #0x1c4a0
0x0001c444  mov      x0, x24
0x0001c448  bl       #0x1c620
0x0001c44c  mov      x29, x29
0x0001c450  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001c454  mov      x25, x0
0x0001c458  mov      x2, x21
0x0001c45c  bl       #0x5cc00   ; CALL objc_msgSend$sizeWithAttributes:
0x0001c460  fcmp     d0, d14
0x0001c464  fcsel    d2, d0, d14, mi
0x0001c468  fmov     d0, #-0.50000000
0x0001c46c  fmul     d0, d2, d0
0x0001c470  fadd     d0, d13, d0
0x0001c474  fadd     d1, d15, d10
0x0001c478  fmov     d3, #4.00000000
0x0001c47c  fadd     d1, d1, d3
0x0001c480  fmov     d3, #16.00000000
0x0001c484  mov      x0, x25
0x0001c488  mov      w2, #0x20
0x0001c48c  mov      x3, x21
0x0001c490  mov      x4, #0
0x0001c494  bl       #0x57900   ; CALL objc_msgSend$drawWithRect:options:attributes:context:
0x0001c498  mov      x0, x25
0x0001c49c  bl       #0x55d78   ; CALL _objc_release
0x0001c4a0  mov      x0, x24
0x0001c4a4  bl       #0x55d78   ; CALL _objc_release
0x0001c4a8  add      x23, x23, #1
0x0001c4ac  mov      x0, x19
0x0001c4b0  bl       #0x58980   ; CALL objc_msgSend$items
0x0001c4b4  mov      x29, x29
0x0001c4b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001c4bc  mov      x24, x0
0x0001c4c0  bl       #0x573c0   ; CALL objc_msgSend$count
0x0001c4c4  mov      x25, x0
0x0001c4c8  mov      x0, x24
0x0001c4cc  bl       #0x55d78   ; CALL _objc_release
0x0001c4d0  cmp      x20, x25
0x0001c4d4  csel     x8, x20, x25, lt
0x0001c4d8  cmp      x23, x8
0x0001c4dc  b.lt     #0x1c390
0x0001c4e0  cmp      x28, #1
0x0001c4e4  b.le     #0x1c5c4
0x0001c4e8  mov      w8, #0xc
0x0001c4ec  mov      x9, #4
0x0001c4f0  ldr      x10, [sp]
0x0001c4f4  madd     x8, x10, x8, x9
0x0001c4f8  scvtf    d8, x8
0x0001c4fc  mov      x8, #0x4050000000000000
0x0001c500  fmov     d0, x8
0x0001c504  mov      x8, #0x4087000000000000
0x0001c508  fmov     d2, x8
0x0001c50c  fmov     d1, xzr
0x0001c510  ldr      d10, [sp, #0x28]
0x0001c514  mov      v3.16b, v10.16b
0x0001c518  bl       #0x55a60   ; CALL _CGRectGetMidX
0x0001c51c  mov      x20, #0
0x0001c520  fmov     d1, #-0.50000000
0x0001c524  fmul     d1, d8, d1
0x0001c528  fadd     d9, d0, d1
0x0001c52c  fmov     d0, #-12.00000000
0x0001c530  fadd     d8, d10, d0
0x0001c534  fmov     d11, #6.00000000
0x0001c538  fmov     d12, #16.00000000
0x0001c53c  adrp     x8, #0x65000
0x0001c540  ldr      d13, [x8, #0x780]
0x0001c544  fmov     d14, #1.00000000
0x0001c548  adrp     x22, #0x8e000
0x0001c54c  cmp      x20, #0
0x0001c550  fcsel    d10, d12, d11, eq
0x0001c554  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x0001c558  fcsel    d1, d14, d13, eq
0x0001c55c  fmov     d0, #1.00000000
0x0001c560  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0001c564  mov      x29, x29
0x0001c568  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001c56c  mov      x19, x0
0x0001c570  bl       #0x5ae00   ; CALL objc_msgSend$setFill
0x0001c574  mov      x0, x19
0x0001c578  bl       #0x55d78   ; CALL _objc_release
0x0001c57c  ldr      x0, [x22, #0xac0]   ; @CLASS UIBezierPath
0x0001c580  fmov     d3, #6.00000000
0x0001c584  fmov     d4, #3.00000000
0x0001c588  mov      v0.16b, v9.16b
0x0001c58c  mov      v1.16b, v8.16b
0x0001c590  mov      v2.16b, v10.16b
0x0001c594  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x0001c598  mov      x29, x29
0x0001c59c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001c5a0  mov      x19, x0
0x0001c5a4  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0001c5a8  mov      x0, x19
0x0001c5ac  bl       #0x55d78   ; CALL _objc_release
0x0001c5b0  fadd     d0, d10, d11
0x0001c5b4  fadd     d9, d9, d0
0x0001c5b8  add      x20, x20, #1
0x0001c5bc  cmp      x28, x20
0x0001c5c0  b.ne     #0x1c54c
0x0001c5c4  mov      x0, x21
0x0001c5c8  bl       #0x55d78   ; CALL _objc_release
0x0001c5cc  ldr      x0, [sp, #8]
0x0001c5d0  bl       #0x55d78   ; CALL _objc_release
0x0001c5d4  ldur     x8, [x29, #-0xa0]
0x0001c5d8  adrp     x9, #0x74000
0x0001c5dc  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0001c5e0  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0001c5e4  cmp      x9, x8
0x0001c5e8  b.ne     #0x1c61c
0x0001c5ec  add      sp, sp, #0x160
0x0001c5f0  ldp      x29, x30, [sp, #0x90]
0x0001c5f4  ldp      x20, x19, [sp, #0x80]
0x0001c5f8  ldp      x22, x21, [sp, #0x70]
0x0001c5fc  ldp      x24, x23, [sp, #0x60]
0x0001c600  ldp      x26, x25, [sp, #0x50]
0x0001c604  ldp      x28, x27, [sp, #0x40]
0x0001c608  ldp      d9, d8, [sp, #0x30]
0x0001c60c  ldp      d11, d10, [sp, #0x20]
0x0001c610  ldp      d13, d12, [sp, #0x10]
0x0001c614  ldp      d15, d14, [sp], #0xa0
0x0001c618  ret      
0x0001c61c  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0001c620  stp      x24, x23, [sp, #-0x40]!
0x0001c624  stp      x22, x21, [sp, #0x10]
0x0001c628  stp      x20, x19, [sp, #0x20]
0x0001c62c  stp      x29, x30, [sp, #0x30]
0x0001c630  add      x29, sp, #0x30
0x0001c634  mov      x19, x0
0x0001c638  bl       #0x55d84   ; CALL _objc_retain
0x0001c63c  adrp     x8, #0x90000
0x0001c640  ldr      x0, [x8, #0x18]
0x0001c644  mov      x2, x19
0x0001c648  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001c64c  mov      x29, x29
0x0001c650  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001c654  mov      x20, x0
0x0001c658  bl       #0x58c20   ; CALL objc_msgSend$length
0x0001c65c  cbz      x0, #0x1c670
0x0001c660  mov      x0, x20
0x0001c664  mov      x2, x19
0x0001c668  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0001c66c  tbz      w0, #0, #0x1c750
0x0001c670  adrp     x0, #0x63000
0x0001c674  add      x0, x0, #0xf6   ; CSTR "LSApplicationProxy"
0x0001c678  bl       #0x55d0c   ; CALL _objc_getClass
0x0001c67c  mov      x21, x0
0x0001c680  adrp     x0, #0x79000
0x0001c684  add      x0, x0, #0xc68   ; STR "applicationProxyForIdentifier:"
0x0001c688  bl       #0x55b08   ; CALL _NSSelectorFromString
0x0001c68c  mov      x23, x0
0x0001c690  adrp     x0, #0x79000
0x0001c694  add      x0, x0, #0xc88   ; STR "localizedName"
0x0001c698  bl       #0x55b08   ; CALL _NSSelectorFromString
0x0001c69c  mov      x22, x0
0x0001c6a0  mov      x0, x21
0x0001c6a4  mov      x1, x23
0x0001c6a8  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x0001c6ac  tbz      w0, #0, #0x1c6d0
0x0001c6b0  mov      x0, x21
0x0001c6b4  mov      x1, x23
0x0001c6b8  mov      x2, x19
0x0001c6bc  bl       #0x55d30   ; CALL _objc_msgSend
0x0001c6c0  mov      x29, x29
0x0001c6c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001c6c8  mov      x21, x0
0x0001c6cc  b        #0x1c6d4
0x0001c6d0  mov      x21, #0
0x0001c6d4  mov      x0, x21
0x0001c6d8  mov      x1, x22
0x0001c6dc  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x0001c6e0  tbz      w0, #0, #0x1c700
0x0001c6e4  mov      x0, x21
0x0001c6e8  mov      x1, x22
0x0001c6ec  bl       #0x55d30   ; CALL _objc_msgSend
0x0001c6f0  mov      x29, x29
0x0001c6f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001c6f8  mov      x22, x0
0x0001c6fc  b        #0x1c704
0x0001c700  mov      x22, #0
0x0001c704  adrp     x8, #0x8e000
0x0001c708  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0001c70c  bl       #0x55d48   ; CALL _objc_opt_class
0x0001c710  mov      x1, x0
0x0001c714  mov      x0, x22
0x0001c718  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0001c71c  tbz      w0, #0, #0x1c730
0x0001c720  mov      x0, x22
0x0001c724  bl       #0x58c20   ; CALL objc_msgSend$length
0x0001c728  mov      x23, x22
0x0001c72c  cbnz     x0, #0x1c734
0x0001c730  mov      x23, x19
0x0001c734  mov      x0, x23
0x0001c738  bl       #0x55d84   ; CALL _objc_retain
0x0001c73c  mov      x0, x22
0x0001c740  bl       #0x55d78   ; CALL _objc_release
0x0001c744  mov      x0, x21
0x0001c748  bl       #0x55d78   ; CALL _objc_release
0x0001c74c  b        #0x1c75c
0x0001c750  mov      x0, x20
0x0001c754  bl       #0x55d84   ; CALL _objc_retain
0x0001c758  mov      x23, x20
0x0001c75c  mov      x0, x20
0x0001c760  bl       #0x55d78   ; CALL _objc_release
0x0001c764  mov      x0, x19
0x0001c768  bl       #0x55d78   ; CALL _objc_release
0x0001c76c  mov      x0, x23
0x0001c770  ldp      x29, x30, [sp, #0x30]
0x0001c774  ldp      x20, x19, [sp, #0x20]
0x0001c778  ldp      x22, x21, [sp, #0x10]
0x0001c77c  ldp      x24, x23, [sp], #0x40
0x0001c780  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCHSPreview items]  va=0x1c784 size=16 types=@16@0:8
0x0001c784  adrp     x8, #0x8e000
0x0001c788  ldrsw    x8, [x8, #0xe34]
0x0001c78c  ldr      x0, [x0, x8]
0x0001c790  ret      

=== -[OMCHSPreview setItems:]  va=0x1c794 size=12 types=v24@0:8@16
0x0001c794  adrp     x8, #0x8e000
0x0001c798  ldrsw    x3, [x8, #0xe34]
0x0001c79c  b        #0x55dc0   ; CALL _objc_setProperty_nonatomic_copy

=== -[OMCHSPreview wallpaper]  va=0x1c7a0 size=16 types=@16@0:8
0x0001c7a0  adrp     x8, #0x8e000
0x0001c7a4  ldrsw    x8, [x8, #0xe38]
0x0001c7a8  ldr      x0, [x0, x8]
0x0001c7ac  ret      

=== -[OMCHSPreview setWallpaper:]  va=0x1c7b0 size=64 types=v24@0:8@16
0x0001c7b0  stp      x22, x21, [sp, #-0x30]!
0x0001c7b4  stp      x20, x19, [sp, #0x10]
0x0001c7b8  stp      x29, x30, [sp, #0x20]
0x0001c7bc  add      x29, sp, #0x20
0x0001c7c0  mov      x19, x2
0x0001c7c4  mov      x20, x0
0x0001c7c8  adrp     x8, #0x8e000
0x0001c7cc  ldrsw    x21, [x8, #0xe38]
0x0001c7d0  mov      x0, x2
0x0001c7d4  bl       #0x55d84   ; CALL _objc_retain
0x0001c7d8  ldr      x0, [x20, x21]
0x0001c7dc  str      x19, [x20, x21]
0x0001c7e0  ldp      x29, x30, [sp, #0x20]
0x0001c7e4  ldp      x20, x19, [sp, #0x10]
0x0001c7e8  ldp      x22, x21, [sp], #0x30
0x0001c7ec  b        #0x55d78   ; CALL _objc_release

=== -[OMCHSPreview size]  va=0x1c7f0 size=16 types=q16@0:8
0x0001c7f0  adrp     x8, #0x8e000
0x0001c7f4  ldrsw    x8, [x8, #0xe3c]
0x0001c7f8  ldr      x0, [x0, x8]
0x0001c7fc  ret      

=== -[OMCHSPreview setSize:]  va=0x1c800 size=16 types=v24@0:8q16
0x0001c800  adrp     x8, #0x8e000
0x0001c804  ldrsw    x8, [x8, #0xe3c]
0x0001c808  str      x2, [x0, x8]
0x0001c80c  ret      

=== -[OMCHSPreview blur]  va=0x1c810 size=16 types=q16@0:8
0x0001c810  adrp     x8, #0x8e000
0x0001c814  ldrsw    x8, [x8, #0xe40]
0x0001c818  ldr      x0, [x0, x8]
0x0001c81c  ret      

=== -[OMCHSPreview setBlur:]  va=0x1c820 size=16 types=v24@0:8q16
0x0001c820  adrp     x8, #0x8e000
0x0001c824  ldrsw    x8, [x8, #0xe40]
0x0001c828  str      x2, [x0, x8]
0x0001c82c  ret      

=== -[OMCHSPreview dim]  va=0x1c830 size=16 types=q16@0:8
0x0001c830  adrp     x8, #0x8e000
0x0001c834  ldrsw    x8, [x8, #0xe44]
0x0001c838  ldr      x0, [x0, x8]
0x0001c83c  ret      

=== -[OMCHSPreview setDim:]  va=0x1c840 size=16 types=v24@0:8q16
0x0001c840  adrp     x8, #0x8e000
0x0001c844  ldrsw    x8, [x8, #0xe44]
0x0001c848  str      x2, [x0, x8]
0x0001c84c  ret      

=== -[OMCHSPreview cols]  va=0x1c850 size=16 types=q16@0:8
0x0001c850  adrp     x8, #0x8e000
0x0001c854  ldrsw    x8, [x8, #0xe48]
0x0001c858  ldr      x0, [x0, x8]
0x0001c85c  ret      

=== -[OMCHSPreview setCols:]  va=0x1c860 size=16 types=v24@0:8q16
0x0001c860  adrp     x8, #0x8e000
0x0001c864  ldrsw    x8, [x8, #0xe48]
0x0001c868  str      x2, [x0, x8]
0x0001c86c  ret      

=== -[OMCHSPreview rows]  va=0x1c870 size=16 types=q16@0:8
0x0001c870  adrp     x8, #0x8e000
0x0001c874  ldrsw    x8, [x8, #0xe4c]
0x0001c878  ldr      x0, [x0, x8]
0x0001c87c  ret      

=== -[OMCHSPreview setRows:]  va=0x1c880 size=16 types=v24@0:8q16
0x0001c880  adrp     x8, #0x8e000
0x0001c884  ldrsw    x8, [x8, #0xe4c]
0x0001c888  str      x2, [x0, x8]
0x0001c88c  ret      

=== -[OMCHSPreview names]  va=0x1c890 size=16 types=B16@0:8
0x0001c890  adrp     x8, #0x8e000
0x0001c894  ldrsw    x8, [x8, #0xe50]
0x0001c898  ldrb     w0, [x0, x8]
0x0001c89c  ret      

=== -[OMCHSPreview setNames:]  va=0x1c8a0 size=16 types=v20@0:8B16
0x0001c8a0  adrp     x8, #0x8e000
0x0001c8a4  ldrsw    x8, [x8, #0xe50]
0x0001c8a8  strb     w2, [x0, x8]
0x0001c8ac  ret      

=== -[OMCHSPreview video]  va=0x1c8b0 size=16 types=B16@0:8
0x0001c8b0  adrp     x8, #0x8e000
0x0001c8b4  ldrsw    x8, [x8, #0xe54]
0x0001c8b8  ldrb     w0, [x0, x8]
0x0001c8bc  ret      

=== -[OMCHSPreview setVideo:]  va=0x1c8c0 size=16 types=v20@0:8B16
0x0001c8c0  adrp     x8, #0x8e000
0x0001c8c4  ldrsw    x8, [x8, #0xe54]
0x0001c8c8  strb     w2, [x0, x8]
0x0001c8cc  ret      

=== -[OMCHSPreview .cxx_destruct]  va=0x1c8d0 size=64 types=v16@0:8
0x0001c8d0  stp      x20, x19, [sp, #-0x20]!
0x0001c8d4  stp      x29, x30, [sp, #0x10]
0x0001c8d8  add      x29, sp, #0x10
0x0001c8dc  mov      x19, x0
0x0001c8e0  adrp     x8, #0x8e000
0x0001c8e4  ldrsw    x8, [x8, #0xe38]
0x0001c8e8  add      x0, x0, x8
0x0001c8ec  mov      x1, #0
0x0001c8f0  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0001c8f4  adrp     x8, #0x8e000
0x0001c8f8  ldrsw    x8, [x8, #0xe34]
0x0001c8fc  add      x0, x19, x8
0x0001c900  mov      x1, #0
0x0001c904  ldp      x29, x30, [sp, #0x10]
0x0001c908  ldp      x20, x19, [sp], #0x20
0x0001c90c  b        #0x55dcc   ; CALL _objc_storeStrong
