; ==== sub_1257c @ 0x1257c..0x126b8 (316 bytes) ====
0x0001257c  bl       #0x2480c   ; call _objc_release
0x00012580  b        #0x12548   ; call sub_12548
0x00012584  mov      x23, x0
0x00012588  mov      x0, x26
0x0001258c  bl       #0x2480c   ; call _objc_release
0x00012590  b        #0x12598   ; call sub_12598
0x00012594  mov      x23, x0
0x00012598  mov      x0, x22
0x0001259c  bl       #0x2480c   ; call _objc_release
0x000125a0  ldr      x0, [sp, #8]
0x000125a4  bl       #0x2480c   ; call _objc_release
0x000125a8  ldr      x0, [sp]
0x000125ac  bl       #0x2480c   ; call _objc_release
0x000125b0  b        #0x125b8   ; call sub_125b8
0x000125b4  mov      x23, x0
0x000125b8  mov      x0, x23
0x000125bc  bl       #0x24470   ; call __Unwind_Resume
0x000125c0  sub      sp, sp, #0x50
0x000125c4  stp      x20, x19, [sp, #0x30]
0x000125c8  stp      x29, x30, [sp, #0x40]
0x000125cc  add      x29, sp, #0x40
0x000125d0  mov      x19, x0
0x000125d4  ldr      x0, [x0, #0x20]
0x000125d8  fmov     d0, #1.00000000
0x000125dc  bl       #0x26b40   ; objc_msgSend: setAlpha:
0x000125e0  ldur     q0, [x19, #0x28]
0x000125e4  ldur     q1, [x19, #0x38]
0x000125e8  stp      q0, q1, [sp]
0x000125ec  ldur     q0, [x19, #0x48]
0x000125f0  str      q0, [sp, #0x20]
0x000125f4  ldr      x0, [x19, #0x20]
0x000125f8  mov      x2, sp
0x000125fc  bl       #0x279a0   ; objc_msgSend: setTransform:
0x00012600  ldp      x29, x30, [sp, #0x40]
0x00012604  ldp      x20, x19, [sp, #0x30]
0x00012608  add      sp, sp, #0x50
0x0001260c  ret      
0x00012610  sub      sp, sp, #0x130
0x00012614  stp      d9, d8, [sp, #0xe0]
0x00012618  stp      x24, x23, [sp, #0xf0]
0x0001261c  stp      x22, x21, [sp, #0x100]
0x00012620  stp      x20, x19, [sp, #0x110]
0x00012624  stp      x29, x30, [sp, #0x120]
0x00012628  add      x29, sp, #0x120
0x0001262c  mov      x19, x2
0x00012630  mov      x0, x2
0x00012634  bl       #0x24818   ; call _objc_retain
0x00012638  mov      x0, x19
0x0001263c  bl       #0x24e60   ; objc_msgSend: bar
0x00012640  mov      x29, x29
0x00012644  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012648  mov      x20, x0
0x0001264c  cbz      x0, #0x12750
0x00012650  mov      x0, x20
0x00012654  bl       #0x25d00   ; objc_msgSend: isHidden
0x00012658  tbnz     w0, #0, #0x12750
0x0001265c  mov      x0, x19
0x00012660  bl       #0x25840   ; objc_msgSend: handle
0x00012664  mov      x29, x29
0x00012668  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001266c  mov      x21, x0
0x00012670  mov      w1, #0
0x00012674  bl       #0x11f58   ; call sub_11f58
0x00012678  mov      x0, x21
0x0001267c  bl       #0x2480c   ; call _objc_release
0x00012680  sub      x8, x29, #0x70
0x00012684  mov      x0, x20
0x00012688  bl       #0x27fe0   ; objc_msgSend: transform
0x0001268c  add      x22, sp, #0x58
0x00012690  adrp     x8, #0x3e000
0x00012694  ldr      x21, [x8, #0x2d0]   ; -> [class(UIView)]
0x00012698  adrp     x23, #0x34000
0x0001269c  ldr      x23, [x23, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x000126a0  str      x23, [sp, #0x58]
0x000126a4  adrp     x8, #0x2b000
0x000126a8  ldr      d8, [x8, #0x1d0]
0x000126ac  str      d8, [sp, #0x60]
0x000126b0  adrp     x8, #0x12000
0x000126b4  add      x8, x8, #0x7cc
