; ==== sub_21930 @ 0x21930..0x21d30 (1024 bytes) ====
0x00021930  mov      x0, x26
0x00021934  mov      w4, #0x10
0x00021938  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0002193c  mov      x23, x0
0x00021940  cbnz     x0, #0x218a4
0x00021944  mov      x0, x26
0x00021948  bl       #0x2480c   ; call _objc_release
0x0002194c  adrp     x8, #0x3e000
0x00021950  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x00021954  ldr      x9, [sp, #0x38]
0x00021958  cmp      x9, #0
0x0002195c  adrp     x8, #0x37000
0x00021960  add      x8, x8, #0x310   ; -> @"?"
0x00021964  csel     x8, x8, x9, eq
0x00021968  ldr      x9, [sp, #0x58]
0x0002196c  stp      x8, x9, [sp]
0x00021970  adrp     x2, #0x38000
0x00021974  add      x2, x2, #0x950   ; -> @"nap ho so xe %@ (%@)"
0x00021978  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0002197c  mov      x29, x29
0x00021980  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021984  mov      x21, x0
0x00021988  adrp     x0, #0x37000
0x0002198c  add      x0, x0, #0xd50   ; -> @"Core"
0x00021990  mov      x1, x21
0x00021994  bl       #0x1dd30   ; call _OMCLogWrite
0x00021998  mov      x0, x21
0x0002199c  bl       #0x2480c   ; call _objc_release
0x000219a0  b        #0x21a54   ; call sub_21a54
0x000219a4  adrp     x8, #0x38000
0x000219a8  add      x8, x8, #0x910   ; -> @"values"
0x000219ac  str      x8, [sp, #0x200]
0x000219b0  bl       #0x23434   ; call sub_23434
0x000219b4  mov      x29, x29
0x000219b8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000219bc  mov      x23, x0
0x000219c0  str      x0, [sp, #0x180]
0x000219c4  ldr      x0, [x24, #0x310]
0x000219c8  add      x2, sp, #0x180
0x000219cc  add      x3, sp, #0x200
0x000219d0  mov      w4, #1
0x000219d4  bl       #0x255c0   ; objc_msgSend: dictionaryWithObjects:forKeys:count:
0x000219d8  mov      x29, x29
0x000219dc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000219e0  mov      x21, x0
0x000219e4  bl       #0x261e0   ; objc_msgSend: mutableCopy
0x000219e8  str      x0, [sp, #0x60]
0x000219ec  mov      x0, x21
0x000219f0  bl       #0x2480c   ; call _objc_release
0x000219f4  mov      x0, x23
0x000219f8  bl       #0x2480c   ; call _objc_release
0x000219fc  mov      x0, x19
0x00021a00  ldp      x3, x2, [sp, #0x58]
0x00021a04  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00021a08  adrp     x8, #0x3e000
0x00021a0c  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x00021a10  ldr      x9, [sp, #0x38]
0x00021a14  cmp      x9, #0
0x00021a18  adrp     x8, #0x37000
0x00021a1c  add      x8, x8, #0x310   ; -> @"?"
0x00021a20  csel     x8, x8, x9, eq
0x00021a24  ldr      x9, [sp, #0x58]
0x00021a28  stp      x8, x9, [sp]
0x00021a2c  adrp     x2, #0x38000
0x00021a30  add      x2, x2, #0x930   ; -> @"ho so xe moi: %@ (%@)"
0x00021a34  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00021a38  mov      x29, x29
0x00021a3c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021a40  mov      x25, x0
0x00021a44  adrp     x0, #0x37000
0x00021a48  add      x0, x0, #0xd50   ; -> @"Core"
0x00021a4c  mov      x1, x25
0x00021a50  bl       #0x1dd30   ; call _OMCLogWrite
0x00021a54  mov      x0, x25
0x00021a58  bl       #0x2480c   ; call _objc_release
0x00021a5c  ldr      x2, [sp, #0x38]
0x00021a60  cbz      x2, #0x21a78
0x00021a64  ldr      x0, [sp, #0x60]
0x00021a68  adrp     x3, #0x38000
0x00021a6c  add      x3, x3, #0x790   ; -> @"name"
0x00021a70  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00021a74  b        #0x21ab4   ; call sub_21ab4
0x00021a78  adrp     x0, #0x38000
0x00021a7c  add      x0, x0, #0x970   ; -> @"Xe"
0x00021a80  adrp     x1, #0x38000
0x00021a84  add      x1, x1, #0x990   ; -> @"Car"
0x00021a88  bl       #0x23a38   ; call _OMCTr
0x00021a8c  mov      x29, x29
0x00021a90  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021a94  mov      x21, x0
0x00021a98  ldr      x0, [sp, #0x60]
0x00021a9c  mov      x2, x21
0x00021aa0  adrp     x3, #0x38000
0x00021aa4  add      x3, x3, #0x790   ; -> @"name"
0x00021aa8  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00021aac  mov      x0, x21
0x00021ab0  bl       #0x2480c   ; call _objc_release
0x00021ab4  adrp     x8, #0x3e000
0x00021ab8  ldr      x0, [x8, #0x418]   ; -> [class(NSDate)]
0x00021abc  bl       #0x25480   ; objc_msgSend: date
0x00021ac0  mov      x29, x29
0x00021ac4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021ac8  mov      x21, x0
0x00021acc  ldr      x0, [sp, #0x60]
0x00021ad0  mov      x2, x21
0x00021ad4  adrp     x3, #0x38000
0x00021ad8  add      x3, x3, #0x9b0   ; -> @"lastSeen"
0x00021adc  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00021ae0  mov      x0, x21
0x00021ae4  bl       #0x2480c   ; call _objc_release
0x00021ae8  adrp     x0, #0x38000
0x00021aec  add      x0, x0, #0x8d0   ; -> @"carProfiles"
0x00021af0  mov      x1, x19
0x00021af4  adrp     x2, #0x37000
0x00021af8  add      x2, x2, #0x70   ; -> @"com.anlai.omnicar"
0x00021afc  bl       #0x242cc   ; call _CFPreferencesSetAppValue
0x00021b00  adrp     x0, #0x38000
0x00021b04  add      x0, x0, #0x8f0   ; -> @"carProfileCurrent"
0x00021b08  ldr      x1, [sp, #0x58]
0x00021b0c  adrp     x2, #0x37000
0x00021b10  add      x2, x2, #0x70   ; -> @"com.anlai.omnicar"
0x00021b14  bl       #0x242cc   ; call _CFPreferencesSetAppValue
0x00021b18  adrp     x0, #0x37000
0x00021b1c  add      x0, x0, #0x70   ; -> @"com.anlai.omnicar"
0x00021b20  bl       #0x242b4   ; call _CFPreferencesAppSynchronize
0x00021b24  adrp     x0, #0x2a000
0x00021b28  add      x0, x0, #0xb0d   ; -> "com.anlai.omnicar/prefschanged"
0x00021b2c  bl       #0x246ec   ; call _notify_post
0x00021b30  ldr      x0, [sp, #0x60]
0x00021b34  bl       #0x2480c   ; call _objc_release
0x00021b38  ldr      x0, [sp, #0x40]
0x00021b3c  bl       #0x2480c   ; call _objc_release
0x00021b40  mov      x0, x22
0x00021b44  bl       #0x2480c   ; call _objc_release
0x00021b48  mov      x0, x19
0x00021b4c  bl       #0x2480c   ; call _objc_release
0x00021b50  ldr      x0, [sp, #0x58]
0x00021b54  bl       #0x2480c   ; call _objc_release
0x00021b58  ldr      x0, [sp, #0x30]
0x00021b5c  bl       #0x2480c   ; call _objc_release
0x00021b60  ldr      x0, [sp, #0x38]
0x00021b64  bl       #0x2480c   ; call _objc_release
0x00021b68  ldr      x0, [sp, #0x78]
0x00021b6c  bl       #0x2480c   ; call _objc_release
0x00021b70  adrp     x8, #0x3e000
0x00021b74  ldr      x23, [x8, #0x290]   ; -> [class(NSString)]
0x00021b78  ldr      x0, [sp, #0x78]
0x00021b7c  adrp     x2, #0x38000
0x00021b80  add      x2, x2, #0x1b0   ; -> @"points"
0x00021b84  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00021b88  mov      x29, x29
0x00021b8c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021b90  mov      x19, x0
0x00021b94  ldr      x0, [sp, #0x78]
0x00021b98  adrp     x2, #0x38000
0x00021b9c  add      x2, x2, #0x1d0   ; -> @"pixels"
0x00021ba0  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00021ba4  mov      x29, x29
0x00021ba8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021bac  mov      x20, x0
0x00021bb0  ldr      x0, [sp, #0x78]
0x00021bb4  adrp     x2, #0x38000
0x00021bb8  add      x2, x2, #0x210   ; -> @"maxFPS"
0x00021bbc  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00021bc0  mov      x29, x29
0x00021bc4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021bc8  mov      x22, x0
0x00021bcc  ldr      x0, [sp, #0x78]
0x00021bd0  adrp     x2, #0x37000
0x00021bd4  add      x2, x2, #0x950   ; -> @"session"
0x00021bd8  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00021bdc  mov      x29, x29
0x00021be0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021be4  mov      x25, x0
0x00021be8  cmp      x0, #0
0x00021bec  cset     w8, ne
0x00021bf0  stp      x19, x20, [sp]
0x00021bf4  stp      x22, x8, [sp, #0x10]
0x00021bf8  mov      x0, x23
0x00021bfc  adrp     x2, #0x38000
0x00021c00  add      x2, x2, #0x290   ; -> @"man xe %@ pt, %@ px, %@ fps, session=%d"
0x00021c04  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00021c08  mov      x29, x29
0x00021c0c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021c10  mov      x21, x0
0x00021c14  adrp     x0, #0x37000
0x00021c18  add      x0, x0, #0xd50   ; -> @"Core"
0x00021c1c  mov      x1, x21
0x00021c20  bl       #0x1dd30   ; call _OMCLogWrite
0x00021c24  mov      x0, x21
0x00021c28  bl       #0x2480c   ; call _objc_release
0x00021c2c  mov      x0, x25
0x00021c30  bl       #0x2480c   ; call _objc_release
0x00021c34  mov      x0, x22
0x00021c38  bl       #0x2480c   ; call _objc_release
0x00021c3c  mov      x0, x20
0x00021c40  bl       #0x2480c   ; call _objc_release
0x00021c44  mov      x0, x19
0x00021c48  bl       #0x2480c   ; call _objc_release
0x00021c4c  ldr      x0, [sp, #0x78]
0x00021c50  bl       #0x2480c   ; call _objc_release
0x00021c54  ldr      x0, [sp, #0x70]
0x00021c58  bl       #0x2480c   ; call _objc_release
0x00021c5c  ldr      x9, [sp, #0x68]
0x00021c60  add      x9, x9, #1
0x00021c64  ldr      x8, [sp, #0x50]
0x00021c68  str      x9, [sp, #0x68]
0x00021c6c  cmp      x9, x8
0x00021c70  b.ne     #0x20dc4
0x00021c74  b        #0x21cec   ; call sub_21cec
0x00021c78  b        #0x21c84   ; call sub_21c84
0x00021c7c  b        #0x21c84   ; call sub_21c84
0x00021c80  b        #0x21c84   ; call sub_21c84
0x00021c84  mov      x19, x0
0x00021c88  cmp      w1, #1
0x00021c8c  b.ne     #0x21d64
0x00021c90  mov      x0, x19
0x00021c94  bl       #0x24740   ; call _objc_begin_catch
0x00021c98  mov      x19, x0
0x00021c9c  bl       #0x24818   ; call _objc_retain
0x00021ca0  adrp     x8, #0x3e000
0x00021ca4  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x00021ca8  str      x19, [sp]
0x00021cac  adrp     x2, #0x38000
0x00021cb0  add      x2, x2, #0x270   ; -> @"CarKit loi: %@"
0x00021cb4  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00021cb8  mov      x29, x29
0x00021cbc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021cc0  mov      x20, x0
0x00021cc4  adrp     x0, #0x37000
0x00021cc8  add      x0, x0, #0xd50   ; -> @"Core"
0x00021ccc  mov      x1, x20
0x00021cd0  bl       #0x1dd30   ; call _OMCLogWrite
0x00021cd4  mov      x0, x20
0x00021cd8  bl       #0x2480c   ; call _objc_release
0x00021cdc  mov      x0, x19
0x00021ce0  bl       #0x2480c   ; call _objc_release
0x00021ce4  bl       #0x24764   ; call _objc_end_catch
0x00021ce8  b        #0x214e4   ; call sub_214e4
0x00021cec  add      x2, sp, #0x80
0x00021cf0  add      x3, sp, #0x100
0x00021cf4  ldr      x0, [sp, #0x28]
0x00021cf8  mov      w4, #0x10
0x00021cfc  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00021d00  str      x0, [sp, #0x50]
0x00021d04  ldr      x8, [sp, #0x50]
0x00021d08  cbnz     x8, #0x20dc0
0x00021d0c  ldr      x0, [sp, #0x28]
0x00021d10  bl       #0x2480c   ; call _objc_release
0x00021d14  ldur     x8, [x29, #-0x70]
0x00021d18  adrp     x9, #0x34000
0x00021d1c  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00021d20  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x00021d24  cmp      x9, x8
0x00021d28  b.ne     #0x21d50
0x00021d2c  add      sp, sp, #0x2d0
