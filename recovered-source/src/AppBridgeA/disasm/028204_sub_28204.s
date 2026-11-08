; ==== sub_28204 @ 0x28204..0x28218 (20 bytes) ====
0x00028204  ldr      x1, [x1, #0xc0]
0x00028208  adrp     x16, #0x34000
0x0002820c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00028210  br       x16
0x00028214  brk      #1
