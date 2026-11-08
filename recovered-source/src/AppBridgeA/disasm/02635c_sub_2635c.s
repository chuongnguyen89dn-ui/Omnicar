; ==== sub_2635c @ 0x2635c..0x263b4 (88 bytes) ====
0x0002635c  brk      #1
0x00026360  adrp     x1, #0x3d000
0x00026364  ldr      x1, [x1, #0x918]   ; -> [@selector(numberWithLong:)]
0x00026368  adrp     x16, #0x34000
0x0002636c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00026370  br       x16
0x00026374  brk      #1
0x00026378  brk      #1
0x0002637c  brk      #1
0x00026380  adrp     x1, #0x3d000
0x00026384  ldr      x1, [x1, #0x920]   ; -> [@selector(numberWithLongLong:)]
0x00026388  adrp     x16, #0x34000
0x0002638c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00026390  br       x16
0x00026394  brk      #1
0x00026398  brk      #1
0x0002639c  brk      #1
0x000263a0  adrp     x1, #0x3d000
0x000263a4  ldr      x1, [x1, #0x928]   ; -> [@selector(numberWithUnsignedInteger:)]
0x000263a8  adrp     x16, #0x34000
0x000263ac  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x000263b0  br       x16
