; ==== sub_1ebb0 @ 0x1ebb0..0x1f408 (2136 bytes) ====
0x0001ebb0  mov      x0, x19
0x0001ebb4  bl       #0x2480c   ; call _objc_release
0x0001ebb8  b        #0x1ebf4   ; call sub_1ebf4
0x0001ebbc  ldr      x20, [sp, #0x38]
0x0001ebc0  mov      x0, x20
0x0001ebc4  bl       #0x25420   ; objc_msgSend: count
0x0001ebc8  stp      x23, x0, [sp]
0x0001ebcc  adrp     x2, #0x37000
0x0001ebd0  add      x2, x2, #0xc50   ; -> @"iOS %@: du %lu hook"
0x0001ebd4  mov      x0, x19
0x0001ebd8  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0001ebdc  mov      x29, x29
0x0001ebe0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ebe4  mov      x26, x0
0x0001ebe8  mov      x0, x27
0x0001ebec  mov      x1, x26
0x0001ebf0  bl       #0x1dd30   ; call _OMCLogWrite
0x0001ebf4  mov      x0, x26
0x0001ebf8  bl       #0x2480c   ; call _objc_release
0x0001ebfc  mov      x0, x25
0x0001ec00  bl       #0x2480c   ; call _objc_release
0x0001ec04  mov      x0, x24
0x0001ec08  bl       #0x2480c   ; call _objc_release
0x0001ec0c  mov      x0, x23
0x0001ec10  bl       #0x2480c   ; call _objc_release
0x0001ec14  ldr      x0, [sp, #0x28]
0x0001ec18  bl       #0x2480c   ; call _objc_release
0x0001ec1c  mov      x0, x28
0x0001ec20  bl       #0x2480c   ; call _objc_release
0x0001ec24  mov      x0, x20
0x0001ec28  bl       #0x2480c   ; call _objc_release
0x0001ec2c  mov      x0, x27
0x0001ec30  bl       #0x2480c   ; call _objc_release
0x0001ec34  ldur     x8, [x29, #-0x60]
0x0001ec38  adrp     x9, #0x34000
0x0001ec3c  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x0001ec40  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0001ec44  cmp      x9, x8
0x0001ec48  b.ne     #0x1ec6c
0x0001ec4c  ldp      x29, x30, [sp, #0x180]
0x0001ec50  ldp      x20, x19, [sp, #0x170]
0x0001ec54  ldp      x22, x21, [sp, #0x160]
0x0001ec58  ldp      x24, x23, [sp, #0x150]
0x0001ec5c  ldp      x26, x25, [sp, #0x140]
0x0001ec60  ldp      x28, x27, [sp, #0x130]
0x0001ec64  add      sp, sp, #0x190
0x0001ec68  ret      
0x0001ec6c  bl       #0x24488   ; call ___stack_chk_fail
0x0001ec70  sub      sp, sp, #0x60
0x0001ec74  stp      x26, x25, [sp, #0x10]
0x0001ec78  stp      x24, x23, [sp, #0x20]
0x0001ec7c  stp      x22, x21, [sp, #0x30]
0x0001ec80  stp      x20, x19, [sp, #0x40]
0x0001ec84  stp      x29, x30, [sp, #0x50]
0x0001ec88  add      x29, sp, #0x50
0x0001ec8c  mov      x21, x2
0x0001ec90  mov      x20, x1
0x0001ec94  mov      x19, x0
0x0001ec98  bl       #0x24818   ; call _objc_retain
0x0001ec9c  mov      x0, x20
0x0001eca0  bl       #0x24818   ; call _objc_retain
0x0001eca4  mov      x0, x21
0x0001eca8  bl       #0x24818   ; call _objc_retain
0x0001ecac  cbz      x20, #0x1edd0
0x0001ecb0  adrp     x8, #0x3e000
0x0001ecb4  ldr      x8, [x8, #0xac0]
0x0001ecb8  cmn      x8, #1
0x0001ecbc  b.ne     #0x1ee00
0x0001ecc0  adrp     x24, #0x3e000
0x0001ecc4  ldr      x22, [x24, #0x290]   ; -> [class(NSString)]
0x0001ecc8  mov      x0, x20
0x0001eccc  bl       #0x247d0   ; call _objc_opt_class
0x0001ecd0  bl       #0x2444c   ; call _NSStringFromClass
0x0001ecd4  mov      x29, x29
0x0001ecd8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ecdc  mov      x23, x0
0x0001ece0  stp      x0, x21, [sp]
0x0001ece4  adrp     x2, #0x35000
0x0001ece8  add      x2, x2, #0x970   ; -> @"%@ %@"
0x0001ecec  mov      x0, x22
0x0001ecf0  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0001ecf4  mov      x29, x29
0x0001ecf8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ecfc  mov      x22, x0
0x0001ed00  mov      x0, x23
0x0001ed04  bl       #0x2480c   ; call _objc_release
0x0001ed08  adrp     x25, #0x3e000
0x0001ed0c  ldr      x23, [x25, #0xab8]
0x0001ed10  mov      x0, x23
0x0001ed14  bl       #0x24818   ; call _objc_retain
0x0001ed18  mov      x0, x23
0x0001ed1c  bl       #0x24878   ; call _objc_sync_enter
0x0001ed20  ldr      x0, [x25, #0xab8]
0x0001ed24  mov      x2, x22
0x0001ed28  bl       #0x25360   ; objc_msgSend: containsObject:
0x0001ed2c  tbz      w0, #0, #0x1ed3c
0x0001ed30  mov      x0, x23
0x0001ed34  bl       #0x24884   ; call _objc_sync_exit
0x0001ed38  b        #0x1edc0   ; call sub_1edc0
0x0001ed3c  ldr      x0, [x25, #0xab8]
0x0001ed40  mov      x2, x22
0x0001ed44  bl       #0x24b20   ; objc_msgSend: addObject:
0x0001ed48  mov      x0, x23
0x0001ed4c  bl       #0x24884   ; call _objc_sync_exit
0x0001ed50  mov      x0, x23
0x0001ed54  bl       #0x2480c   ; call _objc_release
0x0001ed58  ldr      x24, [x24, #0x290]   ; -> [class(NSString)]
0x0001ed5c  adrp     x8, #0x3e000
0x0001ed60  ldr      x0, [x8, #0x2b8]   ; -> [class(UIDevice)]
0x0001ed64  bl       #0x25460   ; objc_msgSend: currentDevice
0x0001ed68  mov      x29, x29
0x0001ed6c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ed70  mov      x23, x0
0x0001ed74  bl       #0x27ec0   ; objc_msgSend: systemVersion
0x0001ed78  mov      x29, x29
0x0001ed7c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ed80  mov      x25, x0
0x0001ed84  stp      x0, x22, [sp]
0x0001ed88  adrp     x2, #0x37000
0x0001ed8c  add      x2, x2, #0xc70   ; -> @"THIEU METHOD (iOS %@): %@ -> bo qua"
0x0001ed90  mov      x0, x24
0x0001ed94  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0001ed98  mov      x29, x29
0x0001ed9c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001eda0  mov      x24, x0
0x0001eda4  mov      x0, x19
0x0001eda8  mov      x1, x24
0x0001edac  bl       #0x1dd30   ; call _OMCLogWrite
0x0001edb0  mov      x0, x24
0x0001edb4  bl       #0x2480c   ; call _objc_release
0x0001edb8  mov      x0, x25
0x0001edbc  bl       #0x2480c   ; call _objc_release
0x0001edc0  mov      x0, x23
0x0001edc4  bl       #0x2480c   ; call _objc_release
0x0001edc8  mov      x0, x22
0x0001edcc  bl       #0x2480c   ; call _objc_release
0x0001edd0  mov      x0, x21
0x0001edd4  bl       #0x2480c   ; call _objc_release
0x0001edd8  mov      x0, x20
0x0001eddc  bl       #0x2480c   ; call _objc_release
0x0001ede0  mov      x0, x19
0x0001ede4  ldp      x29, x30, [sp, #0x50]
0x0001ede8  ldp      x20, x19, [sp, #0x40]
0x0001edec  ldp      x22, x21, [sp, #0x30]
0x0001edf0  ldp      x24, x23, [sp, #0x20]
0x0001edf4  ldp      x26, x25, [sp, #0x10]
0x0001edf8  add      sp, sp, #0x60
0x0001edfc  b        #0x2480c   ; call _objc_release
0x0001ee00  bl       #0x2424c   ; call sub_2424c
0x0001ee04  b        #0x1ecc0   ; call sub_1ecc0
0x0001ee08  mov      x19, x0
0x0001ee0c  mov      x0, x23
0x0001ee10  bl       #0x24884   ; call _objc_sync_exit
0x0001ee14  mov      x0, x19
0x0001ee18  bl       #0x24470   ; call __Unwind_Resume
0x0001ee1c  stp      x29, x30, [sp, #-0x10]!
0x0001ee20  mov      x29, sp
0x0001ee24  adrp     x8, #0x3e000
0x0001ee28  ldr      x0, [x8, #0x2f0]   ; -> [class(NSMutableSet)]
0x0001ee2c  bl       #0x26ac0   ; objc_msgSend: set
0x0001ee30  mov      x29, x29
0x0001ee34  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ee38  adrp     x9, #0x3e000
0x0001ee3c  ldr      x8, [x9, #0xab8]
0x0001ee40  str      x0, [x9, #0xab8]
0x0001ee44  mov      x0, x8
0x0001ee48  ldp      x29, x30, [sp], #0x10
0x0001ee4c  b        #0x2480c   ; call _objc_release
0x0001ee50  sub      sp, sp, #0x40
0x0001ee54  stp      x22, x21, [sp, #0x10]
0x0001ee58  stp      x20, x19, [sp, #0x20]
0x0001ee5c  stp      x29, x30, [sp, #0x30]
0x0001ee60  add      x29, sp, #0x30
0x0001ee64  mov      x19, x0
0x0001ee68  bl       #0x24818   ; call _objc_retain
0x0001ee6c  cbz      x19, #0x1ef3c
0x0001ee70  adrp     x0, #0x2a000
0x0001ee74  add      x0, x0, #0x860   ; -> "DBApplicationLaunchInfo"
0x0001ee78  bl       #0x1e438   ; call _OMCCarClass
0x0001ee7c  mov      x20, x0
0x0001ee80  adrp     x0, #0x37000
0x0001ee84  add      x0, x0, #0xd10   ; -> @"launchInfoForApplication:"
0x0001ee88  bl       #0x2441c   ; call _NSSelectorFromString
0x0001ee8c  mov      x22, x0
0x0001ee90  adrp     x0, #0x37000
0x0001ee94  add      x0, x0, #0xd30   ; -> @"launchInfoForApplication:withActivationSettings:"
0x0001ee98  bl       #0x2441c   ; call _NSSelectorFromString
0x0001ee9c  mov      x21, x0
0x0001eea0  mov      x0, x20
0x0001eea4  mov      x1, x22
0x0001eea8  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0001eeac  tbz      w0, #0, #0x1eecc
0x0001eeb0  mov      x0, x20
0x0001eeb4  mov      x1, x22
0x0001eeb8  mov      x2, x19
0x0001eebc  bl       #0x247ac   ; call _objc_msgSend
0x0001eec0  mov      x29, x29
0x0001eec4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001eec8  b        #0x1eef8   ; call sub_1eef8
0x0001eecc  mov      x0, x20
0x0001eed0  mov      x1, x21
0x0001eed4  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0001eed8  tbz      w0, #0, #0x1ef00
0x0001eedc  mov      x0, x20
0x0001eee0  mov      x1, x21
0x0001eee4  mov      x2, x19
0x0001eee8  mov      x3, #0
0x0001eeec  bl       #0x247ac   ; call _objc_msgSend
0x0001eef0  mov      x29, x29
0x0001eef4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001eef8  mov      x20, x0
0x0001eefc  b        #0x1ef40   ; call sub_1ef40
0x0001ef00  adrp     x8, #0x3e000
0x0001ef04  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x0001ef08  str      x20, [sp]
0x0001ef0c  adrp     x2, #0x37000
0x0001ef10  add      x2, x2, #0xd70   ; -> @"THIEU METHOD: %@ khong tao duoc launchInfo"
0x0001ef14  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0001ef18  mov      x29, x29
0x0001ef1c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ef20  mov      x20, x0
0x0001ef24  adrp     x0, #0x37000
0x0001ef28  add      x0, x0, #0xd50   ; -> @"Core"
0x0001ef2c  mov      x1, x20
0x0001ef30  bl       #0x1dd30   ; call _OMCLogWrite
0x0001ef34  mov      x0, x20
0x0001ef38  bl       #0x2480c   ; call _objc_release
0x0001ef3c  mov      x20, #0
0x0001ef40  mov      x0, x19
0x0001ef44  bl       #0x2480c   ; call _objc_release
0x0001ef48  mov      x0, x20
0x0001ef4c  ldp      x29, x30, [sp, #0x30]
0x0001ef50  ldp      x20, x19, [sp, #0x20]
0x0001ef54  ldp      x22, x21, [sp, #0x10]
0x0001ef58  add      sp, sp, #0x40
0x0001ef5c  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x0001ef60  stp      x28, x27, [sp, #-0x60]!
0x0001ef64  stp      x26, x25, [sp, #0x10]
0x0001ef68  stp      x24, x23, [sp, #0x20]
0x0001ef6c  stp      x22, x21, [sp, #0x30]
0x0001ef70  stp      x20, x19, [sp, #0x40]
0x0001ef74  stp      x29, x30, [sp, #0x50]
0x0001ef78  add      x29, sp, #0x50
0x0001ef7c  sub      sp, sp, #0x480
0x0001ef80  mov      x26, x0
0x0001ef84  adrp     x8, #0x34000
0x0001ef88  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0001ef8c  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0001ef90  stur     x8, [x29, #-0x60]
0x0001ef94  bl       #0x24818   ; call _objc_retain
0x0001ef98  adrp     x8, #0x3e000
0x0001ef9c  ldr      x8, [x8, #0xb28]
0x0001efa0  cmn      x8, #1
0x0001efa4  b.ne     #0x200e8
0x0001efa8  adrp     x8, #0x3e000
0x0001efac  ldrb     w8, [x8, #0xb20]
0x0001efb0  cmp      w8, #1
0x0001efb4  b.ne     #0x1f0c0
0x0001efb8  mov      x0, x26
0x0001efbc  bl       #0x25fa0   ; objc_msgSend: length
0x0001efc0  cbz      x0, #0x1f0c0
0x0001efc4  bl       #0x200f4   ; call sub_200f4
0x0001efc8  adrp     x20, #0x3e000
0x0001efcc  adrp     x22, #0x3e000
0x0001efd0  cbnz     x0, #0x1fd94
0x0001efd4  mov      w0, #1
0x0001efd8  mov      w1, #0x448
0x0001efdc  bl       #0x244e8   ; call _calloc
0x0001efe0  adrp     x22, #0x3e000
0x0001efe4  str      x0, [x22, #0xb30]
0x0001efe8  mov      x0, #0
0x0001efec  bl       #0x249b0   ; call _time
0x0001eff0  ldr      x8, [x22, #0xb30]
0x0001eff4  str      x0, [x8, #0x440]
0x0001eff8  str      x8, [sp]
0x0001effc  adrp     x2, #0x2a000
0x0001f000  add      x2, x2, #0x9f5   ; -> "%llx"
0x0001f004  add      x0, sp, #0x2d0
0x0001f008  mov      w1, #0x20
0x0001f00c  bl       #0x24920   ; call _snprintf
0x0001f010  adrp     x0, #0x2a000
0x0001f014  add      x0, x0, #0x9e6   ; -> "OMC_CRASHGUARD"
0x0001f018  add      x1, sp, #0x2d0
0x0001f01c  mov      w2, #1
0x0001f020  bl       #0x248fc   ; call _setenv
0x0001f024  bl       #0x24464   ; call _NSTemporaryDirectory
0x0001f028  mov      x29, x29
0x0001f02c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f030  mov      x19, x0
0x0001f034  adrp     x2, #0x37000
0x0001f038  add      x2, x2, #0xfb0   ; -> @"OmniCar-CarPlay-crash.txt"
0x0001f03c  bl       #0x27c60   ; objc_msgSend: stringByAppendingPathComponent:
0x0001f040  mov      x29, x29
0x0001f044  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f048  mov      x21, x0
0x0001f04c  mov      x0, x19
0x0001f050  bl       #0x2480c   ; call _objc_release
0x0001f054  ldr      x19, [x22, #0xb30]
0x0001f058  mov      x0, x21
0x0001f05c  bl       #0x24824   ; call _objc_retainAutorelease
0x0001f060  str      x21, [sp, #0x48]
0x0001f064  bl       #0x25740   ; objc_msgSend: fileSystemRepresentation
0x0001f068  mov      x1, x0
0x0001f06c  mov      x0, x19
0x0001f070  mov      w2, #0x400
0x0001f074  mov      w3, #0x400
0x0001f078  bl       #0x24494   ; call ___strlcpy_chk
0x0001f07c  mov      x21, x20
0x0001f080  ldr      x20, [x20, #0x398]   ; -> [class(NSMutableDictionary)]
0x0001f084  bl       #0x20138   ; call sub_20138
0x0001f088  mov      x29, x29
0x0001f08c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f090  mov      x19, x0
0x0001f094  mov      x0, x20
0x0001f098  mov      x2, x19
0x0001f09c  bl       #0x255a0   ; objc_msgSend: dictionaryWithContentsOfFile:
0x0001f0a0  mov      x29, x29
0x0001f0a4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f0a8  mov      x20, x0
0x0001f0ac  cbz      x0, #0x1f0c8
0x0001f0b0  mov      x0, x20
0x0001f0b4  bl       #0x24818   ; call _objc_retain
0x0001f0b8  mov      x21, x20
0x0001f0bc  b        #0x1f0dc   ; call sub_1f0dc
0x0001f0c0  mov      w22, #1
0x0001f0c4  b        #0x20024   ; call sub_20024
0x0001f0c8  ldr      x0, [x21, #0x398]
0x0001f0cc  bl       #0x25580   ; objc_msgSend: dictionary
0x0001f0d0  mov      x29, x29
0x0001f0d4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f0d8  mov      x21, x0
0x0001f0dc  mov      x0, x20
0x0001f0e0  bl       #0x2480c   ; call _objc_release
0x0001f0e4  mov      x0, x19
0x0001f0e8  bl       #0x2480c   ; call _objc_release
0x0001f0ec  adrp     x2, #0x37000
0x0001f0f0  add      x2, x2, #0xfd0   ; -> @"early"
0x0001f0f4  mov      x0, x21
0x0001f0f8  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0001f0fc  mov      x29, x29
0x0001f100  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f104  mov      x19, x0
0x0001f108  bl       #0x25bc0   ; objc_msgSend: integerValue
0x0001f10c  str      x0, [sp, #0x20]
0x0001f110  mov      x0, x19
0x0001f114  bl       #0x2480c   ; call _objc_release
0x0001f118  adrp     x8, #0x3e000
0x0001f11c  ldr      x19, [x8, #0x318]   ; -> [class(NSMutableArray)]
0x0001f120  adrp     x2, #0x37000
0x0001f124  add      x2, x2, #0xff0   ; -> @"suspects"
0x0001f128  mov      x0, x21
0x0001f12c  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0001f130  mov      x29, x29
0x0001f134  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f138  mov      x20, x0
0x0001f13c  cmp      x0, #0
0x0001f140  adrp     x8, #0x34000
0x0001f144  ldr      x8, [x8, #0x1f0]   ; -> [got:___NSArray0__struct]
0x0001f148  csel     x2, x8, x0, eq
0x0001f14c  mov      x0, x19
0x0001f150  bl       #0x24e00   ; objc_msgSend: arrayWithArray:
0x0001f154  mov      x29, x29
0x0001f158  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f15c  mov      x27, x0
0x0001f160  mov      x0, x20
0x0001f164  bl       #0x2480c   ; call _objc_release
0x0001f168  adrp     x19, #0x3e000
0x0001f16c  ldr      x0, [x19, #0x290]   ; -> [class(NSString)]
0x0001f170  ldr      x2, [sp, #0x48]
0x0001f174  mov      w3, #4
0x0001f178  mov      x4, #0
0x0001f17c  bl       #0x27d00   ; objc_msgSend: stringWithContentsOfFile:encoding:error:
0x0001f180  mov      x29, x29
0x0001f184  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f188  str      x0, [sp, #0x40]
0x0001f18c  bl       #0x25fa0   ; objc_msgSend: length
0x0001f190  adrp     x20, #0x3e000
0x0001f194  str      x21, [sp, #0x38]
0x0001f198  cbz      x0, #0x1fbbc
0x0001f19c  ldr      x0, [x19, #0x290]   ; -> [class(NSString)]
0x0001f1a0  ldr      x8, [sp, #0x40]
0x0001f1a4  str      x8, [sp]
0x0001f1a8  adrp     x2, #0x38000
0x0001f1ac  add      x2, x2, #0x10   ; -> @"CARPLAY SAP LAN TRUOC:
%@"
0x0001f1b0  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0001f1b4  mov      x29, x29
0x0001f1b8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f1bc  mov      x19, x0
0x0001f1c0  adrp     x0, #0x37000
0x0001f1c4  add      x0, x0, #0xd50   ; -> @"Core"
0x0001f1c8  mov      x1, x19
0x0001f1cc  bl       #0x1dd30   ; call _OMCLogWrite
0x0001f1d0  mov      x0, x19
0x0001f1d4  bl       #0x2480c   ; call _objc_release
0x0001f1d8  adrp     x8, #0x3e000
0x0001f1dc  ldr      x0, [x8, #0x428]   ; -> [class(NSFileManager)]
0x0001f1e0  bl       #0x254e0   ; objc_msgSend: defaultManager
0x0001f1e4  mov      x29, x29
0x0001f1e8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f1ec  mov      x19, x0
0x0001f1f0  ldr      x2, [sp, #0x48]
0x0001f1f4  mov      x3, #0
0x0001f1f8  bl       #0x24e40   ; objc_msgSend: attributesOfItemAtPath:error:
0x0001f1fc  mov      x29, x29
0x0001f200  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f204  mov      x20, x0
0x0001f208  bl       #0x25700   ; objc_msgSend: fileModificationDate
0x0001f20c  mov      x29, x29
0x0001f210  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f214  mov      x21, x0
0x0001f218  cbz      x0, #0x1f22c
0x0001f21c  mov      x0, x21
0x0001f220  bl       #0x24818   ; call _objc_retain
0x0001f224  str      x21, [sp, #0x28]
0x0001f228  b        #0x1f244   ; call sub_1f244
0x0001f22c  adrp     x8, #0x3e000
0x0001f230  ldr      x0, [x8, #0x418]   ; -> [class(NSDate)]
0x0001f234  bl       #0x25480   ; objc_msgSend: date
0x0001f238  mov      x29, x29
0x0001f23c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f240  str      x0, [sp, #0x28]
0x0001f244  str      x27, [sp, #0x50]
0x0001f248  str      x26, [sp, #0x30]
0x0001f24c  mov      x0, x21
0x0001f250  bl       #0x2480c   ; call _objc_release
0x0001f254  mov      x0, x20
0x0001f258  bl       #0x2480c   ; call _objc_release
0x0001f25c  mov      x0, x19
0x0001f260  bl       #0x2480c   ; call _objc_release
0x0001f264  ldr      x0, [x22, #0xb30]
0x0001f268  bl       #0x249bc   ; call _unlink
0x0001f26c  movi     v0.16b, #0
0x0001f270  stp      q0, q0, [sp, #0xc0]
0x0001f274  stp      q0, q0, [sp, #0xe0]
0x0001f278  adrp     x2, #0x35000
0x0001f27c  add      x2, x2, #0x210   ; -> @"
"
0x0001f280  ldr      x0, [sp, #0x40]
0x0001f284  bl       #0x252e0   ; objc_msgSend: componentsSeparatedByString:
0x0001f288  mov      x29, x29
0x0001f28c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f290  add      x2, sp, #0xc0
0x0001f294  add      x3, sp, #0x250
0x0001f298  str      x0, [sp, #0x68]
0x0001f29c  mov      w4, #0x10
0x0001f2a0  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001f2a4  cbz      x0, #0x1f4b8
0x0001f2a8  mov      x23, x0
0x0001f2ac  mov      x26, #0
0x0001f2b0  str      xzr, [sp, #0x78]
0x0001f2b4  ldr      x8, [sp, #0xd0]
0x0001f2b8  mov      x27, #0x7fffffffffffffff
0x0001f2bc  ldr      x22, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x0001f2c0  adrp     x24, #0x38000
0x0001f2c4  add      x24, x24, #0x30   ; -> @"omc-crash "
0x0001f2c8  adrp     x21, #0x38000
0x0001f2cc  add      x21, x21, #0x50   ; -> @"age="
0x0001f2d0  adrp     x19, #0x38000
0x0001f2d4  add      x19, x19, #0x70   ; -> @"suspect="
0x0001f2d8  str      x22, [sp, #0x58]
0x0001f2dc  mov      x25, #0
0x0001f2e0  str      x23, [sp, #0x60]
0x0001f2e4  ldr      x8, [sp, #0xd0]
0x0001f2e8  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x0001f2ec  cmp      x8, x22
0x0001f2f0  b.eq     #0x1f2fc
0x0001f2f4  ldr      x0, [sp, #0x68]
0x0001f2f8  bl       #0x24770   ; call _objc_enumerationMutation
0x0001f2fc  ldr      x8, [sp, #0xc8]
0x0001f300  ldr      x20, [x8, x25, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x0001f304  mov      x0, x20
0x0001f308  mov      x2, x24
0x0001f30c  bl       #0x258a0   ; objc_msgSend: hasPrefix:
0x0001f310  cbz      w0, #0x1f48c
0x0001f314  str      x25, [sp, #0x70]
0x0001f318  movi     v0.16b, #0
0x0001f31c  stp      q0, q0, [sp, #0xa0]
0x0001f320  stp      q0, q0, [sp, #0x80]
0x0001f324  mov      x0, x20
0x0001f328  adrp     x2, #0x36000
0x0001f32c  add      x2, x2, #0xfd0   ; -> @" "
0x0001f330  bl       #0x252e0   ; objc_msgSend: componentsSeparatedByString:
0x0001f334  mov      x29, x29
0x0001f338  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f33c  mov      x20, x0
0x0001f340  add      x2, sp, #0x80
0x0001f344  add      x3, sp, #0x1d0
0x0001f348  mov      w4, #0x10
0x0001f34c  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001f350  cbz      x0, #0x1f474
0x0001f354  mov      x24, x0
0x0001f358  ldr      x8, [sp, #0x90]
0x0001f35c  ldr      x28, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x0001f360  mov      x22, #0
0x0001f364  ldr      x8, [sp, #0x90]
0x0001f368  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x0001f36c  cmp      x8, x28
0x0001f370  b.eq     #0x1f37c
0x0001f374  mov      x0, x20
0x0001f378  bl       #0x24770   ; call _objc_enumerationMutation
0x0001f37c  ldr      x8, [sp, #0x88]
0x0001f380  ldr      x25, [x8, x22, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x0001f384  mov      x0, x25
0x0001f388  mov      x2, x21
0x0001f38c  bl       #0x258a0   ; objc_msgSend: hasPrefix:
0x0001f390  cbz      w0, #0x1f3c8
0x0001f394  mov      x0, x25
0x0001f398  mov      w2, #4
0x0001f39c  bl       #0x27da0   ; objc_msgSend: substringFromIndex:
0x0001f3a0  mov      x29, x29
0x0001f3a4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f3a8  mov      x25, x0
0x0001f3ac  bl       #0x25bc0   ; objc_msgSend: integerValue
0x0001f3b0  mov      x23, x0
0x0001f3b4  mov      x0, x25
0x0001f3b8  bl       #0x2480c   ; call _objc_release
0x0001f3bc  cmp      x27, x23
0x0001f3c0  csel     x27, x27, x23, lt
0x0001f3c4  b        #0x1f44c   ; call sub_1f44c
0x0001f3c8  mov      x0, x25
0x0001f3cc  mov      x2, x19
0x0001f3d0  bl       #0x258a0   ; objc_msgSend: hasPrefix:
0x0001f3d4  cbz      w0, #0x1f3ec
0x0001f3d8  mov      x0, x25
0x0001f3dc  bl       #0x25fa0   ; objc_msgSend: length
0x0001f3e0  cmp      x0, #9
0x0001f3e4  ccmp     x26, #0, #0, hs
0x0001f3e8  b.eq     #0x1f434
0x0001f3ec  mov      x0, x25
0x0001f3f0  adrp     x2, #0x38000
0x0001f3f4  add      x2, x2, #0x90   ; -> @"last="
0x0001f3f8  bl       #0x258a0   ; objc_msgSend: hasPrefix:
0x0001f3fc  cbz      w0, #0x1f44c
0x0001f400  mov      x0, x25
0x0001f404  bl       #0x25fa0   ; objc_msgSend: length
