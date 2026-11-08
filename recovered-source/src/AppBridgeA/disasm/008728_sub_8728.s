; ==== sub_8728 @ 0x8728..0x90a8 (2432 bytes) ====
0x00008728  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000872c  mov      x23, x0
0x00008730  adrp     x2, #0x35000
0x00008734  add      x2, x2, #0x550   ; -> @"r"
0x00008738  mov      x0, x20
0x0000873c  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008740  mov      x29, x29
0x00008744  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008748  mov      x24, x0
0x0000874c  bl       #0x25640   ; objc_msgSend: doubleValue
0x00008750  mov      v8.16b, v0.16b
0x00008754  adrp     x2, #0x35000
0x00008758  add      x2, x2, #0x570   ; -> @"corners"
0x0000875c  mov      x0, x20
0x00008760  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008764  mov      x29, x29
0x00008768  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000876c  mov      x25, x0
0x00008770  bl       #0x28060   ; objc_msgSend: unsignedLongLongValue
0x00008774  mov      x21, x0
0x00008778  adrp     x2, #0x35000
0x0000877c  add      x2, x2, #0x3b0   ; -> @"identifier"
0x00008780  mov      x0, x20
0x00008784  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008788  mov      x29, x29
0x0000878c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008790  mov      x19, x0
0x00008794  mov      x0, x23
0x00008798  mov      v0.16b, v8.16b
0x0000879c  mov      x2, x21
0x000087a0  mov      x3, x19
0x000087a4  bl       #0x26e40   ; objc_msgSend: setCornerRadius:corners:forApp:
0x000087a8  mov      x0, x19
0x000087ac  bl       #0x2480c   ; call _objc_release
0x000087b0  mov      x0, x25
0x000087b4  bl       #0x2480c   ; call _objc_release
0x000087b8  mov      x0, x24
0x000087bc  bl       #0x2480c   ; call _objc_release
0x000087c0  mov      x0, x23
0x000087c4  bl       #0x2480c   ; call _objc_release
0x000087c8  adrp     x8, #0x3e000
0x000087cc  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x000087d0  bl       #0x27b20   ; objc_msgSend: shared
0x000087d4  mov      x29, x29
0x000087d8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000087dc  mov      x23, x0
0x000087e0  adrp     x2, #0x35000
0x000087e4  add      x2, x2, #0x590   ; -> @"hx"
0x000087e8  mov      x0, x20
0x000087ec  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000087f0  mov      x29, x29
0x000087f4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000087f8  mov      x24, x0
0x000087fc  bl       #0x25640   ; objc_msgSend: doubleValue
0x00008800  mov      v8.16b, v0.16b
0x00008804  adrp     x2, #0x35000
0x00008808  add      x2, x2, #0x3b0   ; -> @"identifier"
0x0000880c  mov      x0, x20
0x00008810  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008814  mov      x29, x29
0x00008818  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000881c  mov      x19, x0
0x00008820  mov      x0, x23
0x00008824  mov      v0.16b, v8.16b
0x00008828  mov      x2, x19
0x0000882c  bl       #0x27060   ; objc_msgSend: setHandleOffset:forApp:
0x00008830  mov      x0, x19
0x00008834  bl       #0x2480c   ; call _objc_release
0x00008838  mov      x0, x24
0x0000883c  bl       #0x2480c   ; call _objc_release
0x00008840  mov      x0, x23
0x00008844  bl       #0x2480c   ; call _objc_release
0x00008848  adrp     x8, #0x3e000
0x0000884c  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x00008850  bl       #0x27b20   ; objc_msgSend: shared
0x00008854  mov      x29, x29
0x00008858  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000885c  mov      x23, x0
0x00008860  adrp     x2, #0x35000
0x00008864  add      x2, x2, #0x5b0   ; -> @"front"
0x00008868  mov      x0, x20
0x0000886c  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008870  mov      x29, x29
0x00008874  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008878  mov      x24, x0
0x0000887c  bl       #0x24f20   ; objc_msgSend: boolValue
0x00008880  mov      x21, x0
0x00008884  adrp     x2, #0x35000
0x00008888  add      x2, x2, #0x3b0   ; -> @"identifier"
0x0000888c  mov      x0, x20
0x00008890  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008894  mov      x29, x29
0x00008898  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000889c  mov      x19, x0
0x000088a0  mov      x0, x23
0x000088a4  mov      x2, x21
0x000088a8  mov      x3, x19
0x000088ac  bl       #0x26fc0   ; objc_msgSend: setFront:forApp:
0x000088b0  mov      x0, x19
0x000088b4  bl       #0x2480c   ; call _objc_release
0x000088b8  mov      x0, x24
0x000088bc  bl       #0x2480c   ; call _objc_release
0x000088c0  mov      x0, x23
0x000088c4  bl       #0x2480c   ; call _objc_release
0x000088c8  adrp     x2, #0x35000
0x000088cc  add      x2, x2, #0x5d0   ; -> @"aw"
0x000088d0  mov      x0, x20
0x000088d4  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000088d8  mov      x29, x29
0x000088dc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000088e0  mov      x19, x0
0x000088e4  bl       #0x25640   ; objc_msgSend: doubleValue
0x000088e8  mov      v8.16b, v0.16b
0x000088ec  mov      x0, x19
0x000088f0  bl       #0x2480c   ; call _objc_release
0x000088f4  fcmp     d8, #0.0
0x000088f8  b.le     #0x89e0
0x000088fc  adrp     x2, #0x35000
0x00008900  add      x2, x2, #0x5f0   ; -> @"ax"
0x00008904  mov      x0, x20
0x00008908  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0000890c  mov      x29, x29
0x00008910  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008914  mov      x23, x0
0x00008918  bl       #0x25640   ; objc_msgSend: doubleValue
0x0000891c  mov      v8.16b, v0.16b
0x00008920  adrp     x2, #0x35000
0x00008924  add      x2, x2, #0x610   ; -> @"ay"
0x00008928  mov      x0, x20
0x0000892c  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008930  mov      x29, x29
0x00008934  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008938  mov      x24, x0
0x0000893c  bl       #0x25640   ; objc_msgSend: doubleValue
0x00008940  mov      v9.16b, v0.16b
0x00008944  adrp     x2, #0x35000
0x00008948  add      x2, x2, #0x5d0   ; -> @"aw"
0x0000894c  mov      x0, x20
0x00008950  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008954  mov      x29, x29
0x00008958  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000895c  mov      x25, x0
0x00008960  bl       #0x25640   ; objc_msgSend: doubleValue
0x00008964  mov      v10.16b, v0.16b
0x00008968  adrp     x2, #0x35000
0x0000896c  add      x2, x2, #0x630   ; -> @"ah"
0x00008970  mov      x0, x20
0x00008974  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008978  mov      x29, x29
0x0000897c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008980  mov      x26, x0
0x00008984  bl       #0x25640   ; objc_msgSend: doubleValue
0x00008988  mov      v11.16b, v0.16b
0x0000898c  adrp     x8, #0x3e000
0x00008990  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x00008994  bl       #0x27b20   ; objc_msgSend: shared
0x00008998  mov      x29, x29
0x0000899c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000089a0  mov      x19, x0
0x000089a4  mov      v0.16b, v8.16b
0x000089a8  mov      v1.16b, v9.16b
0x000089ac  mov      v2.16b, v10.16b
0x000089b0  mov      v3.16b, v11.16b
0x000089b4  bl       #0x26d40   ; objc_msgSend: setCarAppArea:
0x000089b8  mov      x0, x19
0x000089bc  bl       #0x2480c   ; call _objc_release
0x000089c0  mov      x0, x26
0x000089c4  bl       #0x2480c   ; call _objc_release
0x000089c8  mov      x0, x25
0x000089cc  bl       #0x2480c   ; call _objc_release
0x000089d0  mov      x0, x24
0x000089d4  bl       #0x2480c   ; call _objc_release
0x000089d8  mov      x0, x23
0x000089dc  bl       #0x2480c   ; call _objc_release
0x000089e0  mov      x0, x20
0x000089e4  bl       #0x2480c   ; call _objc_release
0x000089e8  ldr      x0, [sp, #0x18]
0x000089ec  ldp      x29, x30, [sp, #0xb0]
0x000089f0  ldp      x20, x19, [sp, #0xa0]
0x000089f4  ldp      x22, x21, [sp, #0x90]
0x000089f8  ldp      x24, x23, [sp, #0x80]
0x000089fc  ldp      x26, x25, [sp, #0x70]
0x00008a00  ldp      x28, x27, [sp, #0x60]
0x00008a04  ldp      d9, d8, [sp, #0x50]
0x00008a08  ldp      d11, d10, [sp, #0x40]
0x00008a0c  ldp      d13, d12, [sp, #0x30]
0x00008a10  ldp      d15, d14, [sp, #0x20]
0x00008a14  add      sp, sp, #0xc0
0x00008a18  b        #0x2480c   ; call _objc_release
0x00008a1c  mov      x22, x1
0x00008a20  mov      x21, x0
0x00008a24  mov      x0, x19
0x00008a28  b        #0x8b08   ; call sub_8b08
0x00008a2c  b        #0x8b78   ; call sub_8b78
0x00008a30  b        #0x8b8c   ; call sub_8b8c
0x00008a34  b        #0x8b18   ; call sub_8b18
0x00008a38  b        #0x8ab8   ; call sub_8ab8
0x00008a3c  mov      x22, x1
0x00008a40  mov      x21, x0
0x00008a44  mov      x0, x19
0x00008a48  b        #0x8ba8   ; call sub_8ba8
0x00008a4c  b        #0x8a54   ; call sub_8a54
0x00008a50  b        #0x8ab8   ; call sub_8ab8
0x00008a54  mov      x22, x1
0x00008a58  mov      x21, x0
0x00008a5c  mov      x0, x19
0x00008a60  b        #0x8b98   ; call sub_8b98
0x00008a64  b        #0x8ab8   ; call sub_8ab8
0x00008a68  mov      x22, x1
0x00008a6c  mov      x21, x0
0x00008a70  mov      x0, x19
0x00008a74  b        #0x8b84   ; call sub_8b84
0x00008a78  b        #0x8ab8   ; call sub_8ab8
0x00008a7c  mov      x22, x1
0x00008a80  mov      x21, x0
0x00008a84  mov      x0, x19
0x00008a88  bl       #0x2480c   ; call _objc_release
0x00008a8c  b        #0x8b04   ; call sub_8b04
0x00008a90  b        #0x8ab8   ; call sub_8ab8
0x00008a94  mov      x22, x1
0x00008a98  mov      x21, x0
0x00008a9c  mov      x0, x19
0x00008aa0  bl       #0x2480c   ; call _objc_release
0x00008aa4  b        #0x8b2c   ; call sub_8b2c
0x00008aa8  mov      x22, x1
0x00008aac  mov      x21, x0
0x00008ab0  b        #0x8b70   ; call sub_8b70
0x00008ab4  b        #0x8b18   ; call sub_8b18
0x00008ab8  mov      x22, x1
0x00008abc  mov      x21, x0
0x00008ac0  b        #0x8ba4   ; call sub_8ba4
0x00008ac4  b        #0x8acc   ; call sub_8acc
0x00008ac8  b        #0x8adc   ; call sub_8adc
0x00008acc  mov      x21, x0
0x00008ad0  mov      x0, x19
0x00008ad4  bl       #0x2480c   ; call _objc_release
0x00008ad8  b        #0x8c30   ; call sub_8c30
0x00008adc  mov      x21, x0
0x00008ae0  b        #0x8c58   ; call sub_8c58
0x00008ae4  mov      x21, x0
0x00008ae8  b        #0x8c60   ; call sub_8c60
0x00008aec  b        #0x8b18   ; call sub_8b18
0x00008af0  b        #0x8b18   ; call sub_8b18
0x00008af4  b        #0x8b8c   ; call sub_8b8c
0x00008af8  b        #0x8b18   ; call sub_8b18
0x00008afc  mov      x22, x1
0x00008b00  mov      x21, x0
0x00008b04  mov      x0, x27
0x00008b08  bl       #0x2480c   ; call _objc_release
0x00008b0c  b        #0x8b80   ; call sub_8b80
0x00008b10  b        #0x8b78   ; call sub_8b78
0x00008b14  b        #0x8b8c   ; call sub_8b8c
0x00008b18  mov      x22, x1
0x00008b1c  mov      x21, x0
0x00008b20  b        #0x8b9c   ; call sub_8b9c
0x00008b24  mov      x22, x1
0x00008b28  mov      x21, x0
0x00008b2c  mov      x0, x27
0x00008b30  bl       #0x2480c   ; call _objc_release
0x00008b34  b        #0x8b40   ; call sub_8b40
0x00008b38  mov      x22, x1
0x00008b3c  mov      x21, x0
0x00008b40  mov      x0, x26
0x00008b44  bl       #0x2480c   ; call _objc_release
0x00008b48  b        #0x8b54   ; call sub_8b54
0x00008b4c  mov      x22, x1
0x00008b50  mov      x21, x0
0x00008b54  mov      x0, x25
0x00008b58  bl       #0x2480c   ; call _objc_release
0x00008b5c  b        #0x8b68   ; call sub_8b68
0x00008b60  mov      x22, x1
0x00008b64  mov      x21, x0
0x00008b68  ldr      x0, [sp, #8]
0x00008b6c  bl       #0x2480c   ; call _objc_release
0x00008b70  ldr      x0, [sp, #0x10]
0x00008b74  b        #0x8ba8   ; call sub_8ba8
0x00008b78  mov      x22, x1
0x00008b7c  mov      x21, x0
0x00008b80  mov      x0, x26
0x00008b84  bl       #0x2480c   ; call _objc_release
0x00008b88  b        #0x8b94   ; call sub_8b94
0x00008b8c  mov      x22, x1
0x00008b90  mov      x21, x0
0x00008b94  mov      x0, x25
0x00008b98  bl       #0x2480c   ; call _objc_release
0x00008b9c  mov      x0, x24
0x00008ba0  bl       #0x2480c   ; call _objc_release
0x00008ba4  mov      x0, x23
0x00008ba8  bl       #0x2480c   ; call _objc_release
0x00008bac  cmp      w22, #1
0x00008bb0  b.ne     #0x8c58
0x00008bb4  mov      x0, x21
0x00008bb8  bl       #0x24740   ; call _objc_begin_catch
0x00008bbc  adrp     x8, #0x3e000
0x00008bc0  ldr      x8, [x8, #0x290]   ; -> [class(NSString)]
0x00008bc4  str      x0, [sp]
0x00008bc8  adrp     x2, #0x35000
0x00008bcc  add      x2, x2, #0x6d0   ; -> @"frame loi %@"
0x00008bd0  mov      x0, x8
0x00008bd4  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00008bd8  mov      x29, x29
0x00008bdc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008be0  mov      x19, x0
0x00008be4  adrp     x0, #0x34000
0x00008be8  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00008bec  mov      x1, x19
0x00008bf0  bl       #0x1dd30   ; call _OMCLogWrite
0x00008bf4  mov      x0, x19
0x00008bf8  bl       #0x2480c   ; call _objc_release
0x00008bfc  bl       #0x24764   ; call _objc_end_catch
0x00008c00  b        #0x89e0   ; call sub_89e0
0x00008c04  mov      x21, x0
0x00008c08  mov      x0, x19
0x00008c0c  bl       #0x2480c   ; call _objc_release
0x00008c10  b        #0x8c18   ; call sub_8c18
0x00008c14  mov      x21, x0
0x00008c18  bl       #0x24764   ; call _objc_end_catch
0x00008c1c  b        #0x8c58   ; call sub_8c58
0x00008c20  b        #0x8c2c   ; call sub_8c2c
0x00008c24  b        #0x8c3c   ; call sub_8c3c
0x00008c28  b        #0x8c4c   ; call sub_8c4c
0x00008c2c  mov      x21, x0
0x00008c30  mov      x0, x24
0x00008c34  bl       #0x2480c   ; call _objc_release
0x00008c38  b        #0x8c40   ; call sub_8c40
0x00008c3c  mov      x21, x0
0x00008c40  mov      x0, x23
0x00008c44  bl       #0x2480c   ; call _objc_release
0x00008c48  b        #0x8c50   ; call sub_8c50
0x00008c4c  mov      x21, x0
0x00008c50  mov      x0, x22
0x00008c54  bl       #0x2480c   ; call _objc_release
0x00008c58  mov      x0, x20
0x00008c5c  bl       #0x2480c   ; call _objc_release
0x00008c60  ldr      x0, [sp, #0x18]
0x00008c64  bl       #0x2480c   ; call _objc_release
0x00008c68  mov      x0, x21
0x00008c6c  bl       #0x24470   ; call __Unwind_Resume
0x00008c70  mov      x22, x1
0x00008c74  mov      x21, x0
0x00008c78  b        #0x8bac   ; call sub_8bac
0x00008c7c  sub      sp, sp, #0x50
0x00008c80  stp      x24, x23, [sp, #0x10]
0x00008c84  stp      x22, x21, [sp, #0x20]
0x00008c88  stp      x20, x19, [sp, #0x30]
0x00008c8c  stp      x29, x30, [sp, #0x40]
0x00008c90  add      x29, sp, #0x40
0x00008c94  mov      x19, x1
0x00008c98  mov      x0, x1
0x00008c9c  bl       #0x24818   ; call _objc_retain
0x00008ca0  adrp     x8, #0x3e000
0x00008ca4  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x00008ca8  bl       #0x27b20   ; objc_msgSend: shared
0x00008cac  mov      x29, x29
0x00008cb0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008cb4  mov      x20, x0
0x00008cb8  mov      x0, x19
0x00008cbc  bl       #0x280c0   ; objc_msgSend: userInfo
0x00008cc0  mov      x29, x29
0x00008cc4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008cc8  mov      x22, x0
0x00008ccc  adrp     x2, #0x35000
0x00008cd0  add      x2, x2, #0x710   ; -> @"on"
0x00008cd4  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008cd8  mov      x29, x29
0x00008cdc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008ce0  mov      x21, x0
0x00008ce4  bl       #0x24f20   ; objc_msgSend: boolValue
0x00008ce8  mov      x2, x0
0x00008cec  mov      x0, x20
0x00008cf0  bl       #0x277c0   ; objc_msgSend: setShieldAll:
0x00008cf4  mov      x0, x21
0x00008cf8  bl       #0x2480c   ; call _objc_release
0x00008cfc  mov      x0, x22
0x00008d00  bl       #0x2480c   ; call _objc_release
0x00008d04  mov      x0, x20
0x00008d08  bl       #0x2480c   ; call _objc_release
0x00008d0c  mov      x0, x19
0x00008d10  ldp      x29, x30, [sp, #0x40]
0x00008d14  ldp      x20, x19, [sp, #0x30]
0x00008d18  ldp      x22, x21, [sp, #0x20]
0x00008d1c  ldp      x24, x23, [sp, #0x10]
0x00008d20  add      sp, sp, #0x50
0x00008d24  b        #0x2480c   ; call _objc_release
0x00008d28  mov      x23, x1
0x00008d2c  mov      x21, x0
0x00008d30  b        #0x8d60   ; call sub_8d60
0x00008d34  mov      x23, x1
0x00008d38  mov      x21, x0
0x00008d3c  b        #0x8d68   ; call sub_8d68
0x00008d40  mov      x23, x1
0x00008d44  mov      x21, x0
0x00008d48  b        #0x8d70   ; call sub_8d70
0x00008d4c  mov      x23, x1
0x00008d50  mov      x1, x21
0x00008d54  mov      x21, x0
0x00008d58  mov      x0, x1
0x00008d5c  bl       #0x2480c   ; call _objc_release
0x00008d60  mov      x0, x22
0x00008d64  bl       #0x2480c   ; call _objc_release
0x00008d68  mov      x0, x20
0x00008d6c  bl       #0x2480c   ; call _objc_release
0x00008d70  cmp      w23, #1
0x00008d74  b.ne     #0x8de0
0x00008d78  mov      x0, x21
0x00008d7c  bl       #0x24740   ; call _objc_begin_catch
0x00008d80  adrp     x8, #0x3e000
0x00008d84  ldr      x8, [x8, #0x290]   ; -> [class(NSString)]
0x00008d88  str      x0, [sp]
0x00008d8c  adrp     x2, #0x35000
0x00008d90  add      x2, x2, #0x730   ; -> @"shield loi %@"
0x00008d94  mov      x0, x8
0x00008d98  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00008d9c  mov      x29, x29
0x00008da0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008da4  mov      x20, x0
0x00008da8  adrp     x0, #0x34000
0x00008dac  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00008db0  mov      x1, x20
0x00008db4  bl       #0x1dd30   ; call _OMCLogWrite
0x00008db8  mov      x0, x20
0x00008dbc  bl       #0x2480c   ; call _objc_release
0x00008dc0  bl       #0x24764   ; call _objc_end_catch
0x00008dc4  b        #0x8d0c   ; call sub_8d0c
0x00008dc8  mov      x21, x0
0x00008dcc  mov      x0, x20
0x00008dd0  bl       #0x2480c   ; call _objc_release
0x00008dd4  b        #0x8ddc   ; call sub_8ddc
0x00008dd8  mov      x21, x0
0x00008ddc  bl       #0x24764   ; call _objc_end_catch
0x00008de0  mov      x0, x19
0x00008de4  bl       #0x2480c   ; call _objc_release
0x00008de8  mov      x0, x21
0x00008dec  bl       #0x24470   ; call __Unwind_Resume
0x00008df0  sub      sp, sp, #0x60
0x00008df4  stp      x26, x25, [sp, #0x10]
0x00008df8  stp      x24, x23, [sp, #0x20]
0x00008dfc  stp      x22, x21, [sp, #0x30]
0x00008e00  stp      x20, x19, [sp, #0x40]
0x00008e04  stp      x29, x30, [sp, #0x50]
0x00008e08  add      x29, sp, #0x50
0x00008e0c  mov      x19, x1
0x00008e10  mov      x0, x1
0x00008e14  bl       #0x24818   ; call _objc_retain
0x00008e18  adrp     x8, #0x3e000
0x00008e1c  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x00008e20  bl       #0x27b20   ; objc_msgSend: shared
0x00008e24  mov      x29, x29
0x00008e28  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008e2c  mov      x20, x0
0x00008e30  mov      x0, x19
0x00008e34  bl       #0x280c0   ; objc_msgSend: userInfo
0x00008e38  mov      x29, x29
0x00008e3c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008e40  mov      x21, x0
0x00008e44  adrp     x2, #0x35000
0x00008e48  add      x2, x2, #0x3b0   ; -> @"identifier"
0x00008e4c  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008e50  mov      x29, x29
0x00008e54  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008e58  mov      x23, x0
0x00008e5c  mov      x0, x19
0x00008e60  bl       #0x280c0   ; objc_msgSend: userInfo
0x00008e64  mov      x29, x29
0x00008e68  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008e6c  mov      x25, x0
0x00008e70  adrp     x2, #0x35000
0x00008e74  add      x2, x2, #0x770   ; -> @"terminate"
0x00008e78  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008e7c  mov      x29, x29
0x00008e80  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008e84  mov      x22, x0
0x00008e88  bl       #0x24f20   ; objc_msgSend: boolValue
0x00008e8c  mov      x3, x0
0x00008e90  mov      x0, x20
0x00008e94  mov      x2, x23
0x00008e98  bl       #0x251e0   ; objc_msgSend: closeApp:terminate:
0x00008e9c  mov      x0, x22
0x00008ea0  bl       #0x2480c   ; call _objc_release
0x00008ea4  mov      x0, x25
0x00008ea8  bl       #0x2480c   ; call _objc_release
0x00008eac  mov      x0, x23
0x00008eb0  bl       #0x2480c   ; call _objc_release
0x00008eb4  mov      x0, x21
0x00008eb8  bl       #0x2480c   ; call _objc_release
0x00008ebc  mov      x0, x20
0x00008ec0  bl       #0x2480c   ; call _objc_release
0x00008ec4  mov      x0, x19
0x00008ec8  ldp      x29, x30, [sp, #0x50]
0x00008ecc  ldp      x20, x19, [sp, #0x40]
0x00008ed0  ldp      x22, x21, [sp, #0x30]
0x00008ed4  ldp      x24, x23, [sp, #0x20]
0x00008ed8  ldp      x26, x25, [sp, #0x10]
0x00008edc  add      sp, sp, #0x60
0x00008ee0  b        #0x2480c   ; call _objc_release
0x00008ee4  mov      x24, x1
0x00008ee8  mov      x22, x0
0x00008eec  b        #0x8f34   ; call sub_8f34
0x00008ef0  mov      x24, x1
0x00008ef4  mov      x22, x0
0x00008ef8  b        #0x8f3c   ; call sub_8f3c
0x00008efc  mov      x24, x1
0x00008f00  mov      x22, x0
0x00008f04  b        #0x8f44   ; call sub_8f44
0x00008f08  mov      x24, x1
0x00008f0c  mov      x22, x0
0x00008f10  b        #0x8f4c   ; call sub_8f4c
0x00008f14  mov      x24, x1
0x00008f18  mov      x22, x0
0x00008f1c  b        #0x8f54   ; call sub_8f54
0x00008f20  mov      x24, x1
0x00008f24  mov      x1, x22
0x00008f28  mov      x22, x0
0x00008f2c  mov      x0, x1
0x00008f30  bl       #0x2480c   ; call _objc_release
0x00008f34  mov      x0, x25
0x00008f38  bl       #0x2480c   ; call _objc_release
0x00008f3c  mov      x0, x23
0x00008f40  bl       #0x2480c   ; call _objc_release
0x00008f44  mov      x0, x21
0x00008f48  bl       #0x2480c   ; call _objc_release
0x00008f4c  mov      x0, x20
0x00008f50  bl       #0x2480c   ; call _objc_release
0x00008f54  cmp      w24, #1
0x00008f58  b.ne     #0x8fc4
0x00008f5c  mov      x0, x22
0x00008f60  bl       #0x24740   ; call _objc_begin_catch
0x00008f64  adrp     x8, #0x3e000
0x00008f68  ldr      x8, [x8, #0x290]   ; -> [class(NSString)]
0x00008f6c  str      x0, [sp]
0x00008f70  adrp     x2, #0x35000
0x00008f74  add      x2, x2, #0x790   ; -> @"close loi %@"
0x00008f78  mov      x0, x8
0x00008f7c  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00008f80  mov      x29, x29
0x00008f84  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008f88  mov      x20, x0
0x00008f8c  adrp     x0, #0x34000
0x00008f90  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00008f94  mov      x1, x20
0x00008f98  bl       #0x1dd30   ; call _OMCLogWrite
0x00008f9c  mov      x0, x20
0x00008fa0  bl       #0x2480c   ; call _objc_release
0x00008fa4  bl       #0x24764   ; call _objc_end_catch
0x00008fa8  b        #0x8ec4   ; call sub_8ec4
0x00008fac  mov      x22, x0
0x00008fb0  mov      x0, x20
0x00008fb4  bl       #0x2480c   ; call _objc_release
0x00008fb8  b        #0x8fc0   ; call sub_8fc0
0x00008fbc  mov      x22, x0
0x00008fc0  bl       #0x24764   ; call _objc_end_catch
0x00008fc4  mov      x0, x19
0x00008fc8  bl       #0x2480c   ; call _objc_release
0x00008fcc  mov      x0, x22
0x00008fd0  bl       #0x24470   ; call __Unwind_Resume
0x00008fd4  sub      sp, sp, #0x50
0x00008fd8  stp      x24, x23, [sp, #0x10]
0x00008fdc  stp      x22, x21, [sp, #0x20]
0x00008fe0  stp      x20, x19, [sp, #0x30]
0x00008fe4  stp      x29, x30, [sp, #0x40]
0x00008fe8  add      x29, sp, #0x40
0x00008fec  mov      x19, x1
0x00008ff0  mov      x0, x1
0x00008ff4  bl       #0x24818   ; call _objc_retain
0x00008ff8  adrp     x8, #0x3e000
0x00008ffc  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x00009000  bl       #0x27b20   ; objc_msgSend: shared
0x00009004  mov      x29, x29
0x00009008  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000900c  mov      x20, x0
0x00009010  mov      x0, x19
0x00009014  bl       #0x280c0   ; objc_msgSend: userInfo
0x00009018  mov      x29, x29
0x0000901c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009020  mov      x22, x0
0x00009024  adrp     x2, #0x35000
0x00009028  add      x2, x2, #0x7d0   ; -> @"except"
0x0000902c  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00009030  mov      x29, x29
0x00009034  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009038  mov      x21, x0
0x0000903c  mov      x0, x20
0x00009040  mov      x2, x21
0x00009044  bl       #0x251c0   ; objc_msgSend: closeAllExcept:
0x00009048  mov      x0, x21
0x0000904c  bl       #0x2480c   ; call _objc_release
0x00009050  mov      x0, x22
0x00009054  bl       #0x2480c   ; call _objc_release
0x00009058  mov      x0, x20
0x0000905c  bl       #0x2480c   ; call _objc_release
0x00009060  mov      x0, x19
0x00009064  ldp      x29, x30, [sp, #0x40]
0x00009068  ldp      x20, x19, [sp, #0x30]
0x0000906c  ldp      x22, x21, [sp, #0x20]
0x00009070  ldp      x24, x23, [sp, #0x10]
0x00009074  add      sp, sp, #0x50
0x00009078  b        #0x2480c   ; call _objc_release
0x0000907c  mov      x23, x1
0x00009080  mov      x1, x21
0x00009084  mov      x21, x0
0x00009088  mov      x0, x1
0x0000908c  bl       #0x2480c   ; call _objc_release
0x00009090  b        #0x909c   ; call sub_909c
0x00009094  mov      x23, x1
0x00009098  mov      x21, x0
0x0000909c  mov      x0, x22
0x000090a0  bl       #0x2480c   ; call _objc_release
0x000090a4  b        #0x90b0   ; call sub_90b0
