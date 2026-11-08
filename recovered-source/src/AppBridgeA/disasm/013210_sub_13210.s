; ==== sub_13210 @ 0x13210..0x13364 (340 bytes) ====
0x00013210  bl       #0x254c0   ; objc_msgSend: defaultCenter
0x00013214  mov      x29, x29
0x00013218  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001321c  mov      x22, x0
0x00013220  adrp     x8, #0x35000
0x00013224  add      x8, x8, #0x3b0   ; -> @"identifier"
0x00013228  str      x8, [sp, #0x18]
0x0001322c  mov      x0, x21
0x00013230  bl       #0x25020   ; objc_msgSend: bundleID
0x00013234  mov      x29, x29
0x00013238  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001323c  mov      x24, x0
0x00013240  adrp     x8, #0x35000
0x00013244  add      x8, x8, #0x170   ; -> @"action"
0x00013248  stp      x8, x0, [sp, #0x20]
0x0001324c  str      x19, [sp, #0x30]
0x00013250  adrp     x8, #0x3e000
0x00013254  ldr      x0, [x8, #0x310]   ; -> [class(NSDictionary)]
0x00013258  add      x2, sp, #0x28
0x0001325c  add      x3, sp, #0x18
0x00013260  mov      w4, #2
0x00013264  bl       #0x255c0   ; objc_msgSend: dictionaryWithObjects:forKeys:count:
0x00013268  mov      x29, x29
0x0001326c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013270  mov      x23, x0
0x00013274  adrp     x2, #0x36000
0x00013278  add      x2, x2, #0x510   ; -> @"com.anlai.omnicar/appbridge.baraction"
0x0001327c  mov      x0, x22
0x00013280  mov      x3, #0
0x00013284  mov      x4, x23
0x00013288  bl       #0x26620   ; objc_msgSend: postNotificationName:object:userInfo:
0x0001328c  mov      x0, x23
0x00013290  bl       #0x2480c   ; call _objc_release
0x00013294  mov      x0, x24
0x00013298  bl       #0x2480c   ; call _objc_release
0x0001329c  mov      x0, x22
0x000132a0  bl       #0x2480c   ; call _objc_release
0x000132a4  mov      x0, x21
0x000132a8  bl       #0x2480c   ; call _objc_release
0x000132ac  mov      x0, x20
0x000132b0  bl       #0x2480c   ; call _objc_release
0x000132b4  mov      x0, x19
0x000132b8  bl       #0x2480c   ; call _objc_release
0x000132bc  ldr      x8, [sp, #0x38]
0x000132c0  adrp     x9, #0x34000
0x000132c4  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x000132c8  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x000132cc  cmp      x9, x8
0x000132d0  b.ne     #0x132ec
0x000132d4  ldp      x29, x30, [sp, #0x70]
0x000132d8  ldp      x20, x19, [sp, #0x60]
0x000132dc  ldp      x22, x21, [sp, #0x50]
0x000132e0  ldp      x24, x23, [sp, #0x40]
0x000132e4  add      sp, sp, #0x80
0x000132e8  ret      
0x000132ec  bl       #0x24488   ; call ___stack_chk_fail
0x000132f0  mov      x1, x23
0x000132f4  mov      x23, x0
0x000132f8  mov      x0, x1
0x000132fc  bl       #0x2480c   ; call _objc_release
0x00013300  b        #0x13308   ; call sub_13308
0x00013304  mov      x23, x0
0x00013308  mov      x0, x24
0x0001330c  bl       #0x2480c   ; call _objc_release
0x00013310  b        #0x13318   ; call sub_13318
0x00013314  mov      x23, x0
0x00013318  mov      x0, x22
0x0001331c  bl       #0x2480c   ; call _objc_release
0x00013320  b        #0x13350   ; call sub_13350
0x00013324  mov      x23, x0
0x00013328  mov      x0, x24
0x0001332c  bl       #0x2480c   ; call _objc_release
0x00013330  b        #0x13338   ; call sub_13338
0x00013334  mov      x23, x0
0x00013338  mov      x0, x22
0x0001333c  bl       #0x2480c   ; call _objc_release
0x00013340  b        #0x13350   ; call sub_13350
0x00013344  mov      x23, x0
0x00013348  b        #0x13358   ; call sub_13358
0x0001334c  mov      x23, x0
0x00013350  mov      x0, x21
0x00013354  bl       #0x2480c   ; call _objc_release
0x00013358  mov      x0, x20
0x0001335c  bl       #0x2480c   ; call _objc_release
0x00013360  mov      x0, x19
