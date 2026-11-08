; ==== sub_17918 @ 0x17918..0x17abc (420 bytes) ====
0x00017918  mov      x29, x29
0x0001791c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00017920  mov      x27, x0
0x00017924  bl       #0x26060   ; objc_msgSend: lowercaseString
0x00017928  mov      x29, x29
0x0001792c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00017930  mov      x26, x0
0x00017934  mov      x0, x27
0x00017938  bl       #0x2480c   ; call _objc_release
0x0001793c  ldr      w8, [sp, #0x14]
0x00017940  tbnz     w8, #0, #0x17958
0x00017944  adrp     x0, #0x39000
0x00017948  add      x0, x0, #0x4b0
0x0001794c  mov      x2, x26
0x00017950  bl       #0x25360   ; objc_msgSend: containsObject:
0x00017954  cbz      w0, #0x1795c
0x00017958  add      x24, x24, #1
0x0001795c  mov      x0, x26
0x00017960  bl       #0x2480c   ; call _objc_release
0x00017964  mov      x26, x24
0x00017968  b        #0x17aac   ; call sub_17aac
0x0001796c  cmp      w27, #0x61
0x00017970  b.eq     #0x179cc
0x00017974  cmp      w27, #0x64
0x00017978  b.ne     #0x17ca4
0x0001797c  mov      x0, x22
0x00017980  bl       #0x25fa0   ; objc_msgSend: length
0x00017984  cbz      x0, #0x17ca0
0x00017988  mov      x0, x22
0x0001798c  mov      x2, #0
0x00017990  bl       #0x25140   ; objc_msgSend: characterAtIndex:
0x00017994  orr      w8, w0, #0x20
0x00017998  cmp      w8, #0x64
0x0001799c  b.ne     #0x17c5c
0x000179a0  adrp     x8, #0x36000
0x000179a4  add      x8, x8, #0xbd0   ; -> @""
0x000179a8  adrp     x9, #0x36000
0x000179ac  add      x9, x9, #0xbb0   ; -> @""
0x000179b0  cmp      w0, #0x64
0x000179b4  csel     x4, x9, x8, eq
0x000179b8  mov      x0, x22
0x000179bc  mov      x2, #0
0x000179c0  mov      w3, #1
0x000179c4  bl       #0x268c0   ; objc_msgSend: replaceCharactersInRange:withString:
0x000179c8  b        #0x17b2c   ; call sub_17b2c
0x000179cc  tbnz     x26, #0x3f, #0x17ca0
0x000179d0  cmp      w27, #0x65
0x000179d4  mov      w8, #6
0x000179d8  mov      w9, #3
0x000179dc  csel     w8, w9, w8, eq
0x000179e0  mov      w9, #7
0x000179e4  mov      w10, #4
0x000179e8  csel     w9, w10, w9, eq
0x000179ec  cmp      w27, #0x61
0x000179f0  csel     w26, wzr, w8, eq
0x000179f4  mov      w8, #2
0x000179f8  csel     w21, w8, w9, eq
0x000179fc  cmp      x23, x24
0x00017a00  b.le     #0x17ca0
0x00017a04  sub      x23, x23, #1
0x00017a08  str      xzr, [sp, #0x38]
0x00017a0c  strb     wzr, [sp, #0x30]
0x00017a10  mov      x0, x22
0x00017a14  mov      x2, x23
0x00017a18  bl       #0x25140   ; objc_msgSend: characterAtIndex:
0x00017a1c  add      x1, sp, #0x3c
0x00017a20  add      x2, sp, #0x38
0x00017a24  add      x3, sp, #0x30
0x00017a28  bl       #0x17ecc   ; call sub_17ecc
0x00017a2c  ldr      w25, [sp, #0x3c]
0x00017a30  cmp      w25, w26
0x00017a34  ccmp     w25, w21, #4, ne
0x00017a38  b.ne     #0x179fc
0x00017a3c  cmp      w25, w26
0x00017a40  csel     w0, w21, w26, eq
0x00017a44  ldr      w1, [sp, #0x38]
0x00017a48  ldrb     w2, [sp, #0x30]
0x00017a4c  bl       #0x180c0   ; call sub_180c0
0x00017a50  strh     w0, [sp, #0x34]
0x00017a54  adrp     x8, #0x3e000
0x00017a58  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x00017a5c  add      x2, sp, #0x34
0x00017a60  mov      w3, #1
0x00017a64  bl       #0x27ce0   ; objc_msgSend: stringWithCharacters:length:
0x00017a68  mov      x29, x29
0x00017a6c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00017a70  mov      x24, x0
0x00017a74  mov      x0, x22
0x00017a78  mov      x2, x23
0x00017a7c  mov      w3, #1
0x00017a80  mov      x4, x24
0x00017a84  bl       #0x268c0   ; objc_msgSend: replaceCharactersInRange:withString:
0x00017a88  mov      x0, x24
0x00017a8c  bl       #0x2480c   ; call _objc_release
0x00017a90  cmp      w25, w21
0x00017a94  b.ne     #0x17b2c
0x00017a98  mov      x0, x22
0x00017a9c  mov      x2, x20
0x00017aa0  bl       #0x24d60   ; objc_msgSend: appendString:
0x00017aa4  b        #0x17b2c   ; call sub_17b2c
0x00017aa8  add      x26, x24, #1
0x00017aac  mov      x0, x22
0x00017ab0  bl       #0x2480c   ; call _objc_release
0x00017ab4  str      wzr, [sp, #0x3c]
0x00017ab8  strb     wzr, [sp, #0x34]
