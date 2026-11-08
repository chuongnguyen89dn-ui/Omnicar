; ==== sub_13e68 @ 0x13e68..0x14284 (1052 bytes) ====
0x00013e68  mov      x26, x0
0x00013e6c  mov      w2, #0
0x00013e70  bl       #0x279e0   ; objc_msgSend: setUserInteractionEnabled:
0x00013e74  adrp     x8, #0x3e000
0x00013e78  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x00013e7c  bl       #0x251a0   ; objc_msgSend: clearColor
0x00013e80  mov      x29, x29
0x00013e84  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013e88  mov      x19, x0
0x00013e8c  mov      x0, x26
0x00013e90  mov      x2, x19
0x00013e94  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x00013e98  mov      x0, x19
0x00013e9c  bl       #0x2480c   ; call _objc_release
0x00013ea0  mov      x0, x26
0x00013ea4  bl       #0x25f00   ; objc_msgSend: layer
0x00013ea8  mov      x29, x29
0x00013eac  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013eb0  mov      x20, x0
0x00013eb4  fmov     d0, #7.00000000
0x00013eb8  bl       #0x26e20   ; objc_msgSend: setCornerRadius:
0x00013ebc  mov      x0, x20
0x00013ec0  bl       #0x2480c   ; call _objc_release
0x00013ec4  adrp     x8, #0x3e000
0x00013ec8  ldr      x0, [x8, #0x350]   ; -> [class(UIVisualEffectView)]
0x00013ecc  bl       #0x2471c   ; call _objc_alloc
0x00013ed0  mov      x19, x0
0x00013ed4  adrp     x8, #0x3e000
0x00013ed8  ldr      x0, [x8, #0x358]   ; -> [class(UIBlurEffect)]
0x00013edc  mov      w2, #0xb
0x00013ee0  bl       #0x25680   ; objc_msgSend: effectWithStyle:
0x00013ee4  mov      x29, x29
0x00013ee8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013eec  mov      x20, x0
0x00013ef0  mov      x0, x19
0x00013ef4  mov      x2, x20
0x00013ef8  bl       #0x25a20   ; objc_msgSend: initWithEffect:
0x00013efc  mov      x28, x0
0x00013f00  mov      x0, x20
0x00013f04  bl       #0x2480c   ; call _objc_release
0x00013f08  mov      x0, x26
0x00013f0c  bl       #0x24f40   ; objc_msgSend: bounds
0x00013f10  mov      x0, x28
0x00013f14  bl       #0x26f80   ; objc_msgSend: setFrame:
0x00013f18  mov      x0, x28
0x00013f1c  mov      w2, #0x12
0x00013f20  bl       #0x26c00   ; objc_msgSend: setAutoresizingMask:
0x00013f24  adrp     x8, #0x3e000
0x00013f28  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x00013f2c  fmov     d0, #1.00000000
0x00013f30  ldr      d1, [sp, #0x48]
0x00013f34  bl       #0x25240   ; objc_msgSend: colorWithWhite:alpha:
0x00013f38  mov      x29, x29
0x00013f3c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013f40  mov      x20, x0
0x00013f44  mov      x0, x28
0x00013f48  bl       #0x253a0   ; objc_msgSend: contentView
0x00013f4c  mov      x29, x29
0x00013f50  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013f54  mov      x19, x0
0x00013f58  mov      x2, x20
0x00013f5c  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x00013f60  mov      x0, x19
0x00013f64  bl       #0x2480c   ; call _objc_release
0x00013f68  mov      x0, x20
0x00013f6c  bl       #0x2480c   ; call _objc_release
0x00013f70  mov      x0, x28
0x00013f74  bl       #0x25f00   ; objc_msgSend: layer
0x00013f78  mov      x29, x29
0x00013f7c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013f80  mov      x20, x0
0x00013f84  fmov     d0, #7.00000000
0x00013f88  bl       #0x26e20   ; objc_msgSend: setCornerRadius:
0x00013f8c  mov      x0, x20
0x00013f90  bl       #0x2480c   ; call _objc_release
0x00013f94  mov      x0, x28
0x00013f98  mov      w2, #1
0x00013f9c  bl       #0x26d80   ; objc_msgSend: setClipsToBounds:
0x00013fa0  mov      x0, x28
0x00013fa4  mov      w2, #0
0x00013fa8  bl       #0x279e0   ; objc_msgSend: setUserInteractionEnabled:
0x00013fac  mov      x0, x26
0x00013fb0  mov      x2, x28
0x00013fb4  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x00013fb8  mov      x0, x26
0x00013fbc  bl       #0x25f00   ; objc_msgSend: layer
0x00013fc0  mov      x29, x29
0x00013fc4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013fc8  mov      x20, x0
0x00013fcc  fmov     d0, #1.50000000
0x00013fd0  bl       #0x26ca0   ; objc_msgSend: setBorderWidth:
0x00013fd4  mov      x0, x20
0x00013fd8  bl       #0x2480c   ; call _objc_release
0x00013fdc  adrp     x8, #0x3e000
0x00013fe0  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x00013fe4  fmov     d0, #1.00000000
0x00013fe8  ldr      d1, [sp, #0x40]
0x00013fec  bl       #0x25240   ; objc_msgSend: colorWithWhite:alpha:
0x00013ff0  mov      x29, x29
0x00013ff4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013ff8  mov      x20, x0
0x00013ffc  bl       #0x24824   ; call _objc_retainAutorelease
0x00014000  mov      x0, x20
0x00014004  bl       #0x249e0   ; objc_msgSend: CGColor
0x00014008  mov      x19, x0
0x0001400c  mov      x0, x26
0x00014010  bl       #0x25f00   ; objc_msgSend: layer
0x00014014  mov      x29, x29
0x00014018  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001401c  mov      x21, x0
0x00014020  mov      x2, x19
0x00014024  bl       #0x26c80   ; objc_msgSend: setBorderColor:
0x00014028  mov      x0, x21
0x0001402c  bl       #0x2480c   ; call _objc_release
0x00014030  mov      x0, x20
0x00014034  bl       #0x2480c   ; call _objc_release
0x00014038  adrp     x8, #0x3e000
0x0001403c  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x00014040  fmov     d3, #1.00000000
0x00014044  ldp      d1, d0, [sp, #0x30]
0x00014048  mov      v2.16b, v15.16b
0x0001404c  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x00014050  mov      x29, x29
0x00014054  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014058  mov      x20, x0
0x0001405c  bl       #0x24824   ; call _objc_retainAutorelease
0x00014060  mov      x0, x20
0x00014064  bl       #0x249e0   ; objc_msgSend: CGColor
0x00014068  mov      x19, x0
0x0001406c  mov      x0, x26
0x00014070  bl       #0x25f00   ; objc_msgSend: layer
0x00014074  mov      x29, x29
0x00014078  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001407c  mov      x21, x0
0x00014080  mov      x2, x19
0x00014084  bl       #0x276e0   ; objc_msgSend: setShadowColor:
0x00014088  mov      x0, x21
0x0001408c  bl       #0x2480c   ; call _objc_release
0x00014090  mov      x0, x20
0x00014094  bl       #0x2480c   ; call _objc_release
0x00014098  mov      x0, x26
0x0001409c  bl       #0x25f00   ; objc_msgSend: layer
0x000140a0  mov      x29, x29
0x000140a4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000140a8  mov      x19, x0
0x000140ac  mov      v0.16b, v9.16b
0x000140b0  bl       #0x27720   ; objc_msgSend: setShadowOpacity:
0x000140b4  mov      x0, x19
0x000140b8  bl       #0x2480c   ; call _objc_release
0x000140bc  mov      x0, x26
0x000140c0  bl       #0x25f00   ; objc_msgSend: layer
0x000140c4  mov      x29, x29
0x000140c8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000140cc  mov      x20, x0
0x000140d0  fmov     d0, #3.00000000
0x000140d4  bl       #0x27760   ; objc_msgSend: setShadowRadius:
0x000140d8  mov      x0, x20
0x000140dc  bl       #0x2480c   ; call _objc_release
0x000140e0  mov      x0, x26
0x000140e4  bl       #0x25f00   ; objc_msgSend: layer
0x000140e8  mov      x29, x29
0x000140ec  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000140f0  mov      x20, x0
0x000140f4  fmov     d0, xzr
0x000140f8  fmov     d1, #1.00000000
0x000140fc  bl       #0x27700   ; objc_msgSend: setShadowOffset:
0x00014100  mov      x0, x20
0x00014104  bl       #0x2480c   ; call _objc_release
0x00014108  adrp     x8, #0x3e000
0x0001410c  ldr      x0, [x8, #0x3b8]   ; -> [class(CALayer)]
0x00014110  bl       #0x25f00   ; objc_msgSend: layer
0x00014114  mov      x29, x29
0x00014118  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001411c  mov      x21, x0
0x00014120  adrp     x2, #0x36000
0x00014124  add      x2, x2, #0xad0   ; -> @"omcDot"
0x00014128  bl       #0x273c0   ; objc_msgSend: setName:
0x0001412c  fmov     d0, #5.00000000
0x00014130  fmov     d1, #5.00000000
0x00014134  fmov     d2, #4.00000000
0x00014138  fmov     d3, #4.00000000
0x0001413c  mov      x0, x21
0x00014140  bl       #0x26f80   ; objc_msgSend: setFrame:
0x00014144  fmov     d0, #2.00000000
0x00014148  mov      x0, x21
0x0001414c  bl       #0x26e20   ; objc_msgSend: setCornerRadius:
0x00014150  adrp     x8, #0x3e000
0x00014154  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x00014158  fmov     d3, #1.00000000
0x0001415c  mov      v0.16b, v10.16b
0x00014160  mov      v1.16b, v11.16b
0x00014164  mov      v2.16b, v12.16b
0x00014168  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001416c  mov      x29, x29
0x00014170  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014174  mov      x20, x0
0x00014178  bl       #0x24824   ; call _objc_retainAutorelease
0x0001417c  mov      x0, x20
0x00014180  bl       #0x249e0   ; objc_msgSend: CGColor
0x00014184  mov      x2, x0
0x00014188  mov      x0, x21
0x0001418c  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x00014190  mov      x0, x20
0x00014194  bl       #0x2480c   ; call _objc_release
0x00014198  mov      x0, x26
0x0001419c  bl       #0x25f00   ; objc_msgSend: layer
0x000141a0  mov      x29, x29
0x000141a4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000141a8  mov      x19, x0
0x000141ac  mov      x2, x21
0x000141b0  bl       #0x24b80   ; objc_msgSend: addSublayer:
0x000141b4  mov      x0, x19
0x000141b8  bl       #0x2480c   ; call _objc_release
0x000141bc  mov      x0, x27
0x000141c0  mov      x2, x26
0x000141c4  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x000141c8  mov      x0, x27
0x000141cc  mov      x2, x26
0x000141d0  bl       #0x26ec0   ; objc_msgSend: setDot:
0x000141d4  mov      x0, x21
0x000141d8  bl       #0x2480c   ; call _objc_release
0x000141dc  mov      x0, x28
0x000141e0  bl       #0x2480c   ; call _objc_release
0x000141e4  mov      x0, x26
0x000141e8  bl       #0x2480c   ; call _objc_release
0x000141ec  mov      x22, x27
0x000141f0  ldr      x0, [sp, #0x88]
0x000141f4  bl       #0x25e60   ; objc_msgSend: knobViews
0x000141f8  mov      x29, x29
0x000141fc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014200  mov      x19, x0
0x00014204  mov      x2, x27
0x00014208  bl       #0x24b20   ; objc_msgSend: addObject:
0x0001420c  mov      x0, x19
0x00014210  bl       #0x2480c   ; call _objc_release
0x00014214  mov      x22, x27
0x00014218  mov      x0, x22
0x0001421c  bl       #0x27e20   ; objc_msgSend: superview
0x00014220  mov      x29, x29
0x00014224  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014228  mov      x20, x0
0x0001422c  str      x22, [sp, #0x80]
0x00014230  ldr      x0, [sp, #0x88]
0x00014234  bl       #0x281e0   ; objc_msgSend: window
0x00014238  mov      x29, x29
0x0001423c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014240  cmp      x20, x0
0x00014244  cset     w19, eq
0x00014248  bl       #0x2480c   ; call _objc_release
0x0001424c  mov      x0, x20
0x00014250  bl       #0x2480c   ; call _objc_release
0x00014254  tbnz     w19, #0, #0x1427c
0x00014258  ldp      x22, x0, [sp, #0x80]
0x0001425c  bl       #0x281e0   ; objc_msgSend: window
0x00014260  mov      x29, x29
0x00014264  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014268  mov      x19, x0
0x0001426c  mov      x2, x22
0x00014270  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x00014274  mov      x0, x19
0x00014278  bl       #0x2480c   ; call _objc_release
0x0001427c  ldp      x22, x0, [sp, #0x80]
0x00014280  bl       #0x281e0   ; objc_msgSend: window
