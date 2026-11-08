; ==== sub_1f408 @ 0x1f408..0x1f430 (40 bytes) ====
0x0001f408  cmp      x0, #6
0x0001f40c  ldr      x8, [sp, #0x78]
0x0001f410  ccmp     x8, #0, #0, hs
0x0001f414  b.ne     #0x1f44c
0x0001f418  mov      x0, x25
0x0001f41c  mov      w2, #5
0x0001f420  bl       #0x27da0   ; objc_msgSend: substringFromIndex:
0x0001f424  mov      x29, x29
0x0001f428  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f42c  str      x0, [sp, #0x78]
