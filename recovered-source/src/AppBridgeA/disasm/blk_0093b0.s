; block literal @0x34790 desc @0x34750 sig=v12@?0i8 flags=0x50000000
; ==== sub_93b0 @ 0x93b0..0x943c (140 bytes) ====
0x000093b0  sub      sp, sp, #0x40
0x000093b4  stp      x22, x21, [sp, #0x10]
0x000093b8  stp      x20, x19, [sp, #0x20]
0x000093bc  stp      x29, x30, [sp, #0x30]
0x000093c0  add      x29, sp, #0x30
0x000093c4  mov      x0, x1
0x000093c8  str      xzr, [sp, #8]
0x000093cc  add      x1, sp, #8
0x000093d0  bl       #0x246e0   ; call _notify_get_state
0x000093d4  adrp     x8, #0x3e000
0x000093d8  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x000093dc  bl       #0x27b20   ; objc_msgSend: shared
0x000093e0  mov      x29, x29
0x000093e4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000093e8  mov      x20, x0
0x000093ec  ldr      x8, [sp, #8]
0x000093f0  lsr      x2, x8, #0x18
0x000093f4  bl       #0x25000   ; objc_msgSend: bundleForHash:
0x000093f8  mov      x29, x29
0x000093fc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009400  mov      x19, x0
0x00009404  mov      x0, x20
0x00009408  bl       #0x2480c   ; call _objc_release
0x0000940c  cbz      x19, #0x943c
0x00009410  adrp     x8, #0x3e000
0x00009414  ldr      x0, [x8, #0x2e8]   ; -> [class(ABKeyboard)]
0x00009418  ldrb     w8, [sp, #8]
0x0000941c  tbnz     w8, #0, #0x947c
0x00009420  bl       #0x27b20   ; objc_msgSend: shared
0x00009424  mov      x29, x29
0x00009428  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000942c  mov      x20, x0
0x00009430  mov      x2, x19
0x00009434  bl       #0x25900   ; objc_msgSend: hideForApp:
0x00009438  b        #0x94a0   ; call sub_94a0

