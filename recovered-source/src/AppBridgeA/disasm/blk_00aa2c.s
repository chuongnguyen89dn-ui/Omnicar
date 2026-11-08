; block literal @0x34840 desc @0x34610 sig=v8@?0 flags=0x50000000
; ==== sub_aa2c @ 0xaa2c..0xaa70 (68 bytes) ====
0x0000aa2c  stp      x20, x19, [sp, #-0x20]!
0x0000aa30  stp      x29, x30, [sp, #0x10]
0x0000aa34  add      x29, sp, #0x10
0x0000aa38  adrp     x8, #0x3e000
0x0000aa3c  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x0000aa40  bl       #0x247e8   ; call _objc_opt_new
0x0000aa44  adrp     x20, #0x3e000
0x0000aa48  ldr      x8, [x20, #0xa30]
0x0000aa4c  str      x0, [x20, #0xa30]
0x0000aa50  mov      x0, x8
0x0000aa54  bl       #0x2480c   ; call _objc_release
0x0000aa58  adrp     x8, #0x3e000
0x0000aa5c  ldr      x0, [x8, #0x318]   ; -> [class(NSMutableArray)]
0x0000aa60  bl       #0x24dc0   ; objc_msgSend: array
0x0000aa64  mov      x29, x29
0x0000aa68  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000aa6c  mov      x19, x0

