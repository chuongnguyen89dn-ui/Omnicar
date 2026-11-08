; ==== sub_124f0 @ 0x124f0..0x1257c (140 bytes) ====
0x000124f0  mov      x0, x22
0x000124f4  bl       #0x2480c   ; call _objc_release
0x000124f8  b        #0x125a8   ; call sub_125a8
0x000124fc  mov      x23, x0
0x00012500  str      xzr, [sp, #8]
0x00012504  b        #0x12598   ; call sub_12598
0x00012508  mov      x23, x0
0x0001250c  mov      x0, x21
0x00012510  bl       #0x2480c   ; call _objc_release
0x00012514  b        #0x125a8   ; call sub_125a8
0x00012518  mov      x23, x0
0x0001251c  b        #0x125a8   ; call sub_125a8
0x00012520  mov      x23, x0
0x00012524  mov      x0, x21
0x00012528  bl       #0x2480c   ; call _objc_release
0x0001252c  b        #0x125a8   ; call sub_125a8
0x00012530  b        #0x12544   ; call sub_12544
0x00012534  b        #0x12594   ; call sub_12594
0x00012538  mov      x23, x0
0x0001253c  b        #0x12578   ; call sub_12578
0x00012540  b        #0x12544   ; call sub_12544
0x00012544  mov      x23, x0
0x00012548  mov      x0, x22
0x0001254c  bl       #0x2480c   ; call _objc_release
0x00012550  ldr      x0, [sp, #8]
0x00012554  bl       #0x2480c   ; call _objc_release
0x00012558  b        #0x125a8   ; call sub_125a8
0x0001255c  mov      x23, x0
0x00012560  tbz      w20, #0, #0x12570
0x00012564  mov      x0, x25
0x00012568  bl       #0x2480c   ; call _objc_release
0x0001256c  b        #0x12548   ; call sub_12548
0x00012570  mov      x0, x26
0x00012574  bl       #0x2480c   ; call _objc_release
0x00012578  mov      x0, x24
