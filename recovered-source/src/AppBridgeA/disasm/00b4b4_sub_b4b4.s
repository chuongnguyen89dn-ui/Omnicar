; ==== sub_b4b4 @ 0xb4b4..0xb764 (688 bytes) ====
0x0000b4b4  bl       #0x2480c   ; call _objc_release
0x0000b4b8  b        #0xb4cc   ; call sub_b4cc
0x0000b4bc  mov      x21, x0
0x0000b4c0  b        #0xb4cc   ; call sub_b4cc
0x0000b4c4  mov      x21, x0
0x0000b4c8  mov      x20, x19
0x0000b4cc  mov      x0, x20
0x0000b4d0  bl       #0x2480c   ; call _objc_release
0x0000b4d4  mov      x0, x19
0x0000b4d8  bl       #0x2480c   ; call _objc_release
0x0000b4dc  mov      x0, x21
0x0000b4e0  bl       #0x24470   ; call __Unwind_Resume
0x0000b4e4  sub      sp, sp, #0x140
0x0000b4e8  stp      x28, x27, [sp, #0xe0]
0x0000b4ec  stp      x26, x25, [sp, #0xf0]
0x0000b4f0  stp      x24, x23, [sp, #0x100]
0x0000b4f4  stp      x22, x21, [sp, #0x110]
0x0000b4f8  stp      x20, x19, [sp, #0x120]
0x0000b4fc  stp      x29, x30, [sp, #0x130]
0x0000b500  add      x29, sp, #0x130
0x0000b504  adrp     x8, #0x34000
0x0000b508  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0000b50c  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0000b510  stur     x8, [x29, #-0x60]
0x0000b514  adrp     x0, #0x29000
0x0000b518  add      x0, x0, #0x667   ; -> "AVExternalDevice"
0x0000b51c  bl       #0x24788   ; call _objc_getClass
0x0000b520  mov      x29, x29
0x0000b524  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b528  mov      x20, x0
0x0000b52c  adrp     x0, #0x35000
0x0000b530  add      x0, x0, #0x8f0   ; -> @"currentCarPlayExternalDevice"
0x0000b534  bl       #0x2441c   ; call _NSSelectorFromString
0x0000b538  mov      x19, x0
0x0000b53c  mov      x0, x20
0x0000b540  mov      x1, x19
0x0000b544  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000b548  tbz      w0, #0, #0xb568
0x0000b54c  mov      x0, x20
0x0000b550  mov      x1, x19
0x0000b554  bl       #0x247ac   ; call _objc_msgSend
0x0000b558  mov      x29, x29
0x0000b55c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b560  mov      x19, x0
0x0000b564  b        #0xb57c   ; call sub_b57c
0x0000b568  adrp     x1, #0x35000
0x0000b56c  add      x1, x1, #0x8f0   ; -> @"currentCarPlayExternalDevice"
0x0000b570  mov      x0, x20
0x0000b574  bl       #0x9698   ; call _ABMissingSelector
0x0000b578  mov      x19, #0
0x0000b57c  mov      x0, x20
0x0000b580  bl       #0x2480c   ; call _objc_release
0x0000b584  str      x19, [sp, #8]
0x0000b588  cbz      x19, #0xb5d0
0x0000b58c  mov      x0, x19
0x0000b590  bl       #0x24818   ; call _objc_retain
0x0000b594  adrp     x0, #0x36000
0x0000b598  add      x0, x0, #0x790   ; -> @"screenIDs"
0x0000b59c  bl       #0x2441c   ; call _NSSelectorFromString
0x0000b5a0  mov      x20, x0
0x0000b5a4  mov      x0, x19
0x0000b5a8  mov      x1, x20
0x0000b5ac  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000b5b0  tbz      w0, #0, #0xb5d8
0x0000b5b4  mov      x0, x19
0x0000b5b8  mov      x1, x20
0x0000b5bc  bl       #0x247ac   ; call _objc_msgSend
0x0000b5c0  mov      x29, x29
0x0000b5c4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b5c8  mov      x20, x0
0x0000b5cc  b        #0xb5ec   ; call sub_b5ec
0x0000b5d0  mov      x20, #0
0x0000b5d4  b        #0xb5f4   ; call sub_b5f4
0x0000b5d8  adrp     x1, #0x36000
0x0000b5dc  add      x1, x1, #0x790   ; -> @"screenIDs"
0x0000b5e0  mov      x0, x19
0x0000b5e4  bl       #0x9698   ; call _ABMissingSelector
0x0000b5e8  mov      x20, #0
0x0000b5ec  mov      x0, x19
0x0000b5f0  bl       #0x2480c   ; call _objc_release
0x0000b5f4  mov      x0, x20
0x0000b5f8  bl       #0x25420   ; objc_msgSend: count
0x0000b5fc  cbz      x0, #0xb660
0x0000b600  movi     v0.16b, #0
0x0000b604  stp      q0, q0, [sp, #0x30]
0x0000b608  stp      q0, q0, [sp, #0x10]
0x0000b60c  adrp     x0, #0x2a000
0x0000b610  add      x0, x0, #0x1df   ; -> "CADisplay"
0x0000b614  bl       #0x24788   ; call _objc_getClass
0x0000b618  mov      x29, x29
0x0000b61c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b620  mov      x22, x0
0x0000b624  adrp     x0, #0x36000
0x0000b628  add      x0, x0, #0x7b0   ; -> @"displays"
0x0000b62c  bl       #0x2441c   ; call _NSSelectorFromString
0x0000b630  mov      x21, x0
0x0000b634  mov      x0, x22
0x0000b638  mov      x1, x21
0x0000b63c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000b640  tbz      w0, #0, #0xb668
0x0000b644  mov      x0, x22
0x0000b648  mov      x1, x21
0x0000b64c  bl       #0x247ac   ; call _objc_msgSend
0x0000b650  mov      x29, x29
0x0000b654  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b658  mov      x21, x0
0x0000b65c  b        #0xb67c   ; call sub_b67c
0x0000b660  mov      x22, #0
0x0000b664  b        #0xb7a8   ; call sub_b7a8
0x0000b668  adrp     x1, #0x36000
0x0000b66c  add      x1, x1, #0x7b0   ; -> @"displays"
0x0000b670  mov      x0, x22
0x0000b674  bl       #0x9698   ; call _ABMissingSelector
0x0000b678  mov      x21, #0
0x0000b67c  mov      x0, x22
0x0000b680  bl       #0x2480c   ; call _objc_release
0x0000b684  add      x2, sp, #0x10
0x0000b688  add      x3, sp, #0x50
0x0000b68c  mov      x0, x21
0x0000b690  mov      w4, #0x10
0x0000b694  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0000b698  mov      x24, x0
0x0000b69c  cbz      x0, #0xb790
0x0000b6a0  ldr      x8, [sp, #0x20]
0x0000b6a4  ldr      x28, [x8]   ; -> [got:___objc_personality_v0]
0x0000b6a8  adrp     x23, #0x35000
0x0000b6ac  add      x23, x23, #0xa90   ; -> @"uniqueId"
0x0000b6b0  mov      x19, #0
0x0000b6b4  ldr      x8, [sp, #0x20]
0x0000b6b8  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0000b6bc  cmp      x8, x28
0x0000b6c0  b.eq     #0xb6cc
0x0000b6c4  mov      x0, x21
0x0000b6c8  bl       #0x24770   ; call _objc_enumerationMutation
0x0000b6cc  ldr      x8, [sp, #0x18]
0x0000b6d0  ldr      x22, [x8, x19, lsl #3]   ; -> [got:___objc_personality_v0]
0x0000b6d4  mov      x0, x20
0x0000b6d8  mov      x2, #0
0x0000b6dc  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x0000b6e0  mov      x29, x29
0x0000b6e4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b6e8  mov      x25, x0
0x0000b6ec  mov      x0, x22
0x0000b6f0  bl       #0x24818   ; call _objc_retain
0x0000b6f4  mov      x0, x23
0x0000b6f8  bl       #0x2441c   ; call _NSSelectorFromString
0x0000b6fc  mov      x26, x0
0x0000b700  mov      x0, x22
0x0000b704  mov      x1, x26
0x0000b708  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000b70c  tbz      w0, #0, #0xb72c
0x0000b710  mov      x0, x22
0x0000b714  mov      x1, x26
0x0000b718  bl       #0x247ac   ; call _objc_msgSend
0x0000b71c  mov      x29, x29
0x0000b720  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b724  mov      x26, x0
0x0000b728  b        #0xb73c   ; call sub_b73c
0x0000b72c  mov      x0, x22
0x0000b730  mov      x1, x23
0x0000b734  bl       #0x9698   ; call _ABMissingSelector
0x0000b738  mov      x26, #0
0x0000b73c  mov      x0, x22
0x0000b740  bl       #0x2480c   ; call _objc_release
0x0000b744  mov      x0, x25
0x0000b748  mov      x2, x26
0x0000b74c  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0000b750  mov      x27, x0
0x0000b754  mov      x0, x26
0x0000b758  bl       #0x2480c   ; call _objc_release
0x0000b75c  mov      x0, x25
0x0000b760  bl       #0x2480c   ; call _objc_release
