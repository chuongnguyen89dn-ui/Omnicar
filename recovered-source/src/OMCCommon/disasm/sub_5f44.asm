; === sub_5f44 @ 0x5f44 size=172 ===
0x00005f44  stp      d9, d8, [sp, #-0x30]!
0x00005f48  stp      x20, x19, [sp, #0x10]
0x00005f4c  stp      x29, x30, [sp, #0x20]
0x00005f50  add      x29, sp, #0x20
0x00005f54  mov      x19, x0
0x00005f58  bl       #0x6528 ; call _OMCPrefsSync
0x00005f5c  ldr      x0, [x19, #0x20]
0x00005f60  bl       #0xe4e0 ; call objc_stub[timeIntervalSince1970]
0x00005f64  mov      v8.16b, v0.16b
0x00005f68  adrp     x0, #0x14000
0x00005f6c  add      x0, x0, #0xa08 ; -> CFSTR("trustedTime")
0x00005f70  adrp     x1, #0x16000
0x00005f74  add      x1, x1, #0xcd0 ; -> __DATA_CONST,__objc_intobj+0x0 [NSNumber int=0]
0x00005f78  bl       #0x6534 ; call _OMCPref
0x00005f7c  mov      x29, x29
0x00005f80  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005f84  mov      x19, x0
0x00005f88  bl       #0xdb00 ; call objc_stub[doubleValue]
0x00005f8c  mov      v9.16b, v0.16b
0x00005f90  mov      x0, x19
0x00005f94  bl       #0xd4b8 ; call stub:_objc_release
0x00005f98  fcmp     d8, d9
0x00005f9c  b.ls     #0x5fe0
0x00005fa0  adrp     x8, #0x18000
0x00005fa4  ldr      x0, [x8, #0x448] ; -> [classref(NSNumber)]
0x00005fa8  mov      v0.16b, v8.16b
0x00005fac  bl       #0xdea0 ; call objc_stub[numberWithDouble:]
0x00005fb0  mov      x1, x0
0x00005fb4  adrp     x0, #0x14000
0x00005fb8  add      x0, x0, #0xa08 ; -> CFSTR("trustedTime")
0x00005fbc  adrp     x19, #0x14000
0x00005fc0  add      x19, x19, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x00005fc4  mov      x2, x19
0x00005fc8  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x00005fcc  mov      x0, x19
0x00005fd0  ldp      x29, x30, [sp, #0x20]
0x00005fd4  ldp      x20, x19, [sp, #0x10]
0x00005fd8  ldp      d9, d8, [sp], #0x30
0x00005fdc  b        #0xd0e0 ; call stub:_CFPreferencesAppSynchronize
0x00005fe0  ldp      x29, x30, [sp, #0x20]
0x00005fe4  ldp      x20, x19, [sp, #0x10]
0x00005fe8  ldp      d9, d8, [sp], #0x30
0x00005fec  ret      
