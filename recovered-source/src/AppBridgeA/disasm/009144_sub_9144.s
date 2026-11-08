; ==== sub_9144 @ 0x9144..0x9220 (220 bytes) ====
0x00009144  sub      sp, sp, #0x50
0x00009148  stp      x24, x23, [sp, #0x10]
0x0000914c  stp      x22, x21, [sp, #0x20]
0x00009150  stp      x20, x19, [sp, #0x30]
0x00009154  stp      x29, x30, [sp, #0x40]
0x00009158  add      x29, sp, #0x40
0x0000915c  mov      x19, x1
0x00009160  mov      x0, x1
0x00009164  bl       #0x24818   ; call _objc_retain
0x00009168  adrp     x8, #0x3e000
0x0000916c  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x00009170  bl       #0x27b20   ; objc_msgSend: shared
0x00009174  mov      x29, x29
0x00009178  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000917c  mov      x20, x0
0x00009180  mov      x0, x19
0x00009184  bl       #0x280c0   ; objc_msgSend: userInfo
0x00009188  mov      x29, x29
0x0000918c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009190  mov      x22, x0
0x00009194  adrp     x2, #0x35000
0x00009198  add      x2, x2, #0x830   ; -> @"knobs"
0x0000919c  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000091a0  mov      x29, x29
0x000091a4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000091a8  mov      x21, x0
0x000091ac  mov      x0, x20
0x000091b0  mov      x2, x21
0x000091b4  bl       #0x27200   ; objc_msgSend: setKnobs:
0x000091b8  mov      x0, x21
0x000091bc  bl       #0x2480c   ; call _objc_release
0x000091c0  mov      x0, x22
0x000091c4  bl       #0x2480c   ; call _objc_release
0x000091c8  mov      x0, x20
0x000091cc  bl       #0x2480c   ; call _objc_release
0x000091d0  mov      x0, x19
0x000091d4  ldp      x29, x30, [sp, #0x40]
0x000091d8  ldp      x20, x19, [sp, #0x30]
0x000091dc  ldp      x22, x21, [sp, #0x20]
0x000091e0  ldp      x24, x23, [sp, #0x10]
0x000091e4  add      sp, sp, #0x50
0x000091e8  b        #0x2480c   ; call _objc_release
0x000091ec  mov      x23, x1
0x000091f0  mov      x1, x21
0x000091f4  mov      x21, x0
0x000091f8  mov      x0, x1
0x000091fc  bl       #0x2480c   ; call _objc_release
0x00009200  b        #0x920c   ; call sub_920c
0x00009204  mov      x23, x1
0x00009208  mov      x21, x0
0x0000920c  mov      x0, x22
0x00009210  bl       #0x2480c   ; call _objc_release
0x00009214  b        #0x9220   ; call sub_9220
0x00009218  mov      x23, x1
0x0000921c  mov      x21, x0
