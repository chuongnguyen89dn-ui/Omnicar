; ==== sub_21454 @ 0x21454..0x21484 (48 bytes) ====
0x00021454  adrp     x3, #0x37000
0x00021458  add      x3, x3, #0x950   ; -> @"session"
0x0002145c  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00021460  mov      x0, x20
0x00021464  bl       #0x2480c   ; call _objc_release
0x00021468  adrp     x0, #0x37000
0x0002146c  add      x0, x0, #0x970   ; -> @"configuration"
0x00021470  bl       #0x2441c   ; call _NSSelectorFromString
0x00021474  mov      x1, x0
0x00021478  mov      x0, x19
0x0002147c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00021480  tbz      w0, #0, #0x214dc
