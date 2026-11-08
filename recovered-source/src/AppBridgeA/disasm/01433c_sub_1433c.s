; ==== sub_1433c @ 0x1433c..0x14364 (40 bytes) ====
0x0001433c  mov      x2, #0
0x00014340  ldr      x22, [sp, #0x80]
0x00014344  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x00014348  mov      x29, x29
0x0001434c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014350  mov      x20, x0
0x00014354  bl       #0x25640   ; objc_msgSend: doubleValue
0x00014358  mov      v13.16b, v0.16b
0x0001435c  mov      x0, x19
0x00014360  mov      w2, #1
