; block literal @0x34c70 desc @0x34670 sig=v16@?0@"NSNotification"8 flags=0x50000000
; ==== sub_20958 @ 0x20958..0x2098c (52 bytes) ====
0x00020958  b        #0x2095c   ; call sub_2095c
0x0002095c  stp      x29, x30, [sp, #-0x10]!
0x00020960  mov      x29, sp
0x00020964  mov      x0, #0
0x00020968  mov      w1, #0x2800
0x0002096c  movk     w1, #0xee6b, lsl #16
0x00020970  bl       #0x245cc   ; call _dispatch_time
0x00020974  adrp     x1, #0x34000
0x00020978  ldr      x1, [x1, #0x290]   ; -> [got:__dispatch_main_q]
0x0002097c  adrp     x2, #0x34000
0x00020980  add      x2, x2, #0xcb0
0x00020984  ldp      x29, x30, [sp], #0x10
0x00020988  b        #0x24548   ; call _dispatch_after

