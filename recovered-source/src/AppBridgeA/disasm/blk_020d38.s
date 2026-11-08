; block literal @0x34cb0 desc @0x34610 sig=v8@?0 flags=0x50000000
; ==== sub_20d38 @ 0x20d38..0x20dd4 (156 bytes) ====
0x00020d38  stp      d9, d8, [sp, #-0x70]!
0x00020d3c  stp      x28, x27, [sp, #0x10]
0x00020d40  stp      x26, x25, [sp, #0x20]
0x00020d44  stp      x24, x23, [sp, #0x30]
0x00020d48  stp      x22, x21, [sp, #0x40]
0x00020d4c  stp      x20, x19, [sp, #0x50]
0x00020d50  stp      x29, x30, [sp, #0x60]
0x00020d54  add      x29, sp, #0x60
0x00020d58  sub      sp, sp, #0x2d0
0x00020d5c  adrp     x8, #0x34000
0x00020d60  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00020d64  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00020d68  stur     x8, [x29, #-0x70]
0x00020d6c  movi     v0.16b, #0
0x00020d70  stp      q0, q0, [sp, #0x80]
0x00020d74  stp      q0, q0, [sp, #0xa0]
0x00020d78  adrp     x8, #0x3e000
0x00020d7c  ldr      x0, [x8, #0x430]   ; -> [class(UIScreen)]
0x00020d80  bl       #0x26a60   ; objc_msgSend: screens
0x00020d84  mov      x29, x29
0x00020d88  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020d8c  add      x2, sp, #0x80
0x00020d90  add      x3, sp, #0x100
0x00020d94  str      x0, [sp, #0x28]
0x00020d98  mov      w4, #0x10
0x00020d9c  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00020da0  str      x0, [sp, #0x50]
0x00020da4  ldr      x8, [sp, #0x50]
0x00020da8  cbz      x8, #0x21d0c
0x00020dac  ldr      x8, [sp, #0x90]
0x00020db0  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00020db4  str      x8, [sp, #0x48]
0x00020db8  fmov     d8, #1.00000000
0x00020dbc  adrp     x24, #0x3e000
0x00020dc0  str      xzr, [sp, #0x68]
0x00020dc4  ldr      x8, [sp, #0x90]
0x00020dc8  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00020dcc  ldr      x9, [sp, #0x48]
0x00020dd0  cmp      x8, x9

