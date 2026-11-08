; ==== sub_1d6d0 @ 0x1d6d0..0x1d9cc (764 bytes) ====
0x0001d6d0  bl       #0x2480c   ; call _objc_release
0x0001d6d4  mov      x0, x21
0x0001d6d8  ldp      x29, x30, [sp, #0x20]
0x0001d6dc  ldp      x20, x19, [sp, #0x10]
0x0001d6e0  ldp      x22, x21, [sp], #0x30
0x0001d6e4  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x0001d6e8  stp      x20, x19, [sp, #-0x20]!
0x0001d6ec  stp      x29, x30, [sp, #0x10]
0x0001d6f0  add      x29, sp, #0x10
0x0001d6f4  bl       #0x2358c   ; call _OMCExpired
0x0001d6f8  tbz      w0, #0, #0x1d704
0x0001d6fc  mov      w0, #0
0x0001d700  b        #0x1d738   ; call sub_1d738
0x0001d704  adrp     x0, #0x37000
0x0001d708  add      x0, x0, #0x8d0   ; -> @"enabled"
0x0001d70c  adrp     x1, #0x34000
0x0001d710  ldr      x1, [x1, #0x208]   ; -> [got:___kCFBooleanTrue]
0x0001d714  bl       #0x1d680   ; call _OMCPref
0x0001d718  mov      x29, x29
0x0001d71c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001d720  mov      x19, x0
0x0001d724  bl       #0x24f20   ; objc_msgSend: boolValue
0x0001d728  mov      x20, x0
0x0001d72c  mov      x0, x19
0x0001d730  bl       #0x2480c   ; call _objc_release
0x0001d734  mov      x0, x20
0x0001d738  ldp      x29, x30, [sp, #0x10]
0x0001d73c  ldp      x20, x19, [sp], #0x20
0x0001d740  ret      
0x0001d744  stp      x22, x21, [sp, #-0x30]!
0x0001d748  stp      x20, x19, [sp, #0x10]
0x0001d74c  stp      x29, x30, [sp, #0x20]
0x0001d750  add      x29, sp, #0x20
0x0001d754  mov      x19, x0
0x0001d758  bl       #0x24818   ; call _objc_retain
0x0001d75c  bl       #0x1d6e8   ; call _OMCEnabled
0x0001d760  cbz      w0, #0x1d7b4
0x0001d764  adrp     x2, #0x37000
0x0001d768  add      x2, x2, #0x8f0   ; -> @"Enabled"
0x0001d76c  mov      x0, x19
0x0001d770  bl       #0x27c80   ; objc_msgSend: stringByAppendingString:
0x0001d774  mov      x29, x29
0x0001d778  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001d77c  mov      x21, x0
0x0001d780  adrp     x1, #0x34000
0x0001d784  ldr      x1, [x1, #0x208]   ; -> [got:___kCFBooleanTrue]
0x0001d788  bl       #0x1d680   ; call _OMCPref
0x0001d78c  mov      x29, x29
0x0001d790  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001d794  mov      x22, x0
0x0001d798  bl       #0x24f20   ; objc_msgSend: boolValue
0x0001d79c  mov      x20, x0
0x0001d7a0  mov      x0, x22
0x0001d7a4  bl       #0x2480c   ; call _objc_release
0x0001d7a8  mov      x0, x21
0x0001d7ac  bl       #0x2480c   ; call _objc_release
0x0001d7b0  b        #0x1d7b8   ; call sub_1d7b8
0x0001d7b4  mov      w20, #0
0x0001d7b8  mov      x0, x19
0x0001d7bc  bl       #0x2480c   ; call _objc_release
0x0001d7c0  mov      x0, x20
0x0001d7c4  ldp      x29, x30, [sp, #0x20]
0x0001d7c8  ldp      x20, x19, [sp, #0x10]
0x0001d7cc  ldp      x22, x21, [sp], #0x30
0x0001d7d0  ret      
0x0001d7d4  sub      sp, sp, #0x30
0x0001d7d8  stp      x20, x19, [sp, #0x10]
0x0001d7dc  stp      x29, x30, [sp, #0x20]
0x0001d7e0  add      x29, sp, #0x20
0x0001d7e4  bl       #0x242a8   ; call _CFAbsoluteTimeGetCurrent
0x0001d7e8  adrp     x8, #0x3e000
0x0001d7ec  ldr      d1, [x8, #0xa98]
0x0001d7f0  fsub     d2, d0, d1
0x0001d7f4  fcmp     d1, #0.0
0x0001d7f8  fmov     d1, #3.00000000
0x0001d7fc  fccmp    d2, d1, #0, ne
0x0001d800  b.mi     #0x1d898
0x0001d804  str      d0, [x8, #0xa98]
0x0001d808  adrp     x0, #0x37000
0x0001d80c  add      x0, x0, #0x70   ; -> @"com.anlai.omnicar"
0x0001d810  bl       #0x242b4   ; call _CFPreferencesAppSynchronize
0x0001d814  adrp     x0, #0x37000
0x0001d818  add      x0, x0, #0x910   ; -> @"liteMode"
0x0001d81c  adrp     x1, #0x39000
0x0001d820  add      x1, x1, #0x600
0x0001d824  bl       #0x1d680   ; call _OMCPref
0x0001d828  mov      x29, x29
0x0001d82c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001d830  mov      x20, x0
0x0001d834  bl       #0x25bc0   ; objc_msgSend: integerValue
0x0001d838  mov      x19, x0
0x0001d83c  mov      x0, x20
0x0001d840  bl       #0x2480c   ; call _objc_release
0x0001d844  cmp      x19, #1
0x0001d848  b.eq     #0x1d8ac
0x0001d84c  cmp      x19, #2
0x0001d850  b.ne     #0x1d8a4
0x0001d854  bl       #0x1d6e8   ; call _OMCEnabled
0x0001d858  tbz      w0, #0, #0x1d8a4
0x0001d85c  adrp     x8, #0x3e000
0x0001d860  ldr      x0, [x8, #0x408]   ; -> [class(NSProcessInfo)]
0x0001d864  bl       #0x266c0   ; objc_msgSend: processInfo
0x0001d868  mov      x29, x29
0x0001d86c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001d870  mov      x19, x0
0x0001d874  bl       #0x27f20   ; objc_msgSend: thermalState
0x0001d878  mov      x20, x0
0x0001d87c  mov      x0, x19
0x0001d880  bl       #0x2480c   ; call _objc_release
0x0001d884  cmp      x20, #2
0x0001d888  b.lt     #0x1d8cc
0x0001d88c  adrp     x8, #0x3e000
0x0001d890  mov      w0, #1
0x0001d894  b        #0x1d8b4   ; call sub_1d8b4
0x0001d898  adrp     x8, #0x3e000
0x0001d89c  ldrb     w0, [x8, #0xa90]
0x0001d8a0  b        #0x1d8b8   ; call sub_1d8b8
0x0001d8a4  mov      w0, #0
0x0001d8a8  b        #0x1d8b0   ; call sub_1d8b0
0x0001d8ac  bl       #0x1d6e8   ; call _OMCEnabled
0x0001d8b0  adrp     x8, #0x3e000
0x0001d8b4  strb     w0, [x8, #0xa90]
0x0001d8b8  and      w0, w0, #1
0x0001d8bc  ldp      x29, x30, [sp, #0x20]
0x0001d8c0  ldp      x20, x19, [sp, #0x10]
0x0001d8c4  add      sp, sp, #0x30
0x0001d8c8  ret      
0x0001d8cc  adrp     x19, #0x3e000
0x0001d8d0  ldr      w0, [x19, #0x8f8]
0x0001d8d4  cmn      w0, #1
0x0001d8d8  b.eq     #0x1d8f8
0x0001d8dc  str      xzr, [sp, #8]
0x0001d8e0  add      x1, sp, #8
0x0001d8e4  bl       #0x246e0   ; call _notify_get_state
0x0001d8e8  ldr      x8, [sp, #8]
0x0001d8ec  cmp      x8, #0
0x0001d8f0  cset     w0, ne
0x0001d8f4  b        #0x1d8b0   ; call sub_1d8b0
0x0001d8f8  adrp     x0, #0x2a000
0x0001d8fc  add      x0, x0, #0x695   ; -> "com.anlai.omnicar/lite"
0x0001d900  adrp     x1, #0x3e000
0x0001d904  add      x1, x1, #0x8f8
0x0001d908  bl       #0x246f8   ; call _notify_register_check
0x0001d90c  cbz      w0, #0x1d928
0x0001d910  mov      w0, #0
0x0001d914  mov      w8, #-1
0x0001d918  str      w8, [x19, #0x8f8]
0x0001d91c  adrp     x8, #0x3e000
0x0001d920  strb     wzr, [x8, #0xa90]
0x0001d924  b        #0x1d8b8   ; call sub_1d8b8
0x0001d928  ldr      w0, [x19, #0x8f8]
0x0001d92c  b        #0x1d8dc   ; call sub_1d8dc
0x0001d930  stp      x28, x27, [sp, #-0x60]!
0x0001d934  stp      x26, x25, [sp, #0x10]
0x0001d938  stp      x24, x23, [sp, #0x20]
0x0001d93c  stp      x22, x21, [sp, #0x30]
0x0001d940  stp      x20, x19, [sp, #0x40]
0x0001d944  stp      x29, x30, [sp, #0x50]
0x0001d948  add      x29, sp, #0x50
0x0001d94c  sub      sp, sp, #0x1b0
0x0001d950  adrp     x8, #0x34000
0x0001d954  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0001d958  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0001d95c  stur     x8, [x29, #-0x60]
0x0001d960  adrp     x0, #0x37000
0x0001d964  add      x0, x0, #0x930   ; -> @"diagCar"
0x0001d968  mov      x1, #0
0x0001d96c  bl       #0x1d680   ; call _OMCPref
0x0001d970  mov      x29, x29
0x0001d974  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001d978  mov      x19, x0
0x0001d97c  adrp     x21, #0x3e000
0x0001d980  ldr      x0, [x21, #0x310]   ; -> [class(NSDictionary)]
0x0001d984  bl       #0x247d0   ; call _objc_opt_class
0x0001d988  mov      x1, x0
0x0001d98c  mov      x0, x19
0x0001d990  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0001d994  tbz      w0, #0, #0x1dc80
0x0001d998  movi     v0.16b, #0
0x0001d99c  stp      q0, q0, [sp, #0x80]
0x0001d9a0  stp      q0, q0, [sp, #0x60]
0x0001d9a4  adrp     x0, #0x39000
0x0001d9a8  add      x0, x0, #0x4c8
0x0001d9ac  add      x2, sp, #0x60
0x0001d9b0  sub      x3, x29, #0xe0
0x0001d9b4  mov      w4, #0x10
0x0001d9b8  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001d9bc  cbz      x0, #0x1dc80
0x0001d9c0  mov      x23, x0
0x0001d9c4  ldr      x8, [sp, #0x70]
0x0001d9c8  adrp     x24, #0x3e000
