; ==== sub_e02c @ 0xe02c..0xe104 (216 bytes) ====
0x0000e02c  mov      x29, x29
0x0000e030  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000e034  mov      x23, x0
0x0000e038  mov      x0, x27
0x0000e03c  bl       #0x2480c   ; call _objc_release
0x0000e040  mov      x0, x24
0x0000e044  bl       #0x24824   ; call _objc_retainAutorelease
0x0000e048  mov      x2, x21
0x0000e04c  bl       #0x257e0   ; objc_msgSend: getArgumentTypeAtIndex:
0x0000e050  ldrb     w8, [x0]
0x0000e054  cmp      w8, #0x63
0x0000e058  b.eq     #0xe064
0x0000e05c  cmp      w8, #0x42
0x0000e060  b.ne     #0xe08c
0x0000e064  mov      x0, x23
0x0000e068  adrp     x2, #0x36000
0x0000e06c  add      x2, x2, #0x970   ; -> @"createprimary"
0x0000e070  bl       #0x25380   ; objc_msgSend: containsString:
0x0000e074  strb     w0, [sp, #0x18]
0x0000e078  add      x2, sp, #0x18
0x0000e07c  mov      x0, x25
0x0000e080  mov      x3, x21
0x0000e084  bl       #0x26be0   ; objc_msgSend: setArgument:atIndex:
0x0000e088  b        #0xe11c   ; call sub_e11c
0x0000e08c  str      xzr, [sp, #0x18]
0x0000e090  mov      x0, x23
0x0000e094  adrp     x2, #0x36000
0x0000e098  add      x2, x2, #0x990   ; -> @"bundleidentifier"
0x0000e09c  bl       #0x25380   ; objc_msgSend: containsString:
0x0000e0a0  mov      x27, x22
0x0000e0a4  tbnz     w0, #0, #0xe0f0
0x0000e0a8  mov      x0, x23
0x0000e0ac  adrp     x2, #0x36000
0x0000e0b0  add      x2, x2, #0x9b0   ; -> @"application"
0x0000e0b4  bl       #0x25380   ; objc_msgSend: containsString:
0x0000e0b8  ldr      x27, [sp, #0x10]
0x0000e0bc  tbnz     w0, #0, #0xe0f0
0x0000e0c0  mov      x0, x23
0x0000e0c4  adrp     x2, #0x36000
0x0000e0c8  add      x2, x2, #0x9d0   ; -> @"role"
0x0000e0cc  bl       #0x25380   ; objc_msgSend: containsString:
0x0000e0d0  ldr      x27, [sp, #8]
0x0000e0d4  tbnz     w0, #0, #0xe0f0
0x0000e0d8  mov      x0, x23
0x0000e0dc  adrp     x2, #0x36000
0x0000e0e0  add      x2, x2, #0x9f0   ; -> @"display"
0x0000e0e4  bl       #0x25380   ; objc_msgSend: containsString:
0x0000e0e8  ldr      x27, [sp]
0x0000e0ec  cbz      w0, #0xe104
0x0000e0f0  mov      x0, x27
0x0000e0f4  bl       #0x24818   ; call _objc_retain
0x0000e0f8  ldr      x0, [sp, #0x18]
0x0000e0fc  str      x27, [sp, #0x18]
0x0000e100  bl       #0x2480c   ; call _objc_release
