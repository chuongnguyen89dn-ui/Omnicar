; ==== sub_e4c4 @ 0xe4c4..0xe58c (200 bytes) ====
0x0000e4c4  bl       #0x2480c   ; call _objc_release
0x0000e4c8  add      x0, x23, #0x28
0x0000e4cc  bl       #0x24758   ; call _objc_destroyWeak
0x0000e4d0  add      x0, x23, #0x20
0x0000e4d4  bl       #0x24758   ; call _objc_destroyWeak
0x0000e4d8  mov      x0, x20
0x0000e4dc  bl       #0x2480c   ; call _objc_release
0x0000e4e0  mov      x0, x19
0x0000e4e4  bl       #0x2480c   ; call _objc_release
0x0000e4e8  mov      x0, x22
0x0000e4ec  bl       #0x24470   ; call __Unwind_Resume
0x0000e4f0  sub      sp, sp, #0x50
0x0000e4f4  stp      x20, x19, [sp, #0x30]
0x0000e4f8  stp      x29, x30, [sp, #0x40]
0x0000e4fc  add      x29, sp, #0x40
0x0000e500  mov      x19, x0
0x0000e504  adrp     x8, #0x34000
0x0000e508  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x0000e50c  str      x8, [sp]
0x0000e510  adrp     x8, #0x2b000
0x0000e514  ldr      d0, [x8, #0x1d0]
0x0000e518  adrp     x8, #0xe000
0x0000e51c  add      x8, x8, #0x57c
0x0000e520  str      d0, [sp, #8]
0x0000e524  adrp     x9, #0x34000
0x0000e528  add      x9, x9, #0x8c0
0x0000e52c  stp      x8, x9, [sp, #0x10]
0x0000e530  mov      x20, sp
0x0000e534  add      x0, x20, #0x20
0x0000e538  add      x1, x19, #0x20
0x0000e53c  bl       #0x2474c   ; call _objc_copyWeak
0x0000e540  add      x0, x20, #0x28
0x0000e544  add      x1, x19, #0x28
0x0000e548  bl       #0x2474c   ; call _objc_copyWeak
0x0000e54c  adrp     x0, #0x34000
0x0000e550  ldr      x0, [x0, #0x290]   ; -> [got:__dispatch_main_q]
0x0000e554  mov      x1, sp
0x0000e558  bl       #0x24554   ; call _dispatch_async
0x0000e55c  add      x0, x20, #0x28
0x0000e560  bl       #0x24758   ; call _objc_destroyWeak
0x0000e564  add      x0, x20, #0x20
0x0000e568  bl       #0x24758   ; call _objc_destroyWeak
0x0000e56c  ldp      x29, x30, [sp, #0x40]
0x0000e570  ldp      x20, x19, [sp, #0x30]
0x0000e574  add      sp, sp, #0x50
0x0000e578  ret      
0x0000e57c  stp      x22, x21, [sp, #-0x30]!
0x0000e580  stp      x20, x19, [sp, #0x10]
0x0000e584  stp      x29, x30, [sp, #0x20]
0x0000e588  add      x29, sp, #0x20
