; block literal @0x347b0 desc @0x34670 sig=v16@?0@"NSNotification"8 flags=0x50000000
; ==== sub_958c @ 0x958c..0x95d8 (76 bytes) ====
0x0000958c  stp      x20, x19, [sp, #-0x20]!
0x00009590  stp      x29, x30, [sp, #0x10]
0x00009594  add      x29, sp, #0x10
0x00009598  adrp     x0, #0x29000
0x0000959c  add      x0, x0, #0x667   ; -> "AVExternalDevice"
0x000095a0  bl       #0x24788   ; call _objc_getClass
0x000095a4  mov      x29, x29
0x000095a8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000095ac  mov      x19, x0
0x000095b0  adrp     x0, #0x35000
0x000095b4  add      x0, x0, #0x8f0   ; -> @"currentCarPlayExternalDevice"
0x000095b8  bl       #0x2441c   ; call _NSSelectorFromString
0x000095bc  mov      x20, x0
0x000095c0  mov      x0, x19
0x000095c4  mov      x1, x20
0x000095c8  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x000095cc  tbz      w0, #0, #0x95ec
0x000095d0  mov      x0, x19
0x000095d4  mov      x1, x20

