; block literal @0x34770 desc @0x34750 sig=v12@?0i8 flags=0x50000000
; ==== sub_92b4 @ 0x92b4..0x93b0 (252 bytes) ====
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

