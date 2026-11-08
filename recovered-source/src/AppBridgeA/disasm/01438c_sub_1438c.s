; ==== sub_1438c @ 0x1438c..0x14438 (172 bytes) ====
0x0001438c  bl       #0x2480c   ; call _objc_release
0x00014390  mov      x0, x20
0x00014394  bl       #0x2480c   ; call _objc_release
0x00014398  ldr      x22, [sp, #0x80]
0x0001439c  mov      x0, x22
0x000143a0  bl       #0x25620   ; objc_msgSend: dot
0x000143a4  mov      x29, x29
0x000143a8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000143ac  mov      x19, x0
0x000143b0  bl       #0x24818   ; call _objc_retain
0x000143b4  movi     v0.16b, #0
0x000143b8  stp      q0, q0, [sp, #0x110]
0x000143bc  stp      q0, q0, [sp, #0x130]
0x000143c0  mov      x0, x19
0x000143c4  str      x19, [sp, #0x78]
0x000143c8  bl       #0x25f00   ; objc_msgSend: layer
0x000143cc  mov      x29, x29
0x000143d0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000143d4  mov      x19, x0
0x000143d8  bl       #0x27d80   ; objc_msgSend: sublayers
0x000143dc  mov      x29, x29
0x000143e0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000143e4  mov      x21, x0
0x000143e8  mov      x0, x19
0x000143ec  bl       #0x2480c   ; call _objc_release
0x000143f0  add      x2, sp, #0x110
0x000143f4  add      x3, sp, #0x160
0x000143f8  mov      x0, x21
0x000143fc  mov      w4, #0x10
0x00014400  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00014404  mov      x23, #0
0x00014408  mov      x28, #0
0x0001440c  mov      x22, x0
0x00014410  cbz      x0, #0x144f4
0x00014414  ldr      x8, [sp, #0x120]
0x00014418  ldr      x26, [x8]
0x0001441c  mov      x24, #0
0x00014420  ldr      x8, [sp, #0x120]
0x00014424  ldr      x8, [x8]
0x00014428  cmp      x8, x26
0x0001442c  b.eq     #0x14438
0x00014430  mov      x0, x21
0x00014434  bl       #0x24770   ; call _objc_enumerationMutation
