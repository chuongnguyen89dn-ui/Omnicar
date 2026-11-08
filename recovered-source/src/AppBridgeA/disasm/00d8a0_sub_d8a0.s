; ==== sub_d8a0 @ 0xd8a0..0xdb2c (652 bytes) ====
0x0000d8a0  str      x0, [sp, #0x30]
0x0000d8a4  ldr      x0, [sp, #0x70]
0x0000d8a8  b        #0xd944   ; call sub_d944
0x0000d8ac  str      x0, [sp, #0x30]
0x0000d8b0  ldr      x0, [sp, #0x50]
0x0000d8b4  b        #0xd95c   ; call sub_d95c
0x0000d8b8  str      x0, [sp, #0x30]
0x0000d8bc  mov      x0, x21
0x0000d8c0  b        #0xd974   ; call sub_d974
0x0000d8c4  str      x0, [sp, #0x30]
0x0000d8c8  mov      x0, x19
0x0000d8cc  b        #0xd97c   ; call sub_d97c
0x0000d8d0  str      x0, [sp, #0x30]
0x0000d8d4  mov      x0, x23
0x0000d8d8  bl       #0x2480c   ; call _objc_release
0x0000d8dc  mov      x0, x23
0x0000d8e0  b        #0xd954   ; call sub_d954
0x0000d8e4  str      x0, [sp, #0x30]
0x0000d8e8  mov      x0, x23
0x0000d8ec  bl       #0x2480c   ; call _objc_release
0x0000d8f0  mov      x0, x19
0x0000d8f4  b        #0xd90c   ; call sub_d90c
0x0000d8f8  str      x0, [sp, #0x30]
0x0000d8fc  mov      x0, x22
0x0000d900  b        #0xd90c   ; call sub_d90c
0x0000d904  str      x0, [sp, #0x30]
0x0000d908  mov      x0, x20
0x0000d90c  bl       #0x2480c   ; call _objc_release
0x0000d910  sub      x0, x29, #0x68
0x0000d914  bl       #0x24758   ; call _objc_destroyWeak
0x0000d918  sub      x0, x29, #0x60
0x0000d91c  bl       #0x24758   ; call _objc_destroyWeak
0x0000d920  ldr      x0, [sp, #0x28]
0x0000d924  bl       #0x2480c   ; call _objc_release
0x0000d928  mov      x0, x20
0x0000d92c  bl       #0x2480c   ; call _objc_release
0x0000d930  mov      x0, x22
0x0000d934  bl       #0x2480c   ; call _objc_release
0x0000d938  ldr      x0, [sp, #0x78]
0x0000d93c  bl       #0x2480c   ; call _objc_release
0x0000d940  ldr      x0, [sp, #0x68]
0x0000d944  bl       #0x2480c   ; call _objc_release
0x0000d948  ldr      x0, [sp, #0x70]
0x0000d94c  bl       #0x2480c   ; call _objc_release
0x0000d950  ldr      x0, [sp, #0x40]
0x0000d954  bl       #0x2480c   ; call _objc_release
0x0000d958  ldr      x0, [sp, #0x48]
0x0000d95c  bl       #0x2480c   ; call _objc_release
0x0000d960  ldr      x0, [sp, #0x50]
0x0000d964  bl       #0x2480c   ; call _objc_release
0x0000d968  ldr      x0, [sp, #0x58]
0x0000d96c  bl       #0x2480c   ; call _objc_release
0x0000d970  ldr      x0, [sp, #0x38]
0x0000d974  bl       #0x2480c   ; call _objc_release
0x0000d978  mov      x0, x21
0x0000d97c  bl       #0x2480c   ; call _objc_release
0x0000d980  ldr      x0, [sp, #0x60]
0x0000d984  bl       #0x2480c   ; call _objc_release
0x0000d988  ldr      x0, [sp, #0x80]
0x0000d98c  bl       #0x2480c   ; call _objc_release
0x0000d990  ldr      x0, [sp, #0x30]
0x0000d994  bl       #0x24470   ; call __Unwind_Resume
0x0000d998  str      x0, [sp, #0x30]
0x0000d99c  mov      x0, x19
0x0000d9a0  b        #0xd92c   ; call sub_d92c
0x0000d9a4  str      x0, [sp, #0x30]
0x0000d9a8  mov      x0, x22
0x0000d9ac  b        #0xd92c   ; call sub_d92c
0x0000d9b0  sub      sp, sp, #0x180
0x0000d9b4  stp      x28, x27, [sp, #0x120]
0x0000d9b8  stp      x26, x25, [sp, #0x130]
0x0000d9bc  stp      x24, x23, [sp, #0x140]
0x0000d9c0  stp      x22, x21, [sp, #0x150]
0x0000d9c4  stp      x20, x19, [sp, #0x160]
0x0000d9c8  stp      x29, x30, [sp, #0x170]
0x0000d9cc  add      x29, sp, #0x170
0x0000d9d0  mov      x21, x2
0x0000d9d4  mov      x20, x1
0x0000d9d8  mov      x19, x0
0x0000d9dc  adrp     x8, #0x34000
0x0000d9e0  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0000d9e4  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0000d9e8  stur     x8, [x29, #-0x60]
0x0000d9ec  bl       #0x24818   ; call _objc_retain
0x0000d9f0  mov      x0, x20
0x0000d9f4  bl       #0x24818   ; call _objc_retain
0x0000d9f8  mov      x0, x21
0x0000d9fc  bl       #0x24818   ; call _objc_retain
0x0000da00  str      x20, [sp, #0x40]
0x0000da04  cbz      x19, #0xdba8
0x0000da08  movi     v0.16b, #0
0x0000da0c  stp      q0, q0, [sp, #0x70]
0x0000da10  stp      q0, q0, [sp, #0x50]
0x0000da14  mov      x0, x20
0x0000da18  bl       #0x24818   ; call _objc_retain
0x0000da1c  add      x2, sp, #0x50
0x0000da20  add      x3, sp, #0x90
0x0000da24  mov      x0, x20
0x0000da28  mov      w4, #0x10
0x0000da2c  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0000da30  mov      x23, x0
0x0000da34  cbz      x0, #0xdaa4
0x0000da38  ldr      x8, [sp, #0x60]
0x0000da3c  ldr      x20, [x8]   ; -> [got:___objc_personality_v0]
0x0000da40  mov      x24, #0
0x0000da44  ldr      x8, [sp, #0x60]
0x0000da48  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0000da4c  cmp      x8, x20
0x0000da50  b.eq     #0xda5c
0x0000da54  ldr      x0, [sp, #0x40]
0x0000da58  bl       #0x24770   ; call _objc_enumerationMutation
0x0000da5c  ldr      x8, [sp, #0x58]
0x0000da60  ldr      x22, [x8, x24, lsl #3]   ; -> [got:___objc_personality_v0]
0x0000da64  mov      x0, x22
0x0000da68  bl       #0x2441c   ; call _NSSelectorFromString
0x0000da6c  mov      x1, x0
0x0000da70  mov      x0, x19
0x0000da74  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000da78  tbnz     w0, #0, #0xdb98
0x0000da7c  add      x24, x24, #1
0x0000da80  cmp      x23, x24
0x0000da84  b.ne     #0xda44
0x0000da88  add      x2, sp, #0x50
0x0000da8c  add      x3, sp, #0x90
0x0000da90  ldr      x0, [sp, #0x40]
0x0000da94  mov      w4, #0x10
0x0000da98  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0000da9c  mov      x23, x0
0x0000daa0  cbnz     x0, #0xda40
0x0000daa4  ldr      x0, [sp, #0x40]
0x0000daa8  bl       #0x2480c   ; call _objc_release
0x0000daac  adrp     x8, #0x3e000
0x0000dab0  ldr      x0, [x8, #0x318]   ; -> [class(NSMutableArray)]
0x0000dab4  bl       #0x24dc0   ; objc_msgSend: array
0x0000dab8  mov      x29, x29
0x0000dabc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000dac0  mov      x22, x0
0x0000dac4  mov      x0, x19
0x0000dac8  bl       #0x247d0   ; call _objc_opt_class
0x0000dacc  mov      x24, x0
0x0000dad0  mov      x23, #0
0x0000dad4  mov      x28, #0x7fffffffffffffff
0x0000dad8  cbz      x24, #0xdbb0
0x0000dadc  str      wzr, [sp, #0x4c]
0x0000dae0  add      x1, sp, #0x4c
0x0000dae4  mov      x0, x24
0x0000dae8  bl       #0x24500   ; call _class_copyMethodList
0x0000daec  mov      x25, x0
0x0000daf0  ldr      w8, [sp, #0x4c]
0x0000daf4  cbz      w8, #0xdb80
0x0000daf8  mov      x20, #0
0x0000dafc  ldr      x0, [x25, x20, lsl #3]
0x0000db00  bl       #0x246c8   ; call _method_getName
0x0000db04  bl       #0x24458   ; call _NSStringFromSelector
0x0000db08  mov      x29, x29
0x0000db0c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000db10  mov      x26, x0
0x0000db14  mov      x2, x21
0x0000db18  mov      w3, #1
0x0000db1c  bl       #0x26760   ; objc_msgSend: rangeOfString:options:
0x0000db20  cmp      x0, x28
0x0000db24  b.eq     #0xdb68
0x0000db28  mov      x0, x22
