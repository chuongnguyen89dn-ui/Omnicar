; ==== sub_2141c @ 0x2141c..0x2144c (48 bytes) ====
0x0002141c  adrp     x2, #0x38000
0x00021420  add      x2, x2, #0x250   ; -> @"currentSession"
0x00021424  bl       #0x28100   ; objc_msgSend: valueForKey:
0x00021428  mov      x29, x29
0x0002142c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021430  mov      x19, x0
0x00021434  cbz      x0, #0x214e4
0x00021438  mov      x0, x19
0x0002143c  bl       #0x21d6c   ; call sub_21d6c
0x00021440  mov      x29, x29
0x00021444  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021448  mov      x20, x0
