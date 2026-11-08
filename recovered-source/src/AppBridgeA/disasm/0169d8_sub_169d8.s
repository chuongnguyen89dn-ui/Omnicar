; ==== sub_169d8 @ 0x169d8..0x16ce4 (780 bytes) ====
0x000169d8  fmov     d1, #20.00000000
0x000169dc  mov      x0, x20
0x000169e0  bl       #0x261c0   ; objc_msgSend: moveToPoint:
0x000169e4  fmov     d0, #4.00000000
0x000169e8  fmov     d1, #20.00000000
0x000169ec  mov      x0, x20
0x000169f0  bl       #0x24b00   ; objc_msgSend: addLineToPoint:
0x000169f4  fmov     d0, #4.00000000
0x000169f8  fmov     d1, #13.50000000
0x000169fc  mov      x0, x20
0x00016a00  bl       #0x24b00   ; objc_msgSend: addLineToPoint:
0x00016a04  fmov     d0, #4.00000000
0x00016a08  fmov     d1, #20.00000000
0x00016a0c  mov      x0, x20
0x00016a10  bl       #0x261c0   ; objc_msgSend: moveToPoint:
0x00016a14  fmov     d8, #14.00000000
0x00016a18  fmov     d9, #10.00000000
0x00016a1c  b        #0x16b7c   ; call sub_16b7c
0x00016a20  ldr      x0, [x22, #0x20]
0x00016a24  adrp     x2, #0x36000
0x00016a28  add      x2, x2, #0x530   ; -> @"replace"
0x00016a2c  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00016a30  cbz      w0, #0x16b30
0x00016a34  ldr      x0, [x24, #0x300]
0x00016a38  adrp     x8, #0x2b000
0x00016a3c  ldr      d8, [x8, #0x370]
0x00016a40  fmov     d0, #3.50000000
0x00016a44  fmov     d1, #3.50000000
0x00016a48  fmov     d2, #7.50000000
0x00016a4c  fmov     d3, #7.50000000
0x00016a50  mov      v4.16b, v8.16b
0x00016a54  bl       #0x24ee0   ; objc_msgSend: bezierPathWithRoundedRect:cornerRadius:
0x00016a58  mov      x29, x29
0x00016a5c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016a60  mov      x22, x0
0x00016a64  mov      x0, x20
0x00016a68  mov      x2, x22
0x00016a6c  bl       #0x24d40   ; objc_msgSend: appendPath:
0x00016a70  mov      x0, x22
0x00016a74  bl       #0x2480c   ; call _objc_release
0x00016a78  ldr      x0, [x24, #0x300]
0x00016a7c  fmov     d0, #13.00000000
0x00016a80  fmov     d1, #3.50000000
0x00016a84  fmov     d2, #7.50000000
0x00016a88  fmov     d3, #7.50000000
0x00016a8c  mov      v4.16b, v8.16b
0x00016a90  bl       #0x24ee0   ; objc_msgSend: bezierPathWithRoundedRect:cornerRadius:
0x00016a94  mov      x29, x29
0x00016a98  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016a9c  mov      x22, x0
0x00016aa0  mov      x0, x20
0x00016aa4  mov      x2, x22
0x00016aa8  bl       #0x24d40   ; objc_msgSend: appendPath:
0x00016aac  mov      x0, x22
0x00016ab0  bl       #0x2480c   ; call _objc_release
0x00016ab4  ldr      x0, [x24, #0x300]
0x00016ab8  fmov     d0, #3.50000000
0x00016abc  fmov     d1, #13.00000000
0x00016ac0  fmov     d2, #7.50000000
0x00016ac4  fmov     d3, #7.50000000
0x00016ac8  mov      v4.16b, v8.16b
0x00016acc  bl       #0x24ee0   ; objc_msgSend: bezierPathWithRoundedRect:cornerRadius:
0x00016ad0  mov      x29, x29
0x00016ad4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016ad8  mov      x22, x0
0x00016adc  mov      x0, x20
0x00016ae0  mov      x2, x22
0x00016ae4  bl       #0x24d40   ; objc_msgSend: appendPath:
0x00016ae8  mov      x0, x22
0x00016aec  bl       #0x2480c   ; call _objc_release
0x00016af0  adrp     x8, #0x2b000
0x00016af4  ldr      d8, [x8, #0x378]
0x00016af8  fmov     d1, #13.50000000
0x00016afc  mov      x0, x20
0x00016b00  mov      v0.16b, v8.16b
0x00016b04  bl       #0x261c0   ; objc_msgSend: moveToPoint:
0x00016b08  fmov     d9, #20.00000000
0x00016b0c  fmov     d1, #20.00000000
0x00016b10  mov      x0, x20
0x00016b14  mov      v0.16b, v8.16b
0x00016b18  bl       #0x24b00   ; objc_msgSend: addLineToPoint:
0x00016b1c  fmov     d0, #13.50000000
0x00016b20  mov      x0, x20
0x00016b24  mov      v1.16b, v8.16b
0x00016b28  bl       #0x261c0   ; objc_msgSend: moveToPoint:
0x00016b2c  b        #0x16b7c   ; call sub_16b7c
0x00016b30  ldr      x0, [x22, #0x20]
0x00016b34  adrp     x2, #0x36000
0x00016b38  add      x2, x2, #0x590   ; -> @"close"
0x00016b3c  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00016b40  cbz      w0, #0x16bcc
0x00016b44  fmov     d0, #7.00000000
0x00016b48  fmov     d1, #7.00000000
0x00016b4c  mov      x0, x20
0x00016b50  bl       #0x261c0   ; objc_msgSend: moveToPoint:
0x00016b54  fmov     d8, #17.00000000
0x00016b58  fmov     d0, #17.00000000
0x00016b5c  fmov     d1, #17.00000000
0x00016b60  mov      x0, x20
0x00016b64  bl       #0x24b00   ; objc_msgSend: addLineToPoint:
0x00016b68  fmov     d9, #7.00000000
0x00016b6c  fmov     d0, #17.00000000
0x00016b70  fmov     d1, #7.00000000
0x00016b74  mov      x0, x20
0x00016b78  bl       #0x261c0   ; objc_msgSend: moveToPoint:
0x00016b7c  mov      x0, x20
0x00016b80  mov      v0.16b, v9.16b
0x00016b84  mov      v1.16b, v8.16b
0x00016b88  bl       #0x24b00   ; objc_msgSend: addLineToPoint:
0x00016b8c  mov      x0, x20
0x00016b90  bl       #0x27d60   ; objc_msgSend: stroke
0x00016b94  mov      x0, x21
0x00016b98  bl       #0x25760   ; objc_msgSend: fill
0x00016b9c  mov      x0, x21
0x00016ba0  bl       #0x2480c   ; call _objc_release
0x00016ba4  mov      x0, x20
0x00016ba8  bl       #0x2480c   ; call _objc_release
0x00016bac  mov      x0, x19
0x00016bb0  ldp      x29, x30, [sp, #0x50]
0x00016bb4  ldp      x20, x19, [sp, #0x40]
0x00016bb8  ldp      x22, x21, [sp, #0x30]
0x00016bbc  ldp      x24, x23, [sp, #0x20]
0x00016bc0  ldp      d9, d8, [sp, #0x10]
0x00016bc4  ldp      d11, d10, [sp], #0x60
0x00016bc8  b        #0x2480c   ; call _objc_release
0x00016bcc  ldr      x0, [x22, #0x20]
0x00016bd0  adrp     x2, #0x36000
0x00016bd4  add      x2, x2, #0xa70   ; -> @"float"
0x00016bd8  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00016bdc  cbz      w0, #0x16c58
0x00016be0  ldr      x0, [x24, #0x300]
0x00016be4  fmov     d0, #3.50000000
0x00016be8  fmov     d1, #4.50000000
0x00016bec  fmov     d2, #17.00000000
0x00016bf0  fmov     d3, #15.00000000
0x00016bf4  fmov     d4, #3.00000000
0x00016bf8  bl       #0x24ee0   ; objc_msgSend: bezierPathWithRoundedRect:cornerRadius:
0x00016bfc  mov      x29, x29
0x00016c00  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016c04  mov      x22, x0
0x00016c08  mov      x0, x20
0x00016c0c  mov      x2, x22
0x00016c10  bl       #0x24d40   ; objc_msgSend: appendPath:
0x00016c14  mov      x0, x22
0x00016c18  bl       #0x2480c   ; call _objc_release
0x00016c1c  ldr      x0, [x24, #0x300]
0x00016c20  adrp     x8, #0x2b000
0x00016c24  ldr      d4, [x8, #0x310]
0x00016c28  fmov     d0, #11.50000000
0x00016c2c  fmov     d1, #11.00000000
0x00016c30  fmov     d2, #6.50000000
0x00016c34  fmov     d3, #6.00000000
0x00016c38  bl       #0x24ee0   ; objc_msgSend: bezierPathWithRoundedRect:cornerRadius:
0x00016c3c  mov      x29, x29
0x00016c40  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016c44  mov      x22, x0
0x00016c48  mov      x0, x21
0x00016c4c  mov      x2, x22
0x00016c50  bl       #0x24d40   ; objc_msgSend: appendPath:
0x00016c54  b        #0x16d14   ; call sub_16d14
0x00016c58  ldr      x0, [x22, #0x20]
0x00016c5c  adrp     x2, #0x36000
0x00016c60  add      x2, x2, #0xa90   ; -> @"dock"
0x00016c64  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00016c68  cbz      w0, #0x16d20
0x00016c6c  ldr      x0, [x24, #0x300]
0x00016c70  fmov     d0, #3.50000000
0x00016c74  fmov     d1, #4.50000000
0x00016c78  fmov     d2, #17.00000000
0x00016c7c  fmov     d3, #15.00000000
0x00016c80  fmov     d4, #3.00000000
0x00016c84  bl       #0x24ee0   ; objc_msgSend: bezierPathWithRoundedRect:cornerRadius:
0x00016c88  mov      x29, x29
0x00016c8c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016c90  mov      x23, x0
0x00016c94  mov      x0, x20
0x00016c98  mov      x2, x23
0x00016c9c  bl       #0x24d40   ; objc_msgSend: appendPath:
0x00016ca0  mov      x0, x23
0x00016ca4  bl       #0x2480c   ; call _objc_release
0x00016ca8  fmov     d0, #12.00000000
0x00016cac  fmov     d1, #4.50000000
0x00016cb0  mov      x0, x20
0x00016cb4  bl       #0x261c0   ; objc_msgSend: moveToPoint:
0x00016cb8  adrp     x8, #0x2b000
0x00016cbc  ldr      d1, [x8, #0x340]
0x00016cc0  fmov     d0, #12.00000000
0x00016cc4  mov      x0, x20
0x00016cc8  bl       #0x24b00   ; objc_msgSend: addLineToPoint:
0x00016ccc  ldr      x0, [x24, #0x300]
0x00016cd0  adrp     x8, #0x2b000
0x00016cd4  ldr      d0, [x8, #0x348]
0x00016cd8  adrp     x8, #0x2b000
0x00016cdc  ldr      d1, [x8, #0x350]
0x00016ce0  adrp     x8, #0x2b000
