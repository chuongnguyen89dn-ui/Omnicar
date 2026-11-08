; ==== sub_9658 @ 0x9658..0x9694 (60 bytes) ====
0x00009658  mov      x0, x20
0x0000965c  ldp      x29, x30, [sp, #0x10]
0x00009660  ldp      x20, x19, [sp], #0x20
0x00009664  b        #0x2480c   ; call _objc_release
0x00009668  b        #0x9674   ; call sub_9674
0x0000966c  b        #0x9674   ; call sub_9674
0x00009670  b        #0x9674   ; call sub_9674
0x00009674  mov      x20, x0
0x00009678  mov      x0, x19
0x0000967c  bl       #0x2480c   ; call _objc_release
0x00009680  mov      x0, x20
0x00009684  bl       #0x24470   ; call __Unwind_Resume
0x00009688  adrp     x8, #0x3e000
0x0000968c  ldr      x1, [x8, #0xa10]
0x00009690  mov      w0, #0
