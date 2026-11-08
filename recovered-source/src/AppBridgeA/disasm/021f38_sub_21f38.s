; ==== sub_21f38 @ 0x21f38..0x21f7c (68 bytes) ====
0x00021f38  mov      x26, x0
0x00021f3c  mov      x0, x23
0x00021f40  bl       #0x2480c   ; call _objc_release
0x00021f44  mov      x0, x22
0x00021f48  bl       #0x2480c   ; call _objc_release
0x00021f4c  mov      x0, x27
0x00021f50  bl       #0x2480c   ; call _objc_release
0x00021f54  mov      x0, x26
0x00021f58  bl       #0x25fa0   ; objc_msgSend: length
0x00021f5c  mov      x23, x0
0x00021f60  cmp      x0, #0xa1
0x00021f64  b.lo     #0x21fa4
0x00021f68  mov      x0, x26
0x00021f6c  mov      w2, #0xa0
0x00021f70  bl       #0x27dc0   ; objc_msgSend: substringToIndex:
0x00021f74  mov      x29, x29
0x00021f78  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
