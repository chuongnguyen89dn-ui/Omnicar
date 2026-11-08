; === sub_46f0 @ 0x46f0 size=412 ===
0x000046f0  sub      sp, sp, #0x40
0x000046f4  stp      x22, x21, [sp, #0x10]
0x000046f8  stp      x20, x19, [sp, #0x20]
0x000046fc  stp      x29, x30, [sp, #0x30]
0x00004700  add      x29, sp, #0x30
0x00004704  bl       #0xd428 ; call stub:_objc_autoreleasePoolPush
0x00004708  mov      x19, x0
0x0000470c  bl       #0x7088 ; call _OMCLogRelayStart
0x00004710  adrp     x8, #0x18000
0x00004714  ldr      x20, [x8, #0x3f0] ; -> [classref(NSString)]
0x00004718  adrp     x8, #0x18000
0x0000471c  ldr      x0, [x8, #0x400] ; -> [classref(NSBundle)]
0x00004720  bl       #0xdd40 ; call objc_stub[mainBundle]
0x00004724  mov      x29, x29
0x00004728  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000472c  mov      x21, x0
0x00004730  bl       #0xd800 ; call objc_stub[bundleIdentifier]
0x00004734  mov      x29, x29
0x00004738  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000473c  mov      x22, x0
0x00004740  bl       #0x659c ; call _OMCEnabled
0x00004744  stp      x22, x0, [sp]
0x00004748  adrp     x2, #0x14000
0x0000474c  add      x2, x2, #0x908 ; -> CFSTR("loaded into %@ enabled=%d")
0x00004750  mov      x0, x20
0x00004754  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00004758  mov      x29, x29
0x0000475c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00004760  mov      x20, x0
0x00004764  adrp     x0, #0x14000
0x00004768  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x0000476c  mov      x1, x20
0x00004770  bl       #0x6be4 ; call _OMCLogWrite
0x00004774  mov      x0, x20
0x00004778  bl       #0xd4b8 ; call stub:_objc_release
0x0000477c  mov      x0, x22
0x00004780  bl       #0xd4b8 ; call stub:_objc_release
0x00004784  mov      x0, x21
0x00004788  bl       #0xd4b8 ; call stub:_objc_release
0x0000478c  bl       #0x44a8 ; call _OMCTrustedTimeStart
0x00004790  adrp     x0, #0xe000
0x00004794  add      x0, x0, #0x754 ; -> "com.anlai.omnicar/rescue"
0x00004798  adrp     x1, #0x18000
0x0000479c  add      x1, x1, #0x534 ; -> __DATA,__bss+0x34
0x000047a0  adrp     x20, #0x14000
0x000047a4  ldr      x20, [x20, #0x1d0] ; -> [got(__dispatch_main_q)]
0x000047a8  adrp     x3, #0x14000
0x000047ac  add      x3, x3, #0x4c8 ; -> __DATA_CONST,__const+0xc0 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x000047b0  mov      x2, x20
0x000047b4  bl       #0xd3ec ; call stub:_notify_register_dispatch
0x000047b8  adrp     x0, #0xe000
0x000047bc  add      x0, x0, #0x776 ; -> "com.anlai.omnicar/car.connected"
0x000047c0  adrp     x1, #0x18000
0x000047c4  add      x1, x1, #0x538 ; -> __DATA,__bss+0x38
0x000047c8  adrp     x3, #0x14000
0x000047cc  add      x3, x3, #0x4e8 ; -> __DATA_CONST,__const+0xe0 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x000047d0  mov      x2, x20
0x000047d4  bl       #0xd3ec ; call stub:_notify_register_dispatch
0x000047d8  mov      x0, x20
0x000047dc  bl       #0xd4b8 ; call stub:_objc_release
0x000047e0  adrp     x0, #0xe000
0x000047e4  add      x0, x0, #0x796 ; -> "NSDistributedNotificationCenter"
0x000047e8  bl       #0xd464 ; call stub:_objc_getClass
0x000047ec  bl       #0xda20 ; call objc_stub[defaultCenter]
0x000047f0  mov      x29, x29
0x000047f4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000047f8  mov      x21, x0
0x000047fc  adrp     x8, #0x18000
0x00004800  ldr      x0, [x8, #0x408] ; -> [classref(NSOperationQueue)]
0x00004804  bl       #0xdd60 ; call objc_stub[mainQueue]
0x00004808  mov      x29, x29
0x0000480c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00004810  mov      x22, x0
0x00004814  adrp     x2, #0x14000
0x00004818  add      x2, x2, #0x928 ; -> CFSTR("com.anlai.omnicar/url")
0x0000481c  adrp     x5, #0x14000
0x00004820  add      x5, x5, #0x568 ; -> __DATA_CONST,__const+0x160 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x00004824  mov      x0, x21
0x00004828  mov      x3, #0
0x0000482c  mov      x4, x22
0x00004830  bl       #0xd6e0 ; call objc_stub[addObserverForName:object:queue:usingBlock:]
0x00004834  mov      x29, x29
0x00004838  bl       #0xd500 ; call stub:_objc_unsafeClaimAutoreleasedReturnValue
0x0000483c  mov      x0, x22
0x00004840  bl       #0xd4b8 ; call stub:_objc_release
0x00004844  mov      x0, x21
0x00004848  bl       #0xd4b8 ; call stub:_objc_release
0x0000484c  adrp     x0, #0xe000
0x00004850  add      x0, x0, #0x7e9 ; -> "com.anlai.omnicar/cleanram.now"
0x00004854  adrp     x1, #0x18000
0x00004858  add      x1, x1, #0x53c ; -> __DATA,__bss+0x3c
0x0000485c  adrp     x3, #0x14000
0x00004860  add      x3, x3, #0x588 ; -> __DATA_CONST,__const+0x180 [u64=0x8020000000000080 f64=-4.450147717014529e-308]
0x00004864  mov      x2, x20
0x00004868  bl       #0xd3ec ; call stub:_notify_register_dispatch
0x0000486c  mov      x0, x20
0x00004870  bl       #0xd4b8 ; call stub:_objc_release
0x00004874  mov      x0, x19
0x00004878  ldp      x29, x30, [sp, #0x30]
0x0000487c  ldp      x20, x19, [sp, #0x20]
0x00004880  ldp      x22, x21, [sp, #0x10]
0x00004884  add      sp, sp, #0x40
0x00004888  b        #0xd41c ; call stub:_objc_autoreleasePoolPop
