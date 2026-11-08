; === sub_464c @ 0x464c size=164 ===
0x0000464c  sub      sp, sp, #0x30
0x00004650  stp      x20, x19, [sp, #0x10]
0x00004654  stp      x29, x30, [sp, #0x20]
0x00004658  add      x29, sp, #0x20
0x0000465c  mov      x19, x1
0x00004660  mov      x0, x1
0x00004664  bl       #0xd4c4 ; call stub:_objc_retain
0x00004668  adrp     x20, #0x18000
0x0000466c  ldrb     w8, [x20, #0x530]
0x00004670  tbnz     w8, #0, #0x46dc
0x00004674  bl       #0xc414 ; call _OMCExpired
0x00004678  cbz      w0, #0x46dc
0x0000467c  mov      w8, #1
0x00004680  strb     w8, [x20, #0x530]
0x00004684  adrp     x8, #0x18000
0x00004688  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x0000468c  adrp     x8, #0xe000
0x00004690  add      x8, x8, #0x6da ; -> "2027-04-30"
0x00004694  str      x8, [sp]
0x00004698  adrp     x2, #0x14000
0x0000469c  add      x2, x2, #0x8e8 ; -> CFSTR("free period over (%s): features off")
0x000046a0  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x000046a4  mov      x29, x29
0x000046a8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000046ac  mov      x20, x0
0x000046b0  adrp     x0, #0x14000
0x000046b4  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x000046b8  mov      x1, x20
0x000046bc  bl       #0x6be4 ; call _OMCLogWrite
0x000046c0  mov      x0, x20
0x000046c4  bl       #0xd4b8 ; call stub:_objc_release
0x000046c8  adrp     x0, #0xe000
0x000046cc  add      x0, x0, #0x71b ; -> "com.anlai.omnicar/prefschanged"
0x000046d0  bl       #0xd3d4 ; call stub:_notify_post
0x000046d4  mov      x0, x19
0x000046d8  bl       #0xdc40 ; call objc_stub[invalidate]
0x000046dc  mov      x0, x19
0x000046e0  ldp      x29, x30, [sp, #0x20]
0x000046e4  ldp      x20, x19, [sp, #0x10]
0x000046e8  add      sp, sp, #0x30
0x000046ec  b        #0xd4b8 ; call stub:_objc_release
