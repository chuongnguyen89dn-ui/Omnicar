; === sub_9bc0 @ 0x9bc0 size=4148 ===
0x00009bc0  stp      d9, d8, [sp, #-0x70]!
0x00009bc4  stp      x28, x27, [sp, #0x10]
0x00009bc8  stp      x26, x25, [sp, #0x20]
0x00009bcc  stp      x24, x23, [sp, #0x30]
0x00009bd0  stp      x22, x21, [sp, #0x40]
0x00009bd4  stp      x20, x19, [sp, #0x50]
0x00009bd8  stp      x29, x30, [sp, #0x60]
0x00009bdc  add      x29, sp, #0x60
0x00009be0  sub      sp, sp, #0x2d0
0x00009be4  adrp     x8, #0x14000
0x00009be8  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x00009bec  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x00009bf0  stur     x8, [x29, #-0x70]
0x00009bf4  movi     v0.16b, #0
0x00009bf8  stp      q0, q0, [sp, #0x80]
0x00009bfc  stp      q0, q0, [sp, #0xa0]
0x00009c00  adrp     x8, #0x18000
0x00009c04  ldr      x0, [x8, #0x4b8] ; -> [classref(UIScreen)]
0x00009c08  bl       #0xe1c0 ; call objc_stub[screens]
0x00009c0c  mov      x29, x29
0x00009c10  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00009c14  add      x2, sp, #0x80
0x00009c18  add      x3, sp, #0x100
0x00009c1c  str      x0, [sp, #0x28]
0x00009c20  mov      w4, #0x10
0x00009c24  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00009c28  str      x0, [sp, #0x50]
0x00009c2c  ldr      x8, [sp, #0x50]
0x00009c30  cbz      x8, #0xab94
0x00009c34  ldr      x8, [sp, #0x90]
0x00009c38  ldr      x8, [x8] ; -> [selref(CGContext)]
0x00009c3c  str      x8, [sp, #0x48]
0x00009c40  fmov     d8, #1.00000000
0x00009c44  adrp     x24, #0x18000
0x00009c48  str      xzr, [sp, #0x68]
0x00009c4c  ldr      x8, [sp, #0x90]
0x00009c50  ldr      x8, [x8] ; -> [selref(CGContext)]
0x00009c54  ldr      x9, [sp, #0x48]
0x00009c58  cmp      x8, x9
0x00009c5c  b.eq     #0x9c68
0x00009c60  ldr      x0, [sp, #0x28]
0x00009c64  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x00009c68  ldr      x8, [sp, #0x88]
0x00009c6c  ldr      x9, [sp, #0x68]
0x00009c70  ldr      x19, [x8, x9, lsl #3] ; -> [selref(CGContext)]
0x00009c74  mov      x0, x19
0x00009c78  bl       #0xd4c4 ; call stub:_objc_retain
0x00009c7c  str      x19, [sp, #0x70]
0x00009c80  cbz      x19, #0xaadc
0x00009c84  adrp     x8, #0x18000
0x00009c88  ldr      x0, [x8, #0x4b8] ; -> [classref(UIScreen)]
0x00009c8c  bl       #0xdda0 ; call objc_stub[mainScreen]
0x00009c90  mov      x29, x29
0x00009c94  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00009c98  ldr      x8, [sp, #0x70]
0x00009c9c  cmp      x8, x0
0x00009ca0  cset     w19, eq
0x00009ca4  bl       #0xd4b8 ; call stub:_objc_release
0x00009ca8  tbnz     w19, #0, #0xaadc
0x00009cac  ldr      x19, [sp, #0x70]
0x00009cb0  mov      x0, x19
0x00009cb4  bl       #0xd4c4 ; call stub:_objc_retain
0x00009cb8  adrp     x8, #0x18000
0x00009cbc  ldr      x8, [x8, #0x588] ; -> [__DATA,__bss+0x88]
0x00009cc0  cbnz     x8, #0xa068
0x00009cc4  mov      x0, x19
0x00009cc8  bl       #0xd4c4 ; call stub:_objc_retain
0x00009ccc  adrp     x8, #0x18000
0x00009cd0  ldr      x0, [x8, #0x588] ; -> [__DATA,__bss+0x88]
0x00009cd4  str      x19, [x8, #0x588]
0x00009cd8  bl       #0xd4b8 ; call stub:_objc_release
0x00009cdc  adrp     x9, #0x18000
0x00009ce0  ldr      x8, [x9, #0x608] ; -> [__DATA,__bss+0x108]
0x00009ce4  add      x8, x8, #1 ; -> __DATA,__objc_selrefs+0x1
0x00009ce8  str      x8, [x9, #0x608]
0x00009cec  adrp     x8, #0x18000
0x00009cf0  ldr      x0, [x8, #0x460] ; -> [classref(NSDate)]
0x00009cf4  bl       #0xd9e0 ; call objc_stub[date]
0x00009cf8  mov      x29, x29
0x00009cfc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00009d00  adrp     x9, #0x18000
0x00009d04  ldr      x8, [x9, #0x5a0] ; -> [__DATA,__bss+0xa0]
0x00009d08  str      x0, [x9, #0x5a0]
0x00009d0c  mov      x0, x8
0x00009d10  bl       #0xd4b8 ; call stub:_objc_release
0x00009d14  adrp     x8, #0x18000
0x00009d18  ldr      x0, [x8, #0x490] ; -> [classref(NSMutableOrderedSet)]
0x00009d1c  bl       #0xdf80 ; call objc_stub[orderedSet]
0x00009d20  mov      x29, x29
0x00009d24  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00009d28  mov      x19, x0
0x00009d2c  bl       #0xd1e8 ; call stub:__dyld_image_count
0x00009d30  cbz      w0, #0x9df4
0x00009d34  mov      w20, #0
0x00009d38  mov      x0, x20
0x00009d3c  bl       #0xd1dc ; call stub:__dyld_get_image_name
0x00009d40  mov      x22, x0
0x00009d44  cbz      x0, #0x9de4
0x00009d48  mov      x0, x22
0x00009d4c  adrp     x1, #0xf000
0x00009d50  add      x1, x1, #0x5cf ; -> "/DynamicLibraries/"
0x00009d54  bl       #0xd5cc ; call stub:_strstr
0x00009d58  cbnz     x0, #0x9d70
0x00009d5c  mov      x0, x22
0x00009d60  adrp     x1, #0xf000
0x00009d64  add      x1, x1, #0x5e2 ; -> "/TweakInject/"
0x00009d68  bl       #0xd5cc ; call stub:_strstr
0x00009d6c  cbz      x0, #0x9de4
0x00009d70  adrp     x8, #0x18000
0x00009d74  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x00009d78  mov      x2, x22
0x00009d7c  bl       #0xe440 ; call objc_stub[stringWithUTF8String:]
0x00009d80  mov      x29, x29
0x00009d84  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00009d88  mov      x23, x0
0x00009d8c  bl       #0xdcc0 ; call objc_stub[lastPathComponent]
0x00009d90  mov      x29, x29
0x00009d94  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00009d98  mov      x21, x0
0x00009d9c  bl       #0xe3c0 ; call objc_stub[stringByDeletingPathExtension]
0x00009da0  mov      x29, x29
0x00009da4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00009da8  mov      x22, x0
0x00009dac  mov      x0, x21
0x00009db0  bl       #0xd4b8 ; call stub:_objc_release
0x00009db4  mov      x0, x23
0x00009db8  bl       #0xd4b8 ; call stub:_objc_release
0x00009dbc  mov      x0, x22
0x00009dc0  adrp     x2, #0x16000
0x00009dc4  add      x2, x2, #0xc8 ; -> CFSTR("OmniCar")
0x00009dc8  bl       #0xdba0 ; call objc_stub[hasPrefix:]
0x00009dcc  tbnz     w0, #0, #0x9ddc
0x00009dd0  mov      x0, x19
0x00009dd4  mov      x2, x22
0x00009dd8  bl       #0xd6a0 ; call objc_stub[addObject:]
0x00009ddc  mov      x0, x22
0x00009de0  bl       #0xd4b8 ; call stub:_objc_release
0x00009de4  bl       #0xd1e8 ; call stub:__dyld_image_count
0x00009de8  add      w20, w20, #1
0x00009dec  cmp      w20, w0
0x00009df0  b.lo     #0x9d38
0x00009df4  mov      x0, x19
0x00009df8  bl       #0xd740 ; call objc_stub[array]
0x00009dfc  mov      x29, x29
0x00009e00  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00009e04  mov      x20, x0
0x00009e08  mov      x0, x19
0x00009e0c  bl       #0xd4b8 ; call stub:_objc_release
0x00009e10  adrp     x8, #0x18000
0x00009e14  ldr      x0, [x8, #0x5a8] ; -> [__DATA,__bss+0xa8]
0x00009e18  str      x20, [x8, #0x5a8]
0x00009e1c  bl       #0xd4b8 ; call stub:_objc_release
0x00009e20  adrp     x8, #0x18000
0x00009e24  ldr      x0, [x8, #0x470] ; -> [classref(NSMutableDictionary)]
0x00009e28  bl       #0xda80 ; call objc_stub[dictionary]
0x00009e2c  mov      x29, x29
0x00009e30  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00009e34  adrp     x9, #0x18000
0x00009e38  ldr      x8, [x9, #0x5b0] ; -> [__DATA,__bss+0xb0]
0x00009e3c  str      x0, [x9, #0x5b0]
0x00009e40  mov      x0, x8
0x00009e44  bl       #0xd4b8 ; call stub:_objc_release
0x00009e48  ldr      x0, [sp, #0x70]
0x00009e4c  bl       #0xddc0 ; call objc_stub[maximumFramesPerSecond]
0x00009e50  cmp      x0, #1
0x00009e54  csinc    x8, x0, xzr, gt
0x00009e58  ucvtf    d0, x8
0x00009e5c  fdiv     d0, d8, d0
0x00009e60  adrp     x8, #0x18000
0x00009e64  str      d0, [x8, #0x610]
0x00009e68  adrp     x8, #0x18000
0x00009e6c  str      xzr, [x8, #0x618]
0x00009e70  adrp     x8, #0x18000
0x00009e74  str      xzr, [x8, #0x620]
0x00009e78  adrp     x8, #0x18000
0x00009e7c  str      xzr, [x8, #0x628]
0x00009e80  adrp     x8, #0x18000
0x00009e84  str      xzr, [x8, #0x630]
0x00009e88  adrp     x8, #0x18000
0x00009e8c  str      xzr, [x8, #0x638]
0x00009e90  adrp     x8, #0x18000
0x00009e94  str      xzr, [x8, #0x640]
0x00009e98  adrp     x8, #0x18000
0x00009e9c  str      xzr, [x8, #0x648]
0x00009ea0  adrp     x8, #0x18000
0x00009ea4  str      xzr, [x8, #0x650]
0x00009ea8  adrp     x8, #0x18000
0x00009eac  str      xzr, [x8, #0x658]
0x00009eb0  adrp     x8, #0x18000
0x00009eb4  str      xzr, [x8, #0x660]
0x00009eb8  adrp     x8, #0x18000
0x00009ebc  str      xzr, [x8, #0x668]
0x00009ec0  adrp     x8, #0x18000
0x00009ec4  mov      x9, #0x7fefffffffffffff
0x00009ec8  str      x9, [x8, #0x670]
0x00009ecc  adrp     x8, #0x18000
0x00009ed0  str      x9, [x8, #0x678]
0x00009ed4  adrp     x8, #0x18000
0x00009ed8  str      xzr, [x8, #0x680]
0x00009edc  adrp     x8, #0x18000
0x00009ee0  str      xzr, [x8, #0x688]
0x00009ee4  adrp     x8, #0x18000
0x00009ee8  strb     wzr, [x8, #0x690]
0x00009eec  adrp     x8, #0x18000
0x00009ef0  str      xzr, [x8, #0x698]
0x00009ef4  adrp     x8, #0x18000
0x00009ef8  str      xzr, [x8, #0x6a0]
0x00009efc  adrp     x8, #0x18000
0x00009f00  mov      x9, #-0x4010000000000000
0x00009f04  str      x9, [x8, #0x6a8]
0x00009f08  adrp     x8, #0x18000
0x00009f0c  add      x8, x8, #0x6b0 ; -> __DATA,__bss+0x1b0
0x00009f10  stp      xzr, xzr, [x8, #8]
0x00009f14  str      xzr, [x8]
0x00009f18  adrp     x8, #0x18000
0x00009f1c  str      xzr, [x8, #0x6c8]
0x00009f20  adrp     x8, #0x18000
0x00009f24  ldr      x0, [x8, #0x5b8] ; -> [__DATA,__bss+0xb8]
0x00009f28  str      xzr, [x8, #0x5b8]
0x00009f2c  bl       #0xd4b8 ; call stub:_objc_release
0x00009f30  adrp     x8, #0x18000
0x00009f34  strb     wzr, [x8, #0x6d0]
0x00009f38  mov      w0, #0
0x00009f3c  bl       #0xaee4 ; call sub_aee4
0x00009f40  adrp     x8, #0x18000
0x00009f44  add      x8, x8, #0x6d1 ; -> __DATA,__bss+0x1d1
0x00009f48  stlrb    wzr, [x8]
0x00009f4c  adrp     x0, #0xf000
0x00009f50  add      x0, x0, #0x580 ; -> "com.anlai.omnicar.perf"
0x00009f54  mov      x1, #0
0x00009f58  bl       #0xd290 ; call stub:_dispatch_queue_create
0x00009f5c  mov      x19, x0
0x00009f60  adrp     x0, #0x14000
0x00009f64  ldr      x0, [x0, #0x1d8] ; -> [got(__dispatch_source_type_timer)]
0x00009f68  mov      x1, #0
0x00009f6c  mov      x2, #0
0x00009f70  mov      x3, x19
0x00009f74  bl       #0xd2b4 ; call stub:_dispatch_source_create
0x00009f78  adrp     x9, #0x18000
0x00009f7c  ldr      x8, [x9, #0x598] ; -> [__DATA,__bss+0x98]
0x00009f80  str      x0, [x9, #0x598]
0x00009f84  mov      x0, x8
0x00009f88  bl       #0xd4b8 ; call stub:_objc_release
0x00009f8c  adrp     x21, #0x18000
0x00009f90  ldr      x20, [x21, #0x598] ; -> [__DATA,__bss+0x98]
0x00009f94  mov      x0, #0
0x00009f98  mov      w1, #0xb280
0x00009f9c  movk     w1, #0xee6, lsl #16
0x00009fa0  bl       #0xd2d8 ; call stub:_dispatch_time
0x00009fa4  mov      x1, x0
0x00009fa8  mov      x0, x20
0x00009fac  mov      w2, #0xb280
0x00009fb0  movk     w2, #0xee6, lsl #16
0x00009fb4  mov      w3, #0xf080
0x00009fb8  movk     w3, #0x2fa, lsl #16
0x00009fbc  bl       #0xd2cc ; call stub:_dispatch_source_set_timer
0x00009fc0  ldr      x0, [x21, #0x598] ; -> [__DATA,__bss+0x98]
0x00009fc4  adrp     x1, #0x14000
0x00009fc8  add      x1, x1, #0x788 ; -> __DATA_CONST,__const+0x380 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x00009fcc  bl       #0xd2c0 ; call stub:_dispatch_source_set_event_handler
0x00009fd0  ldr      x0, [x21, #0x598] ; -> [__DATA,__bss+0x98]
0x00009fd4  bl       #0xd29c ; call stub:_dispatch_resume
0x00009fd8  adrp     x0, #0xe000
0x00009fdc  add      x0, x0, #0x776 ; -> "com.anlai.omnicar/car.connected"
0x00009fe0  bl       #0xd3d4 ; call stub:_notify_post
0x00009fe4  adrp     x8, #0x18000
0x00009fe8  ldr      x22, [x8, #0x3f0] ; -> [classref(NSString)]
0x00009fec  adrp     x8, #0x18000
0x00009ff0  ldr      x0, [x8, #0x5a8] ; -> [__DATA,__bss+0xa8]
0x00009ff4  bl       #0xd960 ; call objc_stub[count]
0x00009ff8  mov      x23, x0
0x00009ffc  adrp     x8, #0x18000
0x0000a000  ldr      x0, [x8, #0x5a8] ; -> [__DATA,__bss+0xa8]
0x0000a004  adrp     x2, #0x14000
0x0000a008  add      x2, x2, #0xa68 ; -> CFSTR(", ")
0x0000a00c  bl       #0xd880 ; call objc_stub[componentsJoinedByString:]
0x0000a010  mov      x29, x29
0x0000a014  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a018  mov      x20, x0
0x0000a01c  stp      x23, x0, [sp]
0x0000a020  mov      x0, x22
0x0000a024  adrp     x2, #0x16000
0x0000a028  add      x2, x2, #0xa8 ; -> CFSTR("do hieu nang: bat dau, %lu tweak khac trong CarPlay: %@")
0x0000a02c  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x0000a030  mov      x29, x29
0x0000a034  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a038  mov      x21, x0
0x0000a03c  adrp     x0, #0x14000
0x0000a040  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x0000a044  mov      x1, x21
0x0000a048  bl       #0x6be4 ; call _OMCLogWrite
0x0000a04c  mov      x0, x21
0x0000a050  bl       #0xd4b8 ; call stub:_objc_release
0x0000a054  mov      x0, x20
0x0000a058  bl       #0xd4b8 ; call stub:_objc_release
0x0000a05c  mov      x0, x19
0x0000a060  bl       #0xd4b8 ; call stub:_objc_release
0x0000a064  ldr      x19, [sp, #0x70]
0x0000a068  mov      x0, x19
0x0000a06c  bl       #0xd4b8 ; call stub:_objc_release
0x0000a070  adrp     x8, #0x18000
0x0000a074  ldr      x0, [x8, #0x470] ; -> [classref(NSMutableDictionary)]
0x0000a078  bl       #0xda80 ; call objc_stub[dictionary]
0x0000a07c  mov      x29, x29
0x0000a080  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a084  str      x0, [sp, #0x78]
0x0000a088  adrp     x8, #0x18000
0x0000a08c  ldr      x0, [x8, #0x460] ; -> [classref(NSDate)]
0x0000a090  bl       #0xd9e0 ; call objc_stub[date]
0x0000a094  mov      x29, x29
0x0000a098  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a09c  mov      x19, x0
0x0000a0a0  ldr      x0, [sp, #0x78]
0x0000a0a4  mov      x2, x19
0x0000a0a8  adrp     x3, #0x14000
0x0000a0ac  add      x3, x3, #0xd68 ; -> CFSTR("date")
0x0000a0b0  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000a0b4  mov      x0, x19
0x0000a0b8  bl       #0xd4b8 ; call stub:_objc_release
0x0000a0bc  ldr      x0, [sp, #0x78]
0x0000a0c0  adrp     x2, #0x14000
0x0000a0c4  ldr      x2, [x2, #0x188] ; -> [got(___kCFBooleanTrue)]
0x0000a0c8  adrp     x3, #0x15000
0x0000a0cc  add      x3, x3, #0xf28 ; -> CFSTR("connected")
0x0000a0d0  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000a0d4  adrp     x8, #0x18000
0x0000a0d8  ldr      x0, [x8, #0x498] ; -> [classref(UIDevice)]
0x0000a0dc  bl       #0xd9a0 ; call objc_stub[currentDevice]
0x0000a0e0  mov      x29, x29
0x0000a0e4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a0e8  mov      x19, x0
0x0000a0ec  bl       #0xe4a0 ; call objc_stub[systemVersion]
0x0000a0f0  mov      x29, x29
0x0000a0f4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a0f8  mov      x20, x0
0x0000a0fc  ldr      x0, [sp, #0x78]
0x0000a100  mov      x2, x20
0x0000a104  adrp     x3, #0x15000
0x0000a108  add      x3, x3, #0x9c8 ; -> CFSTR("ios")
0x0000a10c  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000a110  mov      x0, x20
0x0000a114  bl       #0xd4b8 ; call stub:_objc_release
0x0000a118  mov      x0, x19
0x0000a11c  bl       #0xd4b8 ; call stub:_objc_release
0x0000a120  ldr      x0, [sp, #0x70]
0x0000a124  bl       #0xd7e0 ; call objc_stub[bounds]
0x0000a128  adrp     x8, #0x18000
0x0000a12c  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x0000a130  stp      d2, d3, [sp]
0x0000a134  adrp     x2, #0x16000
0x0000a138  add      x2, x2, #0x488 ; -> CFSTR("%.0fx%.0f")
0x0000a13c  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x0000a140  mov      x29, x29
0x0000a144  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a148  mov      x19, x0
0x0000a14c  ldr      x0, [sp, #0x78]
0x0000a150  mov      x2, x19
0x0000a154  adrp     x3, #0x15000
0x0000a158  add      x3, x3, #0xfa8 ; -> CFSTR("points")
0x0000a15c  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000a160  mov      x0, x19
0x0000a164  bl       #0xd4b8 ; call stub:_objc_release
0x0000a168  ldr      x0, [sp, #0x70]
0x0000a16c  bl       #0xde40 ; call objc_stub[nativeBounds]
0x0000a170  adrp     x8, #0x18000
0x0000a174  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x0000a178  stp      d2, d3, [sp]
0x0000a17c  adrp     x2, #0x16000
0x0000a180  add      x2, x2, #0x488 ; -> CFSTR("%.0fx%.0f")
0x0000a184  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x0000a188  mov      x29, x29
0x0000a18c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a190  mov      x19, x0
0x0000a194  ldr      x0, [sp, #0x78]
0x0000a198  mov      x2, x19
0x0000a19c  adrp     x3, #0x15000
0x0000a1a0  add      x3, x3, #0xfc8 ; -> CFSTR("pixels")
0x0000a1a4  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000a1a8  mov      x0, x19
0x0000a1ac  bl       #0xd4b8 ; call stub:_objc_release
0x0000a1b0  adrp     x8, #0x18000
0x0000a1b4  ldr      x19, [x8, #0x448] ; -> [classref(NSNumber)]
0x0000a1b8  ldr      x0, [sp, #0x70]
0x0000a1bc  bl       #0xe160 ; call objc_stub[scale]
0x0000a1c0  mov      x0, x19
0x0000a1c4  bl       #0xdea0 ; call objc_stub[numberWithDouble:]
0x0000a1c8  mov      x29, x29
0x0000a1cc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a1d0  mov      x19, x0
0x0000a1d4  ldr      x0, [sp, #0x78]
0x0000a1d8  mov      x2, x19
0x0000a1dc  adrp     x3, #0x15000
0x0000a1e0  add      x3, x3, #0xfe8 ; -> CFSTR("scale")
0x0000a1e4  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000a1e8  mov      x0, x19
0x0000a1ec  bl       #0xd4b8 ; call stub:_objc_release
0x0000a1f0  adrp     x8, #0x18000
0x0000a1f4  ldr      x19, [x8, #0x448] ; -> [classref(NSNumber)]
0x0000a1f8  ldr      x0, [sp, #0x70]
0x0000a1fc  bl       #0xddc0 ; call objc_stub[maximumFramesPerSecond]
0x0000a200  mov      x2, x0
0x0000a204  mov      x0, x19
0x0000a208  bl       #0xdec0 ; call objc_stub[numberWithInteger:]
0x0000a20c  mov      x29, x29
0x0000a210  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a214  mov      x19, x0
0x0000a218  ldr      x0, [sp, #0x78]
0x0000a21c  mov      x2, x19
0x0000a220  adrp     x3, #0x16000
0x0000a224  add      x3, x3, #8 ; -> CFSTR("maxFPS")
0x0000a228  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000a22c  mov      x0, x19
0x0000a230  bl       #0xd4b8 ; call stub:_objc_release
0x0000a234  adrp     x0, #0xf000
0x0000a238  add      x0, x0, #0x4ef ; -> "/System/Library/PrivateFrameworks/CarKit.framework/CarKit"
0x0000a23c  mov      w1, #1
0x0000a240  bl       #0xd2f0 ; call stub:_dlopen
0x0000a244  adrp     x0, #0x16000
0x0000a248  add      x0, x0, #0x28 ; -> CFSTR("CARSessionStatus")
0x0000a24c  bl       #0xd14c ; call stub:_NSClassFromString
0x0000a250  adrp     x8, #0x18000
0x0000a254  ldr      x19, [x8, #0x600] ; -> [__DATA,__bss+0x100]
0x0000a258  cbnz     x19, #0xa280
0x0000a25c  cbz      x0, #0xa280
0x0000a260  bl       #0xd494 ; call stub:_objc_opt_new
0x0000a264  adrp     x9, #0x18000
0x0000a268  ldr      x8, [x9, #0x600] ; -> [__DATA,__bss+0x100]
0x0000a26c  str      x0, [x9, #0x600]
0x0000a270  mov      x0, x8
0x0000a274  bl       #0xd4b8 ; call stub:_objc_release
0x0000a278  adrp     x8, #0x18000
0x0000a27c  ldr      x19, [x8, #0x600] ; -> [__DATA,__bss+0x100]
0x0000a280  adrp     x0, #0x16000
0x0000a284  add      x0, x0, #0x48 ; -> CFSTR("currentSession")
0x0000a288  bl       #0xd170 ; call stub:_NSSelectorFromString
0x0000a28c  mov      x1, x0
0x0000a290  mov      x0, x19
0x0000a294  bl       #0xd4a0 ; call stub:_objc_opt_respondsToSelector
0x0000a298  tbz      w0, #0, #0xa36c
0x0000a29c  adrp     x8, #0x18000
0x0000a2a0  ldr      x0, [x8, #0x600] ; -> [__DATA,__bss+0x100]
0x0000a2a4  adrp     x2, #0x16000
0x0000a2a8  add      x2, x2, #0x48 ; -> CFSTR("currentSession")
0x0000a2ac  bl       #0xe5c0 ; call objc_stub[valueForKey:]
0x0000a2b0  mov      x29, x29
0x0000a2b4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a2b8  mov      x19, x0
0x0000a2bc  cbz      x0, #0xa36c
0x0000a2c0  mov      x0, x19
0x0000a2c4  bl       #0xabf4 ; call sub_abf4
0x0000a2c8  mov      x29, x29
0x0000a2cc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a2d0  mov      x20, x0
0x0000a2d4  ldr      x0, [sp, #0x78]
0x0000a2d8  mov      x2, x20
0x0000a2dc  adrp     x3, #0x15000
0x0000a2e0  add      x3, x3, #0x6c8 ; -> CFSTR("session")
0x0000a2e4  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000a2e8  mov      x0, x20
0x0000a2ec  bl       #0xd4b8 ; call stub:_objc_release
0x0000a2f0  adrp     x0, #0x15000
0x0000a2f4  add      x0, x0, #0x6e8 ; -> CFSTR("configuration")
0x0000a2f8  bl       #0xd170 ; call stub:_NSSelectorFromString
0x0000a2fc  mov      x1, x0
0x0000a300  mov      x0, x19
0x0000a304  bl       #0xd4a0 ; call stub:_objc_opt_respondsToSelector
0x0000a308  tbz      w0, #0, #0xa364
0x0000a30c  mov      x0, x19
0x0000a310  adrp     x2, #0x15000
0x0000a314  add      x2, x2, #0x6e8 ; -> CFSTR("configuration")
0x0000a318  bl       #0xe5c0 ; call objc_stub[valueForKey:]
0x0000a31c  mov      x29, x29
0x0000a320  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a324  mov      x20, x0
0x0000a328  cbz      x0, #0xa364
0x0000a32c  mov      x0, x20
0x0000a330  bl       #0xabf4 ; call sub_abf4
0x0000a334  mov      x29, x29
0x0000a338  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a33c  mov      x21, x0
0x0000a340  ldr      x0, [sp, #0x78]
0x0000a344  mov      x2, x21
0x0000a348  adrp     x3, #0x15000
0x0000a34c  add      x3, x3, #0x6e8 ; -> CFSTR("configuration")
0x0000a350  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000a354  mov      x0, x21
0x0000a358  bl       #0xd4b8 ; call stub:_objc_release
0x0000a35c  mov      x0, x20
0x0000a360  bl       #0xd4b8 ; call stub:_objc_release
0x0000a364  mov      x0, x19
0x0000a368  bl       #0xd4b8 ; call stub:_objc_release
0x0000a36c  adrp     x0, #0x15000
0x0000a370  add      x0, x0, #0x6a8 ; -> CFSTR("diagCar")
0x0000a374  ldr      x1, [sp, #0x78]
0x0000a378  adrp     x2, #0x14000
0x0000a37c  add      x2, x2, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x0000a380  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x0000a384  adrp     x0, #0x14000
0x0000a388  add      x0, x0, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x0000a38c  bl       #0xd0e0 ; call stub:_CFPreferencesAppSynchronize
0x0000a390  ldr      x0, [sp, #0x78]
0x0000a394  bl       #0xd4c4 ; call stub:_objc_retain
0x0000a398  adrp     x0, #0x14000
0x0000a39c  add      x0, x0, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x0000a3a0  bl       #0xd0e0 ; call stub:_CFPreferencesAppSynchronize
0x0000a3a4  adrp     x0, #0x16000
0x0000a3a8  add      x0, x0, #0x588 ; -> CFSTR("carProfilesEnabled")
0x0000a3ac  adrp     x1, #0x14000
0x0000a3b0  ldr      x1, [x1, #0x180] ; -> [got(___kCFBooleanFalse)]
0x0000a3b4  bl       #0x6534 ; call _OMCPref
0x0000a3b8  mov      x29, x29
0x0000a3bc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a3c0  mov      x19, x0
0x0000a3c4  bl       #0xd7c0 ; call objc_stub[boolValue]
0x0000a3c8  mov      x20, x0
0x0000a3cc  mov      x0, x19
0x0000a3d0  bl       #0xd4b8 ; call stub:_objc_release
0x0000a3d4  cbz      w20, #0xa9f0
0x0000a3d8  ldr      x0, [sp, #0x78]
0x0000a3dc  adrp     x1, #0x17000
0x0000a3e0  add      x1, x1, #0x90 ; -> __DATA_CONST,__objc_arrayobj+0x78 (const collection)
0x0000a3e4  bl       #0xc038 ; call sub_c038
0x0000a3e8  mov      x29, x29
0x0000a3ec  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a3f0  str      x0, [sp, #0x38]
0x0000a3f4  ldr      x0, [sp, #0x78]
0x0000a3f8  adrp     x1, #0x17000
0x0000a3fc  add      x1, x1, #0xa8 ; -> __DATA_CONST,__objc_arrayobj+0x90 (const collection)
0x0000a400  bl       #0xc038 ; call sub_c038
0x0000a404  mov      x29, x29
0x0000a408  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a40c  str      x0, [sp, #0x30]
0x0000a410  ldr      x19, [sp, #0x30]
0x0000a414  cbz      x19, #0xa428
0x0000a418  mov      x0, x19
0x0000a41c  bl       #0xd4c4 ; call stub:_objc_retain
0x0000a420  str      x19, [sp, #0x58]
0x0000a424  b        #0xa498
0x0000a428  adrp     x8, #0x18000
0x0000a42c  ldr      x20, [x8, #0x3f0] ; -> [classref(NSString)]
0x0000a430  ldr      x9, [sp, #0x38]
0x0000a434  cmp      x9, #0
0x0000a438  adrp     x8, #0x16000
0x0000a43c  add      x8, x8, #0x728 ; -> CFSTR("?")
0x0000a440  csel     x21, x8, x9, eq
0x0000a444  ldr      x0, [sp, #0x78]
0x0000a448  adrp     x2, #0x15000
0x0000a44c  add      x2, x2, #0xfc8 ; -> CFSTR("pixels")
0x0000a450  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000a454  mov      x29, x29
0x0000a458  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a45c  mov      x19, x0
0x0000a460  cmp      x0, #0
0x0000a464  adrp     x8, #0x16000
0x0000a468  add      x8, x8, #0x728 ; -> CFSTR("?")
0x0000a46c  csel     x8, x8, x0, eq
0x0000a470  stp      x21, x8, [sp]
0x0000a474  mov      x0, x20
0x0000a478  adrp     x2, #0x16000
0x0000a47c  add      x2, x2, #0x708 ; -> CFSTR("%@|%@")
0x0000a480  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x0000a484  mov      x29, x29
0x0000a488  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a48c  str      x0, [sp, #0x58]
0x0000a490  mov      x0, x19
0x0000a494  bl       #0xd4b8 ; call stub:_objc_release
0x0000a498  adrp     x8, #0x18000
0x0000a49c  ldr      x0, [x8, #0x470] ; -> [classref(NSMutableDictionary)]
0x0000a4a0  bl       #0xda80 ; call objc_stub[dictionary]
0x0000a4a4  mov      x29, x29
0x0000a4a8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a4ac  mov      x19, x0
0x0000a4b0  adrp     x0, #0x16000
0x0000a4b4  add      x0, x0, #0x748 ; -> CFSTR("carProfiles")
0x0000a4b8  mov      x1, #0
0x0000a4bc  bl       #0x6534 ; call _OMCPref
0x0000a4c0  mov      x29, x29
0x0000a4c4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a4c8  mov      x22, x0
0x0000a4cc  ldr      x0, [x24, #0x468] ; -> [classref(NSDictionary)]
0x0000a4d0  bl       #0xd47c ; call stub:_objc_opt_class
0x0000a4d4  mov      x1, x0
0x0000a4d8  mov      x0, x22
0x0000a4dc  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x0000a4e0  tbz      w0, #0, #0xa5ec
0x0000a4e4  movi     v0.16b, #0
0x0000a4e8  stp      q0, q0, [sp, #0xe0]
0x0000a4ec  stp      q0, q0, [sp, #0xc0]
0x0000a4f0  mov      x0, x22
0x0000a4f4  bl       #0xd4c4 ; call stub:_objc_retain
0x0000a4f8  add      x2, sp, #0xc0
0x0000a4fc  sub      x3, x29, #0xf0
0x0000a500  mov      x0, x22
0x0000a504  mov      w4, #0x10
0x0000a508  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000a50c  mov      x20, x0
0x0000a510  cbz      x0, #0xa5e4
0x0000a514  ldr      x8, [sp, #0xd0]
0x0000a518  ldr      x26, [x8] ; -> [selref(CGContext)]
0x0000a51c  mov      x28, #0
0x0000a520  ldr      x8, [sp, #0xd0]
0x0000a524  ldr      x8, [x8] ; -> [selref(CGContext)]
0x0000a528  cmp      x8, x26
0x0000a52c  b.eq     #0xa538
0x0000a530  mov      x0, x22
0x0000a534  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x0000a538  ldr      x8, [sp, #0xc8]
0x0000a53c  ldr      x23, [x8, x28, lsl #3] ; -> [selref(CGContext)]
0x0000a540  mov      x0, x22
0x0000a544  mov      x2, x23
0x0000a548  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000a54c  mov      x29, x29
0x0000a550  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a554  mov      x25, x0
0x0000a558  ldr      x0, [x24, #0x468] ; -> [classref(NSDictionary)]
0x0000a55c  bl       #0xd47c ; call stub:_objc_opt_class
0x0000a560  mov      x1, x0
0x0000a564  mov      x0, x25
0x0000a568  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x0000a56c  mov      x21, x0
0x0000a570  mov      x0, x25
0x0000a574  bl       #0xd4b8 ; call stub:_objc_release
0x0000a578  tbz      w21, #0, #0xa5bc
0x0000a57c  mov      x0, x22
0x0000a580  mov      x2, x23
0x0000a584  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000a588  mov      x29, x29
0x0000a58c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a590  mov      x25, x0
0x0000a594  bl       #0xde00 ; call objc_stub[mutableCopy]
0x0000a598  mov      x21, x0
0x0000a59c  mov      x0, x19
0x0000a5a0  mov      x2, x21
0x0000a5a4  mov      x3, x23
0x0000a5a8  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000a5ac  mov      x0, x21
0x0000a5b0  bl       #0xd4b8 ; call stub:_objc_release
0x0000a5b4  mov      x0, x25
0x0000a5b8  bl       #0xd4b8 ; call stub:_objc_release
0x0000a5bc  add      x28, x28, #1
0x0000a5c0  cmp      x20, x28
0x0000a5c4  b.ne     #0xa520
0x0000a5c8  add      x2, sp, #0xc0
0x0000a5cc  sub      x3, x29, #0xf0
0x0000a5d0  mov      x0, x22
0x0000a5d4  mov      w4, #0x10
0x0000a5d8  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000a5dc  mov      x20, x0
0x0000a5e0  cbnz     x0, #0xa51c
0x0000a5e4  mov      x0, x22
0x0000a5e8  bl       #0xd4b8 ; call stub:_objc_release
0x0000a5ec  adrp     x0, #0x16000
0x0000a5f0  add      x0, x0, #0x768 ; -> CFSTR("carProfileCurrent")
0x0000a5f4  mov      x1, #0
0x0000a5f8  bl       #0x6534 ; call _OMCPref
0x0000a5fc  mov      x29, x29
0x0000a600  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a604  str      x0, [sp, #0x40]
0x0000a608  adrp     x8, #0x18000
0x0000a60c  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x0000a610  bl       #0xd47c ; call stub:_objc_opt_class
0x0000a614  mov      x1, x0
0x0000a618  ldr      x0, [sp, #0x40]
0x0000a61c  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x0000a620  tbz      w0, #0, #0xa6a4
0x0000a624  mov      x0, x19
0x0000a628  ldr      x2, [sp, #0x40]
0x0000a62c  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000a630  mov      x29, x29
0x0000a634  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a638  mov      x20, x0
0x0000a63c  cbz      x0, #0xa6a4
0x0000a640  ldr      x0, [sp, #0x40]
0x0000a644  ldr      x2, [sp, #0x58]
0x0000a648  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x0000a64c  mov      x21, x0
0x0000a650  mov      x0, x20
0x0000a654  bl       #0xd4b8 ; call stub:_objc_release
0x0000a658  tbnz     w21, #0, #0xa6a4
0x0000a65c  bl       #0xc2bc ; call sub_c2bc
0x0000a660  mov      x29, x29
0x0000a664  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a668  mov      x20, x0
0x0000a66c  mov      x0, x19
0x0000a670  ldr      x2, [sp, #0x40]
0x0000a674  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000a678  mov      x29, x29
0x0000a67c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a680  mov      x21, x0
0x0000a684  mov      x2, x20
0x0000a688  adrp     x3, #0x16000
0x0000a68c  add      x3, x3, #0x788 ; -> CFSTR("values")
0x0000a690  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000a694  mov      x0, x21
0x0000a698  bl       #0xd4b8 ; call stub:_objc_release
0x0000a69c  mov      x0, x20
0x0000a6a0  bl       #0xd4b8 ; call stub:_objc_release
0x0000a6a4  mov      x0, x19
0x0000a6a8  ldr      x2, [sp, #0x58]
0x0000a6ac  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000a6b0  mov      x29, x29
0x0000a6b4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a6b8  str      x0, [sp, #0x60]
0x0000a6bc  ldr      x8, [sp, #0x60]
0x0000a6c0  cbz      x8, #0xa82c
0x0000a6c4  ldr      x0, [sp, #0x40]
0x0000a6c8  ldr      x2, [sp, #0x58]
0x0000a6cc  bl       #0xdc60 ; call objc_stub[isEqual:]
0x0000a6d0  tbnz     w0, #0, #0xa8e4
0x0000a6d4  ldr      x0, [sp, #0x60]
0x0000a6d8  adrp     x2, #0x16000
0x0000a6dc  add      x2, x2, #0x788 ; -> CFSTR("values")
0x0000a6e0  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000a6e4  mov      x29, x29
0x0000a6e8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a6ec  mov      x25, x0
0x0000a6f0  movi     v0.16b, #0
0x0000a6f4  stp      q0, q0, [sp, #0x220]
0x0000a6f8  stp      q0, q0, [sp, #0x200]
0x0000a6fc  bl       #0xc510 ; call _OMCProfileKeys
0x0000a700  mov      x29, x29
0x0000a704  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a708  mov      x26, x0
0x0000a70c  add      x2, sp, #0x200
0x0000a710  add      x3, sp, #0x180
0x0000a714  mov      w4, #0x10
0x0000a718  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000a71c  mov      x23, x0
0x0000a720  cbz      x0, #0xa7cc
0x0000a724  ldr      x8, [sp, #0x210]
0x0000a728  ldr      x20, [x8] ; -> [selref(CGContext)]
0x0000a72c  mov      x27, #0
0x0000a730  ldr      x8, [sp, #0x210]
0x0000a734  ldr      x8, [x8] ; -> [selref(CGContext)]
0x0000a738  cmp      x8, x20
0x0000a73c  b.eq     #0xa748
0x0000a740  mov      x0, x26
0x0000a744  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x0000a748  ldr      x8, [sp, #0x208]
0x0000a74c  ldr      x28, [x8, x27, lsl #3] ; -> [selref(CGContext)]
0x0000a750  ldr      x0, [x24, #0x468] ; -> [classref(NSDictionary)]
0x0000a754  bl       #0xd47c ; call stub:_objc_opt_class
0x0000a758  mov      x1, x0
0x0000a75c  mov      x0, x25
0x0000a760  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x0000a764  tbz      w0, #0, #0xa784
0x0000a768  mov      x0, x25
0x0000a76c  mov      x2, x28
0x0000a770  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000a774  mov      x29, x29
0x0000a778  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a77c  mov      x21, x0
0x0000a780  b        #0xa788
0x0000a784  mov      x21, #0
0x0000a788  mov      x0, x28
0x0000a78c  mov      x1, x21
0x0000a790  adrp     x2, #0x14000
0x0000a794  add      x2, x2, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x0000a798  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x0000a79c  mov      x0, x21
0x0000a7a0  bl       #0xd4b8 ; call stub:_objc_release
0x0000a7a4  add      x27, x27, #1
0x0000a7a8  cmp      x23, x27
0x0000a7ac  b.ne     #0xa730
0x0000a7b0  add      x2, sp, #0x200
0x0000a7b4  add      x3, sp, #0x180
0x0000a7b8  mov      x0, x26
0x0000a7bc  mov      w4, #0x10
0x0000a7c0  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000a7c4  mov      x23, x0
0x0000a7c8  cbnz     x0, #0xa72c
0x0000a7cc  mov      x0, x26
0x0000a7d0  bl       #0xd4b8 ; call stub:_objc_release
0x0000a7d4  adrp     x8, #0x18000
0x0000a7d8  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x0000a7dc  ldr      x9, [sp, #0x38]
0x0000a7e0  cmp      x9, #0
0x0000a7e4  adrp     x8, #0x16000
0x0000a7e8  add      x8, x8, #0x728 ; -> CFSTR("?")
0x0000a7ec  csel     x8, x8, x9, eq
0x0000a7f0  ldr      x9, [sp, #0x58]
0x0000a7f4  stp      x8, x9, [sp]
0x0000a7f8  adrp     x2, #0x16000
0x0000a7fc  add      x2, x2, #0x7c8 ; -> CFSTR("nap ho so xe %@ (%@)")
0x0000a800  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x0000a804  mov      x29, x29
0x0000a808  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a80c  mov      x21, x0
0x0000a810  adrp     x0, #0x14000
0x0000a814  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x0000a818  mov      x1, x21
0x0000a81c  bl       #0x6be4 ; call _OMCLogWrite
0x0000a820  mov      x0, x21
0x0000a824  bl       #0xd4b8 ; call stub:_objc_release
0x0000a828  b        #0xa8dc
0x0000a82c  adrp     x8, #0x16000
0x0000a830  add      x8, x8, #0x788 ; -> CFSTR("values")
0x0000a834  str      x8, [sp, #0x200]
0x0000a838  bl       #0xc2bc ; call sub_c2bc
0x0000a83c  mov      x29, x29
0x0000a840  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a844  mov      x23, x0
0x0000a848  str      x0, [sp, #0x180]
0x0000a84c  ldr      x0, [x24, #0x468] ; -> [classref(NSDictionary)]
0x0000a850  add      x2, sp, #0x180
0x0000a854  add      x3, sp, #0x200
0x0000a858  mov      w4, #1
0x0000a85c  bl       #0xdac0 ; call objc_stub[dictionaryWithObjects:forKeys:count:]
0x0000a860  mov      x29, x29
0x0000a864  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a868  mov      x21, x0
0x0000a86c  bl       #0xde00 ; call objc_stub[mutableCopy]
0x0000a870  str      x0, [sp, #0x60]
0x0000a874  mov      x0, x21
0x0000a878  bl       #0xd4b8 ; call stub:_objc_release
0x0000a87c  mov      x0, x23
0x0000a880  bl       #0xd4b8 ; call stub:_objc_release
0x0000a884  mov      x0, x19
0x0000a888  ldp      x3, x2, [sp, #0x58]
0x0000a88c  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000a890  adrp     x8, #0x18000
0x0000a894  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x0000a898  ldr      x9, [sp, #0x38]
0x0000a89c  cmp      x9, #0
0x0000a8a0  adrp     x8, #0x16000
0x0000a8a4  add      x8, x8, #0x728 ; -> CFSTR("?")
0x0000a8a8  csel     x8, x8, x9, eq
0x0000a8ac  ldr      x9, [sp, #0x58]
0x0000a8b0  stp      x8, x9, [sp]
0x0000a8b4  adrp     x2, #0x16000
0x0000a8b8  add      x2, x2, #0x7a8 ; -> CFSTR("ho so xe moi: %@ (%@)")
0x0000a8bc  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x0000a8c0  mov      x29, x29
0x0000a8c4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a8c8  mov      x25, x0
0x0000a8cc  adrp     x0, #0x14000
0x0000a8d0  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x0000a8d4  mov      x1, x25
0x0000a8d8  bl       #0x6be4 ; call _OMCLogWrite
0x0000a8dc  mov      x0, x25
0x0000a8e0  bl       #0xd4b8 ; call stub:_objc_release
0x0000a8e4  ldr      x2, [sp, #0x38]
0x0000a8e8  cbz      x2, #0xa900
0x0000a8ec  ldr      x0, [sp, #0x60]
0x0000a8f0  adrp     x3, #0x16000
0x0000a8f4  add      x3, x3, #0x5c8 ; -> CFSTR("name")
0x0000a8f8  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000a8fc  b        #0xa93c
0x0000a900  adrp     x0, #0x16000
0x0000a904  add      x0, x0, #0x7e8 ; -> CFSTR("Xe")
0x0000a908  adrp     x1, #0x16000
0x0000a90c  add      x1, x1, #0x808 ; -> CFSTR("Car")
0x0000a910  bl       #0xc8c0 ; call _OMCTr
0x0000a914  mov      x29, x29
0x0000a918  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a91c  mov      x21, x0
0x0000a920  ldr      x0, [sp, #0x60]
0x0000a924  mov      x2, x21
0x0000a928  adrp     x3, #0x16000
0x0000a92c  add      x3, x3, #0x5c8 ; -> CFSTR("name")
0x0000a930  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000a934  mov      x0, x21
0x0000a938  bl       #0xd4b8 ; call stub:_objc_release
0x0000a93c  adrp     x8, #0x18000
0x0000a940  ldr      x0, [x8, #0x460] ; -> [classref(NSDate)]
0x0000a944  bl       #0xd9e0 ; call objc_stub[date]
0x0000a948  mov      x29, x29
0x0000a94c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000a950  mov      x21, x0
0x0000a954  ldr      x0, [sp, #0x60]
0x0000a958  mov      x2, x21
0x0000a95c  adrp     x3, #0x16000
0x0000a960  add      x3, x3, #0x828 ; -> CFSTR("lastSeen")
0x0000a964  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000a968  mov      x0, x21
0x0000a96c  bl       #0xd4b8 ; call stub:_objc_release
0x0000a970  adrp     x0, #0x16000
0x0000a974  add      x0, x0, #0x748 ; -> CFSTR("carProfiles")
0x0000a978  mov      x1, x19
0x0000a97c  adrp     x2, #0x14000
0x0000a980  add      x2, x2, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x0000a984  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x0000a988  adrp     x0, #0x16000
0x0000a98c  add      x0, x0, #0x768 ; -> CFSTR("carProfileCurrent")
0x0000a990  ldr      x1, [sp, #0x58]
0x0000a994  adrp     x2, #0x14000
0x0000a998  add      x2, x2, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x0000a99c  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x0000a9a0  adrp     x0, #0x14000
0x0000a9a4  add      x0, x0, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x0000a9a8  bl       #0xd0e0 ; call stub:_CFPreferencesAppSynchronize
0x0000a9ac  adrp     x0, #0xe000
0x0000a9b0  add      x0, x0, #0x71b ; -> "com.anlai.omnicar/prefschanged"
0x0000a9b4  bl       #0xd3d4 ; call stub:_notify_post
0x0000a9b8  ldr      x0, [sp, #0x60]
0x0000a9bc  bl       #0xd4b8 ; call stub:_objc_release
0x0000a9c0  ldr      x0, [sp, #0x40]
0x0000a9c4  bl       #0xd4b8 ; call stub:_objc_release
0x0000a9c8  mov      x0, x22
0x0000a9cc  bl       #0xd4b8 ; call stub:_objc_release
0x0000a9d0  mov      x0, x19
0x0000a9d4  bl       #0xd4b8 ; call stub:_objc_release
0x0000a9d8  ldr      x0, [sp, #0x58]
0x0000a9dc  bl       #0xd4b8 ; call stub:_objc_release
0x0000a9e0  ldr      x0, [sp, #0x30]
0x0000a9e4  bl       #0xd4b8 ; call stub:_objc_release
0x0000a9e8  ldr      x0, [sp, #0x38]
0x0000a9ec  bl       #0xd4b8 ; call stub:_objc_release
0x0000a9f0  ldr      x0, [sp, #0x78]
0x0000a9f4  bl       #0xd4b8 ; call stub:_objc_release
0x0000a9f8  adrp     x8, #0x18000
0x0000a9fc  ldr      x23, [x8, #0x3f0] ; -> [classref(NSString)]
0x0000aa00  ldr      x0, [sp, #0x78]
0x0000aa04  adrp     x2, #0x15000
0x0000aa08  add      x2, x2, #0xfa8 ; -> CFSTR("points")
0x0000aa0c  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000aa10  mov      x29, x29
0x0000aa14  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000aa18  mov      x19, x0
0x0000aa1c  ldr      x0, [sp, #0x78]
0x0000aa20  adrp     x2, #0x15000
0x0000aa24  add      x2, x2, #0xfc8 ; -> CFSTR("pixels")
0x0000aa28  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000aa2c  mov      x29, x29
0x0000aa30  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000aa34  mov      x20, x0
0x0000aa38  ldr      x0, [sp, #0x78]
0x0000aa3c  adrp     x2, #0x16000
0x0000aa40  add      x2, x2, #8 ; -> CFSTR("maxFPS")
0x0000aa44  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000aa48  mov      x29, x29
0x0000aa4c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000aa50  mov      x22, x0
0x0000aa54  ldr      x0, [sp, #0x78]
0x0000aa58  adrp     x2, #0x15000
0x0000aa5c  add      x2, x2, #0x6c8 ; -> CFSTR("session")
0x0000aa60  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000aa64  mov      x29, x29
0x0000aa68  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000aa6c  mov      x25, x0
0x0000aa70  cmp      x0, #0
0x0000aa74  cset     w8, ne
0x0000aa78  stp      x19, x20, [sp]
0x0000aa7c  stp      x22, x8, [sp, #0x10]
0x0000aa80  mov      x0, x23
0x0000aa84  adrp     x2, #0x16000
0x0000aa88  add      x2, x2, #0x88 ; -> CFSTR("man xe %@ pt, %@ px, %@ fps, session=%d")
0x0000aa8c  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x0000aa90  mov      x29, x29
0x0000aa94  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000aa98  mov      x21, x0
0x0000aa9c  adrp     x0, #0x14000
0x0000aaa0  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x0000aaa4  mov      x1, x21
0x0000aaa8  bl       #0x6be4 ; call _OMCLogWrite
0x0000aaac  mov      x0, x21
0x0000aab0  bl       #0xd4b8 ; call stub:_objc_release
0x0000aab4  mov      x0, x25
0x0000aab8  bl       #0xd4b8 ; call stub:_objc_release
0x0000aabc  mov      x0, x22
0x0000aac0  bl       #0xd4b8 ; call stub:_objc_release
0x0000aac4  mov      x0, x20
0x0000aac8  bl       #0xd4b8 ; call stub:_objc_release
0x0000aacc  mov      x0, x19
0x0000aad0  bl       #0xd4b8 ; call stub:_objc_release
0x0000aad4  ldr      x0, [sp, #0x78]
0x0000aad8  bl       #0xd4b8 ; call stub:_objc_release
0x0000aadc  ldr      x0, [sp, #0x70]
0x0000aae0  bl       #0xd4b8 ; call stub:_objc_release
0x0000aae4  ldr      x9, [sp, #0x68]
0x0000aae8  add      x9, x9, #1 ; -> __DATA,__objc_selrefs+0x1
0x0000aaec  ldr      x8, [sp, #0x50]
0x0000aaf0  str      x9, [sp, #0x68]
0x0000aaf4  cmp      x9, x8
0x0000aaf8  b.ne     #0x9c4c
0x0000aafc  b        #0xab74
0x0000ab00  b        #0xab0c
0x0000ab04  b        #0xab0c
0x0000ab08  b        #0xab0c
0x0000ab0c  mov      x19, x0
0x0000ab10  cmp      w1, #1
0x0000ab14  b.ne     #0xabec
0x0000ab18  mov      x0, x19
0x0000ab1c  bl       #0xd440 ; call stub:_objc_begin_catch
0x0000ab20  mov      x19, x0
0x0000ab24  bl       #0xd4c4 ; call stub:_objc_retain
0x0000ab28  adrp     x8, #0x18000
0x0000ab2c  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x0000ab30  str      x19, [sp]
0x0000ab34  adrp     x2, #0x16000
0x0000ab38  add      x2, x2, #0x68 ; -> CFSTR("CarKit loi: %@")
0x0000ab3c  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x0000ab40  mov      x29, x29
0x0000ab44  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000ab48  mov      x20, x0
0x0000ab4c  adrp     x0, #0x14000
0x0000ab50  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x0000ab54  mov      x1, x20
0x0000ab58  bl       #0x6be4 ; call _OMCLogWrite
0x0000ab5c  mov      x0, x20
0x0000ab60  bl       #0xd4b8 ; call stub:_objc_release
0x0000ab64  mov      x0, x19
0x0000ab68  bl       #0xd4b8 ; call stub:_objc_release
0x0000ab6c  bl       #0xd44c ; call stub:_objc_end_catch
0x0000ab70  b        #0xa36c
0x0000ab74  add      x2, sp, #0x80
0x0000ab78  add      x3, sp, #0x100
0x0000ab7c  ldr      x0, [sp, #0x28]
0x0000ab80  mov      w4, #0x10
0x0000ab84  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000ab88  str      x0, [sp, #0x50]
0x0000ab8c  ldr      x8, [sp, #0x50]
0x0000ab90  cbnz     x8, #0x9c48
0x0000ab94  ldr      x0, [sp, #0x28]
0x0000ab98  bl       #0xd4b8 ; call stub:_objc_release
0x0000ab9c  ldur     x8, [x29, #-0x70]
0x0000aba0  adrp     x9, #0x14000
0x0000aba4  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x0000aba8  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x0000abac  cmp      x9, x8
0x0000abb0  b.ne     #0xabd8
0x0000abb4  add      sp, sp, #0x2d0
0x0000abb8  ldp      x29, x30, [sp, #0x60]
0x0000abbc  ldp      x20, x19, [sp, #0x50]
0x0000abc0  ldp      x22, x21, [sp, #0x40]
0x0000abc4  ldp      x24, x23, [sp, #0x30]
0x0000abc8  ldp      x26, x25, [sp, #0x20]
0x0000abcc  ldp      x28, x27, [sp, #0x10]
0x0000abd0  ldp      d9, d8, [sp], #0x70
0x0000abd4  ret      
0x0000abd8  bl       #0xd1b8 ; call stub:___stack_chk_fail
0x0000abdc  mov      x19, x0
0x0000abe0  bl       #0xd44c ; call stub:_objc_end_catch
0x0000abe4  b        #0xabec
0x0000abe8  mov      x19, x0
0x0000abec  mov      x0, x19
0x0000abf0  bl       #0xd1a0 ; call stub:__Unwind_Resume
