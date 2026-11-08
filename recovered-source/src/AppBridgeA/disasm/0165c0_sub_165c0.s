; ==== sub_165c0 @ 0x165c0..0x16610 (80 bytes) ====
0x000165c0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000165c4  mov      x20, x0
0x000165c8  bl       #0x26800   ; objc_msgSend: removeAllObjects
0x000165cc  mov      x0, x20
0x000165d0  bl       #0x2480c   ; call _objc_release
0x000165d4  mov      x0, x19
0x000165d8  bl       #0x281e0   ; objc_msgSend: window
0x000165dc  mov      x29, x29
0x000165e0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000165e4  mov      x20, x0
0x000165e8  mov      w2, #1
0x000165ec  bl       #0x270a0   ; objc_msgSend: setHidden:
0x000165f0  mov      x0, x20
0x000165f4  bl       #0x2480c   ; call _objc_release
0x000165f8  mov      x0, x19
0x000165fc  mov      x2, #0
0x00016600  bl       #0x27a80   ; objc_msgSend: setWindow:
0x00016604  ldur     x8, [x29, #-0x38]
0x00016608  adrp     x9, #0x34000
0x0001660c  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
