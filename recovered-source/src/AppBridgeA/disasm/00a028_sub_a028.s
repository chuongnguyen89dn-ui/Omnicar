; ==== sub_a028 @ 0xa028..0xa12c (260 bytes) ====
0x0000a028  b        #0x2435c   ; call _CGRectContainsPoint
0x0000a02c  sub      sp, sp, #0x70
0x0000a030  stp      x22, x21, [sp, #0x40]
0x0000a034  stp      x20, x19, [sp, #0x50]
0x0000a038  stp      x29, x30, [sp, #0x60]
0x0000a03c  add      x29, sp, #0x60
0x0000a040  mov      x19, x2
0x0000a044  mov      x20, x0
0x0000a048  bl       #0x25d20   ; objc_msgSend: isHighlighted
0x0000a04c  mov      x21, x0
0x0000a050  adrp     x8, #0x3e000
0x0000a054  ldr      x8, [x8, #0x468]
0x0000a058  stp      x20, x8, [sp, #0x30]
0x0000a05c  adrp     x8, #0x3d000
0x0000a060  ldr      x1, [x8, #0x260]   ; -> [@selector(setHighlighted:)]
0x0000a064  add      x0, sp, #0x30
0x0000a068  mov      x2, x19
0x0000a06c  bl       #0x247c4   ; call _objc_msgSendSuper2
0x0000a070  cmp      w19, w21
0x0000a074  b.eq     #0xa0ec
0x0000a078  adrp     x8, #0x3e000
0x0000a07c  ldr      x0, [x8, #0x2d0]   ; -> [class(UIView)]
0x0000a080  cmp      w19, #0
0x0000a084  adrp     x8, #0x2b000
0x0000a088  ldr      d0, [x8, #0x1f0]
0x0000a08c  adrp     x8, #0x2b000
0x0000a090  ldr      d1, [x8, #0x1f8]
0x0000a094  fcsel    d0, d1, d0, ne
0x0000a098  adrp     x8, #0x34000
0x0000a09c  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x0000a0a0  str      x8, [sp]
0x0000a0a4  adrp     x8, #0x2b000
0x0000a0a8  ldr      d1, [x8, #0x1d0]
0x0000a0ac  str      d1, [sp, #8]
0x0000a0b0  adrp     x8, #0xa000
0x0000a0b4  add      x8, x8, #0x104
0x0000a0b8  adrp     x9, #0x34000
0x0000a0bc  add      x9, x9, #0x810
0x0000a0c0  stp      x8, x9, [sp, #0x10]
0x0000a0c4  str      x20, [sp, #0x20]
0x0000a0c8  strb     w19, [sp, #0x28]
0x0000a0cc  adrp     x8, #0x2b000
0x0000a0d0  ldr      d2, [x8, #0x200]
0x0000a0d4  fmov     d1, xzr
0x0000a0d8  fmov     d3, xzr
0x0000a0dc  mov      x3, sp
0x0000a0e0  mov      w2, #6
0x0000a0e4  mov      x4, #0
0x0000a0e8  bl       #0x24ca0   ; objc_msgSend: animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
0x0000a0ec  ldp      x29, x30, [sp, #0x60]
0x0000a0f0  ldp      x20, x19, [sp, #0x50]
0x0000a0f4  ldp      x22, x21, [sp, #0x40]
0x0000a0f8  add      sp, sp, #0x70
0x0000a0fc  ret      
0x0000a100  bl       #0x24470   ; call __Unwind_Resume
0x0000a104  sub      sp, sp, #0x80
0x0000a108  stp      x20, x19, [sp, #0x60]
0x0000a10c  stp      x29, x30, [sp, #0x70]
0x0000a110  add      x29, sp, #0x70
0x0000a114  mov      x19, x0
0x0000a118  ldrb     w8, [x0, #0x28]
0x0000a11c  cmp      w8, #1
0x0000a120  b.ne     #0xa13c
0x0000a124  adrp     x8, #0x2b000
0x0000a128  ldr      d0, [x8, #0x208]
