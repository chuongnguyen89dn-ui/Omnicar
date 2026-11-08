; ==== sub_21504 @ 0x21504..0x21534 (48 bytes) ====
0x00021504  bl       #0x242b4   ; call _CFPreferencesAppSynchronize
0x00021508  ldr      x0, [sp, #0x78]
0x0002150c  bl       #0x24818   ; call _objc_retain
0x00021510  adrp     x0, #0x37000
0x00021514  add      x0, x0, #0x70   ; -> @"com.anlai.omnicar"
0x00021518  bl       #0x242b4   ; call _CFPreferencesAppSynchronize
0x0002151c  adrp     x0, #0x38000
0x00021520  add      x0, x0, #0x750   ; -> @"carProfilesEnabled"
0x00021524  adrp     x1, #0x34000
0x00021528  ldr      x1, [x1, #0x200]   ; -> [got:___kCFBooleanFalse]
0x0002152c  bl       #0x1d680   ; call _OMCPref
0x00021530  mov      x29, x29
