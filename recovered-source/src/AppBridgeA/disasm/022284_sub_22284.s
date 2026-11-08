; ==== sub_22284 @ 0x22284..0x22360 (220 bytes) ====
0x00022284  ldr      w0, [x19, #0xc20]
0x00022288  cbnz     w0, #0x222a4
0x0002228c  bl       #0x24698   ; call _mach_host_self
0x00022290  str      w0, [x19, #0xc20]
0x00022294  adrp     x1, #0x3e000
0x00022298  add      x1, x1, #0xc28
0x0002229c  bl       #0x2465c   ; call _host_page_size
0x000222a0  ldr      w0, [x19, #0xc20]
0x000222a4  mov      w8, #0x26
0x000222a8  str      w8, [sp, #0x30]
0x000222ac  add      x2, sp, #0x38
0x000222b0  add      x3, sp, #0x30
0x000222b4  mov      w1, #4
0x000222b8  bl       #0x24668   ; call _host_statistics64
0x000222bc  fmov     d10, #-1.00000000
0x000222c0  cbnz     w0, #0x222f0
0x000222c4  ldr      w8, [sp, #0x38]
0x000222c8  ldr      w9, [sp, #0x40]
0x000222cc  add      w8, w9, w8
0x000222d0  ucvtf    d0, w8
0x000222d4  adrp     x8, #0x3e000
0x000222d8  ldr      d1, [x8, #0xc28]
0x000222dc  ucvtf    d1, d1
0x000222e0  fmul     d0, d0, d1
0x000222e4  mov      x8, #0x3eb0000000000000
0x000222e8  fmov     d1, x8
0x000222ec  fmul     d10, d0, d1
0x000222f0  bl       #0x248c0   ; call _os_proc_available_memory
0x000222f4  ucvtf    d0, x0, #0x14
0x000222f8  adrp     x8, #0x34000
0x000222fc  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x00022300  str      x8, [sp, #0x38]
0x00022304  adrp     x8, #0x2b000
0x00022308  ldr      d1, [x8, #0x1e8]
0x0002230c  str      d1, [sp, #0x40]
0x00022310  adrp     x8, #0x22000
0x00022314  add      x8, x8, #0x584
0x00022318  adrp     x9, #0x34000
0x0002231c  add      x9, x9, #0xcf0
0x00022320  stp      x8, x9, [sp, #0x48]
0x00022324  stp      d8, d9, [sp, #0x58]
0x00022328  stp      d0, d10, [sp, #0x68]
0x0002232c  adrp     x0, #0x34000
0x00022330  ldr      x0, [x0, #0x290]   ; -> [got:__dispatch_main_q]
0x00022334  add      x1, sp, #0x38
0x00022338  bl       #0x24554   ; call _dispatch_async
0x0002233c  add      sp, sp, #0x1a0
0x00022340  ldp      x29, x30, [sp, #0x50]
0x00022344  ldp      x20, x19, [sp, #0x40]
0x00022348  ldp      x22, x21, [sp, #0x30]
0x0002234c  ldp      x28, x27, [sp, #0x20]
0x00022350  ldp      d9, d8, [sp, #0x10]
0x00022354  ldp      d11, d10, [sp], #0x60
0x00022358  ret      
0x0002235c  stp      x29, x30, [sp, #-0x10]!
