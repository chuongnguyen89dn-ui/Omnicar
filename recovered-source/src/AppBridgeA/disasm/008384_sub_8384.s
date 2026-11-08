; ==== sub_8384 @ 0x8384..0x84a8 (292 bytes) ====
0x00008384  mov      x29, x29
0x00008388  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000838c  mov      x22, x0
0x00008390  bl       #0x25640   ; objc_msgSend: doubleValue
0x00008394  mov      v12.16b, v0.16b
0x00008398  adrp     x2, #0x35000
0x0000839c  add      x2, x2, #0x3f0   ; -> @"pl"
0x000083a0  mov      x0, x20
0x000083a4  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000083a8  mov      x29, x29
0x000083ac  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000083b0  mov      x23, x0
0x000083b4  bl       #0x25640   ; objc_msgSend: doubleValue
0x000083b8  mov      v13.16b, v0.16b
0x000083bc  adrp     x2, #0x35000
0x000083c0  add      x2, x2, #0x410   ; -> @"pb"
0x000083c4  mov      x0, x20
0x000083c8  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000083cc  mov      x29, x29
0x000083d0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000083d4  mov      x24, x0
0x000083d8  bl       #0x25640   ; objc_msgSend: doubleValue
0x000083dc  mov      v14.16b, v0.16b
0x000083e0  adrp     x2, #0x35000
0x000083e4  add      x2, x2, #0x430   ; -> @"pr"
0x000083e8  mov      x0, x20
0x000083ec  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000083f0  mov      x29, x29
0x000083f4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000083f8  mov      x19, x0
0x000083fc  bl       #0x25640   ; objc_msgSend: doubleValue
0x00008400  mov      v15.16b, v0.16b
0x00008404  mov      x0, x19
0x00008408  bl       #0x2480c   ; call _objc_release
0x0000840c  mov      x0, x24
0x00008410  bl       #0x2480c   ; call _objc_release
0x00008414  mov      x0, x23
0x00008418  bl       #0x2480c   ; call _objc_release
0x0000841c  mov      x0, x22
0x00008420  bl       #0x2480c   ; call _objc_release
0x00008424  adrp     x8, #0x3e000
0x00008428  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x0000842c  bl       #0x27b20   ; objc_msgSend: shared
0x00008430  mov      x29, x29
0x00008434  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008438  mov      x23, x0
0x0000843c  adrp     x2, #0x35000
0x00008440  add      x2, x2, #0x3b0   ; -> @"identifier"
0x00008444  mov      x0, x20
0x00008448  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0000844c  mov      x29, x29
0x00008450  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008454  mov      x24, x0
0x00008458  adrp     x2, #0x35000
0x0000845c  add      x2, x2, #0x690   ; -> @"live"
0x00008460  mov      x0, x20
0x00008464  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008468  mov      x29, x29
0x0000846c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008470  mov      x25, x0
0x00008474  bl       #0x24f20   ; objc_msgSend: boolValue
0x00008478  mov      x21, x0
0x0000847c  adrp     x2, #0x35000
0x00008480  add      x2, x2, #0x6b0   ; -> @"handle"
0x00008484  mov      x0, x20
0x00008488  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0000848c  mov      x29, x29
0x00008490  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008494  mov      x26, x0
0x00008498  bl       #0x24f20   ; objc_msgSend: boolValue
0x0000849c  mov      x4, x0
0x000084a0  mov      x0, x23
0x000084a4  mov      v0.16b, v8.16b
