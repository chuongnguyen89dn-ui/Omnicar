; === _OMCLiteActive @ 0x6688 size=348 ===
0x00006688  sub      sp, sp, #0x30
0x0000668c  stp      x20, x19, [sp, #0x10]
0x00006690  stp      x29, x30, [sp, #0x20]
0x00006694  add      x29, sp, #0x20
0x00006698  bl       #0xd0d4 ; call stub:_CFAbsoluteTimeGetCurrent
0x0000669c  adrp     x8, #0x18000
0x000066a0  ldr      d1, [x8, #0x558] ; -> [__DATA,__bss+0x58]
0x000066a4  fsub     d2, d0, d1
0x000066a8  fcmp     d1, #0.0
0x000066ac  fmov     d1, #3.00000000
0x000066b0  fccmp    d2, d1, #0, ne
0x000066b4  b.mi     #0x674c
0x000066b8  str      d0, [x8, #0x558]
0x000066bc  adrp     x0, #0x14000
0x000066c0  add      x0, x0, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x000066c4  bl       #0xd0e0 ; call stub:_CFPreferencesAppSynchronize
0x000066c8  adrp     x0, #0x15000
0x000066cc  add      x0, x0, #0x528 ; -> CFSTR("liteMode")
0x000066d0  adrp     x1, #0x16000
0x000066d4  add      x1, x1, #0xd30 ; -> __DATA_CONST,__objc_intobj+0x60 [NSNumber int=2]
0x000066d8  bl       #0x6534 ; call _OMCPref
0x000066dc  mov      x29, x29
0x000066e0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000066e4  mov      x20, x0
0x000066e8  bl       #0xdc20 ; call objc_stub[integerValue]
0x000066ec  mov      x19, x0
0x000066f0  mov      x0, x20
0x000066f4  bl       #0xd4b8 ; call stub:_objc_release
0x000066f8  cmp      x19, #1
0x000066fc  b.eq     #0x6760
0x00006700  cmp      x19, #2
0x00006704  b.ne     #0x6758
0x00006708  bl       #0x659c ; call _OMCEnabled
0x0000670c  tbz      w0, #0, #0x6758
0x00006710  adrp     x8, #0x18000
0x00006714  ldr      x0, [x8, #0x488] ; -> [classref(NSProcessInfo)]
0x00006718  bl       #0xe040 ; call objc_stub[processInfo]
0x0000671c  mov      x29, x29
0x00006720  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006724  mov      x19, x0
0x00006728  bl       #0xe4c0 ; call objc_stub[thermalState]
0x0000672c  mov      x20, x0
0x00006730  mov      x0, x19
0x00006734  bl       #0xd4b8 ; call stub:_objc_release
0x00006738  cmp      x20, #2
0x0000673c  b.lt     #0x6780
0x00006740  adrp     x8, #0x18000
0x00006744  mov      w0, #1
0x00006748  b        #0x6768
0x0000674c  adrp     x8, #0x18000
0x00006750  ldrb     w0, [x8, #0x550]
0x00006754  b        #0x676c
0x00006758  mov      w0, #0
0x0000675c  b        #0x6764
0x00006760  bl       #0x659c ; call _OMCEnabled
0x00006764  adrp     x8, #0x18000
0x00006768  strb     w0, [x8, #0x550]
0x0000676c  and      w0, w0, #1
0x00006770  ldp      x29, x30, [sp, #0x20]
0x00006774  ldp      x20, x19, [sp, #0x10]
0x00006778  add      sp, sp, #0x30
0x0000677c  ret      
0x00006780  adrp     x19, #0x18000
0x00006784  ldr      w0, [x19, #0x4f0] ; -> [__DATA,__data+0x0]
0x00006788  cmn      w0, #1
0x0000678c  b.eq     #0x67ac
0x00006790  str      xzr, [sp, #8]
0x00006794  add      x1, sp, #8
0x00006798  bl       #0xd3c8 ; call stub:_notify_get_state
0x0000679c  ldr      x8, [sp, #8]
0x000067a0  cmp      x8, #0
0x000067a4  cset     w0, ne
0x000067a8  b        #0x6764
0x000067ac  adrp     x0, #0xe000
0x000067b0  add      x0, x0, #0xf84 ; -> "com.anlai.omnicar/lite"
0x000067b4  adrp     x1, #0x18000
0x000067b8  add      x1, x1, #0x4f0 ; -> __DATA,__data+0x0
0x000067bc  bl       #0xd3e0 ; call stub:_notify_register_check
0x000067c0  cbz      w0, #0x67dc
0x000067c4  mov      w0, #0
0x000067c8  mov      w8, #-1
0x000067cc  str      w8, [x19, #0x4f0]
0x000067d0  adrp     x8, #0x18000
0x000067d4  strb     wzr, [x8, #0x550]
0x000067d8  b        #0x676c
0x000067dc  ldr      w0, [x19, #0x4f0] ; -> [__DATA,__data+0x0]
0x000067e0  b        #0x6790
