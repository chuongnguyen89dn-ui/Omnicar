; === _OMCCarLaunchInfo @ 0x7cd8 size=272 ===
0x00007cd8  sub      sp, sp, #0x40
0x00007cdc  stp      x22, x21, [sp, #0x10]
0x00007ce0  stp      x20, x19, [sp, #0x20]
0x00007ce4  stp      x29, x30, [sp, #0x30]
0x00007ce8  add      x29, sp, #0x30
0x00007cec  mov      x19, x0
0x00007cf0  bl       #0xd4c4 ; call stub:_objc_retain
0x00007cf4  cbz      x19, #0x7dc4
0x00007cf8  adrp     x0, #0xf000
0x00007cfc  add      x0, x0, #0x15b ; -> "DBApplicationLaunchInfo"
0x00007d00  bl       #0x72c0 ; call _OMCCarClass
0x00007d04  mov      x20, x0
0x00007d08  adrp     x0, #0x15000
0x00007d0c  add      x0, x0, #0xb08 ; -> CFSTR("launchInfoForApplication:")
0x00007d10  bl       #0xd170 ; call stub:_NSSelectorFromString
0x00007d14  mov      x22, x0
0x00007d18  adrp     x0, #0x15000
0x00007d1c  add      x0, x0, #0xb28 ; -> CFSTR("launchInfoForApplication:withActivationSettings:")
0x00007d20  bl       #0xd170 ; call stub:_NSSelectorFromString
0x00007d24  mov      x21, x0
0x00007d28  mov      x0, x20
0x00007d2c  mov      x1, x22
0x00007d30  bl       #0xd4a0 ; call stub:_objc_opt_respondsToSelector
0x00007d34  tbz      w0, #0, #0x7d54
0x00007d38  mov      x0, x20
0x00007d3c  mov      x1, x22
0x00007d40  mov      x2, x19
0x00007d44  bl       #0xd470 ; call stub:_objc_msgSend
0x00007d48  mov      x29, x29
0x00007d4c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007d50  b        #0x7d80
0x00007d54  mov      x0, x20
0x00007d58  mov      x1, x21
0x00007d5c  bl       #0xd4a0 ; call stub:_objc_opt_respondsToSelector
0x00007d60  tbz      w0, #0, #0x7d88
0x00007d64  mov      x0, x20
0x00007d68  mov      x1, x21
0x00007d6c  mov      x2, x19
0x00007d70  mov      x3, #0
0x00007d74  bl       #0xd470 ; call stub:_objc_msgSend
0x00007d78  mov      x29, x29
0x00007d7c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007d80  mov      x20, x0
0x00007d84  b        #0x7dc8
0x00007d88  adrp     x8, #0x18000
0x00007d8c  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x00007d90  str      x20, [sp]
0x00007d94  adrp     x2, #0x15000
0x00007d98  add      x2, x2, #0xb48 ; -> CFSTR("THIEU METHOD: %@ khong tao duoc launchInfo")
0x00007d9c  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00007da0  mov      x29, x29
0x00007da4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007da8  mov      x20, x0
0x00007dac  adrp     x0, #0x14000
0x00007db0  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x00007db4  mov      x1, x20
0x00007db8  bl       #0x6be4 ; call _OMCLogWrite
0x00007dbc  mov      x0, x20
0x00007dc0  bl       #0xd4b8 ; call stub:_objc_release
0x00007dc4  mov      x20, #0
0x00007dc8  mov      x0, x19
0x00007dcc  bl       #0xd4b8 ; call stub:_objc_release
0x00007dd0  mov      x0, x20
0x00007dd4  ldp      x29, x30, [sp, #0x30]
0x00007dd8  ldp      x20, x19, [sp, #0x20]
0x00007ddc  ldp      x22, x21, [sp, #0x10]
0x00007de0  add      sp, sp, #0x40
0x00007de4  b        #0xd434 ; call stub:_objc_autoreleaseReturnValue
