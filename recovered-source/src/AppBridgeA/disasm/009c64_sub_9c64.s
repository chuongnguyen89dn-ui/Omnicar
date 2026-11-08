; ==== sub_9c64 @ 0x9c64..0x9cbc (88 bytes) ====
0x00009c64  bl       #0x26120   ; objc_msgSend: mask
0x00009c68  mov      x29, x29
0x00009c6c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009c70  mov      x22, x0
0x00009c74  adrp     x20, #0x3e000
0x00009c78  ldr      x0, [x20, #0x2f8]   ; -> [class(CAShapeLayer)]
0x00009c7c  bl       #0x247d0   ; call _objc_opt_class
0x00009c80  mov      x1, x0
0x00009c84  mov      x0, x22
0x00009c88  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x00009c8c  tbz      w0, #0, #0x9cc0
0x00009c90  mov      x0, x19
0x00009c94  bl       #0x25f00   ; objc_msgSend: layer
0x00009c98  mov      x29, x29
0x00009c9c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009ca0  mov      x23, x0
0x00009ca4  bl       #0x26120   ; objc_msgSend: mask
0x00009ca8  mov      x29, x29
0x00009cac  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009cb0  mov      x20, x0
0x00009cb4  mov      x0, x23
0x00009cb8  bl       #0x2480c   ; call _objc_release
