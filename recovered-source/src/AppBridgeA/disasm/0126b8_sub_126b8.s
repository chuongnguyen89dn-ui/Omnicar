; ==== sub_126b8 @ 0x126b8..0x12910 (600 bytes) ====
0x000126b8  adrp     x9, #0x34000
0x000126bc  add      x9, x9, #0x990
0x000126c0  stp      x8, x9, [sp, #0x68]
0x000126c4  mov      x0, x20
0x000126c8  bl       #0x24818   ; call _objc_retain
0x000126cc  str      x20, [sp, #0x78]
0x000126d0  ldp      q0, q1, [x29, #-0x70]
0x000126d4  stur     q0, [x22, #0x28]
0x000126d8  stur     q1, [x22, #0x38]
0x000126dc  ldur     q0, [x29, #-0x50]
0x000126e0  stur     q0, [x22, #0x48]
0x000126e4  str      x23, [sp]
0x000126e8  str      d8, [sp, #8]
0x000126ec  adrp     x8, #0x12000
0x000126f0  add      x8, x8, #0x844
0x000126f4  adrp     x9, #0x34000
0x000126f8  add      x9, x9, #0x9c0
0x000126fc  stp      x8, x9, [sp, #0x10]
0x00012700  mov      x0, x20
0x00012704  bl       #0x24818   ; call _objc_retain
0x00012708  str      x20, [sp, #0x20]
0x0001270c  ldp      q0, q1, [x29, #-0x70]
0x00012710  stur     q0, [sp, #0x28]
0x00012714  stur     q1, [sp, #0x38]
0x00012718  ldur     q0, [x29, #-0x50]
0x0001271c  stur     q0, [sp, #0x48]
0x00012720  adrp     x8, #0x2b000
0x00012724  ldr      d0, [x8, #0x2b8]
0x00012728  fmov     d1, xzr
0x0001272c  add      x3, sp, #0x58
0x00012730  mov      x4, sp
0x00012734  mov      x0, x21
0x00012738  mov      w2, #0x10000
0x0001273c  bl       #0x24c80   ; objc_msgSend: animateWithDuration:delay:options:animations:completion:
0x00012740  ldr      x0, [sp, #0x20]
0x00012744  bl       #0x2480c   ; call _objc_release
0x00012748  ldr      x0, [sp, #0x78]
0x0001274c  bl       #0x2480c   ; call _objc_release
0x00012750  mov      x0, x20
0x00012754  bl       #0x2480c   ; call _objc_release
0x00012758  mov      x0, x19
0x0001275c  bl       #0x2480c   ; call _objc_release
0x00012760  ldp      x29, x30, [sp, #0x120]
0x00012764  ldp      x20, x19, [sp, #0x110]
0x00012768  ldp      x22, x21, [sp, #0x100]
0x0001276c  ldp      x24, x23, [sp, #0xf0]
0x00012770  ldp      d9, d8, [sp, #0xe0]
0x00012774  add      sp, sp, #0x130
0x00012778  ret      
0x0001277c  mov      x21, x0
0x00012780  ldr      x0, [sp, #0x20]
0x00012784  bl       #0x2480c   ; call _objc_release
0x00012788  ldr      x0, [sp, #0x78]
0x0001278c  b        #0x127a0   ; call sub_127a0
0x00012790  b        #0x127a8   ; call sub_127a8
0x00012794  mov      x1, x21
0x00012798  mov      x21, x0
0x0001279c  mov      x0, x1
0x000127a0  bl       #0x2480c   ; call _objc_release
0x000127a4  b        #0x127ac   ; call sub_127ac
0x000127a8  mov      x21, x0
0x000127ac  mov      x0, x20
0x000127b0  bl       #0x2480c   ; call _objc_release
0x000127b4  b        #0x127bc   ; call sub_127bc
0x000127b8  mov      x21, x0
0x000127bc  mov      x0, x19
0x000127c0  bl       #0x2480c   ; call _objc_release
0x000127c4  mov      x0, x21
0x000127c8  bl       #0x24470   ; call __Unwind_Resume
0x000127cc  sub      sp, sp, #0x80
0x000127d0  stp      x20, x19, [sp, #0x60]
0x000127d4  stp      x29, x30, [sp, #0x70]
0x000127d8  add      x29, sp, #0x70
0x000127dc  mov      x19, x0
0x000127e0  ldr      x0, [x0, #0x20]
0x000127e4  fmov     d0, xzr
0x000127e8  bl       #0x26b40   ; objc_msgSend: setAlpha:
0x000127ec  ldur     q0, [x19, #0x28]
0x000127f0  ldur     q1, [x19, #0x38]
0x000127f4  stp      q0, q1, [sp, #0x30]
0x000127f8  ldur     q0, [x19, #0x48]
0x000127fc  str      q0, [sp, #0x50]
0x00012800  adrp     x8, #0x2b000
0x00012804  ldr      d0, [x8, #0x2c0]
0x00012808  mov      x8, sp
0x0001280c  add      x0, sp, #0x30
0x00012810  mov      v1.16b, v0.16b
0x00012814  bl       #0x242fc   ; call _CGAffineTransformScale
0x00012818  ldp      q0, q1, [sp]
0x0001281c  stp      q0, q1, [sp, #0x30]
0x00012820  ldr      q0, [sp, #0x20]
0x00012824  str      q0, [sp, #0x50]
0x00012828  ldr      x0, [x19, #0x20]
0x0001282c  add      x2, sp, #0x30
0x00012830  bl       #0x279a0   ; objc_msgSend: setTransform:
0x00012834  ldp      x29, x30, [sp, #0x70]
0x00012838  ldp      x20, x19, [sp, #0x60]
0x0001283c  add      sp, sp, #0x80
0x00012840  ret      
0x00012844  sub      sp, sp, #0x50
0x00012848  stp      x20, x19, [sp, #0x30]
0x0001284c  stp      x29, x30, [sp, #0x40]
0x00012850  add      x29, sp, #0x40
0x00012854  mov      x19, x0
0x00012858  ldr      x0, [x0, #0x20]
0x0001285c  bl       #0x24c20   ; objc_msgSend: alpha
0x00012860  fcmp     d0, #0.0
0x00012864  b.ne     #0x12894
0x00012868  ldr      x0, [x19, #0x20]
0x0001286c  mov      w2, #1
0x00012870  bl       #0x270a0   ; objc_msgSend: setHidden:
0x00012874  ldur     q0, [x19, #0x28]
0x00012878  ldur     q1, [x19, #0x38]
0x0001287c  stp      q0, q1, [sp]
0x00012880  ldur     q0, [x19, #0x48]
0x00012884  str      q0, [sp, #0x20]
0x00012888  ldr      x0, [x19, #0x20]
0x0001288c  mov      x2, sp
0x00012890  bl       #0x279a0   ; objc_msgSend: setTransform:
0x00012894  ldp      x29, x30, [sp, #0x40]
0x00012898  ldp      x20, x19, [sp, #0x30]
0x0001289c  add      sp, sp, #0x50
0x000128a0  ret      
0x000128a4  sub      sp, sp, #0x120
0x000128a8  stp      x28, x27, [sp, #0xd0]
0x000128ac  stp      x24, x23, [sp, #0xe0]
0x000128b0  stp      x22, x21, [sp, #0xf0]
0x000128b4  stp      x20, x19, [sp, #0x100]
0x000128b8  stp      x29, x30, [sp, #0x110]
0x000128bc  add      x29, sp, #0x110
0x000128c0  mov      x20, x2
0x000128c4  mov      x21, x0
0x000128c8  adrp     x8, #0x34000
0x000128cc  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x000128d0  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x000128d4  stur     x8, [x29, #-0x48]
0x000128d8  bl       #0x277e0   ; objc_msgSend: setShieldOn:
0x000128dc  movi     v0.16b, #0
0x000128e0  stp      q0, q0, [sp, #0x20]
0x000128e4  stp      q0, q0, [sp]
0x000128e8  mov      x0, x21
0x000128ec  bl       #0x26580   ; objc_msgSend: panes
0x000128f0  mov      x29, x29
0x000128f4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000128f8  mov      x19, x0
0x000128fc  mov      x2, sp
0x00012900  add      x3, sp, #0x48
0x00012904  mov      w4, #0x10
0x00012908  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001290c  mov      x22, x0
