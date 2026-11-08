; ==== sub_205c8 @ 0x205c8..0x207b8 (496 bytes) ====
0x000205c8  mov      x0, x21
0x000205cc  mov      w4, #0x10
0x000205d0  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x000205d4  mov      x22, x0
0x000205d8  cbnz     x0, #0x20574
0x000205dc  b        #0x205ec   ; call sub_205ec
0x000205e0  mov      w23, #0x40
0x000205e4  b        #0x205ec   ; call sub_205ec
0x000205e8  mov      w23, #0
0x000205ec  mov      x0, x21
0x000205f0  bl       #0x2480c   ; call _objc_release
0x000205f4  adrp     x1, #0x2a000
0x000205f8  add      x1, x1, #0xb2c   ; -> "exception"
0x000205fc  add      x2, sp, #0xe8
0x00020600  mov      x0, x20
0x00020604  mov      x3, x23
0x00020608  bl       #0x20bcc   ; call sub_20bcc
0x0002060c  adrp     x8, #0x3e000
0x00020610  ldr      x21, [x8, #0x290]   ; -> [class(NSString)]
0x00020614  mov      x0, x19
0x00020618  bl       #0x26200   ; objc_msgSend: name
0x0002061c  mov      x29, x29
0x00020620  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020624  mov      x22, x0
0x00020628  mov      x0, x19
0x0002062c  bl       #0x267a0   ; objc_msgSend: reason
0x00020630  mov      x29, x29
0x00020634  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020638  mov      x23, x0
0x0002063c  mov      x0, x19
0x00020640  bl       #0x250c0   ; objc_msgSend: callStackSymbols
0x00020644  mov      x29, x29
0x00020648  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0002064c  mov      x24, x0
0x00020650  adrp     x2, #0x35000
0x00020654  add      x2, x2, #0x210   ; -> @"
"
0x00020658  bl       #0x252a0   ; objc_msgSend: componentsJoinedByString:
0x0002065c  mov      x29, x29
0x00020660  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020664  mov      x25, x0
0x00020668  stp      x23, x0, [sp, #8]
0x0002066c  str      x22, [sp]
0x00020670  adrp     x2, #0x38000
0x00020674  add      x2, x2, #0x190   ; -> @"uncaught %@: %@
%@
"
0x00020678  mov      x0, x21
0x0002067c  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00020680  mov      x29, x29
0x00020684  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020688  mov      x21, x0
0x0002068c  mov      x0, x25
0x00020690  bl       #0x2480c   ; call _objc_release
0x00020694  mov      x0, x24
0x00020698  bl       #0x2480c   ; call _objc_release
0x0002069c  mov      x0, x23
0x000206a0  bl       #0x2480c   ; call _objc_release
0x000206a4  mov      x0, x22
0x000206a8  bl       #0x2480c   ; call _objc_release
0x000206ac  mov      x0, x21
0x000206b0  bl       #0x24824   ; call _objc_retainAutorelease
0x000206b4  bl       #0x24a40   ; objc_msgSend: UTF8String
0x000206b8  str      x0, [sp]
0x000206bc  adrp     x1, #0x2a000
0x000206c0  add      x1, x1, #0xb4a   ; -> "%s"
0x000206c4  mov      x0, x20
0x000206c8  bl       #0x245fc   ; call _dprintf
0x000206cc  mov      x0, x20
0x000206d0  bl       #0x2453c   ; call _close
0x000206d4  mov      x0, x21
0x000206d8  bl       #0x2480c   ; call _objc_release
0x000206dc  adrp     x8, #0x3e000
0x000206e0  ldr      x8, [x8, #0xb38]
0x000206e4  cbz      x8, #0x206f0
0x000206e8  mov      x0, x19
0x000206ec  blr      x8   ; indirect call
0x000206f0  mov      x0, x19
0x000206f4  bl       #0x2480c   ; call _objc_release
0x000206f8  ldur     x8, [x29, #-0x58]
0x000206fc  adrp     x9, #0x34000
0x00020700  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00020704  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x00020708  cmp      x9, x8
0x0002070c  b.ne     #0x20730
0x00020710  add      sp, sp, #0x2f0
0x00020714  ldp      x29, x30, [sp, #0x50]
0x00020718  ldp      x20, x19, [sp, #0x40]
0x0002071c  ldp      x22, x21, [sp, #0x30]
0x00020720  ldp      x24, x23, [sp, #0x20]
0x00020724  ldp      x26, x25, [sp, #0x10]
0x00020728  ldp      x28, x27, [sp], #0x60
0x0002072c  ret      
0x00020730  bl       #0x24488   ; call ___stack_chk_fail
0x00020734  stp      x28, x27, [sp, #-0x60]!
0x00020738  stp      x26, x25, [sp, #0x10]
0x0002073c  stp      x24, x23, [sp, #0x20]
0x00020740  stp      x22, x21, [sp, #0x30]
0x00020744  stp      x20, x19, [sp, #0x40]
0x00020748  stp      x29, x30, [sp, #0x50]
0x0002074c  add      x29, sp, #0x50
0x00020750  sub      sp, sp, #0x270
0x00020754  mov      x22, x1
0x00020758  mov      x23, x0
0x0002075c  adrp     x8, #0x34000
0x00020760  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00020764  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00020768  stur     x8, [x29, #-0x60]
0x0002076c  adrp     x8, #0x3e000
0x00020770  ldr      x0, [x8, #0xb30]
0x00020774  mov      w8, #0x1a4
0x00020778  str      x8, [sp]
0x0002077c  mov      w1, #0x209
0x00020780  bl       #0x248b4   ; call _open
0x00020784  tbnz     w0, #0x1f, #0x20908
0x00020788  mov      x20, x0
0x0002078c  add      x0, sp, #0x60
0x00020790  mov      w1, #0x40
0x00020794  bl       #0x244d0   ; call _backtrace
0x00020798  mov      x21, x0
0x0002079c  mov      x8, x23
0x000207a0  str      x8, [sp]
0x000207a4  adrp     x2, #0x2a000
0x000207a8  add      x2, x2, #0xb89   ; -> "signal-%d"
0x000207ac  add      x0, sp, #0x30
0x000207b0  mov      w1, #0x30
0x000207b4  bl       #0x24920   ; call _snprintf
