; ==== sub_192d4 @ 0x192d4..0x195b0 (732 bytes) ====
0x000192d4  mov      x0, x20
0x000192d8  bl       #0x2480c   ; call _objc_release
0x000192dc  mov      x0, x19
0x000192e0  bl       #0x2480c   ; call _objc_release
0x000192e4  mov      x0, x21
0x000192e8  bl       #0x24470   ; call __Unwind_Resume
0x000192ec  sub      sp, sp, #0x50
0x000192f0  stp      x20, x19, [sp, #0x30]
0x000192f4  stp      x29, x30, [sp, #0x40]
0x000192f8  add      x29, sp, #0x40
0x000192fc  adrp     x8, #0x34000
0x00019300  ldr      x8, [x8, #0x4b0]   ; -> [got:_CGAffineTransformIdentity]
0x00019304  ldp      q0, q1, [x8]
0x00019308  stp      q0, q1, [sp]
0x0001930c  ldr      q0, [x8, #0x20]   ; -> [got:_class_getClassMethod]
0x00019310  str      q0, [sp, #0x20]
0x00019314  ldr      x0, [x0, #0x20]
0x00019318  bl       #0x26560   ; objc_msgSend: panel
0x0001931c  mov      x29, x29
0x00019320  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019324  mov      x19, x0
0x00019328  mov      x2, sp
0x0001932c  bl       #0x279a0   ; objc_msgSend: setTransform:
0x00019330  mov      x0, x19
0x00019334  bl       #0x2480c   ; call _objc_release
0x00019338  ldp      x29, x30, [sp, #0x40]
0x0001933c  ldp      x20, x19, [sp, #0x30]
0x00019340  add      sp, sp, #0x50
0x00019344  ret      
0x00019348  mov      x20, x0
0x0001934c  mov      x0, x19
0x00019350  bl       #0x2480c   ; call _objc_release
0x00019354  mov      x0, x20
0x00019358  bl       #0x24470   ; call __Unwind_Resume
0x0001935c  sub      sp, sp, #0xb0
0x00019360  stp      d9, d8, [sp, #0x60]
0x00019364  stp      x24, x23, [sp, #0x70]
0x00019368  stp      x22, x21, [sp, #0x80]
0x0001936c  stp      x20, x19, [sp, #0x90]
0x00019370  stp      x29, x30, [sp, #0xa0]
0x00019374  add      x29, sp, #0xa0
0x00019378  mov      x19, x2
0x0001937c  mov      x20, x0
0x00019380  mov      x0, x2
0x00019384  bl       #0x24818   ; call _objc_retain
0x00019388  mov      x0, x20
0x0001938c  bl       #0x24ce0   ; objc_msgSend: app
0x00019390  mov      x29, x29
0x00019394  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019398  mov      x21, x0
0x0001939c  cbz      x0, #0x1956c
0x000193a0  cbz      x19, #0x193e0
0x000193a4  mov      x0, x20
0x000193a8  bl       #0x24ce0   ; objc_msgSend: app
0x000193ac  mov      x29, x29
0x000193b0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000193b4  mov      x22, x0
0x000193b8  mov      x0, x19
0x000193bc  mov      x2, x22
0x000193c0  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x000193c4  mov      x23, x0
0x000193c8  mov      x0, x22
0x000193cc  bl       #0x2480c   ; call _objc_release
0x000193d0  mov      x0, x21
0x000193d4  bl       #0x2480c   ; call _objc_release
0x000193d8  tbnz     w23, #0, #0x193e8
0x000193dc  b        #0x1956c   ; call sub_1956c
0x000193e0  mov      x0, x21
0x000193e4  bl       #0x2480c   ; call _objc_release
0x000193e8  adrp     x8, #0x3e000
0x000193ec  ldr      x22, [x8, #0x290]   ; -> [class(NSString)]
0x000193f0  mov      x0, x20
0x000193f4  bl       #0x24ce0   ; objc_msgSend: app
0x000193f8  mov      x29, x29
0x000193fc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019400  mov      x21, x0
0x00019404  str      x0, [sp]
0x00019408  adrp     x2, #0x36000
0x0001940c  add      x2, x2, #0xcb0   ; -> @"ban phim xe: an (%@)"
0x00019410  mov      x0, x22
0x00019414  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00019418  mov      x29, x29
0x0001941c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019420  mov      x22, x0
0x00019424  adrp     x0, #0x34000
0x00019428  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0001942c  mov      x1, x22
0x00019430  bl       #0x1dd30   ; call _OMCLogWrite
0x00019434  mov      x0, x22
0x00019438  bl       #0x2480c   ; call _objc_release
0x0001943c  mov      x0, x21
0x00019440  bl       #0x2480c   ; call _objc_release
0x00019444  mov      x0, x20
0x00019448  mov      x2, #0
0x0001944c  bl       #0x26b80   ; objc_msgSend: setApp:
0x00019450  mov      x0, x20
0x00019454  bl       #0x26560   ; objc_msgSend: panel
0x00019458  mov      x29, x29
0x0001945c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00019460  mov      x21, x0
0x00019464  mov      x0, x20
0x00019468  mov      x2, #0
0x0001946c  mov      w3, #0
0x00019470  bl       #0x25da0   ; objc_msgSend: key:pressed:
0x00019474  adrp     x8, #0x3e000
0x00019478  ldr      x0, [x8, #0x3c8]   ; -> [class(UIViewPropertyAnimator)]
0x0001947c  bl       #0x2471c   ; call _objc_alloc
0x00019480  mov      x22, x0
0x00019484  adrp     x8, #0x3e000
0x00019488  ldr      x0, [x8, #0x3d0]   ; -> [class(UICubicTimingParameters)]
0x0001948c  bl       #0x2471c   ; call _objc_alloc
0x00019490  adrp     x8, #0x2b000
0x00019494  ldr      d0, [x8, #0x1d8]
0x00019498  fmov     d1, xzr
0x0001949c  fmov     d3, #1.00000000
0x000194a0  mov      v2.16b, v0.16b
0x000194a4  bl       #0x259e0   ; objc_msgSend: initWithControlPoint1:controlPoint2:
0x000194a8  mov      x23, x0
0x000194ac  fmov     d0, #0.25000000
0x000194b0  mov      x0, x22
0x000194b4  mov      x2, x23
0x000194b8  bl       #0x25a00   ; objc_msgSend: initWithDuration:timingParameters:
0x000194bc  mov      x22, x0
0x000194c0  mov      x0, x23
0x000194c4  bl       #0x2480c   ; call _objc_release
0x000194c8  adrp     x23, #0x34000
0x000194cc  ldr      x23, [x23, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x000194d0  str      x23, [sp, #0x38]
0x000194d4  adrp     x8, #0x2b000
0x000194d8  ldr      d8, [x8, #0x1d0]
0x000194dc  str      d8, [sp, #0x40]
0x000194e0  adrp     x8, #0x19000
0x000194e4  add      x8, x8, #0x608
0x000194e8  adrp     x9, #0x34000
0x000194ec  add      x9, x9, #0x890
0x000194f0  stp      x8, x9, [sp, #0x48]
0x000194f4  mov      x0, x21
0x000194f8  bl       #0x24818   ; call _objc_retain
0x000194fc  str      x21, [sp, #0x58]
0x00019500  add      x2, sp, #0x38
0x00019504  mov      x0, x22
0x00019508  bl       #0x24a80   ; objc_msgSend: addAnimations:
0x0001950c  str      x23, [sp, #8]
0x00019510  adrp     x8, #0x19000
0x00019514  add      x8, x8, #0x664
0x00019518  str      d8, [sp, #0x10]
0x0001951c  adrp     x9, #0x34000
0x00019520  add      x9, x9, #0xb10
0x00019524  stp      x8, x9, [sp, #0x18]
0x00019528  str      x20, [sp, #0x28]
0x0001952c  mov      x0, x21
0x00019530  bl       #0x24818   ; call _objc_retain
0x00019534  str      x21, [sp, #0x30]
0x00019538  add      x2, sp, #8
0x0001953c  mov      x0, x22
0x00019540  bl       #0x24ac0   ; objc_msgSend: addCompletion:
0x00019544  mov      x0, x22
0x00019548  bl       #0x27c00   ; objc_msgSend: startAnimation
0x0001954c  ldr      x0, [sp, #0x30]
0x00019550  bl       #0x2480c   ; call _objc_release
0x00019554  ldr      x0, [sp, #0x58]
0x00019558  bl       #0x2480c   ; call _objc_release
0x0001955c  mov      x0, x22
0x00019560  bl       #0x2480c   ; call _objc_release
0x00019564  mov      x0, x21
0x00019568  bl       #0x2480c   ; call _objc_release
0x0001956c  mov      x0, x19
0x00019570  bl       #0x2480c   ; call _objc_release
0x00019574  ldp      x29, x30, [sp, #0xa0]
0x00019578  ldp      x20, x19, [sp, #0x90]
0x0001957c  ldp      x22, x21, [sp, #0x80]
0x00019580  ldp      x24, x23, [sp, #0x70]
0x00019584  ldp      d9, d8, [sp, #0x60]
0x00019588  add      sp, sp, #0xb0
0x0001958c  ret      
0x00019590  b        #0x195d0   ; call sub_195d0
0x00019594  b        #0x195e4   ; call sub_195e4
0x00019598  b        #0x1959c   ; call sub_1959c
0x0001959c  mov      x20, x0
0x000195a0  ldr      x0, [sp, #0x30]
0x000195a4  bl       #0x2480c   ; call _objc_release
0x000195a8  b        #0x195b0   ; call sub_195b0
0x000195ac  mov      x20, x0
