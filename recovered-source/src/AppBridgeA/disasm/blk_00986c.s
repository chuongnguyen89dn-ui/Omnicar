; block literal @0x347f0 desc @0x34610 sig=v8@?0 flags=0x50000000
; ==== sub_986c @ 0x986c..0x9888 (28 bytes) ====
0x0000986c  stp      x29, x30, [sp, #-0x10]!
0x00009870  mov      x29, sp
0x00009874  adrp     x8, #0x3e000
0x00009878  ldr      x0, [x8, #0x2f0]   ; -> [class(NSMutableSet)]
0x0000987c  bl       #0x26ac0   ; objc_msgSend: set
0x00009880  mov      x29, x29
0x00009884  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue

