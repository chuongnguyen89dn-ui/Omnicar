; ==== sub_129b0 @ 0x129b0..0x129e8 (56 bytes) ====
0x000129b0  bl       #0x24488   ; call ___stack_chk_fail
0x000129b4  b        #0x129bc   ; call sub_129bc
0x000129b8  b        #0x129bc   ; call sub_129bc
0x000129bc  mov      x20, x0
0x000129c0  mov      x0, x19
0x000129c4  bl       #0x2480c   ; call _objc_release
0x000129c8  b        #0x129d0   ; call sub_129d0
0x000129cc  mov      x20, x0
0x000129d0  mov      x0, x20
0x000129d4  bl       #0x24470   ; call __Unwind_Resume
0x000129d8  stp      d11, d10, [sp, #-0x50]!
0x000129dc  stp      d9, d8, [sp, #0x10]
0x000129e0  stp      x22, x21, [sp, #0x20]
0x000129e4  stp      x20, x19, [sp, #0x30]
