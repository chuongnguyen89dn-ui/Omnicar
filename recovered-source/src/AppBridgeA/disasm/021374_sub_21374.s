; ==== sub_21374 @ 0x21374..0x213a4 (48 bytes) ====
0x00021374  bl       #0x26140   ; objc_msgSend: maximumFramesPerSecond
0x00021378  mov      x2, x0
0x0002137c  mov      x0, x19
0x00021380  bl       #0x26340   ; objc_msgSend: numberWithInteger:
0x00021384  mov      x29, x29
0x00021388  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0002138c  mov      x19, x0
0x00021390  ldr      x0, [sp, #0x78]
0x00021394  mov      x2, x19
0x00021398  adrp     x3, #0x38000
0x0002139c  add      x3, x3, #0x210   ; -> @"maxFPS"
0x000213a0  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
