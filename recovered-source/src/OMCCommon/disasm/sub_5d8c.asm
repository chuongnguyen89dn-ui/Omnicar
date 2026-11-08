; === sub_5d8c @ 0x5d8c size=440 ===
0x00005d8c  sub      sp, sp, #0x60
0x00005d90  stp      x22, x21, [sp, #0x30]
0x00005d94  stp      x20, x19, [sp, #0x40]
0x00005d98  stp      x29, x30, [sp, #0x50]
0x00005d9c  add      x29, sp, #0x50
0x00005da0  mov      x19, x2
0x00005da4  mov      x0, x2
0x00005da8  bl       #0xd4c4 ; call stub:_objc_retain
0x00005dac  adrp     x8, #0x18000
0x00005db0  ldr      x0, [x8, #0x428] ; -> [classref(NSHTTPURLResponse)]
0x00005db4  bl       #0xd47c ; call stub:_objc_opt_class
0x00005db8  mov      x1, x0
0x00005dbc  mov      x0, x19
0x00005dc0  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x00005dc4  tbz      w0, #0, #0x5e00
0x00005dc8  mov      x0, x19
0x00005dcc  bl       #0xd720 ; call objc_stub[allHeaderFields]
0x00005dd0  mov      x29, x29
0x00005dd4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005dd8  mov      x21, x0
0x00005ddc  adrp     x2, #0x14000
0x00005de0  add      x2, x2, #0x9a8 ; -> CFSTR("Date")
0x00005de4  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x00005de8  mov      x29, x29
0x00005dec  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005df0  mov      x20, x0
0x00005df4  mov      x0, x21
0x00005df8  bl       #0xd4b8 ; call stub:_objc_release
0x00005dfc  b        #0x5e04
0x00005e00  mov      x20, #0
0x00005e04  adrp     x8, #0x18000
0x00005e08  ldr      x0, [x8, #0x3f0] ; -> [classref(NSString)]
0x00005e0c  bl       #0xd47c ; call stub:_objc_opt_class
0x00005e10  mov      x1, x0
0x00005e14  mov      x0, x20
0x00005e18  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x00005e1c  tbz      w0, #0, #0x5f20
0x00005e20  adrp     x8, #0x18000
0x00005e24  ldr      x0, [x8, #0x430] ; -> [classref(NSDateFormatter)]
0x00005e28  bl       #0xd494 ; call stub:_objc_opt_new
0x00005e2c  mov      x21, x0
0x00005e30  adrp     x8, #0x18000
0x00005e34  ldr      x0, [x8, #0x438] ; -> [classref(NSLocale)]
0x00005e38  adrp     x2, #0x14000
0x00005e3c  add      x2, x2, #0x9c8 ; -> CFSTR("en_US_POSIX")
0x00005e40  bl       #0xdd00 ; call objc_stub[localeWithLocaleIdentifier:]
0x00005e44  mov      x29, x29
0x00005e48  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005e4c  mov      x22, x0
0x00005e50  mov      x0, x21
0x00005e54  mov      x2, x22
0x00005e58  bl       #0xe280 ; call objc_stub[setLocale:]
0x00005e5c  mov      x0, x22
0x00005e60  bl       #0xd4b8 ; call stub:_objc_release
0x00005e64  adrp     x8, #0x18000
0x00005e68  ldr      x0, [x8, #0x440] ; -> [classref(NSTimeZone)]
0x00005e6c  mov      x2, #0
0x00005e70  bl       #0xe520 ; call objc_stub[timeZoneForSecondsFromGMT:]
0x00005e74  mov      x29, x29
0x00005e78  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005e7c  mov      x22, x0
0x00005e80  mov      x0, x21
0x00005e84  mov      x2, x22
0x00005e88  bl       #0xe300 ; call objc_stub[setTimeZone:]
0x00005e8c  mov      x0, x22
0x00005e90  bl       #0xd4b8 ; call stub:_objc_release
0x00005e94  adrp     x2, #0x14000
0x00005e98  add      x2, x2, #0x9e8 ; -> CFSTR("EEE, dd MMM yyyy HH:mm:ss zzz")
0x00005e9c  mov      x0, x21
0x00005ea0  bl       #0xe220 ; call objc_stub[setDateFormat:]
0x00005ea4  mov      x0, x21
0x00005ea8  mov      x2, x20
0x00005eac  bl       #0xda00 ; call objc_stub[dateFromString:]
0x00005eb0  mov      x29, x29
0x00005eb4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005eb8  mov      x22, x0
0x00005ebc  cbz      x0, #0x5f10
0x00005ec0  adrp     x8, #0x14000
0x00005ec4  ldr      x8, [x8, #0x1a0] ; -> [got(__NSConcreteStackBlock)]
0x00005ec8  str      x8, [sp, #8]
0x00005ecc  adrp     x8, #0xf000
0x00005ed0  ldr      d0, [x8, #0xab8] ; -> [__TEXT,__const+0x8 [u64=0xc2000000 f64=1.6080749353e-314]]
0x00005ed4  str      d0, [sp, #0x10]
0x00005ed8  adrp     x8, #0x5000
0x00005edc  add      x8, x8, #0xf44 ; -> __TEXT,__text+0x1f44
0x00005ee0  adrp     x9, #0x14000
0x00005ee4  add      x9, x9, #0x5e8 ; -> __DATA_CONST,__const+0x1e0 [u64=0x0 f64=0.0]
0x00005ee8  stp      x8, x9, [sp, #0x18]
0x00005eec  mov      x0, x22
0x00005ef0  bl       #0xd4c4 ; call stub:_objc_retain
0x00005ef4  str      x22, [sp, #0x28]
0x00005ef8  adrp     x0, #0x14000
0x00005efc  ldr      x0, [x0, #0x1d0] ; -> [got(__dispatch_main_q)]
0x00005f00  add      x1, sp, #8
0x00005f04  bl       #0xd26c ; call stub:_dispatch_async
0x00005f08  ldr      x0, [sp, #0x28]
0x00005f0c  bl       #0xd4b8 ; call stub:_objc_release
0x00005f10  mov      x0, x22
0x00005f14  bl       #0xd4b8 ; call stub:_objc_release
0x00005f18  mov      x0, x21
0x00005f1c  bl       #0xd4b8 ; call stub:_objc_release
0x00005f20  mov      x0, x20
0x00005f24  bl       #0xd4b8 ; call stub:_objc_release
0x00005f28  mov      x0, x19
0x00005f2c  bl       #0xd4b8 ; call stub:_objc_release
0x00005f30  ldp      x29, x30, [sp, #0x50]
0x00005f34  ldp      x20, x19, [sp, #0x40]
0x00005f38  ldp      x22, x21, [sp, #0x30]
0x00005f3c  add      sp, sp, #0x60
0x00005f40  ret      
