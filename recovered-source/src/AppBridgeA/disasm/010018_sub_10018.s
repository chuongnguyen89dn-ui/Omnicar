; ==== sub_10018 @ 0x10018..0x10120 (264 bytes) ====
0x00010018  b        #0x101ac   ; call sub_101ac
0x0001001c  mov      v0.16b, v12.16b
0x00010020  mov      v1.16b, v13.16b
0x00010024  mov      v2.16b, v14.16b
0x00010028  mov      v3.16b, v15.16b
0x0001002c  mov      v4.16b, v11.16b
0x00010030  mov      v5.16b, v10.16b
0x00010034  mov      v6.16b, v9.16b
0x00010038  mov      v7.16b, v8.16b
0x0001003c  bl       #0x24368   ; call _CGRectEqualToRect
0x00010040  fmov     d0, xzr
0x00010044  tbnz     w0, #0, #0x1006c
0x00010048  mov      v0.16b, v12.16b
0x0001004c  mov      v1.16b, v13.16b
0x00010050  mov      v2.16b, v14.16b
0x00010054  mov      v3.16b, v15.16b
0x00010058  bl       #0x243c8   ; call _CGRectIsEmpty
0x0001005c  cmp      w0, #0
0x00010060  fmov     d0, #0.25000000
0x00010064  fmov     d1, xzr
0x00010068  fcsel    d0, d1, d0, ne
0x0001006c  adrp     x8, #0x3e000
0x00010070  ldr      x22, [x8, #0x2d0]   ; -> [class(UIView)]
0x00010074  adrp     x8, #0x34000
0x00010078  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x0001007c  str      x8, [sp, #0x20]
0x00010080  adrp     x8, #0x2b000
0x00010084  mov      v12.16b, v0.16b
0x00010088  ldr      d0, [x8, #0x1d0]
0x0001008c  str      d0, [sp, #0x28]
0x00010090  adrp     x8, #0x10000
0x00010094  add      x8, x8, #0x284
0x00010098  adrp     x9, #0x34000
0x0001009c  add      x9, x9, #0x960
0x000100a0  stp      x8, x9, [sp, #0x30]
0x000100a4  mov      x0, x20
0x000100a8  bl       #0x24818   ; call _objc_retain
0x000100ac  stp      d11, d10, [sp, #0x50]
0x000100b0  stp      d9, d8, [sp, #0x60]
0x000100b4  stp      x20, x21, [sp, #0x40]
0x000100b8  fmov     d1, xzr
0x000100bc  add      x3, sp, #0x20
0x000100c0  mov      x0, x22
0x000100c4  mov      v0.16b, v12.16b
0x000100c8  mov      x2, #0
0x000100cc  mov      x4, #0
0x000100d0  bl       #0x24c80   ; objc_msgSend: animateWithDuration:delay:options:animations:completion:
0x000100d4  mov      x0, x20
0x000100d8  bl       #0x26a20   ; objc_msgSend: sceneBox
0x000100dc  fcmp     d0, d9
0x000100e0  b.ne     #0x10124
0x000100e4  fcmp     d1, d8
0x000100e8  b.ne     #0x10124
0x000100ec  mov      x0, x20
0x000100f0  bl       #0x24d00   ; objc_msgSend: appViewController
0x000100f4  mov      x29, x29
0x000100f8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000100fc  mov      x22, x0
0x00010100  bl       #0x28140   ; objc_msgSend: view
0x00010104  mov      x29, x29
0x00010108  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001010c  mov      x23, x0
0x00010110  fmov     d1, #0.50000000
0x00010114  fmul     d0, d9, d1
0x00010118  fmul     d1, d8, d1
0x0001011c  bl       #0x26d60   ; objc_msgSend: setCenter:
