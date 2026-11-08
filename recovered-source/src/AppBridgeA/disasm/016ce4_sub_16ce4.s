; ==== sub_16ce4 @ 0x16ce4..0x16e08 (292 bytes) ====
0x00016ce4  ldr      d2, [x8, #0x358]
0x00016ce8  adrp     x8, #0x2b000
0x00016cec  ldr      d3, [x8, #0x360]
0x00016cf0  adrp     x8, #0x2b000
0x00016cf4  ldr      d4, [x8, #0x368]
0x00016cf8  bl       #0x24ee0   ; objc_msgSend: bezierPathWithRoundedRect:cornerRadius:
0x00016cfc  mov      x29, x29
0x00016d00  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016d04  mov      x22, x0
0x00016d08  mov      x0, x21
0x00016d0c  mov      x2, x22
0x00016d10  bl       #0x24d40   ; objc_msgSend: appendPath:
0x00016d14  mov      x0, x22
0x00016d18  bl       #0x2480c   ; call _objc_release
0x00016d1c  b        #0x16b8c   ; call sub_16b8c
0x00016d20  ldr      x0, [x22, #0x20]
0x00016d24  adrp     x2, #0x36000
0x00016d28  add      x2, x2, #0xa30   ; -> @"hm_"
0x00016d2c  bl       #0x258a0   ; objc_msgSend: hasPrefix:
0x00016d30  cbz      w0, #0x16b8c
0x00016d34  fmov     d0, #1.50000000
0x00016d38  mov      x0, x20
0x00016d3c  bl       #0x272c0   ; objc_msgSend: setLineWidth:
0x00016d40  ldr      x0, [x22, #0x20]
0x00016d44  adrp     x2, #0x36000
0x00016d48  add      x2, x2, #0x2b0   ; -> @"hm_apps"
0x00016d4c  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00016d50  cbz      w0, #0x16e48
0x00016d54  ldr      x0, [x24, #0x300]
0x00016d58  adrp     x8, #0x2b000
0x00016d5c  ldr      d8, [x8, #0x338]
0x00016d60  fmov     d0, #4.00000000
0x00016d64  fmov     d1, #4.00000000
0x00016d68  fmov     d2, #7.00000000
0x00016d6c  fmov     d3, #7.00000000
0x00016d70  mov      v4.16b, v8.16b
0x00016d74  bl       #0x24ee0   ; objc_msgSend: bezierPathWithRoundedRect:cornerRadius:
0x00016d78  mov      x29, x29
0x00016d7c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016d80  mov      x23, x0
0x00016d84  mov      x0, x20
0x00016d88  mov      x2, x23
0x00016d8c  bl       #0x24d40   ; objc_msgSend: appendPath:
0x00016d90  mov      x0, x23
0x00016d94  bl       #0x2480c   ; call _objc_release
0x00016d98  ldr      x0, [x24, #0x300]
0x00016d9c  fmov     d0, #13.00000000
0x00016da0  fmov     d1, #4.00000000
0x00016da4  fmov     d2, #7.00000000
0x00016da8  fmov     d3, #7.00000000
0x00016dac  mov      v4.16b, v8.16b
0x00016db0  bl       #0x24ee0   ; objc_msgSend: bezierPathWithRoundedRect:cornerRadius:
0x00016db4  mov      x29, x29
0x00016db8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016dbc  mov      x23, x0
0x00016dc0  mov      x0, x20
0x00016dc4  mov      x2, x23
0x00016dc8  bl       #0x24d40   ; objc_msgSend: appendPath:
0x00016dcc  mov      x0, x23
0x00016dd0  bl       #0x2480c   ; call _objc_release
0x00016dd4  ldr      x0, [x24, #0x300]
0x00016dd8  fmov     d0, #4.00000000
0x00016ddc  fmov     d1, #13.00000000
0x00016de0  fmov     d2, #7.00000000
0x00016de4  fmov     d3, #7.00000000
0x00016de8  mov      v4.16b, v8.16b
0x00016dec  bl       #0x24ee0   ; objc_msgSend: bezierPathWithRoundedRect:cornerRadius:
0x00016df0  mov      x29, x29
0x00016df4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016df8  mov      x23, x0
0x00016dfc  mov      x0, x20
0x00016e00  mov      x2, x23
0x00016e04  bl       #0x24d40   ; objc_msgSend: appendPath:
