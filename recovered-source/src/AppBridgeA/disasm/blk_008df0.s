; block literal @0x346f0 desc @0x34670 sig=v16@?0@"NSNotification"8 flags=0x50000000
; ==== sub_8df0 @ 0x8df0..0x8fd4 (484 bytes) ====
0x00008df0  sub      sp, sp, #0x60
0x00008df4  stp      x26, x25, [sp, #0x10]
0x00008df8  stp      x24, x23, [sp, #0x20]
0x00008dfc  stp      x22, x21, [sp, #0x30]
0x00008e00  stp      x20, x19, [sp, #0x40]
0x00008e04  stp      x29, x30, [sp, #0x50]
0x00008e08  add      x29, sp, #0x50
0x00008e0c  mov      x19, x1
0x00008e10  mov      x0, x1
0x00008e14  bl       #0x24818   ; call _objc_retain
0x00008e18  adrp     x8, #0x3e000
0x00008e1c  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x00008e20  bl       #0x27b20   ; objc_msgSend: shared
0x00008e24  mov      x29, x29
0x00008e28  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008e2c  mov      x20, x0
0x00008e30  mov      x0, x19
0x00008e34  bl       #0x280c0   ; objc_msgSend: userInfo
0x00008e38  mov      x29, x29
0x00008e3c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008e40  mov      x21, x0
0x00008e44  adrp     x2, #0x35000
0x00008e48  add      x2, x2, #0x3b0   ; -> @"identifier"
0x00008e4c  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008e50  mov      x29, x29
0x00008e54  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008e58  mov      x23, x0
0x00008e5c  mov      x0, x19
0x00008e60  bl       #0x280c0   ; objc_msgSend: userInfo
0x00008e64  mov      x29, x29
0x00008e68  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008e6c  mov      x25, x0
0x00008e70  adrp     x2, #0x35000
0x00008e74  add      x2, x2, #0x770   ; -> @"terminate"
0x00008e78  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008e7c  mov      x29, x29
0x00008e80  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008e84  mov      x22, x0
0x00008e88  bl       #0x24f20   ; objc_msgSend: boolValue
0x00008e8c  mov      x3, x0
0x00008e90  mov      x0, x20
0x00008e94  mov      x2, x23
0x00008e98  bl       #0x251e0   ; objc_msgSend: closeApp:terminate:
0x00008e9c  mov      x0, x22
0x00008ea0  bl       #0x2480c   ; call _objc_release
0x00008ea4  mov      x0, x25
0x00008ea8  bl       #0x2480c   ; call _objc_release
0x00008eac  mov      x0, x23
0x00008eb0  bl       #0x2480c   ; call _objc_release
0x00008eb4  mov      x0, x21
0x00008eb8  bl       #0x2480c   ; call _objc_release
0x00008ebc  mov      x0, x20
0x00008ec0  bl       #0x2480c   ; call _objc_release
0x00008ec4  mov      x0, x19
0x00008ec8  ldp      x29, x30, [sp, #0x50]
0x00008ecc  ldp      x20, x19, [sp, #0x40]
0x00008ed0  ldp      x22, x21, [sp, #0x30]
0x00008ed4  ldp      x24, x23, [sp, #0x20]
0x00008ed8  ldp      x26, x25, [sp, #0x10]
0x00008edc  add      sp, sp, #0x60
0x00008ee0  b        #0x2480c   ; call _objc_release
0x00008ee4  mov      x24, x1
0x00008ee8  mov      x22, x0
0x00008eec  b        #0x8f34   ; call sub_8f34
0x00008ef0  mov      x24, x1
0x00008ef4  mov      x22, x0
0x00008ef8  b        #0x8f3c   ; call sub_8f3c
0x00008efc  mov      x24, x1
0x00008f00  mov      x22, x0
0x00008f04  b        #0x8f44   ; call sub_8f44
0x00008f08  mov      x24, x1
0x00008f0c  mov      x22, x0
0x00008f10  b        #0x8f4c   ; call sub_8f4c
0x00008f14  mov      x24, x1
0x00008f18  mov      x22, x0
0x00008f1c  b        #0x8f54   ; call sub_8f54
0x00008f20  mov      x24, x1
0x00008f24  mov      x1, x22
0x00008f28  mov      x22, x0
0x00008f2c  mov      x0, x1
0x00008f30  bl       #0x2480c   ; call _objc_release
0x00008f34  mov      x0, x25
0x00008f38  bl       #0x2480c   ; call _objc_release
0x00008f3c  mov      x0, x23
0x00008f40  bl       #0x2480c   ; call _objc_release
0x00008f44  mov      x0, x21
0x00008f48  bl       #0x2480c   ; call _objc_release
0x00008f4c  mov      x0, x20
0x00008f50  bl       #0x2480c   ; call _objc_release
0x00008f54  cmp      w24, #1
0x00008f58  b.ne     #0x8fc4
0x00008f5c  mov      x0, x22
0x00008f60  bl       #0x24740   ; call _objc_begin_catch
0x00008f64  adrp     x8, #0x3e000
0x00008f68  ldr      x8, [x8, #0x290]   ; -> [class(NSString)]
0x00008f6c  str      x0, [sp]
0x00008f70  adrp     x2, #0x35000
0x00008f74  add      x2, x2, #0x790   ; -> @"close loi %@"
0x00008f78  mov      x0, x8
0x00008f7c  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00008f80  mov      x29, x29
0x00008f84  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008f88  mov      x20, x0
0x00008f8c  adrp     x0, #0x34000
0x00008f90  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00008f94  mov      x1, x20
0x00008f98  bl       #0x1dd30   ; call _OMCLogWrite
0x00008f9c  mov      x0, x20
0x00008fa0  bl       #0x2480c   ; call _objc_release
0x00008fa4  bl       #0x24764   ; call _objc_end_catch
0x00008fa8  b        #0x8ec4   ; call sub_8ec4
0x00008fac  mov      x22, x0
0x00008fb0  mov      x0, x20
0x00008fb4  bl       #0x2480c   ; call _objc_release
0x00008fb8  b        #0x8fc0   ; call sub_8fc0
0x00008fbc  mov      x22, x0
0x00008fc0  bl       #0x24764   ; call _objc_end_catch
0x00008fc4  mov      x0, x19
0x00008fc8  bl       #0x2480c   ; call _objc_release
0x00008fcc  mov      x0, x22
0x00008fd0  bl       #0x24470   ; call __Unwind_Resume

