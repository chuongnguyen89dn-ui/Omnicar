; ==== sub_12944 @ 0x12944..0x1296c (40 bytes) ====
0x00012944  mov      x2, x20
0x00012948  bl       #0x277a0   ; objc_msgSend: setShield:forPane:
0x0001294c  add      x24, x24, #1
0x00012950  cmp      x22, x24
0x00012954  b.ne     #0x12920
0x00012958  mov      x2, sp
0x0001295c  add      x3, sp, #0x48
0x00012960  mov      x0, x19
0x00012964  mov      w4, #0x10
0x00012968  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
