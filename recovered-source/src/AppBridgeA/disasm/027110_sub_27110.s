; ==== sub_27110 @ 0x27110..0x271b0 (160 bytes) ====
0x00027110  br       x16
0x00027114  brk      #1
0x00027118  brk      #1
0x0002711c  brk      #1
0x00027120  adrp     x1, #0x3d000
0x00027124  ldr      x1, [x1, #0xc88]   ; -> [@selector(setHole:forApp:)]
0x00027128  adrp     x16, #0x34000
0x0002712c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00027130  br       x16
0x00027134  brk      #1
0x00027138  brk      #1
0x0002713c  brk      #1
0x00027140  adrp     x1, #0x3d000
0x00027144  ldr      x1, [x1, #0xc90]   ; -> [@selector(setImage:)]
0x00027148  adrp     x16, #0x34000
0x0002714c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00027150  br       x16
0x00027154  brk      #1
0x00027158  brk      #1
0x0002715c  brk      #1
0x00027160  adrp     x1, #0x3d000
0x00027164  ldr      x1, [x1, #0xc98]   ; -> [@selector(setImage:forState:)]
0x00027168  adrp     x16, #0x34000
0x0002716c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00027170  br       x16
0x00027174  brk      #1
0x00027178  brk      #1
0x0002717c  brk      #1
0x00027180  adrp     x1, #0x3d000
0x00027184  ldr      x1, [x1, #0xca0]   ; -> [@selector(setIndex:)]
0x00027188  adrp     x16, #0x34000
0x0002718c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00027190  br       x16
0x00027194  brk      #1
0x00027198  brk      #1
0x0002719c  brk      #1
0x000271a0  adrp     x1, #0x3d000
0x000271a4  ldr      x1, [x1, #0xca8]   ; -> [@selector(setInputView:)]
0x000271a8  adrp     x16, #0x34000
0x000271ac  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
