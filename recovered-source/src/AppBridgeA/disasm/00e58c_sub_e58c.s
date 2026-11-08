; ==== sub_e58c @ 0xe58c..0xe90c (896 bytes) ====
0x0000e58c  mov      x20, x0
0x0000e590  add      x0, x0, #0x20
0x0000e594  bl       #0x247a0   ; call _objc_loadWeakRetained
0x0000e598  mov      x19, x0
0x0000e59c  add      x0, x20, #0x28
0x0000e5a0  bl       #0x247a0   ; call _objc_loadWeakRetained
0x0000e5a4  mov      x20, x0
0x0000e5a8  cbz      x19, #0xe664
0x0000e5ac  cbz      x20, #0xe664
0x0000e5b0  mov      x0, x20
0x0000e5b4  bl       #0x26580   ; objc_msgSend: panes
0x0000e5b8  mov      x29, x29
0x0000e5bc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000e5c0  mov      x21, x0
0x0000e5c4  mov      x2, x19
0x0000e5c8  bl       #0x25360   ; objc_msgSend: containsObject:
0x0000e5cc  mov      x22, x0
0x0000e5d0  mov      x0, x21
0x0000e5d4  bl       #0x2480c   ; call _objc_release
0x0000e5d8  tbz      w22, #0, #0xe664
0x0000e5dc  mov      x0, x19
0x0000e5e0  bl       #0x25020   ; objc_msgSend: bundleID
0x0000e5e4  mov      x29, x29
0x0000e5e8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000e5ec  mov      x21, x0
0x0000e5f0  mov      x0, x19
0x0000e5f4  bl       #0x264c0   ; objc_msgSend: orientation
0x0000e5f8  mov      x1, x0
0x0000e5fc  mov      x0, x21
0x0000e600  bl       #0xe6b8   ; call sub_e6b8
0x0000e604  mov      x0, x21
0x0000e608  bl       #0x2480c   ; call _objc_release
0x0000e60c  mov      x0, x20
0x0000e610  mov      x2, x19
0x0000e614  bl       #0x25f60   ; objc_msgSend: layoutPane:
0x0000e618  mov      x0, x20
0x0000e61c  mov      x2, x19
0x0000e620  bl       #0x269a0   ; objc_msgSend: revealPane:
0x0000e624  mov      x0, x19
0x0000e628  bl       #0x26780   ; objc_msgSend: ready
0x0000e62c  tbnz     w0, #0, #0xe664
0x0000e630  mov      x0, x19
0x0000e634  mov      w2, #1
0x0000e638  bl       #0x275a0   ; objc_msgSend: setReady:
0x0000e63c  mov      x0, x19
0x0000e640  bl       #0x25020   ; objc_msgSend: bundleID
0x0000e644  mov      x29, x29
0x0000e648  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000e64c  mov      x21, x0
0x0000e650  adrp     x1, #0x35000
0x0000e654  add      x1, x1, #0xbb0   ; -> @"ready"
0x0000e658  bl       #0xbed4   ; call sub_bed4
0x0000e65c  mov      x0, x21
0x0000e660  bl       #0x2480c   ; call _objc_release
0x0000e664  mov      x0, x20
0x0000e668  bl       #0x2480c   ; call _objc_release
0x0000e66c  mov      x0, x19
0x0000e670  ldp      x29, x30, [sp, #0x20]
0x0000e674  ldp      x20, x19, [sp, #0x10]
0x0000e678  ldp      x22, x21, [sp], #0x30
0x0000e67c  b        #0x2480c   ; call _objc_release
0x0000e680  b        #0xe688   ; call sub_e688
0x0000e684  b        #0xe688   ; call sub_e688
0x0000e688  mov      x1, x21
0x0000e68c  mov      x21, x0
0x0000e690  mov      x0, x1
0x0000e694  bl       #0x2480c   ; call _objc_release
0x0000e698  b        #0xe6a0   ; call sub_e6a0
0x0000e69c  mov      x21, x0
0x0000e6a0  mov      x0, x20
0x0000e6a4  bl       #0x2480c   ; call _objc_release
0x0000e6a8  mov      x0, x19
0x0000e6ac  bl       #0x2480c   ; call _objc_release
0x0000e6b0  mov      x0, x21
0x0000e6b4  bl       #0x24470   ; call __Unwind_Resume
0x0000e6b8  sub      sp, sp, #0x80
0x0000e6bc  stp      x24, x23, [sp, #0x40]
0x0000e6c0  stp      x22, x21, [sp, #0x50]
0x0000e6c4  stp      x20, x19, [sp, #0x60]
0x0000e6c8  stp      x29, x30, [sp, #0x70]
0x0000e6cc  add      x29, sp, #0x70
0x0000e6d0  mov      x22, x1
0x0000e6d4  mov      x19, x0
0x0000e6d8  adrp     x8, #0x34000
0x0000e6dc  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0000e6e0  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0000e6e4  str      x8, [sp, #0x38]
0x0000e6e8  bl       #0x24818   ; call _objc_retain
0x0000e6ec  cbz      x19, #0xe854
0x0000e6f0  cmp      x22, #1
0x0000e6f4  b.lt     #0xe740
0x0000e6f8  adrp     x0, #0x36000
0x0000e6fc  add      x0, x0, #0xa10   ; -> @"appBridgeFps"
0x0000e700  adrp     x1, #0x39000
0x0000e704  add      x1, x1, #0x5e8
0x0000e708  bl       #0x1d680   ; call _OMCPref
0x0000e70c  mov      x29, x29
0x0000e710  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000e714  mov      x20, x0
0x0000e718  bl       #0x25ba0   ; objc_msgSend: intValue
0x0000e71c  mov      x23, x0
0x0000e720  mov      x0, x20
0x0000e724  bl       #0x2480c   ; call _objc_release
0x0000e728  cmp      w23, #0
0x0000e72c  b.gt     #0xe758
0x0000e730  bl       #0x1d7d4   ; call _OMCLiteActive
0x0000e734  tbz      w0, #0, #0xe748
0x0000e738  mov      w23, #0x1e
0x0000e73c  b        #0xe758   ; call sub_e758
0x0000e740  mov      w23, #0
0x0000e744  b        #0xe758   ; call sub_e758
0x0000e748  bl       #0x1d930   ; call _OMCCarWireless
0x0000e74c  cmp      w0, #1
0x0000e750  mov      w8, #0x1e
0x0000e754  csel     w23, w8, wzr, eq
0x0000e758  adrp     x0, #0x28000
0x0000e75c  add      x0, x0, #0xfc3   ; -> "NSDistributedNotificationCenter"
0x0000e760  bl       #0x24788   ; call _objc_getClass
0x0000e764  bl       #0x254c0   ; objc_msgSend: defaultCenter
0x0000e768  mov      x29, x29
0x0000e76c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000e770  mov      x20, x0
0x0000e774  adrp     x8, #0x34000
0x0000e778  add      x8, x8, #0xf50   ; -> @"orientation"
0x0000e77c  str      x8, [sp, #8]
0x0000e780  adrp     x24, #0x3e000
0x0000e784  ldr      x0, [x24, #0x2a0]   ; -> [class(NSNumber)]
0x0000e788  mov      x2, x22
0x0000e78c  bl       #0x26380   ; objc_msgSend: numberWithLongLong:
0x0000e790  mov      x29, x29
0x0000e794  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000e798  mov      x21, x0
0x0000e79c  bic      x2, x22, x22, asr #63
0x0000e7a0  str      x0, [sp, #0x20]
0x0000e7a4  adrp     x8, #0x35000
0x0000e7a8  add      x8, x8, #0xd0   ; -> @"device"
0x0000e7ac  str      x8, [sp, #0x10]
0x0000e7b0  ldr      x0, [x24, #0x2a0]   ; -> [class(NSNumber)]
0x0000e7b4  bl       #0x26380   ; objc_msgSend: numberWithLongLong:
0x0000e7b8  mov      x29, x29
0x0000e7bc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000e7c0  mov      x22, x0
0x0000e7c4  str      x0, [sp, #0x28]
0x0000e7c8  adrp     x8, #0x34000
0x0000e7cc  add      x8, x8, #0xf70   ; -> @"fps"
0x0000e7d0  str      x8, [sp, #0x18]
0x0000e7d4  ldr      x0, [x24, #0x2a0]   ; -> [class(NSNumber)]
0x0000e7d8  mov      x2, x23
0x0000e7dc  bl       #0x26320   ; objc_msgSend: numberWithInt:
0x0000e7e0  mov      x29, x29
0x0000e7e4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000e7e8  mov      x24, x0
0x0000e7ec  str      x0, [sp, #0x30]
0x0000e7f0  adrp     x8, #0x3e000
0x0000e7f4  ldr      x0, [x8, #0x310]   ; -> [class(NSDictionary)]
0x0000e7f8  add      x2, sp, #0x20
0x0000e7fc  add      x3, sp, #8
0x0000e800  mov      w4, #3
0x0000e804  bl       #0x255c0   ; objc_msgSend: dictionaryWithObjects:forKeys:count:
0x0000e808  mov      x29, x29
0x0000e80c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000e810  mov      x23, x0
0x0000e814  adrp     x2, #0x34000
0x0000e818  add      x2, x2, #0xeb0   ; -> @"com.anlai.omnicar/appbridge.orientation"
0x0000e81c  mov      x0, x20
0x0000e820  mov      x3, x19
0x0000e824  mov      x4, x23
0x0000e828  bl       #0x26620   ; objc_msgSend: postNotificationName:object:userInfo:
0x0000e82c  mov      x0, x23
0x0000e830  bl       #0x2480c   ; call _objc_release
0x0000e834  mov      x0, x24
0x0000e838  bl       #0x2480c   ; call _objc_release
0x0000e83c  mov      x0, x22
0x0000e840  bl       #0x2480c   ; call _objc_release
0x0000e844  mov      x0, x21
0x0000e848  bl       #0x2480c   ; call _objc_release
0x0000e84c  mov      x0, x20
0x0000e850  bl       #0x2480c   ; call _objc_release
0x0000e854  mov      x0, x19
0x0000e858  bl       #0x2480c   ; call _objc_release
0x0000e85c  ldr      x8, [sp, #0x38]
0x0000e860  adrp     x9, #0x34000
0x0000e864  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x0000e868  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0000e86c  cmp      x9, x8
0x0000e870  b.ne     #0xe88c
0x0000e874  ldp      x29, x30, [sp, #0x70]
0x0000e878  ldp      x20, x19, [sp, #0x60]
0x0000e87c  ldp      x22, x21, [sp, #0x50]
0x0000e880  ldp      x24, x23, [sp, #0x40]
0x0000e884  add      sp, sp, #0x80
0x0000e888  ret      
0x0000e88c  bl       #0x24488   ; call ___stack_chk_fail
0x0000e890  mov      x23, x0
0x0000e894  mov      x0, x20
0x0000e898  bl       #0x2480c   ; call _objc_release
0x0000e89c  b        #0xe8f8   ; call sub_e8f8
0x0000e8a0  mov      x1, x23
0x0000e8a4  mov      x23, x0
0x0000e8a8  mov      x0, x1
0x0000e8ac  bl       #0x2480c   ; call _objc_release
0x0000e8b0  b        #0xe8b8   ; call sub_e8b8
0x0000e8b4  mov      x23, x0
0x0000e8b8  mov      x0, x24
0x0000e8bc  bl       #0x2480c   ; call _objc_release
0x0000e8c0  b        #0xe8c8   ; call sub_e8c8
0x0000e8c4  mov      x23, x0
0x0000e8c8  mov      x0, x22
0x0000e8cc  bl       #0x2480c   ; call _objc_release
0x0000e8d0  b        #0xe8d8   ; call sub_e8d8
0x0000e8d4  mov      x23, x0
0x0000e8d8  mov      x0, x21
0x0000e8dc  bl       #0x2480c   ; call _objc_release
0x0000e8e0  b        #0xe8e8   ; call sub_e8e8
0x0000e8e4  mov      x23, x0
0x0000e8e8  mov      x0, x20
0x0000e8ec  bl       #0x2480c   ; call _objc_release
0x0000e8f0  b        #0xe8f8   ; call sub_e8f8
0x0000e8f4  mov      x23, x0
0x0000e8f8  mov      x0, x19
0x0000e8fc  bl       #0x2480c   ; call _objc_release
0x0000e900  b        #0xe908   ; call sub_e908
0x0000e904  mov      x23, x0
0x0000e908  mov      x0, x23
