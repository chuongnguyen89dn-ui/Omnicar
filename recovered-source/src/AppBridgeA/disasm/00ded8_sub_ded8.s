; ==== sub_ded8 @ 0xded8..0xdef8 (32 bytes) ====
0x0000ded8  mov      x0, x19
0x0000dedc  bl       #0x2480c   ; call _objc_release
0x0000dee0  b        #0xdee8   ; call sub_dee8
0x0000dee4  mov      x20, x0
0x0000dee8  mov      x0, x20
0x0000deec  bl       #0x24470   ; call __Unwind_Resume
0x0000def0  sub      sp, sp, #0x80
0x0000def4  stp      x28, x27, [sp, #0x20]
