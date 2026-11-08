; ==== sub_80c0 @ 0x80c0..0x8118 (88 bytes) ====
0x000080c0  b        #0x8154   ; call sub_8154
0x000080c4  mov      x22, x1
0x000080c8  mov      x21, x0
0x000080cc  mov      x0, x27
0x000080d0  bl       #0x2480c   ; call _objc_release
0x000080d4  b        #0x80e0   ; call sub_80e0
0x000080d8  mov      x22, x1
0x000080dc  mov      x21, x0
0x000080e0  mov      x0, x26
0x000080e4  bl       #0x2480c   ; call _objc_release
0x000080e8  b        #0x80f4   ; call sub_80f4
0x000080ec  mov      x22, x1
0x000080f0  mov      x21, x0
0x000080f4  mov      x0, x25
0x000080f8  bl       #0x2480c   ; call _objc_release
0x000080fc  b        #0x8108   ; call sub_8108
0x00008100  mov      x22, x1
0x00008104  mov      x21, x0
0x00008108  ldr      x0, [sp, #0x18]
0x0000810c  bl       #0x2480c   ; call _objc_release
0x00008110  ldr      x0, [sp, #0x20]
0x00008114  b        #0x8168   ; call sub_8168
