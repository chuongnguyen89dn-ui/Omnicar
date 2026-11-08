; ==== sub_27cb0 @ 0x27cb0..0x27d44 (148 bytes) ====
0x00027cb0  br       x16
0x00027cb4  brk      #1
0x00027cb8  brk      #1
0x00027cbc  brk      #1
0x00027cc0  adrp     x1, #0x3d000
0x00027cc4  ldr      x1, [x1, #0xf70]   ; -> [@selector(stringFromDate:)]
0x00027cc8  adrp     x16, #0x34000
0x00027ccc  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00027cd0  br       x16
0x00027cd4  brk      #1
0x00027cd8  brk      #1
0x00027cdc  brk      #1
0x00027ce0  adrp     x1, #0x3d000
0x00027ce4  ldr      x1, [x1, #0xf78]   ; -> [@selector(stringWithCharacters:length:)]
0x00027ce8  adrp     x16, #0x34000
0x00027cec  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00027cf0  br       x16
0x00027cf4  brk      #1
0x00027cf8  brk      #1
0x00027cfc  brk      #1
0x00027d00  adrp     x1, #0x3d000
0x00027d04  ldr      x1, [x1, #0xf80]   ; -> [@selector(stringWithContentsOfFile:encoding:error:)]
0x00027d08  adrp     x16, #0x34000
0x00027d0c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00027d10  br       x16
0x00027d14  brk      #1
0x00027d18  brk      #1
0x00027d1c  brk      #1
0x00027d20  adrp     x1, #0x3d000
0x00027d24  ldr      x1, [x1, #0xf88]   ; -> [@selector(stringWithFormat:)]
0x00027d28  adrp     x16, #0x34000
0x00027d2c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00027d30  br       x16
0x00027d34  brk      #1
0x00027d38  brk      #1
0x00027d3c  brk      #1
0x00027d40  adrp     x1, #0x3d000
