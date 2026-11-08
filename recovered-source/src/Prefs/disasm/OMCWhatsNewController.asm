=== +[OMCWhatsNewController shouldShow]  va=0x19808 size=900 types=B16@0:8
0x00019808  stp      x22, x21, [sp, #-0x30]!
0x0001980c  stp      x20, x19, [sp, #0x10]
0x00019810  stp      x29, x30, [sp, #0x20]
0x00019814  add      x29, sp, #0x20
0x00019818  adrp     x19, #0x75000
0x0001981c  add      x19, x19, #0x28   ; STR "com.anlai.omnicar"
0x00019820  mov      x0, x19
0x00019824  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x00019828  adrp     x0, #0x78000
0x0001982c  add      x0, x0, #0xf88   ; STR "whatsNewSeen"
0x00019830  mov      x1, x19
0x00019834  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x00019838  mov      x19, x0
0x0001983c  adrp     x8, #0x8e000
0x00019840  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00019844  bl       #0x55d48   ; CALL _objc_opt_class
0x00019848  mov      x1, x0
0x0001984c  mov      x0, x19
0x00019850  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00019854  tbz      w0, #0, #0x19874
0x00019858  adrp     x2, #0x75000
0x0001985c  add      x2, x2, #0xc28   ; STR "1.0.3"
0x00019860  mov      x0, x19
0x00019864  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00019868  tbz      w0, #0, #0x19874
0x0001986c  mov      w20, #0
0x00019870  b        #0x198a8
0x00019874  bl       #0x19ab0
0x00019878  mov      x29, x29
0x0001987c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019880  mov      x21, x0
0x00019884  mov      w1, #1
0x00019888  bl       #0x198c4
0x0001988c  mov      x29, x29
0x00019890  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019894  cmp      x0, #0
0x00019898  cset     w20, ne
0x0001989c  bl       #0x55d78   ; CALL _objc_release
0x000198a0  mov      x0, x21
0x000198a4  bl       #0x55d78   ; CALL _objc_release
0x000198a8  mov      x0, x19
0x000198ac  bl       #0x55d78   ; CALL _objc_release
0x000198b0  mov      x0, x20
0x000198b4  ldp      x29, x30, [sp, #0x20]
0x000198b8  ldp      x20, x19, [sp, #0x10]
0x000198bc  ldp      x22, x21, [sp], #0x30
0x000198c0  ret      
0x000198c4  sub      sp, sp, #0x130
0x000198c8  stp      x28, x27, [sp, #0xd0]
0x000198cc  stp      x26, x25, [sp, #0xe0]
0x000198d0  stp      x24, x23, [sp, #0xf0]
0x000198d4  stp      x22, x21, [sp, #0x100]
0x000198d8  stp      x20, x19, [sp, #0x110]
0x000198dc  stp      x29, x30, [sp, #0x120]
0x000198e0  add      x29, sp, #0x120
0x000198e4  mov      x21, x1
0x000198e8  mov      x19, x0
0x000198ec  adrp     x8, #0x74000
0x000198f0  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000198f4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000198f8  stur     x8, [x29, #-0x58]
0x000198fc  bl       #0x55d84   ; CALL _objc_retain
0x00019900  adrp     x20, #0x75000
0x00019904  add      x20, x20, #0xc28   ; STR "1.0.3"
0x00019908  mov      x0, x19
0x0001990c  mov      x2, x20
0x00019910  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00019914  mov      x29, x29
0x00019918  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001991c  mov      x22, x0
0x00019920  adrp     x25, #0x8e000
0x00019924  ldr      x0, [x25, #0x960]   ; @CLASS NSArray
0x00019928  bl       #0x55d48   ; CALL _objc_opt_class
0x0001992c  mov      x1, x0
0x00019930  mov      x0, x22
0x00019934  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00019938  mov      x23, x0
0x0001993c  mov      x0, x22
0x00019940  bl       #0x55d78   ; CALL _objc_release
0x00019944  ands     w8, w23, #1
0x00019948  csel     x20, x20, xzr, ne
0x0001994c  cbnz     w8, #0x19a68
0x00019950  tbnz     w21, #0, #0x19a68
0x00019954  movi     v0.16b, #0
0x00019958  stp      q0, q0, [sp, #0x20]
0x0001995c  stp      q0, q0, [sp]
0x00019960  mov      x0, x19
0x00019964  bl       #0x55d84   ; CALL _objc_retain
0x00019968  mov      x2, sp
0x0001996c  add      x3, sp, #0x48
0x00019970  mov      x0, x19
0x00019974  mov      w4, #0x10
0x00019978  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001997c  cbz      x0, #0x19a5c
0x00019980  mov      x21, x0
0x00019984  mov      x20, #0
0x00019988  ldr      x8, [sp, #0x10]
0x0001998c  ldr      x26, [x8]   ; @GOT ___objc_personality_v0
0x00019990  mov      x27, #0
0x00019994  ldr      x8, [sp, #0x10]
0x00019998  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001999c  cmp      x8, x26
0x000199a0  b.eq     #0x199ac
0x000199a4  mov      x0, x19
0x000199a8  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x000199ac  ldr      x8, [sp, #8]
0x000199b0  ldr      x22, [x8, x27, lsl #3]   ; @GOT ___objc_personality_v0
0x000199b4  mov      x0, x19
0x000199b8  mov      x2, x22
0x000199bc  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000199c0  mov      x29, x29
0x000199c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000199c8  mov      x23, x0
0x000199cc  ldr      x0, [x25, #0x960]   ; @CLASS NSArray
0x000199d0  bl       #0x55d48   ; CALL _objc_opt_class
0x000199d4  mov      x1, x0
0x000199d8  mov      x0, x23
0x000199dc  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x000199e0  tbz      w0, #0, #0x19a28
0x000199e4  cbz      x20, #0x19a10
0x000199e8  mov      x0, x22
0x000199ec  mov      x2, x20
0x000199f0  mov      w3, #0x40
0x000199f4  bl       #0x56f80   ; CALL objc_msgSend$compare:options:
0x000199f8  mov      x24, x0
0x000199fc  mov      x0, x23
0x00019a00  bl       #0x55d78   ; CALL _objc_release
0x00019a04  cmp      x24, #1
0x00019a08  b.eq     #0x19a18
0x00019a0c  b        #0x19a30
0x00019a10  mov      x0, x23
0x00019a14  bl       #0x55d78   ; CALL _objc_release
0x00019a18  mov      x0, x22
0x00019a1c  bl       #0x55d84   ; CALL _objc_retain
0x00019a20  mov      x23, x20
0x00019a24  mov      x20, x22
0x00019a28  mov      x0, x23
0x00019a2c  bl       #0x55d78   ; CALL _objc_release
0x00019a30  add      x27, x27, #1
0x00019a34  cmp      x21, x27
0x00019a38  b.ne     #0x19994
0x00019a3c  mov      x2, sp
0x00019a40  add      x3, sp, #0x48
0x00019a44  mov      x0, x19
0x00019a48  mov      w4, #0x10
0x00019a4c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00019a50  mov      x21, x0
0x00019a54  cbnz     x0, #0x19990
0x00019a58  b        #0x19a60
0x00019a5c  mov      x20, #0
0x00019a60  mov      x0, x19
0x00019a64  bl       #0x55d78   ; CALL _objc_release
0x00019a68  mov      x0, x19
0x00019a6c  bl       #0x55d78   ; CALL _objc_release
0x00019a70  ldur     x8, [x29, #-0x58]
0x00019a74  adrp     x9, #0x74000
0x00019a78  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00019a7c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00019a80  cmp      x9, x8
0x00019a84  b.ne     #0x19aac
0x00019a88  mov      x0, x20
0x00019a8c  ldp      x29, x30, [sp, #0x120]
0x00019a90  ldp      x20, x19, [sp, #0x110]
0x00019a94  ldp      x22, x21, [sp, #0x100]
0x00019a98  ldp      x24, x23, [sp, #0xf0]
0x00019a9c  ldp      x26, x25, [sp, #0xe0]
0x00019aa0  ldp      x28, x27, [sp, #0xd0]
0x00019aa4  add      sp, sp, #0x130
0x00019aa8  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00019aac  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00019ab0  stp      x22, x21, [sp, #-0x30]!
0x00019ab4  stp      x20, x19, [sp, #0x10]
0x00019ab8  stp      x29, x30, [sp, #0x20]
0x00019abc  add      x29, sp, #0x20
0x00019ac0  adrp     x8, #0x8e000
0x00019ac4  ldr      x19, [x8, #0x9d8]   ; @CLASS NSBundle
0x00019ac8  adrp     x8, #0x8e000
0x00019acc  ldr      x0, [x8, #0xad0]   ; @CLASS OMCWhatsNewController
0x00019ad0  bl       #0x55d48   ; CALL _objc_opt_class
0x00019ad4  mov      x2, x0
0x00019ad8  mov      x0, x19
0x00019adc  bl       #0x56b40   ; CALL objc_msgSend$bundleForClass:
0x00019ae0  mov      x29, x29
0x00019ae4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019ae8  mov      x19, x0
0x00019aec  adrp     x2, #0x79000
0x00019af0  add      x2, x2, #0x48   ; STR "WhatsNew"
0x00019af4  adrp     x3, #0x76000
0x00019af8  add      x3, x3, #0xf48   ; STR "plist"
0x00019afc  bl       #0x59640   ; CALL objc_msgSend$pathForResource:ofType:
0x00019b00  mov      x29, x29
0x00019b04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019b08  mov      x20, x0
0x00019b0c  adrp     x22, #0x8e000
0x00019b10  cbz      x0, #0x19b30
0x00019b14  ldr      x0, [x22, #0x970]   ; @CLASS NSDictionary
0x00019b18  mov      x2, x20
0x00019b1c  bl       #0x577a0   ; CALL objc_msgSend$dictionaryWithContentsOfFile:
0x00019b20  mov      x29, x29
0x00019b24  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019b28  mov      x21, x0
0x00019b2c  b        #0x19b34
0x00019b30  mov      x21, #0
0x00019b34  ldr      x0, [x22, #0x970]   ; @CLASS NSDictionary
0x00019b38  bl       #0x55d48   ; CALL _objc_opt_class
0x00019b3c  mov      x1, x0
0x00019b40  mov      x0, x21
0x00019b44  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00019b48  adrp     x8, #0x74000
0x00019b4c  ldr      x8, [x8, #0x1a8]   ; @GOT ___NSDictionary0__struct
0x00019b50  tst      w0, #1
0x00019b54  csel     x22, x21, x8, ne
0x00019b58  mov      x0, x22
0x00019b5c  bl       #0x55d84   ; CALL _objc_retain
0x00019b60  mov      x0, x21
0x00019b64  bl       #0x55d78   ; CALL _objc_release
0x00019b68  mov      x0, x20
0x00019b6c  bl       #0x55d78   ; CALL _objc_release
0x00019b70  mov      x0, x19
0x00019b74  bl       #0x55d78   ; CALL _objc_release
0x00019b78  mov      x0, x22
0x00019b7c  ldp      x29, x30, [sp, #0x20]
0x00019b80  ldp      x20, x19, [sp, #0x10]
0x00019b84  ldp      x22, x21, [sp], #0x30
0x00019b88  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== +[OMCWhatsNewController markSeen]  va=0x19b8c size=60 types=v16@0:8
0x00019b8c  stp      x20, x19, [sp, #-0x20]!
0x00019b90  stp      x29, x30, [sp, #0x10]
0x00019b94  add      x29, sp, #0x10
0x00019b98  adrp     x0, #0x78000
0x00019b9c  add      x0, x0, #0xf88   ; STR "whatsNewSeen"
0x00019ba0  adrp     x1, #0x75000
0x00019ba4  add      x1, x1, #0xc28   ; STR "1.0.3"
0x00019ba8  adrp     x19, #0x75000
0x00019bac  add      x19, x19, #0x28   ; STR "com.anlai.omnicar"
0x00019bb0  mov      x2, x19
0x00019bb4  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x00019bb8  mov      x0, x19
0x00019bbc  ldp      x29, x30, [sp, #0x10]
0x00019bc0  ldp      x20, x19, [sp], #0x20
0x00019bc4  b        #0x55850   ; CALL _CFPreferencesAppSynchronize

=== +[OMCWhatsNewController whatsNewNavigationController]  va=0x19bc8 size=576 types=@16@0:8
0x00019bc8  sub      sp, sp, #0x130
0x00019bcc  stp      x28, x27, [sp, #0xd0]
0x00019bd0  stp      x26, x25, [sp, #0xe0]
0x00019bd4  stp      x24, x23, [sp, #0xf0]
0x00019bd8  stp      x22, x21, [sp, #0x100]
0x00019bdc  stp      x20, x19, [sp, #0x110]
0x00019be0  stp      x29, x30, [sp, #0x120]
0x00019be4  add      x29, sp, #0x120
0x00019be8  adrp     x8, #0x74000
0x00019bec  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00019bf0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00019bf4  stur     x8, [x29, #-0x58]
0x00019bf8  bl       #0x58f40   ; CALL objc_msgSend$markSeen
0x00019bfc  adrp     x8, #0x8e000
0x00019c00  ldr      x0, [x8, #0xad0]   ; @CLASS OMCWhatsNewController
0x00019c04  bl       #0x55d60   ; CALL _objc_opt_new
0x00019c08  mov      x19, x0
0x00019c0c  bl       #0x19ab0
0x00019c10  mov      x29, x29
0x00019c14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019c18  mov      x20, x0
0x00019c1c  mov      w1, #0
0x00019c20  bl       #0x198c4
0x00019c24  mov      x29, x29
0x00019c28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019c2c  mov      x21, x0
0x00019c30  adrp     x8, #0x75000
0x00019c34  add      x8, x8, #0xc28   ; STR "1.0.3"
0x00019c38  cmp      x0, #0
0x00019c3c  csel     x2, x8, x0, eq
0x00019c40  mov      x0, x19
0x00019c44  bl       #0x5c7c0   ; CALL objc_msgSend$setVersion:
0x00019c48  mov      x0, x21
0x00019c4c  bl       #0x55d78   ; CALL _objc_release
0x00019c50  adrp     x8, #0x8e000
0x00019c54  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00019c58  bl       #0x565c0   ; CALL objc_msgSend$array
0x00019c5c  mov      x29, x29
0x00019c60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019c64  mov      x21, x0
0x00019c68  movi     v0.16b, #0
0x00019c6c  stp      q0, q0, [sp]
0x00019c70  stp      q0, q0, [sp, #0x20]
0x00019c74  mov      x0, x19
0x00019c78  bl       #0x5df00   ; CALL objc_msgSend$version
0x00019c7c  mov      x29, x29
0x00019c80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019c84  mov      x23, x0
0x00019c88  mov      x0, x20
0x00019c8c  mov      x2, x23
0x00019c90  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00019c94  mov      x29, x29
0x00019c98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019c9c  mov      x22, x0
0x00019ca0  mov      x0, x23
0x00019ca4  bl       #0x55d78   ; CALL _objc_release
0x00019ca8  mov      x2, sp
0x00019cac  add      x3, sp, #0x48
0x00019cb0  mov      x0, x22
0x00019cb4  mov      w4, #0x10
0x00019cb8  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00019cbc  cbz      x0, #0x19d40
0x00019cc0  mov      x23, x0
0x00019cc4  ldr      x8, [sp, #0x10]
0x00019cc8  ldr      x25, [x8]   ; @SEL "whatsNewNavigationController"
0x00019ccc  adrp     x26, #0x8e000
0x00019cd0  mov      x27, #0
0x00019cd4  ldr      x8, [sp, #0x10]
0x00019cd8  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00019cdc  cmp      x8, x25
0x00019ce0  b.eq     #0x19cec
0x00019ce4  mov      x0, x22
0x00019ce8  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00019cec  ldr      x8, [sp, #8]
0x00019cf0  ldr      x24, [x8, x27, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00019cf4  ldr      x0, [x26, #0x970]   ; @CLASS NSDictionary
0x00019cf8  bl       #0x55d48   ; CALL _objc_opt_class
0x00019cfc  mov      x1, x0
0x00019d00  mov      x0, x24
0x00019d04  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00019d08  tbz      w0, #0, #0x19d18
0x00019d0c  mov      x0, x21
0x00019d10  mov      x2, x24
0x00019d14  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00019d18  add      x27, x27, #1
0x00019d1c  cmp      x23, x27
0x00019d20  b.ne     #0x19cd4
0x00019d24  mov      x2, sp
0x00019d28  add      x3, sp, #0x48
0x00019d2c  mov      x0, x22
0x00019d30  mov      w4, #0x10
0x00019d34  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00019d38  mov      x23, x0
0x00019d3c  cbnz     x0, #0x19cd0
0x00019d40  mov      x0, x22
0x00019d44  bl       #0x55d78   ; CALL _objc_release
0x00019d48  mov      x0, x19
0x00019d4c  mov      x2, x21
0x00019d50  bl       #0x5b1c0   ; CALL objc_msgSend$setItems:
0x00019d54  adrp     x8, #0x8e000
0x00019d58  ldr      x0, [x8, #0xa28]   ; @CLASS UINavigationController
0x00019d5c  bl       #0x55c7c   ; CALL _objc_alloc
0x00019d60  mov      x2, x19
0x00019d64  bl       #0x58520   ; CALL objc_msgSend$initWithRootViewController:
0x00019d68  mov      x22, x0
0x00019d6c  mov      w2, #1
0x00019d70  bl       #0x5b6c0   ; CALL objc_msgSend$setModalPresentationStyle:
0x00019d74  bl       #0x17e8c   ; CALL _OMCAccentColor
0x00019d78  mov      x29, x29
0x00019d7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019d80  mov      x23, x0
0x00019d84  mov      x0, x22
0x00019d88  bl       #0x59160   ; CALL objc_msgSend$navigationBar
0x00019d8c  mov      x29, x29
0x00019d90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019d94  mov      x24, x0
0x00019d98  mov      x2, x23
0x00019d9c  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x00019da0  mov      x0, x24
0x00019da4  bl       #0x55d78   ; CALL _objc_release
0x00019da8  mov      x0, x23
0x00019dac  bl       #0x55d78   ; CALL _objc_release
0x00019db0  mov      x0, x21
0x00019db4  bl       #0x55d78   ; CALL _objc_release
0x00019db8  mov      x0, x20
0x00019dbc  bl       #0x55d78   ; CALL _objc_release
0x00019dc0  mov      x0, x19
0x00019dc4  bl       #0x55d78   ; CALL _objc_release
0x00019dc8  ldur     x8, [x29, #-0x58]
0x00019dcc  adrp     x9, #0x74000
0x00019dd0  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00019dd4  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00019dd8  cmp      x9, x8
0x00019ddc  b.ne     #0x19e04
0x00019de0  mov      x0, x22
0x00019de4  ldp      x29, x30, [sp, #0x120]
0x00019de8  ldp      x20, x19, [sp, #0x110]
0x00019dec  ldp      x22, x21, [sp, #0x100]
0x00019df0  ldp      x24, x23, [sp, #0xf0]
0x00019df4  ldp      x26, x25, [sp, #0xe0]
0x00019df8  ldp      x28, x27, [sp, #0xd0]
0x00019dfc  add      sp, sp, #0x130
0x00019e00  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00019e04  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCWhatsNewController viewDidLoad]  va=0x19e08 size=3220 types=v16@0:8
0x00019e08  stp      x28, x27, [sp, #-0x60]!
0x00019e0c  stp      x26, x25, [sp, #0x10]
0x00019e10  stp      x24, x23, [sp, #0x20]
0x00019e14  stp      x22, x21, [sp, #0x30]
0x00019e18  stp      x20, x19, [sp, #0x40]
0x00019e1c  stp      x29, x30, [sp, #0x50]
0x00019e20  add      x29, sp, #0x50
0x00019e24  sub      sp, sp, #0x2d0
0x00019e28  mov      x25, x0
0x00019e2c  adrp     x8, #0x74000
0x00019e30  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00019e34  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00019e38  stur     x8, [x29, #-0x60]
0x00019e3c  adrp     x8, #0x8e000
0x00019e40  ldr      x8, [x8, #0xd40]   ; @SUPER OMCWhatsNewController
0x00019e44  stp      x0, x8, [sp, #0x1b8]
0x00019e48  adrp     x8, #0x8b000
0x00019e4c  ldr      x1, [x8, #0xda0]   ; @SEL "viewDidLoad"
0x00019e50  add      x0, sp, #0x1b8
0x00019e54  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00019e58  bl       #0x17a44   ; CALL _OMCLoadStrings
0x00019e5c  bl       #0x17fe4   ; CALL _OMCBackgroundColor
0x00019e60  mov      x29, x29
0x00019e64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019e68  mov      x19, x0
0x00019e6c  mov      x0, x25
0x00019e70  bl       #0x5df60   ; CALL objc_msgSend$view
0x00019e74  mov      x29, x29
0x00019e78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019e7c  mov      x20, x0
0x00019e80  mov      x2, x19
0x00019e84  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x00019e88  mov      x0, x20
0x00019e8c  bl       #0x55d78   ; CALL _objc_release
0x00019e90  mov      x0, x19
0x00019e94  bl       #0x55d78   ; CALL _objc_release
0x00019e98  bl       #0x17e8c   ; CALL _OMCAccentColor
0x00019e9c  mov      x29, x29
0x00019ea0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019ea4  mov      x19, x0
0x00019ea8  mov      x0, x25
0x00019eac  bl       #0x5df60   ; CALL objc_msgSend$view
0x00019eb0  mov      x29, x29
0x00019eb4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019eb8  mov      x20, x0
0x00019ebc  mov      x2, x19
0x00019ec0  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x00019ec4  mov      x0, x20
0x00019ec8  bl       #0x55d78   ; CALL _objc_release
0x00019ecc  mov      x0, x19
0x00019ed0  bl       #0x55d78   ; CALL _objc_release
0x00019ed4  adrp     x8, #0x8e000
0x00019ed8  ldr      x0, [x8, #0xa30]   ; @CLASS UIScrollView
0x00019edc  bl       #0x55d60   ; CALL _objc_opt_new
0x00019ee0  mov      x21, x0
0x00019ee4  mov      w2, #0
0x00019ee8  bl       #0x5c6c0   ; CALL objc_msgSend$setTranslatesAutoresizingMaskIntoConstraints:
0x00019eec  mov      x0, x21
0x00019ef0  mov      w2, #0
0x00019ef4  bl       #0x5c160   ; CALL objc_msgSend$setShowsVerticalScrollIndicator:
0x00019ef8  mov      x0, x25
0x00019efc  bl       #0x5df60   ; CALL objc_msgSend$view
0x00019f00  mov      x29, x29
0x00019f04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019f08  mov      x19, x0
0x00019f0c  mov      x2, x21
0x00019f10  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00019f14  mov      x0, x19
0x00019f18  bl       #0x55d78   ; CALL _objc_release
0x00019f1c  adrp     x8, #0x8e000
0x00019f20  ldr      x0, [x8, #0xa38]   ; @CLASS UIStackView
0x00019f24  bl       #0x55d60   ; CALL _objc_opt_new
0x00019f28  mov      x20, x0
0x00019f2c  mov      w2, #0
0x00019f30  bl       #0x5c6c0   ; CALL objc_msgSend$setTranslatesAutoresizingMaskIntoConstraints:
0x00019f34  mov      x0, x20
0x00019f38  mov      w2, #1
0x00019f3c  bl       #0x5a540   ; CALL objc_msgSend$setAxis:
0x00019f40  mov      x0, x20
0x00019f44  mov      x2, #0
0x00019f48  bl       #0x5a3a0   ; CALL objc_msgSend$setAlignment:
0x00019f4c  fmov     d0, #18.00000000
0x00019f50  mov      x0, x20
0x00019f54  bl       #0x5c240   ; CALL objc_msgSend$setSpacing:
0x00019f58  str      x21, [sp, #0x168]
0x00019f5c  mov      x0, x21
0x00019f60  mov      x2, x20
0x00019f64  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00019f68  adrp     x2, #0x78000
0x00019f6c  add      x2, x2, #0xfa8   ; STR "sparkles"
0x00019f70  mov      x8, #0x4052000000000000
0x00019f74  fmov     d0, x8
0x00019f78  mov      x8, #0x4040000000000000
0x00019f7c  fmov     d1, x8
0x00019f80  fmov     d2, #20.00000000
0x00019f84  mov      x0, x25
0x00019f88  bl       #0x5da80   ; CALL objc_msgSend$tileWithSymbol:side:pointSize:radius:
0x00019f8c  mov      x29, x29
0x00019f90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019f94  mov      x19, x0
0x00019f98  adrp     x8, #0x8e000
0x00019f9c  ldr      x0, [x8, #0x918]   ; @CLASS UIView
0x00019fa0  bl       #0x55d60   ; CALL _objc_opt_new
0x00019fa4  mov      x22, x0
0x00019fa8  mov      x2, x19
0x00019fac  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00019fb0  adrp     x8, #0x8e000
0x00019fb4  ldr      x8, [x8, #0xa58]   ; @CLASS NSLayoutConstraint
0x00019fb8  str      x8, [sp, #0x140]
0x00019fbc  mov      x0, x19
0x00019fc0  bl       #0x5dc00   ; CALL objc_msgSend$topAnchor
0x00019fc4  mov      x29, x29
0x00019fc8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019fcc  mov      x21, x0
0x00019fd0  str      x0, [sp, #0x158]
0x00019fd4  mov      x0, x22
0x00019fd8  bl       #0x5dc00   ; CALL objc_msgSend$topAnchor
0x00019fdc  mov      x29, x29
0x00019fe0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019fe4  mov      x2, x0
0x00019fe8  str      x0, [sp, #0x150]
0x00019fec  mov      x0, x21
0x00019ff0  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x00019ff4  mov      x29, x29
0x00019ff8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019ffc  str      x0, [sp, #0x148]
0x0001a000  stur     x0, [x29, #-0x78]
0x0001a004  mov      x0, x19
0x0001a008  bl       #0x56a00   ; CALL objc_msgSend$bottomAnchor
0x0001a00c  mov      x29, x29
0x0001a010  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a014  mov      x23, x0
0x0001a018  mov      x0, x22
0x0001a01c  bl       #0x56a00   ; CALL objc_msgSend$bottomAnchor
0x0001a020  mov      x29, x29
0x0001a024  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a028  mov      x26, x0
0x0001a02c  mov      x0, x23
0x0001a030  mov      x2, x26
0x0001a034  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x0001a038  mov      x29, x29
0x0001a03c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a040  mov      x27, x0
0x0001a044  stur     x0, [x29, #-0x70]
0x0001a048  str      x19, [sp, #0x160]
0x0001a04c  mov      x0, x19
0x0001a050  bl       #0x56d60   ; CALL objc_msgSend$centerXAnchor
0x0001a054  mov      x29, x29
0x0001a058  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a05c  mov      x28, x0
0x0001a060  mov      x0, x22
0x0001a064  bl       #0x56d60   ; CALL objc_msgSend$centerXAnchor
0x0001a068  mov      x29, x29
0x0001a06c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a070  mov      x24, x0
0x0001a074  mov      x0, x28
0x0001a078  mov      x2, x24
0x0001a07c  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x0001a080  mov      x29, x29
0x0001a084  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a088  mov      x19, x0
0x0001a08c  stur     x0, [x29, #-0x68]
0x0001a090  adrp     x8, #0x8e000
0x0001a094  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0001a098  sub      x2, x29, #0x78
0x0001a09c  mov      w3, #3
0x0001a0a0  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0001a0a4  mov      x29, x29
0x0001a0a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a0ac  mov      x21, x0
0x0001a0b0  ldr      x0, [sp, #0x140]
0x0001a0b4  mov      x2, x21
0x0001a0b8  bl       #0x55fe0   ; CALL objc_msgSend$activateConstraints:
0x0001a0bc  mov      x0, x21
0x0001a0c0  bl       #0x55d78   ; CALL _objc_release
0x0001a0c4  mov      x0, x19
0x0001a0c8  bl       #0x55d78   ; CALL _objc_release
0x0001a0cc  mov      x0, x24
0x0001a0d0  bl       #0x55d78   ; CALL _objc_release
0x0001a0d4  mov      x0, x28
0x0001a0d8  bl       #0x55d78   ; CALL _objc_release
0x0001a0dc  mov      x0, x27
0x0001a0e0  bl       #0x55d78   ; CALL _objc_release
0x0001a0e4  mov      x0, x26
0x0001a0e8  bl       #0x55d78   ; CALL _objc_release
0x0001a0ec  mov      x0, x23
0x0001a0f0  bl       #0x55d78   ; CALL _objc_release
0x0001a0f4  ldr      x0, [sp, #0x148]
0x0001a0f8  bl       #0x55d78   ; CALL _objc_release
0x0001a0fc  ldr      x0, [sp, #0x150]
0x0001a100  bl       #0x55d78   ; CALL _objc_release
0x0001a104  ldr      x0, [sp, #0x158]
0x0001a108  bl       #0x55d78   ; CALL _objc_release
0x0001a10c  mov      x0, x20
0x0001a110  str      x22, [sp, #0x158]
0x0001a114  mov      x2, x22
0x0001a118  bl       #0x56060   ; CALL objc_msgSend$addArrangedSubview:
0x0001a11c  adrp     x8, #0x8e000
0x0001a120  ldr      x0, [x8, #0xa88]   ; @CLASS UIFontMetrics
0x0001a124  adrp     x8, #0x74000
0x0001a128  ldr      x8, [x8, #0x230]   ; @GOT _UIFontTextStyleTitle1
0x0001a12c  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0001a130  bl       #0x58fc0   ; CALL objc_msgSend$metricsForTextStyle:
0x0001a134  mov      x29, x29
0x0001a138  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a13c  mov      x19, x0
0x0001a140  adrp     x8, #0x8e000
0x0001a144  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x0001a148  adrp     x8, #0x74000
0x0001a14c  ldr      x8, [x8, #0x238]   ; @GOT _UIFontWeightBold
0x0001a150  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x0001a154  fmov     d0, #26.00000000
0x0001a158  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x0001a15c  mov      x29, x29
0x0001a160  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a164  mov      x21, x0
0x0001a168  mov      x0, x19
0x0001a16c  mov      x2, x21
0x0001a170  bl       #0x5a080   ; CALL objc_msgSend$scaledFontForFont:
0x0001a174  mov      x29, x29
0x0001a178  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a17c  mov      x22, x0
0x0001a180  mov      x0, x21
0x0001a184  bl       #0x55d78   ; CALL _objc_release
0x0001a188  mov      x0, x19
0x0001a18c  bl       #0x55d78   ; CALL _objc_release
0x0001a190  adrp     x23, #0x8e000
0x0001a194  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0001a198  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x0001a19c  mov      x29, x29
0x0001a1a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a1a4  mov      x19, x0
0x0001a1a8  mov      x0, x25
0x0001a1ac  str      x22, [sp, #0x150]
0x0001a1b0  mov      x2, x22
0x0001a1b4  mov      x3, x19
0x0001a1b8  bl       #0x58a00   ; CALL objc_msgSend$labelWithFont:color:
0x0001a1bc  mov      x29, x29
0x0001a1c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a1c4  mov      x24, x0
0x0001a1c8  mov      x0, x19
0x0001a1cc  bl       #0x55d78   ; CALL _objc_release
0x0001a1d0  mov      x0, x24
0x0001a1d4  mov      w2, #1
0x0001a1d8  bl       #0x5c4e0   ; CALL objc_msgSend$setTextAlignment:
0x0001a1dc  adrp     x8, #0x8e000
0x0001a1e0  ldr      x19, [x8, #0x958]   ; @CLASS NSString
0x0001a1e4  adrp     x0, #0x78000
0x0001a1e8  add      x0, x0, #0xfc8   ; STR "WN_TITLE"
0x0001a1ec  bl       #0x17e20   ; CALL _L
0x0001a1f0  mov      x29, x29
0x0001a1f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a1f8  mov      x21, x0
0x0001a1fc  mov      x0, x25
0x0001a200  bl       #0x5df00   ; CALL objc_msgSend$version
0x0001a204  mov      x29, x29
0x0001a208  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a20c  mov      x22, x0
0x0001a210  str      x0, [sp]
0x0001a214  mov      x0, x19
0x0001a218  mov      x2, x21
0x0001a21c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0001a220  mov      x29, x29
0x0001a224  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a228  mov      x19, x0
0x0001a22c  mov      x0, x24
0x0001a230  mov      x2, x19
0x0001a234  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0001a238  mov      x0, x19
0x0001a23c  bl       #0x55d78   ; CALL _objc_release
0x0001a240  mov      x0, x22
0x0001a244  bl       #0x55d78   ; CALL _objc_release
0x0001a248  mov      x0, x21
0x0001a24c  bl       #0x55d78   ; CALL _objc_release
0x0001a250  mov      x0, x20
0x0001a254  mov      x2, x24
0x0001a258  bl       #0x56060   ; CALL objc_msgSend$addArrangedSubview:
0x0001a25c  fmov     d0, #28.00000000
0x0001a260  mov      x0, x20
0x0001a264  str      x24, [sp, #0x148]
0x0001a268  mov      x2, x24
0x0001a26c  bl       #0x5abe0   ; CALL objc_msgSend$setCustomSpacing:afterView:
0x0001a270  movi     v0.16b, #0
0x0001a274  stp      q0, q0, [sp, #0x190]
0x0001a278  stp      q0, q0, [sp, #0x170]
0x0001a27c  mov      x0, x25
0x0001a280  bl       #0x58980   ; CALL objc_msgSend$items
0x0001a284  mov      x29, x29
0x0001a288  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a28c  mov      x19, x0
0x0001a290  add      x2, sp, #0x170
0x0001a294  sub      x3, x29, #0xf8
0x0001a298  mov      w4, #0x10
0x0001a29c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001a2a0  cbz      x0, #0x1a324
0x0001a2a4  mov      x21, x0
0x0001a2a8  ldr      x8, [sp, #0x180]
0x0001a2ac  ldr      x24, [x8]   ; @SEL "whatsNewNavigationController"
0x0001a2b0  mov      x26, #0
0x0001a2b4  ldr      x8, [sp, #0x180]
0x0001a2b8  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0001a2bc  cmp      x8, x24
0x0001a2c0  b.eq     #0x1a2cc
0x0001a2c4  mov      x0, x19
0x0001a2c8  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0001a2cc  ldr      x8, [sp, #0x178]
0x0001a2d0  ldr      x2, [x8, x26, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0001a2d4  mov      x0, x25
0x0001a2d8  bl       #0x59f80   ; CALL objc_msgSend$rowForItem:
0x0001a2dc  mov      x29, x29
0x0001a2e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a2e4  mov      x22, x0
0x0001a2e8  mov      x0, x20
0x0001a2ec  mov      x2, x22
0x0001a2f0  bl       #0x56060   ; CALL objc_msgSend$addArrangedSubview:
0x0001a2f4  mov      x0, x22
0x0001a2f8  bl       #0x55d78   ; CALL _objc_release
0x0001a2fc  add      x26, x26, #1
0x0001a300  cmp      x21, x26
0x0001a304  b.ne     #0x1a2b4
0x0001a308  add      x2, sp, #0x170
0x0001a30c  sub      x3, x29, #0xf8
0x0001a310  mov      x0, x19
0x0001a314  mov      w4, #0x10
0x0001a318  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001a31c  mov      x21, x0
0x0001a320  cbnz     x0, #0x1a2b0
0x0001a324  mov      x0, x19
0x0001a328  bl       #0x55d78   ; CALL _objc_release
0x0001a32c  adrp     x8, #0x8e000
0x0001a330  ldr      x0, [x8, #0xa48]   ; @CLASS UIButtonConfiguration
0x0001a334  bl       #0x57be0   ; CALL objc_msgSend$filledButtonConfiguration
0x0001a338  mov      x29, x29
0x0001a33c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a340  mov      x21, x0
0x0001a344  adrp     x0, #0x78000
0x0001a348  add      x0, x0, #0xfe8   ; STR "WN_CONTINUE"
0x0001a34c  bl       #0x17e20   ; CALL _L
0x0001a350  mov      x29, x29
0x0001a354  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a358  mov      x19, x0
0x0001a35c  mov      x0, x21
0x0001a360  mov      x2, x19
0x0001a364  bl       #0x5c5e0   ; CALL objc_msgSend$setTitle:
0x0001a368  mov      x0, x19
0x0001a36c  bl       #0x55d78   ; CALL _objc_release
0x0001a370  mov      x0, x21
0x0001a374  mov      w2, #4
0x0001a378  bl       #0x5ab80   ; CALL objc_msgSend$setCornerStyle:
0x0001a37c  bl       #0x17e8c   ; CALL _OMCAccentColor
0x0001a380  mov      x29, x29
0x0001a384  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a388  mov      x19, x0
0x0001a38c  mov      x0, x21
0x0001a390  mov      x2, x19
0x0001a394  bl       #0x5a5e0   ; CALL objc_msgSend$setBaseBackgroundColor:
0x0001a398  mov      x0, x19
0x0001a39c  bl       #0x55d78   ; CALL _objc_release
0x0001a3a0  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0001a3a4  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0001a3a8  mov      x29, x29
0x0001a3ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a3b0  mov      x19, x0
0x0001a3b4  mov      x0, x21
0x0001a3b8  mov      x2, x19
0x0001a3bc  bl       #0x5a600   ; CALL objc_msgSend$setBaseForegroundColor:
0x0001a3c0  mov      x0, x19
0x0001a3c4  bl       #0x55d78   ; CALL _objc_release
0x0001a3c8  fmov     d0, #12.00000000
0x0001a3cc  fmov     d1, #24.00000000
0x0001a3d0  fmov     d2, #12.00000000
0x0001a3d4  fmov     d3, #24.00000000
0x0001a3d8  str      x21, [sp, #0x140]
0x0001a3dc  mov      x0, x21
0x0001a3e0  bl       #0x5aa20   ; CALL objc_msgSend$setContentInsets:
0x0001a3e4  adrp     x8, #0x8e000
0x0001a3e8  ldr      x0, [x8, #0xa50]   ; @CLASS UIButton
0x0001a3ec  mov      w2, #1
0x0001a3f0  bl       #0x56b80   ; CALL objc_msgSend$buttonWithType:
0x0001a3f4  mov      x29, x29
0x0001a3f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a3fc  mov      x19, x0
0x0001a400  mov      w2, #0
0x0001a404  bl       #0x5c6c0   ; CALL objc_msgSend$setTranslatesAutoresizingMaskIntoConstraints:
0x0001a408  mov      x0, x19
0x0001a40c  mov      x2, x21
0x0001a410  bl       #0x5a960   ; CALL objc_msgSend$setConfiguration:
0x0001a414  adrp     x8, #0x8b000
0x0001a418  ldr      x3, [x8, #0xe58]   ; @SEL "close"
0x0001a41c  mov      x0, x19
0x0001a420  mov      x21, x19
0x0001a424  mov      x2, x25
0x0001a428  mov      w4, #0x40
0x0001a42c  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x0001a430  mov      x0, x25
0x0001a434  bl       #0x5df60   ; CALL objc_msgSend$view
0x0001a438  mov      x29, x29
0x0001a43c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a440  mov      x19, x0
0x0001a444  mov      x2, x21
0x0001a448  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0001a44c  mov      x0, x19
0x0001a450  bl       #0x55d78   ; CALL _objc_release
0x0001a454  mov      x0, x25
0x0001a458  bl       #0x5df60   ; CALL objc_msgSend$view
0x0001a45c  mov      x29, x29
0x0001a460  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a464  mov      x19, x0
0x0001a468  bl       #0x5a020   ; CALL objc_msgSend$safeAreaLayoutGuide
0x0001a46c  mov      x29, x29
0x0001a470  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a474  mov      x22, x0
0x0001a478  mov      x0, x19
0x0001a47c  bl       #0x55d78   ; CALL _objc_release
0x0001a480  adrp     x8, #0x8e000
0x0001a484  ldr      x8, [x8, #0xa58]   ; @CLASS NSLayoutConstraint
0x0001a488  str      x8, [sp, #0xa8]
0x0001a48c  ldr      x19, [sp, #0x168]
0x0001a490  mov      x0, x19
0x0001a494  bl       #0x5dc00   ; CALL objc_msgSend$topAnchor
0x0001a498  mov      x29, x29
0x0001a49c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a4a0  mov      x23, x0
0x0001a4a4  str      x0, [sp, #0x138]
0x0001a4a8  mov      x0, x22
0x0001a4ac  bl       #0x5dc00   ; CALL objc_msgSend$topAnchor
0x0001a4b0  mov      x29, x29
0x0001a4b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a4b8  mov      x2, x0
0x0001a4bc  str      x0, [sp, #0x130]
0x0001a4c0  mov      x0, x23
0x0001a4c4  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x0001a4c8  mov      x29, x29
0x0001a4cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a4d0  str      x0, [sp, #0x128]
0x0001a4d4  str      x0, [sp, #0x1c8]
0x0001a4d8  mov      x0, x19
0x0001a4dc  bl       #0x58be0   ; CALL objc_msgSend$leadingAnchor
0x0001a4e0  mov      x29, x29
0x0001a4e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a4e8  mov      x23, x0
0x0001a4ec  str      x0, [sp, #0x118]
0x0001a4f0  mov      x0, x25
0x0001a4f4  bl       #0x5df60   ; CALL objc_msgSend$view
0x0001a4f8  mov      x29, x29
0x0001a4fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a500  str      x0, [sp, #0x120]
0x0001a504  bl       #0x58be0   ; CALL objc_msgSend$leadingAnchor
0x0001a508  mov      x29, x29
0x0001a50c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a510  mov      x2, x0
0x0001a514  str      x0, [sp, #0x110]
0x0001a518  mov      x0, x23
0x0001a51c  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x0001a520  mov      x29, x29
0x0001a524  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a528  str      x0, [sp, #0x108]
0x0001a52c  str      x0, [sp, #0x1d0]
0x0001a530  mov      x0, x19
0x0001a534  bl       #0x5dc40   ; CALL objc_msgSend$trailingAnchor
0x0001a538  mov      x29, x29
0x0001a53c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a540  mov      x23, x0
0x0001a544  str      x0, [sp, #0xf8]
0x0001a548  mov      x0, x25
0x0001a54c  bl       #0x5df60   ; CALL objc_msgSend$view
0x0001a550  mov      x29, x29
0x0001a554  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a558  str      x0, [sp, #0x100]
0x0001a55c  bl       #0x5dc40   ; CALL objc_msgSend$trailingAnchor
0x0001a560  mov      x29, x29
0x0001a564  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a568  mov      x2, x0
0x0001a56c  str      x0, [sp, #0xf0]
0x0001a570  mov      x0, x23
0x0001a574  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x0001a578  mov      x29, x29
0x0001a57c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a580  str      x0, [sp, #0xe8]
0x0001a584  str      x0, [sp, #0x1d8]
0x0001a588  mov      x0, x19
0x0001a58c  bl       #0x56a00   ; CALL objc_msgSend$bottomAnchor
0x0001a590  mov      x29, x29
0x0001a594  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a598  mov      x23, x0
0x0001a59c  str      x0, [sp, #0xe0]
0x0001a5a0  mov      x0, x21
0x0001a5a4  bl       #0x5dc00   ; CALL objc_msgSend$topAnchor
0x0001a5a8  mov      x29, x29
0x0001a5ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a5b0  mov      x2, x0
0x0001a5b4  str      x0, [sp, #0xd8]
0x0001a5b8  fmov     d0, #-12.00000000
0x0001a5bc  mov      x0, x23
0x0001a5c0  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x0001a5c4  mov      x29, x29
0x0001a5c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a5cc  str      x0, [sp, #0xd0]
0x0001a5d0  str      x0, [sp, #0x1e0]
0x0001a5d4  mov      x0, x20
0x0001a5d8  bl       #0x5dc00   ; CALL objc_msgSend$topAnchor
0x0001a5dc  mov      x29, x29
0x0001a5e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a5e4  mov      x23, x0
0x0001a5e8  str      x0, [sp, #0xc0]
0x0001a5ec  mov      x0, x19
0x0001a5f0  bl       #0x57200   ; CALL objc_msgSend$contentLayoutGuide
0x0001a5f4  mov      x29, x29
0x0001a5f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a5fc  str      x0, [sp, #0xc8]
0x0001a600  bl       #0x5dc00   ; CALL objc_msgSend$topAnchor
0x0001a604  mov      x29, x29
0x0001a608  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a60c  mov      x2, x0
0x0001a610  str      x0, [sp, #0xb8]
0x0001a614  mov      x8, #0x4042000000000000
0x0001a618  fmov     d0, x8
0x0001a61c  mov      x0, x23
0x0001a620  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x0001a624  mov      x29, x29
0x0001a628  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a62c  str      x0, [sp, #0xb0]
0x0001a630  str      x0, [sp, #0x1e8]
0x0001a634  mov      x0, x20
0x0001a638  bl       #0x56a00   ; CALL objc_msgSend$bottomAnchor
0x0001a63c  mov      x29, x29
0x0001a640  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a644  mov      x23, x0
0x0001a648  str      x0, [sp, #0x98]
0x0001a64c  mov      x0, x19
0x0001a650  bl       #0x57200   ; CALL objc_msgSend$contentLayoutGuide
0x0001a654  mov      x29, x29
0x0001a658  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a65c  str      x0, [sp, #0xa0]
0x0001a660  bl       #0x56a00   ; CALL objc_msgSend$bottomAnchor
0x0001a664  mov      x29, x29
0x0001a668  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a66c  mov      x2, x0
0x0001a670  str      x0, [sp, #0x90]
0x0001a674  fmov     d0, #-20.00000000
0x0001a678  mov      x0, x23
0x0001a67c  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x0001a680  mov      x29, x29
0x0001a684  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a688  str      x0, [sp, #0x88]
0x0001a68c  str      x0, [sp, #0x1f0]
0x0001a690  mov      x0, x20
0x0001a694  bl       #0x58be0   ; CALL objc_msgSend$leadingAnchor
0x0001a698  mov      x29, x29
0x0001a69c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a6a0  mov      x23, x0
0x0001a6a4  str      x0, [sp, #0x78]
0x0001a6a8  mov      x0, x19
0x0001a6ac  bl       #0x57200   ; CALL objc_msgSend$contentLayoutGuide
0x0001a6b0  mov      x29, x29
0x0001a6b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a6b8  str      x0, [sp, #0x80]
0x0001a6bc  bl       #0x58be0   ; CALL objc_msgSend$leadingAnchor
0x0001a6c0  mov      x29, x29
0x0001a6c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a6c8  mov      x2, x0
0x0001a6cc  str      x0, [sp, #0x68]
0x0001a6d0  fmov     d0, #24.00000000
0x0001a6d4  mov      x0, x23
0x0001a6d8  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x0001a6dc  mov      x29, x29
0x0001a6e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a6e4  str      x0, [sp, #0x58]
0x0001a6e8  str      x0, [sp, #0x1f8]
0x0001a6ec  mov      x0, x20
0x0001a6f0  bl       #0x5dc40   ; CALL objc_msgSend$trailingAnchor
0x0001a6f4  mov      x29, x29
0x0001a6f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a6fc  mov      x23, x0
0x0001a700  str      x0, [sp, #0x48]
0x0001a704  mov      x0, x19
0x0001a708  bl       #0x57200   ; CALL objc_msgSend$contentLayoutGuide
0x0001a70c  mov      x29, x29
0x0001a710  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a714  str      x0, [sp, #0x50]
0x0001a718  bl       #0x5dc40   ; CALL objc_msgSend$trailingAnchor
0x0001a71c  mov      x29, x29
0x0001a720  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a724  mov      x2, x0
0x0001a728  str      x0, [sp, #0x40]
0x0001a72c  fmov     d0, #-24.00000000
0x0001a730  mov      x0, x23
0x0001a734  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x0001a738  mov      x29, x29
0x0001a73c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a740  str      x0, [sp, #0x38]
0x0001a744  str      x0, [sp, #0x200]
0x0001a748  mov      x0, x20
0x0001a74c  bl       #0x5e1c0   ; CALL objc_msgSend$widthAnchor
0x0001a750  mov      x29, x29
0x0001a754  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a758  mov      x23, x0
0x0001a75c  str      x0, [sp, #0x28]
0x0001a760  mov      x0, x19
0x0001a764  bl       #0x57d20   ; CALL objc_msgSend$frameLayoutGuide
0x0001a768  mov      x29, x29
0x0001a76c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a770  str      x0, [sp, #0x30]
0x0001a774  bl       #0x5e1c0   ; CALL objc_msgSend$widthAnchor
0x0001a778  mov      x29, x29
0x0001a77c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a780  mov      x2, x0
0x0001a784  str      x0, [sp, #0x20]
0x0001a788  mov      x8, #-0x3fb8000000000000
0x0001a78c  fmov     d0, x8
0x0001a790  mov      x0, x23
0x0001a794  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x0001a798  mov      x29, x29
0x0001a79c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a7a0  str      x0, [sp, #0x18]
0x0001a7a4  str      x0, [sp, #0x208]
0x0001a7a8  mov      x0, x21
0x0001a7ac  bl       #0x58be0   ; CALL objc_msgSend$leadingAnchor
0x0001a7b0  mov      x29, x29
0x0001a7b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a7b8  mov      x19, x0
0x0001a7bc  str      x0, [sp, #0x10]
0x0001a7c0  mov      x0, x22
0x0001a7c4  bl       #0x58be0   ; CALL objc_msgSend$leadingAnchor
0x0001a7c8  mov      x29, x29
0x0001a7cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a7d0  mov      x25, x0
0x0001a7d4  fmov     d0, #24.00000000
0x0001a7d8  mov      x0, x19
0x0001a7dc  mov      x2, x25
0x0001a7e0  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x0001a7e4  mov      x29, x29
0x0001a7e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a7ec  mov      x23, x0
0x0001a7f0  str      x0, [sp, #0x210]
0x0001a7f4  mov      x0, x21
0x0001a7f8  str      x21, [sp, #0x70]
0x0001a7fc  bl       #0x5dc40   ; CALL objc_msgSend$trailingAnchor
0x0001a800  mov      x29, x29
0x0001a804  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a808  mov      x28, x0
0x0001a80c  str      x22, [sp, #0x60]
0x0001a810  mov      x0, x22
0x0001a814  bl       #0x5dc40   ; CALL objc_msgSend$trailingAnchor
0x0001a818  mov      x29, x29
0x0001a81c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a820  mov      x24, x0
0x0001a824  fmov     d0, #-24.00000000
0x0001a828  mov      x0, x28
0x0001a82c  mov      x2, x24
0x0001a830  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x0001a834  mov      x29, x29
0x0001a838  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a83c  mov      x26, x0
0x0001a840  str      x0, [sp, #0x218]
0x0001a844  mov      x0, x21
0x0001a848  bl       #0x56a00   ; CALL objc_msgSend$bottomAnchor
0x0001a84c  mov      x29, x29
0x0001a850  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a854  mov      x27, x0
0x0001a858  mov      x0, x22
0x0001a85c  bl       #0x56a00   ; CALL objc_msgSend$bottomAnchor
0x0001a860  mov      x29, x29
0x0001a864  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a868  mov      x22, x0
0x0001a86c  fmov     d0, #-16.00000000
0x0001a870  mov      x0, x27
0x0001a874  mov      x2, x22
0x0001a878  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x0001a87c  mov      x29, x29
0x0001a880  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a884  mov      x21, x0
0x0001a888  str      x0, [sp, #0x220]
0x0001a88c  adrp     x8, #0x8e000
0x0001a890  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0001a894  add      x2, sp, #0x1c8
0x0001a898  mov      w3, #0xc
0x0001a89c  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0001a8a0  mov      x29, x29
0x0001a8a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001a8a8  mov      x19, x0
0x0001a8ac  ldr      x0, [sp, #0xa8]
0x0001a8b0  mov      x2, x19
0x0001a8b4  bl       #0x55fe0   ; CALL objc_msgSend$activateConstraints:
0x0001a8b8  mov      x0, x19
0x0001a8bc  bl       #0x55d78   ; CALL _objc_release
0x0001a8c0  mov      x0, x21
0x0001a8c4  bl       #0x55d78   ; CALL _objc_release
0x0001a8c8  mov      x0, x22
0x0001a8cc  bl       #0x55d78   ; CALL _objc_release
0x0001a8d0  mov      x0, x27
0x0001a8d4  bl       #0x55d78   ; CALL _objc_release
0x0001a8d8  mov      x0, x26
0x0001a8dc  bl       #0x55d78   ; CALL _objc_release
0x0001a8e0  mov      x0, x24
0x0001a8e4  bl       #0x55d78   ; CALL _objc_release
0x0001a8e8  mov      x0, x28
0x0001a8ec  bl       #0x55d78   ; CALL _objc_release
0x0001a8f0  mov      x0, x23
0x0001a8f4  bl       #0x55d78   ; CALL _objc_release
0x0001a8f8  mov      x0, x25
0x0001a8fc  bl       #0x55d78   ; CALL _objc_release
0x0001a900  ldr      x0, [sp, #0x10]
0x0001a904  bl       #0x55d78   ; CALL _objc_release
0x0001a908  ldr      x0, [sp, #0x18]
0x0001a90c  bl       #0x55d78   ; CALL _objc_release
0x0001a910  ldr      x0, [sp, #0x20]
0x0001a914  bl       #0x55d78   ; CALL _objc_release
0x0001a918  ldr      x0, [sp, #0x30]
0x0001a91c  bl       #0x55d78   ; CALL _objc_release
0x0001a920  ldr      x0, [sp, #0x28]
0x0001a924  bl       #0x55d78   ; CALL _objc_release
0x0001a928  ldr      x0, [sp, #0x38]
0x0001a92c  bl       #0x55d78   ; CALL _objc_release
0x0001a930  ldr      x0, [sp, #0x40]
0x0001a934  bl       #0x55d78   ; CALL _objc_release
0x0001a938  ldr      x0, [sp, #0x50]
0x0001a93c  bl       #0x55d78   ; CALL _objc_release
0x0001a940  ldr      x0, [sp, #0x48]
0x0001a944  bl       #0x55d78   ; CALL _objc_release
0x0001a948  ldr      x0, [sp, #0x58]
0x0001a94c  bl       #0x55d78   ; CALL _objc_release
0x0001a950  ldr      x0, [sp, #0x68]
0x0001a954  bl       #0x55d78   ; CALL _objc_release
0x0001a958  ldr      x0, [sp, #0x80]
0x0001a95c  bl       #0x55d78   ; CALL _objc_release
0x0001a960  ldr      x0, [sp, #0x78]
0x0001a964  bl       #0x55d78   ; CALL _objc_release
0x0001a968  ldr      x0, [sp, #0x88]
0x0001a96c  bl       #0x55d78   ; CALL _objc_release
0x0001a970  ldr      x0, [sp, #0x90]
0x0001a974  bl       #0x55d78   ; CALL _objc_release
0x0001a978  ldr      x0, [sp, #0xa0]
0x0001a97c  bl       #0x55d78   ; CALL _objc_release
0x0001a980  ldr      x0, [sp, #0x98]
0x0001a984  bl       #0x55d78   ; CALL _objc_release
0x0001a988  ldr      x0, [sp, #0xb0]
0x0001a98c  bl       #0x55d78   ; CALL _objc_release
0x0001a990  ldr      x0, [sp, #0xb8]
0x0001a994  bl       #0x55d78   ; CALL _objc_release
0x0001a998  ldr      x0, [sp, #0xc8]
0x0001a99c  bl       #0x55d78   ; CALL _objc_release
0x0001a9a0  ldr      x0, [sp, #0xc0]
0x0001a9a4  bl       #0x55d78   ; CALL _objc_release
0x0001a9a8  ldr      x0, [sp, #0xd0]
0x0001a9ac  bl       #0x55d78   ; CALL _objc_release
0x0001a9b0  ldr      x0, [sp, #0xd8]
0x0001a9b4  bl       #0x55d78   ; CALL _objc_release
0x0001a9b8  ldr      x0, [sp, #0xe0]
0x0001a9bc  bl       #0x55d78   ; CALL _objc_release
0x0001a9c0  ldr      x0, [sp, #0xe8]
0x0001a9c4  bl       #0x55d78   ; CALL _objc_release
0x0001a9c8  ldr      x0, [sp, #0xf0]
0x0001a9cc  bl       #0x55d78   ; CALL _objc_release
0x0001a9d0  ldr      x0, [sp, #0x100]
0x0001a9d4  bl       #0x55d78   ; CALL _objc_release
0x0001a9d8  ldr      x0, [sp, #0xf8]
0x0001a9dc  bl       #0x55d78   ; CALL _objc_release
0x0001a9e0  ldr      x0, [sp, #0x108]
0x0001a9e4  bl       #0x55d78   ; CALL _objc_release
0x0001a9e8  ldr      x0, [sp, #0x110]
0x0001a9ec  bl       #0x55d78   ; CALL _objc_release
0x0001a9f0  ldr      x0, [sp, #0x120]
0x0001a9f4  bl       #0x55d78   ; CALL _objc_release
0x0001a9f8  ldr      x0, [sp, #0x118]
0x0001a9fc  bl       #0x55d78   ; CALL _objc_release
0x0001aa00  ldr      x0, [sp, #0x128]
0x0001aa04  bl       #0x55d78   ; CALL _objc_release
0x0001aa08  ldr      x0, [sp, #0x130]
0x0001aa0c  bl       #0x55d78   ; CALL _objc_release
0x0001aa10  ldr      x0, [sp, #0x138]
0x0001aa14  bl       #0x55d78   ; CALL _objc_release
0x0001aa18  ldr      x0, [sp, #0x60]
0x0001aa1c  bl       #0x55d78   ; CALL _objc_release
0x0001aa20  ldr      x0, [sp, #0x70]
0x0001aa24  bl       #0x55d78   ; CALL _objc_release
0x0001aa28  ldr      x0, [sp, #0x140]
0x0001aa2c  bl       #0x55d78   ; CALL _objc_release
0x0001aa30  ldr      x0, [sp, #0x148]
0x0001aa34  bl       #0x55d78   ; CALL _objc_release
0x0001aa38  ldr      x0, [sp, #0x150]
0x0001aa3c  bl       #0x55d78   ; CALL _objc_release
0x0001aa40  ldr      x0, [sp, #0x158]
0x0001aa44  bl       #0x55d78   ; CALL _objc_release
0x0001aa48  ldr      x0, [sp, #0x160]
0x0001aa4c  bl       #0x55d78   ; CALL _objc_release
0x0001aa50  mov      x0, x20
0x0001aa54  bl       #0x55d78   ; CALL _objc_release
0x0001aa58  ldr      x0, [sp, #0x168]
0x0001aa5c  bl       #0x55d78   ; CALL _objc_release
0x0001aa60  ldur     x8, [x29, #-0x60]
0x0001aa64  adrp     x9, #0x74000
0x0001aa68  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0001aa6c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0001aa70  cmp      x9, x8
0x0001aa74  b.ne     #0x1aa98
0x0001aa78  add      sp, sp, #0x2d0
0x0001aa7c  ldp      x29, x30, [sp, #0x50]
0x0001aa80  ldp      x20, x19, [sp, #0x40]
0x0001aa84  ldp      x22, x21, [sp, #0x30]
0x0001aa88  ldp      x24, x23, [sp, #0x20]
0x0001aa8c  ldp      x26, x25, [sp, #0x10]
0x0001aa90  ldp      x28, x27, [sp], #0x60
0x0001aa94  ret      
0x0001aa98  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCWhatsNewController viewWillAppear:]  va=0x1aa9c size=108 types=v20@0:8B16
0x0001aa9c  sub      sp, sp, #0x30
0x0001aaa0  stp      x20, x19, [sp, #0x10]
0x0001aaa4  stp      x29, x30, [sp, #0x20]
0x0001aaa8  add      x29, sp, #0x20
0x0001aaac  mov      x19, x2
0x0001aab0  mov      x20, x0
0x0001aab4  adrp     x8, #0x8e000
0x0001aab8  ldr      x8, [x8, #0xd40]   ; @SUPER OMCWhatsNewController
0x0001aabc  stp      x0, x8, [sp]
0x0001aac0  adrp     x8, #0x8b000
0x0001aac4  ldr      x1, [x8, #0xda8]   ; @SEL "viewWillAppear:"
0x0001aac8  mov      x0, sp
0x0001aacc  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0001aad0  mov      x0, x20
0x0001aad4  bl       #0x59180   ; CALL objc_msgSend$navigationController
0x0001aad8  mov      x29, x29
0x0001aadc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001aae0  mov      x20, x0
0x0001aae4  mov      w2, #1
0x0001aae8  mov      x3, x19
0x0001aaec  bl       #0x5b740   ; CALL objc_msgSend$setNavigationBarHidden:animated:
0x0001aaf0  mov      x0, x20
0x0001aaf4  bl       #0x55d78   ; CALL _objc_release
0x0001aaf8  ldp      x29, x30, [sp, #0x20]
0x0001aafc  ldp      x20, x19, [sp, #0x10]
0x0001ab00  add      sp, sp, #0x30
0x0001ab04  ret      

=== -[OMCWhatsNewController labelWithFont:color:]  va=0x1ab08 size=140 types=@32@0:8@16@24
0x0001ab08  stp      x22, x21, [sp, #-0x30]!
0x0001ab0c  stp      x20, x19, [sp, #0x10]
0x0001ab10  stp      x29, x30, [sp, #0x20]
0x0001ab14  add      x29, sp, #0x20
0x0001ab18  mov      x19, x3
0x0001ab1c  mov      x20, x2
0x0001ab20  adrp     x8, #0x8e000
0x0001ab24  ldr      x21, [x8, #0x940]   ; @CLASS UILabel
0x0001ab28  mov      x0, x3
0x0001ab2c  bl       #0x55d84   ; CALL _objc_retain
0x0001ab30  mov      x0, x20
0x0001ab34  bl       #0x55d84   ; CALL _objc_retain
0x0001ab38  mov      x0, x21
0x0001ab3c  bl       #0x55d60   ; CALL _objc_opt_new
0x0001ab40  mov      x21, x0
0x0001ab44  mov      x2, x20
0x0001ab48  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x0001ab4c  mov      x0, x20
0x0001ab50  bl       #0x55d78   ; CALL _objc_release
0x0001ab54  mov      x0, x21
0x0001ab58  mov      w2, #1
0x0001ab5c  bl       #0x5a360   ; CALL objc_msgSend$setAdjustsFontForContentSizeCategory:
0x0001ab60  mov      x0, x21
0x0001ab64  mov      x2, x19
0x0001ab68  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0001ab6c  mov      x0, x19
0x0001ab70  bl       #0x55d78   ; CALL _objc_release
0x0001ab74  mov      x0, x21
0x0001ab78  mov      x2, #0
0x0001ab7c  bl       #0x5b820   ; CALL objc_msgSend$setNumberOfLines:
0x0001ab80  mov      x0, x21
0x0001ab84  ldp      x29, x30, [sp, #0x20]
0x0001ab88  ldp      x20, x19, [sp, #0x10]
0x0001ab8c  ldp      x22, x21, [sp], #0x30
0x0001ab90  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCWhatsNewController tileWithSymbol:side:pointSize:radius:]  va=0x1ab94 size=932 types=@48@0:8@16d24d32d40
0x0001ab94  sub      sp, sp, #0xe0
0x0001ab98  stp      d11, d10, [sp, #0x60]
0x0001ab9c  stp      d9, d8, [sp, #0x70]
0x0001aba0  stp      x28, x27, [sp, #0x80]
0x0001aba4  stp      x26, x25, [sp, #0x90]
0x0001aba8  stp      x24, x23, [sp, #0xa0]
0x0001abac  stp      x22, x21, [sp, #0xb0]
0x0001abb0  stp      x20, x19, [sp, #0xc0]
0x0001abb4  stp      x29, x30, [sp, #0xd0]
0x0001abb8  add      x29, sp, #0xd0
0x0001abbc  mov      v9.16b, v2.16b
0x0001abc0  mov      v10.16b, v1.16b
0x0001abc4  mov      v8.16b, v0.16b
0x0001abc8  mov      x20, x2
0x0001abcc  adrp     x8, #0x74000
0x0001abd0  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0001abd4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001abd8  str      x8, [sp, #0x58]
0x0001abdc  adrp     x8, #0x8e000
0x0001abe0  ldr      x19, [x8, #0xa70]   ; @CLASS UIImageSymbolConfiguration
0x0001abe4  mov      x0, x2
0x0001abe8  bl       #0x55d84   ; CALL _objc_retain
0x0001abec  mov      x0, x19
0x0001abf0  mov      v0.16b, v10.16b
0x0001abf4  mov      w2, #6
0x0001abf8  bl       #0x57100   ; CALL objc_msgSend$configurationWithPointSize:weight:
0x0001abfc  mov      x29, x29
0x0001ac00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ac04  mov      x22, x0
0x0001ac08  adrp     x21, #0x8e000
0x0001ac0c  ldr      x0, [x21, #0xa78]   ; @CLASS UIImage
0x0001ac10  mov      x2, x20
0x0001ac14  mov      x3, x22
0x0001ac18  bl       #0x5d840   ; CALL objc_msgSend$systemImageNamed:withConfiguration:
0x0001ac1c  mov      x29, x29
0x0001ac20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ac24  mov      x19, x0
0x0001ac28  mov      x0, x20
0x0001ac2c  bl       #0x55d78   ; CALL _objc_release
0x0001ac30  str      x22, [sp, #0x30]
0x0001ac34  cbz      x19, #0x1ac48
0x0001ac38  mov      x0, x19
0x0001ac3c  bl       #0x55d84   ; CALL _objc_retain
0x0001ac40  mov      x20, x19
0x0001ac44  b        #0x1ac68
0x0001ac48  ldr      x0, [x21, #0xa78]   ; @CLASS UIImage
0x0001ac4c  adrp     x2, #0x78000
0x0001ac50  add      x2, x2, #0xfa8   ; STR "sparkles"
0x0001ac54  mov      x3, x22
0x0001ac58  bl       #0x5d840   ; CALL objc_msgSend$systemImageNamed:withConfiguration:
0x0001ac5c  mov      x29, x29
0x0001ac60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ac64  mov      x20, x0
0x0001ac68  str      x20, [sp, #0x10]
0x0001ac6c  mov      x0, x19
0x0001ac70  bl       #0x55d78   ; CALL _objc_release
0x0001ac74  adrp     x8, #0x8e000
0x0001ac78  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x0001ac7c  bl       #0x55c7c   ; CALL _objc_alloc
0x0001ac80  mov      x2, x20
0x0001ac84  bl       #0x584c0   ; CALL objc_msgSend$initWithImage:
0x0001ac88  mov      x21, x0
0x0001ac8c  mov      w2, #0
0x0001ac90  bl       #0x5c6c0   ; CALL objc_msgSend$setTranslatesAutoresizingMaskIntoConstraints:
0x0001ac94  adrp     x8, #0x8e000
0x0001ac98  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0001ac9c  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0001aca0  mov      x29, x29
0x0001aca4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001aca8  mov      x19, x0
0x0001acac  mov      x0, x21
0x0001acb0  mov      x2, x19
0x0001acb4  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x0001acb8  mov      x0, x19
0x0001acbc  bl       #0x55d78   ; CALL _objc_release
0x0001acc0  mov      x0, x21
0x0001acc4  mov      w2, #4
0x0001acc8  bl       #0x5aa40   ; CALL objc_msgSend$setContentMode:
0x0001accc  adrp     x8, #0x8e000
0x0001acd0  ldr      x0, [x8, #0x918]   ; @CLASS UIView
0x0001acd4  bl       #0x55d60   ; CALL _objc_opt_new
0x0001acd8  mov      x22, x0
0x0001acdc  mov      w2, #0
0x0001ace0  bl       #0x5c6c0   ; CALL objc_msgSend$setTranslatesAutoresizingMaskIntoConstraints:
0x0001ace4  bl       #0x17e8c   ; CALL _OMCAccentColor
0x0001ace8  mov      x29, x29
0x0001acec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001acf0  mov      x19, x0
0x0001acf4  mov      x0, x22
0x0001acf8  mov      x2, x19
0x0001acfc  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0001ad00  mov      x0, x19
0x0001ad04  bl       #0x55d78   ; CALL _objc_release
0x0001ad08  mov      x0, x22
0x0001ad0c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0001ad10  mov      x29, x29
0x0001ad14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ad18  mov      x19, x0
0x0001ad1c  mov      v0.16b, v9.16b
0x0001ad20  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0001ad24  mov      x0, x19
0x0001ad28  bl       #0x55d78   ; CALL _objc_release
0x0001ad2c  adrp     x8, #0x74000
0x0001ad30  ldr      x8, [x8, #0x648]   ; @GOT _kCACornerCurveContinuous
0x0001ad34  ldr      x19, [x8]   ; @GOT ___objc_personality_v0
0x0001ad38  mov      x0, x22
0x0001ad3c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0001ad40  mov      x29, x29
0x0001ad44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ad48  mov      x23, x0
0x0001ad4c  mov      x2, x19
0x0001ad50  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x0001ad54  mov      x0, x23
0x0001ad58  bl       #0x55d78   ; CALL _objc_release
0x0001ad5c  mov      x0, x22
0x0001ad60  mov      x2, x21
0x0001ad64  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0001ad68  adrp     x8, #0x8e000
0x0001ad6c  ldr      x8, [x8, #0xa58]   ; @CLASS NSLayoutConstraint
0x0001ad70  str      x8, [sp, #8]
0x0001ad74  mov      x0, x22
0x0001ad78  bl       #0x5e1c0   ; CALL objc_msgSend$widthAnchor
0x0001ad7c  mov      x29, x29
0x0001ad80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ad84  str      x0, [sp, #0x28]
0x0001ad88  mov      v0.16b, v8.16b
0x0001ad8c  bl       #0x57180   ; CALL objc_msgSend$constraintEqualToConstant:
0x0001ad90  mov      x29, x29
0x0001ad94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ad98  str      x0, [sp, #0x20]
0x0001ad9c  str      x0, [sp, #0x38]
0x0001ada0  mov      x0, x22
0x0001ada4  bl       #0x57f40   ; CALL objc_msgSend$heightAnchor
0x0001ada8  mov      x29, x29
0x0001adac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001adb0  str      x0, [sp, #0x18]
0x0001adb4  mov      v0.16b, v8.16b
0x0001adb8  bl       #0x57180   ; CALL objc_msgSend$constraintEqualToConstant:
0x0001adbc  mov      x29, x29
0x0001adc0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001adc4  mov      x26, x0
0x0001adc8  str      x0, [sp, #0x40]
0x0001adcc  mov      x0, x21
0x0001add0  bl       #0x56d60   ; CALL objc_msgSend$centerXAnchor
0x0001add4  mov      x29, x29
0x0001add8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001addc  mov      x28, x0
0x0001ade0  mov      x0, x22
0x0001ade4  bl       #0x56d60   ; CALL objc_msgSend$centerXAnchor
0x0001ade8  mov      x29, x29
0x0001adec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001adf0  mov      x19, x0
0x0001adf4  mov      x0, x28
0x0001adf8  mov      x2, x19
0x0001adfc  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x0001ae00  mov      x29, x29
0x0001ae04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ae08  mov      x20, x0
0x0001ae0c  str      x0, [sp, #0x48]
0x0001ae10  mov      x0, x21
0x0001ae14  bl       #0x56d80   ; CALL objc_msgSend$centerYAnchor
0x0001ae18  mov      x29, x29
0x0001ae1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ae20  mov      x27, x0
0x0001ae24  mov      x0, x22
0x0001ae28  bl       #0x56d80   ; CALL objc_msgSend$centerYAnchor
0x0001ae2c  mov      x29, x29
0x0001ae30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ae34  mov      x23, x0
0x0001ae38  mov      x0, x27
0x0001ae3c  mov      x2, x23
0x0001ae40  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x0001ae44  mov      x29, x29
0x0001ae48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ae4c  mov      x24, x0
0x0001ae50  str      x0, [sp, #0x50]
0x0001ae54  adrp     x8, #0x8e000
0x0001ae58  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0001ae5c  add      x2, sp, #0x38
0x0001ae60  mov      w3, #4
0x0001ae64  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0001ae68  mov      x29, x29
0x0001ae6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ae70  mov      x25, x0
0x0001ae74  ldr      x0, [sp, #8]
0x0001ae78  mov      x2, x25
0x0001ae7c  bl       #0x55fe0   ; CALL objc_msgSend$activateConstraints:
0x0001ae80  mov      x0, x25
0x0001ae84  bl       #0x55d78   ; CALL _objc_release
0x0001ae88  mov      x0, x24
0x0001ae8c  bl       #0x55d78   ; CALL _objc_release
0x0001ae90  mov      x0, x23
0x0001ae94  bl       #0x55d78   ; CALL _objc_release
0x0001ae98  mov      x0, x27
0x0001ae9c  bl       #0x55d78   ; CALL _objc_release
0x0001aea0  mov      x0, x20
0x0001aea4  bl       #0x55d78   ; CALL _objc_release
0x0001aea8  mov      x0, x19
0x0001aeac  bl       #0x55d78   ; CALL _objc_release
0x0001aeb0  mov      x0, x28
0x0001aeb4  bl       #0x55d78   ; CALL _objc_release
0x0001aeb8  mov      x0, x26
0x0001aebc  bl       #0x55d78   ; CALL _objc_release
0x0001aec0  ldr      x0, [sp, #0x18]
0x0001aec4  bl       #0x55d78   ; CALL _objc_release
0x0001aec8  ldr      x0, [sp, #0x20]
0x0001aecc  bl       #0x55d78   ; CALL _objc_release
0x0001aed0  ldr      x0, [sp, #0x28]
0x0001aed4  bl       #0x55d78   ; CALL _objc_release
0x0001aed8  mov      x0, x21
0x0001aedc  bl       #0x55d78   ; CALL _objc_release
0x0001aee0  ldr      x0, [sp, #0x10]
0x0001aee4  bl       #0x55d78   ; CALL _objc_release
0x0001aee8  ldr      x0, [sp, #0x30]
0x0001aeec  bl       #0x55d78   ; CALL _objc_release
0x0001aef0  ldr      x8, [sp, #0x58]
0x0001aef4  adrp     x9, #0x74000
0x0001aef8  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0001aefc  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0001af00  cmp      x9, x8
0x0001af04  b.ne     #0x1af34
0x0001af08  mov      x0, x22
0x0001af0c  ldp      x29, x30, [sp, #0xd0]
0x0001af10  ldp      x20, x19, [sp, #0xc0]
0x0001af14  ldp      x22, x21, [sp, #0xb0]
0x0001af18  ldp      x24, x23, [sp, #0xa0]
0x0001af1c  ldp      x26, x25, [sp, #0x90]
0x0001af20  ldp      x28, x27, [sp, #0x80]
0x0001af24  ldp      d9, d8, [sp, #0x70]
0x0001af28  ldp      d11, d10, [sp, #0x60]
0x0001af2c  add      sp, sp, #0xe0
0x0001af30  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0001af34  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCWhatsNewController rowForItem:]  va=0x1af38 size=892 types=@24@0:8@16
0x0001af38  sub      sp, sp, #0x90
0x0001af3c  stp      x28, x27, [sp, #0x30]
0x0001af40  stp      x26, x25, [sp, #0x40]
0x0001af44  stp      x24, x23, [sp, #0x50]
0x0001af48  stp      x22, x21, [sp, #0x60]
0x0001af4c  stp      x20, x19, [sp, #0x70]
0x0001af50  stp      x29, x30, [sp, #0x80]
0x0001af54  add      x29, sp, #0x80
0x0001af58  mov      x19, x2
0x0001af5c  mov      x23, x0
0x0001af60  adrp     x8, #0x74000
0x0001af64  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0001af68  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001af6c  str      x8, [sp, #0x28]
0x0001af70  mov      x0, x2
0x0001af74  bl       #0x55d84   ; CALL _objc_retain
0x0001af78  adrp     x2, #0x78000
0x0001af7c  add      x2, x2, #0x848   ; STR "symbol"
0x0001af80  mov      x0, x19
0x0001af84  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001af88  mov      x29, x29
0x0001af8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001af90  mov      x21, x0
0x0001af94  adrp     x8, #0x8e000
0x0001af98  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0001af9c  bl       #0x55d48   ; CALL _objc_opt_class
0x0001afa0  mov      x1, x0
0x0001afa4  mov      x0, x21
0x0001afa8  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0001afac  tbz      w0, #0, #0x1afd0
0x0001afb0  adrp     x2, #0x78000
0x0001afb4  add      x2, x2, #0x848   ; STR "symbol"
0x0001afb8  mov      x0, x19
0x0001afbc  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001afc0  mov      x29, x29
0x0001afc4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001afc8  mov      x20, x0
0x0001afcc  b        #0x1afd8
0x0001afd0  adrp     x20, #0x78000
0x0001afd4  add      x20, x20, #0xfa8   ; STR "sparkles"
0x0001afd8  mov      x0, x21
0x0001afdc  bl       #0x55d78   ; CALL _objc_release
0x0001afe0  mov      x8, #0x4044000000000000
0x0001afe4  fmov     d0, x8
0x0001afe8  fmov     d1, #18.00000000
0x0001afec  fmov     d2, #11.00000000
0x0001aff0  mov      x0, x23
0x0001aff4  mov      x2, x20
0x0001aff8  bl       #0x5da80   ; CALL objc_msgSend$tileWithSymbol:side:pointSize:radius:
0x0001affc  mov      x29, x29
0x0001b000  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b004  mov      x21, x0
0x0001b008  adrp     x26, #0x8e000
0x0001b00c  ldr      x0, [x26, #0x948]   ; @CLASS UIFont
0x0001b010  adrp     x8, #0x74000
0x0001b014  ldr      x8, [x8, #0x220]   ; @GOT _UIFontTextStyleHeadline
0x0001b018  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0001b01c  bl       #0x59900   ; CALL objc_msgSend$preferredFontForTextStyle:
0x0001b020  mov      x29, x29
0x0001b024  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b028  mov      x24, x0
0x0001b02c  adrp     x27, #0x8e000
0x0001b030  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x0001b034  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x0001b038  mov      x29, x29
0x0001b03c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b040  mov      x25, x0
0x0001b044  mov      x0, x23
0x0001b048  mov      x2, x24
0x0001b04c  mov      x3, x25
0x0001b050  bl       #0x58a00   ; CALL objc_msgSend$labelWithFont:color:
0x0001b054  mov      x29, x29
0x0001b058  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b05c  mov      x22, x0
0x0001b060  mov      x0, x25
0x0001b064  bl       #0x55d78   ; CALL _objc_release
0x0001b068  mov      x0, x24
0x0001b06c  bl       #0x55d78   ; CALL _objc_release
0x0001b070  adrp     x2, #0x79000
0x0001b074  add      x2, x2, #8   ; STR "titleKey"
0x0001b078  mov      x0, x19
0x0001b07c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001b080  mov      x29, x29
0x0001b084  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b088  mov      x24, x0
0x0001b08c  adrp     x28, #0x75000
0x0001b090  add      x28, x28, #0xd28
0x0001b094  cmp      x0, #0
0x0001b098  csel     x0, x28, x0, eq
0x0001b09c  bl       #0x17e20   ; CALL _L
0x0001b0a0  mov      x29, x29
0x0001b0a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b0a8  mov      x25, x0
0x0001b0ac  mov      x0, x22
0x0001b0b0  mov      x2, x25
0x0001b0b4  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0001b0b8  mov      x0, x25
0x0001b0bc  bl       #0x55d78   ; CALL _objc_release
0x0001b0c0  mov      x0, x24
0x0001b0c4  bl       #0x55d78   ; CALL _objc_release
0x0001b0c8  ldr      x0, [x26, #0x948]   ; @CLASS UIFont
0x0001b0cc  adrp     x8, #0x74000
0x0001b0d0  ldr      x8, [x8, #0x228]   ; @GOT _UIFontTextStyleSubheadline
0x0001b0d4  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0001b0d8  bl       #0x59900   ; CALL objc_msgSend$preferredFontForTextStyle:
0x0001b0dc  mov      x29, x29
0x0001b0e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b0e4  mov      x24, x0
0x0001b0e8  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x0001b0ec  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x0001b0f0  mov      x29, x29
0x0001b0f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b0f8  mov      x25, x0
0x0001b0fc  mov      x0, x23
0x0001b100  mov      x2, x24
0x0001b104  mov      x3, x25
0x0001b108  bl       #0x58a00   ; CALL objc_msgSend$labelWithFont:color:
0x0001b10c  mov      x29, x29
0x0001b110  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b114  mov      x23, x0
0x0001b118  mov      x0, x25
0x0001b11c  bl       #0x55d78   ; CALL _objc_release
0x0001b120  mov      x0, x24
0x0001b124  bl       #0x55d78   ; CALL _objc_release
0x0001b128  adrp     x2, #0x79000
0x0001b12c  add      x2, x2, #0x28   ; STR "textKey"
0x0001b130  mov      x0, x19
0x0001b134  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001b138  mov      x29, x29
0x0001b13c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b140  mov      x24, x0
0x0001b144  cmp      x0, #0
0x0001b148  csel     x0, x28, x0, eq
0x0001b14c  bl       #0x17e20   ; CALL _L
0x0001b150  mov      x29, x29
0x0001b154  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b158  mov      x25, x0
0x0001b15c  mov      x0, x23
0x0001b160  mov      x2, x25
0x0001b164  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0001b168  mov      x0, x25
0x0001b16c  bl       #0x55d78   ; CALL _objc_release
0x0001b170  mov      x0, x24
0x0001b174  bl       #0x55d78   ; CALL _objc_release
0x0001b178  adrp     x26, #0x8e000
0x0001b17c  ldr      x0, [x26, #0xa38]   ; @CLASS UIStackView
0x0001b180  bl       #0x55c7c   ; CALL _objc_alloc
0x0001b184  mov      x24, x0
0x0001b188  stp      x22, x23, [sp, #0x18]
0x0001b18c  adrp     x27, #0x8e000
0x0001b190  ldr      x0, [x27, #0x960]   ; @CLASS NSArray
0x0001b194  add      x2, sp, #0x18
0x0001b198  mov      w3, #2
0x0001b19c  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0001b1a0  mov      x29, x29
0x0001b1a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b1a8  mov      x25, x0
0x0001b1ac  mov      x0, x24
0x0001b1b0  mov      x2, x25
0x0001b1b4  bl       #0x583a0   ; CALL objc_msgSend$initWithArrangedSubviews:
0x0001b1b8  mov      x24, x0
0x0001b1bc  mov      x0, x25
0x0001b1c0  bl       #0x55d78   ; CALL _objc_release
0x0001b1c4  mov      x0, x24
0x0001b1c8  mov      w2, #1
0x0001b1cc  bl       #0x5a540   ; CALL objc_msgSend$setAxis:
0x0001b1d0  fmov     d0, #2.00000000
0x0001b1d4  mov      x0, x24
0x0001b1d8  bl       #0x5c240   ; CALL objc_msgSend$setSpacing:
0x0001b1dc  ldr      x0, [x26, #0xa38]   ; @CLASS UIStackView
0x0001b1e0  bl       #0x55c7c   ; CALL _objc_alloc
0x0001b1e4  mov      x25, x0
0x0001b1e8  stp      x21, x24, [sp, #8]
0x0001b1ec  ldr      x0, [x27, #0x960]   ; @CLASS NSArray
0x0001b1f0  add      x2, sp, #8
0x0001b1f4  mov      w3, #2
0x0001b1f8  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0001b1fc  mov      x29, x29
0x0001b200  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b204  mov      x26, x0
0x0001b208  mov      x0, x25
0x0001b20c  mov      x2, x26
0x0001b210  bl       #0x583a0   ; CALL objc_msgSend$initWithArrangedSubviews:
0x0001b214  mov      x25, x0
0x0001b218  mov      x0, x26
0x0001b21c  bl       #0x55d78   ; CALL _objc_release
0x0001b220  mov      x0, x25
0x0001b224  mov      x2, #0
0x0001b228  bl       #0x5a540   ; CALL objc_msgSend$setAxis:
0x0001b22c  mov      x0, x25
0x0001b230  mov      w2, #1
0x0001b234  bl       #0x5a3a0   ; CALL objc_msgSend$setAlignment:
0x0001b238  fmov     d0, #14.00000000
0x0001b23c  mov      x0, x25
0x0001b240  bl       #0x5c240   ; CALL objc_msgSend$setSpacing:
0x0001b244  mov      x0, x24
0x0001b248  bl       #0x55d78   ; CALL _objc_release
0x0001b24c  mov      x0, x23
0x0001b250  bl       #0x55d78   ; CALL _objc_release
0x0001b254  mov      x0, x22
0x0001b258  bl       #0x55d78   ; CALL _objc_release
0x0001b25c  mov      x0, x21
0x0001b260  bl       #0x55d78   ; CALL _objc_release
0x0001b264  mov      x0, x20
0x0001b268  bl       #0x55d78   ; CALL _objc_release
0x0001b26c  mov      x0, x19
0x0001b270  bl       #0x55d78   ; CALL _objc_release
0x0001b274  ldr      x8, [sp, #0x28]
0x0001b278  adrp     x9, #0x74000
0x0001b27c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0001b280  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0001b284  cmp      x9, x8
0x0001b288  b.ne     #0x1b2b0
0x0001b28c  mov      x0, x25
0x0001b290  ldp      x29, x30, [sp, #0x80]
0x0001b294  ldp      x20, x19, [sp, #0x70]
0x0001b298  ldp      x22, x21, [sp, #0x60]
0x0001b29c  ldp      x24, x23, [sp, #0x50]
0x0001b2a0  ldp      x26, x25, [sp, #0x40]
0x0001b2a4  ldp      x28, x27, [sp, #0x30]
0x0001b2a8  add      sp, sp, #0x90
0x0001b2ac  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0001b2b0  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCWhatsNewController close]  va=0x1b2b4 size=88 types=v16@0:8
0x0001b2b4  stp      x20, x19, [sp, #-0x20]!
0x0001b2b8  stp      x29, x30, [sp, #0x10]
0x0001b2bc  add      x29, sp, #0x10
0x0001b2c0  mov      x19, x0
0x0001b2c4  bl       #0x59180   ; CALL objc_msgSend$navigationController
0x0001b2c8  mov      x29, x29
0x0001b2cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b2d0  mov      x20, x0
0x0001b2d4  cmp      x0, #0
0x0001b2d8  csel     x19, x19, x0, eq
0x0001b2dc  mov      x0, x19
0x0001b2e0  bl       #0x55d84   ; CALL _objc_retain
0x0001b2e4  mov      x0, x20
0x0001b2e8  bl       #0x55d78   ; CALL _objc_release
0x0001b2ec  mov      x0, x19
0x0001b2f0  mov      w2, #1
0x0001b2f4  mov      x3, #0
0x0001b2f8  bl       #0x57820   ; CALL objc_msgSend$dismissViewControllerAnimated:completion:
0x0001b2fc  mov      x0, x19
0x0001b300  ldp      x29, x30, [sp, #0x10]
0x0001b304  ldp      x20, x19, [sp], #0x20
0x0001b308  b        #0x55d78   ; CALL _objc_release

=== -[OMCWhatsNewController version]  va=0x1b30c size=16 types=@16@0:8
0x0001b30c  adrp     x8, #0x8e000
0x0001b310  ldrsw    x8, [x8, #0xe2c]
0x0001b314  ldr      x0, [x0, x8]
0x0001b318  ret      

=== -[OMCWhatsNewController setVersion:]  va=0x1b31c size=12 types=v24@0:8@16
0x0001b31c  adrp     x8, #0x8e000
0x0001b320  ldrsw    x3, [x8, #0xe2c]
0x0001b324  b        #0x55dc0   ; CALL _objc_setProperty_nonatomic_copy

=== -[OMCWhatsNewController items]  va=0x1b328 size=16 types=@16@0:8
0x0001b328  adrp     x8, #0x8e000
0x0001b32c  ldrsw    x8, [x8, #0xe30]
0x0001b330  ldr      x0, [x0, x8]
0x0001b334  ret      

=== -[OMCWhatsNewController setItems:]  va=0x1b338 size=12 types=v24@0:8@16
0x0001b338  adrp     x8, #0x8e000
0x0001b33c  ldrsw    x3, [x8, #0xe30]
0x0001b340  b        #0x55dc0   ; CALL _objc_setProperty_nonatomic_copy

=== -[OMCWhatsNewController .cxx_destruct]  va=0x1b344 size=64 types=v16@0:8
0x0001b344  stp      x20, x19, [sp, #-0x20]!
0x0001b348  stp      x29, x30, [sp, #0x10]
0x0001b34c  add      x29, sp, #0x10
0x0001b350  mov      x19, x0
0x0001b354  adrp     x8, #0x8e000
0x0001b358  ldrsw    x8, [x8, #0xe30]
0x0001b35c  add      x0, x0, x8
0x0001b360  mov      x1, #0
0x0001b364  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0001b368  adrp     x8, #0x8e000
0x0001b36c  ldrsw    x8, [x8, #0xe2c]
0x0001b370  add      x0, x19, x8
0x0001b374  mov      x1, #0
0x0001b378  ldp      x29, x30, [sp, #0x10]
0x0001b37c  ldp      x20, x19, [sp], #0x20
0x0001b380  b        #0x55dcc   ; CALL _objc_storeStrong
