; === sub_90dc @ 0x90dc size=400 ===
0x000090dc  sub      sp, sp, #0x80
0x000090e0  stp      x22, x21, [sp, #0x50]
0x000090e4  stp      x20, x19, [sp, #0x60]
0x000090e8  stp      x29, x30, [sp, #0x70]
0x000090ec  add      x29, sp, #0x70
0x000090f0  mov      x19, x0
0x000090f4  adrp     x8, #0x14000
0x000090f8  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x000090fc  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x00009100  stur     x8, [x29, #-0x28]
0x00009104  adrp     x21, #0x18000
0x00009108  ldr      x0, [x21, #0x3f0] ; -> [classref(NSString)]
0x0000910c  ldr      x10, [x19, #0x20]
0x00009110  adrp     x8, #0xf000
0x00009114  add      x8, x8, #0x291 ; -> "1.0.3"
0x00009118  adrp     x9, #0xf000
0x0000911c  add      x9, x9, #0x289 ; -> "fbebb21"
0x00009120  stp      x8, x10, [sp, #8]
0x00009124  str      x9, [sp]
0x00009128  adrp     x2, #0x15000
0x0000912c  add      x2, x2, #0xc28 ; -> CFSTR("build %s (%s) loaded into %@")
0x00009130  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00009134  mov      x29, x29
0x00009138  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000913c  mov      x20, x0
0x00009140  adrp     x0, #0x14000
0x00009144  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x00009148  mov      x1, x20
0x0000914c  bl       #0x6be4 ; call _OMCLogWrite
0x00009150  mov      x0, x20
0x00009154  bl       #0xd4b8 ; call stub:_objc_release
0x00009158  ldr      x0, [x21, #0x3f0] ; -> [classref(NSString)]
0x0000915c  ldr      x10, [x19, #0x20]
0x00009160  adrp     x8, #0xe000
0x00009164  add      x8, x8, #0x6bf ; -> "Core"
0x00009168  adrp     x9, #0x15000
0x0000916c  add      x9, x9, #0xc68 ; -> CFSTR("diagLoaded.")
0x00009170  stp      x8, x10, [sp, #8]
0x00009174  str      x9, [sp]
0x00009178  adrp     x2, #0x15000
0x0000917c  add      x2, x2, #0xc48 ; -> CFSTR("%@%s@%@")
0x00009180  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00009184  mov      x29, x29
0x00009188  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000918c  mov      x19, x0
0x00009190  adrp     x8, #0x15000
0x00009194  add      x8, x8, #0xc88 ; -> CFSTR("version")
0x00009198  adrp     x9, #0x15000
0x0000919c  add      x9, x9, #0xca8 ; -> CFSTR("1.0.3")
0x000091a0  adrp     x10, #0x15000
0x000091a4  add      x10, x10, #0xcc8 ; -> CFSTR("build")
0x000091a8  stp      x8, x10, [sp, #0x18]
0x000091ac  adrp     x8, #0x15000
0x000091b0  add      x8, x8, #0xce8 ; -> CFSTR("fbebb21")
0x000091b4  stp      x9, x8, [sp, #0x30]
0x000091b8  adrp     x8, #0x14000
0x000091bc  add      x8, x8, #0xd68 ; -> CFSTR("date")
0x000091c0  str      x8, [sp, #0x28]
0x000091c4  adrp     x8, #0x18000
0x000091c8  ldr      x0, [x8, #0x460] ; -> [classref(NSDate)]
0x000091cc  bl       #0xd9e0 ; call objc_stub[date]
0x000091d0  mov      x29, x29
0x000091d4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000091d8  mov      x20, x0
0x000091dc  str      x0, [sp, #0x40]
0x000091e0  adrp     x8, #0x18000
0x000091e4  ldr      x0, [x8, #0x468] ; -> [classref(NSDictionary)]
0x000091e8  add      x2, sp, #0x30
0x000091ec  add      x3, sp, #0x18
0x000091f0  mov      w4, #3
0x000091f4  bl       #0xdac0 ; call objc_stub[dictionaryWithObjects:forKeys:count:]
0x000091f8  mov      x29, x29
0x000091fc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00009200  mov      x21, x0
0x00009204  mov      x0, x20
0x00009208  bl       #0xd4b8 ; call stub:_objc_release
0x0000920c  adrp     x20, #0x14000
0x00009210  add      x20, x20, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x00009214  mov      x0, x19
0x00009218  mov      x1, x21
0x0000921c  mov      x2, x20
0x00009220  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x00009224  mov      x0, x20
0x00009228  bl       #0xd0e0 ; call stub:_CFPreferencesAppSynchronize
0x0000922c  mov      x0, x21
0x00009230  bl       #0xd4b8 ; call stub:_objc_release
0x00009234  mov      x0, x19
0x00009238  bl       #0xd4b8 ; call stub:_objc_release
0x0000923c  ldur     x8, [x29, #-0x28]
0x00009240  adrp     x9, #0x14000
0x00009244  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x00009248  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x0000924c  cmp      x9, x8
0x00009250  b.ne     #0x9268
0x00009254  ldp      x29, x30, [sp, #0x70]
0x00009258  ldp      x20, x19, [sp, #0x60]
0x0000925c  ldp      x22, x21, [sp, #0x50]
0x00009260  add      sp, sp, #0x80
0x00009264  ret      
0x00009268  bl       #0xd1b8 ; call stub:___stack_chk_fail
