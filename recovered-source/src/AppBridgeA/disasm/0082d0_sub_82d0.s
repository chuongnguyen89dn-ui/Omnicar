; ==== sub_82d0 @ 0x82d0..0x8384 (180 bytes) ====
0x000082d0  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000082d4  mov      x29, x29
0x000082d8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000082dc  mov      x22, x0
0x000082e0  bl       #0x25640   ; objc_msgSend: doubleValue
0x000082e4  mov      v8.16b, v0.16b
0x000082e8  adrp     x2, #0x35000
0x000082ec  add      x2, x2, #0x350   ; -> @"y"
0x000082f0  mov      x0, x20
0x000082f4  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000082f8  mov      x29, x29
0x000082fc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008300  mov      x23, x0
0x00008304  bl       #0x25640   ; objc_msgSend: doubleValue
0x00008308  mov      v9.16b, v0.16b
0x0000830c  adrp     x2, #0x35000
0x00008310  add      x2, x2, #0x370   ; -> @"w"
0x00008314  mov      x0, x20
0x00008318  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0000831c  mov      x29, x29
0x00008320  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008324  mov      x24, x0
0x00008328  bl       #0x25640   ; objc_msgSend: doubleValue
0x0000832c  mov      v10.16b, v0.16b
0x00008330  adrp     x2, #0x35000
0x00008334  add      x2, x2, #0x390   ; -> @"h"
0x00008338  mov      x0, x20
0x0000833c  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008340  mov      x29, x29
0x00008344  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008348  mov      x19, x0
0x0000834c  bl       #0x25640   ; objc_msgSend: doubleValue
0x00008350  mov      v11.16b, v0.16b
0x00008354  mov      x0, x19
0x00008358  bl       #0x2480c   ; call _objc_release
0x0000835c  mov      x0, x24
0x00008360  bl       #0x2480c   ; call _objc_release
0x00008364  mov      x0, x23
0x00008368  bl       #0x2480c   ; call _objc_release
0x0000836c  mov      x0, x22
0x00008370  bl       #0x2480c   ; call _objc_release
0x00008374  adrp     x2, #0x35000
0x00008378  add      x2, x2, #0x3d0   ; -> @"pt"
0x0000837c  mov      x0, x20
0x00008380  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
