=== -[SPPBubbleView initWithFrame:]  va=0x2dc30 size=144 types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
0x0002dc30  sub      sp, sp, #0x30
0x0002dc34  stp      x20, x19, [sp, #0x10]
0x0002dc38  stp      x29, x30, [sp, #0x20]
0x0002dc3c  add      x29, sp, #0x20
0x0002dc40  adrp     x8, #0x8e000
0x0002dc44  ldr      x8, [x8, #0xd80]   ; @SUPER SPPBubbleView
0x0002dc48  stp      x0, x8, [sp]
0x0002dc4c  adrp     x8, #0x8c000
0x0002dc50  ldr      x1, [x8, #0x8c8]   ; @SEL "initWithFrame:"
0x0002dc54  mov      x0, sp
0x0002dc58  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0002dc5c  mov      x19, x0
0x0002dc60  cbz      x0, #0x2dcac
0x0002dc64  adrp     x8, #0x8e000
0x0002dc68  ldrsw    x8, [x8, #0xee0]
0x0002dc6c  mov      x9, #-1
0x0002dc70  str      x9, [x19, x8]
0x0002dc74  adrp     x8, #0x8e000
0x0002dc78  ldrsw    x8, [x8, #0xee4]
0x0002dc7c  mov      w9, #-1
0x0002dc80  str      w9, [x19, x8]
0x0002dc84  adrp     x8, #0x8e000
0x0002dc88  ldrsw    x8, [x8, #0xee8]
0x0002dc8c  str      w9, [x19, x8]
0x0002dc90  adrp     x8, #0x8e000
0x0002dc94  ldrsw    x8, [x8, #0xeec]
0x0002dc98  mov      w9, #1
0x0002dc9c  strb     w9, [x19, x8]
0x0002dca0  mov      x0, x19
0x0002dca4  mov      w2, #0
0x0002dca8  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x0002dcac  mov      x0, x19
0x0002dcb0  ldp      x29, x30, [sp, #0x20]
0x0002dcb4  ldp      x20, x19, [sp, #0x10]
0x0002dcb8  add      sp, sp, #0x30
0x0002dcbc  ret      

=== -[SPPBubbleView speedState]  va=0x2dcc0 size=184 types=i16@0:8
0x0002dcc0  stp      d9, d8, [sp, #-0x40]!
0x0002dcc4  stp      x22, x21, [sp, #0x10]
0x0002dcc8  stp      x20, x19, [sp, #0x20]
0x0002dccc  stp      x29, x30, [sp, #0x30]
0x0002dcd0  add      x29, sp, #0x30
0x0002dcd4  mov      x19, x0
0x0002dcd8  bl       #0x58c40   ; CALL objc_msgSend$limit
0x0002dcdc  cmp      w0, #1
0x0002dce0  b.lt     #0x2dd28
0x0002dce4  mov      x0, x19
0x0002dce8  bl       #0x5ce00   ; CALL objc_msgSend$speed
0x0002dcec  tbnz     w0, #0x1f, #0x2dd28
0x0002dcf0  mov      x0, x19
0x0002dcf4  bl       #0x56b20   ; CALL objc_msgSend$builtStyle
0x0002dcf8  mov      x21, x0
0x0002dcfc  mov      x0, x19
0x0002dd00  bl       #0x5ce00   ; CALL objc_msgSend$speed
0x0002dd04  mov      x20, x0
0x0002dd08  mov      x0, x19
0x0002dd0c  bl       #0x58c40   ; CALL objc_msgSend$limit
0x0002dd10  cmp      x21, #7
0x0002dd14  b.ne     #0x2dd30
0x0002dd18  cmp      w20, w0
0x0002dd1c  b.lt     #0x2dd38
0x0002dd20  mov      w0, #2
0x0002dd24  b        #0x2dd64
0x0002dd28  mov      w0, #0
0x0002dd2c  b        #0x2dd64
0x0002dd30  cmp      w20, w0
0x0002dd34  b.gt     #0x2dd20
0x0002dd38  mov      x0, x19
0x0002dd3c  bl       #0x5ce00   ; CALL objc_msgSend$speed
0x0002dd40  scvtf    d8, w0
0x0002dd44  mov      x0, x19
0x0002dd48  bl       #0x58c40   ; CALL objc_msgSend$limit
0x0002dd4c  scvtf    d0, w0
0x0002dd50  adrp     x8, #0x65000
0x0002dd54  ldr      d1, [x8, #0x708]
0x0002dd58  fmul     d0, d0, d1
0x0002dd5c  fcmp     d0, d8
0x0002dd60  cset     w0, ls
0x0002dd64  ldp      x29, x30, [sp, #0x30]
0x0002dd68  ldp      x20, x19, [sp, #0x20]
0x0002dd6c  ldp      x22, x21, [sp, #0x10]
0x0002dd70  ldp      d9, d8, [sp], #0x40
0x0002dd74  ret      

=== -[SPPBubbleView stateColor]  va=0x2dd78 size=132 types=@16@0:8
0x0002dd78  stp      x29, x30, [sp, #-0x10]!
0x0002dd7c  mov      x29, sp
0x0002dd80  bl       #0x5ce80   ; CALL objc_msgSend$speedState
0x0002dd84  mov      x8, x0
0x0002dd88  adrp     x9, #0x8e000
0x0002dd8c  ldr      x0, [x9, #0x910]   ; @CLASS UIColor
0x0002dd90  cmp      w8, #1
0x0002dd94  b.eq     #0x2ddb4
0x0002dd98  cmp      w8, #2
0x0002dd9c  b.ne     #0x2ddcc
0x0002dda0  adrp     x8, #0x65000
0x0002dda4  ldr      d1, [x8, #0xac0]
0x0002dda8  adrp     x8, #0x65000
0x0002ddac  ldr      d2, [x8, #0xac8]
0x0002ddb0  b        #0x2ddc4
0x0002ddb4  adrp     x8, #0x65000
0x0002ddb8  ldr      d1, [x8, #0xab0]
0x0002ddbc  adrp     x8, #0x65000
0x0002ddc0  ldr      d2, [x8, #0xab8]
0x0002ddc4  fmov     d0, #1.00000000
0x0002ddc8  b        #0x2dde4
0x0002ddcc  adrp     x8, #0x65000
0x0002ddd0  ldr      d0, [x8, #0x820]
0x0002ddd4  adrp     x8, #0x65000
0x0002ddd8  ldr      d1, [x8, #0xad0]
0x0002dddc  adrp     x8, #0x65000
0x0002dde0  ldr      d2, [x8, #0x928]
0x0002dde4  fmov     d3, #1.00000000
0x0002dde8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002ddec  mov      x29, x29
0x0002ddf0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ddf4  ldp      x29, x30, [sp], #0x10
0x0002ddf8  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[SPPBubbleView speedRatio]  va=0x2ddfc size=124 types=d16@0:8
0x0002ddfc  stp      d9, d8, [sp, #-0x30]!
0x0002de00  stp      x20, x19, [sp, #0x10]
0x0002de04  stp      x29, x30, [sp, #0x20]
0x0002de08  add      x29, sp, #0x20
0x0002de0c  mov      x19, x0
0x0002de10  bl       #0x5ce00   ; CALL objc_msgSend$speed
0x0002de14  cmp      w0, #1
0x0002de18  b.lt     #0x2de48
0x0002de1c  mov      x0, x19
0x0002de20  bl       #0x5ce00   ; CALL objc_msgSend$speed
0x0002de24  scvtf    d8, w0
0x0002de28  mov      x0, x19
0x0002de2c  bl       #0x58c40   ; CALL objc_msgSend$limit
0x0002de30  cmp      w0, #1
0x0002de34  b.lt     #0x2de50
0x0002de38  mov      x0, x19
0x0002de3c  bl       #0x58c40   ; CALL objc_msgSend$limit
0x0002de40  scvtf    d0, w0
0x0002de44  b        #0x2de58
0x0002de48  fmov     d0, xzr
0x0002de4c  b        #0x2de68
0x0002de50  mov      x8, #0x4064000000000000
0x0002de54  fmov     d0, x8
0x0002de58  fdiv     d0, d8, d0
0x0002de5c  fmov     d1, #1.00000000
0x0002de60  fcmp     d0, d1
0x0002de64  fcsel    d0, d1, d0, gt
0x0002de68  ldp      x29, x30, [sp, #0x20]
0x0002de6c  ldp      x20, x19, [sp, #0x10]
0x0002de70  ldp      d9, d8, [sp], #0x30
0x0002de74  ret      

=== -[SPPBubbleView bit:]  va=0x2de78 size=108 types=@24@0:8@16
0x0002de78  stp      x22, x21, [sp, #-0x30]!
0x0002de7c  stp      x20, x19, [sp, #0x10]
0x0002de80  stp      x29, x30, [sp, #0x20]
0x0002de84  add      x29, sp, #0x20
0x0002de88  mov      x19, x2
0x0002de8c  mov      x20, x0
0x0002de90  mov      x0, x2
0x0002de94  bl       #0x55d84   ; CALL _objc_retain
0x0002de98  mov      x0, x20
0x0002de9c  bl       #0x56920   ; CALL objc_msgSend$bits
0x0002dea0  mov      x29, x29
0x0002dea4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002dea8  mov      x20, x0
0x0002deac  mov      x2, x19
0x0002deb0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0002deb4  mov      x29, x29
0x0002deb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002debc  mov      x21, x0
0x0002dec0  mov      x0, x19
0x0002dec4  bl       #0x55d78   ; CALL _objc_release
0x0002dec8  mov      x0, x20
0x0002decc  bl       #0x55d78   ; CALL _objc_release
0x0002ded0  mov      x0, x21
0x0002ded4  ldp      x29, x30, [sp, #0x20]
0x0002ded8  ldp      x20, x19, [sp, #0x10]
0x0002dedc  ldp      x22, x21, [sp], #0x30
0x0002dee0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[SPPBubbleView addBit:to:]  va=0x2dee4 size=160 types=@32@0:8@16@24
0x0002dee4  stp      x22, x21, [sp, #-0x30]!
0x0002dee8  stp      x20, x19, [sp, #0x10]
0x0002deec  stp      x29, x30, [sp, #0x20]
0x0002def0  add      x29, sp, #0x20
0x0002def4  mov      x19, x3
0x0002def8  mov      x20, x2
0x0002defc  mov      x21, x0
0x0002df00  adrp     x8, #0x8e000
0x0002df04  ldr      x22, [x8, #0x918]   ; @CLASS UIView
0x0002df08  mov      x0, x3
0x0002df0c  bl       #0x55d84   ; CALL _objc_retain
0x0002df10  mov      x0, x20
0x0002df14  bl       #0x55d84   ; CALL _objc_retain
0x0002df18  mov      x0, x22
0x0002df1c  bl       #0x55c88   ; CALL _objc_alloc_init
0x0002df20  mov      x22, x0
0x0002df24  mov      w2, #0
0x0002df28  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x0002df2c  mov      x0, x19
0x0002df30  mov      x2, x22
0x0002df34  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002df38  mov      x0, x19
0x0002df3c  bl       #0x55d78   ; CALL _objc_release
0x0002df40  mov      x0, x21
0x0002df44  bl       #0x56920   ; CALL objc_msgSend$bits
0x0002df48  mov      x29, x29
0x0002df4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002df50  mov      x19, x0
0x0002df54  mov      x2, x22
0x0002df58  mov      x3, x20
0x0002df5c  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0002df60  mov      x0, x20
0x0002df64  bl       #0x55d78   ; CALL _objc_release
0x0002df68  mov      x0, x19
0x0002df6c  bl       #0x55d78   ; CALL _objc_release
0x0002df70  mov      x0, x22
0x0002df74  ldp      x29, x30, [sp, #0x20]
0x0002df78  ldp      x20, x19, [sp, #0x10]
0x0002df7c  ldp      x22, x21, [sp], #0x30
0x0002df80  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[SPPBubbleView shapePart:in:stroke:width:]  va=0x2df84 size=292 types=@48@0:8@16@24@32d40
0x0002df84  stp      d9, d8, [sp, #-0x50]!
0x0002df88  stp      x24, x23, [sp, #0x10]
0x0002df8c  stp      x22, x21, [sp, #0x20]
0x0002df90  stp      x20, x19, [sp, #0x30]
0x0002df94  stp      x29, x30, [sp, #0x40]
0x0002df98  add      x29, sp, #0x40
0x0002df9c  mov      v8.16b, v0.16b
0x0002dfa0  mov      x23, x4
0x0002dfa4  mov      x22, x3
0x0002dfa8  mov      x19, x2
0x0002dfac  mov      x20, x0
0x0002dfb0  adrp     x8, #0x8e000
0x0002dfb4  ldr      x21, [x8, #0xb48]   ; @CLASS CAShapeLayer
0x0002dfb8  mov      x0, x4
0x0002dfbc  bl       #0x55d84   ; CALL _objc_retain
0x0002dfc0  mov      x0, x22
0x0002dfc4  bl       #0x55d84   ; CALL _objc_retain
0x0002dfc8  mov      x0, x19
0x0002dfcc  bl       #0x55d84   ; CALL _objc_retain
0x0002dfd0  mov      x0, x21
0x0002dfd4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002dfd8  mov      x29, x29
0x0002dfdc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002dfe0  mov      x21, x0
0x0002dfe4  adrp     x8, #0x8e000
0x0002dfe8  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0002dfec  bl       #0x56de0   ; CALL objc_msgSend$clearColor
0x0002dff0  mov      x29, x29
0x0002dff4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002dff8  mov      x24, x0
0x0002dffc  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002e000  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002e004  mov      x2, x0
0x0002e008  mov      x0, x21
0x0002e00c  bl       #0x5ae40   ; CALL objc_msgSend$setFillColor:
0x0002e010  mov      x0, x24
0x0002e014  bl       #0x55d78   ; CALL _objc_release
0x0002e018  mov      x0, x23
0x0002e01c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002e020  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002e024  mov      x24, x0
0x0002e028  mov      x0, x23
0x0002e02c  bl       #0x55d78   ; CALL _objc_release
0x0002e030  mov      x0, x21
0x0002e034  mov      x2, x24
0x0002e038  bl       #0x5c380   ; CALL objc_msgSend$setStrokeColor:
0x0002e03c  mov      x0, x21
0x0002e040  mov      v0.16b, v8.16b
0x0002e044  bl       #0x5b3a0   ; CALL objc_msgSend$setLineWidth:
0x0002e048  mov      x0, x22
0x0002e04c  mov      x2, x21
0x0002e050  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0002e054  mov      x0, x22
0x0002e058  bl       #0x55d78   ; CALL _objc_release
0x0002e05c  mov      x0, x20
0x0002e060  bl       #0x595e0   ; CALL objc_msgSend$parts
0x0002e064  mov      x29, x29
0x0002e068  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e06c  mov      x20, x0
0x0002e070  mov      x2, x21
0x0002e074  mov      x3, x19
0x0002e078  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0002e07c  mov      x0, x19
0x0002e080  bl       #0x55d78   ; CALL _objc_release
0x0002e084  mov      x0, x20
0x0002e088  bl       #0x55d78   ; CALL _objc_release
0x0002e08c  mov      x0, x21
0x0002e090  ldp      x29, x30, [sp, #0x40]
0x0002e094  ldp      x20, x19, [sp, #0x30]
0x0002e098  ldp      x22, x21, [sp, #0x20]
0x0002e09c  ldp      x24, x23, [sp, #0x10]
0x0002e0a0  ldp      d9, d8, [sp], #0x50
0x0002e0a4  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[SPPBubbleView buildStyle:]  va=0x2e0a8 size=10120 types=v24@0:8q16
0x0002e0a8  stp      d13, d12, [sp, #-0x90]!
0x0002e0ac  stp      d11, d10, [sp, #0x10]
0x0002e0b0  stp      d9, d8, [sp, #0x20]
0x0002e0b4  stp      x28, x27, [sp, #0x30]
0x0002e0b8  stp      x26, x25, [sp, #0x40]
0x0002e0bc  stp      x24, x23, [sp, #0x50]
0x0002e0c0  stp      x22, x21, [sp, #0x60]
0x0002e0c4  stp      x20, x19, [sp, #0x70]
0x0002e0c8  stp      x29, x30, [sp, #0x80]
0x0002e0cc  add      x29, sp, #0x80
0x0002e0d0  sub      sp, sp, #0x310
0x0002e0d4  mov      x28, x2
0x0002e0d8  mov      x19, x0
0x0002e0dc  adrp     x8, #0x74000
0x0002e0e0  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0002e0e4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002e0e8  stur     x8, [x29, #-0x90]
0x0002e0ec  bl       #0x55d84   ; CALL _objc_retain
0x0002e0f0  movi     v0.16b, #0
0x0002e0f4  stp      q0, q0, [sp, #0xe0]
0x0002e0f8  stp      q0, q0, [sp, #0x100]
0x0002e0fc  mov      x0, x19
0x0002e100  bl       #0x5d700   ; CALL objc_msgSend$subviews
0x0002e104  mov      x29, x29
0x0002e108  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e10c  mov      x21, x0
0x0002e110  bl       #0x572e0   ; CALL objc_msgSend$copy
0x0002e114  mov      x20, x0
0x0002e118  mov      x0, x21
0x0002e11c  bl       #0x55d78   ; CALL _objc_release
0x0002e120  add      x2, sp, #0xe0
0x0002e124  add      x3, sp, #0x280
0x0002e128  mov      x0, x20
0x0002e12c  mov      w4, #0x10
0x0002e130  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0002e134  cbz      x0, #0x2e194
0x0002e138  mov      x21, x0
0x0002e13c  ldr      x8, [sp, #0xf0]
0x0002e140  ldr      x22, [x8]   ; @GOT ___objc_personality_v0
0x0002e144  mov      x23, #0
0x0002e148  ldr      x8, [sp, #0xf0]
0x0002e14c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002e150  cmp      x8, x22
0x0002e154  b.eq     #0x2e160
0x0002e158  mov      x0, x20
0x0002e15c  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0002e160  ldr      x8, [sp, #0xe8]
0x0002e164  ldr      x0, [x8, x23, lsl #3]   ; @GOT ___objc_personality_v0
0x0002e168  bl       #0x59e00   ; CALL objc_msgSend$removeFromSuperview
0x0002e16c  add      x23, x23, #1
0x0002e170  cmp      x21, x23
0x0002e174  b.ne     #0x2e148
0x0002e178  add      x2, sp, #0xe0
0x0002e17c  add      x3, sp, #0x280
0x0002e180  mov      x0, x20
0x0002e184  mov      w4, #0x10
0x0002e188  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0002e18c  mov      x21, x0
0x0002e190  cbnz     x0, #0x2e144
0x0002e194  mov      x0, x20
0x0002e198  bl       #0x55d78   ; CALL _objc_release
0x0002e19c  movi     v0.16b, #0
0x0002e1a0  stp      q0, q0, [sp, #0xc0]
0x0002e1a4  stp      q0, q0, [sp, #0xa0]
0x0002e1a8  mov      x0, x19
0x0002e1ac  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002e1b0  mov      x29, x29
0x0002e1b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e1b8  mov      x21, x0
0x0002e1bc  bl       #0x5d6a0   ; CALL objc_msgSend$sublayers
0x0002e1c0  mov      x29, x29
0x0002e1c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e1c8  mov      x22, x0
0x0002e1cc  bl       #0x572e0   ; CALL objc_msgSend$copy
0x0002e1d0  mov      x20, x0
0x0002e1d4  mov      x0, x22
0x0002e1d8  bl       #0x55d78   ; CALL _objc_release
0x0002e1dc  mov      x0, x21
0x0002e1e0  bl       #0x55d78   ; CALL _objc_release
0x0002e1e4  add      x2, sp, #0xa0
0x0002e1e8  add      x3, sp, #0x200
0x0002e1ec  mov      x0, x20
0x0002e1f0  mov      w4, #0x10
0x0002e1f4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0002e1f8  cbz      x0, #0x2e258
0x0002e1fc  mov      x21, x0
0x0002e200  ldr      x8, [sp, #0xb0]
0x0002e204  ldr      x22, [x8]   ; @GOT ___objc_personality_v0
0x0002e208  mov      x23, #0
0x0002e20c  ldr      x8, [sp, #0xb0]
0x0002e210  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002e214  cmp      x8, x22
0x0002e218  b.eq     #0x2e224
0x0002e21c  mov      x0, x20
0x0002e220  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0002e224  ldr      x8, [sp, #0xa8]
0x0002e228  ldr      x0, [x8, x23, lsl #3]   ; @GOT ___objc_personality_v0
0x0002e22c  bl       #0x59de0   ; CALL objc_msgSend$removeFromSuperlayer
0x0002e230  add      x23, x23, #1
0x0002e234  cmp      x21, x23
0x0002e238  b.ne     #0x2e20c
0x0002e23c  add      x2, sp, #0xa0
0x0002e240  add      x3, sp, #0x200
0x0002e244  mov      x0, x20
0x0002e248  mov      w4, #0x10
0x0002e24c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0002e250  mov      x21, x0
0x0002e254  cbnz     x0, #0x2e208
0x0002e258  mov      x0, x20
0x0002e25c  bl       #0x55d78   ; CALL _objc_release
0x0002e260  mov      x0, x19
0x0002e264  mov      x2, #0
0x0002e268  bl       #0x5af60   ; CALL objc_msgSend$setGlass:
0x0002e26c  mov      x0, x19
0x0002e270  mov      x2, #0
0x0002e274  bl       #0x5b060   ; CALL objc_msgSend$setIconView:
0x0002e278  mov      x0, x19
0x0002e27c  mov      x2, #0
0x0002e280  bl       #0x5c180   ; CALL objc_msgSend$setSign:
0x0002e284  mov      x0, x19
0x0002e288  mov      x2, #0
0x0002e28c  bl       #0x5ae80   ; CALL objc_msgSend$setFlashView:
0x0002e290  mov      x0, x19
0x0002e294  mov      x2, #0
0x0002e298  bl       #0x5ac80   ; CALL objc_msgSend$setDeco:
0x0002e29c  mov      x0, x19
0x0002e2a0  mov      x2, #0
0x0002e2a4  bl       #0x5c2a0   ; CALL objc_msgSend$setSpeedLabel:
0x0002e2a8  mov      x0, x19
0x0002e2ac  mov      x2, #0
0x0002e2b0  bl       #0x5c700   ; CALL objc_msgSend$setUnitLabel:
0x0002e2b4  mov      x0, x19
0x0002e2b8  mov      x2, #0
0x0002e2bc  bl       #0x5c520   ; CALL objc_msgSend$setTickLabels:
0x0002e2c0  adrp     x21, #0x8e000
0x0002e2c4  ldr      x0, [x21, #0x9d0]   ; @CLASS NSMutableDictionary
0x0002e2c8  bl       #0x57780   ; CALL objc_msgSend$dictionary
0x0002e2cc  mov      x29, x29
0x0002e2d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e2d4  mov      x20, x0
0x0002e2d8  mov      x0, x19
0x0002e2dc  mov      x2, x20
0x0002e2e0  bl       #0x5bb40   ; CALL objc_msgSend$setParts:
0x0002e2e4  mov      x0, x20
0x0002e2e8  bl       #0x55d78   ; CALL _objc_release
0x0002e2ec  ldr      x0, [x21, #0x9d0]   ; @CLASS NSMutableDictionary
0x0002e2f0  bl       #0x57780   ; CALL objc_msgSend$dictionary
0x0002e2f4  mov      x29, x29
0x0002e2f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e2fc  mov      x20, x0
0x0002e300  mov      x0, x19
0x0002e304  mov      x2, x20
0x0002e308  bl       #0x5a6c0   ; CALL objc_msgSend$setBits:
0x0002e30c  mov      x0, x20
0x0002e310  bl       #0x55d78   ; CALL _objc_release
0x0002e314  cmp      x28, #8
0x0002e318  csel     x26, xzr, x28, hi
0x0002e31c  adrp     x21, #0x8e000
0x0002e320  ldr      x0, [x21, #0x918]   ; @CLASS UIView
0x0002e324  bl       #0x55c88   ; CALL _objc_alloc_init
0x0002e328  mov      x23, x0
0x0002e32c  adrp     x22, #0x8e000
0x0002e330  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002e334  adrp     x8, #0x65000
0x0002e338  ldr      d8, [x8, #0xac0]
0x0002e33c  adrp     x8, #0x65000
0x0002e340  ldr      d9, [x8, #0xac8]
0x0002e344  fmov     d0, #1.00000000
0x0002e348  fmov     d3, #1.00000000
0x0002e34c  mov      v1.16b, v8.16b
0x0002e350  mov      v2.16b, v9.16b
0x0002e354  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002e358  mov      x29, x29
0x0002e35c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e360  mov      x20, x0
0x0002e364  mov      x0, x23
0x0002e368  mov      x2, x20
0x0002e36c  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0002e370  mov      x0, x20
0x0002e374  bl       #0x55d78   ; CALL _objc_release
0x0002e378  fmov     d0, xzr
0x0002e37c  mov      x0, x23
0x0002e380  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x0002e384  mov      x0, x23
0x0002e388  mov      w2, #0
0x0002e38c  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x0002e390  mov      x0, x19
0x0002e394  mov      x2, x23
0x0002e398  bl       #0x5ae80   ; CALL objc_msgSend$setFlashView:
0x0002e39c  adrp     x8, #0x8e000
0x0002e3a0  ldr      x0, [x8, #0xbc0]   ; @CLASS SPPGlassView
0x0002e3a4  bl       #0x55c88   ; CALL _objc_alloc_init
0x0002e3a8  mov      x27, x0
0x0002e3ac  cmp      x28, #7
0x0002e3b0  b.hi     #0x2ee00
0x0002e3b4  mov      w8, #1
0x0002e3b8  lsl      x8, x8, x28
0x0002e3bc  mov      w9, #0xd2
0x0002e3c0  tst      x8, x9
0x0002e3c4  b.eq     #0x2ee00
0x0002e3c8  mov      x0, x19
0x0002e3cc  mov      x2, x27
0x0002e3d0  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002e3d4  mov      x0, x27
0x0002e3d8  mov      x2, x23
0x0002e3dc  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002e3e0  cmp      x26, #5
0x0002e3e4  ccmp     x26, #8, #4, ne
0x0002e3e8  cset     w2, eq
0x0002e3ec  mov      x0, x27
0x0002e3f0  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x0002e3f4  mov      x0, x19
0x0002e3f8  mov      x2, x27
0x0002e3fc  bl       #0x5af60   ; CALL objc_msgSend$setGlass:
0x0002e400  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002e404  adrp     x8, #0x65000
0x0002e408  ldr      d13, [x8, #0x820]
0x0002e40c  adrp     x8, #0x65000
0x0002e410  ldr      d12, [x8, #0xad0]
0x0002e414  adrp     x8, #0x65000
0x0002e418  ldr      d11, [x8, #0x928]
0x0002e41c  fmov     d3, #1.00000000
0x0002e420  mov      v0.16b, v13.16b
0x0002e424  mov      v1.16b, v12.16b
0x0002e428  mov      v2.16b, v11.16b
0x0002e42c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002e430  mov      x29, x29
0x0002e434  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e438  str      x0, [sp, #0x58]
0x0002e43c  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002e440  adrp     x8, #0x65000
0x0002e444  ldr      d10, [x8, #0x838]
0x0002e448  mov      v0.16b, v13.16b
0x0002e44c  mov      v1.16b, v12.16b
0x0002e450  mov      v2.16b, v11.16b
0x0002e454  mov      v3.16b, v10.16b
0x0002e458  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002e45c  mov      x29, x29
0x0002e460  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e464  mov      x25, x0
0x0002e468  cmp      x26, #3
0x0002e46c  str      x27, [sp, #0x48]
0x0002e470  b.le     #0x2e668
0x0002e474  cmp      x26, #5
0x0002e478  str      x28, [sp, #0x38]
0x0002e47c  b.le     #0x2e878
0x0002e480  str      x25, [sp, #0x50]
0x0002e484  cmp      x26, #6
0x0002e488  b.eq     #0x2ee18
0x0002e48c  cmp      x26, #7
0x0002e490  b.ne     #0x2f7b4
0x0002e494  adrp     x2, #0x7b000
0x0002e498  add      x2, x2, #0x1c8   ; STR "ticks"
0x0002e49c  mov      x0, x19
0x0002e4a0  mov      x3, x19
0x0002e4a4  bl       #0x56080   ; CALL objc_msgSend$addBit:to:
0x0002e4a8  mov      x29, x29
0x0002e4ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e4b0  mov      x24, x0
0x0002e4b4  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002e4b8  fmov     d3, #1.00000000
0x0002e4bc  mov      v0.16b, v13.16b
0x0002e4c0  mov      v1.16b, v12.16b
0x0002e4c4  mov      v2.16b, v11.16b
0x0002e4c8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002e4cc  mov      x29, x29
0x0002e4d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e4d4  mov      x20, x0
0x0002e4d8  adrp     x8, #0x65000
0x0002e4dc  ldr      d0, [x8, #0xb08]
0x0002e4e0  bl       #0x56e80   ; CALL objc_msgSend$colorWithAlphaComponent:
0x0002e4e4  mov      x29, x29
0x0002e4e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e4ec  mov      x21, x0
0x0002e4f0  mov      x0, x24
0x0002e4f4  mov      x2, x21
0x0002e4f8  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0002e4fc  mov      x0, x21
0x0002e500  bl       #0x55d78   ; CALL _objc_release
0x0002e504  mov      x0, x20
0x0002e508  bl       #0x55d78   ; CALL _objc_release
0x0002e50c  adrp     x8, #0x8e000
0x0002e510  ldr      x0, [x8, #0xb48]   ; @CLASS CAShapeLayer
0x0002e514  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002e518  mov      x29, x29
0x0002e51c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e520  mov      x27, x0
0x0002e524  mov      x0, x24
0x0002e528  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002e52c  mov      x29, x29
0x0002e530  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e534  mov      x20, x0
0x0002e538  mov      x2, x27
0x0002e53c  bl       #0x5b4c0   ; CALL objc_msgSend$setMask:
0x0002e540  mov      x0, x20
0x0002e544  bl       #0x55d78   ; CALL _objc_release
0x0002e548  mov      x0, x19
0x0002e54c  bl       #0x595e0   ; CALL objc_msgSend$parts
0x0002e550  mov      x29, x29
0x0002e554  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e558  mov      x20, x0
0x0002e55c  adrp     x3, #0x7b000
0x0002e560  add      x3, x3, #0x1e8   ; STR "ticksMask"
0x0002e564  mov      x2, x27
0x0002e568  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0002e56c  mov      x0, x20
0x0002e570  bl       #0x55d78   ; CALL _objc_release
0x0002e574  adrp     x2, #0x7b000
0x0002e578  add      x2, x2, #0x148   ; STR "fill"
0x0002e57c  mov      x0, x19
0x0002e580  mov      x3, x24
0x0002e584  bl       #0x56080   ; CALL objc_msgSend$addBit:to:
0x0002e588  mov      x29, x29
0x0002e58c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e590  mov      x20, x0
0x0002e594  mov      w2, #1
0x0002e598  bl       #0x5a8a0   ; CALL objc_msgSend$setClipsToBounds:
0x0002e59c  adrp     x8, #0x8e000
0x0002e5a0  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x0002e5a4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002e5a8  mov      x29, x29
0x0002e5ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e5b0  mov      x25, x0
0x0002e5b4  fmov     d0, xzr
0x0002e5b8  fmov     d1, #0.50000000
0x0002e5bc  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x0002e5c0  fmov     d0, #1.00000000
0x0002e5c4  fmov     d1, #0.50000000
0x0002e5c8  mov      x0, x25
0x0002e5cc  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x0002e5d0  bl       #0x304f4
0x0002e5d4  mov      x29, x29
0x0002e5d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e5dc  mov      x21, x0
0x0002e5e0  mov      x0, x25
0x0002e5e4  mov      x2, x21
0x0002e5e8  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0002e5ec  mov      x0, x21
0x0002e5f0  bl       #0x55d78   ; CALL _objc_release
0x0002e5f4  mov      x0, x20
0x0002e5f8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002e5fc  mov      x29, x29
0x0002e600  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e604  mov      x21, x0
0x0002e608  mov      x2, x25
0x0002e60c  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0002e610  mov      x0, x21
0x0002e614  bl       #0x55d78   ; CALL _objc_release
0x0002e618  mov      x0, x19
0x0002e61c  bl       #0x595e0   ; CALL objc_msgSend$parts
0x0002e620  mov      x29, x29
0x0002e624  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e628  mov      x21, x0
0x0002e62c  adrp     x3, #0x7b000
0x0002e630  add      x3, x3, #0x188   ; STR "fillGrad"
0x0002e634  mov      x2, x25
0x0002e638  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0002e63c  mov      x0, x21
0x0002e640  mov      x21, x27
0x0002e644  bl       #0x55d78   ; CALL _objc_release
0x0002e648  mov      x0, x25
0x0002e64c  bl       #0x55d78   ; CALL _objc_release
0x0002e650  mov      x0, x20
0x0002e654  bl       #0x55d78   ; CALL _objc_release
0x0002e658  fmov     d9, #30.00000000
0x0002e65c  fmov     d8, #10.00000000
0x0002e660  ldr      x28, [sp, #0x38]
0x0002e664  b        #0x2f20c
0x0002e668  cmp      x26, #1
0x0002e66c  b.gt     #0x2e800
0x0002e670  str      x25, [sp, #0x50]
0x0002e674  cbnz     x26, #0x2f124
0x0002e678  fmov     d0, #3.00000000
0x0002e67c  mov      w0, #1
0x0002e680  bl       #0x3036c
0x0002e684  mov      x29, x29
0x0002e688  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e68c  mov      x24, x0
0x0002e690  mov      x0, x27
0x0002e694  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002e698  mov      x29, x29
0x0002e69c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e6a0  mov      x20, x0
0x0002e6a4  mov      x2, x24
0x0002e6a8  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0002e6ac  mov      x0, x20
0x0002e6b0  bl       #0x55d78   ; CALL _objc_release
0x0002e6b4  mov      x0, x19
0x0002e6b8  bl       #0x595e0   ; CALL objc_msgSend$parts
0x0002e6bc  mov      x29, x29
0x0002e6c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e6c4  mov      x20, x0
0x0002e6c8  adrp     x3, #0x7b000
0x0002e6cc  add      x3, x3, #0x88   ; STR "ring"
0x0002e6d0  mov      x2, x24
0x0002e6d4  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0002e6d8  mov      x0, x20
0x0002e6dc  bl       #0x55d78   ; CALL _objc_release
0x0002e6e0  adrp     x8, #0x8e000
0x0002e6e4  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x0002e6e8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002e6ec  mov      x29, x29
0x0002e6f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e6f4  mov      x27, x0
0x0002e6f8  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002e6fc  fmov     d0, #1.00000000
0x0002e700  fmov     d1, #0.75000000
0x0002e704  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0002e708  mov      x29, x29
0x0002e70c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e710  mov      x20, x0
0x0002e714  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002e718  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002e71c  str      x0, [sp, #0x1f0]
0x0002e720  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002e724  fmov     d0, #1.00000000
0x0002e728  fmov     d1, xzr
0x0002e72c  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0002e730  mov      x29, x29
0x0002e734  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e738  mov      x25, x0
0x0002e73c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002e740  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002e744  str      x0, [sp, #0x1f8]
0x0002e748  adrp     x8, #0x8e000
0x0002e74c  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0002e750  add      x2, sp, #0x1f0
0x0002e754  mov      w3, #2
0x0002e758  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0002e75c  mov      x29, x29
0x0002e760  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e764  mov      x21, x28
0x0002e768  mov      x28, x0
0x0002e76c  mov      x0, x27
0x0002e770  mov      x2, x28
0x0002e774  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0002e778  mov      x0, x28
0x0002e77c  mov      x28, x21
0x0002e780  mov      x21, x27
0x0002e784  bl       #0x55d78   ; CALL _objc_release
0x0002e788  mov      x0, x25
0x0002e78c  bl       #0x55d78   ; CALL _objc_release
0x0002e790  mov      x0, x20
0x0002e794  bl       #0x55d78   ; CALL _objc_release
0x0002e798  mov      x0, x27
0x0002e79c  mov      w2, #1
0x0002e7a0  bl       #0x5b520   ; CALL objc_msgSend$setMasksToBounds:
0x0002e7a4  ldr      x0, [sp, #0x48]
0x0002e7a8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002e7ac  mov      x29, x29
0x0002e7b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e7b4  mov      x20, x0
0x0002e7b8  mov      x2, x27
0x0002e7bc  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0002e7c0  mov      x0, x20
0x0002e7c4  bl       #0x55d78   ; CALL _objc_release
0x0002e7c8  mov      x0, x19
0x0002e7cc  bl       #0x595e0   ; CALL objc_msgSend$parts
0x0002e7d0  mov      x29, x29
0x0002e7d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e7d8  mov      x20, x0
0x0002e7dc  adrp     x3, #0x7b000
0x0002e7e0  add      x3, x3, #0xa8   ; STR "shine"
0x0002e7e4  mov      x2, x27
0x0002e7e8  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0002e7ec  mov      x0, x20
0x0002e7f0  bl       #0x55d78   ; CALL _objc_release
0x0002e7f4  fmov     d8, #10.00000000
0x0002e7f8  mov      x8, #0x4042000000000000
0x0002e7fc  b        #0x2f208
0x0002e800  cmp      x26, #2
0x0002e804  b.ne     #0x2f214
0x0002e808  mov      x0, x27
0x0002e80c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002e810  mov      x29, x29
0x0002e814  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e818  mov      x24, x0
0x0002e81c  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002e820  adrp     x8, #0x65000
0x0002e824  ldr      d1, [x8, #0xab0]
0x0002e828  adrp     x8, #0x65000
0x0002e82c  ldr      d2, [x8, #0xab8]
0x0002e830  fmov     d0, #1.00000000
0x0002e834  fmov     d3, #1.00000000
0x0002e838  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002e83c  mov      x29, x29
0x0002e840  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e844  mov      x21, x0
0x0002e848  adrp     x2, #0x7b000
0x0002e84c  add      x2, x2, #0x108   ; STR "nearRing"
0x0002e850  fmov     d0, #3.00000000
0x0002e854  mov      x0, x19
0x0002e858  mov      x3, x24
0x0002e85c  mov      x4, x21
0x0002e860  bl       #0x5c960   ; CALL objc_msgSend$shapePart:in:stroke:width:
0x0002e864  mov      x29, x29
0x0002e868  bl       #0x55dfc   ; CALL _objc_unsafeClaimAutoreleasedReturnValue
0x0002e86c  fmov     d9, #30.00000000
0x0002e870  fmov     d8, #10.00000000
0x0002e874  b        #0x2f33c
0x0002e878  str      x23, [sp, #0x30]
0x0002e87c  str      x26, [sp, #0x40]
0x0002e880  cmp      x26, #4
0x0002e884  b.ne     #0x300bc
0x0002e888  mov      x0, x27
0x0002e88c  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0002e890  mov      x29, x29
0x0002e894  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e898  mov      x20, x0
0x0002e89c  fmov     d0, xzr
0x0002e8a0  fmov     d1, xzr
0x0002e8a4  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x0002e8a8  mov      x0, x20
0x0002e8ac  bl       #0x55d78   ; CALL _objc_release
0x0002e8b0  mov      x0, x27
0x0002e8b4  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0002e8b8  mov      x29, x29
0x0002e8bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e8c0  mov      x20, x0
0x0002e8c4  fmov     d0, #1.00000000
0x0002e8c8  fmov     d1, #1.00000000
0x0002e8cc  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x0002e8d0  mov      x0, x20
0x0002e8d4  bl       #0x55d78   ; CALL _objc_release
0x0002e8d8  adrp     x8, #0x8e000
0x0002e8dc  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x0002e8e0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002e8e4  mov      x29, x29
0x0002e8e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e8ec  mov      x24, x0
0x0002e8f0  fmov     d0, #1.00000000
0x0002e8f4  fmov     d1, xzr
0x0002e8f8  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x0002e8fc  fmov     d0, xzr
0x0002e900  fmov     d1, #1.00000000
0x0002e904  mov      x0, x24
0x0002e908  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x0002e90c  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002e910  adrp     x8, #0x65000
0x0002e914  ldr      d9, [x8, #0x880]
0x0002e918  adrp     x8, #0x65000
0x0002e91c  ldr      d11, [x8, #0x7d0]
0x0002e920  adrp     x8, #0x65000
0x0002e924  ldr      d12, [x8, #0x888]
0x0002e928  adrp     x8, #0x65000
0x0002e92c  ldr      d8, [x8, #0x708]
0x0002e930  mov      v0.16b, v9.16b
0x0002e934  mov      v1.16b, v11.16b
0x0002e938  mov      v2.16b, v12.16b
0x0002e93c  mov      v3.16b, v8.16b
0x0002e940  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002e944  mov      x29, x29
0x0002e948  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e94c  mov      x20, x0
0x0002e950  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002e954  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002e958  str      x0, [sp, #0x1d0]
0x0002e95c  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002e960  fmov     d3, xzr
0x0002e964  mov      v0.16b, v9.16b
0x0002e968  mov      v1.16b, v11.16b
0x0002e96c  mov      v2.16b, v12.16b
0x0002e970  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002e974  mov      x29, x29
0x0002e978  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e97c  mov      x26, x27
0x0002e980  mov      x27, x0
0x0002e984  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002e988  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002e98c  str      x0, [sp, #0x1d8]
0x0002e990  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002e994  adrp     x8, #0x65000
0x0002e998  ldr      d9, [x8, #0x890]
0x0002e99c  adrp     x8, #0x65000
0x0002e9a0  ldr      d11, [x8, #0x898]
0x0002e9a4  adrp     x8, #0x65000
0x0002e9a8  ldr      d12, [x8, #0x8a0]
0x0002e9ac  fmov     d3, xzr
0x0002e9b0  mov      v0.16b, v9.16b
0x0002e9b4  mov      v1.16b, v11.16b
0x0002e9b8  mov      v2.16b, v12.16b
0x0002e9bc  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002e9c0  mov      x29, x29
0x0002e9c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e9c8  mov      x23, x25
0x0002e9cc  mov      x25, x0
0x0002e9d0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002e9d4  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002e9d8  str      x0, [sp, #0x1e0]
0x0002e9dc  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002e9e0  mov      v0.16b, v9.16b
0x0002e9e4  mov      v1.16b, v11.16b
0x0002e9e8  mov      v2.16b, v12.16b
0x0002e9ec  mov      v3.16b, v8.16b
0x0002e9f0  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002e9f4  mov      x29, x29
0x0002e9f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002e9fc  mov      x28, x0
0x0002ea00  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002ea04  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002ea08  str      x0, [sp, #0x1e8]
0x0002ea0c  adrp     x8, #0x8e000
0x0002ea10  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0002ea14  add      x2, sp, #0x1d0
0x0002ea18  mov      w3, #4
0x0002ea1c  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0002ea20  mov      x29, x29
0x0002ea24  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ea28  mov      x21, x0
0x0002ea2c  mov      x0, x24
0x0002ea30  mov      x2, x21
0x0002ea34  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0002ea38  mov      x0, x21
0x0002ea3c  bl       #0x55d78   ; CALL _objc_release
0x0002ea40  mov      x0, x28
0x0002ea44  bl       #0x55d78   ; CALL _objc_release
0x0002ea48  mov      x0, x25
0x0002ea4c  bl       #0x55d78   ; CALL _objc_release
0x0002ea50  mov      x0, x27
0x0002ea54  bl       #0x55d78   ; CALL _objc_release
0x0002ea58  mov      x0, x20
0x0002ea5c  bl       #0x55d78   ; CALL _objc_release
0x0002ea60  adrp     x2, #0x7f000
0x0002ea64  add      x2, x2, #0xba0
0x0002ea68  mov      x0, x24
0x0002ea6c  bl       #0x5b480   ; CALL objc_msgSend$setLocations:
0x0002ea70  mov      x0, x26
0x0002ea74  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0002ea78  mov      x29, x29
0x0002ea7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ea80  mov      x20, x0
0x0002ea84  mov      x2, x24
0x0002ea88  mov      w3, #0
0x0002ea8c  bl       #0x58680   ; CALL objc_msgSend$insertSublayer:atIndex:
0x0002ea90  mov      x0, x20
0x0002ea94  bl       #0x55d78   ; CALL _objc_release
0x0002ea98  mov      x0, x19
0x0002ea9c  bl       #0x595e0   ; CALL objc_msgSend$parts
0x0002eaa0  mov      x29, x29
0x0002eaa4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002eaa8  mov      x20, x0
0x0002eaac  adrp     x3, #0x7b000
0x0002eab0  add      x3, x3, #0x168   ; STR "mesh"
0x0002eab4  mov      x2, x24
0x0002eab8  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0002eabc  mov      x0, x20
0x0002eac0  bl       #0x55d78   ; CALL _objc_release
0x0002eac4  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002eac8  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0002eacc  mov      x29, x29
0x0002ead0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ead4  mov      x20, x0
0x0002ead8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002eadc  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002eae0  mov      x21, x0
0x0002eae4  mov      x0, x26
0x0002eae8  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0002eaec  mov      x29, x29
0x0002eaf0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002eaf4  mov      x25, x0
0x0002eaf8  mov      x2, x21
0x0002eafc  bl       #0x5a700   ; CALL objc_msgSend$setBorderColor:
0x0002eb00  mov      x0, x25
0x0002eb04  bl       #0x55d78   ; CALL _objc_release
0x0002eb08  mov      x0, x20
0x0002eb0c  bl       #0x55d78   ; CALL _objc_release
0x0002eb10  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002eb14  adrp     x8, #0x65000
0x0002eb18  ldr      d0, [x8, #0xb20]
0x0002eb1c  adrp     x8, #0x65000
0x0002eb20  ldr      d1, [x8, #0x648]
0x0002eb24  adrp     x8, #0x65000
0x0002eb28  ldr      d2, [x8, #0xb28]
0x0002eb2c  fmov     d3, #1.00000000
0x0002eb30  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002eb34  mov      x29, x29
0x0002eb38  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002eb3c  mov      x20, x0
0x0002eb40  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002eb44  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002eb48  mov      x21, x0
0x0002eb4c  mov      x0, x26
0x0002eb50  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002eb54  mov      x29, x29
0x0002eb58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002eb5c  mov      x25, x0
0x0002eb60  mov      x2, x21
0x0002eb64  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x0002eb68  mov      x0, x25
0x0002eb6c  bl       #0x55d78   ; CALL _objc_release
0x0002eb70  mov      x0, x20
0x0002eb74  bl       #0x55d78   ; CALL _objc_release
0x0002eb78  mov      x0, x26
0x0002eb7c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002eb80  mov      x29, x29
0x0002eb84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002eb88  mov      x20, x0
0x0002eb8c  adrp     x8, #0x65000
0x0002eb90  ldr      s0, [x8, #0xd14]
0x0002eb94  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x0002eb98  mov      x0, x20
0x0002eb9c  bl       #0x55d78   ; CALL _objc_release
0x0002eba0  mov      x0, x26
0x0002eba4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002eba8  mov      x29, x29
0x0002ebac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ebb0  mov      x20, x0
0x0002ebb4  fmov     d0, #12.00000000
0x0002ebb8  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x0002ebbc  mov      x0, x20
0x0002ebc0  bl       #0x55d78   ; CALL _objc_release
0x0002ebc4  adrp     x2, #0x7b000
0x0002ebc8  add      x2, x2, #0x128   ; STR "track"
0x0002ebcc  mov      x0, x19
0x0002ebd0  mov      x3, x19
0x0002ebd4  bl       #0x56080   ; CALL objc_msgSend$addBit:to:
0x0002ebd8  mov      x29, x29
0x0002ebdc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ebe0  mov      x27, x0
0x0002ebe4  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002ebe8  fmov     d0, #1.00000000
0x0002ebec  mov      v1.16b, v10.16b
0x0002ebf0  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0002ebf4  mov      x29, x29
0x0002ebf8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ebfc  mov      x20, x0
0x0002ec00  mov      x0, x27
0x0002ec04  mov      x2, x20
0x0002ec08  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0002ec0c  mov      x0, x20
0x0002ec10  bl       #0x55d78   ; CALL _objc_release
0x0002ec14  mov      x0, x27
0x0002ec18  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002ec1c  mov      x29, x29
0x0002ec20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ec24  mov      x20, x0
0x0002ec28  fmov     d0, #3.00000000
0x0002ec2c  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0002ec30  mov      x0, x20
0x0002ec34  bl       #0x55d78   ; CALL _objc_release
0x0002ec38  mov      x0, x27
0x0002ec3c  mov      w2, #1
0x0002ec40  bl       #0x5a8a0   ; CALL objc_msgSend$setClipsToBounds:
0x0002ec44  adrp     x2, #0x7b000
0x0002ec48  add      x2, x2, #0x148   ; STR "fill"
0x0002ec4c  mov      x0, x19
0x0002ec50  mov      x3, x27
0x0002ec54  bl       #0x56080   ; CALL objc_msgSend$addBit:to:
0x0002ec58  mov      x29, x29
0x0002ec5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ec60  mov      x28, x0
0x0002ec64  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002ec68  mov      x29, x29
0x0002ec6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ec70  mov      x20, x0
0x0002ec74  fmov     d0, #3.00000000
0x0002ec78  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0002ec7c  mov      x0, x20
0x0002ec80  bl       #0x55d78   ; CALL _objc_release
0x0002ec84  mov      x0, x28
0x0002ec88  mov      w2, #1
0x0002ec8c  bl       #0x5a8a0   ; CALL objc_msgSend$setClipsToBounds:
0x0002ec90  adrp     x8, #0x8e000
0x0002ec94  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x0002ec98  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002ec9c  mov      x29, x29
0x0002eca0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002eca4  mov      x20, x0
0x0002eca8  fmov     d0, xzr
0x0002ecac  fmov     d1, #0.50000000
0x0002ecb0  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x0002ecb4  fmov     d0, #1.00000000
0x0002ecb8  fmov     d1, #0.50000000
0x0002ecbc  mov      x0, x20
0x0002ecc0  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x0002ecc4  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002ecc8  adrp     x8, #0x65000
0x0002eccc  ldr      d0, [x8, #0xb30]
0x0002ecd0  adrp     x8, #0x65000
0x0002ecd4  ldr      d1, [x8, #0xb38]
0x0002ecd8  adrp     x8, #0x65000
0x0002ecdc  ldr      d2, [x8, #0xb40]
0x0002ece0  fmov     d3, #1.00000000
0x0002ece4  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002ece8  mov      x29, x29
0x0002ecec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ecf0  mov      x25, x0
0x0002ecf4  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002ecf8  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002ecfc  str      x0, [sp, #0x1c0]
0x0002ed00  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002ed04  adrp     x8, #0x65000
0x0002ed08  ldr      d0, [x8, #0xb48]
0x0002ed0c  adrp     x8, #0x65000
0x0002ed10  ldr      d1, [x8, #0xb50]
0x0002ed14  adrp     x8, #0x65000
0x0002ed18  ldr      d2, [x8, #0xb58]
0x0002ed1c  fmov     d3, #1.00000000
0x0002ed20  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002ed24  mov      x29, x29
0x0002ed28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ed2c  mov      x21, x0
0x0002ed30  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002ed34  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002ed38  str      x0, [sp, #0x1c8]
0x0002ed3c  adrp     x8, #0x8e000
0x0002ed40  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0002ed44  add      x2, sp, #0x1c0
0x0002ed48  mov      w3, #2
0x0002ed4c  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0002ed50  mov      x29, x29
0x0002ed54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ed58  mov      x26, x0
0x0002ed5c  mov      x0, x20
0x0002ed60  mov      x2, x26
0x0002ed64  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0002ed68  mov      x0, x26
0x0002ed6c  bl       #0x55d78   ; CALL _objc_release
0x0002ed70  mov      x0, x21
0x0002ed74  bl       #0x55d78   ; CALL _objc_release
0x0002ed78  mov      x0, x25
0x0002ed7c  mov      x25, x23
0x0002ed80  bl       #0x55d78   ; CALL _objc_release
0x0002ed84  mov      x0, x28
0x0002ed88  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002ed8c  mov      x29, x29
0x0002ed90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ed94  mov      x21, x0
0x0002ed98  mov      x2, x20
0x0002ed9c  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0002eda0  mov      x0, x21
0x0002eda4  bl       #0x55d78   ; CALL _objc_release
0x0002eda8  mov      x0, x19
0x0002edac  bl       #0x595e0   ; CALL objc_msgSend$parts
0x0002edb0  mov      x29, x29
0x0002edb4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002edb8  mov      x21, x0
0x0002edbc  adrp     x3, #0x7b000
0x0002edc0  add      x3, x3, #0x188   ; STR "fillGrad"
0x0002edc4  mov      x2, x20
0x0002edc8  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0002edcc  mov      x0, x21
0x0002edd0  mov      x21, x27
0x0002edd4  bl       #0x55d78   ; CALL _objc_release
0x0002edd8  mov      x0, x20
0x0002eddc  bl       #0x55d78   ; CALL _objc_release
0x0002ede0  mov      x0, x28
0x0002ede4  bl       #0x55d78   ; CALL _objc_release
0x0002ede8  fmov     d8, #10.00000000
0x0002edec  mov      x8, #0x4044000000000000
0x0002edf0  fmov     d9, x8
0x0002edf4  ldp      x23, x28, [sp, #0x30]
0x0002edf8  ldr      x26, [sp, #0x40]
0x0002edfc  b        #0x2f33c
0x0002ee00  mov      x0, x19
0x0002ee04  mov      x2, x23
0x0002ee08  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002ee0c  mov      x0, x19
0x0002ee10  mov      x2, x27
0x0002ee14  b        #0x2e3dc
0x0002ee18  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002ee1c  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0002ee20  mov      x29, x29
0x0002ee24  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ee28  mov      x28, x0
0x0002ee2c  ldr      x0, [sp, #0x58]
0x0002ee30  bl       #0x55d78   ; CALL _objc_release
0x0002ee34  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002ee38  adrp     x8, #0x65000
0x0002ee3c  ldr      d1, [x8, #0x6e8]
0x0002ee40  fmov     d0, #1.00000000
0x0002ee44  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0002ee48  mov      x29, x29
0x0002ee4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ee50  mov      x25, x26
0x0002ee54  mov      x26, x0
0x0002ee58  ldr      x0, [sp, #0x50]
0x0002ee5c  bl       #0x55d78   ; CALL _objc_release
0x0002ee60  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002ee64  adrp     x8, #0x65000
0x0002ee68  ldr      d0, [x8, #0xb10]
0x0002ee6c  adrp     x8, #0x65000
0x0002ee70  ldr      d8, [x8, #0xa88]
0x0002ee74  adrp     x8, #0x65000
0x0002ee78  ldr      d2, [x8, #0x8d0]
0x0002ee7c  adrp     x8, #0x65000
0x0002ee80  ldr      d3, [x8, #0xb18]
0x0002ee84  mov      v1.16b, v8.16b
0x0002ee88  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002ee8c  mov      x29, x29
0x0002ee90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ee94  mov      x20, x0
0x0002ee98  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002ee9c  adrp     x8, #0x65000
0x0002eea0  ldr      d0, [x8, #0xae8]
0x0002eea4  adrp     x8, #0x65000
0x0002eea8  ldr      d1, [x8, #0xaf0]
0x0002eeac  adrp     x8, #0x65000
0x0002eeb0  ldr      d3, [x8, #0x6b0]
0x0002eeb4  mov      v2.16b, v8.16b
0x0002eeb8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002eebc  mov      x29, x29
0x0002eec0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002eec4  mov      x21, x0
0x0002eec8  mov      x0, x27
0x0002eecc  mov      x2, x20
0x0002eed0  mov      x3, x21
0x0002eed4  bl       #0x5c680   ; CALL objc_msgSend$setTop:bottom:
0x0002eed8  mov      x0, x21
0x0002eedc  bl       #0x55d78   ; CALL _objc_release
0x0002eee0  mov      x0, x20
0x0002eee4  bl       #0x55d78   ; CALL _objc_release
0x0002eee8  mov      x0, x27
0x0002eeec  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0002eef0  mov      x29, x29
0x0002eef4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002eef8  mov      x20, x0
0x0002eefc  fmov     d0, xzr
0x0002ef00  bl       #0x5a740   ; CALL objc_msgSend$setBorderWidth:
0x0002ef04  mov      x0, x20
0x0002ef08  bl       #0x55d78   ; CALL _objc_release
0x0002ef0c  mov      x0, x27
0x0002ef10  bl       #0x5c9a0   ; CALL objc_msgSend$sheen
0x0002ef14  mov      x29, x29
0x0002ef18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ef1c  mov      x20, x0
0x0002ef20  mov      w2, #1
0x0002ef24  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x0002ef28  mov      x0, x20
0x0002ef2c  bl       #0x55d78   ; CALL _objc_release
0x0002ef30  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002ef34  bl       #0x56940   ; CALL objc_msgSend$blackColor
0x0002ef38  mov      x29, x29
0x0002ef3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ef40  mov      x20, x0
0x0002ef44  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002ef48  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002ef4c  mov      x21, x0
0x0002ef50  mov      x0, x27
0x0002ef54  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002ef58  mov      x29, x29
0x0002ef5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ef60  mov      x24, x0
0x0002ef64  mov      x2, x21
0x0002ef68  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x0002ef6c  mov      x0, x24
0x0002ef70  bl       #0x55d78   ; CALL _objc_release
0x0002ef74  mov      x0, x20
0x0002ef78  bl       #0x55d78   ; CALL _objc_release
0x0002ef7c  mov      x0, x27
0x0002ef80  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002ef84  mov      x29, x29
0x0002ef88  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ef8c  mov      x20, x0
0x0002ef90  adrp     x8, #0x65000
0x0002ef94  ldr      s0, [x8, #0xd08]
0x0002ef98  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x0002ef9c  mov      x0, x20
0x0002efa0  bl       #0x55d78   ; CALL _objc_release
0x0002efa4  mov      x0, x19
0x0002efa8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002efac  mov      x29, x29
0x0002efb0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002efb4  mov      x20, x0
0x0002efb8  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002efbc  adrp     x8, #0x65000
0x0002efc0  ldr      d8, [x8, #0x7a0]
0x0002efc4  adrp     x8, #0x65000
0x0002efc8  ldr      d9, [x8, #0x7a8]
0x0002efcc  adrp     x8, #0x65000
0x0002efd0  ldr      d10, [x8, #0x7b0]
0x0002efd4  fmov     d3, #1.00000000
0x0002efd8  mov      v0.16b, v8.16b
0x0002efdc  mov      v1.16b, v9.16b
0x0002efe0  mov      v2.16b, v10.16b
0x0002efe4  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002efe8  mov      x29, x29
0x0002efec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002eff0  mov      x21, x0
0x0002eff4  adrp     x2, #0x7b000
0x0002eff8  add      x2, x2, #0x1a8   ; STR "glow"
0x0002effc  fmov     d0, #1.50000000
0x0002f000  mov      x0, x19
0x0002f004  mov      x3, x20
0x0002f008  mov      x4, x21
0x0002f00c  bl       #0x5c960   ; CALL objc_msgSend$shapePart:in:stroke:width:
0x0002f010  mov      x29, x29
0x0002f014  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f018  mov      x24, x0
0x0002f01c  mov      x0, x21
0x0002f020  bl       #0x55d78   ; CALL _objc_release
0x0002f024  mov      x0, x20
0x0002f028  bl       #0x55d78   ; CALL _objc_release
0x0002f02c  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002f030  fmov     d3, #1.00000000
0x0002f034  mov      v0.16b, v8.16b
0x0002f038  mov      v1.16b, v9.16b
0x0002f03c  mov      v2.16b, v10.16b
0x0002f040  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002f044  mov      x29, x29
0x0002f048  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f04c  mov      x20, x0
0x0002f050  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002f054  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002f058  mov      x2, x0
0x0002f05c  mov      x0, x24
0x0002f060  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x0002f064  mov      x0, x20
0x0002f068  bl       #0x55d78   ; CALL _objc_release
0x0002f06c  fmov     d0, #4.00000000
0x0002f070  mov      x0, x24
0x0002f074  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x0002f078  adrp     x8, #0x65000
0x0002f07c  ldr      s0, [x8, #0x684]
0x0002f080  mov      x0, x24
0x0002f084  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x0002f088  adrp     x8, #0x74000
0x0002f08c  ldr      x8, [x8, #0x618]   ; @GOT _CGSizeZero
0x0002f090  ldp      d0, d1, [x8]
0x0002f094  mov      x0, x24
0x0002f098  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x0002f09c  fmov     d0, #1.50000000
0x0002f0a0  mov      w0, #1
0x0002f0a4  bl       #0x3036c
0x0002f0a8  mov      x29, x29
0x0002f0ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f0b0  mov      x21, x0
0x0002f0b4  mov      x0, x19
0x0002f0b8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002f0bc  mov      x29, x29
0x0002f0c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f0c4  mov      x20, x0
0x0002f0c8  mov      x2, x21
0x0002f0cc  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0002f0d0  mov      x0, x20
0x0002f0d4  bl       #0x55d78   ; CALL _objc_release
0x0002f0d8  mov      x0, x19
0x0002f0dc  bl       #0x595e0   ; CALL objc_msgSend$parts
0x0002f0e0  mov      x29, x29
0x0002f0e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f0e8  mov      x20, x0
0x0002f0ec  adrp     x3, #0x7b000
0x0002f0f0  add      x3, x3, #0x88   ; STR "ring"
0x0002f0f4  mov      x2, x21
0x0002f0f8  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0002f0fc  mov      x0, x20
0x0002f100  bl       #0x55d78   ; CALL _objc_release
0x0002f104  fmov     d9, #30.00000000
0x0002f108  fmov     d8, #10.00000000
0x0002f10c  mov      x0, x26
0x0002f110  mov      x26, x25
0x0002f114  mov      x25, x0
0x0002f118  mov      x27, x28
0x0002f11c  ldr      x28, [sp, #0x38]
0x0002f120  b        #0x2f340
0x0002f124  adrp     x2, #0x7b000
0x0002f128  add      x2, x2, #0xc8   ; STR "dot"
0x0002f12c  mov      x0, x19
0x0002f130  mov      x3, x19
0x0002f134  bl       #0x56080   ; CALL objc_msgSend$addBit:to:
0x0002f138  mov      x29, x29
0x0002f13c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f140  mov      x24, x0
0x0002f144  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002f148  mov      x29, x29
0x0002f14c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f150  mov      x20, x0
0x0002f154  fmov     d0, #4.00000000
0x0002f158  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0002f15c  mov      x0, x20
0x0002f160  bl       #0x55d78   ; CALL _objc_release
0x0002f164  adrp     x2, #0x7b000
0x0002f168  add      x2, x2, #0xe8   ; STR "bar"
0x0002f16c  mov      x0, x19
0x0002f170  mov      x3, x19
0x0002f174  bl       #0x56080   ; CALL objc_msgSend$addBit:to:
0x0002f178  mov      x29, x29
0x0002f17c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f180  mov      x21, x0
0x0002f184  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002f188  fmov     d3, #1.00000000
0x0002f18c  mov      v0.16b, v13.16b
0x0002f190  mov      v1.16b, v12.16b
0x0002f194  mov      v2.16b, v11.16b
0x0002f198  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002f19c  mov      x29, x29
0x0002f1a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f1a4  mov      x20, x0
0x0002f1a8  adrp     x8, #0x65000
0x0002f1ac  ldr      d0, [x8, #0xb60]
0x0002f1b0  bl       #0x56e80   ; CALL objc_msgSend$colorWithAlphaComponent:
0x0002f1b4  mov      x29, x29
0x0002f1b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f1bc  mov      x25, x0
0x0002f1c0  mov      x0, x21
0x0002f1c4  mov      x2, x25
0x0002f1c8  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0002f1cc  mov      x0, x25
0x0002f1d0  bl       #0x55d78   ; CALL _objc_release
0x0002f1d4  mov      x0, x20
0x0002f1d8  bl       #0x55d78   ; CALL _objc_release
0x0002f1dc  mov      x0, x21
0x0002f1e0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002f1e4  mov      x29, x29
0x0002f1e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f1ec  mov      x20, x0
0x0002f1f0  fmov     d0, #0.75000000
0x0002f1f4  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0002f1f8  mov      x0, x20
0x0002f1fc  bl       #0x55d78   ; CALL _objc_release
0x0002f200  fmov     d8, #10.00000000
0x0002f204  mov      x8, #0x4040000000000000
0x0002f208  fmov     d9, x8
0x0002f20c  ldr      x25, [sp, #0x50]
0x0002f210  b        #0x2f33c
0x0002f214  mov      x0, x27
0x0002f218  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002f21c  mov      x29, x29
0x0002f220  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f224  mov      x20, x0
0x0002f228  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002f22c  fmov     d3, #1.00000000
0x0002f230  mov      v0.16b, v13.16b
0x0002f234  mov      v1.16b, v12.16b
0x0002f238  mov      v2.16b, v11.16b
0x0002f23c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002f240  mov      x29, x29
0x0002f244  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f248  str      x25, [sp, #0x50]
0x0002f24c  mov      x25, x0
0x0002f250  adrp     x8, #0x65000
0x0002f254  ldr      d0, [x8, #0x5f0]
0x0002f258  bl       #0x56e80   ; CALL objc_msgSend$colorWithAlphaComponent:
0x0002f25c  mov      x29, x29
0x0002f260  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f264  mov      x21, x27
0x0002f268  mov      x27, x0
0x0002f26c  adrp     x2, #0x7b000
0x0002f270  add      x2, x2, #0x128   ; STR "track"
0x0002f274  fmov     d0, #7.00000000
0x0002f278  mov      x0, x19
0x0002f27c  mov      x3, x20
0x0002f280  mov      x4, x27
0x0002f284  bl       #0x5c960   ; CALL objc_msgSend$shapePart:in:stroke:width:
0x0002f288  mov      x29, x29
0x0002f28c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f290  mov      x24, x0
0x0002f294  mov      x0, x27
0x0002f298  bl       #0x55d78   ; CALL _objc_release
0x0002f29c  mov      x0, x25
0x0002f2a0  ldr      x25, [sp, #0x50]
0x0002f2a4  bl       #0x55d78   ; CALL _objc_release
0x0002f2a8  mov      x0, x20
0x0002f2ac  bl       #0x55d78   ; CALL _objc_release
0x0002f2b0  adrp     x8, #0x74000
0x0002f2b4  ldr      x8, [x8, #0x688]   ; @GOT _kCALineCapRound
0x0002f2b8  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0002f2bc  mov      x0, x24
0x0002f2c0  bl       #0x5b320   ; CALL objc_msgSend$setLineCap:
0x0002f2c4  fmov     d0, #7.00000000
0x0002f2c8  mov      w0, #0
0x0002f2cc  bl       #0x3036c
0x0002f2d0  mov      x29, x29
0x0002f2d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f2d8  mov      x1, x0
0x0002f2dc  mov      x0, x21
0x0002f2e0  mov      x21, x1
0x0002f2e4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002f2e8  mov      x29, x29
0x0002f2ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f2f0  mov      x20, x0
0x0002f2f4  mov      x2, x21
0x0002f2f8  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0002f2fc  mov      x0, x20
0x0002f300  bl       #0x55d78   ; CALL _objc_release
0x0002f304  mov      x0, x19
0x0002f308  bl       #0x595e0   ; CALL objc_msgSend$parts
0x0002f30c  mov      x29, x29
0x0002f310  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f314  mov      x20, x0
0x0002f318  adrp     x3, #0x7b000
0x0002f31c  add      x3, x3, #0x148   ; STR "fill"
0x0002f320  mov      x2, x21
0x0002f324  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0002f328  mov      x0, x20
0x0002f32c  bl       #0x55d78   ; CALL _objc_release
0x0002f330  fmov     d8, #10.00000000
0x0002f334  mov      x8, #0x4041000000000000
0x0002f338  fmov     d9, x8
0x0002f33c  ldr      x27, [sp, #0x58]
0x0002f340  mov      x0, x21
0x0002f344  bl       #0x55d78   ; CALL _objc_release
0x0002f348  mov      x0, x24
0x0002f34c  bl       #0x55d78   ; CALL _objc_release
0x0002f350  mov      v0.16b, v9.16b
0x0002f354  bl       #0x2d6bc
0x0002f358  mov      x29, x29
0x0002f35c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f360  mov      x20, x0
0x0002f364  mov      x1, x27
0x0002f368  bl       #0x2d620
0x0002f36c  mov      x29, x29
0x0002f370  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f374  mov      x21, x0
0x0002f378  mov      x0, x19
0x0002f37c  mov      x2, x21
0x0002f380  bl       #0x5c2a0   ; CALL objc_msgSend$setSpeedLabel:
0x0002f384  mov      x0, x21
0x0002f388  bl       #0x55d78   ; CALL _objc_release
0x0002f38c  mov      x0, x20
0x0002f390  bl       #0x55d78   ; CALL _objc_release
0x0002f394  mov      v0.16b, v8.16b
0x0002f398  bl       #0x30644
0x0002f39c  mov      x29, x29
0x0002f3a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f3a4  mov      x20, x0
0x0002f3a8  mov      x1, x25
0x0002f3ac  bl       #0x2d620
0x0002f3b0  mov      x29, x29
0x0002f3b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f3b8  mov      x21, x0
0x0002f3bc  mov      x0, x19
0x0002f3c0  mov      x2, x21
0x0002f3c4  bl       #0x5c700   ; CALL objc_msgSend$setUnitLabel:
0x0002f3c8  mov      x0, x21
0x0002f3cc  bl       #0x55d78   ; CALL _objc_release
0x0002f3d0  mov      x0, x20
0x0002f3d4  bl       #0x55d78   ; CALL _objc_release
0x0002f3d8  cmp      x26, #5
0x0002f3dc  b.ne     #0x2f508
0x0002f3e0  stp      x25, x27, [sp, #0x50]
0x0002f3e4  str      x26, [sp, #0x40]
0x0002f3e8  mov      x27, x23
0x0002f3ec  movi     v0.16b, #0
0x0002f3f0  stp      q0, q0, [sp, #0x80]
0x0002f3f4  stp      q0, q0, [sp, #0x60]
0x0002f3f8  mov      x0, x19
0x0002f3fc  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x0002f400  mov      x29, x29
0x0002f404  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f408  mov      x21, x0
0x0002f40c  str      x0, [sp, #0x120]
0x0002f410  mov      x0, x19
0x0002f414  bl       #0x5dc80   ; CALL objc_msgSend$unitLabel
0x0002f418  mov      x29, x29
0x0002f41c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f420  mov      x23, x0
0x0002f424  str      x0, [sp, #0x128]
0x0002f428  adrp     x8, #0x8e000
0x0002f42c  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0002f430  add      x2, sp, #0x120
0x0002f434  mov      w3, #2
0x0002f438  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0002f43c  mov      x29, x29
0x0002f440  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f444  mov      x20, x0
0x0002f448  mov      x0, x23
0x0002f44c  bl       #0x55d78   ; CALL _objc_release
0x0002f450  mov      x0, x21
0x0002f454  bl       #0x55d78   ; CALL _objc_release
0x0002f458  add      x2, sp, #0x60
0x0002f45c  add      x3, sp, #0x130
0x0002f460  mov      x0, x20
0x0002f464  mov      w4, #0x10
0x0002f468  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0002f46c  cbz      x0, #0x2f4f4
0x0002f470  mov      x24, x0
0x0002f474  ldr      x8, [sp, #0x70]
0x0002f478  ldr      x25, [x8]   ; @SEL "whatsNewNavigationController"
0x0002f47c  mov      x26, #0
0x0002f480  ldr      x8, [sp, #0x70]
0x0002f484  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0002f488  cmp      x8, x25
0x0002f48c  b.eq     #0x2f498
0x0002f490  mov      x0, x20
0x0002f494  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0002f498  ldr      x8, [sp, #0x68]
0x0002f49c  ldr      x21, [x8, x26, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0002f4a0  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002f4a4  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0002f4a8  mov      x29, x29
0x0002f4ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f4b0  mov      x23, x0
0x0002f4b4  fmov     d0, #4.00000000
0x0002f4b8  mov      x0, x21
0x0002f4bc  mov      x1, x23
0x0002f4c0  bl       #0x30730
0x0002f4c4  mov      x0, x23
0x0002f4c8  bl       #0x55d78   ; CALL _objc_release
0x0002f4cc  add      x26, x26, #1
0x0002f4d0  cmp      x24, x26
0x0002f4d4  b.ne     #0x2f480
0x0002f4d8  add      x2, sp, #0x60
0x0002f4dc  add      x3, sp, #0x130
0x0002f4e0  mov      x0, x20
0x0002f4e4  mov      w4, #0x10
0x0002f4e8  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0002f4ec  mov      x24, x0
0x0002f4f0  cbnz     x0, #0x2f47c
0x0002f4f4  mov      x0, x20
0x0002f4f8  bl       #0x55d78   ; CALL _objc_release
0x0002f4fc  mov      x23, x27
0x0002f500  ldr      x26, [sp, #0x40]
0x0002f504  ldp      x25, x27, [sp, #0x50]
0x0002f508  cmp      x28, #8
0x0002f50c  b.eq     #0x2f518
0x0002f510  cmp      x28, #6
0x0002f514  b.ne     #0x2f57c
0x0002f518  mov      x0, x19
0x0002f51c  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x0002f520  mov      x29, x29
0x0002f524  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f528  mov      x20, x0
0x0002f52c  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002f530  adrp     x8, #0x65000
0x0002f534  ldr      d0, [x8, #0x658]
0x0002f538  adrp     x8, #0x65000
0x0002f53c  ldr      d1, [x8, #0xb68]
0x0002f540  adrp     x8, #0x65000
0x0002f544  ldr      d3, [x8, #0x700]
0x0002f548  fmov     d2, #1.00000000
0x0002f54c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002f550  mov      x29, x29
0x0002f554  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f558  mov      x21, x0
0x0002f55c  fmov     d0, #8.00000000
0x0002f560  mov      x0, x20
0x0002f564  mov      x1, x21
0x0002f568  bl       #0x30730
0x0002f56c  mov      x0, x21
0x0002f570  bl       #0x55d78   ; CALL _objc_release
0x0002f574  mov      x0, x20
0x0002f578  bl       #0x55d78   ; CALL _objc_release
0x0002f57c  mov      x0, x19
0x0002f580  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x0002f584  mov      x29, x29
0x0002f588  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f58c  mov      x20, x0
0x0002f590  mov      x0, x19
0x0002f594  mov      x2, x20
0x0002f598  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002f59c  mov      x0, x20
0x0002f5a0  bl       #0x55d78   ; CALL _objc_release
0x0002f5a4  mov      x0, x19
0x0002f5a8  bl       #0x5dc80   ; CALL objc_msgSend$unitLabel
0x0002f5ac  mov      x29, x29
0x0002f5b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f5b4  mov      x20, x0
0x0002f5b8  mov      x0, x19
0x0002f5bc  mov      x2, x20
0x0002f5c0  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002f5c4  mov      x0, x20
0x0002f5c8  bl       #0x55d78   ; CALL _objc_release
0x0002f5cc  adrp     x8, #0x8e000
0x0002f5d0  ldr      x0, [x8, #0xbc8]   ; @CLASS SPPSignView
0x0002f5d4  bl       #0x55c88   ; CALL _objc_alloc_init
0x0002f5d8  mov      x20, x0
0x0002f5dc  mov      x0, x19
0x0002f5e0  mov      x2, x20
0x0002f5e4  bl       #0x5c180   ; CALL objc_msgSend$setSign:
0x0002f5e8  mov      x0, x20
0x0002f5ec  bl       #0x55d78   ; CALL _objc_release
0x0002f5f0  mov      x0, x19
0x0002f5f4  bl       #0x5cb80   ; CALL objc_msgSend$sign
0x0002f5f8  mov      x29, x29
0x0002f5fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f600  mov      x20, x0
0x0002f604  mov      x0, x19
0x0002f608  mov      x2, x20
0x0002f60c  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002f610  mov      x0, x20
0x0002f614  bl       #0x55d78   ; CALL _objc_release
0x0002f618  adrp     x8, #0x8e000
0x0002f61c  ldr      x0, [x8, #0xbd0]   ; @CLASS SPPIconView
0x0002f620  bl       #0x55c88   ; CALL _objc_alloc_init
0x0002f624  mov      x20, x0
0x0002f628  mov      x0, x19
0x0002f62c  mov      x2, x20
0x0002f630  bl       #0x5b060   ; CALL objc_msgSend$setIconView:
0x0002f634  mov      x0, x20
0x0002f638  bl       #0x55d78   ; CALL _objc_release
0x0002f63c  mov      x0, x19
0x0002f640  bl       #0x58040   ; CALL objc_msgSend$iconView
0x0002f644  mov      x29, x29
0x0002f648  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f64c  mov      x20, x0
0x0002f650  mov      x2, #0
0x0002f654  bl       #0x5c060   ; CALL objc_msgSend$setShape:
0x0002f658  mov      x0, x20
0x0002f65c  bl       #0x55d78   ; CALL _objc_release
0x0002f660  mov      x0, x19
0x0002f664  bl       #0x58040   ; CALL objc_msgSend$iconView
0x0002f668  mov      x29, x29
0x0002f66c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f670  mov      x20, x0
0x0002f674  mov      x0, x19
0x0002f678  mov      x2, x20
0x0002f67c  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002f680  mov      x0, x20
0x0002f684  bl       #0x55d78   ; CALL _objc_release
0x0002f688  mov      x0, x19
0x0002f68c  bl       #0x58040   ; CALL objc_msgSend$iconView
0x0002f690  mov      x29, x29
0x0002f694  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f698  mov      x20, x0
0x0002f69c  bl       #0x58120   ; CALL objc_msgSend$imageView
0x0002f6a0  mov      x29, x29
0x0002f6a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f6a8  mov      x21, x0
0x0002f6ac  mov      x2, #0
0x0002f6b0  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x0002f6b4  mov      x0, x21
0x0002f6b8  bl       #0x55d78   ; CALL _objc_release
0x0002f6bc  mov      x0, x20
0x0002f6c0  bl       #0x55d78   ; CALL _objc_release
0x0002f6c4  mov      x0, x19
0x0002f6c8  mov      x2, x26
0x0002f6cc  bl       #0x5a780   ; CALL objc_msgSend$setBuiltStyle:
0x0002f6d0  mov      x0, x19
0x0002f6d4  bl       #0x58e20   ; CALL objc_msgSend$log
0x0002f6d8  mov      x29, x29
0x0002f6dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f6e0  mov      x20, x0
0x0002f6e4  bl       #0x55d78   ; CALL _objc_release
0x0002f6e8  ldr      x22, [sp, #0x48]
0x0002f6ec  cbz      x20, #0x2f748
0x0002f6f0  mov      x0, x19
0x0002f6f4  bl       #0x58e20   ; CALL objc_msgSend$log
0x0002f6f8  mov      x29, x29
0x0002f6fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f700  mov      x20, x0
0x0002f704  adrp     x8, #0x8e000
0x0002f708  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0002f70c  str      x26, [sp]
0x0002f710  adrp     x2, #0x7b000
0x0002f714  add      x2, x2, #0x328   ; STR "bubble: kieu %ld"
0x0002f718  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0002f71c  mov      x29, x29
0x0002f720  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f724  mov      x21, x0
0x0002f728  ldr      x8, [x20, #0x10]
0x0002f72c  mov      x0, x20
0x0002f730  mov      x1, x21
0x0002f734  blr      x8
0x0002f738  mov      x0, x21
0x0002f73c  bl       #0x55d78   ; CALL _objc_release
0x0002f740  mov      x0, x20
0x0002f744  bl       #0x55d78   ; CALL _objc_release
0x0002f748  mov      x0, x25
0x0002f74c  bl       #0x55d78   ; CALL _objc_release
0x0002f750  mov      x0, x27
0x0002f754  bl       #0x55d78   ; CALL _objc_release
0x0002f758  mov      x0, x22
0x0002f75c  bl       #0x55d78   ; CALL _objc_release
0x0002f760  mov      x0, x23
0x0002f764  bl       #0x55d78   ; CALL _objc_release
0x0002f768  mov      x0, x19
0x0002f76c  bl       #0x55d78   ; CALL _objc_release
0x0002f770  ldur     x8, [x29, #-0x90]
0x0002f774  adrp     x9, #0x74000
0x0002f778  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0002f77c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0002f780  cmp      x9, x8
0x0002f784  b.ne     #0x30368
0x0002f788  add      sp, sp, #0x310
0x0002f78c  ldp      x29, x30, [sp, #0x80]
0x0002f790  ldp      x20, x19, [sp, #0x70]
0x0002f794  ldp      x22, x21, [sp, #0x60]
0x0002f798  ldp      x24, x23, [sp, #0x50]
0x0002f79c  ldp      x26, x25, [sp, #0x40]
0x0002f7a0  ldp      x28, x27, [sp, #0x30]
0x0002f7a4  ldp      d9, d8, [sp, #0x20]
0x0002f7a8  ldp      d11, d10, [sp, #0x10]
0x0002f7ac  ldp      d13, d12, [sp], #0x90
0x0002f7b0  ret      
0x0002f7b4  str      x26, [sp, #0x40]
0x0002f7b8  str      x23, [sp, #0x30]
0x0002f7bc  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002f7c0  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0002f7c4  mov      x29, x29
0x0002f7c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f7cc  str      x0, [sp, #0x20]
0x0002f7d0  ldr      x0, [sp, #0x58]
0x0002f7d4  bl       #0x55d78   ; CALL _objc_release
0x0002f7d8  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002f7dc  adrp     x8, #0x65000
0x0002f7e0  ldr      d1, [x8, #0x6e8]
0x0002f7e4  fmov     d0, #1.00000000
0x0002f7e8  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0002f7ec  mov      x29, x29
0x0002f7f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f7f4  str      x0, [sp, #0x28]
0x0002f7f8  ldr      x0, [sp, #0x50]
0x0002f7fc  bl       #0x55d78   ; CALL _objc_release
0x0002f800  ldr      x0, [x21, #0x918]
0x0002f804  bl       #0x55c88   ; CALL _objc_alloc_init
0x0002f808  mov      x24, x0
0x0002f80c  mov      w2, #0
0x0002f810  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x0002f814  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002f818  bl       #0x56940   ; CALL objc_msgSend$blackColor
0x0002f81c  mov      x29, x29
0x0002f820  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f824  mov      x20, x0
0x0002f828  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002f82c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002f830  mov      x21, x0
0x0002f834  mov      x0, x24
0x0002f838  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002f83c  mov      x29, x29
0x0002f840  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f844  mov      x25, x0
0x0002f848  mov      x2, x21
0x0002f84c  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x0002f850  mov      x0, x25
0x0002f854  bl       #0x55d78   ; CALL _objc_release
0x0002f858  mov      x0, x20
0x0002f85c  bl       #0x55d78   ; CALL _objc_release
0x0002f860  mov      x0, x24
0x0002f864  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002f868  mov      x29, x29
0x0002f86c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f870  mov      x20, x0
0x0002f874  adrp     x8, #0x65000
0x0002f878  ldr      s0, [x8, #0xd08]
0x0002f87c  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x0002f880  mov      x0, x20
0x0002f884  bl       #0x55d78   ; CALL _objc_release
0x0002f888  mov      x0, x24
0x0002f88c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002f890  mov      x29, x29
0x0002f894  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f898  mov      x20, x0
0x0002f89c  fmov     d0, #8.00000000
0x0002f8a0  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x0002f8a4  mov      x0, x20
0x0002f8a8  bl       #0x55d78   ; CALL _objc_release
0x0002f8ac  mov      x0, x24
0x0002f8b0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002f8b4  mov      x29, x29
0x0002f8b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f8bc  mov      x20, x0
0x0002f8c0  fmov     d0, xzr
0x0002f8c4  fmov     d1, #4.00000000
0x0002f8c8  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x0002f8cc  mov      x0, x20
0x0002f8d0  bl       #0x55d78   ; CALL _objc_release
0x0002f8d4  mov      x0, x19
0x0002f8d8  mov      x2, x24
0x0002f8dc  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002f8e0  mov      x0, x19
0x0002f8e4  mov      x2, x24
0x0002f8e8  bl       #0x5ac80   ; CALL objc_msgSend$setDeco:
0x0002f8ec  adrp     x8, #0x8e000
0x0002f8f0  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x0002f8f4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002f8f8  mov      x29, x29
0x0002f8fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f900  mov      x23, x0
0x0002f904  adrp     x8, #0x74000
0x0002f908  ldr      x8, [x8, #0x670]   ; @GOT _kCAGradientLayerRadial
0x0002f90c  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0002f910  bl       #0x5c6e0   ; CALL objc_msgSend$setType:
0x0002f914  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002f918  adrp     x8, #0x65000
0x0002f91c  ldr      d0, [x8, #0x810]
0x0002f920  adrp     x8, #0x65000
0x0002f924  ldr      d1, [x8, #0xad8]
0x0002f928  adrp     x8, #0x65000
0x0002f92c  ldr      d2, [x8, #0xae0]
0x0002f930  fmov     d3, #1.00000000
0x0002f934  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002f938  mov      x29, x29
0x0002f93c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f940  mov      x20, x0
0x0002f944  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002f948  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002f94c  str      x0, [sp, #0x1b0]
0x0002f950  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002f954  adrp     x8, #0x65000
0x0002f958  ldr      d0, [x8, #0xae8]
0x0002f95c  adrp     x8, #0x65000
0x0002f960  ldr      d1, [x8, #0xaf0]
0x0002f964  adrp     x8, #0x65000
0x0002f968  ldr      d2, [x8, #0xa88]
0x0002f96c  fmov     d3, #1.00000000
0x0002f970  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002f974  mov      x29, x29
0x0002f978  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f97c  mov      x21, x0
0x0002f980  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002f984  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002f988  str      x0, [sp, #0x1b8]
0x0002f98c  adrp     x8, #0x8e000
0x0002f990  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0002f994  add      x2, sp, #0x1b0
0x0002f998  mov      w3, #2
0x0002f99c  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0002f9a0  mov      x29, x29
0x0002f9a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f9a8  mov      x25, x0
0x0002f9ac  mov      x0, x23
0x0002f9b0  mov      x2, x25
0x0002f9b4  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0002f9b8  mov      x0, x25
0x0002f9bc  bl       #0x55d78   ; CALL _objc_release
0x0002f9c0  mov      x0, x21
0x0002f9c4  bl       #0x55d78   ; CALL _objc_release
0x0002f9c8  mov      x0, x20
0x0002f9cc  bl       #0x55d78   ; CALL _objc_release
0x0002f9d0  mov      x0, x23
0x0002f9d4  mov      w2, #1
0x0002f9d8  bl       #0x5b520   ; CALL objc_msgSend$setMasksToBounds:
0x0002f9dc  mov      x0, x24
0x0002f9e0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002f9e4  mov      x29, x29
0x0002f9e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002f9ec  mov      x20, x0
0x0002f9f0  mov      x2, x23
0x0002f9f4  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0002f9f8  mov      x0, x20
0x0002f9fc  bl       #0x55d78   ; CALL _objc_release
0x0002fa00  mov      x0, x19
0x0002fa04  bl       #0x595e0   ; CALL objc_msgSend$parts
0x0002fa08  mov      x29, x29
0x0002fa0c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fa10  mov      x20, x0
0x0002fa14  adrp     x3, #0x7b000
0x0002fa18  add      x3, x3, #0x208   ; STR "face"
0x0002fa1c  str      x23, [sp, #0x58]
0x0002fa20  mov      x2, x23
0x0002fa24  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0002fa28  mov      x0, x20
0x0002fa2c  bl       #0x55d78   ; CALL _objc_release
0x0002fa30  fmov     d0, #3.00000000
0x0002fa34  mov      w0, #1
0x0002fa38  bl       #0x3036c
0x0002fa3c  mov      x29, x29
0x0002fa40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fa44  mov      x21, x0
0x0002fa48  mov      x0, x24
0x0002fa4c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002fa50  mov      x29, x29
0x0002fa54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fa58  mov      x20, x0
0x0002fa5c  mov      x2, x21
0x0002fa60  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0002fa64  mov      x0, x20
0x0002fa68  bl       #0x55d78   ; CALL _objc_release
0x0002fa6c  mov      x0, x19
0x0002fa70  bl       #0x595e0   ; CALL objc_msgSend$parts
0x0002fa74  mov      x29, x29
0x0002fa78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fa7c  mov      x20, x0
0x0002fa80  adrp     x3, #0x7b000
0x0002fa84  add      x3, x3, #0x88   ; STR "ring"
0x0002fa88  str      x21, [sp, #0x50]
0x0002fa8c  mov      x2, x21
0x0002fa90  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0002fa94  mov      x0, x20
0x0002fa98  bl       #0x55d78   ; CALL _objc_release
0x0002fa9c  mov      x0, x24
0x0002faa0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002faa4  mov      x29, x29
0x0002faa8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002faac  mov      x20, x0
0x0002fab0  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002fab4  adrp     x8, #0x65000
0x0002fab8  ldr      d1, [x8, #0x770]
0x0002fabc  fmov     d0, #1.00000000
0x0002fac0  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0002fac4  mov      x29, x29
0x0002fac8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002facc  mov      x21, x0
0x0002fad0  adrp     x2, #0x7b000
0x0002fad4  add      x2, x2, #0x228   ; STR "inner"
0x0002fad8  fmov     d0, #1.00000000
0x0002fadc  mov      x0, x19
0x0002fae0  mov      x3, x20
0x0002fae4  mov      x4, x21
0x0002fae8  bl       #0x5c960   ; CALL objc_msgSend$shapePart:in:stroke:width:
0x0002faec  mov      x29, x29
0x0002faf0  bl       #0x55dfc   ; CALL _objc_unsafeClaimAutoreleasedReturnValue
0x0002faf4  mov      x0, x21
0x0002faf8  bl       #0x55d78   ; CALL _objc_release
0x0002fafc  mov      x0, x20
0x0002fb00  bl       #0x55d78   ; CALL _objc_release
0x0002fb04  mov      x0, x24
0x0002fb08  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002fb0c  mov      x29, x29
0x0002fb10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fb14  mov      x20, x0
0x0002fb18  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002fb1c  fmov     d0, #1.00000000
0x0002fb20  fmov     d3, #1.00000000
0x0002fb24  mov      v1.16b, v8.16b
0x0002fb28  mov      v2.16b, v9.16b
0x0002fb2c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002fb30  mov      x29, x29
0x0002fb34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fb38  mov      x21, x0
0x0002fb3c  adrp     x8, #0x65000
0x0002fb40  ldr      d10, [x8, #0x708]
0x0002fb44  mov      v0.16b, v10.16b
0x0002fb48  bl       #0x56e80   ; CALL objc_msgSend$colorWithAlphaComponent:
0x0002fb4c  mov      x29, x29
0x0002fb50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fb54  mov      x25, x0
0x0002fb58  adrp     x2, #0x7b000
0x0002fb5c  add      x2, x2, #0x248   ; STR "zone"
0x0002fb60  fmov     d0, #3.50000000
0x0002fb64  mov      x0, x19
0x0002fb68  mov      x3, x20
0x0002fb6c  mov      x4, x25
0x0002fb70  bl       #0x5c960   ; CALL objc_msgSend$shapePart:in:stroke:width:
0x0002fb74  mov      x29, x29
0x0002fb78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fb7c  mov      x23, x0
0x0002fb80  mov      x0, x25
0x0002fb84  bl       #0x55d78   ; CALL _objc_release
0x0002fb88  mov      x0, x21
0x0002fb8c  bl       #0x55d78   ; CALL _objc_release
0x0002fb90  mov      x0, x20
0x0002fb94  bl       #0x55d78   ; CALL _objc_release
0x0002fb98  adrp     x8, #0x74000
0x0002fb9c  ldr      x8, [x8, #0x680]   ; @GOT _kCALineCapButt
0x0002fba0  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0002fba4  str      x23, [sp, #0x18]
0x0002fba8  mov      x0, x23
0x0002fbac  bl       #0x5b320   ; CALL objc_msgSend$setLineCap:
0x0002fbb0  mov      x0, x24
0x0002fbb4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002fbb8  mov      x29, x29
0x0002fbbc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fbc0  mov      x20, x0
0x0002fbc4  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002fbc8  fmov     d0, #1.00000000
0x0002fbcc  fmov     d3, #1.00000000
0x0002fbd0  mov      v1.16b, v8.16b
0x0002fbd4  mov      v2.16b, v9.16b
0x0002fbd8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002fbdc  mov      x29, x29
0x0002fbe0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fbe4  mov      x21, x0
0x0002fbe8  adrp     x2, #0x7b000
0x0002fbec  add      x2, x2, #0x268   ; STR "limTick"
0x0002fbf0  fmov     d0, #2.50000000
0x0002fbf4  mov      x0, x19
0x0002fbf8  mov      x3, x20
0x0002fbfc  mov      x4, x21
0x0002fc00  bl       #0x5c960   ; CALL objc_msgSend$shapePart:in:stroke:width:
0x0002fc04  mov      x29, x29
0x0002fc08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fc0c  mov      x23, x0
0x0002fc10  mov      x0, x21
0x0002fc14  bl       #0x55d78   ; CALL _objc_release
0x0002fc18  mov      x0, x20
0x0002fc1c  bl       #0x55d78   ; CALL _objc_release
0x0002fc20  adrp     x8, #0x74000
0x0002fc24  ldr      x8, [x8, #0x688]   ; @GOT _kCALineCapRound
0x0002fc28  ldr      x20, [x8]   ; @GOT ___objc_personality_v0
0x0002fc2c  str      x23, [sp, #0x10]
0x0002fc30  mov      x0, x23
0x0002fc34  mov      x2, x20
0x0002fc38  bl       #0x5b320   ; CALL objc_msgSend$setLineCap:
0x0002fc3c  mov      x0, x24
0x0002fc40  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002fc44  mov      x29, x29
0x0002fc48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fc4c  mov      x21, x0
0x0002fc50  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002fc54  adrp     x8, #0x65000
0x0002fc58  ldr      d1, [x8, #0x6c0]
0x0002fc5c  fmov     d0, #1.00000000
0x0002fc60  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0002fc64  mov      x29, x29
0x0002fc68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fc6c  mov      x25, x0
0x0002fc70  adrp     x2, #0x7b000
0x0002fc74  add      x2, x2, #0x288   ; STR "minor"
0x0002fc78  adrp     x8, #0x65000
0x0002fc7c  ldr      d0, [x8, #0x830]
0x0002fc80  mov      x0, x19
0x0002fc84  mov      x3, x21
0x0002fc88  mov      x4, x25
0x0002fc8c  bl       #0x5c960   ; CALL objc_msgSend$shapePart:in:stroke:width:
0x0002fc90  mov      x29, x29
0x0002fc94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fc98  mov      x23, x0
0x0002fc9c  mov      x0, x25
0x0002fca0  bl       #0x55d78   ; CALL _objc_release
0x0002fca4  mov      x0, x21
0x0002fca8  bl       #0x55d78   ; CALL _objc_release
0x0002fcac  mov      x0, x24
0x0002fcb0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002fcb4  mov      x29, x29
0x0002fcb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fcbc  mov      x21, x0
0x0002fcc0  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002fcc4  fmov     d0, #1.00000000
0x0002fcc8  mov      v1.16b, v10.16b
0x0002fccc  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0002fcd0  mov      x29, x29
0x0002fcd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fcd8  mov      x25, x0
0x0002fcdc  adrp     x2, #0x7b000
0x0002fce0  add      x2, x2, #0x2a8   ; STR "major"
0x0002fce4  fmov     d0, #2.00000000
0x0002fce8  mov      x0, x19
0x0002fcec  mov      x3, x21
0x0002fcf0  mov      x4, x25
0x0002fcf4  bl       #0x5c960   ; CALL objc_msgSend$shapePart:in:stroke:width:
0x0002fcf8  mov      x29, x29
0x0002fcfc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fd00  mov      x26, x0
0x0002fd04  mov      x0, x25
0x0002fd08  bl       #0x55d78   ; CALL _objc_release
0x0002fd0c  mov      x0, x21
0x0002fd10  bl       #0x55d78   ; CALL _objc_release
0x0002fd14  str      x23, [sp, #8]
0x0002fd18  mov      x0, x23
0x0002fd1c  mov      x2, x20
0x0002fd20  bl       #0x5b320   ; CALL objc_msgSend$setLineCap:
0x0002fd24  mov      x27, x26
0x0002fd28  mov      x0, x26
0x0002fd2c  mov      x2, x20
0x0002fd30  bl       #0x5b320   ; CALL objc_msgSend$setLineCap:
0x0002fd34  adrp     x8, #0x8e000
0x0002fd38  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x0002fd3c  bl       #0x565c0   ; CALL objc_msgSend$array
0x0002fd40  mov      x29, x29
0x0002fd44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fd48  mov      x26, x0
0x0002fd4c  adrp     x8, #0x74000
0x0002fd50  ldr      x8, [x8, #0x238]   ; @GOT _UIFontWeightBold
0x0002fd54  ldr      d10, [x8]   ; @GOT ___objc_personality_v0
0x0002fd58  mov      w25, #9
0x0002fd5c  adrp     x8, #0x65000
0x0002fd60  ldr      d9, [x8, #0x6d0]
0x0002fd64  adrp     x28, #0x8e000
0x0002fd68  fmov     d0, #9.00000000
0x0002fd6c  bl       #0x30644
0x0002fd70  mov      x29, x29
0x0002fd74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fd78  mov      x20, x0
0x0002fd7c  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002fd80  fmov     d0, #1.00000000
0x0002fd84  mov      v1.16b, v9.16b
0x0002fd88  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0002fd8c  mov      x29, x29
0x0002fd90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fd94  mov      x21, x0
0x0002fd98  mov      x0, x20
0x0002fd9c  mov      x1, x21
0x0002fda0  bl       #0x2d620
0x0002fda4  mov      x29, x29
0x0002fda8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fdac  mov      x23, x0
0x0002fdb0  mov      x0, x21
0x0002fdb4  bl       #0x55d78   ; CALL _objc_release
0x0002fdb8  mov      x0, x20
0x0002fdbc  bl       #0x55d78   ; CALL _objc_release
0x0002fdc0  ldr      x0, [x28, #0x948]   ; @CLASS UIFont
0x0002fdc4  fmov     d0, #9.00000000
0x0002fdc8  mov      v1.16b, v10.16b
0x0002fdcc  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x0002fdd0  mov      x29, x29
0x0002fdd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fdd8  mov      x20, x0
0x0002fddc  mov      x0, x23
0x0002fde0  mov      x2, x20
0x0002fde4  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x0002fde8  mov      x0, x20
0x0002fdec  bl       #0x55d78   ; CALL _objc_release
0x0002fdf0  mov      x0, x24
0x0002fdf4  mov      x2, x23
0x0002fdf8  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002fdfc  mov      x0, x26
0x0002fe00  mov      x2, x23
0x0002fe04  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0002fe08  mov      x0, x23
0x0002fe0c  bl       #0x55d78   ; CALL _objc_release
0x0002fe10  subs     w25, w25, #1
0x0002fe14  b.ne     #0x2fd68
0x0002fe18  mov      x0, x19
0x0002fe1c  mov      x2, x26
0x0002fe20  bl       #0x5c520   ; CALL objc_msgSend$setTickLabels:
0x0002fe24  fmov     d0, #3.00000000
0x0002fe28  mov      w0, #0
0x0002fe2c  bl       #0x3036c
0x0002fe30  mov      x29, x29
0x0002fe34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fe38  mov      x28, x0
0x0002fe3c  fmov     d0, xzr
0x0002fe40  fmov     d1, #1.00000000
0x0002fe44  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x0002fe48  fmov     d0, #1.00000000
0x0002fe4c  fmov     d1, xzr
0x0002fe50  mov      x0, x28
0x0002fe54  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x0002fe58  mov      x0, x24
0x0002fe5c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002fe60  mov      x29, x29
0x0002fe64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fe68  mov      x20, x0
0x0002fe6c  mov      x2, x28
0x0002fe70  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0002fe74  mov      x0, x20
0x0002fe78  bl       #0x55d78   ; CALL _objc_release
0x0002fe7c  mov      x0, x19
0x0002fe80  bl       #0x595e0   ; CALL objc_msgSend$parts
0x0002fe84  mov      x29, x29
0x0002fe88  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fe8c  mov      x20, x0
0x0002fe90  adrp     x3, #0x7b000
0x0002fe94  add      x3, x3, #0x2c8   ; STR "prog"
0x0002fe98  mov      x2, x28
0x0002fe9c  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0002fea0  mov      x0, x20
0x0002fea4  bl       #0x55d78   ; CALL _objc_release
0x0002fea8  mov      x0, x24
0x0002feac  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002feb0  mov      x29, x29
0x0002feb4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002feb8  mov      x20, x0
0x0002febc  adrp     x2, #0x7b000
0x0002fec0  add      x2, x2, #0x2e8   ; STR "needle"
0x0002fec4  fmov     d0, xzr
0x0002fec8  mov      x0, x19
0x0002fecc  mov      x3, x20
0x0002fed0  mov      x4, #0
0x0002fed4  bl       #0x5c960   ; CALL objc_msgSend$shapePart:in:stroke:width:
0x0002fed8  mov      x29, x29
0x0002fedc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fee0  mov      x25, x0
0x0002fee4  mov      x0, x20
0x0002fee8  bl       #0x55d78   ; CALL _objc_release
0x0002feec  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002fef0  adrp     x8, #0x65000
0x0002fef4  ldr      d10, [x8, #0xaf8]
0x0002fef8  fmov     d0, #1.00000000
0x0002fefc  fmov     d3, #1.00000000
0x0002ff00  mov      v1.16b, v8.16b
0x0002ff04  mov      v2.16b, v10.16b
0x0002ff08  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002ff0c  mov      x29, x29
0x0002ff10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ff14  mov      x20, x0
0x0002ff18  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002ff1c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002ff20  mov      x2, x0
0x0002ff24  mov      x0, x25
0x0002ff28  bl       #0x5ae40   ; CALL objc_msgSend$setFillColor:
0x0002ff2c  mov      x0, x20
0x0002ff30  bl       #0x55d78   ; CALL _objc_release
0x0002ff34  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002ff38  fmov     d0, #1.00000000
0x0002ff3c  fmov     d3, #1.00000000
0x0002ff40  mov      v1.16b, v8.16b
0x0002ff44  mov      v2.16b, v10.16b
0x0002ff48  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002ff4c  mov      x29, x29
0x0002ff50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ff54  mov      x20, x0
0x0002ff58  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002ff5c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002ff60  mov      x2, x0
0x0002ff64  mov      x0, x25
0x0002ff68  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x0002ff6c  mov      x0, x20
0x0002ff70  bl       #0x55d78   ; CALL _objc_release
0x0002ff74  fmov     d0, #3.00000000
0x0002ff78  mov      x0, x25
0x0002ff7c  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x0002ff80  adrp     x8, #0x65000
0x0002ff84  ldr      s0, [x8, #0xd0c]
0x0002ff88  mov      x0, x25
0x0002ff8c  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x0002ff90  adrp     x8, #0x74000
0x0002ff94  ldr      x8, [x8, #0x618]   ; @GOT _CGSizeZero
0x0002ff98  ldp      d0, d1, [x8]
0x0002ff9c  mov      x0, x25
0x0002ffa0  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x0002ffa4  mov      x0, x24
0x0002ffa8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002ffac  mov      x29, x29
0x0002ffb0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ffb4  mov      x20, x0
0x0002ffb8  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0002ffbc  fmov     d0, #1.00000000
0x0002ffc0  mov      v1.16b, v9.16b
0x0002ffc4  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0002ffc8  mov      x29, x29
0x0002ffcc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ffd0  mov      x21, x0
0x0002ffd4  adrp     x2, #0x7b000
0x0002ffd8  add      x2, x2, #0x308   ; STR "hub"
0x0002ffdc  fmov     d0, #1.50000000
0x0002ffe0  mov      x0, x19
0x0002ffe4  mov      x3, x20
0x0002ffe8  mov      x4, x21
0x0002ffec  bl       #0x5c960   ; CALL objc_msgSend$shapePart:in:stroke:width:
0x0002fff0  mov      x29, x29
0x0002fff4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002fff8  mov      x23, x0
0x0002fffc  mov      x0, x21
0x00030000  bl       #0x55d78   ; CALL _objc_release
0x00030004  mov      x0, x20
0x00030008  bl       #0x55d78   ; CALL _objc_release
0x0003000c  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x00030010  adrp     x8, #0x65000
0x00030014  ldr      d0, [x8, #0xb00]
0x00030018  adrp     x8, #0x65000
0x0003001c  ldr      d1, [x8, #0x6a8]
0x00030020  adrp     x8, #0x65000
0x00030024  ldr      d2, [x8, #0x858]
0x00030028  fmov     d3, #1.00000000
0x0003002c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00030030  mov      x29, x29
0x00030034  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030038  mov      x20, x0
0x0003003c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00030040  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00030044  mov      x2, x0
0x00030048  mov      x0, x23
0x0003004c  bl       #0x5ae40   ; CALL objc_msgSend$setFillColor:
0x00030050  mov      x0, x20
0x00030054  bl       #0x55d78   ; CALL _objc_release
0x00030058  mov      x0, x23
0x0003005c  bl       #0x55d78   ; CALL _objc_release
0x00030060  mov      x0, x25
0x00030064  bl       #0x55d78   ; CALL _objc_release
0x00030068  mov      x0, x28
0x0003006c  bl       #0x55d78   ; CALL _objc_release
0x00030070  mov      x0, x26
0x00030074  bl       #0x55d78   ; CALL _objc_release
0x00030078  mov      x0, x27
0x0003007c  bl       #0x55d78   ; CALL _objc_release
0x00030080  ldr      x0, [sp, #8]
0x00030084  bl       #0x55d78   ; CALL _objc_release
0x00030088  ldr      x0, [sp, #0x10]
0x0003008c  bl       #0x55d78   ; CALL _objc_release
0x00030090  ldr      x0, [sp, #0x18]
0x00030094  bl       #0x55d78   ; CALL _objc_release
0x00030098  ldr      x0, [sp, #0x50]
0x0003009c  bl       #0x55d78   ; CALL _objc_release
0x000300a0  fmov     d9, #24.00000000
0x000300a4  fmov     d8, #9.00000000
0x000300a8  ldp      x27, x25, [sp, #0x20]
0x000300ac  ldp      x23, x28, [sp, #0x30]
0x000300b0  ldr      x26, [sp, #0x40]
0x000300b4  ldr      x21, [sp, #0x58]
0x000300b8  b        #0x2f340
0x000300bc  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x000300c0  fmov     d3, #1.00000000
0x000300c4  mov      v0.16b, v13.16b
0x000300c8  mov      v1.16b, v12.16b
0x000300cc  mov      v2.16b, v11.16b
0x000300d0  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000300d4  mov      x29, x29
0x000300d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000300dc  mov      x27, x0
0x000300e0  ldr      x0, [sp, #0x58]
0x000300e4  bl       #0x55d78   ; CALL _objc_release
0x000300e8  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x000300ec  fmov     d3, #1.00000000
0x000300f0  mov      v0.16b, v13.16b
0x000300f4  mov      v1.16b, v12.16b
0x000300f8  mov      v2.16b, v11.16b
0x000300fc  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00030100  mov      x29, x29
0x00030104  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030108  mov      x26, x0
0x0003010c  mov      x0, x25
0x00030110  bl       #0x55d78   ; CALL _objc_release
0x00030114  adrp     x2, #0x7b000
0x00030118  add      x2, x2, #0x128   ; STR "track"
0x0003011c  mov      x0, x19
0x00030120  mov      x3, x19
0x00030124  bl       #0x56080   ; CALL objc_msgSend$addBit:to:
0x00030128  mov      x29, x29
0x0003012c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030130  mov      x24, x0
0x00030134  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x00030138  adrp     x8, #0x65000
0x0003013c  ldr      d1, [x8, #0x670]
0x00030140  fmov     d0, #1.00000000
0x00030144  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x00030148  mov      x29, x29
0x0003014c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030150  mov      x20, x0
0x00030154  mov      x0, x24
0x00030158  mov      x2, x20
0x0003015c  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x00030160  mov      x0, x20
0x00030164  bl       #0x55d78   ; CALL _objc_release
0x00030168  mov      x0, x24
0x0003016c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00030170  mov      x29, x29
0x00030174  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030178  mov      x20, x0
0x0003017c  fmov     d0, #2.50000000
0x00030180  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x00030184  mov      x0, x20
0x00030188  bl       #0x55d78   ; CALL _objc_release
0x0003018c  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x00030190  bl       #0x56940   ; CALL objc_msgSend$blackColor
0x00030194  mov      x29, x29
0x00030198  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003019c  mov      x20, x0
0x000301a0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000301a4  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000301a8  mov      x21, x0
0x000301ac  mov      x0, x24
0x000301b0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000301b4  mov      x29, x29
0x000301b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000301bc  mov      x25, x0
0x000301c0  mov      x2, x21
0x000301c4  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x000301c8  mov      x0, x25
0x000301cc  bl       #0x55d78   ; CALL _objc_release
0x000301d0  mov      x0, x20
0x000301d4  bl       #0x55d78   ; CALL _objc_release
0x000301d8  mov      x0, x24
0x000301dc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000301e0  mov      x29, x29
0x000301e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000301e8  mov      x20, x0
0x000301ec  adrp     x8, #0x65000
0x000301f0  ldr      s0, [x8, #0xd10]
0x000301f4  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x000301f8  mov      x0, x20
0x000301fc  bl       #0x55d78   ; CALL _objc_release
0x00030200  mov      x0, x24
0x00030204  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00030208  mov      x29, x29
0x0003020c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030210  mov      x20, x0
0x00030214  fmov     d0, #2.00000000
0x00030218  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x0003021c  mov      x0, x20
0x00030220  bl       #0x55d78   ; CALL _objc_release
0x00030224  mov      x0, x24
0x00030228  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003022c  mov      x29, x29
0x00030230  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030234  mov      x20, x0
0x00030238  fmov     d0, xzr
0x0003023c  fmov     d1, #1.00000000
0x00030240  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x00030244  mov      x0, x20
0x00030248  bl       #0x55d78   ; CALL _objc_release
0x0003024c  adrp     x2, #0x7b000
0x00030250  add      x2, x2, #0x148   ; STR "fill"
0x00030254  mov      x0, x19
0x00030258  mov      x3, x24
0x0003025c  bl       #0x56080   ; CALL objc_msgSend$addBit:to:
0x00030260  mov      x29, x29
0x00030264  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030268  mov      x23, x0
0x0003026c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00030270  mov      x29, x29
0x00030274  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030278  mov      x20, x0
0x0003027c  fmov     d0, #2.50000000
0x00030280  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x00030284  mov      x0, x20
0x00030288  bl       #0x55d78   ; CALL _objc_release
0x0003028c  mov      x0, x23
0x00030290  mov      w2, #1
0x00030294  bl       #0x5a8a0   ; CALL objc_msgSend$setClipsToBounds:
0x00030298  adrp     x8, #0x8e000
0x0003029c  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x000302a0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000302a4  mov      x29, x29
0x000302a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000302ac  mov      x20, x0
0x000302b0  fmov     d0, xzr
0x000302b4  fmov     d1, #0.50000000
0x000302b8  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x000302bc  fmov     d0, #1.00000000
0x000302c0  fmov     d1, #0.50000000
0x000302c4  mov      x0, x20
0x000302c8  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x000302cc  bl       #0x304f4
0x000302d0  mov      x29, x29
0x000302d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000302d8  mov      x21, x0
0x000302dc  mov      x0, x20
0x000302e0  mov      x2, x21
0x000302e4  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x000302e8  mov      x0, x21
0x000302ec  bl       #0x55d78   ; CALL _objc_release
0x000302f0  mov      x0, x23
0x000302f4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000302f8  mov      x29, x29
0x000302fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030300  mov      x21, x0
0x00030304  mov      x2, x20
0x00030308  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0003030c  mov      x0, x21
0x00030310  bl       #0x55d78   ; CALL _objc_release
0x00030314  mov      x0, x19
0x00030318  bl       #0x595e0   ; CALL objc_msgSend$parts
0x0003031c  mov      x29, x29
0x00030320  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030324  mov      x21, x0
0x00030328  adrp     x3, #0x7b000
0x0003032c  add      x3, x3, #0x188   ; STR "fillGrad"
0x00030330  mov      x2, x20
0x00030334  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x00030338  mov      x0, x21
0x0003033c  mov      x21, x23
0x00030340  bl       #0x55d78   ; CALL _objc_release
0x00030344  mov      x0, x20
0x00030348  bl       #0x55d78   ; CALL _objc_release
0x0003034c  fmov     d8, #12.00000000
0x00030350  mov      x8, #0x4048000000000000
0x00030354  fmov     d9, x8
0x00030358  mov      x25, x26
0x0003035c  ldp      x23, x28, [sp, #0x30]
0x00030360  ldr      x26, [sp, #0x40]
0x00030364  b        #0x2f340
0x00030368  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0003036c  stp      d9, d8, [sp, #-0x40]!
0x00030370  stp      x22, x21, [sp, #0x10]
0x00030374  stp      x20, x19, [sp, #0x20]
0x00030378  stp      x29, x30, [sp, #0x30]
0x0003037c  add      x29, sp, #0x30
0x00030380  mov      v8.16b, v0.16b
0x00030384  mov      x20, x0
0x00030388  adrp     x8, #0x8e000
0x0003038c  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x00030390  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00030394  mov      x29, x29
0x00030398  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003039c  mov      x19, x0
0x000303a0  cbz      w20, #0x303e8
0x000303a4  adrp     x8, #0x74000
0x000303a8  ldr      x8, [x8, #0x668]   ; @GOT _kCAGradientLayerConic
0x000303ac  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x000303b0  mov      x0, x19
0x000303b4  bl       #0x5c6e0   ; CALL objc_msgSend$setType:
0x000303b8  fmov     d0, #0.50000000
0x000303bc  fmov     d1, #0.50000000
0x000303c0  mov      x0, x19
0x000303c4  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x000303c8  fmov     d0, #0.50000000
0x000303cc  fmov     d1, xzr
0x000303d0  mov      x0, x19
0x000303d4  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x000303d8  bl       #0x3499c
0x000303dc  mov      x29, x29
0x000303e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000303e4  b        #0x30414
0x000303e8  fmov     d0, xzr
0x000303ec  fmov     d1, xzr
0x000303f0  mov      x0, x19
0x000303f4  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x000303f8  fmov     d0, #1.00000000
0x000303fc  fmov     d1, #1.00000000
0x00030400  mov      x0, x19
0x00030404  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x00030408  bl       #0x304f4
0x0003040c  mov      x29, x29
0x00030410  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030414  mov      x20, x0
0x00030418  mov      x0, x19
0x0003041c  mov      x2, x20
0x00030420  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x00030424  mov      x0, x20
0x00030428  bl       #0x55d78   ; CALL _objc_release
0x0003042c  adrp     x8, #0x8e000
0x00030430  ldr      x0, [x8, #0xb48]   ; @CLASS CAShapeLayer
0x00030434  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00030438  mov      x29, x29
0x0003043c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030440  mov      x20, x0
0x00030444  adrp     x22, #0x8e000
0x00030448  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0003044c  bl       #0x56de0   ; CALL objc_msgSend$clearColor
0x00030450  mov      x29, x29
0x00030454  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030458  mov      x21, x0
0x0003045c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00030460  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00030464  mov      x2, x0
0x00030468  mov      x0, x20
0x0003046c  bl       #0x5ae40   ; CALL objc_msgSend$setFillColor:
0x00030470  mov      x0, x21
0x00030474  bl       #0x55d78   ; CALL _objc_release
0x00030478  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0003047c  bl       #0x56940   ; CALL objc_msgSend$blackColor
0x00030480  mov      x29, x29
0x00030484  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030488  mov      x21, x0
0x0003048c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00030490  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00030494  mov      x2, x0
0x00030498  mov      x0, x20
0x0003049c  bl       #0x5c380   ; CALL objc_msgSend$setStrokeColor:
0x000304a0  mov      x0, x21
0x000304a4  bl       #0x55d78   ; CALL _objc_release
0x000304a8  mov      x0, x20
0x000304ac  mov      v0.16b, v8.16b
0x000304b0  bl       #0x5b3a0   ; CALL objc_msgSend$setLineWidth:
0x000304b4  adrp     x8, #0x74000
0x000304b8  ldr      x8, [x8, #0x688]   ; @GOT _kCALineCapRound
0x000304bc  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x000304c0  mov      x0, x20
0x000304c4  bl       #0x5b320   ; CALL objc_msgSend$setLineCap:
0x000304c8  mov      x0, x19
0x000304cc  mov      x2, x20
0x000304d0  bl       #0x5b4c0   ; CALL objc_msgSend$setMask:
0x000304d4  mov      x0, x20
0x000304d8  bl       #0x55d78   ; CALL _objc_release
0x000304dc  mov      x0, x19
0x000304e0  ldp      x29, x30, [sp, #0x30]
0x000304e4  ldp      x20, x19, [sp, #0x20]
0x000304e8  ldp      x22, x21, [sp, #0x10]
0x000304ec  ldp      d9, d8, [sp], #0x40
0x000304f0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x000304f4  sub      sp, sp, #0x60
0x000304f8  stp      d9, d8, [sp, #0x20]
0x000304fc  stp      x22, x21, [sp, #0x30]
0x00030500  stp      x20, x19, [sp, #0x40]
0x00030504  stp      x29, x30, [sp, #0x50]
0x00030508  add      x29, sp, #0x50
0x0003050c  adrp     x8, #0x74000
0x00030510  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00030514  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00030518  str      x8, [sp, #0x18]
0x0003051c  adrp     x21, #0x8e000
0x00030520  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00030524  adrp     x8, #0x65000
0x00030528  ldr      d0, [x8, #0x7a0]
0x0003052c  adrp     x8, #0x65000
0x00030530  ldr      d1, [x8, #0x7a8]
0x00030534  adrp     x8, #0x65000
0x00030538  ldr      d8, [x8, #0x7b0]
0x0003053c  fmov     d3, #1.00000000
0x00030540  mov      v2.16b, v8.16b
0x00030544  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00030548  mov      x29, x29
0x0003054c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030550  mov      x19, x0
0x00030554  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00030558  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0003055c  str      x0, [sp]
0x00030560  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00030564  adrp     x8, #0x65000
0x00030568  ldr      d0, [x8, #0x7b8]
0x0003056c  adrp     x8, #0x65000
0x00030570  ldr      d1, [x8, #0x7c0]
0x00030574  fmov     d3, #1.00000000
0x00030578  mov      v2.16b, v8.16b
0x0003057c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00030580  mov      x29, x29
0x00030584  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030588  mov      x20, x0
0x0003058c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00030590  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00030594  str      x0, [sp, #8]
0x00030598  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x0003059c  adrp     x8, #0x65000
0x000305a0  ldr      d0, [x8, #0x7c8]
0x000305a4  adrp     x8, #0x65000
0x000305a8  ldr      d1, [x8, #0x7d0]
0x000305ac  adrp     x8, #0x65000
0x000305b0  ldr      d2, [x8, #0x7d8]
0x000305b4  fmov     d3, #1.00000000
0x000305b8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000305bc  mov      x29, x29
0x000305c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000305c4  mov      x22, x0
0x000305c8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000305cc  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000305d0  str      x0, [sp, #0x10]
0x000305d4  adrp     x8, #0x8e000
0x000305d8  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000305dc  mov      x2, sp
0x000305e0  mov      w3, #3
0x000305e4  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000305e8  mov      x29, x29
0x000305ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000305f0  mov      x21, x0
0x000305f4  mov      x0, x22
0x000305f8  bl       #0x55d78   ; CALL _objc_release
0x000305fc  mov      x0, x20
0x00030600  bl       #0x55d78   ; CALL _objc_release
0x00030604  mov      x0, x19
0x00030608  bl       #0x55d78   ; CALL _objc_release
0x0003060c  ldr      x8, [sp, #0x18]
0x00030610  adrp     x9, #0x74000
0x00030614  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00030618  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0003061c  cmp      x9, x8
0x00030620  b.ne     #0x30640
0x00030624  mov      x0, x21
0x00030628  ldp      x29, x30, [sp, #0x50]
0x0003062c  ldp      x20, x19, [sp, #0x40]
0x00030630  ldp      x22, x21, [sp, #0x30]
0x00030634  ldp      d9, d8, [sp, #0x20]
0x00030638  add      sp, sp, #0x60
0x0003063c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00030640  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00030644  stp      d9, d8, [sp, #-0x50]!
0x00030648  stp      x24, x23, [sp, #0x10]
0x0003064c  stp      x22, x21, [sp, #0x20]
0x00030650  stp      x20, x19, [sp, #0x30]
0x00030654  stp      x29, x30, [sp, #0x40]
0x00030658  add      x29, sp, #0x40
0x0003065c  mov      v8.16b, v0.16b
0x00030660  adrp     x23, #0x8e000
0x00030664  ldr      x0, [x23, #0x948]   ; @CLASS UIFont
0x00030668  adrp     x8, #0x74000
0x0003066c  ldr      x8, [x8, #0x260]   ; @GOT _UIFontWeightSemibold
0x00030670  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x00030674  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x00030678  mov      x29, x29
0x0003067c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030680  mov      x19, x0
0x00030684  bl       #0x57c80   ; CALL objc_msgSend$fontDescriptor
0x00030688  mov      x29, x29
0x0003068c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030690  mov      x20, x0
0x00030694  adrp     x8, #0x74000
0x00030698  ldr      x8, [x8, #0x208]   ; @GOT _UIFontDescriptorSystemDesignRounded
0x0003069c  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x000306a0  bl       #0x57cc0   ; CALL objc_msgSend$fontDescriptorWithDesign:
0x000306a4  mov      x29, x29
0x000306a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000306ac  mov      x22, x0
0x000306b0  cbz      x0, #0x306c4
0x000306b4  mov      x0, x22
0x000306b8  bl       #0x55d84   ; CALL _objc_retain
0x000306bc  mov      x21, x22
0x000306c0  b        #0x306d8
0x000306c4  mov      x0, x19
0x000306c8  bl       #0x57c80   ; CALL objc_msgSend$fontDescriptor
0x000306cc  mov      x29, x29
0x000306d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000306d4  mov      x21, x0
0x000306d8  mov      x0, x22
0x000306dc  bl       #0x55d78   ; CALL _objc_release
0x000306e0  mov      x0, x20
0x000306e4  bl       #0x55d78   ; CALL _objc_release
0x000306e8  ldr      x0, [x23, #0x948]   ; @CLASS UIFont
0x000306ec  mov      x2, x21
0x000306f0  mov      v0.16b, v8.16b
0x000306f4  bl       #0x57ce0   ; CALL objc_msgSend$fontWithDescriptor:size:
0x000306f8  mov      x29, x29
0x000306fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030700  mov      x20, x0
0x00030704  mov      x0, x21
0x00030708  bl       #0x55d78   ; CALL _objc_release
0x0003070c  mov      x0, x19
0x00030710  bl       #0x55d78   ; CALL _objc_release
0x00030714  mov      x0, x20
0x00030718  ldp      x29, x30, [sp, #0x40]
0x0003071c  ldp      x20, x19, [sp, #0x30]
0x00030720  ldp      x22, x21, [sp, #0x20]
0x00030724  ldp      x24, x23, [sp, #0x10]
0x00030728  ldp      d9, d8, [sp], #0x50
0x0003072c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00030730  stp      d11, d10, [sp, #-0x50]!
0x00030734  stp      d9, d8, [sp, #0x10]
0x00030738  stp      x22, x21, [sp, #0x20]
0x0003073c  stp      x20, x19, [sp, #0x30]
0x00030740  stp      x29, x30, [sp, #0x40]
0x00030744  add      x29, sp, #0x40
0x00030748  mov      v8.16b, v0.16b
0x0003074c  mov      x20, x1
0x00030750  mov      x19, x0
0x00030754  mov      x0, x1
0x00030758  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0003075c  mov      x0, x19
0x00030760  bl       #0x55d84   ; CALL _objc_retain
0x00030764  mov      x0, x20
0x00030768  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0003076c  mov      x20, x0
0x00030770  mov      x0, x19
0x00030774  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00030778  mov      x29, x29
0x0003077c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030780  mov      x21, x0
0x00030784  mov      x2, x20
0x00030788  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x0003078c  mov      x0, x21
0x00030790  bl       #0x55d78   ; CALL _objc_release
0x00030794  adrp     x8, #0x74000
0x00030798  ldr      x8, [x8, #0x618]   ; @GOT _CGSizeZero
0x0003079c  ldp      d9, d10, [x8]
0x000307a0  mov      x0, x19
0x000307a4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000307a8  mov      x29, x29
0x000307ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000307b0  mov      x20, x0
0x000307b4  mov      v0.16b, v9.16b
0x000307b8  mov      v1.16b, v10.16b
0x000307bc  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x000307c0  mov      x0, x20
0x000307c4  bl       #0x55d78   ; CALL _objc_release
0x000307c8  mov      x0, x19
0x000307cc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000307d0  mov      x29, x29
0x000307d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000307d8  mov      x20, x0
0x000307dc  mov      v0.16b, v8.16b
0x000307e0  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x000307e4  mov      x0, x20
0x000307e8  bl       #0x55d78   ; CALL _objc_release
0x000307ec  mov      x0, x19
0x000307f0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000307f4  mov      x29, x29
0x000307f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000307fc  mov      x20, x0
0x00030800  mov      x0, x19
0x00030804  bl       #0x55d78   ; CALL _objc_release
0x00030808  fmov     s0, #1.00000000
0x0003080c  mov      x0, x20
0x00030810  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x00030814  mov      x0, x20
0x00030818  ldp      x29, x30, [sp, #0x40]
0x0003081c  ldp      x20, x19, [sp, #0x30]
0x00030820  ldp      x22, x21, [sp, #0x20]
0x00030824  ldp      d9, d8, [sp, #0x10]
0x00030828  ldp      d11, d10, [sp], #0x50
0x0003082c  b        #0x55d78   ; CALL _objc_release

=== -[SPPBubbleView setOverLimitWarning:]  va=0x30830 size=792 types=v20@0:8B16
0x00030830  stp      d9, d8, [sp, #-0x50]!
0x00030834  stp      x24, x23, [sp, #0x10]
0x00030838  stp      x22, x21, [sp, #0x20]
0x0003083c  stp      x20, x19, [sp, #0x30]
0x00030840  stp      x29, x30, [sp, #0x40]
0x00030844  add      x29, sp, #0x40
0x00030848  mov      x21, x2
0x0003084c  mov      x20, x0
0x00030850  bl       #0x57c40   ; CALL objc_msgSend$flashView
0x00030854  mov      x29, x29
0x00030858  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003085c  mov      x19, x0
0x00030860  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00030864  mov      x29, x29
0x00030868  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003086c  mov      x22, x0
0x00030870  adrp     x2, #0x7b000
0x00030874  add      x2, x2, #0x348   ; STR "sppFlash"
0x00030878  bl       #0x56380   ; CALL objc_msgSend$animationForKey:
0x0003087c  mov      x29, x29
0x00030880  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030884  mov      x23, x0
0x00030888  bl       #0x55d78   ; CALL _objc_release
0x0003088c  mov      x0, x22
0x00030890  bl       #0x55d78   ; CALL _objc_release
0x00030894  cmp      x23, #0
0x00030898  cset     w8, eq
0x0003089c  eor      w8, w21, w8
0x000308a0  tbnz     w8, #0, #0x30b2c
0x000308a4  cbz      w21, #0x30ab8
0x000308a8  adrp     x23, #0x8e000
0x000308ac  ldr      x0, [x23, #0xbd8]   ; @CLASS CABasicAnimation
0x000308b0  adrp     x2, #0x7b000
0x000308b4  add      x2, x2, #0x368   ; STR "opacity"
0x000308b8  bl       #0x563a0   ; CALL objc_msgSend$animationWithKeyPath:
0x000308bc  mov      x29, x29
0x000308c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000308c4  mov      x21, x0
0x000308c8  adrp     x2, #0x80000
0x000308cc  add      x2, x2, #0x6f8
0x000308d0  bl       #0x5aee0   ; CALL objc_msgSend$setFromValue:
0x000308d4  adrp     x2, #0x80000
0x000308d8  add      x2, x2, #0x6e8
0x000308dc  mov      x0, x21
0x000308e0  bl       #0x5c660   ; CALL objc_msgSend$setToValue:
0x000308e4  fmov     d0, #0.50000000
0x000308e8  mov      x0, x21
0x000308ec  bl       #0x5ad40   ; CALL objc_msgSend$setDuration:
0x000308f0  mov      x0, x21
0x000308f4  mov      w2, #1
0x000308f8  bl       #0x5a520   ; CALL objc_msgSend$setAutoreverses:
0x000308fc  mov      w8, #0x7f800000
0x00030900  fmov     s8, w8
0x00030904  mov      x0, x21
0x00030908  mov      v0.16b, v8.16b
0x0003090c  bl       #0x5bdc0   ; CALL objc_msgSend$setRepeatCount:
0x00030910  adrp     x8, #0x8e000
0x00030914  ldr      x0, [x8, #0xbe0]   ; @CLASS CAMediaTimingFunction
0x00030918  adrp     x8, #0x74000
0x0003091c  ldr      x8, [x8, #0x698]   ; @GOT _kCAMediaTimingFunctionEaseInEaseOut
0x00030920  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x00030924  bl       #0x57d60   ; CALL objc_msgSend$functionWithName:
0x00030928  mov      x29, x29
0x0003092c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030930  mov      x22, x0
0x00030934  mov      x0, x21
0x00030938  mov      x2, x22
0x0003093c  bl       #0x5c5a0   ; CALL objc_msgSend$setTimingFunction:
0x00030940  mov      x0, x22
0x00030944  bl       #0x55d78   ; CALL _objc_release
0x00030948  fmov     d0, #1.00000000
0x0003094c  mov      x0, x19
0x00030950  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x00030954  mov      x0, x19
0x00030958  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003095c  mov      x29, x29
0x00030960  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030964  mov      x22, x0
0x00030968  fmov     s0, wzr
0x0003096c  bl       #0x5b940   ; CALL objc_msgSend$setOpacity:
0x00030970  mov      x0, x22
0x00030974  bl       #0x55d78   ; CALL _objc_release
0x00030978  mov      x0, x19
0x0003097c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00030980  mov      x29, x29
0x00030984  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030988  mov      x22, x0
0x0003098c  adrp     x3, #0x7b000
0x00030990  add      x3, x3, #0x348   ; STR "sppFlash"
0x00030994  mov      x2, x21
0x00030998  bl       #0x56020   ; CALL objc_msgSend$addAnimation:forKey:
0x0003099c  mov      x0, x22
0x000309a0  bl       #0x55d78   ; CALL _objc_release
0x000309a4  ldr      x0, [x23, #0xbd8]   ; @CLASS CABasicAnimation
0x000309a8  adrp     x2, #0x7b000
0x000309ac  add      x2, x2, #0x388   ; STR "transform.scale"
0x000309b0  bl       #0x563a0   ; CALL objc_msgSend$animationWithKeyPath:
0x000309b4  mov      x29, x29
0x000309b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000309bc  mov      x22, x0
0x000309c0  adrp     x2, #0x80000
0x000309c4  add      x2, x2, #0x708
0x000309c8  bl       #0x5aee0   ; CALL objc_msgSend$setFromValue:
0x000309cc  adrp     x2, #0x80000
0x000309d0  add      x2, x2, #0x718
0x000309d4  mov      x0, x22
0x000309d8  bl       #0x5c660   ; CALL objc_msgSend$setToValue:
0x000309dc  fmov     d0, #0.50000000
0x000309e0  mov      x0, x22
0x000309e4  bl       #0x5ad40   ; CALL objc_msgSend$setDuration:
0x000309e8  mov      x0, x22
0x000309ec  mov      w2, #1
0x000309f0  bl       #0x5a520   ; CALL objc_msgSend$setAutoreverses:
0x000309f4  mov      x0, x22
0x000309f8  mov      v0.16b, v8.16b
0x000309fc  bl       #0x5bdc0   ; CALL objc_msgSend$setRepeatCount:
0x00030a00  mov      x0, x20
0x00030a04  bl       #0x5cb80   ; CALL objc_msgSend$sign
0x00030a08  mov      x29, x29
0x00030a0c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030a10  mov      x23, x0
0x00030a14  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00030a18  mov      x29, x29
0x00030a1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030a20  mov      x24, x0
0x00030a24  adrp     x3, #0x7b000
0x00030a28  add      x3, x3, #0x3a8   ; STR "sppPulse"
0x00030a2c  mov      x2, x22
0x00030a30  bl       #0x56020   ; CALL objc_msgSend$addAnimation:forKey:
0x00030a34  mov      x0, x24
0x00030a38  bl       #0x55d78   ; CALL _objc_release
0x00030a3c  mov      x0, x23
0x00030a40  bl       #0x55d78   ; CALL _objc_release
0x00030a44  mov      x0, x20
0x00030a48  bl       #0x58e20   ; CALL objc_msgSend$log
0x00030a4c  mov      x29, x29
0x00030a50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030a54  mov      x23, x0
0x00030a58  bl       #0x55d78   ; CALL _objc_release
0x00030a5c  cbz      x23, #0x30b1c
0x00030a60  mov      x0, x20
0x00030a64  bl       #0x58e20   ; CALL objc_msgSend$log
0x00030a68  mov      x29, x29
0x00030a6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030a70  mov      x20, x0
0x00030a74  adrp     x8, #0x8e000
0x00030a78  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00030a7c  adrp     x2, #0x7b000
0x00030a80  add      x2, x2, #0x3c8   ; STR "bubble: vuot gioi han -> nhay canh bao"
0x00030a84  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00030a88  mov      x29, x29
0x00030a8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030a90  mov      x23, x0
0x00030a94  ldr      x8, [x20, #0x10]
0x00030a98  mov      x0, x20
0x00030a9c  mov      x1, x23
0x00030aa0  blr      x8
0x00030aa4  mov      x0, x23
0x00030aa8  bl       #0x55d78   ; CALL _objc_release
0x00030aac  mov      x0, x20
0x00030ab0  bl       #0x55d78   ; CALL _objc_release
0x00030ab4  b        #0x30b1c
0x00030ab8  mov      x0, x19
0x00030abc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00030ac0  mov      x29, x29
0x00030ac4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030ac8  mov      x21, x0
0x00030acc  adrp     x2, #0x7b000
0x00030ad0  add      x2, x2, #0x348   ; STR "sppFlash"
0x00030ad4  bl       #0x59dc0   ; CALL objc_msgSend$removeAnimationForKey:
0x00030ad8  mov      x0, x21
0x00030adc  bl       #0x55d78   ; CALL _objc_release
0x00030ae0  fmov     d0, xzr
0x00030ae4  mov      x0, x19
0x00030ae8  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x00030aec  mov      x0, x20
0x00030af0  bl       #0x5cb80   ; CALL objc_msgSend$sign
0x00030af4  mov      x29, x29
0x00030af8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030afc  mov      x21, x0
0x00030b00  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00030b04  mov      x29, x29
0x00030b08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030b0c  mov      x22, x0
0x00030b10  adrp     x2, #0x7b000
0x00030b14  add      x2, x2, #0x3a8   ; STR "sppPulse"
0x00030b18  bl       #0x59dc0   ; CALL objc_msgSend$removeAnimationForKey:
0x00030b1c  mov      x0, x22
0x00030b20  bl       #0x55d78   ; CALL _objc_release
0x00030b24  mov      x0, x21
0x00030b28  bl       #0x55d78   ; CALL _objc_release
0x00030b2c  mov      x0, x19
0x00030b30  ldp      x29, x30, [sp, #0x40]
0x00030b34  ldp      x20, x19, [sp, #0x30]
0x00030b38  ldp      x22, x21, [sp, #0x20]
0x00030b3c  ldp      x24, x23, [sp, #0x10]
0x00030b40  ldp      d9, d8, [sp], #0x50
0x00030b44  b        #0x55d78   ; CALL _objc_release

=== -[SPPBubbleView numberColor]  va=0x30b48 size=336 types=@16@0:8
0x00030b48  stp      x20, x19, [sp, #-0x20]!
0x00030b4c  stp      x29, x30, [sp, #0x10]
0x00030b50  add      x29, sp, #0x10
0x00030b54  mov      x20, x0
0x00030b58  bl       #0x5ce80   ; CALL objc_msgSend$speedState
0x00030b5c  mov      x19, x0
0x00030b60  mov      x0, x20
0x00030b64  bl       #0x56b20   ; CALL objc_msgSend$builtStyle
0x00030b68  cmp      x0, #5
0x00030b6c  b.gt     #0x30b8c
0x00030b70  cmp      x0, #2
0x00030b74  b.eq     #0x30bfc
0x00030b78  cmp      x0, #4
0x00030b7c  b.ne     #0x30bc8
0x00030b80  cmp      w19, #1
0x00030b84  b.ge     #0x30c0c
0x00030b88  b        #0x30c24
0x00030b8c  cmp      x0, #8
0x00030b90  b.eq     #0x30b9c
0x00030b94  cmp      x0, #6
0x00030b98  b.ne     #0x30bc8
0x00030b9c  adrp     x8, #0x8e000
0x00030ba0  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00030ba4  cmp      w19, #1
0x00030ba8  b.eq     #0x30c68
0x00030bac  cmp      w19, #2
0x00030bb0  b.ne     #0x30c14
0x00030bb4  adrp     x8, #0x65000
0x00030bb8  ldr      d1, [x8, #0xb70]
0x00030bbc  adrp     x8, #0x65000
0x00030bc0  ldr      d2, [x8, #0xb78]
0x00030bc4  b        #0x30c78
0x00030bc8  cmp      w19, #1
0x00030bcc  b.eq     #0x30c48
0x00030bd0  cmp      w19, #2
0x00030bd4  b.ne     #0x30c24
0x00030bd8  adrp     x8, #0x8e000
0x00030bdc  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00030be0  adrp     x8, #0x65000
0x00030be4  ldr      d0, [x8, #0xa68]
0x00030be8  adrp     x8, #0x65000
0x00030bec  ldr      d1, [x8, #0xb88]
0x00030bf0  adrp     x8, #0x65000
0x00030bf4  ldr      d2, [x8, #0x858]
0x00030bf8  b        #0x30c7c
0x00030bfc  cmp      w19, #1
0x00030c00  b.eq     #0x30c48
0x00030c04  cmp      w19, #2
0x00030c08  b.ne     #0x30c24
0x00030c0c  adrp     x8, #0x8e000
0x00030c10  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00030c14  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x00030c18  mov      x29, x29
0x00030c1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030c20  b        #0x30c8c
0x00030c24  adrp     x8, #0x8e000
0x00030c28  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00030c2c  adrp     x8, #0x65000
0x00030c30  ldr      d0, [x8, #0x820]
0x00030c34  adrp     x8, #0x65000
0x00030c38  ldr      d1, [x8, #0xad0]
0x00030c3c  adrp     x8, #0x65000
0x00030c40  ldr      d2, [x8, #0x928]
0x00030c44  b        #0x30c7c
0x00030c48  adrp     x8, #0x8e000
0x00030c4c  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00030c50  adrp     x8, #0x65000
0x00030c54  ldr      d0, [x8, #0xb80]
0x00030c58  adrp     x8, #0x65000
0x00030c5c  ldr      d1, [x8, #0xb70]
0x00030c60  fmov     d2, xzr
0x00030c64  b        #0x30c7c
0x00030c68  adrp     x8, #0x65000
0x00030c6c  ldr      d1, [x8, #0x8f8]
0x00030c70  adrp     x8, #0x65000
0x00030c74  ldr      d2, [x8, #0xb70]
0x00030c78  fmov     d0, #1.00000000
0x00030c7c  fmov     d3, #1.00000000
0x00030c80  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00030c84  mov      x29, x29
0x00030c88  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030c8c  ldp      x29, x30, [sp, #0x10]
0x00030c90  ldp      x20, x19, [sp], #0x20
0x00030c94  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[SPPBubbleView applyColor:]  va=0x30c98 size=1524 types=v20@0:8i16
0x00030c98  sub      sp, sp, #0x170
0x00030c9c  stp      d11, d10, [sp, #0xf0]
0x00030ca0  stp      d9, d8, [sp, #0x100]
0x00030ca4  stp      x28, x27, [sp, #0x110]
0x00030ca8  stp      x26, x25, [sp, #0x120]
0x00030cac  stp      x24, x23, [sp, #0x130]
0x00030cb0  stp      x22, x21, [sp, #0x140]
0x00030cb4  stp      x20, x19, [sp, #0x150]
0x00030cb8  stp      x29, x30, [sp, #0x160]
0x00030cbc  add      x29, sp, #0x160
0x00030cc0  mov      x24, x2
0x00030cc4  mov      x21, x0
0x00030cc8  adrp     x8, #0x74000
0x00030ccc  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00030cd0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00030cd4  stur     x8, [x29, #-0x80]
0x00030cd8  bl       #0x56e60   ; CALL objc_msgSend$color
0x00030cdc  sub      x8, x0, #7
0x00030ce0  cmn      x8, #6
0x00030ce4  b.lo     #0x31248
0x00030ce8  mov      x22, x0
0x00030cec  adrp     x8, #0x65000
0x00030cf0  add      x8, x8, #0xd40
0x00030cf4  ldr      w8, [x8, x0, lsl #2]
0x00030cf8  ubfx     w9, w8, #0x10, #8
0x00030cfc  ubfx     w10, w8, #8, #8
0x00030d00  and      w8, w8, #0xff
0x00030d04  adrp     x27, #0x8e000
0x00030d08  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x00030d0c  ucvtf    d0, w9
0x00030d10  adrp     x9, #0x65000
0x00030d14  ldr      d2, [x9, #0x688]
0x00030d18  fdiv     d0, d0, d2
0x00030d1c  ucvtf    d1, w10
0x00030d20  fdiv     d1, d1, d2
0x00030d24  ucvtf    d3, w8
0x00030d28  fdiv     d2, d3, d2
0x00030d2c  fmov     d3, #1.00000000
0x00030d30  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00030d34  mov      x29, x29
0x00030d38  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030d3c  mov      x19, x0
0x00030d40  adrp     x8, #0x65000
0x00030d44  add      x8, x8, #0xd60
0x00030d48  ldr      d0, [x8, x22, lsl #3]
0x00030d4c  bl       #0x56e80   ; CALL objc_msgSend$colorWithAlphaComponent:
0x00030d50  mov      x29, x29
0x00030d54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030d58  mov      x20, x0
0x00030d5c  mov      x0, x21
0x00030d60  bl       #0x56b20   ; CALL objc_msgSend$builtStyle
0x00030d64  cmp      x0, #8
0x00030d68  b.eq     #0x30dcc
0x00030d6c  cmp      x0, #5
0x00030d70  b.ne     #0x30e60
0x00030d74  cbz      w24, #0x30e88
0x00030d78  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x00030d7c  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x00030d80  mov      x29, x29
0x00030d84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030d88  mov      x22, x0
0x00030d8c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00030d90  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00030d94  mov      x23, x0
0x00030d98  mov      x0, x21
0x00030d9c  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x00030da0  mov      x29, x29
0x00030da4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030da8  mov      x21, x0
0x00030dac  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00030db0  mov      x29, x29
0x00030db4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030db8  mov      x24, x0
0x00030dbc  mov      x2, x23
0x00030dc0  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x00030dc4  mov      x0, x24
0x00030dc8  b        #0x30e4c
0x00030dcc  cmp      x22, #1
0x00030dd0  b.eq     #0x31238
0x00030dd4  mov      x0, x19
0x00030dd8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00030ddc  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00030de0  stur     x0, [x29, #-0x90]
0x00030de4  mov      x0, x19
0x00030de8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00030dec  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00030df0  stur     x0, [x29, #-0x88]
0x00030df4  adrp     x8, #0x8e000
0x00030df8  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00030dfc  sub      x2, x29, #0x90
0x00030e00  mov      w3, #2
0x00030e04  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00030e08  mov      x29, x29
0x00030e0c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030e10  mov      x22, x0
0x00030e14  mov      x0, x21
0x00030e18  bl       #0x595e0   ; CALL objc_msgSend$parts
0x00030e1c  mov      x29, x29
0x00030e20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030e24  mov      x21, x0
0x00030e28  adrp     x2, #0x7b000
0x00030e2c  add      x2, x2, #0x208   ; STR "face"
0x00030e30  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00030e34  mov      x29, x29
0x00030e38  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030e3c  mov      x23, x0
0x00030e40  mov      x2, x22
0x00030e44  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x00030e48  mov      x0, x23
0x00030e4c  bl       #0x55d78   ; CALL _objc_release
0x00030e50  mov      x0, x21
0x00030e54  bl       #0x55d78   ; CALL _objc_release
0x00030e58  mov      x0, x22
0x00030e5c  b        #0x310fc
0x00030e60  cmp      w24, #2
0x00030e64  b.eq     #0x30ec8
0x00030e68  cmp      w24, #1
0x00030e6c  b.ne     #0x30ef8
0x00030e70  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x00030e74  adrp     x8, #0x65000
0x00030e78  ldr      d1, [x8, #0xab0]
0x00030e7c  adrp     x8, #0x65000
0x00030e80  ldr      d2, [x8, #0xab8]
0x00030e84  b        #0x30edc
0x00030e88  mov      x0, x21
0x00030e8c  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x00030e90  mov      x29, x29
0x00030e94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030e98  mov      x23, x0
0x00030e9c  mov      x2, x19
0x00030ea0  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00030ea4  mov      x0, x23
0x00030ea8  bl       #0x55d78   ; CALL _objc_release
0x00030eac  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x00030eb0  cmp      x22, #1
0x00030eb4  b.eq     #0x3109c
0x00030eb8  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x00030ebc  mov      x29, x29
0x00030ec0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030ec4  b        #0x310a8
0x00030ec8  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x00030ecc  adrp     x8, #0x65000
0x00030ed0  ldr      d1, [x8, #0xac0]
0x00030ed4  adrp     x8, #0x65000
0x00030ed8  ldr      d2, [x8, #0xac8]
0x00030edc  fmov     d0, #1.00000000
0x00030ee0  fmov     d3, #1.00000000
0x00030ee4  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00030ee8  mov      x29, x29
0x00030eec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030ef0  mov      x23, x0
0x00030ef4  b        #0x30f04
0x00030ef8  mov      x0, x20
0x00030efc  bl       #0x55d84   ; CALL _objc_retain
0x00030f00  mov      x23, x20
0x00030f04  mov      x0, x21
0x00030f08  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00030f0c  mov      x29, x29
0x00030f10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030f14  mov      x25, x0
0x00030f18  mov      x2, x23
0x00030f1c  mov      x3, x23
0x00030f20  bl       #0x5c680   ; CALL objc_msgSend$setTop:bottom:
0x00030f24  mov      x0, x25
0x00030f28  bl       #0x55d78   ; CALL _objc_release
0x00030f2c  mov      x0, x21
0x00030f30  bl       #0x595e0   ; CALL objc_msgSend$parts
0x00030f34  mov      x29, x29
0x00030f38  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030f3c  mov      x25, x0
0x00030f40  adrp     x2, #0x7b000
0x00030f44  add      x2, x2, #0x168   ; STR "mesh"
0x00030f48  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00030f4c  mov      x29, x29
0x00030f50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030f54  mov      x26, x0
0x00030f58  mov      w2, #1
0x00030f5c  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x00030f60  mov      x0, x26
0x00030f64  bl       #0x55d78   ; CALL _objc_release
0x00030f68  mov      x0, x25
0x00030f6c  bl       #0x55d78   ; CALL _objc_release
0x00030f70  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x00030f74  cmp      w24, #0
0x00030f78  str      x20, [sp, #8]
0x00030f7c  b.gt     #0x31044
0x00030f80  cmp      x22, #1
0x00030f84  b.ne     #0x31044
0x00030f88  adrp     x8, #0x65000
0x00030f8c  ldr      d8, [x8, #0x820]
0x00030f90  adrp     x8, #0x65000
0x00030f94  ldr      d9, [x8, #0xad0]
0x00030f98  adrp     x8, #0x65000
0x00030f9c  ldr      d10, [x8, #0x928]
0x00030fa0  fmov     d3, #1.00000000
0x00030fa4  mov      v0.16b, v8.16b
0x00030fa8  mov      v1.16b, v9.16b
0x00030fac  mov      v2.16b, v10.16b
0x00030fb0  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00030fb4  mov      x29, x29
0x00030fb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030fbc  mov      x22, x0
0x00030fc0  mov      x0, x21
0x00030fc4  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x00030fc8  mov      x29, x29
0x00030fcc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00030fd0  mov      x24, x0
0x00030fd4  mov      x2, x22
0x00030fd8  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00030fdc  mov      x0, x24
0x00030fe0  bl       #0x55d78   ; CALL _objc_release
0x00030fe4  mov      x0, x22
0x00030fe8  bl       #0x55d78   ; CALL _objc_release
0x00030fec  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x00030ff0  adrp     x8, #0x65000
0x00030ff4  ldr      d3, [x8, #0x838]
0x00030ff8  mov      v0.16b, v8.16b
0x00030ffc  mov      v1.16b, v9.16b
0x00031000  mov      v2.16b, v10.16b
0x00031004  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00031008  mov      x29, x29
0x0003100c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031010  mov      x22, x0
0x00031014  mov      x0, x21
0x00031018  bl       #0x5dc80   ; CALL objc_msgSend$unitLabel
0x0003101c  mov      x29, x29
0x00031020  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031024  mov      x21, x0
0x00031028  mov      x2, x22
0x0003102c  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00031030  mov      x0, x21
0x00031034  bl       #0x55d78   ; CALL _objc_release
0x00031038  mov      x0, x22
0x0003103c  bl       #0x55d78   ; CALL _objc_release
0x00031040  b        #0x3122c
0x00031044  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x00031048  mov      x29, x29
0x0003104c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031050  mov      x25, x0
0x00031054  mov      x0, x21
0x00031058  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x0003105c  mov      x29, x29
0x00031060  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031064  mov      x26, x0
0x00031068  mov      x2, x25
0x0003106c  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00031070  mov      x0, x26
0x00031074  bl       #0x55d78   ; CALL _objc_release
0x00031078  mov      x0, x25
0x0003107c  bl       #0x55d78   ; CALL _objc_release
0x00031080  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x00031084  cmp      w24, #1
0x00031088  b.lt     #0x31104
0x0003108c  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x00031090  mov      x29, x29
0x00031094  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031098  b        #0x31118
0x0003109c  bl       #0x56940   ; CALL objc_msgSend$blackColor
0x000310a0  mov      x29, x29
0x000310a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000310a8  mov      x23, x0
0x000310ac  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000310b0  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000310b4  mov      x24, x0
0x000310b8  mov      x0, x21
0x000310bc  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x000310c0  mov      x29, x29
0x000310c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000310c8  mov      x21, x0
0x000310cc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000310d0  mov      x29, x29
0x000310d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000310d8  mov      x25, x0
0x000310dc  mov      x2, x24
0x000310e0  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x000310e4  mov      x0, x25
0x000310e8  bl       #0x55d78   ; CALL _objc_release
0x000310ec  mov      x0, x21
0x000310f0  bl       #0x55d78   ; CALL _objc_release
0x000310f4  cmp      x22, #1
0x000310f8  mov      x0, x23
0x000310fc  bl       #0x55d78   ; CALL _objc_release
0x00031100  b        #0x31238
0x00031104  fmov     d0, #1.00000000
0x00031108  fmov     d1, #0.75000000
0x0003110c  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x00031110  mov      x29, x29
0x00031114  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031118  mov      x24, x0
0x0003111c  mov      x0, x21
0x00031120  bl       #0x5dc80   ; CALL objc_msgSend$unitLabel
0x00031124  mov      x29, x29
0x00031128  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003112c  mov      x25, x0
0x00031130  mov      x2, x24
0x00031134  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00031138  mov      x0, x25
0x0003113c  bl       #0x55d78   ; CALL _objc_release
0x00031140  mov      x0, x24
0x00031144  bl       #0x55d78   ; CALL _objc_release
0x00031148  cmp      x22, #1
0x0003114c  b.eq     #0x3122c
0x00031150  movi     v0.16b, #0
0x00031154  stp      q0, q0, [sp, #0x30]
0x00031158  stp      q0, q0, [sp, #0x10]
0x0003115c  adrp     x0, #0x7f000
0x00031160  add      x0, x0, #0xbb8
0x00031164  add      x2, sp, #0x10
0x00031168  add      x3, sp, #0x50
0x0003116c  mov      w4, #0x10
0x00031170  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00031174  cbz      x0, #0x3122c
0x00031178  mov      x24, x0
0x0003117c  ldr      x8, [sp, #0x20]
0x00031180  ldr      x28, [x8]   ; @CSTR "m.fill"
0x00031184  adrp     x8, #0x65000
0x00031188  ldr      d8, [x8, #0x668]
0x0003118c  adrp     x22, #0x7f000
0x00031190  add      x22, x22, #0xbb8
0x00031194  mov      x20, #0
0x00031198  ldr      x8, [sp, #0x20]
0x0003119c  ldr      x8, [x8]   ; @CSTR "m.fill"
0x000311a0  cmp      x8, x28
0x000311a4  b.eq     #0x311b0
0x000311a8  mov      x0, x22
0x000311ac  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x000311b0  ldr      x8, [sp, #0x18]
0x000311b4  ldr      x25, [x8, x20, lsl #3]
0x000311b8  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x000311bc  fmov     d0, #1.00000000
0x000311c0  mov      v1.16b, v8.16b
0x000311c4  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x000311c8  mov      x29, x29
0x000311cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000311d0  mov      x26, x0
0x000311d4  mov      x0, x21
0x000311d8  mov      x2, x25
0x000311dc  bl       #0x56900   ; CALL objc_msgSend$bit:
0x000311e0  mov      x29, x29
0x000311e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000311e8  mov      x25, x0
0x000311ec  mov      x2, x26
0x000311f0  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x000311f4  mov      x0, x25
0x000311f8  bl       #0x55d78   ; CALL _objc_release
0x000311fc  mov      x0, x26
0x00031200  bl       #0x55d78   ; CALL _objc_release
0x00031204  add      x20, x20, #1
0x00031208  cmp      x24, x20
0x0003120c  b.ne     #0x31198
0x00031210  add      x2, sp, #0x10
0x00031214  add      x3, sp, #0x50
0x00031218  mov      x0, x22
0x0003121c  mov      w4, #0x10
0x00031220  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00031224  mov      x24, x0
0x00031228  cbnz     x0, #0x31194
0x0003122c  mov      x0, x23
0x00031230  bl       #0x55d78   ; CALL _objc_release
0x00031234  ldr      x20, [sp, #8]
0x00031238  mov      x0, x20
0x0003123c  bl       #0x55d78   ; CALL _objc_release
0x00031240  mov      x0, x19
0x00031244  bl       #0x55d78   ; CALL _objc_release
0x00031248  ldur     x8, [x29, #-0x80]
0x0003124c  adrp     x9, #0x74000
0x00031250  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00031254  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00031258  cmp      x9, x8
0x0003125c  b.ne     #0x31288
0x00031260  ldp      x29, x30, [sp, #0x160]
0x00031264  ldp      x20, x19, [sp, #0x150]
0x00031268  ldp      x22, x21, [sp, #0x140]
0x0003126c  ldp      x24, x23, [sp, #0x130]
0x00031270  ldp      x26, x25, [sp, #0x120]
0x00031274  ldp      x28, x27, [sp, #0x110]
0x00031278  ldp      d9, d8, [sp, #0x100]
0x0003127c  ldp      d11, d10, [sp, #0xf0]
0x00031280  add      sp, sp, #0x170
0x00031284  ret      
0x00031288  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[SPPBubbleView stackNumberAt:top:width:]  va=0x3128c size=304 types=v40@0:8d16d24d32
0x0003128c  stp      d13, d12, [sp, #-0x60]!
0x00031290  stp      d11, d10, [sp, #0x10]
0x00031294  stp      d9, d8, [sp, #0x20]
0x00031298  stp      x22, x21, [sp, #0x30]
0x0003129c  stp      x20, x19, [sp, #0x40]
0x000312a0  stp      x29, x30, [sp, #0x50]
0x000312a4  add      x29, sp, #0x50
0x000312a8  mov      v8.16b, v2.16b
0x000312ac  mov      v9.16b, v1.16b
0x000312b0  mov      v10.16b, v0.16b
0x000312b4  mov      x19, x0
0x000312b8  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x000312bc  mov      x29, x29
0x000312c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000312c4  mov      x20, x0
0x000312c8  bl       #0x57c60   ; CALL objc_msgSend$font
0x000312cc  mov      x29, x29
0x000312d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000312d4  mov      x21, x0
0x000312d8  bl       #0x58c60   ; CALL objc_msgSend$lineHeight
0x000312dc  frintp   d11, d0
0x000312e0  mov      x0, x21
0x000312e4  bl       #0x55d78   ; CALL _objc_release
0x000312e8  mov      x0, x20
0x000312ec  bl       #0x55d78   ; CALL _objc_release
0x000312f0  mov      x0, x19
0x000312f4  bl       #0x5dc80   ; CALL objc_msgSend$unitLabel
0x000312f8  mov      x29, x29
0x000312fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031300  mov      x20, x0
0x00031304  bl       #0x57c60   ; CALL objc_msgSend$font
0x00031308  mov      x29, x29
0x0003130c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031310  mov      x21, x0
0x00031314  bl       #0x58c60   ; CALL objc_msgSend$lineHeight
0x00031318  frintp   d12, d0
0x0003131c  mov      x0, x21
0x00031320  bl       #0x55d78   ; CALL _objc_release
0x00031324  mov      x0, x20
0x00031328  bl       #0x55d78   ; CALL _objc_release
0x0003132c  fmov     d0, #-0.50000000
0x00031330  fmul     d0, d8, d0
0x00031334  fadd     d10, d10, d0
0x00031338  mov      x0, x19
0x0003133c  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x00031340  mov      x29, x29
0x00031344  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031348  mov      x20, x0
0x0003134c  mov      v0.16b, v10.16b
0x00031350  mov      v1.16b, v9.16b
0x00031354  mov      v2.16b, v8.16b
0x00031358  mov      v3.16b, v11.16b
0x0003135c  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00031360  mov      x0, x20
0x00031364  bl       #0x55d78   ; CALL _objc_release
0x00031368  fadd     d0, d9, d11
0x0003136c  fmov     d1, #-3.00000000
0x00031370  fadd     d9, d0, d1
0x00031374  mov      x0, x19
0x00031378  bl       #0x5dc80   ; CALL objc_msgSend$unitLabel
0x0003137c  mov      x29, x29
0x00031380  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031384  mov      x19, x0
0x00031388  mov      v0.16b, v10.16b
0x0003138c  mov      v1.16b, v9.16b
0x00031390  mov      v2.16b, v8.16b
0x00031394  mov      v3.16b, v12.16b
0x00031398  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0003139c  mov      x0, x19
0x000313a0  ldp      x29, x30, [sp, #0x50]
0x000313a4  ldp      x20, x19, [sp, #0x40]
0x000313a8  ldp      x22, x21, [sp, #0x30]
0x000313ac  ldp      d9, d8, [sp, #0x20]
0x000313b0  ldp      d11, d10, [sp, #0x10]
0x000313b4  ldp      d13, d12, [sp], #0x60
0x000313b8  b        #0x55d78   ; CALL _objc_release

=== -[SPPBubbleView stackHeight]  va=0x313bc size=176 types=d16@0:8
0x000313bc  stp      d9, d8, [sp, #-0x40]!
0x000313c0  stp      x22, x21, [sp, #0x10]
0x000313c4  stp      x20, x19, [sp, #0x20]
0x000313c8  stp      x29, x30, [sp, #0x30]
0x000313cc  add      x29, sp, #0x30
0x000313d0  mov      x19, x0
0x000313d4  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x000313d8  mov      x29, x29
0x000313dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000313e0  mov      x20, x0
0x000313e4  bl       #0x57c60   ; CALL objc_msgSend$font
0x000313e8  mov      x29, x29
0x000313ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000313f0  mov      x21, x0
0x000313f4  bl       #0x58c60   ; CALL objc_msgSend$lineHeight
0x000313f8  frintp   d0, d0
0x000313fc  fmov     d1, #-3.00000000
0x00031400  fadd     d8, d0, d1
0x00031404  mov      x0, x19
0x00031408  bl       #0x5dc80   ; CALL objc_msgSend$unitLabel
0x0003140c  mov      x29, x29
0x00031410  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031414  mov      x19, x0
0x00031418  bl       #0x57c60   ; CALL objc_msgSend$font
0x0003141c  mov      x29, x29
0x00031420  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031424  mov      x22, x0
0x00031428  bl       #0x58c60   ; CALL objc_msgSend$lineHeight
0x0003142c  frintp   d0, d0
0x00031430  fadd     d8, d8, d0
0x00031434  mov      x0, x22
0x00031438  bl       #0x55d78   ; CALL _objc_release
0x0003143c  mov      x0, x19
0x00031440  bl       #0x55d78   ; CALL _objc_release
0x00031444  mov      x0, x21
0x00031448  bl       #0x55d78   ; CALL _objc_release
0x0003144c  mov      x0, x20
0x00031450  bl       #0x55d78   ; CALL _objc_release
0x00031454  mov      v0.16b, v8.16b
0x00031458  ldp      x29, x30, [sp, #0x30]
0x0003145c  ldp      x20, x19, [sp, #0x20]
0x00031460  ldp      x22, x21, [sp, #0x10]
0x00031464  ldp      d9, d8, [sp], #0x40
0x00031468  ret      

=== -[SPPBubbleView renderStyle]  va=0x3146c size=14228 types=v16@0:8
0x0003146c  stp      d15, d14, [sp, #-0xa0]!
0x00031470  stp      d13, d12, [sp, #0x10]
0x00031474  stp      d11, d10, [sp, #0x20]
0x00031478  stp      d9, d8, [sp, #0x30]
0x0003147c  stp      x28, x27, [sp, #0x40]
0x00031480  stp      x26, x25, [sp, #0x50]
0x00031484  stp      x24, x23, [sp, #0x60]
0x00031488  stp      x22, x21, [sp, #0x70]
0x0003148c  stp      x20, x19, [sp, #0x80]
0x00031490  stp      x29, x30, [sp, #0x90]
0x00031494  add      x29, sp, #0x90
0x00031498  sub      sp, sp, #0x250
0x0003149c  mov      x19, x0
0x000314a0  adrp     x8, #0x74000
0x000314a4  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000314a8  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000314ac  stur     x8, [x29, #-0xa8]
0x000314b0  bl       #0x58c40   ; CALL objc_msgSend$limit
0x000314b4  mov      x21, x0
0x000314b8  mov      x0, x19
0x000314bc  bl       #0x5ca20   ; CALL objc_msgSend$showIcon
0x000314c0  mov      x22, x0
0x000314c4  mov      x0, x19
0x000314c8  bl       #0x5ce80   ; CALL objc_msgSend$speedState
0x000314cc  mov      x27, x0
0x000314d0  mov      x0, x19
0x000314d4  bl       #0x5d300   ; CALL objc_msgSend$stateColor
0x000314d8  mov      x29, x29
0x000314dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000314e0  mov      x28, x0
0x000314e4  mov      x0, x19
0x000314e8  bl       #0x5ce60   ; CALL objc_msgSend$speedRatio
0x000314ec  mov      v8.16b, v0.16b
0x000314f0  mov      x0, x19
0x000314f4  bl       #0x5ce00   ; CALL objc_msgSend$speed
0x000314f8  mov      x20, x0
0x000314fc  adrp     x25, #0x8e000
0x00031500  tbnz     w0, #0x1f, #0x31534
0x00031504  ldr      x23, [x25, #0x958]   ; @CLASS NSString
0x00031508  mov      x0, x19
0x0003150c  bl       #0x5ce00   ; CALL objc_msgSend$speed
0x00031510  str      x0, [sp]
0x00031514  adrp     x2, #0x7b000
0x00031518  add      x2, x2, #0x3e8   ; STR "%d"
0x0003151c  mov      x0, x23
0x00031520  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00031524  mov      x29, x29
0x00031528  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003152c  mov      x23, x0
0x00031530  b        #0x3153c
0x00031534  adrp     x23, #0x7b000
0x00031538  add      x23, x23, #0x408   ; STR "--"
0x0003153c  mov      x0, x19
0x00031540  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x00031544  mov      x29, x29
0x00031548  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003154c  mov      x24, x0
0x00031550  mov      x2, x23
0x00031554  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00031558  mov      x0, x24
0x0003155c  bl       #0x55d78   ; CALL _objc_release
0x00031560  tbnz     w20, #0x1f, #0x3156c
0x00031564  mov      x0, x23
0x00031568  bl       #0x55d78   ; CALL _objc_release
0x0003156c  mov      x0, x19
0x00031570  bl       #0x59260   ; CALL objc_msgSend$numberColor
0x00031574  mov      x29, x29
0x00031578  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003157c  mov      x20, x0
0x00031580  mov      x0, x19
0x00031584  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x00031588  mov      x29, x29
0x0003158c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031590  mov      x23, x0
0x00031594  mov      x2, x20
0x00031598  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0003159c  mov      x0, x23
0x000315a0  bl       #0x55d78   ; CALL _objc_release
0x000315a4  mov      x0, x20
0x000315a8  bl       #0x55d78   ; CALL _objc_release
0x000315ac  mov      x0, x19
0x000315b0  bl       #0x5dc80   ; CALL objc_msgSend$unitLabel
0x000315b4  mov      x29, x29
0x000315b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000315bc  mov      x20, x0
0x000315c0  adrp     x2, #0x7b000
0x000315c4  add      x2, x2, #0x428   ; STR "km/h"
0x000315c8  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x000315cc  mov      x0, x20
0x000315d0  bl       #0x55d78   ; CALL _objc_release
0x000315d4  cmp      w21, #1
0x000315d8  b.lt     #0x3160c
0x000315dc  ldr      x20, [x25, #0x958]   ; @CLASS NSString
0x000315e0  mov      x0, x19
0x000315e4  bl       #0x58c40   ; CALL objc_msgSend$limit
0x000315e8  str      x0, [sp]
0x000315ec  adrp     x2, #0x7b000
0x000315f0  add      x2, x2, #0x3e8   ; STR "%d"
0x000315f4  mov      x0, x20
0x000315f8  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x000315fc  mov      x29, x29
0x00031600  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031604  mov      x20, x0
0x00031608  b        #0x31614
0x0003160c  adrp     x20, #0x7b000
0x00031610  add      x20, x20, #0x408   ; STR "--"
0x00031614  mov      x0, x19
0x00031618  bl       #0x5cb80   ; CALL objc_msgSend$sign
0x0003161c  mov      x29, x29
0x00031620  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031624  mov      x23, x0
0x00031628  bl       #0x589c0   ; CALL objc_msgSend$label
0x0003162c  mov      x29, x29
0x00031630  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031634  mov      x24, x0
0x00031638  mov      x2, x20
0x0003163c  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00031640  mov      x0, x24
0x00031644  bl       #0x55d78   ; CALL _objc_release
0x00031648  mov      x0, x23
0x0003164c  bl       #0x55d78   ; CALL _objc_release
0x00031650  cmp      w21, #1
0x00031654  b.lt     #0x31660
0x00031658  mov      x0, x20
0x0003165c  bl       #0x55d78   ; CALL _objc_release
0x00031660  cmp      w21, #1
0x00031664  cset     w20, lt
0x00031668  mov      x0, x19
0x0003166c  bl       #0x5cb80   ; CALL objc_msgSend$sign
0x00031670  mov      x29, x29
0x00031674  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031678  mov      x23, x0
0x0003167c  mov      x2, x20
0x00031680  bl       #0x5b6e0   ; CALL objc_msgSend$setMuted:
0x00031684  mov      x0, x23
0x00031688  bl       #0x55d78   ; CALL _objc_release
0x0003168c  eor      w20, w22, #1
0x00031690  mov      x0, x19
0x00031694  bl       #0x58040   ; CALL objc_msgSend$iconView
0x00031698  mov      x29, x29
0x0003169c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000316a0  mov      x23, x0
0x000316a4  mov      x2, x20
0x000316a8  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x000316ac  mov      x0, x23
0x000316b0  bl       #0x55d78   ; CALL _objc_release
0x000316b4  tbnz     w20, #0, #0x3177c
0x000316b8  mov      x0, x19
0x000316bc  bl       #0x58040   ; CALL objc_msgSend$iconView
0x000316c0  mov      x29, x29
0x000316c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000316c8  mov      x20, x0
0x000316cc  bl       #0x58120   ; CALL objc_msgSend$imageView
0x000316d0  mov      x29, x29
0x000316d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000316d8  mov      x23, x0
0x000316dc  bl       #0x58080   ; CALL objc_msgSend$image
0x000316e0  mov      x29, x29
0x000316e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000316e8  mov      x24, x0
0x000316ec  mov      x0, x19
0x000316f0  bl       #0x58020   ; CALL objc_msgSend$iconImage
0x000316f4  mov      x29, x29
0x000316f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000316fc  mov      x25, x0
0x00031700  bl       #0x55d78   ; CALL _objc_release
0x00031704  mov      x0, x24
0x00031708  bl       #0x55d78   ; CALL _objc_release
0x0003170c  mov      x0, x23
0x00031710  bl       #0x55d78   ; CALL _objc_release
0x00031714  mov      x0, x20
0x00031718  bl       #0x55d78   ; CALL _objc_release
0x0003171c  cmp      x24, x25
0x00031720  b.eq     #0x3177c
0x00031724  mov      x0, x19
0x00031728  bl       #0x58020   ; CALL objc_msgSend$iconImage
0x0003172c  mov      x29, x29
0x00031730  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031734  mov      x20, x0
0x00031738  mov      x0, x19
0x0003173c  bl       #0x58040   ; CALL objc_msgSend$iconView
0x00031740  mov      x29, x29
0x00031744  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031748  mov      x23, x0
0x0003174c  bl       #0x58120   ; CALL objc_msgSend$imageView
0x00031750  mov      x29, x29
0x00031754  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031758  mov      x24, x0
0x0003175c  mov      x2, x20
0x00031760  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00031764  mov      x0, x24
0x00031768  bl       #0x55d78   ; CALL _objc_release
0x0003176c  mov      x0, x23
0x00031770  bl       #0x55d78   ; CALL _objc_release
0x00031774  mov      x0, x20
0x00031778  bl       #0x55d78   ; CALL _objc_release
0x0003177c  adrp     x26, #0x8e000
0x00031780  ldr      x0, [x26, #0xab8]   ; @CLASS CATransaction
0x00031784  bl       #0x567a0   ; CALL objc_msgSend$begin
0x00031788  ldr      x0, [x26, #0xab8]   ; @CLASS CATransaction
0x0003178c  mov      w2, #1
0x00031790  bl       #0x5ad00   ; CALL objc_msgSend$setDisableActions:
0x00031794  mov      x0, x19
0x00031798  bl       #0x56b20   ; CALL objc_msgSend$builtStyle
0x0003179c  cmp      x0, #4
0x000317a0  str      x19, [sp, #0x50]
0x000317a4  b.gt     #0x3188c
0x000317a8  cmp      x0, #2
0x000317ac  b.gt     #0x31a80
0x000317b0  cmp      x0, #1
0x000317b4  b.eq     #0x32204
0x000317b8  cmp      x0, #2
0x000317bc  b.ne     #0x329e8
0x000317c0  mov      x0, x19
0x000317c4  bl       #0x57e20   ; CALL objc_msgSend$glass
0x000317c8  mov      x29, x29
0x000317cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000317d0  mov      x20, x0
0x000317d4  mov      x8, #0x4053000000000000
0x000317d8  fmov     d2, x8
0x000317dc  fmov     d0, #4.00000000
0x000317e0  fmov     d1, #4.00000000
0x000317e4  mov      v3.16b, v2.16b
0x000317e8  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x000317ec  mov      x0, x20
0x000317f0  bl       #0x55d78   ; CALL _objc_release
0x000317f4  mov      x0, x19
0x000317f8  bl       #0x57e20   ; CALL objc_msgSend$glass
0x000317fc  mov      x29, x29
0x00031800  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031804  mov      x20, x0
0x00031808  mov      x8, #0x4043000000000000
0x0003180c  fmov     d0, x8
0x00031810  bl       #0x5ab20   ; CALL objc_msgSend$setCorner:
0x00031814  mov      x0, x20
0x00031818  bl       #0x55d78   ; CALL _objc_release
0x0003181c  mov      x0, x19
0x00031820  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00031824  mov      x29, x29
0x00031828  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003182c  mov      x20, x0
0x00031830  adrp     x21, #0x8e000
0x00031834  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00031838  cmp      w27, #2
0x0003183c  b.ne     #0x32b10
0x00031840  adrp     x8, #0x65000
0x00031844  ldr      d1, [x8, #0xac0]
0x00031848  adrp     x8, #0x65000
0x0003184c  ldr      d2, [x8, #0xac8]
0x00031850  fmov     d0, #1.00000000
0x00031854  fmov     d3, #1.00000000
0x00031858  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0003185c  mov      x29, x29
0x00031860  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031864  mov      x22, x0
0x00031868  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x0003186c  adrp     x8, #0x65000
0x00031870  ldr      d0, [x8, #0xa68]
0x00031874  adrp     x8, #0x65000
0x00031878  ldr      d1, [x8, #0xab8]
0x0003187c  adrp     x8, #0x65000
0x00031880  ldr      d2, [x8, #0x648]
0x00031884  fmov     d3, #1.00000000
0x00031888  b        #0x32b58
0x0003188c  cmp      x0, #6
0x00031890  b.gt     #0x31bb4
0x00031894  cmp      x0, #5
0x00031898  b.eq     #0x32274
0x0003189c  cmp      x0, #6
0x000318a0  b.ne     #0x329e8
0x000318a4  mov      x0, x19
0x000318a8  bl       #0x5cb80   ; CALL objc_msgSend$sign
0x000318ac  mov      x29, x29
0x000318b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000318b4  mov      x20, x0
0x000318b8  adrp     x8, #0x65000
0x000318bc  ldr      d10, [x8, #0xc58]
0x000318c0  adrp     x8, #0x65000
0x000318c4  ldr      d1, [x8, #0xc60]
0x000318c8  mov      x8, #0x4049000000000000
0x000318cc  fmov     d2, x8
0x000318d0  mov      v0.16b, v10.16b
0x000318d4  bl       #0x3460c
0x000318d8  mov      x0, x20
0x000318dc  bl       #0x55d78   ; CALL _objc_release
0x000318e0  adrp     x8, #0x65000
0x000318e4  ldr      d8, [x8, #0xc20]
0x000318e8  mov      x8, #0x404f000000000000
0x000318ec  fmov     d2, x8
0x000318f0  mov      x0, x19
0x000318f4  mov      v0.16b, v10.16b
0x000318f8  mov      v1.16b, v8.16b
0x000318fc  bl       #0x5d2c0   ; CALL objc_msgSend$stackNumberAt:top:width:
0x00031900  mov      x0, x19
0x00031904  bl       #0x5d2a0   ; CALL objc_msgSend$stackHeight
0x00031908  fadd     d8, d0, d8
0x0003190c  cbz      w22, #0x31950
0x00031910  mov      x0, x19
0x00031914  bl       #0x58040   ; CALL objc_msgSend$iconView
0x00031918  mov      x29, x29
0x0003191c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031920  mov      x20, x0
0x00031924  fmov     d0, #8.00000000
0x00031928  fadd     d0, d8, d0
0x0003192c  fmov     d1, #9.00000000
0x00031930  fadd     d1, d0, d1
0x00031934  fmov     d2, #18.00000000
0x00031938  mov      v0.16b, v10.16b
0x0003193c  bl       #0x3460c
0x00031940  mov      x0, x20
0x00031944  bl       #0x55d78   ; CALL _objc_release
0x00031948  fmov     d0, #26.00000000
0x0003194c  fadd     d8, d8, d0
0x00031950  fmov     d0, #12.00000000
0x00031954  fadd     d8, d8, d0
0x00031958  mov      x0, x19
0x0003195c  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00031960  mov      x29, x29
0x00031964  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031968  mov      x20, x0
0x0003196c  adrp     x8, #0x65000
0x00031970  ldr      d9, [x8, #0xa00]
0x00031974  fmov     d0, xzr
0x00031978  fmov     d1, xzr
0x0003197c  mov      v2.16b, v9.16b
0x00031980  mov      v3.16b, v8.16b
0x00031984  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00031988  mov      x0, x20
0x0003198c  bl       #0x55d78   ; CALL _objc_release
0x00031990  mov      x0, x19
0x00031994  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00031998  mov      x29, x29
0x0003199c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000319a0  mov      x20, x0
0x000319a4  mov      v0.16b, v10.16b
0x000319a8  bl       #0x5ab20   ; CALL objc_msgSend$setCorner:
0x000319ac  mov      x0, x20
0x000319b0  bl       #0x55d78   ; CALL _objc_release
0x000319b4  adrp     x8, #0x8e000
0x000319b8  ldr      x0, [x8, #0xac0]   ; @CLASS UIBezierPath
0x000319bc  fmov     d0, #-1.50000000
0x000319c0  fadd     d3, d8, d0
0x000319c4  adrp     x8, #0x65000
0x000319c8  ldr      d2, [x8, #0xc68]
0x000319cc  adrp     x8, #0x65000
0x000319d0  ldr      d4, [x8, #0xc70]
0x000319d4  fmov     d0, #0.75000000
0x000319d8  fmov     d1, #0.75000000
0x000319dc  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x000319e0  mov      x29, x29
0x000319e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000319e8  mov      x22, x0
0x000319ec  mov      x0, x19
0x000319f0  bl       #0x595e0   ; CALL objc_msgSend$parts
0x000319f4  mov      x29, x29
0x000319f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000319fc  mov      x20, x0
0x00031a00  adrp     x2, #0x7b000
0x00031a04  add      x2, x2, #0x88   ; STR "ring"
0x00031a08  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00031a0c  mov      x29, x29
0x00031a10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031a14  mov      x21, x0
0x00031a18  mov      x0, x20
0x00031a1c  bl       #0x55d78   ; CALL _objc_release
0x00031a20  fmov     d0, xzr
0x00031a24  fmov     d1, xzr
0x00031a28  mov      x0, x21
0x00031a2c  mov      v2.16b, v9.16b
0x00031a30  mov      v3.16b, v8.16b
0x00031a34  mov      x1, x22
0x00031a38  bl       #0x3467c
0x00031a3c  cbz      w27, #0x3315c
0x00031a40  mov      x0, x28
0x00031a44  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00031a48  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00031a4c  stur     x0, [x29, #-0xd8]
0x00031a50  mov      x0, x28
0x00031a54  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00031a58  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00031a5c  stur     x0, [x29, #-0xd0]
0x00031a60  adrp     x8, #0x8e000
0x00031a64  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00031a68  sub      x2, x29, #0xd8
0x00031a6c  mov      w3, #2
0x00031a70  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00031a74  mov      x29, x29
0x00031a78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031a7c  b        #0x33168
0x00031a80  cmp      x0, #3
0x00031a84  b.eq     #0x324e8
0x00031a88  cmp      x0, #4
0x00031a8c  b.ne     #0x329e8
0x00031a90  mov      x0, x19
0x00031a94  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00031a98  mov      x29, x29
0x00031a9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031aa0  mov      x20, x0
0x00031aa4  mov      x8, #0x405f000000000000
0x00031aa8  fmov     d9, x8
0x00031aac  fmov     d0, xzr
0x00031ab0  fmov     d1, xzr
0x00031ab4  mov      v2.16b, v9.16b
0x00031ab8  mov      v3.16b, v9.16b
0x00031abc  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00031ac0  mov      x0, x20
0x00031ac4  bl       #0x55d78   ; CALL _objc_release
0x00031ac8  mov      x0, x19
0x00031acc  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00031ad0  mov      x29, x29
0x00031ad4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031ad8  mov      x20, x0
0x00031adc  fmov     d0, #28.00000000
0x00031ae0  bl       #0x5ab20   ; CALL objc_msgSend$setCorner:
0x00031ae4  mov      x0, x20
0x00031ae8  bl       #0x55d78   ; CALL _objc_release
0x00031aec  mov      x0, x19
0x00031af0  bl       #0x595e0   ; CALL objc_msgSend$parts
0x00031af4  mov      x29, x29
0x00031af8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031afc  mov      x20, x0
0x00031b00  adrp     x2, #0x7b000
0x00031b04  add      x2, x2, #0x168   ; STR "mesh"
0x00031b08  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00031b0c  mov      x29, x29
0x00031b10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031b14  mov      x23, x0
0x00031b18  mov      x0, x20
0x00031b1c  bl       #0x55d78   ; CALL _objc_release
0x00031b20  fmov     d0, xzr
0x00031b24  fmov     d1, xzr
0x00031b28  mov      x0, x23
0x00031b2c  mov      v2.16b, v9.16b
0x00031b30  mov      v3.16b, v9.16b
0x00031b34  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00031b38  cmp      w27, #0
0x00031b3c  cset     w2, ne
0x00031b40  mov      x0, x23
0x00031b44  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x00031b48  mov      x0, x19
0x00031b4c  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00031b50  mov      x29, x29
0x00031b54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031b58  mov      x20, x0
0x00031b5c  adrp     x21, #0x8e000
0x00031b60  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00031b64  cmp      w27, #1
0x00031b68  b.eq     #0x33b44
0x00031b6c  cmp      w27, #2
0x00031b70  b.ne     #0x33cb4
0x00031b74  adrp     x8, #0x65000
0x00031b78  ldr      d1, [x8, #0xb70]
0x00031b7c  adrp     x8, #0x65000
0x00031b80  ldr      d2, [x8, #0xb78]
0x00031b84  fmov     d0, #1.00000000
0x00031b88  fmov     d3, #1.00000000
0x00031b8c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00031b90  mov      x29, x29
0x00031b94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031b98  mov      x24, x0
0x00031b9c  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00031ba0  adrp     x8, #0x65000
0x00031ba4  ldr      d1, [x8, #0xad0]
0x00031ba8  adrp     x8, #0x65000
0x00031bac  ldr      d2, [x8, #0x8c8]
0x00031bb0  b        #0x33b80
0x00031bb4  cmp      x0, #7
0x00031bb8  b.eq     #0x32680
0x00031bbc  cmp      x0, #8
0x00031bc0  b.ne     #0x329e8
0x00031bc4  str      w21, [sp, #0x38]
0x00031bc8  str      w27, [sp, #0x44]
0x00031bcc  str      x28, [sp, #0x48]
0x00031bd0  adrp     x20, #0x74000
0x00031bd4  ldr      x20, [x20, #0x378]   ; @GOT __NSConcreteStackBlock
0x00031bd8  str      x20, [sp, #0x1a0]
0x00031bdc  adrp     x8, #0x65000
0x00031be0  ldr      d8, [x8, #0x6f8]
0x00031be4  str      d8, [sp, #0x1a8]
0x00031be8  adrp     x8, #0x34000
0x00031bec  add      x8, x8, #0xb80
0x00031bf0  adrp     x9, #0x74000
0x00031bf4  add      x9, x9, #0xbc0
0x00031bf8  stp      x8, x9, [sp, #0x1b0]
0x00031bfc  mov      x8, #0x4064000000000000
0x00031c00  str      x8, [sp, #0x1c0]
0x00031c04  add      x0, sp, #0x1a0
0x00031c08  bl       #0x55da8   ; CALL _objc_retainBlock
0x00031c0c  str      x0, [sp, #0x68]
0x00031c10  str      x20, [sp, #0x178]
0x00031c14  str      d8, [sp, #0x180]
0x00031c18  adrp     x8, #0x34000
0x00031c1c  add      x8, x8, #0xbb8
0x00031c20  adrp     x9, #0x74000
0x00031c24  add      x9, x9, #0xbe0
0x00031c28  stp      x8, x9, [sp, #0x188]
0x00031c2c  mov      x8, #0x800000000000
0x00031c30  movk     x8, #0x4051, lsl #48
0x00031c34  str      x8, [sp, #0x198]
0x00031c38  add      x0, sp, #0x178
0x00031c3c  bl       #0x55da8   ; CALL _objc_retainBlock
0x00031c40  mov      x23, x0
0x00031c44  mov      x0, x19
0x00031c48  bl       #0x57660   ; CALL objc_msgSend$deco
0x00031c4c  mov      x29, x29
0x00031c50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031c54  mov      x20, x0
0x00031c58  adrp     x8, #0x65000
0x00031c5c  ldr      d10, [x8, #0xb90]
0x00031c60  fmov     d11, xzr
0x00031c64  fmov     d0, xzr
0x00031c68  fmov     d1, xzr
0x00031c6c  mov      v2.16b, v10.16b
0x00031c70  mov      v3.16b, v10.16b
0x00031c74  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00031c78  mov      x0, x20
0x00031c7c  bl       #0x55d78   ; CALL _objc_release
0x00031c80  adrp     x22, #0x8e000
0x00031c84  ldr      x0, [x22, #0xac0]   ; @CLASS UIBezierPath
0x00031c88  adrp     x8, #0x65000
0x00031c8c  ldr      d8, [x8, #0xa00]
0x00031c90  adrp     x8, #0x65000
0x00031c94  ldr      d9, [x8, #0xb98]
0x00031c98  fmov     d3, xzr
0x00031c9c  mov      v0.16b, v8.16b
0x00031ca0  mov      v1.16b, v8.16b
0x00031ca4  mov      v2.16b, v8.16b
0x00031ca8  mov      v4.16b, v9.16b
0x00031cac  mov      w2, #1
0x00031cb0  bl       #0x56800   ; CALL objc_msgSend$bezierPathWithArcCenter:radius:startAngle:endAngle:clockwise:
0x00031cb4  mov      x29, x29
0x00031cb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031cbc  mov      x20, x0
0x00031cc0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00031cc4  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x00031cc8  mov      x24, x0
0x00031ccc  mov      x0, x19
0x00031cd0  bl       #0x57660   ; CALL objc_msgSend$deco
0x00031cd4  mov      x29, x29
0x00031cd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031cdc  mov      x25, x0
0x00031ce0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00031ce4  mov      x29, x29
0x00031ce8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031cec  mov      x26, x0
0x00031cf0  mov      x2, x24
0x00031cf4  bl       #0x5c020   ; CALL objc_msgSend$setShadowPath:
0x00031cf8  mov      x0, x26
0x00031cfc  bl       #0x55d78   ; CALL _objc_release
0x00031d00  mov      x0, x25
0x00031d04  bl       #0x55d78   ; CALL _objc_release
0x00031d08  mov      x0, x20
0x00031d0c  bl       #0x55d78   ; CALL _objc_release
0x00031d10  mov      x0, x19
0x00031d14  bl       #0x595e0   ; CALL objc_msgSend$parts
0x00031d18  mov      x29, x29
0x00031d1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031d20  mov      x20, x0
0x00031d24  adrp     x2, #0x7b000
0x00031d28  add      x2, x2, #0x208   ; STR "face"
0x00031d2c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00031d30  mov      x29, x29
0x00031d34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031d38  mov      x21, x0
0x00031d3c  mov      x0, x20
0x00031d40  bl       #0x55d78   ; CALL _objc_release
0x00031d44  fmov     d0, xzr
0x00031d48  fmov     d1, xzr
0x00031d4c  mov      x0, x21
0x00031d50  mov      v2.16b, v10.16b
0x00031d54  mov      v3.16b, v10.16b
0x00031d58  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00031d5c  mov      x0, x21
0x00031d60  mov      v0.16b, v8.16b
0x00031d64  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x00031d68  adrp     x8, #0x65000
0x00031d6c  ldr      d1, [x8, #0x738]
0x00031d70  fmov     d0, #0.50000000
0x00031d74  mov      x0, x21
0x00031d78  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x00031d7c  adrp     x8, #0x65000
0x00031d80  ldr      d0, [x8, #0xba0]
0x00031d84  adrp     x8, #0x65000
0x00031d88  ldr      d1, [x8, #0xba8]
0x00031d8c  str      x21, [sp, #0x30]
0x00031d90  mov      x0, x21
0x00031d94  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x00031d98  mov      x0, x19
0x00031d9c  bl       #0x595e0   ; CALL objc_msgSend$parts
0x00031da0  mov      x29, x29
0x00031da4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031da8  mov      x20, x0
0x00031dac  adrp     x2, #0x7b000
0x00031db0  add      x2, x2, #0x88   ; STR "ring"
0x00031db4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00031db8  mov      x29, x29
0x00031dbc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031dc0  mov      x24, x0
0x00031dc4  ldr      x0, [x22, #0xac0]   ; @CLASS UIBezierPath
0x00031dc8  adrp     x8, #0x65000
0x00031dcc  ldr      d2, [x8, #0xbb0]
0x00031dd0  fmov     d3, xzr
0x00031dd4  mov      v0.16b, v8.16b
0x00031dd8  mov      v1.16b, v8.16b
0x00031ddc  mov      v4.16b, v9.16b
0x00031de0  mov      w2, #1
0x00031de4  bl       #0x56800   ; CALL objc_msgSend$bezierPathWithArcCenter:radius:startAngle:endAngle:clockwise:
0x00031de8  mov      x29, x29
0x00031dec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031df0  mov      x25, x0
0x00031df4  fmov     d0, xzr
0x00031df8  fmov     d1, xzr
0x00031dfc  mov      x0, x24
0x00031e00  mov      v2.16b, v10.16b
0x00031e04  str      d10, [sp, #0x18]
0x00031e08  mov      v3.16b, v10.16b
0x00031e0c  mov      x1, x25
0x00031e10  bl       #0x3467c
0x00031e14  mov      x0, x25
0x00031e18  bl       #0x55d78   ; CALL _objc_release
0x00031e1c  mov      x0, x24
0x00031e20  bl       #0x55d78   ; CALL _objc_release
0x00031e24  mov      x0, x20
0x00031e28  bl       #0x55d78   ; CALL _objc_release
0x00031e2c  ldr      x0, [x22, #0xac0]   ; @CLASS UIBezierPath
0x00031e30  mov      x8, #0x4050000000000000
0x00031e34  fmov     d2, x8
0x00031e38  fmov     d3, xzr
0x00031e3c  mov      v0.16b, v8.16b
0x00031e40  stp      d9, d8, [sp, #0x20]
0x00031e44  mov      v1.16b, v8.16b
0x00031e48  mov      v4.16b, v9.16b
0x00031e4c  mov      w2, #1
0x00031e50  bl       #0x56800   ; CALL objc_msgSend$bezierPathWithArcCenter:radius:startAngle:endAngle:clockwise:
0x00031e54  mov      x29, x29
0x00031e58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031e5c  mov      x20, x0
0x00031e60  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00031e64  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x00031e68  mov      x24, x0
0x00031e6c  mov      x0, x19
0x00031e70  bl       #0x595e0   ; CALL objc_msgSend$parts
0x00031e74  mov      x29, x29
0x00031e78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031e7c  mov      x25, x0
0x00031e80  adrp     x2, #0x7b000
0x00031e84  add      x2, x2, #0x228   ; STR "inner"
0x00031e88  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00031e8c  mov      x29, x29
0x00031e90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031e94  mov      x26, x0
0x00031e98  mov      x2, x24
0x00031e9c  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x00031ea0  mov      x0, x26
0x00031ea4  bl       #0x55d78   ; CALL _objc_release
0x00031ea8  mov      x0, x25
0x00031eac  bl       #0x55d78   ; CALL _objc_release
0x00031eb0  mov      x0, x20
0x00031eb4  bl       #0x55d78   ; CALL _objc_release
0x00031eb8  ldr      x0, [x22, #0xac0]   ; @CLASS UIBezierPath
0x00031ebc  bl       #0x567e0   ; CALL objc_msgSend$bezierPath
0x00031ec0  mov      x29, x29
0x00031ec4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031ec8  str      x0, [sp, #0x60]
0x00031ecc  ldr      x0, [x22, #0xac0]   ; @CLASS UIBezierPath
0x00031ed0  bl       #0x567e0   ; CALL objc_msgSend$bezierPath
0x00031ed4  mov      x29, x29
0x00031ed8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031edc  str      x0, [sp, #0x58]
0x00031ee0  mov      x20, #0
0x00031ee4  mov      w24, #-0xa
0x00031ee8  mov      w25, #0xcccd
0x00031eec  movk     w25, #0xccc, lsl #16
0x00031ef0  mov      w26, #0x14
0x00031ef4  mov      w27, #8
0x00031ef8  adrp     x8, #0x65000
0x00031efc  ldr      d12, [x8, #0xbb8]
0x00031f00  adrp     x8, #0x65000
0x00031f04  ldr      d13, [x8, #0xbc0]
0x00031f08  fmov     d9, #-12.00000000
0x00031f0c  adrp     x22, #0x65000
0x00031f10  add      x22, x22, #0xd30
0x00031f14  fmov     d10, #-6.00000000
0x00031f18  fmov     d8, #10.00000000
0x00031f1c  add      w24, w24, #0xa
0x00031f20  umull    x8, w24, w25
0x00031f24  lsr      x8, x8, #0x20
0x00031f28  msub     w21, w8, w26, w24
0x00031f2c  ldr      x0, [sp, #0x68]
0x00031f30  ldr      x8, [x0, #0x10]
0x00031f34  mov      v0.16b, v11.16b
0x00031f38  blr      x8
0x00031f3c  mov      v14.16b, v0.16b
0x00031f40  cmp      w21, #0
0x00031f44  ldp      x9, x8, [sp, #0x58]
0x00031f48  csel     x28, x9, x8, eq
0x00031f4c  csel     x8, x27, xzr, eq
0x00031f50  ldr      d15, [x22, x8]
0x00031f54  ldr      x19, [x23, #0x10]
0x00031f58  mov      x0, x28
0x00031f5c  bl       #0x55d84   ; CALL _objc_retain
0x00031f60  mov      x0, x23
0x00031f64  mov      v0.16b, v15.16b
0x00031f68  mov      v1.16b, v14.16b
0x00031f6c  blr      x19
0x00031f70  mov      x0, x28
0x00031f74  bl       #0x59060   ; CALL objc_msgSend$moveToPoint:
0x00031f78  ldr      x8, [x23, #0x10]
0x00031f7c  mov      x0, x23
0x00031f80  mov      v0.16b, v12.16b
0x00031f84  mov      v1.16b, v14.16b
0x00031f88  blr      x8
0x00031f8c  mov      x0, x28
0x00031f90  bl       #0x56100   ; CALL objc_msgSend$addLineToPoint:
0x00031f94  mov      x0, x28
0x00031f98  bl       #0x55d78   ; CALL _objc_release
0x00031f9c  cbnz     w21, #0x32080
0x00031fa0  ldr      x19, [sp, #0x50]
0x00031fa4  mov      x0, x19
0x00031fa8  bl       #0x5da00   ; CALL objc_msgSend$tickLabels
0x00031fac  mov      x29, x29
0x00031fb0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031fb4  mov      x28, x0
0x00031fb8  bl       #0x573c0   ; CALL objc_msgSend$count
0x00031fbc  mov      x21, x0
0x00031fc0  mov      x0, x28
0x00031fc4  bl       #0x55d78   ; CALL _objc_release
0x00031fc8  cmp      x20, x21
0x00031fcc  b.ge     #0x32080
0x00031fd0  mov      x0, x19
0x00031fd4  bl       #0x5da00   ; CALL objc_msgSend$tickLabels
0x00031fd8  mov      x29, x29
0x00031fdc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031fe0  mov      x21, x0
0x00031fe4  add      x28, x20, #1
0x00031fe8  mov      x2, x20
0x00031fec  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00031ff0  mov      x29, x29
0x00031ff4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00031ff8  mov      x20, x0
0x00031ffc  mov      x0, x21
0x00032000  bl       #0x55d78   ; CALL _objc_release
0x00032004  mov      x0, x20
0x00032008  mov      w2, #0
0x0003200c  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x00032010  adrp     x8, #0x8e000
0x00032014  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00032018  str      x24, [sp]
0x0003201c  adrp     x2, #0x7b000
0x00032020  add      x2, x2, #0x3e8   ; STR "%d"
0x00032024  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00032028  mov      x29, x29
0x0003202c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032030  mov      x21, x0
0x00032034  mov      x0, x20
0x00032038  mov      x2, x21
0x0003203c  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00032040  mov      x0, x21
0x00032044  bl       #0x55d78   ; CALL _objc_release
0x00032048  ldr      x8, [x23, #0x10]
0x0003204c  mov      x0, x23
0x00032050  mov      v0.16b, v13.16b
0x00032054  mov      v1.16b, v14.16b
0x00032058  blr      x8
0x0003205c  fadd     d0, d0, d9
0x00032060  fadd     d1, d1, d10
0x00032064  fmov     d2, #24.00000000
0x00032068  fmov     d3, #12.00000000
0x0003206c  mov      x0, x20
0x00032070  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00032074  mov      x0, x20
0x00032078  bl       #0x55d78   ; CALL _objc_release
0x0003207c  mov      x20, x28
0x00032080  fadd     d11, d11, d8
0x00032084  cmp      w24, #0x97
0x00032088  b.lo     #0x31f1c
0x0003208c  ldr      x19, [sp, #0x50]
0x00032090  mov      x0, x19
0x00032094  bl       #0x5da00   ; CALL objc_msgSend$tickLabels
0x00032098  mov      x29, x29
0x0003209c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000320a0  mov      x24, x0
0x000320a4  bl       #0x573c0   ; CALL objc_msgSend$count
0x000320a8  mov      x28, x0
0x000320ac  mov      x0, x24
0x000320b0  bl       #0x55d78   ; CALL _objc_release
0x000320b4  cmp      x20, x28
0x000320b8  b.ge     #0x3212c
0x000320bc  mov      x0, x19
0x000320c0  bl       #0x5da00   ; CALL objc_msgSend$tickLabels
0x000320c4  mov      x29, x29
0x000320c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000320cc  mov      x21, x0
0x000320d0  mov      x2, x20
0x000320d4  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000320d8  mov      x29, x29
0x000320dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000320e0  mov      x24, x0
0x000320e4  mov      w2, #1
0x000320e8  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x000320ec  mov      x0, x24
0x000320f0  bl       #0x55d78   ; CALL _objc_release
0x000320f4  mov      x0, x21
0x000320f8  bl       #0x55d78   ; CALL _objc_release
0x000320fc  add      x20, x20, #1
0x00032100  mov      x0, x19
0x00032104  bl       #0x5da00   ; CALL objc_msgSend$tickLabels
0x00032108  mov      x29, x29
0x0003210c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032110  mov      x21, x0
0x00032114  bl       #0x573c0   ; CALL objc_msgSend$count
0x00032118  mov      x24, x0
0x0003211c  mov      x0, x21
0x00032120  bl       #0x55d78   ; CALL _objc_release
0x00032124  cmp      x20, x24
0x00032128  b.lt     #0x320bc
0x0003212c  ldr      x0, [sp, #0x60]
0x00032130  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00032134  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x00032138  mov      x20, x0
0x0003213c  mov      x0, x19
0x00032140  bl       #0x595e0   ; CALL objc_msgSend$parts
0x00032144  mov      x29, x29
0x00032148  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003214c  mov      x21, x0
0x00032150  adrp     x2, #0x7b000
0x00032154  add      x2, x2, #0x288   ; STR "minor"
0x00032158  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0003215c  mov      x29, x29
0x00032160  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032164  mov      x24, x0
0x00032168  mov      x2, x20
0x0003216c  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x00032170  mov      x0, x24
0x00032174  bl       #0x55d78   ; CALL _objc_release
0x00032178  mov      x0, x21
0x0003217c  bl       #0x55d78   ; CALL _objc_release
0x00032180  ldr      x0, [sp, #0x58]
0x00032184  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00032188  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x0003218c  mov      x20, x0
0x00032190  mov      x0, x19
0x00032194  bl       #0x595e0   ; CALL objc_msgSend$parts
0x00032198  mov      x29, x29
0x0003219c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000321a0  mov      x21, x0
0x000321a4  adrp     x2, #0x7b000
0x000321a8  add      x2, x2, #0x2a8   ; STR "major"
0x000321ac  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000321b0  mov      x29, x29
0x000321b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000321b8  mov      x24, x0
0x000321bc  mov      x2, x20
0x000321c0  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x000321c4  mov      x0, x24
0x000321c8  bl       #0x55d78   ; CALL _objc_release
0x000321cc  mov      x0, x21
0x000321d0  bl       #0x55d78   ; CALL _objc_release
0x000321d4  ldr      w8, [sp, #0x38]
0x000321d8  cmp      w8, #1
0x000321dc  ldr      w24, [sp, #0x44]
0x000321e0  adrp     x26, #0x8e000
0x000321e4  ldr      d8, [sp, #0x28]
0x000321e8  adrp     x27, #0x8e000
0x000321ec  ldr      d9, [sp, #0x18]
0x000321f0  b.lt     #0x332f0
0x000321f4  mov      x0, x19
0x000321f8  bl       #0x58c40   ; CALL objc_msgSend$limit
0x000321fc  scvtf    d11, w0
0x00032200  b        #0x332f4
0x00032204  adrp     x2, #0x7b000
0x00032208  add      x2, x2, #0xc8   ; STR "dot"
0x0003220c  mov      x0, x19
0x00032210  bl       #0x56900   ; CALL objc_msgSend$bit:
0x00032214  mov      x29, x29
0x00032218  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003221c  mov      x20, x0
0x00032220  mov      x2, x22
0x00032224  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x00032228  cbz      w27, #0x32d6c
0x0003222c  mov      x0, x20
0x00032230  mov      x2, x28
0x00032234  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x00032238  cbz      w22, #0x32db8
0x0003223c  mov      x0, x19
0x00032240  bl       #0x58040   ; CALL objc_msgSend$iconView
0x00032244  mov      x29, x29
0x00032248  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003224c  mov      x22, x0
0x00032250  fmov     d0, #21.00000000
0x00032254  fmov     d1, #30.00000000
0x00032258  fmov     d2, #22.00000000
0x0003225c  bl       #0x3460c
0x00032260  mov      x0, x22
0x00032264  bl       #0x55d78   ; CALL _objc_release
0x00032268  mov      x8, #0x4045000000000000
0x0003226c  fmov     d10, x8
0x00032270  b        #0x32dd4
0x00032274  cmp      w22, #0
0x00032278  fmov     d0, xzr
0x0003227c  fmov     d1, #24.00000000
0x00032280  fcsel    d9, d1, d0, ne
0x00032284  cbz      w22, #0x322b4
0x00032288  mov      x0, x19
0x0003228c  bl       #0x58040   ; CALL objc_msgSend$iconView
0x00032290  mov      x29, x29
0x00032294  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032298  mov      x20, x0
0x0003229c  fmov     d0, #10.00000000
0x000322a0  fmov     d1, #10.00000000
0x000322a4  fmov     d2, #20.00000000
0x000322a8  bl       #0x3460c
0x000322ac  mov      x0, x20
0x000322b0  bl       #0x55d78   ; CALL _objc_release
0x000322b4  adrp     x8, #0x8e000
0x000322b8  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x000322bc  adrp     x8, #0x65000
0x000322c0  ldr      d0, [x8, #0x820]
0x000322c4  adrp     x8, #0x65000
0x000322c8  ldr      d1, [x8, #0xad0]
0x000322cc  adrp     x8, #0x65000
0x000322d0  ldr      d2, [x8, #0x928]
0x000322d4  fmov     d3, #1.00000000
0x000322d8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000322dc  mov      x29, x29
0x000322e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000322e4  mov      x20, x0
0x000322e8  mov      x0, x19
0x000322ec  bl       #0x5dc80   ; CALL objc_msgSend$unitLabel
0x000322f0  mov      x29, x29
0x000322f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000322f8  mov      x22, x0
0x000322fc  mov      x2, x20
0x00032300  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00032304  mov      x0, x22
0x00032308  bl       #0x55d78   ; CALL _objc_release
0x0003230c  mov      x0, x20
0x00032310  bl       #0x55d78   ; CALL _objc_release
0x00032314  mov      x0, x19
0x00032318  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x0003231c  mov      x29, x29
0x00032320  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032324  mov      x20, x0
0x00032328  adrp     x8, #0x65000
0x0003232c  ldr      d0, [x8, #0xc78]
0x00032330  mov      x8, #0x404e000000000000
0x00032334  fmov     d1, x8
0x00032338  bl       #0x5cbc0   ; CALL objc_msgSend$sizeThatFits:
0x0003233c  frintp   d11, d0
0x00032340  mov      x0, x20
0x00032344  bl       #0x55d78   ; CALL _objc_release
0x00032348  mov      x0, x19
0x0003234c  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x00032350  mov      x29, x29
0x00032354  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032358  mov      x20, x0
0x0003235c  mov      x8, #0x404a000000000000
0x00032360  fmov     d10, x8
0x00032364  fmov     d0, xzr
0x00032368  mov      v1.16b, v9.16b
0x0003236c  mov      v2.16b, v11.16b
0x00032370  mov      v3.16b, v10.16b
0x00032374  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00032378  mov      x0, x20
0x0003237c  bl       #0x55d78   ; CALL _objc_release
0x00032380  mov      x0, x19
0x00032384  bl       #0x5dc80   ; CALL objc_msgSend$unitLabel
0x00032388  mov      x29, x29
0x0003238c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032390  mov      x20, x0
0x00032394  mov      x0, x19
0x00032398  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x0003239c  mov      x29, x29
0x000323a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000323a4  mov      x22, x0
0x000323a8  mov      x0, x20
0x000323ac  mov      x1, x22
0x000323b0  bl       #0x34760
0x000323b4  mov      x0, x22
0x000323b8  bl       #0x55d78   ; CALL _objc_release
0x000323bc  mov      x0, x20
0x000323c0  bl       #0x55d78   ; CALL _objc_release
0x000323c4  mov      x0, x19
0x000323c8  bl       #0x5dc80   ; CALL objc_msgSend$unitLabel
0x000323cc  mov      x29, x29
0x000323d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000323d4  mov      x20, x0
0x000323d8  bl       #0x57d00   ; CALL objc_msgSend$frame
0x000323dc  bl       #0x55a48   ; CALL _CGRectGetMaxX
0x000323e0  mov      v11.16b, v0.16b
0x000323e4  mov      x0, x20
0x000323e8  bl       #0x55d78   ; CALL _objc_release
0x000323ec  mov      x8, #0x4057000000000000
0x000323f0  fmov     d12, x8
0x000323f4  fcmp     d11, d12
0x000323f8  fcsel    d11, d12, d11, mi
0x000323fc  fadd     d0, d9, d10
0x00032400  fmov     d1, #3.00000000
0x00032404  fadd     d9, d0, d1
0x00032408  adrp     x2, #0x7b000
0x0003240c  add      x2, x2, #0x128   ; STR "track"
0x00032410  mov      x0, x19
0x00032414  bl       #0x56900   ; CALL objc_msgSend$bit:
0x00032418  mov      x29, x29
0x0003241c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032420  mov      x22, x0
0x00032424  adrp     x2, #0x7b000
0x00032428  add      x2, x2, #0x148   ; STR "fill"
0x0003242c  mov      x0, x19
0x00032430  bl       #0x56900   ; CALL objc_msgSend$bit:
0x00032434  mov      x29, x29
0x00032438  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003243c  mov      x23, x0
0x00032440  fmov     d0, xzr
0x00032444  fmov     d3, #5.00000000
0x00032448  mov      x0, x22
0x0003244c  mov      v1.16b, v9.16b
0x00032450  mov      v2.16b, v12.16b
0x00032454  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00032458  mov      x0, x19
0x0003245c  bl       #0x595e0   ; CALL objc_msgSend$parts
0x00032460  mov      x29, x29
0x00032464  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032468  mov      x20, x0
0x0003246c  adrp     x2, #0x7b000
0x00032470  add      x2, x2, #0x188   ; STR "fillGrad"
0x00032474  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00032478  mov      x29, x29
0x0003247c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032480  mov      x24, x0
0x00032484  mov      x0, x20
0x00032488  bl       #0x55d78   ; CALL _objc_release
0x0003248c  fmov     d0, xzr
0x00032490  fmov     d1, xzr
0x00032494  fmov     d3, #5.00000000
0x00032498  mov      x0, x24
0x0003249c  mov      v2.16b, v12.16b
0x000324a0  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x000324a4  cbz      w27, #0x32f3c
0x000324a8  mov      x0, x28
0x000324ac  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000324b0  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000324b4  stur     x0, [x29, #-0xc8]
0x000324b8  mov      x0, x28
0x000324bc  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000324c0  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000324c4  stur     x0, [x29, #-0xc0]
0x000324c8  adrp     x8, #0x8e000
0x000324cc  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000324d0  sub      x2, x29, #0xc8
0x000324d4  mov      w3, #2
0x000324d8  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000324dc  mov      x29, x29
0x000324e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000324e4  b        #0x32f48
0x000324e8  mov      x0, x19
0x000324ec  bl       #0x57e20   ; CALL objc_msgSend$glass
0x000324f0  mov      x29, x29
0x000324f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000324f8  mov      x20, x0
0x000324fc  mov      x8, #0x405a000000000000
0x00032500  fmov     d9, x8
0x00032504  fmov     d0, xzr
0x00032508  fmov     d1, xzr
0x0003250c  mov      v2.16b, v9.16b
0x00032510  mov      v3.16b, v9.16b
0x00032514  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00032518  mov      x0, x20
0x0003251c  bl       #0x55d78   ; CALL _objc_release
0x00032520  mov      x0, x19
0x00032524  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00032528  mov      x29, x29
0x0003252c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032530  mov      x20, x0
0x00032534  mov      x8, #0x404a000000000000
0x00032538  fmov     d10, x8
0x0003253c  mov      v0.16b, v10.16b
0x00032540  bl       #0x5ab20   ; CALL objc_msgSend$setCorner:
0x00032544  mov      x0, x20
0x00032548  bl       #0x55d78   ; CALL _objc_release
0x0003254c  adrp     x8, #0x8e000
0x00032550  ldr      x0, [x8, #0xac0]   ; @CLASS UIBezierPath
0x00032554  mov      x8, #0x4047000000000000
0x00032558  fmov     d2, x8
0x0003255c  adrp     x8, #0x65000
0x00032560  ldr      d3, [x8, #0xcb0]
0x00032564  adrp     x8, #0x65000
0x00032568  ldr      d4, [x8, #0xcb8]
0x0003256c  mov      v0.16b, v10.16b
0x00032570  mov      v1.16b, v10.16b
0x00032574  mov      w2, #1
0x00032578  bl       #0x56800   ; CALL objc_msgSend$bezierPathWithArcCenter:radius:startAngle:endAngle:clockwise:
0x0003257c  mov      x29, x29
0x00032580  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032584  mov      x22, x0
0x00032588  mov      x0, x19
0x0003258c  bl       #0x595e0   ; CALL objc_msgSend$parts
0x00032590  mov      x29, x29
0x00032594  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032598  mov      x20, x0
0x0003259c  adrp     x2, #0x7b000
0x000325a0  add      x2, x2, #0x128   ; STR "track"
0x000325a4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000325a8  mov      x29, x29
0x000325ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000325b0  mov      x23, x0
0x000325b4  mov      x0, x20
0x000325b8  bl       #0x55d78   ; CALL _objc_release
0x000325bc  fmov     d0, xzr
0x000325c0  fmov     d1, xzr
0x000325c4  mov      x0, x23
0x000325c8  mov      v2.16b, v9.16b
0x000325cc  mov      v3.16b, v9.16b
0x000325d0  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x000325d4  mov      x0, x22
0x000325d8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000325dc  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x000325e0  mov      x2, x0
0x000325e4  mov      x0, x23
0x000325e8  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x000325ec  mov      x0, x19
0x000325f0  bl       #0x595e0   ; CALL objc_msgSend$parts
0x000325f4  mov      x29, x29
0x000325f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000325fc  mov      x20, x0
0x00032600  adrp     x2, #0x7b000
0x00032604  add      x2, x2, #0x148   ; STR "fill"
0x00032608  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0003260c  mov      x29, x29
0x00032610  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032614  mov      x24, x0
0x00032618  mov      x0, x20
0x0003261c  bl       #0x55d78   ; CALL _objc_release
0x00032620  fmov     d0, xzr
0x00032624  fmov     d1, xzr
0x00032628  mov      x0, x24
0x0003262c  mov      v2.16b, v9.16b
0x00032630  mov      v3.16b, v9.16b
0x00032634  mov      x1, x22
0x00032638  bl       #0x3467c
0x0003263c  cbz      w27, #0x3301c
0x00032640  mov      x0, x28
0x00032644  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00032648  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0003264c  stur     x0, [x29, #-0xb8]
0x00032650  mov      x0, x28
0x00032654  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00032658  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0003265c  stur     x0, [x29, #-0xb0]
0x00032660  adrp     x8, #0x8e000
0x00032664  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00032668  sub      x2, x29, #0xb8
0x0003266c  mov      w3, #2
0x00032670  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00032674  mov      x29, x29
0x00032678  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003267c  b        #0x33028
0x00032680  str      d8, [sp, #0x68]
0x00032684  fmov     d11, #10.00000000
0x00032688  cbz      w22, #0x326c0
0x0003268c  mov      x0, x19
0x00032690  bl       #0x58040   ; CALL objc_msgSend$iconView
0x00032694  mov      x29, x29
0x00032698  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003269c  mov      x20, x0
0x000326a0  fmov     d0, #17.00000000
0x000326a4  fmov     d1, #29.00000000
0x000326a8  fmov     d2, #22.00000000
0x000326ac  bl       #0x3460c
0x000326b0  mov      x0, x20
0x000326b4  bl       #0x55d78   ; CALL _objc_release
0x000326b8  mov      x8, #0x4042000000000000
0x000326bc  fmov     d11, x8
0x000326c0  mov      x0, x19
0x000326c4  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x000326c8  mov      x29, x29
0x000326cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000326d0  mov      x20, x0
0x000326d4  mov      x8, #0x4069000000000000
0x000326d8  fmov     d9, x8
0x000326dc  mov      x8, #0x4044000000000000
0x000326e0  fmov     d1, x8
0x000326e4  mov      v0.16b, v9.16b
0x000326e8  bl       #0x5cbc0   ; CALL objc_msgSend$sizeThatFits:
0x000326ec  frintp   d8, d0
0x000326f0  mov      x0, x20
0x000326f4  bl       #0x55d78   ; CALL _objc_release
0x000326f8  mov      x0, x19
0x000326fc  bl       #0x5dc80   ; CALL objc_msgSend$unitLabel
0x00032700  mov      x29, x29
0x00032704  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032708  mov      x20, x0
0x0003270c  fmov     d1, #20.00000000
0x00032710  mov      v0.16b, v9.16b
0x00032714  bl       #0x5cbc0   ; CALL objc_msgSend$sizeThatFits:
0x00032718  frintp   d9, d0
0x0003271c  mov      x0, x20
0x00032720  bl       #0x55d78   ; CALL _objc_release
0x00032724  fcmp     d8, d9
0x00032728  fcsel    d9, d9, d8, mi
0x0003272c  fmov     d8, #0.50000000
0x00032730  fmul     d0, d9, d8
0x00032734  fadd     d10, d11, d0
0x00032738  mov      x0, x19
0x0003273c  bl       #0x5d2a0   ; CALL objc_msgSend$stackHeight
0x00032740  fmul     d0, d0, d8
0x00032744  fmov     d1, #29.00000000
0x00032748  fsub     d1, d1, d0
0x0003274c  mov      x0, x19
0x00032750  mov      v0.16b, v10.16b
0x00032754  mov      v2.16b, v9.16b
0x00032758  bl       #0x5d2c0   ; CALL objc_msgSend$stackNumberAt:top:width:
0x0003275c  fmov     d0, #8.00000000
0x00032760  fadd     d0, d9, d0
0x00032764  fadd     d8, d11, d0
0x00032768  adrp     x2, #0x7b000
0x0003276c  add      x2, x2, #0x1c8   ; STR "ticks"
0x00032770  mov      x0, x19
0x00032774  bl       #0x56900   ; CALL objc_msgSend$bit:
0x00032778  mov      x29, x29
0x0003277c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032780  mov      x22, x0
0x00032784  adrp     x2, #0x7b000
0x00032788  add      x2, x2, #0x148   ; STR "fill"
0x0003278c  mov      x0, x19
0x00032790  bl       #0x56900   ; CALL objc_msgSend$bit:
0x00032794  mov      x29, x29
0x00032798  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003279c  mov      x23, x0
0x000327a0  adrp     x8, #0x65000
0x000327a4  ldr      d2, [x8, #0xbb8]
0x000327a8  fmov     d13, #24.00000000
0x000327ac  fmov     d1, #17.00000000
0x000327b0  fmov     d3, #24.00000000
0x000327b4  mov      x0, x22
0x000327b8  stp      d2, d8, [sp, #0x58]
0x000327bc  mov      v0.16b, v8.16b
0x000327c0  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x000327c4  adrp     x21, #0x8e000
0x000327c8  ldr      x0, [x21, #0xac0]   ; @CLASS UIBezierPath
0x000327cc  bl       #0x567e0   ; CALL objc_msgSend$bezierPath
0x000327d0  mov      x29, x29
0x000327d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000327d8  mov      x24, x0
0x000327dc  fmov     d11, xzr
0x000327e0  fmov     d14, #2.50000000
0x000327e4  adrp     x8, #0x65000
0x000327e8  ldr      d15, [x8, #0xc38]
0x000327ec  fmov     d8, #1.00000000
0x000327f0  adrp     x8, #0x65000
0x000327f4  ldr      d9, [x8, #0xc40]
0x000327f8  fmov     d10, #5.00000000
0x000327fc  adrp     x8, #0x65000
0x00032800  ldr      d12, [x8, #0xc48]
0x00032804  fadd     d0, d11, d14
0x00032808  fdiv     d0, d0, d15
0x0003280c  fadd     d0, d0, d8
0x00032810  fmul     d1, d0, d9
0x00032814  ldr      x0, [x21, #0xac0]   ; @CLASS UIBezierPath
0x00032818  fsub     d3, d13, d1
0x0003281c  fmov     d2, #5.00000000
0x00032820  fmov     d4, #1.50000000
0x00032824  mov      v0.16b, v11.16b
0x00032828  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x0003282c  mov      x29, x29
0x00032830  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032834  mov      x20, x0
0x00032838  mov      x0, x24
0x0003283c  mov      x2, x20
0x00032840  bl       #0x56480   ; CALL objc_msgSend$appendPath:
0x00032844  mov      x0, x20
0x00032848  bl       #0x55d78   ; CALL _objc_release
0x0003284c  fmov     d0, #8.00000000
0x00032850  fadd     d11, d11, d0
0x00032854  fadd     d0, d11, d10
0x00032858  fcmp     d0, d12
0x0003285c  b.ls     #0x32804
0x00032860  mov      x0, x19
0x00032864  bl       #0x595e0   ; CALL objc_msgSend$parts
0x00032868  mov      x29, x29
0x0003286c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032870  mov      x20, x0
0x00032874  adrp     x2, #0x7b000
0x00032878  add      x2, x2, #0x1e8   ; STR "ticksMask"
0x0003287c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00032880  mov      x29, x29
0x00032884  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032888  mov      x25, x0
0x0003288c  mov      x0, x20
0x00032890  bl       #0x55d78   ; CALL _objc_release
0x00032894  mov      x0, x22
0x00032898  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0003289c  mov      x0, x25
0x000328a0  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x000328a4  mov      x0, x24
0x000328a8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000328ac  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x000328b0  mov      x2, x0
0x000328b4  mov      x0, x25
0x000328b8  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x000328bc  mov      x0, x19
0x000328c0  bl       #0x595e0   ; CALL objc_msgSend$parts
0x000328c4  mov      x29, x29
0x000328c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000328cc  mov      x20, x0
0x000328d0  adrp     x2, #0x7b000
0x000328d4  add      x2, x2, #0x188   ; STR "fillGrad"
0x000328d8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000328dc  mov      x29, x29
0x000328e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000328e4  mov      x26, x0
0x000328e8  mov      x0, x20
0x000328ec  bl       #0x55d78   ; CALL _objc_release
0x000328f0  fmov     d0, xzr
0x000328f4  fmov     d1, xzr
0x000328f8  fmov     d3, #24.00000000
0x000328fc  mov      x0, x26
0x00032900  ldr      d10, [sp, #0x58]
0x00032904  mov      v2.16b, v10.16b
0x00032908  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0003290c  cmp      w27, #1
0x00032910  b.eq     #0x33a70
0x00032914  cmp      w27, #2
0x00032918  ldr      d8, [sp, #0x68]
0x0003291c  b.ne     #0x33b8c
0x00032920  adrp     x21, #0x8e000
0x00032924  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00032928  adrp     x8, #0x65000
0x0003292c  ldr      d11, [x8, #0xac0]
0x00032930  adrp     x8, #0x65000
0x00032934  ldr      d12, [x8, #0xac8]
0x00032938  fmov     d0, #1.00000000
0x0003293c  fmov     d3, #1.00000000
0x00032940  mov      v1.16b, v11.16b
0x00032944  mov      v2.16b, v12.16b
0x00032948  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0003294c  mov      x29, x29
0x00032950  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032954  mov      x20, x0
0x00032958  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0003295c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00032960  stur     x0, [x29, #-0xe8]
0x00032964  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00032968  fmov     d0, #1.00000000
0x0003296c  fmov     d3, #1.00000000
0x00032970  mov      v1.16b, v11.16b
0x00032974  mov      v2.16b, v12.16b
0x00032978  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0003297c  mov      x29, x29
0x00032980  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032984  mov      x21, x27
0x00032988  mov      x27, x0
0x0003298c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00032990  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00032994  stur     x0, [x29, #-0xe0]
0x00032998  adrp     x8, #0x8e000
0x0003299c  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000329a0  sub      x2, x29, #0xe8
0x000329a4  mov      w3, #2
0x000329a8  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000329ac  mov      x29, x29
0x000329b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000329b4  mov      x19, x28
0x000329b8  mov      x28, x0
0x000329bc  mov      x0, x26
0x000329c0  mov      x2, x28
0x000329c4  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x000329c8  mov      x0, x28
0x000329cc  mov      x28, x19
0x000329d0  bl       #0x55d78   ; CALL _objc_release
0x000329d4  mov      x0, x27
0x000329d8  mov      x27, x21
0x000329dc  ldr      x19, [sp, #0x50]
0x000329e0  bl       #0x55d78   ; CALL _objc_release
0x000329e4  b        #0x33ba8
0x000329e8  mov      x0, x19
0x000329ec  bl       #0x57e20   ; CALL objc_msgSend$glass
0x000329f0  mov      x29, x29
0x000329f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000329f8  mov      x20, x0
0x000329fc  mov      x8, #0x4059000000000000
0x00032a00  fmov     d8, x8
0x00032a04  fmov     d0, #4.00000000
0x00032a08  fmov     d1, #16.00000000
0x00032a0c  mov      v2.16b, v8.16b
0x00032a10  mov      v3.16b, v8.16b
0x00032a14  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00032a18  mov      x0, x20
0x00032a1c  bl       #0x55d78   ; CALL _objc_release
0x00032a20  mov      x0, x19
0x00032a24  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00032a28  mov      x29, x29
0x00032a2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032a30  mov      x20, x0
0x00032a34  mov      x8, #0x4049000000000000
0x00032a38  fmov     d0, x8
0x00032a3c  bl       #0x5ab20   ; CALL objc_msgSend$setCorner:
0x00032a40  mov      x0, x20
0x00032a44  bl       #0x55d78   ; CALL _objc_release
0x00032a48  mov      x0, x19
0x00032a4c  bl       #0x595e0   ; CALL objc_msgSend$parts
0x00032a50  mov      x29, x29
0x00032a54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032a58  mov      x20, x0
0x00032a5c  adrp     x2, #0x7b000
0x00032a60  add      x2, x2, #0x88   ; STR "ring"
0x00032a64  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00032a68  mov      x29, x29
0x00032a6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032a70  mov      x22, x0
0x00032a74  mov      x0, x20
0x00032a78  bl       #0x55d78   ; CALL _objc_release
0x00032a7c  adrp     x8, #0x8e000
0x00032a80  ldr      x0, [x8, #0xac0]   ; @CLASS UIBezierPath
0x00032a84  adrp     x8, #0x65000
0x00032a88  ldr      d2, [x8, #0xcd8]
0x00032a8c  fmov     d0, #1.50000000
0x00032a90  fmov     d1, #1.50000000
0x00032a94  mov      v3.16b, v2.16b
0x00032a98  bl       #0x56820   ; CALL objc_msgSend$bezierPathWithOvalInRect:
0x00032a9c  mov      x29, x29
0x00032aa0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032aa4  mov      x20, x0
0x00032aa8  fmov     d0, xzr
0x00032aac  fmov     d1, xzr
0x00032ab0  mov      x0, x22
0x00032ab4  mov      v2.16b, v8.16b
0x00032ab8  mov      v3.16b, v8.16b
0x00032abc  mov      x1, x20
0x00032ac0  bl       #0x3467c
0x00032ac4  mov      x0, x20
0x00032ac8  bl       #0x55d78   ; CALL _objc_release
0x00032acc  cbz      w27, #0x33920
0x00032ad0  mov      x0, x28
0x00032ad4  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00032ad8  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00032adc  str      x0, [sp, #0x1c8]
0x00032ae0  mov      x0, x28
0x00032ae4  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00032ae8  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00032aec  str      x0, [sp, #0x1d0]
0x00032af0  adrp     x8, #0x8e000
0x00032af4  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00032af8  add      x2, sp, #0x1c8
0x00032afc  mov      w3, #2
0x00032b00  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00032b04  mov      x29, x29
0x00032b08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032b0c  b        #0x3392c
0x00032b10  adrp     x8, #0x65000
0x00032b14  ldr      d8, [x8, #0x708]
0x00032b18  fmov     d0, #1.00000000
0x00032b1c  fmov     d1, #1.00000000
0x00032b20  fmov     d2, #1.00000000
0x00032b24  mov      v3.16b, v8.16b
0x00032b28  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00032b2c  mov      x29, x29
0x00032b30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032b34  mov      x22, x0
0x00032b38  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00032b3c  adrp     x8, #0x65000
0x00032b40  ldr      d0, [x8, #0xa60]
0x00032b44  adrp     x8, #0x65000
0x00032b48  ldr      d1, [x8, #0xa68]
0x00032b4c  adrp     x8, #0x65000
0x00032b50  ldr      d2, [x8, #0xa70]
0x00032b54  mov      v3.16b, v8.16b
0x00032b58  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00032b5c  mov      x29, x29
0x00032b60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032b64  mov      x23, x0
0x00032b68  mov      x0, x20
0x00032b6c  mov      x2, x22
0x00032b70  mov      x3, x23
0x00032b74  bl       #0x5c680   ; CALL objc_msgSend$setTop:bottom:
0x00032b78  mov      x0, x23
0x00032b7c  bl       #0x55d78   ; CALL _objc_release
0x00032b80  mov      x0, x22
0x00032b84  bl       #0x55d78   ; CALL _objc_release
0x00032b88  mov      x0, x20
0x00032b8c  bl       #0x55d78   ; CALL _objc_release
0x00032b90  mov      x0, x19
0x00032b94  bl       #0x595e0   ; CALL objc_msgSend$parts
0x00032b98  mov      x29, x29
0x00032b9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032ba0  mov      x20, x0
0x00032ba4  adrp     x2, #0x7b000
0x00032ba8  add      x2, x2, #0x108   ; STR "nearRing"
0x00032bac  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00032bb0  mov      x29, x29
0x00032bb4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032bb8  mov      x22, x0
0x00032bbc  mov      x0, x20
0x00032bc0  bl       #0x55d78   ; CALL _objc_release
0x00032bc4  cmp      w27, #1
0x00032bc8  cset     w2, ne
0x00032bcc  mov      x0, x22
0x00032bd0  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x00032bd4  mov      x8, #0x4053000000000000
0x00032bd8  fmov     d2, x8
0x00032bdc  fmov     d0, xzr
0x00032be0  fmov     d1, xzr
0x00032be4  mov      x0, x22
0x00032be8  mov      v3.16b, v2.16b
0x00032bec  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00032bf0  adrp     x8, #0x8e000
0x00032bf4  ldr      x0, [x8, #0xac0]   ; @CLASS UIBezierPath
0x00032bf8  adrp     x8, #0x65000
0x00032bfc  ldr      d2, [x8, #0xcd0]
0x00032c00  fmov     d0, #1.50000000
0x00032c04  fmov     d1, #1.50000000
0x00032c08  mov      v3.16b, v2.16b
0x00032c0c  bl       #0x56820   ; CALL objc_msgSend$bezierPathWithOvalInRect:
0x00032c10  mov      x29, x29
0x00032c14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032c18  mov      x20, x0
0x00032c1c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00032c20  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x00032c24  mov      x2, x0
0x00032c28  mov      x0, x22
0x00032c2c  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x00032c30  mov      x0, x20
0x00032c34  bl       #0x55d78   ; CALL _objc_release
0x00032c38  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00032c3c  cmp      w27, #2
0x00032c40  b.ne     #0x32c54
0x00032c44  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x00032c48  mov      x29, x29
0x00032c4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032c50  b        #0x32c80
0x00032c54  adrp     x8, #0x65000
0x00032c58  ldr      d0, [x8, #0x820]
0x00032c5c  adrp     x8, #0x65000
0x00032c60  ldr      d1, [x8, #0xad0]
0x00032c64  adrp     x8, #0x65000
0x00032c68  ldr      d2, [x8, #0x928]
0x00032c6c  adrp     x8, #0x65000
0x00032c70  ldr      d3, [x8, #0x838]
0x00032c74  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00032c78  mov      x29, x29
0x00032c7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032c80  mov      x20, x0
0x00032c84  mov      x0, x19
0x00032c88  bl       #0x5dc80   ; CALL objc_msgSend$unitLabel
0x00032c8c  mov      x29, x29
0x00032c90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032c94  mov      x23, x0
0x00032c98  mov      x2, x20
0x00032c9c  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00032ca0  mov      x0, x23
0x00032ca4  bl       #0x55d78   ; CALL _objc_release
0x00032ca8  mov      x0, x20
0x00032cac  bl       #0x55d78   ; CALL _objc_release
0x00032cb0  mov      x0, x19
0x00032cb4  bl       #0x5d2a0   ; CALL objc_msgSend$stackHeight
0x00032cb8  fmov     d1, #-0.50000000
0x00032cbc  fmul     d0, d0, d1
0x00032cc0  mov      x8, #0x4045000000000000
0x00032cc4  fmov     d8, x8
0x00032cc8  fadd     d1, d0, d8
0x00032ccc  mov      x8, #0x4050000000000000
0x00032cd0  fmov     d2, x8
0x00032cd4  mov      x0, x19
0x00032cd8  mov      v0.16b, v8.16b
0x00032cdc  bl       #0x5d2c0   ; CALL objc_msgSend$stackNumberAt:top:width:
0x00032ce0  mov      x0, x19
0x00032ce4  bl       #0x58040   ; CALL objc_msgSend$iconView
0x00032ce8  mov      x29, x29
0x00032cec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032cf0  mov      x20, x0
0x00032cf4  fmov     d0, #10.00000000
0x00032cf8  fmov     d1, #10.00000000
0x00032cfc  fmov     d2, #20.00000000
0x00032d00  bl       #0x3460c
0x00032d04  mov      x0, x20
0x00032d08  bl       #0x55d78   ; CALL _objc_release
0x00032d0c  mov      x0, x19
0x00032d10  bl       #0x5cb80   ; CALL objc_msgSend$sign
0x00032d14  mov      x29, x29
0x00032d18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032d1c  mov      x20, x0
0x00032d20  mov      x8, #0x405f000000000000
0x00032d24  fmov     d0, x8
0x00032d28  mov      x8, #0x4052000000000000
0x00032d2c  fmov     d2, x8
0x00032d30  mov      v1.16b, v8.16b
0x00032d34  bl       #0x3460c
0x00032d38  mov      x0, x20
0x00032d3c  bl       #0x55d78   ; CALL _objc_release
0x00032d40  mov      x0, x19
0x00032d44  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00032d48  mov      x29, x29
0x00032d4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032d50  mov      x20, x0
0x00032d54  mov      x0, x22
0x00032d58  bl       #0x55d78   ; CALL _objc_release
0x00032d5c  mov      x8, #0x4054000000000000
0x00032d60  fmov     d8, x8
0x00032d64  mov      x8, #0x4064000000000000
0x00032d68  b        #0x33a68
0x00032d6c  adrp     x8, #0x8e000
0x00032d70  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00032d74  adrp     x8, #0x65000
0x00032d78  ldr      d0, [x8, #0x7c8]
0x00032d7c  adrp     x8, #0x65000
0x00032d80  ldr      d1, [x8, #0x7d0]
0x00032d84  adrp     x8, #0x65000
0x00032d88  ldr      d2, [x8, #0x7d8]
0x00032d8c  fmov     d3, #1.00000000
0x00032d90  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00032d94  mov      x29, x29
0x00032d98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032d9c  mov      x23, x0
0x00032da0  mov      x0, x20
0x00032da4  mov      x2, x23
0x00032da8  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x00032dac  mov      x0, x23
0x00032db0  bl       #0x55d78   ; CALL _objc_release
0x00032db4  cbnz     w22, #0x3223c
0x00032db8  fmov     d0, #10.00000000
0x00032dbc  fmov     d1, #26.00000000
0x00032dc0  fmov     d2, #8.00000000
0x00032dc4  fmov     d3, #8.00000000
0x00032dc8  mov      x0, x20
0x00032dcc  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00032dd0  fmov     d10, #24.00000000
0x00032dd4  mov      x0, x19
0x00032dd8  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x00032ddc  mov      x29, x29
0x00032de0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032de4  mov      x22, x0
0x00032de8  mov      x8, #0x4069000000000000
0x00032dec  fmov     d0, x8
0x00032df0  mov      x8, #0x4044000000000000
0x00032df4  fmov     d1, x8
0x00032df8  bl       #0x5cbc0   ; CALL objc_msgSend$sizeThatFits:
0x00032dfc  frintp   d8, d0
0x00032e00  mov      x0, x22
0x00032e04  bl       #0x55d78   ; CALL _objc_release
0x00032e08  mov      x8, #0x404a000000000000
0x00032e0c  fmov     d0, x8
0x00032e10  fmaxnm   d8, d8, d0
0x00032e14  fmov     d11, #0.50000000
0x00032e18  fmul     d0, d8, d11
0x00032e1c  fadd     d9, d10, d0
0x00032e20  mov      x0, x19
0x00032e24  bl       #0x5d2a0   ; CALL objc_msgSend$stackHeight
0x00032e28  fmul     d0, d0, d11
0x00032e2c  fmov     d1, #30.00000000
0x00032e30  fsub     d1, d1, d0
0x00032e34  mov      x0, x19
0x00032e38  mov      v0.16b, v9.16b
0x00032e3c  mov      v2.16b, v8.16b
0x00032e40  bl       #0x5d2c0   ; CALL objc_msgSend$stackNumberAt:top:width:
0x00032e44  fmov     d0, #10.00000000
0x00032e48  fadd     d0, d8, d0
0x00032e4c  fadd     d8, d10, d0
0x00032e50  adrp     x2, #0x7b000
0x00032e54  add      x2, x2, #0xe8   ; STR "bar"
0x00032e58  mov      x0, x19
0x00032e5c  bl       #0x56900   ; CALL objc_msgSend$bit:
0x00032e60  mov      x29, x29
0x00032e64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032e68  mov      x22, x0
0x00032e6c  mov      x8, #0x4040000000000000
0x00032e70  fmov     d3, x8
0x00032e74  fmov     d1, #14.00000000
0x00032e78  fmov     d2, #1.50000000
0x00032e7c  mov      v0.16b, v8.16b
0x00032e80  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00032e84  mov      x0, x22
0x00032e88  bl       #0x55d78   ; CALL _objc_release
0x00032e8c  fmov     d0, #11.50000000
0x00032e90  fadd     d9, d8, d0
0x00032e94  mov      x0, x19
0x00032e98  bl       #0x5cb80   ; CALL objc_msgSend$sign
0x00032e9c  mov      x29, x29
0x00032ea0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032ea4  mov      x22, x0
0x00032ea8  fmov     d0, #22.00000000
0x00032eac  fadd     d0, d9, d0
0x00032eb0  mov      x8, #0x4046000000000000
0x00032eb4  fmov     d8, x8
0x00032eb8  fmov     d1, #30.00000000
0x00032ebc  mov      v2.16b, v8.16b
0x00032ec0  bl       #0x3460c
0x00032ec4  mov      x0, x22
0x00032ec8  bl       #0x55d78   ; CALL _objc_release
0x00032ecc  fadd     d0, d9, d8
0x00032ed0  fmov     d1, #8.00000000
0x00032ed4  fadd     d9, d0, d1
0x00032ed8  mov      x0, x19
0x00032edc  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00032ee0  mov      x29, x29
0x00032ee4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032ee8  mov      x22, x0
0x00032eec  mov      x8, #0x404e000000000000
0x00032ef0  fmov     d8, x8
0x00032ef4  fmov     d0, xzr
0x00032ef8  fmov     d1, xzr
0x00032efc  mov      v2.16b, v9.16b
0x00032f00  mov      v3.16b, v8.16b
0x00032f04  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00032f08  mov      x0, x22
0x00032f0c  bl       #0x55d78   ; CALL _objc_release
0x00032f10  mov      x0, x19
0x00032f14  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00032f18  mov      x29, x29
0x00032f1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032f20  mov      x22, x0
0x00032f24  fmov     d0, #30.00000000
0x00032f28  bl       #0x5ab20   ; CALL objc_msgSend$setCorner:
0x00032f2c  mov      x0, x22
0x00032f30  bl       #0x55d78   ; CALL _objc_release
0x00032f34  mov      x0, x20
0x00032f38  b        #0x34180
0x00032f3c  bl       #0x304f4
0x00032f40  mov      x29, x29
0x00032f44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032f48  mov      x20, x0
0x00032f4c  mov      x0, x24
0x00032f50  mov      x2, x20
0x00032f54  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x00032f58  mov      x0, x20
0x00032f5c  bl       #0x55d78   ; CALL _objc_release
0x00032f60  ldr      x0, [x26, #0xab8]   ; @CLASS CATransaction
0x00032f64  mov      w2, #0
0x00032f68  bl       #0x5ad00   ; CALL objc_msgSend$setDisableActions:
0x00032f6c  mov      x8, #0x4057000000000000
0x00032f70  fmov     d0, x8
0x00032f74  fmul     d0, d8, d0
0x00032f78  adrp     x8, #0x65000
0x00032f7c  ldr      d1, [x8, #0x6e8]
0x00032f80  mov      x0, x23
0x00032f84  bl       #0x348d8
0x00032f88  ldr      x0, [x26, #0xab8]   ; @CLASS CATransaction
0x00032f8c  mov      w2, #1
0x00032f90  bl       #0x5ad00   ; CALL objc_msgSend$setDisableActions:
0x00032f94  mov      x0, x19
0x00032f98  bl       #0x5cb80   ; CALL objc_msgSend$sign
0x00032f9c  mov      x29, x29
0x00032fa0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032fa4  mov      x20, x0
0x00032fa8  fmov     d0, #8.00000000
0x00032fac  fadd     d10, d11, d0
0x00032fb0  fmov     d0, #20.00000000
0x00032fb4  fadd     d0, d10, d0
0x00032fb8  fmov     d1, #5.00000000
0x00032fbc  fadd     d8, d9, d1
0x00032fc0  fmov     d1, #-8.00000000
0x00032fc4  fadd     d1, d8, d1
0x00032fc8  fmov     d2, #-20.00000000
0x00032fcc  fadd     d1, d1, d2
0x00032fd0  mov      x8, #0x4044000000000000
0x00032fd4  fmov     d9, x8
0x00032fd8  mov      v2.16b, v9.16b
0x00032fdc  bl       #0x3460c
0x00032fe0  mov      x0, x20
0x00032fe4  bl       #0x55d78   ; CALL _objc_release
0x00032fe8  fadd     d9, d10, d9
0x00032fec  mov      x0, x19
0x00032ff0  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x00032ff4  mov      x29, x29
0x00032ff8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00032ffc  mov      x20, x0
0x00033000  mov      x0, x24
0x00033004  bl       #0x55d78   ; CALL _objc_release
0x00033008  mov      x0, x23
0x0003300c  bl       #0x55d78   ; CALL _objc_release
0x00033010  mov      x0, x22
0x00033014  bl       #0x55d78   ; CALL _objc_release
0x00033018  b        #0x34320
0x0003301c  bl       #0x304f4
0x00033020  mov      x29, x29
0x00033024  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033028  mov      x20, x0
0x0003302c  mov      x0, x24
0x00033030  mov      x2, x20
0x00033034  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x00033038  mov      x0, x20
0x0003303c  bl       #0x55d78   ; CALL _objc_release
0x00033040  ldr      x0, [x26, #0xab8]   ; @CLASS CATransaction
0x00033044  mov      w2, #0
0x00033048  bl       #0x5ad00   ; CALL objc_msgSend$setDisableActions:
0x0003304c  ldr      x0, [x26, #0xab8]   ; @CLASS CATransaction
0x00033050  adrp     x8, #0x65000
0x00033054  ldr      d0, [x8, #0x6e8]
0x00033058  bl       #0x5a460   ; CALL objc_msgSend$setAnimationDuration:
0x0003305c  mov      x0, x24
0x00033060  bl       #0x58f60   ; CALL objc_msgSend$mask
0x00033064  mov      x29, x29
0x00033068  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003306c  mov      x20, x0
0x00033070  mov      v0.16b, v8.16b
0x00033074  bl       #0x5c3a0   ; CALL objc_msgSend$setStrokeEnd:
0x00033078  mov      x0, x20
0x0003307c  bl       #0x55d78   ; CALL _objc_release
0x00033080  ldr      x0, [x26, #0xab8]   ; @CLASS CATransaction
0x00033084  mov      w2, #1
0x00033088  bl       #0x5ad00   ; CALL objc_msgSend$setDisableActions:
0x0003308c  mov      x0, x19
0x00033090  bl       #0x5d2a0   ; CALL objc_msgSend$stackHeight
0x00033094  fmov     d1, #-0.50000000
0x00033098  fmul     d0, d0, d1
0x0003309c  mov      x8, #0x4047000000000000
0x000330a0  fmov     d8, x8
0x000330a4  fadd     d1, d0, d8
0x000330a8  mov      x8, #0x404a000000000000
0x000330ac  fmov     d9, x8
0x000330b0  mov      x8, #0x4054000000000000
0x000330b4  fmov     d2, x8
0x000330b8  mov      x0, x19
0x000330bc  mov      v0.16b, v9.16b
0x000330c0  bl       #0x5d2c0   ; CALL objc_msgSend$stackNumberAt:top:width:
0x000330c4  mov      x0, x19
0x000330c8  bl       #0x58040   ; CALL objc_msgSend$iconView
0x000330cc  mov      x29, x29
0x000330d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000330d4  mov      x20, x0
0x000330d8  fmov     d0, #10.00000000
0x000330dc  fmov     d1, #12.00000000
0x000330e0  fmov     d2, #20.00000000
0x000330e4  bl       #0x3460c
0x000330e8  mov      x0, x20
0x000330ec  bl       #0x55d78   ; CALL _objc_release
0x000330f0  mov      x0, x19
0x000330f4  bl       #0x5cb80   ; CALL objc_msgSend$sign
0x000330f8  mov      x29, x29
0x000330fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033100  mov      x20, x0
0x00033104  adrp     x8, #0x65000
0x00033108  ldr      d1, [x8, #0xcc0]
0x0003310c  mov      v0.16b, v9.16b
0x00033110  mov      v2.16b, v8.16b
0x00033114  bl       #0x3460c
0x00033118  mov      x0, x20
0x0003311c  bl       #0x55d78   ; CALL _objc_release
0x00033120  mov      x0, x19
0x00033124  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00033128  mov      x29, x29
0x0003312c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033130  mov      x20, x0
0x00033134  mov      x0, x24
0x00033138  bl       #0x55d78   ; CALL _objc_release
0x0003313c  mov      x0, x23
0x00033140  bl       #0x55d78   ; CALL _objc_release
0x00033144  mov      x0, x22
0x00033148  bl       #0x55d78   ; CALL _objc_release
0x0003314c  adrp     x8, #0x65000
0x00033150  ldr      d8, [x8, #0xcc8]
0x00033154  mov      x8, #0x405a000000000000
0x00033158  b        #0x33a68
0x0003315c  bl       #0x3499c
0x00033160  mov      x29, x29
0x00033164  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033168  mov      x20, x0
0x0003316c  mov      x0, x21
0x00033170  mov      x2, x20
0x00033174  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x00033178  mov      x0, x20
0x0003317c  bl       #0x55d78   ; CALL _objc_release
0x00033180  mov      x0, x19
0x00033184  bl       #0x595e0   ; CALL objc_msgSend$parts
0x00033188  mov      x29, x29
0x0003318c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033190  mov      x24, x0
0x00033194  adrp     x2, #0x7b000
0x00033198  add      x2, x2, #0x1a8   ; STR "glow"
0x0003319c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000331a0  mov      x29, x29
0x000331a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000331a8  mov      x20, x0
0x000331ac  mov      x0, x24
0x000331b0  bl       #0x55d78   ; CALL _objc_release
0x000331b4  fmov     d0, xzr
0x000331b8  fmov     d1, xzr
0x000331bc  mov      x0, x20
0x000331c0  mov      v2.16b, v9.16b
0x000331c4  mov      v3.16b, v8.16b
0x000331c8  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x000331cc  mov      x0, x22
0x000331d0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000331d4  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x000331d8  mov      x2, x0
0x000331dc  mov      x0, x20
0x000331e0  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x000331e4  mov      x24, x28
0x000331e8  cbnz     w27, #0x33220
0x000331ec  adrp     x8, #0x8e000
0x000331f0  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x000331f4  adrp     x8, #0x65000
0x000331f8  ldr      d0, [x8, #0x7a0]
0x000331fc  adrp     x8, #0x65000
0x00033200  ldr      d1, [x8, #0x7a8]
0x00033204  adrp     x8, #0x65000
0x00033208  ldr      d2, [x8, #0x7b0]
0x0003320c  fmov     d3, #1.00000000
0x00033210  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00033214  mov      x29, x29
0x00033218  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003321c  mov      x24, x0
0x00033220  mov      x0, x24
0x00033224  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00033228  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0003322c  mov      x2, x0
0x00033230  mov      x0, x20
0x00033234  bl       #0x5c380   ; CALL objc_msgSend$setStrokeColor:
0x00033238  cbnz     w27, #0x33244
0x0003323c  mov      x0, x24
0x00033240  bl       #0x55d78   ; CALL _objc_release
0x00033244  mov      x0, x20
0x00033248  bl       #0x5d600   ; CALL objc_msgSend$strokeColor
0x0003324c  mov      x2, x0
0x00033250  mov      x0, x20
0x00033254  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x00033258  cmp      w27, #2
0x0003325c  str      x28, [sp, #0x48]
0x00033260  str      x21, [sp, #0x68]
0x00033264  b.ne     #0x332a8
0x00033268  mov      x23, x27
0x0003326c  adrp     x8, #0x8e000
0x00033270  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00033274  adrp     x8, #0x65000
0x00033278  ldr      d1, [x8, #0xac0]
0x0003327c  adrp     x8, #0x65000
0x00033280  ldr      d2, [x8, #0xac8]
0x00033284  fmov     d0, #1.00000000
0x00033288  fmov     d3, #1.00000000
0x0003328c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00033290  mov      x29, x29
0x00033294  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033298  mov      x24, x0
0x0003329c  mov      w28, #0
0x000332a0  mov      w21, #0
0x000332a4  b        #0x340ec
0x000332a8  adrp     x8, #0x8e000
0x000332ac  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x000332b0  mov      x23, x27
0x000332b4  cmp      w27, #1
0x000332b8  b.ne     #0x340b8
0x000332bc  adrp     x8, #0x65000
0x000332c0  ldr      d1, [x8, #0xab0]
0x000332c4  adrp     x8, #0x65000
0x000332c8  ldr      d2, [x8, #0xab8]
0x000332cc  fmov     d0, #1.00000000
0x000332d0  fmov     d3, #1.00000000
0x000332d4  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000332d8  mov      x29, x29
0x000332dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000332e0  mov      x24, x0
0x000332e4  mov      w28, #0
0x000332e8  mov      w21, #1
0x000332ec  b        #0x340ec
0x000332f0  fmov     d11, xzr
0x000332f4  ldr      x22, [sp, #0x48]
0x000332f8  mov      x0, x19
0x000332fc  bl       #0x5ce00   ; CALL objc_msgSend$speed
0x00033300  bic      w21, w0, w0, asr #31
0x00033304  mov      x0, x19
0x00033308  bl       #0x595e0   ; CALL objc_msgSend$parts
0x0003330c  mov      x29, x29
0x00033310  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033314  mov      x20, x0
0x00033318  adrp     x2, #0x7b000
0x0003331c  add      x2, x2, #0x248   ; STR "zone"
0x00033320  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00033324  mov      x29, x29
0x00033328  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003332c  mov      x28, x0
0x00033330  mov      x0, x20
0x00033334  bl       #0x55d78   ; CALL _objc_release
0x00033338  mov      x0, x19
0x0003333c  bl       #0x595e0   ; CALL objc_msgSend$parts
0x00033340  mov      x29, x29
0x00033344  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033348  mov      x20, x0
0x0003334c  adrp     x2, #0x7b000
0x00033350  add      x2, x2, #0x268   ; STR "limTick"
0x00033354  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00033358  mov      x29, x29
0x0003335c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033360  mov      x25, x0
0x00033364  mov      x0, x20
0x00033368  bl       #0x55d78   ; CALL _objc_release
0x0003336c  mov      x8, #0x4064000000000000
0x00033370  fmov     d0, x8
0x00033374  fcmp     d11, d0
0x00033378  ldr      w8, [sp, #0x38]
0x0003337c  ccmp     w8, #1, #8, mi
0x00033380  cset     w20, lt
0x00033384  str      x25, [sp, #0x38]
0x00033388  mov      x0, x25
0x0003338c  mov      x2, x20
0x00033390  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x00033394  mov      x0, x28
0x00033398  mov      x2, x20
0x0003339c  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x000333a0  mov      x0, x28
0x000333a4  bl       #0x58860   ; CALL objc_msgSend$isHidden
0x000333a8  tbnz     w0, #0, #0x334d0
0x000333ac  ldr      x25, [sp, #0x68]
0x000333b0  ldr      x8, [x25, #0x10]   ; @SEL "whitespaceAndNewlineCharacterSet"
0x000333b4  mov      x0, x25
0x000333b8  mov      v0.16b, v11.16b
0x000333bc  blr      x8
0x000333c0  mov      v12.16b, v0.16b
0x000333c4  ldr      x8, [x25, #0x10]   ; @SEL "whitespaceAndNewlineCharacterSet"
0x000333c8  mov      x9, #0x4064000000000000
0x000333cc  fmov     d0, x9
0x000333d0  mov      x0, x25
0x000333d4  blr      x8
0x000333d8  ldr      x0, [x27, #0xac0]   ; @CLASS UIBezierPath
0x000333dc  adrp     x8, #0x65000
0x000333e0  ldr      d1, [x8, #0x930]
0x000333e4  fmul     d2, d12, d1
0x000333e8  adrp     x8, #0x65000
0x000333ec  ldr      d4, [x8, #0x828]
0x000333f0  fdiv     d3, d2, d4
0x000333f4  fmul     d0, d0, d1
0x000333f8  fdiv     d4, d0, d4
0x000333fc  adrp     x8, #0x65000
0x00033400  ldr      d2, [x8, #0xbc8]
0x00033404  mov      v0.16b, v8.16b
0x00033408  mov      v1.16b, v8.16b
0x0003340c  mov      w2, #1
0x00033410  bl       #0x56800   ; CALL objc_msgSend$bezierPathWithArcCenter:radius:startAngle:endAngle:clockwise:
0x00033414  mov      x29, x29
0x00033418  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003341c  mov      x20, x0
0x00033420  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00033424  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x00033428  mov      x2, x0
0x0003342c  mov      x0, x28
0x00033430  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x00033434  mov      x0, x20
0x00033438  bl       #0x55d78   ; CALL _objc_release
0x0003343c  ldr      x0, [x27, #0xac0]   ; @CLASS UIBezierPath
0x00033440  bl       #0x567e0   ; CALL objc_msgSend$bezierPath
0x00033444  mov      x29, x29
0x00033448  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003344c  mov      x20, x0
0x00033450  ldr      x8, [x25, #0x10]   ; @SEL "whitespaceAndNewlineCharacterSet"
0x00033454  mov      x0, x25
0x00033458  mov      v0.16b, v11.16b
0x0003345c  blr      x8
0x00033460  mov      v1.16b, v0.16b
0x00033464  ldr      x8, [x23, #0x10]
0x00033468  mov      x9, #0x404a000000000000
0x0003346c  fmov     d0, x9
0x00033470  mov      x0, x23
0x00033474  blr      x8
0x00033478  mov      x0, x20
0x0003347c  bl       #0x59060   ; CALL objc_msgSend$moveToPoint:
0x00033480  ldr      x8, [x25, #0x10]   ; @SEL "whitespaceAndNewlineCharacterSet"
0x00033484  mov      x0, x25
0x00033488  mov      v0.16b, v11.16b
0x0003348c  blr      x8
0x00033490  mov      v1.16b, v0.16b
0x00033494  ldr      x8, [x23, #0x10]
0x00033498  adrp     x9, #0x65000
0x0003349c  ldr      d0, [x9, #0xbd0]
0x000334a0  mov      x0, x23
0x000334a4  blr      x8
0x000334a8  mov      x0, x20
0x000334ac  bl       #0x56100   ; CALL objc_msgSend$addLineToPoint:
0x000334b0  mov      x0, x20
0x000334b4  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000334b8  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x000334bc  mov      x2, x0
0x000334c0  ldr      x0, [sp, #0x38]
0x000334c4  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x000334c8  mov      x0, x20
0x000334cc  bl       #0x55d78   ; CALL _objc_release
0x000334d0  ucvtf    d11, w21
0x000334d4  mov      x0, x19
0x000334d8  bl       #0x595e0   ; CALL objc_msgSend$parts
0x000334dc  mov      x29, x29
0x000334e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000334e4  mov      x20, x0
0x000334e8  adrp     x2, #0x7b000
0x000334ec  add      x2, x2, #0x2c8   ; STR "prog"
0x000334f0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000334f4  mov      x29, x29
0x000334f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000334fc  mov      x25, x0
0x00033500  mov      x0, x20
0x00033504  bl       #0x55d78   ; CALL _objc_release
0x00033508  ldr      x0, [x27, #0xac0]   ; @CLASS UIBezierPath
0x0003350c  adrp     x8, #0x65000
0x00033510  ldr      d2, [x8, #0xbd8]
0x00033514  adrp     x8, #0x65000
0x00033518  ldr      d3, [x8, #0xbe0]
0x0003351c  adrp     x8, #0x65000
0x00033520  ldr      d4, [x8, #0xbe8]
0x00033524  mov      v0.16b, v8.16b
0x00033528  mov      v1.16b, v8.16b
0x0003352c  mov      w2, #1
0x00033530  bl       #0x56800   ; CALL objc_msgSend$bezierPathWithArcCenter:radius:startAngle:endAngle:clockwise:
0x00033534  mov      x29, x29
0x00033538  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003353c  mov      x20, x0
0x00033540  fmov     d0, xzr
0x00033544  fmov     d1, xzr
0x00033548  mov      x0, x25
0x0003354c  mov      v2.16b, v9.16b
0x00033550  mov      v3.16b, v9.16b
0x00033554  mov      x1, x20
0x00033558  bl       #0x3467c
0x0003355c  mov      x0, x20
0x00033560  bl       #0x55d78   ; CALL _objc_release
0x00033564  str      x28, [sp, #0x10]
0x00033568  cbz      w24, #0x335ac
0x0003356c  mov      x0, x22
0x00033570  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00033574  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00033578  str      x0, [sp, #0x1d8]
0x0003357c  mov      x0, x22
0x00033580  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00033584  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00033588  str      x0, [sp, #0x1e0]
0x0003358c  adrp     x8, #0x8e000
0x00033590  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00033594  add      x2, sp, #0x1d8
0x00033598  mov      w3, #2
0x0003359c  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000335a0  mov      x29, x29
0x000335a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000335a8  b        #0x335b8
0x000335ac  bl       #0x304f4
0x000335b0  mov      x29, x29
0x000335b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000335b8  mov      x20, x0
0x000335bc  mov      x0, x25
0x000335c0  mov      x2, x20
0x000335c4  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x000335c8  mov      x0, x20
0x000335cc  bl       #0x55d78   ; CALL _objc_release
0x000335d0  mov      x0, x19
0x000335d4  bl       #0x595e0   ; CALL objc_msgSend$parts
0x000335d8  mov      x29, x29
0x000335dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000335e0  mov      x20, x0
0x000335e4  adrp     x2, #0x7b000
0x000335e8  add      x2, x2, #0x2e8   ; STR "needle"
0x000335ec  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000335f0  mov      x29, x29
0x000335f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000335f8  mov      x22, x0
0x000335fc  mov      x0, x20
0x00033600  bl       #0x55d78   ; CALL _objc_release
0x00033604  fmov     d0, xzr
0x00033608  fmov     d1, xzr
0x0003360c  mov      x0, x22
0x00033610  mov      v2.16b, v9.16b
0x00033614  mov      v3.16b, v9.16b
0x00033618  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x0003361c  mov      x0, x22
0x00033620  mov      v0.16b, v8.16b
0x00033624  mov      v1.16b, v8.16b
0x00033628  bl       #0x5bc00   ; CALL objc_msgSend$setPosition:
0x0003362c  ldr      x0, [x27, #0xac0]   ; @CLASS UIBezierPath
0x00033630  bl       #0x567e0   ; CALL objc_msgSend$bezierPath
0x00033634  mov      x29, x29
0x00033638  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003363c  mov      x28, x0
0x00033640  mov      x8, #0x404d000000000000
0x00033644  fmov     d10, x8
0x00033648  adrp     x8, #0x65000
0x0003364c  ldr      d1, [x8, #0xbf0]
0x00033650  mov      v0.16b, v10.16b
0x00033654  bl       #0x59060   ; CALL objc_msgSend$moveToPoint:
0x00033658  adrp     x8, #0x65000
0x0003365c  ldr      d0, [x8, #0xbf8]
0x00033660  mov      x0, x28
0x00033664  mov      v1.16b, v8.16b
0x00033668  bl       #0x56100   ; CALL objc_msgSend$addLineToPoint:
0x0003366c  adrp     x8, #0x65000
0x00033670  ldr      d1, [x8, #0xc00]
0x00033674  mov      x0, x28
0x00033678  mov      v0.16b, v10.16b
0x0003367c  bl       #0x56100   ; CALL objc_msgSend$addLineToPoint:
0x00033680  mov      x0, x28
0x00033684  bl       #0x56e20   ; CALL objc_msgSend$closePath
0x00033688  mov      x0, x28
0x0003368c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00033690  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x00033694  mov      x2, x0
0x00033698  mov      x0, x22
0x0003369c  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x000336a0  ldr      x0, [x27, #0xac0]   ; @CLASS UIBezierPath
0x000336a4  fmov     d2, #7.00000000
0x000336a8  fmov     d3, xzr
0x000336ac  mov      v0.16b, v8.16b
0x000336b0  mov      v1.16b, v8.16b
0x000336b4  ldr      d4, [sp, #0x20]
0x000336b8  mov      w2, #1
0x000336bc  bl       #0x56800   ; CALL objc_msgSend$bezierPathWithArcCenter:radius:startAngle:endAngle:clockwise:
0x000336c0  mov      x29, x29
0x000336c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000336c8  mov      x20, x0
0x000336cc  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000336d0  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x000336d4  mov      x21, x0
0x000336d8  mov      x0, x19
0x000336dc  bl       #0x595e0   ; CALL objc_msgSend$parts
0x000336e0  mov      x29, x29
0x000336e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000336e8  mov      x27, x0
0x000336ec  adrp     x2, #0x7b000
0x000336f0  add      x2, x2, #0x308   ; STR "hub"
0x000336f4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000336f8  mov      x29, x29
0x000336fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033700  mov      x24, x0
0x00033704  mov      x2, x21
0x00033708  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x0003370c  mov      x0, x24
0x00033710  bl       #0x55d78   ; CALL _objc_release
0x00033714  mov      x0, x27
0x00033718  ldr      x19, [sp, #0x50]
0x0003371c  bl       #0x55d78   ; CALL _objc_release
0x00033720  mov      x0, x20
0x00033724  bl       #0x55d78   ; CALL _objc_release
0x00033728  ldr      x0, [x26, #0xab8]   ; @CLASS CATransaction
0x0003372c  mov      w2, #0
0x00033730  bl       #0x5ad00   ; CALL objc_msgSend$setDisableActions:
0x00033734  ldr      x0, [x26, #0xab8]   ; @CLASS CATransaction
0x00033738  adrp     x8, #0x65000
0x0003373c  ldr      d8, [x8, #0x6e8]
0x00033740  mov      v0.16b, v8.16b
0x00033744  bl       #0x5a460   ; CALL objc_msgSend$setAnimationDuration:
0x00033748  ldr      x21, [sp, #0x68]
0x0003374c  ldr      x8, [x21, #0x10]   ; @SEL "whitespaceAndNewlineCharacterSet"
0x00033750  mov      x0, x21
0x00033754  mov      v0.16b, v11.16b
0x00033758  blr      x8
0x0003375c  adrp     x8, #0x65000
0x00033760  ldr      d1, [x8, #0xc08]
0x00033764  fadd     d0, d0, d1
0x00033768  mov      x8, #0x406e000000000000
0x0003376c  fmov     d1, x8
0x00033770  fdiv     d0, d0, d1
0x00033774  fmov     d1, #1.00000000
0x00033778  fcmp     d0, d1
0x0003377c  fcsel    d9, d1, d0, gt
0x00033780  mov      x0, x25
0x00033784  bl       #0x58f60   ; CALL objc_msgSend$mask
0x00033788  mov      x29, x29
0x0003378c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033790  mov      x20, x0
0x00033794  mov      v0.16b, v9.16b
0x00033798  bl       #0x5c3a0   ; CALL objc_msgSend$setStrokeEnd:
0x0003379c  mov      x0, x20
0x000337a0  bl       #0x55d78   ; CALL _objc_release
0x000337a4  ldr      x8, [x21, #0x10]   ; @SEL "whitespaceAndNewlineCharacterSet"
0x000337a8  mov      x0, x21
0x000337ac  mov      v0.16b, v11.16b
0x000337b0  blr      x8
0x000337b4  adrp     x8, #0x65000
0x000337b8  ldr      d1, [x8, #0x930]
0x000337bc  fmul     d0, d0, d1
0x000337c0  adrp     x8, #0x65000
0x000337c4  ldr      d1, [x8, #0x828]
0x000337c8  fdiv     d0, d0, d1
0x000337cc  add      x8, sp, #0xf8
0x000337d0  fmov     d1, xzr
0x000337d4  fmov     d2, xzr
0x000337d8  fmov     d3, #1.00000000
0x000337dc  bl       #0x55820   ; CALL _CATransform3DMakeRotation
0x000337e0  add      x8, sp, #0xf8
0x000337e4  ldp      q0, q1, [x8, #0x40]
0x000337e8  stp      q0, q1, [sp, #0xb0]
0x000337ec  ldp      q0, q1, [x8, #0x60]
0x000337f0  stp      q0, q1, [sp, #0xd0]
0x000337f4  ldp      q0, q1, [x8]
0x000337f8  stp      q0, q1, [sp, #0x70]
0x000337fc  ldp      q0, q1, [x8, #0x20]
0x00033800  stp      q0, q1, [sp, #0x90]
0x00033804  add      x2, sp, #0x70
0x00033808  str      x22, [sp, #0x28]
0x0003380c  mov      x0, x22
0x00033810  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x00033814  ldr      x0, [x26, #0xab8]   ; @CLASS CATransaction
0x00033818  mov      w2, #1
0x0003381c  bl       #0x5ad00   ; CALL objc_msgSend$setDisableActions:
0x00033820  mov      x0, x19
0x00033824  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x00033828  mov      x29, x29
0x0003382c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033830  mov      x20, x0
0x00033834  adrp     x8, #0x65000
0x00033838  ldr      d1, [x8, #0x9d8]
0x0003383c  mov      x8, #0x4054000000000000
0x00033840  fmov     d2, x8
0x00033844  fmov     d0, #30.00000000
0x00033848  fmov     d3, #28.00000000
0x0003384c  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00033850  mov      x0, x20
0x00033854  bl       #0x55d78   ; CALL _objc_release
0x00033858  mov      x0, x19
0x0003385c  bl       #0x5dc80   ; CALL objc_msgSend$unitLabel
0x00033860  mov      x29, x29
0x00033864  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033868  mov      x20, x0
0x0003386c  mov      x8, #0x4044000000000000
0x00033870  fmov     d0, x8
0x00033874  mov      x8, #0x405c000000000000
0x00033878  fmov     d1, x8
0x0003387c  mov      x8, #0x404e000000000000
0x00033880  fmov     d2, x8
0x00033884  fmov     d3, #11.00000000
0x00033888  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0003388c  mov      x0, x20
0x00033890  bl       #0x55d78   ; CALL _objc_release
0x00033894  ldr      w9, [sp, #0x44]
0x00033898  cmp      w9, #2
0x0003389c  str      x25, [sp, #8]
0x000338a0  adrp     x8, #0x8e000
0x000338a4  b.ne     #0x338e0
0x000338a8  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x000338ac  adrp     x8, #0x65000
0x000338b0  ldr      d1, [x8, #0xac0]
0x000338b4  adrp     x8, #0x65000
0x000338b8  ldr      d2, [x8, #0xac8]
0x000338bc  fmov     d0, #1.00000000
0x000338c0  fmov     d3, #1.00000000
0x000338c4  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000338c8  mov      x29, x29
0x000338cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000338d0  mov      x20, x0
0x000338d4  mov      w25, #0
0x000338d8  mov      w22, #0
0x000338dc  b        #0x341c4
0x000338e0  ldr      x0, [x8, #0x910]
0x000338e4  cmp      w9, #1
0x000338e8  b.ne     #0x34194
0x000338ec  adrp     x8, #0x65000
0x000338f0  ldr      d1, [x8, #0xab0]
0x000338f4  adrp     x8, #0x65000
0x000338f8  ldr      d2, [x8, #0xab8]
0x000338fc  fmov     d0, #1.00000000
0x00033900  fmov     d3, #1.00000000
0x00033904  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00033908  mov      x29, x29
0x0003390c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033910  mov      x20, x0
0x00033914  mov      w25, #0
0x00033918  mov      w22, #1
0x0003391c  b        #0x341c4
0x00033920  bl       #0x3499c
0x00033924  mov      x29, x29
0x00033928  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003392c  mov      x20, x0
0x00033930  mov      x0, x22
0x00033934  mov      x2, x20
0x00033938  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0003393c  mov      x0, x20
0x00033940  bl       #0x55d78   ; CALL _objc_release
0x00033944  mov      x0, x19
0x00033948  bl       #0x595e0   ; CALL objc_msgSend$parts
0x0003394c  mov      x29, x29
0x00033950  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033954  mov      x20, x0
0x00033958  adrp     x2, #0x7b000
0x0003395c  add      x2, x2, #0xa8   ; STR "shine"
0x00033960  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00033964  mov      x29, x29
0x00033968  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003396c  mov      x23, x0
0x00033970  mov      x0, x20
0x00033974  bl       #0x55d78   ; CALL _objc_release
0x00033978  mov      x8, #0x4047000000000000
0x0003397c  fmov     d2, x8
0x00033980  fmov     d0, #16.00000000
0x00033984  fmov     d1, #9.00000000
0x00033988  fmov     d3, #26.00000000
0x0003398c  mov      x0, x23
0x00033990  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00033994  fmov     d0, #13.00000000
0x00033998  mov      x0, x23
0x0003399c  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x000339a0  mov      x0, x19
0x000339a4  bl       #0x5d2a0   ; CALL objc_msgSend$stackHeight
0x000339a8  fmov     d1, #-0.50000000
0x000339ac  fmul     d0, d0, d1
0x000339b0  mov      x8, #0x4051000000000000
0x000339b4  fmov     d1, x8
0x000339b8  fadd     d1, d0, d1
0x000339bc  mov      x8, #0x404b000000000000
0x000339c0  fmov     d0, x8
0x000339c4  mov      x8, #0x4055000000000000
0x000339c8  fmov     d2, x8
0x000339cc  mov      x0, x19
0x000339d0  bl       #0x5d2c0   ; CALL objc_msgSend$stackNumberAt:top:width:
0x000339d4  mov      x0, x19
0x000339d8  bl       #0x58040   ; CALL objc_msgSend$iconView
0x000339dc  mov      x29, x29
0x000339e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000339e4  mov      x20, x0
0x000339e8  adrp     x8, #0x65000
0x000339ec  ldr      d1, [x8, #0xce0]
0x000339f0  fmov     d0, #11.00000000
0x000339f4  fmov     d2, #22.00000000
0x000339f8  bl       #0x3460c
0x000339fc  mov      x0, x20
0x00033a00  bl       #0x55d78   ; CALL _objc_release
0x00033a04  mov      x0, x19
0x00033a08  bl       #0x5cb80   ; CALL objc_msgSend$sign
0x00033a0c  mov      x29, x29
0x00033a10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033a14  mov      x20, x0
0x00033a18  adrp     x8, #0x65000
0x00033a1c  ldr      d0, [x8, #0xce8]
0x00033a20  mov      x8, #0x4049000000000000
0x00033a24  fmov     d2, x8
0x00033a28  fmov     d1, #25.00000000
0x00033a2c  bl       #0x3460c
0x00033a30  mov      x0, x20
0x00033a34  bl       #0x55d78   ; CALL _objc_release
0x00033a38  mov      x0, x19
0x00033a3c  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00033a40  mov      x29, x29
0x00033a44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033a48  mov      x20, x0
0x00033a4c  mov      x0, x23
0x00033a50  bl       #0x55d78   ; CALL _objc_release
0x00033a54  mov      x0, x22
0x00033a58  bl       #0x55d78   ; CALL _objc_release
0x00033a5c  adrp     x8, #0x65000
0x00033a60  ldr      d8, [x8, #0xcf0]
0x00033a64  mov      x8, #0x405e000000000000
0x00033a68  fmov     d9, x8
0x00033a6c  b        #0x34320
0x00033a70  adrp     x21, #0x8e000
0x00033a74  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00033a78  adrp     x8, #0x65000
0x00033a7c  ldr      d1, [x8, #0x8f8]
0x00033a80  adrp     x8, #0x65000
0x00033a84  ldr      d2, [x8, #0xb70]
0x00033a88  fmov     d0, #1.00000000
0x00033a8c  fmov     d3, #1.00000000
0x00033a90  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00033a94  mov      x29, x29
0x00033a98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033a9c  mov      x20, x0
0x00033aa0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00033aa4  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00033aa8  stur     x0, [x29, #-0xf8]
0x00033aac  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00033ab0  adrp     x8, #0x65000
0x00033ab4  ldr      d1, [x8, #0xab0]
0x00033ab8  adrp     x8, #0x65000
0x00033abc  ldr      d2, [x8, #0xab8]
0x00033ac0  fmov     d0, #1.00000000
0x00033ac4  fmov     d3, #1.00000000
0x00033ac8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00033acc  mov      x29, x29
0x00033ad0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033ad4  mov      x21, x27
0x00033ad8  mov      x27, x0
0x00033adc  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00033ae0  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00033ae4  stur     x0, [x29, #-0xf0]
0x00033ae8  adrp     x8, #0x8e000
0x00033aec  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00033af0  sub      x2, x29, #0xf8
0x00033af4  mov      w3, #2
0x00033af8  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00033afc  mov      x29, x29
0x00033b00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033b04  mov      x19, x28
0x00033b08  mov      x28, x0
0x00033b0c  mov      x0, x26
0x00033b10  mov      x2, x28
0x00033b14  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x00033b18  mov      x0, x28
0x00033b1c  mov      x28, x19
0x00033b20  bl       #0x55d78   ; CALL _objc_release
0x00033b24  mov      x0, x27
0x00033b28  mov      x27, x21
0x00033b2c  ldr      x19, [sp, #0x50]
0x00033b30  bl       #0x55d78   ; CALL _objc_release
0x00033b34  mov      x0, x20
0x00033b38  bl       #0x55d78   ; CALL _objc_release
0x00033b3c  ldr      d8, [sp, #0x68]
0x00033b40  b        #0x33bb0
0x00033b44  adrp     x8, #0x65000
0x00033b48  ldr      d1, [x8, #0x8f8]
0x00033b4c  adrp     x8, #0x65000
0x00033b50  ldr      d2, [x8, #0xb70]
0x00033b54  fmov     d0, #1.00000000
0x00033b58  fmov     d3, #1.00000000
0x00033b5c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00033b60  mov      x29, x29
0x00033b64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033b68  mov      x24, x0
0x00033b6c  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00033b70  adrp     x8, #0x65000
0x00033b74  ldr      d1, [x8, #0xab0]
0x00033b78  adrp     x8, #0x65000
0x00033b7c  ldr      d2, [x8, #0xab8]
0x00033b80  fmov     d0, #1.00000000
0x00033b84  fmov     d3, #1.00000000
0x00033b88  b        #0x33d08
0x00033b8c  bl       #0x304f4
0x00033b90  mov      x29, x29
0x00033b94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033b98  mov      x20, x0
0x00033b9c  mov      x0, x26
0x00033ba0  mov      x2, x20
0x00033ba4  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x00033ba8  mov      x0, x20
0x00033bac  bl       #0x55d78   ; CALL _objc_release
0x00033bb0  ldr      d9, [sp, #0x60]
0x00033bb4  adrp     x21, #0x8e000
0x00033bb8  ldr      x0, [x21, #0xab8]   ; @CLASS CATransaction
0x00033bbc  mov      w2, #0
0x00033bc0  bl       #0x5ad00   ; CALL objc_msgSend$setDisableActions:
0x00033bc4  fmul     d0, d8, d10
0x00033bc8  adrp     x8, #0x65000
0x00033bcc  ldr      d1, [x8, #0x708]
0x00033bd0  mov      x0, x23
0x00033bd4  bl       #0x348d8
0x00033bd8  ldr      x0, [x21, #0xab8]   ; @CLASS CATransaction
0x00033bdc  mov      w2, #1
0x00033be0  bl       #0x5ad00   ; CALL objc_msgSend$setDisableActions:
0x00033be4  adrp     x8, #0x65000
0x00033be8  ldr      d0, [x8, #0xc50]
0x00033bec  fadd     d9, d9, d0
0x00033bf0  mov      x0, x19
0x00033bf4  bl       #0x5cb80   ; CALL objc_msgSend$sign
0x00033bf8  mov      x29, x29
0x00033bfc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033c00  mov      x20, x0
0x00033c04  fmov     d0, #25.00000000
0x00033c08  fadd     d0, d9, d0
0x00033c0c  mov      x8, #0x4049000000000000
0x00033c10  fmov     d8, x8
0x00033c14  fmov     d1, #29.00000000
0x00033c18  mov      v2.16b, v8.16b
0x00033c1c  bl       #0x3460c
0x00033c20  mov      x0, x20
0x00033c24  bl       #0x55d78   ; CALL _objc_release
0x00033c28  fadd     d0, d9, d8
0x00033c2c  fmov     d1, #4.00000000
0x00033c30  fadd     d9, d0, d1
0x00033c34  mov      x0, x19
0x00033c38  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00033c3c  mov      x29, x29
0x00033c40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033c44  mov      x20, x0
0x00033c48  mov      x8, #0x404d000000000000
0x00033c4c  fmov     d8, x8
0x00033c50  fmov     d0, xzr
0x00033c54  fmov     d1, xzr
0x00033c58  mov      v2.16b, v9.16b
0x00033c5c  mov      v3.16b, v8.16b
0x00033c60  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00033c64  mov      x0, x20
0x00033c68  bl       #0x55d78   ; CALL _objc_release
0x00033c6c  mov      x0, x19
0x00033c70  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00033c74  mov      x29, x29
0x00033c78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033c7c  mov      x20, x0
0x00033c80  fmov     d0, #29.00000000
0x00033c84  bl       #0x5ab20   ; CALL objc_msgSend$setCorner:
0x00033c88  mov      x0, x20
0x00033c8c  bl       #0x55d78   ; CALL _objc_release
0x00033c90  mov      x0, x26
0x00033c94  mov      x26, x21
0x00033c98  bl       #0x55d78   ; CALL _objc_release
0x00033c9c  mov      x0, x25
0x00033ca0  bl       #0x55d78   ; CALL _objc_release
0x00033ca4  mov      x0, x24
0x00033ca8  bl       #0x55d78   ; CALL _objc_release
0x00033cac  mov      x0, x23
0x00033cb0  b        #0x34178
0x00033cb4  adrp     x8, #0x65000
0x00033cb8  ldr      d0, [x8, #0xc80]
0x00033cbc  adrp     x8, #0x65000
0x00033cc0  ldr      d1, [x8, #0xc88]
0x00033cc4  adrp     x8, #0x65000
0x00033cc8  ldr      d2, [x8, #0xc90]
0x00033ccc  adrp     x8, #0x65000
0x00033cd0  ldr      d9, [x8, #0xc98]
0x00033cd4  mov      v3.16b, v9.16b
0x00033cd8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00033cdc  mov      x29, x29
0x00033ce0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033ce4  mov      x24, x0
0x00033ce8  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00033cec  adrp     x8, #0x65000
0x00033cf0  ldr      d0, [x8, #0xb28]
0x00033cf4  adrp     x8, #0x65000
0x00033cf8  ldr      d1, [x8, #0xa60]
0x00033cfc  adrp     x8, #0x65000
0x00033d00  ldr      d2, [x8, #0xb80]
0x00033d04  mov      v3.16b, v9.16b
0x00033d08  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00033d0c  mov      x29, x29
0x00033d10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033d14  mov      x25, x0
0x00033d18  mov      x0, x20
0x00033d1c  mov      x2, x24
0x00033d20  mov      x3, x25
0x00033d24  bl       #0x5c680   ; CALL objc_msgSend$setTop:bottom:
0x00033d28  cmp      w27, #0
0x00033d2c  cset     w26, ne
0x00033d30  mov      x0, x25
0x00033d34  bl       #0x55d78   ; CALL _objc_release
0x00033d38  mov      x0, x24
0x00033d3c  bl       #0x55d78   ; CALL _objc_release
0x00033d40  mov      x0, x20
0x00033d44  bl       #0x55d78   ; CALL _objc_release
0x00033d48  mov      x0, x19
0x00033d4c  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00033d50  mov      x29, x29
0x00033d54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033d58  mov      x20, x0
0x00033d5c  bl       #0x5c9a0   ; CALL objc_msgSend$sheen
0x00033d60  mov      x29, x29
0x00033d64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033d68  mov      x24, x0
0x00033d6c  mov      x2, x26
0x00033d70  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x00033d74  mov      x0, x24
0x00033d78  bl       #0x55d78   ; CALL _objc_release
0x00033d7c  mov      x0, x20
0x00033d80  bl       #0x55d78   ; CALL _objc_release
0x00033d84  cbz      w22, #0x33db4
0x00033d88  mov      x0, x19
0x00033d8c  bl       #0x58040   ; CALL objc_msgSend$iconView
0x00033d90  mov      x29, x29
0x00033d94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033d98  mov      x20, x0
0x00033d9c  fmov     d0, #23.00000000
0x00033da0  fmov     d1, #23.00000000
0x00033da4  fmov     d2, #22.00000000
0x00033da8  bl       #0x3460c
0x00033dac  mov      x0, x20
0x00033db0  bl       #0x55d78   ; CALL _objc_release
0x00033db4  mov      x0, x19
0x00033db8  bl       #0x5cb80   ; CALL objc_msgSend$sign
0x00033dbc  mov      x29, x29
0x00033dc0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033dc4  mov      x20, x0
0x00033dc8  mov      x8, #0x4056000000000000
0x00033dcc  fmov     d0, x8
0x00033dd0  mov      x8, #0x4042000000000000
0x00033dd4  fmov     d1, x8
0x00033dd8  mov      x8, #0x4048000000000000
0x00033ddc  fmov     d2, x8
0x00033de0  bl       #0x3460c
0x00033de4  mov      x0, x20
0x00033de8  bl       #0x55d78   ; CALL _objc_release
0x00033dec  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00033df0  cbz      w27, #0x33e04
0x00033df4  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x00033df8  mov      x29, x29
0x00033dfc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033e00  b        #0x33e30
0x00033e04  adrp     x8, #0x65000
0x00033e08  ldr      d0, [x8, #0x820]
0x00033e0c  adrp     x8, #0x65000
0x00033e10  ldr      d1, [x8, #0xad0]
0x00033e14  adrp     x8, #0x65000
0x00033e18  ldr      d2, [x8, #0x928]
0x00033e1c  adrp     x8, #0x65000
0x00033e20  ldr      d3, [x8, #0x838]
0x00033e24  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00033e28  mov      x29, x29
0x00033e2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033e30  mov      x22, x0
0x00033e34  cmp      w27, #0
0x00033e38  cset     w20, ne
0x00033e3c  mov      x0, x19
0x00033e40  bl       #0x5dc80   ; CALL objc_msgSend$unitLabel
0x00033e44  mov      x29, x29
0x00033e48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033e4c  mov      x24, x0
0x00033e50  mov      x2, x22
0x00033e54  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00033e58  mov      x0, x24
0x00033e5c  bl       #0x55d78   ; CALL _objc_release
0x00033e60  mov      x0, x22
0x00033e64  bl       #0x55d78   ; CALL _objc_release
0x00033e68  mov      x0, x19
0x00033e6c  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x00033e70  mov      x29, x29
0x00033e74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033e78  mov      x22, x0
0x00033e7c  mov      x8, #0x4069000000000000
0x00033e80  fmov     d0, x8
0x00033e84  mov      x8, #0x4049000000000000
0x00033e88  fmov     d1, x8
0x00033e8c  bl       #0x5cbc0   ; CALL objc_msgSend$sizeThatFits:
0x00033e90  frintp   d9, d0
0x00033e94  mov      x0, x22
0x00033e98  bl       #0x55d78   ; CALL _objc_release
0x00033e9c  mov      x0, x19
0x00033ea0  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x00033ea4  mov      x29, x29
0x00033ea8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033eac  mov      x22, x0
0x00033eb0  adrp     x8, #0x65000
0x00033eb4  ldr      d1, [x8, #0xca0]
0x00033eb8  mov      x8, #0x4048000000000000
0x00033ebc  fmov     d3, x8
0x00033ec0  fmov     d0, #12.00000000
0x00033ec4  mov      v2.16b, v9.16b
0x00033ec8  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00033ecc  mov      x0, x22
0x00033ed0  bl       #0x55d78   ; CALL _objc_release
0x00033ed4  mov      x0, x19
0x00033ed8  bl       #0x5dc80   ; CALL objc_msgSend$unitLabel
0x00033edc  mov      x29, x29
0x00033ee0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033ee4  mov      x22, x0
0x00033ee8  mov      x0, x19
0x00033eec  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x00033ef0  mov      x29, x29
0x00033ef4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033ef8  mov      x24, x0
0x00033efc  mov      x0, x22
0x00033f00  mov      x1, x24
0x00033f04  bl       #0x34760
0x00033f08  mov      x0, x24
0x00033f0c  bl       #0x55d78   ; CALL _objc_release
0x00033f10  mov      x0, x22
0x00033f14  bl       #0x55d78   ; CALL _objc_release
0x00033f18  adrp     x2, #0x7b000
0x00033f1c  add      x2, x2, #0x128   ; STR "track"
0x00033f20  mov      x0, x19
0x00033f24  bl       #0x56900   ; CALL objc_msgSend$bit:
0x00033f28  mov      x29, x29
0x00033f2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033f30  mov      x22, x0
0x00033f34  adrp     x2, #0x7b000
0x00033f38  add      x2, x2, #0x148   ; STR "fill"
0x00033f3c  mov      x0, x19
0x00033f40  bl       #0x56900   ; CALL objc_msgSend$bit:
0x00033f44  mov      x29, x29
0x00033f48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033f4c  mov      x24, x0
0x00033f50  adrp     x8, #0x65000
0x00033f54  ldr      d1, [x8, #0xca8]
0x00033f58  mov      x8, #0x4059000000000000
0x00033f5c  fmov     d2, x8
0x00033f60  fmov     d0, #12.00000000
0x00033f64  fmov     d3, #6.00000000
0x00033f68  mov      x0, x22
0x00033f6c  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00033f70  mov      x0, x22
0x00033f74  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00033f78  mov      v9.16b, v2.16b
0x00033f7c  mov      x0, x19
0x00033f80  bl       #0x595e0   ; CALL objc_msgSend$parts
0x00033f84  mov      x29, x29
0x00033f88  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033f8c  mov      x25, x0
0x00033f90  adrp     x26, #0x7b000
0x00033f94  add      x26, x26, #0x188   ; STR "fillGrad"
0x00033f98  mov      x2, x26
0x00033f9c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00033fa0  mov      x29, x29
0x00033fa4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033fa8  mov      x19, x27
0x00033fac  mov      x27, x0
0x00033fb0  fmov     d0, xzr
0x00033fb4  fmov     d1, xzr
0x00033fb8  fmov     d3, #6.00000000
0x00033fbc  mov      v2.16b, v9.16b
0x00033fc0  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00033fc4  mov      x0, x27
0x00033fc8  mov      x27, x19
0x00033fcc  ldr      x19, [sp, #0x50]
0x00033fd0  bl       #0x55d78   ; CALL _objc_release
0x00033fd4  mov      x0, x25
0x00033fd8  bl       #0x55d78   ; CALL _objc_release
0x00033fdc  mov      x0, x19
0x00033fe0  bl       #0x595e0   ; CALL objc_msgSend$parts
0x00033fe4  mov      x29, x29
0x00033fe8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00033fec  mov      x25, x0
0x00033ff0  mov      x2, x26
0x00033ff4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00033ff8  mov      x29, x29
0x00033ffc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034000  mov      x26, x0
0x00034004  mov      x2, x20
0x00034008  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x0003400c  mov      x0, x26
0x00034010  bl       #0x55d78   ; CALL _objc_release
0x00034014  mov      x0, x25
0x00034018  bl       #0x55d78   ; CALL _objc_release
0x0003401c  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00034020  cbz      w27, #0x34034
0x00034024  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x00034028  mov      x29, x29
0x0003402c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034030  b        #0x34040
0x00034034  bl       #0x56de0   ; CALL objc_msgSend$clearColor
0x00034038  mov      x29, x29
0x0003403c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034040  mov      x20, x0
0x00034044  adrp     x26, #0x8e000
0x00034048  mov      x0, x24
0x0003404c  mov      x2, x20
0x00034050  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x00034054  mov      x0, x20
0x00034058  bl       #0x55d78   ; CALL _objc_release
0x0003405c  ldr      x0, [x26, #0xab8]   ; @CLASS CATransaction
0x00034060  mov      w2, #0
0x00034064  bl       #0x5ad00   ; CALL objc_msgSend$setDisableActions:
0x00034068  mov      x0, x22
0x0003406c  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00034070  fmul     d0, d8, d2
0x00034074  adrp     x8, #0x65000
0x00034078  ldr      d1, [x8, #0x6e8]
0x0003407c  mov      x0, x24
0x00034080  bl       #0x348d8
0x00034084  ldr      x0, [x26, #0xab8]   ; @CLASS CATransaction
0x00034088  mov      w2, #1
0x0003408c  bl       #0x5ad00   ; CALL objc_msgSend$setDisableActions:
0x00034090  mov      x0, x24
0x00034094  bl       #0x55d78   ; CALL _objc_release
0x00034098  mov      x0, x22
0x0003409c  bl       #0x55d78   ; CALL _objc_release
0x000340a0  mov      x0, x23
0x000340a4  bl       #0x55d78   ; CALL _objc_release
0x000340a8  mov      x8, #0x405f000000000000
0x000340ac  fmov     d9, x8
0x000340b0  mov      v8.16b, v9.16b
0x000340b4  b        #0x34184
0x000340b8  adrp     x8, #0x65000
0x000340bc  ldr      d0, [x8, #0x658]
0x000340c0  adrp     x8, #0x65000
0x000340c4  ldr      d1, [x8, #0xb68]
0x000340c8  adrp     x8, #0x65000
0x000340cc  ldr      d3, [x8, #0x700]
0x000340d0  fmov     d2, #1.00000000
0x000340d4  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000340d8  mov      x29, x29
0x000340dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000340e0  mov      x24, x0
0x000340e4  mov      w21, #0
0x000340e8  mov      w28, #1
0x000340ec  mov      x0, x24
0x000340f0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000340f4  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000340f8  mov      x25, x0
0x000340fc  mov      x0, x19
0x00034100  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x00034104  mov      x29, x29
0x00034108  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003410c  mov      x26, x0
0x00034110  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00034114  mov      x29, x29
0x00034118  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003411c  mov      x27, x0
0x00034120  mov      x2, x25
0x00034124  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x00034128  mov      x0, x27
0x0003412c  bl       #0x55d78   ; CALL _objc_release
0x00034130  mov      x0, x26
0x00034134  bl       #0x55d78   ; CALL _objc_release
0x00034138  cbz      w28, #0x34144
0x0003413c  mov      x0, x24
0x00034140  bl       #0x55d78   ; CALL _objc_release
0x00034144  mov      x27, x23
0x00034148  adrp     x26, #0x8e000
0x0003414c  cbz      w21, #0x34158
0x00034150  mov      x0, x24
0x00034154  bl       #0x55d78   ; CALL _objc_release
0x00034158  cmp      w27, #2
0x0003415c  ldp      x28, x19, [sp, #0x48]
0x00034160  b.ne     #0x3416c
0x00034164  mov      x0, x24
0x00034168  bl       #0x55d78   ; CALL _objc_release
0x0003416c  mov      x0, x20
0x00034170  bl       #0x55d78   ; CALL _objc_release
0x00034174  ldr      x0, [sp, #0x68]
0x00034178  bl       #0x55d78   ; CALL _objc_release
0x0003417c  mov      x0, x22
0x00034180  bl       #0x55d78   ; CALL _objc_release
0x00034184  mov      x0, x19
0x00034188  mov      x2, x27
0x0003418c  bl       #0x564c0   ; CALL objc_msgSend$applyColor:
0x00034190  b        #0x343ec
0x00034194  adrp     x8, #0x65000
0x00034198  ldr      d0, [x8, #0x658]
0x0003419c  adrp     x8, #0x65000
0x000341a0  ldr      d1, [x8, #0xb68]
0x000341a4  fmov     d2, #1.00000000
0x000341a8  mov      v3.16b, v8.16b
0x000341ac  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000341b0  mov      x29, x29
0x000341b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000341b8  mov      x20, x0
0x000341bc  mov      w22, #0
0x000341c0  mov      w25, #1
0x000341c4  mov      x0, x20
0x000341c8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000341cc  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000341d0  mov      x21, x0
0x000341d4  mov      x0, x19
0x000341d8  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x000341dc  mov      x29, x29
0x000341e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000341e4  mov      x24, x0
0x000341e8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000341ec  mov      x29, x29
0x000341f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000341f4  mov      x27, x0
0x000341f8  mov      x2, x21
0x000341fc  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x00034200  mov      x0, x27
0x00034204  bl       #0x55d78   ; CALL _objc_release
0x00034208  mov      x0, x24
0x0003420c  bl       #0x55d78   ; CALL _objc_release
0x00034210  cbz      w25, #0x3421c
0x00034214  mov      x0, x20
0x00034218  bl       #0x55d78   ; CALL _objc_release
0x0003421c  ldr      w27, [sp, #0x44]
0x00034220  cbz      w22, #0x3422c
0x00034224  mov      x0, x20
0x00034228  bl       #0x55d78   ; CALL _objc_release
0x0003422c  cmp      w27, #2
0x00034230  ldr      x19, [sp, #0x50]
0x00034234  ldr      x21, [sp, #8]
0x00034238  b.ne     #0x34244
0x0003423c  mov      x0, x20
0x00034240  bl       #0x55d78   ; CALL _objc_release
0x00034244  mov      x0, x19
0x00034248  bl       #0x58040   ; CALL objc_msgSend$iconView
0x0003424c  mov      x29, x29
0x00034250  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034254  mov      x20, x0
0x00034258  fmov     d0, #14.00000000
0x0003425c  fmov     d1, #14.00000000
0x00034260  fmov     d2, #24.00000000
0x00034264  bl       #0x3460c
0x00034268  mov      x0, x20
0x0003426c  bl       #0x55d78   ; CALL _objc_release
0x00034270  mov      x0, x19
0x00034274  bl       #0x5cb80   ; CALL objc_msgSend$sign
0x00034278  mov      x29, x29
0x0003427c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034280  mov      x20, x0
0x00034284  adrp     x8, #0x65000
0x00034288  ldr      d0, [x8, #0xc10]
0x0003428c  adrp     x8, #0x65000
0x00034290  ldr      d1, [x8, #0xc18]
0x00034294  adrp     x8, #0x65000
0x00034298  ldr      d2, [x8, #0xc20]
0x0003429c  bl       #0x3460c
0x000342a0  mov      x0, x20
0x000342a4  bl       #0x55d78   ; CALL _objc_release
0x000342a8  mov      x0, x19
0x000342ac  bl       #0x57660   ; CALL objc_msgSend$deco
0x000342b0  mov      x29, x29
0x000342b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000342b8  mov      x20, x0
0x000342bc  mov      x0, x28
0x000342c0  bl       #0x55d78   ; CALL _objc_release
0x000342c4  ldr      x0, [sp, #0x28]
0x000342c8  bl       #0x55d78   ; CALL _objc_release
0x000342cc  mov      x0, x21
0x000342d0  bl       #0x55d78   ; CALL _objc_release
0x000342d4  ldr      x0, [sp, #0x38]
0x000342d8  bl       #0x55d78   ; CALL _objc_release
0x000342dc  ldr      x0, [sp, #0x10]
0x000342e0  bl       #0x55d78   ; CALL _objc_release
0x000342e4  ldr      x0, [sp, #0x58]
0x000342e8  bl       #0x55d78   ; CALL _objc_release
0x000342ec  ldr      x0, [sp, #0x60]
0x000342f0  bl       #0x55d78   ; CALL _objc_release
0x000342f4  ldr      x0, [sp, #0x30]
0x000342f8  bl       #0x55d78   ; CALL _objc_release
0x000342fc  mov      x0, x23
0x00034300  bl       #0x55d78   ; CALL _objc_release
0x00034304  ldr      x0, [sp, #0x68]
0x00034308  bl       #0x55d78   ; CALL _objc_release
0x0003430c  adrp     x8, #0x65000
0x00034310  ldr      d8, [x8, #0xc28]
0x00034314  adrp     x8, #0x65000
0x00034318  ldr      d9, [x8, #0xc30]
0x0003431c  ldr      x28, [sp, #0x48]
0x00034320  mov      x0, x19
0x00034324  mov      x2, x27
0x00034328  bl       #0x564c0   ; CALL objc_msgSend$applyColor:
0x0003432c  cbz      x20, #0x343ec
0x00034330  mov      x0, x20
0x00034334  bl       #0x57d00   ; CALL objc_msgSend$frame
0x00034338  fmov     d4, #-6.00000000
0x0003433c  fmov     d5, #-6.00000000
0x00034340  bl       #0x55a90   ; CALL _CGRectInset
0x00034344  mov      v10.16b, v0.16b
0x00034348  mov      v11.16b, v1.16b
0x0003434c  mov      v12.16b, v2.16b
0x00034350  mov      v13.16b, v3.16b
0x00034354  mov      x0, x19
0x00034358  bl       #0x57c40   ; CALL objc_msgSend$flashView
0x0003435c  mov      x29, x29
0x00034360  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034364  mov      x21, x0
0x00034368  mov      v0.16b, v10.16b
0x0003436c  mov      v1.16b, v11.16b
0x00034370  mov      v2.16b, v12.16b
0x00034374  mov      v3.16b, v13.16b
0x00034378  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0003437c  mov      x0, x21
0x00034380  bl       #0x55d78   ; CALL _objc_release
0x00034384  mov      x0, x19
0x00034388  bl       #0x5ce20   ; CALL objc_msgSend$speedLabel
0x0003438c  mov      x29, x29
0x00034390  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034394  mov      x22, x0
0x00034398  fcmp     d12, d13
0x0003439c  fcsel    d0, d12, d13, mi
0x000343a0  fmov     d1, #0.50000000
0x000343a4  fmul     d0, d0, d1
0x000343a8  cmp      x20, x0
0x000343ac  fmov     d1, #16.00000000
0x000343b0  fcsel    d10, d1, d0, eq
0x000343b4  mov      x0, x19
0x000343b8  bl       #0x57c40   ; CALL objc_msgSend$flashView
0x000343bc  mov      x29, x29
0x000343c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000343c4  mov      x23, x0
0x000343c8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000343cc  mov      x29, x29
0x000343d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000343d4  mov      x21, x0
0x000343d8  mov      v0.16b, v10.16b
0x000343dc  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x000343e0  mov      x0, x21
0x000343e4  bl       #0x55d78   ; CALL _objc_release
0x000343e8  b        #0x34494
0x000343ec  mov      x0, x19
0x000343f0  bl       #0x57e20   ; CALL objc_msgSend$glass
0x000343f4  mov      x29, x29
0x000343f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000343fc  mov      x20, x0
0x00034400  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00034404  mov      v10.16b, v0.16b
0x00034408  mov      v11.16b, v1.16b
0x0003440c  mov      v12.16b, v2.16b
0x00034410  mov      v13.16b, v3.16b
0x00034414  mov      x0, x19
0x00034418  bl       #0x57c40   ; CALL objc_msgSend$flashView
0x0003441c  mov      x29, x29
0x00034420  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034424  mov      x21, x0
0x00034428  mov      v0.16b, v10.16b
0x0003442c  mov      v1.16b, v11.16b
0x00034430  mov      v2.16b, v12.16b
0x00034434  mov      v3.16b, v13.16b
0x00034438  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0003443c  mov      x0, x21
0x00034440  bl       #0x55d78   ; CALL _objc_release
0x00034444  mov      x0, x20
0x00034448  bl       #0x55d78   ; CALL _objc_release
0x0003444c  mov      x0, x19
0x00034450  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00034454  mov      x29, x29
0x00034458  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003445c  mov      x20, x0
0x00034460  bl       #0x573a0   ; CALL objc_msgSend$corner
0x00034464  mov      v10.16b, v0.16b
0x00034468  mov      x0, x19
0x0003446c  bl       #0x57c40   ; CALL objc_msgSend$flashView
0x00034470  mov      x29, x29
0x00034474  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034478  mov      x22, x0
0x0003447c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00034480  mov      x29, x29
0x00034484  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034488  mov      x23, x0
0x0003448c  mov      v0.16b, v10.16b
0x00034490  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x00034494  mov      x0, x23
0x00034498  bl       #0x55d78   ; CALL _objc_release
0x0003449c  mov      x0, x22
0x000344a0  bl       #0x55d78   ; CALL _objc_release
0x000344a4  mov      x0, x20
0x000344a8  bl       #0x55d78   ; CALL _objc_release
0x000344ac  mov      x0, x19
0x000344b0  bl       #0x56b20   ; CALL objc_msgSend$builtStyle
0x000344b4  cmp      x0, #5
0x000344b8  b.ne     #0x344e4
0x000344bc  fmov     d0, xzr
0x000344c0  fmov     d1, xzr
0x000344c4  mov      x0, x19
0x000344c8  mov      v2.16b, v9.16b
0x000344cc  mov      v3.16b, v8.16b
0x000344d0  bl       #0x5ba00   ; CALL objc_msgSend$setOutlineRect:
0x000344d4  fmov     d0, #16.00000000
0x000344d8  mov      x0, x19
0x000344dc  bl       #0x5b9e0   ; CALL objc_msgSend$setOutlineCorner:
0x000344e0  b        #0x34590
0x000344e4  mov      x0, x19
0x000344e8  bl       #0x56b20   ; CALL objc_msgSend$builtStyle
0x000344ec  cmp      x0, #8
0x000344f0  b.ne     #0x34540
0x000344f4  mov      x0, x19
0x000344f8  bl       #0x57660   ; CALL objc_msgSend$deco
0x000344fc  mov      x29, x29
0x00034500  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034504  mov      x20, x0
0x00034508  bl       #0x57d00   ; CALL objc_msgSend$frame
0x0003450c  mov      x0, x19
0x00034510  bl       #0x5ba00   ; CALL objc_msgSend$setOutlineRect:
0x00034514  mov      x0, x20
0x00034518  bl       #0x55d78   ; CALL _objc_release
0x0003451c  mov      x0, x19
0x00034520  bl       #0x57660   ; CALL objc_msgSend$deco
0x00034524  mov      x29, x29
0x00034528  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003452c  mov      x20, x0
0x00034530  bl       #0x57d00   ; CALL objc_msgSend$frame
0x00034534  fmov     d0, #0.50000000
0x00034538  fmul     d0, d2, d0
0x0003453c  b        #0x34580
0x00034540  mov      x0, x19
0x00034544  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00034548  mov      x29, x29
0x0003454c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034550  mov      x20, x0
0x00034554  bl       #0x57d00   ; CALL objc_msgSend$frame
0x00034558  mov      x0, x19
0x0003455c  bl       #0x5ba00   ; CALL objc_msgSend$setOutlineRect:
0x00034560  mov      x0, x20
0x00034564  bl       #0x55d78   ; CALL _objc_release
0x00034568  mov      x0, x19
0x0003456c  bl       #0x57e20   ; CALL objc_msgSend$glass
0x00034570  mov      x29, x29
0x00034574  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034578  mov      x20, x0
0x0003457c  bl       #0x573a0   ; CALL objc_msgSend$corner
0x00034580  mov      x0, x19
0x00034584  bl       #0x5b9e0   ; CALL objc_msgSend$setOutlineCorner:
0x00034588  mov      x0, x20
0x0003458c  bl       #0x55d78   ; CALL _objc_release
0x00034590  ldr      x0, [x26, #0xab8]   ; @CLASS CATransaction
0x00034594  bl       #0x56f40   ; CALL objc_msgSend$commit
0x00034598  mov      x0, x19
0x0003459c  mov      v0.16b, v9.16b
0x000345a0  mov      v1.16b, v8.16b
0x000345a4  bl       #0x5aac0   ; CALL objc_msgSend$setContentSize:
0x000345a8  cmp      w27, #2
0x000345ac  cset     w2, eq
0x000345b0  mov      x0, x19
0x000345b4  bl       #0x5ba60   ; CALL objc_msgSend$setOverLimitWarning:
0x000345b8  mov      x0, x28
0x000345bc  bl       #0x55d78   ; CALL _objc_release
0x000345c0  ldur     x8, [x29, #-0xa8]
0x000345c4  adrp     x9, #0x74000
0x000345c8  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000345cc  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000345d0  cmp      x9, x8
0x000345d4  b.ne     #0x34608
0x000345d8  add      sp, sp, #0x250
0x000345dc  ldp      x29, x30, [sp, #0x90]
0x000345e0  ldp      x20, x19, [sp, #0x80]
0x000345e4  ldp      x22, x21, [sp, #0x70]
0x000345e8  ldp      x24, x23, [sp, #0x60]
0x000345ec  ldp      x26, x25, [sp, #0x50]
0x000345f0  ldp      x28, x27, [sp, #0x40]
0x000345f4  ldp      d9, d8, [sp, #0x30]
0x000345f8  ldp      d11, d10, [sp, #0x20]
0x000345fc  ldp      d13, d12, [sp, #0x10]
0x00034600  ldp      d15, d14, [sp], #0xa0
0x00034604  ret      
0x00034608  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0003460c  stp      d11, d10, [sp, #-0x40]!
0x00034610  stp      d9, d8, [sp, #0x10]
0x00034614  stp      x20, x19, [sp, #0x20]
0x00034618  stp      x29, x30, [sp, #0x30]
0x0003461c  add      x29, sp, #0x30
0x00034620  mov      v8.16b, v2.16b
0x00034624  mov      v9.16b, v1.16b
0x00034628  mov      v10.16b, v0.16b
0x0003462c  mov      x19, x0
0x00034630  bl       #0x55d84   ; CALL _objc_retain
0x00034634  fmov     d0, xzr
0x00034638  fmov     d1, xzr
0x0003463c  mov      x0, x19
0x00034640  mov      v2.16b, v8.16b
0x00034644  mov      v3.16b, v8.16b
0x00034648  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x0003464c  mov      x0, x19
0x00034650  mov      v0.16b, v10.16b
0x00034654  mov      v1.16b, v9.16b
0x00034658  bl       #0x5a840   ; CALL objc_msgSend$setCenter:
0x0003465c  mov      x0, x19
0x00034660  bl       #0x5b7a0   ; CALL objc_msgSend$setNeedsLayout
0x00034664  mov      x0, x19
0x00034668  ldp      x29, x30, [sp, #0x30]
0x0003466c  ldp      x20, x19, [sp, #0x20]
0x00034670  ldp      d9, d8, [sp, #0x10]
0x00034674  ldp      d11, d10, [sp], #0x40
0x00034678  b        #0x55d78   ; CALL _objc_release
0x0003467c  stp      d11, d10, [sp, #-0x50]!
0x00034680  stp      d9, d8, [sp, #0x10]
0x00034684  stp      x22, x21, [sp, #0x20]
0x00034688  stp      x20, x19, [sp, #0x30]
0x0003468c  stp      x29, x30, [sp, #0x40]
0x00034690  add      x29, sp, #0x40
0x00034694  mov      x19, x1
0x00034698  mov      v8.16b, v3.16b
0x0003469c  mov      v9.16b, v2.16b
0x000346a0  mov      v10.16b, v1.16b
0x000346a4  mov      v11.16b, v0.16b
0x000346a8  mov      x20, x0
0x000346ac  mov      x0, x1
0x000346b0  bl       #0x55d84   ; CALL _objc_retain
0x000346b4  mov      x0, x20
0x000346b8  bl       #0x55d84   ; CALL _objc_retain
0x000346bc  mov      x0, x20
0x000346c0  mov      v0.16b, v11.16b
0x000346c4  mov      v1.16b, v10.16b
0x000346c8  mov      v2.16b, v9.16b
0x000346cc  mov      v3.16b, v8.16b
0x000346d0  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x000346d4  mov      x0, x20
0x000346d8  bl       #0x58f60   ; CALL objc_msgSend$mask
0x000346dc  mov      x29, x29
0x000346e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000346e4  mov      x21, x0
0x000346e8  mov      x0, x20
0x000346ec  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x000346f0  mov      v8.16b, v0.16b
0x000346f4  mov      v9.16b, v1.16b
0x000346f8  mov      v10.16b, v2.16b
0x000346fc  mov      v11.16b, v3.16b
0x00034700  mov      x0, x20
0x00034704  bl       #0x55d78   ; CALL _objc_release
0x00034708  mov      x0, x21
0x0003470c  mov      v0.16b, v8.16b
0x00034710  mov      v1.16b, v9.16b
0x00034714  mov      v2.16b, v10.16b
0x00034718  mov      v3.16b, v11.16b
0x0003471c  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00034720  mov      x0, x19
0x00034724  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00034728  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x0003472c  mov      x20, x0
0x00034730  mov      x0, x19
0x00034734  bl       #0x55d78   ; CALL _objc_release
0x00034738  mov      x0, x21
0x0003473c  mov      x2, x20
0x00034740  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x00034744  mov      x0, x21
0x00034748  ldp      x29, x30, [sp, #0x40]
0x0003474c  ldp      x20, x19, [sp, #0x30]
0x00034750  ldp      x22, x21, [sp, #0x20]
0x00034754  ldp      d9, d8, [sp, #0x10]
0x00034758  ldp      d11, d10, [sp], #0x50
0x0003475c  b        #0x55d78   ; CALL _objc_release
0x00034760  stp      d13, d12, [sp, #-0x60]!
0x00034764  stp      d11, d10, [sp, #0x10]
0x00034768  stp      d9, d8, [sp, #0x20]
0x0003476c  stp      x22, x21, [sp, #0x30]
0x00034770  stp      x20, x19, [sp, #0x40]
0x00034774  stp      x29, x30, [sp, #0x50]
0x00034778  add      x29, sp, #0x50
0x0003477c  mov      x20, x1
0x00034780  mov      x19, x0
0x00034784  mov      x0, x1
0x00034788  bl       #0x55d84   ; CALL _objc_retain
0x0003478c  mov      x0, x19
0x00034790  bl       #0x55d84   ; CALL _objc_retain
0x00034794  mov      x0, x20
0x00034798  bl       #0x57d00   ; CALL objc_msgSend$frame
0x0003479c  bl       #0x55a84   ; CALL _CGRectGetMinY
0x000347a0  mov      v8.16b, v0.16b
0x000347a4  mov      x0, x20
0x000347a8  bl       #0x57c60   ; CALL objc_msgSend$font
0x000347ac  mov      x29, x29
0x000347b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000347b4  mov      x21, x0
0x000347b8  bl       #0x56660   ; CALL objc_msgSend$ascender
0x000347bc  fadd     d9, d8, d0
0x000347c0  mov      x0, x20
0x000347c4  bl       #0x57d00   ; CALL objc_msgSend$frame
0x000347c8  mov      v8.16b, v3.16b
0x000347cc  mov      x0, x20
0x000347d0  bl       #0x57c60   ; CALL objc_msgSend$font
0x000347d4  mov      x29, x29
0x000347d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000347dc  mov      x22, x0
0x000347e0  bl       #0x58c60   ; CALL objc_msgSend$lineHeight
0x000347e4  fsub     d0, d8, d0
0x000347e8  fmov     d1, #0.50000000
0x000347ec  fmul     d0, d0, d1
0x000347f0  fadd     d13, d9, d0
0x000347f4  mov      x0, x22
0x000347f8  bl       #0x55d78   ; CALL _objc_release
0x000347fc  mov      x0, x21
0x00034800  bl       #0x55d78   ; CALL _objc_release
0x00034804  mov      x8, #0x4069000000000000
0x00034808  fmov     d0, x8
0x0003480c  mov      x8, #0x4044000000000000
0x00034810  fmov     d1, x8
0x00034814  mov      x0, x19
0x00034818  bl       #0x5cbc0   ; CALL objc_msgSend$sizeThatFits:
0x0003481c  frintp   d8, d0
0x00034820  mov      x0, x20
0x00034824  bl       #0x57d00   ; CALL objc_msgSend$frame
0x00034828  mov      v9.16b, v0.16b
0x0003482c  mov      v10.16b, v1.16b
0x00034830  mov      v11.16b, v2.16b
0x00034834  mov      v12.16b, v3.16b
0x00034838  mov      x0, x20
0x0003483c  bl       #0x55d78   ; CALL _objc_release
0x00034840  mov      v0.16b, v9.16b
0x00034844  mov      v1.16b, v10.16b
0x00034848  mov      v2.16b, v11.16b
0x0003484c  mov      v3.16b, v12.16b
0x00034850  bl       #0x55a48   ; CALL _CGRectGetMaxX
0x00034854  fmov     d1, #4.00000000
0x00034858  fadd     d9, d0, d1
0x0003485c  mov      x0, x19
0x00034860  bl       #0x57c60   ; CALL objc_msgSend$font
0x00034864  mov      x29, x29
0x00034868  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003486c  mov      x20, x0
0x00034870  bl       #0x56660   ; CALL objc_msgSend$ascender
0x00034874  fsub     d10, d13, d0
0x00034878  mov      x0, x19
0x0003487c  bl       #0x57c60   ; CALL objc_msgSend$font
0x00034880  mov      x29, x29
0x00034884  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034888  mov      x21, x0
0x0003488c  bl       #0x58c60   ; CALL objc_msgSend$lineHeight
0x00034890  mov      v3.16b, v0.16b
0x00034894  mov      x0, x19
0x00034898  mov      v0.16b, v9.16b
0x0003489c  mov      v1.16b, v10.16b
0x000348a0  mov      v2.16b, v8.16b
0x000348a4  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x000348a8  mov      x0, x19
0x000348ac  bl       #0x55d78   ; CALL _objc_release
0x000348b0  mov      x0, x21
0x000348b4  bl       #0x55d78   ; CALL _objc_release
0x000348b8  mov      x0, x20
0x000348bc  ldp      x29, x30, [sp, #0x50]
0x000348c0  ldp      x20, x19, [sp, #0x40]
0x000348c4  ldp      x22, x21, [sp, #0x30]
0x000348c8  ldp      d9, d8, [sp, #0x20]
0x000348cc  ldp      d11, d10, [sp, #0x10]
0x000348d0  ldp      d13, d12, [sp], #0x60
0x000348d4  b        #0x55d78   ; CALL _objc_release
0x000348d8  sub      sp, sp, #0x60
0x000348dc  stp      d9, d8, [sp, #0x30]
0x000348e0  stp      x20, x19, [sp, #0x40]
0x000348e4  stp      x29, x30, [sp, #0x50]
0x000348e8  add      x29, sp, #0x50
0x000348ec  mov      v8.16b, v1.16b
0x000348f0  mov      v9.16b, v0.16b
0x000348f4  mov      x19, x0
0x000348f8  bl       #0x55d84   ; CALL _objc_retain
0x000348fc  mov      x0, x19
0x00034900  bl       #0x57d00   ; CALL objc_msgSend$frame
0x00034904  fabd     d0, d2, d9
0x00034908  fmov     d1, #0.25000000
0x0003490c  fcmp     d0, d1
0x00034910  b.mi     #0x34980
0x00034914  adrp     x8, #0x8e000
0x00034918  ldr      x20, [x8, #0x918]   ; @CLASS UIView
0x0003491c  adrp     x8, #0x74000
0x00034920  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00034924  str      x8, [sp]
0x00034928  adrp     x8, #0x65000
0x0003492c  ldr      d0, [x8, #0x600]
0x00034930  str      d0, [sp, #8]
0x00034934  adrp     x8, #0x35000
0x00034938  add      x8, x8, #0x254
0x0003493c  adrp     x9, #0x74000
0x00034940  add      x9, x9, #0xc00
0x00034944  stp      x8, x9, [sp, #0x10]
0x00034948  mov      x0, x19
0x0003494c  bl       #0x55d84   ; CALL _objc_retain
0x00034950  str      x19, [sp, #0x20]
0x00034954  str      d9, [sp, #0x28]
0x00034958  fmov     d1, xzr
0x0003495c  mov      x3, sp
0x00034960  mov      x0, x20
0x00034964  mov      v0.16b, v8.16b
0x00034968  mov      w2, #4
0x0003496c  movk     w2, #2, lsl #16
0x00034970  mov      x4, #0
0x00034974  bl       #0x56340   ; CALL objc_msgSend$animateWithDuration:delay:options:animations:completion:
0x00034978  ldr      x0, [sp, #0x20]
0x0003497c  bl       #0x55d78   ; CALL _objc_release
0x00034980  mov      x0, x19
0x00034984  bl       #0x55d78   ; CALL _objc_release
0x00034988  ldp      x29, x30, [sp, #0x50]
0x0003498c  ldp      x20, x19, [sp, #0x40]
0x00034990  ldp      d9, d8, [sp, #0x30]
0x00034994  add      sp, sp, #0x60
0x00034998  ret      
0x0003499c  sub      sp, sp, #0x90
0x000349a0  stp      d11, d10, [sp, #0x30]
0x000349a4  stp      d9, d8, [sp, #0x40]
0x000349a8  stp      x24, x23, [sp, #0x50]
0x000349ac  stp      x22, x21, [sp, #0x60]
0x000349b0  stp      x20, x19, [sp, #0x70]
0x000349b4  stp      x29, x30, [sp, #0x80]
0x000349b8  add      x29, sp, #0x80
0x000349bc  adrp     x8, #0x74000
0x000349c0  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000349c4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000349c8  str      x8, [sp, #0x28]
0x000349cc  adrp     x22, #0x8e000
0x000349d0  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x000349d4  adrp     x8, #0x65000
0x000349d8  ldr      d8, [x8, #0x7a0]
0x000349dc  adrp     x8, #0x65000
0x000349e0  ldr      d9, [x8, #0x7a8]
0x000349e4  adrp     x8, #0x65000
0x000349e8  ldr      d10, [x8, #0x7b0]
0x000349ec  fmov     d3, #1.00000000
0x000349f0  mov      v0.16b, v8.16b
0x000349f4  mov      v1.16b, v9.16b
0x000349f8  mov      v2.16b, v10.16b
0x000349fc  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00034a00  mov      x29, x29
0x00034a04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034a08  mov      x19, x0
0x00034a0c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00034a10  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00034a14  str      x0, [sp]
0x00034a18  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x00034a1c  adrp     x8, #0x65000
0x00034a20  ldr      d0, [x8, #0x7b8]
0x00034a24  adrp     x8, #0x65000
0x00034a28  ldr      d1, [x8, #0x7c0]
0x00034a2c  fmov     d3, #1.00000000
0x00034a30  mov      v2.16b, v10.16b
0x00034a34  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00034a38  mov      x29, x29
0x00034a3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034a40  mov      x20, x0
0x00034a44  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00034a48  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00034a4c  str      x0, [sp, #8]
0x00034a50  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x00034a54  adrp     x8, #0x65000
0x00034a58  ldr      d0, [x8, #0x7c8]
0x00034a5c  adrp     x8, #0x65000
0x00034a60  ldr      d1, [x8, #0x7d0]
0x00034a64  adrp     x8, #0x65000
0x00034a68  ldr      d2, [x8, #0x7d8]
0x00034a6c  fmov     d3, #1.00000000
0x00034a70  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00034a74  mov      x29, x29
0x00034a78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034a7c  mov      x21, x0
0x00034a80  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00034a84  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00034a88  str      x0, [sp, #0x10]
0x00034a8c  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x00034a90  adrp     x8, #0x65000
0x00034a94  ldr      d0, [x8, #0x7e0]
0x00034a98  adrp     x8, #0x65000
0x00034a9c  ldr      d1, [x8, #0x7e8]
0x00034aa0  adrp     x8, #0x65000
0x00034aa4  ldr      d2, [x8, #0x7f0]
0x00034aa8  fmov     d3, #1.00000000
0x00034aac  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00034ab0  mov      x29, x29
0x00034ab4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034ab8  mov      x23, x0
0x00034abc  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00034ac0  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00034ac4  str      x0, [sp, #0x18]
0x00034ac8  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x00034acc  fmov     d3, #1.00000000
0x00034ad0  mov      v0.16b, v8.16b
0x00034ad4  mov      v1.16b, v9.16b
0x00034ad8  mov      v2.16b, v10.16b
0x00034adc  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00034ae0  mov      x29, x29
0x00034ae4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034ae8  mov      x24, x0
0x00034aec  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00034af0  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00034af4  str      x0, [sp, #0x20]
0x00034af8  adrp     x8, #0x8e000
0x00034afc  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00034b00  mov      x2, sp
0x00034b04  mov      w3, #5
0x00034b08  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00034b0c  mov      x29, x29
0x00034b10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00034b14  mov      x22, x0
0x00034b18  mov      x0, x24
0x00034b1c  bl       #0x55d78   ; CALL _objc_release
0x00034b20  mov      x0, x23
0x00034b24  bl       #0x55d78   ; CALL _objc_release
0x00034b28  mov      x0, x21
0x00034b2c  bl       #0x55d78   ; CALL _objc_release
0x00034b30  mov      x0, x20
0x00034b34  bl       #0x55d78   ; CALL _objc_release
0x00034b38  mov      x0, x19
0x00034b3c  bl       #0x55d78   ; CALL _objc_release
0x00034b40  ldr      x8, [sp, #0x28]
0x00034b44  adrp     x9, #0x74000
0x00034b48  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00034b4c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00034b50  cmp      x9, x8
0x00034b54  b.ne     #0x34b7c
0x00034b58  mov      x0, x22
0x00034b5c  ldp      x29, x30, [sp, #0x80]
0x00034b60  ldp      x20, x19, [sp, #0x70]
0x00034b64  ldp      x22, x21, [sp, #0x60]
0x00034b68  ldp      x24, x23, [sp, #0x50]
0x00034b6c  ldp      d9, d8, [sp, #0x40]
0x00034b70  ldp      d11, d10, [sp, #0x30]
0x00034b74  add      sp, sp, #0x90
0x00034b78  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00034b7c  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00034b80  fmov     d1, xzr
0x00034b84  fmaxnm   d0, d0, d1
0x00034b88  ldr      d1, [x0, #0x20]
0x00034b8c  fdiv     d0, d0, d1
0x00034b90  adrp     x8, #0x65000
0x00034b94  ldr      d1, [x8, #0xcf8]
0x00034b98  fcmp     d0, d1
0x00034b9c  fcsel    d0, d1, d0, gt
0x00034ba0  adrp     x8, #0x65000
0x00034ba4  ldr      d1, [x8, #0x788]
0x00034ba8  mov      x8, #0x406e000000000000
0x00034bac  fmov     d2, x8
0x00034bb0  fmadd    d0, d0, d2, d1
0x00034bb4  ret      
0x00034bb8  stp      d9, d8, [sp, #-0x20]!
0x00034bbc  stp      x29, x30, [sp, #0x10]
0x00034bc0  add      x29, sp, #0x10
0x00034bc4  mov      v8.16b, v0.16b
0x00034bc8  ldr      d9, [x0, #0x20]
0x00034bcc  adrp     x8, #0x65000
0x00034bd0  ldr      d0, [x8, #0x930]
0x00034bd4  fmul     d0, d1, d0
0x00034bd8  adrp     x8, #0x65000
0x00034bdc  ldr      d1, [x8, #0x828]
0x00034be0  fdiv     d0, d0, d1
0x00034be4  bl       #0x55b8c   ; CALL ___sincos_stret
0x00034be8  fmadd    d2, d8, d1, d9
0x00034bec  fmadd    d1, d8, d0, d9
0x00034bf0  mov      v0.16b, v2.16b
0x00034bf4  ldp      x29, x30, [sp, #0x10]
0x00034bf8  ldp      d9, d8, [sp], #0x20
0x00034bfc  ret      

=== -[SPPBubbleView render]  va=0x34c00 size=112 types={CGSize=dd}16@0:8
0x00034c00  stp      x20, x19, [sp, #-0x20]!
0x00034c04  stp      x29, x30, [sp, #0x10]
0x00034c08  add      x29, sp, #0x10
0x00034c0c  mov      x19, x0
0x00034c10  bl       #0x5d620   ; CALL objc_msgSend$style
0x00034c14  tbnz     x0, #0x3f, #0x34c38
0x00034c18  mov      x0, x19
0x00034c1c  bl       #0x5d620   ; CALL objc_msgSend$style
0x00034c20  cmp      x0, #8
0x00034c24  b.gt     #0x34c38
0x00034c28  mov      x0, x19
0x00034c2c  bl       #0x5d620   ; CALL objc_msgSend$style
0x00034c30  mov      x20, x0
0x00034c34  b        #0x34c3c
0x00034c38  mov      x20, #0
0x00034c3c  mov      x0, x19
0x00034c40  bl       #0x56b20   ; CALL objc_msgSend$builtStyle
0x00034c44  cmp      x20, x0
0x00034c48  b.eq     #0x34c58
0x00034c4c  mov      x0, x19
0x00034c50  mov      x2, x20
0x00034c54  bl       #0x56ac0   ; CALL objc_msgSend$buildStyle:
0x00034c58  mov      x0, x19
0x00034c5c  bl       #0x59ea0   ; CALL objc_msgSend$renderStyle
0x00034c60  mov      x0, x19
0x00034c64  ldp      x29, x30, [sp, #0x10]
0x00034c68  ldp      x20, x19, [sp], #0x20
0x00034c6c  b        #0x57260   ; CALL objc_msgSend$contentSize

=== -[SPPBubbleView rebuild]  va=0x34c70 size=8 types=v16@0:8
0x00034c70  mov      x2, #-1
0x00034c74  b        #0x5a780   ; CALL objc_msgSend$setBuiltStyle:

=== -[SPPBubbleView setColor:]  va=0x34c78 size=32 types=v24@0:8q16
0x00034c78  adrp     x8, #0x8e000
0x00034c7c  ldrsw    x8, [x8, #0xef0]
0x00034c80  ldr      x9, [x0, x8]
0x00034c84  cmp      x2, x9
0x00034c88  b.ne     #0x34c90
0x00034c8c  ret      
0x00034c90  str      x2, [x0, x8]
0x00034c94  b        #0x59ba0   ; CALL objc_msgSend$rebuild

=== -[SPPBubbleView style]  va=0x34c98 size=16 types=q16@0:8
0x00034c98  adrp     x8, #0x8e000
0x00034c9c  ldrsw    x8, [x8, #0xef4]
0x00034ca0  ldr      x0, [x0, x8]
0x00034ca4  ret      

=== -[SPPBubbleView setStyle:]  va=0x34ca8 size=16 types=v24@0:8q16
0x00034ca8  adrp     x8, #0x8e000
0x00034cac  ldrsw    x8, [x8, #0xef4]
0x00034cb0  str      x2, [x0, x8]
0x00034cb4  ret      

=== -[SPPBubbleView speed]  va=0x34cb8 size=16 types=i16@0:8
0x00034cb8  adrp     x8, #0x8e000
0x00034cbc  ldrsw    x8, [x8, #0xee4]
0x00034cc0  ldr      w0, [x0, x8]
0x00034cc4  ret      

=== -[SPPBubbleView setSpeed:]  va=0x34cc8 size=16 types=v20@0:8i16
0x00034cc8  adrp     x8, #0x8e000
0x00034ccc  ldrsw    x8, [x8, #0xee4]
0x00034cd0  str      w2, [x0, x8]
0x00034cd4  ret      

=== -[SPPBubbleView limit]  va=0x34cd8 size=16 types=i16@0:8
0x00034cd8  adrp     x8, #0x8e000
0x00034cdc  ldrsw    x8, [x8, #0xee8]
0x00034ce0  ldr      w0, [x0, x8]
0x00034ce4  ret      

=== -[SPPBubbleView setLimit:]  va=0x34ce8 size=16 types=v20@0:8i16
0x00034ce8  adrp     x8, #0x8e000
0x00034cec  ldrsw    x8, [x8, #0xee8]
0x00034cf0  str      w2, [x0, x8]
0x00034cf4  ret      

=== -[SPPBubbleView showIcon]  va=0x34cf8 size=16 types=B16@0:8
0x00034cf8  adrp     x8, #0x8e000
0x00034cfc  ldrsw    x8, [x8, #0xeec]
0x00034d00  ldrb     w0, [x0, x8]
0x00034d04  ret      

=== -[SPPBubbleView setShowIcon:]  va=0x34d08 size=16 types=v20@0:8B16
0x00034d08  adrp     x8, #0x8e000
0x00034d0c  ldrsw    x8, [x8, #0xeec]
0x00034d10  strb     w2, [x0, x8]
0x00034d14  ret      

=== -[SPPBubbleView iconImage]  va=0x34d18 size=16 types=@16@0:8
0x00034d18  adrp     x8, #0x8e000
0x00034d1c  ldrsw    x8, [x8, #0xef8]
0x00034d20  ldr      x0, [x0, x8]
0x00034d24  ret      

=== -[SPPBubbleView setIconImage:]  va=0x34d28 size=64 types=v24@0:8@16
0x00034d28  stp      x22, x21, [sp, #-0x30]!
0x00034d2c  stp      x20, x19, [sp, #0x10]
0x00034d30  stp      x29, x30, [sp, #0x20]
0x00034d34  add      x29, sp, #0x20
0x00034d38  mov      x19, x2
0x00034d3c  mov      x20, x0
0x00034d40  adrp     x8, #0x8e000
0x00034d44  ldrsw    x21, [x8, #0xef8]
0x00034d48  mov      x0, x2
0x00034d4c  bl       #0x55d84   ; CALL _objc_retain
0x00034d50  ldr      x0, [x20, x21]
0x00034d54  str      x19, [x20, x21]
0x00034d58  ldp      x29, x30, [sp, #0x20]
0x00034d5c  ldp      x20, x19, [sp, #0x10]
0x00034d60  ldp      x22, x21, [sp], #0x30
0x00034d64  b        #0x55d78   ; CALL _objc_release

=== -[SPPBubbleView color]  va=0x34d68 size=16 types=q16@0:8
0x00034d68  adrp     x8, #0x8e000
0x00034d6c  ldrsw    x8, [x8, #0xef0]
0x00034d70  ldr      x0, [x0, x8]
0x00034d74  ret      

=== -[SPPBubbleView log]  va=0x34d78 size=16 types=@?16@0:8
0x00034d78  adrp     x8, #0x8e000
0x00034d7c  ldrsw    x8, [x8, #0xefc]
0x00034d80  ldr      x0, [x0, x8]
0x00034d84  ret      

=== -[SPPBubbleView setLog:]  va=0x34d88 size=12 types=v24@0:8@?16
0x00034d88  adrp     x8, #0x8e000
0x00034d8c  ldrsw    x3, [x8, #0xefc]
0x00034d90  b        #0x55dc0   ; CALL _objc_setProperty_nonatomic_copy

=== -[SPPBubbleView builtStyle]  va=0x34d94 size=16 types=q16@0:8
0x00034d94  adrp     x8, #0x8e000
0x00034d98  ldrsw    x8, [x8, #0xee0]
0x00034d9c  ldr      x0, [x0, x8]
0x00034da0  ret      

=== -[SPPBubbleView setBuiltStyle:]  va=0x34da4 size=16 types=v24@0:8q16
0x00034da4  adrp     x8, #0x8e000
0x00034da8  ldrsw    x8, [x8, #0xee0]
0x00034dac  str      x2, [x0, x8]
0x00034db0  ret      

=== -[SPPBubbleView outlineRect]  va=0x34db4 size=24 types={CGRect={CGPoint=dd}{CGSize=dd}}16@0:8
0x00034db4  adrp     x8, #0x8e000
0x00034db8  ldrsw    x8, [x8, #0xf00]
0x00034dbc  add      x8, x0, x8
0x00034dc0  ldp      d0, d1, [x8]
0x00034dc4  ldp      d2, d3, [x8, #0x10]
0x00034dc8  ret      

=== -[SPPBubbleView setOutlineRect:]  va=0x34dcc size=24 types=v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
0x00034dcc  adrp     x8, #0x8e000
0x00034dd0  ldrsw    x8, [x8, #0xf00]
0x00034dd4  add      x8, x0, x8
0x00034dd8  stp      d0, d1, [x8]
0x00034ddc  stp      d2, d3, [x8, #0x10]
0x00034de0  ret      

=== -[SPPBubbleView outlineCorner]  va=0x34de4 size=16 types=d16@0:8
0x00034de4  adrp     x8, #0x8e000
0x00034de8  ldrsw    x8, [x8, #0xf04]
0x00034dec  ldr      d0, [x0, x8]
0x00034df0  ret      

=== -[SPPBubbleView setOutlineCorner:]  va=0x34df4 size=16 types=v24@0:8d16
0x00034df4  adrp     x8, #0x8e000
0x00034df8  ldrsw    x8, [x8, #0xf04]
0x00034dfc  str      d0, [x0, x8]
0x00034e00  ret      

=== -[SPPBubbleView speedLabel]  va=0x34e04 size=16 types=@16@0:8
0x00034e04  adrp     x8, #0x8e000
0x00034e08  ldrsw    x8, [x8, #0xf08]
0x00034e0c  ldr      x0, [x0, x8]
0x00034e10  ret      

=== -[SPPBubbleView setSpeedLabel:]  va=0x34e14 size=64 types=v24@0:8@16
0x00034e14  stp      x22, x21, [sp, #-0x30]!
0x00034e18  stp      x20, x19, [sp, #0x10]
0x00034e1c  stp      x29, x30, [sp, #0x20]
0x00034e20  add      x29, sp, #0x20
0x00034e24  mov      x19, x2
0x00034e28  mov      x20, x0
0x00034e2c  adrp     x8, #0x8e000
0x00034e30  ldrsw    x21, [x8, #0xf08]
0x00034e34  mov      x0, x2
0x00034e38  bl       #0x55d84   ; CALL _objc_retain
0x00034e3c  ldr      x0, [x20, x21]
0x00034e40  str      x19, [x20, x21]
0x00034e44  ldp      x29, x30, [sp, #0x20]
0x00034e48  ldp      x20, x19, [sp, #0x10]
0x00034e4c  ldp      x22, x21, [sp], #0x30
0x00034e50  b        #0x55d78   ; CALL _objc_release

=== -[SPPBubbleView contentSize]  va=0x34e54 size=20 types={CGSize=dd}16@0:8
0x00034e54  adrp     x8, #0x8e000
0x00034e58  ldrsw    x8, [x8, #0xf0c]
0x00034e5c  add      x8, x0, x8
0x00034e60  ldp      d0, d1, [x8]
0x00034e64  ret      

=== -[SPPBubbleView setContentSize:]  va=0x34e68 size=20 types=v32@0:8{CGSize=dd}16
0x00034e68  adrp     x8, #0x8e000
0x00034e6c  ldrsw    x8, [x8, #0xf0c]
0x00034e70  add      x8, x0, x8
0x00034e74  stp      d0, d1, [x8]
0x00034e78  ret      

=== -[SPPBubbleView glass]  va=0x34e7c size=16 types=@16@0:8
0x00034e7c  adrp     x8, #0x8e000
0x00034e80  ldrsw    x8, [x8, #0xf10]
0x00034e84  ldr      x0, [x0, x8]
0x00034e88  ret      

=== -[SPPBubbleView setGlass:]  va=0x34e8c size=64 types=v24@0:8@16
0x00034e8c  stp      x22, x21, [sp, #-0x30]!
0x00034e90  stp      x20, x19, [sp, #0x10]
0x00034e94  stp      x29, x30, [sp, #0x20]
0x00034e98  add      x29, sp, #0x20
0x00034e9c  mov      x19, x2
0x00034ea0  mov      x20, x0
0x00034ea4  adrp     x8, #0x8e000
0x00034ea8  ldrsw    x21, [x8, #0xf10]
0x00034eac  mov      x0, x2
0x00034eb0  bl       #0x55d84   ; CALL _objc_retain
0x00034eb4  ldr      x0, [x20, x21]
0x00034eb8  str      x19, [x20, x21]
0x00034ebc  ldp      x29, x30, [sp, #0x20]
0x00034ec0  ldp      x20, x19, [sp, #0x10]
0x00034ec4  ldp      x22, x21, [sp], #0x30
0x00034ec8  b        #0x55d78   ; CALL _objc_release

=== -[SPPBubbleView iconView]  va=0x34ecc size=16 types=@16@0:8
0x00034ecc  adrp     x8, #0x8e000
0x00034ed0  ldrsw    x8, [x8, #0xf14]
0x00034ed4  ldr      x0, [x0, x8]
0x00034ed8  ret      

=== -[SPPBubbleView setIconView:]  va=0x34edc size=64 types=v24@0:8@16
0x00034edc  stp      x22, x21, [sp, #-0x30]!
0x00034ee0  stp      x20, x19, [sp, #0x10]
0x00034ee4  stp      x29, x30, [sp, #0x20]
0x00034ee8  add      x29, sp, #0x20
0x00034eec  mov      x19, x2
0x00034ef0  mov      x20, x0
0x00034ef4  adrp     x8, #0x8e000
0x00034ef8  ldrsw    x21, [x8, #0xf14]
0x00034efc  mov      x0, x2
0x00034f00  bl       #0x55d84   ; CALL _objc_retain
0x00034f04  ldr      x0, [x20, x21]
0x00034f08  str      x19, [x20, x21]
0x00034f0c  ldp      x29, x30, [sp, #0x20]
0x00034f10  ldp      x20, x19, [sp, #0x10]
0x00034f14  ldp      x22, x21, [sp], #0x30
0x00034f18  b        #0x55d78   ; CALL _objc_release

=== -[SPPBubbleView sign]  va=0x34f1c size=16 types=@16@0:8
0x00034f1c  adrp     x8, #0x8e000
0x00034f20  ldrsw    x8, [x8, #0xf18]
0x00034f24  ldr      x0, [x0, x8]
0x00034f28  ret      

=== -[SPPBubbleView setSign:]  va=0x34f2c size=64 types=v24@0:8@16
0x00034f2c  stp      x22, x21, [sp, #-0x30]!
0x00034f30  stp      x20, x19, [sp, #0x10]
0x00034f34  stp      x29, x30, [sp, #0x20]
0x00034f38  add      x29, sp, #0x20
0x00034f3c  mov      x19, x2
0x00034f40  mov      x20, x0
0x00034f44  adrp     x8, #0x8e000
0x00034f48  ldrsw    x21, [x8, #0xf18]
0x00034f4c  mov      x0, x2
0x00034f50  bl       #0x55d84   ; CALL _objc_retain
0x00034f54  ldr      x0, [x20, x21]
0x00034f58  str      x19, [x20, x21]
0x00034f5c  ldp      x29, x30, [sp, #0x20]
0x00034f60  ldp      x20, x19, [sp, #0x10]
0x00034f64  ldp      x22, x21, [sp], #0x30
0x00034f68  b        #0x55d78   ; CALL _objc_release

=== -[SPPBubbleView unitLabel]  va=0x34f6c size=16 types=@16@0:8
0x00034f6c  adrp     x8, #0x8e000
0x00034f70  ldrsw    x8, [x8, #0xf1c]
0x00034f74  ldr      x0, [x0, x8]
0x00034f78  ret      

=== -[SPPBubbleView setUnitLabel:]  va=0x34f7c size=64 types=v24@0:8@16
0x00034f7c  stp      x22, x21, [sp, #-0x30]!
0x00034f80  stp      x20, x19, [sp, #0x10]
0x00034f84  stp      x29, x30, [sp, #0x20]
0x00034f88  add      x29, sp, #0x20
0x00034f8c  mov      x19, x2
0x00034f90  mov      x20, x0
0x00034f94  adrp     x8, #0x8e000
0x00034f98  ldrsw    x21, [x8, #0xf1c]
0x00034f9c  mov      x0, x2
0x00034fa0  bl       #0x55d84   ; CALL _objc_retain
0x00034fa4  ldr      x0, [x20, x21]
0x00034fa8  str      x19, [x20, x21]
0x00034fac  ldp      x29, x30, [sp, #0x20]
0x00034fb0  ldp      x20, x19, [sp, #0x10]
0x00034fb4  ldp      x22, x21, [sp], #0x30
0x00034fb8  b        #0x55d78   ; CALL _objc_release

=== -[SPPBubbleView deco]  va=0x34fbc size=16 types=@16@0:8
0x00034fbc  adrp     x8, #0x8e000
0x00034fc0  ldrsw    x8, [x8, #0xf20]
0x00034fc4  ldr      x0, [x0, x8]
0x00034fc8  ret      

=== -[SPPBubbleView setDeco:]  va=0x34fcc size=64 types=v24@0:8@16
0x00034fcc  stp      x22, x21, [sp, #-0x30]!
0x00034fd0  stp      x20, x19, [sp, #0x10]
0x00034fd4  stp      x29, x30, [sp, #0x20]
0x00034fd8  add      x29, sp, #0x20
0x00034fdc  mov      x19, x2
0x00034fe0  mov      x20, x0
0x00034fe4  adrp     x8, #0x8e000
0x00034fe8  ldrsw    x21, [x8, #0xf20]
0x00034fec  mov      x0, x2
0x00034ff0  bl       #0x55d84   ; CALL _objc_retain
0x00034ff4  ldr      x0, [x20, x21]
0x00034ff8  str      x19, [x20, x21]
0x00034ffc  ldp      x29, x30, [sp, #0x20]
0x00035000  ldp      x20, x19, [sp, #0x10]
0x00035004  ldp      x22, x21, [sp], #0x30
0x00035008  b        #0x55d78   ; CALL _objc_release

=== -[SPPBubbleView parts]  va=0x3500c size=16 types=@16@0:8
0x0003500c  adrp     x8, #0x8e000
0x00035010  ldrsw    x8, [x8, #0xf24]
0x00035014  ldr      x0, [x0, x8]
0x00035018  ret      

=== -[SPPBubbleView setParts:]  va=0x3501c size=64 types=v24@0:8@16
0x0003501c  stp      x22, x21, [sp, #-0x30]!
0x00035020  stp      x20, x19, [sp, #0x10]
0x00035024  stp      x29, x30, [sp, #0x20]
0x00035028  add      x29, sp, #0x20
0x0003502c  mov      x19, x2
0x00035030  mov      x20, x0
0x00035034  adrp     x8, #0x8e000
0x00035038  ldrsw    x21, [x8, #0xf24]
0x0003503c  mov      x0, x2
0x00035040  bl       #0x55d84   ; CALL _objc_retain
0x00035044  ldr      x0, [x20, x21]
0x00035048  str      x19, [x20, x21]
0x0003504c  ldp      x29, x30, [sp, #0x20]
0x00035050  ldp      x20, x19, [sp, #0x10]
0x00035054  ldp      x22, x21, [sp], #0x30
0x00035058  b        #0x55d78   ; CALL _objc_release

=== -[SPPBubbleView bits]  va=0x3505c size=16 types=@16@0:8
0x0003505c  adrp     x8, #0x8e000
0x00035060  ldrsw    x8, [x8, #0xf28]
0x00035064  ldr      x0, [x0, x8]
0x00035068  ret      

=== -[SPPBubbleView setBits:]  va=0x3506c size=64 types=v24@0:8@16
0x0003506c  stp      x22, x21, [sp, #-0x30]!
0x00035070  stp      x20, x19, [sp, #0x10]
0x00035074  stp      x29, x30, [sp, #0x20]
0x00035078  add      x29, sp, #0x20
0x0003507c  mov      x19, x2
0x00035080  mov      x20, x0
0x00035084  adrp     x8, #0x8e000
0x00035088  ldrsw    x21, [x8, #0xf28]
0x0003508c  mov      x0, x2
0x00035090  bl       #0x55d84   ; CALL _objc_retain
0x00035094  ldr      x0, [x20, x21]
0x00035098  str      x19, [x20, x21]
0x0003509c  ldp      x29, x30, [sp, #0x20]
0x000350a0  ldp      x20, x19, [sp, #0x10]
0x000350a4  ldp      x22, x21, [sp], #0x30
0x000350a8  b        #0x55d78   ; CALL _objc_release

=== -[SPPBubbleView tickLabels]  va=0x350ac size=16 types=@16@0:8
0x000350ac  adrp     x8, #0x8e000
0x000350b0  ldrsw    x8, [x8, #0xf2c]
0x000350b4  ldr      x0, [x0, x8]
0x000350b8  ret      

=== -[SPPBubbleView setTickLabels:]  va=0x350bc size=64 types=v24@0:8@16
0x000350bc  stp      x22, x21, [sp, #-0x30]!
0x000350c0  stp      x20, x19, [sp, #0x10]
0x000350c4  stp      x29, x30, [sp, #0x20]
0x000350c8  add      x29, sp, #0x20
0x000350cc  mov      x19, x2
0x000350d0  mov      x20, x0
0x000350d4  adrp     x8, #0x8e000
0x000350d8  ldrsw    x21, [x8, #0xf2c]
0x000350dc  mov      x0, x2
0x000350e0  bl       #0x55d84   ; CALL _objc_retain
0x000350e4  ldr      x0, [x20, x21]
0x000350e8  str      x19, [x20, x21]
0x000350ec  ldp      x29, x30, [sp, #0x20]
0x000350f0  ldp      x20, x19, [sp, #0x10]
0x000350f4  ldp      x22, x21, [sp], #0x30
0x000350f8  b        #0x55d78   ; CALL _objc_release

=== -[SPPBubbleView flashView]  va=0x350fc size=16 types=@16@0:8
0x000350fc  adrp     x8, #0x8e000
0x00035100  ldrsw    x8, [x8, #0xf30]
0x00035104  ldr      x0, [x0, x8]
0x00035108  ret      

=== -[SPPBubbleView setFlashView:]  va=0x3510c size=64 types=v24@0:8@16
0x0003510c  stp      x22, x21, [sp, #-0x30]!
0x00035110  stp      x20, x19, [sp, #0x10]
0x00035114  stp      x29, x30, [sp, #0x20]
0x00035118  add      x29, sp, #0x20
0x0003511c  mov      x19, x2
0x00035120  mov      x20, x0
0x00035124  adrp     x8, #0x8e000
0x00035128  ldrsw    x21, [x8, #0xf30]
0x0003512c  mov      x0, x2
0x00035130  bl       #0x55d84   ; CALL _objc_retain
0x00035134  ldr      x0, [x20, x21]
0x00035138  str      x19, [x20, x21]
0x0003513c  ldp      x29, x30, [sp, #0x20]
0x00035140  ldp      x20, x19, [sp, #0x10]
0x00035144  ldp      x22, x21, [sp], #0x30
0x00035148  b        #0x55d78   ; CALL _objc_release

=== -[SPPBubbleView .cxx_destruct]  va=0x3514c size=352 types=v16@0:8
0x0003514c  stp      x20, x19, [sp, #-0x20]!
0x00035150  stp      x29, x30, [sp, #0x10]
0x00035154  add      x29, sp, #0x10
0x00035158  mov      x19, x0
0x0003515c  adrp     x8, #0x8e000
0x00035160  ldrsw    x8, [x8, #0xf30]
0x00035164  add      x0, x0, x8
0x00035168  mov      x1, #0
0x0003516c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00035170  adrp     x8, #0x8e000
0x00035174  ldrsw    x8, [x8, #0xf2c]
0x00035178  add      x0, x19, x8
0x0003517c  mov      x1, #0
0x00035180  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00035184  adrp     x8, #0x8e000
0x00035188  ldrsw    x8, [x8, #0xf28]
0x0003518c  add      x0, x19, x8
0x00035190  mov      x1, #0
0x00035194  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00035198  adrp     x8, #0x8e000
0x0003519c  ldrsw    x8, [x8, #0xf24]
0x000351a0  add      x0, x19, x8
0x000351a4  mov      x1, #0
0x000351a8  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000351ac  adrp     x8, #0x8e000
0x000351b0  ldrsw    x8, [x8, #0xf20]
0x000351b4  add      x0, x19, x8
0x000351b8  mov      x1, #0
0x000351bc  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000351c0  adrp     x8, #0x8e000
0x000351c4  ldrsw    x8, [x8, #0xf1c]
0x000351c8  add      x0, x19, x8
0x000351cc  mov      x1, #0
0x000351d0  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000351d4  adrp     x8, #0x8e000
0x000351d8  ldrsw    x8, [x8, #0xf18]
0x000351dc  add      x0, x19, x8
0x000351e0  mov      x1, #0
0x000351e4  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000351e8  adrp     x8, #0x8e000
0x000351ec  ldrsw    x8, [x8, #0xf14]
0x000351f0  add      x0, x19, x8
0x000351f4  mov      x1, #0
0x000351f8  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000351fc  adrp     x8, #0x8e000
0x00035200  ldrsw    x8, [x8, #0xf10]
0x00035204  add      x0, x19, x8
0x00035208  mov      x1, #0
0x0003520c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00035210  adrp     x8, #0x8e000
0x00035214  ldrsw    x8, [x8, #0xf08]
0x00035218  add      x0, x19, x8
0x0003521c  mov      x1, #0
0x00035220  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00035224  adrp     x8, #0x8e000
0x00035228  ldrsw    x8, [x8, #0xefc]
0x0003522c  add      x0, x19, x8
0x00035230  mov      x1, #0
0x00035234  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00035238  adrp     x8, #0x8e000
0x0003523c  ldrsw    x8, [x8, #0xef8]
0x00035240  add      x0, x19, x8
0x00035244  mov      x1, #0
0x00035248  ldp      x29, x30, [sp, #0x10]
0x0003524c  ldp      x20, x19, [sp], #0x20
0x00035250  b        #0x55dcc   ; CALL _objc_storeStrong
0x00035254  stp      d9, d8, [sp, #-0x30]!
0x00035258  stp      x20, x19, [sp, #0x10]
0x0003525c  stp      x29, x30, [sp, #0x20]
0x00035260  add      x29, sp, #0x20
0x00035264  mov      x19, x0
0x00035268  ldr      d8, [x0, #0x28]
0x0003526c  ldr      x0, [x0, #0x20]
0x00035270  bl       #0x5d740   ; CALL objc_msgSend$superview
0x00035274  mov      x29, x29
0x00035278  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003527c  mov      x20, x0
0x00035280  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00035284  ldr      x0, [x19, #0x20]
0x00035288  fmov     d0, xzr
0x0003528c  fmov     d1, xzr
0x00035290  mov      v2.16b, v8.16b
0x00035294  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00035298  mov      x0, x20
0x0003529c  ldp      x29, x30, [sp, #0x20]
0x000352a0  ldp      x20, x19, [sp, #0x10]
0x000352a4  ldp      d9, d8, [sp], #0x30
0x000352a8  b        #0x55d78   ; CALL _objc_release
