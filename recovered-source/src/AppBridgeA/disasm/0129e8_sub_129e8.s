; ==== sub_129e8 @ 0x129e8..0x12c80 (664 bytes) ====
0x000129e8  stp      x29, x30, [sp, #0x40]
0x000129ec  add      x29, sp, #0x40
0x000129f0  mov      x19, x3
0x000129f4  mov      x20, x2
0x000129f8  mov      x0, x3
0x000129fc  bl       #0x24818   ; call _objc_retain
0x00012a00  cbz      x19, #0x12c54
0x00012a04  tbz      w20, #0, #0x12c28
0x00012a08  mov      x0, x19
0x00012a0c  bl       #0x27b60   ; objc_msgSend: shield
0x00012a10  mov      x29, x29
0x00012a14  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012a18  mov      x20, x0
0x00012a1c  bl       #0x2480c   ; call _objc_release
0x00012a20  cbnz     x20, #0x12adc
0x00012a24  adrp     x8, #0x3e000
0x00012a28  ldr      x0, [x8, #0x368]   ; -> [class(ABShieldView)]
0x00012a2c  bl       #0x2471c   ; call _objc_alloc
0x00012a30  mov      x21, x0
0x00012a34  mov      x0, x19
0x00012a38  bl       #0x24f60   ; objc_msgSend: box
0x00012a3c  mov      x29, x29
0x00012a40  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012a44  mov      x20, x0
0x00012a48  bl       #0x24f40   ; objc_msgSend: bounds
0x00012a4c  mov      x0, x21
0x00012a50  bl       #0x25a40   ; objc_msgSend: initWithFrame:
0x00012a54  mov      x21, x0
0x00012a58  mov      x0, x20
0x00012a5c  bl       #0x2480c   ; call _objc_release
0x00012a60  adrp     x8, #0x3e000
0x00012a64  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x00012a68  adrp     x8, #0x2b000
0x00012a6c  ldr      d1, [x8, #0x2c8]
0x00012a70  fmov     d0, #1.00000000
0x00012a74  bl       #0x25240   ; objc_msgSend: colorWithWhite:alpha:
0x00012a78  mov      x29, x29
0x00012a7c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012a80  mov      x20, x0
0x00012a84  mov      x0, x21
0x00012a88  mov      x2, x20
0x00012a8c  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x00012a90  mov      x0, x20
0x00012a94  bl       #0x2480c   ; call _objc_release
0x00012a98  mov      x0, x21
0x00012a9c  mov      w2, #0x12
0x00012aa0  bl       #0x26c00   ; objc_msgSend: setAutoresizingMask:
0x00012aa4  mov      x0, x19
0x00012aa8  mov      x2, x21
0x00012aac  bl       #0x27780   ; objc_msgSend: setShield:
0x00012ab0  mov      x0, x19
0x00012ab4  bl       #0x24f60   ; objc_msgSend: box
0x00012ab8  mov      x29, x29
0x00012abc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012ac0  mov      x20, x0
0x00012ac4  mov      x2, x21
0x00012ac8  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x00012acc  mov      x0, x20
0x00012ad0  bl       #0x2480c   ; call _objc_release
0x00012ad4  mov      x0, x21
0x00012ad8  bl       #0x2480c   ; call _objc_release
0x00012adc  mov      x0, x19
0x00012ae0  bl       #0x24f60   ; objc_msgSend: box
0x00012ae4  mov      x29, x29
0x00012ae8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012aec  mov      x21, x0
0x00012af0  bl       #0x24f40   ; objc_msgSend: bounds
0x00012af4  mov      v8.16b, v0.16b
0x00012af8  mov      v9.16b, v1.16b
0x00012afc  mov      v10.16b, v2.16b
0x00012b00  mov      v11.16b, v3.16b
0x00012b04  mov      x0, x19
0x00012b08  bl       #0x27b60   ; objc_msgSend: shield
0x00012b0c  mov      x29, x29
0x00012b10  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012b14  mov      x20, x0
0x00012b18  mov      v0.16b, v8.16b
0x00012b1c  mov      v1.16b, v9.16b
0x00012b20  mov      v2.16b, v10.16b
0x00012b24  mov      v3.16b, v11.16b
0x00012b28  bl       #0x26f80   ; objc_msgSend: setFrame:
0x00012b2c  mov      x0, x20
0x00012b30  bl       #0x2480c   ; call _objc_release
0x00012b34  mov      x0, x21
0x00012b38  bl       #0x2480c   ; call _objc_release
0x00012b3c  mov      x0, x19
0x00012b40  bl       #0x24f60   ; objc_msgSend: box
0x00012b44  mov      x29, x29
0x00012b48  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012b4c  mov      x21, x0
0x00012b50  mov      x0, x19
0x00012b54  bl       #0x27b60   ; objc_msgSend: shield
0x00012b58  mov      x29, x29
0x00012b5c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012b60  mov      x20, x0
0x00012b64  mov      x0, x21
0x00012b68  mov      x2, x20
0x00012b6c  bl       #0x24f80   ; objc_msgSend: bringSubviewToFront:
0x00012b70  mov      x0, x20
0x00012b74  bl       #0x2480c   ; call _objc_release
0x00012b78  mov      x0, x21
0x00012b7c  bl       #0x2480c   ; call _objc_release
0x00012b80  mov      x0, x19
0x00012b84  bl       #0x24e60   ; objc_msgSend: bar
0x00012b88  mov      x29, x29
0x00012b8c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012b90  mov      x20, x0
0x00012b94  bl       #0x2480c   ; call _objc_release
0x00012b98  cbz      x20, #0x12be0
0x00012b9c  mov      x0, x19
0x00012ba0  bl       #0x24f60   ; objc_msgSend: box
0x00012ba4  mov      x29, x29
0x00012ba8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012bac  mov      x21, x0
0x00012bb0  mov      x0, x19
0x00012bb4  bl       #0x24e60   ; objc_msgSend: bar
0x00012bb8  mov      x29, x29
0x00012bbc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012bc0  mov      x20, x0
0x00012bc4  mov      x0, x21
0x00012bc8  mov      x2, x20
0x00012bcc  bl       #0x24f80   ; objc_msgSend: bringSubviewToFront:
0x00012bd0  mov      x0, x20
0x00012bd4  bl       #0x2480c   ; call _objc_release
0x00012bd8  mov      x0, x21
0x00012bdc  bl       #0x2480c   ; call _objc_release
0x00012be0  mov      x0, x19
0x00012be4  bl       #0x24f60   ; objc_msgSend: box
0x00012be8  mov      x29, x29
0x00012bec  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012bf0  mov      x21, x0
0x00012bf4  mov      x0, x19
0x00012bf8  bl       #0x25860   ; objc_msgSend: handleHit
0x00012bfc  mov      x29, x29
0x00012c00  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012c04  mov      x20, x0
0x00012c08  mov      x0, x21
0x00012c0c  mov      x2, x20
0x00012c10  bl       #0x24f80   ; objc_msgSend: bringSubviewToFront:
0x00012c14  mov      x0, x20
0x00012c18  bl       #0x2480c   ; call _objc_release
0x00012c1c  mov      x0, x21
0x00012c20  bl       #0x2480c   ; call _objc_release
0x00012c24  b        #0x12c54   ; call sub_12c54
0x00012c28  mov      x0, x19
0x00012c2c  bl       #0x27b60   ; objc_msgSend: shield
0x00012c30  mov      x29, x29
0x00012c34  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012c38  mov      x21, x0
0x00012c3c  bl       #0x26840   ; objc_msgSend: removeFromSuperview
0x00012c40  mov      x0, x21
0x00012c44  bl       #0x2480c   ; call _objc_release
0x00012c48  mov      x0, x19
0x00012c4c  mov      x2, #0
0x00012c50  bl       #0x27780   ; objc_msgSend: setShield:
0x00012c54  mov      x0, x19
0x00012c58  ldp      x29, x30, [sp, #0x40]
0x00012c5c  ldp      x20, x19, [sp, #0x30]
0x00012c60  ldp      x22, x21, [sp, #0x20]
0x00012c64  ldp      d9, d8, [sp, #0x10]
0x00012c68  ldp      d11, d10, [sp], #0x50
0x00012c6c  b        #0x2480c   ; call _objc_release
0x00012c70  b        #0x12ca4   ; call sub_12ca4
0x00012c74  b        #0x12ca4   ; call sub_12ca4
0x00012c78  b        #0x12ca4   ; call sub_12ca4
0x00012c7c  b        #0x12cc0   ; call sub_12cc0
