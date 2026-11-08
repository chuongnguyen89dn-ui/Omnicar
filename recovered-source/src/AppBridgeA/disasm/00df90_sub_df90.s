; ==== sub_df90 @ 0xdf90..0xe02c (156 bytes) ====
0x0000df90  bl       #0x25c00   ; objc_msgSend: invocationWithMethodSignature:
0x0000df94  mov      x29, x29
0x0000df98  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000df9c  mov      x25, x0
0x0000dfa0  mov      x2, x19
0x0000dfa4  bl       #0x278a0   ; objc_msgSend: setTarget:
0x0000dfa8  mov      x0, x25
0x0000dfac  mov      x2, x21
0x0000dfb0  bl       #0x276c0   ; objc_msgSend: setSelector:
0x0000dfb4  adrp     x2, #0x36000
0x0000dfb8  add      x2, x2, #0x950   ; -> @":"
0x0000dfbc  mov      x0, x20
0x0000dfc0  bl       #0x252e0   ; objc_msgSend: componentsSeparatedByString:
0x0000dfc4  mov      x29, x29
0x0000dfc8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000dfcc  mov      x26, x0
0x0000dfd0  adrp     x8, #0x34000
0x0000dfd4  ldr      x8, [x8, #0x250]   ; -> [got:_UIWindowSceneSessionRoleApplication]
0x0000dfd8  ldr      x0, [x8]   ; -> [got:___objc_personality_v0]
0x0000dfdc  str      x0, [sp, #8]
0x0000dfe0  bl       #0x24818   ; call _objc_retain
0x0000dfe4  mov      x28, #0
0x0000dfe8  mov      x0, x26
0x0000dfec  bl       #0x25420   ; objc_msgSend: count
0x0000dff0  add      x8, x28, #1
0x0000dff4  cmp      x8, x0
0x0000dff8  b.hs     #0xe12c
0x0000dffc  mov      x0, x24
0x0000e000  bl       #0x262a0   ; objc_msgSend: numberOfArguments
0x0000e004  add      x21, x28, #2
0x0000e008  cmp      x21, x0
0x0000e00c  b.hs     #0xe12c
0x0000e010  mov      x0, x26
0x0000e014  mov      x2, x28
0x0000e018  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x0000e01c  mov      x29, x29
0x0000e020  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000e024  mov      x27, x0
0x0000e028  bl       #0x26060   ; objc_msgSend: lowercaseString
