; ==== sub_9220 @ 0x9220..0x943c (540 bytes) ====
0x00009220  mov      x0, x20
0x00009224  bl       #0x2480c   ; call _objc_release
0x00009228  b        #0x9234   ; call sub_9234
0x0000922c  mov      x23, x1
0x00009230  mov      x21, x0
0x00009234  cmp      w23, #1
0x00009238  b.ne     #0x92a4
0x0000923c  mov      x0, x21
0x00009240  bl       #0x24740   ; call _objc_begin_catch
0x00009244  adrp     x8, #0x3e000
0x00009248  ldr      x8, [x8, #0x290]   ; -> [class(NSString)]
0x0000924c  str      x0, [sp]
0x00009250  adrp     x2, #0x35000
0x00009254  add      x2, x2, #0x850   ; -> @"knobs loi %@"
0x00009258  mov      x0, x8
0x0000925c  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00009260  mov      x29, x29
0x00009264  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009268  mov      x20, x0
0x0000926c  adrp     x0, #0x34000
0x00009270  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00009274  mov      x1, x20
0x00009278  bl       #0x1dd30   ; call _OMCLogWrite
0x0000927c  mov      x0, x20
0x00009280  bl       #0x2480c   ; call _objc_release
0x00009284  bl       #0x24764   ; call _objc_end_catch
0x00009288  b        #0x91d0   ; call sub_91d0
0x0000928c  mov      x21, x0
0x00009290  mov      x0, x20
0x00009294  bl       #0x2480c   ; call _objc_release
0x00009298  b        #0x92a0   ; call sub_92a0
0x0000929c  mov      x21, x0
0x000092a0  bl       #0x24764   ; call _objc_end_catch
0x000092a4  mov      x0, x19
0x000092a8  bl       #0x2480c   ; call _objc_release
0x000092ac  mov      x0, x21
0x000092b0  bl       #0x24470   ; call __Unwind_Resume
0x000092b4  sub      sp, sp, #0x30
0x000092b8  stp      x20, x19, [sp, #0x10]
0x000092bc  stp      x29, x30, [sp, #0x20]
0x000092c0  add      x29, sp, #0x20
0x000092c4  mov      x0, x1
0x000092c8  str      xzr, [sp, #8]
0x000092cc  add      x1, sp, #8
0x000092d0  bl       #0x246e0   ; call _notify_get_state
0x000092d4  ldr      x20, [sp, #8]
0x000092d8  adrp     x8, #0x3e000
0x000092dc  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x000092e0  bl       #0x27b20   ; objc_msgSend: shared
0x000092e4  mov      x29, x29
0x000092e8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000092ec  mov      x19, x0
0x000092f0  ubfx     x4, x20, #8, #0x10
0x000092f4  lsr      x2, x20, #0x18
0x000092f8  and      w3, w20, #0xff
0x000092fc  bl       #0x24d20   ; objc_msgSend: appWithHash:changedOrientation:supportedMask:
0x00009300  mov      x0, x19
0x00009304  bl       #0x2480c   ; call _objc_release
0x00009308  ldp      x29, x30, [sp, #0x20]
0x0000930c  ldp      x20, x19, [sp, #0x10]
0x00009310  add      sp, sp, #0x30
0x00009314  ret      
0x00009318  mov      x20, x1
0x0000931c  mov      x1, x19
0x00009320  mov      x19, x0
0x00009324  mov      x0, x1
0x00009328  bl       #0x2480c   ; call _objc_release
0x0000932c  b        #0x9338   ; call sub_9338
0x00009330  mov      x20, x1
0x00009334  mov      x19, x0
0x00009338  cmp      w20, #1
0x0000933c  b.ne     #0x93a8
0x00009340  mov      x0, x19
0x00009344  bl       #0x24740   ; call _objc_begin_catch
0x00009348  adrp     x8, #0x3e000
0x0000934c  ldr      x8, [x8, #0x290]   ; -> [class(NSString)]
0x00009350  str      x0, [sp]
0x00009354  adrp     x2, #0x35000
0x00009358  add      x2, x2, #0x870   ; -> @"apporient loi %@"
0x0000935c  mov      x0, x8
0x00009360  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00009364  mov      x29, x29
0x00009368  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000936c  mov      x20, x0
0x00009370  adrp     x0, #0x34000
0x00009374  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00009378  mov      x1, x20
0x0000937c  bl       #0x1dd30   ; call _OMCLogWrite
0x00009380  mov      x0, x20
0x00009384  bl       #0x2480c   ; call _objc_release
0x00009388  bl       #0x24764   ; call _objc_end_catch
0x0000938c  b        #0x9308   ; call sub_9308
0x00009390  mov      x19, x0
0x00009394  mov      x0, x20
0x00009398  bl       #0x2480c   ; call _objc_release
0x0000939c  b        #0x93a4   ; call sub_93a4
0x000093a0  mov      x19, x0
0x000093a4  bl       #0x24764   ; call _objc_end_catch
0x000093a8  mov      x0, x19
0x000093ac  bl       #0x24470   ; call __Unwind_Resume
0x000093b0  sub      sp, sp, #0x40
0x000093b4  stp      x22, x21, [sp, #0x10]
0x000093b8  stp      x20, x19, [sp, #0x20]
0x000093bc  stp      x29, x30, [sp, #0x30]
0x000093c0  add      x29, sp, #0x30
0x000093c4  mov      x0, x1
0x000093c8  str      xzr, [sp, #8]
0x000093cc  add      x1, sp, #8
0x000093d0  bl       #0x246e0   ; call _notify_get_state
0x000093d4  adrp     x8, #0x3e000
0x000093d8  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x000093dc  bl       #0x27b20   ; objc_msgSend: shared
0x000093e0  mov      x29, x29
0x000093e4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000093e8  mov      x20, x0
0x000093ec  ldr      x8, [sp, #8]
0x000093f0  lsr      x2, x8, #0x18
0x000093f4  bl       #0x25000   ; objc_msgSend: bundleForHash:
0x000093f8  mov      x29, x29
0x000093fc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009400  mov      x19, x0
0x00009404  mov      x0, x20
0x00009408  bl       #0x2480c   ; call _objc_release
0x0000940c  cbz      x19, #0x943c
0x00009410  adrp     x8, #0x3e000
0x00009414  ldr      x0, [x8, #0x2e8]   ; -> [class(ABKeyboard)]
0x00009418  ldrb     w8, [sp, #8]
0x0000941c  tbnz     w8, #0, #0x947c
0x00009420  bl       #0x27b20   ; objc_msgSend: shared
0x00009424  mov      x29, x29
0x00009428  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000942c  mov      x20, x0
0x00009430  mov      x2, x19
0x00009434  bl       #0x25900   ; objc_msgSend: hideForApp:
0x00009438  b        #0x94a0   ; call sub_94a0
