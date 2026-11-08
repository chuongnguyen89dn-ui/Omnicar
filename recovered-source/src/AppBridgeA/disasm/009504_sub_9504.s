; ==== sub_9504 @ 0x9504..0x95d8 (212 bytes) ====
0x00009504  bl       #0x2480c   ; call _objc_release
0x00009508  b        #0x9514   ; call sub_9514
0x0000950c  mov      x21, x1
0x00009510  mov      x20, x0
0x00009514  cmp      w21, #1
0x00009518  b.ne     #0x9584
0x0000951c  mov      x0, x20
0x00009520  bl       #0x24740   ; call _objc_begin_catch
0x00009524  adrp     x8, #0x3e000
0x00009528  ldr      x8, [x8, #0x290]   ; -> [class(NSString)]
0x0000952c  str      x0, [sp]
0x00009530  adrp     x2, #0x35000
0x00009534  add      x2, x2, #0x8b0   ; -> @"ban phim loi %@"
0x00009538  mov      x0, x8
0x0000953c  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00009540  mov      x29, x29
0x00009544  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009548  mov      x19, x0
0x0000954c  adrp     x0, #0x34000
0x00009550  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00009554  mov      x1, x19
0x00009558  bl       #0x1dd30   ; call _OMCLogWrite
0x0000955c  mov      x0, x19
0x00009560  bl       #0x2480c   ; call _objc_release
0x00009564  bl       #0x24764   ; call _objc_end_catch
0x00009568  b        #0x94b0   ; call sub_94b0
0x0000956c  mov      x20, x0
0x00009570  mov      x0, x19
0x00009574  bl       #0x2480c   ; call _objc_release
0x00009578  b        #0x9580   ; call sub_9580
0x0000957c  mov      x20, x0
0x00009580  bl       #0x24764   ; call _objc_end_catch
0x00009584  mov      x0, x20
0x00009588  bl       #0x24470   ; call __Unwind_Resume
0x0000958c  stp      x20, x19, [sp, #-0x20]!
0x00009590  stp      x29, x30, [sp, #0x10]
0x00009594  add      x29, sp, #0x10
0x00009598  adrp     x0, #0x29000
0x0000959c  add      x0, x0, #0x667   ; -> "AVExternalDevice"
0x000095a0  bl       #0x24788   ; call _objc_getClass
0x000095a4  mov      x29, x29
0x000095a8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000095ac  mov      x19, x0
0x000095b0  adrp     x0, #0x35000
0x000095b4  add      x0, x0, #0x8f0   ; -> @"currentCarPlayExternalDevice"
0x000095b8  bl       #0x2441c   ; call _NSSelectorFromString
0x000095bc  mov      x20, x0
0x000095c0  mov      x0, x19
0x000095c4  mov      x1, x20
0x000095c8  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x000095cc  tbz      w0, #0, #0x95ec
0x000095d0  mov      x0, x19
0x000095d4  mov      x1, x20
