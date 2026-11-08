; === _OMCCarWireless @ 0x67e4 size=1024 ===
0x000067e4  stp      x28, x27, [sp, #-0x60]!
0x000067e8  stp      x26, x25, [sp, #0x10]
0x000067ec  stp      x24, x23, [sp, #0x20]
0x000067f0  stp      x22, x21, [sp, #0x30]
0x000067f4  stp      x20, x19, [sp, #0x40]
0x000067f8  stp      x29, x30, [sp, #0x50]
0x000067fc  add      x29, sp, #0x50
0x00006800  sub      sp, sp, #0x1b0
0x00006804  adrp     x8, #0x14000
0x00006808  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x0000680c  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x00006810  stur     x8, [x29, #-0x60]
0x00006814  adrp     x0, #0x15000
0x00006818  add      x0, x0, #0x6a8 ; -> CFSTR("diagCar")
0x0000681c  mov      x1, #0
0x00006820  bl       #0x6534 ; call _OMCPref
0x00006824  mov      x29, x29
0x00006828  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000682c  mov      x19, x0
0x00006830  adrp     x21, #0x18000
0x00006834  ldr      x0, [x21, #0x468] ; -> [classref(NSDictionary)]
0x00006838  bl       #0xd47c ; call stub:_objc_opt_class
0x0000683c  mov      x1, x0
0x00006840  mov      x0, x19
0x00006844  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x00006848  tbz      w0, #0, #0x6b34
0x0000684c  movi     v0.16b, #0
0x00006850  stp      q0, q0, [sp, #0x80]
0x00006854  stp      q0, q0, [sp, #0x60]
0x00006858  adrp     x0, #0x17000
0x0000685c  add      x0, x0, #0x60 ; -> __DATA_CONST,__objc_arrayobj+0x48 (const collection)
0x00006860  add      x2, sp, #0x60
0x00006864  sub      x3, x29, #0xe0
0x00006868  mov      w4, #0x10
0x0000686c  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00006870  cbz      x0, #0x6b34
0x00006874  mov      x23, x0
0x00006878  ldr      x8, [sp, #0x70]
0x0000687c  adrp     x24, #0x18000
0x00006880  ldr      x26, [x8] ; -> [got(___objc_personality_v0)]
0x00006884  adrp     x22, #0x17000
0x00006888  add      x22, x22, #0x60 ; -> __DATA_CONST,__objc_arrayobj+0x48 (const collection)
0x0000688c  str      x19, [sp, #0x18]
0x00006890  str      x26, [sp, #8]
0x00006894  mov      x25, #0
0x00006898  ldr      x8, [sp, #0x70]
0x0000689c  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x000068a0  cmp      x8, x26
0x000068a4  b.eq     #0x68b0
0x000068a8  mov      x0, x22
0x000068ac  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x000068b0  ldr      x8, [sp, #0x68]
0x000068b4  ldr      x2, [x8, x25, lsl #3] ; -> [got(___objc_personality_v0)]
0x000068b8  mov      x0, x19
0x000068bc  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x000068c0  mov      x29, x29
0x000068c4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000068c8  mov      x20, x0
0x000068cc  ldr      x0, [x21, #0x468] ; -> [classref(NSDictionary)]
0x000068d0  bl       #0xd47c ; call stub:_objc_opt_class
0x000068d4  mov      x1, x0
0x000068d8  mov      x0, x20
0x000068dc  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x000068e0  tbz      w0, #0, #0x6b04
0x000068e4  movi     v0.16b, #0
0x000068e8  stp      q0, q0, [sp, #0x40]
0x000068ec  stp      q0, q0, [sp, #0x20]
0x000068f0  mov      x0, x20
0x000068f4  bl       #0xd4c4 ; call stub:_objc_retain
0x000068f8  add      x2, sp, #0x20
0x000068fc  add      x3, sp, #0xa0
0x00006900  mov      x0, x20
0x00006904  mov      w4, #0x10
0x00006908  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000690c  cbz      x0, #0x6af4
0x00006910  mov      x28, x0
0x00006914  ldr      x8, [sp, #0x30]
0x00006918  ldr      x22, [x8] ; -> [got(___objc_personality_v0)]
0x0000691c  str      x23, [sp, #0x10]
0x00006920  mov      x21, #0
0x00006924  ldr      x8, [sp, #0x30]
0x00006928  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x0000692c  cmp      x8, x22
0x00006930  b.eq     #0x693c
0x00006934  mov      x0, x20
0x00006938  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x0000693c  ldr      x8, [sp, #0x28]
0x00006940  ldr      x26, [x8, x21, lsl #3] ; -> [got(___objc_personality_v0)]
0x00006944  ldr      x0, [x24, #0x3f0] ; -> [classref(NSString)]
0x00006948  bl       #0xd47c ; call stub:_objc_opt_class
0x0000694c  mov      x1, x0
0x00006950  mov      x0, x26
0x00006954  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x00006958  tbz      w0, #0, #0x6ac0
0x0000695c  mov      x19, x24
0x00006960  mov      x0, x26
0x00006964  bl       #0xdd20 ; call objc_stub[lowercaseString]
0x00006968  mov      x29, x29
0x0000696c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006970  mov      x27, x0
0x00006974  mov      x0, x20
0x00006978  mov      x2, x26
0x0000697c  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x00006980  mov      x29, x29
0x00006984  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006988  mov      x24, x0
0x0000698c  bl       #0xda60 ; call objc_stub[description]
0x00006990  mov      x29, x29
0x00006994  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006998  mov      x23, x0
0x0000699c  bl       #0xdd20 ; call objc_stub[lowercaseString]
0x000069a0  mov      x29, x29
0x000069a4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000069a8  mov      x26, x0
0x000069ac  mov      x0, x23
0x000069b0  bl       #0xd4b8 ; call stub:_objc_release
0x000069b4  mov      x0, x24
0x000069b8  bl       #0xd4b8 ; call stub:_objc_release
0x000069bc  mov      x0, x27
0x000069c0  adrp     x2, #0x15000
0x000069c4  add      x2, x2, #0x708 ; -> CFSTR("wireless")
0x000069c8  bl       #0xd920 ; call objc_stub[containsString:]
0x000069cc  cbz      w0, #0x69f8
0x000069d0  mov      x0, x26
0x000069d4  adrp     x2, #0x15000
0x000069d8  add      x2, x2, #0x728 ; -> CFSTR("1")
0x000069dc  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x000069e0  tbnz     w0, #0, #0x6b44
0x000069e4  mov      x0, x26
0x000069e8  adrp     x2, #0x15000
0x000069ec  add      x2, x2, #0x748 ; -> CFSTR("0")
0x000069f0  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x000069f4  cbnz     w0, #0x6b44
0x000069f8  mov      x0, x27
0x000069fc  adrp     x2, #0x15000
0x00006a00  add      x2, x2, #0x768 ; -> CFSTR("wired")
0x00006a04  bl       #0xd920 ; call objc_stub[containsString:]
0x00006a08  cbz      w0, #0x6a34
0x00006a0c  mov      x0, x26
0x00006a10  adrp     x2, #0x15000
0x00006a14  add      x2, x2, #0x728 ; -> CFSTR("1")
0x00006a18  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x00006a1c  tbnz     w0, #0, #0x6b5c
0x00006a20  mov      x0, x26
0x00006a24  adrp     x2, #0x15000
0x00006a28  add      x2, x2, #0x748 ; -> CFSTR("0")
0x00006a2c  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x00006a30  cbnz     w0, #0x6b5c
0x00006a34  mov      x0, x27
0x00006a38  adrp     x2, #0x15000
0x00006a3c  add      x2, x2, #0x788 ; -> CFSTR("transport")
0x00006a40  bl       #0xd920 ; call objc_stub[containsString:]
0x00006a44  cbz      w0, #0x6aac
0x00006a48  mov      x0, x26
0x00006a4c  adrp     x2, #0x15000
0x00006a50  add      x2, x2, #0x7a8 ; -> CFSTR("wifi")
0x00006a54  bl       #0xd920 ; call objc_stub[containsString:]
0x00006a58  tbnz     w0, #0, #0x6b3c
0x00006a5c  mov      x0, x26
0x00006a60  adrp     x2, #0x15000
0x00006a64  add      x2, x2, #0x708 ; -> CFSTR("wireless")
0x00006a68  bl       #0xd920 ; call objc_stub[containsString:]
0x00006a6c  tbnz     w0, #0, #0x6b3c
0x00006a70  mov      x0, x26
0x00006a74  adrp     x2, #0x15000
0x00006a78  add      x2, x2, #0x7c8 ; -> CFSTR("wi-fi")
0x00006a7c  bl       #0xd920 ; call objc_stub[containsString:]
0x00006a80  tbnz     w0, #0, #0x6b3c
0x00006a84  mov      x0, x26
0x00006a88  adrp     x2, #0x15000
0x00006a8c  add      x2, x2, #0x7e8 ; -> CFSTR("usb")
0x00006a90  bl       #0xd920 ; call objc_stub[containsString:]
0x00006a94  tbnz     w0, #0, #0x6b74
0x00006a98  mov      x0, x26
0x00006a9c  adrp     x2, #0x15000
0x00006aa0  add      x2, x2, #0x768 ; -> CFSTR("wired")
0x00006aa4  bl       #0xd920 ; call objc_stub[containsString:]
0x00006aa8  tbnz     w0, #0, #0x6b74
0x00006aac  mov      x0, x26
0x00006ab0  bl       #0xd4b8 ; call stub:_objc_release
0x00006ab4  mov      x0, x27
0x00006ab8  bl       #0xd4b8 ; call stub:_objc_release
0x00006abc  mov      x24, x19
0x00006ac0  add      x21, x21, #1 ; -> __DATA,__objc_selrefs+0x1
0x00006ac4  cmp      x28, x21
0x00006ac8  b.ne     #0x6924
0x00006acc  add      x2, sp, #0x20
0x00006ad0  add      x3, sp, #0xa0
0x00006ad4  mov      x0, x20
0x00006ad8  mov      w4, #0x10
0x00006adc  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00006ae0  mov      x28, x0
0x00006ae4  adrp     x21, #0x18000
0x00006ae8  ldp      x23, x19, [sp, #0x10]
0x00006aec  ldr      x26, [sp, #8]
0x00006af0  cbnz     x0, #0x6920
0x00006af4  mov      x0, x20
0x00006af8  bl       #0xd4b8 ; call stub:_objc_release
0x00006afc  adrp     x22, #0x17000
0x00006b00  add      x22, x22, #0x60 ; -> __DATA_CONST,__objc_arrayobj+0x48 (const collection)
0x00006b04  mov      x0, x20
0x00006b08  bl       #0xd4b8 ; call stub:_objc_release
0x00006b0c  add      x25, x25, #1
0x00006b10  cmp      x25, x23
0x00006b14  b.ne     #0x6898
0x00006b18  add      x2, sp, #0x60
0x00006b1c  sub      x3, x29, #0xe0
0x00006b20  mov      x0, x22
0x00006b24  mov      w4, #0x10
0x00006b28  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00006b2c  mov      x23, x0
0x00006b30  cbnz     x0, #0x6894
0x00006b34  mov      w21, #-1
0x00006b38  b        #0x6b9c
0x00006b3c  mov      w21, #1
0x00006b40  b        #0x6b78
0x00006b44  adrp     x2, #0x15000
0x00006b48  add      x2, x2, #0x728 ; -> CFSTR("1")
0x00006b4c  mov      x0, x26
0x00006b50  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x00006b54  mov      x21, x0
0x00006b58  b        #0x6b78
0x00006b5c  adrp     x2, #0x15000
0x00006b60  add      x2, x2, #0x728 ; -> CFSTR("1")
0x00006b64  mov      x0, x26
0x00006b68  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x00006b6c  eor      w21, w0, #1
0x00006b70  b        #0x6b78
0x00006b74  mov      w21, #0
0x00006b78  mov      x0, x26
0x00006b7c  bl       #0xd4b8 ; call stub:_objc_release
0x00006b80  mov      x0, x27
0x00006b84  bl       #0xd4b8 ; call stub:_objc_release
0x00006b88  mov      x0, x20
0x00006b8c  bl       #0xd4b8 ; call stub:_objc_release
0x00006b90  mov      x0, x20
0x00006b94  bl       #0xd4b8 ; call stub:_objc_release
0x00006b98  ldr      x19, [sp, #0x18]
0x00006b9c  mov      x0, x19
0x00006ba0  bl       #0xd4b8 ; call stub:_objc_release
0x00006ba4  ldur     x8, [x29, #-0x60]
0x00006ba8  adrp     x9, #0x14000
0x00006bac  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x00006bb0  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x00006bb4  cmp      x9, x8
0x00006bb8  b.ne     #0x6be0
0x00006bbc  mov      x0, x21
0x00006bc0  add      sp, sp, #0x1b0
0x00006bc4  ldp      x29, x30, [sp, #0x50]
0x00006bc8  ldp      x20, x19, [sp, #0x40]
0x00006bcc  ldp      x22, x21, [sp, #0x30]
0x00006bd0  ldp      x24, x23, [sp, #0x20]
0x00006bd4  ldp      x26, x25, [sp, #0x10]
0x00006bd8  ldp      x28, x27, [sp], #0x60
0x00006bdc  ret      
0x00006be0  bl       #0xd1b8 ; call stub:___stack_chk_fail
