; ==== sub_16f78 @ 0x16f78..0x17148 (464 bytes) ====
0x00016f78  bl       #0x261c0   ; objc_msgSend: moveToPoint:
0x00016f7c  fmov     d0, #7.50000000
0x00016f80  fmov     d1, #20.00000000
0x00016f84  mov      x0, x20
0x00016f88  bl       #0x24b00   ; objc_msgSend: addLineToPoint:
0x00016f8c  fmov     d0, #7.50000000
0x00016f90  fmov     d2, #3.50000000
0x00016f94  mov      x0, x20
0x00016f98  mov      v1.16b, v9.16b
0x00016f9c  mov      v3.16b, v10.16b
0x00016fa0  mov      v4.16b, v8.16b
0x00016fa4  mov      w2, #1
0x00016fa8  bl       #0x24aa0   ; objc_msgSend: addArcWithCenter:radius:startAngle:endAngle:clockwise:
0x00016fac  fmov     d8, #14.50000000
0x00016fb0  fmov     d9, #4.00000000
0x00016fb4  b        #0x16b7c   ; call sub_16b7c
0x00016fb8  ldr      x0, [x22, #0x20]
0x00016fbc  adrp     x2, #0x36000
0x00016fc0  add      x2, x2, #0x490   ; -> @"hm_split"
0x00016fc4  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00016fc8  cbz      w0, #0x17040
0x00016fcc  ldr      x0, [x24, #0x300]
0x00016fd0  fmov     d0, #3.50000000
0x00016fd4  fmov     d1, #4.50000000
0x00016fd8  fmov     d2, #7.50000000
0x00016fdc  fmov     d3, #15.00000000
0x00016fe0  fmov     d4, #2.50000000
0x00016fe4  bl       #0x24ee0   ; objc_msgSend: bezierPathWithRoundedRect:cornerRadius:
0x00016fe8  mov      x29, x29
0x00016fec  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016ff0  mov      x23, x0
0x00016ff4  mov      x0, x20
0x00016ff8  mov      x2, x23
0x00016ffc  bl       #0x24d40   ; objc_msgSend: appendPath:
0x00017000  mov      x0, x23
0x00017004  bl       #0x2480c   ; call _objc_release
0x00017008  ldr      x0, [x24, #0x300]
0x0001700c  fmov     d0, #13.00000000
0x00017010  fmov     d1, #4.50000000
0x00017014  fmov     d2, #7.50000000
0x00017018  fmov     d3, #15.00000000
0x0001701c  fmov     d4, #2.50000000
0x00017020  bl       #0x24ee0   ; objc_msgSend: bezierPathWithRoundedRect:cornerRadius:
0x00017024  mov      x29, x29
0x00017028  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001702c  mov      x22, x0
0x00017030  mov      x0, x20
0x00017034  mov      x2, x22
0x00017038  bl       #0x24d40   ; objc_msgSend: appendPath:
0x0001703c  b        #0x16d14   ; call sub_16d14
0x00017040  ldr      x0, [x22, #0x20]
0x00017044  adrp     x2, #0x36000
0x00017048  add      x2, x2, #0x370   ; -> @"hm_float"
0x0001704c  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00017050  cbz      w0, #0x170cc
0x00017054  ldr      x0, [x24, #0x300]
0x00017058  fmov     d0, #3.50000000
0x0001705c  fmov     d1, #4.50000000
0x00017060  fmov     d2, #17.00000000
0x00017064  fmov     d3, #15.00000000
0x00017068  fmov     d4, #3.00000000
0x0001706c  bl       #0x24ee0   ; objc_msgSend: bezierPathWithRoundedRect:cornerRadius:
0x00017070  mov      x29, x29
0x00017074  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00017078  mov      x23, x0
0x0001707c  mov      x0, x20
0x00017080  mov      x2, x23
0x00017084  bl       #0x24d40   ; objc_msgSend: appendPath:
0x00017088  mov      x0, x23
0x0001708c  bl       #0x2480c   ; call _objc_release
0x00017090  ldr      x0, [x24, #0x300]
0x00017094  adrp     x8, #0x2b000
0x00017098  ldr      d4, [x8, #0x310]
0x0001709c  fmov     d0, #11.50000000
0x000170a0  fmov     d1, #11.50000000
0x000170a4  fmov     d2, #6.50000000
0x000170a8  fmov     d3, #5.50000000
0x000170ac  bl       #0x24ee0   ; objc_msgSend: bezierPathWithRoundedRect:cornerRadius:
0x000170b0  mov      x29, x29
0x000170b4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000170b8  mov      x22, x0
0x000170bc  mov      x0, x21
0x000170c0  mov      x2, x22
0x000170c4  bl       #0x24d40   ; objc_msgSend: appendPath:
0x000170c8  b        #0x16d14   ; call sub_16d14
0x000170cc  ldr      x0, [x22, #0x20]
0x000170d0  adrp     x2, #0x36000
0x000170d4  add      x2, x2, #0x3d0   ; -> @"hm_min"
0x000170d8  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x000170dc  cbz      w0, #0x17100
0x000170e0  fmov     d8, #12.00000000
0x000170e4  fmov     d0, #5.50000000
0x000170e8  fmov     d1, #12.00000000
0x000170ec  mov      x0, x20
0x000170f0  bl       #0x261c0   ; objc_msgSend: moveToPoint:
0x000170f4  adrp     x8, #0x2b000
0x000170f8  ldr      d9, [x8, #0x308]
0x000170fc  b        #0x16b7c   ; call sub_16b7c
0x00017100  ldr      x0, [x22, #0x20]
0x00017104  adrp     x2, #0x36000
0x00017108  add      x2, x2, #0x430   ; -> @"hm_close"
0x0001710c  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00017110  cbz      w0, #0x16b8c
0x00017114  fmov     d0, #6.50000000
0x00017118  fmov     d1, #6.50000000
0x0001711c  mov      x0, x20
0x00017120  bl       #0x261c0   ; objc_msgSend: moveToPoint:
0x00017124  adrp     x8, #0x2b000
0x00017128  ldr      d8, [x8, #0x300]
0x0001712c  mov      x0, x20
0x00017130  mov      v0.16b, v8.16b
0x00017134  mov      v1.16b, v8.16b
0x00017138  bl       #0x24b00   ; objc_msgSend: addLineToPoint:
0x0001713c  fmov     d9, #6.50000000
0x00017140  fmov     d1, #6.50000000
0x00017144  mov      x0, x20
