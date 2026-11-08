; === sub_4170 @ 0x4170 size=316 ===
0x00004170  stp      x24, x23, [sp, #-0x40]!
0x00004174  stp      x22, x21, [sp, #0x10]
0x00004178  stp      x20, x19, [sp, #0x20]
0x0000417c  stp      x29, x30, [sp, #0x30]
0x00004180  add      x29, sp, #0x30
0x00004184  adrp     x0, #0xe000
0x00004188  add      x0, x0, #0x60e ; -> "@rpath/libroot.dylib"
0x0000418c  mov      w1, #2
0x00004190  bl       #0xd2f0 ; call stub:_dlopen
0x00004194  adrp     x24, #0x18000
0x00004198  adrp     x23, #0x18000
0x0000419c  adrp     x22, #0x18000
0x000041a0  adrp     x21, #0x18000
0x000041a4  adrp     x20, #0x18000
0x000041a8  cbz      x0, #0x4210
0x000041ac  mov      x19, x0
0x000041b0  adrp     x1, #0xe000
0x000041b4  add      x1, x1, #0x623 ; -> "libroot_get_root_prefix"
0x000041b8  bl       #0xd2fc ; call stub:_dlsym
0x000041bc  str      x0, [x24, #0x500]
0x000041c0  adrp     x1, #0xe000
0x000041c4  add      x1, x1, #0x63b ; -> "libroot_get_jbroot_prefix"
0x000041c8  mov      x0, x19
0x000041cc  bl       #0xd2fc ; call stub:_dlsym
0x000041d0  str      x0, [x23, #0x508]
0x000041d4  adrp     x1, #0xe000
0x000041d8  add      x1, x1, #0x655 ; -> "libroot_get_boot_uuid"
0x000041dc  mov      x0, x19
0x000041e0  bl       #0xd2fc ; call stub:_dlsym
0x000041e4  str      x0, [x22, #0x510]
0x000041e8  adrp     x1, #0xe000
0x000041ec  add      x1, x1, #0x66b ; -> "libroot_jbrootpath"
0x000041f0  mov      x0, x19
0x000041f4  bl       #0xd2fc ; call stub:_dlsym
0x000041f8  str      x0, [x21, #0x520]
0x000041fc  adrp     x1, #0xe000
0x00004200  add      x1, x1, #0x67e ; -> "libroot_rootfspath"
0x00004204  mov      x0, x19
0x00004208  bl       #0xd2fc ; call stub:_dlsym
0x0000420c  str      x0, [x20, #0x518]
0x00004210  ldr      x8, [x24, #0x500] ; -> [__DATA,__bss+0x0]
0x00004214  cbz      x8, #0x424c
0x00004218  ldr      x8, [x23, #0x508] ; -> [__DATA,__bss+0x8]
0x0000421c  cbz      x8, #0x4260
0x00004220  ldr      x8, [x22, #0x510] ; -> [__DATA,__bss+0x10]
0x00004224  cbz      x8, #0x4274
0x00004228  ldr      x8, [x21, #0x520] ; -> [__DATA,__bss+0x20]
0x0000422c  cbz      x8, #0x4288
0x00004230  ldr      x8, [x20, #0x518] ; -> [__DATA,__bss+0x18]
0x00004234  cbz      x8, #0x429c
0x00004238  ldp      x29, x30, [sp, #0x30]
0x0000423c  ldp      x20, x19, [sp, #0x20]
0x00004240  ldp      x22, x21, [sp, #0x10]
0x00004244  ldp      x24, x23, [sp], #0x40
0x00004248  ret      
0x0000424c  adrp     x8, #0x4000
0x00004250  add      x8, x8, #0x2ac ; -> __TEXT,__text+0x2ac
0x00004254  str      x8, [x24, #0x500]
0x00004258  ldr      x8, [x23, #0x508] ; -> [__DATA,__bss+0x8]
0x0000425c  cbnz     x8, #0x4220
0x00004260  adrp     x8, #0x4000
0x00004264  add      x8, x8, #0x2b8 ; -> __TEXT,__text+0x2b8
0x00004268  str      x8, [x23, #0x508]
0x0000426c  ldr      x8, [x22, #0x510] ; -> [__DATA,__bss+0x10]
0x00004270  cbnz     x8, #0x4228
0x00004274  adrp     x8, #0x4000
0x00004278  add      x8, x8, #0x2c4 ; -> __TEXT,__text+0x2c4
0x0000427c  str      x8, [x22, #0x510]
0x00004280  ldr      x8, [x21, #0x520] ; -> [__DATA,__bss+0x20]
0x00004284  cbnz     x8, #0x4230
0x00004288  adrp     x8, #0x4000
0x0000428c  add      x8, x8, #0x2d0 ; -> __TEXT,__text+0x2d0
0x00004290  str      x8, [x21, #0x520]
0x00004294  ldr      x8, [x20, #0x518] ; -> [__DATA,__bss+0x18]
0x00004298  cbnz     x8, #0x4238
0x0000429c  adrp     x8, #0x4000
0x000042a0  add      x8, x8, #0x384 ; -> __TEXT,__text+0x384
0x000042a4  str      x8, [x20, #0x518]
0x000042a8  b        #0x4238
