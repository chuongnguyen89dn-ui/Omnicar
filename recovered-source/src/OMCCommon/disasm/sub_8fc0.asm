; === sub_8fc0 @ 0x8fc0 size=76 ===
0x00008fc0  stp      x20, x19, [sp, #-0x20]!
0x00008fc4  stp      x29, x30, [sp, #0x10]
0x00008fc8  add      x29, sp, #0x10
0x00008fcc  bl       #0xd194 ; call stub:_NSTemporaryDirectory
0x00008fd0  mov      x29, x29
0x00008fd4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008fd8  mov      x19, x0
0x00008fdc  adrp     x2, #0x16000
0x00008fe0  add      x2, x2, #0x888 ; -> CFSTR("OmniCar-crashguard.plist")
0x00008fe4  bl       #0xe380 ; call objc_stub[stringByAppendingPathComponent:]
0x00008fe8  mov      x29, x29
0x00008fec  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00008ff0  mov      x20, x0
0x00008ff4  mov      x0, x19
0x00008ff8  bl       #0xd4b8 ; call stub:_objc_release
0x00008ffc  mov      x0, x20
0x00009000  ldp      x29, x30, [sp, #0x10]
0x00009004  ldp      x20, x19, [sp], #0x20
0x00009008  b        #0xd434 ; call stub:_objc_autoreleaseReturnValue
