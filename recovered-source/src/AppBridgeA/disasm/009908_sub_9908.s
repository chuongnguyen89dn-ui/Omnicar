; ==== sub_9908 @ 0x9908..0x9c64 (860 bytes) ====
0x00009908  mov      x0, x20
0x0000990c  bl       #0x25860   ; objc_msgSend: handleHit
0x00009910  mov      x29, x29
0x00009914  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009918  mov      x21, x0
0x0000991c  cbz      x0, #0x9994
0x00009920  mov      x0, x20
0x00009924  bl       #0x25860   ; objc_msgSend: handleHit
0x00009928  mov      x29, x29
0x0000992c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009930  mov      x22, x0
0x00009934  bl       #0x25d00   ; objc_msgSend: isHidden
0x00009938  cbz      w0, #0x9950
0x0000993c  mov      x0, x22
0x00009940  bl       #0x2480c   ; call _objc_release
0x00009944  mov      x0, x21
0x00009948  bl       #0x2480c   ; call _objc_release
0x0000994c  b        #0x9994   ; call sub_9994
0x00009950  mov      x0, x20
0x00009954  bl       #0x25860   ; objc_msgSend: handleHit
0x00009958  mov      x29, x29
0x0000995c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009960  mov      x23, x0
0x00009964  bl       #0x257c0   ; objc_msgSend: frame
0x00009968  mov      v4.16b, v9.16b
0x0000996c  mov      v5.16b, v8.16b
0x00009970  bl       #0x2435c   ; call _CGRectContainsPoint
0x00009974  mov      x24, x0
0x00009978  mov      x0, x23
0x0000997c  bl       #0x2480c   ; call _objc_release
0x00009980  mov      x0, x22
0x00009984  bl       #0x2480c   ; call _objc_release
0x00009988  mov      x0, x21
0x0000998c  bl       #0x2480c   ; call _objc_release
0x00009990  tbnz     w24, #0, #0x9a20
0x00009994  mov      x0, x20
0x00009998  bl       #0x24e60   ; objc_msgSend: bar
0x0000999c  mov      x29, x29
0x000099a0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000099a4  mov      x21, x0
0x000099a8  cbz      x0, #0x9a28
0x000099ac  mov      x0, x20
0x000099b0  bl       #0x24e60   ; objc_msgSend: bar
0x000099b4  mov      x29, x29
0x000099b8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000099bc  mov      x22, x0
0x000099c0  bl       #0x25d00   ; objc_msgSend: isHidden
0x000099c4  cbz      w0, #0x99dc
0x000099c8  mov      x0, x22
0x000099cc  bl       #0x2480c   ; call _objc_release
0x000099d0  mov      x0, x21
0x000099d4  bl       #0x2480c   ; call _objc_release
0x000099d8  b        #0x9a28   ; call sub_9a28
0x000099dc  mov      x0, x20
0x000099e0  bl       #0x24e60   ; objc_msgSend: bar
0x000099e4  mov      x29, x29
0x000099e8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000099ec  mov      x23, x0
0x000099f0  bl       #0x257c0   ; objc_msgSend: frame
0x000099f4  mov      v4.16b, v9.16b
0x000099f8  mov      v5.16b, v8.16b
0x000099fc  bl       #0x2435c   ; call _CGRectContainsPoint
0x00009a00  mov      x24, x0
0x00009a04  mov      x0, x23
0x00009a08  bl       #0x2480c   ; call _objc_release
0x00009a0c  mov      x0, x22
0x00009a10  bl       #0x2480c   ; call _objc_release
0x00009a14  mov      x0, x21
0x00009a18  bl       #0x2480c   ; call _objc_release
0x00009a1c  tbz      w24, #0, #0x9a28
0x00009a20  mov      w20, #1
0x00009a24  b        #0x9aac   ; call sub_9aac
0x00009a28  mov      x0, x20
0x00009a2c  bl       #0x25940   ; objc_msgSend: hole
0x00009a30  bl       #0x243c8   ; call _CGRectIsEmpty
0x00009a34  tbnz     w0, #0, #0x9a58
0x00009a38  mov      x0, x20
0x00009a3c  bl       #0x25940   ; objc_msgSend: hole
0x00009a40  mov      v4.16b, v9.16b
0x00009a44  mov      v5.16b, v8.16b
0x00009a48  bl       #0x2435c   ; call _CGRectContainsPoint
0x00009a4c  tbz      w0, #0, #0x9a58
0x00009a50  mov      w20, #0
0x00009a54  b        #0x9aac   ; call sub_9aac
0x00009a58  mov      x0, x20
0x00009a5c  bl       #0x24f40   ; objc_msgSend: bounds
0x00009a60  mov      v12.16b, v0.16b
0x00009a64  mov      v13.16b, v1.16b
0x00009a68  mov      v11.16b, v2.16b
0x00009a6c  mov      v10.16b, v3.16b
0x00009a70  mov      x0, x20
0x00009a74  bl       #0x265a0   ; objc_msgSend: passInsets
0x00009a78  fadd     d4, d12, d1
0x00009a7c  fadd     d5, d13, d0
0x00009a80  fadd     d1, d1, d3
0x00009a84  fsub     d6, d11, d1
0x00009a88  fadd     d0, d0, d2
0x00009a8c  fsub     d3, d10, d0
0x00009a90  mov      v0.16b, v4.16b
0x00009a94  mov      v1.16b, v5.16b
0x00009a98  mov      v2.16b, v6.16b
0x00009a9c  mov      v4.16b, v9.16b
0x00009aa0  mov      v5.16b, v8.16b
0x00009aa4  bl       #0x2435c   ; call _CGRectContainsPoint
0x00009aa8  mov      x20, x0
0x00009aac  mov      x0, x19
0x00009ab0  bl       #0x2480c   ; call _objc_release
0x00009ab4  mov      x0, x20
0x00009ab8  ldp      x29, x30, [sp, #0x70]
0x00009abc  ldp      x20, x19, [sp, #0x60]
0x00009ac0  ldp      x22, x21, [sp, #0x50]
0x00009ac4  ldp      x24, x23, [sp, #0x40]
0x00009ac8  ldp      d9, d8, [sp, #0x30]
0x00009acc  ldp      d11, d10, [sp, #0x20]
0x00009ad0  ldp      d13, d12, [sp, #0x10]
0x00009ad4  add      sp, sp, #0x80
0x00009ad8  ret      
0x00009adc  b        #0x9ae4   ; call sub_9ae4
0x00009ae0  b        #0x9af4   ; call sub_9af4
0x00009ae4  mov      x20, x0
0x00009ae8  mov      x0, x23
0x00009aec  bl       #0x2480c   ; call _objc_release
0x00009af0  b        #0x9b04   ; call sub_9b04
0x00009af4  mov      x20, x0
0x00009af8  b        #0x9b0c   ; call sub_9b0c
0x00009afc  b        #0x9b00   ; call sub_9b00
0x00009b00  mov      x20, x0
0x00009b04  mov      x0, x22
0x00009b08  bl       #0x2480c   ; call _objc_release
0x00009b0c  mov      x0, x21
0x00009b10  bl       #0x2480c   ; call _objc_release
0x00009b14  b        #0x9b1c   ; call sub_9b1c
0x00009b18  mov      x20, x0
0x00009b1c  mov      x0, x19
0x00009b20  bl       #0x2480c   ; call _objc_release
0x00009b24  mov      x0, x20
0x00009b28  bl       #0x24470   ; call __Unwind_Resume
0x00009b2c  stp      d11, d10, [sp, #-0x50]!
0x00009b30  stp      d9, d8, [sp, #0x10]
0x00009b34  stp      x22, x21, [sp, #0x20]
0x00009b38  stp      x20, x19, [sp, #0x30]
0x00009b3c  stp      x29, x30, [sp, #0x40]
0x00009b40  add      x29, sp, #0x40
0x00009b44  mov      v8.16b, v3.16b
0x00009b48  mov      v9.16b, v2.16b
0x00009b4c  mov      v10.16b, v1.16b
0x00009b50  mov      v11.16b, v0.16b
0x00009b54  mov      x19, x0
0x00009b58  adrp     x8, #0x3e000
0x00009b5c  ldrsw    x8, [x8, #0x478]
0x00009b60  add      x22, x0, x8
0x00009b64  ldp      d4, d5, [x22]
0x00009b68  ldp      d6, d7, [x22, #0x10]
0x00009b6c  bl       #0x24368   ; call _CGRectEqualToRect
0x00009b70  cbz      w0, #0x9bd8
0x00009b74  mov      v0.16b, v11.16b
0x00009b78  mov      v1.16b, v10.16b
0x00009b7c  mov      v2.16b, v9.16b
0x00009b80  mov      v3.16b, v8.16b
0x00009b84  bl       #0x243c8   ; call _CGRectIsEmpty
0x00009b88  tbnz     w0, #0, #0x9bc0
0x00009b8c  mov      x0, x19
0x00009b90  bl       #0x25f00   ; objc_msgSend: layer
0x00009b94  mov      x29, x29
0x00009b98  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009b9c  mov      x20, x0
0x00009ba0  bl       #0x26120   ; objc_msgSend: mask
0x00009ba4  mov      x29, x29
0x00009ba8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009bac  mov      x21, x0
0x00009bb0  bl       #0x2480c   ; call _objc_release
0x00009bb4  mov      x0, x20
0x00009bb8  bl       #0x2480c   ; call _objc_release
0x00009bbc  cbz      x21, #0x9bd8
0x00009bc0  ldp      x29, x30, [sp, #0x40]
0x00009bc4  ldp      x20, x19, [sp, #0x30]
0x00009bc8  ldp      x22, x21, [sp, #0x20]
0x00009bcc  ldp      d9, d8, [sp, #0x10]
0x00009bd0  ldp      d11, d10, [sp], #0x50
0x00009bd4  ret      
0x00009bd8  stp      d11, d10, [x22]
0x00009bdc  stp      d9, d8, [x22, #0x10]
0x00009be0  mov      x0, x19
0x00009be4  ldp      x29, x30, [sp, #0x40]
0x00009be8  ldp      x20, x19, [sp, #0x30]
0x00009bec  ldp      x22, x21, [sp, #0x20]
0x00009bf0  ldp      d9, d8, [sp, #0x10]
0x00009bf4  ldp      d11, d10, [sp], #0x50
0x00009bf8  b        #0x24da0   ; objc_msgSend: applyHole
0x00009bfc  mov      x19, x0
0x00009c00  mov      x0, x20
0x00009c04  bl       #0x2480c   ; call _objc_release
0x00009c08  mov      x0, x19
0x00009c0c  bl       #0x24470   ; call __Unwind_Resume
0x00009c10  stp      x24, x23, [sp, #-0x40]!
0x00009c14  stp      x22, x21, [sp, #0x10]
0x00009c18  stp      x20, x19, [sp, #0x20]
0x00009c1c  stp      x29, x30, [sp, #0x30]
0x00009c20  add      x29, sp, #0x30
0x00009c24  mov      x19, x0
0x00009c28  bl       #0x25940   ; objc_msgSend: hole
0x00009c2c  bl       #0x243c8   ; call _CGRectIsEmpty
0x00009c30  mov      x20, x0
0x00009c34  mov      x0, x19
0x00009c38  bl       #0x25f00   ; objc_msgSend: layer
0x00009c3c  mov      x29, x29
0x00009c40  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009c44  mov      x21, x0
0x00009c48  cbz      w20, #0x9c60
0x00009c4c  mov      x0, x21
0x00009c50  mov      x2, #0
0x00009c54  bl       #0x27320   ; objc_msgSend: setMask:
0x00009c58  mov      x20, x21
0x00009c5c  b        #0x9dc8   ; call sub_9dc8
0x00009c60  mov      x0, x21
