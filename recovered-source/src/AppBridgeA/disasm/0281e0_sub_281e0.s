; ==== sub_281e0 @ 0x281e0..0x28204 (36 bytes) ====
0x000281e0  adrp     x1, #0x3e000
0x000281e4  ldr      x1, [x1, #0xb8]   ; -> [@selector(window)]
0x000281e8  adrp     x16, #0x34000
0x000281ec  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x000281f0  br       x16
0x000281f4  brk      #1
0x000281f8  brk      #1
0x000281fc  brk      #1
0x00028200  adrp     x1, #0x3e000
