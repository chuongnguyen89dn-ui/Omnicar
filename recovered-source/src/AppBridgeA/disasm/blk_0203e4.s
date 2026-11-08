; block literal @0x34c10 desc @0x34610 sig=v8@?0 flags=0x50000000
; ==== sub_203e4 @ 0x203e4..0x20414 (48 bytes) ====
0x000203e4  stp      x29, x30, [sp, #-0x10]!
0x000203e8  mov      x29, sp
0x000203ec  adrp     x0, #0x2a000
0x000203f0  add      x0, x0, #0x9cb   ; -> "com.anlai.omnicar.log"
0x000203f4  mov      x1, #0
0x000203f8  bl       #0x24584   ; call _dispatch_queue_create
0x000203fc  adrp     x9, #0x3e000
0x00020400  ldr      x8, [x9, #0xb00]
0x00020404  str      x0, [x9, #0xb00]
0x00020408  mov      x0, x8
0x0002040c  ldp      x29, x30, [sp], #0x10
0x00020410  b        #0x2480c   ; call _objc_release

