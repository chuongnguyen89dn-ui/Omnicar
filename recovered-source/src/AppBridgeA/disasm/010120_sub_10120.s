; ==== sub_10120 @ 0x10120..0x10150 (48 bytes) ====
0x00010120  b        #0x10198   ; call sub_10198
0x00010124  mov      x0, x21
0x00010128  mov      x2, x20
0x0001012c  bl       #0x25f60   ; objc_msgSend: layoutPane:
0x00010130  adrp     x8, #0x3e000
0x00010134  ldr      x23, [x8, #0x290]   ; -> [class(NSString)]
0x00010138  mov      v0.16b, v11.16b
0x0001013c  mov      v1.16b, v10.16b
0x00010140  mov      v2.16b, v9.16b
0x00010144  mov      v3.16b, v8.16b
0x00010148  bl       #0x24440   ; call _NSStringFromCGRect
0x0001014c  mov      x29, x29
