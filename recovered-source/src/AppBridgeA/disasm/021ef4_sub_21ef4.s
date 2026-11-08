; ==== sub_21ef4 @ 0x21ef4..0x21f38 (68 bytes) ====
0x00021ef4  adrp     x8, #0x3e000
0x00021ef8  ldr      x0, [x8, #0x400]   ; -> [class(NSCharacterSet)]
0x00021efc  bl       #0x26240   ; objc_msgSend: newlineCharacterSet
0x00021f00  mov      x29, x29
0x00021f04  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021f08  mov      x27, x0
0x00021f0c  mov      x0, x23
0x00021f10  mov      x2, x27
0x00021f14  bl       #0x252c0   ; objc_msgSend: componentsSeparatedByCharactersInSet:
0x00021f18  mov      x29, x29
0x00021f1c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021f20  mov      x22, x0
0x00021f24  adrp     x2, #0x36000
0x00021f28  add      x2, x2, #0xfd0   ; -> @" "
0x00021f2c  bl       #0x252a0   ; objc_msgSend: componentsJoinedByString:
0x00021f30  mov      x29, x29
0x00021f34  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
