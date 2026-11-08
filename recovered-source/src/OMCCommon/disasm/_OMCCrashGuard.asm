; === _OMCCrashGuard @ 0x7de8 size=4500 ===
0x00007de8  stp      x28, x27, [sp, #-0x60]!
0x00007dec  stp      x26, x25, [sp, #0x10]
0x00007df0  stp      x24, x23, [sp, #0x20]
0x00007df4  stp      x22, x21, [sp, #0x30]
0x00007df8  stp      x20, x19, [sp, #0x40]
0x00007dfc  stp      x29, x30, [sp, #0x50]
0x00007e00  add      x29, sp, #0x50
0x00007e04  sub      sp, sp, #0x480
0x00007e08  mov      x26, x0
0x00007e0c  adrp     x8, #0x14000
0x00007e10  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x00007e14  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x00007e18  stur     x8, [x29, #-0x60]
0x00007e1c  bl       #0xd4c4 ; call stub:_objc_retain
0x00007e20  adrp     x8, #0x18000
0x00007e24  ldr      x8, [x8, #0x5e8] ; -> [__DATA,__bss+0xe8]
0x00007e28  cmn      x8, #1
0x00007e2c  b.ne     #0x8f70
0x00007e30  adrp     x8, #0x18000
0x00007e34  ldrb     w8, [x8, #0x5e0]
0x00007e38  cmp      w8, #1
0x00007e3c  b.ne     #0x7f48
0x00007e40  mov      x0, x26
0x00007e44  bl       #0xdce0 ; call objc_stub[length]
0x00007e48  cbz      x0, #0x7f48
0x00007e4c  bl       #0x8f7c ; call sub_8f7c
0x00007e50  adrp     x20, #0x18000
0x00007e54  adrp     x22, #0x18000
0x00007e58  cbnz     x0, #0x8c1c
0x00007e5c  mov      w0, #1
0x00007e60  mov      w1, #0x448
0x00007e64  bl       #0xd20c ; call stub:_calloc
0x00007e68  adrp     x22, #0x18000
0x00007e6c  str      x0, [x22, #0x5f0]
0x00007e70  mov      x0, #0
0x00007e74  bl       #0xd608 ; call stub:_time
0x00007e78  ldr      x8, [x22, #0x5f0] ; -> [__DATA,__bss+0xf0]
0x00007e7c  str      x0, [x8, #0x440]
0x00007e80  str      x8, [sp]
0x00007e84  adrp     x2, #0xf000
0x00007e88  add      x2, x2, #0x310 ; -> "%llx"
0x00007e8c  add      x0, sp, #0x2d0
0x00007e90  mov      w1, #0x20
0x00007e94  bl       #0xd578 ; call stub:_snprintf
0x00007e98  adrp     x0, #0xf000
0x00007e9c  add      x0, x0, #0x301 ; -> "OMC_CRASHGUARD"
0x00007ea0  add      x1, sp, #0x2d0
0x00007ea4  mov      w2, #1
0x00007ea8  bl       #0xd554 ; call stub:_setenv
0x00007eac  bl       #0xd194 ; call stub:_NSTemporaryDirectory
0x00007eb0  mov      x29, x29
0x00007eb4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007eb8  mov      x19, x0
0x00007ebc  adrp     x2, #0x15000
0x00007ec0  add      x2, x2, #0xd88 ; -> CFSTR("OmniCar-CarPlay-crash.txt")
0x00007ec4  bl       #0xe380 ; call objc_stub[stringByAppendingPathComponent:]
0x00007ec8  mov      x29, x29
0x00007ecc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007ed0  mov      x21, x0
0x00007ed4  mov      x0, x19
0x00007ed8  bl       #0xd4b8 ; call stub:_objc_release
0x00007edc  ldr      x19, [x22, #0x5f0] ; -> [__DATA,__bss+0xf0]
0x00007ee0  mov      x0, x21
0x00007ee4  bl       #0xd4d0 ; call stub:_objc_retainAutorelease
0x00007ee8  str      x21, [sp, #0x48]
0x00007eec  bl       #0xdb60 ; call objc_stub[fileSystemRepresentation]
0x00007ef0  mov      x1, x0
0x00007ef4  mov      x0, x19
0x00007ef8  mov      w2, #0x400
0x00007efc  mov      w3, #0x400
0x00007f00  bl       #0xd1c4 ; call stub:___strlcpy_chk
0x00007f04  mov      x21, x20
0x00007f08  ldr      x20, [x20, #0x470] ; -> [classref(NSMutableDictionary)]
0x00007f0c  bl       #0x8fc0 ; call sub_8fc0
0x00007f10  mov      x29, x29
0x00007f14  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007f18  mov      x19, x0
0x00007f1c  mov      x0, x20
0x00007f20  mov      x2, x19
0x00007f24  bl       #0xdaa0 ; call objc_stub[dictionaryWithContentsOfFile:]
0x00007f28  mov      x29, x29
0x00007f2c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007f30  mov      x20, x0
0x00007f34  cbz      x0, #0x7f50
0x00007f38  mov      x0, x20
0x00007f3c  bl       #0xd4c4 ; call stub:_objc_retain
0x00007f40  mov      x21, x20
0x00007f44  b        #0x7f64
0x00007f48  mov      w22, #1
0x00007f4c  b        #0x8eac
0x00007f50  ldr      x0, [x21, #0x470]
0x00007f54  bl       #0xda80 ; call objc_stub[dictionary]
0x00007f58  mov      x29, x29
0x00007f5c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007f60  mov      x21, x0
0x00007f64  mov      x0, x20
0x00007f68  bl       #0xd4b8 ; call stub:_objc_release
0x00007f6c  mov      x0, x19
0x00007f70  bl       #0xd4b8 ; call stub:_objc_release
0x00007f74  adrp     x2, #0x15000
0x00007f78  add      x2, x2, #0xda8 ; -> CFSTR("early")
0x00007f7c  mov      x0, x21
0x00007f80  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x00007f84  mov      x29, x29
0x00007f88  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007f8c  mov      x19, x0
0x00007f90  bl       #0xdc20 ; call objc_stub[integerValue]
0x00007f94  str      x0, [sp, #0x20]
0x00007f98  mov      x0, x19
0x00007f9c  bl       #0xd4b8 ; call stub:_objc_release
0x00007fa0  adrp     x8, #0x18000
0x00007fa4  ldr      x19, [x8, #0x458] ; -> [classref(NSMutableArray)]
0x00007fa8  adrp     x2, #0x15000
0x00007fac  add      x2, x2, #0xdc8 ; -> CFSTR("suspects")
0x00007fb0  mov      x0, x21
0x00007fb4  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x00007fb8  mov      x29, x29
0x00007fbc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007fc0  mov      x20, x0
0x00007fc4  cmp      x0, #0
0x00007fc8  adrp     x8, #0x14000
0x00007fcc  ldr      x8, [x8, #0x170] ; -> [got(___NSArray0__struct)]
0x00007fd0  csel     x2, x8, x0, eq
0x00007fd4  mov      x0, x19
0x00007fd8  bl       #0xd780 ; call objc_stub[arrayWithArray:]
0x00007fdc  mov      x29, x29
0x00007fe0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007fe4  mov      x27, x0
0x00007fe8  mov      x0, x20
0x00007fec  bl       #0xd4b8 ; call stub:_objc_release
0x00007ff0  adrp     x19, #0x18000
0x00007ff4  ldr      x0, [x19, #0x3f0] ; -> [classref(NSString)]
0x00007ff8  ldr      x2, [sp, #0x48]
0x00007ffc  mov      w3, #4
0x00008000  mov      x4, #0
0x00008004  bl       #0xe400 ; call objc_stub[stringWithContentsOfFile:encoding:error:]
0x00008008  mov      x29, x29
0x0000800c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008010  str      x0, [sp, #0x40]
0x00008014  bl       #0xdce0 ; call objc_stub[length]
0x00008018  adrp     x20, #0x18000
0x0000801c  str      x21, [sp, #0x38]
0x00008020  cbz      x0, #0x8a44
0x00008024  ldr      x0, [x19, #0x3f0] ; -> [classref(NSString)]
0x00008028  ldr      x8, [sp, #0x40]
0x0000802c  str      x8, [sp]
0x00008030  adrp     x2, #0x15000
0x00008034  add      x2, x2, #0xde8 ; -> CFSTR("CARPLAY SAP LAN TRUOC:
%@")
0x00008038  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x0000803c  mov      x29, x29
0x00008040  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008044  mov      x19, x0
0x00008048  adrp     x0, #0x14000
0x0000804c  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x00008050  mov      x1, x19
0x00008054  bl       #0x6be4 ; call _OMCLogWrite
0x00008058  mov      x0, x19
0x0000805c  bl       #0xd4b8 ; call stub:_objc_release
0x00008060  adrp     x8, #0x18000
0x00008064  ldr      x0, [x8, #0x4a8] ; -> [classref(NSFileManager)]
0x00008068  bl       #0xda40 ; call objc_stub[defaultManager]
0x0000806c  mov      x29, x29
0x00008070  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008074  mov      x19, x0
0x00008078  ldr      x2, [sp, #0x48]
0x0000807c  mov      x3, #0
0x00008080  bl       #0xd7a0 ; call objc_stub[attributesOfItemAtPath:error:]
0x00008084  mov      x29, x29
0x00008088  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000808c  mov      x20, x0
0x00008090  bl       #0xdb20 ; call objc_stub[fileModificationDate]
0x00008094  mov      x29, x29
0x00008098  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000809c  mov      x21, x0
0x000080a0  cbz      x0, #0x80b4
0x000080a4  mov      x0, x21
0x000080a8  bl       #0xd4c4 ; call stub:_objc_retain
0x000080ac  str      x21, [sp, #0x28]
0x000080b0  b        #0x80cc
0x000080b4  adrp     x8, #0x18000
0x000080b8  ldr      x0, [x8, #0x460] ; -> [classref(NSDate)]
0x000080bc  bl       #0xd9e0 ; call objc_stub[date]
0x000080c0  mov      x29, x29
0x000080c4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000080c8  str      x0, [sp, #0x28]
0x000080cc  str      x27, [sp, #0x50]
0x000080d0  str      x26, [sp, #0x30]
0x000080d4  mov      x0, x21
0x000080d8  bl       #0xd4b8 ; call stub:_objc_release
0x000080dc  mov      x0, x20
0x000080e0  bl       #0xd4b8 ; call stub:_objc_release
0x000080e4  mov      x0, x19
0x000080e8  bl       #0xd4b8 ; call stub:_objc_release
0x000080ec  ldr      x0, [x22, #0x5f0] ; -> [__DATA,__bss+0xf0]
0x000080f0  bl       #0xd614 ; call stub:_unlink
0x000080f4  movi     v0.16b, #0
0x000080f8  stp      q0, q0, [sp, #0xc0]
0x000080fc  stp      q0, q0, [sp, #0xe0]
0x00008100  adrp     x2, #0x15000
0x00008104  add      x2, x2, #0xe08 ; -> CFSTR("
")
0x00008108  ldr      x0, [sp, #0x40]
0x0000810c  bl       #0xd8c0 ; call objc_stub[componentsSeparatedByString:]
0x00008110  mov      x29, x29
0x00008114  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008118  add      x2, sp, #0xc0
0x0000811c  add      x3, sp, #0x250
0x00008120  str      x0, [sp, #0x68]
0x00008124  mov      w4, #0x10
0x00008128  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000812c  cbz      x0, #0x8340
0x00008130  mov      x23, x0
0x00008134  mov      x26, #0
0x00008138  str      xzr, [sp, #0x78]
0x0000813c  ldr      x8, [sp, #0xd0]
0x00008140  mov      x27, #0x7fffffffffffffff
0x00008144  ldr      x22, [x8] ; -> [selref(CGContext)]
0x00008148  adrp     x24, #0x15000
0x0000814c  add      x24, x24, #0xe28 ; -> CFSTR("omc-crash ")
0x00008150  adrp     x21, #0x15000
0x00008154  add      x21, x21, #0xe48 ; -> CFSTR("age=")
0x00008158  adrp     x19, #0x15000
0x0000815c  add      x19, x19, #0xe68 ; -> CFSTR("suspect=")
0x00008160  str      x22, [sp, #0x58]
0x00008164  mov      x25, #0
0x00008168  str      x23, [sp, #0x60]
0x0000816c  ldr      x8, [sp, #0xd0]
0x00008170  ldr      x8, [x8] ; -> [selref(CGContext)]
0x00008174  cmp      x8, x22
0x00008178  b.eq     #0x8184
0x0000817c  ldr      x0, [sp, #0x68]
0x00008180  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x00008184  ldr      x8, [sp, #0xc8]
0x00008188  ldr      x20, [x8, x25, lsl #3] ; -> [selref(CGContext)]
0x0000818c  mov      x0, x20
0x00008190  mov      x2, x24
0x00008194  bl       #0xdba0 ; call objc_stub[hasPrefix:]
0x00008198  cbz      w0, #0x8314
0x0000819c  str      x25, [sp, #0x70]
0x000081a0  movi     v0.16b, #0
0x000081a4  stp      q0, q0, [sp, #0xa0]
0x000081a8  stp      q0, q0, [sp, #0x80]
0x000081ac  mov      x0, x20
0x000081b0  adrp     x2, #0x15000
0x000081b4  add      x2, x2, #0x8e8 ; -> CFSTR(" ")
0x000081b8  bl       #0xd8c0 ; call objc_stub[componentsSeparatedByString:]
0x000081bc  mov      x29, x29
0x000081c0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000081c4  mov      x20, x0
0x000081c8  add      x2, sp, #0x80
0x000081cc  add      x3, sp, #0x1d0
0x000081d0  mov      w4, #0x10
0x000081d4  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x000081d8  cbz      x0, #0x82fc
0x000081dc  mov      x24, x0
0x000081e0  ldr      x8, [sp, #0x90]
0x000081e4  ldr      x28, [x8] ; -> [selref(CGContext)]
0x000081e8  mov      x22, #0
0x000081ec  ldr      x8, [sp, #0x90]
0x000081f0  ldr      x8, [x8] ; -> [selref(CGContext)]
0x000081f4  cmp      x8, x28
0x000081f8  b.eq     #0x8204
0x000081fc  mov      x0, x20
0x00008200  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x00008204  ldr      x8, [sp, #0x88]
0x00008208  ldr      x25, [x8, x22, lsl #3] ; -> [selref(CGContext)]
0x0000820c  mov      x0, x25
0x00008210  mov      x2, x21
0x00008214  bl       #0xdba0 ; call objc_stub[hasPrefix:]
0x00008218  cbz      w0, #0x8250
0x0000821c  mov      x0, x25
0x00008220  mov      w2, #4
0x00008224  bl       #0xe460 ; call objc_stub[substringFromIndex:]
0x00008228  mov      x29, x29
0x0000822c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008230  mov      x25, x0
0x00008234  bl       #0xdc20 ; call objc_stub[integerValue]
0x00008238  mov      x23, x0
0x0000823c  mov      x0, x25
0x00008240  bl       #0xd4b8 ; call stub:_objc_release
0x00008244  cmp      x27, x23
0x00008248  csel     x27, x27, x23, lt
0x0000824c  b        #0x82d4
0x00008250  mov      x0, x25
0x00008254  mov      x2, x19
0x00008258  bl       #0xdba0 ; call objc_stub[hasPrefix:]
0x0000825c  cbz      w0, #0x8274
0x00008260  mov      x0, x25
0x00008264  bl       #0xdce0 ; call objc_stub[length]
0x00008268  cmp      x0, #9
0x0000826c  ccmp     x26, #0, #0, hs
0x00008270  b.eq     #0x82bc
0x00008274  mov      x0, x25
0x00008278  adrp     x2, #0x15000
0x0000827c  add      x2, x2, #0xe88 ; -> CFSTR("last=")
0x00008280  bl       #0xdba0 ; call objc_stub[hasPrefix:]
0x00008284  cbz      w0, #0x82d4
0x00008288  mov      x0, x25
0x0000828c  bl       #0xdce0 ; call objc_stub[length]
0x00008290  cmp      x0, #6
0x00008294  ldr      x8, [sp, #0x78]
0x00008298  ccmp     x8, #0, #0, hs
0x0000829c  b.ne     #0x82d4
0x000082a0  mov      x0, x25
0x000082a4  mov      w2, #5
0x000082a8  bl       #0xe460 ; call objc_stub[substringFromIndex:]
0x000082ac  mov      x29, x29
0x000082b0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000082b4  str      x0, [sp, #0x78]
0x000082b8  b        #0x82d4
0x000082bc  mov      x0, x25
0x000082c0  mov      w2, #8
0x000082c4  bl       #0xe460 ; call objc_stub[substringFromIndex:]
0x000082c8  mov      x29, x29
0x000082cc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000082d0  mov      x26, x0
0x000082d4  add      x22, x22, #1 ; -> __DATA,__objc_selrefs+0x1
0x000082d8  cmp      x24, x22
0x000082dc  b.ne     #0x81ec
0x000082e0  add      x2, sp, #0x80
0x000082e4  add      x3, sp, #0x1d0
0x000082e8  mov      x0, x20
0x000082ec  mov      w4, #0x10
0x000082f0  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x000082f4  mov      x24, x0
0x000082f8  cbnz     x0, #0x81e8
0x000082fc  mov      x0, x20
0x00008300  bl       #0xd4b8 ; call stub:_objc_release
0x00008304  ldp      x22, x23, [sp, #0x58]
0x00008308  adrp     x24, #0x15000
0x0000830c  add      x24, x24, #0xe28 ; -> CFSTR("omc-crash ")
0x00008310  ldr      x25, [sp, #0x70]
0x00008314  add      x25, x25, #1
0x00008318  cmp      x25, x23
0x0000831c  b.ne     #0x816c
0x00008320  add      x2, sp, #0xc0
0x00008324  add      x3, sp, #0x250
0x00008328  ldr      x0, [sp, #0x68]
0x0000832c  mov      w4, #0x10
0x00008330  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00008334  mov      x23, x0
0x00008338  cbnz     x0, #0x8164
0x0000833c  b        #0x834c
0x00008340  mov      x26, #0
0x00008344  str      xzr, [sp, #0x78]
0x00008348  mov      x27, #0x7fffffffffffffff
0x0000834c  ldr      x0, [sp, #0x68]
0x00008350  bl       #0xd4b8 ; call stub:_objc_release
0x00008354  cmp      x26, #0
0x00008358  ldr      x8, [sp, #0x78]
0x0000835c  csel     x20, x8, x26, eq
0x00008360  mov      x0, x20
0x00008364  bl       #0xd4c4 ; call stub:_objc_retain
0x00008368  mov      x0, x20
0x0000836c  bl       #0xdce0 ; call objc_stub[length]
0x00008370  cbz      x0, #0x83e8
0x00008374  mov      x0, x20
0x00008378  mov      w2, #1
0x0000837c  bl       #0xe480 ; call objc_stub[substringToIndex:]
0x00008380  mov      x29, x29
0x00008384  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008388  mov      x21, x0
0x0000838c  bl       #0xdd20 ; call objc_stub[lowercaseString]
0x00008390  mov      x29, x29
0x00008394  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008398  mov      x22, x0
0x0000839c  mov      x0, x20
0x000083a0  mov      w2, #1
0x000083a4  bl       #0xe460 ; call objc_stub[substringFromIndex:]
0x000083a8  mov      x29, x29
0x000083ac  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000083b0  mov      x23, x0
0x000083b4  mov      x0, x22
0x000083b8  mov      x2, x23
0x000083bc  bl       #0xe3a0 ; call objc_stub[stringByAppendingString:]
0x000083c0  mov      x29, x29
0x000083c4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000083c8  mov      x19, x0
0x000083cc  mov      x0, x23
0x000083d0  bl       #0xd4b8 ; call stub:_objc_release
0x000083d4  mov      x0, x22
0x000083d8  bl       #0xd4b8 ; call stub:_objc_release
0x000083dc  mov      x0, x21
0x000083e0  bl       #0xd4b8 ; call stub:_objc_release
0x000083e4  b        #0x83ec
0x000083e8  mov      x19, #0
0x000083ec  mov      x0, x20
0x000083f0  bl       #0xd4b8 ; call stub:_objc_release
0x000083f4  adrp     x8, #0x14000
0x000083f8  add      x8, x8, #0xd68 ; -> CFSTR("date")
0x000083fc  ldr      x22, [sp, #0x28]
0x00008400  stp      x8, x22, [sp, #0x1c0]
0x00008404  adrp     x8, #0x18000
0x00008408  ldr      x0, [x8, #0x468] ; -> [classref(NSDictionary)]
0x0000840c  add      x2, sp, #0x1c8
0x00008410  add      x3, sp, #0x1c0
0x00008414  mov      w4, #1
0x00008418  bl       #0xdac0 ; call objc_stub[dictionaryWithObjects:forKeys:count:]
0x0000841c  mov      x29, x29
0x00008420  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008424  mov      x21, x0
0x00008428  bl       #0xde00 ; call objc_stub[mutableCopy]
0x0000842c  mov      x20, x0
0x00008430  mov      x0, x21
0x00008434  bl       #0xd4b8 ; call stub:_objc_release
0x00008438  mov      x8, #0x7fffffffffffffff
0x0000843c  cmp      x27, x8
0x00008440  b.eq     #0x847c
0x00008444  adrp     x8, #0x18000
0x00008448  ldr      x0, [x8, #0x448] ; -> [classref(NSNumber)]
0x0000844c  mov      x2, x27
0x00008450  bl       #0xdee0 ; call objc_stub[numberWithLong:]
0x00008454  mov      x29, x29
0x00008458  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000845c  mov      x21, x0
0x00008460  adrp     x3, #0x15000
0x00008464  add      x3, x3, #0xea8 ; -> CFSTR("age")
0x00008468  mov      x0, x20
0x0000846c  mov      x2, x21
0x00008470  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x00008474  mov      x0, x21
0x00008478  bl       #0xd4b8 ; call stub:_objc_release
0x0000847c  cbz      x19, #0x84d8
0x00008480  adrp     x3, #0x15000
0x00008484  add      x3, x3, #0xec8 ; -> CFSTR("suspect")
0x00008488  mov      x0, x20
0x0000848c  mov      x2, x19
0x00008490  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x00008494  adrp     x0, #0x15000
0x00008498  add      x0, x0, #0xee8 ; -> CFSTR("diagLastCrash")
0x0000849c  adrp     x2, #0x14000
0x000084a0  add      x2, x2, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x000084a4  mov      x1, x20
0x000084a8  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x000084ac  cmp      x27, #0x3b
0x000084b0  ldr      x21, [sp, #0x38]
0x000084b4  b.gt     #0x8a10
0x000084b8  ldr      x0, [sp, #0x50]
0x000084bc  mov      x2, x19
0x000084c0  bl       #0xd900 ; call objc_stub[containsObject:]
0x000084c4  tbnz     w0, #0, #0x84f4
0x000084c8  ldr      x0, [sp, #0x50]
0x000084cc  mov      x2, x19
0x000084d0  bl       #0xd6a0 ; call objc_stub[addObject:]
0x000084d4  b        #0x84f4
0x000084d8  adrp     x0, #0x15000
0x000084dc  add      x0, x0, #0xee8 ; -> CFSTR("diagLastCrash")
0x000084e0  adrp     x2, #0x14000
0x000084e4  add      x2, x2, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x000084e8  mov      x1, x20
0x000084ec  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x000084f0  ldr      x21, [sp, #0x38]
0x000084f4  mov      x0, x20
0x000084f8  bl       #0xd4b8 ; call stub:_objc_release
0x000084fc  mov      x0, x19
0x00008500  bl       #0xd4b8 ; call stub:_objc_release
0x00008504  ldr      x0, [sp, #0x78]
0x00008508  bl       #0xd4b8 ; call stub:_objc_release
0x0000850c  mov      x0, x26
0x00008510  bl       #0xd4b8 ; call stub:_objc_release
0x00008514  mov      x0, x22
0x00008518  bl       #0xd4b8 ; call stub:_objc_release
0x0000851c  cmp      x27, #0x3c
0x00008520  ldr      x26, [sp, #0x30]
0x00008524  ldr      x27, [sp, #0x50]
0x00008528  adrp     x20, #0x18000
0x0000852c  b.ge     #0x8a44
0x00008530  ldr      x8, [sp, #0x20]
0x00008534  cmp      x8, #1
0x00008538  b.lt     #0x8ef0
0x0000853c  adrp     x2, #0x15000
0x00008540  add      x2, x2, #0xb68 ; -> CFSTR("features")
0x00008544  mov      x0, x21
0x00008548  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000854c  mov      x29, x29
0x00008550  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008554  cmp      x0, #0
0x00008558  adrp     x8, #0x14000
0x0000855c  ldr      x8, [x8, #0x170] ; -> [got(___NSArray0__struct)]
0x00008560  str      x0, [sp, #0x78]
0x00008564  csel     x24, x8, x0, eq
0x00008568  mov      x0, x27
0x0000856c  bl       #0xd4c4 ; call stub:_objc_retain
0x00008570  mov      x0, x24
0x00008574  bl       #0xd4c4 ; call stub:_objc_retain
0x00008578  adrp     x0, #0x14000
0x0000857c  add      x0, x0, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x00008580  bl       #0xd0e0 ; call stub:_CFPreferencesAppSynchronize
0x00008584  adrp     x28, #0x18000
0x00008588  ldr      x0, [x28, #0x490] ; -> [classref(NSMutableOrderedSet)]
0x0000858c  bl       #0xdf80 ; call objc_stub[orderedSet]
0x00008590  mov      x29, x29
0x00008594  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008598  mov      x23, x0
0x0000859c  movi     v0.16b, #0
0x000085a0  stp      q0, q0, [sp, #0x180]
0x000085a4  stp      q0, q0, [sp, #0x1a0]
0x000085a8  mov      x0, x27
0x000085ac  bl       #0xd4c4 ; call stub:_objc_retain
0x000085b0  add      x2, sp, #0x180
0x000085b4  sub      x3, x29, #0xe0
0x000085b8  mov      x0, x27
0x000085bc  mov      w4, #0x10
0x000085c0  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x000085c4  cbz      x0, #0x863c
0x000085c8  mov      x19, x0
0x000085cc  ldr      x8, [sp, #0x190]
0x000085d0  ldr      x21, [x8] ; -> [got(___objc_personality_v0)]
0x000085d4  mov      x22, #0
0x000085d8  ldr      x8, [sp, #0x190]
0x000085dc  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x000085e0  cmp      x8, x21
0x000085e4  b.eq     #0x85f0
0x000085e8  mov      x0, x27
0x000085ec  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x000085f0  ldr      x8, [sp, #0x188]
0x000085f4  ldr      x20, [x8, x22, lsl #3] ; -> [got(___objc_personality_v0)]
0x000085f8  mov      x0, x24
0x000085fc  mov      x2, x20
0x00008600  bl       #0xd900 ; call objc_stub[containsObject:]
0x00008604  cbz      w0, #0x8614
0x00008608  mov      x0, x23
0x0000860c  mov      x2, x20
0x00008610  bl       #0xd6a0 ; call objc_stub[addObject:]
0x00008614  add      x22, x22, #1 ; -> __DATA,__objc_selrefs+0x2
0x00008618  cmp      x19, x22
0x0000861c  b.ne     #0x85d8
0x00008620  add      x2, sp, #0x180
0x00008624  sub      x3, x29, #0xe0
0x00008628  mov      x0, x27
0x0000862c  mov      w4, #0x10
0x00008630  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00008634  mov      x19, x0
0x00008638  cbnz     x0, #0x85d4
0x0000863c  mov      x0, x27
0x00008640  bl       #0xd4b8 ; call stub:_objc_release
0x00008644  mov      x0, x23
0x00008648  bl       #0xd960 ; call objc_stub[count]
0x0000864c  mov      x25, x23
0x00008650  cbnz     x0, #0x8758
0x00008654  movi     v0.16b, #0
0x00008658  stp      q0, q0, [sp, #0x160]
0x0000865c  stp      q0, q0, [sp, #0x140]
0x00008660  mov      x0, x24
0x00008664  bl       #0xd4c4 ; call stub:_objc_retain
0x00008668  add      x2, sp, #0x140
0x0000866c  add      x3, sp, #0x370
0x00008670  mov      x26, x24
0x00008674  mov      x0, x24
0x00008678  mov      w4, #0x10
0x0000867c  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00008680  cbz      x0, #0x8744
0x00008684  mov      x21, x0
0x00008688  ldr      x8, [sp, #0x150]
0x0000868c  ldr      x24, [x8] ; -> [got(___objc_personality_v0)]
0x00008690  adrp     x20, #0x14000
0x00008694  ldr      x20, [x20, #0x188] ; -> [got(___kCFBooleanTrue)]
0x00008698  mov      x19, #0
0x0000869c  ldr      x8, [sp, #0x150]
0x000086a0  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x000086a4  cmp      x8, x24
0x000086a8  b.eq     #0x86b4
0x000086ac  mov      x0, x26
0x000086b0  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x000086b4  ldr      x8, [sp, #0x148]
0x000086b8  ldr      x22, [x8, x19, lsl #3] ; -> [got(___objc_personality_v0)]
0x000086bc  mov      x0, x22
0x000086c0  adrp     x2, #0x15000
0x000086c4  add      x2, x2, #0x688 ; -> CFSTR("Enabled")
0x000086c8  bl       #0xe3a0 ; call objc_stub[stringByAppendingString:]
0x000086cc  mov      x29, x29
0x000086d0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000086d4  mov      x23, x0
0x000086d8  mov      x1, x20
0x000086dc  bl       #0x6534 ; call _OMCPref
0x000086e0  mov      x29, x29
0x000086e4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000086e8  mov      x27, x0
0x000086ec  bl       #0xd7c0 ; call objc_stub[boolValue]
0x000086f0  mov      x28, x0
0x000086f4  mov      x0, x27
0x000086f8  bl       #0xd4b8 ; call stub:_objc_release
0x000086fc  mov      x0, x23
0x00008700  bl       #0xd4b8 ; call stub:_objc_release
0x00008704  mov      x23, x25
0x00008708  cbz      w28, #0x8718
0x0000870c  mov      x0, x23
0x00008710  mov      x2, x22
0x00008714  bl       #0xd6a0 ; call objc_stub[addObject:]
0x00008718  add      x19, x19, #1 ; -> __DATA_CONST,__cfstring+0x15c1
0x0000871c  cmp      x21, x19
0x00008720  ldr      x27, [sp, #0x50]
0x00008724  b.ne     #0x869c
0x00008728  add      x2, sp, #0x140
0x0000872c  add      x3, sp, #0x370
0x00008730  mov      x0, x26
0x00008734  mov      w4, #0x10
0x00008738  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000873c  mov      x21, x0
0x00008740  cbnz     x0, #0x8698
0x00008744  mov      x24, x26
0x00008748  mov      x0, x26
0x0000874c  bl       #0xd4b8 ; call stub:_objc_release
0x00008750  ldr      x26, [sp, #0x30]
0x00008754  adrp     x28, #0x18000
0x00008758  mov      x0, x23
0x0000875c  bl       #0xd960 ; call objc_stub[count]
0x00008760  cbz      x0, #0x89d8
0x00008764  str      x24, [sp, #0x70]
0x00008768  adrp     x0, #0x14000
0x0000876c  add      x0, x0, #0xa48 ; -> CFSTR("rescueFeatures")
0x00008770  mov      x1, #0
0x00008774  bl       #0x6534 ; call _OMCPref
0x00008778  mov      x29, x29
0x0000877c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008780  mov      x19, x0
0x00008784  ldr      x20, [x28, #0x490] ; -> [classref(NSMutableOrderedSet)]
0x00008788  adrp     x8, #0x18000
0x0000878c  ldr      x0, [x8, #0x450] ; -> [classref(NSArray)]
0x00008790  bl       #0xd47c ; call stub:_objc_opt_class
0x00008794  mov      x1, x0
0x00008798  mov      x0, x19
0x0000879c  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x000087a0  tst      w0, #1
0x000087a4  adrp     x8, #0x14000
0x000087a8  ldr      x8, [x8, #0x170] ; -> [got(___NSArray0__struct)]
0x000087ac  str      x19, [sp, #0x68]
0x000087b0  csel     x2, x19, x8, ne
0x000087b4  mov      x0, x20
0x000087b8  bl       #0xdfa0 ; call objc_stub[orderedSetWithArray:]
0x000087bc  mov      x29, x29
0x000087c0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000087c4  mov      x20, x0
0x000087c8  movi     v0.16b, #0
0x000087cc  stp      q0, q0, [sp, #0x100]
0x000087d0  stp      q0, q0, [sp, #0x120]
0x000087d4  mov      x0, x23
0x000087d8  bl       #0xd4c4 ; call stub:_objc_retain
0x000087dc  add      x2, sp, #0x100
0x000087e0  add      x3, sp, #0x2f0
0x000087e4  mov      x0, x23
0x000087e8  mov      w4, #0x10
0x000087ec  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x000087f0  cbz      x0, #0x889c
0x000087f4  mov      x27, x0
0x000087f8  ldr      x8, [sp, #0x110]
0x000087fc  ldr      x19, [x8] ; -> [got(___objc_personality_v0)]
0x00008800  adrp     x21, #0x15000
0x00008804  add      x21, x21, #0x688 ; -> CFSTR("Enabled")
0x00008808  adrp     x22, #0x14000
0x0000880c  ldr      x22, [x22, #0x180] ; -> [got(___kCFBooleanFalse)]
0x00008810  adrp     x23, #0x14000
0x00008814  add      x23, x23, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x00008818  mov      x26, #0
0x0000881c  ldr      x8, [sp, #0x110]
0x00008820  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x00008824  cmp      x8, x19
0x00008828  b.eq     #0x8834
0x0000882c  mov      x0, x25
0x00008830  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x00008834  ldr      x8, [sp, #0x108]
0x00008838  ldr      x28, [x8, x26, lsl #3] ; -> [got(___objc_personality_v0)]
0x0000883c  mov      x0, x28
0x00008840  mov      x2, x21
0x00008844  bl       #0xe3a0 ; call objc_stub[stringByAppendingString:]
0x00008848  mov      x29, x29
0x0000884c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008850  mov      x24, x0
0x00008854  mov      x1, x22
0x00008858  mov      x2, x23
0x0000885c  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x00008860  mov      x0, x24
0x00008864  bl       #0xd4b8 ; call stub:_objc_release
0x00008868  mov      x0, x20
0x0000886c  mov      x2, x28
0x00008870  bl       #0xd6a0 ; call objc_stub[addObject:]
0x00008874  add      x26, x26, #1
0x00008878  cmp      x27, x26
0x0000887c  b.ne     #0x881c
0x00008880  add      x2, sp, #0x100
0x00008884  add      x3, sp, #0x2f0
0x00008888  mov      x0, x25
0x0000888c  mov      w4, #0x10
0x00008890  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00008894  mov      x27, x0
0x00008898  cbnz     x0, #0x8818
0x0000889c  mov      x0, x25
0x000088a0  bl       #0xd4b8 ; call stub:_objc_release
0x000088a4  mov      x0, x20
0x000088a8  bl       #0xd740 ; call objc_stub[array]
0x000088ac  mov      x29, x29
0x000088b0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000088b4  mov      x21, x0
0x000088b8  adrp     x0, #0x14000
0x000088bc  add      x0, x0, #0xa48 ; -> CFSTR("rescueFeatures")
0x000088c0  adrp     x22, #0x14000
0x000088c4  add      x22, x22, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x000088c8  mov      x1, x21
0x000088cc  mov      x2, x22
0x000088d0  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x000088d4  mov      x0, x21
0x000088d8  bl       #0xd4b8 ; call stub:_objc_release
0x000088dc  adrp     x8, #0x18000
0x000088e0  ldr      x0, [x8, #0x460] ; -> [classref(NSDate)]
0x000088e4  bl       #0xd9e0 ; call objc_stub[date]
0x000088e8  mov      x29, x29
0x000088ec  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000088f0  mov      x21, x0
0x000088f4  adrp     x0, #0x15000
0x000088f8  add      x0, x0, #0xba8 ; -> CFSTR("rescueDate")
0x000088fc  mov      x1, x21
0x00008900  mov      x2, x22
0x00008904  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x00008908  mov      x0, x21
0x0000890c  bl       #0xd4b8 ; call stub:_objc_release
0x00008910  mov      x0, x22
0x00008914  bl       #0xd0e0 ; call stub:_CFPreferencesAppSynchronize
0x00008918  adrp     x8, #0x18000
0x0000891c  ldr      x21, [x8, #0x3f0] ; -> [classref(NSString)]
0x00008920  mov      x0, x25
0x00008924  bl       #0xd740 ; call objc_stub[array]
0x00008928  mov      x29, x29
0x0000892c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008930  mov      x22, x0
0x00008934  adrp     x2, #0x14000
0x00008938  add      x2, x2, #0xa68 ; -> CFSTR(", ")
0x0000893c  bl       #0xd880 ; call objc_stub[componentsJoinedByString:]
0x00008940  mov      x29, x29
0x00008944  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008948  mov      x23, x0
0x0000894c  mov      w8, #0x3c
0x00008950  mov      w9, #2
0x00008954  stp      x8, x0, [sp, #8]
0x00008958  str      x9, [sp]
0x0000895c  adrp     x2, #0x15000
0x00008960  add      x2, x2, #0xf68 ; -> CFSTR("CHE DO CUU: CarPlay sap %d lan lien trong %ds dau -> tat %@")
0x00008964  mov      x0, x21
0x00008968  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x0000896c  mov      x29, x29
0x00008970  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008974  mov      x21, x0
0x00008978  adrp     x0, #0x14000
0x0000897c  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x00008980  mov      x1, x21
0x00008984  bl       #0x6be4 ; call _OMCLogWrite
0x00008988  mov      x0, x21
0x0000898c  bl       #0xd4b8 ; call stub:_objc_release
0x00008990  mov      x0, x23
0x00008994  mov      x23, x25
0x00008998  bl       #0xd4b8 ; call stub:_objc_release
0x0000899c  mov      x0, x22
0x000089a0  bl       #0xd4b8 ; call stub:_objc_release
0x000089a4  adrp     x0, #0xe000
0x000089a8  add      x0, x0, #0x754 ; -> "com.anlai.omnicar/rescue"
0x000089ac  bl       #0xd3d4 ; call stub:_notify_post
0x000089b0  adrp     x0, #0xe000
0x000089b4  add      x0, x0, #0x71b ; -> "com.anlai.omnicar/prefschanged"
0x000089b8  bl       #0xd3d4 ; call stub:_notify_post
0x000089bc  mov      x0, x20
0x000089c0  bl       #0xd4b8 ; call stub:_objc_release
0x000089c4  ldr      x0, [sp, #0x68]
0x000089c8  bl       #0xd4b8 ; call stub:_objc_release
0x000089cc  ldr      x26, [sp, #0x30]
0x000089d0  ldr      x27, [sp, #0x50]
0x000089d4  ldr      x24, [sp, #0x70]
0x000089d8  mov      x0, x23
0x000089dc  bl       #0xd4b8 ; call stub:_objc_release
0x000089e0  mov      x0, x24
0x000089e4  bl       #0xd4b8 ; call stub:_objc_release
0x000089e8  mov      x0, x27
0x000089ec  bl       #0xd4b8 ; call stub:_objc_release
0x000089f0  ldr      x0, [sp, #0x78]
0x000089f4  bl       #0xd4b8 ; call stub:_objc_release
0x000089f8  mov      x0, x27
0x000089fc  bl       #0xe0c0 ; call objc_stub[removeAllObjects]
0x00008a00  mov      x19, #0
0x00008a04  ldr      x21, [sp, #0x38]
0x00008a08  adrp     x20, #0x18000
0x00008a0c  b        #0x8a50
0x00008a10  mov      x0, x20
0x00008a14  bl       #0xd4b8 ; call stub:_objc_release
0x00008a18  mov      x0, x19
0x00008a1c  bl       #0xd4b8 ; call stub:_objc_release
0x00008a20  ldr      x0, [sp, #0x78]
0x00008a24  bl       #0xd4b8 ; call stub:_objc_release
0x00008a28  mov      x0, x26
0x00008a2c  bl       #0xd4b8 ; call stub:_objc_release
0x00008a30  mov      x0, x22
0x00008a34  bl       #0xd4b8 ; call stub:_objc_release
0x00008a38  ldr      x26, [sp, #0x30]
0x00008a3c  ldr      x27, [sp, #0x50]
0x00008a40  adrp     x20, #0x18000
0x00008a44  mov      x0, x27
0x00008a48  bl       #0xe0c0 ; call objc_stub[removeAllObjects]
0x00008a4c  mov      x19, #0
0x00008a50  ldr      x0, [x20, #0x448] ; -> [classref(NSNumber)]
0x00008a54  mov      x2, x19
0x00008a58  bl       #0xdec0 ; call objc_stub[numberWithInteger:]
0x00008a5c  mov      x29, x29
0x00008a60  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008a64  mov      x19, x0
0x00008a68  adrp     x3, #0x15000
0x00008a6c  add      x3, x3, #0xda8 ; -> CFSTR("early")
0x00008a70  mov      x0, x21
0x00008a74  mov      x2, x19
0x00008a78  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x00008a7c  mov      x0, x19
0x00008a80  bl       #0xd4b8 ; call stub:_objc_release
0x00008a84  adrp     x3, #0x15000
0x00008a88  add      x3, x3, #0xdc8 ; -> CFSTR("suspects")
0x00008a8c  mov      x0, x21
0x00008a90  mov      x2, x27
0x00008a94  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x00008a98  bl       #0x8fc0 ; call sub_8fc0
0x00008a9c  mov      x29, x29
0x00008aa0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008aa4  mov      x19, x0
0x00008aa8  mov      x0, x21
0x00008aac  mov      x2, x19
0x00008ab0  mov      w3, #1
0x00008ab4  bl       #0xe5e0 ; call objc_stub[writeToFile:atomically:]
0x00008ab8  mov      x0, x19
0x00008abc  bl       #0xd4b8 ; call stub:_objc_release
0x00008ac0  bl       #0xd158 ; call stub:_NSGetUncaughtExceptionHandler
0x00008ac4  adrp     x8, #0x18000
0x00008ac8  str      x0, [x8, #0x5f8]
0x00008acc  adrp     x0, #0x9000
0x00008ad0  add      x0, x0, #0x35c ; -> __TEXT,__text+0x535c
0x00008ad4  bl       #0xd17c ; call stub:_NSSetUncaughtExceptionHandler
0x00008ad8  mov      x19, #0
0x00008adc  adrp     x8, #0x9000
0x00008ae0  add      x8, x8, #0x5bc ; -> __TEXT,__text+0x55bc
0x00008ae4  stur     x8, [x29, #-0xe0]
0x00008ae8  adrp     x8, #0xf000
0x00008aec  ldr      d0, [x8, #0xac0] ; -> [__TEXT,__const+0x10 [u64=0x4000000000 f64=1.35807730622e-312]]
0x00008af0  stur     d0, [x29, #-0xd8]
0x00008af4  adrp     x20, #0xf000
0x00008af8  add      x20, x20, #0xae8 ; -> __TEXT,__const+0x38 [u64=0xa0000000b f64=2.1219957915e-313]
0x00008afc  ldr      w0, [x20, x19] ; -> [__TEXT,__const+0x38 [u64=0xa0000000b f64=2.1219957915e-313]]
0x00008b00  sub      x1, x29, #0xe0
0x00008b04  mov      x2, #0
0x00008b08  bl       #0xd560 ; call stub:_sigaction
0x00008b0c  add      x19, x19, #4 ; -> __DATA_CONST,__cfstring+0x15c5
0x00008b10  cmp      x19, #0x18
0x00008b14  b.ne     #0x8afc
0x00008b18  adrp     x22, #0x18000
0x00008b1c  ldr      x0, [x22, #0x4b0] ; -> [classref(NSNotificationCenter)]
0x00008b20  bl       #0xda20 ; call objc_stub[defaultCenter]
0x00008b24  mov      x29, x29
0x00008b28  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008b2c  mov      x19, x0
0x00008b30  adrp     x8, #0x14000
0x00008b34  ldr      x8, [x8, #0x190] ; -> [got(_UIScreenDidConnectNotification)]
0x00008b38  ldr      x20, [x8] ; -> [got(___objc_personality_v0)]
0x00008b3c  adrp     x23, #0x18000
0x00008b40  ldr      x0, [x23, #0x408] ; -> [classref(NSOperationQueue)]
0x00008b44  bl       #0xdd60 ; call objc_stub[mainQueue]
0x00008b48  mov      x29, x29
0x00008b4c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008b50  mov      x21, x0
0x00008b54  adrp     x5, #0x14000
0x00008b58  add      x5, x5, #0x728 ; -> __DATA_CONST,__const+0x320 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x00008b5c  mov      x0, x19
0x00008b60  mov      x2, x20
0x00008b64  mov      x3, #0
0x00008b68  mov      x4, x21
0x00008b6c  bl       #0xd6e0 ; call objc_stub[addObserverForName:object:queue:usingBlock:]
0x00008b70  mov      x29, x29
0x00008b74  bl       #0xd500 ; call stub:_objc_unsafeClaimAutoreleasedReturnValue
0x00008b78  mov      x0, x21
0x00008b7c  bl       #0xd4b8 ; call stub:_objc_release
0x00008b80  mov      x0, x19
0x00008b84  bl       #0xd4b8 ; call stub:_objc_release
0x00008b88  ldr      x0, [x22, #0x4b0] ; -> [classref(NSNotificationCenter)]
0x00008b8c  bl       #0xda20 ; call objc_stub[defaultCenter]
0x00008b90  mov      x29, x29
0x00008b94  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008b98  mov      x19, x0
0x00008b9c  adrp     x8, #0x14000
0x00008ba0  ldr      x8, [x8, #0x198] ; -> [got(_UIScreenDidDisconnectNotification)]
0x00008ba4  ldr      x20, [x8] ; -> [got(___objc_personality_v0)]
0x00008ba8  ldr      x0, [x23, #0x408] ; -> [classref(NSOperationQueue)]
0x00008bac  bl       #0xdd60 ; call objc_stub[mainQueue]
0x00008bb0  mov      x29, x29
0x00008bb4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008bb8  mov      x21, x0
0x00008bbc  adrp     x5, #0x14000
0x00008bc0  add      x5, x5, #0x748 ; -> __DATA_CONST,__const+0x340 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x00008bc4  mov      x0, x19
0x00008bc8  mov      x2, x20
0x00008bcc  mov      x3, #0
0x00008bd0  mov      x4, x21
0x00008bd4  bl       #0xd6e0 ; call objc_stub[addObserverForName:object:queue:usingBlock:]
0x00008bd8  mov      x29, x29
0x00008bdc  bl       #0xd500 ; call stub:_objc_unsafeClaimAutoreleasedReturnValue
0x00008be0  mov      x0, x21
0x00008be4  bl       #0xd4b8 ; call stub:_objc_release
0x00008be8  mov      x0, x19
0x00008bec  bl       #0xd4b8 ; call stub:_objc_release
0x00008bf0  bl       #0x97e4 ; call sub_97e4
0x00008bf4  ldr      x0, [sp, #0x40]
0x00008bf8  bl       #0xd4b8 ; call stub:_objc_release
0x00008bfc  mov      x0, x27
0x00008c00  bl       #0xd4b8 ; call stub:_objc_release
0x00008c04  ldr      x0, [sp, #0x38]
0x00008c08  bl       #0xd4b8 ; call stub:_objc_release
0x00008c0c  ldr      x0, [sp, #0x48]
0x00008c10  bl       #0xd4b8 ; call stub:_objc_release
0x00008c14  adrp     x22, #0x18000
0x00008c18  adrp     x20, #0x18000
0x00008c1c  ldr      x19, [x20, #0x470] ; -> [classref(NSMutableDictionary)]
0x00008c20  bl       #0x8fc0 ; call sub_8fc0
0x00008c24  mov      x29, x29
0x00008c28  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008c2c  mov      x23, x20
0x00008c30  mov      x20, x0
0x00008c34  mov      x0, x19
0x00008c38  mov      x2, x20
0x00008c3c  bl       #0xdaa0 ; call objc_stub[dictionaryWithContentsOfFile:]
0x00008c40  mov      x29, x29
0x00008c44  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008c48  mov      x21, x0
0x00008c4c  cbz      x0, #0x8c60
0x00008c50  mov      x0, x21
0x00008c54  bl       #0xd4c4 ; call stub:_objc_retain
0x00008c58  mov      x19, x21
0x00008c5c  b        #0x8c74
0x00008c60  ldr      x0, [x23, #0x470] ; -> [classref(NSMutableDictionary)]
0x00008c64  bl       #0xda80 ; call objc_stub[dictionary]
0x00008c68  mov      x29, x29
0x00008c6c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008c70  mov      x19, x0
0x00008c74  mov      x0, x21
0x00008c78  bl       #0xd4b8 ; call stub:_objc_release
0x00008c7c  mov      x0, x20
0x00008c80  bl       #0xd4b8 ; call stub:_objc_release
0x00008c84  adrp     x2, #0x15000
0x00008c88  add      x2, x2, #0xb68 ; -> CFSTR("features")
0x00008c8c  mov      x0, x19
0x00008c90  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x00008c94  mov      x29, x29
0x00008c98  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008c9c  mov      x21, x0
0x00008ca0  cmp      x0, #0
0x00008ca4  adrp     x8, #0x14000
0x00008ca8  ldr      x8, [x8, #0x170] ; -> [got(___NSArray0__struct)]
0x00008cac  csel     x20, x8, x0, eq
0x00008cb0  mov      x0, x20
0x00008cb4  bl       #0xd4c4 ; call stub:_objc_retain
0x00008cb8  mov      x0, x21
0x00008cbc  bl       #0xd4b8 ; call stub:_objc_release
0x00008cc0  mov      x0, x20
0x00008cc4  mov      x2, x26
0x00008cc8  bl       #0xd900 ; call objc_stub[containsObject:]
0x00008ccc  tbnz     w0, #0, #0x8d2c
0x00008cd0  mov      x0, x20
0x00008cd4  mov      x2, x26
0x00008cd8  bl       #0xd760 ; call objc_stub[arrayByAddingObject:]
0x00008cdc  mov      x29, x29
0x00008ce0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008ce4  mov      x21, x0
0x00008ce8  adrp     x3, #0x15000
0x00008cec  add      x3, x3, #0xb68 ; -> CFSTR("features")
0x00008cf0  mov      x0, x19
0x00008cf4  mov      x2, x21
0x00008cf8  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x00008cfc  mov      x0, x21
0x00008d00  bl       #0xd4b8 ; call stub:_objc_release
0x00008d04  bl       #0x8fc0 ; call sub_8fc0
0x00008d08  mov      x29, x29
0x00008d0c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008d10  mov      x21, x0
0x00008d14  mov      x0, x19
0x00008d18  mov      x2, x21
0x00008d1c  mov      w3, #1
0x00008d20  bl       #0xe5e0 ; call objc_stub[writeToFile:atomically:]
0x00008d24  mov      x0, x21
0x00008d28  bl       #0xd4b8 ; call stub:_objc_release
0x00008d2c  adrp     x0, #0x14000
0x00008d30  add      x0, x0, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x00008d34  bl       #0xd0e0 ; call stub:_CFPreferencesAppSynchronize
0x00008d38  adrp     x0, #0x14000
0x00008d3c  add      x0, x0, #0xa48 ; -> CFSTR("rescueFeatures")
0x00008d40  mov      x1, #0
0x00008d44  bl       #0x6534 ; call _OMCPref
0x00008d48  mov      x29, x29
0x00008d4c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008d50  mov      x21, x0
0x00008d54  ldr      x0, [x22, #0x450] ; -> [classref(NSArray)]
0x00008d58  bl       #0xd47c ; call stub:_objc_opt_class
0x00008d5c  mov      x1, x0
0x00008d60  mov      x0, x21
0x00008d64  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x00008d68  tbz      w0, #0, #0x8e28
0x00008d6c  mov      x0, x21
0x00008d70  mov      x2, x26
0x00008d74  bl       #0xd900 ; call objc_stub[containsObject:]
0x00008d78  cbz      w0, #0x8e28
0x00008d7c  adrp     x2, #0x15000
0x00008d80  add      x2, x2, #0x688 ; -> CFSTR("Enabled")
0x00008d84  mov      x0, x26
0x00008d88  bl       #0xe3a0 ; call objc_stub[stringByAppendingString:]
0x00008d8c  mov      x29, x29
0x00008d90  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008d94  mov      x23, x0
0x00008d98  adrp     x1, #0x14000
0x00008d9c  ldr      x1, [x1, #0x188] ; -> [got(___kCFBooleanTrue)]
0x00008da0  bl       #0x6534 ; call _OMCPref
0x00008da4  mov      x29, x29
0x00008da8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008dac  mov      x24, x0
0x00008db0  bl       #0xd7c0 ; call objc_stub[boolValue]
0x00008db4  mov      x22, x0
0x00008db8  mov      x0, x24
0x00008dbc  bl       #0xd4b8 ; call stub:_objc_release
0x00008dc0  mov      x0, x23
0x00008dc4  bl       #0xd4b8 ; call stub:_objc_release
0x00008dc8  tbz      w22, #0, #0x8e30
0x00008dcc  mov      x0, x21
0x00008dd0  bl       #0xde00 ; call objc_stub[mutableCopy]
0x00008dd4  mov      x23, x0
0x00008dd8  mov      x2, x26
0x00008ddc  bl       #0xe100 ; call objc_stub[removeObject:]
0x00008de0  mov      x0, x23
0x00008de4  bl       #0xd960 ; call objc_stub[count]
0x00008de8  cmp      x0, #0
0x00008dec  csel     x1, xzr, x23, eq
0x00008df0  adrp     x0, #0x14000
0x00008df4  add      x0, x0, #0xa48 ; -> CFSTR("rescueFeatures")
0x00008df8  adrp     x24, #0x14000
0x00008dfc  add      x24, x24, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x00008e00  mov      x2, x24
0x00008e04  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x00008e08  mov      x0, x24
0x00008e0c  bl       #0xd0e0 ; call stub:_CFPreferencesAppSynchronize
0x00008e10  adrp     x8, #0x18000
0x00008e14  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x00008e18  str      x26, [sp]
0x00008e1c  adrp     x2, #0x15000
0x00008e20  add      x2, x2, #0xbc8 ; -> CFSTR("%@ bat lai sau che do cuu")
0x00008e24  b        #0x8e64
0x00008e28  mov      w22, #1
0x00008e2c  b        #0x8e94
0x00008e30  adrp     x8, #0x18000
0x00008e34  ldr      x24, [x8, #0x3f0] ; -> [classref(NSString)]
0x00008e38  adrp     x0, #0x15000
0x00008e3c  add      x0, x0, #0xba8 ; -> CFSTR("rescueDate")
0x00008e40  mov      x1, #0
0x00008e44  bl       #0x6534 ; call _OMCPref
0x00008e48  mov      x29, x29
0x00008e4c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008e50  mov      x23, x0
0x00008e54  stp      x26, x0, [sp]
0x00008e58  adrp     x2, #0x15000
0x00008e5c  add      x2, x2, #0xb88 ; -> CFSTR("%@ dang tat boi che do cuu (tu %@): khong cai hook trong CarPlay")
0x00008e60  mov      x0, x24
0x00008e64  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00008e68  mov      x29, x29
0x00008e6c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008e70  mov      x24, x0
0x00008e74  adrp     x0, #0x14000
0x00008e78  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x00008e7c  mov      x1, x24
0x00008e80  bl       #0x6be4 ; call _OMCLogWrite
0x00008e84  mov      x0, x24
0x00008e88  bl       #0xd4b8 ; call stub:_objc_release
0x00008e8c  mov      x0, x23
0x00008e90  bl       #0xd4b8 ; call stub:_objc_release
0x00008e94  mov      x0, x21
0x00008e98  bl       #0xd4b8 ; call stub:_objc_release
0x00008e9c  mov      x0, x20
0x00008ea0  bl       #0xd4b8 ; call stub:_objc_release
0x00008ea4  mov      x0, x19
0x00008ea8  bl       #0xd4b8 ; call stub:_objc_release
0x00008eac  mov      x0, x26
0x00008eb0  bl       #0xd4b8 ; call stub:_objc_release
0x00008eb4  ldur     x8, [x29, #-0x60]
0x00008eb8  adrp     x9, #0x14000
0x00008ebc  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x00008ec0  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x00008ec4  cmp      x9, x8
0x00008ec8  b.ne     #0x8f78
0x00008ecc  mov      x0, x22
0x00008ed0  add      sp, sp, #0x480
0x00008ed4  ldp      x29, x30, [sp, #0x50]
0x00008ed8  ldp      x20, x19, [sp, #0x40]
0x00008edc  ldp      x22, x21, [sp, #0x30]
0x00008ee0  ldp      x24, x23, [sp, #0x20]
0x00008ee4  ldp      x26, x25, [sp, #0x10]
0x00008ee8  ldp      x28, x27, [sp], #0x60
0x00008eec  ret      
0x00008ef0  add      x19, x8, #1 ; -> __DATA,__objc_selrefs+0x1
0x00008ef4  cbz      x19, #0x8a50
0x00008ef8  adrp     x8, #0x18000
0x00008efc  ldr      x20, [x8, #0x3f0] ; -> [classref(NSString)]
0x00008f00  adrp     x2, #0x14000
0x00008f04  add      x2, x2, #0xa68 ; -> CFSTR(", ")
0x00008f08  mov      x0, x27
0x00008f0c  bl       #0xd880 ; call objc_stub[componentsJoinedByString:]
0x00008f10  mov      x29, x29
0x00008f14  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008f18  mov      x21, x0
0x00008f1c  mov      w8, #2
0x00008f20  stp      x8, x0, [sp, #8]
0x00008f24  str      x19, [sp]
0x00008f28  adrp     x2, #0x15000
0x00008f2c  add      x2, x2, #0xf08 ; -> CFSTR("CarPlay sap som %ld/%d lan lien (nghi: %@)")
0x00008f30  mov      x0, x20
0x00008f34  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00008f38  mov      x29, x29
0x00008f3c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008f40  mov      x20, x0
0x00008f44  adrp     x0, #0x14000
0x00008f48  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x00008f4c  mov      x1, x20
0x00008f50  bl       #0x6be4 ; call _OMCLogWrite
0x00008f54  mov      x0, x20
0x00008f58  adrp     x20, #0x18000
0x00008f5c  bl       #0xd4b8 ; call stub:_objc_release
0x00008f60  mov      x0, x21
0x00008f64  ldr      x21, [sp, #0x38]
0x00008f68  bl       #0xd4b8 ; call stub:_objc_release
0x00008f6c  b        #0x8a50
0x00008f70  bl       #0xd098 ; call sub_d098
0x00008f74  b        #0x7e30
0x00008f78  bl       #0xd1b8 ; call stub:___stack_chk_fail
