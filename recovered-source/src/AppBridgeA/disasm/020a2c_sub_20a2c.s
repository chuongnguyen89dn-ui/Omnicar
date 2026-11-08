; ==== sub_20a2c @ 0x20a2c..0x20dd4 (936 bytes) ====
0x00020a2c  bl       #0x229dc   ; call sub_229dc
0x00020a30  adrp     x8, #0x3e000
0x00020a34  ldr      x19, [x8, #0x290]   ; -> [class(NSString)]
0x00020a38  adrp     x8, #0x3e000
0x00020a3c  ldr      x0, [x8, #0xae0]
0x00020a40  bl       #0x27f60   ; objc_msgSend: timeIntervalSinceNow
0x00020a44  fneg     d0, d0
0x00020a48  adrp     x8, #0x3e000
0x00020a4c  ldr      d1, [x8, #0xb60]
0x00020a50  adrp     x8, #0x3e000
0x00020a54  ldr      d2, [x8, #0xb68]
0x00020a58  adrp     x8, #0x3e000
0x00020a5c  ldr      d3, [x8, #0xb88]
0x00020a60  adrp     x8, #0x3e000
0x00020a64  ldr      d4, [x8, #0xb78]
0x00020a68  adrp     x8, #0x3e000
0x00020a6c  ldr      x8, [x8, #0xbc0]
0x00020a70  cbz      x8, #0x20a98
0x00020a74  adrp     x9, #0x3e000
0x00020a78  ldr      d5, [x9, #0xba8]
0x00020a7c  ucvtf    d6, x8
0x00020a80  fdiv     d5, d5, d6
0x00020a84  b        #0x20a9c   ; call sub_20a9c
0x00020a88  ldp      x29, x30, [sp, #0x50]
0x00020a8c  ldp      x20, x19, [sp, #0x40]
0x00020a90  add      sp, sp, #0x60
0x00020a94  ret      
0x00020a98  fmov     d5, xzr
0x00020a9c  adrp     x8, #0x3e000
0x00020aa0  ldr      d6, [x8, #0xb90]
0x00020aa4  stp      d5, d6, [sp, #0x28]
0x00020aa8  stp      d3, d4, [sp, #0x18]
0x00020aac  stp      d1, d2, [sp, #8]
0x00020ab0  adrp     x2, #0x38000
0x00020ab4  add      x2, x2, #0x9f0   ; -> @"do hieu nang: %.0fs, tre %.0f/%.0f khung, do %.0f lan (max %.0f ms), CPU tb %.0f%%, RAM %.0f MB"
0x00020ab8  str      d0, [sp]
0x00020abc  mov      x0, x19
0x00020ac0  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00020ac4  mov      x29, x29
0x00020ac8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020acc  mov      x19, x0
0x00020ad0  adrp     x0, #0x37000
0x00020ad4  add      x0, x0, #0xd50   ; -> @"Core"
0x00020ad8  mov      x1, x19
0x00020adc  bl       #0x1dd30   ; call _OMCLogWrite
0x00020ae0  mov      x0, x19
0x00020ae4  bl       #0x2480c   ; call _objc_release
0x00020ae8  mov      w0, #0
0x00020aec  mov      x1, #0
0x00020af0  bl       #0x22f58   ; call sub_22f58
0x00020af4  ldr      x0, [x20, #0xac8]
0x00020af8  str      xzr, [x20, #0xac8]
0x00020afc  bl       #0x2480c   ; call _objc_release
0x00020b00  adrp     x0, #0x37000
0x00020b04  add      x0, x0, #0x930   ; -> @"diagCar"
0x00020b08  mov      x1, #0
0x00020b0c  bl       #0x1d680   ; call _OMCPref
0x00020b10  mov      x29, x29
0x00020b14  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020b18  mov      x20, x0
0x00020b1c  bl       #0x261e0   ; objc_msgSend: mutableCopy
0x00020b20  mov      x19, x0
0x00020b24  mov      x0, x20
0x00020b28  bl       #0x2480c   ; call _objc_release
0x00020b2c  adrp     x8, #0x3e000
0x00020b30  ldr      x0, [x8, #0x398]   ; -> [class(NSMutableDictionary)]
0x00020b34  bl       #0x247d0   ; call _objc_opt_class
0x00020b38  mov      x1, x0
0x00020b3c  mov      x0, x19
0x00020b40  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x00020b44  tbz      w0, #0, #0x20bb8
0x00020b48  adrp     x2, #0x34000
0x00020b4c  ldr      x2, [x2, #0x200]   ; -> [got:___kCFBooleanFalse]
0x00020b50  adrp     x3, #0x38000
0x00020b54  add      x3, x3, #0x130   ; -> @"connected"
0x00020b58  mov      x0, x19
0x00020b5c  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00020b60  adrp     x8, #0x3e000
0x00020b64  ldr      x0, [x8, #0x418]   ; -> [class(NSDate)]
0x00020b68  bl       #0x25480   ; objc_msgSend: date
0x00020b6c  mov      x29, x29
0x00020b70  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020b74  mov      x20, x0
0x00020b78  adrp     x3, #0x38000
0x00020b7c  add      x3, x3, #0x150   ; -> @"disconnected"
0x00020b80  mov      x0, x19
0x00020b84  mov      x2, x20
0x00020b88  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00020b8c  mov      x0, x20
0x00020b90  bl       #0x2480c   ; call _objc_release
0x00020b94  adrp     x0, #0x37000
0x00020b98  add      x0, x0, #0x930   ; -> @"diagCar"
0x00020b9c  adrp     x20, #0x37000
0x00020ba0  add      x20, x20, #0x70   ; -> @"com.anlai.omnicar"
0x00020ba4  mov      x1, x19
0x00020ba8  mov      x2, x20
0x00020bac  bl       #0x242cc   ; call _CFPreferencesSetAppValue
0x00020bb0  mov      x0, x20
0x00020bb4  bl       #0x242b4   ; call _CFPreferencesAppSynchronize
0x00020bb8  mov      x0, x19
0x00020bbc  ldp      x29, x30, [sp, #0x50]
0x00020bc0  ldp      x20, x19, [sp, #0x40]
0x00020bc4  add      sp, sp, #0x60
0x00020bc8  b        #0x2480c   ; call _objc_release
0x00020bcc  sub      sp, sp, #0xe0
0x00020bd0  stp      x26, x25, [sp, #0x90]
0x00020bd4  stp      x24, x23, [sp, #0xa0]
0x00020bd8  stp      x22, x21, [sp, #0xb0]
0x00020bdc  stp      x20, x19, [sp, #0xc0]
0x00020be0  stp      x29, x30, [sp, #0xd0]
0x00020be4  add      x29, sp, #0xd0
0x00020be8  mov      x20, x1
0x00020bec  mov      x19, x0
0x00020bf0  adrp     x8, #0x34000
0x00020bf4  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00020bf8  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00020bfc  stur     x8, [x29, #-0x48]
0x00020c00  strb     wzr, [sp, #0x48]
0x00020c04  cmp      w3, #1
0x00020c08  b.lt     #0x20cc8
0x00020c0c  mov      x21, x2
0x00020c10  mov      w26, w3
0x00020c14  adrp     x22, #0x2a000
0x00020c18  add      x22, x22, #0xb7a   ; -> "OmniCar"
0x00020c1c  adrp     x23, #0x2a000
0x00020c20  add      x23, x23, #0xb82   ; -> ".dylib"
0x00020c24  ldr      x0, [x21], #8
0x00020c28  add      x1, sp, #0x28
0x00020c2c  bl       #0x245d8   ; call _dladdr
0x00020c30  ldr      x24, [sp, #0x28]
0x00020c34  cmp      w0, #0
0x00020c38  ccmp     x24, #0, #4, ne
0x00020c3c  b.eq     #0x20c90
0x00020c40  mov      x0, x24
0x00020c44  mov      w1, #0x2f
0x00020c48  bl       #0x24968   ; call _strrchr
0x00020c4c  cmp      x0, #0
0x00020c50  csinc    x24, x24, x0, eq
0x00020c54  mov      x0, x24
0x00020c58  bl       #0x24950   ; call _strlen
0x00020c5c  mov      x25, x0
0x00020c60  mov      x0, x24
0x00020c64  mov      x1, x22
0x00020c68  mov      w2, #7
0x00020c6c  bl       #0x2495c   ; call _strncmp
0x00020c70  cmp      w0, #0
0x00020c74  ccmp     x25, #0xe, #0, eq
0x00020c78  b.lo     #0x20c90
0x00020c7c  add      x8, x24, x25
0x00020c80  sub      x0, x8, #6
0x00020c84  mov      x1, x23
0x00020c88  bl       #0x2492c   ; call _strcmp
0x00020c8c  cbz      w0, #0x20c9c
0x00020c90  subs     x26, x26, #1
0x00020c94  b.ne     #0x20c24
0x00020c98  b        #0x20cc8   ; call sub_20cc8
0x00020c9c  sub      x8, x25, #0xd
0x00020ca0  cmp      x8, #0x3f
0x00020ca4  mov      w9, #0x3f
0x00020ca8  csel     x21, x8, x9, lo
0x00020cac  add      x22, sp, #0x48
0x00020cb0  add      x0, sp, #0x48
0x00020cb4  add      x1, x24, #7
0x00020cb8  mov      x2, x21
0x00020cbc  mov      w3, #0x40
0x00020cc0  bl       #0x2447c   ; call ___memcpy_chk
0x00020cc4  strb     wzr, [x22, x21]
0x00020cc8  mov      x0, #0
0x00020ccc  bl       #0x249b0   ; call _time
0x00020cd0  adrp     x8, #0x3e000
0x00020cd4  ldr      x8, [x8, #0xb30]
0x00020cd8  ldr      x9, [x8, #0x440]   ; -> [class(NSObject)]
0x00020cdc  sub      x9, x0, x9
0x00020ce0  add      x8, x8, #0x400   ; -> class(NSCharacterSet)
0x00020ce4  stp      x8, x20, [sp, #0x10]
0x00020ce8  add      x8, sp, #0x48
0x00020cec  stp      x9, x8, [sp]
0x00020cf0  adrp     x1, #0x2a000
0x00020cf4  add      x1, x1, #0xb4d   ; -> "omc-crash age=%ld suspect=%s last=%s how=%s
"
0x00020cf8  mov      x0, x19
0x00020cfc  bl       #0x245fc   ; call _dprintf
0x00020d00  ldur     x8, [x29, #-0x48]
0x00020d04  adrp     x9, #0x34000
0x00020d08  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00020d0c  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x00020d10  cmp      x9, x8
0x00020d14  b.ne     #0x20d34
0x00020d18  ldp      x29, x30, [sp, #0xd0]
0x00020d1c  ldp      x20, x19, [sp, #0xc0]
0x00020d20  ldp      x22, x21, [sp, #0xb0]
0x00020d24  ldp      x24, x23, [sp, #0xa0]
0x00020d28  ldp      x26, x25, [sp, #0x90]
0x00020d2c  add      sp, sp, #0xe0
0x00020d30  ret      
0x00020d34  bl       #0x24488   ; call ___stack_chk_fail
0x00020d38  stp      d9, d8, [sp, #-0x70]!
0x00020d3c  stp      x28, x27, [sp, #0x10]
0x00020d40  stp      x26, x25, [sp, #0x20]
0x00020d44  stp      x24, x23, [sp, #0x30]
0x00020d48  stp      x22, x21, [sp, #0x40]
0x00020d4c  stp      x20, x19, [sp, #0x50]
0x00020d50  stp      x29, x30, [sp, #0x60]
0x00020d54  add      x29, sp, #0x60
0x00020d58  sub      sp, sp, #0x2d0
0x00020d5c  adrp     x8, #0x34000
0x00020d60  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00020d64  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00020d68  stur     x8, [x29, #-0x70]
0x00020d6c  movi     v0.16b, #0
0x00020d70  stp      q0, q0, [sp, #0x80]
0x00020d74  stp      q0, q0, [sp, #0xa0]
0x00020d78  adrp     x8, #0x3e000
0x00020d7c  ldr      x0, [x8, #0x430]   ; -> [class(UIScreen)]
0x00020d80  bl       #0x26a60   ; objc_msgSend: screens
0x00020d84  mov      x29, x29
0x00020d88  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020d8c  add      x2, sp, #0x80
0x00020d90  add      x3, sp, #0x100
0x00020d94  str      x0, [sp, #0x28]
0x00020d98  mov      w4, #0x10
0x00020d9c  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00020da0  str      x0, [sp, #0x50]
0x00020da4  ldr      x8, [sp, #0x50]
0x00020da8  cbz      x8, #0x21d0c
0x00020dac  ldr      x8, [sp, #0x90]
0x00020db0  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00020db4  str      x8, [sp, #0x48]
0x00020db8  fmov     d8, #1.00000000
0x00020dbc  adrp     x24, #0x3e000
0x00020dc0  str      xzr, [sp, #0x68]
0x00020dc4  ldr      x8, [sp, #0x90]
0x00020dc8  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00020dcc  ldr      x9, [sp, #0x48]
0x00020dd0  cmp      x8, x9
