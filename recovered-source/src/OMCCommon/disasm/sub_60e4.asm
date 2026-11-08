; === sub_60e4 @ 0x60e4 size=572 ===
0x000060e4  sub      sp, sp, #0x140
0x000060e8  stp      x28, x27, [sp, #0xe0]
0x000060ec  stp      x26, x25, [sp, #0xf0]
0x000060f0  stp      x24, x23, [sp, #0x100]
0x000060f4  stp      x22, x21, [sp, #0x110]
0x000060f8  stp      x20, x19, [sp, #0x120]
0x000060fc  stp      x29, x30, [sp, #0x130]
0x00006100  add      x29, sp, #0x130
0x00006104  adrp     x8, #0x14000
0x00006108  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x0000610c  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x00006110  stur     x8, [x29, #-0x60]
0x00006114  adrp     x0, #0xe000
0x00006118  add      x0, x0, #0xb11 ; -> "SBApplicationController"
0x0000611c  bl       #0xd464 ; call stub:_objc_getClass
0x00006120  adrp     x1, #0x14000
0x00006124  add      x1, x1, #0xe48 ; -> CFSTR("sharedInstance")
0x00006128  bl       #0x6078 ; call sub_6078
0x0000612c  mov      x29, x29
0x00006130  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006134  mov      x19, x0
0x00006138  adrp     x1, #0x14000
0x0000613c  add      x1, x1, #0xe68 ; -> CFSTR("runningApplications")
0x00006140  bl       #0x6078 ; call sub_6078
0x00006144  mov      x29, x29
0x00006148  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000614c  mov      x20, x0
0x00006150  adrp     x8, #0x18000
0x00006154  ldr      x0, [x8, #0x450] ; -> [classref(NSArray)]
0x00006158  bl       #0xd47c ; call stub:_objc_opt_class
0x0000615c  mov      x1, x0
0x00006160  mov      x0, x20
0x00006164  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x00006168  tbz      w0, #0, #0x6188
0x0000616c  mov      x0, x20
0x00006170  bl       #0xd960 ; call objc_stub[count]
0x00006174  cbz      x0, #0x6188
0x00006178  mov      x0, x20
0x0000617c  bl       #0xd4c4 ; call stub:_objc_retain
0x00006180  mov      x21, x20
0x00006184  b        #0x62d0
0x00006188  adrp     x8, #0x18000
0x0000618c  ldr      x0, [x8, #0x458] ; -> [classref(NSMutableArray)]
0x00006190  bl       #0xd740 ; call objc_stub[array]
0x00006194  mov      x29, x29
0x00006198  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000619c  mov      x21, x0
0x000061a0  movi     v0.16b, #0
0x000061a4  stp      q0, q0, [sp, #0x10]
0x000061a8  stp      q0, q0, [sp, #0x30]
0x000061ac  adrp     x1, #0x14000
0x000061b0  add      x1, x1, #0xe88 ; -> CFSTR("allApplications")
0x000061b4  str      x19, [sp, #8]
0x000061b8  mov      x0, x19
0x000061bc  bl       #0x6078 ; call sub_6078
0x000061c0  mov      x29, x29
0x000061c4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000061c8  mov      x22, x0
0x000061cc  add      x2, sp, #0x10
0x000061d0  add      x3, sp, #0x50
0x000061d4  mov      w4, #0x10
0x000061d8  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x000061dc  cbz      x0, #0x62c4
0x000061e0  mov      x24, x0
0x000061e4  ldr      x8, [sp, #0x20]
0x000061e8  ldr      x28, [x8] ; -> [selref(CGContext)]
0x000061ec  adrp     x23, #0x14000
0x000061f0  add      x23, x23, #0xea8 ; -> CFSTR("isRunning")
0x000061f4  adrp     x25, #0x14000
0x000061f8  add      x25, x25, #0xec8 ; -> CFSTR("processState")
0x000061fc  mov      x19, #0
0x00006200  ldr      x8, [sp, #0x20]
0x00006204  ldr      x8, [x8] ; -> [selref(CGContext)]
0x00006208  cmp      x8, x28
0x0000620c  b.eq     #0x6218
0x00006210  mov      x0, x22
0x00006214  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x00006218  ldr      x8, [sp, #0x18]
0x0000621c  ldr      x26, [x8, x19, lsl #3] ; -> [selref(CGContext)]
0x00006220  mov      x0, x26
0x00006224  bl       #0xd4c4 ; call stub:_objc_retain
0x00006228  mov      x0, x23
0x0000622c  bl       #0xd170 ; call stub:_NSSelectorFromString
0x00006230  mov      x27, x0
0x00006234  mov      x0, x26
0x00006238  mov      x1, x27
0x0000623c  bl       #0xd4a0 ; call stub:_objc_opt_respondsToSelector
0x00006240  tbz      w0, #0, #0x6264
0x00006244  mov      x0, x26
0x00006248  mov      x1, x27
0x0000624c  bl       #0xd470 ; call stub:_objc_msgSend
0x00006250  mov      x27, x0
0x00006254  mov      x0, x26
0x00006258  bl       #0xd4b8 ; call stub:_objc_release
0x0000625c  cbnz     w27, #0x6290
0x00006260  b        #0x629c
0x00006264  mov      x0, x26
0x00006268  mov      x1, x25
0x0000626c  bl       #0x6078 ; call sub_6078
0x00006270  mov      x29, x29
0x00006274  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006278  mov      x27, x0
0x0000627c  mov      x0, x26
0x00006280  bl       #0xd4b8 ; call stub:_objc_release
0x00006284  mov      x0, x27
0x00006288  bl       #0xd4b8 ; call stub:_objc_release
0x0000628c  cbz      x27, #0x629c
0x00006290  mov      x0, x21
0x00006294  mov      x2, x26
0x00006298  bl       #0xd6a0 ; call objc_stub[addObject:]
0x0000629c  add      x19, x19, #1
0x000062a0  cmp      x24, x19
0x000062a4  b.ne     #0x6200
0x000062a8  add      x2, sp, #0x10
0x000062ac  add      x3, sp, #0x50
0x000062b0  mov      x0, x22
0x000062b4  mov      w4, #0x10
0x000062b8  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x000062bc  mov      x24, x0
0x000062c0  cbnz     x0, #0x61fc
0x000062c4  mov      x0, x22
0x000062c8  bl       #0xd4b8 ; call stub:_objc_release
0x000062cc  ldr      x19, [sp, #8]
0x000062d0  mov      x0, x20
0x000062d4  bl       #0xd4b8 ; call stub:_objc_release
0x000062d8  mov      x0, x19
0x000062dc  bl       #0xd4b8 ; call stub:_objc_release
0x000062e0  ldur     x8, [x29, #-0x60]
0x000062e4  adrp     x9, #0x14000
0x000062e8  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x000062ec  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x000062f0  cmp      x9, x8
0x000062f4  b.ne     #0x631c
0x000062f8  mov      x0, x21
0x000062fc  ldp      x29, x30, [sp, #0x130]
0x00006300  ldp      x20, x19, [sp, #0x120]
0x00006304  ldp      x22, x21, [sp, #0x110]
0x00006308  ldp      x24, x23, [sp, #0x100]
0x0000630c  ldp      x26, x25, [sp, #0xf0]
0x00006310  ldp      x28, x27, [sp, #0xe0]
0x00006314  add      sp, sp, #0x140
0x00006318  b        #0xd434 ; call stub:_objc_autoreleaseReturnValue
0x0000631c  bl       #0xd1b8 ; call stub:___stack_chk_fail
