; block literal @0x34cd0 desc @0x34610 sig=v8@?0 flags=0x50000000
; ==== sub_220cc @ 0x220cc..0x22154 (136 bytes) ====
0x000220cc  stp      d11, d10, [sp, #-0x60]!
0x000220d0  stp      d9, d8, [sp, #0x10]
0x000220d4  stp      x28, x27, [sp, #0x20]
0x000220d8  stp      x22, x21, [sp, #0x30]
0x000220dc  stp      x20, x19, [sp, #0x40]
0x000220e0  stp      x29, x30, [sp, #0x50]
0x000220e4  add      x29, sp, #0x50
0x000220e8  sub      sp, sp, #0x1a0
0x000220ec  bl       #0x2235c   ; call sub_2235c
0x000220f0  adrp     x8, #0x3e000
0x000220f4  add      x8, x8, #0xc11
0x000220f8  mov      w9, #1
0x000220fc  ldaxrb   w10, [x8]
0x00022100  cbnz     w10, #0x22150
0x00022104  stlxrb   w10, w9, [x8]
0x00022108  cbnz     w10, #0x220fc
0x0002210c  adrp     x8, #0x34000
0x00022110  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x00022114  str      x8, [sp]
0x00022118  adrp     x8, #0x2b000
0x0002211c  ldr      d1, [x8, #0x1e8]
0x00022120  adrp     x8, #0x22000
0x00022124  add      x8, x8, #0x3b4
0x00022128  str      d1, [sp, #8]
0x0002212c  adrp     x9, #0x34000
0x00022130  add      x9, x9, #0x650
0x00022134  stp      x8, x9, [sp, #0x10]
0x00022138  str      d0, [sp, #0x20]
0x0002213c  adrp     x0, #0x34000
0x00022140  ldr      x0, [x0, #0x290]   ; -> [got:__dispatch_main_q]
0x00022144  mov      x1, sp
0x00022148  bl       #0x24554   ; call _dispatch_async
0x0002214c  b        #0x22154   ; call sub_22154
0x00022150  clrex    

