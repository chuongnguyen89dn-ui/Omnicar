; ==== sub_24184 @ 0x24184..0x24254 (208 bytes) ====
0x00024184  mov      x29, x29
0x00024188  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0002418c  adrp     x9, #0x3e000
0x00024190  ldr      x8, [x9, #0xc78]
0x00024194  str      x0, [x9, #0xc78]
0x00024198  mov      x0, x8
0x0002419c  ldp      x29, x30, [sp], #0x10
0x000241a0  b        #0x2480c   ; call _objc_release
0x000241a4  adrp     x0, #0x3e000
0x000241a8  add      x0, x0, #0xa28
0x000241ac  adrp     x1, #0x34000
0x000241b0  add      x1, x1, #0x7f0
0x000241b4  b        #0x24578   ; call _dispatch_once
0x000241b8  adrp     x0, #0x3e000
0x000241bc  add      x0, x0, #0xa38
0x000241c0  adrp     x1, #0x34000
0x000241c4  add      x1, x1, #0x840
0x000241c8  b        #0x24578   ; call _dispatch_once
0x000241cc  adrp     x0, #0x3e000
0x000241d0  add      x0, x0, #0xa58
0x000241d4  adrp     x1, #0x34000
0x000241d8  add      x1, x1, #0xaf0
0x000241dc  b        #0x24578   ; call _dispatch_once
0x000241e0  stp      x29, x30, [sp, #-0x10]!
0x000241e4  mov      x29, sp
0x000241e8  adrp     x0, #0x3e000
0x000241ec  add      x0, x0, #0xa80
0x000241f0  adrp     x1, #0x34000
0x000241f4  add      x1, x1, #0xb60
0x000241f8  bl       #0x24578   ; call _dispatch_once
0x000241fc  ldp      x29, x30, [sp], #0x10
0x00024200  ret      
0x00024204  adrp     x0, #0x3e000
0x00024208  add      x0, x0, #0xa68
0x0002420c  adrp     x1, #0x34000
0x00024210  add      x1, x1, #0xb40
0x00024214  b        #0x24578   ; call _dispatch_once
0x00024218  adrp     x0, #0x3e000
0x0002421c  add      x0, x0, #0xaa8
0x00024220  adrp     x1, #0x34000
0x00024224  add      x1, x1, #0xb80
0x00024228  b        #0x24578   ; call _dispatch_once
0x0002422c  adrp     x0, #0x3e000
0x00024230  add      x0, x0, #0xb08
0x00024234  adrp     x1, #0x34000
0x00024238  add      x1, x1, #0xc10
0x0002423c  b        #0x24578   ; call _dispatch_once
0x00024240  b        #0x23578   ; call sub_23578
0x00024244  b        #0x23578   ; call sub_23578
0x00024248  b        #0x23578   ; call sub_23578
0x0002424c  adrp     x0, #0x3e000
0x00024250  add      x0, x0, #0xac0
