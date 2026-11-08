; block literal @0x34bd0 desc @0x34670 sig=v16@?0@"NSNotification"8 flags=0x50000000
; ==== sub_1e284 @ 0x1e284..0x1e384 (256 bytes) ====
0x0001e284  sub      sp, sp, #0x50
0x0001e288  stp      x20, x19, [sp, #0x30]
0x0001e28c  stp      x29, x30, [sp, #0x40]
0x0001e290  add      x29, sp, #0x40
0x0001e294  mov      x0, x1
0x0001e298  bl       #0x280c0   ; objc_msgSend: userInfo
0x0001e29c  mov      x29, x29
0x0001e2a0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e2a4  mov      x20, x0
0x0001e2a8  adrp     x2, #0x37000
0x0001e2ac  add      x2, x2, #0xb30   ; -> @"line"
0x0001e2b0  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0001e2b4  mov      x29, x29
0x0001e2b8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e2bc  mov      x19, x0
0x0001e2c0  mov      x0, x20
0x0001e2c4  bl       #0x2480c   ; call _objc_release
0x0001e2c8  adrp     x8, #0x3e000
0x0001e2cc  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x0001e2d0  bl       #0x247d0   ; call _objc_opt_class
0x0001e2d4  mov      x1, x0
0x0001e2d8  mov      x0, x19
0x0001e2dc  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0001e2e0  tbz      w0, #0, #0x1e348
0x0001e2e4  bl       #0x1df38   ; call sub_1df38
0x0001e2e8  mov      x29, x29
0x0001e2ec  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e2f0  mov      x20, x0
0x0001e2f4  adrp     x8, #0x34000
0x0001e2f8  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x0001e2fc  str      x8, [sp, #8]
0x0001e300  adrp     x8, #0x2b000
0x0001e304  ldr      d0, [x8, #0x1d0]
0x0001e308  str      d0, [sp, #0x10]
0x0001e30c  adrp     x8, #0x1e000
0x0001e310  add      x8, x8, #0x360
0x0001e314  adrp     x9, #0x34000
0x0001e318  add      x9, x9, #0xba0
0x0001e31c  stp      x8, x9, [sp, #0x18]
0x0001e320  mov      x0, x19
0x0001e324  bl       #0x24818   ; call _objc_retain
0x0001e328  str      x19, [sp, #0x28]
0x0001e32c  add      x1, sp, #8
0x0001e330  mov      x0, x20
0x0001e334  bl       #0x24554   ; call _dispatch_async
0x0001e338  mov      x0, x20
0x0001e33c  bl       #0x2480c   ; call _objc_release
0x0001e340  ldr      x0, [sp, #0x28]
0x0001e344  bl       #0x2480c   ; call _objc_release
0x0001e348  mov      x0, x19
0x0001e34c  bl       #0x2480c   ; call _objc_release
0x0001e350  ldp      x29, x30, [sp, #0x40]
0x0001e354  ldp      x20, x19, [sp, #0x30]
0x0001e358  add      sp, sp, #0x50
0x0001e35c  ret      
0x0001e360  stp      x20, x19, [sp, #-0x20]!
0x0001e364  stp      x29, x30, [sp, #0x10]
0x0001e368  add      x29, sp, #0x10
0x0001e36c  mov      x19, x0
0x0001e370  bl       #0x1e094   ; call sub_1e094
0x0001e374  ldr      x0, [x19, #0x20]
0x0001e378  ldp      x29, x30, [sp, #0x10]
0x0001e37c  ldp      x20, x19, [sp], #0x20
0x0001e380  b        #0x1e154   ; call sub_1e154

