; ==== sub_133d0 @ 0x133d0..0x1340c (60 bytes) ====
0x000133d0  stp      x28, x27, [sp, #0x20]
0x000133d4  stp      x26, x25, [sp, #0x30]
0x000133d8  stp      x24, x23, [sp, #0x40]
0x000133dc  stp      x22, x21, [sp, #0x50]
0x000133e0  stp      x20, x19, [sp, #0x60]
0x000133e4  stp      x29, x30, [sp, #0x70]
0x000133e8  add      x29, sp, #0x70
0x000133ec  mov      x19, x2
0x000133f0  mov      x22, x0
0x000133f4  mov      x0, x2
0x000133f8  bl       #0x24818   ; call _objc_retain
0x000133fc  adrp     x26, #0x3e000
0x00013400  ldr      x0, [x26, #0x2d0]   ; -> [class(UIView)]
0x00013404  bl       #0x2471c   ; call _objc_alloc
0x00013408  mov      x8, #0x4046000000000000
