; ==== sub_d58c @ 0xd58c..0xd688 (252 bytes) ====
0x0000d58c  bl       #0x2480c   ; call _objc_release
0x0000d590  ldr      x0, [sp, #0x68]
0x0000d594  bl       #0x2480c   ; call _objc_release
0x0000d598  ldr      x0, [sp, #0x70]
0x0000d59c  bl       #0x2480c   ; call _objc_release
0x0000d5a0  ldr      x0, [sp, #0x40]
0x0000d5a4  bl       #0x2480c   ; call _objc_release
0x0000d5a8  ldr      x0, [sp, #0x48]
0x0000d5ac  bl       #0x2480c   ; call _objc_release
0x0000d5b0  ldr      x0, [sp, #0x50]
0x0000d5b4  bl       #0x2480c   ; call _objc_release
0x0000d5b8  ldr      x0, [sp, #0x58]
0x0000d5bc  bl       #0x2480c   ; call _objc_release
0x0000d5c0  ldr      x0, [sp, #0x38]
0x0000d5c4  bl       #0x2480c   ; call _objc_release
0x0000d5c8  mov      x0, x21
0x0000d5cc  bl       #0x2480c   ; call _objc_release
0x0000d5d0  ldr      x0, [sp, #0x60]
0x0000d5d4  bl       #0x2480c   ; call _objc_release
0x0000d5d8  ldr      x0, [sp, #0x80]
0x0000d5dc  bl       #0x2480c   ; call _objc_release
0x0000d5e0  ldp      x29, x30, [sp, #0x130]
0x0000d5e4  ldp      x20, x19, [sp, #0x120]
0x0000d5e8  ldp      x22, x21, [sp, #0x110]
0x0000d5ec  ldp      x24, x23, [sp, #0x100]
0x0000d5f0  ldp      x26, x25, [sp, #0xf0]
0x0000d5f4  ldp      x28, x27, [sp, #0xe0]
0x0000d5f8  add      sp, sp, #0x140
0x0000d5fc  ret      
0x0000d600  b        #0xd76c   ; call sub_d76c
0x0000d604  b        #0xd778   ; call sub_d778
0x0000d608  b        #0xd7c8   ; call sub_d7c8
0x0000d60c  str      x0, [sp, #0x30]
0x0000d610  mov      x0, x25
0x0000d614  b        #0xd704   ; call sub_d704
0x0000d618  b        #0xd6fc   ; call sub_d6fc
0x0000d61c  b        #0xd76c   ; call sub_d76c
0x0000d620  b        #0xd778   ; call sub_d778
0x0000d624  str      x0, [sp, #0x30]
0x0000d628  add      x0, x23, #0x38
0x0000d62c  bl       #0x24758   ; call _objc_destroyWeak
0x0000d630  add      x0, x23, #0x30
0x0000d634  bl       #0x24758   ; call _objc_destroyWeak
0x0000d638  ldr      x0, [sp, #0xb0]
0x0000d63c  bl       #0x2480c   ; call _objc_release
0x0000d640  ldr      x0, [sp, #0xa8]
0x0000d644  bl       #0x2480c   ; call _objc_release
0x0000d648  b        #0xd908   ; call sub_d908
0x0000d64c  str      x0, [sp, #0x30]
0x0000d650  mov      x0, x23
0x0000d654  bl       #0x2480c   ; call _objc_release
0x0000d658  b        #0xd84c   ; call sub_d84c
0x0000d65c  b        #0xd6fc   ; call sub_d6fc
0x0000d660  b        #0xd7c8   ; call sub_d7c8
0x0000d664  b        #0xd7bc   ; call sub_d7bc
0x0000d668  str      x0, [sp, #0x30]
0x0000d66c  mov      x0, x19
0x0000d670  bl       #0x2480c   ; call _objc_release
0x0000d674  b        #0xd8d4   ; call sub_d8d4
0x0000d678  str      x0, [sp, #0x30]
0x0000d67c  mov      x0, x19
0x0000d680  bl       #0x2480c   ; call _objc_release
0x0000d684  b        #0xd87c   ; call sub_d87c
