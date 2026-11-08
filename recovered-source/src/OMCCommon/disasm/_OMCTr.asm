; === _OMCTr @ 0xc8c0 size=632 ===
0x0000c8c0  stp      x28, x27, [sp, #-0x60]!
0x0000c8c4  stp      x26, x25, [sp, #0x10]
0x0000c8c8  stp      x24, x23, [sp, #0x20]
0x0000c8cc  stp      x22, x21, [sp, #0x30]
0x0000c8d0  stp      x20, x19, [sp, #0x40]
0x0000c8d4  stp      x29, x30, [sp, #0x50]
0x0000c8d8  add      x29, sp, #0x50
0x0000c8dc  sub      sp, sp, #0x420
0x0000c8e0  mov      x20, x1
0x0000c8e4  mov      x19, x0
0x0000c8e8  adrp     x8, #0x14000
0x0000c8ec  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x0000c8f0  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x0000c8f4  stur     x8, [x29, #-0x58]
0x0000c8f8  bl       #0xd4c4 ; call stub:_objc_retain
0x0000c8fc  mov      x0, x20
0x0000c900  bl       #0xd4c4 ; call stub:_objc_retain
0x0000c904  bl       #0xc528 ; call _OMCCurrentLanguage
0x0000c908  mov      x29, x29
0x0000c90c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000c910  mov      x21, x0
0x0000c914  adrp     x2, #0x16000
0x0000c918  add      x2, x2, #0xa48 ; -> CFSTR("vi")
0x0000c91c  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x0000c920  cbz      w0, #0xc934
0x0000c924  mov      x0, x19
0x0000c928  bl       #0xd4c4 ; call stub:_objc_retain
0x0000c92c  mov      x22, x19
0x0000c930  b        #0xcab4
0x0000c934  adrp     x2, #0x16000
0x0000c938  add      x2, x2, #0xa68 ; -> CFSTR("en")
0x0000c93c  mov      x0, x21
0x0000c940  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x0000c944  cbz      x20, #0xc9d4
0x0000c948  cbnz     w0, #0xc9d4
0x0000c94c  mov      x0, x21
0x0000c950  bl       #0xd4c4 ; call stub:_objc_retain
0x0000c954  adrp     x8, #0x18000
0x0000c958  ldr      x8, [x8, #0x740] ; -> [__DATA,__bss+0x240]
0x0000c95c  cmn      x8, #1
0x0000c960  b.ne     #0xcb08
0x0000c964  adrp     x26, #0x18000
0x0000c968  ldr      x22, [x26, #0x738] ; -> [__DATA,__bss+0x238]
0x0000c96c  mov      x0, x22
0x0000c970  bl       #0xd4c4 ; call stub:_objc_retain
0x0000c974  mov      x0, x22
0x0000c978  bl       #0xd4e8 ; call stub:_objc_sync_enter
0x0000c97c  ldr      x0, [x26, #0x738] ; -> [__DATA,__bss+0x238]
0x0000c980  mov      x2, x21
0x0000c984  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000c988  mov      x29, x29
0x0000c98c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000c990  mov      x23, x0
0x0000c994  cbnz     x0, #0xca64
0x0000c998  adrp     x24, #0x18000
0x0000c99c  ldr      x23, [x24, #0x3f0] ; -> [classref(NSString)]
0x0000c9a0  adrp     x0, #0x16000
0x0000c9a4  add      x0, x0, #0xca8 ; -> CFSTR("/Library/PreferenceBundles/OmniCarPrefs.bundle")
0x0000c9a8  bl       #0xdb60 ; call objc_stub[fileSystemRepresentation]
0x0000c9ac  add      x1, sp, #0x18
0x0000c9b0  bl       #0x4118 ; call sub_4118
0x0000c9b4  mov      x2, x0
0x0000c9b8  cbz      x0, #0xc9e4
0x0000c9bc  ldr      x0, [x24, #0x3f0] ; -> [classref(NSString)]
0x0000c9c0  bl       #0xe440 ; call objc_stub[stringWithUTF8String:]
0x0000c9c4  mov      x29, x29
0x0000c9c8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000c9cc  mov      x25, x0
0x0000c9d0  b        #0xc9e8
0x0000c9d4  mov      x0, x20
0x0000c9d8  bl       #0xd4c4 ; call stub:_objc_retain
0x0000c9dc  mov      x22, x20
0x0000c9e0  b        #0xcab4
0x0000c9e4  mov      x25, #0
0x0000c9e8  stp      x25, x21, [sp]
0x0000c9ec  adrp     x2, #0x16000
0x0000c9f0  add      x2, x2, #0xc88 ; -> CFSTR("%@/%@.lproj/Car.strings")
0x0000c9f4  mov      x0, x23
0x0000c9f8  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x0000c9fc  mov      x29, x29
0x0000ca00  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000ca04  mov      x24, x0
0x0000ca08  mov      x0, x25
0x0000ca0c  bl       #0xd4b8 ; call stub:_objc_release
0x0000ca10  adrp     x8, #0x18000
0x0000ca14  ldr      x0, [x8, #0x468] ; -> [classref(NSDictionary)]
0x0000ca18  mov      x2, x24
0x0000ca1c  bl       #0xdaa0 ; call objc_stub[dictionaryWithContentsOfFile:]
0x0000ca20  mov      x29, x29
0x0000ca24  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000ca28  mov      x25, x0
0x0000ca2c  adrp     x8, #0x14000
0x0000ca30  ldr      x8, [x8, #0x178] ; -> [got(___NSDictionary0__struct)]
0x0000ca34  cmp      x0, #0
0x0000ca38  csel     x23, x8, x0, eq
0x0000ca3c  mov      x0, x23
0x0000ca40  bl       #0xd4c4 ; call stub:_objc_retain
0x0000ca44  mov      x0, x25
0x0000ca48  bl       #0xd4b8 ; call stub:_objc_release
0x0000ca4c  ldr      x0, [x26, #0x738] ; -> [__DATA,__bss+0x238]
0x0000ca50  mov      x2, x23
0x0000ca54  mov      x3, x21
0x0000ca58  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000ca5c  mov      x0, x24
0x0000ca60  bl       #0xd4b8 ; call stub:_objc_release
0x0000ca64  mov      x0, x22
0x0000ca68  bl       #0xd4f4 ; call stub:_objc_sync_exit
0x0000ca6c  mov      x0, x22
0x0000ca70  bl       #0xd4b8 ; call stub:_objc_release
0x0000ca74  mov      x0, x21
0x0000ca78  bl       #0xd4b8 ; call stub:_objc_release
0x0000ca7c  mov      x0, x23
0x0000ca80  mov      x2, x20
0x0000ca84  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000ca88  mov      x29, x29
0x0000ca8c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000ca90  mov      x24, x0
0x0000ca94  cmp      x0, #0
0x0000ca98  csel     x22, x20, x0, eq
0x0000ca9c  mov      x0, x22
0x0000caa0  bl       #0xd4c4 ; call stub:_objc_retain
0x0000caa4  mov      x0, x24
0x0000caa8  bl       #0xd4b8 ; call stub:_objc_release
0x0000caac  mov      x0, x23
0x0000cab0  bl       #0xd4b8 ; call stub:_objc_release
0x0000cab4  mov      x0, x21
0x0000cab8  bl       #0xd4b8 ; call stub:_objc_release
0x0000cabc  mov      x0, x20
0x0000cac0  bl       #0xd4b8 ; call stub:_objc_release
0x0000cac4  mov      x0, x19
0x0000cac8  bl       #0xd4b8 ; call stub:_objc_release
0x0000cacc  ldur     x8, [x29, #-0x58]
0x0000cad0  adrp     x9, #0x14000
0x0000cad4  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x0000cad8  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x0000cadc  cmp      x9, x8
0x0000cae0  b.ne     #0xcb10
0x0000cae4  mov      x0, x22
0x0000cae8  add      sp, sp, #0x420
0x0000caec  ldp      x29, x30, [sp, #0x50]
0x0000caf0  ldp      x20, x19, [sp, #0x40]
0x0000caf4  ldp      x22, x21, [sp, #0x30]
0x0000caf8  ldp      x24, x23, [sp, #0x20]
0x0000cafc  ldp      x26, x25, [sp, #0x10]
0x0000cb00  ldp      x28, x27, [sp], #0x60
0x0000cb04  b        #0xd434 ; call stub:_objc_autoreleaseReturnValue
0x0000cb08  bl       #0xd0c0 ; call sub_d0c0
0x0000cb0c  b        #0xc964
0x0000cb10  bl       #0xd1b8 ; call stub:___stack_chk_fail
0x0000cb14  b        #0xcb1c
0x0000cb18  b        #0xcb1c
0x0000cb1c  mov      x19, x0
0x0000cb20  mov      x0, x22
0x0000cb24  bl       #0xd4f4 ; call stub:_objc_sync_exit
0x0000cb28  b        #0xcb30
0x0000cb2c  mov      x19, x0
0x0000cb30  mov      x0, x19
0x0000cb34  bl       #0xd1a0 ; call stub:__Unwind_Resume
