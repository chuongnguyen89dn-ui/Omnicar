; ==== sub_243e4 @ 0x243e4..0x24414 (48 bytes) ====
0x000243e4  ldr      x16, [x16, #0x590]
0x000243e8  br       x16
0x000243ec  adrp     x16, #0x34000
0x000243f0  ldr      x16, [x16, #0x598]   ; -> [got:_MSHookMessageEx]
0x000243f4  br       x16
0x000243f8  adrp     x16, #0x34000
0x000243fc  ldr      x16, [x16, #0x180]   ; -> [got:_NSClassFromString]
0x00024400  br       x16
0x00024404  adrp     x16, #0x34000
0x00024408  ldr      x16, [x16, #0x188]   ; -> [got:_NSGetUncaughtExceptionHandler]
0x0002440c  br       x16
0x00024410  adrp     x16, #0x34000
