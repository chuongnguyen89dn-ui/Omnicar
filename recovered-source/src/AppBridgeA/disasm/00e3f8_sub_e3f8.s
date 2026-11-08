; ==== sub_e3f8 @ 0xe3f8..0xe428 (48 bytes) ====
0x0000e3f8  add      x2, x2, #0xf30
0x0000e3fc  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000e400  mov      x29, x29
0x0000e404  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000e408  mov      x22, x0
0x0000e40c  adrp     x0, #0x34000
0x0000e410  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000e414  mov      x1, x22
0x0000e418  bl       #0x1dd30   ; call _OMCLogWrite
0x0000e41c  mov      x0, x22
0x0000e420  bl       #0x2480c   ; call _objc_release
0x0000e424  ldr      x8, [x21, #0x10]
