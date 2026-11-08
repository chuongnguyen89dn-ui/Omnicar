; === sub_b23c @ 0xb23c size=464 ===
0x0000b23c  sub      sp, sp, #0x50
0x0000b240  stp      d9, d8, [sp, #0x10]
0x0000b244  stp      x22, x21, [sp, #0x20]
0x0000b248  stp      x20, x19, [sp, #0x30]
0x0000b24c  stp      x29, x30, [sp, #0x40]
0x0000b250  add      x29, sp, #0x40
0x0000b254  mov      x19, x0
0x0000b258  bl       #0xb1e4 ; call sub_b1e4
0x0000b25c  ldr      d1, [x19, #0x20]
0x0000b260  fsub     d8, d0, d1
0x0000b264  adrp     x8, #0x18000
0x0000b268  add      x8, x8, #0x6d1 ; -> __DATA,__bss+0x1d1
0x0000b26c  stlrb    wzr, [x8]
0x0000b270  adrp     x8, #0x18000
0x0000b274  ldr      x8, [x8, #0x588] ; -> [__DATA,__bss+0x88]
0x0000b278  fmov     d0, #0.50000000
0x0000b27c  fcmp     d8, d0
0x0000b280  ccmp     x8, #0, #4, ge
0x0000b284  b.ne     #0xb2a0
0x0000b288  ldp      x29, x30, [sp, #0x40]
0x0000b28c  ldp      x20, x19, [sp, #0x30]
0x0000b290  ldp      x22, x21, [sp, #0x20]
0x0000b294  ldp      d9, d8, [sp, #0x10]
0x0000b298  add      sp, sp, #0x50
0x0000b29c  ret      
0x0000b2a0  adrp     x8, #0x18000
0x0000b2a4  ldr      d1, [x8, #0x648] ; -> [__DATA,__bss+0x148]
0x0000b2a8  fmov     d0, #1.00000000
0x0000b2ac  fadd     d1, d1, d0
0x0000b2b0  str      d1, [x8, #0x648]
0x0000b2b4  fmov     d1, #2.00000000
0x0000b2b8  fcmp     d8, d1
0x0000b2bc  b.lt     #0xb2d0
0x0000b2c0  adrp     x8, #0x18000
0x0000b2c4  ldr      d1, [x8, #0x640] ; -> [__DATA,__bss+0x140]
0x0000b2c8  fadd     d0, d1, d0
0x0000b2cc  str      d0, [x8, #0x640]
0x0000b2d0  adrp     x8, #0x18000
0x0000b2d4  ldr      d0, [x8, #0x638] ; -> [__DATA,__bss+0x138]
0x0000b2d8  adrp     x9, #0xf000
0x0000b2dc  ldr      d1, [x9, #0xad0] ; -> [__TEXT,__const+0x20 [u64=0x408f400000000000 f64=1000.0]]
0x0000b2e0  fmul     d1, d8, d1
0x0000b2e4  fcmp     d0, d1
0x0000b2e8  fcsel    d0, d1, d0, mi
0x0000b2ec  str      d0, [x8, #0x638]
0x0000b2f0  bl       #0x8f7c ; call sub_8f7c
0x0000b2f4  cbz      x0, #0xb324
0x0000b2f8  ldrb     w8, [x0, #0x400]
0x0000b2fc  cbz      w8, #0xb324
0x0000b300  adrp     x8, #0x18000
0x0000b304  ldr      x8, [x8, #0x3f0] ; -> [classref(NSString)]
0x0000b308  add      x2, x0, #0x400
0x0000b30c  mov      x0, x8
0x0000b310  bl       #0xe440 ; call objc_stub[stringWithUTF8String:]
0x0000b314  mov      x29, x29
0x0000b318  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000b31c  mov      x19, x0
0x0000b320  b        #0xb32c
0x0000b324  adrp     x19, #0x15000
0x0000b328  add      x19, x19, #0x928 ; -> CFSTR("-")
0x0000b32c  adrp     x8, #0x18000
0x0000b330  ldr      x20, [x8, #0x448] ; -> [classref(NSNumber)]
0x0000b334  adrp     x22, #0x18000
0x0000b338  ldr      x0, [x22, #0x5b0] ; -> [__DATA,__bss+0xb0]
0x0000b33c  mov      x2, x19
0x0000b340  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000b344  mov      x29, x29
0x0000b348  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000b34c  mov      x21, x0
0x0000b350  bl       #0xdc20 ; call objc_stub[integerValue]
0x0000b354  add      x2, x0, #1
0x0000b358  mov      x0, x20
0x0000b35c  bl       #0xdec0 ; call objc_stub[numberWithInteger:]
0x0000b360  mov      x29, x29
0x0000b364  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000b368  mov      x20, x0
0x0000b36c  ldr      x0, [x22, #0x5b0] ; -> [__DATA,__bss+0xb0]
0x0000b370  mov      x2, x20
0x0000b374  mov      x3, x19
0x0000b378  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000b37c  mov      x0, x20
0x0000b380  bl       #0xd4b8 ; call stub:_objc_release
0x0000b384  mov      x0, x21
0x0000b388  bl       #0xd4b8 ; call stub:_objc_release
0x0000b38c  adrp     x20, #0x18000
0x0000b390  add      x20, x20, #0x6b0 ; -> __DATA,__bss+0x1b0
0x0000b394  ldur     q0, [x20, #8]
0x0000b398  str      q0, [x20]
0x0000b39c  bl       #0xb1e4 ; call sub_b1e4
0x0000b3a0  str      d0, [x20, #0x10]
0x0000b3a4  fmov     d0, #2.00000000
0x0000b3a8  fcmp     d8, d0
0x0000b3ac  b.lt     #0xb3f0
0x0000b3b0  adrp     x8, #0x18000
0x0000b3b4  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x0000b3b8  str      x19, [sp, #8]
0x0000b3bc  str      d8, [sp]
0x0000b3c0  adrp     x2, #0x16000
0x0000b3c4  add      x2, x2, #0xe8 ; -> CFSTR("CarPlay do %.1fs (OmniCar gan nhat: %@)")
0x0000b3c8  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x0000b3cc  mov      x29, x29
0x0000b3d0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000b3d4  mov      x20, x0
0x0000b3d8  adrp     x0, #0x14000
0x0000b3dc  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x0000b3e0  mov      x1, x20
0x0000b3e4  bl       #0x6be4 ; call _OMCLogWrite
0x0000b3e8  mov      x0, x20
0x0000b3ec  bl       #0xd4b8 ; call stub:_objc_release
0x0000b3f0  mov      x0, x19
0x0000b3f4  ldp      x29, x30, [sp, #0x40]
0x0000b3f8  ldp      x20, x19, [sp, #0x30]
0x0000b3fc  ldp      x22, x21, [sp, #0x20]
0x0000b400  ldp      d9, d8, [sp, #0x10]
0x0000b404  add      sp, sp, #0x50
0x0000b408  b        #0xd4b8 ; call stub:_objc_release
