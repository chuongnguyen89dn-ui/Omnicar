; ==== sub_13364 @ 0x13364..0x133d0 (108 bytes) ====
0x00013364  bl       #0x2480c   ; call _objc_release
0x00013368  b        #0x13370   ; call sub_13370
0x0001336c  mov      x23, x0
0x00013370  mov      x0, x23
0x00013374  bl       #0x24470   ; call __Unwind_Resume
0x00013378  mov      x3, x2
0x0001337c  adrp     x2, #0x36000
0x00013380  add      x2, x2, #0x530   ; -> @"replace"
0x00013384  b        #0x265e0   ; objc_msgSend: postBarAction:from:
0x00013388  mov      x3, x2
0x0001338c  adrp     x2, #0x35000
0x00013390  add      x2, x2, #0x470   ; -> @"pop"
0x00013394  b        #0x265e0   ; objc_msgSend: postBarAction:from:
0x00013398  mov      x3, x2
0x0001339c  adrp     x2, #0x36000
0x000133a0  add      x2, x2, #0x550   ; -> @"full"
0x000133a4  b        #0x265e0   ; objc_msgSend: postBarAction:from:
0x000133a8  mov      x3, x2
0x000133ac  adrp     x2, #0x36000
0x000133b0  add      x2, x2, #0x570   ; -> @"bg"
0x000133b4  b        #0x265e0   ; objc_msgSend: postBarAction:from:
0x000133b8  mov      x3, x2
0x000133bc  adrp     x2, #0x36000
0x000133c0  add      x2, x2, #0x590   ; -> @"close"
0x000133c4  b        #0x265e0   ; objc_msgSend: postBarAction:from:
0x000133c8  stp      d11, d10, [sp, #-0x80]!
0x000133cc  stp      d9, d8, [sp, #0x10]
