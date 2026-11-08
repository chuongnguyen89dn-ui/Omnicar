; ==== sub_215dc @ 0x215dc..0x21620 (68 bytes) ====
0x000215dc  adrp     x8, #0x37000
0x000215e0  add      x8, x8, #0x310   ; -> @"?"
0x000215e4  csel     x8, x8, x0, eq
0x000215e8  stp      x21, x8, [sp]
0x000215ec  mov      x0, x20
0x000215f0  adrp     x2, #0x38000
0x000215f4  add      x2, x2, #0x8b0   ; -> @"%@|%@"
0x000215f8  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x000215fc  mov      x29, x29
0x00021600  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021604  str      x0, [sp, #0x58]
0x00021608  mov      x0, x19
0x0002160c  bl       #0x2480c   ; call _objc_release
0x00021610  adrp     x8, #0x3e000
0x00021614  ldr      x0, [x8, #0x398]   ; -> [class(NSMutableDictionary)]
0x00021618  bl       #0x25580   ; objc_msgSend: dictionary
0x0002161c  mov      x29, x29
