; ==== sub_17abc @ 0x17abc..0x18c7c (4544 bytes) ====
0x00017abc  mov      x0, x22
0x00017ac0  mov      x2, x26
0x00017ac4  bl       #0x25140   ; objc_msgSend: characterAtIndex:
0x00017ac8  add      x1, sp, #0x3c
0x00017acc  add      x3, sp, #0x34
0x00017ad0  mov      x2, #0
0x00017ad4  bl       #0x17ecc   ; call sub_17ecc
0x00017ad8  ldr      w0, [sp, #0x3c]
0x00017adc  ldrb     w2, [sp, #0x34]
0x00017ae0  mov      x1, x25
0x00017ae4  ldr      x19, [sp, #0x18]
0x00017ae8  bl       #0x180c0   ; call sub_180c0
0x00017aec  strh     w0, [sp, #0x38]
0x00017af0  adrp     x8, #0x3e000
0x00017af4  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x00017af8  add      x2, sp, #0x38
0x00017afc  mov      w3, #1
0x00017b00  bl       #0x27ce0   ; objc_msgSend: stringWithCharacters:length:
0x00017b04  mov      x29, x29
0x00017b08  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00017b0c  mov      x24, x0
0x00017b10  mov      x0, x22
0x00017b14  mov      x2, x26
0x00017b18  mov      w3, #1
0x00017b1c  mov      x4, x24
0x00017b20  bl       #0x268c0   ; objc_msgSend: replaceCharactersInRange:withString:
0x00017b24  mov      x0, x24
0x00017b28  bl       #0x2480c   ; call _objc_release
0x00017b2c  mov      x0, x22
0x00017b30  bl       #0x24818   ; call _objc_retain
0x00017b34  mov      x28, x22
0x00017b38  b        #0x17ca4   ; call sub_17ca4
0x00017b3c  tbnz     x26, #0x3f, #0x17c14
0x00017b40  add      x8, x24, #1
0x00017b44  cmp      x8, x23
0x00017b48  b.ge     #0x17bc0
0x00017b4c  sub      x21, x23, #1
0x00017b50  mov      x25, x24
0x00017b54  stp      xzr, xzr, [sp, #0x30]
0x00017b58  strh     wzr, [sp, #0x2e]
0x00017b5c  mov      x0, x22
0x00017b60  mov      x2, x25
0x00017b64  bl       #0x25140   ; objc_msgSend: characterAtIndex:
0x00017b68  add      x1, sp, #0x3c
0x00017b6c  add      x2, sp, #0x38
0x00017b70  add      x3, sp, #0x2f
0x00017b74  bl       #0x17ecc   ; call sub_17ecc
0x00017b78  add      x2, x25, #1
0x00017b7c  mov      x0, x22
0x00017b80  bl       #0x25140   ; objc_msgSend: characterAtIndex:
0x00017b84  add      x1, sp, #0x34
0x00017b88  add      x2, sp, #0x30
0x00017b8c  add      x3, sp, #0x2e
0x00017b90  bl       #0x17ecc   ; call sub_17ecc
0x00017b94  ldr      w8, [sp, #0x3c]
0x00017b98  cmp      w8, #9
0x00017b9c  b.ne     #0x17bb4
0x00017ba0  ldr      w8, [sp, #0x34]
0x00017ba4  cmp      w8, #8
0x00017ba8  b.eq     #0x17ce8
0x00017bac  cmp      w8, #6
0x00017bb0  b.eq     #0x17ce8
0x00017bb4  add      x25, x25, #1
0x00017bb8  cmp      x21, x25
0x00017bbc  b.ne     #0x17b54
0x00017bc0  cmp      x23, x24
0x00017bc4  b.le     #0x17ca0
0x00017bc8  mov      w25, #0x743
0x00017bcc  sub      x23, x23, #1
0x00017bd0  str      xzr, [sp, #0x38]
0x00017bd4  strb     wzr, [sp, #0x30]
0x00017bd8  mov      x0, x22
0x00017bdc  mov      x2, x23
0x00017be0  bl       #0x25140   ; objc_msgSend: characterAtIndex:
0x00017be4  add      x1, sp, #0x3c
0x00017be8  add      x2, sp, #0x38
0x00017bec  add      x3, sp, #0x30
0x00017bf0  bl       #0x17ecc   ; call sub_17ecc
0x00017bf4  ldr      w21, [sp, #0x3c]
0x00017bf8  cmp      w21, #0xa
0x00017bfc  b.hi     #0x17c08
0x00017c00  lsr      w8, w25, w21
0x00017c04  tbnz     w8, #0, #0x17d4c
0x00017c08  cmp      x23, x24
0x00017c0c  b.gt     #0x17bcc
0x00017c10  b        #0x17ca0   ; call sub_17ca0
0x00017c14  cmp      w27, w25
0x00017c18  cset     w2, ne
0x00017c1c  mov      w0, #0xa
0x00017c20  mov      w1, #0
0x00017c24  bl       #0x180c0   ; call sub_180c0
0x00017c28  strh     w0, [sp, #0x3c]
0x00017c2c  adrp     x8, #0x3e000
0x00017c30  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x00017c34  add      x2, sp, #0x3c
0x00017c38  mov      w3, #1
0x00017c3c  bl       #0x27ce0   ; objc_msgSend: stringWithCharacters:length:
0x00017c40  mov      x29, x29
0x00017c44  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00017c48  mov      x24, x0
0x00017c4c  mov      x0, x22
0x00017c50  mov      x2, x24
0x00017c54  bl       #0x24d60   ; objc_msgSend: appendString:
0x00017c58  b        #0x17b24   ; call sub_17b24
0x00017c5c  and      w8, w0, #0xfffe
0x00017c60  cmp      w8, #0x110
0x00017c64  b.ne     #0x17ca0
0x00017c68  adrp     x8, #0x36000
0x00017c6c  add      x8, x8, #0xc10   ; -> @"D"
0x00017c70  adrp     x9, #0x36000
0x00017c74  add      x9, x9, #0xbf0   ; -> @"d"
0x00017c78  cmp      w0, #0x111
0x00017c7c  csel     x4, x9, x8, eq
0x00017c80  mov      x0, x22
0x00017c84  mov      x2, #0
0x00017c88  mov      w3, #1
0x00017c8c  bl       #0x268c0   ; objc_msgSend: replaceCharactersInRange:withString:
0x00017c90  mov      x0, x22
0x00017c94  mov      x2, x20
0x00017c98  bl       #0x24d60   ; objc_msgSend: appendString:
0x00017c9c  b        #0x17b2c   ; call sub_17b2c
0x00017ca0  mov      x28, #0
0x00017ca4  mov      x0, x22
0x00017ca8  bl       #0x2480c   ; call _objc_release
0x00017cac  ldr      x0, [sp, #0x20]
0x00017cb0  bl       #0x2480c   ; call _objc_release
0x00017cb4  mov      x0, x20
0x00017cb8  bl       #0x2480c   ; call _objc_release
0x00017cbc  mov      x0, x19
0x00017cc0  bl       #0x2480c   ; call _objc_release
0x00017cc4  mov      x0, x28
0x00017cc8  ldp      x29, x30, [sp, #0x90]
0x00017ccc  ldp      x20, x19, [sp, #0x80]
0x00017cd0  ldp      x22, x21, [sp, #0x70]
0x00017cd4  ldp      x24, x23, [sp, #0x60]
0x00017cd8  ldp      x26, x25, [sp, #0x50]
0x00017cdc  ldp      x28, x27, [sp, #0x40]
0x00017ce0  add      sp, sp, #0xa0
0x00017ce4  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x00017ce8  ldr      w1, [sp, #0x38]
0x00017cec  ldrb     w2, [sp, #0x2f]
0x00017cf0  mov      w0, #0xa
0x00017cf4  bl       #0x180c0   ; call sub_180c0
0x00017cf8  mov      x23, x0
0x00017cfc  ldr      w1, [sp, #0x30]
0x00017d00  ldrb     w2, [sp, #0x2e]
0x00017d04  mov      w0, #8
0x00017d08  bl       #0x180c0   ; call sub_180c0
0x00017d0c  adrp     x8, #0x3e000
0x00017d10  ldr      x8, [x8, #0x290]   ; -> [class(NSString)]
0x00017d14  stp      x23, x0, [sp]
0x00017d18  adrp     x2, #0x36000
0x00017d1c  add      x2, x2, #0xb90   ; -> @"%C%C"
0x00017d20  mov      x0, x8
0x00017d24  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00017d28  mov      x29, x29
0x00017d2c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00017d30  mov      x24, x0
0x00017d34  mov      x0, x22
0x00017d38  mov      x2, x25
0x00017d3c  mov      w3, #2
0x00017d40  mov      x4, x24
0x00017d44  bl       #0x268c0   ; objc_msgSend: replaceCharactersInRange:withString:
0x00017d48  b        #0x17b24   ; call sub_17b24
0x00017d4c  adrp     x8, #0x2b000
0x00017d50  add      x8, x8, #0x404
0x00017d54  ldr      w0, [x8, x21, lsl #2]
0x00017d58  ldr      w1, [sp, #0x38]
0x00017d5c  ldrb     w2, [sp, #0x30]
0x00017d60  bl       #0x180c0   ; call sub_180c0
0x00017d64  strh     w0, [sp, #0x34]
0x00017d68  adrp     x8, #0x3e000
0x00017d6c  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x00017d70  add      x2, sp, #0x34
0x00017d74  mov      w3, #1
0x00017d78  bl       #0x27ce0   ; objc_msgSend: stringWithCharacters:length:
0x00017d7c  mov      x29, x29
0x00017d80  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00017d84  mov      x24, x0
0x00017d88  mov      x0, x22
0x00017d8c  mov      x2, x23
0x00017d90  mov      w3, #1
0x00017d94  mov      x4, x24
0x00017d98  bl       #0x268c0   ; objc_msgSend: replaceCharactersInRange:withString:
0x00017d9c  mov      x0, x24
0x00017da0  bl       #0x2480c   ; call _objc_release
0x00017da4  cmp      w21, #0xa
0x00017da8  b.hi     #0x17b2c
0x00017dac  mov      w8, #1
0x00017db0  lsl      w8, w8, w21
0x00017db4  mov      w9, #0x502
0x00017db8  tst      w8, w9
0x00017dbc  b.eq     #0x17b2c
0x00017dc0  mov      x0, x22
0x00017dc4  mov      x2, x20
0x00017dc8  bl       #0x24d60   ; objc_msgSend: appendString:
0x00017dcc  b        #0x17b2c   ; call sub_17b2c
0x00017dd0  b        #0x17de8   ; call sub_17de8
0x00017dd4  b        #0x17de8   ; call sub_17de8
0x00017dd8  b        #0x17e9c   ; call sub_17e9c
0x00017ddc  b        #0x17e9c   ; call sub_17e9c
0x00017de0  b        #0x17e9c   ; call sub_17e9c
0x00017de4  b        #0x17de8   ; call sub_17de8
0x00017de8  str      x19, [sp, #0x18]
0x00017dec  b        #0x17e20   ; call sub_17e20
0x00017df0  mov      x23, x0
0x00017df4  mov      x0, x26
0x00017df8  b        #0x17e14   ; call sub_17e14
0x00017dfc  b        #0x17e9c   ; call sub_17e9c
0x00017e00  b        #0x17e9c   ; call sub_17e9c
0x00017e04  b        #0x17e9c   ; call sub_17e9c
0x00017e08  b        #0x17e9c   ; call sub_17e9c
0x00017e0c  mov      x23, x0
0x00017e10  mov      x0, x27
0x00017e14  bl       #0x2480c   ; call _objc_release
0x00017e18  b        #0x17e7c   ; call sub_17e7c
0x00017e1c  b        #0x17e78   ; call sub_17e78
0x00017e20  mov      x23, x0
0x00017e24  mov      x0, x24
0x00017e28  b        #0x17e8c   ; call sub_17e8c
0x00017e2c  b        #0x17ea0   ; call sub_17ea0
0x00017e30  b        #0x17e9c   ; call sub_17e9c
0x00017e34  b        #0x17ea0   ; call sub_17ea0
0x00017e38  b        #0x17ea0   ; call sub_17ea0
0x00017e3c  b        #0x17e9c   ; call sub_17e9c
0x00017e40  b        #0x17e9c   ; call sub_17e9c
0x00017e44  b        #0x17e9c   ; call sub_17e9c
0x00017e48  b        #0x17e9c   ; call sub_17e9c
0x00017e4c  b        #0x17e9c   ; call sub_17e9c
0x00017e50  b        #0x17e9c   ; call sub_17e9c
0x00017e54  b        #0x17e58   ; call sub_17e58
0x00017e58  str      x19, [sp, #0x18]
0x00017e5c  mov      x23, x0
0x00017e60  b        #0x17eac   ; call sub_17eac
0x00017e64  b        #0x17e6c   ; call sub_17e6c
0x00017e68  b        #0x17e6c   ; call sub_17e6c
0x00017e6c  str      x19, [sp, #0x18]
0x00017e70  mov      x23, x0
0x00017e74  b        #0x17eb4   ; call sub_17eb4
0x00017e78  mov      x23, x0
0x00017e7c  mov      x0, x22
0x00017e80  b        #0x17e8c   ; call sub_17e8c
0x00017e84  mov      x23, x0
0x00017e88  mov      x0, x27
0x00017e8c  bl       #0x2480c   ; call _objc_release
0x00017e90  b        #0x17ea4   ; call sub_17ea4
0x00017e94  b        #0x17ea0   ; call sub_17ea0
0x00017e98  b        #0x17ea0   ; call sub_17ea0
0x00017e9c  str      x19, [sp, #0x18]
0x00017ea0  mov      x23, x0
0x00017ea4  mov      x0, x22
0x00017ea8  bl       #0x2480c   ; call _objc_release
0x00017eac  ldr      x0, [sp, #0x20]
0x00017eb0  bl       #0x2480c   ; call _objc_release
0x00017eb4  mov      x0, x20
0x00017eb8  bl       #0x2480c   ; call _objc_release
0x00017ebc  ldr      x0, [sp, #0x18]
0x00017ec0  bl       #0x2480c   ; call _objc_release
0x00017ec4  mov      x0, x23
0x00017ec8  bl       #0x24470   ; call __Unwind_Resume
0x00017ecc  sub      sp, sp, #0x80
0x00017ed0  stp      x28, x27, [sp, #0x20]
0x00017ed4  stp      x26, x25, [sp, #0x30]
0x00017ed8  stp      x24, x23, [sp, #0x40]
0x00017edc  stp      x22, x21, [sp, #0x50]
0x00017ee0  stp      x20, x19, [sp, #0x60]
0x00017ee4  stp      x29, x30, [sp, #0x70]
0x00017ee8  add      x29, sp, #0x70
0x00017eec  str      x3, [sp, #8]
0x00017ef0  mov      x21, x2
0x00017ef4  mov      x23, x1
0x00017ef8  strh     w0, [sp, #0x1e]
0x00017efc  adrp     x22, #0x3e000
0x00017f00  ldr      x0, [x22, #0x290]   ; -> [class(NSString)]
0x00017f04  add      x2, sp, #0x1e
0x00017f08  mov      w3, #1
0x00017f0c  bl       #0x27ce0   ; objc_msgSend: stringWithCharacters:length:
0x00017f10  mov      x29, x29
0x00017f14  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00017f18  str      x0, [sp, #0x10]
0x00017f1c  bl       #0x26060   ; objc_msgSend: lowercaseString
0x00017f20  mov      x29, x29
0x00017f24  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00017f28  mov      x20, x0
0x00017f2c  bl       #0x25fa0   ; objc_msgSend: length
0x00017f30  cmp      x0, #1
0x00017f34  str      x23, [sp]
0x00017f38  b.ne     #0x17f50
0x00017f3c  mov      x0, x20
0x00017f40  mov      x2, #0
0x00017f44  bl       #0x25140   ; objc_msgSend: characterAtIndex:
0x00017f48  mov      x19, x21
0x00017f4c  b        #0x17f58   ; call sub_17f58
0x00017f50  mov      x19, x21
0x00017f54  ldrh     w0, [sp, #0x1e]
0x00017f58  strh     w0, [sp, #0x1c]
0x00017f5c  bl       #0x1d5dc   ; call sub_1d5dc
0x00017f60  mov      x29, x29
0x00017f64  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00017f68  mov      x24, x0
0x00017f6c  mov      x25, #0
0x00017f70  mov      x23, #0x7fffffffffffffff
0x00017f74  mov      x0, x24
0x00017f78  bl       #0x25420   ; objc_msgSend: count
0x00017f7c  mov      x26, x0
0x00017f80  cmp      x25, w26, sxtw
0x00017f84  b.ge     #0x18020
0x00017f88  mov      x0, x24
0x00017f8c  mov      x2, x25
0x00017f90  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x00017f94  mov      x29, x29
0x00017f98  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00017f9c  mov      x27, x0
0x00017fa0  ldr      x0, [x22, #0x290]   ; -> [class(NSString)]
0x00017fa4  add      x2, sp, #0x1c
0x00017fa8  mov      w3, #1
0x00017fac  bl       #0x27ce0   ; objc_msgSend: stringWithCharacters:length:
0x00017fb0  mov      x29, x29
0x00017fb4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00017fb8  mov      x21, x0
0x00017fbc  mov      x0, x27
0x00017fc0  mov      x2, x21
0x00017fc4  bl       #0x26740   ; objc_msgSend: rangeOfString:
0x00017fc8  mov      x28, x0
0x00017fcc  mov      x0, x21
0x00017fd0  bl       #0x2480c   ; call _objc_release
0x00017fd4  mov      x0, x27
0x00017fd8  bl       #0x2480c   ; call _objc_release
0x00017fdc  cmp      x28, x23
0x00017fe0  b.ne     #0x17fec
0x00017fe4  add      x25, x25, #1
0x00017fe8  b        #0x17f74   ; call sub_17f74
0x00017fec  ldr      x8, [sp]
0x00017ff0  cbz      x8, #0x17ff8
0x00017ff4  str      w25, [x8]
0x00017ff8  cbz      x19, #0x18000
0x00017ffc  str      w28, [x19]
0x00018000  ldr      x8, [sp, #8]
0x00018004  cbz      x8, #0x18020
0x00018008  ldrh     w8, [sp, #0x1c]
0x0001800c  ldrh     w9, [sp, #0x1e]
0x00018010  cmp      w8, w9
0x00018014  cset     w8, ne
0x00018018  ldr      x9, [sp, #8]
0x0001801c  strb     w8, [x9]
0x00018020  sxtw     x8, w26
0x00018024  cmp      x25, x8
0x00018028  cset     w21, lt
0x0001802c  mov      x0, x24
0x00018030  bl       #0x2480c   ; call _objc_release
0x00018034  mov      x0, x20
0x00018038  bl       #0x2480c   ; call _objc_release
0x0001803c  ldr      x0, [sp, #0x10]
0x00018040  bl       #0x2480c   ; call _objc_release
0x00018044  mov      x0, x21
0x00018048  ldp      x29, x30, [sp, #0x70]
0x0001804c  ldp      x20, x19, [sp, #0x60]
0x00018050  ldp      x22, x21, [sp, #0x50]
0x00018054  ldp      x24, x23, [sp, #0x40]
0x00018058  ldp      x26, x25, [sp, #0x30]
0x0001805c  ldp      x28, x27, [sp, #0x20]
0x00018060  add      sp, sp, #0x80
0x00018064  ret      
0x00018068  mov      x22, x0
0x0001806c  b        #0x180b0   ; call sub_180b0
0x00018070  mov      x22, x0
0x00018074  b        #0x180a8   ; call sub_180a8
0x00018078  b        #0x1809c   ; call sub_1809c
0x0001807c  mov      x22, x0
0x00018080  mov      x0, x21
0x00018084  bl       #0x2480c   ; call _objc_release
0x00018088  b        #0x18090   ; call sub_18090
0x0001808c  mov      x22, x0
0x00018090  mov      x0, x27
0x00018094  bl       #0x2480c   ; call _objc_release
0x00018098  b        #0x180a0   ; call sub_180a0
0x0001809c  mov      x22, x0
0x000180a0  mov      x0, x24
0x000180a4  bl       #0x2480c   ; call _objc_release
0x000180a8  mov      x0, x20
0x000180ac  bl       #0x2480c   ; call _objc_release
0x000180b0  ldr      x0, [sp, #0x10]
0x000180b4  bl       #0x2480c   ; call _objc_release
0x000180b8  mov      x0, x22
0x000180bc  bl       #0x24470   ; call __Unwind_Resume
0x000180c0  sub      sp, sp, #0x40
0x000180c4  stp      x22, x21, [sp, #0x10]
0x000180c8  stp      x20, x19, [sp, #0x20]
0x000180cc  stp      x29, x30, [sp, #0x30]
0x000180d0  add      x29, sp, #0x30
0x000180d4  mov      x20, x2
0x000180d8  mov      x21, x1
0x000180dc  mov      x22, x0
0x000180e0  bl       #0x1d5dc   ; call sub_1d5dc
0x000180e4  mov      x29, x29
0x000180e8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000180ec  mov      x19, x0
0x000180f0  sxtw     x2, w22
0x000180f4  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x000180f8  mov      x29, x29
0x000180fc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018100  mov      x22, x0
0x00018104  sxtw     x2, w21
0x00018108  bl       #0x25140   ; objc_msgSend: characterAtIndex:
0x0001810c  mov      x21, x0
0x00018110  mov      x0, x22
0x00018114  bl       #0x2480c   ; call _objc_release
0x00018118  mov      x0, x19
0x0001811c  bl       #0x2480c   ; call _objc_release
0x00018120  strh     w21, [sp, #0xe]
0x00018124  tbz      w20, #0, #0x18190
0x00018128  adrp     x8, #0x3e000
0x0001812c  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x00018130  add      x2, sp, #0xe
0x00018134  mov      w3, #1
0x00018138  bl       #0x27ce0   ; objc_msgSend: stringWithCharacters:length:
0x0001813c  mov      x29, x29
0x00018140  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018144  mov      x21, x0
0x00018148  bl       #0x280a0   ; objc_msgSend: uppercaseString
0x0001814c  mov      x29, x29
0x00018150  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018154  mov      x19, x0
0x00018158  mov      x0, x21
0x0001815c  bl       #0x2480c   ; call _objc_release
0x00018160  mov      x0, x19
0x00018164  bl       #0x25fa0   ; objc_msgSend: length
0x00018168  cmp      x0, #1
0x0001816c  b.ne     #0x18184
0x00018170  mov      x0, x19
0x00018174  mov      x2, #0
0x00018178  bl       #0x25140   ; objc_msgSend: characterAtIndex:
0x0001817c  mov      x21, x0
0x00018180  b        #0x18188   ; call sub_18188
0x00018184  ldrh     w21, [sp, #0xe]
0x00018188  mov      x0, x19
0x0001818c  bl       #0x2480c   ; call _objc_release
0x00018190  mov      x0, x21
0x00018194  ldp      x29, x30, [sp, #0x30]
0x00018198  ldp      x20, x19, [sp, #0x20]
0x0001819c  ldp      x22, x21, [sp, #0x10]
0x000181a0  add      sp, sp, #0x40
0x000181a4  ret      
0x000181a8  mov      x20, x0
0x000181ac  mov      x0, x21
0x000181b0  b        #0x181d0   ; call sub_181d0
0x000181b4  b        #0x181c8   ; call sub_181c8
0x000181b8  mov      x20, x0
0x000181bc  mov      x0, x22
0x000181c0  bl       #0x2480c   ; call _objc_release
0x000181c4  b        #0x181cc   ; call sub_181cc
0x000181c8  mov      x20, x0
0x000181cc  mov      x0, x19
0x000181d0  bl       #0x2480c   ; call _objc_release
0x000181d4  mov      x0, x20
0x000181d8  bl       #0x24470   ; call __Unwind_Resume
0x000181dc  sub      sp, sp, #0xa0
0x000181e0  stp      d13, d12, [sp, #0x20]
0x000181e4  stp      d11, d10, [sp, #0x30]
0x000181e8  stp      d9, d8, [sp, #0x40]
0x000181ec  stp      x26, x25, [sp, #0x50]
0x000181f0  stp      x24, x23, [sp, #0x60]
0x000181f4  stp      x22, x21, [sp, #0x70]
0x000181f8  stp      x20, x19, [sp, #0x80]
0x000181fc  stp      x29, x30, [sp, #0x90]
0x00018200  add      x29, sp, #0x90
0x00018204  mov      x20, x2
0x00018208  mov      x19, x0
0x0001820c  adrp     x8, #0x34000
0x00018210  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00018214  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00018218  str      x8, [sp, #0x18]
0x0001821c  bl       #0x25fe0   ; objc_msgSend: lit
0x00018220  cbz      w0, #0x184ec
0x00018224  mov      x0, x19
0x00018228  bl       #0x24a60   ; objc_msgSend: accent
0x0001822c  mov      x29, x29
0x00018230  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018234  mov      x21, x0
0x00018238  bl       #0x2480c   ; call _objc_release
0x0001823c  cbnz     x21, #0x184ec
0x00018240  adrp     x8, #0x3e000
0x00018244  ldr      x0, [x8, #0x3a8]   ; -> [class(CAGradientLayer)]
0x00018248  bl       #0x25f00   ; objc_msgSend: layer
0x0001824c  mov      x29, x29
0x00018250  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018254  mov      x21, x0
0x00018258  mov      x0, x19
0x0001825c  mov      x2, x21
0x00018260  bl       #0x26ae0   ; objc_msgSend: setAccent:
0x00018264  mov      x0, x21
0x00018268  bl       #0x2480c   ; call _objc_release
0x0001826c  adrp     x25, #0x3e000
0x00018270  ldr      x0, [x25, #0x320]   ; -> [class(UIColor)]
0x00018274  adrp     x8, #0x2b000
0x00018278  ldr      d8, [x8, #0x288]
0x0001827c  adrp     x8, #0x2b000
0x00018280  ldr      d9, [x8, #0x290]
0x00018284  adrp     x8, #0x2b000
0x00018288  ldr      d10, [x8, #0x298]
0x0001828c  fmov     d3, #1.00000000
0x00018290  mov      v0.16b, v8.16b
0x00018294  mov      v1.16b, v9.16b
0x00018298  mov      v2.16b, v10.16b
0x0001829c  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x000182a0  mov      x29, x29
0x000182a4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000182a8  mov      x21, x0
0x000182ac  bl       #0x24824   ; call _objc_retainAutorelease
0x000182b0  bl       #0x249e0   ; objc_msgSend: CGColor
0x000182b4  str      x0, [sp, #8]
0x000182b8  ldr      x0, [x25, #0x320]   ; -> [class(UIColor)]
0x000182bc  adrp     x8, #0x2b000
0x000182c0  ldr      d0, [x8, #0x2a0]
0x000182c4  adrp     x8, #0x2b000
0x000182c8  ldr      d1, [x8, #0x2a8]
0x000182cc  adrp     x8, #0x2b000
0x000182d0  ldr      d2, [x8, #0x2b0]
0x000182d4  fmov     d3, #1.00000000
0x000182d8  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x000182dc  mov      x29, x29
0x000182e0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000182e4  mov      x22, x0
0x000182e8  bl       #0x24824   ; call _objc_retainAutorelease
0x000182ec  bl       #0x249e0   ; objc_msgSend: CGColor
0x000182f0  str      x0, [sp, #0x10]
0x000182f4  adrp     x8, #0x3e000
0x000182f8  ldr      x0, [x8, #0x2a8]   ; -> [class(NSArray)]
0x000182fc  add      x2, sp, #8
0x00018300  mov      w3, #2
0x00018304  bl       #0x24e20   ; objc_msgSend: arrayWithObjects:count:
0x00018308  mov      x29, x29
0x0001830c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018310  mov      x23, x0
0x00018314  mov      x0, x19
0x00018318  bl       #0x24a60   ; objc_msgSend: accent
0x0001831c  mov      x29, x29
0x00018320  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018324  mov      x24, x0
0x00018328  mov      x2, x23
0x0001832c  bl       #0x26da0   ; objc_msgSend: setColors:
0x00018330  mov      x0, x24
0x00018334  bl       #0x2480c   ; call _objc_release
0x00018338  mov      x0, x23
0x0001833c  bl       #0x2480c   ; call _objc_release
0x00018340  mov      x0, x22
0x00018344  bl       #0x2480c   ; call _objc_release
0x00018348  mov      x0, x21
0x0001834c  bl       #0x2480c   ; call _objc_release
0x00018350  adrp     x8, #0x34000
0x00018354  ldr      x8, [x8, #0x508]   ; -> [got:_CGPointZero]
0x00018358  ldp      d11, d12, [x8]
0x0001835c  mov      x0, x19
0x00018360  bl       #0x24a60   ; objc_msgSend: accent
0x00018364  mov      x29, x29
0x00018368  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001836c  mov      x21, x0
0x00018370  mov      v0.16b, v11.16b
0x00018374  mov      v1.16b, v12.16b
0x00018378  bl       #0x27840   ; objc_msgSend: setStartPoint:
0x0001837c  mov      x0, x21
0x00018380  bl       #0x2480c   ; call _objc_release
0x00018384  mov      x0, x19
0x00018388  bl       #0x24a60   ; objc_msgSend: accent
0x0001838c  mov      x29, x29
0x00018390  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018394  mov      x21, x0
0x00018398  fmov     d0, #1.00000000
0x0001839c  fmov     d1, #1.00000000
0x000183a0  bl       #0x26ee0   ; objc_msgSend: setEndPoint:
0x000183a4  mov      x0, x21
0x000183a8  bl       #0x2480c   ; call _objc_release
0x000183ac  mov      x0, x19
0x000183b0  bl       #0x24a60   ; objc_msgSend: accent
0x000183b4  mov      x29, x29
0x000183b8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000183bc  mov      x21, x0
0x000183c0  fmov     d0, #7.00000000
0x000183c4  bl       #0x26e20   ; objc_msgSend: setCornerRadius:
0x000183c8  mov      x0, x21
0x000183cc  bl       #0x2480c   ; call _objc_release
0x000183d0  mov      x0, x19
0x000183d4  bl       #0x25f00   ; objc_msgSend: layer
0x000183d8  mov      x29, x29
0x000183dc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000183e0  mov      x21, x0
0x000183e4  mov      x0, x19
0x000183e8  bl       #0x24a60   ; objc_msgSend: accent
0x000183ec  mov      x29, x29
0x000183f0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000183f4  mov      x22, x0
0x000183f8  mov      x0, x21
0x000183fc  mov      x2, x22
0x00018400  mov      w3, #0
0x00018404  bl       #0x25b20   ; objc_msgSend: insertSublayer:atIndex:
0x00018408  mov      x0, x22
0x0001840c  bl       #0x2480c   ; call _objc_release
0x00018410  mov      x0, x21
0x00018414  bl       #0x2480c   ; call _objc_release
0x00018418  ldr      x0, [x25, #0x320]   ; -> [class(UIColor)]
0x0001841c  fmov     d3, #1.00000000
0x00018420  mov      v0.16b, v8.16b
0x00018424  mov      v1.16b, v9.16b
0x00018428  mov      v2.16b, v10.16b
0x0001842c  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x00018430  mov      x29, x29
0x00018434  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018438  mov      x21, x0
0x0001843c  bl       #0x24824   ; call _objc_retainAutorelease
0x00018440  mov      x0, x21
0x00018444  bl       #0x249e0   ; objc_msgSend: CGColor
0x00018448  mov      x23, x0
0x0001844c  mov      x0, x19
0x00018450  bl       #0x25f00   ; objc_msgSend: layer
0x00018454  mov      x29, x29
0x00018458  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001845c  mov      x22, x0
0x00018460  mov      x2, x23
0x00018464  bl       #0x276e0   ; objc_msgSend: setShadowColor:
0x00018468  mov      x0, x22
0x0001846c  bl       #0x2480c   ; call _objc_release
0x00018470  mov      x0, x21
0x00018474  bl       #0x2480c   ; call _objc_release
0x00018478  mov      x0, x19
0x0001847c  bl       #0x25f00   ; objc_msgSend: layer
0x00018480  mov      x29, x29
0x00018484  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018488  mov      x21, x0
0x0001848c  adrp     x8, #0x2b000
0x00018490  ldr      s0, [x8, #0x3f8]
0x00018494  bl       #0x27720   ; objc_msgSend: setShadowOpacity:
0x00018498  mov      x0, x21
0x0001849c  bl       #0x2480c   ; call _objc_release
0x000184a0  mov      x0, x19
0x000184a4  bl       #0x25f00   ; objc_msgSend: layer
0x000184a8  mov      x29, x29
0x000184ac  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000184b0  mov      x21, x0
0x000184b4  fmov     d0, #6.00000000
0x000184b8  bl       #0x27760   ; objc_msgSend: setShadowRadius:
0x000184bc  mov      x0, x21
0x000184c0  bl       #0x2480c   ; call _objc_release
0x000184c4  mov      x0, x19
0x000184c8  bl       #0x25f00   ; objc_msgSend: layer
0x000184cc  mov      x29, x29
0x000184d0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000184d4  mov      x21, x0
0x000184d8  fmov     d0, xzr
0x000184dc  fmov     d1, #3.00000000
0x000184e0  bl       #0x27700   ; objc_msgSend: setShadowOffset:
0x000184e4  mov      x0, x21
0x000184e8  bl       #0x2480c   ; call _objc_release
0x000184ec  cmp      w20, #0
0x000184f0  adrp     x8, #0x2b000
0x000184f4  ldr      s0, [x8, #0x3fc]
0x000184f8  fmov     s1, #1.00000000
0x000184fc  fcsel    s8, s0, s1, ne
0x00018500  mov      x0, x19
0x00018504  bl       #0x24a60   ; objc_msgSend: accent
0x00018508  mov      x29, x29
0x0001850c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018510  mov      x21, x0
0x00018514  mov      v0.16b, v8.16b
0x00018518  bl       #0x27420   ; objc_msgSend: setOpacity:
0x0001851c  mov      x0, x21
0x00018520  bl       #0x2480c   ; call _objc_release
0x00018524  mov      x0, x19
0x00018528  bl       #0x25fe0   ; objc_msgSend: lit
0x0001852c  mov      x21, x0
0x00018530  cbz      w0, #0x18558
0x00018534  adrp     x8, #0x3e000
0x00018538  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x0001853c  bl       #0x251a0   ; objc_msgSend: clearColor
0x00018540  mov      x29, x29
0x00018544  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018548  mov      x20, x0
0x0001854c  mov      w22, #0
0x00018550  mov      w23, #0
0x00018554  b        #0x185ac   ; call sub_185ac
0x00018558  cbz      w20, #0x18590
0x0001855c  adrp     x8, #0x3e000
0x00018560  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x00018564  fmov     d0, #1.00000000
0x00018568  fmov     d1, #1.00000000
0x0001856c  fmov     d2, #1.00000000
0x00018570  fmov     d3, #1.00000000
0x00018574  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x00018578  mov      x29, x29
0x0001857c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018580  mov      x20, x0
0x00018584  mov      w23, #0
0x00018588  mov      w22, #1
0x0001858c  b        #0x185ac   ; call sub_185ac
0x00018590  mov      x0, x19
0x00018594  bl       #0x26920   ; objc_msgSend: restColor
0x00018598  mov      x29, x29
0x0001859c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000185a0  mov      x20, x0
0x000185a4  mov      w22, #0
0x000185a8  mov      w23, #1
0x000185ac  mov      x0, x19
0x000185b0  mov      x2, x20
0x000185b4  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x000185b8  cbz      w23, #0x185c4
0x000185bc  mov      x0, x20
0x000185c0  bl       #0x2480c   ; call _objc_release
0x000185c4  cbz      w22, #0x185d0
0x000185c8  mov      x0, x20
0x000185cc  bl       #0x2480c   ; call _objc_release
0x000185d0  cbz      w21, #0x185dc
0x000185d4  mov      x0, x20
0x000185d8  bl       #0x2480c   ; call _objc_release
0x000185dc  mov      x0, x19
0x000185e0  bl       #0x25fe0   ; objc_msgSend: lit
0x000185e4  mov      x20, x0
0x000185e8  cbz      w0, #0x18604
0x000185ec  adrp     x8, #0x3e000
0x000185f0  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x000185f4  bl       #0x281c0   ; objc_msgSend: whiteColor
0x000185f8  mov      x29, x29
0x000185fc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018600  b        #0x18614   ; call sub_18614
0x00018604  mov      x0, x19
0x00018608  bl       #0x26940   ; objc_msgSend: restTint
0x0001860c  mov      x29, x29
0x00018610  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018614  mov      x21, x0
0x00018618  mov      x0, x19
0x0001861c  mov      x2, x21
0x00018620  bl       #0x27940   ; objc_msgSend: setTintColor:
0x00018624  mov      x0, x21
0x00018628  bl       #0x2480c   ; call _objc_release
0x0001862c  ldr      x8, [sp, #0x18]
0x00018630  adrp     x9, #0x34000
0x00018634  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00018638  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0001863c  cmp      x9, x8
0x00018640  b.ne     #0x1866c
0x00018644  ldp      x29, x30, [sp, #0x90]
0x00018648  ldp      x20, x19, [sp, #0x80]
0x0001864c  ldp      x22, x21, [sp, #0x70]
0x00018650  ldp      x24, x23, [sp, #0x60]
0x00018654  ldp      x26, x25, [sp, #0x50]
0x00018658  ldp      d9, d8, [sp, #0x40]
0x0001865c  ldp      d11, d10, [sp, #0x30]
0x00018660  ldp      d13, d12, [sp, #0x20]
0x00018664  add      sp, sp, #0xa0
0x00018668  ret      
0x0001866c  bl       #0x24488   ; call ___stack_chk_fail
0x00018670  mov      x19, x0
0x00018674  mov      x0, x21
0x00018678  bl       #0x2480c   ; call _objc_release
0x0001867c  b        #0x187cc   ; call sub_187cc
0x00018680  mov      x19, x0
0x00018684  mov      x0, x21
0x00018688  bl       #0x2480c   ; call _objc_release
0x0001868c  b        #0x187cc   ; call sub_187cc
0x00018690  mov      x19, x0
0x00018694  mov      x0, x21
0x00018698  bl       #0x2480c   ; call _objc_release
0x0001869c  b        #0x187cc   ; call sub_187cc
0x000186a0  mov      x19, x0
0x000186a4  mov      x0, x22
0x000186a8  bl       #0x2480c   ; call _objc_release
0x000186ac  b        #0x18734   ; call sub_18734
0x000186b0  mov      x19, x0
0x000186b4  mov      x0, x22
0x000186b8  bl       #0x2480c   ; call _objc_release
0x000186bc  b        #0x186c4   ; call sub_186c4
0x000186c0  mov      x19, x0
0x000186c4  mov      x0, x21
0x000186c8  bl       #0x2480c   ; call _objc_release
0x000186cc  b        #0x187cc   ; call sub_187cc
0x000186d0  mov      x19, x0
0x000186d4  mov      x0, x21
0x000186d8  bl       #0x2480c   ; call _objc_release
0x000186dc  b        #0x187cc   ; call sub_187cc
0x000186e0  mov      x19, x0
0x000186e4  mov      x0, x21
0x000186e8  bl       #0x2480c   ; call _objc_release
0x000186ec  b        #0x187cc   ; call sub_187cc
0x000186f0  mov      x19, x0
0x000186f4  mov      x0, x21
0x000186f8  bl       #0x2480c   ; call _objc_release
0x000186fc  b        #0x187cc   ; call sub_187cc
0x00018700  mov      x19, x0
0x00018704  mov      x0, x24
0x00018708  bl       #0x2480c   ; call _objc_release
0x0001870c  b        #0x18714   ; call sub_18714
0x00018710  mov      x19, x0
0x00018714  mov      x0, x23
0x00018718  bl       #0x2480c   ; call _objc_release
0x0001871c  b        #0x18744   ; call sub_18744
0x00018720  mov      x19, x0
0x00018724  mov      x0, x21
0x00018728  bl       #0x2480c   ; call _objc_release
0x0001872c  b        #0x187cc   ; call sub_187cc
0x00018730  mov      x19, x0
0x00018734  mov      x0, x21
0x00018738  bl       #0x2480c   ; call _objc_release
0x0001873c  b        #0x187cc   ; call sub_187cc
0x00018740  mov      x19, x0
0x00018744  mov      x0, x22
0x00018748  bl       #0x2480c   ; call _objc_release
0x0001874c  b        #0x18754   ; call sub_18754
0x00018750  mov      x19, x0
0x00018754  mov      x0, x21
0x00018758  bl       #0x2480c   ; call _objc_release
0x0001875c  b        #0x187cc   ; call sub_187cc
0x00018760  mov      x19, x0
0x00018764  tbz      w20, #0, #0x18774
0x00018768  mov      x0, x21
0x0001876c  bl       #0x2480c   ; call _objc_release
0x00018770  b        #0x187cc   ; call sub_187cc
0x00018774  mov      x0, x21
0x00018778  bl       #0x2480c   ; call _objc_release
0x0001877c  b        #0x187cc   ; call sub_187cc
0x00018780  mov      x19, x0
0x00018784  cbz      w23, #0x1879c
0x00018788  mov      x0, x20
0x0001878c  bl       #0x2480c   ; call _objc_release
0x00018790  tbnz     w22, #0, #0x187a0
0x00018794  cbnz     w21, #0x187ac
0x00018798  b        #0x187cc   ; call sub_187cc
0x0001879c  cbz      w22, #0x18794
0x000187a0  mov      x0, x20
0x000187a4  bl       #0x2480c   ; call _objc_release
0x000187a8  tbz      w21, #0, #0x187cc
0x000187ac  mov      x0, x20
0x000187b0  bl       #0x2480c   ; call _objc_release
0x000187b4  b        #0x187cc   ; call sub_187cc
0x000187b8  mov      x19, x0
0x000187bc  mov      x0, x21
0x000187c0  bl       #0x2480c   ; call _objc_release
0x000187c4  b        #0x187cc   ; call sub_187cc
0x000187c8  mov      x19, x0
0x000187cc  mov      x0, x19
0x000187d0  bl       #0x24470   ; call __Unwind_Resume
0x000187d4  sub      sp, sp, #0x70
0x000187d8  stp      x22, x21, [sp, #0x40]
0x000187dc  stp      x20, x19, [sp, #0x50]
0x000187e0  stp      x29, x30, [sp, #0x60]
0x000187e4  add      x29, sp, #0x60
0x000187e8  mov      x19, x2
0x000187ec  mov      x20, x0
0x000187f0  bl       #0x25d20   ; objc_msgSend: isHighlighted
0x000187f4  cmp      w19, w0
0x000187f8  b.eq     #0x18910
0x000187fc  adrp     x8, #0x3e000
0x00018800  ldr      x8, [x8, #0x470]
0x00018804  stp      x20, x8, [sp, #0x30]
0x00018808  adrp     x8, #0x3d000
0x0001880c  ldr      x1, [x8, #0x260]   ; -> [@selector(setHighlighted:)]
0x00018810  add      x0, sp, #0x30
0x00018814  mov      x2, x19
0x00018818  bl       #0x247c4   ; call _objc_msgSendSuper2
0x0001881c  mov      x0, x20
0x00018820  mov      x2, x19
0x00018824  bl       #0x26500   ; objc_msgSend: paint:
0x00018828  adrp     x8, #0x3e000
0x0001882c  ldr      x0, [x8, #0x2d0]   ; -> [class(UIView)]
0x00018830  cmp      w19, #0
0x00018834  adrp     x8, #0x2b000
0x00018838  ldr      d0, [x8, #0x1f0]
0x0001883c  adrp     x8, #0x2b000
0x00018840  ldr      d1, [x8, #0x398]
0x00018844  fcsel    d0, d1, d0, ne
0x00018848  adrp     x8, #0x2b000
0x0001884c  ldr      d1, [x8, #0x210]
0x00018850  fmov     d2, #1.00000000
0x00018854  fcsel    d2, d2, d1, ne
0x00018858  adrp     x8, #0x34000
0x0001885c  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x00018860  str      x8, [sp]
0x00018864  adrp     x8, #0x2b000
0x00018868  ldr      d1, [x8, #0x1d0]
0x0001886c  str      d1, [sp, #8]
0x00018870  adrp     x8, #0x18000
0x00018874  add      x8, x8, #0x94c
0x00018878  adrp     x9, #0x34000
0x0001887c  add      x9, x9, #0x810
0x00018880  stp      x8, x9, [sp, #0x10]
0x00018884  str      x20, [sp, #0x20]
0x00018888  strb     w19, [sp, #0x28]
0x0001888c  fmov     d1, xzr
0x00018890  fmov     d3, xzr
0x00018894  mov      x3, sp
0x00018898  mov      w2, #6
0x0001889c  mov      x4, #0
0x000188a0  bl       #0x24ca0   ; objc_msgSend: animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
0x000188a4  mov      x0, x20
0x000188a8  bl       #0x25260   ; objc_msgSend: command
0x000188ac  mov      x29, x29
0x000188b0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000188b4  mov      x21, x0
0x000188b8  cbnz     x0, #0x18908
0x000188bc  mov      x0, x20
0x000188c0  bl       #0x280e0   ; objc_msgSend: value
0x000188c4  mov      x29, x29
0x000188c8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000188cc  mov      x21, x0
0x000188d0  bl       #0x25fa0   ; objc_msgSend: length
0x000188d4  mov      x22, x0
0x000188d8  mov      x0, x21
0x000188dc  bl       #0x2480c   ; call _objc_release
0x000188e0  cbz      x22, #0x18910
0x000188e4  adrp     x8, #0x3e000
0x000188e8  ldr      x0, [x8, #0x2e8]   ; -> [class(ABKeyboard)]
0x000188ec  bl       #0x27b20   ; objc_msgSend: shared
0x000188f0  mov      x29, x29
0x000188f4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000188f8  mov      x21, x0
0x000188fc  mov      x2, x20
0x00018900  mov      x3, x19
0x00018904  bl       #0x25da0   ; objc_msgSend: key:pressed:
0x00018908  mov      x0, x21
0x0001890c  bl       #0x2480c   ; call _objc_release
0x00018910  ldp      x29, x30, [sp, #0x60]
0x00018914  ldp      x20, x19, [sp, #0x50]
0x00018918  ldp      x22, x21, [sp, #0x40]
0x0001891c  add      sp, sp, #0x70
0x00018920  ret      
0x00018924  b        #0x18928   ; call sub_18928
0x00018928  mov      x19, x0
0x0001892c  mov      x0, x21
0x00018930  bl       #0x2480c   ; call _objc_release
0x00018934  b        #0x18944   ; call sub_18944
0x00018938  b        #0x18940   ; call sub_18940
0x0001893c  b        #0x18940   ; call sub_18940
0x00018940  mov      x19, x0
0x00018944  mov      x0, x19
0x00018948  bl       #0x24470   ; call __Unwind_Resume
0x0001894c  sub      sp, sp, #0x80
0x00018950  stp      x20, x19, [sp, #0x60]
0x00018954  stp      x29, x30, [sp, #0x70]
0x00018958  add      x29, sp, #0x70
0x0001895c  mov      x19, x0
0x00018960  ldrb     w8, [x0, #0x28]
0x00018964  cmp      w8, #1
0x00018968  b.ne     #0x18984
0x0001896c  adrp     x8, #0x2b000
0x00018970  ldr      d0, [x8, #0x3a0]
0x00018974  add      x8, sp, #0x30
0x00018978  mov      v1.16b, v0.16b
0x0001897c  bl       #0x242e4   ; call _CGAffineTransformMakeScale
0x00018980  b        #0x1899c   ; call sub_1899c
0x00018984  adrp     x8, #0x34000
0x00018988  ldr      x8, [x8, #0x4b0]   ; -> [got:_CGAffineTransformIdentity]
0x0001898c  ldp      q0, q1, [x8]
0x00018990  stp      q0, q1, [sp, #0x30]
0x00018994  ldr      q0, [x8, #0x20]   ; -> [got:_class_getClassMethod]
0x00018998  str      q0, [sp, #0x50]
0x0001899c  ldp      q0, q1, [sp, #0x30]
0x000189a0  stp      q0, q1, [sp]
0x000189a4  ldr      q0, [sp, #0x50]
0x000189a8  str      q0, [sp, #0x20]
0x000189ac  ldr      x0, [x19, #0x20]
0x000189b0  mov      x2, sp
0x000189b4  bl       #0x279a0   ; objc_msgSend: setTransform:
0x000189b8  ldp      x29, x30, [sp, #0x70]
0x000189bc  ldp      x20, x19, [sp, #0x60]
0x000189c0  add      sp, sp, #0x80
0x000189c4  ret      
0x000189c8  sub      sp, sp, #0x60
0x000189cc  stp      d11, d10, [sp, #0x10]
0x000189d0  stp      d9, d8, [sp, #0x20]
0x000189d4  stp      x22, x21, [sp, #0x30]
0x000189d8  stp      x20, x19, [sp, #0x40]
0x000189dc  stp      x29, x30, [sp, #0x50]
0x000189e0  add      x29, sp, #0x50
0x000189e4  mov      x19, x0
0x000189e8  adrp     x8, #0x3e000
0x000189ec  ldr      x8, [x8, #0x470]
0x000189f0  stp      x0, x8, [sp]
0x000189f4  adrp     x8, #0x3d000
0x000189f8  ldr      x1, [x8, #0x258]   ; -> [@selector(layoutSubviews)]
0x000189fc  mov      x0, sp
0x00018a00  bl       #0x247c4   ; call _objc_msgSendSuper2
0x00018a04  adrp     x21, #0x3e000
0x00018a08  ldr      x0, [x21, #0x308]   ; -> [class(CATransaction)]
0x00018a0c  bl       #0x24e80   ; objc_msgSend: begin
0x00018a10  ldr      x0, [x21, #0x308]   ; -> [class(CATransaction)]
0x00018a14  mov      w2, #1
0x00018a18  bl       #0x26e80   ; objc_msgSend: setDisableActions:
0x00018a1c  mov      x0, x19
0x00018a20  bl       #0x24f40   ; objc_msgSend: bounds
0x00018a24  mov      v8.16b, v0.16b
0x00018a28  mov      v9.16b, v1.16b
0x00018a2c  mov      v10.16b, v2.16b
0x00018a30  mov      v11.16b, v3.16b
0x00018a34  mov      x0, x19
0x00018a38  bl       #0x24a60   ; objc_msgSend: accent
0x00018a3c  mov      x29, x29
0x00018a40  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018a44  mov      x20, x0
0x00018a48  mov      v0.16b, v8.16b
0x00018a4c  mov      v1.16b, v9.16b
0x00018a50  mov      v2.16b, v10.16b
0x00018a54  mov      v3.16b, v11.16b
0x00018a58  bl       #0x26f80   ; objc_msgSend: setFrame:
0x00018a5c  mov      x0, x20
0x00018a60  bl       #0x2480c   ; call _objc_release
0x00018a64  ldr      x0, [x21, #0x308]   ; -> [class(CATransaction)]
0x00018a68  bl       #0x25280   ; objc_msgSend: commit
0x00018a6c  mov      x0, x19
0x00018a70  bl       #0x25920   ; objc_msgSend: hint
0x00018a74  mov      x29, x29
0x00018a78  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018a7c  mov      x20, x0
0x00018a80  bl       #0x2480c   ; call _objc_release
0x00018a84  cbz      x20, #0x18ac8
0x00018a88  mov      x0, x19
0x00018a8c  bl       #0x24f40   ; objc_msgSend: bounds
0x00018a90  fmov     d0, #-13.00000000
0x00018a94  fadd     d8, d2, d0
0x00018a98  mov      x0, x19
0x00018a9c  bl       #0x25920   ; objc_msgSend: hint
0x00018aa0  mov      x29, x29
0x00018aa4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018aa8  mov      x20, x0
0x00018aac  fmov     d1, xzr
0x00018ab0  fmov     d2, #11.00000000
0x00018ab4  fmov     d3, #11.00000000
0x00018ab8  mov      v0.16b, v8.16b
0x00018abc  bl       #0x26f80   ; objc_msgSend: setFrame:
0x00018ac0  mov      x0, x20
0x00018ac4  bl       #0x2480c   ; call _objc_release
0x00018ac8  ldp      x29, x30, [sp, #0x50]
0x00018acc  ldp      x20, x19, [sp, #0x40]
0x00018ad0  ldp      x22, x21, [sp, #0x30]
0x00018ad4  ldp      d9, d8, [sp, #0x20]
0x00018ad8  ldp      d11, d10, [sp, #0x10]
0x00018adc  add      sp, sp, #0x60
0x00018ae0  ret      
0x00018ae4  b        #0x18ae8   ; call sub_18ae8
0x00018ae8  mov      x19, x0
0x00018aec  mov      x0, x20
0x00018af0  bl       #0x2480c   ; call _objc_release
0x00018af4  mov      x0, x19
0x00018af8  bl       #0x24470   ; call __Unwind_Resume
0x00018afc  adrp     x8, #0x3e000
0x00018b00  ldrsw    x8, [x8, #0x4f0]
0x00018b04  ldr      x0, [x0, x8]
0x00018b08  ret      
0x00018b0c  adrp     x8, #0x3e000
0x00018b10  ldrsw    x3, [x8, #0x4f0]
0x00018b14  b        #0x24854   ; call _objc_setProperty_nonatomic_copy
0x00018b18  adrp     x8, #0x3e000
0x00018b1c  ldrsw    x8, [x8, #0x4f4]
0x00018b20  ldr      x0, [x0, x8]
0x00018b24  ret      
0x00018b28  adrp     x8, #0x3e000
0x00018b2c  ldrsw    x3, [x8, #0x4f4]
0x00018b30  b        #0x24854   ; call _objc_setProperty_nonatomic_copy
0x00018b34  adrp     x8, #0x3e000
0x00018b38  ldrsw    x8, [x8, #0x4f8]
0x00018b3c  ldr      d0, [x0, x8]
0x00018b40  ret      
0x00018b44  adrp     x8, #0x3e000
0x00018b48  ldrsw    x8, [x8, #0x4f8]
0x00018b4c  str      d0, [x0, x8]
0x00018b50  ret      
0x00018b54  adrp     x8, #0x3e000
0x00018b58  ldrsw    x8, [x8, #0x4fc]
0x00018b5c  ldrb     w0, [x0, x8]
0x00018b60  ret      
0x00018b64  adrp     x8, #0x3e000
0x00018b68  ldrsw    x8, [x8, #0x4fc]
0x00018b6c  strb     w2, [x0, x8]
0x00018b70  ret      
0x00018b74  adrp     x8, #0x3e000
0x00018b78  ldrsw    x8, [x8, #0x500]
0x00018b7c  ldr      x0, [x0, x8]
0x00018b80  ret      
0x00018b84  stp      x22, x21, [sp, #-0x30]!
0x00018b88  stp      x20, x19, [sp, #0x10]
0x00018b8c  stp      x29, x30, [sp, #0x20]
0x00018b90  add      x29, sp, #0x20
0x00018b94  mov      x19, x2
0x00018b98  mov      x20, x0
0x00018b9c  adrp     x8, #0x3e000
0x00018ba0  ldrsw    x21, [x8, #0x500]
0x00018ba4  mov      x0, x2
0x00018ba8  bl       #0x24818   ; call _objc_retain
0x00018bac  ldr      x0, [x20, x21]
0x00018bb0  str      x19, [x20, x21]
0x00018bb4  ldp      x29, x30, [sp, #0x20]
0x00018bb8  ldp      x20, x19, [sp, #0x10]
0x00018bbc  ldp      x22, x21, [sp], #0x30
0x00018bc0  b        #0x2480c   ; call _objc_release
0x00018bc4  adrp     x8, #0x3e000
0x00018bc8  ldrsw    x8, [x8, #0x504]
0x00018bcc  ldr      x0, [x0, x8]
0x00018bd0  ret      
0x00018bd4  stp      x22, x21, [sp, #-0x30]!
0x00018bd8  stp      x20, x19, [sp, #0x10]
0x00018bdc  stp      x29, x30, [sp, #0x20]
0x00018be0  add      x29, sp, #0x20
0x00018be4  mov      x19, x2
0x00018be8  mov      x20, x0
0x00018bec  adrp     x8, #0x3e000
0x00018bf0  ldrsw    x21, [x8, #0x504]
0x00018bf4  mov      x0, x2
0x00018bf8  bl       #0x24818   ; call _objc_retain
0x00018bfc  ldr      x0, [x20, x21]
0x00018c00  str      x19, [x20, x21]
0x00018c04  ldp      x29, x30, [sp, #0x20]
0x00018c08  ldp      x20, x19, [sp, #0x10]
0x00018c0c  ldp      x22, x21, [sp], #0x30
0x00018c10  b        #0x2480c   ; call _objc_release
0x00018c14  adrp     x8, #0x3e000
0x00018c18  ldrsw    x8, [x8, #0x508]
0x00018c1c  ldr      x0, [x0, x8]
0x00018c20  ret      
0x00018c24  stp      x22, x21, [sp, #-0x30]!
0x00018c28  stp      x20, x19, [sp, #0x10]
0x00018c2c  stp      x29, x30, [sp, #0x20]
0x00018c30  add      x29, sp, #0x20
0x00018c34  mov      x19, x2
0x00018c38  mov      x20, x0
0x00018c3c  adrp     x8, #0x3e000
0x00018c40  ldrsw    x21, [x8, #0x508]
0x00018c44  mov      x0, x2
0x00018c48  bl       #0x24818   ; call _objc_retain
0x00018c4c  ldr      x0, [x20, x21]
0x00018c50  str      x19, [x20, x21]
0x00018c54  ldp      x29, x30, [sp, #0x20]
0x00018c58  ldp      x20, x19, [sp, #0x10]
0x00018c5c  ldp      x22, x21, [sp], #0x30
0x00018c60  b        #0x2480c   ; call _objc_release
0x00018c64  adrp     x8, #0x3e000
0x00018c68  ldrsw    x8, [x8, #0x50c]
0x00018c6c  ldr      x0, [x0, x8]
0x00018c70  ret      
0x00018c74  stp      x22, x21, [sp, #-0x30]!
0x00018c78  stp      x20, x19, [sp, #0x10]
