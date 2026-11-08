; ==== sub_e308 @ 0xe308..0xe338 (48 bytes) ====
0x0000e308  mov      x1, x20
0x0000e30c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000e310  tbz      w0, #0, #0xe338
0x0000e314  mov      x0, x19
0x0000e318  mov      x1, x20
0x0000e31c  bl       #0x247ac   ; call _objc_msgSend
0x0000e320  mov      x29, x29
0x0000e324  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000e328  mov      x20, x0
0x0000e32c  b        #0xe34c   ; call sub_e34c
0x0000e330  mov      x20, #0
0x0000e334  b        #0xe354   ; call sub_e354
