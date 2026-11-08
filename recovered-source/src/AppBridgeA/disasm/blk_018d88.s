; block literal @0x34af0 desc @0x34610 sig=v8@?0 flags=0x50000000
; ==== sub_18d88 @ 0x18d88..0x18db4 (44 bytes) ====
0x00018d88  stp      x29, x30, [sp, #-0x10]!
0x00018d8c  mov      x29, sp
0x00018d90  adrp     x8, #0x3e000
0x00018d94  ldr      x0, [x8, #0x2e8]   ; -> [class(ABKeyboard)]
0x00018d98  bl       #0x247e8   ; call _objc_opt_new
0x00018d9c  adrp     x9, #0x3e000
0x00018da0  ldr      x8, [x9, #0xa50]
0x00018da4  str      x0, [x9, #0xa50]
0x00018da8  mov      x0, x8
0x00018dac  ldp      x29, x30, [sp], #0x10
0x00018db0  b        #0x2480c   ; call _objc_release

