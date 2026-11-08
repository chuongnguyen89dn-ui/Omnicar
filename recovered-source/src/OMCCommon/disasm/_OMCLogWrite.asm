; === _OMCLogWrite @ 0x6be4 size=424 ===
0x00006be4  sub      sp, sp, #0xa0
0x00006be8  stp      x26, x25, [sp, #0x50]
0x00006bec  stp      x24, x23, [sp, #0x60]
0x00006bf0  stp      x22, x21, [sp, #0x70]
0x00006bf4  stp      x20, x19, [sp, #0x80]
0x00006bf8  stp      x29, x30, [sp, #0x90]
0x00006bfc  add      x29, sp, #0x90
0x00006c00  mov      x20, x1
0x00006c04  mov      x19, x0
0x00006c08  bl       #0xd4c4 ; call stub:_objc_retain
0x00006c0c  mov      x0, x20
0x00006c10  bl       #0xd4c4 ; call stub:_objc_retain
0x00006c14  bl       #0x8f7c ; call sub_8f7c
0x00006c18  stp      x19, x20, [sp]
0x00006c1c  adrp     x0, #0x15000
0x00006c20  add      x0, x0, #0x828 ; -> CFSTR("[OmniCar/%@] %@")
0x00006c24  bl       #0xd164 ; call stub:_NSLog
0x00006c28  adrp     x8, #0x18000
0x00006c2c  ldr      x8, [x8, #0x568] ; -> [__DATA,__bss+0x68]
0x00006c30  cmn      x8, #1
0x00006c34  b.ne     #0x6d84
0x00006c38  adrp     x8, #0x18000
0x00006c3c  ldr      x21, [x8, #0x3f0] ; -> [classref(NSString)]
0x00006c40  adrp     x8, #0x18000
0x00006c44  ldr      x22, [x8, #0x560] ; -> [__DATA,__bss+0x60]
0x00006c48  adrp     x8, #0x18000
0x00006c4c  ldr      x0, [x8, #0x460] ; -> [classref(NSDate)]
0x00006c50  bl       #0xd9e0 ; call objc_stub[date]
0x00006c54  mov      x29, x29
0x00006c58  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006c5c  mov      x23, x0
0x00006c60  mov      x0, x22
0x00006c64  mov      x2, x23
0x00006c68  bl       #0xe3e0 ; call objc_stub[stringFromDate:]
0x00006c6c  mov      x29, x29
0x00006c70  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006c74  mov      x22, x0
0x00006c78  adrp     x8, #0x18000
0x00006c7c  ldr      x0, [x8, #0x488] ; -> [classref(NSProcessInfo)]
0x00006c80  bl       #0xe040 ; call objc_stub[processInfo]
0x00006c84  mov      x29, x29
0x00006c88  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006c8c  mov      x24, x0
0x00006c90  bl       #0xe060 ; call objc_stub[processName]
0x00006c94  mov      x29, x29
0x00006c98  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006c9c  mov      x25, x0
0x00006ca0  bl       #0xd350 ; call stub:_getpid
0x00006ca4  stp      x19, x20, [sp, #0x18]
0x00006ca8  stp      x25, x0, [sp, #8]
0x00006cac  str      x22, [sp]
0x00006cb0  adrp     x2, #0x15000
0x00006cb4  add      x2, x2, #0x868 ; -> CFSTR("%@ [%@:%d] %@: %@
")
0x00006cb8  mov      x0, x21
0x00006cbc  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00006cc0  mov      x29, x29
0x00006cc4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006cc8  mov      x21, x0
0x00006ccc  mov      x0, x25
0x00006cd0  bl       #0xd4b8 ; call stub:_objc_release
0x00006cd4  mov      x0, x24
0x00006cd8  bl       #0xd4b8 ; call stub:_objc_release
0x00006cdc  mov      x0, x22
0x00006ce0  bl       #0xd4b8 ; call stub:_objc_release
0x00006ce4  mov      x0, x23
0x00006ce8  bl       #0xd4b8 ; call stub:_objc_release
0x00006cec  bl       #0x6dd0 ; call sub_6dd0
0x00006cf0  mov      x29, x29
0x00006cf4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00006cf8  mov      x22, x0
0x00006cfc  adrp     x8, #0x14000
0x00006d00  ldr      x8, [x8, #0x1a0] ; -> [got(__NSConcreteStackBlock)]
0x00006d04  str      x8, [sp, #0x28]
0x00006d08  adrp     x8, #0xf000
0x00006d0c  ldr      d0, [x8, #0xab8] ; -> [__TEXT,__const+0x8 [u64=0xc2000000 f64=1.6080749353e-314]]
0x00006d10  adrp     x8, #0x6000
0x00006d14  add      x8, x8, #0xe14 ; -> __TEXT,__text+0x2e14
0x00006d18  str      d0, [sp, #0x30]
0x00006d1c  adrp     x9, #0x14000
0x00006d20  add      x9, x9, #0x5e8 ; -> __DATA_CONST,__const+0x1e0 [u64=0x0 f64=0.0]
0x00006d24  stp      x8, x9, [sp, #0x38]
0x00006d28  str      x21, [sp, #0x48]
0x00006d2c  mov      x0, x21
0x00006d30  bl       #0xd4c4 ; call stub:_objc_retain
0x00006d34  add      x1, sp, #0x28
0x00006d38  mov      x0, x22
0x00006d3c  bl       #0xd26c ; call stub:_dispatch_async
0x00006d40  mov      x0, x22
0x00006d44  bl       #0xd4b8 ; call stub:_objc_release
0x00006d48  ldr      x0, [sp, #0x48]
0x00006d4c  bl       #0xd4b8 ; call stub:_objc_release
0x00006d50  mov      x0, x21
0x00006d54  bl       #0xd4b8 ; call stub:_objc_release
0x00006d58  mov      x0, x20
0x00006d5c  bl       #0xd4b8 ; call stub:_objc_release
0x00006d60  mov      x0, x19
0x00006d64  bl       #0xd4b8 ; call stub:_objc_release
0x00006d68  ldp      x29, x30, [sp, #0x90]
0x00006d6c  ldp      x20, x19, [sp, #0x80]
0x00006d70  ldp      x22, x21, [sp, #0x70]
0x00006d74  ldp      x24, x23, [sp, #0x60]
0x00006d78  ldp      x26, x25, [sp, #0x50]
0x00006d7c  add      sp, sp, #0xa0
0x00006d80  ret      
0x00006d84  bl       #0xd050 ; call sub_d050
0x00006d88  b        #0x6c38
