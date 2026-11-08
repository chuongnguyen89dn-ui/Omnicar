; ==== sub_10150 @ 0x10150..0x10178 (40 bytes) ====
0x00010150  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010154  mov      x22, x0
0x00010158  mov      x0, x21
0x0001015c  mov      x2, x20
0x00010160  bl       #0x256a0   ; objc_msgSend: effectiveOrientation:
0x00010164  stp      x22, x0, [sp, #8]
0x00010168  str      x19, [sp]
0x0001016c  adrp     x2, #0x36000
0x00010170  add      x2, x2, #0x290   ; -> @"%@ -> %@ (huong %lld)"
0x00010174  mov      x0, x23
