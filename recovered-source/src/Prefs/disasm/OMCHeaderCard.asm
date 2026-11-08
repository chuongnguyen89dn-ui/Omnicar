=== -[OMCHeaderCard initWithFrame:]  va=0x140d8 size=2640 types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
0x000140d8  sub      sp, sp, #0xc0
0x000140dc  stp      d11, d10, [sp, #0x40]
0x000140e0  stp      d9, d8, [sp, #0x50]
0x000140e4  stp      x28, x27, [sp, #0x60]
0x000140e8  stp      x26, x25, [sp, #0x70]
0x000140ec  stp      x24, x23, [sp, #0x80]
0x000140f0  stp      x22, x21, [sp, #0x90]
0x000140f4  stp      x20, x19, [sp, #0xa0]
0x000140f8  stp      x29, x30, [sp, #0xb0]
0x000140fc  add      x29, sp, #0xb0
0x00014100  adrp     x8, #0x74000
0x00014104  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00014108  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001410c  str      x8, [sp, #0x38]
0x00014110  adrp     x8, #0x8e000
0x00014114  ldr      x8, [x8, #0xd28]   ; @SUPER OMCHeaderCard
0x00014118  stp      x0, x8, [sp]
0x0001411c  adrp     x8, #0x8c000
0x00014120  ldr      x1, [x8, #0x8c8]   ; @SEL "initWithFrame:"
0x00014124  mov      x0, sp
0x00014128  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0001412c  mov      x19, x0
0x00014130  cbz      x0, #0x14ad8
0x00014134  mov      x0, x19
0x00014138  mov      w2, #1
0x0001413c  bl       #0x5bca0   ; CALL objc_msgSend$setPreservesSuperviewLayoutMargins:
0x00014140  adrp     x25, #0x8e000
0x00014144  ldr      x0, [x25, #0x918]   ; @CLASS UIView
0x00014148  bl       #0x55d60   ; CALL _objc_opt_new
0x0001414c  adrp     x8, #0x8e000
0x00014150  ldrsw    x24, [x8, #0xdf4]
0x00014154  ldr      x8, [x19, x24]
0x00014158  str      x0, [x19, x24]
0x0001415c  mov      x0, x8
0x00014160  bl       #0x55d78   ; CALL _objc_release
0x00014164  ldr      x0, [x19, x24]
0x00014168  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0001416c  mov      x29, x29
0x00014170  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014174  mov      x20, x0
0x00014178  fmov     d0, #22.00000000
0x0001417c  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x00014180  mov      x0, x20
0x00014184  bl       #0x55d78   ; CALL _objc_release
0x00014188  adrp     x8, #0x74000
0x0001418c  ldr      x8, [x8, #0x648]   ; @GOT _kCACornerCurveContinuous
0x00014190  ldr      x20, [x8]   ; @GOT ___objc_personality_v0
0x00014194  ldr      x0, [x19, x24]
0x00014198  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0001419c  mov      x29, x29
0x000141a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000141a4  mov      x21, x0
0x000141a8  mov      x2, x20
0x000141ac  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x000141b0  mov      x0, x21
0x000141b4  bl       #0x55d78   ; CALL _objc_release
0x000141b8  adrp     x26, #0x8e000
0x000141bc  ldr      x0, [x26, #0x910]   ; @CLASS UIColor
0x000141c0  adrp     x8, #0x65000
0x000141c4  ldr      d0, [x8, #0x648]
0x000141c8  adrp     x8, #0x65000
0x000141cc  ldr      d1, [x8, #0x650]
0x000141d0  adrp     x8, #0x65000
0x000141d4  ldr      d2, [x8, #0x658]
0x000141d8  fmov     d3, #1.00000000
0x000141dc  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000141e0  mov      x29, x29
0x000141e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000141e8  mov      x21, x0
0x000141ec  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000141f0  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000141f4  mov      x22, x0
0x000141f8  ldr      x0, [x19, x24]
0x000141fc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00014200  mov      x29, x29
0x00014204  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014208  mov      x23, x0
0x0001420c  mov      x2, x22
0x00014210  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x00014214  mov      x0, x23
0x00014218  bl       #0x55d78   ; CALL _objc_release
0x0001421c  mov      x0, x21
0x00014220  bl       #0x55d78   ; CALL _objc_release
0x00014224  ldr      x0, [x19, x24]
0x00014228  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0001422c  mov      x29, x29
0x00014230  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014234  mov      x21, x0
0x00014238  adrp     x8, #0x65000
0x0001423c  ldr      s0, [x8, #0x680]
0x00014240  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x00014244  mov      x0, x21
0x00014248  bl       #0x55d78   ; CALL _objc_release
0x0001424c  ldr      x0, [x19, x24]
0x00014250  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00014254  mov      x29, x29
0x00014258  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001425c  mov      x21, x0
0x00014260  fmov     d0, #16.00000000
0x00014264  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x00014268  mov      x0, x21
0x0001426c  bl       #0x55d78   ; CALL _objc_release
0x00014270  ldr      x0, [x19, x24]
0x00014274  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00014278  mov      x29, x29
0x0001427c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014280  mov      x21, x0
0x00014284  fmov     d0, xzr
0x00014288  fmov     d1, #8.00000000
0x0001428c  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x00014290  mov      x0, x21
0x00014294  bl       #0x55d78   ; CALL _objc_release
0x00014298  ldr      x2, [x19, x24]
0x0001429c  mov      x0, x19
0x000142a0  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x000142a4  ldr      x0, [x25, #0x918]   ; @CLASS UIView
0x000142a8  bl       #0x55d60   ; CALL _objc_opt_new
0x000142ac  adrp     x8, #0x8e000
0x000142b0  ldrsw    x28, [x8, #0xdf8]
0x000142b4  ldr      x8, [x19, x28]
0x000142b8  str      x0, [x19, x28]
0x000142bc  mov      x0, x8
0x000142c0  bl       #0x55d78   ; CALL _objc_release
0x000142c4  ldr      x0, [x19, x28]
0x000142c8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000142cc  mov      x29, x29
0x000142d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000142d4  mov      x21, x0
0x000142d8  fmov     d0, #22.00000000
0x000142dc  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x000142e0  mov      x0, x21
0x000142e4  bl       #0x55d78   ; CALL _objc_release
0x000142e8  ldr      x0, [x19, x28]
0x000142ec  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000142f0  mov      x29, x29
0x000142f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000142f8  mov      x21, x0
0x000142fc  mov      x2, x20
0x00014300  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x00014304  mov      x0, x21
0x00014308  bl       #0x55d78   ; CALL _objc_release
0x0001430c  ldr      x0, [x19, x28]
0x00014310  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00014314  mov      x29, x29
0x00014318  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001431c  mov      x20, x0
0x00014320  fmov     d0, #0.50000000
0x00014324  bl       #0x5a740   ; CALL objc_msgSend$setBorderWidth:
0x00014328  mov      x0, x20
0x0001432c  bl       #0x55d78   ; CALL _objc_release
0x00014330  ldr      x0, [x26, #0x910]   ; @CLASS UIColor
0x00014334  fmov     d0, #1.00000000
0x00014338  fmov     d1, #0.75000000
0x0001433c  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x00014340  mov      x29, x29
0x00014344  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014348  mov      x20, x0
0x0001434c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00014350  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00014354  mov      x21, x0
0x00014358  ldr      x0, [x19, x28]
0x0001435c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00014360  mov      x29, x29
0x00014364  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014368  mov      x22, x0
0x0001436c  mov      x2, x21
0x00014370  bl       #0x5a700   ; CALL objc_msgSend$setBorderColor:
0x00014374  mov      x0, x22
0x00014378  bl       #0x55d78   ; CALL _objc_release
0x0001437c  mov      x0, x20
0x00014380  bl       #0x55d78   ; CALL _objc_release
0x00014384  ldr      x0, [x19, x28]
0x00014388  mov      w2, #1
0x0001438c  bl       #0x5a8a0   ; CALL objc_msgSend$setClipsToBounds:
0x00014390  ldr      x0, [x19, x24]
0x00014394  ldr      x2, [x19, x28]
0x00014398  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0001439c  adrp     x8, #0x8e000
0x000143a0  ldr      x0, [x8, #0xaa0]   ; @CLASS UIVisualEffectView
0x000143a4  bl       #0x55c7c   ; CALL _objc_alloc
0x000143a8  mov      x20, x0
0x000143ac  adrp     x8, #0x8e000
0x000143b0  ldr      x0, [x8, #0xaa8]   ; @CLASS UIBlurEffect
0x000143b4  mov      w2, #7
0x000143b8  bl       #0x57980   ; CALL objc_msgSend$effectWithStyle:
0x000143bc  mov      x29, x29
0x000143c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000143c4  mov      x21, x0
0x000143c8  mov      x0, x20
0x000143cc  mov      x2, x21
0x000143d0  bl       #0x58440   ; CALL objc_msgSend$initWithEffect:
0x000143d4  adrp     x8, #0x8e000
0x000143d8  ldrsw    x20, [x8, #0xdfc]
0x000143dc  ldr      x8, [x19, x20]
0x000143e0  str      x0, [x19, x20]
0x000143e4  mov      x0, x8
0x000143e8  bl       #0x55d78   ; CALL _objc_release
0x000143ec  mov      x0, x21
0x000143f0  bl       #0x55d78   ; CALL _objc_release
0x000143f4  ldr      x0, [x19, x28]
0x000143f8  ldr      x2, [x19, x20]
0x000143fc  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00014400  adrp     x8, #0x8e000
0x00014404  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x00014408  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0001440c  mov      x29, x29
0x00014410  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014414  adrp     x8, #0x8e000
0x00014418  ldrsw    x27, [x8, #0xe00]
0x0001441c  ldr      x8, [x19, x27]
0x00014420  str      x0, [x19, x27]
0x00014424  mov      x0, x8
0x00014428  bl       #0x55d78   ; CALL _objc_release
0x0001442c  adrp     x0, #0x78000
0x00014430  add      x0, x0, #0x528   ; STR "#B7A6FF"
0x00014434  bl       #0x18080   ; CALL _OMCColorFromHex
0x00014438  mov      x29, x29
0x0001443c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014440  mov      x20, x0
0x00014444  adrp     x8, #0x65000
0x00014448  ldr      d8, [x8, #0x660]
0x0001444c  mov      v0.16b, v8.16b
0x00014450  bl       #0x56e80   ; CALL objc_msgSend$colorWithAlphaComponent:
0x00014454  mov      x29, x29
0x00014458  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001445c  mov      x21, x0
0x00014460  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00014464  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00014468  str      x0, [sp, #0x20]
0x0001446c  adrp     x0, #0x78000
0x00014470  add      x0, x0, #0x548   ; STR "#8FD3FF"
0x00014474  bl       #0x18080   ; CALL _OMCColorFromHex
0x00014478  mov      x29, x29
0x0001447c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014480  mov      x22, x0
0x00014484  adrp     x8, #0x65000
0x00014488  ldr      d0, [x8, #0x668]
0x0001448c  bl       #0x56e80   ; CALL objc_msgSend$colorWithAlphaComponent:
0x00014490  mov      x29, x29
0x00014494  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014498  mov      x23, x0
0x0001449c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000144a0  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000144a4  str      x0, [sp, #0x28]
0x000144a8  adrp     x0, #0x78000
0x000144ac  add      x0, x0, #0x568   ; STR "#9DF2D8"
0x000144b0  bl       #0x18080   ; CALL _OMCColorFromHex
0x000144b4  mov      x29, x29
0x000144b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000144bc  mov      x24, x0
0x000144c0  fmov     d0, #0.25000000
0x000144c4  bl       #0x56e80   ; CALL objc_msgSend$colorWithAlphaComponent:
0x000144c8  mov      x29, x29
0x000144cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000144d0  mov      x25, x0
0x000144d4  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000144d8  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000144dc  str      x0, [sp, #0x30]
0x000144e0  adrp     x8, #0x8e000
0x000144e4  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000144e8  add      x2, sp, #0x20
0x000144ec  mov      w3, #3
0x000144f0  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000144f4  mov      x29, x29
0x000144f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000144fc  mov      x26, x0
0x00014500  ldr      x0, [x19, x27]
0x00014504  mov      x2, x26
0x00014508  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0001450c  mov      x0, x26
0x00014510  bl       #0x55d78   ; CALL _objc_release
0x00014514  mov      x0, x25
0x00014518  bl       #0x55d78   ; CALL _objc_release
0x0001451c  mov      x0, x24
0x00014520  bl       #0x55d78   ; CALL _objc_release
0x00014524  mov      x0, x23
0x00014528  bl       #0x55d78   ; CALL _objc_release
0x0001452c  mov      x0, x22
0x00014530  bl       #0x55d78   ; CALL _objc_release
0x00014534  mov      x0, x21
0x00014538  bl       #0x55d78   ; CALL _objc_release
0x0001453c  mov      x0, x20
0x00014540  bl       #0x55d78   ; CALL _objc_release
0x00014544  adrp     x8, #0x74000
0x00014548  ldr      x8, [x8, #0x5c8]   ; @GOT _CGPointZero
0x0001454c  ldp      d0, d1, [x8]
0x00014550  ldr      x0, [x19, x27]
0x00014554  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x00014558  ldr      x0, [x19, x27]
0x0001455c  fmov     d0, #1.00000000
0x00014560  fmov     d1, #1.00000000
0x00014564  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x00014568  ldr      x0, [x19, x28]
0x0001456c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00014570  mov      x29, x29
0x00014574  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014578  mov      x20, x0
0x0001457c  ldr      x2, [x19, x27]
0x00014580  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x00014584  mov      x0, x20
0x00014588  bl       #0x55d78   ; CALL _objc_release
0x0001458c  adrp     x8, #0x8e000
0x00014590  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x00014594  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00014598  mov      x29, x29
0x0001459c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000145a0  adrp     x8, #0x8e000
0x000145a4  ldrsw    x23, [x8, #0xe04]
0x000145a8  ldr      x8, [x19, x23]
0x000145ac  str      x0, [x19, x23]
0x000145b0  mov      x0, x8
0x000145b4  bl       #0x55d78   ; CALL _objc_release
0x000145b8  adrp     x27, #0x8e000
0x000145bc  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x000145c0  fmov     d0, #1.00000000
0x000145c4  mov      v1.16b, v8.16b
0x000145c8  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x000145cc  mov      x29, x29
0x000145d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000145d4  mov      x20, x0
0x000145d8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000145dc  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000145e0  str      x0, [sp, #0x10]
0x000145e4  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x000145e8  fmov     d0, #1.00000000
0x000145ec  fmov     d1, xzr
0x000145f0  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x000145f4  mov      x29, x29
0x000145f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000145fc  mov      x21, x0
0x00014600  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00014604  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00014608  str      x0, [sp, #0x18]
0x0001460c  adrp     x8, #0x8e000
0x00014610  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00014614  add      x2, sp, #0x10
0x00014618  mov      w3, #2
0x0001461c  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00014620  mov      x29, x29
0x00014624  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014628  mov      x22, x0
0x0001462c  ldr      x0, [x19, x23]
0x00014630  mov      x2, x22
0x00014634  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x00014638  mov      x0, x22
0x0001463c  bl       #0x55d78   ; CALL _objc_release
0x00014640  mov      x0, x21
0x00014644  bl       #0x55d78   ; CALL _objc_release
0x00014648  mov      x0, x20
0x0001464c  bl       #0x55d78   ; CALL _objc_release
0x00014650  ldr      x0, [x19, x28]
0x00014654  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00014658  mov      x29, x29
0x0001465c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014660  mov      x20, x0
0x00014664  ldr      x2, [x19, x23]
0x00014668  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0001466c  mov      x0, x20
0x00014670  bl       #0x55d78   ; CALL _objc_release
0x00014674  adrp     x8, #0x8e000
0x00014678  ldr      x20, [x8, #0x9d8]   ; @CLASS NSBundle
0x0001467c  mov      x0, x19
0x00014680  bl       #0x55d48   ; CALL _objc_opt_class
0x00014684  mov      x2, x0
0x00014688  mov      x0, x20
0x0001468c  bl       #0x56b40   ; CALL objc_msgSend$bundleForClass:
0x00014690  mov      x29, x29
0x00014694  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014698  mov      x20, x0
0x0001469c  adrp     x8, #0x8e000
0x000146a0  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x000146a4  bl       #0x55c7c   ; CALL _objc_alloc
0x000146a8  mov      x21, x0
0x000146ac  adrp     x8, #0x8e000
0x000146b0  ldr      x0, [x8, #0xa78]   ; @CLASS UIImage
0x000146b4  adrp     x2, #0x78000
0x000146b8  add      x2, x2, #0x588   ; STR "logo"
0x000146bc  mov      x3, x20
0x000146c0  mov      x4, #0
0x000146c4  bl       #0x58100   ; CALL objc_msgSend$imageNamed:inBundle:compatibleWithTraitCollection:
0x000146c8  mov      x29, x29
0x000146cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000146d0  mov      x22, x0
0x000146d4  mov      x0, x21
0x000146d8  mov      x2, x22
0x000146dc  bl       #0x584c0   ; CALL objc_msgSend$initWithImage:
0x000146e0  adrp     x8, #0x8e000
0x000146e4  ldrsw    x21, [x8, #0xe08]
0x000146e8  ldr      x8, [x19, x21]
0x000146ec  str      x0, [x19, x21]
0x000146f0  mov      x0, x8
0x000146f4  bl       #0x55d78   ; CALL _objc_release
0x000146f8  mov      x0, x22
0x000146fc  bl       #0x55d78   ; CALL _objc_release
0x00014700  ldr      x0, [x19, x28]
0x00014704  ldr      x2, [x19, x21]
0x00014708  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0001470c  adrp     x24, #0x8e000
0x00014710  ldr      x0, [x24, #0x940]   ; @CLASS UILabel
0x00014714  bl       #0x55d60   ; CALL _objc_opt_new
0x00014718  adrp     x8, #0x8e000
0x0001471c  ldrsw    x22, [x8, #0xe0c]
0x00014720  ldr      x8, [x19, x22]
0x00014724  str      x0, [x19, x22]
0x00014728  mov      x0, x8
0x0001472c  bl       #0x55d78   ; CALL _objc_release
0x00014730  ldr      x0, [x19, x22]
0x00014734  adrp     x2, #0x75000
0x00014738  add      x2, x2, #0x508   ; STR "OmniCar"
0x0001473c  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00014740  adrp     x25, #0x8e000
0x00014744  ldr      x0, [x25, #0x948]   ; @CLASS UIFont
0x00014748  adrp     x8, #0x74000
0x0001474c  ldr      x8, [x8, #0x238]   ; @GOT _UIFontWeightBold
0x00014750  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x00014754  fmov     d0, #21.00000000
0x00014758  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x0001475c  mov      x29, x29
0x00014760  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014764  mov      x21, x0
0x00014768  ldr      x0, [x19, x22]
0x0001476c  mov      x2, x21
0x00014770  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00014774  mov      x0, x21
0x00014778  bl       #0x55d78   ; CALL _objc_release
0x0001477c  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x00014780  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x00014784  mov      x29, x29
0x00014788  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001478c  mov      x21, x0
0x00014790  ldr      x0, [x19, x22]
0x00014794  mov      x2, x21
0x00014798  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0001479c  mov      x0, x21
0x000147a0  bl       #0x55d78   ; CALL _objc_release
0x000147a4  ldr      x0, [x19, x28]
0x000147a8  ldr      x2, [x19, x22]
0x000147ac  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x000147b0  ldr      x0, [x24, #0x940]   ; @CLASS UILabel
0x000147b4  bl       #0x55d60   ; CALL _objc_opt_new
0x000147b8  adrp     x8, #0x8e000
0x000147bc  ldrsw    x22, [x8, #0xe10]
0x000147c0  ldr      x8, [x19, x22]
0x000147c4  str      x0, [x19, x22]
0x000147c8  mov      x0, x8
0x000147cc  bl       #0x55d78   ; CALL _objc_release
0x000147d0  ldr      x0, [x19, x22]
0x000147d4  adrp     x2, #0x75000
0x000147d8  add      x2, x2, #0xc28   ; STR "1.0.3"
0x000147dc  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x000147e0  ldr      x0, [x25, #0x948]   ; @CLASS UIFont
0x000147e4  adrp     x8, #0x74000
0x000147e8  ldr      x8, [x8, #0x250]   ; @GOT _UIFontWeightMedium
0x000147ec  ldr      d8, [x8]   ; @GOT ___objc_personality_v0
0x000147f0  fmov     d0, #13.00000000
0x000147f4  mov      v1.16b, v8.16b
0x000147f8  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x000147fc  mov      x29, x29
0x00014800  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014804  mov      x21, x0
0x00014808  ldr      x0, [x19, x22]
0x0001480c  mov      x2, x21
0x00014810  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00014814  mov      x0, x21
0x00014818  bl       #0x55d78   ; CALL _objc_release
0x0001481c  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x00014820  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x00014824  mov      x29, x29
0x00014828  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001482c  mov      x21, x0
0x00014830  ldr      x0, [x19, x22]
0x00014834  mov      x2, x21
0x00014838  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0001483c  mov      x0, x21
0x00014840  bl       #0x55d78   ; CALL _objc_release
0x00014844  ldr      x0, [x19, x28]
0x00014848  ldr      x2, [x19, x22]
0x0001484c  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00014850  ldr      x0, [x24, #0x940]   ; @CLASS UILabel
0x00014854  bl       #0x55d60   ; CALL _objc_opt_new
0x00014858  adrp     x8, #0x8e000
0x0001485c  ldrsw    x22, [x8, #0xe14]
0x00014860  ldr      x8, [x19, x22]
0x00014864  str      x0, [x19, x22]
0x00014868  mov      x0, x8
0x0001486c  bl       #0x55d78   ; CALL _objc_release
0x00014870  ldr      x0, [x25, #0x948]   ; @CLASS UIFont
0x00014874  adrp     x8, #0x74000
0x00014878  ldr      x8, [x8, #0x258]   ; @GOT _UIFontWeightRegular
0x0001487c  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x00014880  fmov     d0, #13.00000000
0x00014884  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x00014888  mov      x29, x29
0x0001488c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014890  mov      x21, x0
0x00014894  ldr      x0, [x19, x22]
0x00014898  mov      x2, x21
0x0001489c  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x000148a0  mov      x0, x21
0x000148a4  bl       #0x55d78   ; CALL _objc_release
0x000148a8  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x000148ac  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x000148b0  mov      x29, x29
0x000148b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000148b8  mov      x21, x0
0x000148bc  ldr      x0, [x19, x22]
0x000148c0  mov      x2, x21
0x000148c4  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x000148c8  mov      x0, x21
0x000148cc  bl       #0x55d78   ; CALL _objc_release
0x000148d0  ldr      x0, [x19, x22]
0x000148d4  mov      w2, #1
0x000148d8  bl       #0x5a380   ; CALL objc_msgSend$setAdjustsFontSizeToFitWidth:
0x000148dc  ldr      x0, [x19, x22]
0x000148e0  adrp     x8, #0x65000
0x000148e4  ldr      d0, [x8, #0x670]
0x000148e8  bl       #0x5b660   ; CALL objc_msgSend$setMinimumScaleFactor:
0x000148ec  ldr      x0, [x19, x28]
0x000148f0  ldr      x2, [x19, x22]
0x000148f4  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x000148f8  adrp     x8, #0x8e000
0x000148fc  ldr      x0, [x8, #0x918]   ; @CLASS UIView
0x00014900  bl       #0x55d60   ; CALL _objc_opt_new
0x00014904  adrp     x8, #0x8e000
0x00014908  ldrsw    x26, [x8, #0xe18]
0x0001490c  ldr      x8, [x19, x26]
0x00014910  str      x0, [x19, x26]
0x00014914  mov      x0, x8
0x00014918  bl       #0x55d78   ; CALL _objc_release
0x0001491c  ldr      x0, [x19, x26]
0x00014920  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00014924  mov      x29, x29
0x00014928  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001492c  mov      x21, x0
0x00014930  fmov     d0, #3.50000000
0x00014934  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x00014938  mov      x0, x21
0x0001493c  bl       #0x55d78   ; CALL _objc_release
0x00014940  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x00014944  bl       #0x5d800   ; CALL objc_msgSend$systemGreenColor
0x00014948  mov      x29, x29
0x0001494c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014950  mov      x21, x0
0x00014954  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00014958  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0001495c  mov      x22, x0
0x00014960  ldr      x0, [x19, x26]
0x00014964  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00014968  mov      x29, x29
0x0001496c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014970  mov      x23, x0
0x00014974  mov      x2, x22
0x00014978  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x0001497c  mov      x0, x23
0x00014980  bl       #0x55d78   ; CALL _objc_release
0x00014984  mov      x0, x21
0x00014988  bl       #0x55d78   ; CALL _objc_release
0x0001498c  ldr      x0, [x19, x26]
0x00014990  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00014994  mov      x29, x29
0x00014998  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001499c  mov      x21, x0
0x000149a0  fmov     d0, #4.00000000
0x000149a4  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x000149a8  mov      x0, x21
0x000149ac  bl       #0x55d78   ; CALL _objc_release
0x000149b0  adrp     x8, #0x74000
0x000149b4  ldr      x8, [x8, #0x618]   ; @GOT _CGSizeZero
0x000149b8  ldp      d9, d10, [x8]
0x000149bc  ldr      x0, [x19, x26]
0x000149c0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000149c4  mov      x29, x29
0x000149c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000149cc  mov      x21, x0
0x000149d0  mov      v0.16b, v9.16b
0x000149d4  mov      v1.16b, v10.16b
0x000149d8  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x000149dc  mov      x0, x21
0x000149e0  bl       #0x55d78   ; CALL _objc_release
0x000149e4  ldr      x0, [x19, x28]
0x000149e8  ldr      x2, [x19, x26]
0x000149ec  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x000149f0  ldr      x0, [x24, #0x940]   ; @CLASS UILabel
0x000149f4  bl       #0x55d60   ; CALL _objc_opt_new
0x000149f8  adrp     x8, #0x8e000
0x000149fc  ldrsw    x22, [x8, #0xe1c]
0x00014a00  ldr      x8, [x19, x22]
0x00014a04  str      x0, [x19, x22]
0x00014a08  mov      x0, x8
0x00014a0c  bl       #0x55d78   ; CALL _objc_release
0x00014a10  ldr      x0, [x25, #0x948]   ; @CLASS UIFont
0x00014a14  fmov     d0, #12.50000000
0x00014a18  mov      v1.16b, v8.16b
0x00014a1c  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x00014a20  mov      x29, x29
0x00014a24  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014a28  mov      x21, x0
0x00014a2c  ldr      x0, [x19, x22]
0x00014a30  mov      x2, x21
0x00014a34  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00014a38  mov      x0, x21
0x00014a3c  bl       #0x55d78   ; CALL _objc_release
0x00014a40  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x00014a44  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x00014a48  mov      x29, x29
0x00014a4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014a50  mov      x21, x0
0x00014a54  ldr      x0, [x19, x22]
0x00014a58  mov      x2, x21
0x00014a5c  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00014a60  mov      x0, x21
0x00014a64  bl       #0x55d78   ; CALL _objc_release
0x00014a68  ldr      x0, [x19, x28]
0x00014a6c  ldr      x2, [x19, x22]
0x00014a70  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00014a74  adrp     x8, #0x8e000
0x00014a78  ldr      x0, [x8, #0x920]   ; @CLASS UISwitch
0x00014a7c  bl       #0x55d60   ; CALL _objc_opt_new
0x00014a80  adrp     x8, #0x8e000
0x00014a84  ldrsw    x22, [x8, #0xe20]
0x00014a88  ldr      x8, [x19, x22]
0x00014a8c  str      x0, [x19, x22]
0x00014a90  mov      x0, x8
0x00014a94  bl       #0x55d78   ; CALL _objc_release
0x00014a98  bl       #0x17fd8   ; CALL _OMCSwitchColor
0x00014a9c  mov      x29, x29
0x00014aa0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014aa4  mov      x21, x0
0x00014aa8  ldr      x0, [x19, x22]
0x00014aac  mov      x2, x21
0x00014ab0  bl       #0x5b920   ; CALL objc_msgSend$setOnTintColor:
0x00014ab4  mov      x0, x21
0x00014ab8  bl       #0x55d78   ; CALL _objc_release
0x00014abc  ldr      x0, [x19, x28]
0x00014ac0  ldr      x2, [x19, x22]
0x00014ac4  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00014ac8  mov      x0, x19
0x00014acc  bl       #0x55d84   ; CALL _objc_retain
0x00014ad0  mov      x0, x20
0x00014ad4  bl       #0x55d78   ; CALL _objc_release
0x00014ad8  mov      x0, x19
0x00014adc  bl       #0x55d78   ; CALL _objc_release
0x00014ae0  ldr      x8, [sp, #0x38]
0x00014ae4  adrp     x9, #0x74000
0x00014ae8  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00014aec  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00014af0  cmp      x9, x8
0x00014af4  b.ne     #0x14b24
0x00014af8  mov      x0, x19
0x00014afc  ldp      x29, x30, [sp, #0xb0]
0x00014b00  ldp      x20, x19, [sp, #0xa0]
0x00014b04  ldp      x22, x21, [sp, #0x90]
0x00014b08  ldp      x24, x23, [sp, #0x80]
0x00014b0c  ldp      x26, x25, [sp, #0x70]
0x00014b10  ldp      x28, x27, [sp, #0x60]
0x00014b14  ldp      d9, d8, [sp, #0x50]
0x00014b18  ldp      d11, d10, [sp, #0x40]
0x00014b1c  add      sp, sp, #0xc0
0x00014b20  ret      
0x00014b24  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCHeaderCard updateWithTagline:status:enabled:]  va=0x14b28 size=272 types=v36@0:8@16@24B32
0x00014b28  stp      d9, d8, [sp, #-0x50]!
0x00014b2c  stp      x24, x23, [sp, #0x10]
0x00014b30  stp      x22, x21, [sp, #0x20]
0x00014b34  stp      x20, x19, [sp, #0x30]
0x00014b38  stp      x29, x30, [sp, #0x40]
0x00014b3c  add      x29, sp, #0x40
0x00014b40  mov      x20, x4
0x00014b44  mov      x21, x3
0x00014b48  mov      x22, x2
0x00014b4c  mov      x19, x0
0x00014b50  adrp     x8, #0x8e000
0x00014b54  ldrsw    x8, [x8, #0xe14]
0x00014b58  ldr      x23, [x0, x8]
0x00014b5c  mov      x0, x3
0x00014b60  bl       #0x55d84   ; CALL _objc_retain
0x00014b64  mov      x0, x23
0x00014b68  mov      x2, x22
0x00014b6c  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00014b70  adrp     x8, #0x8e000
0x00014b74  ldrsw    x8, [x8, #0xe1c]
0x00014b78  ldr      x0, [x19, x8]
0x00014b7c  mov      x2, x21
0x00014b80  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00014b84  mov      x0, x21
0x00014b88  bl       #0x55d78   ; CALL _objc_release
0x00014b8c  adrp     x8, #0x8e000
0x00014b90  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00014b94  tbz      w20, #0, #0x14bb4
0x00014b98  bl       #0x5d800   ; CALL objc_msgSend$systemGreenColor
0x00014b9c  mov      x29, x29
0x00014ba0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014ba4  mov      x21, x0
0x00014ba8  adrp     x8, #0x65000
0x00014bac  ldr      s8, [x8, #0x684]
0x00014bb0  b        #0x14bc8
0x00014bb4  bl       #0x5d960   ; CALL objc_msgSend$tertiaryLabelColor
0x00014bb8  mov      x29, x29
0x00014bbc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014bc0  mov      x21, x0
0x00014bc4  fmov     s8, wzr
0x00014bc8  adrp     x8, #0x8e000
0x00014bcc  ldrsw    x22, [x8, #0xe18]
0x00014bd0  ldr      x0, [x19, x22]
0x00014bd4  mov      x2, x21
0x00014bd8  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x00014bdc  mov      x0, x21
0x00014be0  bl       #0x55d78   ; CALL _objc_release
0x00014be4  ldr      x0, [x19, x22]
0x00014be8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00014bec  mov      x29, x29
0x00014bf0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014bf4  mov      x21, x0
0x00014bf8  mov      v0.16b, v8.16b
0x00014bfc  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x00014c00  mov      x0, x21
0x00014c04  bl       #0x55d78   ; CALL _objc_release
0x00014c08  adrp     x8, #0x8e000
0x00014c0c  ldrsw    x8, [x8, #0xe20]
0x00014c10  ldr      x0, [x19, x8]
0x00014c14  mov      x2, x20
0x00014c18  bl       #0x5b900   ; CALL objc_msgSend$setOn:
0x00014c1c  mov      x0, x19
0x00014c20  ldp      x29, x30, [sp, #0x40]
0x00014c24  ldp      x20, x19, [sp, #0x30]
0x00014c28  ldp      x22, x21, [sp, #0x20]
0x00014c2c  ldp      x24, x23, [sp, #0x10]
0x00014c30  ldp      d9, d8, [sp], #0x50
0x00014c34  b        #0x5b7a0   ; CALL objc_msgSend$setNeedsLayout

=== -[OMCHeaderCard layoutSubviews]  va=0x14c38 size=844 types=v16@0:8
0x00014c38  sub      sp, sp, #0x80
0x00014c3c  stp      d15, d14, [sp, #0x10]
0x00014c40  stp      d13, d12, [sp, #0x20]
0x00014c44  stp      d11, d10, [sp, #0x30]
0x00014c48  stp      d9, d8, [sp, #0x40]
0x00014c4c  stp      x22, x21, [sp, #0x50]
0x00014c50  stp      x20, x19, [sp, #0x60]
0x00014c54  stp      x29, x30, [sp, #0x70]
0x00014c58  add      x29, sp, #0x70
0x00014c5c  mov      x19, x0
0x00014c60  adrp     x8, #0x8e000
0x00014c64  ldr      x8, [x8, #0xd28]   ; @SUPER OMCHeaderCard
0x00014c68  stp      x0, x8, [sp]
0x00014c6c  adrp     x8, #0x8b000
0x00014c70  ldr      x1, [x8, #0xe28]   ; @SEL "layoutSubviews"
0x00014c74  mov      x0, sp
0x00014c78  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00014c7c  mov      x0, x19
0x00014c80  bl       #0x58b20   ; CALL objc_msgSend$layoutMargins
0x00014c84  mov      v10.16b, v1.16b
0x00014c88  mov      v8.16b, v3.16b
0x00014c8c  mov      x0, x19
0x00014c90  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00014c94  fsub     d0, d2, d10
0x00014c98  fsub     d9, d0, d8
0x00014c9c  mov      x0, x19
0x00014ca0  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00014ca4  fmov     d0, #-24.00000000
0x00014ca8  fadd     d8, d3, d0
0x00014cac  adrp     x8, #0x8e000
0x00014cb0  ldrsw    x22, [x8, #0xdf4]
0x00014cb4  ldr      x0, [x19, x22]
0x00014cb8  fmov     d13, #8.00000000
0x00014cbc  fmov     d1, #8.00000000
0x00014cc0  mov      v0.16b, v10.16b
0x00014cc4  mov      v2.16b, v9.16b
0x00014cc8  mov      v3.16b, v8.16b
0x00014ccc  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00014cd0  ldr      x0, [x19, x22]
0x00014cd4  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00014cd8  adrp     x8, #0x8e000
0x00014cdc  ldrsw    x20, [x8, #0xdf8]
0x00014ce0  ldr      x0, [x19, x20]
0x00014ce4  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00014ce8  ldr      x0, [x19, x20]
0x00014cec  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00014cf0  adrp     x8, #0x8e000
0x00014cf4  ldrsw    x8, [x8, #0xdfc]
0x00014cf8  ldr      x0, [x19, x8]
0x00014cfc  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00014d00  adrp     x21, #0x8e000
0x00014d04  ldr      x0, [x21, #0xab8]   ; @CLASS CATransaction
0x00014d08  bl       #0x567a0   ; CALL objc_msgSend$begin
0x00014d0c  ldr      x0, [x21, #0xab8]   ; @CLASS CATransaction
0x00014d10  mov      w2, #1
0x00014d14  bl       #0x5ad00   ; CALL objc_msgSend$setDisableActions:
0x00014d18  ldr      x0, [x19, x20]
0x00014d1c  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00014d20  adrp     x8, #0x8e000
0x00014d24  ldrsw    x8, [x8, #0xe00]
0x00014d28  ldr      x0, [x19, x8]
0x00014d2c  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00014d30  fmov     d15, #0.50000000
0x00014d34  fmul     d3, d8, d15
0x00014d38  adrp     x8, #0x8e000
0x00014d3c  ldrsw    x8, [x8, #0xe04]
0x00014d40  ldr      x0, [x19, x8]
0x00014d44  fmov     d14, xzr
0x00014d48  fmov     d0, xzr
0x00014d4c  fmov     d1, xzr
0x00014d50  mov      v2.16b, v9.16b
0x00014d54  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00014d58  ldr      x0, [x21, #0xab8]   ; @CLASS CATransaction
0x00014d5c  bl       #0x56f40   ; CALL objc_msgSend$commit
0x00014d60  adrp     x8, #0x8e000
0x00014d64  ldr      x20, [x8, #0xac0]   ; @CLASS UIBezierPath
0x00014d68  ldr      x0, [x19, x22]
0x00014d6c  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00014d70  fmov     d4, #22.00000000
0x00014d74  mov      x0, x20
0x00014d78  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x00014d7c  mov      x29, x29
0x00014d80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014d84  mov      x20, x0
0x00014d88  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00014d8c  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x00014d90  mov      x21, x0
0x00014d94  ldr      x0, [x19, x22]
0x00014d98  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00014d9c  mov      x29, x29
0x00014da0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00014da4  mov      x22, x0
0x00014da8  mov      x2, x21
0x00014dac  bl       #0x5c020   ; CALL objc_msgSend$setShadowPath:
0x00014db0  mov      x0, x22
0x00014db4  bl       #0x55d78   ; CALL _objc_release
0x00014db8  mov      x0, x20
0x00014dbc  bl       #0x55d78   ; CALL _objc_release
0x00014dc0  mov      x8, #-0x3fb3000000000000
0x00014dc4  fmov     d0, x8
0x00014dc8  fadd     d0, d8, d0
0x00014dcc  fmul     d1, d0, d15
0x00014dd0  adrp     x8, #0x8e000
0x00014dd4  ldrsw    x20, [x8, #0xe08]
0x00014dd8  ldr      x0, [x19, x20]
0x00014ddc  mov      x8, #0x404d000000000000
0x00014de0  fmov     d2, x8
0x00014de4  fmov     d0, #16.00000000
0x00014de8  mov      v3.16b, v2.16b
0x00014dec  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00014df0  adrp     x8, #0x8e000
0x00014df4  ldrsw    x21, [x8, #0xe20]
0x00014df8  ldr      x0, [x19, x21]
0x00014dfc  adrp     x8, #0x74000
0x00014e00  ldr      x8, [x8, #0x618]   ; @GOT _CGSizeZero
0x00014e04  ldp      d11, d12, [x8]
0x00014e08  mov      v0.16b, v11.16b
0x00014e0c  mov      v1.16b, v12.16b
0x00014e10  bl       #0x5cbc0   ; CALL objc_msgSend$sizeThatFits:
0x00014e14  mov      v2.16b, v0.16b
0x00014e18  mov      v3.16b, v1.16b
0x00014e1c  fmov     d0, #-16.00000000
0x00014e20  fadd     d0, d9, d0
0x00014e24  fsub     d0, d0, d2
0x00014e28  fsub     d1, d8, d1
0x00014e2c  fmul     d1, d1, d15
0x00014e30  ldr      x0, [x19, x21]
0x00014e34  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00014e38  ldr      x0, [x19, x20]
0x00014e3c  bl       #0x57d00   ; CALL objc_msgSend$frame
0x00014e40  bl       #0x55a48   ; CALL _CGRectGetMaxX
0x00014e44  fmov     d1, #14.00000000
0x00014e48  fadd     d9, d0, d1
0x00014e4c  ldr      x0, [x19, x21]
0x00014e50  bl       #0x57d00   ; CALL objc_msgSend$frame
0x00014e54  bl       #0x55a78   ; CALL _CGRectGetMinX
0x00014e58  fmov     d1, #-10.00000000
0x00014e5c  fadd     d0, d0, d1
0x00014e60  fsub     d10, d0, d9
0x00014e64  mov      x8, #-0x3fb0000000000000
0x00014e68  fmov     d0, x8
0x00014e6c  fadd     d0, d8, d0
0x00014e70  fmul     d8, d0, d15
0x00014e74  adrp     x8, #0x8e000
0x00014e78  ldrsw    x20, [x8, #0xe0c]
0x00014e7c  ldr      x0, [x19, x20]
0x00014e80  mov      v0.16b, v11.16b
0x00014e84  mov      v1.16b, v12.16b
0x00014e88  bl       #0x5cbc0   ; CALL objc_msgSend$sizeThatFits:
0x00014e8c  frintp   d0, d0
0x00014e90  fcmp     d0, d10
0x00014e94  fcsel    d11, d0, d10, mi
0x00014e98  ldr      x0, [x19, x20]
0x00014e9c  fmov     d12, #28.00000000
0x00014ea0  fmov     d3, #28.00000000
0x00014ea4  mov      v0.16b, v9.16b
0x00014ea8  mov      v1.16b, v8.16b
0x00014eac  mov      v2.16b, v11.16b
0x00014eb0  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00014eb4  fadd     d0, d9, d11
0x00014eb8  fmov     d1, #6.00000000
0x00014ebc  fadd     d0, d0, d1
0x00014ec0  fadd     d1, d8, d13
0x00014ec4  fsub     d2, d10, d11
0x00014ec8  fmov     d3, #-6.00000000
0x00014ecc  fadd     d2, d2, d3
0x00014ed0  fmaxnm   d2, d2, d14
0x00014ed4  adrp     x8, #0x8e000
0x00014ed8  ldrsw    x8, [x8, #0xe10]
0x00014edc  ldr      x0, [x19, x8]
0x00014ee0  fmov     d3, #18.00000000
0x00014ee4  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00014ee8  fadd     d1, d8, d12
0x00014eec  adrp     x8, #0x8e000
0x00014ef0  ldrsw    x8, [x8, #0xe14]
0x00014ef4  ldr      x0, [x19, x8]
0x00014ef8  fmov     d3, #18.00000000
0x00014efc  mov      v0.16b, v9.16b
0x00014f00  mov      v2.16b, v10.16b
0x00014f04  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00014f08  fmov     d0, #13.00000000
0x00014f0c  fadd     d0, d9, d0
0x00014f10  mov      x8, #0x4047000000000000
0x00014f14  fmov     d1, x8
0x00014f18  fadd     d8, d8, d1
0x00014f1c  fmov     d1, #-13.00000000
0x00014f20  fadd     d2, d10, d1
0x00014f24  adrp     x8, #0x8e000
0x00014f28  ldrsw    x8, [x8, #0xe1c]
0x00014f2c  ldr      x0, [x19, x8]
0x00014f30  fmov     d3, #18.00000000
0x00014f34  mov      v1.16b, v8.16b
0x00014f38  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00014f3c  fmov     d0, #5.50000000
0x00014f40  fadd     d1, d8, d0
0x00014f44  adrp     x8, #0x8e000
0x00014f48  ldrsw    x8, [x8, #0xe18]
0x00014f4c  ldr      x0, [x19, x8]
0x00014f50  fmov     d2, #7.00000000
0x00014f54  fmov     d3, #7.00000000
0x00014f58  mov      v0.16b, v9.16b
0x00014f5c  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00014f60  ldp      x29, x30, [sp, #0x70]
0x00014f64  ldp      x20, x19, [sp, #0x60]
0x00014f68  ldp      x22, x21, [sp, #0x50]
0x00014f6c  ldp      d9, d8, [sp, #0x40]
0x00014f70  ldp      d11, d10, [sp, #0x30]
0x00014f74  ldp      d13, d12, [sp, #0x20]
0x00014f78  ldp      d15, d14, [sp, #0x10]
0x00014f7c  add      sp, sp, #0x80
0x00014f80  ret      

=== -[OMCHeaderCard card]  va=0x14f84 size=16 types=@16@0:8
0x00014f84  adrp     x8, #0x8e000
0x00014f88  ldrsw    x8, [x8, #0xdf4]
0x00014f8c  ldr      x0, [x0, x8]
0x00014f90  ret      

=== -[OMCHeaderCard setCard:]  va=0x14f94 size=64 types=v24@0:8@16
0x00014f94  stp      x22, x21, [sp, #-0x30]!
0x00014f98  stp      x20, x19, [sp, #0x10]
0x00014f9c  stp      x29, x30, [sp, #0x20]
0x00014fa0  add      x29, sp, #0x20
0x00014fa4  mov      x19, x2
0x00014fa8  mov      x20, x0
0x00014fac  adrp     x8, #0x8e000
0x00014fb0  ldrsw    x21, [x8, #0xdf4]
0x00014fb4  mov      x0, x2
0x00014fb8  bl       #0x55d84   ; CALL _objc_retain
0x00014fbc  ldr      x0, [x20, x21]
0x00014fc0  str      x19, [x20, x21]
0x00014fc4  ldp      x29, x30, [sp, #0x20]
0x00014fc8  ldp      x20, x19, [sp, #0x10]
0x00014fcc  ldp      x22, x21, [sp], #0x30
0x00014fd0  b        #0x55d78   ; CALL _objc_release

=== -[OMCHeaderCard clip]  va=0x14fd4 size=16 types=@16@0:8
0x00014fd4  adrp     x8, #0x8e000
0x00014fd8  ldrsw    x8, [x8, #0xdf8]
0x00014fdc  ldr      x0, [x0, x8]
0x00014fe0  ret      

=== -[OMCHeaderCard setClip:]  va=0x14fe4 size=64 types=v24@0:8@16
0x00014fe4  stp      x22, x21, [sp, #-0x30]!
0x00014fe8  stp      x20, x19, [sp, #0x10]
0x00014fec  stp      x29, x30, [sp, #0x20]
0x00014ff0  add      x29, sp, #0x20
0x00014ff4  mov      x19, x2
0x00014ff8  mov      x20, x0
0x00014ffc  adrp     x8, #0x8e000
0x00015000  ldrsw    x21, [x8, #0xdf8]
0x00015004  mov      x0, x2
0x00015008  bl       #0x55d84   ; CALL _objc_retain
0x0001500c  ldr      x0, [x20, x21]
0x00015010  str      x19, [x20, x21]
0x00015014  ldp      x29, x30, [sp, #0x20]
0x00015018  ldp      x20, x19, [sp, #0x10]
0x0001501c  ldp      x22, x21, [sp], #0x30
0x00015020  b        #0x55d78   ; CALL _objc_release

=== -[OMCHeaderCard dot]  va=0x15024 size=16 types=@16@0:8
0x00015024  adrp     x8, #0x8e000
0x00015028  ldrsw    x8, [x8, #0xe18]
0x0001502c  ldr      x0, [x0, x8]
0x00015030  ret      

=== -[OMCHeaderCard setDot:]  va=0x15034 size=64 types=v24@0:8@16
0x00015034  stp      x22, x21, [sp, #-0x30]!
0x00015038  stp      x20, x19, [sp, #0x10]
0x0001503c  stp      x29, x30, [sp, #0x20]
0x00015040  add      x29, sp, #0x20
0x00015044  mov      x19, x2
0x00015048  mov      x20, x0
0x0001504c  adrp     x8, #0x8e000
0x00015050  ldrsw    x21, [x8, #0xe18]
0x00015054  mov      x0, x2
0x00015058  bl       #0x55d84   ; CALL _objc_retain
0x0001505c  ldr      x0, [x20, x21]
0x00015060  str      x19, [x20, x21]
0x00015064  ldp      x29, x30, [sp, #0x20]
0x00015068  ldp      x20, x19, [sp, #0x10]
0x0001506c  ldp      x22, x21, [sp], #0x30
0x00015070  b        #0x55d78   ; CALL _objc_release

=== -[OMCHeaderCard gradient]  va=0x15074 size=16 types=@16@0:8
0x00015074  adrp     x8, #0x8e000
0x00015078  ldrsw    x8, [x8, #0xe00]
0x0001507c  ldr      x0, [x0, x8]
0x00015080  ret      

=== -[OMCHeaderCard setGradient:]  va=0x15084 size=64 types=v24@0:8@16
0x00015084  stp      x22, x21, [sp, #-0x30]!
0x00015088  stp      x20, x19, [sp, #0x10]
0x0001508c  stp      x29, x30, [sp, #0x20]
0x00015090  add      x29, sp, #0x20
0x00015094  mov      x19, x2
0x00015098  mov      x20, x0
0x0001509c  adrp     x8, #0x8e000
0x000150a0  ldrsw    x21, [x8, #0xe00]
0x000150a4  mov      x0, x2
0x000150a8  bl       #0x55d84   ; CALL _objc_retain
0x000150ac  ldr      x0, [x20, x21]
0x000150b0  str      x19, [x20, x21]
0x000150b4  ldp      x29, x30, [sp, #0x20]
0x000150b8  ldp      x20, x19, [sp, #0x10]
0x000150bc  ldp      x22, x21, [sp], #0x30
0x000150c0  b        #0x55d78   ; CALL _objc_release

=== -[OMCHeaderCard sheen]  va=0x150c4 size=16 types=@16@0:8
0x000150c4  adrp     x8, #0x8e000
0x000150c8  ldrsw    x8, [x8, #0xe04]
0x000150cc  ldr      x0, [x0, x8]
0x000150d0  ret      

=== -[OMCHeaderCard setSheen:]  va=0x150d4 size=64 types=v24@0:8@16
0x000150d4  stp      x22, x21, [sp, #-0x30]!
0x000150d8  stp      x20, x19, [sp, #0x10]
0x000150dc  stp      x29, x30, [sp, #0x20]
0x000150e0  add      x29, sp, #0x20
0x000150e4  mov      x19, x2
0x000150e8  mov      x20, x0
0x000150ec  adrp     x8, #0x8e000
0x000150f0  ldrsw    x21, [x8, #0xe04]
0x000150f4  mov      x0, x2
0x000150f8  bl       #0x55d84   ; CALL _objc_retain
0x000150fc  ldr      x0, [x20, x21]
0x00015100  str      x19, [x20, x21]
0x00015104  ldp      x29, x30, [sp, #0x20]
0x00015108  ldp      x20, x19, [sp, #0x10]
0x0001510c  ldp      x22, x21, [sp], #0x30
0x00015110  b        #0x55d78   ; CALL _objc_release

=== -[OMCHeaderCard logo]  va=0x15114 size=16 types=@16@0:8
0x00015114  adrp     x8, #0x8e000
0x00015118  ldrsw    x8, [x8, #0xe08]
0x0001511c  ldr      x0, [x0, x8]
0x00015120  ret      

=== -[OMCHeaderCard setLogo:]  va=0x15124 size=64 types=v24@0:8@16
0x00015124  stp      x22, x21, [sp, #-0x30]!
0x00015128  stp      x20, x19, [sp, #0x10]
0x0001512c  stp      x29, x30, [sp, #0x20]
0x00015130  add      x29, sp, #0x20
0x00015134  mov      x19, x2
0x00015138  mov      x20, x0
0x0001513c  adrp     x8, #0x8e000
0x00015140  ldrsw    x21, [x8, #0xe08]
0x00015144  mov      x0, x2
0x00015148  bl       #0x55d84   ; CALL _objc_retain
0x0001514c  ldr      x0, [x20, x21]
0x00015150  str      x19, [x20, x21]
0x00015154  ldp      x29, x30, [sp, #0x20]
0x00015158  ldp      x20, x19, [sp, #0x10]
0x0001515c  ldp      x22, x21, [sp], #0x30
0x00015160  b        #0x55d78   ; CALL _objc_release

=== -[OMCHeaderCard glass]  va=0x15164 size=16 types=@16@0:8
0x00015164  adrp     x8, #0x8e000
0x00015168  ldrsw    x8, [x8, #0xdfc]
0x0001516c  ldr      x0, [x0, x8]
0x00015170  ret      

=== -[OMCHeaderCard setGlass:]  va=0x15174 size=64 types=v24@0:8@16
0x00015174  stp      x22, x21, [sp, #-0x30]!
0x00015178  stp      x20, x19, [sp, #0x10]
0x0001517c  stp      x29, x30, [sp, #0x20]
0x00015180  add      x29, sp, #0x20
0x00015184  mov      x19, x2
0x00015188  mov      x20, x0
0x0001518c  adrp     x8, #0x8e000
0x00015190  ldrsw    x21, [x8, #0xdfc]
0x00015194  mov      x0, x2
0x00015198  bl       #0x55d84   ; CALL _objc_retain
0x0001519c  ldr      x0, [x20, x21]
0x000151a0  str      x19, [x20, x21]
0x000151a4  ldp      x29, x30, [sp, #0x20]
0x000151a8  ldp      x20, x19, [sp, #0x10]
0x000151ac  ldp      x22, x21, [sp], #0x30
0x000151b0  b        #0x55d78   ; CALL _objc_release

=== -[OMCHeaderCard nameLabel]  va=0x151b4 size=16 types=@16@0:8
0x000151b4  adrp     x8, #0x8e000
0x000151b8  ldrsw    x8, [x8, #0xe0c]
0x000151bc  ldr      x0, [x0, x8]
0x000151c0  ret      

=== -[OMCHeaderCard setNameLabel:]  va=0x151c4 size=64 types=v24@0:8@16
0x000151c4  stp      x22, x21, [sp, #-0x30]!
0x000151c8  stp      x20, x19, [sp, #0x10]
0x000151cc  stp      x29, x30, [sp, #0x20]
0x000151d0  add      x29, sp, #0x20
0x000151d4  mov      x19, x2
0x000151d8  mov      x20, x0
0x000151dc  adrp     x8, #0x8e000
0x000151e0  ldrsw    x21, [x8, #0xe0c]
0x000151e4  mov      x0, x2
0x000151e8  bl       #0x55d84   ; CALL _objc_retain
0x000151ec  ldr      x0, [x20, x21]
0x000151f0  str      x19, [x20, x21]
0x000151f4  ldp      x29, x30, [sp, #0x20]
0x000151f8  ldp      x20, x19, [sp, #0x10]
0x000151fc  ldp      x22, x21, [sp], #0x30
0x00015200  b        #0x55d78   ; CALL _objc_release

=== -[OMCHeaderCard versionLabel]  va=0x15204 size=16 types=@16@0:8
0x00015204  adrp     x8, #0x8e000
0x00015208  ldrsw    x8, [x8, #0xe10]
0x0001520c  ldr      x0, [x0, x8]
0x00015210  ret      

=== -[OMCHeaderCard setVersionLabel:]  va=0x15214 size=64 types=v24@0:8@16
0x00015214  stp      x22, x21, [sp, #-0x30]!
0x00015218  stp      x20, x19, [sp, #0x10]
0x0001521c  stp      x29, x30, [sp, #0x20]
0x00015220  add      x29, sp, #0x20
0x00015224  mov      x19, x2
0x00015228  mov      x20, x0
0x0001522c  adrp     x8, #0x8e000
0x00015230  ldrsw    x21, [x8, #0xe10]
0x00015234  mov      x0, x2
0x00015238  bl       #0x55d84   ; CALL _objc_retain
0x0001523c  ldr      x0, [x20, x21]
0x00015240  str      x19, [x20, x21]
0x00015244  ldp      x29, x30, [sp, #0x20]
0x00015248  ldp      x20, x19, [sp, #0x10]
0x0001524c  ldp      x22, x21, [sp], #0x30
0x00015250  b        #0x55d78   ; CALL _objc_release

=== -[OMCHeaderCard taglineLabel]  va=0x15254 size=16 types=@16@0:8
0x00015254  adrp     x8, #0x8e000
0x00015258  ldrsw    x8, [x8, #0xe14]
0x0001525c  ldr      x0, [x0, x8]
0x00015260  ret      

=== -[OMCHeaderCard setTaglineLabel:]  va=0x15264 size=64 types=v24@0:8@16
0x00015264  stp      x22, x21, [sp, #-0x30]!
0x00015268  stp      x20, x19, [sp, #0x10]
0x0001526c  stp      x29, x30, [sp, #0x20]
0x00015270  add      x29, sp, #0x20
0x00015274  mov      x19, x2
0x00015278  mov      x20, x0
0x0001527c  adrp     x8, #0x8e000
0x00015280  ldrsw    x21, [x8, #0xe14]
0x00015284  mov      x0, x2
0x00015288  bl       #0x55d84   ; CALL _objc_retain
0x0001528c  ldr      x0, [x20, x21]
0x00015290  str      x19, [x20, x21]
0x00015294  ldp      x29, x30, [sp, #0x20]
0x00015298  ldp      x20, x19, [sp, #0x10]
0x0001529c  ldp      x22, x21, [sp], #0x30
0x000152a0  b        #0x55d78   ; CALL _objc_release

=== -[OMCHeaderCard statusLabel]  va=0x152a4 size=16 types=@16@0:8
0x000152a4  adrp     x8, #0x8e000
0x000152a8  ldrsw    x8, [x8, #0xe1c]
0x000152ac  ldr      x0, [x0, x8]
0x000152b0  ret      

=== -[OMCHeaderCard setStatusLabel:]  va=0x152b4 size=64 types=v24@0:8@16
0x000152b4  stp      x22, x21, [sp, #-0x30]!
0x000152b8  stp      x20, x19, [sp, #0x10]
0x000152bc  stp      x29, x30, [sp, #0x20]
0x000152c0  add      x29, sp, #0x20
0x000152c4  mov      x19, x2
0x000152c8  mov      x20, x0
0x000152cc  adrp     x8, #0x8e000
0x000152d0  ldrsw    x21, [x8, #0xe1c]
0x000152d4  mov      x0, x2
0x000152d8  bl       #0x55d84   ; CALL _objc_retain
0x000152dc  ldr      x0, [x20, x21]
0x000152e0  str      x19, [x20, x21]
0x000152e4  ldp      x29, x30, [sp, #0x20]
0x000152e8  ldp      x20, x19, [sp, #0x10]
0x000152ec  ldp      x22, x21, [sp], #0x30
0x000152f0  b        #0x55d78   ; CALL _objc_release

=== -[OMCHeaderCard toggle]  va=0x152f4 size=16 types=@16@0:8
0x000152f4  adrp     x8, #0x8e000
0x000152f8  ldrsw    x8, [x8, #0xe20]
0x000152fc  ldr      x0, [x0, x8]
0x00015300  ret      

=== -[OMCHeaderCard setToggle:]  va=0x15304 size=64 types=v24@0:8@16
0x00015304  stp      x22, x21, [sp, #-0x30]!
0x00015308  stp      x20, x19, [sp, #0x10]
0x0001530c  stp      x29, x30, [sp, #0x20]
0x00015310  add      x29, sp, #0x20
0x00015314  mov      x19, x2
0x00015318  mov      x20, x0
0x0001531c  adrp     x8, #0x8e000
0x00015320  ldrsw    x21, [x8, #0xe20]
0x00015324  mov      x0, x2
0x00015328  bl       #0x55d84   ; CALL _objc_retain
0x0001532c  ldr      x0, [x20, x21]
0x00015330  str      x19, [x20, x21]
0x00015334  ldp      x29, x30, [sp, #0x20]
0x00015338  ldp      x20, x19, [sp, #0x10]
0x0001533c  ldp      x22, x21, [sp], #0x30
0x00015340  b        #0x55d78   ; CALL _objc_release

=== -[OMCHeaderCard .cxx_destruct]  va=0x15344 size=264 types=v16@0:8
0x00015344  stp      x20, x19, [sp, #-0x20]!
0x00015348  stp      x29, x30, [sp, #0x10]
0x0001534c  add      x29, sp, #0x10
0x00015350  mov      x19, x0
0x00015354  adrp     x8, #0x8e000
0x00015358  ldrsw    x8, [x8, #0xe20]
0x0001535c  add      x0, x0, x8
0x00015360  mov      x1, #0
0x00015364  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00015368  adrp     x8, #0x8e000
0x0001536c  ldrsw    x8, [x8, #0xe1c]
0x00015370  add      x0, x19, x8
0x00015374  mov      x1, #0
0x00015378  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0001537c  adrp     x8, #0x8e000
0x00015380  ldrsw    x8, [x8, #0xe14]
0x00015384  add      x0, x19, x8
0x00015388  mov      x1, #0
0x0001538c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00015390  adrp     x8, #0x8e000
0x00015394  ldrsw    x8, [x8, #0xe10]
0x00015398  add      x0, x19, x8
0x0001539c  mov      x1, #0
0x000153a0  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000153a4  adrp     x8, #0x8e000
0x000153a8  ldrsw    x8, [x8, #0xe0c]
0x000153ac  add      x0, x19, x8
0x000153b0  mov      x1, #0
0x000153b4  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000153b8  adrp     x8, #0x8e000
0x000153bc  ldrsw    x8, [x8, #0xdfc]
0x000153c0  add      x0, x19, x8
0x000153c4  mov      x1, #0
0x000153c8  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000153cc  adrp     x8, #0x8e000
0x000153d0  ldrsw    x8, [x8, #0xe08]
0x000153d4  add      x0, x19, x8
0x000153d8  mov      x1, #0
0x000153dc  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000153e0  adrp     x8, #0x8e000
0x000153e4  ldrsw    x8, [x8, #0xe04]
0x000153e8  add      x0, x19, x8
0x000153ec  mov      x1, #0
0x000153f0  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000153f4  adrp     x8, #0x8e000
0x000153f8  ldrsw    x8, [x8, #0xe00]
0x000153fc  add      x0, x19, x8
0x00015400  mov      x1, #0
0x00015404  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00015408  adrp     x8, #0x8e000
0x0001540c  ldrsw    x8, [x8, #0xe18]
0x00015410  add      x0, x19, x8
0x00015414  mov      x1, #0
0x00015418  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0001541c  adrp     x8, #0x8e000
0x00015420  ldrsw    x8, [x8, #0xdf8]
0x00015424  add      x0, x19, x8
0x00015428  mov      x1, #0
0x0001542c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00015430  adrp     x8, #0x8e000
0x00015434  ldrsw    x8, [x8, #0xdf4]
0x00015438  add      x0, x19, x8
0x0001543c  mov      x1, #0
0x00015440  ldp      x29, x30, [sp, #0x10]
0x00015444  ldp      x20, x19, [sp], #0x20
0x00015448  b        #0x55dcc   ; CALL _objc_storeStrong
