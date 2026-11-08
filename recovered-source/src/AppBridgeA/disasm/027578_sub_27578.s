; ==== sub_27578 @ 0x27578..0x2758c (20 bytes) ====
0x00027578  brk      #1
0x0002757c  brk      #1
0x00027580  adrp     x1, #0x3d000
0x00027584  ldr      x1, [x1, #0xda0]   ; -> [@selector(setPreview:)]
0x00027588  adrp     x16, #0x34000
