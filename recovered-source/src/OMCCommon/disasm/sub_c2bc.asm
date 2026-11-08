; === sub_c2bc @ 0xc2bc size=324 ===
0x0000c2bc  sub      sp, sp, #0x120
0x0000c2c0  stp      x26, x25, [sp, #0xd0]
0x0000c2c4  stp      x24, x23, [sp, #0xe0]
0x0000c2c8  stp      x22, x21, [sp, #0xf0]
0x0000c2cc  stp      x20, x19, [sp, #0x100]
0x0000c2d0  stp      x29, x30, [sp, #0x110]
0x0000c2d4  add      x29, sp, #0x110
0x0000c2d8  adrp     x8, #0x14000
0x0000c2dc  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x0000c2e0  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x0000c2e4  stur     x8, [x29, #-0x48]
0x0000c2e8  adrp     x8, #0x18000
0x0000c2ec  ldr      x0, [x8, #0x470] ; -> [classref(NSMutableDictionary)]
0x0000c2f0  bl       #0xda80 ; call objc_stub[dictionary]
0x0000c2f4  mov      x29, x29
0x0000c2f8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000c2fc  mov      x19, x0
0x0000c300  movi     v0.16b, #0
0x0000c304  stp      q0, q0, [sp]
0x0000c308  stp      q0, q0, [sp, #0x20]
0x0000c30c  bl       #0xc510 ; call _OMCProfileKeys
0x0000c310  mov      x29, x29
0x0000c314  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000c318  mov      x20, x0
0x0000c31c  mov      x2, sp
0x0000c320  add      x3, sp, #0x48
0x0000c324  mov      w4, #0x10
0x0000c328  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000c32c  cbz      x0, #0xc3bc
0x0000c330  mov      x21, x0
0x0000c334  ldr      x8, [sp, #0x10]
0x0000c338  ldr      x24, [x8] ; -> [selref(CGContext)]
0x0000c33c  mov      x25, #0
0x0000c340  ldr      x8, [sp, #0x10]
0x0000c344  ldr      x8, [x8] ; -> [selref(CGContext)]
0x0000c348  cmp      x8, x24
0x0000c34c  b.eq     #0xc358
0x0000c350  mov      x0, x20
0x0000c354  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x0000c358  ldr      x8, [sp, #8]
0x0000c35c  ldr      x22, [x8, x25, lsl #3] ; -> [selref(CGContext)]
0x0000c360  mov      x0, x22
0x0000c364  mov      x1, #0
0x0000c368  bl       #0x6534 ; call _OMCPref
0x0000c36c  mov      x29, x29
0x0000c370  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000c374  mov      x23, x0
0x0000c378  cbz      x0, #0xc38c
0x0000c37c  mov      x0, x19
0x0000c380  mov      x2, x23
0x0000c384  mov      x3, x22
0x0000c388  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000c38c  mov      x0, x23
0x0000c390  bl       #0xd4b8 ; call stub:_objc_release
0x0000c394  add      x25, x25, #1
0x0000c398  cmp      x21, x25
0x0000c39c  b.ne     #0xc340
0x0000c3a0  mov      x2, sp
0x0000c3a4  add      x3, sp, #0x48
0x0000c3a8  mov      x0, x20
0x0000c3ac  mov      w4, #0x10
0x0000c3b0  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000c3b4  mov      x21, x0
0x0000c3b8  cbnz     x0, #0xc33c
0x0000c3bc  mov      x0, x20
0x0000c3c0  bl       #0xd4b8 ; call stub:_objc_release
0x0000c3c4  ldur     x8, [x29, #-0x48]
0x0000c3c8  adrp     x9, #0x14000
0x0000c3cc  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x0000c3d0  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x0000c3d4  cmp      x9, x8
0x0000c3d8  b.ne     #0xc3fc
0x0000c3dc  mov      x0, x19
0x0000c3e0  ldp      x29, x30, [sp, #0x110]
0x0000c3e4  ldp      x20, x19, [sp, #0x100]
0x0000c3e8  ldp      x22, x21, [sp, #0xf0]
0x0000c3ec  ldp      x24, x23, [sp, #0xe0]
0x0000c3f0  ldp      x26, x25, [sp, #0xd0]
0x0000c3f4  add      sp, sp, #0x120
0x0000c3f8  b        #0xd434 ; call stub:_objc_autoreleaseReturnValue
0x0000c3fc  bl       #0xd1b8 ; call stub:___stack_chk_fail
