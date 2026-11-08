; ==== sub_122a0 @ 0x122a0..0x124f0 (592 bytes) ====
0x000122a0  ldr      x0, [sp]
0x000122a4  mov      x2, x22
0x000122a8  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x000122ac  cmp      w20, #0
0x000122b0  csel     x0, x22, x22, ne
0x000122b4  bl       #0x2480c   ; call _objc_release
0x000122b8  movi     v0.16b, #0
0x000122bc  stp      q0, q0, [sp, #0x30]
0x000122c0  stp      q0, q0, [sp, #0x10]
0x000122c4  ldr      x0, [sp]
0x000122c8  bl       #0x27e00   ; objc_msgSend: subviews
0x000122cc  mov      x29, x29
0x000122d0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000122d4  mov      x22, x0
0x000122d8  add      x2, sp, #0x10
0x000122dc  add      x3, sp, #0x90
0x000122e0  mov      w4, #0x10
0x000122e4  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x000122e8  mov      x23, x0
0x000122ec  cbz      x0, #0x123e0
0x000122f0  ldr      x8, [sp, #0x20]
0x000122f4  ldr      x28, [x8]
0x000122f8  adrp     x19, #0x3e000
0x000122fc  adrp     x8, #0x2b000
0x00012300  ldr      d8, [x8, #0x218]
0x00012304  adrp     x8, #0x2b000
0x00012308  ldr      d9, [x8, #0x220]
0x0001230c  adrp     x8, #0x2b000
0x00012310  ldr      d10, [x8, #0x228]
0x00012314  adrp     x8, #0x2b000
0x00012318  ldr      d11, [x8, #0x258]
0x0001231c  mov      x21, #0
0x00012320  ldr      x8, [sp, #0x20]
0x00012324  ldr      x8, [x8]
0x00012328  cmp      x8, x28
0x0001232c  b.eq     #0x12338
0x00012330  mov      x0, x22
0x00012334  bl       #0x24770   ; call _objc_enumerationMutation
0x00012338  ldr      x8, [sp, #0x18]
0x0001233c  ldr      x27, [x8, x21, lsl #3]
0x00012340  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x00012344  cbz      w20, #0x12360
0x00012348  bl       #0x281c0   ; objc_msgSend: whiteColor
0x0001234c  mov      x29, x29
0x00012350  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012354  mov      x2, x0
0x00012358  mov      x25, x0
0x0001235c  b        #0x12398   ; call sub_12398
0x00012360  fmov     d3, #1.00000000
0x00012364  mov      v0.16b, v8.16b
0x00012368  mov      v1.16b, v9.16b
0x0001236c  mov      v2.16b, v10.16b
0x00012370  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x00012374  mov      x29, x29
0x00012378  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001237c  mov      x24, x0
0x00012380  mov      v0.16b, v11.16b
0x00012384  bl       #0x25200   ; objc_msgSend: colorWithAlphaComponent:
0x00012388  mov      x29, x29
0x0001238c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012390  mov      x2, x0
0x00012394  mov      x26, x0
0x00012398  mov      x0, x27
0x0001239c  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x000123a0  mov      x0, x25
0x000123a4  tbnz     w20, #0, #0x123b4
0x000123a8  mov      x0, x26
0x000123ac  bl       #0x2480c   ; call _objc_release
0x000123b0  mov      x0, x24
0x000123b4  bl       #0x2480c   ; call _objc_release
0x000123b8  add      x21, x21, #1
0x000123bc  cmp      x23, x21
0x000123c0  b.ne     #0x12320
0x000123c4  add      x2, sp, #0x10
0x000123c8  add      x3, sp, #0x90
0x000123cc  mov      x0, x22
0x000123d0  mov      w4, #0x10
0x000123d4  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x000123d8  mov      x23, x0
0x000123dc  cbnz     x0, #0x1231c
0x000123e0  mov      x0, x22
0x000123e4  bl       #0x2480c   ; call _objc_release
0x000123e8  ldr      x0, [sp, #8]
0x000123ec  bl       #0x2480c   ; call _objc_release
0x000123f0  ldr      x19, [sp]
0x000123f4  mov      x0, x19
0x000123f8  bl       #0x2480c   ; call _objc_release
0x000123fc  ldur     x8, [x29, #-0x80]
0x00012400  adrp     x9, #0x34000
0x00012404  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00012408  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0001240c  cmp      x9, x8
0x00012410  b.ne     #0x1243c
0x00012414  add      sp, sp, #0x1b0
0x00012418  ldp      x29, x30, [sp, #0x70]
0x0001241c  ldp      x20, x19, [sp, #0x60]
0x00012420  ldp      x22, x21, [sp, #0x50]
0x00012424  ldp      x24, x23, [sp, #0x40]
0x00012428  ldp      x26, x25, [sp, #0x30]
0x0001242c  ldp      x28, x27, [sp, #0x20]
0x00012430  ldp      d9, d8, [sp, #0x10]
0x00012434  ldp      d11, d10, [sp], #0x80
0x00012438  ret      
0x0001243c  bl       #0x24488   ; call ___stack_chk_fail
0x00012440  mov      x23, x0
0x00012444  ldr      x0, [sp, #8]
0x00012448  bl       #0x2480c   ; call _objc_release
0x0001244c  b        #0x125a8   ; call sub_125a8
0x00012450  mov      x23, x0
0x00012454  mov      x0, x24
0x00012458  bl       #0x2480c   ; call _objc_release
0x0001245c  mov      x0, x22
0x00012460  bl       #0x2480c   ; call _objc_release
0x00012464  b        #0x125a8   ; call sub_125a8
0x00012468  mov      x23, x0
0x0001246c  mov      x0, x25
0x00012470  bl       #0x2480c   ; call _objc_release
0x00012474  b        #0x124d8   ; call sub_124d8
0x00012478  mov      x23, x0
0x0001247c  mov      x0, x24
0x00012480  bl       #0x2480c   ; call _objc_release
0x00012484  mov      x0, x22
0x00012488  bl       #0x2480c   ; call _objc_release
0x0001248c  b        #0x125a8   ; call sub_125a8
0x00012490  b        #0x12544   ; call sub_12544
0x00012494  mov      x23, x0
0x00012498  ldr      x0, [sp, #8]
0x0001249c  bl       #0x2480c   ; call _objc_release
0x000124a0  b        #0x125a8   ; call sub_125a8
0x000124a4  mov      x23, x0
0x000124a8  tbz      w20, #0, #0x124c0
0x000124ac  mov      x0, x22
0x000124b0  bl       #0x2480c   ; call _objc_release
0x000124b4  ldr      x0, [sp, #8]
0x000124b8  bl       #0x2480c   ; call _objc_release
0x000124bc  b        #0x125a8   ; call sub_125a8
0x000124c0  mov      x0, x22
0x000124c4  bl       #0x2480c   ; call _objc_release
0x000124c8  ldr      x0, [sp, #8]
0x000124cc  bl       #0x2480c   ; call _objc_release
0x000124d0  b        #0x125a8   ; call sub_125a8
0x000124d4  mov      x23, x0
0x000124d8  mov      x0, x21
0x000124dc  bl       #0x2480c   ; call _objc_release
0x000124e0  b        #0x124e8   ; call sub_124e8
0x000124e4  mov      x23, x0
0x000124e8  mov      x0, x24
0x000124ec  bl       #0x2480c   ; call _objc_release
