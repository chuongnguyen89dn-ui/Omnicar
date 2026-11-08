; ==== sub_22094 @ 0x22094..0x22154 (192 bytes) ====
0x00022094  add      x1, x1, #0x8fc
0x00022098  bl       #0x246f8   ; call _notify_register_check
0x0002209c  cbz      w0, #0x220bc
0x000220a0  mov      w8, #-1
0x000220a4  str      w8, [x20, #0x8fc]
0x000220a8  adrp     x0, #0x2a000
0x000220ac  add      x0, x0, #0x695   ; -> "com.anlai.omnicar/lite"
0x000220b0  ldp      x29, x30, [sp, #0x10]
0x000220b4  ldp      x20, x19, [sp], #0x20
0x000220b8  b        #0x246ec   ; call _notify_post
0x000220bc  ldr      w0, [x20, #0x8fc]
0x000220c0  cmn      w0, #1
0x000220c4  b.ne     #0x2207c
0x000220c8  b        #0x220a8   ; call sub_220a8
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
