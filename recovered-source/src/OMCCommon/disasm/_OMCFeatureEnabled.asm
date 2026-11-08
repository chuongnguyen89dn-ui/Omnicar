; === _OMCFeatureEnabled @ 0x65f8 size=144 ===
0x000065f8  stp      x22, x21, [sp, #-0x30]!
0x000065fc  stp      x20, x19, [sp, #0x10]
0x00006600  stp      x29, x30, [sp, #0x20]
0x00006604  add      x29, sp, #0x20
0x00006608  mov      x19, x0
0x0000660c  bl       #0xd4c4 ; call stub:_objc_retain
0x00006610  bl       #0x659c ; call _OMCEnabled
0x00006614  cbz      w0, #0x6668
0x00006618  adrp     x2, #0x15000
0x0000661c  add      x2, x2, #0x688 ; -> CFSTR("Enabled")
0x00006620  mov      x0, x19
0x00006624  bl       #0xe3a0 ; call objc_stub[stringByAppendingString:]
0x00006628  mov      x29, x29
0x0000662c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006630  mov      x21, x0
0x00006634  adrp     x1, #0x14000
0x00006638  ldr      x1, [x1, #0x188] ; -> [got(___kCFBooleanTrue)]
0x0000663c  bl       #0x6534 ; call _OMCPref
0x00006640  mov      x29, x29
0x00006644  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006648  mov      x22, x0
0x0000664c  bl       #0xd7c0 ; call objc_stub[boolValue]
0x00006650  mov      x20, x0
0x00006654  mov      x0, x22
0x00006658  bl       #0xd4b8 ; call stub:_objc_release
0x0000665c  mov      x0, x21
0x00006660  bl       #0xd4b8 ; call stub:_objc_release
0x00006664  b        #0x666c
0x00006668  mov      w20, #0
0x0000666c  mov      x0, x19
0x00006670  bl       #0xd4b8 ; call stub:_objc_release
0x00006674  mov      x0, x20
0x00006678  ldp      x29, x30, [sp, #0x20]
0x0000667c  ldp      x20, x19, [sp, #0x10]
0x00006680  ldp      x22, x21, [sp], #0x30
0x00006684  ret      
