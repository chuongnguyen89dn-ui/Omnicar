; === _OMCLogoMeshImage @ 0xcb38 size=148 ===
0x0000cb38  sub      sp, sp, #0x50
0x0000cb3c  stp      x20, x19, [sp, #0x30]
0x0000cb40  stp      x29, x30, [sp, #0x40]
0x0000cb44  add      x29, sp, #0x40
0x0000cb48  mov      x19, x0
0x0000cb4c  adrp     x8, #0x18000
0x0000cb50  add      x8, x8, #0x718 ; -> __DATA,__bss+0x218
0x0000cb54  add      x0, x8, w0, uxtw #3
0x0000cb58  adrp     x8, #0x14000
0x0000cb5c  ldr      x8, [x8, #0x1a0] ; -> [got(__NSConcreteStackBlock)]
0x0000cb60  str      x8, [sp, #8]
0x0000cb64  adrp     x8, #0xf000
0x0000cb68  ldr      d0, [x8, #0xac8] ; -> [__TEXT,__const+0x18 [u64=0xc0000000 f64=1.591496843e-314]]
0x0000cb6c  str      d0, [sp, #0x10]
0x0000cb70  adrp     x8, #0xc000
0x0000cb74  add      x8, x8, #0xbcc ; -> __TEXT,__text+0x8bcc
0x0000cb78  adrp     x9, #0x14000
0x0000cb7c  add      x9, x9, #0x848 ; -> __DATA_CONST,__const+0x440 [u64=0x0 f64=0.0]
0x0000cb80  stp      x8, x9, [sp, #0x18]
0x0000cb84  strb     w19, [sp, #0x2c]
0x0000cb88  str      w19, [sp, #0x28]
0x0000cb8c  ldr      x8, [x0]
0x0000cb90  cmn      x8, #1
0x0000cb94  b.ne     #0xcbc0
0x0000cb98  adrp     x8, #0x18000
0x0000cb9c  add      x8, x8, #0x708 ; -> __DATA,__bss+0x208
0x0000cba0  ldr      x19, [x8, w19, uxtw #3] ; -> [__DATA,__bss+0x208]
0x0000cba4  mov      x0, x19
0x0000cba8  bl       #0xd4c4 ; call stub:_objc_retain
0x0000cbac  mov      x0, x19
0x0000cbb0  ldp      x29, x30, [sp, #0x40]
0x0000cbb4  ldp      x20, x19, [sp, #0x30]
0x0000cbb8  add      sp, sp, #0x50
0x0000cbbc  b        #0xd434 ; call stub:_objc_autoreleaseReturnValue
0x0000cbc0  add      x1, sp, #8
0x0000cbc4  bl       #0xd284 ; call stub:_dispatch_once
0x0000cbc8  b        #0xcb98
