; ==== sub_14438 @ 0x14438..0x145b8 (384 bytes) ====
0x00014438  ldr      x8, [sp, #0x118]
0x0001443c  ldr      x20, [x8, x24, lsl #3]
0x00014440  mov      x0, x20
0x00014444  bl       #0x26200   ; objc_msgSend: name
0x00014448  mov      x29, x29
0x0001444c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014450  mov      x19, x0
0x00014454  adrp     x2, #0x36000
0x00014458  add      x2, x2, #0xad0   ; -> @"omcDot"
0x0001445c  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00014460  mov      x27, x0
0x00014464  mov      x0, x19
0x00014468  bl       #0x2480c   ; call _objc_release
0x0001446c  tbz      w27, #0, #0x14480
0x00014470  mov      x19, x28
0x00014474  mov      x25, x23
0x00014478  mov      x28, x20
0x0001447c  b        #0x144b8   ; call sub_144b8
0x00014480  mov      x0, x20
0x00014484  bl       #0x26200   ; objc_msgSend: name
0x00014488  mov      x29, x29
0x0001448c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014490  mov      x19, x0
0x00014494  adrp     x2, #0x36000
0x00014498  add      x2, x2, #0xab0   ; -> @"omcAccent"
0x0001449c  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x000144a0  mov      x27, x0
0x000144a4  mov      x0, x19
0x000144a8  bl       #0x2480c   ; call _objc_release
0x000144ac  mov      x19, x23
0x000144b0  mov      x25, x20
0x000144b4  tbz      w27, #0, #0x144cc
0x000144b8  mov      x0, x20
0x000144bc  bl       #0x24818   ; call _objc_retain
0x000144c0  mov      x0, x19
0x000144c4  bl       #0x2480c   ; call _objc_release
0x000144c8  mov      x23, x25
0x000144cc  add      x24, x24, #1
0x000144d0  cmp      x22, x24
0x000144d4  b.ne     #0x14420
0x000144d8  add      x2, sp, #0x110
0x000144dc  add      x3, sp, #0x160
0x000144e0  mov      x0, x21
0x000144e4  mov      w4, #0x10
0x000144e8  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x000144ec  mov      x22, x0
0x000144f0  cbnz     x0, #0x1441c
0x000144f4  mov      x0, x21
0x000144f8  bl       #0x2480c   ; call _objc_release
0x000144fc  cmp      x23, #0
0x00014500  ldr      w22, [sp, #0x6c]
0x00014504  csel     w8, wzr, w22, ne
0x00014508  cmp      w8, #1
0x0001450c  b.ne     #0x146dc
0x00014510  adrp     x8, #0x3e000
0x00014514  ldr      x0, [x8, #0x3a8]   ; -> [class(CAGradientLayer)]
0x00014518  mov      x20, #0
0x0001451c  mov      x22, x28
0x00014520  bl       #0x25f00   ; objc_msgSend: layer
0x00014524  mov      x29, x29
0x00014528  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001452c  mov      x23, x0
0x00014530  mov      x22, x28
0x00014534  mov      x20, x0
0x00014538  adrp     x2, #0x36000
0x0001453c  add      x2, x2, #0xab0   ; -> @"omcAccent"
0x00014540  bl       #0x273c0   ; objc_msgSend: setName:
0x00014544  adrp     x8, #0x3e000
0x00014548  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x0001454c  fmov     d3, #1.00000000
0x00014550  mov      x22, x28
0x00014554  mov      x20, x23
0x00014558  ldp      d1, d0, [sp, #0x20]
0x0001455c  ldr      d2, [sp, #0x18]
0x00014560  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x00014564  mov      x29, x29
0x00014568  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001456c  mov      x21, x0
0x00014570  bl       #0x24824   ; call _objc_retainAutorelease
0x00014574  mov      x0, x21
0x00014578  bl       #0x249e0   ; objc_msgSend: CGColor
0x0001457c  str      x0, [sp, #0x150]
0x00014580  adrp     x8, #0x3e000
0x00014584  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x00014588  fmov     d3, #1.00000000
0x0001458c  ldp      d1, d0, [sp, #8]
0x00014590  ldr      d2, [sp]
0x00014594  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x00014598  mov      x29, x29
0x0001459c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000145a0  mov      x20, x0
0x000145a4  bl       #0x24824   ; call _objc_retainAutorelease
0x000145a8  mov      x0, x20
0x000145ac  bl       #0x249e0   ; objc_msgSend: CGColor
0x000145b0  str      x0, [sp, #0x158]
0x000145b4  adrp     x8, #0x3e000
