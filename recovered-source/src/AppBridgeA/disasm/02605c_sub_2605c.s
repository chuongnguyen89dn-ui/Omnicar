; ==== sub_2605c @ 0x2605c..0x260cc (112 bytes) ====
0x0002605c  brk      #1
0x00026060  adrp     x1, #0x3d000
0x00026064  ldr      x1, [x1, #0x858]   ; -> [@selector(lowercaseString)]
0x00026068  adrp     x16, #0x34000
0x0002606c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00026070  br       x16
0x00026074  brk      #1
0x00026078  brk      #1
0x0002607c  brk      #1
0x00026080  adrp     x1, #0x3d000
0x00026084  ldr      x1, [x1, #0x860]   ; -> [@selector(mainBundle)]
0x00026088  adrp     x16, #0x34000
0x0002608c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00026090  br       x16
0x00026094  brk      #1
0x00026098  brk      #1
0x0002609c  brk      #1
0x000260a0  adrp     x1, #0x3d000
0x000260a4  ldr      x1, [x1, #0x868]   ; -> [@selector(mainQueue)]
0x000260a8  adrp     x16, #0x34000
0x000260ac  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x000260b0  br       x16
0x000260b4  brk      #1
0x000260b8  brk      #1
0x000260bc  brk      #1
0x000260c0  adrp     x1, #0x3d000
0x000260c4  ldr      x1, [x1, #0x870]   ; -> [@selector(mainRunLoop)]
0x000260c8  adrp     x16, #0x34000
