; === _OMCExpired @ 0xc414 size=252 ===
0x0000c414  stp      d9, d8, [sp, #-0x40]!
0x0000c418  stp      x22, x21, [sp, #0x10]
0x0000c41c  stp      x20, x19, [sp, #0x20]
0x0000c420  stp      x29, x30, [sp, #0x30]
0x0000c424  add      x29, sp, #0x30
0x0000c428  adrp     x21, #0x18000
0x0000c42c  ldrb     w8, [x21, #0x700]
0x0000c430  tbz      w8, #0, #0xc43c
0x0000c434  mov      w20, #1
0x0000c438  b        #0xc4f0
0x0000c43c  adrp     x8, #0x18000
0x0000c440  ldr      x8, [x8, #0x730] ; -> [__DATA,__bss+0x230]
0x0000c444  cmn      x8, #1
0x0000c448  b.ne     #0xc508
0x0000c44c  adrp     x8, #0x18000
0x0000c450  ldr      d9, [x8, #0x728] ; -> [__DATA,__bss+0x228]
0x0000c454  fcmp     d9, #0.0
0x0000c458  b.ls     #0xc4d8
0x0000c45c  adrp     x8, #0x18000
0x0000c460  ldr      x0, [x8, #0x460] ; -> [classref(NSDate)]
0x0000c464  bl       #0xd9e0 ; call objc_stub[date]
0x0000c468  mov      x29, x29
0x0000c46c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000c470  mov      x19, x0
0x0000c474  bl       #0xe4e0 ; call objc_stub[timeIntervalSince1970]
0x0000c478  mov      v8.16b, v0.16b
0x0000c47c  mov      x0, x19
0x0000c480  bl       #0xd4b8 ; call stub:_objc_release
0x0000c484  adrp     x0, #0x14000
0x0000c488  add      x0, x0, #0xa08 ; -> CFSTR("trustedTime")
0x0000c48c  adrp     x1, #0x14000
0x0000c490  add      x1, x1, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x0000c494  bl       #0xd0ec ; call stub:_CFPreferencesCopyAppValue
0x0000c498  mov      x19, x0
0x0000c49c  adrp     x8, #0x18000
0x0000c4a0  ldr      x0, [x8, #0x448] ; -> [classref(NSNumber)]
0x0000c4a4  bl       #0xd47c ; call stub:_objc_opt_class
0x0000c4a8  mov      x1, x0
0x0000c4ac  mov      x0, x19
0x0000c4b0  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x0000c4b4  tbz      w0, #0, #0xc4c8
0x0000c4b8  mov      x0, x19
0x0000c4bc  bl       #0xdb00 ; call objc_stub[doubleValue]
0x0000c4c0  fcmp     d8, d0
0x0000c4c4  fcsel    d8, d0, d8, mi
0x0000c4c8  fcmp     d8, d9
0x0000c4cc  b.ge     #0xc4e0
0x0000c4d0  ldrb     w20, [x21, #0x700]
0x0000c4d4  b        #0xc4e8
0x0000c4d8  mov      w20, #0
0x0000c4dc  b        #0xc4f0
0x0000c4e0  mov      w20, #1
0x0000c4e4  strb     w20, [x21, #0x700]
0x0000c4e8  mov      x0, x19
0x0000c4ec  bl       #0xd4b8 ; call stub:_objc_release
0x0000c4f0  mov      x0, x20
0x0000c4f4  ldp      x29, x30, [sp, #0x30]
0x0000c4f8  ldp      x20, x19, [sp, #0x20]
0x0000c4fc  ldp      x22, x21, [sp, #0x10]
0x0000c500  ldp      d9, d8, [sp], #0x40
0x0000c504  ret      
0x0000c508  bl       #0xd0ac ; call sub_d0ac
0x0000c50c  b        #0xc44c
