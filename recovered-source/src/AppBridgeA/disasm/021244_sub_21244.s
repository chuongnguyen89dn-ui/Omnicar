; ==== sub_21244 @ 0x21244..0x2127c (56 bytes) ====
0x00021244  add      x3, x3, #0x130
0x00021248  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x0002124c  adrp     x8, #0x3e000
0x00021250  ldr      x0, [x8, #0x2b8]   ; -> [class(UIDevice)]
0x00021254  bl       #0x25460   ; objc_msgSend: currentDevice
0x00021258  mov      x29, x29
0x0002125c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021260  mov      x19, x0
0x00021264  bl       #0x27ec0   ; objc_msgSend: systemVersion
0x00021268  mov      x29, x29
0x0002126c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021270  mov      x20, x0
0x00021274  ldr      x0, [sp, #0x78]
0x00021278  mov      x2, x20
