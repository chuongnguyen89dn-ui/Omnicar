; === sub_c038 @ 0xc038 size=644 ===
0x0000c038  stp      x28, x27, [sp, #-0x60]!
0x0000c03c  stp      x26, x25, [sp, #0x10]
0x0000c040  stp      x24, x23, [sp, #0x20]
0x0000c044  stp      x22, x21, [sp, #0x30]
0x0000c048  stp      x20, x19, [sp, #0x40]
0x0000c04c  stp      x29, x30, [sp, #0x50]
0x0000c050  add      x29, sp, #0x50
0x0000c054  sub      sp, sp, #0x1b0
0x0000c058  mov      x20, x1
0x0000c05c  mov      x19, x0
0x0000c060  adrp     x8, #0x14000
0x0000c064  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x0000c068  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x0000c06c  stur     x8, [x29, #-0x60]
0x0000c070  bl       #0xd4c4 ; call stub:_objc_retain
0x0000c074  mov      x0, x20
0x0000c078  bl       #0xd4c4 ; call stub:_objc_retain
0x0000c07c  movi     v0.16b, #0
0x0000c080  stp      q0, q0, [sp, #0x60]
0x0000c084  stp      q0, q0, [sp, #0x80]
0x0000c088  adrp     x0, #0x17000
0x0000c08c  add      x0, x0, #0xc0 ; -> __DATA_CONST,__objc_arrayobj+0xa8 (const collection)
0x0000c090  add      x2, sp, #0x60
0x0000c094  sub      x3, x29, #0xe0
0x0000c098  mov      w4, #0x10
0x0000c09c  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000c0a0  mov      x27, x0
0x0000c0a4  cbz      x0, #0xc26c
0x0000c0a8  ldr      x8, [sp, #0x70]
0x0000c0ac  ldr      x21, [x8] ; -> [got(___objc_personality_v0)]
0x0000c0b0  adrp     x26, #0x18000
0x0000c0b4  adrp     x24, #0x18000
0x0000c0b8  adrp     x22, #0x16000
0x0000c0bc  add      x22, x22, #0x548 ; -> CFSTR("nil")
0x0000c0c0  adrp     x23, #0x16000
0x0000c0c4  add      x23, x23, #0x848 ; -> CFSTR("(null)")
0x0000c0c8  str      x19, [sp, #0x18]
0x0000c0cc  str      x21, [sp, #8]
0x0000c0d0  mov      x28, #0
0x0000c0d4  str      x27, [sp, #0x10]
0x0000c0d8  ldr      x8, [sp, #0x70]
0x0000c0dc  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x0000c0e0  cmp      x8, x21
0x0000c0e4  b.eq     #0xc0f4
0x0000c0e8  adrp     x0, #0x17000
0x0000c0ec  add      x0, x0, #0xc0 ; -> __DATA_CONST,__objc_arrayobj+0xa8 (const collection)
0x0000c0f0  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x0000c0f4  ldr      x8, [sp, #0x68]
0x0000c0f8  ldr      x2, [x8, x28, lsl #3] ; -> [got(___objc_personality_v0)]
0x0000c0fc  mov      x0, x19
0x0000c100  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000c104  mov      x29, x29
0x0000c108  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000c10c  mov      x25, x0
0x0000c110  ldr      x0, [x26, #0x468] ; -> [classref(NSDictionary)]
0x0000c114  bl       #0xd47c ; call stub:_objc_opt_class
0x0000c118  mov      x1, x0
0x0000c11c  mov      x0, x25
0x0000c120  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x0000c124  tbz      w0, #0, #0xc220
0x0000c128  movi     v0.16b, #0
0x0000c12c  stp      q0, q0, [sp, #0x40]
0x0000c130  stp      q0, q0, [sp, #0x20]
0x0000c134  mov      x0, x20
0x0000c138  bl       #0xd4c4 ; call stub:_objc_retain
0x0000c13c  add      x2, sp, #0x20
0x0000c140  add      x3, sp, #0xa0
0x0000c144  mov      x0, x20
0x0000c148  mov      w4, #0x10
0x0000c14c  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000c150  cbz      x0, #0xc20c
0x0000c154  mov      x26, x0
0x0000c158  ldr      x8, [sp, #0x30]
0x0000c15c  ldr      x21, [x8] ; -> [got(___objc_personality_v0)]
0x0000c160  mov      x19, #0
0x0000c164  ldr      x8, [sp, #0x30]
0x0000c168  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x0000c16c  cmp      x8, x21
0x0000c170  b.eq     #0xc17c
0x0000c174  mov      x0, x20
0x0000c178  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x0000c17c  ldr      x8, [sp, #0x28]
0x0000c180  ldr      x2, [x8, x19, lsl #3] ; -> [got(___objc_personality_v0)]
0x0000c184  mov      x0, x25
0x0000c188  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000c18c  mov      x29, x29
0x0000c190  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000c194  mov      x27, x0
0x0000c198  ldr      x0, [x24, #0x3f0] ; -> [classref(NSString)]
0x0000c19c  bl       #0xd47c ; call stub:_objc_opt_class
0x0000c1a0  mov      x1, x0
0x0000c1a4  mov      x0, x27
0x0000c1a8  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x0000c1ac  tbz      w0, #0, #0xc1dc
0x0000c1b0  mov      x0, x27
0x0000c1b4  bl       #0xdce0 ; call objc_stub[length]
0x0000c1b8  cbz      x0, #0xc1dc
0x0000c1bc  mov      x0, x27
0x0000c1c0  mov      x2, x22
0x0000c1c4  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x0000c1c8  tbnz     w0, #0, #0xc1dc
0x0000c1cc  mov      x0, x27
0x0000c1d0  mov      x2, x23
0x0000c1d4  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x0000c1d8  cbz      w0, #0xc258
0x0000c1dc  mov      x0, x27
0x0000c1e0  bl       #0xd4b8 ; call stub:_objc_release
0x0000c1e4  add      x19, x19, #1
0x0000c1e8  cmp      x26, x19
0x0000c1ec  b.ne     #0xc164
0x0000c1f0  add      x2, sp, #0x20
0x0000c1f4  add      x3, sp, #0xa0
0x0000c1f8  mov      x0, x20
0x0000c1fc  mov      w4, #0x10
0x0000c200  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000c204  mov      x26, x0
0x0000c208  cbnz     x0, #0xc160
0x0000c20c  mov      x0, x20
0x0000c210  bl       #0xd4b8 ; call stub:_objc_release
0x0000c214  ldp      x27, x19, [sp, #0x10]
0x0000c218  ldr      x21, [sp, #8]
0x0000c21c  adrp     x26, #0x18000
0x0000c220  mov      x0, x25
0x0000c224  bl       #0xd4b8 ; call stub:_objc_release
0x0000c228  add      x28, x28, #1
0x0000c22c  cmp      x28, x27
0x0000c230  b.ne     #0xc0d8
0x0000c234  add      x2, sp, #0x60
0x0000c238  sub      x3, x29, #0xe0
0x0000c23c  adrp     x0, #0x17000
0x0000c240  add      x0, x0, #0xc0 ; -> __DATA_CONST,__objc_arrayobj+0xa8 (const collection)
0x0000c244  mov      w4, #0x10
0x0000c248  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000c24c  mov      x27, x0
0x0000c250  cbnz     x0, #0xc0d0
0x0000c254  b        #0xc26c
0x0000c258  mov      x0, x20
0x0000c25c  bl       #0xd4b8 ; call stub:_objc_release
0x0000c260  mov      x0, x25
0x0000c264  bl       #0xd4b8 ; call stub:_objc_release
0x0000c268  ldr      x19, [sp, #0x18]
0x0000c26c  mov      x0, x20
0x0000c270  bl       #0xd4b8 ; call stub:_objc_release
0x0000c274  mov      x0, x19
0x0000c278  bl       #0xd4b8 ; call stub:_objc_release
0x0000c27c  ldur     x8, [x29, #-0x60]
0x0000c280  adrp     x9, #0x14000
0x0000c284  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x0000c288  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x0000c28c  cmp      x9, x8
0x0000c290  b.ne     #0xc2b8
0x0000c294  mov      x0, x27
0x0000c298  add      sp, sp, #0x1b0
0x0000c29c  ldp      x29, x30, [sp, #0x50]
0x0000c2a0  ldp      x20, x19, [sp, #0x40]
0x0000c2a4  ldp      x22, x21, [sp, #0x30]
0x0000c2a8  ldp      x24, x23, [sp, #0x20]
0x0000c2ac  ldp      x26, x25, [sp, #0x10]
0x0000c2b0  ldp      x28, x27, [sp], #0x60
0x0000c2b4  b        #0xd434 ; call stub:_objc_autoreleaseReturnValue
0x0000c2b8  bl       #0xd1b8 ; call stub:___stack_chk_fail
