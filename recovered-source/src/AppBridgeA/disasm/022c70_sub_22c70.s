; ==== sub_22c70 @ 0x22c70..0x22e1c (428 bytes) ====
0x00022c70  cbz      x0, #0x22c9c
0x00022c74  ldr      x0, [x20, #0xaf0]
0x00022c78  bl       #0x253e0   ; objc_msgSend: copy
0x00022c7c  mov      x20, x0
0x00022c80  adrp     x3, #0x38000
0x00022c84  add      x3, x3, #0x4d0   ; -> @"hangWho"
0x00022c88  mov      x0, x19
0x00022c8c  mov      x2, x20
0x00022c90  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022c94  mov      x0, x20
0x00022c98  bl       #0x2480c   ; call _objc_release
0x00022c9c  adrp     x8, #0x3e000
0x00022ca0  ldr      x8, [x8, #0xbc0]
0x00022ca4  cbz      x8, #0x22e30
0x00022ca8  ldr      x0, [x21, #0x2a0]
0x00022cac  adrp     x9, #0x3e000
0x00022cb0  ldr      d0, [x9, #0xba8]
0x00022cb4  ucvtf    d1, x8
0x00022cb8  fdiv     d0, d0, d1
0x00022cbc  fcvtas   x2, d0
0x00022cc0  bl       #0x26360   ; objc_msgSend: numberWithLong:
0x00022cc4  mov      x29, x29
0x00022cc8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022ccc  mov      x20, x0
0x00022cd0  adrp     x3, #0x38000
0x00022cd4  add      x3, x3, #0x4f0   ; -> @"cpuAvg"
0x00022cd8  mov      x0, x19
0x00022cdc  mov      x2, x20
0x00022ce0  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022ce4  mov      x0, x20
0x00022ce8  bl       #0x2480c   ; call _objc_release
0x00022cec  ldr      x0, [x21, #0x2a0]
0x00022cf0  adrp     x8, #0x3e000
0x00022cf4  ldr      d0, [x8, #0xba0]
0x00022cf8  fcvtas   x2, d0
0x00022cfc  bl       #0x26360   ; objc_msgSend: numberWithLong:
0x00022d00  mov      x29, x29
0x00022d04  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022d08  mov      x20, x0
0x00022d0c  adrp     x3, #0x38000
0x00022d10  add      x3, x3, #0x510   ; -> @"cpuMax"
0x00022d14  mov      x0, x19
0x00022d18  mov      x2, x20
0x00022d1c  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022d20  mov      x0, x20
0x00022d24  bl       #0x2480c   ; call _objc_release
0x00022d28  ldr      x0, [x21, #0x2a0]
0x00022d2c  adrp     x8, #0x3e000
0x00022d30  ldr      d0, [x8, #0xb98]
0x00022d34  fcvtas   x2, d0
0x00022d38  bl       #0x26360   ; objc_msgSend: numberWithLong:
0x00022d3c  mov      x29, x29
0x00022d40  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022d44  mov      x20, x0
0x00022d48  adrp     x3, #0x38000
0x00022d4c  add      x3, x3, #0x530   ; -> @"memMB"
0x00022d50  mov      x0, x19
0x00022d54  mov      x2, x20
0x00022d58  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022d5c  mov      x0, x20
0x00022d60  bl       #0x2480c   ; call _objc_release
0x00022d64  ldr      x0, [x21, #0x2a0]
0x00022d68  adrp     x8, #0x3e000
0x00022d6c  ldr      d0, [x8, #0xb90]
0x00022d70  fcvtas   x2, d0
0x00022d74  bl       #0x26360   ; objc_msgSend: numberWithLong:
0x00022d78  mov      x29, x29
0x00022d7c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022d80  mov      x20, x0
0x00022d84  adrp     x3, #0x38000
0x00022d88  add      x3, x3, #0x550   ; -> @"memMaxMB"
0x00022d8c  mov      x0, x19
0x00022d90  mov      x2, x20
0x00022d94  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022d98  mov      x0, x20
0x00022d9c  bl       #0x2480c   ; call _objc_release
0x00022da0  ldr      x0, [x21, #0x2a0]
0x00022da4  adrp     x8, #0x3e000
0x00022da8  ldr      d0, [x8, #0xbb8]
0x00022dac  fcvtas   x8, d0
0x00022db0  mov      x9, #0x7fefffffffffffff
0x00022db4  fmov     d8, x9
0x00022db8  fcmp     d0, d8
0x00022dbc  csel     x2, x8, xzr, mi
0x00022dc0  bl       #0x26360   ; objc_msgSend: numberWithLong:
0x00022dc4  mov      x29, x29
0x00022dc8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022dcc  mov      x20, x0
0x00022dd0  adrp     x3, #0x38000
0x00022dd4  add      x3, x3, #0x570   ; -> @"availMinMB"
0x00022dd8  mov      x0, x19
0x00022ddc  mov      x2, x20
0x00022de0  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022de4  mov      x0, x20
0x00022de8  bl       #0x2480c   ; call _objc_release
0x00022dec  ldr      x0, [x21, #0x2a0]
0x00022df0  adrp     x8, #0x3e000
0x00022df4  ldr      d0, [x8, #0xbb0]
0x00022df8  fcvtas   x8, d0
0x00022dfc  fcmp     d0, d8
0x00022e00  csel     x2, x8, xzr, mi
0x00022e04  bl       #0x26360   ; objc_msgSend: numberWithLong:
0x00022e08  mov      x29, x29
0x00022e0c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022e10  mov      x20, x0
0x00022e14  adrp     x3, #0x38000
0x00022e18  add      x3, x3, #0x590   ; -> @"sysFreeMinMB"
