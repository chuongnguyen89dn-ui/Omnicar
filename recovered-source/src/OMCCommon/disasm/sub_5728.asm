; === sub_5728 @ 0x5728 size=1628 ===
0x00005728  sub      sp, sp, #0x150
0x0000572c  stp      x28, x27, [sp, #0xf0]
0x00005730  stp      x26, x25, [sp, #0x100]
0x00005734  stp      x24, x23, [sp, #0x110]
0x00005738  stp      x22, x21, [sp, #0x120]
0x0000573c  stp      x20, x19, [sp, #0x130]
0x00005740  stp      x29, x30, [sp, #0x140]
0x00005744  add      x29, sp, #0x140
0x00005748  mov      x0, x1
0x0000574c  adrp     x8, #0x14000
0x00005750  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x00005754  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x00005758  stur     x8, [x29, #-0x60]
0x0000575c  bl       #0xe580 ; call objc_stub[userInfo]
0x00005760  mov      x29, x29
0x00005764  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005768  mov      x19, x0
0x0000576c  adrp     x2, #0x14000
0x00005770  add      x2, x2, #0x948 ; -> CFSTR("url")
0x00005774  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x00005778  mov      x29, x29
0x0000577c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005780  mov      x20, x0
0x00005784  adrp     x8, #0x18000
0x00005788  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x0000578c  bl       #0xd47c ; call stub:_objc_opt_class
0x00005790  mov      x1, x0
0x00005794  mov      x0, x20
0x00005798  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x0000579c  tbz      w0, #0, #0x57c0
0x000057a0  adrp     x8, #0x18000
0x000057a4  ldr      x0, [x8, #0x418] ; -> [classref(NSURL)]
0x000057a8  mov      x2, x20
0x000057ac  bl       #0xd660 ; call objc_stub[URLWithString:]
0x000057b0  mov      x29, x29
0x000057b4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000057b8  mov      x21, x0
0x000057bc  b        #0x57c4
0x000057c0  mov      x21, #0
0x000057c4  mov      x0, x21
0x000057c8  bl       #0xe1a0 ; call objc_stub[scheme]
0x000057cc  mov      x29, x29
0x000057d0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000057d4  mov      x22, x0
0x000057d8  adrp     x2, #0x15000
0x000057dc  add      x2, x2, #0x268 ; -> CFSTR("omnicar")
0x000057e0  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x000057e4  mov      x23, x0
0x000057e8  mov      x0, x22
0x000057ec  bl       #0xd4b8 ; call stub:_objc_release
0x000057f0  cbz      w23, #0x5d10
0x000057f4  adrp     x8, #0x18000
0x000057f8  ldr      x0, [x8, #0x470] ; -> [classref(NSMutableDictionary)]
0x000057fc  bl       #0xda80 ; call objc_stub[dictionary]
0x00005800  mov      x29, x29
0x00005804  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005808  mov      x22, x0
0x0000580c  movi     v0.16b, #0
0x00005810  stp      q0, q0, [sp, #0x20]
0x00005814  stp      q0, q0, [sp, #0x40]
0x00005818  adrp     x8, #0x18000
0x0000581c  ldr      x0, [x8, #0x480] ; -> [classref(NSURLComponents)]
0x00005820  mov      x2, x21
0x00005824  mov      w3, #0
0x00005828  bl       #0xd8e0 ; call objc_stub[componentsWithURL:resolvingAgainstBaseURL:]
0x0000582c  mov      x29, x29
0x00005830  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005834  mov      x24, x0
0x00005838  bl       #0xe080 ; call objc_stub[queryItems]
0x0000583c  mov      x29, x29
0x00005840  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005844  mov      x23, x0
0x00005848  mov      x0, x24
0x0000584c  bl       #0xd4b8 ; call stub:_objc_release
0x00005850  add      x2, sp, #0x20
0x00005854  add      x3, sp, #0x60
0x00005858  mov      x0, x23
0x0000585c  mov      w4, #0x10
0x00005860  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00005864  cbz      x0, #0x5924
0x00005868  mov      x24, x0
0x0000586c  ldr      x8, [sp, #0x30]
0x00005870  ldr      x27, [x8] ; -> [selref(CGContext)]
0x00005874  mov      x28, #0
0x00005878  ldr      x8, [sp, #0x30]
0x0000587c  ldr      x8, [x8] ; -> [selref(CGContext)]
0x00005880  cmp      x8, x27
0x00005884  b.eq     #0x5890
0x00005888  mov      x0, x23
0x0000588c  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x00005890  ldr      x8, [sp, #0x28]
0x00005894  ldr      x25, [x8, x28, lsl #3] ; -> [selref(CGContext)]
0x00005898  mov      x0, x25
0x0000589c  bl       #0xe5a0 ; call objc_stub[value]
0x000058a0  mov      x29, x29
0x000058a4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000058a8  mov      x26, x0
0x000058ac  bl       #0xd4b8 ; call stub:_objc_release
0x000058b0  cbz      x26, #0x58fc
0x000058b4  mov      x0, x25
0x000058b8  bl       #0xe5a0 ; call objc_stub[value]
0x000058bc  mov      x29, x29
0x000058c0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000058c4  mov      x26, x0
0x000058c8  mov      x0, x25
0x000058cc  bl       #0xde20 ; call objc_stub[name]
0x000058d0  mov      x29, x29
0x000058d4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000058d8  mov      x25, x0
0x000058dc  mov      x0, x22
0x000058e0  mov      x2, x26
0x000058e4  mov      x3, x25
0x000058e8  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x000058ec  mov      x0, x25
0x000058f0  bl       #0xd4b8 ; call stub:_objc_release
0x000058f4  mov      x0, x26
0x000058f8  bl       #0xd4b8 ; call stub:_objc_release
0x000058fc  add      x28, x28, #1
0x00005900  cmp      x24, x28
0x00005904  b.ne     #0x5878
0x00005908  add      x2, sp, #0x20
0x0000590c  add      x3, sp, #0x60
0x00005910  mov      x0, x23
0x00005914  mov      w4, #0x10
0x00005918  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000591c  mov      x24, x0
0x00005920  cbnz     x0, #0x5874
0x00005924  mov      x0, x23
0x00005928  bl       #0xd4b8 ; call stub:_objc_release
0x0000592c  mov      x0, x21
0x00005930  bl       #0xdbc0 ; call objc_stub[host]
0x00005934  mov      x29, x29
0x00005938  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000593c  mov      x24, x0
0x00005940  bl       #0xdd20 ; call objc_stub[lowercaseString]
0x00005944  mov      x29, x29
0x00005948  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000594c  mov      x27, x0
0x00005950  mov      x0, x24
0x00005954  bl       #0xd4b8 ; call stub:_objc_release
0x00005958  bl       #0x6528 ; call _OMCPrefsSync
0x0000595c  adrp     x2, #0x15000
0x00005960  add      x2, x2, #0x288 ; -> CFSTR("feature")
0x00005964  mov      x0, x27
0x00005968  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x0000596c  cbz      w0, #0x59c4
0x00005970  mov      x0, x21
0x00005974  bl       #0xdfc0 ; call objc_stub[pathComponents]
0x00005978  mov      x29, x29
0x0000597c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005980  mov      x25, x0
0x00005984  bl       #0xd960 ; call objc_stub[count]
0x00005988  cmp      x0, #2
0x0000598c  b.lo     #0x5a70
0x00005990  mov      x0, x21
0x00005994  bl       #0xdfc0 ; call objc_stub[pathComponents]
0x00005998  mov      x29, x29
0x0000599c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000059a0  mov      x26, x0
0x000059a4  mov      w2, #1
0x000059a8  bl       #0xdf40 ; call objc_stub[objectAtIndexedSubscript:]
0x000059ac  mov      x29, x29
0x000059b0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000059b4  mov      x24, x0
0x000059b8  mov      x0, x26
0x000059bc  bl       #0xd4b8 ; call stub:_objc_release
0x000059c0  b        #0x5a78
0x000059c4  adrp     x2, #0x15000
0x000059c8  add      x2, x2, #0x488 ; -> CFSTR("lite")
0x000059cc  mov      x0, x27
0x000059d0  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x000059d4  cbz      w0, #0x5b54
0x000059d8  adrp     x2, #0x15000
0x000059dc  add      x2, x2, #0x508 ; -> CFSTR("mode")
0x000059e0  mov      x0, x22
0x000059e4  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x000059e8  mov      x29, x29
0x000059ec  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000059f0  mov      x23, x0
0x000059f4  bl       #0xdd20 ; call objc_stub[lowercaseString]
0x000059f8  mov      x29, x29
0x000059fc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005a00  mov      x25, x0
0x00005a04  adrp     x8, #0x15000
0x00005a08  add      x8, x8, #0x2a8 ; -> CFSTR("")
0x00005a0c  cmp      x0, #0
0x00005a10  csel     x2, x8, x0, eq
0x00005a14  adrp     x0, #0x17000
0x00005a18  add      x0, x0, #0x130 ; -> __DATA_CONST,__objc_dictobj+0x28 (const collection)
0x00005a1c  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x00005a20  mov      x29, x29
0x00005a24  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005a28  mov      x24, x0
0x00005a2c  mov      x0, x25
0x00005a30  bl       #0xd4b8 ; call stub:_objc_release
0x00005a34  mov      x0, x23
0x00005a38  bl       #0xd4b8 ; call stub:_objc_release
0x00005a3c  cbz      x24, #0x5d00
0x00005a40  adrp     x0, #0x15000
0x00005a44  add      x0, x0, #0x528 ; -> CFSTR("liteMode")
0x00005a48  adrp     x2, #0x14000
0x00005a4c  add      x2, x2, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x00005a50  mov      x1, x24
0x00005a54  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x00005a58  adrp     x8, #0x18000
0x00005a5c  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x00005a60  str      x24, [sp]
0x00005a64  adrp     x2, #0x15000
0x00005a68  add      x2, x2, #0x548 ; -> CFSTR("URL: che do nhe = %@")
0x00005a6c  b        #0x5bfc
0x00005a70  adrp     x24, #0x15000
0x00005a74  add      x24, x24, #0x2a8 ; -> CFSTR("")
0x00005a78  mov      x0, x25
0x00005a7c  bl       #0xd4b8 ; call stub:_objc_release
0x00005a80  mov      x0, x24
0x00005a84  bl       #0xdd20 ; call objc_stub[lowercaseString]
0x00005a88  mov      x29, x29
0x00005a8c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005a90  mov      x26, x0
0x00005a94  adrp     x0, #0x17000
0x00005a98  add      x0, x0, #0x108 ; -> __DATA_CONST,__objc_dictobj+0x0 (const collection)
0x00005a9c  mov      x2, x26
0x00005aa0  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x00005aa4  mov      x29, x29
0x00005aa8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005aac  mov      x25, x0
0x00005ab0  mov      x0, x26
0x00005ab4  bl       #0xd4b8 ; call stub:_objc_release
0x00005ab8  cbz      x25, #0x5c20
0x00005abc  str      x27, [sp, #0x18]
0x00005ac0  adrp     x2, #0x15000
0x00005ac4  add      x2, x2, #0x428 ; -> CFSTR("on")
0x00005ac8  mov      x0, x22
0x00005acc  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x00005ad0  mov      x29, x29
0x00005ad4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005ad8  mov      x27, x0
0x00005adc  bl       #0xdd20 ; call objc_stub[lowercaseString]
0x00005ae0  mov      x29, x29
0x00005ae4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005ae8  mov      x28, x0
0x00005aec  adrp     x23, #0x15000
0x00005af0  add      x23, x23, #0x448 ; -> CFSTR("toggle")
0x00005af4  cmp      x0, #0
0x00005af8  csel     x26, x23, x0, eq
0x00005afc  mov      x0, x26
0x00005b00  bl       #0xd4c4 ; call stub:_objc_retain
0x00005b04  mov      x0, x28
0x00005b08  bl       #0xd4b8 ; call stub:_objc_release
0x00005b0c  mov      x0, x27
0x00005b10  bl       #0xd4b8 ; call stub:_objc_release
0x00005b14  mov      x0, x26
0x00005b18  mov      x2, x23
0x00005b1c  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x00005b20  tbz      w0, #0, #0x5c68
0x00005b24  adrp     x1, #0x14000
0x00005b28  ldr      x1, [x1, #0x188] ; -> [got(___kCFBooleanTrue)]
0x00005b2c  mov      x0, x25
0x00005b30  bl       #0x6534 ; call _OMCPref
0x00005b34  mov      x29, x29
0x00005b38  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005b3c  mov      x23, x0
0x00005b40  bl       #0xd7c0 ; call objc_stub[boolValue]
0x00005b44  eor      w27, w0, #1
0x00005b48  mov      x0, x23
0x00005b4c  bl       #0xd4b8 ; call stub:_objc_release
0x00005b50  b        #0x5c74
0x00005b54  adrp     x2, #0x15000
0x00005b58  add      x2, x2, #0x568 ; -> CFSTR("startup")
0x00005b5c  mov      x0, x27
0x00005b60  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x00005b64  cbz      w0, #0x5d60
0x00005b68  adrp     x2, #0x15000
0x00005b6c  add      x2, x2, #0x608 ; -> CFSTR("style")
0x00005b70  mov      x0, x22
0x00005b74  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x00005b78  mov      x29, x29
0x00005b7c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005b80  mov      x23, x0
0x00005b84  bl       #0xdd20 ; call objc_stub[lowercaseString]
0x00005b88  mov      x29, x29
0x00005b8c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005b90  mov      x25, x0
0x00005b94  adrp     x8, #0x15000
0x00005b98  add      x8, x8, #0x2a8 ; -> CFSTR("")
0x00005b9c  cmp      x0, #0
0x00005ba0  csel     x2, x8, x0, eq
0x00005ba4  adrp     x0, #0x17000
0x00005ba8  add      x0, x0, #0x158 ; -> __DATA_CONST,__objc_dictobj+0x50 (const collection)
0x00005bac  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x00005bb0  mov      x29, x29
0x00005bb4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005bb8  mov      x24, x0
0x00005bbc  mov      x0, x25
0x00005bc0  bl       #0xd4b8 ; call stub:_objc_release
0x00005bc4  mov      x0, x23
0x00005bc8  bl       #0xd4b8 ; call stub:_objc_release
0x00005bcc  cbz      x24, #0x5d00
0x00005bd0  adrp     x0, #0x15000
0x00005bd4  add      x0, x0, #0x628 ; -> CFSTR("startupScreenStyle")
0x00005bd8  adrp     x2, #0x14000
0x00005bdc  add      x2, x2, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x00005be0  mov      x1, x24
0x00005be4  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x00005be8  adrp     x8, #0x18000
0x00005bec  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x00005bf0  str      x24, [sp]
0x00005bf4  adrp     x2, #0x15000
0x00005bf8  add      x2, x2, #0x648 ; -> CFSTR("URL: kieu khoi dong = %@")
0x00005bfc  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00005c00  mov      x29, x29
0x00005c04  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005c08  mov      x25, x0
0x00005c0c  adrp     x0, #0x14000
0x00005c10  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x00005c14  mov      x1, x25
0x00005c18  bl       #0x6be4 ; call _OMCLogWrite
0x00005c1c  b        #0x5ce0
0x00005c20  adrp     x8, #0x18000
0x00005c24  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x00005c28  str      x24, [sp]
0x00005c2c  adrp     x2, #0x15000
0x00005c30  add      x2, x2, #0x408 ; -> CFSTR("URL: khong co tinh nang %@")
0x00005c34  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00005c38  mov      x29, x29
0x00005c3c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005c40  mov      x25, x0
0x00005c44  adrp     x0, #0x14000
0x00005c48  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x00005c4c  mov      x1, x25
0x00005c50  bl       #0x6be4 ; call _OMCLogWrite
0x00005c54  mov      x0, x25
0x00005c58  bl       #0xd4b8 ; call stub:_objc_release
0x00005c5c  mov      x0, x24
0x00005c60  bl       #0xd4b8 ; call stub:_objc_release
0x00005c64  b        #0x5d00
0x00005c68  mov      x0, x26
0x00005c6c  bl       #0xd7c0 ; call objc_stub[boolValue]
0x00005c70  mov      x27, x0
0x00005c74  adrp     x8, #0x18000
0x00005c78  ldr      x0, [x8, #0x448] ; -> [classref(NSNumber)]
0x00005c7c  mov      x2, x27
0x00005c80  bl       #0xde80 ; call objc_stub[numberWithBool:]
0x00005c84  mov      x1, x0
0x00005c88  adrp     x2, #0x14000
0x00005c8c  add      x2, x2, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x00005c90  mov      x0, x25
0x00005c94  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x00005c98  adrp     x8, #0x18000
0x00005c9c  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x00005ca0  stp      x25, x27, [sp]
0x00005ca4  adrp     x2, #0x15000
0x00005ca8  add      x2, x2, #0x468 ; -> CFSTR("URL: %@ = %d")
0x00005cac  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00005cb0  mov      x29, x29
0x00005cb4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005cb8  mov      x23, x0
0x00005cbc  adrp     x0, #0x14000
0x00005cc0  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x00005cc4  mov      x1, x23
0x00005cc8  bl       #0x6be4 ; call _OMCLogWrite
0x00005ccc  mov      x0, x23
0x00005cd0  bl       #0xd4b8 ; call stub:_objc_release
0x00005cd4  mov      x0, x26
0x00005cd8  bl       #0xd4b8 ; call stub:_objc_release
0x00005cdc  ldr      x27, [sp, #0x18]
0x00005ce0  mov      x0, x25
0x00005ce4  bl       #0xd4b8 ; call stub:_objc_release
0x00005ce8  mov      x0, x24
0x00005cec  bl       #0xd4b8 ; call stub:_objc_release
0x00005cf0  bl       #0x6528 ; call _OMCPrefsSync
0x00005cf4  adrp     x0, #0xe000
0x00005cf8  add      x0, x0, #0x71b ; -> "com.anlai.omnicar/prefschanged"
0x00005cfc  bl       #0xd3d4 ; call stub:_notify_post
0x00005d00  mov      x0, x27
0x00005d04  bl       #0xd4b8 ; call stub:_objc_release
0x00005d08  mov      x0, x22
0x00005d0c  bl       #0xd4b8 ; call stub:_objc_release
0x00005d10  mov      x0, x21
0x00005d14  bl       #0xd4b8 ; call stub:_objc_release
0x00005d18  mov      x0, x20
0x00005d1c  bl       #0xd4b8 ; call stub:_objc_release
0x00005d20  mov      x0, x19
0x00005d24  bl       #0xd4b8 ; call stub:_objc_release
0x00005d28  ldur     x8, [x29, #-0x60]
0x00005d2c  adrp     x9, #0x14000
0x00005d30  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x00005d34  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x00005d38  cmp      x9, x8
0x00005d3c  b.ne     #0x5d80
0x00005d40  ldp      x29, x30, [sp, #0x140]
0x00005d44  ldp      x20, x19, [sp, #0x130]
0x00005d48  ldp      x22, x21, [sp, #0x120]
0x00005d4c  ldp      x24, x23, [sp, #0x110]
0x00005d50  ldp      x26, x25, [sp, #0x100]
0x00005d54  ldp      x28, x27, [sp, #0xf0]
0x00005d58  add      sp, sp, #0x150
0x00005d5c  ret      
0x00005d60  adrp     x2, #0x15000
0x00005d64  add      x2, x2, #0x668 ; -> CFSTR("cleanram")
0x00005d68  mov      x0, x27
0x00005d6c  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x00005d70  cbz      w0, #0x5d00
0x00005d74  adrp     x0, #0xe000
0x00005d78  add      x0, x0, #0x7e9 ; -> "com.anlai.omnicar/cleanram.now"
0x00005d7c  b        #0x5cfc
0x00005d80  bl       #0xd1b8 ; call stub:___stack_chk_fail
