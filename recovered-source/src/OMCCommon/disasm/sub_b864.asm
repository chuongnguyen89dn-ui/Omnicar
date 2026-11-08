; === sub_b864 @ 0xb864 size=1404 ===
0x0000b864  stp      d9, d8, [sp, #-0x40]!
0x0000b868  stp      x22, x21, [sp, #0x10]
0x0000b86c  stp      x20, x19, [sp, #0x20]
0x0000b870  stp      x29, x30, [sp, #0x30]
0x0000b874  add      x29, sp, #0x30
0x0000b878  adrp     x20, #0x18000
0x0000b87c  ldr      x0, [x20, #0x5a0] ; -> [__DATA,__bss+0xa0]
0x0000b880  cbz      x0, #0xb894
0x0000b884  bl       #0xe500 ; call objc_stub[timeIntervalSinceNow]
0x0000b888  fmov     d1, #-30.00000000
0x0000b88c  fcmp     d0, d1
0x0000b890  b.le     #0xb8a8
0x0000b894  ldp      x29, x30, [sp, #0x30]
0x0000b898  ldp      x20, x19, [sp, #0x20]
0x0000b89c  ldp      x22, x21, [sp, #0x10]
0x0000b8a0  ldp      d9, d8, [sp], #0x40
0x0000b8a4  ret      
0x0000b8a8  fneg     d8, d0
0x0000b8ac  adrp     x8, #0x18000
0x0000b8b0  ldr      x0, [x8, #0x470] ; -> [classref(NSMutableDictionary)]
0x0000b8b4  bl       #0xda80 ; call objc_stub[dictionary]
0x0000b8b8  mov      x29, x29
0x0000b8bc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000b8c0  mov      x19, x0
0x0000b8c4  ldr      x2, [x20, #0x5a0] ; -> [__DATA,__bss+0xa0]
0x0000b8c8  adrp     x3, #0x16000
0x0000b8cc  add      x3, x3, #0x1e8 ; -> CFSTR("start")
0x0000b8d0  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000b8d4  adrp     x8, #0x18000
0x0000b8d8  ldr      x0, [x8, #0x460] ; -> [classref(NSDate)]
0x0000b8dc  bl       #0xd9e0 ; call objc_stub[date]
0x0000b8e0  mov      x29, x29
0x0000b8e4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000b8e8  mov      x20, x0
0x0000b8ec  adrp     x3, #0x16000
0x0000b8f0  add      x3, x3, #0x208 ; -> CFSTR("updated")
0x0000b8f4  mov      x0, x19
0x0000b8f8  mov      x2, x20
0x0000b8fc  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000b900  mov      x0, x20
0x0000b904  bl       #0xd4b8 ; call stub:_objc_release
0x0000b908  adrp     x21, #0x18000
0x0000b90c  ldr      x0, [x21, #0x448] ; -> [classref(NSNumber)]
0x0000b910  fcvtas   x2, d8
0x0000b914  bl       #0xdee0 ; call objc_stub[numberWithLong:]
0x0000b918  mov      x29, x29
0x0000b91c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000b920  mov      x20, x0
0x0000b924  adrp     x3, #0x16000
0x0000b928  add      x3, x3, #0x228 ; -> CFSTR("seconds")
0x0000b92c  mov      x0, x19
0x0000b930  mov      x2, x20
0x0000b934  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000b938  mov      x0, x20
0x0000b93c  bl       #0xd4b8 ; call stub:_objc_release
0x0000b940  ldr      x0, [x21, #0x448] ; -> [classref(NSNumber)]
0x0000b944  adrp     x8, #0x18000
0x0000b948  ldr      d0, [x8, #0x610] ; -> [__DATA,__bss+0x110]
0x0000b94c  fmov     d1, #1.00000000
0x0000b950  fdiv     d0, d1, d0
0x0000b954  fcvtas   x2, d0
0x0000b958  bl       #0xdee0 ; call objc_stub[numberWithLong:]
0x0000b95c  mov      x29, x29
0x0000b960  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000b964  mov      x20, x0
0x0000b968  adrp     x3, #0x16000
0x0000b96c  add      x3, x3, #0x248 ; -> CFSTR("fps")
0x0000b970  mov      x0, x19
0x0000b974  mov      x2, x20
0x0000b978  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000b97c  mov      x0, x20
0x0000b980  bl       #0xd4b8 ; call stub:_objc_release
0x0000b984  ldr      x0, [x21, #0x448] ; -> [classref(NSNumber)]
0x0000b988  adrp     x8, #0x18000
0x0000b98c  ldr      d0, [x8, #0x628] ; -> [__DATA,__bss+0x128]
0x0000b990  fcvtas   x2, d0
0x0000b994  bl       #0xdee0 ; call objc_stub[numberWithLong:]
0x0000b998  mov      x29, x29
0x0000b99c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000b9a0  mov      x20, x0
0x0000b9a4  adrp     x3, #0x16000
0x0000b9a8  add      x3, x3, #0x148 ; -> CFSTR("frames")
0x0000b9ac  mov      x0, x19
0x0000b9b0  mov      x2, x20
0x0000b9b4  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000b9b8  mov      x0, x20
0x0000b9bc  bl       #0xd4b8 ; call stub:_objc_release
0x0000b9c0  ldr      x0, [x21, #0x448] ; -> [classref(NSNumber)]
0x0000b9c4  adrp     x8, #0x18000
0x0000b9c8  ldr      d0, [x8, #0x620] ; -> [__DATA,__bss+0x120]
0x0000b9cc  fcvtas   x2, d0
0x0000b9d0  bl       #0xdee0 ; call objc_stub[numberWithLong:]
0x0000b9d4  mov      x29, x29
0x0000b9d8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000b9dc  mov      x20, x0
0x0000b9e0  adrp     x3, #0x16000
0x0000b9e4  add      x3, x3, #0x268 ; -> CFSTR("late")
0x0000b9e8  mov      x0, x19
0x0000b9ec  mov      x2, x20
0x0000b9f0  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000b9f4  mov      x0, x20
0x0000b9f8  bl       #0xd4b8 ; call stub:_objc_release
0x0000b9fc  ldr      x0, [x21, #0x448] ; -> [classref(NSNumber)]
0x0000ba00  adrp     x8, #0x18000
0x0000ba04  ldr      d0, [x8, #0x618] ; -> [__DATA,__bss+0x118]
0x0000ba08  fcvtas   x2, d0
0x0000ba0c  bl       #0xdee0 ; call objc_stub[numberWithLong:]
0x0000ba10  mov      x29, x29
0x0000ba14  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000ba18  mov      x20, x0
0x0000ba1c  adrp     x3, #0x16000
0x0000ba20  add      x3, x3, #0x288 ; -> CFSTR("worstMs")
0x0000ba24  mov      x0, x19
0x0000ba28  mov      x2, x20
0x0000ba2c  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000ba30  mov      x0, x20
0x0000ba34  bl       #0xd4b8 ; call stub:_objc_release
0x0000ba38  ldr      x0, [x21, #0x448] ; -> [classref(NSNumber)]
0x0000ba3c  adrp     x8, #0x18000
0x0000ba40  ldr      d0, [x8, #0x648] ; -> [__DATA,__bss+0x148]
0x0000ba44  fcvtas   x2, d0
0x0000ba48  bl       #0xdee0 ; call objc_stub[numberWithLong:]
0x0000ba4c  mov      x29, x29
0x0000ba50  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000ba54  mov      x20, x0
0x0000ba58  adrp     x3, #0x16000
0x0000ba5c  add      x3, x3, #0x128 ; -> CFSTR("hangs")
0x0000ba60  mov      x0, x19
0x0000ba64  mov      x2, x20
0x0000ba68  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000ba6c  mov      x0, x20
0x0000ba70  bl       #0xd4b8 ; call stub:_objc_release
0x0000ba74  ldr      x0, [x21, #0x448] ; -> [classref(NSNumber)]
0x0000ba78  adrp     x8, #0x18000
0x0000ba7c  ldr      d0, [x8, #0x640] ; -> [__DATA,__bss+0x140]
0x0000ba80  fcvtas   x2, d0
0x0000ba84  bl       #0xdee0 ; call objc_stub[numberWithLong:]
0x0000ba88  mov      x29, x29
0x0000ba8c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000ba90  mov      x20, x0
0x0000ba94  adrp     x3, #0x16000
0x0000ba98  add      x3, x3, #0x2a8 ; -> CFSTR("freezes")
0x0000ba9c  mov      x0, x19
0x0000baa0  mov      x2, x20
0x0000baa4  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000baa8  mov      x0, x20
0x0000baac  bl       #0xd4b8 ; call stub:_objc_release
0x0000bab0  ldr      x0, [x21, #0x448] ; -> [classref(NSNumber)]
0x0000bab4  adrp     x8, #0x18000
0x0000bab8  ldr      d0, [x8, #0x638] ; -> [__DATA,__bss+0x138]
0x0000babc  fcvtas   x2, d0
0x0000bac0  bl       #0xdee0 ; call objc_stub[numberWithLong:]
0x0000bac4  mov      x29, x29
0x0000bac8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000bacc  mov      x20, x0
0x0000bad0  adrp     x3, #0x16000
0x0000bad4  add      x3, x3, #0x2c8 ; -> CFSTR("hangMaxMs")
0x0000bad8  mov      x0, x19
0x0000badc  mov      x2, x20
0x0000bae0  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000bae4  mov      x0, x20
0x0000bae8  bl       #0xd4b8 ; call stub:_objc_release
0x0000baec  adrp     x20, #0x18000
0x0000baf0  ldr      x0, [x20, #0x5b0] ; -> [__DATA,__bss+0xb0]
0x0000baf4  bl       #0xd960 ; call objc_stub[count]
0x0000baf8  cbz      x0, #0xbb24
0x0000bafc  ldr      x0, [x20, #0x5b0] ; -> [__DATA,__bss+0xb0]
0x0000bb00  bl       #0xd940 ; call objc_stub[copy]
0x0000bb04  mov      x20, x0
0x0000bb08  adrp     x3, #0x16000
0x0000bb0c  add      x3, x3, #0x2e8 ; -> CFSTR("hangWho")
0x0000bb10  mov      x0, x19
0x0000bb14  mov      x2, x20
0x0000bb18  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000bb1c  mov      x0, x20
0x0000bb20  bl       #0xd4b8 ; call stub:_objc_release
0x0000bb24  adrp     x8, #0x18000
0x0000bb28  ldr      x8, [x8, #0x680] ; -> [__DATA,__bss+0x180]
0x0000bb2c  cbz      x8, #0xbcb8
0x0000bb30  ldr      x0, [x21, #0x448] ; -> [classref(NSNumber)]
0x0000bb34  adrp     x9, #0x18000
0x0000bb38  ldr      d0, [x9, #0x668] ; -> [__DATA,__bss+0x168]
0x0000bb3c  ucvtf    d1, x8
0x0000bb40  fdiv     d0, d0, d1
0x0000bb44  fcvtas   x2, d0
0x0000bb48  bl       #0xdee0 ; call objc_stub[numberWithLong:]
0x0000bb4c  mov      x29, x29
0x0000bb50  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000bb54  mov      x20, x0
0x0000bb58  adrp     x3, #0x16000
0x0000bb5c  add      x3, x3, #0x308 ; -> CFSTR("cpuAvg")
0x0000bb60  mov      x0, x19
0x0000bb64  mov      x2, x20
0x0000bb68  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000bb6c  mov      x0, x20
0x0000bb70  bl       #0xd4b8 ; call stub:_objc_release
0x0000bb74  ldr      x0, [x21, #0x448] ; -> [classref(NSNumber)]
0x0000bb78  adrp     x8, #0x18000
0x0000bb7c  ldr      d0, [x8, #0x660] ; -> [__DATA,__bss+0x160]
0x0000bb80  fcvtas   x2, d0
0x0000bb84  bl       #0xdee0 ; call objc_stub[numberWithLong:]
0x0000bb88  mov      x29, x29
0x0000bb8c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000bb90  mov      x20, x0
0x0000bb94  adrp     x3, #0x16000
0x0000bb98  add      x3, x3, #0x328 ; -> CFSTR("cpuMax")
0x0000bb9c  mov      x0, x19
0x0000bba0  mov      x2, x20
0x0000bba4  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000bba8  mov      x0, x20
0x0000bbac  bl       #0xd4b8 ; call stub:_objc_release
0x0000bbb0  ldr      x0, [x21, #0x448] ; -> [classref(NSNumber)]
0x0000bbb4  adrp     x8, #0x18000
0x0000bbb8  ldr      d0, [x8, #0x658] ; -> [__DATA,__bss+0x158]
0x0000bbbc  fcvtas   x2, d0
0x0000bbc0  bl       #0xdee0 ; call objc_stub[numberWithLong:]
0x0000bbc4  mov      x29, x29
0x0000bbc8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000bbcc  mov      x20, x0
0x0000bbd0  adrp     x3, #0x16000
0x0000bbd4  add      x3, x3, #0x348 ; -> CFSTR("memMB")
0x0000bbd8  mov      x0, x19
0x0000bbdc  mov      x2, x20
0x0000bbe0  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000bbe4  mov      x0, x20
0x0000bbe8  bl       #0xd4b8 ; call stub:_objc_release
0x0000bbec  ldr      x0, [x21, #0x448] ; -> [classref(NSNumber)]
0x0000bbf0  adrp     x8, #0x18000
0x0000bbf4  ldr      d0, [x8, #0x650] ; -> [__DATA,__bss+0x150]
0x0000bbf8  fcvtas   x2, d0
0x0000bbfc  bl       #0xdee0 ; call objc_stub[numberWithLong:]
0x0000bc00  mov      x29, x29
0x0000bc04  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000bc08  mov      x20, x0
0x0000bc0c  adrp     x3, #0x16000
0x0000bc10  add      x3, x3, #0x368 ; -> CFSTR("memMaxMB")
0x0000bc14  mov      x0, x19
0x0000bc18  mov      x2, x20
0x0000bc1c  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000bc20  mov      x0, x20
0x0000bc24  bl       #0xd4b8 ; call stub:_objc_release
0x0000bc28  ldr      x0, [x21, #0x448] ; -> [classref(NSNumber)]
0x0000bc2c  adrp     x8, #0x18000
0x0000bc30  ldr      d0, [x8, #0x678] ; -> [__DATA,__bss+0x178]
0x0000bc34  fcvtas   x8, d0
0x0000bc38  mov      x9, #0x7fefffffffffffff
0x0000bc3c  fmov     d8, x9
0x0000bc40  fcmp     d0, d8
0x0000bc44  csel     x2, x8, xzr, mi
0x0000bc48  bl       #0xdee0 ; call objc_stub[numberWithLong:]
0x0000bc4c  mov      x29, x29
0x0000bc50  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000bc54  mov      x20, x0
0x0000bc58  adrp     x3, #0x16000
0x0000bc5c  add      x3, x3, #0x388 ; -> CFSTR("availMinMB")
0x0000bc60  mov      x0, x19
0x0000bc64  mov      x2, x20
0x0000bc68  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000bc6c  mov      x0, x20
0x0000bc70  bl       #0xd4b8 ; call stub:_objc_release
0x0000bc74  ldr      x0, [x21, #0x448] ; -> [classref(NSNumber)]
0x0000bc78  adrp     x8, #0x18000
0x0000bc7c  ldr      d0, [x8, #0x670] ; -> [__DATA,__bss+0x170]
0x0000bc80  fcvtas   x8, d0
0x0000bc84  fcmp     d0, d8
0x0000bc88  csel     x2, x8, xzr, mi
0x0000bc8c  bl       #0xdee0 ; call objc_stub[numberWithLong:]
0x0000bc90  mov      x29, x29
0x0000bc94  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000bc98  mov      x20, x0
0x0000bc9c  adrp     x3, #0x16000
0x0000bca0  add      x3, x3, #0x3a8 ; -> CFSTR("sysFreeMinMB")
0x0000bca4  mov      x0, x19
0x0000bca8  mov      x2, x20
0x0000bcac  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000bcb0  mov      x0, x20
0x0000bcb4  bl       #0xd4b8 ; call stub:_objc_release
0x0000bcb8  ldr      x0, [x21, #0x448] ; -> [classref(NSNumber)]
0x0000bcbc  adrp     x8, #0x18000
0x0000bcc0  ldr      x2, [x8, #0x688] ; -> [__DATA,__bss+0x188]
0x0000bcc4  bl       #0xdec0 ; call objc_stub[numberWithInteger:]
0x0000bcc8  mov      x29, x29
0x0000bccc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000bcd0  mov      x20, x0
0x0000bcd4  adrp     x3, #0x16000
0x0000bcd8  add      x3, x3, #0x3c8 ; -> CFSTR("thermalMax")
0x0000bcdc  mov      x0, x19
0x0000bce0  mov      x2, x20
0x0000bce4  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000bce8  mov      x0, x20
0x0000bcec  bl       #0xd4b8 ; call stub:_objc_release
0x0000bcf0  ldr      x0, [x21, #0x448] ; -> [classref(NSNumber)]
0x0000bcf4  adrp     x8, #0x18000
0x0000bcf8  ldrb     w2, [x8, #0x690]
0x0000bcfc  bl       #0xde80 ; call objc_stub[numberWithBool:]
0x0000bd00  mov      x29, x29
0x0000bd04  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000bd08  mov      x20, x0
0x0000bd0c  adrp     x3, #0x16000
0x0000bd10  add      x3, x3, #0x3e8 ; -> CFSTR("lowPower")
0x0000bd14  mov      x0, x19
0x0000bd18  mov      x2, x20
0x0000bd1c  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000bd20  mov      x0, x20
0x0000bd24  bl       #0xd4b8 ; call stub:_objc_release
0x0000bd28  adrp     x8, #0x18000
0x0000bd2c  ldr      x8, [x8, #0x5a8] ; -> [__DATA,__bss+0xa8]
0x0000bd30  adrp     x9, #0x14000
0x0000bd34  ldr      x9, [x9, #0x170] ; -> [got(___NSArray0__struct)]
0x0000bd38  cmp      x8, #0
0x0000bd3c  csel     x2, x9, x8, eq
0x0000bd40  adrp     x3, #0x16000
0x0000bd44  add      x3, x3, #0x408 ; -> CFSTR("tweaks")
0x0000bd48  mov      x0, x19
0x0000bd4c  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000bd50  ldr      x0, [x21, #0x448] ; -> [classref(NSNumber)]
0x0000bd54  adrp     x8, #0x18000
0x0000bd58  ldr      x2, [x8, #0x6c8] ; -> [__DATA,__bss+0x1c8]
0x0000bd5c  bl       #0xdf00 ; call objc_stub[numberWithUnsignedInteger:]
0x0000bd60  mov      x29, x29
0x0000bd64  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000bd68  mov      x20, x0
0x0000bd6c  adrp     x3, #0x16000
0x0000bd70  add      x3, x3, #0x428 ; -> CFSTR("liteCount")
0x0000bd74  mov      x0, x19
0x0000bd78  mov      x2, x20
0x0000bd7c  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000bd80  mov      x0, x20
0x0000bd84  bl       #0xd4b8 ; call stub:_objc_release
0x0000bd88  adrp     x8, #0x18000
0x0000bd8c  ldr      x2, [x8, #0x5b8] ; -> [__DATA,__bss+0xb8]
0x0000bd90  cbz      x2, #0xbda4
0x0000bd94  adrp     x3, #0x16000
0x0000bd98  add      x3, x3, #0x448 ; -> CFSTR("liteReason")
0x0000bd9c  mov      x0, x19
0x0000bda0  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000bda4  adrp     x0, #0x16000
0x0000bda8  add      x0, x0, #0x468 ; -> CFSTR("diagPerf")
0x0000bdac  adrp     x20, #0x14000
0x0000bdb0  add      x20, x20, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x0000bdb4  mov      x1, x19
0x0000bdb8  mov      x2, x20
0x0000bdbc  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x0000bdc0  mov      x0, x20
0x0000bdc4  bl       #0xd0e0 ; call stub:_CFPreferencesAppSynchronize
0x0000bdc8  mov      x0, x19
0x0000bdcc  ldp      x29, x30, [sp, #0x30]
0x0000bdd0  ldp      x20, x19, [sp, #0x20]
0x0000bdd4  ldp      x22, x21, [sp, #0x10]
0x0000bdd8  ldp      d9, d8, [sp], #0x40
0x0000bddc  b        #0xd4b8 ; call stub:_objc_release
