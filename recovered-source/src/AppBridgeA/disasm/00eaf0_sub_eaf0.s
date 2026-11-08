; ==== sub_eaf0 @ 0xeaf0..0xec84 (404 bytes) ====
0x0000eaf0  ldr      x24, [x8, #0x290]
0x0000eaf4  mov      x0, x22
0x0000eaf8  bl       #0x25020   ; objc_msgSend: bundleID
0x0000eafc  mov      x29, x29
0x0000eb00  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000eb04  mov      x23, x0
0x0000eb08  str      x0, [sp]
0x0000eb0c  adrp     x2, #0x36000
0x0000eb10  add      x2, x2, #0x90   ; -> @"scene cua %@ bi huy -> bo o"
0x0000eb14  mov      x0, x24
0x0000eb18  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000eb1c  mov      x29, x29
0x0000eb20  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000eb24  mov      x24, x0
0x0000eb28  adrp     x0, #0x34000
0x0000eb2c  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000eb30  mov      x1, x24
0x0000eb34  bl       #0x1dd30   ; call _OMCLogWrite
0x0000eb38  mov      x0, x24
0x0000eb3c  bl       #0x2480c   ; call _objc_release
0x0000eb40  mov      x0, x23
0x0000eb44  bl       #0x2480c   ; call _objc_release
0x0000eb48  mov      x0, x22
0x0000eb4c  bl       #0x25020   ; objc_msgSend: bundleID
0x0000eb50  mov      x29, x29
0x0000eb54  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000eb58  mov      x23, x0
0x0000eb5c  mov      x0, x21
0x0000eb60  mov      x2, x22
0x0000eb64  bl       #0x27ee0   ; objc_msgSend: teardownPane:
0x0000eb68  mov      x0, x21
0x0000eb6c  bl       #0x26580   ; objc_msgSend: panes
0x0000eb70  mov      x29, x29
0x0000eb74  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000eb78  mov      x24, x0
0x0000eb7c  mov      x2, x22
0x0000eb80  bl       #0x268a0   ; objc_msgSend: removeObject:
0x0000eb84  mov      x0, x24
0x0000eb88  bl       #0x2480c   ; call _objc_release
0x0000eb8c  mov      x0, x21
0x0000eb90  bl       #0x25660   ; objc_msgSend: dropWindowIfEmpty
0x0000eb94  adrp     x1, #0x36000
0x0000eb98  add      x1, x1, #0xb0   ; -> @"gone"
0x0000eb9c  mov      x0, x23
0x0000eba0  bl       #0xbed4   ; call sub_bed4
0x0000eba4  mov      x0, x23
0x0000eba8  bl       #0x2480c   ; call _objc_release
0x0000ebac  mov      x0, x20
0x0000ebb0  bl       #0x2480c   ; call _objc_release
0x0000ebb4  mov      x0, x19
0x0000ebb8  bl       #0x2480c   ; call _objc_release
0x0000ebbc  ldur     x8, [x29, #-0x58]
0x0000ebc0  adrp     x9, #0x34000
0x0000ebc4  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x0000ebc8  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0000ebcc  cmp      x9, x8
0x0000ebd0  b.ne     #0xebf4
0x0000ebd4  ldp      x29, x30, [sp, #0x130]
0x0000ebd8  ldp      x20, x19, [sp, #0x120]
0x0000ebdc  ldp      x22, x21, [sp, #0x110]
0x0000ebe0  ldp      x24, x23, [sp, #0x100]
0x0000ebe4  ldp      x26, x25, [sp, #0xf0]
0x0000ebe8  ldp      x28, x27, [sp, #0xe0]
0x0000ebec  add      sp, sp, #0x140
0x0000ebf0  ret      
0x0000ebf4  bl       #0x24488   ; call ___stack_chk_fail
0x0000ebf8  b        #0xec5c   ; call sub_ec5c
0x0000ebfc  mov      x21, x0
0x0000ec00  mov      x0, x24
0x0000ec04  bl       #0x2480c   ; call _objc_release
0x0000ec08  b        #0xec50   ; call sub_ec50
0x0000ec0c  b        #0xec5c   ; call sub_ec5c
0x0000ec10  mov      x21, x0
0x0000ec14  mov      x0, x24
0x0000ec18  bl       #0x2480c   ; call _objc_release
0x0000ec1c  b        #0xec24   ; call sub_ec24
0x0000ec20  mov      x21, x0
0x0000ec24  mov      x0, x23
0x0000ec28  bl       #0x2480c   ; call _objc_release
0x0000ec2c  b        #0xec60   ; call sub_ec60
0x0000ec30  mov      x21, x0
0x0000ec34  mov      x0, x22
0x0000ec38  bl       #0x2480c   ; call _objc_release
0x0000ec3c  b        #0xec68   ; call sub_ec68
0x0000ec40  mov      x21, x0
0x0000ec44  b        #0xec68   ; call sub_ec68
0x0000ec48  b        #0xec5c   ; call sub_ec5c
0x0000ec4c  mov      x21, x0
0x0000ec50  mov      x0, x23
0x0000ec54  bl       #0x2480c   ; call _objc_release
0x0000ec58  b        #0xec60   ; call sub_ec60
0x0000ec5c  mov      x21, x0
0x0000ec60  mov      x0, x20
0x0000ec64  bl       #0x2480c   ; call _objc_release
0x0000ec68  mov      x0, x19
0x0000ec6c  bl       #0x2480c   ; call _objc_release
0x0000ec70  b        #0xec78   ; call sub_ec78
0x0000ec74  mov      x21, x0
0x0000ec78  mov      x0, x21
0x0000ec7c  bl       #0x24470   ; call __Unwind_Resume
0x0000ec80  sub      sp, sp, #0x160
