; ==== sub_1e1c4 @ 0x1e1c4..0x1e200 (60 bytes) ====
0x0001e1c4  stp      x29, x30, [sp, #-0x10]!
0x0001e1c8  mov      x29, sp
0x0001e1cc  adrp     x0, #0x37000
0x0001e1d0  add      x0, x0, #0xf90   ; -> @"NSDistributedNotificationCenter"
0x0001e1d4  bl       #0x243f8   ; call _NSClassFromString
0x0001e1d8  cbz      x0, #0x1e1e8
0x0001e1dc  bl       #0x254c0   ; objc_msgSend: defaultCenter
0x0001e1e0  mov      x29, x29
0x0001e1e4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e1e8  ldp      x29, x30, [sp], #0x10
0x0001e1ec  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x0001e1f0  ldr      x0, [x1, #0x20]
0x0001e1f4  b        #0x24818   ; call _objc_retain
0x0001e1f8  ldr      x0, [x0, #0x20]
0x0001e1fc  b        #0x2480c   ; call _objc_release
