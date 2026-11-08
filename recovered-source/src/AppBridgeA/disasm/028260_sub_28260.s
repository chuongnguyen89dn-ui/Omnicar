; ==== sub_28260 @ 0x28260..0x28274 (20 bytes) ====
0x00028260  adrp     x1, #0x3e000
0x00028264  ldr      x1, [x1, #0xd8]   ; -> [@selector(zoom)]
0x00028268  adrp     x16, #0x34000
0x0002826c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00028270  br       x16
