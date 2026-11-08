; ==== sub_1a72c @ 0x1a72c..0x1a75c (48 bytes) ====
0x0001a72c  ldr      x0, [x21, #0x3e0]
0x0001a730  adrp     x8, #0x34000
0x0001a734  ldr      x8, [x8, #0x230]   ; -> [got:_UIFontWeightSemibold]
0x0001a738  ldr      d1, [x8]   ; -> [got:___objc_personality_v0]
0x0001a73c  fmov     d0, #10.50000000
0x0001a740  bl       #0x27e80   ; objc_msgSend: systemFontOfSize:weight:
0x0001a744  mov      x29, x29
0x0001a748  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a74c  mov      x26, x0
0x0001a750  mov      x0, x25
0x0001a754  bl       #0x27fc0   ; objc_msgSend: titleLabel
0x0001a758  mov      x29, x29
