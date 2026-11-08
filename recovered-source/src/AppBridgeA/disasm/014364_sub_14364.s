; ==== sub_14364 @ 0x14364..0x1438c (40 bytes) ====
0x00014364  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x00014368  mov      x29, x29
0x0001436c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014370  mov      x21, x0
0x00014374  bl       #0x25640   ; objc_msgSend: doubleValue
0x00014378  mov      v1.16b, v0.16b
0x0001437c  mov      x0, x22
0x00014380  mov      v0.16b, v13.16b
0x00014384  bl       #0x26d60   ; objc_msgSend: setCenter:
0x00014388  mov      x0, x21
