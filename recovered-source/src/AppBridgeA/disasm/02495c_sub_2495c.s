; ==== sub_2495c @ 0x2495c..0x2498c (48 bytes) ====
0x0002495c  adrp     x16, #0x34000
0x00024960  ldr      x16, [x16, #0x458]   ; -> [got:_strncmp]
0x00024964  br       x16
0x00024968  adrp     x16, #0x34000
0x0002496c  ldr      x16, [x16, #0x460]   ; -> [got:_strrchr]
0x00024970  br       x16
0x00024974  adrp     x16, #0x34000
0x00024978  ldr      x16, [x16, #0x468]   ; -> [got:_strstr]
0x0002497c  br       x16
0x00024980  adrp     x16, #0x34000
0x00024984  ldr      x16, [x16, #0x470]   ; -> [got:_strtoull]
0x00024988  br       x16
