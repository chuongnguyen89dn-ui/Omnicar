; ==== sub_11ef0 @ 0x11ef0..0x122a0 (944 bytes) ====
0x00011ef0  ldr      x0, [sp, #0x20]
0x00011ef4  bl       #0x2480c   ; call _objc_release
0x00011ef8  mov      x0, x22
0x00011efc  bl       #0x2480c   ; call _objc_release
0x00011f00  b        #0x11f30   ; call sub_11f30
0x00011f04  b        #0x11f2c   ; call sub_11f2c
0x00011f08  mov      x24, x0
0x00011f0c  b        #0x11f38   ; call sub_11f38
0x00011f10  mov      x24, x0
0x00011f14  mov      x0, x22
0x00011f18  bl       #0x2480c   ; call _objc_release
0x00011f1c  b        #0x11f24   ; call sub_11f24
0x00011f20  mov      x24, x0
0x00011f24  mov      x0, x23
0x00011f28  b        #0x11f34   ; call sub_11f34
0x00011f2c  mov      x24, x0
0x00011f30  mov      x0, x20
0x00011f34  bl       #0x2480c   ; call _objc_release
0x00011f38  mov      x0, x21
0x00011f3c  bl       #0x2480c   ; call _objc_release
0x00011f40  mov      x0, x20
0x00011f44  bl       #0x2480c   ; call _objc_release
0x00011f48  mov      x0, x19
0x00011f4c  bl       #0x2480c   ; call _objc_release
0x00011f50  mov      x0, x24
0x00011f54  bl       #0x24470   ; call __Unwind_Resume
0x00011f58  stp      d11, d10, [sp, #-0x80]!
0x00011f5c  stp      d9, d8, [sp, #0x10]
0x00011f60  stp      x28, x27, [sp, #0x20]
0x00011f64  stp      x26, x25, [sp, #0x30]
0x00011f68  stp      x24, x23, [sp, #0x40]
0x00011f6c  stp      x22, x21, [sp, #0x50]
0x00011f70  stp      x20, x19, [sp, #0x60]
0x00011f74  stp      x29, x30, [sp, #0x70]
0x00011f78  add      x29, sp, #0x70
0x00011f7c  sub      sp, sp, #0x1b0
0x00011f80  mov      x20, x1
0x00011f84  mov      x19, x0
0x00011f88  adrp     x8, #0x34000
0x00011f8c  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00011f90  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00011f94  stur     x8, [x29, #-0x80]
0x00011f98  bl       #0x24818   ; call _objc_retain
0x00011f9c  cbz      x19, #0x123f4
0x00011fa0  movi     v0.16b, #0
0x00011fa4  stp      q0, q0, [sp, #0x70]
0x00011fa8  stp      q0, q0, [sp, #0x50]
0x00011fac  str      x19, [sp]
0x00011fb0  mov      x0, x19
0x00011fb4  bl       #0x25f00   ; objc_msgSend: layer
0x00011fb8  mov      x29, x29
0x00011fbc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011fc0  mov      x21, x0
0x00011fc4  bl       #0x27d80   ; objc_msgSend: sublayers
0x00011fc8  mov      x29, x29
0x00011fcc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011fd0  mov      x22, x0
0x00011fd4  mov      x0, x21
0x00011fd8  bl       #0x2480c   ; call _objc_release
0x00011fdc  add      x2, sp, #0x50
0x00011fe0  sub      x3, x29, #0x100
0x00011fe4  mov      x0, x22
0x00011fe8  mov      w4, #0x10
0x00011fec  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00011ff0  mov      x23, x0
0x00011ff4  cbz      x0, #0x1209c
0x00011ff8  str      xzr, [sp, #8]
0x00011ffc  ldr      x8, [sp, #0x60]
0x00012000  ldr      x19, [x8]   ; -> [got:___objc_personality_v0]
0x00012004  adrp     x24, #0x36000
0x00012008  add      x24, x24, #0xab0   ; -> @"omcAccent"
0x0001200c  mov      x21, #0
0x00012010  ldr      x8, [sp, #0x60]
0x00012014  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00012018  cmp      x8, x19
0x0001201c  b.eq     #0x12028
0x00012020  mov      x0, x22
0x00012024  bl       #0x24770   ; call _objc_enumerationMutation
0x00012028  ldr      x8, [sp, #0x58]
0x0001202c  ldr      x25, [x8, x21, lsl #3]   ; -> [got:___objc_personality_v0]
0x00012030  mov      x0, x25
0x00012034  bl       #0x26200   ; objc_msgSend: name
0x00012038  mov      x29, x29
0x0001203c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012040  mov      x26, x0
0x00012044  mov      x2, x24
0x00012048  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001204c  mov      x27, x0
0x00012050  mov      x0, x26
0x00012054  bl       #0x2480c   ; call _objc_release
0x00012058  cbz      w27, #0x12070
0x0001205c  mov      x0, x25
0x00012060  bl       #0x24818   ; call _objc_retain
0x00012064  ldr      x0, [sp, #8]
0x00012068  bl       #0x2480c   ; call _objc_release
0x0001206c  str      x25, [sp, #8]
0x00012070  add      x21, x21, #1
0x00012074  cmp      x23, x21
0x00012078  b.ne     #0x12010
0x0001207c  add      x2, sp, #0x50
0x00012080  sub      x3, x29, #0x100
0x00012084  mov      x0, x22
0x00012088  mov      w4, #0x10
0x0001208c  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00012090  mov      x23, x0
0x00012094  cbnz     x0, #0x1200c
0x00012098  b        #0x120a0   ; call sub_120a0
0x0001209c  str      xzr, [sp, #8]
0x000120a0  mov      x0, x22
0x000120a4  bl       #0x2480c   ; call _objc_release
0x000120a8  cbz      w20, #0x12250
0x000120ac  ldr      x8, [sp, #8]
0x000120b0  cbnz     x8, #0x12250
0x000120b4  adrp     x8, #0x3e000
0x000120b8  ldr      x0, [x8, #0x3a8]   ; -> [class(CAGradientLayer)]
0x000120bc  mov      x21, #0
0x000120c0  bl       #0x25f00   ; objc_msgSend: layer
0x000120c4  mov      x29, x29
0x000120c8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000120cc  mov      x22, x0
0x000120d0  adrp     x2, #0x36000
0x000120d4  add      x2, x2, #0xab0   ; -> @"omcAccent"
0x000120d8  mov      x21, x0
0x000120dc  bl       #0x273c0   ; objc_msgSend: setName:
0x000120e0  adrp     x19, #0x3e000
0x000120e4  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x000120e8  adrp     x8, #0x2b000
0x000120ec  ldr      d0, [x8, #0x288]
0x000120f0  adrp     x8, #0x2b000
0x000120f4  ldr      d1, [x8, #0x290]
0x000120f8  adrp     x8, #0x2b000
0x000120fc  ldr      d2, [x8, #0x298]
0x00012100  fmov     d3, #1.00000000
0x00012104  mov      x21, x22
0x00012108  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001210c  mov      x29, x29
0x00012110  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012114  mov      x24, x0
0x00012118  bl       #0x24824   ; call _objc_retainAutorelease
0x0001211c  mov      x0, x24
0x00012120  bl       #0x249e0   ; objc_msgSend: CGColor
0x00012124  str      x0, [sp, #0x110]
0x00012128  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x0001212c  adrp     x8, #0x2b000
0x00012130  ldr      d0, [x8, #0x2a0]
0x00012134  adrp     x8, #0x2b000
0x00012138  ldr      d1, [x8, #0x2a8]
0x0001213c  adrp     x8, #0x2b000
0x00012140  ldr      d2, [x8, #0x2b0]
0x00012144  fmov     d3, #1.00000000
0x00012148  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001214c  mov      x29, x29
0x00012150  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012154  mov      x21, x0
0x00012158  bl       #0x24824   ; call _objc_retainAutorelease
0x0001215c  mov      x0, x21
0x00012160  bl       #0x249e0   ; objc_msgSend: CGColor
0x00012164  str      x0, [sp, #0x118]
0x00012168  adrp     x8, #0x3e000
0x0001216c  ldr      x0, [x8, #0x2a8]   ; -> [class(NSArray)]
0x00012170  add      x2, sp, #0x110
0x00012174  mov      w3, #2
0x00012178  bl       #0x24e20   ; objc_msgSend: arrayWithObjects:count:
0x0001217c  mov      x29, x29
0x00012180  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012184  mov      x25, x0
0x00012188  mov      x0, x22
0x0001218c  mov      x2, x25
0x00012190  bl       #0x26da0   ; objc_msgSend: setColors:
0x00012194  mov      x0, x25
0x00012198  bl       #0x2480c   ; call _objc_release
0x0001219c  mov      x0, x21
0x000121a0  bl       #0x2480c   ; call _objc_release
0x000121a4  mov      x0, x24
0x000121a8  bl       #0x2480c   ; call _objc_release
0x000121ac  adrp     x8, #0x34000
0x000121b0  ldr      x8, [x8, #0x508]   ; -> [got:_CGPointZero]
0x000121b4  ldp      d0, d1, [x8]
0x000121b8  mov      x21, x22
0x000121bc  mov      x0, x22
0x000121c0  bl       #0x27840   ; objc_msgSend: setStartPoint:
0x000121c4  fmov     d0, #1.00000000
0x000121c8  fmov     d1, #1.00000000
0x000121cc  mov      x21, x22
0x000121d0  mov      x0, x22
0x000121d4  bl       #0x26ee0   ; objc_msgSend: setEndPoint:
0x000121d8  mov      x21, x22
0x000121dc  ldr      x0, [sp]
0x000121e0  bl       #0x24f40   ; objc_msgSend: bounds
0x000121e4  mov      x21, x22
0x000121e8  mov      x0, x22
0x000121ec  bl       #0x26f80   ; objc_msgSend: setFrame:
0x000121f0  mov      x21, x22
0x000121f4  ldr      x0, [sp]
0x000121f8  bl       #0x25f00   ; objc_msgSend: layer
0x000121fc  mov      x29, x29
0x00012200  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012204  mov      x24, x0
0x00012208  bl       #0x25400   ; objc_msgSend: cornerRadius
0x0001220c  mov      x0, x22
0x00012210  bl       #0x26e20   ; objc_msgSend: setCornerRadius:
0x00012214  mov      x0, x24
0x00012218  bl       #0x2480c   ; call _objc_release
0x0001221c  mov      x21, x22
0x00012220  ldr      x0, [sp]
0x00012224  bl       #0x25f00   ; objc_msgSend: layer
0x00012228  mov      x29, x29
0x0001222c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012230  mov      x24, x0
0x00012234  mov      x2, x22
0x00012238  mov      w3, #0
0x0001223c  bl       #0x25b20   ; objc_msgSend: insertSublayer:atIndex:
0x00012240  mov      x0, x24
0x00012244  bl       #0x2480c   ; call _objc_release
0x00012248  str      x22, [sp, #8]
0x0001224c  b        #0x12254   ; call sub_12254
0x00012250  tbz      w20, #0, #0x12270
0x00012254  adrp     x8, #0x3e000
0x00012258  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x0001225c  ldr      x21, [sp, #8]
0x00012260  bl       #0x251a0   ; objc_msgSend: clearColor
0x00012264  mov      x29, x29
0x00012268  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001226c  b        #0x1229c   ; call sub_1229c
0x00012270  ldr      x21, [sp, #8]
0x00012274  mov      x0, x21
0x00012278  bl       #0x26820   ; objc_msgSend: removeFromSuperlayer
0x0001227c  adrp     x8, #0x3e000
0x00012280  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x00012284  adrp     x8, #0x2b000
0x00012288  ldr      d1, [x8, #0x268]
0x0001228c  fmov     d0, #1.00000000
0x00012290  bl       #0x25240   ; objc_msgSend: colorWithWhite:alpha:
0x00012294  mov      x29, x29
0x00012298  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001229c  mov      x22, x0
