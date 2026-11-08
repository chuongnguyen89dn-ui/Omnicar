; ==== sub_aa70 @ 0xaa70..0xaad4 (100 bytes) ====
0x0000aa70  ldr      x0, [x20, #0xa30]
0x0000aa74  mov      x2, x19
0x0000aa78  bl       #0x274a0   ; objc_msgSend: setPanes:
0x0000aa7c  mov      x0, x19
0x0000aa80  ldp      x29, x30, [sp, #0x10]
0x0000aa84  ldp      x20, x19, [sp], #0x20
0x0000aa88  b        #0x2480c   ; call _objc_release
0x0000aa8c  mov      x20, x0
0x0000aa90  mov      x0, x19
0x0000aa94  bl       #0x2480c   ; call _objc_release
0x0000aa98  mov      x0, x20
0x0000aa9c  bl       #0x24470   ; call __Unwind_Resume
0x0000aaa0  stp      x20, x19, [sp, #-0x20]!
0x0000aaa4  stp      x29, x30, [sp, #0x10]
0x0000aaa8  add      x29, sp, #0x10
0x0000aaac  bl       #0x26580   ; objc_msgSend: panes
0x0000aab0  mov      x29, x29
0x0000aab4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000aab8  mov      x19, x0
0x0000aabc  bl       #0x25420   ; objc_msgSend: count
0x0000aac0  mov      x20, x0
0x0000aac4  mov      x0, x19
0x0000aac8  bl       #0x2480c   ; call _objc_release
0x0000aacc  mov      x0, x20
0x0000aad0  ldp      x29, x30, [sp, #0x10]
