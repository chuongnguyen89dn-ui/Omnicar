=== -[OMCCardPage loadView]  va=0x44a8 size=132 types=v16@0:8
0x000044a8  stp      x20, x19, [sp, #-0x20]!
0x000044ac  stp      x29, x30, [sp, #0x10]
0x000044b0  add      x29, sp, #0x10
0x000044b4  mov      x19, x0
0x000044b8  adrp     x8, #0x8e000
0x000044bc  ldr      x0, [x8, #0x900]   ; @CLASS UITableView
0x000044c0  bl       #0x55c7c   ; CALL _objc_alloc
0x000044c4  adrp     x8, #0x74000
0x000044c8  ldr      x8, [x8, #0x610]   ; @GOT _CGRectZero
0x000044cc  ldp      d0, d1, [x8]
0x000044d0  ldp      d2, d3, [x8, #0x10]
0x000044d4  mov      w2, #2
0x000044d8  bl       #0x584a0   ; CALL objc_msgSend$initWithFrame:style:
0x000044dc  adrp     x8, #0x8e000
0x000044e0  ldrsw    x20, [x8, #0xdc0]
0x000044e4  ldr      x8, [x19, x20]
0x000044e8  str      x0, [x19, x20]
0x000044ec  mov      x0, x8
0x000044f0  bl       #0x55d78   ; CALL _objc_release
0x000044f4  ldr      x0, [x19, x20]
0x000044f8  mov      x2, x19
0x000044fc  bl       #0x5ac00   ; CALL objc_msgSend$setDataSource:
0x00004500  ldr      x0, [x19, x20]
0x00004504  mov      x2, x19
0x00004508  bl       #0x5aca0   ; CALL objc_msgSend$setDelegate:
0x0000450c  ldr      x0, [x19, x20]
0x00004510  mov      w2, #1
0x00004514  bl       #0x5b1e0   ; CALL objc_msgSend$setKeyboardDismissMode:
0x00004518  ldr      x2, [x19, x20]
0x0000451c  mov      x0, x19
0x00004520  ldp      x29, x30, [sp, #0x10]
0x00004524  ldp      x20, x19, [sp], #0x20
0x00004528  b        #0x5c840   ; CALL objc_msgSend$setView:

=== -[OMCCardPage viewDidLoad]  va=0x452c size=152 types=v16@0:8
0x0000452c  sub      sp, sp, #0x40
0x00004530  stp      x22, x21, [sp, #0x10]
0x00004534  stp      x20, x19, [sp, #0x20]
0x00004538  stp      x29, x30, [sp, #0x30]
0x0000453c  add      x29, sp, #0x30
0x00004540  mov      x19, x0
0x00004544  adrp     x8, #0x8e000
0x00004548  ldr      x8, [x8, #0xd08]   ; @SUPER OMCCardPage
0x0000454c  stp      x0, x8, [sp]
0x00004550  adrp     x8, #0x8b000
0x00004554  ldr      x1, [x8, #0xda0]   ; @SEL "viewDidLoad"
0x00004558  mov      x0, sp
0x0000455c  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00004560  bl       #0x17a44   ; CALL _OMCLoadStrings
0x00004564  bl       #0x17e8c   ; CALL _OMCAccentColor
0x00004568  mov      x29, x29
0x0000456c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004570  mov      x20, x0
0x00004574  mov      x0, x19
0x00004578  bl       #0x5df60   ; CALL objc_msgSend$view
0x0000457c  mov      x29, x29
0x00004580  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004584  mov      x21, x0
0x00004588  mov      x2, x20
0x0000458c  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x00004590  mov      x0, x21
0x00004594  bl       #0x55d78   ; CALL _objc_release
0x00004598  mov      x0, x20
0x0000459c  bl       #0x55d78   ; CALL _objc_release
0x000045a0  adrp     x8, #0x8e000
0x000045a4  ldrsw    x8, [x8, #0xdc0]
0x000045a8  ldr      x0, [x19, x8]
0x000045ac  bl       #0x18828   ; CALL _OMCStyleTable
0x000045b0  ldp      x29, x30, [sp, #0x30]
0x000045b4  ldp      x20, x19, [sp, #0x20]
0x000045b8  ldp      x22, x21, [sp, #0x10]
0x000045bc  add      sp, sp, #0x40
0x000045c0  ret      

=== -[OMCCardPage viewWillAppear:]  va=0x45c4 size=228 types=v20@0:8B16
0x000045c4  sub      sp, sp, #0x40
0x000045c8  stp      x22, x21, [sp, #0x10]
0x000045cc  stp      x20, x19, [sp, #0x20]
0x000045d0  stp      x29, x30, [sp, #0x30]
0x000045d4  add      x29, sp, #0x30
0x000045d8  mov      x19, x0
0x000045dc  adrp     x8, #0x8e000
0x000045e0  ldr      x8, [x8, #0xd08]   ; @SUPER OMCCardPage
0x000045e4  stp      x0, x8, [sp]
0x000045e8  adrp     x8, #0x8b000
0x000045ec  ldr      x1, [x8, #0xda8]   ; @SEL "viewWillAppear:"
0x000045f0  mov      x0, sp
0x000045f4  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x000045f8  adrp     x0, #0x75000
0x000045fc  add      x0, x0, #0x28   ; STR "com.anlai.omnicar"
0x00004600  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x00004604  mov      x0, x19
0x00004608  bl       #0x5cdc0   ; CALL objc_msgSend$specifier
0x0000460c  mov      x29, x29
0x00004610  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004614  mov      x20, x0
0x00004618  bl       #0x590e0   ; CALL objc_msgSend$name
0x0000461c  mov      x29, x29
0x00004620  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004624  mov      x21, x0
0x00004628  bl       #0x58c20   ; CALL objc_msgSend$length
0x0000462c  mov      x22, x0
0x00004630  mov      x0, x21
0x00004634  bl       #0x55d78   ; CALL _objc_release
0x00004638  mov      x0, x20
0x0000463c  bl       #0x55d78   ; CALL _objc_release
0x00004640  cbz      x22, #0x4684
0x00004644  mov      x0, x19
0x00004648  bl       #0x5cdc0   ; CALL objc_msgSend$specifier
0x0000464c  mov      x29, x29
0x00004650  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004654  mov      x20, x0
0x00004658  bl       #0x590e0   ; CALL objc_msgSend$name
0x0000465c  mov      x29, x29
0x00004660  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004664  mov      x21, x0
0x00004668  mov      x0, x19
0x0000466c  mov      x2, x21
0x00004670  bl       #0x5c5e0   ; CALL objc_msgSend$setTitle:
0x00004674  mov      x0, x21
0x00004678  bl       #0x55d78   ; CALL _objc_release
0x0000467c  mov      x0, x20
0x00004680  bl       #0x55d78   ; CALL _objc_release
0x00004684  adrp     x8, #0x8e000
0x00004688  ldrsw    x8, [x8, #0xdc0]
0x0000468c  ldr      x0, [x19, x8]
0x00004690  bl       #0x59ca0   ; CALL objc_msgSend$reloadData
0x00004694  ldp      x29, x30, [sp, #0x30]
0x00004698  ldp      x20, x19, [sp, #0x20]
0x0000469c  ldp      x22, x21, [sp, #0x10]
0x000046a0  add      sp, sp, #0x40
0x000046a4  ret      

=== -[OMCCardPage traitCollectionDidChange:]  va=0x46a8 size=180 types=v24@0:8@16
0x000046a8  sub      sp, sp, #0x50
0x000046ac  stp      x24, x23, [sp, #0x10]
0x000046b0  stp      x22, x21, [sp, #0x20]
0x000046b4  stp      x20, x19, [sp, #0x30]
0x000046b8  stp      x29, x30, [sp, #0x40]
0x000046bc  add      x29, sp, #0x40
0x000046c0  mov      x20, x2
0x000046c4  mov      x19, x0
0x000046c8  adrp     x8, #0x8e000
0x000046cc  ldr      x8, [x8, #0xd08]   ; @SUPER OMCCardPage
0x000046d0  stp      x0, x8, [sp]
0x000046d4  adrp     x8, #0x8b000
0x000046d8  ldr      x21, [x8, #0xdb0]   ; @SEL "traitCollectionDidChange:"
0x000046dc  mov      x0, x2
0x000046e0  bl       #0x55d84   ; CALL _objc_retain
0x000046e4  mov      x0, sp
0x000046e8  mov      x1, x21
0x000046ec  mov      x2, x20
0x000046f0  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x000046f4  mov      x0, x19
0x000046f8  bl       #0x5dc60   ; CALL objc_msgSend$traitCollection
0x000046fc  mov      x29, x29
0x00004700  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004704  mov      x21, x0
0x00004708  bl       #0x5de60   ; CALL objc_msgSend$userInterfaceStyle
0x0000470c  mov      x22, x0
0x00004710  mov      x0, x20
0x00004714  bl       #0x5de60   ; CALL objc_msgSend$userInterfaceStyle
0x00004718  mov      x23, x0
0x0000471c  mov      x0, x20
0x00004720  bl       #0x55d78   ; CALL _objc_release
0x00004724  mov      x0, x21
0x00004728  bl       #0x55d78   ; CALL _objc_release
0x0000472c  cmp      x22, x23
0x00004730  b.eq     #0x4744
0x00004734  adrp     x8, #0x8e000
0x00004738  ldrsw    x8, [x8, #0xdc0]
0x0000473c  ldr      x0, [x19, x8]
0x00004740  bl       #0x18828   ; CALL _OMCStyleTable
0x00004744  ldp      x29, x30, [sp, #0x40]
0x00004748  ldp      x20, x19, [sp, #0x30]
0x0000474c  ldp      x22, x21, [sp, #0x20]
0x00004750  ldp      x24, x23, [sp, #0x10]
0x00004754  add      sp, sp, #0x50
0x00004758  ret      

=== -[OMCCardPage prefForKey:def:]  va=0x475c size=108 types=@32@0:8@16@24
0x0000475c  stp      x22, x21, [sp, #-0x30]!
0x00004760  stp      x20, x19, [sp, #0x10]
0x00004764  stp      x29, x30, [sp, #0x20]
0x00004768  add      x29, sp, #0x20
0x0000476c  mov      x19, x3
0x00004770  mov      x20, x2
0x00004774  mov      x0, x3
0x00004778  bl       #0x55d84   ; CALL _objc_retain
0x0000477c  cbz      x20, #0x4794
0x00004780  adrp     x1, #0x75000
0x00004784  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x00004788  mov      x0, x20
0x0000478c  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x00004790  mov      x20, x0
0x00004794  cmp      x20, #0
0x00004798  csel     x21, x19, x20, eq
0x0000479c  mov      x0, x21
0x000047a0  bl       #0x55d84   ; CALL _objc_retain
0x000047a4  mov      x0, x20
0x000047a8  bl       #0x55d78   ; CALL _objc_release
0x000047ac  mov      x0, x19
0x000047b0  bl       #0x55d78   ; CALL _objc_release
0x000047b4  mov      x0, x21
0x000047b8  ldp      x29, x30, [sp, #0x20]
0x000047bc  ldp      x20, x19, [sp, #0x10]
0x000047c0  ldp      x22, x21, [sp], #0x30
0x000047c4  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCCardPage intForKey:def:]  va=0x47c8 size=88 types=q32@0:8@16q24
0x000047c8  stp      x20, x19, [sp, #-0x20]!
0x000047cc  stp      x29, x30, [sp, #0x10]
0x000047d0  add      x29, sp, #0x10
0x000047d4  mov      x19, x3
0x000047d8  mov      x3, #0
0x000047dc  bl       #0x598c0   ; CALL objc_msgSend$prefForKey:def:
0x000047e0  mov      x29, x29
0x000047e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000047e8  mov      x20, x0
0x000047ec  adrp     x8, #0x8c000
0x000047f0  ldr      x1, [x8, #0x978]   ; @SEL "integerValue"
0x000047f4  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x000047f8  tbz      w0, #0, #0x4808
0x000047fc  mov      x0, x20
0x00004800  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x00004804  mov      x19, x0
0x00004808  mov      x0, x20
0x0000480c  bl       #0x55d78   ; CALL _objc_release
0x00004810  mov      x0, x19
0x00004814  ldp      x29, x30, [sp, #0x10]
0x00004818  ldp      x20, x19, [sp], #0x20
0x0000481c  ret      

=== -[OMCCardPage storeValue:forKey:]  va=0x4820 size=72 types=v32@0:8@16@24
0x00004820  cbz      x3, #0x4864
0x00004824  stp      x20, x19, [sp, #-0x20]!
0x00004828  stp      x29, x30, [sp, #0x10]
0x0000482c  add      x29, sp, #0x10
0x00004830  adrp     x19, #0x75000
0x00004834  add      x19, x19, #0x28   ; STR "com.anlai.omnicar"
0x00004838  mov      x0, x3
0x0000483c  mov      x1, x2
0x00004840  mov      x2, x19
0x00004844  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x00004848  mov      x0, x19
0x0000484c  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x00004850  adrp     x0, #0x61000
0x00004854  add      x0, x0, #0x1b1   ; CSTR "com.anlai.omnicar/prefschanged"
0x00004858  ldp      x29, x30, [sp, #0x10]
0x0000485c  ldp      x20, x19, [sp], #0x20
0x00004860  b        #0x55c70   ; CALL _notify_post
0x00004864  ret      

=== -[OMCCardPage prefChanged:]  va=0x4868 size=4 types=v24@0:8@16
0x00004868  ret      

=== -[OMCCardPage prefChanging:]  va=0x486c size=4 types=v24@0:8@16
0x0000486c  ret      

=== -[OMCCardPage cellWithId:]  va=0x4870 size=488 types=@24@0:8@16
0x00004870  stp      x24, x23, [sp, #-0x40]!
0x00004874  stp      x22, x21, [sp, #0x10]
0x00004878  stp      x20, x19, [sp, #0x20]
0x0000487c  stp      x29, x30, [sp, #0x30]
0x00004880  add      x29, sp, #0x30
0x00004884  mov      x19, x2
0x00004888  mov      x20, x0
0x0000488c  mov      x0, x2
0x00004890  bl       #0x55d84   ; CALL _objc_retain
0x00004894  adrp     x8, #0x8e000
0x00004898  ldrsw    x8, [x8, #0xdc0]
0x0000489c  ldr      x0, [x20, x8]
0x000048a0  mov      x2, x19
0x000048a4  bl       #0x576e0   ; CALL objc_msgSend$dequeueReusableCellWithIdentifier:
0x000048a8  mov      x29, x29
0x000048ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000048b0  mov      x20, x0
0x000048b4  cbnz     x0, #0x48d4
0x000048b8  adrp     x8, #0x8e000
0x000048bc  ldr      x0, [x8, #0x908]   ; @CLASS UITableViewCell
0x000048c0  bl       #0x55c7c   ; CALL _objc_alloc
0x000048c4  mov      w2, #3
0x000048c8  mov      x3, x19
0x000048cc  bl       #0x585c0   ; CALL objc_msgSend$initWithStyle:reuseIdentifier:
0x000048d0  mov      x20, x0
0x000048d4  mov      x0, x20
0x000048d8  bl       #0x19168   ; CALL _OMCStyleCell
0x000048dc  mov      x0, x20
0x000048e0  mov      x2, #0
0x000048e4  bl       #0x5a2c0   ; CALL objc_msgSend$setAccessoryView:
0x000048e8  mov      x0, x20
0x000048ec  mov      x2, #0
0x000048f0  bl       #0x5a2a0   ; CALL objc_msgSend$setAccessoryType:
0x000048f4  mov      x0, x20
0x000048f8  mov      x2, #0
0x000048fc  bl       #0x5bfa0   ; CALL objc_msgSend$setSelectionStyle:
0x00004900  mov      x0, x20
0x00004904  bl       #0x58120   ; CALL objc_msgSend$imageView
0x00004908  mov      x29, x29
0x0000490c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004910  mov      x21, x0
0x00004914  mov      x2, #0
0x00004918  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x0000491c  mov      x0, x21
0x00004920  bl       #0x55d78   ; CALL _objc_release
0x00004924  mov      x0, x20
0x00004928  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x0000492c  mov      x29, x29
0x00004930  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004934  mov      x21, x0
0x00004938  mov      x2, #0
0x0000493c  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00004940  mov      x0, x21
0x00004944  bl       #0x55d78   ; CALL _objc_release
0x00004948  mov      x0, x20
0x0000494c  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x00004950  mov      x29, x29
0x00004954  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004958  mov      x21, x0
0x0000495c  mov      x2, #0
0x00004960  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00004964  mov      x0, x21
0x00004968  bl       #0x55d78   ; CALL _objc_release
0x0000496c  adrp     x23, #0x8e000
0x00004970  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x00004974  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x00004978  mov      x29, x29
0x0000497c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004980  mov      x21, x0
0x00004984  mov      x0, x20
0x00004988  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x0000498c  mov      x29, x29
0x00004990  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004994  mov      x22, x0
0x00004998  mov      x2, x21
0x0000499c  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x000049a0  mov      x0, x22
0x000049a4  bl       #0x55d78   ; CALL _objc_release
0x000049a8  mov      x0, x21
0x000049ac  bl       #0x55d78   ; CALL _objc_release
0x000049b0  mov      x0, x20
0x000049b4  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x000049b8  mov      x29, x29
0x000049bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000049c0  mov      x21, x0
0x000049c4  fmov     d0, #1.00000000
0x000049c8  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x000049cc  mov      x0, x21
0x000049d0  bl       #0x55d78   ; CALL _objc_release
0x000049d4  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x000049d8  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x000049dc  mov      x29, x29
0x000049e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000049e4  mov      x21, x0
0x000049e8  mov      x0, x20
0x000049ec  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x000049f0  mov      x29, x29
0x000049f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000049f8  mov      x22, x0
0x000049fc  mov      x2, x21
0x00004a00  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00004a04  mov      x0, x22
0x00004a08  bl       #0x55d78   ; CALL _objc_release
0x00004a0c  mov      x0, x21
0x00004a10  bl       #0x55d78   ; CALL _objc_release
0x00004a14  mov      x0, x20
0x00004a18  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x00004a1c  mov      x29, x29
0x00004a20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004a24  mov      x21, x0
0x00004a28  mov      w2, #2
0x00004a2c  bl       #0x5b820   ; CALL objc_msgSend$setNumberOfLines:
0x00004a30  mov      x0, x21
0x00004a34  bl       #0x55d78   ; CALL _objc_release
0x00004a38  mov      x0, x19
0x00004a3c  bl       #0x55d78   ; CALL _objc_release
0x00004a40  mov      x0, x20
0x00004a44  ldp      x29, x30, [sp, #0x30]
0x00004a48  ldp      x20, x19, [sp, #0x20]
0x00004a4c  ldp      x22, x21, [sp, #0x10]
0x00004a50  ldp      x24, x23, [sp], #0x40
0x00004a54  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCCardPage boxInCell:]  va=0x4a58 size=228 types=@24@0:8@16
0x00004a58  stp      x22, x21, [sp, #-0x30]!
0x00004a5c  stp      x20, x19, [sp, #0x10]
0x00004a60  stp      x29, x30, [sp, #0x20]
0x00004a64  add      x29, sp, #0x20
0x00004a68  mov      x19, x2
0x00004a6c  mov      x0, x2
0x00004a70  bl       #0x55d84   ; CALL _objc_retain
0x00004a74  mov      x0, x19
0x00004a78  bl       #0x57280   ; CALL objc_msgSend$contentView
0x00004a7c  mov      x29, x29
0x00004a80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004a84  mov      x21, x0
0x00004a88  mov      w2, #0x4258
0x00004a8c  bl       #0x5df80   ; CALL objc_msgSend$viewWithTag:
0x00004a90  mov      x29, x29
0x00004a94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004a98  mov      x20, x0
0x00004a9c  mov      x0, x21
0x00004aa0  bl       #0x55d78   ; CALL _objc_release
0x00004aa4  cbnz     x20, #0x4b20
0x00004aa8  adrp     x8, #0x8e000
0x00004aac  ldr      x0, [x8, #0x918]   ; @CLASS UIView
0x00004ab0  bl       #0x55c7c   ; CALL _objc_alloc
0x00004ab4  mov      x20, x0
0x00004ab8  mov      x0, x19
0x00004abc  bl       #0x57280   ; CALL objc_msgSend$contentView
0x00004ac0  mov      x29, x29
0x00004ac4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004ac8  mov      x21, x0
0x00004acc  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00004ad0  mov      x0, x20
0x00004ad4  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x00004ad8  mov      x20, x0
0x00004adc  mov      x0, x21
0x00004ae0  bl       #0x55d78   ; CALL _objc_release
0x00004ae4  mov      x0, x20
0x00004ae8  mov      w2, #0x4258
0x00004aec  bl       #0x5c480   ; CALL objc_msgSend$setTag:
0x00004af0  mov      x0, x20
0x00004af4  mov      w2, #0x12
0x00004af8  bl       #0x5a500   ; CALL objc_msgSend$setAutoresizingMask:
0x00004afc  mov      x0, x19
0x00004b00  bl       #0x57280   ; CALL objc_msgSend$contentView
0x00004b04  mov      x29, x29
0x00004b08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004b0c  mov      x21, x0
0x00004b10  mov      x2, x20
0x00004b14  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00004b18  mov      x0, x21
0x00004b1c  bl       #0x55d78   ; CALL _objc_release
0x00004b20  mov      x0, x19
0x00004b24  bl       #0x55d78   ; CALL _objc_release
0x00004b28  mov      x0, x20
0x00004b2c  ldp      x29, x30, [sp, #0x20]
0x00004b30  ldp      x20, x19, [sp, #0x10]
0x00004b34  ldp      x22, x21, [sp], #0x30
0x00004b38  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCCardPage setAccessory:onCell:]  va=0x4b3c size=8 types=v32@0:8@16@24
0x00004b3c  mov      x0, x3
0x00004b40  b        #0x5a2c0   ; CALL objc_msgSend$setAccessoryView:

=== -[OMCCardPage switchForKey:def:]  va=0x4b44 size=264 types=@28@0:8@16B24
0x00004b44  stp      x24, x23, [sp, #-0x40]!
0x00004b48  stp      x22, x21, [sp, #0x10]
0x00004b4c  stp      x20, x19, [sp, #0x20]
0x00004b50  stp      x29, x30, [sp, #0x30]
0x00004b54  add      x29, sp, #0x30
0x00004b58  mov      x22, x3
0x00004b5c  mov      x21, x2
0x00004b60  mov      x19, x0
0x00004b64  adrp     x8, #0x8e000
0x00004b68  ldr      x20, [x8, #0x920]   ; @CLASS UISwitch
0x00004b6c  mov      x0, x2
0x00004b70  bl       #0x55d84   ; CALL _objc_retain
0x00004b74  mov      x0, x20
0x00004b78  bl       #0x55d60   ; CALL _objc_opt_new
0x00004b7c  mov      x20, x0
0x00004b80  bl       #0x17fd8   ; CALL _OMCSwitchColor
0x00004b84  mov      x29, x29
0x00004b88  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004b8c  mov      x23, x0
0x00004b90  mov      x0, x20
0x00004b94  mov      x2, x23
0x00004b98  bl       #0x5b920   ; CALL objc_msgSend$setOnTintColor:
0x00004b9c  mov      x0, x23
0x00004ba0  bl       #0x55d78   ; CALL _objc_release
0x00004ba4  adrp     x8, #0x8e000
0x00004ba8  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x00004bac  mov      x2, x22
0x00004bb0  bl       #0x592c0   ; CALL objc_msgSend$numberWithBool:
0x00004bb4  mov      x29, x29
0x00004bb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004bbc  mov      x22, x0
0x00004bc0  mov      x0, x19
0x00004bc4  mov      x2, x21
0x00004bc8  mov      x3, x22
0x00004bcc  bl       #0x598c0   ; CALL objc_msgSend$prefForKey:def:
0x00004bd0  mov      x29, x29
0x00004bd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004bd8  mov      x23, x0
0x00004bdc  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00004be0  mov      x2, x0
0x00004be4  mov      x0, x20
0x00004be8  bl       #0x5b900   ; CALL objc_msgSend$setOn:
0x00004bec  mov      x0, x23
0x00004bf0  bl       #0x55d78   ; CALL _objc_release
0x00004bf4  mov      x0, x22
0x00004bf8  bl       #0x55d78   ; CALL _objc_release
0x00004bfc  adrp     x1, #0x8f000
0x00004c00  add      x1, x1, #0xff8
0x00004c04  mov      x0, x20
0x00004c08  mov      x2, x21
0x00004c0c  mov      w3, #3
0x00004c10  bl       #0x55db4   ; CALL _objc_setAssociatedObject
0x00004c14  mov      x0, x21
0x00004c18  bl       #0x55d78   ; CALL _objc_release
0x00004c1c  adrp     x8, #0x8b000
0x00004c20  ldr      x3, [x8, #0xdb8]   ; @SEL "omcSwitchChanged:"
0x00004c24  mov      x0, x20
0x00004c28  mov      x2, x19
0x00004c2c  mov      w4, #0x1000
0x00004c30  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x00004c34  mov      x0, x20
0x00004c38  ldp      x29, x30, [sp, #0x30]
0x00004c3c  ldp      x20, x19, [sp, #0x20]
0x00004c40  ldp      x22, x21, [sp, #0x10]
0x00004c44  ldp      x24, x23, [sp], #0x40
0x00004c48  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCCardPage omcSwitchChanged:]  va=0x4c4c size=176 types=v24@0:8@16
0x00004c4c  stp      x24, x23, [sp, #-0x40]!
0x00004c50  stp      x22, x21, [sp, #0x10]
0x00004c54  stp      x20, x19, [sp, #0x20]
0x00004c58  stp      x29, x30, [sp, #0x30]
0x00004c5c  add      x29, sp, #0x30
0x00004c60  mov      x19, x2
0x00004c64  mov      x20, x0
0x00004c68  mov      x0, x2
0x00004c6c  bl       #0x55d84   ; CALL _objc_retain
0x00004c70  adrp     x1, #0x8f000
0x00004c74  add      x1, x1, #0xff8
0x00004c78  mov      x0, x19
0x00004c7c  bl       #0x55d00   ; CALL _objc_getAssociatedObject
0x00004c80  mov      x29, x29
0x00004c84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004c88  mov      x21, x0
0x00004c8c  adrp     x8, #0x8e000
0x00004c90  ldr      x22, [x8, #0x928]   ; @CLASS NSNumber
0x00004c94  mov      x0, x19
0x00004c98  bl       #0x588c0   ; CALL objc_msgSend$isOn
0x00004c9c  mov      x23, x0
0x00004ca0  mov      x0, x19
0x00004ca4  bl       #0x55d78   ; CALL _objc_release
0x00004ca8  mov      x0, x22
0x00004cac  mov      x2, x23
0x00004cb0  bl       #0x592c0   ; CALL objc_msgSend$numberWithBool:
0x00004cb4  mov      x29, x29
0x00004cb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004cbc  mov      x19, x0
0x00004cc0  mov      x0, x20
0x00004cc4  mov      x2, x19
0x00004cc8  mov      x3, x21
0x00004ccc  bl       #0x5d3c0   ; CALL objc_msgSend$storeValue:forKey:
0x00004cd0  mov      x0, x19
0x00004cd4  bl       #0x55d78   ; CALL _objc_release
0x00004cd8  mov      x0, x20
0x00004cdc  mov      x2, x21
0x00004ce0  bl       #0x59880   ; CALL objc_msgSend$prefChanged:
0x00004ce4  mov      x0, x21
0x00004ce8  ldp      x29, x30, [sp, #0x30]
0x00004cec  ldp      x20, x19, [sp, #0x20]
0x00004cf0  ldp      x22, x21, [sp, #0x10]
0x00004cf4  ldp      x24, x23, [sp], #0x40
0x00004cf8  b        #0x55d78   ; CALL _objc_release

=== -[OMCCardPage segmentForKey:titles:def:]  va=0x4cfc size=220 types=@40@0:8@16@24q32
0x00004cfc  stp      x24, x23, [sp, #-0x40]!
0x00004d00  stp      x22, x21, [sp, #0x10]
0x00004d04  stp      x20, x19, [sp, #0x20]
0x00004d08  stp      x29, x30, [sp, #0x30]
0x00004d0c  add      x29, sp, #0x30
0x00004d10  mov      x23, x4
0x00004d14  mov      x20, x3
0x00004d18  mov      x19, x2
0x00004d1c  mov      x21, x0
0x00004d20  mov      x0, x2
0x00004d24  bl       #0x55d84   ; CALL _objc_retain
0x00004d28  mov      x0, x20
0x00004d2c  bl       #0x55d84   ; CALL _objc_retain
0x00004d30  adrp     x8, #0x8e000
0x00004d34  ldr      x0, [x8, #0x930]   ; @CLASS UISegmentedControl
0x00004d38  bl       #0x55c7c   ; CALL _objc_alloc
0x00004d3c  mov      x2, x20
0x00004d40  bl       #0x58500   ; CALL objc_msgSend$initWithItems:
0x00004d44  mov      x22, x0
0x00004d48  mov      x0, x21
0x00004d4c  mov      x2, x19
0x00004d50  mov      x3, x23
0x00004d54  bl       #0x58700   ; CALL objc_msgSend$intForKey:def:
0x00004d58  tbnz     x0, #0x3f, #0x4d70
0x00004d5c  mov      x24, x0
0x00004d60  mov      x0, x20
0x00004d64  bl       #0x573c0   ; CALL objc_msgSend$count
0x00004d68  cmp      x24, x0
0x00004d6c  b.lt     #0x4d74
0x00004d70  mov      x24, x23
0x00004d74  mov      x0, x22
0x00004d78  mov      x2, x24
0x00004d7c  bl       #0x5bf60   ; CALL objc_msgSend$setSelectedSegmentIndex:
0x00004d80  adrp     x1, #0x8f000
0x00004d84  add      x1, x1, #0xff8
0x00004d88  mov      x0, x22
0x00004d8c  mov      x2, x19
0x00004d90  mov      w3, #3
0x00004d94  bl       #0x55db4   ; CALL _objc_setAssociatedObject
0x00004d98  adrp     x8, #0x8b000
0x00004d9c  ldr      x3, [x8, #0xdc0]   ; @SEL "omcSegmentChanged:"
0x00004da0  mov      x0, x22
0x00004da4  mov      x2, x21
0x00004da8  mov      w4, #0x1000
0x00004dac  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x00004db0  mov      x0, x20
0x00004db4  bl       #0x55d78   ; CALL _objc_release
0x00004db8  mov      x0, x19
0x00004dbc  bl       #0x55d78   ; CALL _objc_release
0x00004dc0  mov      x0, x22
0x00004dc4  ldp      x29, x30, [sp, #0x30]
0x00004dc8  ldp      x20, x19, [sp, #0x20]
0x00004dcc  ldp      x22, x21, [sp, #0x10]
0x00004dd0  ldp      x24, x23, [sp], #0x40
0x00004dd4  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCCardPage omcSegmentChanged:]  va=0x4dd8 size=204 types=v24@0:8@16
0x00004dd8  stp      x24, x23, [sp, #-0x40]!
0x00004ddc  stp      x22, x21, [sp, #0x10]
0x00004de0  stp      x20, x19, [sp, #0x20]
0x00004de4  stp      x29, x30, [sp, #0x30]
0x00004de8  add      x29, sp, #0x30
0x00004dec  mov      x19, x2
0x00004df0  mov      x20, x0
0x00004df4  mov      x0, x2
0x00004df8  bl       #0x55d84   ; CALL _objc_retain
0x00004dfc  adrp     x1, #0x8f000
0x00004e00  add      x1, x1, #0xff8
0x00004e04  mov      x0, x19
0x00004e08  bl       #0x55d00   ; CALL _objc_getAssociatedObject
0x00004e0c  mov      x29, x29
0x00004e10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004e14  mov      x21, x0
0x00004e18  adrp     x8, #0x8e000
0x00004e1c  ldr      x0, [x8, #0x938]   ; @CLASS UISelectionFeedbackGenerator
0x00004e20  bl       #0x55d60   ; CALL _objc_opt_new
0x00004e24  mov      x22, x0
0x00004e28  bl       #0x5a200   ; CALL objc_msgSend$selectionChanged
0x00004e2c  mov      x0, x22
0x00004e30  bl       #0x55d78   ; CALL _objc_release
0x00004e34  adrp     x8, #0x8e000
0x00004e38  ldr      x22, [x8, #0x928]   ; @CLASS NSNumber
0x00004e3c  mov      x0, x19
0x00004e40  bl       #0x5a1c0   ; CALL objc_msgSend$selectedSegmentIndex
0x00004e44  mov      x23, x0
0x00004e48  mov      x0, x19
0x00004e4c  bl       #0x55d78   ; CALL _objc_release
0x00004e50  mov      x0, x22
0x00004e54  mov      x2, x23
0x00004e58  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x00004e5c  mov      x29, x29
0x00004e60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004e64  mov      x19, x0
0x00004e68  mov      x0, x20
0x00004e6c  mov      x2, x19
0x00004e70  mov      x3, x21
0x00004e74  bl       #0x5d3c0   ; CALL objc_msgSend$storeValue:forKey:
0x00004e78  mov      x0, x19
0x00004e7c  bl       #0x55d78   ; CALL _objc_release
0x00004e80  mov      x0, x20
0x00004e84  mov      x2, x21
0x00004e88  bl       #0x59880   ; CALL objc_msgSend$prefChanged:
0x00004e8c  mov      x0, x21
0x00004e90  ldp      x29, x30, [sp, #0x30]
0x00004e94  ldp      x20, x19, [sp, #0x20]
0x00004e98  ldp      x22, x21, [sp, #0x10]
0x00004e9c  ldp      x24, x23, [sp], #0x40
0x00004ea0  b        #0x55d78   ; CALL _objc_release

=== -[OMCCardPage sliderForKey:min:max:def:format:width:]  va=0x4ea4 size=776 types=@64@0:8@16q24q32q40@48d56
0x00004ea4  sub      sp, sp, #0xa0
0x00004ea8  stp      d9, d8, [sp, #0x30]
0x00004eac  stp      x28, x27, [sp, #0x40]
0x00004eb0  stp      x26, x25, [sp, #0x50]
0x00004eb4  stp      x24, x23, [sp, #0x60]
0x00004eb8  stp      x22, x21, [sp, #0x70]
0x00004ebc  stp      x20, x19, [sp, #0x80]
0x00004ec0  stp      x29, x30, [sp, #0x90]
0x00004ec4  add      x29, sp, #0x90
0x00004ec8  mov      v8.16b, v0.16b
0x00004ecc  mov      x20, x6
0x00004ed0  mov      x26, x5
0x00004ed4  mov      x24, x4
0x00004ed8  mov      x25, x3
0x00004edc  mov      x19, x2
0x00004ee0  mov      x22, x0
0x00004ee4  adrp     x8, #0x74000
0x00004ee8  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00004eec  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00004ef0  str      x8, [sp, #0x28]
0x00004ef4  adrp     x8, #0x8e000
0x00004ef8  ldr      x21, [x8, #0x918]   ; @CLASS UIView
0x00004efc  mov      x0, x6
0x00004f00  bl       #0x55d84   ; CALL _objc_retain
0x00004f04  mov      x0, x19
0x00004f08  bl       #0x55d84   ; CALL _objc_retain
0x00004f0c  mov      x0, x21
0x00004f10  bl       #0x55c7c   ; CALL _objc_alloc
0x00004f14  mov      x8, #0x4040000000000000
0x00004f18  fmov     d9, x8
0x00004f1c  fmov     d0, xzr
0x00004f20  fmov     d1, xzr
0x00004f24  mov      v2.16b, v8.16b
0x00004f28  mov      v3.16b, v9.16b
0x00004f2c  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x00004f30  mov      x21, x0
0x00004f34  adrp     x8, #0x8e000
0x00004f38  ldr      x0, [x8, #0x940]   ; @CLASS UILabel
0x00004f3c  bl       #0x55c7c   ; CALL _objc_alloc
0x00004f40  mov      x8, #-0x3fb1000000000000
0x00004f44  fmov     d0, x8
0x00004f48  fadd     d0, d8, d0
0x00004f4c  mov      x8, #0x404f000000000000
0x00004f50  fmov     d2, x8
0x00004f54  fmov     d1, xzr
0x00004f58  mov      v3.16b, v9.16b
0x00004f5c  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x00004f60  mov      x23, x0
0x00004f64  mov      w2, #2
0x00004f68  bl       #0x5c4e0   ; CALL objc_msgSend$setTextAlignment:
0x00004f6c  adrp     x8, #0x8e000
0x00004f70  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x00004f74  adrp     x8, #0x74000
0x00004f78  ldr      x8, [x8, #0x258]   ; @GOT _UIFontWeightRegular
0x00004f7c  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x00004f80  fmov     d0, #14.00000000
0x00004f84  bl       #0x58fe0   ; CALL objc_msgSend$monospacedDigitSystemFontOfSize:weight:
0x00004f88  mov      x29, x29
0x00004f8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004f90  mov      x27, x0
0x00004f94  mov      x0, x23
0x00004f98  mov      x2, x27
0x00004f9c  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00004fa0  mov      x0, x27
0x00004fa4  bl       #0x55d78   ; CALL _objc_release
0x00004fa8  adrp     x8, #0x8e000
0x00004fac  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00004fb0  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x00004fb4  mov      x29, x29
0x00004fb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00004fbc  mov      x27, x0
0x00004fc0  mov      x0, x23
0x00004fc4  mov      x2, x27
0x00004fc8  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00004fcc  mov      x0, x27
0x00004fd0  bl       #0x55d78   ; CALL _objc_release
0x00004fd4  mov      x0, x23
0x00004fd8  mov      w2, #1
0x00004fdc  bl       #0x5a380   ; CALL objc_msgSend$setAdjustsFontSizeToFitWidth:
0x00004fe0  adrp     x8, #0x8e000
0x00004fe4  ldr      x0, [x8, #0x950]   ; @CLASS UISlider
0x00004fe8  bl       #0x55c7c   ; CALL _objc_alloc
0x00004fec  mov      x8, #-0x3faf000000000000
0x00004ff0  fmov     d0, x8
0x00004ff4  fadd     d2, d8, d0
0x00004ff8  fmov     d0, xzr
0x00004ffc  fmov     d1, xzr
0x00005000  mov      v3.16b, v9.16b
0x00005004  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x00005008  mov      x27, x0
0x0000500c  scvtf    s0, x25
0x00005010  bl       #0x5b6a0   ; CALL objc_msgSend$setMinimumValue:
0x00005014  scvtf    s0, x24
0x00005018  mov      x0, x27
0x0000501c  bl       #0x5b580   ; CALL objc_msgSend$setMaximumValue:
0x00005020  mov      x0, x22
0x00005024  mov      x2, x19
0x00005028  mov      x3, x26
0x0000502c  bl       #0x58700   ; CALL objc_msgSend$intForKey:def:
0x00005030  cmp      x25, x0
0x00005034  csel     x8, x25, x0, gt
0x00005038  cmp      x24, x8
0x0000503c  csel     x8, x24, x8, lt
0x00005040  scvtf    s0, x8
0x00005044  mov      x0, x27
0x00005048  bl       #0x5c780   ; CALL objc_msgSend$setValue:
0x0000504c  bl       #0x17e8c   ; CALL _OMCAccentColor
0x00005050  mov      x29, x29
0x00005054  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005058  mov      x24, x0
0x0000505c  mov      x0, x27
0x00005060  mov      x2, x24
0x00005064  bl       #0x5b680   ; CALL objc_msgSend$setMinimumTrackTintColor:
0x00005068  mov      x0, x24
0x0000506c  bl       #0x55d78   ; CALL _objc_release
0x00005070  adrp     x8, #0x8e000
0x00005074  ldr      x24, [x8, #0x958]   ; @CLASS NSString
0x00005078  mov      x0, x27
0x0000507c  bl       #0x5dea0   ; CALL objc_msgSend$value
0x00005080  fcvt     d0, s0
0x00005084  fcvtas   x8, d0
0x00005088  str      x8, [sp]
0x0000508c  mov      x0, x24
0x00005090  mov      x2, x20
0x00005094  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00005098  mov      x29, x29
0x0000509c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000050a0  mov      x24, x0
0x000050a4  mov      x0, x23
0x000050a8  mov      x2, x24
0x000050ac  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x000050b0  mov      x0, x24
0x000050b4  bl       #0x55d78   ; CALL _objc_release
0x000050b8  stp      x19, x20, [sp, #0x10]
0x000050bc  str      x23, [sp, #0x20]
0x000050c0  adrp     x8, #0x8e000
0x000050c4  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000050c8  add      x2, sp, #0x10
0x000050cc  mov      w3, #3
0x000050d0  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000050d4  mov      x29, x29
0x000050d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000050dc  mov      x24, x0
0x000050e0  adrp     x1, #0x8f000
0x000050e4  add      x1, x1, #0xff8
0x000050e8  mov      x0, x27
0x000050ec  mov      x2, x24
0x000050f0  mov      w3, #1
0x000050f4  bl       #0x55db4   ; CALL _objc_setAssociatedObject
0x000050f8  mov      x0, x24
0x000050fc  bl       #0x55d78   ; CALL _objc_release
0x00005100  adrp     x8, #0x8b000
0x00005104  ldr      x3, [x8, #0xdc8]   ; @SEL "omcSliderMoved:"
0x00005108  mov      x0, x27
0x0000510c  mov      x2, x22
0x00005110  mov      w4, #0x1000
0x00005114  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x00005118  adrp     x8, #0x8b000
0x0000511c  ldr      x3, [x8, #0xdd0]   ; @SEL "omcSliderDone:"
0x00005120  mov      x0, x27
0x00005124  mov      x2, x22
0x00005128  mov      w4, #0xc0
0x0000512c  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x00005130  mov      x0, x20
0x00005134  bl       #0x55d78   ; CALL _objc_release
0x00005138  mov      x0, x19
0x0000513c  bl       #0x55d78   ; CALL _objc_release
0x00005140  mov      x0, x21
0x00005144  mov      x2, x27
0x00005148  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0000514c  mov      x0, x21
0x00005150  mov      x2, x23
0x00005154  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00005158  mov      x0, x27
0x0000515c  bl       #0x55d78   ; CALL _objc_release
0x00005160  mov      x0, x23
0x00005164  bl       #0x55d78   ; CALL _objc_release
0x00005168  ldr      x8, [sp, #0x28]
0x0000516c  adrp     x9, #0x74000
0x00005170  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00005174  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00005178  cmp      x9, x8
0x0000517c  b.ne     #0x51a8
0x00005180  mov      x0, x21
0x00005184  ldp      x29, x30, [sp, #0x90]
0x00005188  ldp      x20, x19, [sp, #0x80]
0x0000518c  ldp      x22, x21, [sp, #0x70]
0x00005190  ldp      x24, x23, [sp, #0x60]
0x00005194  ldp      x26, x25, [sp, #0x50]
0x00005198  ldp      x28, x27, [sp, #0x40]
0x0000519c  ldp      d9, d8, [sp, #0x30]
0x000051a0  add      sp, sp, #0xa0
0x000051a4  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x000051a8  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCCardPage omcSliderMoved:]  va=0x51ac size=372 types=v24@0:8@16
0x000051ac  sub      sp, sp, #0x60
0x000051b0  stp      d9, d8, [sp, #0x10]
0x000051b4  stp      x24, x23, [sp, #0x20]
0x000051b8  stp      x22, x21, [sp, #0x30]
0x000051bc  stp      x20, x19, [sp, #0x40]
0x000051c0  stp      x29, x30, [sp, #0x50]
0x000051c4  add      x29, sp, #0x50
0x000051c8  mov      x21, x2
0x000051cc  mov      x19, x0
0x000051d0  mov      x0, x2
0x000051d4  bl       #0x55d84   ; CALL _objc_retain
0x000051d8  adrp     x1, #0x8f000
0x000051dc  add      x1, x1, #0xff8
0x000051e0  mov      x0, x21
0x000051e4  bl       #0x55d00   ; CALL _objc_getAssociatedObject
0x000051e8  mov      x29, x29
0x000051ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000051f0  mov      x20, x0
0x000051f4  adrp     x8, #0x8e000
0x000051f8  ldr      x22, [x8, #0x958]   ; @CLASS NSString
0x000051fc  mov      w2, #1
0x00005200  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00005204  mov      x29, x29
0x00005208  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000520c  mov      x23, x0
0x00005210  mov      x0, x21
0x00005214  bl       #0x5dea0   ; CALL objc_msgSend$value
0x00005218  fcvt     d0, s0
0x0000521c  fcvtas   x8, d0
0x00005220  str      x8, [sp]
0x00005224  mov      x0, x22
0x00005228  mov      x2, x23
0x0000522c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00005230  mov      x29, x29
0x00005234  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005238  mov      x22, x0
0x0000523c  mov      x0, x20
0x00005240  mov      w2, #2
0x00005244  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00005248  mov      x29, x29
0x0000524c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005250  mov      x24, x0
0x00005254  mov      x2, x22
0x00005258  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0000525c  mov      x0, x24
0x00005260  bl       #0x55d78   ; CALL _objc_release
0x00005264  mov      x0, x22
0x00005268  bl       #0x55d78   ; CALL _objc_release
0x0000526c  mov      x0, x23
0x00005270  bl       #0x55d78   ; CALL _objc_release
0x00005274  mov      x0, x20
0x00005278  mov      x2, #0
0x0000527c  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00005280  mov      x29, x29
0x00005284  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005288  mov      x22, x0
0x0000528c  adrp     x8, #0x8e000
0x00005290  ldr      x23, [x8, #0x928]   ; @CLASS NSNumber
0x00005294  mov      x0, x21
0x00005298  bl       #0x5dea0   ; CALL objc_msgSend$value
0x0000529c  mov      v8.16b, v0.16b
0x000052a0  mov      x0, x21
0x000052a4  bl       #0x55d78   ; CALL _objc_release
0x000052a8  fcvt     d0, s8
0x000052ac  fcvtas   x2, d0
0x000052b0  mov      x0, x23
0x000052b4  bl       #0x59340   ; CALL objc_msgSend$numberWithLong:
0x000052b8  mov      x1, x0
0x000052bc  adrp     x2, #0x75000
0x000052c0  add      x2, x2, #0x28   ; STR "com.anlai.omnicar"
0x000052c4  mov      x0, x22
0x000052c8  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x000052cc  mov      x0, x22
0x000052d0  bl       #0x55d78   ; CALL _objc_release
0x000052d4  mov      x0, x20
0x000052d8  mov      x2, #0
0x000052dc  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000052e0  mov      x29, x29
0x000052e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000052e8  mov      x21, x0
0x000052ec  mov      x0, x19
0x000052f0  mov      x2, x21
0x000052f4  bl       #0x598a0   ; CALL objc_msgSend$prefChanging:
0x000052f8  mov      x0, x21
0x000052fc  bl       #0x55d78   ; CALL _objc_release
0x00005300  mov      x0, x20
0x00005304  ldp      x29, x30, [sp, #0x50]
0x00005308  ldp      x20, x19, [sp, #0x40]
0x0000530c  ldp      x22, x21, [sp, #0x30]
0x00005310  ldp      x24, x23, [sp, #0x20]
0x00005314  ldp      d9, d8, [sp, #0x10]
0x00005318  add      sp, sp, #0x60
0x0000531c  b        #0x55d78   ; CALL _objc_release

=== -[OMCCardPage omcSliderDone:]  va=0x5320 size=244 types=v24@0:8@16
0x00005320  stp      d9, d8, [sp, #-0x40]!
0x00005324  stp      x22, x21, [sp, #0x10]
0x00005328  stp      x20, x19, [sp, #0x20]
0x0000532c  stp      x29, x30, [sp, #0x30]
0x00005330  add      x29, sp, #0x30
0x00005334  mov      x20, x2
0x00005338  mov      x19, x0
0x0000533c  mov      x0, x2
0x00005340  bl       #0x55d84   ; CALL _objc_retain
0x00005344  adrp     x1, #0x8f000
0x00005348  add      x1, x1, #0xff8
0x0000534c  mov      x0, x20
0x00005350  bl       #0x55d00   ; CALL _objc_getAssociatedObject
0x00005354  mov      x29, x29
0x00005358  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000535c  mov      x21, x0
0x00005360  adrp     x8, #0x8e000
0x00005364  ldr      x22, [x8, #0x928]   ; @CLASS NSNumber
0x00005368  mov      x0, x20
0x0000536c  bl       #0x5dea0   ; CALL objc_msgSend$value
0x00005370  mov      v8.16b, v0.16b
0x00005374  mov      x0, x20
0x00005378  bl       #0x55d78   ; CALL _objc_release
0x0000537c  fcvt     d0, s8
0x00005380  fcvtas   x2, d0
0x00005384  mov      x0, x22
0x00005388  bl       #0x59340   ; CALL objc_msgSend$numberWithLong:
0x0000538c  mov      x29, x29
0x00005390  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005394  mov      x20, x0
0x00005398  mov      x0, x21
0x0000539c  mov      x2, #0
0x000053a0  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000053a4  mov      x29, x29
0x000053a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000053ac  mov      x22, x0
0x000053b0  mov      x0, x19
0x000053b4  mov      x2, x20
0x000053b8  mov      x3, x22
0x000053bc  bl       #0x5d3c0   ; CALL objc_msgSend$storeValue:forKey:
0x000053c0  mov      x0, x22
0x000053c4  bl       #0x55d78   ; CALL _objc_release
0x000053c8  mov      x0, x20
0x000053cc  bl       #0x55d78   ; CALL _objc_release
0x000053d0  mov      x0, x21
0x000053d4  mov      x2, #0
0x000053d8  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000053dc  mov      x29, x29
0x000053e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000053e4  mov      x20, x0
0x000053e8  mov      x0, x19
0x000053ec  mov      x2, x20
0x000053f0  bl       #0x59880   ; CALL objc_msgSend$prefChanged:
0x000053f4  mov      x0, x20
0x000053f8  bl       #0x55d78   ; CALL _objc_release
0x000053fc  mov      x0, x21
0x00005400  ldp      x29, x30, [sp, #0x30]
0x00005404  ldp      x20, x19, [sp, #0x20]
0x00005408  ldp      x22, x21, [sp, #0x10]
0x0000540c  ldp      d9, d8, [sp], #0x40
0x00005410  b        #0x55d78   ; CALL _objc_release

=== -[OMCCardPage toast:]  va=0x5414 size=772 types=v24@0:8@16
0x00005414  sub      sp, sp, #0xb0
0x00005418  stp      d13, d12, [sp, #0x50]
0x0000541c  stp      d11, d10, [sp, #0x60]
0x00005420  stp      d9, d8, [sp, #0x70]
0x00005424  stp      x22, x21, [sp, #0x80]
0x00005428  stp      x20, x19, [sp, #0x90]
0x0000542c  stp      x29, x30, [sp, #0xa0]
0x00005430  add      x29, sp, #0xa0
0x00005434  mov      x21, x2
0x00005438  mov      x19, x0
0x0000543c  mov      x0, x2
0x00005440  bl       #0x55d84   ; CALL _objc_retain
0x00005444  mov      x0, x19
0x00005448  bl       #0x59180   ; CALL objc_msgSend$navigationController
0x0000544c  mov      x29, x29
0x00005450  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005454  mov      x20, x0
0x00005458  bl       #0x5df60   ; CALL objc_msgSend$view
0x0000545c  mov      x29, x29
0x00005460  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005464  mov      x22, x0
0x00005468  cbz      x0, #0x547c
0x0000546c  mov      x0, x22
0x00005470  bl       #0x55d84   ; CALL _objc_retain
0x00005474  mov      x19, x22
0x00005478  b        #0x5490
0x0000547c  mov      x0, x19
0x00005480  bl       #0x5df60   ; CALL objc_msgSend$view
0x00005484  mov      x29, x29
0x00005488  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000548c  mov      x19, x0
0x00005490  mov      x0, x22
0x00005494  bl       #0x55d78   ; CALL _objc_release
0x00005498  mov      x0, x20
0x0000549c  bl       #0x55d78   ; CALL _objc_release
0x000054a0  adrp     x8, #0x8e000
0x000054a4  ldr      x0, [x8, #0x940]   ; @CLASS UILabel
0x000054a8  bl       #0x55d60   ; CALL _objc_opt_new
0x000054ac  mov      x20, x0
0x000054b0  mov      x2, x21
0x000054b4  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x000054b8  mov      x0, x21
0x000054bc  bl       #0x55d78   ; CALL _objc_release
0x000054c0  adrp     x8, #0x8e000
0x000054c4  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x000054c8  adrp     x8, #0x74000
0x000054cc  ldr      x8, [x8, #0x250]   ; @GOT _UIFontWeightMedium
0x000054d0  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x000054d4  fmov     d12, #14.00000000
0x000054d8  fmov     d0, #14.00000000
0x000054dc  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x000054e0  mov      x29, x29
0x000054e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000054e8  mov      x21, x0
0x000054ec  mov      x0, x20
0x000054f0  mov      x2, x21
0x000054f4  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x000054f8  mov      x0, x21
0x000054fc  bl       #0x55d78   ; CALL _objc_release
0x00005500  adrp     x22, #0x8e000
0x00005504  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x00005508  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0000550c  mov      x29, x29
0x00005510  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005514  mov      x21, x0
0x00005518  mov      x0, x20
0x0000551c  mov      x2, x21
0x00005520  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00005524  mov      x0, x21
0x00005528  bl       #0x55d78   ; CALL _objc_release
0x0000552c  mov      x0, x20
0x00005530  mov      w2, #1
0x00005534  bl       #0x5c4e0   ; CALL objc_msgSend$setTextAlignment:
0x00005538  mov      x0, x20
0x0000553c  mov      w2, #2
0x00005540  bl       #0x5b820   ; CALL objc_msgSend$setNumberOfLines:
0x00005544  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x00005548  adrp     x8, #0x65000
0x0000554c  ldr      d0, [x8, #0x5f0]
0x00005550  adrp     x8, #0x65000
0x00005554  ldr      d1, [x8, #0x5f8]
0x00005558  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0000555c  mov      x29, x29
0x00005560  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00005564  mov      x21, x0
0x00005568  mov      x0, x20
0x0000556c  mov      x2, x21
0x00005570  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x00005574  mov      x0, x21
0x00005578  bl       #0x55d78   ; CALL _objc_release
0x0000557c  mov      x0, x20
0x00005580  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00005584  mov      x29, x29
0x00005588  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000558c  mov      x21, x0
0x00005590  fmov     d0, #16.00000000
0x00005594  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x00005598  mov      x0, x21
0x0000559c  bl       #0x55d78   ; CALL _objc_release
0x000055a0  mov      x0, x20
0x000055a4  mov      w2, #1
0x000055a8  bl       #0x5a8a0   ; CALL objc_msgSend$setClipsToBounds:
0x000055ac  mov      x0, x19
0x000055b0  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x000055b4  mov      x8, #-0x3fb0000000000000
0x000055b8  fmov     d0, x8
0x000055bc  fadd     d0, d2, d0
0x000055c0  mov      x8, #0x404e000000000000
0x000055c4  fmov     d1, x8
0x000055c8  mov      x0, x20
0x000055cc  bl       #0x5cbc0   ; CALL objc_msgSend$sizeThatFits:
0x000055d0  mov      v8.16b, v0.16b
0x000055d4  mov      v9.16b, v1.16b
0x000055d8  mov      x0, x19
0x000055dc  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x000055e0  fsub     d0, d2, d8
0x000055e4  fmov     d1, #-28.00000000
0x000055e8  fadd     d0, d0, d1
0x000055ec  fmov     d1, #0.50000000
0x000055f0  fmul     d10, d0, d1
0x000055f4  mov      x0, x19
0x000055f8  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x000055fc  mov      v11.16b, v3.16b
0x00005600  mov      x0, x19
0x00005604  bl       #0x5a000   ; CALL objc_msgSend$safeAreaInsets
0x00005608  fsub     d0, d11, d2
0x0000560c  fsub     d0, d0, d9
0x00005610  mov      x8, #-0x3fbc000000000000
0x00005614  fmov     d1, x8
0x00005618  fadd     d1, d0, d1
0x0000561c  fmov     d0, #28.00000000
0x00005620  fadd     d2, d8, d0
0x00005624  fadd     d3, d9, d12
0x00005628  mov      x0, x20
0x0000562c  mov      v0.16b, v10.16b
0x00005630  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00005634  mov      x0, x19
0x00005638  mov      x2, x20
0x0000563c  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00005640  adrp     x8, #0x8e000
0x00005644  ldr      x21, [x8, #0x918]   ; @CLASS UIView
0x00005648  adrp     x22, #0x74000
0x0000564c  ldr      x22, [x22, #0x378]   ; @GOT __NSConcreteStackBlock
0x00005650  str      x22, [sp, #0x28]
0x00005654  adrp     x8, #0x65000
0x00005658  ldr      d8, [x8, #0x600]
0x0000565c  str      d8, [sp, #0x30]
0x00005660  adrp     x8, #0x5000
0x00005664  add      x8, x8, #0x70c
0x00005668  adrp     x9, #0x74000
0x0000566c  add      x9, x9, #0x6e0
0x00005670  stp      x8, x9, [sp, #0x38]
0x00005674  mov      x0, x20
0x00005678  bl       #0x55d84   ; CALL _objc_retain
0x0000567c  str      x20, [sp, #0x48]
0x00005680  str      x22, [sp]
0x00005684  adrp     x8, #0x5000
0x00005688  add      x8, x8, #0x728
0x0000568c  str      d8, [sp, #8]
0x00005690  adrp     x9, #0x74000
0x00005694  add      x9, x9, #0x710
0x00005698  stp      x8, x9, [sp, #0x10]
0x0000569c  str      x20, [sp, #0x20]
0x000056a0  mov      x0, x20
0x000056a4  bl       #0x55d84   ; CALL _objc_retain
0x000056a8  adrp     x8, #0x65000
0x000056ac  ldr      d0, [x8, #0x608]
0x000056b0  adrp     x8, #0x65000
0x000056b4  ldr      d1, [x8, #0x610]
0x000056b8  add      x3, sp, #0x28
0x000056bc  mov      x4, sp
0x000056c0  mov      x0, x21
0x000056c4  mov      x2, #0
0x000056c8  bl       #0x56340   ; CALL objc_msgSend$animateWithDuration:delay:options:animations:completion:
0x000056cc  ldr      x0, [sp, #0x20]
0x000056d0  bl       #0x55d78   ; CALL _objc_release
0x000056d4  ldr      x0, [sp, #0x48]
0x000056d8  bl       #0x55d78   ; CALL _objc_release
0x000056dc  mov      x0, x20
0x000056e0  bl       #0x55d78   ; CALL _objc_release
0x000056e4  mov      x0, x19
0x000056e8  bl       #0x55d78   ; CALL _objc_release
0x000056ec  ldp      x29, x30, [sp, #0xa0]
0x000056f0  ldp      x20, x19, [sp, #0x90]
0x000056f4  ldp      x22, x21, [sp, #0x80]
0x000056f8  ldp      d9, d8, [sp, #0x70]
0x000056fc  ldp      d11, d10, [sp, #0x60]
0x00005700  ldp      d13, d12, [sp, #0x50]
0x00005704  add      sp, sp, #0xb0
0x00005708  ret      
0x0000570c  ldr      x0, [x0, #0x20]
0x00005710  fmov     d0, xzr
0x00005714  b        #0x5a3e0   ; CALL objc_msgSend$setAlpha:

=== -[OMCCardPage reloadSection:]  va=0x5730 size=132 types=v24@0:8q16
0x00005730  stp      x22, x21, [sp, #-0x30]!
0x00005734  stp      x20, x19, [sp, #0x10]
0x00005738  stp      x29, x30, [sp, #0x20]
0x0000573c  add      x29, sp, #0x20
0x00005740  mov      x19, x2
0x00005744  mov      x20, x0
0x00005748  adrp     x8, #0x8e000
0x0000574c  ldrsw    x21, [x8, #0xdc0]
0x00005750  ldr      x0, [x0, x21]
0x00005754  bl       #0x592a0   ; CALL objc_msgSend$numberOfSections
0x00005758  cmp      x19, x0
0x0000575c  b.ge     #0x57a4
0x00005760  ldr      x20, [x20, x21]
0x00005764  adrp     x8, #0x8e000
0x00005768  ldr      x0, [x8, #0x968]   ; @CLASS NSIndexSet
0x0000576c  mov      x2, x19
0x00005770  bl       #0x58340   ; CALL objc_msgSend$indexSetWithIndex:
0x00005774  mov      x29, x29
0x00005778  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0000577c  mov      x19, x0
0x00005780  mov      x0, x20
0x00005784  mov      x2, x19
0x00005788  mov      w3, #5
0x0000578c  bl       #0x59d00   ; CALL objc_msgSend$reloadSections:withRowAnimation:
0x00005790  mov      x0, x19
0x00005794  ldp      x29, x30, [sp, #0x20]
0x00005798  ldp      x20, x19, [sp, #0x10]
0x0000579c  ldp      x22, x21, [sp], #0x30
0x000057a0  b        #0x55d78   ; CALL _objc_release
0x000057a4  ldp      x29, x30, [sp, #0x20]
0x000057a8  ldp      x20, x19, [sp, #0x10]
0x000057ac  ldp      x22, x21, [sp], #0x30
0x000057b0  ret      

=== -[OMCCardPage tableView:numberOfRowsInSection:]  va=0x57b4 size=8 types=q32@0:8@16q24
0x000057b4  mov      x0, #0
0x000057b8  ret      

=== -[OMCCardPage tableView:cellForRowAtIndexPath:]  va=0x57bc size=12 types=@32@0:8@16@24
0x000057bc  adrp     x2, #0x75000
0x000057c0  add      x2, x2, #0x48   ; STR "empty"
0x000057c4  b        #0x56d00   ; CALL objc_msgSend$cellWithId:

=== -[OMCCardPage tableView:willDisplayHeaderView:forSection:]  va=0x57c8 size=12 types=v40@0:8@16@24q32
0x000057c8  mov      x0, x3
0x000057cc  mov      w1, #1
0x000057d0  b        #0x19300   ; CALL _OMCStyleHeaderFooter

=== -[OMCCardPage tableView:willDisplayFooterView:forSection:]  va=0x57d4 size=12 types=v40@0:8@16@24q32
0x000057d4  mov      x0, x3
0x000057d8  mov      w1, #0
0x000057dc  b        #0x19300   ; CALL _OMCStyleHeaderFooter

=== -[OMCCardPage table]  va=0x57e0 size=16 types=@16@0:8
0x000057e0  adrp     x8, #0x8e000
0x000057e4  ldrsw    x8, [x8, #0xdc0]
0x000057e8  ldr      x0, [x0, x8]
0x000057ec  ret      

=== -[OMCCardPage setTable:]  va=0x57f0 size=64 types=v24@0:8@16
0x000057f0  stp      x22, x21, [sp, #-0x30]!
0x000057f4  stp      x20, x19, [sp, #0x10]
0x000057f8  stp      x29, x30, [sp, #0x20]
0x000057fc  add      x29, sp, #0x20
0x00005800  mov      x19, x2
0x00005804  mov      x20, x0
0x00005808  adrp     x8, #0x8e000
0x0000580c  ldrsw    x21, [x8, #0xdc0]
0x00005810  mov      x0, x2
0x00005814  bl       #0x55d84   ; CALL _objc_retain
0x00005818  ldr      x0, [x20, x21]
0x0000581c  str      x19, [x20, x21]
0x00005820  ldp      x29, x30, [sp, #0x20]
0x00005824  ldp      x20, x19, [sp, #0x10]
0x00005828  ldp      x22, x21, [sp], #0x30
0x0000582c  b        #0x55d78   ; CALL _objc_release

=== -[OMCCardPage .cxx_destruct]  va=0x5830 size=20 types=v16@0:8
0x00005830  adrp     x8, #0x8e000
0x00005834  ldrsw    x8, [x8, #0xdc0]
0x00005838  add      x0, x0, x8
0x0000583c  mov      x1, #0
0x00005840  b        #0x55dcc   ; CALL _objc_storeStrong
