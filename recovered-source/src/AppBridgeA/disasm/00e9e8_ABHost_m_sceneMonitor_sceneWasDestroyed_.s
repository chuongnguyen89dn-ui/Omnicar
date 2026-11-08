; ==== ABHost_m_sceneMonitor_sceneWasDestroyed_ @ 0xe9e8..0xea2c (68 bytes) ====
0x0000e9e8  sub      sp, sp, #0x140
0x0000e9ec  stp      x28, x27, [sp, #0xe0]
0x0000e9f0  stp      x26, x25, [sp, #0xf0]
0x0000e9f4  stp      x24, x23, [sp, #0x100]
0x0000e9f8  stp      x22, x21, [sp, #0x110]
0x0000e9fc  stp      x20, x19, [sp, #0x120]
0x0000ea00  stp      x29, x30, [sp, #0x130]
0x0000ea04  add      x29, sp, #0x130
0x0000ea08  mov      x19, x2
0x0000ea0c  mov      x21, x0
0x0000ea10  adrp     x8, #0x34000
0x0000ea14  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0000ea18  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0000ea1c  stur     x8, [x29, #-0x58]
0x0000ea20  mov      x0, x2
0x0000ea24  bl       #0x24818   ; call _objc_retain
0x0000ea28  movi     v0.16b, #0
