; === _OMCTrustedTimeStart @ 0x44a8 size=196 ===
0x000044a8  sub      sp, sp, #0x30
0x000044ac  stp      x20, x19, [sp, #0x10]
0x000044b0  stp      x29, x30, [sp, #0x20]
0x000044b4  add      x29, sp, #0x20
0x000044b8  bl       #0xc414 ; call _OMCExpired
0x000044bc  adrp     x8, #0x18000
0x000044c0  strb     w0, [x8, #0x530]
0x000044c4  cbz      w0, #0x450c
0x000044c8  adrp     x8, #0x18000
0x000044cc  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x000044d0  adrp     x8, #0xe000
0x000044d4  add      x8, x8, #0x6da ; -> "2027-04-30"
0x000044d8  str      x8, [sp]
0x000044dc  adrp     x2, #0x14000
0x000044e0  add      x2, x2, #0x8c8 ; -> CFSTR("free period over (%s)")
0x000044e4  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x000044e8  mov      x29, x29
0x000044ec  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000044f0  mov      x19, x0
0x000044f4  adrp     x0, #0x14000
0x000044f8  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x000044fc  mov      x1, x19
0x00004500  bl       #0x6be4 ; call _OMCLogWrite
0x00004504  mov      x0, x19
0x00004508  bl       #0xd4b8 ; call stub:_objc_release
0x0000450c  bl       #0x456c ; call sub_456c
0x00004510  adrp     x19, #0x18000
0x00004514  ldr      x0, [x19, #0x3f8] ; -> [classref(NSTimer)]
0x00004518  adrp     x3, #0x14000
0x0000451c  add      x3, x3, #0x468 ; -> __DATA_CONST,__const+0x60 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x00004520  adrp     x8, #0xf000
0x00004524  ldr      d0, [x8, #0xab0] ; -> [__TEXT,__const+0x0 [u64=0x40d5180000000000 f64=21600.0]]
0x00004528  mov      w2, #1
0x0000452c  bl       #0xe180 ; call objc_stub[scheduledTimerWithTimeInterval:repeats:block:]
0x00004530  mov      x29, x29
0x00004534  bl       #0xd500 ; call stub:_objc_unsafeClaimAutoreleasedReturnValue
0x00004538  ldr      x0, [x19, #0x3f8] ; -> [classref(NSTimer)]
0x0000453c  adrp     x3, #0x14000
0x00004540  add      x3, x3, #0x488 ; -> __DATA_CONST,__const+0x80 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x00004544  mov      x8, #0x404e000000000000
0x00004548  fmov     d0, x8
0x0000454c  mov      w2, #1
0x00004550  bl       #0xe180 ; call objc_stub[scheduledTimerWithTimeInterval:repeats:block:]
0x00004554  mov      x29, x29
0x00004558  bl       #0xd500 ; call stub:_objc_unsafeClaimAutoreleasedReturnValue
0x0000455c  ldp      x29, x30, [sp, #0x20]
0x00004560  ldp      x20, x19, [sp, #0x10]
0x00004564  add      sp, sp, #0x30
0x00004568  ret      
