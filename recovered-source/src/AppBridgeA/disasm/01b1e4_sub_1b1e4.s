; ==== sub_1b1e4 @ 0x1b1e4..0x1b494 (688 bytes) ====
0x0001b1e4  mov      x0, x23
0x0001b1e8  bl       #0x27fc0   ; objc_msgSend: titleLabel
0x0001b1ec  mov      x29, x29
0x0001b1f0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b1f4  mov      x27, x0
0x0001b1f8  mov      x2, x26
0x0001b1fc  bl       #0x26f60   ; objc_msgSend: setFont:
0x0001b200  mov      x0, x27
0x0001b204  bl       #0x2480c   ; call _objc_release
0x0001b208  cbz      w24, #0x1b2b4
0x0001b20c  mov      x0, x26
0x0001b210  bl       #0x2480c   ; call _objc_release
0x0001b214  cbnz     w19, #0x1b2b8
0x0001b218  cbz      w25, #0x1b224
0x0001b21c  mov      x0, x26
0x0001b220  bl       #0x2480c   ; call _objc_release
0x0001b224  mov      x0, x23
0x0001b228  bl       #0x27fc0   ; objc_msgSend: titleLabel
0x0001b22c  mov      x29, x29
0x0001b230  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b234  mov      x25, x0
0x0001b238  mov      w2, #1
0x0001b23c  bl       #0x26b20   ; objc_msgSend: setAdjustsFontSizeToFitWidth:
0x0001b240  mov      x0, x25
0x0001b244  bl       #0x2480c   ; call _objc_release
0x0001b248  mov      x0, x23
0x0001b24c  mov      w2, #0
0x0001b250  bl       #0x26500   ; objc_msgSend: paint:
0x0001b254  adrp     x8, #0x3d000
0x0001b258  ldr      x3, [x8, #0x7c0]   ; -> [@selector(keyTapped:)]
0x0001b25c  mov      x0, x23
0x0001b260  ldr      x2, [sp, #0x10]
0x0001b264  mov      w4, #0x40
0x0001b268  bl       #0x24bc0   ; objc_msgSend: addTarget:action:forControlEvents:
0x0001b26c  mov      x0, x22
0x0001b270  bl       #0x2480c   ; call _objc_release
0x0001b274  ldr      x0, [sp, #8]
0x0001b278  bl       #0x2480c   ; call _objc_release
0x0001b27c  ldr      x0, [sp, #0x18]
0x0001b280  bl       #0x2480c   ; call _objc_release
0x0001b284  mov      x0, x21
0x0001b288  bl       #0x2480c   ; call _objc_release
0x0001b28c  mov      x0, x23
0x0001b290  ldp      x29, x30, [sp, #0x80]
0x0001b294  ldp      x20, x19, [sp, #0x70]
0x0001b298  ldp      x22, x21, [sp, #0x60]
0x0001b29c  ldp      x24, x23, [sp, #0x50]
0x0001b2a0  ldp      x26, x25, [sp, #0x40]
0x0001b2a4  ldp      x28, x27, [sp, #0x30]
0x0001b2a8  ldp      d9, d8, [sp, #0x20]
0x0001b2ac  add      sp, sp, #0x90
0x0001b2b0  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x0001b2b4  cbz      w19, #0x1b218
0x0001b2b8  mov      x0, x26
0x0001b2bc  bl       #0x2480c   ; call _objc_release
0x0001b2c0  cbnz     w25, #0x1b21c
0x0001b2c4  b        #0x1b224   ; call sub_1b224
0x0001b2c8  b        #0x1b3d4   ; call sub_1b3d4
0x0001b2cc  b        #0x1b3d4   ; call sub_1b3d4
0x0001b2d0  b        #0x1b3d4   ; call sub_1b3d4
0x0001b2d4  b        #0x1b3d4   ; call sub_1b3d4
0x0001b2d8  b        #0x1b3d4   ; call sub_1b3d4
0x0001b2dc  b        #0x1b36c   ; call sub_1b36c
0x0001b2e0  b        #0x1b36c   ; call sub_1b36c
0x0001b2e4  b        #0x1b36c   ; call sub_1b36c
0x0001b2e8  b        #0x1b2f8   ; call sub_1b2f8
0x0001b2ec  b        #0x1b2f8   ; call sub_1b2f8
0x0001b2f0  b        #0x1b380   ; call sub_1b380
0x0001b2f4  b        #0x1b3d4   ; call sub_1b3d4
0x0001b2f8  str      x0, [sp, #0x10]
0x0001b2fc  mov      x0, x27
0x0001b300  bl       #0x2480c   ; call _objc_release
0x0001b304  b        #0x1b370   ; call sub_1b370
0x0001b308  b        #0x1b36c   ; call sub_1b36c
0x0001b30c  b        #0x1b3d4   ; call sub_1b3d4
0x0001b310  b        #0x1b3d4   ; call sub_1b3d4
0x0001b314  str      x0, [sp, #0x10]
0x0001b318  mov      x0, x25
0x0001b31c  b        #0x1b388   ; call sub_1b388
0x0001b320  str      x0, [sp, #0x10]
0x0001b324  mov      x0, x27
0x0001b328  bl       #0x2480c   ; call _objc_release
0x0001b32c  b        #0x1b334   ; call sub_1b334
0x0001b330  str      x0, [sp, #0x10]
0x0001b334  cbz      w24, #0x1b354
0x0001b338  mov      x0, x26
0x0001b33c  bl       #0x2480c   ; call _objc_release
0x0001b340  tbnz     w19, #0, #0x1b358
0x0001b344  cbnz     w25, #0x1b370
0x0001b348  b        #0x1b3d8   ; call sub_1b3d8
0x0001b34c  str      x0, [sp, #0x10]
0x0001b350  cbnz     w20, #0x1b338
0x0001b354  cbz      w19, #0x1b344
0x0001b358  mov      x0, x26
0x0001b35c  bl       #0x2480c   ; call _objc_release
0x0001b360  tbnz     w25, #0, #0x1b370
0x0001b364  b        #0x1b3d8   ; call sub_1b3d8
0x0001b368  b        #0x1b36c   ; call sub_1b36c
0x0001b36c  str      x0, [sp, #0x10]
0x0001b370  mov      x0, x26
0x0001b374  b        #0x1b388   ; call sub_1b388
0x0001b378  b        #0x1b380   ; call sub_1b380
0x0001b37c  b        #0x1b380   ; call sub_1b380
0x0001b380  str      x0, [sp, #0x10]
0x0001b384  mov      x0, x27
0x0001b388  bl       #0x2480c   ; call _objc_release
0x0001b38c  b        #0x1b3d8   ; call sub_1b3d8
0x0001b390  str      x0, [sp, #0x10]
0x0001b394  cbz      w20, #0x1b3a8
0x0001b398  mov      x0, x28
0x0001b39c  bl       #0x2480c   ; call _objc_release
0x0001b3a0  tbnz     w21, #0, #0x1b3ac
0x0001b3a4  b        #0x1b3b4   ; call sub_1b3b4
0x0001b3a8  cbz      w21, #0x1b3b4
0x0001b3ac  mov      x0, x28
0x0001b3b0  bl       #0x2480c   ; call _objc_release
0x0001b3b4  tbnz     w24, #0, #0x1b3d8
0x0001b3b8  mov      x0, x28
0x0001b3bc  b        #0x1b388   ; call sub_1b388
0x0001b3c0  b        #0x1b3d4   ; call sub_1b3d4
0x0001b3c4  b        #0x1b3d4   ; call sub_1b3d4
0x0001b3c8  str      x0, [sp, #0x10]
0x0001b3cc  b        #0x1b3e0   ; call sub_1b3e0
0x0001b3d0  b        #0x1b3d4   ; call sub_1b3d4
0x0001b3d4  str      x0, [sp, #0x10]
0x0001b3d8  mov      x0, x23
0x0001b3dc  bl       #0x2480c   ; call _objc_release
0x0001b3e0  mov      x0, x22
0x0001b3e4  bl       #0x2480c   ; call _objc_release
0x0001b3e8  ldr      x0, [sp, #8]
0x0001b3ec  bl       #0x2480c   ; call _objc_release
0x0001b3f0  ldr      x0, [sp, #0x18]
0x0001b3f4  bl       #0x2480c   ; call _objc_release
0x0001b3f8  ldr      x0, [sp]
0x0001b3fc  bl       #0x2480c   ; call _objc_release
0x0001b400  ldr      x0, [sp, #0x10]
0x0001b404  bl       #0x24470   ; call __Unwind_Resume
0x0001b408  stp      x29, x30, [sp, #-0x10]!
0x0001b40c  mov      x29, sp
0x0001b410  mov      x5, x4
0x0001b414  mov      x4, x3
0x0001b418  mov      x3, #0
0x0001b41c  bl       #0x25dc0   ; objc_msgSend: key:symbol:value:command:weight:
0x0001b420  mov      x29, x29
0x0001b424  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b428  ldp      x29, x30, [sp], #0x10
0x0001b42c  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x0001b430  stp      d11, d10, [sp, #-0x80]!
0x0001b434  stp      d9, d8, [sp, #0x10]
0x0001b438  stp      x28, x27, [sp, #0x20]
0x0001b43c  stp      x26, x25, [sp, #0x30]
0x0001b440  stp      x24, x23, [sp, #0x40]
0x0001b444  stp      x22, x21, [sp, #0x50]
0x0001b448  stp      x20, x19, [sp, #0x60]
0x0001b44c  stp      x29, x30, [sp, #0x70]
0x0001b450  add      x29, sp, #0x70
0x0001b454  sub      sp, sp, #0x2b0
0x0001b458  mov      x20, x0
0x0001b45c  adrp     x8, #0x34000
0x0001b460  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0001b464  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0001b468  stur     x8, [x29, #-0x80]
0x0001b46c  movi     v0.16b, #0
0x0001b470  stp      q0, q0, [sp, #0xb0]
0x0001b474  stp      q0, q0, [sp, #0xd0]
0x0001b478  bl       #0x25e40   ; objc_msgSend: keysView
0x0001b47c  mov      x29, x29
0x0001b480  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b484  mov      x21, x0
0x0001b488  bl       #0x27e00   ; objc_msgSend: subviews
0x0001b48c  mov      x29, x29
0x0001b490  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
