; ==== sub_95d8 @ 0x95d8..0x960c (52 bytes) ====
0x000095d8  bl       #0x247ac   ; call _objc_msgSend
0x000095dc  mov      x29, x29
0x000095e0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000095e4  mov      x20, x0
0x000095e8  b        #0x9600   ; call sub_9600
0x000095ec  adrp     x1, #0x35000
0x000095f0  add      x1, x1, #0x8f0   ; -> @"currentCarPlayExternalDevice"
0x000095f4  mov      x0, x19
0x000095f8  bl       #0x9698   ; call _ABMissingSelector
0x000095fc  mov      x20, #0
0x00009600  mov      x0, x19
0x00009604  bl       #0x2480c   ; call _objc_release
0x00009608  cbnz     x20, #0x9658
