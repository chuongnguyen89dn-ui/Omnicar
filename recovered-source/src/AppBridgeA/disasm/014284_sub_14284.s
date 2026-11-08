; ==== sub_14284 @ 0x14284..0x1433c (184 bytes) ====
0x00014284  mov      x29, x29
0x00014288  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001428c  mov      x19, x0
0x00014290  mov      x2, x22
0x00014294  bl       #0x24f80   ; objc_msgSend: bringSubviewToFront:
0x00014298  mov      x0, x19
0x0001429c  bl       #0x2480c   ; call _objc_release
0x000142a0  ldr      x19, [sp, #0x90]
0x000142a4  mov      x0, x19
0x000142a8  ldr      x22, [sp, #0x80]
0x000142ac  bl       #0x25420   ; objc_msgSend: count
0x000142b0  mov      x20, x0
0x000142b4  cmp      x0, #4
0x000142b8  b.lo     #0x142e4
0x000142bc  mov      x0, x19
0x000142c0  mov      w2, #3
0x000142c4  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x000142c8  mov      x29, x29
0x000142cc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000142d0  str      x0, [sp, #0x60]
0x000142d4  ldr      x0, [sp, #0x60]
0x000142d8  bl       #0x25ba0   ; objc_msgSend: intValue
0x000142dc  mov      x2, x0
0x000142e0  b        #0x142ec   ; call sub_142ec
0x000142e4  ldr      x8, [sp, #0x98]
0x000142e8  mov      x2, x8
0x000142ec  mov      x0, x22
0x000142f0  bl       #0x27180   ; objc_msgSend: setIndex:
0x000142f4  cmp      x20, #4
0x000142f8  b.lo     #0x1430c
0x000142fc  ldr      x0, [sp, #0x60]
0x00014300  bl       #0x2480c   ; call _objc_release
0x00014304  ldr      x19, [sp, #0x90]
0x00014308  ldr      x22, [sp, #0x80]
0x0001430c  mov      x0, x19
0x00014310  mov      w2, #2
0x00014314  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x00014318  mov      x29, x29
0x0001431c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014320  mov      x19, x0
0x00014324  bl       #0x24f20   ; objc_msgSend: boolValue
0x00014328  str      w0, [sp, #0x6c]
0x0001432c  mov      x0, x19
0x00014330  bl       #0x2480c   ; call _objc_release
0x00014334  ldr      x19, [sp, #0x90]
0x00014338  mov      x0, x19
