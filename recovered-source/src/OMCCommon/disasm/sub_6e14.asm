; === sub_6e14 @ 0x6e14 size=280 ===
0x00006e14  sub      sp, sp, #0x50
0x00006e18  stp      x22, x21, [sp, #0x20]
0x00006e1c  stp      x20, x19, [sp, #0x30]
0x00006e20  stp      x29, x30, [sp, #0x40]
0x00006e24  add      x29, sp, #0x40
0x00006e28  mov      x19, x0
0x00006e2c  adrp     x8, #0x14000
0x00006e30  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x00006e34  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x00006e38  str      x8, [sp, #0x18]
0x00006e3c  adrp     x20, #0x18000
0x00006e40  ldr      x8, [x20, #0x5d8] ; -> [__DATA,__bss+0xd8]
0x00006e44  cmn      x8, #1
0x00006e48  b.ne     #0x6f18
0x00006e4c  adrp     x21, #0x18000
0x00006e50  ldrb     w8, [x21, #0x5d0]
0x00006e54  cmp      w8, #1
0x00006e58  b.ne     #0x6e60
0x00006e5c  bl       #0x6f2c ; call sub_6f2c
0x00006e60  ldr      x0, [x19, #0x20]
0x00006e64  bl       #0x6fec ; call sub_6fec
0x00006e68  tbnz     w0, #0, #0x6eec
0x00006e6c  ldr      x8, [x20, #0x5d8] ; -> [__DATA,__bss+0xd8]
0x00006e70  cmn      x8, #1
0x00006e74  b.ne     #0x6f20
0x00006e78  ldrb     w8, [x21, #0x5d0]
0x00006e7c  tbnz     w8, #0, #0x6eec
0x00006e80  bl       #0x705c ; call sub_705c
0x00006e84  mov      x29, x29
0x00006e88  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006e8c  mov      x20, x0
0x00006e90  adrp     x8, #0x15000
0x00006e94  add      x9, x8, #0x8a8 ; -> CFSTR("line")
0x00006e98  ldr      x8, [x19, #0x20]
0x00006e9c  stp      x9, x8, [sp, #8]
0x00006ea0  adrp     x8, #0x18000
0x00006ea4  ldr      x0, [x8, #0x468] ; -> [classref(NSDictionary)]
0x00006ea8  add      x2, sp, #0x10
0x00006eac  add      x3, sp, #8
0x00006eb0  mov      w4, #1
0x00006eb4  bl       #0xdac0 ; call objc_stub[dictionaryWithObjects:forKeys:count:]
0x00006eb8  mov      x29, x29
0x00006ebc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006ec0  mov      x19, x0
0x00006ec4  adrp     x2, #0x15000
0x00006ec8  add      x2, x2, #0x888 ; -> CFSTR("com.anlai.omnicar/log")
0x00006ecc  mov      x0, x20
0x00006ed0  mov      x3, #0
0x00006ed4  mov      x4, x19
0x00006ed8  bl       #0xdfe0 ; call objc_stub[postNotificationName:object:userInfo:]
0x00006edc  mov      x0, x19
0x00006ee0  bl       #0xd4b8 ; call stub:_objc_release
0x00006ee4  mov      x0, x20
0x00006ee8  bl       #0xd4b8 ; call stub:_objc_release
0x00006eec  ldr      x8, [sp, #0x18]
0x00006ef0  adrp     x9, #0x14000
0x00006ef4  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x00006ef8  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x00006efc  cmp      x9, x8
0x00006f00  b.ne     #0x6f28
0x00006f04  ldp      x29, x30, [sp, #0x40]
0x00006f08  ldp      x20, x19, [sp, #0x30]
0x00006f0c  ldp      x22, x21, [sp, #0x20]
0x00006f10  add      sp, sp, #0x50
0x00006f14  ret      
0x00006f18  bl       #0xd078 ; call sub_d078
0x00006f1c  b        #0x6e4c
0x00006f20  bl       #0xd07c ; call sub_d07c
0x00006f24  b        #0x6e78
0x00006f28  bl       #0xd1b8 ; call stub:___stack_chk_fail
