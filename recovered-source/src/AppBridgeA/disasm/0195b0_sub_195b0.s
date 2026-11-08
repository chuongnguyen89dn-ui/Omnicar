; ==== sub_195b0 @ 0x195b0..0x19b9c (1516 bytes) ====
0x000195b0  ldr      x0, [sp, #0x58]
0x000195b4  bl       #0x2480c   ; call _objc_release
0x000195b8  b        #0x195d4   ; call sub_195d4
0x000195bc  mov      x20, x0
0x000195c0  mov      x0, x23
0x000195c4  b        #0x195d8   ; call sub_195d8
0x000195c8  b        #0x195e4   ; call sub_195e4
0x000195cc  b        #0x195f4   ; call sub_195f4
0x000195d0  mov      x20, x0
0x000195d4  mov      x0, x22
0x000195d8  bl       #0x2480c   ; call _objc_release
0x000195dc  b        #0x195e8   ; call sub_195e8
0x000195e0  b        #0x195e4   ; call sub_195e4
0x000195e4  mov      x20, x0
0x000195e8  mov      x0, x21
0x000195ec  bl       #0x2480c   ; call _objc_release
0x000195f0  b        #0x195f8   ; call sub_195f8
0x000195f4  mov      x20, x0
0x000195f8  mov      x0, x19
0x000195fc  bl       #0x2480c   ; call _objc_release
0x00019600  mov      x0, x20
0x00019604  bl       #0x24470   ; call __Unwind_Resume
0x00019608  sub      sp, sp, #0x80
0x0001960c  stp      x20, x19, [sp, #0x60]
0x00019610  stp      x29, x30, [sp, #0x70]
0x00019614  add      x29, sp, #0x70
0x00019618  mov      x19, x0
0x0001961c  ldr      x0, [x0, #0x20]
0x00019620  bl       #0x24f40   ; objc_msgSend: bounds
0x00019624  fmov     d0, #12.00000000
0x00019628  fadd     d1, d3, d0
0x0001962c  add      x8, sp, #0x30
0x00019630  fmov     d0, xzr
0x00019634  bl       #0x242f0   ; call _CGAffineTransformMakeTranslation
0x00019638  ldp      q0, q1, [sp, #0x30]
0x0001963c  stp      q0, q1, [sp]
0x00019640  ldr      q0, [sp, #0x50]
0x00019644  str      q0, [sp, #0x20]
0x00019648  ldr      x0, [x19, #0x20]
0x0001964c  mov      x2, sp
0x00019650  bl       #0x279a0   ; objc_msgSend: setTransform:
0x00019654  ldp      x29, x30, [sp, #0x70]
0x00019658  ldp      x20, x19, [sp, #0x60]
0x0001965c  add      sp, sp, #0x80
0x00019660  ret      
0x00019664  sub      sp, sp, #0x50
0x00019668  stp      x20, x19, [sp, #0x30]
0x0001966c  stp      x29, x30, [sp, #0x40]
0x00019670  add      x29, sp, #0x40
0x00019674  mov      x19, x0
0x00019678  ldr      x0, [x0, #0x20]
0x0001967c  bl       #0x24ce0   ; objc_msgSend: app
0x00019680  mov      x29, x29
0x00019684  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019688  mov      x20, x0
0x0001968c  bl       #0x2480c   ; call _objc_release
0x00019690  cbnz     x20, #0x1969c
0x00019694  ldr      x0, [x19, #0x28]
0x00019698  bl       #0x26840   ; objc_msgSend: removeFromSuperview
0x0001969c  adrp     x8, #0x34000
0x000196a0  ldr      x8, [x8, #0x4b0]   ; -> [got:_CGAffineTransformIdentity]
0x000196a4  ldp      q0, q1, [x8]
0x000196a8  stp      q0, q1, [sp]
0x000196ac  ldr      q0, [x8, #0x20]   ; -> [got:_class_getClassMethod]
0x000196b0  str      q0, [sp, #0x20]
0x000196b4  ldr      x0, [x19, #0x28]
0x000196b8  mov      x2, sp
0x000196bc  bl       #0x279a0   ; objc_msgSend: setTransform:
0x000196c0  ldp      x29, x30, [sp, #0x40]
0x000196c4  ldp      x20, x19, [sp, #0x30]
0x000196c8  add      sp, sp, #0x50
0x000196cc  ret      
0x000196d0  sub      sp, sp, #0xa0
0x000196d4  stp      d15, d14, [sp, #0x20]
0x000196d8  stp      d13, d12, [sp, #0x30]
0x000196dc  stp      d11, d10, [sp, #0x40]
0x000196e0  stp      d9, d8, [sp, #0x50]
0x000196e4  stp      x24, x23, [sp, #0x60]
0x000196e8  stp      x22, x21, [sp, #0x70]
0x000196ec  stp      x20, x19, [sp, #0x80]
0x000196f0  stp      x29, x30, [sp, #0x90]
0x000196f4  add      x29, sp, #0x90
0x000196f8  mov      x20, x0
0x000196fc  mov      x0, x2
0x00019700  bl       #0x24f40   ; objc_msgSend: bounds
0x00019704  mov      v12.16b, v0.16b
0x00019708  mov      v11.16b, v1.16b
0x0001970c  mov      v9.16b, v2.16b
0x00019710  mov      v10.16b, v3.16b
0x00019714  adrp     x8, #0x3e000
0x00019718  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x0001971c  bl       #0x27b20   ; objc_msgSend: shared
0x00019720  mov      x29, x29
0x00019724  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019728  mov      x19, x0
0x0001972c  bl       #0x250e0   ; objc_msgSend: carAppArea
0x00019730  stp      d1, d0, [sp, #8]
0x00019734  str      d3, [sp]
0x00019738  mov      v15.16b, v2.16b
0x0001973c  mov      x0, x19
0x00019740  bl       #0x2480c   ; call _objc_release
0x00019744  mov      x8, #0x4059000000000000
0x00019748  fmov     d0, x8
0x0001974c  fcmp     d15, d0
0x00019750  str      d12, [sp, #0x18]
0x00019754  mov      v13.16b, v11.16b
0x00019758  mov      v14.16b, v9.16b
0x0001975c  mov      v8.16b, v10.16b
0x00019760  b.le     #0x19794
0x00019764  ldp      d1, d0, [sp, #8]
0x00019768  mov      v2.16b, v15.16b
0x0001976c  ldr      d3, [sp]
0x00019770  ldr      d4, [sp, #0x18]
0x00019774  mov      v5.16b, v11.16b
0x00019778  mov      v6.16b, v9.16b
0x0001977c  mov      v7.16b, v10.16b
0x00019780  bl       #0x243bc   ; call _CGRectIntersection
0x00019784  mov      v12.16b, v0.16b
0x00019788  mov      v13.16b, v1.16b
0x0001978c  mov      v14.16b, v2.16b
0x00019790  mov      v8.16b, v3.16b
0x00019794  mov      v0.16b, v12.16b
0x00019798  mov      v1.16b, v13.16b
0x0001979c  mov      v2.16b, v14.16b
0x000197a0  mov      v3.16b, v8.16b
0x000197a4  bl       #0x243c8   ; call _CGRectIsEmpty
0x000197a8  cmp      w0, #0
0x000197ac  ldr      d15, [sp, #0x18]
0x000197b0  fcsel    d0, d15, d12, ne
0x000197b4  fcsel    d1, d11, d13, ne
0x000197b8  fcsel    d3, d10, d8, ne
0x000197bc  fcsel    d2, d9, d14, ne
0x000197c0  fmov     d4, #-12.00000000
0x000197c4  fadd     d4, d2, d4
0x000197c8  mov      x8, #0x4069000000000000
0x000197cc  fmov     d5, x8
0x000197d0  fmaxnm   d8, d4, d5
0x000197d4  bl       #0x24398   ; call _CGRectGetMinX
0x000197d8  mov      v12.16b, v0.16b
0x000197dc  mov      v0.16b, v15.16b
0x000197e0  mov      v1.16b, v11.16b
0x000197e4  mov      v2.16b, v9.16b
0x000197e8  mov      v3.16b, v10.16b
0x000197ec  bl       #0x24374   ; call _CGRectGetMaxY
0x000197f0  mov      v11.16b, v0.16b
0x000197f4  mov      x0, x20
0x000197f8  bl       #0x26560   ; objc_msgSend: panel
0x000197fc  mov      x29, x29
0x00019800  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019804  mov      x19, x0
0x00019808  fmov     d0, #6.00000000
0x0001980c  fadd     d0, d12, d0
0x00019810  fcmp     d0, #0.0
0x00019814  fmov     d1, xzr
0x00019818  fcsel    d0, d1, d0, mi
0x0001981c  fsub     d1, d9, d8
0x00019820  fcmp     d0, d1
0x00019824  fcsel    d0, d0, d1, mi
0x00019828  adrp     x8, #0x2b000
0x0001982c  ldr      d1, [x8, #0x3a8]
0x00019830  fmul     d1, d10, d1
0x00019834  frintm   d1, d1
0x00019838  adrp     x8, #0x2b000
0x0001983c  ldr      d2, [x8, #0x3b0]
0x00019840  fminnm   d3, d1, d2
0x00019844  fsub     d1, d11, d3
0x00019848  fmov     d2, #-6.00000000
0x0001984c  fadd     d1, d1, d2
0x00019850  mov      v2.16b, v8.16b
0x00019854  bl       #0x26f80   ; objc_msgSend: setFrame:
0x00019858  mov      x0, x19
0x0001985c  bl       #0x2480c   ; call _objc_release
0x00019860  mov      x0, x20
0x00019864  bl       #0x26560   ; objc_msgSend: panel
0x00019868  mov      x29, x29
0x0001986c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019870  mov      x19, x0
0x00019874  bl       #0x24f40   ; objc_msgSend: bounds
0x00019878  mov      v8.16b, v0.16b
0x0001987c  mov      v9.16b, v1.16b
0x00019880  mov      v10.16b, v2.16b
0x00019884  mov      v11.16b, v3.16b
0x00019888  mov      x0, x20
0x0001988c  bl       #0x25820   ; objc_msgSend: glass
0x00019890  mov      x29, x29
0x00019894  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019898  mov      x21, x0
0x0001989c  mov      v0.16b, v8.16b
0x000198a0  mov      v1.16b, v9.16b
0x000198a4  mov      v2.16b, v10.16b
0x000198a8  mov      v3.16b, v11.16b
0x000198ac  bl       #0x26f80   ; objc_msgSend: setFrame:
0x000198b0  mov      x0, x21
0x000198b4  bl       #0x2480c   ; call _objc_release
0x000198b8  mov      x0, x19
0x000198bc  bl       #0x2480c   ; call _objc_release
0x000198c0  adrp     x8, #0x3e000
0x000198c4  ldr      x21, [x8, #0x300]   ; -> [class(UIBezierPath)]
0x000198c8  mov      x0, x20
0x000198cc  bl       #0x26560   ; objc_msgSend: panel
0x000198d0  mov      x29, x29
0x000198d4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000198d8  mov      x19, x0
0x000198dc  bl       #0x24f40   ; objc_msgSend: bounds
0x000198e0  fmov     d4, #20.00000000
0x000198e4  mov      x0, x21
0x000198e8  bl       #0x24ee0   ; objc_msgSend: bezierPathWithRoundedRect:cornerRadius:
0x000198ec  mov      x29, x29
0x000198f0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000198f4  mov      x21, x0
0x000198f8  bl       #0x24824   ; call _objc_retainAutorelease
0x000198fc  bl       #0x24a20   ; objc_msgSend: CGPath
0x00019900  mov      x23, x0
0x00019904  mov      x0, x20
0x00019908  bl       #0x26560   ; objc_msgSend: panel
0x0001990c  mov      x29, x29
0x00019910  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019914  mov      x22, x0
0x00019918  bl       #0x25f00   ; objc_msgSend: layer
0x0001991c  mov      x29, x29
0x00019920  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019924  mov      x20, x0
0x00019928  mov      x2, x23
0x0001992c  bl       #0x27740   ; objc_msgSend: setShadowPath:
0x00019930  mov      x0, x20
0x00019934  bl       #0x2480c   ; call _objc_release
0x00019938  mov      x0, x22
0x0001993c  bl       #0x2480c   ; call _objc_release
0x00019940  mov      x0, x21
0x00019944  bl       #0x2480c   ; call _objc_release
0x00019948  mov      x0, x19
0x0001994c  ldp      x29, x30, [sp, #0x90]
0x00019950  ldp      x20, x19, [sp, #0x80]
0x00019954  ldp      x22, x21, [sp, #0x70]
0x00019958  ldp      x24, x23, [sp, #0x60]
0x0001995c  ldp      d9, d8, [sp, #0x50]
0x00019960  ldp      d11, d10, [sp, #0x40]
0x00019964  ldp      d13, d12, [sp, #0x30]
0x00019968  ldp      d15, d14, [sp, #0x20]
0x0001996c  add      sp, sp, #0xa0
0x00019970  b        #0x2480c   ; call _objc_release
0x00019974  mov      x1, x20
0x00019978  mov      x20, x0
0x0001997c  mov      x0, x1
0x00019980  bl       #0x2480c   ; call _objc_release
0x00019984  b        #0x1998c   ; call sub_1998c
0x00019988  mov      x20, x0
0x0001998c  mov      x0, x22
0x00019990  bl       #0x2480c   ; call _objc_release
0x00019994  b        #0x199a8   ; call sub_199a8
0x00019998  b        #0x199a4   ; call sub_199a4
0x0001999c  b        #0x199b8   ; call sub_199b8
0x000199a0  b        #0x199b8   ; call sub_199b8
0x000199a4  mov      x20, x0
0x000199a8  mov      x0, x21
0x000199ac  bl       #0x2480c   ; call _objc_release
0x000199b0  b        #0x199bc   ; call sub_199bc
0x000199b4  b        #0x199b8   ; call sub_199b8
0x000199b8  mov      x20, x0
0x000199bc  mov      x0, x19
0x000199c0  bl       #0x2480c   ; call _objc_release
0x000199c4  mov      x0, x20
0x000199c8  bl       #0x24470   ; call __Unwind_Resume
0x000199cc  sub      sp, sp, #0x150
0x000199d0  stp      d15, d14, [sp, #0xc0]
0x000199d4  stp      d13, d12, [sp, #0xd0]
0x000199d8  stp      d11, d10, [sp, #0xe0]
0x000199dc  stp      d9, d8, [sp, #0xf0]
0x000199e0  stp      x28, x27, [sp, #0x100]
0x000199e4  stp      x24, x23, [sp, #0x110]
0x000199e8  stp      x22, x21, [sp, #0x120]
0x000199ec  stp      x20, x19, [sp, #0x130]
0x000199f0  stp      x29, x30, [sp, #0x140]
0x000199f4  add      x29, sp, #0x140
0x000199f8  mov      x21, x3
0x000199fc  mov      x19, x2
0x00019a00  mov      x20, x0
0x00019a04  mov      x0, x2
0x00019a08  bl       #0x24818   ; call _objc_retain
0x00019a0c  cbz      w21, #0x1a02c
0x00019a10  mov      x0, x19
0x00019a14  bl       #0x27e20   ; objc_msgSend: superview
0x00019a18  mov      x29, x29
0x00019a1c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019a20  mov      x21, x0
0x00019a24  cbz      x0, #0x1a02c
0x00019a28  mov      x0, x20
0x00019a2c  bl       #0x26560   ; objc_msgSend: panel
0x00019a30  mov      x29, x29
0x00019a34  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019a38  mov      x22, x0
0x00019a3c  bl       #0x2480c   ; call _objc_release
0x00019a40  mov      x0, x21
0x00019a44  bl       #0x2480c   ; call _objc_release
0x00019a48  cbz      x22, #0x1a02c
0x00019a4c  mov      x0, x20
0x00019a50  bl       #0x24fa0   ; objc_msgSend: bubble
0x00019a54  mov      x29, x29
0x00019a58  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019a5c  mov      x21, x0
0x00019a60  bl       #0x2480c   ; call _objc_release
0x00019a64  cbnz     x21, #0x19c64
0x00019a68  adrp     x8, #0x3e000
0x00019a6c  ldr      x0, [x8, #0x3d8]   ; -> [class(UILabel)]
0x00019a70  bl       #0x247e8   ; call _objc_opt_new
0x00019a74  mov      x21, x0
0x00019a78  adrp     x23, #0x3e000
0x00019a7c  ldr      x0, [x23, #0x320]   ; -> [class(UIColor)]
0x00019a80  bl       #0x281c0   ; objc_msgSend: whiteColor
0x00019a84  mov      x29, x29
0x00019a88  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019a8c  mov      x22, x0
0x00019a90  mov      x0, x21
0x00019a94  mov      x2, x22
0x00019a98  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x00019a9c  mov      x0, x22
0x00019aa0  bl       #0x2480c   ; call _objc_release
0x00019aa4  ldr      x0, [x23, #0x320]   ; -> [class(UIColor)]
0x00019aa8  adrp     x8, #0x2b000
0x00019aac  ldr      d0, [x8, #0x218]
0x00019ab0  adrp     x8, #0x2b000
0x00019ab4  ldr      d1, [x8, #0x220]
0x00019ab8  adrp     x8, #0x2b000
0x00019abc  ldr      d2, [x8, #0x228]
0x00019ac0  fmov     d3, #1.00000000
0x00019ac4  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x00019ac8  mov      x29, x29
0x00019acc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019ad0  mov      x22, x0
0x00019ad4  mov      x0, x21
0x00019ad8  mov      x2, x22
0x00019adc  bl       #0x27900   ; objc_msgSend: setTextColor:
0x00019ae0  mov      x0, x22
0x00019ae4  bl       #0x2480c   ; call _objc_release
0x00019ae8  mov      x0, x21
0x00019aec  mov      w2, #1
0x00019af0  bl       #0x278e0   ; objc_msgSend: setTextAlignment:
0x00019af4  mov      x0, x21
0x00019af8  bl       #0x25f00   ; objc_msgSend: layer
0x00019afc  mov      x29, x29
0x00019b00  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019b04  mov      x22, x0
0x00019b08  fmov     d0, #9.00000000
0x00019b0c  bl       #0x26e20   ; objc_msgSend: setCornerRadius:
0x00019b10  mov      x0, x22
0x00019b14  bl       #0x2480c   ; call _objc_release
0x00019b18  mov      x0, x21
0x00019b1c  bl       #0x25f00   ; objc_msgSend: layer
0x00019b20  mov      x29, x29
0x00019b24  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019b28  mov      x22, x0
0x00019b2c  adrp     x8, #0x34000
0x00019b30  ldr      x8, [x8, #0x580]   ; -> [got:_kCACornerCurveContinuous]
0x00019b34  ldr      x2, [x8]   ; -> [got:___objc_personality_v0]
0x00019b38  bl       #0x26e00   ; objc_msgSend: setCornerCurve:
0x00019b3c  mov      x0, x22
0x00019b40  bl       #0x2480c   ; call _objc_release
0x00019b44  mov      x0, x21
0x00019b48  bl       #0x25f00   ; objc_msgSend: layer
0x00019b4c  mov      x29, x29
0x00019b50  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019b54  mov      x22, x0
0x00019b58  mov      w2, #0
0x00019b5c  bl       #0x27360   ; objc_msgSend: setMasksToBounds:
0x00019b60  mov      x0, x22
0x00019b64  bl       #0x2480c   ; call _objc_release
0x00019b68  ldr      x0, [x23, #0x320]   ; -> [class(UIColor)]
0x00019b6c  adrp     x8, #0x2b000
0x00019b70  ldr      d0, [x8, #0x240]
0x00019b74  adrp     x8, #0x2b000
0x00019b78  ldr      d1, [x8, #0x248]
0x00019b7c  adrp     x8, #0x2b000
0x00019b80  ldr      d2, [x8, #0x250]
0x00019b84  fmov     d3, #1.00000000
0x00019b88  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x00019b8c  mov      x29, x29
0x00019b90  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019b94  mov      x22, x0
0x00019b98  bl       #0x24824   ; call _objc_retainAutorelease
