=== -[OMCSplitScreenController viewDidLoad]  va=0x382d4 size=156 types=v16@0:8
0x000382d4  sub      sp, sp, #0x40
0x000382d8  stp      x22, x21, [sp, #0x10]
0x000382dc  stp      x20, x19, [sp, #0x20]
0x000382e0  stp      x29, x30, [sp, #0x30]
0x000382e4  add      x29, sp, #0x30
0x000382e8  mov      x19, x0
0x000382ec  adrp     x8, #0x8e000
0x000382f0  ldr      x8, [x8, #0xda0]   ; @SUPER OMCSplitScreenController
0x000382f4  stp      x0, x8, [sp]
0x000382f8  adrp     x8, #0x8b000
0x000382fc  ldr      x1, [x8, #0xda0]   ; @SEL "viewDidLoad"
0x00038300  mov      x0, sp
0x00038304  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00038308  mov      x0, x19
0x0003830c  bl       #0x5db40   ; CALL objc_msgSend$title
0x00038310  mov      x29, x29
0x00038314  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038318  mov      x20, x0
0x0003831c  bl       #0x58c20   ; CALL objc_msgSend$length
0x00038320  mov      x21, x0
0x00038324  mov      x0, x20
0x00038328  bl       #0x55d78   ; CALL _objc_release
0x0003832c  cbnz     x21, #0x3835c
0x00038330  adrp     x0, #0x7b000
0x00038334  add      x0, x0, #0xae8   ; STR "SPLITSCREEN"
0x00038338  bl       #0x17e20   ; CALL _L
0x0003833c  mov      x29, x29
0x00038340  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038344  mov      x20, x0
0x00038348  mov      x0, x19
0x0003834c  mov      x2, x20
0x00038350  bl       #0x5c5e0   ; CALL objc_msgSend$setTitle:
0x00038354  mov      x0, x20
0x00038358  bl       #0x55d78   ; CALL _objc_release
0x0003835c  ldp      x29, x30, [sp, #0x30]
0x00038360  ldp      x20, x19, [sp, #0x20]
0x00038364  ldp      x22, x21, [sp, #0x10]
0x00038368  add      sp, sp, #0x40
0x0003836c  ret      

=== -[OMCSplitScreenController on]  va=0x38370 size=76 types=B16@0:8
0x00038370  stp      x20, x19, [sp, #-0x20]!
0x00038374  stp      x29, x30, [sp, #0x10]
0x00038378  add      x29, sp, #0x10
0x0003837c  adrp     x2, #0x7b000
0x00038380  add      x2, x2, #0xb08   ; STR "splitScreenEnabled"
0x00038384  adrp     x3, #0x74000
0x00038388  ldr      x3, [x3, #0x1b8]   ; @GOT ___kCFBooleanTrue
0x0003838c  bl       #0x598c0   ; CALL objc_msgSend$prefForKey:def:
0x00038390  mov      x29, x29
0x00038394  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038398  mov      x19, x0
0x0003839c  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x000383a0  mov      x20, x0
0x000383a4  mov      x0, x19
0x000383a8  bl       #0x55d78   ; CALL _objc_release
0x000383ac  mov      x0, x20
0x000383b0  ldp      x29, x30, [sp, #0x10]
0x000383b4  ldp      x20, x19, [sp], #0x20
0x000383b8  ret      

=== -[OMCSplitScreenController stringForKey:]  va=0x383bc size=112 types=@24@0:8@16
0x000383bc  stp      x20, x19, [sp, #-0x20]!
0x000383c0  stp      x29, x30, [sp, #0x10]
0x000383c4  add      x29, sp, #0x10
0x000383c8  mov      x3, #0
0x000383cc  bl       #0x598c0   ; CALL objc_msgSend$prefForKey:def:
0x000383d0  mov      x29, x29
0x000383d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000383d8  mov      x19, x0
0x000383dc  adrp     x8, #0x8e000
0x000383e0  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x000383e4  bl       #0x55d48   ; CALL _objc_opt_class
0x000383e8  mov      x1, x0
0x000383ec  mov      x0, x19
0x000383f0  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x000383f4  mov      x20, #0
0x000383f8  tbz      w0, #0, #0x3840c
0x000383fc  mov      x0, x19
0x00038400  bl       #0x58c20   ; CALL objc_msgSend$length
0x00038404  cmp      x0, #0
0x00038408  csel     x20, xzr, x19, eq
0x0003840c  mov      x0, x20
0x00038410  bl       #0x55d84   ; CALL _objc_retain
0x00038414  mov      x0, x19
0x00038418  bl       #0x55d78   ; CALL _objc_release
0x0003841c  mov      x0, x20
0x00038420  ldp      x29, x30, [sp, #0x10]
0x00038424  ldp      x20, x19, [sp], #0x20
0x00038428  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCSplitScreenController layoutOf:]  va=0x3842c size=136 types=q24@0:8q16
0x0003842c  sub      sp, sp, #0x40
0x00038430  stp      x22, x21, [sp, #0x10]
0x00038434  stp      x20, x19, [sp, #0x20]
0x00038438  stp      x29, x30, [sp, #0x30]
0x0003843c  add      x29, sp, #0x30
0x00038440  mov      x19, x0
0x00038444  adrp     x8, #0x8e000
0x00038448  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0003844c  adrp     x8, #0x7b000
0x00038450  add      x8, x8, #0xb48   ; STR "Layout"
0x00038454  stp      x2, x8, [sp]
0x00038458  adrp     x2, #0x7b000
0x0003845c  add      x2, x2, #0xb28   ; STR "splitScreenFav%ld%@"
0x00038460  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00038464  mov      x29, x29
0x00038468  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003846c  mov      x20, x0
0x00038470  mov      w21, #2
0x00038474  mov      x0, x19
0x00038478  mov      x2, x20
0x0003847c  mov      w3, #2
0x00038480  bl       #0x58700   ; CALL objc_msgSend$intForKey:def:
0x00038484  mov      x19, x0
0x00038488  mov      x0, x20
0x0003848c  bl       #0x55d78   ; CALL _objc_release
0x00038490  cmp      x19, #0xd
0x00038494  ccmp     x19, #3, #4, ne
0x00038498  ccmp     x19, #0x1f, #4, ne
0x0003849c  csel     x0, x19, x21, eq
0x000384a0  ldp      x29, x30, [sp, #0x30]
0x000384a4  ldp      x20, x19, [sp, #0x20]
0x000384a8  ldp      x22, x21, [sp, #0x10]
0x000384ac  add      sp, sp, #0x40
0x000384b0  ret      

=== -[OMCSplitScreenController boxCount:]  va=0x384b4 size=16 types=q24@0:8q16
0x000384b4  cmp      x2, #2
0x000384b8  mov      w8, #2
0x000384bc  cinc     x0, x8, ne
0x000384c0  ret      

=== -[OMCSplitScreenController appsOf:]  va=0x384c4 size=384 types=@24@0:8q16
0x000384c4  sub      sp, sp, #0x140
0x000384c8  stp      x28, x27, [sp, #0xe0]
0x000384cc  stp      x26, x25, [sp, #0xf0]
0x000384d0  stp      x24, x23, [sp, #0x100]
0x000384d4  stp      x22, x21, [sp, #0x110]
0x000384d8  stp      x20, x19, [sp, #0x120]
0x000384dc  stp      x29, x30, [sp, #0x130]
0x000384e0  add      x29, sp, #0x130
0x000384e4  mov      x19, x2
0x000384e8  mov      x20, x0
0x000384ec  adrp     x8, #0x74000
0x000384f0  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000384f4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000384f8  stur     x8, [x29, #-0x60]
0x000384fc  adrp     x8, #0x8e000
0x00038500  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00038504  bl       #0x565c0   ; CALL objc_msgSend$array
0x00038508  mov      x29, x29
0x0003850c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038510  mov      x21, x0
0x00038514  movi     v0.16b, #0
0x00038518  stp      q0, q0, [sp, #0x10]
0x0003851c  stp      q0, q0, [sp, #0x30]
0x00038520  adrp     x0, #0x7f000
0x00038524  add      x0, x0, #0xc00
0x00038528  add      x2, sp, #0x10
0x0003852c  add      x3, sp, #0x50
0x00038530  mov      w4, #0x10
0x00038534  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00038538  cbz      x0, #0x38604
0x0003853c  mov      x23, x0
0x00038540  ldr      x8, [sp, #0x20]
0x00038544  ldr      x27, [x8]   ; @SEL "whatsNewNavigationController"
0x00038548  adrp     x22, #0x7b000
0x0003854c  add      x22, x22, #0xb28   ; STR "splitScreenFav%ld%@"
0x00038550  adrp     x24, #0x75000
0x00038554  add      x24, x24, #0xd28
0x00038558  mov      x28, #0
0x0003855c  ldr      x8, [sp, #0x20]
0x00038560  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00038564  cmp      x8, x27
0x00038568  b.eq     #0x38578
0x0003856c  adrp     x0, #0x7f000
0x00038570  add      x0, x0, #0xc00
0x00038574  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00038578  ldr      x8, [sp, #0x18]
0x0003857c  ldr      x8, [x8, x28, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00038580  adrp     x9, #0x8e000
0x00038584  ldr      x0, [x9, #0x958]   ; @CLASS NSString
0x00038588  stp      x19, x8, [sp]
0x0003858c  mov      x2, x22
0x00038590  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00038594  mov      x29, x29
0x00038598  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003859c  mov      x25, x0
0x000385a0  mov      x0, x20
0x000385a4  mov      x2, x25
0x000385a8  bl       #0x5d4e0   ; CALL objc_msgSend$stringForKey:
0x000385ac  mov      x29, x29
0x000385b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000385b4  mov      x26, x0
0x000385b8  cmp      x0, #0
0x000385bc  csel     x2, x24, x0, eq
0x000385c0  mov      x0, x21
0x000385c4  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x000385c8  mov      x0, x26
0x000385cc  bl       #0x55d78   ; CALL _objc_release
0x000385d0  mov      x0, x25
0x000385d4  bl       #0x55d78   ; CALL _objc_release
0x000385d8  add      x28, x28, #1
0x000385dc  cmp      x23, x28
0x000385e0  b.ne     #0x3855c
0x000385e4  add      x2, sp, #0x10
0x000385e8  add      x3, sp, #0x50
0x000385ec  adrp     x0, #0x7f000
0x000385f0  add      x0, x0, #0xc00
0x000385f4  mov      w4, #0x10
0x000385f8  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000385fc  mov      x23, x0
0x00038600  cbnz     x0, #0x38558
0x00038604  ldur     x8, [x29, #-0x60]
0x00038608  adrp     x9, #0x74000
0x0003860c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00038610  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00038614  cmp      x9, x8
0x00038618  b.ne     #0x38640
0x0003861c  mov      x0, x21
0x00038620  ldp      x29, x30, [sp, #0x130]
0x00038624  ldp      x20, x19, [sp, #0x120]
0x00038628  ldp      x22, x21, [sp, #0x110]
0x0003862c  ldp      x24, x23, [sp, #0x100]
0x00038630  ldp      x26, x25, [sp, #0xf0]
0x00038634  ldp      x28, x27, [sp, #0xe0]
0x00038638  add      sp, sp, #0x140
0x0003863c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00038640  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCSplitScreenController nameOf:]  va=0x38644 size=212 types=@24@0:8q16
0x00038644  sub      sp, sp, #0x40
0x00038648  stp      x22, x21, [sp, #0x10]
0x0003864c  stp      x20, x19, [sp, #0x20]
0x00038650  stp      x29, x30, [sp, #0x30]
0x00038654  add      x29, sp, #0x30
0x00038658  mov      x21, x2
0x0003865c  mov      x20, x0
0x00038660  adrp     x22, #0x8e000
0x00038664  ldr      x0, [x22, #0x958]   ; @CLASS NSString
0x00038668  adrp     x8, #0x77000
0x0003866c  add      x8, x8, #0x108   ; STR "Name"
0x00038670  stp      x2, x8, [sp]
0x00038674  adrp     x2, #0x7b000
0x00038678  add      x2, x2, #0xb28   ; STR "splitScreenFav%ld%@"
0x0003867c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00038680  mov      x29, x29
0x00038684  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038688  mov      x19, x0
0x0003868c  mov      x0, x20
0x00038690  mov      x2, x19
0x00038694  bl       #0x5d4e0   ; CALL objc_msgSend$stringForKey:
0x00038698  mov      x29, x29
0x0003869c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000386a0  mov      x20, x0
0x000386a4  cbz      x0, #0x386b8
0x000386a8  mov      x0, x20
0x000386ac  bl       #0x55d84   ; CALL _objc_retain
0x000386b0  mov      x21, x20
0x000386b4  b        #0x386f0
0x000386b8  ldr      x0, [x22, #0x958]   ; @CLASS NSString
0x000386bc  str      x21, [sp]
0x000386c0  adrp     x2, #0x7b000
0x000386c4  add      x2, x2, #0xbc8   ; STR "SPLITSCREEN_FAV%ld_PLACEHOLDER"
0x000386c8  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x000386cc  mov      x29, x29
0x000386d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000386d4  mov      x22, x0
0x000386d8  bl       #0x17e20   ; CALL _L
0x000386dc  mov      x29, x29
0x000386e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000386e4  mov      x21, x0
0x000386e8  mov      x0, x22
0x000386ec  bl       #0x55d78   ; CALL _objc_release
0x000386f0  mov      x0, x20
0x000386f4  bl       #0x55d78   ; CALL _objc_release
0x000386f8  mov      x0, x19
0x000386fc  bl       #0x55d78   ; CALL _objc_release
0x00038700  mov      x0, x21
0x00038704  ldp      x29, x30, [sp, #0x30]
0x00038708  ldp      x20, x19, [sp, #0x20]
0x0003870c  ldp      x22, x21, [sp, #0x10]
0x00038710  add      sp, sp, #0x40
0x00038714  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCSplitScreenController urls]  va=0x38718 size=84 types=@16@0:8
0x00038718  stp      x20, x19, [sp, #-0x20]!
0x0003871c  stp      x29, x30, [sp, #0x10]
0x00038720  add      x29, sp, #0x10
0x00038724  adrp     x0, #0x7b000
0x00038728  add      x0, x0, #0xbe8   ; STR "SPLITSCREEN_SHORTCUTS_FOOTER"
0x0003872c  bl       #0x17e20   ; CALL _L
0x00038730  mov      x29, x29
0x00038734  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038738  mov      x19, x0
0x0003873c  adrp     x2, #0x75000
0x00038740  add      x2, x2, #0xbe8   ; STR "\n"
0x00038744  bl       #0x57040   ; CALL objc_msgSend$componentsSeparatedByString:
0x00038748  mov      x29, x29
0x0003874c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038750  mov      x20, x0
0x00038754  mov      x0, x19
0x00038758  bl       #0x55d78   ; CALL _objc_release
0x0003875c  mov      x0, x20
0x00038760  ldp      x29, x30, [sp, #0x10]
0x00038764  ldp      x20, x19, [sp], #0x20
0x00038768  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCSplitScreenController prefChanged:]  va=0x3876c size=92 types=v24@0:8@16
0x0003876c  stp      x20, x19, [sp, #-0x20]!
0x00038770  stp      x29, x30, [sp, #0x10]
0x00038774  add      x29, sp, #0x10
0x00038778  mov      x8, x2
0x0003877c  mov      x19, x0
0x00038780  adrp     x2, #0x7b000
0x00038784  add      x2, x2, #0xb08   ; STR "splitScreenEnabled"
0x00038788  mov      x0, x8
0x0003878c  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00038790  cbz      w0, #0x387bc
0x00038794  mov      x0, x19
0x00038798  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x0003879c  mov      x29, x29
0x000387a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000387a4  mov      x19, x0
0x000387a8  bl       #0x59ca0   ; CALL objc_msgSend$reloadData
0x000387ac  mov      x0, x19
0x000387b0  ldp      x29, x30, [sp, #0x10]
0x000387b4  ldp      x20, x19, [sp], #0x20
0x000387b8  b        #0x55d78   ; CALL _objc_release
0x000387bc  ldp      x29, x30, [sp, #0x10]
0x000387c0  ldp      x20, x19, [sp], #0x20
0x000387c4  ret      

=== -[OMCSplitScreenController numberOfSectionsInTableView:]  va=0x387c8 size=8 types=q24@0:8@16
0x000387c8  mov      w0, #6
0x000387cc  ret      

=== -[OMCSplitScreenController tableView:numberOfRowsInSection:]  va=0x387d0 size=200 types=q32@0:8@16q24
0x000387d0  stp      x22, x21, [sp, #-0x30]!
0x000387d4  stp      x20, x19, [sp, #0x10]
0x000387d8  stp      x29, x30, [sp, #0x20]
0x000387dc  add      x29, sp, #0x20
0x000387e0  mov      x20, x3
0x000387e4  mov      x19, x2
0x000387e8  mov      x21, x0
0x000387ec  mov      x0, x2
0x000387f0  bl       #0x55d84   ; CALL _objc_retain
0x000387f4  cmp      x20, #1
0x000387f8  b.eq     #0x38870
0x000387fc  cmp      x20, #5
0x00038800  b.eq     #0x38828
0x00038804  cmp      x20, #3
0x00038808  b.ne     #0x38878
0x0003880c  mov      x0, x21
0x00038810  bl       #0x57940   ; CALL objc_msgSend$editing
0x00038814  cmp      x0, #0
0x00038818  mov      w8, #7
0x0003881c  mov      w9, #3
0x00038820  csel     x20, x9, x8, eq
0x00038824  b        #0x3887c
0x00038828  mov      x0, x21
0x0003882c  bl       #0x5c9e0   ; CALL objc_msgSend$showGestures
0x00038830  cmp      w0, #0
0x00038834  mov      w8, #2
0x00038838  cinc     x20, x8, ne
0x0003883c  mov      x0, x21
0x00038840  bl       #0x5caa0   ; CALL objc_msgSend$showSiri
0x00038844  cbz      w0, #0x3887c
0x00038848  mov      x0, x21
0x0003884c  bl       #0x5dde0   ; CALL objc_msgSend$urls
0x00038850  mov      x29, x29
0x00038854  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038858  mov      x21, x0
0x0003885c  bl       #0x573c0   ; CALL objc_msgSend$count
0x00038860  add      x20, x0, x20
0x00038864  mov      x0, x21
0x00038868  bl       #0x55d78   ; CALL _objc_release
0x0003886c  b        #0x3887c
0x00038870  mov      w20, #2
0x00038874  b        #0x3887c
0x00038878  mov      w20, #1
0x0003887c  mov      x0, x19
0x00038880  bl       #0x55d78   ; CALL _objc_release
0x00038884  mov      x0, x20
0x00038888  ldp      x29, x30, [sp, #0x20]
0x0003888c  ldp      x20, x19, [sp, #0x10]
0x00038890  ldp      x22, x21, [sp], #0x30
0x00038894  ret      

=== -[OMCSplitScreenController tableView:titleForHeaderInSection:]  va=0x38898 size=100 types=@32@0:8@16q24
0x00038898  stp      x20, x19, [sp, #-0x20]!
0x0003889c  stp      x29, x30, [sp, #0x10]
0x000388a0  add      x29, sp, #0x10
0x000388a4  mov      x20, x3
0x000388a8  mov      x19, x2
0x000388ac  mov      x0, x2
0x000388b0  bl       #0x55d84   ; CALL _objc_retain
0x000388b4  sub      x8, x20, #2
0x000388b8  cmp      x8, #2
0x000388bc  b.hi     #0x388e0
0x000388c0  adrp     x9, #0x74000
0x000388c4  add      x9, x9, #0xc90
0x000388c8  ldr      x0, [x9, x8, lsl #3]
0x000388cc  bl       #0x17e20   ; CALL _L
0x000388d0  mov      x29, x29
0x000388d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000388d8  mov      x20, x0
0x000388dc  b        #0x388e4
0x000388e0  mov      x20, #0
0x000388e4  mov      x0, x19
0x000388e8  bl       #0x55d78   ; CALL _objc_release
0x000388ec  mov      x0, x20
0x000388f0  ldp      x29, x30, [sp, #0x10]
0x000388f4  ldp      x20, x19, [sp], #0x20
0x000388f8  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCSplitScreenController tableView:titleForFooterInSection:]  va=0x388fc size=132 types=@32@0:8@16q24
0x000388fc  stp      x20, x19, [sp, #-0x20]!
0x00038900  stp      x29, x30, [sp, #0x10]
0x00038904  add      x29, sp, #0x10
0x00038908  mov      x20, x3
0x0003890c  mov      x19, x2
0x00038910  mov      x0, x2
0x00038914  bl       #0x55d84   ; CALL _objc_retain
0x00038918  cmp      x20, #2
0x0003891c  b.eq     #0x38948
0x00038920  cmp      x20, #5
0x00038924  b.eq     #0x3893c
0x00038928  cmp      x20, #3
0x0003892c  b.ne     #0x38964
0x00038930  adrp     x0, #0x7b000
0x00038934  add      x0, x0, #0xc88   ; STR "SPLITSCREEN_FAV_FOOTER"
0x00038938  b        #0x38950
0x0003893c  adrp     x0, #0x7b000
0x00038940  add      x0, x0, #0xca8   ; STR "SPLITSCREEN_CREDITS_FOOTER"
0x00038944  b        #0x38950
0x00038948  adrp     x0, #0x7b000
0x0003894c  add      x0, x0, #0xc68   ; STR "SPLITSCREEN_PINNED_FOOTER"
0x00038950  bl       #0x17e20   ; CALL _L
0x00038954  mov      x29, x29
0x00038958  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003895c  mov      x20, x0
0x00038960  b        #0x38968
0x00038964  mov      x20, #0
0x00038968  mov      x0, x19
0x0003896c  bl       #0x55d78   ; CALL _objc_release
0x00038970  mov      x0, x20
0x00038974  ldp      x29, x30, [sp, #0x10]
0x00038978  ldp      x20, x19, [sp], #0x20
0x0003897c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCSplitScreenController favRow:fav:part:]  va=0x38980 size=104 types=v40@0:8q16^q24^q32
0x00038980  stp      x22, x21, [sp, #-0x30]!
0x00038984  stp      x20, x19, [sp, #0x10]
0x00038988  stp      x29, x30, [sp, #0x20]
0x0003898c  add      x29, sp, #0x20
0x00038990  mov      x19, x4
0x00038994  mov      x20, x3
0x00038998  mov      x21, x2
0x0003899c  bl       #0x57940   ; CALL objc_msgSend$editing
0x000389a0  cbz      x0, #0x389c0
0x000389a4  subs     x8, x21, x0
0x000389a8  b.lt     #0x389c0
0x000389ac  add      x9, x0, #4
0x000389b0  cmp      x21, x9
0x000389b4  b.ge     #0x389c8
0x000389b8  str      x0, [x20]
0x000389bc  b        #0x389d4
0x000389c0  add      x8, x21, #1
0x000389c4  b        #0x389cc
0x000389c8  sub      x8, x21, #3
0x000389cc  str      x8, [x20]
0x000389d0  mov      x8, #-1
0x000389d4  str      x8, [x19]
0x000389d8  ldp      x29, x30, [sp, #0x20]
0x000389dc  ldp      x20, x19, [sp, #0x10]
0x000389e0  ldp      x22, x21, [sp], #0x30
0x000389e4  ret      

=== -[OMCSplitScreenController helpKind:index:]  va=0x389e8 size=132 types=q32@0:8q16^q24
0x000389e8  cbz      x2, #0x38a20
0x000389ec  stp      x22, x21, [sp, #-0x30]!
0x000389f0  stp      x20, x19, [sp, #0x10]
0x000389f4  stp      x29, x30, [sp, #0x20]
0x000389f8  add      x29, sp, #0x20
0x000389fc  mov      x19, x3
0x00038a00  mov      x20, x2
0x00038a04  mov      x21, x0
0x00038a08  bl       #0x5c9e0   ; CALL objc_msgSend$showGestures
0x00038a0c  cmp      x20, #1
0x00038a10  b.ne     #0x38a28
0x00038a14  tbz      w0, #0, #0x38a28
0x00038a18  mov      w0, #1
0x00038a1c  b        #0x38a5c
0x00038a20  mov      x0, #0
0x00038a24  ret      
0x00038a28  mov      x0, x21
0x00038a2c  bl       #0x5c9e0   ; CALL objc_msgSend$showGestures
0x00038a30  cmp      w0, #0
0x00038a34  mov      w8, #1
0x00038a38  cinc     x8, x8, ne
0x00038a3c  cmp      x20, x8
0x00038a40  b.ne     #0x38a4c
0x00038a44  mov      w0, #2
0x00038a48  b        #0x38a5c
0x00038a4c  mvn      x8, x8
0x00038a50  add      x8, x20, x8
0x00038a54  str      x8, [x19]
0x00038a58  mov      w0, #3
0x00038a5c  ldp      x29, x30, [sp, #0x20]
0x00038a60  ldp      x20, x19, [sp, #0x10]
0x00038a64  ldp      x22, x21, [sp], #0x30
0x00038a68  ret      

=== -[OMCSplitScreenController tableView:heightForRowAtIndexPath:]  va=0x38a6c size=596 types=d32@0:8@16@24
0x00038a6c  sub      sp, sp, #0x70
0x00038a70  stp      d9, d8, [sp, #0x30]
0x00038a74  stp      x22, x21, [sp, #0x40]
0x00038a78  stp      x20, x19, [sp, #0x50]
0x00038a7c  stp      x29, x30, [sp, #0x60]
0x00038a80  add      x29, sp, #0x60
0x00038a84  mov      x19, x3
0x00038a88  mov      x21, x2
0x00038a8c  mov      x20, x0
0x00038a90  adrp     x8, #0x74000
0x00038a94  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00038a98  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00038a9c  str      x8, [sp, #0x28]
0x00038aa0  mov      x0, x3
0x00038aa4  bl       #0x55d84   ; CALL _objc_retain
0x00038aa8  mov      x0, x21
0x00038aac  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00038ab0  mov      x8, #-0x3fbc000000000000
0x00038ab4  fmov     d0, x8
0x00038ab8  fadd     d8, d2, d0
0x00038abc  mov      x0, x19
0x00038ac0  bl       #0x5a180   ; CALL objc_msgSend$section
0x00038ac4  cbz      x0, #0x38af4
0x00038ac8  mov      x0, x19
0x00038acc  bl       #0x5a180   ; CALL objc_msgSend$section
0x00038ad0  cmp      x0, #1
0x00038ad4  b.eq     #0x38ae8
0x00038ad8  mov      x0, x19
0x00038adc  bl       #0x5a180   ; CALL objc_msgSend$section
0x00038ae0  cmp      x0, #2
0x00038ae4  b.ne     #0x38b4c
0x00038ae8  mov      x8, #0x404e000000000000
0x00038aec  fmov     d8, x8
0x00038af0  b        #0x38b10
0x00038af4  adrp     x8, #0x65000
0x00038af8  ldr      d0, [x8, #0xe40]
0x00038afc  fmul     d0, d8, d0
0x00038b00  frinta   d0, d0
0x00038b04  adrp     x8, #0x65000
0x00038b08  ldr      d1, [x8, #0xcf0]
0x00038b0c  fmaxnm   d8, d0, d1
0x00038b10  mov      x0, x19
0x00038b14  bl       #0x55d78   ; CALL _objc_release
0x00038b18  ldr      x8, [sp, #0x28]
0x00038b1c  adrp     x9, #0x74000
0x00038b20  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00038b24  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00038b28  cmp      x9, x8
0x00038b2c  b.ne     #0x38cbc
0x00038b30  mov      v0.16b, v8.16b
0x00038b34  ldp      x29, x30, [sp, #0x60]
0x00038b38  ldp      x20, x19, [sp, #0x50]
0x00038b3c  ldp      x22, x21, [sp, #0x40]
0x00038b40  ldp      d9, d8, [sp, #0x30]
0x00038b44  add      sp, sp, #0x70
0x00038b48  ret      
0x00038b4c  mov      x0, x19
0x00038b50  bl       #0x5a180   ; CALL objc_msgSend$section
0x00038b54  cmp      x0, #3
0x00038b58  b.ne     #0x38bac
0x00038b5c  mov      x0, x19
0x00038b60  bl       #0x59f60   ; CALL objc_msgSend$row
0x00038b64  mov      x2, x0
0x00038b68  add      x3, sp, #0x10
0x00038b6c  add      x4, sp, #8
0x00038b70  mov      x0, x20
0x00038b74  bl       #0x57b20   ; CALL objc_msgSend$favRow:fav:part:
0x00038b78  ldr      x8, [sp, #8]
0x00038b7c  and      x9, x8, #0xfffffffffffffffd
0x00038b80  cmp      x8, #2
0x00038b84  mov      x8, #0x404e000000000000
0x00038b88  fmov     d0, x8
0x00038b8c  mov      x8, #0x404d000000000000
0x00038b90  fmov     d1, x8
0x00038b94  fcsel    d0, d1, d0, eq
0x00038b98  cmp      x9, #1
0x00038b9c  mov      x8, #0x4048000000000000
0x00038ba0  fmov     d1, x8
0x00038ba4  fcsel    d8, d1, d0, eq
0x00038ba8  b        #0x38b10
0x00038bac  mov      x0, x19
0x00038bb0  bl       #0x5a180   ; CALL objc_msgSend$section
0x00038bb4  cmp      x0, #5
0x00038bb8  b.ne     #0x38cac
0x00038bbc  str      xzr, [sp, #0x10]
0x00038bc0  mov      x0, x19
0x00038bc4  bl       #0x59f60   ; CALL objc_msgSend$row
0x00038bc8  mov      x2, x0
0x00038bcc  add      x3, sp, #0x10
0x00038bd0  mov      x0, x20
0x00038bd4  bl       #0x57f60   ; CALL objc_msgSend$helpKind:index:
0x00038bd8  cmp      x0, #3
0x00038bdc  b.eq     #0x38cb4
0x00038be0  cmp      x0, #1
0x00038be4  b.ne     #0x38cac
0x00038be8  adrp     x0, #0x7b000
0x00038bec  add      x0, x0, #0xcc8   ; STR "SPLITSCREEN_GUIDE_CAR_TEXT"
0x00038bf0  bl       #0x17e20   ; CALL _L
0x00038bf4  mov      x29, x29
0x00038bf8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038bfc  mov      x20, x0
0x00038c00  mov      x8, #-0x3fc0000000000000
0x00038c04  fmov     d0, x8
0x00038c08  fadd     d8, d8, d0
0x00038c0c  adrp     x8, #0x74000
0x00038c10  ldr      x8, [x8, #0x1d8]   ; @GOT _NSFontAttributeName
0x00038c14  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00038c18  str      x8, [sp, #0x18]
0x00038c1c  adrp     x8, #0x8e000
0x00038c20  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x00038c24  fmov     d0, #12.50000000
0x00038c28  bl       #0x5d7c0   ; CALL objc_msgSend$systemFontOfSize:
0x00038c2c  mov      x29, x29
0x00038c30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038c34  mov      x21, x0
0x00038c38  str      x0, [sp, #0x20]
0x00038c3c  adrp     x8, #0x8e000
0x00038c40  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00038c44  add      x2, sp, #0x20
0x00038c48  add      x3, sp, #0x18
0x00038c4c  mov      w4, #1
0x00038c50  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00038c54  mov      x29, x29
0x00038c58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038c5c  mov      x22, x0
0x00038c60  adrp     x8, #0x65000
0x00038c64  ldr      d1, [x8, #0x640]
0x00038c68  mov      x0, x20
0x00038c6c  mov      v0.16b, v8.16b
0x00038c70  mov      w2, #1
0x00038c74  mov      x3, x22
0x00038c78  mov      x4, #0
0x00038c7c  bl       #0x56a20   ; CALL objc_msgSend$boundingRectWithSize:options:attributes:context:
0x00038c80  mov      v8.16b, v3.16b
0x00038c84  mov      x0, x22
0x00038c88  bl       #0x55d78   ; CALL _objc_release
0x00038c8c  mov      x0, x21
0x00038c90  bl       #0x55d78   ; CALL _objc_release
0x00038c94  mov      x0, x20
0x00038c98  bl       #0x55d78   ; CALL _objc_release
0x00038c9c  frintp   d0, d8
0x00038ca0  fmov     d1, #20.00000000
0x00038ca4  fadd     d8, d0, d1
0x00038ca8  b        #0x38b10
0x00038cac  mov      x8, #0x404a000000000000
0x00038cb0  b        #0x38aec
0x00038cb4  mov      x8, #0x4044000000000000
0x00038cb8  b        #0x38aec
0x00038cbc  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCSplitScreenController tableView:cellForRowAtIndexPath:]  va=0x38cc0 size=6164 types=@32@0:8@16@24
0x00038cc0  stp      d13, d12, [sp, #-0x90]!
0x00038cc4  stp      d11, d10, [sp, #0x10]
0x00038cc8  stp      d9, d8, [sp, #0x20]
0x00038ccc  stp      x28, x27, [sp, #0x30]
0x00038cd0  stp      x26, x25, [sp, #0x40]
0x00038cd4  stp      x24, x23, [sp, #0x50]
0x00038cd8  stp      x22, x21, [sp, #0x60]
0x00038cdc  stp      x20, x19, [sp, #0x70]
0x00038ce0  stp      x29, x30, [sp, #0x80]
0x00038ce4  add      x29, sp, #0x80
0x00038ce8  sub      sp, sp, #0x220
0x00038cec  mov      x20, x3
0x00038cf0  mov      x19, x2
0x00038cf4  mov      x23, x0
0x00038cf8  adrp     x8, #0x74000
0x00038cfc  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00038d00  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00038d04  stur     x8, [x29, #-0x90]
0x00038d08  mov      x0, x2
0x00038d0c  bl       #0x55d84   ; CALL _objc_retain
0x00038d10  mov      x0, x20
0x00038d14  bl       #0x55d84   ; CALL _objc_retain
0x00038d18  mov      x0, x19
0x00038d1c  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00038d20  mov      x8, #-0x3fbc000000000000
0x00038d24  fmov     d0, x8
0x00038d28  fadd     d8, d2, d0
0x00038d2c  mov      x0, x23
0x00038d30  bl       #0x59440   ; CALL objc_msgSend$on
0x00038d34  mov      x28, x0
0x00038d38  mov      x0, x20
0x00038d3c  bl       #0x5a180   ; CALL objc_msgSend$section
0x00038d40  cmp      x0, #1
0x00038d44  b.le     #0x38f74
0x00038d48  cmp      x0, #2
0x00038d4c  b.eq     #0x39104
0x00038d50  cmp      x0, #3
0x00038d54  b.eq     #0x39198
0x00038d58  cmp      x0, #4
0x00038d5c  b.ne     #0x39540
0x00038d60  adrp     x2, #0x7b000
0x00038d64  add      x2, x2, #0xec8   ; STR "panel"
0x00038d68  mov      x0, x23
0x00038d6c  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x00038d70  mov      x29, x29
0x00038d74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038d78  mov      x21, x0
0x00038d7c  adrp     x0, #0x7b000
0x00038d80  add      x0, x0, #0xee8   ; STR "SPLITSCREEN_PANEL_SHOW"
0x00038d84  bl       #0x17e20   ; CALL _L
0x00038d88  mov      x29, x29
0x00038d8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038d90  mov      x22, x0
0x00038d94  mov      x0, x21
0x00038d98  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00038d9c  mov      x29, x29
0x00038da0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038da4  mov      x24, x0
0x00038da8  mov      x2, x22
0x00038dac  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00038db0  mov      x0, x24
0x00038db4  bl       #0x55d78   ; CALL _objc_release
0x00038db8  mov      x0, x22
0x00038dbc  bl       #0x55d78   ; CALL _objc_release
0x00038dc0  adrp     x0, #0x78000
0x00038dc4  add      x0, x0, #0xec8   ; STR "#FF7FA8"
0x00038dc8  bl       #0x18080   ; CALL _OMCColorFromHex
0x00038dcc  mov      x29, x29
0x00038dd0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038dd4  mov      x22, x0
0x00038dd8  adrp     x0, #0x7b000
0x00038ddc  add      x0, x0, #0xf08   ; STR "list.bullet.rectangle.fill"
0x00038de0  mov      x1, x22
0x00038de4  bl       #0x18144   ; CALL _OMCIcon
0x00038de8  mov      x29, x29
0x00038dec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038df0  mov      x24, x0
0x00038df4  mov      x0, x21
0x00038df8  bl       #0x58120   ; CALL objc_msgSend$imageView
0x00038dfc  mov      x29, x29
0x00038e00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038e04  mov      x25, x0
0x00038e08  mov      x2, x24
0x00038e0c  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00038e10  mov      x0, x25
0x00038e14  bl       #0x55d78   ; CALL _objc_release
0x00038e18  mov      x0, x24
0x00038e1c  bl       #0x55d78   ; CALL _objc_release
0x00038e20  mov      x0, x22
0x00038e24  bl       #0x55d78   ; CALL _objc_release
0x00038e28  adrp     x8, #0x8e000
0x00038e2c  ldr      x0, [x8, #0xa38]   ; @CLASS UIStackView
0x00038e30  bl       #0x55c7c   ; CALL _objc_alloc
0x00038e34  mov      x22, x0
0x00038e38  adrp     x0, #0x7b000
0x00038e3c  add      x0, x0, #0xf28   ; STR "SPLITSCREEN_SHOW_RECENT"
0x00038e40  bl       #0x17e20   ; CALL _L
0x00038e44  mov      x29, x29
0x00038e48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038e4c  mov      x24, x0
0x00038e50  adrp     x3, #0x7b000
0x00038e54  add      x3, x3, #0xf48   ; STR "splitScreenShowRecent"
0x00038e58  mov      x0, x23
0x00038e5c  mov      x2, x24
0x00038e60  bl       #0x56dc0   ; CALL objc_msgSend$chip:key:
0x00038e64  mov      x29, x29
0x00038e68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038e6c  mov      x25, x0
0x00038e70  str      x0, [sp, #0x180]
0x00038e74  adrp     x0, #0x7b000
0x00038e78  add      x0, x0, #0xf68   ; STR "SPLITSCREEN_SHOW_FAVORITES"
0x00038e7c  bl       #0x17e20   ; CALL _L
0x00038e80  mov      x29, x29
0x00038e84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038e88  mov      x26, x0
0x00038e8c  adrp     x3, #0x7b000
0x00038e90  add      x3, x3, #0xf88   ; STR "splitScreenShowFavorites"
0x00038e94  mov      x0, x23
0x00038e98  mov      x2, x26
0x00038e9c  bl       #0x56dc0   ; CALL objc_msgSend$chip:key:
0x00038ea0  mov      x29, x29
0x00038ea4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038ea8  mov      x27, x0
0x00038eac  str      x0, [sp, #0x188]
0x00038eb0  adrp     x8, #0x8e000
0x00038eb4  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00038eb8  add      x2, sp, #0x180
0x00038ebc  mov      w3, #2
0x00038ec0  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00038ec4  mov      x29, x29
0x00038ec8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00038ecc  str      x23, [sp, #0x28]
0x00038ed0  mov      x23, x19
0x00038ed4  mov      x19, x20
0x00038ed8  mov      x20, x28
0x00038edc  mov      x28, x0
0x00038ee0  mov      x0, x22
0x00038ee4  mov      x2, x28
0x00038ee8  bl       #0x583a0   ; CALL objc_msgSend$initWithArrangedSubviews:
0x00038eec  mov      x22, x0
0x00038ef0  mov      x0, x28
0x00038ef4  mov      x28, x20
0x00038ef8  mov      x20, x19
0x00038efc  mov      x19, x23
0x00038f00  bl       #0x55d78   ; CALL _objc_release
0x00038f04  mov      x0, x27
0x00038f08  bl       #0x55d78   ; CALL _objc_release
0x00038f0c  mov      x0, x26
0x00038f10  bl       #0x55d78   ; CALL _objc_release
0x00038f14  mov      x0, x25
0x00038f18  bl       #0x55d78   ; CALL _objc_release
0x00038f1c  mov      x0, x24
0x00038f20  bl       #0x55d78   ; CALL _objc_release
0x00038f24  fmov     d0, #6.00000000
0x00038f28  mov      x0, x22
0x00038f2c  bl       #0x5c240   ; CALL objc_msgSend$setSpacing:
0x00038f30  adrp     x8, #0x74000
0x00038f34  ldr      x8, [x8, #0x2a8]   ; @GOT _UILayoutFittingCompressedSize
0x00038f38  ldp      d0, d1, [x8]
0x00038f3c  mov      x0, x22
0x00038f40  bl       #0x5d860   ; CALL objc_msgSend$systemLayoutSizeFittingSize:
0x00038f44  mov      v2.16b, v0.16b
0x00038f48  fmov     d0, xzr
0x00038f4c  fmov     d1, xzr
0x00038f50  fmov     d3, #30.00000000
0x00038f54  mov      x0, x22
0x00038f58  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00038f5c  ldr      x0, [sp, #0x28]
0x00038f60  mov      x2, x22
0x00038f64  mov      x3, x21
0x00038f68  bl       #0x5a280   ; CALL objc_msgSend$setAccessory:onCell:
0x00038f6c  mov      x0, x22
0x00038f70  b        #0x39ea4
0x00038f74  cbz      x0, #0x391dc
0x00038f78  cmp      x0, #1
0x00038f7c  b.ne     #0x39540
0x00038f80  str      w28, [sp, #0x28]
0x00038f84  mov      x0, x20
0x00038f88  bl       #0x59f60   ; CALL objc_msgSend$row
0x00038f8c  mov      x24, x0
0x00038f90  adrp     x8, #0x7b000
0x00038f94  add      x8, x8, #0xd68   ; STR "auto"
0x00038f98  adrp     x9, #0x7a000
0x00038f9c  add      x9, x9, #0x668   ; STR "enable"
0x00038fa0  cmp      x0, #0
0x00038fa4  csel     x2, x9, x8, eq
0x00038fa8  adrp     x8, #0x7b000
0x00038fac  add      x8, x8, #0xda8   ; STR "SPLITSCREEN_AUTO_LAUNCH"
0x00038fb0  adrp     x9, #0x7b000
0x00038fb4  add      x9, x9, #0xd88   ; STR "SPLITSCREEN_ENABLE"
0x00038fb8  csel     x26, x9, x8, eq
0x00038fbc  adrp     x8, #0x7b000
0x00038fc0  add      x8, x8, #0xde8   ; STR "SPLITSCREEN_AUTO_LAUNCH_SUB"
0x00038fc4  adrp     x9, #0x7b000
0x00038fc8  add      x9, x9, #0xdc8   ; STR "SPLITSCREEN_ENABLE_SUB"
0x00038fcc  csel     x27, x9, x8, eq
0x00038fd0  adrp     x8, #0x7b000
0x00038fd4  add      x8, x8, #0xe08   ; STR "bolt.fill"
0x00038fd8  adrp     x9, #0x78000
0x00038fdc  add      x9, x9, #0x328   ; STR "rectangle.split.2x1.fill"
0x00038fe0  adrp     x10, #0x78000
0x00038fe4  add      x10, x10, #0xee8   ; STR "#2BC79A"
0x00038fe8  csel     x25, x9, x8, eq
0x00038fec  adrp     x8, #0x78000
0x00038ff0  add      x8, x8, #0xf28   ; STR "#8B7CFF"
0x00038ff4  csel     x28, x8, x10, eq
0x00038ff8  mov      x0, x23
0x00038ffc  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x00039000  mov      x29, x29
0x00039004  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039008  mov      x21, x0
0x0003900c  mov      x0, x26
0x00039010  bl       #0x17e20   ; CALL _L
0x00039014  mov      x29, x29
0x00039018  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003901c  mov      x26, x0
0x00039020  mov      x0, x21
0x00039024  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00039028  mov      x29, x29
0x0003902c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039030  mov      x22, x0
0x00039034  mov      x2, x26
0x00039038  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0003903c  mov      x0, x22
0x00039040  bl       #0x55d78   ; CALL _objc_release
0x00039044  mov      x0, x26
0x00039048  bl       #0x55d78   ; CALL _objc_release
0x0003904c  mov      x0, x27
0x00039050  bl       #0x17e20   ; CALL _L
0x00039054  mov      x29, x29
0x00039058  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003905c  mov      x22, x0
0x00039060  mov      x0, x21
0x00039064  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x00039068  mov      x29, x29
0x0003906c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039070  mov      x26, x0
0x00039074  mov      x2, x22
0x00039078  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0003907c  mov      x0, x26
0x00039080  bl       #0x55d78   ; CALL _objc_release
0x00039084  mov      x0, x22
0x00039088  bl       #0x55d78   ; CALL _objc_release
0x0003908c  mov      x0, x28
0x00039090  bl       #0x18080   ; CALL _OMCColorFromHex
0x00039094  mov      x29, x29
0x00039098  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003909c  mov      x22, x0
0x000390a0  mov      x0, x25
0x000390a4  mov      x1, x22
0x000390a8  bl       #0x18144   ; CALL _OMCIcon
0x000390ac  mov      x29, x29
0x000390b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000390b4  mov      x25, x0
0x000390b8  mov      x0, x21
0x000390bc  bl       #0x58120   ; CALL objc_msgSend$imageView
0x000390c0  mov      x29, x29
0x000390c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000390c8  mov      x26, x0
0x000390cc  mov      x2, x25
0x000390d0  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x000390d4  mov      x0, x26
0x000390d8  bl       #0x55d78   ; CALL _objc_release
0x000390dc  mov      x0, x25
0x000390e0  bl       #0x55d78   ; CALL _objc_release
0x000390e4  mov      x0, x22
0x000390e8  bl       #0x55d78   ; CALL _objc_release
0x000390ec  cbz      x24, #0x39898
0x000390f0  adrp     x2, #0x7b000
0x000390f4  add      x2, x2, #0xe28   ; STR "splitScreenAutoLaunch"
0x000390f8  mov      x0, x23
0x000390fc  mov      w3, #0
0x00039100  b        #0x398a8
0x00039104  adrp     x2, #0x7b000
0x00039108  add      x2, x2, #0xe48   ; STR "pinned"
0x0003910c  mov      x0, x23
0x00039110  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x00039114  mov      x29, x29
0x00039118  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003911c  mov      x21, x0
0x00039120  adrp     x2, #0x7b000
0x00039124  add      x2, x2, #0xd08   ; STR "splitScreenPinnedApp"
0x00039128  mov      x0, x23
0x0003912c  bl       #0x5d4e0   ; CALL objc_msgSend$stringForKey:
0x00039130  mov      x29, x29
0x00039134  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039138  mov      x23, x0
0x0003913c  adrp     x0, #0x7b000
0x00039140  add      x0, x0, #0xe68   ; STR "SPLITSCREEN_PINNED"
0x00039144  bl       #0x17e20   ; CALL _L
0x00039148  mov      x29, x29
0x0003914c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039150  mov      x22, x0
0x00039154  mov      x0, x21
0x00039158  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x0003915c  mov      x29, x29
0x00039160  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039164  mov      x24, x0
0x00039168  mov      x2, x22
0x0003916c  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00039170  mov      x0, x24
0x00039174  bl       #0x55d78   ; CALL _objc_release
0x00039178  mov      x0, x22
0x0003917c  bl       #0x55d78   ; CALL _objc_release
0x00039180  cbz      x23, #0x39598
0x00039184  mov      x0, x23
0x00039188  bl       #0x3a3ec
0x0003918c  mov      x29, x29
0x00039190  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039194  b        #0x395ac
0x00039198  mov      x0, x20
0x0003919c  bl       #0x59f60   ; CALL objc_msgSend$row
0x000391a0  mov      x2, x0
0x000391a4  add      x3, sp, #0xb8
0x000391a8  add      x4, sp, #0xb0
0x000391ac  mov      x0, x23
0x000391b0  bl       #0x57b20   ; CALL objc_msgSend$favRow:fav:part:
0x000391b4  ldr      x2, [sp, #0xb0]
0x000391b8  tbnz     x2, #0x3f, #0x39690
0x000391bc  ldr      x3, [sp, #0xb8]
0x000391c0  mov      x0, x23
0x000391c4  mov      v0.16b, v8.16b
0x000391c8  bl       #0x57960   ; CALL objc_msgSend$editorCell:fav:width:
0x000391cc  mov      x29, x29
0x000391d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000391d4  mov      x21, x0
0x000391d8  b        #0x3a2ec
0x000391dc  adrp     x2, #0x79000
0x000391e0  add      x2, x2, #0x6e8   ; STR "preview"
0x000391e4  mov      x0, x23
0x000391e8  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x000391ec  mov      x29, x29
0x000391f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000391f4  mov      x21, x0
0x000391f8  mov      x0, x23
0x000391fc  bl       #0x599e0   ; CALL objc_msgSend$preview
0x00039200  mov      x29, x29
0x00039204  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039208  cbz      x0, #0x3926c
0x0003920c  mov      x24, x0
0x00039210  mov      x0, x23
0x00039214  bl       #0x599e0   ; CALL objc_msgSend$preview
0x00039218  mov      x29, x29
0x0003921c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039220  mov      x25, x0
0x00039224  bl       #0x5d740   ; CALL objc_msgSend$superview
0x00039228  mov      x29, x29
0x0003922c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039230  mov      x26, x0
0x00039234  mov      x0, x21
0x00039238  bl       #0x57280   ; CALL objc_msgSend$contentView
0x0003923c  mov      x29, x29
0x00039240  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039244  mov      x27, x0
0x00039248  bl       #0x55d78   ; CALL _objc_release
0x0003924c  mov      x0, x26
0x00039250  bl       #0x55d78   ; CALL _objc_release
0x00039254  mov      x0, x25
0x00039258  bl       #0x55d78   ; CALL _objc_release
0x0003925c  mov      x0, x24
0x00039260  bl       #0x55d78   ; CALL _objc_release
0x00039264  cmp      x26, x27
0x00039268  b.eq     #0x392f4
0x0003926c  mov      x0, x23
0x00039270  bl       #0x599e0   ; CALL objc_msgSend$preview
0x00039274  mov      x29, x29
0x00039278  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003927c  mov      x24, x0
0x00039280  bl       #0x59e00   ; CALL objc_msgSend$removeFromSuperview
0x00039284  mov      x0, x24
0x00039288  bl       #0x55d78   ; CALL _objc_release
0x0003928c  adrp     x8, #0x8e000
0x00039290  ldr      x0, [x8, #0xc20]   ; @CLASS OMCSplitPreview
0x00039294  bl       #0x55d60   ; CALL _objc_opt_new
0x00039298  mov      x24, x0
0x0003929c  mov      x0, x23
0x000392a0  mov      x2, x24
0x000392a4  bl       #0x5bcc0   ; CALL objc_msgSend$setPreview:
0x000392a8  mov      x0, x24
0x000392ac  bl       #0x55d78   ; CALL _objc_release
0x000392b0  mov      x0, x21
0x000392b4  bl       #0x57280   ; CALL objc_msgSend$contentView
0x000392b8  mov      x29, x29
0x000392bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000392c0  mov      x24, x0
0x000392c4  mov      x0, x23
0x000392c8  bl       #0x599e0   ; CALL objc_msgSend$preview
0x000392cc  mov      x29, x29
0x000392d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000392d4  mov      x25, x0
0x000392d8  mov      x0, x24
0x000392dc  mov      x2, x25
0x000392e0  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x000392e4  mov      x0, x25
0x000392e8  bl       #0x55d78   ; CALL _objc_release
0x000392ec  mov      x0, x24
0x000392f0  bl       #0x55d78   ; CALL _objc_release
0x000392f4  fmov     d9, #-16.00000000
0x000392f8  fadd     d8, d8, d9
0x000392fc  mov      x0, x23
0x00039300  mov      x2, x19
0x00039304  mov      x3, x20
0x00039308  bl       #0x5d8e0   ; CALL objc_msgSend$tableView:heightForRowAtIndexPath:
0x0003930c  fadd     d9, d0, d9
0x00039310  mov      x0, x23
0x00039314  bl       #0x599e0   ; CALL objc_msgSend$preview
0x00039318  mov      x29, x29
0x0003931c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039320  mov      x24, x0
0x00039324  fmov     d0, #8.00000000
0x00039328  fmov     d1, #8.00000000
0x0003932c  mov      v2.16b, v8.16b
0x00039330  mov      v3.16b, v9.16b
0x00039334  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00039338  mov      x0, x24
0x0003933c  bl       #0x55d78   ; CALL _objc_release
0x00039340  mov      x0, x23
0x00039344  bl       #0x599e0   ; CALL objc_msgSend$preview
0x00039348  mov      x29, x29
0x0003934c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039350  mov      x24, x0
0x00039354  mov      x2, x28
0x00039358  bl       #0x5b900   ; CALL objc_msgSend$setOn:
0x0003935c  mov      x0, x24
0x00039360  bl       #0x55d78   ; CALL _objc_release
0x00039364  adrp     x0, #0x7b000
0x00039368  add      x0, x0, #0xce8   ; STR "SPLITSCREEN_OFF"
0x0003936c  bl       #0x17e20   ; CALL _L
0x00039370  mov      x29, x29
0x00039374  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039378  mov      x22, x0
0x0003937c  mov      x0, x23
0x00039380  bl       #0x599e0   ; CALL objc_msgSend$preview
0x00039384  mov      x29, x29
0x00039388  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003938c  mov      x24, x0
0x00039390  mov      x2, x22
0x00039394  bl       #0x5b8e0   ; CALL objc_msgSend$setOffText:
0x00039398  mov      x0, x24
0x0003939c  bl       #0x55d78   ; CALL _objc_release
0x000393a0  mov      x0, x22
0x000393a4  bl       #0x55d78   ; CALL _objc_release
0x000393a8  adrp     x2, #0x7b000
0x000393ac  add      x2, x2, #0xd08   ; STR "splitScreenPinnedApp"
0x000393b0  mov      x0, x23
0x000393b4  bl       #0x5d4e0   ; CALL objc_msgSend$stringForKey:
0x000393b8  mov      x29, x29
0x000393bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000393c0  mov      x22, x0
0x000393c4  mov      x0, x23
0x000393c8  bl       #0x599e0   ; CALL objc_msgSend$preview
0x000393cc  mov      x29, x29
0x000393d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000393d4  mov      x24, x0
0x000393d8  mov      x2, x22
0x000393dc  bl       #0x5bba0   ; CALL objc_msgSend$setPinned:
0x000393e0  mov      x0, x24
0x000393e4  bl       #0x55d78   ; CALL _objc_release
0x000393e8  mov      x0, x22
0x000393ec  bl       #0x55d78   ; CALL _objc_release
0x000393f0  adrp     x2, #0x7b000
0x000393f4  add      x2, x2, #0xd28   ; STR "splitScreenLastLeft"
0x000393f8  mov      x0, x23
0x000393fc  bl       #0x5d4e0   ; CALL objc_msgSend$stringForKey:
0x00039400  mov      x29, x29
0x00039404  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039408  mov      x22, x0
0x0003940c  mov      x0, x23
0x00039410  bl       #0x599e0   ; CALL objc_msgSend$preview
0x00039414  mov      x29, x29
0x00039418  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003941c  mov      x24, x0
0x00039420  bl       #0x59720   ; CALL objc_msgSend$pinned
0x00039424  mov      x29, x29
0x00039428  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003942c  mov      x25, x0
0x00039430  mov      x0, x22
0x00039434  mov      x2, x25
0x00039438  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0003943c  mov      x26, x0
0x00039440  mov      x0, x25
0x00039444  bl       #0x55d78   ; CALL _objc_release
0x00039448  mov      x0, x24
0x0003944c  bl       #0x55d78   ; CALL _objc_release
0x00039450  cbz      w26, #0x3947c
0x00039454  adrp     x2, #0x7b000
0x00039458  add      x2, x2, #0xd48   ; STR "splitScreenLastRight"
0x0003945c  mov      x0, x23
0x00039460  bl       #0x5d4e0   ; CALL objc_msgSend$stringForKey:
0x00039464  mov      x29, x29
0x00039468  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003946c  mov      x24, x0
0x00039470  mov      x0, x22
0x00039474  bl       #0x55d78   ; CALL _objc_release
0x00039478  mov      x22, x24
0x0003947c  adrp     x8, #0x79000
0x00039480  add      x8, x8, #0x128   ; STR "com.apple.Music"
0x00039484  cmp      x22, #0
0x00039488  csel     x24, x8, x22, eq
0x0003948c  mov      x0, x23
0x00039490  bl       #0x599e0   ; CALL objc_msgSend$preview
0x00039494  mov      x29, x29
0x00039498  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003949c  mov      x25, x0
0x000394a0  mov      x2, x24
0x000394a4  bl       #0x5b280   ; CALL objc_msgSend$setLeft:
0x000394a8  mov      x0, x25
0x000394ac  bl       #0x55d78   ; CALL _objc_release
0x000394b0  mov      x0, x23
0x000394b4  bl       #0x599e0   ; CALL objc_msgSend$preview
0x000394b8  mov      x29, x29
0x000394bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000394c0  mov      x24, x0
0x000394c4  bl       #0x59720   ; CALL objc_msgSend$pinned
0x000394c8  mov      x29, x29
0x000394cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000394d0  mov      x25, x0
0x000394d4  bl       #0x55d78   ; CALL _objc_release
0x000394d8  mov      x0, x24
0x000394dc  bl       #0x55d78   ; CALL _objc_release
0x000394e0  cbnz     x25, #0x3950c
0x000394e4  mov      x0, x23
0x000394e8  bl       #0x599e0   ; CALL objc_msgSend$preview
0x000394ec  mov      x29, x29
0x000394f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000394f4  mov      x24, x0
0x000394f8  adrp     x2, #0x79000
0x000394fc  add      x2, x2, #0x108   ; STR "com.apple.Maps"
0x00039500  bl       #0x5bba0   ; CALL objc_msgSend$setPinned:
0x00039504  mov      x0, x24
0x00039508  bl       #0x55d78   ; CALL _objc_release
0x0003950c  mov      x0, x23
0x00039510  bl       #0x599e0   ; CALL objc_msgSend$preview
0x00039514  mov      x29, x29
0x00039518  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003951c  mov      x23, x0
0x00039520  bl       #0x5b780   ; CALL objc_msgSend$setNeedsDisplay
0x00039524  mov      x0, x23
0x00039528  bl       #0x55d78   ; CALL _objc_release
0x0003952c  mov      x0, x21
0x00039530  bl       #0x55d84   ; CALL _objc_retain
0x00039534  mov      x0, x22
0x00039538  bl       #0x55d78   ; CALL _objc_release
0x0003953c  b        #0x3a388
0x00039540  str      xzr, [sp, #0xc0]
0x00039544  mov      x0, x20
0x00039548  bl       #0x59f60   ; CALL objc_msgSend$row
0x0003954c  mov      x2, x0
0x00039550  add      x3, sp, #0xc0
0x00039554  mov      x0, x23
0x00039558  bl       #0x57f60   ; CALL objc_msgSend$helpKind:index:
0x0003955c  cmp      x0, #2
0x00039560  b.eq     #0x39a1c
0x00039564  cmp      x0, #1
0x00039568  b.eq     #0x398d4
0x0003956c  cbnz     x0, #0x39b9c
0x00039570  mov      x0, x23
0x00039574  bl       #0x5c9e0   ; CALL objc_msgSend$showGestures
0x00039578  mov      x24, x0
0x0003957c  adrp     x27, #0x7b000
0x00039580  add      x27, x27, #0xfc8   ; STR "SPLITSCREEN_GESTURES"
0x00039584  adrp     x25, #0x7c000
0x00039588  add      x25, x25, #8   ; STR "hand.tap.fill"
0x0003958c  adrp     x26, #0x78000
0x00039590  add      x26, x26, #0xf08   ; STR "#5AB8FF"
0x00039594  b        #0x39a40
0x00039598  adrp     x0, #0x7b000
0x0003959c  add      x0, x0, #0xa28   ; STR "SPLITSCREEN_PICKER_NONE"
0x000395a0  bl       #0x17e20   ; CALL _L
0x000395a4  mov      x29, x29
0x000395a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000395ac  mov      x24, x0
0x000395b0  mov      x0, x21
0x000395b4  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x000395b8  mov      x29, x29
0x000395bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000395c0  mov      x22, x0
0x000395c4  mov      x2, x24
0x000395c8  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x000395cc  mov      x0, x22
0x000395d0  bl       #0x55d78   ; CALL _objc_release
0x000395d4  mov      x0, x24
0x000395d8  cbz      x23, #0x395fc
0x000395dc  bl       #0x55d78   ; CALL _objc_release
0x000395e0  fmov     d0, #30.00000000
0x000395e4  mov      x0, x23
0x000395e8  bl       #0x380a4
0x000395ec  mov      x29, x29
0x000395f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000395f4  mov      x25, x0
0x000395f8  b        #0x39634
0x000395fc  bl       #0x55d78   ; CALL _objc_release
0x00039600  adrp     x0, #0x7a000
0x00039604  add      x0, x0, #0xbc8   ; STR "#FFB340"
0x00039608  bl       #0x18080   ; CALL _OMCColorFromHex
0x0003960c  mov      x29, x29
0x00039610  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039614  mov      x24, x0
0x00039618  adrp     x0, #0x7b000
0x0003961c  add      x0, x0, #0xac8   ; STR "pin.fill"
0x00039620  mov      x1, x24
0x00039624  bl       #0x18144   ; CALL _OMCIcon
0x00039628  mov      x29, x29
0x0003962c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039630  mov      x25, x0
0x00039634  mov      x0, x21
0x00039638  bl       #0x58120   ; CALL objc_msgSend$imageView
0x0003963c  mov      x29, x29
0x00039640  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039644  mov      x22, x0
0x00039648  mov      x2, x25
0x0003964c  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00039650  mov      x0, x22
0x00039654  bl       #0x55d78   ; CALL _objc_release
0x00039658  cbnz     x23, #0x39668
0x0003965c  mov      x0, x25
0x00039660  bl       #0x55d78   ; CALL _objc_release
0x00039664  mov      x25, x24
0x00039668  mov      x0, x25
0x0003966c  bl       #0x55d78   ; CALL _objc_release
0x00039670  mov      x0, x21
0x00039674  mov      w2, #1
0x00039678  bl       #0x5a2a0   ; CALL objc_msgSend$setAccessoryType:
0x0003967c  mov      x0, x21
0x00039680  mov      w2, #3
0x00039684  bl       #0x5bfa0   ; CALL objc_msgSend$setSelectionStyle:
0x00039688  mov      x0, x23
0x0003968c  b        #0x39ea4
0x00039690  str      w28, [sp, #0x28]
0x00039694  str      x19, [sp, #0x20]
0x00039698  adrp     x2, #0x7b000
0x0003969c  add      x2, x2, #0xe88   ; STR "fav"
0x000396a0  mov      x0, x23
0x000396a4  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x000396a8  mov      x29, x29
0x000396ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000396b0  mov      x21, x0
0x000396b4  ldr      x2, [sp, #0xb8]
0x000396b8  mov      x0, x23
0x000396bc  bl       #0x58b40   ; CALL objc_msgSend$layoutOf:
0x000396c0  mov      x19, x0
0x000396c4  ldr      x2, [sp, #0xb8]
0x000396c8  mov      x0, x23
0x000396cc  bl       #0x56580   ; CALL objc_msgSend$appsOf:
0x000396d0  mov      x29, x29
0x000396d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000396d8  mov      x22, x0
0x000396dc  mov      x0, x23
0x000396e0  str      x19, [sp, #0x18]
0x000396e4  mov      x2, x19
0x000396e8  bl       #0x56a60   ; CALL objc_msgSend$boxCount:
0x000396ec  mov      x3, x0
0x000396f0  mov      x0, x22
0x000396f4  mov      x2, #0
0x000396f8  bl       #0x5d680   ; CALL objc_msgSend$subarrayWithRange:
0x000396fc  mov      x29, x29
0x00039700  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039704  mov      x24, x0
0x00039708  mov      x0, x22
0x0003970c  bl       #0x55d78   ; CALL _objc_release
0x00039710  adrp     x8, #0x8e000
0x00039714  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00039718  bl       #0x565c0   ; CALL objc_msgSend$array
0x0003971c  mov      x29, x29
0x00039720  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039724  mov      x25, x0
0x00039728  movi     v0.16b, #0
0x0003972c  stp      q0, q0, [sp, #0x70]
0x00039730  stp      q0, q0, [sp, #0x90]
0x00039734  mov      x0, x24
0x00039738  bl       #0x55d84   ; CALL _objc_retain
0x0003973c  add      x2, sp, #0x70
0x00039740  add      x3, sp, #0x190
0x00039744  mov      x0, x24
0x00039748  mov      w4, #0x10
0x0003974c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00039750  cbz      x0, #0x397e0
0x00039754  mov      x26, x0
0x00039758  ldr      x8, [sp, #0x80]
0x0003975c  ldr      x27, [x8]   ; @SEL "whatsNewNavigationController"
0x00039760  mov      x19, #0
0x00039764  ldr      x8, [sp, #0x80]
0x00039768  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0003976c  cmp      x8, x27
0x00039770  b.eq     #0x3977c
0x00039774  mov      x0, x24
0x00039778  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0003977c  ldr      x8, [sp, #0x78]
0x00039780  ldr      x28, [x8, x19, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00039784  mov      x0, x28
0x00039788  bl       #0x58c20   ; CALL objc_msgSend$length
0x0003978c  cbz      x0, #0x397b8
0x00039790  mov      x0, x28
0x00039794  bl       #0x3a3ec
0x00039798  mov      x29, x29
0x0003979c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000397a0  mov      x22, x0
0x000397a4  mov      x0, x25
0x000397a8  mov      x2, x22
0x000397ac  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x000397b0  mov      x0, x22
0x000397b4  bl       #0x55d78   ; CALL _objc_release
0x000397b8  add      x19, x19, #1
0x000397bc  cmp      x26, x19
0x000397c0  b.ne     #0x39764
0x000397c4  add      x2, sp, #0x70
0x000397c8  add      x3, sp, #0x190
0x000397cc  mov      x0, x24
0x000397d0  mov      w4, #0x10
0x000397d4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000397d8  mov      x26, x0
0x000397dc  cbnz     x0, #0x39760
0x000397e0  mov      x0, x24
0x000397e4  bl       #0x55d78   ; CALL _objc_release
0x000397e8  adrp     x19, #0x8e000
0x000397ec  ldr      x0, [x19, #0x958]   ; @CLASS NSString
0x000397f0  ldr      x8, [sp, #0x18]
0x000397f4  str      x8, [sp]
0x000397f8  adrp     x2, #0x7b000
0x000397fc  add      x2, x2, #0xea8   ; STR "SPLITSCREEN_LAYOUT_%ld"
0x00039800  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00039804  mov      x29, x29
0x00039808  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003980c  mov      x22, x0
0x00039810  bl       #0x17e20   ; CALL _L
0x00039814  mov      x29, x29
0x00039818  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003981c  mov      x27, x0
0x00039820  mov      x0, x22
0x00039824  bl       #0x55d78   ; CALL _objc_release
0x00039828  ldr      x2, [sp, #0xb8]
0x0003982c  mov      x0, x23
0x00039830  bl       #0x59120   ; CALL objc_msgSend$nameOf:
0x00039834  mov      x29, x29
0x00039838  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003983c  mov      x22, x0
0x00039840  mov      x0, x21
0x00039844  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00039848  mov      x29, x29
0x0003984c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039850  mov      x26, x0
0x00039854  mov      x2, x22
0x00039858  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0003985c  mov      x0, x26
0x00039860  bl       #0x55d78   ; CALL _objc_release
0x00039864  mov      x0, x22
0x00039868  bl       #0x55d78   ; CALL _objc_release
0x0003986c  mov      x0, x25
0x00039870  bl       #0x573c0   ; CALL objc_msgSend$count
0x00039874  ldr      x26, [x19, #0x958]   ; @CLASS NSString
0x00039878  cbz      x0, #0x39eac
0x0003987c  adrp     x2, #0x75000
0x00039880  add      x2, x2, #0xb28   ; STR ", "
0x00039884  mov      x0, x25
0x00039888  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x0003988c  mov      x29, x29
0x00039890  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039894  b        #0x39ec0
0x00039898  adrp     x2, #0x7b000
0x0003989c  add      x2, x2, #0xb08   ; STR "splitScreenEnabled"
0x000398a0  mov      x0, x23
0x000398a4  mov      w3, #1
0x000398a8  bl       #0x5d780   ; CALL objc_msgSend$switchForKey:def:
0x000398ac  mov      x29, x29
0x000398b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000398b4  mov      x22, x0
0x000398b8  mov      x0, x23
0x000398bc  mov      x2, x22
0x000398c0  mov      x3, x21
0x000398c4  bl       #0x5a280   ; CALL objc_msgSend$setAccessory:onCell:
0x000398c8  mov      x0, x22
0x000398cc  bl       #0x55d78   ; CALL _objc_release
0x000398d0  b        #0x3a2e8
0x000398d4  adrp     x2, #0x7c000
0x000398d8  add      x2, x2, #0x48   ; STR "gestures"
0x000398dc  mov      x0, x23
0x000398e0  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x000398e4  mov      x29, x29
0x000398e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000398ec  mov      x21, x0
0x000398f0  mov      x0, x23
0x000398f4  mov      x2, x21
0x000398f8  bl       #0x56a80   ; CALL objc_msgSend$boxInCell:
0x000398fc  mov      x29, x29
0x00039900  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039904  mov      x24, x0
0x00039908  mov      w2, #0x47
0x0003990c  bl       #0x5df80   ; CALL objc_msgSend$viewWithTag:
0x00039910  mov      x29, x29
0x00039914  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039918  mov      x25, x0
0x0003991c  cbnz     x0, #0x399ac
0x00039920  adrp     x8, #0x8e000
0x00039924  ldr      x0, [x8, #0x940]   ; @CLASS UILabel
0x00039928  bl       #0x55d60   ; CALL _objc_opt_new
0x0003992c  mov      x25, x0
0x00039930  mov      w2, #0x47
0x00039934  bl       #0x5c480   ; CALL objc_msgSend$setTag:
0x00039938  mov      x0, x25
0x0003993c  mov      x2, #0
0x00039940  bl       #0x5b820   ; CALL objc_msgSend$setNumberOfLines:
0x00039944  adrp     x8, #0x8e000
0x00039948  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x0003994c  fmov     d0, #12.50000000
0x00039950  bl       #0x5d7c0   ; CALL objc_msgSend$systemFontOfSize:
0x00039954  mov      x29, x29
0x00039958  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003995c  mov      x22, x0
0x00039960  mov      x0, x25
0x00039964  mov      x2, x22
0x00039968  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x0003996c  mov      x0, x22
0x00039970  bl       #0x55d78   ; CALL _objc_release
0x00039974  adrp     x8, #0x8e000
0x00039978  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0003997c  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x00039980  mov      x29, x29
0x00039984  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039988  mov      x22, x0
0x0003998c  mov      x0, x25
0x00039990  mov      x2, x22
0x00039994  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00039998  mov      x0, x22
0x0003999c  bl       #0x55d78   ; CALL _objc_release
0x000399a0  mov      x0, x24
0x000399a4  mov      x2, x25
0x000399a8  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x000399ac  adrp     x0, #0x7b000
0x000399b0  add      x0, x0, #0xcc8   ; STR "SPLITSCREEN_GUIDE_CAR_TEXT"
0x000399b4  bl       #0x17e20   ; CALL _L
0x000399b8  mov      x29, x29
0x000399bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000399c0  mov      x22, x0
0x000399c4  mov      x0, x25
0x000399c8  mov      x2, x22
0x000399cc  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x000399d0  mov      x0, x22
0x000399d4  bl       #0x55d78   ; CALL _objc_release
0x000399d8  mov      x8, #-0x3fc0000000000000
0x000399dc  fmov     d0, x8
0x000399e0  fadd     d8, d8, d0
0x000399e4  mov      x0, x23
0x000399e8  mov      x2, x19
0x000399ec  mov      x3, x20
0x000399f0  bl       #0x5d8e0   ; CALL objc_msgSend$tableView:heightForRowAtIndexPath:
0x000399f4  fmov     d1, #-20.00000000
0x000399f8  fadd     d3, d0, d1
0x000399fc  fmov     d0, #16.00000000
0x00039a00  fmov     d1, #10.00000000
0x00039a04  mov      x0, x25
0x00039a08  mov      v2.16b, v8.16b
0x00039a0c  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00039a10  mov      x0, x25
0x00039a14  bl       #0x55d78   ; CALL _objc_release
0x00039a18  b        #0x39ea0
0x00039a1c  mov      x0, x23
0x00039a20  bl       #0x5caa0   ; CALL objc_msgSend$showSiri
0x00039a24  mov      x24, x0
0x00039a28  adrp     x27, #0x7b000
0x00039a2c  add      x27, x27, #0xfe8   ; STR "SPLITSCREEN_SIRI"
0x00039a30  adrp     x25, #0x7c000
0x00039a34  add      x25, x25, #0x28   ; STR "command"
0x00039a38  adrp     x26, #0x79000
0x00039a3c  add      x26, x26, #0x988   ; STR "#4A4F80"
0x00039a40  adrp     x2, #0x7b000
0x00039a44  add      x2, x2, #0xfa8   ; STR "fold"
0x00039a48  mov      x0, x23
0x00039a4c  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x00039a50  mov      x29, x29
0x00039a54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039a58  mov      x21, x0
0x00039a5c  mov      x0, x27
0x00039a60  bl       #0x17e20   ; CALL _L
0x00039a64  mov      x29, x29
0x00039a68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039a6c  mov      x22, x0
0x00039a70  mov      x0, x21
0x00039a74  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00039a78  mov      x29, x29
0x00039a7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039a80  mov      x23, x0
0x00039a84  mov      x2, x22
0x00039a88  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00039a8c  mov      x0, x23
0x00039a90  bl       #0x55d78   ; CALL _objc_release
0x00039a94  mov      x0, x22
0x00039a98  bl       #0x55d78   ; CALL _objc_release
0x00039a9c  mov      x0, x26
0x00039aa0  bl       #0x18080   ; CALL _OMCColorFromHex
0x00039aa4  mov      x29, x29
0x00039aa8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039aac  mov      x22, x0
0x00039ab0  mov      x0, x25
0x00039ab4  mov      x1, x22
0x00039ab8  bl       #0x18144   ; CALL _OMCIcon
0x00039abc  mov      x29, x29
0x00039ac0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039ac4  mov      x23, x0
0x00039ac8  mov      x0, x21
0x00039acc  bl       #0x58120   ; CALL objc_msgSend$imageView
0x00039ad0  mov      x29, x29
0x00039ad4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039ad8  mov      x25, x0
0x00039adc  mov      x2, x23
0x00039ae0  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00039ae4  mov      x0, x25
0x00039ae8  bl       #0x55d78   ; CALL _objc_release
0x00039aec  mov      x0, x23
0x00039af0  bl       #0x55d78   ; CALL _objc_release
0x00039af4  mov      x0, x22
0x00039af8  bl       #0x55d78   ; CALL _objc_release
0x00039afc  adrp     x8, #0x8e000
0x00039b00  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x00039b04  bl       #0x55c7c   ; CALL _objc_alloc
0x00039b08  mov      x22, x0
0x00039b0c  adrp     x8, #0x8e000
0x00039b10  ldr      x0, [x8, #0xa78]   ; @CLASS UIImage
0x00039b14  adrp     x8, #0x79000
0x00039b18  add      x8, x8, #0x568   ; STR "chevron.right"
0x00039b1c  adrp     x9, #0x79000
0x00039b20  add      x9, x9, #0x548   ; STR "chevron.down"
0x00039b24  cmp      w24, #0
0x00039b28  csel     x2, x9, x8, ne
0x00039b2c  bl       #0x5d820   ; CALL objc_msgSend$systemImageNamed:
0x00039b30  mov      x29, x29
0x00039b34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039b38  mov      x23, x0
0x00039b3c  mov      x0, x22
0x00039b40  mov      x2, x23
0x00039b44  bl       #0x584c0   ; CALL objc_msgSend$initWithImage:
0x00039b48  mov      x24, x0
0x00039b4c  mov      x0, x23
0x00039b50  bl       #0x55d78   ; CALL _objc_release
0x00039b54  adrp     x8, #0x8e000
0x00039b58  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00039b5c  bl       #0x5d960   ; CALL objc_msgSend$tertiaryLabelColor
0x00039b60  mov      x29, x29
0x00039b64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039b68  mov      x22, x0
0x00039b6c  mov      x0, x24
0x00039b70  mov      x2, x22
0x00039b74  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x00039b78  mov      x0, x22
0x00039b7c  bl       #0x55d78   ; CALL _objc_release
0x00039b80  mov      x0, x21
0x00039b84  mov      x2, x24
0x00039b88  bl       #0x5a2c0   ; CALL objc_msgSend$setAccessoryView:
0x00039b8c  mov      x0, x21
0x00039b90  mov      w2, #3
0x00039b94  bl       #0x5bfa0   ; CALL objc_msgSend$setSelectionStyle:
0x00039b98  b        #0x39ea0
0x00039b9c  str      w28, [sp, #0x28]
0x00039ba0  str      x19, [sp, #0x20]
0x00039ba4  adrp     x2, #0x7c000
0x00039ba8  add      x2, x2, #0x68   ; STR "url"
0x00039bac  mov      x0, x23
0x00039bb0  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x00039bb4  mov      x29, x29
0x00039bb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039bbc  mov      x21, x0
0x00039bc0  mov      x0, x23
0x00039bc4  mov      x2, x21
0x00039bc8  bl       #0x56a80   ; CALL objc_msgSend$boxInCell:
0x00039bcc  mov      x29, x29
0x00039bd0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039bd4  mov      x24, x0
0x00039bd8  movi     v0.16b, #0
0x00039bdc  stp      q0, q0, [sp, #0x30]
0x00039be0  stp      q0, q0, [sp, #0x50]
0x00039be4  bl       #0x5d700   ; CALL objc_msgSend$subviews
0x00039be8  mov      x29, x29
0x00039bec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039bf0  mov      x22, x0
0x00039bf4  bl       #0x572e0   ; CALL objc_msgSend$copy
0x00039bf8  mov      x25, x0
0x00039bfc  mov      x0, x22
0x00039c00  bl       #0x55d78   ; CALL _objc_release
0x00039c04  add      x2, sp, #0x30
0x00039c08  add      x3, sp, #0x100
0x00039c0c  mov      x0, x25
0x00039c10  mov      w4, #0x10
0x00039c14  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00039c18  cbz      x0, #0x39c78
0x00039c1c  mov      x26, x0
0x00039c20  ldr      x8, [sp, #0x40]
0x00039c24  ldr      x22, [x8]   ; @SEL "whatsNewNavigationController"
0x00039c28  mov      x19, #0
0x00039c2c  ldr      x8, [sp, #0x40]
0x00039c30  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00039c34  cmp      x8, x22
0x00039c38  b.eq     #0x39c44
0x00039c3c  mov      x0, x25
0x00039c40  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00039c44  ldr      x8, [sp, #0x38]
0x00039c48  ldr      x0, [x8, x19, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00039c4c  bl       #0x59e00   ; CALL objc_msgSend$removeFromSuperview
0x00039c50  add      x19, x19, #1
0x00039c54  cmp      x26, x19
0x00039c58  b.ne     #0x39c2c
0x00039c5c  add      x2, sp, #0x30
0x00039c60  add      x3, sp, #0x100
0x00039c64  mov      x0, x25
0x00039c68  mov      w4, #0x10
0x00039c6c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00039c70  mov      x26, x0
0x00039c74  cbnz     x0, #0x39c28
0x00039c78  mov      x0, x25
0x00039c7c  bl       #0x55d78   ; CALL _objc_release
0x00039c80  mov      x0, x23
0x00039c84  bl       #0x5dde0   ; CALL objc_msgSend$urls
0x00039c88  mov      x29, x29
0x00039c8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039c90  mov      x22, x0
0x00039c94  ldr      x2, [sp, #0xc0]
0x00039c98  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00039c9c  mov      x29, x29
0x00039ca0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039ca4  mov      x25, x0
0x00039ca8  mov      x0, x22
0x00039cac  bl       #0x55d78   ; CALL _objc_release
0x00039cb0  adrp     x8, #0x8e000
0x00039cb4  ldr      x0, [x8, #0x940]   ; @CLASS UILabel
0x00039cb8  bl       #0x55c7c   ; CALL _objc_alloc
0x00039cbc  mov      x8, #-0x3fc0000000000000
0x00039cc0  fmov     d0, x8
0x00039cc4  fadd     d0, d8, d0
0x00039cc8  mov      x8, #-0x3fb2000000000000
0x00039ccc  fmov     d1, x8
0x00039cd0  fadd     d2, d0, d1
0x00039cd4  fmov     d0, #16.00000000
0x00039cd8  fmov     d1, #6.00000000
0x00039cdc  fmov     d3, #28.00000000
0x00039ce0  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x00039ce4  mov      x26, x0
0x00039ce8  mov      x2, x25
0x00039cec  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00039cf0  adrp     x28, #0x8e000
0x00039cf4  ldr      x0, [x28, #0x948]   ; @CLASS UIFont
0x00039cf8  adrp     x8, #0x74000
0x00039cfc  ldr      x8, [x8, #0x258]   ; @GOT _UIFontWeightRegular
0x00039d00  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x00039d04  fmov     d0, #11.00000000
0x00039d08  bl       #0x59000   ; CALL objc_msgSend$monospacedSystemFontOfSize:weight:
0x00039d0c  mov      x29, x29
0x00039d10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039d14  mov      x22, x0
0x00039d18  mov      x0, x26
0x00039d1c  mov      x2, x22
0x00039d20  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00039d24  mov      x0, x22
0x00039d28  bl       #0x55d78   ; CALL _objc_release
0x00039d2c  adrp     x8, #0x8e000
0x00039d30  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00039d34  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x00039d38  mov      x29, x29
0x00039d3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039d40  mov      x22, x0
0x00039d44  mov      x0, x26
0x00039d48  mov      x2, x22
0x00039d4c  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00039d50  mov      x0, x22
0x00039d54  bl       #0x55d78   ; CALL _objc_release
0x00039d58  mov      x0, x26
0x00039d5c  mov      w2, #5
0x00039d60  bl       #0x5b300   ; CALL objc_msgSend$setLineBreakMode:
0x00039d64  mov      x0, x24
0x00039d68  mov      x2, x26
0x00039d6c  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00039d70  adrp     x8, #0x8e000
0x00039d74  ldr      x0, [x8, #0xa50]   ; @CLASS UIButton
0x00039d78  mov      w2, #1
0x00039d7c  bl       #0x56b80   ; CALL objc_msgSend$buttonWithType:
0x00039d80  mov      x29, x29
0x00039d84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039d88  mov      x27, x0
0x00039d8c  adrp     x0, #0x7c000
0x00039d90  add      x0, x0, #0x88   ; STR "SPLITSCREEN_COPY"
0x00039d94  bl       #0x17e20   ; CALL _L
0x00039d98  mov      x29, x29
0x00039d9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039da0  mov      x22, x0
0x00039da4  mov      x0, x27
0x00039da8  mov      x2, x22
0x00039dac  mov      x3, #0
0x00039db0  bl       #0x5c600   ; CALL objc_msgSend$setTitle:forState:
0x00039db4  mov      x0, x22
0x00039db8  bl       #0x55d78   ; CALL _objc_release
0x00039dbc  ldr      x0, [x28, #0x948]   ; @CLASS UIFont
0x00039dc0  adrp     x8, #0x74000
0x00039dc4  ldr      x8, [x8, #0x260]   ; @GOT _UIFontWeightSemibold
0x00039dc8  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x00039dcc  fmov     d0, #13.00000000
0x00039dd0  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x00039dd4  mov      x29, x29
0x00039dd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039ddc  mov      x22, x0
0x00039de0  mov      x0, x27
0x00039de4  bl       #0x5db80   ; CALL objc_msgSend$titleLabel
0x00039de8  mov      x29, x29
0x00039dec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039df0  mov      x28, x0
0x00039df4  mov      x2, x22
0x00039df8  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00039dfc  mov      x0, x28
0x00039e00  bl       #0x55d78   ; CALL _objc_release
0x00039e04  mov      x0, x22
0x00039e08  bl       #0x55d78   ; CALL _objc_release
0x00039e0c  fmov     d0, #-16.00000000
0x00039e10  fadd     d0, d8, d0
0x00039e14  mov      x8, #-0x3fb4000000000000
0x00039e18  fmov     d1, x8
0x00039e1c  fadd     d0, d0, d1
0x00039e20  mov      x8, #0x404c000000000000
0x00039e24  fmov     d2, x8
0x00039e28  fmov     d1, #6.00000000
0x00039e2c  fmov     d3, #28.00000000
0x00039e30  mov      x0, x27
0x00039e34  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00039e38  mov      x0, x27
0x00039e3c  mov      w2, #2
0x00039e40  bl       #0x5a9c0   ; CALL objc_msgSend$setContentHorizontalAlignment:
0x00039e44  adrp     x1, #0x90000
0x00039e48  add      x1, x1, #0xc0
0x00039e4c  mov      x0, x27
0x00039e50  mov      x2, x25
0x00039e54  mov      w3, #3
0x00039e58  bl       #0x55db4   ; CALL _objc_setAssociatedObject
0x00039e5c  adrp     x8, #0x8b000
0x00039e60  ldr      x3, [x8, #0xee0]   ; @SEL "copyURL:"
0x00039e64  mov      x0, x27
0x00039e68  mov      x2, x23
0x00039e6c  mov      w4, #0x40
0x00039e70  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x00039e74  mov      x0, x24
0x00039e78  mov      x2, x27
0x00039e7c  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00039e80  mov      x0, x27
0x00039e84  bl       #0x55d78   ; CALL _objc_release
0x00039e88  mov      x0, x26
0x00039e8c  bl       #0x55d78   ; CALL _objc_release
0x00039e90  mov      x0, x25
0x00039e94  bl       #0x55d78   ; CALL _objc_release
0x00039e98  ldr      x19, [sp, #0x20]
0x00039e9c  ldr      w28, [sp, #0x28]
0x00039ea0  mov      x0, x24
0x00039ea4  bl       #0x55d78   ; CALL _objc_release
0x00039ea8  b        #0x3a2ec
0x00039eac  adrp     x0, #0x7b000
0x00039eb0  add      x0, x0, #0x968   ; STR "SPLITSCREEN_APP_NOT_SET"
0x00039eb4  bl       #0x17e20   ; CALL _L
0x00039eb8  mov      x29, x29
0x00039ebc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039ec0  mov      x28, x0
0x00039ec4  stp      x0, x27, [sp, #8]
0x00039ec8  str      x27, [sp]
0x00039ecc  adrp     x2, #0x76000
0x00039ed0  add      x2, x2, #0x4a8   ; STR "%@ · %@"
0x00039ed4  mov      x0, x26
0x00039ed8  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00039edc  mov      x29, x29
0x00039ee0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039ee4  mov      x22, x0
0x00039ee8  mov      x0, x21
0x00039eec  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x00039ef0  mov      x29, x29
0x00039ef4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039ef8  mov      x26, x0
0x00039efc  mov      x2, x22
0x00039f00  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00039f04  mov      x0, x26
0x00039f08  bl       #0x55d78   ; CALL _objc_release
0x00039f0c  mov      x0, x22
0x00039f10  bl       #0x55d78   ; CALL _objc_release
0x00039f14  mov      x0, x28
0x00039f18  bl       #0x55d78   ; CALL _objc_release
0x00039f1c  mov      x0, x24
0x00039f20  bl       #0x55d84   ; CALL _objc_retain
0x00039f24  adrp     x8, #0x8e000
0x00039f28  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00039f2c  bl       #0x565c0   ; CALL objc_msgSend$array
0x00039f30  mov      x29, x29
0x00039f34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039f38  mov      x28, x0
0x00039f3c  ldr      x19, [sp, #0x18]
0x00039f40  cmp      x19, #0x1f
0x00039f44  b.eq     #0x39f50
0x00039f48  cmp      x19, #0xd
0x00039f4c  b.ne     #0x3a0b8
0x00039f50  adrp     x26, #0x8e000
0x00039f54  ldr      x0, [x26, #0xc40]   ; @CLASS NSValue
0x00039f58  fmov     d0, xzr
0x00039f5c  fmov     d1, xzr
0x00039f60  fmov     d2, #26.00000000
0x00039f64  fmov     d3, #28.00000000
0x00039f68  bl       #0x5dee0   ; CALL objc_msgSend$valueWithCGRect:
0x00039f6c  mov      x29, x29
0x00039f70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039f74  mov      x22, x0
0x00039f78  mov      x0, x28
0x00039f7c  mov      x2, x22
0x00039f80  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00039f84  mov      x0, x22
0x00039f88  bl       #0x55d78   ; CALL _objc_release
0x00039f8c  ldr      x0, [x26, #0xc40]   ; @CLASS NSValue
0x00039f90  fmov     d0, #28.00000000
0x00039f94  fmov     d1, xzr
0x00039f98  fmov     d2, #22.00000000
0x00039f9c  fmov     d3, #13.00000000
0x00039fa0  bl       #0x5dee0   ; CALL objc_msgSend$valueWithCGRect:
0x00039fa4  mov      x29, x29
0x00039fa8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039fac  mov      x22, x0
0x00039fb0  mov      x0, x28
0x00039fb4  mov      x2, x22
0x00039fb8  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00039fbc  mov      x0, x22
0x00039fc0  bl       #0x55d78   ; CALL _objc_release
0x00039fc4  ldr      x0, [x26, #0xc40]   ; @CLASS NSValue
0x00039fc8  fmov     d0, #28.00000000
0x00039fcc  fmov     d1, #15.00000000
0x00039fd0  fmov     d2, #22.00000000
0x00039fd4  fmov     d3, #13.00000000
0x00039fd8  bl       #0x5dee0   ; CALL objc_msgSend$valueWithCGRect:
0x00039fdc  mov      x29, x29
0x00039fe0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00039fe4  mov      x22, x0
0x00039fe8  mov      x0, x28
0x00039fec  mov      x2, x22
0x00039ff0  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00039ff4  mov      x0, x22
0x00039ff8  bl       #0x55d78   ; CALL _objc_release
0x00039ffc  cmp      x19, #0x1f
0x0003a000  b.ne     #0x3a13c
0x0003a004  mov      x0, x28
0x0003a008  bl       #0x573c0   ; CALL objc_msgSend$count
0x0003a00c  cbz      x0, #0x3a13c
0x0003a010  mov      x27, #0
0x0003a014  mov      x8, #0x4049000000000000
0x0003a018  fmov     d12, x8
0x0003a01c  mov      x0, x28
0x0003a020  mov      x2, x27
0x0003a024  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0003a028  mov      x29, x29
0x0003a02c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a030  mov      x22, x0
0x0003a034  bl       #0x55f00   ; CALL objc_msgSend$CGRectValue
0x0003a038  mov      v8.16b, v0.16b
0x0003a03c  mov      v9.16b, v1.16b
0x0003a040  mov      v10.16b, v2.16b
0x0003a044  mov      v11.16b, v3.16b
0x0003a048  mov      x0, x22
0x0003a04c  bl       #0x55d78   ; CALL _objc_release
0x0003a050  mov      v0.16b, v8.16b
0x0003a054  mov      v1.16b, v9.16b
0x0003a058  mov      v2.16b, v10.16b
0x0003a05c  mov      v3.16b, v11.16b
0x0003a060  bl       #0x55a48   ; CALL _CGRectGetMaxX
0x0003a064  fsub     d0, d12, d0
0x0003a068  ldr      x0, [x26, #0xc40]   ; @CLASS NSValue
0x0003a06c  mov      v1.16b, v9.16b
0x0003a070  mov      v2.16b, v10.16b
0x0003a074  mov      v3.16b, v11.16b
0x0003a078  bl       #0x5dee0   ; CALL objc_msgSend$valueWithCGRect:
0x0003a07c  mov      x29, x29
0x0003a080  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a084  mov      x22, x0
0x0003a088  mov      x0, x28
0x0003a08c  mov      x2, x22
0x0003a090  mov      x3, x27
0x0003a094  bl       #0x5b860   ; CALL objc_msgSend$setObject:atIndexedSubscript:
0x0003a098  mov      x0, x22
0x0003a09c  bl       #0x55d78   ; CALL _objc_release
0x0003a0a0  add      x27, x27, #1
0x0003a0a4  mov      x0, x28
0x0003a0a8  bl       #0x573c0   ; CALL objc_msgSend$count
0x0003a0ac  cmp      x27, x0
0x0003a0b0  b.lo     #0x3a01c
0x0003a0b4  b        #0x3a13c
0x0003a0b8  mov      x26, #0
0x0003a0bc  cmp      x19, #3
0x0003a0c0  mov      w8, #2
0x0003a0c4  cinc     x27, x8, eq
0x0003a0c8  sub      x8, x27, #1
0x0003a0cc  ucvtf    d0, x8
0x0003a0d0  mov      x8, #0x4049000000000000
0x0003a0d4  fmov     d1, x8
0x0003a0d8  fmov     d2, #-2.00000000
0x0003a0dc  fmadd    d0, d0, d2, d1
0x0003a0e0  ucvtf    d1, x27
0x0003a0e4  fdiv     d8, d0, d1
0x0003a0e8  fmov     d0, #2.00000000
0x0003a0ec  fadd     d9, d8, d0
0x0003a0f0  adrp     x19, #0x8e000
0x0003a0f4  ldr      x0, [x19, #0xc40]   ; @CLASS NSValue
0x0003a0f8  ucvtf    d0, x26
0x0003a0fc  fmul     d0, d9, d0
0x0003a100  fmov     d1, xzr
0x0003a104  fmov     d3, #28.00000000
0x0003a108  mov      v2.16b, v8.16b
0x0003a10c  bl       #0x5dee0   ; CALL objc_msgSend$valueWithCGRect:
0x0003a110  mov      x29, x29
0x0003a114  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a118  mov      x22, x0
0x0003a11c  mov      x0, x28
0x0003a120  mov      x2, x22
0x0003a124  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0003a128  mov      x0, x22
0x0003a12c  bl       #0x55d78   ; CALL _objc_release
0x0003a130  add      x26, x26, #1
0x0003a134  cmp      x27, x26
0x0003a138  b.ne     #0x3a0f4
0x0003a13c  adrp     x8, #0x8e000
0x0003a140  ldr      x0, [x8, #0xb00]   ; @CLASS UIGraphicsImageRenderer
0x0003a144  bl       #0x55c7c   ; CALL _objc_alloc
0x0003a148  mov      x8, #0x404b000000000000
0x0003a14c  fmov     d0, x8
0x0003a150  mov      x8, #0x4040000000000000
0x0003a154  fmov     d1, x8
0x0003a158  bl       #0x58540   ; CALL objc_msgSend$initWithSize:
0x0003a15c  mov      x22, x0
0x0003a160  adrp     x8, #0x74000
0x0003a164  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x0003a168  str      x8, [sp, #0xc0]
0x0003a16c  adrp     x8, #0x65000
0x0003a170  ldr      d0, [x8, #0x600]
0x0003a174  str      d0, [sp, #0xc8]
0x0003a178  adrp     x8, #0x3b000
0x0003a17c  add      x8, x8, #0xc34
0x0003a180  adrp     x9, #0x74000
0x0003a184  add      x9, x9, #0xc60
0x0003a188  stp      x8, x9, [sp, #0xd0]
0x0003a18c  adrp     x8, #0x65000
0x0003a190  ldr      q0, [x8, #0xe70]
0x0003a194  str      q0, [sp, #0xf0]
0x0003a198  stp      x28, x24, [sp, #0xe0]
0x0003a19c  mov      x0, x28
0x0003a1a0  bl       #0x55d84   ; CALL _objc_retain
0x0003a1a4  mov      x0, x24
0x0003a1a8  bl       #0x55d84   ; CALL _objc_retain
0x0003a1ac  add      x2, sp, #0xc0
0x0003a1b0  mov      x0, x22
0x0003a1b4  bl       #0x58140   ; CALL objc_msgSend$imageWithActions:
0x0003a1b8  mov      x29, x29
0x0003a1bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a1c0  mov      x26, x0
0x0003a1c4  ldr      x0, [sp, #0xe8]
0x0003a1c8  bl       #0x55d78   ; CALL _objc_release
0x0003a1cc  ldr      x0, [sp, #0xe0]
0x0003a1d0  bl       #0x55d78   ; CALL _objc_release
0x0003a1d4  mov      x0, x28
0x0003a1d8  bl       #0x55d78   ; CALL _objc_release
0x0003a1dc  mov      x0, x24
0x0003a1e0  bl       #0x55d78   ; CALL _objc_release
0x0003a1e4  mov      x0, x22
0x0003a1e8  bl       #0x55d78   ; CALL _objc_release
0x0003a1ec  mov      x0, x21
0x0003a1f0  bl       #0x58120   ; CALL objc_msgSend$imageView
0x0003a1f4  mov      x29, x29
0x0003a1f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a1fc  mov      x22, x0
0x0003a200  mov      x2, x26
0x0003a204  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x0003a208  mov      x0, x22
0x0003a20c  bl       #0x55d78   ; CALL _objc_release
0x0003a210  mov      x0, x26
0x0003a214  bl       #0x55d78   ; CALL _objc_release
0x0003a218  adrp     x8, #0x8e000
0x0003a21c  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x0003a220  bl       #0x55c7c   ; CALL _objc_alloc
0x0003a224  mov      x22, x0
0x0003a228  adrp     x8, #0x8e000
0x0003a22c  ldr      x26, [x8, #0xa78]   ; @CLASS UIImage
0x0003a230  mov      x0, x23
0x0003a234  bl       #0x57940   ; CALL objc_msgSend$editing
0x0003a238  ldr      x8, [sp, #0xb8]
0x0003a23c  adrp     x9, #0x79000
0x0003a240  add      x9, x9, #0x568   ; STR "chevron.right"
0x0003a244  adrp     x10, #0x79000
0x0003a248  add      x10, x10, #0x548   ; STR "chevron.down"
0x0003a24c  cmp      x0, x8
0x0003a250  csel     x2, x10, x9, eq
0x0003a254  mov      x0, x26
0x0003a258  bl       #0x5d820   ; CALL objc_msgSend$systemImageNamed:
0x0003a25c  mov      x29, x29
0x0003a260  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a264  mov      x23, x0
0x0003a268  mov      x0, x22
0x0003a26c  mov      x2, x23
0x0003a270  bl       #0x584c0   ; CALL objc_msgSend$initWithImage:
0x0003a274  mov      x22, x0
0x0003a278  mov      x0, x23
0x0003a27c  bl       #0x55d78   ; CALL _objc_release
0x0003a280  adrp     x8, #0x8e000
0x0003a284  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0003a288  bl       #0x5d960   ; CALL objc_msgSend$tertiaryLabelColor
0x0003a28c  mov      x29, x29
0x0003a290  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a294  mov      x23, x0
0x0003a298  mov      x0, x22
0x0003a29c  mov      x2, x23
0x0003a2a0  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x0003a2a4  mov      x0, x23
0x0003a2a8  bl       #0x55d78   ; CALL _objc_release
0x0003a2ac  mov      x0, x21
0x0003a2b0  mov      x2, x22
0x0003a2b4  bl       #0x5a2c0   ; CALL objc_msgSend$setAccessoryView:
0x0003a2b8  mov      x0, x21
0x0003a2bc  mov      w2, #3
0x0003a2c0  bl       #0x5bfa0   ; CALL objc_msgSend$setSelectionStyle:
0x0003a2c4  mov      x0, x22
0x0003a2c8  bl       #0x55d78   ; CALL _objc_release
0x0003a2cc  ldr      x0, [sp, #0x10]
0x0003a2d0  bl       #0x55d78   ; CALL _objc_release
0x0003a2d4  mov      x0, x25
0x0003a2d8  bl       #0x55d78   ; CALL _objc_release
0x0003a2dc  mov      x0, x24
0x0003a2e0  bl       #0x55d78   ; CALL _objc_release
0x0003a2e4  ldr      x19, [sp, #0x20]
0x0003a2e8  ldr      w28, [sp, #0x28]
0x0003a2ec  fmov     d8, #1.00000000
0x0003a2f0  tbnz     w28, #0, #0x3a328
0x0003a2f4  mov      x0, x20
0x0003a2f8  bl       #0x5a180   ; CALL objc_msgSend$section
0x0003a2fc  cmp      x0, #2
0x0003a300  b.lt     #0x3a328
0x0003a304  mov      x0, x20
0x0003a308  bl       #0x5a180   ; CALL objc_msgSend$section
0x0003a30c  cmp      x0, #5
0x0003a310  cset     w22, eq
0x0003a314  adrp     x8, #0x65000
0x0003a318  ldr      d0, [x8, #0x780]
0x0003a31c  fmov     d1, #1.00000000
0x0003a320  fcsel    d8, d1, d0, eq
0x0003a324  b        #0x3a32c
0x0003a328  mov      w22, #1
0x0003a32c  mov      x0, x21
0x0003a330  bl       #0x57280   ; CALL objc_msgSend$contentView
0x0003a334  mov      x29, x29
0x0003a338  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a33c  mov      x23, x0
0x0003a340  mov      v0.16b, v8.16b
0x0003a344  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x0003a348  mov      x0, x23
0x0003a34c  bl       #0x55d78   ; CALL _objc_release
0x0003a350  mov      x0, x21
0x0003a354  bl       #0x55f80   ; CALL objc_msgSend$accessoryView
0x0003a358  mov      x29, x29
0x0003a35c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a360  mov      x23, x0
0x0003a364  mov      v0.16b, v8.16b
0x0003a368  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x0003a36c  mov      x0, x23
0x0003a370  bl       #0x55d78   ; CALL _objc_release
0x0003a374  mov      x0, x21
0x0003a378  mov      x2, x22
0x0003a37c  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x0003a380  mov      x0, x21
0x0003a384  bl       #0x55d84   ; CALL _objc_retain
0x0003a388  mov      x0, x21
0x0003a38c  bl       #0x55d78   ; CALL _objc_release
0x0003a390  mov      x0, x20
0x0003a394  bl       #0x55d78   ; CALL _objc_release
0x0003a398  mov      x0, x19
0x0003a39c  bl       #0x55d78   ; CALL _objc_release
0x0003a3a0  ldur     x8, [x29, #-0x90]
0x0003a3a4  adrp     x9, #0x74000
0x0003a3a8  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0003a3ac  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0003a3b0  cmp      x9, x8
0x0003a3b4  b.ne     #0x3a3e8
0x0003a3b8  mov      x0, x21
0x0003a3bc  add      sp, sp, #0x220
0x0003a3c0  ldp      x29, x30, [sp, #0x80]
0x0003a3c4  ldp      x20, x19, [sp, #0x70]
0x0003a3c8  ldp      x22, x21, [sp, #0x60]
0x0003a3cc  ldp      x24, x23, [sp, #0x50]
0x0003a3d0  ldp      x26, x25, [sp, #0x40]
0x0003a3d4  ldp      x28, x27, [sp, #0x30]
0x0003a3d8  ldp      d9, d8, [sp, #0x20]
0x0003a3dc  ldp      d11, d10, [sp, #0x10]
0x0003a3e0  ldp      d13, d12, [sp], #0x90
0x0003a3e4  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0003a3e8  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0003a3ec  stp      x22, x21, [sp, #-0x30]!
0x0003a3f0  stp      x20, x19, [sp, #0x10]
0x0003a3f4  stp      x29, x30, [sp, #0x20]
0x0003a3f8  add      x29, sp, #0x20
0x0003a3fc  mov      x19, x0
0x0003a400  bl       #0x55d84   ; CALL _objc_retain
0x0003a404  adrp     x0, #0x63000
0x0003a408  add      x0, x0, #0xf6   ; CSTR "LSApplicationProxy"
0x0003a40c  bl       #0x55d0c   ; CALL _objc_getClass
0x0003a410  mov      x20, x0
0x0003a414  cbz      x0, #0x3a46c
0x0003a418  adrp     x0, #0x79000
0x0003a41c  add      x0, x0, #0xc68   ; STR "applicationProxyForIdentifier:"
0x0003a420  bl       #0x55b08   ; CALL _NSSelectorFromString
0x0003a424  mov      x1, x0
0x0003a428  mov      x0, x20
0x0003a42c  mov      x2, x19
0x0003a430  bl       #0x55d30   ; CALL _objc_msgSend
0x0003a434  mov      x29, x29
0x0003a438  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a43c  mov      x20, x0
0x0003a440  cbz      x0, #0x3a46c
0x0003a444  adrp     x0, #0x79000
0x0003a448  add      x0, x0, #0xc88   ; STR "localizedName"
0x0003a44c  bl       #0x55b08   ; CALL _NSSelectorFromString
0x0003a450  mov      x1, x0
0x0003a454  mov      x0, x20
0x0003a458  bl       #0x55d30   ; CALL _objc_msgSend
0x0003a45c  mov      x29, x29
0x0003a460  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a464  mov      x21, x0
0x0003a468  b        #0x3a470
0x0003a46c  mov      x21, #0
0x0003a470  adrp     x8, #0x8e000
0x0003a474  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0003a478  bl       #0x55d48   ; CALL _objc_opt_class
0x0003a47c  mov      x1, x0
0x0003a480  mov      x0, x21
0x0003a484  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0003a488  tbz      w0, #0, #0x3a49c
0x0003a48c  mov      x0, x21
0x0003a490  bl       #0x58c20   ; CALL objc_msgSend$length
0x0003a494  mov      x22, x21
0x0003a498  cbnz     x0, #0x3a4a0
0x0003a49c  mov      x22, x19
0x0003a4a0  mov      x0, x22
0x0003a4a4  bl       #0x55d84   ; CALL _objc_retain
0x0003a4a8  mov      x0, x21
0x0003a4ac  bl       #0x55d78   ; CALL _objc_release
0x0003a4b0  mov      x0, x20
0x0003a4b4  bl       #0x55d78   ; CALL _objc_release
0x0003a4b8  mov      x0, x19
0x0003a4bc  bl       #0x55d78   ; CALL _objc_release
0x0003a4c0  mov      x0, x22
0x0003a4c4  ldp      x29, x30, [sp, #0x20]
0x0003a4c8  ldp      x20, x19, [sp, #0x10]
0x0003a4cc  ldp      x22, x21, [sp], #0x30
0x0003a4d0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCSplitScreenController chip:key:]  va=0x3a4d4 size=844 types=@32@0:8@16@24
0x0003a4d4  sub      sp, sp, #0x80
0x0003a4d8  stp      d9, d8, [sp, #0x20]
0x0003a4dc  stp      x26, x25, [sp, #0x30]
0x0003a4e0  stp      x24, x23, [sp, #0x40]
0x0003a4e4  stp      x22, x21, [sp, #0x50]
0x0003a4e8  stp      x20, x19, [sp, #0x60]
0x0003a4ec  stp      x29, x30, [sp, #0x70]
0x0003a4f0  add      x29, sp, #0x70
0x0003a4f4  mov      x21, x3
0x0003a4f8  mov      x19, x2
0x0003a4fc  mov      x20, x0
0x0003a500  adrp     x8, #0x74000
0x0003a504  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0003a508  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003a50c  str      x8, [sp, #0x18]
0x0003a510  mov      x0, x2
0x0003a514  bl       #0x55d84   ; CALL _objc_retain
0x0003a518  mov      x0, x21
0x0003a51c  bl       #0x55d84   ; CALL _objc_retain
0x0003a520  adrp     x3, #0x74000
0x0003a524  ldr      x3, [x3, #0x1b8]   ; @GOT ___kCFBooleanTrue
0x0003a528  mov      x0, x20
0x0003a52c  mov      x2, x21
0x0003a530  bl       #0x598c0   ; CALL objc_msgSend$prefForKey:def:
0x0003a534  mov      x29, x29
0x0003a538  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a53c  mov      x22, x0
0x0003a540  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x0003a544  mov      x23, x0
0x0003a548  mov      x0, x22
0x0003a54c  bl       #0x55d78   ; CALL _objc_release
0x0003a550  adrp     x8, #0x8e000
0x0003a554  ldr      x0, [x8, #0xa50]   ; @CLASS UIButton
0x0003a558  mov      x2, #0
0x0003a55c  bl       #0x56b80   ; CALL objc_msgSend$buttonWithType:
0x0003a560  mov      x29, x29
0x0003a564  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a568  mov      x22, x0
0x0003a56c  mov      x2, x19
0x0003a570  mov      x3, #0
0x0003a574  bl       #0x5c600   ; CALL objc_msgSend$setTitle:forState:
0x0003a578  adrp     x8, #0x8e000
0x0003a57c  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x0003a580  adrp     x8, #0x74000
0x0003a584  ldr      x8, [x8, #0x260]   ; @GOT _UIFontWeightSemibold
0x0003a588  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x0003a58c  fmov     d0, #12.50000000
0x0003a590  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x0003a594  mov      x29, x29
0x0003a598  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a59c  mov      x24, x0
0x0003a5a0  mov      x0, x22
0x0003a5a4  bl       #0x5db80   ; CALL objc_msgSend$titleLabel
0x0003a5a8  mov      x29, x29
0x0003a5ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a5b0  mov      x25, x0
0x0003a5b4  mov      x2, x24
0x0003a5b8  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x0003a5bc  mov      x0, x25
0x0003a5c0  bl       #0x55d78   ; CALL _objc_release
0x0003a5c4  mov      x0, x24
0x0003a5c8  bl       #0x55d78   ; CALL _objc_release
0x0003a5cc  adrp     x24, #0x8e000
0x0003a5d0  ldr      x0, [x24, #0x910]   ; @CLASS UIColor
0x0003a5d4  tbz      w23, #0, #0x3a618
0x0003a5d8  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0003a5dc  mov      x29, x29
0x0003a5e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a5e4  mov      x23, x0
0x0003a5e8  mov      x0, x22
0x0003a5ec  mov      x2, x23
0x0003a5f0  mov      x3, #0
0x0003a5f4  bl       #0x5c620   ; CALL objc_msgSend$setTitleColor:forState:
0x0003a5f8  mov      x0, x23
0x0003a5fc  bl       #0x55d78   ; CALL _objc_release
0x0003a600  adrp     x0, #0x78000
0x0003a604  add      x0, x0, #0xf28   ; STR "#8B7CFF"
0x0003a608  bl       #0x18080   ; CALL _OMCColorFromHex
0x0003a60c  mov      x29, x29
0x0003a610  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a614  b        #0x3a65c
0x0003a618  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x0003a61c  mov      x29, x29
0x0003a620  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a624  mov      x23, x0
0x0003a628  mov      x0, x22
0x0003a62c  mov      x2, x23
0x0003a630  mov      x3, #0
0x0003a634  bl       #0x5c620   ; CALL objc_msgSend$setTitleColor:forState:
0x0003a638  mov      x0, x23
0x0003a63c  bl       #0x55d78   ; CALL _objc_release
0x0003a640  ldr      x0, [x24, #0x910]   ; @CLASS UIColor
0x0003a644  adrp     x8, #0x65000
0x0003a648  ldr      d1, [x8, #0x758]
0x0003a64c  fmov     d0, #0.50000000
0x0003a650  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0003a654  mov      x29, x29
0x0003a658  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a65c  mov      x23, x0
0x0003a660  mov      x0, x22
0x0003a664  mov      x2, x23
0x0003a668  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0003a66c  mov      x0, x23
0x0003a670  bl       #0x55d78   ; CALL _objc_release
0x0003a674  mov      x0, x22
0x0003a678  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003a67c  mov      x29, x29
0x0003a680  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a684  mov      x23, x0
0x0003a688  fmov     d0, #10.00000000
0x0003a68c  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0003a690  mov      x0, x23
0x0003a694  bl       #0x55d78   ; CALL _objc_release
0x0003a698  adrp     x8, #0x74000
0x0003a69c  ldr      x8, [x8, #0x1d8]   ; @GOT _NSFontAttributeName
0x0003a6a0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003a6a4  str      x8, [sp, #8]
0x0003a6a8  mov      x0, x22
0x0003a6ac  bl       #0x5db80   ; CALL objc_msgSend$titleLabel
0x0003a6b0  mov      x29, x29
0x0003a6b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a6b8  mov      x23, x0
0x0003a6bc  bl       #0x57c60   ; CALL objc_msgSend$font
0x0003a6c0  mov      x29, x29
0x0003a6c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a6c8  mov      x24, x0
0x0003a6cc  str      x0, [sp, #0x10]
0x0003a6d0  adrp     x8, #0x8e000
0x0003a6d4  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x0003a6d8  add      x2, sp, #0x10
0x0003a6dc  add      x3, sp, #8
0x0003a6e0  mov      w4, #1
0x0003a6e4  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0003a6e8  mov      x29, x29
0x0003a6ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a6f0  mov      x25, x0
0x0003a6f4  mov      x0, x19
0x0003a6f8  mov      x2, x25
0x0003a6fc  bl       #0x5cc00   ; CALL objc_msgSend$sizeWithAttributes:
0x0003a700  frintp   d8, d0
0x0003a704  mov      x0, x25
0x0003a708  bl       #0x55d78   ; CALL _objc_release
0x0003a70c  mov      x0, x24
0x0003a710  bl       #0x55d78   ; CALL _objc_release
0x0003a714  mov      x0, x23
0x0003a718  bl       #0x55d78   ; CALL _objc_release
0x0003a71c  mov      x0, x22
0x0003a720  bl       #0x5e1c0   ; CALL objc_msgSend$widthAnchor
0x0003a724  mov      x29, x29
0x0003a728  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a72c  mov      x23, x0
0x0003a730  fmov     d0, #20.00000000
0x0003a734  fadd     d0, d8, d0
0x0003a738  bl       #0x57180   ; CALL objc_msgSend$constraintEqualToConstant:
0x0003a73c  mov      x29, x29
0x0003a740  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a744  mov      x24, x0
0x0003a748  mov      w2, #1
0x0003a74c  bl       #0x5a2e0   ; CALL objc_msgSend$setActive:
0x0003a750  mov      x0, x24
0x0003a754  bl       #0x55d78   ; CALL _objc_release
0x0003a758  mov      x0, x23
0x0003a75c  bl       #0x55d78   ; CALL _objc_release
0x0003a760  mov      x0, x22
0x0003a764  bl       #0x57f40   ; CALL objc_msgSend$heightAnchor
0x0003a768  mov      x29, x29
0x0003a76c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a770  mov      x23, x0
0x0003a774  fmov     d0, #30.00000000
0x0003a778  bl       #0x57180   ; CALL objc_msgSend$constraintEqualToConstant:
0x0003a77c  mov      x29, x29
0x0003a780  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a784  mov      x24, x0
0x0003a788  mov      w2, #1
0x0003a78c  bl       #0x5a2e0   ; CALL objc_msgSend$setActive:
0x0003a790  mov      x0, x24
0x0003a794  bl       #0x55d78   ; CALL _objc_release
0x0003a798  mov      x0, x23
0x0003a79c  bl       #0x55d78   ; CALL _objc_release
0x0003a7a0  adrp     x1, #0x90000
0x0003a7a4  add      x1, x1, #0xc0
0x0003a7a8  mov      x0, x22
0x0003a7ac  mov      x2, x21
0x0003a7b0  mov      w3, #3
0x0003a7b4  bl       #0x55db4   ; CALL _objc_setAssociatedObject
0x0003a7b8  mov      x0, x21
0x0003a7bc  bl       #0x55d78   ; CALL _objc_release
0x0003a7c0  adrp     x8, #0x8b000
0x0003a7c4  ldr      x3, [x8, #0xee8]   ; @SEL "chipTapped:"
0x0003a7c8  mov      x0, x22
0x0003a7cc  mov      x2, x20
0x0003a7d0  mov      w4, #0x40
0x0003a7d4  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x0003a7d8  mov      x0, x19
0x0003a7dc  bl       #0x55d78   ; CALL _objc_release
0x0003a7e0  ldr      x8, [sp, #0x18]
0x0003a7e4  adrp     x9, #0x74000
0x0003a7e8  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0003a7ec  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0003a7f0  cmp      x9, x8
0x0003a7f4  b.ne     #0x3a81c
0x0003a7f8  mov      x0, x22
0x0003a7fc  ldp      x29, x30, [sp, #0x70]
0x0003a800  ldp      x20, x19, [sp, #0x60]
0x0003a804  ldp      x22, x21, [sp, #0x50]
0x0003a808  ldp      x24, x23, [sp, #0x40]
0x0003a80c  ldp      x26, x25, [sp, #0x30]
0x0003a810  ldp      d9, d8, [sp, #0x20]
0x0003a814  add      sp, sp, #0x80
0x0003a818  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0003a81c  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCSplitScreenController chipTapped:]  va=0x3a820 size=208 types=v24@0:8@16
0x0003a820  stp      x22, x21, [sp, #-0x30]!
0x0003a824  stp      x20, x19, [sp, #0x10]
0x0003a828  stp      x29, x30, [sp, #0x20]
0x0003a82c  add      x29, sp, #0x20
0x0003a830  mov      x19, x0
0x0003a834  adrp     x1, #0x90000
0x0003a838  add      x1, x1, #0xc0
0x0003a83c  mov      x0, x2
0x0003a840  bl       #0x55d00   ; CALL _objc_getAssociatedObject
0x0003a844  mov      x29, x29
0x0003a848  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a84c  mov      x20, x0
0x0003a850  adrp     x8, #0x8e000
0x0003a854  ldr      x0, [x8, #0x938]   ; @CLASS UISelectionFeedbackGenerator
0x0003a858  bl       #0x55d60   ; CALL _objc_opt_new
0x0003a85c  mov      x21, x0
0x0003a860  bl       #0x5a200   ; CALL objc_msgSend$selectionChanged
0x0003a864  mov      x0, x21
0x0003a868  bl       #0x55d78   ; CALL _objc_release
0x0003a86c  adrp     x8, #0x8e000
0x0003a870  ldr      x21, [x8, #0x928]   ; @CLASS NSNumber
0x0003a874  adrp     x3, #0x74000
0x0003a878  ldr      x3, [x3, #0x1b8]   ; @GOT ___kCFBooleanTrue
0x0003a87c  mov      x0, x19
0x0003a880  mov      x2, x20
0x0003a884  bl       #0x598c0   ; CALL objc_msgSend$prefForKey:def:
0x0003a888  mov      x29, x29
0x0003a88c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a890  mov      x22, x0
0x0003a894  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x0003a898  eor      w2, w0, #1
0x0003a89c  mov      x0, x21
0x0003a8a0  bl       #0x59300   ; CALL objc_msgSend$numberWithInt:
0x0003a8a4  mov      x29, x29
0x0003a8a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a8ac  mov      x21, x0
0x0003a8b0  mov      x0, x19
0x0003a8b4  mov      x2, x21
0x0003a8b8  mov      x3, x20
0x0003a8bc  bl       #0x5d3c0   ; CALL objc_msgSend$storeValue:forKey:
0x0003a8c0  mov      x0, x21
0x0003a8c4  bl       #0x55d78   ; CALL _objc_release
0x0003a8c8  mov      x0, x22
0x0003a8cc  bl       #0x55d78   ; CALL _objc_release
0x0003a8d0  mov      x0, x19
0x0003a8d4  mov      w2, #4
0x0003a8d8  bl       #0x59ce0   ; CALL objc_msgSend$reloadSection:
0x0003a8dc  mov      x0, x20
0x0003a8e0  ldp      x29, x30, [sp, #0x20]
0x0003a8e4  ldp      x20, x19, [sp, #0x10]
0x0003a8e8  ldp      x22, x21, [sp], #0x30
0x0003a8ec  b        #0x55d78   ; CALL _objc_release

=== -[OMCSplitScreenController editorCell:fav:width:]  va=0x3a8f0 size=3048 types=@40@0:8q16q24d32
0x0003a8f0  stp      d11, d10, [sp, #-0x80]!
0x0003a8f4  stp      d9, d8, [sp, #0x10]
0x0003a8f8  stp      x28, x27, [sp, #0x20]
0x0003a8fc  stp      x26, x25, [sp, #0x30]
0x0003a900  stp      x24, x23, [sp, #0x40]
0x0003a904  stp      x22, x21, [sp, #0x50]
0x0003a908  stp      x20, x19, [sp, #0x60]
0x0003a90c  stp      x29, x30, [sp, #0x70]
0x0003a910  add      x29, sp, #0x70
0x0003a914  sub      sp, sp, #0x180
0x0003a918  mov      v8.16b, v0.16b
0x0003a91c  str      x3, [sp, #0x40]
0x0003a920  mov      x19, x2
0x0003a924  mov      x21, x0
0x0003a928  adrp     x8, #0x74000
0x0003a92c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0003a930  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003a934  stur     x8, [x29, #-0x80]
0x0003a938  adrp     x8, #0x8e000
0x0003a93c  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0003a940  str      x2, [sp]
0x0003a944  adrp     x2, #0x7c000
0x0003a948  add      x2, x2, #0xa8   ; STR "edit%ld"
0x0003a94c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0003a950  mov      x29, x29
0x0003a954  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a958  mov      x20, x0
0x0003a95c  mov      x0, x21
0x0003a960  mov      x2, x20
0x0003a964  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x0003a968  mov      x29, x29
0x0003a96c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a970  mov      x25, x0
0x0003a974  mov      x0, x20
0x0003a978  bl       #0x55d78   ; CALL _objc_release
0x0003a97c  str      x21, [sp, #0x48]
0x0003a980  mov      x0, x21
0x0003a984  mov      x2, x25
0x0003a988  bl       #0x56a80   ; CALL objc_msgSend$boxInCell:
0x0003a98c  mov      x29, x29
0x0003a990  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a994  mov      x26, x0
0x0003a998  movi     v0.16b, #0
0x0003a99c  stp      q0, q0, [sp, #0x50]
0x0003a9a0  stp      q0, q0, [sp, #0x70]
0x0003a9a4  bl       #0x5d700   ; CALL objc_msgSend$subviews
0x0003a9a8  mov      x29, x29
0x0003a9ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003a9b0  mov      x21, x0
0x0003a9b4  bl       #0x572e0   ; CALL objc_msgSend$copy
0x0003a9b8  mov      x20, x0
0x0003a9bc  mov      x0, x21
0x0003a9c0  bl       #0x55d78   ; CALL _objc_release
0x0003a9c4  add      x2, sp, #0x50
0x0003a9c8  add      x3, sp, #0xf0
0x0003a9cc  mov      x0, x20
0x0003a9d0  mov      w4, #0x10
0x0003a9d4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0003a9d8  cbz      x0, #0x3aa38
0x0003a9dc  mov      x21, x0
0x0003a9e0  ldr      x8, [sp, #0x60]
0x0003a9e4  ldr      x22, [x8]   ; @SEL "whatsNewNavigationController"
0x0003a9e8  mov      x23, #0
0x0003a9ec  ldr      x8, [sp, #0x60]
0x0003a9f0  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0003a9f4  cmp      x8, x22
0x0003a9f8  b.eq     #0x3aa04
0x0003a9fc  mov      x0, x20
0x0003aa00  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0003aa04  ldr      x8, [sp, #0x58]
0x0003aa08  ldr      x0, [x8, x23, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0003aa0c  bl       #0x59e00   ; CALL objc_msgSend$removeFromSuperview
0x0003aa10  add      x23, x23, #1
0x0003aa14  cmp      x21, x23
0x0003aa18  b.ne     #0x3a9ec
0x0003aa1c  add      x2, sp, #0x50
0x0003aa20  add      x3, sp, #0xf0
0x0003aa24  mov      x0, x20
0x0003aa28  mov      w4, #0x10
0x0003aa2c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0003aa30  mov      x21, x0
0x0003aa34  cbnz     x0, #0x3a9e8
0x0003aa38  mov      x0, x20
0x0003aa3c  bl       #0x55d78   ; CALL _objc_release
0x0003aa40  bl       #0x17e8c   ; CALL _OMCAccentColor
0x0003aa44  mov      x29, x29
0x0003aa48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003aa4c  mov      x20, x0
0x0003aa50  adrp     x8, #0x65000
0x0003aa54  ldr      d0, [x8, #0x760]
0x0003aa58  bl       #0x56e80   ; CALL objc_msgSend$colorWithAlphaComponent:
0x0003aa5c  mov      x29, x29
0x0003aa60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003aa64  mov      x21, x0
0x0003aa68  mov      x0, x25
0x0003aa6c  mov      x2, x21
0x0003aa70  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0003aa74  mov      x0, x21
0x0003aa78  bl       #0x55d78   ; CALL _objc_release
0x0003aa7c  mov      x0, x20
0x0003aa80  bl       #0x55d78   ; CALL _objc_release
0x0003aa84  cmp      x19, #2
0x0003aa88  b.eq     #0x3aea8
0x0003aa8c  cmp      x19, #1
0x0003aa90  b.eq     #0x3ad38
0x0003aa94  cbnz     x19, #0x3b38c
0x0003aa98  adrp     x8, #0x8e000
0x0003aa9c  ldr      x0, [x8, #0x940]   ; @CLASS UILabel
0x0003aaa0  bl       #0x55c7c   ; CALL _objc_alloc
0x0003aaa4  mov      x8, #0x4054000000000000
0x0003aaa8  fmov     d2, x8
0x0003aaac  mov      x8, #0x404e000000000000
0x0003aab0  fmov     d3, x8
0x0003aab4  fmov     d0, #16.00000000
0x0003aab8  fmov     d1, xzr
0x0003aabc  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0003aac0  mov      x27, x0
0x0003aac4  adrp     x0, #0x7c000
0x0003aac8  add      x0, x0, #0xc8   ; STR "SPLITSCREEN_PAIR_NAME"
0x0003aacc  bl       #0x17e20   ; CALL _L
0x0003aad0  mov      x29, x29
0x0003aad4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003aad8  mov      x19, x0
0x0003aadc  mov      x0, x27
0x0003aae0  mov      x2, x19
0x0003aae4  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0003aae8  mov      x0, x19
0x0003aaec  bl       #0x55d78   ; CALL _objc_release
0x0003aaf0  mov      x0, x26
0x0003aaf4  mov      x2, x27
0x0003aaf8  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0003aafc  adrp     x8, #0x8e000
0x0003ab00  ldr      x0, [x8, #0xba0]   ; @CLASS UITextField
0x0003ab04  bl       #0x55c7c   ; CALL _objc_alloc
0x0003ab08  mov      x8, #-0x3fa8000000000000
0x0003ab0c  fmov     d0, x8
0x0003ab10  fadd     d0, d8, d0
0x0003ab14  fmov     d1, #-14.00000000
0x0003ab18  fadd     d2, d0, d1
0x0003ab1c  mov      x8, #0x4058000000000000
0x0003ab20  fmov     d0, x8
0x0003ab24  mov      x8, #0x4040000000000000
0x0003ab28  fmov     d3, x8
0x0003ab2c  fmov     d1, #14.00000000
0x0003ab30  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0003ab34  mov      x19, x0
0x0003ab38  adrp     x24, #0x8e000
0x0003ab3c  ldr      x0, [x24, #0x958]   ; @CLASS NSString
0x0003ab40  adrp     x8, #0x77000
0x0003ab44  add      x8, x8, #0x108   ; STR "Name"
0x0003ab48  ldr      x23, [sp, #0x40]
0x0003ab4c  stp      x23, x8, [sp]
0x0003ab50  adrp     x2, #0x7b000
0x0003ab54  add      x2, x2, #0xb28   ; STR "splitScreenFav%ld%@"
0x0003ab58  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0003ab5c  mov      x29, x29
0x0003ab60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ab64  mov      x20, x0
0x0003ab68  ldr      x22, [sp, #0x48]
0x0003ab6c  mov      x0, x22
0x0003ab70  mov      x2, x20
0x0003ab74  bl       #0x5d4e0   ; CALL objc_msgSend$stringForKey:
0x0003ab78  mov      x29, x29
0x0003ab7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ab80  mov      x21, x0
0x0003ab84  mov      x0, x19
0x0003ab88  mov      x2, x21
0x0003ab8c  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0003ab90  mov      x0, x21
0x0003ab94  bl       #0x55d78   ; CALL _objc_release
0x0003ab98  mov      x0, x20
0x0003ab9c  bl       #0x55d78   ; CALL _objc_release
0x0003aba0  ldr      x0, [x24, #0x958]   ; @CLASS NSString
0x0003aba4  str      x23, [sp]
0x0003aba8  adrp     x2, #0x7b000
0x0003abac  add      x2, x2, #0xbc8   ; STR "SPLITSCREEN_FAV%ld_PLACEHOLDER"
0x0003abb0  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0003abb4  mov      x29, x29
0x0003abb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003abbc  mov      x20, x0
0x0003abc0  bl       #0x17e20   ; CALL _L
0x0003abc4  mov      x29, x29
0x0003abc8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003abcc  mov      x21, x0
0x0003abd0  mov      x0, x19
0x0003abd4  mov      x2, x21
0x0003abd8  bl       #0x5bbc0   ; CALL objc_msgSend$setPlaceholder:
0x0003abdc  mov      x0, x21
0x0003abe0  bl       #0x55d78   ; CALL _objc_release
0x0003abe4  mov      x0, x20
0x0003abe8  bl       #0x55d78   ; CALL _objc_release
0x0003abec  mov      x0, x19
0x0003abf0  mov      w2, #2
0x0003abf4  bl       #0x5c4e0   ; CALL objc_msgSend$setTextAlignment:
0x0003abf8  mov      x0, x19
0x0003abfc  mov      x2, #0
0x0003ac00  bl       #0x5a720   ; CALL objc_msgSend$setBorderStyle:
0x0003ac04  adrp     x8, #0x8e000
0x0003ac08  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0003ac0c  adrp     x8, #0x65000
0x0003ac10  ldr      d1, [x8, #0x5f0]
0x0003ac14  fmov     d0, #0.50000000
0x0003ac18  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0003ac1c  mov      x29, x29
0x0003ac20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ac24  mov      x20, x0
0x0003ac28  mov      x0, x19
0x0003ac2c  mov      x2, x20
0x0003ac30  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0003ac34  mov      x0, x20
0x0003ac38  bl       #0x55d78   ; CALL _objc_release
0x0003ac3c  mov      x0, x19
0x0003ac40  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003ac44  mov      x29, x29
0x0003ac48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ac4c  mov      x20, x0
0x0003ac50  fmov     d0, #9.00000000
0x0003ac54  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0003ac58  mov      x0, x20
0x0003ac5c  bl       #0x55d78   ; CALL _objc_release
0x0003ac60  adrp     x21, #0x8e000
0x0003ac64  ldr      x0, [x21, #0x918]   ; @CLASS UIView
0x0003ac68  bl       #0x55c7c   ; CALL _objc_alloc
0x0003ac6c  fmov     d0, xzr
0x0003ac70  fmov     d1, xzr
0x0003ac74  fmov     d2, #8.00000000
0x0003ac78  fmov     d3, #8.00000000
0x0003ac7c  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0003ac80  mov      x20, x0
0x0003ac84  mov      x0, x19
0x0003ac88  mov      x2, x20
0x0003ac8c  bl       #0x5b2a0   ; CALL objc_msgSend$setLeftView:
0x0003ac90  mov      x0, x20
0x0003ac94  bl       #0x55d78   ; CALL _objc_release
0x0003ac98  mov      x0, x19
0x0003ac9c  mov      w2, #3
0x0003aca0  bl       #0x5b2c0   ; CALL objc_msgSend$setLeftViewMode:
0x0003aca4  ldr      x0, [x21, #0x918]   ; @CLASS UIView
0x0003aca8  bl       #0x55c7c   ; CALL _objc_alloc
0x0003acac  fmov     d0, xzr
0x0003acb0  fmov     d1, xzr
0x0003acb4  fmov     d2, #8.00000000
0x0003acb8  fmov     d3, #8.00000000
0x0003acbc  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0003acc0  mov      x20, x0
0x0003acc4  mov      x0, x19
0x0003acc8  mov      x2, x20
0x0003accc  bl       #0x5be40   ; CALL objc_msgSend$setRightView:
0x0003acd0  mov      x0, x20
0x0003acd4  bl       #0x55d78   ; CALL _objc_release
0x0003acd8  mov      x0, x19
0x0003acdc  mov      w2, #3
0x0003ace0  bl       #0x5be60   ; CALL objc_msgSend$setRightViewMode:
0x0003ace4  mov      x0, x19
0x0003ace8  mov      w2, #9
0x0003acec  bl       #0x5bde0   ; CALL objc_msgSend$setReturnKeyType:
0x0003acf0  mov      x0, x19
0x0003acf4  mov      x2, x22
0x0003acf8  bl       #0x5aca0   ; CALL objc_msgSend$setDelegate:
0x0003acfc  mov      x0, x19
0x0003ad00  mov      x2, x23
0x0003ad04  bl       #0x5c480   ; CALL objc_msgSend$setTag:
0x0003ad08  adrp     x8, #0x8b000
0x0003ad0c  ldr      x3, [x8, #0xef0]   ; @SEL "nameEdited:"
0x0003ad10  mov      x0, x19
0x0003ad14  mov      x2, x22
0x0003ad18  mov      w4, #0x20000
0x0003ad1c  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x0003ad20  mov      x0, x26
0x0003ad24  mov      x2, x19
0x0003ad28  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0003ad2c  mov      x0, x19
0x0003ad30  bl       #0x55d78   ; CALL _objc_release
0x0003ad34  b        #0x3b480
0x0003ad38  adrp     x8, #0x8e000
0x0003ad3c  ldr      x0, [x8, #0x930]   ; @CLASS UISegmentedControl
0x0003ad40  bl       #0x55c7c   ; CALL _objc_alloc
0x0003ad44  mov      x20, x0
0x0003ad48  adrp     x0, #0x7c000
0x0003ad4c  add      x0, x0, #0xe8   ; STR "SPLITSCREEN_LAYOUT_2"
0x0003ad50  bl       #0x17e20   ; CALL _L
0x0003ad54  mov      x29, x29
0x0003ad58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ad5c  mov      x19, x0
0x0003ad60  str      x0, [sp, #0xd0]
0x0003ad64  adrp     x0, #0x7c000
0x0003ad68  add      x0, x0, #0x108   ; STR "SPLITSCREEN_LAYOUT_3"
0x0003ad6c  bl       #0x17e20   ; CALL _L
0x0003ad70  mov      x29, x29
0x0003ad74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ad78  mov      x21, x0
0x0003ad7c  str      x0, [sp, #0xd8]
0x0003ad80  adrp     x0, #0x7c000
0x0003ad84  add      x0, x0, #0x128   ; STR "SPLITSCREEN_LAYOUT_13"
0x0003ad88  bl       #0x17e20   ; CALL _L
0x0003ad8c  mov      x29, x29
0x0003ad90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ad94  mov      x22, x0
0x0003ad98  str      x0, [sp, #0xe0]
0x0003ad9c  adrp     x0, #0x7c000
0x0003ada0  add      x0, x0, #0x148   ; STR "SPLITSCREEN_LAYOUT_31"
0x0003ada4  bl       #0x17e20   ; CALL _L
0x0003ada8  mov      x29, x29
0x0003adac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003adb0  mov      x23, x0
0x0003adb4  str      x0, [sp, #0xe8]
0x0003adb8  adrp     x8, #0x8e000
0x0003adbc  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0003adc0  add      x2, sp, #0xd0
0x0003adc4  mov      w3, #4
0x0003adc8  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0003adcc  mov      x29, x29
0x0003add0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003add4  mov      x24, x0
0x0003add8  mov      x0, x20
0x0003addc  mov      x2, x24
0x0003ade0  bl       #0x58500   ; CALL objc_msgSend$initWithItems:
0x0003ade4  mov      x27, x0
0x0003ade8  mov      x0, x24
0x0003adec  bl       #0x55d78   ; CALL _objc_release
0x0003adf0  mov      x0, x23
0x0003adf4  bl       #0x55d78   ; CALL _objc_release
0x0003adf8  mov      x0, x22
0x0003adfc  bl       #0x55d78   ; CALL _objc_release
0x0003ae00  mov      x0, x21
0x0003ae04  bl       #0x55d78   ; CALL _objc_release
0x0003ae08  mov      x0, x19
0x0003ae0c  bl       #0x55d78   ; CALL _objc_release
0x0003ae10  adrp     x8, #0x8e000
0x0003ae14  ldr      x19, [x8, #0x928]   ; @CLASS NSNumber
0x0003ae18  ldp      x21, x20, [sp, #0x40]
0x0003ae1c  mov      x0, x20
0x0003ae20  mov      x2, x21
0x0003ae24  bl       #0x58b40   ; CALL objc_msgSend$layoutOf:
0x0003ae28  mov      x2, x0
0x0003ae2c  mov      x0, x19
0x0003ae30  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x0003ae34  mov      x29, x29
0x0003ae38  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ae3c  mov      x19, x0
0x0003ae40  adrp     x0, #0x7f000
0x0003ae44  add      x0, x0, #0xc18
0x0003ae48  mov      x2, x19
0x0003ae4c  bl       #0x582c0   ; CALL objc_msgSend$indexOfObject:
0x0003ae50  mov      x2, x0
0x0003ae54  mov      x0, x27
0x0003ae58  bl       #0x5bf60   ; CALL objc_msgSend$setSelectedSegmentIndex:
0x0003ae5c  mov      x0, x19
0x0003ae60  bl       #0x55d78   ; CALL _objc_release
0x0003ae64  fmov     d0, #-24.00000000
0x0003ae68  fadd     d2, d8, d0
0x0003ae6c  mov      x8, #0x4040000000000000
0x0003ae70  fmov     d3, x8
0x0003ae74  fmov     d0, #12.00000000
0x0003ae78  fmov     d1, #8.00000000
0x0003ae7c  mov      x0, x27
0x0003ae80  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0003ae84  mov      x0, x27
0x0003ae88  mov      x2, x21
0x0003ae8c  bl       #0x5c480   ; CALL objc_msgSend$setTag:
0x0003ae90  adrp     x8, #0x8b000
0x0003ae94  ldr      x3, [x8, #0xef8]   ; @SEL "layoutPicked:"
0x0003ae98  mov      x0, x27
0x0003ae9c  mov      x2, x20
0x0003aea0  mov      w4, #0x1000
0x0003aea4  b        #0x3b470
0x0003aea8  str      x25, [sp, #0x20]
0x0003aeac  adrp     x8, #0x8e000
0x0003aeb0  ldr      x0, [x8, #0x940]   ; @CLASS UILabel
0x0003aeb4  bl       #0x55c7c   ; CALL _objc_alloc
0x0003aeb8  adrp     x8, #0x65000
0x0003aebc  ldr      d2, [x8, #0xb90]
0x0003aec0  mov      x8, #0x4047000000000000
0x0003aec4  fmov     d3, x8
0x0003aec8  fmov     d9, #6.00000000
0x0003aecc  fmov     d0, #16.00000000
0x0003aed0  fmov     d1, #6.00000000
0x0003aed4  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0003aed8  mov      x27, x0
0x0003aedc  mov      w2, #2
0x0003aee0  bl       #0x5b820   ; CALL objc_msgSend$setNumberOfLines:
0x0003aee4  adrp     x8, #0x8e000
0x0003aee8  ldr      x0, [x8, #0xc28]   ; @CLASS NSMutableAttributedString
0x0003aeec  bl       #0x55c7c   ; CALL _objc_alloc
0x0003aef0  mov      x19, x0
0x0003aef4  adrp     x0, #0x7c000
0x0003aef8  add      x0, x0, #0x168   ; STR "SPLITSCREEN_APPS_GROUP"
0x0003aefc  bl       #0x17e20   ; CALL _L
0x0003af00  mov      x29, x29
0x0003af04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003af08  mov      x20, x0
0x0003af0c  adrp     x8, #0x74000
0x0003af10  ldr      x8, [x8, #0x1d8]   ; @GOT _NSFontAttributeName
0x0003af14  ldr      x23, [x8]   ; @GOT ___objc_personality_v0
0x0003af18  str      x23, [sp, #0xc0]
0x0003af1c  adrp     x25, #0x8e000
0x0003af20  ldr      x0, [x25, #0x948]   ; @CLASS UIFont
0x0003af24  fmov     d0, #15.00000000
0x0003af28  bl       #0x5d7c0   ; CALL objc_msgSend$systemFontOfSize:
0x0003af2c  mov      x29, x29
0x0003af30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003af34  mov      x21, x0
0x0003af38  str      x0, [sp, #0xc8]
0x0003af3c  adrp     x24, #0x8e000
0x0003af40  ldr      x0, [x24, #0x970]   ; @CLASS NSDictionary
0x0003af44  add      x2, sp, #0xc8
0x0003af48  add      x3, sp, #0xc0
0x0003af4c  mov      w4, #1
0x0003af50  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0003af54  mov      x29, x29
0x0003af58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003af5c  mov      x22, x0
0x0003af60  mov      x0, x19
0x0003af64  mov      x2, x20
0x0003af68  mov      x3, x22
0x0003af6c  bl       #0x58580   ; CALL objc_msgSend$initWithString:attributes:
0x0003af70  mov      x28, x0
0x0003af74  mov      x0, x22
0x0003af78  bl       #0x55d78   ; CALL _objc_release
0x0003af7c  mov      x0, x21
0x0003af80  bl       #0x55d78   ; CALL _objc_release
0x0003af84  mov      x0, x20
0x0003af88  bl       #0x55d78   ; CALL _objc_release
0x0003af8c  adrp     x8, #0x8e000
0x0003af90  ldr      x0, [x8, #0xa68]   ; @CLASS NSAttributedString
0x0003af94  bl       #0x55c7c   ; CALL _objc_alloc
0x0003af98  mov      x21, x0
0x0003af9c  adrp     x0, #0x7c000
0x0003afa0  add      x0, x0, #0x188   ; STR "SPLITSCREEN_FAV_APPS_HINT"
0x0003afa4  bl       #0x17e20   ; CALL _L
0x0003afa8  mov      x29, x29
0x0003afac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003afb0  mov      x19, x0
0x0003afb4  adrp     x0, #0x75000
0x0003afb8  add      x0, x0, #0xbe8   ; STR "\n"
0x0003afbc  mov      x2, x19
0x0003afc0  bl       #0x5d440   ; CALL objc_msgSend$stringByAppendingString:
0x0003afc4  mov      x29, x29
0x0003afc8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003afcc  mov      x20, x0
0x0003afd0  str      x23, [sp, #0xa0]
0x0003afd4  ldr      x0, [x25, #0x948]   ; @CLASS UIFont
0x0003afd8  fmov     d0, #11.00000000
0x0003afdc  bl       #0x5d7c0   ; CALL objc_msgSend$systemFontOfSize:
0x0003afe0  mov      x29, x29
0x0003afe4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003afe8  mov      x22, x0
0x0003afec  str      x0, [sp, #0xb0]
0x0003aff0  adrp     x8, #0x74000
0x0003aff4  ldr      x8, [x8, #0x1e0]   ; @GOT _NSForegroundColorAttributeName
0x0003aff8  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003affc  str      x8, [sp, #0xa8]
0x0003b000  adrp     x8, #0x8e000
0x0003b004  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0003b008  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x0003b00c  mov      x29, x29
0x0003b010  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b014  mov      x23, x0
0x0003b018  str      x0, [sp, #0xb8]
0x0003b01c  ldr      x0, [x24, #0x970]   ; @CLASS NSDictionary
0x0003b020  add      x2, sp, #0xb0
0x0003b024  add      x3, sp, #0xa0
0x0003b028  mov      w4, #2
0x0003b02c  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0003b030  mov      x29, x29
0x0003b034  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b038  mov      x24, x0
0x0003b03c  mov      x0, x21
0x0003b040  mov      x2, x20
0x0003b044  mov      x3, x24
0x0003b048  bl       #0x58580   ; CALL objc_msgSend$initWithString:attributes:
0x0003b04c  mov      x21, x0
0x0003b050  mov      x0, x28
0x0003b054  mov      x2, x21
0x0003b058  bl       #0x56420   ; CALL objc_msgSend$appendAttributedString:
0x0003b05c  mov      x0, x21
0x0003b060  bl       #0x55d78   ; CALL _objc_release
0x0003b064  mov      x0, x24
0x0003b068  bl       #0x55d78   ; CALL _objc_release
0x0003b06c  mov      x0, x23
0x0003b070  bl       #0x55d78   ; CALL _objc_release
0x0003b074  mov      x0, x22
0x0003b078  bl       #0x55d78   ; CALL _objc_release
0x0003b07c  mov      x0, x20
0x0003b080  bl       #0x55d78   ; CALL _objc_release
0x0003b084  mov      x0, x19
0x0003b088  bl       #0x55d78   ; CALL _objc_release
0x0003b08c  mov      x0, x27
0x0003b090  str      x28, [sp, #0x10]
0x0003b094  mov      x2, x28
0x0003b098  bl       #0x5a4c0   ; CALL objc_msgSend$setAttributedText:
0x0003b09c  mov      x0, x26
0x0003b0a0  str      x27, [sp, #0x18]
0x0003b0a4  mov      x2, x27
0x0003b0a8  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0003b0ac  ldp      x20, x19, [sp, #0x40]
0x0003b0b0  mov      x0, x19
0x0003b0b4  mov      x2, x20
0x0003b0b8  bl       #0x58b40   ; CALL objc_msgSend$layoutOf:
0x0003b0bc  mov      x2, x0
0x0003b0c0  mov      x0, x19
0x0003b0c4  bl       #0x56a60   ; CALL objc_msgSend$boxCount:
0x0003b0c8  mov      x21, x0
0x0003b0cc  mov      x0, x19
0x0003b0d0  mov      x2, x20
0x0003b0d4  bl       #0x56580   ; CALL objc_msgSend$appsOf:
0x0003b0d8  mov      x29, x29
0x0003b0dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b0e0  stp      x21, x0, [sp, #0x30]
0x0003b0e4  cmp      x21, #1
0x0003b0e8  b.lt     #0x3b374
0x0003b0ec  mov      x28, #0
0x0003b0f0  mov      x27, #0
0x0003b0f4  fmov     d0, #-14.00000000
0x0003b0f8  fadd     d0, d8, d0
0x0003b0fc  ldr      x8, [sp, #0x30]
0x0003b100  add      x8, x8, x8, lsl #2
0x0003b104  lsl      x8, x8, #3
0x0003b108  scvtf    d1, x8
0x0003b10c  fsub     d0, d0, d1
0x0003b110  fadd     d10, d0, d9
0x0003b114  adrp     x8, #0x8b000
0x0003b118  ldr      x8, [x8, #0xf00]   ; @SEL "boxTapped:"
0x0003b11c  str      x8, [sp, #0x28]
0x0003b120  mov      x8, #0x4041000000000000
0x0003b124  fmov     d8, x8
0x0003b128  adrp     x8, #0x65000
0x0003b12c  ldr      d9, [x8, #0x728]
0x0003b130  mov      x25, x26
0x0003b134  adrp     x8, #0x8e000
0x0003b138  ldr      x0, [x8, #0xa50]   ; @CLASS UIButton
0x0003b13c  mov      x2, #0
0x0003b140  bl       #0x56b80   ; CALL objc_msgSend$buttonWithType:
0x0003b144  mov      x29, x29
0x0003b148  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b14c  mov      x20, x0
0x0003b150  ucvtf    d0, x28
0x0003b154  fadd     d0, d10, d0
0x0003b158  fmov     d1, #12.00000000
0x0003b15c  mov      v2.16b, v8.16b
0x0003b160  mov      v3.16b, v8.16b
0x0003b164  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0003b168  ldr      x0, [sp, #0x38]
0x0003b16c  mov      x2, x27
0x0003b170  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0003b174  mov      x29, x29
0x0003b178  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b17c  mov      x19, x0
0x0003b180  mov      v0.16b, v8.16b
0x0003b184  bl       #0x380a4
0x0003b188  mov      x29, x29
0x0003b18c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b190  mov      x21, x0
0x0003b194  mov      x0, x19
0x0003b198  bl       #0x55d78   ; CALL _objc_release
0x0003b19c  cbz      x21, #0x3b1b4
0x0003b1a0  mov      x0, x20
0x0003b1a4  mov      x2, x21
0x0003b1a8  mov      x3, #0
0x0003b1ac  bl       #0x5b0a0   ; CALL objc_msgSend$setImage:forState:
0x0003b1b0  b        #0x3b24c
0x0003b1b4  adrp     x22, #0x8e000
0x0003b1b8  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0003b1bc  fmov     d0, #0.50000000
0x0003b1c0  mov      v1.16b, v9.16b
0x0003b1c4  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0003b1c8  mov      x29, x29
0x0003b1cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b1d0  mov      x19, x0
0x0003b1d4  mov      x0, x20
0x0003b1d8  mov      x2, x19
0x0003b1dc  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0003b1e0  mov      x0, x19
0x0003b1e4  bl       #0x55d78   ; CALL _objc_release
0x0003b1e8  mov      x0, x20
0x0003b1ec  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003b1f0  mov      x29, x29
0x0003b1f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b1f8  mov      x19, x0
0x0003b1fc  fmov     d0, #8.00000000
0x0003b200  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0003b204  mov      x0, x19
0x0003b208  bl       #0x55d78   ; CALL _objc_release
0x0003b20c  mov      x0, x20
0x0003b210  adrp     x2, #0x7c000
0x0003b214  add      x2, x2, #0x1a8   ; STR "+"
0x0003b218  mov      x3, #0
0x0003b21c  bl       #0x5c600   ; CALL objc_msgSend$setTitle:forState:
0x0003b220  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0003b224  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x0003b228  mov      x29, x29
0x0003b22c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b230  mov      x19, x0
0x0003b234  mov      x0, x20
0x0003b238  mov      x2, x19
0x0003b23c  mov      x3, #0
0x0003b240  bl       #0x5c620   ; CALL objc_msgSend$setTitleColor:forState:
0x0003b244  mov      x0, x19
0x0003b248  bl       #0x55d78   ; CALL _objc_release
0x0003b24c  adrp     x22, #0x8e000
0x0003b250  ldr      x24, [x22, #0x958]   ; @CLASS NSString
0x0003b254  adrp     x0, #0x7f000
0x0003b258  add      x0, x0, #0xc30
0x0003b25c  mov      x2, x27
0x0003b260  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0003b264  mov      x29, x29
0x0003b268  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b26c  mov      x19, x0
0x0003b270  ldr      x8, [sp, #0x40]
0x0003b274  stp      x8, x0, [sp]
0x0003b278  mov      x0, x24
0x0003b27c  adrp     x2, #0x7b000
0x0003b280  add      x2, x2, #0xb28   ; STR "splitScreenFav%ld%@"
0x0003b284  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0003b288  mov      x29, x29
0x0003b28c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b290  mov      x24, x0
0x0003b294  str      x0, [sp, #0x90]
0x0003b298  ldr      x0, [x22, #0x958]   ; @CLASS NSString
0x0003b29c  add      x27, x27, #1
0x0003b2a0  str      x27, [sp]
0x0003b2a4  adrp     x2, #0x7c000
0x0003b2a8  add      x2, x2, #0x1c8   ; STR "SPLITSCREEN_BOX_%ld"
0x0003b2ac  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0003b2b0  mov      x29, x29
0x0003b2b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b2b8  mov      x23, x0
0x0003b2bc  bl       #0x17e20   ; CALL _L
0x0003b2c0  mov      x29, x29
0x0003b2c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b2c8  mov      x22, x0
0x0003b2cc  str      x0, [sp, #0x98]
0x0003b2d0  adrp     x8, #0x8e000
0x0003b2d4  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0003b2d8  add      x2, sp, #0x90
0x0003b2dc  mov      w3, #2
0x0003b2e0  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0003b2e4  mov      x29, x29
0x0003b2e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b2ec  mov      x26, x0
0x0003b2f0  mov      x0, x20
0x0003b2f4  adrp     x1, #0x90000
0x0003b2f8  add      x1, x1, #0xc0
0x0003b2fc  mov      x2, x26
0x0003b300  mov      w3, #1
0x0003b304  bl       #0x55db4   ; CALL _objc_setAssociatedObject
0x0003b308  mov      x0, x26
0x0003b30c  bl       #0x55d78   ; CALL _objc_release
0x0003b310  mov      x0, x22
0x0003b314  bl       #0x55d78   ; CALL _objc_release
0x0003b318  mov      x0, x23
0x0003b31c  bl       #0x55d78   ; CALL _objc_release
0x0003b320  mov      x0, x24
0x0003b324  bl       #0x55d78   ; CALL _objc_release
0x0003b328  mov      x0, x19
0x0003b32c  bl       #0x55d78   ; CALL _objc_release
0x0003b330  mov      x0, x20
0x0003b334  ldr      x2, [sp, #0x48]
0x0003b338  ldr      x3, [sp, #0x28]
0x0003b33c  mov      w4, #0x40
0x0003b340  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x0003b344  mov      x26, x25
0x0003b348  mov      x0, x25
0x0003b34c  mov      x2, x20
0x0003b350  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0003b354  mov      x0, x21
0x0003b358  bl       #0x55d78   ; CALL _objc_release
0x0003b35c  mov      x0, x20
0x0003b360  bl       #0x55d78   ; CALL _objc_release
0x0003b364  add      x28, x28, #0x28
0x0003b368  ldr      x8, [sp, #0x30]
0x0003b36c  cmp      x8, x27
0x0003b370  b.ne     #0x3b134
0x0003b374  ldr      x0, [sp, #0x38]
0x0003b378  bl       #0x55d78   ; CALL _objc_release
0x0003b37c  ldr      x0, [sp, #0x10]
0x0003b380  bl       #0x55d78   ; CALL _objc_release
0x0003b384  ldp      x27, x25, [sp, #0x18]
0x0003b388  b        #0x3b480
0x0003b38c  adrp     x8, #0x8e000
0x0003b390  ldr      x0, [x8, #0xa50]   ; @CLASS UIButton
0x0003b394  mov      w2, #1
0x0003b398  bl       #0x56b80   ; CALL objc_msgSend$buttonWithType:
0x0003b39c  mov      x29, x29
0x0003b3a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b3a4  mov      x27, x0
0x0003b3a8  adrp     x0, #0x7c000
0x0003b3ac  add      x0, x0, #0x1e8   ; STR "SPLITSCREEN_FAV_DONE"
0x0003b3b0  bl       #0x17e20   ; CALL _L
0x0003b3b4  mov      x29, x29
0x0003b3b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b3bc  mov      x19, x0
0x0003b3c0  mov      x0, x27
0x0003b3c4  mov      x2, x19
0x0003b3c8  mov      x3, #0
0x0003b3cc  bl       #0x5c600   ; CALL objc_msgSend$setTitle:forState:
0x0003b3d0  mov      x0, x19
0x0003b3d4  bl       #0x55d78   ; CALL _objc_release
0x0003b3d8  adrp     x8, #0x8e000
0x0003b3dc  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x0003b3e0  adrp     x8, #0x74000
0x0003b3e4  ldr      x8, [x8, #0x260]   ; @GOT _UIFontWeightSemibold
0x0003b3e8  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x0003b3ec  fmov     d0, #15.00000000
0x0003b3f0  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x0003b3f4  mov      x29, x29
0x0003b3f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b3fc  mov      x19, x0
0x0003b400  mov      x0, x27
0x0003b404  bl       #0x5db80   ; CALL objc_msgSend$titleLabel
0x0003b408  mov      x29, x29
0x0003b40c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b410  mov      x20, x0
0x0003b414  mov      x2, x19
0x0003b418  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x0003b41c  mov      x0, x20
0x0003b420  bl       #0x55d78   ; CALL _objc_release
0x0003b424  mov      x0, x19
0x0003b428  bl       #0x55d78   ; CALL _objc_release
0x0003b42c  mov      x8, #-0x3fc0000000000000
0x0003b430  fmov     d0, x8
0x0003b434  fadd     d2, d8, d0
0x0003b438  mov      x8, #0x4044000000000000
0x0003b43c  fmov     d3, x8
0x0003b440  fmov     d0, #16.00000000
0x0003b444  fmov     d1, #4.00000000
0x0003b448  mov      x0, x27
0x0003b44c  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0003b450  mov      x0, x27
0x0003b454  mov      w2, #1
0x0003b458  bl       #0x5a9c0   ; CALL objc_msgSend$setContentHorizontalAlignment:
0x0003b45c  adrp     x8, #0x8b000
0x0003b460  ldr      x3, [x8, #0xf08]   ; @SEL "doneEditing"
0x0003b464  mov      x0, x27
0x0003b468  ldr      x2, [sp, #0x48]
0x0003b46c  mov      w4, #0x40
0x0003b470  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x0003b474  mov      x0, x26
0x0003b478  mov      x2, x27
0x0003b47c  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0003b480  mov      x0, x27
0x0003b484  bl       #0x55d78   ; CALL _objc_release
0x0003b488  mov      x0, x26
0x0003b48c  bl       #0x55d78   ; CALL _objc_release
0x0003b490  ldur     x8, [x29, #-0x80]
0x0003b494  adrp     x9, #0x74000
0x0003b498  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0003b49c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0003b4a0  cmp      x9, x8
0x0003b4a4  b.ne     #0x3b4d4
0x0003b4a8  mov      x0, x25
0x0003b4ac  add      sp, sp, #0x180
0x0003b4b0  ldp      x29, x30, [sp, #0x70]
0x0003b4b4  ldp      x20, x19, [sp, #0x60]
0x0003b4b8  ldp      x22, x21, [sp, #0x50]
0x0003b4bc  ldp      x24, x23, [sp, #0x40]
0x0003b4c0  ldp      x26, x25, [sp, #0x30]
0x0003b4c4  ldp      x28, x27, [sp, #0x20]
0x0003b4c8  ldp      d9, d8, [sp, #0x10]
0x0003b4cc  ldp      d11, d10, [sp], #0x80
0x0003b4d0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0003b4d4  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCSplitScreenController nameEdited:]  va=0x3b4d8 size=260 types=v24@0:8@16
0x0003b4d8  sub      sp, sp, #0x50
0x0003b4dc  stp      x24, x23, [sp, #0x10]
0x0003b4e0  stp      x22, x21, [sp, #0x20]
0x0003b4e4  stp      x20, x19, [sp, #0x30]
0x0003b4e8  stp      x29, x30, [sp, #0x40]
0x0003b4ec  add      x29, sp, #0x40
0x0003b4f0  mov      x20, x2
0x0003b4f4  mov      x19, x0
0x0003b4f8  mov      x0, x2
0x0003b4fc  bl       #0x55d84   ; CALL _objc_retain
0x0003b500  mov      x0, x20
0x0003b504  bl       #0x5d980   ; CALL objc_msgSend$text
0x0003b508  mov      x29, x29
0x0003b50c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b510  mov      x21, x0
0x0003b514  adrp     x8, #0x8e000
0x0003b518  ldr      x0, [x8, #0x9e0]   ; @CLASS NSCharacterSet
0x0003b51c  bl       #0x5e1a0   ; CALL objc_msgSend$whitespaceCharacterSet
0x0003b520  mov      x29, x29
0x0003b524  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b528  mov      x22, x0
0x0003b52c  mov      x0, x21
0x0003b530  mov      x2, x22
0x0003b534  bl       #0x5d4c0   ; CALL objc_msgSend$stringByTrimmingCharactersInSet:
0x0003b538  mov      x29, x29
0x0003b53c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b540  mov      x23, x0
0x0003b544  mov      x0, x22
0x0003b548  bl       #0x55d78   ; CALL _objc_release
0x0003b54c  mov      x0, x21
0x0003b550  bl       #0x55d78   ; CALL _objc_release
0x0003b554  mov      x0, x23
0x0003b558  bl       #0x58c20   ; CALL objc_msgSend$length
0x0003b55c  cmp      x0, #0
0x0003b560  csel     x21, xzr, x23, eq
0x0003b564  adrp     x8, #0x8e000
0x0003b568  ldr      x22, [x8, #0x958]   ; @CLASS NSString
0x0003b56c  mov      x0, x20
0x0003b570  bl       #0x5d920   ; CALL objc_msgSend$tag
0x0003b574  mov      x24, x0
0x0003b578  mov      x0, x20
0x0003b57c  bl       #0x55d78   ; CALL _objc_release
0x0003b580  adrp     x8, #0x77000
0x0003b584  add      x8, x8, #0x108   ; STR "Name"
0x0003b588  stp      x24, x8, [sp]
0x0003b58c  adrp     x2, #0x7b000
0x0003b590  add      x2, x2, #0xb28   ; STR "splitScreenFav%ld%@"
0x0003b594  mov      x0, x22
0x0003b598  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0003b59c  mov      x29, x29
0x0003b5a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b5a4  mov      x20, x0
0x0003b5a8  mov      x0, x19
0x0003b5ac  mov      x2, x21
0x0003b5b0  mov      x3, x20
0x0003b5b4  bl       #0x5d3c0   ; CALL objc_msgSend$storeValue:forKey:
0x0003b5b8  mov      x0, x20
0x0003b5bc  bl       #0x55d78   ; CALL _objc_release
0x0003b5c0  mov      x0, x23
0x0003b5c4  ldp      x29, x30, [sp, #0x40]
0x0003b5c8  ldp      x20, x19, [sp, #0x30]
0x0003b5cc  ldp      x22, x21, [sp, #0x20]
0x0003b5d0  ldp      x24, x23, [sp, #0x10]
0x0003b5d4  add      sp, sp, #0x50
0x0003b5d8  b        #0x55d78   ; CALL _objc_release

=== -[OMCSplitScreenController textFieldShouldReturn:]  va=0x3b5dc size=52 types=B24@0:8@16
0x0003b5dc  stp      x20, x19, [sp, #-0x20]!
0x0003b5e0  stp      x29, x30, [sp, #0x10]
0x0003b5e4  add      x29, sp, #0x10
0x0003b5e8  mov      x19, x0
0x0003b5ec  mov      x0, x2
0x0003b5f0  bl       #0x59f00   ; CALL objc_msgSend$resignFirstResponder
0x0003b5f4  mov      x0, x19
0x0003b5f8  mov      w2, #3
0x0003b5fc  bl       #0x59ce0   ; CALL objc_msgSend$reloadSection:
0x0003b600  mov      w0, #1
0x0003b604  ldp      x29, x30, [sp, #0x10]
0x0003b608  ldp      x20, x19, [sp], #0x20
0x0003b60c  ret      

=== -[OMCSplitScreenController layoutPicked:]  va=0x3b610 size=208 types=v24@0:8@16
0x0003b610  sub      sp, sp, #0x50
0x0003b614  stp      x24, x23, [sp, #0x10]
0x0003b618  stp      x22, x21, [sp, #0x20]
0x0003b61c  stp      x20, x19, [sp, #0x30]
0x0003b620  stp      x29, x30, [sp, #0x40]
0x0003b624  add      x29, sp, #0x40
0x0003b628  mov      x19, x2
0x0003b62c  mov      x20, x0
0x0003b630  mov      x0, x2
0x0003b634  bl       #0x55d84   ; CALL _objc_retain
0x0003b638  mov      x0, x19
0x0003b63c  bl       #0x5a1c0   ; CALL objc_msgSend$selectedSegmentIndex
0x0003b640  mov      x2, x0
0x0003b644  adrp     x0, #0x7f000
0x0003b648  add      x0, x0, #0xc48
0x0003b64c  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0003b650  mov      x29, x29
0x0003b654  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b658  mov      x21, x0
0x0003b65c  adrp     x8, #0x8e000
0x0003b660  ldr      x22, [x8, #0x958]   ; @CLASS NSString
0x0003b664  mov      x0, x19
0x0003b668  bl       #0x5d920   ; CALL objc_msgSend$tag
0x0003b66c  mov      x23, x0
0x0003b670  mov      x0, x19
0x0003b674  bl       #0x55d78   ; CALL _objc_release
0x0003b678  adrp     x8, #0x7b000
0x0003b67c  add      x8, x8, #0xb48   ; STR "Layout"
0x0003b680  stp      x23, x8, [sp]
0x0003b684  adrp     x2, #0x7b000
0x0003b688  add      x2, x2, #0xb28   ; STR "splitScreenFav%ld%@"
0x0003b68c  mov      x0, x22
0x0003b690  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0003b694  mov      x29, x29
0x0003b698  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b69c  mov      x19, x0
0x0003b6a0  mov      x0, x20
0x0003b6a4  mov      x2, x21
0x0003b6a8  mov      x3, x19
0x0003b6ac  bl       #0x5d3c0   ; CALL objc_msgSend$storeValue:forKey:
0x0003b6b0  mov      x0, x19
0x0003b6b4  bl       #0x55d78   ; CALL _objc_release
0x0003b6b8  mov      x0, x21
0x0003b6bc  bl       #0x55d78   ; CALL _objc_release
0x0003b6c0  mov      x0, x20
0x0003b6c4  mov      w2, #3
0x0003b6c8  ldp      x29, x30, [sp, #0x40]
0x0003b6cc  ldp      x20, x19, [sp, #0x30]
0x0003b6d0  ldp      x22, x21, [sp, #0x20]
0x0003b6d4  ldp      x24, x23, [sp, #0x10]
0x0003b6d8  add      sp, sp, #0x50
0x0003b6dc  b        #0x59ce0   ; CALL objc_msgSend$reloadSection:

=== -[OMCSplitScreenController pickAppForKey:title:]  va=0x3b6e0 size=252 types=v32@0:8@16@24
0x0003b6e0  sub      sp, sp, #0x50
0x0003b6e4  stp      x24, x23, [sp, #0x10]
0x0003b6e8  stp      x22, x21, [sp, #0x20]
0x0003b6ec  stp      x20, x19, [sp, #0x30]
0x0003b6f0  stp      x29, x30, [sp, #0x40]
0x0003b6f4  add      x29, sp, #0x40
0x0003b6f8  mov      x20, x3
0x0003b6fc  mov      x19, x2
0x0003b700  mov      x21, x0
0x0003b704  mov      x0, x2
0x0003b708  bl       #0x55d84   ; CALL _objc_retain
0x0003b70c  mov      x0, x20
0x0003b710  bl       #0x55d84   ; CALL _objc_retain
0x0003b714  adrp     x0, #0x7c000
0x0003b718  add      x0, x0, #0x208   ; STR "OMCSplitScreenAppPickerController"
0x0003b71c  bl       #0x55af0   ; CALL _NSClassFromString
0x0003b720  cbz      x0, #0x3b7b8
0x0003b724  mov      x22, x0
0x0003b728  adrp     x8, #0x8e000
0x0003b72c  ldr      x0, [x8, #0xa98]   ; @CLASS PSSpecifier
0x0003b730  str      xzr, [sp]
0x0003b734  mov      x2, x20
0x0003b738  mov      x3, x21
0x0003b73c  mov      x4, #0
0x0003b740  mov      x5, #0
0x0003b744  mov      x6, x22
0x0003b748  mov      w7, #1
0x0003b74c  bl       #0x598e0   ; CALL objc_msgSend$preferenceSpecifierNamed:target:set:get:detail:cell:edit:
0x0003b750  mov      x29, x29
0x0003b754  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b758  mov      x23, x0
0x0003b75c  adrp     x3, #0x76000
0x0003b760  add      x3, x3, #0xfc8   ; STR "key"
0x0003b764  mov      x2, x19
0x0003b768  bl       #0x5bd60   ; CALL objc_msgSend$setProperty:forKey:
0x0003b76c  mov      x0, x22
0x0003b770  bl       #0x55c88   ; CALL _objc_alloc_init
0x0003b774  mov      x22, x0
0x0003b778  mov      x2, x23
0x0003b77c  bl       #0x5c260   ; CALL objc_msgSend$setSpecifier:
0x0003b780  mov      x0, x21
0x0003b784  bl       #0x59180   ; CALL objc_msgSend$navigationController
0x0003b788  mov      x29, x29
0x0003b78c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b790  mov      x21, x0
0x0003b794  mov      x2, x22
0x0003b798  mov      w3, #1
0x0003b79c  bl       #0x59ae0   ; CALL objc_msgSend$pushViewController:animated:
0x0003b7a0  mov      x0, x21
0x0003b7a4  bl       #0x55d78   ; CALL _objc_release
0x0003b7a8  mov      x0, x22
0x0003b7ac  bl       #0x55d78   ; CALL _objc_release
0x0003b7b0  mov      x0, x23
0x0003b7b4  bl       #0x55d78   ; CALL _objc_release
0x0003b7b8  mov      x0, x20
0x0003b7bc  bl       #0x55d78   ; CALL _objc_release
0x0003b7c0  mov      x0, x19
0x0003b7c4  ldp      x29, x30, [sp, #0x40]
0x0003b7c8  ldp      x20, x19, [sp, #0x30]
0x0003b7cc  ldp      x22, x21, [sp, #0x20]
0x0003b7d0  ldp      x24, x23, [sp, #0x10]
0x0003b7d4  add      sp, sp, #0x50
0x0003b7d8  b        #0x55d78   ; CALL _objc_release

=== -[OMCSplitScreenController boxTapped:]  va=0x3b7dc size=144 types=v24@0:8@16
0x0003b7dc  stp      x22, x21, [sp, #-0x30]!
0x0003b7e0  stp      x20, x19, [sp, #0x10]
0x0003b7e4  stp      x29, x30, [sp, #0x20]
0x0003b7e8  add      x29, sp, #0x20
0x0003b7ec  mov      x19, x0
0x0003b7f0  adrp     x1, #0x90000
0x0003b7f4  add      x1, x1, #0xc0
0x0003b7f8  mov      x0, x2
0x0003b7fc  bl       #0x55d00   ; CALL _objc_getAssociatedObject
0x0003b800  mov      x29, x29
0x0003b804  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b808  mov      x20, x0
0x0003b80c  mov      x2, #0
0x0003b810  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0003b814  mov      x29, x29
0x0003b818  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b81c  mov      x21, x0
0x0003b820  mov      x0, x20
0x0003b824  mov      w2, #1
0x0003b828  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0003b82c  mov      x29, x29
0x0003b830  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b834  mov      x22, x0
0x0003b838  mov      x0, x19
0x0003b83c  mov      x2, x21
0x0003b840  mov      x3, x22
0x0003b844  bl       #0x596c0   ; CALL objc_msgSend$pickAppForKey:title:
0x0003b848  mov      x0, x22
0x0003b84c  bl       #0x55d78   ; CALL _objc_release
0x0003b850  mov      x0, x21
0x0003b854  bl       #0x55d78   ; CALL _objc_release
0x0003b858  mov      x0, x20
0x0003b85c  ldp      x29, x30, [sp, #0x20]
0x0003b860  ldp      x20, x19, [sp, #0x10]
0x0003b864  ldp      x22, x21, [sp], #0x30
0x0003b868  b        #0x55d78   ; CALL _objc_release

=== -[OMCSplitScreenController doneEditing]  va=0x3b86c size=80 types=v16@0:8
0x0003b86c  stp      x20, x19, [sp, #-0x20]!
0x0003b870  stp      x29, x30, [sp, #0x10]
0x0003b874  add      x29, sp, #0x10
0x0003b878  mov      x19, x0
0x0003b87c  bl       #0x5df60   ; CALL objc_msgSend$view
0x0003b880  mov      x29, x29
0x0003b884  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b888  mov      x20, x0
0x0003b88c  mov      w2, #1
0x0003b890  bl       #0x579a0   ; CALL objc_msgSend$endEditing:
0x0003b894  mov      x0, x20
0x0003b898  bl       #0x55d78   ; CALL _objc_release
0x0003b89c  mov      x0, x19
0x0003b8a0  mov      x2, #0
0x0003b8a4  bl       #0x5ad60   ; CALL objc_msgSend$setEditing:
0x0003b8a8  mov      x0, x19
0x0003b8ac  mov      w2, #3
0x0003b8b0  ldp      x29, x30, [sp, #0x10]
0x0003b8b4  ldp      x20, x19, [sp], #0x20
0x0003b8b8  b        #0x59ce0   ; CALL objc_msgSend$reloadSection:

=== -[OMCSplitScreenController copyURL:]  va=0x3b8bc size=184 types=v24@0:8@16
0x0003b8bc  stp      x22, x21, [sp, #-0x30]!
0x0003b8c0  stp      x20, x19, [sp, #0x10]
0x0003b8c4  stp      x29, x30, [sp, #0x20]
0x0003b8c8  add      x29, sp, #0x20
0x0003b8cc  mov      x19, x0
0x0003b8d0  adrp     x1, #0x90000
0x0003b8d4  add      x1, x1, #0xc0
0x0003b8d8  mov      x0, x2
0x0003b8dc  bl       #0x55d00   ; CALL _objc_getAssociatedObject
0x0003b8e0  mov      x29, x29
0x0003b8e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b8e8  mov      x20, x0
0x0003b8ec  adrp     x8, #0x8e000
0x0003b8f0  ldr      x0, [x8, #0xc30]   ; @CLASS UIPasteboard
0x0003b8f4  bl       #0x57de0   ; CALL objc_msgSend$generalPasteboard
0x0003b8f8  mov      x29, x29
0x0003b8fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b900  mov      x21, x0
0x0003b904  mov      x2, x20
0x0003b908  bl       #0x5c320   ; CALL objc_msgSend$setString:
0x0003b90c  mov      x0, x21
0x0003b910  bl       #0x55d78   ; CALL _objc_release
0x0003b914  mov      x0, x20
0x0003b918  bl       #0x55d78   ; CALL _objc_release
0x0003b91c  adrp     x8, #0x8e000
0x0003b920  ldr      x0, [x8, #0xc38]   ; @CLASS UINotificationFeedbackGenerator
0x0003b924  bl       #0x55d60   ; CALL _objc_opt_new
0x0003b928  mov      x20, x0
0x0003b92c  mov      x2, #0
0x0003b930  bl       #0x59200   ; CALL objc_msgSend$notificationOccurred:
0x0003b934  mov      x0, x20
0x0003b938  bl       #0x55d78   ; CALL _objc_release
0x0003b93c  adrp     x0, #0x7c000
0x0003b940  add      x0, x0, #0x228   ; STR "SPLITSCREEN_COPIED"
0x0003b944  bl       #0x17e20   ; CALL _L
0x0003b948  mov      x29, x29
0x0003b94c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b950  mov      x20, x0
0x0003b954  mov      x0, x19
0x0003b958  mov      x2, x20
0x0003b95c  bl       #0x5dba0   ; CALL objc_msgSend$toast:
0x0003b960  mov      x0, x20
0x0003b964  ldp      x29, x30, [sp, #0x20]
0x0003b968  ldp      x20, x19, [sp, #0x10]
0x0003b96c  ldp      x22, x21, [sp], #0x30
0x0003b970  b        #0x55d78   ; CALL _objc_release

=== -[OMCSplitScreenController tableView:didSelectRowAtIndexPath:]  va=0x3b974 size=396 types=v32@0:8@16@24
0x0003b974  sub      sp, sp, #0x40
0x0003b978  stp      x22, x21, [sp, #0x10]
0x0003b97c  stp      x20, x19, [sp, #0x20]
0x0003b980  stp      x29, x30, [sp, #0x30]
0x0003b984  add      x29, sp, #0x30
0x0003b988  mov      x19, x3
0x0003b98c  mov      x21, x2
0x0003b990  mov      x20, x0
0x0003b994  mov      x0, x3
0x0003b998  bl       #0x55d84   ; CALL _objc_retain
0x0003b99c  mov      x0, x21
0x0003b9a0  mov      x2, x19
0x0003b9a4  mov      w3, #1
0x0003b9a8  bl       #0x57740   ; CALL objc_msgSend$deselectRowAtIndexPath:animated:
0x0003b9ac  mov      x0, x19
0x0003b9b0  bl       #0x5a180   ; CALL objc_msgSend$section
0x0003b9b4  cmp      x0, #2
0x0003b9b8  b.ne     #0x3b9f4
0x0003b9bc  adrp     x0, #0x7b000
0x0003b9c0  add      x0, x0, #0xe68   ; STR "SPLITSCREEN_PINNED"
0x0003b9c4  bl       #0x17e20   ; CALL _L
0x0003b9c8  mov      x29, x29
0x0003b9cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003b9d0  mov      x21, x0
0x0003b9d4  adrp     x2, #0x7b000
0x0003b9d8  add      x2, x2, #0xd08   ; STR "splitScreenPinnedApp"
0x0003b9dc  mov      x0, x20
0x0003b9e0  mov      x3, x21
0x0003b9e4  bl       #0x596c0   ; CALL objc_msgSend$pickAppForKey:title:
0x0003b9e8  mov      x0, x21
0x0003b9ec  bl       #0x55d78   ; CALL _objc_release
0x0003b9f0  b        #0x3bae4
0x0003b9f4  mov      x0, x19
0x0003b9f8  bl       #0x5a180   ; CALL objc_msgSend$section
0x0003b9fc  cmp      x0, #3
0x0003ba00  b.ne     #0x3ba74
0x0003ba04  mov      x0, x19
0x0003ba08  bl       #0x59f60   ; CALL objc_msgSend$row
0x0003ba0c  mov      x2, x0
0x0003ba10  add      x3, sp, #8
0x0003ba14  mov      x4, sp
0x0003ba18  mov      x0, x20
0x0003ba1c  bl       #0x57b20   ; CALL objc_msgSend$favRow:fav:part:
0x0003ba20  ldr      x8, [sp]
0x0003ba24  tbz      x8, #0x3f, #0x3bae4
0x0003ba28  mov      x0, x20
0x0003ba2c  bl       #0x5df60   ; CALL objc_msgSend$view
0x0003ba30  mov      x29, x29
0x0003ba34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ba38  mov      x21, x0
0x0003ba3c  mov      w2, #1
0x0003ba40  bl       #0x579a0   ; CALL objc_msgSend$endEditing:
0x0003ba44  mov      x0, x21
0x0003ba48  bl       #0x55d78   ; CALL _objc_release
0x0003ba4c  mov      x0, x20
0x0003ba50  bl       #0x57940   ; CALL objc_msgSend$editing
0x0003ba54  ldr      x8, [sp, #8]
0x0003ba58  cmp      x0, x8
0x0003ba5c  csel     x2, xzr, x8, eq
0x0003ba60  mov      x0, x20
0x0003ba64  bl       #0x5ad60   ; CALL objc_msgSend$setEditing:
0x0003ba68  mov      x0, x20
0x0003ba6c  mov      w2, #3
0x0003ba70  b        #0x3bae0
0x0003ba74  mov      x0, x19
0x0003ba78  bl       #0x5a180   ; CALL objc_msgSend$section
0x0003ba7c  cmp      x0, #5
0x0003ba80  b.ne     #0x3bae4
0x0003ba84  str      xzr, [sp, #8]
0x0003ba88  mov      x0, x19
0x0003ba8c  bl       #0x59f60   ; CALL objc_msgSend$row
0x0003ba90  mov      x2, x0
0x0003ba94  add      x3, sp, #8
0x0003ba98  mov      x0, x20
0x0003ba9c  bl       #0x57f60   ; CALL objc_msgSend$helpKind:index:
0x0003baa0  cmp      x0, #2
0x0003baa4  b.eq     #0x3bac4
0x0003baa8  cbnz     x0, #0x3bae4
0x0003baac  mov      x0, x20
0x0003bab0  bl       #0x5c9e0   ; CALL objc_msgSend$showGestures
0x0003bab4  eor      w2, w0, #1
0x0003bab8  mov      x0, x20
0x0003babc  bl       #0x5c0c0   ; CALL objc_msgSend$setShowGestures:
0x0003bac0  b        #0x3bad8
0x0003bac4  mov      x0, x20
0x0003bac8  bl       #0x5caa0   ; CALL objc_msgSend$showSiri
0x0003bacc  eor      w2, w0, #1
0x0003bad0  mov      x0, x20
0x0003bad4  bl       #0x5c100   ; CALL objc_msgSend$setShowSiri:
0x0003bad8  mov      x0, x20
0x0003badc  mov      w2, #5
0x0003bae0  bl       #0x59ce0   ; CALL objc_msgSend$reloadSection:
0x0003bae4  mov      x0, x19
0x0003bae8  bl       #0x55d78   ; CALL _objc_release
0x0003baec  ldp      x29, x30, [sp, #0x30]
0x0003baf0  ldp      x20, x19, [sp, #0x20]
0x0003baf4  ldp      x22, x21, [sp, #0x10]
0x0003baf8  add      sp, sp, #0x40
0x0003bafc  ret      

=== -[OMCSplitScreenController preview]  va=0x3bb00 size=16 types=@16@0:8
0x0003bb00  adrp     x8, #0x8e000
0x0003bb04  ldrsw    x8, [x8, #0xf54]
0x0003bb08  ldr      x0, [x0, x8]
0x0003bb0c  ret      

=== -[OMCSplitScreenController setPreview:]  va=0x3bb10 size=64 types=v24@0:8@16
0x0003bb10  stp      x22, x21, [sp, #-0x30]!
0x0003bb14  stp      x20, x19, [sp, #0x10]
0x0003bb18  stp      x29, x30, [sp, #0x20]
0x0003bb1c  add      x29, sp, #0x20
0x0003bb20  mov      x19, x2
0x0003bb24  mov      x20, x0
0x0003bb28  adrp     x8, #0x8e000
0x0003bb2c  ldrsw    x21, [x8, #0xf54]
0x0003bb30  mov      x0, x2
0x0003bb34  bl       #0x55d84   ; CALL _objc_retain
0x0003bb38  ldr      x0, [x20, x21]
0x0003bb3c  str      x19, [x20, x21]
0x0003bb40  ldp      x29, x30, [sp, #0x20]
0x0003bb44  ldp      x20, x19, [sp, #0x10]
0x0003bb48  ldp      x22, x21, [sp], #0x30
0x0003bb4c  b        #0x55d78   ; CALL _objc_release

=== -[OMCSplitScreenController editing]  va=0x3bb50 size=16 types=q16@0:8
0x0003bb50  adrp     x8, #0x8e000
0x0003bb54  ldrsw    x8, [x8, #0xf58]
0x0003bb58  ldr      x0, [x0, x8]
0x0003bb5c  ret      

=== -[OMCSplitScreenController setEditing:]  va=0x3bb60 size=16 types=v24@0:8q16
0x0003bb60  adrp     x8, #0x8e000
0x0003bb64  ldrsw    x8, [x8, #0xf58]
0x0003bb68  str      x2, [x0, x8]
0x0003bb6c  ret      

=== -[OMCSplitScreenController showGestures]  va=0x3bb70 size=16 types=B16@0:8
0x0003bb70  adrp     x8, #0x8e000
0x0003bb74  ldrsw    x8, [x8, #0xf5c]
0x0003bb78  ldrb     w0, [x0, x8]
0x0003bb7c  ret      

=== -[OMCSplitScreenController setShowGestures:]  va=0x3bb80 size=16 types=v20@0:8B16
0x0003bb80  adrp     x8, #0x8e000
0x0003bb84  ldrsw    x8, [x8, #0xf5c]
0x0003bb88  strb     w2, [x0, x8]
0x0003bb8c  ret      

=== -[OMCSplitScreenController showSiri]  va=0x3bb90 size=16 types=B16@0:8
0x0003bb90  adrp     x8, #0x8e000
0x0003bb94  ldrsw    x8, [x8, #0xf60]
0x0003bb98  ldrb     w0, [x0, x8]
0x0003bb9c  ret      

=== -[OMCSplitScreenController setShowSiri:]  va=0x3bba0 size=16 types=v20@0:8B16
0x0003bba0  adrp     x8, #0x8e000
0x0003bba4  ldrsw    x8, [x8, #0xf60]
0x0003bba8  strb     w2, [x0, x8]
0x0003bbac  ret      

=== -[OMCSplitScreenController .cxx_destruct]  va=0x3bbb0 size=740 types=v16@0:8
0x0003bbb0  adrp     x8, #0x8e000
0x0003bbb4  ldrsw    x8, [x8, #0xf54]
0x0003bbb8  add      x0, x0, x8
0x0003bbbc  mov      x1, #0
0x0003bbc0  b        #0x55dcc   ; CALL _objc_storeStrong
0x0003bbc4  stp      x20, x19, [sp, #-0x20]!
0x0003bbc8  stp      x29, x30, [sp, #0x10]
0x0003bbcc  add      x29, sp, #0x10
0x0003bbd0  mov      x19, x0
0x0003bbd4  adrp     x8, #0x8e000
0x0003bbd8  ldr      x0, [x8, #0xac0]   ; @CLASS UIBezierPath
0x0003bbdc  ldr      d2, [x19, #0x28]
0x0003bbe0  adrp     x8, #0x65000
0x0003bbe4  ldr      d0, [x8, #0xe48]
0x0003bbe8  fmul     d4, d2, d0
0x0003bbec  fmov     d0, xzr
0x0003bbf0  fmov     d1, xzr
0x0003bbf4  mov      v3.16b, v2.16b
0x0003bbf8  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x0003bbfc  mov      x29, x29
0x0003bc00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003bc04  mov      x20, x0
0x0003bc08  bl       #0x560a0   ; CALL objc_msgSend$addClip
0x0003bc0c  mov      x0, x20
0x0003bc10  bl       #0x55d78   ; CALL _objc_release
0x0003bc14  ldr      x0, [x19, #0x20]
0x0003bc18  ldr      d2, [x19, #0x28]
0x0003bc1c  fmov     d0, xzr
0x0003bc20  fmov     d1, xzr
0x0003bc24  mov      v3.16b, v2.16b
0x0003bc28  ldp      x29, x30, [sp, #0x10]
0x0003bc2c  ldp      x20, x19, [sp], #0x20
0x0003bc30  b        #0x578e0   ; CALL objc_msgSend$drawInRect:
0x0003bc34  stp      d15, d14, [sp, #-0x80]!
0x0003bc38  stp      d13, d12, [sp, #0x10]
0x0003bc3c  stp      d11, d10, [sp, #0x20]
0x0003bc40  stp      d9, d8, [sp, #0x30]
0x0003bc44  stp      x24, x23, [sp, #0x40]
0x0003bc48  stp      x22, x21, [sp, #0x50]
0x0003bc4c  stp      x20, x19, [sp, #0x60]
0x0003bc50  stp      x29, x30, [sp, #0x70]
0x0003bc54  add      x29, sp, #0x70
0x0003bc58  mov      x19, x0
0x0003bc5c  adrp     x23, #0x8e000
0x0003bc60  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0003bc64  adrp     x8, #0x65000
0x0003bc68  ldr      d1, [x8, #0x5f0]
0x0003bc6c  fmov     d14, #0.50000000
0x0003bc70  fmov     d0, #0.50000000
0x0003bc74  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0003bc78  mov      x29, x29
0x0003bc7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003bc80  mov      x20, x0
0x0003bc84  bl       #0x5ae00   ; CALL objc_msgSend$setFill
0x0003bc88  mov      x0, x20
0x0003bc8c  bl       #0x55d78   ; CALL _objc_release
0x0003bc90  adrp     x24, #0x8e000
0x0003bc94  ldr      x0, [x24, #0xac0]   ; @CLASS UIBezierPath
0x0003bc98  ldp      d2, d3, [x19, #0x30]
0x0003bc9c  fmov     d0, xzr
0x0003bca0  fmov     d1, xzr
0x0003bca4  fmov     d4, #7.00000000
0x0003bca8  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x0003bcac  mov      x29, x29
0x0003bcb0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003bcb4  mov      x20, x0
0x0003bcb8  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0003bcbc  mov      x0, x20
0x0003bcc0  bl       #0x55d78   ; CALL _objc_release
0x0003bcc4  ldr      x0, [x19, #0x20]
0x0003bcc8  bl       #0x573c0   ; CALL objc_msgSend$count
0x0003bccc  cbz      x0, #0x3be70
0x0003bcd0  mov      x20, #0
0x0003bcd4  adrp     x8, #0x65000
0x0003bcd8  ldr      d8, [x8, #0xe50]
0x0003bcdc  fmov     d15, #16.00000000
0x0003bce0  ldr      x0, [x19, #0x20]
0x0003bce4  mov      x2, x20
0x0003bce8  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0003bcec  mov      x29, x29
0x0003bcf0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003bcf4  mov      x21, x0
0x0003bcf8  bl       #0x55f00   ; CALL objc_msgSend$CGRectValue
0x0003bcfc  fmov     d4, #2.00000000
0x0003bd00  fmov     d5, #2.00000000
0x0003bd04  bl       #0x55a9c   ; CALL _CGRectOffset
0x0003bd08  mov      v9.16b, v0.16b
0x0003bd0c  mov      v10.16b, v1.16b
0x0003bd10  mov      v11.16b, v2.16b
0x0003bd14  mov      v12.16b, v3.16b
0x0003bd18  mov      x0, x21
0x0003bd1c  bl       #0x55d78   ; CALL _objc_release
0x0003bd20  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0003bd24  fmov     d0, #0.50000000
0x0003bd28  mov      v1.16b, v8.16b
0x0003bd2c  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0003bd30  mov      x29, x29
0x0003bd34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003bd38  mov      x21, x0
0x0003bd3c  bl       #0x5ae00   ; CALL objc_msgSend$setFill
0x0003bd40  mov      x0, x21
0x0003bd44  bl       #0x55d78   ; CALL _objc_release
0x0003bd48  ldr      x0, [x24, #0xac0]   ; @CLASS UIBezierPath
0x0003bd4c  fmov     d4, #5.00000000
0x0003bd50  mov      v0.16b, v9.16b
0x0003bd54  mov      v1.16b, v10.16b
0x0003bd58  mov      v2.16b, v11.16b
0x0003bd5c  mov      v3.16b, v12.16b
0x0003bd60  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x0003bd64  mov      x29, x29
0x0003bd68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003bd6c  mov      x21, x0
0x0003bd70  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0003bd74  mov      x0, x21
0x0003bd78  bl       #0x55d78   ; CALL _objc_release
0x0003bd7c  ldr      x0, [x19, #0x28]
0x0003bd80  bl       #0x573c0   ; CALL objc_msgSend$count
0x0003bd84  cmp      x20, x0
0x0003bd88  b.hs     #0x3be5c
0x0003bd8c  ldr      x0, [x19, #0x28]
0x0003bd90  mov      x2, x20
0x0003bd94  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0003bd98  mov      x29, x29
0x0003bd9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003bda0  mov      x22, x0
0x0003bda4  fcmp     d11, d12
0x0003bda8  fcsel    d0, d11, d12, mi
0x0003bdac  fmov     d1, #-3.00000000
0x0003bdb0  fadd     d0, d0, d1
0x0003bdb4  fcmp     d0, d15
0x0003bdb8  fcsel    d0, d15, d0, gt
0x0003bdbc  bl       #0x380a4
0x0003bdc0  mov      x29, x29
0x0003bdc4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003bdc8  mov      x21, x0
0x0003bdcc  mov      x0, x22
0x0003bdd0  bl       #0x55d78   ; CALL _objc_release
0x0003bdd4  cbz      x21, #0x3be5c
0x0003bdd8  mov      v0.16b, v9.16b
0x0003bddc  mov      v1.16b, v10.16b
0x0003bde0  mov      v2.16b, v11.16b
0x0003bde4  mov      v3.16b, v12.16b
0x0003bde8  bl       #0x55a60   ; CALL _CGRectGetMidX
0x0003bdec  mov      v13.16b, v0.16b
0x0003bdf0  mov      x0, x21
0x0003bdf4  bl       #0x5cba0   ; CALL objc_msgSend$size
0x0003bdf8  fmul     d0, d0, d14
0x0003bdfc  fsub     d13, d13, d0
0x0003be00  mov      v0.16b, v9.16b
0x0003be04  mov      v1.16b, v10.16b
0x0003be08  mov      v2.16b, v11.16b
0x0003be0c  mov      v3.16b, v12.16b
0x0003be10  bl       #0x55a6c   ; CALL _CGRectGetMidY
0x0003be14  mov      v9.16b, v0.16b
0x0003be18  mov      x0, x21
0x0003be1c  bl       #0x5cba0   ; CALL objc_msgSend$size
0x0003be20  fmul     d0, d1, d14
0x0003be24  fsub     d9, d9, d0
0x0003be28  mov      x0, x21
0x0003be2c  bl       #0x5cba0   ; CALL objc_msgSend$size
0x0003be30  mov      v10.16b, v0.16b
0x0003be34  mov      x0, x21
0x0003be38  bl       #0x5cba0   ; CALL objc_msgSend$size
0x0003be3c  mov      v3.16b, v1.16b
0x0003be40  mov      x0, x21
0x0003be44  mov      v0.16b, v13.16b
0x0003be48  mov      v1.16b, v9.16b
0x0003be4c  mov      v2.16b, v10.16b
0x0003be50  bl       #0x578e0   ; CALL objc_msgSend$drawInRect:
0x0003be54  mov      x0, x21
0x0003be58  bl       #0x55d78   ; CALL _objc_release
0x0003be5c  add      x20, x20, #1
0x0003be60  ldr      x0, [x19, #0x20]
0x0003be64  bl       #0x573c0   ; CALL objc_msgSend$count
0x0003be68  cmp      x20, x0
0x0003be6c  b.lo     #0x3bce0
0x0003be70  ldp      x29, x30, [sp, #0x70]
0x0003be74  ldp      x20, x19, [sp, #0x60]
0x0003be78  ldp      x22, x21, [sp, #0x50]
0x0003be7c  ldp      x24, x23, [sp, #0x40]
0x0003be80  ldp      d9, d8, [sp, #0x30]
0x0003be84  ldp      d11, d10, [sp, #0x20]
0x0003be88  ldp      d13, d12, [sp, #0x10]
0x0003be8c  ldp      d15, d14, [sp], #0x80
0x0003be90  ret      
