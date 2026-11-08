; === sub_456c @ 0x456c size=220 ===
0x0000456c  stp      x22, x21, [sp, #-0x30]!
0x00004570  stp      x20, x19, [sp, #0x10]
0x00004574  stp      x29, x30, [sp, #0x20]
0x00004578  add      x29, sp, #0x20
0x0000457c  adrp     x8, #0x18000
0x00004580  ldr      x19, [x8, #0x410] ; -> [classref(NSMutableURLRequest)]
0x00004584  adrp     x8, #0x18000
0x00004588  ldr      x0, [x8, #0x418] ; -> [classref(NSURL)]
0x0000458c  adrp     x2, #0x14000
0x00004590  add      x2, x2, #0x968 ; -> CFSTR("https://www.apple.com/")
0x00004594  bl       #0xd660 ; call objc_stub[URLWithString:]
0x00004598  mov      x29, x29
0x0000459c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000045a0  mov      x20, x0
0x000045a4  mov      x0, x19
0x000045a8  mov      x2, x20
0x000045ac  bl       #0xe120 ; call objc_stub[requestWithURL:]
0x000045b0  mov      x29, x29
0x000045b4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000045b8  mov      x19, x0
0x000045bc  mov      x0, x20
0x000045c0  bl       #0xd4b8 ; call stub:_objc_release
0x000045c4  adrp     x2, #0x14000
0x000045c8  add      x2, x2, #0x988 ; -> CFSTR("HEAD")
0x000045cc  mov      x0, x19
0x000045d0  bl       #0xe260 ; call objc_stub[setHTTPMethod:]
0x000045d4  fmov     d0, #15.00000000
0x000045d8  mov      x0, x19
0x000045dc  bl       #0xe320 ; call objc_stub[setTimeoutInterval:]
0x000045e0  mov      x0, x19
0x000045e4  mov      w2, #1
0x000045e8  bl       #0xe200 ; call objc_stub[setCachePolicy:]
0x000045ec  adrp     x8, #0x18000
0x000045f0  ldr      x0, [x8, #0x420] ; -> [classref(NSURLSession)]
0x000045f4  bl       #0xe360 ; call objc_stub[sharedSession]
0x000045f8  mov      x29, x29
0x000045fc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00004600  mov      x20, x0
0x00004604  adrp     x3, #0x14000
0x00004608  add      x3, x3, #0x5c8 ; -> __DATA_CONST,__const+0x1c0 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x0000460c  mov      x2, x19
0x00004610  bl       #0xd9c0 ; call objc_stub[dataTaskWithRequest:completionHandler:]
0x00004614  mov      x29, x29
0x00004618  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000461c  mov      x21, x0
0x00004620  bl       #0xe140 ; call objc_stub[resume]
0x00004624  mov      x0, x21
0x00004628  bl       #0xd4b8 ; call stub:_objc_release
0x0000462c  mov      x0, x20
0x00004630  bl       #0xd4b8 ; call stub:_objc_release
0x00004634  mov      x0, x19
0x00004638  ldp      x29, x30, [sp, #0x20]
0x0000463c  ldp      x20, x19, [sp, #0x10]
0x00004640  ldp      x22, x21, [sp], #0x30
0x00004644  b        #0xd4b8 ; call stub:_objc_release
