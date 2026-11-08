; block literal @0x34b40 desc @0x34610 sig=v8@?0 flags=0x50000000
; ==== sub_1d620 @ 0x1d620..0x1d638 (24 bytes) ====
0x0001d620  adrp     x8, #0x3e000
0x0001d624  ldr      x0, [x8, #0xa60]
0x0001d628  adrp     x9, #0x39000
0x0001d62c  add      x9, x9, #0x498
0x0001d630  str      x9, [x8, #0xa60]
0x0001d634  b        #0x2480c   ; call _objc_release

