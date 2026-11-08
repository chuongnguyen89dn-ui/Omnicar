; ==== sub_1340c @ 0x1340c..0x135ec (480 bytes) ====
0x0001340c  fmov     d2, x8
0x00013410  fmov     d0, xzr
0x00013414  fmov     d1, xzr
0x00013418  fmov     d3, #24.00000000
0x0001341c  bl       #0x25a40   ; objc_msgSend: initWithFrame:
0x00013420  mov      x20, x0
0x00013424  ldr      x0, [x26, #0x2d0]
0x00013428  bl       #0x2471c   ; call _objc_alloc
0x0001342c  mov      x8, #0x4041000000000000
0x00013430  fmov     d2, x8
0x00013434  fmov     d0, #5.00000000
0x00013438  fmov     d1, #6.00000000
0x0001343c  fmov     d3, #12.00000000
0x00013440  bl       #0x25a40   ; objc_msgSend: initWithFrame:
0x00013444  mov      x21, x0
0x00013448  adrp     x27, #0x3e000
0x0001344c  ldr      x0, [x27, #0x320]   ; -> [class(UIColor)]
0x00013450  adrp     x8, #0x2b000
0x00013454  ldr      d1, [x8, #0x268]
0x00013458  fmov     d0, #1.00000000
0x0001345c  bl       #0x25240   ; objc_msgSend: colorWithWhite:alpha:
0x00013460  mov      x29, x29
0x00013464  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013468  mov      x23, x0
0x0001346c  mov      x0, x21
0x00013470  mov      x2, x23
0x00013474  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x00013478  mov      x0, x23
0x0001347c  bl       #0x2480c   ; call _objc_release
0x00013480  mov      x0, x21
0x00013484  bl       #0x25f00   ; objc_msgSend: layer
0x00013488  mov      x29, x29
0x0001348c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013490  mov      x23, x0
0x00013494  fmov     d0, #6.00000000
0x00013498  bl       #0x26e20   ; objc_msgSend: setCornerRadius:
0x0001349c  mov      x0, x23
0x000134a0  bl       #0x2480c   ; call _objc_release
0x000134a4  mov      x0, x21
0x000134a8  bl       #0x25f00   ; objc_msgSend: layer
0x000134ac  mov      x29, x29
0x000134b0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000134b4  mov      x23, x0
0x000134b8  fmov     d0, #0.50000000
0x000134bc  bl       #0x26ca0   ; objc_msgSend: setBorderWidth:
0x000134c0  mov      x0, x23
0x000134c4  bl       #0x2480c   ; call _objc_release
0x000134c8  ldr      x0, [x27, #0x320]   ; -> [class(UIColor)]
0x000134cc  adrp     x8, #0x2b000
0x000134d0  ldr      d1, [x8, #0x2d0]
0x000134d4  fmov     d0, #1.00000000
0x000134d8  bl       #0x25240   ; objc_msgSend: colorWithWhite:alpha:
0x000134dc  mov      x29, x29
0x000134e0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000134e4  mov      x23, x0
0x000134e8  bl       #0x24824   ; call _objc_retainAutorelease
0x000134ec  bl       #0x249e0   ; objc_msgSend: CGColor
0x000134f0  mov      x25, x0
0x000134f4  mov      x0, x21
0x000134f8  bl       #0x25f00   ; objc_msgSend: layer
0x000134fc  mov      x29, x29
0x00013500  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013504  mov      x24, x0
0x00013508  mov      x2, x25
0x0001350c  bl       #0x26c80   ; objc_msgSend: setBorderColor:
0x00013510  mov      x0, x24
0x00013514  bl       #0x2480c   ; call _objc_release
0x00013518  mov      x0, x23
0x0001351c  bl       #0x2480c   ; call _objc_release
0x00013520  mov      x0, x21
0x00013524  mov      w2, #0
0x00013528  bl       #0x279e0   ; objc_msgSend: setUserInteractionEnabled:
0x0001352c  mov      w28, #9
0x00013530  adrp     x8, #0x2b000
0x00013534  ldr      d8, [x8, #0x218]
0x00013538  adrp     x8, #0x2b000
0x0001353c  ldr      d9, [x8, #0x220]
0x00013540  adrp     x8, #0x2b000
0x00013544  ldr      d10, [x8, #0x228]
0x00013548  adrp     x8, #0x2b000
0x0001354c  ldr      d11, [x8, #0x258]
0x00013550  ldr      x0, [x26, #0x2d0]
0x00013554  bl       #0x2471c   ; call _objc_alloc
0x00013558  ucvtf    d0, w28
0x0001355c  fmov     d1, #4.00000000
0x00013560  fmov     d2, #4.00000000
0x00013564  fmov     d3, #4.00000000
0x00013568  bl       #0x25a40   ; objc_msgSend: initWithFrame:
0x0001356c  mov      x23, x0
0x00013570  ldr      x0, [x27, #0x320]   ; -> [class(UIColor)]
0x00013574  fmov     d3, #1.00000000
0x00013578  mov      v0.16b, v8.16b
0x0001357c  mov      v1.16b, v9.16b
0x00013580  mov      v2.16b, v10.16b
0x00013584  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x00013588  mov      x29, x29
0x0001358c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013590  mov      x24, x0
0x00013594  mov      v0.16b, v11.16b
0x00013598  bl       #0x25200   ; objc_msgSend: colorWithAlphaComponent:
0x0001359c  mov      x29, x29
0x000135a0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000135a4  mov      x25, x0
0x000135a8  mov      x0, x23
0x000135ac  mov      x2, x25
0x000135b0  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x000135b4  mov      x0, x25
0x000135b8  bl       #0x2480c   ; call _objc_release
0x000135bc  mov      x0, x24
0x000135c0  bl       #0x2480c   ; call _objc_release
0x000135c4  mov      x0, x23
0x000135c8  bl       #0x25f00   ; objc_msgSend: layer
0x000135cc  mov      x29, x29
0x000135d0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000135d4  mov      x24, x0
0x000135d8  fmov     d0, #2.00000000
0x000135dc  bl       #0x26e20   ; objc_msgSend: setCornerRadius:
0x000135e0  mov      x0, x24
0x000135e4  bl       #0x2480c   ; call _objc_release
0x000135e8  mov      x0, x21
