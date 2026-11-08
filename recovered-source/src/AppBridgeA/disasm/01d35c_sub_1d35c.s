; ==== sub_1d35c @ 0x1d35c..0x1d608 (684 bytes) ====
0x0001d35c  str      x19, [x20, #0x30]
0x0001d360  ldp      x29, x30, [sp, #0x10]
0x0001d364  ldp      x20, x19, [sp], #0x20
0x0001d368  b        #0x2480c   ; call _objc_release
0x0001d36c  ldr      x0, [x0, #0x38]
0x0001d370  ret      
0x0001d374  stp      x20, x19, [sp, #-0x20]!
0x0001d378  stp      x29, x30, [sp, #0x10]
0x0001d37c  add      x29, sp, #0x10
0x0001d380  mov      x19, x2
0x0001d384  mov      x20, x0
0x0001d388  mov      x0, x2
0x0001d38c  bl       #0x24818   ; call _objc_retain
0x0001d390  ldr      x0, [x20, #0x38]
0x0001d394  str      x19, [x20, #0x38]
0x0001d398  ldp      x29, x30, [sp, #0x10]
0x0001d39c  ldp      x20, x19, [sp], #0x20
0x0001d3a0  b        #0x2480c   ; call _objc_release
0x0001d3a4  ldr      x0, [x0, #0x40]
0x0001d3a8  ret      
0x0001d3ac  stp      x20, x19, [sp, #-0x20]!
0x0001d3b0  stp      x29, x30, [sp, #0x10]
0x0001d3b4  add      x29, sp, #0x10
0x0001d3b8  mov      x19, x2
0x0001d3bc  mov      x20, x0
0x0001d3c0  mov      x0, x2
0x0001d3c4  bl       #0x24818   ; call _objc_retain
0x0001d3c8  ldr      x0, [x20, #0x40]
0x0001d3cc  str      x19, [x20, #0x40]
0x0001d3d0  ldp      x29, x30, [sp, #0x10]
0x0001d3d4  ldp      x20, x19, [sp], #0x20
0x0001d3d8  b        #0x2480c   ; call _objc_release
0x0001d3dc  ldr      x0, [x0, #0x48]
0x0001d3e0  ret      
0x0001d3e4  stp      x20, x19, [sp, #-0x20]!
0x0001d3e8  stp      x29, x30, [sp, #0x10]
0x0001d3ec  add      x29, sp, #0x10
0x0001d3f0  mov      x19, x2
0x0001d3f4  mov      x20, x0
0x0001d3f8  mov      x0, x2
0x0001d3fc  bl       #0x24818   ; call _objc_retain
0x0001d400  ldr      x0, [x20, #0x48]
0x0001d404  str      x19, [x20, #0x48]
0x0001d408  ldp      x29, x30, [sp, #0x10]
0x0001d40c  ldp      x20, x19, [sp], #0x20
0x0001d410  b        #0x2480c   ; call _objc_release
0x0001d414  ldr      x0, [x0, #0x50]
0x0001d418  ret      
0x0001d41c  stp      x20, x19, [sp, #-0x20]!
0x0001d420  stp      x29, x30, [sp, #0x10]
0x0001d424  add      x29, sp, #0x10
0x0001d428  mov      x19, x2
0x0001d42c  mov      x20, x0
0x0001d430  mov      x0, x2
0x0001d434  bl       #0x24818   ; call _objc_retain
0x0001d438  ldr      x0, [x20, #0x50]
0x0001d43c  str      x19, [x20, #0x50]
0x0001d440  ldp      x29, x30, [sp, #0x10]
0x0001d444  ldp      x20, x19, [sp], #0x20
0x0001d448  b        #0x2480c   ; call _objc_release
0x0001d44c  ldr      x0, [x0, #0x58]
0x0001d450  ret      
0x0001d454  stp      x20, x19, [sp, #-0x20]!
0x0001d458  stp      x29, x30, [sp, #0x10]
0x0001d45c  add      x29, sp, #0x10
0x0001d460  mov      x19, x2
0x0001d464  mov      x20, x0
0x0001d468  mov      x0, x2
0x0001d46c  bl       #0x24818   ; call _objc_retain
0x0001d470  ldr      x0, [x20, #0x58]
0x0001d474  str      x19, [x20, #0x58]
0x0001d478  ldp      x29, x30, [sp, #0x10]
0x0001d47c  ldp      x20, x19, [sp], #0x20
0x0001d480  b        #0x2480c   ; call _objc_release
0x0001d484  ldrb     w0, [x0, #8]
0x0001d488  ret      
0x0001d48c  strb     w2, [x0, #8]
0x0001d490  ret      
0x0001d494  ldrb     w0, [x0, #9]
0x0001d498  ret      
0x0001d49c  strb     w2, [x0, #9]
0x0001d4a0  ret      
0x0001d4a4  ldrb     w0, [x0, #0xa]
0x0001d4a8  ret      
0x0001d4ac  strb     w2, [x0, #0xa]
0x0001d4b0  ret      
0x0001d4b4  ldr      x0, [x0, #0x60]
0x0001d4b8  ret      
0x0001d4bc  str      x2, [x0, #0x60]
0x0001d4c0  ret      
0x0001d4c4  ldr      x0, [x0, #0x68]
0x0001d4c8  ret      
0x0001d4cc  stp      x20, x19, [sp, #-0x20]!
0x0001d4d0  stp      x29, x30, [sp, #0x10]
0x0001d4d4  add      x29, sp, #0x10
0x0001d4d8  mov      x19, x2
0x0001d4dc  mov      x20, x0
0x0001d4e0  mov      x0, x2
0x0001d4e4  bl       #0x24818   ; call _objc_retain
0x0001d4e8  ldr      x0, [x20, #0x68]
0x0001d4ec  str      x19, [x20, #0x68]
0x0001d4f0  ldp      x29, x30, [sp, #0x10]
0x0001d4f4  ldp      x20, x19, [sp], #0x20
0x0001d4f8  b        #0x2480c   ; call _objc_release
0x0001d4fc  ldr      x0, [x0, #0x70]
0x0001d500  ret      
0x0001d504  stp      x20, x19, [sp, #-0x20]!
0x0001d508  stp      x29, x30, [sp, #0x10]
0x0001d50c  add      x29, sp, #0x10
0x0001d510  mov      x19, x2
0x0001d514  mov      x20, x0
0x0001d518  mov      x0, x2
0x0001d51c  bl       #0x24818   ; call _objc_retain
0x0001d520  ldr      x0, [x20, #0x70]
0x0001d524  str      x19, [x20, #0x70]
0x0001d528  ldp      x29, x30, [sp, #0x10]
0x0001d52c  ldp      x20, x19, [sp], #0x20
0x0001d530  b        #0x2480c   ; call _objc_release
0x0001d534  stp      x20, x19, [sp, #-0x20]!
0x0001d538  stp      x29, x30, [sp, #0x10]
0x0001d53c  add      x29, sp, #0x10
0x0001d540  mov      x19, x0
0x0001d544  add      x0, x0, #0x70
0x0001d548  mov      x1, #0
0x0001d54c  bl       #0x24860   ; call _objc_storeStrong
0x0001d550  add      x0, x19, #0x68
0x0001d554  mov      x1, #0
0x0001d558  bl       #0x24860   ; call _objc_storeStrong
0x0001d55c  add      x0, x19, #0x58
0x0001d560  mov      x1, #0
0x0001d564  bl       #0x24860   ; call _objc_storeStrong
0x0001d568  add      x0, x19, #0x50
0x0001d56c  mov      x1, #0
0x0001d570  bl       #0x24860   ; call _objc_storeStrong
0x0001d574  add      x0, x19, #0x48
0x0001d578  mov      x1, #0
0x0001d57c  bl       #0x24860   ; call _objc_storeStrong
0x0001d580  add      x0, x19, #0x40
0x0001d584  mov      x1, #0
0x0001d588  bl       #0x24860   ; call _objc_storeStrong
0x0001d58c  add      x0, x19, #0x38
0x0001d590  mov      x1, #0
0x0001d594  bl       #0x24860   ; call _objc_storeStrong
0x0001d598  add      x0, x19, #0x30
0x0001d59c  mov      x1, #0
0x0001d5a0  bl       #0x24860   ; call _objc_storeStrong
0x0001d5a4  add      x0, x19, #0x28
0x0001d5a8  mov      x1, #0
0x0001d5ac  bl       #0x24860   ; call _objc_storeStrong
0x0001d5b0  add      x0, x19, #0x20
0x0001d5b4  mov      x1, #0
0x0001d5b8  bl       #0x24860   ; call _objc_storeStrong
0x0001d5bc  add      x0, x19, #0x18
0x0001d5c0  mov      x1, #0
0x0001d5c4  bl       #0x24860   ; call _objc_storeStrong
0x0001d5c8  add      x0, x19, #0x10
0x0001d5cc  mov      x1, #0
0x0001d5d0  ldp      x29, x30, [sp, #0x10]
0x0001d5d4  ldp      x20, x19, [sp], #0x20
0x0001d5d8  b        #0x24860   ; call _objc_storeStrong
0x0001d5dc  stp      x20, x19, [sp, #-0x20]!
0x0001d5e0  stp      x29, x30, [sp, #0x10]
0x0001d5e4  add      x29, sp, #0x10
0x0001d5e8  adrp     x8, #0x3e000
0x0001d5ec  ldr      x8, [x8, #0xa68]
0x0001d5f0  cmn      x8, #1
0x0001d5f4  b.ne     #0x1d618
0x0001d5f8  adrp     x8, #0x3e000
0x0001d5fc  ldr      x19, [x8, #0xa60]
0x0001d600  mov      x0, x19
0x0001d604  bl       #0x24818   ; call _objc_retain
