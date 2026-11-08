; === _OMCCurrentLanguage @ 0xc528 size=920 ===
0x0000c528  stp      x28, x27, [sp, #-0x60]!
0x0000c52c  stp      x26, x25, [sp, #0x10]
0x0000c530  stp      x24, x23, [sp, #0x20]
0x0000c534  stp      x22, x21, [sp, #0x30]
0x0000c538  stp      x20, x19, [sp, #0x40]
0x0000c53c  stp      x29, x30, [sp, #0x50]
0x0000c540  add      x29, sp, #0x50
0x0000c544  sub      sp, sp, #0x280
0x0000c548  adrp     x8, #0x14000
0x0000c54c  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x0000c550  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x0000c554  stur     x8, [x29, #-0x60]
0x0000c558  adrp     x0, #0x16000
0x0000c55c  add      x0, x0, #0xc08 ; -> CFSTR("language")
0x0000c560  adrp     x1, #0x14000
0x0000c564  add      x1, x1, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x0000c568  bl       #0xd0ec ; call stub:_CFPreferencesCopyAppValue
0x0000c56c  mov      x19, x0
0x0000c570  adrp     x8, #0x18000
0x0000c574  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x0000c578  bl       #0xd47c ; call stub:_objc_opt_class
0x0000c57c  mov      x1, x0
0x0000c580  mov      x0, x19
0x0000c584  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x0000c588  tbz      w0, #0, #0xc5b0
0x0000c58c  adrp     x0, #0x17000
0x0000c590  add      x0, x0, #0xf0 ; -> __DATA_CONST,__objc_arrayobj+0xd8 (const collection)
0x0000c594  mov      x2, x19
0x0000c598  bl       #0xd900 ; call objc_stub[containsObject:]
0x0000c59c  cbz      w0, #0xc5b0
0x0000c5a0  mov      x0, x19
0x0000c5a4  bl       #0xd4c4 ; call stub:_objc_retain
0x0000c5a8  mov      x26, x19
0x0000c5ac  b        #0xc860
0x0000c5b0  movi     v0.16b, #0
0x0000c5b4  stp      q0, q0, [sp, #0xd0]
0x0000c5b8  stp      q0, q0, [sp, #0xb0]
0x0000c5bc  adrp     x8, #0x18000
0x0000c5c0  ldr      x0, [x8, #0x438] ; -> [classref(NSLocale)]
0x0000c5c4  bl       #0xe020 ; call objc_stub[preferredLanguages]
0x0000c5c8  mov      x29, x29
0x0000c5cc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000c5d0  mov      x20, x0
0x0000c5d4  add      x2, sp, #0xb0
0x0000c5d8  sub      x3, x29, #0xe0
0x0000c5dc  mov      w4, #0x10
0x0000c5e0  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000c5e4  cbz      x0, #0xc83c
0x0000c5e8  ldr      x8, [sp, #0xc0]
0x0000c5ec  ldr      x22, [x8] ; -> [selref(CGContext)]
0x0000c5f0  adrp     x21, #0x17000
0x0000c5f4  add      x21, x21, #0xf0 ; -> __DATA_CONST,__objc_arrayobj+0xd8 (const collection)
0x0000c5f8  adrp     x23, #0x15000
0x0000c5fc  add      x23, x23, #0x928 ; -> CFSTR("-")
0x0000c600  str      x20, [sp, #0x28]
0x0000c604  str      x22, [sp, #0x10]
0x0000c608  mov      x24, #0
0x0000c60c  str      x0, [sp, #0x18]
0x0000c610  ldr      x8, [sp, #0xc0]
0x0000c614  ldr      x8, [x8] ; -> [selref(CGContext)]
0x0000c618  cmp      x8, x22
0x0000c61c  b.eq     #0xc628
0x0000c620  mov      x0, x20
0x0000c624  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x0000c628  ldr      x8, [sp, #0xb8]
0x0000c62c  str      x24, [sp, #0x20]
0x0000c630  ldr      x25, [x8, x24, lsl #3] ; -> [selref(CGContext)]
0x0000c634  movi     v0.16b, #0
0x0000c638  stp      q0, q0, [sp, #0x70]
0x0000c63c  stp      q0, q0, [sp, #0x90]
0x0000c640  add      x2, sp, #0x70
0x0000c644  add      x3, sp, #0x170
0x0000c648  mov      x0, x21
0x0000c64c  mov      w4, #0x10
0x0000c650  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000c654  cbz      x0, #0xc6f4
0x0000c658  mov      x27, x0
0x0000c65c  ldr      x8, [sp, #0x80]
0x0000c660  ldr      x22, [x8] ; -> [selref(CGContext)]
0x0000c664  mov      x20, #0
0x0000c668  ldr      x8, [sp, #0x80]
0x0000c66c  ldr      x8, [x8] ; -> [selref(CGContext)]
0x0000c670  cmp      x8, x22
0x0000c674  b.eq     #0xc680
0x0000c678  mov      x0, x21
0x0000c67c  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x0000c680  ldr      x8, [sp, #0x78]
0x0000c684  ldr      x26, [x8, x20, lsl #3] ; -> [selref(CGContext)]
0x0000c688  mov      x0, x25
0x0000c68c  mov      x2, x26
0x0000c690  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x0000c694  tbnz     w0, #0, #0xc850
0x0000c698  mov      x0, x26
0x0000c69c  mov      x2, x23
0x0000c6a0  bl       #0xe3a0 ; call objc_stub[stringByAppendingString:]
0x0000c6a4  mov      x29, x29
0x0000c6a8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000c6ac  mov      x28, x0
0x0000c6b0  mov      x0, x25
0x0000c6b4  mov      x2, x28
0x0000c6b8  bl       #0xdba0 ; call objc_stub[hasPrefix:]
0x0000c6bc  mov      x24, x0
0x0000c6c0  mov      x0, x28
0x0000c6c4  bl       #0xd4b8 ; call stub:_objc_release
0x0000c6c8  tbnz     w24, #0, #0xc850
0x0000c6cc  add      x20, x20, #1
0x0000c6d0  cmp      x27, x20
0x0000c6d4  b.ne     #0xc668
0x0000c6d8  add      x2, sp, #0x70
0x0000c6dc  add      x3, sp, #0x170
0x0000c6e0  mov      x0, x21
0x0000c6e4  mov      w4, #0x10
0x0000c6e8  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000c6ec  mov      x27, x0
0x0000c6f0  cbnz     x0, #0xc664
0x0000c6f4  mov      x0, x25
0x0000c6f8  mov      x2, x23
0x0000c6fc  bl       #0xd8c0 ; call objc_stub[componentsSeparatedByString:]
0x0000c700  mov      x29, x29
0x0000c704  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000c708  mov      x24, x0
0x0000c70c  bl       #0xdb80 ; call objc_stub[firstObject]
0x0000c710  mov      x29, x29
0x0000c714  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000c718  mov      x25, x0
0x0000c71c  mov      x0, x24
0x0000c720  bl       #0xd4b8 ; call stub:_objc_release
0x0000c724  mov      x0, x25
0x0000c728  adrp     x2, #0x16000
0x0000c72c  add      x2, x2, #0xc28 ; -> CFSTR("zh")
0x0000c730  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x0000c734  tbnz     w0, #0, #0xc804
0x0000c738  movi     v0.16b, #0
0x0000c73c  stp      q0, q0, [sp, #0x50]
0x0000c740  stp      q0, q0, [sp, #0x30]
0x0000c744  add      x2, sp, #0x30
0x0000c748  add      x3, sp, #0xf0
0x0000c74c  mov      x0, x21
0x0000c750  mov      w4, #0x10
0x0000c754  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000c758  cbz      x0, #0xc804
0x0000c75c  mov      x27, x0
0x0000c760  ldr      x8, [sp, #0x40]
0x0000c764  ldr      x20, [x8] ; -> [selref(CGContext)]
0x0000c768  str      x19, [sp, #8]
0x0000c76c  mov      x19, #0
0x0000c770  ldr      x8, [sp, #0x40]
0x0000c774  ldr      x8, [x8] ; -> [selref(CGContext)]
0x0000c778  cmp      x8, x20
0x0000c77c  b.eq     #0xc788
0x0000c780  mov      x0, x21
0x0000c784  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x0000c788  ldr      x8, [sp, #0x38]
0x0000c78c  ldr      x26, [x8, x19, lsl #3] ; -> [selref(CGContext)]
0x0000c790  mov      x0, x26
0x0000c794  mov      x2, x23
0x0000c798  bl       #0xd8c0 ; call objc_stub[componentsSeparatedByString:]
0x0000c79c  mov      x29, x29
0x0000c7a0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000c7a4  mov      x24, x0
0x0000c7a8  bl       #0xdb80 ; call objc_stub[firstObject]
0x0000c7ac  mov      x29, x29
0x0000c7b0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000c7b4  mov      x28, x0
0x0000c7b8  mov      x2, x25
0x0000c7bc  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x0000c7c0  mov      x22, x0
0x0000c7c4  mov      x0, x28
0x0000c7c8  bl       #0xd4b8 ; call stub:_objc_release
0x0000c7cc  mov      x0, x24
0x0000c7d0  bl       #0xd4b8 ; call stub:_objc_release
0x0000c7d4  tbnz     w22, #0, #0xc8a4
0x0000c7d8  add      x19, x19, #1
0x0000c7dc  cmp      x27, x19
0x0000c7e0  b.ne     #0xc770
0x0000c7e4  add      x2, sp, #0x30
0x0000c7e8  add      x3, sp, #0xf0
0x0000c7ec  mov      x0, x21
0x0000c7f0  mov      w4, #0x10
0x0000c7f4  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000c7f8  mov      x27, x0
0x0000c7fc  ldr      x19, [sp, #8]
0x0000c800  cbnz     x0, #0xc76c
0x0000c804  mov      x0, x25
0x0000c808  bl       #0xd4b8 ; call stub:_objc_release
0x0000c80c  ldp      x0, x24, [sp, #0x18]
0x0000c810  add      x24, x24, #1
0x0000c814  cmp      x24, x0
0x0000c818  ldr      x20, [sp, #0x28]
0x0000c81c  ldr      x22, [sp, #0x10]
0x0000c820  b.ne     #0xc610
0x0000c824  add      x2, sp, #0xb0
0x0000c828  sub      x3, x29, #0xe0
0x0000c82c  mov      x0, x20
0x0000c830  mov      w4, #0x10
0x0000c834  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000c838  cbnz     x0, #0xc608
0x0000c83c  mov      x0, x20
0x0000c840  bl       #0xd4b8 ; call stub:_objc_release
0x0000c844  adrp     x26, #0x16000
0x0000c848  add      x26, x26, #0xa68 ; -> CFSTR("en")
0x0000c84c  b        #0xc860
0x0000c850  mov      x0, x26
0x0000c854  bl       #0xd4c4 ; call stub:_objc_retain
0x0000c858  ldr      x0, [sp, #0x28]
0x0000c85c  bl       #0xd4b8 ; call stub:_objc_release
0x0000c860  mov      x0, x19
0x0000c864  bl       #0xd4b8 ; call stub:_objc_release
0x0000c868  ldur     x8, [x29, #-0x60]
0x0000c86c  adrp     x9, #0x14000
0x0000c870  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x0000c874  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x0000c878  cmp      x9, x8
0x0000c87c  b.ne     #0xc8bc
0x0000c880  mov      x0, x26
0x0000c884  add      sp, sp, #0x280
0x0000c888  ldp      x29, x30, [sp, #0x50]
0x0000c88c  ldp      x20, x19, [sp, #0x40]
0x0000c890  ldp      x22, x21, [sp, #0x30]
0x0000c894  ldp      x24, x23, [sp, #0x20]
0x0000c898  ldp      x26, x25, [sp, #0x10]
0x0000c89c  ldp      x28, x27, [sp], #0x60
0x0000c8a0  b        #0xd434 ; call stub:_objc_autoreleaseReturnValue
0x0000c8a4  mov      x0, x26
0x0000c8a8  bl       #0xd4c4 ; call stub:_objc_retain
0x0000c8ac  mov      x0, x25
0x0000c8b0  bl       #0xd4b8 ; call stub:_objc_release
0x0000c8b4  ldr      x19, [sp, #8]
0x0000c8b8  b        #0xc858
0x0000c8bc  bl       #0xd1b8 ; call stub:___stack_chk_fail
