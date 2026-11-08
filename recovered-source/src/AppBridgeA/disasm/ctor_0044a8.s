; ==== __mod_init_0 @ 0x44a8..0x6028 (7040 bytes) ====
0x000044a8  sub      sp, sp, #0xb0
0x000044ac  stp      d9, d8, [sp, #0x50]
0x000044b0  stp      x26, x25, [sp, #0x60]
0x000044b4  stp      x24, x23, [sp, #0x70]
0x000044b8  stp      x22, x21, [sp, #0x80]
0x000044bc  stp      x20, x19, [sp, #0x90]
0x000044c0  stp      x29, x30, [sp, #0xa0]
0x000044c4  add      x29, sp, #0xa0
0x000044c8  adrp     x8, #0x3e000
0x000044cc  ldr      x0, [x8, #0x280]   ; -> [class(NSBundle)]
0x000044d0  bl       #0x26080   ; objc_msgSend: mainBundle
0x000044d4  mov      x29, x29
0x000044d8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000044dc  mov      x19, x0
0x000044e0  bl       #0x25040   ; objc_msgSend: bundleIdentifier
0x000044e4  mov      x29, x29
0x000044e8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000044ec  mov      x20, x0
0x000044f0  bl       #0x25fa0   ; objc_msgSend: length
0x000044f4  cbz      x0, #0x4670
0x000044f8  mov      x0, x19
0x000044fc  bl       #0x25060   ; objc_msgSend: bundlePath
0x00004500  mov      x29, x29
0x00004504  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00004508  mov      x22, x0
0x0000450c  adrp     x2, #0x34000
0x00004510  add      x2, x2, #0xdd0   ; -> @".app"
0x00004514  bl       #0x25380   ; objc_msgSend: containsString:
0x00004518  mov      x21, x0
0x0000451c  mov      x0, x22
0x00004520  bl       #0x2480c   ; call _objc_release
0x00004524  tbz      w21, #0, #0x4670
0x00004528  adrp     x0, #0x39000
0x0000452c  add      x0, x0, #0x3d8
0x00004530  mov      x2, x20
0x00004534  bl       #0x25360   ; objc_msgSend: containsObject:
0x00004538  tbnz     w0, #0, #0x4670
0x0000453c  adrp     x0, #0x28000
0x00004540  add      x0, x0, #0xfc3   ; -> "NSDistributedNotificationCenter"
0x00004544  bl       #0x24788   ; call _objc_getClass
0x00004548  bl       #0x254c0   ; objc_msgSend: defaultCenter
0x0000454c  mov      x29, x29
0x00004550  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00004554  mov      x22, x0
0x00004558  adrp     x23, #0x3e000
0x0000455c  ldr      x0, [x23, #0x288]   ; -> [class(NSOperationQueue)]
0x00004560  bl       #0x260a0   ; objc_msgSend: mainQueue
0x00004564  mov      x29, x29
0x00004568  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000456c  mov      x21, x0
0x00004570  adrp     x24, #0x34000
0x00004574  ldr      x24, [x24, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x00004578  str      x24, [sp, #0x28]
0x0000457c  adrp     x8, #0x2b000
0x00004580  ldr      d8, [x8, #0x1d0]
0x00004584  str      d8, [sp, #0x30]
0x00004588  adrp     x8, #0x4000
0x0000458c  add      x8, x8, #0x728
0x00004590  adrp     x25, #0x34000
0x00004594  add      x25, x25, #0x5e0
0x00004598  stp      x8, x25, [sp, #0x38]
0x0000459c  mov      x0, x20
0x000045a0  bl       #0x24818   ; call _objc_retain
0x000045a4  str      x20, [sp, #0x48]
0x000045a8  adrp     x2, #0x34000
0x000045ac  add      x2, x2, #0xeb0   ; -> @"com.anlai.omnicar/appbridge.orientation"
0x000045b0  add      x5, sp, #0x28
0x000045b4  mov      x0, x22
0x000045b8  mov      x3, x20
0x000045bc  mov      x4, x21
0x000045c0  bl       #0x24b60   ; objc_msgSend: addObserverForName:object:queue:usingBlock:
0x000045c4  mov      x29, x29
0x000045c8  bl       #0x24890   ; call _objc_unsafeClaimAutoreleasedReturnValue
0x000045cc  mov      x0, x21
0x000045d0  bl       #0x2480c   ; call _objc_release
0x000045d4  mov      x0, x22
0x000045d8  bl       #0x2480c   ; call _objc_release
0x000045dc  adrp     x0, #0x28000
0x000045e0  add      x0, x0, #0xfc3   ; -> "NSDistributedNotificationCenter"
0x000045e4  bl       #0x24788   ; call _objc_getClass
0x000045e8  bl       #0x254c0   ; objc_msgSend: defaultCenter
0x000045ec  mov      x29, x29
0x000045f0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000045f4  mov      x22, x0
0x000045f8  ldr      x0, [x23, #0x288]   ; -> [class(NSOperationQueue)]
0x000045fc  bl       #0x260a0   ; objc_msgSend: mainQueue
0x00004600  mov      x29, x29
0x00004604  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00004608  mov      x23, x0
0x0000460c  str      x24, [sp]
0x00004610  str      d8, [sp, #8]
0x00004614  adrp     x8, #0x5000
0x00004618  add      x8, x8, #0x908
0x0000461c  stp      x8, x25, [sp, #0x10]
0x00004620  mov      x0, x20
0x00004624  bl       #0x24818   ; call _objc_retain
0x00004628  str      x20, [sp, #0x20]
0x0000462c  adrp     x2, #0x34000
0x00004630  add      x2, x2, #0xf90   ; -> @"com.anlai.omnicar/appbridge.key"
0x00004634  mov      x5, sp
0x00004638  mov      x0, x22
0x0000463c  mov      x3, x20
0x00004640  mov      x4, x23
0x00004644  bl       #0x24b60   ; objc_msgSend: addObserverForName:object:queue:usingBlock:
0x00004648  mov      x29, x29
0x0000464c  bl       #0x24890   ; call _objc_unsafeClaimAutoreleasedReturnValue
0x00004650  mov      x0, x23
0x00004654  bl       #0x2480c   ; call _objc_release
0x00004658  mov      x0, x22
0x0000465c  bl       #0x2480c   ; call _objc_release
0x00004660  ldr      x0, [sp, #0x20]
0x00004664  bl       #0x2480c   ; call _objc_release
0x00004668  ldr      x0, [sp, #0x48]
0x0000466c  bl       #0x2480c   ; call _objc_release
0x00004670  mov      x0, x20
0x00004674  bl       #0x2480c   ; call _objc_release
0x00004678  mov      x0, x19
0x0000467c  bl       #0x2480c   ; call _objc_release
0x00004680  ldp      x29, x30, [sp, #0xa0]
0x00004684  ldp      x20, x19, [sp, #0x90]
0x00004688  ldp      x22, x21, [sp, #0x80]
0x0000468c  ldp      x24, x23, [sp, #0x70]
0x00004690  ldp      x26, x25, [sp, #0x60]
0x00004694  ldp      d9, d8, [sp, #0x50]
0x00004698  add      sp, sp, #0xb0
0x0000469c  ret      
0x000046a0  mov      x21, x0
0x000046a4  ldr      x0, [sp, #0x20]
0x000046a8  bl       #0x2480c   ; call _objc_release
0x000046ac  mov      x0, x23
0x000046b0  bl       #0x2480c   ; call _objc_release
0x000046b4  b        #0x46bc   ; call sub_46bc
0x000046b8  mov      x21, x0
0x000046bc  mov      x0, x22
0x000046c0  bl       #0x2480c   ; call _objc_release
0x000046c4  b        #0x46ec   ; call sub_46ec
0x000046c8  mov      x23, x21
0x000046cc  mov      x21, x0
0x000046d0  ldr      x0, [sp, #0x48]
0x000046d4  bl       #0x2480c   ; call _objc_release
0x000046d8  mov      x0, x23
0x000046dc  bl       #0x2480c   ; call _objc_release
0x000046e0  b        #0x46f8   ; call sub_46f8
0x000046e4  b        #0x46f4   ; call sub_46f4
0x000046e8  mov      x21, x0
0x000046ec  ldr      x0, [sp, #0x48]
0x000046f0  b        #0x46fc   ; call sub_46fc
0x000046f4  mov      x21, x0
0x000046f8  mov      x0, x22
0x000046fc  bl       #0x2480c   ; call _objc_release
0x00004700  b        #0x4710   ; call sub_4710
0x00004704  mov      x21, x0
0x00004708  b        #0x4718   ; call sub_4718
0x0000470c  mov      x21, x0
0x00004710  mov      x0, x20
0x00004714  bl       #0x2480c   ; call _objc_release
0x00004718  mov      x0, x19
0x0000471c  bl       #0x2480c   ; call _objc_release
0x00004720  mov      x0, x21
0x00004724  bl       #0x24470   ; call __Unwind_Resume
0x00004728  stp      x28, x27, [sp, #-0x60]!
0x0000472c  stp      x26, x25, [sp, #0x10]
0x00004730  stp      x24, x23, [sp, #0x20]
0x00004734  stp      x22, x21, [sp, #0x30]
0x00004738  stp      x20, x19, [sp, #0x40]
0x0000473c  stp      x29, x30, [sp, #0x50]
0x00004740  add      x29, sp, #0x50
0x00004744  sub      sp, sp, #0x1b0
0x00004748  mov      x20, x0
0x0000474c  adrp     x8, #0x34000
0x00004750  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00004754  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00004758  stur     x8, [x29, #-0x60]
0x0000475c  str      x1, [sp, #0x18]
0x00004760  mov      x0, x1
0x00004764  bl       #0x24818   ; call _objc_retain
0x00004768  adrp     x8, #0x3e000
0x0000476c  ldrb     w9, [x8, #0x938]
0x00004770  adrp     x19, #0x3e000
0x00004774  tbnz     w9, #0, #0x49f0
0x00004778  mov      w9, #1
0x0000477c  strb     w9, [x8, #0x938]
0x00004780  adrp     x0, #0x29000
0x00004784  add      x0, x0, #0xb   ; -> "CADisplayLink"
0x00004788  bl       #0x24788   ; call _objc_getClass
0x0000478c  mov      x21, x0
0x00004790  bl       #0x2489c   ; call _object_getClass
0x00004794  adrp     x8, #0x3d000
0x00004798  ldr      x1, [x8, #0x5c0]   ; -> [@selector(displayLinkWithTarget:selector:)]
0x0000479c  adrp     x2, #0x5000
0x000047a0  add      x2, x2, #0xa8
0x000047a4  adrp     x3, #0x3e000
0x000047a8  add      x3, x3, #0x940
0x000047ac  bl       #0x243ec   ; call _MSHookMessageEx
0x000047b0  adrp     x8, #0x3d000
0x000047b4  ldr      x1, [x8, #0xd98]   ; -> [@selector(setPreferredFramesPerSecond:)]
0x000047b8  adrp     x2, #0x5000
0x000047bc  add      x2, x2, #0x144
0x000047c0  adrp     x3, #0x3e000
0x000047c4  add      x3, x3, #0x948
0x000047c8  mov      x0, x21
0x000047cc  bl       #0x243ec   ; call _MSHookMessageEx
0x000047d0  adrp     x8, #0x3d000
0x000047d4  ldr      x1, [x8, #0xd90]   ; -> [@selector(setPreferredFrameRateRange:)]
0x000047d8  adrp     x2, #0x5000
0x000047dc  add      x2, x2, #0x220
0x000047e0  adrp     x3, #0x3e000
0x000047e4  add      x3, x3, #0x950
0x000047e8  mov      x0, x21
0x000047ec  bl       #0x243ec   ; call _MSHookMessageEx
0x000047f0  adrp     x0, #0x29000
0x000047f4  add      x0, x0, #0x19   ; -> "UIWindow"
0x000047f8  bl       #0x24788   ; call _objc_getClass
0x000047fc  adrp     x8, #0x3d000
0x00004800  ldr      x1, [x8, #0x1f0]   ; -> [@selector(_setRotatableViewOrientation:duration:force:)]
0x00004804  adrp     x2, #0x5000
0x00004808  add      x2, x2, #0x43c
0x0000480c  adrp     x3, #0x3e000
0x00004810  add      x3, x3, #0x958
0x00004814  bl       #0x243ec   ; call _MSHookMessageEx
0x00004818  adrp     x0, #0x29000
0x0000481c  add      x0, x0, #0x22   ; -> "UIDevice"
0x00004820  bl       #0x24788   ; call _objc_getClass
0x00004824  mov      x21, x0
0x00004828  adrp     x8, #0x3d000
0x0000482c  ldr      x1, [x8, #0x1f8]   ; -> [@selector(beginGeneratingDeviceOrientationNotifications)]
0x00004830  adrp     x2, #0x5000
0x00004834  add      x2, x2, #0x4c8
0x00004838  adrp     x3, #0x3e000
0x0000483c  add      x3, x3, #0x960
0x00004840  bl       #0x243ec   ; call _MSHookMessageEx
0x00004844  adrp     x8, #0x3d000
0x00004848  ldr      x1, [x8, #0x200]   ; -> [@selector(setOrientation:animated:)]
0x0000484c  adrp     x2, #0x5000
0x00004850  add      x2, x2, #0x504
0x00004854  adrp     x3, #0x3e000
0x00004858  add      x3, x3, #0x968
0x0000485c  mov      x0, x21
0x00004860  bl       #0x243ec   ; call _MSHookMessageEx
0x00004864  adrp     x8, #0x3d000
0x00004868  ldr      x1, [x8, #0x970]   ; -> [@selector(orientation)]
0x0000486c  adrp     x2, #0x5000
0x00004870  add      x2, x2, #0x5d8
0x00004874  adrp     x3, #0x3e000
0x00004878  add      x3, x3, #0x970
0x0000487c  mov      x0, x21
0x00004880  bl       #0x243ec   ; call _MSHookMessageEx
0x00004884  adrp     x0, #0x29000
0x00004888  add      x0, x0, #0x2b   ; -> "UITextField"
0x0000488c  bl       #0x24788   ; call _objc_getClass
0x00004890  mov      x23, x0
0x00004894  adrp     x8, #0x3d000
0x00004898  ldr      x21, [x8, #0x208]   ; -> [@selector(becomeFirstResponder)]
0x0000489c  adrp     x2, #0x5000
0x000048a0  add      x2, x2, #0x60c
0x000048a4  adrp     x3, #0x3e000
0x000048a8  add      x3, x3, #0x978
0x000048ac  mov      x1, x21
0x000048b0  bl       #0x243ec   ; call _MSHookMessageEx
0x000048b4  adrp     x8, #0x3d000
0x000048b8  ldr      x22, [x8, #0xa80]   ; -> [@selector(resignFirstResponder)]
0x000048bc  adrp     x2, #0x5000
0x000048c0  add      x2, x2, #0x658
0x000048c4  adrp     x3, #0x3e000
0x000048c8  add      x3, x3, #0x980
0x000048cc  mov      x0, x23
0x000048d0  mov      x1, x22
0x000048d4  bl       #0x243ec   ; call _MSHookMessageEx
0x000048d8  adrp     x0, #0x29000
0x000048dc  add      x0, x0, #0x37   ; -> "UITextView"
0x000048e0  bl       #0x24788   ; call _objc_getClass
0x000048e4  mov      x23, x0
0x000048e8  adrp     x2, #0x5000
0x000048ec  add      x2, x2, #0x694
0x000048f0  adrp     x3, #0x3e000
0x000048f4  add      x3, x3, #0x988
0x000048f8  mov      x1, x21
0x000048fc  bl       #0x243ec   ; call _MSHookMessageEx
0x00004900  adrp     x2, #0x5000
0x00004904  add      x2, x2, #0x6f8
0x00004908  adrp     x3, #0x3e000
0x0000490c  add      x3, x3, #0x990
0x00004910  mov      x0, x23
0x00004914  mov      x1, x22
0x00004918  bl       #0x243ec   ; call _MSHookMessageEx
0x0000491c  adrp     x0, #0x29000
0x00004920  add      x0, x0, #0x42   ; -> "UIWindowScene"
0x00004924  adrp     x1, #0x34000
0x00004928  add      x1, x1, #0xed0   ; -> @"requestGeometryUpdateWithPreferences:errorHandler:"
0x0000492c  bl       #0x1e384   ; call _OMCHasMethod
0x00004930  cbz      w0, #0x4988
0x00004934  adrp     x0, #0x29000
0x00004938  add      x0, x0, #0x42   ; -> "UIWindowScene"
0x0000493c  bl       #0x24788   ; call _objc_getClass
0x00004940  adrp     x8, #0x3d000
0x00004944  ldr      x1, [x8, #0x210]   ; -> [@selector(requestGeometryUpdateWithPreferences:errorHandler:)]
0x00004948  adrp     x2, #0x5000
0x0000494c  add      x2, x2, #0x734
0x00004950  adrp     x3, #0x3e000
0x00004954  add      x3, x3, #0x998
0x00004958  bl       #0x243ec   ; call _MSHookMessageEx
0x0000495c  adrp     x0, #0x29000
0x00004960  add      x0, x0, #0x83   ; -> "UIViewController"
0x00004964  bl       #0x24788   ; call _objc_getClass
0x00004968  adrp     x8, #0x3d000
0x0000496c  ldr      x1, [x8, #0x218]   ; -> [@selector(setNeedsUpdateOfSupportedInterfaceOrientations)]
0x00004970  adrp     x2, #0x5000
0x00004974  add      x2, x2, #0x888
0x00004978  adrp     x3, #0x3e000
0x0000497c  add      x3, x3, #0x9a0
0x00004980  bl       #0x243ec   ; call _MSHookMessageEx
0x00004984  b        #0x49b4   ; call sub_49b4
0x00004988  adrp     x0, #0x29000
0x0000498c  add      x0, x0, #0x83   ; -> "UIViewController"
0x00004990  bl       #0x24788   ; call _objc_getClass
0x00004994  bl       #0x2489c   ; call _object_getClass
0x00004998  adrp     x8, #0x3d000
0x0000499c  ldr      x1, [x8, #0x220]   ; -> [@selector(attemptRotationToDeviceOrientation)]
0x000049a0  adrp     x2, #0x5000
0x000049a4  add      x2, x2, #0x8c0
0x000049a8  adrp     x3, #0x3e000
0x000049ac  add      x3, x3, #0x9a8
0x000049b0  bl       #0x243ec   ; call _MSHookMessageEx
0x000049b4  ldr      x0, [x19, #0x290]   ; -> [class(NSString)]
0x000049b8  ldr      x8, [x20, #0x20]
0x000049bc  str      x8, [sp]
0x000049c0  adrp     x2, #0x34000
0x000049c4  add      x2, x2, #0xf10   ; -> @"%@: dua len xe, cai hook"
0x000049c8  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x000049cc  mov      x29, x29
0x000049d0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000049d4  mov      x21, x0
0x000049d8  adrp     x0, #0x34000
0x000049dc  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x000049e0  mov      x1, x21
0x000049e4  bl       #0x1dd30   ; call _OMCLogWrite
0x000049e8  mov      x0, x21
0x000049ec  bl       #0x2480c   ; call _objc_release
0x000049f0  ldr      x0, [sp, #0x18]
0x000049f4  bl       #0x280c0   ; objc_msgSend: userInfo
0x000049f8  mov      x29, x29
0x000049fc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00004a00  mov      x21, x0
0x00004a04  bl       #0x24818   ; call _objc_retain
0x00004a08  adrp     x2, #0x34000
0x00004a0c  add      x2, x2, #0xf50   ; -> @"orientation"
0x00004a10  mov      x0, x21
0x00004a14  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00004a18  mov      x29, x29
0x00004a1c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00004a20  mov      x24, x0
0x00004a24  bl       #0x25ba0   ; objc_msgSend: intValue
0x00004a28  mov      x22, x0
0x00004a2c  mov      x0, x24
0x00004a30  bl       #0x2480c   ; call _objc_release
0x00004a34  adrp     x26, #0x3e000
0x00004a38  adrp     x25, #0x3e000
0x00004a3c  cmp      w22, #0
0x00004a40  b.le     #0x4a8c
0x00004a44  ldr      w23, [x25, #0x7d0]
0x00004a48  str      w22, [x25, #0x7d0]
0x00004a4c  adrp     x8, #0x3e000
0x00004a50  str      xzr, [x8, #0x9c8]
0x00004a54  adrp     x2, #0x35000
0x00004a58  add      x2, x2, #0xd0   ; -> @"device"
0x00004a5c  mov      x0, x21
0x00004a60  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00004a64  mov      x29, x29
0x00004a68  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00004a6c  mov      x24, x0
0x00004a70  bl       #0x25ba0   ; objc_msgSend: intValue
0x00004a74  str      w0, [x26, #0x9d0]
0x00004a78  mov      x0, x24
0x00004a7c  bl       #0x2480c   ; call _objc_release
0x00004a80  ldr      w9, [x25, #0x7d0]
0x00004a84  ldr      w8, [x26, #0x9d0]
0x00004a88  b        #0x4adc   ; call sub_4adc
0x00004a8c  adrp     x0, #0x3e000
0x00004a90  add      x0, x0, #0x930
0x00004a94  bl       #0x247a0   ; call _objc_loadWeakRetained
0x00004a98  mov      x23, x0
0x00004a9c  bl       #0x2480c   ; call _objc_release
0x00004aa0  cbz      x23, #0x4ac0
0x00004aa4  adrp     x0, #0x3e000
0x00004aa8  add      x0, x0, #0x930
0x00004aac  bl       #0x247a0   ; call _objc_loadWeakRetained
0x00004ab0  mov      x24, x0
0x00004ab4  bl       #0x26900   ; objc_msgSend: resignFirstResponder
0x00004ab8  mov      x0, x24
0x00004abc  bl       #0x2480c   ; call _objc_release
0x00004ac0  mov      w8, #0
0x00004ac4  ldr      w23, [x25, #0x7d0]
0x00004ac8  str      w22, [x25, #0x7d0]
0x00004acc  adrp     x9, #0x3e000
0x00004ad0  str      xzr, [x9, #0x9c8]
0x00004ad4  str      wzr, [x26, #0x9d0]
0x00004ad8  mov      x9, x22
0x00004adc  cmp      w22, w23
0x00004ae0  cset     w10, ne
0x00004ae4  ldr      x0, [x19, #0x290]   ; -> [class(NSString)]
0x00004ae8  stp      x8, x10, [sp, #8]
0x00004aec  str      x9, [sp]
0x00004af0  adrp     x2, #0x35000
0x00004af4  add      x2, x2, #0xf0   ; -> @"huong o %d, thiet bi gia %d (doi=%d)"
0x00004af8  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00004afc  mov      x29, x29
0x00004b00  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00004b04  mov      x24, x0
0x00004b08  adrp     x0, #0x34000
0x00004b0c  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00004b10  mov      x1, x24
0x00004b14  bl       #0x1dd30   ; call _OMCLogWrite
0x00004b18  mov      x0, x24
0x00004b1c  bl       #0x2480c   ; call _objc_release
0x00004b20  cmp      w22, w23
0x00004b24  b.eq     #0x4ca8
0x00004b28  ldr      w8, [x26, #0x9d0]
0x00004b2c  cmp      w8, #1
0x00004b30  b.lt     #0x4bc4
0x00004b34  movi     v0.16b, #0
0x00004b38  stp      q0, q0, [sp, #0x40]
0x00004b3c  stp      q0, q0, [sp, #0x20]
0x00004b40  adrp     x0, #0x39000
0x00004b44  add      x0, x0, #0x3f0
0x00004b48  add      x2, sp, #0x20
0x00004b4c  add      x3, sp, #0xa0
0x00004b50  mov      w4, #0x10
0x00004b54  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00004b58  mov      x23, x0
0x00004b5c  cbz      x0, #0x4bc4
0x00004b60  ldr      x8, [sp, #0x30]
0x00004b64  ldr      x24, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00004b68  adrp     x22, #0x39000
0x00004b6c  add      x22, x22, #0x3f0
0x00004b70  mov      x26, #0
0x00004b74  ldr      x8, [sp, #0x30]
0x00004b78  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00004b7c  cmp      x8, x24
0x00004b80  b.eq     #0x4b8c
0x00004b84  mov      x0, x22
0x00004b88  bl       #0x24770   ; call _objc_enumerationMutation
0x00004b8c  ldr      x8, [sp, #0x28]
0x00004b90  ldr      x0, [x8, x26, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x00004b94  bl       #0x25640   ; objc_msgSend: doubleValue
0x00004b98  bl       #0x5ff0   ; call sub_5ff0
0x00004b9c  add      x26, x26, #1
0x00004ba0  cmp      x23, x26
0x00004ba4  b.ne     #0x4b74
0x00004ba8  add      x2, sp, #0x20
0x00004bac  add      x3, sp, #0xa0
0x00004bb0  mov      x0, x22
0x00004bb4  mov      w4, #0x10
0x00004bb8  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00004bbc  mov      x23, x0
0x00004bc0  cbnz     x0, #0x4b70
0x00004bc4  ldr      w23, [x25, #0x7d0]
0x00004bc8  cmn      w23, #1
0x00004bcc  b.ne     #0x4c00
0x00004bd0  adrp     x8, #0x3e000
0x00004bd4  ldr      x0, [x8, #0x2b8]   ; -> [class(UIDevice)]
0x00004bd8  bl       #0x25460   ; objc_msgSend: currentDevice
0x00004bdc  mov      x29, x29
0x00004be0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00004be4  mov      x24, x0
0x00004be8  bl       #0x264c0   ; objc_msgSend: orientation
0x00004bec  mov      x22, x0
0x00004bf0  mov      x0, x24
0x00004bf4  bl       #0x2480c   ; call _objc_release
0x00004bf8  cmp      w22, #1
0x00004bfc  csinc    w23, w22, wzr, gt
0x00004c00  bl       #0x612c   ; call sub_612c
0x00004c04  cmp      w23, #1
0x00004c08  b.lt     #0x4c1c
0x00004c0c  mov      w8, #1
0x00004c10  lsl      w8, w8, w23
0x00004c14  tst      x0, x8
0x00004c18  b.eq     #0x4c6c
0x00004c1c  bl       #0x61d0   ; call sub_61d0
0x00004c20  mov      x29, x29
0x00004c24  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00004c28  mov      x24, x0
0x00004c2c  adrp     x0, #0x35000
0x00004c30  add      x0, x0, #0x130   ; -> @"_setRotatableViewOrientation:duration:force:"
0x00004c34  bl       #0x2441c   ; call _NSSelectorFromString
0x00004c38  cbz      x24, #0x4ca0
0x00004c3c  mov      x22, x0
0x00004c40  mov      x0, x24
0x00004c44  mov      x1, x22
0x00004c48  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00004c4c  tbz      w0, #0, #0x4ca0
0x00004c50  sxtw     x2, w23
0x00004c54  fmov     d0, xzr
0x00004c58  mov      x0, x24
0x00004c5c  mov      x1, x22
0x00004c60  mov      w3, #1
0x00004c64  bl       #0x247ac   ; call _objc_msgSend
0x00004c68  b        #0x4ca0   ; call sub_4ca0
0x00004c6c  ldr      x8, [x19, #0x290]   ; -> [class(NSString)]
0x00004c70  stp      x23, x0, [sp]
0x00004c74  adrp     x2, #0x35000
0x00004c78  add      x2, x2, #0x110   ; -> @"bo qua ep xoay %d: app chi cho mask %lu"
0x00004c7c  mov      x0, x8
0x00004c80  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00004c84  mov      x29, x29
0x00004c88  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00004c8c  mov      x24, x0
0x00004c90  adrp     x0, #0x34000
0x00004c94  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00004c98  mov      x1, x24
0x00004c9c  bl       #0x1dd30   ; call _OMCLogWrite
0x00004ca0  mov      x0, x24
0x00004ca4  bl       #0x2480c   ; call _objc_release
0x00004ca8  mov      x0, x21
0x00004cac  bl       #0x2480c   ; call _objc_release
0x00004cb0  mov      x0, x21
0x00004cb4  bl       #0x2480c   ; call _objc_release
0x00004cb8  ldr      x0, [sp, #0x18]
0x00004cbc  bl       #0x280c0   ; objc_msgSend: userInfo
0x00004cc0  mov      x29, x29
0x00004cc4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00004cc8  mov      x20, x0
0x00004ccc  adrp     x2, #0x34000
0x00004cd0  add      x2, x2, #0xf50   ; -> @"orientation"
0x00004cd4  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00004cd8  mov      x29, x29
0x00004cdc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00004ce0  mov      x21, x0
0x00004ce4  bl       #0x25ba0   ; objc_msgSend: intValue
0x00004ce8  mov      x25, x0
0x00004cec  cmp      w0, #1
0x00004cf0  b.lt     #0x4d2c
0x00004cf4  ldr      x0, [sp, #0x18]
0x00004cf8  bl       #0x280c0   ; objc_msgSend: userInfo
0x00004cfc  mov      x29, x29
0x00004d00  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00004d04  mov      x23, x0
0x00004d08  adrp     x2, #0x34000
0x00004d0c  add      x2, x2, #0xf70   ; -> @"fps"
0x00004d10  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00004d14  mov      x29, x29
0x00004d18  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00004d1c  mov      x24, x0
0x00004d20  bl       #0x25ba0   ; objc_msgSend: intValue
0x00004d24  mov      x22, x0
0x00004d28  b        #0x4d30   ; call sub_4d30
0x00004d2c  mov      w22, #0
0x00004d30  adrp     x8, #0x3e000
0x00004d34  ldr      w9, [x8, #0x9b0]
0x00004d38  cmp      w22, w9
0x00004d3c  b.eq     #0x4e30
0x00004d40  str      w22, [x8, #0x9b0]
0x00004d44  movi     v0.16b, #0
0x00004d48  stp      q0, q0, [sp, #0x60]
0x00004d4c  stp      q0, q0, [sp, #0x80]
0x00004d50  bl       #0x5c64   ; call sub_5c64
0x00004d54  mov      x29, x29
0x00004d58  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00004d5c  mov      x27, x0
0x00004d60  bl       #0x24c00   ; objc_msgSend: allObjects
0x00004d64  mov      x29, x29
0x00004d68  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00004d6c  mov      x26, x0
0x00004d70  mov      x0, x27
0x00004d74  bl       #0x2480c   ; call _objc_release
0x00004d78  add      x2, sp, #0x60
0x00004d7c  sub      x3, x29, #0xe0
0x00004d80  mov      x0, x26
0x00004d84  mov      w4, #0x10
0x00004d88  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00004d8c  mov      x27, x0
0x00004d90  cbz      x0, #0x4dec
0x00004d94  ldr      x8, [sp, #0x70]
0x00004d98  ldr      x28, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00004d9c  mov      x19, #0
0x00004da0  ldr      x8, [sp, #0x70]
0x00004da4  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00004da8  cmp      x8, x28
0x00004dac  b.eq     #0x4db8
0x00004db0  mov      x0, x26
0x00004db4  bl       #0x24770   ; call _objc_enumerationMutation
0x00004db8  ldr      x8, [sp, #0x68]
0x00004dbc  ldr      x0, [x8, x19, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x00004dc0  bl       #0x5cbc   ; call sub_5cbc
0x00004dc4  add      x19, x19, #1
0x00004dc8  cmp      x27, x19
0x00004dcc  b.ne     #0x4da0
0x00004dd0  add      x2, sp, #0x60
0x00004dd4  sub      x3, x29, #0xe0
0x00004dd8  mov      x0, x26
0x00004ddc  mov      w4, #0x10
0x00004de0  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00004de4  mov      x27, x0
0x00004de8  cbnz     x0, #0x4d9c
0x00004dec  mov      x0, x26
0x00004df0  bl       #0x2480c   ; call _objc_release
0x00004df4  adrp     x8, #0x3e000
0x00004df8  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x00004dfc  str      x22, [sp]
0x00004e00  adrp     x2, #0x35000
0x00004e04  add      x2, x2, #0x150   ; -> @"gioi han khung hinh: %d"
0x00004e08  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00004e0c  mov      x29, x29
0x00004e10  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00004e14  mov      x26, x0
0x00004e18  adrp     x0, #0x34000
0x00004e1c  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00004e20  mov      x1, x26
0x00004e24  bl       #0x1dd30   ; call _OMCLogWrite
0x00004e28  mov      x0, x26
0x00004e2c  bl       #0x2480c   ; call _objc_release
0x00004e30  cmp      w25, #1
0x00004e34  b.lt     #0x4e48
0x00004e38  mov      x0, x24
0x00004e3c  bl       #0x2480c   ; call _objc_release
0x00004e40  mov      x0, x23
0x00004e44  bl       #0x2480c   ; call _objc_release
0x00004e48  mov      x0, x21
0x00004e4c  bl       #0x2480c   ; call _objc_release
0x00004e50  mov      x0, x20
0x00004e54  bl       #0x2480c   ; call _objc_release
0x00004e58  ldr      x0, [sp, #0x18]
0x00004e5c  bl       #0x2480c   ; call _objc_release
0x00004e60  ldur     x8, [x29, #-0x60]
0x00004e64  adrp     x9, #0x34000
0x00004e68  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00004e6c  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x00004e70  cmp      x9, x8
0x00004e74  b.ne     #0x4e98
0x00004e78  add      sp, sp, #0x1b0
0x00004e7c  ldp      x29, x30, [sp, #0x50]
0x00004e80  ldp      x20, x19, [sp, #0x40]
0x00004e84  ldp      x22, x21, [sp, #0x30]
0x00004e88  ldp      x24, x23, [sp, #0x20]
0x00004e8c  ldp      x26, x25, [sp, #0x10]
0x00004e90  ldp      x28, x27, [sp], #0x60
0x00004e94  ret      
0x00004e98  bl       #0x24488   ; call ___stack_chk_fail
0x00004e9c  mov      x23, x1
0x00004ea0  mov      x22, x0
0x00004ea4  mov      x0, x24
0x00004ea8  bl       #0x2480c   ; call _objc_release
0x00004eac  b        #0x4fd4   ; call sub_4fd4
0x00004eb0  mov      x23, x1
0x00004eb4  mov      x22, x0
0x00004eb8  mov      x0, x24
0x00004ebc  bl       #0x2480c   ; call _objc_release
0x00004ec0  b        #0x4fd4   ; call sub_4fd4
0x00004ec4  b        #0x4fcc   ; call sub_4fcc
0x00004ec8  b        #0x4f78   ; call sub_4f78
0x00004ecc  b        #0x4fbc   ; call sub_4fbc
0x00004ed0  b        #0x4fcc   ; call sub_4fcc
0x00004ed4  b        #0x4fcc   ; call sub_4fcc
0x00004ed8  mov      x22, x0
0x00004edc  cmp      w25, #0
0x00004ee0  cset     w19, gt
0x00004ee4  mov      x0, x26
0x00004ee8  bl       #0x2480c   ; call _objc_release
0x00004eec  b        #0x506c   ; call sub_506c
0x00004ef0  mov      x22, x0
0x00004ef4  mov      x0, x21
0x00004ef8  bl       #0x2480c   ; call _objc_release
0x00004efc  b        #0x5090   ; call sub_5090
0x00004f00  b        #0x5058   ; call sub_5058
0x00004f04  b        #0x4fbc   ; call sub_4fbc
0x00004f08  mov      x22, x0
0x00004f0c  cmp      w25, #0
0x00004f10  cset     w19, gt
0x00004f14  mov      x0, x27
0x00004f18  bl       #0x2480c   ; call _objc_release
0x00004f1c  cbnz     w19, #0x5070
0x00004f20  b        #0x5080   ; call sub_5080
0x00004f24  b        #0x4fbc   ; call sub_4fbc
0x00004f28  b        #0x4fbc   ; call sub_4fbc
0x00004f2c  b        #0x4fbc   ; call sub_4fbc
0x00004f30  b        #0x4fcc   ; call sub_4fcc
0x00004f34  mov      x22, x0
0x00004f38  b        #0x5070   ; call sub_5070
0x00004f3c  mov      x22, x0
0x00004f40  b        #0x5078   ; call sub_5078
0x00004f44  b        #0x4f78   ; call sub_4f78
0x00004f48  mov      x23, x1
0x00004f4c  mov      x22, x0
0x00004f50  mov      x0, x24
0x00004f54  bl       #0x2480c   ; call _objc_release
0x00004f58  b        #0x4fd4   ; call sub_4fd4
0x00004f5c  mov      x22, x0
0x00004f60  cmp      w25, #0
0x00004f64  b.gt     #0x5070
0x00004f68  b        #0x5080   ; call sub_5080
0x00004f6c  b        #0x4f78   ; call sub_4f78
0x00004f70  mov      x22, x0
0x00004f74  b        #0x5088   ; call sub_5088
0x00004f78  mov      x23, x1
0x00004f7c  mov      x22, x0
0x00004f80  mov      x0, x24
0x00004f84  bl       #0x2480c   ; call _objc_release
0x00004f88  b        #0x4fd4   ; call sub_4fd4
0x00004f8c  b        #0x4fcc   ; call sub_4fcc
0x00004f90  mov      x23, x1
0x00004f94  mov      x22, x0
0x00004f98  b        #0x4fe4   ; call sub_4fe4
0x00004f9c  b        #0x4fbc   ; call sub_4fbc
0x00004fa0  b        #0x4fbc   ; call sub_4fbc
0x00004fa4  b        #0x4fbc   ; call sub_4fbc
0x00004fa8  mov      x22, x0
0x00004fac  b        #0x5080   ; call sub_5080
0x00004fb0  b        #0x4fcc   ; call sub_4fcc
0x00004fb4  b        #0x4fbc   ; call sub_4fbc
0x00004fb8  b        #0x4fbc   ; call sub_4fbc
0x00004fbc  mov      x22, x0
0x00004fc0  b        #0x5090   ; call sub_5090
0x00004fc4  b        #0x4fcc   ; call sub_4fcc
0x00004fc8  b        #0x5058   ; call sub_5058
0x00004fcc  mov      x23, x1
0x00004fd0  mov      x22, x0
0x00004fd4  mov      x0, x21
0x00004fd8  bl       #0x2480c   ; call _objc_release
0x00004fdc  mov      x0, x21
0x00004fe0  bl       #0x2480c   ; call _objc_release
0x00004fe4  cmp      w23, #1
0x00004fe8  b.ne     #0x5090
0x00004fec  mov      x0, x22
0x00004ff0  bl       #0x24740   ; call _objc_begin_catch
0x00004ff4  ldr      x8, [x19, #0x290]   ; -> [class(NSString)]
0x00004ff8  ldr      x9, [x20, #0x20]
0x00004ffc  stp      x9, x0, [sp]
0x00005000  adrp     x2, #0x34000
0x00005004  add      x2, x2, #0xf30   ; -> @"%@: xoay loi %@"
0x00005008  mov      x0, x8
0x0000500c  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00005010  mov      x29, x29
0x00005014  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005018  mov      x20, x0
0x0000501c  adrp     x0, #0x34000
0x00005020  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00005024  mov      x1, x20
0x00005028  bl       #0x1dd30   ; call _OMCLogWrite
0x0000502c  mov      x0, x20
0x00005030  bl       #0x2480c   ; call _objc_release
0x00005034  bl       #0x24764   ; call _objc_end_catch
0x00005038  b        #0x4cb8   ; call sub_4cb8
0x0000503c  mov      x22, x0
0x00005040  mov      x0, x20
0x00005044  bl       #0x2480c   ; call _objc_release
0x00005048  b        #0x5050   ; call sub_5050
0x0000504c  mov      x22, x0
0x00005050  bl       #0x24764   ; call _objc_end_catch
0x00005054  b        #0x5090   ; call sub_5090
0x00005058  mov      x22, x0
0x0000505c  cmp      w25, #0
0x00005060  cset     w19, gt
0x00005064  mov      x0, x26
0x00005068  bl       #0x2480c   ; call _objc_release
0x0000506c  tbz      w19, #0, #0x5080
0x00005070  mov      x0, x24
0x00005074  bl       #0x2480c   ; call _objc_release
0x00005078  mov      x0, x23
0x0000507c  bl       #0x2480c   ; call _objc_release
0x00005080  mov      x0, x21
0x00005084  bl       #0x2480c   ; call _objc_release
0x00005088  mov      x0, x20
0x0000508c  bl       #0x2480c   ; call _objc_release
0x00005090  ldr      x0, [sp, #0x18]
0x00005094  bl       #0x2480c   ; call _objc_release
0x00005098  b        #0x50a0   ; call sub_50a0
0x0000509c  mov      x22, x0
0x000050a0  mov      x0, x22
0x000050a4  bl       #0x24470   ; call __Unwind_Resume
0x000050a8  stp      x22, x21, [sp, #-0x30]!
0x000050ac  stp      x20, x19, [sp, #0x10]
0x000050b0  stp      x29, x30, [sp, #0x20]
0x000050b4  add      x29, sp, #0x20
0x000050b8  adrp     x8, #0x3e000
0x000050bc  ldr      x8, [x8, #0x940]
0x000050c0  blr      x8   ; indirect call
0x000050c4  mov      x29, x29
0x000050c8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000050cc  mov      x19, x0
0x000050d0  cbz      x0, #0x510c
0x000050d4  bl       #0x5c64   ; call sub_5c64
0x000050d8  mov      x29, x29
0x000050dc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000050e0  mov      x20, x0
0x000050e4  mov      x2, x19
0x000050e8  bl       #0x24b20   ; objc_msgSend: addObject:
0x000050ec  mov      x0, x20
0x000050f0  bl       #0x2480c   ; call _objc_release
0x000050f4  adrp     x8, #0x3e000
0x000050f8  ldr      w8, [x8, #0x9b0]
0x000050fc  cmp      w8, #1
0x00005100  b.lt     #0x510c
0x00005104  mov      x0, x19
0x00005108  bl       #0x5cbc   ; call sub_5cbc
0x0000510c  mov      x0, x19
0x00005110  ldp      x29, x30, [sp, #0x20]
0x00005114  ldp      x20, x19, [sp, #0x10]
0x00005118  ldp      x22, x21, [sp], #0x30
0x0000511c  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x00005120  mov      x21, x0
0x00005124  mov      x0, x20
0x00005128  bl       #0x2480c   ; call _objc_release
0x0000512c  b        #0x5134   ; call sub_5134
0x00005130  mov      x21, x0
0x00005134  mov      x0, x19
0x00005138  bl       #0x2480c   ; call _objc_release
0x0000513c  mov      x0, x21
0x00005140  bl       #0x24470   ; call __Unwind_Resume
0x00005144  stp      x22, x21, [sp, #-0x30]!
0x00005148  stp      x20, x19, [sp, #0x10]
0x0000514c  stp      x29, x30, [sp, #0x20]
0x00005150  add      x29, sp, #0x20
0x00005154  mov      x19, x2
0x00005158  mov      x20, x1
0x0000515c  mov      x21, x0
0x00005160  adrp     x8, #0x3e000
0x00005164  ldrb     w8, [x8, #0x9c0]
0x00005168  cmp      w8, #1
0x0000516c  b.eq     #0x51e8
0x00005170  adrp     x8, #0x3e000
0x00005174  ldr      x0, [x8, #0x2a0]   ; -> [class(NSNumber)]
0x00005178  mov      x2, x19
0x0000517c  bl       #0x26340   ; objc_msgSend: numberWithInteger:
0x00005180  mov      x29, x29
0x00005184  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005188  mov      x22, x0
0x0000518c  adrp     x1, #0x3e000
0x00005190  add      x1, x1, #0x9c2
0x00005194  mov      x0, x21
0x00005198  mov      x2, x22
0x0000519c  mov      w3, #1
0x000051a0  bl       #0x24848   ; call _objc_setAssociatedObject
0x000051a4  mov      x0, x22
0x000051a8  bl       #0x2480c   ; call _objc_release
0x000051ac  adrp     x1, #0x3e000
0x000051b0  add      x1, x1, #0x9c1
0x000051b4  mov      x0, x21
0x000051b8  mov      x2, #0
0x000051bc  mov      w3, #1
0x000051c0  bl       #0x24848   ; call _objc_setAssociatedObject
0x000051c4  adrp     x8, #0x3e000
0x000051c8  ldr      w8, [x8, #0x9b0]
0x000051cc  cmp      w8, #1
0x000051d0  b.lt     #0x51e8
0x000051d4  mov      x0, x21
0x000051d8  ldp      x29, x30, [sp, #0x20]
0x000051dc  ldp      x20, x19, [sp, #0x10]
0x000051e0  ldp      x22, x21, [sp], #0x30
0x000051e4  b        #0x5cbc   ; call sub_5cbc
0x000051e8  adrp     x8, #0x3e000
0x000051ec  ldr      x3, [x8, #0x948]
0x000051f0  mov      x0, x21
0x000051f4  mov      x1, x20
0x000051f8  mov      x2, x19
0x000051fc  ldp      x29, x30, [sp, #0x20]
0x00005200  ldp      x20, x19, [sp, #0x10]
0x00005204  ldp      x22, x21, [sp], #0x30
0x00005208  br       x3
0x0000520c  mov      x19, x0
0x00005210  mov      x0, x22
0x00005214  bl       #0x2480c   ; call _objc_release
0x00005218  mov      x0, x19
0x0000521c  bl       #0x24470   ; call __Unwind_Resume
0x00005220  sub      sp, sp, #0x80
0x00005224  stp      d11, d10, [sp, #0x20]
0x00005228  stp      d9, d8, [sp, #0x30]
0x0000522c  stp      x24, x23, [sp, #0x40]
0x00005230  stp      x22, x21, [sp, #0x50]
0x00005234  stp      x20, x19, [sp, #0x60]
0x00005238  stp      x29, x30, [sp, #0x70]
0x0000523c  add      x29, sp, #0x70
0x00005240  mov      v8.16b, v2.16b
0x00005244  mov      v9.16b, v1.16b
0x00005248  mov      v10.16b, v0.16b
0x0000524c  mov      x21, x1
0x00005250  mov      x20, x0
0x00005254  adrp     x8, #0x34000
0x00005258  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0000525c  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00005260  str      x8, [sp, #0x18]
0x00005264  adrp     x8, #0x3e000
0x00005268  ldrb     w8, [x8, #0x9c0]
0x0000526c  cmp      w8, #1
0x00005270  b.ne     #0x52c8
0x00005274  adrp     x8, #0x3e000
0x00005278  ldr      x2, [x8, #0x950]
0x0000527c  ldr      x8, [sp, #0x18]
0x00005280  adrp     x9, #0x34000
0x00005284  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00005288  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0000528c  cmp      x9, x8
0x00005290  b.ne     #0x53ec
0x00005294  mov      x0, x20
0x00005298  mov      x1, x21
0x0000529c  mov      v0.16b, v10.16b
0x000052a0  mov      v1.16b, v9.16b
0x000052a4  mov      v2.16b, v8.16b
0x000052a8  ldp      x29, x30, [sp, #0x70]
0x000052ac  ldp      x20, x19, [sp, #0x60]
0x000052b0  ldp      x22, x21, [sp, #0x50]
0x000052b4  ldp      x24, x23, [sp, #0x40]
0x000052b8  ldp      d9, d8, [sp, #0x30]
0x000052bc  ldp      d11, d10, [sp, #0x20]
0x000052c0  add      sp, sp, #0x80
0x000052c4  br       x2
0x000052c8  adrp     x23, #0x3e000
0x000052cc  ldr      x0, [x23, #0x2a0]   ; -> [class(NSNumber)]
0x000052d0  mov      v0.16b, v10.16b
0x000052d4  bl       #0x26300   ; objc_msgSend: numberWithFloat:
0x000052d8  mov      x29, x29
0x000052dc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000052e0  mov      x19, x0
0x000052e4  str      x0, [sp]
0x000052e8  ldr      x0, [x23, #0x2a0]   ; -> [class(NSNumber)]
0x000052ec  mov      v0.16b, v9.16b
0x000052f0  bl       #0x26300   ; objc_msgSend: numberWithFloat:
0x000052f4  mov      x29, x29
0x000052f8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000052fc  mov      x22, x0
0x00005300  str      x0, [sp, #8]
0x00005304  ldr      x0, [x23, #0x2a0]   ; -> [class(NSNumber)]
0x00005308  mov      v0.16b, v8.16b
0x0000530c  bl       #0x26300   ; objc_msgSend: numberWithFloat:
0x00005310  mov      x29, x29
0x00005314  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005318  mov      x23, x0
0x0000531c  str      x0, [sp, #0x10]
0x00005320  adrp     x8, #0x3e000
0x00005324  ldr      x0, [x8, #0x2a8]   ; -> [class(NSArray)]
0x00005328  mov      x2, sp
0x0000532c  mov      w3, #3
0x00005330  bl       #0x24e20   ; objc_msgSend: arrayWithObjects:count:
0x00005334  mov      x29, x29
0x00005338  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000533c  mov      x24, x0
0x00005340  adrp     x1, #0x3e000
0x00005344  add      x1, x1, #0x9c1
0x00005348  mov      x0, x20
0x0000534c  mov      x2, x24
0x00005350  mov      w3, #1
0x00005354  bl       #0x24848   ; call _objc_setAssociatedObject
0x00005358  mov      x0, x24
0x0000535c  bl       #0x2480c   ; call _objc_release
0x00005360  mov      x0, x23
0x00005364  bl       #0x2480c   ; call _objc_release
0x00005368  mov      x0, x22
0x0000536c  bl       #0x2480c   ; call _objc_release
0x00005370  mov      x0, x19
0x00005374  bl       #0x2480c   ; call _objc_release
0x00005378  adrp     x8, #0x3e000
0x0000537c  ldr      w8, [x8, #0x9b0]
0x00005380  cmp      w8, #1
0x00005384  b.lt     #0x5394
0x00005388  mov      x0, x20
0x0000538c  bl       #0x5cbc   ; call sub_5cbc
0x00005390  b        #0x53b4   ; call sub_53b4
0x00005394  adrp     x8, #0x3e000
0x00005398  ldr      x8, [x8, #0x950]
0x0000539c  mov      x0, x20
0x000053a0  mov      x1, x21
0x000053a4  mov      v0.16b, v10.16b
0x000053a8  mov      v1.16b, v9.16b
0x000053ac  mov      v2.16b, v8.16b
0x000053b0  blr      x8   ; indirect call
0x000053b4  ldr      x8, [sp, #0x18]
0x000053b8  adrp     x9, #0x34000
0x000053bc  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x000053c0  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x000053c4  cmp      x9, x8
0x000053c8  b.ne     #0x53ec
0x000053cc  ldp      x29, x30, [sp, #0x70]
0x000053d0  ldp      x20, x19, [sp, #0x60]
0x000053d4  ldp      x22, x21, [sp, #0x50]
0x000053d8  ldp      x24, x23, [sp, #0x40]
0x000053dc  ldp      d9, d8, [sp, #0x30]
0x000053e0  ldp      d11, d10, [sp, #0x20]
0x000053e4  add      sp, sp, #0x80
0x000053e8  ret      
0x000053ec  bl       #0x24488   ; call ___stack_chk_fail
0x000053f0  mov      x20, x0
0x000053f4  mov      x0, x24
0x000053f8  bl       #0x2480c   ; call _objc_release
0x000053fc  b        #0x5404   ; call sub_5404
0x00005400  mov      x20, x0
0x00005404  mov      x0, x23
0x00005408  bl       #0x2480c   ; call _objc_release
0x0000540c  b        #0x5414   ; call sub_5414
0x00005410  mov      x20, x0
0x00005414  mov      x0, x22
0x00005418  bl       #0x2480c   ; call _objc_release
0x0000541c  b        #0x5424   ; call sub_5424
0x00005420  mov      x20, x0
0x00005424  mov      x0, x19
0x00005428  bl       #0x2480c   ; call _objc_release
0x0000542c  b        #0x5434   ; call sub_5434
0x00005430  mov      x20, x0
0x00005434  mov      x0, x20
0x00005438  bl       #0x24470   ; call __Unwind_Resume
0x0000543c  stp      d9, d8, [sp, #-0x50]!
0x00005440  stp      x24, x23, [sp, #0x10]
0x00005444  stp      x22, x21, [sp, #0x20]
0x00005448  stp      x20, x19, [sp, #0x30]
0x0000544c  stp      x29, x30, [sp, #0x40]
0x00005450  add      x29, sp, #0x40
0x00005454  mov      x19, x3
0x00005458  mov      v8.16b, v0.16b
0x0000545c  mov      x20, x2
0x00005460  mov      x21, x1
0x00005464  mov      x22, x0
0x00005468  adrp     x8, #0x3e000
0x0000546c  ldr      x8, [x8, #0x9c8]
0x00005470  adrp     x9, #0x3e000
0x00005474  ldrsw    x9, [x9, #0x7d0]
0x00005478  cmp      x8, #0
0x0000547c  csel     x23, x8, x9, gt
0x00005480  bl       #0x5ec0   ; call sub_5ec0
0x00005484  mov      w8, #1
0x00005488  lsl      w8, w8, w23
0x0000548c  tst      x0, x8
0x00005490  ccmp     x23, #1, #8, ne
0x00005494  adrp     x8, #0x3e000
0x00005498  ldr      x4, [x8, #0x958]
0x0000549c  csel     x2, x20, x23, lt
0x000054a0  mov      x0, x22
0x000054a4  mov      x1, x21
0x000054a8  mov      v0.16b, v8.16b
0x000054ac  mov      x3, x19
0x000054b0  ldp      x29, x30, [sp, #0x40]
0x000054b4  ldp      x20, x19, [sp, #0x30]
0x000054b8  ldp      x22, x21, [sp, #0x20]
0x000054bc  ldp      x24, x23, [sp, #0x10]
0x000054c0  ldp      d9, d8, [sp], #0x50
0x000054c4  br       x4
0x000054c8  stp      x29, x30, [sp, #-0x10]!
0x000054cc  mov      x29, sp
0x000054d0  adrp     x8, #0x3e000
0x000054d4  ldr      x8, [x8, #0x960]
0x000054d8  blr      x8   ; indirect call
0x000054dc  adrp     x8, #0x3e000
0x000054e0  ldr      w8, [x8, #0x9d0]
0x000054e4  cmp      w8, #1
0x000054e8  b.lt     #0x54fc
0x000054ec  adrp     x8, #0x2b000
0x000054f0  ldr      d0, [x8, #0x1d8]
0x000054f4  ldp      x29, x30, [sp], #0x10
0x000054f8  b        #0x5ff0   ; call sub_5ff0
0x000054fc  ldp      x29, x30, [sp], #0x10
0x00005500  ret      
0x00005504  sub      sp, sp, #0x50
0x00005508  stp      x24, x23, [sp, #0x10]
0x0000550c  stp      x22, x21, [sp, #0x20]
0x00005510  stp      x20, x19, [sp, #0x30]
0x00005514  stp      x29, x30, [sp, #0x40]
0x00005518  add      x29, sp, #0x40
0x0000551c  mov      x19, x3
0x00005520  mov      x20, x2
0x00005524  mov      x21, x1
0x00005528  mov      x22, x0
0x0000552c  adrp     x8, #0x3e000
0x00005530  ldr      w8, [x8, #0x7d0]
0x00005534  cmp      w8, #1
0x00005538  b.lt     #0x5594
0x0000553c  sub      x8, x20, #3
0x00005540  cmp      x8, #2
0x00005544  csel     x8, x20, xzr, lo
0x00005548  adrp     x24, #0x3e000
0x0000554c  str      x8, [x24, #0x9c8]
0x00005550  adrp     x9, #0x3e000
0x00005554  ldr      x0, [x9, #0x290]   ; -> [class(NSString)]
0x00005558  stp      x20, x8, [sp]
0x0000555c  adrp     x2, #0x34000
0x00005560  add      x2, x2, #0xff0   ; -> @"app setOrientation %lld -> %lld"
0x00005564  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00005568  mov      x29, x29
0x0000556c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005570  mov      x23, x0
0x00005574  adrp     x0, #0x34000
0x00005578  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000557c  mov      x1, x23
0x00005580  bl       #0x1dd30   ; call _OMCLogWrite
0x00005584  mov      x0, x23
0x00005588  bl       #0x2480c   ; call _objc_release
0x0000558c  ldr      x0, [x24, #0x9c8]
0x00005590  bl       #0x6750   ; call sub_6750
0x00005594  adrp     x8, #0x3e000
0x00005598  ldr      x4, [x8, #0x968]
0x0000559c  mov      x0, x22
0x000055a0  mov      x1, x21
0x000055a4  mov      x2, x20
0x000055a8  mov      x3, x19
0x000055ac  ldp      x29, x30, [sp, #0x40]
0x000055b0  ldp      x20, x19, [sp, #0x30]
0x000055b4  ldp      x22, x21, [sp, #0x20]
0x000055b8  ldp      x24, x23, [sp, #0x10]
0x000055bc  add      sp, sp, #0x50
0x000055c0  br       x4
0x000055c4  mov      x19, x0
0x000055c8  mov      x0, x23
0x000055cc  bl       #0x2480c   ; call _objc_release
0x000055d0  mov      x0, x19
0x000055d4  bl       #0x24470   ; call __Unwind_Resume
0x000055d8  adrp     x8, #0x3e000
0x000055dc  ldr      x8, [x8, #0x9c8]
0x000055e0  cmp      x8, #0
0x000055e4  b.gt     #0x55f8
0x000055e8  adrp     x8, #0x3e000
0x000055ec  ldr      w8, [x8, #0x9d0]
0x000055f0  cmp      w8, #1
0x000055f4  b.lt     #0x5600
0x000055f8  mov      x0, x8
0x000055fc  ret      
0x00005600  adrp     x8, #0x3e000
0x00005604  ldr      x2, [x8, #0x970]
0x00005608  br       x2
0x0000560c  stp      x20, x19, [sp, #-0x20]!
0x00005610  stp      x29, x30, [sp, #0x10]
0x00005614  add      x29, sp, #0x10
0x00005618  mov      x20, x1
0x0000561c  mov      x19, x0
0x00005620  bl       #0x698c   ; call sub_698c
0x00005624  adrp     x8, #0x3e000
0x00005628  ldr      x8, [x8, #0x978]
0x0000562c  mov      x0, x19
0x00005630  mov      x1, x20
0x00005634  blr      x8   ; indirect call
0x00005638  mov      x20, x0
0x0000563c  cbz      w0, #0x5648
0x00005640  mov      x0, x19
0x00005644  bl       #0x6a70   ; call sub_6a70
0x00005648  mov      x0, x20
0x0000564c  ldp      x29, x30, [sp, #0x10]
0x00005650  ldp      x20, x19, [sp], #0x20
0x00005654  ret      
0x00005658  stp      x20, x19, [sp, #-0x20]!
0x0000565c  stp      x29, x30, [sp, #0x10]
0x00005660  add      x29, sp, #0x10
0x00005664  mov      x19, x0
0x00005668  adrp     x8, #0x3e000
0x0000566c  ldr      x8, [x8, #0x980]
0x00005670  blr      x8   ; indirect call
0x00005674  mov      x20, x0
0x00005678  cbz      w0, #0x5684
0x0000567c  mov      x0, x19
0x00005680  bl       #0x6d50   ; call sub_6d50
0x00005684  mov      x0, x20
0x00005688  ldp      x29, x30, [sp, #0x10]
0x0000568c  ldp      x20, x19, [sp], #0x20
0x00005690  ret      
0x00005694  stp      x20, x19, [sp, #-0x20]!
0x00005698  stp      x29, x30, [sp, #0x10]
0x0000569c  add      x29, sp, #0x10
0x000056a0  mov      x20, x1
0x000056a4  mov      x19, x0
0x000056a8  bl       #0x25c80   ; objc_msgSend: isEditable
0x000056ac  cbz      w0, #0x56b8
0x000056b0  mov      x0, x19
0x000056b4  bl       #0x698c   ; call sub_698c
0x000056b8  adrp     x8, #0x3e000
0x000056bc  ldr      x8, [x8, #0x988]
0x000056c0  mov      x0, x19
0x000056c4  mov      x1, x20
0x000056c8  blr      x8   ; indirect call
0x000056cc  mov      x20, x0
0x000056d0  cbz      w0, #0x56e8
0x000056d4  mov      x0, x19
0x000056d8  bl       #0x25c80   ; objc_msgSend: isEditable
0x000056dc  cbz      w0, #0x56e8
0x000056e0  mov      x0, x19
0x000056e4  bl       #0x6a70   ; call sub_6a70
0x000056e8  mov      x0, x20
0x000056ec  ldp      x29, x30, [sp, #0x10]
0x000056f0  ldp      x20, x19, [sp], #0x20
0x000056f4  ret      
0x000056f8  stp      x20, x19, [sp, #-0x20]!
0x000056fc  stp      x29, x30, [sp, #0x10]
0x00005700  add      x29, sp, #0x10
0x00005704  mov      x19, x0
0x00005708  adrp     x8, #0x3e000
0x0000570c  ldr      x8, [x8, #0x990]
0x00005710  blr      x8   ; indirect call
0x00005714  mov      x20, x0
0x00005718  cbz      w0, #0x5724
0x0000571c  mov      x0, x19
0x00005720  bl       #0x6d50   ; call sub_6d50
0x00005724  mov      x0, x20
0x00005728  ldp      x29, x30, [sp, #0x10]
0x0000572c  ldp      x20, x19, [sp], #0x20
0x00005730  ret      
0x00005734  sub      sp, sp, #0x50
0x00005738  stp      x24, x23, [sp, #0x10]
0x0000573c  stp      x22, x21, [sp, #0x20]
0x00005740  stp      x20, x19, [sp, #0x30]
0x00005744  stp      x29, x30, [sp, #0x40]
0x00005748  add      x29, sp, #0x40
0x0000574c  mov      x20, x3
0x00005750  mov      x19, x2
0x00005754  mov      x21, x1
0x00005758  mov      x22, x0
0x0000575c  mov      x0, x2
0x00005760  bl       #0x24818   ; call _objc_retain
0x00005764  mov      x0, x20
0x00005768  bl       #0x24818   ; call _objc_retain
0x0000576c  adrp     x8, #0x3e000
0x00005770  ldr      w8, [x8, #0x7d0]
0x00005774  cmp      w8, #1
0x00005778  b.lt     #0x5818
0x0000577c  adrp     x8, #0x3d000
0x00005780  ldr      x23, [x8, #0x228]   ; -> [@selector(interfaceOrientations)]
0x00005784  mov      x0, x19
0x00005788  mov      x1, x23
0x0000578c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00005790  tbz      w0, #0, #0x5818
0x00005794  mov      x0, x19
0x00005798  mov      x1, x23
0x0000579c  bl       #0x247ac   ; call _objc_msgSend
0x000057a0  mov      w8, #4
0x000057a4  mov      w9, #3
0x000057a8  lsr      x10, x0, #1
0x000057ac  and      x10, x10, #2
0x000057b0  tst      w0, #8
0x000057b4  csel     x9, x9, x10, ne
0x000057b8  tst      w0, #0x10
0x000057bc  csel     x8, x8, x9, ne
0x000057c0  tst      w0, #2
0x000057c4  csel     x9, xzr, x8, ne
0x000057c8  adrp     x24, #0x3e000
0x000057cc  str      x9, [x24, #0x9c8]
0x000057d0  adrp     x8, #0x3e000
0x000057d4  ldr      x8, [x8, #0x290]   ; -> [class(NSString)]
0x000057d8  stp      x0, x9, [sp]
0x000057dc  adrp     x2, #0x35000
0x000057e0  add      x2, x2, #0xb0   ; -> @"app xin huong mask=%lu -> %lld"
0x000057e4  mov      x0, x8
0x000057e8  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x000057ec  mov      x29, x29
0x000057f0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000057f4  mov      x23, x0
0x000057f8  adrp     x0, #0x34000
0x000057fc  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00005800  mov      x1, x23
0x00005804  bl       #0x1dd30   ; call _OMCLogWrite
0x00005808  mov      x0, x23
0x0000580c  bl       #0x2480c   ; call _objc_release
0x00005810  ldr      x0, [x24, #0x9c8]
0x00005814  bl       #0x6750   ; call sub_6750
0x00005818  adrp     x8, #0x3e000
0x0000581c  ldr      x8, [x8, #0x998]
0x00005820  mov      x0, x22
0x00005824  mov      x1, x21
0x00005828  mov      x2, x19
0x0000582c  mov      x3, x20
0x00005830  blr      x8   ; indirect call
0x00005834  mov      x0, x20
0x00005838  bl       #0x2480c   ; call _objc_release
0x0000583c  mov      x0, x19
0x00005840  ldp      x29, x30, [sp, #0x40]
0x00005844  ldp      x20, x19, [sp, #0x30]
0x00005848  ldp      x22, x21, [sp, #0x20]
0x0000584c  ldp      x24, x23, [sp, #0x10]
0x00005850  add      sp, sp, #0x50
0x00005854  b        #0x2480c   ; call _objc_release
0x00005858  mov      x21, x0
0x0000585c  mov      x0, x23
0x00005860  bl       #0x2480c   ; call _objc_release
0x00005864  b        #0x5870   ; call sub_5870
0x00005868  b        #0x586c   ; call sub_586c
0x0000586c  mov      x21, x0
0x00005870  mov      x0, x20
0x00005874  bl       #0x2480c   ; call _objc_release
0x00005878  mov      x0, x19
0x0000587c  bl       #0x2480c   ; call _objc_release
0x00005880  mov      x0, x21
0x00005884  bl       #0x24470   ; call __Unwind_Resume
0x00005888  stp      x29, x30, [sp, #-0x10]!
0x0000588c  mov      x29, sp
0x00005890  adrp     x8, #0x3e000
0x00005894  ldr      x8, [x8, #0x9a0]
0x00005898  blr      x8   ; indirect call
0x0000589c  adrp     x8, #0x3e000
0x000058a0  ldr      w8, [x8, #0x7d0]
0x000058a4  cmp      w8, #1
0x000058a8  b.lt     #0x58b8
0x000058ac  mov      w0, #0xff
0x000058b0  ldp      x29, x30, [sp], #0x10
0x000058b4  b        #0x6750   ; call sub_6750
0x000058b8  ldp      x29, x30, [sp], #0x10
0x000058bc  ret      
0x000058c0  stp      x29, x30, [sp, #-0x10]!
0x000058c4  mov      x29, sp
0x000058c8  adrp     x8, #0x3e000
0x000058cc  ldr      x8, [x8, #0x9a8]
0x000058d0  blr      x8   ; indirect call
0x000058d4  adrp     x8, #0x3e000
0x000058d8  ldr      w8, [x8, #0x7d0]
0x000058dc  cmp      w8, #1
0x000058e0  b.lt     #0x58f0
0x000058e4  mov      w0, #0xff
0x000058e8  ldp      x29, x30, [sp], #0x10
0x000058ec  b        #0x6750   ; call sub_6750
0x000058f0  ldp      x29, x30, [sp], #0x10
0x000058f4  ret      
0x000058f8  ldr      x0, [x1, #0x20]   ; -> [@selector(timeZoneForSecondsFromGMT:)]
0x000058fc  b        #0x24818   ; call _objc_retain
0x00005900  ldr      x0, [x0, #0x20]   ; -> [got:_class_getClassMethod]
0x00005904  b        #0x2480c   ; call _objc_release
0x00005908  sub      sp, sp, #0x60
0x0000590c  stp      x26, x25, [sp, #0x10]
0x00005910  stp      x24, x23, [sp, #0x20]
0x00005914  stp      x22, x21, [sp, #0x30]
0x00005918  stp      x20, x19, [sp, #0x40]
0x0000591c  stp      x29, x30, [sp, #0x50]
0x00005920  add      x29, sp, #0x50
0x00005924  mov      x19, x1
0x00005928  mov      x21, x0
0x0000592c  mov      x0, x1
0x00005930  bl       #0x24818   ; call _objc_retain
0x00005934  mov      x0, x19
0x00005938  bl       #0x280c0   ; objc_msgSend: userInfo
0x0000593c  mov      x29, x29
0x00005940  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005944  mov      x20, x0
0x00005948  bl       #0x24818   ; call _objc_retain
0x0000594c  adrp     x0, #0x3e000
0x00005950  add      x0, x0, #0x930
0x00005954  bl       #0x247a0   ; call _objc_loadWeakRetained
0x00005958  mov      x22, x0
0x0000595c  cbz      x0, #0x5ae0
0x00005960  mov      x0, x22
0x00005964  bl       #0x25ce0   ; objc_msgSend: isFirstResponder
0x00005968  cbz      w0, #0x5ae0
0x0000596c  adrp     x8, #0x3e000
0x00005970  ldr      x2, [x8, #0x278]
0x00005974  mov      x0, x22
0x00005978  bl       #0x25320   ; objc_msgSend: conformsToProtocol:
0x0000597c  tbz      w0, #0, #0x5ae0
0x00005980  adrp     x2, #0x35000
0x00005984  add      x2, x2, #0x170   ; -> @"action"
0x00005988  mov      x0, x20
0x0000598c  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00005990  mov      x29, x29
0x00005994  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005998  mov      x23, x0
0x0000599c  adrp     x2, #0x35000
0x000059a0  add      x2, x2, #0x190   ; -> @"type"
0x000059a4  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x000059a8  cbz      w0, #0x5a4c
0x000059ac  adrp     x2, #0x35000
0x000059b0  add      x2, x2, #0x1b0   ; -> @"del"
0x000059b4  mov      x0, x20
0x000059b8  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000059bc  mov      x29, x29
0x000059c0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000059c4  mov      x24, x0
0x000059c8  bl       #0x25ba0   ; objc_msgSend: intValue
0x000059cc  mov      x25, x0
0x000059d0  mov      x0, x24
0x000059d4  bl       #0x2480c   ; call _objc_release
0x000059d8  cmp      w25, #1
0x000059dc  b.lt     #0x59f8
0x000059e0  add      w24, w25, #1
0x000059e4  mov      x0, x22
0x000059e8  bl       #0x25520   ; objc_msgSend: deleteBackward
0x000059ec  sub      w24, w24, #1
0x000059f0  cmp      w24, #1
0x000059f4  b.gt     #0x59e4
0x000059f8  adrp     x2, #0x35000
0x000059fc  add      x2, x2, #0x1d0   ; -> @"text"
0x00005a00  mov      x0, x20
0x00005a04  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00005a08  mov      x29, x29
0x00005a0c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005a10  mov      x24, x0
0x00005a14  adrp     x8, #0x3e000
0x00005a18  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x00005a1c  bl       #0x247d0   ; call _objc_opt_class
0x00005a20  mov      x1, x0
0x00005a24  mov      x0, x24
0x00005a28  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x00005a2c  tbz      w0, #0, #0x5ad0
0x00005a30  mov      x0, x24
0x00005a34  bl       #0x25fa0   ; objc_msgSend: length
0x00005a38  cbz      x0, #0x5ad0
0x00005a3c  mov      x0, x22
0x00005a40  mov      x2, x24
0x00005a44  bl       #0x25b80   ; objc_msgSend: insertText:
0x00005a48  b        #0x5ad0   ; call sub_5ad0
0x00005a4c  adrp     x2, #0x35000
0x00005a50  add      x2, x2, #0x1f0   ; -> @"return"
0x00005a54  mov      x0, x23
0x00005a58  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00005a5c  cbz      w0, #0x5b18
0x00005a60  adrp     x8, #0x3e000
0x00005a64  ldr      x0, [x8, #0x2d8]   ; -> [class(UITextField)]
0x00005a68  bl       #0x247d0   ; call _objc_opt_class
0x00005a6c  mov      x1, x0
0x00005a70  mov      x0, x22
0x00005a74  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x00005a78  tbz      w0, #0, #0x5b38
0x00005a7c  mov      x0, x22
0x00005a80  bl       #0x24818   ; call _objc_retain
0x00005a84  mov      x0, x22
0x00005a88  bl       #0x25500   ; objc_msgSend: delegate
0x00005a8c  mov      x29, x29
0x00005a90  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005a94  mov      x24, x0
0x00005a98  adrp     x8, #0x3e000
0x00005a9c  ldr      x1, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00005aa0  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00005aa4  tbz      w0, #0, #0x5ab8
0x00005aa8  mov      x0, x24
0x00005aac  mov      x2, x22
0x00005ab0  bl       #0x27f00   ; objc_msgSend: textFieldShouldReturn:
0x00005ab4  cbz      w0, #0x5ac4
0x00005ab8  mov      x0, x22
0x00005abc  mov      w2, #0x80000
0x00005ac0  bl       #0x26aa0   ; objc_msgSend: sendActionsForControlEvents:
0x00005ac4  mov      x0, x24
0x00005ac8  bl       #0x2480c   ; call _objc_release
0x00005acc  mov      x24, x22
0x00005ad0  mov      x0, x24
0x00005ad4  bl       #0x2480c   ; call _objc_release
0x00005ad8  mov      x0, x23
0x00005adc  bl       #0x2480c   ; call _objc_release
0x00005ae0  mov      x0, x22
0x00005ae4  bl       #0x2480c   ; call _objc_release
0x00005ae8  mov      x0, x20
0x00005aec  bl       #0x2480c   ; call _objc_release
0x00005af0  mov      x0, x20
0x00005af4  bl       #0x2480c   ; call _objc_release
0x00005af8  mov      x0, x19
0x00005afc  ldp      x29, x30, [sp, #0x50]
0x00005b00  ldp      x20, x19, [sp, #0x40]
0x00005b04  ldp      x22, x21, [sp, #0x30]
0x00005b08  ldp      x24, x23, [sp, #0x20]
0x00005b0c  ldp      x26, x25, [sp, #0x10]
0x00005b10  add      sp, sp, #0x60
0x00005b14  b        #0x2480c   ; call _objc_release
0x00005b18  adrp     x2, #0x35000
0x00005b1c  add      x2, x2, #0x230   ; -> @"dismiss"
0x00005b20  mov      x0, x23
0x00005b24  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00005b28  cbz      w0, #0x5ad8
0x00005b2c  mov      x0, x22
0x00005b30  bl       #0x26900   ; objc_msgSend: resignFirstResponder
0x00005b34  b        #0x5ad8   ; call sub_5ad8
0x00005b38  adrp     x2, #0x35000
0x00005b3c  add      x2, x2, #0x210   ; -> @"
"
0x00005b40  mov      x0, x22
0x00005b44  bl       #0x25b80   ; objc_msgSend: insertText:
0x00005b48  b        #0x5ad8   ; call sub_5ad8
0x00005b4c  mov      x25, x1
0x00005b50  mov      x24, x0
0x00005b54  b        #0x5b6c   ; call sub_5b6c
0x00005b58  mov      x25, x1
0x00005b5c  mov      x1, x24
0x00005b60  mov      x24, x0
0x00005b64  mov      x0, x1
0x00005b68  bl       #0x2480c   ; call _objc_release
0x00005b6c  mov      x0, x22
0x00005b70  b        #0x5b94   ; call sub_5b94
0x00005b74  b        #0x5bb8   ; call sub_5bb8
0x00005b78  b        #0x5b84   ; call sub_5b84
0x00005b7c  b        #0x5bb8   ; call sub_5bb8
0x00005b80  b        #0x5ba0   ; call sub_5ba0
0x00005b84  mov      x25, x1
0x00005b88  mov      x1, x24
0x00005b8c  mov      x24, x0
0x00005b90  mov      x0, x1
0x00005b94  bl       #0x2480c   ; call _objc_release
0x00005b98  b        #0x5bc0   ; call sub_5bc0
0x00005b9c  b        #0x5bb8   ; call sub_5bb8
0x00005ba0  mov      x25, x1
0x00005ba4  mov      x24, x0
0x00005ba8  b        #0x5bc8   ; call sub_5bc8
0x00005bac  mov      x25, x1
0x00005bb0  mov      x24, x0
0x00005bb4  b        #0x5be0   ; call sub_5be0
0x00005bb8  mov      x25, x1
0x00005bbc  mov      x24, x0
0x00005bc0  mov      x0, x23
0x00005bc4  bl       #0x2480c   ; call _objc_release
0x00005bc8  mov      x0, x22
0x00005bcc  bl       #0x2480c   ; call _objc_release
0x00005bd0  mov      x0, x20
0x00005bd4  bl       #0x2480c   ; call _objc_release
0x00005bd8  mov      x0, x20
0x00005bdc  bl       #0x2480c   ; call _objc_release
0x00005be0  cmp      w25, #1
0x00005be4  b.ne     #0x5c54
0x00005be8  mov      x0, x24
0x00005bec  bl       #0x24740   ; call _objc_begin_catch
0x00005bf0  adrp     x8, #0x3e000
0x00005bf4  ldr      x8, [x8, #0x290]   ; -> [class(NSString)]
0x00005bf8  ldr      x9, [x21, #0x20]
0x00005bfc  stp      x9, x0, [sp]
0x00005c00  adrp     x2, #0x34000
0x00005c04  add      x2, x2, #0xfb0   ; -> @"%@: phim loi %@"
0x00005c08  mov      x0, x8
0x00005c0c  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00005c10  mov      x29, x29
0x00005c14  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005c18  mov      x20, x0
0x00005c1c  adrp     x0, #0x34000
0x00005c20  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00005c24  mov      x1, x20
0x00005c28  bl       #0x1dd30   ; call _OMCLogWrite
0x00005c2c  mov      x0, x20
0x00005c30  bl       #0x2480c   ; call _objc_release
0x00005c34  bl       #0x24764   ; call _objc_end_catch
0x00005c38  b        #0x5af8   ; call sub_5af8
0x00005c3c  mov      x24, x0
0x00005c40  mov      x0, x20
0x00005c44  bl       #0x2480c   ; call _objc_release
0x00005c48  b        #0x5c50   ; call sub_5c50
0x00005c4c  mov      x24, x0
0x00005c50  bl       #0x24764   ; call _objc_end_catch
0x00005c54  mov      x0, x19
0x00005c58  bl       #0x2480c   ; call _objc_release
0x00005c5c  mov      x0, x24
0x00005c60  bl       #0x24470   ; call __Unwind_Resume
0x00005c64  stp      x20, x19, [sp, #-0x20]!
0x00005c68  stp      x29, x30, [sp, #0x10]
0x00005c6c  add      x29, sp, #0x10
0x00005c70  adrp     x20, #0x3e000
0x00005c74  ldr      x19, [x20, #0x9b8]
0x00005c78  cbnz     x19, #0x5ca4
0x00005c7c  adrp     x8, #0x3e000
0x00005c80  ldr      x0, [x8, #0x298]   ; -> [class(NSHashTable)]
0x00005c84  bl       #0x28180   ; objc_msgSend: weakObjectsHashTable
0x00005c88  mov      x29, x29
0x00005c8c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005c90  ldr      x8, [x20, #0x9b8]
0x00005c94  str      x0, [x20, #0x9b8]
0x00005c98  mov      x0, x8
0x00005c9c  bl       #0x2480c   ; call _objc_release
0x00005ca0  ldr      x19, [x20, #0x9b8]
0x00005ca4  mov      x0, x19
0x00005ca8  bl       #0x24818   ; call _objc_retain
0x00005cac  mov      x0, x19
0x00005cb0  ldp      x29, x30, [sp, #0x10]
0x00005cb4  ldp      x20, x19, [sp], #0x20
0x00005cb8  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x00005cbc  stp      d11, d10, [sp, #-0x60]!
0x00005cc0  stp      d9, d8, [sp, #0x10]
0x00005cc4  stp      x24, x23, [sp, #0x20]
0x00005cc8  stp      x22, x21, [sp, #0x30]
0x00005ccc  stp      x20, x19, [sp, #0x40]
0x00005cd0  stp      x29, x30, [sp, #0x50]
0x00005cd4  add      x29, sp, #0x50
0x00005cd8  mov      x19, x0
0x00005cdc  bl       #0x24818   ; call _objc_retain
0x00005ce0  adrp     x23, #0x3e000
0x00005ce4  mov      w8, #1
0x00005ce8  strb     w8, [x23, #0x9c0]
0x00005cec  adrp     x1, #0x3e000
0x00005cf0  add      x1, x1, #0x9c1
0x00005cf4  mov      x0, x19
0x00005cf8  bl       #0x2477c   ; call _objc_getAssociatedObject
0x00005cfc  mov      x29, x29
0x00005d00  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005d04  mov      x20, x0
0x00005d08  bl       #0x25420   ; objc_msgSend: count
0x00005d0c  cmp      x0, #3
0x00005d10  b.ne     #0x5de4
0x00005d14  mov      x0, x20
0x00005d18  mov      x2, #0
0x00005d1c  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x00005d20  mov      x29, x29
0x00005d24  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005d28  mov      x21, x0
0x00005d2c  bl       #0x257a0   ; objc_msgSend: floatValue
0x00005d30  mov      v8.16b, v0.16b
0x00005d34  mov      x0, x21
0x00005d38  bl       #0x2480c   ; call _objc_release
0x00005d3c  mov      x0, x20
0x00005d40  mov      w2, #1
0x00005d44  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x00005d48  mov      x29, x29
0x00005d4c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005d50  mov      x21, x0
0x00005d54  bl       #0x257a0   ; objc_msgSend: floatValue
0x00005d58  mov      v9.16b, v0.16b
0x00005d5c  mov      x0, x21
0x00005d60  bl       #0x2480c   ; call _objc_release
0x00005d64  mov      x0, x20
0x00005d68  mov      w2, #2
0x00005d6c  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x00005d70  mov      x29, x29
0x00005d74  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005d78  mov      x21, x0
0x00005d7c  bl       #0x257a0   ; objc_msgSend: floatValue
0x00005d80  mov      v10.16b, v0.16b
0x00005d84  mov      x0, x21
0x00005d88  bl       #0x2480c   ; call _objc_release
0x00005d8c  adrp     x8, #0x3e000
0x00005d90  ldr      w8, [x8, #0x9b0]
0x00005d94  cmp      w8, #1
0x00005d98  b.lt     #0x5dc8
0x00005d9c  ucvtf    s0, w8
0x00005da0  fcmp     s9, s0
0x00005da4  fmov     s1, wzr
0x00005da8  fccmp    s9, s1, #4, mi
0x00005dac  fcsel    s9, s9, s0, gt
0x00005db0  fcmp     s10, s9
0x00005db4  fcsel    s0, s10, s9, mi
0x00005db8  fcmp     s10, #0.0
0x00005dbc  fcsel    s10, s0, s1, gt
0x00005dc0  fcmp     s8, s9
0x00005dc4  fcsel    s8, s8, s9, mi
0x00005dc8  mov      v0.16b, v8.16b
0x00005dcc  mov      v1.16b, v9.16b
0x00005dd0  mov      v2.16b, v10.16b
0x00005dd4  bl       #0x2429c   ; call _CAFrameRateRangeMake
0x00005dd8  mov      x0, x19
0x00005ddc  bl       #0x27540   ; objc_msgSend: setPreferredFrameRateRange:
0x00005de0  b        #0x5e38   ; call sub_5e38
0x00005de4  adrp     x1, #0x3e000
0x00005de8  add      x1, x1, #0x9c2
0x00005dec  mov      x0, x19
0x00005df0  bl       #0x2477c   ; call _objc_getAssociatedObject
0x00005df4  mov      x29, x29
0x00005df8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005dfc  mov      x22, x0
0x00005e00  bl       #0x25bc0   ; objc_msgSend: integerValue
0x00005e04  mov      x21, x0
0x00005e08  mov      x0, x22
0x00005e0c  bl       #0x2480c   ; call _objc_release
0x00005e10  adrp     x8, #0x3e000
0x00005e14  ldr      w8, [x8, #0x9b0]
0x00005e18  cmp      x21, x8
0x00005e1c  csel     x9, x21, x8, lt
0x00005e20  cmp      x21, #0
0x00005e24  csel     x9, x9, x8, gt
0x00005e28  cmp      w8, #0
0x00005e2c  csel     x2, x9, x21, gt
0x00005e30  mov      x0, x19
0x00005e34  bl       #0x27560   ; objc_msgSend: setPreferredFramesPerSecond:
0x00005e38  strb     wzr, [x23, #0x9c0]
0x00005e3c  mov      x0, x20
0x00005e40  bl       #0x2480c   ; call _objc_release
0x00005e44  mov      x0, x19
0x00005e48  ldp      x29, x30, [sp, #0x50]
0x00005e4c  ldp      x20, x19, [sp, #0x40]
0x00005e50  ldp      x22, x21, [sp, #0x30]
0x00005e54  ldp      x24, x23, [sp, #0x20]
0x00005e58  ldp      d9, d8, [sp, #0x10]
0x00005e5c  ldp      d11, d10, [sp], #0x60
0x00005e60  b        #0x2480c   ; call _objc_release
0x00005e64  b        #0x5e7c   ; call sub_5e7c
0x00005e68  b        #0x5e7c   ; call sub_5e7c
0x00005e6c  b        #0x5ea4   ; call sub_5ea4
0x00005e70  mov      x21, x0
0x00005e74  mov      x0, x22
0x00005e78  b        #0x5e88   ; call sub_5e88
0x00005e7c  mov      x1, x21
0x00005e80  mov      x21, x0
0x00005e84  mov      x0, x1
0x00005e88  bl       #0x2480c   ; call _objc_release
0x00005e8c  b        #0x5ea8   ; call sub_5ea8
0x00005e90  b        #0x5ea4   ; call sub_5ea4
0x00005e94  b        #0x5ea4   ; call sub_5ea4
0x00005e98  b        #0x5ea4   ; call sub_5ea4
0x00005e9c  mov      x21, x0
0x00005ea0  b        #0x5eb0   ; call sub_5eb0
0x00005ea4  mov      x21, x0
0x00005ea8  mov      x0, x20
0x00005eac  bl       #0x2480c   ; call _objc_release
0x00005eb0  mov      x0, x19
0x00005eb4  bl       #0x2480c   ; call _objc_release
0x00005eb8  mov      x0, x21
0x00005ebc  bl       #0x24470   ; call __Unwind_Resume
0x00005ec0  stp      x24, x23, [sp, #-0x40]!
0x00005ec4  stp      x22, x21, [sp, #0x10]
0x00005ec8  stp      x20, x19, [sp, #0x20]
0x00005ecc  stp      x29, x30, [sp, #0x30]
0x00005ed0  add      x29, sp, #0x30
0x00005ed4  mov      x19, x0
0x00005ed8  bl       #0x24818   ; call _objc_retain
0x00005edc  mov      x0, x19
0x00005ee0  bl       #0x269c0   ; objc_msgSend: rootViewController
0x00005ee4  mov      x29, x29
0x00005ee8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005eec  mov      x20, x0
0x00005ef0  cbz      x0, #0x5f80
0x00005ef4  mov      x0, x20
0x00005ef8  bl       #0x26680   ; objc_msgSend: presentedViewController
0x00005efc  mov      x29, x29
0x00005f00  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005f04  mov      x21, x0
0x00005f08  cbz      x0, #0x5f60
0x00005f0c  mov      x0, x20
0x00005f10  bl       #0x26680   ; objc_msgSend: presentedViewController
0x00005f14  mov      x29, x29
0x00005f18  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005f1c  mov      x22, x0
0x00005f20  bl       #0x25c40   ; objc_msgSend: isBeingDismissed
0x00005f24  mov      x23, x0
0x00005f28  mov      x0, x22
0x00005f2c  bl       #0x2480c   ; call _objc_release
0x00005f30  mov      x0, x21
0x00005f34  bl       #0x2480c   ; call _objc_release
0x00005f38  tbnz     w23, #0, #0x5f60
0x00005f3c  mov      x0, x20
0x00005f40  bl       #0x26680   ; objc_msgSend: presentedViewController
0x00005f44  mov      x29, x29
0x00005f48  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00005f4c  mov      x21, x0
0x00005f50  mov      x0, x20
0x00005f54  bl       #0x2480c   ; call _objc_release
0x00005f58  mov      x20, x21
0x00005f5c  b        #0x5ef4   ; call sub_5ef4
0x00005f60  mov      x0, x20
0x00005f64  bl       #0x27e40   ; objc_msgSend: supportedInterfaceOrientations
0x00005f68  cmp      x0, #0
0x00005f6c  mov      w8, #0x1e
0x00005f70  csel     x21, x8, x0, eq
0x00005f74  mov      x0, x20
0x00005f78  bl       #0x2480c   ; call _objc_release
0x00005f7c  b        #0x5f84   ; call sub_5f84
0x00005f80  mov      w21, #0x1e
0x00005f84  mov      x0, x19
0x00005f88  bl       #0x2480c   ; call _objc_release
0x00005f8c  mov      x0, x21
0x00005f90  ldp      x29, x30, [sp, #0x30]
0x00005f94  ldp      x20, x19, [sp, #0x20]
0x00005f98  ldp      x22, x21, [sp, #0x10]
0x00005f9c  ldp      x24, x23, [sp], #0x40
0x00005fa0  ret      
0x00005fa4  b        #0x5fd4   ; call sub_5fd4
0x00005fa8  mov      x22, x0
0x00005fac  b        #0x5fe0   ; call sub_5fe0
0x00005fb0  mov      x1, x22
0x00005fb4  mov      x22, x0
0x00005fb8  mov      x0, x1
0x00005fbc  bl       #0x2480c   ; call _objc_release
0x00005fc0  b        #0x5fc8   ; call sub_5fc8
0x00005fc4  mov      x22, x0
0x00005fc8  mov      x0, x21
0x00005fcc  bl       #0x2480c   ; call _objc_release
0x00005fd0  b        #0x5fd8   ; call sub_5fd8
0x00005fd4  mov      x22, x0
0x00005fd8  mov      x0, x20
0x00005fdc  bl       #0x2480c   ; call _objc_release
0x00005fe0  mov      x0, x19
0x00005fe4  bl       #0x2480c   ; call _objc_release
0x00005fe8  mov      x0, x22
0x00005fec  bl       #0x24470   ; call __Unwind_Resume
0x00005ff0  stp      x29, x30, [sp, #-0x10]!
0x00005ff4  mov      x29, sp
0x00005ff8  adrp     x8, #0x2b000
0x00005ffc  ldr      d1, [x8, #0x1e0]
0x00006000  fmul     d0, d0, d1
0x00006004  fcvtzs   x1, d0
0x00006008  mov      x0, #0
0x0000600c  bl       #0x245cc   ; call _dispatch_time
0x00006010  adrp     x1, #0x34000
0x00006014  ldr      x1, [x1, #0x290]   ; -> [got:__dispatch_main_q]
0x00006018  adrp     x2, #0x34000
0x0000601c  add      x2, x2, #0x630
0x00006020  ldp      x29, x30, [sp], #0x10
0x00006024  b        #0x24548   ; call _dispatch_after

