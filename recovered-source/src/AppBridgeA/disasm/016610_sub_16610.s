; ==== sub_16610 @ 0x16610..0x167cc (444 bytes) ====
0x00016610  ldr      x9, [x9]
0x00016614  cmp      x9, x8
0x00016618  b.ne     #0x16634
0x0001661c  ldp      x29, x30, [sp, #0x110]
0x00016620  ldp      x20, x19, [sp, #0x100]
0x00016624  ldp      x22, x21, [sp, #0xf0]
0x00016628  ldp      x24, x23, [sp, #0xe0]
0x0001662c  add      sp, sp, #0x120
0x00016630  ret      
0x00016634  bl       #0x24488   ; call ___stack_chk_fail
0x00016638  mov      x19, x0
0x0001663c  mov      x0, x20
0x00016640  bl       #0x2480c   ; call _objc_release
0x00016644  b        #0x166ac   ; call sub_166ac
0x00016648  mov      x19, x0
0x0001664c  mov      x0, x20
0x00016650  bl       #0x2480c   ; call _objc_release
0x00016654  b        #0x166ac   ; call sub_166ac
0x00016658  b        #0x16698   ; call sub_16698
0x0001665c  mov      x19, x0
0x00016660  mov      x0, x21
0x00016664  b        #0x1668c   ; call sub_1668c
0x00016668  mov      x19, x0
0x0001666c  mov      x0, x21
0x00016670  bl       #0x2480c   ; call _objc_release
0x00016674  b        #0x16688   ; call sub_16688
0x00016678  b        #0x16684   ; call sub_16684
0x0001667c  b        #0x16684   ; call sub_16684
0x00016680  b        #0x16684   ; call sub_16684
0x00016684  mov      x19, x0
0x00016688  mov      x0, x20
0x0001668c  bl       #0x2480c   ; call _objc_release
0x00016690  b        #0x166ac   ; call sub_166ac
0x00016694  b        #0x16698   ; call sub_16698
0x00016698  mov      x19, x0
0x0001669c  mov      x0, x20
0x000166a0  bl       #0x2480c   ; call _objc_release
0x000166a4  b        #0x166ac   ; call sub_166ac
0x000166a8  mov      x19, x0
0x000166ac  mov      x0, x19
0x000166b0  bl       #0x24470   ; call __Unwind_Resume
0x000166b4  ldp      d0, d1, [x0, #0x30]
0x000166b8  ldp      d2, d3, [x0, #0x40]
0x000166bc  ret      
0x000166c0  stp      d0, d1, [x0, #0x30]
0x000166c4  stp      d2, d3, [x0, #0x40]
0x000166c8  ret      
0x000166cc  ldr      x0, [x0, #0x10]
0x000166d0  ret      
0x000166d4  stp      x20, x19, [sp, #-0x20]!
0x000166d8  stp      x29, x30, [sp, #0x10]
0x000166dc  add      x29, sp, #0x10
0x000166e0  mov      x19, x2
0x000166e4  mov      x20, x0
0x000166e8  mov      x0, x2
0x000166ec  bl       #0x24818   ; call _objc_retain
0x000166f0  ldr      x0, [x20, #0x10]
0x000166f4  str      x19, [x20, #0x10]
0x000166f8  ldp      x29, x30, [sp, #0x10]
0x000166fc  ldp      x20, x19, [sp], #0x20
0x00016700  b        #0x2480c   ; call _objc_release
0x00016704  ldrb     w0, [x0, #8]
0x00016708  ret      
0x0001670c  strb     w2, [x0, #8]
0x00016710  ret      
0x00016714  ldr      x0, [x0, #0x18]
0x00016718  ret      
0x0001671c  mov      w3, #0x18
0x00016720  b        #0x24854   ; call _objc_setProperty_nonatomic_copy
0x00016724  ldr      x0, [x0, #0x20]
0x00016728  ret      
0x0001672c  stp      x20, x19, [sp, #-0x20]!
0x00016730  stp      x29, x30, [sp, #0x10]
0x00016734  add      x29, sp, #0x10
0x00016738  mov      x19, x2
0x0001673c  mov      x20, x0
0x00016740  mov      x0, x2
0x00016744  bl       #0x24818   ; call _objc_retain
0x00016748  ldr      x0, [x20, #0x20]
0x0001674c  str      x19, [x20, #0x20]
0x00016750  ldp      x29, x30, [sp, #0x10]
0x00016754  ldp      x20, x19, [sp], #0x20
0x00016758  b        #0x2480c   ; call _objc_release
0x0001675c  ldr      x0, [x0, #0x28]
0x00016760  ret      
0x00016764  stp      x20, x19, [sp, #-0x20]!
0x00016768  stp      x29, x30, [sp, #0x10]
0x0001676c  add      x29, sp, #0x10
0x00016770  mov      x19, x2
0x00016774  mov      x20, x0
0x00016778  mov      x0, x2
0x0001677c  bl       #0x24818   ; call _objc_retain
0x00016780  ldr      x0, [x20, #0x28]
0x00016784  str      x19, [x20, #0x28]
0x00016788  ldp      x29, x30, [sp, #0x10]
0x0001678c  ldp      x20, x19, [sp], #0x20
0x00016790  b        #0x2480c   ; call _objc_release
0x00016794  stp      x20, x19, [sp, #-0x20]!
0x00016798  stp      x29, x30, [sp, #0x10]
0x0001679c  add      x29, sp, #0x10
0x000167a0  mov      x19, x0
0x000167a4  add      x0, x0, #0x28
0x000167a8  mov      x1, #0
0x000167ac  bl       #0x24860   ; call _objc_storeStrong
0x000167b0  add      x0, x19, #0x20
0x000167b4  mov      x1, #0
0x000167b8  bl       #0x24860   ; call _objc_storeStrong
0x000167bc  add      x0, x19, #0x18
0x000167c0  mov      x1, #0
0x000167c4  bl       #0x24860   ; call _objc_storeStrong
0x000167c8  add      x0, x19, #0x10
