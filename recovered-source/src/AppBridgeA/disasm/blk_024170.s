; block literal @0x34db0 desc @0x34610 sig=v8@?0 flags=0x50000000
; ==== sub_24170 @ 0x24170..0x24184 (20 bytes) ====
0x00024170  stp      x29, x30, [sp, #-0x10]!
0x00024174  mov      x29, sp
0x00024178  adrp     x8, #0x3e000
0x0002417c  ldr      x0, [x8, #0x398]   ; -> [class(NSMutableDictionary)]
0x00024180  bl       #0x25580   ; objc_msgSend: dictionary

