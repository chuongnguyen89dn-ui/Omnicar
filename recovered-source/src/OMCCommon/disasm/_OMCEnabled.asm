; === _OMCEnabled @ 0x659c size=92 ===
0x0000659c  stp      x20, x19, [sp, #-0x20]!
0x000065a0  stp      x29, x30, [sp, #0x10]
0x000065a4  add      x29, sp, #0x10
0x000065a8  bl       #0xc414 ; call _OMCExpired
0x000065ac  tbz      w0, #0, #0x65b8
0x000065b0  mov      w0, #0
0x000065b4  b        #0x65ec
0x000065b8  adrp     x0, #0x15000
0x000065bc  add      x0, x0, #0x3e8 ; -> CFSTR("enabled")
0x000065c0  adrp     x1, #0x14000
0x000065c4  ldr      x1, [x1, #0x188] ; -> [got(___kCFBooleanTrue)]
0x000065c8  bl       #0x6534 ; call _OMCPref
0x000065cc  mov      x29, x29
0x000065d0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000065d4  mov      x19, x0
0x000065d8  bl       #0xd7c0 ; call objc_stub[boolValue]
0x000065dc  mov      x20, x0
0x000065e0  mov      x0, x19
0x000065e4  bl       #0xd4b8 ; call stub:_objc_release
0x000065e8  mov      x0, x20
0x000065ec  ldp      x29, x30, [sp, #0x10]
0x000065f0  ldp      x20, x19, [sp], #0x20
0x000065f4  ret      
