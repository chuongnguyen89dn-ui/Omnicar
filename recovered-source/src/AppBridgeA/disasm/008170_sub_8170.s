; ==== sub_8170 @ 0x8170..0x82ac (316 bytes) ====
0x00008170  b.ne     #0x8250
0x00008174  mov      x0, x21
0x00008178  bl       #0x24740   ; call _objc_begin_catch
0x0000817c  mov      x22, x0
0x00008180  bl       #0x24818   ; call _objc_retain
0x00008184  adrp     x8, #0x3e000
0x00008188  ldr      x19, [x8, #0x290]   ; -> [class(NSString)]
0x0000818c  mov      x0, x22
0x00008190  bl       #0x250c0   ; objc_msgSend: callStackSymbols
0x00008194  mov      x29, x29
0x00008198  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000819c  mov      x23, x0
0x000081a0  stp      x22, x0, [sp]
0x000081a4  adrp     x2, #0x35000
0x000081a8  add      x2, x2, #0x650   ; -> @"open loi %@
%@"
0x000081ac  mov      x0, x19
0x000081b0  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x000081b4  mov      x29, x29
0x000081b8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000081bc  mov      x19, x0
0x000081c0  adrp     x0, #0x34000
0x000081c4  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x000081c8  mov      x1, x19
0x000081cc  bl       #0x1dd30   ; call _OMCLogWrite
0x000081d0  mov      x0, x19
0x000081d4  bl       #0x2480c   ; call _objc_release
0x000081d8  mov      x0, x23
0x000081dc  bl       #0x2480c   ; call _objc_release
0x000081e0  mov      x0, x22
0x000081e4  bl       #0x2480c   ; call _objc_release
0x000081e8  bl       #0x24764   ; call _objc_end_catch
0x000081ec  b        #0x7f94   ; call sub_7f94
0x000081f0  mov      x21, x0
0x000081f4  mov      x0, x19
0x000081f8  bl       #0x2480c   ; call _objc_release
0x000081fc  b        #0x8204   ; call sub_8204
0x00008200  mov      x21, x0
0x00008204  mov      x0, x23
0x00008208  bl       #0x2480c   ; call _objc_release
0x0000820c  b        #0x8214   ; call sub_8214
0x00008210  mov      x21, x0
0x00008214  mov      x0, x22
0x00008218  bl       #0x2480c   ; call _objc_release
0x0000821c  bl       #0x24764   ; call _objc_end_catch
0x00008220  b        #0x8250   ; call sub_8250
0x00008224  mov      x21, x0
0x00008228  mov      x0, x24
0x0000822c  bl       #0x2480c   ; call _objc_release
0x00008230  b        #0x8238   ; call sub_8238
0x00008234  mov      x21, x0
0x00008238  mov      x0, x23
0x0000823c  bl       #0x2480c   ; call _objc_release
0x00008240  b        #0x8248   ; call sub_8248
0x00008244  mov      x21, x0
0x00008248  mov      x0, x22
0x0000824c  bl       #0x2480c   ; call _objc_release
0x00008250  mov      x0, x20
0x00008254  bl       #0x2480c   ; call _objc_release
0x00008258  ldr      x0, [sp, #0x28]
0x0000825c  bl       #0x2480c   ; call _objc_release
0x00008260  mov      x0, x21
0x00008264  bl       #0x24470   ; call __Unwind_Resume
0x00008268  mov      x22, x1
0x0000826c  mov      x21, x0
0x00008270  b        #0x816c   ; call sub_816c
0x00008274  sub      sp, sp, #0xc0
0x00008278  stp      d15, d14, [sp, #0x20]
0x0000827c  stp      d13, d12, [sp, #0x30]
0x00008280  stp      d11, d10, [sp, #0x40]
0x00008284  stp      d9, d8, [sp, #0x50]
0x00008288  stp      x28, x27, [sp, #0x60]
0x0000828c  stp      x26, x25, [sp, #0x70]
0x00008290  stp      x24, x23, [sp, #0x80]
0x00008294  stp      x22, x21, [sp, #0x90]
0x00008298  stp      x20, x19, [sp, #0xa0]
0x0000829c  stp      x29, x30, [sp, #0xb0]
0x000082a0  add      x29, sp, #0xb0
0x000082a4  mov      x19, x1
0x000082a8  mov      x0, x1
