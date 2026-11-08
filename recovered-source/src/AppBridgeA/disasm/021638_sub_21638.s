; ==== sub_21638 @ 0x21638..0x21674 (60 bytes) ====
0x00021638  mov      x29, x29
0x0002163c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021640  mov      x22, x0
0x00021644  ldr      x0, [x24, #0x310]
0x00021648  bl       #0x247d0   ; call _objc_opt_class
0x0002164c  mov      x1, x0
0x00021650  mov      x0, x22
0x00021654  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x00021658  tbz      w0, #0, #0x21764
0x0002165c  movi     v0.16b, #0
0x00021660  stp      q0, q0, [sp, #0xe0]
0x00021664  stp      q0, q0, [sp, #0xc0]
0x00021668  mov      x0, x22
0x0002166c  bl       #0x24818   ; call _objc_retain
0x00021670  add      x2, sp, #0xc0
