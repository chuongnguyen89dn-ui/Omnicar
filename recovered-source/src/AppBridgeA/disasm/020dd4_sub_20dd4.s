; ==== sub_20dd4 @ 0x20dd4..0x21244 (1136 bytes) ====
0x00020dd4  b.eq     #0x20de0
0x00020dd8  ldr      x0, [sp, #0x28]
0x00020ddc  bl       #0x24770   ; call _objc_enumerationMutation
0x00020de0  ldr      x8, [sp, #0x88]
0x00020de4  ldr      x9, [sp, #0x68]
0x00020de8  ldr      x19, [x8, x9, lsl #3]
0x00020dec  mov      x0, x19
0x00020df0  bl       #0x24818   ; call _objc_retain
0x00020df4  str      x19, [sp, #0x70]
0x00020df8  cbz      x19, #0x21c54
0x00020dfc  adrp     x8, #0x3e000
0x00020e00  ldr      x0, [x8, #0x430]   ; -> [class(UIScreen)]
0x00020e04  bl       #0x260e0   ; objc_msgSend: mainScreen
0x00020e08  mov      x29, x29
0x00020e0c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020e10  ldr      x8, [sp, #0x70]
0x00020e14  cmp      x8, x0
0x00020e18  cset     w19, eq
0x00020e1c  bl       #0x2480c   ; call _objc_release
0x00020e20  tbnz     w19, #0, #0x21c54
0x00020e24  ldr      x19, [sp, #0x70]
0x00020e28  mov      x0, x19
0x00020e2c  bl       #0x24818   ; call _objc_retain
0x00020e30  adrp     x8, #0x3e000
0x00020e34  ldr      x8, [x8, #0xac8]
0x00020e38  cbnz     x8, #0x211e0
0x00020e3c  mov      x0, x19
0x00020e40  bl       #0x24818   ; call _objc_retain
0x00020e44  adrp     x8, #0x3e000
0x00020e48  ldr      x0, [x8, #0xac8]
0x00020e4c  str      x19, [x8, #0xac8]
0x00020e50  bl       #0x2480c   ; call _objc_release
0x00020e54  adrp     x9, #0x3e000
0x00020e58  ldr      x8, [x9, #0xb48]
0x00020e5c  add      x8, x8, #1
0x00020e60  str      x8, [x9, #0xb48]
0x00020e64  adrp     x8, #0x3e000
0x00020e68  ldr      x0, [x8, #0x418]   ; -> [class(NSDate)]
0x00020e6c  bl       #0x25480   ; objc_msgSend: date
0x00020e70  mov      x29, x29
0x00020e74  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020e78  adrp     x9, #0x3e000
0x00020e7c  ldr      x8, [x9, #0xae0]
0x00020e80  str      x0, [x9, #0xae0]
0x00020e84  mov      x0, x8
0x00020e88  bl       #0x2480c   ; call _objc_release
0x00020e8c  adrp     x8, #0x3e000
0x00020e90  ldr      x0, [x8, #0x420]   ; -> [class(NSMutableOrderedSet)]
0x00020e94  bl       #0x26480   ; objc_msgSend: orderedSet
0x00020e98  mov      x29, x29
0x00020e9c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020ea0  mov      x19, x0
0x00020ea4  bl       #0x244c4   ; call __dyld_image_count
0x00020ea8  cbz      w0, #0x20f6c
0x00020eac  mov      w20, #0
0x00020eb0  mov      x0, x20
0x00020eb4  bl       #0x244b8   ; call __dyld_get_image_name
0x00020eb8  mov      x22, x0
0x00020ebc  cbz      x0, #0x20f5c
0x00020ec0  mov      x0, x22
0x00020ec4  adrp     x1, #0x2a000
0x00020ec8  add      x1, x1, #0xd08   ; -> "/DynamicLibraries/"
0x00020ecc  bl       #0x24974   ; call _strstr
0x00020ed0  cbnz     x0, #0x20ee8
0x00020ed4  mov      x0, x22
0x00020ed8  adrp     x1, #0x2a000
0x00020edc  add      x1, x1, #0xd1b   ; -> "/TweakInject/"
0x00020ee0  bl       #0x24974   ; call _strstr
0x00020ee4  cbz      x0, #0x20f5c
0x00020ee8  adrp     x8, #0x3e000
0x00020eec  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x00020ef0  mov      x2, x22
0x00020ef4  bl       #0x27d40   ; objc_msgSend: stringWithUTF8String:
0x00020ef8  mov      x29, x29
0x00020efc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020f00  mov      x23, x0
0x00020f04  bl       #0x25ec0   ; objc_msgSend: lastPathComponent
0x00020f08  mov      x29, x29
0x00020f0c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020f10  mov      x21, x0
0x00020f14  bl       #0x27ca0   ; objc_msgSend: stringByDeletingPathExtension
0x00020f18  mov      x29, x29
0x00020f1c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020f20  mov      x22, x0
0x00020f24  mov      x0, x21
0x00020f28  bl       #0x2480c   ; call _objc_release
0x00020f2c  mov      x0, x23
0x00020f30  bl       #0x2480c   ; call _objc_release
0x00020f34  mov      x0, x22
0x00020f38  adrp     x2, #0x38000
0x00020f3c  add      x2, x2, #0x2d0   ; -> @"OmniCar"
0x00020f40  bl       #0x258a0   ; objc_msgSend: hasPrefix:
0x00020f44  tbnz     w0, #0, #0x20f54
0x00020f48  mov      x0, x19
0x00020f4c  mov      x2, x22
0x00020f50  bl       #0x24b20   ; objc_msgSend: addObject:
0x00020f54  mov      x0, x22
0x00020f58  bl       #0x2480c   ; call _objc_release
0x00020f5c  bl       #0x244c4   ; call __dyld_image_count
0x00020f60  add      w20, w20, #1
0x00020f64  cmp      w20, w0
0x00020f68  b.lo     #0x20eb0
0x00020f6c  mov      x0, x19
0x00020f70  bl       #0x24dc0   ; objc_msgSend: array
0x00020f74  mov      x29, x29
0x00020f78  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020f7c  mov      x20, x0
0x00020f80  mov      x0, x19
0x00020f84  bl       #0x2480c   ; call _objc_release
0x00020f88  adrp     x8, #0x3e000
0x00020f8c  ldr      x0, [x8, #0xae8]
0x00020f90  str      x20, [x8, #0xae8]
0x00020f94  bl       #0x2480c   ; call _objc_release
0x00020f98  adrp     x8, #0x3e000
0x00020f9c  ldr      x0, [x8, #0x398]   ; -> [class(NSMutableDictionary)]
0x00020fa0  bl       #0x25580   ; objc_msgSend: dictionary
0x00020fa4  mov      x29, x29
0x00020fa8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020fac  adrp     x9, #0x3e000
0x00020fb0  ldr      x8, [x9, #0xaf0]
0x00020fb4  str      x0, [x9, #0xaf0]
0x00020fb8  mov      x0, x8
0x00020fbc  bl       #0x2480c   ; call _objc_release
0x00020fc0  ldr      x0, [sp, #0x70]
0x00020fc4  bl       #0x26140   ; objc_msgSend: maximumFramesPerSecond
0x00020fc8  cmp      x0, #1
0x00020fcc  csinc    x8, x0, xzr, gt
0x00020fd0  ucvtf    d0, x8
0x00020fd4  fdiv     d0, d8, d0
0x00020fd8  adrp     x8, #0x3e000
0x00020fdc  str      d0, [x8, #0xb50]
0x00020fe0  adrp     x8, #0x3e000
0x00020fe4  str      xzr, [x8, #0xb58]
0x00020fe8  adrp     x8, #0x3e000
0x00020fec  str      xzr, [x8, #0xb60]
0x00020ff0  adrp     x8, #0x3e000
0x00020ff4  str      xzr, [x8, #0xb68]
0x00020ff8  adrp     x8, #0x3e000
0x00020ffc  str      xzr, [x8, #0xb70]
0x00021000  adrp     x8, #0x3e000
0x00021004  str      xzr, [x8, #0xb78]
0x00021008  adrp     x8, #0x3e000
0x0002100c  str      xzr, [x8, #0xb80]
0x00021010  adrp     x8, #0x3e000
0x00021014  str      xzr, [x8, #0xb88]
0x00021018  adrp     x8, #0x3e000
0x0002101c  str      xzr, [x8, #0xb90]
0x00021020  adrp     x8, #0x3e000
0x00021024  str      xzr, [x8, #0xb98]
0x00021028  adrp     x8, #0x3e000
0x0002102c  str      xzr, [x8, #0xba0]
0x00021030  adrp     x8, #0x3e000
0x00021034  str      xzr, [x8, #0xba8]
0x00021038  adrp     x8, #0x3e000
0x0002103c  mov      x9, #0x7fefffffffffffff
0x00021040  str      x9, [x8, #0xbb0]
0x00021044  adrp     x8, #0x3e000
0x00021048  str      x9, [x8, #0xbb8]
0x0002104c  adrp     x8, #0x3e000
0x00021050  str      xzr, [x8, #0xbc0]
0x00021054  adrp     x8, #0x3e000
0x00021058  str      xzr, [x8, #0xbc8]
0x0002105c  adrp     x8, #0x3e000
0x00021060  strb     wzr, [x8, #0xbd0]
0x00021064  adrp     x8, #0x3e000
0x00021068  str      xzr, [x8, #0xbd8]
0x0002106c  adrp     x8, #0x3e000
0x00021070  str      xzr, [x8, #0xbe0]
0x00021074  adrp     x8, #0x3e000
0x00021078  mov      x9, #-0x4010000000000000
0x0002107c  str      x9, [x8, #0xbe8]
0x00021080  adrp     x8, #0x3e000
0x00021084  add      x8, x8, #0xbf0
0x00021088  stp      xzr, xzr, [x8, #8]
0x0002108c  str      xzr, [x8]
0x00021090  adrp     x8, #0x3e000
0x00021094  str      xzr, [x8, #0xc08]
0x00021098  adrp     x8, #0x3e000
0x0002109c  ldr      x0, [x8, #0xaf8]
0x000210a0  str      xzr, [x8, #0xaf8]
0x000210a4  bl       #0x2480c   ; call _objc_release
0x000210a8  adrp     x8, #0x3e000
0x000210ac  strb     wzr, [x8, #0xc10]
0x000210b0  mov      w0, #0
0x000210b4  bl       #0x2205c   ; call sub_2205c
0x000210b8  adrp     x8, #0x3e000
0x000210bc  add      x8, x8, #0xc11
0x000210c0  stlrb    wzr, [x8]
0x000210c4  adrp     x0, #0x2a000
0x000210c8  add      x0, x0, #0xc99   ; -> "com.anlai.omnicar.perf"
0x000210cc  mov      x1, #0
0x000210d0  bl       #0x24584   ; call _dispatch_queue_create
0x000210d4  mov      x19, x0
0x000210d8  adrp     x0, #0x34000
0x000210dc  ldr      x0, [x0, #0x298]   ; -> [got:__dispatch_source_type_timer]
0x000210e0  mov      x1, #0
0x000210e4  mov      x2, #0
0x000210e8  mov      x3, x19
0x000210ec  bl       #0x245a8   ; call _dispatch_source_create
0x000210f0  adrp     x9, #0x3e000
0x000210f4  ldr      x8, [x9, #0xad8]
0x000210f8  str      x0, [x9, #0xad8]
0x000210fc  mov      x0, x8
0x00021100  bl       #0x2480c   ; call _objc_release
0x00021104  adrp     x21, #0x3e000
0x00021108  ldr      x20, [x21, #0xad8]
0x0002110c  mov      x0, #0
0x00021110  mov      w1, #0xb280
0x00021114  movk     w1, #0xee6, lsl #16
0x00021118  bl       #0x245cc   ; call _dispatch_time
0x0002111c  mov      x1, x0
0x00021120  mov      x0, x20
0x00021124  mov      w2, #0xb280
0x00021128  movk     w2, #0xee6, lsl #16
0x0002112c  mov      w3, #0xf080
0x00021130  movk     w3, #0x2fa, lsl #16
0x00021134  bl       #0x245c0   ; call _dispatch_source_set_timer
0x00021138  ldr      x0, [x21, #0xad8]
0x0002113c  adrp     x1, #0x34000
0x00021140  add      x1, x1, #0xcd0
0x00021144  bl       #0x245b4   ; call _dispatch_source_set_event_handler
0x00021148  ldr      x0, [x21, #0xad8]
0x0002114c  bl       #0x24590   ; call _dispatch_resume
0x00021150  adrp     x0, #0x2a000
0x00021154  add      x0, x0, #0xcb0   ; -> "com.anlai.omnicar/car.connected"
0x00021158  bl       #0x246ec   ; call _notify_post
0x0002115c  adrp     x8, #0x3e000
0x00021160  ldr      x22, [x8, #0x290]   ; -> [class(NSString)]
0x00021164  adrp     x8, #0x3e000
0x00021168  ldr      x0, [x8, #0xae8]
0x0002116c  bl       #0x25420   ; objc_msgSend: count
0x00021170  mov      x23, x0
0x00021174  adrp     x8, #0x3e000
0x00021178  ldr      x0, [x8, #0xae8]
0x0002117c  adrp     x2, #0x36000
0x00021180  add      x2, x2, #0x930   ; -> @", "
0x00021184  bl       #0x252a0   ; objc_msgSend: componentsJoinedByString:
0x00021188  mov      x29, x29
0x0002118c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021190  mov      x20, x0
0x00021194  stp      x23, x0, [sp]
0x00021198  mov      x0, x22
0x0002119c  adrp     x2, #0x38000
0x000211a0  add      x2, x2, #0x2b0   ; -> @"do hieu nang: bat dau, %lu tweak khac trong CarPlay: %@"
0x000211a4  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x000211a8  mov      x29, x29
0x000211ac  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000211b0  mov      x21, x0
0x000211b4  adrp     x0, #0x37000
0x000211b8  add      x0, x0, #0xd50   ; -> @"Core"
0x000211bc  mov      x1, x21
0x000211c0  bl       #0x1dd30   ; call _OMCLogWrite
0x000211c4  mov      x0, x21
0x000211c8  bl       #0x2480c   ; call _objc_release
0x000211cc  mov      x0, x20
0x000211d0  bl       #0x2480c   ; call _objc_release
0x000211d4  mov      x0, x19
0x000211d8  bl       #0x2480c   ; call _objc_release
0x000211dc  ldr      x19, [sp, #0x70]
0x000211e0  mov      x0, x19
0x000211e4  bl       #0x2480c   ; call _objc_release
0x000211e8  adrp     x8, #0x3e000
0x000211ec  ldr      x0, [x8, #0x398]   ; -> [class(NSMutableDictionary)]
0x000211f0  bl       #0x25580   ; objc_msgSend: dictionary
0x000211f4  mov      x29, x29
0x000211f8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000211fc  str      x0, [sp, #0x78]
0x00021200  adrp     x8, #0x3e000
0x00021204  ldr      x0, [x8, #0x418]   ; -> [class(NSDate)]
0x00021208  bl       #0x25480   ; objc_msgSend: date
0x0002120c  mov      x29, x29
0x00021210  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021214  mov      x19, x0
0x00021218  ldr      x0, [sp, #0x78]
0x0002121c  mov      x2, x19
0x00021220  adrp     x3, #0x37000
0x00021224  add      x3, x3, #0xf50   ; -> @"date"
0x00021228  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x0002122c  mov      x0, x19
0x00021230  bl       #0x2480c   ; call _objc_release
0x00021234  ldr      x0, [sp, #0x78]
0x00021238  adrp     x2, #0x34000
0x0002123c  ldr      x2, [x2, #0x208]   ; -> [got:___kCFBooleanTrue]
0x00021240  adrp     x3, #0x38000
