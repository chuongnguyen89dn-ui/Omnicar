; ==== sub_207b8 @ 0x207b8..0x2081c (100 bytes) ====
0x000207b8  add      x1, sp, #0x30
0x000207bc  add      x2, sp, #0x60
0x000207c0  mov      x0, x20
0x000207c4  mov      x3, x21
0x000207c8  bl       #0x20bcc   ; call sub_20bcc
0x000207cc  cbz      x22, #0x207dc
0x000207d0  ldr      w19, [x22, #8]
0x000207d4  ldr      x22, [x22, #0x18]
0x000207d8  b        #0x207e0   ; call sub_207e0
0x000207dc  mov      w19, #0
0x000207e0  bl       #0x24644   ; call _getpid
0x000207e4  stp      x22, x0, [sp, #0x10]
0x000207e8  stp      x23, x19, [sp]
0x000207ec  str      x23, [sp, #0x20]
0x000207f0  adrp     x1, #0x2a000
0x000207f4  add      x1, x1, #0xb93   ; -> "signal %d (code %d) addr %p pid %d
"
0x000207f8  mov      x0, x20
0x000207fc  bl       #0x245fc   ; call _dprintf
0x00020800  add      x0, sp, #0x60
0x00020804  mov      x1, x21
0x00020808  mov      x2, x20
0x0002080c  bl       #0x244dc   ; call _backtrace_symbols_fd
0x00020810  bl       #0x244c4   ; call __dyld_image_count
0x00020814  cbz      w0, #0x208fc
0x00020818  mov      w21, #0
