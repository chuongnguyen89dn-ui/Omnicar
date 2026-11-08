; === sub_9814 @ 0x9814 size=576 ===
0x00009814  sub      sp, sp, #0x60
0x00009818  stp      x20, x19, [sp, #0x40]
0x0000981c  stp      x29, x30, [sp, #0x50]
0x00009820  add      x29, sp, #0x50
0x00009824  mov      x0, x1
0x00009828  bl       #0xdf20 ; call objc_stub[object]
0x0000982c  mov      x29, x29
0x00009830  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00009834  mov      x19, x0
0x00009838  adrp     x8, #0x18000
0x0000983c  ldr      x0, [x8, #0x4b8] ; -> [classref(UIScreen)]
0x00009840  bl       #0xdda0 ; call objc_stub[mainScreen]
0x00009844  mov      x29, x29
0x00009848  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000984c  mov      x20, x0
0x00009850  bl       #0xd4b8 ; call stub:_objc_release
0x00009854  mov      x0, x19
0x00009858  bl       #0xd4b8 ; call stub:_objc_release
0x0000985c  cmp      x19, x20
0x00009860  b.eq     #0x9910
0x00009864  adrp     x20, #0x18000
0x00009868  ldr      x8, [x20, #0x588] ; -> [__DATA,__bss+0x88]
0x0000986c  cbz      x8, #0x9988
0x00009870  adrp     x19, #0x18000
0x00009874  ldr      x0, [x19, #0x598] ; -> [__DATA,__bss+0x98]
0x00009878  cbz      x0, #0x9884
0x0000987c  bl       #0xd2a8 ; call stub:_dispatch_source_cancel
0x00009880  ldr      x0, [x19, #0x598] ; -> [__DATA,__bss+0x98]
0x00009884  str      xzr, [x19, #0x598]
0x00009888  bl       #0xd4b8 ; call stub:_objc_release
0x0000988c  adrp     x19, #0x18000
0x00009890  ldr      x0, [x19, #0x590] ; -> [__DATA,__bss+0x90]
0x00009894  bl       #0xdc40 ; call objc_stub[invalidate]
0x00009898  ldr      x0, [x19, #0x590] ; -> [__DATA,__bss+0x90]
0x0000989c  str      xzr, [x19, #0x590]
0x000098a0  bl       #0xd4b8 ; call stub:_objc_release
0x000098a4  adrp     x8, #0x18000
0x000098a8  ldr      x9, [x8, #0x608] ; -> [__DATA,__bss+0x108]
0x000098ac  add      x9, x9, #1
0x000098b0  str      x9, [x8, #0x608]
0x000098b4  bl       #0xb864 ; call sub_b864
0x000098b8  adrp     x8, #0x18000
0x000098bc  ldr      x19, [x8, #0x3f0] ; -> [classref(NSString)]
0x000098c0  adrp     x8, #0x18000
0x000098c4  ldr      x0, [x8, #0x5a0] ; -> [__DATA,__bss+0xa0]
0x000098c8  bl       #0xe500 ; call objc_stub[timeIntervalSinceNow]
0x000098cc  fneg     d0, d0
0x000098d0  adrp     x8, #0x18000
0x000098d4  ldr      d1, [x8, #0x620] ; -> [__DATA,__bss+0x120]
0x000098d8  adrp     x8, #0x18000
0x000098dc  ldr      d2, [x8, #0x628] ; -> [__DATA,__bss+0x128]
0x000098e0  adrp     x8, #0x18000
0x000098e4  ldr      d3, [x8, #0x648] ; -> [__DATA,__bss+0x148]
0x000098e8  adrp     x8, #0x18000
0x000098ec  ldr      d4, [x8, #0x638] ; -> [__DATA,__bss+0x138]
0x000098f0  adrp     x8, #0x18000
0x000098f4  ldr      x8, [x8, #0x680] ; -> [__DATA,__bss+0x180]
0x000098f8  cbz      x8, #0x9920
0x000098fc  adrp     x9, #0x18000
0x00009900  ldr      d5, [x9, #0x668] ; -> [__DATA,__bss+0x168]
0x00009904  ucvtf    d6, x8
0x00009908  fdiv     d5, d5, d6
0x0000990c  b        #0x9924
0x00009910  ldp      x29, x30, [sp, #0x50]
0x00009914  ldp      x20, x19, [sp, #0x40]
0x00009918  add      sp, sp, #0x60
0x0000991c  ret      
0x00009920  fmov     d5, xzr
0x00009924  adrp     x8, #0x18000
0x00009928  ldr      d6, [x8, #0x650] ; -> [__DATA,__bss+0x150]
0x0000992c  stp      d5, d6, [sp, #0x28]
0x00009930  stp      d3, d4, [sp, #0x18]
0x00009934  stp      d1, d2, [sp, #8]
0x00009938  adrp     x2, #0x16000
0x0000993c  add      x2, x2, #0x868 ; -> CFSTR("do hieu nang: %.0fs, tre %.0f/%.0f khung, do %.0f lan (max %.0f ms), CPU tb %.0f%%, RAM %.0f MB")
0x00009940  str      d0, [sp]
0x00009944  mov      x0, x19
0x00009948  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x0000994c  mov      x29, x29
0x00009950  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00009954  mov      x19, x0
0x00009958  adrp     x0, #0x14000
0x0000995c  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x00009960  mov      x1, x19
0x00009964  bl       #0x6be4 ; call _OMCLogWrite
0x00009968  mov      x0, x19
0x0000996c  bl       #0xd4b8 ; call stub:_objc_release
0x00009970  mov      w0, #0
0x00009974  mov      x1, #0
0x00009978  bl       #0xbde0 ; call sub_bde0
0x0000997c  ldr      x0, [x20, #0x588] ; -> [__DATA,__bss+0x88]
0x00009980  str      xzr, [x20, #0x588]
0x00009984  bl       #0xd4b8 ; call stub:_objc_release
0x00009988  adrp     x0, #0x15000
0x0000998c  add      x0, x0, #0x6a8 ; -> CFSTR("diagCar")
0x00009990  mov      x1, #0
0x00009994  bl       #0x6534 ; call _OMCPref
0x00009998  mov      x29, x29
0x0000999c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000099a0  mov      x20, x0
0x000099a4  bl       #0xde00 ; call objc_stub[mutableCopy]
0x000099a8  mov      x19, x0
0x000099ac  mov      x0, x20
0x000099b0  bl       #0xd4b8 ; call stub:_objc_release
0x000099b4  adrp     x8, #0x18000
0x000099b8  ldr      x0, [x8, #0x470] ; -> [classref(NSMutableDictionary)]
0x000099bc  bl       #0xd47c ; call stub:_objc_opt_class
0x000099c0  mov      x1, x0
0x000099c4  mov      x0, x19
0x000099c8  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x000099cc  tbz      w0, #0, #0x9a40
0x000099d0  adrp     x2, #0x14000
0x000099d4  ldr      x2, [x2, #0x180] ; -> [got(___kCFBooleanFalse)]
0x000099d8  adrp     x3, #0x15000
0x000099dc  add      x3, x3, #0xf28 ; -> CFSTR("connected")
0x000099e0  mov      x0, x19
0x000099e4  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x000099e8  adrp     x8, #0x18000
0x000099ec  ldr      x0, [x8, #0x460] ; -> [classref(NSDate)]
0x000099f0  bl       #0xd9e0 ; call objc_stub[date]
0x000099f4  mov      x29, x29
0x000099f8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000099fc  mov      x20, x0
0x00009a00  adrp     x3, #0x15000
0x00009a04  add      x3, x3, #0xf48 ; -> CFSTR("disconnected")
0x00009a08  mov      x0, x19
0x00009a0c  mov      x2, x20
0x00009a10  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x00009a14  mov      x0, x20
0x00009a18  bl       #0xd4b8 ; call stub:_objc_release
0x00009a1c  adrp     x0, #0x15000
0x00009a20  add      x0, x0, #0x6a8 ; -> CFSTR("diagCar")
0x00009a24  adrp     x20, #0x14000
0x00009a28  add      x20, x20, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x00009a2c  mov      x1, x19
0x00009a30  mov      x2, x20
0x00009a34  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x00009a38  mov      x0, x20
0x00009a3c  bl       #0xd0e0 ; call stub:_CFPreferencesAppSynchronize
0x00009a40  mov      x0, x19
0x00009a44  ldp      x29, x30, [sp, #0x50]
0x00009a48  ldp      x20, x19, [sp, #0x40]
0x00009a4c  add      sp, sp, #0x60
0x00009a50  b        #0xd4b8 ; call stub:_objc_release
