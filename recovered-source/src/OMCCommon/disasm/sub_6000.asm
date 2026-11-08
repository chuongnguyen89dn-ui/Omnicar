; === sub_6000 @ 0x6000 size=40 ===
0x00006000  ldp      x5, x7, [x0, #0x28]
0x00006004  ldr      x4, [x0, #0x20]
0x00006008  adrp     x6, #0x14000
0x0000600c  add      x6, x6, #0xb28 ; -> CFSTR("OK")
0x00006010  fmov     d0, xzr
0x00006014  mov      x0, #0
0x00006018  mov      x1, #0
0x0000601c  mov      x2, #0
0x00006020  mov      x3, #0
0x00006024  br       x7
