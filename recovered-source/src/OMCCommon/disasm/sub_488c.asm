; === sub_488c @ 0x488c size=984 ===
0x0000488c  sub      sp, sp, #0x180
0x00004890  stp      x28, x27, [sp, #0x120]
0x00004894  stp      x26, x25, [sp, #0x130]
0x00004898  stp      x24, x23, [sp, #0x140]
0x0000489c  stp      x22, x21, [sp, #0x150]
0x000048a0  stp      x20, x19, [sp, #0x160]
0x000048a4  stp      x29, x30, [sp, #0x170]
0x000048a8  add      x29, sp, #0x170
0x000048ac  adrp     x8, #0x14000
0x000048b0  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x000048b4  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x000048b8  stur     x8, [x29, #-0x60]
0x000048bc  bl       #0x6528 ; call _OMCPrefsSync
0x000048c0  adrp     x0, #0x14000
0x000048c4  add      x0, x0, #0xa48 ; -> CFSTR("rescueFeatures")
0x000048c8  mov      x1, #0
0x000048cc  bl       #0x6534 ; call _OMCPref
0x000048d0  mov      x29, x29
0x000048d4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000048d8  mov      x19, x0
0x000048dc  adrp     x8, #0x18000
0x000048e0  ldr      x0, [x8, #0x450] ; -> [classref(NSArray)]
0x000048e4  bl       #0xd47c ; call stub:_objc_opt_class
0x000048e8  mov      x1, x0
0x000048ec  mov      x0, x19
0x000048f0  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x000048f4  tbz      w0, #0, #0x4c20
0x000048f8  mov      x0, x19
0x000048fc  bl       #0xd960 ; call objc_stub[count]
0x00004900  cbz      x0, #0x4c20
0x00004904  adrp     x8, #0x18000
0x00004908  ldr      x0, [x8, #0x458] ; -> [classref(NSMutableArray)]
0x0000490c  bl       #0xd740 ; call objc_stub[array]
0x00004910  mov      x29, x29
0x00004914  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00004918  mov      x20, x0
0x0000491c  movi     v0.16b, #0
0x00004920  stp      q0, q0, [sp, #0x50]
0x00004924  stp      q0, q0, [sp, #0x70]
0x00004928  mov      x0, x19
0x0000492c  bl       #0xd4c4 ; call stub:_objc_retain
0x00004930  add      x2, sp, #0x50
0x00004934  add      x3, sp, #0x90
0x00004938  mov      x0, x19
0x0000493c  mov      w4, #0x10
0x00004940  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00004944  cbz      x0, #0x4a90
0x00004948  mov      x23, x0
0x0000494c  adrp     x21, #0x14000
0x00004950  add      x21, x21, #0xb48 ; -> CFSTR("splitScreen")
0x00004954  ldr      x8, [sp, #0x60]
0x00004958  ldr      x28, [x8] ; -> [selref(CGContext)]
0x0000495c  adrp     x24, #0x14000
0x00004960  add      x24, x24, #0xb88 ; -> CFSTR("Split Screen")
0x00004964  adrp     x25, #0x14000
0x00004968  add      x25, x25, #0xba8 ; -> CFSTR("startupScreen")
0x0000496c  mov      x22, #0
0x00004970  ldr      x8, [sp, #0x60]
0x00004974  ldr      x8, [x8] ; -> [selref(CGContext)]
0x00004978  cmp      x8, x28
0x0000497c  b.eq     #0x4988
0x00004980  mov      x0, x19
0x00004984  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x00004988  ldr      x8, [sp, #0x58]
0x0000498c  ldr      x27, [x8, x22, lsl #3] ; -> [selref(CGContext)]
0x00004990  mov      x0, x27
0x00004994  bl       #0xd4c4 ; call stub:_objc_retain
0x00004998  mov      x0, x27
0x0000499c  mov      x2, x21
0x000049a0  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x000049a4  cbz      w0, #0x49b8
0x000049a8  adrp     x0, #0x14000
0x000049ac  add      x0, x0, #0xb68 ; -> CFSTR("C")
0x000049b0  mov      x1, x24
0x000049b4  b        #0x4a28
0x000049b8  mov      x0, x27
0x000049bc  mov      x2, x25
0x000049c0  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x000049c4  cbz      w0, #0x49dc
0x000049c8  adrp     x0, #0x14000
0x000049cc  add      x0, x0, #0xbc8 ; -> CFSTR("M")
0x000049d0  adrp     x1, #0x14000
0x000049d4  add      x1, x1, #0xbe8 ; -> CFSTR("Startup Screen")
0x000049d8  b        #0x4a28
0x000049dc  mov      x0, x27
0x000049e0  adrp     x2, #0x14000
0x000049e4  add      x2, x2, #0xc08 ; -> CFSTR("speedBubble")
0x000049e8  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x000049ec  cbz      w0, #0x4a04
0x000049f0  adrp     x0, #0x14000
0x000049f4  add      x0, x0, #0xc28 ; -> CFSTR("B")
0x000049f8  adrp     x1, #0x14000
0x000049fc  add      x1, x1, #0xc48 ; -> CFSTR("Speed Bubble")
0x00004a00  b        #0x4a28
0x00004a04  mov      x0, x27
0x00004a08  adrp     x2, #0x14000
0x00004a0c  add      x2, x2, #0xc68 ; -> CFSTR("appBridge")
0x00004a10  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x00004a14  cbz      w0, #0x4a64
0x00004a18  adrp     x0, #0x14000
0x00004a1c  add      x0, x0, #0xc88 ; -> CFSTR("A")
0x00004a20  adrp     x1, #0x14000
0x00004a24  add      x1, x1, #0xca8 ; -> CFSTR("Apps on the car screen")
0x00004a28  bl       #0xc8c0 ; call _OMCTr
0x00004a2c  mov      x29, x29
0x00004a30  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00004a34  mov      x26, x0
0x00004a38  mov      x0, x27
0x00004a3c  bl       #0xd4b8 ; call stub:_objc_release
0x00004a40  mov      x0, x20
0x00004a44  mov      x2, x26
0x00004a48  bl       #0xd6a0 ; call objc_stub[addObject:]
0x00004a4c  mov      x0, x26
0x00004a50  bl       #0xd4b8 ; call stub:_objc_release
0x00004a54  add      x22, x22, #1
0x00004a58  cmp      x23, x22
0x00004a5c  b.ne     #0x4970
0x00004a60  b        #0x4a74
0x00004a64  mov      x0, x27
0x00004a68  bl       #0xd4c4 ; call stub:_objc_retain
0x00004a6c  mov      x26, x27
0x00004a70  b        #0x4a38
0x00004a74  add      x2, sp, #0x50
0x00004a78  add      x3, sp, #0x90
0x00004a7c  mov      x0, x19
0x00004a80  mov      w4, #0x10
0x00004a84  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00004a88  mov      x23, x0
0x00004a8c  cbnz     x0, #0x496c
0x00004a90  mov      x0, x19
0x00004a94  bl       #0xd4b8 ; call stub:_objc_release
0x00004a98  adrp     x2, #0x14000
0x00004a9c  add      x2, x2, #0xa68 ; -> CFSTR(", ")
0x00004aa0  mov      x0, x20
0x00004aa4  bl       #0xd880 ; call objc_stub[componentsJoinedByString:]
0x00004aa8  mov      x29, x29
0x00004aac  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00004ab0  mov      x21, x0
0x00004ab4  adrp     x0, #0x14000
0x00004ab8  add      x0, x0, #0xa88 ; -> CFSTR("O")
0x00004abc  adrp     x1, #0x14000
0x00004ac0  add      x1, x1, #0xaa8 ; -> CFSTR("OmniCar: rescue mode")
0x00004ac4  bl       #0xc8c0 ; call _OMCTr
0x00004ac8  mov      x29, x29
0x00004acc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00004ad0  mov      x22, x0
0x00004ad4  adrp     x25, #0x18000
0x00004ad8  ldr      x23, [x25, #0x3f0] ; -> [classref(NSString)]
0x00004adc  adrp     x0, #0x14000
0x00004ae0  add      x0, x0, #0xac8 ; -> CFSTR("C")
0x00004ae4  adrp     x1, #0x14000
0x00004ae8  add      x1, x1, #0xae8 ; -> CFSTR("CarPlay crashed %d times in a row right after connecting, so OmniCar turned off: %@.

Open Settings > OmniCar to turn it back on or send the log to the developer.")
0x00004aec  bl       #0xc8c0 ; call _OMCTr
0x00004af0  mov      x29, x29
0x00004af4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00004af8  mov      x24, x0
0x00004afc  mov      w8, #2
0x00004b00  stp      x8, x21, [sp]
0x00004b04  mov      x0, x23
0x00004b08  mov      x2, x24
0x00004b0c  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00004b10  mov      x29, x29
0x00004b14  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00004b18  mov      x23, x0
0x00004b1c  mov      x0, x24
0x00004b20  bl       #0xd4b8 ; call stub:_objc_release
0x00004b24  adrp     x1, #0xe000
0x00004b28  add      x1, x1, #0x96c ; -> "CFUserNotificationDisplayNotice"
0x00004b2c  mov      x0, #-2
0x00004b30  bl       #0xd2fc ; call stub:_dlsym
0x00004b34  mov      x24, x0
0x00004b38  ldr      x0, [x25, #0x3f0] ; -> [classref(NSString)]
0x00004b3c  cmp      x24, #0
0x00004b40  cset     w8, ne
0x00004b44  stp      x21, x8, [sp]
0x00004b48  adrp     x2, #0x14000
0x00004b4c  add      x2, x2, #0xb08 ; -> CFSTR("thong bao che do cuu: %@ (notice=%d)")
0x00004b50  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00004b54  mov      x29, x29
0x00004b58  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00004b5c  mov      x25, x0
0x00004b60  adrp     x0, #0x14000
0x00004b64  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x00004b68  mov      x1, x25
0x00004b6c  bl       #0x6be4 ; call _OMCLogWrite
0x00004b70  mov      x0, x25
0x00004b74  bl       #0xd4b8 ; call stub:_objc_release
0x00004b78  cbz      x24, #0x4c00
0x00004b7c  mov      w0, #0x19
0x00004b80  mov      x1, #0
0x00004b84  bl       #0xd278 ; call stub:_dispatch_get_global_queue
0x00004b88  mov      x29, x29
0x00004b8c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00004b90  mov      x25, x0
0x00004b94  adrp     x8, #0x14000
0x00004b98  ldr      x8, [x8, #0x1a0] ; -> [got(__NSConcreteStackBlock)]
0x00004b9c  str      x8, [sp, #0x18]
0x00004ba0  adrp     x8, #0xf000
0x00004ba4  ldr      d0, [x8, #0xab8] ; -> [__TEXT,__const+0x8 [u64=0xc2000000 f64=1.6080749353e-314]]
0x00004ba8  adrp     x8, #0x6000
0x00004bac  add      x8, x8, #0 ; -> __TEXT,__text+0x2000
0x00004bb0  str      d0, [sp, #0x20]
0x00004bb4  adrp     x9, #0x14000
0x00004bb8  add      x9, x9, #0x618 ; -> __DATA_CONST,__const+0x210 [u64=0x0 f64=0.0]
0x00004bbc  stp      x8, x9, [sp, #0x28]
0x00004bc0  str      x24, [sp, #0x48]
0x00004bc4  mov      x0, x22
0x00004bc8  bl       #0xd4c4 ; call stub:_objc_retain
0x00004bcc  str      x22, [sp, #0x38]
0x00004bd0  mov      x0, x23
0x00004bd4  bl       #0xd4c4 ; call stub:_objc_retain
0x00004bd8  str      x23, [sp, #0x40]
0x00004bdc  add      x1, sp, #0x18
0x00004be0  mov      x0, x25
0x00004be4  bl       #0xd26c ; call stub:_dispatch_async
0x00004be8  mov      x0, x25
0x00004bec  bl       #0xd4b8 ; call stub:_objc_release
0x00004bf0  ldr      x0, [sp, #0x40]
0x00004bf4  bl       #0xd4b8 ; call stub:_objc_release
0x00004bf8  ldr      x0, [sp, #0x38]
0x00004bfc  bl       #0xd4b8 ; call stub:_objc_release
0x00004c00  mov      x0, x23
0x00004c04  bl       #0xd4b8 ; call stub:_objc_release
0x00004c08  mov      x0, x22
0x00004c0c  bl       #0xd4b8 ; call stub:_objc_release
0x00004c10  mov      x0, x21
0x00004c14  bl       #0xd4b8 ; call stub:_objc_release
0x00004c18  mov      x0, x20
0x00004c1c  bl       #0xd4b8 ; call stub:_objc_release
0x00004c20  mov      x0, x19
0x00004c24  bl       #0xd4b8 ; call stub:_objc_release
0x00004c28  ldur     x8, [x29, #-0x60]
0x00004c2c  adrp     x9, #0x14000
0x00004c30  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x00004c34  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x00004c38  cmp      x9, x8
0x00004c3c  b.ne     #0x4c60
0x00004c40  ldp      x29, x30, [sp, #0x170]
0x00004c44  ldp      x20, x19, [sp, #0x160]
0x00004c48  ldp      x22, x21, [sp, #0x150]
0x00004c4c  ldp      x24, x23, [sp, #0x140]
0x00004c50  ldp      x26, x25, [sp, #0x130]
0x00004c54  ldp      x28, x27, [sp, #0x120]
0x00004c58  add      sp, sp, #0x180
0x00004c5c  ret      
0x00004c60  bl       #0xd1b8 ; call stub:___stack_chk_fail
