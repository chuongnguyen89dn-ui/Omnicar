=== -[OMCFeatureListController specifiers]  va=0x10d04 size=272 types=@16@0:8
0x00010d04  stp      x22, x21, [sp, #-0x30]!
0x00010d08  stp      x20, x19, [sp, #0x10]
0x00010d0c  stp      x29, x30, [sp, #0x20]
0x00010d10  add      x29, sp, #0x20
0x00010d14  adrp     x8, #0x74000
0x00010d18  ldr      x8, [x8, #0x368]   ; @GOT _OBJC_IVAR_$_PSListController._specifiers
0x00010d1c  ldrsw    x22, [x8]   ; @GOT ___objc_personality_v0
0x00010d20  ldr      x20, [x0, x22]
0x00010d24  cbnz     x20, #0x10df8
0x00010d28  mov      x19, x0
0x00010d2c  bl       #0x17a44   ; CALL _OMCLoadStrings
0x00010d30  mov      x0, x19
0x00010d34  bl       #0x5cdc0   ; CALL objc_msgSend$specifier
0x00010d38  mov      x29, x29
0x00010d3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010d40  mov      x21, x0
0x00010d44  adrp     x2, #0x76000
0x00010d48  add      x2, x2, #0xf48   ; STR "plist"
0x00010d4c  bl       #0x59aa0   ; CALL objc_msgSend$propertyForKey:
0x00010d50  mov      x29, x29
0x00010d54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010d58  mov      x20, x0
0x00010d5c  mov      x0, x21
0x00010d60  bl       #0x55d78   ; CALL _objc_release
0x00010d64  cbz      x20, #0x10d98
0x00010d68  mov      x0, x19
0x00010d6c  mov      x2, x20
0x00010d70  mov      x3, x19
0x00010d74  bl       #0x58d00   ; CALL objc_msgSend$loadSpecifiersFromPlistName:target:
0x00010d78  mov      x29, x29
0x00010d7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010d80  mov      x21, x0
0x00010d84  cbz      x0, #0x10db8
0x00010d88  mov      x0, x21
0x00010d8c  bl       #0x55d84   ; CALL _objc_retain
0x00010d90  mov      x0, x21
0x00010d94  b        #0x10dcc
0x00010d98  adrp     x8, #0x8e000
0x00010d9c  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00010da0  bl       #0x565c0   ; CALL objc_msgSend$array
0x00010da4  mov      x29, x29
0x00010da8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010dac  ldr      x21, [x19, x22]
0x00010db0  str      x0, [x19, x22]
0x00010db4  b        #0x10ddc
0x00010db8  adrp     x8, #0x8e000
0x00010dbc  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00010dc0  bl       #0x565c0   ; CALL objc_msgSend$array
0x00010dc4  mov      x29, x29
0x00010dc8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010dcc  ldr      x8, [x19, x22]
0x00010dd0  str      x0, [x19, x22]
0x00010dd4  mov      x0, x8
0x00010dd8  bl       #0x55d78   ; CALL _objc_release
0x00010ddc  mov      x0, x21
0x00010de0  bl       #0x55d78   ; CALL _objc_release
0x00010de4  ldr      x0, [x19, x22]
0x00010de8  bl       #0x18cb4   ; CALL _OMCLocalizeSpecifiers
0x00010dec  mov      x0, x20
0x00010df0  bl       #0x55d78   ; CALL _objc_release
0x00010df4  ldr      x20, [x19, x22]
0x00010df8  mov      x0, x20
0x00010dfc  bl       #0x55d84   ; CALL _objc_retain
0x00010e00  mov      x0, x20
0x00010e04  ldp      x29, x30, [sp, #0x20]
0x00010e08  ldp      x20, x19, [sp, #0x10]
0x00010e0c  ldp      x22, x21, [sp], #0x30
0x00010e10  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCFeatureListController viewDidLoad]  va=0x10e14 size=368 types=v16@0:8
0x00010e14  sub      sp, sp, #0x70
0x00010e18  stp      x24, x23, [sp, #0x30]
0x00010e1c  stp      x22, x21, [sp, #0x40]
0x00010e20  stp      x20, x19, [sp, #0x50]
0x00010e24  stp      x29, x30, [sp, #0x60]
0x00010e28  add      x29, sp, #0x60
0x00010e2c  mov      x19, x0
0x00010e30  adrp     x8, #0x74000
0x00010e34  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00010e38  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00010e3c  str      x8, [sp, #0x28]
0x00010e40  adrp     x8, #0x8e000
0x00010e44  ldr      x8, [x8, #0xd18]   ; @SUPER OMCFeatureListController
0x00010e48  stp      x0, x8, [sp, #8]
0x00010e4c  adrp     x8, #0x8b000
0x00010e50  ldr      x1, [x8, #0xda0]   ; @SEL "viewDidLoad"
0x00010e54  add      x0, sp, #8
0x00010e58  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00010e5c  bl       #0x17fd8   ; CALL _OMCSwitchColor
0x00010e60  mov      x29, x29
0x00010e64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010e68  mov      x20, x0
0x00010e6c  adrp     x8, #0x8e000
0x00010e70  ldr      x21, [x8, #0x920]   ; @CLASS UISwitch
0x00010e74  mov      x0, x19
0x00010e78  bl       #0x55d48   ; CALL _objc_opt_class
0x00010e7c  str      x0, [sp, #0x20]
0x00010e80  adrp     x23, #0x8e000
0x00010e84  ldr      x0, [x23, #0x960]   ; @CLASS NSArray
0x00010e88  add      x2, sp, #0x20
0x00010e8c  mov      w3, #1
0x00010e90  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00010e94  mov      x29, x29
0x00010e98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010e9c  mov      x22, x0
0x00010ea0  mov      x0, x21
0x00010ea4  mov      x2, x22
0x00010ea8  bl       #0x56400   ; CALL objc_msgSend$appearanceWhenContainedInInstancesOfClasses:
0x00010eac  mov      x29, x29
0x00010eb0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010eb4  mov      x21, x0
0x00010eb8  mov      x2, x20
0x00010ebc  bl       #0x5b920   ; CALL objc_msgSend$setOnTintColor:
0x00010ec0  mov      x0, x21
0x00010ec4  bl       #0x55d78   ; CALL _objc_release
0x00010ec8  mov      x0, x22
0x00010ecc  bl       #0x55d78   ; CALL _objc_release
0x00010ed0  mov      x0, x20
0x00010ed4  bl       #0x55d78   ; CALL _objc_release
0x00010ed8  bl       #0x17e8c   ; CALL _OMCAccentColor
0x00010edc  mov      x29, x29
0x00010ee0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010ee4  mov      x20, x0
0x00010ee8  adrp     x8, #0x8e000
0x00010eec  ldr      x21, [x8, #0x950]   ; @CLASS UISlider
0x00010ef0  mov      x0, x19
0x00010ef4  bl       #0x55d48   ; CALL _objc_opt_class
0x00010ef8  str      x0, [sp, #0x18]
0x00010efc  ldr      x0, [x23, #0x960]   ; @CLASS NSArray
0x00010f00  add      x2, sp, #0x18
0x00010f04  mov      w3, #1
0x00010f08  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00010f0c  mov      x29, x29
0x00010f10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010f14  mov      x19, x0
0x00010f18  mov      x0, x21
0x00010f1c  mov      x2, x19
0x00010f20  bl       #0x56400   ; CALL objc_msgSend$appearanceWhenContainedInInstancesOfClasses:
0x00010f24  mov      x29, x29
0x00010f28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010f2c  mov      x21, x0
0x00010f30  mov      x2, x20
0x00010f34  bl       #0x5b680   ; CALL objc_msgSend$setMinimumTrackTintColor:
0x00010f38  mov      x0, x21
0x00010f3c  bl       #0x55d78   ; CALL _objc_release
0x00010f40  mov      x0, x19
0x00010f44  bl       #0x55d78   ; CALL _objc_release
0x00010f48  mov      x0, x20
0x00010f4c  bl       #0x55d78   ; CALL _objc_release
0x00010f50  ldr      x8, [sp, #0x28]
0x00010f54  adrp     x9, #0x74000
0x00010f58  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00010f5c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00010f60  cmp      x9, x8
0x00010f64  b.ne     #0x10f80
0x00010f68  ldp      x29, x30, [sp, #0x60]
0x00010f6c  ldp      x20, x19, [sp, #0x50]
0x00010f70  ldp      x22, x21, [sp, #0x40]
0x00010f74  ldp      x24, x23, [sp, #0x30]
0x00010f78  add      sp, sp, #0x70
0x00010f7c  ret      
0x00010f80  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCFeatureListController viewWillAppear:]  va=0x10f84 size=252 types=v20@0:8B16
0x00010f84  sub      sp, sp, #0x40
0x00010f88  stp      x22, x21, [sp, #0x10]
0x00010f8c  stp      x20, x19, [sp, #0x20]
0x00010f90  stp      x29, x30, [sp, #0x30]
0x00010f94  add      x29, sp, #0x30
0x00010f98  mov      x19, x0
0x00010f9c  adrp     x8, #0x8e000
0x00010fa0  ldr      x8, [x8, #0xd18]   ; @SUPER OMCFeatureListController
0x00010fa4  stp      x0, x8, [sp]
0x00010fa8  adrp     x8, #0x8b000
0x00010fac  ldr      x1, [x8, #0xda8]   ; @SEL "viewWillAppear:"
0x00010fb0  mov      x0, sp
0x00010fb4  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00010fb8  adrp     x0, #0x75000
0x00010fbc  add      x0, x0, #0x28   ; STR "com.anlai.omnicar"
0x00010fc0  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x00010fc4  mov      x0, x19
0x00010fc8  bl       #0x59d40   ; CALL objc_msgSend$reloadSpecifiers
0x00010fcc  mov      x0, x19
0x00010fd0  bl       #0x5cdc0   ; CALL objc_msgSend$specifier
0x00010fd4  mov      x29, x29
0x00010fd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010fdc  mov      x20, x0
0x00010fe0  bl       #0x590e0   ; CALL objc_msgSend$name
0x00010fe4  mov      x29, x29
0x00010fe8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010fec  mov      x21, x0
0x00010ff0  bl       #0x58c20   ; CALL objc_msgSend$length
0x00010ff4  mov      x22, x0
0x00010ff8  mov      x0, x21
0x00010ffc  bl       #0x55d78   ; CALL _objc_release
0x00011000  mov      x0, x20
0x00011004  bl       #0x55d78   ; CALL _objc_release
0x00011008  cbz      x22, #0x1104c
0x0001100c  mov      x0, x19
0x00011010  bl       #0x5cdc0   ; CALL objc_msgSend$specifier
0x00011014  mov      x29, x29
0x00011018  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001101c  mov      x20, x0
0x00011020  bl       #0x590e0   ; CALL objc_msgSend$name
0x00011024  mov      x29, x29
0x00011028  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001102c  mov      x21, x0
0x00011030  mov      x0, x19
0x00011034  mov      x2, x21
0x00011038  bl       #0x5c5e0   ; CALL objc_msgSend$setTitle:
0x0001103c  mov      x0, x21
0x00011040  bl       #0x55d78   ; CALL _objc_release
0x00011044  mov      x0, x20
0x00011048  bl       #0x55d78   ; CALL _objc_release
0x0001104c  mov      x0, x19
0x00011050  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x00011054  mov      x29, x29
0x00011058  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001105c  mov      x19, x0
0x00011060  bl       #0x18828   ; CALL _OMCStyleTable
0x00011064  mov      x0, x19
0x00011068  bl       #0x55d78   ; CALL _objc_release
0x0001106c  ldp      x29, x30, [sp, #0x30]
0x00011070  ldp      x20, x19, [sp, #0x20]
0x00011074  ldp      x22, x21, [sp, #0x10]
0x00011078  add      sp, sp, #0x40
0x0001107c  ret      

=== -[OMCFeatureListController tableView:cellForRowAtIndexPath:]  va=0x11080 size=80 types=@32@0:8@16@24
0x00011080  sub      sp, sp, #0x30
0x00011084  stp      x20, x19, [sp, #0x10]
0x00011088  stp      x29, x30, [sp, #0x20]
0x0001108c  add      x29, sp, #0x20
0x00011090  adrp     x8, #0x8e000
0x00011094  ldr      x8, [x8, #0xd18]   ; @SUPER OMCFeatureListController
0x00011098  stp      x0, x8, [sp]
0x0001109c  adrp     x8, #0x8b000
0x000110a0  ldr      x1, [x8, #0xde0]   ; @SEL "tableView:cellForRowAtIndexPath:"
0x000110a4  mov      x0, sp
0x000110a8  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x000110ac  mov      x29, x29
0x000110b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000110b4  mov      x19, x0
0x000110b8  bl       #0x19168   ; CALL _OMCStyleCell
0x000110bc  mov      x0, x19
0x000110c0  ldp      x29, x30, [sp, #0x20]
0x000110c4  ldp      x20, x19, [sp, #0x10]
0x000110c8  add      sp, sp, #0x30
0x000110cc  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCFeatureListController tableView:willDisplayHeaderView:forSection:]  va=0x110d0 size=172 types=v40@0:8@16@24q32
0x000110d0  sub      sp, sp, #0x50
0x000110d4  stp      x24, x23, [sp, #0x10]
0x000110d8  stp      x22, x21, [sp, #0x20]
0x000110dc  stp      x20, x19, [sp, #0x30]
0x000110e0  stp      x29, x30, [sp, #0x40]
0x000110e4  add      x29, sp, #0x40
0x000110e8  mov      x21, x4
0x000110ec  mov      x20, x3
0x000110f0  mov      x19, x2
0x000110f4  mov      x23, x1
0x000110f8  mov      x22, x0
0x000110fc  mov      x0, x2
0x00011100  bl       #0x55d84   ; CALL _objc_retain
0x00011104  mov      x0, x20
0x00011108  bl       #0x55d84   ; CALL _objc_retain
0x0001110c  adrp     x8, #0x8e000
0x00011110  ldr      x0, [x8, #0xa18]   ; @CLASS PSListController
0x00011114  mov      x2, x23
0x00011118  bl       #0x586e0   ; CALL objc_msgSend$instancesRespondToSelector:
0x0001111c  cbz      w0, #0x11148
0x00011120  adrp     x8, #0x8e000
0x00011124  ldr      x8, [x8, #0xd18]   ; @SUPER OMCFeatureListController
0x00011128  stp      x22, x8, [sp]
0x0001112c  adrp     x8, #0x8b000
0x00011130  ldr      x1, [x8, #0xde8]   ; @SEL "tableView:willDisplayHeaderView:forSection:"
0x00011134  mov      x0, sp
0x00011138  mov      x2, x19
0x0001113c  mov      x3, x20
0x00011140  mov      x4, x21
0x00011144  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00011148  mov      x0, x20
0x0001114c  mov      w1, #1
0x00011150  bl       #0x19300   ; CALL _OMCStyleHeaderFooter
0x00011154  mov      x0, x20
0x00011158  bl       #0x55d78   ; CALL _objc_release
0x0001115c  mov      x0, x19
0x00011160  bl       #0x55d78   ; CALL _objc_release
0x00011164  ldp      x29, x30, [sp, #0x40]
0x00011168  ldp      x20, x19, [sp, #0x30]
0x0001116c  ldp      x22, x21, [sp, #0x20]
0x00011170  ldp      x24, x23, [sp, #0x10]
0x00011174  add      sp, sp, #0x50
0x00011178  ret      

=== -[OMCFeatureListController tableView:willDisplayFooterView:forSection:]  va=0x1117c size=172 types=v40@0:8@16@24q32
0x0001117c  sub      sp, sp, #0x50
0x00011180  stp      x24, x23, [sp, #0x10]
0x00011184  stp      x22, x21, [sp, #0x20]
0x00011188  stp      x20, x19, [sp, #0x30]
0x0001118c  stp      x29, x30, [sp, #0x40]
0x00011190  add      x29, sp, #0x40
0x00011194  mov      x21, x4
0x00011198  mov      x20, x3
0x0001119c  mov      x19, x2
0x000111a0  mov      x23, x1
0x000111a4  mov      x22, x0
0x000111a8  mov      x0, x2
0x000111ac  bl       #0x55d84   ; CALL _objc_retain
0x000111b0  mov      x0, x20
0x000111b4  bl       #0x55d84   ; CALL _objc_retain
0x000111b8  adrp     x8, #0x8e000
0x000111bc  ldr      x0, [x8, #0xa18]   ; @CLASS PSListController
0x000111c0  mov      x2, x23
0x000111c4  bl       #0x586e0   ; CALL objc_msgSend$instancesRespondToSelector:
0x000111c8  cbz      w0, #0x111f4
0x000111cc  adrp     x8, #0x8e000
0x000111d0  ldr      x8, [x8, #0xd18]   ; @SUPER OMCFeatureListController
0x000111d4  stp      x22, x8, [sp]
0x000111d8  adrp     x8, #0x8b000
0x000111dc  ldr      x1, [x8, #0xdf0]   ; @SEL "tableView:willDisplayFooterView:forSection:"
0x000111e0  mov      x0, sp
0x000111e4  mov      x2, x19
0x000111e8  mov      x3, x20
0x000111ec  mov      x4, x21
0x000111f0  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x000111f4  mov      x0, x20
0x000111f8  mov      w1, #0
0x000111fc  bl       #0x19300   ; CALL _OMCStyleHeaderFooter
0x00011200  mov      x0, x20
0x00011204  bl       #0x55d78   ; CALL _objc_release
0x00011208  mov      x0, x19
0x0001120c  bl       #0x55d78   ; CALL _objc_release
0x00011210  ldp      x29, x30, [sp, #0x40]
0x00011214  ldp      x20, x19, [sp, #0x30]
0x00011218  ldp      x22, x21, [sp, #0x20]
0x0001121c  ldp      x24, x23, [sp, #0x10]
0x00011220  add      sp, sp, #0x50
0x00011224  ret      

=== -[OMCFeatureListController traitCollectionDidChange:]  va=0x11228 size=196 types=v24@0:8@16
0x00011228  sub      sp, sp, #0x50
0x0001122c  stp      x24, x23, [sp, #0x10]
0x00011230  stp      x22, x21, [sp, #0x20]
0x00011234  stp      x20, x19, [sp, #0x30]
0x00011238  stp      x29, x30, [sp, #0x40]
0x0001123c  add      x29, sp, #0x40
0x00011240  mov      x20, x2
0x00011244  mov      x19, x0
0x00011248  adrp     x8, #0x8e000
0x0001124c  ldr      x8, [x8, #0xd18]   ; @SUPER OMCFeatureListController
0x00011250  stp      x0, x8, [sp]
0x00011254  adrp     x8, #0x8b000
0x00011258  ldr      x21, [x8, #0xdb0]   ; @SEL "traitCollectionDidChange:"
0x0001125c  mov      x0, x2
0x00011260  bl       #0x55d84   ; CALL _objc_retain
0x00011264  mov      x0, sp
0x00011268  mov      x1, x21
0x0001126c  mov      x2, x20
0x00011270  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00011274  mov      x0, x19
0x00011278  bl       #0x5dc60   ; CALL objc_msgSend$traitCollection
0x0001127c  mov      x29, x29
0x00011280  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011284  mov      x21, x0
0x00011288  bl       #0x5de60   ; CALL objc_msgSend$userInterfaceStyle
0x0001128c  mov      x22, x0
0x00011290  mov      x0, x20
0x00011294  bl       #0x5de60   ; CALL objc_msgSend$userInterfaceStyle
0x00011298  mov      x23, x0
0x0001129c  mov      x0, x20
0x000112a0  bl       #0x55d78   ; CALL _objc_release
0x000112a4  mov      x0, x21
0x000112a8  bl       #0x55d78   ; CALL _objc_release
0x000112ac  cmp      x22, x23
0x000112b0  b.eq     #0x112d4
0x000112b4  mov      x0, x19
0x000112b8  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x000112bc  mov      x29, x29
0x000112c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000112c4  mov      x19, x0
0x000112c8  bl       #0x18828   ; CALL _OMCStyleTable
0x000112cc  mov      x0, x19
0x000112d0  bl       #0x55d78   ; CALL _objc_release
0x000112d4  ldp      x29, x30, [sp, #0x40]
0x000112d8  ldp      x20, x19, [sp, #0x30]
0x000112dc  ldp      x22, x21, [sp, #0x20]
0x000112e0  ldp      x24, x23, [sp, #0x10]
0x000112e4  add      sp, sp, #0x50
0x000112e8  ret      

=== -[OMCFeatureListController showMessage:]  va=0x112ec size=192 types=v24@0:8@16
0x000112ec  stp      x22, x21, [sp, #-0x30]!
0x000112f0  stp      x20, x19, [sp, #0x10]
0x000112f4  stp      x29, x30, [sp, #0x20]
0x000112f8  add      x29, sp, #0x20
0x000112fc  mov      x3, x2
0x00011300  mov      x19, x0
0x00011304  adrp     x8, #0x8e000
0x00011308  ldr      x0, [x8, #0x9b8]   ; @CLASS UIAlertController
0x0001130c  adrp     x2, #0x75000
0x00011310  add      x2, x2, #0x508   ; STR "OmniCar"
0x00011314  mov      w4, #1
0x00011318  bl       #0x56280   ; CALL objc_msgSend$alertControllerWithTitle:message:preferredStyle:
0x0001131c  mov      x29, x29
0x00011320  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011324  mov      x20, x0
0x00011328  adrp     x8, #0x8e000
0x0001132c  ldr      x21, [x8, #0x9c0]   ; @CLASS UIAlertAction
0x00011330  adrp     x0, #0x76000
0x00011334  add      x0, x0, #0xea8   ; STR "OK"
0x00011338  bl       #0x17e20   ; CALL _L
0x0001133c  mov      x29, x29
0x00011340  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011344  mov      x22, x0
0x00011348  mov      x0, x21
0x0001134c  mov      x2, x22
0x00011350  mov      x3, #0
0x00011354  mov      x4, #0
0x00011358  bl       #0x55fc0   ; CALL objc_msgSend$actionWithTitle:style:handler:
0x0001135c  mov      x29, x29
0x00011360  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011364  mov      x21, x0
0x00011368  mov      x0, x20
0x0001136c  mov      x2, x21
0x00011370  bl       #0x56000   ; CALL objc_msgSend$addAction:
0x00011374  mov      x0, x21
0x00011378  bl       #0x55d78   ; CALL _objc_release
0x0001137c  mov      x0, x22
0x00011380  bl       #0x55d78   ; CALL _objc_release
0x00011384  mov      x0, x19
0x00011388  mov      x2, x20
0x0001138c  mov      w3, #1
0x00011390  mov      x4, #0
0x00011394  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x00011398  mov      x0, x20
0x0001139c  ldp      x29, x30, [sp, #0x20]
0x000113a0  ldp      x20, x19, [sp, #0x10]
0x000113a4  ldp      x22, x21, [sp], #0x30
0x000113a8  b        #0x55d78   ; CALL _objc_release
