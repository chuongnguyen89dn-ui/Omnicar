; ==== sub_16844 @ 0x16844..0x168a4 (96 bytes) ====
0x00016844  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016848  mov      x21, x0
0x0001684c  cmp      x0, x19
0x00016850  csel     x22, xzr, x0, eq
0x00016854  mov      x0, x22
0x00016858  bl       #0x24818   ; call _objc_retain
0x0001685c  mov      x0, x21
0x00016860  bl       #0x2480c   ; call _objc_release
0x00016864  mov      x0, x20
0x00016868  bl       #0x2480c   ; call _objc_release
0x0001686c  mov      x0, x19
0x00016870  bl       #0x2480c   ; call _objc_release
0x00016874  mov      x0, x22
0x00016878  ldp      x29, x30, [sp, #0x40]
0x0001687c  ldp      x20, x19, [sp, #0x30]
0x00016880  ldp      x22, x21, [sp, #0x20]
0x00016884  ldp      d9, d8, [sp, #0x10]
0x00016888  add      sp, sp, #0x50
0x0001688c  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x00016890  b        #0x16894   ; call sub_16894
0x00016894  mov      x21, x0
0x00016898  mov      x0, x20
0x0001689c  bl       #0x2480c   ; call _objc_release
0x000168a0  mov      x0, x19
