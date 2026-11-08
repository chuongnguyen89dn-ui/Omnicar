; ==== sub_22200 @ 0x22200..0x22284 (132 bytes) ====
0x00022200  fmul     d0, d0, d1
0x00022204  fdiv     d0, d0, d10
0x00022208  fadd     d8, d8, d0
0x0002220c  ldr      w0, [x19]
0x00022210  ldr      x8, [sp, #0x30]
0x00022214  ldr      w1, [x8, x20, lsl #2]
0x00022218  bl       #0x246a4   ; call _mach_port_deallocate
0x0002221c  add      x20, x20, #1
0x00022220  ldr      w8, [sp, #0x2c]
0x00022224  cmp      x20, x8
0x00022228  b.lo     #0x221cc
0x0002222c  lsl      x2, x8, #2
0x00022230  b        #0x2223c   ; call sub_2223c
0x00022234  mov      x2, #0
0x00022238  fmov     d8, xzr
0x0002223c  ldr      w0, [x19]
0x00022240  ldr      x1, [sp, #0x30]
0x00022244  bl       #0x249c8   ; call _vm_deallocate
0x00022248  mov      w8, #0x59
0x0002224c  str      w8, [sp, #0x30]
0x00022250  ldr      w0, [x19]
0x00022254  add      x2, sp, #0x38
0x00022258  add      x3, sp, #0x30
0x0002225c  mov      w1, #0x16
0x00022260  bl       #0x2498c   ; call _task_info
0x00022264  ldr      d0, [sp, #0xc8]
0x00022268  ucvtf    d0, d0
0x0002226c  mov      x8, #0x3eb0000000000000
0x00022270  fmov     d1, x8
0x00022274  fmul     d0, d0, d1
0x00022278  cmp      w0, #0
0x0002227c  fcsel    d9, d0, d9, eq
0x00022280  adrp     x19, #0x3e000
