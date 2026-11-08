; ==== _OMCLogRelayStart @ 0x1e200..0x1ebb0 (2480 bytes) ====
0x0001e200  stp      x20, x19, [sp, #-0x20]!
0x0001e204  stp      x29, x30, [sp, #0x10]
0x0001e208  add      x29, sp, #0x10
0x0001e20c  adrp     x8, #0x3e000
0x0001e210  ldr      x8, [x8, #0xb18]
0x0001e214  cmn      x8, #1
0x0001e218  b.ne     #0x1e27c
0x0001e21c  adrp     x8, #0x3e000
0x0001e220  ldrb     w8, [x8, #0xb10]
0x0001e224  cmp      w8, #1
0x0001e228  b.ne     #0x1e270
0x0001e22c  bl       #0x1e1c4   ; call sub_1e1c4
0x0001e230  mov      x29, x29
0x0001e234  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e238  mov      x19, x0
0x0001e23c  adrp     x2, #0x37000
0x0001e240  add      x2, x2, #0xb10   ; -> @"com.anlai.omnicar/log"
0x0001e244  adrp     x5, #0x34000
0x0001e248  add      x5, x5, #0xbd0
0x0001e24c  mov      x3, #0
0x0001e250  mov      x4, #0
0x0001e254  bl       #0x24b60   ; objc_msgSend: addObserverForName:object:queue:usingBlock:
0x0001e258  mov      x29, x29
0x0001e25c  bl       #0x24890   ; call _objc_unsafeClaimAutoreleasedReturnValue
0x0001e260  mov      x0, x19
0x0001e264  ldp      x29, x30, [sp, #0x10]
0x0001e268  ldp      x20, x19, [sp], #0x20
0x0001e26c  b        #0x2480c   ; call _objc_release
0x0001e270  ldp      x29, x30, [sp, #0x10]
0x0001e274  ldp      x20, x19, [sp], #0x20
0x0001e278  ret      
0x0001e27c  bl       #0x24248   ; call sub_24248
0x0001e280  b        #0x1e21c   ; call sub_1e21c
0x0001e284  sub      sp, sp, #0x50
0x0001e288  stp      x20, x19, [sp, #0x30]
0x0001e28c  stp      x29, x30, [sp, #0x40]
0x0001e290  add      x29, sp, #0x40
0x0001e294  mov      x0, x1
0x0001e298  bl       #0x280c0   ; objc_msgSend: userInfo
0x0001e29c  mov      x29, x29
0x0001e2a0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e2a4  mov      x20, x0
0x0001e2a8  adrp     x2, #0x37000
0x0001e2ac  add      x2, x2, #0xb30   ; -> @"line"
0x0001e2b0  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0001e2b4  mov      x29, x29
0x0001e2b8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e2bc  mov      x19, x0
0x0001e2c0  mov      x0, x20
0x0001e2c4  bl       #0x2480c   ; call _objc_release
0x0001e2c8  adrp     x8, #0x3e000
0x0001e2cc  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x0001e2d0  bl       #0x247d0   ; call _objc_opt_class
0x0001e2d4  mov      x1, x0
0x0001e2d8  mov      x0, x19
0x0001e2dc  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0001e2e0  tbz      w0, #0, #0x1e348
0x0001e2e4  bl       #0x1df38   ; call sub_1df38
0x0001e2e8  mov      x29, x29
0x0001e2ec  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e2f0  mov      x20, x0
0x0001e2f4  adrp     x8, #0x34000
0x0001e2f8  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x0001e2fc  str      x8, [sp, #8]
0x0001e300  adrp     x8, #0x2b000
0x0001e304  ldr      d0, [x8, #0x1d0]
0x0001e308  str      d0, [sp, #0x10]
0x0001e30c  adrp     x8, #0x1e000
0x0001e310  add      x8, x8, #0x360
0x0001e314  adrp     x9, #0x34000
0x0001e318  add      x9, x9, #0xba0
0x0001e31c  stp      x8, x9, [sp, #0x18]
0x0001e320  mov      x0, x19
0x0001e324  bl       #0x24818   ; call _objc_retain
0x0001e328  str      x19, [sp, #0x28]
0x0001e32c  add      x1, sp, #8
0x0001e330  mov      x0, x20
0x0001e334  bl       #0x24554   ; call _dispatch_async
0x0001e338  mov      x0, x20
0x0001e33c  bl       #0x2480c   ; call _objc_release
0x0001e340  ldr      x0, [sp, #0x28]
0x0001e344  bl       #0x2480c   ; call _objc_release
0x0001e348  mov      x0, x19
0x0001e34c  bl       #0x2480c   ; call _objc_release
0x0001e350  ldp      x29, x30, [sp, #0x40]
0x0001e354  ldp      x20, x19, [sp, #0x30]
0x0001e358  add      sp, sp, #0x50
0x0001e35c  ret      
0x0001e360  stp      x20, x19, [sp, #-0x20]!
0x0001e364  stp      x29, x30, [sp, #0x10]
0x0001e368  add      x29, sp, #0x10
0x0001e36c  mov      x19, x0
0x0001e370  bl       #0x1e094   ; call sub_1e094
0x0001e374  ldr      x0, [x19, #0x20]
0x0001e378  ldp      x29, x30, [sp, #0x10]
0x0001e37c  ldp      x20, x19, [sp], #0x20
0x0001e380  b        #0x1e154   ; call sub_1e154
0x0001e384  stp      x22, x21, [sp, #-0x30]!
0x0001e388  stp      x20, x19, [sp, #0x10]
0x0001e38c  stp      x29, x30, [sp, #0x20]
0x0001e390  add      x29, sp, #0x20
0x0001e394  mov      x19, x1
0x0001e398  mov      x20, x0
0x0001e39c  mov      x0, x1
0x0001e3a0  bl       #0x24818   ; call _objc_retain
0x0001e3a4  mov      x0, x20
0x0001e3a8  bl       #0x1e438   ; call _OMCCarClass
0x0001e3ac  mov      x20, x0
0x0001e3b0  cbz      x0, #0x1e41c
0x0001e3b4  adrp     x2, #0x37000
0x0001e3b8  add      x2, x2, #0x6b0   ; -> @"+"
0x0001e3bc  mov      x0, x19
0x0001e3c0  bl       #0x258a0   ; objc_msgSend: hasPrefix:
0x0001e3c4  cbz      w0, #0x1e400
0x0001e3c8  mov      x0, x19
0x0001e3cc  mov      w2, #1
0x0001e3d0  bl       #0x27da0   ; objc_msgSend: substringFromIndex:
0x0001e3d4  mov      x29, x29
0x0001e3d8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e3dc  mov      x21, x0
0x0001e3e0  bl       #0x2441c   ; call _NSSelectorFromString
0x0001e3e4  mov      x22, x0
0x0001e3e8  mov      x0, x21
0x0001e3ec  bl       #0x2480c   ; call _objc_release
0x0001e3f0  mov      x0, x20
0x0001e3f4  mov      x1, x22
0x0001e3f8  bl       #0x24518   ; call _class_getClassMethod
0x0001e3fc  b        #0x1e414   ; call sub_1e414
0x0001e400  mov      x0, x19
0x0001e404  bl       #0x2441c   ; call _NSSelectorFromString
0x0001e408  mov      x1, x0
0x0001e40c  mov      x0, x20
0x0001e410  bl       #0x24524   ; call _class_getInstanceMethod
0x0001e414  cmp      x0, #0
0x0001e418  cset     w20, ne
0x0001e41c  mov      x0, x19
0x0001e420  bl       #0x2480c   ; call _objc_release
0x0001e424  mov      x0, x20
0x0001e428  ldp      x29, x30, [sp, #0x20]
0x0001e42c  ldp      x20, x19, [sp, #0x10]
0x0001e430  ldp      x22, x21, [sp], #0x30
0x0001e434  ret      
0x0001e438  stp      x22, x21, [sp, #-0x30]!
0x0001e43c  stp      x20, x19, [sp, #0x10]
0x0001e440  stp      x29, x30, [sp, #0x20]
0x0001e444  add      x29, sp, #0x20
0x0001e448  mov      x19, x0
0x0001e44c  bl       #0x24788   ; call _objc_getClass
0x0001e450  cbz      x0, #0x1e460
0x0001e454  mov      x21, x0
0x0001e458  bl       #0x24818   ; call _objc_retain
0x0001e45c  b        #0x1e56c   ; call sub_1e56c
0x0001e460  adrp     x8, #0x3e000
0x0001e464  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x0001e468  mov      x2, x19
0x0001e46c  bl       #0x27d40   ; objc_msgSend: stringWithUTF8String:
0x0001e470  mov      x29, x29
0x0001e474  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e478  mov      x19, x0
0x0001e47c  adrp     x2, #0x37000
0x0001e480  add      x2, x2, #0xc90   ; -> @"DashBoard"
0x0001e484  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001e488  cbz      w0, #0x1e4a8
0x0001e48c  adrp     x0, #0x2a000
0x0001e490  add      x0, x0, #0x845   ; -> "CARApplication"
0x0001e494  bl       #0x24788   ; call _objc_getClass
0x0001e498  mov      x29, x29
0x0001e49c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e4a0  mov      x21, x0
0x0001e4a4  b        #0x1e564   ; call sub_1e564
0x0001e4a8  adrp     x2, #0x37000
0x0001e4ac  add      x2, x2, #0xcb0   ; -> @"DB"
0x0001e4b0  mov      x0, x19
0x0001e4b4  bl       #0x258a0   ; objc_msgSend: hasPrefix:
0x0001e4b8  cbz      w0, #0x1e51c
0x0001e4bc  mov      x0, x19
0x0001e4c0  mov      w2, #2
0x0001e4c4  bl       #0x27da0   ; objc_msgSend: substringFromIndex:
0x0001e4c8  mov      x29, x29
0x0001e4cc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e4d0  cbz      x0, #0x1e51c
0x0001e4d4  mov      x20, x0
0x0001e4d8  adrp     x0, #0x37000
0x0001e4dc  add      x0, x0, #0xcd0   ; -> @"CAR"
0x0001e4e0  mov      x2, x20
0x0001e4e4  bl       #0x27c80   ; objc_msgSend: stringByAppendingString:
0x0001e4e8  mov      x29, x29
0x0001e4ec  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e4f0  mov      x22, x0
0x0001e4f4  bl       #0x24824   ; call _objc_retainAutorelease
0x0001e4f8  bl       #0x24a40   ; objc_msgSend: UTF8String
0x0001e4fc  bl       #0x24788   ; call _objc_getClass
0x0001e500  mov      x21, x0
0x0001e504  mov      x0, x22
0x0001e508  bl       #0x2480c   ; call _objc_release
0x0001e50c  cbz      x21, #0x1e524
0x0001e510  mov      x0, x21
0x0001e514  bl       #0x24818   ; call _objc_retain
0x0001e518  b        #0x1e55c   ; call sub_1e55c
0x0001e51c  mov      x21, #0
0x0001e520  b        #0x1e564   ; call sub_1e564
0x0001e524  adrp     x0, #0x37000
0x0001e528  add      x0, x0, #0xcf0   ; -> @"_CAR"
0x0001e52c  mov      x2, x20
0x0001e530  bl       #0x27c80   ; objc_msgSend: stringByAppendingString:
0x0001e534  mov      x29, x29
0x0001e538  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e53c  mov      x22, x0
0x0001e540  bl       #0x24824   ; call _objc_retainAutorelease
0x0001e544  bl       #0x24a40   ; objc_msgSend: UTF8String
0x0001e548  bl       #0x24788   ; call _objc_getClass
0x0001e54c  mov      x21, x0
0x0001e550  bl       #0x24818   ; call _objc_retain
0x0001e554  mov      x0, x22
0x0001e558  bl       #0x2480c   ; call _objc_release
0x0001e55c  mov      x0, x20
0x0001e560  bl       #0x2480c   ; call _objc_release
0x0001e564  mov      x0, x19
0x0001e568  bl       #0x2480c   ; call _objc_release
0x0001e56c  mov      x0, x21
0x0001e570  ldp      x29, x30, [sp, #0x20]
0x0001e574  ldp      x20, x19, [sp, #0x10]
0x0001e578  ldp      x22, x21, [sp], #0x30
0x0001e57c  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x0001e580  sub      sp, sp, #0x190
0x0001e584  stp      x28, x27, [sp, #0x130]
0x0001e588  stp      x26, x25, [sp, #0x140]
0x0001e58c  stp      x24, x23, [sp, #0x150]
0x0001e590  stp      x22, x21, [sp, #0x160]
0x0001e594  stp      x20, x19, [sp, #0x170]
0x0001e598  stp      x29, x30, [sp, #0x180]
0x0001e59c  add      x29, sp, #0x180
0x0001e5a0  mov      x26, x1
0x0001e5a4  adrp     x8, #0x34000
0x0001e5a8  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0001e5ac  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0001e5b0  stur     x8, [x29, #-0x60]
0x0001e5b4  str      x0, [sp, #0x20]
0x0001e5b8  bl       #0x24818   ; call _objc_retain
0x0001e5bc  mov      x0, x26
0x0001e5c0  bl       #0x24818   ; call _objc_retain
0x0001e5c4  adrp     x8, #0x3e000
0x0001e5c8  ldr      x0, [x8, #0x318]   ; -> [class(NSMutableArray)]
0x0001e5cc  bl       #0x24dc0   ; objc_msgSend: array
0x0001e5d0  mov      x29, x29
0x0001e5d4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e5d8  str      x0, [sp, #0x30]
0x0001e5dc  adrp     x8, #0x3e000
0x0001e5e0  ldr      x0, [x8, #0x420]   ; -> [class(NSMutableOrderedSet)]
0x0001e5e4  bl       #0x26480   ; objc_msgSend: orderedSet
0x0001e5e8  mov      x29, x29
0x0001e5ec  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e5f0  str      x0, [sp, #0x28]
0x0001e5f4  movi     v0.16b, #0
0x0001e5f8  stp      q0, q0, [sp, #0x40]
0x0001e5fc  stp      q0, q0, [sp, #0x60]
0x0001e600  mov      x0, x26
0x0001e604  bl       #0x24818   ; call _objc_retain
0x0001e608  add      x2, sp, #0x40
0x0001e60c  add      x3, sp, #0xa0
0x0001e610  mov      x0, x26
0x0001e614  mov      w4, #0x10
0x0001e618  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001e61c  str      x26, [sp, #0x38]
0x0001e620  cbz      x0, #0x1e848
0x0001e624  mov      x24, x0
0x0001e628  ldr      x8, [sp, #0x50]
0x0001e62c  ldr      x20, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x0001e630  adrp     x23, #0x36000
0x0001e634  add      x23, x23, #0xfd0   ; -> @" "
0x0001e638  mov      x25, #0
0x0001e63c  ldr      x8, [sp, #0x50]
0x0001e640  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x0001e644  cmp      x8, x20
0x0001e648  b.eq     #0x1e654
0x0001e64c  mov      x0, x26
0x0001e650  bl       #0x24770   ; call _objc_enumerationMutation
0x0001e654  ldr      x8, [sp, #0x48]
0x0001e658  ldr      x28, [x8, x25, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x0001e65c  mov      x0, x28
0x0001e660  mov      x2, x23
0x0001e664  bl       #0x252e0   ; objc_msgSend: componentsSeparatedByString:
0x0001e668  mov      x29, x29
0x0001e66c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e670  mov      x27, x0
0x0001e674  bl       #0x25420   ; objc_msgSend: count
0x0001e678  cmp      x0, #2
0x0001e67c  b.ne     #0x1e818
0x0001e680  mov      x0, x27
0x0001e684  mov      x2, #0
0x0001e688  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x0001e68c  mov      x29, x29
0x0001e690  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e694  mov      x22, x0
0x0001e698  bl       #0x24824   ; call _objc_retainAutorelease
0x0001e69c  bl       #0x24a40   ; objc_msgSend: UTF8String
0x0001e6a0  bl       #0x1e438   ; call _OMCCarClass
0x0001e6a4  mov      x19, x0
0x0001e6a8  mov      x0, x22
0x0001e6ac  bl       #0x2480c   ; call _objc_release
0x0001e6b0  cbz      x19, #0x1e780
0x0001e6b4  mov      x0, x19
0x0001e6b8  bl       #0x2444c   ; call _NSStringFromClass
0x0001e6bc  mov      x29, x29
0x0001e6c0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e6c4  mov      x22, x0
0x0001e6c8  mov      x0, x27
0x0001e6cc  mov      x2, #0
0x0001e6d0  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x0001e6d4  mov      x29, x29
0x0001e6d8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e6dc  mov      x26, x0
0x0001e6e0  mov      x0, x22
0x0001e6e4  mov      x2, x26
0x0001e6e8  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001e6ec  mov      x21, x0
0x0001e6f0  mov      x0, x26
0x0001e6f4  ldr      x26, [sp, #0x38]
0x0001e6f8  bl       #0x2480c   ; call _objc_release
0x0001e6fc  mov      x0, x22
0x0001e700  bl       #0x2480c   ; call _objc_release
0x0001e704  tbnz     w21, #0, #0x1e780
0x0001e708  adrp     x8, #0x3e000
0x0001e70c  ldr      x21, [x8, #0x290]   ; -> [class(NSString)]
0x0001e710  mov      x0, x27
0x0001e714  mov      x2, #0
0x0001e718  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x0001e71c  mov      x29, x29
0x0001e720  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e724  mov      x22, x0
0x0001e728  mov      x0, x19
0x0001e72c  bl       #0x2444c   ; call _NSStringFromClass
0x0001e730  mov      x29, x29
0x0001e734  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e738  mov      x19, x0
0x0001e73c  stp      x22, x0, [sp]
0x0001e740  mov      x0, x21
0x0001e744  adrp     x2, #0x37000
0x0001e748  add      x2, x2, #0xb50   ; -> @"%@=%@"
0x0001e74c  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0001e750  mov      x29, x29
0x0001e754  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e758  mov      x21, x0
0x0001e75c  ldr      x0, [sp, #0x28]
0x0001e760  mov      x2, x21
0x0001e764  bl       #0x24b20   ; objc_msgSend: addObject:
0x0001e768  mov      x0, x21
0x0001e76c  bl       #0x2480c   ; call _objc_release
0x0001e770  mov      x0, x19
0x0001e774  bl       #0x2480c   ; call _objc_release
0x0001e778  mov      x0, x22
0x0001e77c  bl       #0x2480c   ; call _objc_release
0x0001e780  mov      x0, x27
0x0001e784  mov      w2, #1
0x0001e788  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x0001e78c  mov      x29, x29
0x0001e790  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e794  mov      x19, x0
0x0001e798  adrp     x2, #0x35000
0x0001e79c  add      x2, x2, #0x90   ; -> @"-"
0x0001e7a0  bl       #0x258a0   ; objc_msgSend: hasPrefix:
0x0001e7a4  cbz      w0, #0x1e7cc
0x0001e7a8  mov      x0, x19
0x0001e7ac  mov      w2, #1
0x0001e7b0  bl       #0x27da0   ; objc_msgSend: substringFromIndex:
0x0001e7b4  mov      x29, x29
0x0001e7b8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e7bc  mov      x21, x0
0x0001e7c0  mov      x0, x19
0x0001e7c4  bl       #0x2480c   ; call _objc_release
0x0001e7c8  mov      x19, x21
0x0001e7cc  mov      x0, x27
0x0001e7d0  mov      x2, #0
0x0001e7d4  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x0001e7d8  mov      x29, x29
0x0001e7dc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e7e0  mov      x21, x0
0x0001e7e4  bl       #0x24824   ; call _objc_retainAutorelease
0x0001e7e8  bl       #0x24a40   ; objc_msgSend: UTF8String
0x0001e7ec  mov      x1, x19
0x0001e7f0  bl       #0x1e384   ; call _OMCHasMethod
0x0001e7f4  mov      x22, x0
0x0001e7f8  mov      x0, x21
0x0001e7fc  bl       #0x2480c   ; call _objc_release
0x0001e800  tbnz     w22, #0, #0x1e810
0x0001e804  ldr      x0, [sp, #0x30]
0x0001e808  mov      x2, x28
0x0001e80c  bl       #0x24b20   ; objc_msgSend: addObject:
0x0001e810  mov      x0, x19
0x0001e814  bl       #0x2480c   ; call _objc_release
0x0001e818  mov      x0, x27
0x0001e81c  bl       #0x2480c   ; call _objc_release
0x0001e820  add      x25, x25, #1
0x0001e824  cmp      x24, x25
0x0001e828  b.ne     #0x1e63c
0x0001e82c  add      x2, sp, #0x40
0x0001e830  add      x3, sp, #0xa0
0x0001e834  mov      x0, x26
0x0001e838  mov      w4, #0x10
0x0001e83c  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001e840  mov      x24, x0
0x0001e844  cbnz     x0, #0x1e638
0x0001e848  mov      x0, x26
0x0001e84c  bl       #0x2480c   ; call _objc_release
0x0001e850  adrp     x8, #0x3e000
0x0001e854  ldr      x0, [x8, #0x2b8]   ; -> [class(UIDevice)]
0x0001e858  bl       #0x25460   ; objc_msgSend: currentDevice
0x0001e85c  mov      x29, x29
0x0001e860  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e864  mov      x19, x0
0x0001e868  bl       #0x27ec0   ; objc_msgSend: systemVersion
0x0001e86c  mov      x29, x29
0x0001e870  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e874  mov      x23, x0
0x0001e878  mov      x0, x19
0x0001e87c  bl       #0x2480c   ; call _objc_release
0x0001e880  adrp     x20, #0x3e000
0x0001e884  ldr      x8, [x20, #0xab0]
0x0001e888  cbnz     x8, #0x1e8b0
0x0001e88c  adrp     x8, #0x3e000
0x0001e890  ldr      x0, [x8, #0x398]   ; -> [class(NSMutableDictionary)]
0x0001e894  bl       #0x25580   ; objc_msgSend: dictionary
0x0001e898  mov      x29, x29
0x0001e89c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e8a0  ldr      x8, [x20, #0xab0]
0x0001e8a4  str      x0, [x20, #0xab0]
0x0001e8a8  mov      x0, x8
0x0001e8ac  bl       #0x2480c   ; call _objc_release
0x0001e8b0  adrp     x8, #0x3e000
0x0001e8b4  ldr      x19, [x8, #0x290]   ; -> [class(NSString)]
0x0001e8b8  adrp     x8, #0x3e000
0x0001e8bc  ldr      x0, [x8, #0x408]   ; -> [class(NSProcessInfo)]
0x0001e8c0  bl       #0x266c0   ; objc_msgSend: processInfo
0x0001e8c4  mov      x29, x29
0x0001e8c8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e8cc  mov      x21, x0
0x0001e8d0  bl       #0x266e0   ; objc_msgSend: processName
0x0001e8d4  mov      x29, x29
0x0001e8d8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e8dc  mov      x22, x0
0x0001e8e0  adrp     x8, #0x37000
0x0001e8e4  add      x8, x8, #0xb90   ; -> @"diagHooks."
0x0001e8e8  ldr      x27, [sp, #0x20]
0x0001e8ec  stp      x27, x0, [sp, #8]
0x0001e8f0  str      x8, [sp]
0x0001e8f4  adrp     x2, #0x37000
0x0001e8f8  add      x2, x2, #0xb70   ; -> @"%@%@@%@"
0x0001e8fc  mov      x0, x19
0x0001e900  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0001e904  mov      x29, x29
0x0001e908  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e90c  mov      x24, x0
0x0001e910  mov      x0, x22
0x0001e914  bl       #0x2480c   ; call _objc_release
0x0001e918  mov      x0, x21
0x0001e91c  bl       #0x2480c   ; call _objc_release
0x0001e920  ldr      x0, [x20, #0xab0]
0x0001e924  mov      x2, x24
0x0001e928  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0001e92c  mov      x29, x29
0x0001e930  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e934  mov      x26, x0
0x0001e938  ldr      x28, [sp, #0x30]
0x0001e93c  cbz      x0, #0x1e950
0x0001e940  mov      x0, x26
0x0001e944  bl       #0x24818   ; call _objc_retain
0x0001e948  mov      x25, x26
0x0001e94c  b        #0x1e9d8   ; call sub_1e9d8
0x0001e950  adrp     x8, #0x37000
0x0001e954  add      x8, x8, #0xbb0   ; -> @"total"
0x0001e958  adrp     x9, #0x37000
0x0001e95c  add      x9, x9, #0xbd0   ; -> @"missing"
0x0001e960  adrp     x10, #0x39000
0x0001e964  add      x10, x10, #0x618
0x0001e968  stp      x9, x10, [sp, #0x88]
0x0001e96c  str      x8, [sp, #0x80]
0x0001e970  adrp     x8, #0x3e000
0x0001e974  ldr      x0, [x8, #0x318]   ; -> [class(NSMutableArray)]
0x0001e978  bl       #0x24dc0   ; objc_msgSend: array
0x0001e97c  mov      x29, x29
0x0001e980  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e984  mov      x19, x0
0x0001e988  str      x0, [sp, #0x98]
0x0001e98c  adrp     x8, #0x3e000
0x0001e990  ldr      x0, [x8, #0x310]   ; -> [class(NSDictionary)]
0x0001e994  add      x2, sp, #0x90
0x0001e998  add      x3, sp, #0x80
0x0001e99c  mov      w4, #2
0x0001e9a0  bl       #0x255c0   ; objc_msgSend: dictionaryWithObjects:forKeys:count:
0x0001e9a4  mov      x29, x29
0x0001e9a8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e9ac  mov      x21, x0
0x0001e9b0  bl       #0x261e0   ; objc_msgSend: mutableCopy
0x0001e9b4  mov      x25, x0
0x0001e9b8  ldr      x0, [x20, #0xab0]
0x0001e9bc  mov      x2, x25
0x0001e9c0  mov      x3, x24
0x0001e9c4  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x0001e9c8  mov      x0, x21
0x0001e9cc  bl       #0x2480c   ; call _objc_release
0x0001e9d0  mov      x0, x19
0x0001e9d4  bl       #0x2480c   ; call _objc_release
0x0001e9d8  mov      x0, x26
0x0001e9dc  bl       #0x2480c   ; call _objc_release
0x0001e9e0  adrp     x3, #0x37000
0x0001e9e4  add      x3, x3, #0xbf0   ; -> @"ios"
0x0001e9e8  mov      x0, x25
0x0001e9ec  mov      x2, x23
0x0001e9f0  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x0001e9f4  adrp     x8, #0x3e000
0x0001e9f8  ldr      x19, [x8, #0x2a0]   ; -> [class(NSNumber)]
0x0001e9fc  adrp     x21, #0x37000
0x0001ea00  add      x21, x21, #0xbb0   ; -> @"total"
0x0001ea04  mov      x0, x25
0x0001ea08  mov      x2, x21
0x0001ea0c  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0001ea10  mov      x29, x29
0x0001ea14  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ea18  mov      x22, x0
0x0001ea1c  bl       #0x28040   ; objc_msgSend: unsignedIntegerValue
0x0001ea20  mov      x26, x0
0x0001ea24  ldr      x0, [sp, #0x38]
0x0001ea28  bl       #0x25420   ; objc_msgSend: count
0x0001ea2c  add      x2, x0, x26
0x0001ea30  mov      x0, x19
0x0001ea34  bl       #0x263a0   ; objc_msgSend: numberWithUnsignedInteger:
0x0001ea38  mov      x29, x29
0x0001ea3c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ea40  mov      x19, x0
0x0001ea44  mov      x0, x25
0x0001ea48  mov      x2, x19
0x0001ea4c  mov      x3, x21
0x0001ea50  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x0001ea54  mov      x0, x19
0x0001ea58  bl       #0x2480c   ; call _objc_release
0x0001ea5c  mov      x0, x22
0x0001ea60  bl       #0x2480c   ; call _objc_release
0x0001ea64  adrp     x2, #0x37000
0x0001ea68  add      x2, x2, #0xbd0   ; -> @"missing"
0x0001ea6c  mov      x0, x25
0x0001ea70  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0001ea74  mov      x29, x29
0x0001ea78  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ea7c  mov      x19, x0
0x0001ea80  mov      x2, x28
0x0001ea84  bl       #0x24b40   ; objc_msgSend: addObjectsFromArray:
0x0001ea88  mov      x0, x19
0x0001ea8c  bl       #0x2480c   ; call _objc_release
0x0001ea90  adrp     x19, #0x37000
0x0001ea94  add      x19, x19, #0x70   ; -> @"com.anlai.omnicar"
0x0001ea98  mov      x0, x24
0x0001ea9c  mov      x1, x25
0x0001eaa0  mov      x2, x19
0x0001eaa4  bl       #0x242cc   ; call _CFPreferencesSetAppValue
0x0001eaa8  mov      x0, x19
0x0001eaac  bl       #0x242b4   ; call _CFPreferencesAppSynchronize
0x0001eab0  ldr      x20, [sp, #0x28]
0x0001eab4  mov      x0, x20
0x0001eab8  bl       #0x25420   ; objc_msgSend: count
0x0001eabc  adrp     x26, #0x3e000
0x0001eac0  cbz      x0, #0x1eb38
0x0001eac4  ldr      x19, [x26, #0x290]   ; -> [class(NSString)]
0x0001eac8  mov      x0, x20
0x0001eacc  bl       #0x24dc0   ; objc_msgSend: array
0x0001ead0  mov      x29, x29
0x0001ead4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ead8  mov      x21, x0
0x0001eadc  adrp     x2, #0x36000
0x0001eae0  add      x2, x2, #0x930   ; -> @", "
0x0001eae4  bl       #0x252a0   ; objc_msgSend: componentsJoinedByString:
0x0001eae8  mov      x29, x29
0x0001eaec  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001eaf0  mov      x22, x0
0x0001eaf4  stp      x23, x0, [sp]
0x0001eaf8  adrp     x2, #0x37000
0x0001eafc  add      x2, x2, #0xc10   ; -> @"iOS %@: lop CarPlay %@"
0x0001eb00  mov      x0, x19
0x0001eb04  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0001eb08  mov      x29, x29
0x0001eb0c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001eb10  mov      x19, x0
0x0001eb14  mov      x0, x27
0x0001eb18  mov      x1, x19
0x0001eb1c  bl       #0x1dd30   ; call _OMCLogWrite
0x0001eb20  mov      x0, x19
0x0001eb24  bl       #0x2480c   ; call _objc_release
0x0001eb28  mov      x0, x22
0x0001eb2c  bl       #0x2480c   ; call _objc_release
0x0001eb30  mov      x0, x21
0x0001eb34  bl       #0x2480c   ; call _objc_release
0x0001eb38  mov      x0, x28
0x0001eb3c  bl       #0x25420   ; objc_msgSend: count
0x0001eb40  ldr      x19, [x26, #0x290]   ; -> [class(NSString)]
0x0001eb44  cbz      x0, #0x1ebbc
0x0001eb48  mov      x0, x28
0x0001eb4c  bl       #0x25420   ; objc_msgSend: count
0x0001eb50  mov      x21, x0
0x0001eb54  ldr      x20, [sp, #0x38]
0x0001eb58  mov      x0, x20
0x0001eb5c  bl       #0x25420   ; objc_msgSend: count
0x0001eb60  mov      x22, x0
0x0001eb64  adrp     x2, #0x36000
0x0001eb68  add      x2, x2, #0x930   ; -> @", "
0x0001eb6c  mov      x0, x28
0x0001eb70  bl       #0x252a0   ; objc_msgSend: componentsJoinedByString:
0x0001eb74  mov      x29, x29
0x0001eb78  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001eb7c  mov      x26, x0
0x0001eb80  stp      x22, x0, [sp, #0x10]
0x0001eb84  stp      x23, x21, [sp]
0x0001eb88  adrp     x2, #0x37000
0x0001eb8c  add      x2, x2, #0xc30   ; -> @"iOS %@: %lu/%lu hook KHONG co tren iOS nay (tinh nang lien quan se khong chay): %@"
0x0001eb90  mov      x0, x19
0x0001eb94  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0001eb98  mov      x29, x29
0x0001eb9c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001eba0  mov      x19, x0
0x0001eba4  mov      x0, x27
0x0001eba8  mov      x1, x19
0x0001ebac  bl       #0x1dd30   ; call _OMCLogWrite
