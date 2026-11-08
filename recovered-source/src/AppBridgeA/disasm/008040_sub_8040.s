; ==== sub_8040 @ 0x8040..0x8080 (64 bytes) ====
0x00008040  mov      x21, x0
0x00008044  mov      x0, x19
0x00008048  bl       #0x2480c   ; call _objc_release
0x0000804c  b        #0x80cc   ; call sub_80cc
0x00008050  mov      x22, x1
0x00008054  mov      x21, x0
0x00008058  b        #0x8110   ; call sub_8110
0x0000805c  mov      x22, x1
0x00008060  mov      x21, x0
0x00008064  mov      x0, x28
0x00008068  bl       #0x2480c   ; call _objc_release
0x0000806c  b        #0x8120   ; call sub_8120
0x00008070  b        #0x8078   ; call sub_8078
0x00008074  b        #0x8154   ; call sub_8154
0x00008078  mov      x22, x1
0x0000807c  mov      x21, x0
