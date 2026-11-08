; === sub_4ca0 @ 0x4ca0 size=2696 ===
0x00004ca0  stp      x28, x27, [sp, #-0x60]!
0x00004ca4  stp      x26, x25, [sp, #0x10]
0x00004ca8  stp      x24, x23, [sp, #0x20]
0x00004cac  stp      x22, x21, [sp, #0x30]
0x00004cb0  stp      x20, x19, [sp, #0x40]
0x00004cb4  stp      x29, x30, [sp, #0x50]
0x00004cb8  add      x29, sp, #0x50
0x00004cbc  sub      sp, sp, #0x490
0x00004cc0  mov      x21, x0
0x00004cc4  adrp     x8, #0x14000
0x00004cc8  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x00004ccc  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x00004cd0  stur     x8, [x29, #-0x68]
0x00004cd4  bl       #0x6528 ; call _OMCPrefsSync
0x00004cd8  tbz      w21, #0, #0x56b0
0x00004cdc  add      x22, sp, #0xc0
0x00004ce0  adrp     x0, #0xe000
0x00004ce4  add      x0, x0, #0xa36 ; -> "AVExternalDevice"
0x00004ce8  bl       #0xd464 ; call stub:_objc_getClass
0x00004cec  adrp     x1, #0x14000
0x00004cf0  add      x1, x1, #0xce8 ; -> CFSTR("currentCarPlayExternalDevice")
0x00004cf4  bl       #0x6078 ; call sub_6078
0x00004cf8  mov      x29, x29
0x00004cfc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00004d00  mov      x19, x0
0x00004d04  bl       #0xd4b8 ; call stub:_objc_release
0x00004d08  bl       #0x60e4 ; call sub_60e4
0x00004d0c  mov      x29, x29
0x00004d10  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00004d14  mov      x26, x0
0x00004d18  str      x19, [sp, #0x30]
0x00004d1c  cmp      x19, #0
0x00004d20  str      w21, [sp, #0x38]
0x00004d24  eor      w8, w21, #1
0x00004d28  csinc    w24, w8, wzr, eq
0x00004d2c  adrp     x8, #0x18000
0x00004d30  ldr      x0, [x8, #0x470] ; -> [classref(NSMutableDictionary)]
0x00004d34  bl       #0xda80 ; call objc_stub[dictionary]
0x00004d38  mov      x29, x29
0x00004d3c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00004d40  mov      x20, x0
0x00004d44  movi     v0.16b, #0
0x00004d48  stp      q0, q0, [x22, #0xc0]
0x00004d4c  stp      q0, q0, [x22, #0xe0]
0x00004d50  adrp     x0, #0x17000
0x00004d54  add      x0, x0, #0x18 ; -> __DATA_CONST,__objc_arrayobj+0x0 (const collection)
0x00004d58  add      x2, sp, #0x180
0x00004d5c  sub      x3, x29, #0xe8
0x00004d60  mov      w4, #0x10
0x00004d64  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00004d68  cbz      x0, #0x4de0
0x00004d6c  mov      x23, x0
0x00004d70  ldr      x8, [sp, #0x190]
0x00004d74  ldr      x25, [x8] ; -> [selref(CGContext)]
0x00004d78  adrp     x21, #0x14000
0x00004d7c  add      x21, x21, #0xf88 ; -> CFSTR("system")
0x00004d80  adrp     x22, #0x17000
0x00004d84  add      x22, x22, #0x18 ; -> __DATA_CONST,__objc_arrayobj+0x0 (const collection)
0x00004d88  mov      x19, #0
0x00004d8c  ldr      x8, [sp, #0x190]
0x00004d90  ldr      x8, [x8] ; -> [selref(CGContext)]
0x00004d94  cmp      x8, x25
0x00004d98  b.eq     #0x4da4
0x00004d9c  mov      x0, x22
0x00004da0  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x00004da4  ldr      x8, [sp, #0x188]
0x00004da8  ldr      x3, [x8, x19, lsl #3] ; -> [selref(CGContext)]
0x00004dac  mov      x0, x20
0x00004db0  mov      x2, x21
0x00004db4  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x00004db8  add      x19, x19, #1
0x00004dbc  cmp      x23, x19
0x00004dc0  b.ne     #0x4d8c
0x00004dc4  add      x2, sp, #0x180
0x00004dc8  sub      x3, x29, #0xe8
0x00004dcc  mov      x0, x22
0x00004dd0  mov      w4, #0x10
0x00004dd4  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00004dd8  mov      x23, x0
0x00004ddc  cbnz     x0, #0x4d88
0x00004de0  str      x26, [sp, #0x48]
0x00004de4  cbz      w24, #0x4fec
0x00004de8  movi     v0.16b, #0
0x00004dec  add      x8, sp, #0xc0
0x00004df0  stp      q0, q0, [x8, #0xa0]
0x00004df4  stp      q0, q0, [x8, #0x80]
0x00004df8  adrp     x0, #0x17000
0x00004dfc  add      x0, x0, #0x30 ; -> __DATA_CONST,__objc_arrayobj+0x18 (const collection)
0x00004e00  add      x2, sp, #0x140
0x00004e04  add      x3, sp, #0x378
0x00004e08  mov      w4, #0x10
0x00004e0c  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00004e10  cbz      x0, #0x4e88
0x00004e14  mov      x23, x0
0x00004e18  ldr      x8, [sp, #0x150]
0x00004e1c  ldr      x24, [x8] ; -> [selref(CGContext)]
0x00004e20  adrp     x21, #0x15000
0x00004e24  add      x21, x21, #0x68 ; -> CFSTR("car")
0x00004e28  adrp     x22, #0x17000
0x00004e2c  add      x22, x22, #0x30 ; -> __DATA_CONST,__objc_arrayobj+0x18 (const collection)
0x00004e30  mov      x19, #0
0x00004e34  ldr      x8, [sp, #0x150]
0x00004e38  ldr      x8, [x8] ; -> [selref(CGContext)]
0x00004e3c  cmp      x8, x24
0x00004e40  b.eq     #0x4e4c
0x00004e44  mov      x0, x22
0x00004e48  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x00004e4c  ldr      x8, [sp, #0x148]
0x00004e50  ldr      x3, [x8, x19, lsl #3] ; -> [selref(CGContext)]
0x00004e54  mov      x0, x20
0x00004e58  mov      x2, x21
0x00004e5c  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x00004e60  add      x19, x19, #1
0x00004e64  cmp      x23, x19
0x00004e68  b.ne     #0x4e34
0x00004e6c  add      x2, sp, #0x140
0x00004e70  add      x3, sp, #0x378
0x00004e74  mov      x0, x22
0x00004e78  mov      w4, #0x10
0x00004e7c  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00004e80  mov      x23, x0
0x00004e84  cbnz     x0, #0x4e30
0x00004e88  add      x8, sp, #0xc0
0x00004e8c  movi     v0.16b, #0
0x00004e90  stp      q0, q0, [x8, #0x60]
0x00004e94  stp      q0, q0, [x8, #0x40]
0x00004e98  adrp     x0, #0x17000
0x00004e9c  add      x0, x0, #0x48 ; -> __DATA_CONST,__objc_arrayobj+0x30 (const collection)
0x00004ea0  add      x2, sp, #0x100
0x00004ea4  add      x3, sp, #0x2f8
0x00004ea8  mov      w4, #0x10
0x00004eac  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00004eb0  cbz      x0, #0x4fec
0x00004eb4  mov      x21, x0
0x00004eb8  ldr      x8, [sp, #0x110]
0x00004ebc  ldr      x26, [x8] ; -> [selref(CGContext)]
0x00004ec0  adrp     x27, #0x18000
0x00004ec4  mov      x28, #0
0x00004ec8  ldr      x8, [sp, #0x110]
0x00004ecc  ldr      x8, [x8] ; -> [selref(CGContext)]
0x00004ed0  cmp      x8, x26
0x00004ed4  b.eq     #0x4ee4
0x00004ed8  adrp     x0, #0x17000
0x00004edc  add      x0, x0, #0x48 ; -> __DATA_CONST,__objc_arrayobj+0x30 (const collection)
0x00004ee0  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x00004ee4  ldr      x8, [sp, #0x108]
0x00004ee8  ldr      x24, [x8, x28, lsl #3] ; -> [selref(CGContext)]
0x00004eec  mov      x0, x24
0x00004ef0  mov      x1, #0
0x00004ef4  bl       #0x6534 ; call _OMCPref
0x00004ef8  mov      x29, x29
0x00004efc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00004f00  mov      x23, x0
0x00004f04  ldr      x0, [x27, #0x450] ; -> [classref(NSArray)]
0x00004f08  bl       #0xd47c ; call stub:_objc_opt_class
0x00004f0c  mov      x1, x0
0x00004f10  mov      x0, x23
0x00004f14  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x00004f18  tbz      w0, #0, #0x4fb8
0x00004f1c  add      x8, sp, #0xc0
0x00004f20  movi     v0.16b, #0
0x00004f24  stp      q0, q0, [x8, #0x20]
0x00004f28  stp      q0, q0, [sp, #0xc0]
0x00004f2c  mov      x0, x23
0x00004f30  bl       #0xd4c4 ; call stub:_objc_retain
0x00004f34  add      x2, sp, #0xc0
0x00004f38  add      x3, sp, #0x278
0x00004f3c  mov      x0, x23
0x00004f40  mov      w4, #0x10
0x00004f44  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00004f48  cbz      x0, #0x4fb0
0x00004f4c  mov      x25, x0
0x00004f50  ldr      x8, [sp, #0xd0]
0x00004f54  ldr      x19, [x8] ; -> [selref(CGContext)]
0x00004f58  mov      x22, #0
0x00004f5c  ldr      x8, [sp, #0xd0]
0x00004f60  ldr      x8, [x8] ; -> [selref(CGContext)]
0x00004f64  cmp      x8, x19
0x00004f68  b.eq     #0x4f74
0x00004f6c  mov      x0, x23
0x00004f70  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x00004f74  ldr      x8, [sp, #0xc8]
0x00004f78  ldr      x3, [x8, x22, lsl #3] ; -> [selref(CGContext)]
0x00004f7c  mov      x0, x20
0x00004f80  mov      x2, x24
0x00004f84  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x00004f88  add      x22, x22, #1 ; -> __DATA_CONST,__objc_arrayobj+0x19 (const collection)
0x00004f8c  cmp      x25, x22
0x00004f90  b.ne     #0x4f5c
0x00004f94  add      x2, sp, #0xc0
0x00004f98  add      x3, sp, #0x278
0x00004f9c  mov      x0, x23
0x00004fa0  mov      w4, #0x10
0x00004fa4  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00004fa8  mov      x25, x0
0x00004fac  cbnz     x0, #0x4f58
0x00004fb0  mov      x0, x23
0x00004fb4  bl       #0xd4b8 ; call stub:_objc_release
0x00004fb8  mov      x0, x23
0x00004fbc  bl       #0xd4b8 ; call stub:_objc_release
0x00004fc0  add      x28, x28, #1
0x00004fc4  cmp      x28, x21
0x00004fc8  b.ne     #0x4ec8
0x00004fcc  add      x2, sp, #0x100
0x00004fd0  add      x3, sp, #0x2f8
0x00004fd4  adrp     x0, #0x17000
0x00004fd8  add      x0, x0, #0x48 ; -> __DATA_CONST,__objc_arrayobj+0x30 (const collection)
0x00004fdc  mov      w4, #0x10
0x00004fe0  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00004fe4  mov      x21, x0
0x00004fe8  cbnz     x0, #0x4ec4
0x00004fec  adrp     x0, #0xe000
0x00004ff0  add      x0, x0, #0xc6e ; -> "SBMediaController"
0x00004ff4  bl       #0xd464 ; call stub:_objc_getClass
0x00004ff8  adrp     x1, #0x14000
0x00004ffc  add      x1, x1, #0xe48 ; -> CFSTR("sharedInstance")
0x00005000  bl       #0x6078 ; call sub_6078
0x00005004  mov      x29, x29
0x00005008  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000500c  mov      x22, x0
0x00005010  adrp     x1, #0x15000
0x00005014  add      x1, x1, #0xc8 ; -> CFSTR("nowPlayingApplication")
0x00005018  bl       #0x6078 ; call sub_6078
0x0000501c  mov      x29, x29
0x00005020  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005024  mov      x23, x0
0x00005028  adrp     x1, #0x14000
0x0000502c  add      x1, x1, #0xd08 ; -> CFSTR("bundleIdentifier")
0x00005030  bl       #0x6078 ; call sub_6078
0x00005034  mov      x29, x29
0x00005038  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000503c  mov      x21, x0
0x00005040  mov      x0, x23
0x00005044  bl       #0xd4b8 ; call stub:_objc_release
0x00005048  mov      x0, x22
0x0000504c  bl       #0xd4b8 ; call stub:_objc_release
0x00005050  cbz      x21, #0x5068
0x00005054  adrp     x2, #0x15000
0x00005058  add      x2, x2, #0xe8 ; -> CFSTR("playing")
0x0000505c  mov      x0, x20
0x00005060  mov      x3, x21
0x00005064  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x00005068  adrp     x8, #0x18000
0x0000506c  ldr      x0, [x8, #0x478] ; -> [classref(UIApplication)]
0x00005070  bl       #0xe340 ; call objc_stub[sharedApplication]
0x00005074  mov      x29, x29
0x00005078  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000507c  mov      x23, x0
0x00005080  adrp     x1, #0x15000
0x00005084  add      x1, x1, #0x108 ; -> CFSTR("_accessibilityFrontMostApplication")
0x00005088  bl       #0x6078 ; call sub_6078
0x0000508c  mov      x29, x29
0x00005090  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005094  mov      x24, x0
0x00005098  adrp     x1, #0x14000
0x0000509c  add      x1, x1, #0xd08 ; -> CFSTR("bundleIdentifier")
0x000050a0  bl       #0x6078 ; call sub_6078
0x000050a4  mov      x29, x29
0x000050a8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000050ac  mov      x22, x0
0x000050b0  mov      x0, x24
0x000050b4  bl       #0xd4b8 ; call stub:_objc_release
0x000050b8  mov      x0, x23
0x000050bc  bl       #0xd4b8 ; call stub:_objc_release
0x000050c0  ldr      x28, [sp, #0x48]
0x000050c4  cbz      x22, #0x50dc
0x000050c8  adrp     x2, #0x15000
0x000050cc  add      x2, x2, #0x128 ; -> CFSTR("front")
0x000050d0  mov      x0, x20
0x000050d4  mov      x3, x22
0x000050d8  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x000050dc  mov      x0, x22
0x000050e0  bl       #0xd4b8 ; call stub:_objc_release
0x000050e4  mov      x0, x21
0x000050e8  bl       #0xd4b8 ; call stub:_objc_release
0x000050ec  adrp     x19, #0x18000
0x000050f0  ldr      x0, [x19, #0x458] ; -> [classref(NSMutableArray)]
0x000050f4  bl       #0xd740 ; call objc_stub[array]
0x000050f8  mov      x29, x29
0x000050fc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005100  str      x0, [sp, #0x40]
0x00005104  ldr      x0, [x19, #0x458] ; -> [classref(NSMutableArray)]
0x00005108  bl       #0xd740 ; call objc_stub[array]
0x0000510c  mov      x29, x29
0x00005110  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005114  str      x0, [sp, #0x50]
0x00005118  movi     v0.16b, #0
0x0000511c  stp      q0, q0, [sp, #0x80]
0x00005120  stp      q0, q0, [sp, #0xa0]
0x00005124  mov      x0, x28
0x00005128  bl       #0xd4c4 ; call stub:_objc_retain
0x0000512c  add      x2, sp, #0x80
0x00005130  add      x3, sp, #0x1f8
0x00005134  mov      x0, x28
0x00005138  mov      w4, #0x10
0x0000513c  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x00005140  adrp     x19, #0x18000
0x00005144  cbz      x0, #0x5494
0x00005148  mov      x26, x0
0x0000514c  adrp     x25, #0x14000
0x00005150  add      x25, x25, #0xd08 ; -> CFSTR("bundleIdentifier")
0x00005154  ldr      x8, [sp, #0x90]
0x00005158  ldr      x24, [x8] ; -> [selref(CGContext)]
0x0000515c  mov      x23, #0
0x00005160  ldr      x8, [sp, #0x90]
0x00005164  ldr      x8, [x8] ; -> [selref(CGContext)]
0x00005168  cmp      x8, x24
0x0000516c  b.eq     #0x5178
0x00005170  mov      x0, x28
0x00005174  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x00005178  ldr      x8, [sp, #0x88]
0x0000517c  ldr      x0, [x8, x23, lsl #3] ; -> [selref(CGContext)]
0x00005180  mov      x1, x25
0x00005184  bl       #0x6078 ; call sub_6078
0x00005188  mov      x29, x29
0x0000518c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005190  mov      x27, x0
0x00005194  ldr      x0, [x19, #0x3f0] ; -> [classref(NSString)]
0x00005198  bl       #0xd47c ; call stub:_objc_opt_class
0x0000519c  mov      x1, x0
0x000051a0  mov      x0, x27
0x000051a4  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x000051a8  tbz      w0, #0, #0x543c
0x000051ac  mov      x0, x20
0x000051b0  mov      x2, x27
0x000051b4  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x000051b8  mov      x29, x29
0x000051bc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000051c0  mov      x21, x0
0x000051c4  bl       #0xd4b8 ; call stub:_objc_release
0x000051c8  cbz      x21, #0x5228
0x000051cc  ldr      x21, [x19, #0x3f0] ; -> [classref(NSString)]
0x000051d0  mov      x0, x20
0x000051d4  mov      x2, x27
0x000051d8  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x000051dc  mov      x29, x29
0x000051e0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000051e4  mov      x22, x0
0x000051e8  stp      x27, x0, [sp]
0x000051ec  mov      x0, x21
0x000051f0  adrp     x2, #0x14000
0x000051f4  add      x2, x2, #0xd28 ; -> CFSTR("%@ (%@)")
0x000051f8  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x000051fc  mov      x29, x29
0x00005200  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005204  mov      x21, x0
0x00005208  ldr      x0, [sp, #0x50]
0x0000520c  mov      x2, x21
0x00005210  bl       #0xd6a0 ; call objc_stub[addObject:]
0x00005214  mov      x0, x21
0x00005218  bl       #0xd4b8 ; call stub:_objc_release
0x0000521c  mov      x0, x22
0x00005220  bl       #0xd4b8 ; call stub:_objc_release
0x00005224  b        #0x543c
0x00005228  mov      x0, x27
0x0000522c  bl       #0xd4c4 ; call stub:_objc_retain
0x00005230  adrp     x0, #0xe000
0x00005234  add      x0, x0, #0xcc7 ; -> "LSApplicationProxy"
0x00005238  bl       #0xd464 ; call stub:_objc_getClass
0x0000523c  mov      x21, x0
0x00005240  adrp     x0, #0x15000
0x00005244  add      x0, x0, #0x148 ; -> CFSTR("applicationProxyForIdentifier:")
0x00005248  bl       #0xd170 ; call stub:_NSSelectorFromString
0x0000524c  mov      x22, x0
0x00005250  mov      x0, x21
0x00005254  mov      x1, x22
0x00005258  bl       #0xd4a0 ; call stub:_objc_opt_respondsToSelector
0x0000525c  tbz      w0, #0, #0x5280
0x00005260  mov      x0, x21
0x00005264  mov      x1, x22
0x00005268  mov      x2, x27
0x0000526c  bl       #0xd470 ; call stub:_objc_msgSend
0x00005270  mov      x29, x29
0x00005274  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005278  mov      x28, x0
0x0000527c  b        #0x5284
0x00005280  mov      x28, #0
0x00005284  mov      x0, x28
0x00005288  adrp     x1, #0x15000
0x0000528c  add      x1, x1, #0x168 ; -> CFSTR("applicationType")
0x00005290  bl       #0x6078 ; call sub_6078
0x00005294  mov      x29, x29
0x00005298  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000529c  mov      x22, x0
0x000052a0  adrp     x2, #0x15000
0x000052a4  add      x2, x2, #0x188 ; -> CFSTR("User")
0x000052a8  bl       #0xdc60 ; call objc_stub[isEqual:]
0x000052ac  tbz      w0, #0, #0x530c
0x000052b0  mov      x0, x22
0x000052b4  bl       #0xd4b8 ; call stub:_objc_release
0x000052b8  mov      x0, x28
0x000052bc  bl       #0xd4b8 ; call stub:_objc_release
0x000052c0  mov      x0, x27
0x000052c4  bl       #0xd4b8 ; call stub:_objc_release
0x000052c8  ldr      x28, [sp, #0x48]
0x000052cc  mov      x0, x27
0x000052d0  bl       #0xd4c4 ; call stub:_objc_retain
0x000052d4  adrp     x8, #0x18000
0x000052d8  ldr      x8, [x8, #0x548] ; -> [__DATA,__bss+0x48]
0x000052dc  cmn      x8, #1
0x000052e0  b.ne     #0x5470
0x000052e4  adrp     x8, #0x18000
0x000052e8  ldr      x8, [x8, #0x540] ; -> [__DATA,__bss+0x40]
0x000052ec  cbz      x8, #0x539c
0x000052f0  mov      x0, x27
0x000052f4  mov      w1, #5
0x000052f8  mov      w2, #0
0x000052fc  adrp     x3, #0x15000
0x00005300  add      x3, x3, #0x208 ; -> CFSTR("OmniCar: free memory")
0x00005304  blr      x8
0x00005308  b        #0x5408
0x0000530c  mov      x0, x22
0x00005310  adrp     x2, #0x15000
0x00005314  add      x2, x2, #0x1a8 ; -> CFSTR("System")
0x00005318  bl       #0xdc60 ; call objc_stub[isEqual:]
0x0000531c  tbz      w0, #0, #0x5420
0x00005320  mov      x0, x28
0x00005324  adrp     x1, #0x15000
0x00005328  add      x1, x1, #0x1c8 ; -> CFSTR("appTags")
0x0000532c  bl       #0x6078 ; call sub_6078
0x00005330  mov      x29, x29
0x00005334  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005338  mov      x21, x0
0x0000533c  adrp     x8, #0x18000
0x00005340  ldr      x0, [x8, #0x450] ; -> [classref(NSArray)]
0x00005344  bl       #0xd47c ; call stub:_objc_opt_class
0x00005348  mov      x1, x0
0x0000534c  mov      x0, x21
0x00005350  bl       #0xd488 ; call stub:_objc_opt_isKindOfClass
0x00005354  tbz      w0, #0, #0x5464
0x00005358  mov      x0, x21
0x0000535c  adrp     x2, #0x15000
0x00005360  add      x2, x2, #0x1e8 ; -> CFSTR("hidden")
0x00005364  bl       #0xd900 ; call objc_stub[containsObject:]
0x00005368  str      w0, [sp, #0x3c]
0x0000536c  mov      x0, x21
0x00005370  bl       #0xd4b8 ; call stub:_objc_release
0x00005374  mov      x0, x22
0x00005378  bl       #0xd4b8 ; call stub:_objc_release
0x0000537c  mov      x0, x28
0x00005380  bl       #0xd4b8 ; call stub:_objc_release
0x00005384  mov      x0, x27
0x00005388  bl       #0xd4b8 ; call stub:_objc_release
0x0000538c  ldr      x28, [sp, #0x48]
0x00005390  ldr      w8, [sp, #0x3c]
0x00005394  tbz      w8, #0, #0x52cc
0x00005398  b        #0x543c
0x0000539c  adrp     x0, #0xe000
0x000053a0  add      x0, x0, #0xdc2 ; -> "FBSSystemService"
0x000053a4  bl       #0xd464 ; call stub:_objc_getClass
0x000053a8  adrp     x1, #0x15000
0x000053ac  add      x1, x1, #0x228 ; -> CFSTR("sharedService")
0x000053b0  bl       #0x6078 ; call sub_6078
0x000053b4  mov      x29, x29
0x000053b8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000053bc  mov      x22, x0
0x000053c0  adrp     x0, #0x15000
0x000053c4  add      x0, x0, #0x248 ; -> CFSTR("terminateApplication:forReason:andReport:withDescription:")
0x000053c8  bl       #0xd170 ; call stub:_NSSelectorFromString
0x000053cc  mov      x21, x0
0x000053d0  mov      x0, x22
0x000053d4  mov      x1, x21
0x000053d8  bl       #0xd4a0 ; call stub:_objc_opt_respondsToSelector
0x000053dc  tbz      w0, #0, #0x5454
0x000053e0  mov      x0, x22
0x000053e4  mov      x1, x21
0x000053e8  mov      x2, x27
0x000053ec  mov      w3, #1
0x000053f0  mov      w4, #0
0x000053f4  adrp     x5, #0x15000
0x000053f8  add      x5, x5, #0x208 ; -> CFSTR("OmniCar: free memory")
0x000053fc  bl       #0xd470 ; call stub:_objc_msgSend
0x00005400  mov      x0, x22
0x00005404  bl       #0xd4b8 ; call stub:_objc_release
0x00005408  mov      x0, x27
0x0000540c  bl       #0xd4b8 ; call stub:_objc_release
0x00005410  ldr      x0, [sp, #0x40]
0x00005414  mov      x2, x27
0x00005418  bl       #0xd6a0 ; call objc_stub[addObject:]
0x0000541c  b        #0x543c
0x00005420  mov      x0, x22
0x00005424  bl       #0xd4b8 ; call stub:_objc_release
0x00005428  mov      x0, x28
0x0000542c  bl       #0xd4b8 ; call stub:_objc_release
0x00005430  mov      x0, x27
0x00005434  bl       #0xd4b8 ; call stub:_objc_release
0x00005438  ldr      x28, [sp, #0x48]
0x0000543c  mov      x0, x27
0x00005440  bl       #0xd4b8 ; call stub:_objc_release
0x00005444  add      x23, x23, #1
0x00005448  cmp      x26, x23
0x0000544c  b.ne     #0x5160
0x00005450  b        #0x5478
0x00005454  mov      x0, x22
0x00005458  bl       #0xd4b8 ; call stub:_objc_release
0x0000545c  mov      x0, x27
0x00005460  b        #0x5220
0x00005464  mov      x0, x21
0x00005468  bl       #0xd4b8 ; call stub:_objc_release
0x0000546c  b        #0x52b0
0x00005470  bl       #0xd02c ; call sub_d02c
0x00005474  b        #0x52e4
0x00005478  add      x2, sp, #0x80
0x0000547c  add      x3, sp, #0x1f8
0x00005480  mov      x0, x28
0x00005484  mov      w4, #0x10
0x00005488  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x0000548c  mov      x26, x0
0x00005490  cbnz     x0, #0x515c
0x00005494  ldr      x8, [sp, #0x30]
0x00005498  cmp      x8, #0
0x0000549c  cset     w8, ne
0x000054a0  str      x8, [sp, #0x48]
0x000054a4  mov      x0, x28
0x000054a8  bl       #0xd4b8 ; call stub:_objc_release
0x000054ac  adrp     x8, #0x14000
0x000054b0  add      x8, x8, #0xd68 ; -> CFSTR("date")
0x000054b4  str      x8, [sp, #0x1c8]
0x000054b8  adrp     x8, #0x18000
0x000054bc  ldr      x0, [x8, #0x460] ; -> [classref(NSDate)]
0x000054c0  bl       #0xd9e0 ; call objc_stub[date]
0x000054c4  mov      x29, x29
0x000054c8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000054cc  mov      x21, x0
0x000054d0  adrp     x8, #0x14000
0x000054d4  add      x8, x8, #0xd88 ; -> CFSTR("closed")
0x000054d8  ldr      x27, [sp, #0x40]
0x000054dc  stp      x0, x27, [sp, #0x1e0]
0x000054e0  adrp     x9, #0x14000
0x000054e4  add      x9, x9, #0xda8 ; -> CFSTR("running")
0x000054e8  stp      x8, x9, [sp, #0x1d0]
0x000054ec  adrp     x8, #0x18000
0x000054f0  ldr      x22, [x8, #0x448] ; -> [classref(NSNumber)]
0x000054f4  mov      x0, x28
0x000054f8  bl       #0xd960 ; call objc_stub[count]
0x000054fc  mov      x2, x0
0x00005500  mov      x0, x22
0x00005504  bl       #0xdf00 ; call objc_stub[numberWithUnsignedInteger:]
0x00005508  mov      x29, x29
0x0000550c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00005510  mov      x22, x0
0x00005514  str      x0, [sp, #0x1f0]
0x00005518  adrp     x8, #0x18000
0x0000551c  ldr      x0, [x8, #0x468] ; -> [classref(NSDictionary)]
0x00005520  add      x2, sp, #0x1e0
0x00005524  add      x3, sp, #0x1c8
0x00005528  mov      w4, #3
0x0000552c  bl       #0xdac0 ; call objc_stub[dictionaryWithObjects:forKeys:count:]
0x00005530  mov      x1, x0
0x00005534  adrp     x0, #0x14000
0x00005538  add      x0, x0, #0xd48 ; -> CFSTR("diagCleanRam")
0x0000553c  adrp     x2, #0x14000
0x00005540  add      x2, x2, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x00005544  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x00005548  mov      x0, x22
0x0000554c  bl       #0xd4b8 ; call stub:_objc_release
0x00005550  mov      x0, x21
0x00005554  bl       #0xd4b8 ; call stub:_objc_release
0x00005558  bl       #0x6528 ; call _OMCPrefsSync
0x0000555c  ldr      x21, [x19, #0x3f0] ; -> [classref(NSString)]
0x00005560  adrp     x8, #0x14000
0x00005564  add      x8, x8, #0xe08 ; -> CFSTR("cam xe")
0x00005568  adrp     x9, #0x14000
0x0000556c  add      x9, x9, #0xde8 ; -> CFSTR("bam tay")
0x00005570  ldr      w10, [sp, #0x38]
0x00005574  cmp      w10, #0
0x00005578  csel     x19, x9, x8, ne
0x0000557c  mov      x0, x28
0x00005580  bl       #0xd960 ; call objc_stub[count]
0x00005584  mov      x22, x0
0x00005588  mov      x0, x27
0x0000558c  bl       #0xd960 ; call objc_stub[count]
0x00005590  mov      x23, x0
0x00005594  adrp     x25, #0x14000
0x00005598  add      x25, x25, #0xa68 ; -> CFSTR(", ")
0x0000559c  mov      x0, x27
0x000055a0  mov      x2, x25
0x000055a4  bl       #0xd880 ; call objc_stub[componentsJoinedByString:]
0x000055a8  mov      x29, x29
0x000055ac  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000055b0  mov      x26, x0
0x000055b4  ldr      x24, [sp, #0x50]
0x000055b8  mov      x0, x24
0x000055bc  mov      x2, x25
0x000055c0  bl       #0xd880 ; call objc_stub[componentsJoinedByString:]
0x000055c4  mov      x29, x29
0x000055c8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000055cc  mov      x25, x0
0x000055d0  stp      x26, x0, [sp, #0x20]
0x000055d4  stp      x22, x23, [sp, #0x10]
0x000055d8  ldr      x8, [sp, #0x48]
0x000055dc  stp      x19, x8, [sp]
0x000055e0  adrp     x2, #0x14000
0x000055e4  add      x2, x2, #0xdc8 ; -> CFSTR("don RAM (%@, xe=%d): %lu app dang chay, dong %lu: %@ | giu lai: %@")
0x000055e8  mov      x0, x21
0x000055ec  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x000055f0  mov      x29, x29
0x000055f4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000055f8  mov      x21, x0
0x000055fc  adrp     x0, #0x14000
0x00005600  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x00005604  mov      x1, x21
0x00005608  bl       #0x6be4 ; call _OMCLogWrite
0x0000560c  mov      x0, x21
0x00005610  bl       #0xd4b8 ; call stub:_objc_release
0x00005614  mov      x0, x25
0x00005618  bl       #0xd4b8 ; call stub:_objc_release
0x0000561c  mov      x0, x26
0x00005620  bl       #0xd4b8 ; call stub:_objc_release
0x00005624  mov      x0, #0
0x00005628  mov      w1, #0x9400
0x0000562c  movk     w1, #0x7735, lsl #16
0x00005630  bl       #0xd2d8 ; call stub:_dispatch_time
0x00005634  mov      x21, x0
0x00005638  adrp     x8, #0x14000
0x0000563c  ldr      x8, [x8, #0x1a0] ; -> [got(__NSConcreteStackBlock)]
0x00005640  str      x8, [sp, #0x58]
0x00005644  adrp     x8, #0xf000
0x00005648  ldr      d0, [x8, #0xab8] ; -> [__TEXT,__const+0x8 [u64=0xc2000000 f64=1.6080749353e-314]]
0x0000564c  adrp     x8, #0x6000
0x00005650  add      x8, x8, #0x320 ; -> __TEXT,__text+0x2320
0x00005654  str      d0, [sp, #0x60]
0x00005658  adrp     x9, #0x14000
0x0000565c  add      x9, x9, #0x5e8 ; -> __DATA_CONST,__const+0x1e0 [u64=0x0 f64=0.0]
0x00005660  stp      x8, x9, [sp, #0x68]
0x00005664  str      x27, [sp, #0x78]
0x00005668  mov      x0, x27
0x0000566c  bl       #0xd4c4 ; call stub:_objc_retain
0x00005670  adrp     x1, #0x14000
0x00005674  ldr      x1, [x1, #0x1d0] ; -> [got(__dispatch_main_q)]
0x00005678  add      x2, sp, #0x58
0x0000567c  mov      x0, x21
0x00005680  bl       #0xd260 ; call stub:_dispatch_after
0x00005684  ldr      x0, [sp, #0x78]
0x00005688  bl       #0xd4b8 ; call stub:_objc_release
0x0000568c  mov      x0, x27
0x00005690  bl       #0xd4b8 ; call stub:_objc_release
0x00005694  mov      x0, x24
0x00005698  bl       #0xd4b8 ; call stub:_objc_release
0x0000569c  mov      x0, x20
0x000056a0  bl       #0xd4b8 ; call stub:_objc_release
0x000056a4  mov      x0, x28
0x000056a8  bl       #0xd4b8 ; call stub:_objc_release
0x000056ac  b        #0x56ec
0x000056b0  bl       #0x659c ; call _OMCEnabled
0x000056b4  cbz      w0, #0x56ec
0x000056b8  adrp     x0, #0x14000
0x000056bc  add      x0, x0, #0xcc8 ; -> CFSTR("cleanRamOnConnect")
0x000056c0  adrp     x1, #0x14000
0x000056c4  ldr      x1, [x1, #0x180] ; -> [got(___kCFBooleanFalse)]
0x000056c8  bl       #0x6534 ; call _OMCPref
0x000056cc  mov      x29, x29
0x000056d0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000056d4  mov      x19, x0
0x000056d8  bl       #0xd7c0 ; call objc_stub[boolValue]
0x000056dc  mov      x20, x0
0x000056e0  mov      x0, x19
0x000056e4  bl       #0xd4b8 ; call stub:_objc_release
0x000056e8  cbnz     w20, #0x4cdc
0x000056ec  ldur     x8, [x29, #-0x68]
0x000056f0  adrp     x9, #0x14000
0x000056f4  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x000056f8  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x000056fc  cmp      x9, x8
0x00005700  b.ne     #0x5724
0x00005704  add      sp, sp, #0x490
0x00005708  ldp      x29, x30, [sp, #0x50]
0x0000570c  ldp      x20, x19, [sp, #0x40]
0x00005710  ldp      x22, x21, [sp, #0x30]
0x00005714  ldp      x24, x23, [sp, #0x20]
0x00005718  ldp      x26, x25, [sp, #0x10]
0x0000571c  ldp      x28, x27, [sp], #0x60
0x00005720  ret      
0x00005724  bl       #0xd1b8 ; call stub:___stack_chk_fail
