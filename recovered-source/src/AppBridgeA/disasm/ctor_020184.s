; ==== __mod_init_2 @ 0x20184..0x203e4 (608 bytes) ====
0x00020184  sub      sp, sp, #0x50
0x00020188  stp      x20, x19, [sp, #0x30]
0x0002018c  stp      x29, x30, [sp, #0x40]
0x00020190  add      x29, sp, #0x40
0x00020194  adrp     x8, #0x3e000
0x00020198  ldr      x0, [x8, #0x408]   ; -> [class(NSProcessInfo)]
0x0002019c  bl       #0x266c0   ; objc_msgSend: processInfo
0x000201a0  mov      x29, x29
0x000201a4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000201a8  mov      x20, x0
0x000201ac  bl       #0x266e0   ; objc_msgSend: processName
0x000201b0  mov      x29, x29
0x000201b4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000201b8  mov      x19, x0
0x000201bc  mov      x0, x20
0x000201c0  bl       #0x2480c   ; call _objc_release
0x000201c4  adrp     x2, #0x37000
0x000201c8  add      x2, x2, #0xe30   ; -> @"SpringBoard"
0x000201cc  mov      x0, x19
0x000201d0  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x000201d4  tbnz     w0, #0, #0x201ec
0x000201d8  adrp     x2, #0x37000
0x000201dc  add      x2, x2, #0xe50   ; -> @"CarPlay"
0x000201e0  mov      x0, x19
0x000201e4  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x000201e8  cbz      w0, #0x2023c
0x000201ec  adrp     x8, #0x34000
0x000201f0  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x000201f4  str      x8, [sp, #8]
0x000201f8  adrp     x8, #0x2b000
0x000201fc  ldr      d0, [x8, #0x1d0]
0x00020200  str      d0, [sp, #0x10]
0x00020204  adrp     x8, #0x20000
0x00020208  add      x8, x8, #0x254
0x0002020c  adrp     x9, #0x34000
0x00020210  add      x9, x9, #0xba0
0x00020214  stp      x8, x9, [sp, #0x18]
0x00020218  mov      x0, x19
0x0002021c  bl       #0x24818   ; call _objc_retain
0x00020220  str      x19, [sp, #0x28]
0x00020224  adrp     x0, #0x34000
0x00020228  ldr      x0, [x0, #0x290]   ; -> [got:__dispatch_main_q]
0x0002022c  add      x1, sp, #8
0x00020230  bl       #0x24554   ; call _dispatch_async
0x00020234  ldr      x0, [sp, #0x28]
0x00020238  bl       #0x2480c   ; call _objc_release
0x0002023c  mov      x0, x19
0x00020240  bl       #0x2480c   ; call _objc_release
0x00020244  ldp      x29, x30, [sp, #0x40]
0x00020248  ldp      x20, x19, [sp, #0x30]
0x0002024c  add      sp, sp, #0x50
0x00020250  ret      
0x00020254  sub      sp, sp, #0x80
0x00020258  stp      x22, x21, [sp, #0x50]
0x0002025c  stp      x20, x19, [sp, #0x60]
0x00020260  stp      x29, x30, [sp, #0x70]
0x00020264  add      x29, sp, #0x70
0x00020268  mov      x19, x0
0x0002026c  adrp     x8, #0x34000
0x00020270  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00020274  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00020278  stur     x8, [x29, #-0x28]
0x0002027c  adrp     x21, #0x3e000
0x00020280  ldr      x0, [x21, #0x290]   ; -> [class(NSString)]
0x00020284  ldr      x10, [x19, #0x20]
0x00020288  adrp     x8, #0x2a000
0x0002028c  add      x8, x8, #0x99e   ; -> "1.0.3"
0x00020290  adrp     x9, #0x2a000
0x00020294  add      x9, x9, #0x996   ; -> "fbebb21"
0x00020298  stp      x8, x10, [sp, #8]
0x0002029c  str      x9, [sp]
0x000202a0  adrp     x2, #0x37000
0x000202a4  add      x2, x2, #0xe70   ; -> @"build %s (%s) loaded into %@"
0x000202a8  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x000202ac  mov      x29, x29
0x000202b0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000202b4  mov      x20, x0
0x000202b8  adrp     x0, #0x34000
0x000202bc  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x000202c0  mov      x1, x20
0x000202c4  bl       #0x1dd30   ; call _OMCLogWrite
0x000202c8  mov      x0, x20
0x000202cc  bl       #0x2480c   ; call _objc_release
0x000202d0  ldr      x0, [x21, #0x290]   ; -> [class(NSString)]
0x000202d4  ldr      x10, [x19, #0x20]
0x000202d8  adrp     x8, #0x29000
0x000202dc  add      x8, x8, #0x94   ; -> "AppBridge"
0x000202e0  adrp     x9, #0x37000
0x000202e4  add      x9, x9, #0xeb0   ; -> @"diagLoaded."
0x000202e8  stp      x8, x10, [sp, #8]
0x000202ec  str      x9, [sp]
0x000202f0  adrp     x2, #0x37000
0x000202f4  add      x2, x2, #0xe90   ; -> @"%@%s@%@"
0x000202f8  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x000202fc  mov      x29, x29
0x00020300  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020304  mov      x19, x0
0x00020308  adrp     x8, #0x37000
0x0002030c  add      x8, x8, #0xed0   ; -> @"version"
0x00020310  adrp     x9, #0x37000
0x00020314  add      x9, x9, #0xef0   ; -> @"1.0.3"
0x00020318  adrp     x10, #0x37000
0x0002031c  add      x10, x10, #0xf10   ; -> @"build"
0x00020320  stp      x8, x10, [sp, #0x18]
0x00020324  adrp     x8, #0x37000
0x00020328  add      x8, x8, #0xf30   ; -> @"fbebb21"
0x0002032c  stp      x9, x8, [sp, #0x30]
0x00020330  adrp     x8, #0x37000
0x00020334  add      x8, x8, #0xf50   ; -> @"date"
0x00020338  str      x8, [sp, #0x28]
0x0002033c  adrp     x8, #0x3e000
0x00020340  ldr      x0, [x8, #0x418]   ; -> [class(NSDate)]
0x00020344  bl       #0x25480   ; objc_msgSend: date
0x00020348  mov      x29, x29
0x0002034c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020350  mov      x20, x0
0x00020354  str      x0, [sp, #0x40]
0x00020358  adrp     x8, #0x3e000
0x0002035c  ldr      x0, [x8, #0x310]   ; -> [class(NSDictionary)]
0x00020360  add      x2, sp, #0x30
0x00020364  add      x3, sp, #0x18
0x00020368  mov      w4, #3
0x0002036c  bl       #0x255c0   ; objc_msgSend: dictionaryWithObjects:forKeys:count:
0x00020370  mov      x29, x29
0x00020374  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020378  mov      x21, x0
0x0002037c  mov      x0, x20
0x00020380  bl       #0x2480c   ; call _objc_release
0x00020384  adrp     x20, #0x37000
0x00020388  add      x20, x20, #0x70   ; -> @"com.anlai.omnicar"
0x0002038c  mov      x0, x19
0x00020390  mov      x1, x21
0x00020394  mov      x2, x20
0x00020398  bl       #0x242cc   ; call _CFPreferencesSetAppValue
0x0002039c  mov      x0, x20
0x000203a0  bl       #0x242b4   ; call _CFPreferencesAppSynchronize
0x000203a4  mov      x0, x21
0x000203a8  bl       #0x2480c   ; call _objc_release
0x000203ac  mov      x0, x19
0x000203b0  bl       #0x2480c   ; call _objc_release
0x000203b4  ldur     x8, [x29, #-0x28]
0x000203b8  adrp     x9, #0x34000
0x000203bc  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x000203c0  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x000203c4  cmp      x9, x8
0x000203c8  b.ne     #0x203e0
0x000203cc  ldp      x29, x30, [sp, #0x70]
0x000203d0  ldp      x20, x19, [sp, #0x60]
0x000203d4  ldp      x22, x21, [sp, #0x50]
0x000203d8  add      sp, sp, #0x80
0x000203dc  ret      
0x000203e0  bl       #0x24488   ; call ___stack_chk_fail

