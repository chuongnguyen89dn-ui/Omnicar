; === sub_6f2c @ 0x6f2c size=192 ===
0x00006f2c  stp      x22, x21, [sp, #-0x30]!
0x00006f30  stp      x20, x19, [sp, #0x10]
0x00006f34  stp      x29, x30, [sp, #0x20]
0x00006f38  add      x29, sp, #0x20
0x00006f3c  adrp     x8, #0x18000
0x00006f40  ldr      x0, [x8, #0x4a8] ; -> [classref(NSFileManager)]
0x00006f44  bl       #0xda40 ; call objc_stub[defaultManager]
0x00006f48  mov      x29, x29
0x00006f4c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006f50  mov      x19, x0
0x00006f54  adrp     x2, #0x15000
0x00006f58  add      x2, x2, #0x808 ; -> CFSTR("/var/mobile/Documents/OmniCar.log")
0x00006f5c  mov      x3, #0
0x00006f60  bl       #0xd7a0 ; call objc_stub[attributesOfItemAtPath:error:]
0x00006f64  mov      x29, x29
0x00006f68  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006f6c  mov      x20, x0
0x00006f70  bl       #0xdb40 ; call objc_stub[fileSize]
0x00006f74  mov      x21, x0
0x00006f78  mov      x0, x20
0x00006f7c  bl       #0xd4b8 ; call stub:_objc_release
0x00006f80  cmp      x21, #0x200, lsl #12
0x00006f84  b.lo     #0x6fd8
0x00006f88  adrp     x20, #0x15000
0x00006f8c  add      x20, x20, #0x808 ; -> CFSTR("/var/mobile/Documents/OmniCar.log")
0x00006f90  adrp     x2, #0x15000
0x00006f94  add      x2, x2, #0xd28 ; -> CFSTR(".old")
0x00006f98  mov      x0, x20
0x00006f9c  bl       #0xe3a0 ; call objc_stub[stringByAppendingString:]
0x00006fa0  mov      x29, x29
0x00006fa4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006fa8  mov      x21, x0
0x00006fac  mov      x0, x19
0x00006fb0  mov      x2, x21
0x00006fb4  mov      x3, #0
0x00006fb8  bl       #0xe0e0 ; call objc_stub[removeItemAtPath:error:]
0x00006fbc  mov      x0, x19
0x00006fc0  mov      x2, x20
0x00006fc4  mov      x3, x21
0x00006fc8  mov      x4, #0
0x00006fcc  bl       #0xdde0 ; call objc_stub[moveItemAtPath:toPath:error:]
0x00006fd0  mov      x0, x21
0x00006fd4  bl       #0xd4b8 ; call stub:_objc_release
0x00006fd8  mov      x0, x19
0x00006fdc  ldp      x29, x30, [sp, #0x20]
0x00006fe0  ldp      x20, x19, [sp, #0x10]
0x00006fe4  ldp      x22, x21, [sp], #0x30
0x00006fe8  b        #0xd4b8 ; call stub:_objc_release
