=== -[OMCAppBridgeAppsController layoutPage]  va=0x1c910 size=8 types=B16@0:8
0x0001c910  mov      w0, #0
0x0001c914  ret      

=== -[OMCAppBridgeAppsController shows:]  va=0x1c918 size=44 types=B24@0:8q16
0x0001c918  stp      x20, x19, [sp, #-0x20]!
0x0001c91c  stp      x29, x30, [sp, #0x10]
0x0001c920  add      x29, sp, #0x10
0x0001c924  sub      x8, x2, #1
0x0001c928  cmp      x8, #2
0x0001c92c  cset     w19, lo
0x0001c930  bl       #0x58b60   ; CALL objc_msgSend$layoutPage
0x0001c934  eor      w0, w19, w0
0x0001c938  ldp      x29, x30, [sp, #0x10]
0x0001c93c  ldp      x20, x19, [sp], #0x20
0x0001c940  ret      

=== -[OMCAppBridgeAppsController loadView]  va=0x1c944 size=132 types=v16@0:8
0x0001c944  stp      x20, x19, [sp, #-0x20]!
0x0001c948  stp      x29, x30, [sp, #0x10]
0x0001c94c  add      x29, sp, #0x10
0x0001c950  mov      x19, x0
0x0001c954  adrp     x8, #0x8e000
0x0001c958  ldr      x0, [x8, #0x900]   ; @CLASS UITableView
0x0001c95c  bl       #0x55c7c   ; CALL _objc_alloc
0x0001c960  adrp     x8, #0x74000
0x0001c964  ldr      x8, [x8, #0x610]   ; @GOT _CGRectZero
0x0001c968  ldp      d0, d1, [x8]
0x0001c96c  ldp      d2, d3, [x8, #0x10]
0x0001c970  mov      w2, #2
0x0001c974  bl       #0x584a0   ; CALL objc_msgSend$initWithFrame:style:
0x0001c978  adrp     x8, #0x8e000
0x0001c97c  ldrsw    x20, [x8, #0xe58]
0x0001c980  ldr      x8, [x19, x20]
0x0001c984  str      x0, [x19, x20]
0x0001c988  mov      x0, x8
0x0001c98c  bl       #0x55d78   ; CALL _objc_release
0x0001c990  ldr      x0, [x19, x20]
0x0001c994  mov      x2, x19
0x0001c998  bl       #0x5ac00   ; CALL objc_msgSend$setDataSource:
0x0001c99c  ldr      x0, [x19, x20]
0x0001c9a0  mov      x2, x19
0x0001c9a4  bl       #0x5aca0   ; CALL objc_msgSend$setDelegate:
0x0001c9a8  ldr      x0, [x19, x20]
0x0001c9ac  mov      w2, #1
0x0001c9b0  bl       #0x5b1e0   ; CALL objc_msgSend$setKeyboardDismissMode:
0x0001c9b4  ldr      x2, [x19, x20]
0x0001c9b8  mov      x0, x19
0x0001c9bc  ldp      x29, x30, [sp, #0x10]
0x0001c9c0  ldp      x20, x19, [sp], #0x20
0x0001c9c4  b        #0x5c840   ; CALL objc_msgSend$setView:

=== -[OMCAppBridgeAppsController viewDidLoad]  va=0x1c9c8 size=556 types=v16@0:8
0x0001c9c8  sub      sp, sp, #0x40
0x0001c9cc  stp      x22, x21, [sp, #0x10]
0x0001c9d0  stp      x20, x19, [sp, #0x20]
0x0001c9d4  stp      x29, x30, [sp, #0x30]
0x0001c9d8  add      x29, sp, #0x30
0x0001c9dc  mov      x19, x0
0x0001c9e0  adrp     x8, #0x8e000
0x0001c9e4  ldr      x8, [x8, #0xd58]   ; @SUPER OMCAppBridgeAppsController
0x0001c9e8  stp      x0, x8, [sp]
0x0001c9ec  adrp     x8, #0x8b000
0x0001c9f0  ldr      x1, [x8, #0xda0]   ; @SEL "viewDidLoad"
0x0001c9f4  mov      x0, sp
0x0001c9f8  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0001c9fc  bl       #0x17a44   ; CALL _OMCLoadStrings
0x0001ca00  mov      x0, x19
0x0001ca04  bl       #0x5cdc0   ; CALL objc_msgSend$specifier
0x0001ca08  mov      x29, x29
0x0001ca0c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ca10  mov      x20, x0
0x0001ca14  bl       #0x590e0   ; CALL objc_msgSend$name
0x0001ca18  mov      x29, x29
0x0001ca1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ca20  mov      x21, x0
0x0001ca24  cbz      x0, #0x1ca38
0x0001ca28  mov      x0, x19
0x0001ca2c  mov      x2, x21
0x0001ca30  bl       #0x5c5e0   ; CALL objc_msgSend$setTitle:
0x0001ca34  b        #0x1ca7c
0x0001ca38  mov      x0, x19
0x0001ca3c  bl       #0x58b60   ; CALL objc_msgSend$layoutPage
0x0001ca40  adrp     x8, #0x79000
0x0001ca44  add      x8, x8, #0x148   ; STR "APPS_TITLE"
0x0001ca48  adrp     x9, #0x76000
0x0001ca4c  add      x9, x9, #0xee8   ; STR "HOME_SCREEN"
0x0001ca50  cmp      w0, #0
0x0001ca54  csel     x0, x9, x8, ne
0x0001ca58  bl       #0x17e20   ; CALL _L
0x0001ca5c  mov      x29, x29
0x0001ca60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ca64  mov      x22, x0
0x0001ca68  mov      x0, x19
0x0001ca6c  mov      x2, x22
0x0001ca70  bl       #0x5c5e0   ; CALL objc_msgSend$setTitle:
0x0001ca74  mov      x0, x22
0x0001ca78  bl       #0x55d78   ; CALL _objc_release
0x0001ca7c  mov      x0, x21
0x0001ca80  bl       #0x55d78   ; CALL _objc_release
0x0001ca84  mov      x0, x20
0x0001ca88  bl       #0x55d78   ; CALL _objc_release
0x0001ca8c  bl       #0x17e8c   ; CALL _OMCAccentColor
0x0001ca90  mov      x29, x29
0x0001ca94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ca98  mov      x20, x0
0x0001ca9c  mov      x0, x19
0x0001caa0  bl       #0x5df60   ; CALL objc_msgSend$view
0x0001caa4  mov      x29, x29
0x0001caa8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001caac  mov      x21, x0
0x0001cab0  mov      x2, x20
0x0001cab4  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x0001cab8  mov      x0, x21
0x0001cabc  bl       #0x55d78   ; CALL _objc_release
0x0001cac0  mov      x0, x20
0x0001cac4  bl       #0x55d78   ; CALL _objc_release
0x0001cac8  adrp     x8, #0x8e000
0x0001cacc  ldrsw    x20, [x8, #0xe58]
0x0001cad0  ldr      x0, [x19, x20]
0x0001cad4  bl       #0x18828   ; CALL _OMCStyleTable
0x0001cad8  adrp     x8, #0x8e000
0x0001cadc  ldr      x0, [x8, #0xb18]   ; @CLASS NSCache
0x0001cae0  bl       #0x55d60   ; CALL _objc_opt_new
0x0001cae4  adrp     x8, #0x8e000
0x0001cae8  ldrsw    x9, [x8, #0xe5c]
0x0001caec  ldr      x8, [x19, x9]
0x0001caf0  str      x0, [x19, x9]
0x0001caf4  mov      x0, x8
0x0001caf8  bl       #0x55d78   ; CALL _objc_release
0x0001cafc  adrp     x8, #0x8e000
0x0001cb00  ldr      x0, [x8, #0x9a0]   ; @CLASS NSMutableSet
0x0001cb04  adrp     x2, #0x80000
0x0001cb08  add      x2, x2, #0x1c0
0x0001cb0c  bl       #0x5c920   ; CALL objc_msgSend$setWithObject:
0x0001cb10  mov      x29, x29
0x0001cb14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001cb18  adrp     x8, #0x8e000
0x0001cb1c  ldrsw    x9, [x8, #0xe60]
0x0001cb20  ldr      x8, [x19, x9]
0x0001cb24  str      x0, [x19, x9]
0x0001cb28  mov      x0, x8
0x0001cb2c  bl       #0x55d78   ; CALL _objc_release
0x0001cb30  mov      x0, x19
0x0001cb34  bl       #0x58b60   ; CALL objc_msgSend$layoutPage
0x0001cb38  tbnz     w0, #0, #0x1cb54
0x0001cb3c  ldr      x0, [x19, x20]
0x0001cb40  mov      w2, #1
0x0001cb44  bl       #0x5ad60   ; CALL objc_msgSend$setEditing:
0x0001cb48  ldr      x0, [x19, x20]
0x0001cb4c  mov      w2, #1
0x0001cb50  bl       #0x5a3c0   ; CALL objc_msgSend$setAllowsSelectionDuringEditing:
0x0001cb54  adrp     x8, #0x8e000
0x0001cb58  ldr      x0, [x8, #0xad8]   ; @CLASS UIBarButtonItem
0x0001cb5c  bl       #0x55c7c   ; CALL _objc_alloc
0x0001cb60  mov      x20, x0
0x0001cb64  adrp     x0, #0x79000
0x0001cb68  add      x0, x0, #0x168   ; STR "APPS_RESET"
0x0001cb6c  bl       #0x17e20   ; CALL _L
0x0001cb70  mov      x29, x29
0x0001cb74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001cb78  mov      x21, x0
0x0001cb7c  adrp     x8, #0x8b000
0x0001cb80  ldr      x5, [x8, #0xe60]   ; @SEL "resetTapped"
0x0001cb84  mov      x0, x20
0x0001cb88  mov      x2, x21
0x0001cb8c  mov      x3, #0
0x0001cb90  mov      x4, x19
0x0001cb94  bl       #0x58600   ; CALL objc_msgSend$initWithTitle:style:target:action:
0x0001cb98  mov      x20, x0
0x0001cb9c  mov      x0, x19
0x0001cba0  bl       #0x591a0   ; CALL objc_msgSend$navigationItem
0x0001cba4  mov      x29, x29
0x0001cba8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001cbac  mov      x22, x0
0x0001cbb0  mov      x2, x20
0x0001cbb4  bl       #0x5be00   ; CALL objc_msgSend$setRightBarButtonItem:
0x0001cbb8  mov      x0, x22
0x0001cbbc  bl       #0x55d78   ; CALL _objc_release
0x0001cbc0  mov      x0, x20
0x0001cbc4  bl       #0x55d78   ; CALL _objc_release
0x0001cbc8  mov      x0, x21
0x0001cbcc  bl       #0x55d78   ; CALL _objc_release
0x0001cbd0  mov      x0, x19
0x0001cbd4  bl       #0x59ec0   ; CALL objc_msgSend$resetAdvancedOnce
0x0001cbd8  mov      x0, x19
0x0001cbdc  bl       #0x58d20   ; CALL objc_msgSend$loadState
0x0001cbe0  ldp      x29, x30, [sp, #0x30]
0x0001cbe4  ldp      x20, x19, [sp, #0x20]
0x0001cbe8  ldp      x22, x21, [sp, #0x10]
0x0001cbec  add      sp, sp, #0x40
0x0001cbf0  ret      

=== -[OMCAppBridgeAppsController viewWillAppear:]  va=0x1cbf4 size=88 types=v20@0:8B16
0x0001cbf4  sub      sp, sp, #0x30
0x0001cbf8  stp      x20, x19, [sp, #0x10]
0x0001cbfc  stp      x29, x30, [sp, #0x20]
0x0001cc00  add      x29, sp, #0x20
0x0001cc04  mov      x19, x0
0x0001cc08  adrp     x8, #0x8e000
0x0001cc0c  ldr      x8, [x8, #0xd58]   ; @SUPER OMCAppBridgeAppsController
0x0001cc10  stp      x0, x8, [sp]
0x0001cc14  adrp     x8, #0x8b000
0x0001cc18  ldr      x1, [x8, #0xda8]   ; @SEL "viewWillAppear:"
0x0001cc1c  mov      x0, sp
0x0001cc20  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0001cc24  mov      x0, x19
0x0001cc28  bl       #0x58d20   ; CALL objc_msgSend$loadState
0x0001cc2c  adrp     x8, #0x8e000
0x0001cc30  ldrsw    x8, [x8, #0xe58]
0x0001cc34  ldr      x0, [x19, x8]
0x0001cc38  bl       #0x59ca0   ; CALL objc_msgSend$reloadData
0x0001cc3c  ldp      x29, x30, [sp, #0x20]
0x0001cc40  ldp      x20, x19, [sp, #0x10]
0x0001cc44  add      sp, sp, #0x30
0x0001cc48  ret      

=== -[OMCAppBridgeAppsController resetAdvancedOnce]  va=0x1cc4c size=396 types=v16@0:8
0x0001cc4c  sub      sp, sp, #0x110
0x0001cc50  stp      x24, x23, [sp, #0xd0]
0x0001cc54  stp      x22, x21, [sp, #0xe0]
0x0001cc58  stp      x20, x19, [sp, #0xf0]
0x0001cc5c  stp      x29, x30, [sp, #0x100]
0x0001cc60  add      x29, sp, #0x100
0x0001cc64  adrp     x8, #0x74000
0x0001cc68  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0001cc6c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001cc70  stur     x8, [x29, #-0x38]
0x0001cc74  adrp     x0, #0x79000
0x0001cc78  add      x0, x0, #0x188   ; STR "appBridgeAdvancedReset"
0x0001cc7c  bl       #0x1cd84
0x0001cc80  mov      x29, x29
0x0001cc84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001cc88  mov      x19, x0
0x0001cc8c  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x0001cc90  mov      x20, x0
0x0001cc94  mov      x0, x19
0x0001cc98  bl       #0x55d78   ; CALL _objc_release
0x0001cc9c  tbnz     w20, #0, #0x1cd50
0x0001cca0  movi     v0.16b, #0
0x0001cca4  stp      q0, q0, [sp, #0x20]
0x0001cca8  stp      q0, q0, [sp]
0x0001ccac  adrp     x0, #0x7f000
0x0001ccb0  add      x0, x0, #0x960
0x0001ccb4  mov      x2, sp
0x0001ccb8  add      x3, sp, #0x48
0x0001ccbc  mov      w4, #0x10
0x0001ccc0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001ccc4  cbz      x0, #0x1cd3c
0x0001ccc8  mov      x21, x0
0x0001cccc  ldr      x8, [sp, #0x10]
0x0001ccd0  ldr      x22, [x8]   ; @GOT ___objc_personality_v0
0x0001ccd4  adrp     x19, #0x75000
0x0001ccd8  add      x19, x19, #0x28   ; STR "com.anlai.omnicar"
0x0001ccdc  adrp     x20, #0x7f000
0x0001cce0  add      x20, x20, #0x960
0x0001cce4  mov      x23, #0
0x0001cce8  ldr      x8, [sp, #0x10]
0x0001ccec  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001ccf0  cmp      x8, x22
0x0001ccf4  b.eq     #0x1cd00
0x0001ccf8  mov      x0, x20
0x0001ccfc  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0001cd00  ldr      x8, [sp, #8]
0x0001cd04  ldr      x0, [x8, x23, lsl #3]   ; @GOT ___objc_personality_v0
0x0001cd08  mov      x1, #0
0x0001cd0c  mov      x2, x19
0x0001cd10  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x0001cd14  add      x23, x23, #1
0x0001cd18  cmp      x21, x23
0x0001cd1c  b.ne     #0x1cce8
0x0001cd20  mov      x2, sp
0x0001cd24  add      x3, sp, #0x48
0x0001cd28  mov      x0, x20
0x0001cd2c  mov      w4, #0x10
0x0001cd30  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001cd34  mov      x21, x0
0x0001cd38  cbnz     x0, #0x1cce4
0x0001cd3c  adrp     x0, #0x79000
0x0001cd40  add      x0, x0, #0x188   ; STR "appBridgeAdvancedReset"
0x0001cd44  adrp     x1, #0x74000
0x0001cd48  ldr      x1, [x1, #0x1b8]   ; @GOT ___kCFBooleanTrue
0x0001cd4c  bl       #0x1cda0
0x0001cd50  ldur     x8, [x29, #-0x38]
0x0001cd54  adrp     x9, #0x74000
0x0001cd58  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0001cd5c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0001cd60  cmp      x9, x8
0x0001cd64  b.ne     #0x1cd80
0x0001cd68  ldp      x29, x30, [sp, #0x100]
0x0001cd6c  ldp      x20, x19, [sp, #0xf0]
0x0001cd70  ldp      x22, x21, [sp, #0xe0]
0x0001cd74  ldp      x24, x23, [sp, #0xd0]
0x0001cd78  add      sp, sp, #0x110
0x0001cd7c  ret      
0x0001cd80  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0001cd84  stp      x29, x30, [sp, #-0x10]!
0x0001cd88  mov      x29, sp
0x0001cd8c  adrp     x1, #0x75000
0x0001cd90  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x0001cd94  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x0001cd98  ldp      x29, x30, [sp], #0x10
0x0001cd9c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0001cda0  stp      x20, x19, [sp, #-0x20]!
0x0001cda4  stp      x29, x30, [sp, #0x10]
0x0001cda8  add      x29, sp, #0x10
0x0001cdac  adrp     x19, #0x75000
0x0001cdb0  add      x19, x19, #0x28   ; STR "com.anlai.omnicar"
0x0001cdb4  mov      x2, x19
0x0001cdb8  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x0001cdbc  mov      x0, x19
0x0001cdc0  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x0001cdc4  adrp     x0, #0x61000
0x0001cdc8  add      x0, x0, #0x1b1   ; CSTR "com.anlai.omnicar/prefschanged"
0x0001cdcc  ldp      x29, x30, [sp, #0x10]
0x0001cdd0  ldp      x20, x19, [sp], #0x20
0x0001cdd4  b        #0x55c70   ; CALL _notify_post

=== -[OMCAppBridgeAppsController loadState]  va=0x1cdd8 size=3924 types=v16@0:8
0x0001cdd8  stp      x28, x27, [sp, #-0x60]!
0x0001cddc  stp      x26, x25, [sp, #0x10]
0x0001cde0  stp      x24, x23, [sp, #0x20]
0x0001cde4  stp      x22, x21, [sp, #0x30]
0x0001cde8  stp      x20, x19, [sp, #0x40]
0x0001cdec  stp      x29, x30, [sp, #0x50]
0x0001cdf0  add      x29, sp, #0x50
0x0001cdf4  sub      sp, sp, #0x6d0
0x0001cdf8  mov      x19, x0
0x0001cdfc  adrp     x8, #0x74000
0x0001ce00  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0001ce04  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001ce08  stur     x8, [x29, #-0x60]
0x0001ce0c  adrp     x0, #0x75000
0x0001ce10  add      x0, x0, #0x28   ; STR "com.anlai.omnicar"
0x0001ce14  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x0001ce18  adrp     x8, #0x8e000
0x0001ce1c  ldrsw    x10, [x8, #0xe64]
0x0001ce20  ldr      x8, [x19, x10]
0x0001ce24  adrp     x9, #0x8e000
0x0001ce28  cbnz     x8, #0x1d1e0
0x0001ce2c  str      x10, [sp, #8]
0x0001ce30  ldr      x0, [x9, #0x988]   ; @CLASS NSMutableArray
0x0001ce34  bl       #0x565c0   ; CALL objc_msgSend$array
0x0001ce38  mov      x29, x29
0x0001ce3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ce40  str      x0, [sp, #0x10]
0x0001ce44  adrp     x0, #0x62000
0x0001ce48  add      x0, x0, #0x227   ; CSTR "LSApplicationWorkspace"
0x0001ce4c  bl       #0x55d0c   ; CALL _objc_getClass
0x0001ce50  adrp     x1, #0x77000
0x0001ce54  add      x1, x1, #0x7e8   ; STR "defaultWorkspace"
0x0001ce58  bl       #0x24d80
0x0001ce5c  mov      x29, x29
0x0001ce60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ce64  mov      x20, x0
0x0001ce68  adrp     x1, #0x79000
0x0001ce6c  add      x1, x1, #0xca8   ; STR "allInstalledApplications"
0x0001ce70  bl       #0x24d80
0x0001ce74  mov      x29, x29
0x0001ce78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ce7c  mov      x27, x0
0x0001ce80  mov      x0, x20
0x0001ce84  bl       #0x55d78   ; CALL _objc_release
0x0001ce88  adrp     x8, #0x8e000
0x0001ce8c  ldr      x0, [x8, #0x9b0]   ; @CLASS NSSet
0x0001ce90  adrp     x2, #0x7f000
0x0001ce94  add      x2, x2, #0xa80
0x0001ce98  bl       #0x5c900   ; CALL objc_msgSend$setWithArray:
0x0001ce9c  mov      x29, x29
0x0001cea0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001cea4  mov      x26, x0
0x0001cea8  movi     v0.16b, #0
0x0001ceac  str      q0, [sp, #0x5c0]
0x0001ceb0  str      q0, [sp, #0x5d0]
0x0001ceb4  str      q0, [sp, #0x5e0]
0x0001ceb8  str      q0, [sp, #0x5f0]
0x0001cebc  mov      x0, x27
0x0001cec0  bl       #0x55d84   ; CALL _objc_retain
0x0001cec4  add      x2, sp, #0x5c0
0x0001cec8  add      x3, sp, #0xb8
0x0001cecc  mov      x0, x27
0x0001ced0  mov      w4, #0x10
0x0001ced4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001ced8  cbz      x0, #0x1d144
0x0001cedc  mov      x25, x0
0x0001cee0  adrp     x23, #0x79000
0x0001cee4  add      x23, x23, #0xd48   ; STR "bundleIdentifier"
0x0001cee8  ldr      x8, [sp, #0x5d0]
0x0001ceec  ldr      x22, [x8]   ; @SEL "whatsNewNavigationController"
0x0001cef0  stp      x27, x26, [sp, #0x20]
0x0001cef4  mov      x21, #0
0x0001cef8  ldr      x8, [sp, #0x5d0]
0x0001cefc  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0001cf00  cmp      x8, x22
0x0001cf04  b.eq     #0x1cf10
0x0001cf08  mov      x0, x27
0x0001cf0c  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0001cf10  ldr      x8, [sp, #0x5c8]
0x0001cf14  ldr      x24, [x8, x21, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0001cf18  mov      x0, x24
0x0001cf1c  mov      x1, x23
0x0001cf20  bl       #0x24d80
0x0001cf24  mov      x29, x29
0x0001cf28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001cf2c  mov      x28, x0
0x0001cf30  adrp     x8, #0x8e000
0x0001cf34  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0001cf38  bl       #0x55d48   ; CALL _objc_opt_class
0x0001cf3c  mov      x1, x0
0x0001cf40  mov      x0, x28
0x0001cf44  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0001cf48  tbz      w0, #0, #0x1d114
0x0001cf4c  mov      x0, x28
0x0001cf50  bl       #0x58c20   ; CALL objc_msgSend$length
0x0001cf54  cbz      x0, #0x1d114
0x0001cf58  mov      x0, x26
0x0001cf5c  mov      x2, x28
0x0001cf60  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0001cf64  tbnz     w0, #0, #0x1d114
0x0001cf68  mov      x0, x24
0x0001cf6c  adrp     x1, #0x79000
0x0001cf70  add      x1, x1, #0xd68   ; STR "applicationType"
0x0001cf74  bl       #0x24d80
0x0001cf78  mov      x29, x29
0x0001cf7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001cf80  mov      x20, x0
0x0001cf84  adrp     x2, #0x79000
0x0001cf88  add      x2, x2, #0xd88   ; STR "User"
0x0001cf8c  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0001cf90  mov      x26, x0
0x0001cf94  tbnz     w0, #0, #0x1cfac
0x0001cf98  mov      x0, x20
0x0001cf9c  adrp     x2, #0x79000
0x0001cfa0  add      x2, x2, #0xda8   ; STR "System"
0x0001cfa4  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0001cfa8  cbz      w0, #0x1d108
0x0001cfac  mov      x0, x24
0x0001cfb0  adrp     x1, #0x79000
0x0001cfb4  add      x1, x1, #0xdc8   ; STR "appTags"
0x0001cfb8  bl       #0x24d80
0x0001cfbc  mov      x29, x29
0x0001cfc0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001cfc4  mov      x27, x0
0x0001cfc8  adrp     x8, #0x8e000
0x0001cfcc  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0001cfd0  bl       #0x55d48   ; CALL _objc_opt_class
0x0001cfd4  mov      x1, x0
0x0001cfd8  mov      x0, x27
0x0001cfdc  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0001cfe0  tbz      w0, #0, #0x1cff8
0x0001cfe4  mov      x0, x27
0x0001cfe8  adrp     x2, #0x79000
0x0001cfec  add      x2, x2, #0xde8   ; STR "hidden"
0x0001cff0  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0001cff4  tbnz     w0, #0, #0x1d0fc
0x0001cff8  mov      x0, x24
0x0001cffc  adrp     x1, #0x79000
0x0001d000  add      x1, x1, #0xe08   ; STR "isLaunchProhibited"
0x0001d004  bl       #0x24e0c
0x0001d008  tbnz     w0, #0, #0x1d0fc
0x0001d00c  mov      x0, x24
0x0001d010  adrp     x1, #0x79000
0x0001d014  add      x1, x1, #0xe28   ; STR "isPlaceholder"
0x0001d018  bl       #0x24e0c
0x0001d01c  tbnz     w0, #0, #0x1d0fc
0x0001d020  mov      x0, x24
0x0001d024  bl       #0x24e90
0x0001d028  tbnz     w0, #0, #0x1d0fc
0x0001d02c  mov      x0, x24
0x0001d030  adrp     x1, #0x79000
0x0001d034  add      x1, x1, #0xc88   ; STR "localizedName"
0x0001d038  bl       #0x24d80
0x0001d03c  mov      x29, x29
0x0001d040  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d044  mov      x24, x0
0x0001d048  adrp     x8, #0x8e000
0x0001d04c  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0001d050  bl       #0x55d48   ; CALL _objc_opt_class
0x0001d054  mov      x1, x0
0x0001d058  mov      x0, x24
0x0001d05c  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0001d060  tbz      w0, #0, #0x1d0f4
0x0001d064  mov      x0, x24
0x0001d068  bl       #0x58c20   ; CALL objc_msgSend$length
0x0001d06c  cbz      x0, #0x1d0f4
0x0001d070  adrp     x8, #0x75000
0x0001d074  add      x9, x8, #0x3e8   ; STR "id"
0x0001d078  adrp     x8, #0x75000
0x0001d07c  add      x8, x8, #0x1e8   ; STR "name"
0x0001d080  stp      x9, x8, [x29, #-0xe0]
0x0001d084  stp      x28, x24, [x29, #-0xa0]
0x0001d088  adrp     x8, #0x79000
0x0001d08c  add      x8, x8, #0xe48   ; STR "system"
0x0001d090  stur     x8, [x29, #-0xd0]
0x0001d094  adrp     x8, #0x8e000
0x0001d098  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x0001d09c  eor      w2, w26, #1
0x0001d0a0  bl       #0x59300   ; CALL objc_msgSend$numberWithInt:
0x0001d0a4  mov      x29, x29
0x0001d0a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d0ac  str      x0, [sp, #0x18]
0x0001d0b0  stur     x0, [x29, #-0x90]
0x0001d0b4  adrp     x8, #0x8e000
0x0001d0b8  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x0001d0bc  sub      x2, x29, #0xa0
0x0001d0c0  sub      x3, x29, #0xe0
0x0001d0c4  mov      w4, #3
0x0001d0c8  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0001d0cc  mov      x29, x29
0x0001d0d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d0d4  mov      x26, x0
0x0001d0d8  ldr      x0, [sp, #0x10]
0x0001d0dc  mov      x2, x26
0x0001d0e0  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0001d0e4  mov      x0, x26
0x0001d0e8  bl       #0x55d78   ; CALL _objc_release
0x0001d0ec  ldr      x0, [sp, #0x18]
0x0001d0f0  bl       #0x55d78   ; CALL _objc_release
0x0001d0f4  mov      x0, x24
0x0001d0f8  bl       #0x55d78   ; CALL _objc_release
0x0001d0fc  mov      x0, x27
0x0001d100  bl       #0x55d78   ; CALL _objc_release
0x0001d104  ldr      x27, [sp, #0x20]
0x0001d108  mov      x0, x20
0x0001d10c  bl       #0x55d78   ; CALL _objc_release
0x0001d110  ldr      x26, [sp, #0x28]
0x0001d114  mov      x0, x28
0x0001d118  bl       #0x55d78   ; CALL _objc_release
0x0001d11c  add      x21, x21, #1
0x0001d120  cmp      x25, x21
0x0001d124  b.ne     #0x1cef8
0x0001d128  add      x2, sp, #0x5c0
0x0001d12c  add      x3, sp, #0xb8
0x0001d130  mov      x0, x27
0x0001d134  mov      w4, #0x10
0x0001d138  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001d13c  mov      x25, x0
0x0001d140  cbnz     x0, #0x1cef4
0x0001d144  mov      x0, x27
0x0001d148  bl       #0x55d78   ; CALL _objc_release
0x0001d14c  adrp     x8, #0x8e000
0x0001d150  ldr      x0, [x8, #0xb80]   ; @CLASS NSSortDescriptor
0x0001d154  adrp     x8, #0x8c000
0x0001d158  ldr      x4, [x8, #0xb10]   ; @SEL "localizedCaseInsensitiveCompare:"
0x0001d15c  adrp     x2, #0x75000
0x0001d160  add      x2, x2, #0x1e8   ; STR "name"
0x0001d164  mov      w3, #1
0x0001d168  bl       #0x5cc60   ; CALL objc_msgSend$sortDescriptorWithKey:ascending:selector:
0x0001d16c  mov      x29, x29
0x0001d170  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d174  mov      x20, x0
0x0001d178  str      x0, [sp, #0x5b8]
0x0001d17c  adrp     x8, #0x8e000
0x0001d180  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0001d184  add      x2, sp, #0x5b8
0x0001d188  mov      w3, #1
0x0001d18c  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0001d190  mov      x29, x29
0x0001d194  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d198  mov      x23, x0
0x0001d19c  ldr      x21, [sp, #0x10]
0x0001d1a0  mov      x0, x21
0x0001d1a4  mov      x2, x23
0x0001d1a8  bl       #0x5cca0   ; CALL objc_msgSend$sortUsingDescriptors:
0x0001d1ac  mov      x0, x23
0x0001d1b0  bl       #0x55d78   ; CALL _objc_release
0x0001d1b4  mov      x0, x20
0x0001d1b8  bl       #0x55d78   ; CALL _objc_release
0x0001d1bc  mov      x0, x26
0x0001d1c0  bl       #0x55d78   ; CALL _objc_release
0x0001d1c4  mov      x0, x27
0x0001d1c8  bl       #0x55d78   ; CALL _objc_release
0x0001d1cc  ldr      x8, [sp, #8]
0x0001d1d0  ldr      x0, [x19, x8]
0x0001d1d4  str      x21, [x19, x8]
0x0001d1d8  bl       #0x55d78   ; CALL _objc_release
0x0001d1dc  adrp     x9, #0x8e000
0x0001d1e0  ldr      x0, [x9, #0x988]   ; @CLASS NSMutableArray
0x0001d1e4  bl       #0x565c0   ; CALL objc_msgSend$array
0x0001d1e8  mov      x29, x29
0x0001d1ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d1f0  str      x0, [sp, #0x28]
0x0001d1f4  adrp     x8, #0x8e000
0x0001d1f8  ldr      x0, [x8, #0x9d0]   ; @CLASS NSMutableDictionary
0x0001d1fc  bl       #0x57780   ; CALL objc_msgSend$dictionary
0x0001d200  mov      x29, x29
0x0001d204  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d208  str      x0, [sp, #0x20]
0x0001d20c  adrp     x8, #0x8e000
0x0001d210  ldr      x0, [x8, #0x9a0]   ; @CLASS NSMutableSet
0x0001d214  bl       #0x5a220   ; CALL objc_msgSend$set
0x0001d218  mov      x29, x29
0x0001d21c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d220  str      x0, [sp, #0x18]
0x0001d224  movi     v0.16b, #0
0x0001d228  stp      q0, q0, [sp, #0x70]
0x0001d22c  stp      q0, q0, [sp, #0x90]
0x0001d230  adrp     x0, #0x79000
0x0001d234  add      x0, x0, #0x1e8   ; STR "homeScreenCarApps"
0x0001d238  bl       #0x1dc60
0x0001d23c  mov      x29, x29
0x0001d240  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d244  mov      x23, x0
0x0001d248  add      x2, sp, #0x70
0x0001d24c  add      x3, sp, #0x538
0x0001d250  mov      w4, #0x10
0x0001d254  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001d258  cbz      x0, #0x1d438
0x0001d25c  mov      x26, x0
0x0001d260  ldr      x8, [sp, #0x80]
0x0001d264  ldr      x20, [x8]   ; @SEL "whatsNewNavigationController"
0x0001d268  adrp     x27, #0x8e000
0x0001d26c  adrp     x24, #0x75000
0x0001d270  add      x24, x24, #0x3e8   ; STR "id"
0x0001d274  mov      x25, #0
0x0001d278  ldr      x8, [sp, #0x80]
0x0001d27c  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0001d280  cmp      x8, x20
0x0001d284  b.eq     #0x1d290
0x0001d288  mov      x0, x23
0x0001d28c  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0001d290  ldr      x8, [sp, #0x78]
0x0001d294  ldr      x28, [x8, x25, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0001d298  ldr      x0, [x27, #0x970]   ; @CLASS NSDictionary
0x0001d29c  bl       #0x55d48   ; CALL _objc_opt_class
0x0001d2a0  mov      x1, x0
0x0001d2a4  mov      x0, x28
0x0001d2a8  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0001d2ac  tbz      w0, #0, #0x1d410
0x0001d2b0  mov      x0, x28
0x0001d2b4  mov      x2, x24
0x0001d2b8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001d2bc  mov      x29, x29
0x0001d2c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d2c4  mov      x21, x0
0x0001d2c8  adrp     x8, #0x8e000
0x0001d2cc  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0001d2d0  bl       #0x55d48   ; CALL _objc_opt_class
0x0001d2d4  mov      x1, x0
0x0001d2d8  mov      x0, x21
0x0001d2dc  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0001d2e0  mov      x22, x0
0x0001d2e4  mov      x0, x21
0x0001d2e8  bl       #0x55d78   ; CALL _objc_release
0x0001d2ec  tbz      w22, #0, #0x1d410
0x0001d2f0  mov      x0, x28
0x0001d2f4  mov      x2, x24
0x0001d2f8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001d2fc  mov      x29, x29
0x0001d300  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d304  mov      x21, x0
0x0001d308  ldr      x0, [sp, #0x28]
0x0001d30c  mov      x2, x21
0x0001d310  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0001d314  mov      x0, x21
0x0001d318  bl       #0x55d78   ; CALL _objc_release
0x0001d31c  mov      x0, x28
0x0001d320  adrp     x2, #0x75000
0x0001d324  add      x2, x2, #0x1e8   ; STR "name"
0x0001d328  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001d32c  mov      x29, x29
0x0001d330  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d334  mov      x21, x0
0x0001d338  adrp     x8, #0x8e000
0x0001d33c  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0001d340  bl       #0x55d48   ; CALL _objc_opt_class
0x0001d344  mov      x1, x0
0x0001d348  mov      x0, x21
0x0001d34c  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0001d350  mov      x22, x0
0x0001d354  mov      x0, x21
0x0001d358  bl       #0x55d78   ; CALL _objc_release
0x0001d35c  tbz      w22, #0, #0x1d3b4
0x0001d360  mov      x0, x28
0x0001d364  adrp     x2, #0x75000
0x0001d368  add      x2, x2, #0x1e8   ; STR "name"
0x0001d36c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001d370  mov      x29, x29
0x0001d374  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d378  mov      x21, x0
0x0001d37c  mov      x0, x28
0x0001d380  mov      x2, x24
0x0001d384  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001d388  mov      x29, x29
0x0001d38c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d390  mov      x22, x0
0x0001d394  ldr      x0, [sp, #0x20]
0x0001d398  mov      x2, x21
0x0001d39c  mov      x3, x22
0x0001d3a0  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0001d3a4  mov      x0, x22
0x0001d3a8  bl       #0x55d78   ; CALL _objc_release
0x0001d3ac  mov      x0, x21
0x0001d3b0  bl       #0x55d78   ; CALL _objc_release
0x0001d3b4  mov      x0, x28
0x0001d3b8  adrp     x2, #0x77000
0x0001d3bc  add      x2, x2, #0xf48   ; STR "off"
0x0001d3c0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001d3c4  mov      x29, x29
0x0001d3c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d3cc  mov      x21, x0
0x0001d3d0  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x0001d3d4  mov      x22, x0
0x0001d3d8  mov      x0, x21
0x0001d3dc  bl       #0x55d78   ; CALL _objc_release
0x0001d3e0  cbz      w22, #0x1d410
0x0001d3e4  mov      x0, x28
0x0001d3e8  mov      x2, x24
0x0001d3ec  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001d3f0  mov      x29, x29
0x0001d3f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d3f8  mov      x21, x0
0x0001d3fc  ldr      x0, [sp, #0x18]
0x0001d400  mov      x2, x21
0x0001d404  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0001d408  mov      x0, x21
0x0001d40c  bl       #0x55d78   ; CALL _objc_release
0x0001d410  add      x25, x25, #1
0x0001d414  cmp      x26, x25
0x0001d418  b.ne     #0x1d278
0x0001d41c  add      x2, sp, #0x70
0x0001d420  add      x3, sp, #0x538
0x0001d424  mov      x0, x23
0x0001d428  mov      w4, #0x10
0x0001d42c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001d430  mov      x26, x0
0x0001d434  cbnz     x0, #0x1d274
0x0001d438  mov      x0, x23
0x0001d43c  bl       #0x55d78   ; CALL _objc_release
0x0001d440  ldr      x20, [sp, #0x20]
0x0001d444  mov      x0, x20
0x0001d448  bl       #0x55d84   ; CALL _objc_retain
0x0001d44c  adrp     x8, #0x90000
0x0001d450  ldr      x0, [x8, #0x18]
0x0001d454  str      x20, [x8, #0x18]
0x0001d458  bl       #0x55d78   ; CALL _objc_release
0x0001d45c  adrp     x8, #0x8e000
0x0001d460  ldrsw    x20, [x8, #0xe68]
0x0001d464  ldr      x21, [sp, #0x18]
0x0001d468  mov      x0, x21
0x0001d46c  bl       #0x55d84   ; CALL _objc_retain
0x0001d470  ldr      x0, [x19, x20]
0x0001d474  str      x21, [x19, x20]
0x0001d478  bl       #0x55d78   ; CALL _objc_release
0x0001d47c  ldr      x22, [sp, #0x28]
0x0001d480  mov      x0, x22
0x0001d484  bl       #0x573c0   ; CALL objc_msgSend$count
0x0001d488  mov      x21, x0
0x0001d48c  cbnz     x0, #0x1d4a8
0x0001d490  adrp     x0, #0x76000
0x0001d494  add      x0, x0, #0x8a8   ; STR "splitScreenCarPlayApps"
0x0001d498  bl       #0x1dc60
0x0001d49c  mov      x29, x29
0x0001d4a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d4a4  mov      x22, x0
0x0001d4a8  adrp     x8, #0x8e000
0x0001d4ac  ldrsw    x20, [x8, #0xe6c]
0x0001d4b0  mov      x0, x22
0x0001d4b4  bl       #0x55d84   ; CALL _objc_retain
0x0001d4b8  ldr      x0, [x19, x20]
0x0001d4bc  str      x22, [x19, x20]
0x0001d4c0  bl       #0x55d78   ; CALL _objc_release
0x0001d4c4  adrp     x26, #0x8e000
0x0001d4c8  cbnz     x21, #0x1d4d4
0x0001d4cc  mov      x0, x22
0x0001d4d0  bl       #0x55d78   ; CALL _objc_release
0x0001d4d4  ldr      x0, [x19, x20]
0x0001d4d8  bl       #0x573c0   ; CALL objc_msgSend$count
0x0001d4dc  cbnz     x0, #0x1d75c
0x0001d4e0  adrp     x8, #0x8e000
0x0001d4e4  ldrsw    x9, [x8, #0xe70]
0x0001d4e8  ldr      x8, [x19, x9]
0x0001d4ec  cbnz     x8, #0x1d75c
0x0001d4f0  str      x9, [sp, #8]
0x0001d4f4  adrp     x20, #0x8e000
0x0001d4f8  ldr      x0, [x20, #0x988]   ; @CLASS NSMutableArray
0x0001d4fc  bl       #0x565c0   ; CALL objc_msgSend$array
0x0001d500  mov      x29, x29
0x0001d504  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d508  mov      x23, x0
0x0001d50c  ldr      x0, [x20, #0x988]   ; @CLASS NSMutableArray
0x0001d510  bl       #0x565c0   ; CALL objc_msgSend$array
0x0001d514  mov      x29, x29
0x0001d518  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d51c  str      x0, [sp, #0x10]
0x0001d520  ldr      x0, [x26, #0x9a0]   ; @CLASS NSMutableSet
0x0001d524  bl       #0x5a220   ; CALL objc_msgSend$set
0x0001d528  mov      x29, x29
0x0001d52c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d530  mov      x25, x0
0x0001d534  adrp     x0, #0x62000
0x0001d538  add      x0, x0, #0x227   ; CSTR "LSApplicationWorkspace"
0x0001d53c  bl       #0x55d0c   ; CALL _objc_getClass
0x0001d540  movi     v0.16b, #0
0x0001d544  stp      q0, q0, [x29, #-0xa0]
0x0001d548  stp      q0, q0, [x29, #-0x80]
0x0001d54c  adrp     x1, #0x77000
0x0001d550  add      x1, x1, #0x7e8   ; STR "defaultWorkspace"
0x0001d554  bl       #0x24d80
0x0001d558  mov      x29, x29
0x0001d55c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d560  mov      x21, x0
0x0001d564  adrp     x1, #0x79000
0x0001d568  add      x1, x1, #0xca8   ; STR "allInstalledApplications"
0x0001d56c  bl       #0x24d80
0x0001d570  mov      x29, x29
0x0001d574  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d578  mov      x26, x0
0x0001d57c  mov      x0, x21
0x0001d580  bl       #0x55d78   ; CALL _objc_release
0x0001d584  sub      x2, x29, #0xa0
0x0001d588  add      x3, sp, #0xb8
0x0001d58c  mov      x0, x26
0x0001d590  mov      w4, #0x10
0x0001d594  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001d598  cbz      x0, #0x1d67c
0x0001d59c  mov      x24, x0
0x0001d5a0  ldur     x8, [x29, #-0x90]
0x0001d5a4  ldr      x20, [x8]   ; @SEL "whatsNewNavigationController"
0x0001d5a8  adrp     x27, #0x79000
0x0001d5ac  add      x27, x27, #0xd48   ; STR "bundleIdentifier"
0x0001d5b0  mov      x28, #0
0x0001d5b4  ldur     x8, [x29, #-0x90]
0x0001d5b8  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0001d5bc  cmp      x8, x20
0x0001d5c0  b.eq     #0x1d5cc
0x0001d5c4  mov      x0, x26
0x0001d5c8  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0001d5cc  ldur     x8, [x29, #-0x98]
0x0001d5d0  ldr      x22, [x8, x28, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0001d5d4  mov      x0, x22
0x0001d5d8  mov      x1, x27
0x0001d5dc  bl       #0x24d80
0x0001d5e0  mov      x29, x29
0x0001d5e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d5e8  mov      x21, x0
0x0001d5ec  adrp     x8, #0x8e000
0x0001d5f0  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0001d5f4  bl       #0x55d48   ; CALL _objc_opt_class
0x0001d5f8  mov      x1, x0
0x0001d5fc  mov      x0, x21
0x0001d600  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0001d604  tbz      w0, #0, #0x1d64c
0x0001d608  mov      x0, x21
0x0001d60c  bl       #0x58c20   ; CALL objc_msgSend$length
0x0001d610  cbz      x0, #0x1d64c
0x0001d614  mov      x0, x25
0x0001d618  mov      x2, x21
0x0001d61c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0001d620  adrp     x0, #0x7f000
0x0001d624  add      x0, x0, #0xab0
0x0001d628  mov      x2, x21
0x0001d62c  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0001d630  tbnz     w0, #0, #0x1d64c
0x0001d634  mov      x0, x22
0x0001d638  bl       #0x24e90
0x0001d63c  cbz      w0, #0x1d64c
0x0001d640  ldr      x0, [sp, #0x10]
0x0001d644  mov      x2, x21
0x0001d648  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0001d64c  mov      x0, x21
0x0001d650  bl       #0x55d78   ; CALL _objc_release
0x0001d654  add      x28, x28, #1
0x0001d658  cmp      x24, x28
0x0001d65c  b.ne     #0x1d5b4
0x0001d660  sub      x2, x29, #0xa0
0x0001d664  add      x3, sp, #0xb8
0x0001d668  mov      x0, x26
0x0001d66c  mov      w4, #0x10
0x0001d670  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001d674  mov      x24, x0
0x0001d678  cbnz     x0, #0x1d5b0
0x0001d67c  mov      x0, x26
0x0001d680  bl       #0x55d78   ; CALL _objc_release
0x0001d684  movi     v0.16b, #0
0x0001d688  stp      q0, q0, [x29, #-0xc0]
0x0001d68c  stp      q0, q0, [x29, #-0xe0]
0x0001d690  adrp     x0, #0x7f000
0x0001d694  add      x0, x0, #0xab0
0x0001d698  sub      x2, x29, #0xe0
0x0001d69c  add      x3, sp, #0x5c0
0x0001d6a0  mov      w4, #0x10
0x0001d6a4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001d6a8  cbz      x0, #0x1d728
0x0001d6ac  mov      x26, x0
0x0001d6b0  ldur     x8, [x29, #-0xd0]
0x0001d6b4  ldr      x20, [x8]   ; @SEL "whatsNewNavigationController"
0x0001d6b8  adrp     x24, #0x7f000
0x0001d6bc  add      x24, x24, #0xab0
0x0001d6c0  mov      x22, #0
0x0001d6c4  ldur     x8, [x29, #-0xd0]
0x0001d6c8  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0001d6cc  cmp      x8, x20
0x0001d6d0  b.eq     #0x1d6dc
0x0001d6d4  mov      x0, x24
0x0001d6d8  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0001d6dc  ldur     x8, [x29, #-0xd8]
0x0001d6e0  ldr      x21, [x8, x22, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0001d6e4  mov      x0, x25
0x0001d6e8  mov      x2, x21
0x0001d6ec  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0001d6f0  cbz      w0, #0x1d700
0x0001d6f4  mov      x0, x23
0x0001d6f8  mov      x2, x21
0x0001d6fc  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0001d700  add      x22, x22, #1
0x0001d704  cmp      x26, x22
0x0001d708  b.ne     #0x1d6c4
0x0001d70c  sub      x2, x29, #0xe0
0x0001d710  add      x3, sp, #0x5c0
0x0001d714  mov      x0, x24
0x0001d718  mov      w4, #0x10
0x0001d71c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001d720  mov      x26, x0
0x0001d724  cbnz     x0, #0x1d6c0
0x0001d728  mov      x0, x23
0x0001d72c  ldr      x20, [sp, #0x10]
0x0001d730  mov      x2, x20
0x0001d734  bl       #0x56160   ; CALL objc_msgSend$addObjectsFromArray:
0x0001d738  mov      x0, x25
0x0001d73c  bl       #0x55d78   ; CALL _objc_release
0x0001d740  mov      x0, x20
0x0001d744  bl       #0x55d78   ; CALL _objc_release
0x0001d748  ldr      x8, [sp, #8]
0x0001d74c  ldr      x0, [x19, x8]
0x0001d750  str      x23, [x19, x8]
0x0001d754  bl       #0x55d78   ; CALL _objc_release
0x0001d758  adrp     x26, #0x8e000
0x0001d75c  ldr      x21, [x26, #0x9a0]   ; @CLASS NSMutableSet
0x0001d760  bl       #0x1b510
0x0001d764  mov      x29, x29
0x0001d768  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d76c  mov      x22, x0
0x0001d770  mov      x0, x21
0x0001d774  mov      x2, x22
0x0001d778  bl       #0x5c900   ; CALL objc_msgSend$setWithArray:
0x0001d77c  mov      x29, x29
0x0001d780  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d784  adrp     x8, #0x8e000
0x0001d788  ldrsw    x9, [x8, #0xe74]
0x0001d78c  ldr      x8, [x19, x9]
0x0001d790  str      x0, [x19, x9]
0x0001d794  mov      x0, x8
0x0001d798  bl       #0x55d78   ; CALL _objc_release
0x0001d79c  mov      x0, x22
0x0001d7a0  bl       #0x55d78   ; CALL _objc_release
0x0001d7a4  ldr      x0, [x26, #0x9a0]   ; @CLASS NSMutableSet
0x0001d7a8  bl       #0x5a220   ; CALL objc_msgSend$set
0x0001d7ac  mov      x29, x29
0x0001d7b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d7b4  adrp     x8, #0x8e000
0x0001d7b8  ldrsw    x20, [x8, #0xe78]
0x0001d7bc  ldr      x8, [x19, x20]
0x0001d7c0  str      x0, [x19, x20]
0x0001d7c4  mov      x0, x8
0x0001d7c8  bl       #0x55d78   ; CALL _objc_release
0x0001d7cc  movi     v0.16b, #0
0x0001d7d0  stp      q0, q0, [sp, #0x50]
0x0001d7d4  stp      q0, q0, [sp, #0x30]
0x0001d7d8  adrp     x0, #0x79000
0x0001d7dc  add      x0, x0, #0x208   ; STR "homeScreenHiddenApps"
0x0001d7e0  bl       #0x1dc60
0x0001d7e4  mov      x29, x29
0x0001d7e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d7ec  mov      x23, x0
0x0001d7f0  add      x2, sp, #0x30
0x0001d7f4  add      x3, sp, #0x4b8
0x0001d7f8  mov      w4, #0x10
0x0001d7fc  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001d800  cbz      x0, #0x1d878
0x0001d804  mov      x24, x0
0x0001d808  ldr      x8, [sp, #0x40]
0x0001d80c  ldr      x22, [x8]   ; @SEL "whatsNewNavigationController"
0x0001d810  mov      x25, #0
0x0001d814  ldr      x8, [sp, #0x40]
0x0001d818  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0001d81c  cmp      x8, x22
0x0001d820  b.eq     #0x1d82c
0x0001d824  mov      x0, x23
0x0001d828  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0001d82c  ldr      x8, [sp, #0x38]
0x0001d830  ldr      x21, [x8, x25, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0001d834  mov      x0, x19
0x0001d838  mov      x2, x21
0x0001d83c  bl       #0x58e00   ; CALL objc_msgSend$locked:
0x0001d840  tbnz     w0, #0, #0x1d850
0x0001d844  ldr      x0, [x19, x20]
0x0001d848  mov      x2, x21
0x0001d84c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0001d850  add      x25, x25, #1
0x0001d854  cmp      x24, x25
0x0001d858  b.ne     #0x1d814
0x0001d85c  add      x2, sp, #0x30
0x0001d860  add      x3, sp, #0x4b8
0x0001d864  mov      x0, x23
0x0001d868  mov      w4, #0x10
0x0001d86c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001d870  mov      x24, x0
0x0001d874  cbnz     x0, #0x1d810
0x0001d878  mov      x0, x23
0x0001d87c  bl       #0x55d78   ; CALL _objc_release
0x0001d880  ldr      x21, [x26, #0x9a0]   ; @CLASS NSMutableSet
0x0001d884  adrp     x0, #0x79000
0x0001d888  add      x0, x0, #0x228   ; STR "homeScreenShownApps"
0x0001d88c  bl       #0x1dc60
0x0001d890  mov      x29, x29
0x0001d894  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d898  mov      x22, x0
0x0001d89c  mov      x0, x21
0x0001d8a0  mov      x2, x22
0x0001d8a4  bl       #0x5c900   ; CALL objc_msgSend$setWithArray:
0x0001d8a8  mov      x29, x29
0x0001d8ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d8b0  adrp     x8, #0x8e000
0x0001d8b4  ldrsw    x9, [x8, #0xe7c]
0x0001d8b8  ldr      x8, [x19, x9]
0x0001d8bc  str      x0, [x19, x9]
0x0001d8c0  mov      x0, x8
0x0001d8c4  bl       #0x55d78   ; CALL _objc_release
0x0001d8c8  mov      x0, x22
0x0001d8cc  bl       #0x55d78   ; CALL _objc_release
0x0001d8d0  adrp     x20, #0x8e000
0x0001d8d4  ldr      x21, [x20, #0xa78]   ; @CLASS UIImage
0x0001d8d8  adrp     x0, #0x79000
0x0001d8dc  add      x0, x0, #0x248   ; STR "/var/mobile/Library/OmniCar"
0x0001d8e0  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0001d8e4  add      x1, sp, #0xb8
0x0001d8e8  bl       #0x4118
0x0001d8ec  cbz      x0, #0x1d910
0x0001d8f0  mov      x2, x0
0x0001d8f4  adrp     x8, #0x8e000
0x0001d8f8  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0001d8fc  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0001d900  mov      x29, x29
0x0001d904  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d908  mov      x22, x0
0x0001d90c  b        #0x1d914
0x0001d910  mov      x22, #0
0x0001d914  adrp     x2, #0x79000
0x0001d918  add      x2, x2, #0x268   ; STR "HomeScreen/photo.jpg"
0x0001d91c  mov      x0, x22
0x0001d920  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x0001d924  mov      x29, x29
0x0001d928  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d92c  mov      x23, x0
0x0001d930  mov      x0, x21
0x0001d934  mov      x2, x23
0x0001d938  bl       #0x581c0   ; CALL objc_msgSend$imageWithContentsOfFile:
0x0001d93c  mov      x29, x29
0x0001d940  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d944  adrp     x8, #0x8e000
0x0001d948  ldrsw    x9, [x8, #0xe80]
0x0001d94c  ldr      x8, [x19, x9]
0x0001d950  str      x0, [x19, x9]
0x0001d954  mov      x0, x8
0x0001d958  bl       #0x55d78   ; CALL _objc_release
0x0001d95c  mov      x0, x23
0x0001d960  bl       #0x55d78   ; CALL _objc_release
0x0001d964  mov      x0, x22
0x0001d968  bl       #0x55d78   ; CALL _objc_release
0x0001d96c  adrp     x8, #0x8e000
0x0001d970  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x0001d974  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x0001d978  mov      x29, x29
0x0001d97c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d980  mov      x23, x0
0x0001d984  adrp     x0, #0x79000
0x0001d988  add      x0, x0, #0x248   ; STR "/var/mobile/Library/OmniCar"
0x0001d98c  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0001d990  add      x1, sp, #0xb8
0x0001d994  bl       #0x4118
0x0001d998  cbz      x0, #0x1d9bc
0x0001d99c  mov      x2, x0
0x0001d9a0  adrp     x8, #0x8e000
0x0001d9a4  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0001d9a8  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0001d9ac  mov      x29, x29
0x0001d9b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d9b4  mov      x24, x0
0x0001d9b8  b        #0x1d9c0
0x0001d9bc  mov      x24, #0
0x0001d9c0  adrp     x2, #0x79000
0x0001d9c4  add      x2, x2, #0x288   ; STR "HomeScreen/video.mp4"
0x0001d9c8  mov      x0, x24
0x0001d9cc  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x0001d9d0  mov      x29, x29
0x0001d9d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001d9d8  mov      x25, x0
0x0001d9dc  mov      x0, x23
0x0001d9e0  mov      x2, x25
0x0001d9e4  bl       #0x57b40   ; CALL objc_msgSend$fileExistsAtPath:
0x0001d9e8  mov      x26, x0
0x0001d9ec  cbz      w0, #0x1da2c
0x0001d9f0  ldr      x21, [x20, #0xa78]   ; @CLASS UIImage
0x0001d9f4  adrp     x0, #0x79000
0x0001d9f8  add      x0, x0, #0x248   ; STR "/var/mobile/Library/OmniCar"
0x0001d9fc  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0001da00  add      x1, sp, #0xb8
0x0001da04  bl       #0x4118
0x0001da08  cbz      x0, #0x1da34
0x0001da0c  mov      x2, x0
0x0001da10  adrp     x8, #0x8e000
0x0001da14  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0001da18  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0001da1c  mov      x29, x29
0x0001da20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001da24  mov      x27, x0
0x0001da28  b        #0x1da38
0x0001da2c  mov      x21, #0
0x0001da30  b        #0x1da6c
0x0001da34  mov      x27, #0
0x0001da38  adrp     x2, #0x79000
0x0001da3c  add      x2, x2, #0x2a8   ; STR "HomeScreen/video.jpg"
0x0001da40  mov      x0, x27
0x0001da44  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x0001da48  mov      x29, x29
0x0001da4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001da50  mov      x22, x0
0x0001da54  mov      x0, x21
0x0001da58  mov      x2, x22
0x0001da5c  bl       #0x581c0   ; CALL objc_msgSend$imageWithContentsOfFile:
0x0001da60  mov      x29, x29
0x0001da64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001da68  mov      x21, x0
0x0001da6c  adrp     x8, #0x8e000
0x0001da70  ldrsw    x28, [x8, #0xe84]
0x0001da74  mov      x0, x21
0x0001da78  bl       #0x55d84   ; CALL _objc_retain
0x0001da7c  ldr      x0, [x19, x28]
0x0001da80  str      x21, [x19, x28]
0x0001da84  bl       #0x55d78   ; CALL _objc_release
0x0001da88  cbz      w26, #0x1daa4
0x0001da8c  mov      x0, x21
0x0001da90  bl       #0x55d78   ; CALL _objc_release
0x0001da94  mov      x0, x22
0x0001da98  bl       #0x55d78   ; CALL _objc_release
0x0001da9c  mov      x0, x27
0x0001daa0  bl       #0x55d78   ; CALL _objc_release
0x0001daa4  mov      x0, x25
0x0001daa8  bl       #0x55d78   ; CALL _objc_release
0x0001daac  mov      x0, x24
0x0001dab0  bl       #0x55d78   ; CALL _objc_release
0x0001dab4  mov      x0, x23
0x0001dab8  bl       #0x55d78   ; CALL _objc_release
0x0001dabc  adrp     x0, #0x79000
0x0001dac0  add      x0, x0, #0x2c8   ; STR "homeScreenWallpaper"
0x0001dac4  adrp     x1, #0x74000
0x0001dac8  ldr      x1, [x1, #0x1b0]   ; @GOT ___kCFBooleanFalse
0x0001dacc  bl       #0x1dcc4
0x0001dad0  mov      x29, x29
0x0001dad4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001dad8  mov      x21, x0
0x0001dadc  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x0001dae0  mov      x22, x0
0x0001dae4  mov      x0, x21
0x0001dae8  bl       #0x55d78   ; CALL _objc_release
0x0001daec  tbz      w22, #0, #0x1db2c
0x0001daf0  mov      x21, x20
0x0001daf4  adrp     x2, #0x79000
0x0001daf8  add      x2, x2, #0x2e8   ; STR "homeScreenWallpaperStyle"
0x0001dafc  mov      x0, x19
0x0001db00  mov      w3, #7
0x0001db04  bl       #0x59220   ; CALL objc_msgSend$num:def:
0x0001db08  adrp     x8, #0x8e000
0x0001db0c  ldrsw    x8, [x8, #0xe88]
0x0001db10  add      x20, x19, x8
0x0001db14  str      x0, [x20]
0x0001db18  cmp      x0, #8
0x0001db1c  b.ne     #0x1db48
0x0001db20  mov      w22, #0
0x0001db24  ldr      x24, [x19, x28]
0x0001db28  b        #0x1db44
0x0001db2c  mov      w22, #0
0x0001db30  mov      x24, #0
0x0001db34  adrp     x8, #0x8e000
0x0001db38  ldrsw    x8, [x8, #0xe88]
0x0001db3c  add      x20, x19, x8
0x0001db40  str      xzr, [x20]
0x0001db44  b        #0x1dbc0
0x0001db48  ldr      x22, [x21, #0xa78]
0x0001db4c  adrp     x0, #0x79000
0x0001db50  add      x0, x0, #0x248   ; STR "/var/mobile/Library/OmniCar"
0x0001db54  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0001db58  add      x1, sp, #0xb8
0x0001db5c  bl       #0x4118
0x0001db60  cbz      x0, #0x1db84
0x0001db64  mov      x2, x0
0x0001db68  adrp     x8, #0x8e000
0x0001db6c  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0001db70  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0001db74  mov      x29, x29
0x0001db78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001db7c  mov      x23, x0
0x0001db80  b        #0x1db88
0x0001db84  mov      x23, #0
0x0001db88  adrp     x2, #0x79000
0x0001db8c  add      x2, x2, #0x308   ; STR "HomeScreen/wallpaper.jpg"
0x0001db90  mov      x0, x23
0x0001db94  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x0001db98  mov      x29, x29
0x0001db9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001dba0  mov      x21, x0
0x0001dba4  mov      x0, x22
0x0001dba8  mov      x2, x21
0x0001dbac  bl       #0x581c0   ; CALL objc_msgSend$imageWithContentsOfFile:
0x0001dbb0  mov      x29, x29
0x0001dbb4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001dbb8  mov      x24, x0
0x0001dbbc  mov      w22, #1
0x0001dbc0  adrp     x8, #0x8e000
0x0001dbc4  ldrsw    x25, [x8, #0xe8c]
0x0001dbc8  mov      x0, x24
0x0001dbcc  bl       #0x55d84   ; CALL _objc_retain
0x0001dbd0  ldr      x0, [x19, x25]
0x0001dbd4  str      x24, [x19, x25]
0x0001dbd8  bl       #0x55d78   ; CALL _objc_release
0x0001dbdc  cbz      w22, #0x1dbf8
0x0001dbe0  mov      x0, x24
0x0001dbe4  bl       #0x55d78   ; CALL _objc_release
0x0001dbe8  mov      x0, x21
0x0001dbec  bl       #0x55d78   ; CALL _objc_release
0x0001dbf0  mov      x0, x23
0x0001dbf4  bl       #0x55d78   ; CALL _objc_release
0x0001dbf8  ldr      x8, [x19, x25]
0x0001dbfc  cbnz     x8, #0x1dc04
0x0001dc00  str      xzr, [x20]
0x0001dc04  mov      x0, x19
0x0001dc08  bl       #0x59bc0   ; CALL objc_msgSend$rebuildRows
0x0001dc0c  ldr      x0, [sp, #0x18]
0x0001dc10  bl       #0x55d78   ; CALL _objc_release
0x0001dc14  ldr      x0, [sp, #0x20]
0x0001dc18  bl       #0x55d78   ; CALL _objc_release
0x0001dc1c  ldr      x0, [sp, #0x28]
0x0001dc20  bl       #0x55d78   ; CALL _objc_release
0x0001dc24  ldur     x8, [x29, #-0x60]
0x0001dc28  adrp     x9, #0x74000
0x0001dc2c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0001dc30  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0001dc34  cmp      x9, x8
0x0001dc38  b.ne     #0x1dc5c
0x0001dc3c  add      sp, sp, #0x6d0
0x0001dc40  ldp      x29, x30, [sp, #0x50]
0x0001dc44  ldp      x20, x19, [sp, #0x40]
0x0001dc48  ldp      x22, x21, [sp, #0x30]
0x0001dc4c  ldp      x24, x23, [sp, #0x20]
0x0001dc50  ldp      x26, x25, [sp, #0x10]
0x0001dc54  ldp      x28, x27, [sp], #0x60
0x0001dc58  ret      
0x0001dc5c  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0001dc60  stp      x20, x19, [sp, #-0x20]!
0x0001dc64  stp      x29, x30, [sp, #0x10]
0x0001dc68  add      x29, sp, #0x10
0x0001dc6c  bl       #0x1cd84
0x0001dc70  mov      x29, x29
0x0001dc74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001dc78  mov      x19, x0
0x0001dc7c  adrp     x8, #0x8e000
0x0001dc80  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0001dc84  bl       #0x55d48   ; CALL _objc_opt_class
0x0001dc88  mov      x1, x0
0x0001dc8c  mov      x0, x19
0x0001dc90  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0001dc94  adrp     x8, #0x74000
0x0001dc98  ldr      x8, [x8, #0x1a0]   ; @GOT ___NSArray0__struct
0x0001dc9c  tst      w0, #1
0x0001dca0  csel     x20, x19, x8, ne
0x0001dca4  mov      x0, x20
0x0001dca8  bl       #0x55d84   ; CALL _objc_retain
0x0001dcac  mov      x0, x19
0x0001dcb0  bl       #0x55d78   ; CALL _objc_release
0x0001dcb4  mov      x0, x20
0x0001dcb8  ldp      x29, x30, [sp, #0x10]
0x0001dcbc  ldp      x20, x19, [sp], #0x20
0x0001dcc0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0001dcc4  stp      x22, x21, [sp, #-0x30]!
0x0001dcc8  stp      x20, x19, [sp, #0x10]
0x0001dccc  stp      x29, x30, [sp, #0x20]
0x0001dcd0  add      x29, sp, #0x20
0x0001dcd4  mov      x19, x1
0x0001dcd8  mov      x20, x0
0x0001dcdc  mov      x0, x1
0x0001dce0  bl       #0x55d84   ; CALL _objc_retain
0x0001dce4  adrp     x1, #0x75000
0x0001dce8  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x0001dcec  mov      x0, x20
0x0001dcf0  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x0001dcf4  mov      x20, x0
0x0001dcf8  cmp      x0, #0
0x0001dcfc  csel     x21, x19, x0, eq
0x0001dd00  mov      x0, x21
0x0001dd04  bl       #0x55d84   ; CALL _objc_retain
0x0001dd08  mov      x0, x19
0x0001dd0c  bl       #0x55d78   ; CALL _objc_release
0x0001dd10  mov      x0, x20
0x0001dd14  bl       #0x55d78   ; CALL _objc_release
0x0001dd18  mov      x0, x21
0x0001dd1c  ldp      x29, x30, [sp, #0x20]
0x0001dd20  ldp      x20, x19, [sp, #0x10]
0x0001dd24  ldp      x22, x21, [sp], #0x30
0x0001dd28  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCAppBridgeAppsController carplayGuessed]  va=0x1dd2c size=40 types=B16@0:8
0x0001dd2c  stp      x29, x30, [sp, #-0x10]!
0x0001dd30  mov      x29, sp
0x0001dd34  adrp     x8, #0x8e000
0x0001dd38  ldrsw    x8, [x8, #0xe6c]
0x0001dd3c  ldr      x0, [x0, x8]
0x0001dd40  bl       #0x573c0   ; CALL objc_msgSend$count
0x0001dd44  cmp      x0, #0
0x0001dd48  cset     w0, eq
0x0001dd4c  ldp      x29, x30, [sp], #0x10
0x0001dd50  ret      

=== -[OMCAppBridgeAppsController carplayIDs]  va=0x1dd54 size=476 types=@16@0:8
0x0001dd54  sub      sp, sp, #0x130
0x0001dd58  stp      x28, x27, [sp, #0xd0]
0x0001dd5c  stp      x26, x25, [sp, #0xe0]
0x0001dd60  stp      x24, x23, [sp, #0xf0]
0x0001dd64  stp      x22, x21, [sp, #0x100]
0x0001dd68  stp      x20, x19, [sp, #0x110]
0x0001dd6c  stp      x29, x30, [sp, #0x120]
0x0001dd70  add      x29, sp, #0x120
0x0001dd74  mov      x20, x0
0x0001dd78  adrp     x8, #0x74000
0x0001dd7c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0001dd80  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001dd84  stur     x8, [x29, #-0x60]
0x0001dd88  adrp     x8, #0x8e000
0x0001dd8c  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x0001dd90  bl       #0x565c0   ; CALL objc_msgSend$array
0x0001dd94  mov      x29, x29
0x0001dd98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001dd9c  mov      x19, x0
0x0001dda0  adrp     x8, #0x8e000
0x0001dda4  ldrsw    x8, [x8, #0xe78]
0x0001dda8  ldr      x0, [x20, x8]
0x0001ddac  bl       #0x562c0   ; CALL objc_msgSend$allObjects
0x0001ddb0  mov      x29, x29
0x0001ddb4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ddb8  mov      x22, x0
0x0001ddbc  adrp     x2, #0x74000
0x0001ddc0  add      x2, x2, #0x990
0x0001ddc4  bl       #0x5cce0   ; CALL objc_msgSend$sortedArrayUsingComparator:
0x0001ddc8  mov      x29, x29
0x0001ddcc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ddd0  mov      x21, x0
0x0001ddd4  mov      x0, x22
0x0001ddd8  bl       #0x55d78   ; CALL _objc_release
0x0001dddc  movi     v0.16b, #0
0x0001dde0  stp      q0, q0, [sp, #0x20]
0x0001dde4  stp      q0, q0, [sp]
0x0001dde8  mov      x0, x20
0x0001ddec  bl       #0x56c20   ; CALL objc_msgSend$carplayGuessed
0x0001ddf0  adrp     x8, #0x8e000
0x0001ddf4  add      x8, x8, #0xe6c
0x0001ddf8  adrp     x9, #0x8e000
0x0001ddfc  add      x9, x9, #0xe70
0x0001de00  cmp      w0, #0
0x0001de04  csel     x8, x9, x8, ne
0x0001de08  ldrsw    x8, [x8]
0x0001de0c  ldr      x0, [x20, x8]
0x0001de10  mov      x2, x21
0x0001de14  bl       #0x56600   ; CALL objc_msgSend$arrayByAddingObjectsFromArray:
0x0001de18  mov      x29, x29
0x0001de1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001de20  mov      x22, x0
0x0001de24  mov      x2, sp
0x0001de28  add      x3, sp, #0x40
0x0001de2c  mov      w4, #0x10
0x0001de30  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001de34  cbz      x0, #0x1dee0
0x0001de38  mov      x23, x0
0x0001de3c  ldr      x8, [sp, #0x10]
0x0001de40  ldr      x25, [x8]
0x0001de44  adrp     x26, #0x8e000
0x0001de48  adrp     x27, #0x8e000
0x0001de4c  mov      x28, #0
0x0001de50  ldr      x8, [sp, #0x10]
0x0001de54  ldr      x8, [x8]
0x0001de58  cmp      x8, x25
0x0001de5c  b.eq     #0x1de68
0x0001de60  mov      x0, x22
0x0001de64  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0001de68  ldr      x8, [sp, #8]
0x0001de6c  ldr      x24, [x8, x28, lsl #3]
0x0001de70  ldr      x0, [x26, #0x958]   ; @CLASS NSString
0x0001de74  bl       #0x55d48   ; CALL _objc_opt_class
0x0001de78  mov      x1, x0
0x0001de7c  mov      x0, x24
0x0001de80  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0001de84  tbz      w0, #0, #0x1deb8
0x0001de88  ldrsw    x8, [x27, #0xe74]
0x0001de8c  ldr      x0, [x20, x8]
0x0001de90  mov      x2, x24
0x0001de94  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0001de98  tbnz     w0, #0, #0x1deb8
0x0001de9c  mov      x0, x19
0x0001dea0  mov      x2, x24
0x0001dea4  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0001dea8  tbnz     w0, #0, #0x1deb8
0x0001deac  mov      x0, x19
0x0001deb0  mov      x2, x24
0x0001deb4  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0001deb8  add      x28, x28, #1
0x0001debc  cmp      x23, x28
0x0001dec0  b.ne     #0x1de50
0x0001dec4  mov      x2, sp
0x0001dec8  add      x3, sp, #0x40
0x0001decc  mov      x0, x22
0x0001ded0  mov      w4, #0x10
0x0001ded4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001ded8  mov      x23, x0
0x0001dedc  cbnz     x0, #0x1de4c
0x0001dee0  mov      x0, x22
0x0001dee4  bl       #0x55d78   ; CALL _objc_release
0x0001dee8  mov      x0, x21
0x0001deec  bl       #0x55d78   ; CALL _objc_release
0x0001def0  ldur     x8, [x29, #-0x60]
0x0001def4  adrp     x9, #0x74000
0x0001def8  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0001defc  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0001df00  cmp      x9, x8
0x0001df04  b.ne     #0x1df2c
0x0001df08  mov      x0, x19
0x0001df0c  ldp      x29, x30, [sp, #0x120]
0x0001df10  ldp      x20, x19, [sp, #0x110]
0x0001df14  ldp      x22, x21, [sp, #0x100]
0x0001df18  ldp      x24, x23, [sp, #0xf0]
0x0001df1c  ldp      x26, x25, [sp, #0xe0]
0x0001df20  ldp      x28, x27, [sp, #0xd0]
0x0001df24  add      sp, sp, #0x130
0x0001df28  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0001df2c  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCAppBridgeAppsController locked:]  va=0x1dfb4 size=692 types=B24@0:8@16
0x0001dfb4  stp      x22, x21, [sp, #-0x30]!
0x0001dfb8  stp      x20, x19, [sp, #0x10]
0x0001dfbc  stp      x29, x30, [sp, #0x20]
0x0001dfc0  add      x29, sp, #0x20
0x0001dfc4  mov      x19, x2
0x0001dfc8  mov      x20, x0
0x0001dfcc  mov      x0, x2
0x0001dfd0  bl       #0x55d84   ; CALL _objc_retain
0x0001dfd4  mov      x0, x19
0x0001dfd8  bl       #0x55d84   ; CALL _objc_retain
0x0001dfdc  adrp     x8, #0x8e000
0x0001dfe0  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0001dfe4  bl       #0x55d48   ; CALL _objc_opt_class
0x0001dfe8  mov      x1, x0
0x0001dfec  mov      x0, x19
0x0001dff0  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0001dff4  tbz      w0, #0, #0x1e03c
0x0001dff8  mov      x0, x19
0x0001dffc  bl       #0x58c20   ; CALL objc_msgSend$length
0x0001e000  cbz      x0, #0x1e03c
0x0001e004  adrp     x0, #0x7f000
0x0001e008  add      x0, x0, #0xac8
0x0001e00c  mov      x2, x19
0x0001e010  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0001e014  tbnz     w0, #0, #0x1e02c
0x0001e018  adrp     x2, #0x79000
0x0001e01c  add      x2, x2, #0xba8   ; STR "com.apple.CarPlay"
0x0001e020  mov      x0, x19
0x0001e024  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x0001e028  cbz      w0, #0x1e098
0x0001e02c  mov      x0, x19
0x0001e030  bl       #0x55d78   ; CALL _objc_release
0x0001e034  mov      w20, #1
0x0001e038  b        #0x1e07c
0x0001e03c  mov      x0, x19
0x0001e040  bl       #0x55d78   ; CALL _objc_release
0x0001e044  mov      x0, x20
0x0001e048  bl       #0x56c20   ; CALL objc_msgSend$carplayGuessed
0x0001e04c  tbnz     w0, #0, #0x1e068
0x0001e050  adrp     x8, #0x8e000
0x0001e054  ldrsw    x8, [x8, #0xe68]
0x0001e058  ldr      x0, [x20, x8]
0x0001e05c  mov      x2, x19
0x0001e060  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0001e064  tbz      w0, #0, #0x1e070
0x0001e068  mov      w20, #0
0x0001e06c  b        #0x1e07c
0x0001e070  mov      x0, x19
0x0001e074  bl       #0x1e0c4
0x0001e078  eor      w20, w0, #1
0x0001e07c  mov      x0, x19
0x0001e080  bl       #0x55d78   ; CALL _objc_release
0x0001e084  mov      x0, x20
0x0001e088  ldp      x29, x30, [sp, #0x20]
0x0001e08c  ldp      x20, x19, [sp, #0x10]
0x0001e090  ldp      x22, x21, [sp], #0x30
0x0001e094  ret      
0x0001e098  adrp     x2, #0x79000
0x0001e09c  add      x2, x2, #0xb28   ; STR "NowPlaying"
0x0001e0a0  mov      x0, x19
0x0001e0a4  bl       #0x59b40   ; CALL objc_msgSend$rangeOfString:
0x0001e0a8  mov      x21, x0
0x0001e0ac  mov      x0, x19
0x0001e0b0  bl       #0x55d78   ; CALL _objc_release
0x0001e0b4  mov      x8, #0x7fffffffffffffff
0x0001e0b8  cmp      x21, x8
0x0001e0bc  b.ne     #0x1e034
0x0001e0c0  b        #0x1e044
0x0001e0c4  stp      x24, x23, [sp, #-0x40]!
0x0001e0c8  stp      x22, x21, [sp, #0x10]
0x0001e0cc  stp      x20, x19, [sp, #0x20]
0x0001e0d0  stp      x29, x30, [sp, #0x30]
0x0001e0d4  add      x29, sp, #0x30
0x0001e0d8  mov      x19, x0
0x0001e0dc  bl       #0x55d84   ; CALL _objc_retain
0x0001e0e0  adrp     x24, #0x90000
0x0001e0e4  ldr      x8, [x24, #0x30]
0x0001e0e8  cbnz     x8, #0x1e110
0x0001e0ec  adrp     x8, #0x8e000
0x0001e0f0  ldr      x0, [x8, #0x9d0]   ; @CLASS NSMutableDictionary
0x0001e0f4  bl       #0x57780   ; CALL objc_msgSend$dictionary
0x0001e0f8  mov      x29, x29
0x0001e0fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e100  ldr      x8, [x24, #0x30]
0x0001e104  str      x0, [x24, #0x30]
0x0001e108  mov      x0, x8
0x0001e10c  bl       #0x55d78   ; CALL _objc_release
0x0001e110  mov      x0, x19
0x0001e114  bl       #0x58c20   ; CALL objc_msgSend$length
0x0001e118  cbz      x0, #0x1e160
0x0001e11c  ldr      x0, [x24, #0x30]
0x0001e120  mov      x2, x19
0x0001e124  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001e128  mov      x29, x29
0x0001e12c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e130  mov      x20, x0
0x0001e134  bl       #0x55d78   ; CALL _objc_release
0x0001e138  cbz      x20, #0x1e168
0x0001e13c  ldr      x0, [x24, #0x30]
0x0001e140  mov      x2, x19
0x0001e144  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001e148  mov      x29, x29
0x0001e14c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e150  mov      x20, x0
0x0001e154  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x0001e158  mov      x21, x0
0x0001e15c  b        #0x1e240
0x0001e160  mov      w21, #0
0x0001e164  b        #0x1e248
0x0001e168  adrp     x0, #0x63000
0x0001e16c  add      x0, x0, #0xf6   ; CSTR "LSApplicationProxy"
0x0001e170  bl       #0x55d0c   ; CALL _objc_getClass
0x0001e174  mov      x20, x0
0x0001e178  adrp     x0, #0x79000
0x0001e17c  add      x0, x0, #0xc68   ; STR "applicationProxyForIdentifier:"
0x0001e180  bl       #0x55b08   ; CALL _NSSelectorFromString
0x0001e184  mov      x21, x0
0x0001e188  mov      x0, x20
0x0001e18c  mov      x1, x21
0x0001e190  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x0001e194  tbz      w0, #0, #0x1e1b8
0x0001e198  mov      x0, x20
0x0001e19c  mov      x1, x21
0x0001e1a0  mov      x2, x19
0x0001e1a4  bl       #0x55d30   ; CALL _objc_msgSend
0x0001e1a8  mov      x29, x29
0x0001e1ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e1b0  mov      x20, x0
0x0001e1b4  b        #0x1e1bc
0x0001e1b8  mov      x20, #0
0x0001e1bc  adrp     x1, #0x7a000
0x0001e1c0  add      x1, x1, #0xc8   ; STR "appState"
0x0001e1c4  mov      x0, x20
0x0001e1c8  bl       #0x24d80
0x0001e1cc  mov      x29, x29
0x0001e1d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e1d4  mov      x22, x0
0x0001e1d8  cbz      x20, #0x1e1f8
0x0001e1dc  cbz      x22, #0x1e200
0x0001e1e0  adrp     x1, #0x7a000
0x0001e1e4  add      x1, x1, #0xe8   ; STR "isInstalled"
0x0001e1e8  mov      x0, x22
0x0001e1ec  bl       #0x24e0c
0x0001e1f0  mov      x21, x0
0x0001e1f4  b        #0x1e204
0x0001e1f8  mov      w21, #0
0x0001e1fc  b        #0x1e204
0x0001e200  mov      w21, #1
0x0001e204  adrp     x8, #0x8e000
0x0001e208  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x0001e20c  mov      x2, x21
0x0001e210  bl       #0x592c0   ; CALL objc_msgSend$numberWithBool:
0x0001e214  mov      x29, x29
0x0001e218  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e21c  mov      x23, x0
0x0001e220  ldr      x0, [x24, #0x30]
0x0001e224  mov      x2, x23
0x0001e228  mov      x3, x19
0x0001e22c  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x0001e230  mov      x0, x23
0x0001e234  bl       #0x55d78   ; CALL _objc_release
0x0001e238  mov      x0, x22
0x0001e23c  bl       #0x55d78   ; CALL _objc_release
0x0001e240  mov      x0, x20
0x0001e244  bl       #0x55d78   ; CALL _objc_release
0x0001e248  mov      x0, x19
0x0001e24c  bl       #0x55d78   ; CALL _objc_release
0x0001e250  mov      x0, x21
0x0001e254  ldp      x29, x30, [sp, #0x30]
0x0001e258  ldp      x20, x19, [sp, #0x20]
0x0001e25c  ldp      x22, x21, [sp, #0x10]
0x0001e260  ldp      x24, x23, [sp], #0x40
0x0001e264  ret      

=== -[OMCAppBridgeAppsController hides:]  va=0x1e268 size=156 types=B24@0:8@16
0x0001e268  stp      x20, x19, [sp, #-0x20]!
0x0001e26c  stp      x29, x30, [sp, #0x10]
0x0001e270  add      x29, sp, #0x10
0x0001e274  mov      x19, x2
0x0001e278  mov      x20, x0
0x0001e27c  mov      x0, x2
0x0001e280  bl       #0x55d84   ; CALL _objc_retain
0x0001e284  mov      x0, x20
0x0001e288  mov      x2, x19
0x0001e28c  bl       #0x58e00   ; CALL objc_msgSend$locked:
0x0001e290  tbz      w0, #0, #0x1e29c
0x0001e294  mov      w20, #0
0x0001e298  b        #0x1e2ec
0x0001e29c  adrp     x8, #0x8e000
0x0001e2a0  ldrsw    x8, [x8, #0xe78]
0x0001e2a4  ldr      x0, [x20, x8]
0x0001e2a8  mov      x2, x19
0x0001e2ac  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0001e2b0  tbz      w0, #0, #0x1e2bc
0x0001e2b4  mov      w20, #1
0x0001e2b8  b        #0x1e2ec
0x0001e2bc  adrp     x8, #0x8e000
0x0001e2c0  ldrsw    x8, [x8, #0xe68]
0x0001e2c4  ldr      x0, [x20, x8]
0x0001e2c8  mov      x2, x19
0x0001e2cc  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0001e2d0  cbz      w0, #0x1e294
0x0001e2d4  adrp     x8, #0x8e000
0x0001e2d8  ldrsw    x8, [x8, #0xe7c]
0x0001e2dc  ldr      x0, [x20, x8]
0x0001e2e0  mov      x2, x19
0x0001e2e4  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0001e2e8  eor      w20, w0, #1
0x0001e2ec  mov      x0, x19
0x0001e2f0  bl       #0x55d78   ; CALL _objc_release
0x0001e2f4  mov      x0, x20
0x0001e2f8  ldp      x29, x30, [sp, #0x10]
0x0001e2fc  ldp      x20, x19, [sp], #0x20
0x0001e300  ret      

=== -[OMCAppBridgeAppsController removable:]  va=0x1e304 size=164 types=B24@0:8@16
0x0001e304  stp      x22, x21, [sp, #-0x30]!
0x0001e308  stp      x20, x19, [sp, #0x10]
0x0001e30c  stp      x29, x30, [sp, #0x20]
0x0001e310  add      x29, sp, #0x20
0x0001e314  mov      x19, x2
0x0001e318  mov      x21, x0
0x0001e31c  mov      x0, x2
0x0001e320  bl       #0x55d84   ; CALL _objc_retain
0x0001e324  adrp     x2, #0x79000
0x0001e328  add      x2, x2, #0x328   ; STR "carplay"
0x0001e32c  mov      x0, x19
0x0001e330  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001e334  mov      x29, x29
0x0001e338  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e33c  mov      x20, x0
0x0001e340  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x0001e344  cbz      w0, #0x1e380
0x0001e348  adrp     x2, #0x75000
0x0001e34c  add      x2, x2, #0x3e8   ; STR "id"
0x0001e350  mov      x0, x19
0x0001e354  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001e358  mov      x29, x29
0x0001e35c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e360  mov      x22, x0
0x0001e364  mov      x0, x21
0x0001e368  mov      x2, x22
0x0001e36c  bl       #0x58e00   ; CALL objc_msgSend$locked:
0x0001e370  eor      w21, w0, #1
0x0001e374  mov      x0, x22
0x0001e378  bl       #0x55d78   ; CALL _objc_release
0x0001e37c  b        #0x1e384
0x0001e380  mov      w21, #1
0x0001e384  mov      x0, x20
0x0001e388  bl       #0x55d78   ; CALL _objc_release
0x0001e38c  mov      x0, x19
0x0001e390  bl       #0x55d78   ; CALL _objc_release
0x0001e394  mov      x0, x21
0x0001e398  ldp      x29, x30, [sp, #0x20]
0x0001e39c  ldp      x20, x19, [sp, #0x10]
0x0001e3a0  ldp      x22, x21, [sp], #0x30
0x0001e3a4  ret      

=== -[OMCAppBridgeAppsController rebuildRows]  va=0x1e3a8 size=1100 types=v16@0:8
0x0001e3a8  stp      x28, x27, [sp, #-0x60]!
0x0001e3ac  stp      x26, x25, [sp, #0x10]
0x0001e3b0  stp      x24, x23, [sp, #0x20]
0x0001e3b4  stp      x22, x21, [sp, #0x30]
0x0001e3b8  stp      x20, x19, [sp, #0x40]
0x0001e3bc  stp      x29, x30, [sp, #0x50]
0x0001e3c0  add      x29, sp, #0x50
0x0001e3c4  sub      sp, sp, #0x210
0x0001e3c8  mov      x20, x0
0x0001e3cc  adrp     x8, #0x74000
0x0001e3d0  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0001e3d4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001e3d8  stur     x8, [x29, #-0x60]
0x0001e3dc  adrp     x8, #0x8e000
0x0001e3e0  ldrsw    x19, [x8, #0xe90]
0x0001e3e4  ldr      x0, [x0, x19]
0x0001e3e8  bl       #0x58c20   ; CALL objc_msgSend$length
0x0001e3ec  cbz      x0, #0x1e3f8
0x0001e3f0  ldr      x22, [x20, x19]
0x0001e3f4  b        #0x1e3fc
0x0001e3f8  mov      x22, #0
0x0001e3fc  mov      x0, x22
0x0001e400  bl       #0x55d84   ; CALL _objc_retain
0x0001e404  adrp     x19, #0x8e000
0x0001e408  ldr      x0, [x19, #0x988]   ; @CLASS NSMutableArray
0x0001e40c  bl       #0x565c0   ; CALL objc_msgSend$array
0x0001e410  mov      x29, x29
0x0001e414  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e418  mov      x21, x0
0x0001e41c  ldr      x0, [x19, #0x988]   ; @CLASS NSMutableArray
0x0001e420  bl       #0x565c0   ; CALL objc_msgSend$array
0x0001e424  mov      x29, x29
0x0001e428  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e42c  str      x0, [sp, #0x18]
0x0001e430  adrp     x8, #0x74000
0x0001e434  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x0001e438  str      x8, [sp, #0xa8]
0x0001e43c  adrp     x8, #0x65000
0x0001e440  ldr      d0, [x8, #0x600]
0x0001e444  str      d0, [sp, #0xb0]
0x0001e448  adrp     x8, #0x1e000
0x0001e44c  add      x8, x8, #0x7bc
0x0001e450  adrp     x9, #0x74000
0x0001e454  add      x9, x9, #0x9b0
0x0001e458  stp      x8, x9, [sp, #0xb8]
0x0001e45c  mov      x0, x22
0x0001e460  bl       #0x55d84   ; CALL _objc_retain
0x0001e464  str      x22, [sp, #8]
0x0001e468  str      x22, [sp, #0xc8]
0x0001e46c  add      x0, sp, #0xa8
0x0001e470  bl       #0x55da8   ; CALL _objc_retainBlock
0x0001e474  mov      x23, x0
0x0001e478  movi     v0.16b, #0
0x0001e47c  stp      q0, q0, [sp, #0x60]
0x0001e480  stp      q0, q0, [sp, #0x80]
0x0001e484  mov      x0, x20
0x0001e488  bl       #0x56c40   ; CALL objc_msgSend$carplayIDs
0x0001e48c  mov      x29, x29
0x0001e490  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e494  add      x2, sp, #0x60
0x0001e498  sub      x3, x29, #0xe0
0x0001e49c  str      x0, [sp, #0x10]
0x0001e4a0  mov      w4, #0x10
0x0001e4a4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001e4a8  cbz      x0, #0x1e5dc
0x0001e4ac  mov      x26, x0
0x0001e4b0  ldr      x8, [sp, #0x70]
0x0001e4b4  adrp     x25, #0x75000
0x0001e4b8  add      x25, x25, #0x1e8   ; STR "name"
0x0001e4bc  ldr      x24, [x8]
0x0001e4c0  mov      x22, #0
0x0001e4c4  ldr      x8, [sp, #0x70]
0x0001e4c8  ldr      x8, [x8]
0x0001e4cc  cmp      x8, x24
0x0001e4d0  b.eq     #0x1e4dc
0x0001e4d4  ldr      x0, [sp, #0x10]
0x0001e4d8  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0001e4dc  ldr      x8, [sp, #0x68]
0x0001e4e0  ldr      x28, [x8, x22, lsl #3]
0x0001e4e4  stur     x28, [x29, #-0xf8]
0x0001e4e8  adrp     x8, #0x75000
0x0001e4ec  add      x8, x8, #0x3e8   ; STR "id"
0x0001e4f0  stp      x8, x25, [sp, #0x150]
0x0001e4f4  mov      x0, x28
0x0001e4f8  bl       #0x1c620
0x0001e4fc  mov      x29, x29
0x0001e500  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e504  mov      x19, x0
0x0001e508  adrp     x8, #0x79000
0x0001e50c  add      x8, x8, #0x328   ; STR "carplay"
0x0001e510  str      x8, [sp, #0x160]
0x0001e514  stur     x0, [x29, #-0xf0]
0x0001e518  adrp     x8, #0x74000
0x0001e51c  ldr      x8, [x8, #0x1b8]   ; @GOT ___kCFBooleanTrue
0x0001e520  stur     x8, [x29, #-0xe8]
0x0001e524  adrp     x8, #0x8e000
0x0001e528  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x0001e52c  sub      x2, x29, #0xf8
0x0001e530  add      x3, sp, #0x150
0x0001e534  mov      w4, #3
0x0001e538  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0001e53c  mov      x29, x29
0x0001e540  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e544  mov      x27, x0
0x0001e548  mov      x0, x19
0x0001e54c  bl       #0x55d78   ; CALL _objc_release
0x0001e550  mov      x0, x20
0x0001e554  mov      x2, x28
0x0001e558  bl       #0x57fa0   ; CALL objc_msgSend$hides:
0x0001e55c  mov      x8, x0
0x0001e560  mov      x0, x21
0x0001e564  cbz      w8, #0x1e5a4
0x0001e568  mov      x0, x27
0x0001e56c  mov      x2, x25
0x0001e570  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001e574  mov      x29, x29
0x0001e578  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e57c  mov      x19, x0
0x0001e580  ldr      x8, [x23, #0x10]
0x0001e584  mov      x0, x23
0x0001e588  mov      x1, x19
0x0001e58c  blr      x8
0x0001e590  mov      x28, x0
0x0001e594  mov      x0, x19
0x0001e598  bl       #0x55d78   ; CALL _objc_release
0x0001e59c  ldr      x0, [sp, #0x18]
0x0001e5a0  cbz      w28, #0x1e5ac
0x0001e5a4  mov      x2, x27
0x0001e5a8  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0001e5ac  mov      x0, x27
0x0001e5b0  bl       #0x55d78   ; CALL _objc_release
0x0001e5b4  add      x22, x22, #1
0x0001e5b8  cmp      x26, x22
0x0001e5bc  b.ne     #0x1e4c4
0x0001e5c0  add      x2, sp, #0x60
0x0001e5c4  sub      x3, x29, #0xe0
0x0001e5c8  ldr      x0, [sp, #0x10]
0x0001e5cc  mov      w4, #0x10
0x0001e5d0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001e5d4  mov      x26, x0
0x0001e5d8  cbnz     x0, #0x1e4c0
0x0001e5dc  ldr      x0, [sp, #0x10]
0x0001e5e0  bl       #0x55d78   ; CALL _objc_release
0x0001e5e4  movi     v0.16b, #0
0x0001e5e8  stp      q0, q0, [sp, #0x40]
0x0001e5ec  stp      q0, q0, [sp, #0x20]
0x0001e5f0  adrp     x8, #0x8e000
0x0001e5f4  ldrsw    x8, [x8, #0xe64]
0x0001e5f8  ldr      x19, [x20, x8]
0x0001e5fc  mov      x0, x19
0x0001e600  bl       #0x55d84   ; CALL _objc_retain
0x0001e604  add      x2, sp, #0x20
0x0001e608  add      x3, sp, #0xd0
0x0001e60c  str      x19, [sp, #0x10]
0x0001e610  mov      x0, x19
0x0001e614  mov      w4, #0x10
0x0001e618  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001e61c  cbz      x0, #0x1e70c
0x0001e620  mov      x26, x0
0x0001e624  ldr      x8, [sp, #0x30]
0x0001e628  ldr      x22, [x8]
0x0001e62c  adrp     x25, #0x75000
0x0001e630  add      x25, x25, #0x3e8   ; STR "id"
0x0001e634  mov      x24, #0
0x0001e638  ldr      x8, [sp, #0x30]
0x0001e63c  ldr      x8, [x8]
0x0001e640  cmp      x8, x22
0x0001e644  b.eq     #0x1e650
0x0001e648  ldr      x0, [sp, #0x10]
0x0001e64c  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0001e650  ldr      x8, [sp, #0x28]
0x0001e654  ldr      x28, [x8, x24, lsl #3]
0x0001e658  adrp     x8, #0x8e000
0x0001e65c  ldrsw    x8, [x8, #0xe74]
0x0001e660  ldr      x19, [x20, x8]
0x0001e664  mov      x0, x28
0x0001e668  mov      x2, x25
0x0001e66c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001e670  mov      x29, x29
0x0001e674  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e678  mov      x27, x0
0x0001e67c  mov      x0, x19
0x0001e680  mov      x2, x27
0x0001e684  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0001e688  mov      x19, x0
0x0001e68c  mov      x0, x27
0x0001e690  bl       #0x55d78   ; CALL _objc_release
0x0001e694  mov      x0, x21
0x0001e698  tbnz     w19, #0, #0x1e6dc
0x0001e69c  mov      x0, x28
0x0001e6a0  adrp     x2, #0x75000
0x0001e6a4  add      x2, x2, #0x1e8   ; STR "name"
0x0001e6a8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001e6ac  mov      x29, x29
0x0001e6b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e6b4  mov      x19, x0
0x0001e6b8  ldr      x8, [x23, #0x10]
0x0001e6bc  mov      x0, x23
0x0001e6c0  mov      x1, x19
0x0001e6c4  blr      x8
0x0001e6c8  mov      x27, x0
0x0001e6cc  mov      x0, x19
0x0001e6d0  bl       #0x55d78   ; CALL _objc_release
0x0001e6d4  ldr      x0, [sp, #0x18]
0x0001e6d8  cbz      w27, #0x1e6e4
0x0001e6dc  mov      x2, x28
0x0001e6e0  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0001e6e4  add      x24, x24, #1
0x0001e6e8  cmp      x26, x24
0x0001e6ec  b.ne     #0x1e638
0x0001e6f0  add      x2, sp, #0x20
0x0001e6f4  add      x3, sp, #0xd0
0x0001e6f8  ldr      x0, [sp, #0x10]
0x0001e6fc  mov      w4, #0x10
0x0001e700  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001e704  mov      x26, x0
0x0001e708  cbnz     x0, #0x1e634
0x0001e70c  ldr      x0, [sp, #0x10]
0x0001e710  bl       #0x55d78   ; CALL _objc_release
0x0001e714  adrp     x8, #0x8e000
0x0001e718  ldrsw    x8, [x8, #0xe94]
0x0001e71c  ldr      x19, [x20, x8]
0x0001e720  str      x21, [x20, x8]
0x0001e724  mov      x0, x21
0x0001e728  bl       #0x55d84   ; CALL _objc_retain
0x0001e72c  mov      x0, x19
0x0001e730  bl       #0x55d78   ; CALL _objc_release
0x0001e734  adrp     x8, #0x8e000
0x0001e738  ldrsw    x8, [x8, #0xe98]
0x0001e73c  ldr      x19, [x20, x8]
0x0001e740  ldr      x22, [sp, #0x18]
0x0001e744  str      x22, [x20, x8]
0x0001e748  mov      x0, x22
0x0001e74c  bl       #0x55d84   ; CALL _objc_retain
0x0001e750  mov      x0, x19
0x0001e754  bl       #0x55d78   ; CALL _objc_release
0x0001e758  mov      x0, x23
0x0001e75c  bl       #0x55d78   ; CALL _objc_release
0x0001e760  ldr      x0, [sp, #0xc8]
0x0001e764  bl       #0x55d78   ; CALL _objc_release
0x0001e768  mov      x0, x22
0x0001e76c  bl       #0x55d78   ; CALL _objc_release
0x0001e770  mov      x0, x21
0x0001e774  bl       #0x55d78   ; CALL _objc_release
0x0001e778  ldr      x0, [sp, #8]
0x0001e77c  bl       #0x55d78   ; CALL _objc_release
0x0001e780  ldur     x8, [x29, #-0x60]
0x0001e784  adrp     x9, #0x74000
0x0001e788  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0001e78c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0001e790  cmp      x9, x8
0x0001e794  b.ne     #0x1e7b8
0x0001e798  add      sp, sp, #0x210
0x0001e79c  ldp      x29, x30, [sp, #0x50]
0x0001e7a0  ldp      x20, x19, [sp, #0x40]
0x0001e7a4  ldp      x22, x21, [sp, #0x30]
0x0001e7a8  ldp      x24, x23, [sp, #0x20]
0x0001e7ac  ldp      x26, x25, [sp, #0x10]
0x0001e7b0  ldp      x28, x27, [sp], #0x60
0x0001e7b4  ret      
0x0001e7b8  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0001e7bc  ldr      x2, [x0, #0x20]
0x0001e7c0  cbz      x2, #0x1e7ec
0x0001e7c4  stp      x29, x30, [sp, #-0x10]!
0x0001e7c8  mov      x29, sp
0x0001e7cc  mov      x0, x1
0x0001e7d0  mov      w3, #0x81
0x0001e7d4  bl       #0x59b60   ; CALL objc_msgSend$rangeOfString:options:
0x0001e7d8  mov      x8, #0x7fffffffffffffff
0x0001e7dc  cmp      x0, x8
0x0001e7e0  cset     w0, ne
0x0001e7e4  ldp      x29, x30, [sp], #0x10
0x0001e7e8  ret      
0x0001e7ec  mov      w0, #1
0x0001e7f0  ret      

=== -[OMCAppBridgeAppsController iconFor:]  va=0x1e7f4 size=144 types=@24@0:8@16
0x0001e7f4  stp      x22, x21, [sp, #-0x30]!
0x0001e7f8  stp      x20, x19, [sp, #0x10]
0x0001e7fc  stp      x29, x30, [sp, #0x20]
0x0001e800  add      x29, sp, #0x20
0x0001e804  mov      x19, x2
0x0001e808  mov      x20, x0
0x0001e80c  mov      x0, x2
0x0001e810  bl       #0x55d84   ; CALL _objc_retain
0x0001e814  adrp     x8, #0x8e000
0x0001e818  ldrsw    x22, [x8, #0xe5c]
0x0001e81c  ldr      x0, [x20, x22]
0x0001e820  mov      x2, x19
0x0001e824  bl       #0x593a0   ; CALL objc_msgSend$objectForKey:
0x0001e828  mov      x29, x29
0x0001e82c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e830  mov      x21, x0
0x0001e834  cbnz     x0, #0x1e868
0x0001e838  mov      x8, #0x4042000000000000
0x0001e83c  fmov     d0, x8
0x0001e840  mov      x0, x19
0x0001e844  bl       #0x1b7cc
0x0001e848  mov      x29, x29
0x0001e84c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e850  mov      x21, x0
0x0001e854  cbz      x0, #0x1e868
0x0001e858  ldr      x0, [x20, x22]
0x0001e85c  mov      x2, x21
0x0001e860  mov      x3, x19
0x0001e864  bl       #0x5b880   ; CALL objc_msgSend$setObject:forKey:
0x0001e868  mov      x0, x19
0x0001e86c  bl       #0x55d78   ; CALL _objc_release
0x0001e870  mov      x0, x21
0x0001e874  ldp      x29, x30, [sp, #0x20]
0x0001e878  ldp      x20, x19, [sp, #0x10]
0x0001e87c  ldp      x22, x21, [sp], #0x30
0x0001e880  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCAppBridgeAppsController alert:]  va=0x1e884 size=156 types=v24@0:8@16
0x0001e884  stp      x22, x21, [sp, #-0x30]!
0x0001e888  stp      x20, x19, [sp, #0x10]
0x0001e88c  stp      x29, x30, [sp, #0x20]
0x0001e890  add      x29, sp, #0x20
0x0001e894  mov      x3, x2
0x0001e898  mov      x19, x0
0x0001e89c  adrp     x8, #0x8e000
0x0001e8a0  ldr      x0, [x8, #0x9b8]   ; @CLASS UIAlertController
0x0001e8a4  mov      x2, #0
0x0001e8a8  mov      w4, #1
0x0001e8ac  bl       #0x56280   ; CALL objc_msgSend$alertControllerWithTitle:message:preferredStyle:
0x0001e8b0  mov      x29, x29
0x0001e8b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e8b8  mov      x20, x0
0x0001e8bc  adrp     x8, #0x8e000
0x0001e8c0  ldr      x0, [x8, #0x9c0]   ; @CLASS UIAlertAction
0x0001e8c4  adrp     x2, #0x76000
0x0001e8c8  add      x2, x2, #0xea8   ; STR "OK"
0x0001e8cc  mov      w3, #1
0x0001e8d0  mov      x4, #0
0x0001e8d4  bl       #0x55fc0   ; CALL objc_msgSend$actionWithTitle:style:handler:
0x0001e8d8  mov      x29, x29
0x0001e8dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e8e0  mov      x21, x0
0x0001e8e4  mov      x0, x20
0x0001e8e8  mov      x2, x21
0x0001e8ec  bl       #0x56000   ; CALL objc_msgSend$addAction:
0x0001e8f0  mov      x0, x21
0x0001e8f4  bl       #0x55d78   ; CALL _objc_release
0x0001e8f8  mov      x0, x19
0x0001e8fc  mov      x2, x20
0x0001e900  mov      w3, #1
0x0001e904  mov      x4, #0
0x0001e908  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x0001e90c  mov      x0, x20
0x0001e910  ldp      x29, x30, [sp, #0x20]
0x0001e914  ldp      x20, x19, [sp, #0x10]
0x0001e918  ldp      x22, x21, [sp], #0x30
0x0001e91c  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController storeChoices]  va=0x1e920 size=600 types=v16@0:8
0x0001e920  sub      sp, sp, #0x140
0x0001e924  stp      x28, x27, [sp, #0xe0]
0x0001e928  stp      x26, x25, [sp, #0xf0]
0x0001e92c  stp      x24, x23, [sp, #0x100]
0x0001e930  stp      x22, x21, [sp, #0x110]
0x0001e934  stp      x20, x19, [sp, #0x120]
0x0001e938  stp      x29, x30, [sp, #0x130]
0x0001e93c  add      x29, sp, #0x130
0x0001e940  mov      x20, x0
0x0001e944  adrp     x8, #0x74000
0x0001e948  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0001e94c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001e950  stur     x8, [x29, #-0x60]
0x0001e954  adrp     x8, #0x8e000
0x0001e958  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x0001e95c  bl       #0x565c0   ; CALL objc_msgSend$array
0x0001e960  mov      x29, x29
0x0001e964  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e968  str      x0, [sp, #8]
0x0001e96c  movi     v0.16b, #0
0x0001e970  stp      q0, q0, [sp, #0x10]
0x0001e974  stp      q0, q0, [sp, #0x30]
0x0001e978  adrp     x8, #0x8e000
0x0001e97c  ldrsw    x8, [x8, #0xe64]
0x0001e980  ldr      x21, [x20, x8]
0x0001e984  mov      x0, x21
0x0001e988  bl       #0x55d84   ; CALL _objc_retain
0x0001e98c  add      x2, sp, #0x10
0x0001e990  add      x3, sp, #0x50
0x0001e994  mov      x0, x21
0x0001e998  mov      w4, #0x10
0x0001e99c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001e9a0  cbz      x0, #0x1ea70
0x0001e9a4  mov      x23, x0
0x0001e9a8  ldr      x8, [sp, #0x20]
0x0001e9ac  ldr      x27, [x8]
0x0001e9b0  adrp     x28, #0x8e000
0x0001e9b4  adrp     x22, #0x75000
0x0001e9b8  add      x22, x22, #0x3e8   ; STR "id"
0x0001e9bc  mov      x19, #0
0x0001e9c0  ldr      x8, [sp, #0x20]
0x0001e9c4  ldr      x8, [x8]
0x0001e9c8  cmp      x8, x27
0x0001e9cc  b.eq     #0x1e9d8
0x0001e9d0  mov      x0, x21
0x0001e9d4  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0001e9d8  ldr      x8, [sp, #0x18]
0x0001e9dc  ldr      x24, [x8, x19, lsl #3]
0x0001e9e0  ldrsw    x8, [x28, #0xe74]
0x0001e9e4  ldr      x25, [x20, x8]
0x0001e9e8  mov      x0, x24
0x0001e9ec  mov      x2, x22
0x0001e9f0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001e9f4  mov      x29, x29
0x0001e9f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001e9fc  mov      x26, x0
0x0001ea00  mov      x0, x25
0x0001ea04  mov      x2, x26
0x0001ea08  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0001ea0c  mov      x25, x0
0x0001ea10  mov      x0, x26
0x0001ea14  bl       #0x55d78   ; CALL _objc_release
0x0001ea18  cbz      w25, #0x1ea48
0x0001ea1c  mov      x0, x24
0x0001ea20  mov      x2, x22
0x0001ea24  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001ea28  mov      x29, x29
0x0001ea2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ea30  mov      x24, x0
0x0001ea34  ldr      x0, [sp, #8]
0x0001ea38  mov      x2, x24
0x0001ea3c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0001ea40  mov      x0, x24
0x0001ea44  bl       #0x55d78   ; CALL _objc_release
0x0001ea48  add      x19, x19, #1
0x0001ea4c  cmp      x23, x19
0x0001ea50  b.ne     #0x1e9c0
0x0001ea54  add      x2, sp, #0x10
0x0001ea58  add      x3, sp, #0x50
0x0001ea5c  mov      x0, x21
0x0001ea60  mov      w4, #0x10
0x0001ea64  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001ea68  mov      x23, x0
0x0001ea6c  cbnz     x0, #0x1e9bc
0x0001ea70  mov      x0, x21
0x0001ea74  bl       #0x55d78   ; CALL _objc_release
0x0001ea78  adrp     x0, #0x76000
0x0001ea7c  add      x0, x0, #0x928   ; STR "appBridgeApps"
0x0001ea80  ldr      x19, [sp, #8]
0x0001ea84  mov      x1, x19
0x0001ea88  bl       #0x1cda0
0x0001ea8c  adrp     x8, #0x8e000
0x0001ea90  ldrsw    x8, [x8, #0xe78]
0x0001ea94  ldr      x0, [x20, x8]
0x0001ea98  bl       #0x562c0   ; CALL objc_msgSend$allObjects
0x0001ea9c  mov      x29, x29
0x0001eaa0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001eaa4  mov      x21, x0
0x0001eaa8  adrp     x8, #0x8c000
0x0001eaac  ldr      x22, [x8, #0x388]   ; @SEL "compare:"
0x0001eab0  mov      x2, x22
0x0001eab4  bl       #0x5cd00   ; CALL objc_msgSend$sortedArrayUsingSelector:
0x0001eab8  mov      x29, x29
0x0001eabc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001eac0  mov      x23, x0
0x0001eac4  adrp     x0, #0x79000
0x0001eac8  add      x0, x0, #0x208   ; STR "homeScreenHiddenApps"
0x0001eacc  mov      x1, x23
0x0001ead0  bl       #0x1cda0
0x0001ead4  mov      x0, x23
0x0001ead8  bl       #0x55d78   ; CALL _objc_release
0x0001eadc  mov      x0, x21
0x0001eae0  bl       #0x55d78   ; CALL _objc_release
0x0001eae4  adrp     x8, #0x8e000
0x0001eae8  ldrsw    x8, [x8, #0xe7c]
0x0001eaec  ldr      x0, [x20, x8]
0x0001eaf0  bl       #0x562c0   ; CALL objc_msgSend$allObjects
0x0001eaf4  mov      x29, x29
0x0001eaf8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001eafc  mov      x20, x0
0x0001eb00  mov      x2, x22
0x0001eb04  bl       #0x5cd00   ; CALL objc_msgSend$sortedArrayUsingSelector:
0x0001eb08  mov      x29, x29
0x0001eb0c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001eb10  mov      x21, x0
0x0001eb14  adrp     x0, #0x79000
0x0001eb18  add      x0, x0, #0x228   ; STR "homeScreenShownApps"
0x0001eb1c  mov      x1, x21
0x0001eb20  bl       #0x1cda0
0x0001eb24  mov      x0, x21
0x0001eb28  bl       #0x55d78   ; CALL _objc_release
0x0001eb2c  mov      x0, x20
0x0001eb30  bl       #0x55d78   ; CALL _objc_release
0x0001eb34  mov      x0, x19
0x0001eb38  bl       #0x55d78   ; CALL _objc_release
0x0001eb3c  ldur     x8, [x29, #-0x60]
0x0001eb40  adrp     x9, #0x74000
0x0001eb44  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0001eb48  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0001eb4c  cmp      x9, x8
0x0001eb50  b.ne     #0x1eb74
0x0001eb54  ldp      x29, x30, [sp, #0x130]
0x0001eb58  ldp      x20, x19, [sp, #0x120]
0x0001eb5c  ldp      x22, x21, [sp, #0x110]
0x0001eb60  ldp      x24, x23, [sp, #0x100]
0x0001eb64  ldp      x26, x25, [sp, #0xf0]
0x0001eb68  ldp      x28, x27, [sp, #0xe0]
0x0001eb6c  add      sp, sp, #0x140
0x0001eb70  ret      
0x0001eb74  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCAppBridgeAppsController reloadLists]  va=0x1eb78 size=668 types=v16@0:8
0x0001eb78  sub      sp, sp, #0xa0
0x0001eb7c  stp      x28, x27, [sp, #0x40]
0x0001eb80  stp      x26, x25, [sp, #0x50]
0x0001eb84  stp      x24, x23, [sp, #0x60]
0x0001eb88  stp      x22, x21, [sp, #0x70]
0x0001eb8c  stp      x20, x19, [sp, #0x80]
0x0001eb90  stp      x29, x30, [sp, #0x90]
0x0001eb94  add      x29, sp, #0x90
0x0001eb98  mov      x19, x0
0x0001eb9c  adrp     x8, #0x8e000
0x0001eba0  ldrsw    x26, [x8, #0xe58]
0x0001eba4  ldr      x0, [x0, x26]
0x0001eba8  mov      w2, #1
0x0001ebac  bl       #0x59280   ; CALL objc_msgSend$numberOfRowsInSection:
0x0001ebb0  mov      x22, x0
0x0001ebb4  ldr      x0, [x19, x26]
0x0001ebb8  mov      w2, #2
0x0001ebbc  bl       #0x59280   ; CALL objc_msgSend$numberOfRowsInSection:
0x0001ebc0  mov      x23, x0
0x0001ebc4  mov      x0, x19
0x0001ebc8  bl       #0x59bc0   ; CALL objc_msgSend$rebuildRows
0x0001ebcc  adrp     x21, #0x8e000
0x0001ebd0  ldr      x0, [x21, #0x988]   ; @CLASS NSMutableArray
0x0001ebd4  bl       #0x565c0   ; CALL objc_msgSend$array
0x0001ebd8  mov      x29, x29
0x0001ebdc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ebe0  mov      x20, x0
0x0001ebe4  ldr      x0, [x21, #0x988]   ; @CLASS NSMutableArray
0x0001ebe8  bl       #0x565c0   ; CALL objc_msgSend$array
0x0001ebec  mov      x29, x29
0x0001ebf0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ebf4  mov      x21, x0
0x0001ebf8  adrp     x27, #0x8e000
0x0001ebfc  cmp      x23, #2
0x0001ec00  b.lt     #0x1ec44
0x0001ec04  mov      w24, #1
0x0001ec08  ldr      x0, [x27, #0xb20]   ; @CLASS NSIndexPath
0x0001ec0c  mov      x2, x24
0x0001ec10  mov      w3, #2
0x0001ec14  bl       #0x58300   ; CALL objc_msgSend$indexPathForRow:inSection:
0x0001ec18  mov      x29, x29
0x0001ec1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ec20  mov      x25, x0
0x0001ec24  mov      x0, x20
0x0001ec28  mov      x2, x25
0x0001ec2c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0001ec30  mov      x0, x25
0x0001ec34  bl       #0x55d78   ; CALL _objc_release
0x0001ec38  add      x24, x24, #1
0x0001ec3c  cmp      x23, x24
0x0001ec40  b.ne     #0x1ec08
0x0001ec44  ldr      x2, [x19, x26]
0x0001ec48  mov      x0, x19
0x0001ec4c  mov      w3, #2
0x0001ec50  bl       #0x5d900   ; CALL objc_msgSend$tableView:numberOfRowsInSection:
0x0001ec54  cmp      x0, #2
0x0001ec58  b.lt     #0x1ecac
0x0001ec5c  mov      w23, #1
0x0001ec60  ldr      x0, [x27, #0xb20]   ; @CLASS NSIndexPath
0x0001ec64  mov      x2, x23
0x0001ec68  mov      w3, #2
0x0001ec6c  bl       #0x58300   ; CALL objc_msgSend$indexPathForRow:inSection:
0x0001ec70  mov      x29, x29
0x0001ec74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ec78  mov      x24, x0
0x0001ec7c  mov      x0, x21
0x0001ec80  mov      x2, x24
0x0001ec84  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0001ec88  mov      x0, x24
0x0001ec8c  bl       #0x55d78   ; CALL _objc_release
0x0001ec90  add      x23, x23, #1
0x0001ec94  ldr      x2, [x19, x26]
0x0001ec98  mov      x0, x19
0x0001ec9c  mov      w3, #2
0x0001eca0  bl       #0x5d900   ; CALL objc_msgSend$tableView:numberOfRowsInSection:
0x0001eca4  cmp      x23, x0
0x0001eca8  b.lt     #0x1ec60
0x0001ecac  ldr      x23, [x19, x26]
0x0001ecb0  adrp     x8, #0x74000
0x0001ecb4  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x0001ecb8  str      x8, [sp]
0x0001ecbc  adrp     x8, #0x65000
0x0001ecc0  ldr      d0, [x8, #0x600]
0x0001ecc4  str      d0, [sp, #8]
0x0001ecc8  adrp     x8, #0x1e000
0x0001eccc  add      x8, x8, #0xd48
0x0001ecd0  adrp     x9, #0x74000
0x0001ecd4  add      x9, x9, #0x9e0
0x0001ecd8  stp      x8, x9, [sp, #0x10]
0x0001ecdc  stp      x19, x20, [sp, #0x20]
0x0001ece0  stp      x21, x22, [sp, #0x30]
0x0001ece4  mov      x0, x21
0x0001ece8  bl       #0x55d84   ; CALL _objc_retain
0x0001ecec  mov      x0, x20
0x0001ecf0  bl       #0x55d84   ; CALL _objc_retain
0x0001ecf4  mov      x2, sp
0x0001ecf8  mov      x0, x23
0x0001ecfc  mov      x3, #0
0x0001ed00  bl       #0x59680   ; CALL objc_msgSend$performBatchUpdates:completion:
0x0001ed04  mov      x0, x19
0x0001ed08  bl       #0x5dd80   ; CALL objc_msgSend$updatePreview
0x0001ed0c  ldr      x0, [sp, #0x30]
0x0001ed10  bl       #0x55d78   ; CALL _objc_release
0x0001ed14  ldr      x0, [sp, #0x28]
0x0001ed18  bl       #0x55d78   ; CALL _objc_release
0x0001ed1c  mov      x0, x21
0x0001ed20  bl       #0x55d78   ; CALL _objc_release
0x0001ed24  mov      x0, x20
0x0001ed28  ldp      x29, x30, [sp, #0x90]
0x0001ed2c  ldp      x20, x19, [sp, #0x80]
0x0001ed30  ldp      x22, x21, [sp, #0x70]
0x0001ed34  ldp      x24, x23, [sp, #0x60]
0x0001ed38  ldp      x26, x25, [sp, #0x50]
0x0001ed3c  ldp      x28, x27, [sp, #0x40]
0x0001ed40  add      sp, sp, #0xa0
0x0001ed44  b        #0x55d78   ; CALL _objc_release
0x0001ed48  stp      x22, x21, [sp, #-0x30]!
0x0001ed4c  stp      x20, x19, [sp, #0x10]
0x0001ed50  stp      x29, x30, [sp, #0x20]
0x0001ed54  add      x29, sp, #0x20
0x0001ed58  mov      x19, x0
0x0001ed5c  ldr      x0, [x0, #0x20]
0x0001ed60  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x0001ed64  mov      x29, x29
0x0001ed68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ed6c  mov      x20, x0
0x0001ed70  adrp     x8, #0x8e000
0x0001ed74  ldr      x0, [x8, #0x968]   ; @CLASS NSIndexSet
0x0001ed78  mov      w2, #1
0x0001ed7c  bl       #0x58340   ; CALL objc_msgSend$indexSetWithIndex:
0x0001ed80  mov      x29, x29
0x0001ed84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ed88  mov      x21, x0
0x0001ed8c  ldr      x8, [x19, #0x38]
0x0001ed90  cmp      x8, #0
0x0001ed94  mov      w8, #5
0x0001ed98  csel     x3, x8, xzr, eq
0x0001ed9c  mov      x0, x20
0x0001eda0  mov      x2, x21
0x0001eda4  bl       #0x59d00   ; CALL objc_msgSend$reloadSections:withRowAnimation:
0x0001eda8  mov      x0, x21
0x0001edac  bl       #0x55d78   ; CALL _objc_release
0x0001edb0  mov      x0, x20
0x0001edb4  bl       #0x55d78   ; CALL _objc_release
0x0001edb8  ldr      x0, [x19, #0x20]
0x0001edbc  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x0001edc0  mov      x29, x29
0x0001edc4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001edc8  mov      x20, x0
0x0001edcc  ldr      x2, [x19, #0x28]
0x0001edd0  mov      x3, #0
0x0001edd4  bl       #0x576c0   ; CALL objc_msgSend$deleteRowsAtIndexPaths:withRowAnimation:
0x0001edd8  mov      x0, x20
0x0001eddc  bl       #0x55d78   ; CALL _objc_release
0x0001ede0  ldr      x0, [x19, #0x20]
0x0001ede4  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x0001ede8  mov      x29, x29
0x0001edec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001edf0  mov      x20, x0
0x0001edf4  ldr      x2, [x19, #0x30]
0x0001edf8  mov      x3, #0
0x0001edfc  bl       #0x58660   ; CALL objc_msgSend$insertRowsAtIndexPaths:withRowAnimation:
0x0001ee00  mov      x0, x20
0x0001ee04  ldp      x29, x30, [sp, #0x20]
0x0001ee08  ldp      x20, x19, [sp, #0x10]
0x0001ee0c  ldp      x22, x21, [sp], #0x30
0x0001ee10  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController searchBar:textDidChange:]  va=0x1ee74 size=64 types=v32@0:8@16@24
0x0001ee74  stp      x20, x19, [sp, #-0x20]!
0x0001ee78  stp      x29, x30, [sp, #0x10]
0x0001ee7c  add      x29, sp, #0x10
0x0001ee80  mov      x19, x3
0x0001ee84  mov      x20, x0
0x0001ee88  mov      x0, x3
0x0001ee8c  bl       #0x55d84   ; CALL _objc_retain
0x0001ee90  adrp     x8, #0x8e000
0x0001ee94  ldrsw    x8, [x8, #0xe90]
0x0001ee98  ldr      x0, [x20, x8]
0x0001ee9c  str      x19, [x20, x8]
0x0001eea0  bl       #0x55d78   ; CALL _objc_release
0x0001eea4  mov      x0, x20
0x0001eea8  ldp      x29, x30, [sp, #0x10]
0x0001eeac  ldp      x20, x19, [sp], #0x20
0x0001eeb0  b        #0x59cc0   ; CALL objc_msgSend$reloadLists

=== -[OMCAppBridgeAppsController searchBarSearchButtonClicked:]  va=0x1eeb4 size=8 types=v24@0:8@16
0x0001eeb4  mov      x0, x2
0x0001eeb8  b        #0x59f00   ; CALL objc_msgSend$resignFirstResponder

=== -[OMCAppBridgeAppsController resetTapped]  va=0x1eebc size=660 types=v16@0:8
0x0001eebc  sub      sp, sp, #0x70
0x0001eec0  stp      x24, x23, [sp, #0x30]
0x0001eec4  stp      x22, x21, [sp, #0x40]
0x0001eec8  stp      x20, x19, [sp, #0x50]
0x0001eecc  stp      x29, x30, [sp, #0x60]
0x0001eed0  add      x29, sp, #0x60
0x0001eed4  mov      x19, x0
0x0001eed8  bl       #0x58b60   ; CALL objc_msgSend$layoutPage
0x0001eedc  mov      x21, x0
0x0001eee0  adrp     x8, #0x8e000
0x0001eee4  ldr      x20, [x8, #0x9b8]   ; @CLASS UIAlertController
0x0001eee8  adrp     x8, #0x79000
0x0001eeec  add      x8, x8, #0x368   ; STR "APPS_RESET_CONFIRM"
0x0001eef0  adrp     x9, #0x79000
0x0001eef4  add      x9, x9, #0x348   ; STR "HOMESCREEN_RESET_CONFIRM"
0x0001eef8  cmp      w0, #0
0x0001eefc  csel     x0, x9, x8, ne
0x0001ef00  bl       #0x17e20   ; CALL _L
0x0001ef04  mov      x29, x29
0x0001ef08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ef0c  mov      x22, x0
0x0001ef10  mov      x0, x20
0x0001ef14  mov      x2, #0
0x0001ef18  mov      x3, x22
0x0001ef1c  mov      x4, #0
0x0001ef20  bl       #0x56280   ; CALL objc_msgSend$alertControllerWithTitle:message:preferredStyle:
0x0001ef24  mov      x29, x29
0x0001ef28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ef2c  mov      x20, x0
0x0001ef30  mov      x0, x22
0x0001ef34  bl       #0x55d78   ; CALL _objc_release
0x0001ef38  adrp     x24, #0x8e000
0x0001ef3c  ldr      x22, [x24, #0x9c0]   ; @CLASS UIAlertAction
0x0001ef40  adrp     x0, #0x79000
0x0001ef44  add      x0, x0, #0x168   ; STR "APPS_RESET"
0x0001ef48  bl       #0x17e20   ; CALL _L
0x0001ef4c  mov      x29, x29
0x0001ef50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ef54  mov      x23, x0
0x0001ef58  adrp     x8, #0x74000
0x0001ef5c  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x0001ef60  str      x8, [sp]
0x0001ef64  adrp     x8, #0x65000
0x0001ef68  ldr      d0, [x8, #0x600]
0x0001ef6c  str      d0, [sp, #8]
0x0001ef70  adrp     x8, #0x1f000
0x0001ef74  add      x8, x8, #0xac
0x0001ef78  adrp     x9, #0x74000
0x0001ef7c  add      x9, x9, #0xa10
0x0001ef80  stp      x8, x9, [sp, #0x10]
0x0001ef84  strb     w21, [sp, #0x28]
0x0001ef88  str      x19, [sp, #0x20]
0x0001ef8c  mov      x4, sp
0x0001ef90  mov      x0, x22
0x0001ef94  mov      x2, x23
0x0001ef98  mov      w3, #2
0x0001ef9c  bl       #0x55fc0   ; CALL objc_msgSend$actionWithTitle:style:handler:
0x0001efa0  mov      x29, x29
0x0001efa4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001efa8  mov      x21, x0
0x0001efac  mov      x0, x20
0x0001efb0  mov      x2, x21
0x0001efb4  bl       #0x56000   ; CALL objc_msgSend$addAction:
0x0001efb8  mov      x0, x21
0x0001efbc  bl       #0x55d78   ; CALL _objc_release
0x0001efc0  mov      x0, x23
0x0001efc4  bl       #0x55d78   ; CALL _objc_release
0x0001efc8  ldr      x21, [x24, #0x9c0]   ; @CLASS UIAlertAction
0x0001efcc  adrp     x0, #0x78000
0x0001efd0  add      x0, x0, #0x9e8   ; STR "CANCEL"
0x0001efd4  bl       #0x17e20   ; CALL _L
0x0001efd8  mov      x29, x29
0x0001efdc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001efe0  mov      x22, x0
0x0001efe4  mov      x0, x21
0x0001efe8  mov      x2, x22
0x0001efec  mov      w3, #1
0x0001eff0  mov      x4, #0
0x0001eff4  bl       #0x55fc0   ; CALL objc_msgSend$actionWithTitle:style:handler:
0x0001eff8  mov      x29, x29
0x0001effc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f000  mov      x21, x0
0x0001f004  mov      x0, x20
0x0001f008  mov      x2, x21
0x0001f00c  bl       #0x56000   ; CALL objc_msgSend$addAction:
0x0001f010  mov      x0, x21
0x0001f014  bl       #0x55d78   ; CALL _objc_release
0x0001f018  mov      x0, x22
0x0001f01c  bl       #0x55d78   ; CALL _objc_release
0x0001f020  mov      x0, x19
0x0001f024  bl       #0x591a0   ; CALL objc_msgSend$navigationItem
0x0001f028  mov      x29, x29
0x0001f02c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f030  mov      x21, x0
0x0001f034  bl       #0x59f20   ; CALL objc_msgSend$rightBarButtonItem
0x0001f038  mov      x29, x29
0x0001f03c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f040  mov      x22, x0
0x0001f044  mov      x0, x20
0x0001f048  bl       #0x59840   ; CALL objc_msgSend$popoverPresentationController
0x0001f04c  mov      x29, x29
0x0001f050  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f054  mov      x23, x0
0x0001f058  mov      x2, x22
0x0001f05c  bl       #0x5a5c0   ; CALL objc_msgSend$setBarButtonItem:
0x0001f060  mov      x0, x23
0x0001f064  bl       #0x55d78   ; CALL _objc_release
0x0001f068  mov      x0, x22
0x0001f06c  bl       #0x55d78   ; CALL _objc_release
0x0001f070  mov      x0, x21
0x0001f074  bl       #0x55d78   ; CALL _objc_release
0x0001f078  mov      x0, x19
0x0001f07c  mov      x2, x20
0x0001f080  mov      w3, #1
0x0001f084  mov      x4, #0
0x0001f088  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x0001f08c  mov      x0, x20
0x0001f090  bl       #0x55d78   ; CALL _objc_release
0x0001f094  ldp      x29, x30, [sp, #0x60]
0x0001f098  ldp      x20, x19, [sp, #0x50]
0x0001f09c  ldp      x22, x21, [sp, #0x40]
0x0001f0a0  ldp      x24, x23, [sp, #0x30]
0x0001f0a4  add      sp, sp, #0x70
0x0001f0a8  ret      
0x0001f0ac  stp      x20, x19, [sp, #-0x20]!
0x0001f0b0  stp      x29, x30, [sp, #0x10]
0x0001f0b4  add      x29, sp, #0x10
0x0001f0b8  mov      x19, x0
0x0001f0bc  ldrb     w8, [x0, #0x28]
0x0001f0c0  ldr      x0, [x0, #0x20]   ; @STR "vi"
0x0001f0c4  cmp      w8, #1
0x0001f0c8  b.ne     #0x1f0d4
0x0001f0cc  bl       #0x59ee0   ; CALL objc_msgSend$resetLayout
0x0001f0d0  b        #0x1f118
0x0001f0d4  bl       #0x57f80   ; CALL objc_msgSend$hidden
0x0001f0d8  mov      x29, x29
0x0001f0dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f0e0  mov      x20, x0
0x0001f0e4  bl       #0x59da0   ; CALL objc_msgSend$removeAllObjects
0x0001f0e8  mov      x0, x20
0x0001f0ec  bl       #0x55d78   ; CALL _objc_release
0x0001f0f0  ldr      x0, [x19, #0x20]
0x0001f0f4  bl       #0x5cb20   ; CALL objc_msgSend$shown
0x0001f0f8  mov      x29, x29
0x0001f0fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f100  mov      x20, x0
0x0001f104  bl       #0x59da0   ; CALL objc_msgSend$removeAllObjects
0x0001f108  mov      x0, x20
0x0001f10c  bl       #0x55d78   ; CALL _objc_release
0x0001f110  ldr      x0, [x19, #0x20]
0x0001f114  bl       #0x5d3a0   ; CALL objc_msgSend$storeChoices
0x0001f118  ldr      x0, [x19, #0x20]
0x0001f11c  bl       #0x59bc0   ; CALL objc_msgSend$rebuildRows
0x0001f120  ldr      x0, [x19, #0x20]
0x0001f124  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x0001f128  mov      x29, x29
0x0001f12c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f130  mov      x20, x0
0x0001f134  bl       #0x59ca0   ; CALL objc_msgSend$reloadData
0x0001f138  mov      x0, x20
0x0001f13c  bl       #0x55d78   ; CALL _objc_release
0x0001f140  ldr      x0, [x19, #0x20]
0x0001f144  ldp      x29, x30, [sp, #0x10]
0x0001f148  ldp      x20, x19, [sp], #0x20
0x0001f14c  b        #0x5dd80   ; CALL objc_msgSend$updatePreview

=== -[OMCAppBridgeAppsController resetLayout]  va=0x1f150 size=444 types=v16@0:8
0x0001f150  stp      x28, x27, [sp, #-0x50]!
0x0001f154  stp      x24, x23, [sp, #0x10]
0x0001f158  stp      x22, x21, [sp, #0x20]
0x0001f15c  stp      x20, x19, [sp, #0x30]
0x0001f160  stp      x29, x30, [sp, #0x40]
0x0001f164  add      x29, sp, #0x40
0x0001f168  sub      sp, sp, #0x4d0
0x0001f16c  mov      x19, x0
0x0001f170  adrp     x8, #0x74000
0x0001f174  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0001f178  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001f17c  stur     x8, [x29, #-0x48]
0x0001f180  movi     v0.16b, #0
0x0001f184  stp      q0, q0, [sp]
0x0001f188  stp      q0, q0, [sp, #0x20]
0x0001f18c  adrp     x0, #0x7f000
0x0001f190  add      x0, x0, #0x978
0x0001f194  mov      x2, sp
0x0001f198  sub      x3, x29, #0xc8
0x0001f19c  mov      w4, #0x10
0x0001f1a0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001f1a4  cbz      x0, #0x1f21c
0x0001f1a8  mov      x22, x0
0x0001f1ac  ldr      x8, [sp, #0x10]
0x0001f1b0  ldr      x23, [x8]   ; @GOT ___objc_personality_v0
0x0001f1b4  adrp     x20, #0x75000
0x0001f1b8  add      x20, x20, #0x28   ; STR "com.anlai.omnicar"
0x0001f1bc  adrp     x21, #0x7f000
0x0001f1c0  add      x21, x21, #0x978
0x0001f1c4  mov      x24, #0
0x0001f1c8  ldr      x8, [sp, #0x10]
0x0001f1cc  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001f1d0  cmp      x8, x23
0x0001f1d4  b.eq     #0x1f1e0
0x0001f1d8  mov      x0, x21
0x0001f1dc  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0001f1e0  ldr      x8, [sp, #8]
0x0001f1e4  ldr      x0, [x8, x24, lsl #3]   ; @GOT ___objc_personality_v0
0x0001f1e8  mov      x1, #0
0x0001f1ec  mov      x2, x20
0x0001f1f0  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x0001f1f4  add      x24, x24, #1
0x0001f1f8  cmp      x22, x24
0x0001f1fc  b.ne     #0x1f1c8
0x0001f200  mov      x2, sp
0x0001f204  sub      x3, x29, #0xc8
0x0001f208  mov      x0, x21
0x0001f20c  mov      w4, #0x10
0x0001f210  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001f214  mov      x22, x0
0x0001f218  cbnz     x0, #0x1f1c4
0x0001f21c  adrp     x8, #0x8e000
0x0001f220  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x0001f224  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x0001f228  mov      x29, x29
0x0001f22c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f230  mov      x20, x0
0x0001f234  adrp     x0, #0x79000
0x0001f238  add      x0, x0, #0x248   ; STR "/var/mobile/Library/OmniCar"
0x0001f23c  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0001f240  add      x1, sp, #0x48
0x0001f244  bl       #0x4118
0x0001f248  cbz      x0, #0x1f26c
0x0001f24c  mov      x2, x0
0x0001f250  adrp     x8, #0x8e000
0x0001f254  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0001f258  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0001f25c  mov      x29, x29
0x0001f260  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f264  mov      x21, x0
0x0001f268  b        #0x1f270
0x0001f26c  mov      x21, #0
0x0001f270  adrp     x2, #0x79000
0x0001f274  add      x2, x2, #0x308   ; STR "HomeScreen/wallpaper.jpg"
0x0001f278  mov      x0, x21
0x0001f27c  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x0001f280  mov      x29, x29
0x0001f284  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f288  mov      x22, x0
0x0001f28c  mov      x0, x20
0x0001f290  mov      x2, x22
0x0001f294  mov      x3, #0
0x0001f298  bl       #0x59e20   ; CALL objc_msgSend$removeItemAtPath:error:
0x0001f29c  mov      x0, x22
0x0001f2a0  bl       #0x55d78   ; CALL _objc_release
0x0001f2a4  mov      x0, x21
0x0001f2a8  bl       #0x55d78   ; CALL _objc_release
0x0001f2ac  mov      x0, x20
0x0001f2b0  bl       #0x55d78   ; CALL _objc_release
0x0001f2b4  adrp     x0, #0x75000
0x0001f2b8  add      x0, x0, #0x28   ; STR "com.anlai.omnicar"
0x0001f2bc  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x0001f2c0  adrp     x0, #0x61000
0x0001f2c4  add      x0, x0, #0x1b1   ; CSTR "com.anlai.omnicar/prefschanged"
0x0001f2c8  bl       #0x55c70   ; CALL _notify_post
0x0001f2cc  mov      x0, x19
0x0001f2d0  bl       #0x58d20   ; CALL objc_msgSend$loadState
0x0001f2d4  ldur     x8, [x29, #-0x48]
0x0001f2d8  adrp     x9, #0x74000
0x0001f2dc  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0001f2e0  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0001f2e4  cmp      x9, x8
0x0001f2e8  b.ne     #0x1f308
0x0001f2ec  add      sp, sp, #0x4d0
0x0001f2f0  ldp      x29, x30, [sp, #0x40]
0x0001f2f4  ldp      x20, x19, [sp, #0x30]
0x0001f2f8  ldp      x22, x21, [sp, #0x20]
0x0001f2fc  ldp      x24, x23, [sp, #0x10]
0x0001f300  ldp      x28, x27, [sp], #0x50
0x0001f304  ret      
0x0001f308  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCAppBridgeAppsController updatePreview]  va=0x1f30c size=1032 types=v16@0:8
0x0001f30c  stp      x28, x27, [sp, #-0x60]!
0x0001f310  stp      x26, x25, [sp, #0x10]
0x0001f314  stp      x24, x23, [sp, #0x20]
0x0001f318  stp      x22, x21, [sp, #0x30]
0x0001f31c  stp      x20, x19, [sp, #0x40]
0x0001f320  stp      x29, x30, [sp, #0x50]
0x0001f324  add      x29, sp, #0x50
0x0001f328  sub      sp, sp, #0x1a0
0x0001f32c  mov      x21, x0
0x0001f330  adrp     x8, #0x74000
0x0001f334  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0001f338  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001f33c  stur     x8, [x29, #-0x60]
0x0001f340  bl       #0x599e0   ; CALL objc_msgSend$preview
0x0001f344  mov      x29, x29
0x0001f348  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f34c  mov      x19, x0
0x0001f350  cbz      x0, #0x1f6d0
0x0001f354  str      x19, [sp]
0x0001f358  adrp     x8, #0x8e000
0x0001f35c  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x0001f360  bl       #0x565c0   ; CALL objc_msgSend$array
0x0001f364  mov      x29, x29
0x0001f368  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f36c  mov      x25, x0
0x0001f370  movi     v0.16b, #0
0x0001f374  stp      q0, q0, [sp, #0x50]
0x0001f378  stp      q0, q0, [sp, #0x70]
0x0001f37c  adrp     x8, #0x8e000
0x0001f380  ldrsw    x8, [x8, #0xe6c]
0x0001f384  ldr      x22, [x21, x8]
0x0001f388  mov      x0, x22
0x0001f38c  bl       #0x55d84   ; CALL _objc_retain
0x0001f390  add      x2, sp, #0x50
0x0001f394  sub      x3, x29, #0xe0
0x0001f398  mov      x0, x22
0x0001f39c  mov      w4, #0x10
0x0001f3a0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001f3a4  cbz      x0, #0x1f434
0x0001f3a8  mov      x23, x0
0x0001f3ac  ldr      x8, [sp, #0x60]
0x0001f3b0  ldr      x19, [x8]
0x0001f3b4  mov      x20, #0
0x0001f3b8  ldr      x8, [sp, #0x60]
0x0001f3bc  ldr      x8, [x8]
0x0001f3c0  cmp      x8, x19
0x0001f3c4  b.eq     #0x1f3d0
0x0001f3c8  mov      x0, x22
0x0001f3cc  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0001f3d0  ldr      x8, [sp, #0x58]
0x0001f3d4  ldr      x24, [x8, x20, lsl #3]
0x0001f3d8  mov      x0, x21
0x0001f3dc  mov      x2, x24
0x0001f3e0  bl       #0x57fa0   ; CALL objc_msgSend$hides:
0x0001f3e4  tbnz     w0, #0, #0x1f40c
0x0001f3e8  adrp     x8, #0x8e000
0x0001f3ec  ldrsw    x8, [x8, #0xe74]
0x0001f3f0  ldr      x0, [x21, x8]
0x0001f3f4  mov      x2, x24
0x0001f3f8  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0001f3fc  tbnz     w0, #0, #0x1f40c
0x0001f400  mov      x0, x25
0x0001f404  mov      x2, x24
0x0001f408  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0001f40c  add      x20, x20, #1
0x0001f410  cmp      x23, x20
0x0001f414  b.ne     #0x1f3b8
0x0001f418  add      x2, sp, #0x50
0x0001f41c  sub      x3, x29, #0xe0
0x0001f420  mov      x0, x22
0x0001f424  mov      w4, #0x10
0x0001f428  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001f42c  mov      x23, x0
0x0001f430  cbnz     x0, #0x1f3b4
0x0001f434  str      x25, [sp, #8]
0x0001f438  mov      x0, x22
0x0001f43c  bl       #0x55d78   ; CALL _objc_release
0x0001f440  movi     v0.16b, #0
0x0001f444  stp      q0, q0, [sp, #0x30]
0x0001f448  stp      q0, q0, [sp, #0x10]
0x0001f44c  adrp     x8, #0x8e000
0x0001f450  ldrsw    x8, [x8, #0xe64]
0x0001f454  ldr      x22, [x21, x8]
0x0001f458  mov      x0, x22
0x0001f45c  bl       #0x55d84   ; CALL _objc_retain
0x0001f460  add      x2, sp, #0x10
0x0001f464  add      x3, sp, #0x90
0x0001f468  mov      x0, x22
0x0001f46c  mov      w4, #0x10
0x0001f470  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001f474  cbz      x0, #0x1f574
0x0001f478  mov      x24, x0
0x0001f47c  ldr      x8, [sp, #0x20]
0x0001f480  ldr      x20, [x8]
0x0001f484  adrp     x23, #0x75000
0x0001f488  add      x23, x23, #0x3e8   ; STR "id"
0x0001f48c  mov      x19, #0
0x0001f490  ldr      x8, [sp, #0x20]
0x0001f494  ldr      x8, [x8]
0x0001f498  cmp      x8, x20
0x0001f49c  b.eq     #0x1f4a8
0x0001f4a0  mov      x0, x22
0x0001f4a4  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0001f4a8  ldr      x8, [sp, #0x18]
0x0001f4ac  ldr      x25, [x8, x19, lsl #3]
0x0001f4b0  adrp     x8, #0x8e000
0x0001f4b4  ldrsw    x8, [x8, #0xe74]
0x0001f4b8  ldr      x27, [x21, x8]
0x0001f4bc  mov      x0, x25
0x0001f4c0  mov      x2, x23
0x0001f4c4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001f4c8  mov      x29, x29
0x0001f4cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f4d0  mov      x26, x0
0x0001f4d4  mov      x0, x27
0x0001f4d8  mov      x2, x26
0x0001f4dc  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0001f4e0  cbz      w0, #0x1f544
0x0001f4e4  mov      x0, x25
0x0001f4e8  mov      x2, x23
0x0001f4ec  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001f4f0  mov      x29, x29
0x0001f4f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f4f8  mov      x27, x0
0x0001f4fc  ldr      x0, [sp, #8]
0x0001f500  mov      x2, x27
0x0001f504  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0001f508  mov      x28, x0
0x0001f50c  mov      x0, x27
0x0001f510  bl       #0x55d78   ; CALL _objc_release
0x0001f514  mov      x0, x26
0x0001f518  bl       #0x55d78   ; CALL _objc_release
0x0001f51c  tbnz     w28, #0, #0x1f54c
0x0001f520  mov      x0, x25
0x0001f524  mov      x2, x23
0x0001f528  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001f52c  mov      x29, x29
0x0001f530  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f534  mov      x26, x0
0x0001f538  ldr      x0, [sp, #8]
0x0001f53c  mov      x2, x26
0x0001f540  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0001f544  mov      x0, x26
0x0001f548  bl       #0x55d78   ; CALL _objc_release
0x0001f54c  add      x19, x19, #1
0x0001f550  cmp      x24, x19
0x0001f554  b.ne     #0x1f490
0x0001f558  add      x2, sp, #0x10
0x0001f55c  add      x3, sp, #0x90
0x0001f560  mov      x0, x22
0x0001f564  mov      w4, #0x10
0x0001f568  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001f56c  mov      x24, x0
0x0001f570  cbnz     x0, #0x1f48c
0x0001f574  mov      x0, x22
0x0001f578  bl       #0x55d78   ; CALL _objc_release
0x0001f57c  ldr      x20, [sp, #8]
0x0001f580  mov      x0, x20
0x0001f584  bl       #0x573c0   ; CALL objc_msgSend$count
0x0001f588  ldr      x19, [sp]
0x0001f58c  cbnz     x0, #0x1f5ac
0x0001f590  adrp     x0, #0x7f000
0x0001f594  add      x0, x0, #0x990
0x0001f598  bl       #0x590a0   ; CALL objc_msgSend$mutableCopy
0x0001f59c  mov      x22, x0
0x0001f5a0  mov      x0, x20
0x0001f5a4  bl       #0x55d78   ; CALL _objc_release
0x0001f5a8  mov      x20, x22
0x0001f5ac  mov      x0, x19
0x0001f5b0  mov      x2, x20
0x0001f5b4  bl       #0x5b1c0   ; CALL objc_msgSend$setItems:
0x0001f5b8  adrp     x8, #0x8e000
0x0001f5bc  ldrsw    x8, [x8, #0xe8c]
0x0001f5c0  ldr      x2, [x21, x8]
0x0001f5c4  mov      x0, x19
0x0001f5c8  bl       #0x5c8a0   ; CALL objc_msgSend$setWallpaper:
0x0001f5cc  adrp     x8, #0x8e000
0x0001f5d0  ldrsw    x8, [x8, #0xe88]
0x0001f5d4  ldr      x8, [x21, x8]
0x0001f5d8  cmp      x8, #8
0x0001f5dc  cset     w2, eq
0x0001f5e0  mov      x0, x19
0x0001f5e4  bl       #0x5c7e0   ; CALL objc_msgSend$setVideo:
0x0001f5e8  adrp     x2, #0x79000
0x0001f5ec  add      x2, x2, #0x3c8   ; STR "homeScreenIconSize"
0x0001f5f0  mov      x0, x21
0x0001f5f4  mov      w3, #0x64
0x0001f5f8  bl       #0x59220   ; CALL objc_msgSend$num:def:
0x0001f5fc  mov      x2, x0
0x0001f600  mov      x0, x19
0x0001f604  bl       #0x5c1a0   ; CALL objc_msgSend$setSize:
0x0001f608  adrp     x2, #0x79000
0x0001f60c  add      x2, x2, #0x408   ; STR "homeScreenBlur"
0x0001f610  mov      x0, x21
0x0001f614  mov      x3, #0
0x0001f618  bl       #0x59220   ; CALL objc_msgSend$num:def:
0x0001f61c  mov      x2, x0
0x0001f620  mov      x0, x19
0x0001f624  bl       #0x5a6e0   ; CALL objc_msgSend$setBlur:
0x0001f628  adrp     x2, #0x79000
0x0001f62c  add      x2, x2, #0x428   ; STR "homeScreenDim"
0x0001f630  mov      x0, x21
0x0001f634  mov      w3, #0x19
0x0001f638  bl       #0x59220   ; CALL objc_msgSend$num:def:
0x0001f63c  mov      x2, x0
0x0001f640  mov      x0, x19
0x0001f644  bl       #0x5acc0   ; CALL objc_msgSend$setDim:
0x0001f648  adrp     x2, #0x79000
0x0001f64c  add      x2, x2, #0x388   ; STR "homeScreenGridCols"
0x0001f650  mov      x0, x21
0x0001f654  mov      x3, #0
0x0001f658  bl       #0x59220   ; CALL objc_msgSend$num:def:
0x0001f65c  mov      x2, x0
0x0001f660  mov      x0, x19
0x0001f664  bl       #0x5a920   ; CALL objc_msgSend$setCols:
0x0001f668  adrp     x2, #0x79000
0x0001f66c  add      x2, x2, #0x3a8   ; STR "homeScreenGridRows"
0x0001f670  mov      x0, x21
0x0001f674  mov      x3, #0
0x0001f678  bl       #0x59220   ; CALL objc_msgSend$num:def:
0x0001f67c  mov      x2, x0
0x0001f680  mov      x0, x19
0x0001f684  bl       #0x5bec0   ; CALL objc_msgSend$setRows:
0x0001f688  adrp     x0, #0x79000
0x0001f68c  add      x0, x0, #0x3e8   ; STR "homeScreenShowNames"
0x0001f690  adrp     x1, #0x74000
0x0001f694  ldr      x1, [x1, #0x1b8]   ; @GOT ___kCFBooleanTrue
0x0001f698  bl       #0x1dcc4
0x0001f69c  mov      x29, x29
0x0001f6a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f6a4  mov      x21, x0
0x0001f6a8  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x0001f6ac  mov      x2, x0
0x0001f6b0  mov      x0, x19
0x0001f6b4  bl       #0x5b720   ; CALL objc_msgSend$setNames:
0x0001f6b8  mov      x0, x21
0x0001f6bc  bl       #0x55d78   ; CALL _objc_release
0x0001f6c0  mov      x0, x19
0x0001f6c4  bl       #0x5b780   ; CALL objc_msgSend$setNeedsDisplay
0x0001f6c8  mov      x0, x20
0x0001f6cc  bl       #0x55d78   ; CALL _objc_release
0x0001f6d0  mov      x0, x19
0x0001f6d4  bl       #0x55d78   ; CALL _objc_release
0x0001f6d8  ldur     x8, [x29, #-0x60]
0x0001f6dc  adrp     x9, #0x74000
0x0001f6e0  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0001f6e4  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0001f6e8  cmp      x9, x8
0x0001f6ec  b.ne     #0x1f710
0x0001f6f0  add      sp, sp, #0x1a0
0x0001f6f4  ldp      x29, x30, [sp, #0x50]
0x0001f6f8  ldp      x20, x19, [sp, #0x40]
0x0001f6fc  ldp      x22, x21, [sp, #0x30]
0x0001f700  ldp      x24, x23, [sp, #0x20]
0x0001f704  ldp      x26, x25, [sp, #0x10]
0x0001f708  ldp      x28, x27, [sp], #0x60
0x0001f70c  ret      
0x0001f710  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCAppBridgeAppsController isOpen:]  va=0x1f714 size=88 types=B24@0:8q16
0x0001f714  stp      x20, x19, [sp, #-0x20]!
0x0001f718  stp      x29, x30, [sp, #0x10]
0x0001f71c  add      x29, sp, #0x10
0x0001f720  adrp     x8, #0x8e000
0x0001f724  ldrsw    x8, [x8, #0xe60]
0x0001f728  ldr      x19, [x0, x8]
0x0001f72c  adrp     x8, #0x8e000
0x0001f730  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x0001f734  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x0001f738  mov      x29, x29
0x0001f73c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f740  mov      x20, x0
0x0001f744  mov      x0, x19
0x0001f748  mov      x2, x20
0x0001f74c  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0001f750  mov      x19, x0
0x0001f754  mov      x0, x20
0x0001f758  bl       #0x55d78   ; CALL _objc_release
0x0001f75c  mov      x0, x19
0x0001f760  ldp      x29, x30, [sp, #0x10]
0x0001f764  ldp      x20, x19, [sp], #0x20
0x0001f768  ret      

=== -[OMCAppBridgeAppsController reloadCard:]  va=0x1f76c size=124 types=v24@0:8q16
0x0001f76c  stp      x22, x21, [sp, #-0x30]!
0x0001f770  stp      x20, x19, [sp, #0x10]
0x0001f774  stp      x29, x30, [sp, #0x20]
0x0001f778  add      x29, sp, #0x20
0x0001f77c  mov      x20, x2
0x0001f780  mov      x19, x0
0x0001f784  adrp     x8, #0x8e000
0x0001f788  ldrsw    x8, [x8, #0xe58]
0x0001f78c  ldr      x21, [x0, x8]
0x0001f790  adrp     x8, #0x8e000
0x0001f794  ldr      x0, [x8, #0x968]   ; @CLASS NSIndexSet
0x0001f798  bl       #0x58340   ; CALL objc_msgSend$indexSetWithIndex:
0x0001f79c  mov      x29, x29
0x0001f7a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f7a4  mov      x22, x0
0x0001f7a8  mov      x0, x21
0x0001f7ac  mov      x2, x22
0x0001f7b0  mov      w3, #5
0x0001f7b4  bl       #0x59d00   ; CALL objc_msgSend$reloadSections:withRowAnimation:
0x0001f7b8  mov      x0, x22
0x0001f7bc  bl       #0x55d78   ; CALL _objc_release
0x0001f7c0  cbz      x20, #0x1f7d8
0x0001f7c4  mov      x0, x19
0x0001f7c8  ldp      x29, x30, [sp, #0x20]
0x0001f7cc  ldp      x20, x19, [sp, #0x10]
0x0001f7d0  ldp      x22, x21, [sp], #0x30
0x0001f7d4  b        #0x5dd80   ; CALL objc_msgSend$updatePreview
0x0001f7d8  ldp      x29, x30, [sp, #0x20]
0x0001f7dc  ldp      x20, x19, [sp, #0x10]
0x0001f7e0  ldp      x22, x21, [sp], #0x30
0x0001f7e4  ret      

=== -[OMCAppBridgeAppsController wallName:]  va=0x1f7e8 size=112 types=@24@0:8q16
0x0001f7e8  sub      sp, sp, #0x30
0x0001f7ec  stp      x20, x19, [sp, #0x10]
0x0001f7f0  stp      x29, x30, [sp, #0x20]
0x0001f7f4  add      x29, sp, #0x20
0x0001f7f8  adrp     x8, #0x8e000
0x0001f7fc  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0001f800  bic      x8, x2, x2, asr #63
0x0001f804  cmp      x8, #8
0x0001f808  mov      w9, #8
0x0001f80c  csel     x8, x8, x9, lt
0x0001f810  str      x8, [sp]
0x0001f814  adrp     x2, #0x79000
0x0001f818  add      x2, x2, #0x4a8   ; STR "APPS_WALL_%ld"
0x0001f81c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0001f820  mov      x29, x29
0x0001f824  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f828  mov      x19, x0
0x0001f82c  bl       #0x17e20   ; CALL _L
0x0001f830  mov      x29, x29
0x0001f834  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f838  mov      x20, x0
0x0001f83c  mov      x0, x19
0x0001f840  bl       #0x55d78   ; CALL _objc_release
0x0001f844  mov      x0, x20
0x0001f848  ldp      x29, x30, [sp, #0x20]
0x0001f84c  ldp      x20, x19, [sp, #0x10]
0x0001f850  add      sp, sp, #0x30
0x0001f854  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCAppBridgeAppsController summaryFor:]  va=0x1f858 size=56 types=@24@0:8q16
0x0001f858  cmp      x2, #4
0x0001f85c  b.ne     #0x1f888
0x0001f860  stp      x29, x30, [sp, #-0x10]!
0x0001f864  mov      x29, sp
0x0001f868  adrp     x8, #0x8e000
0x0001f86c  ldrsw    x8, [x8, #0xe88]
0x0001f870  ldr      x2, [x0, x8]
0x0001f874  bl       #0x5e040   ; CALL objc_msgSend$wallName:
0x0001f878  mov      x29, x29
0x0001f87c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f880  ldp      x29, x30, [sp], #0x10
0x0001f884  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0001f888  mov      x0, #0
0x0001f88c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCAppBridgeAppsController updateHeaders]  va=0x1f890 size=420 types=v16@0:8
0x0001f890  sub      sp, sp, #0x130
0x0001f894  stp      x28, x27, [sp, #0xd0]
0x0001f898  stp      x26, x25, [sp, #0xe0]
0x0001f89c  stp      x24, x23, [sp, #0xf0]
0x0001f8a0  stp      x22, x21, [sp, #0x100]
0x0001f8a4  stp      x20, x19, [sp, #0x110]
0x0001f8a8  stp      x29, x30, [sp, #0x120]
0x0001f8ac  add      x29, sp, #0x120
0x0001f8b0  mov      x19, x0
0x0001f8b4  adrp     x8, #0x74000
0x0001f8b8  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0001f8bc  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001f8c0  stur     x8, [x29, #-0x60]
0x0001f8c4  movi     v0.16b, #0
0x0001f8c8  stp      q0, q0, [sp]
0x0001f8cc  stp      q0, q0, [sp, #0x20]
0x0001f8d0  adrp     x0, #0x7f000
0x0001f8d4  add      x0, x0, #0x9a8
0x0001f8d8  mov      x2, sp
0x0001f8dc  add      x3, sp, #0x40
0x0001f8e0  mov      w4, #0x10
0x0001f8e4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001f8e8  cbz      x0, #0x1f9f8
0x0001f8ec  mov      x20, x0
0x0001f8f0  ldr      x8, [sp, #0x10]
0x0001f8f4  ldr      x25, [x8]   ; @GOT ___objc_personality_v0
0x0001f8f8  adrp     x26, #0x8e000
0x0001f8fc  adrp     x27, #0x8e000
0x0001f900  adrp     x21, #0x7f000
0x0001f904  add      x21, x21, #0x9a8
0x0001f908  mov      x28, #0
0x0001f90c  ldr      x8, [sp, #0x10]
0x0001f910  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001f914  cmp      x8, x25
0x0001f918  b.eq     #0x1f924
0x0001f91c  mov      x0, x21
0x0001f920  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0001f924  ldr      x8, [sp, #8]
0x0001f928  ldr      x22, [x8, x28, lsl #3]   ; @GOT ___objc_personality_v0
0x0001f92c  ldrsw    x8, [x26, #0xe58]
0x0001f930  ldr      x23, [x19, x8]
0x0001f934  ldr      x24, [x27, #0xb20]   ; @CLASS NSIndexPath
0x0001f938  mov      x0, x22
0x0001f93c  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0001f940  mov      x3, x0
0x0001f944  mov      x0, x24
0x0001f948  mov      x2, #0
0x0001f94c  bl       #0x58300   ; CALL objc_msgSend$indexPathForRow:inSection:
0x0001f950  mov      x29, x29
0x0001f954  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f958  mov      x24, x0
0x0001f95c  mov      x0, x23
0x0001f960  mov      x2, x24
0x0001f964  bl       #0x56cc0   ; CALL objc_msgSend$cellForRowAtIndexPath:
0x0001f968  mov      x29, x29
0x0001f96c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f970  mov      x23, x0
0x0001f974  mov      x0, x24
0x0001f978  bl       #0x55d78   ; CALL _objc_release
0x0001f97c  mov      x0, x22
0x0001f980  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0001f984  mov      x2, x0
0x0001f988  mov      x0, x19
0x0001f98c  bl       #0x5d720   ; CALL objc_msgSend$summaryFor:
0x0001f990  mov      x29, x29
0x0001f994  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f998  mov      x22, x0
0x0001f99c  mov      x0, x23
0x0001f9a0  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x0001f9a4  mov      x29, x29
0x0001f9a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001f9ac  mov      x24, x0
0x0001f9b0  mov      x2, x22
0x0001f9b4  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0001f9b8  mov      x0, x24
0x0001f9bc  bl       #0x55d78   ; CALL _objc_release
0x0001f9c0  mov      x0, x22
0x0001f9c4  bl       #0x55d78   ; CALL _objc_release
0x0001f9c8  mov      x0, x23
0x0001f9cc  bl       #0x55d78   ; CALL _objc_release
0x0001f9d0  add      x28, x28, #1
0x0001f9d4  cmp      x20, x28
0x0001f9d8  b.ne     #0x1f90c
0x0001f9dc  mov      x2, sp
0x0001f9e0  add      x3, sp, #0x40
0x0001f9e4  mov      x0, x21
0x0001f9e8  mov      w4, #0x10
0x0001f9ec  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001f9f0  mov      x20, x0
0x0001f9f4  cbnz     x0, #0x1f908
0x0001f9f8  ldur     x8, [x29, #-0x60]
0x0001f9fc  adrp     x9, #0x74000
0x0001fa00  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0001fa04  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0001fa08  cmp      x9, x8
0x0001fa0c  b.ne     #0x1fa30
0x0001fa10  ldp      x29, x30, [sp, #0x120]
0x0001fa14  ldp      x20, x19, [sp, #0x110]
0x0001fa18  ldp      x22, x21, [sp, #0x100]
0x0001fa1c  ldp      x24, x23, [sp, #0xf0]
0x0001fa20  ldp      x26, x25, [sp, #0xe0]
0x0001fa24  ldp      x28, x27, [sp, #0xd0]
0x0001fa28  add      sp, sp, #0x130
0x0001fa2c  ret      
0x0001fa30  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCAppBridgeAppsController headerCellFor:inTable:]  va=0x1fa34 size=844 types=@32@0:8q16@24
0x0001fa34  sub      sp, sp, #0x80
0x0001fa38  stp      x28, x27, [sp, #0x20]
0x0001fa3c  stp      x26, x25, [sp, #0x30]
0x0001fa40  stp      x24, x23, [sp, #0x40]
0x0001fa44  stp      x22, x21, [sp, #0x50]
0x0001fa48  stp      x20, x19, [sp, #0x60]
0x0001fa4c  stp      x29, x30, [sp, #0x70]
0x0001fa50  add      x29, sp, #0x70
0x0001fa54  mov      x20, x2
0x0001fa58  mov      x21, x0
0x0001fa5c  adrp     x8, #0x74000
0x0001fa60  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0001fa64  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001fa68  str      x8, [sp, #0x18]
0x0001fa6c  adrp     x2, #0x79000
0x0001fa70  add      x2, x2, #0x4c8   ; STR "head"
0x0001fa74  mov      x0, x3
0x0001fa78  bl       #0x576e0   ; CALL objc_msgSend$dequeueReusableCellWithIdentifier:
0x0001fa7c  mov      x29, x29
0x0001fa80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001fa84  mov      x22, x0
0x0001fa88  cbz      x0, #0x1fa9c
0x0001fa8c  mov      x0, x22
0x0001fa90  bl       #0x55d84   ; CALL _objc_retain
0x0001fa94  mov      x19, x22
0x0001fa98  b        #0x1fabc
0x0001fa9c  adrp     x8, #0x8e000
0x0001faa0  ldr      x0, [x8, #0x908]   ; @CLASS UITableViewCell
0x0001faa4  bl       #0x55c7c   ; CALL _objc_alloc
0x0001faa8  adrp     x3, #0x79000
0x0001faac  add      x3, x3, #0x4c8   ; STR "head"
0x0001fab0  mov      w2, #1
0x0001fab4  bl       #0x585c0   ; CALL objc_msgSend$initWithStyle:reuseIdentifier:
0x0001fab8  mov      x19, x0
0x0001fabc  mov      x0, x22
0x0001fac0  bl       #0x55d78   ; CALL _objc_release
0x0001fac4  mov      x0, x19
0x0001fac8  bl       #0x19168   ; CALL _OMCStyleCell
0x0001facc  adrp     x8, #0x80000
0x0001fad0  add      x9, x8, #0x1c0
0x0001fad4  adrp     x8, #0x7f000
0x0001fad8  add      x8, x8, #0x9c0
0x0001fadc  stp      x9, x8, [sp, #8]
0x0001fae0  adrp     x8, #0x8e000
0x0001fae4  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x0001fae8  add      x2, sp, #0x10
0x0001faec  add      x3, sp, #8
0x0001faf0  mov      w4, #1
0x0001faf4  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0001faf8  mov      x29, x29
0x0001fafc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001fb00  mov      x23, x0
0x0001fb04  adrp     x8, #0x8e000
0x0001fb08  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x0001fb0c  mov      x2, x20
0x0001fb10  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x0001fb14  mov      x29, x29
0x0001fb18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001fb1c  mov      x24, x0
0x0001fb20  mov      x0, x23
0x0001fb24  mov      x2, x24
0x0001fb28  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001fb2c  mov      x29, x29
0x0001fb30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001fb34  mov      x22, x0
0x0001fb38  mov      x0, x24
0x0001fb3c  bl       #0x55d78   ; CALL _objc_release
0x0001fb40  mov      x0, x23
0x0001fb44  bl       #0x55d78   ; CALL _objc_release
0x0001fb48  mov      x0, x22
0x0001fb4c  mov      x2, #0
0x0001fb50  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0001fb54  mov      x29, x29
0x0001fb58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001fb5c  mov      x23, x0
0x0001fb60  bl       #0x17e20   ; CALL _L
0x0001fb64  mov      x29, x29
0x0001fb68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001fb6c  mov      x24, x0
0x0001fb70  mov      x0, x19
0x0001fb74  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x0001fb78  mov      x29, x29
0x0001fb7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001fb80  mov      x25, x0
0x0001fb84  mov      x2, x24
0x0001fb88  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0001fb8c  mov      x0, x25
0x0001fb90  bl       #0x55d78   ; CALL _objc_release
0x0001fb94  mov      x0, x24
0x0001fb98  bl       #0x55d78   ; CALL _objc_release
0x0001fb9c  mov      x0, x23
0x0001fba0  bl       #0x55d78   ; CALL _objc_release
0x0001fba4  mov      x0, x22
0x0001fba8  mov      w2, #1
0x0001fbac  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0001fbb0  mov      x29, x29
0x0001fbb4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001fbb8  mov      x23, x0
0x0001fbbc  mov      x0, x22
0x0001fbc0  mov      w2, #2
0x0001fbc4  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0001fbc8  mov      x29, x29
0x0001fbcc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001fbd0  mov      x24, x0
0x0001fbd4  bl       #0x18080   ; CALL _OMCColorFromHex
0x0001fbd8  mov      x29, x29
0x0001fbdc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001fbe0  mov      x25, x0
0x0001fbe4  mov      x0, x23
0x0001fbe8  mov      x1, x25
0x0001fbec  bl       #0x18144   ; CALL _OMCIcon
0x0001fbf0  mov      x29, x29
0x0001fbf4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001fbf8  mov      x26, x0
0x0001fbfc  mov      x0, x19
0x0001fc00  bl       #0x58120   ; CALL objc_msgSend$imageView
0x0001fc04  mov      x29, x29
0x0001fc08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001fc0c  mov      x27, x0
0x0001fc10  mov      x2, x26
0x0001fc14  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x0001fc18  mov      x0, x27
0x0001fc1c  bl       #0x55d78   ; CALL _objc_release
0x0001fc20  mov      x0, x26
0x0001fc24  bl       #0x55d78   ; CALL _objc_release
0x0001fc28  mov      x0, x25
0x0001fc2c  bl       #0x55d78   ; CALL _objc_release
0x0001fc30  mov      x0, x24
0x0001fc34  bl       #0x55d78   ; CALL _objc_release
0x0001fc38  mov      x0, x23
0x0001fc3c  bl       #0x55d78   ; CALL _objc_release
0x0001fc40  mov      x0, x21
0x0001fc44  mov      x2, x20
0x0001fc48  bl       #0x5d720   ; CALL objc_msgSend$summaryFor:
0x0001fc4c  mov      x29, x29
0x0001fc50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001fc54  mov      x23, x0
0x0001fc58  mov      x0, x19
0x0001fc5c  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x0001fc60  mov      x29, x29
0x0001fc64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001fc68  mov      x24, x0
0x0001fc6c  mov      x2, x23
0x0001fc70  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0001fc74  mov      x0, x24
0x0001fc78  bl       #0x55d78   ; CALL _objc_release
0x0001fc7c  mov      x0, x23
0x0001fc80  bl       #0x55d78   ; CALL _objc_release
0x0001fc84  adrp     x8, #0x8e000
0x0001fc88  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x0001fc8c  bl       #0x55c7c   ; CALL _objc_alloc
0x0001fc90  mov      x23, x0
0x0001fc94  adrp     x8, #0x8e000
0x0001fc98  ldr      x24, [x8, #0xa78]   ; @CLASS UIImage
0x0001fc9c  mov      x0, x21
0x0001fca0  mov      x2, x20
0x0001fca4  bl       #0x588e0   ; CALL objc_msgSend$isOpen:
0x0001fca8  adrp     x8, #0x79000
0x0001fcac  add      x8, x8, #0x568   ; STR "chevron.right"
0x0001fcb0  adrp     x9, #0x79000
0x0001fcb4  add      x9, x9, #0x548   ; STR "chevron.down"
0x0001fcb8  cmp      w0, #0
0x0001fcbc  csel     x2, x9, x8, ne
0x0001fcc0  mov      x0, x24
0x0001fcc4  bl       #0x5d820   ; CALL objc_msgSend$systemImageNamed:
0x0001fcc8  mov      x29, x29
0x0001fccc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001fcd0  mov      x20, x0
0x0001fcd4  mov      x0, x23
0x0001fcd8  mov      x2, x20
0x0001fcdc  bl       #0x584c0   ; CALL objc_msgSend$initWithImage:
0x0001fce0  mov      x21, x0
0x0001fce4  mov      x0, x20
0x0001fce8  bl       #0x55d78   ; CALL _objc_release
0x0001fcec  adrp     x8, #0x8e000
0x0001fcf0  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0001fcf4  bl       #0x5d960   ; CALL objc_msgSend$tertiaryLabelColor
0x0001fcf8  mov      x29, x29
0x0001fcfc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001fd00  mov      x20, x0
0x0001fd04  mov      x0, x21
0x0001fd08  mov      x2, x20
0x0001fd0c  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x0001fd10  mov      x0, x20
0x0001fd14  bl       #0x55d78   ; CALL _objc_release
0x0001fd18  mov      x0, x19
0x0001fd1c  mov      x2, x21
0x0001fd20  bl       #0x5a2c0   ; CALL objc_msgSend$setAccessoryView:
0x0001fd24  mov      x0, x19
0x0001fd28  mov      w2, #3
0x0001fd2c  bl       #0x5bfa0   ; CALL objc_msgSend$setSelectionStyle:
0x0001fd30  mov      x0, x21
0x0001fd34  bl       #0x55d78   ; CALL _objc_release
0x0001fd38  mov      x0, x22
0x0001fd3c  bl       #0x55d78   ; CALL _objc_release
0x0001fd40  ldr      x8, [sp, #0x18]
0x0001fd44  adrp     x9, #0x74000
0x0001fd48  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0001fd4c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0001fd50  cmp      x9, x8
0x0001fd54  b.ne     #0x1fd7c
0x0001fd58  mov      x0, x19
0x0001fd5c  ldp      x29, x30, [sp, #0x70]
0x0001fd60  ldp      x20, x19, [sp, #0x60]
0x0001fd64  ldp      x22, x21, [sp, #0x50]
0x0001fd68  ldp      x24, x23, [sp, #0x40]
0x0001fd6c  ldp      x26, x25, [sp, #0x30]
0x0001fd70  ldp      x28, x27, [sp, #0x20]
0x0001fd74  add      sp, sp, #0x80
0x0001fd78  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0001fd7c  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCAppBridgeAppsController numberOfSectionsInTableView:]  va=0x1fd80 size=8 types=q24@0:8@16
0x0001fd80  mov      w0, #5
0x0001fd84  ret      

=== -[OMCAppBridgeAppsController tableView:numberOfRowsInSection:]  va=0x1fd88 size=192 types=q32@0:8@16q24
0x0001fd88  stp      x20, x19, [sp, #-0x20]!
0x0001fd8c  stp      x29, x30, [sp, #0x10]
0x0001fd90  add      x29, sp, #0x10
0x0001fd94  mov      x20, x3
0x0001fd98  mov      x19, x0
0x0001fd9c  mov      x2, x3
0x0001fda0  bl       #0x5cb60   ; CALL objc_msgSend$shows:
0x0001fda4  cbz      w0, #0x1fe08
0x0001fda8  mov      x0, x19
0x0001fdac  mov      x2, x20
0x0001fdb0  bl       #0x588e0   ; CALL objc_msgSend$isOpen:
0x0001fdb4  cmp      x20, #1
0x0001fdb8  b.le     #0x1fde4
0x0001fdbc  cmp      x20, #2
0x0001fdc0  b.eq     #0x1fe18
0x0001fdc4  cmp      x20, #3
0x0001fdc8  b.eq     #0x1fe38
0x0001fdcc  cmp      x20, #4
0x0001fdd0  b.ne     #0x1fe08
0x0001fdd4  cmp      w0, #0
0x0001fdd8  mov      w8, #5
0x0001fddc  csinc    x0, x8, xzr, ne
0x0001fde0  b        #0x1fe0c
0x0001fde4  cbz      x20, #0x1fe40
0x0001fde8  cmp      x20, #1
0x0001fdec  b.ne     #0x1fe08
0x0001fdf0  adrp     x8, #0x8e000
0x0001fdf4  ldrsw    x8, [x8, #0xe94]
0x0001fdf8  ldr      x0, [x19, x8]
0x0001fdfc  ldp      x29, x30, [sp, #0x10]
0x0001fe00  ldp      x20, x19, [sp], #0x20
0x0001fe04  b        #0x573c0   ; CALL objc_msgSend$count
0x0001fe08  mov      x0, #0
0x0001fe0c  ldp      x29, x30, [sp, #0x10]
0x0001fe10  ldp      x20, x19, [sp], #0x20
0x0001fe14  ret      
0x0001fe18  adrp     x8, #0x8e000
0x0001fe1c  ldrsw    x8, [x8, #0xe98]
0x0001fe20  ldr      x0, [x19, x8]
0x0001fe24  bl       #0x573c0   ; CALL objc_msgSend$count
0x0001fe28  cmp      x0, #1
0x0001fe2c  csinc    x8, x0, xzr, gt
0x0001fe30  add      x0, x8, #1
0x0001fe34  b        #0x1fe0c
0x0001fe38  mov      w0, #4
0x0001fe3c  b        #0x1fe0c
0x0001fe40  mov      w0, #1
0x0001fe44  b        #0x1fe0c

=== -[OMCAppBridgeAppsController tableView:titleForFooterInSection:]  va=0x1fe48 size=348 types=@32@0:8@16q24
0x0001fe48  sub      sp, sp, #0x40
0x0001fe4c  stp      x22, x21, [sp, #0x10]
0x0001fe50  stp      x20, x19, [sp, #0x20]
0x0001fe54  stp      x29, x30, [sp, #0x30]
0x0001fe58  add      x29, sp, #0x30
0x0001fe5c  mov      x20, x3
0x0001fe60  mov      x21, x0
0x0001fe64  mov      x2, x3
0x0001fe68  bl       #0x5cb60   ; CALL objc_msgSend$shows:
0x0001fe6c  cbz      w0, #0x1fee4
0x0001fe70  mov      x19, #0
0x0001fe74  cmp      x20, #2
0x0001fe78  b.gt     #0x1feb8
0x0001fe7c  cmp      x20, #1
0x0001fe80  b.eq     #0x1feec
0x0001fe84  cmp      x20, #2
0x0001fe88  b.ne     #0x1ff8c
0x0001fe8c  adrp     x8, #0x8e000
0x0001fe90  ldr      x19, [x8, #0x958]   ; @CLASS NSString
0x0001fe94  adrp     x0, #0x79000
0x0001fe98  add      x0, x0, #0x5c8   ; STR "APPS_OTHER_FOOTER"
0x0001fe9c  bl       #0x17e20   ; CALL _L
0x0001fea0  mov      x29, x29
0x0001fea4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001fea8  mov      x20, x0
0x0001feac  adrp     x0, #0x79000
0x0001feb0  add      x0, x0, #0x5e8   ; STR "APPBRIDGE_APPS_OTHER_FOOTER"
0x0001feb4  b        #0x1ff20
0x0001feb8  cmp      x20, #3
0x0001febc  b.eq     #0x1ff5c
0x0001fec0  cmp      x20, #4
0x0001fec4  b.ne     #0x1ff8c
0x0001fec8  mov      x0, x21
0x0001fecc  mov      w2, #4
0x0001fed0  bl       #0x588e0   ; CALL objc_msgSend$isOpen:
0x0001fed4  cbz      w0, #0x1fee4
0x0001fed8  adrp     x0, #0x79000
0x0001fedc  add      x0, x0, #0x628   ; STR "APPS_WALL_FOOTER"
0x0001fee0  b        #0x1ff64
0x0001fee4  mov      x19, #0
0x0001fee8  b        #0x1ff8c
0x0001feec  adrp     x0, #0x79000
0x0001fef0  add      x0, x0, #0x588   ; STR "APPS_CARPLAY_FOOTER"
0x0001fef4  bl       #0x17e20   ; CALL _L
0x0001fef8  mov      x29, x29
0x0001fefc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ff00  mov      x20, x0
0x0001ff04  mov      x0, x21
0x0001ff08  bl       #0x56c20   ; CALL objc_msgSend$carplayGuessed
0x0001ff0c  tbz      w0, #0, #0x1ff78
0x0001ff10  adrp     x8, #0x8e000
0x0001ff14  ldr      x19, [x8, #0x958]   ; @CLASS NSString
0x0001ff18  adrp     x0, #0x79000
0x0001ff1c  add      x0, x0, #0x5a8   ; STR "APPS_CARPLAY_GUESS_FOOTER"
0x0001ff20  bl       #0x17e20   ; CALL _L
0x0001ff24  mov      x29, x29
0x0001ff28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ff2c  mov      x21, x0
0x0001ff30  stp      x20, x0, [sp]
0x0001ff34  adrp     x2, #0x75000
0x0001ff38  add      x2, x2, #0x728   ; STR "%@ %@"
0x0001ff3c  mov      x0, x19
0x0001ff40  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0001ff44  mov      x29, x29
0x0001ff48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ff4c  mov      x19, x0
0x0001ff50  mov      x0, x21
0x0001ff54  bl       #0x55d78   ; CALL _objc_release
0x0001ff58  b        #0x1ff84
0x0001ff5c  adrp     x0, #0x79000
0x0001ff60  add      x0, x0, #0x608   ; STR "HOMESCREEN_ICON_SIZE_FOOTER"
0x0001ff64  bl       #0x17e20   ; CALL _L
0x0001ff68  mov      x29, x29
0x0001ff6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001ff70  mov      x19, x0
0x0001ff74  b        #0x1ff8c
0x0001ff78  mov      x0, x20
0x0001ff7c  bl       #0x55d84   ; CALL _objc_retain
0x0001ff80  mov      x19, x20
0x0001ff84  mov      x0, x20
0x0001ff88  bl       #0x55d78   ; CALL _objc_release
0x0001ff8c  mov      x0, x19
0x0001ff90  ldp      x29, x30, [sp, #0x30]
0x0001ff94  ldp      x20, x19, [sp, #0x20]
0x0001ff98  ldp      x22, x21, [sp, #0x10]
0x0001ff9c  add      sp, sp, #0x40
0x0001ffa0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCAppBridgeAppsController tableView:titleForHeaderInSection:]  va=0x1ffa4 size=224 types=@32@0:8@16q24
0x0001ffa4  sub      sp, sp, #0x40
0x0001ffa8  stp      x22, x21, [sp, #0x10]
0x0001ffac  stp      x20, x19, [sp, #0x20]
0x0001ffb0  stp      x29, x30, [sp, #0x30]
0x0001ffb4  add      x29, sp, #0x30
0x0001ffb8  mov      x20, x3
0x0001ffbc  mov      x19, x0
0x0001ffc0  mov      x2, x3
0x0001ffc4  bl       #0x5cb60   ; CALL objc_msgSend$shows:
0x0001ffc8  cbz      w0, #0x20040
0x0001ffcc  cmp      x20, #3
0x0001ffd0  b.eq     #0x20054
0x0001ffd4  cmp      x20, #2
0x0001ffd8  b.eq     #0x20048
0x0001ffdc  cmp      x20, #1
0x0001ffe0  b.ne     #0x20040
0x0001ffe4  adrp     x8, #0x8e000
0x0001ffe8  ldr      x20, [x8, #0x958]   ; @CLASS NSString
0x0001ffec  adrp     x0, #0x79000
0x0001fff0  add      x0, x0, #0x668   ; STR "APPS_INCLUDED"
0x0001fff4  bl       #0x17e20   ; CALL _L
0x0001fff8  mov      x29, x29
0x0001fffc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020000  mov      x21, x0
0x00020004  adrp     x8, #0x8e000
0x00020008  ldrsw    x8, [x8, #0xe94]
0x0002000c  ldr      x0, [x19, x8]
0x00020010  bl       #0x573c0   ; CALL objc_msgSend$count
0x00020014  stp      x21, x0, [sp]
0x00020018  adrp     x2, #0x79000
0x0002001c  add      x2, x2, #0x648   ; STR "%@ · %lu"
0x00020020  mov      x0, x20
0x00020024  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00020028  mov      x29, x29
0x0002002c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020030  mov      x19, x0
0x00020034  mov      x0, x21
0x00020038  bl       #0x55d78   ; CALL _objc_release
0x0002003c  b        #0x2006c
0x00020040  mov      x19, #0
0x00020044  b        #0x2006c
0x00020048  adrp     x0, #0x79000
0x0002004c  add      x0, x0, #0x688   ; STR "APPS_OTHER"
0x00020050  b        #0x2005c
0x00020054  adrp     x0, #0x79000
0x00020058  add      x0, x0, #0x6a8   ; STR "HOMESCREEN_GRID"
0x0002005c  bl       #0x17e20   ; CALL _L
0x00020060  mov      x29, x29
0x00020064  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020068  mov      x19, x0
0x0002006c  mov      x0, x19
0x00020070  ldp      x29, x30, [sp, #0x30]
0x00020074  ldp      x20, x19, [sp, #0x20]
0x00020078  ldp      x22, x21, [sp, #0x10]
0x0002007c  add      sp, sp, #0x40
0x00020080  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCAppBridgeAppsController tableView:willDisplayHeaderView:forSection:]  va=0x20084 size=12 types=v40@0:8@16@24q32
0x00020084  mov      x0, x3
0x00020088  mov      w1, #1
0x0002008c  b        #0x19300   ; CALL _OMCStyleHeaderFooter

=== -[OMCAppBridgeAppsController tableView:heightForHeaderInSection:]  va=0x20090 size=52 types=d32@0:8@16q24
0x00020090  stp      x29, x30, [sp, #-0x10]!
0x00020094  mov      x29, sp
0x00020098  mov      x2, x3
0x0002009c  bl       #0x5cb60   ; CALL objc_msgSend$shows:
0x000200a0  adrp     x8, #0x74000
0x000200a4  ldr      x8, [x8, #0x2c0]   ; @GOT _UITableViewAutomaticDimension
0x000200a8  ldr      d0, [x8]   ; @GOT ___objc_personality_v0
0x000200ac  cmp      w0, #0
0x000200b0  mov      x8, #0x10000000000000
0x000200b4  fmov     d1, x8
0x000200b8  fcsel    d0, d0, d1, ne
0x000200bc  ldp      x29, x30, [sp], #0x10
0x000200c0  ret      

=== -[OMCAppBridgeAppsController tableView:heightForFooterInSection:]  va=0x200c4 size=52 types=d32@0:8@16q24
0x000200c4  stp      x29, x30, [sp, #-0x10]!
0x000200c8  mov      x29, sp
0x000200cc  mov      x2, x3
0x000200d0  bl       #0x5cb60   ; CALL objc_msgSend$shows:
0x000200d4  adrp     x8, #0x74000
0x000200d8  ldr      x8, [x8, #0x2c0]   ; @GOT _UITableViewAutomaticDimension
0x000200dc  ldr      d0, [x8]   ; @GOT ___objc_personality_v0
0x000200e0  cmp      w0, #0
0x000200e4  mov      x8, #0x10000000000000
0x000200e8  fmov     d1, x8
0x000200ec  fcsel    d0, d0, d1, ne
0x000200f0  ldp      x29, x30, [sp], #0x10
0x000200f4  ret      

=== -[OMCAppBridgeAppsController tableView:willDisplayFooterView:forSection:]  va=0x200f8 size=12 types=v40@0:8@16@24q32
0x000200f8  mov      x0, x3
0x000200fc  mov      w1, #0
0x00020100  b        #0x19300   ; CALL _OMCStyleHeaderFooter

=== -[OMCAppBridgeAppsController tableView:heightForRowAtIndexPath:]  va=0x20104 size=320 types=d32@0:8@16@24
0x00020104  stp      d9, d8, [sp, #-0x40]!
0x00020108  stp      x22, x21, [sp, #0x10]
0x0002010c  stp      x20, x19, [sp, #0x20]
0x00020110  stp      x29, x30, [sp, #0x30]
0x00020114  add      x29, sp, #0x30
0x00020118  mov      x20, x3
0x0002011c  mov      x19, x2
0x00020120  mov      x21, x0
0x00020124  mov      x0, x2
0x00020128  bl       #0x55d84   ; CALL _objc_retain
0x0002012c  mov      x0, x20
0x00020130  bl       #0x55d84   ; CALL _objc_retain
0x00020134  mov      x0, x19
0x00020138  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0002013c  mov      v8.16b, v2.16b
0x00020140  mov      x0, x20
0x00020144  bl       #0x5a180   ; CALL objc_msgSend$section
0x00020148  cbz      x0, #0x201d0
0x0002014c  mov      x0, x20
0x00020150  bl       #0x5a180   ; CALL objc_msgSend$section
0x00020154  cmp      x0, #2
0x00020158  b.ne     #0x20168
0x0002015c  mov      x0, x20
0x00020160  bl       #0x59f60   ; CALL objc_msgSend$row
0x00020164  cbz      x0, #0x20214
0x00020168  mov      x0, x20
0x0002016c  bl       #0x5a180   ; CALL objc_msgSend$section
0x00020170  cmp      x0, #4
0x00020174  b.ne     #0x201a8
0x00020178  mov      x0, x20
0x0002017c  bl       #0x59f60   ; CALL objc_msgSend$row
0x00020180  cmp      x0, #1
0x00020184  b.ne     #0x201a8
0x00020188  mov      x8, #-0x3fbc000000000000
0x0002018c  fmov     d0, x8
0x00020190  fadd     d0, d8, d0
0x00020194  mov      x0, x21
0x00020198  mov      x2, #0
0x0002019c  bl       #0x58bc0   ; CALL objc_msgSend$layoutTilesIn:width:
0x000201a0  mov      v8.16b, v0.16b
0x000201a4  b        #0x2021c
0x000201a8  mov      x0, x20
0x000201ac  bl       #0x5a180   ; CALL objc_msgSend$section
0x000201b0  cmp      x0, #4
0x000201b4  b.ne     #0x2020c
0x000201b8  mov      x0, x20
0x000201bc  bl       #0x59f60   ; CALL objc_msgSend$row
0x000201c0  cmp      x0, #2
0x000201c4  b.ne     #0x2020c
0x000201c8  mov      x8, #0x404d000000000000
0x000201cc  b        #0x20218
0x000201d0  mov      x0, x19
0x000201d4  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x000201d8  mov      x8, #-0x3fb2000000000000
0x000201dc  fmov     d0, x8
0x000201e0  fadd     d0, d2, d0
0x000201e4  adrp     x8, #0x65000
0x000201e8  ldr      d1, [x8, #0x638]
0x000201ec  fmul     d0, d0, d1
0x000201f0  mov      x8, #0x4089000000000000
0x000201f4  fmov     d1, x8
0x000201f8  fdiv     d0, d0, d1
0x000201fc  frintm   d0, d0
0x00020200  fmov     d1, #20.00000000
0x00020204  fadd     d8, d0, d1
0x00020208  b        #0x2021c
0x0002020c  mov      x8, #0x404a000000000000
0x00020210  b        #0x20218
0x00020214  mov      x8, #0x4049000000000000
0x00020218  fmov     d8, x8
0x0002021c  mov      x0, x20
0x00020220  bl       #0x55d78   ; CALL _objc_release
0x00020224  mov      x0, x19
0x00020228  bl       #0x55d78   ; CALL _objc_release
0x0002022c  mov      v0.16b, v8.16b
0x00020230  ldp      x29, x30, [sp, #0x30]
0x00020234  ldp      x20, x19, [sp, #0x20]
0x00020238  ldp      x22, x21, [sp, #0x10]
0x0002023c  ldp      d9, d8, [sp], #0x40
0x00020240  ret      

=== -[OMCAppBridgeAppsController appAt:]  va=0x20244 size=244 types=@24@0:8@16
0x00020244  stp      x22, x21, [sp, #-0x30]!
0x00020248  stp      x20, x19, [sp, #0x10]
0x0002024c  stp      x29, x30, [sp, #0x20]
0x00020250  add      x29, sp, #0x20
0x00020254  mov      x19, x2
0x00020258  mov      x20, x0
0x0002025c  mov      x0, x2
0x00020260  bl       #0x55d84   ; CALL _objc_retain
0x00020264  mov      x0, x19
0x00020268  bl       #0x5a180   ; CALL objc_msgSend$section
0x0002026c  cmp      x0, #1
0x00020270  b.ne     #0x202ac
0x00020274  mov      x0, x19
0x00020278  bl       #0x59f60   ; CALL objc_msgSend$row
0x0002027c  mov      x21, x0
0x00020280  adrp     x8, #0x8e000
0x00020284  ldrsw    x22, [x8, #0xe94]
0x00020288  ldr      x0, [x20, x22]
0x0002028c  bl       #0x573c0   ; CALL objc_msgSend$count
0x00020290  cmp      x21, x0
0x00020294  b.ge     #0x202ac
0x00020298  ldr      x20, [x20, x22]
0x0002029c  mov      x0, x19
0x000202a0  bl       #0x59f60   ; CALL objc_msgSend$row
0x000202a4  mov      x2, x0
0x000202a8  b        #0x20308
0x000202ac  mov      x0, x19
0x000202b0  bl       #0x5a180   ; CALL objc_msgSend$section
0x000202b4  cmp      x0, #2
0x000202b8  b.ne     #0x202f0
0x000202bc  mov      x0, x19
0x000202c0  bl       #0x59f60   ; CALL objc_msgSend$row
0x000202c4  cmp      x0, #1
0x000202c8  b.lt     #0x202f0
0x000202cc  mov      x0, x19
0x000202d0  bl       #0x59f60   ; CALL objc_msgSend$row
0x000202d4  mov      x21, x0
0x000202d8  adrp     x8, #0x8e000
0x000202dc  ldrsw    x22, [x8, #0xe98]
0x000202e0  ldr      x0, [x20, x22]
0x000202e4  bl       #0x573c0   ; CALL objc_msgSend$count
0x000202e8  cmp      x21, x0
0x000202ec  b.le     #0x202f8
0x000202f0  mov      x20, #0
0x000202f4  b        #0x2031c
0x000202f8  ldr      x20, [x20, x22]
0x000202fc  mov      x0, x19
0x00020300  bl       #0x59f60   ; CALL objc_msgSend$row
0x00020304  sub      x2, x0, #1
0x00020308  mov      x0, x20
0x0002030c  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00020310  mov      x29, x29
0x00020314  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020318  mov      x20, x0
0x0002031c  mov      x0, x19
0x00020320  bl       #0x55d78   ; CALL _objc_release
0x00020324  mov      x0, x20
0x00020328  ldp      x29, x30, [sp, #0x20]
0x0002032c  ldp      x20, x19, [sp, #0x10]
0x00020330  ldp      x22, x21, [sp], #0x30
0x00020334  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCAppBridgeAppsController tableView:canEditRowAtIndexPath:]  va=0x20338 size=56 types=B32@0:8@16@24
0x00020338  stp      x20, x19, [sp, #-0x20]!
0x0002033c  stp      x29, x30, [sp, #0x10]
0x00020340  add      x29, sp, #0x10
0x00020344  mov      x2, x3
0x00020348  bl       #0x563c0   ; CALL objc_msgSend$appAt:
0x0002034c  mov      x29, x29
0x00020350  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020354  cmp      x0, #0
0x00020358  cset     w19, ne
0x0002035c  bl       #0x55d78   ; CALL _objc_release
0x00020360  mov      x0, x19
0x00020364  ldp      x29, x30, [sp, #0x10]
0x00020368  ldp      x20, x19, [sp], #0x20
0x0002036c  ret      

=== -[OMCAppBridgeAppsController tableView:canMoveRowAtIndexPath:]  va=0x20370 size=8 types=B32@0:8@16@24
0x00020370  mov      w0, #0
0x00020374  ret      

=== -[OMCAppBridgeAppsController tableView:shouldIndentWhileEditingRowAtIndexPath:]  va=0x20378 size=56 types=B32@0:8@16@24
0x00020378  stp      x20, x19, [sp, #-0x20]!
0x0002037c  stp      x29, x30, [sp, #0x10]
0x00020380  add      x29, sp, #0x10
0x00020384  mov      x2, x3
0x00020388  bl       #0x563c0   ; CALL objc_msgSend$appAt:
0x0002038c  mov      x29, x29
0x00020390  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020394  cmp      x0, #0
0x00020398  cset     w19, ne
0x0002039c  bl       #0x55d78   ; CALL _objc_release
0x000203a0  mov      x0, x19
0x000203a4  ldp      x29, x30, [sp, #0x10]
0x000203a8  ldp      x20, x19, [sp], #0x20
0x000203ac  ret      

=== -[OMCAppBridgeAppsController tableView:editingStyleForRowAtIndexPath:]  va=0x203b0 size=144 types=q32@0:8@16@24
0x000203b0  stp      x22, x21, [sp, #-0x30]!
0x000203b4  stp      x20, x19, [sp, #0x10]
0x000203b8  stp      x29, x30, [sp, #0x20]
0x000203bc  add      x29, sp, #0x20
0x000203c0  mov      x19, x3
0x000203c4  mov      x21, x0
0x000203c8  mov      x0, x3
0x000203cc  bl       #0x55d84   ; CALL _objc_retain
0x000203d0  mov      x0, x21
0x000203d4  mov      x2, x19
0x000203d8  bl       #0x563c0   ; CALL objc_msgSend$appAt:
0x000203dc  mov      x29, x29
0x000203e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000203e4  mov      x20, x0
0x000203e8  cbz      x0, #0x20404
0x000203ec  mov      x0, x19
0x000203f0  bl       #0x5a180   ; CALL objc_msgSend$section
0x000203f4  cmp      x0, #2
0x000203f8  b.ne     #0x2040c
0x000203fc  mov      w21, #2
0x00020400  b        #0x2041c
0x00020404  mov      x21, #0
0x00020408  b        #0x2041c
0x0002040c  mov      x0, x21
0x00020410  mov      x2, x20
0x00020414  bl       #0x59d60   ; CALL objc_msgSend$removable:
0x00020418  mov      w21, w0
0x0002041c  mov      x0, x20
0x00020420  bl       #0x55d78   ; CALL _objc_release
0x00020424  mov      x0, x19
0x00020428  bl       #0x55d78   ; CALL _objc_release
0x0002042c  mov      x0, x21
0x00020430  ldp      x29, x30, [sp, #0x20]
0x00020434  ldp      x20, x19, [sp, #0x10]
0x00020438  ldp      x22, x21, [sp], #0x30
0x0002043c  ret      

=== -[OMCAppBridgeAppsController tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:]  va=0x20440 size=12 types=@32@0:8@16@24
0x00020440  adrp     x0, #0x79000
0x00020444  add      x0, x0, #0x6c8   ; STR "APPS_REMOVE"
0x00020448  b        #0x17e20   ; CALL _L

=== -[OMCAppBridgeAppsController tableView:commitEditingStyle:forRowAtIndexPath:]  va=0x2044c size=352 types=v40@0:8@16q24@32
0x0002044c  stp      x24, x23, [sp, #-0x40]!
0x00020450  stp      x22, x21, [sp, #0x10]
0x00020454  stp      x20, x19, [sp, #0x20]
0x00020458  stp      x29, x30, [sp, #0x30]
0x0002045c  add      x29, sp, #0x30
0x00020460  mov      x2, x4
0x00020464  mov      x22, x3
0x00020468  mov      x20, x0
0x0002046c  bl       #0x563c0   ; CALL objc_msgSend$appAt:
0x00020470  mov      x29, x29
0x00020474  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020478  mov      x19, x0
0x0002047c  cbz      x0, #0x20594
0x00020480  adrp     x2, #0x75000
0x00020484  add      x2, x2, #0x3e8   ; STR "id"
0x00020488  mov      x0, x19
0x0002048c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00020490  mov      x29, x29
0x00020494  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020498  mov      x21, x0
0x0002049c  adrp     x2, #0x79000
0x000204a0  add      x2, x2, #0x328   ; STR "carplay"
0x000204a4  mov      x0, x19
0x000204a8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000204ac  mov      x29, x29
0x000204b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000204b4  mov      x23, x0
0x000204b8  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x000204bc  mov      x24, x0
0x000204c0  mov      x0, x23
0x000204c4  bl       #0x55d78   ; CALL _objc_release
0x000204c8  cbz      w24, #0x2050c
0x000204cc  cmp      x22, #2
0x000204d0  b.ne     #0x20524
0x000204d4  adrp     x8, #0x8e000
0x000204d8  ldrsw    x8, [x8, #0xe78]
0x000204dc  ldr      x0, [x20, x8]
0x000204e0  mov      x2, x21
0x000204e4  bl       #0x59e40   ; CALL objc_msgSend$removeObject:
0x000204e8  adrp     x8, #0x8e000
0x000204ec  ldrsw    x8, [x8, #0xe68]
0x000204f0  ldr      x0, [x20, x8]
0x000204f4  mov      x2, x21
0x000204f8  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x000204fc  cbz      w0, #0x20560
0x00020500  adrp     x8, #0x8e000
0x00020504  ldrsw    x8, [x8, #0xe7c]
0x00020508  b        #0x20554
0x0002050c  adrp     x8, #0x8e000
0x00020510  ldrsw    x8, [x8, #0xe74]
0x00020514  ldr      x0, [x20, x8]
0x00020518  cmp      x22, #2
0x0002051c  b.ne     #0x20540
0x00020520  b        #0x20558
0x00020524  adrp     x8, #0x8e000
0x00020528  ldrsw    x22, [x8, #0xe7c]
0x0002052c  ldr      x0, [x20, x22]
0x00020530  mov      x2, x21
0x00020534  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x00020538  cbz      w0, #0x2054c
0x0002053c  ldr      x0, [x20, x22]
0x00020540  mov      x2, x21
0x00020544  bl       #0x59e40   ; CALL objc_msgSend$removeObject:
0x00020548  b        #0x20560
0x0002054c  adrp     x8, #0x8e000
0x00020550  ldrsw    x8, [x8, #0xe78]
0x00020554  ldr      x0, [x20, x8]
0x00020558  mov      x2, x21
0x0002055c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00020560  adrp     x8, #0x8e000
0x00020564  ldr      x0, [x8, #0x938]   ; @CLASS UISelectionFeedbackGenerator
0x00020568  bl       #0x55d60   ; CALL _objc_opt_new
0x0002056c  mov      x22, x0
0x00020570  bl       #0x5a200   ; CALL objc_msgSend$selectionChanged
0x00020574  mov      x0, x22
0x00020578  bl       #0x55d78   ; CALL _objc_release
0x0002057c  mov      x0, x20
0x00020580  bl       #0x5d3a0   ; CALL objc_msgSend$storeChoices
0x00020584  mov      x0, x20
0x00020588  bl       #0x59cc0   ; CALL objc_msgSend$reloadLists
0x0002058c  mov      x0, x21
0x00020590  bl       #0x55d78   ; CALL _objc_release
0x00020594  mov      x0, x19
0x00020598  ldp      x29, x30, [sp, #0x30]
0x0002059c  ldp      x20, x19, [sp, #0x20]
0x000205a0  ldp      x22, x21, [sp, #0x10]
0x000205a4  ldp      x24, x23, [sp], #0x40
0x000205a8  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController cellWithId:inTable:]  va=0x205ac size=312 types=@32@0:8@16@24
0x000205ac  stp      x22, x21, [sp, #-0x30]!
0x000205b0  stp      x20, x19, [sp, #0x10]
0x000205b4  stp      x29, x30, [sp, #0x20]
0x000205b8  add      x29, sp, #0x20
0x000205bc  mov      x20, x3
0x000205c0  mov      x19, x2
0x000205c4  mov      x0, x2
0x000205c8  bl       #0x55d84   ; CALL _objc_retain
0x000205cc  mov      x0, x20
0x000205d0  mov      x2, x19
0x000205d4  bl       #0x576e0   ; CALL objc_msgSend$dequeueReusableCellWithIdentifier:
0x000205d8  mov      x29, x29
0x000205dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000205e0  mov      x20, x0
0x000205e4  cbnz     x0, #0x20604
0x000205e8  adrp     x8, #0x8e000
0x000205ec  ldr      x0, [x8, #0x908]   ; @CLASS UITableViewCell
0x000205f0  bl       #0x55c7c   ; CALL _objc_alloc
0x000205f4  mov      w2, #3
0x000205f8  mov      x3, x19
0x000205fc  bl       #0x585c0   ; CALL objc_msgSend$initWithStyle:reuseIdentifier:
0x00020600  mov      x20, x0
0x00020604  mov      x0, x20
0x00020608  bl       #0x19168   ; CALL _OMCStyleCell
0x0002060c  mov      x0, x20
0x00020610  mov      x2, #0
0x00020614  bl       #0x5a2c0   ; CALL objc_msgSend$setAccessoryView:
0x00020618  mov      x0, x20
0x0002061c  mov      x2, #0
0x00020620  bl       #0x5ad80   ; CALL objc_msgSend$setEditingAccessoryView:
0x00020624  mov      x0, x20
0x00020628  mov      x2, #0
0x0002062c  bl       #0x5a2a0   ; CALL objc_msgSend$setAccessoryType:
0x00020630  mov      x0, x20
0x00020634  mov      x2, #0
0x00020638  bl       #0x5bfa0   ; CALL objc_msgSend$setSelectionStyle:
0x0002063c  mov      x0, x20
0x00020640  bl       #0x58120   ; CALL objc_msgSend$imageView
0x00020644  mov      x29, x29
0x00020648  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002064c  mov      x21, x0
0x00020650  mov      x2, #0
0x00020654  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00020658  mov      x0, x21
0x0002065c  bl       #0x55d78   ; CALL _objc_release
0x00020660  mov      x0, x20
0x00020664  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x00020668  mov      x29, x29
0x0002066c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020670  mov      x21, x0
0x00020674  mov      x2, #0
0x00020678  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0002067c  mov      x0, x21
0x00020680  bl       #0x55d78   ; CALL _objc_release
0x00020684  adrp     x8, #0x8e000
0x00020688  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0002068c  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x00020690  mov      x29, x29
0x00020694  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020698  mov      x21, x0
0x0002069c  mov      x0, x20
0x000206a0  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x000206a4  mov      x29, x29
0x000206a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000206ac  mov      x22, x0
0x000206b0  mov      x2, x21
0x000206b4  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x000206b8  mov      x0, x22
0x000206bc  bl       #0x55d78   ; CALL _objc_release
0x000206c0  mov      x0, x21
0x000206c4  bl       #0x55d78   ; CALL _objc_release
0x000206c8  mov      x0, x19
0x000206cc  bl       #0x55d78   ; CALL _objc_release
0x000206d0  mov      x0, x20
0x000206d4  ldp      x29, x30, [sp, #0x20]
0x000206d8  ldp      x20, x19, [sp, #0x10]
0x000206dc  ldp      x22, x21, [sp], #0x30
0x000206e0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCAppBridgeAppsController tableView:cellForRowAtIndexPath:]  va=0x206e4 size=2864 types=@32@0:8@16@24
0x000206e4  sub      sp, sp, #0x80
0x000206e8  stp      d9, d8, [sp, #0x10]
0x000206ec  stp      x28, x27, [sp, #0x20]
0x000206f0  stp      x26, x25, [sp, #0x30]
0x000206f4  stp      x24, x23, [sp, #0x40]
0x000206f8  stp      x22, x21, [sp, #0x50]
0x000206fc  stp      x20, x19, [sp, #0x60]
0x00020700  stp      x29, x30, [sp, #0x70]
0x00020704  add      x29, sp, #0x70
0x00020708  mov      x20, x3
0x0002070c  mov      x19, x2
0x00020710  mov      x22, x0
0x00020714  mov      x0, x2
0x00020718  bl       #0x55d84   ; CALL _objc_retain
0x0002071c  mov      x0, x20
0x00020720  bl       #0x55d84   ; CALL _objc_retain
0x00020724  mov      x0, x20
0x00020728  bl       #0x59f60   ; CALL objc_msgSend$row
0x0002072c  cbnz     x0, #0x20768
0x00020730  mov      x0, x20
0x00020734  bl       #0x5a180   ; CALL objc_msgSend$section
0x00020738  cmp      x0, #4
0x0002073c  b.ne     #0x20768
0x00020740  mov      x0, x20
0x00020744  bl       #0x5a180   ; CALL objc_msgSend$section
0x00020748  mov      x2, x0
0x0002074c  mov      x0, x22
0x00020750  mov      x3, x19
0x00020754  bl       #0x57f00   ; CALL objc_msgSend$headerCellFor:inTable:
0x00020758  mov      x29, x29
0x0002075c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020760  mov      x21, x0
0x00020764  b        #0x211dc
0x00020768  mov      x0, x19
0x0002076c  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00020770  mov      x8, #-0x3fbc000000000000
0x00020774  fmov     d0, x8
0x00020778  fadd     d8, d2, d0
0x0002077c  mov      x0, x20
0x00020780  bl       #0x5a180   ; CALL objc_msgSend$section
0x00020784  cmp      x0, #1
0x00020788  b.gt     #0x207b4
0x0002078c  cbz      x0, #0x209d8
0x00020790  cmp      x0, #1
0x00020794  b.ne     #0x20964
0x00020798  mov      x0, x22
0x0002079c  mov      x2, x20
0x000207a0  bl       #0x563c0   ; CALL objc_msgSend$appAt:
0x000207a4  mov      x29, x29
0x000207a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000207ac  mov      x23, x0
0x000207b0  b        #0x20b88
0x000207b4  cmp      x0, #2
0x000207b8  b.eq     #0x20b60
0x000207bc  cmp      x0, #3
0x000207c0  b.ne     #0x20964
0x000207c4  mov      x0, x20
0x000207c8  bl       #0x59f60   ; CALL objc_msgSend$row
0x000207cc  mov      x2, x0
0x000207d0  adrp     x0, #0x7f000
0x000207d4  add      x0, x0, #0xa38
0x000207d8  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000207dc  mov      x29, x29
0x000207e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000207e4  mov      x23, x0
0x000207e8  adrp     x8, #0x8e000
0x000207ec  ldr      x21, [x8, #0x958]   ; @CLASS NSString
0x000207f0  mov      x0, x20
0x000207f4  bl       #0x59f60   ; CALL objc_msgSend$row
0x000207f8  str      x0, [sp]
0x000207fc  adrp     x2, #0x79000
0x00020800  add      x2, x2, #0x868   ; STR "grid%ld"
0x00020804  mov      x0, x21
0x00020808  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0002080c  mov      x29, x29
0x00020810  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020814  mov      x24, x0
0x00020818  mov      x0, x22
0x0002081c  mov      x2, x24
0x00020820  mov      x3, x19
0x00020824  bl       #0x56d20   ; CALL objc_msgSend$cellWithId:inTable:
0x00020828  mov      x29, x29
0x0002082c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020830  mov      x21, x0
0x00020834  mov      x0, x24
0x00020838  bl       #0x55d78   ; CALL _objc_release
0x0002083c  mov      x0, x23
0x00020840  mov      x2, #0
0x00020844  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00020848  mov      x29, x29
0x0002084c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020850  mov      x24, x0
0x00020854  bl       #0x17e20   ; CALL _L
0x00020858  mov      x29, x29
0x0002085c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020860  mov      x25, x0
0x00020864  mov      x0, x21
0x00020868  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x0002086c  mov      x29, x29
0x00020870  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020874  mov      x26, x0
0x00020878  mov      x2, x25
0x0002087c  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00020880  mov      x0, x26
0x00020884  bl       #0x55d78   ; CALL _objc_release
0x00020888  mov      x0, x25
0x0002088c  bl       #0x55d78   ; CALL _objc_release
0x00020890  mov      x0, x24
0x00020894  bl       #0x55d78   ; CALL _objc_release
0x00020898  mov      x0, x23
0x0002089c  mov      w2, #1
0x000208a0  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000208a4  mov      x29, x29
0x000208a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000208ac  mov      x24, x0
0x000208b0  mov      x0, x23
0x000208b4  mov      w2, #2
0x000208b8  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000208bc  mov      x29, x29
0x000208c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000208c4  mov      x25, x0
0x000208c8  bl       #0x18080   ; CALL _OMCColorFromHex
0x000208cc  mov      x29, x29
0x000208d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000208d4  mov      x26, x0
0x000208d8  mov      x0, x24
0x000208dc  mov      x1, x26
0x000208e0  bl       #0x18144   ; CALL _OMCIcon
0x000208e4  mov      x29, x29
0x000208e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000208ec  mov      x27, x0
0x000208f0  mov      x0, x21
0x000208f4  bl       #0x58120   ; CALL objc_msgSend$imageView
0x000208f8  mov      x29, x29
0x000208fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020900  mov      x28, x0
0x00020904  mov      x2, x27
0x00020908  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x0002090c  mov      x0, x28
0x00020910  bl       #0x55d78   ; CALL _objc_release
0x00020914  mov      x0, x27
0x00020918  bl       #0x55d78   ; CALL _objc_release
0x0002091c  mov      x0, x26
0x00020920  bl       #0x55d78   ; CALL _objc_release
0x00020924  mov      x0, x25
0x00020928  bl       #0x55d78   ; CALL _objc_release
0x0002092c  mov      x0, x24
0x00020930  bl       #0x55d78   ; CALL _objc_release
0x00020934  mov      x0, x20
0x00020938  bl       #0x59f60   ; CALL objc_msgSend$row
0x0002093c  cmp      x0, #2
0x00020940  b.eq     #0x20fe4
0x00020944  cmp      x0, #1
0x00020948  b.eq     #0x20fc0
0x0002094c  cbnz     x0, #0x21018
0x00020950  adrp     x2, #0x79000
0x00020954  add      x2, x2, #0x388   ; STR "homeScreenGridCols"
0x00020958  adrp     x3, #0x7f000
0x0002095c  add      x3, x3, #0xa50
0x00020960  b        #0x20fd0
0x00020964  mov      x0, x20
0x00020968  bl       #0x59f60   ; CALL objc_msgSend$row
0x0002096c  adrp     x8, #0x79000
0x00020970  add      x8, x8, #0x8c8   ; STR "wall"
0x00020974  adrp     x9, #0x79000
0x00020978  add      x9, x9, #0x8a8   ; STR "tiles"
0x0002097c  cmp      x0, #1
0x00020980  csel     x2, x9, x8, eq
0x00020984  mov      x0, x22
0x00020988  mov      x3, x19
0x0002098c  bl       #0x56d20   ; CALL objc_msgSend$cellWithId:inTable:
0x00020990  mov      x29, x29
0x00020994  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020998  mov      x21, x0
0x0002099c  mov      x0, x20
0x000209a0  bl       #0x59f60   ; CALL objc_msgSend$row
0x000209a4  cmp      x0, #1
0x000209a8  b.ne     #0x20ba8
0x000209ac  mov      x0, x22
0x000209b0  mov      x2, x21
0x000209b4  bl       #0x56a80   ; CALL objc_msgSend$boxInCell:
0x000209b8  mov      x29, x29
0x000209bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000209c0  mov      x23, x0
0x000209c4  mov      x0, x22
0x000209c8  mov      x2, x23
0x000209cc  mov      v0.16b, v8.16b
0x000209d0  bl       #0x58bc0   ; CALL objc_msgSend$layoutTilesIn:width:
0x000209d4  b        #0x211c4
0x000209d8  adrp     x2, #0x79000
0x000209dc  add      x2, x2, #0x6e8   ; STR "preview"
0x000209e0  mov      x0, x22
0x000209e4  mov      x3, x19
0x000209e8  bl       #0x56d20   ; CALL objc_msgSend$cellWithId:inTable:
0x000209ec  mov      x29, x29
0x000209f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000209f4  mov      x21, x0
0x000209f8  mov      x0, x22
0x000209fc  bl       #0x599e0   ; CALL objc_msgSend$preview
0x00020a00  mov      x29, x29
0x00020a04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020a08  cbz      x0, #0x20a6c
0x00020a0c  mov      x23, x0
0x00020a10  mov      x0, x22
0x00020a14  bl       #0x599e0   ; CALL objc_msgSend$preview
0x00020a18  mov      x29, x29
0x00020a1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020a20  mov      x24, x0
0x00020a24  bl       #0x5d740   ; CALL objc_msgSend$superview
0x00020a28  mov      x29, x29
0x00020a2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020a30  mov      x25, x0
0x00020a34  mov      x0, x21
0x00020a38  bl       #0x57280   ; CALL objc_msgSend$contentView
0x00020a3c  mov      x29, x29
0x00020a40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020a44  mov      x26, x0
0x00020a48  bl       #0x55d78   ; CALL _objc_release
0x00020a4c  mov      x0, x25
0x00020a50  bl       #0x55d78   ; CALL _objc_release
0x00020a54  mov      x0, x24
0x00020a58  bl       #0x55d78   ; CALL _objc_release
0x00020a5c  mov      x0, x23
0x00020a60  bl       #0x55d78   ; CALL _objc_release
0x00020a64  cmp      x25, x26
0x00020a68  b.eq     #0x20af4
0x00020a6c  mov      x0, x22
0x00020a70  bl       #0x599e0   ; CALL objc_msgSend$preview
0x00020a74  mov      x29, x29
0x00020a78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020a7c  mov      x23, x0
0x00020a80  bl       #0x59e00   ; CALL objc_msgSend$removeFromSuperview
0x00020a84  mov      x0, x23
0x00020a88  bl       #0x55d78   ; CALL _objc_release
0x00020a8c  adrp     x8, #0x8e000
0x00020a90  ldr      x0, [x8, #0xb28]   ; @CLASS OMCHSPreview
0x00020a94  bl       #0x55d60   ; CALL _objc_opt_new
0x00020a98  mov      x23, x0
0x00020a9c  mov      x0, x22
0x00020aa0  mov      x2, x23
0x00020aa4  bl       #0x5bcc0   ; CALL objc_msgSend$setPreview:
0x00020aa8  mov      x0, x23
0x00020aac  bl       #0x55d78   ; CALL _objc_release
0x00020ab0  mov      x0, x21
0x00020ab4  bl       #0x57280   ; CALL objc_msgSend$contentView
0x00020ab8  mov      x29, x29
0x00020abc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020ac0  mov      x23, x0
0x00020ac4  mov      x0, x22
0x00020ac8  bl       #0x599e0   ; CALL objc_msgSend$preview
0x00020acc  mov      x29, x29
0x00020ad0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020ad4  mov      x24, x0
0x00020ad8  mov      x0, x23
0x00020adc  mov      x2, x24
0x00020ae0  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00020ae4  mov      x0, x24
0x00020ae8  bl       #0x55d78   ; CALL _objc_release
0x00020aec  mov      x0, x23
0x00020af0  bl       #0x55d78   ; CALL _objc_release
0x00020af4  mov      x0, x19
0x00020af8  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00020afc  mov      x8, #-0x3fb2000000000000
0x00020b00  fmov     d0, x8
0x00020b04  fadd     d8, d2, d0
0x00020b08  adrp     x8, #0x65000
0x00020b0c  ldr      d0, [x8, #0x638]
0x00020b10  fmul     d0, d8, d0
0x00020b14  mov      x8, #0x4089000000000000
0x00020b18  fmov     d1, x8
0x00020b1c  fdiv     d0, d0, d1
0x00020b20  frintm   d9, d0
0x00020b24  mov      x0, x22
0x00020b28  bl       #0x599e0   ; CALL objc_msgSend$preview
0x00020b2c  mov      x29, x29
0x00020b30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020b34  mov      x23, x0
0x00020b38  fmov     d0, #10.00000000
0x00020b3c  fmov     d1, #10.00000000
0x00020b40  mov      v2.16b, v8.16b
0x00020b44  mov      v3.16b, v9.16b
0x00020b48  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00020b4c  mov      x0, x23
0x00020b50  bl       #0x55d78   ; CALL _objc_release
0x00020b54  mov      x0, x22
0x00020b58  bl       #0x5dd80   ; CALL objc_msgSend$updatePreview
0x00020b5c  b        #0x211dc
0x00020b60  mov      x0, x20
0x00020b64  bl       #0x59f60   ; CALL objc_msgSend$row
0x00020b68  cbz      x0, #0x20dbc
0x00020b6c  mov      x0, x22
0x00020b70  mov      x2, x20
0x00020b74  bl       #0x563c0   ; CALL objc_msgSend$appAt:
0x00020b78  mov      x29, x29
0x00020b7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020b80  mov      x23, x0
0x00020b84  cbz      x0, #0x210bc
0x00020b88  mov      x0, x22
0x00020b8c  mov      x2, x23
0x00020b90  mov      x3, x19
0x00020b94  bl       #0x563e0   ; CALL objc_msgSend$appCell:inTable:
0x00020b98  mov      x29, x29
0x00020b9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020ba0  mov      x21, x0
0x00020ba4  b        #0x210b4
0x00020ba8  mov      x0, x20
0x00020bac  bl       #0x59f60   ; CALL objc_msgSend$row
0x00020bb0  cmp      x0, #2
0x00020bb4  b.ne     #0x20eac
0x00020bb8  mov      x0, x21
0x00020bbc  bl       #0x57280   ; CALL objc_msgSend$contentView
0x00020bc0  mov      x29, x29
0x00020bc4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020bc8  mov      x24, x0
0x00020bcc  mov      w2, #0x50
0x00020bd0  bl       #0x5df80   ; CALL objc_msgSend$viewWithTag:
0x00020bd4  mov      x29, x29
0x00020bd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020bdc  mov      x23, x0
0x00020be0  mov      x0, x24
0x00020be4  bl       #0x55d78   ; CALL _objc_release
0x00020be8  cbnz     x23, #0x20d58
0x00020bec  adrp     x8, #0x8e000
0x00020bf0  ldr      x0, [x8, #0xa50]   ; @CLASS UIButton
0x00020bf4  mov      w2, #1
0x00020bf8  bl       #0x56b80   ; CALL objc_msgSend$buttonWithType:
0x00020bfc  mov      x29, x29
0x00020c00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020c04  mov      x23, x0
0x00020c08  mov      w2, #0x50
0x00020c0c  bl       #0x5c480   ; CALL objc_msgSend$setTag:
0x00020c10  adrp     x8, #0x8e000
0x00020c14  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x00020c18  adrp     x8, #0x74000
0x00020c1c  ldr      x8, [x8, #0x260]   ; @GOT _UIFontWeightSemibold
0x00020c20  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x00020c24  fmov     d0, #15.00000000
0x00020c28  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x00020c2c  mov      x29, x29
0x00020c30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020c34  mov      x24, x0
0x00020c38  mov      x0, x23
0x00020c3c  bl       #0x5db80   ; CALL objc_msgSend$titleLabel
0x00020c40  mov      x29, x29
0x00020c44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020c48  mov      x25, x0
0x00020c4c  mov      x2, x24
0x00020c50  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00020c54  mov      x0, x25
0x00020c58  bl       #0x55d78   ; CALL _objc_release
0x00020c5c  mov      x0, x24
0x00020c60  bl       #0x55d78   ; CALL _objc_release
0x00020c64  adrp     x25, #0x8e000
0x00020c68  ldr      x0, [x25, #0x910]   ; @CLASS UIColor
0x00020c6c  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x00020c70  mov      x29, x29
0x00020c74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020c78  mov      x24, x0
0x00020c7c  mov      x0, x23
0x00020c80  mov      x2, x24
0x00020c84  mov      x3, #0
0x00020c88  bl       #0x5c620   ; CALL objc_msgSend$setTitleColor:forState:
0x00020c8c  mov      x0, x24
0x00020c90  bl       #0x55d78   ; CALL _objc_release
0x00020c94  ldr      x0, [x25, #0x910]   ; @CLASS UIColor
0x00020c98  adrp     x8, #0x65000
0x00020c9c  ldr      d1, [x8, #0x5f0]
0x00020ca0  fmov     d0, #0.50000000
0x00020ca4  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x00020ca8  mov      x29, x29
0x00020cac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020cb0  mov      x24, x0
0x00020cb4  mov      x0, x23
0x00020cb8  mov      x2, x24
0x00020cbc  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x00020cc0  mov      x0, x24
0x00020cc4  bl       #0x55d78   ; CALL _objc_release
0x00020cc8  mov      x0, x23
0x00020ccc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00020cd0  mov      x29, x29
0x00020cd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020cd8  mov      x24, x0
0x00020cdc  fmov     d0, #11.00000000
0x00020ce0  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x00020ce4  mov      x0, x24
0x00020ce8  bl       #0x55d78   ; CALL _objc_release
0x00020cec  adrp     x8, #0x74000
0x00020cf0  ldr      x8, [x8, #0x648]   ; @GOT _kCACornerCurveContinuous
0x00020cf4  ldr      x24, [x8]   ; @GOT ___objc_personality_v0
0x00020cf8  mov      x0, x23
0x00020cfc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00020d00  mov      x29, x29
0x00020d04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020d08  mov      x25, x0
0x00020d0c  mov      x2, x24
0x00020d10  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x00020d14  mov      x0, x25
0x00020d18  bl       #0x55d78   ; CALL _objc_release
0x00020d1c  adrp     x8, #0x8b000
0x00020d20  ldr      x3, [x8, #0xe70]   ; @SEL "pickPhoto"
0x00020d24  mov      x0, x23
0x00020d28  mov      x2, x22
0x00020d2c  mov      w4, #0x40
0x00020d30  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x00020d34  mov      x0, x21
0x00020d38  bl       #0x57280   ; CALL objc_msgSend$contentView
0x00020d3c  mov      x29, x29
0x00020d40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020d44  mov      x22, x0
0x00020d48  mov      x2, x23
0x00020d4c  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00020d50  mov      x0, x22
0x00020d54  bl       #0x55d78   ; CALL _objc_release
0x00020d58  adrp     x0, #0x79000
0x00020d5c  add      x0, x0, #0x8e8   ; STR "APPS_FROM_PHOTOS"
0x00020d60  bl       #0x17e20   ; CALL _L
0x00020d64  mov      x29, x29
0x00020d68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020d6c  mov      x22, x0
0x00020d70  mov      x0, x23
0x00020d74  mov      x2, x22
0x00020d78  mov      x3, #0
0x00020d7c  bl       #0x5c600   ; CALL objc_msgSend$setTitle:forState:
0x00020d80  mov      x0, x22
0x00020d84  bl       #0x55d78   ; CALL _objc_release
0x00020d88  fmov     d0, #-24.00000000
0x00020d8c  fadd     d2, d8, d0
0x00020d90  mov      x8, #0x4045000000000000
0x00020d94  fmov     d3, x8
0x00020d98  fmov     d0, #12.00000000
0x00020d9c  fmov     d1, #4.00000000
0x00020da0  mov      x0, x23
0x00020da4  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00020da8  mov      x0, x21
0x00020dac  bl       #0x55d84   ; CALL _objc_retain
0x00020db0  mov      x0, x23
0x00020db4  bl       #0x55d78   ; CALL _objc_release
0x00020db8  b        #0x211d4
0x00020dbc  adrp     x2, #0x79000
0x00020dc0  add      x2, x2, #0x708   ; STR "tools"
0x00020dc4  mov      x0, x22
0x00020dc8  mov      x3, x19
0x00020dcc  bl       #0x56d20   ; CALL objc_msgSend$cellWithId:inTable:
0x00020dd0  mov      x29, x29
0x00020dd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020dd8  mov      x21, x0
0x00020ddc  mov      x0, x22
0x00020de0  mov      x2, x21
0x00020de4  bl       #0x56a80   ; CALL objc_msgSend$boxInCell:
0x00020de8  mov      x29, x29
0x00020dec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020df0  mov      x23, x0
0x00020df4  mov      w2, #2
0x00020df8  bl       #0x5df80   ; CALL objc_msgSend$viewWithTag:
0x00020dfc  mov      x29, x29
0x00020e00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020e04  mov      x24, x0
0x00020e08  cbnz     x0, #0x20e74
0x00020e0c  adrp     x8, #0x8e000
0x00020e10  ldr      x0, [x8, #0xb30]   ; @CLASS UISearchBar
0x00020e14  bl       #0x55d60   ; CALL _objc_opt_new
0x00020e18  mov      x24, x0
0x00020e1c  mov      w2, #2
0x00020e20  bl       #0x5c480   ; CALL objc_msgSend$setTag:
0x00020e24  mov      x0, x24
0x00020e28  mov      w2, #2
0x00020e2c  bl       #0x5bf20   ; CALL objc_msgSend$setSearchBarStyle:
0x00020e30  adrp     x0, #0x79000
0x00020e34  add      x0, x0, #0x728   ; STR "APPBRIDGE_APPS_SEARCH"
0x00020e38  bl       #0x17e20   ; CALL _L
0x00020e3c  mov      x29, x29
0x00020e40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020e44  mov      x25, x0
0x00020e48  mov      x0, x24
0x00020e4c  mov      x2, x25
0x00020e50  bl       #0x5bbc0   ; CALL objc_msgSend$setPlaceholder:
0x00020e54  mov      x0, x25
0x00020e58  bl       #0x55d78   ; CALL _objc_release
0x00020e5c  mov      x0, x24
0x00020e60  mov      x2, x22
0x00020e64  bl       #0x5aca0   ; CALL objc_msgSend$setDelegate:
0x00020e68  mov      x0, x23
0x00020e6c  mov      x2, x24
0x00020e70  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00020e74  adrp     x8, #0x8e000
0x00020e78  ldrsw    x8, [x8, #0xe90]
0x00020e7c  ldr      x2, [x22, x8]
0x00020e80  mov      x0, x24
0x00020e84  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00020e88  fmov     d0, #-16.00000000
0x00020e8c  fadd     d2, d8, d0
0x00020e90  mov      x8, #0x4046000000000000
0x00020e94  fmov     d3, x8
0x00020e98  fmov     d0, #8.00000000
0x00020e9c  fmov     d1, #3.00000000
0x00020ea0  mov      x0, x24
0x00020ea4  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00020ea8  b        #0x210ac
0x00020eac  mov      x0, x20
0x00020eb0  bl       #0x59f60   ; CALL objc_msgSend$row
0x00020eb4  mov      x23, x0
0x00020eb8  adrp     x8, #0x79000
0x00020ebc  add      x8, x8, #0x928   ; STR "HOMESCREEN_DIM"
0x00020ec0  adrp     x9, #0x79000
0x00020ec4  add      x9, x9, #0x908   ; STR "HOMESCREEN_BLUR"
0x00020ec8  cmp      x0, #3
0x00020ecc  csel     x0, x9, x8, eq
0x00020ed0  adrp     x8, #0x79000
0x00020ed4  add      x8, x8, #0x968   ; STR "moon.fill"
0x00020ed8  adrp     x9, #0x79000
0x00020edc  add      x9, x9, #0x948   ; STR "drop.fill"
0x00020ee0  csel     x24, x9, x8, eq
0x00020ee4  adrp     x8, #0x79000
0x00020ee8  add      x8, x8, #0x988   ; STR "#4A4F80"
0x00020eec  adrp     x9, #0x78000
0x00020ef0  add      x9, x9, #0xf08   ; STR "#5AB8FF"
0x00020ef4  csel     x25, x9, x8, eq
0x00020ef8  bl       #0x17e20   ; CALL _L
0x00020efc  mov      x29, x29
0x00020f00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020f04  mov      x26, x0
0x00020f08  mov      x0, x21
0x00020f0c  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00020f10  mov      x29, x29
0x00020f14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020f18  mov      x27, x0
0x00020f1c  mov      x2, x26
0x00020f20  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00020f24  mov      x0, x27
0x00020f28  bl       #0x55d78   ; CALL _objc_release
0x00020f2c  mov      x0, x26
0x00020f30  bl       #0x55d78   ; CALL _objc_release
0x00020f34  mov      x0, x25
0x00020f38  bl       #0x18080   ; CALL _OMCColorFromHex
0x00020f3c  mov      x29, x29
0x00020f40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020f44  mov      x25, x0
0x00020f48  mov      x0, x24
0x00020f4c  mov      x1, x25
0x00020f50  bl       #0x18144   ; CALL _OMCIcon
0x00020f54  mov      x29, x29
0x00020f58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020f5c  mov      x24, x0
0x00020f60  mov      x0, x21
0x00020f64  bl       #0x58120   ; CALL objc_msgSend$imageView
0x00020f68  mov      x29, x29
0x00020f6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020f70  mov      x26, x0
0x00020f74  mov      x2, x24
0x00020f78  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00020f7c  mov      x0, x26
0x00020f80  bl       #0x55d78   ; CALL _objc_release
0x00020f84  mov      x0, x24
0x00020f88  bl       #0x55d78   ; CALL _objc_release
0x00020f8c  mov      x0, x25
0x00020f90  bl       #0x55d78   ; CALL _objc_release
0x00020f94  cmp      x23, #3
0x00020f98  b.ne     #0x21184
0x00020f9c  adrp     x2, #0x79000
0x00020fa0  add      x2, x2, #0x408   ; STR "homeScreenBlur"
0x00020fa4  adrp     x6, #0x75000
0x00020fa8  add      x6, x6, #0xd28
0x00020fac  mov      x0, x22
0x00020fb0  mov      x3, #0
0x00020fb4  mov      w4, #0x1e
0x00020fb8  mov      x5, #0
0x00020fbc  b        #0x211a4
0x00020fc0  adrp     x2, #0x79000
0x00020fc4  add      x2, x2, #0x3a8   ; STR "homeScreenGridRows"
0x00020fc8  adrp     x3, #0x7f000
0x00020fcc  add      x3, x3, #0xa68
0x00020fd0  mov      x0, x22
0x00020fd4  bl       #0x5d340   ; CALL objc_msgSend$stepperFor:values:
0x00020fd8  mov      x29, x29
0x00020fdc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00020fe0  b        #0x21010
0x00020fe4  adrp     x2, #0x79000
0x00020fe8  add      x2, x2, #0x3c8   ; STR "homeScreenIconSize"
0x00020fec  adrp     x6, #0x79000
0x00020ff0  add      x6, x6, #0x888   ; STR "%"
0x00020ff4  mov      x0, x22
0x00020ff8  mov      w3, #0x3c
0x00020ffc  mov      w4, #0x82
0x00021000  mov      w5, #0x64
0x00021004  bl       #0x5cc20   ; CALL objc_msgSend$sliderFor:min:max:def:unit:
0x00021008  mov      x29, x29
0x0002100c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021010  mov      x24, x0
0x00021014  b        #0x2109c
0x00021018  adrp     x8, #0x8e000
0x0002101c  ldr      x0, [x8, #0x920]   ; @CLASS UISwitch
0x00021020  bl       #0x55d60   ; CALL _objc_opt_new
0x00021024  mov      x24, x0
0x00021028  bl       #0x17fd8   ; CALL _OMCSwitchColor
0x0002102c  mov      x29, x29
0x00021030  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021034  mov      x25, x0
0x00021038  mov      x0, x24
0x0002103c  mov      x2, x25
0x00021040  bl       #0x5b920   ; CALL objc_msgSend$setOnTintColor:
0x00021044  mov      x0, x25
0x00021048  bl       #0x55d78   ; CALL _objc_release
0x0002104c  adrp     x0, #0x79000
0x00021050  add      x0, x0, #0x3e8   ; STR "homeScreenShowNames"
0x00021054  adrp     x1, #0x74000
0x00021058  ldr      x1, [x1, #0x1b8]   ; @GOT ___kCFBooleanTrue
0x0002105c  bl       #0x1dcc4
0x00021060  mov      x29, x29
0x00021064  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021068  mov      x25, x0
0x0002106c  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00021070  mov      x2, x0
0x00021074  mov      x0, x24
0x00021078  bl       #0x5b900   ; CALL objc_msgSend$setOn:
0x0002107c  mov      x0, x25
0x00021080  bl       #0x55d78   ; CALL _objc_release
0x00021084  adrp     x8, #0x8b000
0x00021088  ldr      x3, [x8, #0xe68]   ; @SEL "namesSwitched:"
0x0002108c  mov      x0, x24
0x00021090  mov      x2, x22
0x00021094  mov      w4, #0x1000
0x00021098  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x0002109c  mov      x0, x22
0x000210a0  mov      x2, x24
0x000210a4  mov      x3, x21
0x000210a8  bl       #0x5a280   ; CALL objc_msgSend$setAccessory:onCell:
0x000210ac  mov      x0, x24
0x000210b0  bl       #0x55d78   ; CALL _objc_release
0x000210b4  mov      x0, x23
0x000210b8  b        #0x211d8
0x000210bc  adrp     x2, #0x76000
0x000210c0  add      x2, x2, #0x5e8   ; STR "none"
0x000210c4  mov      x0, x22
0x000210c8  mov      x3, x19
0x000210cc  bl       #0x56d20   ; CALL objc_msgSend$cellWithId:inTable:
0x000210d0  mov      x29, x29
0x000210d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000210d8  mov      x21, x0
0x000210dc  adrp     x8, #0x8e000
0x000210e0  ldrsw    x8, [x8, #0xe90]
0x000210e4  ldr      x0, [x22, x8]
0x000210e8  bl       #0x58c20   ; CALL objc_msgSend$length
0x000210ec  adrp     x8, #0x79000
0x000210f0  add      x8, x8, #0x748   ; STR "APPBRIDGE_APPS_NO_MATCH"
0x000210f4  adrp     x9, #0x79000
0x000210f8  add      x9, x9, #0xa8   ; STR "APPBRIDGE_APPS_NONE"
0x000210fc  cmp      x0, #0
0x00021100  csel     x0, x9, x8, eq
0x00021104  bl       #0x17e20   ; CALL _L
0x00021108  mov      x29, x29
0x0002110c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021110  mov      x22, x0
0x00021114  mov      x0, x21
0x00021118  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x0002111c  mov      x29, x29
0x00021120  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021124  mov      x24, x0
0x00021128  mov      x2, x22
0x0002112c  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00021130  mov      x0, x24
0x00021134  bl       #0x55d78   ; CALL _objc_release
0x00021138  mov      x0, x22
0x0002113c  bl       #0x55d78   ; CALL _objc_release
0x00021140  adrp     x8, #0x8e000
0x00021144  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00021148  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x0002114c  mov      x29, x29
0x00021150  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021154  mov      x22, x0
0x00021158  mov      x0, x21
0x0002115c  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00021160  mov      x29, x29
0x00021164  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021168  mov      x24, x0
0x0002116c  mov      x2, x22
0x00021170  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00021174  mov      x0, x24
0x00021178  bl       #0x55d78   ; CALL _objc_release
0x0002117c  mov      x0, x22
0x00021180  b        #0x210b0
0x00021184  adrp     x2, #0x79000
0x00021188  add      x2, x2, #0x428   ; STR "homeScreenDim"
0x0002118c  adrp     x6, #0x79000
0x00021190  add      x6, x6, #0x888   ; STR "%"
0x00021194  mov      x0, x22
0x00021198  mov      x3, #0
0x0002119c  mov      w4, #0x46
0x000211a0  mov      w5, #0x19
0x000211a4  bl       #0x5cc20   ; CALL objc_msgSend$sliderFor:min:max:def:unit:
0x000211a8  mov      x29, x29
0x000211ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000211b0  mov      x23, x0
0x000211b4  mov      x0, x22
0x000211b8  mov      x2, x23
0x000211bc  mov      x3, x21
0x000211c0  bl       #0x5a280   ; CALL objc_msgSend$setAccessory:onCell:
0x000211c4  mov      x0, x23
0x000211c8  bl       #0x55d78   ; CALL _objc_release
0x000211cc  mov      x0, x21
0x000211d0  bl       #0x55d84   ; CALL _objc_retain
0x000211d4  mov      x0, x21
0x000211d8  bl       #0x55d78   ; CALL _objc_release
0x000211dc  mov      x0, x20
0x000211e0  bl       #0x55d78   ; CALL _objc_release
0x000211e4  mov      x0, x19
0x000211e8  bl       #0x55d78   ; CALL _objc_release
0x000211ec  mov      x0, x21
0x000211f0  ldp      x29, x30, [sp, #0x70]
0x000211f4  ldp      x20, x19, [sp, #0x60]
0x000211f8  ldp      x22, x21, [sp, #0x50]
0x000211fc  ldp      x24, x23, [sp, #0x40]
0x00021200  ldp      x26, x25, [sp, #0x30]
0x00021204  ldp      x28, x27, [sp, #0x20]
0x00021208  ldp      d9, d8, [sp, #0x10]
0x0002120c  add      sp, sp, #0x80
0x00021210  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCAppBridgeAppsController appCell:inTable:]  va=0x21214 size=668 types=@32@0:8@16@24
0x00021214  stp      x24, x23, [sp, #-0x40]!
0x00021218  stp      x22, x21, [sp, #0x10]
0x0002121c  stp      x20, x19, [sp, #0x20]
0x00021220  stp      x29, x30, [sp, #0x30]
0x00021224  add      x29, sp, #0x30
0x00021228  mov      x20, x3
0x0002122c  mov      x19, x2
0x00021230  mov      x22, x0
0x00021234  mov      x0, x2
0x00021238  bl       #0x55d84   ; CALL _objc_retain
0x0002123c  adrp     x2, #0x79000
0x00021240  add      x2, x2, #0x9a8   ; STR "app"
0x00021244  mov      x0, x22
0x00021248  mov      x3, x20
0x0002124c  bl       #0x56d20   ; CALL objc_msgSend$cellWithId:inTable:
0x00021250  mov      x29, x29
0x00021254  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021258  mov      x20, x0
0x0002125c  adrp     x2, #0x75000
0x00021260  add      x2, x2, #0x3e8   ; STR "id"
0x00021264  mov      x0, x19
0x00021268  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0002126c  mov      x29, x29
0x00021270  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021274  mov      x21, x0
0x00021278  adrp     x2, #0x75000
0x0002127c  add      x2, x2, #0x1e8   ; STR "name"
0x00021280  mov      x0, x19
0x00021284  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00021288  mov      x29, x29
0x0002128c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021290  mov      x23, x0
0x00021294  mov      x0, x20
0x00021298  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x0002129c  mov      x29, x29
0x000212a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000212a4  mov      x24, x0
0x000212a8  mov      x2, x23
0x000212ac  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x000212b0  mov      x0, x24
0x000212b4  bl       #0x55d78   ; CALL _objc_release
0x000212b8  mov      x0, x23
0x000212bc  bl       #0x55d78   ; CALL _objc_release
0x000212c0  mov      x0, x22
0x000212c4  mov      x2, x21
0x000212c8  bl       #0x58000   ; CALL objc_msgSend$iconFor:
0x000212cc  mov      x29, x29
0x000212d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000212d4  mov      x23, x0
0x000212d8  mov      x0, x20
0x000212dc  bl       #0x58120   ; CALL objc_msgSend$imageView
0x000212e0  mov      x29, x29
0x000212e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000212e8  mov      x24, x0
0x000212ec  mov      x2, x23
0x000212f0  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x000212f4  mov      x0, x24
0x000212f8  bl       #0x55d78   ; CALL _objc_release
0x000212fc  mov      x0, x23
0x00021300  bl       #0x55d78   ; CALL _objc_release
0x00021304  adrp     x2, #0x79000
0x00021308  add      x2, x2, #0x328   ; STR "carplay"
0x0002130c  mov      x0, x19
0x00021310  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00021314  mov      x29, x29
0x00021318  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002131c  mov      x23, x0
0x00021320  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00021324  cbz      w0, #0x2135c
0x00021328  adrp     x8, #0x8e000
0x0002132c  ldrsw    x8, [x8, #0xe68]
0x00021330  ldr      x0, [x22, x8]
0x00021334  mov      x2, x21
0x00021338  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0002133c  cbz      w0, #0x2135c
0x00021340  adrp     x8, #0x8e000
0x00021344  ldrsw    x8, [x8, #0xe7c]
0x00021348  ldr      x0, [x22, x8]
0x0002134c  mov      x2, x21
0x00021350  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x00021354  mov      x22, x0
0x00021358  b        #0x21360
0x0002135c  mov      w22, #1
0x00021360  mov      x0, x23
0x00021364  bl       #0x55d78   ; CALL _objc_release
0x00021368  adrp     x2, #0x79000
0x0002136c  add      x2, x2, #0x328   ; STR "carplay"
0x00021370  mov      x0, x19
0x00021374  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00021378  mov      x29, x29
0x0002137c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021380  mov      x23, x0
0x00021384  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00021388  mov      x24, x0
0x0002138c  mov      x0, x23
0x00021390  bl       #0x55d78   ; CALL _objc_release
0x00021394  cbz      w24, #0x2139c
0x00021398  tbnz     w22, #0, #0x21488
0x0002139c  adrp     x8, #0x79000
0x000213a0  add      x8, x8, #0x9c8   ; STR "APPS_IOS_REMOVED"
0x000213a4  adrp     x9, #0x79000
0x000213a8  add      x9, x9, #0x9e8   ; STR "APPBRIDGE"
0x000213ac  cmp      w22, #0
0x000213b0  csel     x0, x9, x8, ne
0x000213b4  bl       #0x17e20   ; CALL _L
0x000213b8  mov      x29, x29
0x000213bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000213c0  mov      x22, x0
0x000213c4  mov      x0, x20
0x000213c8  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x000213cc  mov      x29, x29
0x000213d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000213d4  mov      x23, x0
0x000213d8  mov      x2, x22
0x000213dc  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x000213e0  mov      x0, x23
0x000213e4  bl       #0x55d78   ; CALL _objc_release
0x000213e8  mov      x0, x22
0x000213ec  bl       #0x55d78   ; CALL _objc_release
0x000213f0  adrp     x8, #0x8e000
0x000213f4  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x000213f8  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x000213fc  mov      x29, x29
0x00021400  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021404  mov      x22, x0
0x00021408  mov      x0, x20
0x0002140c  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x00021410  mov      x29, x29
0x00021414  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021418  mov      x23, x0
0x0002141c  mov      x2, x22
0x00021420  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00021424  mov      x0, x23
0x00021428  bl       #0x55d78   ; CALL _objc_release
0x0002142c  mov      x0, x22
0x00021430  bl       #0x55d78   ; CALL _objc_release
0x00021434  adrp     x8, #0x8e000
0x00021438  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x0002143c  adrp     x8, #0x74000
0x00021440  ldr      x8, [x8, #0x260]   ; @GOT _UIFontWeightSemibold
0x00021444  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x00021448  fmov     d0, #11.00000000
0x0002144c  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x00021450  mov      x29, x29
0x00021454  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021458  mov      x22, x0
0x0002145c  mov      x0, x20
0x00021460  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x00021464  mov      x29, x29
0x00021468  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002146c  mov      x23, x0
0x00021470  mov      x2, x22
0x00021474  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00021478  mov      x0, x23
0x0002147c  bl       #0x55d78   ; CALL _objc_release
0x00021480  mov      x0, x22
0x00021484  bl       #0x55d78   ; CALL _objc_release
0x00021488  mov      x0, x21
0x0002148c  bl       #0x55d78   ; CALL _objc_release
0x00021490  mov      x0, x19
0x00021494  bl       #0x55d78   ; CALL _objc_release
0x00021498  mov      x0, x20
0x0002149c  ldp      x29, x30, [sp, #0x30]
0x000214a0  ldp      x20, x19, [sp, #0x20]
0x000214a4  ldp      x22, x21, [sp, #0x10]
0x000214a8  ldp      x24, x23, [sp], #0x40
0x000214ac  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCAppBridgeAppsController tableView:didSelectRowAtIndexPath:]  va=0x214b0 size=308 types=v32@0:8@16@24
0x000214b0  stp      x22, x21, [sp, #-0x30]!
0x000214b4  stp      x20, x19, [sp, #0x10]
0x000214b8  stp      x29, x30, [sp, #0x20]
0x000214bc  add      x29, sp, #0x20
0x000214c0  mov      x19, x3
0x000214c4  mov      x21, x2
0x000214c8  mov      x20, x0
0x000214cc  mov      x0, x3
0x000214d0  bl       #0x55d84   ; CALL _objc_retain
0x000214d4  mov      x0, x21
0x000214d8  mov      x2, x19
0x000214dc  mov      w3, #1
0x000214e0  bl       #0x57740   ; CALL objc_msgSend$deselectRowAtIndexPath:animated:
0x000214e4  mov      x0, x19
0x000214e8  bl       #0x59f60   ; CALL objc_msgSend$row
0x000214ec  cbnz     x0, #0x215d0
0x000214f0  mov      x0, x19
0x000214f4  bl       #0x5a180   ; CALL objc_msgSend$section
0x000214f8  cmp      x0, #4
0x000214fc  b.ne     #0x215d0
0x00021500  adrp     x8, #0x8e000
0x00021504  ldr      x21, [x8, #0x928]   ; @CLASS NSNumber
0x00021508  mov      x0, x19
0x0002150c  bl       #0x5a180   ; CALL objc_msgSend$section
0x00021510  mov      x2, x0
0x00021514  mov      x0, x21
0x00021518  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x0002151c  mov      x29, x29
0x00021520  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021524  mov      x21, x0
0x00021528  adrp     x8, #0x8e000
0x0002152c  ldrsw    x22, [x8, #0xe60]
0x00021530  ldr      x0, [x20, x22]
0x00021534  mov      x2, x21
0x00021538  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0002153c  mov      x8, x0
0x00021540  ldr      x0, [x20, x22]
0x00021544  mov      x2, x21
0x00021548  cbz      w8, #0x21554
0x0002154c  bl       #0x59e40   ; CALL objc_msgSend$removeObject:
0x00021550  b        #0x21558
0x00021554  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00021558  mov      x0, x20
0x0002155c  bl       #0x5df60   ; CALL objc_msgSend$view
0x00021560  mov      x29, x29
0x00021564  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021568  mov      x22, x0
0x0002156c  mov      w2, #1
0x00021570  bl       #0x579a0   ; CALL objc_msgSend$endEditing:
0x00021574  mov      x0, x22
0x00021578  bl       #0x55d78   ; CALL _objc_release
0x0002157c  adrp     x8, #0x8e000
0x00021580  ldrsw    x8, [x8, #0xe58]
0x00021584  ldr      x20, [x20, x8]
0x00021588  adrp     x8, #0x8e000
0x0002158c  ldr      x22, [x8, #0x968]   ; @CLASS NSIndexSet
0x00021590  mov      x0, x19
0x00021594  bl       #0x5a180   ; CALL objc_msgSend$section
0x00021598  mov      x2, x0
0x0002159c  mov      x0, x22
0x000215a0  bl       #0x58340   ; CALL objc_msgSend$indexSetWithIndex:
0x000215a4  mov      x29, x29
0x000215a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000215ac  mov      x22, x0
0x000215b0  mov      x0, x20
0x000215b4  mov      x2, x22
0x000215b8  mov      x3, #0
0x000215bc  bl       #0x59d00   ; CALL objc_msgSend$reloadSections:withRowAnimation:
0x000215c0  mov      x0, x22
0x000215c4  bl       #0x55d78   ; CALL _objc_release
0x000215c8  mov      x0, x21
0x000215cc  bl       #0x55d78   ; CALL _objc_release
0x000215d0  mov      x0, x19
0x000215d4  ldp      x29, x30, [sp, #0x20]
0x000215d8  ldp      x20, x19, [sp, #0x10]
0x000215dc  ldp      x22, x21, [sp], #0x30
0x000215e0  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController num:def:]  va=0x215e4 size=92 types=q32@0:8@16q24
0x000215e4  stp      x20, x19, [sp, #-0x20]!
0x000215e8  stp      x29, x30, [sp, #0x10]
0x000215ec  add      x29, sp, #0x10
0x000215f0  mov      x19, x3
0x000215f4  mov      x0, x2
0x000215f8  mov      x1, #0
0x000215fc  bl       #0x1dcc4
0x00021600  mov      x29, x29
0x00021604  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021608  mov      x20, x0
0x0002160c  adrp     x8, #0x8c000
0x00021610  ldr      x1, [x8, #0x978]   ; @SEL "integerValue"
0x00021614  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x00021618  tbz      w0, #0, #0x21628
0x0002161c  mov      x0, x20
0x00021620  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x00021624  mov      x19, x0
0x00021628  mov      x0, x20
0x0002162c  bl       #0x55d78   ; CALL _objc_release
0x00021630  mov      x0, x19
0x00021634  ldp      x29, x30, [sp, #0x10]
0x00021638  ldp      x20, x19, [sp], #0x20
0x0002163c  ret      

=== -[OMCAppBridgeAppsController setAccessory:onCell:]  va=0x21640 size=84 types=v32@0:8@16@24
0x00021640  stp      x20, x19, [sp, #-0x20]!
0x00021644  stp      x29, x30, [sp, #0x10]
0x00021648  add      x29, sp, #0x10
0x0002164c  mov      x19, x3
0x00021650  mov      x20, x2
0x00021654  mov      x0, x3
0x00021658  bl       #0x55d84   ; CALL _objc_retain
0x0002165c  mov      x0, x20
0x00021660  bl       #0x55d84   ; CALL _objc_retain
0x00021664  mov      x0, x19
0x00021668  mov      x2, x20
0x0002166c  bl       #0x5a2c0   ; CALL objc_msgSend$setAccessoryView:
0x00021670  mov      x0, x19
0x00021674  mov      x2, x20
0x00021678  bl       #0x5ad80   ; CALL objc_msgSend$setEditingAccessoryView:
0x0002167c  mov      x0, x19
0x00021680  bl       #0x55d78   ; CALL _objc_release
0x00021684  mov      x0, x20
0x00021688  ldp      x29, x30, [sp, #0x10]
0x0002168c  ldp      x20, x19, [sp], #0x20
0x00021690  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController sliderFor:min:max:def:unit:]  va=0x21694 size=732 types=@56@0:8@16q24q32q40@48
0x00021694  sub      sp, sp, #0x90
0x00021698  stp      d9, d8, [sp, #0x30]
0x0002169c  stp      x26, x25, [sp, #0x40]
0x000216a0  stp      x24, x23, [sp, #0x50]
0x000216a4  stp      x22, x21, [sp, #0x60]
0x000216a8  stp      x20, x19, [sp, #0x70]
0x000216ac  stp      x29, x30, [sp, #0x80]
0x000216b0  add      x29, sp, #0x80
0x000216b4  mov      x20, x6
0x000216b8  mov      x24, x5
0x000216bc  mov      x25, x4
0x000216c0  mov      x26, x3
0x000216c4  mov      x19, x2
0x000216c8  mov      x22, x0
0x000216cc  adrp     x8, #0x74000
0x000216d0  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000216d4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000216d8  str      x8, [sp, #0x28]
0x000216dc  adrp     x8, #0x8e000
0x000216e0  ldr      x21, [x8, #0x918]   ; @CLASS UIView
0x000216e4  mov      x0, x6
0x000216e8  bl       #0x55d84   ; CALL _objc_retain
0x000216ec  mov      x0, x19
0x000216f0  bl       #0x55d84   ; CALL _objc_retain
0x000216f4  mov      x0, x21
0x000216f8  bl       #0x55c7c   ; CALL _objc_alloc
0x000216fc  mov      x8, #0x4069000000000000
0x00021700  fmov     d2, x8
0x00021704  mov      x8, #0x4040000000000000
0x00021708  fmov     d8, x8
0x0002170c  fmov     d0, xzr
0x00021710  fmov     d1, xzr
0x00021714  mov      v3.16b, v8.16b
0x00021718  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0002171c  mov      x21, x0
0x00021720  adrp     x8, #0x8e000
0x00021724  ldr      x0, [x8, #0x950]   ; @CLASS UISlider
0x00021728  bl       #0x55c7c   ; CALL _objc_alloc
0x0002172c  adrp     x8, #0x65000
0x00021730  ldr      d2, [x8, #0x788]
0x00021734  fmov     d0, xzr
0x00021738  fmov     d1, xzr
0x0002173c  mov      v3.16b, v8.16b
0x00021740  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x00021744  mov      x23, x0
0x00021748  scvtf    s0, x26
0x0002174c  bl       #0x5b6a0   ; CALL objc_msgSend$setMinimumValue:
0x00021750  scvtf    s0, x25
0x00021754  mov      x0, x23
0x00021758  bl       #0x5b580   ; CALL objc_msgSend$setMaximumValue:
0x0002175c  mov      x0, x22
0x00021760  mov      x2, x19
0x00021764  mov      x3, x24
0x00021768  bl       #0x59220   ; CALL objc_msgSend$num:def:
0x0002176c  scvtf    s0, x0
0x00021770  mov      x0, x23
0x00021774  bl       #0x5c780   ; CALL objc_msgSend$setValue:
0x00021778  bl       #0x17e8c   ; CALL _OMCAccentColor
0x0002177c  mov      x29, x29
0x00021780  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021784  mov      x24, x0
0x00021788  mov      x0, x23
0x0002178c  mov      x2, x24
0x00021790  bl       #0x5b680   ; CALL objc_msgSend$setMinimumTrackTintColor:
0x00021794  mov      x0, x24
0x00021798  bl       #0x55d78   ; CALL _objc_release
0x0002179c  adrp     x8, #0x8e000
0x000217a0  ldr      x0, [x8, #0x940]   ; @CLASS UILabel
0x000217a4  bl       #0x55c7c   ; CALL _objc_alloc
0x000217a8  adrp     x8, #0x65000
0x000217ac  ldr      d0, [x8, #0x790]
0x000217b0  mov      x8, #0x4047000000000000
0x000217b4  fmov     d2, x8
0x000217b8  fmov     d1, xzr
0x000217bc  mov      v3.16b, v8.16b
0x000217c0  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x000217c4  mov      x24, x0
0x000217c8  mov      w2, #2
0x000217cc  bl       #0x5c4e0   ; CALL objc_msgSend$setTextAlignment:
0x000217d0  adrp     x8, #0x8e000
0x000217d4  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x000217d8  adrp     x8, #0x74000
0x000217dc  ldr      x8, [x8, #0x258]   ; @GOT _UIFontWeightRegular
0x000217e0  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x000217e4  fmov     d0, #14.00000000
0x000217e8  bl       #0x58fe0   ; CALL objc_msgSend$monospacedDigitSystemFontOfSize:weight:
0x000217ec  mov      x29, x29
0x000217f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000217f4  mov      x25, x0
0x000217f8  mov      x0, x24
0x000217fc  mov      x2, x25
0x00021800  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00021804  mov      x0, x25
0x00021808  bl       #0x55d78   ; CALL _objc_release
0x0002180c  adrp     x8, #0x8e000
0x00021810  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00021814  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x00021818  mov      x29, x29
0x0002181c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021820  mov      x25, x0
0x00021824  mov      x0, x24
0x00021828  mov      x2, x25
0x0002182c  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00021830  mov      x0, x25
0x00021834  bl       #0x55d78   ; CALL _objc_release
0x00021838  adrp     x8, #0x8e000
0x0002183c  ldr      x25, [x8, #0x958]   ; @CLASS NSString
0x00021840  mov      x0, x23
0x00021844  bl       #0x5dea0   ; CALL objc_msgSend$value
0x00021848  fcvtzs   x8, s0
0x0002184c  stp      x8, x20, [sp]
0x00021850  adrp     x2, #0x79000
0x00021854  add      x2, x2, #0xa08   ; STR "%ld%@"
0x00021858  mov      x0, x25
0x0002185c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00021860  mov      x29, x29
0x00021864  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021868  mov      x25, x0
0x0002186c  mov      x0, x24
0x00021870  mov      x2, x25
0x00021874  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00021878  mov      x0, x25
0x0002187c  bl       #0x55d78   ; CALL _objc_release
0x00021880  stp      x19, x20, [sp, #0x10]
0x00021884  str      x24, [sp, #0x20]
0x00021888  adrp     x8, #0x8e000
0x0002188c  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00021890  add      x2, sp, #0x10
0x00021894  mov      w3, #3
0x00021898  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0002189c  mov      x29, x29
0x000218a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000218a4  mov      x25, x0
0x000218a8  adrp     x1, #0x90000
0x000218ac  add      x1, x1, #0x20
0x000218b0  mov      x0, x23
0x000218b4  mov      x2, x25
0x000218b8  mov      w3, #1
0x000218bc  bl       #0x55db4   ; CALL _objc_setAssociatedObject
0x000218c0  mov      x0, x25
0x000218c4  bl       #0x55d78   ; CALL _objc_release
0x000218c8  adrp     x8, #0x8b000
0x000218cc  ldr      x3, [x8, #0xe78]   ; @SEL "sliderMoved:"
0x000218d0  mov      x0, x23
0x000218d4  mov      x2, x22
0x000218d8  mov      w4, #0x1000
0x000218dc  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x000218e0  adrp     x8, #0x8b000
0x000218e4  ldr      x3, [x8, #0xe80]   ; @SEL "sliderDone:"
0x000218e8  mov      x0, x23
0x000218ec  mov      x2, x22
0x000218f0  mov      w4, #0xc0
0x000218f4  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x000218f8  mov      x0, x20
0x000218fc  bl       #0x55d78   ; CALL _objc_release
0x00021900  mov      x0, x19
0x00021904  bl       #0x55d78   ; CALL _objc_release
0x00021908  mov      x0, x21
0x0002190c  mov      x2, x23
0x00021910  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00021914  mov      x0, x21
0x00021918  mov      x2, x24
0x0002191c  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00021920  mov      x0, x24
0x00021924  bl       #0x55d78   ; CALL _objc_release
0x00021928  mov      x0, x23
0x0002192c  bl       #0x55d78   ; CALL _objc_release
0x00021930  ldr      x8, [sp, #0x28]
0x00021934  adrp     x9, #0x74000
0x00021938  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0002193c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00021940  cmp      x9, x8
0x00021944  b.ne     #0x2196c
0x00021948  mov      x0, x21
0x0002194c  ldp      x29, x30, [sp, #0x80]
0x00021950  ldp      x20, x19, [sp, #0x70]
0x00021954  ldp      x22, x21, [sp, #0x60]
0x00021958  ldp      x24, x23, [sp, #0x50]
0x0002195c  ldp      x26, x25, [sp, #0x40]
0x00021960  ldp      d9, d8, [sp, #0x30]
0x00021964  add      sp, sp, #0x90
0x00021968  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0002196c  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCAppBridgeAppsController stepperFor:values:]  va=0x21970 size=760 types=@32@0:8@16@24
0x00021970  sub      sp, sp, #0x90
0x00021974  stp      d11, d10, [sp, #0x20]
0x00021978  stp      d9, d8, [sp, #0x30]
0x0002197c  stp      x26, x25, [sp, #0x40]
0x00021980  stp      x24, x23, [sp, #0x50]
0x00021984  stp      x22, x21, [sp, #0x60]
0x00021988  stp      x20, x19, [sp, #0x70]
0x0002198c  stp      x29, x30, [sp, #0x80]
0x00021990  add      x29, sp, #0x80
0x00021994  mov      x22, x3
0x00021998  mov      x20, x2
0x0002199c  mov      x19, x0
0x000219a0  adrp     x8, #0x74000
0x000219a4  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000219a8  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000219ac  str      x8, [sp, #0x18]
0x000219b0  adrp     x8, #0x8e000
0x000219b4  ldr      x21, [x8, #0x918]   ; @CLASS UIView
0x000219b8  mov      x0, x3
0x000219bc  bl       #0x55d84   ; CALL _objc_retain
0x000219c0  mov      x0, x20
0x000219c4  bl       #0x55d84   ; CALL _objc_retain
0x000219c8  mov      x0, x21
0x000219cc  bl       #0x55c7c   ; CALL _objc_alloc
0x000219d0  adrp     x8, #0x65000
0x000219d4  ldr      d9, [x8, #0x798]
0x000219d8  mov      x8, #0x4040000000000000
0x000219dc  fmov     d8, x8
0x000219e0  fmov     d0, xzr
0x000219e4  fmov     d1, xzr
0x000219e8  mov      v2.16b, v9.16b
0x000219ec  mov      v3.16b, v8.16b
0x000219f0  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x000219f4  mov      x21, x0
0x000219f8  adrp     x8, #0x8e000
0x000219fc  ldr      x0, [x8, #0x940]   ; @CLASS UILabel
0x00021a00  bl       #0x55c7c   ; CALL _objc_alloc
0x00021a04  mov      x8, #0x4050000000000000
0x00021a08  fmov     d2, x8
0x00021a0c  fmov     d0, xzr
0x00021a10  fmov     d1, xzr
0x00021a14  mov      v3.16b, v8.16b
0x00021a18  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x00021a1c  mov      x23, x0
0x00021a20  mov      w2, #2
0x00021a24  bl       #0x5c4e0   ; CALL objc_msgSend$setTextAlignment:
0x00021a28  adrp     x8, #0x8e000
0x00021a2c  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x00021a30  adrp     x8, #0x74000
0x00021a34  ldr      x8, [x8, #0x258]   ; @GOT _UIFontWeightRegular
0x00021a38  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x00021a3c  fmov     d0, #14.00000000
0x00021a40  bl       #0x58fe0   ; CALL objc_msgSend$monospacedDigitSystemFontOfSize:weight:
0x00021a44  mov      x29, x29
0x00021a48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021a4c  mov      x24, x0
0x00021a50  mov      x0, x23
0x00021a54  mov      x2, x24
0x00021a58  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00021a5c  mov      x0, x24
0x00021a60  bl       #0x55d78   ; CALL _objc_release
0x00021a64  adrp     x8, #0x8e000
0x00021a68  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00021a6c  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x00021a70  mov      x29, x29
0x00021a74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021a78  mov      x24, x0
0x00021a7c  mov      x0, x23
0x00021a80  mov      x2, x24
0x00021a84  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00021a88  mov      x0, x24
0x00021a8c  bl       #0x55d78   ; CALL _objc_release
0x00021a90  mov      x0, x23
0x00021a94  mov      w2, #1
0x00021a98  bl       #0x5a380   ; CALL objc_msgSend$setAdjustsFontSizeToFitWidth:
0x00021a9c  adrp     x8, #0x8e000
0x00021aa0  ldr      x0, [x8, #0xb38]   ; @CLASS UIStepper
0x00021aa4  bl       #0x55d60   ; CALL _objc_opt_new
0x00021aa8  mov      x24, x0
0x00021aac  bl       #0x57d00   ; CALL objc_msgSend$frame
0x00021ab0  fsub     d9, d9, d2
0x00021ab4  mov      x0, x24
0x00021ab8  bl       #0x57d00   ; CALL objc_msgSend$frame
0x00021abc  fsub     d0, d8, d3
0x00021ac0  fmov     d1, #0.50000000
0x00021ac4  fmul     d8, d0, d1
0x00021ac8  mov      x0, x24
0x00021acc  bl       #0x57d00   ; CALL objc_msgSend$frame
0x00021ad0  mov      v10.16b, v2.16b
0x00021ad4  mov      x0, x24
0x00021ad8  bl       #0x57d00   ; CALL objc_msgSend$frame
0x00021adc  mov      x0, x24
0x00021ae0  mov      v0.16b, v9.16b
0x00021ae4  mov      v1.16b, v8.16b
0x00021ae8  mov      v2.16b, v10.16b
0x00021aec  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00021af0  fmov     d0, xzr
0x00021af4  mov      x0, x24
0x00021af8  bl       #0x5b6a0   ; CALL objc_msgSend$setMinimumValue:
0x00021afc  mov      x0, x22
0x00021b00  bl       #0x573c0   ; CALL objc_msgSend$count
0x00021b04  sub      x8, x0, #1
0x00021b08  ucvtf    d0, x8
0x00021b0c  mov      x0, x24
0x00021b10  bl       #0x5b580   ; CALL objc_msgSend$setMaximumValue:
0x00021b14  fmov     d0, #1.00000000
0x00021b18  mov      x0, x24
0x00021b1c  bl       #0x5c300   ; CALL objc_msgSend$setStepValue:
0x00021b20  adrp     x8, #0x8e000
0x00021b24  ldr      x25, [x8, #0x928]   ; @CLASS NSNumber
0x00021b28  mov      x0, x19
0x00021b2c  mov      x2, x20
0x00021b30  mov      x3, #0
0x00021b34  bl       #0x59220   ; CALL objc_msgSend$num:def:
0x00021b38  mov      x2, x0
0x00021b3c  mov      x0, x25
0x00021b40  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x00021b44  mov      x29, x29
0x00021b48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021b4c  mov      x25, x0
0x00021b50  mov      x0, x22
0x00021b54  mov      x2, x25
0x00021b58  bl       #0x582c0   ; CALL objc_msgSend$indexOfObject:
0x00021b5c  mov      x26, x0
0x00021b60  mov      x0, x25
0x00021b64  bl       #0x55d78   ; CALL _objc_release
0x00021b68  mov      x8, #0x7fffffffffffffff
0x00021b6c  cmp      x26, x8
0x00021b70  csel     x8, xzr, x26, eq
0x00021b74  ucvtf    d0, x8
0x00021b78  mov      x0, x24
0x00021b7c  bl       #0x5c780   ; CALL objc_msgSend$setValue:
0x00021b80  stp      x20, x22, [sp]
0x00021b84  str      x23, [sp, #0x10]
0x00021b88  adrp     x8, #0x8e000
0x00021b8c  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00021b90  mov      x2, sp
0x00021b94  mov      w3, #3
0x00021b98  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00021b9c  mov      x29, x29
0x00021ba0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021ba4  mov      x25, x0
0x00021ba8  adrp     x1, #0x90000
0x00021bac  add      x1, x1, #0x20
0x00021bb0  mov      x0, x24
0x00021bb4  mov      x2, x25
0x00021bb8  mov      w3, #1
0x00021bbc  bl       #0x55db4   ; CALL _objc_setAssociatedObject
0x00021bc0  mov      x0, x25
0x00021bc4  bl       #0x55d78   ; CALL _objc_release
0x00021bc8  adrp     x8, #0x8b000
0x00021bcc  ldr      x3, [x8, #0xe88]   ; @SEL "stepped:"
0x00021bd0  mov      x0, x24
0x00021bd4  mov      x2, x19
0x00021bd8  mov      w4, #0x1000
0x00021bdc  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x00021be0  mov      x0, x22
0x00021be4  bl       #0x55d78   ; CALL _objc_release
0x00021be8  mov      x0, x20
0x00021bec  bl       #0x55d78   ; CALL _objc_release
0x00021bf0  mov      x0, x19
0x00021bf4  mov      x2, x24
0x00021bf8  bl       #0x5cac0   ; CALL objc_msgSend$showStep:
0x00021bfc  mov      x0, x21
0x00021c00  mov      x2, x23
0x00021c04  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00021c08  mov      x0, x21
0x00021c0c  mov      x2, x24
0x00021c10  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00021c14  mov      x0, x24
0x00021c18  bl       #0x55d78   ; CALL _objc_release
0x00021c1c  mov      x0, x23
0x00021c20  bl       #0x55d78   ; CALL _objc_release
0x00021c24  ldr      x8, [sp, #0x18]
0x00021c28  adrp     x9, #0x74000
0x00021c2c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00021c30  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00021c34  cmp      x9, x8
0x00021c38  b.ne     #0x21c64
0x00021c3c  mov      x0, x21
0x00021c40  ldp      x29, x30, [sp, #0x80]
0x00021c44  ldp      x20, x19, [sp, #0x70]
0x00021c48  ldp      x22, x21, [sp, #0x60]
0x00021c4c  ldp      x24, x23, [sp, #0x50]
0x00021c50  ldp      x26, x25, [sp, #0x40]
0x00021c54  ldp      d9, d8, [sp, #0x30]
0x00021c58  ldp      d11, d10, [sp, #0x20]
0x00021c5c  add      sp, sp, #0x90
0x00021c60  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00021c64  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCAppBridgeAppsController showStep:]  va=0x21c68 size=320 types=v24@0:8@16
0x00021c68  stp      d9, d8, [sp, #-0x50]!
0x00021c6c  stp      x24, x23, [sp, #0x10]
0x00021c70  stp      x22, x21, [sp, #0x20]
0x00021c74  stp      x20, x19, [sp, #0x30]
0x00021c78  stp      x29, x30, [sp, #0x40]
0x00021c7c  add      x29, sp, #0x40
0x00021c80  mov      x20, x2
0x00021c84  mov      x0, x2
0x00021c88  bl       #0x55d84   ; CALL _objc_retain
0x00021c8c  adrp     x1, #0x90000
0x00021c90  add      x1, x1, #0x20
0x00021c94  mov      x0, x20
0x00021c98  bl       #0x55d00   ; CALL _objc_getAssociatedObject
0x00021c9c  mov      x29, x29
0x00021ca0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021ca4  mov      x19, x0
0x00021ca8  mov      w2, #1
0x00021cac  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00021cb0  mov      x29, x29
0x00021cb4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021cb8  mov      x21, x0
0x00021cbc  mov      x0, x20
0x00021cc0  bl       #0x5dea0   ; CALL objc_msgSend$value
0x00021cc4  mov      v8.16b, v0.16b
0x00021cc8  mov      x0, x20
0x00021ccc  bl       #0x55d78   ; CALL _objc_release
0x00021cd0  fcvtzu   x2, d8
0x00021cd4  mov      x0, x21
0x00021cd8  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00021cdc  mov      x29, x29
0x00021ce0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021ce4  mov      x22, x0
0x00021ce8  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x00021cec  mov      x20, x0
0x00021cf0  mov      x0, x22
0x00021cf4  bl       #0x55d78   ; CALL _objc_release
0x00021cf8  mov      x0, x21
0x00021cfc  bl       #0x55d78   ; CALL _objc_release
0x00021d00  cbz      x20, #0x21d34
0x00021d04  adrp     x8, #0x8e000
0x00021d08  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x00021d0c  mov      x2, x20
0x00021d10  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x00021d14  mov      x29, x29
0x00021d18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021d1c  mov      x21, x0
0x00021d20  bl       #0x5d540   ; CALL objc_msgSend$stringValue
0x00021d24  mov      x29, x29
0x00021d28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021d2c  mov      x22, x0
0x00021d30  b        #0x21d4c
0x00021d34  adrp     x0, #0x79000
0x00021d38  add      x0, x0, #0xa28   ; STR "HOMESCREEN_AUTO"
0x00021d3c  bl       #0x17e20   ; CALL _L
0x00021d40  mov      x29, x29
0x00021d44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021d48  mov      x22, x0
0x00021d4c  mov      x0, x19
0x00021d50  mov      w2, #2
0x00021d54  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00021d58  mov      x29, x29
0x00021d5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021d60  mov      x23, x0
0x00021d64  mov      x2, x22
0x00021d68  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00021d6c  mov      x0, x23
0x00021d70  bl       #0x55d78   ; CALL _objc_release
0x00021d74  cbz      x20, #0x21d84
0x00021d78  mov      x0, x22
0x00021d7c  bl       #0x55d78   ; CALL _objc_release
0x00021d80  mov      x22, x21
0x00021d84  mov      x0, x22
0x00021d88  bl       #0x55d78   ; CALL _objc_release
0x00021d8c  mov      x0, x19
0x00021d90  ldp      x29, x30, [sp, #0x40]
0x00021d94  ldp      x20, x19, [sp, #0x30]
0x00021d98  ldp      x22, x21, [sp, #0x20]
0x00021d9c  ldp      x24, x23, [sp, #0x10]
0x00021da0  ldp      d9, d8, [sp], #0x50
0x00021da4  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController stepped:]  va=0x21da8 size=328 types=v24@0:8@16
0x00021da8  stp      d9, d8, [sp, #-0x50]!
0x00021dac  stp      x24, x23, [sp, #0x10]
0x00021db0  stp      x22, x21, [sp, #0x20]
0x00021db4  stp      x20, x19, [sp, #0x30]
0x00021db8  stp      x29, x30, [sp, #0x40]
0x00021dbc  add      x29, sp, #0x40
0x00021dc0  mov      x21, x2
0x00021dc4  mov      x19, x0
0x00021dc8  mov      x0, x2
0x00021dcc  bl       #0x55d84   ; CALL _objc_retain
0x00021dd0  adrp     x1, #0x90000
0x00021dd4  add      x1, x1, #0x20
0x00021dd8  mov      x0, x21
0x00021ddc  bl       #0x55d00   ; CALL _objc_getAssociatedObject
0x00021de0  mov      x29, x29
0x00021de4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021de8  mov      x20, x0
0x00021dec  adrp     x8, #0x8e000
0x00021df0  ldr      x0, [x8, #0x938]   ; @CLASS UISelectionFeedbackGenerator
0x00021df4  bl       #0x55d60   ; CALL _objc_opt_new
0x00021df8  mov      x22, x0
0x00021dfc  bl       #0x5a200   ; CALL objc_msgSend$selectionChanged
0x00021e00  mov      x0, x22
0x00021e04  bl       #0x55d78   ; CALL _objc_release
0x00021e08  mov      x0, x19
0x00021e0c  mov      x2, x21
0x00021e10  bl       #0x5cac0   ; CALL objc_msgSend$showStep:
0x00021e14  mov      x0, x20
0x00021e18  mov      x2, #0
0x00021e1c  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00021e20  mov      x29, x29
0x00021e24  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021e28  mov      x22, x0
0x00021e2c  mov      x0, x20
0x00021e30  mov      w2, #1
0x00021e34  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00021e38  mov      x29, x29
0x00021e3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021e40  mov      x23, x0
0x00021e44  mov      x0, x21
0x00021e48  bl       #0x5dea0   ; CALL objc_msgSend$value
0x00021e4c  mov      v8.16b, v0.16b
0x00021e50  mov      x0, x21
0x00021e54  bl       #0x55d78   ; CALL _objc_release
0x00021e58  fcvtzu   x2, d8
0x00021e5c  mov      x0, x23
0x00021e60  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00021e64  mov      x29, x29
0x00021e68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021e6c  mov      x21, x0
0x00021e70  mov      x0, x22
0x00021e74  mov      x1, x21
0x00021e78  bl       #0x21eb8
0x00021e7c  mov      x0, x21
0x00021e80  bl       #0x55d78   ; CALL _objc_release
0x00021e84  mov      x0, x23
0x00021e88  bl       #0x55d78   ; CALL _objc_release
0x00021e8c  mov      x0, x22
0x00021e90  bl       #0x55d78   ; CALL _objc_release
0x00021e94  mov      x0, x19
0x00021e98  bl       #0x5dd80   ; CALL objc_msgSend$updatePreview
0x00021e9c  mov      x0, x20
0x00021ea0  ldp      x29, x30, [sp, #0x40]
0x00021ea4  ldp      x20, x19, [sp, #0x30]
0x00021ea8  ldp      x22, x21, [sp, #0x20]
0x00021eac  ldp      x24, x23, [sp, #0x10]
0x00021eb0  ldp      d9, d8, [sp], #0x50
0x00021eb4  b        #0x55d78   ; CALL _objc_release
0x00021eb8  stp      x20, x19, [sp, #-0x20]!
0x00021ebc  stp      x29, x30, [sp, #0x10]
0x00021ec0  add      x29, sp, #0x10
0x00021ec4  adrp     x19, #0x75000
0x00021ec8  add      x19, x19, #0x28   ; STR "com.anlai.omnicar"
0x00021ecc  mov      x2, x19
0x00021ed0  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x00021ed4  mov      x0, x19
0x00021ed8  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x00021edc  adrp     x0, #0x61000
0x00021ee0  add      x0, x0, #0x1b1   ; CSTR "com.anlai.omnicar/prefschanged"
0x00021ee4  ldp      x29, x30, [sp, #0x10]
0x00021ee8  ldp      x20, x19, [sp], #0x20
0x00021eec  b        #0x55c70   ; CALL _notify_post

=== -[OMCAppBridgeAppsController namesSwitched:]  va=0x21ef0 size=96 types=v24@0:8@16
0x00021ef0  stp      x20, x19, [sp, #-0x20]!
0x00021ef4  stp      x29, x30, [sp, #0x10]
0x00021ef8  add      x29, sp, #0x10
0x00021efc  mov      x19, x0
0x00021f00  adrp     x8, #0x8e000
0x00021f04  ldr      x20, [x8, #0x928]   ; @CLASS NSNumber
0x00021f08  mov      x0, x2
0x00021f0c  bl       #0x588c0   ; CALL objc_msgSend$isOn
0x00021f10  mov      x2, x0
0x00021f14  mov      x0, x20
0x00021f18  bl       #0x592c0   ; CALL objc_msgSend$numberWithBool:
0x00021f1c  mov      x29, x29
0x00021f20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021f24  mov      x20, x0
0x00021f28  adrp     x0, #0x79000
0x00021f2c  add      x0, x0, #0x3e8   ; STR "homeScreenShowNames"
0x00021f30  mov      x1, x20
0x00021f34  bl       #0x21eb8
0x00021f38  mov      x0, x20
0x00021f3c  bl       #0x55d78   ; CALL _objc_release
0x00021f40  mov      x0, x19
0x00021f44  ldp      x29, x30, [sp, #0x10]
0x00021f48  ldp      x20, x19, [sp], #0x20
0x00021f4c  b        #0x5dd80   ; CALL objc_msgSend$updatePreview

=== -[OMCAppBridgeAppsController sliderMoved:]  va=0x21f50 size=344 types=v24@0:8@16
0x00021f50  sub      sp, sp, #0x60
0x00021f54  stp      d9, d8, [sp, #0x10]
0x00021f58  stp      x24, x23, [sp, #0x20]
0x00021f5c  stp      x22, x21, [sp, #0x30]
0x00021f60  stp      x20, x19, [sp, #0x40]
0x00021f64  stp      x29, x30, [sp, #0x50]
0x00021f68  add      x29, sp, #0x50
0x00021f6c  mov      x21, x2
0x00021f70  mov      x19, x0
0x00021f74  mov      x0, x2
0x00021f78  bl       #0x55d84   ; CALL _objc_retain
0x00021f7c  adrp     x1, #0x90000
0x00021f80  add      x1, x1, #0x20
0x00021f84  mov      x0, x21
0x00021f88  bl       #0x55d00   ; CALL _objc_getAssociatedObject
0x00021f8c  mov      x29, x29
0x00021f90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021f94  mov      x20, x0
0x00021f98  adrp     x8, #0x8e000
0x00021f9c  ldr      x22, [x8, #0x958]   ; @CLASS NSString
0x00021fa0  mov      x0, x21
0x00021fa4  bl       #0x5dea0   ; CALL objc_msgSend$value
0x00021fa8  fcvt     d0, s0
0x00021fac  fcvtas   x24, d0
0x00021fb0  mov      x0, x20
0x00021fb4  mov      w2, #1
0x00021fb8  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00021fbc  mov      x29, x29
0x00021fc0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021fc4  mov      x23, x0
0x00021fc8  stp      x24, x0, [sp]
0x00021fcc  adrp     x2, #0x79000
0x00021fd0  add      x2, x2, #0xa08   ; STR "%ld%@"
0x00021fd4  mov      x0, x22
0x00021fd8  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00021fdc  mov      x29, x29
0x00021fe0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021fe4  mov      x22, x0
0x00021fe8  mov      x0, x20
0x00021fec  mov      w2, #2
0x00021ff0  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00021ff4  mov      x29, x29
0x00021ff8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00021ffc  mov      x24, x0
0x00022000  mov      x2, x22
0x00022004  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00022008  mov      x0, x24
0x0002200c  bl       #0x55d78   ; CALL _objc_release
0x00022010  mov      x0, x22
0x00022014  bl       #0x55d78   ; CALL _objc_release
0x00022018  mov      x0, x23
0x0002201c  bl       #0x55d78   ; CALL _objc_release
0x00022020  mov      x0, x20
0x00022024  mov      x2, #0
0x00022028  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0002202c  mov      x29, x29
0x00022030  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022034  mov      x22, x0
0x00022038  adrp     x8, #0x8e000
0x0002203c  ldr      x23, [x8, #0x928]   ; @CLASS NSNumber
0x00022040  mov      x0, x21
0x00022044  bl       #0x5dea0   ; CALL objc_msgSend$value
0x00022048  mov      v8.16b, v0.16b
0x0002204c  mov      x0, x21
0x00022050  bl       #0x55d78   ; CALL _objc_release
0x00022054  fcvt     d0, s8
0x00022058  fcvtas   x2, d0
0x0002205c  mov      x0, x23
0x00022060  bl       #0x59340   ; CALL objc_msgSend$numberWithLong:
0x00022064  mov      x1, x0
0x00022068  adrp     x2, #0x75000
0x0002206c  add      x2, x2, #0x28   ; STR "com.anlai.omnicar"
0x00022070  mov      x0, x22
0x00022074  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x00022078  mov      x0, x22
0x0002207c  bl       #0x55d78   ; CALL _objc_release
0x00022080  mov      x0, x19
0x00022084  bl       #0x5dd80   ; CALL objc_msgSend$updatePreview
0x00022088  mov      x0, x20
0x0002208c  ldp      x29, x30, [sp, #0x50]
0x00022090  ldp      x20, x19, [sp, #0x40]
0x00022094  ldp      x22, x21, [sp, #0x30]
0x00022098  ldp      x24, x23, [sp, #0x20]
0x0002209c  ldp      d9, d8, [sp, #0x10]
0x000220a0  add      sp, sp, #0x60
0x000220a4  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController sliderDone:]  va=0x220a8 size=188 types=v24@0:8@16
0x000220a8  stp      d9, d8, [sp, #-0x40]!
0x000220ac  stp      x22, x21, [sp, #0x10]
0x000220b0  stp      x20, x19, [sp, #0x20]
0x000220b4  stp      x29, x30, [sp, #0x30]
0x000220b8  add      x29, sp, #0x30
0x000220bc  mov      x19, x2
0x000220c0  mov      x0, x2
0x000220c4  bl       #0x55d84   ; CALL _objc_retain
0x000220c8  adrp     x1, #0x90000
0x000220cc  add      x1, x1, #0x20
0x000220d0  mov      x0, x19
0x000220d4  bl       #0x55d00   ; CALL _objc_getAssociatedObject
0x000220d8  mov      x29, x29
0x000220dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000220e0  mov      x20, x0
0x000220e4  mov      x2, #0
0x000220e8  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000220ec  mov      x29, x29
0x000220f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000220f4  mov      x21, x0
0x000220f8  adrp     x8, #0x8e000
0x000220fc  ldr      x22, [x8, #0x928]   ; @CLASS NSNumber
0x00022100  mov      x0, x19
0x00022104  bl       #0x5dea0   ; CALL objc_msgSend$value
0x00022108  mov      v8.16b, v0.16b
0x0002210c  mov      x0, x19
0x00022110  bl       #0x55d78   ; CALL _objc_release
0x00022114  fcvt     d0, s8
0x00022118  fcvtas   x2, d0
0x0002211c  mov      x0, x22
0x00022120  bl       #0x59340   ; CALL objc_msgSend$numberWithLong:
0x00022124  mov      x29, x29
0x00022128  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002212c  mov      x19, x0
0x00022130  mov      x0, x21
0x00022134  mov      x1, x19
0x00022138  bl       #0x21eb8
0x0002213c  mov      x0, x19
0x00022140  bl       #0x55d78   ; CALL _objc_release
0x00022144  mov      x0, x21
0x00022148  bl       #0x55d78   ; CALL _objc_release
0x0002214c  mov      x0, x20
0x00022150  ldp      x29, x30, [sp, #0x30]
0x00022154  ldp      x20, x19, [sp, #0x20]
0x00022158  ldp      x22, x21, [sp, #0x10]
0x0002215c  ldp      d9, d8, [sp], #0x40
0x00022160  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController smallButton:tint:action:bundle:]  va=0x22164 size=288 types=@48@0:8@16@24:32@40
0x00022164  stp      x26, x25, [sp, #-0x50]!
0x00022168  stp      x24, x23, [sp, #0x10]
0x0002216c  stp      x22, x21, [sp, #0x20]
0x00022170  stp      x20, x19, [sp, #0x30]
0x00022174  stp      x29, x30, [sp, #0x40]
0x00022178  add      x29, sp, #0x40
0x0002217c  mov      x21, x5
0x00022180  mov      x19, x4
0x00022184  mov      x23, x3
0x00022188  mov      x24, x2
0x0002218c  mov      x20, x0
0x00022190  adrp     x8, #0x8e000
0x00022194  ldr      x22, [x8, #0xa50]   ; @CLASS UIButton
0x00022198  mov      x0, x5
0x0002219c  bl       #0x55d84   ; CALL _objc_retain
0x000221a0  mov      x0, x23
0x000221a4  bl       #0x55d84   ; CALL _objc_retain
0x000221a8  mov      x0, x24
0x000221ac  bl       #0x55d84   ; CALL _objc_retain
0x000221b0  mov      x0, x22
0x000221b4  mov      w2, #1
0x000221b8  bl       #0x56b80   ; CALL objc_msgSend$buttonWithType:
0x000221bc  mov      x29, x29
0x000221c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000221c4  mov      x22, x0
0x000221c8  adrp     x8, #0x8e000
0x000221cc  ldr      x0, [x8, #0xa78]   ; @CLASS UIImage
0x000221d0  mov      x2, x24
0x000221d4  bl       #0x5d820   ; CALL objc_msgSend$systemImageNamed:
0x000221d8  mov      x29, x29
0x000221dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000221e0  mov      x25, x0
0x000221e4  mov      x0, x24
0x000221e8  bl       #0x55d78   ; CALL _objc_release
0x000221ec  mov      x0, x22
0x000221f0  mov      x2, x25
0x000221f4  mov      x3, #0
0x000221f8  bl       #0x5b0a0   ; CALL objc_msgSend$setImage:forState:
0x000221fc  mov      x0, x25
0x00022200  bl       #0x55d78   ; CALL _objc_release
0x00022204  mov      x0, x22
0x00022208  mov      x2, x23
0x0002220c  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x00022210  mov      x0, x23
0x00022214  bl       #0x55d78   ; CALL _objc_release
0x00022218  mov      x8, #0x4042000000000000
0x0002221c  fmov     d2, x8
0x00022220  fmov     d0, xzr
0x00022224  fmov     d1, xzr
0x00022228  mov      x0, x22
0x0002222c  mov      v3.16b, v2.16b
0x00022230  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00022234  adrp     x1, #0x90000
0x00022238  add      x1, x1, #0x20
0x0002223c  mov      x0, x22
0x00022240  mov      x2, x21
0x00022244  mov      w3, #3
0x00022248  bl       #0x55db4   ; CALL _objc_setAssociatedObject
0x0002224c  mov      x0, x21
0x00022250  bl       #0x55d78   ; CALL _objc_release
0x00022254  mov      x0, x22
0x00022258  mov      x2, x20
0x0002225c  mov      x3, x19
0x00022260  mov      w4, #0x40
0x00022264  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x00022268  mov      x0, x22
0x0002226c  ldp      x29, x30, [sp, #0x40]
0x00022270  ldp      x20, x19, [sp, #0x30]
0x00022274  ldp      x22, x21, [sp, #0x20]
0x00022278  ldp      x24, x23, [sp, #0x10]
0x0002227c  ldp      x26, x25, [sp], #0x50
0x00022280  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCAppBridgeAppsController boxInCell:]  va=0x22284 size=228 types=@24@0:8@16
0x00022284  stp      x22, x21, [sp, #-0x30]!
0x00022288  stp      x20, x19, [sp, #0x10]
0x0002228c  stp      x29, x30, [sp, #0x20]
0x00022290  add      x29, sp, #0x20
0x00022294  mov      x19, x2
0x00022298  mov      x0, x2
0x0002229c  bl       #0x55d84   ; CALL _objc_retain
0x000222a0  mov      x0, x19
0x000222a4  bl       #0x57280   ; CALL objc_msgSend$contentView
0x000222a8  mov      x29, x29
0x000222ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000222b0  mov      x21, x0
0x000222b4  mov      w2, #0x4258
0x000222b8  bl       #0x5df80   ; CALL objc_msgSend$viewWithTag:
0x000222bc  mov      x29, x29
0x000222c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000222c4  mov      x20, x0
0x000222c8  mov      x0, x21
0x000222cc  bl       #0x55d78   ; CALL _objc_release
0x000222d0  cbnz     x20, #0x2234c
0x000222d4  adrp     x8, #0x8e000
0x000222d8  ldr      x0, [x8, #0x918]   ; @CLASS UIView
0x000222dc  bl       #0x55c7c   ; CALL _objc_alloc
0x000222e0  mov      x20, x0
0x000222e4  mov      x0, x19
0x000222e8  bl       #0x57280   ; CALL objc_msgSend$contentView
0x000222ec  mov      x29, x29
0x000222f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000222f4  mov      x21, x0
0x000222f8  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x000222fc  mov      x0, x20
0x00022300  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x00022304  mov      x20, x0
0x00022308  mov      x0, x21
0x0002230c  bl       #0x55d78   ; CALL _objc_release
0x00022310  mov      x0, x20
0x00022314  mov      w2, #0x4258
0x00022318  bl       #0x5c480   ; CALL objc_msgSend$setTag:
0x0002231c  mov      x0, x20
0x00022320  mov      w2, #0x12
0x00022324  bl       #0x5a500   ; CALL objc_msgSend$setAutoresizingMask:
0x00022328  mov      x0, x19
0x0002232c  bl       #0x57280   ; CALL objc_msgSend$contentView
0x00022330  mov      x29, x29
0x00022334  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022338  mov      x21, x0
0x0002233c  mov      x2, x20
0x00022340  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00022344  mov      x0, x21
0x00022348  bl       #0x55d78   ; CALL _objc_release
0x0002234c  mov      x0, x19
0x00022350  bl       #0x55d78   ; CALL _objc_release
0x00022354  mov      x0, x20
0x00022358  ldp      x29, x30, [sp, #0x20]
0x0002235c  ldp      x20, x19, [sp, #0x10]
0x00022360  ldp      x22, x21, [sp], #0x30
0x00022364  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCAppBridgeAppsController layoutTilesIn:width:]  va=0x22368 size=2936 types=d32@0:8@16d24
0x00022368  stp      d15, d14, [sp, #-0xa0]!
0x0002236c  stp      d13, d12, [sp, #0x10]
0x00022370  stp      d11, d10, [sp, #0x20]
0x00022374  stp      d9, d8, [sp, #0x30]
0x00022378  stp      x28, x27, [sp, #0x40]
0x0002237c  stp      x26, x25, [sp, #0x50]
0x00022380  stp      x24, x23, [sp, #0x60]
0x00022384  stp      x22, x21, [sp, #0x70]
0x00022388  stp      x20, x19, [sp, #0x80]
0x0002238c  stp      x29, x30, [sp, #0x90]
0x00022390  add      x29, sp, #0x90
0x00022394  sub      sp, sp, #0x1d0
0x00022398  mov      v8.16b, v0.16b
0x0002239c  mov      x20, x2
0x000223a0  str      x0, [sp, #0xa0]
0x000223a4  adrp     x8, #0x74000
0x000223a8  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000223ac  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000223b0  stur     x8, [x29, #-0xa0]
0x000223b4  mov      x0, x2
0x000223b8  bl       #0x55d84   ; CALL _objc_retain
0x000223bc  adrp     x8, #0x8e000
0x000223c0  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x000223c4  bl       #0x565c0   ; CALL objc_msgSend$array
0x000223c8  mov      x29, x29
0x000223cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000223d0  mov      x21, x0
0x000223d4  mov      x22, #0
0x000223d8  adrp     x19, #0x8e000
0x000223dc  ldr      x0, [x19, #0x928]   ; @CLASS NSNumber
0x000223e0  mov      x2, x22
0x000223e4  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x000223e8  mov      x29, x29
0x000223ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000223f0  mov      x23, x0
0x000223f4  mov      x0, x21
0x000223f8  mov      x2, x23
0x000223fc  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00022400  mov      x0, x23
0x00022404  bl       #0x55d78   ; CALL _objc_release
0x00022408  add      x22, x22, #1
0x0002240c  cmp      x22, #7
0x00022410  b.ne     #0x223dc
0x00022414  adrp     x8, #0x8e000
0x00022418  ldrsw    x8, [x8, #0xe80]
0x0002241c  ldr      x22, [sp, #0xa0]
0x00022420  add      x8, x22, x8
0x00022424  str      x8, [sp, #0xb0]
0x00022428  ldr      x8, [x8]
0x0002242c  cbz      x8, #0x22440
0x00022430  adrp     x2, #0x80000
0x00022434  add      x2, x2, #0x238
0x00022438  mov      x0, x21
0x0002243c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00022440  adrp     x8, #0x8e000
0x00022444  ldrsw    x8, [x8, #0xe84]
0x00022448  add      x8, x22, x8
0x0002244c  str      x8, [sp, #0x10]
0x00022450  ldr      x8, [x8]
0x00022454  cbz      x8, #0x22468
0x00022458  adrp     x2, #0x80000
0x0002245c  add      x2, x2, #0x250
0x00022460  mov      x0, x21
0x00022464  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00022468  mov      x0, x21
0x0002246c  bl       #0x573c0   ; CALL objc_msgSend$count
0x00022470  mov      x19, x0
0x00022474  fmov     d0, #-24.00000000
0x00022478  fadd     d1, d8, d0
0x0002247c  fadd     d0, d1, d0
0x00022480  fmov     d1, #0.25000000
0x00022484  fmul     d0, d0, d1
0x00022488  frintm   d9, d0
0x0002248c  adrp     x8, #0x65000
0x00022490  ldr      d0, [x8, #0x610]
0x00022494  fdiv     d0, d9, d0
0x00022498  frintm   d8, d0
0x0002249c  cbz      x20, #0x22d64
0x000224a0  stp      x19, x20, [sp, #0x90]
0x000224a4  adrp     x8, #0x8e000
0x000224a8  ldrsw    x8, [x8, #0xe88]
0x000224ac  ldr      x8, [x22, x8]
0x000224b0  str      x8, [sp, #0xc8]
0x000224b4  movi     v0.16b, #0
0x000224b8  stp      q0, q0, [sp, #0xf0]
0x000224bc  stp      q0, q0, [sp, #0xd0]
0x000224c0  mov      x0, x20
0x000224c4  bl       #0x5d700   ; CALL objc_msgSend$subviews
0x000224c8  mov      x29, x29
0x000224cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000224d0  mov      x24, x0
0x000224d4  bl       #0x572e0   ; CALL objc_msgSend$copy
0x000224d8  mov      x23, x0
0x000224dc  mov      x0, x24
0x000224e0  bl       #0x55d78   ; CALL _objc_release
0x000224e4  add      x2, sp, #0xd0
0x000224e8  add      x3, sp, #0x140
0x000224ec  mov      x0, x23
0x000224f0  mov      w4, #0x10
0x000224f4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000224f8  cbz      x0, #0x22558
0x000224fc  mov      x24, x0
0x00022500  ldr      x8, [sp, #0xe0]
0x00022504  ldr      x19, [x8]
0x00022508  mov      x20, #0
0x0002250c  ldr      x8, [sp, #0xe0]
0x00022510  ldr      x8, [x8]
0x00022514  cmp      x8, x19
0x00022518  b.eq     #0x22524
0x0002251c  mov      x0, x23
0x00022520  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00022524  ldr      x8, [sp, #0xd8]
0x00022528  ldr      x0, [x8, x20, lsl #3]
0x0002252c  bl       #0x59e00   ; CALL objc_msgSend$removeFromSuperview
0x00022530  add      x20, x20, #1
0x00022534  cmp      x24, x20
0x00022538  b.ne     #0x2250c
0x0002253c  add      x2, sp, #0xd0
0x00022540  add      x3, sp, #0x140
0x00022544  mov      x0, x23
0x00022548  mov      w4, #0x10
0x0002254c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00022550  mov      x24, x0
0x00022554  cbnz     x0, #0x22508
0x00022558  mov      x0, x23
0x0002255c  bl       #0x55d78   ; CALL _objc_release
0x00022560  ldp      x19, x20, [sp, #0x90]
0x00022564  cmp      x19, #1
0x00022568  b.lt     #0x22d64
0x0002256c  mov      x23, #0
0x00022570  fmov     d0, #8.00000000
0x00022574  fadd     d10, d9, d0
0x00022578  fadd     d11, d8, d0
0x0002257c  adrp     x8, #0x74000
0x00022580  ldr      x8, [x8, #0x648]   ; @GOT _kCACornerCurveContinuous
0x00022584  ldr      x9, [x8]   ; @GOT ___objc_personality_v0
0x00022588  adrp     x8, #0x8b000
0x0002258c  ldr      x8, [x8, #0xe90]   ; @SEL "tileTapped:"
0x00022590  stp      x8, x9, [sp, #0xb8]
0x00022594  adrp     x8, #0x74000
0x00022598  ldr      x8, [x8, #0x668]   ; @GOT _kCAGradientLayerConic
0x0002259c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000225a0  str      x8, [sp, #0x88]
0x000225a4  fmov     d12, #12.00000000
0x000225a8  adrp     x8, #0x65000
0x000225ac  ldr      d0, [x8, #0x7a0]
0x000225b0  str      d0, [sp, #0x78]
0x000225b4  adrp     x8, #0x65000
0x000225b8  ldr      d0, [x8, #0x7a8]
0x000225bc  str      d0, [sp, #0x68]
0x000225c0  adrp     x8, #0x65000
0x000225c4  ldr      d0, [x8, #0x7b0]
0x000225c8  str      d0, [sp, #0x58]
0x000225cc  adrp     x8, #0x65000
0x000225d0  ldr      d0, [x8, #0x7b8]
0x000225d4  str      d0, [sp, #0x50]
0x000225d8  adrp     x8, #0x65000
0x000225dc  ldr      d0, [x8, #0x7c0]
0x000225e0  str      d0, [sp, #0x48]
0x000225e4  adrp     x8, #0x65000
0x000225e8  ldr      d0, [x8, #0x7c8]
0x000225ec  str      d0, [sp, #0x40]
0x000225f0  adrp     x8, #0x65000
0x000225f4  ldr      d0, [x8, #0x7d0]
0x000225f8  str      d0, [sp, #0x38]
0x000225fc  adrp     x8, #0x65000
0x00022600  adrp     x9, #0x65000
0x00022604  adrp     x10, #0x65000
0x00022608  adrp     x11, #0x65000
0x0002260c  ldr      d0, [x8, #0x7d8]
0x00022610  str      d0, [sp, #0x30]
0x00022614  ldr      d0, [x9, #0x7e0]
0x00022618  str      d0, [sp, #0x28]
0x0002261c  ldr      d0, [x10, #0x7e8]
0x00022620  str      d0, [sp, #0x20]
0x00022624  adrp     x8, #0x65000
0x00022628  ldr      d0, [x11, #0x7f0]
0x0002262c  str      d0, [sp, #0x18]
0x00022630  ldr      d0, [x8, #0x728]
0x00022634  str      d0, [sp, #8]
0x00022638  str      x21, [sp, #0xa8]
0x0002263c  str      d9, [sp, #0x80]
0x00022640  str      d8, [sp, #0x70]
0x00022644  str      d11, [sp, #0x60]
0x00022648  mov      x0, x21
0x0002264c  mov      x2, x23
0x00022650  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00022654  mov      x29, x29
0x00022658  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002265c  mov      x24, x0
0x00022660  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x00022664  mov      x27, x0
0x00022668  mov      x0, x24
0x0002266c  bl       #0x55d78   ; CALL _objc_release
0x00022670  adrp     x8, #0x8e000
0x00022674  ldr      x0, [x8, #0xa50]   ; @CLASS UIButton
0x00022678  mov      x2, #0
0x0002267c  bl       #0x56b80   ; CALL objc_msgSend$buttonWithType:
0x00022680  mov      x29, x29
0x00022684  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022688  mov      x28, x0
0x0002268c  and      x8, x23, #3
0x00022690  ucvtf    d0, x8
0x00022694  fmadd    d0, d0, d10, d12
0x00022698  lsr      x8, x23, #2
0x0002269c  ucvtf    d1, x8
0x000226a0  fmadd    d1, d1, d11, d12
0x000226a4  mov      v2.16b, v9.16b
0x000226a8  mov      v3.16b, v8.16b
0x000226ac  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x000226b0  mov      x0, x28
0x000226b4  mov      x2, x27
0x000226b8  bl       #0x5c480   ; CALL objc_msgSend$setTag:
0x000226bc  mov      x0, x28
0x000226c0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000226c4  mov      x29, x29
0x000226c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000226cc  mov      x24, x0
0x000226d0  fmov     d0, #10.00000000
0x000226d4  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x000226d8  mov      x0, x24
0x000226dc  bl       #0x55d78   ; CALL _objc_release
0x000226e0  mov      x0, x28
0x000226e4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000226e8  mov      x29, x29
0x000226ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000226f0  mov      x24, x0
0x000226f4  ldr      x2, [sp, #0xc0]
0x000226f8  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x000226fc  mov      x0, x24
0x00022700  bl       #0x55d78   ; CALL _objc_release
0x00022704  mov      x0, x28
0x00022708  mov      w2, #1
0x0002270c  bl       #0x5a8a0   ; CALL objc_msgSend$setClipsToBounds:
0x00022710  cmp      x27, #8
0x00022714  b.eq     #0x228dc
0x00022718  ldr      x8, [sp, #0xb0]
0x0002271c  cmp      x27, #7
0x00022720  b.eq     #0x228e0
0x00022724  cbnz     x27, #0x228f0
0x00022728  adrp     x21, #0x8e000
0x0002272c  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00022730  bl       #0x5d7a0   ; CALL objc_msgSend$systemBackgroundColor
0x00022734  mov      x29, x29
0x00022738  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002273c  mov      x24, x0
0x00022740  mov      x0, x28
0x00022744  mov      x2, x24
0x00022748  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0002274c  mov      x0, x24
0x00022750  bl       #0x55d78   ; CALL _objc_release
0x00022754  mov      x0, x28
0x00022758  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002275c  mov      x29, x29
0x00022760  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022764  mov      x24, x0
0x00022768  fmov     d0, #1.00000000
0x0002276c  bl       #0x5a740   ; CALL objc_msgSend$setBorderWidth:
0x00022770  mov      x0, x24
0x00022774  bl       #0x55d78   ; CALL _objc_release
0x00022778  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x0002277c  fmov     d0, #0.50000000
0x00022780  ldr      d1, [sp, #8]
0x00022784  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x00022788  mov      x29, x29
0x0002278c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022790  mov      x24, x0
0x00022794  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00022798  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002279c  mov      x25, x0
0x000227a0  mov      x0, x28
0x000227a4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000227a8  mov      x29, x29
0x000227ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000227b0  mov      x26, x0
0x000227b4  mov      x2, x25
0x000227b8  bl       #0x5a700   ; CALL objc_msgSend$setBorderColor:
0x000227bc  mov      x0, x26
0x000227c0  bl       #0x55d78   ; CALL _objc_release
0x000227c4  mov      x0, x24
0x000227c8  bl       #0x55d78   ; CALL _objc_release
0x000227cc  adrp     x0, #0x79000
0x000227d0  add      x0, x0, #0xa48   ; STR "HOMESCREEN_WALLPAPER_DEFAULT"
0x000227d4  bl       #0x17e20   ; CALL _L
0x000227d8  mov      x29, x29
0x000227dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000227e0  mov      x24, x0
0x000227e4  mov      x0, x28
0x000227e8  mov      x2, x24
0x000227ec  mov      x3, #0
0x000227f0  bl       #0x5c600   ; CALL objc_msgSend$setTitle:forState:
0x000227f4  mov      x0, x24
0x000227f8  bl       #0x55d78   ; CALL _objc_release
0x000227fc  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00022800  ldr      x21, [sp, #0xa8]
0x00022804  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x00022808  mov      x29, x29
0x0002280c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022810  mov      x24, x0
0x00022814  mov      x0, x28
0x00022818  mov      x2, x24
0x0002281c  mov      x3, #0
0x00022820  bl       #0x5c620   ; CALL objc_msgSend$setTitleColor:forState:
0x00022824  mov      x0, x24
0x00022828  bl       #0x55d78   ; CALL _objc_release
0x0002282c  adrp     x8, #0x8e000
0x00022830  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x00022834  fmov     d0, #12.00000000
0x00022838  bl       #0x5d7c0   ; CALL objc_msgSend$systemFontOfSize:
0x0002283c  mov      x29, x29
0x00022840  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022844  mov      x24, x0
0x00022848  mov      x0, x28
0x0002284c  bl       #0x5db80   ; CALL objc_msgSend$titleLabel
0x00022850  mov      x29, x29
0x00022854  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022858  mov      x25, x0
0x0002285c  mov      x2, x24
0x00022860  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00022864  mov      x0, x25
0x00022868  bl       #0x55d78   ; CALL _objc_release
0x0002286c  mov      x0, x24
0x00022870  bl       #0x55d78   ; CALL _objc_release
0x00022874  mov      x0, x28
0x00022878  bl       #0x5db80   ; CALL objc_msgSend$titleLabel
0x0002287c  mov      x29, x29
0x00022880  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022884  mov      x24, x0
0x00022888  mov      w2, #1
0x0002288c  bl       #0x5a380   ; CALL objc_msgSend$setAdjustsFontSizeToFitWidth:
0x00022890  mov      x0, x24
0x00022894  bl       #0x55d78   ; CALL _objc_release
0x00022898  mov      x0, x28
0x0002289c  bl       #0x5db80   ; CALL objc_msgSend$titleLabel
0x000228a0  mov      x29, x29
0x000228a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000228a8  mov      x24, x0
0x000228ac  mov      w2, #1
0x000228b0  bl       #0x5c4e0   ; CALL objc_msgSend$setTextAlignment:
0x000228b4  mov      x0, x24
0x000228b8  bl       #0x55d78   ; CALL _objc_release
0x000228bc  mov      x0, x28
0x000228c0  bl       #0x5db80   ; CALL objc_msgSend$titleLabel
0x000228c4  mov      x29, x29
0x000228c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000228cc  mov      x24, x0
0x000228d0  mov      w2, #2
0x000228d4  bl       #0x5b820   ; CALL objc_msgSend$setNumberOfLines:
0x000228d8  b        #0x229e0
0x000228dc  ldr      x8, [sp, #0x10]
0x000228e0  ldr      x24, [x8]   ; @SEL "whatsNewNavigationController"
0x000228e4  mov      x0, x24
0x000228e8  bl       #0x55d84   ; CALL _objc_retain
0x000228ec  b        #0x22934
0x000228f0  adrp     x8, #0x8e000
0x000228f4  ldr      x0, [x8, #0xb40]   ; @CLASS UIScreen
0x000228f8  bl       #0x58f00   ; CALL objc_msgSend$mainScreen
0x000228fc  mov      x29, x29
0x00022900  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022904  mov      x25, x0
0x00022908  bl       #0x5a060   ; CALL objc_msgSend$scale
0x0002290c  mov      v2.16b, v0.16b
0x00022910  mov      x0, x27
0x00022914  mov      v0.16b, v9.16b
0x00022918  mov      v1.16b, v8.16b
0x0002291c  bl       #0x22df0
0x00022920  mov      x29, x29
0x00022924  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022928  mov      x24, x0
0x0002292c  mov      x0, x25
0x00022930  bl       #0x55d78   ; CALL _objc_release
0x00022934  mov      x0, x28
0x00022938  mov      x2, x24
0x0002293c  mov      x3, #0
0x00022940  bl       #0x5a580   ; CALL objc_msgSend$setBackgroundImage:forState:
0x00022944  mov      x0, x28
0x00022948  bl       #0x58120   ; CALL objc_msgSend$imageView
0x0002294c  mov      x29, x29
0x00022950  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022954  mov      x25, x0
0x00022958  mov      w2, #2
0x0002295c  bl       #0x5aa40   ; CALL objc_msgSend$setContentMode:
0x00022960  mov      x0, x25
0x00022964  bl       #0x55d78   ; CALL _objc_release
0x00022968  mov      x0, x28
0x0002296c  mov      w2, #2
0x00022970  bl       #0x5aa40   ; CALL objc_msgSend$setContentMode:
0x00022974  cmp      x27, #8
0x00022978  b.ne     #0x229e0
0x0002297c  adrp     x8, #0x8e000
0x00022980  ldr      x0, [x8, #0xa78]   ; @CLASS UIImage
0x00022984  adrp     x2, #0x79000
0x00022988  add      x2, x2, #0xa68   ; STR "play.circle.fill"
0x0002298c  bl       #0x5d820   ; CALL objc_msgSend$systemImageNamed:
0x00022990  mov      x29, x29
0x00022994  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022998  mov      x25, x0
0x0002299c  mov      x0, x28
0x000229a0  mov      x2, x25
0x000229a4  mov      x3, #0
0x000229a8  bl       #0x5b0a0   ; CALL objc_msgSend$setImage:forState:
0x000229ac  mov      x0, x25
0x000229b0  bl       #0x55d78   ; CALL _objc_release
0x000229b4  adrp     x8, #0x8e000
0x000229b8  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x000229bc  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x000229c0  mov      x29, x29
0x000229c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000229c8  mov      x25, x0
0x000229cc  mov      x0, x28
0x000229d0  mov      x2, x25
0x000229d4  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x000229d8  mov      x0, x25
0x000229dc  bl       #0x55d78   ; CALL _objc_release
0x000229e0  mov      x0, x24
0x000229e4  bl       #0x55d78   ; CALL _objc_release
0x000229e8  mov      x0, x28
0x000229ec  mov      x2, x22
0x000229f0  ldr      x3, [sp, #0xb8]
0x000229f4  mov      w4, #0x40
0x000229f8  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x000229fc  mov      x0, x20
0x00022a00  mov      x2, x28
0x00022a04  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00022a08  ldr      x8, [sp, #0xc8]
0x00022a0c  cmp      x27, x8
0x00022a10  b.ne     #0x22d50
0x00022a14  mov      x0, x28
0x00022a18  bl       #0x57d00   ; CALL objc_msgSend$frame
0x00022a1c  fmov     d4, #-3.00000000
0x00022a20  fmov     d5, #-3.00000000
0x00022a24  bl       #0x55a90   ; CALL _CGRectInset
0x00022a28  mov      v15.16b, v0.16b
0x00022a2c  mov      v13.16b, v1.16b
0x00022a30  mov      v14.16b, v2.16b
0x00022a34  mov      v11.16b, v10.16b
0x00022a38  mov      v10.16b, v3.16b
0x00022a3c  adrp     x8, #0x8e000
0x00022a40  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x00022a44  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00022a48  mov      x29, x29
0x00022a4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022a50  mov      x27, x0
0x00022a54  ldr      x2, [sp, #0x88]
0x00022a58  bl       #0x5c6e0   ; CALL objc_msgSend$setType:
0x00022a5c  mov      x0, x27
0x00022a60  mov      v0.16b, v15.16b
0x00022a64  mov      v1.16b, v13.16b
0x00022a68  mov      v2.16b, v14.16b
0x00022a6c  mov      v3.16b, v10.16b
0x00022a70  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00022a74  fmov     d0, #0.50000000
0x00022a78  fmov     d1, #0.50000000
0x00022a7c  mov      x0, x27
0x00022a80  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x00022a84  fmov     d0, xzr
0x00022a88  fmov     d1, #1.00000000
0x00022a8c  mov      x0, x27
0x00022a90  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x00022a94  adrp     x21, #0x8e000
0x00022a98  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00022a9c  fmov     d3, #1.00000000
0x00022aa0  ldr      d12, [sp, #0x78]
0x00022aa4  mov      v0.16b, v12.16b
0x00022aa8  ldr      d9, [sp, #0x68]
0x00022aac  mov      v1.16b, v9.16b
0x00022ab0  ldr      d8, [sp, #0x58]
0x00022ab4  mov      v2.16b, v8.16b
0x00022ab8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00022abc  mov      x29, x29
0x00022ac0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022ac4  mov      x26, x0
0x00022ac8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00022acc  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00022ad0  str      x0, [sp, #0x118]
0x00022ad4  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00022ad8  fmov     d3, #1.00000000
0x00022adc  ldp      d1, d0, [sp, #0x48]
0x00022ae0  mov      v2.16b, v8.16b
0x00022ae4  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00022ae8  mov      x29, x29
0x00022aec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022af0  mov      x24, x0
0x00022af4  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00022af8  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00022afc  str      x0, [sp, #0x120]
0x00022b00  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00022b04  fmov     d3, #1.00000000
0x00022b08  ldp      d1, d0, [sp, #0x38]
0x00022b0c  ldr      d2, [sp, #0x30]
0x00022b10  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00022b14  mov      x29, x29
0x00022b18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022b1c  mov      x25, x0
0x00022b20  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00022b24  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00022b28  str      x0, [sp, #0x128]
0x00022b2c  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00022b30  fmov     d3, #1.00000000
0x00022b34  ldp      d1, d0, [sp, #0x20]
0x00022b38  ldr      d2, [sp, #0x18]
0x00022b3c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00022b40  mov      x29, x29
0x00022b44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022b48  mov      x20, x0
0x00022b4c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00022b50  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00022b54  str      x0, [sp, #0x130]
0x00022b58  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00022b5c  fmov     d3, #1.00000000
0x00022b60  mov      v0.16b, v12.16b
0x00022b64  mov      v1.16b, v9.16b
0x00022b68  mov      v2.16b, v8.16b
0x00022b6c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00022b70  mov      x29, x29
0x00022b74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022b78  mov      x22, x0
0x00022b7c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00022b80  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00022b84  str      x0, [sp, #0x138]
0x00022b88  adrp     x8, #0x8e000
0x00022b8c  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00022b90  add      x2, sp, #0x118
0x00022b94  mov      w3, #5
0x00022b98  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00022b9c  mov      x29, x29
0x00022ba0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022ba4  mov      x19, x0
0x00022ba8  mov      x0, x27
0x00022bac  mov      x2, x19
0x00022bb0  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x00022bb4  mov      x0, x19
0x00022bb8  bl       #0x55d78   ; CALL _objc_release
0x00022bbc  mov      x0, x22
0x00022bc0  ldr      x22, [sp, #0xa0]
0x00022bc4  bl       #0x55d78   ; CALL _objc_release
0x00022bc8  mov      x0, x20
0x00022bcc  bl       #0x55d78   ; CALL _objc_release
0x00022bd0  mov      x0, x25
0x00022bd4  bl       #0x55d78   ; CALL _objc_release
0x00022bd8  mov      x0, x24
0x00022bdc  bl       #0x55d78   ; CALL _objc_release
0x00022be0  mov      x0, x26
0x00022be4  bl       #0x55d78   ; CALL _objc_release
0x00022be8  adrp     x8, #0x8e000
0x00022bec  ldr      x0, [x8, #0xb48]   ; @CLASS CAShapeLayer
0x00022bf0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00022bf4  mov      x29, x29
0x00022bf8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022bfc  mov      x26, x0
0x00022c00  adrp     x8, #0x8e000
0x00022c04  ldr      x19, [x8, #0xac0]   ; @CLASS UIBezierPath
0x00022c08  fmov     d0, xzr
0x00022c0c  fmov     d1, xzr
0x00022c10  fmov     d4, #1.00000000
0x00022c14  fmov     d5, #1.00000000
0x00022c18  mov      v2.16b, v14.16b
0x00022c1c  mov      v3.16b, v10.16b
0x00022c20  bl       #0x55a90   ; CALL _CGRectInset
0x00022c24  fmov     d4, #12.00000000
0x00022c28  mov      x0, x19
0x00022c2c  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x00022c30  mov      x29, x29
0x00022c34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022c38  mov      x19, x0
0x00022c3c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00022c40  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x00022c44  mov      x2, x0
0x00022c48  mov      x0, x26
0x00022c4c  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x00022c50  mov      x0, x19
0x00022c54  bl       #0x55d78   ; CALL _objc_release
0x00022c58  mov      x0, x26
0x00022c5c  mov      x2, #0
0x00022c60  bl       #0x5ae40   ; CALL objc_msgSend$setFillColor:
0x00022c64  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00022c68  ldr      x21, [sp, #0xa8]
0x00022c6c  bl       #0x56940   ; CALL objc_msgSend$blackColor
0x00022c70  mov      x29, x29
0x00022c74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022c78  mov      x19, x0
0x00022c7c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00022c80  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00022c84  mov      x2, x0
0x00022c88  mov      x0, x26
0x00022c8c  bl       #0x5c380   ; CALL objc_msgSend$setStrokeColor:
0x00022c90  mov      x0, x19
0x00022c94  bl       #0x55d78   ; CALL _objc_release
0x00022c98  fmov     d0, #2.00000000
0x00022c9c  mov      x0, x26
0x00022ca0  bl       #0x5b3a0   ; CALL objc_msgSend$setLineWidth:
0x00022ca4  mov      x0, x27
0x00022ca8  mov      x2, x26
0x00022cac  bl       #0x5b4c0   ; CALL objc_msgSend$setMask:
0x00022cb0  adrp     x8, #0x8e000
0x00022cb4  ldr      x0, [x8, #0x918]   ; @CLASS UIView
0x00022cb8  bl       #0x55c7c   ; CALL _objc_alloc
0x00022cbc  mov      v0.16b, v15.16b
0x00022cc0  mov      v1.16b, v13.16b
0x00022cc4  mov      v2.16b, v14.16b
0x00022cc8  mov      v3.16b, v10.16b
0x00022ccc  mov      v10.16b, v11.16b
0x00022cd0  ldr      d11, [sp, #0x60]
0x00022cd4  ldr      d8, [sp, #0x70]
0x00022cd8  ldr      d9, [sp, #0x80]
0x00022cdc  fmov     d12, #12.00000000
0x00022ce0  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x00022ce4  mov      x19, x0
0x00022ce8  mov      w2, #0
0x00022cec  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x00022cf0  mov      x0, x19
0x00022cf4  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00022cf8  mov      x0, x27
0x00022cfc  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00022d00  mov      x0, x19
0x00022d04  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00022d08  mov      x29, x29
0x00022d0c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022d10  mov      x20, x0
0x00022d14  mov      x2, x27
0x00022d18  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x00022d1c  mov      x0, x20
0x00022d20  ldr      x20, [sp, #0x98]
0x00022d24  bl       #0x55d78   ; CALL _objc_release
0x00022d28  mov      x0, x20
0x00022d2c  mov      x2, x19
0x00022d30  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00022d34  mov      x0, x19
0x00022d38  ldr      x19, [sp, #0x90]
0x00022d3c  bl       #0x55d78   ; CALL _objc_release
0x00022d40  mov      x0, x26
0x00022d44  bl       #0x55d78   ; CALL _objc_release
0x00022d48  mov      x0, x27
0x00022d4c  bl       #0x55d78   ; CALL _objc_release
0x00022d50  mov      x0, x28
0x00022d54  bl       #0x55d78   ; CALL _objc_release
0x00022d58  add      x23, x23, #1
0x00022d5c  cmp      x19, x23
0x00022d60  b.ne     #0x22648
0x00022d64  adds     x8, x19, #3
0x00022d68  add      x9, x19, #6
0x00022d6c  csel     x19, x9, x8, lt
0x00022d70  mov      x0, x21
0x00022d74  bl       #0x55d78   ; CALL _objc_release
0x00022d78  mov      x0, x20
0x00022d7c  bl       #0x55d78   ; CALL _objc_release
0x00022d80  ldur     x8, [x29, #-0xa0]
0x00022d84  adrp     x9, #0x74000
0x00022d88  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00022d8c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00022d90  cmp      x9, x8
0x00022d94  b.ne     #0x22dec
0x00022d98  asr      x8, x19, #2
0x00022d9c  sub      x9, x8, #1
0x00022da0  scvtf    d0, x9
0x00022da4  scvtf    d1, x8
0x00022da8  fmul     d1, d8, d1
0x00022dac  fmov     d2, #24.00000000
0x00022db0  fadd     d1, d1, d2
0x00022db4  fmov     d2, #8.00000000
0x00022db8  fmadd    d0, d0, d2, d1
0x00022dbc  add      sp, sp, #0x1d0
0x00022dc0  ldp      x29, x30, [sp, #0x90]
0x00022dc4  ldp      x20, x19, [sp, #0x80]
0x00022dc8  ldp      x22, x21, [sp, #0x70]
0x00022dcc  ldp      x24, x23, [sp, #0x60]
0x00022dd0  ldp      x26, x25, [sp, #0x50]
0x00022dd4  ldp      x28, x27, [sp, #0x40]
0x00022dd8  ldp      d9, d8, [sp, #0x30]
0x00022ddc  ldp      d11, d10, [sp, #0x20]
0x00022de0  ldp      d13, d12, [sp, #0x10]
0x00022de4  ldp      d15, d14, [sp], #0xa0
0x00022de8  ret      
0x00022dec  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00022df0  sub      sp, sp, #0x90
0x00022df4  stp      d11, d10, [sp, #0x40]
0x00022df8  stp      d9, d8, [sp, #0x50]
0x00022dfc  stp      x22, x21, [sp, #0x60]
0x00022e00  stp      x20, x19, [sp, #0x70]
0x00022e04  stp      x29, x30, [sp, #0x80]
0x00022e08  add      x29, sp, #0x80
0x00022e0c  mov      v8.16b, v2.16b
0x00022e10  mov      v9.16b, v1.16b
0x00022e14  mov      v10.16b, v0.16b
0x00022e18  mov      x19, x0
0x00022e1c  adrp     x8, #0x8e000
0x00022e20  ldr      x0, [x8, #0xb58]   ; @CLASS UIGraphicsImageRendererFormat
0x00022e24  bl       #0x59920   ; CALL objc_msgSend$preferredFormat
0x00022e28  mov      x29, x29
0x00022e2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022e30  mov      x20, x0
0x00022e34  mov      v0.16b, v8.16b
0x00022e38  bl       #0x5bee0   ; CALL objc_msgSend$setScale:
0x00022e3c  mov      x0, x20
0x00022e40  mov      w2, #1
0x00022e44  bl       #0x5b960   ; CALL objc_msgSend$setOpaque:
0x00022e48  adrp     x8, #0x8e000
0x00022e4c  ldr      x0, [x8, #0xb00]   ; @CLASS UIGraphicsImageRenderer
0x00022e50  bl       #0x55c7c   ; CALL _objc_alloc
0x00022e54  mov      v0.16b, v10.16b
0x00022e58  mov      v1.16b, v9.16b
0x00022e5c  mov      x2, x20
0x00022e60  bl       #0x58560   ; CALL objc_msgSend$initWithSize:format:
0x00022e64  mov      x21, x0
0x00022e68  adrp     x8, #0x74000
0x00022e6c  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00022e70  str      x8, [sp, #8]
0x00022e74  adrp     x8, #0x65000
0x00022e78  ldr      d0, [x8, #0x6f8]
0x00022e7c  adrp     x8, #0x25000
0x00022e80  add      x8, x8, #0x150
0x00022e84  adrp     x9, #0x74000
0x00022e88  add      x9, x9, #0xb30
0x00022e8c  str      d0, [sp, #0x10]
0x00022e90  stp      x8, x9, [sp, #0x18]
0x00022e94  str      x19, [sp, #0x28]
0x00022e98  stp      d10, d9, [sp, #0x30]
0x00022e9c  add      x2, sp, #8
0x00022ea0  bl       #0x58140   ; CALL objc_msgSend$imageWithActions:
0x00022ea4  mov      x29, x29
0x00022ea8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022eac  mov      x19, x0
0x00022eb0  mov      x0, x21
0x00022eb4  bl       #0x55d78   ; CALL _objc_release
0x00022eb8  mov      x0, x20
0x00022ebc  bl       #0x55d78   ; CALL _objc_release
0x00022ec0  mov      x0, x19
0x00022ec4  ldp      x29, x30, [sp, #0x80]
0x00022ec8  ldp      x20, x19, [sp, #0x70]
0x00022ecc  ldp      x22, x21, [sp, #0x60]
0x00022ed0  ldp      d9, d8, [sp, #0x50]
0x00022ed4  ldp      d11, d10, [sp, #0x40]
0x00022ed8  add      sp, sp, #0x90
0x00022edc  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCAppBridgeAppsController tileTapped:]  va=0x22ee0 size=44 types=v24@0:8@16
0x00022ee0  stp      x20, x19, [sp, #-0x20]!
0x00022ee4  stp      x29, x30, [sp, #0x10]
0x00022ee8  add      x29, sp, #0x10
0x00022eec  mov      x19, x0
0x00022ef0  mov      x0, x2
0x00022ef4  bl       #0x5d920   ; CALL objc_msgSend$tag
0x00022ef8  mov      x2, x0
0x00022efc  mov      x0, x19
0x00022f00  ldp      x29, x30, [sp, #0x10]
0x00022f04  ldp      x20, x19, [sp], #0x20
0x00022f08  b        #0x5de00   ; CALL objc_msgSend$useStyle:

=== -[OMCAppBridgeAppsController useStyle:]  va=0x22f0c size=724 types=v24@0:8q16
0x00022f0c  stp      x28, x27, [sp, #-0x50]!
0x00022f10  stp      x24, x23, [sp, #0x10]
0x00022f14  stp      x22, x21, [sp, #0x20]
0x00022f18  stp      x20, x19, [sp, #0x30]
0x00022f1c  stp      x29, x30, [sp, #0x40]
0x00022f20  add      x29, sp, #0x40
0x00022f24  sub      sp, sp, #0x410
0x00022f28  mov      x20, x2
0x00022f2c  mov      x19, x0
0x00022f30  adrp     x8, #0x74000
0x00022f34  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00022f38  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00022f3c  stur     x8, [x29, #-0x48]
0x00022f40  cmp      x2, #8
0x00022f44  b.eq     #0x22fb0
0x00022f48  cmp      x20, #7
0x00022f4c  b.eq     #0x22fa4
0x00022f50  cbnz     x20, #0x22fd0
0x00022f54  adrp     x8, #0x8e000
0x00022f58  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x00022f5c  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x00022f60  mov      x29, x29
0x00022f64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022f68  mov      x20, x0
0x00022f6c  adrp     x0, #0x79000
0x00022f70  add      x0, x0, #0x248   ; STR "/var/mobile/Library/OmniCar"
0x00022f74  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00022f78  add      x1, sp, #8
0x00022f7c  bl       #0x4118
0x00022f80  cbz      x0, #0x2303c
0x00022f84  mov      x2, x0
0x00022f88  adrp     x8, #0x8e000
0x00022f8c  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00022f90  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00022f94  mov      x29, x29
0x00022f98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022f9c  mov      x21, x0
0x00022fa0  b        #0x23040
0x00022fa4  adrp     x8, #0x8e000
0x00022fa8  add      x8, x8, #0xe80
0x00022fac  b        #0x22fb8
0x00022fb0  adrp     x8, #0x8e000
0x00022fb4  add      x8, x8, #0xe84
0x00022fb8  ldrsw    x8, [x8]
0x00022fbc  ldr      x21, [x19, x8]
0x00022fc0  mov      x0, x21
0x00022fc4  bl       #0x55d84   ; CALL _objc_retain
0x00022fc8  cbnz     x21, #0x22ffc
0x00022fcc  b        #0x231a0
0x00022fd0  mov      x8, #0x409e000000000000
0x00022fd4  fmov     d0, x8
0x00022fd8  adrp     x8, #0x65000
0x00022fdc  ldr      d1, [x8, #0x7f8]
0x00022fe0  fmov     d2, #1.00000000
0x00022fe4  mov      x0, x20
0x00022fe8  bl       #0x22df0
0x00022fec  mov      x29, x29
0x00022ff0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00022ff4  mov      x21, x0
0x00022ff8  cbz      x21, #0x231a0
0x00022ffc  cmp      x20, #8
0x00023000  b.eq     #0x2310c
0x00023004  adrp     x0, #0x79000
0x00023008  add      x0, x0, #0x248   ; STR "/var/mobile/Library/OmniCar"
0x0002300c  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00023010  add      x1, sp, #8
0x00023014  bl       #0x4118
0x00023018  cbz      x0, #0x230c4
0x0002301c  mov      x2, x0
0x00023020  adrp     x8, #0x8e000
0x00023024  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00023028  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0002302c  mov      x29, x29
0x00023030  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023034  mov      x22, x0
0x00023038  b        #0x230c8
0x0002303c  mov      x21, #0
0x00023040  adrp     x2, #0x79000
0x00023044  add      x2, x2, #0x308   ; STR "HomeScreen/wallpaper.jpg"
0x00023048  mov      x0, x21
0x0002304c  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00023050  mov      x29, x29
0x00023054  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023058  mov      x22, x0
0x0002305c  mov      x0, x20
0x00023060  mov      x2, x22
0x00023064  mov      x3, #0
0x00023068  bl       #0x59e20   ; CALL objc_msgSend$removeItemAtPath:error:
0x0002306c  mov      x0, x22
0x00023070  bl       #0x55d78   ; CALL _objc_release
0x00023074  mov      x0, x21
0x00023078  bl       #0x55d78   ; CALL _objc_release
0x0002307c  mov      x0, x20
0x00023080  bl       #0x55d78   ; CALL _objc_release
0x00023084  adrp     x8, #0x8e000
0x00023088  ldrsw    x8, [x8, #0xe8c]
0x0002308c  ldr      x0, [x19, x8]
0x00023090  str      xzr, [x19, x8]
0x00023094  bl       #0x55d78   ; CALL _objc_release
0x00023098  adrp     x8, #0x8e000
0x0002309c  ldrsw    x8, [x8, #0xe88]
0x000230a0  str      xzr, [x19, x8]
0x000230a4  adrp     x0, #0x79000
0x000230a8  add      x0, x0, #0x2e8   ; STR "homeScreenWallpaperStyle"
0x000230ac  adrp     x1, #0x80000
0x000230b0  add      x1, x1, #0x1d8
0x000230b4  bl       #0x21eb8
0x000230b8  adrp     x1, #0x74000
0x000230bc  ldr      x1, [x1, #0x1b0]   ; @GOT ___kCFBooleanFalse
0x000230c0  b        #0x2317c
0x000230c4  mov      x22, #0
0x000230c8  adrp     x2, #0x79000
0x000230cc  add      x2, x2, #0x308   ; STR "HomeScreen/wallpaper.jpg"
0x000230d0  mov      x0, x22
0x000230d4  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x000230d8  mov      x29, x29
0x000230dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000230e0  mov      x23, x0
0x000230e4  mov      x0, x19
0x000230e8  mov      x2, x21
0x000230ec  mov      x3, x23
0x000230f0  bl       #0x5e200   ; CALL objc_msgSend$writeJPEG:to:
0x000230f4  mov      x24, x0
0x000230f8  mov      x0, x23
0x000230fc  bl       #0x55d78   ; CALL _objc_release
0x00023100  mov      x0, x22
0x00023104  bl       #0x55d78   ; CALL _objc_release
0x00023108  tbz      w24, #0, #0x231a0
0x0002310c  adrp     x8, #0x8e000
0x00023110  ldrsw    x8, [x8, #0xe8c]
0x00023114  ldr      x22, [x19, x8]
0x00023118  str      x21, [x19, x8]
0x0002311c  mov      x0, x21
0x00023120  bl       #0x55d84   ; CALL _objc_retain
0x00023124  mov      x0, x22
0x00023128  bl       #0x55d78   ; CALL _objc_release
0x0002312c  adrp     x8, #0x8e000
0x00023130  ldrsw    x8, [x8, #0xe88]
0x00023134  str      x20, [x19, x8]
0x00023138  adrp     x8, #0x8e000
0x0002313c  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x00023140  mov      x2, x20
0x00023144  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x00023148  mov      x29, x29
0x0002314c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023150  mov      x20, x0
0x00023154  mov      x0, x21
0x00023158  bl       #0x55d78   ; CALL _objc_release
0x0002315c  adrp     x0, #0x79000
0x00023160  add      x0, x0, #0x2e8   ; STR "homeScreenWallpaperStyle"
0x00023164  mov      x1, x20
0x00023168  bl       #0x21eb8
0x0002316c  mov      x0, x20
0x00023170  bl       #0x55d78   ; CALL _objc_release
0x00023174  adrp     x1, #0x74000
0x00023178  ldr      x1, [x1, #0x1b8]   ; @GOT ___kCFBooleanTrue
0x0002317c  adrp     x0, #0x79000
0x00023180  add      x0, x0, #0x2c8   ; STR "homeScreenWallpaper"
0x00023184  bl       #0x21eb8
0x00023188  mov      x0, x19
0x0002318c  mov      w2, #4
0x00023190  bl       #0x59c80   ; CALL objc_msgSend$reloadCard:
0x00023194  mov      x0, x19
0x00023198  bl       #0x5dd80   ; CALL objc_msgSend$updatePreview
0x0002319c  b        #0x231a8
0x000231a0  mov      x0, x21
0x000231a4  bl       #0x55d78   ; CALL _objc_release
0x000231a8  ldur     x8, [x29, #-0x48]
0x000231ac  adrp     x9, #0x74000
0x000231b0  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000231b4  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000231b8  cmp      x9, x8
0x000231bc  b.ne     #0x231dc
0x000231c0  add      sp, sp, #0x410
0x000231c4  ldp      x29, x30, [sp, #0x40]
0x000231c8  ldp      x20, x19, [sp, #0x30]
0x000231cc  ldp      x22, x21, [sp, #0x20]
0x000231d0  ldp      x24, x23, [sp, #0x10]
0x000231d4  ldp      x28, x27, [sp], #0x50
0x000231d8  ret      
0x000231dc  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCAppBridgeAppsController pickPhoto]  va=0x231e0 size=328 types=v16@0:8
0x000231e0  sub      sp, sp, #0x60
0x000231e4  stp      x24, x23, [sp, #0x20]
0x000231e8  stp      x22, x21, [sp, #0x30]
0x000231ec  stp      x20, x19, [sp, #0x40]
0x000231f0  stp      x29, x30, [sp, #0x50]
0x000231f4  add      x29, sp, #0x50
0x000231f8  mov      x19, x0
0x000231fc  adrp     x8, #0x74000
0x00023200  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00023204  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00023208  str      x8, [sp, #0x18]
0x0002320c  adrp     x20, #0x8e000
0x00023210  ldr      x0, [x20, #0xb50]   ; @CLASS UIImagePickerController
0x00023214  mov      x2, #0
0x00023218  bl       #0x58900   ; CALL objc_msgSend$isSourceTypeAvailable:
0x0002321c  cbz      w0, #0x232f4
0x00023220  ldr      x0, [x20, #0xb50]   ; @CLASS UIImagePickerController
0x00023224  bl       #0x55d60   ; CALL _objc_opt_new
0x00023228  mov      x20, x0
0x0002322c  mov      x2, #0
0x00023230  bl       #0x5c200   ; CALL objc_msgSend$setSourceType:
0x00023234  adrp     x8, #0x74000
0x00023238  ldr      x8, [x8, #0x310]   ; @GOT _UTTypeImage
0x0002323c  ldr      x0, [x8]   ; @GOT ___objc_personality_v0
0x00023240  bl       #0x58060   ; CALL objc_msgSend$identifier
0x00023244  mov      x29, x29
0x00023248  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002324c  mov      x21, x0
0x00023250  str      x0, [sp, #8]
0x00023254  adrp     x8, #0x74000
0x00023258  ldr      x8, [x8, #0x318]   ; @GOT _UTTypeMovie
0x0002325c  ldr      x0, [x8]   ; @GOT ___objc_personality_v0
0x00023260  bl       #0x58060   ; CALL objc_msgSend$identifier
0x00023264  mov      x29, x29
0x00023268  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002326c  mov      x22, x0
0x00023270  str      x0, [sp, #0x10]
0x00023274  adrp     x8, #0x8e000
0x00023278  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0002327c  add      x2, sp, #8
0x00023280  mov      w3, #2
0x00023284  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00023288  mov      x29, x29
0x0002328c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023290  mov      x23, x0
0x00023294  mov      x0, x20
0x00023298  mov      x2, x23
0x0002329c  bl       #0x5b5a0   ; CALL objc_msgSend$setMediaTypes:
0x000232a0  mov      x0, x23
0x000232a4  bl       #0x55d78   ; CALL _objc_release
0x000232a8  mov      x0, x22
0x000232ac  bl       #0x55d78   ; CALL _objc_release
0x000232b0  mov      x0, x21
0x000232b4  bl       #0x55d78   ; CALL _objc_release
0x000232b8  adrp     x8, #0x74000
0x000232bc  ldr      x8, [x8, #0x2d8]   ; @GOT _AVAssetExportPresetPassthrough
0x000232c0  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x000232c4  mov      x0, x20
0x000232c8  bl       #0x5c800   ; CALL objc_msgSend$setVideoExportPreset:
0x000232cc  mov      x0, x20
0x000232d0  mov      x2, x19
0x000232d4  bl       #0x5aca0   ; CALL objc_msgSend$setDelegate:
0x000232d8  mov      x0, x19
0x000232dc  mov      x2, x20
0x000232e0  mov      w3, #1
0x000232e4  mov      x4, #0
0x000232e8  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x000232ec  mov      x0, x20
0x000232f0  bl       #0x55d78   ; CALL _objc_release
0x000232f4  ldr      x8, [sp, #0x18]
0x000232f8  adrp     x9, #0x74000
0x000232fc  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00023300  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00023304  cmp      x9, x8
0x00023308  b.ne     #0x23324
0x0002330c  ldp      x29, x30, [sp, #0x50]
0x00023310  ldp      x20, x19, [sp, #0x40]
0x00023314  ldp      x22, x21, [sp, #0x30]
0x00023318  ldp      x24, x23, [sp, #0x20]
0x0002331c  add      sp, sp, #0x60
0x00023320  ret      
0x00023324  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCAppBridgeAppsController writeJPEG:to:]  va=0x23328 size=476 types=B32@0:8@16@24
0x00023328  sub      sp, sp, #0x60
0x0002332c  stp      x24, x23, [sp, #0x20]
0x00023330  stp      x22, x21, [sp, #0x30]
0x00023334  stp      x20, x19, [sp, #0x40]
0x00023338  stp      x29, x30, [sp, #0x50]
0x0002333c  add      x29, sp, #0x50
0x00023340  mov      x19, x3
0x00023344  mov      x20, x2
0x00023348  mov      x21, x0
0x0002334c  adrp     x8, #0x74000
0x00023350  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00023354  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00023358  str      x8, [sp, #0x18]
0x0002335c  mov      x0, x3
0x00023360  bl       #0x55d84   ; CALL _objc_retain
0x00023364  adrp     x8, #0x65000
0x00023368  ldr      d0, [x8, #0x6d0]
0x0002336c  mov      x0, x20
0x00023370  bl       #0x55b44   ; CALL _UIImageJPEGRepresentation
0x00023374  mov      x29, x29
0x00023378  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002337c  mov      x20, x0
0x00023380  adrp     x24, #0x8e000
0x00023384  ldr      x0, [x24, #0x990]   ; @CLASS NSFileManager
0x00023388  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x0002338c  mov      x29, x29
0x00023390  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023394  mov      x22, x0
0x00023398  mov      x0, x19
0x0002339c  bl       #0x5d460   ; CALL objc_msgSend$stringByDeletingLastPathComponent
0x000233a0  mov      x29, x29
0x000233a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000233a8  mov      x23, x0
0x000233ac  mov      x0, x22
0x000233b0  mov      x2, x23
0x000233b4  mov      w3, #1
0x000233b8  mov      x4, #0
0x000233bc  mov      x5, #0
0x000233c0  bl       #0x57400   ; CALL objc_msgSend$createDirectoryAtPath:withIntermediateDirectories:attributes:error:
0x000233c4  mov      x0, x23
0x000233c8  bl       #0x55d78   ; CALL _objc_release
0x000233cc  mov      x0, x22
0x000233d0  bl       #0x55d78   ; CALL _objc_release
0x000233d4  cbz      x20, #0x23478
0x000233d8  str      xzr, [sp]
0x000233dc  mov      x4, sp
0x000233e0  mov      x0, x20
0x000233e4  mov      x2, x19
0x000233e8  mov      w3, #1
0x000233ec  bl       #0x5e260   ; CALL objc_msgSend$writeToFile:options:error:
0x000233f0  mov      x23, x0
0x000233f4  ldr      x22, [sp]
0x000233f8  mov      x0, x22
0x000233fc  bl       #0x55d84   ; CALL _objc_retain
0x00023400  tbz      w23, #0, #0x2347c
0x00023404  ldr      x0, [x24, #0x990]   ; @CLASS NSFileManager
0x00023408  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x0002340c  mov      x29, x29
0x00023410  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023414  mov      x23, x0
0x00023418  adrp     x8, #0x74000
0x0002341c  ldr      x8, [x8, #0x120]   ; @GOT _NSFilePosixPermissions
0x00023420  ldr      x9, [x8]   ; @GOT ___objc_personality_v0
0x00023424  adrp     x8, #0x80000
0x00023428  add      x8, x8, #0x298
0x0002342c  stp      x9, x8, [sp, #8]
0x00023430  adrp     x8, #0x8e000
0x00023434  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00023438  mov      w21, #1
0x0002343c  add      x2, sp, #0x10
0x00023440  add      x3, sp, #8
0x00023444  mov      w4, #1
0x00023448  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0002344c  mov      x29, x29
0x00023450  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023454  mov      x24, x0
0x00023458  mov      x0, x23
0x0002345c  mov      x2, x24
0x00023460  mov      x3, x19
0x00023464  mov      x4, #0
0x00023468  bl       #0x5a4e0   ; CALL objc_msgSend$setAttributes:ofItemAtPath:error:
0x0002346c  mov      x0, x24
0x00023470  bl       #0x55d78   ; CALL _objc_release
0x00023474  b        #0x234ac
0x00023478  mov      x22, #0
0x0002347c  mov      x0, x22
0x00023480  bl       #0x58dc0   ; CALL objc_msgSend$localizedDescription
0x00023484  mov      x29, x29
0x00023488  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002348c  mov      x23, x0
0x00023490  adrp     x8, #0x79000
0x00023494  add      x8, x8, #0xa88   ; STR "JPEG"
0x00023498  cmp      x0, #0
0x0002349c  csel     x2, x8, x0, eq
0x000234a0  mov      x0, x21
0x000234a4  bl       #0x56260   ; CALL objc_msgSend$alert:
0x000234a8  mov      w21, #0
0x000234ac  mov      x0, x23
0x000234b0  bl       #0x55d78   ; CALL _objc_release
0x000234b4  mov      x0, x22
0x000234b8  bl       #0x55d78   ; CALL _objc_release
0x000234bc  mov      x0, x20
0x000234c0  bl       #0x55d78   ; CALL _objc_release
0x000234c4  mov      x0, x19
0x000234c8  bl       #0x55d78   ; CALL _objc_release
0x000234cc  ldr      x8, [sp, #0x18]
0x000234d0  adrp     x9, #0x74000
0x000234d4  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000234d8  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000234dc  cmp      x9, x8
0x000234e0  b.ne     #0x23500
0x000234e4  mov      x0, x21
0x000234e8  ldp      x29, x30, [sp, #0x50]
0x000234ec  ldp      x20, x19, [sp, #0x40]
0x000234f0  ldp      x22, x21, [sp, #0x30]
0x000234f4  ldp      x24, x23, [sp, #0x20]
0x000234f8  add      sp, sp, #0x60
0x000234fc  ret      
0x00023500  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCAppBridgeAppsController useWallpaper:]  va=0x23504 size=672 types=v24@0:8@16
0x00023504  stp      d11, d10, [sp, #-0x70]!
0x00023508  stp      d9, d8, [sp, #0x10]
0x0002350c  stp      x26, x25, [sp, #0x20]
0x00023510  stp      x24, x23, [sp, #0x30]
0x00023514  stp      x22, x21, [sp, #0x40]
0x00023518  stp      x20, x19, [sp, #0x50]
0x0002351c  stp      x29, x30, [sp, #0x60]
0x00023520  add      x29, sp, #0x60
0x00023524  sub      sp, sp, #0x440
0x00023528  mov      x19, x2
0x0002352c  mov      x20, x0
0x00023530  adrp     x8, #0x74000
0x00023534  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00023538  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002353c  stur     x8, [x29, #-0x68]
0x00023540  mov      x0, x2
0x00023544  bl       #0x55d84   ; CALL _objc_retain
0x00023548  cbz      x19, #0x23744
0x0002354c  mov      x0, x19
0x00023550  bl       #0x5cba0   ; CALL objc_msgSend$size
0x00023554  mov      v8.16b, v0.16b
0x00023558  mov      x0, x19
0x0002355c  bl       #0x5a060   ; CALL objc_msgSend$scale
0x00023560  fmul     d9, d8, d0
0x00023564  mov      x0, x19
0x00023568  bl       #0x5cba0   ; CALL objc_msgSend$size
0x0002356c  mov      v8.16b, v1.16b
0x00023570  mov      x0, x19
0x00023574  bl       #0x5a060   ; CALL objc_msgSend$scale
0x00023578  fmul     d0, d8, d0
0x0002357c  fcmp     d9, d0
0x00023580  fcsel    d0, d0, d9, mi
0x00023584  mov      x8, #0x409e000000000000
0x00023588  fmov     d1, x8
0x0002358c  fdiv     d0, d1, d0
0x00023590  fmov     d1, #1.00000000
0x00023594  fcmp     d0, d1
0x00023598  fcsel    d10, d1, d0, gt
0x0002359c  mov      x0, x19
0x000235a0  bl       #0x5cba0   ; CALL objc_msgSend$size
0x000235a4  mov      v8.16b, v0.16b
0x000235a8  mov      x0, x19
0x000235ac  bl       #0x5a060   ; CALL objc_msgSend$scale
0x000235b0  fmul     d0, d8, d0
0x000235b4  fmul     d0, d0, d10
0x000235b8  frinta   d8, d0
0x000235bc  mov      x0, x19
0x000235c0  bl       #0x5cba0   ; CALL objc_msgSend$size
0x000235c4  mov      v9.16b, v1.16b
0x000235c8  mov      x0, x19
0x000235cc  bl       #0x5a060   ; CALL objc_msgSend$scale
0x000235d0  fmul     d0, d9, d0
0x000235d4  fmul     d0, d0, d10
0x000235d8  frinta   d9, d0
0x000235dc  adrp     x8, #0x8e000
0x000235e0  ldr      x0, [x8, #0xb58]   ; @CLASS UIGraphicsImageRendererFormat
0x000235e4  bl       #0x59920   ; CALL objc_msgSend$preferredFormat
0x000235e8  mov      x29, x29
0x000235ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000235f0  mov      x21, x0
0x000235f4  fmov     d0, #1.00000000
0x000235f8  bl       #0x5bee0   ; CALL objc_msgSend$setScale:
0x000235fc  mov      x0, x21
0x00023600  mov      w2, #1
0x00023604  bl       #0x5b960   ; CALL objc_msgSend$setOpaque:
0x00023608  adrp     x8, #0x8e000
0x0002360c  ldr      x0, [x8, #0xb00]   ; @CLASS UIGraphicsImageRenderer
0x00023610  bl       #0x55c7c   ; CALL _objc_alloc
0x00023614  mov      v0.16b, v8.16b
0x00023618  mov      v1.16b, v9.16b
0x0002361c  mov      x2, x21
0x00023620  bl       #0x58560   ; CALL objc_msgSend$initWithSize:format:
0x00023624  mov      x23, x0
0x00023628  adrp     x8, #0x74000
0x0002362c  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00023630  str      x8, [sp]
0x00023634  adrp     x8, #0x65000
0x00023638  ldr      d0, [x8, #0x600]
0x0002363c  str      d0, [sp, #8]
0x00023640  adrp     x8, #0x23000
0x00023644  add      x8, x8, #0x78c
0x00023648  adrp     x9, #0x74000
0x0002364c  add      x9, x9, #0xa40
0x00023650  stp      x8, x9, [sp, #0x10]
0x00023654  mov      x0, x19
0x00023658  bl       #0x55d84   ; CALL _objc_retain
0x0002365c  str      x19, [sp, #0x20]
0x00023660  stp      d8, d9, [sp, #0x28]
0x00023664  mov      x2, sp
0x00023668  mov      x0, x23
0x0002366c  bl       #0x58140   ; CALL objc_msgSend$imageWithActions:
0x00023670  mov      x29, x29
0x00023674  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023678  mov      x22, x0
0x0002367c  mov      x0, x23
0x00023680  bl       #0x55d78   ; CALL _objc_release
0x00023684  adrp     x0, #0x79000
0x00023688  add      x0, x0, #0x248   ; STR "/var/mobile/Library/OmniCar"
0x0002368c  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00023690  add      x1, sp, #0x38
0x00023694  bl       #0x4118
0x00023698  cbz      x0, #0x236bc
0x0002369c  mov      x2, x0
0x000236a0  adrp     x8, #0x8e000
0x000236a4  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x000236a8  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x000236ac  mov      x29, x29
0x000236b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000236b4  mov      x23, x0
0x000236b8  b        #0x236c0
0x000236bc  mov      x23, #0
0x000236c0  adrp     x2, #0x79000
0x000236c4  add      x2, x2, #0x268   ; STR "HomeScreen/photo.jpg"
0x000236c8  mov      x0, x23
0x000236cc  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x000236d0  mov      x29, x29
0x000236d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000236d8  mov      x24, x0
0x000236dc  mov      x0, x20
0x000236e0  mov      x2, x22
0x000236e4  mov      x3, x24
0x000236e8  bl       #0x5e200   ; CALL objc_msgSend$writeJPEG:to:
0x000236ec  mov      x25, x0
0x000236f0  mov      x0, x24
0x000236f4  bl       #0x55d78   ; CALL _objc_release
0x000236f8  mov      x0, x23
0x000236fc  bl       #0x55d78   ; CALL _objc_release
0x00023700  cbz      w25, #0x2372c
0x00023704  adrp     x8, #0x8e000
0x00023708  ldrsw    x23, [x8, #0xe80]
0x0002370c  mov      x0, x22
0x00023710  bl       #0x55d84   ; CALL _objc_retain
0x00023714  ldr      x0, [x20, x23]
0x00023718  str      x22, [x20, x23]
0x0002371c  bl       #0x55d78   ; CALL _objc_release
0x00023720  mov      x0, x20
0x00023724  mov      w2, #7
0x00023728  bl       #0x5de00   ; CALL objc_msgSend$useStyle:
0x0002372c  mov      x0, x22
0x00023730  bl       #0x55d78   ; CALL _objc_release
0x00023734  ldr      x0, [sp, #0x20]
0x00023738  bl       #0x55d78   ; CALL _objc_release
0x0002373c  mov      x0, x21
0x00023740  bl       #0x55d78   ; CALL _objc_release
0x00023744  mov      x0, x19
0x00023748  bl       #0x55d78   ; CALL _objc_release
0x0002374c  ldur     x8, [x29, #-0x68]
0x00023750  adrp     x9, #0x74000
0x00023754  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00023758  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0002375c  cmp      x9, x8
0x00023760  b.ne     #0x23788
0x00023764  add      sp, sp, #0x440
0x00023768  ldp      x29, x30, [sp, #0x60]
0x0002376c  ldp      x20, x19, [sp, #0x50]
0x00023770  ldp      x22, x21, [sp, #0x40]
0x00023774  ldp      x24, x23, [sp, #0x30]
0x00023778  ldp      x26, x25, [sp, #0x20]
0x0002377c  ldp      d9, d8, [sp, #0x10]
0x00023780  ldp      d11, d10, [sp], #0x70
0x00023784  ret      
0x00023788  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0002378c  ldr      x8, [x0, #0x20]   ; @STR "HomeScreen/photo.jpg"
0x00023790  ldp      d2, d3, [x0, #0x28]
0x00023794  fmov     d0, xzr
0x00023798  fmov     d1, xzr
0x0002379c  mov      x0, x8
0x000237a0  b        #0x578e0   ; CALL objc_msgSend$drawInRect:

=== -[OMCAppBridgeAppsController useVideo:]  va=0x237a4 size=2888 types=v24@0:8@16
0x000237a4  sub      sp, sp, #0x180
0x000237a8  stp      x28, x27, [sp, #0x120]
0x000237ac  stp      x26, x25, [sp, #0x130]
0x000237b0  stp      x24, x23, [sp, #0x140]
0x000237b4  stp      x22, x21, [sp, #0x150]
0x000237b8  stp      x20, x19, [sp, #0x160]
0x000237bc  stp      x29, x30, [sp, #0x170]
0x000237c0  add      x29, sp, #0x170
0x000237c4  mov      x23, x0
0x000237c8  adrp     x8, #0x8e000
0x000237cc  ldr      x0, [x8, #0xb60]   ; @CLASS AVURLAsset
0x000237d0  mov      x3, #0
0x000237d4  bl       #0x55f40   ; CALL objc_msgSend$URLAssetWithURL:options:
0x000237d8  mov      x29, x29
0x000237dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000237e0  mov      x19, x0
0x000237e4  adrp     x8, #0x74000
0x000237e8  ldr      x8, [x8, #0x300]   ; @GOT _AVMediaTypeVideo
0x000237ec  ldr      x22, [x8]   ; @GOT ___objc_personality_v0
0x000237f0  mov      x2, x22
0x000237f4  bl       #0x5dc20   ; CALL objc_msgSend$tracksWithMediaType:
0x000237f8  mov      x29, x29
0x000237fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023800  mov      x21, x0
0x00023804  bl       #0x57c20   ; CALL objc_msgSend$firstObject
0x00023808  mov      x29, x29
0x0002380c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023810  mov      x20, x0
0x00023814  mov      x0, x21
0x00023818  bl       #0x55d78   ; CALL _objc_release
0x0002381c  cbz      x20, #0x23868
0x00023820  add      x26, sp, #0xb0
0x00023824  adrp     x8, #0x8e000
0x00023828  ldr      x0, [x8, #0xb68]   ; @CLASS AVMutableComposition
0x0002382c  bl       #0x57060   ; CALL objc_msgSend$composition
0x00023830  mov      x29, x29
0x00023834  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023838  mov      x21, x0
0x0002383c  mov      x2, x22
0x00023840  mov      w3, #0
0x00023844  bl       #0x56120   ; CALL objc_msgSend$addMutableTrackWithMediaType:preferredTrackID:
0x00023848  mov      x29, x29
0x0002384c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023850  mov      x22, x0
0x00023854  cbz      x19, #0x23890
0x00023858  add      x8, sp, #0xb0
0x0002385c  mov      x0, x19
0x00023860  bl       #0x57920   ; CALL objc_msgSend$duration
0x00023864  b        #0x23898
0x00023868  adrp     x0, #0x79000
0x0002386c  add      x0, x0, #0xaa8   ; STR "APPS_VIDEO_FAILED"
0x00023870  bl       #0x17e20   ; CALL _L
0x00023874  mov      x29, x29
0x00023878  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002387c  mov      x21, x0
0x00023880  mov      x0, x23
0x00023884  mov      x2, x21
0x00023888  bl       #0x56260   ; CALL objc_msgSend$alert:
0x0002388c  b        #0x23b74
0x00023890  stp      xzr, xzr, [sp, #0xb0]
0x00023894  str      xzr, [sp, #0xc0]
0x00023898  sub      x8, x29, #0x90
0x0002389c  fmov     d0, #20.00000000
0x000238a0  mov      w0, #0x258
0x000238a4  bl       #0x55acc   ; CALL _CMTimeMakeWithSeconds
0x000238a8  sub      x8, x29, #0x78
0x000238ac  add      x0, sp, #0xb0
0x000238b0  sub      x1, x29, #0x90
0x000238b4  bl       #0x55ad8   ; CALL _CMTimeMinimum
0x000238b8  adrp     x8, #0x74000
0x000238bc  ldr      x8, [x8, #0x350]   ; @GOT _kCMTimeZero
0x000238c0  ldr      q0, [x8]   ; @GOT ___objc_personality_v0
0x000238c4  str      q0, [sp]
0x000238c8  str      q0, [x26, #0x30]
0x000238cc  ldr      x24, [x8, #0x10]   ; @GOT _objc_alloc_init
0x000238d0  stur     x24, [x29, #-0x80]
0x000238d4  ldur     q0, [x29, #-0x78]
0x000238d8  str      q0, [sp, #0x90]
0x000238dc  ldur     x8, [x29, #-0x68]
0x000238e0  str      x8, [sp, #0xa0]
0x000238e4  add      x8, sp, #0xb0
0x000238e8  sub      x0, x29, #0x90
0x000238ec  add      x1, sp, #0x90
0x000238f0  bl       #0x55ae4   ; CALL _CMTimeRangeMake
0x000238f4  str      xzr, [sp, #0x88]
0x000238f8  ldr      q0, [sp]
0x000238fc  str      q0, [x26, #0x30]
0x00023900  stur     x24, [x29, #-0x80]
0x00023904  add      x2, sp, #0xb0
0x00023908  sub      x4, x29, #0x90
0x0002390c  add      x5, sp, #0x88
0x00023910  mov      x0, x22
0x00023914  mov      x3, x20
0x00023918  bl       #0x586c0   ; CALL objc_msgSend$insertTimeRange:ofTrack:atTime:error:
0x0002391c  mov      x25, x0
0x00023920  ldr      x24, [sp, #0x88]
0x00023924  mov      x0, x24
0x00023928  bl       #0x55d84   ; CALL _objc_retain
0x0002392c  tbz      w25, #0, #0x23b08
0x00023930  add      x8, sp, #0x58
0x00023934  mov      x0, x20
0x00023938  bl       #0x59960   ; CALL objc_msgSend$preferredTransform
0x0002393c  ldur     q0, [sp, #0x58]
0x00023940  ldur     q1, [sp, #0x68]
0x00023944  stp      q0, q1, [x26]
0x00023948  ldur     q0, [sp, #0x78]
0x0002394c  str      q0, [x26, #0x20]
0x00023950  add      x2, sp, #0xb0
0x00023954  mov      x0, x22
0x00023958  bl       #0x5bc80   ; CALL objc_msgSend$setPreferredTransform:
0x0002395c  adrp     x8, #0x8e000
0x00023960  ldr      x0, [x8, #0xb70]   ; @CLASS AVAssetExportSession
0x00023964  adrp     x8, #0x74000
0x00023968  ldr      x8, [x8, #0x2c8]   ; @GOT _AVAssetExportPreset1280x720
0x0002396c  ldr      x3, [x8]   ; @GOT ___objc_personality_v0
0x00023970  mov      x2, x21
0x00023974  bl       #0x57a60   ; CALL objc_msgSend$exportSessionWithAsset:presetName:
0x00023978  mov      x29, x29
0x0002397c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023980  mov      x25, x0
0x00023984  bl       #0x55b14   ; CALL _NSTemporaryDirectory
0x00023988  mov      x29, x29
0x0002398c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023990  mov      x27, x0
0x00023994  adrp     x2, #0x79000
0x00023998  add      x2, x2, #0xac8   ; STR "omnicar-wallpaper.mp4"
0x0002399c  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x000239a0  mov      x29, x29
0x000239a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000239a8  mov      x26, x0
0x000239ac  mov      x0, x27
0x000239b0  bl       #0x55d78   ; CALL _objc_release
0x000239b4  adrp     x8, #0x8e000
0x000239b8  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x000239bc  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x000239c0  mov      x29, x29
0x000239c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000239c8  mov      x27, x0
0x000239cc  mov      x2, x26
0x000239d0  mov      x3, #0
0x000239d4  bl       #0x59e20   ; CALL objc_msgSend$removeItemAtPath:error:
0x000239d8  mov      x0, x27
0x000239dc  bl       #0x55d78   ; CALL _objc_release
0x000239e0  adrp     x8, #0x8e000
0x000239e4  ldr      x0, [x8, #0xa10]   ; @CLASS NSURL
0x000239e8  mov      x2, x26
0x000239ec  bl       #0x57ba0   ; CALL objc_msgSend$fileURLWithPath:
0x000239f0  mov      x29, x29
0x000239f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000239f8  mov      x27, x0
0x000239fc  mov      x0, x25
0x00023a00  mov      x2, x27
0x00023a04  bl       #0x5ba40   ; CALL objc_msgSend$setOutputURL:
0x00023a08  mov      x0, x27
0x00023a0c  bl       #0x55d78   ; CALL _objc_release
0x00023a10  adrp     x8, #0x74000
0x00023a14  ldr      x8, [x8, #0x2e8]   ; @GOT _AVFileTypeMPEG4
0x00023a18  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x00023a1c  mov      x0, x25
0x00023a20  bl       #0x5ba20   ; CALL objc_msgSend$setOutputFileType:
0x00023a24  mov      x0, x25
0x00023a28  mov      w2, #1
0x00023a2c  bl       #0x5c080   ; CALL objc_msgSend$setShouldOptimizeForNetworkUse:
0x00023a30  adrp     x8, #0x8e000
0x00023a34  ldr      x27, [x8, #0x9b8]   ; @CLASS UIAlertController
0x00023a38  adrp     x0, #0x79000
0x00023a3c  add      x0, x0, #0xae8   ; STR "APPS_VIDEO_WORKING"
0x00023a40  bl       #0x17e20   ; CALL _L
0x00023a44  mov      x29, x29
0x00023a48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023a4c  mov      x28, x0
0x00023a50  mov      x0, x27
0x00023a54  mov      x2, #0
0x00023a58  mov      x3, x28
0x00023a5c  mov      w4, #1
0x00023a60  bl       #0x56280   ; CALL objc_msgSend$alertControllerWithTitle:message:preferredStyle:
0x00023a64  mov      x29, x29
0x00023a68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023a6c  mov      x27, x0
0x00023a70  mov      x0, x28
0x00023a74  bl       #0x55d78   ; CALL _objc_release
0x00023a78  mov      x0, x23
0x00023a7c  mov      x2, x27
0x00023a80  mov      w3, #1
0x00023a84  mov      x4, #0
0x00023a88  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x00023a8c  adrp     x8, #0x74000
0x00023a90  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00023a94  str      x8, [sp, #0x18]
0x00023a98  adrp     x8, #0x65000
0x00023a9c  ldr      d0, [x8, #0x600]
0x00023aa0  str      d0, [sp, #0x20]
0x00023aa4  adrp     x8, #0x23000
0x00023aa8  add      x8, x8, #0xbac
0x00023aac  adrp     x9, #0x74000
0x00023ab0  add      x9, x9, #0xaa0
0x00023ab4  stp      x8, x9, [sp, #0x28]
0x00023ab8  stp      x27, x25, [sp, #0x38]
0x00023abc  stp      x23, x26, [sp, #0x48]
0x00023ac0  mov      x0, x26
0x00023ac4  bl       #0x55d84   ; CALL _objc_retain
0x00023ac8  mov      x0, x25
0x00023acc  bl       #0x55d84   ; CALL _objc_retain
0x00023ad0  mov      x0, x27
0x00023ad4  bl       #0x55d84   ; CALL _objc_retain
0x00023ad8  add      x2, sp, #0x18
0x00023adc  mov      x0, x25
0x00023ae0  bl       #0x57a40   ; CALL objc_msgSend$exportAsynchronouslyWithCompletionHandler:
0x00023ae4  ldr      x0, [sp, #0x50]
0x00023ae8  bl       #0x55d78   ; CALL _objc_release
0x00023aec  ldr      x0, [sp, #0x40]
0x00023af0  bl       #0x55d78   ; CALL _objc_release
0x00023af4  ldr      x0, [sp, #0x38]
0x00023af8  bl       #0x55d78   ; CALL _objc_release
0x00023afc  mov      x0, x26
0x00023b00  bl       #0x55d78   ; CALL _objc_release
0x00023b04  b        #0x23b54
0x00023b08  mov      x0, x24
0x00023b0c  bl       #0x58dc0   ; CALL objc_msgSend$localizedDescription
0x00023b10  mov      x29, x29
0x00023b14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023b18  mov      x27, x0
0x00023b1c  cbz      x0, #0x23b30
0x00023b20  mov      x0, x23
0x00023b24  mov      x2, x27
0x00023b28  bl       #0x56260   ; CALL objc_msgSend$alert:
0x00023b2c  b        #0x23b5c
0x00023b30  adrp     x0, #0x79000
0x00023b34  add      x0, x0, #0xaa8   ; STR "APPS_VIDEO_FAILED"
0x00023b38  bl       #0x17e20   ; CALL _L
0x00023b3c  mov      x29, x29
0x00023b40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023b44  mov      x25, x0
0x00023b48  mov      x0, x23
0x00023b4c  mov      x2, x25
0x00023b50  bl       #0x56260   ; CALL objc_msgSend$alert:
0x00023b54  mov      x0, x25
0x00023b58  bl       #0x55d78   ; CALL _objc_release
0x00023b5c  mov      x0, x27
0x00023b60  bl       #0x55d78   ; CALL _objc_release
0x00023b64  mov      x0, x24
0x00023b68  bl       #0x55d78   ; CALL _objc_release
0x00023b6c  mov      x0, x22
0x00023b70  bl       #0x55d78   ; CALL _objc_release
0x00023b74  mov      x0, x21
0x00023b78  bl       #0x55d78   ; CALL _objc_release
0x00023b7c  mov      x0, x20
0x00023b80  bl       #0x55d78   ; CALL _objc_release
0x00023b84  mov      x0, x19
0x00023b88  bl       #0x55d78   ; CALL _objc_release
0x00023b8c  ldp      x29, x30, [sp, #0x170]
0x00023b90  ldp      x20, x19, [sp, #0x160]
0x00023b94  ldp      x22, x21, [sp, #0x150]
0x00023b98  ldp      x24, x23, [sp, #0x140]
0x00023b9c  ldp      x26, x25, [sp, #0x130]
0x00023ba0  ldp      x28, x27, [sp, #0x120]
0x00023ba4  add      sp, sp, #0x180
0x00023ba8  ret      
0x00023bac  sub      sp, sp, #0x70
0x00023bb0  stp      x20, x19, [sp, #0x50]
0x00023bb4  stp      x29, x30, [sp, #0x60]
0x00023bb8  add      x29, sp, #0x60
0x00023bbc  mov      x19, x0
0x00023bc0  adrp     x8, #0x74000
0x00023bc4  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00023bc8  str      x8, [sp, #0x10]
0x00023bcc  adrp     x8, #0x65000
0x00023bd0  ldr      d0, [x8, #0x600]
0x00023bd4  adrp     x8, #0x23000
0x00023bd8  add      x8, x8, #0xc5c
0x00023bdc  str      d0, [sp, #0x18]
0x00023be0  adrp     x9, #0x74000
0x00023be4  add      x9, x9, #0xaa0
0x00023be8  stp      x8, x9, [sp, #0x20]
0x00023bec  ldr      x20, [x0, #0x20]   ; @STR "omnicar-wallpaper.mp4"
0x00023bf0  mov      x0, x20
0x00023bf4  bl       #0x55d84   ; CALL _objc_retain
0x00023bf8  str      x20, [sp, #0x30]
0x00023bfc  ldr      x20, [x19, #0x28]
0x00023c00  mov      x0, x20
0x00023c04  bl       #0x55d84   ; CALL _objc_retain
0x00023c08  str      x20, [sp, #0x38]
0x00023c0c  ldr      x0, [x19, #0x38]
0x00023c10  ldr      q0, [x19, #0x30]
0x00023c14  str      q0, [sp]
0x00023c18  bl       #0x55d84   ; CALL _objc_retain
0x00023c1c  ldr      q0, [sp]
0x00023c20  str      q0, [sp, #0x40]
0x00023c24  adrp     x0, #0x74000
0x00023c28  ldr      x0, [x0, #0x3a0]   ; @GOT __dispatch_main_q
0x00023c2c  add      x1, sp, #0x10
0x00023c30  bl       #0x55be0   ; CALL _dispatch_async
0x00023c34  ldr      x0, [sp, #0x48]
0x00023c38  bl       #0x55d78   ; CALL _objc_release
0x00023c3c  ldr      x0, [sp, #0x38]
0x00023c40  bl       #0x55d78   ; CALL _objc_release
0x00023c44  ldr      x0, [sp, #0x30]
0x00023c48  bl       #0x55d78   ; CALL _objc_release
0x00023c4c  ldp      x29, x30, [sp, #0x60]
0x00023c50  ldp      x20, x19, [sp, #0x50]
0x00023c54  add      sp, sp, #0x70
0x00023c58  ret      
0x00023c5c  sub      sp, sp, #0x80
0x00023c60  stp      x22, x21, [sp, #0x50]
0x00023c64  stp      x20, x19, [sp, #0x60]
0x00023c68  stp      x29, x30, [sp, #0x70]
0x00023c6c  add      x29, sp, #0x70
0x00023c70  mov      x19, x0
0x00023c74  adrp     x8, #0x74000
0x00023c78  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00023c7c  str      x8, [sp, #0x18]
0x00023c80  adrp     x8, #0x65000
0x00023c84  ldr      d0, [x8, #0x600]
0x00023c88  str      d0, [sp, #0x20]
0x00023c8c  adrp     x8, #0x23000
0x00023c90  add      x8, x8, #0xcfc
0x00023c94  adrp     x9, #0x74000
0x00023c98  add      x9, x9, #0xa70
0x00023c9c  stp      x8, x9, [sp, #0x28]
0x00023ca0  ldp      x20, x21, [x0, #0x20]
0x00023ca4  mov      x0, x21
0x00023ca8  bl       #0x55d84   ; CALL _objc_retain
0x00023cac  str      x21, [sp, #0x38]
0x00023cb0  ldr      x0, [x19, #0x38]
0x00023cb4  ldr      q0, [x19, #0x30]
0x00023cb8  str      q0, [sp]
0x00023cbc  bl       #0x55d84   ; CALL _objc_retain
0x00023cc0  ldr      q0, [sp]
0x00023cc4  stur     q0, [sp, #0x40]
0x00023cc8  add      x3, sp, #0x18
0x00023ccc  mov      x0, x20
0x00023cd0  mov      w2, #1
0x00023cd4  bl       #0x57820   ; CALL objc_msgSend$dismissViewControllerAnimated:completion:
0x00023cd8  ldr      x0, [sp, #0x48]
0x00023cdc  bl       #0x55d78   ; CALL _objc_release
0x00023ce0  ldr      x0, [sp, #0x38]
0x00023ce4  bl       #0x55d78   ; CALL _objc_release
0x00023ce8  ldp      x29, x30, [sp, #0x70]
0x00023cec  ldp      x20, x19, [sp, #0x60]
0x00023cf0  ldp      x22, x21, [sp, #0x50]
0x00023cf4  add      sp, sp, #0x80
0x00023cf8  ret      
0x00023cfc  stp      x28, x27, [sp, #-0x60]!
0x00023d00  stp      x26, x25, [sp, #0x10]
0x00023d04  stp      x24, x23, [sp, #0x20]
0x00023d08  stp      x22, x21, [sp, #0x30]
0x00023d0c  stp      x20, x19, [sp, #0x40]
0x00023d10  stp      x29, x30, [sp, #0x50]
0x00023d14  add      x29, sp, #0x50
0x00023d18  sub      sp, sp, #0x430
0x00023d1c  mov      x20, x0
0x00023d20  adrp     x8, #0x74000
0x00023d24  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00023d28  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00023d2c  stur     x8, [x29, #-0x58]
0x00023d30  ldr      x0, [x0, #0x20]   ; @GOT _objc_autoreleasePoolPop
0x00023d34  bl       #0x5d320   ; CALL objc_msgSend$status
0x00023d38  cmp      x0, #3
0x00023d3c  b.ne     #0x23d90
0x00023d40  adrp     x8, #0x8e000
0x00023d44  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x00023d48  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x00023d4c  mov      x29, x29
0x00023d50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023d54  mov      x19, x0
0x00023d58  adrp     x0, #0x79000
0x00023d5c  add      x0, x0, #0x248   ; STR "/var/mobile/Library/OmniCar"
0x00023d60  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00023d64  add      x1, sp, #0x20
0x00023d68  bl       #0x4118
0x00023d6c  adrp     x27, #0x8e000
0x00023d70  cbz      x0, #0x23dc8
0x00023d74  mov      x2, x0
0x00023d78  ldr      x0, [x27, #0x958]   ; @CLASS NSString
0x00023d7c  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00023d80  mov      x29, x29
0x00023d84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023d88  mov      x21, x0
0x00023d8c  b        #0x23dcc
0x00023d90  ldp      x0, x21, [x20, #0x20]
0x00023d94  bl       #0x57a20   ; CALL objc_msgSend$error
0x00023d98  mov      x29, x29
0x00023d9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023da0  mov      x19, x0
0x00023da4  bl       #0x58dc0   ; CALL objc_msgSend$localizedDescription
0x00023da8  mov      x29, x29
0x00023dac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023db0  mov      x20, x0
0x00023db4  cbz      x0, #0x23e5c
0x00023db8  mov      x0, x21
0x00023dbc  mov      x2, x20
0x00023dc0  bl       #0x56260   ; CALL objc_msgSend$alert:
0x00023dc4  b        #0x23e88
0x00023dc8  mov      x21, #0
0x00023dcc  adrp     x2, #0x79000
0x00023dd0  add      x2, x2, #0x288   ; STR "HomeScreen/video.mp4"
0x00023dd4  mov      x0, x21
0x00023dd8  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00023ddc  mov      x29, x29
0x00023de0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023de4  mov      x22, x0
0x00023de8  bl       #0x5d460   ; CALL objc_msgSend$stringByDeletingLastPathComponent
0x00023dec  mov      x29, x29
0x00023df0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023df4  mov      x23, x0
0x00023df8  mov      x0, x19
0x00023dfc  mov      x2, x23
0x00023e00  mov      w3, #1
0x00023e04  mov      x4, #0
0x00023e08  mov      x5, #0
0x00023e0c  bl       #0x57400   ; CALL objc_msgSend$createDirectoryAtPath:withIntermediateDirectories:attributes:error:
0x00023e10  mov      x0, x23
0x00023e14  bl       #0x55d78   ; CALL _objc_release
0x00023e18  mov      x0, x22
0x00023e1c  bl       #0x55d78   ; CALL _objc_release
0x00023e20  mov      x0, x21
0x00023e24  bl       #0x55d78   ; CALL _objc_release
0x00023e28  adrp     x0, #0x79000
0x00023e2c  add      x0, x0, #0x248   ; STR "/var/mobile/Library/OmniCar"
0x00023e30  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00023e34  add      x1, sp, #0x20
0x00023e38  bl       #0x4118
0x00023e3c  cbz      x0, #0x23ecc
0x00023e40  mov      x2, x0
0x00023e44  ldr      x0, [x27, #0x958]   ; @CLASS NSString
0x00023e48  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00023e4c  mov      x29, x29
0x00023e50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023e54  mov      x21, x0
0x00023e58  b        #0x23ed0
0x00023e5c  adrp     x0, #0x79000
0x00023e60  add      x0, x0, #0xaa8   ; STR "APPS_VIDEO_FAILED"
0x00023e64  bl       #0x17e20   ; CALL _L
0x00023e68  mov      x29, x29
0x00023e6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023e70  mov      x22, x0
0x00023e74  mov      x0, x21
0x00023e78  mov      x2, x22
0x00023e7c  bl       #0x56260   ; CALL objc_msgSend$alert:
0x00023e80  mov      x0, x22
0x00023e84  bl       #0x55d78   ; CALL _objc_release
0x00023e88  mov      x0, x20
0x00023e8c  bl       #0x55d78   ; CALL _objc_release
0x00023e90  ldur     x8, [x29, #-0x58]
0x00023e94  adrp     x9, #0x74000
0x00023e98  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00023e9c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00023ea0  cmp      x9, x8
0x00023ea4  b.ne     #0x242e8
0x00023ea8  mov      x0, x19
0x00023eac  add      sp, sp, #0x430
0x00023eb0  ldp      x29, x30, [sp, #0x50]
0x00023eb4  ldp      x20, x19, [sp, #0x40]
0x00023eb8  ldp      x22, x21, [sp, #0x30]
0x00023ebc  ldp      x24, x23, [sp, #0x20]
0x00023ec0  ldp      x26, x25, [sp, #0x10]
0x00023ec4  ldp      x28, x27, [sp], #0x60
0x00023ec8  b        #0x55d78   ; CALL _objc_release
0x00023ecc  mov      x21, #0
0x00023ed0  adrp     x2, #0x79000
0x00023ed4  add      x2, x2, #0x288   ; STR "HomeScreen/video.mp4"
0x00023ed8  mov      x0, x21
0x00023edc  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00023ee0  mov      x29, x29
0x00023ee4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023ee8  mov      x22, x0
0x00023eec  mov      x0, x19
0x00023ef0  mov      x2, x22
0x00023ef4  mov      x3, #0
0x00023ef8  bl       #0x59e20   ; CALL objc_msgSend$removeItemAtPath:error:
0x00023efc  mov      x0, x22
0x00023f00  bl       #0x55d78   ; CALL _objc_release
0x00023f04  mov      x0, x21
0x00023f08  bl       #0x55d78   ; CALL _objc_release
0x00023f0c  ldr      x21, [x20, #0x30]
0x00023f10  adrp     x0, #0x79000
0x00023f14  add      x0, x0, #0x248   ; STR "/var/mobile/Library/OmniCar"
0x00023f18  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00023f1c  add      x1, sp, #0x20
0x00023f20  bl       #0x4118
0x00023f24  cbz      x0, #0x23f44
0x00023f28  mov      x2, x0
0x00023f2c  ldr      x0, [x27, #0x958]   ; @CLASS NSString
0x00023f30  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00023f34  mov      x29, x29
0x00023f38  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023f3c  mov      x22, x0
0x00023f40  b        #0x23f48
0x00023f44  mov      x22, #0
0x00023f48  adrp     x2, #0x79000
0x00023f4c  add      x2, x2, #0x288   ; STR "HomeScreen/video.mp4"
0x00023f50  mov      x0, x22
0x00023f54  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00023f58  mov      x29, x29
0x00023f5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023f60  mov      x23, x0
0x00023f64  str      xzr, [sp, #8]
0x00023f68  add      x4, sp, #8
0x00023f6c  mov      x0, x19
0x00023f70  mov      x2, x21
0x00023f74  mov      x3, x23
0x00023f78  bl       #0x59040   ; CALL objc_msgSend$moveItemAtPath:toPath:error:
0x00023f7c  mov      x24, x0
0x00023f80  ldr      x21, [sp, #8]
0x00023f84  mov      x0, x21
0x00023f88  bl       #0x55d84   ; CALL _objc_retain
0x00023f8c  mov      x0, x23
0x00023f90  bl       #0x55d78   ; CALL _objc_release
0x00023f94  mov      x0, x22
0x00023f98  bl       #0x55d78   ; CALL _objc_release
0x00023f9c  tbz      w24, #0, #0x24010
0x00023fa0  adrp     x8, #0x74000
0x00023fa4  ldr      x8, [x8, #0x120]   ; @GOT _NSFilePosixPermissions
0x00023fa8  ldr      x9, [x8]   ; @GOT ___objc_personality_v0
0x00023fac  adrp     x8, #0x80000
0x00023fb0  add      x8, x8, #0x298
0x00023fb4  stp      x9, x8, [sp, #0x10]
0x00023fb8  adrp     x8, #0x8e000
0x00023fbc  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00023fc0  add      x2, sp, #0x18
0x00023fc4  add      x3, sp, #0x10
0x00023fc8  mov      w4, #1
0x00023fcc  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00023fd0  mov      x29, x29
0x00023fd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00023fd8  mov      x22, x0
0x00023fdc  adrp     x0, #0x79000
0x00023fe0  add      x0, x0, #0x248   ; STR "/var/mobile/Library/OmniCar"
0x00023fe4  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00023fe8  add      x1, sp, #0x20
0x00023fec  bl       #0x4118
0x00023ff0  cbz      x0, #0x2403c
0x00023ff4  mov      x2, x0
0x00023ff8  ldr      x0, [x27, #0x958]   ; @CLASS NSString
0x00023ffc  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00024000  mov      x29, x29
0x00024004  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00024008  mov      x23, x0
0x0002400c  b        #0x24040
0x00024010  ldr      x20, [x20, #0x28]
0x00024014  mov      x0, x21
0x00024018  bl       #0x58dc0   ; CALL objc_msgSend$localizedDescription
0x0002401c  mov      x29, x29
0x00024020  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00024024  mov      x22, x0
0x00024028  cbz      x0, #0x240d4
0x0002402c  mov      x0, x20
0x00024030  mov      x2, x22
0x00024034  bl       #0x56260   ; CALL objc_msgSend$alert:
0x00024038  b        #0x24298
0x0002403c  mov      x23, #0
0x00024040  adrp     x2, #0x79000
0x00024044  add      x2, x2, #0x288   ; STR "HomeScreen/video.mp4"
0x00024048  mov      x0, x23
0x0002404c  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00024050  mov      x29, x29
0x00024054  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00024058  mov      x24, x0
0x0002405c  mov      x0, x19
0x00024060  mov      x2, x22
0x00024064  mov      x3, x24
0x00024068  mov      x4, #0
0x0002406c  bl       #0x5a4e0   ; CALL objc_msgSend$setAttributes:ofItemAtPath:error:
0x00024070  mov      x0, x24
0x00024074  bl       #0x55d78   ; CALL _objc_release
0x00024078  mov      x0, x23
0x0002407c  bl       #0x55d78   ; CALL _objc_release
0x00024080  mov      x0, x22
0x00024084  bl       #0x55d78   ; CALL _objc_release
0x00024088  adrp     x8, #0x8e000
0x0002408c  ldr      x22, [x8, #0xb78]   ; @CLASS AVAssetImageGenerator
0x00024090  adrp     x8, #0x8e000
0x00024094  ldr      x23, [x8, #0xb60]   ; @CLASS AVURLAsset
0x00024098  adrp     x8, #0x8e000
0x0002409c  ldr      x25, [x8, #0xa10]   ; @CLASS NSURL
0x000240a0  adrp     x0, #0x79000
0x000240a4  add      x0, x0, #0x248   ; STR "/var/mobile/Library/OmniCar"
0x000240a8  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x000240ac  add      x1, sp, #0x20
0x000240b0  bl       #0x4118
0x000240b4  cbz      x0, #0x240fc
0x000240b8  mov      x2, x0
0x000240bc  ldr      x0, [x27, #0x958]   ; @CLASS NSString
0x000240c0  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x000240c4  mov      x29, x29
0x000240c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000240cc  mov      x24, x0
0x000240d0  b        #0x24100
0x000240d4  adrp     x0, #0x79000
0x000240d8  add      x0, x0, #0xaa8   ; STR "APPS_VIDEO_FAILED"
0x000240dc  bl       #0x17e20   ; CALL _L
0x000240e0  mov      x29, x29
0x000240e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000240e8  mov      x23, x0
0x000240ec  mov      x0, x20
0x000240f0  mov      x2, x23
0x000240f4  bl       #0x56260   ; CALL objc_msgSend$alert:
0x000240f8  b        #0x24290
0x000240fc  mov      x24, #0
0x00024100  adrp     x2, #0x79000
0x00024104  add      x2, x2, #0x288   ; STR "HomeScreen/video.mp4"
0x00024108  mov      x0, x24
0x0002410c  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00024110  mov      x29, x29
0x00024114  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00024118  mov      x26, x0
0x0002411c  mov      x0, x25
0x00024120  mov      x2, x26
0x00024124  bl       #0x57ba0   ; CALL objc_msgSend$fileURLWithPath:
0x00024128  mov      x29, x29
0x0002412c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00024130  mov      x25, x0
0x00024134  mov      x0, x23
0x00024138  mov      x2, x25
0x0002413c  mov      x3, #0
0x00024140  bl       #0x55f40   ; CALL objc_msgSend$URLAssetWithURL:options:
0x00024144  mov      x29, x29
0x00024148  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002414c  mov      x23, x0
0x00024150  mov      x0, x22
0x00024154  mov      x2, x23
0x00024158  bl       #0x56680   ; CALL objc_msgSend$assetImageGeneratorWithAsset:
0x0002415c  mov      x29, x29
0x00024160  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00024164  mov      x22, x0
0x00024168  mov      x0, x23
0x0002416c  bl       #0x55d78   ; CALL _objc_release
0x00024170  mov      x0, x25
0x00024174  bl       #0x55d78   ; CALL _objc_release
0x00024178  mov      x0, x26
0x0002417c  bl       #0x55d78   ; CALL _objc_release
0x00024180  mov      x0, x24
0x00024184  bl       #0x55d78   ; CALL _objc_release
0x00024188  mov      x0, x22
0x0002418c  mov      w2, #1
0x00024190  bl       #0x5a480   ; CALL objc_msgSend$setAppliesPreferredTrackTransform:
0x00024194  adrp     x8, #0x74000
0x00024198  ldr      x8, [x8, #0x350]   ; @GOT _kCMTimeZero
0x0002419c  ldr      q0, [x8]   ; @GOT ___objc_personality_v0
0x000241a0  str      q0, [sp, #0x20]
0x000241a4  ldr      x8, [x8, #0x10]   ; @GOT _objc_alloc_init
0x000241a8  str      x8, [sp, #0x30]
0x000241ac  add      x2, sp, #0x20
0x000241b0  mov      x0, x22
0x000241b4  mov      x3, #0
0x000241b8  mov      x4, #0
0x000241bc  bl       #0x57300   ; CALL objc_msgSend$copyCGImageAtTime:actualTime:error:
0x000241c0  cbz      x0, #0x24228
0x000241c4  mov      x24, x0
0x000241c8  adrp     x8, #0x8e000
0x000241cc  ldr      x0, [x8, #0xa78]   ; @CLASS UIImage
0x000241d0  mov      x2, x24
0x000241d4  bl       #0x58160   ; CALL objc_msgSend$imageWithCGImage:
0x000241d8  mov      x29, x29
0x000241dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000241e0  mov      x23, x0
0x000241e4  mov      x0, x24
0x000241e8  bl       #0x559f4   ; CALL _CGImageRelease
0x000241ec  cbz      x23, #0x24290
0x000241f0  ldr      x24, [x20, #0x28]
0x000241f4  adrp     x0, #0x79000
0x000241f8  add      x0, x0, #0x248   ; STR "/var/mobile/Library/OmniCar"
0x000241fc  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00024200  add      x1, sp, #0x20
0x00024204  bl       #0x4118
0x00024208  cbz      x0, #0x24230
0x0002420c  mov      x2, x0
0x00024210  ldr      x0, [x27, #0x958]   ; @CLASS NSString
0x00024214  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00024218  mov      x29, x29
0x0002421c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00024220  mov      x25, x0
0x00024224  b        #0x24234
0x00024228  mov      x23, #0
0x0002422c  b        #0x24290
0x00024230  mov      x25, #0
0x00024234  adrp     x2, #0x79000
0x00024238  add      x2, x2, #0x2a8   ; STR "HomeScreen/video.jpg"
0x0002423c  mov      x0, x25
0x00024240  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00024244  mov      x29, x29
0x00024248  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002424c  mov      x26, x0
0x00024250  mov      x0, x24
0x00024254  mov      x2, x23
0x00024258  mov      x3, x26
0x0002425c  bl       #0x5e200   ; CALL objc_msgSend$writeJPEG:to:
0x00024260  mov      x24, x0
0x00024264  mov      x0, x26
0x00024268  bl       #0x55d78   ; CALL _objc_release
0x0002426c  mov      x0, x25
0x00024270  bl       #0x55d78   ; CALL _objc_release
0x00024274  cbz      w24, #0x24290
0x00024278  ldr      x0, [x20, #0x28]
0x0002427c  mov      x2, x23
0x00024280  bl       #0x5c820   ; CALL objc_msgSend$setVideoThumb:
0x00024284  ldr      x0, [x20, #0x28]
0x00024288  mov      w2, #8
0x0002428c  bl       #0x5de00   ; CALL objc_msgSend$useStyle:
0x00024290  mov      x0, x23
0x00024294  bl       #0x55d78   ; CALL _objc_release
0x00024298  mov      x0, x22
0x0002429c  bl       #0x55d78   ; CALL _objc_release
0x000242a0  mov      x0, x21
0x000242a4  bl       #0x55d78   ; CALL _objc_release
0x000242a8  mov      x0, x19
0x000242ac  bl       #0x55d78   ; CALL _objc_release
0x000242b0  ldur     x8, [x29, #-0x58]
0x000242b4  adrp     x9, #0x74000
0x000242b8  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000242bc  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000242c0  cmp      x9, x8
0x000242c4  b.ne     #0x242e8
0x000242c8  add      sp, sp, #0x430
0x000242cc  ldp      x29, x30, [sp, #0x50]
0x000242d0  ldp      x20, x19, [sp, #0x40]
0x000242d4  ldp      x22, x21, [sp, #0x30]
0x000242d8  ldp      x24, x23, [sp, #0x20]
0x000242dc  ldp      x26, x25, [sp, #0x10]
0x000242e0  ldp      x28, x27, [sp], #0x60
0x000242e4  ret      
0x000242e8  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCAppBridgeAppsController imagePickerController:didFinishPickingMediaWithInfo:]  va=0x2435c size=300 types=v32@0:8@16@24
0x0002435c  sub      sp, sp, #0x80
0x00024360  stp      x24, x23, [sp, #0x40]
0x00024364  stp      x22, x21, [sp, #0x50]
0x00024368  stp      x20, x19, [sp, #0x60]
0x0002436c  stp      x29, x30, [sp, #0x70]
0x00024370  add      x29, sp, #0x70
0x00024374  mov      x21, x3
0x00024378  mov      x20, x2
0x0002437c  mov      x22, x0
0x00024380  adrp     x8, #0x74000
0x00024384  ldr      x8, [x8, #0x298]   ; @GOT _UIImagePickerControllerMediaURL
0x00024388  ldr      x19, [x8]   ; @GOT ___objc_personality_v0
0x0002438c  mov      x0, x3
0x00024390  bl       #0x55d84   ; CALL _objc_retain
0x00024394  mov      x0, x20
0x00024398  bl       #0x55d84   ; CALL _objc_retain
0x0002439c  mov      x0, x21
0x000243a0  mov      x2, x19
0x000243a4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000243a8  mov      x29, x29
0x000243ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000243b0  mov      x19, x0
0x000243b4  adrp     x8, #0x74000
0x000243b8  ldr      x8, [x8, #0x2a0]   ; @GOT _UIImagePickerControllerOriginalImage
0x000243bc  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x000243c0  mov      x0, x21
0x000243c4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000243c8  mov      x29, x29
0x000243cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000243d0  mov      x23, x0
0x000243d4  mov      x0, x21
0x000243d8  bl       #0x55d78   ; CALL _objc_release
0x000243dc  adrp     x8, #0x74000
0x000243e0  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x000243e4  str      x8, [sp, #8]
0x000243e8  adrp     x8, #0x65000
0x000243ec  ldr      d0, [x8, #0x600]
0x000243f0  adrp     x8, #0x24000
0x000243f4  add      x8, x8, #0x470
0x000243f8  adrp     x9, #0x74000
0x000243fc  add      x9, x9, #0xa70
0x00024400  str      d0, [sp, #0x10]
0x00024404  stp      x8, x9, [sp, #0x18]
0x00024408  stp      x19, x22, [sp, #0x28]
0x0002440c  str      x23, [sp, #0x38]
0x00024410  mov      x0, x23
0x00024414  bl       #0x55d84   ; CALL _objc_retain
0x00024418  mov      x0, x19
0x0002441c  bl       #0x55d84   ; CALL _objc_retain
0x00024420  add      x3, sp, #8
0x00024424  mov      x0, x20
0x00024428  mov      w2, #1
0x0002442c  bl       #0x57820   ; CALL objc_msgSend$dismissViewControllerAnimated:completion:
0x00024430  mov      x0, x20
0x00024434  bl       #0x55d78   ; CALL _objc_release
0x00024438  ldr      x0, [sp, #0x38]
0x0002443c  bl       #0x55d78   ; CALL _objc_release
0x00024440  ldr      x0, [sp, #0x28]
0x00024444  bl       #0x55d78   ; CALL _objc_release
0x00024448  mov      x0, x23
0x0002444c  bl       #0x55d78   ; CALL _objc_release
0x00024450  mov      x0, x19
0x00024454  bl       #0x55d78   ; CALL _objc_release
0x00024458  ldp      x29, x30, [sp, #0x70]
0x0002445c  ldp      x20, x19, [sp, #0x60]
0x00024460  ldp      x22, x21, [sp, #0x50]
0x00024464  ldp      x24, x23, [sp, #0x40]
0x00024468  add      sp, sp, #0x80
0x0002446c  ret      
0x00024470  mov      x8, x0
0x00024474  ldp      x2, x0, [x0, #0x20]
0x00024478  cbz      x2, #0x24480
0x0002447c  b        #0x5de20   ; CALL objc_msgSend$useVideo:
0x00024480  ldr      x2, [x8, #0x30]
0x00024484  b        #0x5de40   ; CALL objc_msgSend$useWallpaper:

=== -[OMCAppBridgeAppsController imagePickerControllerDidCancel:]  va=0x24488 size=16 types=v24@0:8@16
0x00024488  mov      x0, x2
0x0002448c  mov      w2, #1
0x00024490  mov      x3, #0
0x00024494  b        #0x57820   ; CALL objc_msgSend$dismissViewControllerAnimated:completion:

=== -[OMCAppBridgeAppsController table]  va=0x24498 size=16 types=@16@0:8
0x00024498  adrp     x8, #0x8e000
0x0002449c  ldrsw    x8, [x8, #0xe58]
0x000244a0  ldr      x0, [x0, x8]
0x000244a4  ret      

=== -[OMCAppBridgeAppsController setTable:]  va=0x244a8 size=64 types=v24@0:8@16
0x000244a8  stp      x22, x21, [sp, #-0x30]!
0x000244ac  stp      x20, x19, [sp, #0x10]
0x000244b0  stp      x29, x30, [sp, #0x20]
0x000244b4  add      x29, sp, #0x20
0x000244b8  mov      x19, x2
0x000244bc  mov      x20, x0
0x000244c0  adrp     x8, #0x8e000
0x000244c4  ldrsw    x21, [x8, #0xe58]
0x000244c8  mov      x0, x2
0x000244cc  bl       #0x55d84   ; CALL _objc_retain
0x000244d0  ldr      x0, [x20, x21]
0x000244d4  str      x19, [x20, x21]
0x000244d8  ldp      x29, x30, [sp, #0x20]
0x000244dc  ldp      x20, x19, [sp, #0x10]
0x000244e0  ldp      x22, x21, [sp], #0x30
0x000244e4  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController preview]  va=0x244e8 size=16 types=@16@0:8
0x000244e8  adrp     x8, #0x8e000
0x000244ec  ldrsw    x8, [x8, #0xe9c]
0x000244f0  ldr      x0, [x0, x8]
0x000244f4  ret      

=== -[OMCAppBridgeAppsController setPreview:]  va=0x244f8 size=64 types=v24@0:8@16
0x000244f8  stp      x22, x21, [sp, #-0x30]!
0x000244fc  stp      x20, x19, [sp, #0x10]
0x00024500  stp      x29, x30, [sp, #0x20]
0x00024504  add      x29, sp, #0x20
0x00024508  mov      x19, x2
0x0002450c  mov      x20, x0
0x00024510  adrp     x8, #0x8e000
0x00024514  ldrsw    x21, [x8, #0xe9c]
0x00024518  mov      x0, x2
0x0002451c  bl       #0x55d84   ; CALL _objc_retain
0x00024520  ldr      x0, [x20, x21]
0x00024524  str      x19, [x20, x21]
0x00024528  ldp      x29, x30, [sp, #0x20]
0x0002452c  ldp      x20, x19, [sp, #0x10]
0x00024530  ldp      x22, x21, [sp], #0x30
0x00024534  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController phoneApps]  va=0x24538 size=16 types=@16@0:8
0x00024538  adrp     x8, #0x8e000
0x0002453c  ldrsw    x8, [x8, #0xe64]
0x00024540  ldr      x0, [x0, x8]
0x00024544  ret      

=== -[OMCAppBridgeAppsController setPhoneApps:]  va=0x24548 size=64 types=v24@0:8@16
0x00024548  stp      x22, x21, [sp, #-0x30]!
0x0002454c  stp      x20, x19, [sp, #0x10]
0x00024550  stp      x29, x30, [sp, #0x20]
0x00024554  add      x29, sp, #0x20
0x00024558  mov      x19, x2
0x0002455c  mov      x20, x0
0x00024560  adrp     x8, #0x8e000
0x00024564  ldrsw    x21, [x8, #0xe64]
0x00024568  mov      x0, x2
0x0002456c  bl       #0x55d84   ; CALL _objc_retain
0x00024570  ldr      x0, [x20, x21]
0x00024574  str      x19, [x20, x21]
0x00024578  ldp      x29, x30, [sp, #0x20]
0x0002457c  ldp      x20, x19, [sp, #0x10]
0x00024580  ldp      x22, x21, [sp], #0x30
0x00024584  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController carplayApps]  va=0x24588 size=16 types=@16@0:8
0x00024588  adrp     x8, #0x8e000
0x0002458c  ldrsw    x8, [x8, #0xe6c]
0x00024590  ldr      x0, [x0, x8]
0x00024594  ret      

=== -[OMCAppBridgeAppsController setCarplayApps:]  va=0x24598 size=64 types=v24@0:8@16
0x00024598  stp      x22, x21, [sp, #-0x30]!
0x0002459c  stp      x20, x19, [sp, #0x10]
0x000245a0  stp      x29, x30, [sp, #0x20]
0x000245a4  add      x29, sp, #0x20
0x000245a8  mov      x19, x2
0x000245ac  mov      x20, x0
0x000245b0  adrp     x8, #0x8e000
0x000245b4  ldrsw    x21, [x8, #0xe6c]
0x000245b8  mov      x0, x2
0x000245bc  bl       #0x55d84   ; CALL _objc_retain
0x000245c0  ldr      x0, [x20, x21]
0x000245c4  str      x19, [x20, x21]
0x000245c8  ldp      x29, x30, [sp, #0x20]
0x000245cc  ldp      x20, x19, [sp, #0x10]
0x000245d0  ldp      x22, x21, [sp], #0x30
0x000245d4  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController guessApps]  va=0x245d8 size=16 types=@16@0:8
0x000245d8  adrp     x8, #0x8e000
0x000245dc  ldrsw    x8, [x8, #0xe70]
0x000245e0  ldr      x0, [x0, x8]
0x000245e4  ret      

=== -[OMCAppBridgeAppsController setGuessApps:]  va=0x245e8 size=64 types=v24@0:8@16
0x000245e8  stp      x22, x21, [sp, #-0x30]!
0x000245ec  stp      x20, x19, [sp, #0x10]
0x000245f0  stp      x29, x30, [sp, #0x20]
0x000245f4  add      x29, sp, #0x20
0x000245f8  mov      x19, x2
0x000245fc  mov      x20, x0
0x00024600  adrp     x8, #0x8e000
0x00024604  ldrsw    x21, [x8, #0xe70]
0x00024608  mov      x0, x2
0x0002460c  bl       #0x55d84   ; CALL _objc_retain
0x00024610  ldr      x0, [x20, x21]
0x00024614  str      x19, [x20, x21]
0x00024618  ldp      x29, x30, [sp, #0x20]
0x0002461c  ldp      x20, x19, [sp, #0x10]
0x00024620  ldp      x22, x21, [sp], #0x30
0x00024624  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController included]  va=0x24628 size=16 types=@16@0:8
0x00024628  adrp     x8, #0x8e000
0x0002462c  ldrsw    x8, [x8, #0xe94]
0x00024630  ldr      x0, [x0, x8]
0x00024634  ret      

=== -[OMCAppBridgeAppsController setIncluded:]  va=0x24638 size=64 types=v24@0:8@16
0x00024638  stp      x22, x21, [sp, #-0x30]!
0x0002463c  stp      x20, x19, [sp, #0x10]
0x00024640  stp      x29, x30, [sp, #0x20]
0x00024644  add      x29, sp, #0x20
0x00024648  mov      x19, x2
0x0002464c  mov      x20, x0
0x00024650  adrp     x8, #0x8e000
0x00024654  ldrsw    x21, [x8, #0xe94]
0x00024658  mov      x0, x2
0x0002465c  bl       #0x55d84   ; CALL _objc_retain
0x00024660  ldr      x0, [x20, x21]
0x00024664  str      x19, [x20, x21]
0x00024668  ldp      x29, x30, [sp, #0x20]
0x0002466c  ldp      x20, x19, [sp, #0x10]
0x00024670  ldp      x22, x21, [sp], #0x30
0x00024674  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController other]  va=0x24678 size=16 types=@16@0:8
0x00024678  adrp     x8, #0x8e000
0x0002467c  ldrsw    x8, [x8, #0xe98]
0x00024680  ldr      x0, [x0, x8]
0x00024684  ret      

=== -[OMCAppBridgeAppsController setOther:]  va=0x24688 size=64 types=v24@0:8@16
0x00024688  stp      x22, x21, [sp, #-0x30]!
0x0002468c  stp      x20, x19, [sp, #0x10]
0x00024690  stp      x29, x30, [sp, #0x20]
0x00024694  add      x29, sp, #0x20
0x00024698  mov      x19, x2
0x0002469c  mov      x20, x0
0x000246a0  adrp     x8, #0x8e000
0x000246a4  ldrsw    x21, [x8, #0xe98]
0x000246a8  mov      x0, x2
0x000246ac  bl       #0x55d84   ; CALL _objc_retain
0x000246b0  ldr      x0, [x20, x21]
0x000246b4  str      x19, [x20, x21]
0x000246b8  ldp      x29, x30, [sp, #0x20]
0x000246bc  ldp      x20, x19, [sp, #0x10]
0x000246c0  ldp      x22, x21, [sp], #0x30
0x000246c4  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController shown]  va=0x246c8 size=16 types=@16@0:8
0x000246c8  adrp     x8, #0x8e000
0x000246cc  ldrsw    x8, [x8, #0xe7c]
0x000246d0  ldr      x0, [x0, x8]
0x000246d4  ret      

=== -[OMCAppBridgeAppsController setShown:]  va=0x246d8 size=64 types=v24@0:8@16
0x000246d8  stp      x22, x21, [sp, #-0x30]!
0x000246dc  stp      x20, x19, [sp, #0x10]
0x000246e0  stp      x29, x30, [sp, #0x20]
0x000246e4  add      x29, sp, #0x20
0x000246e8  mov      x19, x2
0x000246ec  mov      x20, x0
0x000246f0  adrp     x8, #0x8e000
0x000246f4  ldrsw    x21, [x8, #0xe7c]
0x000246f8  mov      x0, x2
0x000246fc  bl       #0x55d84   ; CALL _objc_retain
0x00024700  ldr      x0, [x20, x21]
0x00024704  str      x19, [x20, x21]
0x00024708  ldp      x29, x30, [sp, #0x20]
0x0002470c  ldp      x20, x19, [sp, #0x10]
0x00024710  ldp      x22, x21, [sp], #0x30
0x00024714  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController iosOff]  va=0x24718 size=16 types=@16@0:8
0x00024718  adrp     x8, #0x8e000
0x0002471c  ldrsw    x8, [x8, #0xe68]
0x00024720  ldr      x0, [x0, x8]
0x00024724  ret      

=== -[OMCAppBridgeAppsController setIosOff:]  va=0x24728 size=64 types=v24@0:8@16
0x00024728  stp      x22, x21, [sp, #-0x30]!
0x0002472c  stp      x20, x19, [sp, #0x10]
0x00024730  stp      x29, x30, [sp, #0x20]
0x00024734  add      x29, sp, #0x20
0x00024738  mov      x19, x2
0x0002473c  mov      x20, x0
0x00024740  adrp     x8, #0x8e000
0x00024744  ldrsw    x21, [x8, #0xe68]
0x00024748  mov      x0, x2
0x0002474c  bl       #0x55d84   ; CALL _objc_retain
0x00024750  ldr      x0, [x20, x21]
0x00024754  str      x19, [x20, x21]
0x00024758  ldp      x29, x30, [sp, #0x20]
0x0002475c  ldp      x20, x19, [sp, #0x10]
0x00024760  ldp      x22, x21, [sp], #0x30
0x00024764  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController chosen]  va=0x24768 size=16 types=@16@0:8
0x00024768  adrp     x8, #0x8e000
0x0002476c  ldrsw    x8, [x8, #0xe74]
0x00024770  ldr      x0, [x0, x8]
0x00024774  ret      

=== -[OMCAppBridgeAppsController setChosen:]  va=0x24778 size=64 types=v24@0:8@16
0x00024778  stp      x22, x21, [sp, #-0x30]!
0x0002477c  stp      x20, x19, [sp, #0x10]
0x00024780  stp      x29, x30, [sp, #0x20]
0x00024784  add      x29, sp, #0x20
0x00024788  mov      x19, x2
0x0002478c  mov      x20, x0
0x00024790  adrp     x8, #0x8e000
0x00024794  ldrsw    x21, [x8, #0xe74]
0x00024798  mov      x0, x2
0x0002479c  bl       #0x55d84   ; CALL _objc_retain
0x000247a0  ldr      x0, [x20, x21]
0x000247a4  str      x19, [x20, x21]
0x000247a8  ldp      x29, x30, [sp, #0x20]
0x000247ac  ldp      x20, x19, [sp, #0x10]
0x000247b0  ldp      x22, x21, [sp], #0x30
0x000247b4  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController hidden]  va=0x247b8 size=16 types=@16@0:8
0x000247b8  adrp     x8, #0x8e000
0x000247bc  ldrsw    x8, [x8, #0xe78]
0x000247c0  ldr      x0, [x0, x8]
0x000247c4  ret      

=== -[OMCAppBridgeAppsController setHidden:]  va=0x247c8 size=64 types=v24@0:8@16
0x000247c8  stp      x22, x21, [sp, #-0x30]!
0x000247cc  stp      x20, x19, [sp, #0x10]
0x000247d0  stp      x29, x30, [sp, #0x20]
0x000247d4  add      x29, sp, #0x20
0x000247d8  mov      x19, x2
0x000247dc  mov      x20, x0
0x000247e0  adrp     x8, #0x8e000
0x000247e4  ldrsw    x21, [x8, #0xe78]
0x000247e8  mov      x0, x2
0x000247ec  bl       #0x55d84   ; CALL _objc_retain
0x000247f0  ldr      x0, [x20, x21]
0x000247f4  str      x19, [x20, x21]
0x000247f8  ldp      x29, x30, [sp, #0x20]
0x000247fc  ldp      x20, x19, [sp, #0x10]
0x00024800  ldp      x22, x21, [sp], #0x30
0x00024804  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController open]  va=0x24808 size=16 types=@16@0:8
0x00024808  adrp     x8, #0x8e000
0x0002480c  ldrsw    x8, [x8, #0xe60]
0x00024810  ldr      x0, [x0, x8]
0x00024814  ret      

=== -[OMCAppBridgeAppsController setOpen:]  va=0x24818 size=64 types=v24@0:8@16
0x00024818  stp      x22, x21, [sp, #-0x30]!
0x0002481c  stp      x20, x19, [sp, #0x10]
0x00024820  stp      x29, x30, [sp, #0x20]
0x00024824  add      x29, sp, #0x20
0x00024828  mov      x19, x2
0x0002482c  mov      x20, x0
0x00024830  adrp     x8, #0x8e000
0x00024834  ldrsw    x21, [x8, #0xe60]
0x00024838  mov      x0, x2
0x0002483c  bl       #0x55d84   ; CALL _objc_retain
0x00024840  ldr      x0, [x20, x21]
0x00024844  str      x19, [x20, x21]
0x00024848  ldp      x29, x30, [sp, #0x20]
0x0002484c  ldp      x20, x19, [sp, #0x10]
0x00024850  ldp      x22, x21, [sp], #0x30
0x00024854  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController query]  va=0x24858 size=16 types=@16@0:8
0x00024858  adrp     x8, #0x8e000
0x0002485c  ldrsw    x8, [x8, #0xe90]
0x00024860  ldr      x0, [x0, x8]
0x00024864  ret      

=== -[OMCAppBridgeAppsController setQuery:]  va=0x24868 size=12 types=v24@0:8@16
0x00024868  adrp     x8, #0x8e000
0x0002486c  ldrsw    x3, [x8, #0xe90]
0x00024870  b        #0x55dc0   ; CALL _objc_setProperty_nonatomic_copy

=== -[OMCAppBridgeAppsController wallpaper]  va=0x24874 size=16 types=@16@0:8
0x00024874  adrp     x8, #0x8e000
0x00024878  ldrsw    x8, [x8, #0xe8c]
0x0002487c  ldr      x0, [x0, x8]
0x00024880  ret      

=== -[OMCAppBridgeAppsController setWallpaper:]  va=0x24884 size=64 types=v24@0:8@16
0x00024884  stp      x22, x21, [sp, #-0x30]!
0x00024888  stp      x20, x19, [sp, #0x10]
0x0002488c  stp      x29, x30, [sp, #0x20]
0x00024890  add      x29, sp, #0x20
0x00024894  mov      x19, x2
0x00024898  mov      x20, x0
0x0002489c  adrp     x8, #0x8e000
0x000248a0  ldrsw    x21, [x8, #0xe8c]
0x000248a4  mov      x0, x2
0x000248a8  bl       #0x55d84   ; CALL _objc_retain
0x000248ac  ldr      x0, [x20, x21]
0x000248b0  str      x19, [x20, x21]
0x000248b4  ldp      x29, x30, [sp, #0x20]
0x000248b8  ldp      x20, x19, [sp, #0x10]
0x000248bc  ldp      x22, x21, [sp], #0x30
0x000248c0  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController photo]  va=0x248c4 size=16 types=@16@0:8
0x000248c4  adrp     x8, #0x8e000
0x000248c8  ldrsw    x8, [x8, #0xe80]
0x000248cc  ldr      x0, [x0, x8]
0x000248d0  ret      

=== -[OMCAppBridgeAppsController setPhoto:]  va=0x248d4 size=64 types=v24@0:8@16
0x000248d4  stp      x22, x21, [sp, #-0x30]!
0x000248d8  stp      x20, x19, [sp, #0x10]
0x000248dc  stp      x29, x30, [sp, #0x20]
0x000248e0  add      x29, sp, #0x20
0x000248e4  mov      x19, x2
0x000248e8  mov      x20, x0
0x000248ec  adrp     x8, #0x8e000
0x000248f0  ldrsw    x21, [x8, #0xe80]
0x000248f4  mov      x0, x2
0x000248f8  bl       #0x55d84   ; CALL _objc_retain
0x000248fc  ldr      x0, [x20, x21]
0x00024900  str      x19, [x20, x21]
0x00024904  ldp      x29, x30, [sp, #0x20]
0x00024908  ldp      x20, x19, [sp, #0x10]
0x0002490c  ldp      x22, x21, [sp], #0x30
0x00024910  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController videoThumb]  va=0x24914 size=16 types=@16@0:8
0x00024914  adrp     x8, #0x8e000
0x00024918  ldrsw    x8, [x8, #0xe84]
0x0002491c  ldr      x0, [x0, x8]
0x00024920  ret      

=== -[OMCAppBridgeAppsController setVideoThumb:]  va=0x24924 size=64 types=v24@0:8@16
0x00024924  stp      x22, x21, [sp, #-0x30]!
0x00024928  stp      x20, x19, [sp, #0x10]
0x0002492c  stp      x29, x30, [sp, #0x20]
0x00024930  add      x29, sp, #0x20
0x00024934  mov      x19, x2
0x00024938  mov      x20, x0
0x0002493c  adrp     x8, #0x8e000
0x00024940  ldrsw    x21, [x8, #0xe84]
0x00024944  mov      x0, x2
0x00024948  bl       #0x55d84   ; CALL _objc_retain
0x0002494c  ldr      x0, [x20, x21]
0x00024950  str      x19, [x20, x21]
0x00024954  ldp      x29, x30, [sp, #0x20]
0x00024958  ldp      x20, x19, [sp, #0x10]
0x0002495c  ldp      x22, x21, [sp], #0x30
0x00024960  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController wallStyle]  va=0x24964 size=16 types=q16@0:8
0x00024964  adrp     x8, #0x8e000
0x00024968  ldrsw    x8, [x8, #0xe88]
0x0002496c  ldr      x0, [x0, x8]
0x00024970  ret      

=== -[OMCAppBridgeAppsController setWallStyle:]  va=0x24974 size=16 types=v24@0:8q16
0x00024974  adrp     x8, #0x8e000
0x00024978  ldrsw    x8, [x8, #0xe88]
0x0002497c  str      x2, [x0, x8]
0x00024980  ret      

=== -[OMCAppBridgeAppsController icons]  va=0x24984 size=16 types=@16@0:8
0x00024984  adrp     x8, #0x8e000
0x00024988  ldrsw    x8, [x8, #0xe5c]
0x0002498c  ldr      x0, [x0, x8]
0x00024990  ret      

=== -[OMCAppBridgeAppsController setIcons:]  va=0x24994 size=64 types=v24@0:8@16
0x00024994  stp      x22, x21, [sp, #-0x30]!
0x00024998  stp      x20, x19, [sp, #0x10]
0x0002499c  stp      x29, x30, [sp, #0x20]
0x000249a0  add      x29, sp, #0x20
0x000249a4  mov      x19, x2
0x000249a8  mov      x20, x0
0x000249ac  adrp     x8, #0x8e000
0x000249b0  ldrsw    x21, [x8, #0xe5c]
0x000249b4  mov      x0, x2
0x000249b8  bl       #0x55d84   ; CALL _objc_retain
0x000249bc  ldr      x0, [x20, x21]
0x000249c0  str      x19, [x20, x21]
0x000249c4  ldp      x29, x30, [sp, #0x20]
0x000249c8  ldp      x20, x19, [sp, #0x10]
0x000249cc  ldp      x22, x21, [sp], #0x30
0x000249d0  b        #0x55d78   ; CALL _objc_release

=== -[OMCAppBridgeAppsController .cxx_destruct]  va=0x249d4 size=364 types=v16@0:8
0x000249d4  stp      x20, x19, [sp, #-0x20]!
0x000249d8  stp      x29, x30, [sp, #0x10]
0x000249dc  add      x29, sp, #0x10
0x000249e0  mov      x19, x0
0x000249e4  adrp     x8, #0x8e000
0x000249e8  ldrsw    x8, [x8, #0xe5c]
0x000249ec  add      x0, x0, x8
0x000249f0  mov      x1, #0
0x000249f4  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000249f8  adrp     x8, #0x8e000
0x000249fc  ldrsw    x8, [x8, #0xe84]
0x00024a00  add      x0, x19, x8
0x00024a04  mov      x1, #0
0x00024a08  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00024a0c  adrp     x8, #0x8e000
0x00024a10  ldrsw    x8, [x8, #0xe80]
0x00024a14  add      x0, x19, x8
0x00024a18  mov      x1, #0
0x00024a1c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00024a20  adrp     x8, #0x8e000
0x00024a24  ldrsw    x8, [x8, #0xe8c]
0x00024a28  add      x0, x19, x8
0x00024a2c  mov      x1, #0
0x00024a30  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00024a34  adrp     x8, #0x8e000
0x00024a38  ldrsw    x8, [x8, #0xe90]
0x00024a3c  add      x0, x19, x8
0x00024a40  mov      x1, #0
0x00024a44  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00024a48  adrp     x8, #0x8e000
0x00024a4c  ldrsw    x8, [x8, #0xe60]
0x00024a50  add      x0, x19, x8
0x00024a54  mov      x1, #0
0x00024a58  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00024a5c  adrp     x8, #0x8e000
0x00024a60  ldrsw    x8, [x8, #0xe78]
0x00024a64  add      x0, x19, x8
0x00024a68  mov      x1, #0
0x00024a6c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00024a70  adrp     x8, #0x8e000
0x00024a74  ldrsw    x8, [x8, #0xe74]
0x00024a78  add      x0, x19, x8
0x00024a7c  mov      x1, #0
0x00024a80  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00024a84  adrp     x8, #0x8e000
0x00024a88  ldrsw    x8, [x8, #0xe68]
0x00024a8c  add      x0, x19, x8
0x00024a90  mov      x1, #0
0x00024a94  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00024a98  adrp     x8, #0x8e000
0x00024a9c  ldrsw    x8, [x8, #0xe7c]
0x00024aa0  add      x0, x19, x8
0x00024aa4  mov      x1, #0
0x00024aa8  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00024aac  adrp     x8, #0x8e000
0x00024ab0  ldrsw    x8, [x8, #0xe98]
0x00024ab4  add      x0, x19, x8
0x00024ab8  mov      x1, #0
0x00024abc  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00024ac0  adrp     x8, #0x8e000
0x00024ac4  ldrsw    x8, [x8, #0xe94]
0x00024ac8  add      x0, x19, x8
0x00024acc  mov      x1, #0
0x00024ad0  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00024ad4  adrp     x8, #0x8e000
0x00024ad8  ldrsw    x8, [x8, #0xe70]
0x00024adc  add      x0, x19, x8
0x00024ae0  mov      x1, #0
0x00024ae4  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00024ae8  adrp     x8, #0x8e000
0x00024aec  ldrsw    x8, [x8, #0xe6c]
0x00024af0  add      x0, x19, x8
0x00024af4  mov      x1, #0
0x00024af8  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00024afc  adrp     x8, #0x8e000
0x00024b00  ldrsw    x8, [x8, #0xe64]
0x00024b04  add      x0, x19, x8
0x00024b08  mov      x1, #0
0x00024b0c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00024b10  adrp     x8, #0x8e000
0x00024b14  ldrsw    x8, [x8, #0xe9c]
0x00024b18  add      x0, x19, x8
0x00024b1c  mov      x1, #0
0x00024b20  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00024b24  adrp     x8, #0x8e000
0x00024b28  ldrsw    x8, [x8, #0xe58]
0x00024b2c  add      x0, x19, x8
0x00024b30  mov      x1, #0
0x00024b34  ldp      x29, x30, [sp, #0x10]
0x00024b38  ldp      x20, x19, [sp], #0x20
0x00024b3c  b        #0x55dcc   ; CALL _objc_storeStrong
