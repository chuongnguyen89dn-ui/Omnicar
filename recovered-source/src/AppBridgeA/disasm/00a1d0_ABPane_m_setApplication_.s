; ==== ABPane_m_setApplication_ @ 0xa1d0..0xa498 (712 bytes) ====
0x0000a1d0  stp      x20, x19, [sp, #-0x20]!
0x0000a1d4  stp      x29, x30, [sp, #0x10]
0x0000a1d8  add      x29, sp, #0x10
0x0000a1dc  mov      x19, x2
0x0000a1e0  mov      x20, x0
0x0000a1e4  mov      x0, x2
0x0000a1e8  bl       #0x24818   ; call _objc_retain
0x0000a1ec  ldr      x0, [x20, #0x20]
0x0000a1f0  str      x19, [x20, #0x20]
0x0000a1f4  ldp      x29, x30, [sp, #0x10]
0x0000a1f8  ldp      x20, x19, [sp], #0x20
0x0000a1fc  b        #0x2480c   ; call _objc_release
0x0000a200  ldr      x0, [x0, #0x28]
0x0000a204  ret      
0x0000a208  stp      x20, x19, [sp, #-0x20]!
0x0000a20c  stp      x29, x30, [sp, #0x10]
0x0000a210  add      x29, sp, #0x10
0x0000a214  mov      x19, x2
0x0000a218  mov      x20, x0
0x0000a21c  mov      x0, x2
0x0000a220  bl       #0x24818   ; call _objc_retain
0x0000a224  ldr      x0, [x20, #0x28]
0x0000a228  str      x19, [x20, #0x28]
0x0000a22c  ldp      x29, x30, [sp, #0x10]
0x0000a230  ldp      x20, x19, [sp], #0x20
0x0000a234  b        #0x2480c   ; call _objc_release
0x0000a238  ldr      x0, [x0, #0x30]
0x0000a23c  ret      
0x0000a240  stp      x20, x19, [sp, #-0x20]!
0x0000a244  stp      x29, x30, [sp, #0x10]
0x0000a248  add      x29, sp, #0x10
0x0000a24c  mov      x19, x2
0x0000a250  mov      x20, x0
0x0000a254  mov      x0, x2
0x0000a258  bl       #0x24818   ; call _objc_retain
0x0000a25c  ldr      x0, [x20, #0x30]
0x0000a260  str      x19, [x20, #0x30]
0x0000a264  ldp      x29, x30, [sp, #0x10]
0x0000a268  ldp      x20, x19, [sp], #0x20
0x0000a26c  b        #0x2480c   ; call _objc_release
0x0000a270  ldr      x0, [x0, #0x38]
0x0000a274  ret      
0x0000a278  str      x2, [x0, #0x38]
0x0000a27c  ret      
0x0000a280  ldr      x0, [x0, #0x40]
0x0000a284  ret      
0x0000a288  str      x2, [x0, #0x40]
0x0000a28c  ret      
0x0000a290  ldp      d0, d1, [x0, #0x90]
0x0000a294  ldp      d2, d3, [x0, #0xa0]
0x0000a298  ret      
0x0000a29c  stp      d0, d1, [x0, #0x90]
0x0000a2a0  stp      d2, d3, [x0, #0xa0]
0x0000a2a4  ret      
0x0000a2a8  ldp      d0, d1, [x0, #0x80]
0x0000a2ac  ret      
0x0000a2b0  stp      d0, d1, [x0, #0x80]
0x0000a2b4  ret      
0x0000a2b8  ldrb     w0, [x0, #8]
0x0000a2bc  ret      
0x0000a2c0  strb     w2, [x0, #8]
0x0000a2c4  ret      
0x0000a2c8  ldr      x0, [x0, #0x48]
0x0000a2cc  ret      
0x0000a2d0  stp      x20, x19, [sp, #-0x20]!
0x0000a2d4  stp      x29, x30, [sp, #0x10]
0x0000a2d8  add      x29, sp, #0x10
0x0000a2dc  mov      x19, x2
0x0000a2e0  mov      x20, x0
0x0000a2e4  mov      x0, x2
0x0000a2e8  bl       #0x24818   ; call _objc_retain
0x0000a2ec  ldr      x0, [x20, #0x48]
0x0000a2f0  str      x19, [x20, #0x48]
0x0000a2f4  ldp      x29, x30, [sp, #0x10]
0x0000a2f8  ldp      x20, x19, [sp], #0x20
0x0000a2fc  b        #0x2480c   ; call _objc_release
0x0000a300  ldr      x0, [x0, #0x50]
0x0000a304  ret      
0x0000a308  stp      x20, x19, [sp, #-0x20]!
0x0000a30c  stp      x29, x30, [sp, #0x10]
0x0000a310  add      x29, sp, #0x10
0x0000a314  mov      x19, x2
0x0000a318  mov      x20, x0
0x0000a31c  mov      x0, x2
0x0000a320  bl       #0x24818   ; call _objc_retain
0x0000a324  ldr      x0, [x20, #0x50]
0x0000a328  str      x19, [x20, #0x50]
0x0000a32c  ldp      x29, x30, [sp, #0x10]
0x0000a330  ldp      x20, x19, [sp], #0x20
0x0000a334  b        #0x2480c   ; call _objc_release
0x0000a338  ldr      x0, [x0, #0x58]
0x0000a33c  ret      
0x0000a340  stp      x20, x19, [sp, #-0x20]!
0x0000a344  stp      x29, x30, [sp, #0x10]
0x0000a348  add      x29, sp, #0x10
0x0000a34c  mov      x19, x2
0x0000a350  mov      x20, x0
0x0000a354  mov      x0, x2
0x0000a358  bl       #0x24818   ; call _objc_retain
0x0000a35c  ldr      x0, [x20, #0x58]
0x0000a360  str      x19, [x20, #0x58]
0x0000a364  ldp      x29, x30, [sp, #0x10]
0x0000a368  ldp      x20, x19, [sp], #0x20
0x0000a36c  b        #0x2480c   ; call _objc_release
0x0000a370  ldr      x0, [x0, #0x60]
0x0000a374  ret      
0x0000a378  stp      x20, x19, [sp, #-0x20]!
0x0000a37c  stp      x29, x30, [sp, #0x10]
0x0000a380  add      x29, sp, #0x10
0x0000a384  mov      x19, x2
0x0000a388  mov      x20, x0
0x0000a38c  mov      x0, x2
0x0000a390  bl       #0x24818   ; call _objc_retain
0x0000a394  ldr      x0, [x20, #0x60]
0x0000a398  str      x19, [x20, #0x60]
0x0000a39c  ldp      x29, x30, [sp, #0x10]
0x0000a3a0  ldp      x20, x19, [sp], #0x20
0x0000a3a4  b        #0x2480c   ; call _objc_release
0x0000a3a8  ldr      x0, [x0, #0x68]
0x0000a3ac  ret      
0x0000a3b0  stp      x20, x19, [sp, #-0x20]!
0x0000a3b4  stp      x29, x30, [sp, #0x10]
0x0000a3b8  add      x29, sp, #0x10
0x0000a3bc  mov      x19, x2
0x0000a3c0  mov      x20, x0
0x0000a3c4  mov      x0, x2
0x0000a3c8  bl       #0x24818   ; call _objc_retain
0x0000a3cc  ldr      x0, [x20, #0x68]
0x0000a3d0  str      x19, [x20, #0x68]
0x0000a3d4  ldp      x29, x30, [sp, #0x10]
0x0000a3d8  ldp      x20, x19, [sp], #0x20
0x0000a3dc  b        #0x2480c   ; call _objc_release
0x0000a3e0  ldr      d0, [x0, #0x70]
0x0000a3e4  ret      
0x0000a3e8  str      d0, [x0, #0x70]
0x0000a3ec  ret      
0x0000a3f0  ldr      x0, [x0, #0x78]
0x0000a3f4  ret      
0x0000a3f8  stp      x20, x19, [sp, #-0x20]!
0x0000a3fc  stp      x29, x30, [sp, #0x10]
0x0000a400  add      x29, sp, #0x10
0x0000a404  mov      x19, x2
0x0000a408  mov      x20, x0
0x0000a40c  mov      x0, x2
0x0000a410  bl       #0x24818   ; call _objc_retain
0x0000a414  ldr      x0, [x20, #0x78]
0x0000a418  str      x19, [x20, #0x78]
0x0000a41c  ldp      x29, x30, [sp, #0x10]
0x0000a420  ldp      x20, x19, [sp], #0x20
0x0000a424  b        #0x2480c   ; call _objc_release
0x0000a428  stp      x20, x19, [sp, #-0x20]!
0x0000a42c  stp      x29, x30, [sp, #0x10]
0x0000a430  add      x29, sp, #0x10
0x0000a434  mov      x19, x0
0x0000a438  add      x0, x0, #0x78
0x0000a43c  mov      x1, #0
0x0000a440  bl       #0x24860   ; call _objc_storeStrong
0x0000a444  add      x0, x19, #0x68
0x0000a448  mov      x1, #0
0x0000a44c  bl       #0x24860   ; call _objc_storeStrong
0x0000a450  add      x0, x19, #0x60
0x0000a454  mov      x1, #0
0x0000a458  bl       #0x24860   ; call _objc_storeStrong
0x0000a45c  add      x0, x19, #0x58
0x0000a460  mov      x1, #0
0x0000a464  bl       #0x24860   ; call _objc_storeStrong
0x0000a468  add      x0, x19, #0x50
0x0000a46c  mov      x1, #0
0x0000a470  bl       #0x24860   ; call _objc_storeStrong
0x0000a474  add      x0, x19, #0x48
0x0000a478  mov      x1, #0
0x0000a47c  bl       #0x24860   ; call _objc_storeStrong
0x0000a480  add      x0, x19, #0x30
0x0000a484  mov      x1, #0
0x0000a488  bl       #0x24860   ; call _objc_storeStrong
0x0000a48c  add      x0, x19, #0x28
0x0000a490  mov      x1, #0
0x0000a494  bl       #0x24860   ; call _objc_storeStrong
