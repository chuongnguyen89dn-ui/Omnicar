; ==== sub_21620 @ 0x21620..0x21638 (24 bytes) ====
0x00021620  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021624  mov      x19, x0
0x00021628  adrp     x0, #0x38000
0x0002162c  add      x0, x0, #0x8d0   ; -> @"carProfiles"
0x00021630  mov      x1, #0
0x00021634  bl       #0x1d680   ; call _OMCPref
