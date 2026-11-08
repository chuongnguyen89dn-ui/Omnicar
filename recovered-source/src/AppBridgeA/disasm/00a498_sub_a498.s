; ==== sub_a498 @ 0xa498..0xa750 (696 bytes) ====
0x0000a498  add      x0, x19, #0x20
0x0000a49c  mov      x1, #0
0x0000a4a0  bl       #0x24860   ; call _objc_storeStrong
0x0000a4a4  add      x0, x19, #0x18
0x0000a4a8  mov      x1, #0
0x0000a4ac  bl       #0x24860   ; call _objc_storeStrong
0x0000a4b0  add      x0, x19, #0x10
0x0000a4b4  mov      x1, #0
0x0000a4b8  ldp      x29, x30, [sp, #0x10]
0x0000a4bc  ldp      x20, x19, [sp], #0x20
0x0000a4c0  b        #0x24860   ; call _objc_storeStrong
0x0000a4c4  stp      x20, x19, [sp, #-0x20]!
0x0000a4c8  stp      x29, x30, [sp, #0x10]
0x0000a4cc  add      x29, sp, #0x10
0x0000a4d0  adrp     x8, #0x3e000
0x0000a4d4  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x0000a4d8  adrp     x2, #0x35000
0x0000a4dc  add      x2, x2, #0x9b0   ; -> @"cham ngoai thanh nut (lop chan) -> an thanh nut"
0x0000a4e0  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000a4e4  mov      x29, x29
0x0000a4e8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000a4ec  mov      x19, x0
0x0000a4f0  adrp     x0, #0x34000
0x0000a4f4  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000a4f8  mov      x1, x19
0x0000a4fc  bl       #0x1dd30   ; call _OMCLogWrite
0x0000a500  mov      x0, x19
0x0000a504  bl       #0x2480c   ; call _objc_release
0x0000a508  adrp     x0, #0x28000
0x0000a50c  add      x0, x0, #0xfc3   ; -> "NSDistributedNotificationCenter"
0x0000a510  bl       #0x24788   ; call _objc_getClass
0x0000a514  bl       #0x254c0   ; objc_msgSend: defaultCenter
0x0000a518  mov      x29, x29
0x0000a51c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000a520  mov      x19, x0
0x0000a524  adrp     x2, #0x35000
0x0000a528  add      x2, x2, #0x9d0   ; -> @"com.anlai.omnicar/appbridge.bardismiss"
0x0000a52c  adrp     x4, #0x34000
0x0000a530  ldr      x4, [x4, #0x1f8]   ; -> [got:___NSDictionary0__struct]
0x0000a534  mov      x3, #0
0x0000a538  bl       #0x26620   ; objc_msgSend: postNotificationName:object:userInfo:
0x0000a53c  mov      x0, x19
0x0000a540  bl       #0x2480c   ; call _objc_release
0x0000a544  adrp     x8, #0x3e000
0x0000a548  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x0000a54c  bl       #0x27b20   ; objc_msgSend: shared
0x0000a550  mov      x29, x29
0x0000a554  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000a558  mov      x19, x0
0x0000a55c  bl       #0x264e0   ; objc_msgSend: outsideTouched
0x0000a560  mov      x0, x19
0x0000a564  ldp      x29, x30, [sp, #0x10]
0x0000a568  ldp      x20, x19, [sp], #0x20
0x0000a56c  b        #0x2480c   ; call _objc_release
0x0000a570  b        #0xa578   ; call sub_a578
0x0000a574  b        #0xa578   ; call sub_a578
0x0000a578  mov      x20, x0
0x0000a57c  mov      x0, x19
0x0000a580  bl       #0x2480c   ; call _objc_release
0x0000a584  mov      x0, x20
0x0000a588  bl       #0x24470   ; call __Unwind_Resume
0x0000a58c  sub      sp, sp, #0xd0
0x0000a590  stp      d11, d10, [sp, #0x60]
0x0000a594  stp      d9, d8, [sp, #0x70]
0x0000a598  stp      x26, x25, [sp, #0x80]
0x0000a59c  stp      x24, x23, [sp, #0x90]
0x0000a5a0  stp      x22, x21, [sp, #0xa0]
0x0000a5a4  stp      x20, x19, [sp, #0xb0]
0x0000a5a8  stp      x29, x30, [sp, #0xc0]
0x0000a5ac  add      x29, sp, #0xc0
0x0000a5b0  mov      x19, x3
0x0000a5b4  mov      x21, x2
0x0000a5b8  mov      x22, x0
0x0000a5bc  adrp     x8, #0x34000
0x0000a5c0  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0000a5c4  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0000a5c8  str      x8, [sp, #0x58]
0x0000a5cc  mov      x0, x3
0x0000a5d0  bl       #0x24818   ; call _objc_retain
0x0000a5d4  mov      x0, x19
0x0000a5d8  bl       #0x24cc0   ; objc_msgSend: anyObject
0x0000a5dc  mov      x29, x29
0x0000a5e0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000a5e4  mov      x20, x0
0x0000a5e8  mov      x0, x22
0x0000a5ec  bl       #0x281e0   ; objc_msgSend: window
0x0000a5f0  mov      x29, x29
0x0000a5f4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000a5f8  mov      x23, x0
0x0000a5fc  mov      x0, x20
0x0000a600  mov      x2, x23
0x0000a604  bl       #0x26020   ; objc_msgSend: locationInView:
0x0000a608  mov      v9.16b, v0.16b
0x0000a60c  mov      v8.16b, v1.16b
0x0000a610  mov      x0, x23
0x0000a614  bl       #0x2480c   ; call _objc_release
0x0000a618  mov      x0, x20
0x0000a61c  bl       #0x2480c   ; call _objc_release
0x0000a620  cmp      w21, #1
0x0000a624  b.ne     #0xa654
0x0000a628  mov      x0, x22
0x0000a62c  bl       #0x25ee0   ; objc_msgSend: lastSent
0x0000a630  mov      v10.16b, v0.16b
0x0000a634  mov      x0, x22
0x0000a638  bl       #0x25ee0   ; objc_msgSend: lastSent
0x0000a63c  fsub     d0, d9, d10
0x0000a640  fsub     d1, d8, d1
0x0000a644  bl       #0x24674   ; call _hypot
0x0000a648  fmov     d1, #1.00000000
0x0000a64c  fcmp     d0, d1
0x0000a650  b.mi     #0xa814
0x0000a654  mov      x0, x22
0x0000a658  mov      v0.16b, v9.16b
0x0000a65c  mov      v1.16b, v8.16b
0x0000a660  bl       #0x27240   ; objc_msgSend: setLastSent:
0x0000a664  cmp      w21, #1
0x0000a668  b.eq     #0xa6dc
0x0000a66c  adrp     x8, #0x3e000
0x0000a670  ldr      x23, [x8, #0x290]   ; -> [class(NSString)]
0x0000a674  mov      x0, x22
0x0000a678  bl       #0x259c0   ; objc_msgSend: index
0x0000a67c  mov      x24, x0
0x0000a680  mov      v0.16b, v9.16b
0x0000a684  mov      v1.16b, v8.16b
0x0000a688  bl       #0x24434   ; call _NSStringFromCGPoint
0x0000a68c  mov      x29, x29
0x0000a690  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000a694  mov      x20, x0
0x0000a698  stp      x21, x0, [sp, #8]
0x0000a69c  str      x24, [sp]
0x0000a6a0  adrp     x2, #0x35000
0x0000a6a4  add      x2, x2, #0x9f0   ; -> @"cham tron vach %d: pha %d tai %@"
0x0000a6a8  mov      x0, x23
0x0000a6ac  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000a6b0  mov      x29, x29
0x0000a6b4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000a6b8  mov      x23, x0
0x0000a6bc  adrp     x0, #0x34000
0x0000a6c0  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000a6c4  mov      x1, x23
0x0000a6c8  bl       #0x1dd30   ; call _OMCLogWrite
0x0000a6cc  mov      x0, x23
0x0000a6d0  bl       #0x2480c   ; call _objc_release
0x0000a6d4  mov      x0, x20
0x0000a6d8  bl       #0x2480c   ; call _objc_release
0x0000a6dc  adrp     x0, #0x28000
0x0000a6e0  add      x0, x0, #0xfc3   ; -> "NSDistributedNotificationCenter"
0x0000a6e4  bl       #0x24788   ; call _objc_getClass
0x0000a6e8  bl       #0x254c0   ; objc_msgSend: defaultCenter
0x0000a6ec  mov      x29, x29
0x0000a6f0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000a6f4  mov      x20, x0
0x0000a6f8  adrp     x8, #0x35000
0x0000a6fc  add      x8, x8, #0xa30   ; -> @"index"
0x0000a700  str      x8, [sp, #0x18]
0x0000a704  adrp     x25, #0x3e000
0x0000a708  ldr      x23, [x25, #0x2a0]   ; -> [class(NSNumber)]
0x0000a70c  mov      x0, x22
0x0000a710  bl       #0x259c0   ; objc_msgSend: index
0x0000a714  mov      x2, x0
0x0000a718  mov      x0, x23
0x0000a71c  bl       #0x26320   ; objc_msgSend: numberWithInt:
0x0000a720  mov      x29, x29
0x0000a724  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000a728  mov      x22, x0
0x0000a72c  str      x0, [sp, #0x38]
0x0000a730  adrp     x8, #0x35000
0x0000a734  add      x8, x8, #0xa50   ; -> @"phase"
0x0000a738  str      x8, [sp, #0x20]
0x0000a73c  ldr      x0, [x25, #0x2a0]   ; -> [class(NSNumber)]
0x0000a740  mov      x2, x21
0x0000a744  bl       #0x26320   ; objc_msgSend: numberWithInt:
0x0000a748  mov      x29, x29
0x0000a74c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
