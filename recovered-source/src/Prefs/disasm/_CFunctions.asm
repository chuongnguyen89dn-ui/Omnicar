=== _OMCFeatureDisplayName  va=0x6804 size=1132 types=
0x00006804  stp      x22, x21, [sp, #-0x30]!
0x00006808  stp      x20, x19, [sp, #0x10]
0x0000680c  stp      x29, x30, [sp, #0x20]
0x00006810  add      x29, sp, #0x20
0x00006814  mov      x19, x0
0x00006818  bl       #0x55d84   ; CALL _objc_retain
0x0000681c  bl       #0x687c
0x00006820  mov      x29, x29
0x00006824  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006828  mov      x20, x0
0x0000682c  mov      x2, x19
0x00006830  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00006834  mov      x29, x29
0x00006838  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000683c  mov      x21, x0
0x00006840  cmp      x0, #0
0x00006844  csel     x22, x19, x0, eq
0x00006848  mov      x0, x22
0x0000684c  bl       #0x55d84   ; CALL _objc_retain
0x00006850  mov      x0, x19
0x00006854  bl       #0x55d78   ; CALL _objc_release
0x00006858  mov      x0, x21
0x0000685c  bl       #0x55d78   ; CALL _objc_release
0x00006860  mov      x0, x20
0x00006864  bl       #0x55d78   ; CALL _objc_release
0x00006868  mov      x0, x22
0x0000686c  ldp      x29, x30, [sp, #0x20]
0x00006870  ldp      x20, x19, [sp, #0x10]
0x00006874  ldp      x22, x21, [sp], #0x30
0x00006878  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0000687c  stp      x28, x27, [sp, #-0x60]!
0x00006880  stp      x26, x25, [sp, #0x10]
0x00006884  stp      x24, x23, [sp, #0x20]
0x00006888  stp      x22, x21, [sp, #0x30]
0x0000688c  stp      x20, x19, [sp, #0x40]
0x00006890  stp      x29, x30, [sp, #0x50]
0x00006894  add      x29, sp, #0x50
0x00006898  sub      sp, sp, #0x1c0
0x0000689c  adrp     x8, #0x74000
0x000068a0  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000068a4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000068a8  stur     x8, [x29, #-0x60]
0x000068ac  adrp     x8, #0x8e000
0x000068b0  ldr      x19, [x8, #0x9d0]   ; @CLASS NSMutableDictionary
0x000068b4  adrp     x0, #0x76000
0x000068b8  add      x0, x0, #0xec8   ; STR "APPS"
0x000068bc  bl       #0x17e20   ; CALL _L
0x000068c0  mov      x29, x29
0x000068c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000068c8  mov      x20, x0
0x000068cc  adrp     x3, #0x76000
0x000068d0  add      x3, x3, #0x908   ; STR "appBridge"
0x000068d4  mov      x0, x19
0x000068d8  mov      x2, x20
0x000068dc  bl       #0x577c0   ; CALL objc_msgSend$dictionaryWithObject:forKey:
0x000068e0  mov      x29, x29
0x000068e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000068e8  mov      x21, x0
0x000068ec  mov      x0, x20
0x000068f0  bl       #0x55d78   ; CALL _objc_release
0x000068f4  adrp     x0, #0x76000
0x000068f8  add      x0, x0, #0xee8   ; STR "HOME_SCREEN"
0x000068fc  bl       #0x17e20   ; CALL _L
0x00006900  mov      x29, x29
0x00006904  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006908  mov      x19, x0
0x0000690c  adrp     x3, #0x76000
0x00006910  add      x3, x3, #0xf08   ; STR "homeScreen"
0x00006914  str      x21, [sp, #8]
0x00006918  mov      x0, x21
0x0000691c  mov      x2, x19
0x00006920  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x00006924  mov      x0, x19
0x00006928  bl       #0x55d78   ; CALL _objc_release
0x0000692c  adrp     x8, #0x8e000
0x00006930  ldr      x19, [x8, #0x9d8]   ; @CLASS NSBundle
0x00006934  adrp     x0, #0x76000
0x00006938  add      x0, x0, #0xf28   ; STR "OMCRootListController"
0x0000693c  bl       #0x55af0   ; CALL _NSClassFromString
0x00006940  mov      x2, x0
0x00006944  mov      x0, x19
0x00006948  bl       #0x56b40   ; CALL objc_msgSend$bundleForClass:
0x0000694c  mov      x29, x29
0x00006950  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006954  movi     v0.16b, #0
0x00006958  stp      q0, q0, [sp, #0x70]
0x0000695c  stp      q0, q0, [sp, #0x90]
0x00006960  adrp     x2, #0x76000
0x00006964  add      x2, x2, #0xf48   ; STR "plist"
0x00006968  str      x0, [sp]
0x0000696c  mov      x3, #0
0x00006970  bl       #0x59660   ; CALL objc_msgSend$pathsForResourcesOfType:inDirectory:
0x00006974  mov      x29, x29
0x00006978  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000697c  add      x2, sp, #0x70
0x00006980  sub      x3, x29, #0xe0
0x00006984  str      x0, [sp, #0x20]
0x00006988  mov      w4, #0x10
0x0000698c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00006990  cbz      x0, #0x6c20
0x00006994  mov      x25, x0
0x00006998  ldr      x8, [sp, #0x80]
0x0000699c  adrp     x23, #0x76000
0x000069a0  add      x23, x23, #0xf68   ; STR "Feature"
0x000069a4  ldr      x24, [x8]   ; @SEL "whatsNewNavigationController"
0x000069a8  adrp     x27, #0x76000
0x000069ac  add      x27, x27, #0xfe8   ; STR "cell"
0x000069b0  adrp     x28, #0x77000
0x000069b4  add      x28, x28, #8   ; STR "PSSwitchCell"
0x000069b8  str      x24, [sp, #0x10]
0x000069bc  mov      x20, #0
0x000069c0  str      x25, [sp, #0x18]
0x000069c4  ldr      x8, [sp, #0x80]
0x000069c8  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x000069cc  cmp      x8, x24
0x000069d0  b.eq     #0x69dc
0x000069d4  ldr      x0, [sp, #0x20]
0x000069d8  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x000069dc  ldr      x8, [sp, #0x78]
0x000069e0  ldr      x19, [x8, x20, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x000069e4  mov      x0, x19
0x000069e8  bl       #0x58a80   ; CALL objc_msgSend$lastPathComponent
0x000069ec  mov      x29, x29
0x000069f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000069f4  mov      x21, x0
0x000069f8  mov      x2, x23
0x000069fc  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x00006a00  mov      x22, x0
0x00006a04  mov      x0, x21
0x00006a08  bl       #0x55d78   ; CALL _objc_release
0x00006a0c  cbz      w22, #0x6bf8
0x00006a10  adrp     x8, #0x8e000
0x00006a14  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00006a18  mov      x2, x19
0x00006a1c  bl       #0x577a0   ; CALL objc_msgSend$dictionaryWithContentsOfFile:
0x00006a20  mov      x29, x29
0x00006a24  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006a28  mov      x19, x0
0x00006a2c  adrp     x2, #0x76000
0x00006a30  add      x2, x2, #0xf88   ; STR "featureLabel"
0x00006a34  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00006a38  mov      x29, x29
0x00006a3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006a40  mov      x21, x0
0x00006a44  bl       #0x55d78   ; CALL _objc_release
0x00006a48  cbz      x21, #0x6bf0
0x00006a4c  movi     v0.16b, #0
0x00006a50  stp      q0, q0, [sp, #0x50]
0x00006a54  stp      q0, q0, [sp, #0x30]
0x00006a58  str      x19, [sp, #0x28]
0x00006a5c  mov      x0, x19
0x00006a60  adrp     x2, #0x76000
0x00006a64  add      x2, x2, #0xfa8   ; STR "items"
0x00006a68  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00006a6c  mov      x29, x29
0x00006a70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006a74  mov      x25, x0
0x00006a78  add      x2, sp, #0x30
0x00006a7c  add      x3, sp, #0xb0
0x00006a80  mov      w4, #0x10
0x00006a84  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00006a88  cbz      x0, #0x6bd8
0x00006a8c  mov      x23, x0
0x00006a90  ldr      x8, [sp, #0x40]
0x00006a94  ldr      x19, [x8]   ; @SEL "whatsNewNavigationController"
0x00006a98  mov      x26, #0
0x00006a9c  ldr      x8, [sp, #0x40]
0x00006aa0  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00006aa4  cmp      x8, x19
0x00006aa8  b.eq     #0x6ab4
0x00006aac  mov      x0, x25
0x00006ab0  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00006ab4  ldr      x8, [sp, #0x38]
0x00006ab8  ldr      x22, [x8, x26, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00006abc  mov      x0, x22
0x00006ac0  adrp     x2, #0x76000
0x00006ac4  add      x2, x2, #0xfc8   ; STR "key"
0x00006ac8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00006acc  mov      x29, x29
0x00006ad0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006ad4  mov      x21, x0
0x00006ad8  mov      x0, x22
0x00006adc  mov      x2, x27
0x00006ae0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00006ae4  mov      x29, x29
0x00006ae8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006aec  mov      x22, x0
0x00006af0  mov      x2, x28
0x00006af4  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00006af8  cbz      w0, #0x6b20
0x00006afc  mov      x0, x21
0x00006b00  adrp     x2, #0x75000
0x00006b04  add      x2, x2, #0x468   ; STR "Enabled"
0x00006b08  bl       #0x57ec0   ; CALL objc_msgSend$hasSuffix:
0x00006b0c  mov      x24, x0
0x00006b10  mov      x0, x22
0x00006b14  bl       #0x55d78   ; CALL _objc_release
0x00006b18  tbnz     w24, #0, #0x6b5c
0x00006b1c  b        #0x6b28
0x00006b20  mov      x0, x22
0x00006b24  bl       #0x55d78   ; CALL _objc_release
0x00006b28  mov      x0, x21
0x00006b2c  bl       #0x55d78   ; CALL _objc_release
0x00006b30  add      x26, x26, #1
0x00006b34  cmp      x23, x26
0x00006b38  b.ne     #0x6a9c
0x00006b3c  add      x2, sp, #0x30
0x00006b40  add      x3, sp, #0xb0
0x00006b44  mov      x0, x25
0x00006b48  mov      w4, #0x10
0x00006b4c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00006b50  mov      x23, x0
0x00006b54  cbnz     x0, #0x6a98
0x00006b58  b        #0x6bd8
0x00006b5c  ldr      x0, [sp, #0x28]
0x00006b60  adrp     x2, #0x76000
0x00006b64  add      x2, x2, #0xf88   ; STR "featureLabel"
0x00006b68  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00006b6c  mov      x29, x29
0x00006b70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006b74  mov      x22, x0
0x00006b78  bl       #0x17e20   ; CALL _L
0x00006b7c  mov      x29, x29
0x00006b80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006b84  mov      x23, x0
0x00006b88  mov      x0, x21
0x00006b8c  bl       #0x58c20   ; CALL objc_msgSend$length
0x00006b90  sub      x2, x0, #7
0x00006b94  mov      x0, x21
0x00006b98  bl       #0x5d6e0   ; CALL objc_msgSend$substringToIndex:
0x00006b9c  mov      x29, x29
0x00006ba0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006ba4  mov      x24, x0
0x00006ba8  ldr      x0, [sp, #8]
0x00006bac  mov      x2, x23
0x00006bb0  mov      x3, x24
0x00006bb4  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x00006bb8  mov      x0, x24
0x00006bbc  bl       #0x55d78   ; CALL _objc_release
0x00006bc0  mov      x0, x23
0x00006bc4  bl       #0x55d78   ; CALL _objc_release
0x00006bc8  mov      x0, x22
0x00006bcc  bl       #0x55d78   ; CALL _objc_release
0x00006bd0  mov      x0, x21
0x00006bd4  bl       #0x55d78   ; CALL _objc_release
0x00006bd8  mov      x0, x25
0x00006bdc  bl       #0x55d78   ; CALL _objc_release
0x00006be0  adrp     x23, #0x76000
0x00006be4  add      x23, x23, #0xf68   ; STR "Feature"
0x00006be8  ldp      x24, x25, [sp, #0x10]
0x00006bec  ldr      x19, [sp, #0x28]
0x00006bf0  mov      x0, x19
0x00006bf4  bl       #0x55d78   ; CALL _objc_release
0x00006bf8  add      x20, x20, #1
0x00006bfc  cmp      x20, x25
0x00006c00  b.ne     #0x69c4
0x00006c04  add      x2, sp, #0x70
0x00006c08  sub      x3, x29, #0xe0
0x00006c0c  ldr      x0, [sp, #0x20]
0x00006c10  mov      w4, #0x10
0x00006c14  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00006c18  mov      x25, x0
0x00006c1c  cbnz     x0, #0x69bc
0x00006c20  ldr      x0, [sp, #0x20]
0x00006c24  bl       #0x55d78   ; CALL _objc_release
0x00006c28  ldr      x0, [sp]
0x00006c2c  bl       #0x55d78   ; CALL _objc_release
0x00006c30  ldur     x8, [x29, #-0x60]
0x00006c34  adrp     x9, #0x74000
0x00006c38  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00006c3c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00006c40  cmp      x9, x8
0x00006c44  b.ne     #0x6c6c
0x00006c48  ldr      x0, [sp, #8]
0x00006c4c  add      sp, sp, #0x1c0
0x00006c50  ldp      x29, x30, [sp, #0x50]
0x00006c54  ldp      x20, x19, [sp, #0x40]
0x00006c58  ldp      x22, x21, [sp, #0x30]
0x00006c5c  ldp      x24, x23, [sp, #0x20]
0x00006c60  ldp      x26, x25, [sp, #0x10]
0x00006c64  ldp      x28, x27, [sp], #0x60
0x00006c68  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00006c6c  bl       #0x55b98   ; CALL ___stack_chk_fail

=== _OMCConflictingTweaks  va=0x6c70 size=3192 types=
0x00006c70  stp      x28, x27, [sp, #-0x60]!
0x00006c74  stp      x26, x25, [sp, #0x10]
0x00006c78  stp      x24, x23, [sp, #0x20]
0x00006c7c  stp      x22, x21, [sp, #0x30]
0x00006c80  stp      x20, x19, [sp, #0x40]
0x00006c84  stp      x29, x30, [sp, #0x50]
0x00006c88  add      x29, sp, #0x50
0x00006c8c  sub      sp, sp, #0x8e0
0x00006c90  adrp     x8, #0x74000
0x00006c94  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00006c98  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00006c9c  stur     x8, [x29, #-0x60]
0x00006ca0  adrp     x8, #0x8e000
0x00006ca4  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00006ca8  bl       #0x565c0   ; CALL objc_msgSend$array
0x00006cac  mov      x29, x29
0x00006cb0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006cb4  mov      x19, x0
0x00006cb8  movi     v0.16b, #0
0x00006cbc  stp      q0, q0, [sp, #0x160]
0x00006cc0  stp      q0, q0, [sp, #0x180]
0x00006cc4  adrp     x0, #0x75000
0x00006cc8  add      x0, x0, #0x388   ; STR "/Library/MobileSubstrate/DynamicLibraries"
0x00006ccc  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00006cd0  add      x1, sp, #0x440
0x00006cd4  bl       #0x4118
0x00006cd8  adrp     x20, #0x8e000
0x00006cdc  cbz      x0, #0x6cfc
0x00006ce0  mov      x2, x0
0x00006ce4  ldr      x0, [x20, #0x958]   ; @CLASS NSString
0x00006ce8  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00006cec  mov      x29, x29
0x00006cf0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006cf4  mov      x21, x0
0x00006cf8  b        #0x6d00
0x00006cfc  mov      x21, #0
0x00006d00  stur     x21, [x29, #-0xf0]
0x00006d04  adrp     x0, #0x75000
0x00006d08  add      x0, x0, #0x3a8   ; STR "/usr/lib/TweakInject"
0x00006d0c  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00006d10  add      x1, sp, #0x440
0x00006d14  bl       #0x4118
0x00006d18  cbz      x0, #0x6d38
0x00006d1c  mov      x2, x0
0x00006d20  ldr      x0, [x20, #0x958]   ; @CLASS NSString
0x00006d24  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00006d28  mov      x29, x29
0x00006d2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006d30  mov      x22, x0
0x00006d34  b        #0x6d3c
0x00006d38  mov      x22, #0
0x00006d3c  stur     x22, [x29, #-0xe8]
0x00006d40  adrp     x8, #0x8e000
0x00006d44  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00006d48  sub      x2, x29, #0xf0
0x00006d4c  mov      w3, #2
0x00006d50  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00006d54  mov      x29, x29
0x00006d58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006d5c  mov      x20, x0
0x00006d60  mov      x0, x22
0x00006d64  bl       #0x55d78   ; CALL _objc_release
0x00006d68  mov      x0, x21
0x00006d6c  bl       #0x55d78   ; CALL _objc_release
0x00006d70  add      x2, sp, #0x160
0x00006d74  sub      x3, x29, #0xe0
0x00006d78  str      x20, [sp, #8]
0x00006d7c  mov      x0, x20
0x00006d80  mov      w4, #0x10
0x00006d84  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00006d88  str      x0, [sp, #0x18]
0x00006d8c  cbz      x0, #0x6f20
0x00006d90  ldr      x8, [sp, #0x170]
0x00006d94  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00006d98  str      x8, [sp, #0x10]
0x00006d9c  adrp     x22, #0x75000
0x00006da0  add      x22, x22, #0x3c8   ; STR "dylib"
0x00006da4  mov      x20, #0
0x00006da8  ldr      x8, [sp, #0x170]
0x00006dac  ldr      x8, [x8]   ; @CSTR "whatsNewNavigationController"
0x00006db0  ldr      x9, [sp, #0x10]
0x00006db4  cmp      x8, x9
0x00006db8  b.eq     #0x6dc4
0x00006dbc  ldr      x0, [sp, #8]
0x00006dc0  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00006dc4  ldr      x8, [sp, #0x168]
0x00006dc8  ldr      x23, [x8, x20, lsl #3]
0x00006dcc  movi     v0.16b, #0
0x00006dd0  stp      q0, q0, [sp, #0x120]
0x00006dd4  stp      q0, q0, [sp, #0x140]
0x00006dd8  adrp     x8, #0x8e000
0x00006ddc  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x00006de0  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x00006de4  mov      x29, x29
0x00006de8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006dec  mov      x24, x0
0x00006df0  mov      x2, x23
0x00006df4  mov      x3, #0
0x00006df8  bl       #0x572a0   ; CALL objc_msgSend$contentsOfDirectoryAtPath:error:
0x00006dfc  mov      x29, x29
0x00006e00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006e04  mov      x23, x0
0x00006e08  mov      x0, x24
0x00006e0c  bl       #0x55d78   ; CALL _objc_release
0x00006e10  add      x2, sp, #0x120
0x00006e14  add      x3, sp, #0x3c0
0x00006e18  mov      x0, x23
0x00006e1c  mov      w4, #0x10
0x00006e20  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00006e24  cbz      x0, #0x6eec
0x00006e28  mov      x24, x0
0x00006e2c  ldr      x8, [sp, #0x130]
0x00006e30  ldr      x28, [x8]   ; @SEL "whatsNewNavigationController"
0x00006e34  mov      x21, #0
0x00006e38  ldr      x8, [sp, #0x130]
0x00006e3c  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00006e40  cmp      x8, x28
0x00006e44  b.eq     #0x6e50
0x00006e48  mov      x0, x23
0x00006e4c  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00006e50  ldr      x8, [sp, #0x128]
0x00006e54  ldr      x25, [x8, x21, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00006e58  mov      x0, x25
0x00006e5c  bl       #0x59620   ; CALL objc_msgSend$pathExtension
0x00006e60  mov      x29, x29
0x00006e64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006e68  mov      x26, x0
0x00006e6c  mov      x2, x22
0x00006e70  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00006e74  mov      x27, x0
0x00006e78  mov      x0, x26
0x00006e7c  bl       #0x55d78   ; CALL _objc_release
0x00006e80  cbz      w27, #0x6ec4
0x00006e84  mov      x0, x25
0x00006e88  bl       #0x5d480   ; CALL objc_msgSend$stringByDeletingPathExtension
0x00006e8c  mov      x29, x29
0x00006e90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006e94  mov      x25, x0
0x00006e98  bl       #0x73a8
0x00006e9c  mov      x29, x29
0x00006ea0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006ea4  mov      x26, x0
0x00006ea8  mov      x0, x19
0x00006eac  mov      x2, x26
0x00006eb0  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00006eb4  mov      x0, x26
0x00006eb8  bl       #0x55d78   ; CALL _objc_release
0x00006ebc  mov      x0, x25
0x00006ec0  bl       #0x55d78   ; CALL _objc_release
0x00006ec4  add      x21, x21, #1
0x00006ec8  cmp      x24, x21
0x00006ecc  b.ne     #0x6e38
0x00006ed0  add      x2, sp, #0x120
0x00006ed4  add      x3, sp, #0x3c0
0x00006ed8  mov      x0, x23
0x00006edc  mov      w4, #0x10
0x00006ee0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00006ee4  mov      x24, x0
0x00006ee8  cbnz     x0, #0x6e34
0x00006eec  mov      x0, x23
0x00006ef0  bl       #0x55d78   ; CALL _objc_release
0x00006ef4  add      x20, x20, #1
0x00006ef8  ldr      x8, [sp, #0x18]
0x00006efc  cmp      x20, x8
0x00006f00  b.ne     #0x6da8
0x00006f04  add      x2, sp, #0x160
0x00006f08  sub      x3, x29, #0xe0
0x00006f0c  ldr      x0, [sp, #8]
0x00006f10  mov      w4, #0x10
0x00006f14  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00006f18  str      x0, [sp, #0x18]
0x00006f1c  cbnz     x0, #0x6da4
0x00006f20  ldr      x0, [sp, #8]
0x00006f24  bl       #0x55d78   ; CALL _objc_release
0x00006f28  adrp     x8, #0x8e000
0x00006f2c  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00006f30  bl       #0x565c0   ; CALL objc_msgSend$array
0x00006f34  mov      x29, x29
0x00006f38  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006f3c  mov      x20, x0
0x00006f40  movi     v0.16b, #0
0x00006f44  stp      q0, q0, [sp, #0xe0]
0x00006f48  stp      q0, q0, [sp, #0x100]
0x00006f4c  bl       #0x746c
0x00006f50  mov      x29, x29
0x00006f54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006f58  add      x2, sp, #0xe0
0x00006f5c  add      x3, sp, #0x340
0x00006f60  str      x0, [sp, #0x18]
0x00006f64  mov      w4, #0x10
0x00006f68  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00006f6c  cbz      x0, #0x7074
0x00006f70  mov      x25, x0
0x00006f74  ldr      x8, [sp, #0xf0]
0x00006f78  ldr      x23, [x8]   ; @SEL "whatsNewNavigationController"
0x00006f7c  mov      x24, #0
0x00006f80  ldr      x8, [sp, #0xf0]
0x00006f84  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00006f88  cmp      x8, x23
0x00006f8c  b.eq     #0x6f98
0x00006f90  ldr      x0, [sp, #0x18]
0x00006f94  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00006f98  ldr      x8, [sp, #0xe8]
0x00006f9c  ldr      x26, [x8, x24, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00006fa0  mov      x0, x26
0x00006fa4  adrp     x2, #0x75000
0x00006fa8  add      x2, x2, #0x3e8   ; STR "id"
0x00006fac  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00006fb0  mov      x29, x29
0x00006fb4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006fb8  mov      x27, x0
0x00006fbc  bl       #0x73a8
0x00006fc0  mov      x29, x29
0x00006fc4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006fc8  mov      x28, x0
0x00006fcc  mov      x0, x26
0x00006fd0  adrp     x2, #0x75000
0x00006fd4  add      x2, x2, #0x1e8   ; STR "name"
0x00006fd8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00006fdc  mov      x29, x29
0x00006fe0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006fe4  mov      x26, x0
0x00006fe8  bl       #0x73a8
0x00006fec  mov      x29, x29
0x00006ff0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006ff4  mov      x21, x0
0x00006ff8  str      x0, [sp]
0x00006ffc  mov      x0, x28
0x00007000  adrp     x2, #0x75000
0x00007004  add      x2, x2, #0x408   ; STR " %@"
0x00007008  bl       #0x5d400   ; CALL objc_msgSend$stringByAppendingFormat:
0x0000700c  mov      x29, x29
0x00007010  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007014  mov      x22, x0
0x00007018  mov      x0, x20
0x0000701c  mov      x2, x22
0x00007020  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00007024  mov      x0, x22
0x00007028  bl       #0x55d78   ; CALL _objc_release
0x0000702c  mov      x0, x21
0x00007030  bl       #0x55d78   ; CALL _objc_release
0x00007034  mov      x0, x26
0x00007038  bl       #0x55d78   ; CALL _objc_release
0x0000703c  mov      x0, x28
0x00007040  bl       #0x55d78   ; CALL _objc_release
0x00007044  mov      x0, x27
0x00007048  bl       #0x55d78   ; CALL _objc_release
0x0000704c  add      x24, x24, #1
0x00007050  cmp      x25, x24
0x00007054  b.ne     #0x6f80
0x00007058  add      x2, sp, #0xe0
0x0000705c  add      x3, sp, #0x340
0x00007060  ldr      x0, [sp, #0x18]
0x00007064  mov      w4, #0x10
0x00007068  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000706c  mov      x25, x0
0x00007070  cbnz     x0, #0x6f7c
0x00007074  ldr      x0, [sp, #0x18]
0x00007078  bl       #0x55d78   ; CALL _objc_release
0x0000707c  adrp     x8, #0x8e000
0x00007080  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00007084  bl       #0x565c0   ; CALL objc_msgSend$array
0x00007088  mov      x29, x29
0x0000708c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007090  str      x0, [sp, #8]
0x00007094  movi     v0.16b, #0
0x00007098  stp      q0, q0, [sp, #0xa0]
0x0000709c  stp      q0, q0, [sp, #0xc0]
0x000070a0  adrp     x0, #0x7f000
0x000070a4  add      x0, x0, #0x7e0
0x000070a8  add      x2, sp, #0xa0
0x000070ac  add      x3, sp, #0x2c0
0x000070b0  mov      w4, #0x10
0x000070b4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000070b8  str      x0, [sp, #0x18]
0x000070bc  cbz      x0, #0x7358
0x000070c0  ldr      x8, [sp, #0xb0]
0x000070c4  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x000070c8  str      x8, [sp, #0x10]
0x000070cc  mov      x21, #0
0x000070d0  ldr      x8, [sp, #0xb0]
0x000070d4  ldr      x8, [x8]   ; @CSTR "whatsNewNavigationController"
0x000070d8  ldr      x9, [sp, #0x10]
0x000070dc  cmp      x8, x9
0x000070e0  b.eq     #0x70f0
0x000070e4  adrp     x0, #0x7f000
0x000070e8  add      x0, x0, #0x7e0
0x000070ec  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x000070f0  ldr      x8, [sp, #0xa8]
0x000070f4  ldr      x24, [x8, x21, lsl #3]
0x000070f8  movi     v0.16b, #0
0x000070fc  stp      q0, q0, [sp, #0x60]
0x00007100  stp      q0, q0, [sp, #0x80]
0x00007104  mov      x0, x19
0x00007108  bl       #0x55d84   ; CALL _objc_retain
0x0000710c  add      x2, sp, #0x60
0x00007110  add      x3, sp, #0x240
0x00007114  mov      x0, x19
0x00007118  mov      w4, #0x10
0x0000711c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00007120  cbz      x0, #0x71b4
0x00007124  mov      x26, x0
0x00007128  ldr      x8, [sp, #0x70]
0x0000712c  ldr      x23, [x8]
0x00007130  mov      x22, #0
0x00007134  ldr      x8, [sp, #0x70]
0x00007138  ldr      x8, [x8]
0x0000713c  cmp      x8, x23
0x00007140  b.eq     #0x714c
0x00007144  mov      x0, x19
0x00007148  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0000714c  ldr      x8, [sp, #0x68]
0x00007150  ldr      x27, [x8, x22, lsl #3]
0x00007154  mov      w25, #1
0x00007158  mov      x0, x24
0x0000715c  mov      w2, #1
0x00007160  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00007164  mov      x29, x29
0x00007168  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000716c  mov      x28, x0
0x00007170  mov      x0, x27
0x00007174  mov      x2, x28
0x00007178  bl       #0x571e0   ; CALL objc_msgSend$containsString:
0x0000717c  mov      x27, x0
0x00007180  mov      x0, x28
0x00007184  bl       #0x55d78   ; CALL _objc_release
0x00007188  tbnz     w27, #0, #0x71b8
0x0000718c  add      x22, x22, #1
0x00007190  cmp      x26, x22
0x00007194  b.ne     #0x7134
0x00007198  add      x2, sp, #0x60
0x0000719c  add      x3, sp, #0x240
0x000071a0  mov      x0, x19
0x000071a4  mov      w4, #0x10
0x000071a8  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000071ac  mov      x26, x0
0x000071b0  cbnz     x0, #0x7130
0x000071b4  mov      w25, #0
0x000071b8  mov      x0, x19
0x000071bc  bl       #0x55d78   ; CALL _objc_release
0x000071c0  movi     v0.16b, #0
0x000071c4  stp      q0, q0, [sp, #0x40]
0x000071c8  stp      q0, q0, [sp, #0x20]
0x000071cc  mov      x0, x20
0x000071d0  bl       #0x55d84   ; CALL _objc_retain
0x000071d4  add      x2, sp, #0x20
0x000071d8  add      x3, sp, #0x1c0
0x000071dc  mov      x0, x20
0x000071e0  mov      w4, #0x10
0x000071e4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000071e8  cbz      x0, #0x7278
0x000071ec  mov      x26, x0
0x000071f0  ldr      x8, [sp, #0x30]
0x000071f4  ldr      x23, [x8]
0x000071f8  mov      x22, #0
0x000071fc  ldr      x8, [sp, #0x30]
0x00007200  ldr      x8, [x8]
0x00007204  cmp      x8, x23
0x00007208  b.eq     #0x7214
0x0000720c  mov      x0, x20
0x00007210  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00007214  ldr      x8, [sp, #0x28]
0x00007218  ldr      x27, [x8, x22, lsl #3]
0x0000721c  mov      x0, x24
0x00007220  mov      w2, #1
0x00007224  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00007228  mov      x29, x29
0x0000722c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007230  mov      x28, x0
0x00007234  mov      x0, x27
0x00007238  mov      x2, x28
0x0000723c  bl       #0x571e0   ; CALL objc_msgSend$containsString:
0x00007240  mov      x27, x0
0x00007244  mov      x0, x28
0x00007248  bl       #0x55d78   ; CALL _objc_release
0x0000724c  cbnz     w27, #0x7288
0x00007250  add      x22, x22, #1
0x00007254  cmp      x26, x22
0x00007258  b.ne     #0x71fc
0x0000725c  add      x2, sp, #0x20
0x00007260  add      x3, sp, #0x1c0
0x00007264  mov      x0, x20
0x00007268  mov      w4, #0x10
0x0000726c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00007270  mov      x26, x0
0x00007274  cbnz     x0, #0x71f8
0x00007278  mov      x0, x20
0x0000727c  bl       #0x55d78   ; CALL _objc_release
0x00007280  cbnz     w25, #0x7290
0x00007284  b        #0x7328
0x00007288  mov      x0, x20
0x0000728c  bl       #0x55d78   ; CALL _objc_release
0x00007290  adrp     x8, #0x75000
0x00007294  add      x8, x8, #0x1e8   ; STR "name"
0x00007298  str      x8, [sp, #0x1a0]
0x0000729c  mov      x0, x24
0x000072a0  mov      x2, #0
0x000072a4  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000072a8  mov      x29, x29
0x000072ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000072b0  mov      x24, x0
0x000072b4  adrp     x8, #0x75000
0x000072b8  add      x8, x8, #0x428   ; STR "active"
0x000072bc  stp      x8, x0, [sp, #0x1a8]
0x000072c0  adrp     x8, #0x8e000
0x000072c4  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x000072c8  mov      x2, x25
0x000072cc  bl       #0x592c0   ; CALL objc_msgSend$numberWithBool:
0x000072d0  mov      x29, x29
0x000072d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000072d8  mov      x25, x0
0x000072dc  str      x0, [sp, #0x1b8]
0x000072e0  adrp     x8, #0x8e000
0x000072e4  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x000072e8  add      x2, sp, #0x1b0
0x000072ec  add      x3, sp, #0x1a0
0x000072f0  mov      w4, #2
0x000072f4  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x000072f8  mov      x29, x29
0x000072fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007300  mov      x26, x0
0x00007304  ldr      x0, [sp, #8]
0x00007308  mov      x2, x26
0x0000730c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00007310  mov      x0, x26
0x00007314  bl       #0x55d78   ; CALL _objc_release
0x00007318  mov      x0, x25
0x0000731c  bl       #0x55d78   ; CALL _objc_release
0x00007320  mov      x0, x24
0x00007324  bl       #0x55d78   ; CALL _objc_release
0x00007328  add      x21, x21, #1
0x0000732c  ldr      x8, [sp, #0x18]
0x00007330  cmp      x21, x8
0x00007334  b.ne     #0x70d0
0x00007338  add      x2, sp, #0xa0
0x0000733c  add      x3, sp, #0x2c0
0x00007340  adrp     x0, #0x7f000
0x00007344  add      x0, x0, #0x7e0
0x00007348  mov      w4, #0x10
0x0000734c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00007350  str      x0, [sp, #0x18]
0x00007354  cbnz     x0, #0x70cc
0x00007358  mov      x0, x20
0x0000735c  bl       #0x55d78   ; CALL _objc_release
0x00007360  mov      x0, x19
0x00007364  bl       #0x55d78   ; CALL _objc_release
0x00007368  ldur     x8, [x29, #-0x60]
0x0000736c  adrp     x9, #0x74000
0x00007370  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00007374  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00007378  cmp      x9, x8
0x0000737c  b.ne     #0x73a4
0x00007380  ldr      x0, [sp, #8]
0x00007384  add      sp, sp, #0x8e0
0x00007388  ldp      x29, x30, [sp, #0x50]
0x0000738c  ldp      x20, x19, [sp, #0x40]
0x00007390  ldp      x22, x21, [sp, #0x30]
0x00007394  ldp      x24, x23, [sp, #0x20]
0x00007398  ldp      x26, x25, [sp, #0x10]
0x0000739c  ldp      x28, x27, [sp], #0x60
0x000073a0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x000073a4  bl       #0x55b98   ; CALL ___stack_chk_fail
0x000073a8  stp      x22, x21, [sp, #-0x30]!
0x000073ac  stp      x20, x19, [sp, #0x10]
0x000073b0  stp      x29, x30, [sp, #0x20]
0x000073b4  add      x29, sp, #0x20
0x000073b8  mov      x19, x0
0x000073bc  adrp     x8, #0x8e000
0x000073c0  ldr      x20, [x8, #0x9e0]   ; @CLASS NSCharacterSet
0x000073c4  bl       #0x55d84   ; CALL _objc_retain
0x000073c8  mov      x0, x20
0x000073cc  bl       #0x56300   ; CALL objc_msgSend$alphanumericCharacterSet
0x000073d0  mov      x29, x29
0x000073d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000073d8  mov      x20, x0
0x000073dc  bl       #0x58760   ; CALL objc_msgSend$invertedSet
0x000073e0  mov      x29, x29
0x000073e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000073e8  mov      x21, x0
0x000073ec  mov      x0, x20
0x000073f0  bl       #0x55d78   ; CALL _objc_release
0x000073f4  mov      x0, x19
0x000073f8  bl       #0x58ec0   ; CALL objc_msgSend$lowercaseString
0x000073fc  mov      x29, x29
0x00007400  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007404  mov      x20, x0
0x00007408  mov      x0, x19
0x0000740c  bl       #0x55d78   ; CALL _objc_release
0x00007410  mov      x0, x20
0x00007414  mov      x2, x21
0x00007418  bl       #0x57020   ; CALL objc_msgSend$componentsSeparatedByCharactersInSet:
0x0000741c  mov      x29, x29
0x00007420  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007424  mov      x19, x0
0x00007428  adrp     x2, #0x75000
0x0000742c  add      x2, x2, #0xd28
0x00007430  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x00007434  mov      x29, x29
0x00007438  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000743c  mov      x22, x0
0x00007440  mov      x0, x19
0x00007444  bl       #0x55d78   ; CALL _objc_release
0x00007448  mov      x0, x20
0x0000744c  bl       #0x55d78   ; CALL _objc_release
0x00007450  mov      x0, x21
0x00007454  bl       #0x55d78   ; CALL _objc_release
0x00007458  mov      x0, x22
0x0000745c  ldp      x29, x30, [sp, #0x20]
0x00007460  ldp      x20, x19, [sp, #0x10]
0x00007464  ldp      x22, x21, [sp], #0x30
0x00007468  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0000746c  stp      x28, x27, [sp, #-0x60]!
0x00007470  stp      x26, x25, [sp, #0x10]
0x00007474  stp      x24, x23, [sp, #0x20]
0x00007478  stp      x22, x21, [sp, #0x30]
0x0000747c  stp      x20, x19, [sp, #0x40]
0x00007480  stp      x29, x30, [sp, #0x50]
0x00007484  add      x29, sp, #0x50
0x00007488  sub      sp, sp, #0x600
0x0000748c  adrp     x8, #0x74000
0x00007490  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00007494  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00007498  stur     x8, [x29, #-0x60]
0x0000749c  adrp     x20, #0x8e000
0x000074a0  ldr      x19, [x20, #0x958]   ; @CLASS NSString
0x000074a4  adrp     x0, #0x77000
0x000074a8  add      x0, x0, #0x28   ; STR "/var/lib/dpkg/status"
0x000074ac  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x000074b0  add      x1, sp, #0x1f0
0x000074b4  bl       #0x4118
0x000074b8  cbz      x0, #0x74d8
0x000074bc  mov      x2, x0
0x000074c0  ldr      x0, [x20, #0x958]   ; @CLASS NSString
0x000074c4  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x000074c8  mov      x29, x29
0x000074cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000074d0  mov      x20, x0
0x000074d4  b        #0x74dc
0x000074d8  mov      x20, #0
0x000074dc  mov      x0, x19
0x000074e0  mov      x2, x20
0x000074e4  mov      w3, #4
0x000074e8  mov      x4, #0
0x000074ec  bl       #0x5d560   ; CALL objc_msgSend$stringWithContentsOfFile:encoding:error:
0x000074f0  mov      x29, x29
0x000074f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000074f8  mov      x19, x0
0x000074fc  mov      x0, x20
0x00007500  bl       #0x55d78   ; CALL _objc_release
0x00007504  adrp     x8, #0x8e000
0x00007508  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x0000750c  bl       #0x565c0   ; CALL objc_msgSend$array
0x00007510  mov      x29, x29
0x00007514  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007518  str      x0, [sp, #0x18]
0x0000751c  movi     v0.16b, #0
0x00007520  stp      q0, q0, [sp, #0x80]
0x00007524  stp      q0, q0, [sp, #0xa0]
0x00007528  adrp     x2, #0x77000
0x0000752c  add      x2, x2, #0x48   ; STR "\n\n"
0x00007530  str      x19, [sp, #8]
0x00007534  mov      x0, x19
0x00007538  bl       #0x57040   ; CALL objc_msgSend$componentsSeparatedByString:
0x0000753c  mov      x29, x29
0x00007540  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007544  add      x2, sp, #0x80
0x00007548  add      x3, sp, #0x170
0x0000754c  str      x0, [sp, #0x20]
0x00007550  mov      w4, #0x10
0x00007554  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00007558  str      x0, [sp, #0x30]
0x0000755c  cbz      x0, #0x7884
0x00007560  ldr      x8, [sp, #0x90]
0x00007564  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00007568  str      x8, [sp, #0x28]
0x0000756c  adrp     x19, #0x77000
0x00007570  add      x19, x19, #0x68   ; STR ": "
0x00007574  mov      x24, #0x7fffffffffffffff
0x00007578  mov      x20, #0
0x0000757c  ldr      x8, [sp, #0x90]
0x00007580  ldr      x8, [x8]   ; @CSTR "whatsNewNavigationController"
0x00007584  ldr      x9, [sp, #0x28]
0x00007588  cmp      x8, x9
0x0000758c  b.eq     #0x7598
0x00007590  ldr      x0, [sp, #0x20]
0x00007594  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00007598  ldr      x8, [sp, #0x88]
0x0000759c  str      x20, [sp, #0x38]
0x000075a0  ldr      x21, [x8, x20, lsl #3]
0x000075a4  adrp     x8, #0x8e000
0x000075a8  ldr      x0, [x8, #0x9d0]   ; @CLASS NSMutableDictionary
0x000075ac  bl       #0x57780   ; CALL objc_msgSend$dictionary
0x000075b0  mov      x29, x29
0x000075b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000075b8  mov      x20, x0
0x000075bc  movi     v0.16b, #0
0x000075c0  stp      q0, q0, [sp, #0x40]
0x000075c4  stp      q0, q0, [sp, #0x60]
0x000075c8  mov      x0, x21
0x000075cc  adrp     x2, #0x75000
0x000075d0  add      x2, x2, #0xbe8   ; STR "\n"
0x000075d4  bl       #0x57040   ; CALL objc_msgSend$componentsSeparatedByString:
0x000075d8  mov      x29, x29
0x000075dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000075e0  mov      x25, x0
0x000075e4  add      x2, sp, #0x40
0x000075e8  add      x3, sp, #0xf0
0x000075ec  mov      w4, #0x10
0x000075f0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000075f4  cbz      x0, #0x76d0
0x000075f8  mov      x26, x0
0x000075fc  ldr      x8, [sp, #0x50]
0x00007600  ldr      x23, [x8]   ; @SEL "whatsNewNavigationController"
0x00007604  mov      x27, #0
0x00007608  ldr      x8, [sp, #0x50]
0x0000760c  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00007610  cmp      x8, x23
0x00007614  b.eq     #0x7620
0x00007618  mov      x0, x25
0x0000761c  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00007620  ldr      x8, [sp, #0x48]
0x00007624  ldr      x28, [x8, x27, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00007628  mov      x0, x28
0x0000762c  mov      x2, x19
0x00007630  bl       #0x59b40   ; CALL objc_msgSend$rangeOfString:
0x00007634  cmp      x0, x24
0x00007638  b.eq     #0x76a8
0x0000763c  mov      x22, x0
0x00007640  mov      x21, x1
0x00007644  mov      x0, x28
0x00007648  adrp     x2, #0x77000
0x0000764c  add      x2, x2, #0x88   ; STR " "
0x00007650  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x00007654  tbnz     w0, #0, #0x76a8
0x00007658  add      x2, x22, x21
0x0000765c  mov      x0, x28
0x00007660  bl       #0x5d6c0   ; CALL objc_msgSend$substringFromIndex:
0x00007664  mov      x29, x29
0x00007668  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000766c  mov      x21, x0
0x00007670  mov      x0, x28
0x00007674  mov      x2, x22
0x00007678  bl       #0x5d6e0   ; CALL objc_msgSend$substringToIndex:
0x0000767c  mov      x29, x29
0x00007680  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007684  mov      x22, x0
0x00007688  mov      x0, x20
0x0000768c  mov      x2, x21
0x00007690  mov      x3, x22
0x00007694  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x00007698  mov      x0, x22
0x0000769c  bl       #0x55d78   ; CALL _objc_release
0x000076a0  mov      x0, x21
0x000076a4  bl       #0x55d78   ; CALL _objc_release
0x000076a8  add      x27, x27, #1
0x000076ac  cmp      x26, x27
0x000076b0  b.ne     #0x7608
0x000076b4  add      x2, sp, #0x40
0x000076b8  add      x3, sp, #0xf0
0x000076bc  mov      x0, x25
0x000076c0  mov      w4, #0x10
0x000076c4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000076c8  mov      x26, x0
0x000076cc  cbnz     x0, #0x7604
0x000076d0  mov      x0, x25
0x000076d4  bl       #0x55d78   ; CALL _objc_release
0x000076d8  mov      x0, x20
0x000076dc  adrp     x2, #0x77000
0x000076e0  add      x2, x2, #0xa8   ; STR "Package"
0x000076e4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000076e8  mov      x29, x29
0x000076ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000076f0  cbz      x0, #0x7850
0x000076f4  mov      x22, x0
0x000076f8  mov      x0, x20
0x000076fc  adrp     x2, #0x77000
0x00007700  add      x2, x2, #0xc8   ; STR "Status"
0x00007704  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00007708  mov      x29, x29
0x0000770c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007710  mov      x21, x0
0x00007714  adrp     x2, #0x77000
0x00007718  add      x2, x2, #0xe8   ; STR " installed"
0x0000771c  bl       #0x57ec0   ; CALL objc_msgSend$hasSuffix:
0x00007720  mov      x25, x0
0x00007724  mov      x0, x21
0x00007728  bl       #0x55d78   ; CALL _objc_release
0x0000772c  mov      x0, x22
0x00007730  bl       #0x55d78   ; CALL _objc_release
0x00007734  cbz      w25, #0x7850
0x00007738  adrp     x8, #0x75000
0x0000773c  add      x8, x8, #0x3e8   ; STR "id"
0x00007740  str      x8, [sp, #0xc0]
0x00007744  mov      x0, x20
0x00007748  adrp     x2, #0x77000
0x0000774c  add      x2, x2, #0xa8   ; STR "Package"
0x00007750  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00007754  mov      x29, x29
0x00007758  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000775c  mov      x25, x0
0x00007760  str      x0, [sp, #0xd8]
0x00007764  adrp     x8, #0x75000
0x00007768  add      x8, x8, #0x1e8   ; STR "name"
0x0000776c  str      x8, [sp, #0xc8]
0x00007770  mov      x0, x20
0x00007774  adrp     x2, #0x77000
0x00007778  add      x2, x2, #0x108   ; STR "Name"
0x0000777c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00007780  mov      x29, x29
0x00007784  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007788  mov      x26, x0
0x0000778c  mov      x8, x0
0x00007790  cbnz     x0, #0x77b4
0x00007794  mov      x0, x20
0x00007798  adrp     x2, #0x77000
0x0000779c  add      x2, x2, #0xa8   ; STR "Package"
0x000077a0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000077a4  mov      x29, x29
0x000077a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000077ac  str      x0, [sp, #0x10]
0x000077b0  mov      x8, x0
0x000077b4  str      x8, [sp, #0xe0]
0x000077b8  adrp     x8, #0x77000
0x000077bc  add      x8, x8, #0x128   ; STR "version"
0x000077c0  str      x8, [sp, #0xd0]
0x000077c4  mov      x0, x20
0x000077c8  adrp     x2, #0x77000
0x000077cc  add      x2, x2, #0x148   ; STR "Version"
0x000077d0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000077d4  mov      x29, x29
0x000077d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000077dc  mov      x21, x0
0x000077e0  cmp      x0, #0
0x000077e4  adrp     x8, #0x75000
0x000077e8  add      x8, x8, #0x868   ; STR "?"
0x000077ec  csel     x8, x8, x0, eq
0x000077f0  str      x8, [sp, #0xe8]
0x000077f4  adrp     x8, #0x8e000
0x000077f8  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x000077fc  add      x2, sp, #0xd8
0x00007800  add      x3, sp, #0xc0
0x00007804  mov      w4, #3
0x00007808  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0000780c  mov      x29, x29
0x00007810  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007814  mov      x22, x0
0x00007818  ldr      x0, [sp, #0x18]
0x0000781c  mov      x2, x22
0x00007820  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00007824  mov      x0, x22
0x00007828  bl       #0x55d78   ; CALL _objc_release
0x0000782c  mov      x0, x21
0x00007830  bl       #0x55d78   ; CALL _objc_release
0x00007834  cbnz     x26, #0x7840
0x00007838  ldr      x0, [sp, #0x10]
0x0000783c  bl       #0x55d78   ; CALL _objc_release
0x00007840  mov      x0, x26
0x00007844  bl       #0x55d78   ; CALL _objc_release
0x00007848  mov      x0, x25
0x0000784c  bl       #0x55d78   ; CALL _objc_release
0x00007850  mov      x0, x20
0x00007854  bl       #0x55d78   ; CALL _objc_release
0x00007858  ldp      x8, x20, [sp, #0x30]
0x0000785c  add      x20, x20, #1
0x00007860  cmp      x20, x8
0x00007864  b.ne     #0x757c
0x00007868  add      x2, sp, #0x80
0x0000786c  add      x3, sp, #0x170
0x00007870  ldr      x0, [sp, #0x20]
0x00007874  mov      w4, #0x10
0x00007878  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000787c  str      x0, [sp, #0x30]
0x00007880  cbnz     x0, #0x7578
0x00007884  ldr      x0, [sp, #0x20]
0x00007888  bl       #0x55d78   ; CALL _objc_release
0x0000788c  adrp     x2, #0x74000
0x00007890  add      x2, x2, #0x790
0x00007894  ldr      x19, [sp, #0x18]
0x00007898  mov      x0, x19
0x0000789c  bl       #0x5cc80   ; CALL objc_msgSend$sortUsingComparator:
0x000078a0  ldr      x0, [sp, #8]
0x000078a4  bl       #0x55d78   ; CALL _objc_release
0x000078a8  ldur     x8, [x29, #-0x60]
0x000078ac  adrp     x9, #0x74000
0x000078b0  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000078b4  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000078b8  cmp      x9, x8
0x000078bc  b.ne     #0x78e4
0x000078c0  mov      x0, x19
0x000078c4  add      sp, sp, #0x600
0x000078c8  ldp      x29, x30, [sp, #0x50]
0x000078cc  ldp      x20, x19, [sp, #0x40]
0x000078d0  ldp      x22, x21, [sp, #0x30]
0x000078d4  ldp      x24, x23, [sp, #0x20]
0x000078d8  ldp      x26, x25, [sp, #0x10]
0x000078dc  ldp      x28, x27, [sp], #0x60
0x000078e0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x000078e4  bl       #0x55b98   ; CALL ___stack_chk_fail

=== _OMCRescueFeatures  va=0x78e8 size=528 types=
0x000078e8  sub      sp, sp, #0x120
0x000078ec  stp      x26, x25, [sp, #0xd0]
0x000078f0  stp      x24, x23, [sp, #0xe0]
0x000078f4  stp      x22, x21, [sp, #0xf0]
0x000078f8  stp      x20, x19, [sp, #0x100]
0x000078fc  stp      x29, x30, [sp, #0x110]
0x00007900  add      x29, sp, #0x110
0x00007904  adrp     x8, #0x74000
0x00007908  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0000790c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00007910  stur     x8, [x29, #-0x48]
0x00007914  adrp     x0, #0x75000
0x00007918  add      x0, x0, #0x448   ; STR "rescueFeatures"
0x0000791c  bl       #0x7a70
0x00007920  mov      x29, x29
0x00007924  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007928  mov      x19, x0
0x0000792c  adrp     x8, #0x8e000
0x00007930  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00007934  bl       #0x55d48   ; CALL _objc_opt_class
0x00007938  mov      x1, x0
0x0000793c  mov      x0, x19
0x00007940  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00007944  tbz      w0, #0, #0x7a24
0x00007948  adrp     x8, #0x8e000
0x0000794c  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00007950  bl       #0x565c0   ; CALL objc_msgSend$array
0x00007954  mov      x29, x29
0x00007958  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000795c  mov      x20, x0
0x00007960  movi     v0.16b, #0
0x00007964  stp      q0, q0, [sp]
0x00007968  stp      q0, q0, [sp, #0x20]
0x0000796c  mov      x0, x19
0x00007970  bl       #0x55d84   ; CALL _objc_retain
0x00007974  mov      x2, sp
0x00007978  add      x3, sp, #0x48
0x0000797c  mov      x0, x19
0x00007980  mov      w4, #0x10
0x00007984  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00007988  cbz      x0, #0x7a18
0x0000798c  mov      x21, x0
0x00007990  ldr      x8, [sp, #0x10]
0x00007994  ldr      x23, [x8]   ; @SEL "whatsNewNavigationController"
0x00007998  adrp     x24, #0x8e000
0x0000799c  mov      x25, #0
0x000079a0  ldr      x8, [sp, #0x10]
0x000079a4  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x000079a8  cmp      x8, x23
0x000079ac  b.eq     #0x79b8
0x000079b0  mov      x0, x19
0x000079b4  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x000079b8  ldr      x8, [sp, #8]
0x000079bc  ldr      x22, [x8, x25, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x000079c0  ldr      x0, [x24, #0x958]   ; @CLASS NSString
0x000079c4  bl       #0x55d48   ; CALL _objc_opt_class
0x000079c8  mov      x1, x0
0x000079cc  mov      x0, x22
0x000079d0  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x000079d4  tbz      w0, #0, #0x79f0
0x000079d8  mov      x0, x22
0x000079dc  bl       #0x7a8c
0x000079e0  tbnz     w0, #0, #0x79f0
0x000079e4  mov      x0, x20
0x000079e8  mov      x2, x22
0x000079ec  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x000079f0  add      x25, x25, #1
0x000079f4  cmp      x21, x25
0x000079f8  b.ne     #0x79a0
0x000079fc  mov      x2, sp
0x00007a00  add      x3, sp, #0x48
0x00007a04  mov      x0, x19
0x00007a08  mov      w4, #0x10
0x00007a0c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00007a10  mov      x21, x0
0x00007a14  cbnz     x0, #0x799c
0x00007a18  mov      x0, x19
0x00007a1c  bl       #0x55d78   ; CALL _objc_release
0x00007a20  b        #0x7a2c
0x00007a24  adrp     x20, #0x74000
0x00007a28  ldr      x20, [x20, #0x1a0]   ; @GOT ___NSArray0__struct
0x00007a2c  mov      x0, x19
0x00007a30  bl       #0x55d78   ; CALL _objc_release
0x00007a34  ldur     x8, [x29, #-0x48]
0x00007a38  adrp     x9, #0x74000
0x00007a3c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00007a40  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00007a44  cmp      x9, x8
0x00007a48  b.ne     #0x7a6c
0x00007a4c  mov      x0, x20
0x00007a50  ldp      x29, x30, [sp, #0x110]
0x00007a54  ldp      x20, x19, [sp, #0x100]
0x00007a58  ldp      x22, x21, [sp, #0xf0]
0x00007a5c  ldp      x24, x23, [sp, #0xe0]
0x00007a60  ldp      x26, x25, [sp, #0xd0]
0x00007a64  add      sp, sp, #0x120
0x00007a68  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00007a6c  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00007a70  stp      x29, x30, [sp, #-0x10]!
0x00007a74  mov      x29, sp
0x00007a78  adrp     x1, #0x75000
0x00007a7c  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x00007a80  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x00007a84  ldp      x29, x30, [sp], #0x10
0x00007a88  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00007a8c  stp      x20, x19, [sp, #-0x20]!
0x00007a90  stp      x29, x30, [sp, #0x10]
0x00007a94  add      x29, sp, #0x10
0x00007a98  adrp     x2, #0x75000
0x00007a9c  add      x2, x2, #0x468   ; STR "Enabled"
0x00007aa0  bl       #0x5d440   ; CALL objc_msgSend$stringByAppendingString:
0x00007aa4  mov      x29, x29
0x00007aa8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007aac  mov      x20, x0
0x00007ab0  bl       #0x7a70
0x00007ab4  mov      x29, x29
0x00007ab8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007abc  mov      x19, x0
0x00007ac0  mov      x0, x20
0x00007ac4  bl       #0x55d78   ; CALL _objc_release
0x00007ac8  cbz      x19, #0x7adc
0x00007acc  mov      x0, x19
0x00007ad0  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00007ad4  mov      x20, x0
0x00007ad8  b        #0x7ae0
0x00007adc  mov      w20, #1
0x00007ae0  mov      x0, x19
0x00007ae4  bl       #0x55d78   ; CALL _objc_release
0x00007ae8  mov      x0, x20
0x00007aec  ldp      x29, x30, [sp, #0x10]
0x00007af0  ldp      x20, x19, [sp], #0x20
0x00007af4  ret      

=== _OMCRescueRestore  va=0x7af8 size=384 types=
0x00007af8  sub      sp, sp, #0x130
0x00007afc  stp      x28, x27, [sp, #0xd0]
0x00007b00  stp      x26, x25, [sp, #0xe0]
0x00007b04  stp      x24, x23, [sp, #0xf0]
0x00007b08  stp      x22, x21, [sp, #0x100]
0x00007b0c  stp      x20, x19, [sp, #0x110]
0x00007b10  stp      x29, x30, [sp, #0x120]
0x00007b14  add      x29, sp, #0x120
0x00007b18  adrp     x8, #0x74000
0x00007b1c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00007b20  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00007b24  stur     x8, [x29, #-0x58]
0x00007b28  movi     v0.16b, #0
0x00007b2c  stp      q0, q0, [sp]
0x00007b30  stp      q0, q0, [sp, #0x20]
0x00007b34  bl       #0x78e8   ; CALL _OMCRescueFeatures
0x00007b38  mov      x29, x29
0x00007b3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007b40  mov      x19, x0
0x00007b44  mov      x2, sp
0x00007b48  add      x3, sp, #0x48
0x00007b4c  mov      w4, #0x10
0x00007b50  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00007b54  cbz      x0, #0x7bf0
0x00007b58  mov      x23, x0
0x00007b5c  ldr      x8, [sp, #0x10]
0x00007b60  ldr      x25, [x8]   ; @GOT ___objc_personality_v0
0x00007b64  adrp     x20, #0x75000
0x00007b68  add      x20, x20, #0x468   ; STR "Enabled"
0x00007b6c  adrp     x21, #0x74000
0x00007b70  ldr      x21, [x21, #0x1b8]   ; @GOT ___kCFBooleanTrue
0x00007b74  adrp     x22, #0x75000
0x00007b78  add      x22, x22, #0x28   ; STR "com.anlai.omnicar"
0x00007b7c  mov      x26, #0
0x00007b80  ldr      x8, [sp, #0x10]
0x00007b84  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00007b88  cmp      x8, x25
0x00007b8c  b.eq     #0x7b98
0x00007b90  mov      x0, x19
0x00007b94  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00007b98  ldr      x8, [sp, #8]
0x00007b9c  ldr      x0, [x8, x26, lsl #3]   ; @GOT ___objc_personality_v0
0x00007ba0  mov      x2, x20
0x00007ba4  bl       #0x5d440   ; CALL objc_msgSend$stringByAppendingString:
0x00007ba8  mov      x29, x29
0x00007bac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007bb0  mov      x24, x0
0x00007bb4  mov      x1, x21
0x00007bb8  mov      x2, x22
0x00007bbc  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x00007bc0  mov      x0, x24
0x00007bc4  bl       #0x55d78   ; CALL _objc_release
0x00007bc8  add      x26, x26, #1
0x00007bcc  cmp      x23, x26
0x00007bd0  b.ne     #0x7b80
0x00007bd4  mov      x2, sp
0x00007bd8  add      x3, sp, #0x48
0x00007bdc  mov      x0, x19
0x00007be0  mov      w4, #0x10
0x00007be4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00007be8  mov      x23, x0
0x00007bec  cbnz     x0, #0x7b7c
0x00007bf0  mov      x0, x19
0x00007bf4  bl       #0x55d78   ; CALL _objc_release
0x00007bf8  adrp     x0, #0x75000
0x00007bfc  add      x0, x0, #0x448   ; STR "rescueFeatures"
0x00007c00  adrp     x19, #0x75000
0x00007c04  add      x19, x19, #0x28   ; STR "com.anlai.omnicar"
0x00007c08  mov      x1, #0
0x00007c0c  mov      x2, x19
0x00007c10  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x00007c14  adrp     x0, #0x75000
0x00007c18  add      x0, x0, #0x488   ; STR "rescueDate"
0x00007c1c  mov      x1, #0
0x00007c20  mov      x2, x19
0x00007c24  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x00007c28  mov      x0, x19
0x00007c2c  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x00007c30  adrp     x0, #0x61000
0x00007c34  add      x0, x0, #0x1b1   ; CSTR "com.anlai.omnicar/prefschanged"
0x00007c38  bl       #0x55c70   ; CALL _notify_post
0x00007c3c  ldur     x8, [x29, #-0x58]
0x00007c40  adrp     x9, #0x74000
0x00007c44  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00007c48  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00007c4c  cmp      x9, x8
0x00007c50  b.ne     #0x7c74
0x00007c54  ldp      x29, x30, [sp, #0x120]
0x00007c58  ldp      x20, x19, [sp, #0x110]
0x00007c5c  ldp      x22, x21, [sp, #0x100]
0x00007c60  ldp      x24, x23, [sp, #0xf0]
0x00007c64  ldp      x26, x25, [sp, #0xe0]
0x00007c68  ldp      x28, x27, [sp, #0xd0]
0x00007c6c  add      sp, sp, #0x130
0x00007c70  ret      
0x00007c74  bl       #0x55b98   ; CALL ___stack_chk_fail

=== _OMCDiagSections  va=0x7c78 size=9636 types=
0x00007c78  stp      d9, d8, [sp, #-0x70]!
0x00007c7c  stp      x28, x27, [sp, #0x10]
0x00007c80  stp      x26, x25, [sp, #0x20]
0x00007c84  stp      x24, x23, [sp, #0x30]
0x00007c88  stp      x22, x21, [sp, #0x40]
0x00007c8c  stp      x20, x19, [sp, #0x50]
0x00007c90  stp      x29, x30, [sp, #0x60]
0x00007c94  add      x29, sp, #0x60
0x00007c98  sub      sp, sp, #0x9c0
0x00007c9c  adrp     x8, #0x74000
0x00007ca0  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00007ca4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00007ca8  stur     x8, [x29, #-0x70]
0x00007cac  adrp     x0, #0x75000
0x00007cb0  add      x0, x0, #0x28   ; STR "com.anlai.omnicar"
0x00007cb4  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x00007cb8  adrp     x8, #0x8e000
0x00007cbc  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00007cc0  bl       #0x565c0   ; CALL objc_msgSend$array
0x00007cc4  mov      x29, x29
0x00007cc8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007ccc  str      x0, [sp, #0x88]
0x00007cd0  movi     v0.16b, #0
0x00007cd4  str      q0, [sp, #0x470]
0x00007cd8  str      q0, [sp, #0x460]
0x00007cdc  str      q0, [sp, #0x450]
0x00007ce0  str      q0, [sp, #0x440]
0x00007ce4  mov      w8, #0x40
0x00007ce8  str      x8, [sp, #0x228]
0x00007cec  adrp     x0, #0x61000
0x00007cf0  add      x0, x0, #0x3b3   ; CSTR "kern.osversion"
0x00007cf4  add      x1, sp, #0x440
0x00007cf8  add      x2, sp, #0x228
0x00007cfc  mov      x3, #0
0x00007d00  mov      x4, #0
0x00007d04  bl       #0x55e5c   ; CALL _sysctlbyname
0x00007d08  mov      x20, #0
0x00007d0c  adrp     x22, #0x8e000
0x00007d10  cbnz     w0, #0x7d2c
0x00007d14  ldr      x0, [x22, #0x958]   ; @CLASS NSString
0x00007d18  add      x2, sp, #0x440
0x00007d1c  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00007d20  mov      x29, x29
0x00007d24  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007d28  mov      x20, x0
0x00007d2c  adrp     x8, #0x8e000
0x00007d30  ldr      x0, [x8, #0x998]   ; @CLASS UIDevice
0x00007d34  bl       #0x57440   ; CALL objc_msgSend$currentDevice
0x00007d38  mov      x29, x29
0x00007d3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007d40  mov      x19, x0
0x00007d44  bl       #0x5d8a0   ; CALL objc_msgSend$systemVersion
0x00007d48  mov      x29, x29
0x00007d4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007d50  mov      x21, x0
0x00007d54  mov      x0, x19
0x00007d58  bl       #0x55d78   ; CALL _objc_release
0x00007d5c  adrp     x8, #0x75000
0x00007d60  add      x8, x8, #0x4a8   ; STR "title"
0x00007d64  stur     x8, [x29, #-0x90]
0x00007d68  adrp     x0, #0x75000
0x00007d6c  add      x0, x0, #0x4c8   ; STR "DIAG_DEVICE"
0x00007d70  bl       #0x17e20   ; CALL _L
0x00007d74  mov      x29, x29
0x00007d78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007d7c  mov      x19, x0
0x00007d80  adrp     x8, #0x75000
0x00007d84  add      x8, x8, #0x4e8   ; STR "rows"
0x00007d88  stp      x8, x0, [x29, #-0x88]
0x00007d8c  adrp     x0, #0x75000
0x00007d90  add      x0, x0, #0x508   ; STR "OmniCar"
0x00007d94  adrp     x1, #0x75000
0x00007d98  add      x1, x1, #0x528   ; STR "1.0.3 (fbebb21)"
0x00007d9c  bl       #0x93b8
0x00007da0  mov      x29, x29
0x00007da4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007da8  stur     x0, [x29, #-0xb8]
0x00007dac  str      x20, [sp, #0x80]
0x00007db0  str      x21, [sp, #0x70]
0x00007db4  stp      x0, x19, [sp, #0x110]
0x00007db8  cbz      x20, #0x7ddc
0x00007dbc  ldr      x0, [x22, #0x958]   ; @CLASS NSString
0x00007dc0  stp      x21, x20, [sp]
0x00007dc4  adrp     x2, #0x75000
0x00007dc8  add      x2, x2, #0x568   ; STR "%@ (%@)"
0x00007dcc  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00007dd0  mov      x29, x29
0x00007dd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007dd8  mov      x21, x0
0x00007ddc  adrp     x0, #0x75000
0x00007de0  add      x0, x0, #0x548   ; STR "iOS"
0x00007de4  str      x21, [sp, #0xf8]
0x00007de8  mov      x1, x21
0x00007dec  bl       #0x93b8
0x00007df0  mov      x29, x29
0x00007df4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007df8  str      x0, [sp, #0x108]
0x00007dfc  stur     x0, [x29, #-0xb0]
0x00007e00  adrp     x0, #0x75000
0x00007e04  add      x0, x0, #0x588   ; STR "DIAG_MODEL"
0x00007e08  bl       #0x17e20   ; CALL _L
0x00007e0c  mov      x29, x29
0x00007e10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007e14  mov      x19, x0
0x00007e18  str      x0, [sp, #0x100]
0x00007e1c  bl       #0x9488
0x00007e20  mov      x29, x29
0x00007e24  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007e28  mov      x24, x0
0x00007e2c  mov      x0, x19
0x00007e30  mov      x1, x24
0x00007e34  bl       #0x93b8
0x00007e38  mov      x29, x29
0x00007e3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007e40  mov      x25, x0
0x00007e44  stur     x0, [x29, #-0xa8]
0x00007e48  adrp     x0, #0x75000
0x00007e4c  add      x0, x0, #0x5a8   ; STR "DIAG_JAILBREAK"
0x00007e50  bl       #0x17e20   ; CALL _L
0x00007e54  mov      x29, x29
0x00007e58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007e5c  mov      x26, x0
0x00007e60  bl       #0x94f8
0x00007e64  mov      x29, x29
0x00007e68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007e6c  mov      x27, x0
0x00007e70  mov      x0, x26
0x00007e74  mov      x1, x27
0x00007e78  bl       #0x93b8
0x00007e7c  mov      x29, x29
0x00007e80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007e84  mov      x28, x0
0x00007e88  stur     x0, [x29, #-0xa0]
0x00007e8c  adrp     x0, #0x75000
0x00007e90  add      x0, x0, #0x5c8   ; STR "DIAG_THERMAL"
0x00007e94  bl       #0x17e20   ; CALL _L
0x00007e98  mov      x29, x29
0x00007e9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007ea0  mov      x19, x0
0x00007ea4  bl       #0x95f8
0x00007ea8  mov      x29, x29
0x00007eac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007eb0  mov      x21, x0
0x00007eb4  mov      x0, x19
0x00007eb8  mov      x1, x21
0x00007ebc  bl       #0x93b8
0x00007ec0  mov      x29, x29
0x00007ec4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007ec8  mov      x20, x0
0x00007ecc  stur     x0, [x29, #-0x98]
0x00007ed0  adrp     x8, #0x8e000
0x00007ed4  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00007ed8  sub      x2, x29, #0xb8
0x00007edc  mov      w3, #5
0x00007ee0  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00007ee4  mov      x29, x29
0x00007ee8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007eec  mov      x22, x0
0x00007ef0  stur     x0, [x29, #-0x78]
0x00007ef4  adrp     x8, #0x8e000
0x00007ef8  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00007efc  sub      x2, x29, #0x80
0x00007f00  sub      x3, x29, #0x90
0x00007f04  mov      w4, #2
0x00007f08  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00007f0c  mov      x29, x29
0x00007f10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007f14  mov      x23, x0
0x00007f18  ldr      x0, [sp, #0x88]
0x00007f1c  mov      x2, x23
0x00007f20  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00007f24  mov      x0, x23
0x00007f28  bl       #0x55d78   ; CALL _objc_release
0x00007f2c  mov      x0, x22
0x00007f30  bl       #0x55d78   ; CALL _objc_release
0x00007f34  mov      x0, x20
0x00007f38  bl       #0x55d78   ; CALL _objc_release
0x00007f3c  mov      x0, x21
0x00007f40  bl       #0x55d78   ; CALL _objc_release
0x00007f44  mov      x0, x19
0x00007f48  bl       #0x55d78   ; CALL _objc_release
0x00007f4c  mov      x0, x28
0x00007f50  bl       #0x55d78   ; CALL _objc_release
0x00007f54  mov      x0, x27
0x00007f58  bl       #0x55d78   ; CALL _objc_release
0x00007f5c  mov      x0, x26
0x00007f60  bl       #0x55d78   ; CALL _objc_release
0x00007f64  mov      x0, x25
0x00007f68  bl       #0x55d78   ; CALL _objc_release
0x00007f6c  mov      x0, x24
0x00007f70  bl       #0x55d78   ; CALL _objc_release
0x00007f74  ldr      x0, [sp, #0x100]
0x00007f78  bl       #0x55d78   ; CALL _objc_release
0x00007f7c  ldr      x0, [sp, #0x108]
0x00007f80  bl       #0x55d78   ; CALL _objc_release
0x00007f84  ldr      x8, [sp, #0x80]
0x00007f88  cbz      x8, #0x7f94
0x00007f8c  ldr      x0, [sp, #0xf8]
0x00007f90  bl       #0x55d78   ; CALL _objc_release
0x00007f94  ldr      x0, [sp, #0x110]
0x00007f98  bl       #0x55d78   ; CALL _objc_release
0x00007f9c  ldr      x0, [sp, #0x118]
0x00007fa0  bl       #0x55d78   ; CALL _objc_release
0x00007fa4  adrp     x0, #0x75000
0x00007fa8  add      x0, x0, #0x5e8   ; STR "diagCar"
0x00007fac  bl       #0x7a70
0x00007fb0  mov      x29, x29
0x00007fb4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007fb8  mov      x21, x0
0x00007fbc  adrp     x8, #0x8e000
0x00007fc0  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00007fc4  bl       #0x55d48   ; CALL _objc_opt_class
0x00007fc8  mov      x1, x0
0x00007fcc  mov      x0, x21
0x00007fd0  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00007fd4  str      x21, [sp, #0x78]
0x00007fd8  tbz      w0, #0, #0x842c
0x00007fdc  adrp     x2, #0x75000
0x00007fe0  add      x2, x2, #0x608   ; STR "pixels"
0x00007fe4  mov      x0, x21
0x00007fe8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00007fec  mov      x29, x29
0x00007ff0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00007ff4  mov      x19, x0
0x00007ff8  bl       #0x55d78   ; CALL _objc_release
0x00007ffc  cbz      x19, #0x842c
0x00008000  adrp     x2, #0x75000
0x00008004  add      x2, x2, #0x608   ; STR "pixels"
0x00008008  mov      x0, x21
0x0000800c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00008010  mov      x29, x29
0x00008014  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008018  mov      x19, x0
0x0000801c  bl       #0x9664
0x00008020  mov      v8.16b, v0.16b
0x00008024  mov      v9.16b, v1.16b
0x00008028  mov      x0, x19
0x0000802c  bl       #0x55d78   ; CALL _objc_release
0x00008030  adrp     x1, #0x7f000
0x00008034  add      x1, x1, #0x7f8
0x00008038  mov      x0, x21
0x0000803c  bl       #0x9720
0x00008040  mov      x29, x29
0x00008044  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008048  mov      x23, x0
0x0000804c  adrp     x1, #0x7f000
0x00008050  add      x1, x1, #0x810
0x00008054  mov      x0, x21
0x00008058  bl       #0x9720
0x0000805c  mov      x29, x29
0x00008060  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008064  mov      x22, x0
0x00008068  adrp     x24, #0x8e000
0x0000806c  cbz      x0, #0x80b0
0x00008070  cbz      x23, #0x80b0
0x00008074  mov      x0, x23
0x00008078  mov      x2, x22
0x0000807c  bl       #0x58da0   ; CALL objc_msgSend$localizedCaseInsensitiveContainsString:
0x00008080  tbnz     w0, #0, #0x80b0
0x00008084  ldr      x0, [x24, #0x958]   ; @CLASS NSString
0x00008088  stp      x22, x23, [sp]
0x0000808c  adrp     x2, #0x75000
0x00008090  add      x2, x2, #0x728   ; STR "%@ %@"
0x00008094  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00008098  mov      x29, x29
0x0000809c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000080a0  mov      x19, x0
0x000080a4  mov      x0, x23
0x000080a8  bl       #0x55d78   ; CALL _objc_release
0x000080ac  mov      x23, x19
0x000080b0  orr      x19, x22, x23
0x000080b4  adrp     x8, #0x75000
0x000080b8  add      x8, x8, #0x4a8   ; STR "title"
0x000080bc  stur     x8, [x29, #-0xe8]
0x000080c0  adrp     x0, #0x75000
0x000080c4  add      x0, x0, #0x748   ; STR "DIAG_CAR"
0x000080c8  bl       #0x17e20   ; CALL _L
0x000080cc  mov      x29, x29
0x000080d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000080d4  mov      x25, x0
0x000080d8  stur     x0, [x29, #-0xd0]
0x000080dc  adrp     x8, #0x75000
0x000080e0  add      x8, x8, #0x4e8   ; STR "rows"
0x000080e4  stur     x8, [x29, #-0xe0]
0x000080e8  adrp     x0, #0x75000
0x000080ec  add      x0, x0, #0x768   ; STR "DIAG_CAR_NAME"
0x000080f0  bl       #0x17e20   ; CALL _L
0x000080f4  mov      x29, x29
0x000080f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000080fc  mov      x26, x0
0x00008100  cmp      x19, #0
0x00008104  cset     w8, ne
0x00008108  cmp      x23, #0
0x0000810c  csel     x1, x23, x22, ne
0x00008110  stp      x25, x22, [sp, #0x110]
0x00008114  str      x23, [sp, #0x108]
0x00008118  str      w8, [sp, #0xf8]
0x0000811c  cbnz     x19, #0x8138
0x00008120  adrp     x0, #0x75000
0x00008124  add      x0, x0, #0x788   ; STR "DIAG_UNKNOWN"
0x00008128  bl       #0x17e20   ; CALL _L
0x0000812c  mov      x29, x29
0x00008130  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008134  mov      x1, x0
0x00008138  mov      x0, x26
0x0000813c  str      x1, [sp, #0x100]
0x00008140  bl       #0x93b8
0x00008144  mov      x29, x29
0x00008148  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000814c  str      x0, [sp, #0xf0]
0x00008150  str      x0, [sp, #0x8f8]
0x00008154  adrp     x0, #0x75000
0x00008158  add      x0, x0, #0x7a8   ; STR "DIAG_CAR_CONNECTION"
0x0000815c  bl       #0x17e20   ; CALL _L
0x00008160  mov      x29, x29
0x00008164  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008168  mov      x19, x0
0x0000816c  mov      x0, x21
0x00008170  bl       #0x99a4
0x00008174  mov      x29, x29
0x00008178  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000817c  mov      x1, x0
0x00008180  stp      x1, x19, [sp, #0xe0]
0x00008184  mov      x0, x19
0x00008188  bl       #0x93b8
0x0000818c  mov      x29, x29
0x00008190  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008194  str      x0, [sp, #0xd8]
0x00008198  str      x0, [sp, #0x900]
0x0000819c  adrp     x0, #0x75000
0x000081a0  add      x0, x0, #0x7c8   ; STR "DIAG_CAR_RESOLUTION"
0x000081a4  bl       #0x17e20   ; CALL _L
0x000081a8  mov      x29, x29
0x000081ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000081b0  mov      x23, x0
0x000081b4  ldr      x20, [x24, #0x958]   ; @CLASS NSString
0x000081b8  adrp     x2, #0x75000
0x000081bc  add      x2, x2, #0x608   ; STR "pixels"
0x000081c0  mov      x0, x21
0x000081c4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000081c8  mov      x29, x29
0x000081cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000081d0  mov      x19, x21
0x000081d4  adrp     x21, #0x77000
0x000081d8  add      x21, x21, #0x348   ; STR "x"
0x000081dc  adrp     x22, #0x77000
0x000081e0  add      x22, x22, #0x528   ; STR "×"
0x000081e4  str      x0, [sp, #0xc8]
0x000081e8  mov      x2, x21
0x000081ec  mov      x3, x22
0x000081f0  bl       #0x5d4a0   ; CALL objc_msgSend$stringByReplacingOccurrencesOfString:withString:
0x000081f4  mov      x29, x29
0x000081f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000081fc  str      x0, [sp, #0xc0]
0x00008200  str      x0, [sp]
0x00008204  adrp     x2, #0x75000
0x00008208  add      x2, x2, #0x7e8   ; STR "%@ px"
0x0000820c  mov      x0, x20
0x00008210  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00008214  mov      x29, x29
0x00008218  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000821c  mov      x1, x0
0x00008220  str      x23, [sp, #0xd0]
0x00008224  mov      x0, x23
0x00008228  str      x1, [sp, #0xb8]
0x0000822c  bl       #0x93b8
0x00008230  mov      x29, x29
0x00008234  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008238  str      x0, [sp, #0xb0]
0x0000823c  str      x0, [sp, #0x908]
0x00008240  adrp     x0, #0x75000
0x00008244  add      x0, x0, #0x808   ; STR "DIAG_CAR_POINTS"
0x00008248  bl       #0x17e20   ; CALL _L
0x0000824c  mov      x29, x29
0x00008250  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008254  mov      x23, x0
0x00008258  ldr      x20, [x24, #0x958]   ; @CLASS NSString
0x0000825c  adrp     x2, #0x75000
0x00008260  add      x2, x2, #0x848   ; STR "points"
0x00008264  mov      x0, x19
0x00008268  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000826c  mov      x29, x29
0x00008270  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008274  adrp     x27, #0x75000
0x00008278  add      x27, x27, #0x868   ; STR "?"
0x0000827c  cmp      x0, #0
0x00008280  str      x0, [sp, #0xa0]
0x00008284  csel     x0, x27, x0, eq
0x00008288  mov      x2, x21
0x0000828c  mov      x3, x22
0x00008290  bl       #0x5d4a0   ; CALL objc_msgSend$stringByReplacingOccurrencesOfString:withString:
0x00008294  mov      x29, x29
0x00008298  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000829c  mov      x21, x0
0x000082a0  adrp     x2, #0x75000
0x000082a4  add      x2, x2, #0x888   ; STR "scale"
0x000082a8  mov      x0, x19
0x000082ac  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000082b0  mov      x29, x29
0x000082b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000082b8  cmp      x0, #0
0x000082bc  stp      x0, x21, [sp, #0x90]
0x000082c0  csel     x8, x27, x0, eq
0x000082c4  stp      x21, x8, [sp]
0x000082c8  adrp     x2, #0x75000
0x000082cc  add      x2, x2, #0x828   ; STR "%@ pt @%@x"
0x000082d0  mov      x0, x20
0x000082d4  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x000082d8  mov      x29, x29
0x000082dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000082e0  mov      x1, x0
0x000082e4  str      x23, [sp, #0xa8]
0x000082e8  mov      x0, x23
0x000082ec  str      x1, [sp, #0x68]
0x000082f0  bl       #0x93b8
0x000082f4  mov      x29, x29
0x000082f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000082fc  str      x0, [sp, #0x60]
0x00008300  str      x0, [sp, #0x910]
0x00008304  adrp     x0, #0x75000
0x00008308  add      x0, x0, #0x8a8   ; STR "DIAG_CAR_RATIO"
0x0000830c  bl       #0x17e20   ; CALL _L
0x00008310  mov      x29, x29
0x00008314  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008318  mov      x20, x0
0x0000831c  mov      v0.16b, v8.16b
0x00008320  mov      v1.16b, v9.16b
0x00008324  bl       #0x9da8
0x00008328  mov      x29, x29
0x0000832c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008330  mov      x1, x0
0x00008334  stp      x1, x20, [sp, #0x50]
0x00008338  mov      x0, x20
0x0000833c  bl       #0x93b8
0x00008340  mov      x29, x29
0x00008344  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008348  str      x0, [sp, #0x48]
0x0000834c  str      x0, [sp, #0x918]
0x00008350  adrp     x0, #0x75000
0x00008354  add      x0, x0, #0x8c8   ; STR "DIAG_CAR_FPS"
0x00008358  bl       #0x17e20   ; CALL _L
0x0000835c  mov      x29, x29
0x00008360  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008364  mov      x20, x0
0x00008368  ldr      x21, [x24, #0x958]   ; @CLASS NSString
0x0000836c  adrp     x2, #0x75000
0x00008370  add      x2, x2, #0x908   ; STR "maxFPS"
0x00008374  mov      x0, x19
0x00008378  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000837c  mov      x29, x29
0x00008380  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008384  cmp      x0, #0
0x00008388  str      x0, [sp, #0x38]
0x0000838c  csel     x8, x27, x0, eq
0x00008390  str      x8, [sp]
0x00008394  adrp     x2, #0x75000
0x00008398  add      x2, x2, #0x8e8   ; STR "%@"
0x0000839c  mov      x0, x21
0x000083a0  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x000083a4  mov      x29, x29
0x000083a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000083ac  mov      x1, x0
0x000083b0  str      x20, [sp, #0x40]
0x000083b4  mov      x0, x20
0x000083b8  str      x1, [sp, #0x30]
0x000083bc  bl       #0x93b8
0x000083c0  mov      x29, x29
0x000083c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000083c8  str      x0, [sp, #0x28]
0x000083cc  str      x0, [sp, #0x920]
0x000083d0  adrp     x0, #0x75000
0x000083d4  add      x0, x0, #0x928   ; STR "DIAG_CAR_VIDEO"
0x000083d8  bl       #0x17e20   ; CALL _L
0x000083dc  mov      x29, x29
0x000083e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000083e4  mov      x23, x0
0x000083e8  fcmp     d8, d9
0x000083ec  fcsel    d0, d9, d8, mi
0x000083f0  fcmp     d0, #0.0
0x000083f4  b.ls     #0x9194
0x000083f8  adrp     x8, #0x65000
0x000083fc  ldr      d1, [x8, #0x618]
0x00008400  fcmp     d0, d1
0x00008404  b.ls     #0x918c
0x00008408  adrp     x8, #0x77000
0x0000840c  add      x8, x8, #0x5a8   ; STR "720p (1280×720)"
0x00008410  adrp     x9, #0x77000
0x00008414  add      x9, x9, #0x5c8   ; STR "1080p (1920×1080)"
0x00008418  mov      x10, #0x4094000000000000
0x0000841c  fmov     d1, x10
0x00008420  fcmp     d0, d1
0x00008424  csel     x27, x9, x8, hi
0x00008428  b        #0x9194
0x0000842c  adrp     x8, #0x75000
0x00008430  add      x8, x8, #0x4a8   ; STR "title"
0x00008434  str      x8, [sp, #0x8c8]
0x00008438  adrp     x0, #0x75000
0x0000843c  add      x0, x0, #0x748   ; STR "DIAG_CAR"
0x00008440  bl       #0x17e20   ; CALL _L
0x00008444  mov      x29, x29
0x00008448  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000844c  mov      x23, x0
0x00008450  str      x0, [sp, #0x8e0]
0x00008454  adrp     x8, #0x75000
0x00008458  add      x8, x8, #0x4e8   ; STR "rows"
0x0000845c  str      x8, [sp, #0x8d0]
0x00008460  adrp     x0, #0x75000
0x00008464  add      x0, x0, #0x768   ; STR "DIAG_CAR_NAME"
0x00008468  bl       #0x17e20   ; CALL _L
0x0000846c  mov      x29, x29
0x00008470  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008474  mov      x21, x0
0x00008478  adrp     x0, #0x75000
0x0000847c  add      x0, x0, #0x9c8   ; STR "DIAG_CAR_NONE"
0x00008480  bl       #0x17e20   ; CALL _L
0x00008484  mov      x29, x29
0x00008488  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000848c  mov      x22, x0
0x00008490  mov      x0, x21
0x00008494  mov      x1, x22
0x00008498  bl       #0x93b8
0x0000849c  mov      x29, x29
0x000084a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000084a4  mov      x26, x0
0x000084a8  str      x0, [sp, #0x8c0]
0x000084ac  adrp     x8, #0x8e000
0x000084b0  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000084b4  add      x2, sp, #0x8c0
0x000084b8  mov      w3, #1
0x000084bc  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000084c0  mov      x29, x29
0x000084c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000084c8  mov      x25, x0
0x000084cc  str      x0, [sp, #0x8e8]
0x000084d0  adrp     x8, #0x75000
0x000084d4  add      x8, x8, #0x988   ; STR "footer"
0x000084d8  str      x8, [sp, #0x8d8]
0x000084dc  adrp     x0, #0x75000
0x000084e0  add      x0, x0, #0x9e8   ; STR "DIAG_CAR_NONE_FOOTER"
0x000084e4  bl       #0x17e20   ; CALL _L
0x000084e8  mov      x29, x29
0x000084ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000084f0  mov      x19, x0
0x000084f4  str      x0, [sp, #0x8f0]
0x000084f8  adrp     x8, #0x8e000
0x000084fc  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00008500  add      x2, sp, #0x8e0
0x00008504  add      x3, sp, #0x8c8
0x00008508  mov      w4, #3
0x0000850c  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00008510  mov      x29, x29
0x00008514  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008518  mov      x20, x0
0x0000851c  ldr      x0, [sp, #0x88]
0x00008520  mov      x2, x20
0x00008524  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00008528  mov      x0, x20
0x0000852c  bl       #0x55d78   ; CALL _objc_release
0x00008530  mov      x0, x19
0x00008534  bl       #0x55d78   ; CALL _objc_release
0x00008538  adrp     x24, #0x8e000
0x0000853c  mov      x0, x25
0x00008540  bl       #0x55d78   ; CALL _objc_release
0x00008544  mov      x0, x26
0x00008548  bl       #0x55d78   ; CALL _objc_release
0x0000854c  mov      x0, x22
0x00008550  bl       #0x55d78   ; CALL _objc_release
0x00008554  mov      x0, x21
0x00008558  bl       #0x55d78   ; CALL _objc_release
0x0000855c  mov      x0, x23
0x00008560  bl       #0x55d78   ; CALL _objc_release
0x00008564  bl       #0x687c
0x00008568  mov      x29, x29
0x0000856c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008570  mov      x20, x0
0x00008574  bl       #0x9f18
0x00008578  mov      x29, x29
0x0000857c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008580  str      x0, [sp, #0xa8]
0x00008584  adrp     x19, #0x8e000
0x00008588  ldr      x0, [x19, #0x988]   ; @CLASS NSMutableArray
0x0000858c  bl       #0x565c0   ; CALL objc_msgSend$array
0x00008590  mov      x29, x29
0x00008594  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008598  str      x0, [sp, #0xb0]
0x0000859c  ldr      x0, [x19, #0x988]   ; @CLASS NSMutableArray
0x000085a0  bl       #0x565c0   ; CALL objc_msgSend$array
0x000085a4  mov      x29, x29
0x000085a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000085ac  str      x0, [sp, #0xe8]
0x000085b0  bl       #0x18c50   ; CALL _OMCEnabled
0x000085b4  str      w0, [sp, #0xa0]
0x000085b8  movi     v0.16b, #0
0x000085bc  stp      q0, q0, [sp, #0x1e0]
0x000085c0  stp      q0, q0, [sp, #0x200]
0x000085c4  str      x20, [sp, #0xf0]
0x000085c8  mov      x0, x20
0x000085cc  bl       #0x562a0   ; CALL objc_msgSend$allKeys
0x000085d0  mov      x29, x29
0x000085d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000085d8  mov      x19, x0
0x000085dc  adrp     x8, #0x8c000
0x000085e0  ldr      x2, [x8, #0x388]   ; @SEL "compare:"
0x000085e4  bl       #0x5cd00   ; CALL objc_msgSend$sortedArrayUsingSelector:
0x000085e8  mov      x29, x29
0x000085ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000085f0  mov      x20, x0
0x000085f4  mov      x0, x19
0x000085f8  bl       #0x55d78   ; CALL _objc_release
0x000085fc  add      x2, sp, #0x1e0
0x00008600  add      x3, sp, #0x840
0x00008604  str      x20, [sp, #0x90]
0x00008608  mov      x0, x20
0x0000860c  mov      w4, #0x10
0x00008610  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00008614  str      x0, [sp, #0xb8]
0x00008618  cbz      x0, #0x8b18
0x0000861c  ldr      x8, [sp, #0x1f0]
0x00008620  ldr      x8, [x8]   ; @SEL "addObject:"
0x00008624  str      x8, [sp, #0x98]
0x00008628  adrp     x22, #0x75000
0x0000862c  add      x22, x22, #0xa68   ; STR "FEATURE_OFF"
0x00008630  mov      x25, #0
0x00008634  ldr      x8, [sp, #0x1f0]
0x00008638  ldr      x8, [x8]   ; @CSTR "addObject:"
0x0000863c  ldr      x9, [sp, #0x98]
0x00008640  cmp      x8, x9
0x00008644  b.eq     #0x8650
0x00008648  ldr      x0, [sp, #0x90]
0x0000864c  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00008650  ldr      x8, [sp, #0x1e8]
0x00008654  ldr      x20, [x8, x25, lsl #3]
0x00008658  mov      x0, x20
0x0000865c  mov      w2, #1
0x00008660  bl       #0x5d6e0   ; CALL objc_msgSend$substringToIndex:
0x00008664  mov      x29, x29
0x00008668  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000866c  mov      x19, x0
0x00008670  bl       #0x5ddc0   ; CALL objc_msgSend$uppercaseString
0x00008674  mov      x29, x29
0x00008678  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000867c  mov      x21, x0
0x00008680  str      x20, [sp, #0xf8]
0x00008684  mov      x0, x20
0x00008688  mov      w2, #1
0x0000868c  bl       #0x5d6c0   ; CALL objc_msgSend$substringFromIndex:
0x00008690  mov      x29, x29
0x00008694  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008698  mov      x23, x0
0x0000869c  mov      x0, x21
0x000086a0  mov      x2, x23
0x000086a4  bl       #0x5d440   ; CALL objc_msgSend$stringByAppendingString:
0x000086a8  mov      x29, x29
0x000086ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000086b0  mov      x26, x0
0x000086b4  mov      x0, x23
0x000086b8  bl       #0x55d78   ; CALL _objc_release
0x000086bc  mov      x0, x21
0x000086c0  bl       #0x55d78   ; CALL _objc_release
0x000086c4  mov      x0, x19
0x000086c8  bl       #0x55d78   ; CALL _objc_release
0x000086cc  ldr      x19, [x24, #0x958]   ; @CLASS NSString
0x000086d0  adrp     x0, #0x75000
0x000086d4  add      x0, x0, #0x388   ; STR "/Library/MobileSubstrate/DynamicLibraries"
0x000086d8  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x000086dc  add      x1, sp, #0x440
0x000086e0  bl       #0x4118
0x000086e4  cbz      x0, #0x8704
0x000086e8  mov      x2, x0
0x000086ec  ldr      x0, [x24, #0x958]   ; @CLASS NSString
0x000086f0  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x000086f4  mov      x29, x29
0x000086f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000086fc  mov      x21, x0
0x00008700  b        #0x8708
0x00008704  mov      x21, #0
0x00008708  stp      x21, x26, [sp]
0x0000870c  mov      x0, x19
0x00008710  adrp     x2, #0x75000
0x00008714  add      x2, x2, #0xa08   ; STR "%@/OmniCar%@.dylib"
0x00008718  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000871c  mov      x29, x29
0x00008720  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008724  mov      x28, x0
0x00008728  mov      x0, x21
0x0000872c  bl       #0x55d78   ; CALL _objc_release
0x00008730  adrp     x8, #0x8e000
0x00008734  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00008738  bl       #0x565c0   ; CALL objc_msgSend$array
0x0000873c  mov      x29, x29
0x00008740  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008744  mov      x20, x0
0x00008748  adrp     x8, #0x8e000
0x0000874c  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x00008750  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x00008754  mov      x29, x29
0x00008758  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000875c  mov      x19, x0
0x00008760  mov      x2, x28
0x00008764  bl       #0x57b40   ; CALL objc_msgSend$fileExistsAtPath:
0x00008768  mov      x21, x0
0x0000876c  mov      x0, x19
0x00008770  bl       #0x55d78   ; CALL _objc_release
0x00008774  ldr      w8, [sp, #0xa0]
0x00008778  and      w8, w21, w8
0x0000877c  cmp      w21, #0
0x00008780  adrp     x9, #0x75000
0x00008784  add      x9, x9, #0xa28   ; STR "DIAG_NOT_INSTALLED"
0x00008788  csel     x0, x22, x9, ne
0x0000878c  cmp      w8, #1
0x00008790  b.ne     #0x87ac
0x00008794  ldr      x0, [sp, #0xf8]
0x00008798  bl       #0x7a8c
0x0000879c  cmp      w0, #0
0x000087a0  adrp     x8, #0x75000
0x000087a4  add      x8, x8, #0xa48   ; STR "FEATURE_ON"
0x000087a8  csel     x0, x8, x22, ne
0x000087ac  bl       #0x17e20   ; CALL _L
0x000087b0  mov      x29, x29
0x000087b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000087b8  mov      x19, x0
0x000087bc  mov      x0, x20
0x000087c0  mov      x2, x19
0x000087c4  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x000087c8  mov      x0, x19
0x000087cc  bl       #0x55d78   ; CALL _objc_release
0x000087d0  movi     v0.16b, #0
0x000087d4  stp      q0, q0, [sp, #0x1c0]
0x000087d8  stp      q0, q0, [sp, #0x1a0]
0x000087dc  ldr      x0, [sp, #0xa8]
0x000087e0  mov      x2, x26
0x000087e4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000087e8  mov      x29, x29
0x000087ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000087f0  add      x2, sp, #0x1a0
0x000087f4  add      x3, sp, #0x3c0
0x000087f8  str      x0, [sp, #0xe0]
0x000087fc  mov      w4, #0x10
0x00008800  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00008804  str      x0, [sp, #0x108]
0x00008808  str      x20, [sp, #0xd8]
0x0000880c  cbz      x0, #0x8a5c
0x00008810  stp      x28, x26, [sp, #0xc0]
0x00008814  str      x25, [sp, #0xd0]
0x00008818  mov      x27, #0
0x0000881c  mov      x23, #0
0x00008820  ldr      x8, [sp, #0x1b0]
0x00008824  ldr      x8, [x8]   ; @STR "FEATURE_ON"
0x00008828  str      x8, [sp, #0x100]
0x0000882c  mov      x21, #0
0x00008830  ldr      x8, [sp, #0x1b0]
0x00008834  ldr      x8, [x8]   ; @STR "FEATURE_ON"
0x00008838  ldr      x9, [sp, #0x100]
0x0000883c  cmp      x8, x9
0x00008840  b.eq     #0x884c
0x00008844  ldr      x0, [sp, #0xe0]
0x00008848  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0000884c  ldr      x8, [sp, #0x1a8]
0x00008850  ldr      x28, [x8, x21, lsl #3]   ; @STR "FEATURE_ON"
0x00008854  mov      x0, x28
0x00008858  adrp     x2, #0x75000
0x0000885c  add      x2, x2, #0xa88   ; STR "missing"
0x00008860  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00008864  mov      x29, x29
0x00008868  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000886c  mov      x26, x0
0x00008870  mov      x0, x28
0x00008874  adrp     x2, #0x75000
0x00008878  add      x2, x2, #0xaa8   ; STR "total"
0x0000887c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00008880  mov      x29, x29
0x00008884  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008888  mov      x19, x0
0x0000888c  bl       #0x5dcc0   ; CALL objc_msgSend$unsignedIntegerValue
0x00008890  mov      x20, x0
0x00008894  mov      x0, x19
0x00008898  bl       #0x55d78   ; CALL _objc_release
0x0000889c  mov      x0, x26
0x000088a0  bl       #0x573c0   ; CALL objc_msgSend$count
0x000088a4  mov      x19, x0
0x000088a8  mov      x0, x26
0x000088ac  bl       #0x573c0   ; CALL objc_msgSend$count
0x000088b0  cbz      x0, #0x8994
0x000088b4  ldr      x8, [x24, #0x958]   ; @CLASS NSString
0x000088b8  str      x8, [sp, #0x118]
0x000088bc  ldp      x0, x2, [sp, #0xf0]
0x000088c0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000088c4  mov      x29, x29
0x000088c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000088cc  mov      x22, x0
0x000088d0  str      x0, [sp, #0x110]
0x000088d4  mov      x0, x28
0x000088d8  adrp     x2, #0x75000
0x000088dc  add      x2, x2, #0xae8   ; STR "process"
0x000088e0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000088e4  mov      x29, x29
0x000088e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000088ec  mov      x25, x0
0x000088f0  mov      x0, x28
0x000088f4  adrp     x2, #0x75000
0x000088f8  add      x2, x2, #0xb08   ; STR "ios"
0x000088fc  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00008900  mov      x29, x29
0x00008904  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008908  mov      x28, x0
0x0000890c  mov      x0, x26
0x00008910  adrp     x2, #0x75000
0x00008914  add      x2, x2, #0xb28   ; STR ", "
0x00008918  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x0000891c  mov      x29, x29
0x00008920  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008924  mov      x24, x19
0x00008928  mov      x19, x20
0x0000892c  mov      x20, x0
0x00008930  stp      x28, x0, [sp, #0x10]
0x00008934  stp      x22, x25, [sp]
0x00008938  ldr      x0, [sp, #0x118]
0x0000893c  adrp     x2, #0x75000
0x00008940  add      x2, x2, #0xac8   ; STR "%@ (%@, iOS %@): %@"
0x00008944  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00008948  mov      x29, x29
0x0000894c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008950  mov      x22, x0
0x00008954  ldr      x0, [sp, #0xe8]
0x00008958  mov      x2, x22
0x0000895c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00008960  mov      x0, x22
0x00008964  bl       #0x55d78   ; CALL _objc_release
0x00008968  mov      x0, x20
0x0000896c  mov      x20, x19
0x00008970  mov      x19, x24
0x00008974  bl       #0x55d78   ; CALL _objc_release
0x00008978  mov      x0, x28
0x0000897c  bl       #0x55d78   ; CALL _objc_release
0x00008980  mov      x0, x25
0x00008984  bl       #0x55d78   ; CALL _objc_release
0x00008988  ldr      x0, [sp, #0x110]
0x0000898c  adrp     x24, #0x8e000
0x00008990  bl       #0x55d78   ; CALL _objc_release
0x00008994  add      x27, x20, x27
0x00008998  add      x23, x19, x23
0x0000899c  mov      x0, x26
0x000089a0  bl       #0x55d78   ; CALL _objc_release
0x000089a4  add      x21, x21, #1
0x000089a8  ldr      x8, [sp, #0x108]
0x000089ac  cmp      x8, x21
0x000089b0  b.ne     #0x8830
0x000089b4  add      x2, sp, #0x1a0
0x000089b8  add      x3, sp, #0x3c0
0x000089bc  ldr      x0, [sp, #0xe0]
0x000089c0  mov      w4, #0x10
0x000089c4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000089c8  str      x0, [sp, #0x108]
0x000089cc  cbnz     x0, #0x882c
0x000089d0  ldr      x0, [sp, #0xe0]
0x000089d4  bl       #0x55d78   ; CALL _objc_release
0x000089d8  adrp     x22, #0x75000
0x000089dc  add      x22, x22, #0xa68   ; STR "FEATURE_OFF"
0x000089e0  ldp      x26, x25, [sp, #0xc8]
0x000089e4  ldr      x28, [sp, #0xc0]
0x000089e8  cbz      x27, #0x8a64
0x000089ec  ldr      x19, [x24, #0x958]   ; @CLASS NSString
0x000089f0  cbz      x23, #0x8a14
0x000089f4  adrp     x0, #0x75000
0x000089f8  add      x0, x0, #0xb48   ; STR "DIAG_HOOKS_MISSING"
0x000089fc  bl       #0x17e20   ; CALL _L
0x00008a00  mov      x29, x29
0x00008a04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008a08  mov      x2, x0
0x00008a0c  stp      x23, x27, [sp]
0x00008a10  b        #0x8a30
0x00008a14  adrp     x0, #0x75000
0x00008a18  add      x0, x0, #0xb68   ; STR "DIAG_HOOKS_OK"
0x00008a1c  bl       #0x17e20   ; CALL _L
0x00008a20  mov      x29, x29
0x00008a24  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008a28  mov      x2, x0
0x00008a2c  str      x27, [sp]
0x00008a30  mov      x0, x19
0x00008a34  str      x2, [sp, #0xe0]
0x00008a38  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00008a3c  mov      x29, x29
0x00008a40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008a44  mov      x19, x0
0x00008a48  ldr      x0, [sp, #0xd8]
0x00008a4c  mov      x2, x19
0x00008a50  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00008a54  mov      x0, x19
0x00008a58  bl       #0x55d78   ; CALL _objc_release
0x00008a5c  ldr      x0, [sp, #0xe0]
0x00008a60  bl       #0x55d78   ; CALL _objc_release
0x00008a64  ldp      x0, x2, [sp, #0xf0]
0x00008a68  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00008a6c  mov      x29, x29
0x00008a70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008a74  mov      x19, x0
0x00008a78  ldr      x23, [sp, #0xd8]
0x00008a7c  mov      x0, x23
0x00008a80  adrp     x2, #0x75000
0x00008a84  add      x2, x2, #0xb88   ; STR " · "
0x00008a88  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x00008a8c  mov      x29, x29
0x00008a90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008a94  mov      x20, x0
0x00008a98  mov      x0, x19
0x00008a9c  mov      x1, x20
0x00008aa0  bl       #0x93b8
0x00008aa4  mov      x29, x29
0x00008aa8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008aac  mov      x21, x0
0x00008ab0  ldr      x0, [sp, #0xb0]
0x00008ab4  mov      x2, x21
0x00008ab8  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00008abc  mov      x0, x21
0x00008ac0  bl       #0x55d78   ; CALL _objc_release
0x00008ac4  mov      x0, x20
0x00008ac8  bl       #0x55d78   ; CALL _objc_release
0x00008acc  mov      x0, x19
0x00008ad0  bl       #0x55d78   ; CALL _objc_release
0x00008ad4  mov      x0, x23
0x00008ad8  bl       #0x55d78   ; CALL _objc_release
0x00008adc  mov      x0, x28
0x00008ae0  bl       #0x55d78   ; CALL _objc_release
0x00008ae4  mov      x0, x26
0x00008ae8  bl       #0x55d78   ; CALL _objc_release
0x00008aec  add      x25, x25, #1
0x00008af0  ldr      x8, [sp, #0xb8]
0x00008af4  cmp      x25, x8
0x00008af8  b.ne     #0x8634
0x00008afc  add      x2, sp, #0x1e0
0x00008b00  add      x3, sp, #0x840
0x00008b04  ldr      x0, [sp, #0x90]
0x00008b08  mov      w4, #0x10
0x00008b0c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00008b10  str      x0, [sp, #0xb8]
0x00008b14  cbnz     x0, #0x8630
0x00008b18  ldr      x0, [sp, #0x90]
0x00008b1c  bl       #0x55d78   ; CALL _objc_release
0x00008b20  ldr      x21, [sp, #0xe8]
0x00008b24  mov      x0, x21
0x00008b28  bl       #0x573c0   ; CALL objc_msgSend$count
0x00008b2c  ldr      x20, [x24, #0x958]   ; @CLASS NSString
0x00008b30  cbz      x0, #0x8b94
0x00008b34  adrp     x0, #0x75000
0x00008b38  add      x0, x0, #0xbc8   ; STR "DIAG_HOOKS_FOOTER_MISSING"
0x00008b3c  bl       #0x17e20   ; CALL _L
0x00008b40  mov      x29, x29
0x00008b44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008b48  mov      x19, x0
0x00008b4c  adrp     x2, #0x75000
0x00008b50  add      x2, x2, #0xbe8   ; STR "\n"
0x00008b54  mov      x0, x21
0x00008b58  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x00008b5c  mov      x29, x29
0x00008b60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008b64  mov      x21, x0
0x00008b68  stp      x19, x0, [sp]
0x00008b6c  adrp     x2, #0x75000
0x00008b70  add      x2, x2, #0xba8   ; STR "%@\n%@"
0x00008b74  mov      x0, x20
0x00008b78  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00008b7c  mov      x29, x29
0x00008b80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008b84  mov      x20, x0
0x00008b88  mov      x0, x21
0x00008b8c  bl       #0x55d78   ; CALL _objc_release
0x00008b90  b        #0x8bd0
0x00008b94  adrp     x0, #0x75000
0x00008b98  add      x0, x0, #0xc08   ; STR "DIAG_FEATURES_FOOTER"
0x00008b9c  bl       #0x17e20   ; CALL _L
0x00008ba0  mov      x29, x29
0x00008ba4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008ba8  mov      x19, x0
0x00008bac  adrp     x8, #0x75000
0x00008bb0  add      x8, x8, #0xc28   ; STR "1.0.3"
0x00008bb4  str      x8, [sp]
0x00008bb8  mov      x0, x20
0x00008bbc  mov      x2, x19
0x00008bc0  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00008bc4  mov      x29, x29
0x00008bc8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008bcc  mov      x20, x0
0x00008bd0  mov      x0, x19
0x00008bd4  bl       #0x55d78   ; CALL _objc_release
0x00008bd8  adrp     x8, #0x75000
0x00008bdc  add      x8, x8, #0x4a8   ; STR "title"
0x00008be0  str      x8, [sp, #0x390]
0x00008be4  adrp     x0, #0x75000
0x00008be8  add      x0, x0, #0xc48   ; STR "FEATURES_GROUP"
0x00008bec  bl       #0x17e20   ; CALL _L
0x00008bf0  mov      x29, x29
0x00008bf4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008bf8  mov      x19, x0
0x00008bfc  str      x0, [sp, #0x3a8]
0x00008c00  ldr      x8, [sp, #0xb0]
0x00008c04  str      x8, [sp, #0x3b0]
0x00008c08  adrp     x8, #0x75000
0x00008c0c  add      x8, x8, #0x4e8   ; STR "rows"
0x00008c10  str      x8, [sp, #0x398]
0x00008c14  adrp     x8, #0x75000
0x00008c18  add      x8, x8, #0x988   ; STR "footer"
0x00008c1c  str      x8, [sp, #0x3a0]
0x00008c20  str      x20, [sp, #0x110]
0x00008c24  str      x20, [sp, #0x3b8]
0x00008c28  adrp     x8, #0x8e000
0x00008c2c  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00008c30  add      x2, sp, #0x3a8
0x00008c34  add      x3, sp, #0x390
0x00008c38  mov      w4, #3
0x00008c3c  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00008c40  mov      x29, x29
0x00008c44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008c48  mov      x21, x0
0x00008c4c  ldr      x0, [sp, #0x88]
0x00008c50  mov      x2, x21
0x00008c54  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00008c58  mov      x0, x21
0x00008c5c  bl       #0x55d78   ; CALL _objc_release
0x00008c60  mov      x0, x19
0x00008c64  bl       #0x55d78   ; CALL _objc_release
0x00008c68  bl       #0x78e8   ; CALL _OMCRescueFeatures
0x00008c6c  mov      x29, x29
0x00008c70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008c74  mov      x28, x0
0x00008c78  bl       #0x573c0   ; CALL objc_msgSend$count
0x00008c7c  cbz      x0, #0x8ea0
0x00008c80  adrp     x8, #0x8e000
0x00008c84  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00008c88  bl       #0x565c0   ; CALL objc_msgSend$array
0x00008c8c  mov      x29, x29
0x00008c90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008c94  mov      x21, x0
0x00008c98  movi     v0.16b, #0
0x00008c9c  stp      q0, q0, [sp, #0x160]
0x00008ca0  stp      q0, q0, [sp, #0x180]
0x00008ca4  mov      x0, x28
0x00008ca8  bl       #0x55d84   ; CALL _objc_retain
0x00008cac  add      x2, sp, #0x160
0x00008cb0  add      x3, sp, #0x310
0x00008cb4  mov      x0, x28
0x00008cb8  mov      w4, #0x10
0x00008cbc  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00008cc0  cbz      x0, #0x8d84
0x00008cc4  mov      x23, x0
0x00008cc8  ldr      x8, [sp, #0x170]
0x00008ccc  ldr      x19, [x8]   ; @SEL "whatsNewNavigationController"
0x00008cd0  adrp     x22, #0x75000
0x00008cd4  add      x22, x22, #0xc68   ; STR "DIAG_RESCUED"
0x00008cd8  mov      x20, #0
0x00008cdc  ldr      x8, [sp, #0x170]
0x00008ce0  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00008ce4  cmp      x8, x19
0x00008ce8  b.eq     #0x8cf4
0x00008cec  mov      x0, x28
0x00008cf0  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00008cf4  ldr      x8, [sp, #0x168]
0x00008cf8  ldr      x0, [x8, x20, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00008cfc  bl       #0x6804   ; CALL _OMCFeatureDisplayName
0x00008d00  mov      x29, x29
0x00008d04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008d08  mov      x24, x0
0x00008d0c  mov      x0, x22
0x00008d10  bl       #0x17e20   ; CALL _L
0x00008d14  mov      x29, x29
0x00008d18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008d1c  mov      x25, x0
0x00008d20  mov      x0, x24
0x00008d24  mov      x1, x25
0x00008d28  bl       #0x93b8
0x00008d2c  mov      x29, x29
0x00008d30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008d34  mov      x26, x0
0x00008d38  mov      x0, x21
0x00008d3c  mov      x2, x26
0x00008d40  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00008d44  mov      x0, x26
0x00008d48  bl       #0x55d78   ; CALL _objc_release
0x00008d4c  mov      x0, x25
0x00008d50  bl       #0x55d78   ; CALL _objc_release
0x00008d54  mov      x0, x24
0x00008d58  bl       #0x55d78   ; CALL _objc_release
0x00008d5c  add      x20, x20, #1
0x00008d60  cmp      x23, x20
0x00008d64  b.ne     #0x8cdc
0x00008d68  add      x2, sp, #0x160
0x00008d6c  add      x3, sp, #0x310
0x00008d70  mov      x0, x28
0x00008d74  mov      w4, #0x10
0x00008d78  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00008d7c  mov      x23, x0
0x00008d80  cbnz     x0, #0x8cd8
0x00008d84  mov      x0, x28
0x00008d88  bl       #0x55d78   ; CALL _objc_release
0x00008d8c  adrp     x8, #0x75000
0x00008d90  add      x8, x8, #0x4a8   ; STR "title"
0x00008d94  str      x8, [sp, #0x2e0]
0x00008d98  adrp     x0, #0x75000
0x00008d9c  add      x0, x0, #0xc88   ; STR "RESCUE_GROUP"
0x00008da0  bl       #0x17e20   ; CALL _L
0x00008da4  mov      x29, x29
0x00008da8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008dac  mov      x22, x0
0x00008db0  str      x0, [sp, #0x2f8]
0x00008db4  str      x21, [sp, #0x300]
0x00008db8  adrp     x8, #0x75000
0x00008dbc  add      x8, x8, #0x4e8   ; STR "rows"
0x00008dc0  str      x8, [sp, #0x2e8]
0x00008dc4  adrp     x8, #0x75000
0x00008dc8  add      x8, x8, #0x988   ; STR "footer"
0x00008dcc  str      x8, [sp, #0x2f0]
0x00008dd0  adrp     x8, #0x8e000
0x00008dd4  ldr      x23, [x8, #0x958]   ; @CLASS NSString
0x00008dd8  adrp     x0, #0x75000
0x00008ddc  add      x0, x0, #0xca8   ; STR "DIAG_RESCUE_FOOTER"
0x00008de0  bl       #0x17e20   ; CALL _L
0x00008de4  mov      x29, x29
0x00008de8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008dec  mov      x24, x0
0x00008df0  adrp     x0, #0x75000
0x00008df4  add      x0, x0, #0x488   ; STR "rescueDate"
0x00008df8  bl       #0x7a70
0x00008dfc  mov      x29, x29
0x00008e00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008e04  mov      x25, x0
0x00008e08  bl       #0x9ea0
0x00008e0c  mov      x29, x29
0x00008e10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008e14  mov      x26, x0
0x00008e18  str      x0, [sp]
0x00008e1c  mov      x0, x23
0x00008e20  mov      x2, x24
0x00008e24  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00008e28  mov      x29, x29
0x00008e2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008e30  mov      x23, x0
0x00008e34  str      x0, [sp, #0x308]
0x00008e38  adrp     x8, #0x8e000
0x00008e3c  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00008e40  add      x2, sp, #0x2f8
0x00008e44  add      x3, sp, #0x2e0
0x00008e48  mov      w4, #3
0x00008e4c  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00008e50  mov      x29, x29
0x00008e54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008e58  mov      x27, x0
0x00008e5c  ldr      x0, [sp, #0x88]
0x00008e60  mov      x2, x27
0x00008e64  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00008e68  mov      x0, x27
0x00008e6c  bl       #0x55d78   ; CALL _objc_release
0x00008e70  mov      x0, x23
0x00008e74  bl       #0x55d78   ; CALL _objc_release
0x00008e78  mov      x0, x26
0x00008e7c  bl       #0x55d78   ; CALL _objc_release
0x00008e80  mov      x0, x25
0x00008e84  bl       #0x55d78   ; CALL _objc_release
0x00008e88  mov      x0, x24
0x00008e8c  bl       #0x55d78   ; CALL _objc_release
0x00008e90  mov      x0, x22
0x00008e94  bl       #0x55d78   ; CALL _objc_release
0x00008e98  mov      x0, x21
0x00008e9c  bl       #0x55d78   ; CALL _objc_release
0x00008ea0  str      x28, [sp, #0x108]
0x00008ea4  adrp     x8, #0x8e000
0x00008ea8  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00008eac  bl       #0x565c0   ; CALL objc_msgSend$array
0x00008eb0  mov      x29, x29
0x00008eb4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008eb8  mov      x21, x0
0x00008ebc  movi     v0.16b, #0
0x00008ec0  stp      q0, q0, [sp, #0x120]
0x00008ec4  stp      q0, q0, [sp, #0x140]
0x00008ec8  bl       #0x6c70   ; CALL _OMCConflictingTweaks
0x00008ecc  mov      x29, x29
0x00008ed0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008ed4  add      x2, sp, #0x120
0x00008ed8  add      x3, sp, #0x260
0x00008edc  str      x0, [sp, #0x118]
0x00008ee0  mov      w4, #0x10
0x00008ee4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00008ee8  cbz      x0, #0x8ff0
0x00008eec  mov      x25, x0
0x00008ef0  ldr      x8, [sp, #0x130]
0x00008ef4  ldr      x19, [x8]   ; @SEL "whatsNewNavigationController"
0x00008ef8  adrp     x24, #0x75000
0x00008efc  add      x24, x24, #0x428   ; STR "active"
0x00008f00  adrp     x23, #0x75000
0x00008f04  add      x23, x23, #0xcc8   ; STR "DIAG_CONFLICT_ACTIVE"
0x00008f08  mov      x22, #0
0x00008f0c  ldr      x8, [sp, #0x130]
0x00008f10  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00008f14  cmp      x8, x19
0x00008f18  b.eq     #0x8f24
0x00008f1c  ldr      x0, [sp, #0x118]
0x00008f20  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00008f24  ldr      x8, [sp, #0x128]
0x00008f28  ldr      x26, [x8, x22, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00008f2c  mov      x0, x26
0x00008f30  adrp     x2, #0x75000
0x00008f34  add      x2, x2, #0x1e8   ; STR "name"
0x00008f38  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00008f3c  mov      x29, x29
0x00008f40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008f44  mov      x27, x0
0x00008f48  mov      x0, x26
0x00008f4c  mov      x2, x24
0x00008f50  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00008f54  mov      x29, x29
0x00008f58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008f5c  mov      x26, x0
0x00008f60  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00008f64  cmp      w0, #0
0x00008f68  adrp     x8, #0x75000
0x00008f6c  add      x8, x8, #0xce8   ; STR "DIAG_CONFLICT_INSTALLED"
0x00008f70  csel     x0, x23, x8, ne
0x00008f74  bl       #0x17e20   ; CALL _L
0x00008f78  mov      x29, x29
0x00008f7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008f80  mov      x28, x0
0x00008f84  mov      x0, x27
0x00008f88  mov      x1, x28
0x00008f8c  bl       #0x93b8
0x00008f90  mov      x29, x29
0x00008f94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00008f98  mov      x20, x0
0x00008f9c  mov      x0, x21
0x00008fa0  mov      x2, x20
0x00008fa4  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00008fa8  mov      x0, x20
0x00008fac  bl       #0x55d78   ; CALL _objc_release
0x00008fb0  mov      x0, x28
0x00008fb4  bl       #0x55d78   ; CALL _objc_release
0x00008fb8  mov      x0, x26
0x00008fbc  bl       #0x55d78   ; CALL _objc_release
0x00008fc0  mov      x0, x27
0x00008fc4  bl       #0x55d78   ; CALL _objc_release
0x00008fc8  add      x22, x22, #1
0x00008fcc  cmp      x25, x22
0x00008fd0  b.ne     #0x8f0c
0x00008fd4  add      x2, sp, #0x120
0x00008fd8  add      x3, sp, #0x260
0x00008fdc  ldr      x0, [sp, #0x118]
0x00008fe0  mov      w4, #0x10
0x00008fe4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00008fe8  mov      x25, x0
0x00008fec  cbnz     x0, #0x8f08
0x00008ff0  ldr      x0, [sp, #0x118]
0x00008ff4  bl       #0x55d78   ; CALL _objc_release
0x00008ff8  mov      x0, x21
0x00008ffc  bl       #0x573c0   ; CALL objc_msgSend$count
0x00009000  cbnz     x0, #0x9050
0x00009004  adrp     x0, #0x75000
0x00009008  add      x0, x0, #0xd08   ; STR "DIAG_CONFLICTS_NONE"
0x0000900c  bl       #0x17e20   ; CALL _L
0x00009010  mov      x29, x29
0x00009014  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009018  mov      x20, x0
0x0000901c  adrp     x1, #0x75000
0x00009020  add      x1, x1, #0xd28
0x00009024  bl       #0x93b8
0x00009028  mov      x29, x29
0x0000902c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009030  mov      x22, x0
0x00009034  mov      x0, x21
0x00009038  mov      x2, x22
0x0000903c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00009040  mov      x0, x22
0x00009044  bl       #0x55d78   ; CALL _objc_release
0x00009048  mov      x0, x20
0x0000904c  bl       #0x55d78   ; CALL _objc_release
0x00009050  adrp     x8, #0x75000
0x00009054  add      x8, x8, #0x4a8   ; STR "title"
0x00009058  str      x8, [sp, #0x230]
0x0000905c  adrp     x0, #0x75000
0x00009060  add      x0, x0, #0xd48   ; STR "DIAG_CONFLICTS"
0x00009064  bl       #0x17e20   ; CALL _L
0x00009068  mov      x29, x29
0x0000906c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009070  mov      x20, x0
0x00009074  str      x0, [sp, #0x248]
0x00009078  str      x21, [sp, #0x250]
0x0000907c  adrp     x8, #0x75000
0x00009080  add      x8, x8, #0x4e8   ; STR "rows"
0x00009084  str      x8, [sp, #0x238]
0x00009088  adrp     x8, #0x75000
0x0000908c  add      x8, x8, #0x988   ; STR "footer"
0x00009090  str      x8, [sp, #0x240]
0x00009094  adrp     x0, #0x75000
0x00009098  add      x0, x0, #0xd68   ; STR "DIAG_CONFLICTS_FOOTER"
0x0000909c  bl       #0x17e20   ; CALL _L
0x000090a0  mov      x29, x29
0x000090a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000090a8  mov      x22, x0
0x000090ac  str      x0, [sp, #0x258]
0x000090b0  adrp     x8, #0x8e000
0x000090b4  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x000090b8  add      x2, sp, #0x248
0x000090bc  add      x3, sp, #0x230
0x000090c0  mov      w4, #3
0x000090c4  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x000090c8  mov      x29, x29
0x000090cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000090d0  mov      x23, x0
0x000090d4  ldr      x19, [sp, #0x88]
0x000090d8  mov      x0, x19
0x000090dc  mov      x2, x23
0x000090e0  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x000090e4  mov      x0, x23
0x000090e8  bl       #0x55d78   ; CALL _objc_release
0x000090ec  mov      x0, x22
0x000090f0  bl       #0x55d78   ; CALL _objc_release
0x000090f4  mov      x0, x20
0x000090f8  bl       #0x55d78   ; CALL _objc_release
0x000090fc  mov      x0, x21
0x00009100  bl       #0x55d78   ; CALL _objc_release
0x00009104  ldr      x0, [sp, #0x108]
0x00009108  bl       #0x55d78   ; CALL _objc_release
0x0000910c  ldr      x0, [sp, #0x110]
0x00009110  bl       #0x55d78   ; CALL _objc_release
0x00009114  ldr      x0, [sp, #0xe8]
0x00009118  bl       #0x55d78   ; CALL _objc_release
0x0000911c  ldr      x0, [sp, #0xb0]
0x00009120  bl       #0x55d78   ; CALL _objc_release
0x00009124  ldr      x0, [sp, #0xa8]
0x00009128  bl       #0x55d78   ; CALL _objc_release
0x0000912c  ldr      x0, [sp, #0xf0]
0x00009130  bl       #0x55d78   ; CALL _objc_release
0x00009134  ldr      x0, [sp, #0x78]
0x00009138  bl       #0x55d78   ; CALL _objc_release
0x0000913c  ldr      x0, [sp, #0x70]
0x00009140  bl       #0x55d78   ; CALL _objc_release
0x00009144  ldr      x0, [sp, #0x80]
0x00009148  bl       #0x55d78   ; CALL _objc_release
0x0000914c  ldur     x8, [x29, #-0x70]
0x00009150  adrp     x9, #0x74000
0x00009154  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00009158  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0000915c  cmp      x9, x8
0x00009160  b.ne     #0x93b4
0x00009164  mov      x0, x19
0x00009168  add      sp, sp, #0x9c0
0x0000916c  ldp      x29, x30, [sp, #0x60]
0x00009170  ldp      x20, x19, [sp, #0x50]
0x00009174  ldp      x22, x21, [sp, #0x40]
0x00009178  ldp      x24, x23, [sp, #0x30]
0x0000917c  ldp      x26, x25, [sp, #0x20]
0x00009180  ldp      x28, x27, [sp, #0x10]
0x00009184  ldp      d9, d8, [sp], #0x70
0x00009188  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0000918c  adrp     x27, #0x77000
0x00009190  add      x27, x27, #0x588   ; STR "480p (854×480)"
0x00009194  mov      x0, x27
0x00009198  bl       #0x55d84   ; CALL _objc_retain
0x0000919c  mov      x0, x23
0x000091a0  mov      x1, x27
0x000091a4  bl       #0x93b8
0x000091a8  mov      x29, x29
0x000091ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000091b0  mov      x28, x0
0x000091b4  str      x0, [sp, #0x928]
0x000091b8  adrp     x0, #0x75000
0x000091bc  add      x0, x0, #0x948   ; STR "DIAG_CAR_LAST"
0x000091c0  bl       #0x17e20   ; CALL _L
0x000091c4  mov      x29, x29
0x000091c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000091cc  mov      x25, x0
0x000091d0  adrp     x2, #0x75000
0x000091d4  add      x2, x2, #0x968   ; STR "date"
0x000091d8  ldr      x0, [sp, #0x78]
0x000091dc  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000091e0  mov      x29, x29
0x000091e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000091e8  mov      x22, x0
0x000091ec  bl       #0x9ea0
0x000091f0  mov      x29, x29
0x000091f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000091f8  str      x26, [sp, #0x20]
0x000091fc  mov      x26, x0
0x00009200  mov      x0, x25
0x00009204  mov      x1, x26
0x00009208  bl       #0x93b8
0x0000920c  mov      x29, x29
0x00009210  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009214  mov      x21, x0
0x00009218  str      x0, [sp, #0x930]
0x0000921c  adrp     x8, #0x8e000
0x00009220  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00009224  add      x2, sp, #0x8f8
0x00009228  mov      w3, #8
0x0000922c  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00009230  mov      x29, x29
0x00009234  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009238  mov      x19, x0
0x0000923c  stur     x0, [x29, #-0xc8]
0x00009240  adrp     x8, #0x75000
0x00009244  add      x8, x8, #0x988   ; STR "footer"
0x00009248  stur     x8, [x29, #-0xd8]
0x0000924c  adrp     x0, #0x75000
0x00009250  add      x0, x0, #0x9a8   ; STR "DIAG_CAR_FOOTER"
0x00009254  bl       #0x17e20   ; CALL _L
0x00009258  mov      x29, x29
0x0000925c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009260  mov      x24, x0
0x00009264  stur     x0, [x29, #-0xc0]
0x00009268  adrp     x8, #0x8e000
0x0000926c  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00009270  sub      x2, x29, #0xd0
0x00009274  sub      x3, x29, #0xe8
0x00009278  mov      w4, #3
0x0000927c  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00009280  mov      x29, x29
0x00009284  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009288  mov      x20, x0
0x0000928c  mov      x0, x27
0x00009290  bl       #0x55d78   ; CALL _objc_release
0x00009294  ldr      x0, [sp, #0x88]
0x00009298  mov      x2, x20
0x0000929c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x000092a0  mov      x0, x20
0x000092a4  bl       #0x55d78   ; CALL _objc_release
0x000092a8  mov      x0, x24
0x000092ac  adrp     x24, #0x8e000
0x000092b0  bl       #0x55d78   ; CALL _objc_release
0x000092b4  mov      x0, x19
0x000092b8  bl       #0x55d78   ; CALL _objc_release
0x000092bc  mov      x0, x21
0x000092c0  bl       #0x55d78   ; CALL _objc_release
0x000092c4  mov      x0, x26
0x000092c8  ldr      x26, [sp, #0x20]
0x000092cc  bl       #0x55d78   ; CALL _objc_release
0x000092d0  mov      x0, x22
0x000092d4  bl       #0x55d78   ; CALL _objc_release
0x000092d8  mov      x0, x25
0x000092dc  bl       #0x55d78   ; CALL _objc_release
0x000092e0  mov      x0, x28
0x000092e4  bl       #0x55d78   ; CALL _objc_release
0x000092e8  mov      x0, x23
0x000092ec  bl       #0x55d78   ; CALL _objc_release
0x000092f0  ldr      x0, [sp, #0x28]
0x000092f4  bl       #0x55d78   ; CALL _objc_release
0x000092f8  ldr      x0, [sp, #0x30]
0x000092fc  bl       #0x55d78   ; CALL _objc_release
0x00009300  ldr      x0, [sp, #0x38]
0x00009304  bl       #0x55d78   ; CALL _objc_release
0x00009308  ldr      x0, [sp, #0x40]
0x0000930c  bl       #0x55d78   ; CALL _objc_release
0x00009310  ldr      x0, [sp, #0x48]
0x00009314  bl       #0x55d78   ; CALL _objc_release
0x00009318  ldr      x0, [sp, #0x50]
0x0000931c  bl       #0x55d78   ; CALL _objc_release
0x00009320  ldr      x0, [sp, #0x58]
0x00009324  bl       #0x55d78   ; CALL _objc_release
0x00009328  ldr      x0, [sp, #0x60]
0x0000932c  bl       #0x55d78   ; CALL _objc_release
0x00009330  ldr      x0, [sp, #0x68]
0x00009334  bl       #0x55d78   ; CALL _objc_release
0x00009338  ldr      x0, [sp, #0x90]
0x0000933c  bl       #0x55d78   ; CALL _objc_release
0x00009340  ldr      x0, [sp, #0x98]
0x00009344  bl       #0x55d78   ; CALL _objc_release
0x00009348  ldr      x0, [sp, #0xa0]
0x0000934c  bl       #0x55d78   ; CALL _objc_release
0x00009350  ldr      x0, [sp, #0xa8]
0x00009354  bl       #0x55d78   ; CALL _objc_release
0x00009358  ldr      x0, [sp, #0xb0]
0x0000935c  bl       #0x55d78   ; CALL _objc_release
0x00009360  ldr      x0, [sp, #0xb8]
0x00009364  bl       #0x55d78   ; CALL _objc_release
0x00009368  ldr      x0, [sp, #0xc0]
0x0000936c  bl       #0x55d78   ; CALL _objc_release
0x00009370  ldr      x0, [sp, #0xc8]
0x00009374  bl       #0x55d78   ; CALL _objc_release
0x00009378  ldr      x0, [sp, #0xd0]
0x0000937c  bl       #0x55d78   ; CALL _objc_release
0x00009380  ldr      x0, [sp, #0xd8]
0x00009384  bl       #0x55d78   ; CALL _objc_release
0x00009388  ldr      x0, [sp, #0xe0]
0x0000938c  bl       #0x55d78   ; CALL _objc_release
0x00009390  ldr      x0, [sp, #0xe8]
0x00009394  bl       #0x55d78   ; CALL _objc_release
0x00009398  ldr      x0, [sp, #0xf0]
0x0000939c  bl       #0x55d78   ; CALL _objc_release
0x000093a0  ldp      x22, x21, [sp, #0x110]
0x000093a4  ldp      x25, x23, [sp, #0x100]
0x000093a8  ldr      w8, [sp, #0xf8]
0x000093ac  tbz      w8, #0, #0x853c
0x000093b0  b        #0x8544
0x000093b4  bl       #0x55b98   ; CALL ___stack_chk_fail
0x000093b8  sub      sp, sp, #0x60
0x000093bc  stp      x22, x21, [sp, #0x30]
0x000093c0  stp      x20, x19, [sp, #0x40]
0x000093c4  stp      x29, x30, [sp, #0x50]
0x000093c8  add      x29, sp, #0x50
0x000093cc  mov      x20, x1
0x000093d0  mov      x21, x0
0x000093d4  adrp     x8, #0x74000
0x000093d8  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000093dc  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000093e0  str      x8, [sp, #0x28]
0x000093e4  adrp     x8, #0x77000
0x000093e8  add      x8, x8, #0x168   ; STR "label"
0x000093ec  adrp     x9, #0x77000
0x000093f0  add      x9, x9, #0x188   ; STR "value"
0x000093f4  stp      x8, x9, [sp, #8]
0x000093f8  adrp     x8, #0x77000
0x000093fc  add      x8, x8, #0x1a8   ; STR "—"
0x00009400  cmp      x1, #0
0x00009404  csel     x8, x8, x1, eq
0x00009408  stp      x0, x8, [sp, #0x18]
0x0000940c  adrp     x8, #0x8e000
0x00009410  ldr      x19, [x8, #0x970]   ; @CLASS NSDictionary
0x00009414  mov      x0, x1
0x00009418  bl       #0x55d84   ; CALL _objc_retain
0x0000941c  mov      x0, x21
0x00009420  bl       #0x55d84   ; CALL _objc_retain
0x00009424  add      x2, sp, #0x18
0x00009428  add      x3, sp, #8
0x0000942c  mov      x0, x19
0x00009430  mov      w4, #2
0x00009434  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00009438  mov      x29, x29
0x0000943c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009440  mov      x19, x0
0x00009444  mov      x0, x20
0x00009448  bl       #0x55d78   ; CALL _objc_release
0x0000944c  mov      x0, x21
0x00009450  bl       #0x55d78   ; CALL _objc_release
0x00009454  ldr      x8, [sp, #0x28]
0x00009458  adrp     x9, #0x74000
0x0000945c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00009460  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00009464  cmp      x9, x8
0x00009468  b.ne     #0x9484
0x0000946c  mov      x0, x19
0x00009470  ldp      x29, x30, [sp, #0x50]
0x00009474  ldp      x20, x19, [sp, #0x40]
0x00009478  ldp      x22, x21, [sp, #0x30]
0x0000947c  add      sp, sp, #0x60
0x00009480  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00009484  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00009488  stp      x20, x19, [sp, #-0x20]!
0x0000948c  stp      x29, x30, [sp, #0x10]
0x00009490  add      x29, sp, #0x10
0x00009494  sub      sp, sp, #0x510
0x00009498  adrp     x8, #0x74000
0x0000949c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000094a0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000094a4  stur     x8, [x29, #-0x18]
0x000094a8  add      x19, sp, #8
0x000094ac  add      x0, sp, #8
0x000094b0  bl       #0x55e68   ; CALL _uname
0x000094b4  adrp     x8, #0x8e000
0x000094b8  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x000094bc  add      x2, x19, #0x400   ; CSTR "eCell"
0x000094c0  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x000094c4  mov      x29, x29
0x000094c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000094cc  ldur     x8, [x29, #-0x18]
0x000094d0  adrp     x9, #0x74000
0x000094d4  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000094d8  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000094dc  cmp      x9, x8
0x000094e0  b.ne     #0x94f4
0x000094e4  add      sp, sp, #0x510
0x000094e8  ldp      x29, x30, [sp, #0x10]
0x000094ec  ldp      x20, x19, [sp], #0x20
0x000094f0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x000094f4  bl       #0x55b98   ; CALL ___stack_chk_fail
0x000094f8  stp      x22, x21, [sp, #-0x30]!
0x000094fc  stp      x20, x19, [sp, #0x10]
0x00009500  stp      x29, x30, [sp, #0x20]
0x00009504  add      x29, sp, #0x20
0x00009508  adrp     x8, #0x8e000
0x0000950c  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x00009510  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x00009514  mov      x29, x29
0x00009518  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000951c  mov      x19, x0
0x00009520  adrp     x2, #0x75000
0x00009524  add      x2, x2, #0xe68   ; STR "/var/jb"
0x00009528  bl       #0x57b40   ; CALL objc_msgSend$fileExistsAtPath:
0x0000952c  adrp     x8, #0x77000
0x00009530  add      x8, x8, #0x1e8   ; STR "rootful / roothide"
0x00009534  adrp     x9, #0x77000
0x00009538  add      x9, x9, #0x1c8   ; STR "rootless"
0x0000953c  cmp      w0, #0
0x00009540  csel     x20, x9, x8, ne
0x00009544  mov      x0, x20
0x00009548  bl       #0x55d84   ; CALL _objc_retain
0x0000954c  adrp     x2, #0x77000
0x00009550  add      x2, x2, #0x208   ; STR "/var/jb/.installed_dopamine"
0x00009554  mov      x0, x19
0x00009558  bl       #0x57b40   ; CALL objc_msgSend$fileExistsAtPath:
0x0000955c  tbnz     w0, #0, #0x9574
0x00009560  adrp     x2, #0x77000
0x00009564  add      x2, x2, #0x228   ; STR "/var/jb/basebin"
0x00009568  mov      x0, x19
0x0000956c  bl       #0x57b40   ; CALL objc_msgSend$fileExistsAtPath:
0x00009570  cbz      w0, #0x95b4
0x00009574  adrp     x2, #0x77000
0x00009578  add      x2, x2, #0x248   ; STR " (Dopamine)"
0x0000957c  mov      x0, x20
0x00009580  bl       #0x5d440   ; CALL objc_msgSend$stringByAppendingString:
0x00009584  mov      x29, x29
0x00009588  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000958c  mov      x21, x0
0x00009590  mov      x0, x20
0x00009594  bl       #0x55d78   ; CALL _objc_release
0x00009598  mov      x0, x19
0x0000959c  bl       #0x55d78   ; CALL _objc_release
0x000095a0  mov      x0, x21
0x000095a4  ldp      x29, x30, [sp, #0x20]
0x000095a8  ldp      x20, x19, [sp, #0x10]
0x000095ac  ldp      x22, x21, [sp], #0x30
0x000095b0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x000095b4  adrp     x2, #0x77000
0x000095b8  add      x2, x2, #0x268   ; STR "/var/jb/.installed_palera1n"
0x000095bc  mov      x0, x19
0x000095c0  bl       #0x57b40   ; CALL objc_msgSend$fileExistsAtPath:
0x000095c4  tbnz     w0, #0, #0x95dc
0x000095c8  adrp     x2, #0x77000
0x000095cc  add      x2, x2, #0x288   ; STR "/cores/binpack"
0x000095d0  mov      x0, x19
0x000095d4  bl       #0x57b40   ; CALL objc_msgSend$fileExistsAtPath:
0x000095d8  cbz      w0, #0x95e8
0x000095dc  adrp     x2, #0x77000
0x000095e0  add      x2, x2, #0x2a8   ; STR " (palera1n)"
0x000095e4  b        #0x957c
0x000095e8  mov      x0, x20
0x000095ec  bl       #0x55d84   ; CALL _objc_retain
0x000095f0  mov      x21, x20
0x000095f4  b        #0x9590
0x000095f8  stp      x20, x19, [sp, #-0x20]!
0x000095fc  stp      x29, x30, [sp, #0x10]
0x00009600  add      x29, sp, #0x10
0x00009604  adrp     x8, #0x8e000
0x00009608  ldr      x0, [x8, #0x9a8]   ; @CLASS NSProcessInfo
0x0000960c  bl       #0x59a60   ; CALL objc_msgSend$processInfo
0x00009610  mov      x29, x29
0x00009614  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009618  mov      x20, x0
0x0000961c  bl       #0x5d9e0   ; CALL objc_msgSend$thermalState
0x00009620  mov      x19, x0
0x00009624  mov      x0, x20
0x00009628  bl       #0x55d78   ; CALL _objc_release
0x0000962c  cmp      x19, #3
0x00009630  b.hi     #0x9650
0x00009634  adrp     x8, #0x74000
0x00009638  add      x8, x8, #0x7b0
0x0000963c  ldr      x0, [x8, x19, lsl #3]
0x00009640  bl       #0x17e20   ; CALL _L
0x00009644  mov      x29, x29
0x00009648  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000964c  b        #0x9658
0x00009650  adrp     x0, #0x75000
0x00009654  add      x0, x0, #0x868   ; STR "?"
0x00009658  ldp      x29, x30, [sp, #0x10]
0x0000965c  ldp      x20, x19, [sp], #0x20
0x00009660  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00009664  stp      d9, d8, [sp, #-0x40]!
0x00009668  stp      x22, x21, [sp, #0x10]
0x0000966c  stp      x20, x19, [sp, #0x20]
0x00009670  stp      x29, x30, [sp, #0x30]
0x00009674  add      x29, sp, #0x30
0x00009678  adrp     x2, #0x77000
0x0000967c  add      x2, x2, #0x348   ; STR "x"
0x00009680  bl       #0x57040   ; CALL objc_msgSend$componentsSeparatedByString:
0x00009684  mov      x29, x29
0x00009688  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000968c  mov      x19, x0
0x00009690  bl       #0x573c0   ; CALL objc_msgSend$count
0x00009694  cmp      x0, #2
0x00009698  b.ne     #0x96f0
0x0000969c  mov      x0, x19
0x000096a0  mov      x2, #0
0x000096a4  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000096a8  mov      x29, x29
0x000096ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000096b0  mov      x20, x0
0x000096b4  bl       #0x57880   ; CALL objc_msgSend$doubleValue
0x000096b8  mov      v8.16b, v0.16b
0x000096bc  mov      x0, x19
0x000096c0  mov      w2, #1
0x000096c4  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000096c8  mov      x29, x29
0x000096cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000096d0  mov      x21, x0
0x000096d4  bl       #0x57880   ; CALL objc_msgSend$doubleValue
0x000096d8  mov      v9.16b, v0.16b
0x000096dc  mov      x0, x21
0x000096e0  bl       #0x55d78   ; CALL _objc_release
0x000096e4  mov      x0, x20
0x000096e8  bl       #0x55d78   ; CALL _objc_release
0x000096ec  b        #0x96fc
0x000096f0  adrp     x8, #0x74000
0x000096f4  ldr      x8, [x8, #0x618]   ; @GOT _CGSizeZero
0x000096f8  ldp      d8, d9, [x8]
0x000096fc  mov      x0, x19
0x00009700  bl       #0x55d78   ; CALL _objc_release
0x00009704  mov      v0.16b, v8.16b
0x00009708  mov      v1.16b, v9.16b
0x0000970c  ldp      x29, x30, [sp, #0x30]
0x00009710  ldp      x20, x19, [sp, #0x20]
0x00009714  ldp      x22, x21, [sp, #0x10]
0x00009718  ldp      d9, d8, [sp], #0x40
0x0000971c  ret      
0x00009720  stp      x28, x27, [sp, #-0x60]!
0x00009724  stp      x26, x25, [sp, #0x10]
0x00009728  stp      x24, x23, [sp, #0x20]
0x0000972c  stp      x22, x21, [sp, #0x30]
0x00009730  stp      x20, x19, [sp, #0x40]
0x00009734  stp      x29, x30, [sp, #0x50]
0x00009738  add      x29, sp, #0x50
0x0000973c  sub      sp, sp, #0x1b0
0x00009740  mov      x20, x1
0x00009744  mov      x19, x0
0x00009748  adrp     x8, #0x74000
0x0000974c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00009750  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00009754  stur     x8, [x29, #-0x60]
0x00009758  bl       #0x55d84   ; CALL _objc_retain
0x0000975c  mov      x0, x20
0x00009760  bl       #0x55d84   ; CALL _objc_retain
0x00009764  movi     v0.16b, #0
0x00009768  stp      q0, q0, [sp, #0x60]
0x0000976c  stp      q0, q0, [sp, #0x80]
0x00009770  adrp     x0, #0x7f000
0x00009774  add      x0, x0, #0x8a0
0x00009778  add      x2, sp, #0x60
0x0000977c  sub      x3, x29, #0xe0
0x00009780  mov      w4, #0x10
0x00009784  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00009788  mov      x27, x0
0x0000978c  cbz      x0, #0x9954
0x00009790  ldr      x8, [sp, #0x70]
0x00009794  ldr      x21, [x8]   ; @GOT ___objc_personality_v0
0x00009798  adrp     x26, #0x8e000
0x0000979c  adrp     x24, #0x8e000
0x000097a0  adrp     x22, #0x77000
0x000097a4  add      x22, x22, #0x3a8   ; STR "nil"
0x000097a8  adrp     x23, #0x77000
0x000097ac  add      x23, x23, #0x3c8   ; STR "(null)"
0x000097b0  str      x19, [sp, #0x18]
0x000097b4  str      x21, [sp, #8]
0x000097b8  mov      x28, #0
0x000097bc  str      x27, [sp, #0x10]
0x000097c0  ldr      x8, [sp, #0x70]
0x000097c4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000097c8  cmp      x8, x21
0x000097cc  b.eq     #0x97dc
0x000097d0  adrp     x0, #0x7f000
0x000097d4  add      x0, x0, #0x8a0
0x000097d8  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x000097dc  ldr      x8, [sp, #0x68]
0x000097e0  ldr      x2, [x8, x28, lsl #3]   ; @GOT ___objc_personality_v0
0x000097e4  mov      x0, x19
0x000097e8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000097ec  mov      x29, x29
0x000097f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000097f4  mov      x25, x0
0x000097f8  ldr      x0, [x26, #0x970]   ; @CLASS NSDictionary
0x000097fc  bl       #0x55d48   ; CALL _objc_opt_class
0x00009800  mov      x1, x0
0x00009804  mov      x0, x25
0x00009808  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0000980c  tbz      w0, #0, #0x9908
0x00009810  movi     v0.16b, #0
0x00009814  stp      q0, q0, [sp, #0x40]
0x00009818  stp      q0, q0, [sp, #0x20]
0x0000981c  mov      x0, x20
0x00009820  bl       #0x55d84   ; CALL _objc_retain
0x00009824  add      x2, sp, #0x20
0x00009828  add      x3, sp, #0xa0
0x0000982c  mov      x0, x20
0x00009830  mov      w4, #0x10
0x00009834  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00009838  cbz      x0, #0x98f4
0x0000983c  mov      x26, x0
0x00009840  ldr      x8, [sp, #0x30]
0x00009844  ldr      x21, [x8]   ; @GOT ___objc_personality_v0
0x00009848  mov      x19, #0
0x0000984c  ldr      x8, [sp, #0x30]
0x00009850  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00009854  cmp      x8, x21
0x00009858  b.eq     #0x9864
0x0000985c  mov      x0, x20
0x00009860  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00009864  ldr      x8, [sp, #0x28]
0x00009868  ldr      x2, [x8, x19, lsl #3]   ; @GOT ___objc_personality_v0
0x0000986c  mov      x0, x25
0x00009870  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00009874  mov      x29, x29
0x00009878  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000987c  mov      x27, x0
0x00009880  ldr      x0, [x24, #0x958]   ; @CLASS NSString
0x00009884  bl       #0x55d48   ; CALL _objc_opt_class
0x00009888  mov      x1, x0
0x0000988c  mov      x0, x27
0x00009890  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00009894  tbz      w0, #0, #0x98c4
0x00009898  mov      x0, x27
0x0000989c  bl       #0x58c20   ; CALL objc_msgSend$length
0x000098a0  cbz      x0, #0x98c4
0x000098a4  mov      x0, x27
0x000098a8  mov      x2, x22
0x000098ac  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x000098b0  tbnz     w0, #0, #0x98c4
0x000098b4  mov      x0, x27
0x000098b8  mov      x2, x23
0x000098bc  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x000098c0  cbz      w0, #0x9940
0x000098c4  mov      x0, x27
0x000098c8  bl       #0x55d78   ; CALL _objc_release
0x000098cc  add      x19, x19, #1   ; CSTR "hatsNewNavigationController"
0x000098d0  cmp      x26, x19
0x000098d4  b.ne     #0x984c
0x000098d8  add      x2, sp, #0x20
0x000098dc  add      x3, sp, #0xa0
0x000098e0  mov      x0, x20
0x000098e4  mov      w4, #0x10
0x000098e8  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000098ec  mov      x26, x0
0x000098f0  cbnz     x0, #0x9848
0x000098f4  mov      x0, x20
0x000098f8  bl       #0x55d78   ; CALL _objc_release
0x000098fc  ldp      x27, x19, [sp, #0x10]
0x00009900  ldr      x21, [sp, #8]
0x00009904  adrp     x26, #0x8e000
0x00009908  mov      x0, x25
0x0000990c  bl       #0x55d78   ; CALL _objc_release
0x00009910  add      x28, x28, #1
0x00009914  cmp      x28, x27
0x00009918  b.ne     #0x97c0
0x0000991c  add      x2, sp, #0x60
0x00009920  sub      x3, x29, #0xe0
0x00009924  adrp     x0, #0x7f000
0x00009928  add      x0, x0, #0x8a0
0x0000992c  mov      w4, #0x10
0x00009930  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00009934  mov      x27, x0
0x00009938  cbnz     x0, #0x97b8
0x0000993c  b        #0x9954
0x00009940  mov      x0, x20
0x00009944  bl       #0x55d78   ; CALL _objc_release
0x00009948  mov      x0, x25
0x0000994c  bl       #0x55d78   ; CALL _objc_release
0x00009950  ldr      x19, [sp, #0x18]
0x00009954  mov      x0, x20
0x00009958  bl       #0x55d78   ; CALL _objc_release
0x0000995c  mov      x0, x19
0x00009960  bl       #0x55d78   ; CALL _objc_release
0x00009964  ldur     x8, [x29, #-0x60]
0x00009968  adrp     x9, #0x74000
0x0000996c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00009970  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00009974  cmp      x9, x8
0x00009978  b.ne     #0x99a0
0x0000997c  mov      x0, x27
0x00009980  add      sp, sp, #0x1b0
0x00009984  ldp      x29, x30, [sp, #0x50]
0x00009988  ldp      x20, x19, [sp, #0x40]
0x0000998c  ldp      x22, x21, [sp, #0x30]
0x00009990  ldp      x24, x23, [sp, #0x20]
0x00009994  ldp      x26, x25, [sp, #0x10]
0x00009998  ldp      x28, x27, [sp], #0x60
0x0000999c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x000099a0  bl       #0x55b98   ; CALL ___stack_chk_fail
0x000099a4  stp      x28, x27, [sp, #-0x60]!
0x000099a8  stp      x26, x25, [sp, #0x10]
0x000099ac  stp      x24, x23, [sp, #0x20]
0x000099b0  stp      x22, x21, [sp, #0x30]
0x000099b4  stp      x20, x19, [sp, #0x40]
0x000099b8  stp      x29, x30, [sp, #0x50]
0x000099bc  add      x29, sp, #0x50
0x000099c0  sub      sp, sp, #0x1b0
0x000099c4  mov      x24, x0
0x000099c8  adrp     x8, #0x74000
0x000099cc  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000099d0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000099d4  stur     x8, [x29, #-0x60]
0x000099d8  bl       #0x55d84   ; CALL _objc_retain
0x000099dc  movi     v0.16b, #0
0x000099e0  stp      q0, q0, [sp, #0x60]
0x000099e4  stp      q0, q0, [sp, #0x80]
0x000099e8  adrp     x0, #0x7f000
0x000099ec  add      x0, x0, #0x8b8
0x000099f0  add      x2, sp, #0x60
0x000099f4  sub      x3, x29, #0xe0
0x000099f8  mov      w4, #0x10
0x000099fc  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00009a00  cbz      x0, #0x9ca4
0x00009a04  mov      x26, x0
0x00009a08  adrp     x25, #0x8e000
0x00009a0c  ldr      x8, [sp, #0x70]
0x00009a10  adrp     x23, #0x77000
0x00009a14  add      x23, x23, #0x3e8   ; STR "wireless"
0x00009a18  ldr      x27, [x8]   ; @GOT ___objc_personality_v0
0x00009a1c  adrp     x28, #0x7f000
0x00009a20  add      x28, x28, #0x8b8
0x00009a24  str      x24, [sp, #0x18]
0x00009a28  str      x27, [sp, #8]
0x00009a2c  mov      x22, #0
0x00009a30  ldr      x8, [sp, #0x70]
0x00009a34  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00009a38  cmp      x8, x27
0x00009a3c  b.eq     #0x9a48
0x00009a40  mov      x0, x28
0x00009a44  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00009a48  ldr      x8, [sp, #0x68]
0x00009a4c  ldr      x2, [x8, x22, lsl #3]   ; @GOT ___objc_personality_v0
0x00009a50  mov      x0, x24
0x00009a54  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00009a58  mov      x29, x29
0x00009a5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009a60  mov      x21, x0
0x00009a64  ldr      x0, [x25, #0x970]   ; @CLASS NSDictionary
0x00009a68  bl       #0x55d48   ; CALL _objc_opt_class
0x00009a6c  mov      x1, x0
0x00009a70  mov      x0, x21
0x00009a74  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00009a78  tbz      w0, #0, #0x9c74
0x00009a7c  movi     v0.16b, #0
0x00009a80  stp      q0, q0, [sp, #0x40]
0x00009a84  stp      q0, q0, [sp, #0x20]
0x00009a88  mov      x0, x21
0x00009a8c  bl       #0x55d84   ; CALL _objc_retain
0x00009a90  add      x2, sp, #0x20
0x00009a94  add      x3, sp, #0xa0
0x00009a98  mov      x0, x21
0x00009a9c  mov      w4, #0x10
0x00009aa0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00009aa4  cbz      x0, #0x9c6c
0x00009aa8  mov      x20, x0
0x00009aac  ldr      x8, [sp, #0x30]
0x00009ab0  ldr      x19, [x8]   ; @GOT ___objc_personality_v0
0x00009ab4  str      x26, [sp, #0x10]
0x00009ab8  mov      x26, #0
0x00009abc  ldr      x8, [sp, #0x30]
0x00009ac0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00009ac4  cmp      x8, x19
0x00009ac8  b.eq     #0x9ad4
0x00009acc  mov      x0, x21
0x00009ad0  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00009ad4  ldr      x8, [sp, #0x28]
0x00009ad8  ldr      x27, [x8, x26, lsl #3]   ; @GOT ___objc_personality_v0
0x00009adc  mov      x0, x27
0x00009ae0  bl       #0x58ec0   ; CALL objc_msgSend$lowercaseString
0x00009ae4  mov      x29, x29
0x00009ae8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009aec  mov      x28, x0
0x00009af0  mov      x0, x21
0x00009af4  mov      x2, x27
0x00009af8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00009afc  mov      x29, x29
0x00009b00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009b04  mov      x25, x0
0x00009b08  bl       #0x57720   ; CALL objc_msgSend$description
0x00009b0c  mov      x29, x29
0x00009b10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009b14  mov      x24, x0
0x00009b18  bl       #0x58ec0   ; CALL objc_msgSend$lowercaseString
0x00009b1c  mov      x29, x29
0x00009b20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009b24  mov      x27, x0
0x00009b28  mov      x0, x24
0x00009b2c  bl       #0x55d78   ; CALL _objc_release
0x00009b30  mov      x0, x25
0x00009b34  bl       #0x55d78   ; CALL _objc_release
0x00009b38  mov      x0, x28
0x00009b3c  mov      x2, x23
0x00009b40  bl       #0x571e0   ; CALL objc_msgSend$containsString:
0x00009b44  cbz      w0, #0x9b70
0x00009b48  mov      x0, x27
0x00009b4c  adrp     x2, #0x77000
0x00009b50  add      x2, x2, #0x408   ; STR "1"
0x00009b54  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00009b58  tbnz     w0, #0, #0x9ccc
0x00009b5c  mov      x0, x27
0x00009b60  adrp     x2, #0x77000
0x00009b64  add      x2, x2, #0x428   ; STR "0"
0x00009b68  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00009b6c  cbnz     w0, #0x9ccc
0x00009b70  mov      x0, x28
0x00009b74  adrp     x2, #0x77000
0x00009b78  add      x2, x2, #0x488   ; STR "wired"
0x00009b7c  bl       #0x571e0   ; CALL objc_msgSend$containsString:
0x00009b80  cbz      w0, #0x9bac
0x00009b84  mov      x0, x27
0x00009b88  adrp     x2, #0x77000
0x00009b8c  add      x2, x2, #0x408   ; STR "1"
0x00009b90  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00009b94  tbnz     w0, #0, #0x9cf8
0x00009b98  mov      x0, x27
0x00009b9c  adrp     x2, #0x77000
0x00009ba0  add      x2, x2, #0x428   ; STR "0"
0x00009ba4  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00009ba8  cbnz     w0, #0x9cf8
0x00009bac  mov      x0, x28
0x00009bb0  adrp     x2, #0x77000
0x00009bb4  add      x2, x2, #0x4a8   ; STR "transport"
0x00009bb8  bl       #0x571e0   ; CALL objc_msgSend$containsString:
0x00009bbc  cbz      w0, #0x9c20
0x00009bc0  mov      x0, x27
0x00009bc4  adrp     x2, #0x77000
0x00009bc8  add      x2, x2, #0x4c8   ; STR "wifi"
0x00009bcc  bl       #0x571e0   ; CALL objc_msgSend$containsString:
0x00009bd0  tbnz     w0, #0, #0x9cc0
0x00009bd4  mov      x0, x27
0x00009bd8  mov      x2, x23
0x00009bdc  bl       #0x571e0   ; CALL objc_msgSend$containsString:
0x00009be0  tbnz     w0, #0, #0x9cc0
0x00009be4  mov      x0, x27
0x00009be8  adrp     x2, #0x77000
0x00009bec  add      x2, x2, #0x4e8   ; STR "wi-fi"
0x00009bf0  bl       #0x571e0   ; CALL objc_msgSend$containsString:
0x00009bf4  tbnz     w0, #0, #0x9cc0
0x00009bf8  mov      x0, x27
0x00009bfc  adrp     x2, #0x77000
0x00009c00  add      x2, x2, #0x508   ; STR "usb"
0x00009c04  bl       #0x571e0   ; CALL objc_msgSend$containsString:
0x00009c08  tbnz     w0, #0, #0x9d24
0x00009c0c  mov      x0, x27
0x00009c10  adrp     x2, #0x77000
0x00009c14  add      x2, x2, #0x488   ; STR "wired"
0x00009c18  bl       #0x571e0   ; CALL objc_msgSend$containsString:
0x00009c1c  tbnz     w0, #0, #0x9d24
0x00009c20  mov      x0, x27
0x00009c24  bl       #0x55d78   ; CALL _objc_release
0x00009c28  mov      x0, x28
0x00009c2c  bl       #0x55d78   ; CALL _objc_release
0x00009c30  add      x26, x26, #1
0x00009c34  cmp      x20, x26
0x00009c38  b.ne     #0x9abc
0x00009c3c  add      x2, sp, #0x20
0x00009c40  add      x3, sp, #0xa0
0x00009c44  mov      x0, x21
0x00009c48  mov      w4, #0x10
0x00009c4c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00009c50  mov      x20, x0
0x00009c54  ldp      x26, x24, [sp, #0x10]
0x00009c58  adrp     x25, #0x8e000
0x00009c5c  ldr      x27, [sp, #8]
0x00009c60  adrp     x28, #0x7f000
0x00009c64  add      x28, x28, #0x8b8
0x00009c68  cbnz     x0, #0x9ab8
0x00009c6c  mov      x0, x21
0x00009c70  bl       #0x55d78   ; CALL _objc_release
0x00009c74  mov      x0, x21
0x00009c78  bl       #0x55d78   ; CALL _objc_release
0x00009c7c  add      x22, x22, #1
0x00009c80  cmp      x22, x26
0x00009c84  b.ne     #0x9a30
0x00009c88  add      x2, sp, #0x60
0x00009c8c  sub      x3, x29, #0xe0
0x00009c90  mov      x0, x28
0x00009c94  mov      w4, #0x10
0x00009c98  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00009c9c  mov      x26, x0
0x00009ca0  cbnz     x0, #0x9a2c
0x00009ca4  adrp     x0, #0x75000
0x00009ca8  add      x0, x0, #0x788   ; STR "DIAG_UNKNOWN"
0x00009cac  bl       #0x17e20   ; CALL _L
0x00009cb0  mov      x29, x29
0x00009cb4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009cb8  mov      x20, x0
0x00009cbc  b        #0x9d60
0x00009cc0  adrp     x0, #0x77000
0x00009cc4  add      x0, x0, #0x448   ; STR "DIAG_CAR_WIRELESS"
0x00009cc8  b        #0x9d2c
0x00009ccc  adrp     x2, #0x77000
0x00009cd0  add      x2, x2, #0x408   ; STR "1"
0x00009cd4  mov      x0, x27
0x00009cd8  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00009cdc  cmp      w0, #0
0x00009ce0  adrp     x0, #0x77000
0x00009ce4  add      x0, x0, #0x448   ; STR "DIAG_CAR_WIRELESS"
0x00009ce8  adrp     x8, #0x77000
0x00009cec  add      x8, x8, #0x468   ; STR "DIAG_CAR_WIRED"
0x00009cf0  csel     x0, x0, x8, ne
0x00009cf4  b        #0x9d2c
0x00009cf8  adrp     x2, #0x77000
0x00009cfc  add      x2, x2, #0x408   ; STR "1"
0x00009d00  mov      x0, x27
0x00009d04  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00009d08  cmp      w0, #0
0x00009d0c  adrp     x0, #0x77000
0x00009d10  add      x0, x0, #0x448   ; STR "DIAG_CAR_WIRELESS"
0x00009d14  adrp     x8, #0x77000
0x00009d18  add      x8, x8, #0x468   ; STR "DIAG_CAR_WIRED"
0x00009d1c  csel     x0, x8, x0, ne
0x00009d20  b        #0x9d2c
0x00009d24  adrp     x0, #0x77000
0x00009d28  add      x0, x0, #0x468   ; STR "DIAG_CAR_WIRED"
0x00009d2c  bl       #0x17e20   ; CALL _L
0x00009d30  mov      x29, x29
0x00009d34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009d38  mov      x20, x0
0x00009d3c  mov      x0, x27
0x00009d40  bl       #0x55d78   ; CALL _objc_release
0x00009d44  mov      x0, x28
0x00009d48  bl       #0x55d78   ; CALL _objc_release
0x00009d4c  mov      x0, x21
0x00009d50  bl       #0x55d78   ; CALL _objc_release
0x00009d54  mov      x0, x21
0x00009d58  bl       #0x55d78   ; CALL _objc_release
0x00009d5c  ldr      x24, [sp, #0x18]
0x00009d60  mov      x0, x24
0x00009d64  bl       #0x55d78   ; CALL _objc_release
0x00009d68  ldur     x8, [x29, #-0x60]
0x00009d6c  adrp     x9, #0x74000
0x00009d70  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00009d74  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00009d78  cmp      x9, x8
0x00009d7c  b.ne     #0x9da4
0x00009d80  mov      x0, x20
0x00009d84  add      sp, sp, #0x1b0
0x00009d88  ldp      x29, x30, [sp, #0x50]
0x00009d8c  ldp      x20, x19, [sp, #0x40]
0x00009d90  ldp      x22, x21, [sp, #0x30]
0x00009d94  ldp      x24, x23, [sp, #0x20]
0x00009d98  ldp      x26, x25, [sp, #0x10]
0x00009d9c  ldp      x28, x27, [sp], #0x60
0x00009da0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00009da4  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00009da8  sub      sp, sp, #0x60
0x00009dac  stp      x24, x23, [sp, #0x20]
0x00009db0  stp      x22, x21, [sp, #0x30]
0x00009db4  stp      x20, x19, [sp, #0x40]
0x00009db8  stp      x29, x30, [sp, #0x50]
0x00009dbc  add      x29, sp, #0x50
0x00009dc0  fcmp     d0, d1
0x00009dc4  fcsel    d2, d1, d0, mi
0x00009dc8  fcvtas   x8, d2
0x00009dcc  fcsel    d0, d0, d1, mi
0x00009dd0  fcvtas   x20, d0
0x00009dd4  cmp      x8, #1
0x00009dd8  ccmp     x20, #1, #8, ge
0x00009ddc  b.ge     #0x9dec
0x00009de0  adrp     x20, #0x75000
0x00009de4  add      x20, x20, #0x868   ; STR "?"
0x00009de8  b        #0x9e84
0x00009dec  mov      x9, x8
0x00009df0  mov      x10, x20
0x00009df4  mov      x21, x10
0x00009df8  udiv     x10, x9, x10
0x00009dfc  msub     x10, x10, x21, x9
0x00009e00  mov      x9, x21
0x00009e04  cbnz     x10, #0x9df4
0x00009e08  adrp     x23, #0x8e000
0x00009e0c  ldr      x0, [x23, #0x958]   ; @CLASS NSString
0x00009e10  ucvtf    d0, x8
0x00009e14  ucvtf    d1, x20
0x00009e18  fdiv     d0, d0, d1
0x00009e1c  udiv     x22, x8, x21
0x00009e20  str      d0, [sp]
0x00009e24  adrp     x2, #0x77000
0x00009e28  add      x2, x2, #0x548   ; STR "%.2f:1"
0x00009e2c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00009e30  mov      x29, x29
0x00009e34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009e38  mov      x19, x0
0x00009e3c  cmp      x22, #0x21
0x00009e40  b.hs     #0x9e70
0x00009e44  ldr      x0, [x23, #0x958]   ; @CLASS NSString
0x00009e48  udiv     x8, x20, x21
0x00009e4c  stp      x8, x19, [sp, #8]
0x00009e50  str      x22, [sp]
0x00009e54  adrp     x2, #0x77000
0x00009e58  add      x2, x2, #0x568   ; STR "%ld:%ld (%@)"
0x00009e5c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00009e60  mov      x29, x29
0x00009e64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009e68  mov      x20, x0
0x00009e6c  b        #0x9e7c
0x00009e70  mov      x0, x19
0x00009e74  bl       #0x55d84   ; CALL _objc_retain
0x00009e78  mov      x20, x19
0x00009e7c  mov      x0, x19
0x00009e80  bl       #0x55d78   ; CALL _objc_release
0x00009e84  mov      x0, x20
0x00009e88  ldp      x29, x30, [sp, #0x50]
0x00009e8c  ldp      x20, x19, [sp, #0x40]
0x00009e90  ldp      x22, x21, [sp, #0x30]
0x00009e94  ldp      x24, x23, [sp, #0x20]
0x00009e98  add      sp, sp, #0x60
0x00009e9c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00009ea0  stp      x20, x19, [sp, #-0x20]!
0x00009ea4  stp      x29, x30, [sp, #0x10]
0x00009ea8  add      x29, sp, #0x10
0x00009eac  mov      x19, x0
0x00009eb0  bl       #0x55d84   ; CALL _objc_retain
0x00009eb4  adrp     x8, #0x8e000
0x00009eb8  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x00009ebc  bl       #0x55d48   ; CALL _objc_opt_class
0x00009ec0  mov      x1, x0
0x00009ec4  mov      x0, x19
0x00009ec8  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00009ecc  tbz      w0, #0, #0x9ef8
0x00009ed0  adrp     x8, #0x8e000
0x00009ed4  ldr      x0, [x8, #0x980]   ; @CLASS NSDateFormatter
0x00009ed8  mov      x2, x19
0x00009edc  mov      w3, #1
0x00009ee0  mov      w4, #1
0x00009ee4  bl       #0x58de0   ; CALL objc_msgSend$localizedStringFromDate:dateStyle:timeStyle:
0x00009ee8  mov      x29, x29
0x00009eec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009ef0  mov      x20, x0
0x00009ef4  b        #0x9f00
0x00009ef8  adrp     x20, #0x75000
0x00009efc  add      x20, x20, #0x868   ; STR "?"
0x00009f00  mov      x0, x19
0x00009f04  bl       #0x55d78   ; CALL _objc_release
0x00009f08  mov      x0, x20
0x00009f0c  ldp      x29, x30, [sp, #0x10]
0x00009f10  ldp      x20, x19, [sp], #0x20
0x00009f14  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00009f18  sub      sp, sp, #0x150
0x00009f1c  stp      x28, x27, [sp, #0xf0]
0x00009f20  stp      x26, x25, [sp, #0x100]
0x00009f24  stp      x24, x23, [sp, #0x110]
0x00009f28  stp      x22, x21, [sp, #0x120]
0x00009f2c  stp      x20, x19, [sp, #0x130]
0x00009f30  stp      x29, x30, [sp, #0x140]
0x00009f34  add      x29, sp, #0x140
0x00009f38  adrp     x8, #0x74000
0x00009f3c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00009f40  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00009f44  stur     x8, [x29, #-0x60]
0x00009f48  adrp     x8, #0x8e000
0x00009f4c  ldr      x0, [x8, #0x9d0]   ; @CLASS NSMutableDictionary
0x00009f50  bl       #0x57780   ; CALL objc_msgSend$dictionary
0x00009f54  mov      x29, x29
0x00009f58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00009f5c  str      x0, [sp, #8]
0x00009f60  adrp     x8, #0x74000
0x00009f64  ldr      x8, [x8, #0x1d0]   ; @GOT _kCFPreferencesCurrentUser
0x00009f68  ldr      x1, [x8]   ; @GOT ___objc_personality_v0
0x00009f6c  adrp     x8, #0x74000
0x00009f70  ldr      x8, [x8, #0x1c8]   ; @GOT _kCFPreferencesAnyHost
0x00009f74  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x00009f78  adrp     x0, #0x75000
0x00009f7c  add      x0, x0, #0x28   ; STR "com.anlai.omnicar"
0x00009f80  bl       #0x55868   ; CALL _CFPreferencesCopyKeyList
0x00009f84  mov      x19, x0
0x00009f88  movi     v0.16b, #0
0x00009f8c  stp      q0, q0, [sp, #0x20]
0x00009f90  stp      q0, q0, [sp, #0x40]
0x00009f94  bl       #0x55d84   ; CALL _objc_retain
0x00009f98  add      x2, sp, #0x20
0x00009f9c  add      x3, sp, #0x60
0x00009fa0  mov      x0, x19
0x00009fa4  mov      w4, #0x10
0x00009fa8  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00009fac  cbz      x0, #0xa1cc
0x00009fb0  mov      x24, x0
0x00009fb4  ldr      x8, [sp, #0x30]
0x00009fb8  adrp     x20, #0x77000
0x00009fbc  add      x20, x20, #0x5e8   ; STR "diagHooks."
0x00009fc0  adrp     x22, #0x77000
0x00009fc4  add      x22, x22, #0x608   ; STR "@"
0x00009fc8  ldr      x23, [x8]   ; @GOT ___objc_personality_v0
0x00009fcc  adrp     x28, #0x8e000
0x00009fd0  str      x23, [sp]
0x00009fd4  mov      x21, #0
0x00009fd8  str      x24, [sp, #0x10]
0x00009fdc  ldr      x8, [sp, #0x30]
0x00009fe0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00009fe4  cmp      x8, x23
0x00009fe8  b.eq     #0x9ff4
0x00009fec  mov      x0, x19
0x00009ff0  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00009ff4  ldr      x8, [sp, #0x28]
0x00009ff8  ldr      x26, [x8, x21, lsl #3]   ; @GOT ___objc_personality_v0
0x00009ffc  mov      x0, x26
0x0000a000  mov      x2, x20
0x0000a004  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x0000a008  cbz      w0, #0xa1a4
0x0000a00c  mov      x0, x26
0x0000a010  bl       #0x7a70
0x0000a014  mov      x29, x29
0x0000a018  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a01c  mov      x25, x0
0x0000a020  mov      x0, x20
0x0000a024  bl       #0x58c20   ; CALL objc_msgSend$length
0x0000a028  mov      x2, x0
0x0000a02c  mov      x0, x26
0x0000a030  bl       #0x5d6c0   ; CALL objc_msgSend$substringFromIndex:
0x0000a034  mov      x29, x29
0x0000a038  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a03c  mov      x27, x0
0x0000a040  mov      x2, x22
0x0000a044  bl       #0x57040   ; CALL objc_msgSend$componentsSeparatedByString:
0x0000a048  mov      x29, x29
0x0000a04c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a050  mov      x26, x0
0x0000a054  mov      x0, x27
0x0000a058  bl       #0x55d78   ; CALL _objc_release
0x0000a05c  ldr      x0, [x28, #0x970]   ; @CLASS NSDictionary
0x0000a060  bl       #0x55d48   ; CALL _objc_opt_class
0x0000a064  mov      x1, x0
0x0000a068  mov      x0, x25
0x0000a06c  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0000a070  tbz      w0, #0, #0xa194
0x0000a074  mov      x0, x26
0x0000a078  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000a07c  cmp      x0, #2
0x0000a080  b.ne     #0xa194
0x0000a084  mov      x0, x25
0x0000a088  bl       #0x590a0   ; CALL objc_msgSend$mutableCopy
0x0000a08c  mov      x27, x0
0x0000a090  mov      x0, x26
0x0000a094  mov      w2, #1
0x0000a098  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0000a09c  mov      x29, x29
0x0000a0a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a0a4  mov      x28, x0
0x0000a0a8  mov      x0, x27
0x0000a0ac  str      x27, [sp, #0x18]
0x0000a0b0  mov      x2, x28
0x0000a0b4  adrp     x3, #0x75000
0x0000a0b8  add      x3, x3, #0xae8   ; STR "process"
0x0000a0bc  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0000a0c0  mov      x0, x28
0x0000a0c4  bl       #0x55d78   ; CALL _objc_release
0x0000a0c8  mov      x0, x26
0x0000a0cc  mov      x2, #0
0x0000a0d0  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0000a0d4  mov      x29, x29
0x0000a0d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a0dc  mov      x28, x0
0x0000a0e0  ldr      x20, [sp, #8]
0x0000a0e4  mov      x0, x20
0x0000a0e8  mov      x2, x28
0x0000a0ec  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000a0f0  mov      x29, x29
0x0000a0f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a0f8  mov      x24, x0
0x0000a0fc  cmp      x0, #0
0x0000a100  adrp     x8, #0x74000
0x0000a104  ldr      x8, [x8, #0x1a0]   ; @GOT ___NSArray0__struct
0x0000a108  csel     x0, x8, x0, eq
0x0000a10c  mov      x2, x27
0x0000a110  bl       #0x565e0   ; CALL objc_msgSend$arrayByAddingObject:
0x0000a114  mov      x29, x29
0x0000a118  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a11c  mov      x23, x19
0x0000a120  mov      x19, x0
0x0000a124  mov      x0, x26
0x0000a128  mov      x2, #0
0x0000a12c  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0000a130  mov      x29, x29
0x0000a134  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a138  mov      x27, x22
0x0000a13c  mov      x22, x0
0x0000a140  mov      x0, x20
0x0000a144  adrp     x20, #0x77000
0x0000a148  add      x20, x20, #0x5e8   ; STR "diagHooks."
0x0000a14c  mov      x2, x19
0x0000a150  mov      x3, x22
0x0000a154  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0000a158  mov      x0, x22
0x0000a15c  mov      x22, x27
0x0000a160  bl       #0x55d78   ; CALL _objc_release
0x0000a164  mov      x0, x19
0x0000a168  mov      x19, x23
0x0000a16c  ldr      x23, [sp]
0x0000a170  bl       #0x55d78   ; CALL _objc_release
0x0000a174  mov      x0, x24
0x0000a178  ldr      x24, [sp, #0x10]
0x0000a17c  bl       #0x55d78   ; CALL _objc_release
0x0000a180  mov      x0, x28
0x0000a184  adrp     x28, #0x8e000
0x0000a188  bl       #0x55d78   ; CALL _objc_release
0x0000a18c  ldr      x0, [sp, #0x18]
0x0000a190  bl       #0x55d78   ; CALL _objc_release
0x0000a194  mov      x0, x26
0x0000a198  bl       #0x55d78   ; CALL _objc_release
0x0000a19c  mov      x0, x25
0x0000a1a0  bl       #0x55d78   ; CALL _objc_release
0x0000a1a4  add      x21, x21, #1
0x0000a1a8  cmp      x24, x21
0x0000a1ac  b.ne     #0x9fdc
0x0000a1b0  add      x2, sp, #0x20
0x0000a1b4  add      x3, sp, #0x60
0x0000a1b8  mov      x0, x19
0x0000a1bc  mov      w4, #0x10
0x0000a1c0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000a1c4  mov      x24, x0
0x0000a1c8  cbnz     x0, #0x9fd4
0x0000a1cc  mov      x0, x19
0x0000a1d0  bl       #0x55d78   ; CALL _objc_release
0x0000a1d4  mov      x0, x19
0x0000a1d8  bl       #0x55d78   ; CALL _objc_release
0x0000a1dc  ldur     x8, [x29, #-0x60]
0x0000a1e0  adrp     x9, #0x74000
0x0000a1e4  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0000a1e8  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0000a1ec  cmp      x9, x8
0x0000a1f0  b.ne     #0xa218
0x0000a1f4  ldr      x0, [sp, #8]
0x0000a1f8  ldp      x29, x30, [sp, #0x140]
0x0000a1fc  ldp      x20, x19, [sp, #0x130]
0x0000a200  ldp      x22, x21, [sp, #0x120]
0x0000a204  ldp      x24, x23, [sp, #0x110]
0x0000a208  ldp      x26, x25, [sp, #0x100]
0x0000a20c  ldp      x28, x27, [sp, #0xf0]
0x0000a210  add      sp, sp, #0x150
0x0000a214  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0000a218  bl       #0x55b98   ; CALL ___stack_chk_fail

=== _OMCDiagChecks  va=0xa21c size=22208 types=
0x0000a21c  stp      d9, d8, [sp, #-0x70]!
0x0000a220  stp      x28, x27, [sp, #0x10]
0x0000a224  stp      x26, x25, [sp, #0x20]
0x0000a228  stp      x24, x23, [sp, #0x30]
0x0000a22c  stp      x22, x21, [sp, #0x40]
0x0000a230  stp      x20, x19, [sp, #0x50]
0x0000a234  stp      x29, x30, [sp, #0x60]
0x0000a238  add      x29, sp, #0x60
0x0000a23c  sub      sp, sp, #0xda0
0x0000a240  adrp     x8, #0x74000
0x0000a244  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0000a248  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0000a24c  stur     x8, [x29, #-0x70]
0x0000a250  adrp     x0, #0x75000
0x0000a254  add      x0, x0, #0x28   ; STR "com.anlai.omnicar"
0x0000a258  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x0000a25c  adrp     x8, #0x8e000
0x0000a260  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x0000a264  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x0000a268  mov      x29, x29
0x0000a26c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a270  str      x0, [sp, #0x188]
0x0000a274  adrp     x8, #0x8e000
0x0000a278  ldr      x0, [x8, #0x998]   ; @CLASS UIDevice
0x0000a27c  bl       #0x57440   ; CALL objc_msgSend$currentDevice
0x0000a280  mov      x29, x29
0x0000a284  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a288  mov      x19, x0
0x0000a28c  bl       #0x5d8a0   ; CALL objc_msgSend$systemVersion
0x0000a290  mov      x29, x29
0x0000a294  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a298  mov      x20, x0
0x0000a29c  mov      x0, x19
0x0000a2a0  bl       #0x55d78   ; CALL _objc_release
0x0000a2a4  str      x20, [sp, #0x140]
0x0000a2a8  mov      x0, x20
0x0000a2ac  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0000a2b0  mov      x19, x0
0x0000a2b4  bl       #0x746c
0x0000a2b8  mov      x29, x29
0x0000a2bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a2c0  mov      x26, x0
0x0000a2c4  adrp     x8, #0x8e000
0x0000a2c8  ldr      x0, [x8, #0x9a0]   ; @CLASS NSMutableSet
0x0000a2cc  bl       #0x5a220   ; CALL objc_msgSend$set
0x0000a2d0  mov      x29, x29
0x0000a2d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a2d8  mov      x27, x0
0x0000a2dc  movi     v0.16b, #0
0x0000a2e0  stp      q0, q0, [sp, #0x3d0]
0x0000a2e4  stp      q0, q0, [sp, #0x3f0]
0x0000a2e8  mov      x0, x26
0x0000a2ec  bl       #0x55d84   ; CALL _objc_retain
0x0000a2f0  add      x2, sp, #0x3d0
0x0000a2f4  add      x3, sp, #0x8f0
0x0000a2f8  mov      x0, x26
0x0000a2fc  mov      w4, #0x10
0x0000a300  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000a304  cbz      x0, #0xa3a8
0x0000a308  mov      x21, x0
0x0000a30c  ldr      x8, [sp, #0x3e0]
0x0000a310  ldr      x24, [x8]   ; @SEL "whatsNewNavigationController"
0x0000a314  adrp     x20, #0x75000
0x0000a318  add      x20, x20, #0x3e8   ; STR "id"
0x0000a31c  mov      x25, #0
0x0000a320  ldr      x8, [sp, #0x3e0]
0x0000a324  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0000a328  cmp      x8, x24
0x0000a32c  b.eq     #0xa338
0x0000a330  mov      x0, x26
0x0000a334  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0000a338  ldr      x8, [sp, #0x3d8]
0x0000a33c  ldr      x0, [x8, x25, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0000a340  mov      x2, x20
0x0000a344  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000a348  mov      x29, x29
0x0000a34c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a350  mov      x22, x0
0x0000a354  bl       #0x58ec0   ; CALL objc_msgSend$lowercaseString
0x0000a358  mov      x29, x29
0x0000a35c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a360  mov      x23, x0
0x0000a364  mov      x0, x27
0x0000a368  mov      x2, x23
0x0000a36c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000a370  mov      x0, x23
0x0000a374  bl       #0x55d78   ; CALL _objc_release
0x0000a378  mov      x0, x22
0x0000a37c  bl       #0x55d78   ; CALL _objc_release
0x0000a380  add      x25, x25, #1
0x0000a384  cmp      x21, x25
0x0000a388  b.ne     #0xa320
0x0000a38c  add      x2, sp, #0x3d0
0x0000a390  add      x3, sp, #0x8f0
0x0000a394  mov      x0, x26
0x0000a398  mov      w4, #0x10
0x0000a39c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000a3a0  mov      x21, x0
0x0000a3a4  cbnz     x0, #0xa31c
0x0000a3a8  mov      x0, x26
0x0000a3ac  bl       #0x55d78   ; CALL _objc_release
0x0000a3b0  adrp     x8, #0x8e000
0x0000a3b4  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x0000a3b8  bl       #0x565c0   ; CALL objc_msgSend$array
0x0000a3bc  mov      x29, x29
0x0000a3c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a3c4  mov      x24, x0
0x0000a3c8  adrp     x8, #0x8e000
0x0000a3cc  ldr      x20, [x8, #0x958]   ; @CLASS NSString
0x0000a3d0  bl       #0x9488
0x0000a3d4  mov      x29, x29
0x0000a3d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a3dc  mov      x21, x0
0x0000a3e0  ldr      x8, [sp, #0x140]
0x0000a3e4  stp      x8, x0, [sp]
0x0000a3e8  adrp     x2, #0x75000
0x0000a3ec  add      x2, x2, #0xd88   ; STR "iOS %@ · %@"
0x0000a3f0  mov      x0, x20
0x0000a3f4  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000a3f8  mov      x29, x29
0x0000a3fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a400  mov      x23, x0
0x0000a404  mov      x0, x21
0x0000a408  bl       #0x55d78   ; CALL _objc_release
0x0000a40c  adrp     x22, #0x75000
0x0000a410  add      x22, x22, #0xe08   ; STR "ok"
0x0000a414  cmp      x19, #0xe
0x0000a418  str      x23, [sp, #0x118]
0x0000a41c  adrp     x0, #0x75000
0x0000a420  add      x0, x0, #0xda8   ; STR "CHK_IOS"
0x0000a424  b.gt     #0xa45c
0x0000a428  bl       #0x17e20   ; CALL _L
0x0000a42c  mov      x29, x29
0x0000a430  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a434  mov      x20, x0
0x0000a438  adrp     x0, #0x75000
0x0000a43c  add      x0, x0, #0xde8   ; STR "CHK_IOS_OLD"
0x0000a440  bl       #0x17e20   ; CALL _L
0x0000a444  mov      x29, x29
0x0000a448  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a44c  mov      x19, x0
0x0000a450  adrp     x1, #0x75000
0x0000a454  add      x1, x1, #0xdc8   ; STR "bad"
0x0000a458  b        #0xa4cc
0x0000a45c  bl       #0x17e20   ; CALL _L
0x0000a460  mov      x29, x29
0x0000a464  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a468  mov      x20, x0
0x0000a46c  cmp      x19, #0x10
0x0000a470  b.hi     #0xa4ac
0x0000a474  adrp     x1, #0x75000
0x0000a478  add      x1, x1, #0xe08   ; STR "ok"
0x0000a47c  mov      x0, x20
0x0000a480  mov      x2, x23
0x0000a484  mov      x3, #0
0x0000a488  mov      x4, #0
0x0000a48c  bl       #0xf0f0
0x0000a490  mov      x29, x29
0x0000a494  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a498  mov      x19, x0
0x0000a49c  mov      x0, x24
0x0000a4a0  mov      x2, x19
0x0000a4a4  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000a4a8  b        #0xa500
0x0000a4ac  adrp     x0, #0x75000
0x0000a4b0  add      x0, x0, #0xe48   ; STR "CHK_IOS_NEW"
0x0000a4b4  bl       #0x17e20   ; CALL _L
0x0000a4b8  mov      x29, x29
0x0000a4bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a4c0  mov      x19, x0
0x0000a4c4  adrp     x1, #0x75000
0x0000a4c8  add      x1, x1, #0xe28   ; STR "warn"
0x0000a4cc  mov      x0, x20
0x0000a4d0  mov      x2, x23
0x0000a4d4  mov      x3, x19
0x0000a4d8  mov      x4, #0
0x0000a4dc  bl       #0xf0f0
0x0000a4e0  mov      x29, x29
0x0000a4e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a4e8  mov      x21, x0
0x0000a4ec  mov      x0, x24
0x0000a4f0  mov      x2, x21
0x0000a4f4  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000a4f8  mov      x0, x21
0x0000a4fc  bl       #0x55d78   ; CALL _objc_release
0x0000a500  mov      x0, x19
0x0000a504  bl       #0x55d78   ; CALL _objc_release
0x0000a508  mov      x0, x20
0x0000a50c  bl       #0x55d78   ; CALL _objc_release
0x0000a510  adrp     x2, #0x75000
0x0000a514  add      x2, x2, #0xe68   ; STR "/var/jb"
0x0000a518  ldr      x0, [sp, #0x188]
0x0000a51c  bl       #0x57b40   ; CALL objc_msgSend$fileExistsAtPath:
0x0000a520  mov      x20, x0
0x0000a524  adrp     x0, #0x75000
0x0000a528  add      x0, x0, #0xe88   ; STR "CHK_JB"
0x0000a52c  bl       #0x17e20   ; CALL _L
0x0000a530  mov      x29, x29
0x0000a534  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a538  mov      x19, x0
0x0000a53c  adrp     x8, #0x75000
0x0000a540  add      x8, x8, #0xdc8   ; STR "bad"
0x0000a544  cmp      w20, #0
0x0000a548  csel     x23, x22, x8, ne
0x0000a54c  bl       #0x94f8
0x0000a550  mov      x29, x29
0x0000a554  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a558  mov      x21, x0
0x0000a55c  tbz      w20, #0, #0xa568
0x0000a560  mov      x22, #0
0x0000a564  b        #0xa580
0x0000a568  adrp     x0, #0x75000
0x0000a56c  add      x0, x0, #0xea8   ; STR "CHK_JB_ROOTFUL"
0x0000a570  bl       #0x17e20   ; CALL _L
0x0000a574  mov      x29, x29
0x0000a578  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a57c  mov      x22, x0
0x0000a580  mov      x0, x19
0x0000a584  mov      x1, x23
0x0000a588  mov      x2, x21
0x0000a58c  mov      x3, x22
0x0000a590  mov      x4, #0
0x0000a594  bl       #0xf0f0
0x0000a598  mov      x29, x29
0x0000a59c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a5a0  mov      x23, x0
0x0000a5a4  mov      x0, x24
0x0000a5a8  mov      x2, x23
0x0000a5ac  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000a5b0  mov      x0, x23
0x0000a5b4  bl       #0x55d78   ; CALL _objc_release
0x0000a5b8  tbnz     w20, #0, #0xa5c4
0x0000a5bc  mov      x0, x22
0x0000a5c0  bl       #0x55d78   ; CALL _objc_release
0x0000a5c4  mov      x0, x21
0x0000a5c8  bl       #0x55d78   ; CALL _objc_release
0x0000a5cc  mov      x0, x19
0x0000a5d0  bl       #0x55d78   ; CALL _objc_release
0x0000a5d4  movi     v0.16b, #0
0x0000a5d8  stp      q0, q0, [sp, #0x3b0]
0x0000a5dc  stp      q0, q0, [sp, #0x390]
0x0000a5e0  adrp     x0, #0x7f000
0x0000a5e4  add      x0, x0, #0x828
0x0000a5e8  add      x2, sp, #0x390
0x0000a5ec  add      x3, sp, #0x870
0x0000a5f0  mov      w4, #0x10
0x0000a5f4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000a5f8  cbz      x0, #0xa66c
0x0000a5fc  mov      x20, x0
0x0000a600  ldr      x8, [sp, #0x3a0]
0x0000a604  ldr      x21, [x8]   ; @STR "bad"
0x0000a608  adrp     x19, #0x7f000
0x0000a60c  add      x19, x19, #0x828
0x0000a610  mov      x22, #0
0x0000a614  ldr      x8, [sp, #0x3a0]
0x0000a618  ldr      x8, [x8]   ; @STR "bad"
0x0000a61c  cmp      x8, x21
0x0000a620  b.eq     #0xa62c
0x0000a624  mov      x0, x19
0x0000a628  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0000a62c  ldr      x8, [sp, #0x398]
0x0000a630  ldr      x25, [x8, x22, lsl #3]   ; @STR "bad"
0x0000a634  mov      x0, x27
0x0000a638  mov      x2, x25
0x0000a63c  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0000a640  cbnz     w0, #0xa674
0x0000a644  add      x22, x22, #1
0x0000a648  cmp      x20, x22
0x0000a64c  b.ne     #0xa614
0x0000a650  add      x2, sp, #0x390
0x0000a654  add      x3, sp, #0x870
0x0000a658  mov      x0, x19
0x0000a65c  mov      w4, #0x10
0x0000a660  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000a664  mov      x20, x0
0x0000a668  cbnz     x0, #0xa610
0x0000a66c  mov      x25, #0
0x0000a670  b        #0xa67c
0x0000a674  mov      x0, x25
0x0000a678  bl       #0x55d84   ; CALL _objc_retain
0x0000a67c  adrp     x0, #0x75000
0x0000a680  add      x0, x0, #0xf68   ; STR "/usr/lib/ellekit/libinjector.dylib"
0x0000a684  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0000a688  add      x1, sp, #0x970
0x0000a68c  bl       #0x4118
0x0000a690  cbz      x0, #0xa6c0
0x0000a694  mov      x2, x0
0x0000a698  adrp     x8, #0x8e000
0x0000a69c  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0000a6a0  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0000a6a4  mov      x29, x29
0x0000a6a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a6ac  mov      x19, x0
0x0000a6b0  bl       #0x55d84   ; CALL _objc_retain
0x0000a6b4  mov      x0, x19
0x0000a6b8  bl       #0x55d78   ; CALL _objc_release
0x0000a6bc  b        #0xa6c4
0x0000a6c0  mov      x19, #0
0x0000a6c4  ldr      x0, [sp, #0x188]
0x0000a6c8  mov      x2, x19
0x0000a6cc  bl       #0x57b40   ; CALL objc_msgSend$fileExistsAtPath:
0x0000a6d0  tbnz     w0, #0, #0xa734
0x0000a6d4  adrp     x0, #0x75000
0x0000a6d8  add      x0, x0, #0xf88   ; STR "/usr/lib/libellekit.dylib"
0x0000a6dc  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0000a6e0  add      x1, sp, #0x970
0x0000a6e4  bl       #0x4118
0x0000a6e8  cbz      x0, #0xa718
0x0000a6ec  mov      x2, x0
0x0000a6f0  adrp     x8, #0x8e000
0x0000a6f4  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0000a6f8  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0000a6fc  mov      x29, x29
0x0000a700  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a704  mov      x20, x0
0x0000a708  bl       #0x55d84   ; CALL _objc_retain
0x0000a70c  mov      x0, x20
0x0000a710  bl       #0x55d78   ; CALL _objc_release
0x0000a714  b        #0xa71c
0x0000a718  mov      x20, #0
0x0000a71c  ldr      x0, [sp, #0x188]
0x0000a720  mov      x2, x20
0x0000a724  bl       #0x57b40   ; CALL objc_msgSend$fileExistsAtPath:
0x0000a728  cbz      w0, #0xacc8
0x0000a72c  mov      x0, x20
0x0000a730  bl       #0x55d78   ; CALL _objc_release
0x0000a734  mov      x0, x19
0x0000a738  bl       #0x55d78   ; CALL _objc_release
0x0000a73c  cmp      x25, #0
0x0000a740  cset     w20, ne
0x0000a744  adrp     x0, #0x75000
0x0000a748  add      x0, x0, #0xfe8   ; STR "CHK_LOADER"
0x0000a74c  bl       #0x17e20   ; CALL _L
0x0000a750  mov      x29, x29
0x0000a754  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a758  mov      x19, x0
0x0000a75c  adrp     x2, #0x75000
0x0000a760  add      x2, x2, #0xec8   ; STR "ellekit"
0x0000a764  mov      x0, x25
0x0000a768  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0000a76c  eor      w8, w0, #1
0x0000a770  adrp     x9, #0x76000
0x0000a774  add      x9, x9, #8   ; STR "ElleKit"
0x0000a778  tst      w20, w8
0x0000a77c  csel     x2, x25, x9, ne
0x0000a780  adrp     x1, #0x75000
0x0000a784  add      x1, x1, #0xe08   ; STR "ok"
0x0000a788  mov      x0, x19
0x0000a78c  mov      x3, #0
0x0000a790  mov      x4, #0
0x0000a794  bl       #0xf0f0
0x0000a798  mov      x29, x29
0x0000a79c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a7a0  mov      x20, x0
0x0000a7a4  mov      x0, x24
0x0000a7a8  mov      x2, x20
0x0000a7ac  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000a7b0  mov      x0, x20
0x0000a7b4  bl       #0x55d78   ; CALL _objc_release
0x0000a7b8  mov      x0, x19
0x0000a7bc  bl       #0x55d78   ; CALL _objc_release
0x0000a7c0  adrp     x8, #0x8e000
0x0000a7c4  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x0000a7c8  bl       #0x565c0   ; CALL objc_msgSend$array
0x0000a7cc  mov      x29, x29
0x0000a7d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a7d4  mov      x19, x0
0x0000a7d8  movi     v0.16b, #0
0x0000a7dc  str      q0, [sp, #0x410]
0x0000a7e0  str      q0, [sp, #0x420]
0x0000a7e4  str      q0, [sp, #0x430]
0x0000a7e8  str      q0, [sp, #0x440]
0x0000a7ec  adrp     x8, #0x8e000
0x0000a7f0  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x0000a7f4  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x0000a7f8  mov      x29, x29
0x0000a7fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a800  mov      x21, x0
0x0000a804  adrp     x0, #0x75000
0x0000a808  add      x0, x0, #0x388   ; STR "/Library/MobileSubstrate/DynamicLibraries"
0x0000a80c  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0000a810  add      x1, sp, #0x970
0x0000a814  bl       #0x4118
0x0000a818  str      x24, [sp, #0x150]
0x0000a81c  stp      x27, x26, [sp, #0x120]
0x0000a820  str      x25, [sp, #0x110]
0x0000a824  cbz      x0, #0xa848
0x0000a828  mov      x2, x0
0x0000a82c  adrp     x8, #0x8e000
0x0000a830  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0000a834  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0000a838  mov      x29, x29
0x0000a83c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a840  mov      x22, x0
0x0000a844  b        #0xa84c
0x0000a848  mov      x22, #0
0x0000a84c  mov      x0, x21
0x0000a850  mov      x2, x22
0x0000a854  mov      x3, #0
0x0000a858  bl       #0x572a0   ; CALL objc_msgSend$contentsOfDirectoryAtPath:error:
0x0000a85c  mov      x29, x29
0x0000a860  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a864  mov      x20, x0
0x0000a868  mov      x0, x22
0x0000a86c  bl       #0x55d78   ; CALL _objc_release
0x0000a870  mov      x0, x21
0x0000a874  bl       #0x55d78   ; CALL _objc_release
0x0000a878  add      x2, sp, #0x410
0x0000a87c  add      x3, sp, #0x970
0x0000a880  mov      x0, x20
0x0000a884  mov      w4, #0x10
0x0000a888  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000a88c  cbz      x0, #0xa978
0x0000a890  mov      x23, x0
0x0000a894  ldr      x8, [sp, #0x420]
0x0000a898  ldr      x27, [x8]   ; @SEL "whatsNewNavigationController"
0x0000a89c  adrp     x21, #0x75000
0x0000a8a0  add      x21, x21, #0x508   ; STR "OmniCar"
0x0000a8a4  adrp     x22, #0x75000
0x0000a8a8  add      x22, x22, #0x3c8   ; STR "dylib"
0x0000a8ac  mov      x28, #0
0x0000a8b0  ldr      x8, [sp, #0x420]
0x0000a8b4  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0000a8b8  cmp      x8, x27
0x0000a8bc  b.eq     #0xa8c8
0x0000a8c0  mov      x0, x20
0x0000a8c4  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0000a8c8  ldr      x8, [sp, #0x418]
0x0000a8cc  ldr      x24, [x8, x28, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0000a8d0  mov      x0, x24
0x0000a8d4  mov      x2, x21
0x0000a8d8  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x0000a8dc  cbz      w0, #0xa950
0x0000a8e0  mov      x0, x24
0x0000a8e4  bl       #0x59620   ; CALL objc_msgSend$pathExtension
0x0000a8e8  mov      x29, x29
0x0000a8ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a8f0  mov      x25, x0
0x0000a8f4  mov      x2, x22
0x0000a8f8  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0000a8fc  mov      x26, x0
0x0000a900  mov      x0, x25
0x0000a904  bl       #0x55d78   ; CALL _objc_release
0x0000a908  cbz      w26, #0xa950
0x0000a90c  mov      x0, x24
0x0000a910  bl       #0x5d480   ; CALL objc_msgSend$stringByDeletingPathExtension
0x0000a914  mov      x29, x29
0x0000a918  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a91c  mov      x24, x0
0x0000a920  mov      w2, #7
0x0000a924  bl       #0x5d6c0   ; CALL objc_msgSend$substringFromIndex:
0x0000a928  mov      x29, x29
0x0000a92c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a930  mov      x25, x0
0x0000a934  mov      x0, x19
0x0000a938  mov      x2, x25
0x0000a93c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000a940  mov      x0, x25
0x0000a944  bl       #0x55d78   ; CALL _objc_release
0x0000a948  mov      x0, x24
0x0000a94c  bl       #0x55d78   ; CALL _objc_release
0x0000a950  add      x28, x28, #1
0x0000a954  cmp      x23, x28
0x0000a958  b.ne     #0xa8b0
0x0000a95c  add      x2, sp, #0x410
0x0000a960  add      x3, sp, #0x970
0x0000a964  mov      x0, x20
0x0000a968  mov      w4, #0x10
0x0000a96c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000a970  mov      x23, x0
0x0000a974  cbnz     x0, #0xa8ac
0x0000a978  mov      x0, x20
0x0000a97c  bl       #0x55d78   ; CALL _objc_release
0x0000a980  adrp     x8, #0x8c000
0x0000a984  ldr      x2, [x8, #0x388]   ; @SEL "compare:"
0x0000a988  mov      x0, x19
0x0000a98c  str      x2, [sp, #0x78]
0x0000a990  bl       #0x5cd00   ; CALL objc_msgSend$sortedArrayUsingSelector:
0x0000a994  mov      x29, x29
0x0000a998  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a99c  mov      x20, x0
0x0000a9a0  mov      x0, x19
0x0000a9a4  bl       #0x55d78   ; CALL _objc_release
0x0000a9a8  adrp     x8, #0x8e000
0x0000a9ac  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x0000a9b0  bl       #0x565c0   ; CALL objc_msgSend$array
0x0000a9b4  mov      x29, x29
0x0000a9b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000a9bc  str      x0, [sp, #0x168]
0x0000a9c0  movi     v0.16b, #0
0x0000a9c4  stp      q0, q0, [sp, #0x350]
0x0000a9c8  stp      q0, q0, [sp, #0x370]
0x0000a9cc  mov      x0, x20
0x0000a9d0  bl       #0x55d84   ; CALL _objc_retain
0x0000a9d4  add      x2, sp, #0x350
0x0000a9d8  add      x3, sp, #0x7f0
0x0000a9dc  str      x20, [sp, #0x198]
0x0000a9e0  mov      x0, x20
0x0000a9e4  mov      w4, #0x10
0x0000a9e8  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000a9ec  cbz      x0, #0xab34
0x0000a9f0  mov      x20, x0
0x0000a9f4  ldr      x8, [sp, #0x360]
0x0000a9f8  adrp     x9, #0x74000
0x0000a9fc  ldr      x9, [x9, #0x120]   ; @GOT _NSFilePosixPermissions
0x0000aa00  ldr      x28, [x8]   ; @SEL "whatsNewNavigationController"
0x0000aa04  ldr      x19, [x9]   ; @GOT ___objc_personality_v0
0x0000aa08  adrp     x21, #0x75000
0x0000aa0c  add      x21, x21, #0x388   ; STR "/Library/MobileSubstrate/DynamicLibraries"
0x0000aa10  adrp     x22, #0x76000
0x0000aa14  add      x22, x22, #0x68   ; STR "%@/OmniCar%@.plist"
0x0000aa18  mov      x27, #0
0x0000aa1c  ldr      x8, [sp, #0x360]
0x0000aa20  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0000aa24  cmp      x8, x28
0x0000aa28  b.eq     #0xaa34
0x0000aa2c  ldr      x0, [sp, #0x198]
0x0000aa30  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0000aa34  ldr      x8, [sp, #0x358]
0x0000aa38  ldr      x23, [x8, x27, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0000aa3c  adrp     x25, #0x8e000
0x0000aa40  ldr      x24, [x25, #0x958]   ; @CLASS NSString
0x0000aa44  mov      x0, x21
0x0000aa48  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0000aa4c  add      x1, sp, #0x970
0x0000aa50  bl       #0x4118
0x0000aa54  cbz      x0, #0xaa80
0x0000aa58  mov      x2, x0
0x0000aa5c  ldr      x0, [x25, #0x958]   ; @CLASS NSString
0x0000aa60  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0000aa64  mov      x29, x29
0x0000aa68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000aa6c  mov      x25, x0
0x0000aa70  bl       #0x55d84   ; CALL _objc_retain
0x0000aa74  mov      x0, x25
0x0000aa78  bl       #0x55d78   ; CALL _objc_release
0x0000aa7c  b        #0xaa84
0x0000aa80  mov      x25, #0
0x0000aa84  stp      x25, x23, [sp]
0x0000aa88  mov      x0, x24
0x0000aa8c  mov      x2, x22
0x0000aa90  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000aa94  mov      x29, x29
0x0000aa98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000aa9c  mov      x24, x0
0x0000aaa0  mov      x0, x25
0x0000aaa4  bl       #0x55d78   ; CALL _objc_release
0x0000aaa8  ldr      x0, [sp, #0x188]
0x0000aaac  mov      x2, x24
0x0000aab0  mov      x3, #0
0x0000aab4  bl       #0x56700   ; CALL objc_msgSend$attributesOfItemAtPath:error:
0x0000aab8  mov      x29, x29
0x0000aabc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000aac0  mov      x26, x0
0x0000aac4  mov      x2, x19
0x0000aac8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000aacc  mov      x29, x29
0x0000aad0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000aad4  mov      x25, x0
0x0000aad8  mov      x0, x26
0x0000aadc  bl       #0x55d78   ; CALL _objc_release
0x0000aae0  cbz      x25, #0xaaf0
0x0000aae4  mov      x0, x25
0x0000aae8  bl       #0x5dce0   ; CALL objc_msgSend$unsignedShortValue
0x0000aaec  tbnz     w0, #2, #0xaafc
0x0000aaf0  ldr      x0, [sp, #0x168]
0x0000aaf4  mov      x2, x23
0x0000aaf8  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000aafc  mov      x0, x25
0x0000ab00  bl       #0x55d78   ; CALL _objc_release
0x0000ab04  mov      x0, x24
0x0000ab08  bl       #0x55d78   ; CALL _objc_release
0x0000ab0c  add      x27, x27, #1   ; CSTR "hatsNewNavigationController"
0x0000ab10  cmp      x20, x27
0x0000ab14  b.ne     #0xaa1c
0x0000ab18  add      x2, sp, #0x350
0x0000ab1c  add      x3, sp, #0x7f0
0x0000ab20  ldr      x0, [sp, #0x198]
0x0000ab24  mov      w4, #0x10
0x0000ab28  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000ab2c  mov      x20, x0
0x0000ab30  cbnz     x0, #0xaa18
0x0000ab34  ldr      x19, [sp, #0x198]
0x0000ab38  mov      x0, x19
0x0000ab3c  bl       #0x55d78   ; CALL _objc_release
0x0000ab40  mov      x0, x19
0x0000ab44  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000ab48  cbz      x0, #0xac3c
0x0000ab4c  ldr      x21, [sp, #0x168]
0x0000ab50  mov      x0, x21
0x0000ab54  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000ab58  mov      x20, x0
0x0000ab5c  adrp     x0, #0x76000
0x0000ab60  add      x0, x0, #0x88   ; STR "CHK_PACKAGE"
0x0000ab64  bl       #0x17e20   ; CALL _L
0x0000ab68  mov      x29, x29
0x0000ab6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ab70  mov      x19, x0
0x0000ab74  adrp     x26, #0x8e000
0x0000ab78  ldr      x22, [x26, #0x958]   ; @CLASS NSString
0x0000ab7c  adrp     x27, #0x8e000
0x0000ab80  cbz      x20, #0xad0c
0x0000ab84  adrp     x0, #0x76000
0x0000ab88  add      x0, x0, #0xe8   ; STR "CHK_PACKAGE_BROKEN"
0x0000ab8c  bl       #0x17e20   ; CALL _L
0x0000ab90  mov      x29, x29
0x0000ab94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ab98  mov      x20, x0
0x0000ab9c  adrp     x2, #0x75000
0x0000aba0  add      x2, x2, #0xb28   ; STR ", "
0x0000aba4  mov      x0, x21
0x0000aba8  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x0000abac  mov      x29, x29
0x0000abb0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000abb4  mov      x21, x0
0x0000abb8  str      x0, [sp]
0x0000abbc  mov      x0, x22
0x0000abc0  mov      x2, x20
0x0000abc4  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000abc8  mov      x29, x29
0x0000abcc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000abd0  mov      x22, x0
0x0000abd4  adrp     x0, #0x76000
0x0000abd8  add      x0, x0, #0xc8   ; STR "CHK_PACKAGE_FIX"
0x0000abdc  bl       #0x17e20   ; CALL _L
0x0000abe0  mov      x29, x29
0x0000abe4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000abe8  mov      x23, x0
0x0000abec  adrp     x1, #0x75000
0x0000abf0  add      x1, x1, #0xdc8   ; STR "bad"
0x0000abf4  mov      x0, x19
0x0000abf8  mov      x2, x22
0x0000abfc  mov      x3, x23
0x0000ac00  mov      x4, #0
0x0000ac04  bl       #0xf0f0
0x0000ac08  mov      x29, x29
0x0000ac0c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ac10  mov      x24, x0
0x0000ac14  ldr      x25, [sp, #0x150]
0x0000ac18  mov      x0, x25
0x0000ac1c  mov      x2, x24
0x0000ac20  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000ac24  mov      x0, x24
0x0000ac28  mov      x24, x25
0x0000ac2c  bl       #0x55d78   ; CALL _objc_release
0x0000ac30  mov      x0, x23
0x0000ac34  bl       #0x55d78   ; CALL _objc_release
0x0000ac38  b        #0xad88
0x0000ac3c  adrp     x0, #0x76000
0x0000ac40  add      x0, x0, #0x88   ; STR "CHK_PACKAGE"
0x0000ac44  bl       #0x17e20   ; CALL _L
0x0000ac48  mov      x29, x29
0x0000ac4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ac50  mov      x19, x0
0x0000ac54  adrp     x0, #0x76000
0x0000ac58  add      x0, x0, #0xa8   ; STR "CHK_PACKAGE_NONE"
0x0000ac5c  bl       #0x17e20   ; CALL _L
0x0000ac60  mov      x29, x29
0x0000ac64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ac68  mov      x20, x0
0x0000ac6c  adrp     x0, #0x76000
0x0000ac70  add      x0, x0, #0xc8   ; STR "CHK_PACKAGE_FIX"
0x0000ac74  bl       #0x17e20   ; CALL _L
0x0000ac78  mov      x29, x29
0x0000ac7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ac80  mov      x21, x0
0x0000ac84  adrp     x1, #0x75000
0x0000ac88  add      x1, x1, #0xdc8   ; STR "bad"
0x0000ac8c  mov      x0, x19
0x0000ac90  mov      x2, x20
0x0000ac94  mov      x3, x21
0x0000ac98  mov      x4, #0
0x0000ac9c  bl       #0xf0f0
0x0000aca0  mov      x29, x29
0x0000aca4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000aca8  mov      x22, x0
0x0000acac  ldr      x24, [sp, #0x150]
0x0000acb0  mov      x0, x24
0x0000acb4  mov      x2, x22
0x0000acb8  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000acbc  adrp     x26, #0x8e000
0x0000acc0  adrp     x27, #0x8e000
0x0000acc4  b        #0xad88
0x0000acc8  adrp     x0, #0x75000
0x0000accc  add      x0, x0, #0xfa8   ; STR "/usr/lib/libsubstrate.dylib"
0x0000acd0  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0000acd4  add      x1, sp, #0x970
0x0000acd8  bl       #0x4118
0x0000acdc  cbz      x0, #0xcb3c
0x0000ace0  mov      x2, x0
0x0000ace4  adrp     x8, #0x8e000
0x0000ace8  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0000acec  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0000acf0  mov      x29, x29
0x0000acf4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000acf8  mov      x21, x0
0x0000acfc  bl       #0x55d84   ; CALL _objc_retain
0x0000ad00  mov      x0, x21
0x0000ad04  bl       #0x55d78   ; CALL _objc_release
0x0000ad08  b        #0xcb40
0x0000ad0c  adrp     x0, #0x76000
0x0000ad10  add      x0, x0, #0x108   ; STR "CHK_PACKAGE_OK"
0x0000ad14  bl       #0x17e20   ; CALL _L
0x0000ad18  mov      x29, x29
0x0000ad1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ad20  mov      x20, x0
0x0000ad24  ldr      x0, [sp, #0x198]
0x0000ad28  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000ad2c  adrp     x8, #0x75000
0x0000ad30  add      x8, x8, #0x528   ; STR "1.0.3 (fbebb21)"
0x0000ad34  stp      x8, x0, [sp]
0x0000ad38  mov      x0, x22
0x0000ad3c  mov      x2, x20
0x0000ad40  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000ad44  mov      x29, x29
0x0000ad48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ad4c  mov      x21, x0
0x0000ad50  adrp     x1, #0x75000
0x0000ad54  add      x1, x1, #0xe08   ; STR "ok"
0x0000ad58  mov      x0, x19
0x0000ad5c  mov      x2, x21
0x0000ad60  mov      x3, #0
0x0000ad64  mov      x4, #0
0x0000ad68  bl       #0xf0f0
0x0000ad6c  mov      x29, x29
0x0000ad70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ad74  mov      x22, x0
0x0000ad78  ldr      x24, [sp, #0x150]
0x0000ad7c  mov      x0, x24
0x0000ad80  mov      x2, x22
0x0000ad84  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000ad88  mov      x0, x22
0x0000ad8c  bl       #0x55d78   ; CALL _objc_release
0x0000ad90  mov      x0, x21
0x0000ad94  bl       #0x55d78   ; CALL _objc_release
0x0000ad98  mov      x0, x20
0x0000ad9c  bl       #0x55d78   ; CALL _objc_release
0x0000ada0  mov      x0, x19
0x0000ada4  bl       #0x55d78   ; CALL _objc_release
0x0000ada8  str      xzr, [sp, #0x348]
0x0000adac  adrp     x1, #0x76000
0x0000adb0  add      x1, x1, #0x128   ; STR "SpringBoard"
0x0000adb4  add      x2, sp, #0x348
0x0000adb8  ldr      x0, [sp, #0x198]
0x0000adbc  bl       #0xf260
0x0000adc0  mov      x29, x29
0x0000adc4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000adc8  mov      x20, x0
0x0000adcc  ldr      x22, [sp, #0x348]
0x0000add0  mov      x0, x22
0x0000add4  bl       #0x55d84   ; CALL _objc_retain
0x0000add8  adrp     x19, #0x75000
0x0000addc  add      x19, x19, #0xe08   ; STR "ok"
0x0000ade0  mov      x0, x20
0x0000ade4  mov      x2, x19
0x0000ade8  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0000adec  stp      x20, x22, [sp, #0x100]
0x0000adf0  cbz      w0, #0xae9c
0x0000adf4  adrp     x0, #0x76000
0x0000adf8  add      x0, x0, #0x148   ; STR "CHK_RUNNING"
0x0000adfc  bl       #0x17e20   ; CALL _L
0x0000ae00  mov      x29, x29
0x0000ae04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ae08  mov      x20, x0
0x0000ae0c  ldr      x23, [x26, #0x958]   ; @CLASS NSString
0x0000ae10  adrp     x0, #0x76000
0x0000ae14  add      x0, x0, #0x168   ; STR "CHK_RUNNING_OK"
0x0000ae18  bl       #0x17e20   ; CALL _L
0x0000ae1c  mov      x29, x29
0x0000ae20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ae24  mov      x21, x0
0x0000ae28  mov      x0, x22
0x0000ae2c  bl       #0xf6c0
0x0000ae30  mov      x29, x29
0x0000ae34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ae38  mov      x22, x0
0x0000ae3c  str      x0, [sp]
0x0000ae40  mov      x0, x23
0x0000ae44  mov      x2, x21
0x0000ae48  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000ae4c  mov      x29, x29
0x0000ae50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ae54  mov      x23, x0
0x0000ae58  adrp     x1, #0x75000
0x0000ae5c  add      x1, x1, #0xe08   ; STR "ok"
0x0000ae60  mov      x0, x20
0x0000ae64  mov      x2, x23
0x0000ae68  mov      x3, #0
0x0000ae6c  mov      x4, #0
0x0000ae70  bl       #0xf0f0
0x0000ae74  mov      x29, x29
0x0000ae78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ae7c  mov      x24, x0
0x0000ae80  ldr      x0, [sp, #0x150]
0x0000ae84  mov      x2, x24
0x0000ae88  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000ae8c  mov      x0, x24
0x0000ae90  ldr      x24, [sp, #0x150]
0x0000ae94  bl       #0x55d78   ; CALL _objc_release
0x0000ae98  b        #0xaf70
0x0000ae9c  adrp     x2, #0x76000
0x0000aea0  add      x2, x2, #0x188   ; STR "old"
0x0000aea4  mov      x0, x20
0x0000aea8  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0000aeac  mov      x21, x0
0x0000aeb0  adrp     x0, #0x76000
0x0000aeb4  add      x0, x0, #0x148   ; STR "CHK_RUNNING"
0x0000aeb8  bl       #0x17e20   ; CALL _L
0x0000aebc  mov      x29, x29
0x0000aec0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000aec4  mov      x20, x0
0x0000aec8  cbz      w21, #0xaf08
0x0000aecc  adrp     x0, #0x76000
0x0000aed0  add      x0, x0, #0x1a8   ; STR "CHK_RUNNING_OLD"
0x0000aed4  bl       #0x17e20   ; CALL _L
0x0000aed8  mov      x29, x29
0x0000aedc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000aee0  mov      x21, x0
0x0000aee4  adrp     x0, #0x76000
0x0000aee8  add      x0, x0, #0x1c8   ; STR "CHK_RUNNING_RESPRING"
0x0000aeec  bl       #0x17e20   ; CALL _L
0x0000aef0  mov      x29, x29
0x0000aef4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000aef8  mov      x22, x0
0x0000aefc  adrp     x1, #0x75000
0x0000af00  add      x1, x1, #0xe28   ; STR "warn"
0x0000af04  b        #0xaf40
0x0000af08  adrp     x0, #0x76000
0x0000af0c  add      x0, x0, #0x208   ; STR "CHK_RUNNING_NONE"
0x0000af10  bl       #0x17e20   ; CALL _L
0x0000af14  mov      x29, x29
0x0000af18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000af1c  mov      x21, x0
0x0000af20  adrp     x0, #0x76000
0x0000af24  add      x0, x0, #0x228   ; STR "CHK_RUNNING_NONE_FIX"
0x0000af28  bl       #0x17e20   ; CALL _L
0x0000af2c  mov      x29, x29
0x0000af30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000af34  mov      x22, x0
0x0000af38  adrp     x1, #0x75000
0x0000af3c  add      x1, x1, #0xdc8   ; STR "bad"
0x0000af40  adrp     x4, #0x76000
0x0000af44  add      x4, x4, #0x1e8   ; STR "respring"
0x0000af48  mov      x0, x20
0x0000af4c  mov      x2, x21
0x0000af50  mov      x3, x22
0x0000af54  bl       #0xf0f0
0x0000af58  mov      x29, x29
0x0000af5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000af60  mov      x23, x0
0x0000af64  mov      x0, x24
0x0000af68  mov      x2, x23
0x0000af6c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000af70  mov      x0, x23
0x0000af74  bl       #0x55d78   ; CALL _objc_release
0x0000af78  mov      x0, x22
0x0000af7c  bl       #0x55d78   ; CALL _objc_release
0x0000af80  mov      x0, x21
0x0000af84  bl       #0x55d78   ; CALL _objc_release
0x0000af88  mov      x0, x20
0x0000af8c  bl       #0x55d78   ; CALL _objc_release
0x0000af90  bl       #0x18c50   ; CALL _OMCEnabled
0x0000af94  tbnz     w0, #0, #0xb034
0x0000af98  adrp     x0, #0x76000
0x0000af9c  add      x0, x0, #0x248   ; STR "CHK_MASTER"
0x0000afa0  bl       #0x17e20   ; CALL _L
0x0000afa4  mov      x29, x29
0x0000afa8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000afac  mov      x20, x0
0x0000afb0  adrp     x0, #0x76000
0x0000afb4  add      x0, x0, #0x268   ; STR "STATUS_OFF"
0x0000afb8  bl       #0x17e20   ; CALL _L
0x0000afbc  mov      x29, x29
0x0000afc0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000afc4  mov      x21, x0
0x0000afc8  adrp     x0, #0x76000
0x0000afcc  add      x0, x0, #0x288   ; STR "CHK_MASTER_FIX"
0x0000afd0  bl       #0x17e20   ; CALL _L
0x0000afd4  mov      x29, x29
0x0000afd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000afdc  mov      x22, x0
0x0000afe0  adrp     x1, #0x75000
0x0000afe4  add      x1, x1, #0xe28   ; STR "warn"
0x0000afe8  mov      x0, x20
0x0000afec  mov      x2, x21
0x0000aff0  mov      x3, x22
0x0000aff4  mov      x4, #0
0x0000aff8  bl       #0xf0f0
0x0000affc  mov      x29, x29
0x0000b000  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b004  mov      x23, x0
0x0000b008  mov      x0, x24
0x0000b00c  mov      x2, x23
0x0000b010  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000b014  mov      x0, x23
0x0000b018  bl       #0x55d78   ; CALL _objc_release
0x0000b01c  mov      x0, x22
0x0000b020  bl       #0x55d78   ; CALL _objc_release
0x0000b024  mov      x0, x21
0x0000b028  bl       #0x55d78   ; CALL _objc_release
0x0000b02c  mov      x0, x20
0x0000b030  bl       #0x55d78   ; CALL _objc_release
0x0000b034  adrp     x2, #0x76000
0x0000b038  add      x2, x2, #0x2a8   ; STR "/var"
0x0000b03c  ldr      x0, [sp, #0x188]
0x0000b040  mov      x3, #0
0x0000b044  bl       #0x566e0   ; CALL objc_msgSend$attributesOfFileSystemForPath:error:
0x0000b048  mov      x29, x29
0x0000b04c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b050  mov      x20, x0
0x0000b054  adrp     x8, #0x74000
0x0000b058  ldr      x8, [x8, #0x128]   ; @GOT _NSFileSystemFreeSize
0x0000b05c  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0000b060  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000b064  mov      x29, x29
0x0000b068  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b06c  mov      x23, x0
0x0000b070  mov      x0, x20
0x0000b074  bl       #0x55d78   ; CALL _objc_release
0x0000b078  mov      x0, x23
0x0000b07c  bl       #0x57880   ; CALL objc_msgSend$doubleValue
0x0000b080  adrp     x8, #0x65000
0x0000b084  ldr      d1, [x8, #0x620]
0x0000b088  ldr      x20, [x26, #0x958]   ; @CLASS NSString
0x0000b08c  fdiv     d8, d0, d1
0x0000b090  adrp     x0, #0x76000
0x0000b094  add      x0, x0, #0x2c8   ; STR "CHK_STORAGE_FREE"
0x0000b098  bl       #0x17e20   ; CALL _L
0x0000b09c  mov      x29, x29
0x0000b0a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b0a4  mov      x21, x0
0x0000b0a8  str      d8, [sp]
0x0000b0ac  mov      x0, x20
0x0000b0b0  mov      x2, x21
0x0000b0b4  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000b0b8  mov      x29, x29
0x0000b0bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b0c0  mov      x22, x0
0x0000b0c4  mov      x0, x21
0x0000b0c8  bl       #0x55d78   ; CALL _objc_release
0x0000b0cc  str      x22, [sp, #0xf0]
0x0000b0d0  cbz      x23, #0xb11c
0x0000b0d4  fmov     d0, #0.50000000
0x0000b0d8  fcmp     d8, d0
0x0000b0dc  b.pl     #0xb11c
0x0000b0e0  adrp     x0, #0x76000
0x0000b0e4  add      x0, x0, #0x2e8   ; STR "CHK_STORAGE"
0x0000b0e8  bl       #0x17e20   ; CALL _L
0x0000b0ec  mov      x29, x29
0x0000b0f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b0f4  mov      x20, x0
0x0000b0f8  adrp     x0, #0x76000
0x0000b0fc  add      x0, x0, #0x308   ; STR "CHK_STORAGE_FIX"
0x0000b100  bl       #0x17e20   ; CALL _L
0x0000b104  mov      x29, x29
0x0000b108  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b10c  mov      x21, x0
0x0000b110  adrp     x1, #0x75000
0x0000b114  add      x1, x1, #0xdc8   ; STR "bad"
0x0000b118  b        #0xb164
0x0000b11c  adrp     x0, #0x76000
0x0000b120  add      x0, x0, #0x2e8   ; STR "CHK_STORAGE"
0x0000b124  bl       #0x17e20   ; CALL _L
0x0000b128  mov      x29, x29
0x0000b12c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b130  mov      x20, x0
0x0000b134  cbz      x23, #0xb790
0x0000b138  fmov     d0, #2.00000000
0x0000b13c  fcmp     d8, d0
0x0000b140  b.pl     #0xb790
0x0000b144  adrp     x0, #0x76000
0x0000b148  add      x0, x0, #0x308   ; STR "CHK_STORAGE_FIX"
0x0000b14c  bl       #0x17e20   ; CALL _L
0x0000b150  mov      x29, x29
0x0000b154  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b158  mov      x21, x0
0x0000b15c  adrp     x1, #0x75000
0x0000b160  add      x1, x1, #0xe28   ; STR "warn"
0x0000b164  mov      x0, x20
0x0000b168  mov      x2, x22
0x0000b16c  mov      x3, x21
0x0000b170  mov      x4, #0
0x0000b174  bl       #0xf0f0
0x0000b178  mov      x29, x29
0x0000b17c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b180  mov      x22, x0
0x0000b184  mov      x0, x24
0x0000b188  mov      x2, x22
0x0000b18c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000b190  mov      x0, x22
0x0000b194  bl       #0x55d78   ; CALL _objc_release
0x0000b198  mov      x0, x21
0x0000b19c  bl       #0x55d78   ; CALL _objc_release
0x0000b1a0  mov      x0, x20
0x0000b1a4  bl       #0x55d78   ; CALL _objc_release
0x0000b1a8  ldr      x0, [x27, #0x998]   ; @CLASS UIDevice
0x0000b1ac  bl       #0x57440   ; CALL objc_msgSend$currentDevice
0x0000b1b0  mov      x29, x29
0x0000b1b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b1b8  mov      x21, x0
0x0000b1bc  mov      w2, #1
0x0000b1c0  bl       #0x5a620   ; CALL objc_msgSend$setBatteryMonitoringEnabled:
0x0000b1c4  mov      x0, x21
0x0000b1c8  bl       #0x56720   ; CALL objc_msgSend$batteryLevel
0x0000b1cc  adrp     x22, #0x75000
0x0000b1d0  add      x22, x22, #0x868   ; STR "?"
0x0000b1d4  fcmp     s0, #0.0
0x0000b1d8  b.lt     #0xb224
0x0000b1dc  ldr      x20, [x26, #0x958]   ; @CLASS NSString
0x0000b1e0  mov      x0, x21
0x0000b1e4  bl       #0x56720   ; CALL objc_msgSend$batteryLevel
0x0000b1e8  mov      w8, #0x42c80000
0x0000b1ec  fmov     s1, w8
0x0000b1f0  fmul     s0, s0, s1
0x0000b1f4  fcvt     d0, s0
0x0000b1f8  str      d0, [sp]
0x0000b1fc  adrp     x2, #0x76000
0x0000b200  add      x2, x2, #0x328   ; STR "%.0f%%"
0x0000b204  mov      x0, x20
0x0000b208  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000b20c  mov      x29, x29
0x0000b210  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b214  mov      x22, x0
0x0000b218  bl       #0x55d84   ; CALL _objc_retain
0x0000b21c  mov      x0, x22
0x0000b220  bl       #0x55d78   ; CALL _objc_release
0x0000b224  mov      x0, x21
0x0000b228  bl       #0x56760   ; CALL objc_msgSend$batteryState
0x0000b22c  cmp      x0, #2
0x0000b230  str      x21, [sp, #0xe8]
0x0000b234  b.eq     #0xb248
0x0000b238  mov      x0, x21
0x0000b23c  bl       #0x56760   ; CALL objc_msgSend$batteryState
0x0000b240  cmp      x0, #3
0x0000b244  b.ne     #0xb294
0x0000b248  adrp     x0, #0x76000
0x0000b24c  add      x0, x0, #0x368   ; STR "CHK_BATTERY_CHARGING"
0x0000b250  bl       #0x17e20   ; CALL _L
0x0000b254  mov      x29, x29
0x0000b258  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b25c  mov      x20, x0
0x0000b260  str      x0, [sp]
0x0000b264  adrp     x2, #0x76000
0x0000b268  add      x2, x2, #0x348   ; STR " · %@"
0x0000b26c  mov      x0, x22
0x0000b270  bl       #0x5d400   ; CALL objc_msgSend$stringByAppendingFormat:
0x0000b274  mov      x29, x29
0x0000b278  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b27c  mov      x21, x0
0x0000b280  mov      x0, x22
0x0000b284  bl       #0x55d78   ; CALL _objc_release
0x0000b288  mov      x0, x20
0x0000b28c  bl       #0x55d78   ; CALL _objc_release
0x0000b290  mov      x22, x21
0x0000b294  adrp     x25, #0x75000
0x0000b298  add      x25, x25, #0xe28   ; STR "warn"
0x0000b29c  adrp     x26, #0x8e000
0x0000b2a0  ldr      x0, [x26, #0x9a8]   ; @CLASS NSProcessInfo
0x0000b2a4  bl       #0x59a60   ; CALL objc_msgSend$processInfo
0x0000b2a8  mov      x29, x29
0x0000b2ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b2b0  mov      x20, x0
0x0000b2b4  bl       #0x588a0   ; CALL objc_msgSend$isLowPowerModeEnabled
0x0000b2b8  mov      x21, x0
0x0000b2bc  mov      x0, x20
0x0000b2c0  bl       #0x55d78   ; CALL _objc_release
0x0000b2c4  adrp     x0, #0x76000
0x0000b2c8  add      x0, x0, #0x388   ; STR "CHK_BATTERY"
0x0000b2cc  bl       #0x17e20   ; CALL _L
0x0000b2d0  mov      x29, x29
0x0000b2d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b2d8  mov      x20, x0
0x0000b2dc  str      x23, [sp, #0xf8]
0x0000b2e0  str      x22, [sp, #0xe0]
0x0000b2e4  cbz      w21, #0xb3b8
0x0000b2e8  adrp     x0, #0x76000
0x0000b2ec  add      x0, x0, #0x3a8   ; STR "CHK_LOWPOWER"
0x0000b2f0  bl       #0x17e20   ; CALL _L
0x0000b2f4  mov      x29, x29
0x0000b2f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b2fc  mov      x21, x0
0x0000b300  str      x0, [sp]
0x0000b304  adrp     x2, #0x76000
0x0000b308  add      x2, x2, #0x348   ; STR " · %@"
0x0000b30c  mov      x0, x22
0x0000b310  bl       #0x5d400   ; CALL objc_msgSend$stringByAppendingFormat:
0x0000b314  mov      x29, x29
0x0000b318  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b31c  mov      x22, x0
0x0000b320  adrp     x0, #0x76000
0x0000b324  add      x0, x0, #0x3c8   ; STR "CHK_LOWPOWER_FIX"
0x0000b328  bl       #0x17e20   ; CALL _L
0x0000b32c  mov      x29, x29
0x0000b330  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b334  mov      x23, x0
0x0000b338  adrp     x1, #0x75000
0x0000b33c  add      x1, x1, #0xe28   ; STR "warn"
0x0000b340  mov      x0, x20
0x0000b344  mov      x2, x22
0x0000b348  mov      x3, x23
0x0000b34c  mov      x4, #0
0x0000b350  bl       #0xf0f0
0x0000b354  mov      x29, x29
0x0000b358  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b35c  mov      x27, x24
0x0000b360  mov      x24, x0
0x0000b364  bl       #0x590a0   ; CALL objc_msgSend$mutableCopy
0x0000b368  mov      x25, x0
0x0000b36c  adrp     x2, #0x74000
0x0000b370  ldr      x2, [x2, #0x1b8]   ; @GOT ___kCFBooleanTrue
0x0000b374  adrp     x3, #0x77000
0x0000b378  add      x3, x3, #0x728   ; STR "perf"
0x0000b37c  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0000b380  mov      x0, x27
0x0000b384  mov      x2, x25
0x0000b388  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000b38c  mov      x0, x25
0x0000b390  adrp     x25, #0x75000
0x0000b394  add      x25, x25, #0xe28   ; STR "warn"
0x0000b398  bl       #0x55d78   ; CALL _objc_release
0x0000b39c  mov      x0, x24
0x0000b3a0  bl       #0x55d78   ; CALL _objc_release
0x0000b3a4  mov      x0, x23
0x0000b3a8  bl       #0x55d78   ; CALL _objc_release
0x0000b3ac  mov      x0, x22
0x0000b3b0  bl       #0x55d78   ; CALL _objc_release
0x0000b3b4  b        #0xb3ec
0x0000b3b8  adrp     x1, #0x75000
0x0000b3bc  add      x1, x1, #0xe08   ; STR "ok"
0x0000b3c0  mov      x0, x20
0x0000b3c4  mov      x2, x22
0x0000b3c8  mov      x3, #0
0x0000b3cc  mov      x4, #0
0x0000b3d0  bl       #0xf0f0
0x0000b3d4  mov      x29, x29
0x0000b3d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b3dc  mov      x21, x0
0x0000b3e0  mov      x0, x24
0x0000b3e4  mov      x2, x21
0x0000b3e8  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000b3ec  adrp     x22, #0x75000
0x0000b3f0  add      x22, x22, #0xdc8   ; STR "bad"
0x0000b3f4  mov      x0, x21
0x0000b3f8  bl       #0x55d78   ; CALL _objc_release
0x0000b3fc  mov      x0, x20
0x0000b400  bl       #0x55d78   ; CALL _objc_release
0x0000b404  ldr      x0, [x26, #0x9a8]   ; @CLASS NSProcessInfo
0x0000b408  bl       #0x59a60   ; CALL objc_msgSend$processInfo
0x0000b40c  mov      x29, x29
0x0000b410  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b414  mov      x20, x0
0x0000b418  bl       #0x5d9e0   ; CALL objc_msgSend$thermalState
0x0000b41c  mov      x21, x0
0x0000b420  mov      x0, x20
0x0000b424  bl       #0x55d78   ; CALL _objc_release
0x0000b428  cmp      x21, #2
0x0000b42c  csel     x8, x25, x19, eq
0x0000b430  csel     x23, x22, x8, gt
0x0000b434  mov      x0, x23
0x0000b438  bl       #0x55d84   ; CALL _objc_retain
0x0000b43c  adrp     x0, #0x75000
0x0000b440  add      x0, x0, #0x5c8   ; STR "DIAG_THERMAL"
0x0000b444  bl       #0x17e20   ; CALL _L
0x0000b448  mov      x29, x29
0x0000b44c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b450  mov      x20, x0
0x0000b454  bl       #0x95f8
0x0000b458  mov      x29, x29
0x0000b45c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b460  mov      x21, x0
0x0000b464  mov      x0, x23
0x0000b468  mov      x2, x19
0x0000b46c  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0000b470  mov      x19, x0
0x0000b474  tbz      w0, #0, #0xb480
0x0000b478  mov      x22, #0
0x0000b47c  b        #0xb498
0x0000b480  adrp     x0, #0x76000
0x0000b484  add      x0, x0, #0x3e8   ; STR "CHK_THERMAL_FIX"
0x0000b488  bl       #0x17e20   ; CALL _L
0x0000b48c  mov      x29, x29
0x0000b490  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b494  mov      x22, x0
0x0000b498  mov      x0, x20
0x0000b49c  str      x23, [sp, #0xd8]
0x0000b4a0  mov      x1, x23
0x0000b4a4  mov      x2, x21
0x0000b4a8  mov      x3, x22
0x0000b4ac  mov      x4, #0
0x0000b4b0  bl       #0xf0f0
0x0000b4b4  mov      x29, x29
0x0000b4b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b4bc  mov      x23, x0
0x0000b4c0  bl       #0x590a0   ; CALL objc_msgSend$mutableCopy
0x0000b4c4  mov      x24, x0
0x0000b4c8  adrp     x2, #0x74000
0x0000b4cc  ldr      x2, [x2, #0x1b8]   ; @GOT ___kCFBooleanTrue
0x0000b4d0  adrp     x3, #0x77000
0x0000b4d4  add      x3, x3, #0x728   ; STR "perf"
0x0000b4d8  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0000b4dc  ldr      x0, [sp, #0x150]
0x0000b4e0  mov      x2, x24
0x0000b4e4  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000b4e8  mov      x0, x24
0x0000b4ec  bl       #0x55d78   ; CALL _objc_release
0x0000b4f0  mov      x0, x23
0x0000b4f4  bl       #0x55d78   ; CALL _objc_release
0x0000b4f8  tbnz     w19, #0, #0xb504
0x0000b4fc  mov      x0, x22
0x0000b500  bl       #0x55d78   ; CALL _objc_release
0x0000b504  mov      x0, x21
0x0000b508  bl       #0x55d78   ; CALL _objc_release
0x0000b50c  mov      x0, x20
0x0000b510  bl       #0x55d78   ; CALL _objc_release
0x0000b514  adrp     x19, #0x8e000
0x0000b518  ldr      x0, [x19, #0x988]   ; @CLASS NSMutableArray
0x0000b51c  bl       #0x565c0   ; CALL objc_msgSend$array
0x0000b520  mov      x29, x29
0x0000b524  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b528  mov      x28, x0
0x0000b52c  ldr      x0, [x19, #0x988]   ; @CLASS NSMutableArray
0x0000b530  bl       #0x565c0   ; CALL objc_msgSend$array
0x0000b534  mov      x29, x29
0x0000b538  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b53c  str      x0, [sp, #0x180]
0x0000b540  movi     v0.16b, #0
0x0000b544  stp      q0, q0, [sp, #0x300]
0x0000b548  stp      q0, q0, [sp, #0x320]
0x0000b54c  bl       #0x6c70   ; CALL _OMCConflictingTweaks
0x0000b550  mov      x29, x29
0x0000b554  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b558  mov      x19, x0
0x0000b55c  add      x2, sp, #0x300
0x0000b560  add      x3, sp, #0x770
0x0000b564  mov      w4, #0x10
0x0000b568  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000b56c  cbz      x0, #0xb634
0x0000b570  mov      x22, x0
0x0000b574  ldr      x8, [sp, #0x310]
0x0000b578  ldr      x24, [x8]   ; @CSTR "m.fill"
0x0000b57c  adrp     x20, #0x75000
0x0000b580  add      x20, x20, #0x428   ; STR "active"
0x0000b584  adrp     x21, #0x75000
0x0000b588  add      x21, x21, #0x1e8   ; STR "name"
0x0000b58c  mov      x27, #0
0x0000b590  ldr      x8, [sp, #0x310]
0x0000b594  ldr      x8, [x8]   ; @CSTR "m.fill"
0x0000b598  cmp      x8, x24
0x0000b59c  b.eq     #0xb5a8
0x0000b5a0  mov      x0, x19
0x0000b5a4  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0000b5a8  ldr      x8, [sp, #0x308]
0x0000b5ac  ldr      x23, [x8, x27, lsl #3]
0x0000b5b0  mov      x0, x23
0x0000b5b4  mov      x2, x20
0x0000b5b8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000b5bc  mov      x29, x29
0x0000b5c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b5c4  mov      x25, x0
0x0000b5c8  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x0000b5cc  cmp      w0, #0
0x0000b5d0  ldr      x8, [sp, #0x180]
0x0000b5d4  csel     x26, x28, x8, ne
0x0000b5d8  mov      x0, x23
0x0000b5dc  mov      x2, x21
0x0000b5e0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000b5e4  mov      x29, x29
0x0000b5e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b5ec  mov      x23, x0
0x0000b5f0  mov      x0, x26
0x0000b5f4  mov      x2, x23
0x0000b5f8  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000b5fc  mov      x0, x23
0x0000b600  bl       #0x55d78   ; CALL _objc_release
0x0000b604  mov      x0, x25
0x0000b608  bl       #0x55d78   ; CALL _objc_release
0x0000b60c  add      x27, x27, #1
0x0000b610  cmp      x22, x27
0x0000b614  b.ne     #0xb590
0x0000b618  add      x2, sp, #0x300
0x0000b61c  add      x3, sp, #0x770
0x0000b620  mov      x0, x19
0x0000b624  mov      w4, #0x10
0x0000b628  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000b62c  mov      x22, x0
0x0000b630  cbnz     x0, #0xb58c
0x0000b634  mov      x0, x19
0x0000b638  bl       #0x55d78   ; CALL _objc_release
0x0000b63c  mov      x0, x28
0x0000b640  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000b644  mov      x20, x0
0x0000b648  adrp     x0, #0x76000
0x0000b64c  add      x0, x0, #0x408   ; STR "CHK_CONFLICT"
0x0000b650  bl       #0x17e20   ; CALL _L
0x0000b654  mov      x29, x29
0x0000b658  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b65c  mov      x19, x0
0x0000b660  cbz      x20, #0xb71c
0x0000b664  adrp     x27, #0x8e000
0x0000b668  ldr      x22, [x27, #0x958]   ; @CLASS NSString
0x0000b66c  adrp     x0, #0x76000
0x0000b670  add      x0, x0, #0x428   ; STR "CHK_CONFLICT_ACTIVE"
0x0000b674  bl       #0x17e20   ; CALL _L
0x0000b678  mov      x29, x29
0x0000b67c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b680  mov      x20, x0
0x0000b684  adrp     x2, #0x75000
0x0000b688  add      x2, x2, #0xb28   ; STR ", "
0x0000b68c  mov      x0, x28
0x0000b690  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x0000b694  mov      x29, x29
0x0000b698  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b69c  mov      x21, x0
0x0000b6a0  str      x0, [sp]
0x0000b6a4  mov      x0, x22
0x0000b6a8  mov      x2, x20
0x0000b6ac  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000b6b0  mov      x29, x29
0x0000b6b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b6b8  mov      x22, x0
0x0000b6bc  adrp     x0, #0x76000
0x0000b6c0  add      x0, x0, #0x448   ; STR "CONFLICTS_FOOTER"
0x0000b6c4  bl       #0x17e20   ; CALL _L
0x0000b6c8  mov      x29, x29
0x0000b6cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b6d0  mov      x23, x0
0x0000b6d4  adrp     x1, #0x75000
0x0000b6d8  add      x1, x1, #0xdc8   ; STR "bad"
0x0000b6dc  mov      x0, x19
0x0000b6e0  mov      x2, x22
0x0000b6e4  mov      x3, x23
0x0000b6e8  mov      x4, #0
0x0000b6ec  bl       #0xf0f0
0x0000b6f0  mov      x29, x29
0x0000b6f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b6f8  mov      x25, x0
0x0000b6fc  ldr      x0, [sp, #0x150]
0x0000b700  mov      x2, x25
0x0000b704  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000b708  mov      x0, x25
0x0000b70c  bl       #0x55d78   ; CALL _objc_release
0x0000b710  mov      x0, x23
0x0000b714  bl       #0x55d78   ; CALL _objc_release
0x0000b718  b        #0xb850
0x0000b71c  ldr      x21, [sp, #0x180]
0x0000b720  mov      x0, x21
0x0000b724  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000b728  mov      x23, x0
0x0000b72c  ldr      x24, [sp, #0x150]
0x0000b730  adrp     x27, #0x8e000
0x0000b734  cbz      x0, #0xb7f4
0x0000b738  ldr      x22, [x27, #0x958]   ; @CLASS NSString
0x0000b73c  adrp     x0, #0x76000
0x0000b740  add      x0, x0, #0x468   ; STR "CHK_CONFLICT_IDLE"
0x0000b744  bl       #0x17e20   ; CALL _L
0x0000b748  mov      x29, x29
0x0000b74c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b750  mov      x20, x0
0x0000b754  adrp     x2, #0x75000
0x0000b758  add      x2, x2, #0xb28   ; STR ", "
0x0000b75c  mov      x0, x21
0x0000b760  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x0000b764  mov      x29, x29
0x0000b768  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b76c  mov      x21, x0
0x0000b770  str      x0, [sp]
0x0000b774  mov      x0, x22
0x0000b778  mov      x2, x20
0x0000b77c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000b780  mov      x29, x29
0x0000b784  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b788  mov      x22, x0
0x0000b78c  b        #0xb810
0x0000b790  mov      x21, x22
0x0000b794  cbnz     x23, #0xb7b0
0x0000b798  adrp     x0, #0x75000
0x0000b79c  add      x0, x0, #0x788   ; STR "DIAG_UNKNOWN"
0x0000b7a0  bl       #0x17e20   ; CALL _L
0x0000b7a4  mov      x29, x29
0x0000b7a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b7ac  mov      x21, x0
0x0000b7b0  adrp     x1, #0x75000
0x0000b7b4  add      x1, x1, #0xe08   ; STR "ok"
0x0000b7b8  mov      x0, x20
0x0000b7bc  mov      x2, x21
0x0000b7c0  mov      x3, #0
0x0000b7c4  mov      x4, #0
0x0000b7c8  bl       #0xf0f0
0x0000b7cc  mov      x29, x29
0x0000b7d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b7d4  mov      x22, x0
0x0000b7d8  mov      x0, x24
0x0000b7dc  mov      x2, x22
0x0000b7e0  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000b7e4  mov      x0, x22
0x0000b7e8  bl       #0x55d78   ; CALL _objc_release
0x0000b7ec  cbz      x23, #0xb198
0x0000b7f0  b        #0xb1a0
0x0000b7f4  adrp     x0, #0x75000
0x0000b7f8  add      x0, x0, #0xd08   ; STR "DIAG_CONFLICTS_NONE"
0x0000b7fc  bl       #0x17e20   ; CALL _L
0x0000b800  mov      x29, x29
0x0000b804  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b808  mov      x22, x0
0x0000b80c  mov      x20, x0
0x0000b810  adrp     x1, #0x75000
0x0000b814  add      x1, x1, #0xe08   ; STR "ok"
0x0000b818  mov      x0, x19
0x0000b81c  mov      x2, x22
0x0000b820  mov      x3, #0
0x0000b824  mov      x4, #0
0x0000b828  bl       #0xf0f0
0x0000b82c  mov      x29, x29
0x0000b830  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b834  mov      x25, x0
0x0000b838  mov      x0, x24
0x0000b83c  mov      x2, x25
0x0000b840  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000b844  mov      x0, x25
0x0000b848  bl       #0x55d78   ; CALL _objc_release
0x0000b84c  cbz      x23, #0xb860
0x0000b850  mov      x0, x22
0x0000b854  bl       #0x55d78   ; CALL _objc_release
0x0000b858  mov      x0, x21
0x0000b85c  bl       #0x55d78   ; CALL _objc_release
0x0000b860  mov      x0, x20
0x0000b864  bl       #0x55d78   ; CALL _objc_release
0x0000b868  mov      x0, x19
0x0000b86c  bl       #0x55d78   ; CALL _objc_release
0x0000b870  adrp     x8, #0x8e000
0x0000b874  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x0000b878  bl       #0x565c0   ; CALL objc_msgSend$array
0x0000b87c  mov      x29, x29
0x0000b880  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b884  mov      x25, x0
0x0000b888  adrp     x0, #0x75000
0x0000b88c  add      x0, x0, #0x5e8   ; STR "diagCar"
0x0000b890  bl       #0x7a70
0x0000b894  mov      x29, x29
0x0000b898  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b89c  mov      x21, x0
0x0000b8a0  adrp     x8, #0x8e000
0x0000b8a4  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x0000b8a8  bl       #0x55d48   ; CALL _objc_opt_class
0x0000b8ac  mov      x1, x0
0x0000b8b0  mov      x0, x21
0x0000b8b4  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0000b8b8  tbnz     w0, #0, #0xb8c8
0x0000b8bc  mov      x0, x21
0x0000b8c0  bl       #0x55d78   ; CALL _objc_release
0x0000b8c4  mov      x21, #0
0x0000b8c8  adrp     x0, #0x77000
0x0000b8cc  add      x0, x0, #0x748   ; STR "AVExternalDevice"
0x0000b8d0  bl       #0x55af0   ; CALL _NSClassFromString
0x0000b8d4  mov      x19, x0
0x0000b8d8  adrp     x0, #0x77000
0x0000b8dc  add      x0, x0, #0x768   ; STR "currentCarPlayExternalDevice"
0x0000b8e0  bl       #0x55b08   ; CALL _NSSelectorFromString
0x0000b8e4  mov      x20, x0
0x0000b8e8  mov      x0, x19
0x0000b8ec  mov      x1, x20
0x0000b8f0  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x0000b8f4  str      x25, [sp, #0x148]
0x0000b8f8  str      x21, [sp, #0x138]
0x0000b8fc  tbz      w0, #0, #0xb9b8
0x0000b900  mov      x0, x19
0x0000b904  mov      x1, x20
0x0000b908  bl       #0x55d30   ; CALL _objc_msgSend
0x0000b90c  mov      x29, x29
0x0000b910  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b914  mov      x19, x0
0x0000b918  bl       #0x55d78   ; CALL _objc_release
0x0000b91c  adrp     x1, #0x7f000
0x0000b920  add      x1, x1, #0x840
0x0000b924  mov      x0, x21
0x0000b928  bl       #0x9720
0x0000b92c  mov      x29, x29
0x0000b930  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b934  mov      x22, x0
0x0000b938  cbz      x19, #0xba04
0x0000b93c  str      x22, [sp, #0xc8]
0x0000b940  cbz      x21, #0xba3c
0x0000b944  ldr      x19, [x27, #0x958]   ; @CLASS NSString
0x0000b948  mov      x20, x22
0x0000b94c  cbnz     x22, #0xb968
0x0000b950  adrp     x0, #0x76000
0x0000b954  add      x0, x0, #0x4c8   ; STR "CHK_CAR_UNKNOWN"
0x0000b958  bl       #0x17e20   ; CALL _L
0x0000b95c  mov      x29, x29
0x0000b960  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b964  mov      x20, x0
0x0000b968  mov      x0, x21
0x0000b96c  bl       #0x99a4
0x0000b970  mov      x29, x29
0x0000b974  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b978  mov      x21, x0
0x0000b97c  stp      x20, x0, [sp]
0x0000b980  adrp     x2, #0x76000
0x0000b984  add      x2, x2, #0x4a8   ; STR "%@ · %@"
0x0000b988  mov      x0, x19
0x0000b98c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000b990  mov      x29, x29
0x0000b994  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b998  mov      x19, x0
0x0000b99c  bl       #0x55d84   ; CALL _objc_retain
0x0000b9a0  mov      x0, x19
0x0000b9a4  bl       #0x55d78   ; CALL _objc_release
0x0000b9a8  mov      x0, x21
0x0000b9ac  bl       #0x55d78   ; CALL _objc_release
0x0000b9b0  cbz      x22, #0xba5c
0x0000b9b4  b        #0xba64
0x0000b9b8  adrp     x2, #0x76000
0x0000b9bc  add      x2, x2, #0x488   ; STR "connected"
0x0000b9c0  mov      x0, x21
0x0000b9c4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000b9c8  mov      x29, x29
0x0000b9cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b9d0  mov      x19, x0
0x0000b9d4  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x0000b9d8  mov      x20, x0
0x0000b9dc  mov      x0, x19
0x0000b9e0  bl       #0x55d78   ; CALL _objc_release
0x0000b9e4  adrp     x1, #0x7f000
0x0000b9e8  add      x1, x1, #0x840
0x0000b9ec  mov      x0, x21
0x0000b9f0  bl       #0x9720
0x0000b9f4  mov      x29, x29
0x0000b9f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000b9fc  mov      x22, x0
0x0000ba00  cbnz     w20, #0xb93c
0x0000ba04  str      x22, [sp, #0xc8]
0x0000ba08  cbz      x21, #0xbab8
0x0000ba0c  adrp     x2, #0x76000
0x0000ba10  add      x2, x2, #0x528   ; STR "disconnected"
0x0000ba14  mov      x0, x21
0x0000ba18  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000ba1c  mov      x29, x29
0x0000ba20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ba24  mov      x20, x0
0x0000ba28  cbz      x0, #0xbb3c
0x0000ba2c  mov      x0, x20
0x0000ba30  bl       #0x55d84   ; CALL _objc_retain
0x0000ba34  mov      x19, x20
0x0000ba38  b        #0xbb64
0x0000ba3c  adrp     x0, #0x76000
0x0000ba40  add      x0, x0, #0x4e8   ; STR "CHK_CAR_CONNECTED"
0x0000ba44  bl       #0x17e20   ; CALL _L
0x0000ba48  mov      x29, x29
0x0000ba4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ba50  mov      x20, x0
0x0000ba54  bl       #0x55d84   ; CALL _objc_retain
0x0000ba58  mov      x19, x20
0x0000ba5c  mov      x0, x20
0x0000ba60  bl       #0x55d78   ; CALL _objc_release
0x0000ba64  adrp     x0, #0x76000
0x0000ba68  add      x0, x0, #0x508   ; STR "CHK_CAR"
0x0000ba6c  bl       #0x17e20   ; CALL _L
0x0000ba70  mov      x29, x29
0x0000ba74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ba78  mov      x20, x0
0x0000ba7c  adrp     x1, #0x75000
0x0000ba80  add      x1, x1, #0xe08   ; STR "ok"
0x0000ba84  mov      x2, x19
0x0000ba88  mov      x3, #0
0x0000ba8c  mov      x4, #0
0x0000ba90  bl       #0xf0f0
0x0000ba94  mov      x29, x29
0x0000ba98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ba9c  mov      x21, x0
0x0000baa0  mov      x0, x25
0x0000baa4  mov      x2, x21
0x0000baa8  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000baac  mov      w8, #1
0x0000bab0  str      w8, [sp, #0x50]
0x0000bab4  b        #0xbc28
0x0000bab8  adrp     x0, #0x76000
0x0000babc  add      x0, x0, #0x508   ; STR "CHK_CAR"
0x0000bac0  bl       #0x17e20   ; CALL _L
0x0000bac4  mov      x29, x29
0x0000bac8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bacc  mov      x19, x0
0x0000bad0  adrp     x0, #0x76000
0x0000bad4  add      x0, x0, #0x588   ; STR "CHK_CAR_NEVER"
0x0000bad8  bl       #0x17e20   ; CALL _L
0x0000badc  mov      x29, x29
0x0000bae0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bae4  mov      x20, x0
0x0000bae8  adrp     x0, #0x76000
0x0000baec  add      x0, x0, #0x5a8   ; STR "CHK_CAR_NEVER_FIX"
0x0000baf0  bl       #0x17e20   ; CALL _L
0x0000baf4  mov      x29, x29
0x0000baf8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bafc  mov      x21, x0
0x0000bb00  adrp     x1, #0x76000
0x0000bb04  add      x1, x1, #0x548   ; STR "info"
0x0000bb08  mov      x0, x19
0x0000bb0c  mov      x2, x20
0x0000bb10  mov      x3, x21
0x0000bb14  mov      x4, #0
0x0000bb18  bl       #0xf0f0
0x0000bb1c  mov      x29, x29
0x0000bb20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bb24  mov      x22, x0
0x0000bb28  mov      x0, x25
0x0000bb2c  mov      x2, x22
0x0000bb30  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000bb34  mov      x0, x22
0x0000bb38  b        #0xbc20
0x0000bb3c  adrp     x2, #0x75000
0x0000bb40  add      x2, x2, #0x968   ; STR "date"
0x0000bb44  mov      x0, x21
0x0000bb48  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000bb4c  mov      x29, x29
0x0000bb50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bb54  mov      x19, x0
0x0000bb58  bl       #0x55d84   ; CALL _objc_retain
0x0000bb5c  mov      x0, x19
0x0000bb60  bl       #0x55d78   ; CALL _objc_release
0x0000bb64  mov      x0, x20
0x0000bb68  bl       #0x55d78   ; CALL _objc_release
0x0000bb6c  adrp     x0, #0x76000
0x0000bb70  add      x0, x0, #0x508   ; STR "CHK_CAR"
0x0000bb74  bl       #0x17e20   ; CALL _L
0x0000bb78  mov      x29, x29
0x0000bb7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bb80  mov      x20, x0
0x0000bb84  ldr      x22, [x27, #0x958]   ; @CLASS NSString
0x0000bb88  adrp     x0, #0x76000
0x0000bb8c  add      x0, x0, #0x568   ; STR "CHK_CAR_LAST"
0x0000bb90  bl       #0x17e20   ; CALL _L
0x0000bb94  mov      x29, x29
0x0000bb98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bb9c  mov      x21, x0
0x0000bba0  mov      x0, x19
0x0000bba4  bl       #0xf6c0
0x0000bba8  mov      x29, x29
0x0000bbac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bbb0  mov      x23, x0
0x0000bbb4  str      x0, [sp]
0x0000bbb8  mov      x0, x22
0x0000bbbc  mov      x2, x21
0x0000bbc0  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000bbc4  mov      x29, x29
0x0000bbc8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bbcc  mov      x22, x0
0x0000bbd0  adrp     x1, #0x76000
0x0000bbd4  add      x1, x1, #0x548   ; STR "info"
0x0000bbd8  mov      x0, x20
0x0000bbdc  mov      x2, x22
0x0000bbe0  mov      x3, #0
0x0000bbe4  mov      x4, #0
0x0000bbe8  bl       #0xf0f0
0x0000bbec  mov      x29, x29
0x0000bbf0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bbf4  mov      x25, x0
0x0000bbf8  ldr      x24, [sp, #0x148]
0x0000bbfc  mov      x0, x24
0x0000bc00  mov      x2, x25
0x0000bc04  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000bc08  mov      x0, x25
0x0000bc0c  mov      x25, x24
0x0000bc10  bl       #0x55d78   ; CALL _objc_release
0x0000bc14  mov      x0, x22
0x0000bc18  bl       #0x55d78   ; CALL _objc_release
0x0000bc1c  mov      x0, x23
0x0000bc20  bl       #0x55d78   ; CALL _objc_release
0x0000bc24  str      wzr, [sp, #0x50]
0x0000bc28  mov      x0, x21
0x0000bc2c  bl       #0x55d78   ; CALL _objc_release
0x0000bc30  mov      x0, x20
0x0000bc34  bl       #0x55d78   ; CALL _objc_release
0x0000bc38  mov      x0, x19
0x0000bc3c  bl       #0x55d78   ; CALL _objc_release
0x0000bc40  adrp     x8, #0x8e000
0x0000bc44  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x0000bc48  bl       #0x565c0   ; CALL objc_msgSend$array
0x0000bc4c  mov      x29, x29
0x0000bc50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bc54  mov      x26, x0
0x0000bc58  movi     v0.16b, #0
0x0000bc5c  stp      q0, q0, [sp, #0x2c0]
0x0000bc60  stp      q0, q0, [sp, #0x2e0]
0x0000bc64  ldr      x19, [sp, #0x198]
0x0000bc68  mov      x0, x19
0x0000bc6c  bl       #0x55d84   ; CALL _objc_retain
0x0000bc70  add      x2, sp, #0x2c0
0x0000bc74  add      x3, sp, #0x6f0
0x0000bc78  mov      x0, x19
0x0000bc7c  mov      w4, #0x10
0x0000bc80  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000bc84  cbz      x0, #0xbd14
0x0000bc88  mov      x20, x0
0x0000bc8c  ldr      x8, [sp, #0x2d0]
0x0000bc90  ldr      x23, [x8]   ; @SEL "whatsNewNavigationController"
0x0000bc94  adrp     x19, #0x76000
0x0000bc98  add      x19, x19, #0x5c8   ; STR "CarPlay"
0x0000bc9c  mov      x24, #0
0x0000bca0  ldr      x8, [sp, #0x2d0]
0x0000bca4  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0000bca8  cmp      x8, x23
0x0000bcac  b.eq     #0xbcb8
0x0000bcb0  ldr      x0, [sp, #0x198]
0x0000bcb4  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0000bcb8  ldr      x8, [sp, #0x2c8]
0x0000bcbc  ldr      x21, [x8, x24, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0000bcc0  mov      x0, x21
0x0000bcc4  mov      x1, x19
0x0000bcc8  bl       #0xf76c
0x0000bccc  mov      x29, x29
0x0000bcd0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bcd4  mov      x22, x0
0x0000bcd8  bl       #0x55d78   ; CALL _objc_release
0x0000bcdc  cbz      x22, #0xbcec
0x0000bce0  mov      x0, x26
0x0000bce4  mov      x2, x21
0x0000bce8  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000bcec  add      x24, x24, #1
0x0000bcf0  cmp      x20, x24
0x0000bcf4  b.ne     #0xbca0
0x0000bcf8  add      x2, sp, #0x2c0
0x0000bcfc  add      x3, sp, #0x6f0
0x0000bd00  ldr      x0, [sp, #0x198]
0x0000bd04  mov      w4, #0x10
0x0000bd08  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000bd0c  mov      x20, x0
0x0000bd10  cbnz     x0, #0xbc9c
0x0000bd14  ldr      x0, [sp, #0x198]
0x0000bd18  bl       #0x55d78   ; CALL _objc_release
0x0000bd1c  mov      x0, x26
0x0000bd20  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000bd24  cbz      x0, #0xbd6c
0x0000bd28  str      xzr, [sp, #0x2b8]
0x0000bd2c  adrp     x1, #0x76000
0x0000bd30  add      x1, x1, #0x5c8   ; STR "CarPlay"
0x0000bd34  add      x2, sp, #0x2b8
0x0000bd38  mov      x0, x26
0x0000bd3c  bl       #0xf260
0x0000bd40  mov      x29, x29
0x0000bd44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bd48  mov      x22, x0
0x0000bd4c  ldr      x21, [sp, #0x2b8]
0x0000bd50  mov      x0, x21
0x0000bd54  bl       #0x55d84   ; CALL _objc_retain
0x0000bd58  mov      x0, x22
0x0000bd5c  bl       #0x55d84   ; CALL _objc_retain
0x0000bd60  mov      x0, x22
0x0000bd64  bl       #0x55d78   ; CALL _objc_release
0x0000bd68  b        #0xbd78
0x0000bd6c  mov      x21, #0
0x0000bd70  adrp     x22, #0x76000
0x0000bd74  add      x22, x22, #0x5e8   ; STR "none"
0x0000bd78  adrp     x2, #0x75000
0x0000bd7c  add      x2, x2, #0xe08   ; STR "ok"
0x0000bd80  mov      x0, x22
0x0000bd84  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0000bd88  stp      x22, x21, [sp, #0xb0]
0x0000bd8c  cbz      w0, #0xbe34
0x0000bd90  adrp     x0, #0x76000
0x0000bd94  add      x0, x0, #0x608   ; STR "CHK_CP_RUNNING"
0x0000bd98  bl       #0x17e20   ; CALL _L
0x0000bd9c  mov      x29, x29
0x0000bda0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bda4  mov      x19, x0
0x0000bda8  ldr      x22, [x27, #0x958]   ; @CLASS NSString
0x0000bdac  adrp     x0, #0x76000
0x0000bdb0  add      x0, x0, #0x168   ; STR "CHK_RUNNING_OK"
0x0000bdb4  bl       #0x17e20   ; CALL _L
0x0000bdb8  mov      x29, x29
0x0000bdbc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bdc0  mov      x20, x0
0x0000bdc4  mov      x0, x21
0x0000bdc8  bl       #0xf6c0
0x0000bdcc  mov      x29, x29
0x0000bdd0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bdd4  mov      x21, x0
0x0000bdd8  str      x0, [sp]
0x0000bddc  mov      x0, x22
0x0000bde0  mov      x2, x20
0x0000bde4  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000bde8  mov      x29, x29
0x0000bdec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bdf0  mov      x22, x0
0x0000bdf4  adrp     x1, #0x75000
0x0000bdf8  add      x1, x1, #0xe08   ; STR "ok"
0x0000bdfc  mov      x0, x19
0x0000be00  mov      x2, x22
0x0000be04  mov      x3, #0
0x0000be08  mov      x4, #0
0x0000be0c  bl       #0xf0f0
0x0000be10  mov      x29, x29
0x0000be14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000be18  mov      x23, x0
0x0000be1c  mov      x0, x25
0x0000be20  mov      x2, x23
0x0000be24  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000be28  mov      x0, x23
0x0000be2c  bl       #0x55d78   ; CALL _objc_release
0x0000be30  b        #0xbf04
0x0000be34  adrp     x2, #0x76000
0x0000be38  add      x2, x2, #0x188   ; STR "old"
0x0000be3c  mov      x0, x22
0x0000be40  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0000be44  mov      x20, x0
0x0000be48  adrp     x0, #0x76000
0x0000be4c  add      x0, x0, #0x608   ; STR "CHK_CP_RUNNING"
0x0000be50  bl       #0x17e20   ; CALL _L
0x0000be54  mov      x29, x29
0x0000be58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000be5c  mov      x19, x0
0x0000be60  cbz      w20, #0xbea0
0x0000be64  adrp     x0, #0x76000
0x0000be68  add      x0, x0, #0x1a8   ; STR "CHK_RUNNING_OLD"
0x0000be6c  bl       #0x17e20   ; CALL _L
0x0000be70  mov      x29, x29
0x0000be74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000be78  mov      x20, x0
0x0000be7c  adrp     x0, #0x76000
0x0000be80  add      x0, x0, #0x628   ; STR "CHK_CP_RECONNECT"
0x0000be84  bl       #0x17e20   ; CALL _L
0x0000be88  mov      x29, x29
0x0000be8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000be90  mov      x21, x0
0x0000be94  adrp     x1, #0x75000
0x0000be98  add      x1, x1, #0xe28   ; STR "warn"
0x0000be9c  b        #0xbed8
0x0000bea0  adrp     x0, #0x76000
0x0000bea4  add      x0, x0, #0x648   ; STR "CHK_CP_NONE"
0x0000bea8  bl       #0x17e20   ; CALL _L
0x0000beac  mov      x29, x29
0x0000beb0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000beb4  mov      x20, x0
0x0000beb8  adrp     x0, #0x76000
0x0000bebc  add      x0, x0, #0x5a8   ; STR "CHK_CAR_NEVER_FIX"
0x0000bec0  bl       #0x17e20   ; CALL _L
0x0000bec4  mov      x29, x29
0x0000bec8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000becc  mov      x21, x0
0x0000bed0  adrp     x1, #0x76000
0x0000bed4  add      x1, x1, #0x548   ; STR "info"
0x0000bed8  mov      x0, x19
0x0000bedc  mov      x2, x20
0x0000bee0  mov      x3, x21
0x0000bee4  mov      x4, #0
0x0000bee8  bl       #0xf0f0
0x0000beec  mov      x29, x29
0x0000bef0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bef4  mov      x22, x0
0x0000bef8  mov      x0, x25
0x0000befc  mov      x2, x22
0x0000bf00  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000bf04  mov      x0, x22
0x0000bf08  bl       #0x55d78   ; CALL _objc_release
0x0000bf0c  mov      x0, x21
0x0000bf10  bl       #0x55d78   ; CALL _objc_release
0x0000bf14  mov      x0, x20
0x0000bf18  bl       #0x55d78   ; CALL _objc_release
0x0000bf1c  mov      x0, x19
0x0000bf20  bl       #0x55d78   ; CALL _objc_release
0x0000bf24  bl       #0x687c
0x0000bf28  mov      x29, x29
0x0000bf2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bf30  str      x0, [sp, #0x158]
0x0000bf34  bl       #0x9f18
0x0000bf38  mov      x29, x29
0x0000bf3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bf40  mov      x19, x0
0x0000bf44  adrp     x8, #0x8e000
0x0000bf48  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x0000bf4c  bl       #0x565c0   ; CALL objc_msgSend$array
0x0000bf50  mov      x29, x29
0x0000bf54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000bf58  str      x0, [sp, #0x160]
0x0000bf5c  movi     v0.16b, #0
0x0000bf60  stp      q0, q0, [sp, #0x270]
0x0000bf64  stp      q0, q0, [sp, #0x290]
0x0000bf68  mov      x0, x19
0x0000bf6c  bl       #0x55d84   ; CALL _objc_retain
0x0000bf70  add      x2, sp, #0x270
0x0000bf74  add      x3, sp, #0x670
0x0000bf78  mov      x0, x19
0x0000bf7c  mov      w4, #0x10
0x0000bf80  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000bf84  str      x28, [sp, #0xd0]
0x0000bf88  str      x26, [sp, #0xc0]
0x0000bf8c  str      x19, [sp, #0x178]
0x0000bf90  str      x0, [sp, #0x190]
0x0000bf94  cbz      x0, #0xc30c
0x0000bf98  mov      x25, #0
0x0000bf9c  ldr      x8, [sp, #0x280]
0x0000bfa0  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0000bfa4  str      x8, [sp, #0x170]
0x0000bfa8  adrp     x27, #0x75000
0x0000bfac  add      x27, x27, #0xaa8   ; STR "total"
0x0000bfb0  adrp     x22, #0x75000
0x0000bfb4  add      x22, x22, #0xa88   ; STR "missing"
0x0000bfb8  mov      x20, #0
0x0000bfbc  ldr      x8, [sp, #0x280]
0x0000bfc0  ldr      x8, [x8]   ; @CSTR "whatsNewNavigationController"
0x0000bfc4  ldr      x9, [sp, #0x170]
0x0000bfc8  cmp      x8, x9
0x0000bfcc  b.eq     #0xbfd8
0x0000bfd0  mov      x0, x19
0x0000bfd4  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0000bfd8  ldr      x8, [sp, #0x278]
0x0000bfdc  ldr      x2, [x8, x20, lsl #3]
0x0000bfe0  movi     v0.16b, #0
0x0000bfe4  stp      q0, q0, [sp, #0x230]
0x0000bfe8  stp      q0, q0, [sp, #0x250]
0x0000bfec  mov      x0, x19
0x0000bff0  stp      x2, x20, [sp, #0x1a0]
0x0000bff4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000bff8  mov      x29, x29
0x0000bffc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c000  mov      x21, x0
0x0000c004  add      x2, sp, #0x230
0x0000c008  add      x3, sp, #0x5f0
0x0000c00c  mov      w4, #0x10
0x0000c010  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000c014  cbz      x0, #0xc0c8
0x0000c018  mov      x26, x0
0x0000c01c  mov      x19, #0
0x0000c020  ldr      x8, [sp, #0x240]
0x0000c024  ldr      x20, [x8]
0x0000c028  mov      x23, #0
0x0000c02c  ldr      x8, [sp, #0x240]
0x0000c030  ldr      x8, [x8]
0x0000c034  cmp      x8, x20
0x0000c038  b.eq     #0xc044
0x0000c03c  mov      x0, x21
0x0000c040  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0000c044  ldr      x8, [sp, #0x238]
0x0000c048  ldr      x28, [x8, x23, lsl #3]
0x0000c04c  mov      x0, x28
0x0000c050  mov      x2, x27
0x0000c054  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000c058  mov      x29, x29
0x0000c05c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c060  mov      x24, x0
0x0000c064  bl       #0x5dcc0   ; CALL objc_msgSend$unsignedIntegerValue
0x0000c068  add      x25, x0, x25
0x0000c06c  mov      x0, x24
0x0000c070  bl       #0x55d78   ; CALL _objc_release
0x0000c074  mov      x0, x28
0x0000c078  mov      x2, x22
0x0000c07c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000c080  mov      x29, x29
0x0000c084  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c088  mov      x24, x0
0x0000c08c  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000c090  add      x19, x0, x19
0x0000c094  mov      x0, x24
0x0000c098  bl       #0x55d78   ; CALL _objc_release
0x0000c09c  add      x23, x23, #1   ; CSTR "hatsNewNavigationController"
0x0000c0a0  cmp      x26, x23
0x0000c0a4  b.ne     #0xc02c
0x0000c0a8  add      x2, sp, #0x230
0x0000c0ac  add      x3, sp, #0x5f0
0x0000c0b0  mov      x0, x21
0x0000c0b4  mov      w4, #0x10
0x0000c0b8  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000c0bc  mov      x26, x0
0x0000c0c0  cbnz     x0, #0xc028
0x0000c0c4  b        #0xc0cc
0x0000c0c8  mov      x19, #0
0x0000c0cc  mov      x0, x21
0x0000c0d0  bl       #0x55d78   ; CALL _objc_release
0x0000c0d4  ldr      x20, [sp, #0x1a0]
0x0000c0d8  mov      x0, x20
0x0000c0dc  mov      w2, #1
0x0000c0e0  bl       #0x5d6e0   ; CALL objc_msgSend$substringToIndex:
0x0000c0e4  mov      x29, x29
0x0000c0e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c0ec  mov      x24, x0
0x0000c0f0  bl       #0x58ec0   ; CALL objc_msgSend$lowercaseString
0x0000c0f4  mov      x29, x29
0x0000c0f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c0fc  mov      x26, x0
0x0000c100  mov      x0, x20
0x0000c104  mov      w2, #1
0x0000c108  bl       #0x5d6c0   ; CALL objc_msgSend$substringFromIndex:
0x0000c10c  mov      x29, x29
0x0000c110  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c114  mov      x28, x0
0x0000c118  mov      x0, x26
0x0000c11c  mov      x2, x28
0x0000c120  bl       #0x5d440   ; CALL objc_msgSend$stringByAppendingString:
0x0000c124  mov      x29, x29
0x0000c128  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c12c  mov      x21, x0
0x0000c130  mov      x0, x28
0x0000c134  bl       #0x55d78   ; CALL _objc_release
0x0000c138  mov      x0, x26
0x0000c13c  bl       #0x55d78   ; CALL _objc_release
0x0000c140  mov      x0, x24
0x0000c144  bl       #0x55d78   ; CALL _objc_release
0x0000c148  cbz      x19, #0xc1b0
0x0000c14c  adrp     x8, #0x8e000
0x0000c150  ldr      x24, [x8, #0x958]   ; @CLASS NSString
0x0000c154  ldr      x0, [sp, #0x158]
0x0000c158  mov      x2, x21
0x0000c15c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000c160  mov      x29, x29
0x0000c164  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c168  mov      x26, x0
0x0000c16c  cmp      x0, #0
0x0000c170  csel     x8, x20, x0, eq
0x0000c174  stp      x8, x19, [sp]
0x0000c178  mov      x0, x24
0x0000c17c  adrp     x2, #0x76000
0x0000c180  add      x2, x2, #0x668   ; STR "%@ (%lu)"
0x0000c184  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000c188  mov      x29, x29
0x0000c18c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c190  mov      x20, x0
0x0000c194  ldr      x0, [sp, #0x160]
0x0000c198  mov      x2, x20
0x0000c19c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000c1a0  mov      x0, x20
0x0000c1a4  bl       #0x55d78   ; CALL _objc_release
0x0000c1a8  mov      x0, x26
0x0000c1ac  bl       #0x55d78   ; CALL _objc_release
0x0000c1b0  mov      x0, x21
0x0000c1b4  bl       #0x55d78   ; CALL _objc_release
0x0000c1b8  ldr      x20, [sp, #0x1a8]
0x0000c1bc  add      x20, x20, #1
0x0000c1c0  ldr      x8, [sp, #0x190]
0x0000c1c4  cmp      x20, x8
0x0000c1c8  ldr      x19, [sp, #0x178]
0x0000c1cc  b.ne     #0xbfbc
0x0000c1d0  add      x2, sp, #0x270
0x0000c1d4  add      x3, sp, #0x670
0x0000c1d8  mov      x0, x19
0x0000c1dc  mov      w4, #0x10
0x0000c1e0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000c1e4  str      x0, [sp, #0x190]
0x0000c1e8  cbnz     x0, #0xbfb8
0x0000c1ec  mov      x0, x19
0x0000c1f0  bl       #0x55d78   ; CALL _objc_release
0x0000c1f4  adrp     x27, #0x8e000
0x0000c1f8  cbz      x25, #0xc314
0x0000c1fc  ldr      x21, [sp, #0x160]
0x0000c200  mov      x0, x21
0x0000c204  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000c208  mov      x20, x0
0x0000c20c  adrp     x0, #0x76000
0x0000c210  add      x0, x0, #0x688   ; STR "CHK_HOOKS"
0x0000c214  bl       #0x17e20   ; CALL _L
0x0000c218  mov      x29, x29
0x0000c21c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c220  mov      x19, x0
0x0000c224  ldr      x22, [x27, #0x958]   ; @CLASS NSString
0x0000c228  cbz      x20, #0xcaec
0x0000c22c  adrp     x0, #0x76000
0x0000c230  add      x0, x0, #0x6a8   ; STR "CHK_HOOKS_MISSING"
0x0000c234  bl       #0x17e20   ; CALL _L
0x0000c238  mov      x29, x29
0x0000c23c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c240  mov      x20, x0
0x0000c244  adrp     x2, #0x75000
0x0000c248  add      x2, x2, #0xb28   ; STR ", "
0x0000c24c  mov      x0, x21
0x0000c250  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x0000c254  mov      x29, x29
0x0000c258  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c25c  mov      x21, x0
0x0000c260  str      x0, [sp]
0x0000c264  mov      x0, x22
0x0000c268  mov      x2, x20
0x0000c26c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000c270  mov      x29, x29
0x0000c274  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c278  mov      x22, x0
0x0000c27c  ldr      x23, [x27, #0x958]   ; @CLASS NSString
0x0000c280  adrp     x0, #0x76000
0x0000c284  add      x0, x0, #0x6c8   ; STR "CHK_HOOKS_MISSING_FIX"
0x0000c288  bl       #0x17e20   ; CALL _L
0x0000c28c  mov      x29, x29
0x0000c290  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c294  mov      x24, x0
0x0000c298  ldr      x8, [sp, #0x140]
0x0000c29c  str      x8, [sp]
0x0000c2a0  mov      x0, x23
0x0000c2a4  mov      x2, x24
0x0000c2a8  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000c2ac  mov      x29, x29
0x0000c2b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c2b4  mov      x23, x0
0x0000c2b8  adrp     x1, #0x75000
0x0000c2bc  add      x1, x1, #0xe28   ; STR "warn"
0x0000c2c0  mov      x0, x19
0x0000c2c4  mov      x2, x22
0x0000c2c8  mov      x3, x23
0x0000c2cc  mov      x4, #0
0x0000c2d0  bl       #0xf0f0
0x0000c2d4  mov      x29, x29
0x0000c2d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c2dc  mov      x26, x0
0x0000c2e0  ldr      x25, [sp, #0x148]
0x0000c2e4  mov      x0, x25
0x0000c2e8  mov      x2, x26
0x0000c2ec  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000c2f0  mov      x0, x26
0x0000c2f4  bl       #0x55d78   ; CALL _objc_release
0x0000c2f8  mov      x0, x23
0x0000c2fc  bl       #0x55d78   ; CALL _objc_release
0x0000c300  mov      x0, x24
0x0000c304  bl       #0x55d78   ; CALL _objc_release
0x0000c308  b        #0xc394
0x0000c30c  mov      x0, x19
0x0000c310  bl       #0x55d78   ; CALL _objc_release
0x0000c314  adrp     x0, #0x76000
0x0000c318  add      x0, x0, #0x688   ; STR "CHK_HOOKS"
0x0000c31c  bl       #0x17e20   ; CALL _L
0x0000c320  mov      x29, x29
0x0000c324  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c328  mov      x19, x0
0x0000c32c  adrp     x0, #0x76000
0x0000c330  add      x0, x0, #0x648   ; STR "CHK_CP_NONE"
0x0000c334  bl       #0x17e20   ; CALL _L
0x0000c338  mov      x29, x29
0x0000c33c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c340  mov      x20, x0
0x0000c344  adrp     x0, #0x76000
0x0000c348  add      x0, x0, #0x5a8   ; STR "CHK_CAR_NEVER_FIX"
0x0000c34c  bl       #0x17e20   ; CALL _L
0x0000c350  mov      x29, x29
0x0000c354  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c358  mov      x21, x0
0x0000c35c  adrp     x1, #0x76000
0x0000c360  add      x1, x1, #0x548   ; STR "info"
0x0000c364  mov      x0, x19
0x0000c368  mov      x2, x20
0x0000c36c  mov      x3, x21
0x0000c370  mov      x4, #0
0x0000c374  bl       #0xf0f0
0x0000c378  mov      x29, x29
0x0000c37c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c380  mov      x22, x0
0x0000c384  ldr      x25, [sp, #0x148]
0x0000c388  mov      x0, x25
0x0000c38c  mov      x2, x22
0x0000c390  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000c394  mov      x0, x22
0x0000c398  bl       #0x55d78   ; CALL _objc_release
0x0000c39c  mov      x0, x21
0x0000c3a0  bl       #0x55d78   ; CALL _objc_release
0x0000c3a4  mov      x0, x20
0x0000c3a8  bl       #0x55d78   ; CALL _objc_release
0x0000c3ac  mov      x0, x19
0x0000c3b0  bl       #0x55d78   ; CALL _objc_release
0x0000c3b4  adrp     x0, #0x76000
0x0000c3b8  add      x0, x0, #0x708   ; STR "diagLastCrash"
0x0000c3bc  bl       #0x7a70
0x0000c3c0  mov      x29, x29
0x0000c3c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c3c8  mov      x26, x0
0x0000c3cc  adrp     x8, #0x8e000
0x0000c3d0  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x0000c3d4  bl       #0x55d48   ; CALL _objc_opt_class
0x0000c3d8  mov      x1, x0
0x0000c3dc  mov      x0, x26
0x0000c3e0  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0000c3e4  str      x26, [sp, #0xa8]
0x0000c3e8  tbz      w0, #0, #0xc4dc
0x0000c3ec  adrp     x2, #0x75000
0x0000c3f0  add      x2, x2, #0x968   ; STR "date"
0x0000c3f4  mov      x0, x26
0x0000c3f8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000c3fc  mov      x29, x29
0x0000c400  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c404  mov      x19, x0
0x0000c408  adrp     x8, #0x8e000
0x0000c40c  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x0000c410  bl       #0x55d48   ; CALL _objc_opt_class
0x0000c414  mov      x1, x0
0x0000c418  mov      x0, x19
0x0000c41c  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0000c420  mov      x20, x0
0x0000c424  mov      x0, x19
0x0000c428  bl       #0x55d78   ; CALL _objc_release
0x0000c42c  tbz      w20, #0, #0xc4dc
0x0000c430  adrp     x2, #0x76000
0x0000c434  add      x2, x2, #0x728   ; STR "suspect"
0x0000c438  mov      x0, x26
0x0000c43c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000c440  mov      x29, x29
0x0000c444  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c448  mov      x20, x0
0x0000c44c  cbz      x0, #0xcb9c
0x0000c450  ldr      x19, [x27, #0x958]   ; @CLASS NSString
0x0000c454  adrp     x0, #0x76000
0x0000c458  add      x0, x0, #0x748   ; STR "CHK_CRASH_SUSPECT"
0x0000c45c  bl       #0x17e20   ; CALL _L
0x0000c460  mov      x29, x29
0x0000c464  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c468  mov      x21, x0
0x0000c46c  adrp     x2, #0x76000
0x0000c470  add      x2, x2, #0x728   ; STR "suspect"
0x0000c474  mov      x0, x26
0x0000c478  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000c47c  mov      x29, x29
0x0000c480  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c484  mov      x22, x0
0x0000c488  bl       #0x6804   ; CALL _OMCFeatureDisplayName
0x0000c48c  mov      x29, x29
0x0000c490  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c494  mov      x23, x0
0x0000c498  str      x0, [sp]
0x0000c49c  mov      x0, x19
0x0000c4a0  mov      x2, x21
0x0000c4a4  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000c4a8  mov      x29, x29
0x0000c4ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c4b0  mov      x19, x0
0x0000c4b4  bl       #0x55d84   ; CALL _objc_retain
0x0000c4b8  mov      x0, x19
0x0000c4bc  bl       #0x55d78   ; CALL _objc_release
0x0000c4c0  mov      x0, x23
0x0000c4c4  bl       #0x55d78   ; CALL _objc_release
0x0000c4c8  mov      x0, x22
0x0000c4cc  bl       #0x55d78   ; CALL _objc_release
0x0000c4d0  mov      x0, x21
0x0000c4d4  bl       #0x55d78   ; CALL _objc_release
0x0000c4d8  b        #0xcba4
0x0000c4dc  adrp     x0, #0x76000
0x0000c4e0  add      x0, x0, #0x788   ; STR "CHK_CRASH"
0x0000c4e4  bl       #0x17e20   ; CALL _L
0x0000c4e8  mov      x29, x29
0x0000c4ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c4f0  mov      x19, x0
0x0000c4f4  adrp     x0, #0x76000
0x0000c4f8  add      x0, x0, #0x7c8   ; STR "CHK_CRASH_NONE"
0x0000c4fc  bl       #0x17e20   ; CALL _L
0x0000c500  mov      x29, x29
0x0000c504  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c508  mov      x20, x0
0x0000c50c  adrp     x1, #0x75000
0x0000c510  add      x1, x1, #0xe08   ; STR "ok"
0x0000c514  mov      x0, x19
0x0000c518  mov      x2, x20
0x0000c51c  mov      x3, #0
0x0000c520  mov      x4, #0
0x0000c524  bl       #0xf0f0
0x0000c528  mov      x29, x29
0x0000c52c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c530  mov      x21, x0
0x0000c534  mov      x0, x25
0x0000c538  mov      x2, x21
0x0000c53c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000c540  mov      x0, x21
0x0000c544  bl       #0x55d78   ; CALL _objc_release
0x0000c548  mov      x0, x20
0x0000c54c  bl       #0x55d78   ; CALL _objc_release
0x0000c550  mov      x0, x19
0x0000c554  bl       #0x55d78   ; CALL _objc_release
0x0000c558  bl       #0x78e8   ; CALL _OMCRescueFeatures
0x0000c55c  mov      x29, x29
0x0000c560  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c564  mov      x24, x0
0x0000c568  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000c56c  str      x24, [sp, #0xa0]
0x0000c570  cbz      x0, #0xc730
0x0000c574  adrp     x8, #0x8e000
0x0000c578  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x0000c57c  bl       #0x565c0   ; CALL objc_msgSend$array
0x0000c580  mov      x29, x29
0x0000c584  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c588  mov      x19, x0
0x0000c58c  movi     v0.16b, #0
0x0000c590  stp      q0, q0, [sp, #0x1f0]
0x0000c594  stp      q0, q0, [sp, #0x210]
0x0000c598  mov      x0, x24
0x0000c59c  bl       #0x55d84   ; CALL _objc_retain
0x0000c5a0  add      x2, sp, #0x1f0
0x0000c5a4  add      x3, sp, #0x570
0x0000c5a8  mov      x0, x24
0x0000c5ac  mov      w4, #0x10
0x0000c5b0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000c5b4  cbz      x0, #0xc634
0x0000c5b8  mov      x20, x0
0x0000c5bc  ldr      x8, [sp, #0x200]
0x0000c5c0  ldr      x22, [x8]   ; @SEL "whatsNewNavigationController"
0x0000c5c4  mov      x23, #0
0x0000c5c8  ldr      x8, [sp, #0x200]
0x0000c5cc  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0000c5d0  cmp      x8, x22
0x0000c5d4  b.eq     #0xc5e0
0x0000c5d8  mov      x0, x24
0x0000c5dc  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0000c5e0  ldr      x8, [sp, #0x1f8]
0x0000c5e4  ldr      x0, [x8, x23, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0000c5e8  bl       #0x6804   ; CALL _OMCFeatureDisplayName
0x0000c5ec  mov      x29, x29
0x0000c5f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c5f4  mov      x21, x0
0x0000c5f8  mov      x0, x19
0x0000c5fc  mov      x2, x21
0x0000c600  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000c604  mov      x0, x21
0x0000c608  bl       #0x55d78   ; CALL _objc_release
0x0000c60c  add      x23, x23, #1   ; CSTR "atsNewNavigationController"
0x0000c610  cmp      x20, x23
0x0000c614  b.ne     #0xc5c8
0x0000c618  add      x2, sp, #0x1f0
0x0000c61c  add      x3, sp, #0x570
0x0000c620  mov      x0, x24
0x0000c624  mov      w4, #0x10
0x0000c628  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000c62c  mov      x20, x0
0x0000c630  cbnz     x0, #0xc5c4
0x0000c634  mov      x0, x24
0x0000c638  bl       #0x55d78   ; CALL _objc_release
0x0000c63c  adrp     x0, #0x75000
0x0000c640  add      x0, x0, #0xc88   ; STR "RESCUE_GROUP"
0x0000c644  bl       #0x17e20   ; CALL _L
0x0000c648  mov      x29, x29
0x0000c64c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c650  mov      x20, x0
0x0000c654  ldr      x21, [x27, #0x958]   ; @CLASS NSString
0x0000c658  adrp     x0, #0x76000
0x0000c65c  add      x0, x0, #0x7e8   ; STR "CHK_RESCUE_ON"
0x0000c660  bl       #0x17e20   ; CALL _L
0x0000c664  mov      x29, x29
0x0000c668  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c66c  mov      x22, x0
0x0000c670  adrp     x2, #0x75000
0x0000c674  add      x2, x2, #0xb28   ; STR ", "
0x0000c678  mov      x0, x19
0x0000c67c  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x0000c680  mov      x29, x29
0x0000c684  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c688  mov      x23, x0
0x0000c68c  str      x0, [sp]
0x0000c690  mov      x0, x21
0x0000c694  mov      x2, x22
0x0000c698  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000c69c  mov      x29, x29
0x0000c6a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c6a4  mov      x21, x0
0x0000c6a8  adrp     x0, #0x76000
0x0000c6ac  add      x0, x0, #0x808   ; STR "CHK_RESCUE_FIX"
0x0000c6b0  bl       #0x17e20   ; CALL _L
0x0000c6b4  mov      x29, x29
0x0000c6b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c6bc  mov      x24, x0
0x0000c6c0  adrp     x1, #0x75000
0x0000c6c4  add      x1, x1, #0xdc8   ; STR "bad"
0x0000c6c8  adrp     x4, #0x76000
0x0000c6cc  add      x4, x4, #0x828   ; STR "rescue"
0x0000c6d0  mov      x0, x20
0x0000c6d4  mov      x2, x21
0x0000c6d8  mov      x3, x24
0x0000c6dc  bl       #0xf0f0
0x0000c6e0  mov      x29, x29
0x0000c6e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c6e8  mov      x26, x0
0x0000c6ec  mov      x0, x25
0x0000c6f0  mov      x2, x26
0x0000c6f4  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000c6f8  mov      x0, x26
0x0000c6fc  bl       #0x55d78   ; CALL _objc_release
0x0000c700  mov      x0, x24
0x0000c704  bl       #0x55d78   ; CALL _objc_release
0x0000c708  mov      x0, x21
0x0000c70c  bl       #0x55d78   ; CALL _objc_release
0x0000c710  mov      x0, x23
0x0000c714  bl       #0x55d78   ; CALL _objc_release
0x0000c718  mov      x0, x22
0x0000c71c  bl       #0x55d78   ; CALL _objc_release
0x0000c720  mov      x0, x20
0x0000c724  bl       #0x55d78   ; CALL _objc_release
0x0000c728  mov      x0, x19
0x0000c72c  bl       #0x55d78   ; CALL _objc_release
0x0000c730  adrp     x2, #0x75000
0x0000c734  add      x2, x2, #0x608   ; STR "pixels"
0x0000c738  ldr      x21, [sp, #0x138]
0x0000c73c  mov      x0, x21
0x0000c740  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000c744  mov      x29, x29
0x0000c748  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c74c  mov      x19, x0
0x0000c750  bl       #0x55d78   ; CALL _objc_release
0x0000c754  cbz      x19, #0xc960
0x0000c758  adrp     x19, #0x75000
0x0000c75c  add      x19, x19, #0x608   ; STR "pixels"
0x0000c760  mov      x0, x21
0x0000c764  mov      x2, x19
0x0000c768  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000c76c  mov      x29, x29
0x0000c770  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c774  mov      x20, x0
0x0000c778  bl       #0x9664
0x0000c77c  mov      v8.16b, v0.16b
0x0000c780  mov      v9.16b, v1.16b
0x0000c784  mov      x0, x20
0x0000c788  bl       #0x55d78   ; CALL _objc_release
0x0000c78c  ldr      x20, [x27, #0x958]   ; @CLASS NSString
0x0000c790  mov      x0, x21
0x0000c794  mov      x2, x19
0x0000c798  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000c79c  mov      x29, x29
0x0000c7a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c7a4  mov      x19, x21
0x0000c7a8  mov      x21, x0
0x0000c7ac  adrp     x2, #0x77000
0x0000c7b0  add      x2, x2, #0x348   ; STR "x"
0x0000c7b4  adrp     x3, #0x77000
0x0000c7b8  add      x3, x3, #0x528   ; STR "×"
0x0000c7bc  bl       #0x5d4a0   ; CALL objc_msgSend$stringByReplacingOccurrencesOfString:withString:
0x0000c7c0  mov      x29, x29
0x0000c7c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c7c8  mov      x22, x0
0x0000c7cc  mov      v0.16b, v8.16b
0x0000c7d0  mov      v1.16b, v9.16b
0x0000c7d4  bl       #0x9da8
0x0000c7d8  mov      x29, x29
0x0000c7dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c7e0  mov      x23, x0
0x0000c7e4  adrp     x2, #0x75000
0x0000c7e8  add      x2, x2, #0x908   ; STR "maxFPS"
0x0000c7ec  mov      x0, x19
0x0000c7f0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000c7f4  mov      x29, x29
0x0000c7f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c7fc  mov      x24, x0
0x0000c800  cmp      x0, #0
0x0000c804  adrp     x26, #0x75000
0x0000c808  add      x26, x26, #0x868   ; STR "?"
0x0000c80c  csel     x8, x26, x0, eq
0x0000c810  stp      x23, x8, [sp, #8]
0x0000c814  str      x22, [sp]
0x0000c818  adrp     x2, #0x76000
0x0000c81c  add      x2, x2, #0x848   ; STR "%@ · %@ · %@ FPS"
0x0000c820  mov      x0, x20
0x0000c824  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000c828  mov      x29, x29
0x0000c82c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c830  mov      x19, x0
0x0000c834  mov      x0, x24
0x0000c838  bl       #0x55d78   ; CALL _objc_release
0x0000c83c  mov      x0, x23
0x0000c840  bl       #0x55d78   ; CALL _objc_release
0x0000c844  mov      x0, x22
0x0000c848  bl       #0x55d78   ; CALL _objc_release
0x0000c84c  mov      x0, x21
0x0000c850  bl       #0x55d78   ; CALL _objc_release
0x0000c854  adrp     x0, #0x75000
0x0000c858  add      x0, x0, #0x748   ; STR "DIAG_CAR"
0x0000c85c  bl       #0x17e20   ; CALL _L
0x0000c860  mov      x29, x29
0x0000c864  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c868  mov      x20, x0
0x0000c86c  ldr      x23, [x27, #0x958]   ; @CLASS NSString
0x0000c870  adrp     x0, #0x76000
0x0000c874  add      x0, x0, #0x868   ; STR "CHK_SCREEN_VIDEO"
0x0000c878  bl       #0x17e20   ; CALL _L
0x0000c87c  mov      x29, x29
0x0000c880  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c884  mov      x21, x0
0x0000c888  fcmp     d8, d9
0x0000c88c  fcsel    d0, d9, d8, mi
0x0000c890  fcmp     d0, #0.0
0x0000c894  mov      x22, x26
0x0000c898  b.ls     #0xc8d8
0x0000c89c  adrp     x8, #0x65000
0x0000c8a0  ldr      d1, [x8, #0x618]
0x0000c8a4  fcmp     d0, d1
0x0000c8a8  b.ls     #0xc8d0
0x0000c8ac  adrp     x8, #0x77000
0x0000c8b0  add      x8, x8, #0x5a8   ; STR "720p (1280×720)"
0x0000c8b4  adrp     x9, #0x77000
0x0000c8b8  add      x9, x9, #0x5c8   ; STR "1080p (1920×1080)"
0x0000c8bc  mov      x10, #0x4094000000000000
0x0000c8c0  fmov     d1, x10
0x0000c8c4  fcmp     d0, d1
0x0000c8c8  csel     x22, x9, x8, hi
0x0000c8cc  b        #0xc8d8
0x0000c8d0  adrp     x22, #0x77000
0x0000c8d4  add      x22, x22, #0x588   ; STR "480p (854×480)"
0x0000c8d8  mov      x0, x22
0x0000c8dc  bl       #0x55d84   ; CALL _objc_retain
0x0000c8e0  str      x22, [sp]
0x0000c8e4  mov      x0, x23
0x0000c8e8  mov      x2, x21
0x0000c8ec  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000c8f0  mov      x29, x29
0x0000c8f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c8f8  mov      x23, x0
0x0000c8fc  adrp     x1, #0x76000
0x0000c900  add      x1, x1, #0x548   ; STR "info"
0x0000c904  mov      x0, x20
0x0000c908  mov      x2, x19
0x0000c90c  mov      x3, x23
0x0000c910  mov      x4, #0
0x0000c914  bl       #0xf0f0
0x0000c918  mov      x29, x29
0x0000c91c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c920  mov      x24, x0
0x0000c924  mov      x0, x25
0x0000c928  mov      x2, x24
0x0000c92c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000c930  mov      x0, x24
0x0000c934  bl       #0x55d78   ; CALL _objc_release
0x0000c938  mov      x0, x23
0x0000c93c  bl       #0x55d78   ; CALL _objc_release
0x0000c940  mov      x0, x22
0x0000c944  bl       #0x55d78   ; CALL _objc_release
0x0000c948  mov      x0, x21
0x0000c94c  bl       #0x55d78   ; CALL _objc_release
0x0000c950  mov      x0, x20
0x0000c954  bl       #0x55d78   ; CALL _objc_release
0x0000c958  mov      x0, x19
0x0000c95c  bl       #0x55d78   ; CALL _objc_release
0x0000c960  adrp     x8, #0x8e000
0x0000c964  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x0000c968  bl       #0x565c0   ; CALL objc_msgSend$array
0x0000c96c  mov      x29, x29
0x0000c970  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c974  mov      x26, x0
0x0000c978  bl       #0x18c50   ; CALL _OMCEnabled
0x0000c97c  mov      x28, x0
0x0000c980  adrp     x0, #0x76000
0x0000c984  add      x0, x0, #0x888   ; STR "splitScreen"
0x0000c988  bl       #0x6804   ; CALL _OMCFeatureDisplayName
0x0000c98c  mov      x29, x29
0x0000c990  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c994  mov      x23, x0
0x0000c998  adrp     x0, #0x76000
0x0000c99c  add      x0, x0, #0x8a8   ; STR "splitScreenCarPlayApps"
0x0000c9a0  bl       #0x7a70
0x0000c9a4  mov      x29, x29
0x0000c9a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000c9ac  mov      x19, x0
0x0000c9b0  adrp     x22, #0x8e000
0x0000c9b4  ldr      x0, [x22, #0x960]   ; @CLASS NSArray
0x0000c9b8  bl       #0x55d48   ; CALL _objc_opt_class
0x0000c9bc  mov      x1, x0
0x0000c9c0  mov      x0, x19
0x0000c9c4  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0000c9c8  tbz      w0, #0, #0xc9dc
0x0000c9cc  mov      x0, x19
0x0000c9d0  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000c9d4  mov      x21, x0
0x0000c9d8  b        #0xc9e0
0x0000c9dc  mov      x21, #0
0x0000c9e0  str      x19, [sp, #0x90]
0x0000c9e4  cbz      w28, #0xca9c
0x0000c9e8  adrp     x0, #0x76000
0x0000c9ec  add      x0, x0, #0x888   ; STR "splitScreen"
0x0000c9f0  bl       #0x7a8c
0x0000c9f4  tbz      w0, #0, #0xca9c
0x0000c9f8  cbz      x19, #0xccfc
0x0000c9fc  ldr      x20, [x27, #0x958]   ; @CLASS NSString
0x0000ca00  adrp     x0, #0x76000
0x0000ca04  add      x0, x0, #0x8c8   ; STR "CHK_SPLIT_APPS"
0x0000ca08  bl       #0x17e20   ; CALL _L
0x0000ca0c  mov      x29, x29
0x0000ca10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ca14  mov      x19, x0
0x0000ca18  str      x21, [sp]
0x0000ca1c  mov      x0, x20
0x0000ca20  mov      x2, x19
0x0000ca24  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000ca28  mov      x29, x29
0x0000ca2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ca30  mov      x20, x0
0x0000ca34  cmp      x21, #1
0x0000ca38  b.hi     #0xcd44
0x0000ca3c  adrp     x0, #0x76000
0x0000ca40  add      x0, x0, #0x8e8   ; STR "CHK_SPLIT_FEW"
0x0000ca44  bl       #0x17e20   ; CALL _L
0x0000ca48  mov      x29, x29
0x0000ca4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ca50  mov      x21, x0
0x0000ca54  adrp     x1, #0x75000
0x0000ca58  add      x1, x1, #0xe28   ; STR "warn"
0x0000ca5c  mov      x0, x23
0x0000ca60  mov      x2, x20
0x0000ca64  mov      x3, x21
0x0000ca68  mov      x4, #0
0x0000ca6c  bl       #0xf0f0
0x0000ca70  mov      x29, x29
0x0000ca74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ca78  mov      x24, x22
0x0000ca7c  mov      x22, x0
0x0000ca80  mov      x0, x26
0x0000ca84  mov      x2, x22
0x0000ca88  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000ca8c  mov      x0, x22
0x0000ca90  mov      x22, x24
0x0000ca94  bl       #0x55d78   ; CALL _objc_release
0x0000ca98  b        #0xcd78
0x0000ca9c  adrp     x0, #0x75000
0x0000caa0  add      x0, x0, #0xa68   ; STR "FEATURE_OFF"
0x0000caa4  bl       #0x17e20   ; CALL _L
0x0000caa8  mov      x29, x29
0x0000caac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cab0  mov      x19, x0
0x0000cab4  adrp     x1, #0x76000
0x0000cab8  add      x1, x1, #0x548   ; STR "info"
0x0000cabc  mov      x0, x23
0x0000cac0  mov      x2, x19
0x0000cac4  mov      x3, #0
0x0000cac8  mov      x4, #0
0x0000cacc  bl       #0xf0f0
0x0000cad0  mov      x29, x29
0x0000cad4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cad8  mov      x20, x0
0x0000cadc  mov      x0, x26
0x0000cae0  mov      x2, x20
0x0000cae4  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000cae8  b        #0xcd80
0x0000caec  adrp     x0, #0x76000
0x0000caf0  add      x0, x0, #0x6e8   ; STR "CHK_HOOKS_OK"
0x0000caf4  bl       #0x17e20   ; CALL _L
0x0000caf8  mov      x29, x29
0x0000cafc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cb00  mov      x20, x0
0x0000cb04  ldr      x8, [sp, #0x140]
0x0000cb08  stp      x25, x8, [sp]
0x0000cb0c  mov      x0, x22
0x0000cb10  mov      x2, x20
0x0000cb14  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000cb18  mov      x29, x29
0x0000cb1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cb20  mov      x21, x0
0x0000cb24  adrp     x1, #0x75000
0x0000cb28  add      x1, x1, #0xe08   ; STR "ok"
0x0000cb2c  mov      x0, x19
0x0000cb30  mov      x2, x21
0x0000cb34  mov      x3, #0
0x0000cb38  b        #0xc370
0x0000cb3c  mov      x21, #0
0x0000cb40  ldr      x0, [sp, #0x188]
0x0000cb44  mov      x2, x21
0x0000cb48  bl       #0x57b40   ; CALL objc_msgSend$fileExistsAtPath:
0x0000cb4c  tbz      w0, #0, #0xcb58
0x0000cb50  mov      w22, #1
0x0000cb54  b        #0xd320
0x0000cb58  adrp     x0, #0x75000
0x0000cb5c  add      x0, x0, #0xfc8   ; STR "/usr/lib/TweakInject.dylib"
0x0000cb60  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0000cb64  add      x1, sp, #0x970
0x0000cb68  bl       #0x4118
0x0000cb6c  cbz      x0, #0xd304
0x0000cb70  mov      x2, x0
0x0000cb74  adrp     x8, #0x8e000
0x0000cb78  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0000cb7c  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0000cb80  mov      x29, x29
0x0000cb84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cb88  mov      x23, x0
0x0000cb8c  bl       #0x55d84   ; CALL _objc_retain
0x0000cb90  mov      x0, x23
0x0000cb94  bl       #0x55d78   ; CALL _objc_release
0x0000cb98  b        #0xd308
0x0000cb9c  adrp     x19, #0x75000
0x0000cba0  add      x19, x19, #0xd28
0x0000cba4  mov      x0, x20
0x0000cba8  bl       #0x55d78   ; CALL _objc_release
0x0000cbac  ldr      x20, [x27, #0x958]   ; @CLASS NSString
0x0000cbb0  adrp     x0, #0x76000
0x0000cbb4  add      x0, x0, #0x768   ; STR "CHK_CRASH_AT"
0x0000cbb8  bl       #0x17e20   ; CALL _L
0x0000cbbc  mov      x29, x29
0x0000cbc0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cbc4  mov      x21, x0
0x0000cbc8  adrp     x22, #0x75000
0x0000cbcc  add      x22, x22, #0x968   ; STR "date"
0x0000cbd0  mov      x0, x26
0x0000cbd4  mov      x2, x22
0x0000cbd8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000cbdc  mov      x29, x29
0x0000cbe0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cbe4  mov      x23, x0
0x0000cbe8  bl       #0xf6c0
0x0000cbec  mov      x29, x29
0x0000cbf0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cbf4  mov      x24, x0
0x0000cbf8  stp      x0, x19, [sp]
0x0000cbfc  mov      x0, x20
0x0000cc00  mov      x2, x21
0x0000cc04  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000cc08  mov      x29, x29
0x0000cc0c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cc10  mov      x20, x0
0x0000cc14  mov      x0, x24
0x0000cc18  bl       #0x55d78   ; CALL _objc_release
0x0000cc1c  mov      x0, x23
0x0000cc20  bl       #0x55d78   ; CALL _objc_release
0x0000cc24  mov      x0, x21
0x0000cc28  bl       #0x55d78   ; CALL _objc_release
0x0000cc2c  mov      x0, x26
0x0000cc30  mov      x2, x22
0x0000cc34  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000cc38  mov      x29, x29
0x0000cc3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cc40  mov      x21, x0
0x0000cc44  bl       #0x5dae0   ; CALL objc_msgSend$timeIntervalSinceNow
0x0000cc48  mov      v8.16b, v0.16b
0x0000cc4c  mov      x0, x21
0x0000cc50  bl       #0x55d78   ; CALL _objc_release
0x0000cc54  adrp     x0, #0x76000
0x0000cc58  add      x0, x0, #0x788   ; STR "CHK_CRASH"
0x0000cc5c  bl       #0x17e20   ; CALL _L
0x0000cc60  mov      x29, x29
0x0000cc64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cc68  mov      x21, x0
0x0000cc6c  adrp     x8, #0x65000
0x0000cc70  ldr      d9, [x8, #0x628]
0x0000cc74  fcmp     d8, d9
0x0000cc78  adrp     x8, #0x75000
0x0000cc7c  add      x8, x8, #0xe28   ; STR "warn"
0x0000cc80  adrp     x9, #0x75000
0x0000cc84  add      x9, x9, #0xe08   ; STR "ok"
0x0000cc88  csel     x23, x8, x9, gt
0x0000cc8c  b.le     #0xccac
0x0000cc90  adrp     x0, #0x76000
0x0000cc94  add      x0, x0, #0x7a8   ; STR "CHK_CRASH_FIX"
0x0000cc98  bl       #0x17e20   ; CALL _L
0x0000cc9c  mov      x29, x29
0x0000cca0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cca4  mov      x22, x0
0x0000cca8  b        #0xccb0
0x0000ccac  mov      x22, #0
0x0000ccb0  mov      x0, x21
0x0000ccb4  mov      x1, x23
0x0000ccb8  mov      x2, x20
0x0000ccbc  mov      x3, x22
0x0000ccc0  mov      x4, #0
0x0000ccc4  bl       #0xf0f0
0x0000ccc8  mov      x29, x29
0x0000cccc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ccd0  mov      x23, x0
0x0000ccd4  mov      x0, x25
0x0000ccd8  mov      x2, x23
0x0000ccdc  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000cce0  mov      x0, x23
0x0000cce4  bl       #0x55d78   ; CALL _objc_release
0x0000cce8  fcmp     d8, d9
0x0000ccec  b.le     #0xc540
0x0000ccf0  mov      x0, x22
0x0000ccf4  bl       #0x55d78   ; CALL _objc_release
0x0000ccf8  b        #0xc540
0x0000ccfc  adrp     x0, #0x75000
0x0000cd00  add      x0, x0, #0xa48   ; STR "FEATURE_ON"
0x0000cd04  bl       #0x17e20   ; CALL _L
0x0000cd08  mov      x29, x29
0x0000cd0c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cd10  mov      x19, x0
0x0000cd14  adrp     x0, #0x76000
0x0000cd18  add      x0, x0, #0x5a8   ; STR "CHK_CAR_NEVER_FIX"
0x0000cd1c  bl       #0x17e20   ; CALL _L
0x0000cd20  mov      x29, x29
0x0000cd24  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cd28  mov      x20, x0
0x0000cd2c  adrp     x1, #0x76000
0x0000cd30  add      x1, x1, #0x548   ; STR "info"
0x0000cd34  mov      x0, x23
0x0000cd38  mov      x2, x19
0x0000cd3c  mov      x3, x20
0x0000cd40  b        #0xcd58
0x0000cd44  adrp     x1, #0x75000
0x0000cd48  add      x1, x1, #0xe08   ; STR "ok"
0x0000cd4c  mov      x0, x23
0x0000cd50  mov      x2, x20
0x0000cd54  mov      x3, #0
0x0000cd58  mov      x4, #0
0x0000cd5c  bl       #0xf0f0
0x0000cd60  mov      x29, x29
0x0000cd64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cd68  mov      x21, x0
0x0000cd6c  mov      x0, x26
0x0000cd70  mov      x2, x21
0x0000cd74  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000cd78  mov      x0, x21
0x0000cd7c  bl       #0x55d78   ; CALL _objc_release
0x0000cd80  mov      x0, x20
0x0000cd84  bl       #0x55d78   ; CALL _objc_release
0x0000cd88  mov      x0, x19
0x0000cd8c  bl       #0x55d78   ; CALL _objc_release
0x0000cd90  adrp     x0, #0x76000
0x0000cd94  add      x0, x0, #0x908   ; STR "appBridge"
0x0000cd98  bl       #0x6804   ; CALL _OMCFeatureDisplayName
0x0000cd9c  mov      x29, x29
0x0000cda0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cda4  mov      x24, x0
0x0000cda8  adrp     x0, #0x76000
0x0000cdac  add      x0, x0, #0x928   ; STR "appBridgeApps"
0x0000cdb0  bl       #0x7a70
0x0000cdb4  mov      x29, x29
0x0000cdb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cdbc  mov      x27, x0
0x0000cdc0  ldr      x0, [x22, #0x960]   ; @STR "CHK_STORAGE_FREE"
0x0000cdc4  bl       #0x55d48   ; CALL _objc_opt_class
0x0000cdc8  mov      x1, x0
0x0000cdcc  mov      x0, x27
0x0000cdd0  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0000cdd4  str      x23, [sp, #0x98]
0x0000cdd8  tbnz     w0, #0, #0xcdec
0x0000cddc  mov      x0, x27
0x0000cde0  bl       #0x55d78   ; CALL _objc_release
0x0000cde4  adrp     x27, #0x74000
0x0000cde8  ldr      x27, [x27, #0x1a0]   ; @GOT ___NSArray0__struct
0x0000cdec  adrp     x8, #0x8e000
0x0000cdf0  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x0000cdf4  bl       #0x565c0   ; CALL objc_msgSend$array
0x0000cdf8  mov      x29, x29
0x0000cdfc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ce00  mov      x23, x0
0x0000ce04  movi     v0.16b, #0
0x0000ce08  stp      q0, q0, [sp, #0x1b0]
0x0000ce0c  stp      q0, q0, [sp, #0x1d0]
0x0000ce10  mov      x0, x27
0x0000ce14  bl       #0x55d84   ; CALL _objc_retain
0x0000ce18  add      x2, sp, #0x1b0
0x0000ce1c  add      x3, sp, #0x4f0
0x0000ce20  mov      x0, x27
0x0000ce24  mov      w4, #0x10
0x0000ce28  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000ce2c  cbz      x0, #0xcea0
0x0000ce30  mov      x19, x0
0x0000ce34  ldr      x8, [sp, #0x1c0]
0x0000ce38  ldr      x21, [x8]   ; @SEL "whatsNewNavigationController"
0x0000ce3c  mov      x22, #0
0x0000ce40  ldr      x8, [sp, #0x1c0]
0x0000ce44  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0000ce48  cmp      x8, x21
0x0000ce4c  b.eq     #0xce58
0x0000ce50  mov      x0, x27
0x0000ce54  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0000ce58  ldr      x8, [sp, #0x1b8]
0x0000ce5c  ldr      x20, [x8, x22, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0000ce60  mov      x0, x20
0x0000ce64  bl       #0xf80c
0x0000ce68  tbnz     w0, #0, #0xce78
0x0000ce6c  mov      x0, x23
0x0000ce70  mov      x2, x20
0x0000ce74  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000ce78  add      x22, x22, #1
0x0000ce7c  cmp      x19, x22
0x0000ce80  b.ne     #0xce40
0x0000ce84  add      x2, sp, #0x1b0
0x0000ce88  add      x3, sp, #0x4f0
0x0000ce8c  mov      x0, x27
0x0000ce90  mov      w4, #0x10
0x0000ce94  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000ce98  mov      x19, x0
0x0000ce9c  cbnz     x0, #0xce3c
0x0000cea0  mov      x0, x27
0x0000cea4  bl       #0x55d78   ; CALL _objc_release
0x0000cea8  str      x26, [sp, #0x1a0]
0x0000ceac  str      w28, [sp, #0x1a8]
0x0000ceb0  cbz      w28, #0xcfd8
0x0000ceb4  adrp     x0, #0x76000
0x0000ceb8  add      x0, x0, #0x908   ; STR "appBridge"
0x0000cebc  bl       #0x7a8c
0x0000cec0  tbz      w0, #0, #0xcfd8
0x0000cec4  mov      x0, x27
0x0000cec8  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000cecc  cbz      x0, #0xd028
0x0000ced0  mov      x0, x23
0x0000ced4  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000ced8  mov      x21, x0
0x0000cedc  adrp     x22, #0x8e000
0x0000cee0  ldr      x20, [x22, #0x958]   ; @CLASS NSString
0x0000cee4  adrp     x0, #0x76000
0x0000cee8  add      x0, x0, #0x988   ; STR "CHK_BRIDGE_APPS"
0x0000ceec  bl       #0x17e20   ; CALL _L
0x0000cef0  mov      x29, x29
0x0000cef4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cef8  mov      x19, x0
0x0000cefc  mov      x0, x27
0x0000cf00  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000cf04  str      x0, [sp]
0x0000cf08  mov      x0, x20
0x0000cf0c  mov      x2, x19
0x0000cf10  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000cf14  mov      x29, x29
0x0000cf18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cf1c  mov      x20, x0
0x0000cf20  cbz      x21, #0xd070
0x0000cf24  ldr      x21, [x22, #0x958]   ; @CLASS NSString
0x0000cf28  adrp     x0, #0x76000
0x0000cf2c  add      x0, x0, #0x9a8   ; STR "CHK_BRIDGE_GONE"
0x0000cf30  bl       #0x17e20   ; CALL _L
0x0000cf34  mov      x29, x29
0x0000cf38  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cf3c  mov      x22, x0
0x0000cf40  adrp     x2, #0x75000
0x0000cf44  add      x2, x2, #0xb28   ; STR ", "
0x0000cf48  mov      x0, x23
0x0000cf4c  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x0000cf50  mov      x29, x29
0x0000cf54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cf58  mov      x28, x24
0x0000cf5c  mov      x24, x0
0x0000cf60  str      x0, [sp]
0x0000cf64  mov      x0, x21
0x0000cf68  mov      x2, x22
0x0000cf6c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000cf70  mov      x29, x29
0x0000cf74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cf78  mov      x21, x0
0x0000cf7c  adrp     x1, #0x75000
0x0000cf80  add      x1, x1, #0xe28   ; STR "warn"
0x0000cf84  mov      x0, x28
0x0000cf88  mov      x2, x20
0x0000cf8c  mov      x3, x21
0x0000cf90  mov      x4, #0
0x0000cf94  bl       #0xf0f0
0x0000cf98  mov      x29, x29
0x0000cf9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cfa0  mov      x26, x0
0x0000cfa4  ldr      x0, [sp, #0x1a0]
0x0000cfa8  mov      x2, x26
0x0000cfac  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000cfb0  mov      x0, x26
0x0000cfb4  ldr      x26, [sp, #0x1a0]
0x0000cfb8  bl       #0x55d78   ; CALL _objc_release
0x0000cfbc  mov      x0, x21
0x0000cfc0  bl       #0x55d78   ; CALL _objc_release
0x0000cfc4  mov      x0, x24
0x0000cfc8  mov      x24, x28
0x0000cfcc  bl       #0x55d78   ; CALL _objc_release
0x0000cfd0  mov      x0, x22
0x0000cfd4  b        #0xd0a8
0x0000cfd8  adrp     x0, #0x75000
0x0000cfdc  add      x0, x0, #0xa68   ; STR "FEATURE_OFF"
0x0000cfe0  bl       #0x17e20   ; CALL _L
0x0000cfe4  mov      x29, x29
0x0000cfe8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000cfec  mov      x19, x0
0x0000cff0  adrp     x1, #0x76000
0x0000cff4  add      x1, x1, #0x548   ; STR "info"
0x0000cff8  mov      x0, x24
0x0000cffc  mov      x2, x19
0x0000d000  mov      x3, #0
0x0000d004  mov      x4, #0
0x0000d008  bl       #0xf0f0
0x0000d00c  mov      x29, x29
0x0000d010  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d014  mov      x20, x0
0x0000d018  mov      x0, x26
0x0000d01c  mov      x2, x20
0x0000d020  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000d024  b        #0xd0ac
0x0000d028  adrp     x0, #0x76000
0x0000d02c  add      x0, x0, #0x948   ; STR "CHK_BRIDGE_NONE"
0x0000d030  bl       #0x17e20   ; CALL _L
0x0000d034  mov      x29, x29
0x0000d038  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d03c  mov      x19, x0
0x0000d040  adrp     x0, #0x76000
0x0000d044  add      x0, x0, #0x968   ; STR "CHK_BRIDGE_NONE_FIX"
0x0000d048  bl       #0x17e20   ; CALL _L
0x0000d04c  mov      x29, x29
0x0000d050  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d054  mov      x20, x0
0x0000d058  adrp     x1, #0x75000
0x0000d05c  add      x1, x1, #0xe28   ; STR "warn"
0x0000d060  mov      x0, x24
0x0000d064  mov      x2, x19
0x0000d068  mov      x3, x20
0x0000d06c  b        #0xd084
0x0000d070  adrp     x1, #0x75000
0x0000d074  add      x1, x1, #0xe08   ; STR "ok"
0x0000d078  mov      x0, x24
0x0000d07c  mov      x2, x20
0x0000d080  mov      x3, #0
0x0000d084  mov      x4, #0
0x0000d088  bl       #0xf0f0
0x0000d08c  mov      x29, x29
0x0000d090  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d094  mov      x21, x0
0x0000d098  mov      x0, x26
0x0000d09c  mov      x2, x21
0x0000d0a0  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000d0a4  mov      x0, x21
0x0000d0a8  bl       #0x55d78   ; CALL _objc_release
0x0000d0ac  mov      x0, x20
0x0000d0b0  bl       #0x55d78   ; CALL _objc_release
0x0000d0b4  mov      x0, x19
0x0000d0b8  bl       #0x55d78   ; CALL _objc_release
0x0000d0bc  adrp     x0, #0x76000
0x0000d0c0  add      x0, x0, #0x9c8   ; STR "speedBubble"
0x0000d0c4  bl       #0x6804   ; CALL _OMCFeatureDisplayName
0x0000d0c8  mov      x29, x29
0x0000d0cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d0d0  mov      x28, x0
0x0000d0d4  adrp     x0, #0x76000
0x0000d0d8  add      x0, x0, #0xae8   ; STR "speedBubbleSource"
0x0000d0dc  bl       #0x7a70
0x0000d0e0  mov      x29, x29
0x0000d0e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d0e8  mov      x20, x0
0x0000d0ec  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0000d0f0  mov      x19, x0
0x0000d0f4  mov      x0, x20
0x0000d0f8  bl       #0x55d78   ; CALL _objc_release
0x0000d0fc  tbnz     x19, #0x3f, #0xd114
0x0000d100  adrp     x0, #0x7f000
0x0000d104  add      x0, x0, #0x858
0x0000d108  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000d10c  cmp      x19, x0
0x0000d110  b.lt     #0xd118
0x0000d114  mov      x19, #0
0x0000d118  adrp     x8, #0x8e000
0x0000d11c  ldr      x20, [x8, #0x958]   ; @CLASS NSString
0x0000d120  adrp     x0, #0x76000
0x0000d124  add      x0, x0, #0xb08   ; STR "CHK_BUBBLE_SOURCE"
0x0000d128  bl       #0x17e20   ; CALL _L
0x0000d12c  mov      x29, x29
0x0000d130  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d134  mov      x21, x0
0x0000d138  adrp     x0, #0x7f000
0x0000d13c  add      x0, x0, #0x858
0x0000d140  mov      x2, x19
0x0000d144  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0000d148  mov      x29, x29
0x0000d14c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d150  mov      x22, x0
0x0000d154  str      x0, [sp]
0x0000d158  mov      x0, x20
0x0000d15c  mov      x2, x21
0x0000d160  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000d164  mov      x29, x29
0x0000d168  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d16c  str      x0, [sp, #0x130]
0x0000d170  mov      x0, x22
0x0000d174  bl       #0x55d78   ; CALL _objc_release
0x0000d178  mov      x0, x21
0x0000d17c  bl       #0x55d78   ; CALL _objc_release
0x0000d180  ldr      w8, [sp, #0x1a8]
0x0000d184  str      x24, [sp, #0x88]
0x0000d188  cbz      w8, #0xd2ac
0x0000d18c  adrp     x0, #0x76000
0x0000d190  add      x0, x0, #0x9c8   ; STR "speedBubble"
0x0000d194  bl       #0x7a8c
0x0000d198  tbz      w0, #0, #0xd2ac
0x0000d19c  adrp     x0, #0x7f000
0x0000d1a0  add      x0, x0, #0x870
0x0000d1a4  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000d1a8  cmp      x19, x0
0x0000d1ac  b.ge     #0xd3e0
0x0000d1b0  adrp     x0, #0x7f000
0x0000d1b4  add      x0, x0, #0x870
0x0000d1b8  mov      x2, x19
0x0000d1bc  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0000d1c0  mov      x29, x29
0x0000d1c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d1c8  mov      x20, x0
0x0000d1cc  bl       #0x58c20   ; CALL objc_msgSend$length
0x0000d1d0  cbz      x0, #0xd3d8
0x0000d1d4  adrp     x0, #0x7f000
0x0000d1d8  add      x0, x0, #0x870
0x0000d1dc  mov      x2, x19
0x0000d1e0  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0000d1e4  mov      x29, x29
0x0000d1e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d1ec  mov      x21, x0
0x0000d1f0  bl       #0xf80c
0x0000d1f4  mov      x22, x0
0x0000d1f8  mov      x0, x21
0x0000d1fc  bl       #0x55d78   ; CALL _objc_release
0x0000d200  mov      x0, x20
0x0000d204  bl       #0x55d78   ; CALL _objc_release
0x0000d208  tbnz     w22, #0, #0xd3e0
0x0000d20c  adrp     x8, #0x8e000
0x0000d210  ldr      x21, [x8, #0x958]   ; @CLASS NSString
0x0000d214  adrp     x0, #0x76000
0x0000d218  add      x0, x0, #0xb28   ; STR "CHK_BUBBLE_MISSING"
0x0000d21c  bl       #0x17e20   ; CALL _L
0x0000d220  mov      x29, x29
0x0000d224  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d228  mov      x20, x0
0x0000d22c  adrp     x0, #0x7f000
0x0000d230  add      x0, x0, #0x858
0x0000d234  mov      x2, x19
0x0000d238  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0000d23c  mov      x29, x29
0x0000d240  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d244  mov      x19, x0
0x0000d248  str      x0, [sp]
0x0000d24c  mov      x0, x21
0x0000d250  mov      x2, x20
0x0000d254  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000d258  mov      x29, x29
0x0000d25c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d260  mov      x21, x0
0x0000d264  adrp     x1, #0x75000
0x0000d268  add      x1, x1, #0xe28   ; STR "warn"
0x0000d26c  mov      x0, x28
0x0000d270  ldr      x2, [sp, #0x130]
0x0000d274  mov      x3, x21
0x0000d278  mov      x4, #0
0x0000d27c  bl       #0xf0f0
0x0000d280  mov      x29, x29
0x0000d284  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d288  mov      x22, x0
0x0000d28c  mov      x0, x26
0x0000d290  mov      x2, x22
0x0000d294  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000d298  mov      x0, x22
0x0000d29c  bl       #0x55d78   ; CALL _objc_release
0x0000d2a0  mov      x0, x21
0x0000d2a4  bl       #0x55d78   ; CALL _objc_release
0x0000d2a8  b        #0xd2f8
0x0000d2ac  adrp     x0, #0x75000
0x0000d2b0  add      x0, x0, #0xa68   ; STR "FEATURE_OFF"
0x0000d2b4  bl       #0x17e20   ; CALL _L
0x0000d2b8  mov      x29, x29
0x0000d2bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d2c0  mov      x20, x0
0x0000d2c4  adrp     x1, #0x76000
0x0000d2c8  add      x1, x1, #0x548   ; STR "info"
0x0000d2cc  mov      x0, x28
0x0000d2d0  mov      x2, x20
0x0000d2d4  mov      x3, #0
0x0000d2d8  mov      x4, #0
0x0000d2dc  bl       #0xf0f0
0x0000d2e0  mov      x29, x29
0x0000d2e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d2e8  mov      x19, x0
0x0000d2ec  mov      x0, x26
0x0000d2f0  mov      x2, x19
0x0000d2f4  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000d2f8  mov      x0, x19
0x0000d2fc  bl       #0x55d78   ; CALL _objc_release
0x0000d300  b        #0xd414
0x0000d304  mov      x23, #0
0x0000d308  ldr      x0, [sp, #0x188]
0x0000d30c  mov      x2, x23
0x0000d310  bl       #0x57b40   ; CALL objc_msgSend$fileExistsAtPath:
0x0000d314  mov      x22, x0
0x0000d318  mov      x0, x23
0x0000d31c  bl       #0x55d78   ; CALL _objc_release
0x0000d320  mov      x0, x21
0x0000d324  bl       #0x55d78   ; CALL _objc_release
0x0000d328  mov      x0, x20
0x0000d32c  bl       #0x55d78   ; CALL _objc_release
0x0000d330  mov      x0, x19
0x0000d334  bl       #0x55d78   ; CALL _objc_release
0x0000d338  cmp      x25, #0
0x0000d33c  cset     w20, ne
0x0000d340  cbnz     x25, #0xa744
0x0000d344  tbnz     w22, #0, #0xa744
0x0000d348  adrp     x0, #0x75000
0x0000d34c  add      x0, x0, #0xfe8   ; STR "CHK_LOADER"
0x0000d350  bl       #0x17e20   ; CALL _L
0x0000d354  mov      x29, x29
0x0000d358  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d35c  mov      x19, x0
0x0000d360  adrp     x0, #0x76000
0x0000d364  add      x0, x0, #0x28   ; STR "CHK_LOADER_NONE"
0x0000d368  bl       #0x17e20   ; CALL _L
0x0000d36c  mov      x29, x29
0x0000d370  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d374  mov      x20, x0
0x0000d378  adrp     x0, #0x76000
0x0000d37c  add      x0, x0, #0x48   ; STR "CHK_LOADER_FIX"
0x0000d380  bl       #0x17e20   ; CALL _L
0x0000d384  mov      x29, x29
0x0000d388  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d38c  mov      x21, x0
0x0000d390  adrp     x1, #0x75000
0x0000d394  add      x1, x1, #0xdc8   ; STR "bad"
0x0000d398  mov      x0, x19
0x0000d39c  mov      x2, x20
0x0000d3a0  mov      x3, x21
0x0000d3a4  mov      x4, #0
0x0000d3a8  bl       #0xf0f0
0x0000d3ac  mov      x29, x29
0x0000d3b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d3b4  mov      x22, x0
0x0000d3b8  mov      x0, x24
0x0000d3bc  mov      x2, x22
0x0000d3c0  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000d3c4  mov      x0, x22
0x0000d3c8  bl       #0x55d78   ; CALL _objc_release
0x0000d3cc  mov      x0, x21
0x0000d3d0  bl       #0x55d78   ; CALL _objc_release
0x0000d3d4  b        #0xa7b0
0x0000d3d8  mov      x0, x20
0x0000d3dc  bl       #0x55d78   ; CALL _objc_release
0x0000d3e0  adrp     x1, #0x75000
0x0000d3e4  add      x1, x1, #0xe08   ; STR "ok"
0x0000d3e8  mov      x0, x28
0x0000d3ec  ldr      x2, [sp, #0x130]
0x0000d3f0  mov      x3, #0
0x0000d3f4  mov      x4, #0
0x0000d3f8  bl       #0xf0f0
0x0000d3fc  mov      x29, x29
0x0000d400  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d404  mov      x20, x0
0x0000d408  mov      x0, x26
0x0000d40c  mov      x2, x20
0x0000d410  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000d414  mov      x0, x20
0x0000d418  bl       #0x55d78   ; CALL _objc_release
0x0000d41c  adrp     x0, #0x76000
0x0000d420  add      x0, x0, #0xb48   ; STR "startupScreen"
0x0000d424  bl       #0x6804   ; CALL _OMCFeatureDisplayName
0x0000d428  mov      x29, x29
0x0000d42c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d430  str      x0, [sp, #0x190]
0x0000d434  adrp     x8, #0x8e000
0x0000d438  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x0000d43c  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x0000d440  mov      x29, x29
0x0000d444  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d448  mov      x19, x0
0x0000d44c  adrp     x0, #0x77000
0x0000d450  add      x0, x0, #0x828   ; STR "startupScreenVideoName"
0x0000d454  bl       #0x7a70
0x0000d458  mov      x29, x29
0x0000d45c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d460  mov      x22, x0
0x0000d464  adrp     x8, #0x8e000
0x0000d468  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0000d46c  bl       #0x55d48   ; CALL _objc_opt_class
0x0000d470  mov      x1, x0
0x0000d474  mov      x0, x22
0x0000d478  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0000d47c  str      x28, [sp, #0x80]
0x0000d480  tbz      w0, #0, #0xd518
0x0000d484  mov      x0, x22
0x0000d488  bl       #0x58c20   ; CALL objc_msgSend$length
0x0000d48c  cbz      x0, #0xd518
0x0000d490  adrp     x0, #0x76000
0x0000d494  add      x0, x0, #0xb68   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Videos"
0x0000d498  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0000d49c  add      x1, sp, #0x970
0x0000d4a0  bl       #0x4118
0x0000d4a4  cbz      x0, #0xd4c8
0x0000d4a8  mov      x2, x0
0x0000d4ac  adrp     x8, #0x8e000
0x0000d4b0  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0000d4b4  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0000d4b8  mov      x29, x29
0x0000d4bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d4c0  mov      x20, x0
0x0000d4c4  b        #0xd4cc
0x0000d4c8  mov      x20, #0
0x0000d4cc  mov      x0, x20
0x0000d4d0  mov      x2, x22
0x0000d4d4  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x0000d4d8  mov      x29, x29
0x0000d4dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d4e0  mov      x21, x0
0x0000d4e4  mov      x0, x19
0x0000d4e8  mov      x2, x21
0x0000d4ec  bl       #0x57b40   ; CALL objc_msgSend$fileExistsAtPath:
0x0000d4f0  mov      x24, x0
0x0000d4f4  mov      x0, x21
0x0000d4f8  bl       #0x55d78   ; CALL _objc_release
0x0000d4fc  mov      x0, x20
0x0000d500  bl       #0x55d78   ; CALL _objc_release
0x0000d504  cbz      w24, #0xd518
0x0000d508  mov      x0, x22
0x0000d50c  bl       #0x55d84   ; CALL _objc_retain
0x0000d510  mov      x28, x22
0x0000d514  b        #0xd658
0x0000d518  movi     v0.16b, #0
0x0000d51c  str      q0, [sp, #0x440]
0x0000d520  str      q0, [sp, #0x430]
0x0000d524  str      q0, [sp, #0x420]
0x0000d528  str      q0, [sp, #0x410]
0x0000d52c  adrp     x0, #0x76000
0x0000d530  add      x0, x0, #0xb68   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Videos"
0x0000d534  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0000d538  add      x1, sp, #0x970
0x0000d53c  bl       #0x4118
0x0000d540  cbz      x0, #0xd564
0x0000d544  mov      x2, x0
0x0000d548  adrp     x8, #0x8e000
0x0000d54c  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0000d550  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0000d554  mov      x29, x29
0x0000d558  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d55c  mov      x21, x0
0x0000d560  b        #0xd568
0x0000d564  mov      x21, #0
0x0000d568  mov      x0, x19
0x0000d56c  mov      x2, x21
0x0000d570  mov      x3, #0
0x0000d574  bl       #0x572a0   ; CALL objc_msgSend$contentsOfDirectoryAtPath:error:
0x0000d578  mov      x29, x29
0x0000d57c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d580  mov      x24, x0
0x0000d584  ldr      x2, [sp, #0x78]
0x0000d588  bl       #0x5cd00   ; CALL objc_msgSend$sortedArrayUsingSelector:
0x0000d58c  mov      x29, x29
0x0000d590  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d594  mov      x20, x0
0x0000d598  mov      x0, x24
0x0000d59c  bl       #0x55d78   ; CALL _objc_release
0x0000d5a0  mov      x0, x21
0x0000d5a4  bl       #0x55d78   ; CALL _objc_release
0x0000d5a8  add      x2, sp, #0x410
0x0000d5ac  add      x3, sp, #0x970
0x0000d5b0  mov      x0, x20
0x0000d5b4  mov      w4, #0x10
0x0000d5b8  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000d5bc  cbz      x0, #0xd630
0x0000d5c0  mov      x26, x0
0x0000d5c4  ldr      x8, [sp, #0x420]
0x0000d5c8  ldr      x24, [x8]   ; @SEL "whatsNewNavigationController"
0x0000d5cc  adrp     x21, #0x77000
0x0000d5d0  add      x21, x21, #0x848   ; STR "."
0x0000d5d4  mov      x25, #0
0x0000d5d8  ldr      x8, [sp, #0x420]
0x0000d5dc  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0000d5e0  cmp      x8, x24
0x0000d5e4  b.eq     #0xd5f0
0x0000d5e8  mov      x0, x20
0x0000d5ec  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0000d5f0  ldr      x8, [sp, #0x418]
0x0000d5f4  ldr      x28, [x8, x25, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0000d5f8  mov      x0, x28
0x0000d5fc  mov      x2, x21
0x0000d600  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x0000d604  cbz      w0, #0xd640
0x0000d608  add      x25, x25, #1
0x0000d60c  cmp      x26, x25
0x0000d610  b.ne     #0xd5d8
0x0000d614  add      x2, sp, #0x410
0x0000d618  add      x3, sp, #0x970
0x0000d61c  mov      x0, x20
0x0000d620  mov      w4, #0x10
0x0000d624  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000d628  mov      x26, x0
0x0000d62c  cbnz     x0, #0xd5d4
0x0000d630  mov      x0, x20
0x0000d634  bl       #0x55d78   ; CALL _objc_release
0x0000d638  mov      x28, #0
0x0000d63c  b        #0xd650
0x0000d640  mov      x0, x28
0x0000d644  bl       #0x55d84   ; CALL _objc_retain
0x0000d648  mov      x0, x20
0x0000d64c  bl       #0x55d78   ; CALL _objc_release
0x0000d650  ldr      x25, [sp, #0x148]
0x0000d654  ldr      x26, [sp, #0x1a0]
0x0000d658  mov      x0, x22
0x0000d65c  bl       #0x55d78   ; CALL _objc_release
0x0000d660  mov      x0, x19
0x0000d664  bl       #0x55d78   ; CALL _objc_release
0x0000d668  ldr      x24, [sp, #0x150]
0x0000d66c  str      x28, [sp, #0x170]
0x0000d670  cbz      x28, #0xd6c0
0x0000d674  adrp     x8, #0x8e000
0x0000d678  ldr      x19, [x8, #0x970]   ; @CLASS NSDictionary
0x0000d67c  adrp     x0, #0x76000
0x0000d680  add      x0, x0, #0xb68   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Videos"
0x0000d684  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0000d688  add      x1, sp, #0x970
0x0000d68c  bl       #0x4118
0x0000d690  cbz      x0, #0xd6cc
0x0000d694  mov      x2, x0
0x0000d698  adrp     x8, #0x8e000
0x0000d69c  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0000d6a0  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0000d6a4  mov      x29, x29
0x0000d6a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d6ac  mov      x20, x0
0x0000d6b0  bl       #0x55d84   ; CALL _objc_retain
0x0000d6b4  mov      x0, x20
0x0000d6b8  bl       #0x55d78   ; CALL _objc_release
0x0000d6bc  b        #0xd6d0
0x0000d6c0  mov      x19, #0
0x0000d6c4  ldr      w28, [sp, #0x1a8]
0x0000d6c8  b        #0xd764
0x0000d6cc  mov      x20, #0
0x0000d6d0  ldr      w28, [sp, #0x1a8]
0x0000d6d4  adrp     x2, #0x76000
0x0000d6d8  add      x2, x2, #0xb88   ; STR ".frames"
0x0000d6dc  mov      x0, x20
0x0000d6e0  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x0000d6e4  mov      x29, x29
0x0000d6e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d6ec  mov      x21, x0
0x0000d6f0  ldr      x2, [sp, #0x170]
0x0000d6f4  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x0000d6f8  mov      x29, x29
0x0000d6fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d700  mov      x22, x0
0x0000d704  adrp     x2, #0x76000
0x0000d708  add      x2, x2, #0xba8   ; STR "info.plist"
0x0000d70c  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x0000d710  mov      x29, x29
0x0000d714  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d718  mov      x24, x0
0x0000d71c  mov      x0, x19
0x0000d720  mov      x2, x24
0x0000d724  bl       #0x577a0   ; CALL objc_msgSend$dictionaryWithContentsOfFile:
0x0000d728  mov      x29, x29
0x0000d72c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d730  mov      x19, x0
0x0000d734  bl       #0x55d84   ; CALL _objc_retain
0x0000d738  mov      x0, x19
0x0000d73c  bl       #0x55d78   ; CALL _objc_release
0x0000d740  mov      x0, x24
0x0000d744  bl       #0x55d78   ; CALL _objc_release
0x0000d748  mov      x0, x22
0x0000d74c  bl       #0x55d78   ; CALL _objc_release
0x0000d750  mov      x0, x21
0x0000d754  bl       #0x55d78   ; CALL _objc_release
0x0000d758  mov      x0, x20
0x0000d75c  bl       #0x55d78   ; CALL _objc_release
0x0000d760  ldr      x24, [sp, #0x150]
0x0000d764  adrp     x22, #0x76000
0x0000d768  add      x22, x22, #0x5c8   ; STR "CarPlay"
0x0000d76c  str      x19, [sp, #0x78]
0x0000d770  cbz      w28, #0xd82c
0x0000d774  adrp     x0, #0x76000
0x0000d778  add      x0, x0, #0xb48   ; STR "startupScreen"
0x0000d77c  bl       #0x7a8c
0x0000d780  tbz      w0, #0, #0xd82c
0x0000d784  ldr      x21, [sp, #0x170]
0x0000d788  cbz      x21, #0xdb54
0x0000d78c  adrp     x2, #0x76000
0x0000d790  add      x2, x2, #0xc08   ; STR "count"
0x0000d794  mov      x0, x19
0x0000d798  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000d79c  mov      x29, x29
0x0000d7a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d7a4  mov      x28, x19
0x0000d7a8  mov      x19, x0
0x0000d7ac  bl       #0x5dcc0   ; CALL objc_msgSend$unsignedIntegerValue
0x0000d7b0  mov      x20, x0
0x0000d7b4  mov      x0, x19
0x0000d7b8  bl       #0x55d78   ; CALL _objc_release
0x0000d7bc  cbz      x20, #0xe404
0x0000d7c0  adrp     x8, #0x8e000
0x0000d7c4  ldr      x20, [x8, #0x958]   ; @CLASS NSString
0x0000d7c8  adrp     x2, #0x76000
0x0000d7cc  add      x2, x2, #0xc68   ; STR "fps"
0x0000d7d0  mov      x0, x28
0x0000d7d4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000d7d8  mov      x29, x29
0x0000d7dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d7e0  mov      x19, x0
0x0000d7e4  cmp      x0, #0
0x0000d7e8  adrp     x8, #0x75000
0x0000d7ec  add      x8, x8, #0x868   ; STR "?"
0x0000d7f0  csel     x8, x8, x0, eq
0x0000d7f4  stp      x21, x8, [sp]
0x0000d7f8  adrp     x2, #0x76000
0x0000d7fc  add      x2, x2, #0xc48   ; STR "%@ · %@ fps"
0x0000d800  mov      x0, x20
0x0000d804  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000d808  mov      x29, x29
0x0000d80c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d810  mov      x20, x0
0x0000d814  adrp     x1, #0x75000
0x0000d818  add      x1, x1, #0xe08   ; STR "ok"
0x0000d81c  ldr      x0, [sp, #0x190]
0x0000d820  mov      x2, x20
0x0000d824  mov      x3, #0
0x0000d828  b        #0xdb98
0x0000d82c  adrp     x0, #0x75000
0x0000d830  add      x0, x0, #0xa68   ; STR "FEATURE_OFF"
0x0000d834  bl       #0x17e20   ; CALL _L
0x0000d838  mov      x29, x29
0x0000d83c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d840  mov      x19, x0
0x0000d844  adrp     x1, #0x76000
0x0000d848  add      x1, x1, #0x548   ; STR "info"
0x0000d84c  ldr      x0, [sp, #0x190]
0x0000d850  mov      x2, x19
0x0000d854  mov      x3, #0
0x0000d858  mov      x4, #0
0x0000d85c  bl       #0xf0f0
0x0000d860  mov      x29, x29
0x0000d864  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d868  mov      x20, x0
0x0000d86c  mov      x0, x26
0x0000d870  mov      x2, x20
0x0000d874  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000d878  mov      x0, x20
0x0000d87c  bl       #0x55d78   ; CALL _objc_release
0x0000d880  mov      x0, x19
0x0000d884  bl       #0x55d78   ; CALL _objc_release
0x0000d888  adrp     x19, #0x75000
0x0000d88c  add      x19, x19, #0x4a8   ; STR "title"
0x0000d890  str      x19, [sp, #0x4b0]
0x0000d894  adrp     x0, #0x75000
0x0000d898  add      x0, x0, #0x4c8   ; STR "DIAG_DEVICE"
0x0000d89c  bl       #0x17e20   ; CALL _L
0x0000d8a0  mov      x29, x29
0x0000d8a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d8a8  mov      x26, x0
0x0000d8ac  adrp     x21, #0x76000
0x0000d8b0  add      x21, x21, #0xc88   ; STR "checks"
0x0000d8b4  str      x21, [sp, #0x4b8]
0x0000d8b8  str      x0, [sp, #0x4c0]
0x0000d8bc  str      x24, [sp, #0x4c8]
0x0000d8c0  adrp     x20, #0x8e000
0x0000d8c4  ldr      x0, [x20, #0x970]   ; @CLASS NSDictionary
0x0000d8c8  add      x2, sp, #0x4c0
0x0000d8cc  add      x3, sp, #0x4b0
0x0000d8d0  mov      w4, #2
0x0000d8d4  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0000d8d8  mov      x29, x29
0x0000d8dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d8e0  mov      x24, x0
0x0000d8e4  str      x0, [sp, #0x4d0]
0x0000d8e8  str      x19, [sp, #0x490]
0x0000d8ec  str      x21, [sp, #0x498]
0x0000d8f0  str      x22, [sp, #0x4a0]
0x0000d8f4  str      x25, [sp, #0x4a8]
0x0000d8f8  ldr      x0, [x20, #0x970]   ; @CLASS NSDictionary
0x0000d8fc  add      x2, sp, #0x4a0
0x0000d900  add      x3, sp, #0x490
0x0000d904  mov      w4, #2
0x0000d908  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0000d90c  mov      x29, x29
0x0000d910  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d914  str      x0, [sp, #0x60]
0x0000d918  str      x0, [sp, #0x4d8]
0x0000d91c  str      x19, [sp, #0x470]
0x0000d920  adrp     x0, #0x76000
0x0000d924  add      x0, x0, #0xca8   ; STR "CHK_PERF_GROUP"
0x0000d928  bl       #0x17e20   ; CALL _L
0x0000d92c  mov      x29, x29
0x0000d930  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d934  str      x0, [sp, #0x58]
0x0000d938  str      x0, [sp, #0x480]
0x0000d93c  str      x21, [sp, #0x478]
0x0000d940  adrp     x8, #0x8e000
0x0000d944  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x0000d948  bl       #0x565c0   ; CALL objc_msgSend$array
0x0000d94c  mov      x29, x29
0x0000d950  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d954  mov      x19, x0
0x0000d958  adrp     x0, #0x77000
0x0000d95c  add      x0, x0, #0x868   ; STR "diagPerf"
0x0000d960  bl       #0x7a70
0x0000d964  mov      x29, x29
0x0000d968  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d96c  mov      x28, x0
0x0000d970  ldr      x0, [x20, #0x970]   ; @CLASS NSDictionary
0x0000d974  bl       #0x55d48   ; CALL _objc_opt_class
0x0000d978  mov      x1, x0
0x0000d97c  mov      x0, x28
0x0000d980  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0000d984  str      x28, [sp, #0x1a8]
0x0000d988  stp      x24, x26, [sp, #0x68]
0x0000d98c  tbz      w0, #0, #0xdad4
0x0000d990  adrp     x2, #0x77000
0x0000d994  add      x2, x2, #0x888   ; STR "start"
0x0000d998  mov      x0, x28
0x0000d99c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000d9a0  mov      x29, x29
0x0000d9a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d9a8  mov      x20, x0
0x0000d9ac  adrp     x22, #0x8e000
0x0000d9b0  ldr      x0, [x22, #0x978]   ; @CLASS NSDate
0x0000d9b4  bl       #0x55d48   ; CALL _objc_opt_class
0x0000d9b8  mov      x1, x0
0x0000d9bc  mov      x0, x20
0x0000d9c0  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0000d9c4  mov      x21, x0
0x0000d9c8  mov      x0, x20
0x0000d9cc  bl       #0x55d78   ; CALL _objc_release
0x0000d9d0  tbz      w21, #0, #0xdad4
0x0000d9d4  adrp     x2, #0x77000
0x0000d9d8  add      x2, x2, #0x8e8   ; STR "seconds"
0x0000d9dc  mov      x0, x28
0x0000d9e0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000d9e4  mov      x29, x29
0x0000d9e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000d9ec  mov      x20, x0
0x0000d9f0  bl       #0x57880   ; CALL objc_msgSend$doubleValue
0x0000d9f4  mov      x8, #0x404e000000000000
0x0000d9f8  fmov     d1, x8
0x0000d9fc  fdiv     d0, d0, d1
0x0000da00  fcvtas   x21, d0
0x0000da04  mov      x0, x20
0x0000da08  bl       #0x55d78   ; CALL _objc_release
0x0000da0c  cmp      x21, #1
0x0000da10  csinc    x25, x21, xzr, gt
0x0000da14  ldr      w8, [sp, #0x50]
0x0000da18  cbz      w8, #0xdbcc
0x0000da1c  adrp     x2, #0x77000
0x0000da20  add      x2, x2, #0x908   ; STR "updated"
0x0000da24  mov      x0, x28
0x0000da28  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000da2c  mov      x29, x29
0x0000da30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000da34  mov      x20, x0
0x0000da38  ldr      x0, [x22, #0x978]   ; @CLASS NSDate
0x0000da3c  bl       #0x55d48   ; CALL _objc_opt_class
0x0000da40  mov      x1, x0
0x0000da44  mov      x0, x20
0x0000da48  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0000da4c  tbz      w0, #0, #0xdbc4
0x0000da50  adrp     x2, #0x77000
0x0000da54  add      x2, x2, #0x908   ; STR "updated"
0x0000da58  mov      x0, x28
0x0000da5c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000da60  mov      x29, x29
0x0000da64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000da68  mov      x21, x0
0x0000da6c  bl       #0x5dae0   ; CALL objc_msgSend$timeIntervalSinceNow
0x0000da70  mov      v8.16b, v0.16b
0x0000da74  mov      x0, x21
0x0000da78  bl       #0x55d78   ; CALL _objc_release
0x0000da7c  mov      x0, x20
0x0000da80  bl       #0x55d78   ; CALL _objc_release
0x0000da84  adrp     x8, #0x65000
0x0000da88  ldr      d0, [x8, #0x630]
0x0000da8c  fcmp     d8, d0
0x0000da90  b.le     #0xdbcc
0x0000da94  adrp     x8, #0x8e000
0x0000da98  ldr      x21, [x8, #0x958]   ; @CLASS NSString
0x0000da9c  adrp     x0, #0x77000
0x0000daa0  add      x0, x0, #0x928   ; STR "CHK_PERF_LIVE"
0x0000daa4  bl       #0x17e20   ; CALL _L
0x0000daa8  mov      x29, x29
0x0000daac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000dab0  mov      x20, x0
0x0000dab4  str      x25, [sp]
0x0000dab8  mov      x0, x21
0x0000dabc  mov      x2, x20
0x0000dac0  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000dac4  mov      x29, x29
0x0000dac8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000dacc  mov      x21, x0
0x0000dad0  b        #0xdc44
0x0000dad4  adrp     x0, #0x77000
0x0000dad8  add      x0, x0, #0x8a8   ; STR "CHK_PERF_DRIVE"
0x0000dadc  bl       #0x17e20   ; CALL _L
0x0000dae0  mov      x29, x29
0x0000dae4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000dae8  mov      x25, x0
0x0000daec  adrp     x0, #0x76000
0x0000daf0  add      x0, x0, #0x648   ; STR "CHK_CP_NONE"
0x0000daf4  bl       #0x17e20   ; CALL _L
0x0000daf8  mov      x29, x29
0x0000dafc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000db00  mov      x22, x0
0x0000db04  adrp     x0, #0x77000
0x0000db08  add      x0, x0, #0x8c8   ; STR "CHK_PERF_NONE_FIX"
0x0000db0c  bl       #0x17e20   ; CALL _L
0x0000db10  mov      x29, x29
0x0000db14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000db18  mov      x20, x0
0x0000db1c  adrp     x1, #0x76000
0x0000db20  add      x1, x1, #0x548   ; STR "info"
0x0000db24  mov      x0, x25
0x0000db28  mov      x2, x22
0x0000db2c  mov      x3, x20
0x0000db30  mov      x4, #0
0x0000db34  bl       #0xf0f0
0x0000db38  mov      x29, x29
0x0000db3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000db40  mov      x21, x0
0x0000db44  mov      x0, x19
0x0000db48  mov      x2, x21
0x0000db4c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000db50  b        #0xeb34
0x0000db54  adrp     x0, #0x76000
0x0000db58  add      x0, x0, #0xbc8   ; STR "CHK_START_NONE"
0x0000db5c  bl       #0x17e20   ; CALL _L
0x0000db60  mov      x29, x29
0x0000db64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000db68  mov      x19, x0
0x0000db6c  adrp     x0, #0x76000
0x0000db70  add      x0, x0, #0xbe8   ; STR "CHK_START_NONE_FIX"
0x0000db74  bl       #0x17e20   ; CALL _L
0x0000db78  mov      x29, x29
0x0000db7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000db80  mov      x20, x0
0x0000db84  adrp     x1, #0x75000
0x0000db88  add      x1, x1, #0xe28   ; STR "warn"
0x0000db8c  ldr      x0, [sp, #0x190]
0x0000db90  mov      x2, x19
0x0000db94  mov      x3, x20
0x0000db98  mov      x4, #0
0x0000db9c  bl       #0xf0f0
0x0000dba0  mov      x29, x29
0x0000dba4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000dba8  mov      x21, x0
0x0000dbac  mov      x0, x26
0x0000dbb0  mov      x2, x21
0x0000dbb4  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000dbb8  mov      x0, x21
0x0000dbbc  bl       #0x55d78   ; CALL _objc_release
0x0000dbc0  b        #0xd878
0x0000dbc4  mov      x0, x20
0x0000dbc8  bl       #0x55d78   ; CALL _objc_release
0x0000dbcc  adrp     x8, #0x8e000
0x0000dbd0  ldr      x21, [x8, #0x958]   ; @CLASS NSString
0x0000dbd4  adrp     x0, #0x77000
0x0000dbd8  add      x0, x0, #0x948   ; STR "CHK_PERF_AT"
0x0000dbdc  bl       #0x17e20   ; CALL _L
0x0000dbe0  mov      x29, x29
0x0000dbe4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000dbe8  mov      x20, x0
0x0000dbec  adrp     x2, #0x77000
0x0000dbf0  add      x2, x2, #0x888   ; STR "start"
0x0000dbf4  mov      x0, x28
0x0000dbf8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000dbfc  mov      x29, x29
0x0000dc00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000dc04  mov      x22, x0
0x0000dc08  bl       #0xf6c0
0x0000dc0c  mov      x29, x29
0x0000dc10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000dc14  mov      x24, x0
0x0000dc18  stp      x0, x25, [sp]
0x0000dc1c  mov      x0, x21
0x0000dc20  mov      x2, x20
0x0000dc24  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000dc28  mov      x29, x29
0x0000dc2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000dc30  mov      x21, x0
0x0000dc34  mov      x0, x24
0x0000dc38  bl       #0x55d78   ; CALL _objc_release
0x0000dc3c  mov      x0, x22
0x0000dc40  bl       #0x55d78   ; CALL _objc_release
0x0000dc44  mov      x0, x20
0x0000dc48  bl       #0x55d78   ; CALL _objc_release
0x0000dc4c  adrp     x0, #0x77000
0x0000dc50  add      x0, x0, #0x8a8   ; STR "CHK_PERF_DRIVE"
0x0000dc54  bl       #0x17e20   ; CALL _L
0x0000dc58  mov      x29, x29
0x0000dc5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000dc60  mov      x20, x0
0x0000dc64  adrp     x1, #0x76000
0x0000dc68  add      x1, x1, #0x548   ; STR "info"
0x0000dc6c  str      x21, [sp, #0x40]
0x0000dc70  mov      x2, x21
0x0000dc74  mov      x3, #0
0x0000dc78  mov      x4, #0
0x0000dc7c  bl       #0xf0f0
0x0000dc80  mov      x29, x29
0x0000dc84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000dc88  mov      x21, x0
0x0000dc8c  mov      x0, x19
0x0000dc90  mov      x2, x21
0x0000dc94  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000dc98  mov      x0, x21
0x0000dc9c  bl       #0x55d78   ; CALL _objc_release
0x0000dca0  mov      x0, x20
0x0000dca4  bl       #0x55d78   ; CALL _objc_release
0x0000dca8  mov      x0, x28
0x0000dcac  bl       #0x55d84   ; CALL _objc_retain
0x0000dcb0  adrp     x2, #0x77000
0x0000dcb4  add      x2, x2, #0xba8   ; STR "availMinMB"
0x0000dcb8  mov      x0, x28
0x0000dcbc  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000dcc0  mov      x29, x29
0x0000dcc4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000dcc8  mov      x21, x0
0x0000dccc  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0000dcd0  mov      x20, x0
0x0000dcd4  adrp     x25, #0x75000
0x0000dcd8  add      x25, x25, #0xdc8   ; STR "bad"
0x0000dcdc  cbnz     x0, #0xdd0c
0x0000dce0  adrp     x2, #0x77000
0x0000dce4  add      x2, x2, #0xbc8   ; STR "sysFreeMinMB"
0x0000dce8  mov      x0, x28
0x0000dcec  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000dcf0  mov      x29, x29
0x0000dcf4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000dcf8  mov      x22, x0
0x0000dcfc  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0000dd00  mov      x20, x0
0x0000dd04  mov      x0, x22
0x0000dd08  bl       #0x55d78   ; CALL _objc_release
0x0000dd0c  mov      x0, x21
0x0000dd10  bl       #0x55d78   ; CALL _objc_release
0x0000dd14  adrp     x2, #0x77000
0x0000dd18  add      x2, x2, #0xd48   ; STR "tweaks"
0x0000dd1c  mov      x0, x28
0x0000dd20  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000dd24  mov      x29, x29
0x0000dd28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000dd2c  mov      x22, x0
0x0000dd30  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000dd34  mov      x21, x0
0x0000dd38  mov      x0, x22
0x0000dd3c  bl       #0x55d78   ; CALL _objc_release
0x0000dd40  adrp     x2, #0x77000
0x0000dd44  add      x2, x2, #0xc88   ; STR "thermalMax"
0x0000dd48  mov      x0, x28
0x0000dd4c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000dd50  mov      x29, x29
0x0000dd54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000dd58  mov      x22, x0
0x0000dd5c  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0000dd60  mov      x24, x0
0x0000dd64  mov      x0, x22
0x0000dd68  bl       #0x55d78   ; CALL _objc_release
0x0000dd6c  cmp      x24, #2
0x0000dd70  b.lt     #0xdd80
0x0000dd74  adrp     x0, #0x77000
0x0000dd78  add      x0, x0, #0xcc8   ; STR "CHK_PERF_HEAT_FIX"
0x0000dd7c  b        #0xddb8
0x0000dd80  adrp     x2, #0x77000
0x0000dd84  add      x2, x2, #0xce8   ; STR "lowPower"
0x0000dd88  mov      x0, x28
0x0000dd8c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000dd90  mov      x29, x29
0x0000dd94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000dd98  mov      x22, x0
0x0000dd9c  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x0000dda0  mov      x24, x0
0x0000dda4  mov      x0, x22
0x0000dda8  bl       #0x55d78   ; CALL _objc_release
0x0000ddac  cbz      w24, #0xe3b8
0x0000ddb0  adrp     x0, #0x76000
0x0000ddb4  add      x0, x0, #0x3c8   ; STR "CHK_LOWPOWER_FIX"
0x0000ddb8  bl       #0x17e20   ; CALL _L
0x0000ddbc  mov      x29, x29
0x0000ddc0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ddc4  str      x0, [sp, #0x50]
0x0000ddc8  mov      x24, x28
0x0000ddcc  mov      x0, x24
0x0000ddd0  bl       #0x55d78   ; CALL _objc_release
0x0000ddd4  adrp     x2, #0x77000
0x0000ddd8  add      x2, x2, #0x968   ; STR "frames"
0x0000dddc  mov      x0, x24
0x0000dde0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000dde4  mov      x29, x29
0x0000dde8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ddec  mov      x20, x0
0x0000ddf0  bl       #0x57880   ; CALL objc_msgSend$doubleValue
0x0000ddf4  mov      v8.16b, v0.16b
0x0000ddf8  mov      x0, x20
0x0000ddfc  bl       #0x55d78   ; CALL _objc_release
0x0000de00  adrp     x2, #0x77000
0x0000de04  add      x2, x2, #0x988   ; STR "late"
0x0000de08  mov      x0, x24
0x0000de0c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000de10  mov      x29, x29
0x0000de14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000de18  mov      x20, x0
0x0000de1c  bl       #0x57880   ; CALL objc_msgSend$doubleValue
0x0000de20  mov      v9.16b, v0.16b
0x0000de24  mov      x0, x20
0x0000de28  bl       #0x55d78   ; CALL _objc_release
0x0000de2c  adrp     x8, #0x65000
0x0000de30  ldr      d0, [x8, #0x638]
0x0000de34  fcmp     d8, d0
0x0000de38  b.pl     #0xdea0
0x0000de3c  adrp     x0, #0x77000
0x0000de40  add      x0, x0, #0x9a8   ; STR "CHK_PERF_SMOOTH"
0x0000de44  bl       #0x17e20   ; CALL _L
0x0000de48  mov      x29, x29
0x0000de4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000de50  mov      x20, x0
0x0000de54  adrp     x0, #0x77000
0x0000de58  add      x0, x0, #0x9c8   ; STR "CHK_PERF_FEW"
0x0000de5c  bl       #0x17e20   ; CALL _L
0x0000de60  mov      x29, x29
0x0000de64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000de68  mov      x22, x0
0x0000de6c  adrp     x1, #0x76000
0x0000de70  add      x1, x1, #0x548   ; STR "info"
0x0000de74  mov      x0, x20
0x0000de78  mov      x2, x22
0x0000de7c  mov      x3, #0
0x0000de80  mov      x4, #0
0x0000de84  bl       #0xf0f0
0x0000de88  mov      x29, x29
0x0000de8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000de90  mov      x26, x0
0x0000de94  adrp     x28, #0x75000
0x0000de98  add      x28, x28, #0xe08   ; STR "ok"
0x0000de9c  b        #0xdfe8
0x0000dea0  mov      x8, #0x4059000000000000
0x0000dea4  fmov     d0, x8
0x0000dea8  fmul     d0, d9, d0
0x0000deac  fdiv     d8, d0, d8
0x0000deb0  fmov     d0, #10.00000000
0x0000deb4  fcmp     d8, d0
0x0000deb8  adrp     x28, #0x75000
0x0000debc  add      x28, x28, #0xe28   ; STR "warn"
0x0000dec0  csel     x8, x28, x25, mi
0x0000dec4  fmov     d0, #3.00000000
0x0000dec8  fcmp     d8, d0
0x0000decc  adrp     x28, #0x75000
0x0000ded0  add      x28, x28, #0xe08   ; STR "ok"
0x0000ded4  csel     x21, x28, x8, mi
0x0000ded8  adrp     x8, #0x8e000
0x0000dedc  ldr      x20, [x8, #0x958]   ; @CLASS NSString
0x0000dee0  mov      x0, x21
0x0000dee4  bl       #0x55d84   ; CALL _objc_retain
0x0000dee8  adrp     x0, #0x77000
0x0000deec  add      x0, x0, #0x9e8   ; STR "CHK_PERF_SMOOTH_VALUE"
0x0000def0  bl       #0x17e20   ; CALL _L
0x0000def4  mov      x29, x29
0x0000def8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000defc  mov      x22, x0
0x0000df00  adrp     x2, #0x76000
0x0000df04  add      x2, x2, #0xc68   ; STR "fps"
0x0000df08  mov      x0, x24
0x0000df0c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000df10  mov      x29, x29
0x0000df14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000df18  mov      x24, x0
0x0000df1c  cmp      x0, #0
0x0000df20  adrp     x8, #0x75000
0x0000df24  add      x8, x8, #0x868   ; STR "?"
0x0000df28  csel     x25, x8, x0, eq
0x0000df2c  adrp     x2, #0x77000
0x0000df30  add      x2, x2, #0xa08   ; STR "worstMs"
0x0000df34  ldr      x0, [sp, #0x1a8]
0x0000df38  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000df3c  mov      x29, x29
0x0000df40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000df44  mov      x26, x0
0x0000df48  bl       #0x58ea0   ; CALL objc_msgSend$longValue
0x0000df4c  stp      x25, x0, [sp, #8]
0x0000df50  adrp     x25, #0x75000
0x0000df54  add      x25, x25, #0xdc8   ; STR "bad"
0x0000df58  str      d8, [sp]
0x0000df5c  mov      x0, x20
0x0000df60  mov      x2, x22
0x0000df64  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000df68  mov      x29, x29
0x0000df6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000df70  mov      x20, x0
0x0000df74  mov      x0, x26
0x0000df78  bl       #0x55d78   ; CALL _objc_release
0x0000df7c  mov      x0, x24
0x0000df80  ldr      x24, [sp, #0x1a8]
0x0000df84  bl       #0x55d78   ; CALL _objc_release
0x0000df88  mov      x0, x22
0x0000df8c  bl       #0x55d78   ; CALL _objc_release
0x0000df90  adrp     x0, #0x77000
0x0000df94  add      x0, x0, #0x9a8   ; STR "CHK_PERF_SMOOTH"
0x0000df98  bl       #0x17e20   ; CALL _L
0x0000df9c  mov      x29, x29
0x0000dfa0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000dfa4  mov      x22, x0
0x0000dfa8  mov      x0, x21
0x0000dfac  mov      x2, x28
0x0000dfb0  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0000dfb4  cmp      w0, #0
0x0000dfb8  ldr      x8, [sp, #0x50]
0x0000dfbc  csel     x3, xzr, x8, ne
0x0000dfc0  mov      x0, x22
0x0000dfc4  mov      x1, x21
0x0000dfc8  mov      x2, x20
0x0000dfcc  mov      x4, #0
0x0000dfd0  bl       #0xf0f0
0x0000dfd4  mov      x29, x29
0x0000dfd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000dfdc  mov      x26, x0
0x0000dfe0  mov      x0, x21
0x0000dfe4  bl       #0x55d78   ; CALL _objc_release
0x0000dfe8  mov      x0, x19
0x0000dfec  mov      x2, x26
0x0000dff0  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000dff4  mov      x0, x26
0x0000dff8  bl       #0x55d78   ; CALL _objc_release
0x0000dffc  mov      x0, x22
0x0000e000  bl       #0x55d78   ; CALL _objc_release
0x0000e004  mov      x0, x20
0x0000e008  bl       #0x55d78   ; CALL _objc_release
0x0000e00c  adrp     x2, #0x77000
0x0000e010  add      x2, x2, #0xa28   ; STR "hangs"
0x0000e014  mov      x0, x24
0x0000e018  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000e01c  mov      x29, x29
0x0000e020  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e024  mov      x21, x0
0x0000e028  bl       #0x58ea0   ; CALL objc_msgSend$longValue
0x0000e02c  mov      x20, x0
0x0000e030  mov      x0, x21
0x0000e034  bl       #0x55d78   ; CALL _objc_release
0x0000e038  adrp     x2, #0x77000
0x0000e03c  add      x2, x2, #0xa48   ; STR "freezes"
0x0000e040  mov      x0, x24
0x0000e044  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000e048  mov      x29, x29
0x0000e04c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e050  mov      x21, x0
0x0000e054  bl       #0x58ea0   ; CALL objc_msgSend$longValue
0x0000e058  mov      x22, x0
0x0000e05c  mov      x0, x21
0x0000e060  bl       #0x55d78   ; CALL _objc_release
0x0000e064  cmp      x20, #0xa
0x0000e068  ccmp     x22, #0, #0, le
0x0000e06c  adrp     x8, #0x75000
0x0000e070  add      x8, x8, #0xe28   ; STR "warn"
0x0000e074  csel     x8, x25, x8, ne
0x0000e078  cmp      x20, #0
0x0000e07c  csel     x0, x28, x8, eq
0x0000e080  str      x0, [sp, #0x48]
0x0000e084  bl       #0x55d84   ; CALL _objc_retain
0x0000e088  cbz      x20, #0xe164
0x0000e08c  adrp     x25, #0x8e000
0x0000e090  ldr      x21, [x25, #0x958]   ; @CLASS NSString
0x0000e094  adrp     x0, #0x77000
0x0000e098  add      x0, x0, #0xa68   ; STR "CHK_PERF_HANG_VALUE"
0x0000e09c  bl       #0x17e20   ; CALL _L
0x0000e0a0  mov      x29, x29
0x0000e0a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e0a8  mov      x22, x0
0x0000e0ac  adrp     x2, #0x77000
0x0000e0b0  add      x2, x2, #0xa88   ; STR "hangMaxMs"
0x0000e0b4  mov      x0, x24
0x0000e0b8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000e0bc  mov      x29, x29
0x0000e0c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e0c4  mov      x24, x0
0x0000e0c8  bl       #0x57880   ; CALL objc_msgSend$doubleValue
0x0000e0cc  adrp     x8, #0x65000
0x0000e0d0  ldr      d1, [x8, #0x640]
0x0000e0d4  fdiv     d0, d0, d1
0x0000e0d8  str      d0, [sp, #8]
0x0000e0dc  str      x20, [sp]
0x0000e0e0  mov      x0, x21
0x0000e0e4  mov      x2, x22
0x0000e0e8  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000e0ec  mov      x29, x29
0x0000e0f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e0f4  mov      x26, x0
0x0000e0f8  mov      x0, x24
0x0000e0fc  bl       #0x55d78   ; CALL _objc_release
0x0000e100  mov      x0, x22
0x0000e104  bl       #0x55d78   ; CALL _objc_release
0x0000e108  adrp     x0, #0x77000
0x0000e10c  add      x0, x0, #0xac8   ; STR "CHK_PERF_HANG"
0x0000e110  bl       #0x17e20   ; CALL _L
0x0000e114  mov      x29, x29
0x0000e118  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e11c  mov      x21, x0
0x0000e120  ldr      x24, [x25, #0x958]   ; @CLASS NSString
0x0000e124  adrp     x0, #0x77000
0x0000e128  add      x0, x0, #0xae8   ; STR "CHK_PERF_HANG_FIX"
0x0000e12c  bl       #0x17e20   ; CALL _L
0x0000e130  mov      x29, x29
0x0000e134  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e138  mov      x22, x0
0x0000e13c  ldr      x8, [sp, #0x50]
0x0000e140  str      x8, [sp]
0x0000e144  mov      x0, x24
0x0000e148  mov      x24, x26
0x0000e14c  mov      x2, x22
0x0000e150  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000e154  mov      x29, x29
0x0000e158  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e15c  mov      x26, x0
0x0000e160  b        #0xe198
0x0000e164  adrp     x0, #0x77000
0x0000e168  add      x0, x0, #0xaa8   ; STR "CHK_PERF_HANG_NONE"
0x0000e16c  bl       #0x17e20   ; CALL _L
0x0000e170  mov      x29, x29
0x0000e174  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e178  mov      x24, x0
0x0000e17c  adrp     x0, #0x77000
0x0000e180  add      x0, x0, #0xac8   ; STR "CHK_PERF_HANG"
0x0000e184  bl       #0x17e20   ; CALL _L
0x0000e188  mov      x29, x29
0x0000e18c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e190  mov      x21, x0
0x0000e194  mov      x26, #0
0x0000e198  mov      x0, x21
0x0000e19c  ldr      x1, [sp, #0x48]
0x0000e1a0  str      x24, [sp, #0x38]
0x0000e1a4  mov      x2, x24
0x0000e1a8  mov      x3, x26
0x0000e1ac  mov      x4, #0
0x0000e1b0  bl       #0xf0f0
0x0000e1b4  mov      x29, x29
0x0000e1b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e1bc  mov      x24, x0
0x0000e1c0  mov      x0, x19
0x0000e1c4  mov      x2, x24
0x0000e1c8  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000e1cc  mov      x0, x24
0x0000e1d0  bl       #0x55d78   ; CALL _objc_release
0x0000e1d4  cbz      x20, #0xe1e8
0x0000e1d8  mov      x0, x26
0x0000e1dc  bl       #0x55d78   ; CALL _objc_release
0x0000e1e0  mov      x0, x22
0x0000e1e4  bl       #0x55d78   ; CALL _objc_release
0x0000e1e8  mov      x0, x21
0x0000e1ec  bl       #0x55d78   ; CALL _objc_release
0x0000e1f0  adrp     x2, #0x77000
0x0000e1f4  add      x2, x2, #0xb08   ; STR "cpuAvg"
0x0000e1f8  ldr      x22, [sp, #0x1a8]
0x0000e1fc  mov      x0, x22
0x0000e200  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000e204  mov      x29, x29
0x0000e208  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e20c  mov      x20, x0
0x0000e210  bl       #0x55d78   ; CALL _objc_release
0x0000e214  adrp     x25, #0x75000
0x0000e218  add      x25, x25, #0xdc8   ; STR "bad"
0x0000e21c  cbz      x20, #0xe5dc
0x0000e220  adrp     x2, #0x77000
0x0000e224  add      x2, x2, #0xb08   ; STR "cpuAvg"
0x0000e228  mov      x0, x22
0x0000e22c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000e230  mov      x29, x29
0x0000e234  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e238  mov      x20, x0
0x0000e23c  bl       #0x58ea0   ; CALL objc_msgSend$longValue
0x0000e240  mov      x21, x0
0x0000e244  mov      x0, x20
0x0000e248  bl       #0x55d78   ; CALL _objc_release
0x0000e24c  cmp      x21, #0x3c
0x0000e250  adrp     x8, #0x75000
0x0000e254  add      x8, x8, #0xe28   ; STR "warn"
0x0000e258  csel     x8, x8, x25, lt
0x0000e25c  cmp      x21, #0x1e
0x0000e260  csel     x24, x28, x8, lt
0x0000e264  mov      x0, x24
0x0000e268  bl       #0x55d84   ; CALL _objc_retain
0x0000e26c  adrp     x0, #0x77000
0x0000e270  add      x0, x0, #0xb28   ; STR "CHK_PERF_CPU"
0x0000e274  bl       #0x17e20   ; CALL _L
0x0000e278  mov      x29, x29
0x0000e27c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e280  str      x0, [sp, #0x30]
0x0000e284  adrp     x8, #0x8e000
0x0000e288  ldr      x20, [x8, #0x958]   ; @CLASS NSString
0x0000e28c  adrp     x0, #0x77000
0x0000e290  add      x0, x0, #0xb48   ; STR "CHK_PERF_CPU_VALUE"
0x0000e294  bl       #0x17e20   ; CALL _L
0x0000e298  mov      x29, x29
0x0000e29c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e2a0  mov      x26, x0
0x0000e2a4  adrp     x2, #0x77000
0x0000e2a8  add      x2, x2, #0xb68   ; STR "cpuMax"
0x0000e2ac  mov      x0, x22
0x0000e2b0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000e2b4  mov      x29, x29
0x0000e2b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e2bc  mov      x22, x0
0x0000e2c0  bl       #0x58ea0   ; CALL objc_msgSend$longValue
0x0000e2c4  stp      x21, x0, [sp]
0x0000e2c8  mov      x0, x20
0x0000e2cc  str      x26, [sp, #0x20]
0x0000e2d0  mov      x2, x26
0x0000e2d4  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000e2d8  mov      x29, x29
0x0000e2dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e2e0  mov      x26, x0
0x0000e2e4  mov      x0, x24
0x0000e2e8  mov      x2, x28
0x0000e2ec  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0000e2f0  mov      x20, x0
0x0000e2f4  tbz      w0, #0, #0xe300
0x0000e2f8  mov      x21, #0
0x0000e2fc  b        #0xe318
0x0000e300  adrp     x0, #0x77000
0x0000e304  add      x0, x0, #0xb88   ; STR "CHK_PERF_CPU_FIX"
0x0000e308  bl       #0x17e20   ; CALL _L
0x0000e30c  mov      x29, x29
0x0000e310  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e314  mov      x21, x0
0x0000e318  ldr      x0, [sp, #0x30]
0x0000e31c  str      x24, [sp, #0x28]
0x0000e320  mov      x1, x24
0x0000e324  mov      x2, x26
0x0000e328  mov      x3, x21
0x0000e32c  mov      x4, #0
0x0000e330  bl       #0xf0f0
0x0000e334  mov      x29, x29
0x0000e338  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e33c  mov      x24, x0
0x0000e340  mov      x0, x19
0x0000e344  mov      x2, x24
0x0000e348  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000e34c  mov      x0, x24
0x0000e350  bl       #0x55d78   ; CALL _objc_release
0x0000e354  tbnz     w20, #0, #0xe360
0x0000e358  mov      x0, x21
0x0000e35c  bl       #0x55d78   ; CALL _objc_release
0x0000e360  mov      x0, x26
0x0000e364  bl       #0x55d78   ; CALL _objc_release
0x0000e368  mov      x0, x22
0x0000e36c  bl       #0x55d78   ; CALL _objc_release
0x0000e370  ldr      x0, [sp, #0x20]
0x0000e374  bl       #0x55d78   ; CALL _objc_release
0x0000e378  ldr      x0, [sp, #0x30]
0x0000e37c  bl       #0x55d78   ; CALL _objc_release
0x0000e380  adrp     x2, #0x77000
0x0000e384  add      x2, x2, #0xba8   ; STR "availMinMB"
0x0000e388  ldr      x24, [sp, #0x1a8]
0x0000e38c  mov      x0, x24
0x0000e390  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000e394  mov      x29, x29
0x0000e398  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e39c  mov      x20, x0
0x0000e3a0  bl       #0x58ea0   ; CALL objc_msgSend$longValue
0x0000e3a4  cbz      x0, #0xe434
0x0000e3a8  mov      x21, x0
0x0000e3ac  mov      x0, x20
0x0000e3b0  bl       #0x55d78   ; CALL _objc_release
0x0000e3b4  b        #0xe46c
0x0000e3b8  adrp     x2, #0x77000
0x0000e3bc  add      x2, x2, #0xe48   ; STR "memMB"
0x0000e3c0  mov      x0, x28
0x0000e3c4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000e3c8  mov      x29, x29
0x0000e3cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e3d0  mov      x22, x0
0x0000e3d4  bl       #0x55d78   ; CALL _objc_release
0x0000e3d8  mov      x24, x28
0x0000e3dc  cbz      x22, #0xefe8
0x0000e3e0  cmp      x20, #0xc7
0x0000e3e4  b.gt     #0xefe8
0x0000e3e8  adrp     x0, #0x77000
0x0000e3ec  add      x0, x0, #0xc68   ; STR "CHK_PERF_RAM_FIX"
0x0000e3f0  bl       #0x17e20   ; CALL _L
0x0000e3f4  mov      x29, x29
0x0000e3f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e3fc  str      x0, [sp, #0x50]
0x0000e400  b        #0xddcc
0x0000e404  adrp     x0, #0x76000
0x0000e408  add      x0, x0, #0xc28   ; STR "CHK_START_FRAMES_FIX"
0x0000e40c  bl       #0x17e20   ; CALL _L
0x0000e410  mov      x29, x29
0x0000e414  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e418  mov      x19, x0
0x0000e41c  adrp     x1, #0x75000
0x0000e420  add      x1, x1, #0xe28   ; STR "warn"
0x0000e424  ldr      x0, [sp, #0x190]
0x0000e428  mov      x2, x21
0x0000e42c  mov      x3, x19
0x0000e430  b        #0xd858
0x0000e434  adrp     x2, #0x77000
0x0000e438  add      x2, x2, #0xbc8   ; STR "sysFreeMinMB"
0x0000e43c  mov      x0, x24
0x0000e440  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000e444  mov      x29, x29
0x0000e448  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e44c  mov      x22, x0
0x0000e450  bl       #0x58ea0   ; CALL objc_msgSend$longValue
0x0000e454  mov      x21, x0
0x0000e458  mov      x0, x22
0x0000e45c  bl       #0x55d78   ; CALL _objc_release
0x0000e460  mov      x0, x20
0x0000e464  bl       #0x55d78   ; CALL _objc_release
0x0000e468  cbz      x21, #0xf038
0x0000e46c  cmp      x21, #0xc8
0x0000e470  adrp     x8, #0x75000
0x0000e474  add      x8, x8, #0xe28   ; STR "warn"
0x0000e478  adrp     x9, #0x75000
0x0000e47c  add      x9, x9, #0xe08   ; STR "ok"
0x0000e480  csel     x8, x8, x9, lo
0x0000e484  cmp      x21, #0x64
0x0000e488  csel     x20, x25, x8, lt
0x0000e48c  mov      x0, x20
0x0000e490  bl       #0x55d84   ; CALL _objc_retain
0x0000e494  adrp     x8, #0x8e000
0x0000e498  mov      x25, x24
0x0000e49c  ldr      x24, [x8, #0x958]   ; @CLASS NSString
0x0000e4a0  adrp     x0, #0x77000
0x0000e4a4  add      x0, x0, #0xbe8   ; STR "CHK_PERF_RAM_VALUE"
0x0000e4a8  bl       #0x17e20   ; CALL _L
0x0000e4ac  mov      x29, x29
0x0000e4b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e4b4  mov      x22, x0
0x0000e4b8  adrp     x2, #0x77000
0x0000e4bc  add      x2, x2, #0xc08   ; STR "memMaxMB"
0x0000e4c0  mov      x0, x25
0x0000e4c4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000e4c8  mov      x29, x29
0x0000e4cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e4d0  mov      x26, x0
0x0000e4d4  bl       #0x58ea0   ; CALL objc_msgSend$longValue
0x0000e4d8  stp      x0, x21, [sp]
0x0000e4dc  mov      x0, x24
0x0000e4e0  mov      x2, x22
0x0000e4e4  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000e4e8  mov      x29, x29
0x0000e4ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e4f0  mov      x21, x0
0x0000e4f4  mov      x0, x26
0x0000e4f8  bl       #0x55d78   ; CALL _objc_release
0x0000e4fc  mov      x0, x22
0x0000e500  bl       #0x55d78   ; CALL _objc_release
0x0000e504  adrp     x0, #0x77000
0x0000e508  add      x0, x0, #0xc48   ; STR "CHK_PERF_RAM"
0x0000e50c  bl       #0x17e20   ; CALL _L
0x0000e510  mov      x29, x29
0x0000e514  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e518  mov      x22, x0
0x0000e51c  adrp     x2, #0x75000
0x0000e520  add      x2, x2, #0xe28   ; STR "warn"
0x0000e524  mov      x0, x20
0x0000e528  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0000e52c  tbnz     w0, #0, #0xe544
0x0000e530  adrp     x2, #0x75000
0x0000e534  add      x2, x2, #0xdc8   ; STR "bad"
0x0000e538  mov      x0, x20
0x0000e53c  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0000e540  cbz      w0, #0xe564
0x0000e544  adrp     x0, #0x77000
0x0000e548  add      x0, x0, #0xc68   ; STR "CHK_PERF_RAM_FIX"
0x0000e54c  bl       #0x17e20   ; CALL _L
0x0000e550  mov      x29, x29
0x0000e554  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e558  mov      x26, x0
0x0000e55c  mov      w25, #1
0x0000e560  b        #0xe56c
0x0000e564  mov      w25, #0
0x0000e568  mov      x26, #0
0x0000e56c  mov      x0, x22
0x0000e570  mov      x1, x20
0x0000e574  mov      x2, x21
0x0000e578  mov      x3, x26
0x0000e57c  mov      x4, #0
0x0000e580  bl       #0xf0f0
0x0000e584  mov      x29, x29
0x0000e588  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e58c  mov      x24, x0
0x0000e590  mov      x0, x19
0x0000e594  mov      x2, x24
0x0000e598  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000e59c  mov      x0, x24
0x0000e5a0  bl       #0x55d78   ; CALL _objc_release
0x0000e5a4  cbz      w25, #0xe5b0
0x0000e5a8  mov      x0, x26
0x0000e5ac  bl       #0x55d78   ; CALL _objc_release
0x0000e5b0  mov      x0, x22
0x0000e5b4  bl       #0x55d78   ; CALL _objc_release
0x0000e5b8  mov      x0, x21
0x0000e5bc  bl       #0x55d78   ; CALL _objc_release
0x0000e5c0  mov      x0, x20
0x0000e5c4  bl       #0x55d78   ; CALL _objc_release
0x0000e5c8  ldr      x0, [sp, #0x28]
0x0000e5cc  bl       #0x55d78   ; CALL _objc_release
0x0000e5d0  adrp     x25, #0x75000
0x0000e5d4  add      x25, x25, #0xdc8   ; STR "bad"
0x0000e5d8  ldr      x22, [sp, #0x1a8]
0x0000e5dc  adrp     x2, #0x77000
0x0000e5e0  add      x2, x2, #0xc88   ; STR "thermalMax"
0x0000e5e4  mov      x0, x22
0x0000e5e8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000e5ec  mov      x29, x29
0x0000e5f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e5f4  mov      x21, x0
0x0000e5f8  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0000e5fc  str      x0, [sp, #0x30]
0x0000e600  mov      x0, x21
0x0000e604  bl       #0x55d78   ; CALL _objc_release
0x0000e608  adrp     x0, #0x77000
0x0000e60c  add      x0, x0, #0x2c8   ; STR "DIAG_THERMAL_NOMINAL"
0x0000e610  bl       #0x17e20   ; CALL _L
0x0000e614  mov      x29, x29
0x0000e618  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e61c  mov      x21, x0
0x0000e620  stur     x0, [x29, #-0x90]
0x0000e624  adrp     x0, #0x77000
0x0000e628  add      x0, x0, #0x2e8   ; STR "DIAG_THERMAL_FAIR"
0x0000e62c  bl       #0x17e20   ; CALL _L
0x0000e630  mov      x29, x29
0x0000e634  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e638  mov      x22, x0
0x0000e63c  stur     x0, [x29, #-0x88]
0x0000e640  adrp     x0, #0x77000
0x0000e644  add      x0, x0, #0x308   ; STR "DIAG_THERMAL_SERIOUS"
0x0000e648  bl       #0x17e20   ; CALL _L
0x0000e64c  mov      x29, x29
0x0000e650  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e654  mov      x24, x0
0x0000e658  stur     x0, [x29, #-0x80]
0x0000e65c  adrp     x0, #0x77000
0x0000e660  add      x0, x0, #0x328   ; STR "DIAG_THERMAL_CRITICAL"
0x0000e664  bl       #0x17e20   ; CALL _L
0x0000e668  mov      x29, x29
0x0000e66c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e670  mov      x26, x0
0x0000e674  stur     x0, [x29, #-0x78]
0x0000e678  adrp     x8, #0x8e000
0x0000e67c  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0000e680  sub      x2, x29, #0x90
0x0000e684  mov      w3, #4
0x0000e688  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0000e68c  mov      x29, x29
0x0000e690  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e694  adrp     x20, #0x75000
0x0000e698  add      x20, x20, #0xe08   ; STR "ok"
0x0000e69c  mov      x28, x0
0x0000e6a0  mov      x0, x26
0x0000e6a4  bl       #0x55d78   ; CALL _objc_release
0x0000e6a8  mov      x0, x24
0x0000e6ac  bl       #0x55d78   ; CALL _objc_release
0x0000e6b0  mov      x0, x22
0x0000e6b4  bl       #0x55d78   ; CALL _objc_release
0x0000e6b8  mov      x0, x21
0x0000e6bc  bl       #0x55d78   ; CALL _objc_release
0x0000e6c0  ldr      x22, [sp, #0x30]
0x0000e6c4  cmp      x22, #2
0x0000e6c8  adrp     x8, #0x75000
0x0000e6cc  add      x8, x8, #0xe28   ; STR "warn"
0x0000e6d0  csel     x8, x8, x20, eq
0x0000e6d4  csel     x24, x25, x8, gt
0x0000e6d8  mov      x0, x24
0x0000e6dc  bl       #0x55d84   ; CALL _objc_retain
0x0000e6e0  adrp     x0, #0x77000
0x0000e6e4  add      x0, x0, #0xca8   ; STR "CHK_PERF_HEAT"
0x0000e6e8  bl       #0x17e20   ; CALL _L
0x0000e6ec  mov      x29, x29
0x0000e6f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e6f4  mov      x21, x0
0x0000e6f8  bic      x8, x22, x22, asr #63
0x0000e6fc  cmp      x8, #3
0x0000e700  mov      w9, #3
0x0000e704  csel     x2, x8, x9, lt
0x0000e708  str      x28, [sp, #0x30]
0x0000e70c  mov      x0, x28
0x0000e710  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0000e714  mov      x29, x29
0x0000e718  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e71c  mov      x28, x0
0x0000e720  mov      x0, x24
0x0000e724  mov      x2, x20
0x0000e728  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0000e72c  mov      x22, x0
0x0000e730  tbz      w0, #0, #0xe73c
0x0000e734  mov      x26, #0
0x0000e738  b        #0xe754
0x0000e73c  adrp     x0, #0x77000
0x0000e740  add      x0, x0, #0xcc8   ; STR "CHK_PERF_HEAT_FIX"
0x0000e744  bl       #0x17e20   ; CALL _L
0x0000e748  mov      x29, x29
0x0000e74c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e750  mov      x26, x0
0x0000e754  mov      x0, x21
0x0000e758  str      x24, [sp, #0x28]
0x0000e75c  mov      x1, x24
0x0000e760  mov      x2, x28
0x0000e764  mov      x3, x26
0x0000e768  mov      x4, #0
0x0000e76c  bl       #0xf0f0
0x0000e770  mov      x29, x29
0x0000e774  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e778  mov      x24, x0
0x0000e77c  mov      x0, x19
0x0000e780  mov      x2, x24
0x0000e784  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000e788  mov      x0, x24
0x0000e78c  bl       #0x55d78   ; CALL _objc_release
0x0000e790  tbnz     w22, #0, #0xe79c
0x0000e794  mov      x0, x26
0x0000e798  bl       #0x55d78   ; CALL _objc_release
0x0000e79c  mov      x0, x28
0x0000e7a0  bl       #0x55d78   ; CALL _objc_release
0x0000e7a4  mov      x0, x21
0x0000e7a8  bl       #0x55d78   ; CALL _objc_release
0x0000e7ac  adrp     x2, #0x77000
0x0000e7b0  add      x2, x2, #0xce8   ; STR "lowPower"
0x0000e7b4  ldr      x24, [sp, #0x1a8]
0x0000e7b8  mov      x0, x24
0x0000e7bc  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000e7c0  mov      x29, x29
0x0000e7c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e7c8  mov      x20, x0
0x0000e7cc  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x0000e7d0  mov      x21, x0
0x0000e7d4  mov      x0, x20
0x0000e7d8  bl       #0x55d78   ; CALL _objc_release
0x0000e7dc  cbz      w21, #0xe880
0x0000e7e0  adrp     x0, #0x77000
0x0000e7e4  add      x0, x0, #0xd08   ; STR "CHK_PERF_LOWPOWER"
0x0000e7e8  bl       #0x17e20   ; CALL _L
0x0000e7ec  mov      x29, x29
0x0000e7f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e7f4  mov      x20, x0
0x0000e7f8  adrp     x0, #0x77000
0x0000e7fc  add      x0, x0, #0xd28   ; STR "CHK_PERF_LOWPOWER_ON"
0x0000e800  bl       #0x17e20   ; CALL _L
0x0000e804  mov      x29, x29
0x0000e808  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e80c  mov      x21, x0
0x0000e810  adrp     x0, #0x76000
0x0000e814  add      x0, x0, #0x3c8   ; STR "CHK_LOWPOWER_FIX"
0x0000e818  bl       #0x17e20   ; CALL _L
0x0000e81c  mov      x29, x29
0x0000e820  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e824  mov      x22, x0
0x0000e828  adrp     x1, #0x75000
0x0000e82c  add      x1, x1, #0xe28   ; STR "warn"
0x0000e830  mov      x0, x20
0x0000e834  mov      x2, x21
0x0000e838  mov      x3, x22
0x0000e83c  mov      x4, #0
0x0000e840  bl       #0xf0f0
0x0000e844  mov      x29, x29
0x0000e848  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e84c  mov      x24, x0
0x0000e850  mov      x0, x19
0x0000e854  mov      x2, x24
0x0000e858  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000e85c  mov      x0, x24
0x0000e860  ldr      x24, [sp, #0x1a8]
0x0000e864  bl       #0x55d78   ; CALL _objc_release
0x0000e868  mov      x0, x22
0x0000e86c  bl       #0x55d78   ; CALL _objc_release
0x0000e870  mov      x0, x21
0x0000e874  bl       #0x55d78   ; CALL _objc_release
0x0000e878  mov      x0, x20
0x0000e87c  bl       #0x55d78   ; CALL _objc_release
0x0000e880  adrp     x2, #0x77000
0x0000e884  add      x2, x2, #0xd48   ; STR "tweaks"
0x0000e888  mov      x0, x24
0x0000e88c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000e890  mov      x29, x29
0x0000e894  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e898  mov      x20, x0
0x0000e89c  adrp     x8, #0x8e000
0x0000e8a0  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0000e8a4  bl       #0x55d48   ; CALL _objc_opt_class
0x0000e8a8  mov      x1, x0
0x0000e8ac  mov      x0, x20
0x0000e8b0  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0000e8b4  tbz      w0, #0, #0xe8d8
0x0000e8b8  adrp     x2, #0x77000
0x0000e8bc  add      x2, x2, #0xd48   ; STR "tweaks"
0x0000e8c0  mov      x0, x24
0x0000e8c4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000e8c8  mov      x29, x29
0x0000e8cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e8d0  mov      x22, x0
0x0000e8d4  b        #0xe8e0
0x0000e8d8  adrp     x22, #0x74000
0x0000e8dc  ldr      x22, [x22, #0x1a0]   ; @GOT ___NSArray0__struct
0x0000e8e0  mov      x0, x20
0x0000e8e4  bl       #0x55d78   ; CALL _objc_release
0x0000e8e8  mov      x0, x22
0x0000e8ec  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000e8f0  cmp      x0, #5
0x0000e8f4  mov      w8, #5
0x0000e8f8  csel     x3, x0, x8, lo
0x0000e8fc  mov      x0, x22
0x0000e900  mov      x2, #0
0x0000e904  bl       #0x5d680   ; CALL objc_msgSend$subarrayWithRange:
0x0000e908  mov      x29, x29
0x0000e90c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e910  mov      x20, x0
0x0000e914  adrp     x2, #0x75000
0x0000e918  add      x2, x2, #0xb28   ; STR ", "
0x0000e91c  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x0000e920  mov      x29, x29
0x0000e924  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e928  mov      x26, x0
0x0000e92c  mov      x0, x20
0x0000e930  bl       #0x55d78   ; CALL _objc_release
0x0000e934  mov      x0, x22
0x0000e938  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000e93c  cmp      x0, #6
0x0000e940  b.lo     #0xe97c
0x0000e944  mov      x0, x22
0x0000e948  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000e94c  sub      x8, x0, #5
0x0000e950  str      x8, [sp]
0x0000e954  adrp     x2, #0x77000
0x0000e958  add      x2, x2, #0xd68   ; STR " +%lu"
0x0000e95c  mov      x0, x26
0x0000e960  bl       #0x5d400   ; CALL objc_msgSend$stringByAppendingFormat:
0x0000e964  mov      x29, x29
0x0000e968  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e96c  mov      x20, x0
0x0000e970  mov      x0, x26
0x0000e974  bl       #0x55d78   ; CALL _objc_release
0x0000e978  mov      x26, x20
0x0000e97c  mov      x0, x22
0x0000e980  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000e984  cmp      x0, #4
0x0000e988  b.hs     #0xe998
0x0000e98c  adrp     x20, #0x75000
0x0000e990  add      x20, x20, #0xe08   ; STR "ok"
0x0000e994  b        #0xe9b0
0x0000e998  mov      x0, x22
0x0000e99c  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000e9a0  cmp      x0, #8
0x0000e9a4  adrp     x8, #0x75000
0x0000e9a8  add      x8, x8, #0xe28   ; STR "warn"
0x0000e9ac  csel     x20, x8, x25, lo
0x0000e9b0  ldr      x25, [sp, #0x40]
0x0000e9b4  mov      x0, x20
0x0000e9b8  bl       #0x55d84   ; CALL _objc_retain
0x0000e9bc  mov      x0, x22
0x0000e9c0  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000e9c4  cbz      x0, #0xe9f8
0x0000e9c8  adrp     x8, #0x8e000
0x0000e9cc  ldr      x21, [x8, #0x958]   ; @CLASS NSString
0x0000e9d0  mov      x0, x22
0x0000e9d4  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000e9d8  stp      x0, x26, [sp]
0x0000e9dc  adrp     x2, #0x77000
0x0000e9e0  add      x2, x2, #0xd88   ; STR "%lu · %@"
0x0000e9e4  mov      x0, x21
0x0000e9e8  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000e9ec  mov      x29, x29
0x0000e9f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000e9f4  b        #0xea0c
0x0000e9f8  adrp     x0, #0x77000
0x0000e9fc  add      x0, x0, #0xda8   ; STR "CHK_PERF_TWEAKS_NONE"
0x0000ea00  bl       #0x17e20   ; CALL _L
0x0000ea04  mov      x29, x29
0x0000ea08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ea0c  mov      x24, x0
0x0000ea10  adrp     x0, #0x77000
0x0000ea14  add      x0, x0, #0xdc8   ; STR "CHK_PERF_TWEAKS"
0x0000ea18  bl       #0x17e20   ; CALL _L
0x0000ea1c  mov      x29, x29
0x0000ea20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ea24  mov      x28, x0
0x0000ea28  adrp     x2, #0x75000
0x0000ea2c  add      x2, x2, #0xe08   ; STR "ok"
0x0000ea30  mov      x0, x20
0x0000ea34  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0000ea38  mov      x21, x0
0x0000ea3c  str      x26, [sp, #0x20]
0x0000ea40  str      x20, [sp, #0x40]
0x0000ea44  tbz      w0, #0, #0xea50
0x0000ea48  mov      x26, #0
0x0000ea4c  b        #0xeaa0
0x0000ea50  adrp     x8, #0x8e000
0x0000ea54  mov      x26, x24
0x0000ea58  ldr      x24, [x8, #0x958]   ; @CLASS NSString
0x0000ea5c  adrp     x0, #0x77000
0x0000ea60  add      x0, x0, #0xde8   ; STR "CHK_PERF_TWEAKS_FIX"
0x0000ea64  bl       #0x17e20   ; CALL _L
0x0000ea68  mov      x29, x29
0x0000ea6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ea70  mov      x20, x0
0x0000ea74  mov      x0, x22
0x0000ea78  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000ea7c  str      x0, [sp]
0x0000ea80  mov      x0, x24
0x0000ea84  mov      x24, x26
0x0000ea88  str      x20, [sp, #0x18]
0x0000ea8c  mov      x2, x20
0x0000ea90  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000ea94  mov      x29, x29
0x0000ea98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ea9c  mov      x26, x0
0x0000eaa0  mov      x20, x28
0x0000eaa4  mov      x0, x28
0x0000eaa8  ldr      x1, [sp, #0x40]
0x0000eaac  mov      x28, x24
0x0000eab0  mov      x2, x24
0x0000eab4  mov      x3, x26
0x0000eab8  mov      x4, #0
0x0000eabc  bl       #0xf0f0
0x0000eac0  mov      x29, x29
0x0000eac4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000eac8  mov      x24, x0
0x0000eacc  mov      x0, x19
0x0000ead0  mov      x2, x24
0x0000ead4  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000ead8  mov      x0, x24
0x0000eadc  bl       #0x55d78   ; CALL _objc_release
0x0000eae0  tbnz     w21, #0, #0xeaf4
0x0000eae4  mov      x0, x26
0x0000eae8  bl       #0x55d78   ; CALL _objc_release
0x0000eaec  ldr      x0, [sp, #0x18]
0x0000eaf0  bl       #0x55d78   ; CALL _objc_release
0x0000eaf4  mov      x0, x20
0x0000eaf8  bl       #0x55d78   ; CALL _objc_release
0x0000eafc  mov      x0, x28
0x0000eb00  bl       #0x55d78   ; CALL _objc_release
0x0000eb04  ldr      x0, [sp, #0x40]
0x0000eb08  bl       #0x55d78   ; CALL _objc_release
0x0000eb0c  ldr      x0, [sp, #0x20]
0x0000eb10  bl       #0x55d78   ; CALL _objc_release
0x0000eb14  mov      x0, x22
0x0000eb18  bl       #0x55d78   ; CALL _objc_release
0x0000eb1c  ldr      x0, [sp, #0x28]
0x0000eb20  bl       #0x55d78   ; CALL _objc_release
0x0000eb24  ldr      x0, [sp, #0x30]
0x0000eb28  bl       #0x55d78   ; CALL _objc_release
0x0000eb2c  ldp      x20, x22, [sp, #0x48]
0x0000eb30  ldr      x21, [sp, #0x38]
0x0000eb34  mov      x0, x21
0x0000eb38  bl       #0x55d78   ; CALL _objc_release
0x0000eb3c  mov      x0, x20
0x0000eb40  bl       #0x55d78   ; CALL _objc_release
0x0000eb44  mov      x0, x22
0x0000eb48  bl       #0x55d78   ; CALL _objc_release
0x0000eb4c  mov      x0, x25
0x0000eb50  bl       #0x55d78   ; CALL _objc_release
0x0000eb54  adrp     x8, #0x8e000
0x0000eb58  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x0000eb5c  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x0000eb60  mov      x29, x29
0x0000eb64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000eb68  mov      x20, x0
0x0000eb6c  adrp     x21, #0x75000
0x0000eb70  add      x21, x21, #0x268   ; STR "/var/mobile/Documents/OmniCar.log"
0x0000eb74  mov      x2, x21
0x0000eb78  mov      x3, #0
0x0000eb7c  bl       #0x56700   ; CALL objc_msgSend$attributesOfItemAtPath:error:
0x0000eb80  mov      x29, x29
0x0000eb84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000eb88  mov      x22, x0
0x0000eb8c  bl       #0x57b60   ; CALL objc_msgSend$fileSize
0x0000eb90  mov      x24, x0
0x0000eb94  adrp     x2, #0x77000
0x0000eb98  add      x2, x2, #0xe88   ; STR ".old"
0x0000eb9c  mov      x0, x21
0x0000eba0  bl       #0x5d440   ; CALL objc_msgSend$stringByAppendingString:
0x0000eba4  mov      x29, x29
0x0000eba8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ebac  mov      x21, x0
0x0000ebb0  mov      x0, x20
0x0000ebb4  mov      x2, x21
0x0000ebb8  mov      x3, #0
0x0000ebbc  bl       #0x56700   ; CALL objc_msgSend$attributesOfItemAtPath:error:
0x0000ebc0  mov      x29, x29
0x0000ebc4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ebc8  mov      x26, x0
0x0000ebcc  bl       #0x57b60   ; CALL objc_msgSend$fileSize
0x0000ebd0  add      x24, x0, x24
0x0000ebd4  mov      x0, x26
0x0000ebd8  bl       #0x55d78   ; CALL _objc_release
0x0000ebdc  mov      x0, x21
0x0000ebe0  bl       #0x55d78   ; CALL _objc_release
0x0000ebe4  mov      x0, x22
0x0000ebe8  bl       #0x55d78   ; CALL _objc_release
0x0000ebec  mov      x0, x20
0x0000ebf0  bl       #0x55d78   ; CALL _objc_release
0x0000ebf4  cmp      x24, #0x100, lsl #12
0x0000ebf8  b.ls     #0xec88
0x0000ebfc  adrp     x0, #0x77000
0x0000ec00  add      x0, x0, #0xe08   ; STR "CHK_PERF_LOG"
0x0000ec04  bl       #0x17e20   ; CALL _L
0x0000ec08  mov      x29, x29
0x0000ec0c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ec10  mov      x20, x0
0x0000ec14  adrp     x8, #0x8e000
0x0000ec18  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0000ec1c  ucvtf    d0, x24, #0x14
0x0000ec20  str      d0, [sp]
0x0000ec24  adrp     x2, #0x77000
0x0000ec28  add      x2, x2, #0xe28   ; STR "%.1f MB"
0x0000ec2c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000ec30  mov      x29, x29
0x0000ec34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ec38  mov      x21, x0
0x0000ec3c  adrp     x1, #0x76000
0x0000ec40  add      x1, x1, #0x548   ; STR "info"
0x0000ec44  mov      x0, x20
0x0000ec48  mov      x2, x21
0x0000ec4c  mov      x3, #0
0x0000ec50  mov      x4, #0
0x0000ec54  bl       #0xf0f0
0x0000ec58  mov      x29, x29
0x0000ec5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ec60  mov      x22, x0
0x0000ec64  mov      x0, x19
0x0000ec68  mov      x2, x22
0x0000ec6c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000ec70  mov      x0, x22
0x0000ec74  bl       #0x55d78   ; CALL _objc_release
0x0000ec78  mov      x0, x21
0x0000ec7c  bl       #0x55d78   ; CALL _objc_release
0x0000ec80  mov      x0, x20
0x0000ec84  bl       #0x55d78   ; CALL _objc_release
0x0000ec88  adrp     x8, #0x8e000
0x0000ec8c  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x0000ec90  bl       #0x565c0   ; CALL objc_msgSend$array
0x0000ec94  mov      x29, x29
0x0000ec98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ec9c  mov      x20, x0
0x0000eca0  movi     v0.16b, #0
0x0000eca4  str      q0, [sp, #0x410]
0x0000eca8  str      q0, [sp, #0x420]
0x0000ecac  str      q0, [sp, #0x430]
0x0000ecb0  str      q0, [sp, #0x440]
0x0000ecb4  mov      x0, x19
0x0000ecb8  bl       #0x55d84   ; CALL _objc_retain
0x0000ecbc  add      x2, sp, #0x410
0x0000ecc0  add      x3, sp, #0x970
0x0000ecc4  mov      x0, x19
0x0000ecc8  mov      w4, #0x10
0x0000eccc  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000ecd0  cbz      x0, #0xed64
0x0000ecd4  mov      x26, x0
0x0000ecd8  ldr      x8, [sp, #0x420]
0x0000ecdc  ldr      x25, [x8]   ; @SEL "whatsNewNavigationController"
0x0000ece0  adrp     x21, #0x74000
0x0000ece4  ldr      x21, [x21, #0x1b8]   ; @GOT ___kCFBooleanTrue
0x0000ece8  adrp     x22, #0x77000
0x0000ecec  add      x22, x22, #0x728   ; STR "perf"
0x0000ecf0  mov      x28, #0
0x0000ecf4  ldr      x8, [sp, #0x420]
0x0000ecf8  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0000ecfc  cmp      x8, x25
0x0000ed00  b.eq     #0xed0c
0x0000ed04  mov      x0, x19
0x0000ed08  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0000ed0c  ldr      x8, [sp, #0x418]
0x0000ed10  ldr      x0, [x8, x28, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0000ed14  bl       #0x590a0   ; CALL objc_msgSend$mutableCopy
0x0000ed18  mov      x24, x0
0x0000ed1c  mov      x2, x21
0x0000ed20  mov      x3, x22
0x0000ed24  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0000ed28  mov      x0, x20
0x0000ed2c  mov      x2, x24
0x0000ed30  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0000ed34  mov      x0, x24
0x0000ed38  bl       #0x55d78   ; CALL _objc_release
0x0000ed3c  add      x28, x28, #1
0x0000ed40  cmp      x26, x28
0x0000ed44  b.ne     #0xecf4
0x0000ed48  add      x2, sp, #0x410
0x0000ed4c  add      x3, sp, #0x970
0x0000ed50  mov      x0, x19
0x0000ed54  mov      w4, #0x10
0x0000ed58  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000ed5c  mov      x26, x0
0x0000ed60  cbnz     x0, #0xecf0
0x0000ed64  mov      x0, x19
0x0000ed68  bl       #0x55d78   ; CALL _objc_release
0x0000ed6c  ldr      x0, [sp, #0x1a8]
0x0000ed70  bl       #0x55d78   ; CALL _objc_release
0x0000ed74  mov      x0, x19
0x0000ed78  bl       #0x55d78   ; CALL _objc_release
0x0000ed7c  str      x20, [sp, #0x488]
0x0000ed80  adrp     x19, #0x8e000
0x0000ed84  ldr      x0, [x19, #0x970]   ; @CLASS NSDictionary
0x0000ed88  add      x2, sp, #0x480
0x0000ed8c  add      x3, sp, #0x470
0x0000ed90  mov      w4, #2
0x0000ed94  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0000ed98  mov      x29, x29
0x0000ed9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000eda0  mov      x21, x0
0x0000eda4  str      x0, [sp, #0x4e0]
0x0000eda8  adrp     x8, #0x75000
0x0000edac  add      x8, x8, #0x4a8   ; STR "title"
0x0000edb0  str      x8, [sp, #0x450]
0x0000edb4  adrp     x0, #0x75000
0x0000edb8  add      x0, x0, #0xc48   ; STR "FEATURES_GROUP"
0x0000edbc  bl       #0x17e20   ; CALL _L
0x0000edc0  mov      x29, x29
0x0000edc4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000edc8  mov      x22, x0
0x0000edcc  adrp     x8, #0x76000
0x0000edd0  add      x8, x8, #0xc88   ; STR "checks"
0x0000edd4  str      x8, [sp, #0x458]
0x0000edd8  str      x0, [sp, #0x460]
0x0000eddc  ldr      x25, [sp, #0x1a0]
0x0000ede0  str      x25, [sp, #0x468]
0x0000ede4  ldr      x0, [x19, #0x970]   ; @CLASS NSDictionary
0x0000ede8  add      x2, sp, #0x460
0x0000edec  add      x3, sp, #0x450
0x0000edf0  mov      w4, #2
0x0000edf4  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0000edf8  mov      x29, x29
0x0000edfc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ee00  mov      x24, x0
0x0000ee04  str      x0, [sp, #0x4e8]
0x0000ee08  adrp     x8, #0x8e000
0x0000ee0c  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0000ee10  add      x2, sp, #0x4d0
0x0000ee14  mov      w3, #4
0x0000ee18  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0000ee1c  mov      x29, x29
0x0000ee20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ee24  mov      x19, x0
0x0000ee28  mov      x0, x24
0x0000ee2c  bl       #0x55d78   ; CALL _objc_release
0x0000ee30  mov      x0, x22
0x0000ee34  bl       #0x55d78   ; CALL _objc_release
0x0000ee38  mov      x0, x21
0x0000ee3c  bl       #0x55d78   ; CALL _objc_release
0x0000ee40  mov      x0, x20
0x0000ee44  bl       #0x55d78   ; CALL _objc_release
0x0000ee48  ldr      x0, [sp, #0x58]
0x0000ee4c  bl       #0x55d78   ; CALL _objc_release
0x0000ee50  ldr      x0, [sp, #0x60]
0x0000ee54  bl       #0x55d78   ; CALL _objc_release
0x0000ee58  ldr      x0, [sp, #0x68]
0x0000ee5c  bl       #0x55d78   ; CALL _objc_release
0x0000ee60  ldr      x0, [sp, #0x70]
0x0000ee64  bl       #0x55d78   ; CALL _objc_release
0x0000ee68  ldr      x0, [sp, #0x78]
0x0000ee6c  bl       #0x55d78   ; CALL _objc_release
0x0000ee70  ldr      x0, [sp, #0x170]
0x0000ee74  bl       #0x55d78   ; CALL _objc_release
0x0000ee78  ldr      x0, [sp, #0x190]
0x0000ee7c  bl       #0x55d78   ; CALL _objc_release
0x0000ee80  ldr      x0, [sp, #0x130]
0x0000ee84  bl       #0x55d78   ; CALL _objc_release
0x0000ee88  ldr      x0, [sp, #0x80]
0x0000ee8c  bl       #0x55d78   ; CALL _objc_release
0x0000ee90  mov      x0, x23
0x0000ee94  bl       #0x55d78   ; CALL _objc_release
0x0000ee98  mov      x0, x27
0x0000ee9c  bl       #0x55d78   ; CALL _objc_release
0x0000eea0  ldr      x0, [sp, #0x88]
0x0000eea4  bl       #0x55d78   ; CALL _objc_release
0x0000eea8  ldr      x0, [sp, #0x90]
0x0000eeac  bl       #0x55d78   ; CALL _objc_release
0x0000eeb0  ldr      x0, [sp, #0x98]
0x0000eeb4  bl       #0x55d78   ; CALL _objc_release
0x0000eeb8  mov      x0, x25
0x0000eebc  bl       #0x55d78   ; CALL _objc_release
0x0000eec0  ldr      x0, [sp, #0xa0]
0x0000eec4  bl       #0x55d78   ; CALL _objc_release
0x0000eec8  ldr      x0, [sp, #0xa8]
0x0000eecc  bl       #0x55d78   ; CALL _objc_release
0x0000eed0  ldr      x0, [sp, #0x160]
0x0000eed4  bl       #0x55d78   ; CALL _objc_release
0x0000eed8  ldr      x0, [sp, #0x178]
0x0000eedc  bl       #0x55d78   ; CALL _objc_release
0x0000eee0  ldr      x0, [sp, #0x158]
0x0000eee4  bl       #0x55d78   ; CALL _objc_release
0x0000eee8  ldr      x0, [sp, #0xb0]
0x0000eeec  bl       #0x55d78   ; CALL _objc_release
0x0000eef0  ldr      x0, [sp, #0xb8]
0x0000eef4  bl       #0x55d78   ; CALL _objc_release
0x0000eef8  ldr      x0, [sp, #0xc0]
0x0000eefc  bl       #0x55d78   ; CALL _objc_release
0x0000ef00  ldr      x0, [sp, #0xc8]
0x0000ef04  bl       #0x55d78   ; CALL _objc_release
0x0000ef08  ldr      x0, [sp, #0x138]
0x0000ef0c  bl       #0x55d78   ; CALL _objc_release
0x0000ef10  ldr      x0, [sp, #0x148]
0x0000ef14  bl       #0x55d78   ; CALL _objc_release
0x0000ef18  ldr      x0, [sp, #0x180]
0x0000ef1c  bl       #0x55d78   ; CALL _objc_release
0x0000ef20  ldr      x0, [sp, #0xd0]
0x0000ef24  bl       #0x55d78   ; CALL _objc_release
0x0000ef28  ldr      x0, [sp, #0xd8]
0x0000ef2c  bl       #0x55d78   ; CALL _objc_release
0x0000ef30  ldr      x0, [sp, #0xe0]
0x0000ef34  bl       #0x55d78   ; CALL _objc_release
0x0000ef38  ldr      x0, [sp, #0xe8]
0x0000ef3c  bl       #0x55d78   ; CALL _objc_release
0x0000ef40  ldr      x0, [sp, #0xf0]
0x0000ef44  bl       #0x55d78   ; CALL _objc_release
0x0000ef48  ldr      x0, [sp, #0xf8]
0x0000ef4c  bl       #0x55d78   ; CALL _objc_release
0x0000ef50  ldr      x0, [sp, #0x100]
0x0000ef54  bl       #0x55d78   ; CALL _objc_release
0x0000ef58  ldr      x0, [sp, #0x108]
0x0000ef5c  bl       #0x55d78   ; CALL _objc_release
0x0000ef60  ldr      x0, [sp, #0x168]
0x0000ef64  bl       #0x55d78   ; CALL _objc_release
0x0000ef68  ldr      x0, [sp, #0x198]
0x0000ef6c  bl       #0x55d78   ; CALL _objc_release
0x0000ef70  ldr      x0, [sp, #0x110]
0x0000ef74  bl       #0x55d78   ; CALL _objc_release
0x0000ef78  ldr      x0, [sp, #0x118]
0x0000ef7c  bl       #0x55d78   ; CALL _objc_release
0x0000ef80  ldr      x0, [sp, #0x150]
0x0000ef84  bl       #0x55d78   ; CALL _objc_release
0x0000ef88  ldr      x0, [sp, #0x120]
0x0000ef8c  bl       #0x55d78   ; CALL _objc_release
0x0000ef90  ldr      x0, [sp, #0x128]
0x0000ef94  bl       #0x55d78   ; CALL _objc_release
0x0000ef98  ldr      x0, [sp, #0x140]
0x0000ef9c  bl       #0x55d78   ; CALL _objc_release
0x0000efa0  ldr      x0, [sp, #0x188]
0x0000efa4  bl       #0x55d78   ; CALL _objc_release
0x0000efa8  ldur     x8, [x29, #-0x70]
0x0000efac  adrp     x9, #0x74000
0x0000efb0  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0000efb4  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0000efb8  cmp      x9, x8
0x0000efbc  b.ne     #0xf0ec
0x0000efc0  mov      x0, x19
0x0000efc4  add      sp, sp, #0xda0
0x0000efc8  ldp      x29, x30, [sp, #0x60]
0x0000efcc  ldp      x20, x19, [sp, #0x50]
0x0000efd0  ldp      x22, x21, [sp, #0x40]
0x0000efd4  ldp      x24, x23, [sp, #0x30]
0x0000efd8  ldp      x26, x25, [sp, #0x20]
0x0000efdc  ldp      x28, x27, [sp, #0x10]
0x0000efe0  ldp      d9, d8, [sp], #0x70
0x0000efe4  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0000efe8  cmp      x21, #4
0x0000efec  b.lo     #0xf0a0
0x0000eff0  adrp     x8, #0x8e000
0x0000eff4  ldr      x20, [x8, #0x958]   ; @CLASS NSString
0x0000eff8  adrp     x0, #0x77000
0x0000effc  add      x0, x0, #0xde8   ; STR "CHK_PERF_TWEAKS_FIX"
0x0000f000  bl       #0x17e20   ; CALL _L
0x0000f004  mov      x29, x29
0x0000f008  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f00c  mov      x22, x0
0x0000f010  str      x21, [sp]
0x0000f014  mov      x0, x20
0x0000f018  mov      x2, x22
0x0000f01c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000f020  mov      x29, x29
0x0000f024  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f028  str      x0, [sp, #0x50]
0x0000f02c  mov      x0, x22
0x0000f030  bl       #0x55d78   ; CALL _objc_release
0x0000f034  b        #0xddcc
0x0000f038  adrp     x8, #0x8e000
0x0000f03c  ldr      x20, [x8, #0x958]   ; @CLASS NSString
0x0000f040  adrp     x0, #0x77000
0x0000f044  add      x0, x0, #0xc28   ; STR "CHK_PERF_RAM_USED"
0x0000f048  bl       #0x17e20   ; CALL _L
0x0000f04c  mov      x29, x29
0x0000f050  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f054  mov      x22, x0
0x0000f058  adrp     x2, #0x77000
0x0000f05c  add      x2, x2, #0xc08   ; STR "memMaxMB"
0x0000f060  mov      x0, x24
0x0000f064  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000f068  mov      x29, x29
0x0000f06c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f070  mov      x26, x0
0x0000f074  bl       #0x58ea0   ; CALL objc_msgSend$longValue
0x0000f078  str      x0, [sp]
0x0000f07c  mov      x0, x20
0x0000f080  mov      x2, x22
0x0000f084  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000f088  mov      x29, x29
0x0000f08c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f090  mov      x21, x0
0x0000f094  adrp     x20, #0x76000
0x0000f098  add      x20, x20, #0x548   ; STR "info"
0x0000f09c  b        #0xe4f4
0x0000f0a0  adrp     x2, #0x77000
0x0000f0a4  add      x2, x2, #0xb08   ; STR "cpuAvg"
0x0000f0a8  mov      x0, x24
0x0000f0ac  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000f0b0  mov      x29, x29
0x0000f0b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f0b8  mov      x20, x0
0x0000f0bc  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0000f0c0  mov      x21, x0
0x0000f0c4  mov      x0, x20
0x0000f0c8  bl       #0x55d78   ; CALL _objc_release
0x0000f0cc  cmp      x21, #0x1e
0x0000f0d0  b.lt     #0xf0e0
0x0000f0d4  adrp     x0, #0x77000
0x0000f0d8  add      x0, x0, #0xb88   ; STR "CHK_PERF_CPU_FIX"
0x0000f0dc  b        #0xe3f0
0x0000f0e0  adrp     x0, #0x77000
0x0000f0e4  add      x0, x0, #0xe68   ; STR "CHK_PERF_GENERIC_FIX"
0x0000f0e8  b        #0xe3f0
0x0000f0ec  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0000f0f0  sub      sp, sp, #0x80
0x0000f0f4  stp      x24, x23, [sp, #0x40]
0x0000f0f8  stp      x22, x21, [sp, #0x50]
0x0000f0fc  stp      x20, x19, [sp, #0x60]
0x0000f100  stp      x29, x30, [sp, #0x70]
0x0000f104  add      x29, sp, #0x70
0x0000f108  mov      x20, x4
0x0000f10c  mov      x19, x3
0x0000f110  mov      x23, x2
0x0000f114  mov      x22, x1
0x0000f118  mov      x21, x0
0x0000f11c  adrp     x8, #0x74000
0x0000f120  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0000f124  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0000f128  str      x8, [sp, #0x38]
0x0000f12c  mov      x0, x3
0x0000f130  bl       #0x55d84   ; CALL _objc_retain
0x0000f134  mov      x0, x20
0x0000f138  bl       #0x55d84   ; CALL _objc_retain
0x0000f13c  adrp     x8, #0x75000
0x0000f140  add      x8, x8, #0x4a8   ; STR "title"
0x0000f144  adrp     x9, #0x76000
0x0000f148  add      x9, x9, #0xcc8   ; STR "status"
0x0000f14c  stp      x8, x9, [sp, #8]
0x0000f150  stp      x21, x22, [sp, #0x20]
0x0000f154  adrp     x8, #0x77000
0x0000f158  add      x8, x8, #0x188   ; STR "value"
0x0000f15c  adrp     x9, #0x75000
0x0000f160  add      x9, x9, #0xd28
0x0000f164  str      x8, [sp, #0x18]
0x0000f168  cmp      x23, #0
0x0000f16c  csel     x8, x9, x23, eq
0x0000f170  str      x8, [sp, #0x30]
0x0000f174  adrp     x8, #0x8e000
0x0000f178  ldr      x24, [x8, #0x970]   ; @CLASS NSDictionary
0x0000f17c  mov      x0, x23
0x0000f180  bl       #0x55d84   ; CALL _objc_retain
0x0000f184  mov      x0, x22
0x0000f188  bl       #0x55d84   ; CALL _objc_retain
0x0000f18c  mov      x0, x21
0x0000f190  bl       #0x55d84   ; CALL _objc_retain
0x0000f194  add      x2, sp, #0x20
0x0000f198  add      x3, sp, #8
0x0000f19c  mov      x0, x24
0x0000f1a0  mov      w4, #3
0x0000f1a4  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0000f1a8  mov      x29, x29
0x0000f1ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f1b0  mov      x24, x0
0x0000f1b4  mov      x0, x23
0x0000f1b8  bl       #0x55d78   ; CALL _objc_release
0x0000f1bc  mov      x0, x22
0x0000f1c0  bl       #0x55d78   ; CALL _objc_release
0x0000f1c4  mov      x0, x21
0x0000f1c8  bl       #0x55d78   ; CALL _objc_release
0x0000f1cc  mov      x0, x24
0x0000f1d0  bl       #0x590a0   ; CALL objc_msgSend$mutableCopy
0x0000f1d4  mov      x21, x0
0x0000f1d8  mov      x0, x24
0x0000f1dc  bl       #0x55d78   ; CALL _objc_release
0x0000f1e0  mov      x0, x19
0x0000f1e4  bl       #0x58c20   ; CALL objc_msgSend$length
0x0000f1e8  cbz      x0, #0xf200
0x0000f1ec  adrp     x3, #0x77000
0x0000f1f0  add      x3, x3, #0x628   ; STR "fix"
0x0000f1f4  mov      x0, x21
0x0000f1f8  mov      x2, x19
0x0000f1fc  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0000f200  cbz      x20, #0xf218
0x0000f204  adrp     x3, #0x77000
0x0000f208  add      x3, x3, #0x648   ; STR "action"
0x0000f20c  mov      x0, x21
0x0000f210  mov      x2, x20
0x0000f214  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0000f218  mov      x0, x20
0x0000f21c  bl       #0x55d78   ; CALL _objc_release
0x0000f220  mov      x0, x19
0x0000f224  bl       #0x55d78   ; CALL _objc_release
0x0000f228  ldr      x8, [sp, #0x38]
0x0000f22c  adrp     x9, #0x74000
0x0000f230  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0000f234  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0000f238  cmp      x9, x8
0x0000f23c  b.ne     #0xf25c
0x0000f240  mov      x0, x21
0x0000f244  ldp      x29, x30, [sp, #0x70]
0x0000f248  ldp      x20, x19, [sp, #0x60]
0x0000f24c  ldp      x22, x21, [sp, #0x50]
0x0000f250  ldp      x24, x23, [sp, #0x40]
0x0000f254  add      sp, sp, #0x80
0x0000f258  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0000f25c  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0000f260  stp      x28, x27, [sp, #-0x60]!
0x0000f264  stp      x26, x25, [sp, #0x10]
0x0000f268  stp      x24, x23, [sp, #0x20]
0x0000f26c  stp      x22, x21, [sp, #0x30]
0x0000f270  stp      x20, x19, [sp, #0x40]
0x0000f274  stp      x29, x30, [sp, #0x50]
0x0000f278  add      x29, sp, #0x50
0x0000f27c  sub      sp, sp, #0x500
0x0000f280  mov      x21, x2
0x0000f284  mov      x20, x1
0x0000f288  mov      x19, x0
0x0000f28c  adrp     x8, #0x74000
0x0000f290  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0000f294  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0000f298  stur     x8, [x29, #-0x60]
0x0000f29c  bl       #0x55d84   ; CALL _objc_retain
0x0000f2a0  mov      x0, x20
0x0000f2a4  bl       #0x55d84   ; CALL _objc_retain
0x0000f2a8  movi     v0.16b, #0
0x0000f2ac  stp      q0, q0, [sp, #0x30]
0x0000f2b0  stp      q0, q0, [sp, #0x50]
0x0000f2b4  add      x2, sp, #0x30
0x0000f2b8  add      x3, sp, #0x70
0x0000f2bc  str      x19, [sp, #0x18]
0x0000f2c0  mov      x0, x19
0x0000f2c4  mov      w4, #0x10
0x0000f2c8  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000f2cc  cbz      x0, #0xf668
0x0000f2d0  mov      x22, x0
0x0000f2d4  str      wzr, [sp, #0x24]
0x0000f2d8  str      xzr, [sp, #0x10]
0x0000f2dc  ldr      x8, [sp, #0x40]
0x0000f2e0  adrp     x23, #0x8e000
0x0000f2e4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0000f2e8  str      x8, [sp, #0x28]
0x0000f2ec  mov      x24, #0
0x0000f2f0  ldr      x8, [sp, #0x40]
0x0000f2f4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0000f2f8  ldr      x9, [sp, #0x28]
0x0000f2fc  cmp      x8, x9
0x0000f300  b.eq     #0xf30c
0x0000f304  ldr      x0, [sp, #0x18]
0x0000f308  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0000f30c  ldr      x8, [sp, #0x38]
0x0000f310  ldr      x25, [x8, x24, lsl #3]   ; @GOT ___objc_personality_v0
0x0000f314  mov      x0, x25
0x0000f318  bl       #0x55d84   ; CALL _objc_retain
0x0000f31c  mov      x0, x20
0x0000f320  bl       #0x55d84   ; CALL _objc_retain
0x0000f324  ldr      x19, [x23, #0x958]   ; @CLASS NSString
0x0000f328  adrp     x0, #0x75000
0x0000f32c  add      x0, x0, #0x388   ; STR "/Library/MobileSubstrate/DynamicLibraries"
0x0000f330  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0000f334  add      x1, sp, #0xf0
0x0000f338  bl       #0x4118
0x0000f33c  cbz      x0, #0xf35c
0x0000f340  mov      x2, x0
0x0000f344  ldr      x0, [x23, #0x958]   ; @CLASS NSString
0x0000f348  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0000f34c  mov      x29, x29
0x0000f350  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f354  mov      x27, x0
0x0000f358  b        #0xf360
0x0000f35c  mov      x27, #0
0x0000f360  stp      x27, x25, [sp]
0x0000f364  mov      x0, x19
0x0000f368  adrp     x2, #0x76000
0x0000f36c  add      x2, x2, #0x68   ; STR "%@/OmniCar%@.plist"
0x0000f370  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000f374  mov      x29, x29
0x0000f378  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f37c  mov      x26, x0
0x0000f380  mov      x0, x27
0x0000f384  bl       #0x55d78   ; CALL _objc_release
0x0000f388  adrp     x8, #0x8e000
0x0000f38c  ldr      x0, [x8, #0x9e8]   ; @CLASS NSData
0x0000f390  mov      x2, x26
0x0000f394  bl       #0x57560   ; CALL objc_msgSend$dataWithContentsOfFile:
0x0000f398  mov      x29, x29
0x0000f39c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f3a0  mov      x27, x0
0x0000f3a4  cbz      x0, #0xf3d4
0x0000f3a8  adrp     x8, #0x8e000
0x0000f3ac  ldr      x0, [x8, #0x9f0]   ; @CLASS NSPropertyListSerialization
0x0000f3b0  mov      x2, x27
0x0000f3b4  mov      x3, #0
0x0000f3b8  mov      x4, #0
0x0000f3bc  mov      x5, #0
0x0000f3c0  bl       #0x59ac0   ; CALL objc_msgSend$propertyListWithData:options:format:error:
0x0000f3c4  mov      x29, x29
0x0000f3c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f3cc  mov      x28, x0
0x0000f3d0  b        #0xf3d8
0x0000f3d4  mov      x28, #0
0x0000f3d8  adrp     x8, #0x8e000
0x0000f3dc  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x0000f3e0  bl       #0x55d48   ; CALL _objc_opt_class
0x0000f3e4  mov      x1, x0
0x0000f3e8  mov      x0, x28
0x0000f3ec  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0000f3f0  tbz      w0, #0, #0xf434
0x0000f3f4  mov      x0, x28
0x0000f3f8  adrp     x2, #0x77000
0x0000f3fc  add      x2, x2, #0x6a8   ; STR "Filter"
0x0000f400  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000f404  mov      x29, x29
0x0000f408  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f40c  mov      x23, x0
0x0000f410  adrp     x2, #0x77000
0x0000f414  add      x2, x2, #0x6c8   ; STR "Bundles"
0x0000f418  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000f41c  mov      x29, x29
0x0000f420  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f424  mov      x19, x0
0x0000f428  mov      x0, x23
0x0000f42c  bl       #0x55d78   ; CALL _objc_release
0x0000f430  b        #0xf438
0x0000f434  mov      x19, #0
0x0000f438  adrp     x8, #0x8e000
0x0000f43c  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0000f440  bl       #0x55d48   ; CALL _objc_opt_class
0x0000f444  mov      x1, x0
0x0000f448  mov      x0, x19
0x0000f44c  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0000f450  tbz      w0, #0, #0xf4c0
0x0000f454  mov      x0, x20
0x0000f458  adrp     x2, #0x76000
0x0000f45c  add      x2, x2, #0x128   ; STR "SpringBoard"
0x0000f460  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0000f464  cmp      w0, #0
0x0000f468  adrp     x8, #0x77000
0x0000f46c  add      x8, x8, #0x708   ; STR "com.apple.CarPlayApp"
0x0000f470  adrp     x9, #0x77000
0x0000f474  add      x9, x9, #0x6e8   ; STR "com.apple.springboard"
0x0000f478  csel     x2, x9, x8, ne
0x0000f47c  mov      x0, x19
0x0000f480  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0000f484  mov      x23, x0
0x0000f488  mov      x0, x19
0x0000f48c  bl       #0x55d78   ; CALL _objc_release
0x0000f490  mov      x0, x28
0x0000f494  bl       #0x55d78   ; CALL _objc_release
0x0000f498  mov      x0, x27
0x0000f49c  bl       #0x55d78   ; CALL _objc_release
0x0000f4a0  mov      x0, x26
0x0000f4a4  bl       #0x55d78   ; CALL _objc_release
0x0000f4a8  mov      x0, x20
0x0000f4ac  bl       #0x55d78   ; CALL _objc_release
0x0000f4b0  mov      x0, x25
0x0000f4b4  bl       #0x55d78   ; CALL _objc_release
0x0000f4b8  tbnz     w23, #0, #0xf4f0
0x0000f4bc  b        #0xf604
0x0000f4c0  mov      x0, x19
0x0000f4c4  bl       #0x55d78   ; CALL _objc_release
0x0000f4c8  mov      x0, x28
0x0000f4cc  bl       #0x55d78   ; CALL _objc_release
0x0000f4d0  mov      x0, x27
0x0000f4d4  bl       #0x55d78   ; CALL _objc_release
0x0000f4d8  mov      x0, x26
0x0000f4dc  bl       #0x55d78   ; CALL _objc_release
0x0000f4e0  mov      x0, x20
0x0000f4e4  bl       #0x55d78   ; CALL _objc_release
0x0000f4e8  mov      x0, x25
0x0000f4ec  bl       #0x55d78   ; CALL _objc_release
0x0000f4f0  mov      x0, x25
0x0000f4f4  mov      x1, x20
0x0000f4f8  bl       #0xf76c
0x0000f4fc  mov      x29, x29
0x0000f500  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f504  mov      x25, x0
0x0000f508  cbz      x0, #0xf578
0x0000f50c  mov      x0, x25
0x0000f510  adrp     x2, #0x77000
0x0000f514  add      x2, x2, #0x128   ; STR "version"
0x0000f518  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000f51c  mov      x29, x29
0x0000f520  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f524  mov      x19, x0
0x0000f528  adrp     x2, #0x75000
0x0000f52c  add      x2, x2, #0xc28   ; STR "1.0.3"
0x0000f530  bl       #0x587e0   ; CALL objc_msgSend$isEqual:
0x0000f534  cbz      w0, #0xf584
0x0000f538  mov      x0, x25
0x0000f53c  adrp     x2, #0x77000
0x0000f540  add      x2, x2, #0x668   ; STR "build"
0x0000f544  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000f548  mov      x29, x29
0x0000f54c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f550  mov      x23, x0
0x0000f554  adrp     x2, #0x77000
0x0000f558  add      x2, x2, #0x688   ; STR "fbebb21"
0x0000f55c  bl       #0x587e0   ; CALL objc_msgSend$isEqual:
0x0000f560  eor      w26, w0, #1
0x0000f564  mov      x0, x23
0x0000f568  bl       #0x55d78   ; CALL _objc_release
0x0000f56c  ldr      w8, [sp, #0x24]
0x0000f570  orr      w8, w26, w8
0x0000f574  b        #0xf588
0x0000f578  mov      w8, #1
0x0000f57c  str      w8, [sp, #0x10]
0x0000f580  b        #0xf5fc
0x0000f584  mov      w8, #1
0x0000f588  str      w8, [sp, #0x24]
0x0000f58c  mov      x0, x19
0x0000f590  bl       #0x55d78   ; CALL _objc_release
0x0000f594  ldr      x8, [x21]   ; @GOT ___objc_personality_v0
0x0000f598  cbz      x8, #0xf5d4
0x0000f59c  mov      x0, x25
0x0000f5a0  adrp     x2, #0x75000
0x0000f5a4  add      x2, x2, #0x968   ; STR "date"
0x0000f5a8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000f5ac  mov      x29, x29
0x0000f5b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f5b4  mov      x19, x0
0x0000f5b8  ldr      x2, [x21]   ; @GOT ___objc_personality_v0
0x0000f5bc  bl       #0x56f60   ; CALL objc_msgSend$compare:
0x0000f5c0  mov      x23, x0
0x0000f5c4  mov      x0, x19
0x0000f5c8  bl       #0x55d78   ; CALL _objc_release
0x0000f5cc  cmp      x23, #1
0x0000f5d0  b.ne     #0xf5f4
0x0000f5d4  mov      x0, x25
0x0000f5d8  adrp     x2, #0x75000
0x0000f5dc  add      x2, x2, #0x968   ; STR "date"
0x0000f5e0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000f5e4  mov      x29, x29
0x0000f5e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f5ec  bl       #0x55c94   ; CALL _objc_autorelease
0x0000f5f0  str      x0, [x21]
0x0000f5f4  mov      w8, #1
0x0000f5f8  str      w8, [sp, #0x14]
0x0000f5fc  mov      x0, x25
0x0000f600  bl       #0x55d78   ; CALL _objc_release
0x0000f604  adrp     x23, #0x8e000
0x0000f608  add      x24, x24, #1   ; CSTR "hatsNewNavigationController"
0x0000f60c  cmp      x22, x24
0x0000f610  b.ne     #0xf2f0
0x0000f614  add      x2, sp, #0x30
0x0000f618  add      x3, sp, #0x70
0x0000f61c  ldr      x0, [sp, #0x18]
0x0000f620  mov      w4, #0x10
0x0000f624  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000f628  mov      x22, x0
0x0000f62c  cbnz     x0, #0xf2ec
0x0000f630  ldr      w8, [sp, #0x14]
0x0000f634  tbz      w8, #0, #0xf668
0x0000f638  ldr      w8, [sp, #0x24]
0x0000f63c  ldr      w9, [sp, #0x10]
0x0000f640  orr      w8, w8, w9
0x0000f644  adrp     x9, #0x75000
0x0000f648  add      x9, x9, #0xe08   ; STR "ok"
0x0000f64c  adrp     x10, #0x76000
0x0000f650  add      x10, x10, #0x188   ; STR "old"
0x0000f654  tst      w8, #1
0x0000f658  csel     x19, x10, x9, ne
0x0000f65c  mov      x0, x19
0x0000f660  bl       #0x55d84   ; CALL _objc_retain
0x0000f664  b        #0xf670
0x0000f668  adrp     x19, #0x76000
0x0000f66c  add      x19, x19, #0x5e8   ; STR "none"
0x0000f670  mov      x0, x20
0x0000f674  bl       #0x55d78   ; CALL _objc_release
0x0000f678  ldr      x0, [sp, #0x18]
0x0000f67c  bl       #0x55d78   ; CALL _objc_release
0x0000f680  ldur     x8, [x29, #-0x60]
0x0000f684  adrp     x9, #0x74000
0x0000f688  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0000f68c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0000f690  cmp      x9, x8
0x0000f694  b.ne     #0xf6bc
0x0000f698  mov      x0, x19
0x0000f69c  add      sp, sp, #0x500
0x0000f6a0  ldp      x29, x30, [sp, #0x50]
0x0000f6a4  ldp      x20, x19, [sp, #0x40]
0x0000f6a8  ldp      x22, x21, [sp, #0x30]
0x0000f6ac  ldp      x24, x23, [sp, #0x20]
0x0000f6b0  ldp      x26, x25, [sp, #0x10]
0x0000f6b4  ldp      x28, x27, [sp], #0x60
0x0000f6b8  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0000f6bc  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0000f6c0  stp      x22, x21, [sp, #-0x30]!
0x0000f6c4  stp      x20, x19, [sp, #0x10]
0x0000f6c8  stp      x29, x30, [sp, #0x20]
0x0000f6cc  add      x29, sp, #0x20
0x0000f6d0  mov      x19, x0
0x0000f6d4  bl       #0x55d84   ; CALL _objc_retain
0x0000f6d8  adrp     x8, #0x8e000
0x0000f6dc  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x0000f6e0  bl       #0x55d48   ; CALL _objc_opt_class
0x0000f6e4  mov      x1, x0
0x0000f6e8  mov      x0, x19
0x0000f6ec  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0000f6f0  tbz      w0, #0, #0xf748
0x0000f6f4  adrp     x8, #0x8e000
0x0000f6f8  ldr      x0, [x8, #0x9f8]   ; @CLASS NSCalendar
0x0000f6fc  bl       #0x57420   ; CALL objc_msgSend$currentCalendar
0x0000f700  mov      x29, x29
0x0000f704  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f708  mov      x20, x0
0x0000f70c  mov      x2, x19
0x0000f710  bl       #0x58780   ; CALL objc_msgSend$isDateInToday:
0x0000f714  mov      x21, x0
0x0000f718  mov      x0, x20
0x0000f71c  bl       #0x55d78   ; CALL _objc_release
0x0000f720  adrp     x8, #0x8e000
0x0000f724  ldr      x0, [x8, #0x980]   ; @CLASS NSDateFormatter
0x0000f728  eor      w3, w21, #1
0x0000f72c  mov      x2, x19
0x0000f730  mov      w4, #1
0x0000f734  bl       #0x58de0   ; CALL objc_msgSend$localizedStringFromDate:dateStyle:timeStyle:
0x0000f738  mov      x29, x29
0x0000f73c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f740  mov      x20, x0
0x0000f744  b        #0xf750
0x0000f748  adrp     x20, #0x75000
0x0000f74c  add      x20, x20, #0x868   ; STR "?"
0x0000f750  mov      x0, x19
0x0000f754  bl       #0x55d78   ; CALL _objc_release
0x0000f758  mov      x0, x20
0x0000f75c  ldp      x29, x30, [sp, #0x20]
0x0000f760  ldp      x20, x19, [sp, #0x10]
0x0000f764  ldp      x22, x21, [sp], #0x30
0x0000f768  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0000f76c  sub      sp, sp, #0x40
0x0000f770  stp      x20, x19, [sp, #0x20]
0x0000f774  stp      x29, x30, [sp, #0x30]
0x0000f778  add      x29, sp, #0x30
0x0000f77c  adrp     x8, #0x8e000
0x0000f780  ldr      x8, [x8, #0x958]   ; @CLASS NSString
0x0000f784  stp      x0, x1, [sp, #8]
0x0000f788  adrp     x9, #0x77000
0x0000f78c  add      x9, x9, #0x7a8   ; STR "diagLoaded."
0x0000f790  str      x9, [sp]
0x0000f794  adrp     x2, #0x77000
0x0000f798  add      x2, x2, #0x788   ; STR "%@%@@%@"
0x0000f79c  mov      x0, x8
0x0000f7a0  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000f7a4  mov      x29, x29
0x0000f7a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f7ac  mov      x19, x0
0x0000f7b0  bl       #0x7a70
0x0000f7b4  mov      x29, x29
0x0000f7b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f7bc  mov      x20, x0
0x0000f7c0  mov      x0, x19
0x0000f7c4  bl       #0x55d78   ; CALL _objc_release
0x0000f7c8  adrp     x8, #0x8e000
0x0000f7cc  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x0000f7d0  bl       #0x55d48   ; CALL _objc_opt_class
0x0000f7d4  mov      x1, x0
0x0000f7d8  mov      x0, x20
0x0000f7dc  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0000f7e0  tst      w0, #1
0x0000f7e4  csel     x19, x20, xzr, ne
0x0000f7e8  mov      x0, x19
0x0000f7ec  bl       #0x55d84   ; CALL _objc_retain
0x0000f7f0  mov      x0, x20
0x0000f7f4  bl       #0x55d78   ; CALL _objc_release
0x0000f7f8  mov      x0, x19
0x0000f7fc  ldp      x29, x30, [sp, #0x30]
0x0000f800  ldp      x20, x19, [sp, #0x20]
0x0000f804  add      sp, sp, #0x40
0x0000f808  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0000f80c  stp      x22, x21, [sp, #-0x30]!
0x0000f810  stp      x20, x19, [sp, #0x10]
0x0000f814  stp      x29, x30, [sp, #0x20]
0x0000f818  add      x29, sp, #0x20
0x0000f81c  mov      x19, x0
0x0000f820  bl       #0x55d84   ; CALL _objc_retain
0x0000f824  adrp     x0, #0x77000
0x0000f828  add      x0, x0, #0x7c8   ; STR "LSApplicationWorkspace"
0x0000f82c  bl       #0x55af0   ; CALL _NSClassFromString
0x0000f830  mov      x20, x0
0x0000f834  adrp     x0, #0x77000
0x0000f838  add      x0, x0, #0x7e8   ; STR "defaultWorkspace"
0x0000f83c  bl       #0x55b08   ; CALL _NSSelectorFromString
0x0000f840  mov      x1, x0
0x0000f844  mov      x0, x20
0x0000f848  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x0000f84c  tbz      w0, #0, #0xf878
0x0000f850  adrp     x0, #0x77000
0x0000f854  add      x0, x0, #0x7e8   ; STR "defaultWorkspace"
0x0000f858  bl       #0x55b08   ; CALL _NSSelectorFromString
0x0000f85c  mov      x1, x0
0x0000f860  mov      x0, x20
0x0000f864  bl       #0x55d30   ; CALL _objc_msgSend
0x0000f868  mov      x29, x29
0x0000f86c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f870  mov      x20, x0
0x0000f874  b        #0xf87c
0x0000f878  mov      x20, #0
0x0000f87c  adrp     x0, #0x77000
0x0000f880  add      x0, x0, #0x808   ; STR "applicationIsInstalled:"
0x0000f884  bl       #0x55b08   ; CALL _NSSelectorFromString
0x0000f888  mov      x21, x0
0x0000f88c  mov      x0, x20
0x0000f890  mov      x1, x21
0x0000f894  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x0000f898  tbz      w0, #0, #0xf8b4
0x0000f89c  mov      x0, x20
0x0000f8a0  mov      x1, x21
0x0000f8a4  mov      x2, x19
0x0000f8a8  bl       #0x55d30   ; CALL _objc_msgSend
0x0000f8ac  mov      x21, x0
0x0000f8b0  b        #0xf8b8
0x0000f8b4  mov      w21, #1
0x0000f8b8  mov      x0, x20
0x0000f8bc  bl       #0x55d78   ; CALL _objc_release
0x0000f8c0  mov      x0, x19
0x0000f8c4  bl       #0x55d78   ; CALL _objc_release
0x0000f8c8  mov      x0, x21
0x0000f8cc  ldp      x29, x30, [sp, #0x20]
0x0000f8d0  ldp      x20, x19, [sp, #0x10]
0x0000f8d4  ldp      x22, x21, [sp], #0x30
0x0000f8d8  ret      

=== _OMCDiagSummary  va=0xf8dc size=904 types=
0x0000f8dc  stp      x28, x27, [sp, #-0x60]!
0x0000f8e0  stp      x26, x25, [sp, #0x10]
0x0000f8e4  stp      x24, x23, [sp, #0x20]
0x0000f8e8  stp      x22, x21, [sp, #0x30]
0x0000f8ec  stp      x20, x19, [sp, #0x40]
0x0000f8f0  stp      x29, x30, [sp, #0x50]
0x0000f8f4  add      x29, sp, #0x50
0x0000f8f8  sub      sp, sp, #0x200
0x0000f8fc  mov      x19, x0
0x0000f900  adrp     x8, #0x74000
0x0000f904  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0000f908  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0000f90c  stur     x8, [x29, #-0x60]
0x0000f910  bl       #0x55d84   ; CALL _objc_retain
0x0000f914  movi     v0.16b, #0
0x0000f918  stp      q0, q0, [sp, #0x80]
0x0000f91c  stp      q0, q0, [sp, #0xa0]
0x0000f920  add      x2, sp, #0x80
0x0000f924  sub      x3, x29, #0xe0
0x0000f928  str      x19, [sp, #0x20]
0x0000f92c  mov      x0, x19
0x0000f930  mov      w4, #0x10
0x0000f934  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000f938  str      x0, [sp, #0x30]
0x0000f93c  mov      x19, #0
0x0000f940  mov      x21, #0
0x0000f944  mov      x20, #0
0x0000f948  cbz      x0, #0xfab8
0x0000f94c  ldr      x8, [sp, #0x90]
0x0000f950  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0000f954  str      x8, [sp, #0x28]
0x0000f958  adrp     x22, #0x76000
0x0000f95c  add      x22, x22, #0xcc8   ; STR "status"
0x0000f960  adrp     x23, #0x75000
0x0000f964  add      x23, x23, #0xdc8   ; STR "bad"
0x0000f968  mov      x24, #0
0x0000f96c  ldr      x8, [sp, #0x90]
0x0000f970  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0000f974  ldr      x9, [sp, #0x28]
0x0000f978  cmp      x8, x9
0x0000f97c  b.eq     #0xf988
0x0000f980  ldr      x0, [sp, #0x20]
0x0000f984  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0000f988  ldr      x8, [sp, #0x88]
0x0000f98c  str      x24, [sp, #0x38]
0x0000f990  ldr      x0, [x8, x24, lsl #3]   ; @GOT ___objc_personality_v0
0x0000f994  movi     v0.16b, #0
0x0000f998  stp      q0, q0, [sp, #0x40]
0x0000f99c  stp      q0, q0, [sp, #0x60]
0x0000f9a0  adrp     x2, #0x76000
0x0000f9a4  add      x2, x2, #0xc88   ; STR "checks"
0x0000f9a8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000f9ac  mov      x29, x29
0x0000f9b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000f9b4  mov      x26, x0
0x0000f9b8  add      x2, sp, #0x40
0x0000f9bc  add      x3, sp, #0xf0
0x0000f9c0  mov      w4, #0x10
0x0000f9c4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000f9c8  cbz      x0, #0xfa84
0x0000f9cc  mov      x27, x0
0x0000f9d0  ldr      x8, [sp, #0x50]
0x0000f9d4  ldr      x25, [x8]   ; @GOT ___objc_personality_v0
0x0000f9d8  mov      x24, #0
0x0000f9dc  ldr      x8, [sp, #0x50]
0x0000f9e0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0000f9e4  cmp      x8, x25
0x0000f9e8  b.eq     #0xf9f4
0x0000f9ec  mov      x0, x26
0x0000f9f0  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0000f9f4  ldr      x8, [sp, #0x48]
0x0000f9f8  ldr      x0, [x8, x24, lsl #3]   ; @GOT ___objc_personality_v0
0x0000f9fc  mov      x2, x22
0x0000fa00  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000fa04  mov      x29, x29
0x0000fa08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000fa0c  mov      x28, x0
0x0000fa10  mov      x2, x23
0x0000fa14  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0000fa18  cbz      w0, #0xfa24
0x0000fa1c  add      x20, x20, #1
0x0000fa20  b        #0xfa54
0x0000fa24  mov      x0, x28
0x0000fa28  adrp     x2, #0x75000
0x0000fa2c  add      x2, x2, #0xe28   ; STR "warn"
0x0000fa30  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0000fa34  cbz      w0, #0xfa40
0x0000fa38  add      x21, x21, #1
0x0000fa3c  b        #0xfa54
0x0000fa40  mov      x0, x28
0x0000fa44  adrp     x2, #0x75000
0x0000fa48  add      x2, x2, #0xe08   ; STR "ok"
0x0000fa4c  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0000fa50  add      x19, x19, w0, uxtw
0x0000fa54  mov      x0, x28
0x0000fa58  bl       #0x55d78   ; CALL _objc_release
0x0000fa5c  add      x24, x24, #1
0x0000fa60  cmp      x27, x24
0x0000fa64  b.ne     #0xf9dc
0x0000fa68  add      x2, sp, #0x40
0x0000fa6c  add      x3, sp, #0xf0
0x0000fa70  mov      x0, x26
0x0000fa74  mov      w4, #0x10
0x0000fa78  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000fa7c  mov      x27, x0
0x0000fa80  cbnz     x0, #0xf9d8
0x0000fa84  mov      x0, x26
0x0000fa88  bl       #0x55d78   ; CALL _objc_release
0x0000fa8c  ldp      x8, x24, [sp, #0x30]
0x0000fa90  add      x24, x24, #1
0x0000fa94  cmp      x24, x8
0x0000fa98  b.ne     #0xf96c
0x0000fa9c  add      x2, sp, #0x80
0x0000faa0  sub      x3, x29, #0xe0
0x0000faa4  ldr      x0, [sp, #0x20]
0x0000faa8  mov      w4, #0x10
0x0000faac  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000fab0  str      x0, [sp, #0x30]
0x0000fab4  cbnz     x0, #0xf968
0x0000fab8  adrp     x27, #0x76000
0x0000fabc  add      x27, x27, #0xcc8   ; STR "status"
0x0000fac0  cmp      x21, #0
0x0000fac4  adrp     x8, #0x75000
0x0000fac8  add      x8, x8, #0xe28   ; STR "warn"
0x0000facc  adrp     x9, #0x75000
0x0000fad0  add      x9, x9, #0xe08   ; STR "ok"
0x0000fad4  csel     x8, x9, x8, eq
0x0000fad8  cmp      x20, #0
0x0000fadc  adrp     x9, #0x75000
0x0000fae0  add      x9, x9, #0xdc8   ; STR "bad"
0x0000fae4  csel     x26, x8, x9, eq
0x0000fae8  mov      x0, x26
0x0000faec  bl       #0x55d84   ; CALL _objc_retain
0x0000faf0  adrp     x24, #0x8e000
0x0000faf4  cbz      x20, #0xfb1c
0x0000faf8  ldr      x23, [x24, #0x958]   ; @CLASS NSString
0x0000fafc  adrp     x0, #0x76000
0x0000fb00  add      x0, x0, #0xce8   ; STR "CHK_SUM_BAD"
0x0000fb04  bl       #0x17e20   ; CALL _L
0x0000fb08  mov      x29, x29
0x0000fb0c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000fb10  mov      x22, x0
0x0000fb14  str      x20, [sp]
0x0000fb18  b        #0xfb40
0x0000fb1c  cbz      x21, #0xfc44
0x0000fb20  ldr      x23, [x24, #0x958]   ; @CLASS NSString
0x0000fb24  adrp     x0, #0x76000
0x0000fb28  add      x0, x0, #0xd08   ; STR "CHK_SUM_WARN"
0x0000fb2c  bl       #0x17e20   ; CALL _L
0x0000fb30  mov      x29, x29
0x0000fb34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000fb38  mov      x22, x0
0x0000fb3c  str      x21, [sp]
0x0000fb40  mov      x0, x23
0x0000fb44  mov      x2, x22
0x0000fb48  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000fb4c  mov      x29, x29
0x0000fb50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000fb54  mov      x25, x0
0x0000fb58  mov      x0, x22
0x0000fb5c  bl       #0x55d78   ; CALL _objc_release
0x0000fb60  ldr      x22, [x24, #0x958]   ; @CLASS NSString
0x0000fb64  adrp     x0, #0x76000
0x0000fb68  add      x0, x0, #0xd48   ; STR "CHK_SUM_COUNTS"
0x0000fb6c  bl       #0x17e20   ; CALL _L
0x0000fb70  mov      x29, x29
0x0000fb74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000fb78  mov      x23, x0
0x0000fb7c  stp      x21, x20, [sp, #8]
0x0000fb80  str      x19, [sp]
0x0000fb84  mov      x0, x22
0x0000fb88  mov      x2, x23
0x0000fb8c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0000fb90  mov      x29, x29
0x0000fb94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000fb98  mov      x24, x0
0x0000fb9c  mov      x0, x23
0x0000fba0  bl       #0x55d78   ; CALL _objc_release
0x0000fba4  adrp     x8, #0x75000
0x0000fba8  add      x8, x8, #0x4a8   ; STR "title"
0x0000fbac  stp      x27, x8, [sp, #0xc0]
0x0000fbb0  stp      x26, x25, [sp, #0xd8]
0x0000fbb4  adrp     x8, #0x76000
0x0000fbb8  add      x8, x8, #0xd68   ; STR "subtitle"
0x0000fbbc  str      x8, [sp, #0xd0]
0x0000fbc0  str      x24, [sp, #0xe8]
0x0000fbc4  adrp     x8, #0x8e000
0x0000fbc8  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x0000fbcc  add      x2, sp, #0xd8
0x0000fbd0  add      x3, sp, #0xc0
0x0000fbd4  mov      w4, #3
0x0000fbd8  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0000fbdc  mov      x29, x29
0x0000fbe0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000fbe4  mov      x22, x0
0x0000fbe8  mov      x0, x24
0x0000fbec  bl       #0x55d78   ; CALL _objc_release
0x0000fbf0  mov      x0, x25
0x0000fbf4  bl       #0x55d78   ; CALL _objc_release
0x0000fbf8  mov      x0, x26
0x0000fbfc  bl       #0x55d78   ; CALL _objc_release
0x0000fc00  ldr      x0, [sp, #0x20]
0x0000fc04  bl       #0x55d78   ; CALL _objc_release
0x0000fc08  ldur     x8, [x29, #-0x60]
0x0000fc0c  adrp     x9, #0x74000
0x0000fc10  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0000fc14  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0000fc18  cmp      x9, x8
0x0000fc1c  b.ne     #0xfc60
0x0000fc20  mov      x0, x22
0x0000fc24  add      sp, sp, #0x200
0x0000fc28  ldp      x29, x30, [sp, #0x50]
0x0000fc2c  ldp      x20, x19, [sp, #0x40]
0x0000fc30  ldp      x22, x21, [sp, #0x30]
0x0000fc34  ldp      x24, x23, [sp, #0x20]
0x0000fc38  ldp      x26, x25, [sp, #0x10]
0x0000fc3c  ldp      x28, x27, [sp], #0x60
0x0000fc40  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0000fc44  adrp     x0, #0x76000
0x0000fc48  add      x0, x0, #0xd28   ; STR "CHK_SUM_OK"
0x0000fc4c  bl       #0x17e20   ; CALL _L
0x0000fc50  mov      x29, x29
0x0000fc54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000fc58  mov      x25, x0
0x0000fc5c  b        #0xfb60
0x0000fc60  bl       #0x55b98   ; CALL ___stack_chk_fail

=== _OMCRespring  va=0xfc64 size=684 types=
0x0000fc64  sub      sp, sp, #0x160
0x0000fc68  stp      x28, x27, [sp, #0x100]
0x0000fc6c  stp      x26, x25, [sp, #0x110]
0x0000fc70  stp      x24, x23, [sp, #0x120]
0x0000fc74  stp      x22, x21, [sp, #0x130]
0x0000fc78  stp      x20, x19, [sp, #0x140]
0x0000fc7c  stp      x29, x30, [sp, #0x150]
0x0000fc80  add      x29, sp, #0x150
0x0000fc84  adrp     x8, #0x74000
0x0000fc88  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0000fc8c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0000fc90  stur     x8, [x29, #-0x58]
0x0000fc94  adrp     x0, #0x61000
0x0000fc98  add      x0, x0, #0xdd0   ; CSTR "/System/Library/PrivateFrameworks/FrontBoardServices.framework/FrontBoardServices"
0x0000fc9c  mov      w1, #1
0x0000fca0  bl       #0x55c34   ; CALL _dlopen
0x0000fca4  adrp     x0, #0x61000
0x0000fca8  add      x0, x0, #0xe22   ; CSTR "/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices"
0x0000fcac  mov      w1, #1
0x0000fcb0  bl       #0x55c34   ; CALL _dlopen
0x0000fcb4  adrp     x0, #0x76000
0x0000fcb8  add      x0, x0, #0xd88   ; STR "SBSRelaunchAction"
0x0000fcbc  bl       #0x55af0   ; CALL _NSClassFromString
0x0000fcc0  mov      x19, x0
0x0000fcc4  adrp     x0, #0x76000
0x0000fcc8  add      x0, x0, #0xda8   ; STR "FBSSystemService"
0x0000fccc  bl       #0x55af0   ; CALL _NSClassFromString
0x0000fcd0  cbz      x19, #0xfdd8
0x0000fcd4  mov      x20, x0
0x0000fcd8  cbz      x0, #0xfdd8
0x0000fcdc  adrp     x0, #0x76000
0x0000fce0  add      x0, x0, #0xdc8   ; STR "actionWithReason:options:targetURL:"
0x0000fce4  bl       #0x55b08   ; CALL _NSSelectorFromString
0x0000fce8  mov      x1, x0
0x0000fcec  adrp     x2, #0x76000
0x0000fcf0  add      x2, x2, #0xde8   ; STR "RestartRenderServer"
0x0000fcf4  mov      x0, x19
0x0000fcf8  mov      w3, #4
0x0000fcfc  mov      x4, #0
0x0000fd00  bl       #0x55d30   ; CALL _objc_msgSend
0x0000fd04  mov      x29, x29
0x0000fd08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000fd0c  mov      x19, x0
0x0000fd10  adrp     x0, #0x76000
0x0000fd14  add      x0, x0, #0xe08   ; STR "sharedService"
0x0000fd18  bl       #0x55b08   ; CALL _NSSelectorFromString
0x0000fd1c  mov      x1, x0
0x0000fd20  mov      x0, x20
0x0000fd24  bl       #0x55d30   ; CALL _objc_msgSend
0x0000fd28  mov      x29, x29
0x0000fd2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000fd30  mov      x20, x0
0x0000fd34  cbz      x19, #0xfdc8
0x0000fd38  cbz      x20, #0xfdc8
0x0000fd3c  adrp     x0, #0x76000
0x0000fd40  add      x0, x0, #0xe28   ; STR "sendActions:withResult:"
0x0000fd44  bl       #0x55b08   ; CALL _NSSelectorFromString
0x0000fd48  mov      x21, x0
0x0000fd4c  adrp     x8, #0x8e000
0x0000fd50  ldr      x0, [x8, #0x9b0]   ; @CLASS NSSet
0x0000fd54  mov      x2, x19
0x0000fd58  bl       #0x5c920   ; CALL objc_msgSend$setWithObject:
0x0000fd5c  mov      x29, x29
0x0000fd60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000fd64  mov      x22, x0
0x0000fd68  mov      x0, x20
0x0000fd6c  mov      x1, x21
0x0000fd70  mov      x2, x22
0x0000fd74  mov      x3, #0
0x0000fd78  bl       #0x55d30   ; CALL _objc_msgSend
0x0000fd7c  mov      x0, x22
0x0000fd80  bl       #0x55d78   ; CALL _objc_release
0x0000fd84  mov      x0, x20
0x0000fd88  bl       #0x55d78   ; CALL _objc_release
0x0000fd8c  ldur     x8, [x29, #-0x58]
0x0000fd90  adrp     x9, #0x74000
0x0000fd94  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0000fd98  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0000fd9c  cmp      x9, x8
0x0000fda0  b.ne     #0xff0c
0x0000fda4  mov      x0, x19
0x0000fda8  ldp      x29, x30, [sp, #0x150]
0x0000fdac  ldp      x20, x19, [sp, #0x140]
0x0000fdb0  ldp      x22, x21, [sp, #0x130]
0x0000fdb4  ldp      x24, x23, [sp, #0x120]
0x0000fdb8  ldp      x26, x25, [sp, #0x110]
0x0000fdbc  ldp      x28, x27, [sp, #0x100]
0x0000fdc0  add      sp, sp, #0x160
0x0000fdc4  b        #0x55d78   ; CALL _objc_release
0x0000fdc8  mov      x0, x20
0x0000fdcc  bl       #0x55d78   ; CALL _objc_release
0x0000fdd0  mov      x0, x19
0x0000fdd4  bl       #0x55d78   ; CALL _objc_release
0x0000fdd8  movi     v0.16b, #0
0x0000fddc  stp      q0, q0, [sp, #0x30]
0x0000fde0  stp      q0, q0, [sp, #0x10]
0x0000fde4  adrp     x0, #0x7f000
0x0000fde8  add      x0, x0, #0x888
0x0000fdec  add      x2, sp, #0x10
0x0000fdf0  add      x3, sp, #0x78
0x0000fdf4  mov      w4, #0x10
0x0000fdf8  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000fdfc  cbz      x0, #0xfed4
0x0000fe00  mov      x20, x0
0x0000fe04  ldr      x8, [sp, #0x20]
0x0000fe08  ldr      x24, [x8]   ; @SEL "whatsNewNavigationController"
0x0000fe0c  adrp     x25, #0x8e000
0x0000fe10  adrp     x19, #0x7f000
0x0000fe14  add      x19, x19, #0x888
0x0000fe18  mov      x26, #0
0x0000fe1c  ldr      x8, [sp, #0x20]
0x0000fe20  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0000fe24  cmp      x8, x24
0x0000fe28  b.eq     #0xfe34
0x0000fe2c  mov      x0, x19
0x0000fe30  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0000fe34  ldr      x8, [sp, #0x18]
0x0000fe38  ldr      x21, [x8, x26, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0000fe3c  ldr      x0, [x25, #0x990]   ; @CLASS NSFileManager
0x0000fe40  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x0000fe44  mov      x29, x29
0x0000fe48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000fe4c  mov      x22, x0
0x0000fe50  mov      x2, x21
0x0000fe54  bl       #0x58820   ; CALL objc_msgSend$isExecutableFileAtPath:
0x0000fe58  mov      x23, x0
0x0000fe5c  mov      x0, x22
0x0000fe60  bl       #0x55d78   ; CALL _objc_release
0x0000fe64  cbnz     w23, #0xfe94
0x0000fe68  add      x26, x26, #1
0x0000fe6c  cmp      x20, x26
0x0000fe70  b.ne     #0xfe1c
0x0000fe74  add      x2, sp, #0x10
0x0000fe78  add      x3, sp, #0x78
0x0000fe7c  mov      x0, x19
0x0000fe80  mov      w4, #0x10
0x0000fe84  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0000fe88  mov      x20, x0
0x0000fe8c  cbnz     x0, #0xfe18
0x0000fe90  b        #0xfed4
0x0000fe94  mov      x0, x21
0x0000fe98  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0000fe9c  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0000fea0  mov      x1, x0
0x0000fea4  adrp     x8, #0x61000
0x0000fea8  add      x8, x8, #0xf20   ; CSTR "-9"
0x0000feac  stp      x0, x8, [sp, #0x58]
0x0000feb0  adrp     x8, #0x61000
0x0000feb4  add      x8, x8, #0x8b7   ; CSTR "SpringBoard"
0x0000feb8  stp      x8, xzr, [sp, #0x68]
0x0000febc  add      x0, sp, #0xc
0x0000fec0  add      x4, sp, #0x58
0x0000fec4  mov      x2, #0
0x0000fec8  mov      x3, #0
0x0000fecc  mov      x5, #0
0x0000fed0  bl       #0x55e08   ; CALL _posix_spawn
0x0000fed4  ldur     x8, [x29, #-0x58]
0x0000fed8  adrp     x9, #0x74000
0x0000fedc  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0000fee0  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0000fee4  cmp      x9, x8
0x0000fee8  b.ne     #0xff0c
0x0000feec  ldp      x29, x30, [sp, #0x150]
0x0000fef0  ldp      x20, x19, [sp, #0x140]
0x0000fef4  ldp      x22, x21, [sp, #0x130]
0x0000fef8  ldp      x24, x23, [sp, #0x120]
0x0000fefc  ldp      x26, x25, [sp, #0x110]
0x0000ff00  ldp      x28, x27, [sp, #0x100]
0x0000ff04  add      sp, sp, #0x160
0x0000ff08  ret      
0x0000ff0c  bl       #0x55b98   ; CALL ___stack_chk_fail

=== _OMCShareReport  va=0xff10 size=3152 types=
0x0000ff10  stp      d9, d8, [sp, #-0x70]!
0x0000ff14  stp      x28, x27, [sp, #0x10]
0x0000ff18  stp      x26, x25, [sp, #0x20]
0x0000ff1c  stp      x24, x23, [sp, #0x30]
0x0000ff20  stp      x22, x21, [sp, #0x40]
0x0000ff24  stp      x20, x19, [sp, #0x50]
0x0000ff28  stp      x29, x30, [sp, #0x60]
0x0000ff2c  add      x29, sp, #0x60
0x0000ff30  sub      sp, sp, #0x450
0x0000ff34  mov      x19, x1
0x0000ff38  adrp     x8, #0x74000
0x0000ff3c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0000ff40  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0000ff44  stur     x8, [x29, #-0x70]
0x0000ff48  str      x0, [sp, #0x40]
0x0000ff4c  bl       #0x55d84   ; CALL _objc_retain
0x0000ff50  str      x19, [sp, #0x38]
0x0000ff54  mov      x0, x19
0x0000ff58  bl       #0x55d84   ; CALL _objc_retain
0x0000ff5c  adrp     x8, #0x8e000
0x0000ff60  ldr      x0, [x8, #0xa00]   ; @CLASS NSMutableString
0x0000ff64  bl       #0x5d3e0   ; CALL objc_msgSend$string
0x0000ff68  mov      x29, x29
0x0000ff6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ff70  mov      x21, x0
0x0000ff74  adrp     x8, #0x8e000
0x0000ff78  ldr      x0, [x8, #0x980]   ; @CLASS NSDateFormatter
0x0000ff7c  bl       #0x55d60   ; CALL _objc_opt_new
0x0000ff80  mov      x20, x0
0x0000ff84  adrp     x8, #0x8e000
0x0000ff88  ldr      x0, [x8, #0xa08]   ; @CLASS NSLocale
0x0000ff8c  adrp     x2, #0x77000
0x0000ff90  add      x2, x2, #0xea8   ; STR "en_US_POSIX"
0x0000ff94  bl       #0x58d60   ; CALL objc_msgSend$localeWithLocaleIdentifier:
0x0000ff98  mov      x29, x29
0x0000ff9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ffa0  mov      x19, x0
0x0000ffa4  mov      x0, x20
0x0000ffa8  mov      x2, x19
0x0000ffac  bl       #0x5b440   ; CALL objc_msgSend$setLocale:
0x0000ffb0  mov      x0, x19
0x0000ffb4  bl       #0x55d78   ; CALL _objc_release
0x0000ffb8  adrp     x2, #0x77000
0x0000ffbc  add      x2, x2, #0xec8   ; STR "yyyy-MM-dd HH:mm:ss"
0x0000ffc0  mov      x0, x20
0x0000ffc4  bl       #0x5ac40   ; CALL objc_msgSend$setDateFormat:
0x0000ffc8  adrp     x8, #0x8e000
0x0000ffcc  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x0000ffd0  bl       #0x575a0   ; CALL objc_msgSend$date
0x0000ffd4  mov      x29, x29
0x0000ffd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000ffdc  mov      x19, x0
0x0000ffe0  str      x20, [sp, #0x30]
0x0000ffe4  mov      x0, x20
0x0000ffe8  mov      x2, x19
0x0000ffec  bl       #0x5d500   ; CALL objc_msgSend$stringFromDate:
0x0000fff0  mov      x29, x29
0x0000fff4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000fff8  mov      x20, x0
0x0000fffc  str      x0, [sp]
0x00010000  adrp     x2, #0x77000
0x00010004  add      x2, x2, #0xee8   ; STR "OmniCar report %@\n"
0x00010008  mov      x0, x21
0x0001000c  bl       #0x56460   ; CALL objc_msgSend$appendFormat:
0x00010010  mov      x0, x20
0x00010014  bl       #0x55d78   ; CALL _objc_release
0x00010018  mov      x0, x19
0x0001001c  bl       #0x55d78   ; CALL _objc_release
0x00010020  bl       #0x18c50   ; CALL _OMCEnabled
0x00010024  adrp     x8, #0x77000
0x00010028  add      x8, x8, #0xf48   ; STR "off"
0x0001002c  adrp     x9, #0x77000
0x00010030  add      x9, x9, #0xf28   ; STR "on"
0x00010034  cmp      w0, #0
0x00010038  csel     x20, x9, x8, ne
0x0001003c  bl       #0x17a40   ; CALL _OMCLanguage
0x00010040  mov      x29, x29
0x00010044  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010048  mov      x19, x0
0x0001004c  stp      x20, x0, [sp]
0x00010050  adrp     x2, #0x77000
0x00010054  add      x2, x2, #0xf08   ; STR "master switch: %@, language: %@\n"
0x00010058  mov      x0, x21
0x0001005c  bl       #0x56460   ; CALL objc_msgSend$appendFormat:
0x00010060  mov      x0, x19
0x00010064  bl       #0x55d78   ; CALL _objc_release
0x00010068  bl       #0xa21c   ; CALL _OMCDiagChecks
0x0001006c  mov      x29, x29
0x00010070  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010074  mov      x22, x0
0x00010078  bl       #0xf8dc   ; CALL _OMCDiagSummary
0x0001007c  mov      x29, x29
0x00010080  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010084  mov      x20, x0
0x00010088  adrp     x2, #0x75000
0x0001008c  add      x2, x2, #0x4a8   ; STR "title"
0x00010090  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00010094  mov      x29, x29
0x00010098  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001009c  mov      x19, x0
0x000100a0  adrp     x2, #0x76000
0x000100a4  add      x2, x2, #0xd68   ; STR "subtitle"
0x000100a8  str      x20, [sp, #0x28]
0x000100ac  mov      x0, x20
0x000100b0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000100b4  mov      x29, x29
0x000100b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000100bc  mov      x20, x0
0x000100c0  stp      x19, x0, [sp]
0x000100c4  adrp     x2, #0x77000
0x000100c8  add      x2, x2, #0xf68   ; STR "\n== %@ (%@) ==\n"
0x000100cc  str      x21, [sp, #0x78]
0x000100d0  mov      x0, x21
0x000100d4  bl       #0x56460   ; CALL objc_msgSend$appendFormat:
0x000100d8  mov      x0, x20
0x000100dc  bl       #0x55d78   ; CALL _objc_release
0x000100e0  mov      x0, x19
0x000100e4  bl       #0x55d78   ; CALL _objc_release
0x000100e8  movi     v0.16b, #0
0x000100ec  stp      q0, q0, [sp, #0x1a0]
0x000100f0  stp      q0, q0, [sp, #0x180]
0x000100f4  mov      x0, x22
0x000100f8  bl       #0x55d84   ; CALL _objc_retain
0x000100fc  add      x2, sp, #0x180
0x00010100  sub      x3, x29, #0xf0
0x00010104  str      x22, [sp, #0x48]
0x00010108  mov      x0, x22
0x0001010c  mov      w4, #0x10
0x00010110  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00010114  str      x0, [sp, #0x58]
0x00010118  cbz      x0, #0x10398
0x0001011c  ldr      x8, [sp, #0x190]
0x00010120  ldr      x8, [x8]   ; @STR "off"
0x00010124  str      x8, [sp, #0x50]
0x00010128  adrp     x28, #0x77000
0x0001012c  add      x28, x28, #0x628   ; STR "fix"
0x00010130  mov      x19, #0
0x00010134  ldr      x8, [sp, #0x190]
0x00010138  ldr      x8, [x8]   ; @STR "off"
0x0001013c  ldr      x9, [sp, #0x50]
0x00010140  cmp      x8, x9
0x00010144  b.eq     #0x10150
0x00010148  ldr      x0, [sp, #0x48]
0x0001014c  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00010150  ldr      x8, [sp, #0x188]
0x00010154  str      x19, [sp, #0x60]
0x00010158  ldr      x19, [x8, x19, lsl #3]   ; @STR "off"
0x0001015c  mov      x0, x19
0x00010160  adrp     x2, #0x75000
0x00010164  add      x2, x2, #0x4a8   ; STR "title"
0x00010168  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001016c  mov      x29, x29
0x00010170  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010174  mov      x20, x0
0x00010178  str      x0, [sp]
0x0001017c  ldr      x0, [sp, #0x78]
0x00010180  adrp     x2, #0x78000
0x00010184  add      x2, x2, #8   ; STR "-- %@\n"
0x00010188  bl       #0x56460   ; CALL objc_msgSend$appendFormat:
0x0001018c  mov      x0, x20
0x00010190  bl       #0x55d78   ; CALL _objc_release
0x00010194  movi     v0.16b, #0
0x00010198  stp      q0, q0, [sp, #0x160]
0x0001019c  stp      q0, q0, [sp, #0x140]
0x000101a0  mov      x0, x19
0x000101a4  adrp     x2, #0x76000
0x000101a8  add      x2, x2, #0xc88   ; STR "checks"
0x000101ac  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000101b0  mov      x29, x29
0x000101b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000101b8  add      x2, sp, #0x140
0x000101bc  add      x3, sp, #0x340
0x000101c0  str      x0, [sp, #0x68]
0x000101c4  mov      w4, #0x10
0x000101c8  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000101cc  cbz      x0, #0x10364
0x000101d0  mov      x27, x0
0x000101d4  ldr      x8, [sp, #0x150]
0x000101d8  ldr      x8, [x8]   ; @STR "off"
0x000101dc  str      x8, [sp, #0x70]
0x000101e0  mov      x22, #0
0x000101e4  ldr      x8, [sp, #0x150]
0x000101e8  ldr      x8, [x8]   ; @STR "off"
0x000101ec  ldr      x9, [sp, #0x70]
0x000101f0  cmp      x8, x9
0x000101f4  b.eq     #0x10200
0x000101f8  ldr      x0, [sp, #0x68]
0x000101fc  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00010200  ldr      x8, [sp, #0x148]
0x00010204  ldr      x23, [x8, x22, lsl #3]   ; @STR "off"
0x00010208  mov      x0, x23
0x0001020c  adrp     x2, #0x76000
0x00010210  add      x2, x2, #0xcc8   ; STR "status"
0x00010214  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00010218  mov      x29, x29
0x0001021c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010220  mov      x26, x0
0x00010224  adrp     x0, #0x80000
0x00010228  add      x0, x0, #8
0x0001022c  mov      x2, x26
0x00010230  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00010234  mov      x29, x29
0x00010238  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001023c  mov      x25, x0
0x00010240  mov      x0, x23
0x00010244  adrp     x2, #0x75000
0x00010248  add      x2, x2, #0x4a8   ; STR "title"
0x0001024c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00010250  mov      x29, x29
0x00010254  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010258  mov      x20, x0
0x0001025c  mov      x0, x23
0x00010260  adrp     x2, #0x77000
0x00010264  add      x2, x2, #0x188   ; STR "value"
0x00010268  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001026c  mov      x29, x29
0x00010270  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010274  mov      x19, x0
0x00010278  mov      x0, x23
0x0001027c  mov      x2, x28
0x00010280  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00010284  mov      x29, x29
0x00010288  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001028c  mov      x24, x0
0x00010290  cbz      x0, #0x102f4
0x00010294  mov      x0, x23
0x00010298  mov      x2, x28
0x0001029c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000102a0  mov      x29, x29
0x000102a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000102a8  mov      x23, x0
0x000102ac  adrp     x0, #0x78000
0x000102b0  add      x0, x0, #0x48   ; STR " -> "
0x000102b4  mov      x2, x23
0x000102b8  bl       #0x5d440   ; CALL objc_msgSend$stringByAppendingString:
0x000102bc  mov      x29, x29
0x000102c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000102c4  mov      x21, x0
0x000102c8  stp      x19, x0, [sp, #0x10]
0x000102cc  stp      x25, x20, [sp]
0x000102d0  ldr      x0, [sp, #0x78]
0x000102d4  adrp     x2, #0x78000
0x000102d8  add      x2, x2, #0x28   ; STR "[%@] %@: %@%@\n"
0x000102dc  bl       #0x56460   ; CALL objc_msgSend$appendFormat:
0x000102e0  mov      x0, x21
0x000102e4  bl       #0x55d78   ; CALL _objc_release
0x000102e8  mov      x0, x23
0x000102ec  bl       #0x55d78   ; CALL _objc_release
0x000102f0  b        #0x10314
0x000102f4  adrp     x8, #0x75000
0x000102f8  add      x8, x8, #0xd28
0x000102fc  stp      x19, x8, [sp, #0x10]
0x00010300  stp      x25, x20, [sp]
0x00010304  ldr      x0, [sp, #0x78]
0x00010308  adrp     x2, #0x78000
0x0001030c  add      x2, x2, #0x28   ; STR "[%@] %@: %@%@\n"
0x00010310  bl       #0x56460   ; CALL objc_msgSend$appendFormat:
0x00010314  mov      x0, x24
0x00010318  bl       #0x55d78   ; CALL _objc_release
0x0001031c  mov      x0, x19
0x00010320  bl       #0x55d78   ; CALL _objc_release
0x00010324  mov      x0, x20
0x00010328  bl       #0x55d78   ; CALL _objc_release
0x0001032c  mov      x0, x25
0x00010330  bl       #0x55d78   ; CALL _objc_release
0x00010334  mov      x0, x26
0x00010338  bl       #0x55d78   ; CALL _objc_release
0x0001033c  add      x22, x22, #1
0x00010340  cmp      x27, x22
0x00010344  b.ne     #0x101e4
0x00010348  add      x2, sp, #0x140
0x0001034c  add      x3, sp, #0x340
0x00010350  ldr      x0, [sp, #0x68]
0x00010354  mov      w4, #0x10
0x00010358  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001035c  mov      x27, x0
0x00010360  cbnz     x0, #0x101e0
0x00010364  ldr      x0, [sp, #0x68]
0x00010368  bl       #0x55d78   ; CALL _objc_release
0x0001036c  ldp      x8, x19, [sp, #0x58]
0x00010370  add      x19, x19, #1
0x00010374  cmp      x19, x8
0x00010378  b.ne     #0x10134
0x0001037c  add      x2, sp, #0x180
0x00010380  sub      x3, x29, #0xf0
0x00010384  ldr      x0, [sp, #0x48]
0x00010388  mov      w4, #0x10
0x0001038c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00010390  str      x0, [sp, #0x58]
0x00010394  cbnz     x0, #0x10130
0x00010398  ldr      x0, [sp, #0x48]
0x0001039c  bl       #0x55d78   ; CALL _objc_release
0x000103a0  movi     v0.16b, #0
0x000103a4  stp      q0, q0, [sp, #0x120]
0x000103a8  stp      q0, q0, [sp, #0x100]
0x000103ac  bl       #0x7c78   ; CALL _OMCDiagSections
0x000103b0  mov      x29, x29
0x000103b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000103b8  add      x2, sp, #0x100
0x000103bc  add      x3, sp, #0x2c0
0x000103c0  str      x0, [sp, #0x58]
0x000103c4  mov      w4, #0x10
0x000103c8  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000103cc  str      x0, [sp, #0x68]
0x000103d0  cbz      x0, #0x105e0
0x000103d4  ldr      x8, [sp, #0x110]
0x000103d8  ldr      x8, [x8]
0x000103dc  str      x8, [sp, #0x60]
0x000103e0  adrp     x27, #0x77000
0x000103e4  add      x27, x27, #0x168   ; STR "label"
0x000103e8  adrp     x28, #0x77000
0x000103ec  add      x28, x28, #0x188   ; STR "value"
0x000103f0  adrp     x26, #0x78000
0x000103f4  add      x26, x26, #0x88   ; STR "%@: %@\n"
0x000103f8  mov      x25, #0
0x000103fc  ldr      x8, [sp, #0x110]
0x00010400  ldr      x8, [x8]
0x00010404  ldr      x9, [sp, #0x60]
0x00010408  cmp      x8, x9
0x0001040c  b.eq     #0x10418
0x00010410  ldr      x0, [sp, #0x58]
0x00010414  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00010418  ldr      x8, [sp, #0x108]
0x0001041c  ldr      x19, [x8, x25, lsl #3]
0x00010420  mov      x0, x19
0x00010424  adrp     x2, #0x75000
0x00010428  add      x2, x2, #0x4a8   ; STR "title"
0x0001042c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00010430  mov      x29, x29
0x00010434  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010438  mov      x20, x0
0x0001043c  str      x0, [sp]
0x00010440  ldr      x0, [sp, #0x78]
0x00010444  adrp     x2, #0x78000
0x00010448  add      x2, x2, #0x68   ; STR "\n== %@ ==\n"
0x0001044c  bl       #0x56460   ; CALL objc_msgSend$appendFormat:
0x00010450  mov      x0, x20
0x00010454  bl       #0x55d78   ; CALL _objc_release
0x00010458  movi     v0.16b, #0
0x0001045c  stp      q0, q0, [sp, #0xe0]
0x00010460  stp      q0, q0, [sp, #0xc0]
0x00010464  str      x19, [sp, #0x70]
0x00010468  mov      x0, x19
0x0001046c  adrp     x2, #0x75000
0x00010470  add      x2, x2, #0x4e8   ; STR "rows"
0x00010474  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00010478  mov      x29, x29
0x0001047c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010480  mov      x20, x0
0x00010484  add      x2, sp, #0xc0
0x00010488  add      x3, sp, #0x240
0x0001048c  mov      w4, #0x10
0x00010490  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00010494  cbz      x0, #0x10540
0x00010498  mov      x22, x0
0x0001049c  ldr      x8, [sp, #0xd0]
0x000104a0  ldr      x24, [x8]
0x000104a4  mov      x19, #0
0x000104a8  ldr      x8, [sp, #0xd0]
0x000104ac  ldr      x8, [x8]
0x000104b0  cmp      x8, x24
0x000104b4  b.eq     #0x104c0
0x000104b8  mov      x0, x20
0x000104bc  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x000104c0  ldr      x8, [sp, #0xc8]
0x000104c4  ldr      x21, [x8, x19, lsl #3]
0x000104c8  mov      x0, x21
0x000104cc  mov      x2, x27
0x000104d0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000104d4  mov      x29, x29
0x000104d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000104dc  mov      x23, x0
0x000104e0  mov      x0, x21
0x000104e4  mov      x2, x28
0x000104e8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000104ec  mov      x29, x29
0x000104f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000104f4  mov      x21, x0
0x000104f8  stp      x23, x0, [sp]
0x000104fc  ldr      x0, [sp, #0x78]
0x00010500  mov      x2, x26
0x00010504  bl       #0x56460   ; CALL objc_msgSend$appendFormat:
0x00010508  mov      x0, x21
0x0001050c  bl       #0x55d78   ; CALL _objc_release
0x00010510  mov      x0, x23
0x00010514  bl       #0x55d78   ; CALL _objc_release
0x00010518  add      x19, x19, #1
0x0001051c  cmp      x22, x19
0x00010520  b.ne     #0x104a8
0x00010524  add      x2, sp, #0xc0
0x00010528  add      x3, sp, #0x240
0x0001052c  mov      x0, x20
0x00010530  mov      w4, #0x10
0x00010534  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00010538  mov      x22, x0
0x0001053c  cbnz     x0, #0x104a4
0x00010540  mov      x0, x20
0x00010544  bl       #0x55d78   ; CALL _objc_release
0x00010548  ldr      x22, [sp, #0x70]
0x0001054c  mov      x0, x22
0x00010550  adrp     x19, #0x75000
0x00010554  add      x19, x19, #0x988   ; STR "footer"
0x00010558  mov      x2, x19
0x0001055c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00010560  mov      x29, x29
0x00010564  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010568  mov      x20, x0
0x0001056c  bl       #0x58c20   ; CALL objc_msgSend$length
0x00010570  mov      x21, x0
0x00010574  mov      x0, x20
0x00010578  bl       #0x55d78   ; CALL _objc_release
0x0001057c  cbz      x21, #0x105b4
0x00010580  mov      x0, x22
0x00010584  mov      x2, x19
0x00010588  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001058c  mov      x29, x29
0x00010590  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010594  mov      x19, x0
0x00010598  str      x0, [sp]
0x0001059c  ldr      x0, [sp, #0x78]
0x000105a0  adrp     x2, #0x78000
0x000105a4  add      x2, x2, #0xa8   ; STR "(%@)\n"
0x000105a8  bl       #0x56460   ; CALL objc_msgSend$appendFormat:
0x000105ac  mov      x0, x19
0x000105b0  bl       #0x55d78   ; CALL _objc_release
0x000105b4  add      x25, x25, #1
0x000105b8  ldr      x8, [sp, #0x68]
0x000105bc  cmp      x25, x8
0x000105c0  b.ne     #0x103fc
0x000105c4  add      x2, sp, #0x100
0x000105c8  add      x3, sp, #0x2c0
0x000105cc  ldr      x0, [sp, #0x58]
0x000105d0  mov      w4, #0x10
0x000105d4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000105d8  str      x0, [sp, #0x68]
0x000105dc  cbnz     x0, #0x103f8
0x000105e0  ldr      x0, [sp, #0x58]
0x000105e4  bl       #0x55d78   ; CALL _objc_release
0x000105e8  adrp     x0, #0x75000
0x000105ec  add      x0, x0, #0x5e8   ; STR "diagCar"
0x000105f0  bl       #0x7a70
0x000105f4  mov      x29, x29
0x000105f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000105fc  mov      x20, x0
0x00010600  adrp     x19, #0x8e000
0x00010604  ldr      x0, [x19, #0x970]   ; @CLASS NSDictionary
0x00010608  bl       #0x55d48   ; CALL _objc_opt_class
0x0001060c  mov      x1, x0
0x00010610  mov      x0, x20
0x00010614  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00010618  tbz      w0, #0, #0x10630
0x0001061c  str      x20, [sp]
0x00010620  adrp     x2, #0x78000
0x00010624  add      x2, x2, #0xc8   ; STR "\n== Car (raw) ==\n%@\n"
0x00010628  ldr      x0, [sp, #0x78]
0x0001062c  bl       #0x56460   ; CALL objc_msgSend$appendFormat:
0x00010630  adrp     x0, #0x77000
0x00010634  add      x0, x0, #0x868   ; STR "diagPerf"
0x00010638  bl       #0x7a70
0x0001063c  mov      x29, x29
0x00010640  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010644  mov      x21, x0
0x00010648  ldr      x0, [x19, #0x970]   ; @CLASS NSDictionary
0x0001064c  bl       #0x55d48   ; CALL _objc_opt_class
0x00010650  mov      x1, x0
0x00010654  mov      x0, x21
0x00010658  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0001065c  tbz      w0, #0, #0x10674
0x00010660  str      x21, [sp]
0x00010664  adrp     x2, #0x78000
0x00010668  add      x2, x2, #0xe8   ; STR "\n== Performance, last drive (raw) ==\n%@\n"
0x0001066c  ldr      x0, [sp, #0x78]
0x00010670  bl       #0x56460   ; CALL objc_msgSend$appendFormat:
0x00010674  stp      x21, x20, [sp, #0x60]
0x00010678  adrp     x2, #0x78000
0x0001067c  add      x2, x2, #0x108   ; STR "\n== Installed packages ==\n"
0x00010680  ldr      x0, [sp, #0x78]
0x00010684  bl       #0x564a0   ; CALL objc_msgSend$appendString:
0x00010688  movi     v0.16b, #0
0x0001068c  stp      q0, q0, [sp, #0xa0]
0x00010690  stp      q0, q0, [sp, #0x80]
0x00010694  bl       #0x746c
0x00010698  mov      x29, x29
0x0001069c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000106a0  add      x2, sp, #0x80
0x000106a4  add      x3, sp, #0x1c0
0x000106a8  str      x0, [sp, #0x70]
0x000106ac  mov      w4, #0x10
0x000106b0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000106b4  cbz      x0, #0x107a4
0x000106b8  mov      x24, x0
0x000106bc  ldr      x8, [sp, #0x90]
0x000106c0  ldr      x26, [x8]
0x000106c4  adrp     x20, #0x75000
0x000106c8  add      x20, x20, #0x3e8   ; STR "id"
0x000106cc  adrp     x22, #0x77000
0x000106d0  add      x22, x22, #0x128   ; STR "version"
0x000106d4  adrp     x23, #0x75000
0x000106d8  add      x23, x23, #0x1e8   ; STR "name"
0x000106dc  adrp     x27, #0x78000
0x000106e0  add      x27, x27, #0x128   ; STR "%@ %@ (%@)\n"
0x000106e4  mov      x19, #0
0x000106e8  ldr      x8, [sp, #0x90]
0x000106ec  ldr      x8, [x8]
0x000106f0  cmp      x8, x26
0x000106f4  b.eq     #0x10700
0x000106f8  ldr      x0, [sp, #0x70]
0x000106fc  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00010700  ldr      x8, [sp, #0x88]
0x00010704  ldr      x21, [x8, x19, lsl #3]
0x00010708  mov      x0, x21
0x0001070c  mov      x2, x20
0x00010710  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00010714  mov      x29, x29
0x00010718  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001071c  mov      x28, x0
0x00010720  mov      x0, x21
0x00010724  mov      x2, x22
0x00010728  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001072c  mov      x29, x29
0x00010730  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010734  mov      x25, x0
0x00010738  mov      x0, x21
0x0001073c  mov      x2, x23
0x00010740  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00010744  mov      x29, x29
0x00010748  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001074c  mov      x21, x0
0x00010750  stp      x25, x0, [sp, #8]
0x00010754  str      x28, [sp]
0x00010758  ldr      x0, [sp, #0x78]
0x0001075c  mov      x2, x27
0x00010760  bl       #0x56460   ; CALL objc_msgSend$appendFormat:
0x00010764  mov      x0, x21
0x00010768  bl       #0x55d78   ; CALL _objc_release
0x0001076c  mov      x0, x25
0x00010770  bl       #0x55d78   ; CALL _objc_release
0x00010774  mov      x0, x28
0x00010778  bl       #0x55d78   ; CALL _objc_release
0x0001077c  add      x19, x19, #1
0x00010780  cmp      x24, x19
0x00010784  b.ne     #0x106e8
0x00010788  add      x2, sp, #0x80
0x0001078c  add      x3, sp, #0x1c0
0x00010790  ldr      x0, [sp, #0x70]
0x00010794  mov      w4, #0x10
0x00010798  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001079c  mov      x24, x0
0x000107a0  cbnz     x0, #0x106e4
0x000107a4  ldr      x0, [sp, #0x70]
0x000107a8  bl       #0x55d78   ; CALL _objc_release
0x000107ac  adrp     x19, #0x75000
0x000107b0  add      x19, x19, #0x268   ; STR "/var/mobile/Documents/OmniCar.log"
0x000107b4  adrp     x2, #0x77000
0x000107b8  add      x2, x2, #0xe88   ; STR ".old"
0x000107bc  mov      x0, x19
0x000107c0  bl       #0x5d440   ; CALL objc_msgSend$stringByAppendingString:
0x000107c4  mov      x29, x29
0x000107c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000107cc  mov      x20, x0
0x000107d0  adrp     x1, #0x78000
0x000107d4  add      x1, x1, #0x148   ; STR "OmniCar.log.old"
0x000107d8  ldr      x24, [sp, #0x78]
0x000107dc  mov      x0, x24
0x000107e0  mov      x2, x20
0x000107e4  bl       #0x10bf4
0x000107e8  mov      x0, x20
0x000107ec  bl       #0x55d78   ; CALL _objc_release
0x000107f0  adrp     x1, #0x78000
0x000107f4  add      x1, x1, #0x168   ; STR "OmniCar.log"
0x000107f8  mov      x0, x24
0x000107fc  mov      x2, x19
0x00010800  bl       #0x10bf4
0x00010804  adrp     x2, #0x78000
0x00010808  add      x2, x2, #0x188   ; STR "yyyyMMdd-HHmm"
0x0001080c  ldr      x25, [sp, #0x30]
0x00010810  mov      x0, x25
0x00010814  bl       #0x5ac40   ; CALL objc_msgSend$setDateFormat:
0x00010818  bl       #0x55b14   ; CALL _NSTemporaryDirectory
0x0001081c  mov      x29, x29
0x00010820  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010824  mov      x20, x0
0x00010828  adrp     x8, #0x8e000
0x0001082c  ldr      x19, [x8, #0x958]   ; @CLASS NSString
0x00010830  adrp     x8, #0x8e000
0x00010834  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x00010838  bl       #0x575a0   ; CALL objc_msgSend$date
0x0001083c  mov      x29, x29
0x00010840  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010844  mov      x21, x0
0x00010848  mov      x0, x25
0x0001084c  mov      x2, x21
0x00010850  bl       #0x5d500   ; CALL objc_msgSend$stringFromDate:
0x00010854  mov      x29, x29
0x00010858  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001085c  mov      x22, x0
0x00010860  str      x0, [sp]
0x00010864  adrp     x2, #0x78000
0x00010868  add      x2, x2, #0x1a8   ; STR "OmniCar-log-%@.txt"
0x0001086c  mov      x0, x19
0x00010870  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00010874  mov      x29, x29
0x00010878  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001087c  mov      x23, x0
0x00010880  mov      x0, x20
0x00010884  mov      x2, x23
0x00010888  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x0001088c  mov      x29, x29
0x00010890  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010894  mov      x19, x0
0x00010898  mov      x0, x23
0x0001089c  bl       #0x55d78   ; CALL _objc_release
0x000108a0  mov      x0, x22
0x000108a4  bl       #0x55d78   ; CALL _objc_release
0x000108a8  mov      x0, x21
0x000108ac  bl       #0x55d78   ; CALL _objc_release
0x000108b0  mov      x0, x20
0x000108b4  bl       #0x55d78   ; CALL _objc_release
0x000108b8  mov      x0, x24
0x000108bc  mov      x2, x19
0x000108c0  mov      w3, #1
0x000108c4  mov      w4, #4
0x000108c8  mov      x5, #0
0x000108cc  bl       #0x5e240   ; CALL objc_msgSend$writeToFile:atomically:encoding:error:
0x000108d0  mov      x27, #0
0x000108d4  cbz      w0, #0x108f4
0x000108d8  adrp     x8, #0x8e000
0x000108dc  ldr      x0, [x8, #0xa10]   ; @CLASS NSURL
0x000108e0  mov      x2, x19
0x000108e4  bl       #0x57ba0   ; CALL objc_msgSend$fileURLWithPath:
0x000108e8  mov      x29, x29
0x000108ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000108f0  mov      x27, x0
0x000108f4  mov      x0, x19
0x000108f8  bl       #0x55d78   ; CALL _objc_release
0x000108fc  ldr      x0, [sp, #0x60]
0x00010900  bl       #0x55d78   ; CALL _objc_release
0x00010904  ldr      x0, [sp, #0x68]
0x00010908  bl       #0x55d78   ; CALL _objc_release
0x0001090c  ldr      x0, [sp, #0x28]
0x00010910  bl       #0x55d78   ; CALL _objc_release
0x00010914  ldr      x0, [sp, #0x48]
0x00010918  bl       #0x55d78   ; CALL _objc_release
0x0001091c  mov      x0, x25
0x00010920  bl       #0x55d78   ; CALL _objc_release
0x00010924  ldr      x0, [sp, #0x78]
0x00010928  bl       #0x55d78   ; CALL _objc_release
0x0001092c  ldp      x25, x24, [sp, #0x38]
0x00010930  cbz      x27, #0x10990
0x00010934  adrp     x8, #0x8e000
0x00010938  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x0001093c  mov      x2, x27
0x00010940  bl       #0x56620   ; CALL objc_msgSend$arrayWithObject:
0x00010944  mov      x29, x29
0x00010948  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001094c  mov      x19, x0
0x00010950  adrp     x8, #0x8e000
0x00010954  ldr      x0, [x8, #0x9c8]   ; @CLASS UIActivityViewController
0x00010958  bl       #0x55c7c   ; CALL _objc_alloc
0x0001095c  mov      x2, x19
0x00010960  mov      x3, #0
0x00010964  bl       #0x58380   ; CALL objc_msgSend$initWithActivityItems:applicationActivities:
0x00010968  mov      x20, x0
0x0001096c  bl       #0x59840   ; CALL objc_msgSend$popoverPresentationController
0x00010970  mov      x29, x29
0x00010974  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010978  mov      x21, x0
0x0001097c  cbz      x25, #0x10a50
0x00010980  mov      x0, x21
0x00010984  mov      x2, x25
0x00010988  bl       #0x5a5c0   ; CALL objc_msgSend$setBarButtonItem:
0x0001098c  b        #0x10adc
0x00010990  adrp     x8, #0x8e000
0x00010994  ldr      x19, [x8, #0x9b8]   ; @CLASS UIAlertController
0x00010998  adrp     x0, #0x76000
0x0001099c  add      x0, x0, #0xe88   ; STR "SEND_LOG_FAILED"
0x000109a0  bl       #0x17e20   ; CALL _L
0x000109a4  mov      x29, x29
0x000109a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000109ac  mov      x20, x0
0x000109b0  adrp     x2, #0x75000
0x000109b4  add      x2, x2, #0x508   ; STR "OmniCar"
0x000109b8  mov      x0, x19
0x000109bc  mov      x3, x20
0x000109c0  mov      w4, #1
0x000109c4  bl       #0x56280   ; CALL objc_msgSend$alertControllerWithTitle:message:preferredStyle:
0x000109c8  mov      x29, x29
0x000109cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000109d0  mov      x19, x0
0x000109d4  mov      x0, x20
0x000109d8  bl       #0x55d78   ; CALL _objc_release
0x000109dc  adrp     x8, #0x8e000
0x000109e0  ldr      x20, [x8, #0x9c0]   ; @CLASS UIAlertAction
0x000109e4  adrp     x0, #0x76000
0x000109e8  add      x0, x0, #0xea8   ; STR "OK"
0x000109ec  bl       #0x17e20   ; CALL _L
0x000109f0  mov      x29, x29
0x000109f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000109f8  mov      x21, x0
0x000109fc  mov      x0, x20
0x00010a00  mov      x2, x21
0x00010a04  mov      x3, #0
0x00010a08  mov      x4, #0
0x00010a0c  bl       #0x55fc0   ; CALL objc_msgSend$actionWithTitle:style:handler:
0x00010a10  mov      x29, x29
0x00010a14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010a18  mov      x20, x0
0x00010a1c  mov      x0, x19
0x00010a20  mov      x2, x20
0x00010a24  bl       #0x56000   ; CALL objc_msgSend$addAction:
0x00010a28  mov      x0, x20
0x00010a2c  bl       #0x55d78   ; CALL _objc_release
0x00010a30  mov      x0, x21
0x00010a34  bl       #0x55d78   ; CALL _objc_release
0x00010a38  mov      x0, x24
0x00010a3c  mov      x2, x19
0x00010a40  mov      w3, #1
0x00010a44  mov      x4, #0
0x00010a48  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x00010a4c  b        #0x10b00
0x00010a50  mov      x0, x24
0x00010a54  bl       #0x5df60   ; CALL objc_msgSend$view
0x00010a58  mov      x29, x29
0x00010a5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010a60  mov      x22, x0
0x00010a64  mov      x0, x21
0x00010a68  mov      x2, x22
0x00010a6c  bl       #0x5c220   ; CALL objc_msgSend$setSourceView:
0x00010a70  mov      x0, x22
0x00010a74  bl       #0x55d78   ; CALL _objc_release
0x00010a78  mov      x0, x24
0x00010a7c  bl       #0x5df60   ; CALL objc_msgSend$view
0x00010a80  mov      x29, x29
0x00010a84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010a88  mov      x22, x0
0x00010a8c  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00010a90  bl       #0x55a60   ; CALL _CGRectGetMidX
0x00010a94  mov      v8.16b, v0.16b
0x00010a98  mov      x0, x24
0x00010a9c  bl       #0x5df60   ; CALL objc_msgSend$view
0x00010aa0  mov      x29, x29
0x00010aa4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010aa8  mov      x23, x0
0x00010aac  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00010ab0  bl       #0x55a6c   ; CALL _CGRectGetMidY
0x00010ab4  mov      v1.16b, v0.16b
0x00010ab8  fmov     d2, #1.00000000
0x00010abc  fmov     d3, #1.00000000
0x00010ac0  mov      x0, x21
0x00010ac4  mov      v0.16b, v8.16b
0x00010ac8  bl       #0x5c1e0   ; CALL objc_msgSend$setSourceRect:
0x00010acc  mov      x0, x23
0x00010ad0  bl       #0x55d78   ; CALL _objc_release
0x00010ad4  mov      x0, x22
0x00010ad8  bl       #0x55d78   ; CALL _objc_release
0x00010adc  mov      x0, x24
0x00010ae0  mov      x2, x20
0x00010ae4  mov      w3, #1
0x00010ae8  mov      x4, #0
0x00010aec  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x00010af0  mov      x0, x21
0x00010af4  bl       #0x55d78   ; CALL _objc_release
0x00010af8  mov      x0, x20
0x00010afc  bl       #0x55d78   ; CALL _objc_release
0x00010b00  mov      x0, x19
0x00010b04  bl       #0x55d78   ; CALL _objc_release
0x00010b08  mov      x0, x27
0x00010b0c  bl       #0x55d78   ; CALL _objc_release
0x00010b10  mov      x0, x25
0x00010b14  bl       #0x55d78   ; CALL _objc_release
0x00010b18  mov      x0, x24
0x00010b1c  bl       #0x55d78   ; CALL _objc_release
0x00010b20  ldur     x8, [x29, #-0x70]
0x00010b24  adrp     x9, #0x74000
0x00010b28  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00010b2c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00010b30  cmp      x9, x8
0x00010b34  b.ne     #0x10b5c
0x00010b38  add      sp, sp, #0x450
0x00010b3c  ldp      x29, x30, [sp, #0x60]
0x00010b40  ldp      x20, x19, [sp, #0x50]
0x00010b44  ldp      x22, x21, [sp, #0x40]
0x00010b48  ldp      x24, x23, [sp, #0x30]
0x00010b4c  ldp      x26, x25, [sp, #0x20]
0x00010b50  ldp      x28, x27, [sp, #0x10]
0x00010b54  ldp      d9, d8, [sp], #0x70
0x00010b58  ret      
0x00010b5c  bl       #0x55b98   ; CALL ___stack_chk_fail

=== _OMCLanguages  va=0x179d4 size=4 types=
0x000179d4  b        #0x54cb8   ; CALL _OMCSupportedLanguages

=== _OMCLanguageName  va=0x179d8 size=104 types=
0x000179d8  stp      x22, x21, [sp, #-0x30]!
0x000179dc  stp      x20, x19, [sp, #0x10]
0x000179e0  stp      x29, x30, [sp, #0x20]
0x000179e4  add      x29, sp, #0x20
0x000179e8  mov      x19, x0
0x000179ec  bl       #0x55d84   ; CALL _objc_retain
0x000179f0  adrp     x0, #0x80000
0x000179f4  add      x0, x0, #0x30
0x000179f8  mov      x2, x19
0x000179fc  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00017a00  mov      x29, x29
0x00017a04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017a08  mov      x20, x0
0x00017a0c  cmp      x0, #0
0x00017a10  csel     x21, x19, x0, eq
0x00017a14  mov      x0, x21
0x00017a18  bl       #0x55d84   ; CALL _objc_retain
0x00017a1c  mov      x0, x19
0x00017a20  bl       #0x55d78   ; CALL _objc_release
0x00017a24  mov      x0, x20
0x00017a28  bl       #0x55d78   ; CALL _objc_release
0x00017a2c  mov      x0, x21
0x00017a30  ldp      x29, x30, [sp, #0x20]
0x00017a34  ldp      x20, x19, [sp, #0x10]
0x00017a38  ldp      x22, x21, [sp], #0x30
0x00017a3c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== _OMCLanguage  va=0x17a40 size=4 types=
0x00017a40  b        #0x54cc4   ; CALL _OMCCurrentLanguage

=== _OMCLoadStrings  va=0x17a44 size=988 types=
0x00017a44  stp      x28, x27, [sp, #-0x60]!
0x00017a48  stp      x26, x25, [sp, #0x10]
0x00017a4c  stp      x24, x23, [sp, #0x20]
0x00017a50  stp      x22, x21, [sp, #0x30]
0x00017a54  stp      x20, x19, [sp, #0x40]
0x00017a58  stp      x29, x30, [sp, #0x50]
0x00017a5c  add      x29, sp, #0x50
0x00017a60  sub      sp, sp, #0x1d0
0x00017a64  adrp     x8, #0x74000
0x00017a68  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00017a6c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00017a70  stur     x8, [x29, #-0x60]
0x00017a74  adrp     x8, #0x8e000
0x00017a78  ldr      x19, [x8, #0x9d8]   ; @CLASS NSBundle
0x00017a7c  adrp     x0, #0x76000
0x00017a80  add      x0, x0, #0xf28   ; STR "OMCRootListController"
0x00017a84  bl       #0x55af0   ; CALL _NSClassFromString
0x00017a88  mov      x2, x0
0x00017a8c  mov      x0, x19
0x00017a90  bl       #0x56b40   ; CALL objc_msgSend$bundleForClass:
0x00017a94  mov      x29, x29
0x00017a98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017a9c  mov      x19, x0
0x00017aa0  bl       #0x56b60   ; CALL objc_msgSend$bundlePath
0x00017aa4  mov      x29, x29
0x00017aa8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017aac  mov      x21, x0
0x00017ab0  mov      x0, x19
0x00017ab4  bl       #0x55d78   ; CALL _objc_release
0x00017ab8  bl       #0x54cc4   ; CALL _OMCCurrentLanguage
0x00017abc  mov      x29, x29
0x00017ac0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017ac4  mov      x19, x0
0x00017ac8  str      x0, [sp]
0x00017acc  adrp     x2, #0x78000
0x00017ad0  add      x2, x2, #0xd68   ; STR "/%@.lproj"
0x00017ad4  mov      x0, x21
0x00017ad8  bl       #0x5d400   ; CALL objc_msgSend$stringByAppendingFormat:
0x00017adc  mov      x29, x29
0x00017ae0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017ae4  mov      x22, x0
0x00017ae8  mov      x0, x19
0x00017aec  bl       #0x55d78   ; CALL _objc_release
0x00017af0  adrp     x8, #0x8e000
0x00017af4  ldr      x0, [x8, #0x9d0]   ; @CLASS NSMutableDictionary
0x00017af8  bl       #0x57780   ; CALL objc_msgSend$dictionary
0x00017afc  mov      x29, x29
0x00017b00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017b04  str      x0, [sp, #0x38]
0x00017b08  adrp     x8, #0x8e000
0x00017b0c  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00017b10  bl       #0x565c0   ; CALL objc_msgSend$array
0x00017b14  mov      x29, x29
0x00017b18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017b1c  str      x0, [sp, #0x18]
0x00017b20  bl       #0x54cc4   ; CALL _OMCCurrentLanguage
0x00017b24  mov      x29, x29
0x00017b28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017b2c  mov      x23, x0
0x00017b30  adrp     x2, #0x78000
0x00017b34  add      x2, x2, #0xa48   ; STR "en"
0x00017b38  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00017b3c  tbnz     w0, #0, #0x17b9c
0x00017b40  bl       #0x54cc4   ; CALL _OMCCurrentLanguage
0x00017b44  mov      x29, x29
0x00017b48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017b4c  mov      x19, x0
0x00017b50  adrp     x2, #0x78000
0x00017b54  add      x2, x2, #0xa08   ; STR "vi"
0x00017b58  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00017b5c  mov      x20, x0
0x00017b60  mov      x0, x19
0x00017b64  bl       #0x55d78   ; CALL _objc_release
0x00017b68  mov      x0, x23
0x00017b6c  bl       #0x55d78   ; CALL _objc_release
0x00017b70  tbnz     w20, #0, #0x17ba4
0x00017b74  adrp     x2, #0x78000
0x00017b78  add      x2, x2, #0xd88   ; STR "/en.lproj"
0x00017b7c  mov      x0, x21
0x00017b80  bl       #0x5d440   ; CALL objc_msgSend$stringByAppendingString:
0x00017b84  mov      x29, x29
0x00017b88  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017b8c  mov      x23, x0
0x00017b90  ldr      x0, [sp, #0x18]
0x00017b94  mov      x2, x23
0x00017b98  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00017b9c  mov      x0, x23
0x00017ba0  bl       #0x55d78   ; CALL _objc_release
0x00017ba4  stp      x22, x21, [sp, #8]
0x00017ba8  ldr      x19, [sp, #0x18]
0x00017bac  mov      x0, x19
0x00017bb0  mov      x2, x22
0x00017bb4  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00017bb8  movi     v0.16b, #0
0x00017bbc  stp      q0, q0, [sp, #0xa0]
0x00017bc0  stp      q0, q0, [sp, #0x80]
0x00017bc4  mov      x0, x19
0x00017bc8  bl       #0x55d84   ; CALL _objc_retain
0x00017bcc  add      x2, sp, #0x80
0x00017bd0  sub      x3, x29, #0xe0
0x00017bd4  mov      x0, x19
0x00017bd8  mov      w4, #0x10
0x00017bdc  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00017be0  str      x0, [sp, #0x28]
0x00017be4  cbz      x0, #0x17dac
0x00017be8  ldr      x8, [sp, #0x90]
0x00017bec  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00017bf0  str      x8, [sp, #0x20]
0x00017bf4  adrp     x24, #0x78000
0x00017bf8  add      x24, x24, #0xda8   ; STR "strings"
0x00017bfc  adrp     x25, #0x78000
0x00017c00  add      x25, x25, #0xdc8   ; STR "Car.strings"
0x00017c04  mov      x19, #0
0x00017c08  ldr      x8, [sp, #0x90]
0x00017c0c  ldr      x8, [x8]   ; @CSTR "whatsNewNavigationController"
0x00017c10  ldr      x9, [sp, #0x20]
0x00017c14  cmp      x8, x9
0x00017c18  b.eq     #0x17c24
0x00017c1c  ldr      x0, [sp, #0x18]
0x00017c20  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00017c24  ldr      x8, [sp, #0x88]
0x00017c28  str      x19, [sp, #0x30]
0x00017c2c  ldr      x26, [x8, x19, lsl #3]
0x00017c30  movi     v0.16b, #0
0x00017c34  stp      q0, q0, [sp, #0x40]
0x00017c38  stp      q0, q0, [sp, #0x60]
0x00017c3c  adrp     x8, #0x8e000
0x00017c40  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x00017c44  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x00017c48  mov      x29, x29
0x00017c4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017c50  mov      x19, x0
0x00017c54  mov      x2, x26
0x00017c58  mov      x3, #0
0x00017c5c  bl       #0x572a0   ; CALL objc_msgSend$contentsOfDirectoryAtPath:error:
0x00017c60  mov      x29, x29
0x00017c64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017c68  mov      x27, x0
0x00017c6c  mov      x0, x19
0x00017c70  bl       #0x55d78   ; CALL _objc_release
0x00017c74  add      x2, sp, #0x40
0x00017c78  add      x3, sp, #0xc0
0x00017c7c  mov      x0, x27
0x00017c80  mov      w4, #0x10
0x00017c84  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00017c88  cbz      x0, #0x17d78
0x00017c8c  mov      x28, x0
0x00017c90  ldr      x8, [sp, #0x50]
0x00017c94  ldr      x21, [x8]   ; @SEL "whatsNewNavigationController"
0x00017c98  mov      x23, #0
0x00017c9c  ldr      x8, [sp, #0x50]
0x00017ca0  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00017ca4  cmp      x8, x21
0x00017ca8  b.eq     #0x17cb4
0x00017cac  mov      x0, x27
0x00017cb0  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00017cb4  ldr      x8, [sp, #0x48]
0x00017cb8  ldr      x19, [x8, x23, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00017cbc  mov      x0, x19
0x00017cc0  bl       #0x59620   ; CALL objc_msgSend$pathExtension
0x00017cc4  mov      x29, x29
0x00017cc8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017ccc  mov      x20, x0
0x00017cd0  mov      x2, x24
0x00017cd4  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00017cd8  cbz      w0, #0x17d48
0x00017cdc  mov      x0, x19
0x00017ce0  mov      x2, x25
0x00017ce4  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00017ce8  mov      x22, x0
0x00017cec  mov      x0, x20
0x00017cf0  bl       #0x55d78   ; CALL _objc_release
0x00017cf4  tbnz     w22, #0, #0x17d50
0x00017cf8  adrp     x8, #0x8e000
0x00017cfc  ldr      x20, [x8, #0x970]   ; @CLASS NSDictionary
0x00017d00  mov      x0, x26
0x00017d04  mov      x2, x19
0x00017d08  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00017d0c  mov      x29, x29
0x00017d10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017d14  mov      x19, x0
0x00017d18  mov      x0, x20
0x00017d1c  mov      x2, x19
0x00017d20  bl       #0x577a0   ; CALL objc_msgSend$dictionaryWithContentsOfFile:
0x00017d24  mov      x29, x29
0x00017d28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017d2c  mov      x20, x0
0x00017d30  mov      x0, x19
0x00017d34  bl       #0x55d78   ; CALL _objc_release
0x00017d38  cbz      x20, #0x17d48
0x00017d3c  ldr      x0, [sp, #0x38]
0x00017d40  mov      x2, x20
0x00017d44  bl       #0x560c0   ; CALL objc_msgSend$addEntriesFromDictionary:
0x00017d48  mov      x0, x20
0x00017d4c  bl       #0x55d78   ; CALL _objc_release
0x00017d50  add      x23, x23, #1
0x00017d54  cmp      x28, x23
0x00017d58  b.ne     #0x17c9c
0x00017d5c  add      x2, sp, #0x40
0x00017d60  add      x3, sp, #0xc0
0x00017d64  mov      x0, x27
0x00017d68  mov      w4, #0x10
0x00017d6c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00017d70  mov      x28, x0
0x00017d74  cbnz     x0, #0x17c98
0x00017d78  mov      x0, x27
0x00017d7c  bl       #0x55d78   ; CALL _objc_release
0x00017d80  ldp      x8, x19, [sp, #0x28]
0x00017d84  add      x19, x19, #1
0x00017d88  cmp      x19, x8
0x00017d8c  b.ne     #0x17c08
0x00017d90  add      x2, sp, #0x80
0x00017d94  sub      x3, x29, #0xe0
0x00017d98  ldr      x0, [sp, #0x18]
0x00017d9c  mov      w4, #0x10
0x00017da0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00017da4  str      x0, [sp, #0x28]
0x00017da8  cbnz     x0, #0x17c04
0x00017dac  ldr      x19, [sp, #0x18]
0x00017db0  mov      x0, x19
0x00017db4  bl       #0x55d78   ; CALL _objc_release
0x00017db8  adrp     x8, #0x90000
0x00017dbc  ldr      x0, [x8]
0x00017dc0  ldr      x9, [sp, #0x38]
0x00017dc4  str      x9, [x8]
0x00017dc8  bl       #0x55d78   ; CALL _objc_release
0x00017dcc  mov      x0, x19
0x00017dd0  bl       #0x55d78   ; CALL _objc_release
0x00017dd4  ldr      x0, [sp, #8]
0x00017dd8  bl       #0x55d78   ; CALL _objc_release
0x00017ddc  ldr      x0, [sp, #0x10]
0x00017de0  bl       #0x55d78   ; CALL _objc_release
0x00017de4  ldur     x8, [x29, #-0x60]
0x00017de8  adrp     x9, #0x74000
0x00017dec  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00017df0  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00017df4  cmp      x9, x8
0x00017df8  b.ne     #0x17e1c
0x00017dfc  add      sp, sp, #0x1d0
0x00017e00  ldp      x29, x30, [sp, #0x50]
0x00017e04  ldp      x20, x19, [sp, #0x40]
0x00017e08  ldp      x22, x21, [sp, #0x30]
0x00017e0c  ldp      x24, x23, [sp, #0x20]
0x00017e10  ldp      x26, x25, [sp, #0x10]
0x00017e14  ldp      x28, x27, [sp], #0x60
0x00017e18  ret      
0x00017e1c  bl       #0x55b98   ; CALL ___stack_chk_fail

=== _L  va=0x17e20 size=108 types=
0x00017e20  stp      x22, x21, [sp, #-0x30]!
0x00017e24  stp      x20, x19, [sp, #0x10]
0x00017e28  stp      x29, x30, [sp, #0x20]
0x00017e2c  add      x29, sp, #0x20
0x00017e30  mov      x19, x0
0x00017e34  adrp     x8, #0x90000
0x00017e38  ldr      x20, [x8]
0x00017e3c  bl       #0x55d84   ; CALL _objc_retain
0x00017e40  mov      x0, x20
0x00017e44  mov      x2, x19
0x00017e48  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00017e4c  mov      x29, x29
0x00017e50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017e54  mov      x20, x0
0x00017e58  cmp      x0, #0
0x00017e5c  csel     x21, x19, x0, eq
0x00017e60  mov      x0, x21
0x00017e64  bl       #0x55d84   ; CALL _objc_retain
0x00017e68  mov      x0, x19
0x00017e6c  bl       #0x55d78   ; CALL _objc_release
0x00017e70  mov      x0, x20
0x00017e74  bl       #0x55d78   ; CALL _objc_release
0x00017e78  mov      x0, x21
0x00017e7c  ldp      x29, x30, [sp, #0x20]
0x00017e80  ldp      x20, x19, [sp, #0x10]
0x00017e84  ldp      x22, x21, [sp], #0x30
0x00017e88  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== _OMCAccentColor  va=0x17e8c size=332 types=
0x00017e8c  mov      w0, #0x6cf6
0x00017e90  movk     w0, #0x7b, lsl #16
0x00017e94  mov      w1, #0x9bff
0x00017e98  movk     w1, #0xa8, lsl #16
0x00017e9c  b        #0x17ea0
0x00017ea0  sub      sp, sp, #0x70
0x00017ea4  stp      d9, d8, [sp, #0x30]
0x00017ea8  stp      x22, x21, [sp, #0x40]
0x00017eac  stp      x20, x19, [sp, #0x50]
0x00017eb0  stp      x29, x30, [sp, #0x60]
0x00017eb4  add      x29, sp, #0x60
0x00017eb8  mov      x20, x1
0x00017ebc  adrp     x21, #0x8e000
0x00017ec0  lsr      w8, w0, #0x10
0x00017ec4  ucvtf    d0, w8
0x00017ec8  ldr      x8, [x21, #0x910]   ; @CLASS UIColor
0x00017ecc  adrp     x9, #0x65000
0x00017ed0  ldr      d8, [x9, #0x688]
0x00017ed4  ubfx     w9, w0, #8, #8
0x00017ed8  ucvtf    d1, w9
0x00017edc  fdiv     d0, d0, d8
0x00017ee0  fdiv     d1, d1, d8
0x00017ee4  and      w9, w0, #0xff
0x00017ee8  ucvtf    d2, w9
0x00017eec  fdiv     d2, d2, d8
0x00017ef0  fmov     d3, #1.00000000
0x00017ef4  mov      x0, x8
0x00017ef8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00017efc  mov      x29, x29
0x00017f00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017f04  mov      x19, x0
0x00017f08  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00017f0c  lsr      w8, w20, #0x10
0x00017f10  ucvtf    d0, w8
0x00017f14  ubfx     w8, w20, #8, #8
0x00017f18  ucvtf    d1, w8
0x00017f1c  fdiv     d0, d0, d8
0x00017f20  fdiv     d1, d1, d8
0x00017f24  and      w8, w20, #0xff
0x00017f28  ucvtf    d2, w8
0x00017f2c  fdiv     d2, d2, d8
0x00017f30  fmov     d3, #1.00000000
0x00017f34  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00017f38  mov      x29, x29
0x00017f3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017f40  mov      x20, x0
0x00017f44  ldr      x21, [x21, #0x910]   ; @CLASS UIColor
0x00017f48  adrp     x8, #0x74000
0x00017f4c  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00017f50  str      x8, [sp]
0x00017f54  adrp     x8, #0x65000
0x00017f58  ldr      d0, [x8, #0x600]
0x00017f5c  str      d0, [sp, #8]
0x00017f60  adrp     x8, #0x19000
0x00017f64  add      x8, x8, #0x3e8
0x00017f68  adrp     x9, #0x74000
0x00017f6c  add      x9, x9, #0x920
0x00017f70  stp      x8, x9, [sp, #0x10]
0x00017f74  stp      x0, x19, [sp, #0x20]
0x00017f78  bl       #0x55d84   ; CALL _objc_retain
0x00017f7c  mov      x0, x19
0x00017f80  bl       #0x55d84   ; CALL _objc_retain
0x00017f84  mov      x2, sp
0x00017f88  mov      x0, x21
0x00017f8c  bl       #0x56ea0   ; CALL objc_msgSend$colorWithDynamicProvider:
0x00017f90  mov      x29, x29
0x00017f94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017f98  mov      x21, x0
0x00017f9c  ldr      x0, [sp, #0x28]
0x00017fa0  bl       #0x55d78   ; CALL _objc_release
0x00017fa4  ldr      x0, [sp, #0x20]
0x00017fa8  bl       #0x55d78   ; CALL _objc_release
0x00017fac  mov      x0, x20
0x00017fb0  bl       #0x55d78   ; CALL _objc_release
0x00017fb4  mov      x0, x19
0x00017fb8  bl       #0x55d78   ; CALL _objc_release
0x00017fbc  mov      x0, x21
0x00017fc0  ldp      x29, x30, [sp, #0x60]
0x00017fc4  ldp      x20, x19, [sp, #0x50]
0x00017fc8  ldp      x22, x21, [sp, #0x40]
0x00017fcc  ldp      d9, d8, [sp, #0x30]
0x00017fd0  add      sp, sp, #0x70
0x00017fd4  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== _OMCSwitchColor  va=0x17fd8 size=12 types=
0x00017fd8  adrp     x8, #0x8e000
0x00017fdc  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00017fe0  b        #0x5d800   ; CALL objc_msgSend$systemGreenColor

=== _OMCBackgroundColor  va=0x17fe4 size=20 types=
0x00017fe4  mov      w0, #0xf5fb
0x00017fe8  movk     w0, #0xf4, lsl #16
0x00017fec  mov      w1, #0xf16
0x00017ff0  movk     w1, #0xe, lsl #16
0x00017ff4  b        #0x17ea0

=== _OMCCardColor  va=0x17ff8 size=20 types=
0x00017ff8  adrp     x8, #0x8e000
0x00017ffc  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00018000  adrp     x2, #0x74000
0x00018004  add      x2, x2, #0x8a0
0x00018008  b        #0x56ea0   ; CALL objc_msgSend$colorWithDynamicProvider:

=== _OMCColorFromHex  va=0x18080 size=196 types=
0x00018080  sub      sp, sp, #0x30
0x00018084  stp      x20, x19, [sp, #0x10]
0x00018088  stp      x29, x30, [sp, #0x20]
0x0001808c  add      x29, sp, #0x20
0x00018090  str      wzr, [sp, #0xc]
0x00018094  adrp     x8, #0x8e000
0x00018098  ldr      x19, [x8, #0xaf8]   ; @CLASS NSScanner
0x0001809c  adrp     x2, #0x78000
0x000180a0  add      x2, x2, #0xde8   ; STR "#"
0x000180a4  adrp     x3, #0x75000
0x000180a8  add      x3, x3, #0xd28
0x000180ac  bl       #0x5d4a0   ; CALL objc_msgSend$stringByReplacingOccurrencesOfString:withString:
0x000180b0  mov      x29, x29
0x000180b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000180b8  mov      x20, x0
0x000180bc  mov      x0, x19
0x000180c0  mov      x2, x20
0x000180c4  bl       #0x5a0c0   ; CALL objc_msgSend$scannerWithString:
0x000180c8  mov      x29, x29
0x000180cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000180d0  mov      x19, x0
0x000180d4  add      x2, sp, #0xc
0x000180d8  bl       #0x5a0a0   ; CALL objc_msgSend$scanHexInt:
0x000180dc  mov      x0, x19
0x000180e0  bl       #0x55d78   ; CALL _objc_release
0x000180e4  mov      x0, x20
0x000180e8  bl       #0x55d78   ; CALL _objc_release
0x000180ec  adrp     x8, #0x8e000
0x000180f0  ldr      w9, [sp, #0xc]
0x000180f4  ubfx     w10, w9, #0x10, #8
0x000180f8  ucvtf    d0, w10
0x000180fc  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00018100  adrp     x8, #0x65000
0x00018104  ldr      d2, [x8, #0x688]
0x00018108  ubfx     w8, w9, #8, #8
0x0001810c  ucvtf    d1, w8
0x00018110  fdiv     d0, d0, d2
0x00018114  fdiv     d1, d1, d2
0x00018118  and      w8, w9, #0xff
0x0001811c  ucvtf    d3, w8
0x00018120  fdiv     d2, d3, d2
0x00018124  fmov     d3, #1.00000000
0x00018128  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0001812c  mov      x29, x29
0x00018130  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018134  ldp      x29, x30, [sp, #0x20]
0x00018138  ldp      x20, x19, [sp, #0x10]
0x0001813c  add      sp, sp, #0x30
0x00018140  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== _OMCIcon  va=0x18144 size=1684 types=
0x00018144  sub      sp, sp, #0xc0
0x00018148  stp      x26, x25, [sp, #0x70]
0x0001814c  stp      x24, x23, [sp, #0x80]
0x00018150  stp      x22, x21, [sp, #0x90]
0x00018154  stp      x20, x19, [sp, #0xa0]
0x00018158  stp      x29, x30, [sp, #0xb0]
0x0001815c  add      x29, sp, #0xb0
0x00018160  mov      x19, x1
0x00018164  mov      x21, x0
0x00018168  adrp     x8, #0x74000
0x0001816c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00018170  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00018174  stur     x8, [x29, #-0x48]
0x00018178  mov      x0, x1
0x0001817c  bl       #0x55d84   ; CALL _objc_retain
0x00018180  adrp     x8, #0x8e000
0x00018184  ldr      x20, [x8, #0xa70]   ; @CLASS UIImageSymbolConfiguration
0x00018188  mov      x0, x21
0x0001818c  bl       #0x55d84   ; CALL _objc_retain
0x00018190  fmov     d0, #14.00000000
0x00018194  mov      x0, x20
0x00018198  mov      w2, #6
0x0001819c  bl       #0x57100   ; CALL objc_msgSend$configurationWithPointSize:weight:
0x000181a0  mov      x29, x29
0x000181a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000181a8  mov      x20, x0
0x000181ac  adrp     x8, #0x8e000
0x000181b0  ldr      x0, [x8, #0xa78]   ; @CLASS UIImage
0x000181b4  mov      x2, x21
0x000181b8  mov      x3, x20
0x000181bc  bl       #0x5d840   ; CALL objc_msgSend$systemImageNamed:withConfiguration:
0x000181c0  mov      x29, x29
0x000181c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000181c8  mov      x22, x0
0x000181cc  mov      x0, x21
0x000181d0  bl       #0x55d78   ; CALL _objc_release
0x000181d4  adrp     x8, #0x8e000
0x000181d8  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x000181dc  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x000181e0  mov      x29, x29
0x000181e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000181e8  mov      x23, x0
0x000181ec  mov      x0, x22
0x000181f0  mov      x2, x23
0x000181f4  mov      w3, #1
0x000181f8  bl       #0x58200   ; CALL objc_msgSend$imageWithTintColor:renderingMode:
0x000181fc  mov      x29, x29
0x00018200  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018204  mov      x21, x0
0x00018208  mov      x0, x23
0x0001820c  bl       #0x55d78   ; CALL _objc_release
0x00018210  mov      x0, x22
0x00018214  bl       #0x55d78   ; CALL _objc_release
0x00018218  cbz      x21, #0x182ac
0x0001821c  mov      x22, x19
0x00018220  cbnz     x19, #0x18244
0x00018224  mov      w0, #0x6cf6
0x00018228  movk     w0, #0x7b, lsl #16
0x0001822c  mov      w1, #0x9bff
0x00018230  movk     w1, #0xa8, lsl #16
0x00018234  bl       #0x17ea0
0x00018238  mov      x29, x29
0x0001823c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018240  mov      x22, x0
0x00018244  stp      xzr, xzr, [sp, #0x48]
0x00018248  stp      xzr, xzr, [sp, #0x38]
0x0001824c  add      x2, sp, #0x50
0x00018250  add      x3, sp, #0x48
0x00018254  add      x4, sp, #0x40
0x00018258  add      x5, sp, #0x38
0x0001825c  mov      x0, x22
0x00018260  bl       #0x57e00   ; CALL objc_msgSend$getHue:saturation:brightness:alpha:
0x00018264  ldr      d0, [sp, #0x50]
0x00018268  adrp     x8, #0x65000
0x0001826c  ldr      d1, [x8, #0x6b8]
0x00018270  fcmp     d0, d1
0x00018274  adrp     x8, #0x78000
0x00018278  add      x8, x8, #0x528   ; STR "#B7A6FF"
0x0001827c  adrp     x9, #0x78000
0x00018280  add      x9, x9, #0xf28   ; STR "#8B7CFF"
0x00018284  adrp     x10, #0x65000
0x00018288  b.lt     #0x182b4
0x0001828c  ldr      d1, [x10, #0x6c0]
0x00018290  fcmp     d0, d1
0x00018294  b.pl     #0x182b4
0x00018298  adrp     x10, #0x78000
0x0001829c  add      x10, x10, #0xee8   ; STR "#2BC79A"
0x000182a0  adrp     x11, #0x78000
0x000182a4  add      x11, x11, #0x568   ; STR "#9DF2D8"
0x000182a8  b        #0x1831c
0x000182ac  mov      x22, #0
0x000182b0  b        #0x18434
0x000182b4  ldr      d1, [x10, #0x6c0]   ; @STR "APPS_CARPLAY_GUESS_FOOTER"
0x000182b8  fcmp     d0, d1
0x000182bc  adrp     x10, #0x65000
0x000182c0  b.lt     #0x182e4
0x000182c4  ldr      d1, [x10, #0x6c8]
0x000182c8  fcmp     d0, d1
0x000182cc  b.pl     #0x182e4
0x000182d0  adrp     x10, #0x78000
0x000182d4  add      x10, x10, #0xf08   ; STR "#5AB8FF"
0x000182d8  adrp     x11, #0x78000
0x000182dc  add      x11, x11, #0x548   ; STR "#8FD3FF"
0x000182e0  b        #0x1831c
0x000182e4  ldr      d1, [x10, #0x6c8]
0x000182e8  fcmp     d0, d1
0x000182ec  cset     w10, ge
0x000182f0  adrp     x11, #0x65000
0x000182f4  ldr      d1, [x11, #0x6d0]
0x000182f8  fcmp     d0, d1
0x000182fc  adrp     x11, #0x78000
0x00018300  add      x11, x11, #0xea8   ; STR "#FFC2D6"
0x00018304  cset     w12, mi
0x00018308  tst      w10, w12
0x0001830c  csel     x11, x8, x11, ne
0x00018310  adrp     x10, #0x78000
0x00018314  add      x10, x10, #0xec8   ; STR "#FF7FA8"
0x00018318  csel     x10, x9, x10, ne
0x0001831c  ldr      d0, [sp, #0x48]
0x00018320  adrp     x12, #0x65000
0x00018324  ldr      d1, [x12, #0x6d8]
0x00018328  fcmp     d0, d1
0x0001832c  csel     x0, x8, x11, mi
0x00018330  csel     x23, x9, x10, mi
0x00018334  bl       #0x18080   ; CALL _OMCColorFromHex
0x00018338  mov      x29, x29
0x0001833c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018340  mov      x24, x0
0x00018344  str      x0, [sp, #0x58]
0x00018348  mov      x0, x23
0x0001834c  bl       #0x18080   ; CALL _OMCColorFromHex
0x00018350  mov      x29, x29
0x00018354  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018358  mov      x25, x0
0x0001835c  str      x0, [sp, #0x60]
0x00018360  adrp     x8, #0x8e000
0x00018364  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00018368  add      x2, sp, #0x58
0x0001836c  mov      w3, #2
0x00018370  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00018374  mov      x29, x29
0x00018378  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001837c  mov      x23, x0
0x00018380  mov      x0, x25
0x00018384  bl       #0x55d78   ; CALL _objc_release
0x00018388  mov      x0, x24
0x0001838c  bl       #0x55d78   ; CALL _objc_release
0x00018390  cbnz     x19, #0x1839c
0x00018394  mov      x0, x22
0x00018398  bl       #0x55d78   ; CALL _objc_release
0x0001839c  adrp     x8, #0x8e000
0x000183a0  ldr      x0, [x8, #0xb00]   ; @CLASS UIGraphicsImageRenderer
0x000183a4  bl       #0x55c7c   ; CALL _objc_alloc
0x000183a8  fmov     d0, #29.00000000
0x000183ac  fmov     d1, #29.00000000
0x000183b0  bl       #0x58540   ; CALL objc_msgSend$initWithSize:
0x000183b4  mov      x24, x0
0x000183b8  adrp     x8, #0x74000
0x000183bc  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x000183c0  str      x8, [sp, #8]
0x000183c4  adrp     x8, #0x65000
0x000183c8  ldr      d0, [x8, #0x600]
0x000183cc  adrp     x8, #0x18000
0x000183d0  add      x8, x8, #0x488
0x000183d4  str      d0, [sp, #0x10]
0x000183d8  adrp     x9, #0x74000
0x000183dc  add      x9, x9, #0x8c0
0x000183e0  stp      x8, x9, [sp, #0x18]
0x000183e4  str      x23, [sp, #0x28]
0x000183e8  mov      x0, x21
0x000183ec  bl       #0x55d84   ; CALL _objc_retain
0x000183f0  str      x21, [sp, #0x30]
0x000183f4  mov      x0, x23
0x000183f8  bl       #0x55d84   ; CALL _objc_retain
0x000183fc  add      x2, sp, #8
0x00018400  mov      x0, x24
0x00018404  bl       #0x58140   ; CALL objc_msgSend$imageWithActions:
0x00018408  mov      x29, x29
0x0001840c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018410  mov      x22, x0
0x00018414  ldr      x0, [sp, #0x30]
0x00018418  bl       #0x55d78   ; CALL _objc_release
0x0001841c  ldr      x0, [sp, #0x28]
0x00018420  bl       #0x55d78   ; CALL _objc_release
0x00018424  mov      x0, x23
0x00018428  bl       #0x55d78   ; CALL _objc_release
0x0001842c  mov      x0, x24
0x00018430  bl       #0x55d78   ; CALL _objc_release
0x00018434  mov      x0, x21
0x00018438  bl       #0x55d78   ; CALL _objc_release
0x0001843c  mov      x0, x20
0x00018440  bl       #0x55d78   ; CALL _objc_release
0x00018444  mov      x0, x19
0x00018448  bl       #0x55d78   ; CALL _objc_release
0x0001844c  ldur     x8, [x29, #-0x48]
0x00018450  adrp     x9, #0x74000
0x00018454  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00018458  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0001845c  cmp      x9, x8
0x00018460  b.ne     #0x18484
0x00018464  mov      x0, x22
0x00018468  ldp      x29, x30, [sp, #0xb0]
0x0001846c  ldp      x20, x19, [sp, #0xa0]
0x00018470  ldp      x22, x21, [sp, #0x90]
0x00018474  ldp      x24, x23, [sp, #0x80]
0x00018478  ldp      x26, x25, [sp, #0x70]
0x0001847c  add      sp, sp, #0xc0
0x00018480  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00018484  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00018488  sub      sp, sp, #0xb0
0x0001848c  stp      d11, d10, [sp, #0x30]
0x00018490  stp      d9, d8, [sp, #0x40]
0x00018494  stp      x28, x27, [sp, #0x50]
0x00018498  stp      x26, x25, [sp, #0x60]
0x0001849c  stp      x24, x23, [sp, #0x70]
0x000184a0  stp      x22, x21, [sp, #0x80]
0x000184a4  stp      x20, x19, [sp, #0x90]
0x000184a8  stp      x29, x30, [sp, #0xa0]
0x000184ac  add      x29, sp, #0xa0
0x000184b0  mov      x22, x1
0x000184b4  mov      x20, x0
0x000184b8  adrp     x8, #0x74000
0x000184bc  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000184c0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000184c4  str      x8, [sp, #0x28]
0x000184c8  adrp     x8, #0x8e000
0x000184cc  ldr      x19, [x8, #0xac0]   ; @CLASS UIBezierPath
0x000184d0  mov      x0, x1
0x000184d4  bl       #0x55d84   ; CALL _objc_retain
0x000184d8  fmov     d10, #29.00000000
0x000184dc  fmov     d0, xzr
0x000184e0  fmov     d1, xzr
0x000184e4  fmov     d2, #29.00000000
0x000184e8  fmov     d3, #29.00000000
0x000184ec  fmov     d4, #8.50000000
0x000184f0  mov      x0, x19
0x000184f4  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x000184f8  mov      x29, x29
0x000184fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018500  mov      x19, x0
0x00018504  mov      x0, x22
0x00018508  bl       #0x55ea0   ; CALL objc_msgSend$CGContext
0x0001850c  bl       #0x55970   ; CALL _CGContextSaveGState
0x00018510  mov      x0, x19
0x00018514  bl       #0x560a0   ; CALL objc_msgSend$addClip
0x00018518  bl       #0x558d4   ; CALL _CGColorSpaceCreateDeviceRGB
0x0001851c  mov      x23, x0
0x00018520  ldr      x0, [x20, #0x20]
0x00018524  mov      x2, #0
0x00018528  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0001852c  mov      x29, x29
0x00018530  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018534  mov      x24, x0
0x00018538  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0001853c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00018540  str      x0, [sp, #0x18]
0x00018544  ldr      x0, [x20, #0x20]
0x00018548  mov      w2, #1
0x0001854c  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00018550  mov      x29, x29
0x00018554  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018558  mov      x25, x0
0x0001855c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00018560  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00018564  str      x0, [sp, #0x20]
0x00018568  adrp     x27, #0x8e000
0x0001856c  ldr      x0, [x27, #0x960]   ; @CLASS NSArray
0x00018570  add      x2, sp, #0x18
0x00018574  mov      w3, #2
0x00018578  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0001857c  mov      x29, x29
0x00018580  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018584  mov      x21, x0
0x00018588  mov      x0, x25
0x0001858c  bl       #0x55d78   ; CALL _objc_release
0x00018590  mov      x0, x24
0x00018594  bl       #0x55d78   ; CALL _objc_release
0x00018598  mov      x0, x23
0x0001859c  mov      x1, x21
0x000185a0  mov      x2, #0
0x000185a4  bl       #0x559dc   ; CALL _CGGradientCreateWithColors
0x000185a8  mov      x24, x0
0x000185ac  mov      x0, x22
0x000185b0  bl       #0x55ea0   ; CALL objc_msgSend$CGContext
0x000185b4  adrp     x8, #0x74000
0x000185b8  ldr      x8, [x8, #0x5c8]   ; @GOT _CGPointZero
0x000185bc  ldp      d8, d9, [x8]
0x000185c0  fmov     d2, #29.00000000
0x000185c4  fmov     d3, #29.00000000
0x000185c8  mov      x1, x24
0x000185cc  mov      v0.16b, v8.16b
0x000185d0  mov      v1.16b, v9.16b
0x000185d4  mov      w2, #0
0x000185d8  bl       #0x5591c   ; CALL _CGContextDrawLinearGradient
0x000185dc  mov      x0, x24
0x000185e0  bl       #0x559e8   ; CALL _CGGradientRelease
0x000185e4  adrp     x28, #0x8e000
0x000185e8  ldr      x0, [x28, #0x910]   ; @CLASS UIColor
0x000185ec  adrp     x8, #0x65000
0x000185f0  ldr      d1, [x8, #0x660]
0x000185f4  fmov     d0, #1.00000000
0x000185f8  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x000185fc  mov      x29, x29
0x00018600  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018604  mov      x25, x0
0x00018608  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0001860c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00018610  str      x0, [sp, #8]
0x00018614  ldr      x0, [x28, #0x910]   ; @CLASS UIColor
0x00018618  fmov     d0, #1.00000000
0x0001861c  fmov     d1, xzr
0x00018620  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x00018624  mov      x29, x29
0x00018628  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001862c  mov      x26, x0
0x00018630  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00018634  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00018638  str      x0, [sp, #0x10]
0x0001863c  ldr      x0, [x27, #0x960]   ; @CLASS NSArray
0x00018640  add      x2, sp, #8
0x00018644  mov      w3, #2
0x00018648  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0001864c  mov      x29, x29
0x00018650  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018654  mov      x24, x0
0x00018658  mov      x0, x26
0x0001865c  bl       #0x55d78   ; CALL _objc_release
0x00018660  mov      x0, x25
0x00018664  bl       #0x55d78   ; CALL _objc_release
0x00018668  mov      x0, x23
0x0001866c  mov      x1, x24
0x00018670  mov      x2, #0
0x00018674  bl       #0x559dc   ; CALL _CGGradientCreateWithColors
0x00018678  mov      x25, x0
0x0001867c  mov      x0, x22
0x00018680  bl       #0x55ea0   ; CALL objc_msgSend$CGContext
0x00018684  fmov     d2, xzr
0x00018688  fmov     d3, #14.50000000
0x0001868c  mov      x1, x25
0x00018690  mov      v0.16b, v8.16b
0x00018694  mov      v1.16b, v9.16b
0x00018698  mov      w2, #0
0x0001869c  bl       #0x5591c   ; CALL _CGContextDrawLinearGradient
0x000186a0  mov      x0, x25
0x000186a4  bl       #0x559e8   ; CALL _CGGradientRelease
0x000186a8  mov      x0, x23
0x000186ac  bl       #0x558ec   ; CALL _CGColorSpaceRelease
0x000186b0  mov      x0, x22
0x000186b4  bl       #0x55ea0   ; CALL objc_msgSend$CGContext
0x000186b8  mov      x23, x0
0x000186bc  mov      x0, x22
0x000186c0  bl       #0x55d78   ; CALL _objc_release
0x000186c4  mov      x0, x23
0x000186c8  bl       #0x55958   ; CALL _CGContextRestoreGState
0x000186cc  adrp     x8, #0x8e000
0x000186d0  ldr      x22, [x8, #0xac0]   ; @CLASS UIBezierPath
0x000186d4  fmov     d0, xzr
0x000186d8  fmov     d1, xzr
0x000186dc  fmov     d2, #29.00000000
0x000186e0  fmov     d3, #29.00000000
0x000186e4  fmov     d4, #0.25000000
0x000186e8  fmov     d5, #0.25000000
0x000186ec  bl       #0x55a90   ; CALL _CGRectInset
0x000186f0  adrp     x8, #0x65000
0x000186f4  ldr      d4, [x8, #0x6e0]
0x000186f8  mov      x0, x22
0x000186fc  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x00018700  mov      x29, x29
0x00018704  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018708  mov      x22, x0
0x0001870c  fmov     d8, #0.50000000
0x00018710  fmov     d0, #0.50000000
0x00018714  bl       #0x5b3a0   ; CALL objc_msgSend$setLineWidth:
0x00018718  ldr      x0, [x28, #0x910]   ; @CLASS UIColor
0x0001871c  adrp     x8, #0x65000
0x00018720  ldr      d1, [x8, #0x6e8]
0x00018724  fmov     d0, #1.00000000
0x00018728  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0001872c  mov      x29, x29
0x00018730  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018734  mov      x23, x0
0x00018738  bl       #0x5c360   ; CALL objc_msgSend$setStroke
0x0001873c  mov      x0, x23
0x00018740  bl       #0x55d78   ; CALL _objc_release
0x00018744  mov      x0, x22
0x00018748  bl       #0x5d5e0   ; CALL objc_msgSend$stroke
0x0001874c  ldr      x0, [x20, #0x28]
0x00018750  bl       #0x5cba0   ; CALL objc_msgSend$size
0x00018754  mov      v2.16b, v0.16b
0x00018758  mov      v3.16b, v1.16b
0x0001875c  ldr      x0, [x20, #0x28]
0x00018760  fsub     d0, d10, d0
0x00018764  fmul     d0, d0, d8
0x00018768  fsub     d1, d10, d1
0x0001876c  fmul     d1, d1, d8
0x00018770  bl       #0x578e0   ; CALL objc_msgSend$drawInRect:
0x00018774  mov      x0, x22
0x00018778  bl       #0x55d78   ; CALL _objc_release
0x0001877c  mov      x0, x24
0x00018780  bl       #0x55d78   ; CALL _objc_release
0x00018784  mov      x0, x21
0x00018788  bl       #0x55d78   ; CALL _objc_release
0x0001878c  mov      x0, x19
0x00018790  bl       #0x55d78   ; CALL _objc_release
0x00018794  ldr      x8, [sp, #0x28]
0x00018798  adrp     x9, #0x74000
0x0001879c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000187a0  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000187a4  cmp      x9, x8
0x000187a8  b.ne     #0x187d4
0x000187ac  ldp      x29, x30, [sp, #0xa0]
0x000187b0  ldp      x20, x19, [sp, #0x90]
0x000187b4  ldp      x22, x21, [sp, #0x80]
0x000187b8  ldp      x24, x23, [sp, #0x70]
0x000187bc  ldp      x26, x25, [sp, #0x60]
0x000187c0  ldp      x28, x27, [sp, #0x50]
0x000187c4  ldp      d9, d8, [sp, #0x40]
0x000187c8  ldp      d11, d10, [sp, #0x30]
0x000187cc  add      sp, sp, #0xb0
0x000187d0  ret      
0x000187d4  bl       #0x55b98   ; CALL ___stack_chk_fail

=== _OMCStyleTable  va=0x18828 size=608 types=
0x00018828  sub      sp, sp, #0x90
0x0001882c  stp      x26, x25, [sp, #0x40]
0x00018830  stp      x24, x23, [sp, #0x50]
0x00018834  stp      x22, x21, [sp, #0x60]
0x00018838  stp      x20, x19, [sp, #0x70]
0x0001883c  stp      x29, x30, [sp, #0x80]
0x00018840  add      x29, sp, #0x80
0x00018844  mov      x19, x0
0x00018848  bl       #0x55d84   ; CALL _objc_retain
0x0001884c  mov      w0, #0xf5fb
0x00018850  movk     w0, #0xf4, lsl #16
0x00018854  mov      w1, #0xf16
0x00018858  movk     w1, #0xe, lsl #16
0x0001885c  bl       #0x17ea0
0x00018860  mov      x29, x29
0x00018864  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018868  mov      x20, x0
0x0001886c  mov      x0, x19
0x00018870  mov      x2, x20
0x00018874  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x00018878  mov      x0, x20
0x0001887c  bl       #0x55d78   ; CALL _objc_release
0x00018880  mov      w0, #0x6cf6
0x00018884  movk     w0, #0x7b, lsl #16
0x00018888  mov      w1, #0x9bff
0x0001888c  movk     w1, #0xa8, lsl #16
0x00018890  bl       #0x17ea0
0x00018894  mov      x29, x29
0x00018898  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001889c  mov      x20, x0
0x000188a0  mov      x0, x19
0x000188a4  mov      x2, x20
0x000188a8  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x000188ac  mov      x0, x20
0x000188b0  bl       #0x55d78   ; CALL _objc_release
0x000188b4  mov      x0, x19
0x000188b8  bl       #0x5dc60   ; CALL objc_msgSend$traitCollection
0x000188bc  mov      x29, x29
0x000188c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000188c4  mov      x20, x0
0x000188c8  bl       #0x5de60   ; CALL objc_msgSend$userInterfaceStyle
0x000188cc  mov      x22, x0
0x000188d0  cmp      x0, #2
0x000188d4  cset     w25, eq
0x000188d8  mov      x0, x20
0x000188dc  bl       #0x55d78   ; CALL _objc_release
0x000188e0  adrp     x8, #0x8e000
0x000188e4  ldr      x0, [x8, #0x918]   ; @CLASS UIView
0x000188e8  bl       #0x55d60   ; CALL _objc_opt_new
0x000188ec  mov      x20, x0
0x000188f0  mov      w0, #0xf5fb
0x000188f4  movk     w0, #0xf4, lsl #16
0x000188f8  mov      w1, #0xf16
0x000188fc  movk     w1, #0xe, lsl #16
0x00018900  bl       #0x17ea0
0x00018904  mov      x29, x29
0x00018908  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001890c  mov      x21, x0
0x00018910  mov      x0, x20
0x00018914  mov      x2, x21
0x00018918  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0001891c  mov      x0, x21
0x00018920  bl       #0x55d78   ; CALL _objc_release
0x00018924  adrp     x8, #0x8e000
0x00018928  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x0001892c  bl       #0x55c7c   ; CALL _objc_alloc
0x00018930  mov      x21, x0
0x00018934  adrp     x26, #0x90000
0x00018938  add      x26, x26, #8
0x0001893c  ldr      x23, [x26, w25, uxtw #3]
0x00018940  adrp     x24, #0x65000
0x00018944  cbz      x23, #0x18954
0x00018948  mov      x0, x23
0x0001894c  bl       #0x55d84   ; CALL _objc_retain
0x00018950  b        #0x189e4
0x00018954  cmp      x22, #2
0x00018958  cset     w23, eq
0x0001895c  adrp     x8, #0x8e000
0x00018960  ldr      x0, [x8, #0xb00]   ; @CLASS UIGraphicsImageRenderer
0x00018964  bl       #0x55c7c   ; CALL _objc_alloc
0x00018968  mov      x8, #0x4079000000000000
0x0001896c  fmov     d0, x8
0x00018970  ldr      d1, [x24, #0x6f0]
0x00018974  bl       #0x58540   ; CALL objc_msgSend$initWithSize:
0x00018978  mov      x22, x0
0x0001897c  adrp     x8, #0x74000
0x00018980  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00018984  str      x8, [sp, #8]
0x00018988  adrp     x8, #0x65000
0x0001898c  ldr      d0, [x8, #0x6f8]
0x00018990  str      d0, [sp, #0x10]
0x00018994  adrp     x8, #0x19000
0x00018998  add      x8, x8, #0x42c
0x0001899c  adrp     x9, #0x74000
0x000189a0  add      x9, x9, #0x950
0x000189a4  stp      x8, x9, [sp, #0x18]
0x000189a8  strb     w23, [sp, #0x38]
0x000189ac  adrp     x8, #0x65000
0x000189b0  ldr      q0, [x8, #0x710]
0x000189b4  stur     q0, [sp, #0x28]
0x000189b8  add      x2, sp, #8
0x000189bc  bl       #0x58140   ; CALL objc_msgSend$imageWithActions:
0x000189c0  mov      x29, x29
0x000189c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000189c8  mov      x23, x0
0x000189cc  bl       #0x55d84   ; CALL _objc_retain
0x000189d0  ldr      x0, [x26, w25, uxtw #3]
0x000189d4  str      x23, [x26, w25, uxtw #3]
0x000189d8  bl       #0x55d78   ; CALL _objc_release
0x000189dc  mov      x0, x22
0x000189e0  bl       #0x55d78   ; CALL _objc_release
0x000189e4  mov      x0, x21
0x000189e8  mov      x2, x23
0x000189ec  bl       #0x584c0   ; CALL objc_msgSend$initWithImage:
0x000189f0  mov      x21, x0
0x000189f4  mov      x0, x23
0x000189f8  bl       #0x55d78   ; CALL _objc_release
0x000189fc  mov      x0, x19
0x00018a00  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00018a04  mov      x8, #0x4079000000000000
0x00018a08  fmov     d0, x8
0x00018a0c  fcmp     d2, d0
0x00018a10  fcsel    d2, d0, d2, mi
0x00018a14  ldr      d3, [x24, #0x6f0]
0x00018a18  fmov     d0, xzr
0x00018a1c  fmov     d1, xzr
0x00018a20  mov      x0, x21
0x00018a24  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00018a28  mov      x0, x21
0x00018a2c  mov      w2, #2
0x00018a30  bl       #0x5a500   ; CALL objc_msgSend$setAutoresizingMask:
0x00018a34  mov      x0, x21
0x00018a38  mov      x2, #0
0x00018a3c  bl       #0x5aa40   ; CALL objc_msgSend$setContentMode:
0x00018a40  mov      x0, x20
0x00018a44  mov      x2, x21
0x00018a48  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00018a4c  mov      x0, x19
0x00018a50  mov      x2, x20
0x00018a54  bl       #0x5a5a0   ; CALL objc_msgSend$setBackgroundView:
0x00018a58  mov      x0, x21
0x00018a5c  bl       #0x55d78   ; CALL _objc_release
0x00018a60  mov      x0, x20
0x00018a64  bl       #0x55d78   ; CALL _objc_release
0x00018a68  mov      x0, x19
0x00018a6c  ldp      x29, x30, [sp, #0x80]
0x00018a70  ldp      x20, x19, [sp, #0x70]
0x00018a74  ldp      x22, x21, [sp, #0x60]
0x00018a78  ldp      x24, x23, [sp, #0x50]
0x00018a7c  ldp      x26, x25, [sp, #0x40]
0x00018a80  add      sp, sp, #0x90
0x00018a84  b        #0x55d78   ; CALL _objc_release

=== _OMCStyleGlassCard  va=0x18a88 size=456 types=
0x00018a88  stp      x24, x23, [sp, #-0x40]!
0x00018a8c  stp      x22, x21, [sp, #0x10]
0x00018a90  stp      x20, x19, [sp, #0x20]
0x00018a94  stp      x29, x30, [sp, #0x30]
0x00018a98  add      x29, sp, #0x30
0x00018a9c  mov      x19, x0
0x00018aa0  adrp     x23, #0x8e000
0x00018aa4  ldr      x20, [x23, #0x910]   ; @CLASS UIColor
0x00018aa8  bl       #0x55d84   ; CALL _objc_retain
0x00018aac  adrp     x2, #0x74000
0x00018ab0  add      x2, x2, #0x8a0
0x00018ab4  mov      x0, x20
0x00018ab8  bl       #0x56ea0   ; CALL objc_msgSend$colorWithDynamicProvider:
0x00018abc  mov      x29, x29
0x00018ac0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018ac4  mov      x20, x0
0x00018ac8  mov      x0, x19
0x00018acc  mov      x2, x20
0x00018ad0  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x00018ad4  mov      x0, x20
0x00018ad8  bl       #0x55d78   ; CALL _objc_release
0x00018adc  mov      x0, x19
0x00018ae0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00018ae4  mov      x29, x29
0x00018ae8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018aec  mov      x20, x0
0x00018af0  fmov     d0, #0.50000000
0x00018af4  bl       #0x5a740   ; CALL objc_msgSend$setBorderWidth:
0x00018af8  mov      x0, x20
0x00018afc  bl       #0x55d78   ; CALL _objc_release
0x00018b00  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x00018b04  adrp     x8, #0x65000
0x00018b08  ldr      d1, [x8, #0x700]
0x00018b0c  fmov     d0, #1.00000000
0x00018b10  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x00018b14  mov      x29, x29
0x00018b18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018b1c  mov      x20, x0
0x00018b20  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00018b24  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00018b28  mov      x21, x0
0x00018b2c  mov      x0, x19
0x00018b30  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00018b34  mov      x29, x29
0x00018b38  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018b3c  mov      x22, x0
0x00018b40  mov      x2, x21
0x00018b44  bl       #0x5a700   ; CALL objc_msgSend$setBorderColor:
0x00018b48  mov      x0, x22
0x00018b4c  bl       #0x55d78   ; CALL _objc_release
0x00018b50  mov      x0, x20
0x00018b54  bl       #0x55d78   ; CALL _objc_release
0x00018b58  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x00018b5c  adrp     x8, #0x65000
0x00018b60  ldr      d0, [x8, #0x648]
0x00018b64  adrp     x8, #0x65000
0x00018b68  ldr      d1, [x8, #0x650]
0x00018b6c  adrp     x8, #0x65000
0x00018b70  ldr      d2, [x8, #0x658]
0x00018b74  fmov     d3, #1.00000000
0x00018b78  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00018b7c  mov      x29, x29
0x00018b80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018b84  mov      x20, x0
0x00018b88  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00018b8c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00018b90  mov      x21, x0
0x00018b94  mov      x0, x19
0x00018b98  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00018b9c  mov      x29, x29
0x00018ba0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018ba4  mov      x22, x0
0x00018ba8  mov      x2, x21
0x00018bac  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x00018bb0  mov      x0, x22
0x00018bb4  bl       #0x55d78   ; CALL _objc_release
0x00018bb8  mov      x0, x20
0x00018bbc  bl       #0x55d78   ; CALL _objc_release
0x00018bc0  mov      x0, x19
0x00018bc4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00018bc8  mov      x29, x29
0x00018bcc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018bd0  mov      x20, x0
0x00018bd4  adrp     x8, #0x65000
0x00018bd8  ldr      s0, [x8, #0x720]
0x00018bdc  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x00018be0  mov      x0, x20
0x00018be4  bl       #0x55d78   ; CALL _objc_release
0x00018be8  mov      x0, x19
0x00018bec  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00018bf0  mov      x29, x29
0x00018bf4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018bf8  mov      x20, x0
0x00018bfc  fmov     d0, #14.00000000
0x00018c00  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x00018c04  mov      x0, x20
0x00018c08  bl       #0x55d78   ; CALL _objc_release
0x00018c0c  mov      x0, x19
0x00018c10  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00018c14  mov      x29, x29
0x00018c18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018c1c  mov      x20, x0
0x00018c20  mov      x0, x19
0x00018c24  bl       #0x55d78   ; CALL _objc_release
0x00018c28  fmov     d0, xzr
0x00018c2c  fmov     d1, #6.00000000
0x00018c30  mov      x0, x20
0x00018c34  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x00018c38  mov      x0, x20
0x00018c3c  ldp      x29, x30, [sp, #0x30]
0x00018c40  ldp      x20, x19, [sp, #0x20]
0x00018c44  ldp      x22, x21, [sp, #0x10]
0x00018c48  ldp      x24, x23, [sp], #0x40
0x00018c4c  b        #0x55d78   ; CALL _objc_release

=== _OMCEnabled  va=0x18c50 size=100 types=
0x00018c50  stp      x20, x19, [sp, #-0x20]!
0x00018c54  stp      x29, x30, [sp, #0x10]
0x00018c58  add      x29, sp, #0x10
0x00018c5c  bl       #0x54bb0   ; CALL _OMCExpired
0x00018c60  tbz      w0, #0, #0x18c6c
0x00018c64  mov      w20, #0
0x00018c68  b        #0x18ca4
0x00018c6c  adrp     x0, #0x78000
0x00018c70  add      x0, x0, #0x988   ; STR "enabled"
0x00018c74  adrp     x1, #0x75000
0x00018c78  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x00018c7c  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x00018c80  mov      x19, x0
0x00018c84  cbz      x0, #0x18c98
0x00018c88  mov      x0, x19
0x00018c8c  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00018c90  mov      x20, x0
0x00018c94  b        #0x18c9c
0x00018c98  mov      w20, #1
0x00018c9c  mov      x0, x19
0x00018ca0  bl       #0x55d78   ; CALL _objc_release
0x00018ca4  mov      x0, x20
0x00018ca8  ldp      x29, x30, [sp, #0x10]
0x00018cac  ldp      x20, x19, [sp], #0x20
0x00018cb0  ret      

=== _OMCLocalizeSpecifiers  va=0x18cb4 size=1204 types=
0x00018cb4  sub      sp, sp, #0x180
0x00018cb8  stp      d9, d8, [sp, #0x110]
0x00018cbc  stp      x28, x27, [sp, #0x120]
0x00018cc0  stp      x26, x25, [sp, #0x130]
0x00018cc4  stp      x24, x23, [sp, #0x140]
0x00018cc8  stp      x22, x21, [sp, #0x150]
0x00018ccc  stp      x20, x19, [sp, #0x160]
0x00018cd0  stp      x29, x30, [sp, #0x170]
0x00018cd4  add      x29, sp, #0x170
0x00018cd8  mov      x19, x0
0x00018cdc  adrp     x8, #0x74000
0x00018ce0  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00018ce4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00018ce8  stur     x8, [x29, #-0x70]
0x00018cec  bl       #0x55d84   ; CALL _objc_retain
0x00018cf0  movi     v0.16b, #0
0x00018cf4  stp      q0, q0, [sp, #0x40]
0x00018cf8  stp      q0, q0, [sp, #0x60]
0x00018cfc  add      x2, sp, #0x40
0x00018d00  add      x3, sp, #0x80
0x00018d04  mov      x0, x19
0x00018d08  mov      w4, #0x10
0x00018d0c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00018d10  str      x0, [sp, #0x10]
0x00018d14  cbz      x0, #0x190bc
0x00018d18  adrp     x21, #0x78000
0x00018d1c  add      x21, x21, #0x6e8   ; STR "footerText"
0x00018d20  ldr      x8, [sp, #0x50]
0x00018d24  adrp     x22, #0x78000
0x00018d28  add      x22, x22, #0x848   ; STR "symbol"
0x00018d2c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00018d30  str      x8, [sp, #8]
0x00018d34  adrp     x8, #0x65000
0x00018d38  ldr      d8, [x8, #0x600]
0x00018d3c  mov      x20, #0
0x00018d40  ldr      x8, [sp, #0x50]
0x00018d44  ldr      x8, [x8]   ; @CSTR "m.fill"
0x00018d48  ldr      x9, [sp, #8]
0x00018d4c  cmp      x8, x9
0x00018d50  b.eq     #0x18d5c
0x00018d54  mov      x0, x19
0x00018d58  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00018d5c  ldr      x8, [sp, #0x48]
0x00018d60  ldr      x28, [x8, x20, lsl #3]
0x00018d64  mov      x0, x28
0x00018d68  bl       #0x590e0   ; CALL objc_msgSend$name
0x00018d6c  mov      x29, x29
0x00018d70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018d74  mov      x23, x0
0x00018d78  bl       #0x58c20   ; CALL objc_msgSend$length
0x00018d7c  mov      x24, x0
0x00018d80  mov      x0, x23
0x00018d84  bl       #0x55d78   ; CALL _objc_release
0x00018d88  cbz      x24, #0x18dcc
0x00018d8c  mov      x0, x28
0x00018d90  bl       #0x590e0   ; CALL objc_msgSend$name
0x00018d94  mov      x29, x29
0x00018d98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018d9c  mov      x23, x0
0x00018da0  bl       #0x17e20   ; CALL _L
0x00018da4  mov      x29, x29
0x00018da8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018dac  mov      x24, x0
0x00018db0  mov      x0, x28
0x00018db4  mov      x2, x24
0x00018db8  bl       #0x5b700   ; CALL objc_msgSend$setName:
0x00018dbc  mov      x0, x24
0x00018dc0  bl       #0x55d78   ; CALL _objc_release
0x00018dc4  mov      x0, x23
0x00018dc8  bl       #0x55d78   ; CALL _objc_release
0x00018dcc  mov      x0, x28
0x00018dd0  mov      x2, x21
0x00018dd4  bl       #0x59aa0   ; CALL objc_msgSend$propertyForKey:
0x00018dd8  mov      x29, x29
0x00018ddc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018de0  mov      x24, x0
0x00018de4  cbz      x0, #0x18e14
0x00018de8  mov      x0, x24
0x00018dec  bl       #0x17e20   ; CALL _L
0x00018df0  mov      x29, x29
0x00018df4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018df8  mov      x23, x0
0x00018dfc  mov      x0, x28
0x00018e00  mov      x2, x23
0x00018e04  mov      x3, x21
0x00018e08  bl       #0x5bd60   ; CALL objc_msgSend$setProperty:forKey:
0x00018e0c  mov      x0, x23
0x00018e10  bl       #0x55d78   ; CALL _objc_release
0x00018e14  mov      x0, x28
0x00018e18  bl       #0x5db60   ; CALL objc_msgSend$titleDictionary
0x00018e1c  mov      x29, x29
0x00018e20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018e24  mov      x23, x0
0x00018e28  bl       #0x573c0   ; CALL objc_msgSend$count
0x00018e2c  cbz      x0, #0x18eec
0x00018e30  mov      x0, x28
0x00018e34  adrp     x2, #0x78000
0x00018e38  add      x2, x2, #0xe08   ; STR "dynamicTitles"
0x00018e3c  bl       #0x59aa0   ; CALL objc_msgSend$propertyForKey:
0x00018e40  mov      x29, x29
0x00018e44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018e48  mov      x25, x0
0x00018e4c  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00018e50  mov      x26, x0
0x00018e54  mov      x0, x25
0x00018e58  bl       #0x55d78   ; CALL _objc_release
0x00018e5c  mov      x0, x23
0x00018e60  bl       #0x55d78   ; CALL _objc_release
0x00018e64  tbnz     w26, #0, #0x18ef4
0x00018e68  adrp     x8, #0x8e000
0x00018e6c  ldr      x0, [x8, #0x9d0]   ; @CLASS NSMutableDictionary
0x00018e70  bl       #0x57780   ; CALL objc_msgSend$dictionary
0x00018e74  mov      x29, x29
0x00018e78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018e7c  mov      x23, x0
0x00018e80  mov      x0, x28
0x00018e84  bl       #0x5db60   ; CALL objc_msgSend$titleDictionary
0x00018e88  mov      x29, x29
0x00018e8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018e90  mov      x25, x0
0x00018e94  adrp     x8, #0x74000
0x00018e98  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00018e9c  str      x8, [sp, #0x18]
0x00018ea0  str      d8, [sp, #0x20]
0x00018ea4  adrp     x8, #0x19000
0x00018ea8  add      x9, x8, #0x104
0x00018eac  adrp     x8, #0x74000
0x00018eb0  add      x8, x8, #0x8f0
0x00018eb4  stp      x9, x8, [sp, #0x28]
0x00018eb8  str      x23, [sp, #0x38]
0x00018ebc  mov      x0, x23
0x00018ec0  bl       #0x55d84   ; CALL _objc_retain
0x00018ec4  add      x2, sp, #0x18
0x00018ec8  mov      x0, x25
0x00018ecc  bl       #0x579e0   ; CALL objc_msgSend$enumerateKeysAndObjectsUsingBlock:
0x00018ed0  mov      x0, x25
0x00018ed4  bl       #0x55d78   ; CALL _objc_release
0x00018ed8  mov      x0, x28
0x00018edc  mov      x2, x23
0x00018ee0  bl       #0x5c640   ; CALL objc_msgSend$setTitleDictionary:
0x00018ee4  ldr      x0, [sp, #0x38]
0x00018ee8  bl       #0x55d78   ; CALL _objc_release
0x00018eec  mov      x0, x23
0x00018ef0  bl       #0x55d78   ; CALL _objc_release
0x00018ef4  mov      x0, x28
0x00018ef8  mov      x2, x22
0x00018efc  bl       #0x59aa0   ; CALL objc_msgSend$propertyForKey:
0x00018f00  mov      x29, x29
0x00018f04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018f08  mov      x23, x0
0x00018f0c  cbz      x0, #0x18f90
0x00018f10  mov      x0, x28
0x00018f14  adrp     x2, #0x78000
0x00018f18  add      x2, x2, #0xe28   ; STR "symbolColor"
0x00018f1c  bl       #0x59aa0   ; CALL objc_msgSend$propertyForKey:
0x00018f20  mov      x29, x29
0x00018f24  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018f28  mov      x26, x0
0x00018f2c  cmp      x0, #0
0x00018f30  adrp     x8, #0x78000
0x00018f34  add      x8, x8, #0xe48   ; STR "#0A59F7"
0x00018f38  csel     x0, x8, x0, eq
0x00018f3c  bl       #0x18080   ; CALL _OMCColorFromHex
0x00018f40  mov      x29, x29
0x00018f44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018f48  mov      x27, x0
0x00018f4c  mov      x0, x23
0x00018f50  mov      x1, x27
0x00018f54  bl       #0x18144   ; CALL _OMCIcon
0x00018f58  mov      x29, x29
0x00018f5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018f60  mov      x25, x0
0x00018f64  mov      x0, x27
0x00018f68  bl       #0x55d78   ; CALL _objc_release
0x00018f6c  mov      x0, x26
0x00018f70  bl       #0x55d78   ; CALL _objc_release
0x00018f74  cbz      x25, #0x19078
0x00018f78  mov      x0, x28
0x00018f7c  mov      x2, x25
0x00018f80  adrp     x3, #0x78000
0x00018f84  add      x3, x3, #0xe68   ; STR "iconImage"
0x00018f88  bl       #0x5bd60   ; CALL objc_msgSend$setProperty:forKey:
0x00018f8c  b        #0x19078
0x00018f90  mov      x0, x28
0x00018f94  adrp     x2, #0x78000
0x00018f98  add      x2, x2, #0x808   ; STR "icon"
0x00018f9c  bl       #0x59aa0   ; CALL objc_msgSend$propertyForKey:
0x00018fa0  mov      x29, x29
0x00018fa4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018fa8  mov      x25, x0
0x00018fac  adrp     x8, #0x8e000
0x00018fb0  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00018fb4  bl       #0x55d48   ; CALL _objc_opt_class
0x00018fb8  mov      x1, x0
0x00018fbc  mov      x0, x25
0x00018fc0  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00018fc4  tbz      w0, #0, #0x19078
0x00018fc8  mov      x22, x21
0x00018fcc  mov      x21, x19
0x00018fd0  adrp     x8, #0x8e000
0x00018fd4  ldr      x26, [x8, #0x9d8]   ; @CLASS NSBundle
0x00018fd8  adrp     x0, #0x76000
0x00018fdc  add      x0, x0, #0xf28   ; STR "OMCRootListController"
0x00018fe0  bl       #0x55af0   ; CALL _NSClassFromString
0x00018fe4  mov      x2, x0
0x00018fe8  mov      x0, x26
0x00018fec  bl       #0x56b40   ; CALL objc_msgSend$bundleForClass:
0x00018ff0  mov      x29, x29
0x00018ff4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018ff8  mov      x26, x0
0x00018ffc  adrp     x8, #0x8e000
0x00019000  ldr      x27, [x8, #0xa78]   ; @CLASS UIImage
0x00019004  mov      x0, x25
0x00019008  bl       #0x5d480   ; CALL objc_msgSend$stringByDeletingPathExtension
0x0001900c  mov      x29, x29
0x00019010  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019014  mov      x19, x0
0x00019018  mov      x0, x27
0x0001901c  mov      x2, x19
0x00019020  mov      x3, x26
0x00019024  mov      x4, #0
0x00019028  bl       #0x58100   ; CALL objc_msgSend$imageNamed:inBundle:compatibleWithTraitCollection:
0x0001902c  mov      x29, x29
0x00019030  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019034  mov      x27, x0
0x00019038  mov      x0, x19
0x0001903c  bl       #0x55d78   ; CALL _objc_release
0x00019040  cbz      x27, #0x19058
0x00019044  mov      x0, x28
0x00019048  mov      x2, x27
0x0001904c  adrp     x3, #0x78000
0x00019050  add      x3, x3, #0xe68   ; STR "iconImage"
0x00019054  bl       #0x5bd60   ; CALL objc_msgSend$setProperty:forKey:
0x00019058  mov      x0, x27
0x0001905c  bl       #0x55d78   ; CALL _objc_release
0x00019060  mov      x0, x26
0x00019064  bl       #0x55d78   ; CALL _objc_release
0x00019068  mov      x19, x21
0x0001906c  mov      x21, x22
0x00019070  adrp     x22, #0x78000
0x00019074  add      x22, x22, #0x848   ; STR "symbol"
0x00019078  mov      x0, x25
0x0001907c  bl       #0x55d78   ; CALL _objc_release
0x00019080  mov      x0, x23
0x00019084  bl       #0x55d78   ; CALL _objc_release
0x00019088  mov      x0, x24
0x0001908c  bl       #0x55d78   ; CALL _objc_release
0x00019090  add      x20, x20, #1
0x00019094  ldr      x8, [sp, #0x10]
0x00019098  cmp      x8, x20
0x0001909c  b.ne     #0x18d40
0x000190a0  add      x2, sp, #0x40
0x000190a4  add      x3, sp, #0x80
0x000190a8  mov      x0, x19
0x000190ac  mov      w4, #0x10
0x000190b0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000190b4  str      x0, [sp, #0x10]
0x000190b8  cbnz     x0, #0x18d3c
0x000190bc  mov      x0, x19
0x000190c0  bl       #0x55d78   ; CALL _objc_release
0x000190c4  ldur     x8, [x29, #-0x70]
0x000190c8  adrp     x9, #0x74000
0x000190cc  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000190d0  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000190d4  cmp      x9, x8
0x000190d8  b.ne     #0x19100
0x000190dc  ldp      x29, x30, [sp, #0x170]
0x000190e0  ldp      x20, x19, [sp, #0x160]
0x000190e4  ldp      x22, x21, [sp, #0x150]
0x000190e8  ldp      x24, x23, [sp, #0x140]
0x000190ec  ldp      x26, x25, [sp, #0x130]
0x000190f0  ldp      x28, x27, [sp, #0x120]
0x000190f4  ldp      d9, d8, [sp, #0x110]
0x000190f8  add      sp, sp, #0x180
0x000190fc  ret      
0x00019100  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00019104  stp      x22, x21, [sp, #-0x30]!
0x00019108  stp      x20, x19, [sp, #0x10]
0x0001910c  stp      x29, x30, [sp, #0x20]
0x00019110  add      x29, sp, #0x20
0x00019114  mov      x19, x2
0x00019118  mov      x20, x1
0x0001911c  mov      x21, x0
0x00019120  mov      x0, x1
0x00019124  bl       #0x55d84   ; CALL _objc_retain
0x00019128  mov      x0, x19
0x0001912c  bl       #0x17e20   ; CALL _L
0x00019130  mov      x29, x29
0x00019134  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019138  mov      x19, x0
0x0001913c  ldr      x0, [x21, #0x20]   ; @STR "conflictsGroup"
0x00019140  mov      x2, x19
0x00019144  mov      x3, x20
0x00019148  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0001914c  mov      x0, x20
0x00019150  bl       #0x55d78   ; CALL _objc_release
0x00019154  mov      x0, x19
0x00019158  ldp      x29, x30, [sp, #0x20]
0x0001915c  ldp      x20, x19, [sp, #0x10]
0x00019160  ldp      x22, x21, [sp], #0x30
0x00019164  b        #0x55d78   ; CALL _objc_release

=== _OMCStyleCell  va=0x19168 size=408 types=
0x00019168  stp      x24, x23, [sp, #-0x40]!
0x0001916c  stp      x22, x21, [sp, #0x10]
0x00019170  stp      x20, x19, [sp, #0x20]
0x00019174  stp      x29, x30, [sp, #0x30]
0x00019178  add      x29, sp, #0x30
0x0001917c  mov      x19, x0
0x00019180  bl       #0x55d84   ; CALL _objc_retain
0x00019184  adrp     x23, #0x8e000
0x00019188  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0001918c  adrp     x2, #0x74000
0x00019190  add      x2, x2, #0x8a0
0x00019194  bl       #0x56ea0   ; CALL objc_msgSend$colorWithDynamicProvider:
0x00019198  mov      x29, x29
0x0001919c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000191a0  mov      x20, x0
0x000191a4  mov      x0, x19
0x000191a8  mov      x2, x20
0x000191ac  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x000191b0  mov      x0, x20
0x000191b4  bl       #0x55d78   ; CALL _objc_release
0x000191b8  adrp     x8, #0x8e000
0x000191bc  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x000191c0  adrp     x8, #0x74000
0x000191c4  ldr      x8, [x8, #0x250]   ; @GOT _UIFontWeightMedium
0x000191c8  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x000191cc  fmov     d0, #16.00000000
0x000191d0  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x000191d4  mov      x29, x29
0x000191d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000191dc  mov      x20, x0
0x000191e0  mov      x0, x19
0x000191e4  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x000191e8  mov      x29, x29
0x000191ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000191f0  mov      x21, x0
0x000191f4  mov      x2, x20
0x000191f8  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x000191fc  mov      x0, x21
0x00019200  bl       #0x55d78   ; CALL _objc_release
0x00019204  mov      x0, x20
0x00019208  bl       #0x55d78   ; CALL _objc_release
0x0001920c  adrp     x8, #0x8e000
0x00019210  ldr      x0, [x8, #0xb08]   ; @CLASS PSTableCell
0x00019214  bl       #0x55d48   ; CALL _objc_opt_class
0x00019218  mov      x1, x0
0x0001921c  mov      x0, x19
0x00019220  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00019224  tbz      w0, #0, #0x19240
0x00019228  mov      x0, x19
0x0001922c  bl       #0x5cdc0   ; CALL objc_msgSend$specifier
0x00019230  mov      x29, x29
0x00019234  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019238  mov      x20, x0
0x0001923c  b        #0x19244
0x00019240  mov      x20, #0
0x00019244  mov      x0, x20
0x00019248  bl       #0x56ce0   ; CALL objc_msgSend$cellType
0x0001924c  cmp      x0, #0xd
0x00019250  b.ne     #0x192e0
0x00019254  adrp     x2, #0x78000
0x00019258  add      x2, x2, #0xe88   ; STR "isDestructive"
0x0001925c  mov      x0, x20
0x00019260  bl       #0x59aa0   ; CALL objc_msgSend$propertyForKey:
0x00019264  mov      x29, x29
0x00019268  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001926c  mov      x22, x0
0x00019270  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00019274  mov      x21, x0
0x00019278  mov      x0, x22
0x0001927c  bl       #0x55d78   ; CALL _objc_release
0x00019280  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x00019284  cbz      w21, #0x19298
0x00019288  bl       #0x5d880   ; CALL objc_msgSend$systemRedColor
0x0001928c  mov      x29, x29
0x00019290  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019294  b        #0x192a4
0x00019298  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x0001929c  mov      x29, x29
0x000192a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000192a4  mov      x22, x0
0x000192a8  mov      x0, x19
0x000192ac  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x000192b0  mov      x29, x29
0x000192b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000192b8  mov      x23, x0
0x000192bc  mov      x2, x22
0x000192c0  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x000192c4  mov      x0, x23
0x000192c8  bl       #0x55d78   ; CALL _objc_release
0x000192cc  mov      x0, x22
0x000192d0  bl       #0x55d78   ; CALL _objc_release
0x000192d4  eor      w2, w21, #1
0x000192d8  mov      x0, x19
0x000192dc  bl       #0x5a2a0   ; CALL objc_msgSend$setAccessoryType:
0x000192e0  mov      x0, x20
0x000192e4  bl       #0x55d78   ; CALL _objc_release
0x000192e8  mov      x0, x19
0x000192ec  ldp      x29, x30, [sp, #0x30]
0x000192f0  ldp      x20, x19, [sp, #0x20]
0x000192f4  ldp      x22, x21, [sp, #0x10]
0x000192f8  ldp      x24, x23, [sp], #0x40
0x000192fc  b        #0x55d78   ; CALL _objc_release

=== _OMCStyleHeaderFooter  va=0x19300 size=1288 types=
0x00019300  stp      x22, x21, [sp, #-0x30]!
0x00019304  stp      x20, x19, [sp, #0x10]
0x00019308  stp      x29, x30, [sp, #0x20]
0x0001930c  add      x29, sp, #0x20
0x00019310  mov      x21, x1
0x00019314  mov      x19, x0
0x00019318  bl       #0x55d84   ; CALL _objc_retain
0x0001931c  adrp     x8, #0x8e000
0x00019320  ldr      x0, [x8, #0xb10]   ; @CLASS UITableViewHeaderFooterView
0x00019324  bl       #0x55d48   ; CALL _objc_opt_class
0x00019328  mov      x1, x0
0x0001932c  mov      x0, x19
0x00019330  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00019334  tbz      w0, #0, #0x193d4
0x00019338  mov      x0, x19
0x0001933c  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00019340  mov      x29, x29
0x00019344  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019348  mov      x20, x0
0x0001934c  adrp     x8, #0x8e000
0x00019350  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x00019354  tbz      w21, #0, #0x19378
0x00019358  adrp     x8, #0x74000
0x0001935c  ldr      x8, [x8, #0x250]   ; @GOT _UIFontWeightMedium
0x00019360  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x00019364  fmov     d0, #14.00000000
0x00019368  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x0001936c  mov      x29, x29
0x00019370  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019374  b        #0x19388
0x00019378  fmov     d0, #12.00000000
0x0001937c  bl       #0x5d7c0   ; CALL objc_msgSend$systemFontOfSize:
0x00019380  mov      x29, x29
0x00019384  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019388  mov      x21, x0
0x0001938c  mov      x0, x20
0x00019390  mov      x2, x21
0x00019394  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00019398  mov      x0, x21
0x0001939c  bl       #0x55d78   ; CALL _objc_release
0x000193a0  adrp     x8, #0x8e000
0x000193a4  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x000193a8  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x000193ac  mov      x29, x29
0x000193b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000193b4  mov      x21, x0
0x000193b8  mov      x0, x20
0x000193bc  mov      x2, x21
0x000193c0  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x000193c4  mov      x0, x21
0x000193c8  bl       #0x55d78   ; CALL _objc_release
0x000193cc  mov      x0, x20
0x000193d0  bl       #0x55d78   ; CALL _objc_release
0x000193d4  mov      x0, x19
0x000193d8  ldp      x29, x30, [sp, #0x20]
0x000193dc  ldp      x20, x19, [sp, #0x10]
0x000193e0  ldp      x22, x21, [sp], #0x30
0x000193e4  b        #0x55d78   ; CALL _objc_release
0x000193e8  stp      x20, x19, [sp, #-0x20]!
0x000193ec  stp      x29, x30, [sp, #0x10]
0x000193f0  add      x29, sp, #0x10
0x000193f4  mov      x19, x0
0x000193f8  mov      x0, x1
0x000193fc  bl       #0x5de60   ; CALL objc_msgSend$userInterfaceStyle
0x00019400  cmp      x0, #2
0x00019404  mov      w8, #0x28
0x00019408  mov      w9, #0x20
0x0001940c  csel     x8, x9, x8, eq
0x00019410  ldr      x19, [x19, x8]
0x00019414  mov      x0, x19
0x00019418  bl       #0x55d84   ; CALL _objc_retain
0x0001941c  mov      x0, x19
0x00019420  ldp      x29, x30, [sp, #0x10]
0x00019424  ldp      x20, x19, [sp], #0x20
0x00019428  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0001942c  sub      sp, sp, #0x180
0x00019430  stp      d11, d10, [sp, #0x100]
0x00019434  stp      d9, d8, [sp, #0x110]
0x00019438  stp      x28, x27, [sp, #0x120]
0x0001943c  stp      x26, x25, [sp, #0x130]
0x00019440  stp      x24, x23, [sp, #0x140]
0x00019444  stp      x22, x21, [sp, #0x150]
0x00019448  stp      x20, x19, [sp, #0x160]
0x0001944c  stp      x29, x30, [sp, #0x170]
0x00019450  add      x29, sp, #0x170
0x00019454  mov      x20, x0
0x00019458  adrp     x8, #0x74000
0x0001945c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00019460  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00019464  stur     x8, [x29, #-0x80]
0x00019468  mov      x0, x1
0x0001946c  bl       #0x55ea0   ; CALL objc_msgSend$CGContext
0x00019470  mov      x19, x0
0x00019474  ldrb     w8, [x20, #0x30]
0x00019478  adrp     x9, #0x78000
0x0001947c  add      x9, x9, #0xf68   ; STR "#F4F5FB"
0x00019480  adrp     x10, #0x78000
0x00019484  add      x10, x10, #0xf48   ; STR "#0E0F16"
0x00019488  cmp      w8, #0
0x0001948c  csel     x0, x10, x9, ne
0x00019490  bl       #0x18080   ; CALL _OMCColorFromHex
0x00019494  mov      x29, x29
0x00019498  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001949c  mov      x21, x0
0x000194a0  bl       #0x5ae00   ; CALL objc_msgSend$setFill
0x000194a4  mov      x0, x21
0x000194a8  bl       #0x55d78   ; CALL _objc_release
0x000194ac  ldp      d2, d3, [x20, #0x20]
0x000194b0  mov      x21, x20
0x000194b4  fmov     d0, xzr
0x000194b8  fmov     d1, xzr
0x000194bc  str      x19, [sp, #8]
0x000194c0  mov      x0, x19
0x000194c4  bl       #0x55940   ; CALL _CGContextFillRect
0x000194c8  bl       #0x558d4   ; CALL _CGColorSpaceCreateDeviceRGB
0x000194cc  str      x0, [sp]
0x000194d0  movi     v0.16b, #0
0x000194d4  stp      q0, q0, [sp, #0x10]
0x000194d8  stp      q0, q0, [sp, #0x30]
0x000194dc  adrp     x0, #0x7f000
0x000194e0  add      x0, x0, #0x930
0x000194e4  add      x2, sp, #0x10
0x000194e8  add      x3, sp, #0x70
0x000194ec  mov      w4, #0x10
0x000194f0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000194f4  cbz      x0, #0x196e0
0x000194f8  mov      x22, x0
0x000194fc  ldr      x8, [sp, #0x20]
0x00019500  ldr      x19, [x8]   ; @GOT ___objc_personality_v0
0x00019504  adrp     x8, #0x65000
0x00019508  ldr      d10, [x8, #0x708]
0x0001950c  adrp     x8, #0x65000
0x00019510  ldr      d11, [x8, #0x660]
0x00019514  mov      x20, #0
0x00019518  ldr      x8, [sp, #0x20]
0x0001951c  ldr      x8, [x8]   ; @CSTR "m.fill"
0x00019520  cmp      x8, x19
0x00019524  b.eq     #0x19534
0x00019528  adrp     x0, #0x7f000
0x0001952c  add      x0, x0, #0x930
0x00019530  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00019534  ldr      x8, [sp, #0x18]
0x00019538  ldr      x25, [x8, x20, lsl #3]
0x0001953c  mov      x0, x25
0x00019540  mov      x2, #0
0x00019544  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00019548  mov      x29, x29
0x0001954c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019550  mov      x26, x0
0x00019554  bl       #0x18080   ; CALL _OMCColorFromHex
0x00019558  mov      x29, x29
0x0001955c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019560  mov      x24, x0
0x00019564  mov      x0, x26
0x00019568  bl       #0x55d78   ; CALL _objc_release
0x0001956c  ldrb     w8, [x21, #0x30]
0x00019570  cmp      w8, #0
0x00019574  fcsel    d0, d11, d10, ne
0x00019578  mov      x0, x24
0x0001957c  bl       #0x56e80   ; CALL objc_msgSend$colorWithAlphaComponent:
0x00019580  mov      x29, x29
0x00019584  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019588  mov      x27, x0
0x0001958c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00019590  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00019594  str      x0, [sp, #0x60]
0x00019598  fmov     d0, xzr
0x0001959c  mov      x0, x24
0x000195a0  bl       #0x56e80   ; CALL objc_msgSend$colorWithAlphaComponent:
0x000195a4  mov      x29, x29
0x000195a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000195ac  mov      x28, x0
0x000195b0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000195b4  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000195b8  str      x0, [sp, #0x68]
0x000195bc  adrp     x8, #0x8e000
0x000195c0  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000195c4  add      x2, sp, #0x60
0x000195c8  mov      w3, #2
0x000195cc  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000195d0  mov      x29, x29
0x000195d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000195d8  mov      x26, x0
0x000195dc  mov      x0, x28
0x000195e0  bl       #0x55d78   ; CALL _objc_release
0x000195e4  mov      x0, x27
0x000195e8  bl       #0x55d78   ; CALL _objc_release
0x000195ec  ldr      x0, [sp]
0x000195f0  mov      x1, x26
0x000195f4  mov      x2, #0
0x000195f8  bl       #0x559dc   ; CALL _CGGradientCreateWithColors
0x000195fc  mov      x27, x0
0x00019600  mov      x0, x25
0x00019604  mov      w2, #1
0x00019608  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0001960c  mov      x29, x29
0x00019610  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019614  mov      x28, x0
0x00019618  bl       #0x57880   ; CALL objc_msgSend$doubleValue
0x0001961c  mov      v8.16b, v0.16b
0x00019620  mov      x0, x25
0x00019624  mov      w2, #2
0x00019628  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0001962c  mov      x29, x29
0x00019630  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019634  mov      x23, x0
0x00019638  bl       #0x57880   ; CALL objc_msgSend$doubleValue
0x0001963c  mov      v9.16b, v0.16b
0x00019640  mov      x0, x23
0x00019644  bl       #0x55d78   ; CALL _objc_release
0x00019648  mov      x0, x28
0x0001964c  bl       #0x55d78   ; CALL _objc_release
0x00019650  mov      x0, x25
0x00019654  mov      w2, #3
0x00019658  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0001965c  mov      x29, x29
0x00019660  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019664  mov      x23, x0
0x00019668  bl       #0x57880   ; CALL objc_msgSend$doubleValue
0x0001966c  mov      v5.16b, v0.16b
0x00019670  fmov     d2, xzr
0x00019674  ldr      x0, [sp, #8]
0x00019678  mov      x1, x27
0x0001967c  mov      v0.16b, v8.16b
0x00019680  mov      v1.16b, v9.16b
0x00019684  mov      v3.16b, v8.16b
0x00019688  mov      v4.16b, v9.16b
0x0001968c  mov      w2, #0
0x00019690  bl       #0x55928   ; CALL _CGContextDrawRadialGradient
0x00019694  mov      x0, x23
0x00019698  bl       #0x55d78   ; CALL _objc_release
0x0001969c  mov      x0, x27
0x000196a0  bl       #0x559e8   ; CALL _CGGradientRelease
0x000196a4  mov      x0, x26
0x000196a8  bl       #0x55d78   ; CALL _objc_release
0x000196ac  mov      x0, x24
0x000196b0  bl       #0x55d78   ; CALL _objc_release
0x000196b4  add      x20, x20, #1
0x000196b8  cmp      x22, x20
0x000196bc  b.ne     #0x19518
0x000196c0  add      x2, sp, #0x10
0x000196c4  add      x3, sp, #0x70
0x000196c8  adrp     x0, #0x7f000
0x000196cc  add      x0, x0, #0x930
0x000196d0  mov      w4, #0x10
0x000196d4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000196d8  mov      x22, x0
0x000196dc  cbnz     x0, #0x19514
0x000196e0  ldrb     w8, [x21, #0x30]
0x000196e4  cmp      w8, #0
0x000196e8  adrp     x8, #0x78000
0x000196ec  add      x8, x8, #0xf68   ; STR "#F4F5FB"
0x000196f0  adrp     x9, #0x78000
0x000196f4  add      x9, x9, #0xf48   ; STR "#0E0F16"
0x000196f8  csel     x0, x9, x8, ne
0x000196fc  bl       #0x18080   ; CALL _OMCColorFromHex
0x00019700  mov      x29, x29
0x00019704  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019708  mov      x22, x0
0x0001970c  fmov     d0, xzr
0x00019710  bl       #0x56e80   ; CALL objc_msgSend$colorWithAlphaComponent:
0x00019714  mov      x29, x29
0x00019718  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001971c  mov      x23, x0
0x00019720  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00019724  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00019728  str      x0, [sp, #0x50]
0x0001972c  mov      x0, x22
0x00019730  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00019734  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00019738  str      x0, [sp, #0x58]
0x0001973c  adrp     x8, #0x8e000
0x00019740  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00019744  add      x2, sp, #0x50
0x00019748  mov      w3, #2
0x0001974c  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00019750  mov      x29, x29
0x00019754  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00019758  mov      x24, x0
0x0001975c  mov      x0, x23
0x00019760  bl       #0x55d78   ; CALL _objc_release
0x00019764  ldr      x19, [sp]
0x00019768  mov      x0, x19
0x0001976c  mov      x1, x24
0x00019770  mov      x2, #0
0x00019774  bl       #0x559dc   ; CALL _CGGradientCreateWithColors
0x00019778  mov      x23, x0
0x0001977c  ldr      d3, [x21, #0x28]
0x00019780  adrp     x8, #0x65000
0x00019784  ldr      d0, [x8, #0x6c0]
0x00019788  fmul     d1, d3, d0
0x0001978c  fmov     d0, xzr
0x00019790  fmov     d2, xzr
0x00019794  ldr      x0, [sp, #8]
0x00019798  mov      x1, x23
0x0001979c  mov      w2, #0
0x000197a0  bl       #0x5591c   ; CALL _CGContextDrawLinearGradient
0x000197a4  mov      x0, x23
0x000197a8  bl       #0x559e8   ; CALL _CGGradientRelease
0x000197ac  mov      x0, x19
0x000197b0  bl       #0x558ec   ; CALL _CGColorSpaceRelease
0x000197b4  mov      x0, x24
0x000197b8  bl       #0x55d78   ; CALL _objc_release
0x000197bc  mov      x0, x22
0x000197c0  bl       #0x55d78   ; CALL _objc_release
0x000197c4  ldur     x8, [x29, #-0x80]
0x000197c8  adrp     x9, #0x74000
0x000197cc  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000197d0  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000197d4  cmp      x9, x8
0x000197d8  b.ne     #0x19804
0x000197dc  ldp      x29, x30, [sp, #0x170]
0x000197e0  ldp      x20, x19, [sp, #0x160]
0x000197e4  ldp      x22, x21, [sp, #0x150]
0x000197e8  ldp      x24, x23, [sp, #0x140]
0x000197ec  ldp      x26, x25, [sp, #0x130]
0x000197f0  ldp      x28, x27, [sp, #0x120]
0x000197f4  ldp      d9, d8, [sp, #0x110]
0x000197f8  ldp      d11, d10, [sp, #0x100]
0x000197fc  add      sp, sp, #0x180
0x00019800  ret      
0x00019804  bl       #0x55b98   ; CALL ___stack_chk_fail

=== _SPPVoiceTemplate  va=0x352ac size=256 types=
0x000352ac  stp      x29, x30, [sp, #-0x10]!
0x000352b0  mov      x29, sp
0x000352b4  cmp      x0, #3
0x000352b8  b.le     #0x352e8
0x000352bc  cmp      x0, #5
0x000352c0  b.gt     #0x35314
0x000352c4  cmp      x0, #4
0x000352c8  b.eq     #0x35360
0x000352cc  cmp      x0, #5
0x000352d0  b.ne     #0x3534c
0x000352d4  adrp     x0, #0x7b000
0x000352d8  add      x0, x0, #0x588   ; STR "Camera phạt nguội đang mỉm cười với bạn đó"
0x000352dc  adrp     x1, #0x7b000
0x000352e0  add      x1, x1, #0x5a8   ; STR "The speed camera is smiling at you"
0x000352e4  b        #0x35398
0x000352e8  cmp      x0, #1
0x000352ec  b.eq     #0x35338
0x000352f0  cmp      x0, #2
0x000352f4  b.eq     #0x35388
0x000352f8  cmp      x0, #3
0x000352fc  b.ne     #0x3534c
0x00035300  adrp     x0, #0x7b000
0x00035304  add      x0, x0, #0x508   ; STR "Ê, xe chứ có phải máy bay đâu!"
0x00035308  adrp     x1, #0x7b000
0x0003530c  add      x1, x1, #0x528   ; STR "Hey, this is a car, not a plane!"
0x00035310  b        #0x35398
0x00035314  cmp      x0, #6
0x00035318  b.eq     #0x35374
0x0003531c  cmp      x0, #7
0x00035320  b.ne     #0x3534c
0x00035324  adrp     x0, #0x7b000
0x00035328  add      x0, x0, #0x608   ; STR "Nhẹ chân ga thôi, chạy nhanh không làm bạn đẹp trai hơn đâu"
0x0003532c  adrp     x1, #0x7b000
0x00035330  add      x1, x1, #0x628   ; STR "Easy on the gas, speeding won't make you any better looking"
0x00035334  b        #0x35398
0x00035338  adrp     x0, #0x7b000
0x0003533c  add      x0, x0, #0x488   ; STR "Quá tốc độ, giới hạn {L}"
0x00035340  adrp     x1, #0x7b000
0x00035344  add      x1, x1, #0x4a8   ; STR "Too fast, the limit is {L}"
0x00035348  b        #0x35398
0x0003534c  adrp     x0, #0x7b000
0x00035350  add      x0, x0, #0x648   ; STR "Bạn đang vượt quá giới hạn tốc độ"
0x00035354  adrp     x1, #0x7b000
0x00035358  add      x1, x1, #0x668   ; STR "You are over the speed limit"
0x0003535c  b        #0x35398
0x00035360  adrp     x0, #0x7b000
0x00035364  add      x0, x0, #0x548   ; STR "Bình tĩnh, đường còn dài mà ví thì còn mỏng"
0x00035368  adrp     x1, #0x7b000
0x0003536c  add      x1, x1, #0x568   ; STR "Easy now, the road is long and the wallet is thin"
0x00035370  b        #0x35398
0x00035374  adrp     x0, #0x7b000
0x00035378  add      x0, x0, #0x5c8   ; STR "Chạy gì mà vội, cơm nhà vẫn còn nóng mà"
0x0003537c  adrp     x1, #0x7b000
0x00035380  add      x1, x1, #0x5e8   ; STR "What's the rush? Dinner at home is still hot"
0x00035384  b        #0x35398
0x00035388  adrp     x0, #0x7b000
0x0003538c  add      x0, x0, #0x4c8   ; STR "Vui lòng giảm tốc độ"
0x00035390  adrp     x1, #0x7b000
0x00035394  add      x1, x1, #0x4e8   ; STR "Please slow down"
0x00035398  bl       #0x5505c   ; CALL _OMCTr
0x0003539c  mov      x29, x29
0x000353a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000353a4  ldp      x29, x30, [sp], #0x10
0x000353a8  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== _SPPVoiceIsFun  va=0x353ac size=16 types=
0x000353ac  sub      x8, x0, #3
0x000353b0  cmp      x8, #5
0x000353b4  cset     w0, lo
0x000353b8  ret      

=== _SPPVoiceLine  va=0x353bc size=380 types=
0x000353bc  sub      sp, sp, #0x50
0x000353c0  stp      x24, x23, [sp, #0x10]
0x000353c4  stp      x22, x21, [sp, #0x20]
0x000353c8  stp      x20, x19, [sp, #0x30]
0x000353cc  stp      x29, x30, [sp, #0x40]
0x000353d0  add      x29, sp, #0x40
0x000353d4  mov      x20, x2
0x000353d8  mov      x19, x1
0x000353dc  mov      x22, x0
0x000353e0  mov      x0, x1
0x000353e4  bl       #0x55d84   ; CALL _objc_retain
0x000353e8  adrp     x24, #0x8e000
0x000353ec  cmp      x22, #8
0x000353f0  b.ne     #0x3542c
0x000353f4  ldr      x0, [x24, #0x9e0]   ; @CLASS NSCharacterSet
0x000353f8  bl       #0x5e180   ; CALL objc_msgSend$whitespaceAndNewlineCharacterSet
0x000353fc  mov      x29, x29
0x00035400  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00035404  mov      x23, x0
0x00035408  mov      x0, x19
0x0003540c  mov      x2, x23
0x00035410  bl       #0x5d4c0   ; CALL objc_msgSend$stringByTrimmingCharactersInSet:
0x00035414  mov      x29, x29
0x00035418  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003541c  mov      x21, x0
0x00035420  mov      x0, x23
0x00035424  bl       #0x55d78   ; CALL _objc_release
0x00035428  b        #0x35430
0x0003542c  mov      x21, #0
0x00035430  mov      x0, x21
0x00035434  bl       #0x58c20   ; CALL objc_msgSend$length
0x00035438  cbnz     x0, #0x35460
0x0003543c  cmp      x22, #8
0x00035440  csel     x0, xzr, x22, eq
0x00035444  bl       #0x352ac   ; CALL _SPPVoiceTemplate
0x00035448  mov      x29, x29
0x0003544c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00035450  mov      x22, x0
0x00035454  mov      x0, x21
0x00035458  bl       #0x55d78   ; CALL _objc_release
0x0003545c  mov      x21, x22
0x00035460  cmp      w20, #1
0x00035464  b.lt     #0x35490
0x00035468  adrp     x8, #0x8e000
0x0003546c  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00035470  str      x20, [sp]
0x00035474  adrp     x2, #0x7b000
0x00035478  add      x2, x2, #0x3e8   ; STR "%d"
0x0003547c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00035480  mov      x29, x29
0x00035484  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00035488  mov      x23, x0
0x0003548c  b        #0x35498
0x00035490  adrp     x23, #0x75000
0x00035494  add      x23, x23, #0xd28
0x00035498  adrp     x2, #0x7b000
0x0003549c  add      x2, x2, #0x688   ; STR "{L}"
0x000354a0  mov      x0, x21
0x000354a4  mov      x3, x23
0x000354a8  bl       #0x5d4a0   ; CALL objc_msgSend$stringByReplacingOccurrencesOfString:withString:
0x000354ac  mov      x29, x29
0x000354b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000354b4  mov      x22, x0
0x000354b8  mov      x0, x21
0x000354bc  bl       #0x55d78   ; CALL _objc_release
0x000354c0  cmp      w20, #1
0x000354c4  b.lt     #0x354d0
0x000354c8  mov      x0, x23
0x000354cc  bl       #0x55d78   ; CALL _objc_release
0x000354d0  ldr      x0, [x24, #0x9e0]   ; @CLASS NSCharacterSet
0x000354d4  adrp     x2, #0x7b000
0x000354d8  add      x2, x2, #0x6a8   ; STR " ,"
0x000354dc  bl       #0x56da0   ; CALL objc_msgSend$characterSetWithCharactersInString:
0x000354e0  mov      x29, x29
0x000354e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000354e8  mov      x20, x0
0x000354ec  mov      x0, x22
0x000354f0  mov      x2, x20
0x000354f4  bl       #0x5d4c0   ; CALL objc_msgSend$stringByTrimmingCharactersInSet:
0x000354f8  mov      x29, x29
0x000354fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00035500  mov      x21, x0
0x00035504  mov      x0, x20
0x00035508  bl       #0x55d78   ; CALL _objc_release
0x0003550c  mov      x0, x22
0x00035510  bl       #0x55d78   ; CALL _objc_release
0x00035514  mov      x0, x19
0x00035518  bl       #0x55d78   ; CALL _objc_release
0x0003551c  mov      x0, x21
0x00035520  ldp      x29, x30, [sp, #0x40]
0x00035524  ldp      x20, x19, [sp, #0x30]
0x00035528  ldp      x22, x21, [sp, #0x20]
0x0003552c  ldp      x24, x23, [sp, #0x10]
0x00035530  add      sp, sp, #0x50
0x00035534  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== _SPPPlayTone  va=0x35600 size=2352 types=
0x00035600  sub      sp, sp, #0x1b0
0x00035604  stp      d15, d14, [sp, #0x110]
0x00035608  stp      d13, d12, [sp, #0x120]
0x0003560c  stp      d11, d10, [sp, #0x130]
0x00035610  stp      d9, d8, [sp, #0x140]
0x00035614  stp      x28, x27, [sp, #0x150]
0x00035618  stp      x26, x25, [sp, #0x160]
0x0003561c  stp      x24, x23, [sp, #0x170]
0x00035620  stp      x22, x21, [sp, #0x180]
0x00035624  stp      x20, x19, [sp, #0x190]
0x00035628  stp      x29, x30, [sp, #0x1a0]
0x0003562c  add      x29, sp, #0x1a0
0x00035630  adrp     x8, #0x74000
0x00035634  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00035638  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003563c  stur     x8, [x29, #-0xa0]
0x00035640  cmp      x0, #5
0x00035644  csel     x23, xzr, x0, hi
0x00035648  adrp     x24, #0x90000
0x0003564c  add      x24, x24, #0x50
0x00035650  ldr      x8, [x24, x23, lsl #3]
0x00035654  cbnz     x8, #0x35b44
0x00035658  add      x9, sp, #0x60
0x0003565c  orr      x8, x9, #8
0x00035660  add      x13, x9, #0x30
0x00035664  add      x10, x9, #0x10
0x00035668  add      x14, x9, #0x38
0x0003566c  add      x11, x9, #0x18
0x00035670  add      x15, x9, #0x40
0x00035674  add      x12, x9, #0x20
0x00035678  add      x16, x9, #0x48
0x0003567c  cmp      x0, #2
0x00035680  b.le     #0x3570c
0x00035684  cmp      x0, #3
0x00035688  b.eq     #0x35788
0x0003568c  cmp      x0, #4
0x00035690  b.eq     #0x357d4
0x00035694  cmp      x0, #5
0x00035698  b.ne     #0x35864
0x0003569c  mov      x8, #0
0x000356a0  add      x9, sp, #0x60
0x000356a4  add      x9, x9, #0x10
0x000356a8  mov      w10, #0x384
0x000356ac  adrp     x11, #0x65000
0x000356b0  ldr      d0, [x11, #0x728]
0x000356b4  mov      x11, #-0x6666666666666667
0x000356b8  movk     x11, #0x999a
0x000356bc  movk     x11, #0x3fb9, lsl #48
0x000356c0  adrp     x12, #0x65000
0x000356c4  ldr      d1, [x12, #0xd98]
0x000356c8  mov      x12, #-0x6666666666666667
0x000356cc  movk     x12, #0x999a
0x000356d0  movk     x12, #0x3fc9, lsl #48
0x000356d4  mov      w21, #4
0x000356d8  ucvtf    d2, w10
0x000356dc  ucvtf    d3, w8
0x000356e0  fmul     d3, d3, d0
0x000356e4  stp      d2, d3, [x9, #-0x10]
0x000356e8  str      x11, [x9]
0x000356ec  str      d1, [x9, #8]
0x000356f0  str      x12, [x9, #0x10]
0x000356f4  add      x8, x8, #1
0x000356f8  add      w10, w10, #0xdc
0x000356fc  add      x9, x9, #0x28
0x00035700  cmp      x8, #4
0x00035704  b.ne     #0x356d8
0x00035708  b        #0x3589c
0x0003570c  cmp      x0, #1
0x00035710  b.eq     #0x35800
0x00035714  cmp      x0, #2
0x00035718  b.ne     #0x35864
0x0003571c  mov      x8, #0
0x00035720  add      x9, sp, #0x60
0x00035724  add      x9, x9, #0x10
0x00035728  adrp     x10, #0x65000
0x0003572c  ldr      d0, [x10, #0x6b8]
0x00035730  mov      x10, #0x700000000000
0x00035734  movk     x10, #0x4097, lsl #48
0x00035738  mov      x11, #0xd70a
0x0003573c  movk     x11, #0x70a3, lsl #16
0x00035740  movk     x11, #0xa3d, lsl #32
0x00035744  movk     x11, #0x3fb7, lsl #48
0x00035748  mov      x12, #0x1eb8
0x0003574c  movk     x12, #0xeb85, lsl #16
0x00035750  movk     x12, #0xb851, lsl #32
0x00035754  movk     x12, #0x3fae, lsl #48
0x00035758  mov      w21, #3
0x0003575c  ucvtf    d1, w8
0x00035760  fmul     d1, d1, d0
0x00035764  stur     x10, [x9, #-0x10]
0x00035768  stur     d1, [x9, #-8]
0x0003576c  stp      x11, xzr, [x9]
0x00035770  str      x12, [x9, #0x10]
0x00035774  add      x8, x8, #1
0x00035778  add      x9, x9, #0x28
0x0003577c  cmp      x8, #3
0x00035780  b.ne     #0x3575c
0x00035784  b        #0x3589c
0x00035788  adrp     x8, #0x65000
0x0003578c  ldr      q0, [x8, #0xdd0]
0x00035790  str      q0, [sp, #0x60]
0x00035794  mov      x8, #0x6666666666666666
0x00035798  movk     x8, #0x3fe6, lsl #48
0x0003579c  str      x8, [sp, #0x70]
0x000357a0  mov      w9, #1
0x000357a4  str      w9, [sp, #0x78]
0x000357a8  adrp     x8, #0x65000
0x000357ac  ldr      q0, [x8, #0xde0]
0x000357b0  str      q0, [sp, #0x80]
0x000357b4  mov      w21, #2
0x000357b8  adrp     x8, #0x65000
0x000357bc  ldr      d0, [x8, #0x608]
0x000357c0  adrp     x8, #0x65000
0x000357c4  ldr      d2, [x8, #0x708]
0x000357c8  adrp     x8, #0x65000
0x000357cc  ldr      d1, [x8, #0x668]
0x000357d0  b        #0x35850
0x000357d4  mov      x9, #0x800000000000
0x000357d8  movk     x9, #0x409b, lsl #48
0x000357dc  str      x9, [sp, #0x60]
0x000357e0  mov      w9, #1
0x000357e4  fmov     d1, xzr
0x000357e8  adrp     x13, #0x65000
0x000357ec  ldr      d0, [x13, #0x668]
0x000357f0  adrp     x13, #0x65000
0x000357f4  ldr      d2, [x13, #0x708]
0x000357f8  mov      w21, #1
0x000357fc  b        #0x3588c
0x00035800  mov      w9, #0
0x00035804  adrp     x8, #0x65000
0x00035808  ldr      q0, [x8, #0xdf0]
0x0003580c  str      q0, [sp, #0x60]
0x00035810  mov      x8, #0x1eb8
0x00035814  movk     x8, #0xeb85, lsl #16
0x00035818  movk     x8, #0xb851, lsl #32
0x0003581c  movk     x8, #0x3fbe, lsl #48
0x00035820  str      x8, [sp, #0x70]
0x00035824  adrp     x8, #0x65000
0x00035828  ldr      q0, [x8, #0xe00]
0x0003582c  str      q0, [sp, #0x80]
0x00035830  adrp     x8, #0x65000
0x00035834  ldr      d0, [x8, #0x760]
0x00035838  adrp     x8, #0x65000
0x0003583c  ldr      d2, [x8, #0x5f0]
0x00035840  adrp     x8, #0x65000
0x00035844  ldr      d1, [x8, #0xb60]
0x00035848  mov      w21, #2
0x0003584c  str      wzr, [sp, #0x78]
0x00035850  mov      x8, x13
0x00035854  mov      x10, x14
0x00035858  mov      x11, x15
0x0003585c  mov      x12, x16
0x00035860  b        #0x3588c
0x00035864  mov      w9, #0
0x00035868  mov      x13, #0xa00000000000
0x0003586c  movk     x13, #0x4094, lsl #48
0x00035870  str      x13, [sp, #0x60]
0x00035874  fmov     d1, xzr
0x00035878  mov      w21, #1
0x0003587c  adrp     x13, #0x65000
0x00035880  ldr      d0, [x13, #0x760]
0x00035884  adrp     x13, #0x65000
0x00035888  ldr      d2, [x13, #0xb08]
0x0003588c  str      d1, [x8]
0x00035890  str      d2, [x10]
0x00035894  str      w9, [x11]
0x00035898  str      d0, [x12]
0x0003589c  add      x8, sp, #0x60
0x000358a0  add      x8, x8, #0x10
0x000358a4  fmov     d0, xzr
0x000358a8  adrp     x9, #0x65000
0x000358ac  ldr      d3, [x9, #0xda0]
0x000358b0  mov      x9, x21
0x000358b4  ldp      d1, d2, [x8, #-8]
0x000358b8  fadd     d1, d1, d2
0x000358bc  fadd     d1, d1, d3
0x000358c0  fcmp     d0, d1
0x000358c4  fcsel    d0, d1, d0, mi
0x000358c8  add      x8, x8, #0x28   ; CSTR "eady"
0x000358cc  subs     x9, x9, #1
0x000358d0  b.ne     #0x358b4
0x000358d4  str      d3, [sp, #0x20]
0x000358d8  adrp     x8, #0x65000
0x000358dc  ldr      d10, [x8, #0xda8]
0x000358e0  fmul     d0, d0, d10
0x000358e4  fcvtpu   x19, d0
0x000358e8  mov      x0, x19
0x000358ec  mov      w1, #8
0x000358f0  bl       #0x55bbc   ; CALL _calloc
0x000358f4  mov      x20, x0
0x000358f8  mov      x22, #0
0x000358fc  mov      w25, #0x28
0x00035900  add      x26, sp, #0x60
0x00035904  adrp     x8, #0x65000
0x00035908  ldr      d0, [x8, #0xdb0]
0x0003590c  str      d0, [sp, #0x50]
0x00035910  adrp     x8, #0x65000
0x00035914  ldr      d0, [x8, #0xdb8]
0x00035918  str      d0, [sp, #0x48]
0x0003591c  adrp     x8, #0x65000
0x00035920  ldr      d0, [x8, #0xb98]
0x00035924  str      d0, [sp, #0x18]
0x00035928  adrp     x8, #0x65000
0x0003592c  ldr      d0, [x8, #0xdc0]
0x00035930  str      d0, [sp, #0x38]
0x00035934  madd     x8, x22, x25, x26
0x00035938  ldr      d9, [x8, #8]   ; @CSTR "ight.max"
0x0003593c  fmul     d0, d9, d10
0x00035940  fcvtzu   x27, d0
0x00035944  cmp      x27, x19
0x00035948  b.hs     #0x35a28
0x0003594c  ldr      d0, [x8, #0x10]
0x00035950  ldr      w28, [x8, #0x18]   ; @CSTR "r car is ready, %@"
0x00035954  ldr      d15, [x8, #0x20]   ; @CSTR " ready, %@"
0x00035958  ldr      d1, [sp, #0x50]
0x0003595c  fadd     d13, d9, d1
0x00035960  fadd     d2, d9, d0
0x00035964  ldr      d0, [x8]   ; @CSTR "m.fill"
0x00035968  ldr      d1, [sp, #0x20]
0x0003596c  fadd     d8, d2, d1
0x00035970  ldr      d1, [sp, #0x48]
0x00035974  fdiv     d3, d1, d15
0x00035978  str      d2, [sp, #0x40]
0x0003597c  fsub     d1, d2, d13
0x00035980  stp      d1, d3, [sp, #0x28]
0x00035984  ldr      d1, [sp, #0x18]
0x00035988  fmul     d11, d0, d1
0x0003598c  ucvtf    d0, x27
0x00035990  fdiv     d0, d0, d10
0x00035994  fcmp     d0, d8
0x00035998  b.gt     #0x35a28
0x0003599c  fcmp     d0, d13
0x000359a0  fsub     d14, d0, d9
0x000359a4  b.pl     #0x359b8
0x000359a8  fmul     d0, d15, d14
0x000359ac  ldr      d1, [sp, #0x50]
0x000359b0  fdiv     d12, d0, d1
0x000359b4  b        #0x359dc
0x000359b8  ldp      d1, d12, [sp, #0x40]
0x000359bc  fcmp     d0, d1
0x000359c0  b.pl     #0x359dc
0x000359c4  fsub     d0, d0, d13
0x000359c8  ldr      d1, [sp, #0x28]
0x000359cc  fdiv     d1, d0, d1
0x000359d0  ldr      d0, [sp, #0x30]
0x000359d4  bl       #0x55e14   ; CALL _pow
0x000359d8  fmul     d12, d15, d0
0x000359dc  fmul     d0, d11, d14
0x000359e0  bl       #0x55e20   ; CALL _sin
0x000359e4  cmp      w28, #2
0x000359e8  b.eq     #0x35a04
0x000359ec  cbnz     w28, #0x35a10
0x000359f0  fcmp     d0, #0.0
0x000359f4  fmov     d0, #-1.00000000
0x000359f8  fmov     d1, #1.00000000
0x000359fc  fcsel    d0, d1, d0, ge
0x00035a00  b        #0x35a10
0x00035a04  bl       #0x55bb0   ; CALL _asin
0x00035a08  ldr      d1, [sp, #0x38]
0x00035a0c  fmul     d0, d0, d1
0x00035a10  ldr      d1, [x20, x27, lsl #3]
0x00035a14  fmadd    d0, d12, d0, d1
0x00035a18  str      d0, [x20, x27, lsl #3]
0x00035a1c  add      x27, x27, #1
0x00035a20  cmp      x19, x27
0x00035a24  b.ne     #0x3598c
0x00035a28  add      x22, x22, #1
0x00035a2c  cmp      x22, x21
0x00035a30  b.ne     #0x35934
0x00035a34  fmov     d0, xzr
0x00035a38  fmov     d1, xzr
0x00035a3c  cbz      x19, #0x35a60
0x00035a40  mov      x8, x20
0x00035a44  mov      x9, x19
0x00035a48  ldr      d2, [x8], #8   ; @CSTR "m.fill"
0x00035a4c  fabs     d2, d2
0x00035a50  fcmp     d1, d2
0x00035a54  fcsel    d1, d2, d1, mi
0x00035a58  subs     x9, x9, #1
0x00035a5c  b.ne     #0x35a48
0x00035a60  adrp     x8, #0x65000
0x00035a64  ldr      d2, [x8, #0x670]
0x00035a68  fdiv     d2, d2, d1
0x00035a6c  fcmp     d1, #0.0
0x00035a70  fcsel    d8, d2, d0, gt
0x00035a74  adrp     x8, #0x8e000
0x00035a78  ldr      x0, [x8, #0xc10]   ; @CLASS NSMutableData
0x00035a7c  lsl      x22, x19, #1
0x00035a80  add      x2, x22, #0x2c
0x00035a84  bl       #0x57580   ; CALL objc_msgSend$dataWithLength:
0x00035a88  mov      x29, x29
0x00035a8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00035a90  mov      x21, x0
0x00035a94  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00035a98  bl       #0x59080   ; CALL objc_msgSend$mutableBytes
0x00035a9c  add      w8, w22, #0x24
0x00035aa0  mov      w9, #0x4952
0x00035aa4  movk     w9, #0x4646, lsl #16
0x00035aa8  stp      w9, w8, [x0]
0x00035aac  mov      x8, #0x4157
0x00035ab0  movk     x8, #0x4556, lsl #16
0x00035ab4  movk     x8, #0x6d66, lsl #32
0x00035ab8  movk     x8, #0x2074, lsl #48
0x00035abc  mov      x9, #0x10
0x00035ac0  movk     x9, #1, lsl #32
0x00035ac4  movk     x9, #1, lsl #48
0x00035ac8  stp      x8, x9, [x0, #8]
0x00035acc  mov      x8, #0x5622
0x00035ad0  movk     x8, #0xac44, lsl #32
0x00035ad4  mov      x9, #2
0x00035ad8  movk     x9, #0x10, lsl #16
0x00035adc  movk     x9, #0x6164, lsl #32
0x00035ae0  movk     x9, #0x6174, lsl #48
0x00035ae4  stp      x8, x9, [x0, #0x18]
0x00035ae8  str      w22, [x0, #0x28]
0x00035aec  cbz      x19, #0x35b30
0x00035af0  add      x8, x0, #0x2c
0x00035af4  fmov     d0, #1.00000000
0x00035af8  fmov     d1, #-1.00000000
0x00035afc  adrp     x9, #0x65000
0x00035b00  ldr      d2, [x9, #0xdc8]
0x00035b04  mov      x9, x20
0x00035b08  ldr      d3, [x9], #8   ; @CSTR "m.fill"
0x00035b0c  fmul     d3, d8, d3
0x00035b10  fcmp     d3, d0
0x00035b14  fcsel    d3, d0, d3, gt
0x00035b18  fmaxnm   d3, d3, d1
0x00035b1c  fmul     d3, d3, d2
0x00035b20  fcvtas   x10, d3
0x00035b24  strh     w10, [x8], #2
0x00035b28  subs     x19, x19, #1
0x00035b2c  b.ne     #0x35b08
0x00035b30  mov      x0, x20
0x00035b34  bl       #0x55c4c   ; CALL _free
0x00035b38  ldr      x0, [x24, x23, lsl #3]
0x00035b3c  str      x21, [x24, x23, lsl #3]
0x00035b40  bl       #0x55d78   ; CALL _objc_release
0x00035b44  adrp     x21, #0x90000
0x00035b48  ldr      x0, [x21, #0x48]
0x00035b4c  cbz      x0, #0x35b60
0x00035b50  bl       #0x5d360   ; CALL objc_msgSend$stop
0x00035b54  ldr      x0, [x21, #0x48]
0x00035b58  str      xzr, [x21, #0x48]
0x00035b5c  bl       #0x55d78   ; CALL _objc_release
0x00035b60  bl       #0x35d28
0x00035b64  adrp     x8, #0x8e000
0x00035b68  ldr      x0, [x8, #0xbe8]   ; @CLASS AVAudioPlayer
0x00035b6c  bl       #0x55c7c   ; CALL _objc_alloc
0x00035b70  ldr      x2, [x24, x23, lsl #3]
0x00035b74  adrp     x8, #0x74000
0x00035b78  ldr      x8, [x8, #0x2f0]   ; @GOT _AVFileTypeWAVE
0x00035b7c  ldr      x3, [x8]   ; @GOT ___objc_personality_v0
0x00035b80  str      xzr, [sp, #0x58]
0x00035b84  add      x4, sp, #0x58
0x00035b88  bl       #0x58400   ; CALL objc_msgSend$initWithData:fileTypeHint:error:
0x00035b8c  mov      x20, x0
0x00035b90  ldr      x19, [sp, #0x58]
0x00035b94  mov      x0, x19
0x00035b98  bl       #0x55d84   ; CALL _objc_retain
0x00035b9c  ldr      x0, [x21, #0x48]
0x00035ba0  str      x20, [x21, #0x48]
0x00035ba4  bl       #0x55d78   ; CALL _objc_release
0x00035ba8  ldr      x8, [x21, #0x48]
0x00035bac  cbz      x8, #0x35c04
0x00035bb0  bl       #0x35ee0
0x00035bb4  mov      x29, x29
0x00035bb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00035bbc  mov      x20, x0
0x00035bc0  ldr      x0, [x21, #0x48]
0x00035bc4  mov      x2, x20
0x00035bc8  bl       #0x5aca0   ; CALL objc_msgSend$setDelegate:
0x00035bcc  mov      x0, x20
0x00035bd0  bl       #0x55d78   ; CALL _objc_release
0x00035bd4  ldr      x0, [x21, #0x48]
0x00035bd8  fmov     s0, #1.00000000
0x00035bdc  bl       #0x5c880   ; CALL objc_msgSend$setVolume:
0x00035be0  ldr      x0, [x21, #0x48]
0x00035be4  bl       #0x59760   ; CALL objc_msgSend$play
0x00035be8  tbnz     w0, #0, #0x35cd4
0x00035bec  str      x23, [sp]
0x00035bf0  adrp     x0, #0x7b000
0x00035bf4  add      x0, x0, #0x728   ; STR "OmniCar SpeedBubble: am thanh: khong phat duoc am bao %ld"
0x00035bf8  bl       #0x55afc   ; CALL _NSLog
0x00035bfc  bl       #0x3553c
0x00035c00  b        #0x35cd4
0x00035c04  stp      x23, x19, [sp]
0x00035c08  adrp     x0, #0x7b000
0x00035c0c  add      x0, x0, #0x6e8   ; STR "OmniCar SpeedBubble: am thanh: khong mo duoc am bao %ld: %@ -> am he thong"
0x00035c10  bl       #0x55afc   ; CALL _NSLog
0x00035c14  bl       #0x3553c
0x00035c18  adrp     x25, #0x90000
0x00035c1c  add      x25, x25, #0x80
0x00035c20  ldr      w0, [x25, x23, lsl #2]
0x00035c24  cbnz     w0, #0x35cd0
0x00035c28  bl       #0x55b14   ; CALL _NSTemporaryDirectory
0x00035c2c  mov      x29, x29
0x00035c30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00035c34  mov      x21, x0
0x00035c38  adrp     x8, #0x8e000
0x00035c3c  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00035c40  str      x23, [sp]
0x00035c44  adrp     x2, #0x7b000
0x00035c48  add      x2, x2, #0x708   ; STR "omc-speedbubble-tone-%ld.wav"
0x00035c4c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00035c50  mov      x29, x29
0x00035c54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00035c58  mov      x22, x0
0x00035c5c  mov      x0, x21
0x00035c60  mov      x2, x22
0x00035c64  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00035c68  mov      x29, x29
0x00035c6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00035c70  mov      x20, x0
0x00035c74  mov      x0, x22
0x00035c78  bl       #0x55d78   ; CALL _objc_release
0x00035c7c  mov      x0, x21
0x00035c80  bl       #0x55d78   ; CALL _objc_release
0x00035c84  str      wzr, [sp, #0x60]
0x00035c88  ldr      x0, [x24, x23, lsl #3]
0x00035c8c  mov      x2, x20
0x00035c90  mov      w3, #1
0x00035c94  bl       #0x5e220   ; CALL objc_msgSend$writeToFile:atomically:
0x00035c98  cbz      w0, #0x35cc0
0x00035c9c  adrp     x8, #0x8e000
0x00035ca0  ldr      x0, [x8, #0xa10]   ; @CLASS NSURL
0x00035ca4  mov      x2, x20
0x00035ca8  bl       #0x57ba0   ; CALL objc_msgSend$fileURLWithPath:
0x00035cac  add      x1, sp, #0x60
0x00035cb0  bl       #0x557f0   ; CALL _AudioServicesCreateSystemSoundID
0x00035cb4  cbnz     w0, #0x35cc0
0x00035cb8  ldr      w8, [sp, #0x60]
0x00035cbc  str      w8, [x25, x23, lsl #2]
0x00035cc0  mov      x0, x20
0x00035cc4  bl       #0x55d78   ; CALL _objc_release
0x00035cc8  ldr      w0, [x25, x23, lsl #2]
0x00035ccc  cbz      w0, #0x35cd4
0x00035cd0  bl       #0x557fc   ; CALL _AudioServicesPlaySystemSound
0x00035cd4  mov      x0, x19
0x00035cd8  bl       #0x55d78   ; CALL _objc_release
0x00035cdc  ldur     x8, [x29, #-0xa0]
0x00035ce0  adrp     x9, #0x74000
0x00035ce4  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00035ce8  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00035cec  cmp      x9, x8
0x00035cf0  b.ne     #0x35d24
0x00035cf4  ldp      x29, x30, [sp, #0x1a0]
0x00035cf8  ldp      x20, x19, [sp, #0x190]
0x00035cfc  ldp      x22, x21, [sp, #0x180]
0x00035d00  ldp      x24, x23, [sp, #0x170]
0x00035d04  ldp      x26, x25, [sp, #0x160]
0x00035d08  ldp      x28, x27, [sp, #0x150]
0x00035d0c  ldp      d9, d8, [sp, #0x140]
0x00035d10  ldp      d11, d10, [sp, #0x130]
0x00035d14  ldp      d13, d12, [sp, #0x120]
0x00035d18  ldp      d15, d14, [sp, #0x110]
0x00035d1c  add      sp, sp, #0x1b0
0x00035d20  ret      
0x00035d24  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00035d28  sub      sp, sp, #0x60
0x00035d2c  stp      x24, x23, [sp, #0x20]
0x00035d30  stp      x22, x21, [sp, #0x30]
0x00035d34  stp      x20, x19, [sp, #0x40]
0x00035d38  stp      x29, x30, [sp, #0x50]
0x00035d3c  add      x29, sp, #0x50
0x00035d40  adrp     x8, #0x8e000
0x00035d44  ldr      x0, [x8, #0xc08]   ; @CLASS AVAudioSession
0x00035d48  bl       #0x5c980   ; CALL objc_msgSend$sharedInstance
0x00035d4c  mov      x29, x29
0x00035d50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00035d54  mov      x19, x0
0x00035d58  adrp     x8, #0x90000
0x00035d5c  ldr      w9, [x8, #0xa8]
0x00035d60  add      w10, w9, #1
0x00035d64  str      w10, [x8, #0xa8]
0x00035d68  adrp     x20, #0x90000
0x00035d6c  ldr      x8, [x20, #0xa0]
0x00035d70  cmp      w9, #0
0x00035d74  ccmp     x8, #0, #0, eq
0x00035d78  b.ne     #0x35dac
0x00035d7c  mov      x0, x19
0x00035d80  bl       #0x56c60   ; CALL objc_msgSend$category
0x00035d84  mov      x29, x29
0x00035d88  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00035d8c  ldr      x8, [x20, #0xa0]
0x00035d90  str      x0, [x20, #0xa0]
0x00035d94  mov      x0, x8
0x00035d98  bl       #0x55d78   ; CALL _objc_release
0x00035d9c  mov      x0, x19
0x00035da0  bl       #0x56c80   ; CALL objc_msgSend$categoryOptions
0x00035da4  adrp     x8, #0x90000
0x00035da8  str      x0, [x8, #0xb0]
0x00035dac  adrp     x8, #0x74000
0x00035db0  ldr      x8, [x8, #0x480]   ; @GOT _AVAudioSessionCategoryPlayback
0x00035db4  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x00035db8  str      xzr, [sp, #0x18]
0x00035dbc  add      x4, sp, #0x18
0x00035dc0  mov      x0, x19
0x00035dc4  mov      w3, #3
0x00035dc8  bl       #0x5a820   ; CALL objc_msgSend$setCategory:withOptions:error:
0x00035dcc  mov      x21, x0
0x00035dd0  ldr      x20, [sp, #0x18]
0x00035dd4  mov      x0, x20
0x00035dd8  bl       #0x55d84   ; CALL _objc_retain
0x00035ddc  tbnz     w21, #0, #0x35df0
0x00035de0  str      x20, [sp]
0x00035de4  adrp     x0, #0x7b000
0x00035de8  add      x0, x0, #0x768   ; STR "OmniCar SpeedBubble: am thanh: khong dat duoc phien Playback: %@"
0x00035dec  bl       #0x55afc   ; CALL _NSLog
0x00035df0  mov      x0, x20
0x00035df4  bl       #0x55d78   ; CALL _objc_release
0x00035df8  str      xzr, [sp, #0x10]
0x00035dfc  add      x3, sp, #0x10
0x00035e00  mov      x0, x19
0x00035e04  mov      w2, #1
0x00035e08  bl       #0x5a300   ; CALL objc_msgSend$setActive:error:
0x00035e0c  mov      x21, x0
0x00035e10  ldr      x20, [sp, #0x10]
0x00035e14  mov      x0, x20
0x00035e18  bl       #0x55d84   ; CALL _objc_retain
0x00035e1c  tbz      w21, #0, #0x35ea8
0x00035e20  mov      x0, x19
0x00035e24  bl       #0x574a0   ; CALL objc_msgSend$currentRoute
0x00035e28  mov      x29, x29
0x00035e2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00035e30  mov      x21, x0
0x00035e34  bl       #0x59520   ; CALL objc_msgSend$outputs
0x00035e38  mov      x29, x29
0x00035e3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00035e40  mov      x22, x0
0x00035e44  bl       #0x57c20   ; CALL objc_msgSend$firstObject
0x00035e48  mov      x29, x29
0x00035e4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00035e50  mov      x23, x0
0x00035e54  bl       #0x59860   ; CALL objc_msgSend$portType
0x00035e58  mov      x29, x29
0x00035e5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00035e60  mov      x24, x0
0x00035e64  adrp     x8, #0x75000
0x00035e68  add      x8, x8, #0x868   ; STR "?"
0x00035e6c  cmp      x0, #0
0x00035e70  csel     x8, x8, x0, eq
0x00035e74  str      x8, [sp]
0x00035e78  adrp     x0, #0x7b000
0x00035e7c  add      x0, x0, #0x7a8   ; STR "OmniCar SpeedBubble: am thanh: phien bat, ra %@"
0x00035e80  bl       #0x55afc   ; CALL _NSLog
0x00035e84  mov      x0, x24
0x00035e88  bl       #0x55d78   ; CALL _objc_release
0x00035e8c  mov      x0, x23
0x00035e90  bl       #0x55d78   ; CALL _objc_release
0x00035e94  mov      x0, x22
0x00035e98  bl       #0x55d78   ; CALL _objc_release
0x00035e9c  mov      x0, x21
0x00035ea0  bl       #0x55d78   ; CALL _objc_release
0x00035ea4  b        #0x35eb8
0x00035ea8  str      x20, [sp]
0x00035eac  adrp     x0, #0x7b000
0x00035eb0  add      x0, x0, #0x788   ; STR "OmniCar SpeedBubble: am thanh: khong bat duoc phien: %@"
0x00035eb4  bl       #0x55afc   ; CALL _NSLog
0x00035eb8  mov      x0, x20
0x00035ebc  bl       #0x55d78   ; CALL _objc_release
0x00035ec0  mov      x0, x19
0x00035ec4  bl       #0x55d78   ; CALL _objc_release
0x00035ec8  ldp      x29, x30, [sp, #0x50]
0x00035ecc  ldp      x20, x19, [sp, #0x40]
0x00035ed0  ldp      x22, x21, [sp, #0x30]
0x00035ed4  ldp      x24, x23, [sp, #0x20]
0x00035ed8  add      sp, sp, #0x60
0x00035edc  ret      
0x00035ee0  stp      x20, x19, [sp, #-0x20]!
0x00035ee4  stp      x29, x30, [sp, #0x10]
0x00035ee8  add      x29, sp, #0x10
0x00035eec  adrp     x20, #0x90000
0x00035ef0  ldr      x19, [x20, #0xb8]
0x00035ef4  cbnz     x19, #0x35f18
0x00035ef8  adrp     x8, #0x8e000
0x00035efc  ldr      x0, [x8, #0xc18]   ; @CLASS SPPSoundDelegate
0x00035f00  bl       #0x55d60   ; CALL _objc_opt_new
0x00035f04  ldr      x8, [x20, #0xb8]
0x00035f08  str      x0, [x20, #0xb8]
0x00035f0c  mov      x0, x8
0x00035f10  bl       #0x55d78   ; CALL _objc_release
0x00035f14  ldr      x19, [x20, #0xb8]
0x00035f18  mov      x0, x19
0x00035f1c  bl       #0x55d84   ; CALL _objc_retain
0x00035f20  mov      x0, x19
0x00035f24  ldp      x29, x30, [sp, #0x10]
0x00035f28  ldp      x20, x19, [sp], #0x20
0x00035f2c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== _SPPSpeak  va=0x35f30 size=488 types=
0x00035f30  sub      sp, sp, #0x50
0x00035f34  stp      x24, x23, [sp, #0x10]
0x00035f38  stp      x22, x21, [sp, #0x20]
0x00035f3c  stp      x20, x19, [sp, #0x30]
0x00035f40  stp      x29, x30, [sp, #0x40]
0x00035f44  add      x29, sp, #0x40
0x00035f48  mov      x19, x0
0x00035f4c  bl       #0x55d84   ; CALL _objc_retain
0x00035f50  mov      x0, x19
0x00035f54  bl       #0x58c20   ; CALL objc_msgSend$length
0x00035f58  cbz      x0, #0x36084
0x00035f5c  adrp     x23, #0x90000
0x00035f60  ldr      x0, [x23, #0x98]
0x00035f64  cbnz     x0, #0x35fb8
0x00035f68  adrp     x8, #0x8e000
0x00035f6c  ldr      x0, [x8, #0xbf0]   ; @CLASS AVSpeechSynthesizer
0x00035f70  bl       #0x55d60   ; CALL _objc_opt_new
0x00035f74  ldr      x8, [x23, #0x98]
0x00035f78  str      x0, [x23, #0x98]
0x00035f7c  mov      x0, x8
0x00035f80  bl       #0x55d78   ; CALL _objc_release
0x00035f84  ldr      x0, [x23, #0x98]
0x00035f88  mov      w2, #1
0x00035f8c  bl       #0x5c760   ; CALL objc_msgSend$setUsesApplicationAudioSession:
0x00035f90  bl       #0x35ee0
0x00035f94  mov      x29, x29
0x00035f98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00035f9c  mov      x20, x0
0x00035fa0  ldr      x0, [x23, #0x98]
0x00035fa4  mov      x2, x20
0x00035fa8  bl       #0x5aca0   ; CALL objc_msgSend$setDelegate:
0x00035fac  mov      x0, x20
0x00035fb0  bl       #0x55d78   ; CALL _objc_release
0x00035fb4  ldr      x0, [x23, #0x98]
0x00035fb8  bl       #0x58920   ; CALL objc_msgSend$isSpeaking
0x00035fbc  cbz      w0, #0x35fcc
0x00035fc0  ldr      x0, [x23, #0x98]
0x00035fc4  mov      x2, #0
0x00035fc8  bl       #0x5d380   ; CALL objc_msgSend$stopSpeakingAtBoundary:
0x00035fcc  bl       #0x35d28
0x00035fd0  adrp     x8, #0x8e000
0x00035fd4  ldr      x0, [x8, #0xbf8]   ; @CLASS AVSpeechUtterance
0x00035fd8  mov      x2, x19
0x00035fdc  bl       #0x5cde0   ; CALL objc_msgSend$speechUtteranceWithString:
0x00035fe0  mov      x29, x29
0x00035fe4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00035fe8  mov      x20, x0
0x00035fec  adrp     x8, #0x8e000
0x00035ff0  ldr      x21, [x8, #0xc00]   ; @CLASS AVSpeechSynthesisVoice
0x00035ff4  bl       #0x360a0
0x00035ff8  mov      x29, x29
0x00035ffc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036000  mov      x22, x0
0x00036004  mov      x0, x21
0x00036008  mov      x2, x22
0x0003600c  bl       #0x5e020   ; CALL objc_msgSend$voiceWithLanguage:
0x00036010  mov      x29, x29
0x00036014  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036018  mov      x21, x0
0x0003601c  mov      x0, x22
0x00036020  bl       #0x55d78   ; CALL _objc_release
0x00036024  cbnz     x21, #0x36050
0x00036028  bl       #0x360a0
0x0003602c  mov      x29, x29
0x00036030  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036034  mov      x22, x0
0x00036038  str      x0, [sp]
0x0003603c  adrp     x0, #0x7b000
0x00036040  add      x0, x0, #0x748   ; STR "OmniCar SpeedBubble: am thanh: khong co giong %@, dung giong mac dinh"
0x00036044  bl       #0x55afc   ; CALL _NSLog
0x00036048  mov      x0, x22
0x0003604c  bl       #0x55d78   ; CALL _objc_release
0x00036050  mov      x0, x20
0x00036054  mov      x2, x21
0x00036058  bl       #0x5c860   ; CALL objc_msgSend$setVoice:
0x0003605c  fmov     s0, #1.00000000
0x00036060  mov      x0, x20
0x00036064  bl       #0x5c880   ; CALL objc_msgSend$setVolume:
0x00036068  ldr      x0, [x23, #0x98]
0x0003606c  mov      x2, x20
0x00036070  bl       #0x5cda0   ; CALL objc_msgSend$speakUtterance:
0x00036074  mov      x0, x21
0x00036078  bl       #0x55d78   ; CALL _objc_release
0x0003607c  mov      x0, x20
0x00036080  bl       #0x55d78   ; CALL _objc_release
0x00036084  mov      x0, x19
0x00036088  ldp      x29, x30, [sp, #0x40]
0x0003608c  ldp      x20, x19, [sp, #0x30]
0x00036090  ldp      x22, x21, [sp, #0x20]
0x00036094  ldp      x24, x23, [sp, #0x10]
0x00036098  add      sp, sp, #0x50
0x0003609c  b        #0x55d78   ; CALL _objc_release
0x000360a0  stp      x22, x21, [sp, #-0x30]!
0x000360a4  stp      x20, x19, [sp, #0x10]
0x000360a8  stp      x29, x30, [sp, #0x20]
0x000360ac  add      x29, sp, #0x20
0x000360b0  bl       #0x54cc4   ; CALL _OMCCurrentLanguage
0x000360b4  mov      x29, x29
0x000360b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000360bc  mov      x19, x0
0x000360c0  adrp     x0, #0x80000
0x000360c4  add      x0, x0, #0x80
0x000360c8  mov      x2, x19
0x000360cc  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000360d0  mov      x29, x29
0x000360d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000360d8  mov      x20, x0
0x000360dc  adrp     x8, #0x7b000
0x000360e0  add      x8, x8, #0x7e8   ; STR "en-US"
0x000360e4  cmp      x0, #0
0x000360e8  csel     x21, x8, x0, eq
0x000360ec  mov      x0, x21
0x000360f0  bl       #0x55d84   ; CALL _objc_retain
0x000360f4  mov      x0, x20
0x000360f8  bl       #0x55d78   ; CALL _objc_release
0x000360fc  mov      x0, x19
0x00036100  bl       #0x55d78   ; CALL _objc_release
0x00036104  mov      x0, x21
0x00036108  ldp      x29, x30, [sp, #0x20]
0x0003610c  ldp      x20, x19, [sp, #0x10]
0x00036110  ldp      x22, x21, [sp], #0x30
0x00036114  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== _SSWeatherParse  va=0x452ec size=1088 types=
0x000452ec  stp      x28, x27, [sp, #-0x60]!
0x000452f0  stp      x26, x25, [sp, #0x10]
0x000452f4  stp      x24, x23, [sp, #0x20]
0x000452f8  stp      x22, x21, [sp, #0x30]
0x000452fc  stp      x20, x19, [sp, #0x40]
0x00045300  stp      x29, x30, [sp, #0x50]
0x00045304  add      x29, sp, #0x50
0x00045308  mov      x19, x0
0x0004530c  bl       #0x55d84   ; CALL _objc_retain
0x00045310  adrp     x26, #0x8e000
0x00045314  ldr      x0, [x26, #0x970]   ; @CLASS NSDictionary
0x00045318  bl       #0x55d48   ; CALL _objc_opt_class
0x0004531c  mov      x1, x0
0x00045320  mov      x0, x19
0x00045324  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00045328  tbz      w0, #0, #0x455e8
0x0004532c  mov      x0, x19
0x00045330  bl       #0x55d84   ; CALL _objc_retain
0x00045334  adrp     x2, #0x7d000
0x00045338  add      x2, x2, #0x188   ; STR "current"
0x0004533c  mov      x0, x19
0x00045340  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00045344  mov      x29, x29
0x00045348  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004534c  mov      x20, x0
0x00045350  adrp     x2, #0x7d000
0x00045354  add      x2, x2, #0x1a8   ; STR "daily"
0x00045358  mov      x0, x19
0x0004535c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00045360  mov      x29, x29
0x00045364  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045368  mov      x21, x0
0x0004536c  ldr      x0, [x26, #0x970]   ; @CLASS NSDictionary
0x00045370  bl       #0x55d48   ; CALL _objc_opt_class
0x00045374  mov      x1, x0
0x00045378  mov      x0, x20
0x0004537c  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00045380  tbz      w0, #0, #0x455f0
0x00045384  adrp     x2, #0x7d000
0x00045388  add      x2, x2, #0x1c8   ; STR "temperature_2m"
0x0004538c  mov      x0, x20
0x00045390  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00045394  mov      x29, x29
0x00045398  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004539c  mov      x22, x0
0x000453a0  bl       #0x45644
0x000453a4  mov      x29, x29
0x000453a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000453ac  mov      x23, x0
0x000453b0  mov      x0, x22
0x000453b4  bl       #0x55d78   ; CALL _objc_release
0x000453b8  cbz      x23, #0x455f8
0x000453bc  adrp     x8, #0x8e000
0x000453c0  ldr      x0, [x8, #0x9d0]   ; @CLASS NSMutableDictionary
0x000453c4  bl       #0x57780   ; CALL objc_msgSend$dictionary
0x000453c8  mov      x29, x29
0x000453cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000453d0  mov      x22, x0
0x000453d4  adrp     x3, #0x7c000
0x000453d8  add      x3, x3, #0x748   ; STR "temp"
0x000453dc  mov      x2, x23
0x000453e0  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x000453e4  adrp     x2, #0x7d000
0x000453e8  add      x2, x2, #0x1e8   ; STR "weather_code"
0x000453ec  mov      x0, x20
0x000453f0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000453f4  mov      x29, x29
0x000453f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000453fc  mov      x24, x0
0x00045400  bl       #0x45644
0x00045404  mov      x29, x29
0x00045408  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004540c  mov      x25, x0
0x00045410  adrp     x8, #0x80000
0x00045414  add      x8, x8, #0x478
0x00045418  cmp      x0, #0
0x0004541c  csel     x2, x8, x0, eq
0x00045420  adrp     x3, #0x7c000
0x00045424  add      x3, x3, #0x7c8   ; STR "code"
0x00045428  mov      x0, x22
0x0004542c  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x00045430  mov      x0, x25
0x00045434  bl       #0x55d78   ; CALL _objc_release
0x00045438  mov      x0, x24
0x0004543c  bl       #0x55d78   ; CALL _objc_release
0x00045440  adrp     x2, #0x7d000
0x00045444  add      x2, x2, #0x208   ; STR "is_day"
0x00045448  mov      x0, x20
0x0004544c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00045450  mov      x29, x29
0x00045454  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045458  mov      x24, x0
0x0004545c  bl       #0x45644
0x00045460  mov      x29, x29
0x00045464  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045468  mov      x25, x0
0x0004546c  adrp     x8, #0x80000
0x00045470  add      x8, x8, #0x490
0x00045474  cmp      x0, #0
0x00045478  csel     x2, x8, x0, eq
0x0004547c  adrp     x3, #0x7c000
0x00045480  add      x3, x3, #0x7e8   ; STR "isDay"
0x00045484  mov      x0, x22
0x00045488  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0004548c  mov      x0, x25
0x00045490  bl       #0x55d78   ; CALL _objc_release
0x00045494  mov      x0, x24
0x00045498  bl       #0x55d78   ; CALL _objc_release
0x0004549c  ldr      x0, [x26, #0x970]   ; @CLASS NSDictionary
0x000454a0  bl       #0x55d48   ; CALL _objc_opt_class
0x000454a4  mov      x1, x0
0x000454a8  mov      x0, x21
0x000454ac  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x000454b0  tbz      w0, #0, #0x455b0
0x000454b4  adrp     x2, #0x7d000
0x000454b8  add      x2, x2, #0x228   ; STR "temperature_2m_max"
0x000454bc  mov      x0, x21
0x000454c0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000454c4  mov      x29, x29
0x000454c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000454cc  mov      x25, x0
0x000454d0  bl       #0x4569c
0x000454d4  mov      x29, x29
0x000454d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000454dc  mov      x24, x0
0x000454e0  mov      x0, x25
0x000454e4  bl       #0x55d78   ; CALL _objc_release
0x000454e8  adrp     x2, #0x7d000
0x000454ec  add      x2, x2, #0x248   ; STR "temperature_2m_min"
0x000454f0  mov      x0, x21
0x000454f4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000454f8  mov      x29, x29
0x000454fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045500  mov      x26, x0
0x00045504  bl       #0x4569c
0x00045508  mov      x29, x29
0x0004550c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045510  mov      x25, x0
0x00045514  mov      x0, x26
0x00045518  bl       #0x55d78   ; CALL _objc_release
0x0004551c  adrp     x2, #0x7d000
0x00045520  add      x2, x2, #0x268   ; STR "precipitation_probability_max"
0x00045524  mov      x0, x21
0x00045528  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0004552c  mov      x29, x29
0x00045530  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045534  mov      x27, x0
0x00045538  bl       #0x4569c
0x0004553c  mov      x29, x29
0x00045540  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045544  mov      x26, x0
0x00045548  mov      x0, x27
0x0004554c  bl       #0x55d78   ; CALL _objc_release
0x00045550  cbz      x24, #0x45568
0x00045554  adrp     x3, #0x7c000
0x00045558  add      x3, x3, #0x768   ; STR "high"
0x0004555c  mov      x0, x22
0x00045560  mov      x2, x24
0x00045564  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x00045568  cbz      x25, #0x45580
0x0004556c  adrp     x3, #0x7c000
0x00045570  add      x3, x3, #0x788   ; STR "low"
0x00045574  mov      x0, x22
0x00045578  mov      x2, x25
0x0004557c  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x00045580  cbz      x26, #0x45598
0x00045584  adrp     x3, #0x7c000
0x00045588  add      x3, x3, #0x7a8   ; STR "rain"
0x0004558c  mov      x0, x22
0x00045590  mov      x2, x26
0x00045594  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x00045598  mov      x0, x26
0x0004559c  bl       #0x55d78   ; CALL _objc_release
0x000455a0  mov      x0, x25
0x000455a4  bl       #0x55d78   ; CALL _objc_release
0x000455a8  mov      x0, x24
0x000455ac  bl       #0x55d78   ; CALL _objc_release
0x000455b0  adrp     x8, #0x8e000
0x000455b4  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x000455b8  bl       #0x575a0   ; CALL objc_msgSend$date
0x000455bc  mov      x29, x29
0x000455c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000455c4  mov      x24, x0
0x000455c8  adrp     x3, #0x75000
0x000455cc  add      x3, x3, #0x968   ; STR "date"
0x000455d0  mov      x0, x22
0x000455d4  mov      x2, x24
0x000455d8  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x000455dc  mov      x0, x24
0x000455e0  bl       #0x55d78   ; CALL _objc_release
0x000455e4  b        #0x455fc
0x000455e8  mov      x22, #0
0x000455ec  b        #0x4561c
0x000455f0  mov      x22, #0
0x000455f4  b        #0x45604
0x000455f8  mov      x22, #0
0x000455fc  mov      x0, x23
0x00045600  bl       #0x55d78   ; CALL _objc_release
0x00045604  mov      x0, x21
0x00045608  bl       #0x55d78   ; CALL _objc_release
0x0004560c  mov      x0, x20
0x00045610  bl       #0x55d78   ; CALL _objc_release
0x00045614  mov      x0, x19
0x00045618  bl       #0x55d78   ; CALL _objc_release
0x0004561c  mov      x0, x19
0x00045620  bl       #0x55d78   ; CALL _objc_release
0x00045624  mov      x0, x22
0x00045628  ldp      x29, x30, [sp, #0x50]
0x0004562c  ldp      x20, x19, [sp, #0x40]
0x00045630  ldp      x22, x21, [sp, #0x30]
0x00045634  ldp      x24, x23, [sp, #0x20]
0x00045638  ldp      x26, x25, [sp, #0x10]
0x0004563c  ldp      x28, x27, [sp], #0x60
0x00045640  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00045644  stp      x20, x19, [sp, #-0x20]!
0x00045648  stp      x29, x30, [sp, #0x10]
0x0004564c  add      x29, sp, #0x10
0x00045650  mov      x19, x0
0x00045654  adrp     x8, #0x8e000
0x00045658  ldr      x20, [x8, #0x928]   ; @CLASS NSNumber
0x0004565c  bl       #0x55d84   ; CALL _objc_retain
0x00045660  mov      x0, x20
0x00045664  bl       #0x55d48   ; CALL _objc_opt_class
0x00045668  mov      x1, x0
0x0004566c  mov      x0, x19
0x00045670  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00045674  tst      w0, #1
0x00045678  csel     x20, x19, xzr, ne
0x0004567c  mov      x0, x20
0x00045680  bl       #0x55d84   ; CALL _objc_retain
0x00045684  mov      x0, x19
0x00045688  bl       #0x55d78   ; CALL _objc_release
0x0004568c  mov      x0, x20
0x00045690  ldp      x29, x30, [sp, #0x10]
0x00045694  ldp      x20, x19, [sp], #0x20
0x00045698  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0004569c  stp      x22, x21, [sp, #-0x30]!
0x000456a0  stp      x20, x19, [sp, #0x10]
0x000456a4  stp      x29, x30, [sp, #0x20]
0x000456a8  add      x29, sp, #0x20
0x000456ac  mov      x19, x0
0x000456b0  bl       #0x55d84   ; CALL _objc_retain
0x000456b4  adrp     x8, #0x8e000
0x000456b8  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000456bc  bl       #0x55d48   ; CALL _objc_opt_class
0x000456c0  mov      x1, x0
0x000456c4  mov      x0, x19
0x000456c8  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x000456cc  tbz      w0, #0, #0x4570c
0x000456d0  mov      x0, x19
0x000456d4  bl       #0x573c0   ; CALL objc_msgSend$count
0x000456d8  cbz      x0, #0x4570c
0x000456dc  mov      x0, x19
0x000456e0  bl       #0x57c20   ; CALL objc_msgSend$firstObject
0x000456e4  mov      x29, x29
0x000456e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000456ec  mov      x21, x0
0x000456f0  bl       #0x45644
0x000456f4  mov      x29, x29
0x000456f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000456fc  mov      x20, x0
0x00045700  mov      x0, x21
0x00045704  bl       #0x55d78   ; CALL _objc_release
0x00045708  b        #0x45710
0x0004570c  mov      x20, #0
0x00045710  mov      x0, x19
0x00045714  bl       #0x55d78   ; CALL _objc_release
0x00045718  mov      x0, x20
0x0004571c  ldp      x29, x30, [sp, #0x20]
0x00045720  ldp      x20, x19, [sp, #0x10]
0x00045724  ldp      x22, x21, [sp], #0x30
0x00045728  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== _SSWeatherLoadCache  va=0x4572c size=760 types=
0x0004572c  stp      d9, d8, [sp, #-0x70]!
0x00045730  stp      x28, x27, [sp, #0x10]
0x00045734  stp      x26, x25, [sp, #0x20]
0x00045738  stp      x24, x23, [sp, #0x30]
0x0004573c  stp      x22, x21, [sp, #0x40]
0x00045740  stp      x20, x19, [sp, #0x50]
0x00045744  stp      x29, x30, [sp, #0x60]
0x00045748  add      x29, sp, #0x60
0x0004574c  sub      sp, sp, #0x500
0x00045750  mov      v8.16b, v0.16b
0x00045754  adrp     x8, #0x74000
0x00045758  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0004575c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00045760  stur     x8, [x29, #-0x70]
0x00045764  movi     v0.16b, #0
0x00045768  stp      q0, q0, [sp, #0x20]
0x0004576c  stp      q0, q0, [sp, #0x40]
0x00045770  adrp     x0, #0x7d000
0x00045774  add      x0, x0, #0x288   ; STR "/var/mobile/Library/OmniCar/StartupScreen/weather.plist"
0x00045778  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0004577c  add      x1, sp, #0x60
0x00045780  bl       #0x4118
0x00045784  cbz      x0, #0x457a8
0x00045788  mov      x2, x0
0x0004578c  adrp     x8, #0x8e000
0x00045790  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00045794  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00045798  mov      x29, x29
0x0004579c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000457a0  mov      x20, x0
0x000457a4  b        #0x457ac
0x000457a8  mov      x20, #0
0x000457ac  stur     x20, [x29, #-0x100]
0x000457b0  bl       #0x459d8
0x000457b4  mov      x29, x29
0x000457b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000457bc  mov      x21, x0
0x000457c0  stur     x0, [x29, #-0xf8]
0x000457c4  adrp     x8, #0x8e000
0x000457c8  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000457cc  sub      x2, x29, #0x100
0x000457d0  mov      w3, #2
0x000457d4  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000457d8  mov      x29, x29
0x000457dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000457e0  mov      x19, x0
0x000457e4  mov      x0, x21
0x000457e8  bl       #0x55d78   ; CALL _objc_release
0x000457ec  mov      x0, x20
0x000457f0  bl       #0x55d78   ; CALL _objc_release
0x000457f4  add      x2, sp, #0x20
0x000457f8  sub      x3, x29, #0xf0
0x000457fc  str      x19, [sp, #0x18]
0x00045800  mov      x0, x19
0x00045804  mov      w4, #0x10
0x00045808  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0004580c  cbz      x0, #0x45980
0x00045810  mov      x22, x0
0x00045814  stp      xzr, xzr, [sp, #8]
0x00045818  ldr      x8, [sp, #0x30]
0x0004581c  ldr      x24, [x8]   ; @SEL "whatsNewNavigationController"
0x00045820  adrp     x27, #0x8e000
0x00045824  adrp     x20, #0x75000
0x00045828  add      x20, x20, #0x968   ; STR "date"
0x0004582c  adrp     x19, #0x8e000
0x00045830  mov      x21, #0
0x00045834  ldr      x8, [sp, #0x30]
0x00045838  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0004583c  cmp      x8, x24
0x00045840  b.eq     #0x4584c
0x00045844  ldr      x0, [sp, #0x18]
0x00045848  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0004584c  ldr      x8, [sp, #0x28]
0x00045850  ldr      x2, [x8, x21, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00045854  ldr      x0, [x27, #0x970]   ; @CLASS NSDictionary
0x00045858  bl       #0x577a0   ; CALL objc_msgSend$dictionaryWithContentsOfFile:
0x0004585c  mov      x29, x29
0x00045860  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045864  mov      x25, x0
0x00045868  mov      x2, x20
0x0004586c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00045870  mov      x29, x29
0x00045874  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045878  mov      x26, x0
0x0004587c  ldr      x0, [x19, #0x978]   ; @CLASS NSDate
0x00045880  bl       #0x55d48   ; CALL _objc_opt_class
0x00045884  mov      x1, x0
0x00045888  mov      x0, x26
0x0004588c  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00045890  tbz      w0, #0, #0x45944
0x00045894  mov      x23, x19
0x00045898  mov      x19, x27
0x0004589c  mov      x0, x25
0x000458a0  adrp     x2, #0x7c000
0x000458a4  add      x2, x2, #0x748   ; STR "temp"
0x000458a8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000458ac  mov      x29, x29
0x000458b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000458b4  mov      x27, x0
0x000458b8  bl       #0x45644
0x000458bc  mov      x29, x29
0x000458c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000458c4  mov      x28, x0
0x000458c8  bl       #0x55d78   ; CALL _objc_release
0x000458cc  mov      x0, x27
0x000458d0  bl       #0x55d78   ; CALL _objc_release
0x000458d4  cbz      x28, #0x458f4
0x000458d8  fcmp     d8, #0.0
0x000458dc  b.le     #0x458fc
0x000458e0  mov      x0, x26
0x000458e4  bl       #0x5dae0   ; CALL objc_msgSend$timeIntervalSinceNow
0x000458e8  fneg     d0, d0
0x000458ec  fcmp     d8, d0
0x000458f0  b.pl     #0x458fc
0x000458f4  mov      x27, x19
0x000458f8  b        #0x45940
0x000458fc  mov      x27, x19
0x00045900  ldr      x19, [sp, #0x10]
0x00045904  cbz      x19, #0x4591c
0x00045908  mov      x0, x26
0x0004590c  mov      x2, x19
0x00045910  bl       #0x56f60   ; CALL objc_msgSend$compare:
0x00045914  cmp      x0, #1
0x00045918  b.ne     #0x45940
0x0004591c  mov      x0, x25
0x00045920  bl       #0x55d84   ; CALL _objc_retain
0x00045924  ldr      x0, [sp, #8]
0x00045928  bl       #0x55d78   ; CALL _objc_release
0x0004592c  mov      x0, x26
0x00045930  bl       #0x55d84   ; CALL _objc_retain
0x00045934  mov      x0, x19
0x00045938  bl       #0x55d78   ; CALL _objc_release
0x0004593c  stp      x25, x26, [sp, #8]
0x00045940  mov      x19, x23
0x00045944  mov      x0, x26
0x00045948  bl       #0x55d78   ; CALL _objc_release
0x0004594c  mov      x0, x25
0x00045950  bl       #0x55d78   ; CALL _objc_release
0x00045954  add      x21, x21, #1
0x00045958  cmp      x22, x21
0x0004595c  b.ne     #0x45834
0x00045960  add      x2, sp, #0x20
0x00045964  sub      x3, x29, #0xf0
0x00045968  ldr      x0, [sp, #0x18]
0x0004596c  mov      w4, #0x10
0x00045970  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00045974  mov      x22, x0
0x00045978  cbnz     x0, #0x45830
0x0004597c  b        #0x45984
0x00045980  stp      xzr, xzr, [sp, #8]
0x00045984  ldr      x0, [sp, #0x18]
0x00045988  bl       #0x55d78   ; CALL _objc_release
0x0004598c  ldr      x0, [sp, #0x10]
0x00045990  bl       #0x55d78   ; CALL _objc_release
0x00045994  ldur     x8, [x29, #-0x70]
0x00045998  adrp     x9, #0x74000
0x0004599c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000459a0  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000459a4  cmp      x9, x8
0x000459a8  b.ne     #0x459d4
0x000459ac  ldr      x0, [sp, #8]
0x000459b0  add      sp, sp, #0x500
0x000459b4  ldp      x29, x30, [sp, #0x60]
0x000459b8  ldp      x20, x19, [sp, #0x50]
0x000459bc  ldp      x22, x21, [sp, #0x40]
0x000459c0  ldp      x24, x23, [sp, #0x30]
0x000459c4  ldp      x26, x25, [sp, #0x20]
0x000459c8  ldp      x28, x27, [sp, #0x10]
0x000459cc  ldp      d9, d8, [sp], #0x70
0x000459d0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x000459d4  bl       #0x55b98   ; CALL ___stack_chk_fail
0x000459d8  stp      x20, x19, [sp, #-0x20]!
0x000459dc  stp      x29, x30, [sp, #0x10]
0x000459e0  add      x29, sp, #0x10
0x000459e4  bl       #0x55b14   ; CALL _NSTemporaryDirectory
0x000459e8  mov      x29, x29
0x000459ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000459f0  mov      x19, x0
0x000459f4  adrp     x2, #0x7e000
0x000459f8  add      x2, x2, #0x68   ; STR "OmniCarStartupWeather.plist"
0x000459fc  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00045a00  mov      x29, x29
0x00045a04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045a08  mov      x20, x0
0x00045a0c  mov      x0, x19
0x00045a10  bl       #0x55d78   ; CALL _objc_release
0x00045a14  mov      x0, x20
0x00045a18  ldp      x29, x30, [sp, #0x10]
0x00045a1c  ldp      x20, x19, [sp], #0x20
0x00045a20  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== _SSWeatherSaveCache  va=0x45a24 size=620 types=
0x00045a24  stp      x26, x25, [sp, #-0x50]!
0x00045a28  stp      x24, x23, [sp, #0x10]
0x00045a2c  stp      x22, x21, [sp, #0x20]
0x00045a30  stp      x20, x19, [sp, #0x30]
0x00045a34  stp      x29, x30, [sp, #0x40]
0x00045a38  add      x29, sp, #0x40
0x00045a3c  sub      sp, sp, #0x420
0x00045a40  mov      x19, x0
0x00045a44  adrp     x8, #0x74000
0x00045a48  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00045a4c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00045a50  stur     x8, [x29, #-0x48]
0x00045a54  bl       #0x55d84   ; CALL _objc_retain
0x00045a58  cbz      x19, #0x45c50
0x00045a5c  adrp     x8, #0x8e000
0x00045a60  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x00045a64  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x00045a68  mov      x29, x29
0x00045a6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045a70  mov      x20, x0
0x00045a74  adrp     x0, #0x7d000
0x00045a78  add      x0, x0, #0x288   ; STR "/var/mobile/Library/OmniCar/StartupScreen/weather.plist"
0x00045a7c  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00045a80  add      x1, sp, #0x18
0x00045a84  bl       #0x4118
0x00045a88  adrp     x24, #0x8e000
0x00045a8c  cbz      x0, #0x45aac
0x00045a90  mov      x2, x0
0x00045a94  ldr      x0, [x24, #0x958]   ; @CLASS NSString
0x00045a98  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00045a9c  mov      x29, x29
0x00045aa0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045aa4  mov      x21, x0
0x00045aa8  b        #0x45ab0
0x00045aac  mov      x21, #0
0x00045ab0  mov      x0, x21
0x00045ab4  bl       #0x5d460   ; CALL objc_msgSend$stringByDeletingLastPathComponent
0x00045ab8  mov      x29, x29
0x00045abc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045ac0  mov      x22, x0
0x00045ac4  mov      x0, x20
0x00045ac8  mov      x2, x22
0x00045acc  mov      w3, #1
0x00045ad0  mov      x4, #0
0x00045ad4  mov      x5, #0
0x00045ad8  bl       #0x57400   ; CALL objc_msgSend$createDirectoryAtPath:withIntermediateDirectories:attributes:error:
0x00045adc  mov      x0, x22
0x00045ae0  bl       #0x55d78   ; CALL _objc_release
0x00045ae4  mov      x0, x21
0x00045ae8  bl       #0x55d78   ; CALL _objc_release
0x00045aec  adrp     x25, #0x8e000
0x00045af0  ldr      x21, [x25, #0xa10]   ; @CLASS NSURL
0x00045af4  adrp     x0, #0x7d000
0x00045af8  add      x0, x0, #0x288   ; STR "/var/mobile/Library/OmniCar/StartupScreen/weather.plist"
0x00045afc  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00045b00  add      x1, sp, #0x18
0x00045b04  bl       #0x4118
0x00045b08  cbz      x0, #0x45b28
0x00045b0c  mov      x2, x0
0x00045b10  ldr      x0, [x24, #0x958]   ; @CLASS NSString
0x00045b14  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00045b18  mov      x29, x29
0x00045b1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045b20  mov      x22, x0
0x00045b24  b        #0x45b2c
0x00045b28  mov      x22, #0
0x00045b2c  mov      x0, x21
0x00045b30  mov      x2, x22
0x00045b34  bl       #0x57ba0   ; CALL objc_msgSend$fileURLWithPath:
0x00045b38  mov      x29, x29
0x00045b3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045b40  mov      x21, x0
0x00045b44  str      xzr, [sp]
0x00045b48  mov      x3, sp
0x00045b4c  mov      x0, x19
0x00045b50  mov      x2, x21
0x00045b54  bl       #0x5e280   ; CALL objc_msgSend$writeToURL:error:
0x00045b58  mov      x23, x0
0x00045b5c  mov      x0, x21
0x00045b60  bl       #0x55d78   ; CALL _objc_release
0x00045b64  mov      x0, x22
0x00045b68  bl       #0x55d78   ; CALL _objc_release
0x00045b6c  cbz      w23, #0x45be0
0x00045b70  adrp     x8, #0x74000
0x00045b74  ldr      x8, [x8, #0x120]   ; @GOT _NSFilePosixPermissions
0x00045b78  ldr      x9, [x8]   ; @GOT ___objc_personality_v0
0x00045b7c  adrp     x8, #0x80000
0x00045b80  add      x8, x8, #0x4a8
0x00045b84  stp      x9, x8, [sp, #8]
0x00045b88  adrp     x8, #0x8e000
0x00045b8c  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00045b90  add      x2, sp, #0x10
0x00045b94  add      x3, sp, #8
0x00045b98  mov      w4, #1
0x00045b9c  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00045ba0  mov      x29, x29
0x00045ba4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045ba8  mov      x21, x0
0x00045bac  adrp     x0, #0x7d000
0x00045bb0  add      x0, x0, #0x288   ; STR "/var/mobile/Library/OmniCar/StartupScreen/weather.plist"
0x00045bb4  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00045bb8  add      x1, sp, #0x18
0x00045bbc  bl       #0x4118
0x00045bc0  cbz      x0, #0x45c20
0x00045bc4  mov      x2, x0
0x00045bc8  ldr      x0, [x24, #0x958]   ; @CLASS NSString
0x00045bcc  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00045bd0  mov      x29, x29
0x00045bd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045bd8  mov      x22, x0
0x00045bdc  b        #0x45c24
0x00045be0  ldr      x22, [x25, #0xa10]   ; @CLASS NSURL
0x00045be4  bl       #0x459d8
0x00045be8  mov      x29, x29
0x00045bec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045bf0  mov      x21, x0
0x00045bf4  mov      x0, x22
0x00045bf8  mov      x2, x21
0x00045bfc  bl       #0x57ba0   ; CALL objc_msgSend$fileURLWithPath:
0x00045c00  mov      x29, x29
0x00045c04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045c08  mov      x22, x0
0x00045c0c  mov      x0, x19
0x00045c10  mov      x2, x22
0x00045c14  mov      x3, #0
0x00045c18  bl       #0x5e280   ; CALL objc_msgSend$writeToURL:error:
0x00045c1c  b        #0x45c38
0x00045c20  mov      x22, #0
0x00045c24  mov      x0, x20
0x00045c28  mov      x2, x21
0x00045c2c  mov      x3, x22
0x00045c30  mov      x4, #0
0x00045c34  bl       #0x5a4e0   ; CALL objc_msgSend$setAttributes:ofItemAtPath:error:
0x00045c38  mov      x0, x22
0x00045c3c  bl       #0x55d78   ; CALL _objc_release
0x00045c40  mov      x0, x21
0x00045c44  bl       #0x55d78   ; CALL _objc_release
0x00045c48  mov      x0, x20
0x00045c4c  bl       #0x55d78   ; CALL _objc_release
0x00045c50  mov      x0, x19
0x00045c54  bl       #0x55d78   ; CALL _objc_release
0x00045c58  ldur     x8, [x29, #-0x48]
0x00045c5c  adrp     x9, #0x74000
0x00045c60  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00045c64  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00045c68  cmp      x9, x8
0x00045c6c  b.ne     #0x45c8c
0x00045c70  add      sp, sp, #0x420
0x00045c74  ldp      x29, x30, [sp, #0x40]
0x00045c78  ldp      x20, x19, [sp, #0x30]
0x00045c7c  ldp      x22, x21, [sp, #0x20]
0x00045c80  ldp      x24, x23, [sp, #0x10]
0x00045c84  ldp      x26, x25, [sp], #0x50
0x00045c88  ret      
0x00045c8c  bl       #0x55b98   ; CALL ___stack_chk_fail

=== _SSPeriodForDate  va=0x45c90 size=220 types=
0x00045c90  stp      x22, x21, [sp, #-0x30]!
0x00045c94  stp      x20, x19, [sp, #0x10]
0x00045c98  stp      x29, x30, [sp, #0x20]
0x00045c9c  add      x29, sp, #0x20
0x00045ca0  mov      x19, x0
0x00045ca4  bl       #0x55d84   ; CALL _objc_retain
0x00045ca8  adrp     x8, #0x8e000
0x00045cac  ldr      x0, [x8, #0x9f8]   ; @CLASS NSCalendar
0x00045cb0  bl       #0x57420   ; CALL objc_msgSend$currentCalendar
0x00045cb4  mov      x29, x29
0x00045cb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045cbc  mov      x20, x0
0x00045cc0  cbz      x19, #0x45cdc
0x00045cc4  mov      x0, x20
0x00045cc8  mov      w2, #0x20
0x00045ccc  mov      x3, x19
0x00045cd0  bl       #0x56fc0   ; CALL objc_msgSend$component:fromDate:
0x00045cd4  mov      x21, x0
0x00045cd8  b        #0x45d10
0x00045cdc  adrp     x8, #0x8e000
0x00045ce0  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x00045ce4  bl       #0x575a0   ; CALL objc_msgSend$date
0x00045ce8  mov      x29, x29
0x00045cec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00045cf0  mov      x22, x0
0x00045cf4  mov      x0, x20
0x00045cf8  mov      w2, #0x20
0x00045cfc  mov      x3, x22
0x00045d00  bl       #0x56fc0   ; CALL objc_msgSend$component:fromDate:
0x00045d04  mov      x21, x0
0x00045d08  mov      x0, x22
0x00045d0c  bl       #0x55d78   ; CALL _objc_release
0x00045d10  mov      x0, x20
0x00045d14  bl       #0x55d78   ; CALL _objc_release
0x00045d18  sub      x8, x21, #5
0x00045d1c  cmp      x8, #6
0x00045d20  b.hs     #0x45d2c
0x00045d24  mov      x20, #0
0x00045d28  b        #0x45d50
0x00045d2c  sub      x8, x21, #0xb
0x00045d30  cmp      x8, #6
0x00045d34  b.hs     #0x45d40
0x00045d38  mov      w20, #1
0x00045d3c  b        #0x45d50
0x00045d40  sub      x8, x21, #0x11
0x00045d44  cmp      x8, #4
0x00045d48  mov      w8, #2
0x00045d4c  cinc     x20, x8, hs
0x00045d50  mov      x0, x19
0x00045d54  bl       #0x55d78   ; CALL _objc_release
0x00045d58  mov      x0, x20
0x00045d5c  ldp      x29, x30, [sp, #0x20]
0x00045d60  ldp      x20, x19, [sp, #0x10]
0x00045d64  ldp      x22, x21, [sp], #0x30
0x00045d68  ret      

=== _SSApplySampleData  va=0x545b0 size=980 types=
0x000545b0  sub      sp, sp, #0xd0
0x000545b4  stp      x22, x21, [sp, #0xa0]
0x000545b8  stp      x20, x19, [sp, #0xb0]
0x000545bc  stp      x29, x30, [sp, #0xc0]
0x000545c0  add      x29, sp, #0xc0
0x000545c4  mov      x19, x0
0x000545c8  adrp     x8, #0x74000
0x000545cc  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000545d0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000545d4  stur     x8, [x29, #-0x28]
0x000545d8  bl       #0x55d84   ; CALL _objc_retain
0x000545dc  cbz      x19, #0x54810
0x000545e0  mov      x0, x19
0x000545e4  bl       #0x57fe0   ; CALL objc_msgSend$hud
0x000545e8  mov      x29, x29
0x000545ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000545f0  mov      x20, x0
0x000545f4  bl       #0x55d78   ; CALL _objc_release
0x000545f8  cbnz     x20, #0x5463c
0x000545fc  mov      x0, x19
0x00054600  bl       #0x56be0   ; CALL objc_msgSend$carName
0x00054604  mov      x29, x29
0x00054608  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005460c  mov      x20, x0
0x00054610  bl       #0x50180
0x00054614  mov      x29, x29
0x00054618  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005461c  mov      x21, x0
0x00054620  mov      x0, x19
0x00054624  mov      x2, x21
0x00054628  bl       #0x5b020   ; CALL objc_msgSend$setHud:
0x0005462c  mov      x0, x21
0x00054630  bl       #0x55d78   ; CALL _objc_release
0x00054634  mov      x0, x20
0x00054638  bl       #0x55d78   ; CALL _objc_release
0x0005463c  mov      x0, x19
0x00054640  bl       #0x591e0   ; CALL objc_msgSend$nextEvent
0x00054644  mov      x29, x29
0x00054648  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005464c  mov      x20, x0
0x00054650  bl       #0x55d78   ; CALL _objc_release
0x00054654  cbnz     x20, #0x546fc
0x00054658  adrp     x8, #0x75000
0x0005465c  add      x8, x8, #0x4a8   ; STR "title"
0x00054660  stur     x8, [x29, #-0x48]
0x00054664  adrp     x0, #0x7e000
0x00054668  add      x0, x0, #0x28   ; STR "Họp nhóm"
0x0005466c  adrp     x1, #0x7e000
0x00054670  add      x1, x1, #0x48   ; STR "Team meeting"
0x00054674  bl       #0x5505c   ; CALL _OMCTr
0x00054678  mov      x29, x29
0x0005467c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00054680  mov      x20, x0
0x00054684  adrp     x8, #0x75000
0x00054688  add      x8, x8, #0x968   ; STR "date"
0x0005468c  stp      x8, x0, [x29, #-0x40]
0x00054690  adrp     x8, #0x8e000
0x00054694  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x00054698  adrp     x8, #0x66000
0x0005469c  ldr      d0, [x8, #0x290]
0x000546a0  bl       #0x57620   ; CALL objc_msgSend$dateWithTimeIntervalSinceNow:
0x000546a4  mov      x29, x29
0x000546a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000546ac  mov      x21, x0
0x000546b0  stur     x0, [x29, #-0x30]
0x000546b4  adrp     x8, #0x8e000
0x000546b8  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x000546bc  sub      x2, x29, #0x38
0x000546c0  sub      x3, x29, #0x48
0x000546c4  mov      w4, #2
0x000546c8  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x000546cc  mov      x29, x29
0x000546d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000546d4  mov      x22, x0
0x000546d8  mov      x0, x19
0x000546dc  mov      x2, x22
0x000546e0  bl       #0x5b7c0   ; CALL objc_msgSend$setNextEvent:
0x000546e4  mov      x0, x22
0x000546e8  bl       #0x55d78   ; CALL _objc_release
0x000546ec  mov      x0, x21
0x000546f0  bl       #0x55d78   ; CALL _objc_release
0x000546f4  mov      x0, x20
0x000546f8  bl       #0x55d78   ; CALL _objc_release
0x000546fc  mov      x0, x19
0x00054700  bl       #0x56740   ; CALL objc_msgSend$batteryPercent
0x00054704  tbz      x0, #0x3f, #0x54714
0x00054708  mov      x0, x19
0x0005470c  mov      w2, #0x52
0x00054710  bl       #0x5a640   ; CALL objc_msgSend$setBatteryPercent:
0x00054714  mov      x0, x19
0x00054718  bl       #0x5e100   ; CALL objc_msgSend$weather
0x0005471c  mov      x29, x29
0x00054720  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00054724  mov      x20, x0
0x00054728  bl       #0x55d78   ; CALL _objc_release
0x0005472c  cbnz     x20, #0x54810
0x00054730  adrp     x8, #0x7c000
0x00054734  add      x8, x8, #0x748   ; STR "temp"
0x00054738  adrp     x9, #0x7c000
0x0005473c  add      x9, x9, #0x768   ; STR "high"
0x00054740  stp      x8, x9, [sp, #8]
0x00054744  adrp     x8, #0x80000
0x00054748  add      x8, x8, #0x670
0x0005474c  adrp     x9, #0x80000
0x00054750  add      x9, x9, #0x688
0x00054754  stp      x8, x9, [sp, #0x40]
0x00054758  adrp     x8, #0x7c000
0x0005475c  add      x8, x8, #0x788   ; STR "low"
0x00054760  adrp     x9, #0x7c000
0x00054764  add      x9, x9, #0x7a8   ; STR "rain"
0x00054768  stp      x8, x9, [sp, #0x18]
0x0005476c  adrp     x8, #0x80000
0x00054770  add      x8, x8, #0x6a0
0x00054774  adrp     x9, #0x80000
0x00054778  add      x9, x9, #0x6b8
0x0005477c  stp      x8, x9, [sp, #0x50]
0x00054780  adrp     x8, #0x7c000
0x00054784  add      x8, x8, #0x7c8   ; STR "code"
0x00054788  adrp     x9, #0x7c000
0x0005478c  add      x9, x9, #0x7e8   ; STR "isDay"
0x00054790  stp      x8, x9, [sp, #0x28]
0x00054794  adrp     x8, #0x80000
0x00054798  add      x8, x8, #0x6d0
0x0005479c  adrp     x9, #0x80000
0x000547a0  add      x9, x9, #0x490
0x000547a4  stp      x8, x9, [sp, #0x60]
0x000547a8  adrp     x8, #0x75000
0x000547ac  add      x8, x8, #0x968   ; STR "date"
0x000547b0  str      x8, [sp, #0x38]
0x000547b4  adrp     x8, #0x8e000
0x000547b8  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x000547bc  bl       #0x575a0   ; CALL objc_msgSend$date
0x000547c0  mov      x29, x29
0x000547c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000547c8  mov      x20, x0
0x000547cc  str      x0, [sp, #0x70]
0x000547d0  adrp     x8, #0x8e000
0x000547d4  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x000547d8  add      x2, sp, #0x40
0x000547dc  add      x3, sp, #8
0x000547e0  mov      w4, #7
0x000547e4  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x000547e8  mov      x29, x29
0x000547ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000547f0  mov      x21, x0
0x000547f4  mov      x0, x19
0x000547f8  mov      x2, x21
0x000547fc  bl       #0x5c8e0   ; CALL objc_msgSend$setWeather:
0x00054800  mov      x0, x21
0x00054804  bl       #0x55d78   ; CALL _objc_release
0x00054808  mov      x0, x20
0x0005480c  bl       #0x55d78   ; CALL _objc_release
0x00054810  mov      x0, x19
0x00054814  bl       #0x55d78   ; CALL _objc_release
0x00054818  ldur     x8, [x29, #-0x28]
0x0005481c  adrp     x9, #0x74000
0x00054820  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00054824  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00054828  cmp      x9, x8
0x0005482c  b.ne     #0x54844
0x00054830  ldp      x29, x30, [sp, #0xc0]
0x00054834  ldp      x20, x19, [sp, #0xb0]
0x00054838  ldp      x22, x21, [sp, #0xa0]
0x0005483c  add      sp, sp, #0xd0
0x00054840  ret      
0x00054844  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00054848  sub      sp, sp, #0x70
0x0005484c  stp      d9, d8, [sp, #0x30]
0x00054850  stp      x22, x21, [sp, #0x40]
0x00054854  stp      x20, x19, [sp, #0x50]
0x00054858  stp      x29, x30, [sp, #0x60]
0x0005485c  add      x29, sp, #0x60
0x00054860  mov      x19, x0
0x00054864  mov      v8.16b, v1.16b
0x00054868  mov      v9.16b, v0.16b
0x0005486c  bl       #0x55d84   ; CALL _objc_retain
0x00054870  adrp     x8, #0x8e000
0x00054874  ldr      x0, [x8, #0xb58]   ; @CLASS UIGraphicsImageRendererFormat
0x00054878  bl       #0x59920   ; CALL objc_msgSend$preferredFormat
0x0005487c  mov      x29, x29
0x00054880  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00054884  mov      x20, x0
0x00054888  mov      w2, #0
0x0005488c  bl       #0x5b960   ; CALL objc_msgSend$setOpaque:
0x00054890  adrp     x8, #0x8e000
0x00054894  ldr      x0, [x8, #0xb00]   ; @CLASS UIGraphicsImageRenderer
0x00054898  bl       #0x55c7c   ; CALL _objc_alloc
0x0005489c  mov      v0.16b, v9.16b
0x000548a0  mov      v1.16b, v8.16b
0x000548a4  mov      x2, x20
0x000548a8  bl       #0x58560   ; CALL objc_msgSend$initWithSize:format:
0x000548ac  mov      x21, x0
0x000548b0  adrp     x8, #0x74000
0x000548b4  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x000548b8  str      x8, [sp, #8]
0x000548bc  adrp     x8, #0x65000
0x000548c0  ldr      d0, [x8, #0x600]
0x000548c4  adrp     x8, #0x54000
0x000548c8  add      x8, x8, #0x954
0x000548cc  str      d0, [sp, #0x10]
0x000548d0  adrp     x9, #0x74000
0x000548d4  add      x9, x9, #0xea8
0x000548d8  stp      x8, x9, [sp, #0x18]
0x000548dc  str      x19, [sp, #0x28]
0x000548e0  mov      x0, x19
0x000548e4  bl       #0x55d84   ; CALL _objc_retain
0x000548e8  add      x2, sp, #8
0x000548ec  mov      x0, x21
0x000548f0  bl       #0x58140   ; CALL objc_msgSend$imageWithActions:
0x000548f4  mov      x29, x29
0x000548f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000548fc  mov      x22, x0
0x00054900  ldr      x0, [sp, #0x28]
0x00054904  bl       #0x55d78   ; CALL _objc_release
0x00054908  mov      x0, x19
0x0005490c  bl       #0x55d78   ; CALL _objc_release
0x00054910  mov      x0, x21
0x00054914  bl       #0x55d78   ; CALL _objc_release
0x00054918  mov      x0, x20
0x0005491c  bl       #0x55d78   ; CALL _objc_release
0x00054920  mov      x0, x22
0x00054924  ldp      x29, x30, [sp, #0x60]
0x00054928  ldp      x20, x19, [sp, #0x50]
0x0005492c  ldp      x22, x21, [sp, #0x40]
0x00054930  ldp      d9, d8, [sp, #0x30]
0x00054934  add      sp, sp, #0x70
0x00054938  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0005493c  ldr      x8, [x0, #0x20]   ; @STR "Team meeting"
0x00054940  ldp      d2, d3, [x0, #0x28]
0x00054944  fmov     d0, xzr
0x00054948  fmov     d1, xzr
0x0005494c  mov      x0, x8
0x00054950  b        #0x578e0   ; CALL objc_msgSend$drawInRect:
0x00054954  stp      x20, x19, [sp, #-0x20]!
0x00054958  stp      x29, x30, [sp, #0x10]
0x0005495c  add      x29, sp, #0x10
0x00054960  ldr      x19, [x0, #0x20]   ; @STR "Team meeting"
0x00054964  mov      x0, x1
0x00054968  bl       #0x55ea0   ; CALL objc_msgSend$CGContext
0x0005496c  mov      x1, x0
0x00054970  ldr      x2, [x19, #0x10]
0x00054974  mov      x0, x19
0x00054978  ldp      x29, x30, [sp, #0x10]
0x0005497c  ldp      x20, x19, [sp], #0x20
0x00054980  br       x2

=== _OMCExpired  va=0x54bb0 size=252 types=
0x00054bb0  stp      d9, d8, [sp, #-0x40]!
0x00054bb4  stp      x22, x21, [sp, #0x10]
0x00054bb8  stp      x20, x19, [sp, #0x20]
0x00054bbc  stp      x29, x30, [sp, #0x30]
0x00054bc0  add      x29, sp, #0x30
0x00054bc4  adrp     x21, #0x90000
0x00054bc8  ldrb     w8, [x21, #0xc8]
0x00054bcc  tbz      w8, #0, #0x54bd8
0x00054bd0  mov      w20, #1
0x00054bd4  b        #0x54c8c
0x00054bd8  adrp     x8, #0x90000
0x00054bdc  ldr      x8, [x8, #0xf8]
0x00054be0  cmn      x8, #1
0x00054be4  b.ne     #0x54ca4
0x00054be8  adrp     x8, #0x90000
0x00054bec  ldr      d9, [x8, #0xf0]
0x00054bf0  fcmp     d9, #0.0
0x00054bf4  b.ls     #0x54c74
0x00054bf8  adrp     x8, #0x8e000
0x00054bfc  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x00054c00  bl       #0x575a0   ; CALL objc_msgSend$date
0x00054c04  mov      x29, x29
0x00054c08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00054c0c  mov      x19, x0
0x00054c10  bl       #0x5daa0   ; CALL objc_msgSend$timeIntervalSince1970
0x00054c14  mov      v8.16b, v0.16b
0x00054c18  mov      x0, x19
0x00054c1c  bl       #0x55d78   ; CALL _objc_release
0x00054c20  adrp     x0, #0x7e000
0x00054c24  add      x0, x0, #0x748   ; STR "trustedTime"
0x00054c28  adrp     x1, #0x75000
0x00054c2c  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x00054c30  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x00054c34  mov      x19, x0
0x00054c38  adrp     x8, #0x8e000
0x00054c3c  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x00054c40  bl       #0x55d48   ; CALL _objc_opt_class
0x00054c44  mov      x1, x0
0x00054c48  mov      x0, x19
0x00054c4c  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00054c50  tbz      w0, #0, #0x54c64
0x00054c54  mov      x0, x19
0x00054c58  bl       #0x57880   ; CALL objc_msgSend$doubleValue
0x00054c5c  fcmp     d8, d0
0x00054c60  fcsel    d8, d0, d8, mi
0x00054c64  fcmp     d8, d9
0x00054c68  b.ge     #0x54c7c
0x00054c6c  ldrb     w20, [x21, #0xc8]
0x00054c70  b        #0x54c84
0x00054c74  mov      w20, #0
0x00054c78  b        #0x54c8c
0x00054c7c  mov      w20, #1
0x00054c80  strb     w20, [x21, #0xc8]
0x00054c84  mov      x0, x19
0x00054c88  bl       #0x55d78   ; CALL _objc_release
0x00054c8c  mov      x0, x20
0x00054c90  ldp      x29, x30, [sp, #0x30]
0x00054c94  ldp      x20, x19, [sp, #0x20]
0x00054c98  ldp      x22, x21, [sp, #0x10]
0x00054c9c  ldp      d9, d8, [sp], #0x40
0x00054ca0  ret      
0x00054ca4  bl       #0x557c8
0x00054ca8  b        #0x54be8

=== _OMCProfileKeys  va=0x54cac size=12 types=
0x00054cac  adrp     x0, #0x7f000
0x00054cb0  add      x0, x0, #0xfd8
0x00054cb4  ret      

=== _OMCSupportedLanguages  va=0x54cb8 size=12 types=
0x00054cb8  adrp     x0, #0x7f000
0x00054cbc  add      x0, x0, #0xff0
0x00054cc0  ret      

=== _OMCCurrentLanguage  va=0x54cc4 size=920 types=
0x00054cc4  stp      x28, x27, [sp, #-0x60]!
0x00054cc8  stp      x26, x25, [sp, #0x10]
0x00054ccc  stp      x24, x23, [sp, #0x20]
0x00054cd0  stp      x22, x21, [sp, #0x30]
0x00054cd4  stp      x20, x19, [sp, #0x40]
0x00054cd8  stp      x29, x30, [sp, #0x50]
0x00054cdc  add      x29, sp, #0x50
0x00054ce0  sub      sp, sp, #0x280
0x00054ce4  adrp     x8, #0x74000
0x00054ce8  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00054cec  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00054cf0  stur     x8, [x29, #-0x60]
0x00054cf4  adrp     x0, #0x78000
0x00054cf8  add      x0, x0, #0x908   ; STR "language"
0x00054cfc  adrp     x1, #0x75000
0x00054d00  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x00054d04  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x00054d08  mov      x19, x0
0x00054d0c  adrp     x8, #0x8e000
0x00054d10  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00054d14  bl       #0x55d48   ; CALL _objc_opt_class
0x00054d18  mov      x1, x0
0x00054d1c  mov      x0, x19
0x00054d20  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00054d24  tbz      w0, #0, #0x54d4c
0x00054d28  adrp     x0, #0x7f000
0x00054d2c  add      x0, x0, #0xff0
0x00054d30  mov      x2, x19
0x00054d34  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x00054d38  cbz      w0, #0x54d4c
0x00054d3c  mov      x0, x19
0x00054d40  bl       #0x55d84   ; CALL _objc_retain
0x00054d44  mov      x26, x19
0x00054d48  b        #0x54ffc
0x00054d4c  movi     v0.16b, #0
0x00054d50  stp      q0, q0, [sp, #0xd0]
0x00054d54  stp      q0, q0, [sp, #0xb0]
0x00054d58  adrp     x8, #0x8e000
0x00054d5c  ldr      x0, [x8, #0xa08]   ; @CLASS NSLocale
0x00054d60  bl       #0x59940   ; CALL objc_msgSend$preferredLanguages
0x00054d64  mov      x29, x29
0x00054d68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00054d6c  mov      x20, x0
0x00054d70  add      x2, sp, #0xb0
0x00054d74  sub      x3, x29, #0xe0
0x00054d78  mov      w4, #0x10
0x00054d7c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00054d80  cbz      x0, #0x54fd8
0x00054d84  ldr      x8, [sp, #0xc0]
0x00054d88  ldr      x22, [x8]   ; @SEL "whatsNewNavigationController"
0x00054d8c  adrp     x21, #0x7f000
0x00054d90  add      x21, x21, #0xff0
0x00054d94  adrp     x23, #0x7e000
0x00054d98  add      x23, x23, #0x7e8   ; STR "-"
0x00054d9c  str      x20, [sp, #0x28]
0x00054da0  str      x22, [sp, #0x10]
0x00054da4  mov      x24, #0
0x00054da8  str      x0, [sp, #0x18]
0x00054dac  ldr      x8, [sp, #0xc0]
0x00054db0  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00054db4  cmp      x8, x22
0x00054db8  b.eq     #0x54dc4
0x00054dbc  mov      x0, x20
0x00054dc0  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00054dc4  ldr      x8, [sp, #0xb8]
0x00054dc8  str      x24, [sp, #0x20]
0x00054dcc  ldr      x25, [x8, x24, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00054dd0  movi     v0.16b, #0
0x00054dd4  stp      q0, q0, [sp, #0x70]
0x00054dd8  stp      q0, q0, [sp, #0x90]
0x00054ddc  add      x2, sp, #0x70
0x00054de0  add      x3, sp, #0x170
0x00054de4  mov      x0, x21
0x00054de8  mov      w4, #0x10
0x00054dec  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00054df0  cbz      x0, #0x54e90
0x00054df4  mov      x27, x0
0x00054df8  ldr      x8, [sp, #0x80]
0x00054dfc  ldr      x22, [x8]   ; @CSTR "whatsNewNavigationController"
0x00054e00  mov      x20, #0
0x00054e04  ldr      x8, [sp, #0x80]
0x00054e08  ldr      x8, [x8]   ; @CSTR "whatsNewNavigationController"
0x00054e0c  cmp      x8, x22
0x00054e10  b.eq     #0x54e1c
0x00054e14  mov      x0, x21
0x00054e18  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00054e1c  ldr      x8, [sp, #0x78]
0x00054e20  ldr      x26, [x8, x20, lsl #3]
0x00054e24  mov      x0, x25
0x00054e28  mov      x2, x26
0x00054e2c  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00054e30  tbnz     w0, #0, #0x54fec
0x00054e34  mov      x0, x26
0x00054e38  mov      x2, x23
0x00054e3c  bl       #0x5d440   ; CALL objc_msgSend$stringByAppendingString:
0x00054e40  mov      x29, x29
0x00054e44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00054e48  mov      x28, x0
0x00054e4c  mov      x0, x25
0x00054e50  mov      x2, x28
0x00054e54  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x00054e58  mov      x24, x0
0x00054e5c  mov      x0, x28
0x00054e60  bl       #0x55d78   ; CALL _objc_release
0x00054e64  tbnz     w24, #0, #0x54fec
0x00054e68  add      x20, x20, #1
0x00054e6c  cmp      x27, x20
0x00054e70  b.ne     #0x54e04
0x00054e74  add      x2, sp, #0x70
0x00054e78  add      x3, sp, #0x170
0x00054e7c  mov      x0, x21
0x00054e80  mov      w4, #0x10
0x00054e84  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00054e88  mov      x27, x0
0x00054e8c  cbnz     x0, #0x54e00
0x00054e90  mov      x0, x25
0x00054e94  mov      x2, x23
0x00054e98  bl       #0x57040   ; CALL objc_msgSend$componentsSeparatedByString:
0x00054e9c  mov      x29, x29
0x00054ea0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00054ea4  mov      x24, x0
0x00054ea8  bl       #0x57c20   ; CALL objc_msgSend$firstObject
0x00054eac  mov      x29, x29
0x00054eb0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00054eb4  mov      x25, x0
0x00054eb8  mov      x0, x24
0x00054ebc  bl       #0x55d78   ; CALL _objc_release
0x00054ec0  mov      x0, x25
0x00054ec4  adrp     x2, #0x7e000
0x00054ec8  add      x2, x2, #0x808   ; STR "zh"
0x00054ecc  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00054ed0  tbnz     w0, #0, #0x54fa0
0x00054ed4  movi     v0.16b, #0
0x00054ed8  stp      q0, q0, [sp, #0x50]
0x00054edc  stp      q0, q0, [sp, #0x30]
0x00054ee0  add      x2, sp, #0x30
0x00054ee4  add      x3, sp, #0xf0
0x00054ee8  mov      x0, x21
0x00054eec  mov      w4, #0x10
0x00054ef0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00054ef4  cbz      x0, #0x54fa0
0x00054ef8  mov      x27, x0
0x00054efc  ldr      x8, [sp, #0x40]
0x00054f00  ldr      x20, [x8]
0x00054f04  str      x19, [sp, #8]
0x00054f08  mov      x19, #0
0x00054f0c  ldr      x8, [sp, #0x40]
0x00054f10  ldr      x8, [x8]
0x00054f14  cmp      x8, x20
0x00054f18  b.eq     #0x54f24
0x00054f1c  mov      x0, x21
0x00054f20  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00054f24  ldr      x8, [sp, #0x38]
0x00054f28  ldr      x26, [x8, x19, lsl #3]
0x00054f2c  mov      x0, x26
0x00054f30  mov      x2, x23
0x00054f34  bl       #0x57040   ; CALL objc_msgSend$componentsSeparatedByString:
0x00054f38  mov      x29, x29
0x00054f3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00054f40  mov      x24, x0
0x00054f44  bl       #0x57c20   ; CALL objc_msgSend$firstObject
0x00054f48  mov      x29, x29
0x00054f4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00054f50  mov      x28, x0
0x00054f54  mov      x2, x25
0x00054f58  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00054f5c  mov      x22, x0
0x00054f60  mov      x0, x28
0x00054f64  bl       #0x55d78   ; CALL _objc_release
0x00054f68  mov      x0, x24
0x00054f6c  bl       #0x55d78   ; CALL _objc_release
0x00054f70  tbnz     w22, #0, #0x55040
0x00054f74  add      x19, x19, #1
0x00054f78  cmp      x27, x19
0x00054f7c  b.ne     #0x54f0c
0x00054f80  add      x2, sp, #0x30
0x00054f84  add      x3, sp, #0xf0
0x00054f88  mov      x0, x21
0x00054f8c  mov      w4, #0x10
0x00054f90  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00054f94  mov      x27, x0
0x00054f98  ldr      x19, [sp, #8]
0x00054f9c  cbnz     x0, #0x54f08
0x00054fa0  mov      x0, x25
0x00054fa4  bl       #0x55d78   ; CALL _objc_release
0x00054fa8  ldp      x0, x24, [sp, #0x18]
0x00054fac  add      x24, x24, #1
0x00054fb0  cmp      x24, x0
0x00054fb4  ldr      x20, [sp, #0x28]
0x00054fb8  ldr      x22, [sp, #0x10]
0x00054fbc  b.ne     #0x54dac
0x00054fc0  add      x2, sp, #0xb0
0x00054fc4  sub      x3, x29, #0xe0
0x00054fc8  mov      x0, x20
0x00054fcc  mov      w4, #0x10
0x00054fd0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00054fd4  cbnz     x0, #0x54da4
0x00054fd8  mov      x0, x20
0x00054fdc  bl       #0x55d78   ; CALL _objc_release
0x00054fe0  adrp     x26, #0x78000
0x00054fe4  add      x26, x26, #0xa48   ; STR "en"
0x00054fe8  b        #0x54ffc
0x00054fec  mov      x0, x26
0x00054ff0  bl       #0x55d84   ; CALL _objc_retain
0x00054ff4  ldr      x0, [sp, #0x28]
0x00054ff8  bl       #0x55d78   ; CALL _objc_release
0x00054ffc  mov      x0, x19
0x00055000  bl       #0x55d78   ; CALL _objc_release
0x00055004  ldur     x8, [x29, #-0x60]
0x00055008  adrp     x9, #0x74000
0x0005500c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00055010  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00055014  cmp      x9, x8
0x00055018  b.ne     #0x55058
0x0005501c  mov      x0, x26
0x00055020  add      sp, sp, #0x280
0x00055024  ldp      x29, x30, [sp, #0x50]
0x00055028  ldp      x20, x19, [sp, #0x40]
0x0005502c  ldp      x22, x21, [sp, #0x30]
0x00055030  ldp      x24, x23, [sp, #0x20]
0x00055034  ldp      x26, x25, [sp, #0x10]
0x00055038  ldp      x28, x27, [sp], #0x60
0x0005503c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00055040  mov      x0, x26
0x00055044  bl       #0x55d84   ; CALL _objc_retain
0x00055048  mov      x0, x25
0x0005504c  bl       #0x55d78   ; CALL _objc_release
0x00055050  ldr      x19, [sp, #8]
0x00055054  b        #0x54ff4
0x00055058  bl       #0x55b98   ; CALL ___stack_chk_fail

=== _OMCTr  va=0x5505c size=632 types=
0x0005505c  stp      x28, x27, [sp, #-0x60]!
0x00055060  stp      x26, x25, [sp, #0x10]
0x00055064  stp      x24, x23, [sp, #0x20]
0x00055068  stp      x22, x21, [sp, #0x30]
0x0005506c  stp      x20, x19, [sp, #0x40]
0x00055070  stp      x29, x30, [sp, #0x50]
0x00055074  add      x29, sp, #0x50
0x00055078  sub      sp, sp, #0x420
0x0005507c  mov      x20, x1
0x00055080  mov      x19, x0
0x00055084  adrp     x8, #0x74000
0x00055088  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0005508c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00055090  stur     x8, [x29, #-0x58]
0x00055094  bl       #0x55d84   ; CALL _objc_retain
0x00055098  mov      x0, x20
0x0005509c  bl       #0x55d84   ; CALL _objc_retain
0x000550a0  bl       #0x54cc4   ; CALL _OMCCurrentLanguage
0x000550a4  mov      x29, x29
0x000550a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000550ac  mov      x21, x0
0x000550b0  adrp     x2, #0x78000
0x000550b4  add      x2, x2, #0xa08   ; STR "vi"
0x000550b8  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x000550bc  cbz      w0, #0x550d0
0x000550c0  mov      x0, x19
0x000550c4  bl       #0x55d84   ; CALL _objc_retain
0x000550c8  mov      x22, x19
0x000550cc  b        #0x55250
0x000550d0  adrp     x2, #0x78000
0x000550d4  add      x2, x2, #0xa48   ; STR "en"
0x000550d8  mov      x0, x21
0x000550dc  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x000550e0  cbz      x20, #0x55170
0x000550e4  cbnz     w0, #0x55170
0x000550e8  mov      x0, x21
0x000550ec  bl       #0x55d84   ; CALL _objc_retain
0x000550f0  adrp     x8, #0x90000
0x000550f4  ldr      x8, [x8, #0x108]
0x000550f8  cmn      x8, #1
0x000550fc  b.ne     #0x552a4
0x00055100  adrp     x26, #0x90000
0x00055104  ldr      x22, [x26, #0x100]
0x00055108  mov      x0, x22
0x0005510c  bl       #0x55d84   ; CALL _objc_retain
0x00055110  mov      x0, x22
0x00055114  bl       #0x55de4   ; CALL _objc_sync_enter
0x00055118  ldr      x0, [x26, #0x100]
0x0005511c  mov      x2, x21
0x00055120  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00055124  mov      x29, x29
0x00055128  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005512c  mov      x23, x0
0x00055130  cbnz     x0, #0x55200
0x00055134  adrp     x24, #0x8e000
0x00055138  ldr      x23, [x24, #0x958]   ; @CLASS NSString
0x0005513c  adrp     x0, #0x7e000
0x00055140  add      x0, x0, #0x868   ; STR "/Library/PreferenceBundles/OmniCarPrefs.bundle"
0x00055144  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00055148  add      x1, sp, #0x18
0x0005514c  bl       #0x4118
0x00055150  mov      x2, x0
0x00055154  cbz      x0, #0x55180
0x00055158  ldr      x0, [x24, #0x958]   ; @CLASS NSString
0x0005515c  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00055160  mov      x29, x29
0x00055164  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00055168  mov      x25, x0
0x0005516c  b        #0x55184
0x00055170  mov      x0, x20
0x00055174  bl       #0x55d84   ; CALL _objc_retain
0x00055178  mov      x22, x20
0x0005517c  b        #0x55250
0x00055180  mov      x25, #0
0x00055184  stp      x25, x21, [sp]
0x00055188  adrp     x2, #0x7e000
0x0005518c  add      x2, x2, #0x848   ; STR "%@/%@.lproj/Car.strings"
0x00055190  mov      x0, x23
0x00055194  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00055198  mov      x29, x29
0x0005519c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000551a0  mov      x24, x0
0x000551a4  mov      x0, x25
0x000551a8  bl       #0x55d78   ; CALL _objc_release
0x000551ac  adrp     x8, #0x8e000
0x000551b0  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x000551b4  mov      x2, x24
0x000551b8  bl       #0x577a0   ; CALL objc_msgSend$dictionaryWithContentsOfFile:
0x000551bc  mov      x29, x29
0x000551c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000551c4  mov      x25, x0
0x000551c8  adrp     x8, #0x74000
0x000551cc  ldr      x8, [x8, #0x1a8]   ; @GOT ___NSDictionary0__struct
0x000551d0  cmp      x0, #0
0x000551d4  csel     x23, x8, x0, eq
0x000551d8  mov      x0, x23
0x000551dc  bl       #0x55d84   ; CALL _objc_retain
0x000551e0  mov      x0, x25
0x000551e4  bl       #0x55d78   ; CALL _objc_release
0x000551e8  ldr      x0, [x26, #0x100]
0x000551ec  mov      x2, x23
0x000551f0  mov      x3, x21
0x000551f4  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x000551f8  mov      x0, x24
0x000551fc  bl       #0x55d78   ; CALL _objc_release
0x00055200  mov      x0, x22
0x00055204  bl       #0x55df0   ; CALL _objc_sync_exit
0x00055208  mov      x0, x22
0x0005520c  bl       #0x55d78   ; CALL _objc_release
0x00055210  mov      x0, x21
0x00055214  bl       #0x55d78   ; CALL _objc_release
0x00055218  mov      x0, x23
0x0005521c  mov      x2, x20
0x00055220  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00055224  mov      x29, x29
0x00055228  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005522c  mov      x24, x0
0x00055230  cmp      x0, #0
0x00055234  csel     x22, x20, x0, eq
0x00055238  mov      x0, x22
0x0005523c  bl       #0x55d84   ; CALL _objc_retain
0x00055240  mov      x0, x24
0x00055244  bl       #0x55d78   ; CALL _objc_release
0x00055248  mov      x0, x23
0x0005524c  bl       #0x55d78   ; CALL _objc_release
0x00055250  mov      x0, x21
0x00055254  bl       #0x55d78   ; CALL _objc_release
0x00055258  mov      x0, x20
0x0005525c  bl       #0x55d78   ; CALL _objc_release
0x00055260  mov      x0, x19
0x00055264  bl       #0x55d78   ; CALL _objc_release
0x00055268  ldur     x8, [x29, #-0x58]
0x0005526c  adrp     x9, #0x74000
0x00055270  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00055274  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00055278  cmp      x9, x8
0x0005527c  b.ne     #0x552ac
0x00055280  mov      x0, x22
0x00055284  add      sp, sp, #0x420
0x00055288  ldp      x29, x30, [sp, #0x50]
0x0005528c  ldp      x20, x19, [sp, #0x40]
0x00055290  ldp      x22, x21, [sp, #0x30]
0x00055294  ldp      x24, x23, [sp, #0x20]
0x00055298  ldp      x26, x25, [sp, #0x10]
0x0005529c  ldp      x28, x27, [sp], #0x60
0x000552a0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x000552a4  bl       #0x557dc
0x000552a8  b        #0x55100
0x000552ac  bl       #0x55b98   ; CALL ___stack_chk_fail
0x000552b0  b        #0x552b8
0x000552b4  b        #0x552b8
0x000552b8  mov      x19, x0
0x000552bc  mov      x0, x22
0x000552c0  bl       #0x55df0   ; CALL _objc_sync_exit
0x000552c4  b        #0x552cc
0x000552c8  mov      x19, x0
0x000552cc  mov      x0, x19
0x000552d0  bl       #0x55b80   ; CALL __Unwind_Resume

=== _OMCLogoMeshImage  va=0x552d4 size=960 types=
0x000552d4  sub      sp, sp, #0x50
0x000552d8  stp      x20, x19, [sp, #0x30]
0x000552dc  stp      x29, x30, [sp, #0x40]
0x000552e0  add      x29, sp, #0x40
0x000552e4  mov      x19, x0
0x000552e8  adrp     x8, #0x90000
0x000552ec  add      x8, x8, #0xe0
0x000552f0  add      x0, x8, w0, uxtw #3
0x000552f4  adrp     x8, #0x74000
0x000552f8  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x000552fc  str      x8, [sp, #8]
0x00055300  adrp     x8, #0x65000
0x00055304  ldr      d0, [x8, #0x6f8]
0x00055308  str      d0, [sp, #0x10]
0x0005530c  adrp     x8, #0x55000
0x00055310  add      x8, x8, #0x368
0x00055314  adrp     x9, #0x74000
0x00055318  add      x9, x9, #0xfa8
0x0005531c  stp      x8, x9, [sp, #0x18]
0x00055320  strb     w19, [sp, #0x2c]
0x00055324  str      w19, [sp, #0x28]
0x00055328  ldr      x8, [x0]
0x0005532c  cmn      x8, #1
0x00055330  b.ne     #0x5535c
0x00055334  adrp     x8, #0x90000
0x00055338  add      x8, x8, #0xd0
0x0005533c  ldr      x19, [x8, w19, uxtw #3]
0x00055340  mov      x0, x19
0x00055344  bl       #0x55d84   ; CALL _objc_retain
0x00055348  mov      x0, x19
0x0005534c  ldp      x29, x30, [sp, #0x40]
0x00055350  ldp      x20, x19, [sp, #0x30]
0x00055354  add      sp, sp, #0x50
0x00055358  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0005535c  add      x1, sp, #8
0x00055360  bl       #0x55bf8   ; CALL _dispatch_once
0x00055364  b        #0x55334
0x00055368  sub      sp, sp, #0x70
0x0005536c  stp      d9, d8, [sp, #0x30]
0x00055370  stp      x22, x21, [sp, #0x40]
0x00055374  stp      x20, x19, [sp, #0x50]
0x00055378  stp      x29, x30, [sp, #0x60]
0x0005537c  add      x29, sp, #0x60
0x00055380  mov      x19, x0
0x00055384  ldrb     w8, [x0, #0x24]
0x00055388  cmp      w8, #0
0x0005538c  adrp     x8, #0x65000
0x00055390  ldr      d0, [x8, #0x9a0]
0x00055394  fmov     d1, #1.00000000
0x00055398  fcsel    d8, d1, d0, ne
0x0005539c  adrp     x8, #0x8e000
0x000553a0  ldr      x0, [x8, #0xb58]   ; @CLASS UIGraphicsImageRendererFormat
0x000553a4  bl       #0x59920   ; CALL objc_msgSend$preferredFormat
0x000553a8  mov      x29, x29
0x000553ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000553b0  mov      x20, x0
0x000553b4  fmov     d0, #1.00000000
0x000553b8  bl       #0x5bee0   ; CALL objc_msgSend$setScale:
0x000553bc  ldrb     w2, [x19, #0x24]
0x000553c0  mov      x0, x20
0x000553c4  bl       #0x5b960   ; CALL objc_msgSend$setOpaque:
0x000553c8  adrp     x8, #0x8e000
0x000553cc  ldr      x0, [x8, #0xb00]   ; @CLASS UIGraphicsImageRenderer
0x000553d0  bl       #0x55c7c   ; CALL _objc_alloc
0x000553d4  mov      x8, #0x4058000000000000
0x000553d8  fmov     d0, x8
0x000553dc  mov      v1.16b, v0.16b
0x000553e0  mov      x2, x20
0x000553e4  bl       #0x58560   ; CALL objc_msgSend$initWithSize:format:
0x000553e8  mov      x21, x0
0x000553ec  adrp     x8, #0x74000
0x000553f0  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x000553f4  str      x8, [sp]
0x000553f8  adrp     x8, #0x65000
0x000553fc  ldr      d0, [x8, #0x6f8]
0x00055400  adrp     x8, #0x55000
0x00055404  add      x8, x8, #0x474
0x00055408  adrp     x9, #0x74000
0x0005540c  add      x9, x9, #0xf88
0x00055410  str      d0, [sp, #8]
0x00055414  stp      x8, x9, [sp, #0x10]
0x00055418  ldrb     w8, [x19, #0x24]
0x0005541c  strb     w8, [sp, #0x28]
0x00055420  str      d8, [sp, #0x20]
0x00055424  mov      x2, sp
0x00055428  bl       #0x58140   ; CALL objc_msgSend$imageWithActions:
0x0005542c  mov      x29, x29
0x00055430  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00055434  ldrsw    x9, [x19, #0x20]
0x00055438  adrp     x10, #0x90000
0x0005543c  add      x10, x10, #0xd0
0x00055440  ldr      x8, [x10, x9, lsl #3]
0x00055444  str      x0, [x10, x9, lsl #3]
0x00055448  mov      x0, x8
0x0005544c  bl       #0x55d78   ; CALL _objc_release
0x00055450  mov      x0, x21
0x00055454  bl       #0x55d78   ; CALL _objc_release
0x00055458  mov      x0, x20
0x0005545c  ldp      x29, x30, [sp, #0x60]
0x00055460  ldp      x20, x19, [sp, #0x50]
0x00055464  ldp      x22, x21, [sp, #0x40]
0x00055468  ldp      d9, d8, [sp, #0x30]
0x0005546c  add      sp, sp, #0x70
0x00055470  b        #0x55d78   ; CALL _objc_release
0x00055474  sub      sp, sp, #0x140
0x00055478  stp      d11, d10, [sp, #0xc0]
0x0005547c  stp      d9, d8, [sp, #0xd0]
0x00055480  stp      x28, x27, [sp, #0xe0]
0x00055484  stp      x26, x25, [sp, #0xf0]
0x00055488  stp      x24, x23, [sp, #0x100]
0x0005548c  stp      x22, x21, [sp, #0x110]
0x00055490  stp      x20, x19, [sp, #0x120]
0x00055494  stp      x29, x30, [sp, #0x130]
0x00055498  add      x29, sp, #0x130
0x0005549c  mov      x19, x0
0x000554a0  adrp     x8, #0x74000
0x000554a4  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000554a8  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000554ac  stur     x8, [x29, #-0x78]
0x000554b0  mov      x0, x1
0x000554b4  bl       #0x55ea0   ; CALL objc_msgSend$CGContext
0x000554b8  mov      x20, x0
0x000554bc  movi     v0.16b, #0
0x000554c0  stp      q0, q0, [sp, #0x90]
0x000554c4  mov      x8, #0x4058000000000000
0x000554c8  dup      v1.2d, x8
0x000554cc  stp      q1, q0, [sp, #0x70]
0x000554d0  stur     q1, [sp, #0x88]
0x000554d4  ldrb     w8, [x19, #0x28]
0x000554d8  adrp     x9, #0x8e000
0x000554dc  ldr      x0, [x9, #0x910]   ; @CLASS UIColor
0x000554e0  tbz      w8, #0, #0x55504
0x000554e4  adrp     x8, #0x66000
0x000554e8  ldr      d0, [x8, #0x210]
0x000554ec  adrp     x8, #0x66000
0x000554f0  ldr      d1, [x8, #0x548]
0x000554f4  adrp     x8, #0x65000
0x000554f8  ldr      d2, [x8, #0xb58]
0x000554fc  fmov     d3, #1.00000000
0x00055500  b        #0x55524
0x00055504  adrp     x8, #0x66000
0x00055508  ldr      d0, [x8, #0x2a8]
0x0005550c  adrp     x8, #0x66000
0x00055510  ldr      d1, [x8, #0x540]
0x00055514  adrp     x8, #0x65000
0x00055518  ldr      d2, [x8, #0x7b0]
0x0005551c  adrp     x8, #0x65000
0x00055520  ldr      d3, [x8, #0x670]
0x00055524  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00055528  mov      x29, x29
0x0005552c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00055530  mov      x21, x0
0x00055534  bl       #0x5ae00   ; CALL objc_msgSend$setFill
0x00055538  mov      x8, #0x4058000000000000
0x0005553c  fmov     d2, x8
0x00055540  fmov     d0, xzr
0x00055544  fmov     d1, xzr
0x00055548  mov      x0, x20
0x0005554c  mov      v3.16b, v2.16b
0x00055550  bl       #0x55940   ; CALL _CGContextFillRect
0x00055554  adrp     x24, #0x66000
0x00055558  add      x24, x24, #0x570
0x0005555c  bl       #0x558d4   ; CALL _CGColorSpaceCreateDeviceRGB
0x00055560  mov      x22, x0
0x00055564  mov      x25, #0
0x00055568  adrp     x8, #0x65000
0x0005556c  ldr      d9, [x8, #0x688]
0x00055570  adrp     x8, #0x66000
0x00055574  ldr      d10, [x8, #0x550]
0x00055578  movi     d11, #0x0000ff000000ff
0x0005557c  mov      x8, #0xe00000000000
0x00055580  movk     x8, #0x406f, lsl #48
0x00055584  dup      v4.2d, x8
0x00055588  adrp     x8, #0x65000
0x0005558c  add      x8, x8, #0x940
0x00055590  ldr      q0, [x8]
0x00055594  stp      q0, q4, [sp]
0x00055598  add      x26, sp, #0x70
0x0005559c  adrp     x8, #0x66000
0x000555a0  ldr      d8, [x8, #0x558]
0x000555a4  ldr      w8, [x24], #4
0x000555a8  and      w9, w8, #0xff
0x000555ac  ucvtf    d0, w9
0x000555b0  dup      v1.2s, w8
0x000555b4  ushl     v1.2s, v1.2s, v10.2s
0x000555b8  and      v1.8b, v1.8b, v11.8b
0x000555bc  ushll    v1.2d, v1.2s, #0
0x000555c0  ucvtf    v1.2d, v1.2d
0x000555c4  ldr      q2, [sp, #0x10]
0x000555c8  fdiv     v1.2d, v1.2d, v2.2d
0x000555cc  ldr      d2, [x19, #0x20]
0x000555d0  fdiv     d0, d0, d9
0x000555d4  stp      d0, d2, [sp, #0x40]
0x000555d8  str      q1, [sp, #0x50]
0x000555dc  str      d0, [sp, #0x60]
0x000555e0  str      xzr, [sp, #0x68]
0x000555e4  ldr      q0, [sp]
0x000555e8  stp      q0, q1, [sp, #0x20]
0x000555ec  add      x1, sp, #0x30
0x000555f0  add      x2, sp, #0x20
0x000555f4  mov      x0, x22
0x000555f8  mov      w3, #2
0x000555fc  bl       #0x559d0   ; CALL _CGGradientCreateWithColorComponents
0x00055600  mov      x23, x0
0x00055604  add      x8, x26, x25
0x00055608  ldp      d0, d1, [x8]
0x0005560c  fmov     d2, xzr
0x00055610  mov      x0, x20
0x00055614  mov      x1, x23
0x00055618  mov      v3.16b, v0.16b
0x0005561c  mov      v4.16b, v1.16b
0x00055620  mov      v5.16b, v8.16b
0x00055624  mov      w2, #0
0x00055628  bl       #0x55928   ; CALL _CGContextDrawRadialGradient
0x0005562c  mov      x0, x23
0x00055630  bl       #0x559e8   ; CALL _CGGradientRelease
0x00055634  add      x25, x25, #0x10
0x00055638  cmp      x25, #0x40
0x0005563c  b.ne     #0x555a4
0x00055640  mov      x0, x22
0x00055644  bl       #0x558ec   ; CALL _CGColorSpaceRelease
0x00055648  mov      x0, x21
0x0005564c  bl       #0x55d78   ; CALL _objc_release
0x00055650  ldur     x8, [x29, #-0x78]
0x00055654  adrp     x9, #0x74000
0x00055658  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0005565c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00055660  cmp      x9, x8
0x00055664  b.ne     #0x55690
0x00055668  ldp      x29, x30, [sp, #0x130]
0x0005566c  ldp      x20, x19, [sp, #0x120]
0x00055670  ldp      x22, x21, [sp, #0x110]
0x00055674  ldp      x24, x23, [sp, #0x100]
0x00055678  ldp      x26, x25, [sp, #0xf0]
0x0005567c  ldp      x28, x27, [sp, #0xe0]
0x00055680  ldp      d9, d8, [sp, #0xd0]
0x00055684  ldp      d11, d10, [sp, #0xc0]
0x00055688  add      sp, sp, #0x140
0x0005568c  ret      
0x00055690  bl       #0x55b98   ; CALL ___stack_chk_fail
