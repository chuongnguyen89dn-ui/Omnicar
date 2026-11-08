; ==== sub_152b0 @ 0x152b0..0x15690 (992 bytes) ====
0x000152b0  mov      x20, x0
0x000152b4  mov      x0, x21
0x000152b8  bl       #0x2480c   ; call _objc_release
0x000152bc  b        #0x152c4   ; call sub_152c4
0x000152c0  mov      x20, x0
0x000152c4  mov      x0, x19
0x000152c8  bl       #0x2480c   ; call _objc_release
0x000152cc  mov      x0, x20
0x000152d0  bl       #0x24470   ; call __Unwind_Resume
0x000152d4  sub      sp, sp, #0x150
0x000152d8  stp      x28, x27, [sp, #0xf0]
0x000152dc  stp      x26, x25, [sp, #0x100]
0x000152e0  stp      x24, x23, [sp, #0x110]
0x000152e4  stp      x22, x21, [sp, #0x120]
0x000152e8  stp      x20, x19, [sp, #0x130]
0x000152ec  stp      x29, x30, [sp, #0x140]
0x000152f0  add      x29, sp, #0x140
0x000152f4  mov      x19, x2
0x000152f8  mov      x20, x0
0x000152fc  adrp     x8, #0x34000
0x00015300  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00015304  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00015308  stur     x8, [x29, #-0x58]
0x0001530c  mov      x0, x2
0x00015310  bl       #0x24818   ; call _objc_retain
0x00015314  movi     v0.16b, #0
0x00015318  stp      q0, q0, [sp, #0x10]
0x0001531c  stp      q0, q0, [sp, #0x30]
0x00015320  mov      x0, x20
0x00015324  bl       #0x26580   ; objc_msgSend: panes
0x00015328  mov      x29, x29
0x0001532c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015330  mov      x20, x0
0x00015334  add      x2, sp, #0x10
0x00015338  add      x3, sp, #0x68
0x0001533c  mov      w4, #0x10
0x00015340  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00015344  mov      x22, x0
0x00015348  cbz      x0, #0x154d0
0x0001534c  ldr      x8, [sp, #0x20]
0x00015350  ldr      x24, [x8]   ; -> [got:___objc_personality_v0]
0x00015354  mov      x25, #0
0x00015358  ldr      x8, [sp, #0x20]
0x0001535c  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00015360  cmp      x8, x24
0x00015364  b.eq     #0x15370
0x00015368  mov      x0, x20
0x0001536c  bl       #0x24770   ; call _objc_enumerationMutation
0x00015370  ldr      x8, [sp, #0x18]
0x00015374  ldr      x21, [x8, x25, lsl #3]   ; -> [got:___objc_personality_v0]
0x00015378  mov      x0, x21
0x0001537c  bl       #0x25860   ; objc_msgSend: handleHit
0x00015380  mov      x29, x29
0x00015384  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015388  mov      x23, x0
0x0001538c  mov      x0, x19
0x00015390  bl       #0x28140   ; objc_msgSend: view
0x00015394  mov      x29, x29
0x00015398  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001539c  cmp      x23, x0
0x000153a0  cset     w26, eq
0x000153a4  bl       #0x2480c   ; call _objc_release
0x000153a8  mov      x0, x23
0x000153ac  bl       #0x2480c   ; call _objc_release
0x000153b0  tbnz     w26, #0, #0x153e0
0x000153b4  add      x25, x25, #1
0x000153b8  cmp      x22, x25
0x000153bc  b.ne     #0x15358
0x000153c0  add      x2, sp, #0x10
0x000153c4  add      x3, sp, #0x68
0x000153c8  mov      x0, x20
0x000153cc  mov      w4, #0x10
0x000153d0  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x000153d4  mov      x22, x0
0x000153d8  cbnz     x0, #0x15354
0x000153dc  b        #0x154d0   ; call sub_154d0
0x000153e0  adrp     x8, #0x3e000
0x000153e4  ldr      x23, [x8, #0x290]   ; -> [class(NSString)]
0x000153e8  mov      x0, x21
0x000153ec  bl       #0x25020   ; objc_msgSend: bundleID
0x000153f0  mov      x29, x29
0x000153f4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000153f8  mov      x22, x0
0x000153fc  str      x0, [sp]
0x00015400  adrp     x2, #0x36000
0x00015404  add      x2, x2, #0x5f0   ; -> @"c"
0x00015408  mov      x0, x23
0x0001540c  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00015410  mov      x29, x29
0x00015414  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015418  mov      x23, x0
0x0001541c  adrp     x0, #0x34000
0x00015420  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00015424  mov      x1, x23
0x00015428  bl       #0x1dd30   ; call _OMCLogWrite
0x0001542c  mov      x0, x23
0x00015430  bl       #0x2480c   ; call _objc_release
0x00015434  mov      x0, x22
0x00015438  bl       #0x2480c   ; call _objc_release
0x0001543c  adrp     x0, #0x28000
0x00015440  add      x0, x0, #0xfc3   ; -> "NSDistributedNotificationCenter"
0x00015444  bl       #0x24788   ; call _objc_getClass
0x00015448  bl       #0x254c0   ; objc_msgSend: defaultCenter
0x0001544c  mov      x29, x29
0x00015450  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015454  mov      x22, x0
0x00015458  adrp     x8, #0x35000
0x0001545c  add      x8, x8, #0x3b0   ; -> @"identifier"
0x00015460  str      x8, [sp, #0x58]
0x00015464  mov      x0, x21
0x00015468  bl       #0x25020   ; objc_msgSend: bundleID
0x0001546c  mov      x29, x29
0x00015470  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015474  mov      x23, x0
0x00015478  str      x0, [sp, #0x60]
0x0001547c  adrp     x8, #0x3e000
0x00015480  ldr      x0, [x8, #0x310]   ; -> [class(NSDictionary)]
0x00015484  add      x2, sp, #0x60
0x00015488  add      x3, sp, #0x58
0x0001548c  mov      w4, #1
0x00015490  bl       #0x255c0   ; objc_msgSend: dictionaryWithObjects:forKeys:count:
0x00015494  mov      x29, x29
0x00015498  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001549c  mov      x21, x0
0x000154a0  adrp     x2, #0x36000
0x000154a4  add      x2, x2, #0x610   ; -> @"com.anlai.omnicar/appbridge.handletap"
0x000154a8  mov      x0, x22
0x000154ac  mov      x3, #0
0x000154b0  mov      x4, x21
0x000154b4  bl       #0x26620   ; objc_msgSend: postNotificationName:object:userInfo:
0x000154b8  mov      x0, x21
0x000154bc  bl       #0x2480c   ; call _objc_release
0x000154c0  mov      x0, x23
0x000154c4  bl       #0x2480c   ; call _objc_release
0x000154c8  mov      x0, x22
0x000154cc  bl       #0x2480c   ; call _objc_release
0x000154d0  mov      x0, x20
0x000154d4  bl       #0x2480c   ; call _objc_release
0x000154d8  mov      x0, x19
0x000154dc  bl       #0x2480c   ; call _objc_release
0x000154e0  ldur     x8, [x29, #-0x58]
0x000154e4  adrp     x9, #0x34000
0x000154e8  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x000154ec  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x000154f0  cmp      x9, x8
0x000154f4  b.ne     #0x15518
0x000154f8  ldp      x29, x30, [sp, #0x140]
0x000154fc  ldp      x20, x19, [sp, #0x130]
0x00015500  ldp      x22, x21, [sp, #0x120]
0x00015504  ldp      x24, x23, [sp, #0x110]
0x00015508  ldp      x26, x25, [sp, #0x100]
0x0001550c  ldp      x28, x27, [sp, #0xf0]
0x00015510  add      sp, sp, #0x150
0x00015514  ret      
0x00015518  bl       #0x24488   ; call ___stack_chk_fail
0x0001551c  b        #0x15590   ; call sub_15590
0x00015520  mov      x1, x21
0x00015524  mov      x21, x0
0x00015528  mov      x0, x1
0x0001552c  bl       #0x2480c   ; call _objc_release
0x00015530  b        #0x15538   ; call sub_15538
0x00015534  mov      x21, x0
0x00015538  mov      x0, x23
0x0001553c  bl       #0x2480c   ; call _objc_release
0x00015540  b        #0x15548   ; call sub_15548
0x00015544  mov      x21, x0
0x00015548  mov      x0, x22
0x0001554c  bl       #0x2480c   ; call _objc_release
0x00015550  b        #0x15594   ; call sub_15594
0x00015554  mov      x21, x0
0x00015558  mov      x0, x23
0x0001555c  bl       #0x2480c   ; call _objc_release
0x00015560  b        #0x15568   ; call sub_15568
0x00015564  mov      x21, x0
0x00015568  mov      x0, x22
0x0001556c  bl       #0x2480c   ; call _objc_release
0x00015570  b        #0x15594   ; call sub_15594
0x00015574  mov      x21, x0
0x00015578  b        #0x1559c   ; call sub_1559c
0x0001557c  b        #0x15590   ; call sub_15590
0x00015580  mov      x21, x0
0x00015584  mov      x0, x23
0x00015588  bl       #0x2480c   ; call _objc_release
0x0001558c  b        #0x15594   ; call sub_15594
0x00015590  mov      x21, x0
0x00015594  mov      x0, x20
0x00015598  bl       #0x2480c   ; call _objc_release
0x0001559c  mov      x0, x19
0x000155a0  bl       #0x2480c   ; call _objc_release
0x000155a4  mov      x0, x21
0x000155a8  bl       #0x24470   ; call __Unwind_Resume
0x000155ac  bl       #0x24470   ; call __Unwind_Resume
0x000155b0  sub      sp, sp, #0xc0
0x000155b4  stp      d9, d8, [sp, #0x60]
0x000155b8  stp      x26, x25, [sp, #0x70]
0x000155bc  stp      x24, x23, [sp, #0x80]
0x000155c0  stp      x22, x21, [sp, #0x90]
0x000155c4  stp      x20, x19, [sp, #0xa0]
0x000155c8  stp      x29, x30, [sp, #0xb0]
0x000155cc  add      x29, sp, #0xb0
0x000155d0  mov      x19, x2
0x000155d4  mov      x0, x2
0x000155d8  bl       #0x24818   ; call _objc_retain
0x000155dc  mov      x0, x19
0x000155e0  bl       #0x26a40   ; objc_msgSend: sceneMonitor
0x000155e4  mov      x29, x29
0x000155e8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000155ec  mov      x20, x0
0x000155f0  bl       #0x25be0   ; objc_msgSend: invalidate
0x000155f4  mov      x0, x20
0x000155f8  bl       #0x2480c   ; call _objc_release
0x000155fc  mov      x0, x19
0x00015600  mov      x2, #0
0x00015604  bl       #0x276a0   ; objc_msgSend: setSceneMonitor:
0x00015608  mov      x0, x19
0x0001560c  bl       #0x25020   ; objc_msgSend: bundleID
0x00015610  mov      x29, x29
0x00015614  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015618  mov      x20, x0
0x0001561c  mov      x1, #-1
0x00015620  bl       #0xe6b8   ; call sub_e6b8
0x00015624  mov      x0, x19
0x00015628  bl       #0x24d00   ; objc_msgSend: appViewController
0x0001562c  mov      x29, x29
0x00015630  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015634  mov      x21, x0
0x00015638  bl       #0x24818   ; call _objc_retain
0x0001563c  adrp     x0, #0x36000
0x00015640  add      x0, x0, #0x630   ; -> @"_setCurrentMode:"
0x00015644  bl       #0x2441c   ; call _NSSelectorFromString
0x00015648  mov      x22, x0
0x0001564c  mov      x0, x21
0x00015650  mov      x1, x22
0x00015654  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00015658  tbz      w0, #0, #0x15670
0x0001565c  mov      x0, x21
0x00015660  mov      x1, x22
0x00015664  mov      x2, #0
0x00015668  bl       #0x247ac   ; call _objc_msgSend
0x0001566c  b        #0x15680   ; call sub_15680
0x00015670  adrp     x1, #0x36000
0x00015674  add      x1, x1, #0x630   ; -> @"_setCurrentMode:"
0x00015678  mov      x0, x21
0x0001567c  bl       #0x9698   ; call _ABMissingSelector
0x00015680  mov      x0, x21
0x00015684  bl       #0x2480c   ; call _objc_release
0x00015688  mov      x0, x21
0x0001568c  bl       #0x28140   ; objc_msgSend: view
