; ==== sub_21304 @ 0x21304..0x21334 (48 bytes) ====
0x00021304  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021308  mov      x19, x0
0x0002130c  ldr      x0, [sp, #0x78]
0x00021310  mov      x2, x19
0x00021314  adrp     x3, #0x38000
0x00021318  add      x3, x3, #0x1d0   ; -> @"pixels"
0x0002131c  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00021320  mov      x0, x19
0x00021324  bl       #0x2480c   ; call _objc_release
0x00021328  adrp     x8, #0x3e000
0x0002132c  ldr      x19, [x8, #0x2a0]   ; -> [class(NSNumber)]
0x00021330  ldr      x0, [sp, #0x70]
