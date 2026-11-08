; === sub_6d8c @ 0x6d8c size=68 ===
0x00006d8c  stp      x20, x19, [sp, #-0x20]!
0x00006d90  stp      x29, x30, [sp, #0x10]
0x00006d94  add      x29, sp, #0x10
0x00006d98  adrp     x8, #0x18000
0x00006d9c  ldr      x0, [x8, #0x430] ; -> [classref(NSDateFormatter)]
0x00006da0  bl       #0xd494 ; call stub:_objc_opt_new
0x00006da4  adrp     x19, #0x18000
0x00006da8  ldr      x8, [x19, #0x560] ; -> [__DATA,__bss+0x60]
0x00006dac  str      x0, [x19, #0x560]
0x00006db0  mov      x0, x8
0x00006db4  bl       #0xd4b8 ; call stub:_objc_release
0x00006db8  ldr      x0, [x19, #0x560] ; -> [__DATA,__bss+0x60]
0x00006dbc  adrp     x2, #0x15000
0x00006dc0  add      x2, x2, #0x848 ; -> CFSTR("yyyy-MM-dd HH:mm:ss.SSS")
0x00006dc4  ldp      x29, x30, [sp, #0x10]
0x00006dc8  ldp      x20, x19, [sp], #0x20
0x00006dcc  b        #0xe220 ; call objc_stub[setDateFormat:]
