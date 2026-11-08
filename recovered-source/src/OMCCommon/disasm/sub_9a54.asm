; === sub_9a54 @ 0x9a54 size=364 ===
0x00009a54  sub      sp, sp, #0xe0
0x00009a58  stp      x26, x25, [sp, #0x90]
0x00009a5c  stp      x24, x23, [sp, #0xa0]
0x00009a60  stp      x22, x21, [sp, #0xb0]
0x00009a64  stp      x20, x19, [sp, #0xc0]
0x00009a68  stp      x29, x30, [sp, #0xd0]
0x00009a6c  add      x29, sp, #0xd0
0x00009a70  mov      x20, x1
0x00009a74  mov      x19, x0
0x00009a78  adrp     x8, #0x14000
0x00009a7c  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x00009a80  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x00009a84  stur     x8, [x29, #-0x48]
0x00009a88  strb     wzr, [sp, #0x48]
0x00009a8c  cmp      w3, #1
0x00009a90  b.lt     #0x9b50
0x00009a94  mov      x21, x2
0x00009a98  mov      w26, w3
0x00009a9c  adrp     x22, #0xf000
0x00009aa0  add      x22, x22, #0x45f ; -> "OmniCar"
0x00009aa4  adrp     x23, #0xf000
0x00009aa8  add      x23, x23, #0x467 ; -> ".dylib"
0x00009aac  ldr      x0, [x21], #8
0x00009ab0  add      x1, sp, #0x28
0x00009ab4  bl       #0xd2e4 ; call stub:_dladdr
0x00009ab8  ldr      x24, [sp, #0x28]
0x00009abc  cmp      w0, #0
0x00009ac0  ccmp     x24, #0, #4, ne
0x00009ac4  b.eq     #0x9b18
0x00009ac8  mov      x0, x24
0x00009acc  mov      w1, #0x2f
0x00009ad0  bl       #0xd5c0 ; call stub:_strrchr
0x00009ad4  cmp      x0, #0
0x00009ad8  csinc    x24, x24, x0, eq
0x00009adc  mov      x0, x24
0x00009ae0  bl       #0xd5a8 ; call stub:_strlen
0x00009ae4  mov      x25, x0
0x00009ae8  mov      x0, x24
0x00009aec  mov      x1, x22
0x00009af0  mov      w2, #7
0x00009af4  bl       #0xd5b4 ; call stub:_strncmp
0x00009af8  cmp      w0, #0
0x00009afc  ccmp     x25, #0xe, #0, eq
0x00009b00  b.lo     #0x9b18
0x00009b04  add      x8, x24, x25
0x00009b08  sub      x0, x8, #6
0x00009b0c  mov      x1, x23
0x00009b10  bl       #0xd584 ; call stub:_strcmp
0x00009b14  cbz      w0, #0x9b24
0x00009b18  subs     x26, x26, #1
0x00009b1c  b.ne     #0x9aac
0x00009b20  b        #0x9b50
0x00009b24  sub      x8, x25, #0xd
0x00009b28  cmp      x8, #0x3f
0x00009b2c  mov      w9, #0x3f
0x00009b30  csel     x21, x8, x9, lo
0x00009b34  add      x22, sp, #0x48
0x00009b38  add      x0, sp, #0x48
0x00009b3c  add      x1, x24, #7
0x00009b40  mov      x2, x21
0x00009b44  mov      w3, #0x40
0x00009b48  bl       #0xd1ac ; call stub:___memcpy_chk
0x00009b4c  strb     wzr, [x22, x21]
0x00009b50  mov      x0, #0
0x00009b54  bl       #0xd608 ; call stub:_time
0x00009b58  adrp     x8, #0x18000
0x00009b5c  ldr      x8, [x8, #0x5f0] ; -> [__DATA,__bss+0xf0]
0x00009b60  ldr      x9, [x8, #0x440] ; -> [classref(NSTimeZone)]
0x00009b64  sub      x9, x0, x9
0x00009b68  add      x8, x8, #0x400 ; -> classref(NSBundle)
0x00009b6c  stp      x8, x20, [sp, #0x10]
0x00009b70  add      x8, sp, #0x48
0x00009b74  stp      x9, x8, [sp]
0x00009b78  adrp     x1, #0xf000
0x00009b7c  add      x1, x1, #0x432 ; -> "omc-crash age=%ld suspect=%s last=%s how=%s
"
0x00009b80  mov      x0, x19
0x00009b84  bl       #0xd308 ; call stub:_dprintf
0x00009b88  ldur     x8, [x29, #-0x48]
0x00009b8c  adrp     x9, #0x14000
0x00009b90  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x00009b94  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x00009b98  cmp      x9, x8
0x00009b9c  b.ne     #0x9bbc
0x00009ba0  ldp      x29, x30, [sp, #0xd0]
0x00009ba4  ldp      x20, x19, [sp, #0xc0]
0x00009ba8  ldp      x22, x21, [sp, #0xb0]
0x00009bac  ldp      x24, x23, [sp, #0xa0]
0x00009bb0  ldp      x26, x25, [sp, #0x90]
0x00009bb4  add      sp, sp, #0xe0
0x00009bb8  ret      
0x00009bbc  bl       #0xd1b8 ; call stub:___stack_chk_fail
