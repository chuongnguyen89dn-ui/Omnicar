; ==== sub_1c0c0 @ 0x1c0c0..0x1c1dc (284 bytes) ====
0x0001c0c0  bl       #0x26f80   ; objc_msgSend: setFrame:
0x0001c0c4  mov      x0, x21
0x0001c0c8  bl       #0x2480c   ; call _objc_release
0x0001c0cc  mov      x0, x20
0x0001c0d0  bl       #0x2480c   ; call _objc_release
0x0001c0d4  mov      x0, x19
0x0001c0d8  bl       #0x256e0   ; objc_msgSend: field
0x0001c0dc  mov      x29, x29
0x0001c0e0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c0e4  mov      x20, x0
0x0001c0e8  bl       #0x24f40   ; objc_msgSend: bounds
0x0001c0ec  fmov     d4, #10.00000000
0x0001c0f0  fmov     d5, xzr
0x0001c0f4  bl       #0x243b0   ; call _CGRectInset
0x0001c0f8  mov      v10.16b, v0.16b
0x0001c0fc  mov      v11.16b, v1.16b
0x0001c100  mov      v12.16b, v2.16b
0x0001c104  mov      v13.16b, v3.16b
0x0001c108  mov      x0, x19
0x0001c10c  bl       #0x266a0   ; objc_msgSend: preview
0x0001c110  mov      x29, x29
0x0001c114  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c118  mov      x21, x0
0x0001c11c  mov      v0.16b, v10.16b
0x0001c120  mov      v1.16b, v11.16b
0x0001c124  mov      v2.16b, v12.16b
0x0001c128  mov      v3.16b, v13.16b
0x0001c12c  bl       #0x26f80   ; objc_msgSend: setFrame:
0x0001c130  mov      x0, x21
0x0001c134  bl       #0x2480c   ; call _objc_release
0x0001c138  mov      x0, x20
0x0001c13c  bl       #0x2480c   ; call _objc_release
0x0001c140  fmov     d0, #-10.00000000
0x0001c144  fadd     d9, d9, d0
0x0001c148  adrp     x8, #0x2b000
0x0001c14c  ldr      d0, [x8, #0x3e0]
0x0001c150  fadd     d0, d8, d0
0x0001c154  fmov     d1, #-5.00000000
0x0001c158  fadd     d8, d0, d1
0x0001c15c  mov      x0, x19
0x0001c160  bl       #0x25e40   ; objc_msgSend: keysView
0x0001c164  mov      x29, x29
0x0001c168  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c16c  mov      x20, x0
0x0001c170  adrp     x8, #0x2b000
0x0001c174  ldr      d1, [x8, #0x2e8]
0x0001c178  fmov     d0, #5.00000000
0x0001c17c  mov      v2.16b, v9.16b
0x0001c180  mov      v3.16b, v8.16b
0x0001c184  bl       #0x26f80   ; objc_msgSend: setFrame:
0x0001c188  mov      x0, x20
0x0001c18c  bl       #0x2480c   ; call _objc_release
0x0001c190  mov      x0, x19
0x0001c194  bl       #0x25e40   ; objc_msgSend: keysView
0x0001c198  mov      x29, x29
0x0001c19c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c1a0  mov      x20, x0
0x0001c1a4  bl       #0x24f40   ; objc_msgSend: bounds
0x0001c1a8  mov      v8.16b, v2.16b
0x0001c1ac  mov      v9.16b, v3.16b
0x0001c1b0  mov      x0, x20
0x0001c1b4  bl       #0x2480c   ; call _objc_release
0x0001c1b8  str      x19, [sp, #8]
0x0001c1bc  mov      x0, x19
0x0001c1c0  bl       #0x269e0   ; objc_msgSend: rows
0x0001c1c4  mov      x29, x29
0x0001c1c8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c1cc  mov      x20, x0
0x0001c1d0  bl       #0x25420   ; objc_msgSend: count
0x0001c1d4  mov      x22, x0
0x0001c1d8  mov      x0, x20
