; ==== sub_28170 @ 0x28170..0x281a4 (52 bytes) ====
0x00028170  br       x16
0x00028174  brk      #1
0x00028178  brk      #1
0x0002817c  brk      #1
0x00028180  adrp     x1, #0x3e000
0x00028184  ldr      x1, [x1, #0xa0]   ; -> [@selector(weakObjectsHashTable)]
0x00028188  adrp     x16, #0x34000
0x0002818c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00028190  br       x16
0x00028194  brk      #1
0x00028198  brk      #1
0x0002819c  brk      #1
0x000281a0  adrp     x1, #0x3e000
