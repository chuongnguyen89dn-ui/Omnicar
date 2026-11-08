; ==== sub_281b8 @ 0x281b8..0x281cc (20 bytes) ====
0x000281b8  brk      #1
0x000281bc  brk      #1
0x000281c0  adrp     x1, #0x3e000
0x000281c4  ldr      x1, [x1, #0xb0]   ; -> [@selector(whiteColor)]
0x000281c8  adrp     x16, #0x34000
