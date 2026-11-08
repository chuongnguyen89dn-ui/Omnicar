; ==== sub_177cc @ 0x177cc..0x17918 (332 bytes) ====
0x000177cc  mov      x0, x27
0x000177d0  bl       #0x2480c   ; call _objc_release
0x000177d4  add      x26, x26, #1
0x000177d8  cmp      x23, x26
0x000177dc  b.ne     #0x1775c
0x000177e0  tbz      w21, #0, #0x17800
0x000177e4  cmp      w28, #0
0x000177e8  csel     x28, xzr, x22, eq
0x000177ec  mov      x0, x28
0x000177f0  bl       #0x24818   ; call _objc_retain
0x000177f4  b        #0x17830   ; call sub_17830
0x000177f8  mov      w28, #0
0x000177fc  tbnz     w21, #0, #0x177e4
0x00017800  cmp      w28, w19
0x00017804  b.ne     #0x17888
0x00017808  mov      x0, x22
0x0001780c  mov      x2, x20
0x00017810  ldr      x19, [sp, #0x18]
0x00017814  bl       #0x24d60   ; objc_msgSend: appendString:
0x00017818  b        #0x17b2c   ; call sub_17b2c
0x0001781c  str      x19, [sp, #0x18]
0x00017820  mov      w21, #0
0x00017824  mov      w19, #1
0x00017828  tbz      x26, #0x3f, #0x17744
0x0001782c  mov      x28, #0
0x00017830  ldr      x19, [sp, #0x18]
0x00017834  b        #0x17ca4   ; call sub_17ca4
0x00017838  mov      x28, #0
0x0001783c  cmp      w27, #0x64
0x00017840  b.le     #0x1796c
0x00017844  cmp      w27, #0x65
0x00017848  b.eq     #0x179cc
0x0001784c  cmp      w27, #0x77
0x00017850  b.eq     #0x17b3c
0x00017854  cmp      w27, #0x6f
0x00017858  b.ne     #0x17ca4
0x0001785c  b        #0x179cc   ; call sub_179cc
0x00017860  str      x19, [sp, #0x18]
0x00017864  mov      w21, #0
0x00017868  mov      w19, #5
0x0001786c  tbz      x26, #0x3f, #0x17744
0x00017870  b        #0x1782c   ; call sub_1782c
0x00017874  str      x19, [sp, #0x18]
0x00017878  mov      w21, #0
0x0001787c  mov      w19, #4
0x00017880  tbnz     x26, #0x3f, #0x1782c
0x00017884  b        #0x17744   ; call sub_17744
0x00017888  mov      x25, x19
0x0001788c  mov      x0, x22
0x00017890  bl       #0x24818   ; call _objc_retain
0x00017894  subs     x21, x23, x24
0x00017898  b.ls     #0x178f8
0x0001789c  mov      x26, #-1
0x000178a0  mov      w25, #1
0x000178a4  mov      w28, #0x596
0x000178a8  mov      x27, x24
0x000178ac  str      wzr, [sp, #0x3c]
0x000178b0  mov      x0, x22
0x000178b4  mov      x2, x27
0x000178b8  bl       #0x25140   ; objc_msgSend: characterAtIndex:
0x000178bc  add      x1, sp, #0x3c
0x000178c0  mov      x2, #0
0x000178c4  mov      x3, #0
0x000178c8  bl       #0x17ecc   ; call sub_17ecc
0x000178cc  ldr      w8, [sp, #0x3c]
0x000178d0  cmp      w8, #0xa
0x000178d4  lsl      w8, w25, w8
0x000178d8  and      w8, w8, w28
0x000178dc  ccmp     w8, #0, #4, ls
0x000178e0  csel     x26, x27, x26, ne
0x000178e4  add      x27, x27, #1
0x000178e8  cmp      x23, x27
0x000178ec  b.ne     #0x178ac
0x000178f0  mov      x25, x19
0x000178f4  tbz      x26, #0x3f, #0x17aac
0x000178f8  cmp      x21, #1
0x000178fc  b.eq     #0x17964
0x00017900  cmp      x21, #2
0x00017904  b.ne     #0x17aa8
0x00017908  mov      x0, x22
0x0001790c  mov      x2, x24
0x00017910  mov      w3, #2
0x00017914  bl       #0x27de0   ; objc_msgSend: substringWithRange:
