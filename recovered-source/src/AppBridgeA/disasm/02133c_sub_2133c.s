; ==== sub_2133c @ 0x2133c..0x2136c (48 bytes) ====
0x0002133c  bl       #0x262e0   ; objc_msgSend: numberWithDouble:
0x00021340  mov      x29, x29
0x00021344  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021348  mov      x19, x0
0x0002134c  ldr      x0, [sp, #0x78]
0x00021350  mov      x2, x19
0x00021354  adrp     x3, #0x38000
0x00021358  add      x3, x3, #0x1f0   ; -> @"scale"
0x0002135c  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00021360  mov      x0, x19
0x00021364  bl       #0x2480c   ; call _objc_release
0x00021368  adrp     x8, #0x3e000
