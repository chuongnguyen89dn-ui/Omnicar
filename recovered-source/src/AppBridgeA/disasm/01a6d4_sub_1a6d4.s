; ==== sub_1a6d4 @ 0x1a6d4..0x1a704 (48 bytes) ====
0x0001a6d4  mov      x25, x0
0x0001a6d8  mov      x0, x24
0x0001a6dc  mov      x2, x25
0x0001a6e0  bl       #0x26f60   ; objc_msgSend: setFont:
0x0001a6e4  mov      x0, x25
0x0001a6e8  bl       #0x2480c   ; call _objc_release
0x0001a6ec  mov      x0, x24
0x0001a6f0  mov      w2, #3
0x0001a6f4  bl       #0x27260   ; objc_msgSend: setLineBreakMode:
0x0001a6f8  mov      x0, x23
0x0001a6fc  mov      x2, x24
0x0001a700  bl       #0x24ba0   ; objc_msgSend: addSubview:
