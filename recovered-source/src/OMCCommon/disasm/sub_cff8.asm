; === sub_cff8 @ 0xcff8 size=52 ===
0x0000cff8  stp      x29, x30, [sp, #-0x10]!
0x0000cffc  mov      x29, sp
0x0000d000  adrp     x8, #0x18000
0x0000d004  ldr      x0, [x8, #0x470] ; -> [classref(NSMutableDictionary)]
0x0000d008  bl       #0xda80 ; call objc_stub[dictionary]
0x0000d00c  mov      x29, x29
0x0000d010  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000d014  adrp     x9, #0x18000
0x0000d018  ldr      x8, [x9, #0x738] ; -> [__DATA,__bss+0x238]
0x0000d01c  str      x0, [x9, #0x738]
0x0000d020  mov      x0, x8
0x0000d024  ldp      x29, x30, [sp], #0x10
0x0000d028  b        #0xd4b8 ; call stub:_objc_release
