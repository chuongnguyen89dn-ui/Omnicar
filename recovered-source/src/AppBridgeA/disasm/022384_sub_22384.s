; ==== sub_22384 @ 0x22384..0x22438 (180 bytes) ====
0x00022384  adrp     x8, #0x3e000
0x00022388  add      x8, x8, #0xc18
0x0002238c  ldp      s1, s2, [x8]
0x00022390  ucvtf    d1, d1
0x00022394  fmul     d0, d0, d1
0x00022398  ucvtf    d1, d2
0x0002239c  fdiv     d0, d0, d1
0x000223a0  adrp     x8, #0x2b000
0x000223a4  ldr      d1, [x8, #0x1e0]
0x000223a8  fdiv     d0, d0, d1
0x000223ac  ldp      x29, x30, [sp], #0x10
0x000223b0  ret      
0x000223b4  sub      sp, sp, #0x50
0x000223b8  stp      d9, d8, [sp, #0x10]
0x000223bc  stp      x22, x21, [sp, #0x20]
0x000223c0  stp      x20, x19, [sp, #0x30]
0x000223c4  stp      x29, x30, [sp, #0x40]
0x000223c8  add      x29, sp, #0x40
0x000223cc  mov      x19, x0
0x000223d0  bl       #0x2235c   ; call sub_2235c
0x000223d4  ldr      d1, [x19, #0x20]
0x000223d8  fsub     d8, d0, d1
0x000223dc  adrp     x8, #0x3e000
0x000223e0  add      x8, x8, #0xc11
0x000223e4  stlrb    wzr, [x8]
0x000223e8  adrp     x8, #0x3e000
0x000223ec  ldr      x8, [x8, #0xac8]
0x000223f0  fmov     d0, #0.50000000
0x000223f4  fcmp     d8, d0
0x000223f8  ccmp     x8, #0, #4, ge
0x000223fc  b.ne     #0x22418
0x00022400  ldp      x29, x30, [sp, #0x40]
0x00022404  ldp      x20, x19, [sp, #0x30]
0x00022408  ldp      x22, x21, [sp, #0x20]
0x0002240c  ldp      d9, d8, [sp, #0x10]
0x00022410  add      sp, sp, #0x50
0x00022414  ret      
0x00022418  adrp     x8, #0x3e000
0x0002241c  ldr      d1, [x8, #0xb88]
0x00022420  fmov     d0, #1.00000000
0x00022424  fadd     d1, d1, d0
0x00022428  str      d1, [x8, #0xb88]
0x0002242c  fmov     d1, #2.00000000
0x00022430  fcmp     d8, d1
0x00022434  b.lt     #0x22448
