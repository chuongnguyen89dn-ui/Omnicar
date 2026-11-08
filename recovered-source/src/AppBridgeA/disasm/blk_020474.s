; block literal @0x34c50 desc @0x34610 sig=v8@?0 flags=0x50000000
; ==== sub_20474 @ 0x20474..0x205c8 (340 bytes) ====
0x00020474  stp      x20, x19, [sp, #-0x20]!
0x00020478  stp      x29, x30, [sp, #0x10]
0x0002047c  add      x29, sp, #0x10
0x00020480  adrp     x8, #0x3e000
0x00020484  ldr      x0, [x8, #0x280]   ; -> [class(NSBundle)]
0x00020488  bl       #0x26080   ; objc_msgSend: mainBundle
0x0002048c  mov      x29, x29
0x00020490  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020494  mov      x19, x0
0x00020498  bl       #0x25040   ; objc_msgSend: bundleIdentifier
0x0002049c  mov      x29, x29
0x000204a0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000204a4  mov      x20, x0
0x000204a8  adrp     x2, #0x34000
0x000204ac  add      x2, x2, #0xe10   ; -> @"com.apple.CarPlayApp"
0x000204b0  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x000204b4  adrp     x8, #0x3e000
0x000204b8  strb     w0, [x8, #0xb20]
0x000204bc  mov      x0, x20
0x000204c0  bl       #0x2480c   ; call _objc_release
0x000204c4  mov      x0, x19
0x000204c8  ldp      x29, x30, [sp, #0x10]
0x000204cc  ldp      x20, x19, [sp], #0x20
0x000204d0  b        #0x2480c   ; call _objc_release
0x000204d4  stp      x28, x27, [sp, #-0x60]!
0x000204d8  stp      x26, x25, [sp, #0x10]
0x000204dc  stp      x24, x23, [sp, #0x20]
0x000204e0  stp      x22, x21, [sp, #0x30]
0x000204e4  stp      x20, x19, [sp, #0x40]
0x000204e8  stp      x29, x30, [sp, #0x50]
0x000204ec  add      x29, sp, #0x50
0x000204f0  sub      sp, sp, #0x2f0
0x000204f4  mov      x19, x0
0x000204f8  adrp     x8, #0x34000
0x000204fc  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00020500  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00020504  stur     x8, [x29, #-0x58]
0x00020508  bl       #0x24818   ; call _objc_retain
0x0002050c  adrp     x8, #0x3e000
0x00020510  ldr      x0, [x8, #0xb30]
0x00020514  mov      w8, #0x1a4
0x00020518  str      x8, [sp]
0x0002051c  mov      w1, #0x209
0x00020520  bl       #0x248b4   ; call _open
0x00020524  tbnz     w0, #0x1f, #0x206dc
0x00020528  mov      x20, x0
0x0002052c  movi     v0.16b, #0
0x00020530  stp      q0, q0, [sp, #0x20]
0x00020534  stp      q0, q0, [sp, #0x40]
0x00020538  mov      x0, x19
0x0002053c  bl       #0x250a0   ; objc_msgSend: callStackReturnAddresses
0x00020540  mov      x29, x29
0x00020544  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020548  mov      x21, x0
0x0002054c  add      x2, sp, #0x20
0x00020550  add      x3, sp, #0x68
0x00020554  mov      w4, #0x10
0x00020558  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0002055c  cbz      x0, #0x205e8
0x00020560  mov      x22, x0
0x00020564  mov      x23, #0
0x00020568  ldr      x8, [sp, #0x30]
0x0002056c  ldr      x24, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00020570  add      x25, sp, #0xe8
0x00020574  mov      x26, #0
0x00020578  sxtw     x27, w23
0x0002057c  ldr      x8, [sp, #0x30]
0x00020580  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00020584  cmp      x8, x24
0x00020588  b.eq     #0x20594
0x0002058c  mov      x0, x21
0x00020590  bl       #0x24770   ; call _objc_enumerationMutation
0x00020594  cmp      x27, #0x40
0x00020598  b.eq     #0x205e0
0x0002059c  ldr      x8, [sp, #0x28]
0x000205a0  ldr      x0, [x8, x26, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x000205a4  bl       #0x28060   ; objc_msgSend: unsignedLongLongValue
0x000205a8  add      x23, x27, #1
0x000205ac  str      x0, [x25, x27, lsl #3]
0x000205b0  add      x26, x26, #1
0x000205b4  mov      x27, x23
0x000205b8  cmp      x22, x26
0x000205bc  b.ne     #0x2057c
0x000205c0  add      x2, sp, #0x20
0x000205c4  add      x3, sp, #0x68

