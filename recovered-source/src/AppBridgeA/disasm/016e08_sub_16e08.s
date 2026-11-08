; ==== sub_16e08 @ 0x16e08..0x16f78 (368 bytes) ====
0x00016e08  mov      x0, x23
0x00016e0c  bl       #0x2480c   ; call _objc_release
0x00016e10  ldr      x0, [x24, #0x300]
0x00016e14  fmov     d0, #13.00000000
0x00016e18  fmov     d1, #13.00000000
0x00016e1c  fmov     d2, #7.00000000
0x00016e20  fmov     d3, #7.00000000
0x00016e24  mov      v4.16b, v8.16b
0x00016e28  bl       #0x24ee0   ; objc_msgSend: bezierPathWithRoundedRect:cornerRadius:
0x00016e2c  mov      x29, x29
0x00016e30  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016e34  mov      x22, x0
0x00016e38  mov      x0, x20
0x00016e3c  mov      x2, x22
0x00016e40  bl       #0x24d40   ; objc_msgSend: appendPath:
0x00016e44  b        #0x16d14   ; call sub_16d14
0x00016e48  ldr      x0, [x22, #0x20]
0x00016e4c  adrp     x2, #0x36000
0x00016e50  add      x2, x2, #0x310   ; -> @"hm_full"
0x00016e54  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00016e58  cbz      w0, #0x16fb8
0x00016e5c  fmov     d0, #4.00000000
0x00016e60  fmov     d1, #9.50000000
0x00016e64  mov      x0, x20
0x00016e68  bl       #0x261c0   ; objc_msgSend: moveToPoint:
0x00016e6c  fmov     d0, #4.00000000
0x00016e70  fmov     d1, #7.50000000
0x00016e74  mov      x0, x20
0x00016e78  bl       #0x24b00   ; objc_msgSend: addLineToPoint:
0x00016e7c  adrp     x8, #0x2b000
0x00016e80  ldr      d8, [x8, #0x318]
0x00016e84  adrp     x8, #0x2b000
0x00016e88  ldr      d10, [x8, #0x320]
0x00016e8c  fmov     d0, #7.50000000
0x00016e90  fmov     d1, #7.50000000
0x00016e94  fmov     d2, #3.50000000
0x00016e98  mov      x0, x20
0x00016e9c  mov      v3.16b, v8.16b
0x00016ea0  mov      v4.16b, v10.16b
0x00016ea4  mov      w2, #1
0x00016ea8  bl       #0x24aa0   ; objc_msgSend: addArcWithCenter:radius:startAngle:endAngle:clockwise:
0x00016eac  fmov     d0, #9.50000000
0x00016eb0  fmov     d1, #4.00000000
0x00016eb4  mov      x0, x20
0x00016eb8  bl       #0x24b00   ; objc_msgSend: addLineToPoint:
0x00016ebc  fmov     d0, #14.50000000
0x00016ec0  fmov     d1, #4.00000000
0x00016ec4  mov      x0, x20
0x00016ec8  bl       #0x261c0   ; objc_msgSend: moveToPoint:
0x00016ecc  adrp     x8, #0x2b000
0x00016ed0  ldr      d9, [x8, #0x328]
0x00016ed4  fmov     d1, #4.00000000
0x00016ed8  mov      x0, x20
0x00016edc  mov      v0.16b, v9.16b
0x00016ee0  bl       #0x24b00   ; objc_msgSend: addLineToPoint:
0x00016ee4  fmov     d1, #7.50000000
0x00016ee8  fmov     d2, #3.50000000
0x00016eec  fmov     d4, xzr
0x00016ef0  mov      x0, x20
0x00016ef4  mov      v0.16b, v9.16b
0x00016ef8  mov      v3.16b, v10.16b
0x00016efc  mov      w2, #1
0x00016f00  bl       #0x24aa0   ; objc_msgSend: addArcWithCenter:radius:startAngle:endAngle:clockwise:
0x00016f04  fmov     d0, #20.00000000
0x00016f08  fmov     d1, #9.50000000
0x00016f0c  mov      x0, x20
0x00016f10  bl       #0x24b00   ; objc_msgSend: addLineToPoint:
0x00016f14  fmov     d0, #20.00000000
0x00016f18  fmov     d1, #14.50000000
0x00016f1c  mov      x0, x20
0x00016f20  bl       #0x261c0   ; objc_msgSend: moveToPoint:
0x00016f24  fmov     d0, #20.00000000
0x00016f28  mov      x0, x20
0x00016f2c  mov      v1.16b, v9.16b
0x00016f30  bl       #0x24b00   ; objc_msgSend: addLineToPoint:
0x00016f34  adrp     x8, #0x2b000
0x00016f38  ldr      d10, [x8, #0x330]
0x00016f3c  fmov     d2, #3.50000000
0x00016f40  fmov     d3, xzr
0x00016f44  mov      x0, x20
0x00016f48  mov      v0.16b, v9.16b
0x00016f4c  mov      v1.16b, v9.16b
0x00016f50  mov      v4.16b, v10.16b
0x00016f54  mov      w2, #1
0x00016f58  bl       #0x24aa0   ; objc_msgSend: addArcWithCenter:radius:startAngle:endAngle:clockwise:
0x00016f5c  fmov     d0, #14.50000000
0x00016f60  fmov     d1, #20.00000000
0x00016f64  mov      x0, x20
0x00016f68  bl       #0x24b00   ; objc_msgSend: addLineToPoint:
0x00016f6c  fmov     d0, #9.50000000
0x00016f70  fmov     d1, #20.00000000
0x00016f74  mov      x0, x20
