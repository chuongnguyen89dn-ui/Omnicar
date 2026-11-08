; ==== sub_1c7d4 @ 0x1c7d4..0x1c94c (376 bytes) ====
0x0001c7d4  mov      x2, #0
0x0001c7d8  mov      x3, #0
0x0001c7dc  bl       #0x25de0   ; objc_msgSend: key:value:command:weight:
0x0001c7e0  mov      x29, x29
0x0001c7e4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c7e8  mov      x19, x0
0x0001c7ec  mov      x0, x20
0x0001c7f0  mov      x2, x19
0x0001c7f4  bl       #0x25e00   ; objc_msgSend: keyTapped:
0x0001c7f8  mov      x0, x19
0x0001c7fc  ldp      x29, x30, [sp, #0x10]
0x0001c800  ldp      x20, x19, [sp], #0x20
0x0001c804  b        #0x2480c   ; call _objc_release
0x0001c808  mov      x20, x0
0x0001c80c  mov      x0, x19
0x0001c810  bl       #0x2480c   ; call _objc_release
0x0001c814  mov      x0, x20
0x0001c818  bl       #0x24470   ; call __Unwind_Resume
0x0001c81c  sub      sp, sp, #0x70
0x0001c820  stp      x24, x23, [sp, #0x30]
0x0001c824  stp      x22, x21, [sp, #0x40]
0x0001c828  stp      x20, x19, [sp, #0x50]
0x0001c82c  stp      x29, x30, [sp, #0x60]
0x0001c830  add      x29, sp, #0x60
0x0001c834  mov      x20, x4
0x0001c838  mov      x21, x3
0x0001c83c  mov      x19, x2
0x0001c840  mov      x22, x0
0x0001c844  adrp     x8, #0x34000
0x0001c848  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0001c84c  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0001c850  str      x8, [sp, #0x28]
0x0001c854  mov      x0, x2
0x0001c858  bl       #0x24818   ; call _objc_retain
0x0001c85c  mov      x0, x20
0x0001c860  bl       #0x24818   ; call _objc_retain
0x0001c864  mov      x0, x22
0x0001c868  bl       #0x24ce0   ; objc_msgSend: app
0x0001c86c  mov      x29, x29
0x0001c870  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c874  mov      x23, x0
0x0001c878  bl       #0x2480c   ; call _objc_release
0x0001c87c  cbz      x23, #0x1c96c
0x0001c880  adrp     x8, #0x35000
0x0001c884  add      x8, x8, #0x170   ; -> @"action"
0x0001c888  adrp     x9, #0x35000
0x0001c88c  add      x9, x9, #0x1b0   ; -> @"del"
0x0001c890  str      x8, [sp, #8]
0x0001c894  stp      x9, x19, [sp, #0x10]
0x0001c898  adrp     x8, #0x3e000
0x0001c89c  ldr      x0, [x8, #0x2a0]   ; -> [class(NSNumber)]
0x0001c8a0  mov      x2, x21
0x0001c8a4  bl       #0x263a0   ; objc_msgSend: numberWithUnsignedInteger:
0x0001c8a8  mov      x29, x29
0x0001c8ac  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c8b0  mov      x23, x0
0x0001c8b4  str      x0, [sp, #0x20]
0x0001c8b8  adrp     x8, #0x3e000
0x0001c8bc  ldr      x0, [x8, #0x310]   ; -> [class(NSDictionary)]
0x0001c8c0  add      x2, sp, #0x18
0x0001c8c4  add      x3, sp, #8
0x0001c8c8  mov      w4, #2
0x0001c8cc  bl       #0x255c0   ; objc_msgSend: dictionaryWithObjects:forKeys:count:
0x0001c8d0  mov      x29, x29
0x0001c8d4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c8d8  mov      x24, x0
0x0001c8dc  bl       #0x261e0   ; objc_msgSend: mutableCopy
0x0001c8e0  mov      x21, x0
0x0001c8e4  mov      x0, x24
0x0001c8e8  bl       #0x2480c   ; call _objc_release
0x0001c8ec  mov      x0, x23
0x0001c8f0  bl       #0x2480c   ; call _objc_release
0x0001c8f4  cbz      x20, #0x1c90c
0x0001c8f8  adrp     x3, #0x35000
0x0001c8fc  add      x3, x3, #0x1d0   ; -> @"text"
0x0001c900  mov      x0, x21
0x0001c904  mov      x2, x20
0x0001c908  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x0001c90c  adrp     x0, #0x28000
0x0001c910  add      x0, x0, #0xfc3   ; -> "NSDistributedNotificationCenter"
0x0001c914  bl       #0x24788   ; call _objc_getClass
0x0001c918  bl       #0x254c0   ; objc_msgSend: defaultCenter
0x0001c91c  mov      x29, x29
0x0001c920  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c924  mov      x23, x0
0x0001c928  mov      x0, x22
0x0001c92c  bl       #0x24ce0   ; objc_msgSend: app
0x0001c930  mov      x29, x29
0x0001c934  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c938  mov      x22, x0
0x0001c93c  adrp     x2, #0x34000
0x0001c940  add      x2, x2, #0xf90   ; -> @"com.anlai.omnicar/appbridge.key"
0x0001c944  mov      x0, x23
0x0001c948  mov      x3, x22
