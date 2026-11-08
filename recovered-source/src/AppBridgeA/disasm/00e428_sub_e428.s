; ==== sub_e428 @ 0xe428..0xe4c4 (156 bytes) ====
0x0000e428  mov      x0, x21
0x0000e42c  blr      x8   ; indirect call
0x0000e430  b        #0xe44c   ; call sub_e44c
0x0000e434  adrp     x1, #0x35000
0x0000e438  add      x1, x1, #0xf10   ; -> @"_executeBlockAfterLaunchCompletes:"
0x0000e43c  mov      x0, x20
0x0000e440  bl       #0x9698   ; call _ABMissingSelector
0x0000e444  mov      x0, x20
0x0000e448  bl       #0x2480c   ; call _objc_release
0x0000e44c  mov      x0, x21
0x0000e450  bl       #0x2480c   ; call _objc_release
0x0000e454  add      x0, x23, #0x28
0x0000e458  bl       #0x24758   ; call _objc_destroyWeak
0x0000e45c  add      x0, x23, #0x20
0x0000e460  bl       #0x24758   ; call _objc_destroyWeak
0x0000e464  mov      x0, x20
0x0000e468  bl       #0x2480c   ; call _objc_release
0x0000e46c  mov      x0, x19
0x0000e470  bl       #0x2480c   ; call _objc_release
0x0000e474  ldp      x29, x30, [sp, #0x70]
0x0000e478  ldp      x20, x19, [sp, #0x60]
0x0000e47c  ldp      x22, x21, [sp, #0x50]
0x0000e480  ldp      x24, x23, [sp, #0x40]
0x0000e484  add      sp, sp, #0x80
0x0000e488  ret      
0x0000e48c  mov      x1, x22
0x0000e490  mov      x22, x0
0x0000e494  mov      x0, x1
0x0000e498  b        #0xe4bc   ; call sub_e4bc
0x0000e49c  b        #0xe4a8   ; call sub_e4a8
0x0000e4a0  mov      x22, x0
0x0000e4a4  b        #0xe4c0   ; call sub_e4c0
0x0000e4a8  mov      x22, x0
0x0000e4ac  mov      x0, x19
0x0000e4b0  b        #0xe4dc   ; call sub_e4dc
0x0000e4b4  mov      x22, x0
0x0000e4b8  mov      x0, x20
0x0000e4bc  bl       #0x2480c   ; call _objc_release
0x0000e4c0  mov      x0, x21
