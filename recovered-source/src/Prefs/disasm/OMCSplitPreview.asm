=== -[OMCSplitPreview initWithFrame:]  va=0x37944 size=260 types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
0x00037944  sub      sp, sp, #0x40
0x00037948  stp      x22, x21, [sp, #0x10]
0x0003794c  stp      x20, x19, [sp, #0x20]
0x00037950  stp      x29, x30, [sp, #0x30]
0x00037954  add      x29, sp, #0x30
0x00037958  adrp     x8, #0x8e000
0x0003795c  ldr      x8, [x8, #0xd98]   ; @SUPER OMCSplitPreview
0x00037960  stp      x0, x8, [sp]
0x00037964  adrp     x8, #0x8c000
0x00037968  ldr      x1, [x8, #0x8c8]   ; @SEL "initWithFrame:"
0x0003796c  mov      x0, sp
0x00037970  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00037974  mov      x19, x0
0x00037978  cbz      x0, #0x37a30
0x0003797c  adrp     x8, #0x8e000
0x00037980  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00037984  adrp     x8, #0x65000
0x00037988  ldr      d0, [x8, #0xe10]
0x0003798c  adrp     x8, #0x65000
0x00037990  ldr      d1, [x8, #0x760]
0x00037994  adrp     x8, #0x65000
0x00037998  ldr      d2, [x8, #0xe18]
0x0003799c  fmov     d3, #1.00000000
0x000379a0  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000379a4  mov      x29, x29
0x000379a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000379ac  mov      x20, x0
0x000379b0  mov      x0, x19
0x000379b4  mov      x2, x20
0x000379b8  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x000379bc  mov      x0, x20
0x000379c0  bl       #0x55d78   ; CALL _objc_release
0x000379c4  mov      x0, x19
0x000379c8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000379cc  mov      x29, x29
0x000379d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000379d4  mov      x20, x0
0x000379d8  fmov     d0, #14.00000000
0x000379dc  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x000379e0  mov      x0, x20
0x000379e4  bl       #0x55d78   ; CALL _objc_release
0x000379e8  adrp     x8, #0x74000
0x000379ec  ldr      x8, [x8, #0x648]   ; @GOT _kCACornerCurveContinuous
0x000379f0  ldr      x20, [x8]   ; @GOT ___objc_personality_v0
0x000379f4  mov      x0, x19
0x000379f8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000379fc  mov      x29, x29
0x00037a00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037a04  mov      x21, x0
0x00037a08  mov      x2, x20
0x00037a0c  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x00037a10  mov      x0, x21
0x00037a14  bl       #0x55d78   ; CALL _objc_release
0x00037a18  mov      x0, x19
0x00037a1c  mov      w2, #1
0x00037a20  bl       #0x5a8a0   ; CALL objc_msgSend$setClipsToBounds:
0x00037a24  mov      x0, x19
0x00037a28  mov      w2, #3
0x00037a2c  bl       #0x5aa40   ; CALL objc_msgSend$setContentMode:
0x00037a30  mov      x0, x19
0x00037a34  ldp      x29, x30, [sp, #0x30]
0x00037a38  ldp      x20, x19, [sp, #0x20]
0x00037a3c  ldp      x22, x21, [sp, #0x10]
0x00037a40  add      sp, sp, #0x40
0x00037a44  ret      

=== -[OMCSplitPreview drawRect:]  va=0x37a48 size=1988 types=v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
0x00037a48  sub      sp, sp, #0x170
0x00037a4c  stp      d15, d14, [sp, #0xd0]
0x00037a50  stp      d13, d12, [sp, #0xe0]
0x00037a54  stp      d11, d10, [sp, #0xf0]
0x00037a58  stp      d9, d8, [sp, #0x100]
0x00037a5c  stp      x28, x27, [sp, #0x110]
0x00037a60  stp      x26, x25, [sp, #0x120]
0x00037a64  stp      x24, x23, [sp, #0x130]
0x00037a68  stp      x22, x21, [sp, #0x140]
0x00037a6c  stp      x20, x19, [sp, #0x150]
0x00037a70  stp      x29, x30, [sp, #0x160]
0x00037a74  add      x29, sp, #0x160
0x00037a78  mov      x20, x0
0x00037a7c  adrp     x8, #0x74000
0x00037a80  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00037a84  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00037a88  stur     x8, [x29, #-0xa0]
0x00037a8c  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00037a90  mov      v9.16b, v2.16b
0x00037a94  mov      v8.16b, v3.16b
0x00037a98  adrp     x24, #0x8e000
0x00037a9c  ldr      x0, [x24, #0x910]   ; @CLASS UIColor
0x00037aa0  adrp     x8, #0x65000
0x00037aa4  ldr      d0, [x8, #0xe20]
0x00037aa8  adrp     x8, #0x65000
0x00037aac  ldr      d1, [x8, #0xe28]
0x00037ab0  adrp     x8, #0x65000
0x00037ab4  ldr      d2, [x8, #0xe30]
0x00037ab8  fmov     d3, #1.00000000
0x00037abc  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00037ac0  mov      x29, x29
0x00037ac4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037ac8  mov      x19, x0
0x00037acc  bl       #0x5ae00   ; CALL objc_msgSend$setFill
0x00037ad0  mov      x0, x19
0x00037ad4  bl       #0x55d78   ; CALL _objc_release
0x00037ad8  fmov     d0, xzr
0x00037adc  fmov     d1, xzr
0x00037ae0  fmov     d2, #30.00000000
0x00037ae4  mov      v3.16b, v8.16b
0x00037ae8  bl       #0x55b5c   ; CALL _UIRectFill
0x00037aec  adrp     x0, #0x78000
0x00037af0  add      x0, x0, #0xf28   ; STR "#8B7CFF"
0x00037af4  bl       #0x18080   ; CALL _OMCColorFromHex
0x00037af8  mov      x29, x29
0x00037afc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037b00  mov      x21, x0
0x00037b04  str      x0, [sp, #0xa8]
0x00037b08  adrp     x0, #0x7b000
0x00037b0c  add      x0, x0, #0xa88   ; STR "#2E9CF5"
0x00037b10  bl       #0x18080   ; CALL _OMCColorFromHex
0x00037b14  mov      x29, x29
0x00037b18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037b1c  mov      x22, x0
0x00037b20  str      x0, [sp, #0xb0]
0x00037b24  adrp     x0, #0x7b000
0x00037b28  add      x0, x0, #0xaa8   ; STR "#FA2D55"
0x00037b2c  bl       #0x18080   ; CALL _OMCColorFromHex
0x00037b30  mov      x29, x29
0x00037b34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037b38  mov      x23, x0
0x00037b3c  str      x0, [sp, #0xb8]
0x00037b40  adrp     x27, #0x8e000
0x00037b44  ldr      x0, [x27, #0x960]   ; @CLASS NSArray
0x00037b48  add      x2, sp, #0xa8
0x00037b4c  mov      w3, #3
0x00037b50  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00037b54  mov      x29, x29
0x00037b58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037b5c  mov      x19, x0
0x00037b60  mov      x0, x23
0x00037b64  bl       #0x55d78   ; CALL _objc_release
0x00037b68  mov      x0, x22
0x00037b6c  bl       #0x55d78   ; CALL _objc_release
0x00037b70  mov      x0, x21
0x00037b74  bl       #0x55d78   ; CALL _objc_release
0x00037b78  mov      x0, x19
0x00037b7c  bl       #0x573c0   ; CALL objc_msgSend$count
0x00037b80  adrp     x25, #0x8e000
0x00037b84  cbz      x0, #0x37c00
0x00037b88  mov      x21, #0
0x00037b8c  mov      w23, #0xa
0x00037b90  mov      x0, x19
0x00037b94  mov      x2, x21
0x00037b98  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00037b9c  mov      x29, x29
0x00037ba0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037ba4  mov      x22, x0
0x00037ba8  bl       #0x5ae00   ; CALL objc_msgSend$setFill
0x00037bac  mov      x0, x22
0x00037bb0  bl       #0x55d78   ; CALL _objc_release
0x00037bb4  ldr      x0, [x25, #0xac0]   ; @CLASS UIBezierPath
0x00037bb8  ucvtf    d1, x23
0x00037bbc  fmov     d0, #7.00000000
0x00037bc0  fmov     d2, #16.00000000
0x00037bc4  fmov     d3, #16.00000000
0x00037bc8  fmov     d4, #5.00000000
0x00037bcc  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x00037bd0  mov      x29, x29
0x00037bd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037bd8  mov      x22, x0
0x00037bdc  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x00037be0  mov      x0, x22
0x00037be4  bl       #0x55d78   ; CALL _objc_release
0x00037be8  add      x21, x21, #1
0x00037bec  mov      x0, x19
0x00037bf0  bl       #0x573c0   ; CALL objc_msgSend$count
0x00037bf4  add      x23, x23, #0x16
0x00037bf8  cmp      x21, x0
0x00037bfc  b.lo     #0x37b90
0x00037c00  mov      x0, x20
0x00037c04  bl       #0x59440   ; CALL objc_msgSend$on
0x00037c08  tbz      w0, #0, #0x37f44
0x00037c0c  add      x8, sp, #0x40
0x00037c10  add      x26, x8, #0x20   ; CSTR " ready, %@"
0x00037c14  mov      x8, #-0x3fbd000000000000
0x00037c18  fmov     d0, x8
0x00037c1c  fadd     d0, d9, d0
0x00037c20  fmov     d1, #-8.00000000
0x00037c24  fadd     d5, d8, d1
0x00037c28  fmov     d1, #-4.00000000
0x00037c2c  fadd     d2, d0, d1
0x00037c30  adrp     x8, #0x65000
0x00037c34  ldr      d3, [x8, #0xe38]
0x00037c38  fmul     d2, d2, d3
0x00037c3c  frintm   d2, d2
0x00037c40  adrp     x8, #0x65000
0x00037c44  ldr      q3, [x8, #0xe60]
0x00037c48  str      q3, [sp, #0x40]
0x00037c4c  stp      d2, d5, [sp, #0x50]
0x00037c50  mov      x8, #0x4041000000000000
0x00037c54  fmov     d3, x8
0x00037c58  fadd     d3, d2, d3
0x00037c5c  fmov     d4, #4.00000000
0x00037c60  fadd     d3, d3, d4
0x00037c64  fsub     d0, d0, d2
0x00037c68  str      d3, [sp, #0x60]
0x00037c6c  mov      x8, #0x4010000000000000
0x00037c70  str      x8, [sp, #0x68]
0x00037c74  fadd     d0, d0, d1
0x00037c78  stp      d0, d3, [sp]
0x00037c7c  stp      d0, d5, [sp, #0x70]
0x00037c80  str      d5, [sp, #0x10]
0x00037c84  mov      x0, x20
0x00037c88  bl       #0x58c00   ; CALL objc_msgSend$left
0x00037c8c  mov      x29, x29
0x00037c90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037c94  mov      x22, x0
0x00037c98  adrp     x21, #0x75000
0x00037c9c  add      x21, x21, #0xd28
0x00037ca0  cmp      x0, #0
0x00037ca4  csel     x8, x21, x0, eq
0x00037ca8  str      x8, [sp, #0x30]
0x00037cac  mov      x0, x20
0x00037cb0  bl       #0x59720   ; CALL objc_msgSend$pinned
0x00037cb4  mov      x29, x29
0x00037cb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037cbc  mov      x23, x0
0x00037cc0  cmp      x0, #0
0x00037cc4  csel     x8, x21, x0, eq
0x00037cc8  str      x8, [sp, #0x38]
0x00037ccc  ldr      x0, [x27, #0x960]   ; @CLASS NSArray
0x00037cd0  add      x2, sp, #0x30
0x00037cd4  mov      w3, #2
0x00037cd8  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00037cdc  mov      x29, x29
0x00037ce0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037ce4  mov      x21, x0
0x00037ce8  mov      x0, x23
0x00037cec  bl       #0x55d78   ; CALL _objc_release
0x00037cf0  mov      x0, x22
0x00037cf4  bl       #0x55d78   ; CALL _objc_release
0x00037cf8  mov      x22, #0
0x00037cfc  add      x28, sp, #0x40
0x00037d00  mov      w8, #1
0x00037d04  adrp     x9, #0x65000
0x00037d08  ldr      d0, [x9, #0x5f0]
0x00037d0c  str      d0, [sp, #0x28]
0x00037d10  adrp     x9, #0x65000
0x00037d14  ldr      d0, [x9, #0x6b8]
0x00037d18  str      d0, [sp, #0x20]
0x00037d1c  adrp     x9, #0x65000
0x00037d20  ldr      d0, [x9, #0xb08]
0x00037d24  str      d0, [sp, #0x18]
0x00037d28  adrp     x9, #0x65000
0x00037d2c  ldr      d11, [x9, #0x738]
0x00037d30  mov      x9, #0x4046000000000000
0x00037d34  fmov     d12, x9
0x00037d38  mov      x27, x8
0x00037d3c  ldr      x0, [x24, #0x910]   ; @CLASS UIColor
0x00037d40  fmov     d3, #1.00000000
0x00037d44  ldp      d1, d0, [sp, #0x20]
0x00037d48  ldr      d2, [sp, #0x18]
0x00037d4c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00037d50  mov      x29, x29
0x00037d54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037d58  mov      x23, x0
0x00037d5c  bl       #0x5ae00   ; CALL objc_msgSend$setFill
0x00037d60  mov      x0, x23
0x00037d64  bl       #0x55d78   ; CALL _objc_release
0x00037d68  ldr      x0, [x25, #0xac0]   ; @CLASS UIBezierPath
0x00037d6c  ldp      d14, d15, [x28]
0x00037d70  ldp      d9, d10, [x28, #0x10]
0x00037d74  fmov     d4, #10.00000000
0x00037d78  mov      v0.16b, v14.16b
0x00037d7c  mov      v1.16b, v15.16b
0x00037d80  mov      v2.16b, v9.16b
0x00037d84  mov      v3.16b, v10.16b
0x00037d88  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x00037d8c  mov      x29, x29
0x00037d90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037d94  mov      x23, x0
0x00037d98  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x00037d9c  mov      x0, x23
0x00037da0  bl       #0x55d78   ; CALL _objc_release
0x00037da4  mov      x0, x21
0x00037da8  mov      x2, x22
0x00037dac  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00037db0  mov      x29, x29
0x00037db4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037db8  mov      x23, x0
0x00037dbc  fmul     d0, d10, d11
0x00037dc0  fcmp     d0, d12
0x00037dc4  fcsel    d0, d12, d0, gt
0x00037dc8  bl       #0x380a4
0x00037dcc  mov      x29, x29
0x00037dd0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037dd4  mov      x22, x0
0x00037dd8  mov      x0, x23
0x00037ddc  bl       #0x55d78   ; CALL _objc_release
0x00037de0  cbz      x22, #0x37e64
0x00037de4  mov      v0.16b, v14.16b
0x00037de8  mov      v1.16b, v15.16b
0x00037dec  mov      v2.16b, v9.16b
0x00037df0  mov      v3.16b, v10.16b
0x00037df4  bl       #0x55a60   ; CALL _CGRectGetMidX
0x00037df8  mov      v8.16b, v0.16b
0x00037dfc  mov      x0, x22
0x00037e00  bl       #0x5cba0   ; CALL objc_msgSend$size
0x00037e04  fmov     d13, #0.50000000
0x00037e08  fmul     d0, d0, d13
0x00037e0c  fsub     d8, d8, d0
0x00037e10  mov      v0.16b, v14.16b
0x00037e14  mov      v1.16b, v15.16b
0x00037e18  mov      v2.16b, v9.16b
0x00037e1c  mov      v3.16b, v10.16b
0x00037e20  bl       #0x55a6c   ; CALL _CGRectGetMidY
0x00037e24  mov      v9.16b, v0.16b
0x00037e28  mov      x0, x22
0x00037e2c  bl       #0x5cba0   ; CALL objc_msgSend$size
0x00037e30  fmul     d0, d1, d13
0x00037e34  fsub     d9, d9, d0
0x00037e38  mov      x0, x22
0x00037e3c  bl       #0x5cba0   ; CALL objc_msgSend$size
0x00037e40  mov      v10.16b, v0.16b
0x00037e44  mov      x0, x22
0x00037e48  bl       #0x5cba0   ; CALL objc_msgSend$size
0x00037e4c  mov      v3.16b, v1.16b
0x00037e50  mov      x0, x22
0x00037e54  mov      v0.16b, v8.16b
0x00037e58  mov      v1.16b, v9.16b
0x00037e5c  mov      v2.16b, v10.16b
0x00037e60  bl       #0x578e0   ; CALL objc_msgSend$drawInRect:
0x00037e64  mov      x0, x22
0x00037e68  bl       #0x55d78   ; CALL _objc_release
0x00037e6c  mov      w8, #0
0x00037e70  mov      x28, x26
0x00037e74  mov      w22, #1
0x00037e78  tbnz     w27, #0, #0x37d38
0x00037e7c  mov      x0, x20
0x00037e80  bl       #0x59720   ; CALL objc_msgSend$pinned
0x00037e84  mov      x29, x29
0x00037e88  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037e8c  mov      x20, x0
0x00037e90  bl       #0x58c20   ; CALL objc_msgSend$length
0x00037e94  mov      x22, x0
0x00037e98  mov      x0, x20
0x00037e9c  bl       #0x55d78   ; CALL _objc_release
0x00037ea0  cbz      x22, #0x37f3c
0x00037ea4  adrp     x8, #0x8e000
0x00037ea8  ldr      x0, [x8, #0xa78]   ; @CLASS UIImage
0x00037eac  adrp     x2, #0x7b000
0x00037eb0  add      x2, x2, #0xac8   ; STR "pin.fill"
0x00037eb4  bl       #0x5d820   ; CALL objc_msgSend$systemImageNamed:
0x00037eb8  mov      x29, x29
0x00037ebc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037ec0  mov      x20, x0
0x00037ec4  adrp     x0, #0x7a000
0x00037ec8  add      x0, x0, #0xbc8   ; STR "#FFB340"
0x00037ecc  bl       #0x18080   ; CALL _OMCColorFromHex
0x00037ed0  mov      x29, x29
0x00037ed4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037ed8  mov      x22, x0
0x00037edc  mov      x0, x20
0x00037ee0  mov      x2, x22
0x00037ee4  mov      w3, #1
0x00037ee8  bl       #0x58200   ; CALL objc_msgSend$imageWithTintColor:renderingMode:
0x00037eec  mov      x29, x29
0x00037ef0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037ef4  mov      x23, x0
0x00037ef8  mov      x0, x22
0x00037efc  bl       #0x55d78   ; CALL _objc_release
0x00037f00  mov      x0, x20
0x00037f04  bl       #0x55d78   ; CALL _objc_release
0x00037f08  fmov     d1, #4.00000000
0x00037f0c  ldp      d2, d0, [sp]
0x00037f10  ldr      d3, [sp, #0x10]
0x00037f14  bl       #0x55a48   ; CALL _CGRectGetMaxX
0x00037f18  fmov     d1, #-18.00000000
0x00037f1c  fadd     d0, d0, d1
0x00037f20  fmov     d1, #10.00000000
0x00037f24  fmov     d2, #12.00000000
0x00037f28  fmov     d3, #13.00000000
0x00037f2c  mov      x0, x23
0x00037f30  bl       #0x578e0   ; CALL objc_msgSend$drawInRect:
0x00037f34  mov      x0, x23
0x00037f38  bl       #0x55d78   ; CALL _objc_release
0x00037f3c  mov      x0, x21
0x00037f40  b        #0x3804c
0x00037f44  adrp     x8, #0x74000
0x00037f48  ldr      x8, [x8, #0x1d8]   ; @GOT _NSFontAttributeName
0x00037f4c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00037f50  str      x8, [sp, #0x88]
0x00037f54  adrp     x8, #0x8e000
0x00037f58  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x00037f5c  fmov     d0, #13.00000000
0x00037f60  bl       #0x5d7c0   ; CALL objc_msgSend$systemFontOfSize:
0x00037f64  mov      x29, x29
0x00037f68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037f6c  mov      x21, x0
0x00037f70  str      x0, [sp, #0x98]
0x00037f74  adrp     x8, #0x74000
0x00037f78  ldr      x8, [x8, #0x1e0]   ; @GOT _NSForegroundColorAttributeName
0x00037f7c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00037f80  str      x8, [sp, #0x90]
0x00037f84  ldr      x0, [x24, #0x910]   ; @CLASS UIColor
0x00037f88  adrp     x8, #0x65000
0x00037f8c  ldr      d1, [x8, #0x838]
0x00037f90  fmov     d0, #1.00000000
0x00037f94  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x00037f98  mov      x29, x29
0x00037f9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037fa0  mov      x22, x0
0x00037fa4  str      x0, [sp, #0xa0]
0x00037fa8  adrp     x8, #0x8e000
0x00037fac  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00037fb0  add      x2, sp, #0x98
0x00037fb4  add      x3, sp, #0x88
0x00037fb8  mov      w4, #2
0x00037fbc  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00037fc0  mov      x29, x29
0x00037fc4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037fc8  mov      x23, x0
0x00037fcc  mov      x0, x22
0x00037fd0  bl       #0x55d78   ; CALL _objc_release
0x00037fd4  mov      x0, x21
0x00037fd8  bl       #0x55d78   ; CALL _objc_release
0x00037fdc  mov      x0, x20
0x00037fe0  bl       #0x59420   ; CALL objc_msgSend$offText
0x00037fe4  mov      x29, x29
0x00037fe8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037fec  mov      x21, x0
0x00037ff0  mov      x2, x23
0x00037ff4  bl       #0x5cc00   ; CALL objc_msgSend$sizeWithAttributes:
0x00037ff8  mov      v10.16b, v0.16b
0x00037ffc  mov      v11.16b, v1.16b
0x00038000  mov      x0, x21
0x00038004  bl       #0x55d78   ; CALL _objc_release
0x00038008  mov      x0, x20
0x0003800c  bl       #0x59420   ; CALL objc_msgSend$offText
0x00038010  mov      x29, x29
0x00038014  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038018  mov      x20, x0
0x0003801c  fsub     d0, d9, d10
0x00038020  fmov     d1, #0.50000000
0x00038024  fmul     d0, d0, d1
0x00038028  fmov     d2, #15.00000000
0x0003802c  fadd     d0, d0, d2
0x00038030  fsub     d2, d8, d11
0x00038034  fmul     d1, d2, d1
0x00038038  mov      x2, x23
0x0003803c  bl       #0x578a0   ; CALL objc_msgSend$drawAtPoint:withAttributes:
0x00038040  mov      x0, x20
0x00038044  bl       #0x55d78   ; CALL _objc_release
0x00038048  mov      x0, x23
0x0003804c  bl       #0x55d78   ; CALL _objc_release
0x00038050  mov      x0, x19
0x00038054  bl       #0x55d78   ; CALL _objc_release
0x00038058  ldur     x8, [x29, #-0xa0]
0x0003805c  adrp     x9, #0x74000
0x00038060  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00038064  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00038068  cmp      x9, x8
0x0003806c  b.ne     #0x380a0
0x00038070  ldp      x29, x30, [sp, #0x160]
0x00038074  ldp      x20, x19, [sp, #0x150]
0x00038078  ldp      x22, x21, [sp, #0x140]
0x0003807c  ldp      x24, x23, [sp, #0x130]
0x00038080  ldp      x26, x25, [sp, #0x120]
0x00038084  ldp      x28, x27, [sp, #0x110]
0x00038088  ldp      d9, d8, [sp, #0x100]
0x0003808c  ldp      d11, d10, [sp, #0xf0]
0x00038090  ldp      d13, d12, [sp, #0xe0]
0x00038094  ldp      d15, d14, [sp, #0xd0]
0x00038098  add      sp, sp, #0x170
0x0003809c  ret      
0x000380a0  bl       #0x55b98   ; CALL ___stack_chk_fail
0x000380a4  sub      sp, sp, #0x70
0x000380a8  stp      d9, d8, [sp, #0x30]
0x000380ac  stp      x22, x21, [sp, #0x40]
0x000380b0  stp      x20, x19, [sp, #0x50]
0x000380b4  stp      x29, x30, [sp, #0x60]
0x000380b8  add      x29, sp, #0x60
0x000380bc  mov      v8.16b, v0.16b
0x000380c0  mov      x19, x0
0x000380c4  bl       #0x55d84   ; CALL _objc_retain
0x000380c8  adrp     x8, #0x8e000
0x000380cc  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x000380d0  bl       #0x55d48   ; CALL _objc_opt_class
0x000380d4  mov      x1, x0
0x000380d8  mov      x0, x19
0x000380dc  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x000380e0  tbz      w0, #0, #0x381d4
0x000380e4  mov      x0, x19
0x000380e8  bl       #0x58c20   ; CALL objc_msgSend$length
0x000380ec  cbz      x0, #0x381d4
0x000380f0  adrp     x20, #0x8e000
0x000380f4  ldr      x0, [x20, #0xa78]   ; @CLASS UIImage
0x000380f8  adrp     x8, #0x8b000
0x000380fc  ldr      x1, [x8, #0xf88]   ; @SEL "_applicationIconImageForBundleIdentifier:format:scale:"
0x00038100  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x00038104  tbz      w0, #0, #0x381d4
0x00038108  ldr      x20, [x20, #0xa78]   ; @CLASS UIImage
0x0003810c  adrp     x8, #0x8e000
0x00038110  ldr      x0, [x8, #0xb40]   ; @CLASS UIScreen
0x00038114  bl       #0x58f00   ; CALL objc_msgSend$mainScreen
0x00038118  mov      x29, x29
0x0003811c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038120  mov      x21, x0
0x00038124  bl       #0x5a060   ; CALL objc_msgSend$scale
0x00038128  mov      x0, x20
0x0003812c  mov      x2, x19
0x00038130  mov      w3, #2
0x00038134  bl       #0x55f60   ; CALL objc_msgSend$_applicationIconImageForBundleIdentifier:format:scale:
0x00038138  mov      x29, x29
0x0003813c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038140  mov      x20, x0
0x00038144  mov      x0, x21
0x00038148  bl       #0x55d78   ; CALL _objc_release
0x0003814c  cbz      x20, #0x381fc
0x00038150  adrp     x8, #0x8e000
0x00038154  ldr      x0, [x8, #0xb00]   ; @CLASS UIGraphicsImageRenderer
0x00038158  bl       #0x55c7c   ; CALL _objc_alloc
0x0003815c  mov      v0.16b, v8.16b
0x00038160  mov      v1.16b, v8.16b
0x00038164  bl       #0x58540   ; CALL objc_msgSend$initWithSize:
0x00038168  mov      x22, x0
0x0003816c  adrp     x8, #0x74000
0x00038170  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00038174  str      x8, [sp]
0x00038178  adrp     x8, #0x65000
0x0003817c  ldr      d0, [x8, #0x600]
0x00038180  adrp     x8, #0x3b000
0x00038184  add      x8, x8, #0xbc4
0x00038188  str      d0, [sp, #8]
0x0003818c  adrp     x9, #0x74000
0x00038190  add      x9, x9, #0xb00
0x00038194  stp      x8, x9, [sp, #0x10]
0x00038198  str      d8, [sp, #0x28]
0x0003819c  mov      x0, x20
0x000381a0  bl       #0x55d84   ; CALL _objc_retain
0x000381a4  str      x20, [sp, #0x20]
0x000381a8  mov      x2, sp
0x000381ac  mov      x0, x22
0x000381b0  bl       #0x58140   ; CALL objc_msgSend$imageWithActions:
0x000381b4  mov      x29, x29
0x000381b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000381bc  mov      x21, x0
0x000381c0  ldr      x0, [sp, #0x20]
0x000381c4  bl       #0x55d78   ; CALL _objc_release
0x000381c8  mov      x0, x22
0x000381cc  bl       #0x55d78   ; CALL _objc_release
0x000381d0  b        #0x38200
0x000381d4  mov      x21, #0
0x000381d8  mov      x0, x19
0x000381dc  bl       #0x55d78   ; CALL _objc_release
0x000381e0  mov      x0, x21
0x000381e4  ldp      x29, x30, [sp, #0x60]
0x000381e8  ldp      x20, x19, [sp, #0x50]
0x000381ec  ldp      x22, x21, [sp, #0x40]
0x000381f0  ldp      d9, d8, [sp, #0x30]
0x000381f4  add      sp, sp, #0x70
0x000381f8  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x000381fc  mov      x21, #0
0x00038200  mov      x0, x20
0x00038204  bl       #0x55d78   ; CALL _objc_release
0x00038208  b        #0x381d8

=== -[OMCSplitPreview left]  va=0x3820c size=16 types=@16@0:8
0x0003820c  adrp     x8, #0x8e000
0x00038210  ldrsw    x8, [x8, #0xf44]
0x00038214  ldr      x0, [x0, x8]
0x00038218  ret      

=== -[OMCSplitPreview setLeft:]  va=0x3821c size=12 types=v24@0:8@16
0x0003821c  adrp     x8, #0x8e000
0x00038220  ldrsw    x3, [x8, #0xf44]
0x00038224  b        #0x55dc0   ; CALL _objc_setProperty_nonatomic_copy

=== -[OMCSplitPreview pinned]  va=0x38228 size=16 types=@16@0:8
0x00038228  adrp     x8, #0x8e000
0x0003822c  ldrsw    x8, [x8, #0xf48]
0x00038230  ldr      x0, [x0, x8]
0x00038234  ret      

=== -[OMCSplitPreview setPinned:]  va=0x38238 size=12 types=v24@0:8@16
0x00038238  adrp     x8, #0x8e000
0x0003823c  ldrsw    x3, [x8, #0xf48]
0x00038240  b        #0x55dc0   ; CALL _objc_setProperty_nonatomic_copy

=== -[OMCSplitPreview on]  va=0x38244 size=16 types=B16@0:8
0x00038244  adrp     x8, #0x8e000
0x00038248  ldrsw    x8, [x8, #0xf4c]
0x0003824c  ldrb     w0, [x0, x8]
0x00038250  ret      

=== -[OMCSplitPreview setOn:]  va=0x38254 size=16 types=v20@0:8B16
0x00038254  adrp     x8, #0x8e000
0x00038258  ldrsw    x8, [x8, #0xf4c]
0x0003825c  strb     w2, [x0, x8]
0x00038260  ret      

=== -[OMCSplitPreview offText]  va=0x38264 size=16 types=@16@0:8
0x00038264  adrp     x8, #0x8e000
0x00038268  ldrsw    x8, [x8, #0xf50]
0x0003826c  ldr      x0, [x0, x8]
0x00038270  ret      

=== -[OMCSplitPreview setOffText:]  va=0x38274 size=12 types=v24@0:8@16
0x00038274  adrp     x8, #0x8e000
0x00038278  ldrsw    x3, [x8, #0xf50]
0x0003827c  b        #0x55dc0   ; CALL _objc_setProperty_nonatomic_copy

=== -[OMCSplitPreview .cxx_destruct]  va=0x38280 size=84 types=v16@0:8
0x00038280  stp      x20, x19, [sp, #-0x20]!
0x00038284  stp      x29, x30, [sp, #0x10]
0x00038288  add      x29, sp, #0x10
0x0003828c  mov      x19, x0
0x00038290  adrp     x8, #0x8e000
0x00038294  ldrsw    x8, [x8, #0xf50]
0x00038298  add      x0, x0, x8
0x0003829c  mov      x1, #0
0x000382a0  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000382a4  adrp     x8, #0x8e000
0x000382a8  ldrsw    x8, [x8, #0xf48]
0x000382ac  add      x0, x19, x8
0x000382b0  mov      x1, #0
0x000382b4  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000382b8  adrp     x8, #0x8e000
0x000382bc  ldrsw    x8, [x8, #0xf44]
0x000382c0  add      x0, x19, x8
0x000382c4  mov      x1, #0
0x000382c8  ldp      x29, x30, [sp, #0x10]
0x000382cc  ldp      x20, x19, [sp], #0x20
0x000382d0  b        #0x55dcc   ; CALL _objc_storeStrong
