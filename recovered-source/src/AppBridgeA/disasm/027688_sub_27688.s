; ==== sub_27688 @ 0x27688..0x27694 (12 bytes) ====
0x00027688  adrp     x16, #0x34000
0x0002768c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00027690  br       x16
