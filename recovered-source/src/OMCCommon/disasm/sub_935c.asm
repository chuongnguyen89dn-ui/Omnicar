; === sub_935c @ 0x935c size=608 ===
0x0000935c  stp      x28, x27, [sp, #-0x60]!
0x00009360  stp      x26, x25, [sp, #0x10]
0x00009364  stp      x24, x23, [sp, #0x20]
0x00009368  stp      x22, x21, [sp, #0x30]
0x0000936c  stp      x20, x19, [sp, #0x40]
0x00009370  stp      x29, x30, [sp, #0x50]
0x00009374  add      x29, sp, #0x50
0x00009378  sub      sp, sp, #0x2f0
0x0000937c  mov      x19, x0
0x00009380  adrp     x8, #0x14000
0x00009384  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x00009388  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x0000938c  stur     x8, [x29, #-0x58]
0x00009390  bl       #0xd4c4 ; call stub:_objc_retain
0x00009394  adrp     x8, #0x18000
0x00009398  ldr      x0, [x8, #0x5f0] ; -> [__DATA,__bss+0xf0]
0x0000939c  mov      w8, #0x1a4
0x000093a0  str      x8, [sp]
0x000093a4  mov      w1, #0x209
0x000093a8  bl       #0xd50c ; call stub:_open
0x000093ac  tbnz     w0, #0x1f, #0x9564
0x000093b0  mov      x20, x0
0x000093b4  movi     v0.16b, #0
0x000093b8  stp      q0, q0, [sp, #0x20]
0x000093bc  stp      q0, q0, [sp, #0x40]
0x000093c0  mov      x0, x19
0x000093c4  bl       #0xd820 ; call objc_stub[callStackReturnAddresses]
0x000093c8  mov      x29, x29
0x000093cc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000093d0  mov      x21, x0
0x000093d4  add      x2, sp, #0x20
0x000093d8  add      x3, sp, #0x68
0x000093dc  mov      w4, #0x10
0x000093e0  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x000093e4  cbz      x0, #0x9470
0x000093e8  mov      x22, x0
0x000093ec  mov      x23, #0
0x000093f0  ldr      x8, [sp, #0x30]
0x000093f4  ldr      x24, [x8] ; -> [selref(CGContext)]
0x000093f8  add      x25, sp, #0xe8
0x000093fc  mov      x26, #0
0x00009400  sxtw     x27, w23
0x00009404  ldr      x8, [sp, #0x30]
0x00009408  ldr      x8, [x8] ; -> [selref(CGContext)]
0x0000940c  cmp      x8, x24
0x00009410  b.eq     #0x941c
0x00009414  mov      x0, x21
0x00009418  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x0000941c  cmp      x27, #0x40
0x00009420  b.eq     #0x9468
0x00009424  ldr      x8, [sp, #0x28]
0x00009428  ldr      x0, [x8, x26, lsl #3] ; -> [selref(CGContext)]
0x0000942c  bl       #0xe560 ; call objc_stub[unsignedLongLongValue]
0x00009430  add      x23, x27, #1
0x00009434  str      x0, [x25, x27, lsl #3]
0x00009438  add      x26, x26, #1
0x0000943c  mov      x27, x23
0x00009440  cmp      x22, x26
0x00009444  b.ne     #0x9404
0x00009448  add      x2, sp, #0x20
0x0000944c  add      x3, sp, #0x68
0x00009450  mov      x0, x21
0x00009454  mov      w4, #0x10
0x00009458  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000945c  mov      x22, x0
0x00009460  cbnz     x0, #0x93fc
0x00009464  b        #0x9474
0x00009468  mov      w23, #0x40
0x0000946c  b        #0x9474
0x00009470  mov      w23, #0
0x00009474  mov      x0, x21
0x00009478  bl       #0xd4b8 ; call stub:_objc_release
0x0000947c  adrp     x1, #0xf000
0x00009480  add      x1, x1, #0x411 ; -> "exception"
0x00009484  add      x2, sp, #0xe8
0x00009488  mov      x0, x20
0x0000948c  mov      x3, x23
0x00009490  bl       #0x9a54 ; call sub_9a54
0x00009494  adrp     x8, #0x18000
0x00009498  ldr      x21, [x8, #0x3f0] ; -> [classref(NSString)]
0x0000949c  mov      x0, x19
0x000094a0  bl       #0xde20 ; call objc_stub[name]
0x000094a4  mov      x29, x29
0x000094a8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000094ac  mov      x22, x0
0x000094b0  mov      x0, x19
0x000094b4  bl       #0xe0a0 ; call objc_stub[reason]
0x000094b8  mov      x29, x29
0x000094bc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000094c0  mov      x23, x0
0x000094c4  mov      x0, x19
0x000094c8  bl       #0xd840 ; call objc_stub[callStackSymbols]
0x000094cc  mov      x29, x29
0x000094d0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000094d4  mov      x24, x0
0x000094d8  adrp     x2, #0x15000
0x000094dc  add      x2, x2, #0xe08 ; -> CFSTR("
")
0x000094e0  bl       #0xd880 ; call objc_stub[componentsJoinedByString:]
0x000094e4  mov      x29, x29
0x000094e8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000094ec  mov      x25, x0
0x000094f0  stp      x23, x0, [sp, #8]
0x000094f4  str      x22, [sp]
0x000094f8  adrp     x2, #0x15000
0x000094fc  add      x2, x2, #0xf88 ; -> CFSTR("uncaught %@: %@
%@
")
0x00009500  mov      x0, x21
0x00009504  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00009508  mov      x29, x29
0x0000950c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00009510  mov      x21, x0
0x00009514  mov      x0, x25
0x00009518  bl       #0xd4b8 ; call stub:_objc_release
0x0000951c  mov      x0, x24
0x00009520  bl       #0xd4b8 ; call stub:_objc_release
0x00009524  mov      x0, x23
0x00009528  bl       #0xd4b8 ; call stub:_objc_release
0x0000952c  mov      x0, x22
0x00009530  bl       #0xd4b8 ; call stub:_objc_release
0x00009534  mov      x0, x21
0x00009538  bl       #0xd4d0 ; call stub:_objc_retainAutorelease
0x0000953c  bl       #0xd680 ; call objc_stub[UTF8String]
0x00009540  str      x0, [sp]
0x00009544  adrp     x1, #0xf000
0x00009548  add      x1, x1, #0x42f ; -> "%s"
0x0000954c  mov      x0, x20
0x00009550  bl       #0xd308 ; call stub:_dprintf
0x00009554  mov      x0, x20
0x00009558  bl       #0xd254 ; call stub:_close
0x0000955c  mov      x0, x21
0x00009560  bl       #0xd4b8 ; call stub:_objc_release
0x00009564  adrp     x8, #0x18000
0x00009568  ldr      x8, [x8, #0x5f8] ; -> [__DATA,__bss+0xf8]
0x0000956c  cbz      x8, #0x9578
0x00009570  mov      x0, x19
0x00009574  blr      x8
0x00009578  mov      x0, x19
0x0000957c  bl       #0xd4b8 ; call stub:_objc_release
0x00009580  ldur     x8, [x29, #-0x58]
0x00009584  adrp     x9, #0x14000
0x00009588  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x0000958c  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x00009590  cmp      x9, x8
0x00009594  b.ne     #0x95b8
0x00009598  add      sp, sp, #0x2f0
0x0000959c  ldp      x29, x30, [sp, #0x50]
0x000095a0  ldp      x20, x19, [sp, #0x40]
0x000095a4  ldp      x22, x21, [sp, #0x30]
0x000095a8  ldp      x24, x23, [sp, #0x20]
0x000095ac  ldp      x26, x25, [sp, #0x10]
0x000095b0  ldp      x28, x27, [sp], #0x60
0x000095b4  ret      
0x000095b8  bl       #0xd1b8 ; call stub:___stack_chk_fail
