; ==== sub_119b0 @ 0x119b0..0x11ef0 (1344 bytes) ====
0x000119b0  csel     x0, x21, x21, eq
0x000119b4  bl       #0x2480c   ; call _objc_release
0x000119b8  mov      x0, x27
0x000119bc  bl       #0x2480c   ; call _objc_release
0x000119c0  mov      x0, x20
0x000119c4  bl       #0x265c0   ; objc_msgSend: popButton
0x000119c8  mov      x29, x29
0x000119cc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000119d0  mov      x21, x0
0x000119d4  cmp      w25, #0
0x000119d8  adrp     x8, #0x2b000
0x000119dc  ldr      d0, [x8, #0x268]
0x000119e0  fmov     d1, #1.00000000
0x000119e4  fcsel    d0, d0, d1, ne
0x000119e8  bl       #0x26b40   ; objc_msgSend: setAlpha:
0x000119ec  mov      x0, x21
0x000119f0  bl       #0x2480c   ; call _objc_release
0x000119f4  mov      x0, x20
0x000119f8  bl       #0x27be0   ; objc_msgSend: soloButton
0x000119fc  mov      x29, x29
0x00011a00  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011a04  mov      x25, x0
0x00011a08  adrp     x8, #0x36000
0x00011a0c  add      x8, x8, #0x310   ; -> @"hm_full"
0x00011a10  cmp      w24, #0
0x00011a14  adrp     x9, #0x36000
0x00011a18  add      x9, x9, #0x490   ; -> @"hm_split"
0x00011a1c  csel     x26, x9, x8, ne
0x00011a20  cbz      w24, #0x11a44
0x00011a24  adrp     x0, #0x36000
0x00011a28  add      x0, x0, #0x4b0   ; -> @"C"
0x00011a2c  adrp     x1, #0x36000
0x00011a30  add      x1, x1, #0x4d0   ; -> @"Split"
0x00011a34  bl       #0x23a38   ; call _OMCTr
0x00011a38  mov      x29, x29
0x00011a3c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011a40  b        #0x11a60   ; call sub_11a60
0x00011a44  adrp     x0, #0x36000
0x00011a48  add      x0, x0, #0x330   ; -> @"T"
0x00011a4c  adrp     x1, #0x36000
0x00011a50  add      x1, x1, #0x350   ; -> @"Full screen"
0x00011a54  bl       #0x23a38   ; call _OMCTr
0x00011a58  mov      x29, x29
0x00011a5c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011a60  mov      x21, x0
0x00011a64  mov      x0, x25
0x00011a68  mov      x1, x26
0x00011a6c  mov      x2, x21
0x00011a70  bl       #0x11cd8   ; call sub_11cd8
0x00011a74  cmp      w24, #0
0x00011a78  csel     x0, x21, x21, ne
0x00011a7c  bl       #0x2480c   ; call _objc_release
0x00011a80  mov      x0, x25
0x00011a84  bl       #0x2480c   ; call _objc_release
0x00011a88  mov      x0, x22
0x00011a8c  mov      x2, x20
0x00011a90  bl       #0x25f20   ; objc_msgSend: layoutBarForPane:
0x00011a94  mov      x0, x20
0x00011a98  bl       #0x25840   ; objc_msgSend: handle
0x00011a9c  mov      x29, x29
0x00011aa0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011aa4  mov      x21, x0
0x00011aa8  mov      x1, x23
0x00011aac  bl       #0x11f58   ; call sub_11f58
0x00011ab0  mov      x0, x21
0x00011ab4  bl       #0x2480c   ; call _objc_release
0x00011ab8  ldr      x0, [sp]
0x00011abc  bl       #0x25d00   ; objc_msgSend: isHidden
0x00011ac0  cmp      w23, w0
0x00011ac4  b.ne     #0x11bfc
0x00011ac8  cbz      w23, #0x11af4
0x00011acc  ldr      x0, [sp]
0x00011ad0  mov      w2, #0
0x00011ad4  bl       #0x270a0   ; objc_msgSend: setHidden:
0x00011ad8  add      x22, sp, #0x90
0x00011adc  ldr      x23, [sp]
0x00011ae0  cbz      x23, #0x11b04
0x00011ae4  sub      x8, x29, #0x90
0x00011ae8  mov      x0, x23
0x00011aec  bl       #0x27fe0   ; objc_msgSend: transform
0x00011af0  b        #0x11b10   ; call sub_11b10
0x00011af4  mov      x0, x22
0x00011af8  mov      x2, x20
0x00011afc  bl       #0x258c0   ; objc_msgSend: hideBarForPane:
0x00011b00  b        #0x11bfc   ; call sub_11bfc
0x00011b04  movi     v0.16b, #0
0x00011b08  stp      q0, q0, [x22, #0x70]
0x00011b0c  str      q0, [x22, #0x60]
0x00011b10  ldp      q0, q1, [x22, #0x60]
0x00011b14  stp      q0, q1, [x22]
0x00011b18  ldr      q0, [x22, #0x80]
0x00011b1c  str      q0, [x22, #0x20]
0x00011b20  adrp     x8, #0x2b000
0x00011b24  ldr      d0, [x8, #0x208]
0x00011b28  add      x8, sp, #0xc0
0x00011b2c  add      x0, sp, #0x90
0x00011b30  mov      v1.16b, v0.16b
0x00011b34  bl       #0x242fc   ; call _CGAffineTransformScale
0x00011b38  add      x8, sp, #0x90
0x00011b3c  fmov     d0, xzr
0x00011b40  fmov     d1, #-8.00000000
0x00011b44  bl       #0x242f0   ; call _CGAffineTransformMakeTranslation
0x00011b48  add      x8, sp, #0x60
0x00011b4c  add      x0, sp, #0xc0
0x00011b50  add      x1, sp, #0x90
0x00011b54  bl       #0x242d8   ; call _CGAffineTransformConcat
0x00011b58  ldp      q0, q1, [sp, #0x60]
0x00011b5c  stp      q0, q1, [x22, #0x30]
0x00011b60  ldr      q0, [sp, #0x80]
0x00011b64  str      q0, [x22, #0x50]
0x00011b68  add      x2, sp, #0xc0
0x00011b6c  mov      x0, x23
0x00011b70  bl       #0x279a0   ; objc_msgSend: setTransform:
0x00011b74  adrp     x8, #0x3e000
0x00011b78  ldr      x21, [x8, #0x2d0]   ; -> [class(UIView)]
0x00011b7c  adrp     x8, #0x34000
0x00011b80  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x00011b84  str      x8, [sp, #8]
0x00011b88  adrp     x8, #0x2b000
0x00011b8c  ldr      d0, [x8, #0x1d0]
0x00011b90  str      d0, [sp, #0x10]
0x00011b94  adrp     x8, #0x12000
0x00011b98  add      x8, x8, #0x5c0
0x00011b9c  adrp     x9, #0x34000
0x00011ba0  add      x9, x9, #0x990
0x00011ba4  stp      x8, x9, [sp, #0x18]
0x00011ba8  mov      x0, x23
0x00011bac  bl       #0x24818   ; call _objc_retain
0x00011bb0  str      x23, [sp, #0x28]
0x00011bb4  ldp      q0, q1, [x22, #0x60]
0x00011bb8  stp      q0, q1, [sp, #0x30]
0x00011bbc  ldr      q0, [x22, #0x80]
0x00011bc0  stur     q0, [sp, #0x50]
0x00011bc4  adrp     x8, #0x2b000
0x00011bc8  ldr      d0, [x8, #0x270]
0x00011bcc  adrp     x8, #0x2b000
0x00011bd0  ldr      d2, [x8, #0x278]
0x00011bd4  adrp     x8, #0x2b000
0x00011bd8  ldr      d3, [x8, #0x280]
0x00011bdc  fmov     d1, xzr
0x00011be0  add      x3, sp, #8
0x00011be4  mov      x0, x21
0x00011be8  mov      w2, #2
0x00011bec  mov      x4, #0
0x00011bf0  bl       #0x24ca0   ; objc_msgSend: animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
0x00011bf4  ldr      x0, [sp, #0x28]
0x00011bf8  bl       #0x2480c   ; call _objc_release
0x00011bfc  ldr      x0, [sp]
0x00011c00  bl       #0x2480c   ; call _objc_release
0x00011c04  mov      x0, x20
0x00011c08  bl       #0x2480c   ; call _objc_release
0x00011c0c  mov      x0, x19
0x00011c10  bl       #0x2480c   ; call _objc_release
0x00011c14  ldp      x29, x30, [sp, #0x180]
0x00011c18  ldp      x20, x19, [sp, #0x170]
0x00011c1c  ldp      x22, x21, [sp, #0x160]
0x00011c20  ldp      x24, x23, [sp, #0x150]
0x00011c24  ldp      x26, x25, [sp, #0x140]
0x00011c28  ldp      x28, x27, [sp, #0x130]
0x00011c2c  add      sp, sp, #0x190
0x00011c30  ret      
0x00011c34  mov      x22, x0
0x00011c38  ldr      x0, [sp, #0x28]
0x00011c3c  b        #0x11c98   ; call sub_11c98
0x00011c40  b        #0x11ca4   ; call sub_11ca4
0x00011c44  b        #0x11cb4   ; call sub_11cb4
0x00011c48  b        #0x11c4c   ; call sub_11c4c
0x00011c4c  mov      x22, x0
0x00011c50  b        #0x11c70   ; call sub_11c70
0x00011c54  b        #0x11c58   ; call sub_11c58
0x00011c58  mov      x22, x0
0x00011c5c  b        #0x11c94   ; call sub_11c94
0x00011c60  b        #0x11c78   ; call sub_11c78
0x00011c64  mov      x22, x0
0x00011c68  mov      x0, x21
0x00011c6c  bl       #0x2480c   ; call _objc_release
0x00011c70  mov      x0, x25
0x00011c74  b        #0x11c98   ; call sub_11c98
0x00011c78  mov      x22, x0
0x00011c7c  mov      x0, x21
0x00011c80  b        #0x11c98   ; call sub_11c98
0x00011c84  mov      x22, x0
0x00011c88  cmp      w26, #2
0x00011c8c  mov      x0, x21
0x00011c90  bl       #0x2480c   ; call _objc_release
0x00011c94  mov      x0, x27
0x00011c98  bl       #0x2480c   ; call _objc_release
0x00011c9c  b        #0x11cb8   ; call sub_11cb8
0x00011ca0  b        #0x11ca4   ; call sub_11ca4
0x00011ca4  mov      x22, x0
0x00011ca8  b        #0x11cc0   ; call sub_11cc0
0x00011cac  mov      x22, x0
0x00011cb0  b        #0x11cc8   ; call sub_11cc8
0x00011cb4  mov      x22, x0
0x00011cb8  ldr      x0, [sp]
0x00011cbc  bl       #0x2480c   ; call _objc_release
0x00011cc0  mov      x0, x20
0x00011cc4  bl       #0x2480c   ; call _objc_release
0x00011cc8  mov      x0, x19
0x00011ccc  bl       #0x2480c   ; call _objc_release
0x00011cd0  mov      x0, x22
0x00011cd4  bl       #0x24470   ; call __Unwind_Resume
0x00011cd8  sub      sp, sp, #0x90
0x00011cdc  stp      d9, d8, [sp, #0x30]
0x00011ce0  stp      x26, x25, [sp, #0x40]
0x00011ce4  stp      x24, x23, [sp, #0x50]
0x00011ce8  stp      x22, x21, [sp, #0x60]
0x00011cec  stp      x20, x19, [sp, #0x70]
0x00011cf0  stp      x29, x30, [sp, #0x80]
0x00011cf4  add      x29, sp, #0x80
0x00011cf8  mov      x21, x2
0x00011cfc  mov      x20, x1
0x00011d00  mov      x19, x0
0x00011d04  bl       #0x24818   ; call _objc_retain
0x00011d08  mov      x0, x20
0x00011d0c  bl       #0x24818   ; call _objc_retain
0x00011d10  mov      x0, x21
0x00011d14  bl       #0x24818   ; call _objc_retain
0x00011d18  mov      x0, x20
0x00011d1c  bl       #0x24818   ; call _objc_retain
0x00011d20  adrp     x25, #0x3e000
0x00011d24  ldr      x0, [x25, #0xa48]
0x00011d28  cbnz     x0, #0x11d54
0x00011d2c  adrp     x8, #0x3e000
0x00011d30  ldr      x0, [x8, #0x398]   ; -> [class(NSMutableDictionary)]
0x00011d34  bl       #0x25580   ; objc_msgSend: dictionary
0x00011d38  mov      x29, x29
0x00011d3c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011d40  ldr      x8, [x25, #0xa48]
0x00011d44  str      x0, [x25, #0xa48]
0x00011d48  mov      x0, x8
0x00011d4c  bl       #0x2480c   ; call _objc_release
0x00011d50  ldr      x0, [x25, #0xa48]
0x00011d54  mov      x2, x20
0x00011d58  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00011d5c  mov      x29, x29
0x00011d60  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011d64  mov      x22, x0
0x00011d68  bl       #0x2480c   ; call _objc_release
0x00011d6c  cbz      x22, #0x11d8c
0x00011d70  ldr      x0, [x25, #0xa48]
0x00011d74  mov      x2, x20
0x00011d78  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00011d7c  mov      x29, x29
0x00011d80  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011d84  mov      x23, x0
0x00011d88  b        #0x11e5c   ; call sub_11e5c
0x00011d8c  adrp     x2, #0x36000
0x00011d90  add      x2, x2, #0xa30   ; -> @"hm_"
0x00011d94  mov      x0, x20
0x00011d98  bl       #0x258a0   ; objc_msgSend: hasPrefix:
0x00011d9c  cmp      w0, #0
0x00011da0  fmov     d0, #20.00000000
0x00011da4  fmov     d1, #22.00000000
0x00011da8  fcsel    d8, d1, d0, ne
0x00011dac  adrp     x8, #0x3e000
0x00011db0  ldr      x0, [x8, #0x3a0]   ; -> [class(UIGraphicsImageRenderer)]
0x00011db4  bl       #0x2471c   ; call _objc_alloc
0x00011db8  mov      v0.16b, v8.16b
0x00011dbc  mov      v1.16b, v8.16b
0x00011dc0  bl       #0x25a80   ; objc_msgSend: initWithSize:
0x00011dc4  mov      x22, x0
0x00011dc8  adrp     x8, #0x34000
0x00011dcc  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x00011dd0  str      x8, [sp]
0x00011dd4  adrp     x8, #0x2b000
0x00011dd8  ldr      d0, [x8, #0x1d0]
0x00011ddc  adrp     x8, #0x16000
0x00011de0  add      x8, x8, #0x8b0
0x00011de4  str      d0, [sp, #8]
0x00011de8  adrp     x9, #0x34000
0x00011dec  add      x9, x9, #0xa60
0x00011df0  stp      x8, x9, [sp, #0x10]
0x00011df4  str      d8, [sp, #0x28]
0x00011df8  mov      x0, x20
0x00011dfc  bl       #0x24818   ; call _objc_retain
0x00011e00  str      x20, [sp, #0x20]
0x00011e04  mov      x2, sp
0x00011e08  mov      x0, x22
0x00011e0c  bl       #0x25980   ; objc_msgSend: imageWithActions:
0x00011e10  mov      x29, x29
0x00011e14  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011e18  mov      x24, x0
0x00011e1c  mov      w2, #2
0x00011e20  bl       #0x259a0   ; objc_msgSend: imageWithRenderingMode:
0x00011e24  mov      x29, x29
0x00011e28  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011e2c  mov      x23, x0
0x00011e30  mov      x0, x24
0x00011e34  bl       #0x2480c   ; call _objc_release
0x00011e38  ldr      x0, [x25, #0xa48]
0x00011e3c  mov      x24, x23
0x00011e40  mov      x2, x23
0x00011e44  mov      x3, x20
0x00011e48  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00011e4c  ldr      x0, [sp, #0x20]
0x00011e50  bl       #0x2480c   ; call _objc_release
0x00011e54  mov      x0, x22
0x00011e58  bl       #0x2480c   ; call _objc_release
0x00011e5c  mov      x0, x20
0x00011e60  bl       #0x2480c   ; call _objc_release
0x00011e64  mov      x0, x19
0x00011e68  mov      w2, #0x1c86
0x00011e6c  bl       #0x28160   ; objc_msgSend: viewWithTag:
0x00011e70  mov      x29, x29
0x00011e74  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011e78  mov      x22, x0
0x00011e7c  mov      x2, x23
0x00011e80  bl       #0x27140   ; objc_msgSend: setImage:
0x00011e84  mov      x0, x22
0x00011e88  bl       #0x2480c   ; call _objc_release
0x00011e8c  mov      x0, x23
0x00011e90  bl       #0x2480c   ; call _objc_release
0x00011e94  mov      x0, x19
0x00011e98  mov      x2, x21
0x00011e9c  bl       #0x26b00   ; objc_msgSend: setAccessibilityLabel:
0x00011ea0  mov      x0, x21
0x00011ea4  bl       #0x2480c   ; call _objc_release
0x00011ea8  mov      x0, x20
0x00011eac  bl       #0x2480c   ; call _objc_release
0x00011eb0  mov      x0, x19
0x00011eb4  ldp      x29, x30, [sp, #0x80]
0x00011eb8  ldp      x20, x19, [sp, #0x70]
0x00011ebc  ldp      x22, x21, [sp, #0x60]
0x00011ec0  ldp      x24, x23, [sp, #0x50]
0x00011ec4  ldp      x26, x25, [sp, #0x40]
0x00011ec8  ldp      d9, d8, [sp, #0x30]
0x00011ecc  add      sp, sp, #0x90
0x00011ed0  b        #0x2480c   ; call _objc_release
0x00011ed4  mov      x24, x0
0x00011ed8  b        #0x11ef0   ; call sub_11ef0
0x00011edc  b        #0x11f2c   ; call sub_11f2c
0x00011ee0  mov      x1, x24
0x00011ee4  mov      x24, x0
0x00011ee8  mov      x0, x1
0x00011eec  bl       #0x2480c   ; call _objc_release
