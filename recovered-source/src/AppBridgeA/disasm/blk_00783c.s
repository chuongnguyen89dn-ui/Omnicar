; block literal @0x34690 desc @0x34670 sig=v16@?0@"NSNotification"8 flags=0x50000000
; ==== sub_783c @ 0x783c..0x8000 (1988 bytes) ====
0x0000783c  sub      sp, sp, #0xb0
0x00007840  stp      d11, d10, [sp, #0x30]
0x00007844  stp      d9, d8, [sp, #0x40]
0x00007848  stp      x28, x27, [sp, #0x50]
0x0000784c  stp      x26, x25, [sp, #0x60]
0x00007850  stp      x24, x23, [sp, #0x70]
0x00007854  stp      x22, x21, [sp, #0x80]
0x00007858  stp      x20, x19, [sp, #0x90]
0x0000785c  stp      x29, x30, [sp, #0xa0]
0x00007860  add      x29, sp, #0xa0
0x00007864  mov      x19, x1
0x00007868  mov      x0, x1
0x0000786c  bl       #0x24818   ; call _objc_retain
0x00007870  str      x19, [sp, #0x28]
0x00007874  mov      x0, x19
0x00007878  bl       #0x280c0   ; objc_msgSend: userInfo
0x0000787c  mov      x29, x29
0x00007880  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007884  mov      x20, x0
0x00007888  adrp     x2, #0x35000
0x0000788c  add      x2, x2, #0x330   ; -> @"x"
0x00007890  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007894  mov      x29, x29
0x00007898  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000789c  mov      x22, x0
0x000078a0  bl       #0x25640   ; objc_msgSend: doubleValue
0x000078a4  mov      v8.16b, v0.16b
0x000078a8  adrp     x2, #0x35000
0x000078ac  add      x2, x2, #0x350   ; -> @"y"
0x000078b0  mov      x0, x20
0x000078b4  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000078b8  mov      x29, x29
0x000078bc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000078c0  mov      x23, x0
0x000078c4  bl       #0x25640   ; objc_msgSend: doubleValue
0x000078c8  mov      v9.16b, v0.16b
0x000078cc  adrp     x2, #0x35000
0x000078d0  add      x2, x2, #0x370   ; -> @"w"
0x000078d4  mov      x0, x20
0x000078d8  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000078dc  mov      x29, x29
0x000078e0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000078e4  mov      x24, x0
0x000078e8  bl       #0x25640   ; objc_msgSend: doubleValue
0x000078ec  mov      v10.16b, v0.16b
0x000078f0  adrp     x2, #0x35000
0x000078f4  add      x2, x2, #0x390   ; -> @"h"
0x000078f8  mov      x0, x20
0x000078fc  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007900  mov      x29, x29
0x00007904  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007908  mov      x19, x0
0x0000790c  bl       #0x25640   ; objc_msgSend: doubleValue
0x00007910  mov      v11.16b, v0.16b
0x00007914  mov      x0, x19
0x00007918  bl       #0x2480c   ; call _objc_release
0x0000791c  mov      x0, x24
0x00007920  bl       #0x2480c   ; call _objc_release
0x00007924  mov      x0, x23
0x00007928  bl       #0x2480c   ; call _objc_release
0x0000792c  mov      x0, x22
0x00007930  bl       #0x2480c   ; call _objc_release
0x00007934  adrp     x8, #0x3e000
0x00007938  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x0000793c  bl       #0x27b20   ; objc_msgSend: shared
0x00007940  mov      x29, x29
0x00007944  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007948  mov      x23, x0
0x0000794c  adrp     x2, #0x35000
0x00007950  add      x2, x2, #0x3b0   ; -> @"identifier"
0x00007954  mov      x0, x20
0x00007958  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0000795c  mov      x29, x29
0x00007960  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007964  mov      x24, x0
0x00007968  mov      x0, x23
0x0000796c  mov      x2, x24
0x00007970  mov      v0.16b, v8.16b
0x00007974  mov      v1.16b, v9.16b
0x00007978  mov      v2.16b, v10.16b
0x0000797c  mov      v3.16b, v11.16b
0x00007980  bl       #0x26460   ; objc_msgSend: openApp:frame:
0x00007984  mov      x0, x24
0x00007988  bl       #0x2480c   ; call _objc_release
0x0000798c  mov      x0, x23
0x00007990  bl       #0x2480c   ; call _objc_release
0x00007994  adrp     x8, #0x3e000
0x00007998  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x0000799c  bl       #0x27b20   ; objc_msgSend: shared
0x000079a0  mov      x29, x29
0x000079a4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000079a8  mov      x23, x0
0x000079ac  adrp     x2, #0x35000
0x000079b0  add      x2, x2, #0x3d0   ; -> @"pt"
0x000079b4  mov      x0, x20
0x000079b8  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000079bc  mov      x29, x29
0x000079c0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000079c4  mov      x24, x0
0x000079c8  bl       #0x25640   ; objc_msgSend: doubleValue
0x000079cc  mov      v8.16b, v0.16b
0x000079d0  adrp     x2, #0x35000
0x000079d4  add      x2, x2, #0x3f0   ; -> @"pl"
0x000079d8  mov      x0, x20
0x000079dc  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000079e0  mov      x29, x29
0x000079e4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000079e8  mov      x25, x0
0x000079ec  bl       #0x25640   ; objc_msgSend: doubleValue
0x000079f0  mov      v9.16b, v0.16b
0x000079f4  adrp     x2, #0x35000
0x000079f8  add      x2, x2, #0x410   ; -> @"pb"
0x000079fc  mov      x0, x20
0x00007a00  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007a04  mov      x29, x29
0x00007a08  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007a0c  mov      x26, x0
0x00007a10  bl       #0x25640   ; objc_msgSend: doubleValue
0x00007a14  mov      v10.16b, v0.16b
0x00007a18  adrp     x2, #0x35000
0x00007a1c  add      x2, x2, #0x430   ; -> @"pr"
0x00007a20  mov      x0, x20
0x00007a24  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007a28  mov      x29, x29
0x00007a2c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007a30  mov      x27, x0
0x00007a34  bl       #0x25640   ; objc_msgSend: doubleValue
0x00007a38  mov      v11.16b, v0.16b
0x00007a3c  adrp     x2, #0x35000
0x00007a40  add      x2, x2, #0x3b0   ; -> @"identifier"
0x00007a44  mov      x0, x20
0x00007a48  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007a4c  mov      x29, x29
0x00007a50  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007a54  mov      x28, x0
0x00007a58  mov      x0, x23
0x00007a5c  mov      v0.16b, v8.16b
0x00007a60  mov      v1.16b, v9.16b
0x00007a64  mov      v2.16b, v10.16b
0x00007a68  mov      v3.16b, v11.16b
0x00007a6c  mov      x2, x28
0x00007a70  bl       #0x274e0   ; objc_msgSend: setPassInsets:forApp:
0x00007a74  mov      x0, x28
0x00007a78  bl       #0x2480c   ; call _objc_release
0x00007a7c  mov      x0, x27
0x00007a80  bl       #0x2480c   ; call _objc_release
0x00007a84  mov      x0, x26
0x00007a88  bl       #0x2480c   ; call _objc_release
0x00007a8c  mov      x0, x25
0x00007a90  bl       #0x2480c   ; call _objc_release
0x00007a94  mov      x0, x24
0x00007a98  bl       #0x2480c   ; call _objc_release
0x00007a9c  mov      x0, x23
0x00007aa0  bl       #0x2480c   ; call _objc_release
0x00007aa4  adrp     x8, #0x3e000
0x00007aa8  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x00007aac  bl       #0x27b20   ; objc_msgSend: shared
0x00007ab0  mov      x29, x29
0x00007ab4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007ab8  mov      x19, x0
0x00007abc  adrp     x2, #0x35000
0x00007ac0  add      x2, x2, #0x450   ; -> @"bar"
0x00007ac4  mov      x0, x20
0x00007ac8  str      x19, [sp, #0x20]
0x00007acc  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007ad0  mov      x29, x29
0x00007ad4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007ad8  str      x0, [sp, #0x18]
0x00007adc  bl       #0x24f20   ; objc_msgSend: boolValue
0x00007ae0  mov      x21, x0
0x00007ae4  adrp     x2, #0x35000
0x00007ae8  add      x2, x2, #0x470   ; -> @"pop"
0x00007aec  mov      x0, x20
0x00007af0  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007af4  mov      x29, x29
0x00007af8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007afc  mov      x25, x0
0x00007b00  bl       #0x25ba0   ; objc_msgSend: intValue
0x00007b04  mov      x22, x0
0x00007b08  adrp     x2, #0x35000
0x00007b0c  add      x2, x2, #0x490   ; -> @"popDim"
0x00007b10  mov      x0, x20
0x00007b14  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007b18  mov      x29, x29
0x00007b1c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007b20  mov      x26, x0
0x00007b24  bl       #0x24f20   ; objc_msgSend: boolValue
0x00007b28  mov      x28, x0
0x00007b2c  adrp     x2, #0x35000
0x00007b30  add      x2, x2, #0x4b0   ; -> @"single"
0x00007b34  mov      x0, x20
0x00007b38  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007b3c  mov      x29, x29
0x00007b40  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007b44  mov      x27, x0
0x00007b48  bl       #0x24f20   ; objc_msgSend: boolValue
0x00007b4c  mov      x23, x0
0x00007b50  adrp     x2, #0x35000
0x00007b54  add      x2, x2, #0x3b0   ; -> @"identifier"
0x00007b58  mov      x0, x20
0x00007b5c  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007b60  mov      x29, x29
0x00007b64  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007b68  mov      x19, x0
0x00007b6c  ldr      x24, [sp, #0x20]
0x00007b70  mov      x0, x24
0x00007b74  mov      x2, x21
0x00007b78  mov      x3, x22
0x00007b7c  mov      x4, x28
0x00007b80  mov      x5, x23
0x00007b84  mov      x6, x19
0x00007b88  bl       #0x26c60   ; objc_msgSend: setBarVisible:pop:dim:single:forApp:
0x00007b8c  mov      x0, x19
0x00007b90  bl       #0x2480c   ; call _objc_release
0x00007b94  mov      x0, x27
0x00007b98  bl       #0x2480c   ; call _objc_release
0x00007b9c  mov      x0, x26
0x00007ba0  bl       #0x2480c   ; call _objc_release
0x00007ba4  mov      x0, x25
0x00007ba8  bl       #0x2480c   ; call _objc_release
0x00007bac  ldr      x0, [sp, #0x18]
0x00007bb0  bl       #0x2480c   ; call _objc_release
0x00007bb4  mov      x0, x24
0x00007bb8  bl       #0x2480c   ; call _objc_release
0x00007bbc  adrp     x8, #0x3e000
0x00007bc0  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x00007bc4  bl       #0x27b20   ; objc_msgSend: shared
0x00007bc8  mov      x29, x29
0x00007bcc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007bd0  mov      x23, x0
0x00007bd4  adrp     x2, #0x35000
0x00007bd8  add      x2, x2, #0x4d0   ; -> @"ox"
0x00007bdc  mov      x0, x20
0x00007be0  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007be4  mov      x29, x29
0x00007be8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007bec  mov      x24, x0
0x00007bf0  bl       #0x25640   ; objc_msgSend: doubleValue
0x00007bf4  mov      v8.16b, v0.16b
0x00007bf8  adrp     x2, #0x35000
0x00007bfc  add      x2, x2, #0x4f0   ; -> @"oy"
0x00007c00  mov      x0, x20
0x00007c04  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007c08  mov      x29, x29
0x00007c0c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007c10  mov      x25, x0
0x00007c14  bl       #0x25640   ; objc_msgSend: doubleValue
0x00007c18  mov      v9.16b, v0.16b
0x00007c1c  adrp     x2, #0x35000
0x00007c20  add      x2, x2, #0x510   ; -> @"ow"
0x00007c24  mov      x0, x20
0x00007c28  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007c2c  mov      x29, x29
0x00007c30  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007c34  mov      x26, x0
0x00007c38  bl       #0x25640   ; objc_msgSend: doubleValue
0x00007c3c  mov      v10.16b, v0.16b
0x00007c40  adrp     x2, #0x35000
0x00007c44  add      x2, x2, #0x530   ; -> @"oh"
0x00007c48  mov      x0, x20
0x00007c4c  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007c50  mov      x29, x29
0x00007c54  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007c58  mov      x27, x0
0x00007c5c  bl       #0x25640   ; objc_msgSend: doubleValue
0x00007c60  mov      v11.16b, v0.16b
0x00007c64  adrp     x2, #0x35000
0x00007c68  add      x2, x2, #0x3b0   ; -> @"identifier"
0x00007c6c  mov      x0, x20
0x00007c70  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007c74  mov      x29, x29
0x00007c78  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007c7c  mov      x19, x0
0x00007c80  mov      x0, x23
0x00007c84  mov      v0.16b, v8.16b
0x00007c88  mov      v1.16b, v9.16b
0x00007c8c  mov      v2.16b, v10.16b
0x00007c90  mov      v3.16b, v11.16b
0x00007c94  mov      x2, x19
0x00007c98  bl       #0x27120   ; objc_msgSend: setHole:forApp:
0x00007c9c  mov      x0, x19
0x00007ca0  bl       #0x2480c   ; call _objc_release
0x00007ca4  mov      x0, x27
0x00007ca8  bl       #0x2480c   ; call _objc_release
0x00007cac  mov      x0, x26
0x00007cb0  bl       #0x2480c   ; call _objc_release
0x00007cb4  mov      x0, x25
0x00007cb8  bl       #0x2480c   ; call _objc_release
0x00007cbc  mov      x0, x24
0x00007cc0  bl       #0x2480c   ; call _objc_release
0x00007cc4  mov      x0, x23
0x00007cc8  bl       #0x2480c   ; call _objc_release
0x00007ccc  adrp     x8, #0x3e000
0x00007cd0  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x00007cd4  bl       #0x27b20   ; objc_msgSend: shared
0x00007cd8  mov      x29, x29
0x00007cdc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007ce0  mov      x23, x0
0x00007ce4  adrp     x2, #0x35000
0x00007ce8  add      x2, x2, #0x550   ; -> @"r"
0x00007cec  mov      x0, x20
0x00007cf0  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007cf4  mov      x29, x29
0x00007cf8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007cfc  mov      x24, x0
0x00007d00  bl       #0x25640   ; objc_msgSend: doubleValue
0x00007d04  mov      v8.16b, v0.16b
0x00007d08  adrp     x2, #0x35000
0x00007d0c  add      x2, x2, #0x570   ; -> @"corners"
0x00007d10  mov      x0, x20
0x00007d14  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007d18  mov      x29, x29
0x00007d1c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007d20  mov      x25, x0
0x00007d24  bl       #0x28060   ; objc_msgSend: unsignedLongLongValue
0x00007d28  mov      x21, x0
0x00007d2c  adrp     x2, #0x35000
0x00007d30  add      x2, x2, #0x3b0   ; -> @"identifier"
0x00007d34  mov      x0, x20
0x00007d38  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007d3c  mov      x29, x29
0x00007d40  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007d44  mov      x19, x0
0x00007d48  mov      x0, x23
0x00007d4c  mov      v0.16b, v8.16b
0x00007d50  mov      x2, x21
0x00007d54  mov      x3, x19
0x00007d58  bl       #0x26e40   ; objc_msgSend: setCornerRadius:corners:forApp:
0x00007d5c  mov      x0, x19
0x00007d60  bl       #0x2480c   ; call _objc_release
0x00007d64  mov      x0, x25
0x00007d68  bl       #0x2480c   ; call _objc_release
0x00007d6c  mov      x0, x24
0x00007d70  bl       #0x2480c   ; call _objc_release
0x00007d74  mov      x0, x23
0x00007d78  bl       #0x2480c   ; call _objc_release
0x00007d7c  adrp     x8, #0x3e000
0x00007d80  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x00007d84  bl       #0x27b20   ; objc_msgSend: shared
0x00007d88  mov      x29, x29
0x00007d8c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007d90  mov      x23, x0
0x00007d94  adrp     x2, #0x35000
0x00007d98  add      x2, x2, #0x590   ; -> @"hx"
0x00007d9c  mov      x0, x20
0x00007da0  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007da4  mov      x29, x29
0x00007da8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007dac  mov      x24, x0
0x00007db0  bl       #0x25640   ; objc_msgSend: doubleValue
0x00007db4  mov      v8.16b, v0.16b
0x00007db8  adrp     x2, #0x35000
0x00007dbc  add      x2, x2, #0x3b0   ; -> @"identifier"
0x00007dc0  mov      x0, x20
0x00007dc4  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007dc8  mov      x29, x29
0x00007dcc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007dd0  mov      x19, x0
0x00007dd4  mov      x0, x23
0x00007dd8  mov      v0.16b, v8.16b
0x00007ddc  mov      x2, x19
0x00007de0  bl       #0x27060   ; objc_msgSend: setHandleOffset:forApp:
0x00007de4  mov      x0, x19
0x00007de8  bl       #0x2480c   ; call _objc_release
0x00007dec  mov      x0, x24
0x00007df0  bl       #0x2480c   ; call _objc_release
0x00007df4  mov      x0, x23
0x00007df8  bl       #0x2480c   ; call _objc_release
0x00007dfc  adrp     x8, #0x3e000
0x00007e00  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x00007e04  bl       #0x27b20   ; objc_msgSend: shared
0x00007e08  mov      x29, x29
0x00007e0c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007e10  mov      x23, x0
0x00007e14  adrp     x2, #0x35000
0x00007e18  add      x2, x2, #0x5b0   ; -> @"front"
0x00007e1c  mov      x0, x20
0x00007e20  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007e24  mov      x29, x29
0x00007e28  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007e2c  mov      x24, x0
0x00007e30  bl       #0x24f20   ; objc_msgSend: boolValue
0x00007e34  mov      x21, x0
0x00007e38  adrp     x2, #0x35000
0x00007e3c  add      x2, x2, #0x3b0   ; -> @"identifier"
0x00007e40  mov      x0, x20
0x00007e44  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007e48  mov      x29, x29
0x00007e4c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007e50  mov      x19, x0
0x00007e54  mov      x0, x23
0x00007e58  mov      x2, x21
0x00007e5c  mov      x3, x19
0x00007e60  bl       #0x26fc0   ; objc_msgSend: setFront:forApp:
0x00007e64  mov      x0, x19
0x00007e68  bl       #0x2480c   ; call _objc_release
0x00007e6c  mov      x0, x24
0x00007e70  bl       #0x2480c   ; call _objc_release
0x00007e74  mov      x0, x23
0x00007e78  bl       #0x2480c   ; call _objc_release
0x00007e7c  adrp     x2, #0x35000
0x00007e80  add      x2, x2, #0x5d0   ; -> @"aw"
0x00007e84  mov      x0, x20
0x00007e88  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007e8c  mov      x29, x29
0x00007e90  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007e94  mov      x19, x0
0x00007e98  bl       #0x25640   ; objc_msgSend: doubleValue
0x00007e9c  mov      v8.16b, v0.16b
0x00007ea0  mov      x0, x19
0x00007ea4  bl       #0x2480c   ; call _objc_release
0x00007ea8  fcmp     d8, #0.0
0x00007eac  b.le     #0x7f94
0x00007eb0  adrp     x2, #0x35000
0x00007eb4  add      x2, x2, #0x5f0   ; -> @"ax"
0x00007eb8  mov      x0, x20
0x00007ebc  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007ec0  mov      x29, x29
0x00007ec4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007ec8  mov      x23, x0
0x00007ecc  bl       #0x25640   ; objc_msgSend: doubleValue
0x00007ed0  mov      v8.16b, v0.16b
0x00007ed4  adrp     x2, #0x35000
0x00007ed8  add      x2, x2, #0x610   ; -> @"ay"
0x00007edc  mov      x0, x20
0x00007ee0  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007ee4  mov      x29, x29
0x00007ee8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007eec  mov      x24, x0
0x00007ef0  bl       #0x25640   ; objc_msgSend: doubleValue
0x00007ef4  mov      v9.16b, v0.16b
0x00007ef8  adrp     x2, #0x35000
0x00007efc  add      x2, x2, #0x5d0   ; -> @"aw"
0x00007f00  mov      x0, x20
0x00007f04  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007f08  mov      x29, x29
0x00007f0c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007f10  mov      x25, x0
0x00007f14  bl       #0x25640   ; objc_msgSend: doubleValue
0x00007f18  mov      v10.16b, v0.16b
0x00007f1c  adrp     x2, #0x35000
0x00007f20  add      x2, x2, #0x630   ; -> @"ah"
0x00007f24  mov      x0, x20
0x00007f28  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00007f2c  mov      x29, x29
0x00007f30  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007f34  mov      x26, x0
0x00007f38  bl       #0x25640   ; objc_msgSend: doubleValue
0x00007f3c  mov      v11.16b, v0.16b
0x00007f40  adrp     x8, #0x3e000
0x00007f44  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x00007f48  bl       #0x27b20   ; objc_msgSend: shared
0x00007f4c  mov      x29, x29
0x00007f50  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007f54  mov      x19, x0
0x00007f58  mov      v0.16b, v8.16b
0x00007f5c  mov      v1.16b, v9.16b
0x00007f60  mov      v2.16b, v10.16b
0x00007f64  mov      v3.16b, v11.16b
0x00007f68  bl       #0x26d40   ; objc_msgSend: setCarAppArea:
0x00007f6c  mov      x0, x19
0x00007f70  bl       #0x2480c   ; call _objc_release
0x00007f74  mov      x0, x26
0x00007f78  bl       #0x2480c   ; call _objc_release
0x00007f7c  mov      x0, x25
0x00007f80  bl       #0x2480c   ; call _objc_release
0x00007f84  mov      x0, x24
0x00007f88  bl       #0x2480c   ; call _objc_release
0x00007f8c  mov      x0, x23
0x00007f90  bl       #0x2480c   ; call _objc_release
0x00007f94  mov      x0, x20
0x00007f98  bl       #0x2480c   ; call _objc_release
0x00007f9c  ldr      x0, [sp, #0x28]
0x00007fa0  ldp      x29, x30, [sp, #0xa0]
0x00007fa4  ldp      x20, x19, [sp, #0x90]
0x00007fa8  ldp      x22, x21, [sp, #0x80]
0x00007fac  ldp      x24, x23, [sp, #0x70]
0x00007fb0  ldp      x26, x25, [sp, #0x60]
0x00007fb4  ldp      x28, x27, [sp, #0x50]
0x00007fb8  ldp      d9, d8, [sp, #0x40]
0x00007fbc  ldp      d11, d10, [sp, #0x30]
0x00007fc0  add      sp, sp, #0xb0
0x00007fc4  b        #0x2480c   ; call _objc_release
0x00007fc8  mov      x22, x1
0x00007fcc  mov      x21, x0
0x00007fd0  mov      x0, x19
0x00007fd4  b        #0x8124   ; call sub_8124
0x00007fd8  b        #0x812c   ; call sub_812c
0x00007fdc  b        #0x8140   ; call sub_8140
0x00007fe0  b        #0x8154   ; call sub_8154
0x00007fe4  b        #0x8078   ; call sub_8078
0x00007fe8  mov      x22, x1
0x00007fec  mov      x21, x0
0x00007ff0  mov      x0, x19
0x00007ff4  b        #0x8168   ; call sub_8168
0x00007ff8  b        #0x8000   ; call sub_8000
0x00007ffc  b        #0x8078   ; call sub_8078

