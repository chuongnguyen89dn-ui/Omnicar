; ==== sub_1e178 @ 0x1e178..0x1e1c4 (76 bytes) ====
0x0001e178  add      x1, x1, #0x630
0x0001e17c  bl       #0x24614   ; call _fopen
0x0001e180  mov      x20, x0
0x0001e184  cbz      x0, #0x1e1a4
0x0001e188  mov      x0, x19
0x0001e18c  bl       #0x24824   ; call _objc_retainAutorelease
0x0001e190  bl       #0x24a40   ; objc_msgSend: UTF8String
0x0001e194  mov      x1, x20
0x0001e198  bl       #0x24620   ; call _fputs
0x0001e19c  mov      x0, x20
0x0001e1a0  bl       #0x24608   ; call _fclose
0x0001e1a4  cmp      x20, #0
0x0001e1a8  cset     w20, ne
0x0001e1ac  mov      x0, x19
0x0001e1b0  bl       #0x2480c   ; call _objc_release
0x0001e1b4  mov      x0, x20
0x0001e1b8  ldp      x29, x30, [sp, #0x10]
0x0001e1bc  ldp      x20, x19, [sp], #0x20
0x0001e1c0  ret      
