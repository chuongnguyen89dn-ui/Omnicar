; ==== sub_216e8 @ 0x216e8..0x21744 (92 bytes) ====
0x000216e8  mov      x0, x25
0x000216ec  bl       #0x2480c   ; call _objc_release
0x000216f0  tbz      w21, #0, #0x21734
0x000216f4  mov      x0, x22
0x000216f8  mov      x2, x23
0x000216fc  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00021700  mov      x29, x29
0x00021704  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021708  mov      x25, x0
0x0002170c  bl       #0x261e0   ; objc_msgSend: mutableCopy
0x00021710  mov      x21, x0
0x00021714  mov      x0, x19
0x00021718  mov      x2, x21
0x0002171c  mov      x3, x23
0x00021720  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00021724  mov      x0, x21
0x00021728  bl       #0x2480c   ; call _objc_release
0x0002172c  mov      x0, x25
0x00021730  bl       #0x2480c   ; call _objc_release
0x00021734  add      x28, x28, #1
0x00021738  cmp      x20, x28
0x0002173c  b.ne     #0x21698
0x00021740  add      x2, sp, #0xc0
