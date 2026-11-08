; === sub_b1e4 @ 0xb1e4 size=88 ===
0x0000b1e4  stp      x29, x30, [sp, #-0x10]!
0x0000b1e8  mov      x29, sp
0x0000b1ec  adrp     x8, #0x18000
0x0000b1f0  ldr      w8, [x8, #0x6dc] ; -> [__DATA,__bss+0x1dc]
0x0000b1f4  cbnz     w8, #0xb204
0x0000b1f8  adrp     x0, #0x18000
0x0000b1fc  add      x0, x0, #0x6d8 ; -> __DATA,__bss+0x1d8
0x0000b200  bl       #0xd3b0 ; call stub:_mach_timebase_info
0x0000b204  bl       #0xd38c ; call stub:_mach_absolute_time
0x0000b208  ucvtf    d0, x0
0x0000b20c  adrp     x8, #0x18000
0x0000b210  add      x8, x8, #0x6d8 ; -> __DATA,__bss+0x1d8
0x0000b214  ldp      s1, s2, [x8]
0x0000b218  ucvtf    d1, d1
0x0000b21c  fmul     d0, d0, d1
0x0000b220  ucvtf    d1, d2
0x0000b224  fdiv     d0, d0, d1
0x0000b228  adrp     x8, #0xf000
0x0000b22c  ldr      d1, [x8, #0xad8] ; -> [__TEXT,__const+0x28 [u64=0x41cdcd6500000000 f64=1000000000.0]]
0x0000b230  fdiv     d0, d0, d1
0x0000b234  ldp      x29, x30, [sp], #0x10
0x0000b238  ret      
