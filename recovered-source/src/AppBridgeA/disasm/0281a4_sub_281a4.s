; ==== sub_281a4 @ 0x281a4..0x281b8 (20 bytes) ====
0x000281a4  ldr      x1, [x1, #0xa8]
0x000281a8  adrp     x16, #0x34000
0x000281ac  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x000281b0  br       x16
0x000281b4  brk      #1
