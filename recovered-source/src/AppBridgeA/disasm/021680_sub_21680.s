; ==== sub_21680 @ 0x21680..0x216e8 (104 bytes) ====
0x00021680  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00021684  mov      x20, x0
0x00021688  cbz      x0, #0x2175c
0x0002168c  ldr      x8, [sp, #0xd0]
0x00021690  ldr      x26, [x8]
0x00021694  mov      x28, #0
0x00021698  ldr      x8, [sp, #0xd0]
0x0002169c  ldr      x8, [x8]
0x000216a0  cmp      x8, x26
0x000216a4  b.eq     #0x216b0
0x000216a8  mov      x0, x22
0x000216ac  bl       #0x24770   ; call _objc_enumerationMutation
0x000216b0  ldr      x8, [sp, #0xc8]
0x000216b4  ldr      x23, [x8, x28, lsl #3]
0x000216b8  mov      x0, x22
0x000216bc  mov      x2, x23
0x000216c0  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000216c4  mov      x29, x29
0x000216c8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000216cc  mov      x25, x0
0x000216d0  ldr      x0, [x24, #0x310]
0x000216d4  bl       #0x247d0   ; call _objc_opt_class
0x000216d8  mov      x1, x0
0x000216dc  mov      x0, x25
0x000216e0  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x000216e4  mov      x21, x0
