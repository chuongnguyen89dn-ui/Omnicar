; ==== sub_139ac @ 0x139ac..0x13d98 (1004 bytes) ====
0x000139ac  mov      x0, x22
0x000139b0  bl       #0x27e20   ; objc_msgSend: superview
0x000139b4  mov      x29, x29
0x000139b8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000139bc  mov      x23, x0
0x000139c0  mov      x0, x20
0x000139c4  bl       #0x281e0   ; objc_msgSend: window
0x000139c8  mov      x29, x29
0x000139cc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000139d0  cmp      x23, x0
0x000139d4  cset     w26, eq
0x000139d8  bl       #0x2480c   ; call _objc_release
0x000139dc  mov      x0, x23
0x000139e0  bl       #0x2480c   ; call _objc_release
0x000139e4  cbz      w26, #0x13a0c
0x000139e8  mov      x0, x20
0x000139ec  bl       #0x281e0   ; objc_msgSend: window
0x000139f0  mov      x29, x29
0x000139f4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000139f8  mov      x23, x0
0x000139fc  mov      x2, x22
0x00013a00  bl       #0x24f80   ; objc_msgSend: bringSubviewToFront:
0x00013a04  mov      x0, x23
0x00013a08  bl       #0x2480c   ; call _objc_release
0x00013a0c  add      x25, x25, #1
0x00013a10  cmp      x21, x25
0x00013a14  b.ne     #0x1398c
0x00013a18  mov      x2, sp
0x00013a1c  add      x3, sp, #0x48
0x00013a20  mov      x0, x19
0x00013a24  mov      w4, #0x10
0x00013a28  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00013a2c  mov      x21, x0
0x00013a30  cbnz     x0, #0x13988
0x00013a34  mov      x0, x19
0x00013a38  bl       #0x2480c   ; call _objc_release
0x00013a3c  ldur     x8, [x29, #-0x58]
0x00013a40  adrp     x9, #0x34000
0x00013a44  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00013a48  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x00013a4c  cmp      x9, x8
0x00013a50  b.ne     #0x13a74
0x00013a54  ldp      x29, x30, [sp, #0x120]
0x00013a58  ldp      x20, x19, [sp, #0x110]
0x00013a5c  ldp      x22, x21, [sp, #0x100]
0x00013a60  ldp      x24, x23, [sp, #0xf0]
0x00013a64  ldp      x26, x25, [sp, #0xe0]
0x00013a68  ldp      x28, x27, [sp, #0xd0]
0x00013a6c  add      sp, sp, #0x130
0x00013a70  ret      
0x00013a74  bl       #0x24488   ; call ___stack_chk_fail
0x00013a78  b        #0x13aa0   ; call sub_13aa0
0x00013a7c  b        #0x13aa0   ; call sub_13aa0
0x00013a80  mov      x20, x0
0x00013a84  mov      x0, x23
0x00013a88  bl       #0x2480c   ; call _objc_release
0x00013a8c  b        #0x13aa4   ; call sub_13aa4
0x00013a90  mov      x20, x0
0x00013a94  mov      x0, x23
0x00013a98  bl       #0x2480c   ; call _objc_release
0x00013a9c  b        #0x13aa4   ; call sub_13aa4
0x00013aa0  mov      x20, x0
0x00013aa4  mov      x0, x19
0x00013aa8  bl       #0x2480c   ; call _objc_release
0x00013aac  b        #0x13ab4   ; call sub_13ab4
0x00013ab0  mov      x20, x0
0x00013ab4  mov      x0, x20
0x00013ab8  bl       #0x24470   ; call __Unwind_Resume
0x00013abc  stp      d15, d14, [sp, #-0xa0]!
0x00013ac0  stp      d13, d12, [sp, #0x10]
0x00013ac4  stp      d11, d10, [sp, #0x20]
0x00013ac8  stp      d9, d8, [sp, #0x30]
0x00013acc  stp      x28, x27, [sp, #0x40]
0x00013ad0  stp      x26, x25, [sp, #0x50]
0x00013ad4  stp      x24, x23, [sp, #0x60]
0x00013ad8  stp      x22, x21, [sp, #0x70]
0x00013adc  stp      x20, x19, [sp, #0x80]
0x00013ae0  stp      x29, x30, [sp, #0x90]
0x00013ae4  add      x29, sp, #0x90
0x00013ae8  sub      sp, sp, #0x1f0
0x00013aec  mov      x22, x2
0x00013af0  mov      x23, x0
0x00013af4  adrp     x8, #0x34000
0x00013af8  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00013afc  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00013b00  stur     x8, [x29, #-0xa0]
0x00013b04  mov      x0, x2
0x00013b08  bl       #0x24818   ; call _objc_retain
0x00013b0c  mov      x0, x23
0x00013b10  bl       #0x25e60   ; objc_msgSend: knobViews
0x00013b14  mov      x29, x29
0x00013b18  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013b1c  mov      x19, x0
0x00013b20  bl       #0x2480c   ; call _objc_release
0x00013b24  cbnz     x19, #0x13b54
0x00013b28  adrp     x8, #0x3e000
0x00013b2c  ldr      x0, [x8, #0x318]   ; -> [class(NSMutableArray)]
0x00013b30  bl       #0x24dc0   ; objc_msgSend: array
0x00013b34  mov      x29, x29
0x00013b38  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013b3c  mov      x19, x0
0x00013b40  mov      x0, x23
0x00013b44  mov      x2, x19
0x00013b48  bl       #0x271e0   ; objc_msgSend: setKnobViews:
0x00013b4c  mov      x0, x19
0x00013b50  bl       #0x2480c   ; call _objc_release
0x00013b54  adrp     x8, #0x3e000
0x00013b58  ldr      x0, [x8, #0x2a8]   ; -> [class(NSArray)]
0x00013b5c  bl       #0x247d0   ; call _objc_opt_class
0x00013b60  mov      x1, x0
0x00013b64  mov      x0, x22
0x00013b68  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x00013b6c  tbnz     w0, #0, #0x13b80
0x00013b70  mov      x0, x22
0x00013b74  bl       #0x2480c   ; call _objc_release
0x00013b78  adrp     x22, #0x34000
0x00013b7c  ldr      x22, [x22, #0x1f0]   ; -> [got:___NSArray0__struct]
0x00013b80  mov      x0, x22
0x00013b84  bl       #0x25420   ; objc_msgSend: count
0x00013b88  cbz      x0, #0x13b98
0x00013b8c  mov      x0, x23
0x00013b90  bl       #0x256c0   ; objc_msgSend: ensureWindow
0x00013b94  cbz      w0, #0x1480c
0x00013b98  str      x22, [sp, #0x70]
0x00013b9c  mov      x0, x23
0x00013ba0  bl       #0x25e60   ; objc_msgSend: knobViews
0x00013ba4  mov      x29, x29
0x00013ba8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013bac  mov      x20, x0
0x00013bb0  bl       #0x25420   ; objc_msgSend: count
0x00013bb4  mov      x19, x0
0x00013bb8  mov      x0, x22
0x00013bbc  bl       #0x25420   ; objc_msgSend: count
0x00013bc0  mov      x21, x0
0x00013bc4  mov      x0, x20
0x00013bc8  bl       #0x2480c   ; call _objc_release
0x00013bcc  cmp      x19, x21
0x00013bd0  b.ls     #0x13c30
0x00013bd4  mov      x0, x23
0x00013bd8  bl       #0x25e60   ; objc_msgSend: knobViews
0x00013bdc  mov      x29, x29
0x00013be0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013be4  mov      x20, x0
0x00013be8  bl       #0x25ea0   ; objc_msgSend: lastObject
0x00013bec  mov      x29, x29
0x00013bf0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013bf4  mov      x19, x0
0x00013bf8  bl       #0x26840   ; objc_msgSend: removeFromSuperview
0x00013bfc  mov      x0, x19
0x00013c00  bl       #0x2480c   ; call _objc_release
0x00013c04  mov      x0, x20
0x00013c08  bl       #0x2480c   ; call _objc_release
0x00013c0c  mov      x0, x23
0x00013c10  bl       #0x25e60   ; objc_msgSend: knobViews
0x00013c14  mov      x29, x29
0x00013c18  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013c1c  mov      x19, x0
0x00013c20  bl       #0x26880   ; objc_msgSend: removeLastObject
0x00013c24  mov      x0, x19
0x00013c28  bl       #0x2480c   ; call _objc_release
0x00013c2c  b        #0x13b9c   ; call sub_13b9c
0x00013c30  mov      x24, #0
0x00013c34  adrp     x8, #0x2b000
0x00013c38  ldr      d8, [x8, #0x2d8]
0x00013c3c  adrp     x8, #0x2b000
0x00013c40  ldr      d0, [x8, #0x2e0]
0x00013c44  str      d0, [sp, #0x58]
0x00013c48  adrp     x8, #0x2b000
0x00013c4c  ldr      d0, [x8, #0x2e8]
0x00013c50  str      d0, [sp, #0x50]
0x00013c54  adrp     x8, #0x2b000
0x00013c58  ldr      d0, [x8, #0x268]
0x00013c5c  str      d0, [sp, #0x48]
0x00013c60  adrp     x8, #0x2b000
0x00013c64  ldr      d0, [x8, #0x260]
0x00013c68  str      d0, [sp, #0x40]
0x00013c6c  adrp     x8, #0x2b000
0x00013c70  ldr      d0, [x8, #0x240]
0x00013c74  str      d0, [sp, #0x38]
0x00013c78  adrp     x8, #0x2b000
0x00013c7c  ldr      d0, [x8, #0x248]
0x00013c80  str      d0, [sp, #0x30]
0x00013c84  adrp     x8, #0x2b000
0x00013c88  adrp     x9, #0x2b000
0x00013c8c  ldr      d15, [x8, #0x250]
0x00013c90  ldr      s9, [x9, #0x390]
0x00013c94  adrp     x8, #0x2b000
0x00013c98  ldr      d10, [x8, #0x218]
0x00013c9c  adrp     x8, #0x2b000
0x00013ca0  adrp     x9, #0x2b000
0x00013ca4  ldr      d11, [x8, #0x220]
0x00013ca8  ldr      d12, [x9, #0x228]
0x00013cac  adrp     x8, #0x2b000
0x00013cb0  ldr      d0, [x8, #0x288]
0x00013cb4  str      d0, [sp, #0x28]
0x00013cb8  adrp     x8, #0x2b000
0x00013cbc  ldr      d0, [x8, #0x290]
0x00013cc0  str      d0, [sp, #0x20]
0x00013cc4  adrp     x8, #0x2b000
0x00013cc8  adrp     x9, #0x2b000
0x00013ccc  ldr      d0, [x8, #0x298]
0x00013cd0  str      d0, [sp, #0x18]
0x00013cd4  adrp     x8, #0x2b000
0x00013cd8  adrp     x10, #0x2b000
0x00013cdc  ldr      d0, [x9, #0x2a0]
0x00013ce0  str      d0, [sp, #0x10]
0x00013ce4  ldr      d0, [x8, #0x2a8]
0x00013ce8  str      d0, [sp, #8]
0x00013cec  ldr      d0, [x10, #0x2b0]
0x00013cf0  str      d0, [sp]
0x00013cf4  str      x23, [sp, #0x88]
0x00013cf8  mov      x0, x22
0x00013cfc  bl       #0x25420   ; objc_msgSend: count
0x00013d00  cmp      x24, x0
0x00013d04  b.hs     #0x1480c
0x00013d08  mov      x0, x22
0x00013d0c  mov      x2, x24
0x00013d10  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x00013d14  mov      x29, x29
0x00013d18  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013d1c  mov      x19, x0
0x00013d20  adrp     x8, #0x3e000
0x00013d24  ldr      x0, [x8, #0x2a8]   ; -> [class(NSArray)]
0x00013d28  str      x19, [sp, #0x90]
0x00013d2c  bl       #0x247d0   ; call _objc_opt_class
0x00013d30  mov      x1, x0
0x00013d34  mov      x0, x19
0x00013d38  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x00013d3c  str      x24, [sp, #0x98]
0x00013d40  tbz      w0, #0, #0x147f0
0x00013d44  mov      x0, x19
0x00013d48  bl       #0x25420   ; objc_msgSend: count
0x00013d4c  cmp      x0, #3
0x00013d50  b.lo     #0x147f0
0x00013d54  mov      x0, x23
0x00013d58  bl       #0x25e60   ; objc_msgSend: knobViews
0x00013d5c  mov      x29, x29
0x00013d60  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013d64  mov      x20, x0
0x00013d68  bl       #0x25420   ; objc_msgSend: count
0x00013d6c  cmp      x24, x0
0x00013d70  b.hs     #0x13db4
0x00013d74  mov      x0, x23
0x00013d78  bl       #0x25e60   ; objc_msgSend: knobViews
0x00013d7c  mov      x29, x29
0x00013d80  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013d84  mov      x21, x0
0x00013d88  mov      x2, x24
0x00013d8c  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x00013d90  mov      x29, x29
0x00013d94  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
