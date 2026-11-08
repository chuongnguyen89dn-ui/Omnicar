; ==== sub_960c @ 0x960c..0x9658 (76 bytes) ====
0x0000960c  adrp     x8, #0x3e000
0x00009610  ldr      x0, [x8, #0x2e8]   ; -> [class(ABKeyboard)]
0x00009614  bl       #0x27b20   ; objc_msgSend: shared
0x00009618  mov      x29, x29
0x0000961c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009620  mov      x19, x0
0x00009624  mov      x2, #0
0x00009628  bl       #0x25900   ; objc_msgSend: hideForApp:
0x0000962c  mov      x0, x19
0x00009630  bl       #0x2480c   ; call _objc_release
0x00009634  adrp     x8, #0x3e000
0x00009638  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x0000963c  bl       #0x27b20   ; objc_msgSend: shared
0x00009640  mov      x29, x29
0x00009644  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009648  mov      x19, x0
0x0000964c  bl       #0x25100   ; objc_msgSend: carDisconnected
0x00009650  mov      x0, x19
0x00009654  bl       #0x2480c   ; call _objc_release
