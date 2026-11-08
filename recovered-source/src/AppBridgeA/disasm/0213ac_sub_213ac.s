; ==== sub_213ac @ 0x213ac..0x213dc (48 bytes) ====
0x000213ac  adrp     x0, #0x2a000
0x000213b0  add      x0, x0, #0xc08   ; -> "/System/Library/PrivateFrameworks/CarKit.framework/CarKit"
0x000213b4  mov      w1, #1
0x000213b8  bl       #0x245e4   ; call _dlopen
0x000213bc  adrp     x0, #0x38000
0x000213c0  add      x0, x0, #0x230   ; -> @"CARSessionStatus"
0x000213c4  bl       #0x243f8   ; call _NSClassFromString
0x000213c8  adrp     x8, #0x3e000
0x000213cc  ldr      x19, [x8, #0xb40]
0x000213d0  cbnz     x19, #0x213f8
0x000213d4  cbz      x0, #0x213f8
0x000213d8  bl       #0x247e8   ; call _objc_opt_new
