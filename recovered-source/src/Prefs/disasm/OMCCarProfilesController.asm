=== -[OMCCarProfilesController loadView]  va=0x5844 size=120 types=v16@0:8
0x00005844  stp      x20, x19, [sp, #-0x20]!
0x00005848  stp      x29, x30, [sp, #0x10]
0x0000584c  add      x29, sp, #0x10
0x00005850  mov      x19, x0
0x00005854  adrp     x8, #0x8e000
0x00005858  ldr      x0, [x8, #0x900]   ; @CLASS UITableView
0x0000585c  bl       #0x55c7c   ; CALL _objc_alloc
0x00005860  adrp     x8, #0x74000
0x00005864  ldr      x8, [x8, #0x610]   ; @GOT _CGRectZero
0x00005868  ldp      d0, d1, [x8]
0x0000586c  ldp      d2, d3, [x8, #0x10]
0x00005870  mov      w2, #2
0x00005874  bl       #0x584a0   ; CALL objc_msgSend$initWithFrame:style:
0x00005878  adrp     x8, #0x8e000
0x0000587c  ldrsw    x20, [x8, #0xdc4]
0x00005880  ldr      x8, [x19, x20]
0x00005884  str      x0, [x19, x20]
0x00005888  mov      x0, x8
0x0000588c  bl       #0x55d78   ; CALL _objc_release
0x00005890  ldr      x0, [x19, x20]
0x00005894  mov      x2, x19
0x00005898  bl       #0x5ac00   ; CALL objc_msgSend$setDataSource:
0x0000589c  ldr      x0, [x19, x20]
0x000058a0  mov      x2, x19
0x000058a4  bl       #0x5aca0   ; CALL objc_msgSend$setDelegate:
0x000058a8  ldr      x2, [x19, x20]
0x000058ac  mov      x0, x19
0x000058b0  ldp      x29, x30, [sp, #0x10]
0x000058b4  ldp      x20, x19, [sp], #0x20
0x000058b8  b        #0x5c840   ; CALL objc_msgSend$setView:

=== -[OMCCarProfilesController viewDidLoad]  va=0x58bc size=296 types=v16@0:8
0x000058bc  sub      sp, sp, #0x40
0x000058c0  stp      x22, x21, [sp, #0x10]
0x000058c4  stp      x20, x19, [sp, #0x20]
0x000058c8  stp      x29, x30, [sp, #0x30]
0x000058cc  add      x29, sp, #0x30
0x000058d0  mov      x19, x0
0x000058d4  adrp     x8, #0x8e000
0x000058d8  ldr      x8, [x8, #0xd10]   ; @SUPER OMCCarProfilesController
0x000058dc  stp      x0, x8, [sp]
0x000058e0  adrp     x8, #0x8b000
0x000058e4  ldr      x1, [x8, #0xda0]   ; @SEL "viewDidLoad"
0x000058e8  mov      x0, sp
0x000058ec  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x000058f0  bl       #0x17a44   ; CALL _OMCLoadStrings
0x000058f4  mov      x0, x19
0x000058f8  bl       #0x5cdc0   ; CALL objc_msgSend$specifier
0x000058fc  mov      x29, x29
0x00005900  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005904  mov      x20, x0
0x00005908  bl       #0x590e0   ; CALL objc_msgSend$name
0x0000590c  mov      x29, x29
0x00005910  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005914  mov      x21, x0
0x00005918  cbz      x0, #0x592c
0x0000591c  mov      x0, x19
0x00005920  mov      x2, x21
0x00005924  bl       #0x5c5e0   ; CALL objc_msgSend$setTitle:
0x00005928  b        #0x5958
0x0000592c  adrp     x0, #0x75000
0x00005930  add      x0, x0, #0x68   ; STR "PROFILES"
0x00005934  bl       #0x17e20   ; CALL _L
0x00005938  mov      x29, x29
0x0000593c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005940  mov      x22, x0
0x00005944  mov      x0, x19
0x00005948  mov      x2, x22
0x0000594c  bl       #0x5c5e0   ; CALL objc_msgSend$setTitle:
0x00005950  mov      x0, x22
0x00005954  bl       #0x55d78   ; CALL _objc_release
0x00005958  mov      x0, x21
0x0000595c  bl       #0x55d78   ; CALL _objc_release
0x00005960  mov      x0, x20
0x00005964  bl       #0x55d78   ; CALL _objc_release
0x00005968  bl       #0x17e8c   ; CALL _OMCAccentColor
0x0000596c  mov      x29, x29
0x00005970  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005974  mov      x20, x0
0x00005978  mov      x0, x19
0x0000597c  bl       #0x5df60   ; CALL objc_msgSend$view
0x00005980  mov      x29, x29
0x00005984  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005988  mov      x21, x0
0x0000598c  mov      x2, x20
0x00005990  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x00005994  mov      x0, x21
0x00005998  bl       #0x55d78   ; CALL _objc_release
0x0000599c  mov      x0, x20
0x000059a0  bl       #0x55d78   ; CALL _objc_release
0x000059a4  bl       #0x17fe4   ; CALL _OMCBackgroundColor
0x000059a8  mov      x29, x29
0x000059ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000059b0  mov      x20, x0
0x000059b4  adrp     x8, #0x8e000
0x000059b8  ldrsw    x8, [x8, #0xdc4]
0x000059bc  ldr      x0, [x19, x8]
0x000059c0  mov      x2, x20
0x000059c4  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x000059c8  mov      x0, x20
0x000059cc  bl       #0x55d78   ; CALL _objc_release
0x000059d0  ldp      x29, x30, [sp, #0x30]
0x000059d4  ldp      x20, x19, [sp, #0x20]
0x000059d8  ldp      x22, x21, [sp, #0x10]
0x000059dc  add      sp, sp, #0x40
0x000059e0  ret      

=== -[OMCCarProfilesController viewWillAppear:]  va=0x59e4 size=72 types=v20@0:8B16
0x000059e4  sub      sp, sp, #0x30
0x000059e8  stp      x20, x19, [sp, #0x10]
0x000059ec  stp      x29, x30, [sp, #0x20]
0x000059f0  add      x29, sp, #0x20
0x000059f4  mov      x19, x0
0x000059f8  adrp     x8, #0x8e000
0x000059fc  ldr      x8, [x8, #0xd10]   ; @SUPER OMCCarProfilesController
0x00005a00  stp      x0, x8, [sp]
0x00005a04  adrp     x8, #0x8b000
0x00005a08  ldr      x1, [x8, #0xda8]   ; @SEL "viewWillAppear:"
0x00005a0c  mov      x0, sp
0x00005a10  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00005a14  mov      x0, x19
0x00005a18  bl       #0x59c60   ; CALL objc_msgSend$reload
0x00005a1c  ldp      x29, x30, [sp, #0x20]
0x00005a20  ldp      x20, x19, [sp, #0x10]
0x00005a24  add      sp, sp, #0x30
0x00005a28  ret      

=== -[OMCCarProfilesController reload]  va=0x5a2c size=692 types=v16@0:8
0x00005a2c  sub      sp, sp, #0x70
0x00005a30  stp      x24, x23, [sp, #0x30]
0x00005a34  stp      x22, x21, [sp, #0x40]
0x00005a38  stp      x20, x19, [sp, #0x50]
0x00005a3c  stp      x29, x30, [sp, #0x60]
0x00005a40  add      x29, sp, #0x60
0x00005a44  mov      x20, x0
0x00005a48  adrp     x0, #0x75000
0x00005a4c  add      x0, x0, #0x28   ; STR "com.anlai.omnicar"
0x00005a50  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x00005a54  adrp     x0, #0x75000
0x00005a58  add      x0, x0, #0x88   ; STR "carProfiles"
0x00005a5c  bl       #0x5b64
0x00005a60  mov      x29, x29
0x00005a64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005a68  mov      x19, x0
0x00005a6c  adrp     x8, #0x8e000
0x00005a70  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00005a74  bl       #0x55d48   ; CALL _objc_opt_class
0x00005a78  mov      x1, x0
0x00005a7c  mov      x0, x19
0x00005a80  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00005a84  adrp     x8, #0x74000
0x00005a88  ldr      x8, [x8, #0x1a8]   ; @GOT ___NSDictionary0__struct
0x00005a8c  tst      w0, #1
0x00005a90  csel     x2, x19, x8, ne
0x00005a94  mov      x0, x20
0x00005a98  bl       #0x5bd40   ; CALL objc_msgSend$setProfiles:
0x00005a9c  mov      x0, x20
0x00005aa0  bl       #0x59a80   ; CALL objc_msgSend$profiles
0x00005aa4  mov      x29, x29
0x00005aa8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005aac  mov      x21, x0
0x00005ab0  bl       #0x562a0   ; CALL objc_msgSend$allKeys
0x00005ab4  mov      x29, x29
0x00005ab8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005abc  mov      x22, x0
0x00005ac0  adrp     x8, #0x74000
0x00005ac4  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00005ac8  str      x8, [sp, #8]
0x00005acc  adrp     x8, #0x65000
0x00005ad0  ldr      d0, [x8, #0x600]
0x00005ad4  adrp     x8, #0x5000
0x00005ad8  add      x8, x8, #0xb80
0x00005adc  str      d0, [sp, #0x10]
0x00005ae0  adrp     x9, #0x74000
0x00005ae4  add      x9, x9, #0x740
0x00005ae8  stp      x8, x9, [sp, #0x18]
0x00005aec  str      x20, [sp, #0x28]
0x00005af0  add      x2, sp, #8
0x00005af4  bl       #0x5cce0   ; CALL objc_msgSend$sortedArrayUsingComparator:
0x00005af8  mov      x29, x29
0x00005afc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005b00  mov      x23, x0
0x00005b04  mov      x0, x20
0x00005b08  mov      x2, x23
0x00005b0c  bl       #0x5b200   ; CALL objc_msgSend$setKeys:
0x00005b10  mov      x0, x23
0x00005b14  bl       #0x55d78   ; CALL _objc_release
0x00005b18  mov      x0, x22
0x00005b1c  bl       #0x55d78   ; CALL _objc_release
0x00005b20  mov      x0, x21
0x00005b24  bl       #0x55d78   ; CALL _objc_release
0x00005b28  mov      x0, x20
0x00005b2c  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x00005b30  mov      x29, x29
0x00005b34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005b38  mov      x20, x0
0x00005b3c  bl       #0x59ca0   ; CALL objc_msgSend$reloadData
0x00005b40  mov      x0, x20
0x00005b44  bl       #0x55d78   ; CALL _objc_release
0x00005b48  mov      x0, x19
0x00005b4c  ldp      x29, x30, [sp, #0x60]
0x00005b50  ldp      x20, x19, [sp, #0x50]
0x00005b54  ldp      x22, x21, [sp, #0x40]
0x00005b58  ldp      x24, x23, [sp, #0x30]
0x00005b5c  add      sp, sp, #0x70
0x00005b60  b        #0x55d78   ; CALL _objc_release
0x00005b64  stp      x29, x30, [sp, #-0x10]!
0x00005b68  mov      x29, sp
0x00005b6c  adrp     x1, #0x75000
0x00005b70  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x00005b74  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x00005b78  ldp      x29, x30, [sp], #0x10
0x00005b7c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00005b80  stp      x24, x23, [sp, #-0x40]!
0x00005b84  stp      x22, x21, [sp, #0x10]
0x00005b88  stp      x20, x19, [sp, #0x20]
0x00005b8c  stp      x29, x30, [sp, #0x30]
0x00005b90  add      x29, sp, #0x30
0x00005b94  mov      x20, x2
0x00005b98  mov      x19, x1
0x00005b9c  mov      x21, x0
0x00005ba0  ldr      x22, [x0, #0x20]   ; @STR "lastSeen"
0x00005ba4  mov      x0, x2
0x00005ba8  bl       #0x55d84   ; CALL _objc_retain
0x00005bac  mov      x0, x19
0x00005bb0  bl       #0x55d84   ; CALL _objc_retain
0x00005bb4  mov      x0, x22
0x00005bb8  bl       #0x59a80   ; CALL objc_msgSend$profiles
0x00005bbc  mov      x29, x29
0x00005bc0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005bc4  mov      x22, x0
0x00005bc8  mov      x2, x19
0x00005bcc  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00005bd0  mov      x29, x29
0x00005bd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005bd8  mov      x23, x0
0x00005bdc  mov      x0, x19
0x00005be0  bl       #0x55d78   ; CALL _objc_release
0x00005be4  adrp     x24, #0x75000
0x00005be8  add      x24, x24, #0xa8   ; STR "lastSeen"
0x00005bec  mov      x0, x23
0x00005bf0  mov      x2, x24
0x00005bf4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00005bf8  mov      x29, x29
0x00005bfc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005c00  mov      x19, x0
0x00005c04  mov      x0, x23
0x00005c08  bl       #0x55d78   ; CALL _objc_release
0x00005c0c  mov      x0, x22
0x00005c10  bl       #0x55d78   ; CALL _objc_release
0x00005c14  ldr      x0, [x21, #0x20]
0x00005c18  bl       #0x59a80   ; CALL objc_msgSend$profiles
0x00005c1c  mov      x29, x29
0x00005c20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005c24  mov      x21, x0
0x00005c28  mov      x2, x20
0x00005c2c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00005c30  mov      x29, x29
0x00005c34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005c38  mov      x22, x0
0x00005c3c  mov      x0, x20
0x00005c40  bl       #0x55d78   ; CALL _objc_release
0x00005c44  mov      x0, x22
0x00005c48  mov      x2, x24
0x00005c4c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00005c50  mov      x29, x29
0x00005c54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005c58  mov      x20, x0
0x00005c5c  mov      x0, x22
0x00005c60  bl       #0x55d78   ; CALL _objc_release
0x00005c64  mov      x0, x21
0x00005c68  bl       #0x55d78   ; CALL _objc_release
0x00005c6c  adrp     x21, #0x8e000
0x00005c70  ldr      x0, [x21, #0x978]   ; @CLASS NSDate
0x00005c74  bl       #0x55d48   ; CALL _objc_opt_class
0x00005c78  mov      x1, x0
0x00005c7c  mov      x0, x19
0x00005c80  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00005c84  tbz      w0, #0, #0x5cb4
0x00005c88  ldr      x0, [x21, #0x978]   ; @CLASS NSDate
0x00005c8c  bl       #0x55d48   ; CALL _objc_opt_class
0x00005c90  mov      x1, x0
0x00005c94  mov      x0, x20
0x00005c98  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00005c9c  tbz      w0, #0, #0x5cb4
0x00005ca0  mov      x0, x20
0x00005ca4  mov      x2, x19
0x00005ca8  bl       #0x56f60   ; CALL objc_msgSend$compare:
0x00005cac  mov      x21, x0
0x00005cb0  b        #0x5cb8
0x00005cb4  mov      x21, #0
0x00005cb8  mov      x0, x20
0x00005cbc  bl       #0x55d78   ; CALL _objc_release
0x00005cc0  mov      x0, x19
0x00005cc4  bl       #0x55d78   ; CALL _objc_release
0x00005cc8  mov      x0, x21
0x00005ccc  ldp      x29, x30, [sp, #0x30]
0x00005cd0  ldp      x20, x19, [sp, #0x20]
0x00005cd4  ldp      x22, x21, [sp, #0x10]
0x00005cd8  ldp      x24, x23, [sp], #0x40
0x00005cdc  ret      

=== -[OMCCarProfilesController enabledChanged:]  va=0x5ce0 size=140 types=v24@0:8@16
0x00005ce0  stp      x20, x19, [sp, #-0x20]!
0x00005ce4  stp      x29, x30, [sp, #0x10]
0x00005ce8  add      x29, sp, #0x10
0x00005cec  mov      x0, x2
0x00005cf0  adrp     x8, #0x8e000
0x00005cf4  ldr      x19, [x8, #0x928]   ; @CLASS NSNumber
0x00005cf8  bl       #0x588c0   ; CALL objc_msgSend$isOn
0x00005cfc  mov      x2, x0
0x00005d00  mov      x0, x19
0x00005d04  bl       #0x592c0   ; CALL objc_msgSend$numberWithBool:
0x00005d08  mov      x29, x29
0x00005d0c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005d10  mov      x19, x0
0x00005d14  adrp     x0, #0x75000
0x00005d18  add      x0, x0, #0xc8   ; STR "carProfilesEnabled"
0x00005d1c  mov      x1, x19
0x00005d20  bl       #0x5d34
0x00005d24  mov      x0, x19
0x00005d28  ldp      x29, x30, [sp, #0x10]
0x00005d2c  ldp      x20, x19, [sp], #0x20
0x00005d30  b        #0x55d78   ; CALL _objc_release
0x00005d34  stp      x20, x19, [sp, #-0x20]!
0x00005d38  stp      x29, x30, [sp, #0x10]
0x00005d3c  add      x29, sp, #0x10
0x00005d40  adrp     x19, #0x75000
0x00005d44  add      x19, x19, #0x28   ; STR "com.anlai.omnicar"
0x00005d48  mov      x2, x19
0x00005d4c  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x00005d50  mov      x0, x19
0x00005d54  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x00005d58  adrp     x0, #0x61000
0x00005d5c  add      x0, x0, #0x1b1   ; CSTR "com.anlai.omnicar/prefschanged"
0x00005d60  ldp      x29, x30, [sp, #0x10]
0x00005d64  ldp      x20, x19, [sp], #0x20
0x00005d68  b        #0x55c70   ; CALL _notify_post

=== -[OMCCarProfilesController numberOfSectionsInTableView:]  va=0x5d6c size=8 types=q24@0:8@16
0x00005d6c  mov      w0, #2
0x00005d70  ret      

=== -[OMCCarProfilesController tableView:numberOfRowsInSection:]  va=0x5d74 size=76 types=q32@0:8@16q24
0x00005d74  cbz      x3, #0x5db8
0x00005d78  stp      x20, x19, [sp, #-0x20]!
0x00005d7c  stp      x29, x30, [sp, #0x10]
0x00005d80  add      x29, sp, #0x10
0x00005d84  bl       #0x589a0   ; CALL objc_msgSend$keys
0x00005d88  mov      x29, x29
0x00005d8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005d90  mov      x19, x0
0x00005d94  bl       #0x573c0   ; CALL objc_msgSend$count
0x00005d98  mov      x20, x0
0x00005d9c  mov      x0, x19
0x00005da0  bl       #0x55d78   ; CALL _objc_release
0x00005da4  cmp      x20, #1
0x00005da8  csinc    x0, x20, xzr, gt
0x00005dac  ldp      x29, x30, [sp, #0x10]
0x00005db0  ldp      x20, x19, [sp], #0x20
0x00005db4  ret      
0x00005db8  mov      w0, #1
0x00005dbc  ret      

=== -[OMCCarProfilesController tableView:titleForHeaderInSection:]  va=0x5dc0 size=52 types=@32@0:8@16q24
0x00005dc0  cmp      x3, #1
0x00005dc4  b.ne     #0x5dec
0x00005dc8  stp      x29, x30, [sp, #-0x10]!
0x00005dcc  mov      x29, sp
0x00005dd0  adrp     x0, #0x75000
0x00005dd4  add      x0, x0, #0xe8   ; STR "PROFILES_CARS"
0x00005dd8  bl       #0x17e20   ; CALL _L
0x00005ddc  mov      x29, x29
0x00005de0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005de4  ldp      x29, x30, [sp], #0x10
0x00005de8  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00005dec  mov      x0, #0
0x00005df0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCCarProfilesController tableView:titleForFooterInSection:]  va=0x5df4 size=124 types=@32@0:8@16q24
0x00005df4  stp      x20, x19, [sp, #-0x20]!
0x00005df8  stp      x29, x30, [sp, #0x10]
0x00005dfc  add      x29, sp, #0x10
0x00005e00  cbz      x3, #0x5e38
0x00005e04  bl       #0x589a0   ; CALL objc_msgSend$keys
0x00005e08  mov      x29, x29
0x00005e0c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005e10  mov      x19, x0
0x00005e14  bl       #0x573c0   ; CALL objc_msgSend$count
0x00005e18  cbz      x0, #0x5e54
0x00005e1c  adrp     x0, #0x75000
0x00005e20  add      x0, x0, #0x128   ; STR "PROFILES_CARS_FOOTER"
0x00005e24  bl       #0x17e20   ; CALL _L
0x00005e28  mov      x29, x29
0x00005e2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005e30  mov      x20, x0
0x00005e34  b        #0x5e58
0x00005e38  adrp     x0, #0x75000
0x00005e3c  add      x0, x0, #0x108   ; STR "PROFILES_FOOTER"
0x00005e40  bl       #0x17e20   ; CALL _L
0x00005e44  mov      x29, x29
0x00005e48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005e4c  mov      x20, x0
0x00005e50  b        #0x5e60
0x00005e54  mov      x20, #0
0x00005e58  mov      x0, x19
0x00005e5c  bl       #0x55d78   ; CALL _objc_release
0x00005e60  mov      x0, x20
0x00005e64  ldp      x29, x30, [sp, #0x10]
0x00005e68  ldp      x20, x19, [sp], #0x20
0x00005e6c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCCarProfilesController tableView:willDisplayHeaderView:forSection:]  va=0x5e70 size=12 types=v40@0:8@16@24q32
0x00005e70  mov      x0, x3
0x00005e74  mov      w1, #1
0x00005e78  b        #0x19300   ; CALL _OMCStyleHeaderFooter

=== -[OMCCarProfilesController tableView:willDisplayFooterView:forSection:]  va=0x5e7c size=12 types=v40@0:8@16@24q32
0x00005e7c  mov      x0, x3
0x00005e80  mov      w1, #0
0x00005e84  b        #0x19300   ; CALL _OMCStyleHeaderFooter

=== -[OMCCarProfilesController tableView:cellForRowAtIndexPath:]  va=0x5e88 size=1656 types=@32@0:8@16@24
0x00005e88  sub      sp, sp, #0x70
0x00005e8c  stp      x28, x27, [sp, #0x10]
0x00005e90  stp      x26, x25, [sp, #0x20]
0x00005e94  stp      x24, x23, [sp, #0x30]
0x00005e98  stp      x22, x21, [sp, #0x40]
0x00005e9c  stp      x20, x19, [sp, #0x50]
0x00005ea0  stp      x29, x30, [sp, #0x60]
0x00005ea4  add      x29, sp, #0x60
0x00005ea8  mov      x19, x3
0x00005eac  mov      x23, x2
0x00005eb0  mov      x22, x0
0x00005eb4  mov      x0, x3
0x00005eb8  bl       #0x55d84   ; CALL _objc_retain
0x00005ebc  mov      x0, x23
0x00005ec0  bl       #0x55d84   ; CALL _objc_retain
0x00005ec4  mov      x0, x19
0x00005ec8  bl       #0x5a180   ; CALL objc_msgSend$section
0x00005ecc  cbz      x0, #0x5f08
0x00005ed0  adrp     x2, #0x75000
0x00005ed4  add      x2, x2, #0x1a8   ; STR "car"
0x00005ed8  mov      x0, x23
0x00005edc  bl       #0x576e0   ; CALL objc_msgSend$dequeueReusableCellWithIdentifier:
0x00005ee0  mov      x29, x29
0x00005ee4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005ee8  mov      x21, x0
0x00005eec  mov      x0, x23
0x00005ef0  bl       #0x55d78   ; CALL _objc_release
0x00005ef4  cbz      x21, #0x6094
0x00005ef8  mov      x0, x21
0x00005efc  bl       #0x55d84   ; CALL _objc_retain
0x00005f00  mov      x20, x21
0x00005f04  b        #0x60b4
0x00005f08  adrp     x2, #0x75000
0x00005f0c  add      x2, x2, #0x148   ; STR "switch"
0x00005f10  mov      x0, x23
0x00005f14  bl       #0x576e0   ; CALL objc_msgSend$dequeueReusableCellWithIdentifier:
0x00005f18  mov      x29, x29
0x00005f1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005f20  mov      x20, x0
0x00005f24  mov      x0, x23
0x00005f28  bl       #0x55d78   ; CALL _objc_release
0x00005f2c  cbnz     x20, #0x5fbc
0x00005f30  adrp     x8, #0x8e000
0x00005f34  ldr      x0, [x8, #0x908]   ; @CLASS UITableViewCell
0x00005f38  bl       #0x55c7c   ; CALL _objc_alloc
0x00005f3c  adrp     x3, #0x75000
0x00005f40  add      x3, x3, #0x148   ; STR "switch"
0x00005f44  mov      x2, #0
0x00005f48  bl       #0x585c0   ; CALL objc_msgSend$initWithStyle:reuseIdentifier:
0x00005f4c  mov      x20, x0
0x00005f50  adrp     x8, #0x8e000
0x00005f54  ldr      x0, [x8, #0x920]   ; @CLASS UISwitch
0x00005f58  bl       #0x55d60   ; CALL _objc_opt_new
0x00005f5c  mov      x21, x0
0x00005f60  bl       #0x17fd8   ; CALL _OMCSwitchColor
0x00005f64  mov      x29, x29
0x00005f68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005f6c  mov      x23, x0
0x00005f70  mov      x0, x21
0x00005f74  mov      x2, x23
0x00005f78  bl       #0x5b920   ; CALL objc_msgSend$setOnTintColor:
0x00005f7c  mov      x0, x23
0x00005f80  bl       #0x55d78   ; CALL _objc_release
0x00005f84  adrp     x8, #0x8b000
0x00005f88  ldr      x3, [x8, #0xdd8]   ; @SEL "enabledChanged:"
0x00005f8c  mov      x0, x21
0x00005f90  mov      x2, x22
0x00005f94  mov      w4, #0x1000
0x00005f98  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x00005f9c  mov      x0, x20
0x00005fa0  mov      x2, x21
0x00005fa4  bl       #0x5a2c0   ; CALL objc_msgSend$setAccessoryView:
0x00005fa8  mov      x0, x20
0x00005fac  mov      x2, #0
0x00005fb0  bl       #0x5bfa0   ; CALL objc_msgSend$setSelectionStyle:
0x00005fb4  mov      x0, x21
0x00005fb8  bl       #0x55d78   ; CALL _objc_release
0x00005fbc  mov      x0, x20
0x00005fc0  bl       #0x19168   ; CALL _OMCStyleCell
0x00005fc4  adrp     x0, #0x75000
0x00005fc8  add      x0, x0, #0x168   ; STR "PROFILES_ENABLE"
0x00005fcc  bl       #0x17e20   ; CALL _L
0x00005fd0  mov      x29, x29
0x00005fd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005fd8  mov      x21, x0
0x00005fdc  mov      x0, x20
0x00005fe0  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00005fe4  mov      x29, x29
0x00005fe8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005fec  mov      x22, x0
0x00005ff0  mov      x2, x21
0x00005ff4  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00005ff8  mov      x0, x22
0x00005ffc  bl       #0x55d78   ; CALL _objc_release
0x00006000  mov      x0, x21
0x00006004  bl       #0x55d78   ; CALL _objc_release
0x00006008  adrp     x0, #0x75000
0x0000600c  add      x0, x0, #0x188   ; STR "car.2.fill"
0x00006010  mov      x1, #0
0x00006014  bl       #0x18144   ; CALL _OMCIcon
0x00006018  mov      x29, x29
0x0000601c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006020  mov      x21, x0
0x00006024  mov      x0, x20
0x00006028  bl       #0x58120   ; CALL objc_msgSend$imageView
0x0000602c  mov      x29, x29
0x00006030  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006034  mov      x22, x0
0x00006038  mov      x2, x21
0x0000603c  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00006040  mov      x0, x22
0x00006044  bl       #0x55d78   ; CALL _objc_release
0x00006048  mov      x0, x21
0x0000604c  bl       #0x55d78   ; CALL _objc_release
0x00006050  adrp     x0, #0x75000
0x00006054  add      x0, x0, #0xc8   ; STR "carProfilesEnabled"
0x00006058  bl       #0x5b64
0x0000605c  mov      x29, x29
0x00006060  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006064  mov      x21, x0
0x00006068  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x0000606c  mov      x22, x0
0x00006070  mov      x0, x20
0x00006074  bl       #0x55f80   ; CALL objc_msgSend$accessoryView
0x00006078  mov      x29, x29
0x0000607c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006080  mov      x23, x0
0x00006084  mov      x2, x22
0x00006088  bl       #0x5b900   ; CALL objc_msgSend$setOn:
0x0000608c  mov      x0, x23
0x00006090  b        #0x64c8
0x00006094  adrp     x8, #0x8e000
0x00006098  ldr      x0, [x8, #0x908]   ; @CLASS UITableViewCell
0x0000609c  bl       #0x55c7c   ; CALL _objc_alloc
0x000060a0  adrp     x3, #0x75000
0x000060a4  add      x3, x3, #0x1a8   ; STR "car"
0x000060a8  mov      w2, #3
0x000060ac  bl       #0x585c0   ; CALL objc_msgSend$initWithStyle:reuseIdentifier:
0x000060b0  mov      x20, x0
0x000060b4  mov      x0, x21
0x000060b8  bl       #0x55d78   ; CALL _objc_release
0x000060bc  mov      x0, x20
0x000060c0  bl       #0x19168   ; CALL _OMCStyleCell
0x000060c4  mov      x0, x20
0x000060c8  mov      x2, #0
0x000060cc  bl       #0x5bfa0   ; CALL objc_msgSend$setSelectionStyle:
0x000060d0  adrp     x24, #0x8e000
0x000060d4  ldr      x0, [x24, #0x910]   ; @CLASS UIColor
0x000060d8  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x000060dc  mov      x29, x29
0x000060e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000060e4  mov      x21, x0
0x000060e8  mov      x0, x20
0x000060ec  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x000060f0  mov      x29, x29
0x000060f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000060f8  mov      x23, x0
0x000060fc  mov      x2, x21
0x00006100  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00006104  mov      x0, x23
0x00006108  bl       #0x55d78   ; CALL _objc_release
0x0000610c  mov      x0, x21
0x00006110  bl       #0x55d78   ; CALL _objc_release
0x00006114  mov      x0, x22
0x00006118  bl       #0x589a0   ; CALL objc_msgSend$keys
0x0000611c  mov      x29, x29
0x00006120  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006124  mov      x21, x0
0x00006128  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000612c  mov      x23, x0
0x00006130  mov      x0, x21
0x00006134  bl       #0x55d78   ; CALL _objc_release
0x00006138  cbz      x23, #0x6318
0x0000613c  mov      x0, x22
0x00006140  bl       #0x589a0   ; CALL objc_msgSend$keys
0x00006144  mov      x29, x29
0x00006148  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000614c  mov      x23, x0
0x00006150  mov      x0, x19
0x00006154  bl       #0x59f60   ; CALL objc_msgSend$row
0x00006158  mov      x2, x0
0x0000615c  mov      x0, x23
0x00006160  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00006164  mov      x29, x29
0x00006168  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000616c  mov      x21, x0
0x00006170  mov      x0, x23
0x00006174  bl       #0x55d78   ; CALL _objc_release
0x00006178  mov      x0, x22
0x0000617c  bl       #0x59a80   ; CALL objc_msgSend$profiles
0x00006180  mov      x29, x29
0x00006184  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006188  mov      x23, x0
0x0000618c  mov      x2, x21
0x00006190  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00006194  mov      x29, x29
0x00006198  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000619c  mov      x22, x0
0x000061a0  mov      x0, x23
0x000061a4  bl       #0x55d78   ; CALL _objc_release
0x000061a8  ldr      x0, [x24, #0x910]   ; @CLASS UIColor
0x000061ac  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x000061b0  mov      x29, x29
0x000061b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000061b8  mov      x23, x0
0x000061bc  mov      x0, x20
0x000061c0  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x000061c4  mov      x29, x29
0x000061c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000061cc  mov      x24, x0
0x000061d0  mov      x2, x23
0x000061d4  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x000061d8  mov      x0, x24
0x000061dc  bl       #0x55d78   ; CALL _objc_release
0x000061e0  mov      x0, x23
0x000061e4  bl       #0x55d78   ; CALL _objc_release
0x000061e8  adrp     x2, #0x75000
0x000061ec  add      x2, x2, #0x1e8   ; STR "name"
0x000061f0  mov      x0, x22
0x000061f4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000061f8  mov      x29, x29
0x000061fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006200  mov      x23, x0
0x00006204  adrp     x27, #0x8e000
0x00006208  ldr      x0, [x27, #0x958]   ; @CLASS NSString
0x0000620c  bl       #0x55d48   ; CALL _objc_opt_class
0x00006210  mov      x1, x0
0x00006214  mov      x0, x23
0x00006218  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0000621c  mov      x24, x0
0x00006220  mov      x25, x21
0x00006224  tbz      w0, #0, #0x6244
0x00006228  adrp     x2, #0x75000
0x0000622c  add      x2, x2, #0x1e8   ; STR "name"
0x00006230  mov      x0, x22
0x00006234  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00006238  mov      x29, x29
0x0000623c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006240  mov      x25, x0
0x00006244  mov      x0, x20
0x00006248  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x0000624c  mov      x29, x29
0x00006250  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006254  mov      x26, x0
0x00006258  mov      x2, x25
0x0000625c  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00006260  mov      x0, x26
0x00006264  bl       #0x55d78   ; CALL _objc_release
0x00006268  tbz      w24, #0, #0x6274
0x0000626c  mov      x0, x25
0x00006270  bl       #0x55d78   ; CALL _objc_release
0x00006274  mov      x0, x23
0x00006278  bl       #0x55d78   ; CALL _objc_release
0x0000627c  adrp     x2, #0x75000
0x00006280  add      x2, x2, #0xa8   ; STR "lastSeen"
0x00006284  mov      x0, x22
0x00006288  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0000628c  mov      x29, x29
0x00006290  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006294  mov      x23, x0
0x00006298  adrp     x8, #0x8e000
0x0000629c  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x000062a0  bl       #0x55d48   ; CALL _objc_opt_class
0x000062a4  mov      x1, x0
0x000062a8  mov      x0, x23
0x000062ac  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x000062b0  mov      x24, x0
0x000062b4  tbz      w0, #0, #0x63f4
0x000062b8  ldr      x27, [x27, #0x958]   ; @CLASS NSString
0x000062bc  adrp     x0, #0x75000
0x000062c0  add      x0, x0, #0x208   ; STR "PROFILES_LAST_SEEN"
0x000062c4  bl       #0x17e20   ; CALL _L
0x000062c8  mov      x29, x29
0x000062cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000062d0  mov      x25, x0
0x000062d4  adrp     x8, #0x8e000
0x000062d8  ldr      x0, [x8, #0x980]   ; @CLASS NSDateFormatter
0x000062dc  mov      x2, x23
0x000062e0  mov      w3, #1
0x000062e4  mov      w4, #1
0x000062e8  bl       #0x58de0   ; CALL objc_msgSend$localizedStringFromDate:dateStyle:timeStyle:
0x000062ec  mov      x29, x29
0x000062f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000062f4  mov      x26, x0
0x000062f8  str      x0, [sp]
0x000062fc  mov      x0, x27
0x00006300  mov      x2, x25
0x00006304  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00006308  mov      x29, x29
0x0000630c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006310  mov      x27, x0
0x00006314  b        #0x63f8
0x00006318  adrp     x0, #0x75000
0x0000631c  add      x0, x0, #0x1c8   ; STR "PROFILES_NONE"
0x00006320  bl       #0x17e20   ; CALL _L
0x00006324  mov      x29, x29
0x00006328  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000632c  mov      x21, x0
0x00006330  mov      x0, x20
0x00006334  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00006338  mov      x29, x29
0x0000633c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006340  mov      x22, x0
0x00006344  mov      x2, x21
0x00006348  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0000634c  mov      x0, x22
0x00006350  bl       #0x55d78   ; CALL _objc_release
0x00006354  mov      x0, x21
0x00006358  bl       #0x55d78   ; CALL _objc_release
0x0000635c  ldr      x0, [x24, #0x910]   ; @CLASS UIColor
0x00006360  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x00006364  mov      x29, x29
0x00006368  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000636c  mov      x21, x0
0x00006370  mov      x0, x20
0x00006374  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00006378  mov      x29, x29
0x0000637c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006380  mov      x22, x0
0x00006384  mov      x2, x21
0x00006388  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0000638c  mov      x0, x22
0x00006390  bl       #0x55d78   ; CALL _objc_release
0x00006394  mov      x0, x21
0x00006398  bl       #0x55d78   ; CALL _objc_release
0x0000639c  mov      x0, x20
0x000063a0  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x000063a4  mov      x29, x29
0x000063a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000063ac  mov      x21, x0
0x000063b0  mov      x2, #0
0x000063b4  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x000063b8  mov      x0, x21
0x000063bc  bl       #0x55d78   ; CALL _objc_release
0x000063c0  mov      x0, x20
0x000063c4  bl       #0x58120   ; CALL objc_msgSend$imageView
0x000063c8  mov      x29, x29
0x000063cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000063d0  mov      x21, x0
0x000063d4  mov      x2, #0
0x000063d8  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x000063dc  mov      x0, x21
0x000063e0  bl       #0x55d78   ; CALL _objc_release
0x000063e4  mov      x0, x20
0x000063e8  mov      x2, #0
0x000063ec  bl       #0x5a2a0   ; CALL objc_msgSend$setAccessoryType:
0x000063f0  b        #0x64d4
0x000063f4  mov      x27, #0
0x000063f8  mov      x0, x20
0x000063fc  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x00006400  mov      x29, x29
0x00006404  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006408  mov      x28, x0
0x0000640c  mov      x2, x27
0x00006410  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00006414  mov      x0, x28
0x00006418  bl       #0x55d78   ; CALL _objc_release
0x0000641c  tbz      w24, #0, #0x6438
0x00006420  mov      x0, x27
0x00006424  bl       #0x55d78   ; CALL _objc_release
0x00006428  mov      x0, x26
0x0000642c  bl       #0x55d78   ; CALL _objc_release
0x00006430  mov      x0, x25
0x00006434  bl       #0x55d78   ; CALL _objc_release
0x00006438  adrp     x0, #0x75000
0x0000643c  add      x0, x0, #0x228   ; STR "car.fill"
0x00006440  mov      x1, #0
0x00006444  bl       #0x18144   ; CALL _OMCIcon
0x00006448  mov      x29, x29
0x0000644c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006450  mov      x24, x0
0x00006454  mov      x0, x20
0x00006458  bl       #0x58120   ; CALL objc_msgSend$imageView
0x0000645c  mov      x29, x29
0x00006460  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006464  mov      x25, x0
0x00006468  mov      x2, x24
0x0000646c  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00006470  mov      x0, x25
0x00006474  bl       #0x55d78   ; CALL _objc_release
0x00006478  mov      x0, x24
0x0000647c  bl       #0x55d78   ; CALL _objc_release
0x00006480  adrp     x0, #0x75000
0x00006484  add      x0, x0, #0x248   ; STR "carProfileCurrent"
0x00006488  bl       #0x5b64
0x0000648c  mov      x29, x29
0x00006490  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006494  mov      x24, x0
0x00006498  mov      x2, x21
0x0000649c  bl       #0x587e0   ; CALL objc_msgSend$isEqual:
0x000064a0  cmp      w0, #0
0x000064a4  mov      w8, #3
0x000064a8  csel     x2, x8, xzr, ne
0x000064ac  mov      x0, x20
0x000064b0  bl       #0x5a2a0   ; CALL objc_msgSend$setAccessoryType:
0x000064b4  mov      x0, x24
0x000064b8  bl       #0x55d78   ; CALL _objc_release
0x000064bc  mov      x0, x23
0x000064c0  bl       #0x55d78   ; CALL _objc_release
0x000064c4  mov      x0, x22
0x000064c8  bl       #0x55d78   ; CALL _objc_release
0x000064cc  mov      x0, x21
0x000064d0  bl       #0x55d78   ; CALL _objc_release
0x000064d4  mov      x0, x19
0x000064d8  bl       #0x55d78   ; CALL _objc_release
0x000064dc  mov      x0, x20
0x000064e0  ldp      x29, x30, [sp, #0x60]
0x000064e4  ldp      x20, x19, [sp, #0x50]
0x000064e8  ldp      x22, x21, [sp, #0x40]
0x000064ec  ldp      x24, x23, [sp, #0x30]
0x000064f0  ldp      x26, x25, [sp, #0x20]
0x000064f4  ldp      x28, x27, [sp, #0x10]
0x000064f8  add      sp, sp, #0x70
0x000064fc  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCCarProfilesController tableView:canEditRowAtIndexPath:]  va=0x6500 size=96 types=B32@0:8@16@24
0x00006500  stp      x20, x19, [sp, #-0x20]!
0x00006504  stp      x29, x30, [sp, #0x10]
0x00006508  add      x29, sp, #0x10
0x0000650c  mov      x19, x0
0x00006510  mov      x0, x3
0x00006514  bl       #0x5a180   ; CALL objc_msgSend$section
0x00006518  cmp      x0, #1
0x0000651c  b.ne     #0x654c
0x00006520  mov      x0, x19
0x00006524  bl       #0x589a0   ; CALL objc_msgSend$keys
0x00006528  mov      x29, x29
0x0000652c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006530  mov      x20, x0
0x00006534  bl       #0x573c0   ; CALL objc_msgSend$count
0x00006538  cmp      x0, #0
0x0000653c  cset     w19, ne
0x00006540  mov      x0, x20
0x00006544  bl       #0x55d78   ; CALL _objc_release
0x00006548  b        #0x6550
0x0000654c  mov      w19, #0
0x00006550  mov      x0, x19
0x00006554  ldp      x29, x30, [sp, #0x10]
0x00006558  ldp      x20, x19, [sp], #0x20
0x0000655c  ret      

=== -[OMCCarProfilesController tableView:commitEditingStyle:forRowAtIndexPath:]  va=0x6560 size=352 types=v40@0:8@16q24@32
0x00006560  stp      x24, x23, [sp, #-0x40]!
0x00006564  stp      x22, x21, [sp, #0x10]
0x00006568  stp      x20, x19, [sp, #0x20]
0x0000656c  stp      x29, x30, [sp, #0x30]
0x00006570  add      x29, sp, #0x30
0x00006574  mov      x19, x4
0x00006578  mov      x21, x3
0x0000657c  mov      x20, x0
0x00006580  mov      x0, x4
0x00006584  bl       #0x55d84   ; CALL _objc_retain
0x00006588  cmp      x21, #1
0x0000658c  b.ne     #0x66a8
0x00006590  mov      x0, x19
0x00006594  bl       #0x59f60   ; CALL objc_msgSend$row
0x00006598  mov      x21, x0
0x0000659c  mov      x0, x20
0x000065a0  bl       #0x589a0   ; CALL objc_msgSend$keys
0x000065a4  mov      x29, x29
0x000065a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000065ac  mov      x22, x0
0x000065b0  bl       #0x573c0   ; CALL objc_msgSend$count
0x000065b4  mov      x23, x0
0x000065b8  mov      x0, x22
0x000065bc  bl       #0x55d78   ; CALL _objc_release
0x000065c0  cmp      x21, x23
0x000065c4  b.ge     #0x66a8
0x000065c8  mov      x0, x20
0x000065cc  bl       #0x589a0   ; CALL objc_msgSend$keys
0x000065d0  mov      x29, x29
0x000065d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000065d8  mov      x22, x0
0x000065dc  mov      x0, x19
0x000065e0  bl       #0x59f60   ; CALL objc_msgSend$row
0x000065e4  mov      x2, x0
0x000065e8  mov      x0, x22
0x000065ec  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000065f0  mov      x29, x29
0x000065f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000065f8  mov      x21, x0
0x000065fc  mov      x0, x22
0x00006600  bl       #0x55d78   ; CALL _objc_release
0x00006604  mov      x0, x20
0x00006608  bl       #0x59a80   ; CALL objc_msgSend$profiles
0x0000660c  mov      x29, x29
0x00006610  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006614  mov      x23, x0
0x00006618  bl       #0x590a0   ; CALL objc_msgSend$mutableCopy
0x0000661c  mov      x22, x0
0x00006620  mov      x0, x23
0x00006624  bl       #0x55d78   ; CALL _objc_release
0x00006628  mov      x0, x22
0x0000662c  mov      x2, x21
0x00006630  bl       #0x59e60   ; CALL objc_msgSend$removeObjectForKey:
0x00006634  mov      x0, x22
0x00006638  bl       #0x573c0   ; CALL objc_msgSend$count
0x0000663c  cmp      x0, #0
0x00006640  csel     x1, xzr, x22, eq
0x00006644  adrp     x0, #0x75000
0x00006648  add      x0, x0, #0x88   ; STR "carProfiles"
0x0000664c  bl       #0x5d34
0x00006650  adrp     x0, #0x75000
0x00006654  add      x0, x0, #0x248   ; STR "carProfileCurrent"
0x00006658  bl       #0x5b64
0x0000665c  mov      x29, x29
0x00006660  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00006664  mov      x23, x0
0x00006668  mov      x2, x21
0x0000666c  bl       #0x587e0   ; CALL objc_msgSend$isEqual:
0x00006670  mov      x24, x0
0x00006674  mov      x0, x23
0x00006678  bl       #0x55d78   ; CALL _objc_release
0x0000667c  cbz      w24, #0x6690
0x00006680  adrp     x0, #0x75000
0x00006684  add      x0, x0, #0x248   ; STR "carProfileCurrent"
0x00006688  mov      x1, #0
0x0000668c  bl       #0x5d34
0x00006690  mov      x0, x20
0x00006694  bl       #0x59c60   ; CALL objc_msgSend$reload
0x00006698  mov      x0, x22
0x0000669c  bl       #0x55d78   ; CALL _objc_release
0x000066a0  mov      x0, x21
0x000066a4  bl       #0x55d78   ; CALL _objc_release
0x000066a8  mov      x0, x19
0x000066ac  ldp      x29, x30, [sp, #0x30]
0x000066b0  ldp      x20, x19, [sp, #0x20]
0x000066b4  ldp      x22, x21, [sp, #0x10]
0x000066b8  ldp      x24, x23, [sp], #0x40
0x000066bc  b        #0x55d78   ; CALL _objc_release

=== -[OMCCarProfilesController table]  va=0x66c0 size=16 types=@16@0:8
0x000066c0  adrp     x8, #0x8e000
0x000066c4  ldrsw    x8, [x8, #0xdc4]
0x000066c8  ldr      x0, [x0, x8]
0x000066cc  ret      

=== -[OMCCarProfilesController setTable:]  va=0x66d0 size=64 types=v24@0:8@16
0x000066d0  stp      x22, x21, [sp, #-0x30]!
0x000066d4  stp      x20, x19, [sp, #0x10]
0x000066d8  stp      x29, x30, [sp, #0x20]
0x000066dc  add      x29, sp, #0x20
0x000066e0  mov      x19, x2
0x000066e4  mov      x20, x0
0x000066e8  adrp     x8, #0x8e000
0x000066ec  ldrsw    x21, [x8, #0xdc4]
0x000066f0  mov      x0, x2
0x000066f4  bl       #0x55d84   ; CALL _objc_retain
0x000066f8  ldr      x0, [x20, x21]
0x000066fc  str      x19, [x20, x21]
0x00006700  ldp      x29, x30, [sp, #0x20]
0x00006704  ldp      x20, x19, [sp, #0x10]
0x00006708  ldp      x22, x21, [sp], #0x30
0x0000670c  b        #0x55d78   ; CALL _objc_release

=== -[OMCCarProfilesController keys]  va=0x6710 size=16 types=@16@0:8
0x00006710  adrp     x8, #0x8e000
0x00006714  ldrsw    x8, [x8, #0xdc8]
0x00006718  ldr      x0, [x0, x8]
0x0000671c  ret      

=== -[OMCCarProfilesController setKeys:]  va=0x6720 size=64 types=v24@0:8@16
0x00006720  stp      x22, x21, [sp, #-0x30]!
0x00006724  stp      x20, x19, [sp, #0x10]
0x00006728  stp      x29, x30, [sp, #0x20]
0x0000672c  add      x29, sp, #0x20
0x00006730  mov      x19, x2
0x00006734  mov      x20, x0
0x00006738  adrp     x8, #0x8e000
0x0000673c  ldrsw    x21, [x8, #0xdc8]
0x00006740  mov      x0, x2
0x00006744  bl       #0x55d84   ; CALL _objc_retain
0x00006748  ldr      x0, [x20, x21]
0x0000674c  str      x19, [x20, x21]
0x00006750  ldp      x29, x30, [sp, #0x20]
0x00006754  ldp      x20, x19, [sp, #0x10]
0x00006758  ldp      x22, x21, [sp], #0x30
0x0000675c  b        #0x55d78   ; CALL _objc_release

=== -[OMCCarProfilesController profiles]  va=0x6760 size=16 types=@16@0:8
0x00006760  adrp     x8, #0x8e000
0x00006764  ldrsw    x8, [x8, #0xdcc]
0x00006768  ldr      x0, [x0, x8]
0x0000676c  ret      

=== -[OMCCarProfilesController setProfiles:]  va=0x6770 size=64 types=v24@0:8@16
0x00006770  stp      x22, x21, [sp, #-0x30]!
0x00006774  stp      x20, x19, [sp, #0x10]
0x00006778  stp      x29, x30, [sp, #0x20]
0x0000677c  add      x29, sp, #0x20
0x00006780  mov      x19, x2
0x00006784  mov      x20, x0
0x00006788  adrp     x8, #0x8e000
0x0000678c  ldrsw    x21, [x8, #0xdcc]
0x00006790  mov      x0, x2
0x00006794  bl       #0x55d84   ; CALL _objc_retain
0x00006798  ldr      x0, [x20, x21]
0x0000679c  str      x19, [x20, x21]
0x000067a0  ldp      x29, x30, [sp, #0x20]
0x000067a4  ldp      x20, x19, [sp, #0x10]
0x000067a8  ldp      x22, x21, [sp], #0x30
0x000067ac  b        #0x55d78   ; CALL _objc_release

=== -[OMCCarProfilesController .cxx_destruct]  va=0x67b0 size=84 types=v16@0:8
0x000067b0  stp      x20, x19, [sp, #-0x20]!
0x000067b4  stp      x29, x30, [sp, #0x10]
0x000067b8  add      x29, sp, #0x10
0x000067bc  mov      x19, x0
0x000067c0  adrp     x8, #0x8e000
0x000067c4  ldrsw    x8, [x8, #0xdcc]
0x000067c8  add      x0, x0, x8
0x000067cc  mov      x1, #0
0x000067d0  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000067d4  adrp     x8, #0x8e000
0x000067d8  ldrsw    x8, [x8, #0xdc8]
0x000067dc  add      x0, x19, x8
0x000067e0  mov      x1, #0
0x000067e4  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000067e8  adrp     x8, #0x8e000
0x000067ec  ldrsw    x8, [x8, #0xdc4]
0x000067f0  add      x0, x19, x8
0x000067f4  mov      x1, #0
0x000067f8  ldp      x29, x30, [sp, #0x10]
0x000067fc  ldp      x20, x19, [sp], #0x20
0x00006800  b        #0x55dcc   ; CALL _objc_storeStrong
