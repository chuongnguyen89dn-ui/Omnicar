; ==== sub_eea8 @ 0xeea8..0xf4e4 (1596 bytes) ====
0x0000eea8  b        #0xf1ec   ; call sub_f1ec
0x0000eeac  mov      x23, x1
0x0000eeb0  mov      x26, x0
0x0000eeb4  mov      x22, x28
0x0000eeb8  cmp      w23, #1
0x0000eebc  b.ne     #0xf1d8
0x0000eec0  mov      x0, x26
0x0000eec4  bl       #0x24740   ; call _objc_begin_catch
0x0000eec8  bl       #0x24764   ; call _objc_end_catch
0x0000eecc  mov      x23, #0
0x0000eed0  ldp      q0, q1, [x27]
0x0000eed4  str      q0, [sp, #0x90]
0x0000eed8  ldr      q0, [x27, #0x20]
0x0000eedc  stp      q1, q0, [x25, #0x10]
0x0000eee0  add      x2, sp, #0x90
0x0000eee4  mov      x0, x23
0x0000eee8  bl       #0x279a0   ; objc_msgSend: setTransform:
0x0000eeec  mov      x0, x19
0x0000eef0  bl       #0x24d00   ; objc_msgSend: appViewController
0x0000eef4  mov      x29, x29
0x0000eef8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000eefc  mov      x25, x0
0x0000ef00  adrp     x0, #0x36000
0x0000ef04  add      x0, x0, #0x130   ; -> @"sceneHandle"
0x0000ef08  bl       #0x2441c   ; call _NSSelectorFromString
0x0000ef0c  mov      x26, x0
0x0000ef10  mov      x0, x25
0x0000ef14  mov      x1, x26
0x0000ef18  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000ef1c  tbz      w0, #0, #0xef3c
0x0000ef20  mov      x0, x25
0x0000ef24  mov      x1, x26
0x0000ef28  bl       #0x247ac   ; call _objc_msgSend
0x0000ef2c  mov      x29, x29
0x0000ef30  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ef34  mov      x27, x0
0x0000ef38  b        #0xef50   ; call sub_ef50
0x0000ef3c  adrp     x1, #0x36000
0x0000ef40  add      x1, x1, #0x130   ; -> @"sceneHandle"
0x0000ef44  mov      x0, x25
0x0000ef48  bl       #0x9698   ; call _ABMissingSelector
0x0000ef4c  mov      x27, #0
0x0000ef50  mov      x0, x25
0x0000ef54  bl       #0x2480c   ; call _objc_release
0x0000ef58  adrp     x0, #0x36000
0x0000ef5c  add      x0, x0, #0x150   ; -> @"sceneIfExists"
0x0000ef60  bl       #0x2441c   ; call _NSSelectorFromString
0x0000ef64  mov      x25, x0
0x0000ef68  mov      x0, x27
0x0000ef6c  mov      x1, x25
0x0000ef70  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000ef74  tbz      w0, #0, #0xef94
0x0000ef78  mov      x0, x27
0x0000ef7c  mov      x1, x25
0x0000ef80  bl       #0x247ac   ; call _objc_msgSend
0x0000ef84  mov      x29, x29
0x0000ef88  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ef8c  mov      x25, x0
0x0000ef90  b        #0xefa8   ; call sub_efa8
0x0000ef94  adrp     x1, #0x36000
0x0000ef98  add      x1, x1, #0x150   ; -> @"sceneIfExists"
0x0000ef9c  mov      x0, x27
0x0000efa0  bl       #0x9698   ; call _ABMissingSelector
0x0000efa4  mov      x25, #0
0x0000efa8  mov      x0, x27
0x0000efac  bl       #0x2480c   ; call _objc_release
0x0000efb0  cbz      x25, #0xf078
0x0000efb4  mov      x0, x24
0x0000efb8  mov      x2, x19
0x0000efbc  bl       #0x256a0   ; objc_msgSend: effectiveOrientation:
0x0000efc0  mov      x24, x0
0x0000efc4  sub      x8, x0, #3
0x0000efc8  cmp      x8, #2
0x0000efcc  fmov     d0, xzr
0x0000efd0  fcsel    d12, d0, d13, lo
0x0000efd4  fcsel    d13, d11, d10, lo
0x0000efd8  fcsel    d10, d10, d11, lo
0x0000efdc  mov      x0, x25
0x0000efe0  bl       #0x24818   ; call _objc_retain
0x0000efe4  adrp     x0, #0x36000
0x0000efe8  add      x0, x0, #0x170   ; -> @"updateSettingsWithBlock:"
0x0000efec  bl       #0x2441c   ; call _NSSelectorFromString
0x0000eff0  mov      x26, x0
0x0000eff4  mov      x0, x25
0x0000eff8  mov      x1, x26
0x0000effc  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000f000  tbz      w0, #0, #0xf050
0x0000f004  adrp     x8, #0x34000
0x0000f008  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x0000f00c  str      x8, [sp, #0x18]
0x0000f010  adrp     x8, #0x2b000
0x0000f014  ldr      d0, [x8, #0x1e8]
0x0000f018  str      d0, [sp, #0x20]
0x0000f01c  adrp     x8, #0xf000
0x0000f020  add      x8, x8, #0x210
0x0000f024  adrp     x9, #0x34000
0x0000f028  add      x9, x9, #0x920
0x0000f02c  stp      x8, x9, [sp, #0x28]
0x0000f030  stp      d12, d12, [sp, #0x38]
0x0000f034  stp      d13, d10, [sp, #0x48]
0x0000f038  str      x24, [sp, #0x58]
0x0000f03c  add      x2, sp, #0x18
0x0000f040  mov      x0, x25
0x0000f044  mov      x1, x26
0x0000f048  bl       #0x247ac   ; call _objc_msgSend
0x0000f04c  b        #0xf060   ; call sub_f060
0x0000f050  adrp     x1, #0x36000
0x0000f054  add      x1, x1, #0x170   ; -> @"updateSettingsWithBlock:"
0x0000f058  mov      x0, x25
0x0000f05c  bl       #0x9698   ; call _ABMissingSelector
0x0000f060  mov      x0, x25
0x0000f064  bl       #0x2480c   ; call _objc_release
0x0000f068  mov      x0, x19
0x0000f06c  mov      v0.16b, v8.16b
0x0000f070  mov      v1.16b, v9.16b
0x0000f074  bl       #0x27680   ; objc_msgSend: setSceneBox:
0x0000f078  mov      x0, x25
0x0000f07c  bl       #0x2480c   ; call _objc_release
0x0000f080  mov      x0, x23
0x0000f084  bl       #0x2480c   ; call _objc_release
0x0000f088  mov      x0, x22
0x0000f08c  bl       #0x2480c   ; call _objc_release
0x0000f090  mov      x0, x21
0x0000f094  bl       #0x2480c   ; call _objc_release
0x0000f098  mov      x0, x20
0x0000f09c  bl       #0x2480c   ; call _objc_release
0x0000f0a0  mov      x0, x19
0x0000f0a4  bl       #0x2480c   ; call _objc_release
0x0000f0a8  ldp      x29, x30, [sp, #0x150]
0x0000f0ac  ldp      x20, x19, [sp, #0x140]
0x0000f0b0  ldp      x22, x21, [sp, #0x130]
0x0000f0b4  ldp      x24, x23, [sp, #0x120]
0x0000f0b8  ldp      x26, x25, [sp, #0x110]
0x0000f0bc  ldp      x28, x27, [sp, #0x100]
0x0000f0c0  ldp      d9, d8, [sp, #0xf0]
0x0000f0c4  ldp      d11, d10, [sp, #0xe0]
0x0000f0c8  ldp      d13, d12, [sp, #0xd0]
0x0000f0cc  add      sp, sp, #0x160
0x0000f0d0  ret      
0x0000f0d4  b        #0xf1c4   ; call sub_f1c4
0x0000f0d8  b        #0xf1c4   ; call sub_f1c4
0x0000f0dc  b        #0xf1b8   ; call sub_f1b8
0x0000f0e0  b        #0xf1c4   ; call sub_f1c4
0x0000f0e4  b        #0xf0e8   ; call sub_f0e8
0x0000f0e8  mov      x26, x0
0x0000f0ec  b        #0xf1d0   ; call sub_f1d0
0x0000f0f0  mov      x24, x1
0x0000f0f4  mov      x26, x0
0x0000f0f8  mov      x0, x25
0x0000f0fc  bl       #0x2480c   ; call _objc_release
0x0000f100  cmp      w24, #1
0x0000f104  b.ne     #0xf1c8
0x0000f108  mov      x0, x26
0x0000f10c  bl       #0x24740   ; call _objc_begin_catch
0x0000f110  mov      x24, x0
0x0000f114  bl       #0x24818   ; call _objc_retain
0x0000f118  adrp     x8, #0x3e000
0x0000f11c  ldr      x26, [x8, #0x290]   ; -> [class(NSString)]
0x0000f120  mov      x0, x19
0x0000f124  bl       #0x25020   ; objc_msgSend: bundleID
0x0000f128  mov      x29, x29
0x0000f12c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000f130  mov      x27, x0
0x0000f134  stp      x0, x24, [sp]
0x0000f138  adrp     x2, #0x36000
0x0000f13c  add      x2, x2, #0x210   ; -> @"updateSettings %@ loi %@"
0x0000f140  mov      x0, x26
0x0000f144  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000f148  mov      x29, x29
0x0000f14c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000f150  mov      x28, x0
0x0000f154  adrp     x0, #0x34000
0x0000f158  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000f15c  mov      x1, x28
0x0000f160  bl       #0x1dd30   ; call _OMCLogWrite
0x0000f164  mov      x0, x28
0x0000f168  bl       #0x2480c   ; call _objc_release
0x0000f16c  mov      x0, x27
0x0000f170  bl       #0x2480c   ; call _objc_release
0x0000f174  mov      x0, x24
0x0000f178  bl       #0x2480c   ; call _objc_release
0x0000f17c  bl       #0x24764   ; call _objc_end_catch
0x0000f180  b        #0xf068   ; call sub_f068
0x0000f184  mov      x26, x0
0x0000f188  mov      x0, x28
0x0000f18c  bl       #0x2480c   ; call _objc_release
0x0000f190  b        #0xf198   ; call sub_f198
0x0000f194  mov      x26, x0
0x0000f198  mov      x0, x27
0x0000f19c  bl       #0x2480c   ; call _objc_release
0x0000f1a0  b        #0xf1a8   ; call sub_f1a8
0x0000f1a4  mov      x26, x0
0x0000f1a8  mov      x0, x24
0x0000f1ac  bl       #0x2480c   ; call _objc_release
0x0000f1b0  bl       #0x24764   ; call _objc_end_catch
0x0000f1b4  b        #0xf1c8   ; call sub_f1c8
0x0000f1b8  mov      x26, x0
0x0000f1bc  mov      x0, x27
0x0000f1c0  b        #0xf1cc   ; call sub_f1cc
0x0000f1c4  mov      x26, x0
0x0000f1c8  mov      x0, x25
0x0000f1cc  bl       #0x2480c   ; call _objc_release
0x0000f1d0  mov      x0, x23
0x0000f1d4  bl       #0x2480c   ; call _objc_release
0x0000f1d8  mov      x0, x22
0x0000f1dc  bl       #0x2480c   ; call _objc_release
0x0000f1e0  mov      x0, x21
0x0000f1e4  bl       #0x2480c   ; call _objc_release
0x0000f1e8  b        #0xf1f8   ; call sub_f1f8
0x0000f1ec  mov      x26, x0
0x0000f1f0  b        #0xf200   ; call sub_f200
0x0000f1f4  mov      x26, x0
0x0000f1f8  mov      x0, x20
0x0000f1fc  bl       #0x2480c   ; call _objc_release
0x0000f200  mov      x0, x19
0x0000f204  bl       #0x2480c   ; call _objc_release
0x0000f208  mov      x0, x26
0x0000f20c  bl       #0x24470   ; call __Unwind_Resume
0x0000f210  stp      x20, x19, [sp, #-0x20]!
0x0000f214  stp      x29, x30, [sp, #0x10]
0x0000f218  add      x29, sp, #0x10
0x0000f21c  mov      x19, x1
0x0000f220  mov      x20, x0
0x0000f224  mov      x0, x1
0x0000f228  bl       #0x24818   ; call _objc_retain
0x0000f22c  adrp     x0, #0x36000
0x0000f230  add      x0, x0, #0x190   ; -> @"setFrame:"
0x0000f234  bl       #0x2441c   ; call _NSSelectorFromString
0x0000f238  mov      x1, x0
0x0000f23c  ldp      d0, d1, [x20, #0x20]
0x0000f240  ldp      d2, d3, [x20, #0x30]
0x0000f244  mov      x0, x19
0x0000f248  bl       #0x247ac   ; call _objc_msgSend
0x0000f24c  adrp     x0, #0x36000
0x0000f250  add      x0, x0, #0x1b0   ; -> @"setInterfaceOrientation:"
0x0000f254  bl       #0x2441c   ; call _NSSelectorFromString
0x0000f258  mov      x1, x0
0x0000f25c  mov      x0, x19
0x0000f260  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000f264  tbz      w0, #0, #0xf284
0x0000f268  adrp     x0, #0x36000
0x0000f26c  add      x0, x0, #0x1b0   ; -> @"setInterfaceOrientation:"
0x0000f270  bl       #0x2441c   ; call _NSSelectorFromString
0x0000f274  mov      x1, x0
0x0000f278  ldr      x2, [x20, #0x40]
0x0000f27c  mov      x0, x19
0x0000f280  bl       #0x247ac   ; call _objc_msgSend
0x0000f284  mov      x0, x19
0x0000f288  bl       #0x24818   ; call _objc_retain
0x0000f28c  adrp     x0, #0x36000
0x0000f290  add      x0, x0, #0x1d0   ; -> @"setBackgrounded:"
0x0000f294  bl       #0x2441c   ; call _NSSelectorFromString
0x0000f298  mov      x20, x0
0x0000f29c  mov      x0, x19
0x0000f2a0  mov      x1, x20
0x0000f2a4  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000f2a8  tbz      w0, #0, #0xf2c0
0x0000f2ac  mov      x0, x19
0x0000f2b0  mov      x1, x20
0x0000f2b4  mov      w2, #0
0x0000f2b8  bl       #0x247ac   ; call _objc_msgSend
0x0000f2bc  b        #0xf2d0   ; call sub_f2d0
0x0000f2c0  adrp     x1, #0x36000
0x0000f2c4  add      x1, x1, #0x1d0   ; -> @"setBackgrounded:"
0x0000f2c8  mov      x0, x19
0x0000f2cc  bl       #0x9698   ; call _ABMissingSelector
0x0000f2d0  mov      x0, x19
0x0000f2d4  bl       #0x2480c   ; call _objc_release
0x0000f2d8  mov      x0, x19
0x0000f2dc  bl       #0x24818   ; call _objc_retain
0x0000f2e0  adrp     x0, #0x36000
0x0000f2e4  add      x0, x0, #0x1f0   ; -> @"setForeground:"
0x0000f2e8  bl       #0x2441c   ; call _NSSelectorFromString
0x0000f2ec  mov      x20, x0
0x0000f2f0  mov      x0, x19
0x0000f2f4  mov      x1, x20
0x0000f2f8  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000f2fc  tbz      w0, #0, #0xf314
0x0000f300  mov      x0, x19
0x0000f304  mov      x1, x20
0x0000f308  mov      w2, #1
0x0000f30c  bl       #0x247ac   ; call _objc_msgSend
0x0000f310  b        #0xf324   ; call sub_f324
0x0000f314  adrp     x1, #0x36000
0x0000f318  add      x1, x1, #0x1f0   ; -> @"setForeground:"
0x0000f31c  mov      x0, x19
0x0000f320  bl       #0x9698   ; call _ABMissingSelector
0x0000f324  mov      x0, x19
0x0000f328  bl       #0x2480c   ; call _objc_release
0x0000f32c  mov      x0, x19
0x0000f330  ldp      x29, x30, [sp, #0x10]
0x0000f334  ldp      x20, x19, [sp], #0x20
0x0000f338  b        #0x2480c   ; call _objc_release
0x0000f33c  b        #0xf340   ; call sub_f340
0x0000f340  mov      x20, x0
0x0000f344  mov      x0, x19
0x0000f348  bl       #0x2480c   ; call _objc_release
0x0000f34c  b        #0xf354   ; call sub_f354
0x0000f350  mov      x20, x0
0x0000f354  mov      x0, x19
0x0000f358  bl       #0x2480c   ; call _objc_release
0x0000f35c  mov      x0, x20
0x0000f360  bl       #0x24470   ; call __Unwind_Resume
0x0000f364  stp      x20, x19, [sp, #-0x20]!
0x0000f368  stp      x29, x30, [sp, #0x10]
0x0000f36c  add      x29, sp, #0x10
0x0000f370  mov      x19, x2
0x0000f374  mov      x0, x2
0x0000f378  bl       #0x24818   ; call _objc_retain
0x0000f37c  mov      x0, x19
0x0000f380  bl       #0x268e0   ; objc_msgSend: requestedOrientation
0x0000f384  cmp      x0, #1
0x0000f388  b.lt     #0xf398
0x0000f38c  mov      x0, x19
0x0000f390  bl       #0x268e0   ; objc_msgSend: requestedOrientation
0x0000f394  b        #0xf3a0   ; call sub_f3a0
0x0000f398  mov      x0, x19
0x0000f39c  bl       #0x264c0   ; objc_msgSend: orientation
0x0000f3a0  mov      x20, x0
0x0000f3a4  mov      x0, x19
0x0000f3a8  bl       #0x2480c   ; call _objc_release
0x0000f3ac  mov      x0, x20
0x0000f3b0  ldp      x29, x30, [sp, #0x10]
0x0000f3b4  ldp      x20, x19, [sp], #0x20
0x0000f3b8  ret      
0x0000f3bc  mov      x20, x0
0x0000f3c0  mov      x0, x19
0x0000f3c4  bl       #0x2480c   ; call _objc_release
0x0000f3c8  mov      x0, x20
0x0000f3cc  bl       #0x24470   ; call __Unwind_Resume
0x0000f3d0  stp      x20, x19, [sp, #-0x20]!
0x0000f3d4  stp      x29, x30, [sp, #0x10]
0x0000f3d8  add      x29, sp, #0x10
0x0000f3dc  mov      x19, x0
0x0000f3e0  bl       #0x256c0   ; objc_msgSend: ensureWindow
0x0000f3e4  cbz      w0, #0xf3fc
0x0000f3e8  mov      x0, x19
0x0000f3ec  bl       #0x281e0   ; objc_msgSend: window
0x0000f3f0  mov      x29, x29
0x0000f3f4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000f3f8  b        #0xf400   ; call sub_f400
0x0000f3fc  mov      x0, #0
0x0000f400  ldp      x29, x30, [sp, #0x10]
0x0000f404  ldp      x20, x19, [sp], #0x20
0x0000f408  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x0000f40c  sub      sp, sp, #0x130
0x0000f410  stp      x28, x27, [sp, #0xd0]
0x0000f414  stp      x26, x25, [sp, #0xe0]
0x0000f418  stp      x24, x23, [sp, #0xf0]
0x0000f41c  stp      x22, x21, [sp, #0x100]
0x0000f420  stp      x20, x19, [sp, #0x110]
0x0000f424  stp      x29, x30, [sp, #0x120]
0x0000f428  add      x29, sp, #0x120
0x0000f42c  mov      x20, x2
0x0000f430  adrp     x8, #0x34000
0x0000f434  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0000f438  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0000f43c  stur     x8, [x29, #-0x58]
0x0000f440  movi     v0.16b, #0
0x0000f444  stp      q0, q0, [sp]
0x0000f448  stp      q0, q0, [sp, #0x20]
0x0000f44c  bl       #0x26580   ; objc_msgSend: panes
0x0000f450  mov      x29, x29
0x0000f454  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000f458  mov      x19, x0
0x0000f45c  mov      x2, sp
0x0000f460  add      x3, sp, #0x48
0x0000f464  mov      w4, #0x10
0x0000f468  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0000f46c  mov      x21, x0
0x0000f470  cbz      x0, #0xf54c
0x0000f474  ldr      x8, [sp, #0x10]
0x0000f478  ldr      x24, [x8]   ; -> [got:___objc_personality_v0]
0x0000f47c  mov      w25, #0x193
0x0000f480  movk     w25, #0x100, lsl #16
0x0000f484  mov      x26, #0
0x0000f488  ldr      x8, [sp, #0x10]
0x0000f48c  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0000f490  cmp      x8, x24
0x0000f494  b.eq     #0xf4a0
0x0000f498  mov      x0, x19
0x0000f49c  bl       #0x24770   ; call _objc_enumerationMutation
0x0000f4a0  ldr      x8, [sp, #8]
0x0000f4a4  ldr      x22, [x8, x26, lsl #3]   ; -> [got:___objc_personality_v0]
0x0000f4a8  mov      x0, x22
0x0000f4ac  bl       #0x25020   ; objc_msgSend: bundleID
0x0000f4b0  mov      x29, x29
0x0000f4b4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000f4b8  mov      x23, x0
0x0000f4bc  bl       #0x24818   ; call _objc_retain
0x0000f4c0  mov      x0, x23
0x0000f4c4  bl       #0x24824   ; call _objc_retainAutorelease
0x0000f4c8  mov      x0, x23
0x0000f4cc  bl       #0x24a40   ; objc_msgSend: UTF8String
0x0000f4d0  mov      w27, #0x9dc5
0x0000f4d4  movk     w27, #0x811c, lsl #16
0x0000f4d8  cbz      x0, #0xf508
0x0000f4dc  ldrb     w8, [x0]
0x0000f4e0  mov      w27, #0x9dc5
