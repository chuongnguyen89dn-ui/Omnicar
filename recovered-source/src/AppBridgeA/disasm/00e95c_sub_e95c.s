; ==== sub_e95c @ 0xe95c..0xe970 (20 bytes) ====
0x0000e95c  add      x0, x19, #0x20
0x0000e960  ldp      x29, x30, [sp, #0x10]
0x0000e964  ldp      x20, x19, [sp], #0x20
0x0000e968  b        #0x24758   ; call _objc_destroyWeak
0x0000e96c  stp      x20, x19, [sp, #-0x20]!
