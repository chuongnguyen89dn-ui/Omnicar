; ==== sub_13df8 @ 0x13df8..0x13e68 (112 bytes) ====
0x00013df8  fmov     d0, #1.00000000
0x00013dfc  ldr      d1, [sp, #0x58]
0x00013e00  bl       #0x25240   ; objc_msgSend: colorWithWhite:alpha:
0x00013e04  mov      x29, x29
0x00013e08  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013e0c  mov      x19, x0
0x00013e10  mov      x0, x27
0x00013e14  mov      x2, x19
0x00013e18  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x00013e1c  mov      x0, x19
0x00013e20  bl       #0x2480c   ; call _objc_release
0x00013e24  mov      x0, x27
0x00013e28  bl       #0x25f00   ; objc_msgSend: layer
0x00013e2c  mov      x29, x29
0x00013e30  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013e34  mov      x19, x0
0x00013e38  ldr      d0, [sp, #0x50]
0x00013e3c  bl       #0x26e20   ; objc_msgSend: setCornerRadius:
0x00013e40  mov      x0, x19
0x00013e44  bl       #0x2480c   ; call _objc_release
0x00013e48  adrp     x8, #0x3e000
0x00013e4c  ldr      x0, [x8, #0x2d0]   ; -> [class(UIView)]
0x00013e50  bl       #0x2471c   ; call _objc_alloc
0x00013e54  fmov     d0, #26.00000000
0x00013e58  fmov     d1, #26.00000000
0x00013e5c  fmov     d2, #14.00000000
0x00013e60  fmov     d3, #14.00000000
0x00013e64  bl       #0x25a40   ; objc_msgSend: initWithFrame:
