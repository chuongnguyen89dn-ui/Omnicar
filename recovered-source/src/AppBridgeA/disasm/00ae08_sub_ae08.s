; ==== sub_ae08 @ 0xae08..0xb004 (508 bytes) ====
0x0000ae08  mov      x0, x19
0x0000ae0c  bl       #0x2480c   ; call _objc_release
0x0000ae10  b        #0xae18   ; call sub_ae18
0x0000ae14  mov      x21, x0
0x0000ae18  mov      x0, x21
0x0000ae1c  bl       #0x24470   ; call __Unwind_Resume
0x0000ae20  stp      d9, d8, [sp, #-0x30]!
0x0000ae24  stp      x20, x19, [sp, #0x10]
0x0000ae28  stp      x29, x30, [sp, #0x20]
0x0000ae2c  add      x29, sp, #0x20
0x0000ae30  bl       #0x1d674   ; call _OMCPrefsSync
0x0000ae34  adrp     x0, #0x35000
0x0000ae38  add      x0, x0, #0xa70   ; -> @"appBridgeZoom"
0x0000ae3c  adrp     x1, #0x39000
0x0000ae40  add      x1, x1, #0x5a0
0x0000ae44  bl       #0x1d680   ; call _OMCPref
0x0000ae48  mov      x29, x29
0x0000ae4c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ae50  mov      x19, x0
0x0000ae54  bl       #0x25640   ; objc_msgSend: doubleValue
0x0000ae58  mov      x8, #0x4059000000000000
0x0000ae5c  fmov     d1, x8
0x0000ae60  fdiv     d8, d0, d1
0x0000ae64  mov      x0, x19
0x0000ae68  bl       #0x2480c   ; call _objc_release
0x0000ae6c  adrp     x8, #0x2b000
0x0000ae70  ldr      d0, [x8, #0x210]
0x0000ae74  fmaxnm   d0, d8, d0
0x0000ae78  fmov     d1, #1.00000000
0x0000ae7c  fcmp     d0, d1
0x0000ae80  fcsel    d0, d1, d0, gt
0x0000ae84  ldp      x29, x30, [sp, #0x20]
0x0000ae88  ldp      x20, x19, [sp, #0x10]
0x0000ae8c  ldp      d9, d8, [sp], #0x30
0x0000ae90  ret      
0x0000ae94  mov      x20, x0
0x0000ae98  mov      x0, x19
0x0000ae9c  bl       #0x2480c   ; call _objc_release
0x0000aea0  mov      x0, x20
0x0000aea4  bl       #0x24470   ; call __Unwind_Resume
0x0000aea8  sub      sp, sp, #0x70
0x0000aeac  stp      x28, x27, [sp, #0x10]
0x0000aeb0  stp      x26, x25, [sp, #0x20]
0x0000aeb4  stp      x24, x23, [sp, #0x30]
0x0000aeb8  stp      x22, x21, [sp, #0x40]
0x0000aebc  stp      x20, x19, [sp, #0x50]
0x0000aec0  stp      x29, x30, [sp, #0x60]
0x0000aec4  add      x29, sp, #0x60
0x0000aec8  mov      x21, x0
0x0000aecc  bl       #0xb4e4   ; call sub_b4e4
0x0000aed0  mov      x29, x29
0x0000aed4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000aed8  mov      x19, x0
0x0000aedc  cbz      x0, #0xaf24
0x0000aee0  mov      x0, x19
0x0000aee4  bl       #0x24818   ; call _objc_retain
0x0000aee8  adrp     x0, #0x35000
0x0000aeec  add      x0, x0, #0xa90   ; -> @"uniqueId"
0x0000aef0  bl       #0x2441c   ; call _NSSelectorFromString
0x0000aef4  mov      x20, x0
0x0000aef8  mov      x0, x19
0x0000aefc  mov      x1, x20
0x0000af00  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000af04  tbz      w0, #0, #0xaf2c
0x0000af08  mov      x0, x19
0x0000af0c  mov      x1, x20
0x0000af10  bl       #0x247ac   ; call _objc_msgSend
0x0000af14  mov      x29, x29
0x0000af18  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000af1c  mov      x20, x0
0x0000af20  b        #0xaf40   ; call sub_af40
0x0000af24  mov      x20, #0
0x0000af28  b        #0xaff0   ; call sub_aff0
0x0000af2c  adrp     x1, #0x35000
0x0000af30  add      x1, x1, #0xa90   ; -> @"uniqueId"
0x0000af34  mov      x0, x19
0x0000af38  bl       #0x9698   ; call _ABMissingSelector
0x0000af3c  mov      x20, #0
0x0000af40  mov      x0, x19
0x0000af44  bl       #0x2480c   ; call _objc_release
0x0000af48  cbz      x20, #0xaff0
0x0000af4c  mov      x0, x21
0x0000af50  bl       #0x281e0   ; objc_msgSend: window
0x0000af54  mov      x29, x29
0x0000af58  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000af5c  mov      x22, x0
0x0000af60  cbz      x0, #0xafcc
0x0000af64  mov      x0, x21
0x0000af68  bl       #0x255e0   ; objc_msgSend: displayID
0x0000af6c  mov      x29, x29
0x0000af70  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000af74  mov      x23, x0
0x0000af78  mov      x0, x20
0x0000af7c  mov      x2, x23
0x0000af80  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0000af84  mov      x24, x0
0x0000af88  mov      x0, x23
0x0000af8c  bl       #0x2480c   ; call _objc_release
0x0000af90  mov      x0, x22
0x0000af94  bl       #0x2480c   ; call _objc_release
0x0000af98  tbnz     w24, #0, #0xafcc
0x0000af9c  mov      x0, x21
0x0000afa0  bl       #0x281e0   ; objc_msgSend: window
0x0000afa4  mov      x29, x29
0x0000afa8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000afac  mov      x22, x0
0x0000afb0  mov      w2, #1
0x0000afb4  bl       #0x270a0   ; objc_msgSend: setHidden:
0x0000afb8  mov      x0, x22
0x0000afbc  bl       #0x2480c   ; call _objc_release
0x0000afc0  mov      x0, x21
0x0000afc4  mov      x2, #0
0x0000afc8  bl       #0x27a80   ; objc_msgSend: setWindow:
0x0000afcc  mov      x0, x21
0x0000afd0  bl       #0x281e0   ; objc_msgSend: window
0x0000afd4  mov      x29, x29
0x0000afd8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000afdc  mov      x22, x0
0x0000afe0  bl       #0x2480c   ; call _objc_release
0x0000afe4  cbz      x22, #0xb028
0x0000afe8  mov      w22, #1
0x0000afec  b        #0xaff4   ; call sub_aff4
0x0000aff0  mov      w22, #0
0x0000aff4  mov      x0, x20
0x0000aff8  bl       #0x2480c   ; call _objc_release
0x0000affc  mov      x0, x19
0x0000b000  bl       #0x2480c   ; call _objc_release
