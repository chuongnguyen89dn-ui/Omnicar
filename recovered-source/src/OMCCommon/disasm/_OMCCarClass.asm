; === _OMCCarClass @ 0x72c0 size=328 ===
0x000072c0  stp      x22, x21, [sp, #-0x30]!
0x000072c4  stp      x20, x19, [sp, #0x10]
0x000072c8  stp      x29, x30, [sp, #0x20]
0x000072cc  add      x29, sp, #0x20
0x000072d0  mov      x19, x0
0x000072d4  bl       #0xd464 ; call stub:_objc_getClass
0x000072d8  cbz      x0, #0x72e8
0x000072dc  mov      x21, x0
0x000072e0  bl       #0xd4c4 ; call stub:_objc_retain
0x000072e4  b        #0x73f4
0x000072e8  adrp     x8, #0x18000
0x000072ec  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x000072f0  mov      x2, x19
0x000072f4  bl       #0xe440 ; call objc_stub[stringWithUTF8String:]
0x000072f8  mov      x29, x29
0x000072fc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007300  mov      x19, x0
0x00007304  adrp     x2, #0x15000
0x00007308  add      x2, x2, #0xa88 ; -> CFSTR("DashBoard")
0x0000730c  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x00007310  cbz      w0, #0x7330
0x00007314  adrp     x0, #0xf000
0x00007318  add      x0, x0, #0x140 ; -> "CARApplication"
0x0000731c  bl       #0xd464 ; call stub:_objc_getClass
0x00007320  mov      x29, x29
0x00007324  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007328  mov      x21, x0
0x0000732c  b        #0x73ec
0x00007330  adrp     x2, #0x15000
0x00007334  add      x2, x2, #0xaa8 ; -> CFSTR("DB")
0x00007338  mov      x0, x19
0x0000733c  bl       #0xdba0 ; call objc_stub[hasPrefix:]
0x00007340  cbz      w0, #0x73a4
0x00007344  mov      x0, x19
0x00007348  mov      w2, #2
0x0000734c  bl       #0xe460 ; call objc_stub[substringFromIndex:]
0x00007350  mov      x29, x29
0x00007354  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007358  cbz      x0, #0x73a4
0x0000735c  mov      x20, x0
0x00007360  adrp     x0, #0x15000
0x00007364  add      x0, x0, #0xac8 ; -> CFSTR("CAR")
0x00007368  mov      x2, x20
0x0000736c  bl       #0xe3a0 ; call objc_stub[stringByAppendingString:]
0x00007370  mov      x29, x29
0x00007374  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007378  mov      x22, x0
0x0000737c  bl       #0xd4d0 ; call stub:_objc_retainAutorelease
0x00007380  bl       #0xd680 ; call objc_stub[UTF8String]
0x00007384  bl       #0xd464 ; call stub:_objc_getClass
0x00007388  mov      x21, x0
0x0000738c  mov      x0, x22
0x00007390  bl       #0xd4b8 ; call stub:_objc_release
0x00007394  cbz      x21, #0x73ac
0x00007398  mov      x0, x21
0x0000739c  bl       #0xd4c4 ; call stub:_objc_retain
0x000073a0  b        #0x73e4
0x000073a4  mov      x21, #0
0x000073a8  b        #0x73ec
0x000073ac  adrp     x0, #0x15000
0x000073b0  add      x0, x0, #0xae8 ; -> CFSTR("_CAR")
0x000073b4  mov      x2, x20
0x000073b8  bl       #0xe3a0 ; call objc_stub[stringByAppendingString:]
0x000073bc  mov      x29, x29
0x000073c0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000073c4  mov      x22, x0
0x000073c8  bl       #0xd4d0 ; call stub:_objc_retainAutorelease
0x000073cc  bl       #0xd680 ; call objc_stub[UTF8String]
0x000073d0  bl       #0xd464 ; call stub:_objc_getClass
0x000073d4  mov      x21, x0
0x000073d8  bl       #0xd4c4 ; call stub:_objc_retain
0x000073dc  mov      x0, x22
0x000073e0  bl       #0xd4b8 ; call stub:_objc_release
0x000073e4  mov      x0, x20
0x000073e8  bl       #0xd4b8 ; call stub:_objc_release
0x000073ec  mov      x0, x19
0x000073f0  bl       #0xd4b8 ; call stub:_objc_release
0x000073f4  mov      x0, x21
0x000073f8  ldp      x29, x30, [sp, #0x20]
0x000073fc  ldp      x20, x19, [sp, #0x10]
0x00007400  ldp      x22, x21, [sp], #0x30
0x00007404  b        #0xd434 ; call stub:_objc_autoreleaseReturnValue
