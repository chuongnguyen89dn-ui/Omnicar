; ==== sub_17148 @ 0x17148..0x17378 (560 bytes) ====
0x00017148  mov      v0.16b, v8.16b
0x0001714c  bl       #0x261c0   ; objc_msgSend: moveToPoint:
0x00017150  b        #0x16b7c   ; call sub_16b7c
0x00017154  b        #0x17194   ; call sub_17194
0x00017158  b        #0x17178   ; call sub_17178
0x0001715c  b        #0x17194   ; call sub_17194
0x00017160  b        #0x17178   ; call sub_17178
0x00017164  b        #0x17194   ; call sub_17194
0x00017168  b        #0x17178   ; call sub_17178
0x0001716c  b        #0x17178   ; call sub_17178
0x00017170  b        #0x17178   ; call sub_17178
0x00017174  b        #0x17194   ; call sub_17194
0x00017178  mov      x22, x0
0x0001717c  mov      x0, x23
0x00017180  b        #0x171a0   ; call sub_171a0
0x00017184  b        #0x17194   ; call sub_17194
0x00017188  b        #0x17194   ; call sub_17194
0x0001718c  b        #0x17194   ; call sub_17194
0x00017190  b        #0x17194   ; call sub_17194
0x00017194  mov      x1, x22
0x00017198  mov      x22, x0
0x0001719c  mov      x0, x1
0x000171a0  bl       #0x2480c   ; call _objc_release
0x000171a4  b        #0x171c4   ; call sub_171c4
0x000171a8  b        #0x171b0   ; call sub_171b0
0x000171ac  b        #0x171b8   ; call sub_171b8
0x000171b0  mov      x22, x0
0x000171b4  b        #0x171cc   ; call sub_171cc
0x000171b8  mov      x22, x0
0x000171bc  b        #0x171d4   ; call sub_171d4
0x000171c0  mov      x22, x0
0x000171c4  mov      x0, x21
0x000171c8  bl       #0x2480c   ; call _objc_release
0x000171cc  mov      x0, x20
0x000171d0  bl       #0x2480c   ; call _objc_release
0x000171d4  mov      x0, x19
0x000171d8  bl       #0x2480c   ; call _objc_release
0x000171dc  mov      x0, x22
0x000171e0  bl       #0x24470   ; call __Unwind_Resume
0x000171e4  sub      sp, sp, #0xb0
0x000171e8  stp      d9, d8, [sp, #0x60]
0x000171ec  stp      x24, x23, [sp, #0x70]
0x000171f0  stp      x22, x21, [sp, #0x80]
0x000171f4  stp      x20, x19, [sp, #0x90]
0x000171f8  stp      x29, x30, [sp, #0xa0]
0x000171fc  add      x29, sp, #0xa0
0x00017200  mov      x19, x0
0x00017204  ldrb     w8, [x0, #0x38]
0x00017208  cmp      w8, #1
0x0001720c  b.ne     #0x17228
0x00017210  adrp     x8, #0x2b000
0x00017214  ldr      d0, [x8, #0x310]
0x00017218  add      x8, sp, #0x30
0x0001721c  mov      v1.16b, v0.16b
0x00017220  bl       #0x242e4   ; call _CGAffineTransformMakeScale
0x00017224  b        #0x17240   ; call sub_17240
0x00017228  adrp     x8, #0x34000
0x0001722c  ldr      x8, [x8, #0x4b0]   ; -> [got:_CGAffineTransformIdentity]
0x00017230  ldp      q0, q1, [x8]
0x00017234  stp      q0, q1, [sp, #0x30]
0x00017238  ldr      q0, [x8, #0x20]   ; -> [got:_class_getClassMethod]
0x0001723c  str      q0, [sp, #0x50]
0x00017240  ldp      q0, q1, [sp, #0x30]
0x00017244  stp      q0, q1, [sp]
0x00017248  ldr      q0, [sp, #0x50]
0x0001724c  str      q0, [sp, #0x20]
0x00017250  ldr      x0, [x19, #0x20]
0x00017254  mov      x2, sp
0x00017258  bl       #0x279a0   ; objc_msgSend: setTransform:
0x0001725c  ldr      b0, [x19, #0x38]
0x00017260  ucvtf    s0, s0
0x00017264  ldr      x0, [x19, #0x28]
0x00017268  bl       #0x27420   ; objc_msgSend: setOpacity:
0x0001726c  ldrb     w8, [x19, #0x38]
0x00017270  adrp     x23, #0x3e000
0x00017274  ldr      x0, [x23, #0x320]   ; -> [class(UIColor)]
0x00017278  cmp      w8, #1
0x0001727c  b.ne     #0x17290
0x00017280  bl       #0x281c0   ; objc_msgSend: whiteColor
0x00017284  mov      x29, x29
0x00017288  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001728c  b        #0x172b8   ; call sub_172b8
0x00017290  adrp     x8, #0x2b000
0x00017294  ldr      d0, [x8, #0x218]
0x00017298  adrp     x8, #0x2b000
0x0001729c  ldr      d1, [x8, #0x220]
0x000172a0  adrp     x8, #0x2b000
0x000172a4  ldr      d2, [x8, #0x228]
0x000172a8  fmov     d3, #1.00000000
0x000172ac  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x000172b0  mov      x29, x29
0x000172b4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000172b8  mov      x20, x0
0x000172bc  bl       #0x24824   ; call _objc_retainAutorelease
0x000172c0  bl       #0x249e0   ; objc_msgSend: CGColor
0x000172c4  mov      x2, x0
0x000172c8  ldr      x0, [x19, #0x30]
0x000172cc  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x000172d0  mov      x0, x20
0x000172d4  bl       #0x2480c   ; call _objc_release
0x000172d8  ldr      x0, [x23, #0x320]   ; -> [class(UIColor)]
0x000172dc  ldrb     w8, [x19, #0x38]
0x000172e0  cmp      w8, #0
0x000172e4  adrp     x8, #0x2b000
0x000172e8  ldr      d0, [x8, #0x260]
0x000172ec  fmov     d1, #1.00000000
0x000172f0  fcsel    d1, d1, d0, ne
0x000172f4  fmov     d0, #1.00000000
0x000172f8  bl       #0x25240   ; objc_msgSend: colorWithWhite:alpha:
0x000172fc  mov      x29, x29
0x00017300  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00017304  mov      x20, x0
0x00017308  bl       #0x24824   ; call _objc_retainAutorelease
0x0001730c  bl       #0x249e0   ; objc_msgSend: CGColor
0x00017310  mov      x22, x0
0x00017314  ldr      x0, [x19, #0x20]
0x00017318  bl       #0x25f00   ; objc_msgSend: layer
0x0001731c  mov      x29, x29
0x00017320  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00017324  mov      x21, x0
0x00017328  mov      x2, x22
0x0001732c  bl       #0x26c80   ; objc_msgSend: setBorderColor:
0x00017330  mov      x0, x21
0x00017334  bl       #0x2480c   ; call _objc_release
0x00017338  mov      x0, x20
0x0001733c  bl       #0x2480c   ; call _objc_release
0x00017340  ldrb     w8, [x19, #0x38]
0x00017344  ldr      x0, [x23, #0x320]   ; -> [class(UIColor)]
0x00017348  cmp      w8, #1
0x0001734c  b.ne     #0x17368
0x00017350  adrp     x8, #0x2b000
0x00017354  ldr      d0, [x8, #0x240]
0x00017358  adrp     x8, #0x2b000
0x0001735c  ldr      d1, [x8, #0x380]
0x00017360  fmov     d2, #1.00000000
0x00017364  b        #0x17380   ; call sub_17380
0x00017368  adrp     x8, #0x2b000
0x0001736c  ldr      d0, [x8, #0x240]
0x00017370  adrp     x8, #0x2b000
0x00017374  ldr      d1, [x8, #0x248]
