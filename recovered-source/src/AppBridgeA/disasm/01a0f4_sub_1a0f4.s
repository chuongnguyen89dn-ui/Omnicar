; ==== sub_1a0f4 @ 0x1a0f4..0x1a3e8 (756 bytes) ====
0x0001a0f4  mov      x0, x23
0x0001a0f8  bl       #0x2480c   ; call _objc_release
0x0001a0fc  b        #0x1a140   ; call sub_1a140
0x0001a100  b        #0x1a13c   ; call sub_1a13c
0x0001a104  b        #0x1a13c   ; call sub_1a13c
0x0001a108  b        #0x1a15c   ; call sub_1a15c
0x0001a10c  b        #0x1a15c   ; call sub_1a15c
0x0001a110  b        #0x1a15c   ; call sub_1a15c
0x0001a114  b        #0x1a15c   ; call sub_1a15c
0x0001a118  b        #0x1a15c   ; call sub_1a15c
0x0001a11c  b        #0x1a15c   ; call sub_1a15c
0x0001a120  b        #0x1a15c   ; call sub_1a15c
0x0001a124  b        #0x1a13c   ; call sub_1a13c
0x0001a128  b        #0x1a150   ; call sub_1a150
0x0001a12c  b        #0x1a15c   ; call sub_1a15c
0x0001a130  b        #0x1a15c   ; call sub_1a15c
0x0001a134  b        #0x1a13c   ; call sub_1a13c
0x0001a138  b        #0x1a15c   ; call sub_1a15c
0x0001a13c  mov      x20, x0
0x0001a140  mov      x0, x22
0x0001a144  bl       #0x2480c   ; call _objc_release
0x0001a148  b        #0x1a160   ; call sub_1a160
0x0001a14c  b        #0x1a150   ; call sub_1a150
0x0001a150  mov      x20, x0
0x0001a154  b        #0x1a168   ; call sub_1a168
0x0001a158  b        #0x1a15c   ; call sub_1a15c
0x0001a15c  mov      x20, x0
0x0001a160  mov      x0, x21
0x0001a164  bl       #0x2480c   ; call _objc_release
0x0001a168  mov      x0, x19
0x0001a16c  bl       #0x2480c   ; call _objc_release
0x0001a170  mov      x0, x20
0x0001a174  bl       #0x24470   ; call __Unwind_Resume
0x0001a178  stp      x20, x19, [sp, #-0x20]!
0x0001a17c  stp      x29, x30, [sp, #0x10]
0x0001a180  add      x29, sp, #0x10
0x0001a184  ldr      x0, [x0, #0x20]
0x0001a188  bl       #0x24fa0   ; objc_msgSend: bubble
0x0001a18c  mov      x29, x29
0x0001a190  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a194  mov      x19, x0
0x0001a198  fmov     d0, xzr
0x0001a19c  bl       #0x26b40   ; objc_msgSend: setAlpha:
0x0001a1a0  mov      x0, x19
0x0001a1a4  ldp      x29, x30, [sp, #0x10]
0x0001a1a8  ldp      x20, x19, [sp], #0x20
0x0001a1ac  b        #0x2480c   ; call _objc_release
0x0001a1b0  mov      x20, x0
0x0001a1b4  mov      x0, x19
0x0001a1b8  bl       #0x2480c   ; call _objc_release
0x0001a1bc  mov      x0, x20
0x0001a1c0  bl       #0x24470   ; call __Unwind_Resume
0x0001a1c4  sub      sp, sp, #0x40
0x0001a1c8  stp      x29, x30, [sp, #0x30]
0x0001a1cc  add      x29, sp, #0x30
0x0001a1d0  adrp     x8, #0x34000
0x0001a1d4  ldr      x8, [x8, #0x4b0]   ; -> [got:_CGAffineTransformIdentity]
0x0001a1d8  ldp      q0, q1, [x8]
0x0001a1dc  stp      q0, q1, [sp]
0x0001a1e0  ldr      q0, [x8, #0x20]   ; -> [got:_class_getClassMethod]
0x0001a1e4  str      q0, [sp, #0x20]
0x0001a1e8  ldr      x0, [x0, #0x20]
0x0001a1ec  mov      x2, sp
0x0001a1f0  bl       #0x279a0   ; objc_msgSend: setTransform:
0x0001a1f4  ldp      x29, x30, [sp, #0x30]
0x0001a1f8  add      sp, sp, #0x40
0x0001a1fc  ret      
0x0001a200  sub      sp, sp, #0x90
0x0001a204  stp      d11, d10, [sp, #0x10]
0x0001a208  stp      d9, d8, [sp, #0x20]
0x0001a20c  stp      x28, x27, [sp, #0x30]
0x0001a210  stp      x26, x25, [sp, #0x40]
0x0001a214  stp      x24, x23, [sp, #0x50]
0x0001a218  stp      x22, x21, [sp, #0x60]
0x0001a21c  stp      x20, x19, [sp, #0x70]
0x0001a220  stp      x29, x30, [sp, #0x80]
0x0001a224  add      x29, sp, #0x80
0x0001a228  mov      x22, x0
0x0001a22c  adrp     x8, #0x3e000
0x0001a230  ldr      x0, [x8, #0x2d0]   ; -> [class(UIView)]
0x0001a234  bl       #0x247e8   ; call _objc_opt_new
0x0001a238  mov      x19, x0
0x0001a23c  adrp     x8, #0x3e000
0x0001a240  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x0001a244  bl       #0x251a0   ; objc_msgSend: clearColor
0x0001a248  mov      x29, x29
0x0001a24c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a250  mov      x20, x0
0x0001a254  mov      x0, x19
0x0001a258  mov      x2, x20
0x0001a25c  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x0001a260  mov      x0, x20
0x0001a264  bl       #0x2480c   ; call _objc_release
0x0001a268  adrp     x8, #0x3e000
0x0001a26c  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x0001a270  adrp     x8, #0x2b000
0x0001a274  ldr      d0, [x8, #0x240]
0x0001a278  adrp     x8, #0x2b000
0x0001a27c  ldr      d1, [x8, #0x248]
0x0001a280  adrp     x8, #0x2b000
0x0001a284  ldr      d2, [x8, #0x250]
0x0001a288  fmov     d3, #1.00000000
0x0001a28c  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001a290  mov      x29, x29
0x0001a294  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a298  mov      x20, x0
0x0001a29c  bl       #0x24824   ; call _objc_retainAutorelease
0x0001a2a0  bl       #0x249e0   ; objc_msgSend: CGColor
0x0001a2a4  mov      x23, x0
0x0001a2a8  mov      x0, x19
0x0001a2ac  bl       #0x25f00   ; objc_msgSend: layer
0x0001a2b0  mov      x29, x29
0x0001a2b4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a2b8  mov      x21, x0
0x0001a2bc  mov      x2, x23
0x0001a2c0  bl       #0x276e0   ; objc_msgSend: setShadowColor:
0x0001a2c4  mov      x0, x21
0x0001a2c8  bl       #0x2480c   ; call _objc_release
0x0001a2cc  mov      x0, x20
0x0001a2d0  bl       #0x2480c   ; call _objc_release
0x0001a2d4  mov      x0, x19
0x0001a2d8  bl       #0x25f00   ; objc_msgSend: layer
0x0001a2dc  mov      x29, x29
0x0001a2e0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a2e4  mov      x20, x0
0x0001a2e8  adrp     x8, #0x2b000
0x0001a2ec  ldr      s0, [x8, #0x388]
0x0001a2f0  bl       #0x27720   ; objc_msgSend: setShadowOpacity:
0x0001a2f4  mov      x0, x20
0x0001a2f8  bl       #0x2480c   ; call _objc_release
0x0001a2fc  mov      x0, x19
0x0001a300  bl       #0x25f00   ; objc_msgSend: layer
0x0001a304  mov      x29, x29
0x0001a308  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a30c  mov      x20, x0
0x0001a310  fmov     d0, #20.00000000
0x0001a314  bl       #0x27760   ; objc_msgSend: setShadowRadius:
0x0001a318  mov      x0, x20
0x0001a31c  bl       #0x2480c   ; call _objc_release
0x0001a320  mov      x0, x19
0x0001a324  bl       #0x25f00   ; objc_msgSend: layer
0x0001a328  mov      x29, x29
0x0001a32c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a330  mov      x20, x0
0x0001a334  fmov     d0, xzr
0x0001a338  fmov     d1, #6.00000000
0x0001a33c  bl       #0x27700   ; objc_msgSend: setShadowOffset:
0x0001a340  mov      x0, x20
0x0001a344  bl       #0x2480c   ; call _objc_release
0x0001a348  mov      x0, x19
0x0001a34c  mov      x2, #0
0x0001a350  bl       #0x26c00   ; objc_msgSend: setAutoresizingMask:
0x0001a354  adrp     x8, #0x3e000
0x0001a358  ldr      x0, [x8, #0x350]   ; -> [class(UIVisualEffectView)]
0x0001a35c  bl       #0x2471c   ; call _objc_alloc
0x0001a360  mov      x20, x0
0x0001a364  adrp     x8, #0x3e000
0x0001a368  ldr      x0, [x8, #0x358]   ; -> [class(UIBlurEffect)]
0x0001a36c  mov      w2, #0xb
0x0001a370  bl       #0x25680   ; objc_msgSend: effectWithStyle:
0x0001a374  mov      x29, x29
0x0001a378  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a37c  mov      x21, x0
0x0001a380  mov      x0, x20
0x0001a384  mov      x2, x21
0x0001a388  bl       #0x25a20   ; objc_msgSend: initWithEffect:
0x0001a38c  mov      x20, x0
0x0001a390  mov      x0, x21
0x0001a394  bl       #0x2480c   ; call _objc_release
0x0001a398  adrp     x8, #0x3e000
0x0001a39c  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x0001a3a0  bl       #0x251a0   ; objc_msgSend: clearColor
0x0001a3a4  mov      x29, x29
0x0001a3a8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a3ac  mov      x21, x0
0x0001a3b0  mov      x0, x20
0x0001a3b4  bl       #0x253a0   ; objc_msgSend: contentView
0x0001a3b8  mov      x29, x29
0x0001a3bc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a3c0  mov      x23, x0
0x0001a3c4  mov      x2, x21
0x0001a3c8  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x0001a3cc  mov      x0, x23
0x0001a3d0  bl       #0x2480c   ; call _objc_release
0x0001a3d4  mov      x0, x21
0x0001a3d8  bl       #0x2480c   ; call _objc_release
0x0001a3dc  adrp     x8, #0x3e000
0x0001a3e0  ldr      x0, [x8, #0x360]   ; -> [class(UIImageView)]
0x0001a3e4  bl       #0x2471c   ; call _objc_alloc
