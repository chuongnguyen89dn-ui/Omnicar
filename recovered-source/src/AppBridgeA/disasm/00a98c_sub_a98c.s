; ==== sub_a98c @ 0xa98c..0xaa70 (228 bytes) ====
0x0000a98c  ldr      x0, [x0, x8]
0x0000a990  ret      
0x0000a994  stp      x22, x21, [sp, #-0x30]!
0x0000a998  stp      x20, x19, [sp, #0x10]
0x0000a99c  stp      x29, x30, [sp, #0x20]
0x0000a9a0  add      x29, sp, #0x20
0x0000a9a4  mov      x19, x2
0x0000a9a8  mov      x20, x0
0x0000a9ac  adrp     x8, #0x3e000
0x0000a9b0  ldrsw    x21, [x8, #0x4d4]
0x0000a9b4  mov      x0, x2
0x0000a9b8  bl       #0x24818   ; call _objc_retain
0x0000a9bc  ldr      x0, [x20, x21]
0x0000a9c0  str      x19, [x20, x21]
0x0000a9c4  ldp      x29, x30, [sp, #0x20]
0x0000a9c8  ldp      x20, x19, [sp, #0x10]
0x0000a9cc  ldp      x22, x21, [sp], #0x30
0x0000a9d0  b        #0x2480c   ; call _objc_release
0x0000a9d4  adrp     x8, #0x3e000
0x0000a9d8  ldrsw    x8, [x8, #0x4d4]
0x0000a9dc  add      x0, x0, x8
0x0000a9e0  mov      x1, #0
0x0000a9e4  b        #0x24860   ; call _objc_storeStrong
0x0000a9e8  stp      x20, x19, [sp, #-0x20]!
0x0000a9ec  stp      x29, x30, [sp, #0x10]
0x0000a9f0  add      x29, sp, #0x10
0x0000a9f4  adrp     x8, #0x3e000
0x0000a9f8  ldr      x8, [x8, #0xa38]
0x0000a9fc  cmn      x8, #1
0x0000aa00  b.ne     #0xaa24
0x0000aa04  adrp     x8, #0x3e000
0x0000aa08  ldr      x19, [x8, #0xa30]
0x0000aa0c  mov      x0, x19
0x0000aa10  bl       #0x24818   ; call _objc_retain
0x0000aa14  mov      x0, x19
0x0000aa18  ldp      x29, x30, [sp, #0x10]
0x0000aa1c  ldp      x20, x19, [sp], #0x20
0x0000aa20  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x0000aa24  bl       #0x241b8   ; call sub_241b8
0x0000aa28  b        #0xaa04   ; call sub_aa04
0x0000aa2c  stp      x20, x19, [sp, #-0x20]!
0x0000aa30  stp      x29, x30, [sp, #0x10]
0x0000aa34  add      x29, sp, #0x10
0x0000aa38  adrp     x8, #0x3e000
0x0000aa3c  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x0000aa40  bl       #0x247e8   ; call _objc_opt_new
0x0000aa44  adrp     x20, #0x3e000
0x0000aa48  ldr      x8, [x20, #0xa30]
0x0000aa4c  str      x0, [x20, #0xa30]
0x0000aa50  mov      x0, x8
0x0000aa54  bl       #0x2480c   ; call _objc_release
0x0000aa58  adrp     x8, #0x3e000
0x0000aa5c  ldr      x0, [x8, #0x318]   ; -> [class(NSMutableArray)]
0x0000aa60  bl       #0x24dc0   ; objc_msgSend: array
0x0000aa64  mov      x29, x29
0x0000aa68  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000aa6c  mov      x19, x0
