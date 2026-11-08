; ==== sub_1d664 @ 0x1d664..0x1d6d0 (108 bytes) ====
0x0001d664  add      x9, x9, #0x658
0x0001d668  str      x9, [x8, #0xa78]
0x0001d66c  ldp      x29, x30, [sp], #0x10
0x0001d670  b        #0x2480c   ; call _objc_release
0x0001d674  adrp     x0, #0x37000
0x0001d678  add      x0, x0, #0x70   ; -> @"com.anlai.omnicar"
0x0001d67c  b        #0x242b4   ; call _CFPreferencesAppSynchronize
0x0001d680  stp      x22, x21, [sp, #-0x30]!
0x0001d684  stp      x20, x19, [sp, #0x10]
0x0001d688  stp      x29, x30, [sp, #0x20]
0x0001d68c  add      x29, sp, #0x20
0x0001d690  mov      x19, x1
0x0001d694  mov      x20, x0
0x0001d698  mov      x0, x1
0x0001d69c  bl       #0x24818   ; call _objc_retain
0x0001d6a0  adrp     x1, #0x37000
0x0001d6a4  add      x1, x1, #0x70   ; -> @"com.anlai.omnicar"
0x0001d6a8  mov      x0, x20
0x0001d6ac  bl       #0x242c0   ; call _CFPreferencesCopyAppValue
0x0001d6b0  mov      x20, x0
0x0001d6b4  cmp      x0, #0
0x0001d6b8  csel     x21, x19, x0, eq
0x0001d6bc  mov      x0, x21
0x0001d6c0  bl       #0x24818   ; call _objc_retain
0x0001d6c4  mov      x0, x19
0x0001d6c8  bl       #0x2480c   ; call _objc_release
0x0001d6cc  mov      x0, x20
