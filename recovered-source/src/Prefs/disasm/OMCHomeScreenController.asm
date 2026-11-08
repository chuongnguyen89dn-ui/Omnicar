=== -[OMCHomeScreenController layoutPage]  va=0x24b40 size=4244 types=B16@0:8
0x00024b40  mov      w0, #1
0x00024b44  ret      
0x00024b48  sub      sp, sp, #0x90
0x00024b4c  stp      d11, d10, [sp, #0x30]
0x00024b50  stp      d9, d8, [sp, #0x40]
0x00024b54  stp      x24, x23, [sp, #0x50]
0x00024b58  stp      x22, x21, [sp, #0x60]
0x00024b5c  stp      x20, x19, [sp, #0x70]
0x00024b60  stp      x29, x30, [sp, #0x80]
0x00024b64  add      x29, sp, #0x80
0x00024b68  mov      x20, x1
0x00024b6c  mov      x19, x0
0x00024b70  adrp     x8, #0x74000
0x00024b74  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00024b78  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00024b7c  str      x8, [sp, #0x28]
0x00024b80  adrp     x8, #0x8e000
0x00024b84  ldr      x21, [x8, #0xac0]   ; @CLASS UIBezierPath
0x00024b88  ldr      d8, [x0, #0x38]
0x00024b8c  adrp     x8, #0x65000
0x00024b90  ldr      d0, [x8, #0x730]
0x00024b94  fmul     d9, d8, d0
0x00024b98  mov      x0, x1
0x00024b9c  bl       #0x55d84   ; CALL _objc_retain
0x00024ba0  fmov     d0, xzr
0x00024ba4  fmov     d1, xzr
0x00024ba8  mov      x0, x21
0x00024bac  mov      v2.16b, v8.16b
0x00024bb0  mov      v3.16b, v8.16b
0x00024bb4  mov      v4.16b, v9.16b
0x00024bb8  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x00024bbc  mov      x29, x29
0x00024bc0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00024bc4  mov      x21, x0
0x00024bc8  bl       #0x560a0   ; CALL objc_msgSend$addClip
0x00024bcc  mov      x0, x21
0x00024bd0  bl       #0x55d78   ; CALL _objc_release
0x00024bd4  bl       #0x558d4   ; CALL _CGColorSpaceCreateDeviceRGB
0x00024bd8  mov      x21, x0
0x00024bdc  ldr      x0, [x19, #0x20]
0x00024be0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00024be4  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00024be8  str      x0, [sp, #0x18]
0x00024bec  ldr      x0, [x19, #0x28]
0x00024bf0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00024bf4  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00024bf8  str      x0, [sp, #0x20]
0x00024bfc  adrp     x8, #0x8e000
0x00024c00  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00024c04  add      x2, sp, #0x18
0x00024c08  mov      w3, #2
0x00024c0c  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00024c10  mov      x1, x0
0x00024c14  adrp     x8, #0x65000
0x00024c18  ldr      q0, [x8, #0x940]
0x00024c1c  str      q0, [sp]
0x00024c20  mov      x2, sp
0x00024c24  mov      x0, x21
0x00024c28  bl       #0x559dc   ; CALL _CGGradientCreateWithColors
0x00024c2c  mov      x22, x0
0x00024c30  mov      x0, x20
0x00024c34  bl       #0x55ea0   ; CALL objc_msgSend$CGContext
0x00024c38  mov      x23, x0
0x00024c3c  mov      x0, x20
0x00024c40  bl       #0x55d78   ; CALL _objc_release
0x00024c44  ldr      d3, [x19, #0x38]
0x00024c48  adrp     x8, #0x74000
0x00024c4c  ldr      x8, [x8, #0x5c8]   ; @GOT _CGPointZero
0x00024c50  ldp      d0, d1, [x8]
0x00024c54  fmov     d2, xzr
0x00024c58  mov      x0, x23
0x00024c5c  mov      x1, x22
0x00024c60  mov      w2, #0
0x00024c64  bl       #0x5591c   ; CALL _CGContextDrawLinearGradient
0x00024c68  mov      x0, x22
0x00024c6c  bl       #0x559e8   ; CALL _CGGradientRelease
0x00024c70  mov      x0, x21
0x00024c74  bl       #0x558ec   ; CALL _CGColorSpaceRelease
0x00024c78  ldr      x20, [x19, #0x30]
0x00024c7c  ldr      d8, [x19, #0x38]
0x00024c80  mov      x0, x20
0x00024c84  bl       #0x5cba0   ; CALL objc_msgSend$size
0x00024c88  fsub     d0, d8, d0
0x00024c8c  fmov     d9, #0.50000000
0x00024c90  fmul     d8, d0, d9
0x00024c94  ldr      d10, [x19, #0x38]
0x00024c98  ldr      x0, [x19, #0x30]
0x00024c9c  bl       #0x5cba0   ; CALL objc_msgSend$size
0x00024ca0  fsub     d0, d10, d1
0x00024ca4  fmul     d9, d0, d9
0x00024ca8  ldr      x0, [x19, #0x30]
0x00024cac  bl       #0x5cba0   ; CALL objc_msgSend$size
0x00024cb0  mov      v10.16b, v0.16b
0x00024cb4  ldr      x0, [x19, #0x30]
0x00024cb8  bl       #0x5cba0   ; CALL objc_msgSend$size
0x00024cbc  mov      v3.16b, v1.16b
0x00024cc0  mov      x0, x20
0x00024cc4  mov      v0.16b, v8.16b
0x00024cc8  mov      v1.16b, v9.16b
0x00024ccc  mov      v2.16b, v10.16b
0x00024cd0  bl       #0x578e0   ; CALL objc_msgSend$drawInRect:
0x00024cd4  ldr      x8, [sp, #0x28]
0x00024cd8  adrp     x9, #0x74000
0x00024cdc  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00024ce0  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00024ce4  cmp      x9, x8
0x00024ce8  b.ne     #0x24d0c
0x00024cec  ldp      x29, x30, [sp, #0x80]
0x00024cf0  ldp      x20, x19, [sp, #0x70]
0x00024cf4  ldp      x22, x21, [sp, #0x60]
0x00024cf8  ldp      x24, x23, [sp, #0x50]
0x00024cfc  ldp      d9, d8, [sp, #0x40]
0x00024d00  ldp      d11, d10, [sp, #0x30]
0x00024d04  add      sp, sp, #0x90
0x00024d08  ret      
0x00024d0c  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00024d10  stp      x20, x19, [sp, #-0x20]!
0x00024d14  stp      x29, x30, [sp, #0x10]
0x00024d18  add      x29, sp, #0x10
0x00024d1c  mov      x19, x0
0x00024d20  adrp     x8, #0x8e000
0x00024d24  ldr      x0, [x8, #0xac0]   ; @CLASS UIBezierPath
0x00024d28  ldr      d2, [x19, #0x28]
0x00024d2c  adrp     x8, #0x65000
0x00024d30  ldr      d0, [x8, #0x730]
0x00024d34  fmul     d4, d2, d0
0x00024d38  fmov     d0, xzr
0x00024d3c  fmov     d1, xzr
0x00024d40  mov      v3.16b, v2.16b
0x00024d44  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x00024d48  mov      x29, x29
0x00024d4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00024d50  mov      x20, x0
0x00024d54  bl       #0x560a0   ; CALL objc_msgSend$addClip
0x00024d58  mov      x0, x20
0x00024d5c  bl       #0x55d78   ; CALL _objc_release
0x00024d60  ldr      x0, [x19, #0x20]
0x00024d64  ldr      d2, [x19, #0x28]
0x00024d68  fmov     d0, xzr
0x00024d6c  fmov     d1, xzr
0x00024d70  mov      v3.16b, v2.16b
0x00024d74  ldp      x29, x30, [sp, #0x10]
0x00024d78  ldp      x20, x19, [sp], #0x20
0x00024d7c  b        #0x578e0   ; CALL objc_msgSend$drawInRect:
0x00024d80  stp      x22, x21, [sp, #-0x30]!
0x00024d84  stp      x20, x19, [sp, #0x10]
0x00024d88  stp      x29, x30, [sp, #0x20]
0x00024d8c  add      x29, sp, #0x20
0x00024d90  mov      x20, x1
0x00024d94  mov      x19, x0
0x00024d98  bl       #0x55d84   ; CALL _objc_retain
0x00024d9c  mov      x0, x20
0x00024da0  bl       #0x55d84   ; CALL _objc_retain
0x00024da4  cbz      x19, #0x24de4
0x00024da8  mov      x0, x20
0x00024dac  bl       #0x55b08   ; CALL _NSSelectorFromString
0x00024db0  mov      x1, x0
0x00024db4  mov      x0, x19
0x00024db8  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x00024dbc  tbz      w0, #0, #0x24de4
0x00024dc0  mov      x0, x20
0x00024dc4  bl       #0x55b08   ; CALL _NSSelectorFromString
0x00024dc8  mov      x1, x0
0x00024dcc  mov      x0, x19
0x00024dd0  bl       #0x55d30   ; CALL _objc_msgSend
0x00024dd4  mov      x29, x29
0x00024dd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00024ddc  mov      x21, x0
0x00024de0  b        #0x24de8
0x00024de4  mov      x21, #0
0x00024de8  mov      x0, x20
0x00024dec  bl       #0x55d78   ; CALL _objc_release
0x00024df0  mov      x0, x19
0x00024df4  bl       #0x55d78   ; CALL _objc_release
0x00024df8  mov      x0, x21
0x00024dfc  ldp      x29, x30, [sp, #0x20]
0x00024e00  ldp      x20, x19, [sp, #0x10]
0x00024e04  ldp      x22, x21, [sp], #0x30
0x00024e08  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00024e0c  stp      x22, x21, [sp, #-0x30]!
0x00024e10  stp      x20, x19, [sp, #0x10]
0x00024e14  stp      x29, x30, [sp, #0x20]
0x00024e18  add      x29, sp, #0x20
0x00024e1c  mov      x20, x1
0x00024e20  mov      x19, x0
0x00024e24  bl       #0x55d84   ; CALL _objc_retain
0x00024e28  mov      x0, x20
0x00024e2c  bl       #0x55d84   ; CALL _objc_retain
0x00024e30  cbz      x19, #0x24e68
0x00024e34  mov      x0, x20
0x00024e38  bl       #0x55b08   ; CALL _NSSelectorFromString
0x00024e3c  mov      x1, x0
0x00024e40  mov      x0, x19
0x00024e44  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x00024e48  tbz      w0, #0, #0x24e68
0x00024e4c  mov      x0, x20
0x00024e50  bl       #0x55b08   ; CALL _NSSelectorFromString
0x00024e54  mov      x1, x0
0x00024e58  mov      x0, x19
0x00024e5c  bl       #0x55d30   ; CALL _objc_msgSend
0x00024e60  mov      x21, x0
0x00024e64  b        #0x24e6c
0x00024e68  mov      w21, #0
0x00024e6c  mov      x0, x20
0x00024e70  bl       #0x55d78   ; CALL _objc_release
0x00024e74  mov      x0, x19
0x00024e78  bl       #0x55d78   ; CALL _objc_release
0x00024e7c  mov      x0, x21
0x00024e80  ldp      x29, x30, [sp, #0x20]
0x00024e84  ldp      x20, x19, [sp, #0x10]
0x00024e88  ldp      x22, x21, [sp], #0x30
0x00024e8c  ret      
0x00024e90  sub      sp, sp, #0x1f0
0x00024e94  stp      x28, x27, [sp, #0x190]
0x00024e98  stp      x26, x25, [sp, #0x1a0]
0x00024e9c  stp      x24, x23, [sp, #0x1b0]
0x00024ea0  stp      x22, x21, [sp, #0x1c0]
0x00024ea4  stp      x20, x19, [sp, #0x1d0]
0x00024ea8  stp      x29, x30, [sp, #0x1e0]
0x00024eac  add      x29, sp, #0x1e0
0x00024eb0  mov      x19, x0
0x00024eb4  adrp     x8, #0x74000
0x00024eb8  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00024ebc  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00024ec0  stur     x8, [x29, #-0x60]
0x00024ec4  bl       #0x55d84   ; CALL _objc_retain
0x00024ec8  adrp     x1, #0x79000
0x00024ecc  add      x1, x1, #0xe68   ; STR "entitlements"
0x00024ed0  mov      x0, x19
0x00024ed4  bl       #0x24d80
0x00024ed8  mov      x29, x29
0x00024edc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00024ee0  mov      x20, x0
0x00024ee4  adrp     x8, #0x8e000
0x00024ee8  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00024eec  bl       #0x55d48   ; CALL _objc_opt_class
0x00024ef0  mov      x1, x0
0x00024ef4  mov      x0, x20
0x00024ef8  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00024efc  tbz      w0, #0, #0x24fc8
0x00024f00  mov      x0, x20
0x00024f04  bl       #0x573c0   ; CALL objc_msgSend$count
0x00024f08  cbz      x0, #0x24fc8
0x00024f0c  movi     v0.16b, #0
0x00024f10  stp      q0, q0, [sp, #0x60]
0x00024f14  stp      q0, q0, [sp, #0x40]
0x00024f18  mov      x0, x20
0x00024f1c  bl       #0x55d84   ; CALL _objc_retain
0x00024f20  add      x2, sp, #0x40
0x00024f24  sub      x3, x29, #0xe0
0x00024f28  mov      x0, x20
0x00024f2c  mov      w4, #0x10
0x00024f30  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00024f34  mov      x23, x0
0x00024f38  cbz      x0, #0x24fc0
0x00024f3c  ldr      x8, [sp, #0x50]
0x00024f40  ldr      x25, [x8]   ; @SEL "whatsNewNavigationController"
0x00024f44  adrp     x21, #0x79000
0x00024f48  add      x21, x21, #0xe88   ; STR "com.apple.developer.carplay"
0x00024f4c  adrp     x22, #0x79000
0x00024f50  add      x22, x22, #0xea8   ; STR "com.apple.developer.playable-content"
0x00024f54  mov      x26, #0
0x00024f58  ldr      x8, [sp, #0x50]
0x00024f5c  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00024f60  cmp      x8, x25
0x00024f64  b.eq     #0x24f70
0x00024f68  mov      x0, x20
0x00024f6c  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00024f70  ldr      x8, [sp, #0x48]
0x00024f74  ldr      x24, [x8, x26, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00024f78  mov      x0, x24
0x00024f7c  mov      x2, x21
0x00024f80  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x00024f84  tbnz     w0, #0, #0x250ec
0x00024f88  mov      x0, x24
0x00024f8c  mov      x2, x22
0x00024f90  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00024f94  tbnz     w0, #0, #0x250ec
0x00024f98  add      x26, x26, #1
0x00024f9c  cmp      x23, x26
0x00024fa0  b.ne     #0x24f58
0x00024fa4  add      x2, sp, #0x40
0x00024fa8  sub      x3, x29, #0xe0
0x00024fac  mov      x0, x20
0x00024fb0  mov      w4, #0x10
0x00024fb4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00024fb8  mov      x23, x0
0x00024fbc  cbnz     x0, #0x24f54
0x00024fc0  mov      w21, #0
0x00024fc4  b        #0x250f0
0x00024fc8  adrp     x0, #0x79000
0x00024fcc  add      x0, x0, #0xec8   ; STR "entitlementValueForKey:ofClass:"
0x00024fd0  bl       #0x55b08   ; CALL _NSSelectorFromString
0x00024fd4  mov      x21, x0
0x00024fd8  mov      x0, x19
0x00024fdc  mov      x1, x21
0x00024fe0  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x00024fe4  tbz      w0, #0, #0x250dc
0x00024fe8  movi     v0.16b, #0
0x00024fec  stp      q0, q0, [sp, #0x20]
0x00024ff0  stp      q0, q0, [sp]
0x00024ff4  adrp     x0, #0x7f000
0x00024ff8  add      x0, x0, #0xa98
0x00024ffc  mov      x2, sp
0x00025000  add      x3, sp, #0x80
0x00025004  mov      w4, #0x10
0x00025008  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0002500c  mov      x22, x0
0x00025010  cbz      x0, #0x250dc
0x00025014  ldr      x8, [sp, #0x10]
0x00025018  ldr      x26, [x8]   ; @CSTR "whatsNewNavigationController"
0x0002501c  adrp     x27, #0x8e000
0x00025020  adrp     x23, #0x74000
0x00025024  ldr      x23, [x23, #0x1b0]   ; @GOT ___kCFBooleanFalse
0x00025028  adrp     x24, #0x7f000
0x0002502c  add      x24, x24, #0xa98
0x00025030  mov      x28, #0
0x00025034  ldr      x8, [sp, #0x10]
0x00025038  ldr      x8, [x8]   ; @CSTR "whatsNewNavigationController"
0x0002503c  cmp      x8, x26
0x00025040  b.eq     #0x2504c
0x00025044  mov      x0, x24
0x00025048  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0002504c  ldr      x8, [sp, #8]
0x00025050  ldr      x25, [x8, x28, lsl #3]
0x00025054  ldr      x0, [x27, #0xb88]   ; @CLASS NSObject
0x00025058  bl       #0x55d48   ; CALL _objc_opt_class
0x0002505c  mov      x3, x0
0x00025060  mov      x0, x19
0x00025064  mov      x1, x21
0x00025068  mov      x2, x25
0x0002506c  bl       #0x55d30   ; CALL _objc_msgSend
0x00025070  mov      x29, x29
0x00025074  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025078  mov      x25, x0
0x0002507c  cbz      x0, #0x25090
0x00025080  mov      x0, x25
0x00025084  mov      x2, x23
0x00025088  bl       #0x587e0   ; CALL objc_msgSend$isEqual:
0x0002508c  tbz      w0, #0, #0x250e4
0x00025090  mov      x0, x25
0x00025094  bl       #0x55d78   ; CALL _objc_release
0x00025098  add      x28, x28, #1
0x0002509c  cmp      x22, x28
0x000250a0  b.ne     #0x25034
0x000250a4  b        #0x250c0
0x000250a8  cmp      w1, #1
0x000250ac  b.ne     #0x2514c
0x000250b0  bl       #0x55cc4   ; CALL _objc_begin_catch
0x000250b4  bl       #0x55ce8   ; CALL _objc_end_catch
0x000250b8  mov      x25, #0
0x000250bc  b        #0x25090
0x000250c0  mov      x2, sp
0x000250c4  add      x3, sp, #0x80
0x000250c8  mov      x0, x24
0x000250cc  mov      w4, #0x10
0x000250d0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000250d4  mov      x22, x0
0x000250d8  cbnz     x0, #0x25030
0x000250dc  mov      w21, #0
0x000250e0  b        #0x250fc
0x000250e4  mov      w21, #1
0x000250e8  b        #0x250f4
0x000250ec  mov      w21, #1
0x000250f0  mov      x25, x20
0x000250f4  mov      x0, x25
0x000250f8  bl       #0x55d78   ; CALL _objc_release
0x000250fc  mov      x0, x20
0x00025100  bl       #0x55d78   ; CALL _objc_release
0x00025104  mov      x0, x19
0x00025108  bl       #0x55d78   ; CALL _objc_release
0x0002510c  ldur     x8, [x29, #-0x60]
0x00025110  adrp     x9, #0x74000
0x00025114  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00025118  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0002511c  cmp      x9, x8
0x00025120  b.ne     #0x25148
0x00025124  mov      x0, x21
0x00025128  ldp      x29, x30, [sp, #0x1e0]
0x0002512c  ldp      x20, x19, [sp, #0x1d0]
0x00025130  ldp      x22, x21, [sp, #0x1c0]
0x00025134  ldp      x24, x23, [sp, #0x1b0]
0x00025138  ldp      x26, x25, [sp, #0x1a0]
0x0002513c  ldp      x28, x27, [sp, #0x190]
0x00025140  add      sp, sp, #0x1f0
0x00025144  ret      
0x00025148  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0002514c  bl       #0x55b80   ; CALL __Unwind_Resume
0x00025150  sub      sp, sp, #0x160
0x00025154  stp      d9, d8, [sp, #0x100]
0x00025158  stp      x28, x27, [sp, #0x110]
0x0002515c  stp      x24, x23, [sp, #0x120]
0x00025160  stp      x22, x21, [sp, #0x130]
0x00025164  stp      x20, x19, [sp, #0x140]
0x00025168  stp      x29, x30, [sp, #0x150]
0x0002516c  add      x29, sp, #0x150
0x00025170  mov      x20, x0
0x00025174  adrp     x8, #0x74000
0x00025178  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0002517c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00025180  stur     x8, [x29, #-0x58]
0x00025184  mov      x0, x1
0x00025188  bl       #0x55ea0   ; CALL objc_msgSend$CGContext
0x0002518c  mov      x19, x0
0x00025190  ldr      x8, [x20, #0x20]
0x00025194  adrp     x23, #0x8e000
0x00025198  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0002519c  cmp      x8, #2
0x000251a0  b.le     #0x252a8
0x000251a4  cmp      x8, #3
0x000251a8  b.eq     #0x253e8
0x000251ac  cmp      x8, #4
0x000251b0  b.eq     #0x25508
0x000251b4  cmp      x8, #5
0x000251b8  b.ne     #0x256e4
0x000251bc  adrp     x8, #0x65000
0x000251c0  ldr      d0, [x8, #0x800]
0x000251c4  adrp     x8, #0x65000
0x000251c8  ldr      d1, [x8, #0x808]
0x000251cc  adrp     x8, #0x65000
0x000251d0  ldr      d2, [x8, #0x6a8]
0x000251d4  fmov     d3, #1.00000000
0x000251d8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000251dc  mov      x29, x29
0x000251e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000251e4  mov      x21, x0
0x000251e8  str      x0, [sp, #0x30]
0x000251ec  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x000251f0  adrp     x8, #0x65000
0x000251f4  ldr      d0, [x8, #0x810]
0x000251f8  adrp     x8, #0x65000
0x000251fc  ldr      d1, [x8, #0x818]
0x00025200  adrp     x8, #0x65000
0x00025204  ldr      d2, [x8, #0x820]
0x00025208  fmov     d3, #1.00000000
0x0002520c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00025210  mov      x29, x29
0x00025214  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025218  mov      x22, x0
0x0002521c  str      x0, [sp, #0x38]
0x00025220  adrp     x8, #0x8e000
0x00025224  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00025228  add      x2, sp, #0x30
0x0002522c  mov      w3, #2
0x00025230  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00025234  mov      x29, x29
0x00025238  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002523c  mov      x23, x0
0x00025240  adrp     x8, #0x65000
0x00025244  ldr      q0, [x8, #0x940]
0x00025248  str      q0, [sp, #0x20]
0x0002524c  ldp      d0, d1, [x20, #0x28]
0x00025250  adrp     x8, #0x65000
0x00025254  ldr      d2, [x8, #0x828]
0x00025258  add      x2, sp, #0x20
0x0002525c  mov      x0, x19
0x00025260  mov      x1, x23
0x00025264  bl       #0x257e4
0x00025268  mov      x0, x23
0x0002526c  bl       #0x55d78   ; CALL _objc_release
0x00025270  mov      x0, x22
0x00025274  bl       #0x55d78   ; CALL _objc_release
0x00025278  mov      x0, x21
0x0002527c  bl       #0x55d78   ; CALL _objc_release
0x00025280  ldp      d0, d1, [x20, #0x28]
0x00025284  adrp     x8, #0x65000
0x00025288  ldr      d3, [x8, #0x830]
0x0002528c  adrp     x8, #0x65000
0x00025290  ldr      d4, [x8, #0x838]
0x00025294  fmov     d2, #0.50000000
0x00025298  mov      x0, x19
0x0002529c  mov      w1, #0x7e5f
0x000252a0  movk     w1, #0xff, lsl #16
0x000252a4  b        #0x25500
0x000252a8  cmp      x8, #1
0x000252ac  b.eq     #0x255ec
0x000252b0  cmp      x8, #2
0x000252b4  b.ne     #0x256e4
0x000252b8  adrp     x8, #0x65000
0x000252bc  ldr      d1, [x8, #0x7e8]
0x000252c0  adrp     x8, #0x65000
0x000252c4  ldr      d2, [x8, #0x7a8]
0x000252c8  fmov     d0, #1.00000000
0x000252cc  fmov     d3, #1.00000000
0x000252d0  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000252d4  mov      x29, x29
0x000252d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000252dc  mov      x21, x0
0x000252e0  str      x0, [sp, #0xa8]
0x000252e4  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x000252e8  adrp     x8, #0x65000
0x000252ec  ldr      d0, [x8, #0x8b0]
0x000252f0  adrp     x8, #0x65000
0x000252f4  ldr      d1, [x8, #0x658]
0x000252f8  adrp     x8, #0x65000
0x000252fc  ldr      d2, [x8, #0x8b8]
0x00025300  fmov     d3, #1.00000000
0x00025304  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00025308  mov      x29, x29
0x0002530c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025310  mov      x22, x0
0x00025314  str      x0, [sp, #0xb0]
0x00025318  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0002531c  adrp     x8, #0x65000
0x00025320  ldr      d0, [x8, #0x8c0]
0x00025324  adrp     x8, #0x65000
0x00025328  ldr      d1, [x8, #0x808]
0x0002532c  adrp     x8, #0x65000
0x00025330  ldr      d2, [x8, #0x8c8]
0x00025334  fmov     d3, #1.00000000
0x00025338  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002533c  mov      x29, x29
0x00025340  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025344  mov      x23, x0
0x00025348  str      x0, [sp, #0xb8]
0x0002534c  adrp     x8, #0x8e000
0x00025350  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00025354  add      x2, sp, #0xa8
0x00025358  mov      w3, #3
0x0002535c  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00025360  mov      x29, x29
0x00025364  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025368  mov      x24, x0
0x0002536c  mov      x8, #0x3ff0000000000000
0x00025370  str      x8, [sp, #0xa0]
0x00025374  adrp     x8, #0x65000
0x00025378  add      x8, x8, #0x968
0x0002537c  ldr      q0, [x8]
0x00025380  str      q0, [sp, #0x90]
0x00025384  ldp      d0, d1, [x20, #0x28]
0x00025388  mov      x8, #0x4064000000000000
0x0002538c  fmov     d2, x8
0x00025390  add      x2, sp, #0x90
0x00025394  mov      x0, x19
0x00025398  mov      x1, x24
0x0002539c  bl       #0x257e4
0x000253a0  mov      x0, x24
0x000253a4  bl       #0x55d78   ; CALL _objc_release
0x000253a8  mov      x0, x23
0x000253ac  bl       #0x55d78   ; CALL _objc_release
0x000253b0  mov      x0, x22
0x000253b4  bl       #0x55d78   ; CALL _objc_release
0x000253b8  mov      x0, x21
0x000253bc  bl       #0x55d78   ; CALL _objc_release
0x000253c0  ldp      d0, d1, [x20, #0x28]
0x000253c4  adrp     x8, #0x65000
0x000253c8  ldr      d2, [x8, #0x608]
0x000253cc  adrp     x8, #0x65000
0x000253d0  ldr      d3, [x8, #0x728]
0x000253d4  fmov     d4, #0.50000000
0x000253d8  mov      x0, x19
0x000253dc  mov      w1, #0xd29d
0x000253e0  movk     w1, #0xf9, lsl #16
0x000253e4  b        #0x25500
0x000253e8  adrp     x8, #0x65000
0x000253ec  ldr      d0, [x8, #0x880]
0x000253f0  adrp     x8, #0x65000
0x000253f4  ldr      d1, [x8, #0x7d0]
0x000253f8  adrp     x8, #0x65000
0x000253fc  ldr      d2, [x8, #0x888]
0x00025400  fmov     d3, #1.00000000
0x00025404  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00025408  mov      x29, x29
0x0002540c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025410  mov      x21, x0
0x00025414  str      x0, [sp, #0x80]
0x00025418  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0002541c  adrp     x8, #0x65000
0x00025420  ldr      d0, [x8, #0x890]
0x00025424  adrp     x8, #0x65000
0x00025428  ldr      d1, [x8, #0x898]
0x0002542c  adrp     x8, #0x65000
0x00025430  ldr      d2, [x8, #0x8a0]
0x00025434  fmov     d3, #1.00000000
0x00025438  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002543c  mov      x29, x29
0x00025440  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025444  mov      x22, x0
0x00025448  str      x0, [sp, #0x88]
0x0002544c  adrp     x8, #0x8e000
0x00025450  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00025454  add      x2, sp, #0x80
0x00025458  mov      w3, #2
0x0002545c  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00025460  mov      x29, x29
0x00025464  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025468  mov      x23, x0
0x0002546c  adrp     x8, #0x65000
0x00025470  ldr      q0, [x8, #0x940]
0x00025474  str      q0, [sp, #0x70]
0x00025478  ldp      d0, d1, [x20, #0x28]
0x0002547c  adrp     x8, #0x65000
0x00025480  ldr      d2, [x8, #0x8a8]
0x00025484  add      x2, sp, #0x70
0x00025488  mov      x0, x19
0x0002548c  mov      x1, x23
0x00025490  bl       #0x257e4
0x00025494  mov      x0, x23
0x00025498  bl       #0x55d78   ; CALL _objc_release
0x0002549c  mov      x0, x22
0x000254a0  bl       #0x55d78   ; CALL _objc_release
0x000254a4  mov      x0, x21
0x000254a8  bl       #0x55d78   ; CALL _objc_release
0x000254ac  ldp      d0, d1, [x20, #0x28]
0x000254b0  adrp     x8, #0x65000
0x000254b4  ldr      d2, [x8, #0x728]
0x000254b8  adrp     x8, #0x65000
0x000254bc  ldr      d3, [x8, #0x670]
0x000254c0  adrp     x8, #0x65000
0x000254c4  ldr      d8, [x8, #0x6c0]
0x000254c8  mov      x0, x19
0x000254cc  mov      w1, #0xf1d9
0x000254d0  movk     w1, #0xa0, lsl #16
0x000254d4  mov      v4.16b, v8.16b
0x000254d8  bl       #0x259ec
0x000254dc  ldp      d0, d1, [x20, #0x28]
0x000254e0  adrp     x8, #0x65000
0x000254e4  ldr      d2, [x8, #0x700]
0x000254e8  adrp     x8, #0x65000
0x000254ec  ldr      d3, [x8, #0x608]
0x000254f0  mov      x0, x19
0x000254f4  mov      w1, #0xbaff
0x000254f8  movk     w1, #0xc9, lsl #16
0x000254fc  mov      v4.16b, v8.16b
0x00025500  bl       #0x259ec
0x00025504  b        #0x257a8
0x00025508  adrp     x8, #0x65000
0x0002550c  ldr      d0, [x8, #0x840]
0x00025510  adrp     x8, #0x65000
0x00025514  ldr      d8, [x8, #0x848]
0x00025518  adrp     x8, #0x65000
0x0002551c  ldr      d2, [x8, #0x850]
0x00025520  fmov     d3, #1.00000000
0x00025524  mov      v1.16b, v8.16b
0x00025528  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002552c  mov      x29, x29
0x00025530  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025534  mov      x21, x0
0x00025538  str      x0, [sp, #0x58]
0x0002553c  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x00025540  adrp     x8, #0x65000
0x00025544  ldr      d1, [x8, #0x858]
0x00025548  adrp     x8, #0x65000
0x0002554c  ldr      d2, [x8, #0x860]
0x00025550  fmov     d3, #1.00000000
0x00025554  mov      v0.16b, v8.16b
0x00025558  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002555c  mov      x29, x29
0x00025560  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025564  mov      x22, x0
0x00025568  str      x0, [sp, #0x60]
0x0002556c  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x00025570  adrp     x8, #0x65000
0x00025574  ldr      d0, [x8, #0x868]
0x00025578  adrp     x8, #0x65000
0x0002557c  ldr      d1, [x8, #0x870]
0x00025580  adrp     x8, #0x65000
0x00025584  ldr      d2, [x8, #0x878]
0x00025588  fmov     d3, #1.00000000
0x0002558c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00025590  mov      x29, x29
0x00025594  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025598  mov      x23, x0
0x0002559c  str      x0, [sp, #0x68]
0x000255a0  adrp     x8, #0x8e000
0x000255a4  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000255a8  add      x2, sp, #0x58
0x000255ac  mov      w3, #3
0x000255b0  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000255b4  mov      x29, x29
0x000255b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000255bc  mov      x24, x0
0x000255c0  mov      x8, #0x3ff0000000000000
0x000255c4  str      x8, [sp, #0x50]
0x000255c8  adrp     x8, #0x65000
0x000255cc  add      x8, x8, #0x980
0x000255d0  ldr      q0, [x8]
0x000255d4  str      q0, [sp, #0x40]
0x000255d8  ldp      d0, d1, [x20, #0x28]
0x000255dc  adrp     x8, #0x65000
0x000255e0  ldr      d2, [x8, #0x828]
0x000255e4  add      x2, sp, #0x40
0x000255e8  b        #0x256cc
0x000255ec  adrp     x8, #0x65000
0x000255f0  ldr      d0, [x8, #0x8d0]
0x000255f4  adrp     x8, #0x65000
0x000255f8  ldr      d1, [x8, #0x650]
0x000255fc  adrp     x8, #0x65000
0x00025600  ldr      d2, [x8, #0x8d8]
0x00025604  fmov     d3, #1.00000000
0x00025608  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002560c  mov      x29, x29
0x00025610  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025614  mov      x21, x0
0x00025618  stur     x0, [x29, #-0x70]
0x0002561c  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x00025620  adrp     x8, #0x65000
0x00025624  ldr      d0, [x8, #0x810]
0x00025628  adrp     x8, #0x65000
0x0002562c  ldr      d1, [x8, #0x8e0]
0x00025630  adrp     x8, #0x65000
0x00025634  ldr      d2, [x8, #0x8e8]
0x00025638  fmov     d3, #1.00000000
0x0002563c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00025640  mov      x29, x29
0x00025644  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025648  mov      x22, x0
0x0002564c  stur     x0, [x29, #-0x68]
0x00025650  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x00025654  adrp     x8, #0x65000
0x00025658  ldr      d0, [x8, #0x8f0]
0x0002565c  adrp     x8, #0x65000
0x00025660  ldr      d1, [x8, #0x8f8]
0x00025664  adrp     x8, #0x65000
0x00025668  ldr      d2, [x8, #0x900]
0x0002566c  fmov     d3, #1.00000000
0x00025670  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00025674  mov      x29, x29
0x00025678  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002567c  mov      x23, x0
0x00025680  stur     x0, [x29, #-0x60]
0x00025684  adrp     x8, #0x8e000
0x00025688  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0002568c  sub      x2, x29, #0x70
0x00025690  mov      w3, #3
0x00025694  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00025698  mov      x29, x29
0x0002569c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000256a0  mov      x24, x0
0x000256a4  mov      x8, #0x3ff0000000000000
0x000256a8  stur     x8, [x29, #-0x80]
0x000256ac  adrp     x8, #0x65000
0x000256b0  add      x8, x8, #0x950
0x000256b4  ldr      q0, [x8]
0x000256b8  stur     q0, [x29, #-0x90]
0x000256bc  ldp      d0, d1, [x20, #0x28]
0x000256c0  mov      x8, #0x4064000000000000
0x000256c4  fmov     d2, x8
0x000256c8  sub      x2, x29, #0x90
0x000256cc  mov      x0, x19
0x000256d0  mov      x1, x24
0x000256d4  bl       #0x257e4
0x000256d8  mov      x0, x24
0x000256dc  bl       #0x55d78   ; CALL _objc_release
0x000256e0  b        #0x25790
0x000256e4  adrp     x8, #0x65000
0x000256e8  ldr      d0, [x8, #0x908]
0x000256ec  adrp     x8, #0x65000
0x000256f0  ldr      d1, [x8, #0x910]
0x000256f4  adrp     x8, #0x65000
0x000256f8  ldr      d2, [x8, #0x7c8]
0x000256fc  fmov     d3, #1.00000000
0x00025700  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00025704  mov      x29, x29
0x00025708  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002570c  mov      x21, x0
0x00025710  str      x0, [sp, #0x10]
0x00025714  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x00025718  adrp     x8, #0x65000
0x0002571c  ldr      d0, [x8, #0x918]
0x00025720  adrp     x8, #0x65000
0x00025724  ldr      d1, [x8, #0x920]
0x00025728  adrp     x8, #0x65000
0x0002572c  ldr      d2, [x8, #0x928]
0x00025730  fmov     d3, #1.00000000
0x00025734  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00025738  mov      x29, x29
0x0002573c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025740  mov      x22, x0
0x00025744  str      x0, [sp, #0x18]
0x00025748  adrp     x8, #0x8e000
0x0002574c  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00025750  add      x2, sp, #0x10
0x00025754  mov      w3, #2
0x00025758  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0002575c  mov      x29, x29
0x00025760  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025764  mov      x23, x0
0x00025768  adrp     x8, #0x65000
0x0002576c  ldr      q0, [x8, #0x940]
0x00025770  str      q0, [sp]
0x00025774  ldp      d0, d1, [x20, #0x28]
0x00025778  mov      x8, #0x4064000000000000
0x0002577c  fmov     d2, x8
0x00025780  mov      x2, sp
0x00025784  mov      x0, x19
0x00025788  mov      x1, x23
0x0002578c  bl       #0x257e4
0x00025790  mov      x0, x23
0x00025794  bl       #0x55d78   ; CALL _objc_release
0x00025798  mov      x0, x22
0x0002579c  bl       #0x55d78   ; CALL _objc_release
0x000257a0  mov      x0, x21
0x000257a4  bl       #0x55d78   ; CALL _objc_release
0x000257a8  ldur     x8, [x29, #-0x58]
0x000257ac  adrp     x9, #0x74000
0x000257b0  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000257b4  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000257b8  cmp      x9, x8
0x000257bc  b.ne     #0x257e0
0x000257c0  ldp      x29, x30, [sp, #0x150]
0x000257c4  ldp      x20, x19, [sp, #0x140]
0x000257c8  ldp      x22, x21, [sp, #0x130]
0x000257cc  ldp      x24, x23, [sp, #0x120]
0x000257d0  ldp      x28, x27, [sp, #0x110]
0x000257d4  ldp      d9, d8, [sp, #0x100]
0x000257d8  add      sp, sp, #0x160
0x000257dc  ret      
0x000257e0  bl       #0x55b98   ; CALL ___stack_chk_fail
0x000257e4  sub      sp, sp, #0x160
0x000257e8  stp      d15, d14, [sp, #0xd0]
0x000257ec  stp      d13, d12, [sp, #0xe0]
0x000257f0  stp      d11, d10, [sp, #0xf0]
0x000257f4  stp      d9, d8, [sp, #0x100]
0x000257f8  stp      x26, x25, [sp, #0x110]
0x000257fc  stp      x24, x23, [sp, #0x120]
0x00025800  stp      x22, x21, [sp, #0x130]
0x00025804  stp      x20, x19, [sp, #0x140]
0x00025808  stp      x29, x30, [sp, #0x150]
0x0002580c  add      x29, sp, #0x150
0x00025810  mov      x22, x2
0x00025814  mov      x19, x1
0x00025818  mov      v10.16b, v2.16b
0x0002581c  mov      v8.16b, v1.16b
0x00025820  mov      v9.16b, v0.16b
0x00025824  mov      x21, x0
0x00025828  adrp     x8, #0x74000
0x0002582c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00025830  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00025834  stur     x8, [x29, #-0x88]
0x00025838  mov      x0, x1
0x0002583c  bl       #0x55d84   ; CALL _objc_retain
0x00025840  adrp     x8, #0x8e000
0x00025844  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00025848  bl       #0x565c0   ; CALL objc_msgSend$array
0x0002584c  mov      x29, x29
0x00025850  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025854  mov      x20, x0
0x00025858  movi     v0.16b, #0
0x0002585c  stp      q0, q0, [sp]
0x00025860  stp      q0, q0, [sp, #0x20]
0x00025864  mov      x0, x19
0x00025868  bl       #0x55d84   ; CALL _objc_retain
0x0002586c  mov      x2, sp
0x00025870  add      x3, sp, #0x48
0x00025874  mov      x0, x19
0x00025878  mov      w4, #0x10
0x0002587c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00025880  cbz      x0, #0x258f0
0x00025884  mov      x23, x0
0x00025888  ldr      x8, [sp, #0x10]
0x0002588c  ldr      x24, [x8]   ; @SEL "whatsNewNavigationController"
0x00025890  mov      x25, #0
0x00025894  ldr      x8, [sp, #0x10]
0x00025898  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0002589c  cmp      x8, x24
0x000258a0  b.eq     #0x258ac
0x000258a4  mov      x0, x19
0x000258a8  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x000258ac  ldr      x8, [sp, #8]
0x000258b0  ldr      x0, [x8, x25, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x000258b4  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000258b8  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000258bc  mov      x2, x0
0x000258c0  mov      x0, x20
0x000258c4  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x000258c8  add      x25, x25, #1   ; CSTR "hatsNewNavigationController"
0x000258cc  cmp      x23, x25
0x000258d0  b.ne     #0x25894
0x000258d4  mov      x2, sp
0x000258d8  add      x3, sp, #0x48
0x000258dc  mov      x0, x19
0x000258e0  mov      w4, #0x10
0x000258e4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000258e8  mov      x23, x0
0x000258ec  cbnz     x0, #0x25890
0x000258f0  fmov     d12, #0.50000000
0x000258f4  fmul     d13, d8, d12
0x000258f8  fmul     d14, d9, d12
0x000258fc  adrp     x8, #0x65000
0x00025900  ldr      d0, [x8, #0x930]
0x00025904  fmul     d0, d10, d0
0x00025908  adrp     x8, #0x65000
0x0002590c  ldr      d1, [x8, #0x828]
0x00025910  fdiv     d0, d0, d1
0x00025914  bl       #0x55b8c   ; CALL ___sincos_stret
0x00025918  mov      v10.16b, v0.16b
0x0002591c  mov      v11.16b, v1.16b
0x00025920  fmul     d0, d9, d0
0x00025924  fabs     d0, d0
0x00025928  fnmul    d1, d1, d8
0x0002592c  fabs     d1, d1
0x00025930  fadd     d8, d0, d1
0x00025934  mov      x0, x19
0x00025938  bl       #0x55d78   ; CALL _objc_release
0x0002593c  bl       #0x558d4   ; CALL _CGColorSpaceCreateDeviceRGB
0x00025940  mov      x23, x0
0x00025944  mov      x1, x20
0x00025948  mov      x2, x22
0x0002594c  bl       #0x559dc   ; CALL _CGGradientCreateWithColors
0x00025950  mov      x22, x0
0x00025954  fmul     d0, d10, d8
0x00025958  fmul     d2, d0, d12
0x0002595c  fsub     d0, d14, d2
0x00025960  fnmul    d1, d11, d8
0x00025964  fmul     d3, d1, d12
0x00025968  fadd     d1, d13, d3
0x0002596c  fadd     d2, d14, d2
0x00025970  fsub     d3, d13, d3
0x00025974  mov      x0, x21
0x00025978  mov      x1, x22
0x0002597c  mov      w2, #3
0x00025980  bl       #0x5591c   ; CALL _CGContextDrawLinearGradient
0x00025984  mov      x0, x22
0x00025988  bl       #0x559e8   ; CALL _CGGradientRelease
0x0002598c  mov      x0, x23
0x00025990  bl       #0x558ec   ; CALL _CGColorSpaceRelease
0x00025994  mov      x0, x20
0x00025998  bl       #0x55d78   ; CALL _objc_release
0x0002599c  mov      x0, x19
0x000259a0  bl       #0x55d78   ; CALL _objc_release
0x000259a4  ldur     x8, [x29, #-0x88]
0x000259a8  adrp     x9, #0x74000
0x000259ac  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000259b0  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000259b4  cmp      x9, x8
0x000259b8  b.ne     #0x259e8
0x000259bc  ldp      x29, x30, [sp, #0x150]
0x000259c0  ldp      x20, x19, [sp, #0x140]
0x000259c4  ldp      x22, x21, [sp, #0x130]
0x000259c8  ldp      x24, x23, [sp, #0x120]
0x000259cc  ldp      x26, x25, [sp, #0x110]
0x000259d0  ldp      d9, d8, [sp, #0x100]
0x000259d4  ldp      d11, d10, [sp, #0xf0]
0x000259d8  ldp      d13, d12, [sp, #0xe0]
0x000259dc  ldp      d15, d14, [sp, #0xd0]
0x000259e0  add      sp, sp, #0x160
0x000259e4  ret      
0x000259e8  bl       #0x55b98   ; CALL ___stack_chk_fail
0x000259ec  sub      sp, sp, #0xb0
0x000259f0  stp      d15, d14, [sp, #0x30]
0x000259f4  stp      d13, d12, [sp, #0x40]
0x000259f8  stp      d11, d10, [sp, #0x50]
0x000259fc  stp      d9, d8, [sp, #0x60]
0x00025a00  stp      x24, x23, [sp, #0x70]
0x00025a04  stp      x22, x21, [sp, #0x80]
0x00025a08  stp      x20, x19, [sp, #0x90]
0x00025a0c  stp      x29, x30, [sp, #0xa0]
0x00025a10  add      x29, sp, #0xa0
0x00025a14  mov      v10.16b, v4.16b
0x00025a18  mov      x21, x1
0x00025a1c  mov      v11.16b, v1.16b
0x00025a20  mov      v12.16b, v0.16b
0x00025a24  mov      x19, x0
0x00025a28  mov      w20, #0
0x00025a2c  adrp     x8, #0x74000
0x00025a30  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00025a34  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00025a38  str      x8, [sp, #0x28]
0x00025a3c  fmul     d8, d0, d2
0x00025a40  fmul     d9, d1, d3
0x00025a44  fmov     d13, xzr
0x00025a48  fmov     d14, xzr
0x00025a4c  tst      w20, #1
0x00025a50  fcsel    d0, d13, d12, eq
0x00025a54  fsub     d0, d8, d0
0x00025a58  cmp      w20, #2
0x00025a5c  fcsel    d1, d13, d11, lo
0x00025a60  fsub     d1, d9, d1
0x00025a64  bl       #0x55c58   ; CALL _hypot
0x00025a68  fcmp     d14, d0
0x00025a6c  fcsel    d14, d0, d14, mi
0x00025a70  add      w20, w20, #1
0x00025a74  cmp      w20, #4
0x00025a78  b.ne     #0x25a4c
0x00025a7c  bl       #0x558d4   ; CALL _CGColorSpaceCreateDeviceRGB
0x00025a80  mov      x20, x0
0x00025a84  adrp     x22, #0x8e000
0x00025a88  lsr      w8, w21, #0x10
0x00025a8c  ucvtf    d0, w8
0x00025a90  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x00025a94  adrp     x8, #0x65000
0x00025a98  ldr      d1, [x8, #0x688]
0x00025a9c  ubfx     w8, w21, #8, #8
0x00025aa0  ucvtf    d2, w8
0x00025aa4  fdiv     d11, d0, d1
0x00025aa8  fdiv     d12, d2, d1
0x00025aac  and      w8, w21, #0xff
0x00025ab0  ucvtf    d0, w8
0x00025ab4  fdiv     d13, d0, d1
0x00025ab8  fmov     d3, #1.00000000
0x00025abc  mov      v0.16b, v11.16b
0x00025ac0  mov      v1.16b, v12.16b
0x00025ac4  mov      v2.16b, v13.16b
0x00025ac8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00025acc  mov      x29, x29
0x00025ad0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025ad4  mov      x21, x0
0x00025ad8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00025adc  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00025ae0  str      x0, [sp, #0x18]
0x00025ae4  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x00025ae8  fmov     d3, xzr
0x00025aec  mov      v0.16b, v11.16b
0x00025af0  mov      v1.16b, v12.16b
0x00025af4  mov      v2.16b, v13.16b
0x00025af8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00025afc  mov      x29, x29
0x00025b00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025b04  mov      x22, x0
0x00025b08  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00025b0c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00025b10  str      x0, [sp, #0x20]
0x00025b14  adrp     x8, #0x8e000
0x00025b18  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00025b1c  add      x2, sp, #0x18
0x00025b20  mov      w3, #2
0x00025b24  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00025b28  mov      x1, x0
0x00025b2c  adrp     x8, #0x65000
0x00025b30  ldr      q0, [x8, #0x940]
0x00025b34  str      q0, [sp]
0x00025b38  mov      x2, sp
0x00025b3c  mov      x0, x20
0x00025b40  bl       #0x559dc   ; CALL _CGGradientCreateWithColors
0x00025b44  mov      x23, x0
0x00025b48  mov      x0, x22
0x00025b4c  bl       #0x55d78   ; CALL _objc_release
0x00025b50  mov      x0, x21
0x00025b54  bl       #0x55d78   ; CALL _objc_release
0x00025b58  fmul     d5, d10, d14
0x00025b5c  fmov     d2, xzr
0x00025b60  mov      x0, x19
0x00025b64  mov      x1, x23
0x00025b68  mov      v0.16b, v8.16b
0x00025b6c  mov      v1.16b, v9.16b
0x00025b70  mov      v3.16b, v8.16b
0x00025b74  mov      v4.16b, v9.16b
0x00025b78  mov      w2, #0
0x00025b7c  bl       #0x55928   ; CALL _CGContextDrawRadialGradient
0x00025b80  mov      x0, x23
0x00025b84  bl       #0x559e8   ; CALL _CGGradientRelease
0x00025b88  mov      x0, x20
0x00025b8c  bl       #0x558ec   ; CALL _CGColorSpaceRelease
0x00025b90  ldr      x8, [sp, #0x28]
0x00025b94  adrp     x9, #0x74000
0x00025b98  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00025b9c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00025ba0  cmp      x9, x8
0x00025ba4  b.ne     #0x25bd0
0x00025ba8  ldp      x29, x30, [sp, #0xa0]
0x00025bac  ldp      x20, x19, [sp, #0x90]
0x00025bb0  ldp      x22, x21, [sp, #0x80]
0x00025bb4  ldp      x24, x23, [sp, #0x70]
0x00025bb8  ldp      d9, d8, [sp, #0x60]
0x00025bbc  ldp      d11, d10, [sp, #0x50]
0x00025bc0  ldp      d13, d12, [sp, #0x40]
0x00025bc4  ldp      d15, d14, [sp, #0x30]
0x00025bc8  add      sp, sp, #0xb0
0x00025bcc  ret      
0x00025bd0  bl       #0x55b98   ; CALL ___stack_chk_fail
