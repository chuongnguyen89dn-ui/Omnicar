; ==== sub_22e1c @ 0x22e1c..0x22e50 (52 bytes) ====
0x00022e1c  mov      x0, x19
0x00022e20  mov      x2, x20
0x00022e24  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022e28  mov      x0, x20
0x00022e2c  bl       #0x2480c   ; call _objc_release
0x00022e30  ldr      x0, [x21, #0x2a0]
0x00022e34  adrp     x8, #0x3e000
0x00022e38  ldr      x2, [x8, #0xbc8]
0x00022e3c  bl       #0x26340   ; objc_msgSend: numberWithInteger:
0x00022e40  mov      x29, x29
0x00022e44  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022e48  mov      x20, x0
0x00022e4c  adrp     x3, #0x38000
