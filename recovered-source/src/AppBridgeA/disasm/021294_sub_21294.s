; ==== sub_21294 @ 0x21294..0x212c4 (48 bytes) ====
0x00021294  bl       #0x2480c   ; call _objc_release
0x00021298  ldr      x0, [sp, #0x70]
0x0002129c  bl       #0x24f40   ; objc_msgSend: bounds
0x000212a0  adrp     x8, #0x3e000
0x000212a4  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x000212a8  stp      d2, d3, [sp]
0x000212ac  adrp     x2, #0x38000
0x000212b0  add      x2, x2, #0x670   ; -> @"%.0fx%.0f"
0x000212b4  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x000212b8  mov      x29, x29
0x000212bc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000212c0  mov      x19, x0
