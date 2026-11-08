; block literal @0x34bf0 desc @0x34610 sig=v8@?0 flags=0x50000000
; ==== sub_1ee1c @ 0x1ee1c..0x1ee50 (52 bytes) ====
0x0001ee1c  stp      x29, x30, [sp, #-0x10]!
0x0001ee20  mov      x29, sp
0x0001ee24  adrp     x8, #0x3e000
0x0001ee28  ldr      x0, [x8, #0x2f0]   ; -> [class(NSMutableSet)]
0x0001ee2c  bl       #0x26ac0   ; objc_msgSend: set
0x0001ee30  mov      x29, x29
0x0001ee34  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ee38  adrp     x9, #0x3e000
0x0001ee3c  ldr      x8, [x9, #0xab8]
0x0001ee40  str      x0, [x9, #0xab8]
0x0001ee44  mov      x0, x8
0x0001ee48  ldp      x29, x30, [sp], #0x10
0x0001ee4c  b        #0x2480c   ; call _objc_release

