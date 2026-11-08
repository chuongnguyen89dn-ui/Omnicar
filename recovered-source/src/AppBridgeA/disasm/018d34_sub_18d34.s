; ==== sub_18d34 @ 0x18d34..0x191a8 (1140 bytes) ====
0x00018d34  mov      x1, #0
0x00018d38  ldp      x29, x30, [sp, #0x10]
0x00018d3c  ldp      x20, x19, [sp], #0x20
0x00018d40  b        #0x24860   ; call _objc_storeStrong
0x00018d44  stp      x20, x19, [sp, #-0x20]!
0x00018d48  stp      x29, x30, [sp, #0x10]
0x00018d4c  add      x29, sp, #0x10
0x00018d50  adrp     x8, #0x3e000
0x00018d54  ldr      x8, [x8, #0xa58]
0x00018d58  cmn      x8, #1
0x00018d5c  b.ne     #0x18d80
0x00018d60  adrp     x8, #0x3e000
0x00018d64  ldr      x19, [x8, #0xa50]
0x00018d68  mov      x0, x19
0x00018d6c  bl       #0x24818   ; call _objc_retain
0x00018d70  mov      x0, x19
0x00018d74  ldp      x29, x30, [sp, #0x10]
0x00018d78  ldp      x20, x19, [sp], #0x20
0x00018d7c  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x00018d80  bl       #0x241cc   ; call sub_241cc
0x00018d84  b        #0x18d60   ; call sub_18d60
0x00018d88  stp      x29, x30, [sp, #-0x10]!
0x00018d8c  mov      x29, sp
0x00018d90  adrp     x8, #0x3e000
0x00018d94  ldr      x0, [x8, #0x2e8]   ; -> [class(ABKeyboard)]
0x00018d98  bl       #0x247e8   ; call _objc_opt_new
0x00018d9c  adrp     x9, #0x3e000
0x00018da0  ldr      x8, [x9, #0xa50]
0x00018da4  str      x0, [x9, #0xa50]
0x00018da8  mov      x0, x8
0x00018dac  ldp      x29, x30, [sp], #0x10
0x00018db0  b        #0x2480c   ; call _objc_release
0x00018db4  sub      sp, sp, #0x130
0x00018db8  stp      x28, x27, [sp, #0xd0]
0x00018dbc  stp      x26, x25, [sp, #0xe0]
0x00018dc0  stp      x24, x23, [sp, #0xf0]
0x00018dc4  stp      x22, x21, [sp, #0x100]
0x00018dc8  stp      x20, x19, [sp, #0x110]
0x00018dcc  stp      x29, x30, [sp, #0x120]
0x00018dd0  add      x29, sp, #0x120
0x00018dd4  mov      x22, x4
0x00018dd8  mov      x21, x3
0x00018ddc  mov      x19, x2
0x00018de0  mov      x23, x0
0x00018de4  mov      x0, x2
0x00018de8  bl       #0x24818   ; call _objc_retain
0x00018dec  adrp     x8, #0x3e000
0x00018df0  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x00018df4  bl       #0x27b20   ; objc_msgSend: shared
0x00018df8  mov      x29, x29
0x00018dfc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018e00  mov      x24, x0
0x00018e04  bl       #0x25120   ; objc_msgSend: carWindow
0x00018e08  mov      x29, x29
0x00018e0c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018e10  mov      x20, x0
0x00018e14  mov      x0, x24
0x00018e18  bl       #0x2480c   ; call _objc_release
0x00018e1c  cbz      x19, #0x18e7c
0x00018e20  cbz      x20, #0x18e7c
0x00018e24  mov      x0, x23
0x00018e28  bl       #0x24ce0   ; objc_msgSend: app
0x00018e2c  mov      x29, x29
0x00018e30  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018e34  mov      x24, x0
0x00018e38  mov      x2, x19
0x00018e3c  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00018e40  cbz      w0, #0x18eb4
0x00018e44  mov      x0, x23
0x00018e48  bl       #0x26560   ; objc_msgSend: panel
0x00018e4c  mov      x29, x29
0x00018e50  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018e54  mov      x25, x0
0x00018e58  bl       #0x27e20   ; objc_msgSend: superview
0x00018e5c  mov      x29, x29
0x00018e60  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018e64  cmp      x0, #0
0x00018e68  cset     w27, eq
0x00018e6c  bl       #0x2480c   ; call _objc_release
0x00018e70  mov      x0, x25
0x00018e74  bl       #0x2480c   ; call _objc_release
0x00018e78  b        #0x18eb8   ; call sub_18eb8
0x00018e7c  adrp     x8, #0x3e000
0x00018e80  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x00018e84  str      x19, [sp]
0x00018e88  adrp     x2, #0x36000
0x00018e8c  add      x2, x2, #0xc30   ; -> @"ban phim xe: khong co cua so (%@)"
0x00018e90  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00018e94  mov      x29, x29
0x00018e98  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018e9c  mov      x22, x0
0x00018ea0  adrp     x0, #0x34000
0x00018ea4  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00018ea8  mov      x1, x22
0x00018eac  bl       #0x1dd30   ; call _OMCLogWrite
0x00018eb0  b        #0x19200   ; call sub_19200
0x00018eb4  mov      w27, #1
0x00018eb8  mov      x0, x24
0x00018ebc  bl       #0x2480c   ; call _objc_release
0x00018ec0  mov      x0, x23
0x00018ec4  mov      x2, x19
0x00018ec8  bl       #0x26b80   ; objc_msgSend: setApp:
0x00018ecc  mov      x0, x23
0x00018ed0  mov      x2, x22
0x00018ed4  bl       #0x27620   ; objc_msgSend: setReturnType:
0x00018ed8  adrp     x8, #0x3e000
0x00018edc  ldr      x25, [x8, #0x2a0]   ; -> [class(NSNumber)]
0x00018ee0  bl       #0x236a0   ; call _OMCCurrentLanguage
0x00018ee4  mov      x29, x29
0x00018ee8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018eec  mov      x24, x0
0x00018ef0  adrp     x2, #0x36000
0x00018ef4  add      x2, x2, #0xc70   ; -> @"vi"
0x00018ef8  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00018efc  mov      x2, x0
0x00018f00  mov      x0, x25
0x00018f04  bl       #0x26320   ; objc_msgSend: numberWithInt:
0x00018f08  mov      x29, x29
0x00018f0c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018f10  mov      x25, x0
0x00018f14  adrp     x0, #0x36000
0x00018f18  add      x0, x0, #0xc50   ; -> @"appBridgeKeyboardLang"
0x00018f1c  mov      x1, x25
0x00018f20  bl       #0x1d680   ; call _OMCPref
0x00018f24  mov      x29, x29
0x00018f28  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018f2c  mov      x26, x0
0x00018f30  bl       #0x25ba0   ; objc_msgSend: intValue
0x00018f34  cmp      w0, #1
0x00018f38  cset     w2, eq
0x00018f3c  mov      x0, x23
0x00018f40  bl       #0x27a40   ; objc_msgSend: setVietnamese:
0x00018f44  mov      x0, x26
0x00018f48  bl       #0x2480c   ; call _objc_release
0x00018f4c  mov      x0, x25
0x00018f50  bl       #0x2480c   ; call _objc_release
0x00018f54  mov      x0, x24
0x00018f58  bl       #0x2480c   ; call _objc_release
0x00018f5c  cmp      x21, #0xc
0x00018f60  cset     w8, lo
0x00018f64  mov      w9, #0x934
0x00018f68  lsr      w9, w9, w21
0x00018f6c  and      w2, w8, w9
0x00018f70  mov      x0, x23
0x00018f74  bl       #0x273e0   ; objc_msgSend: setNumbers:
0x00018f78  mov      x0, x23
0x00018f7c  mov      w2, #0
0x00018f80  bl       #0x27800   ; objc_msgSend: setShift:
0x00018f84  cbz      w27, #0x18fdc
0x00018f88  adrp     x25, #0x3e000
0x00018f8c  ldr      x0, [x25, #0x3c0]   ; -> [class(NSMutableString)]
0x00018f90  bl       #0x27c40   ; objc_msgSend: string
0x00018f94  mov      x29, x29
0x00018f98  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018f9c  mov      x24, x0
0x00018fa0  mov      x0, x23
0x00018fa4  mov      x2, x24
0x00018fa8  bl       #0x27ac0   ; objc_msgSend: setWord:
0x00018fac  mov      x0, x24
0x00018fb0  bl       #0x2480c   ; call _objc_release
0x00018fb4  ldr      x0, [x25, #0x3c0]   ; -> [class(NSMutableString)]
0x00018fb8  bl       #0x27c40   ; objc_msgSend: string
0x00018fbc  mov      x29, x29
0x00018fc0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018fc4  mov      x24, x0
0x00018fc8  mov      x0, x23
0x00018fcc  mov      x2, x24
0x00018fd0  bl       #0x279c0   ; objc_msgSend: setTyped:
0x00018fd4  mov      x0, x24
0x00018fd8  bl       #0x2480c   ; call _objc_release
0x00018fdc  mov      x0, x23
0x00018fe0  bl       #0x26560   ; objc_msgSend: panel
0x00018fe4  mov      x29, x29
0x00018fe8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00018fec  mov      x24, x0
0x00018ff0  bl       #0x2480c   ; call _objc_release
0x00018ff4  cbnz     x24, #0x19000
0x00018ff8  mov      x0, x23
0x00018ffc  bl       #0x24fe0   ; objc_msgSend: buildPanel
0x00019000  mov      x0, x23
0x00019004  bl       #0x26560   ; objc_msgSend: panel
0x00019008  mov      x29, x29
0x0001900c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019010  mov      x24, x0
0x00019014  bl       #0x27e20   ; objc_msgSend: superview
0x00019018  mov      x29, x29
0x0001901c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019020  mov      x25, x0
0x00019024  bl       #0x2480c   ; call _objc_release
0x00019028  mov      x0, x24
0x0001902c  bl       #0x2480c   ; call _objc_release
0x00019030  cmp      x25, x20
0x00019034  b.eq     #0x19060
0x00019038  mov      x0, x23
0x0001903c  bl       #0x26560   ; objc_msgSend: panel
0x00019040  mov      x29, x29
0x00019044  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019048  mov      x24, x0
0x0001904c  mov      x0, x20
0x00019050  mov      x2, x24
0x00019054  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x00019058  mov      x0, x24
0x0001905c  bl       #0x2480c   ; call _objc_release
0x00019060  mov      x0, x23
0x00019064  mov      x2, x20
0x00019068  bl       #0x25f80   ; objc_msgSend: layoutPanelIn:
0x0001906c  mov      x0, x23
0x00019070  bl       #0x26560   ; objc_msgSend: panel
0x00019074  mov      x29, x29
0x00019078  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001907c  mov      x24, x0
0x00019080  mov      x0, x20
0x00019084  mov      x2, x24
0x00019088  bl       #0x24f80   ; objc_msgSend: bringSubviewToFront:
0x0001908c  mov      x0, x24
0x00019090  bl       #0x2480c   ; call _objc_release
0x00019094  mov      x0, x23
0x00019098  bl       #0x267c0   ; objc_msgSend: rebuildKeys
0x0001909c  mov      x0, x23
0x000190a0  bl       #0x28080   ; objc_msgSend: updatePreview
0x000190a4  cbz      w27, #0x191c8
0x000190a8  mov      x0, x23
0x000190ac  bl       #0x26560   ; objc_msgSend: panel
0x000190b0  mov      x29, x29
0x000190b4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000190b8  mov      x24, x0
0x000190bc  bl       #0x24f40   ; objc_msgSend: bounds
0x000190c0  sub      x26, x29, #0x80
0x000190c4  fmov     d0, #12.00000000
0x000190c8  fadd     d1, d3, d0
0x000190cc  add      x8, sp, #0x70
0x000190d0  fmov     d0, xzr
0x000190d4  bl       #0x242f0   ; call _CGAffineTransformMakeTranslation
0x000190d8  ldp      q0, q1, [sp, #0x70]
0x000190dc  stp      q0, q1, [x26]
0x000190e0  ldr      q0, [sp, #0x90]
0x000190e4  str      q0, [x26, #0x20]
0x000190e8  mov      x0, x23
0x000190ec  bl       #0x26560   ; objc_msgSend: panel
0x000190f0  mov      x29, x29
0x000190f4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000190f8  mov      x25, x0
0x000190fc  ldp      q0, q1, [x26]
0x00019100  stp      q0, q1, [sp, #0x40]
0x00019104  ldr      q0, [x26, #0x20]
0x00019108  str      q0, [sp, #0x60]
0x0001910c  add      x2, sp, #0x40
0x00019110  bl       #0x279a0   ; objc_msgSend: setTransform:
0x00019114  mov      x0, x25
0x00019118  bl       #0x2480c   ; call _objc_release
0x0001911c  mov      x0, x24
0x00019120  bl       #0x2480c   ; call _objc_release
0x00019124  adrp     x8, #0x3e000
0x00019128  ldr      x0, [x8, #0x3c8]   ; -> [class(UIViewPropertyAnimator)]
0x0001912c  bl       #0x2471c   ; call _objc_alloc
0x00019130  mov      x24, x0
0x00019134  adrp     x8, #0x3e000
0x00019138  ldr      x0, [x8, #0x3d0]   ; -> [class(UICubicTimingParameters)]
0x0001913c  bl       #0x2471c   ; call _objc_alloc
0x00019140  adrp     x8, #0x2b000
0x00019144  ldr      d0, [x8, #0x1d8]
0x00019148  fmov     d1, xzr
0x0001914c  fmov     d3, #1.00000000
0x00019150  mov      v2.16b, v0.16b
0x00019154  bl       #0x259e0   ; objc_msgSend: initWithControlPoint1:controlPoint2:
0x00019158  mov      x25, x0
0x0001915c  adrp     x8, #0x2b000
0x00019160  ldr      d0, [x8, #0x268]
0x00019164  mov      x0, x24
0x00019168  mov      x2, x25
0x0001916c  bl       #0x25a00   ; objc_msgSend: initWithDuration:timingParameters:
0x00019170  mov      x24, x0
0x00019174  mov      x0, x25
0x00019178  bl       #0x2480c   ; call _objc_release
0x0001917c  adrp     x8, #0x34000
0x00019180  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x00019184  str      x8, [sp, #0x18]
0x00019188  adrp     x8, #0x2b000
0x0001918c  ldr      d0, [x8, #0x1d0]
0x00019190  adrp     x8, #0x19000
0x00019194  add      x8, x8, #0x2ec
0x00019198  str      d0, [sp, #0x20]
0x0001919c  adrp     x9, #0x34000
0x000191a0  add      x9, x9, #0x890
0x000191a4  stp      x8, x9, [sp, #0x28]
