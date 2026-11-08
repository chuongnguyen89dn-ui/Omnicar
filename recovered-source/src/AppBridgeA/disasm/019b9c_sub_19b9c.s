; ==== sub_19b9c @ 0x19b9c..0x19c8c (240 bytes) ====
0x00019b9c  bl       #0x249e0   ; objc_msgSend: CGColor
0x00019ba0  mov      x24, x0
0x00019ba4  mov      x0, x21
0x00019ba8  bl       #0x25f00   ; objc_msgSend: layer
0x00019bac  mov      x29, x29
0x00019bb0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019bb4  mov      x23, x0
0x00019bb8  mov      x2, x24
0x00019bbc  bl       #0x276e0   ; objc_msgSend: setShadowColor:
0x00019bc0  mov      x0, x23
0x00019bc4  bl       #0x2480c   ; call _objc_release
0x00019bc8  mov      x0, x22
0x00019bcc  bl       #0x2480c   ; call _objc_release
0x00019bd0  mov      x0, x21
0x00019bd4  bl       #0x25f00   ; objc_msgSend: layer
0x00019bd8  mov      x29, x29
0x00019bdc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019be0  mov      x22, x0
0x00019be4  adrp     x8, #0x2b000
0x00019be8  ldr      s0, [x8, #0x388]
0x00019bec  bl       #0x27720   ; objc_msgSend: setShadowOpacity:
0x00019bf0  mov      x0, x22
0x00019bf4  bl       #0x2480c   ; call _objc_release
0x00019bf8  mov      x0, x21
0x00019bfc  bl       #0x25f00   ; objc_msgSend: layer
0x00019c00  mov      x29, x29
0x00019c04  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019c08  mov      x22, x0
0x00019c0c  fmov     d0, #9.00000000
0x00019c10  bl       #0x27760   ; objc_msgSend: setShadowRadius:
0x00019c14  mov      x0, x22
0x00019c18  bl       #0x2480c   ; call _objc_release
0x00019c1c  mov      x0, x21
0x00019c20  bl       #0x25f00   ; objc_msgSend: layer
0x00019c24  mov      x29, x29
0x00019c28  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019c2c  mov      x22, x0
0x00019c30  fmov     d0, xzr
0x00019c34  fmov     d1, #6.00000000
0x00019c38  bl       #0x27700   ; objc_msgSend: setShadowOffset:
0x00019c3c  mov      x0, x22
0x00019c40  bl       #0x2480c   ; call _objc_release
0x00019c44  mov      x0, x21
0x00019c48  mov      w2, #0
0x00019c4c  bl       #0x279e0   ; objc_msgSend: setUserInteractionEnabled:
0x00019c50  mov      x0, x20
0x00019c54  mov      x2, x21
0x00019c58  bl       #0x26d00   ; objc_msgSend: setBubble:
0x00019c5c  mov      x0, x21
0x00019c60  bl       #0x2480c   ; call _objc_release
0x00019c64  mov      x0, x20
0x00019c68  bl       #0x24fa0   ; objc_msgSend: bubble
0x00019c6c  mov      x29, x29
0x00019c70  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019c74  mov      x21, x0
0x00019c78  bl       #0x27e20   ; objc_msgSend: superview
0x00019c7c  mov      x29, x29
0x00019c80  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019c84  mov      x22, x0
0x00019c88  mov      x0, x20
