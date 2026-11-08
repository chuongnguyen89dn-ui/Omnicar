; ==== sub_10270 @ 0x10270..0x102bc (76 bytes) ====
0x00010270  bl       #0x2480c   ; call _objc_release
0x00010274  mov      x0, x19
0x00010278  bl       #0x2480c   ; call _objc_release
0x0001027c  mov      x0, x21
0x00010280  bl       #0x24470   ; call __Unwind_Resume
0x00010284  stp      d11, d10, [sp, #-0x50]!
0x00010288  stp      d9, d8, [sp, #0x10]
0x0001028c  stp      x22, x21, [sp, #0x20]
0x00010290  stp      x20, x19, [sp, #0x30]
0x00010294  stp      x29, x30, [sp, #0x40]
0x00010298  add      x29, sp, #0x40
0x0001029c  mov      x20, x0
0x000102a0  ldp      d8, d9, [x0, #0x30]
0x000102a4  ldp      d10, d11, [x0, #0x40]
0x000102a8  ldr      x0, [x0, #0x20]
0x000102ac  bl       #0x24f60   ; objc_msgSend: box
0x000102b0  mov      x29, x29
0x000102b4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000102b8  mov      x19, x0
