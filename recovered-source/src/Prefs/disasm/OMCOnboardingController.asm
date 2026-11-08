=== +[OMCOnboardingController shouldShow]  va=0x113ac size=108 types=B16@0:8
0x000113ac  stp      x20, x19, [sp, #-0x20]!
0x000113b0  stp      x29, x30, [sp, #0x10]
0x000113b4  add      x29, sp, #0x10
0x000113b8  adrp     x0, #0x75000
0x000113bc  add      x0, x0, #0x28   ; STR "com.anlai.omnicar"
0x000113c0  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x000113c4  adrp     x0, #0x78000
0x000113c8  add      x0, x0, #0x208   ; STR "onboardingDone"
0x000113cc  bl       #0x113fc
0x000113d0  mov      x29, x29
0x000113d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000113d8  mov      x19, x0
0x000113dc  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x000113e0  mov      x20, x0
0x000113e4  mov      x0, x19
0x000113e8  bl       #0x55d78   ; CALL _objc_release
0x000113ec  eor      w0, w20, #1
0x000113f0  ldp      x29, x30, [sp, #0x10]
0x000113f4  ldp      x20, x19, [sp], #0x20
0x000113f8  ret      
0x000113fc  stp      x29, x30, [sp, #-0x10]!
0x00011400  mov      x29, sp
0x00011404  adrp     x1, #0x75000
0x00011408  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x0001140c  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x00011410  ldp      x29, x30, [sp], #0x10
0x00011414  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== +[OMCOnboardingController guideNavigationControllerWithCompletion:]  va=0x11418 size=220 types=@24@0:8@?16
0x00011418  stp      x22, x21, [sp, #-0x30]!
0x0001141c  stp      x20, x19, [sp, #0x10]
0x00011420  stp      x29, x30, [sp, #0x20]
0x00011424  add      x29, sp, #0x20
0x00011428  mov      x20, x2
0x0001142c  adrp     x8, #0x8e000
0x00011430  ldr      x19, [x8, #0xa20]   ; @CLASS OMCOnboardingController
0x00011434  mov      x0, x2
0x00011438  bl       #0x55d84   ; CALL _objc_retain
0x0001143c  mov      x0, x19
0x00011440  bl       #0x55d60   ; CALL _objc_opt_new
0x00011444  mov      x19, x0
0x00011448  mov      x2, x20
0x0001144c  bl       #0x5a940   ; CALL objc_msgSend$setCompletion:
0x00011450  mov      x0, x20
0x00011454  bl       #0x55d78   ; CALL _objc_release
0x00011458  adrp     x8, #0x8e000
0x0001145c  ldr      x0, [x8, #0xa28]   ; @CLASS UINavigationController
0x00011460  bl       #0x55c7c   ; CALL _objc_alloc
0x00011464  mov      x2, x19
0x00011468  bl       #0x58520   ; CALL objc_msgSend$initWithRootViewController:
0x0001146c  mov      x20, x0
0x00011470  mov      w2, #1
0x00011474  bl       #0x5b6c0   ; CALL objc_msgSend$setModalPresentationStyle:
0x00011478  bl       #0x17e8c   ; CALL _OMCAccentColor
0x0001147c  mov      x29, x29
0x00011480  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011484  mov      x21, x0
0x00011488  mov      x0, x20
0x0001148c  bl       #0x59160   ; CALL objc_msgSend$navigationBar
0x00011490  mov      x29, x29
0x00011494  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011498  mov      x22, x0
0x0001149c  mov      x2, x21
0x000114a0  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x000114a4  mov      x0, x22
0x000114a8  bl       #0x55d78   ; CALL _objc_release
0x000114ac  mov      x0, x21
0x000114b0  bl       #0x55d78   ; CALL _objc_release
0x000114b4  mov      x0, x20
0x000114b8  bl       #0x599a0   ; CALL objc_msgSend$presentationController
0x000114bc  mov      x29, x29
0x000114c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000114c4  mov      x21, x0
0x000114c8  mov      x2, x19
0x000114cc  bl       #0x5aca0   ; CALL objc_msgSend$setDelegate:
0x000114d0  mov      x0, x21
0x000114d4  bl       #0x55d78   ; CALL _objc_release
0x000114d8  mov      x0, x19
0x000114dc  bl       #0x55d78   ; CALL _objc_release
0x000114e0  mov      x0, x20
0x000114e4  ldp      x29, x30, [sp, #0x20]
0x000114e8  ldp      x20, x19, [sp, #0x10]
0x000114ec  ldp      x22, x21, [sp], #0x30
0x000114f0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCOnboardingController viewDidLoad]  va=0x114f4 size=3484 types=v16@0:8
0x000114f4  stp      x28, x27, [sp, #-0x60]!
0x000114f8  stp      x26, x25, [sp, #0x10]
0x000114fc  stp      x24, x23, [sp, #0x20]
0x00011500  stp      x22, x21, [sp, #0x30]
0x00011504  stp      x20, x19, [sp, #0x40]
0x00011508  stp      x29, x30, [sp, #0x50]
0x0001150c  add      x29, sp, #0x50
0x00011510  sub      sp, sp, #0x320
0x00011514  mov      x19, x0
0x00011518  adrp     x8, #0x74000
0x0001151c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00011520  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00011524  stur     x8, [x29, #-0x60]
0x00011528  adrp     x8, #0x8e000
0x0001152c  ldr      x8, [x8, #0xd20]   ; @SUPER OMCOnboardingController
0x00011530  stp      x0, x8, [sp, #0x1e8]
0x00011534  adrp     x8, #0x8b000
0x00011538  ldr      x1, [x8, #0xda0]   ; @SEL "viewDidLoad"
0x0001153c  add      x0, sp, #0x1e8
0x00011540  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00011544  bl       #0x17a44   ; CALL _OMCLoadStrings
0x00011548  bl       #0x17fe4   ; CALL _OMCBackgroundColor
0x0001154c  mov      x29, x29
0x00011550  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011554  mov      x20, x0
0x00011558  mov      x0, x19
0x0001155c  bl       #0x5df60   ; CALL objc_msgSend$view
0x00011560  mov      x29, x29
0x00011564  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011568  mov      x21, x0
0x0001156c  mov      x2, x20
0x00011570  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x00011574  mov      x0, x21
0x00011578  bl       #0x55d78   ; CALL _objc_release
0x0001157c  mov      x0, x20
0x00011580  bl       #0x55d78   ; CALL _objc_release
0x00011584  bl       #0x17e8c   ; CALL _OMCAccentColor
0x00011588  mov      x29, x29
0x0001158c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011590  mov      x20, x0
0x00011594  mov      x0, x19
0x00011598  bl       #0x5df60   ; CALL objc_msgSend$view
0x0001159c  mov      x29, x29
0x000115a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000115a4  mov      x21, x0
0x000115a8  mov      x2, x20
0x000115ac  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x000115b0  mov      x0, x21
0x000115b4  bl       #0x55d78   ; CALL _objc_release
0x000115b8  mov      x0, x20
0x000115bc  bl       #0x55d78   ; CALL _objc_release
0x000115c0  mov      x0, x19
0x000115c4  bl       #0x5e120   ; CALL objc_msgSend$welcomePage
0x000115c8  mov      x29, x29
0x000115cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000115d0  mov      x21, x0
0x000115d4  stur     x0, [x29, #-0x80]
0x000115d8  mov      x0, x19
0x000115dc  bl       #0x5cea0   ; CALL objc_msgSend$splitPage
0x000115e0  mov      x29, x29
0x000115e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000115e8  mov      x22, x0
0x000115ec  stur     x0, [x29, #-0x78]
0x000115f0  mov      x0, x19
0x000115f4  bl       #0x5ce40   ; CALL objc_msgSend$speedPage
0x000115f8  mov      x29, x29
0x000115fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011600  mov      x23, x0
0x00011604  stur     x0, [x29, #-0x70]
0x00011608  mov      x0, x19
0x0001160c  bl       #0x5db20   ; CALL objc_msgSend$tipsPage
0x00011610  mov      x29, x29
0x00011614  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011618  mov      x24, x0
0x0001161c  stur     x0, [x29, #-0x68]
0x00011620  adrp     x8, #0x8e000
0x00011624  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00011628  sub      x2, x29, #0x80
0x0001162c  mov      w3, #4
0x00011630  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00011634  mov      x29, x29
0x00011638  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001163c  mov      x20, x0
0x00011640  mov      x0, x24
0x00011644  bl       #0x55d78   ; CALL _objc_release
0x00011648  mov      x0, x23
0x0001164c  bl       #0x55d78   ; CALL _objc_release
0x00011650  mov      x0, x22
0x00011654  bl       #0x55d78   ; CALL _objc_release
0x00011658  mov      x0, x21
0x0001165c  bl       #0x55d78   ; CALL _objc_release
0x00011660  mov      x0, x20
0x00011664  bl       #0x573c0   ; CALL objc_msgSend$count
0x00011668  mov      x2, x0
0x0001166c  mov      x0, x19
0x00011670  bl       #0x5bac0   ; CALL objc_msgSend$setPageCount:
0x00011674  adrp     x8, #0x8e000
0x00011678  ldr      x0, [x8, #0xa30]   ; @CLASS UIScrollView
0x0001167c  bl       #0x55d60   ; CALL _objc_opt_new
0x00011680  adrp     x8, #0x8e000
0x00011684  ldrsw    x26, [x8, #0xdd0]
0x00011688  ldr      x8, [x19, x26]
0x0001168c  str      x0, [x19, x26]
0x00011690  mov      x0, x8
0x00011694  bl       #0x55d78   ; CALL _objc_release
0x00011698  ldr      x0, [x19, x26]
0x0001169c  mov      w2, #0
0x000116a0  bl       #0x5c6c0   ; CALL objc_msgSend$setTranslatesAutoresizingMaskIntoConstraints:
0x000116a4  ldr      x0, [x19, x26]
0x000116a8  mov      w2, #1
0x000116ac  bl       #0x5bb00   ; CALL objc_msgSend$setPagingEnabled:
0x000116b0  ldr      x0, [x19, x26]
0x000116b4  mov      w2, #0
0x000116b8  bl       #0x5c140   ; CALL objc_msgSend$setShowsHorizontalScrollIndicator:
0x000116bc  ldr      x0, [x19, x26]
0x000116c0  mov      w2, #0
0x000116c4  bl       #0x5c160   ; CALL objc_msgSend$setShowsVerticalScrollIndicator:
0x000116c8  ldr      x0, [x19, x26]
0x000116cc  mov      w2, #2
0x000116d0  bl       #0x5aa00   ; CALL objc_msgSend$setContentInsetAdjustmentBehavior:
0x000116d4  ldr      x0, [x19, x26]
0x000116d8  mov      x2, x19
0x000116dc  bl       #0x5aca0   ; CALL objc_msgSend$setDelegate:
0x000116e0  mov      x0, x19
0x000116e4  bl       #0x5df60   ; CALL objc_msgSend$view
0x000116e8  mov      x29, x29
0x000116ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000116f0  mov      x21, x0
0x000116f4  ldr      x2, [x19, x26]
0x000116f8  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x000116fc  mov      x0, x21
0x00011700  bl       #0x55d78   ; CALL _objc_release
0x00011704  adrp     x8, #0x8e000
0x00011708  ldr      x0, [x8, #0xa38]   ; @CLASS UIStackView
0x0001170c  bl       #0x55c7c   ; CALL _objc_alloc
0x00011710  mov      x2, x20
0x00011714  bl       #0x583a0   ; CALL objc_msgSend$initWithArrangedSubviews:
0x00011718  mov      x21, x0
0x0001171c  mov      w2, #0
0x00011720  bl       #0x5c6c0   ; CALL objc_msgSend$setTranslatesAutoresizingMaskIntoConstraints:
0x00011724  mov      x0, x21
0x00011728  mov      x2, #0
0x0001172c  bl       #0x5a540   ; CALL objc_msgSend$setAxis:
0x00011730  mov      x0, x21
0x00011734  mov      w2, #1
0x00011738  bl       #0x5ad20   ; CALL objc_msgSend$setDistribution:
0x0001173c  ldr      x0, [x19, x26]
0x00011740  str      x21, [sp, #0x198]
0x00011744  mov      x2, x21
0x00011748  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0001174c  movi     v0.16b, #0
0x00011750  stp      q0, q0, [sp, #0x1c0]
0x00011754  stp      q0, q0, [sp, #0x1a0]
0x00011758  mov      x0, x20
0x0001175c  bl       #0x55d84   ; CALL _objc_retain
0x00011760  add      x2, sp, #0x1a0
0x00011764  sub      x3, x29, #0x100
0x00011768  mov      x0, x20
0x0001176c  mov      w4, #0x10
0x00011770  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00011774  cbz      x0, #0x11844
0x00011778  mov      x21, x0
0x0001177c  ldr      x8, [sp, #0x1b0]
0x00011780  ldr      x27, [x8]   ; @SEL "whatsNewNavigationController"
0x00011784  mov      x28, #0
0x00011788  ldr      x8, [sp, #0x1b0]
0x0001178c  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00011790  cmp      x8, x27
0x00011794  b.eq     #0x117a0
0x00011798  mov      x0, x20
0x0001179c  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x000117a0  ldr      x8, [sp, #0x1a8]
0x000117a4  ldr      x0, [x8, x28, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x000117a8  bl       #0x5e1c0   ; CALL objc_msgSend$widthAnchor
0x000117ac  mov      x29, x29
0x000117b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000117b4  mov      x22, x0
0x000117b8  ldr      x0, [x19, x26]
0x000117bc  bl       #0x57d20   ; CALL objc_msgSend$frameLayoutGuide
0x000117c0  mov      x29, x29
0x000117c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000117c8  mov      x23, x0
0x000117cc  bl       #0x5e1c0   ; CALL objc_msgSend$widthAnchor
0x000117d0  mov      x29, x29
0x000117d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000117d8  mov      x24, x0
0x000117dc  mov      x0, x22
0x000117e0  mov      x2, x24
0x000117e4  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x000117e8  mov      x29, x29
0x000117ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000117f0  mov      x25, x0
0x000117f4  mov      w2, #1
0x000117f8  bl       #0x5a2e0   ; CALL objc_msgSend$setActive:
0x000117fc  mov      x0, x25
0x00011800  bl       #0x55d78   ; CALL _objc_release
0x00011804  mov      x0, x24
0x00011808  bl       #0x55d78   ; CALL _objc_release
0x0001180c  mov      x0, x23
0x00011810  bl       #0x55d78   ; CALL _objc_release
0x00011814  mov      x0, x22
0x00011818  bl       #0x55d78   ; CALL _objc_release
0x0001181c  add      x28, x28, #1
0x00011820  cmp      x21, x28
0x00011824  b.ne     #0x11788
0x00011828  add      x2, sp, #0x1a0
0x0001182c  sub      x3, x29, #0x100
0x00011830  mov      x0, x20
0x00011834  mov      w4, #0x10
0x00011838  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001183c  mov      x21, x0
0x00011840  cbnz     x0, #0x11784
0x00011844  mov      x0, x20
0x00011848  bl       #0x55d78   ; CALL _objc_release
0x0001184c  adrp     x8, #0x8e000
0x00011850  ldr      x0, [x8, #0xa40]   ; @CLASS UIPageControl
0x00011854  bl       #0x55d60   ; CALL _objc_opt_new
0x00011858  adrp     x8, #0x8e000
0x0001185c  ldrsw    x24, [x8, #0xdd4]
0x00011860  ldr      x8, [x19, x24]
0x00011864  str      x0, [x19, x24]
0x00011868  mov      x0, x8
0x0001186c  bl       #0x55d78   ; CALL _objc_release
0x00011870  ldr      x0, [x19, x24]
0x00011874  mov      w2, #0
0x00011878  bl       #0x5c6c0   ; CALL objc_msgSend$setTranslatesAutoresizingMaskIntoConstraints:
0x0001187c  mov      x0, x19
0x00011880  bl       #0x59580   ; CALL objc_msgSend$pageCount
0x00011884  mov      x2, x0
0x00011888  ldr      x0, [x19, x24]
0x0001188c  bl       #0x5b840   ; CALL objc_msgSend$setNumberOfPages:
0x00011890  bl       #0x17e8c   ; CALL _OMCAccentColor
0x00011894  mov      x29, x29
0x00011898  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001189c  mov      x21, x0
0x000118a0  ldr      x0, [x19, x24]
0x000118a4  mov      x2, x21
0x000118a8  bl       #0x5abc0   ; CALL objc_msgSend$setCurrentPageIndicatorTintColor:
0x000118ac  mov      x0, x21
0x000118b0  bl       #0x55d78   ; CALL _objc_release
0x000118b4  adrp     x23, #0x8e000
0x000118b8  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x000118bc  bl       #0x5d960   ; CALL objc_msgSend$tertiaryLabelColor
0x000118c0  mov      x29, x29
0x000118c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000118c8  mov      x21, x0
0x000118cc  ldr      x0, [x19, x24]
0x000118d0  mov      x2, x21
0x000118d4  bl       #0x5bae0   ; CALL objc_msgSend$setPageIndicatorTintColor:
0x000118d8  mov      x0, x21
0x000118dc  bl       #0x55d78   ; CALL _objc_release
0x000118e0  ldr      x0, [x19, x24]
0x000118e4  adrp     x8, #0x8b000
0x000118e8  ldr      x3, [x8, #0xdf8]   ; @SEL "dotsChanged:"
0x000118ec  mov      x2, x19
0x000118f0  mov      w4, #0x1000
0x000118f4  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x000118f8  mov      x0, x19
0x000118fc  bl       #0x5df60   ; CALL objc_msgSend$view
0x00011900  mov      x29, x29
0x00011904  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011908  mov      x21, x0
0x0001190c  ldr      x2, [x19, x24]
0x00011910  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00011914  mov      x0, x21
0x00011918  bl       #0x55d78   ; CALL _objc_release
0x0001191c  adrp     x27, #0x8e000
0x00011920  ldr      x0, [x27, #0xa48]   ; @CLASS UIButtonConfiguration
0x00011924  bl       #0x59740   ; CALL objc_msgSend$plainButtonConfiguration
0x00011928  mov      x29, x29
0x0001192c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011930  mov      x28, x0
0x00011934  adrp     x0, #0x78000
0x00011938  add      x0, x0, #0x228   ; STR "ONB_SKIP"
0x0001193c  bl       #0x17e20   ; CALL _L
0x00011940  mov      x29, x29
0x00011944  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011948  mov      x21, x0
0x0001194c  mov      x0, x28
0x00011950  mov      x2, x21
0x00011954  bl       #0x5c5e0   ; CALL objc_msgSend$setTitle:
0x00011958  mov      x0, x21
0x0001195c  bl       #0x55d78   ; CALL _objc_release
0x00011960  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x00011964  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x00011968  mov      x29, x29
0x0001196c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011970  mov      x21, x0
0x00011974  mov      x0, x28
0x00011978  str      x28, [sp, #0x190]
0x0001197c  mov      x2, x21
0x00011980  bl       #0x5a600   ; CALL objc_msgSend$setBaseForegroundColor:
0x00011984  mov      x0, x21
0x00011988  bl       #0x55d78   ; CALL _objc_release
0x0001198c  adrp     x25, #0x8e000
0x00011990  ldr      x0, [x25, #0xa50]   ; @CLASS UIButton
0x00011994  mov      w2, #1
0x00011998  bl       #0x56b80   ; CALL objc_msgSend$buttonWithType:
0x0001199c  mov      x29, x29
0x000119a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000119a4  adrp     x8, #0x8e000
0x000119a8  ldrsw    x22, [x8, #0xdd8]
0x000119ac  ldr      x8, [x19, x22]
0x000119b0  str      x0, [x19, x22]
0x000119b4  mov      x0, x8
0x000119b8  bl       #0x55d78   ; CALL _objc_release
0x000119bc  ldr      x0, [x19, x22]
0x000119c0  mov      w2, #0
0x000119c4  bl       #0x5c6c0   ; CALL objc_msgSend$setTranslatesAutoresizingMaskIntoConstraints:
0x000119c8  ldr      x0, [x19, x22]
0x000119cc  mov      x2, x28
0x000119d0  bl       #0x5a960   ; CALL objc_msgSend$setConfiguration:
0x000119d4  ldr      x0, [x19, x22]
0x000119d8  adrp     x8, #0x8c000
0x000119dc  ldr      x3, [x8, #0x6b0]   ; @SEL "finish"
0x000119e0  mov      x2, x19
0x000119e4  mov      w4, #0x40
0x000119e8  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x000119ec  mov      x0, x19
0x000119f0  bl       #0x5df60   ; CALL objc_msgSend$view
0x000119f4  mov      x29, x29
0x000119f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000119fc  mov      x21, x0
0x00011a00  ldr      x2, [x19, x22]
0x00011a04  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00011a08  mov      x0, x21
0x00011a0c  bl       #0x55d78   ; CALL _objc_release
0x00011a10  ldr      x0, [x27, #0xa48]   ; @CLASS UIButtonConfiguration
0x00011a14  bl       #0x57be0   ; CALL objc_msgSend$filledButtonConfiguration
0x00011a18  mov      x29, x29
0x00011a1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011a20  mov      x27, x0
0x00011a24  adrp     x0, #0x78000
0x00011a28  add      x0, x0, #0x248   ; STR "ONB_NEXT"
0x00011a2c  bl       #0x17e20   ; CALL _L
0x00011a30  mov      x29, x29
0x00011a34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011a38  mov      x21, x0
0x00011a3c  mov      x0, x27
0x00011a40  mov      x2, x21
0x00011a44  bl       #0x5c5e0   ; CALL objc_msgSend$setTitle:
0x00011a48  mov      x0, x21
0x00011a4c  bl       #0x55d78   ; CALL _objc_release
0x00011a50  mov      x0, x27
0x00011a54  mov      w2, #4
0x00011a58  bl       #0x5ab80   ; CALL objc_msgSend$setCornerStyle:
0x00011a5c  bl       #0x17e8c   ; CALL _OMCAccentColor
0x00011a60  mov      x29, x29
0x00011a64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011a68  mov      x21, x0
0x00011a6c  mov      x0, x27
0x00011a70  mov      x2, x21
0x00011a74  bl       #0x5a5e0   ; CALL objc_msgSend$setBaseBackgroundColor:
0x00011a78  mov      x0, x21
0x00011a7c  bl       #0x55d78   ; CALL _objc_release
0x00011a80  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x00011a84  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x00011a88  mov      x29, x29
0x00011a8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011a90  mov      x21, x0
0x00011a94  mov      x0, x27
0x00011a98  mov      x2, x21
0x00011a9c  bl       #0x5a600   ; CALL objc_msgSend$setBaseForegroundColor:
0x00011aa0  mov      x0, x21
0x00011aa4  bl       #0x55d78   ; CALL _objc_release
0x00011aa8  fmov     d0, #10.00000000
0x00011aac  fmov     d1, #24.00000000
0x00011ab0  fmov     d2, #10.00000000
0x00011ab4  fmov     d3, #24.00000000
0x00011ab8  mov      x0, x27
0x00011abc  mov      x21, x27
0x00011ac0  str      x27, [sp, #0x188]
0x00011ac4  bl       #0x5aa20   ; CALL objc_msgSend$setContentInsets:
0x00011ac8  ldr      x0, [x25, #0xa50]   ; @CLASS UIButton
0x00011acc  mov      w2, #1
0x00011ad0  bl       #0x56b80   ; CALL objc_msgSend$buttonWithType:
0x00011ad4  mov      x29, x29
0x00011ad8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011adc  adrp     x8, #0x8e000
0x00011ae0  ldrsw    x27, [x8, #0xddc]
0x00011ae4  ldr      x8, [x19, x27]
0x00011ae8  str      x0, [x19, x27]
0x00011aec  mov      x0, x8
0x00011af0  bl       #0x55d78   ; CALL _objc_release
0x00011af4  ldr      x0, [x19, x27]
0x00011af8  mov      w2, #0
0x00011afc  bl       #0x5c6c0   ; CALL objc_msgSend$setTranslatesAutoresizingMaskIntoConstraints:
0x00011b00  ldr      x0, [x19, x27]
0x00011b04  mov      x2, x21
0x00011b08  bl       #0x5a960   ; CALL objc_msgSend$setConfiguration:
0x00011b0c  ldr      x0, [x19, x27]
0x00011b10  adrp     x8, #0x8b000
0x00011b14  ldr      x3, [x8, #0xe00]   ; @SEL "nextTapped"
0x00011b18  mov      x2, x19
0x00011b1c  mov      w4, #0x40
0x00011b20  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x00011b24  mov      x0, x19
0x00011b28  bl       #0x5df60   ; CALL objc_msgSend$view
0x00011b2c  mov      x29, x29
0x00011b30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011b34  mov      x21, x0
0x00011b38  ldr      x2, [x19, x27]
0x00011b3c  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00011b40  mov      x0, x21
0x00011b44  bl       #0x55d78   ; CALL _objc_release
0x00011b48  mov      x0, x19
0x00011b4c  bl       #0x5df60   ; CALL objc_msgSend$view
0x00011b50  mov      x29, x29
0x00011b54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011b58  mov      x21, x0
0x00011b5c  bl       #0x5a020   ; CALL objc_msgSend$safeAreaLayoutGuide
0x00011b60  mov      x29, x29
0x00011b64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011b68  mov      x23, x0
0x00011b6c  mov      x0, x21
0x00011b70  bl       #0x55d78   ; CALL _objc_release
0x00011b74  adrp     x8, #0x8e000
0x00011b78  ldr      x8, [x8, #0xa58]   ; @CLASS NSLayoutConstraint
0x00011b7c  str      x8, [sp, #0xd0]
0x00011b80  ldr      x0, [x19, x26]
0x00011b84  bl       #0x5dc00   ; CALL objc_msgSend$topAnchor
0x00011b88  mov      x29, x29
0x00011b8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011b90  mov      x21, x0
0x00011b94  str      x0, [sp, #0x180]
0x00011b98  mov      x0, x23
0x00011b9c  bl       #0x5dc00   ; CALL objc_msgSend$topAnchor
0x00011ba0  mov      x29, x29
0x00011ba4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011ba8  mov      x2, x0
0x00011bac  str      x0, [sp, #0x178]
0x00011bb0  mov      x0, x21
0x00011bb4  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x00011bb8  mov      x29, x29
0x00011bbc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011bc0  str      x0, [sp, #0x170]
0x00011bc4  str      x0, [sp, #0x1f8]
0x00011bc8  ldr      x0, [x19, x26]
0x00011bcc  bl       #0x58be0   ; CALL objc_msgSend$leadingAnchor
0x00011bd0  mov      x29, x29
0x00011bd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011bd8  mov      x21, x0
0x00011bdc  str      x0, [sp, #0x160]
0x00011be0  mov      x0, x19
0x00011be4  bl       #0x5df60   ; CALL objc_msgSend$view
0x00011be8  mov      x29, x29
0x00011bec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011bf0  str      x0, [sp, #0x168]
0x00011bf4  bl       #0x58be0   ; CALL objc_msgSend$leadingAnchor
0x00011bf8  mov      x29, x29
0x00011bfc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011c00  mov      x2, x0
0x00011c04  str      x0, [sp, #0x158]
0x00011c08  mov      x0, x21
0x00011c0c  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x00011c10  mov      x29, x29
0x00011c14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011c18  str      x0, [sp, #0x150]
0x00011c1c  str      x0, [sp, #0x200]
0x00011c20  ldr      x0, [x19, x26]
0x00011c24  bl       #0x5dc40   ; CALL objc_msgSend$trailingAnchor
0x00011c28  mov      x29, x29
0x00011c2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011c30  mov      x21, x0
0x00011c34  str      x0, [sp, #0x140]
0x00011c38  mov      x0, x19
0x00011c3c  bl       #0x5df60   ; CALL objc_msgSend$view
0x00011c40  mov      x29, x29
0x00011c44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011c48  str      x0, [sp, #0x148]
0x00011c4c  bl       #0x5dc40   ; CALL objc_msgSend$trailingAnchor
0x00011c50  mov      x29, x29
0x00011c54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011c58  mov      x2, x0
0x00011c5c  str      x0, [sp, #0x138]
0x00011c60  mov      x0, x21
0x00011c64  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x00011c68  mov      x29, x29
0x00011c6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011c70  str      x0, [sp, #0x130]
0x00011c74  str      x0, [sp, #0x208]
0x00011c78  ldr      x0, [x19, x26]
0x00011c7c  bl       #0x56a00   ; CALL objc_msgSend$bottomAnchor
0x00011c80  mov      x29, x29
0x00011c84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011c88  mov      x21, x0
0x00011c8c  str      x0, [sp, #0x128]
0x00011c90  ldr      x0, [x19, x27]
0x00011c94  bl       #0x5dc00   ; CALL objc_msgSend$topAnchor
0x00011c98  mov      x29, x29
0x00011c9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011ca0  mov      x2, x0
0x00011ca4  str      x0, [sp, #0x120]
0x00011ca8  fmov     d0, #-12.00000000
0x00011cac  mov      x0, x21
0x00011cb0  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x00011cb4  mov      x29, x29
0x00011cb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011cbc  str      x0, [sp, #0x118]
0x00011cc0  str      x0, [sp, #0x210]
0x00011cc4  ldr      x21, [sp, #0x198]
0x00011cc8  mov      x0, x21
0x00011ccc  bl       #0x5dc00   ; CALL objc_msgSend$topAnchor
0x00011cd0  mov      x29, x29
0x00011cd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011cd8  mov      x25, x0
0x00011cdc  str      x0, [sp, #0x108]
0x00011ce0  ldr      x0, [x19, x26]
0x00011ce4  bl       #0x57200   ; CALL objc_msgSend$contentLayoutGuide
0x00011ce8  mov      x29, x29
0x00011cec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011cf0  str      x0, [sp, #0x110]
0x00011cf4  bl       #0x5dc00   ; CALL objc_msgSend$topAnchor
0x00011cf8  mov      x29, x29
0x00011cfc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011d00  mov      x2, x0
0x00011d04  str      x0, [sp, #0x100]
0x00011d08  mov      x0, x25
0x00011d0c  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x00011d10  mov      x29, x29
0x00011d14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011d18  str      x0, [sp, #0xf8]
0x00011d1c  str      x0, [sp, #0x218]
0x00011d20  mov      x0, x21
0x00011d24  bl       #0x56a00   ; CALL objc_msgSend$bottomAnchor
0x00011d28  mov      x29, x29
0x00011d2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011d30  mov      x25, x0
0x00011d34  str      x0, [sp, #0xe8]
0x00011d38  ldr      x0, [x19, x26]
0x00011d3c  bl       #0x57200   ; CALL objc_msgSend$contentLayoutGuide
0x00011d40  mov      x29, x29
0x00011d44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011d48  str      x0, [sp, #0xf0]
0x00011d4c  bl       #0x56a00   ; CALL objc_msgSend$bottomAnchor
0x00011d50  mov      x29, x29
0x00011d54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011d58  mov      x2, x0
0x00011d5c  str      x0, [sp, #0xe0]
0x00011d60  mov      x0, x25
0x00011d64  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x00011d68  mov      x29, x29
0x00011d6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011d70  str      x0, [sp, #0xd8]
0x00011d74  str      x0, [sp, #0x220]
0x00011d78  mov      x0, x21
0x00011d7c  bl       #0x58be0   ; CALL objc_msgSend$leadingAnchor
0x00011d80  mov      x29, x29
0x00011d84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011d88  mov      x25, x0
0x00011d8c  str      x0, [sp, #0xc0]
0x00011d90  ldr      x0, [x19, x26]
0x00011d94  bl       #0x57200   ; CALL objc_msgSend$contentLayoutGuide
0x00011d98  mov      x29, x29
0x00011d9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011da0  str      x0, [sp, #0xc8]
0x00011da4  bl       #0x58be0   ; CALL objc_msgSend$leadingAnchor
0x00011da8  mov      x29, x29
0x00011dac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011db0  mov      x2, x0
0x00011db4  str      x0, [sp, #0xb0]
0x00011db8  mov      x0, x25
0x00011dbc  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x00011dc0  mov      x29, x29
0x00011dc4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011dc8  str      x0, [sp, #0xa8]
0x00011dcc  str      x0, [sp, #0x228]
0x00011dd0  mov      x0, x21
0x00011dd4  bl       #0x5dc40   ; CALL objc_msgSend$trailingAnchor
0x00011dd8  mov      x29, x29
0x00011ddc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011de0  mov      x25, x0
0x00011de4  str      x0, [sp, #0x98]
0x00011de8  ldr      x0, [x19, x26]
0x00011dec  bl       #0x57200   ; CALL objc_msgSend$contentLayoutGuide
0x00011df0  mov      x29, x29
0x00011df4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011df8  str      x0, [sp, #0xa0]
0x00011dfc  bl       #0x5dc40   ; CALL objc_msgSend$trailingAnchor
0x00011e00  mov      x29, x29
0x00011e04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011e08  mov      x2, x0
0x00011e0c  str      x0, [sp, #0x90]
0x00011e10  mov      x0, x25
0x00011e14  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x00011e18  mov      x29, x29
0x00011e1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011e20  str      x0, [sp, #0x88]
0x00011e24  str      x0, [sp, #0x230]
0x00011e28  mov      x0, x21
0x00011e2c  bl       #0x57f40   ; CALL objc_msgSend$heightAnchor
0x00011e30  mov      x29, x29
0x00011e34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011e38  mov      x21, x0
0x00011e3c  str      x0, [sp, #0x78]
0x00011e40  ldr      x0, [x19, x26]
0x00011e44  bl       #0x57d20   ; CALL objc_msgSend$frameLayoutGuide
0x00011e48  mov      x29, x29
0x00011e4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011e50  str      x0, [sp, #0x80]
0x00011e54  bl       #0x57f40   ; CALL objc_msgSend$heightAnchor
0x00011e58  mov      x29, x29
0x00011e5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011e60  mov      x2, x0
0x00011e64  str      x0, [sp, #0x70]
0x00011e68  mov      x0, x21
0x00011e6c  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x00011e70  mov      x29, x29
0x00011e74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011e78  str      x0, [sp, #0x68]
0x00011e7c  str      x0, [sp, #0x238]
0x00011e80  ldr      x0, [x19, x27]
0x00011e84  bl       #0x5dc40   ; CALL objc_msgSend$trailingAnchor
0x00011e88  mov      x29, x29
0x00011e8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011e90  mov      x21, x0
0x00011e94  str      x0, [sp, #0x60]
0x00011e98  mov      x0, x23
0x00011e9c  bl       #0x5dc40   ; CALL objc_msgSend$trailingAnchor
0x00011ea0  mov      x29, x29
0x00011ea4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011ea8  mov      x2, x0
0x00011eac  str      x0, [sp, #0x58]
0x00011eb0  fmov     d0, #-20.00000000
0x00011eb4  mov      x0, x21
0x00011eb8  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x00011ebc  mov      x29, x29
0x00011ec0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011ec4  str      x0, [sp, #0x50]
0x00011ec8  str      x0, [sp, #0x240]
0x00011ecc  ldr      x0, [x19, x27]
0x00011ed0  bl       #0x56a00   ; CALL objc_msgSend$bottomAnchor
0x00011ed4  mov      x29, x29
0x00011ed8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011edc  mov      x21, x0
0x00011ee0  str      x0, [sp, #0x48]
0x00011ee4  mov      x0, x23
0x00011ee8  str      x23, [sp, #0xb8]
0x00011eec  bl       #0x56a00   ; CALL objc_msgSend$bottomAnchor
0x00011ef0  mov      x29, x29
0x00011ef4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011ef8  mov      x2, x0
0x00011efc  str      x0, [sp, #0x40]
0x00011f00  fmov     d0, #-16.00000000
0x00011f04  mov      x0, x21
0x00011f08  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x00011f0c  mov      x29, x29
0x00011f10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011f14  str      x0, [sp, #0x38]
0x00011f18  str      x0, [sp, #0x248]
0x00011f1c  ldr      x0, [x19, x22]
0x00011f20  bl       #0x58be0   ; CALL objc_msgSend$leadingAnchor
0x00011f24  mov      x29, x29
0x00011f28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011f2c  mov      x21, x0
0x00011f30  str      x0, [sp, #0x30]
0x00011f34  mov      x0, x23
0x00011f38  bl       #0x58be0   ; CALL objc_msgSend$leadingAnchor
0x00011f3c  mov      x29, x29
0x00011f40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011f44  mov      x2, x0
0x00011f48  str      x0, [sp, #0x28]
0x00011f4c  fmov     d0, #12.00000000
0x00011f50  mov      x0, x21
0x00011f54  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x00011f58  mov      x29, x29
0x00011f5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011f60  str      x0, [sp, #0x20]
0x00011f64  str      x0, [sp, #0x250]
0x00011f68  ldr      x0, [x19, x22]
0x00011f6c  bl       #0x56d80   ; CALL objc_msgSend$centerYAnchor
0x00011f70  mov      x29, x29
0x00011f74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011f78  mov      x21, x0
0x00011f7c  str      x0, [sp, #0x18]
0x00011f80  ldr      x0, [x19, x27]
0x00011f84  bl       #0x56d80   ; CALL objc_msgSend$centerYAnchor
0x00011f88  mov      x29, x29
0x00011f8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011f90  mov      x2, x0
0x00011f94  str      x0, [sp, #0x10]
0x00011f98  mov      x0, x21
0x00011f9c  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x00011fa0  mov      x29, x29
0x00011fa4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011fa8  str      x0, [sp, #8]
0x00011fac  str      x0, [sp, #0x258]
0x00011fb0  ldr      x0, [x19, x24]
0x00011fb4  bl       #0x56d60   ; CALL objc_msgSend$centerXAnchor
0x00011fb8  mov      x29, x29
0x00011fbc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011fc0  mov      x23, x0
0x00011fc4  mov      x0, x19
0x00011fc8  bl       #0x5df60   ; CALL objc_msgSend$view
0x00011fcc  mov      x29, x29
0x00011fd0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011fd4  mov      x28, x0
0x00011fd8  bl       #0x56d60   ; CALL objc_msgSend$centerXAnchor
0x00011fdc  mov      x29, x29
0x00011fe0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011fe4  mov      x25, x0
0x00011fe8  mov      x0, x23
0x00011fec  mov      x2, x25
0x00011ff0  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x00011ff4  mov      x29, x29
0x00011ff8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00011ffc  mov      x22, x0
0x00012000  str      x0, [sp, #0x260]
0x00012004  ldr      x0, [x19, x24]
0x00012008  bl       #0x56d80   ; CALL objc_msgSend$centerYAnchor
0x0001200c  mov      x29, x29
0x00012010  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012014  mov      x24, x0
0x00012018  ldr      x0, [x19, x27]
0x0001201c  bl       #0x56d80   ; CALL objc_msgSend$centerYAnchor
0x00012020  mov      x29, x29
0x00012024  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012028  mov      x21, x0
0x0001202c  mov      x0, x24
0x00012030  mov      x2, x21
0x00012034  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x00012038  mov      x29, x29
0x0001203c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012040  mov      x26, x0
0x00012044  str      x0, [sp, #0x268]
0x00012048  adrp     x8, #0x8e000
0x0001204c  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00012050  add      x2, sp, #0x1f8
0x00012054  mov      w3, #0xf
0x00012058  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0001205c  mov      x29, x29
0x00012060  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012064  mov      x27, x0
0x00012068  ldr      x0, [sp, #0xd0]
0x0001206c  mov      x2, x27
0x00012070  bl       #0x55fe0   ; CALL objc_msgSend$activateConstraints:
0x00012074  mov      x0, x27
0x00012078  bl       #0x55d78   ; CALL _objc_release
0x0001207c  mov      x0, x26
0x00012080  bl       #0x55d78   ; CALL _objc_release
0x00012084  mov      x0, x21
0x00012088  bl       #0x55d78   ; CALL _objc_release
0x0001208c  mov      x0, x24
0x00012090  bl       #0x55d78   ; CALL _objc_release
0x00012094  mov      x0, x22
0x00012098  bl       #0x55d78   ; CALL _objc_release
0x0001209c  mov      x0, x25
0x000120a0  bl       #0x55d78   ; CALL _objc_release
0x000120a4  mov      x0, x28
0x000120a8  bl       #0x55d78   ; CALL _objc_release
0x000120ac  mov      x0, x23
0x000120b0  bl       #0x55d78   ; CALL _objc_release
0x000120b4  ldr      x0, [sp, #8]
0x000120b8  bl       #0x55d78   ; CALL _objc_release
0x000120bc  ldr      x0, [sp, #0x10]
0x000120c0  bl       #0x55d78   ; CALL _objc_release
0x000120c4  ldr      x0, [sp, #0x18]
0x000120c8  bl       #0x55d78   ; CALL _objc_release
0x000120cc  ldr      x0, [sp, #0x20]
0x000120d0  bl       #0x55d78   ; CALL _objc_release
0x000120d4  ldr      x0, [sp, #0x28]
0x000120d8  bl       #0x55d78   ; CALL _objc_release
0x000120dc  ldr      x0, [sp, #0x30]
0x000120e0  bl       #0x55d78   ; CALL _objc_release
0x000120e4  ldr      x0, [sp, #0x38]
0x000120e8  bl       #0x55d78   ; CALL _objc_release
0x000120ec  ldr      x0, [sp, #0x40]
0x000120f0  bl       #0x55d78   ; CALL _objc_release
0x000120f4  ldr      x0, [sp, #0x48]
0x000120f8  bl       #0x55d78   ; CALL _objc_release
0x000120fc  ldr      x0, [sp, #0x50]
0x00012100  bl       #0x55d78   ; CALL _objc_release
0x00012104  ldr      x0, [sp, #0x58]
0x00012108  bl       #0x55d78   ; CALL _objc_release
0x0001210c  ldr      x0, [sp, #0x60]
0x00012110  bl       #0x55d78   ; CALL _objc_release
0x00012114  ldr      x0, [sp, #0x68]
0x00012118  bl       #0x55d78   ; CALL _objc_release
0x0001211c  ldr      x0, [sp, #0x70]
0x00012120  bl       #0x55d78   ; CALL _objc_release
0x00012124  ldr      x0, [sp, #0x80]
0x00012128  bl       #0x55d78   ; CALL _objc_release
0x0001212c  ldr      x0, [sp, #0x78]
0x00012130  bl       #0x55d78   ; CALL _objc_release
0x00012134  ldr      x0, [sp, #0x88]
0x00012138  bl       #0x55d78   ; CALL _objc_release
0x0001213c  ldr      x0, [sp, #0x90]
0x00012140  bl       #0x55d78   ; CALL _objc_release
0x00012144  ldr      x0, [sp, #0xa0]
0x00012148  bl       #0x55d78   ; CALL _objc_release
0x0001214c  ldr      x0, [sp, #0x98]
0x00012150  bl       #0x55d78   ; CALL _objc_release
0x00012154  ldr      x0, [sp, #0xa8]
0x00012158  bl       #0x55d78   ; CALL _objc_release
0x0001215c  ldr      x0, [sp, #0xb0]
0x00012160  bl       #0x55d78   ; CALL _objc_release
0x00012164  ldr      x0, [sp, #0xc8]
0x00012168  bl       #0x55d78   ; CALL _objc_release
0x0001216c  ldr      x0, [sp, #0xc0]
0x00012170  bl       #0x55d78   ; CALL _objc_release
0x00012174  ldr      x0, [sp, #0xd8]
0x00012178  bl       #0x55d78   ; CALL _objc_release
0x0001217c  ldr      x0, [sp, #0xe0]
0x00012180  bl       #0x55d78   ; CALL _objc_release
0x00012184  ldr      x0, [sp, #0xf0]
0x00012188  bl       #0x55d78   ; CALL _objc_release
0x0001218c  ldr      x0, [sp, #0xe8]
0x00012190  bl       #0x55d78   ; CALL _objc_release
0x00012194  ldr      x0, [sp, #0xf8]
0x00012198  bl       #0x55d78   ; CALL _objc_release
0x0001219c  ldr      x0, [sp, #0x100]
0x000121a0  bl       #0x55d78   ; CALL _objc_release
0x000121a4  ldr      x0, [sp, #0x110]
0x000121a8  bl       #0x55d78   ; CALL _objc_release
0x000121ac  ldr      x0, [sp, #0x108]
0x000121b0  bl       #0x55d78   ; CALL _objc_release
0x000121b4  ldr      x0, [sp, #0x118]
0x000121b8  bl       #0x55d78   ; CALL _objc_release
0x000121bc  ldr      x0, [sp, #0x120]
0x000121c0  bl       #0x55d78   ; CALL _objc_release
0x000121c4  ldr      x0, [sp, #0x128]
0x000121c8  bl       #0x55d78   ; CALL _objc_release
0x000121cc  ldr      x0, [sp, #0x130]
0x000121d0  bl       #0x55d78   ; CALL _objc_release
0x000121d4  ldr      x0, [sp, #0x138]
0x000121d8  bl       #0x55d78   ; CALL _objc_release
0x000121dc  ldr      x0, [sp, #0x148]
0x000121e0  bl       #0x55d78   ; CALL _objc_release
0x000121e4  ldr      x0, [sp, #0x140]
0x000121e8  bl       #0x55d78   ; CALL _objc_release
0x000121ec  ldr      x0, [sp, #0x150]
0x000121f0  bl       #0x55d78   ; CALL _objc_release
0x000121f4  ldr      x0, [sp, #0x158]
0x000121f8  bl       #0x55d78   ; CALL _objc_release
0x000121fc  ldr      x0, [sp, #0x168]
0x00012200  bl       #0x55d78   ; CALL _objc_release
0x00012204  ldr      x0, [sp, #0x160]
0x00012208  bl       #0x55d78   ; CALL _objc_release
0x0001220c  ldr      x0, [sp, #0x170]
0x00012210  bl       #0x55d78   ; CALL _objc_release
0x00012214  ldr      x0, [sp, #0x178]
0x00012218  bl       #0x55d78   ; CALL _objc_release
0x0001221c  ldr      x0, [sp, #0x180]
0x00012220  bl       #0x55d78   ; CALL _objc_release
0x00012224  mov      x0, x19
0x00012228  bl       #0x5dd20   ; CALL objc_msgSend$updateControls
0x0001222c  ldr      x0, [sp, #0xb8]
0x00012230  bl       #0x55d78   ; CALL _objc_release
0x00012234  ldr      x0, [sp, #0x188]
0x00012238  bl       #0x55d78   ; CALL _objc_release
0x0001223c  ldr      x0, [sp, #0x190]
0x00012240  bl       #0x55d78   ; CALL _objc_release
0x00012244  ldr      x0, [sp, #0x198]
0x00012248  bl       #0x55d78   ; CALL _objc_release
0x0001224c  mov      x0, x20
0x00012250  bl       #0x55d78   ; CALL _objc_release
0x00012254  ldur     x8, [x29, #-0x60]
0x00012258  adrp     x9, #0x74000
0x0001225c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00012260  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00012264  cmp      x9, x8
0x00012268  b.ne     #0x1228c
0x0001226c  add      sp, sp, #0x320
0x00012270  ldp      x29, x30, [sp, #0x50]
0x00012274  ldp      x20, x19, [sp, #0x40]
0x00012278  ldp      x22, x21, [sp, #0x30]
0x0001227c  ldp      x24, x23, [sp, #0x20]
0x00012280  ldp      x26, x25, [sp, #0x10]
0x00012284  ldp      x28, x27, [sp], #0x60
0x00012288  ret      
0x0001228c  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCOnboardingController viewWillAppear:]  va=0x12290 size=108 types=v20@0:8B16
0x00012290  sub      sp, sp, #0x30
0x00012294  stp      x20, x19, [sp, #0x10]
0x00012298  stp      x29, x30, [sp, #0x20]
0x0001229c  add      x29, sp, #0x20
0x000122a0  mov      x19, x2
0x000122a4  mov      x20, x0
0x000122a8  adrp     x8, #0x8e000
0x000122ac  ldr      x8, [x8, #0xd20]   ; @SUPER OMCOnboardingController
0x000122b0  stp      x0, x8, [sp]
0x000122b4  adrp     x8, #0x8b000
0x000122b8  ldr      x1, [x8, #0xda8]   ; @SEL "viewWillAppear:"
0x000122bc  mov      x0, sp
0x000122c0  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x000122c4  mov      x0, x20
0x000122c8  bl       #0x59180   ; CALL objc_msgSend$navigationController
0x000122cc  mov      x29, x29
0x000122d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000122d4  mov      x20, x0
0x000122d8  mov      w2, #1
0x000122dc  mov      x3, x19
0x000122e0  bl       #0x5b740   ; CALL objc_msgSend$setNavigationBarHidden:animated:
0x000122e4  mov      x0, x20
0x000122e8  bl       #0x55d78   ; CALL _objc_release
0x000122ec  ldp      x29, x30, [sp, #0x20]
0x000122f0  ldp      x20, x19, [sp, #0x10]
0x000122f4  add      sp, sp, #0x30
0x000122f8  ret      

=== -[OMCOnboardingController viewWillDisappear:]  va=0x122fc size=108 types=v20@0:8B16
0x000122fc  sub      sp, sp, #0x30
0x00012300  stp      x20, x19, [sp, #0x10]
0x00012304  stp      x29, x30, [sp, #0x20]
0x00012308  add      x29, sp, #0x20
0x0001230c  mov      x19, x2
0x00012310  mov      x20, x0
0x00012314  adrp     x8, #0x8e000
0x00012318  ldr      x8, [x8, #0xd20]   ; @SUPER OMCOnboardingController
0x0001231c  stp      x0, x8, [sp]
0x00012320  adrp     x8, #0x8b000
0x00012324  ldr      x1, [x8, #0xe08]   ; @SEL "viewWillDisappear:"
0x00012328  mov      x0, sp
0x0001232c  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00012330  mov      x0, x20
0x00012334  bl       #0x59180   ; CALL objc_msgSend$navigationController
0x00012338  mov      x29, x29
0x0001233c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012340  mov      x20, x0
0x00012344  mov      w2, #0
0x00012348  mov      x3, x19
0x0001234c  bl       #0x5b740   ; CALL objc_msgSend$setNavigationBarHidden:animated:
0x00012350  mov      x0, x20
0x00012354  bl       #0x55d78   ; CALL _objc_release
0x00012358  ldp      x29, x30, [sp, #0x20]
0x0001235c  ldp      x20, x19, [sp, #0x10]
0x00012360  add      sp, sp, #0x30
0x00012364  ret      

=== -[OMCOnboardingController viewDidLayoutSubviews]  va=0x12368 size=156 types=v16@0:8
0x00012368  sub      sp, sp, #0x40
0x0001236c  stp      d9, d8, [sp, #0x10]
0x00012370  stp      x20, x19, [sp, #0x20]
0x00012374  stp      x29, x30, [sp, #0x30]
0x00012378  add      x29, sp, #0x30
0x0001237c  mov      x19, x0
0x00012380  adrp     x8, #0x8e000
0x00012384  ldr      x8, [x8, #0xd20]   ; @SUPER OMCOnboardingController
0x00012388  stp      x0, x8, [sp]
0x0001238c  adrp     x8, #0x8b000
0x00012390  ldr      x1, [x8, #0xe10]   ; @SEL "viewDidLayoutSubviews"
0x00012394  mov      x0, sp
0x00012398  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0001239c  adrp     x8, #0x8e000
0x000123a0  ldrsw    x20, [x8, #0xdd0]
0x000123a4  ldr      x0, [x19, x20]
0x000123a8  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x000123ac  fcmp     d2, #0.0
0x000123b0  b.le     #0x123f0
0x000123b4  mov      v8.16b, v2.16b
0x000123b8  mov      x0, x19
0x000123bc  bl       #0x58a40   ; CALL objc_msgSend$laidOutWidth
0x000123c0  fcmp     d8, d0
0x000123c4  b.eq     #0x123f0
0x000123c8  mov      x0, x19
0x000123cc  mov      v0.16b, v8.16b
0x000123d0  bl       #0x5b220   ; CALL objc_msgSend$setLaidOutWidth:
0x000123d4  mov      x0, x19
0x000123d8  bl       #0x59560   ; CALL objc_msgSend$page
0x000123dc  scvtf    d0, x0
0x000123e0  fmul     d0, d8, d0
0x000123e4  ldr      x0, [x19, x20]
0x000123e8  fmov     d1, xzr
0x000123ec  bl       #0x5aa60   ; CALL objc_msgSend$setContentOffset:
0x000123f0  ldp      x29, x30, [sp, #0x30]
0x000123f4  ldp      x20, x19, [sp, #0x20]
0x000123f8  ldp      d9, d8, [sp, #0x10]
0x000123fc  add      sp, sp, #0x40
0x00012400  ret      

=== -[OMCOnboardingController labelWithFont:color:alignment:]  va=0x12404 size=156 types=@40@0:8@16@24q32
0x00012404  stp      x22, x21, [sp, #-0x30]!
0x00012408  stp      x20, x19, [sp, #0x10]
0x0001240c  stp      x29, x30, [sp, #0x20]
0x00012410  add      x29, sp, #0x20
0x00012414  mov      x19, x4
0x00012418  mov      x20, x3
0x0001241c  mov      x21, x2
0x00012420  adrp     x8, #0x8e000
0x00012424  ldr      x22, [x8, #0x940]   ; @CLASS UILabel
0x00012428  mov      x0, x3
0x0001242c  bl       #0x55d84   ; CALL _objc_retain
0x00012430  mov      x0, x21
0x00012434  bl       #0x55d84   ; CALL _objc_retain
0x00012438  mov      x0, x22
0x0001243c  bl       #0x55d60   ; CALL _objc_opt_new
0x00012440  mov      x22, x0
0x00012444  mov      x2, x21
0x00012448  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x0001244c  mov      x0, x21
0x00012450  bl       #0x55d78   ; CALL _objc_release
0x00012454  mov      x0, x22
0x00012458  mov      w2, #1
0x0001245c  bl       #0x5a360   ; CALL objc_msgSend$setAdjustsFontForContentSizeCategory:
0x00012460  mov      x0, x22
0x00012464  mov      x2, x20
0x00012468  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0001246c  mov      x0, x20
0x00012470  bl       #0x55d78   ; CALL _objc_release
0x00012474  mov      x0, x22
0x00012478  mov      x2, x19
0x0001247c  bl       #0x5c4e0   ; CALL objc_msgSend$setTextAlignment:
0x00012480  mov      x0, x22
0x00012484  mov      x2, #0
0x00012488  bl       #0x5b820   ; CALL objc_msgSend$setNumberOfLines:
0x0001248c  mov      x0, x22
0x00012490  ldp      x29, x30, [sp, #0x20]
0x00012494  ldp      x20, x19, [sp, #0x10]
0x00012498  ldp      x22, x21, [sp], #0x30
0x0001249c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCOnboardingController bodyLabelWithText:]  va=0x124a0 size=604 types=@24@0:8@16
0x000124a0  sub      sp, sp, #0xb0
0x000124a4  stp      d9, d8, [sp, #0x50]
0x000124a8  stp      x26, x25, [sp, #0x60]
0x000124ac  stp      x24, x23, [sp, #0x70]
0x000124b0  stp      x22, x21, [sp, #0x80]
0x000124b4  stp      x20, x19, [sp, #0x90]
0x000124b8  stp      x29, x30, [sp, #0xa0]
0x000124bc  add      x29, sp, #0xa0
0x000124c0  mov      x19, x2
0x000124c4  mov      x21, x0
0x000124c8  adrp     x8, #0x74000
0x000124cc  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000124d0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000124d4  str      x8, [sp, #0x48]
0x000124d8  mov      x0, x2
0x000124dc  bl       #0x55d84   ; CALL _objc_retain
0x000124e0  adrp     x8, #0x8e000
0x000124e4  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x000124e8  adrp     x8, #0x74000
0x000124ec  ldr      x8, [x8, #0x210]   ; @GOT _UIFontTextStyleBody
0x000124f0  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x000124f4  bl       #0x59900   ; CALL objc_msgSend$preferredFontForTextStyle:
0x000124f8  mov      x29, x29
0x000124fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012500  mov      x20, x0
0x00012504  adrp     x2, #0x78000
0x00012508  add      x2, x2, #0x268   ; STR "• "
0x0001250c  mov      x0, x19
0x00012510  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x00012514  mov      x23, x0
0x00012518  adrp     x24, #0x8e000
0x0001251c  ldr      x0, [x24, #0x910]   ; @CLASS UIColor
0x00012520  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x00012524  mov      x29, x29
0x00012528  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001252c  mov      x22, x0
0x00012530  cmp      w23, #0
0x00012534  mov      w8, #4
0x00012538  csinc    x4, x8, xzr, ne
0x0001253c  fmov     d0, xzr
0x00012540  fmov     d1, #10.00000000
0x00012544  fcsel    d8, d1, d0, ne
0x00012548  mov      x0, x21
0x0001254c  mov      x2, x20
0x00012550  mov      x3, x22
0x00012554  bl       #0x58a20   ; CALL objc_msgSend$labelWithFont:color:alignment:
0x00012558  mov      x29, x29
0x0001255c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012560  mov      x21, x0
0x00012564  mov      x0, x22
0x00012568  bl       #0x55d78   ; CALL _objc_release
0x0001256c  adrp     x8, #0x8e000
0x00012570  ldr      x0, [x8, #0xa60]   ; @CLASS NSMutableParagraphStyle
0x00012574  bl       #0x55d60   ; CALL _objc_opt_new
0x00012578  mov      x22, x0
0x0001257c  mov      x0, x21
0x00012580  bl       #0x5d9a0   ; CALL objc_msgSend$textAlignment
0x00012584  mov      x2, x0
0x00012588  mov      x0, x22
0x0001258c  bl       #0x5a3a0   ; CALL objc_msgSend$setAlignment:
0x00012590  fmov     d0, #3.00000000
0x00012594  mov      x0, x22
0x00012598  bl       #0x5b380   ; CALL objc_msgSend$setLineSpacing:
0x0001259c  mov      x0, x22
0x000125a0  mov      v0.16b, v8.16b
0x000125a4  bl       #0x5bb20   ; CALL objc_msgSend$setParagraphSpacing:
0x000125a8  adrp     x8, #0x74000
0x000125ac  ldr      x8, [x8, #0x1d8]   ; @GOT _NSFontAttributeName
0x000125b0  ldr      x26, [x8]   ; @GOT ___objc_personality_v0
0x000125b4  adrp     x25, #0x8e000
0x000125b8  cbz      w23, #0x12600
0x000125bc  stp      x26, x20, [sp, #0x38]
0x000125c0  ldr      x0, [x25, #0x970]   ; @CLASS NSDictionary
0x000125c4  add      x2, sp, #0x40
0x000125c8  add      x3, sp, #0x38
0x000125cc  mov      w4, #1
0x000125d0  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x000125d4  mov      x29, x29
0x000125d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000125dc  mov      x23, x0
0x000125e0  adrp     x0, #0x78000
0x000125e4  add      x0, x0, #0x268   ; STR "• "
0x000125e8  mov      x2, x23
0x000125ec  bl       #0x5cc00   ; CALL objc_msgSend$sizeWithAttributes:
0x000125f0  mov      x0, x22
0x000125f4  bl       #0x5afa0   ; CALL objc_msgSend$setHeadIndent:
0x000125f8  mov      x0, x23
0x000125fc  bl       #0x55d78   ; CALL _objc_release
0x00012600  adrp     x8, #0x8e000
0x00012604  ldr      x0, [x8, #0xa68]   ; @CLASS NSAttributedString
0x00012608  bl       #0x55c7c   ; CALL _objc_alloc
0x0001260c  mov      x23, x0
0x00012610  str      x20, [sp, #0x20]
0x00012614  adrp     x8, #0x74000
0x00012618  ldr      x8, [x8, #0x1e0]   ; @GOT _NSForegroundColorAttributeName
0x0001261c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00012620  stp      x26, x8, [sp, #8]
0x00012624  ldr      x0, [x24, #0x910]   ; @CLASS UIColor
0x00012628  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x0001262c  mov      x29, x29
0x00012630  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012634  mov      x24, x0
0x00012638  adrp     x8, #0x74000
0x0001263c  ldr      x8, [x8, #0x1e8]   ; @GOT _NSParagraphStyleAttributeName
0x00012640  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00012644  str      x8, [sp, #0x18]
0x00012648  stp      x0, x22, [sp, #0x28]
0x0001264c  ldr      x0, [x25, #0x970]   ; @CLASS NSDictionary
0x00012650  add      x2, sp, #0x20
0x00012654  add      x3, sp, #8
0x00012658  mov      w4, #3
0x0001265c  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00012660  mov      x29, x29
0x00012664  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012668  mov      x25, x0
0x0001266c  mov      x0, x23
0x00012670  mov      x2, x19
0x00012674  mov      x3, x25
0x00012678  bl       #0x58580   ; CALL objc_msgSend$initWithString:attributes:
0x0001267c  mov      x23, x0
0x00012680  mov      x0, x21
0x00012684  mov      x2, x23
0x00012688  bl       #0x5a4c0   ; CALL objc_msgSend$setAttributedText:
0x0001268c  mov      x0, x23
0x00012690  bl       #0x55d78   ; CALL _objc_release
0x00012694  mov      x0, x25
0x00012698  bl       #0x55d78   ; CALL _objc_release
0x0001269c  mov      x0, x24
0x000126a0  bl       #0x55d78   ; CALL _objc_release
0x000126a4  mov      x0, x22
0x000126a8  bl       #0x55d78   ; CALL _objc_release
0x000126ac  mov      x0, x20
0x000126b0  bl       #0x55d78   ; CALL _objc_release
0x000126b4  mov      x0, x19
0x000126b8  bl       #0x55d78   ; CALL _objc_release
0x000126bc  ldr      x8, [sp, #0x48]
0x000126c0  adrp     x9, #0x74000
0x000126c4  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000126c8  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000126cc  cmp      x9, x8
0x000126d0  b.ne     #0x126f8
0x000126d4  mov      x0, x21
0x000126d8  ldp      x29, x30, [sp, #0xa0]
0x000126dc  ldp      x20, x19, [sp, #0x90]
0x000126e0  ldp      x22, x21, [sp, #0x80]
0x000126e4  ldp      x24, x23, [sp, #0x70]
0x000126e8  ldp      x26, x25, [sp, #0x60]
0x000126ec  ldp      d9, d8, [sp, #0x50]
0x000126f0  add      sp, sp, #0xb0
0x000126f4  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x000126f8  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCOnboardingController pageWithSymbol:title:body:extra:note:]  va=0x126fc size=2676 types=@56@0:8@16@24@32@40@48
0x000126fc  sub      sp, sp, #0x1a0
0x00012700  stp      d9, d8, [sp, #0x130]
0x00012704  stp      x28, x27, [sp, #0x140]
0x00012708  stp      x26, x25, [sp, #0x150]
0x0001270c  stp      x24, x23, [sp, #0x160]
0x00012710  stp      x22, x21, [sp, #0x170]
0x00012714  stp      x20, x19, [sp, #0x180]
0x00012718  stp      x29, x30, [sp, #0x190]
0x0001271c  add      x29, sp, #0x190
0x00012720  mov      x22, x6
0x00012724  mov      x21, x4
0x00012728  mov      x23, x3
0x0001272c  mov      x19, x2
0x00012730  mov      x25, x0
0x00012734  adrp     x8, #0x74000
0x00012738  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0001273c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00012740  stur     x8, [x29, #-0x70]
0x00012744  str      x5, [sp, #0xb8]
0x00012748  mov      x0, x5
0x0001274c  bl       #0x55d84   ; CALL _objc_retain
0x00012750  mov      x0, x22
0x00012754  bl       #0x55d84   ; CALL _objc_retain
0x00012758  adrp     x8, #0x8e000
0x0001275c  ldr      x20, [x8, #0xa30]   ; @CLASS UIScrollView
0x00012760  str      x21, [sp, #0x68]
0x00012764  mov      x0, x21
0x00012768  bl       #0x55d84   ; CALL _objc_retain
0x0001276c  str      x23, [sp, #0x60]
0x00012770  mov      x0, x23
0x00012774  bl       #0x55d84   ; CALL _objc_retain
0x00012778  mov      x0, x19
0x0001277c  bl       #0x55d84   ; CALL _objc_retain
0x00012780  mov      x0, x20
0x00012784  bl       #0x55d60   ; CALL _objc_opt_new
0x00012788  mov      x23, x0
0x0001278c  mov      w2, #0
0x00012790  bl       #0x5c160   ; CALL objc_msgSend$setShowsVerticalScrollIndicator:
0x00012794  mov      x0, x23
0x00012798  mov      w2, #2
0x0001279c  bl       #0x5aa00   ; CALL objc_msgSend$setContentInsetAdjustmentBehavior:
0x000127a0  adrp     x8, #0x8e000
0x000127a4  ldr      x0, [x8, #0xa38]   ; @CLASS UIStackView
0x000127a8  bl       #0x55d60   ; CALL _objc_opt_new
0x000127ac  mov      x20, x0
0x000127b0  mov      w2, #0
0x000127b4  bl       #0x5c6c0   ; CALL objc_msgSend$setTranslatesAutoresizingMaskIntoConstraints:
0x000127b8  mov      x0, x20
0x000127bc  mov      w2, #1
0x000127c0  bl       #0x5a540   ; CALL objc_msgSend$setAxis:
0x000127c4  mov      x0, x20
0x000127c8  mov      x2, #0
0x000127cc  bl       #0x5a3a0   ; CALL objc_msgSend$setAlignment:
0x000127d0  fmov     d0, #14.00000000
0x000127d4  mov      x0, x20
0x000127d8  bl       #0x5c240   ; CALL objc_msgSend$setSpacing:
0x000127dc  mov      x0, x23
0x000127e0  str      x20, [sp, #0xa8]
0x000127e4  mov      x2, x20
0x000127e8  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x000127ec  adrp     x8, #0x8e000
0x000127f0  ldr      x0, [x8, #0xa70]   ; @CLASS UIImageSymbolConfiguration
0x000127f4  mov      x8, #0x4044000000000000
0x000127f8  fmov     d0, x8
0x000127fc  mov      w2, #6
0x00012800  bl       #0x57100   ; CALL objc_msgSend$configurationWithPointSize:weight:
0x00012804  mov      x29, x29
0x00012808  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001280c  mov      x24, x0
0x00012810  adrp     x21, #0x8e000
0x00012814  ldr      x0, [x21, #0xa78]   ; @CLASS UIImage
0x00012818  mov      x2, x19
0x0001281c  mov      x3, x24
0x00012820  bl       #0x5d840   ; CALL objc_msgSend$systemImageNamed:withConfiguration:
0x00012824  mov      x29, x29
0x00012828  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001282c  mov      x20, x0
0x00012830  mov      x0, x19
0x00012834  bl       #0x55d78   ; CALL _objc_release
0x00012838  str      x22, [sp, #0xb0]
0x0001283c  stp      x24, x23, [sp, #0x98]
0x00012840  str      x25, [sp, #0x70]
0x00012844  cbz      x20, #0x12858
0x00012848  mov      x0, x20
0x0001284c  bl       #0x55d84   ; CALL _objc_retain
0x00012850  mov      x19, x20
0x00012854  b        #0x12878
0x00012858  ldr      x0, [x21, #0xa78]   ; @CLASS UIImage
0x0001285c  adrp     x2, #0x75000
0x00012860  add      x2, x2, #0x228   ; STR "car.fill"
0x00012864  mov      x3, x24
0x00012868  bl       #0x5d840   ; CALL objc_msgSend$systemImageNamed:withConfiguration:
0x0001286c  mov      x29, x29
0x00012870  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012874  mov      x19, x0
0x00012878  mov      x0, x20
0x0001287c  bl       #0x55d78   ; CALL _objc_release
0x00012880  adrp     x8, #0x8e000
0x00012884  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x00012888  bl       #0x55c7c   ; CALL _objc_alloc
0x0001288c  str      x19, [sp, #0x90]
0x00012890  mov      x2, x19
0x00012894  bl       #0x584c0   ; CALL objc_msgSend$initWithImage:
0x00012898  mov      x22, x0
0x0001289c  mov      w2, #0
0x000128a0  bl       #0x5c6c0   ; CALL objc_msgSend$setTranslatesAutoresizingMaskIntoConstraints:
0x000128a4  adrp     x8, #0x8e000
0x000128a8  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x000128ac  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x000128b0  mov      x29, x29
0x000128b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000128b8  mov      x19, x0
0x000128bc  mov      x0, x22
0x000128c0  mov      x2, x19
0x000128c4  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x000128c8  mov      x0, x19
0x000128cc  bl       #0x55d78   ; CALL _objc_release
0x000128d0  mov      x0, x22
0x000128d4  mov      w2, #4
0x000128d8  bl       #0x5aa40   ; CALL objc_msgSend$setContentMode:
0x000128dc  adrp     x21, #0x8e000
0x000128e0  ldr      x0, [x21, #0x918]   ; @CLASS UIView
0x000128e4  bl       #0x55d60   ; CALL _objc_opt_new
0x000128e8  mov      x26, x0
0x000128ec  mov      w2, #0
0x000128f0  bl       #0x5c6c0   ; CALL objc_msgSend$setTranslatesAutoresizingMaskIntoConstraints:
0x000128f4  bl       #0x17e8c   ; CALL _OMCAccentColor
0x000128f8  mov      x29, x29
0x000128fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012900  mov      x19, x0
0x00012904  mov      x0, x26
0x00012908  mov      x2, x19
0x0001290c  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x00012910  mov      x0, x19
0x00012914  bl       #0x55d78   ; CALL _objc_release
0x00012918  mov      x0, x26
0x0001291c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00012920  mov      x29, x29
0x00012924  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012928  mov      x19, x0
0x0001292c  fmov     d0, #24.00000000
0x00012930  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x00012934  mov      x0, x19
0x00012938  bl       #0x55d78   ; CALL _objc_release
0x0001293c  adrp     x8, #0x74000
0x00012940  ldr      x8, [x8, #0x648]   ; @GOT _kCACornerCurveContinuous
0x00012944  ldr      x19, [x8]   ; @GOT ___objc_personality_v0
0x00012948  mov      x0, x26
0x0001294c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00012950  mov      x29, x29
0x00012954  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012958  mov      x20, x0
0x0001295c  mov      x2, x19
0x00012960  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x00012964  mov      x0, x20
0x00012968  bl       #0x55d78   ; CALL _objc_release
0x0001296c  mov      x0, x26
0x00012970  mov      x2, x22
0x00012974  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00012978  ldr      x0, [x21, #0x918]   ; @CLASS UIView
0x0001297c  bl       #0x55d60   ; CALL _objc_opt_new
0x00012980  mov      x25, x0
0x00012984  mov      x2, x26
0x00012988  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0001298c  adrp     x8, #0x8e000
0x00012990  ldr      x8, [x8, #0xa58]   ; @CLASS NSLayoutConstraint
0x00012994  str      x8, [sp, #0x28]
0x00012998  mov      x0, x26
0x0001299c  bl       #0x5e1c0   ; CALL objc_msgSend$widthAnchor
0x000129a0  mov      x29, x29
0x000129a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000129a8  str      x0, [sp, #0x78]
0x000129ac  mov      x8, #0x4056000000000000
0x000129b0  fmov     d8, x8
0x000129b4  mov      v0.16b, v8.16b
0x000129b8  bl       #0x57180   ; CALL objc_msgSend$constraintEqualToConstant:
0x000129bc  mov      x29, x29
0x000129c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000129c4  str      x0, [sp, #0x58]
0x000129c8  stur     x0, [x29, #-0xa8]
0x000129cc  mov      x0, x26
0x000129d0  bl       #0x57f40   ; CALL objc_msgSend$heightAnchor
0x000129d4  mov      x29, x29
0x000129d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000129dc  str      x0, [sp, #0x50]
0x000129e0  mov      v0.16b, v8.16b
0x000129e4  bl       #0x57180   ; CALL objc_msgSend$constraintEqualToConstant:
0x000129e8  mov      x29, x29
0x000129ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000129f0  str      x0, [sp, #0x48]
0x000129f4  stur     x0, [x29, #-0xa0]
0x000129f8  mov      x0, x26
0x000129fc  bl       #0x5dc00   ; CALL objc_msgSend$topAnchor
0x00012a00  mov      x29, x29
0x00012a04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012a08  mov      x19, x0
0x00012a0c  str      x0, [sp, #0x40]
0x00012a10  mov      x0, x25
0x00012a14  bl       #0x5dc00   ; CALL objc_msgSend$topAnchor
0x00012a18  mov      x29, x29
0x00012a1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012a20  mov      x2, x0
0x00012a24  str      x0, [sp, #0x38]
0x00012a28  mov      x0, x19
0x00012a2c  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x00012a30  mov      x29, x29
0x00012a34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012a38  str      x0, [sp, #0x30]
0x00012a3c  stur     x0, [x29, #-0x98]
0x00012a40  mov      x0, x26
0x00012a44  bl       #0x56a00   ; CALL objc_msgSend$bottomAnchor
0x00012a48  mov      x29, x29
0x00012a4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012a50  mov      x19, x0
0x00012a54  str      x0, [sp, #0x20]
0x00012a58  mov      x0, x25
0x00012a5c  bl       #0x56a00   ; CALL objc_msgSend$bottomAnchor
0x00012a60  mov      x29, x29
0x00012a64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012a68  mov      x2, x0
0x00012a6c  str      x0, [sp, #0x18]
0x00012a70  mov      x0, x19
0x00012a74  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x00012a78  mov      x29, x29
0x00012a7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012a80  str      x0, [sp, #0x10]
0x00012a84  stur     x0, [x29, #-0x90]
0x00012a88  mov      x0, x26
0x00012a8c  bl       #0x56d60   ; CALL objc_msgSend$centerXAnchor
0x00012a90  mov      x29, x29
0x00012a94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012a98  mov      x19, x0
0x00012a9c  str      x0, [sp, #8]
0x00012aa0  mov      x0, x25
0x00012aa4  bl       #0x56d60   ; CALL objc_msgSend$centerXAnchor
0x00012aa8  mov      x29, x29
0x00012aac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012ab0  mov      x28, x0
0x00012ab4  mov      x0, x19
0x00012ab8  mov      x2, x28
0x00012abc  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x00012ac0  mov      x29, x29
0x00012ac4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012ac8  mov      x24, x0
0x00012acc  stur     x0, [x29, #-0x88]
0x00012ad0  mov      x0, x22
0x00012ad4  bl       #0x56d60   ; CALL objc_msgSend$centerXAnchor
0x00012ad8  mov      x29, x29
0x00012adc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012ae0  mov      x21, x0
0x00012ae4  mov      x0, x26
0x00012ae8  bl       #0x56d60   ; CALL objc_msgSend$centerXAnchor
0x00012aec  mov      x29, x29
0x00012af0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012af4  mov      x27, x0
0x00012af8  mov      x0, x21
0x00012afc  mov      x2, x27
0x00012b00  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x00012b04  mov      x29, x29
0x00012b08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012b0c  mov      x23, x0
0x00012b10  stur     x0, [x29, #-0x80]
0x00012b14  str      x22, [sp, #0x88]
0x00012b18  mov      x0, x22
0x00012b1c  bl       #0x56d80   ; CALL objc_msgSend$centerYAnchor
0x00012b20  mov      x29, x29
0x00012b24  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012b28  mov      x19, x0
0x00012b2c  str      x26, [sp, #0x80]
0x00012b30  mov      x0, x26
0x00012b34  bl       #0x56d80   ; CALL objc_msgSend$centerYAnchor
0x00012b38  mov      x29, x29
0x00012b3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012b40  mov      x22, x0
0x00012b44  mov      x0, x19
0x00012b48  mov      x2, x22
0x00012b4c  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x00012b50  mov      x29, x29
0x00012b54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012b58  mov      x26, x0
0x00012b5c  stur     x0, [x29, #-0x78]
0x00012b60  adrp     x8, #0x8e000
0x00012b64  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00012b68  sub      x2, x29, #0xa8
0x00012b6c  mov      w3, #7
0x00012b70  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00012b74  mov      x29, x29
0x00012b78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012b7c  mov      x20, x0
0x00012b80  ldr      x0, [sp, #0x28]
0x00012b84  mov      x2, x20
0x00012b88  bl       #0x55fe0   ; CALL objc_msgSend$activateConstraints:
0x00012b8c  mov      x0, x20
0x00012b90  bl       #0x55d78   ; CALL _objc_release
0x00012b94  mov      x0, x26
0x00012b98  bl       #0x55d78   ; CALL _objc_release
0x00012b9c  mov      x0, x22
0x00012ba0  bl       #0x55d78   ; CALL _objc_release
0x00012ba4  mov      x0, x19
0x00012ba8  bl       #0x55d78   ; CALL _objc_release
0x00012bac  mov      x0, x23
0x00012bb0  bl       #0x55d78   ; CALL _objc_release
0x00012bb4  mov      x0, x27
0x00012bb8  bl       #0x55d78   ; CALL _objc_release
0x00012bbc  mov      x0, x21
0x00012bc0  bl       #0x55d78   ; CALL _objc_release
0x00012bc4  mov      x0, x24
0x00012bc8  bl       #0x55d78   ; CALL _objc_release
0x00012bcc  mov      x0, x28
0x00012bd0  bl       #0x55d78   ; CALL _objc_release
0x00012bd4  ldr      x0, [sp, #8]
0x00012bd8  bl       #0x55d78   ; CALL _objc_release
0x00012bdc  ldr      x0, [sp, #0x10]
0x00012be0  bl       #0x55d78   ; CALL _objc_release
0x00012be4  ldr      x0, [sp, #0x18]
0x00012be8  bl       #0x55d78   ; CALL _objc_release
0x00012bec  ldr      x0, [sp, #0x20]
0x00012bf0  bl       #0x55d78   ; CALL _objc_release
0x00012bf4  ldr      x0, [sp, #0x30]
0x00012bf8  bl       #0x55d78   ; CALL _objc_release
0x00012bfc  ldr      x0, [sp, #0x38]
0x00012c00  bl       #0x55d78   ; CALL _objc_release
0x00012c04  ldr      x0, [sp, #0x40]
0x00012c08  bl       #0x55d78   ; CALL _objc_release
0x00012c0c  ldr      x0, [sp, #0x48]
0x00012c10  bl       #0x55d78   ; CALL _objc_release
0x00012c14  ldr      x0, [sp, #0x50]
0x00012c18  bl       #0x55d78   ; CALL _objc_release
0x00012c1c  ldr      x0, [sp, #0x58]
0x00012c20  bl       #0x55d78   ; CALL _objc_release
0x00012c24  ldr      x0, [sp, #0x78]
0x00012c28  bl       #0x55d78   ; CALL _objc_release
0x00012c2c  ldr      x23, [sp, #0xa8]
0x00012c30  mov      x0, x23
0x00012c34  mov      x2, x25
0x00012c38  bl       #0x56060   ; CALL objc_msgSend$addArrangedSubview:
0x00012c3c  fmov     d0, #24.00000000
0x00012c40  mov      x0, x23
0x00012c44  str      x25, [sp, #0x78]
0x00012c48  mov      x2, x25
0x00012c4c  bl       #0x5abe0   ; CALL objc_msgSend$setCustomSpacing:afterView:
0x00012c50  adrp     x8, #0x8e000
0x00012c54  ldr      x0, [x8, #0xa88]   ; @CLASS UIFontMetrics
0x00012c58  adrp     x8, #0x74000
0x00012c5c  ldr      x8, [x8, #0x230]   ; @GOT _UIFontTextStyleTitle1
0x00012c60  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x00012c64  bl       #0x58fc0   ; CALL objc_msgSend$metricsForTextStyle:
0x00012c68  mov      x29, x29
0x00012c6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012c70  mov      x19, x0
0x00012c74  adrp     x21, #0x8e000
0x00012c78  ldr      x0, [x21, #0x948]   ; @CLASS UIFont
0x00012c7c  adrp     x8, #0x74000
0x00012c80  ldr      x8, [x8, #0x238]   ; @GOT _UIFontWeightBold
0x00012c84  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x00012c88  fmov     d0, #26.00000000
0x00012c8c  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x00012c90  mov      x29, x29
0x00012c94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012c98  mov      x20, x0
0x00012c9c  mov      x0, x19
0x00012ca0  mov      x2, x20
0x00012ca4  bl       #0x5a080   ; CALL objc_msgSend$scaledFontForFont:
0x00012ca8  mov      x29, x29
0x00012cac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012cb0  mov      x22, x0
0x00012cb4  mov      x0, x20
0x00012cb8  adrp     x20, #0x8e000
0x00012cbc  bl       #0x55d78   ; CALL _objc_release
0x00012cc0  mov      x0, x19
0x00012cc4  bl       #0x55d78   ; CALL _objc_release
0x00012cc8  ldr      x0, [x20, #0x910]   ; @CLASS UIColor
0x00012ccc  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x00012cd0  mov      x29, x29
0x00012cd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012cd8  mov      x19, x0
0x00012cdc  ldr      x25, [sp, #0x70]
0x00012ce0  mov      x0, x25
0x00012ce4  str      x22, [sp, #0x58]
0x00012ce8  mov      x2, x22
0x00012cec  mov      x3, x19
0x00012cf0  mov      w4, #1
0x00012cf4  bl       #0x58a20   ; CALL objc_msgSend$labelWithFont:color:alignment:
0x00012cf8  mov      x29, x29
0x00012cfc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012d00  mov      x22, x0
0x00012d04  mov      x0, x19
0x00012d08  bl       #0x55d78   ; CALL _objc_release
0x00012d0c  mov      x0, x22
0x00012d10  ldr      x19, [sp, #0x60]
0x00012d14  mov      x2, x19
0x00012d18  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00012d1c  mov      x0, x19
0x00012d20  bl       #0x55d78   ; CALL _objc_release
0x00012d24  mov      x0, x23
0x00012d28  str      x22, [sp, #0x60]
0x00012d2c  mov      x2, x22
0x00012d30  bl       #0x56060   ; CALL objc_msgSend$addArrangedSubview:
0x00012d34  mov      x0, x25
0x00012d38  ldr      x19, [sp, #0x68]
0x00012d3c  mov      x2, x19
0x00012d40  bl       #0x56980   ; CALL objc_msgSend$bodyLabelWithText:
0x00012d44  mov      x29, x29
0x00012d48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012d4c  mov      x22, x0
0x00012d50  mov      x0, x19
0x00012d54  bl       #0x55d78   ; CALL _objc_release
0x00012d58  mov      x0, x23
0x00012d5c  mov      x2, x22
0x00012d60  bl       #0x56060   ; CALL objc_msgSend$addArrangedSubview:
0x00012d64  ldr      x19, [sp, #0xb8]
0x00012d68  cbz      x19, #0x12d88
0x00012d6c  fmov     d0, #24.00000000
0x00012d70  mov      x0, x23
0x00012d74  mov      x2, x22
0x00012d78  bl       #0x5abe0   ; CALL objc_msgSend$setCustomSpacing:afterView:
0x00012d7c  mov      x0, x23
0x00012d80  mov      x2, x19
0x00012d84  bl       #0x56060   ; CALL objc_msgSend$addArrangedSubview:
0x00012d88  str      x22, [sp, #0x68]
0x00012d8c  ldr      x22, [sp, #0xb0]
0x00012d90  mov      x0, x22
0x00012d94  bl       #0x58c20   ; CALL objc_msgSend$length
0x00012d98  ldr      x24, [sp, #0xa0]
0x00012d9c  cbz      x0, #0x12e24
0x00012da0  ldr      x0, [x21, #0x948]   ; @CLASS UIFont
0x00012da4  adrp     x8, #0x74000
0x00012da8  ldr      x8, [x8, #0x218]   ; @GOT _UIFontTextStyleFootnote
0x00012dac  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x00012db0  bl       #0x59900   ; CALL objc_msgSend$preferredFontForTextStyle:
0x00012db4  mov      x29, x29
0x00012db8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012dbc  mov      x19, x0
0x00012dc0  ldr      x0, [x20, #0x910]   ; @CLASS UIColor
0x00012dc4  bl       #0x5d960   ; CALL objc_msgSend$tertiaryLabelColor
0x00012dc8  mov      x29, x29
0x00012dcc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012dd0  mov      x20, x0
0x00012dd4  mov      x0, x25
0x00012dd8  mov      x2, x19
0x00012ddc  mov      x3, x20
0x00012de0  mov      w4, #1
0x00012de4  bl       #0x58a20   ; CALL objc_msgSend$labelWithFont:color:alignment:
0x00012de8  mov      x29, x29
0x00012dec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012df0  mov      x21, x0
0x00012df4  mov      x0, x20
0x00012df8  bl       #0x55d78   ; CALL _objc_release
0x00012dfc  mov      x0, x19
0x00012e00  bl       #0x55d78   ; CALL _objc_release
0x00012e04  mov      x0, x21
0x00012e08  mov      x2, x22
0x00012e0c  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00012e10  mov      x0, x23
0x00012e14  mov      x2, x21
0x00012e18  bl       #0x56060   ; CALL objc_msgSend$addArrangedSubview:
0x00012e1c  mov      x0, x21
0x00012e20  bl       #0x55d78   ; CALL _objc_release
0x00012e24  adrp     x8, #0x8e000
0x00012e28  ldr      x8, [x8, #0xa58]   ; @CLASS NSLayoutConstraint
0x00012e2c  str      x8, [sp, #0x18]
0x00012e30  mov      x0, x23
0x00012e34  bl       #0x5dc00   ; CALL objc_msgSend$topAnchor
0x00012e38  mov      x29, x29
0x00012e3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012e40  mov      x19, x0
0x00012e44  str      x0, [sp, #0x50]
0x00012e48  mov      x0, x24
0x00012e4c  bl       #0x57200   ; CALL objc_msgSend$contentLayoutGuide
0x00012e50  mov      x29, x29
0x00012e54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012e58  str      x0, [sp, #0x70]
0x00012e5c  bl       #0x5dc00   ; CALL objc_msgSend$topAnchor
0x00012e60  mov      x29, x29
0x00012e64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012e68  mov      x2, x0
0x00012e6c  str      x0, [sp, #0x48]
0x00012e70  mov      x8, #0x4044000000000000
0x00012e74  fmov     d0, x8
0x00012e78  mov      x0, x19
0x00012e7c  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x00012e80  mov      x29, x29
0x00012e84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012e88  str      x0, [sp, #0x40]
0x00012e8c  str      x0, [sp, #0xc0]
0x00012e90  mov      x0, x23
0x00012e94  bl       #0x56a00   ; CALL objc_msgSend$bottomAnchor
0x00012e98  mov      x29, x29
0x00012e9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012ea0  mov      x19, x0
0x00012ea4  str      x0, [sp, #0x30]
0x00012ea8  mov      x0, x24
0x00012eac  bl       #0x57200   ; CALL objc_msgSend$contentLayoutGuide
0x00012eb0  mov      x29, x29
0x00012eb4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012eb8  str      x0, [sp, #0x38]
0x00012ebc  bl       #0x56a00   ; CALL objc_msgSend$bottomAnchor
0x00012ec0  mov      x29, x29
0x00012ec4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012ec8  mov      x2, x0
0x00012ecc  str      x0, [sp, #0x28]
0x00012ed0  fmov     d0, #-20.00000000
0x00012ed4  mov      x0, x19
0x00012ed8  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x00012edc  mov      x29, x29
0x00012ee0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012ee4  str      x0, [sp, #0x20]
0x00012ee8  str      x0, [sp, #0xc8]
0x00012eec  mov      x0, x23
0x00012ef0  bl       #0x58be0   ; CALL objc_msgSend$leadingAnchor
0x00012ef4  mov      x29, x29
0x00012ef8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012efc  mov      x19, x0
0x00012f00  str      x0, [sp, #8]
0x00012f04  mov      x0, x24
0x00012f08  bl       #0x57200   ; CALL objc_msgSend$contentLayoutGuide
0x00012f0c  mov      x29, x29
0x00012f10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012f14  str      x0, [sp, #0x10]
0x00012f18  bl       #0x58be0   ; CALL objc_msgSend$leadingAnchor
0x00012f1c  mov      x29, x29
0x00012f20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012f24  mov      x2, x0
0x00012f28  str      x0, [sp]
0x00012f2c  fmov     d0, #28.00000000
0x00012f30  mov      x0, x19
0x00012f34  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x00012f38  mov      x29, x29
0x00012f3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012f40  mov      x25, x0
0x00012f44  str      x0, [sp, #0xd0]
0x00012f48  mov      x0, x23
0x00012f4c  bl       #0x5dc40   ; CALL objc_msgSend$trailingAnchor
0x00012f50  mov      x29, x29
0x00012f54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012f58  mov      x19, x23
0x00012f5c  mov      x23, x0
0x00012f60  mov      x0, x24
0x00012f64  bl       #0x57200   ; CALL objc_msgSend$contentLayoutGuide
0x00012f68  mov      x29, x29
0x00012f6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012f70  mov      x20, x0
0x00012f74  bl       #0x5dc40   ; CALL objc_msgSend$trailingAnchor
0x00012f78  mov      x29, x29
0x00012f7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012f80  mov      x21, x0
0x00012f84  fmov     d0, #-28.00000000
0x00012f88  mov      x0, x23
0x00012f8c  mov      x2, x21
0x00012f90  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x00012f94  mov      x29, x29
0x00012f98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012f9c  mov      x27, x0
0x00012fa0  str      x0, [sp, #0xd8]
0x00012fa4  mov      x0, x19
0x00012fa8  bl       #0x5e1c0   ; CALL objc_msgSend$widthAnchor
0x00012fac  mov      x29, x29
0x00012fb0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012fb4  mov      x22, x0
0x00012fb8  mov      x0, x24
0x00012fbc  bl       #0x57d20   ; CALL objc_msgSend$frameLayoutGuide
0x00012fc0  mov      x29, x29
0x00012fc4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012fc8  mov      x26, x0
0x00012fcc  bl       #0x5e1c0   ; CALL objc_msgSend$widthAnchor
0x00012fd0  mov      x29, x29
0x00012fd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012fd8  mov      x24, x0
0x00012fdc  mov      x8, #-0x3fb4000000000000
0x00012fe0  fmov     d0, x8
0x00012fe4  mov      x0, x22
0x00012fe8  mov      x2, x24
0x00012fec  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x00012ff0  mov      x29, x29
0x00012ff4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00012ff8  mov      x28, x0
0x00012ffc  str      x0, [sp, #0xe0]
0x00013000  adrp     x8, #0x8e000
0x00013004  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00013008  add      x2, sp, #0xc0
0x0001300c  mov      w3, #5
0x00013010  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00013014  mov      x29, x29
0x00013018  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001301c  mov      x19, x0
0x00013020  ldr      x0, [sp, #0x18]
0x00013024  mov      x2, x19
0x00013028  bl       #0x55fe0   ; CALL objc_msgSend$activateConstraints:
0x0001302c  mov      x0, x19
0x00013030  bl       #0x55d78   ; CALL _objc_release
0x00013034  mov      x0, x28
0x00013038  bl       #0x55d78   ; CALL _objc_release
0x0001303c  mov      x0, x24
0x00013040  bl       #0x55d78   ; CALL _objc_release
0x00013044  mov      x0, x26
0x00013048  bl       #0x55d78   ; CALL _objc_release
0x0001304c  mov      x0, x22
0x00013050  bl       #0x55d78   ; CALL _objc_release
0x00013054  mov      x0, x27
0x00013058  bl       #0x55d78   ; CALL _objc_release
0x0001305c  mov      x0, x21
0x00013060  bl       #0x55d78   ; CALL _objc_release
0x00013064  mov      x0, x20
0x00013068  bl       #0x55d78   ; CALL _objc_release
0x0001306c  mov      x0, x23
0x00013070  bl       #0x55d78   ; CALL _objc_release
0x00013074  mov      x0, x25
0x00013078  bl       #0x55d78   ; CALL _objc_release
0x0001307c  ldr      x0, [sp]
0x00013080  bl       #0x55d78   ; CALL _objc_release
0x00013084  ldr      x0, [sp, #0x10]
0x00013088  bl       #0x55d78   ; CALL _objc_release
0x0001308c  ldr      x0, [sp, #8]
0x00013090  bl       #0x55d78   ; CALL _objc_release
0x00013094  ldr      x0, [sp, #0x20]
0x00013098  bl       #0x55d78   ; CALL _objc_release
0x0001309c  ldr      x0, [sp, #0x28]
0x000130a0  bl       #0x55d78   ; CALL _objc_release
0x000130a4  ldr      x0, [sp, #0x38]
0x000130a8  bl       #0x55d78   ; CALL _objc_release
0x000130ac  ldr      x0, [sp, #0x30]
0x000130b0  bl       #0x55d78   ; CALL _objc_release
0x000130b4  ldr      x0, [sp, #0x40]
0x000130b8  bl       #0x55d78   ; CALL _objc_release
0x000130bc  ldr      x0, [sp, #0x48]
0x000130c0  bl       #0x55d78   ; CALL _objc_release
0x000130c4  ldr      x0, [sp, #0x70]
0x000130c8  bl       #0x55d78   ; CALL _objc_release
0x000130cc  ldr      x0, [sp, #0x50]
0x000130d0  bl       #0x55d78   ; CALL _objc_release
0x000130d4  ldr      x0, [sp, #0x68]
0x000130d8  bl       #0x55d78   ; CALL _objc_release
0x000130dc  ldr      x0, [sp, #0x60]
0x000130e0  bl       #0x55d78   ; CALL _objc_release
0x000130e4  ldr      x0, [sp, #0x58]
0x000130e8  bl       #0x55d78   ; CALL _objc_release
0x000130ec  ldr      x0, [sp, #0x78]
0x000130f0  bl       #0x55d78   ; CALL _objc_release
0x000130f4  ldr      x0, [sp, #0x80]
0x000130f8  bl       #0x55d78   ; CALL _objc_release
0x000130fc  ldr      x0, [sp, #0x88]
0x00013100  bl       #0x55d78   ; CALL _objc_release
0x00013104  ldr      x0, [sp, #0x90]
0x00013108  bl       #0x55d78   ; CALL _objc_release
0x0001310c  ldr      x0, [sp, #0x98]
0x00013110  bl       #0x55d78   ; CALL _objc_release
0x00013114  ldr      x0, [sp, #0xa8]
0x00013118  bl       #0x55d78   ; CALL _objc_release
0x0001311c  ldr      x0, [sp, #0xb0]
0x00013120  bl       #0x55d78   ; CALL _objc_release
0x00013124  ldr      x0, [sp, #0xb8]
0x00013128  bl       #0x55d78   ; CALL _objc_release
0x0001312c  ldur     x8, [x29, #-0x70]
0x00013130  adrp     x9, #0x74000
0x00013134  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00013138  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0001313c  cmp      x9, x8
0x00013140  b.ne     #0x1316c
0x00013144  ldr      x0, [sp, #0xa0]
0x00013148  ldp      x29, x30, [sp, #0x190]
0x0001314c  ldp      x20, x19, [sp, #0x180]
0x00013150  ldp      x22, x21, [sp, #0x170]
0x00013154  ldp      x24, x23, [sp, #0x160]
0x00013158  ldp      x26, x25, [sp, #0x150]
0x0001315c  ldp      x28, x27, [sp, #0x140]
0x00013160  ldp      d9, d8, [sp, #0x130]
0x00013164  add      sp, sp, #0x1a0
0x00013168  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0001316c  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCOnboardingController welcomePage]  va=0x13170 size=512 types=@16@0:8
0x00013170  stp      x24, x23, [sp, #-0x40]!
0x00013174  stp      x22, x21, [sp, #0x10]
0x00013178  stp      x20, x19, [sp, #0x20]
0x0001317c  stp      x29, x30, [sp, #0x30]
0x00013180  add      x29, sp, #0x30
0x00013184  mov      x20, x0
0x00013188  adrp     x8, #0x8e000
0x0001318c  ldr      x0, [x8, #0xa48]   ; @CLASS UIButtonConfiguration
0x00013190  bl       #0x57be0   ; CALL objc_msgSend$filledButtonConfiguration
0x00013194  mov      x29, x29
0x00013198  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001319c  mov      x19, x0
0x000131a0  adrp     x0, #0x78000
0x000131a4  add      x0, x0, #0x288   ; STR "ONB_P1_BUTTON"
0x000131a8  bl       #0x17e20   ; CALL _L
0x000131ac  mov      x29, x29
0x000131b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000131b4  mov      x21, x0
0x000131b8  mov      x0, x19
0x000131bc  mov      x2, x21
0x000131c0  bl       #0x5c5e0   ; CALL objc_msgSend$setTitle:
0x000131c4  mov      x0, x21
0x000131c8  bl       #0x55d78   ; CALL _objc_release
0x000131cc  adrp     x8, #0x8e000
0x000131d0  ldr      x0, [x8, #0xa78]   ; @CLASS UIImage
0x000131d4  adrp     x2, #0x78000
0x000131d8  add      x2, x2, #0x2a8   ; STR "square.grid.2x2.fill"
0x000131dc  bl       #0x5d820   ; CALL objc_msgSend$systemImageNamed:
0x000131e0  mov      x29, x29
0x000131e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000131e8  mov      x21, x0
0x000131ec  mov      x0, x19
0x000131f0  mov      x2, x21
0x000131f4  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x000131f8  mov      x0, x21
0x000131fc  bl       #0x55d78   ; CALL _objc_release
0x00013200  fmov     d0, #8.00000000
0x00013204  mov      x0, x19
0x00013208  bl       #0x5b0e0   ; CALL objc_msgSend$setImagePadding:
0x0001320c  mov      x0, x19
0x00013210  mov      w2, #3
0x00013214  bl       #0x5ab80   ; CALL objc_msgSend$setCornerStyle:
0x00013218  bl       #0x17e8c   ; CALL _OMCAccentColor
0x0001321c  mov      x29, x29
0x00013220  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013224  mov      x21, x0
0x00013228  mov      x0, x19
0x0001322c  mov      x2, x21
0x00013230  bl       #0x5a5e0   ; CALL objc_msgSend$setBaseBackgroundColor:
0x00013234  mov      x0, x21
0x00013238  bl       #0x55d78   ; CALL _objc_release
0x0001323c  adrp     x8, #0x8e000
0x00013240  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00013244  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x00013248  mov      x29, x29
0x0001324c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013250  mov      x21, x0
0x00013254  mov      x0, x19
0x00013258  mov      x2, x21
0x0001325c  bl       #0x5a600   ; CALL objc_msgSend$setBaseForegroundColor:
0x00013260  mov      x0, x21
0x00013264  bl       #0x55d78   ; CALL _objc_release
0x00013268  fmov     d0, #14.00000000
0x0001326c  fmov     d1, #20.00000000
0x00013270  fmov     d2, #14.00000000
0x00013274  fmov     d3, #20.00000000
0x00013278  mov      x0, x19
0x0001327c  bl       #0x5aa20   ; CALL objc_msgSend$setContentInsets:
0x00013280  adrp     x8, #0x8e000
0x00013284  ldr      x0, [x8, #0xa50]   ; @CLASS UIButton
0x00013288  mov      w2, #1
0x0001328c  bl       #0x56b80   ; CALL objc_msgSend$buttonWithType:
0x00013290  mov      x29, x29
0x00013294  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013298  mov      x21, x0
0x0001329c  mov      x2, x19
0x000132a0  bl       #0x5a960   ; CALL objc_msgSend$setConfiguration:
0x000132a4  adrp     x8, #0x8b000
0x000132a8  ldr      x3, [x8, #0xe18]   ; @SEL "openApps"
0x000132ac  mov      x0, x21
0x000132b0  mov      x2, x20
0x000132b4  mov      w4, #0x40
0x000132b8  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x000132bc  adrp     x0, #0x78000
0x000132c0  add      x0, x0, #0x2c8   ; STR "ONB_P1_TITLE"
0x000132c4  bl       #0x17e20   ; CALL _L
0x000132c8  mov      x29, x29
0x000132cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000132d0  mov      x22, x0
0x000132d4  adrp     x0, #0x78000
0x000132d8  add      x0, x0, #0x2e8   ; STR "ONB_P1_BODY"
0x000132dc  bl       #0x17e20   ; CALL _L
0x000132e0  mov      x29, x29
0x000132e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000132e8  mov      x23, x0
0x000132ec  adrp     x0, #0x78000
0x000132f0  add      x0, x0, #0x308   ; STR "ONB_P1_NOTE"
0x000132f4  bl       #0x17e20   ; CALL _L
0x000132f8  mov      x29, x29
0x000132fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013300  mov      x24, x0
0x00013304  adrp     x2, #0x75000
0x00013308  add      x2, x2, #0x228   ; STR "car.fill"
0x0001330c  mov      x0, x20
0x00013310  mov      x3, x22
0x00013314  mov      x4, x23
0x00013318  mov      x5, x21
0x0001331c  mov      x6, x24
0x00013320  bl       #0x595c0   ; CALL objc_msgSend$pageWithSymbol:title:body:extra:note:
0x00013324  mov      x29, x29
0x00013328  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001332c  mov      x20, x0
0x00013330  mov      x0, x24
0x00013334  bl       #0x55d78   ; CALL _objc_release
0x00013338  mov      x0, x23
0x0001333c  bl       #0x55d78   ; CALL _objc_release
0x00013340  mov      x0, x22
0x00013344  bl       #0x55d78   ; CALL _objc_release
0x00013348  mov      x0, x21
0x0001334c  bl       #0x55d78   ; CALL _objc_release
0x00013350  mov      x0, x19
0x00013354  bl       #0x55d78   ; CALL _objc_release
0x00013358  mov      x0, x20
0x0001335c  ldp      x29, x30, [sp, #0x30]
0x00013360  ldp      x20, x19, [sp, #0x20]
0x00013364  ldp      x22, x21, [sp, #0x10]
0x00013368  ldp      x24, x23, [sp], #0x40
0x0001336c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCOnboardingController splitPage]  va=0x13370 size=180 types=@16@0:8
0x00013370  stp      x22, x21, [sp, #-0x30]!
0x00013374  stp      x20, x19, [sp, #0x10]
0x00013378  stp      x29, x30, [sp, #0x20]
0x0001337c  add      x29, sp, #0x20
0x00013380  mov      x19, x0
0x00013384  adrp     x0, #0x78000
0x00013388  add      x0, x0, #0x348   ; STR "ONB_P2_TITLE"
0x0001338c  bl       #0x17e20   ; CALL _L
0x00013390  mov      x29, x29
0x00013394  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013398  mov      x20, x0
0x0001339c  adrp     x0, #0x78000
0x000133a0  add      x0, x0, #0x368   ; STR "ONB_P2_BODY"
0x000133a4  bl       #0x17e20   ; CALL _L
0x000133a8  mov      x29, x29
0x000133ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000133b0  mov      x21, x0
0x000133b4  adrp     x0, #0x78000
0x000133b8  add      x0, x0, #0x388   ; STR "ONB_P2_NOTE"
0x000133bc  bl       #0x17e20   ; CALL _L
0x000133c0  mov      x29, x29
0x000133c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000133c8  mov      x22, x0
0x000133cc  adrp     x2, #0x78000
0x000133d0  add      x2, x2, #0x328   ; STR "rectangle.split.2x1.fill"
0x000133d4  mov      x0, x19
0x000133d8  mov      x3, x20
0x000133dc  mov      x4, x21
0x000133e0  mov      x5, #0
0x000133e4  mov      x6, x22
0x000133e8  bl       #0x595c0   ; CALL objc_msgSend$pageWithSymbol:title:body:extra:note:
0x000133ec  mov      x29, x29
0x000133f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000133f4  mov      x19, x0
0x000133f8  mov      x0, x22
0x000133fc  bl       #0x55d78   ; CALL _objc_release
0x00013400  mov      x0, x21
0x00013404  bl       #0x55d78   ; CALL _objc_release
0x00013408  mov      x0, x20
0x0001340c  bl       #0x55d78   ; CALL _objc_release
0x00013410  mov      x0, x19
0x00013414  ldp      x29, x30, [sp, #0x20]
0x00013418  ldp      x20, x19, [sp, #0x10]
0x0001341c  ldp      x22, x21, [sp], #0x30
0x00013420  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCOnboardingController speedPage]  va=0x13424 size=988 types=@16@0:8
0x00013424  sub      sp, sp, #0x90
0x00013428  stp      d9, d8, [sp, #0x20]
0x0001342c  stp      x28, x27, [sp, #0x30]
0x00013430  stp      x26, x25, [sp, #0x40]
0x00013434  stp      x24, x23, [sp, #0x50]
0x00013438  stp      x22, x21, [sp, #0x60]
0x0001343c  stp      x20, x19, [sp, #0x70]
0x00013440  stp      x29, x30, [sp, #0x80]
0x00013444  add      x29, sp, #0x80
0x00013448  mov      x20, x0
0x0001344c  adrp     x8, #0x74000
0x00013450  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00013454  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00013458  str      x8, [sp, #0x18]
0x0001345c  adrp     x8, #0x8e000
0x00013460  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x00013464  bl       #0x55c7c   ; CALL _objc_alloc
0x00013468  mov      x19, x0
0x0001346c  adrp     x0, #0x78000
0x00013470  add      x0, x0, #0x3a8   ; STR "speedometer"
0x00013474  mov      x1, #0
0x00013478  bl       #0x18144   ; CALL _OMCIcon
0x0001347c  mov      x29, x29
0x00013480  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013484  mov      x21, x0
0x00013488  mov      x0, x19
0x0001348c  mov      x2, x21
0x00013490  bl       #0x584c0   ; CALL objc_msgSend$initWithImage:
0x00013494  mov      x19, x0
0x00013498  mov      x0, x21
0x0001349c  bl       #0x55d78   ; CALL _objc_release
0x000134a0  mov      w8, #0x447a0000
0x000134a4  fmov     s0, w8
0x000134a8  mov      x0, x19
0x000134ac  mov      x2, #0
0x000134b0  bl       #0x5a9e0   ; CALL objc_msgSend$setContentHuggingPriority:forAxis:
0x000134b4  adrp     x8, #0x8e000
0x000134b8  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x000134bc  adrp     x8, #0x74000
0x000134c0  ldr      x8, [x8, #0x210]   ; @GOT _UIFontTextStyleBody
0x000134c4  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x000134c8  bl       #0x59900   ; CALL objc_msgSend$preferredFontForTextStyle:
0x000134cc  mov      x29, x29
0x000134d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000134d4  mov      x22, x0
0x000134d8  adrp     x8, #0x8e000
0x000134dc  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x000134e0  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x000134e4  mov      x29, x29
0x000134e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000134ec  mov      x23, x0
0x000134f0  mov      x0, x20
0x000134f4  mov      x2, x22
0x000134f8  mov      x3, x23
0x000134fc  mov      w4, #4
0x00013500  bl       #0x58a20   ; CALL objc_msgSend$labelWithFont:color:alignment:
0x00013504  mov      x29, x29
0x00013508  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001350c  mov      x21, x0
0x00013510  mov      x0, x23
0x00013514  bl       #0x55d78   ; CALL _objc_release
0x00013518  mov      x0, x22
0x0001351c  bl       #0x55d78   ; CALL _objc_release
0x00013520  adrp     x0, #0x78000
0x00013524  add      x0, x0, #0x3c8   ; STR "ONB_P3_SWITCH"
0x00013528  bl       #0x17e20   ; CALL _L
0x0001352c  mov      x29, x29
0x00013530  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013534  mov      x22, x0
0x00013538  mov      x0, x21
0x0001353c  mov      x2, x22
0x00013540  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00013544  mov      x0, x22
0x00013548  bl       #0x55d78   ; CALL _objc_release
0x0001354c  adrp     x0, #0x78000
0x00013550  add      x0, x0, #0x3e8   ; STR "speedBubbleEnabled"
0x00013554  bl       #0x113fc
0x00013558  mov      x29, x29
0x0001355c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013560  mov      x22, x0
0x00013564  adrp     x8, #0x8e000
0x00013568  ldr      x0, [x8, #0x920]   ; @CLASS UISwitch
0x0001356c  bl       #0x55d60   ; CALL _objc_opt_new
0x00013570  mov      x23, x0
0x00013574  bl       #0x17fd8   ; CALL _OMCSwitchColor
0x00013578  mov      x29, x29
0x0001357c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013580  mov      x24, x0
0x00013584  mov      x0, x23
0x00013588  mov      x2, x24
0x0001358c  bl       #0x5b920   ; CALL objc_msgSend$setOnTintColor:
0x00013590  mov      x0, x24
0x00013594  bl       #0x55d78   ; CALL _objc_release
0x00013598  cbz      x22, #0x135ac
0x0001359c  mov      x0, x22
0x000135a0  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x000135a4  mov      x2, x0
0x000135a8  b        #0x135b0
0x000135ac  mov      w2, #1
0x000135b0  mov      x0, x23
0x000135b4  bl       #0x5b900   ; CALL objc_msgSend$setOn:
0x000135b8  mov      w8, #0x447a0000
0x000135bc  fmov     s8, w8
0x000135c0  mov      x0, x23
0x000135c4  mov      v0.16b, v8.16b
0x000135c8  mov      x2, #0
0x000135cc  bl       #0x5a9e0   ; CALL objc_msgSend$setContentHuggingPriority:forAxis:
0x000135d0  mov      x0, x23
0x000135d4  mov      v0.16b, v8.16b
0x000135d8  mov      x2, #0
0x000135dc  bl       #0x5a9a0   ; CALL objc_msgSend$setContentCompressionResistancePriority:forAxis:
0x000135e0  adrp     x8, #0x8b000
0x000135e4  ldr      x3, [x8, #0xe20]   ; @SEL "speedBubbleToggled:"
0x000135e8  mov      x0, x23
0x000135ec  mov      x2, x20
0x000135f0  mov      w4, #0x1000
0x000135f4  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x000135f8  adrp     x8, #0x8e000
0x000135fc  ldr      x0, [x8, #0xa38]   ; @CLASS UIStackView
0x00013600  bl       #0x55c7c   ; CALL _objc_alloc
0x00013604  mov      x24, x0
0x00013608  stp      x19, x21, [sp]
0x0001360c  str      x23, [sp, #0x10]
0x00013610  adrp     x8, #0x8e000
0x00013614  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00013618  mov      x2, sp
0x0001361c  mov      w3, #3
0x00013620  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00013624  mov      x29, x29
0x00013628  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001362c  mov      x25, x0
0x00013630  mov      x0, x24
0x00013634  mov      x2, x25
0x00013638  bl       #0x583a0   ; CALL objc_msgSend$initWithArrangedSubviews:
0x0001363c  mov      x24, x0
0x00013640  mov      x0, x25
0x00013644  bl       #0x55d78   ; CALL _objc_release
0x00013648  mov      x0, x24
0x0001364c  mov      x2, #0
0x00013650  bl       #0x5a540   ; CALL objc_msgSend$setAxis:
0x00013654  mov      x0, x24
0x00013658  mov      w2, #3
0x0001365c  bl       #0x5a3a0   ; CALL objc_msgSend$setAlignment:
0x00013660  fmov     d0, #12.00000000
0x00013664  mov      x0, x24
0x00013668  bl       #0x5c240   ; CALL objc_msgSend$setSpacing:
0x0001366c  mov      x0, x24
0x00013670  mov      w2, #1
0x00013674  bl       #0x5b260   ; CALL objc_msgSend$setLayoutMarginsRelativeArrangement:
0x00013678  fmov     d0, #12.00000000
0x0001367c  fmov     d1, #16.00000000
0x00013680  fmov     d2, #12.00000000
0x00013684  fmov     d3, #16.00000000
0x00013688  mov      x0, x24
0x0001368c  bl       #0x5ace0   ; CALL objc_msgSend$setDirectionalLayoutMargins:
0x00013690  bl       #0x17ff8   ; CALL _OMCCardColor
0x00013694  mov      x29, x29
0x00013698  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001369c  mov      x25, x0
0x000136a0  mov      x0, x24
0x000136a4  mov      x2, x25
0x000136a8  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x000136ac  mov      x0, x25
0x000136b0  bl       #0x55d78   ; CALL _objc_release
0x000136b4  mov      x0, x24
0x000136b8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000136bc  mov      x29, x29
0x000136c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000136c4  mov      x25, x0
0x000136c8  fmov     d0, #14.00000000
0x000136cc  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x000136d0  mov      x0, x25
0x000136d4  bl       #0x55d78   ; CALL _objc_release
0x000136d8  adrp     x8, #0x74000
0x000136dc  ldr      x8, [x8, #0x648]   ; @GOT _kCACornerCurveContinuous
0x000136e0  ldr      x25, [x8]   ; @GOT ___objc_personality_v0
0x000136e4  mov      x0, x24
0x000136e8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000136ec  mov      x29, x29
0x000136f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000136f4  mov      x26, x0
0x000136f8  mov      x2, x25
0x000136fc  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x00013700  mov      x0, x26
0x00013704  bl       #0x55d78   ; CALL _objc_release
0x00013708  adrp     x0, #0x78000
0x0001370c  add      x0, x0, #0x408   ; STR "ONB_P3_TITLE"
0x00013710  bl       #0x17e20   ; CALL _L
0x00013714  mov      x29, x29
0x00013718  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001371c  mov      x25, x0
0x00013720  adrp     x0, #0x78000
0x00013724  add      x0, x0, #0x428   ; STR "ONB_P3_BODY"
0x00013728  bl       #0x17e20   ; CALL _L
0x0001372c  mov      x29, x29
0x00013730  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013734  mov      x26, x0
0x00013738  adrp     x0, #0x78000
0x0001373c  add      x0, x0, #0x448   ; STR "ONB_P3_NOTE"
0x00013740  bl       #0x17e20   ; CALL _L
0x00013744  mov      x29, x29
0x00013748  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001374c  mov      x27, x0
0x00013750  adrp     x2, #0x78000
0x00013754  add      x2, x2, #0x3a8   ; STR "speedometer"
0x00013758  mov      x0, x20
0x0001375c  mov      x3, x25
0x00013760  mov      x4, x26
0x00013764  mov      x5, x24
0x00013768  mov      x6, x27
0x0001376c  bl       #0x595c0   ; CALL objc_msgSend$pageWithSymbol:title:body:extra:note:
0x00013770  mov      x29, x29
0x00013774  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013778  mov      x20, x0
0x0001377c  mov      x0, x27
0x00013780  bl       #0x55d78   ; CALL _objc_release
0x00013784  mov      x0, x26
0x00013788  bl       #0x55d78   ; CALL _objc_release
0x0001378c  mov      x0, x25
0x00013790  bl       #0x55d78   ; CALL _objc_release
0x00013794  mov      x0, x24
0x00013798  bl       #0x55d78   ; CALL _objc_release
0x0001379c  mov      x0, x23
0x000137a0  bl       #0x55d78   ; CALL _objc_release
0x000137a4  mov      x0, x22
0x000137a8  bl       #0x55d78   ; CALL _objc_release
0x000137ac  mov      x0, x21
0x000137b0  bl       #0x55d78   ; CALL _objc_release
0x000137b4  mov      x0, x19
0x000137b8  bl       #0x55d78   ; CALL _objc_release
0x000137bc  ldr      x8, [sp, #0x18]
0x000137c0  adrp     x9, #0x74000
0x000137c4  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000137c8  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000137cc  cmp      x9, x8
0x000137d0  b.ne     #0x137fc
0x000137d4  mov      x0, x20
0x000137d8  ldp      x29, x30, [sp, #0x80]
0x000137dc  ldp      x20, x19, [sp, #0x70]
0x000137e0  ldp      x22, x21, [sp, #0x60]
0x000137e4  ldp      x24, x23, [sp, #0x50]
0x000137e8  ldp      x26, x25, [sp, #0x40]
0x000137ec  ldp      x28, x27, [sp, #0x30]
0x000137f0  ldp      d9, d8, [sp, #0x20]
0x000137f4  add      sp, sp, #0x90
0x000137f8  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x000137fc  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCOnboardingController tipsPage]  va=0x13800 size=180 types=@16@0:8
0x00013800  stp      x22, x21, [sp, #-0x30]!
0x00013804  stp      x20, x19, [sp, #0x10]
0x00013808  stp      x29, x30, [sp, #0x20]
0x0001380c  add      x29, sp, #0x20
0x00013810  mov      x19, x0
0x00013814  adrp     x0, #0x78000
0x00013818  add      x0, x0, #0x488   ; STR "ONB_P4_TITLE"
0x0001381c  bl       #0x17e20   ; CALL _L
0x00013820  mov      x29, x29
0x00013824  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013828  mov      x20, x0
0x0001382c  adrp     x0, #0x78000
0x00013830  add      x0, x0, #0x4a8   ; STR "ONB_P4_BODY"
0x00013834  bl       #0x17e20   ; CALL _L
0x00013838  mov      x29, x29
0x0001383c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013840  mov      x21, x0
0x00013844  adrp     x0, #0x78000
0x00013848  add      x0, x0, #0x4c8   ; STR "ONB_P4_NOTE"
0x0001384c  bl       #0x17e20   ; CALL _L
0x00013850  mov      x29, x29
0x00013854  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013858  mov      x22, x0
0x0001385c  adrp     x2, #0x78000
0x00013860  add      x2, x2, #0x468   ; STR "lifepreserver"
0x00013864  mov      x0, x19
0x00013868  mov      x3, x20
0x0001386c  mov      x4, x21
0x00013870  mov      x5, #0
0x00013874  mov      x6, x22
0x00013878  bl       #0x595c0   ; CALL objc_msgSend$pageWithSymbol:title:body:extra:note:
0x0001387c  mov      x29, x29
0x00013880  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013884  mov      x19, x0
0x00013888  mov      x0, x22
0x0001388c  bl       #0x55d78   ; CALL _objc_release
0x00013890  mov      x0, x21
0x00013894  bl       #0x55d78   ; CALL _objc_release
0x00013898  mov      x0, x20
0x0001389c  bl       #0x55d78   ; CALL _objc_release
0x000138a0  mov      x0, x19
0x000138a4  ldp      x29, x30, [sp, #0x20]
0x000138a8  ldp      x20, x19, [sp, #0x10]
0x000138ac  ldp      x22, x21, [sp], #0x30
0x000138b0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCOnboardingController updateControls]  va=0x138b4 size=212 types=v16@0:8
0x000138b4  stp      x22, x21, [sp, #-0x30]!
0x000138b8  stp      x20, x19, [sp, #0x10]
0x000138bc  stp      x29, x30, [sp, #0x20]
0x000138c0  add      x29, sp, #0x20
0x000138c4  mov      x19, x0
0x000138c8  bl       #0x59560   ; CALL objc_msgSend$page
0x000138cc  mov      x20, x0
0x000138d0  mov      x0, x19
0x000138d4  bl       #0x59580   ; CALL objc_msgSend$pageCount
0x000138d8  sub      x21, x0, #1
0x000138dc  mov      x0, x19
0x000138e0  bl       #0x59560   ; CALL objc_msgSend$page
0x000138e4  mov      x2, x0
0x000138e8  adrp     x8, #0x8e000
0x000138ec  ldrsw    x8, [x8, #0xdd4]
0x000138f0  ldr      x0, [x19, x8]
0x000138f4  bl       #0x5aba0   ; CALL objc_msgSend$setCurrentPage:
0x000138f8  cmp      x20, x21
0x000138fc  cset     w2, ge
0x00013900  adrp     x8, #0x8e000
0x00013904  ldrsw    x8, [x8, #0xdd8]
0x00013908  ldr      x0, [x19, x8]
0x0001390c  adrp     x8, #0x78000
0x00013910  add      x8, x8, #0x248   ; STR "ONB_NEXT"
0x00013914  adrp     x9, #0x78000
0x00013918  add      x9, x9, #0x4e8   ; STR "ONB_DONE"
0x0001391c  csel     x20, x9, x8, ge
0x00013920  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x00013924  adrp     x8, #0x8e000
0x00013928  ldrsw    x22, [x8, #0xddc]
0x0001392c  ldr      x0, [x19, x22]
0x00013930  bl       #0x57080   ; CALL objc_msgSend$configuration
0x00013934  mov      x29, x29
0x00013938  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001393c  mov      x21, x0
0x00013940  mov      x0, x20
0x00013944  bl       #0x17e20   ; CALL _L
0x00013948  mov      x29, x29
0x0001394c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013950  mov      x20, x0
0x00013954  mov      x0, x21
0x00013958  mov      x2, x20
0x0001395c  bl       #0x5c5e0   ; CALL objc_msgSend$setTitle:
0x00013960  mov      x0, x20
0x00013964  bl       #0x55d78   ; CALL _objc_release
0x00013968  ldr      x0, [x19, x22]
0x0001396c  mov      x2, x21
0x00013970  bl       #0x5a960   ; CALL objc_msgSend$setConfiguration:
0x00013974  mov      x0, x21
0x00013978  ldp      x29, x30, [sp, #0x20]
0x0001397c  ldp      x20, x19, [sp, #0x10]
0x00013980  ldp      x22, x21, [sp], #0x30
0x00013984  b        #0x55d78   ; CALL _objc_release

=== -[OMCOnboardingController showPage:animated:]  va=0x13988 size=136 types=v28@0:8q16B24
0x00013988  stp      d9, d8, [sp, #-0x40]!
0x0001398c  stp      x22, x21, [sp, #0x10]
0x00013990  stp      x20, x19, [sp, #0x20]
0x00013994  stp      x29, x30, [sp, #0x30]
0x00013998  add      x29, sp, #0x30
0x0001399c  mov      x19, x3
0x000139a0  mov      x20, x2
0x000139a4  mov      x21, x0
0x000139a8  bl       #0x59580   ; CALL objc_msgSend$pageCount
0x000139ac  sub      x8, x0, #1
0x000139b0  cmp      x20, x8
0x000139b4  csel     x8, x20, x8, lt
0x000139b8  bic      x2, x8, x8, asr #63
0x000139bc  mov      x0, x21
0x000139c0  bl       #0x5baa0   ; CALL objc_msgSend$setPage:
0x000139c4  mov      x0, x21
0x000139c8  bl       #0x5dd20   ; CALL objc_msgSend$updateControls
0x000139cc  adrp     x8, #0x8e000
0x000139d0  ldrsw    x22, [x8, #0xdd0]
0x000139d4  ldr      x20, [x21, x22]
0x000139d8  mov      x0, x21
0x000139dc  bl       #0x59560   ; CALL objc_msgSend$page
0x000139e0  scvtf    d8, x0
0x000139e4  ldr      x0, [x21, x22]
0x000139e8  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x000139ec  fmul     d0, d2, d8
0x000139f0  fmov     d1, xzr
0x000139f4  mov      x0, x20
0x000139f8  mov      x2, x19
0x000139fc  ldp      x29, x30, [sp, #0x30]
0x00013a00  ldp      x20, x19, [sp, #0x20]
0x00013a04  ldp      x22, x21, [sp, #0x10]
0x00013a08  ldp      d9, d8, [sp], #0x40
0x00013a0c  b        #0x5aa80   ; CALL objc_msgSend$setContentOffset:animated:

=== -[OMCOnboardingController scrollViewDidScroll:]  va=0x13a10 size=204 types=v24@0:8@16
0x00013a10  stp      d9, d8, [sp, #-0x40]!
0x00013a14  stp      x22, x21, [sp, #0x10]
0x00013a18  stp      x20, x19, [sp, #0x20]
0x00013a1c  stp      x29, x30, [sp, #0x30]
0x00013a20  add      x29, sp, #0x30
0x00013a24  mov      x19, x2
0x00013a28  mov      x20, x0
0x00013a2c  mov      x0, x2
0x00013a30  bl       #0x55d84   ; CALL _objc_retain
0x00013a34  adrp     x8, #0x8e000
0x00013a38  ldrsw    x8, [x8, #0xdd0]
0x00013a3c  ldr      x8, [x20, x8]
0x00013a40  cmp      x19, x8
0x00013a44  b.eq     #0x13a60
0x00013a48  mov      x0, x19
0x00013a4c  ldp      x29, x30, [sp, #0x30]
0x00013a50  ldp      x20, x19, [sp, #0x20]
0x00013a54  ldp      x22, x21, [sp, #0x10]
0x00013a58  ldp      d9, d8, [sp], #0x40
0x00013a5c  b        #0x55d78   ; CALL _objc_release
0x00013a60  mov      x0, x19
0x00013a64  bl       #0x587c0   ; CALL objc_msgSend$isDragging
0x00013a68  tbnz     w0, #0, #0x13a78
0x00013a6c  mov      x0, x19
0x00013a70  bl       #0x587a0   ; CALL objc_msgSend$isDecelerating
0x00013a74  cbz      w0, #0x13a48
0x00013a78  mov      x0, x19
0x00013a7c  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00013a80  fcmp     d2, #0.0
0x00013a84  b.ls     #0x13a48
0x00013a88  mov      v8.16b, v2.16b
0x00013a8c  mov      x0, x19
0x00013a90  bl       #0x57240   ; CALL objc_msgSend$contentOffset
0x00013a94  fdiv     d0, d0, d8
0x00013a98  fcvtas   x21, d0
0x00013a9c  mov      x0, x20
0x00013aa0  bl       #0x59580   ; CALL objc_msgSend$pageCount
0x00013aa4  sub      x8, x0, #1
0x00013aa8  cmp      x21, x8
0x00013aac  csel     x8, x21, x8, lt
0x00013ab0  bic      x21, x8, x8, asr #63
0x00013ab4  mov      x0, x20
0x00013ab8  bl       #0x59560   ; CALL objc_msgSend$page
0x00013abc  cmp      x21, x0
0x00013ac0  b.eq     #0x13a48
0x00013ac4  mov      x0, x20
0x00013ac8  mov      x2, x21
0x00013acc  bl       #0x5baa0   ; CALL objc_msgSend$setPage:
0x00013ad0  mov      x0, x20
0x00013ad4  bl       #0x5dd20   ; CALL objc_msgSend$updateControls
0x00013ad8  b        #0x13a48

=== -[OMCOnboardingController dotsChanged:]  va=0x13adc size=48 types=v24@0:8@16
0x00013adc  stp      x20, x19, [sp, #-0x20]!
0x00013ae0  stp      x29, x30, [sp, #0x10]
0x00013ae4  add      x29, sp, #0x10
0x00013ae8  mov      x19, x0
0x00013aec  mov      x0, x2
0x00013af0  bl       #0x57480   ; CALL objc_msgSend$currentPage
0x00013af4  mov      x2, x0
0x00013af8  mov      x0, x19
0x00013afc  mov      w3, #1
0x00013b00  ldp      x29, x30, [sp, #0x10]
0x00013b04  ldp      x20, x19, [sp], #0x20
0x00013b08  b        #0x5ca60   ; CALL objc_msgSend$showPage:animated:

=== -[OMCOnboardingController nextTapped]  va=0x13b0c size=92 types=v16@0:8
0x00013b0c  stp      x20, x19, [sp, #-0x20]!
0x00013b10  stp      x29, x30, [sp, #0x10]
0x00013b14  add      x29, sp, #0x10
0x00013b18  mov      x19, x0
0x00013b1c  bl       #0x59560   ; CALL objc_msgSend$page
0x00013b20  mov      x20, x0
0x00013b24  mov      x0, x19
0x00013b28  bl       #0x59580   ; CALL objc_msgSend$pageCount
0x00013b2c  sub      x8, x0, #1
0x00013b30  cmp      x20, x8
0x00013b34  b.ge     #0x13b58
0x00013b38  mov      x0, x19
0x00013b3c  bl       #0x59560   ; CALL objc_msgSend$page
0x00013b40  add      x2, x0, #1
0x00013b44  mov      x0, x19
0x00013b48  mov      w3, #1
0x00013b4c  ldp      x29, x30, [sp, #0x10]
0x00013b50  ldp      x20, x19, [sp], #0x20
0x00013b54  b        #0x5ca60   ; CALL objc_msgSend$showPage:animated:
0x00013b58  mov      x0, x19
0x00013b5c  ldp      x29, x30, [sp, #0x10]
0x00013b60  ldp      x20, x19, [sp], #0x20
0x00013b64  b        #0x57c00   ; CALL objc_msgSend$finish

=== -[OMCOnboardingController openApps]  va=0x13b68 size=304 types=v16@0:8
0x00013b68  sub      sp, sp, #0x50
0x00013b6c  stp      x24, x23, [sp, #0x10]
0x00013b70  stp      x22, x21, [sp, #0x20]
0x00013b74  stp      x20, x19, [sp, #0x30]
0x00013b78  stp      x29, x30, [sp, #0x40]
0x00013b7c  add      x29, sp, #0x40
0x00013b80  mov      x19, x0
0x00013b84  adrp     x0, #0x78000
0x00013b88  add      x0, x0, #0x508   ; STR "OMCAppBridgeAppsController"
0x00013b8c  bl       #0x55af0   ; CALL _NSClassFromString
0x00013b90  cbz      x0, #0x13c80
0x00013b94  mov      x21, x0
0x00013b98  adrp     x8, #0x8e000
0x00013b9c  ldr      x0, [x8, #0xa90]   ; @CLASS UIViewController
0x00013ba0  bl       #0x55d48   ; CALL _objc_opt_class
0x00013ba4  mov      x2, x0
0x00013ba8  mov      x0, x21
0x00013bac  bl       #0x58940   ; CALL objc_msgSend$isSubclassOfClass:
0x00013bb0  cbz      w0, #0x13c80
0x00013bb4  mov      x0, x21
0x00013bb8  bl       #0x55d60   ; CALL _objc_opt_new
0x00013bbc  mov      x20, x0
0x00013bc0  adrp     x8, #0x8d000
0x00013bc4  ldr      x1, [x8, #0x848]   ; @SEL "setSpecifier:"
0x00013bc8  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x00013bcc  tbz      w0, #0, #0x13c3c
0x00013bd0  adrp     x8, #0x8e000
0x00013bd4  ldr      x22, [x8, #0xa98]   ; @CLASS PSSpecifier
0x00013bd8  adrp     x0, #0x76000
0x00013bdc  add      x0, x0, #0xec8   ; STR "APPS"
0x00013be0  bl       #0x17e20   ; CALL _L
0x00013be4  mov      x29, x29
0x00013be8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013bec  mov      x23, x0
0x00013bf0  str      xzr, [sp]
0x00013bf4  mov      x0, x22
0x00013bf8  mov      x2, x23
0x00013bfc  mov      x3, #0
0x00013c00  mov      x4, #0
0x00013c04  mov      x5, #0
0x00013c08  mov      x6, x21
0x00013c0c  mov      w7, #1
0x00013c10  bl       #0x598e0   ; CALL objc_msgSend$preferenceSpecifierNamed:target:set:get:detail:cell:edit:
0x00013c14  mov      x29, x29
0x00013c18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013c1c  mov      x21, x0
0x00013c20  mov      x0, x23
0x00013c24  bl       #0x55d78   ; CALL _objc_release
0x00013c28  mov      x0, x20
0x00013c2c  mov      x2, x21
0x00013c30  bl       #0x5c260   ; CALL objc_msgSend$setSpecifier:
0x00013c34  mov      x0, x21
0x00013c38  bl       #0x55d78   ; CALL _objc_release
0x00013c3c  mov      x0, x19
0x00013c40  bl       #0x59180   ; CALL objc_msgSend$navigationController
0x00013c44  mov      x29, x29
0x00013c48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013c4c  mov      x19, x0
0x00013c50  mov      x2, x20
0x00013c54  mov      w3, #1
0x00013c58  bl       #0x59ae0   ; CALL objc_msgSend$pushViewController:animated:
0x00013c5c  mov      x0, x19
0x00013c60  bl       #0x55d78   ; CALL _objc_release
0x00013c64  mov      x0, x20
0x00013c68  ldp      x29, x30, [sp, #0x40]
0x00013c6c  ldp      x20, x19, [sp, #0x30]
0x00013c70  ldp      x22, x21, [sp, #0x20]
0x00013c74  ldp      x24, x23, [sp, #0x10]
0x00013c78  add      sp, sp, #0x50
0x00013c7c  b        #0x55d78   ; CALL _objc_release
0x00013c80  ldp      x29, x30, [sp, #0x40]
0x00013c84  ldp      x20, x19, [sp, #0x30]
0x00013c88  ldp      x22, x21, [sp, #0x20]
0x00013c8c  ldp      x24, x23, [sp, #0x10]
0x00013c90  add      sp, sp, #0x50
0x00013c94  ret      

=== -[OMCOnboardingController speedBubbleToggled:]  va=0x13c98 size=96 types=v24@0:8@16
0x00013c98  stp      x20, x19, [sp, #-0x20]!
0x00013c9c  stp      x29, x30, [sp, #0x10]
0x00013ca0  add      x29, sp, #0x10
0x00013ca4  mov      x0, x2
0x00013ca8  adrp     x8, #0x8e000
0x00013cac  ldr      x19, [x8, #0x928]   ; @CLASS NSNumber
0x00013cb0  bl       #0x588c0   ; CALL objc_msgSend$isOn
0x00013cb4  mov      x2, x0
0x00013cb8  mov      x0, x19
0x00013cbc  bl       #0x592c0   ; CALL objc_msgSend$numberWithBool:
0x00013cc0  mov      x1, x0
0x00013cc4  adrp     x0, #0x78000
0x00013cc8  add      x0, x0, #0x3e8   ; STR "speedBubbleEnabled"
0x00013ccc  adrp     x19, #0x75000
0x00013cd0  add      x19, x19, #0x28   ; STR "com.anlai.omnicar"
0x00013cd4  mov      x2, x19
0x00013cd8  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x00013cdc  mov      x0, x19
0x00013ce0  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x00013ce4  adrp     x0, #0x61000
0x00013ce8  add      x0, x0, #0x1b1   ; CSTR "com.anlai.omnicar/prefschanged"
0x00013cec  ldp      x29, x30, [sp, #0x10]
0x00013cf0  ldp      x20, x19, [sp], #0x20
0x00013cf4  b        #0x55c70   ; CALL _notify_post

=== -[OMCOnboardingController finish]  va=0x13cf8 size=172 types=v16@0:8
0x00013cf8  sub      sp, sp, #0x60
0x00013cfc  stp      x22, x21, [sp, #0x30]
0x00013d00  stp      x20, x19, [sp, #0x40]
0x00013d04  stp      x29, x30, [sp, #0x50]
0x00013d08  add      x29, sp, #0x50
0x00013d0c  mov      x19, x0
0x00013d10  bl       #0x58f20   ; CALL objc_msgSend$markDone
0x00013d14  mov      x0, x19
0x00013d18  bl       #0x59180   ; CALL objc_msgSend$navigationController
0x00013d1c  mov      x29, x29
0x00013d20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013d24  mov      x20, x0
0x00013d28  cmp      x0, #0
0x00013d2c  csel     x21, x19, x0, eq
0x00013d30  mov      x0, x21
0x00013d34  bl       #0x55d84   ; CALL _objc_retain
0x00013d38  mov      x0, x20
0x00013d3c  bl       #0x55d78   ; CALL _objc_release
0x00013d40  adrp     x8, #0x74000
0x00013d44  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00013d48  str      x8, [sp, #8]
0x00013d4c  adrp     x8, #0x65000
0x00013d50  ldr      d0, [x8, #0x600]
0x00013d54  adrp     x8, #0x13000
0x00013d58  add      x8, x8, #0xd9c
0x00013d5c  str      d0, [sp, #0x10]
0x00013d60  adrp     x9, #0x74000
0x00013d64  add      x9, x9, #0x6e0
0x00013d68  stp      x8, x9, [sp, #0x18]
0x00013d6c  str      x19, [sp, #0x28]
0x00013d70  add      x3, sp, #8
0x00013d74  mov      x0, x21
0x00013d78  mov      w2, #1
0x00013d7c  bl       #0x57820   ; CALL objc_msgSend$dismissViewControllerAnimated:completion:
0x00013d80  mov      x0, x21
0x00013d84  bl       #0x55d78   ; CALL _objc_release
0x00013d88  ldp      x29, x30, [sp, #0x50]
0x00013d8c  ldp      x20, x19, [sp, #0x40]
0x00013d90  ldp      x22, x21, [sp, #0x30]
0x00013d94  add      sp, sp, #0x60
0x00013d98  ret      
0x00013d9c  ldr      x0, [x0, #0x20]
0x00013da0  b        #0x59fe0   ; CALL objc_msgSend$runCompletion

=== -[OMCOnboardingController markDone]  va=0x13da4 size=64 types=v16@0:8
0x00013da4  stp      x20, x19, [sp, #-0x20]!
0x00013da8  stp      x29, x30, [sp, #0x10]
0x00013dac  add      x29, sp, #0x10
0x00013db0  adrp     x8, #0x74000
0x00013db4  ldr      x8, [x8, #0x1c0]   ; @GOT _kCFBooleanTrue
0x00013db8  ldr      x1, [x8]   ; @GOT ___objc_personality_v0
0x00013dbc  adrp     x0, #0x78000
0x00013dc0  add      x0, x0, #0x208   ; STR "onboardingDone"
0x00013dc4  adrp     x19, #0x75000
0x00013dc8  add      x19, x19, #0x28   ; STR "com.anlai.omnicar"
0x00013dcc  mov      x2, x19
0x00013dd0  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x00013dd4  mov      x0, x19
0x00013dd8  ldp      x29, x30, [sp, #0x10]
0x00013ddc  ldp      x20, x19, [sp], #0x20
0x00013de0  b        #0x55850   ; CALL _CFPreferencesAppSynchronize

=== -[OMCOnboardingController runCompletion]  va=0x13de4 size=120 types=v16@0:8
0x00013de4  stp      x20, x19, [sp, #-0x20]!
0x00013de8  stp      x29, x30, [sp, #0x10]
0x00013dec  add      x29, sp, #0x10
0x00013df0  mov      x19, x0
0x00013df4  bl       #0x56e40   ; CALL objc_msgSend$closed
0x00013df8  tbnz     w0, #0, #0x13e50
0x00013dfc  mov      x0, x19
0x00013e00  mov      w2, #1
0x00013e04  bl       #0x5a8c0   ; CALL objc_msgSend$setClosed:
0x00013e08  mov      x0, x19
0x00013e0c  bl       #0x56fa0   ; CALL objc_msgSend$completion
0x00013e10  mov      x29, x29
0x00013e14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013e18  mov      x20, x0
0x00013e1c  bl       #0x55d78   ; CALL _objc_release
0x00013e20  cbz      x20, #0x13e50
0x00013e24  mov      x0, x19
0x00013e28  bl       #0x56fa0   ; CALL objc_msgSend$completion
0x00013e2c  mov      x29, x29
0x00013e30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00013e34  mov      x19, x0
0x00013e38  ldr      x8, [x0, #0x10]
0x00013e3c  blr      x8
0x00013e40  mov      x0, x19
0x00013e44  ldp      x29, x30, [sp, #0x10]
0x00013e48  ldp      x20, x19, [sp], #0x20
0x00013e4c  b        #0x55d78   ; CALL _objc_release
0x00013e50  ldp      x29, x30, [sp, #0x10]
0x00013e54  ldp      x20, x19, [sp], #0x20
0x00013e58  ret      

=== -[OMCOnboardingController presentationControllerDidDismiss:]  va=0x13e5c size=36 types=v24@0:8@16
0x00013e5c  stp      x20, x19, [sp, #-0x20]!
0x00013e60  stp      x29, x30, [sp, #0x10]
0x00013e64  add      x29, sp, #0x10
0x00013e68  mov      x19, x0
0x00013e6c  bl       #0x58f20   ; CALL objc_msgSend$markDone
0x00013e70  mov      x0, x19
0x00013e74  ldp      x29, x30, [sp, #0x10]
0x00013e78  ldp      x20, x19, [sp], #0x20
0x00013e7c  b        #0x59fe0   ; CALL objc_msgSend$runCompletion

=== -[OMCOnboardingController pager]  va=0x13e80 size=16 types=@16@0:8
0x00013e80  adrp     x8, #0x8e000
0x00013e84  ldrsw    x8, [x8, #0xdd0]
0x00013e88  ldr      x0, [x0, x8]
0x00013e8c  ret      

=== -[OMCOnboardingController setPager:]  va=0x13e90 size=64 types=v24@0:8@16
0x00013e90  stp      x22, x21, [sp, #-0x30]!
0x00013e94  stp      x20, x19, [sp, #0x10]
0x00013e98  stp      x29, x30, [sp, #0x20]
0x00013e9c  add      x29, sp, #0x20
0x00013ea0  mov      x19, x2
0x00013ea4  mov      x20, x0
0x00013ea8  adrp     x8, #0x8e000
0x00013eac  ldrsw    x21, [x8, #0xdd0]
0x00013eb0  mov      x0, x2
0x00013eb4  bl       #0x55d84   ; CALL _objc_retain
0x00013eb8  ldr      x0, [x20, x21]
0x00013ebc  str      x19, [x20, x21]
0x00013ec0  ldp      x29, x30, [sp, #0x20]
0x00013ec4  ldp      x20, x19, [sp, #0x10]
0x00013ec8  ldp      x22, x21, [sp], #0x30
0x00013ecc  b        #0x55d78   ; CALL _objc_release

=== -[OMCOnboardingController dots]  va=0x13ed0 size=16 types=@16@0:8
0x00013ed0  adrp     x8, #0x8e000
0x00013ed4  ldrsw    x8, [x8, #0xdd4]
0x00013ed8  ldr      x0, [x0, x8]
0x00013edc  ret      

=== -[OMCOnboardingController setDots:]  va=0x13ee0 size=64 types=v24@0:8@16
0x00013ee0  stp      x22, x21, [sp, #-0x30]!
0x00013ee4  stp      x20, x19, [sp, #0x10]
0x00013ee8  stp      x29, x30, [sp, #0x20]
0x00013eec  add      x29, sp, #0x20
0x00013ef0  mov      x19, x2
0x00013ef4  mov      x20, x0
0x00013ef8  adrp     x8, #0x8e000
0x00013efc  ldrsw    x21, [x8, #0xdd4]
0x00013f00  mov      x0, x2
0x00013f04  bl       #0x55d84   ; CALL _objc_retain
0x00013f08  ldr      x0, [x20, x21]
0x00013f0c  str      x19, [x20, x21]
0x00013f10  ldp      x29, x30, [sp, #0x20]
0x00013f14  ldp      x20, x19, [sp, #0x10]
0x00013f18  ldp      x22, x21, [sp], #0x30
0x00013f1c  b        #0x55d78   ; CALL _objc_release

=== -[OMCOnboardingController skipButton]  va=0x13f20 size=16 types=@16@0:8
0x00013f20  adrp     x8, #0x8e000
0x00013f24  ldrsw    x8, [x8, #0xdd8]
0x00013f28  ldr      x0, [x0, x8]
0x00013f2c  ret      

=== -[OMCOnboardingController setSkipButton:]  va=0x13f30 size=64 types=v24@0:8@16
0x00013f30  stp      x22, x21, [sp, #-0x30]!
0x00013f34  stp      x20, x19, [sp, #0x10]
0x00013f38  stp      x29, x30, [sp, #0x20]
0x00013f3c  add      x29, sp, #0x20
0x00013f40  mov      x19, x2
0x00013f44  mov      x20, x0
0x00013f48  adrp     x8, #0x8e000
0x00013f4c  ldrsw    x21, [x8, #0xdd8]
0x00013f50  mov      x0, x2
0x00013f54  bl       #0x55d84   ; CALL _objc_retain
0x00013f58  ldr      x0, [x20, x21]
0x00013f5c  str      x19, [x20, x21]
0x00013f60  ldp      x29, x30, [sp, #0x20]
0x00013f64  ldp      x20, x19, [sp, #0x10]
0x00013f68  ldp      x22, x21, [sp], #0x30
0x00013f6c  b        #0x55d78   ; CALL _objc_release

=== -[OMCOnboardingController nextButton]  va=0x13f70 size=16 types=@16@0:8
0x00013f70  adrp     x8, #0x8e000
0x00013f74  ldrsw    x8, [x8, #0xddc]
0x00013f78  ldr      x0, [x0, x8]
0x00013f7c  ret      

=== -[OMCOnboardingController setNextButton:]  va=0x13f80 size=64 types=v24@0:8@16
0x00013f80  stp      x22, x21, [sp, #-0x30]!
0x00013f84  stp      x20, x19, [sp, #0x10]
0x00013f88  stp      x29, x30, [sp, #0x20]
0x00013f8c  add      x29, sp, #0x20
0x00013f90  mov      x19, x2
0x00013f94  mov      x20, x0
0x00013f98  adrp     x8, #0x8e000
0x00013f9c  ldrsw    x21, [x8, #0xddc]
0x00013fa0  mov      x0, x2
0x00013fa4  bl       #0x55d84   ; CALL _objc_retain
0x00013fa8  ldr      x0, [x20, x21]
0x00013fac  str      x19, [x20, x21]
0x00013fb0  ldp      x29, x30, [sp, #0x20]
0x00013fb4  ldp      x20, x19, [sp, #0x10]
0x00013fb8  ldp      x22, x21, [sp], #0x30
0x00013fbc  b        #0x55d78   ; CALL _objc_release

=== -[OMCOnboardingController page]  va=0x13fc0 size=16 types=q16@0:8
0x00013fc0  adrp     x8, #0x8e000
0x00013fc4  ldrsw    x8, [x8, #0xde0]
0x00013fc8  ldr      x0, [x0, x8]
0x00013fcc  ret      

=== -[OMCOnboardingController setPage:]  va=0x13fd0 size=16 types=v24@0:8q16
0x00013fd0  adrp     x8, #0x8e000
0x00013fd4  ldrsw    x8, [x8, #0xde0]
0x00013fd8  str      x2, [x0, x8]
0x00013fdc  ret      

=== -[OMCOnboardingController pageCount]  va=0x13fe0 size=16 types=q16@0:8
0x00013fe0  adrp     x8, #0x8e000
0x00013fe4  ldrsw    x8, [x8, #0xde4]
0x00013fe8  ldr      x0, [x0, x8]
0x00013fec  ret      

=== -[OMCOnboardingController setPageCount:]  va=0x13ff0 size=16 types=v24@0:8q16
0x00013ff0  adrp     x8, #0x8e000
0x00013ff4  ldrsw    x8, [x8, #0xde4]
0x00013ff8  str      x2, [x0, x8]
0x00013ffc  ret      

=== -[OMCOnboardingController laidOutWidth]  va=0x14000 size=16 types=d16@0:8
0x00014000  adrp     x8, #0x8e000
0x00014004  ldrsw    x8, [x8, #0xde8]
0x00014008  ldr      d0, [x0, x8]
0x0001400c  ret      

=== -[OMCOnboardingController setLaidOutWidth:]  va=0x14010 size=16 types=v24@0:8d16
0x00014010  adrp     x8, #0x8e000
0x00014014  ldrsw    x8, [x8, #0xde8]
0x00014018  str      d0, [x0, x8]
0x0001401c  ret      

=== -[OMCOnboardingController closed]  va=0x14020 size=16 types=B16@0:8
0x00014020  adrp     x8, #0x8e000
0x00014024  ldrsw    x8, [x8, #0xdec]
0x00014028  ldrb     w0, [x0, x8]
0x0001402c  ret      

=== -[OMCOnboardingController setClosed:]  va=0x14030 size=16 types=v20@0:8B16
0x00014030  adrp     x8, #0x8e000
0x00014034  ldrsw    x8, [x8, #0xdec]
0x00014038  strb     w2, [x0, x8]
0x0001403c  ret      

=== -[OMCOnboardingController completion]  va=0x14040 size=16 types=@?16@0:8
0x00014040  adrp     x8, #0x8e000
0x00014044  ldrsw    x8, [x8, #0xdf0]
0x00014048  ldr      x0, [x0, x8]
0x0001404c  ret      

=== -[OMCOnboardingController setCompletion:]  va=0x14050 size=12 types=v24@0:8@?16
0x00014050  adrp     x8, #0x8e000
0x00014054  ldrsw    x3, [x8, #0xdf0]
0x00014058  b        #0x55dc0   ; CALL _objc_setProperty_nonatomic_copy

=== -[OMCOnboardingController .cxx_destruct]  va=0x1405c size=124 types=v16@0:8
0x0001405c  stp      x20, x19, [sp, #-0x20]!
0x00014060  stp      x29, x30, [sp, #0x10]
0x00014064  add      x29, sp, #0x10
0x00014068  mov      x19, x0
0x0001406c  adrp     x8, #0x8e000
0x00014070  ldrsw    x8, [x8, #0xdf0]
0x00014074  add      x0, x0, x8
0x00014078  mov      x1, #0
0x0001407c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00014080  adrp     x8, #0x8e000
0x00014084  ldrsw    x8, [x8, #0xddc]
0x00014088  add      x0, x19, x8
0x0001408c  mov      x1, #0
0x00014090  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00014094  adrp     x8, #0x8e000
0x00014098  ldrsw    x8, [x8, #0xdd8]
0x0001409c  add      x0, x19, x8
0x000140a0  mov      x1, #0
0x000140a4  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000140a8  adrp     x8, #0x8e000
0x000140ac  ldrsw    x8, [x8, #0xdd4]
0x000140b0  add      x0, x19, x8
0x000140b4  mov      x1, #0
0x000140b8  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000140bc  adrp     x8, #0x8e000
0x000140c0  ldrsw    x8, [x8, #0xdd0]
0x000140c4  add      x0, x19, x8
0x000140c8  mov      x1, #0
0x000140cc  ldp      x29, x30, [sp, #0x10]
0x000140d0  ldp      x20, x19, [sp], #0x20
0x000140d4  b        #0x55dcc   ; CALL _objc_storeStrong
