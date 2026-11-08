; block literal @0x34630 desc @0x34610 sig=v8@?0 flags=0x50000000
; ==== sub_6028 @ 0x6028..0x6e08 (3552 bytes) ====
0x00006028  sub      sp, sp, #0x30
0x0000602c  stp      x20, x19, [sp, #0x10]
0x00006030  stp      x29, x30, [sp, #0x20]
0x00006034  add      x29, sp, #0x20
0x00006038  adrp     x8, #0x3e000
0x0000603c  ldr      w8, [x8, #0x9d0]
0x00006040  cmp      w8, #1
0x00006044  b.lt     #0x608c
0x00006048  bl       #0x612c   ; call sub_612c
0x0000604c  tbnz     w0, #1, #0x609c
0x00006050  adrp     x8, #0x3e000
0x00006054  ldr      x8, [x8, #0x290]   ; -> [class(NSString)]
0x00006058  str      x0, [sp]
0x0000605c  adrp     x2, #0x34000
0x00006060  add      x2, x2, #0xfd0   ; -> @"bo qua su kien xoay gia: app dang chi cho mask %lu"
0x00006064  mov      x0, x8
0x00006068  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000606c  mov      x29, x29
0x00006070  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006074  mov      x19, x0
0x00006078  adrp     x0, #0x34000
0x0000607c  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00006080  mov      x1, x19
0x00006084  bl       #0x1dd30   ; call _OMCLogWrite
0x00006088  b        #0x60ec   ; call sub_60ec
0x0000608c  ldp      x29, x30, [sp, #0x20]
0x00006090  ldp      x20, x19, [sp, #0x10]
0x00006094  add      sp, sp, #0x30
0x00006098  ret      
0x0000609c  adrp     x8, #0x3e000
0x000060a0  ldr      x0, [x8, #0x2b0]   ; -> [class(NSNotificationCenter)]
0x000060a4  bl       #0x254c0   ; objc_msgSend: defaultCenter
0x000060a8  mov      x29, x29
0x000060ac  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000060b0  mov      x19, x0
0x000060b4  adrp     x8, #0x3e000
0x000060b8  ldr      x0, [x8, #0x2b8]   ; -> [class(UIDevice)]
0x000060bc  bl       #0x25460   ; objc_msgSend: currentDevice
0x000060c0  mov      x29, x29
0x000060c4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000060c8  mov      x20, x0
0x000060cc  adrp     x8, #0x34000
0x000060d0  ldr      x8, [x8, #0x220]   ; -> [got:_UIDeviceOrientationDidChangeNotification]
0x000060d4  ldr      x2, [x8]   ; -> [got:___objc_personality_v0]
0x000060d8  mov      x0, x19
0x000060dc  mov      x3, x20
0x000060e0  bl       #0x26600   ; objc_msgSend: postNotificationName:object:
0x000060e4  mov      x0, x20
0x000060e8  bl       #0x2480c   ; call _objc_release
0x000060ec  mov      x0, x19
0x000060f0  ldp      x29, x30, [sp, #0x20]
0x000060f4  ldp      x20, x19, [sp, #0x10]
0x000060f8  add      sp, sp, #0x30
0x000060fc  b        #0x2480c   ; call _objc_release
0x00006100  mov      x1, x20
0x00006104  mov      x20, x0
0x00006108  mov      x0, x1
0x0000610c  bl       #0x2480c   ; call _objc_release
0x00006110  b        #0x611c   ; call sub_611c
0x00006114  b        #0x6118   ; call sub_6118
0x00006118  mov      x20, x0
0x0000611c  mov      x0, x19
0x00006120  bl       #0x2480c   ; call _objc_release
0x00006124  mov      x0, x20
0x00006128  bl       #0x24470   ; call __Unwind_Resume
0x0000612c  stp      x22, x21, [sp, #-0x30]!
0x00006130  stp      x20, x19, [sp, #0x10]
0x00006134  stp      x29, x30, [sp, #0x20]
0x00006138  add      x29, sp, #0x20
0x0000613c  bl       #0x61d0   ; call sub_61d0
0x00006140  mov      x29, x29
0x00006144  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006148  mov      x19, x0
0x0000614c  cbz      x0, #0x618c
0x00006150  mov      x0, x19
0x00006154  bl       #0x269c0   ; objc_msgSend: rootViewController
0x00006158  mov      x29, x29
0x0000615c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006160  mov      x21, x0
0x00006164  mov      w1, #0
0x00006168  bl       #0x6498   ; call sub_6498
0x0000616c  mov      x20, x0
0x00006170  mov      x0, x21
0x00006174  bl       #0x2480c   ; call _objc_release
0x00006178  cbnz     x20, #0x6190
0x0000617c  mov      x0, x19
0x00006180  bl       #0x5ec0   ; call sub_5ec0
0x00006184  mov      x20, x0
0x00006188  b        #0x6190   ; call sub_6190
0x0000618c  mov      w20, #0x1e
0x00006190  mov      x0, x19
0x00006194  bl       #0x2480c   ; call _objc_release
0x00006198  mov      x0, x20
0x0000619c  ldp      x29, x30, [sp, #0x20]
0x000061a0  ldp      x20, x19, [sp, #0x10]
0x000061a4  ldp      x22, x21, [sp], #0x30
0x000061a8  ret      
0x000061ac  mov      x20, x0
0x000061b0  mov      x0, x21
0x000061b4  bl       #0x2480c   ; call _objc_release
0x000061b8  b        #0x61c0   ; call sub_61c0
0x000061bc  mov      x20, x0
0x000061c0  mov      x0, x19
0x000061c4  bl       #0x2480c   ; call _objc_release
0x000061c8  mov      x0, x20
0x000061cc  bl       #0x24470   ; call __Unwind_Resume
0x000061d0  stp      x28, x27, [sp, #-0x60]!
0x000061d4  stp      x26, x25, [sp, #0x10]
0x000061d8  stp      x24, x23, [sp, #0x20]
0x000061dc  stp      x22, x21, [sp, #0x30]
0x000061e0  stp      x20, x19, [sp, #0x40]
0x000061e4  stp      x29, x30, [sp, #0x50]
0x000061e8  add      x29, sp, #0x50
0x000061ec  sub      sp, sp, #0x1a0
0x000061f0  adrp     x8, #0x34000
0x000061f4  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x000061f8  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x000061fc  stur     x8, [x29, #-0x60]
0x00006200  movi     v0.16b, #0
0x00006204  stp      q0, q0, [sp, #0x50]
0x00006208  stp      q0, q0, [sp, #0x70]
0x0000620c  adrp     x8, #0x3e000
0x00006210  ldr      x0, [x8, #0x2c0]   ; -> [class(UIApplication)]
0x00006214  bl       #0x27b40   ; objc_msgSend: sharedApplication
0x00006218  mov      x29, x29
0x0000621c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006220  mov      x20, x0
0x00006224  bl       #0x25340   ; objc_msgSend: connectedScenes
0x00006228  mov      x29, x29
0x0000622c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006230  mov      x19, x0
0x00006234  mov      x0, x20
0x00006238  bl       #0x2480c   ; call _objc_release
0x0000623c  add      x2, sp, #0x50
0x00006240  sub      x3, x29, #0xe0
0x00006244  str      x19, [sp]
0x00006248  mov      x0, x19
0x0000624c  mov      w4, #0x10
0x00006250  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00006254  mov      x20, #0
0x00006258  mov      x21, x0
0x0000625c  cbz      x0, #0x63e0
0x00006260  ldr      x8, [sp, #0x60]
0x00006264  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00006268  str      x8, [sp, #8]
0x0000626c  mov      x19, #0
0x00006270  ldr      x8, [sp, #0x60]
0x00006274  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00006278  ldr      x9, [sp, #8]
0x0000627c  cmp      x8, x9
0x00006280  b.eq     #0x628c
0x00006284  ldr      x0, [sp]
0x00006288  bl       #0x24770   ; call _objc_enumerationMutation
0x0000628c  ldr      x8, [sp, #0x58]
0x00006290  ldr      x22, [x8, x19, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x00006294  adrp     x8, #0x3e000
0x00006298  ldr      x0, [x8, #0x2c8]   ; -> [class(UIWindowScene)]
0x0000629c  bl       #0x247d0   ; call _objc_opt_class
0x000062a0  mov      x1, x0
0x000062a4  mov      x0, x22
0x000062a8  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x000062ac  tbz      w0, #0, #0x63b8
0x000062b0  movi     v0.16b, #0
0x000062b4  stp      q0, q0, [sp, #0x30]
0x000062b8  stp      q0, q0, [sp, #0x10]
0x000062bc  mov      x0, x22
0x000062c0  bl       #0x28200   ; objc_msgSend: windows
0x000062c4  mov      x29, x29
0x000062c8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000062cc  mov      x22, x0
0x000062d0  add      x2, sp, #0x10
0x000062d4  add      x3, sp, #0x90
0x000062d8  mov      w4, #0x10
0x000062dc  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x000062e0  mov      x23, x0
0x000062e4  cbz      x0, #0x63a0
0x000062e8  ldr      x8, [sp, #0x20]
0x000062ec  ldr      x28, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x000062f0  mov      x27, #0
0x000062f4  ldr      x8, [sp, #0x20]
0x000062f8  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x000062fc  cmp      x8, x28
0x00006300  b.eq     #0x630c
0x00006304  mov      x0, x22
0x00006308  bl       #0x24770   ; call _objc_enumerationMutation
0x0000630c  ldr      x8, [sp, #0x18]
0x00006310  ldr      x24, [x8, x27, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x00006314  mov      x0, x24
0x00006318  bl       #0x269c0   ; objc_msgSend: rootViewController
0x0000631c  mov      x29, x29
0x00006320  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006324  mov      x25, x0
0x00006328  cbz      x0, #0x6360
0x0000632c  mov      x0, x24
0x00006330  bl       #0x25d00   ; objc_msgSend: isHidden
0x00006334  mov      x26, x0
0x00006338  mov      x0, x25
0x0000633c  bl       #0x2480c   ; call _objc_release
0x00006340  tbnz     w26, #0, #0x6360
0x00006344  mov      x0, x24
0x00006348  bl       #0x25d40   ; objc_msgSend: isKeyWindow
0x0000634c  cbnz     w0, #0x638c
0x00006350  cbnz     x20, #0x6360
0x00006354  mov      x0, x24
0x00006358  bl       #0x24818   ; call _objc_retain
0x0000635c  mov      x20, x24
0x00006360  add      x27, x27, #1
0x00006364  cmp      x23, x27
0x00006368  b.ne     #0x62f4
0x0000636c  add      x2, sp, #0x10
0x00006370  add      x3, sp, #0x90
0x00006374  mov      x0, x22
0x00006378  mov      w4, #0x10
0x0000637c  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00006380  mov      x23, x0
0x00006384  cbnz     x0, #0x62f0
0x00006388  b        #0x63a0   ; call sub_63a0
0x0000638c  mov      x0, x24
0x00006390  bl       #0x24818   ; call _objc_retain
0x00006394  mov      x0, x20
0x00006398  bl       #0x2480c   ; call _objc_release
0x0000639c  mov      x20, x24
0x000063a0  mov      x0, x22
0x000063a4  bl       #0x2480c   ; call _objc_release
0x000063a8  cbz      x20, #0x63b8
0x000063ac  mov      x0, x20
0x000063b0  bl       #0x25d40   ; objc_msgSend: isKeyWindow
0x000063b4  tbnz     w0, #0, #0x63e0
0x000063b8  add      x19, x19, #1
0x000063bc  cmp      x19, x21
0x000063c0  b.ne     #0x6270
0x000063c4  add      x2, sp, #0x50
0x000063c8  sub      x3, x29, #0xe0
0x000063cc  ldr      x0, [sp]
0x000063d0  mov      w4, #0x10
0x000063d4  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x000063d8  mov      x21, x0
0x000063dc  cbnz     x0, #0x626c
0x000063e0  ldr      x0, [sp]
0x000063e4  bl       #0x2480c   ; call _objc_release
0x000063e8  ldur     x8, [x29, #-0x60]
0x000063ec  adrp     x9, #0x34000
0x000063f0  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x000063f4  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x000063f8  cmp      x9, x8
0x000063fc  b.ne     #0x6424
0x00006400  mov      x0, x20
0x00006404  add      sp, sp, #0x1a0
0x00006408  ldp      x29, x30, [sp, #0x50]
0x0000640c  ldp      x20, x19, [sp, #0x40]
0x00006410  ldp      x22, x21, [sp, #0x30]
0x00006414  ldp      x24, x23, [sp, #0x20]
0x00006418  ldp      x26, x25, [sp, #0x10]
0x0000641c  ldp      x28, x27, [sp], #0x60
0x00006420  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x00006424  bl       #0x24488   ; call ___stack_chk_fail
0x00006428  mov      x21, x0
0x0000642c  mov      x20, #0
0x00006430  b        #0x6478   ; call sub_6478
0x00006434  mov      x21, x0
0x00006438  mov      x0, x20
0x0000643c  bl       #0x2480c   ; call _objc_release
0x00006440  b        #0x6490   ; call sub_6490
0x00006444  b        #0x6454   ; call sub_6454
0x00006448  b        #0x6454   ; call sub_6454
0x0000644c  b        #0x646c   ; call sub_646c
0x00006450  b        #0x646c   ; call sub_646c
0x00006454  mov      x21, x0
0x00006458  b        #0x6478   ; call sub_6478
0x0000645c  mov      x21, x0
0x00006460  mov      x0, x25
0x00006464  bl       #0x2480c   ; call _objc_release
0x00006468  b        #0x6470   ; call sub_6470
0x0000646c  mov      x21, x0
0x00006470  mov      x0, x22
0x00006474  bl       #0x2480c   ; call _objc_release
0x00006478  ldr      x0, [sp]
0x0000647c  bl       #0x2480c   ; call _objc_release
0x00006480  mov      x0, x20
0x00006484  bl       #0x2480c   ; call _objc_release
0x00006488  b        #0x6490   ; call sub_6490
0x0000648c  mov      x21, x0
0x00006490  mov      x0, x21
0x00006494  bl       #0x24470   ; call __Unwind_Resume
0x00006498  sub      sp, sp, #0x120
0x0000649c  stp      x26, x25, [sp, #0xd0]
0x000064a0  stp      x24, x23, [sp, #0xe0]
0x000064a4  stp      x22, x21, [sp, #0xf0]
0x000064a8  stp      x20, x19, [sp, #0x100]
0x000064ac  stp      x29, x30, [sp, #0x110]
0x000064b0  add      x29, sp, #0x110
0x000064b4  mov      x20, x1
0x000064b8  mov      x19, x0
0x000064bc  adrp     x8, #0x34000
0x000064c0  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x000064c4  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x000064c8  stur     x8, [x29, #-0x48]
0x000064cc  bl       #0x24818   ; call _objc_retain
0x000064d0  mov      x22, #0
0x000064d4  cbz      x19, #0x668c
0x000064d8  cmp      w20, #0xc
0x000064dc  b.gt     #0x668c
0x000064e0  mov      x0, x19
0x000064e4  bl       #0x25d80   ; objc_msgSend: isViewLoaded
0x000064e8  cbz      w0, #0x6570
0x000064ec  mov      x0, x19
0x000064f0  bl       #0x28140   ; objc_msgSend: view
0x000064f4  mov      x29, x29
0x000064f8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000064fc  mov      x21, x0
0x00006500  bl       #0x281e0   ; objc_msgSend: window
0x00006504  mov      x29, x29
0x00006508  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000650c  mov      x22, x0
0x00006510  cbz      x0, #0x6568
0x00006514  mov      x0, x19
0x00006518  bl       #0x28140   ; objc_msgSend: view
0x0000651c  mov      x29, x29
0x00006520  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006524  mov      x23, x0
0x00006528  bl       #0x25d00   ; objc_msgSend: isHidden
0x0000652c  mov      x24, x0
0x00006530  mov      x0, x23
0x00006534  bl       #0x2480c   ; call _objc_release
0x00006538  mov      x0, x22
0x0000653c  bl       #0x2480c   ; call _objc_release
0x00006540  mov      x0, x21
0x00006544  bl       #0x2480c   ; call _objc_release
0x00006548  tbnz     w24, #0, #0x6570
0x0000654c  mov      x0, x19
0x00006550  bl       #0x27e40   ; objc_msgSend: supportedInterfaceOrientations
0x00006554  mov      x22, x0
0x00006558  tst      x0, #0x18
0x0000655c  b.eq     #0x6570
0x00006560  tbnz     w22, #1, #0x6570
0x00006564  b        #0x668c   ; call sub_668c
0x00006568  mov      x0, x21
0x0000656c  bl       #0x2480c   ; call _objc_release
0x00006570  mov      x0, x19
0x00006574  bl       #0x26680   ; objc_msgSend: presentedViewController
0x00006578  mov      x29, x29
0x0000657c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006580  mov      x21, x0
0x00006584  cbz      x0, #0x65e4
0x00006588  mov      x0, x19
0x0000658c  bl       #0x26680   ; objc_msgSend: presentedViewController
0x00006590  mov      x29, x29
0x00006594  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006598  mov      x22, x0
0x0000659c  bl       #0x25c40   ; objc_msgSend: isBeingDismissed
0x000065a0  mov      x23, x0
0x000065a4  mov      x0, x22
0x000065a8  bl       #0x2480c   ; call _objc_release
0x000065ac  mov      x0, x21
0x000065b0  bl       #0x2480c   ; call _objc_release
0x000065b4  tbnz     w23, #0, #0x65e4
0x000065b8  mov      x0, x19
0x000065bc  bl       #0x26680   ; objc_msgSend: presentedViewController
0x000065c0  mov      x29, x29
0x000065c4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000065c8  mov      x21, x0
0x000065cc  add      w1, w20, #1
0x000065d0  bl       #0x6498   ; call sub_6498
0x000065d4  mov      x22, x0
0x000065d8  mov      x0, x21
0x000065dc  bl       #0x2480c   ; call _objc_release
0x000065e0  cbnz     x22, #0x668c
0x000065e4  movi     v0.16b, #0
0x000065e8  stp      q0, q0, [sp, #0x20]
0x000065ec  stp      q0, q0, [sp]
0x000065f0  mov      x0, x19
0x000065f4  bl       #0x25180   ; objc_msgSend: childViewControllers
0x000065f8  mov      x29, x29
0x000065fc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006600  mov      x21, x0
0x00006604  mov      x2, sp
0x00006608  add      x3, sp, #0x48
0x0000660c  mov      w4, #0x10
0x00006610  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00006614  mov      x23, x0
0x00006618  cbz      x0, #0x6680
0x0000661c  ldr      x8, [sp, #0x10]
0x00006620  ldr      x24, [x8]   ; -> [got:___objc_personality_v0]
0x00006624  mov      x25, #0
0x00006628  ldr      x8, [sp, #0x10]
0x0000662c  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00006630  cmp      x8, x24
0x00006634  b.eq     #0x6640
0x00006638  mov      x0, x21
0x0000663c  bl       #0x24770   ; call _objc_enumerationMutation
0x00006640  ldr      x8, [sp, #8]
0x00006644  ldr      x0, [x8, x25, lsl #3]   ; -> [got:___objc_personality_v0]
0x00006648  add      w1, w20, #1
0x0000664c  bl       #0x6498   ; call sub_6498
0x00006650  mov      x22, x0
0x00006654  cbnz     x0, #0x6684
0x00006658  add      x25, x25, #1
0x0000665c  cmp      x23, x25
0x00006660  b.ne     #0x6628
0x00006664  mov      x2, sp
0x00006668  add      x3, sp, #0x48
0x0000666c  mov      x0, x21
0x00006670  mov      w4, #0x10
0x00006674  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00006678  mov      x23, x0
0x0000667c  cbnz     x0, #0x6624
0x00006680  mov      x22, #0
0x00006684  mov      x0, x21
0x00006688  bl       #0x2480c   ; call _objc_release
0x0000668c  mov      x0, x19
0x00006690  bl       #0x2480c   ; call _objc_release
0x00006694  ldur     x8, [x29, #-0x48]
0x00006698  adrp     x9, #0x34000
0x0000669c  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x000066a0  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x000066a4  cmp      x9, x8
0x000066a8  b.ne     #0x66cc
0x000066ac  mov      x0, x22
0x000066b0  ldp      x29, x30, [sp, #0x110]
0x000066b4  ldp      x20, x19, [sp, #0x100]
0x000066b8  ldp      x22, x21, [sp, #0xf0]
0x000066bc  ldp      x24, x23, [sp, #0xe0]
0x000066c0  ldp      x26, x25, [sp, #0xd0]
0x000066c4  add      sp, sp, #0x120
0x000066c8  ret      
0x000066cc  bl       #0x24488   ; call ___stack_chk_fail
0x000066d0  b        #0x6720   ; call sub_6720
0x000066d4  b        #0x6708   ; call sub_6708
0x000066d8  b        #0x6720   ; call sub_6720
0x000066dc  mov      x20, x0
0x000066e0  mov      x0, x23
0x000066e4  bl       #0x2480c   ; call _objc_release
0x000066e8  b        #0x66fc   ; call sub_66fc
0x000066ec  b        #0x66f8   ; call sub_66f8
0x000066f0  b        #0x672c   ; call sub_672c
0x000066f4  b        #0x6708   ; call sub_6708
0x000066f8  mov      x20, x0
0x000066fc  mov      x0, x22
0x00006700  bl       #0x2480c   ; call _objc_release
0x00006704  b        #0x670c   ; call sub_670c
0x00006708  mov      x20, x0
0x0000670c  mov      x0, x21
0x00006710  bl       #0x2480c   ; call _objc_release
0x00006714  b        #0x6738   ; call sub_6738
0x00006718  b        #0x672c   ; call sub_672c
0x0000671c  b        #0x6720   ; call sub_6720
0x00006720  mov      x20, x0
0x00006724  b        #0x6738   ; call sub_6738
0x00006728  b        #0x672c   ; call sub_672c
0x0000672c  mov      x20, x0
0x00006730  mov      x0, x21
0x00006734  bl       #0x2480c   ; call _objc_release
0x00006738  mov      x0, x19
0x0000673c  bl       #0x2480c   ; call _objc_release
0x00006740  b        #0x6748   ; call sub_6748
0x00006744  mov      x20, x0
0x00006748  mov      x0, x20
0x0000674c  bl       #0x24470   ; call __Unwind_Resume
0x00006750  sub      sp, sp, #0x50
0x00006754  stp      x20, x19, [sp, #0x30]
0x00006758  stp      x29, x30, [sp, #0x40]
0x0000675c  add      x29, sp, #0x40
0x00006760  mov      x19, x0
0x00006764  adrp     x20, #0x3e000
0x00006768  ldr      x0, [x20, #0x9d8]
0x0000676c  cbz      x0, #0x6780
0x00006770  bl       #0x24560   ; call _dispatch_block_cancel
0x00006774  ldr      x0, [x20, #0x9d8]
0x00006778  str      xzr, [x20, #0x9d8]
0x0000677c  bl       #0x2480c   ; call _objc_release
0x00006780  adrp     x8, #0x34000
0x00006784  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x00006788  str      x8, [sp, #8]
0x0000678c  adrp     x8, #0x2b000
0x00006790  ldr      d0, [x8, #0x1e8]
0x00006794  adrp     x8, #0x6000
0x00006798  add      x8, x8, #0x7fc
0x0000679c  str      d0, [sp, #0x10]
0x000067a0  adrp     x9, #0x34000
0x000067a4  add      x9, x9, #0x650
0x000067a8  stp      x8, x9, [sp, #0x18]
0x000067ac  str      x19, [sp, #0x28]
0x000067b0  add      x1, sp, #8
0x000067b4  mov      x0, #0
0x000067b8  bl       #0x2456c   ; call _dispatch_block_create
0x000067bc  ldr      x8, [x20, #0x9d8]
0x000067c0  str      x0, [x20, #0x9d8]
0x000067c4  mov      x0, x8
0x000067c8  bl       #0x2480c   ; call _objc_release
0x000067cc  mov      x0, #0
0x000067d0  mov      w1, #0xb280
0x000067d4  movk     w1, #0xee6, lsl #16
0x000067d8  bl       #0x245cc   ; call _dispatch_time
0x000067dc  ldr      x2, [x20, #0x9d8]
0x000067e0  adrp     x1, #0x34000
0x000067e4  ldr      x1, [x1, #0x290]   ; -> [got:__dispatch_main_q]
0x000067e8  bl       #0x24548   ; call _dispatch_after
0x000067ec  ldp      x29, x30, [sp, #0x40]
0x000067f0  ldp      x20, x19, [sp, #0x30]
0x000067f4  add      sp, sp, #0x50
0x000067f8  ret      
0x000067fc  sub      sp, sp, #0x60
0x00006800  stp      x26, x25, [sp, #0x10]
0x00006804  stp      x24, x23, [sp, #0x20]
0x00006808  stp      x22, x21, [sp, #0x30]
0x0000680c  stp      x20, x19, [sp, #0x40]
0x00006810  stp      x29, x30, [sp, #0x50]
0x00006814  add      x29, sp, #0x50
0x00006818  mov      x19, x0
0x0000681c  adrp     x8, #0x3e000
0x00006820  ldr      x0, [x8, #0x9d8]
0x00006824  str      xzr, [x8, #0x9d8]
0x00006828  bl       #0x2480c   ; call _objc_release
0x0000682c  ldr      x22, [x19, #0x20]
0x00006830  adrp     x23, #0x3e000
0x00006834  ldr      w8, [x23, #0x9e0]
0x00006838  cbnz     w8, #0x6850
0x0000683c  adrp     x0, #0x29000
0x00006840  add      x0, x0, #0x173   ; -> "com.anlai.omnicar/appbridge.apporient"
0x00006844  adrp     x1, #0x3e000
0x00006848  add      x1, x1, #0x9e0
0x0000684c  bl       #0x246f8   ; call _notify_register_check
0x00006850  bl       #0x612c   ; call sub_612c
0x00006854  mov      x20, x0
0x00006858  adrp     x8, #0x3e000
0x0000685c  ldr      x0, [x8, #0x280]   ; -> [class(NSBundle)]
0x00006860  bl       #0x26080   ; objc_msgSend: mainBundle
0x00006864  mov      x29, x29
0x00006868  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000686c  mov      x19, x0
0x00006870  bl       #0x25040   ; objc_msgSend: bundleIdentifier
0x00006874  mov      x29, x29
0x00006878  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000687c  mov      x21, x0
0x00006880  bl       #0x24818   ; call _objc_retain
0x00006884  mov      x0, x21
0x00006888  bl       #0x24824   ; call _objc_retainAutorelease
0x0000688c  bl       #0x24a40   ; objc_msgSend: UTF8String
0x00006890  mov      x24, #0xc5000000
0x00006894  movk     x24, #0x1c9d, lsl #32
0x00006898  movk     x24, #0x81, lsl #48
0x0000689c  cbz      x0, #0x68d0
0x000068a0  ldrb     w8, [x0]
0x000068a4  cbz      w8, #0x68d0
0x000068a8  add      x10, x0, #1
0x000068ac  mov      w9, #0x9dc5
0x000068b0  movk     w9, #0x811c, lsl #16
0x000068b4  mov      w11, #0x193
0x000068b8  movk     w11, #0x100, lsl #16
0x000068bc  eor      w8, w9, w8
0x000068c0  mul      w9, w8, w11
0x000068c4  ldrb     w8, [x10], #1
0x000068c8  cbnz     w8, #0x68bc
0x000068cc  ubfiz    x24, x9, #0x18, #0x20
0x000068d0  mov      x0, x21
0x000068d4  bl       #0x2480c   ; call _objc_release
0x000068d8  and      x25, x22, #0xff
0x000068dc  bfi      x25, x20, #8, #0x10
0x000068e0  mov      x0, x21
0x000068e4  bl       #0x2480c   ; call _objc_release
0x000068e8  mov      x0, x19
0x000068ec  bl       #0x2480c   ; call _objc_release
0x000068f0  ldr      w0, [x23, #0x9e0]
0x000068f4  orr      x1, x25, x24
0x000068f8  bl       #0x24710   ; call _notify_set_state
0x000068fc  adrp     x0, #0x29000
0x00006900  add      x0, x0, #0x173   ; -> "com.anlai.omnicar/appbridge.apporient"
0x00006904  bl       #0x246ec   ; call _notify_post
0x00006908  adrp     x8, #0x3e000
0x0000690c  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x00006910  stp      x22, x20, [sp]
0x00006914  adrp     x2, #0x35000
0x00006918  add      x2, x2, #0x10   ; -> @"bao SpringBoard: ma %lld, mask %lu"
0x0000691c  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00006920  mov      x29, x29
0x00006924  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006928  mov      x19, x0
0x0000692c  adrp     x0, #0x34000
0x00006930  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00006934  mov      x1, x19
0x00006938  bl       #0x1dd30   ; call _OMCLogWrite
0x0000693c  mov      x0, x19
0x00006940  ldp      x29, x30, [sp, #0x50]
0x00006944  ldp      x20, x19, [sp, #0x40]
0x00006948  ldp      x22, x21, [sp, #0x30]
0x0000694c  ldp      x24, x23, [sp, #0x20]
0x00006950  ldp      x26, x25, [sp, #0x10]
0x00006954  add      sp, sp, #0x60
0x00006958  b        #0x2480c   ; call _objc_release
0x0000695c  b        #0x6978   ; call sub_6978
0x00006960  mov      x20, x0
0x00006964  mov      x0, x21
0x00006968  bl       #0x2480c   ; call _objc_release
0x0000696c  mov      x0, x21
0x00006970  bl       #0x2480c   ; call _objc_release
0x00006974  b        #0x697c   ; call sub_697c
0x00006978  mov      x20, x0
0x0000697c  mov      x0, x19
0x00006980  bl       #0x2480c   ; call _objc_release
0x00006984  mov      x0, x20
0x00006988  bl       #0x24470   ; call __Unwind_Resume
0x0000698c  stp      x22, x21, [sp, #-0x30]!
0x00006990  stp      x20, x19, [sp, #0x10]
0x00006994  stp      x29, x30, [sp, #0x20]
0x00006998  add      x29, sp, #0x20
0x0000699c  mov      x19, x0
0x000069a0  bl       #0x24818   ; call _objc_retain
0x000069a4  adrp     x8, #0x3e000
0x000069a8  ldr      w8, [x8, #0x7d0]
0x000069ac  cmp      w8, #1
0x000069b0  b.lt     #0x6a38
0x000069b4  adrp     x8, #0x3d000
0x000069b8  ldr      x1, [x8, #0xca8]   ; -> [@selector(setInputView:)]
0x000069bc  mov      x0, x19
0x000069c0  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x000069c4  tbz      w0, #0, #0x6a38
0x000069c8  mov      x0, x19
0x000069cc  bl       #0x25ae0   ; objc_msgSend: inputView
0x000069d0  mov      x29, x29
0x000069d4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000069d8  mov      x20, x0
0x000069dc  bl       #0x2480c   ; call _objc_release
0x000069e0  cbnz     x20, #0x6a38
0x000069e4  adrp     x8, #0x3e000
0x000069e8  ldr      x0, [x8, #0x2d0]   ; -> [class(UIView)]
0x000069ec  bl       #0x2471c   ; call _objc_alloc
0x000069f0  adrp     x8, #0x34000
0x000069f4  ldr      x8, [x8, #0x570]   ; -> [got:_CGRectZero]
0x000069f8  ldp      d0, d1, [x8]
0x000069fc  ldp      d2, d3, [x8, #0x10]
0x00006a00  bl       #0x25a40   ; objc_msgSend: initWithFrame:
0x00006a04  mov      x20, x0
0x00006a08  mov      x0, x19
0x00006a0c  mov      x2, x20
0x00006a10  bl       #0x271a0   ; objc_msgSend: setInputView:
0x00006a14  mov      x0, x20
0x00006a18  bl       #0x2480c   ; call _objc_release
0x00006a1c  adrp     x1, #0x3e000
0x00006a20  add      x1, x1, #0x9e4
0x00006a24  adrp     x2, #0x34000
0x00006a28  ldr      x2, [x2, #0x208]   ; -> [got:___kCFBooleanTrue]
0x00006a2c  mov      x0, x19
0x00006a30  mov      w3, #1
0x00006a34  bl       #0x24848   ; call _objc_setAssociatedObject
0x00006a38  mov      x0, x19
0x00006a3c  ldp      x29, x30, [sp, #0x20]
0x00006a40  ldp      x20, x19, [sp, #0x10]
0x00006a44  ldp      x22, x21, [sp], #0x30
0x00006a48  b        #0x2480c   ; call _objc_release
0x00006a4c  mov      x21, x0
0x00006a50  mov      x0, x20
0x00006a54  bl       #0x2480c   ; call _objc_release
0x00006a58  b        #0x6a60   ; call sub_6a60
0x00006a5c  mov      x21, x0
0x00006a60  mov      x0, x19
0x00006a64  bl       #0x2480c   ; call _objc_release
0x00006a68  mov      x0, x21
0x00006a6c  bl       #0x24470   ; call __Unwind_Resume
0x00006a70  stp      x20, x19, [sp, #-0x20]!
0x00006a74  stp      x29, x30, [sp, #0x10]
0x00006a78  add      x29, sp, #0x10
0x00006a7c  mov      x19, x0
0x00006a80  bl       #0x24818   ; call _objc_retain
0x00006a84  adrp     x8, #0x3e000
0x00006a88  ldr      w8, [x8, #0x7d0]
0x00006a8c  cmp      w8, #1
0x00006a90  b.lt     #0x6ab0
0x00006a94  adrp     x0, #0x3e000
0x00006a98  add      x0, x0, #0x930
0x00006a9c  mov      x1, x19
0x00006aa0  bl       #0x2486c   ; call _objc_storeWeak
0x00006aa4  mov      w0, #1
0x00006aa8  mov      x1, x19
0x00006aac  bl       #0x6ad4   ; call sub_6ad4
0x00006ab0  mov      x0, x19
0x00006ab4  ldp      x29, x30, [sp, #0x10]
0x00006ab8  ldp      x20, x19, [sp], #0x20
0x00006abc  b        #0x2480c   ; call _objc_release
0x00006ac0  mov      x20, x0
0x00006ac4  mov      x0, x19
0x00006ac8  bl       #0x2480c   ; call _objc_release
0x00006acc  mov      x0, x20
0x00006ad0  bl       #0x24470   ; call __Unwind_Resume
0x00006ad4  sub      sp, sp, #0x60
0x00006ad8  stp      x26, x25, [sp, #0x10]
0x00006adc  stp      x24, x23, [sp, #0x20]
0x00006ae0  stp      x22, x21, [sp, #0x30]
0x00006ae4  stp      x20, x19, [sp, #0x40]
0x00006ae8  stp      x29, x30, [sp, #0x50]
0x00006aec  add      x29, sp, #0x50
0x00006af0  mov      x19, x1
0x00006af4  mov      x20, x0
0x00006af8  mov      x0, x1
0x00006afc  bl       #0x24818   ; call _objc_retain
0x00006b00  adrp     x21, #0x3e000
0x00006b04  ldr      w8, [x21, #0x9e8]
0x00006b08  cbnz     w8, #0x6b20
0x00006b0c  adrp     x0, #0x29000
0x00006b10  add      x0, x0, #0x1bc   ; -> "com.anlai.omnicar/appbridge.keyboard"
0x00006b14  adrp     x1, #0x3e000
0x00006b18  add      x1, x1, #0x9e8
0x00006b1c  bl       #0x246f8   ; call _notify_register_check
0x00006b20  mov      x0, x19
0x00006b24  bl       #0x24818   ; call _objc_retain
0x00006b28  cbz      w20, #0x6b54
0x00006b2c  adrp     x8, #0x3d000
0x00006b30  ldr      x1, [x8, #0x7c8]   ; -> [@selector(keyboardType)]
0x00006b34  mov      x0, x19
0x00006b38  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00006b3c  tbz      w0, #0, #0x6b5c
0x00006b40  mov      x0, x19
0x00006b44  bl       #0x25e20   ; objc_msgSend: keyboardType
0x00006b48  mov      w24, w20
0x00006b4c  bfi      x24, x0, #1, #7
0x00006b50  b        #0x6b60   ; call sub_6b60
0x00006b54  mov      x24, #0
0x00006b58  b        #0x6b80   ; call sub_6b80
0x00006b5c  mov      w24, #1
0x00006b60  adrp     x8, #0x3d000
0x00006b64  ldr      x1, [x8, #0xaa0]   ; -> [@selector(returnKeyType)]
0x00006b68  mov      x0, x19
0x00006b6c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00006b70  tbz      w0, #0, #0x6b80
0x00006b74  mov      x0, x19
0x00006b78  bl       #0x26980   ; objc_msgSend: returnKeyType
0x00006b7c  bfi      x24, x0, #8, #8
0x00006b80  ldr      w23, [x21, #0x9e8]
0x00006b84  adrp     x8, #0x3e000
0x00006b88  ldr      x0, [x8, #0x280]   ; -> [class(NSBundle)]
0x00006b8c  bl       #0x26080   ; objc_msgSend: mainBundle
0x00006b90  mov      x29, x29
0x00006b94  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006b98  mov      x21, x0
0x00006b9c  bl       #0x25040   ; objc_msgSend: bundleIdentifier
0x00006ba0  mov      x29, x29
0x00006ba4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006ba8  mov      x22, x0
0x00006bac  bl       #0x24818   ; call _objc_retain
0x00006bb0  mov      x0, x22
0x00006bb4  bl       #0x24824   ; call _objc_retainAutorelease
0x00006bb8  bl       #0x24a40   ; objc_msgSend: UTF8String
0x00006bbc  mov      x25, #0xc5000000
0x00006bc0  movk     x25, #0x1c9d, lsl #32
0x00006bc4  movk     x25, #0x81, lsl #48
0x00006bc8  cbz      x0, #0x6bfc
0x00006bcc  ldrb     w8, [x0]
0x00006bd0  cbz      w8, #0x6bfc
0x00006bd4  add      x10, x0, #1
0x00006bd8  mov      w9, #0x9dc5
0x00006bdc  movk     w9, #0x811c, lsl #16
0x00006be0  mov      w11, #0x193
0x00006be4  movk     w11, #0x100, lsl #16
0x00006be8  eor      w8, w9, w8
0x00006bec  mul      w9, w8, w11
0x00006bf0  ldrb     w8, [x10], #1
0x00006bf4  cbnz     w8, #0x6be8
0x00006bf8  ubfiz    x25, x9, #0x18, #0x20
0x00006bfc  mov      x0, x22
0x00006c00  bl       #0x2480c   ; call _objc_release
0x00006c04  orr      x1, x25, x24
0x00006c08  mov      x0, x23
0x00006c0c  bl       #0x24710   ; call _notify_set_state
0x00006c10  mov      x0, x22
0x00006c14  bl       #0x2480c   ; call _objc_release
0x00006c18  mov      x0, x21
0x00006c1c  bl       #0x2480c   ; call _objc_release
0x00006c20  adrp     x0, #0x29000
0x00006c24  add      x0, x0, #0x1bc   ; -> "com.anlai.omnicar/appbridge.keyboard"
0x00006c28  bl       #0x246ec   ; call _notify_post
0x00006c2c  adrp     x8, #0x3e000
0x00006c30  ldr      x22, [x8, #0x290]   ; -> [class(NSString)]
0x00006c34  adrp     x8, #0x35000
0x00006c38  add      x8, x8, #0x70   ; -> @"an"
0x00006c3c  adrp     x9, #0x35000
0x00006c40  add      x9, x9, #0x50   ; -> @"hien"
0x00006c44  cmp      w20, #0
0x00006c48  csel     x20, x9, x8, ne
0x00006c4c  cbz      x19, #0x6c6c
0x00006c50  mov      x0, x19
0x00006c54  bl       #0x247d0   ; call _objc_opt_class
0x00006c58  bl       #0x2444c   ; call _NSStringFromClass
0x00006c5c  mov      x29, x29
0x00006c60  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006c64  mov      x21, x0
0x00006c68  b        #0x6c74   ; call sub_6c74
0x00006c6c  adrp     x21, #0x35000
0x00006c70  add      x21, x21, #0x90   ; -> @"-"
0x00006c74  stp      x20, x21, [sp]
0x00006c78  adrp     x2, #0x35000
0x00006c7c  add      x2, x2, #0x30   ; -> @"ban phim xe: %@ (%@)"
0x00006c80  mov      x0, x22
0x00006c84  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00006c88  mov      x29, x29
0x00006c8c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006c90  mov      x22, x0
0x00006c94  adrp     x0, #0x34000
0x00006c98  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00006c9c  mov      x1, x22
0x00006ca0  bl       #0x1dd30   ; call _OMCLogWrite
0x00006ca4  mov      x0, x22
0x00006ca8  bl       #0x2480c   ; call _objc_release
0x00006cac  cbz      x19, #0x6cb8
0x00006cb0  mov      x0, x21
0x00006cb4  bl       #0x2480c   ; call _objc_release
0x00006cb8  mov      x0, x19
0x00006cbc  bl       #0x2480c   ; call _objc_release
0x00006cc0  mov      x0, x19
0x00006cc4  ldp      x29, x30, [sp, #0x50]
0x00006cc8  ldp      x20, x19, [sp, #0x40]
0x00006ccc  ldp      x22, x21, [sp, #0x30]
0x00006cd0  ldp      x24, x23, [sp, #0x20]
0x00006cd4  ldp      x26, x25, [sp, #0x10]
0x00006cd8  add      sp, sp, #0x60
0x00006cdc  b        #0x2480c   ; call _objc_release
0x00006ce0  mov      x20, x0
0x00006ce4  b        #0x6d40   ; call sub_6d40
0x00006ce8  mov      x20, x0
0x00006cec  mov      x0, x22
0x00006cf0  bl       #0x2480c   ; call _objc_release
0x00006cf4  b        #0x6cfc   ; call sub_6cfc
0x00006cf8  mov      x20, x0
0x00006cfc  cbnz     x19, #0x6d28
0x00006d00  b        #0x6d38   ; call sub_6d38
0x00006d04  mov      x20, x0
0x00006d08  b        #0x6d18   ; call sub_6d18
0x00006d0c  mov      x20, x0
0x00006d10  mov      x0, x22
0x00006d14  bl       #0x2480c   ; call _objc_release
0x00006d18  mov      x0, x22
0x00006d1c  bl       #0x2480c   ; call _objc_release
0x00006d20  b        #0x6d28   ; call sub_6d28
0x00006d24  mov      x20, x0
0x00006d28  mov      x0, x21
0x00006d2c  bl       #0x2480c   ; call _objc_release
0x00006d30  b        #0x6d38   ; call sub_6d38
0x00006d34  mov      x20, x0
0x00006d38  mov      x0, x19
0x00006d3c  bl       #0x2480c   ; call _objc_release
0x00006d40  mov      x0, x19
0x00006d44  bl       #0x2480c   ; call _objc_release
0x00006d48  mov      x0, x20
0x00006d4c  bl       #0x24470   ; call __Unwind_Resume
0x00006d50  stp      x20, x19, [sp, #-0x20]!
0x00006d54  stp      x29, x30, [sp, #0x10]
0x00006d58  add      x29, sp, #0x10
0x00006d5c  mov      x19, x0
0x00006d60  bl       #0x24818   ; call _objc_retain
0x00006d64  adrp     x1, #0x3e000
0x00006d68  add      x1, x1, #0x9e4
0x00006d6c  mov      x0, x19
0x00006d70  bl       #0x2477c   ; call _objc_getAssociatedObject
0x00006d74  mov      x29, x29
0x00006d78  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006d7c  mov      x20, x0
0x00006d80  bl       #0x2480c   ; call _objc_release
0x00006d84  cbz      x20, #0x6dac
0x00006d88  adrp     x1, #0x3e000
0x00006d8c  add      x1, x1, #0x9e4
0x00006d90  mov      x0, x19
0x00006d94  mov      x2, #0
0x00006d98  mov      w3, #1
0x00006d9c  bl       #0x24848   ; call _objc_setAssociatedObject
0x00006da0  mov      x0, x19
0x00006da4  mov      x2, #0
0x00006da8  bl       #0x271a0   ; objc_msgSend: setInputView:
0x00006dac  adrp     x0, #0x3e000
0x00006db0  add      x0, x0, #0x930
0x00006db4  bl       #0x247a0   ; call _objc_loadWeakRetained
0x00006db8  mov      x20, x0
0x00006dbc  bl       #0x2480c   ; call _objc_release
0x00006dc0  cmp      x20, x19
0x00006dc4  b.ne     #0x6de4
0x00006dc8  adrp     x0, #0x3e000
0x00006dcc  add      x0, x0, #0x930
0x00006dd0  mov      x1, #0
0x00006dd4  bl       #0x2486c   ; call _objc_storeWeak
0x00006dd8  mov      w0, #0
0x00006ddc  mov      x1, #0
0x00006de0  bl       #0x6ad4   ; call sub_6ad4
0x00006de4  mov      x0, x19
0x00006de8  ldp      x29, x30, [sp, #0x10]
0x00006dec  ldp      x20, x19, [sp], #0x20
0x00006df0  b        #0x2480c   ; call _objc_release
0x00006df4  mov      x20, x0
0x00006df8  mov      x0, x19
0x00006dfc  bl       #0x2480c   ; call _objc_release
0x00006e00  mov      x0, x20
0x00006e04  bl       #0x24470   ; call __Unwind_Resume

