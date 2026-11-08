; ==== sub_18c7c @ 0x18c7c..0x18d34 (184 bytes) ====
0x00018c7c  stp      x29, x30, [sp, #0x20]
0x00018c80  add      x29, sp, #0x20
0x00018c84  mov      x19, x2
0x00018c88  mov      x20, x0
0x00018c8c  adrp     x8, #0x3e000
0x00018c90  ldrsw    x21, [x8, #0x50c]
0x00018c94  mov      x0, x2
0x00018c98  bl       #0x24818   ; call _objc_retain
0x00018c9c  ldr      x0, [x20, x21]
0x00018ca0  str      x19, [x20, x21]
0x00018ca4  ldp      x29, x30, [sp, #0x20]
0x00018ca8  ldp      x20, x19, [sp, #0x10]
0x00018cac  ldp      x22, x21, [sp], #0x30
0x00018cb0  b        #0x2480c   ; call _objc_release
0x00018cb4  stp      x20, x19, [sp, #-0x20]!
0x00018cb8  stp      x29, x30, [sp, #0x10]
0x00018cbc  add      x29, sp, #0x10
0x00018cc0  mov      x19, x0
0x00018cc4  adrp     x8, #0x3e000
0x00018cc8  ldrsw    x8, [x8, #0x50c]
0x00018ccc  add      x0, x0, x8
0x00018cd0  mov      x1, #0
0x00018cd4  bl       #0x24860   ; call _objc_storeStrong
0x00018cd8  adrp     x8, #0x3e000
0x00018cdc  ldrsw    x8, [x8, #0x508]
0x00018ce0  add      x0, x19, x8
0x00018ce4  mov      x1, #0
0x00018ce8  bl       #0x24860   ; call _objc_storeStrong
0x00018cec  adrp     x8, #0x3e000
0x00018cf0  ldrsw    x8, [x8, #0x504]
0x00018cf4  add      x0, x19, x8
0x00018cf8  mov      x1, #0
0x00018cfc  bl       #0x24860   ; call _objc_storeStrong
0x00018d00  adrp     x8, #0x3e000
0x00018d04  ldrsw    x8, [x8, #0x500]
0x00018d08  add      x0, x19, x8
0x00018d0c  mov      x1, #0
0x00018d10  bl       #0x24860   ; call _objc_storeStrong
0x00018d14  adrp     x8, #0x3e000
0x00018d18  ldrsw    x8, [x8, #0x4f4]
0x00018d1c  add      x0, x19, x8
0x00018d20  mov      x1, #0
0x00018d24  bl       #0x24860   ; call _objc_storeStrong
0x00018d28  adrp     x8, #0x3e000
0x00018d2c  ldrsw    x8, [x8, #0x4f0]
0x00018d30  add      x0, x19, x8
