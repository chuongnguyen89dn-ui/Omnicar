; ==== sub_96f8 @ 0x96f8..0x9734 (60 bytes) ====
0x000096f8  stp      x0, x20, [sp]
0x000096fc  adrp     x2, #0x35000
0x00009700  add      x2, x2, #0x970   ; -> @"%@ %@"
0x00009704  mov      x0, x21
0x00009708  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000970c  mov      x29, x29
0x00009710  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009714  mov      x21, x0
0x00009718  mov      x0, x22
0x0000971c  bl       #0x2480c   ; call _objc_release
0x00009720  adrp     x24, #0x3e000
0x00009724  ldr      x22, [x24, #0xa20]
0x00009728  mov      x0, x22
0x0000972c  bl       #0x24818   ; call _objc_retain
0x00009730  mov      x0, x22
