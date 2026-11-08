; ==== sub_168a4 @ 0x168a4..0x169d8 (308 bytes) ====
0x000168a4  bl       #0x2480c   ; call _objc_release
0x000168a8  mov      x0, x21
0x000168ac  bl       #0x24470   ; call __Unwind_Resume
0x000168b0  stp      d11, d10, [sp, #-0x60]!
0x000168b4  stp      d9, d8, [sp, #0x10]
0x000168b8  stp      x24, x23, [sp, #0x20]
0x000168bc  stp      x22, x21, [sp, #0x30]
0x000168c0  stp      x20, x19, [sp, #0x40]
0x000168c4  stp      x29, x30, [sp, #0x50]
0x000168c8  add      x29, sp, #0x50
0x000168cc  mov      x19, x1
0x000168d0  mov      x22, x0
0x000168d4  mov      x0, x1
0x000168d8  bl       #0x24818   ; call _objc_retain
0x000168dc  mov      x0, x19
0x000168e0  bl       #0x24a00   ; objc_msgSend: CGContext
0x000168e4  ldr      d0, [x22, #0x28]
0x000168e8  fmov     d1, #24.00000000
0x000168ec  fdiv     d0, d0, d1
0x000168f0  mov      v1.16b, v0.16b
0x000168f4  bl       #0x24338   ; call _CGContextScaleCTM
0x000168f8  adrp     x8, #0x3e000
0x000168fc  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x00016900  bl       #0x24f00   ; objc_msgSend: blackColor
0x00016904  mov      x29, x29
0x00016908  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001690c  mov      x20, x0
0x00016910  bl       #0x26ac0   ; objc_msgSend: set
0x00016914  mov      x0, x20
0x00016918  bl       #0x2480c   ; call _objc_release
0x0001691c  adrp     x24, #0x3e000
0x00016920  ldr      x0, [x24, #0x300]   ; -> [class(UIBezierPath)]
0x00016924  bl       #0x24ea0   ; objc_msgSend: bezierPath
0x00016928  mov      x29, x29
0x0001692c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016930  mov      x20, x0
0x00016934  ldr      x0, [x24, #0x300]   ; -> [class(UIBezierPath)]
0x00016938  bl       #0x24ea0   ; objc_msgSend: bezierPath
0x0001693c  mov      x29, x29
0x00016940  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016944  mov      x21, x0
0x00016948  adrp     x8, #0x2b000
0x0001694c  ldr      d0, [x8, #0x2f8]
0x00016950  mov      x0, x20
0x00016954  bl       #0x272c0   ; objc_msgSend: setLineWidth:
0x00016958  mov      x0, x20
0x0001695c  mov      w2, #1
0x00016960  bl       #0x27280   ; objc_msgSend: setLineCapStyle:
0x00016964  mov      x0, x20
0x00016968  mov      w2, #1
0x0001696c  bl       #0x272a0   ; objc_msgSend: setLineJoinStyle:
0x00016970  ldr      x0, [x22, #0x20]
0x00016974  adrp     x2, #0x36000
0x00016978  add      x2, x2, #0xa50   ; -> @"fullscreen"
0x0001697c  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00016980  cbz      w0, #0x16a20
0x00016984  fmov     d0, #13.50000000
0x00016988  fmov     d1, #4.00000000
0x0001698c  mov      x0, x20
0x00016990  bl       #0x261c0   ; objc_msgSend: moveToPoint:
0x00016994  fmov     d0, #20.00000000
0x00016998  fmov     d1, #4.00000000
0x0001699c  mov      x0, x20
0x000169a0  bl       #0x24b00   ; objc_msgSend: addLineToPoint:
0x000169a4  fmov     d0, #20.00000000
0x000169a8  fmov     d1, #10.50000000
0x000169ac  mov      x0, x20
0x000169b0  bl       #0x24b00   ; objc_msgSend: addLineToPoint:
0x000169b4  fmov     d0, #20.00000000
0x000169b8  fmov     d1, #4.00000000
0x000169bc  mov      x0, x20
0x000169c0  bl       #0x261c0   ; objc_msgSend: moveToPoint:
0x000169c4  fmov     d0, #14.00000000
0x000169c8  fmov     d1, #10.00000000
0x000169cc  mov      x0, x20
0x000169d0  bl       #0x24b00   ; objc_msgSend: addLineToPoint:
0x000169d4  fmov     d0, #10.50000000
