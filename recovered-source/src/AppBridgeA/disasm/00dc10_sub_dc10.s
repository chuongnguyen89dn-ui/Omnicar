; ==== sub_dc10 @ 0xdc10..0xde50 (576 bytes) ====
0x0000dc10  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000dc14  mov      x29, x29
0x0000dc18  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000dc1c  mov      x24, x0
0x0000dc20  mov      x0, x25
0x0000dc24  bl       #0x2480c   ; call _objc_release
0x0000dc28  ldr      x0, [x20, #0xa40]
0x0000dc2c  mov      x2, x24
0x0000dc30  bl       #0x25360   ; objc_msgSend: containsObject:
0x0000dc34  tbnz     w0, #0, #0xdd64
0x0000dc38  ldr      x0, [x20, #0xa40]
0x0000dc3c  mov      x2, x24
0x0000dc40  bl       #0x24b20   ; objc_msgSend: addObject:
0x0000dc44  ldr      x25, [x26, #0x290]
0x0000dc48  adrp     x8, #0x3e000
0x0000dc4c  ldr      x0, [x8, #0x2b8]   ; -> [class(UIDevice)]
0x0000dc50  bl       #0x25460   ; objc_msgSend: currentDevice
0x0000dc54  mov      x29, x29
0x0000dc58  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000dc5c  str      x0, [sp, #0x28]
0x0000dc60  bl       #0x27ec0   ; objc_msgSend: systemVersion
0x0000dc64  mov      x29, x29
0x0000dc68  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000dc6c  str      x0, [sp, #0x38]
0x0000dc70  mov      x0, x19
0x0000dc74  bl       #0x247d0   ; call _objc_opt_class
0x0000dc78  bl       #0x2444c   ; call _NSStringFromClass
0x0000dc7c  mov      x29, x29
0x0000dc80  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000dc84  str      x0, [sp, #0x30]
0x0000dc88  adrp     x2, #0x36000
0x0000dc8c  add      x2, x2, #0x8f0   ; -> @" / "
0x0000dc90  ldr      x0, [sp, #0x40]
0x0000dc94  bl       #0x252a0   ; objc_msgSend: componentsJoinedByString:
0x0000dc98  mov      x29, x29
0x0000dc9c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000dca0  mov      x26, x0
0x0000dca4  adrp     x8, #0x36000
0x0000dca8  add      x8, x8, #0x910   ; -> @"(khong tim thay)"
0x0000dcac  cmp      x23, #0
0x0000dcb0  csel     x20, x8, x23, eq
0x0000dcb4  mov      x0, x22
0x0000dcb8  bl       #0x25420   ; objc_msgSend: count
0x0000dcbc  mov      x28, x0
0x0000dcc0  cbz      x0, #0xdce4
0x0000dcc4  adrp     x2, #0x36000
0x0000dcc8  add      x2, x2, #0x930   ; -> @", "
0x0000dccc  mov      x0, x22
0x0000dcd0  bl       #0x252a0   ; objc_msgSend: componentsJoinedByString:
0x0000dcd4  mov      x29, x29
0x0000dcd8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000dcdc  mov      x27, x0
0x0000dce0  b        #0xdcec   ; call sub_dcec
0x0000dce4  adrp     x27, #0x35000
0x0000dce8  add      x27, x27, #0x90   ; -> @"-"
0x0000dcec  stp      x20, x27, [sp, #0x18]
0x0000dcf0  ldp      x9, x8, [sp, #0x30]
0x0000dcf4  stp      x9, x26, [sp, #8]
0x0000dcf8  str      x8, [sp]
0x0000dcfc  adrp     x2, #0x36000
0x0000dd00  add      x2, x2, #0x8d0   ; -> @"iOS %@: %@ khong co %@ -> dung %@ (co: %@)"
0x0000dd04  mov      x0, x25
0x0000dd08  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000dd0c  mov      x29, x29
0x0000dd10  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000dd14  mov      x25, x0
0x0000dd18  adrp     x0, #0x34000
0x0000dd1c  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000dd20  mov      x1, x25
0x0000dd24  bl       #0x1dd30   ; call _OMCLogWrite
0x0000dd28  cmp      x28, #0
0x0000dd2c  cset     w20, eq
0x0000dd30  mov      x0, x25
0x0000dd34  bl       #0x2480c   ; call _objc_release
0x0000dd38  tbnz     w20, #0, #0xdd44
0x0000dd3c  mov      x0, x27
0x0000dd40  bl       #0x2480c   ; call _objc_release
0x0000dd44  mov      x0, x26
0x0000dd48  bl       #0x2480c   ; call _objc_release
0x0000dd4c  ldr      x0, [sp, #0x30]
0x0000dd50  bl       #0x2480c   ; call _objc_release
0x0000dd54  ldr      x0, [sp, #0x38]
0x0000dd58  bl       #0x2480c   ; call _objc_release
0x0000dd5c  ldr      x0, [sp, #0x28]
0x0000dd60  bl       #0x2480c   ; call _objc_release
0x0000dd64  mov      x0, x23
0x0000dd68  bl       #0x24818   ; call _objc_retain
0x0000dd6c  mov      x0, x24
0x0000dd70  bl       #0x2480c   ; call _objc_release
0x0000dd74  mov      x0, x22
0x0000dd78  bl       #0x2480c   ; call _objc_release
0x0000dd7c  mov      x22, x23
0x0000dd80  mov      x0, x23
0x0000dd84  bl       #0x2480c   ; call _objc_release
0x0000dd88  mov      x0, x21
0x0000dd8c  bl       #0x2480c   ; call _objc_release
0x0000dd90  ldr      x0, [sp, #0x40]
0x0000dd94  bl       #0x2480c   ; call _objc_release
0x0000dd98  mov      x0, x19
0x0000dd9c  bl       #0x2480c   ; call _objc_release
0x0000dda0  ldur     x8, [x29, #-0x60]
0x0000dda4  adrp     x9, #0x34000
0x0000dda8  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x0000ddac  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0000ddb0  cmp      x9, x8
0x0000ddb4  b.ne     #0xdddc
0x0000ddb8  mov      x0, x22
0x0000ddbc  ldp      x29, x30, [sp, #0x170]
0x0000ddc0  ldp      x20, x19, [sp, #0x160]
0x0000ddc4  ldp      x22, x21, [sp, #0x150]
0x0000ddc8  ldp      x24, x23, [sp, #0x140]
0x0000ddcc  ldp      x26, x25, [sp, #0x130]
0x0000ddd0  ldp      x28, x27, [sp, #0x120]
0x0000ddd4  add      sp, sp, #0x180
0x0000ddd8  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x0000dddc  bl       #0x24488   ; call ___stack_chk_fail
0x0000dde0  b        #0xdeb4   ; call sub_deb4
0x0000dde4  mov      x20, x0
0x0000dde8  mov      x0, x25
0x0000ddec  bl       #0x2480c   ; call _objc_release
0x0000ddf0  b        #0xddf8   ; call sub_ddf8
0x0000ddf4  mov      x20, x0
0x0000ddf8  cbz      x28, #0xde1c
0x0000ddfc  mov      x0, x27
0x0000de00  bl       #0x2480c   ; call _objc_release
0x0000de04  b        #0xde1c   ; call sub_de1c
0x0000de08  mov      x20, x0
0x0000de0c  b        #0xde24   ; call sub_de24
0x0000de10  mov      x20, x0
0x0000de14  b        #0xde3c   ; call sub_de3c
0x0000de18  mov      x20, x0
0x0000de1c  mov      x0, x26
0x0000de20  bl       #0x2480c   ; call _objc_release
0x0000de24  ldr      x0, [sp, #0x30]
0x0000de28  bl       #0x2480c   ; call _objc_release
0x0000de2c  b        #0xde34   ; call sub_de34
0x0000de30  mov      x20, x0
0x0000de34  ldr      x0, [sp, #0x38]
0x0000de38  bl       #0x2480c   ; call _objc_release
0x0000de3c  ldr      x0, [sp, #0x28]
0x0000de40  bl       #0x2480c   ; call _objc_release
0x0000de44  b        #0xde74   ; call sub_de74
0x0000de48  mov      x20, x0
0x0000de4c  mov      x0, x25
