; === sub_710c @ 0x710c size=220 ===
0x0000710c  sub      sp, sp, #0x50
0x00007110  stp      x20, x19, [sp, #0x30]
0x00007114  stp      x29, x30, [sp, #0x40]
0x00007118  add      x29, sp, #0x40
0x0000711c  mov      x0, x1
0x00007120  bl       #0xe580 ; call objc_stub[userInfo]
0x00007124  mov      x29, x29
0x00007128  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000712c  mov      x20, x0
0x00007130  adrp     x2, #0x15000
0x00007134  add      x2, x2, #0x8a8 ; -> CFSTR("line")
0x00007138  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000713c  mov      x29, x29
0x00007140  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007144  mov      x19, x0
0x00007148  mov      x0, x20
0x0000714c  bl       #0xd4b8 ; call stub:_objc_release
0x00007150  adrp     x8, #0x18000
0x00007154  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x00007158  bl       #0xd47c ; call stub:_objc_opt_class
0x0000715c  mov      x1, x0
0x00007160  mov      x0, x19
0x00007164  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x00007168  tbz      w0, #0, #0x71d0
0x0000716c  bl       #0x6dd0 ; call sub_6dd0
0x00007170  mov      x29, x29
0x00007174  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007178  mov      x20, x0
0x0000717c  adrp     x8, #0x14000
0x00007180  ldr      x8, [x8, #0x1a0] ; -> [got(__NSConcreteStackBlock)]
0x00007184  str      x8, [sp, #8]
0x00007188  adrp     x8, #0xf000
0x0000718c  ldr      d0, [x8, #0xab8] ; -> [__TEXT,__const+0x8 [u64=0xc2000000 f64=1.6080749353e-314]]
0x00007190  str      d0, [sp, #0x10]
0x00007194  adrp     x8, #0x7000
0x00007198  add      x8, x8, #0x1e8 ; -> __TEXT,__text+0x31e8
0x0000719c  adrp     x9, #0x14000
0x000071a0  add      x9, x9, #0x5e8 ; -> __DATA_CONST,__const+0x1e0 [u64=0x0 f64=0.0]
0x000071a4  stp      x8, x9, [sp, #0x18]
0x000071a8  mov      x0, x19
0x000071ac  bl       #0xd4c4 ; call stub:_objc_retain
0x000071b0  str      x19, [sp, #0x28]
0x000071b4  add      x1, sp, #8
0x000071b8  mov      x0, x20
0x000071bc  bl       #0xd26c ; call stub:_dispatch_async
0x000071c0  mov      x0, x20
0x000071c4  bl       #0xd4b8 ; call stub:_objc_release
0x000071c8  ldr      x0, [sp, #0x28]
0x000071cc  bl       #0xd4b8 ; call stub:_objc_release
0x000071d0  mov      x0, x19
0x000071d4  bl       #0xd4b8 ; call stub:_objc_release
0x000071d8  ldp      x29, x30, [sp, #0x40]
0x000071dc  ldp      x20, x19, [sp, #0x30]
0x000071e0  add      sp, sp, #0x50
0x000071e4  ret      
