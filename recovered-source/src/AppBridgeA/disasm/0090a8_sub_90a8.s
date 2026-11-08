; ==== sub_90a8 @ 0x90a8..0x9144 (156 bytes) ====
0x000090a8  mov      x23, x1
0x000090ac  mov      x21, x0
0x000090b0  mov      x0, x20
0x000090b4  bl       #0x2480c   ; call _objc_release
0x000090b8  b        #0x90c4   ; call sub_90c4
0x000090bc  mov      x23, x1
0x000090c0  mov      x21, x0
0x000090c4  cmp      w23, #1
0x000090c8  b.ne     #0x9134
0x000090cc  mov      x0, x21
0x000090d0  bl       #0x24740   ; call _objc_begin_catch
0x000090d4  adrp     x8, #0x3e000
0x000090d8  ldr      x8, [x8, #0x290]   ; -> [class(NSString)]
0x000090dc  str      x0, [sp]
0x000090e0  adrp     x2, #0x35000
0x000090e4  add      x2, x2, #0x7f0   ; -> @"closeall loi %@"
0x000090e8  mov      x0, x8
0x000090ec  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x000090f0  mov      x29, x29
0x000090f4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000090f8  mov      x20, x0
0x000090fc  adrp     x0, #0x34000
0x00009100  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00009104  mov      x1, x20
0x00009108  bl       #0x1dd30   ; call _OMCLogWrite
0x0000910c  mov      x0, x20
0x00009110  bl       #0x2480c   ; call _objc_release
0x00009114  bl       #0x24764   ; call _objc_end_catch
0x00009118  b        #0x9060   ; call sub_9060
0x0000911c  mov      x21, x0
0x00009120  mov      x0, x20
0x00009124  bl       #0x2480c   ; call _objc_release
0x00009128  b        #0x9130   ; call sub_9130
0x0000912c  mov      x21, x0
0x00009130  bl       #0x24764   ; call _objc_end_catch
0x00009134  mov      x0, x19
0x00009138  bl       #0x2480c   ; call _objc_release
0x0000913c  mov      x0, x21
0x00009140  bl       #0x24470   ; call __Unwind_Resume
