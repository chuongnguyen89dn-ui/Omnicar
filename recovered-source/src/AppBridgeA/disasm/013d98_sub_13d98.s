; ==== sub_13d98 @ 0x13d98..0x13df8 (96 bytes) ====
0x00013d98  mov      x22, x0
0x00013d9c  mov      x0, x21
0x00013da0  bl       #0x2480c   ; call _objc_release
0x00013da4  mov      x0, x20
0x00013da8  bl       #0x2480c   ; call _objc_release
0x00013dac  cbz      x22, #0x13dbc
0x00013db0  b        #0x14218   ; call sub_14218
0x00013db4  mov      x0, x20
0x00013db8  bl       #0x2480c   ; call _objc_release
0x00013dbc  adrp     x8, #0x3e000
0x00013dc0  ldr      x0, [x8, #0x3b0]   ; -> [class(ABKnobView)]
0x00013dc4  mov      x22, #0
0x00013dc8  bl       #0x2471c   ; call _objc_alloc
0x00013dcc  mov      x22, #0
0x00013dd0  fmov     d0, xzr
0x00013dd4  fmov     d1, xzr
0x00013dd8  mov      v2.16b, v8.16b
0x00013ddc  mov      v3.16b, v8.16b
0x00013de0  bl       #0x25a40   ; objc_msgSend: initWithFrame:
0x00013de4  mov      x27, x0
0x00013de8  mov      w2, #0
0x00013dec  bl       #0x273a0   ; objc_msgSend: setMultipleTouchEnabled:
0x00013df0  adrp     x8, #0x3e000
0x00013df4  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
