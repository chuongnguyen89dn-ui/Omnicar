; ==== sub_24138 @ 0x24138..0x24184 (76 bytes) ====
0x00024138  adrp     x8, #0x2b000
0x0002413c  ldr      d1, [x8, #0x4a8]
0x00024140  fadd     d0, d0, d1
0x00024144  adrp     x8, #0x3e000
0x00024148  str      d0, [x8, #0xc68]
0x0002414c  mov      x0, x20
0x00024150  bl       #0x2480c   ; call _objc_release
0x00024154  mov      x0, x19
0x00024158  ldp      x29, x30, [sp, #0x10]
0x0002415c  ldp      x20, x19, [sp], #0x20
0x00024160  b        #0x2480c   ; call _objc_release
0x00024164  ldp      x29, x30, [sp, #0x10]
0x00024168  ldp      x20, x19, [sp], #0x20
0x0002416c  ret      
0x00024170  stp      x29, x30, [sp, #-0x10]!
0x00024174  mov      x29, sp
0x00024178  adrp     x8, #0x3e000
0x0002417c  ldr      x0, [x8, #0x398]   ; -> [class(NSMutableDictionary)]
0x00024180  bl       #0x25580   ; objc_msgSend: dictionary
