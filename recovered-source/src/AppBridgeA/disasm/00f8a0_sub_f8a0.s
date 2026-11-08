; ==== sub_f8a0 @ 0xf8a0..0xfed4 (1588 bytes) ====
0x0000f8a0  mov      x23, x0
0x0000f8a4  ldr      x0, [sp, #0x28]
0x0000f8a8  mov      x2, x24
0x0000f8ac  bl       #0x256a0   ; objc_msgSend: effectiveOrientation:
0x0000f8b0  stp      x21, x0, [sp, #0x10]
0x0000f8b4  mov      x8, x20
0x0000f8b8  stp      x23, x8, [sp]
0x0000f8bc  adrp     x2, #0x36000
0x0000f8c0  add      x2, x2, #0x230   ; -> @"%@ doi yeu cau xoay (ma %d, mask %lu) -> scene huong %lld"
0x0000f8c4  mov      x0, x25
0x0000f8c8  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000f8cc  mov      x29, x29
0x0000f8d0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000f8d4  mov      x21, x0
0x0000f8d8  adrp     x0, #0x34000
0x0000f8dc  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000f8e0  mov      x1, x21
0x0000f8e4  bl       #0x1dd30   ; call _OMCLogWrite
0x0000f8e8  mov      x0, x21
0x0000f8ec  bl       #0x2480c   ; call _objc_release
0x0000f8f0  mov      x0, x23
0x0000f8f4  bl       #0x2480c   ; call _objc_release
0x0000f8f8  ldr      x0, [sp, #0x28]
0x0000f8fc  mov      x2, x24
0x0000f900  bl       #0x26260   ; objc_msgSend: nudgePane:
0x0000f904  mov      x0, x19
0x0000f908  bl       #0x2480c   ; call _objc_release
0x0000f90c  ldur     x8, [x29, #-0x60]
0x0000f910  adrp     x9, #0x34000
0x0000f914  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x0000f918  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0000f91c  cmp      x9, x8
0x0000f920  b.ne     #0xf944
0x0000f924  ldp      x29, x30, [sp, #0x150]
0x0000f928  ldp      x20, x19, [sp, #0x140]
0x0000f92c  ldp      x22, x21, [sp, #0x130]
0x0000f930  ldp      x24, x23, [sp, #0x120]
0x0000f934  ldp      x26, x25, [sp, #0x110]
0x0000f938  ldp      x28, x27, [sp, #0x100]
0x0000f93c  add      sp, sp, #0x160
0x0000f940  ret      
0x0000f944  bl       #0x24488   ; call ___stack_chk_fail
0x0000f948  b        #0xf990   ; call sub_f990
0x0000f94c  b        #0xf990   ; call sub_f990
0x0000f950  mov      x20, x0
0x0000f954  mov      x0, x21
0x0000f958  bl       #0x2480c   ; call _objc_release
0x0000f95c  b        #0xf968   ; call sub_f968
0x0000f960  b        #0xf990   ; call sub_f990
0x0000f964  mov      x20, x0
0x0000f968  mov      x0, x23
0x0000f96c  bl       #0x2480c   ; call _objc_release
0x0000f970  b        #0xf994   ; call sub_f994
0x0000f974  b        #0xf990   ; call sub_f990
0x0000f978  mov      x20, x0
0x0000f97c  mov      x0, x26
0x0000f980  bl       #0x2480c   ; call _objc_release
0x0000f984  mov      x0, x26
0x0000f988  bl       #0x2480c   ; call _objc_release
0x0000f98c  b        #0xf994   ; call sub_f994
0x0000f990  mov      x20, x0
0x0000f994  mov      x0, x19
0x0000f998  bl       #0x2480c   ; call _objc_release
0x0000f99c  b        #0xf9a4   ; call sub_f9a4
0x0000f9a0  mov      x20, x0
0x0000f9a4  mov      x0, x20
0x0000f9a8  bl       #0x24470   ; call __Unwind_Resume
0x0000f9ac  sub      sp, sp, #0x100
0x0000f9b0  stp      d11, d10, [sp, #0x90]
0x0000f9b4  stp      d9, d8, [sp, #0xa0]
0x0000f9b8  stp      x26, x25, [sp, #0xb0]
0x0000f9bc  stp      x24, x23, [sp, #0xc0]
0x0000f9c0  stp      x22, x21, [sp, #0xd0]
0x0000f9c4  stp      x20, x19, [sp, #0xe0]
0x0000f9c8  stp      x29, x30, [sp, #0xf0]
0x0000f9cc  add      x29, sp, #0xf0
0x0000f9d0  mov      x19, x2
0x0000f9d4  mov      x21, x0
0x0000f9d8  mov      x0, x2
0x0000f9dc  bl       #0x24818   ; call _objc_retain
0x0000f9e0  mov      x0, x19
0x0000f9e4  bl       #0x24d00   ; objc_msgSend: appViewController
0x0000f9e8  mov      x29, x29
0x0000f9ec  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000f9f0  mov      x20, x0
0x0000f9f4  adrp     x0, #0x36000
0x0000f9f8  add      x0, x0, #0x130   ; -> @"sceneHandle"
0x0000f9fc  bl       #0x2441c   ; call _NSSelectorFromString
0x0000fa00  mov      x22, x0
0x0000fa04  mov      x0, x20
0x0000fa08  mov      x1, x22
0x0000fa0c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000fa10  tbz      w0, #0, #0xfa30
0x0000fa14  mov      x0, x20
0x0000fa18  mov      x1, x22
0x0000fa1c  bl       #0x247ac   ; call _objc_msgSend
0x0000fa20  mov      x29, x29
0x0000fa24  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000fa28  mov      x23, x0
0x0000fa2c  b        #0xfa44   ; call sub_fa44
0x0000fa30  adrp     x1, #0x36000
0x0000fa34  add      x1, x1, #0x130   ; -> @"sceneHandle"
0x0000fa38  mov      x0, x20
0x0000fa3c  bl       #0x9698   ; call _ABMissingSelector
0x0000fa40  mov      x23, #0
0x0000fa44  mov      x0, x20
0x0000fa48  bl       #0x2480c   ; call _objc_release
0x0000fa4c  adrp     x0, #0x36000
0x0000fa50  add      x0, x0, #0x150   ; -> @"sceneIfExists"
0x0000fa54  bl       #0x2441c   ; call _NSSelectorFromString
0x0000fa58  mov      x20, x0
0x0000fa5c  mov      x0, x23
0x0000fa60  mov      x1, x20
0x0000fa64  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000fa68  tbz      w0, #0, #0xfa88
0x0000fa6c  mov      x0, x23
0x0000fa70  mov      x1, x20
0x0000fa74  bl       #0x247ac   ; call _objc_msgSend
0x0000fa78  mov      x29, x29
0x0000fa7c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000fa80  mov      x20, x0
0x0000fa84  b        #0xfa9c   ; call sub_fa9c
0x0000fa88  adrp     x1, #0x36000
0x0000fa8c  add      x1, x1, #0x150   ; -> @"sceneIfExists"
0x0000fa90  mov      x0, x23
0x0000fa94  bl       #0x9698   ; call _ABMissingSelector
0x0000fa98  mov      x20, #0
0x0000fa9c  mov      x0, x23
0x0000faa0  bl       #0x2480c   ; call _objc_release
0x0000faa4  cbz      x20, #0xfc48
0x0000faa8  mov      x0, x21
0x0000faac  bl       #0x28260   ; objc_msgSend: zoom
0x0000fab0  mov      v8.16b, v0.16b
0x0000fab4  mov      x0, x19
0x0000fab8  bl       #0x24f60   ; objc_msgSend: box
0x0000fabc  mov      x29, x29
0x0000fac0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000fac4  mov      x23, x0
0x0000fac8  bl       #0x24f40   ; objc_msgSend: bounds
0x0000facc  mov      v9.16b, v2.16b
0x0000fad0  mov      v10.16b, v3.16b
0x0000fad4  mov      x0, x23
0x0000fad8  bl       #0x2480c   ; call _objc_release
0x0000fadc  mov      x0, x21
0x0000fae0  mov      x2, x19
0x0000fae4  bl       #0x256a0   ; objc_msgSend: effectiveOrientation:
0x0000fae8  fdiv     d0, d10, d8
0x0000faec  frinta   d0, d0
0x0000faf0  fdiv     d1, d9, d8
0x0000faf4  frinta   d1, d1
0x0000faf8  sub      x8, x0, #3
0x0000fafc  cmp      x8, #2
0x0000fb00  fcsel    d9, d1, d0, lo
0x0000fb04  fcsel    d8, d0, d1, lo
0x0000fb08  mov      x0, x20
0x0000fb0c  bl       #0x24818   ; call _objc_retain
0x0000fb10  adrp     x0, #0x36000
0x0000fb14  add      x0, x0, #0x170   ; -> @"updateSettingsWithBlock:"
0x0000fb18  bl       #0x2441c   ; call _NSSelectorFromString
0x0000fb1c  mov      x22, x0
0x0000fb20  mov      x0, x20
0x0000fb24  mov      x1, x22
0x0000fb28  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000fb2c  tbz      w0, #0, #0xfb88
0x0000fb30  fmov     d0, #-1.00000000
0x0000fb34  fadd     d0, d9, d0
0x0000fb38  fmov     d1, #1.00000000
0x0000fb3c  fmaxnm   d0, d0, d1
0x0000fb40  adrp     x8, #0x34000
0x0000fb44  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x0000fb48  str      x8, [sp, #0x50]
0x0000fb4c  adrp     x8, #0x2b000
0x0000fb50  ldr      d1, [x8, #0x1e8]
0x0000fb54  str      d1, [sp, #0x58]
0x0000fb58  adrp     x8, #0xf000
0x0000fb5c  add      x8, x8, #0xd98
0x0000fb60  adrp     x9, #0x34000
0x0000fb64  add      x9, x9, #0x940
0x0000fb68  stp      x8, x9, [sp, #0x60]
0x0000fb6c  stp      xzr, xzr, [sp, #0x70]
0x0000fb70  stp      d8, d0, [sp, #0x80]
0x0000fb74  add      x2, sp, #0x50
0x0000fb78  mov      x0, x20
0x0000fb7c  mov      x1, x22
0x0000fb80  bl       #0x247ac   ; call _objc_msgSend
0x0000fb84  b        #0xfb98   ; call sub_fb98
0x0000fb88  adrp     x1, #0x36000
0x0000fb8c  add      x1, x1, #0x170   ; -> @"updateSettingsWithBlock:"
0x0000fb90  mov      x0, x20
0x0000fb94  bl       #0x9698   ; call _ABMissingSelector
0x0000fb98  mov      x0, x20
0x0000fb9c  bl       #0x2480c   ; call _objc_release
0x0000fba0  add      x0, sp, #0x48
0x0000fba4  mov      x1, x21
0x0000fba8  bl       #0x24794   ; call _objc_initWeak
0x0000fbac  add      x0, sp, #0x40
0x0000fbb0  mov      x1, x19
0x0000fbb4  bl       #0x24794   ; call _objc_initWeak
0x0000fbb8  mov      x0, #0
0x0000fbbc  mov      w1, #0xf080
0x0000fbc0  movk     w1, #0x2fa, lsl #16
0x0000fbc4  bl       #0x245cc   ; call _dispatch_time
0x0000fbc8  mov      x21, x0
0x0000fbcc  adrp     x8, #0x34000
0x0000fbd0  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x0000fbd4  str      x8, [sp, #0x10]
0x0000fbd8  adrp     x8, #0x2b000
0x0000fbdc  ldr      d0, [x8, #0x1d0]
0x0000fbe0  adrp     x8, #0xf000
0x0000fbe4  add      x8, x8, #0xdf8
0x0000fbe8  str      d0, [sp, #0x18]
0x0000fbec  adrp     x9, #0x34000
0x0000fbf0  add      x9, x9, #0x8c0
0x0000fbf4  stp      x8, x9, [sp, #0x20]
0x0000fbf8  add      x22, sp, #0x10
0x0000fbfc  add      x0, x22, #0x20
0x0000fc00  add      x1, sp, #0x40
0x0000fc04  bl       #0x2474c   ; call _objc_copyWeak
0x0000fc08  add      x0, x22, #0x28
0x0000fc0c  add      x1, sp, #0x48
0x0000fc10  bl       #0x2474c   ; call _objc_copyWeak
0x0000fc14  adrp     x1, #0x34000
0x0000fc18  ldr      x1, [x1, #0x290]   ; -> [got:__dispatch_main_q]
0x0000fc1c  add      x2, sp, #0x10
0x0000fc20  mov      x0, x21
0x0000fc24  bl       #0x24548   ; call _dispatch_after
0x0000fc28  add      x0, x22, #0x28
0x0000fc2c  bl       #0x24758   ; call _objc_destroyWeak
0x0000fc30  add      x0, x22, #0x20
0x0000fc34  bl       #0x24758   ; call _objc_destroyWeak
0x0000fc38  add      x0, sp, #0x40
0x0000fc3c  bl       #0x24758   ; call _objc_destroyWeak
0x0000fc40  add      x0, sp, #0x48
0x0000fc44  bl       #0x24758   ; call _objc_destroyWeak
0x0000fc48  mov      x0, x20
0x0000fc4c  bl       #0x2480c   ; call _objc_release
0x0000fc50  mov      x0, x19
0x0000fc54  bl       #0x2480c   ; call _objc_release
0x0000fc58  ldp      x29, x30, [sp, #0xf0]
0x0000fc5c  ldp      x20, x19, [sp, #0xe0]
0x0000fc60  ldp      x22, x21, [sp, #0xd0]
0x0000fc64  ldp      x24, x23, [sp, #0xc0]
0x0000fc68  ldp      x26, x25, [sp, #0xb0]
0x0000fc6c  ldp      d9, d8, [sp, #0xa0]
0x0000fc70  ldp      d11, d10, [sp, #0x90]
0x0000fc74  add      sp, sp, #0x100
0x0000fc78  ret      
0x0000fc7c  b        #0xfd7c   ; call sub_fd7c
0x0000fc80  mov      x22, x0
0x0000fc84  mov      x0, x23
0x0000fc88  bl       #0x2480c   ; call _objc_release
0x0000fc8c  b        #0xfd80   ; call sub_fd80
0x0000fc90  b        #0xfd7c   ; call sub_fd7c
0x0000fc94  b        #0xfd7c   ; call sub_fd7c
0x0000fc98  b        #0xfd70   ; call sub_fd70
0x0000fc9c  b        #0xfd7c   ; call sub_fd7c
0x0000fca0  mov      x22, x0
0x0000fca4  b        #0xfd88   ; call sub_fd88
0x0000fca8  mov      x23, x1
0x0000fcac  mov      x22, x0
0x0000fcb0  mov      x0, x20
0x0000fcb4  bl       #0x2480c   ; call _objc_release
0x0000fcb8  cmp      w23, #1
0x0000fcbc  b.ne     #0xfd80
0x0000fcc0  mov      x0, x22
0x0000fcc4  bl       #0x24740   ; call _objc_begin_catch
0x0000fcc8  mov      x23, x0
0x0000fccc  bl       #0x24818   ; call _objc_retain
0x0000fcd0  adrp     x8, #0x3e000
0x0000fcd4  ldr      x22, [x8, #0x290]   ; -> [class(NSString)]
0x0000fcd8  mov      x0, x19
0x0000fcdc  bl       #0x25020   ; objc_msgSend: bundleID
0x0000fce0  mov      x29, x29
0x0000fce4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000fce8  mov      x24, x0
0x0000fcec  stp      x0, x23, [sp]
0x0000fcf0  adrp     x2, #0x36000
0x0000fcf4  add      x2, x2, #0x270   ; -> @"nudge %@ loi %@"
0x0000fcf8  mov      x0, x22
0x0000fcfc  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000fd00  mov      x29, x29
0x0000fd04  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000fd08  mov      x25, x0
0x0000fd0c  adrp     x0, #0x34000
0x0000fd10  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000fd14  mov      x1, x25
0x0000fd18  bl       #0x1dd30   ; call _OMCLogWrite
0x0000fd1c  mov      x0, x25
0x0000fd20  bl       #0x2480c   ; call _objc_release
0x0000fd24  mov      x0, x24
0x0000fd28  bl       #0x2480c   ; call _objc_release
0x0000fd2c  mov      x0, x23
0x0000fd30  bl       #0x2480c   ; call _objc_release
0x0000fd34  bl       #0x24764   ; call _objc_end_catch
0x0000fd38  b        #0xfba0   ; call sub_fba0
0x0000fd3c  mov      x22, x0
0x0000fd40  mov      x0, x25
0x0000fd44  bl       #0x2480c   ; call _objc_release
0x0000fd48  b        #0xfd50   ; call sub_fd50
0x0000fd4c  mov      x22, x0
0x0000fd50  mov      x0, x24
0x0000fd54  bl       #0x2480c   ; call _objc_release
0x0000fd58  b        #0xfd60   ; call sub_fd60
0x0000fd5c  mov      x22, x0
0x0000fd60  mov      x0, x23
0x0000fd64  bl       #0x2480c   ; call _objc_release
0x0000fd68  bl       #0x24764   ; call _objc_end_catch
0x0000fd6c  b        #0xfd80   ; call sub_fd80
0x0000fd70  mov      x22, x0
0x0000fd74  mov      x0, x23
0x0000fd78  b        #0xfd84   ; call sub_fd84
0x0000fd7c  mov      x22, x0
0x0000fd80  mov      x0, x20
0x0000fd84  bl       #0x2480c   ; call _objc_release
0x0000fd88  mov      x0, x19
0x0000fd8c  bl       #0x2480c   ; call _objc_release
0x0000fd90  mov      x0, x22
0x0000fd94  bl       #0x24470   ; call __Unwind_Resume
0x0000fd98  stp      x20, x19, [sp, #-0x20]!
0x0000fd9c  stp      x29, x30, [sp, #0x10]
0x0000fda0  add      x29, sp, #0x10
0x0000fda4  mov      x19, x1
0x0000fda8  mov      x20, x0
0x0000fdac  mov      x0, x1
0x0000fdb0  bl       #0x24818   ; call _objc_retain
0x0000fdb4  adrp     x0, #0x36000
0x0000fdb8  add      x0, x0, #0x190   ; -> @"setFrame:"
0x0000fdbc  bl       #0x2441c   ; call _NSSelectorFromString
0x0000fdc0  mov      x1, x0
0x0000fdc4  ldp      d0, d1, [x20, #0x20]
0x0000fdc8  ldp      d2, d3, [x20, #0x30]
0x0000fdcc  mov      x0, x19
0x0000fdd0  bl       #0x247ac   ; call _objc_msgSend
0x0000fdd4  mov      x0, x19
0x0000fdd8  ldp      x29, x30, [sp, #0x10]
0x0000fddc  ldp      x20, x19, [sp], #0x20
0x0000fde0  b        #0x2480c   ; call _objc_release
0x0000fde4  mov      x20, x0
0x0000fde8  mov      x0, x19
0x0000fdec  bl       #0x2480c   ; call _objc_release
0x0000fdf0  mov      x0, x20
0x0000fdf4  bl       #0x24470   ; call __Unwind_Resume
0x0000fdf8  stp      x22, x21, [sp, #-0x30]!
0x0000fdfc  stp      x20, x19, [sp, #0x10]
0x0000fe00  stp      x29, x30, [sp, #0x20]
0x0000fe04  add      x29, sp, #0x20
0x0000fe08  mov      x20, x0
0x0000fe0c  add      x0, x0, #0x20
0x0000fe10  bl       #0x247a0   ; call _objc_loadWeakRetained
0x0000fe14  mov      x19, x0
0x0000fe18  cbz      x0, #0xfe38
0x0000fe1c  add      x0, x20, #0x28
0x0000fe20  bl       #0x247a0   ; call _objc_loadWeakRetained
0x0000fe24  mov      x20, x0
0x0000fe28  mov      x2, x19
0x0000fe2c  bl       #0x25f60   ; objc_msgSend: layoutPane:
0x0000fe30  mov      x0, x20
0x0000fe34  bl       #0x2480c   ; call _objc_release
0x0000fe38  mov      x0, x19
0x0000fe3c  ldp      x29, x30, [sp, #0x20]
0x0000fe40  ldp      x20, x19, [sp, #0x10]
0x0000fe44  ldp      x22, x21, [sp], #0x30
0x0000fe48  b        #0x2480c   ; call _objc_release
0x0000fe4c  mov      x21, x0
0x0000fe50  mov      x0, x20
0x0000fe54  bl       #0x2480c   ; call _objc_release
0x0000fe58  mov      x0, x19
0x0000fe5c  bl       #0x2480c   ; call _objc_release
0x0000fe60  mov      x0, x21
0x0000fe64  bl       #0x24470   ; call __Unwind_Resume
0x0000fe68  sub      sp, sp, #0x100
0x0000fe6c  stp      d15, d14, [sp, #0x70]
0x0000fe70  stp      d13, d12, [sp, #0x80]
0x0000fe74  stp      d11, d10, [sp, #0x90]
0x0000fe78  stp      d9, d8, [sp, #0xa0]
0x0000fe7c  stp      x26, x25, [sp, #0xb0]
0x0000fe80  stp      x24, x23, [sp, #0xc0]
0x0000fe84  stp      x22, x21, [sp, #0xd0]
0x0000fe88  stp      x20, x19, [sp, #0xe0]
0x0000fe8c  stp      x29, x30, [sp, #0xf0]
0x0000fe90  add      x29, sp, #0xf0
0x0000fe94  mov      v12.16b, v7.16b
0x0000fe98  mov      v13.16b, v6.16b
0x0000fe9c  mov      v14.16b, v5.16b
0x0000fea0  mov      v15.16b, v4.16b
0x0000fea4  mov      x23, x4
0x0000fea8  mov      x22, x3
0x0000feac  mov      x19, x2
0x0000feb0  mov      v8.16b, v3.16b
0x0000feb4  mov      v9.16b, v2.16b
0x0000feb8  mov      v10.16b, v1.16b
0x0000febc  mov      v11.16b, v0.16b
0x0000fec0  mov      x21, x0
0x0000fec4  mov      x0, x2
0x0000fec8  bl       #0x24818   ; call _objc_retain
0x0000fecc  mov      x0, x21
0x0000fed0  mov      x2, x19
