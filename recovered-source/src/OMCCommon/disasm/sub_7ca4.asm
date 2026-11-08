; === sub_7ca4 @ 0x7ca4 size=52 ===
0x00007ca4  stp      x29, x30, [sp, #-0x10]!
0x00007ca8  mov      x29, sp
0x00007cac  adrp     x8, #0x18000
0x00007cb0  ldr      x0, [x8, #0x4a0] ; -> [classref(NSMutableSet)]
0x00007cb4  bl       #0xe1e0 ; call objc_stub[set]
0x00007cb8  mov      x29, x29
0x00007cbc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007cc0  adrp     x9, #0x18000
0x00007cc4  ldr      x8, [x9, #0x578] ; -> [__DATA,__bss+0x78]
0x00007cc8  str      x0, [x9, #0x578]
0x00007ccc  mov      x0, x8
0x00007cd0  ldp      x29, x30, [sp], #0x10
0x00007cd4  b        #0xd4b8 ; call stub:_objc_release
