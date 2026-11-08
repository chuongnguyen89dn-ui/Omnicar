; === sub_95bc @ 0x95bc size=548 ===
0x000095bc  stp      x28, x27, [sp, #-0x60]!
0x000095c0  stp      x26, x25, [sp, #0x10]
0x000095c4  stp      x24, x23, [sp, #0x20]
0x000095c8  stp      x22, x21, [sp, #0x30]
0x000095cc  stp      x20, x19, [sp, #0x40]
0x000095d0  stp      x29, x30, [sp, #0x50]
0x000095d4  add      x29, sp, #0x50
0x000095d8  sub      sp, sp, #0x270
0x000095dc  mov      x22, x1
0x000095e0  mov      x23, x0
0x000095e4  adrp     x8, #0x14000
0x000095e8  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x000095ec  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x000095f0  stur     x8, [x29, #-0x60]
0x000095f4  adrp     x8, #0x18000
0x000095f8  ldr      x0, [x8, #0x5f0] ; -> [__DATA,__bss+0xf0]
0x000095fc  mov      w8, #0x1a4
0x00009600  str      x8, [sp]
0x00009604  mov      w1, #0x209
0x00009608  bl       #0xd50c ; call stub:_open
0x0000960c  tbnz     w0, #0x1f, #0x9790
0x00009610  mov      x20, x0
0x00009614  add      x0, sp, #0x60
0x00009618  mov      w1, #0x40
0x0000961c  bl       #0xd1f4 ; call stub:_backtrace
0x00009620  mov      x21, x0
0x00009624  mov      x8, x23
0x00009628  str      x8, [sp]
0x0000962c  adrp     x2, #0xf000
0x00009630  add      x2, x2, #0x46e ; -> "signal-%d"
0x00009634  add      x0, sp, #0x30
0x00009638  mov      w1, #0x30
0x0000963c  bl       #0xd578 ; call stub:_snprintf
0x00009640  add      x1, sp, #0x30
0x00009644  add      x2, sp, #0x60
0x00009648  mov      x0, x20
0x0000964c  mov      x3, x21
0x00009650  bl       #0x9a54 ; call sub_9a54
0x00009654  cbz      x22, #0x9664
0x00009658  ldr      w19, [x22, #8]
0x0000965c  ldr      x22, [x22, #0x18]
0x00009660  b        #0x9668
0x00009664  mov      w19, #0
0x00009668  bl       #0xd350 ; call stub:_getpid
0x0000966c  stp      x22, x0, [sp, #0x10]
0x00009670  stp      x23, x19, [sp]
0x00009674  str      x23, [sp, #0x20]
0x00009678  adrp     x1, #0xf000
0x0000967c  add      x1, x1, #0x478 ; -> "signal %d (code %d) addr %p pid %d
"
0x00009680  mov      x0, x20
0x00009684  bl       #0xd308 ; call stub:_dprintf
0x00009688  add      x0, sp, #0x60
0x0000968c  mov      x1, x21
0x00009690  mov      x2, x20
0x00009694  bl       #0xd200 ; call stub:_backtrace_symbols_fd
0x00009698  bl       #0xd1e8 ; call stub:__dyld_image_count
0x0000969c  cbz      w0, #0x9784
0x000096a0  mov      w21, #0
0x000096a4  adrp     x22, #0xf000
0x000096a8  add      x22, x22, #0x49c ; -> "__DATA"
0x000096ac  adrp     x23, #0xf000
0x000096b0  add      x23, x23, #0x4a3 ; -> "__crash_info"
0x000096b4  adrp     x27, #0xf000
0x000096b8  add      x27, x27, #0x4d2 ; -> "?"
0x000096bc  adrp     x25, #0xf000
0x000096c0  add      x25, x25, #0x4bd ; -> "crash_info [%s]: %s
"
0x000096c4  mov      x0, x21
0x000096c8  bl       #0xd1d0 ; call stub:__dyld_get_image_header
0x000096cc  cbz      x0, #0x9774
0x000096d0  mov      x26, x0
0x000096d4  str      xzr, [sp, #0x28]
0x000096d8  add      x3, sp, #0x28
0x000096dc  mov      x1, x22
0x000096e0  mov      x2, x23
0x000096e4  bl       #0xd35c ; call stub:_getsectiondata
0x000096e8  cbnz     x0, #0x9704
0x000096ec  add      x3, sp, #0x28
0x000096f0  mov      x0, x26
0x000096f4  adrp     x1, #0xf000
0x000096f8  add      x1, x1, #0x4b0 ; -> "__DATA_DIRTY"
0x000096fc  mov      x2, x23
0x00009700  bl       #0xd35c ; call stub:_getsectiondata
0x00009704  cbz      x0, #0x9774
0x00009708  ldr      x8, [sp, #0x28]
0x0000970c  cmp      x8, #0x28
0x00009710  b.lo     #0x9774
0x00009714  ldr      x28, [x0, #8]
0x00009718  ldr      x24, [x0, #0x20]
0x0000971c  mov      w8, #1
0x00009720  mov      x19, x8
0x00009724  cbz      x28, #0x9768
0x00009728  ldrb     w8, [x28]
0x0000972c  cbz      w8, #0x9768
0x00009730  mov      x0, x21
0x00009734  bl       #0xd1dc ; call stub:__dyld_get_image_name
0x00009738  cbz      x0, #0x974c
0x0000973c  mov      x26, x0
0x00009740  mov      w1, #0x2f
0x00009744  bl       #0xd5c0 ; call stub:_strrchr
0x00009748  b        #0x9750
0x0000974c  mov      x26, x27
0x00009750  cmp      x0, #0
0x00009754  csinc    x8, x26, x0, eq
0x00009758  stp      x8, x28, [sp]
0x0000975c  mov      x0, x20
0x00009760  mov      x1, x25
0x00009764  bl       #0xd308 ; call stub:_dprintf
0x00009768  mov      w8, #0
0x0000976c  mov      x28, x24
0x00009770  tbnz     w19, #0, #0x9720
0x00009774  add      w21, w21, #1
0x00009778  bl       #0xd1e8 ; call stub:__dyld_image_count
0x0000977c  cmp      w21, w0
0x00009780  b.lo     #0x96c4
0x00009784  mov      x0, x20
0x00009788  bl       #0xd254 ; call stub:_close
0x0000978c  ldr      x23, [sp, #0x20]
0x00009790  mov      x0, x23
0x00009794  mov      x1, #0
0x00009798  bl       #0xd56c ; call stub:_signal
0x0000979c  mov      x0, x23
0x000097a0  bl       #0xd53c ; call stub:_raise
0x000097a4  ldur     x8, [x29, #-0x60]
0x000097a8  adrp     x9, #0x14000
0x000097ac  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x000097b0  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x000097b4  cmp      x9, x8
0x000097b8  b.ne     #0x97dc
0x000097bc  add      sp, sp, #0x270
0x000097c0  ldp      x29, x30, [sp, #0x50]
0x000097c4  ldp      x20, x19, [sp, #0x40]
0x000097c8  ldp      x22, x21, [sp, #0x30]
0x000097cc  ldp      x24, x23, [sp, #0x20]
0x000097d0  ldp      x26, x25, [sp, #0x10]
0x000097d4  ldp      x28, x27, [sp], #0x60
0x000097d8  ret      
0x000097dc  bl       #0xd1b8 ; call stub:___stack_chk_fail
