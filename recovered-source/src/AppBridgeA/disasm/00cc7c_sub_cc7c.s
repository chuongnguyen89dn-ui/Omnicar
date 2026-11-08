; ==== sub_cc7c @ 0xcc7c..0xcdf0 (372 bytes) ====
0x0000cc7c  mov      x0, x20
0x0000cc80  bl       #0x9698   ; call _ABMissingSelector
0x0000cc84  mov      x22, #0
0x0000cc88  mov      x0, x22
0x0000cc8c  bl       #0x24818   ; call _objc_retain
0x0000cc90  mov      x0, x22
0x0000cc94  bl       #0x2480c   ; call _objc_release
0x0000cc98  mov      x0, x20
0x0000cc9c  bl       #0x2480c   ; call _objc_release
0x0000cca0  mov      x0, x22
0x0000cca4  bl       #0x24818   ; call _objc_retain
0x0000cca8  str      x22, [sp, #0x78]
0x0000ccac  cbz      x22, #0xcccc
0x0000ccb0  adrp     x0, #0x29000
0x0000ccb4  add      x0, x0, #0xb50   ; -> "SBDeviceApplicationSceneEntity"
0x0000ccb8  bl       #0x24788   ; call _objc_getClass
0x0000ccbc  mov      x1, x0
0x0000ccc0  ldr      x0, [sp, #0x78]
0x0000ccc4  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0000ccc8  tbnz     w0, #0, #0xcd30
0x0000cccc  ldr      x0, [x26, #0x290]
0x0000ccd0  mov      w8, #0x1cf
0x0000ccd4  stp      x25, x8, [sp, #0x10]
0x0000ccd8  ldr      x8, [sp, #0x78]
0x0000ccdc  stp      x19, x8, [sp]
0x0000cce0  adrp     x2, #0x35000
0x0000cce4  add      x2, x2, #0xc10   ; -> @"UNEXPECTED %s: got %@ (%s:%d)"
0x0000cce8  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000ccec  mov      x29, x29
0x0000ccf0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ccf4  mov      x20, x0
0x0000ccf8  adrp     x0, #0x34000
0x0000ccfc  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000cd00  mov      x1, x20
0x0000cd04  bl       #0x1dd30   ; call _OMCLogWrite
0x0000cd08  mov      x0, x20
0x0000cd0c  bl       #0x2480c   ; call _objc_release
0x0000cd10  ldr      x0, [x24, #0x338]
0x0000cd14  adrp     x2, #0x34000
0x0000cd18  add      x2, x2, #0xef0   ; -> @"AppBridge"
0x0000cd1c  ldr      x8, [sp, #0x78]
0x0000cd20  stp      x19, x8, [sp]
0x0000cd24  adrp     x3, #0x35000
0x0000cd28  add      x3, x3, #0xc30   ; -> @"expected %s got %@"
0x0000cd2c  bl       #0x26700   ; objc_msgSend: raise:format:
0x0000cd30  ldr      x19, [sp, #0x78]
0x0000cd34  mov      x0, x19
0x0000cd38  bl       #0x24818   ; call _objc_retain
0x0000cd3c  mov      x0, x19
0x0000cd40  bl       #0x2480c   ; call _objc_release
0x0000cd44  mov      x0, x19
0x0000cd48  bl       #0x2480c   ; call _objc_release
0x0000cd4c  adrp     x19, #0x29000
0x0000cd50  add      x19, x19, #0xb8f   ; -> "SBAppViewController"
0x0000cd54  mov      x0, x19
0x0000cd58  bl       #0x24788   ; call _objc_getClass
0x0000cd5c  bl       #0x2471c   ; call _objc_alloc
0x0000cd60  mov      x20, x0
0x0000cd64  adrp     x0, #0x35000
0x0000cd68  add      x0, x0, #0xdd0   ; -> @"initWithIdentifier:andApplicationSceneEntity:"
0x0000cd6c  bl       #0x2441c   ; call _NSSelectorFromString
0x0000cd70  mov      x22, x0
0x0000cd74  mov      x0, x20
0x0000cd78  mov      x1, x22
0x0000cd7c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000cd80  tbz      w0, #0, #0xcda8
0x0000cd84  mov      x0, x20
0x0000cd88  mov      x1, x22
0x0000cd8c  ldr      x2, [sp, #0x60]
0x0000cd90  ldr      x3, [sp, #0x78]
0x0000cd94  bl       #0x247ac   ; call _objc_msgSend
0x0000cd98  mov      x29, x29
0x0000cd9c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000cda0  mov      x22, x0
0x0000cda4  b        #0xcdbc   ; call sub_cdbc
0x0000cda8  adrp     x1, #0x35000
0x0000cdac  add      x1, x1, #0xdd0   ; -> @"initWithIdentifier:andApplicationSceneEntity:"
0x0000cdb0  mov      x0, x20
0x0000cdb4  bl       #0x9698   ; call _ABMissingSelector
0x0000cdb8  mov      x22, #0
0x0000cdbc  mov      x0, x22
0x0000cdc0  bl       #0x24818   ; call _objc_retain
0x0000cdc4  mov      x0, x22
0x0000cdc8  bl       #0x2480c   ; call _objc_release
0x0000cdcc  mov      x0, x20
0x0000cdd0  bl       #0x2480c   ; call _objc_release
0x0000cdd4  mov      x0, x22
0x0000cdd8  bl       #0x24818   ; call _objc_retain
0x0000cddc  cbz      x22, #0xcdfc
0x0000cde0  adrp     x0, #0x29000
0x0000cde4  add      x0, x0, #0xb8f   ; -> "SBAppViewController"
0x0000cde8  bl       #0x24788   ; call _objc_getClass
0x0000cdec  mov      x1, x0
