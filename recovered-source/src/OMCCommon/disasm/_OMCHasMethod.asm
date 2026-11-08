; === _OMCHasMethod @ 0x720c size=180 ===
0x0000720c  stp      x22, x21, [sp, #-0x30]!
0x00007210  stp      x20, x19, [sp, #0x10]
0x00007214  stp      x29, x30, [sp, #0x20]
0x00007218  add      x29, sp, #0x20
0x0000721c  mov      x19, x1
0x00007220  mov      x20, x0
0x00007224  mov      x0, x1
0x00007228  bl       #0xd4c4 ; call stub:_objc_retain
0x0000722c  mov      x0, x20
0x00007230  bl       #0x72c0 ; call _OMCCarClass
0x00007234  mov      x20, x0
0x00007238  cbz      x0, #0x72a4
0x0000723c  adrp     x2, #0x15000
0x00007240  add      x2, x2, #0x8c8 ; -> CFSTR("+")
0x00007244  mov      x0, x19
0x00007248  bl       #0xdba0 ; call objc_stub[hasPrefix:]
0x0000724c  cbz      w0, #0x7288
0x00007250  mov      x0, x19
0x00007254  mov      w2, #1
0x00007258  bl       #0xe460 ; call objc_stub[substringFromIndex:]
0x0000725c  mov      x29, x29
0x00007260  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007264  mov      x21, x0
0x00007268  bl       #0xd170 ; call stub:_NSSelectorFromString
0x0000726c  mov      x22, x0
0x00007270  mov      x0, x21
0x00007274  bl       #0xd4b8 ; call stub:_objc_release
0x00007278  mov      x0, x20
0x0000727c  mov      x1, x22
0x00007280  bl       #0xd230 ; call stub:_class_getClassMethod
0x00007284  b        #0x729c
0x00007288  mov      x0, x19
0x0000728c  bl       #0xd170 ; call stub:_NSSelectorFromString
0x00007290  mov      x1, x0
0x00007294  mov      x0, x20
0x00007298  bl       #0xd23c ; call stub:_class_getInstanceMethod
0x0000729c  cmp      x0, #0
0x000072a0  cset     w20, ne
0x000072a4  mov      x0, x19
0x000072a8  bl       #0xd4b8 ; call stub:_objc_release
0x000072ac  mov      x0, x20
0x000072b0  ldp      x29, x30, [sp, #0x20]
0x000072b4  ldp      x20, x19, [sp, #0x10]
0x000072b8  ldp      x22, x21, [sp], #0x30
0x000072bc  ret      
