; ==== sub_214cc @ 0x214cc..0x214fc (48 bytes) ====
0x000214cc  mov      x0, x21
0x000214d0  bl       #0x2480c   ; call _objc_release
0x000214d4  mov      x0, x20
0x000214d8  bl       #0x2480c   ; call _objc_release
0x000214dc  mov      x0, x19
0x000214e0  bl       #0x2480c   ; call _objc_release
0x000214e4  adrp     x0, #0x37000
0x000214e8  add      x0, x0, #0x930   ; -> @"diagCar"
0x000214ec  ldr      x1, [sp, #0x78]
0x000214f0  adrp     x2, #0x37000
0x000214f4  add      x2, x2, #0x70   ; -> @"com.anlai.omnicar"
0x000214f8  bl       #0x242cc   ; call _CFPreferencesSetAppValue
