; ==== sub_1a3e8 @ 0x1a3e8..0x1a6b4 (716 bytes) ====
0x0001a3e8  mov      x21, x0
0x0001a3ec  mov      w0, #0
0x0001a3f0  bl       #0x23cb0   ; call _OMCLogoMeshImage
0x0001a3f4  mov      x29, x29
0x0001a3f8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a3fc  mov      x23, x0
0x0001a400  mov      x0, x21
0x0001a404  mov      x2, x23
0x0001a408  bl       #0x25a60   ; objc_msgSend: initWithImage:
0x0001a40c  str      x0, [sp, #8]
0x0001a410  mov      x0, x23
0x0001a414  bl       #0x2480c   ; call _objc_release
0x0001a418  mov      x0, x20
0x0001a41c  bl       #0x253a0   ; objc_msgSend: contentView
0x0001a420  mov      x29, x29
0x0001a424  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a428  mov      x23, x0
0x0001a42c  ldr      x21, [sp, #8]
0x0001a430  bl       #0x24f40   ; objc_msgSend: bounds
0x0001a434  mov      x0, x21
0x0001a438  bl       #0x26f80   ; objc_msgSend: setFrame:
0x0001a43c  mov      x0, x23
0x0001a440  bl       #0x2480c   ; call _objc_release
0x0001a444  mov      x0, x21
0x0001a448  mov      x2, #0
0x0001a44c  bl       #0x26de0   ; objc_msgSend: setContentMode:
0x0001a450  ldr      x0, [sp, #8]
0x0001a454  mov      w2, #0x12
0x0001a458  bl       #0x26c00   ; objc_msgSend: setAutoresizingMask:
0x0001a45c  mov      x0, x20
0x0001a460  bl       #0x253a0   ; objc_msgSend: contentView
0x0001a464  mov      x29, x29
0x0001a468  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a46c  mov      x23, x0
0x0001a470  ldr      x2, [sp, #8]
0x0001a474  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x0001a478  mov      x0, x23
0x0001a47c  bl       #0x2480c   ; call _objc_release
0x0001a480  mov      x0, x20
0x0001a484  bl       #0x25f00   ; objc_msgSend: layer
0x0001a488  mov      x29, x29
0x0001a48c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a490  mov      x23, x0
0x0001a494  fmov     d0, #20.00000000
0x0001a498  bl       #0x26e20   ; objc_msgSend: setCornerRadius:
0x0001a49c  mov      x0, x23
0x0001a4a0  bl       #0x2480c   ; call _objc_release
0x0001a4a4  mov      x0, x20
0x0001a4a8  bl       #0x25f00   ; objc_msgSend: layer
0x0001a4ac  mov      x29, x29
0x0001a4b0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a4b4  mov      x23, x0
0x0001a4b8  adrp     x8, #0x34000
0x0001a4bc  ldr      x8, [x8, #0x580]   ; -> [got:_kCACornerCurveContinuous]
0x0001a4c0  ldr      x24, [x8]   ; -> [got:___objc_personality_v0]
0x0001a4c4  mov      x2, x24
0x0001a4c8  bl       #0x26e00   ; objc_msgSend: setCornerCurve:
0x0001a4cc  mov      x0, x23
0x0001a4d0  bl       #0x2480c   ; call _objc_release
0x0001a4d4  mov      x0, x20
0x0001a4d8  bl       #0x25f00   ; objc_msgSend: layer
0x0001a4dc  mov      x29, x29
0x0001a4e0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a4e4  mov      x23, x0
0x0001a4e8  fmov     d0, #1.00000000
0x0001a4ec  bl       #0x26ca0   ; objc_msgSend: setBorderWidth:
0x0001a4f0  mov      x0, x23
0x0001a4f4  bl       #0x2480c   ; call _objc_release
0x0001a4f8  adrp     x8, #0x3e000
0x0001a4fc  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x0001a500  adrp     x8, #0x2b000
0x0001a504  ldr      d8, [x8, #0x258]
0x0001a508  fmov     d0, #1.00000000
0x0001a50c  mov      v1.16b, v8.16b
0x0001a510  bl       #0x25240   ; objc_msgSend: colorWithWhite:alpha:
0x0001a514  mov      x29, x29
0x0001a518  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a51c  mov      x23, x0
0x0001a520  bl       #0x24824   ; call _objc_retainAutorelease
0x0001a524  bl       #0x249e0   ; objc_msgSend: CGColor
0x0001a528  mov      x26, x0
0x0001a52c  mov      x0, x20
0x0001a530  bl       #0x25f00   ; objc_msgSend: layer
0x0001a534  mov      x29, x29
0x0001a538  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a53c  mov      x25, x0
0x0001a540  mov      x2, x26
0x0001a544  bl       #0x26c80   ; objc_msgSend: setBorderColor:
0x0001a548  mov      x0, x25
0x0001a54c  bl       #0x2480c   ; call _objc_release
0x0001a550  mov      x0, x23
0x0001a554  bl       #0x2480c   ; call _objc_release
0x0001a558  mov      x0, x20
0x0001a55c  mov      w2, #1
0x0001a560  bl       #0x26d80   ; objc_msgSend: setClipsToBounds:
0x0001a564  mov      x0, x20
0x0001a568  mov      w2, #0
0x0001a56c  bl       #0x279e0   ; objc_msgSend: setUserInteractionEnabled:
0x0001a570  mov      x0, x19
0x0001a574  mov      x2, x20
0x0001a578  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x0001a57c  mov      x0, x22
0x0001a580  mov      x2, x20
0x0001a584  bl       #0x26fe0   ; objc_msgSend: setGlass:
0x0001a588  adrp     x8, #0x3e000
0x0001a58c  ldr      x0, [x8, #0x2d0]   ; -> [class(UIView)]
0x0001a590  bl       #0x247e8   ; call _objc_opt_new
0x0001a594  mov      x23, x0
0x0001a598  adrp     x8, #0x3e000
0x0001a59c  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x0001a5a0  fmov     d0, #1.00000000
0x0001a5a4  mov      v1.16b, v8.16b
0x0001a5a8  bl       #0x25240   ; objc_msgSend: colorWithWhite:alpha:
0x0001a5ac  mov      x29, x29
0x0001a5b0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a5b4  mov      x25, x0
0x0001a5b8  mov      x0, x23
0x0001a5bc  mov      x2, x25
0x0001a5c0  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x0001a5c4  mov      x0, x25
0x0001a5c8  bl       #0x2480c   ; call _objc_release
0x0001a5cc  mov      x0, x23
0x0001a5d0  bl       #0x25f00   ; objc_msgSend: layer
0x0001a5d4  mov      x29, x29
0x0001a5d8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a5dc  mov      x25, x0
0x0001a5e0  fmov     d0, #12.00000000
0x0001a5e4  bl       #0x26e20   ; objc_msgSend: setCornerRadius:
0x0001a5e8  mov      x0, x25
0x0001a5ec  bl       #0x2480c   ; call _objc_release
0x0001a5f0  mov      x0, x23
0x0001a5f4  bl       #0x25f00   ; objc_msgSend: layer
0x0001a5f8  mov      x29, x29
0x0001a5fc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a600  mov      x25, x0
0x0001a604  mov      x2, x24
0x0001a608  bl       #0x26e00   ; objc_msgSend: setCornerCurve:
0x0001a60c  mov      x0, x25
0x0001a610  bl       #0x2480c   ; call _objc_release
0x0001a614  mov      x0, x23
0x0001a618  bl       #0x25f00   ; objc_msgSend: layer
0x0001a61c  mov      x29, x29
0x0001a620  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a624  mov      x24, x0
0x0001a628  fmov     d0, #1.00000000
0x0001a62c  bl       #0x26ca0   ; objc_msgSend: setBorderWidth:
0x0001a630  mov      x0, x24
0x0001a634  bl       #0x2480c   ; call _objc_release
0x0001a638  adrp     x8, #0x3e000
0x0001a63c  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x0001a640  bl       #0x281c0   ; objc_msgSend: whiteColor
0x0001a644  mov      x29, x29
0x0001a648  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a64c  mov      x24, x0
0x0001a650  bl       #0x24824   ; call _objc_retainAutorelease
0x0001a654  bl       #0x249e0   ; objc_msgSend: CGColor
0x0001a658  mov      x26, x0
0x0001a65c  mov      x0, x23
0x0001a660  bl       #0x25f00   ; objc_msgSend: layer
0x0001a664  mov      x29, x29
0x0001a668  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a66c  mov      x25, x0
0x0001a670  mov      x2, x26
0x0001a674  bl       #0x26c80   ; objc_msgSend: setBorderColor:
0x0001a678  mov      x0, x25
0x0001a67c  bl       #0x2480c   ; call _objc_release
0x0001a680  mov      x0, x24
0x0001a684  bl       #0x2480c   ; call _objc_release
0x0001a688  mov      x0, x19
0x0001a68c  mov      x2, x23
0x0001a690  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x0001a694  mov      x0, x22
0x0001a698  mov      x2, x23
0x0001a69c  bl       #0x26f00   ; objc_msgSend: setField:
0x0001a6a0  adrp     x8, #0x3e000
0x0001a6a4  ldr      x0, [x8, #0x3d8]   ; -> [class(UILabel)]
0x0001a6a8  bl       #0x247e8   ; call _objc_opt_new
0x0001a6ac  mov      x24, x0
0x0001a6b0  adrp     x21, #0x3e000
