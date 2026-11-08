; ==== sub_213e4 @ 0x213e4..0x21414 (48 bytes) ====
0x000213e4  str      x0, [x9, #0xb40]
0x000213e8  mov      x0, x8
0x000213ec  bl       #0x2480c   ; call _objc_release
0x000213f0  adrp     x8, #0x3e000
0x000213f4  ldr      x19, [x8, #0xb40]
0x000213f8  adrp     x0, #0x38000
0x000213fc  add      x0, x0, #0x250   ; -> @"currentSession"
0x00021400  bl       #0x2441c   ; call _NSSelectorFromString
0x00021404  mov      x1, x0
0x00021408  mov      x0, x19
0x0002140c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00021410  tbz      w0, #0, #0x214e4
