; ==== sub_fed4 @ 0xfed4..0x10018 (324 bytes) ====
0x0000fed4  bl       #0x26520   ; objc_msgSend: paneFor:
0x0000fed8  mov      x29, x29
0x0000fedc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000fee0  mov      x20, x0
0x0000fee4  cbz      x0, #0x101b0
0x0000fee8  fminnm   d0, d9, d8
0x0000feec  fmov     d1, #2.00000000
0x0000fef0  fcmp     d0, d1
0x0000fef4  cset     w24, mi
0x0000fef8  mov      x0, x20
0x0000fefc  bl       #0x24f60   ; objc_msgSend: box
0x0000ff00  mov      x29, x29
0x0000ff04  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ff08  mov      x25, x0
0x0000ff0c  mov      x2, x24
0x0000ff10  bl       #0x270a0   ; objc_msgSend: setHidden:
0x0000ff14  mov      x0, x25
0x0000ff18  bl       #0x2480c   ; call _objc_release
0x0000ff1c  mov      x0, x20
0x0000ff20  bl       #0x24f60   ; objc_msgSend: box
0x0000ff24  mov      x29, x29
0x0000ff28  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ff2c  mov      x25, x0
0x0000ff30  mov      v0.16b, v15.16b
0x0000ff34  mov      v1.16b, v14.16b
0x0000ff38  mov      v2.16b, v13.16b
0x0000ff3c  mov      v3.16b, v12.16b
0x0000ff40  bl       #0x274c0   ; objc_msgSend: setPassInsets:
0x0000ff44  mov      x0, x25
0x0000ff48  bl       #0x2480c   ; call _objc_release
0x0000ff4c  eor      w8, w24, #1
0x0000ff50  and      w2, w23, w8
0x0000ff54  mov      x0, x21
0x0000ff58  mov      x3, x20
0x0000ff5c  bl       #0x27080   ; objc_msgSend: setHandleVisible:forPane:
0x0000ff60  tbnz     w24, #0, #0x101b0
0x0000ff64  mov      x0, x20
0x0000ff68  bl       #0x257c0   ; objc_msgSend: frame
0x0000ff6c  mov      v12.16b, v0.16b
0x0000ff70  mov      v13.16b, v1.16b
0x0000ff74  mov      v14.16b, v2.16b
0x0000ff78  mov      v15.16b, v3.16b
0x0000ff7c  mov      x0, x20
0x0000ff80  mov      v0.16b, v11.16b
0x0000ff84  mov      v1.16b, v10.16b
0x0000ff88  mov      v2.16b, v9.16b
0x0000ff8c  mov      v3.16b, v8.16b
0x0000ff90  bl       #0x26f80   ; objc_msgSend: setFrame:
0x0000ff94  cbz      w22, #0x1001c
0x0000ff98  mov      x0, x20
0x0000ff9c  bl       #0x24f60   ; objc_msgSend: box
0x0000ffa0  mov      x29, x29
0x0000ffa4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ffa8  mov      x22, x0
0x0000ffac  mov      v0.16b, v11.16b
0x0000ffb0  mov      v1.16b, v10.16b
0x0000ffb4  mov      v2.16b, v9.16b
0x0000ffb8  mov      v3.16b, v8.16b
0x0000ffbc  bl       #0x26f80   ; objc_msgSend: setFrame:
0x0000ffc0  mov      x0, x22
0x0000ffc4  bl       #0x2480c   ; call _objc_release
0x0000ffc8  mov      x0, x20
0x0000ffcc  bl       #0x24d00   ; objc_msgSend: appViewController
0x0000ffd0  mov      x29, x29
0x0000ffd4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ffd8  mov      x23, x0
0x0000ffdc  bl       #0x28140   ; objc_msgSend: view
0x0000ffe0  mov      x29, x29
0x0000ffe4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ffe8  mov      x22, x0
0x0000ffec  mov      x0, x23
0x0000fff0  bl       #0x2480c   ; call _objc_release
0x0000fff4  fmov     d1, #0.50000000
0x0000fff8  fmul     d0, d9, d1
0x0000fffc  fmul     d1, d8, d1
0x00010000  mov      x0, x22
0x00010004  bl       #0x26d60   ; objc_msgSend: setCenter:
0x00010008  mov      x0, x21
0x0001000c  mov      x2, x20
0x00010010  bl       #0x25f20   ; objc_msgSend: layoutBarForPane:
0x00010014  mov      x0, x22
