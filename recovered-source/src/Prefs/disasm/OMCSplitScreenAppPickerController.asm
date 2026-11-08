=== -[OMCSplitScreenAppPickerController loadView]  va=0x363b0 size=136 types=v16@0:8
0x000363b0  stp      x20, x19, [sp, #-0x20]!
0x000363b4  stp      x29, x30, [sp, #0x10]
0x000363b8  add      x29, sp, #0x10
0x000363bc  mov      x19, x0
0x000363c0  adrp     x8, #0x8e000
0x000363c4  ldr      x0, [x8, #0x900]   ; @CLASS UITableView
0x000363c8  bl       #0x55c7c   ; CALL _objc_alloc
0x000363cc  adrp     x8, #0x74000
0x000363d0  ldr      x8, [x8, #0x610]   ; @GOT _CGRectZero
0x000363d4  ldp      d0, d1, [x8]
0x000363d8  ldp      d2, d3, [x8, #0x10]
0x000363dc  mov      w2, #2
0x000363e0  bl       #0x584a0   ; CALL objc_msgSend$initWithFrame:style:
0x000363e4  adrp     x8, #0x8e000
0x000363e8  ldrsw    x20, [x8, #0xf34]
0x000363ec  ldr      x8, [x19, x20]
0x000363f0  str      x0, [x19, x20]
0x000363f4  mov      x0, x8
0x000363f8  bl       #0x55d78   ; CALL _objc_release
0x000363fc  ldr      x0, [x19, x20]
0x00036400  mov      x2, x19
0x00036404  bl       #0x5ac00   ; CALL objc_msgSend$setDataSource:
0x00036408  ldr      x0, [x19, x20]
0x0003640c  mov      x2, x19
0x00036410  bl       #0x5aca0   ; CALL objc_msgSend$setDelegate:
0x00036414  ldr      x0, [x19, x20]
0x00036418  mov      x8, #0x404c000000000000
0x0003641c  fmov     d0, x8
0x00036420  bl       #0x5bea0   ; CALL objc_msgSend$setRowHeight:
0x00036424  ldr      x2, [x19, x20]
0x00036428  mov      x0, x19
0x0003642c  ldp      x29, x30, [sp, #0x10]
0x00036430  ldp      x20, x19, [sp], #0x20
0x00036434  b        #0x5c840   ; CALL objc_msgSend$setView:

=== -[OMCSplitScreenAppPickerController viewDidLoad]  va=0x36438 size=2192 types=v16@0:8
0x00036438  stp      x28, x27, [sp, #-0x60]!
0x0003643c  stp      x26, x25, [sp, #0x10]
0x00036440  stp      x24, x23, [sp, #0x20]
0x00036444  stp      x22, x21, [sp, #0x30]
0x00036448  stp      x20, x19, [sp, #0x40]
0x0003644c  stp      x29, x30, [sp, #0x50]
0x00036450  add      x29, sp, #0x50
0x00036454  sub      sp, sp, #0x1e0
0x00036458  mov      x21, x0
0x0003645c  adrp     x8, #0x74000
0x00036460  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00036464  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00036468  stur     x8, [x29, #-0x60]
0x0003646c  adrp     x8, #0x8e000
0x00036470  ldr      x8, [x8, #0xd90]   ; @SUPER OMCSplitScreenAppPickerController
0x00036474  stp      x0, x8, [sp, #0x40]
0x00036478  adrp     x8, #0x8b000
0x0003647c  ldr      x1, [x8, #0xda0]   ; @SEL "viewDidLoad"
0x00036480  add      x0, sp, #0x40
0x00036484  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00036488  bl       #0x17a44   ; CALL _OMCLoadStrings
0x0003648c  mov      x0, x21
0x00036490  bl       #0x5cdc0   ; CALL objc_msgSend$specifier
0x00036494  mov      x29, x29
0x00036498  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003649c  mov      x19, x0
0x000364a0  bl       #0x590e0   ; CALL objc_msgSend$name
0x000364a4  mov      x29, x29
0x000364a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000364ac  mov      x20, x0
0x000364b0  mov      x0, x21
0x000364b4  mov      x2, x20
0x000364b8  bl       #0x5c5e0   ; CALL objc_msgSend$setTitle:
0x000364bc  mov      x0, x20
0x000364c0  bl       #0x55d78   ; CALL _objc_release
0x000364c4  mov      x0, x19
0x000364c8  bl       #0x55d78   ; CALL _objc_release
0x000364cc  bl       #0x17e8c   ; CALL _OMCAccentColor
0x000364d0  mov      x29, x29
0x000364d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000364d8  mov      x19, x0
0x000364dc  mov      x0, x21
0x000364e0  bl       #0x5df60   ; CALL objc_msgSend$view
0x000364e4  mov      x29, x29
0x000364e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000364ec  mov      x20, x0
0x000364f0  mov      x2, x19
0x000364f4  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x000364f8  mov      x0, x20
0x000364fc  bl       #0x55d78   ; CALL _objc_release
0x00036500  mov      x0, x19
0x00036504  bl       #0x55d78   ; CALL _objc_release
0x00036508  bl       #0x17fe4   ; CALL _OMCBackgroundColor
0x0003650c  mov      x29, x29
0x00036510  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036514  mov      x19, x0
0x00036518  adrp     x8, #0x8e000
0x0003651c  ldrsw    x8, [x8, #0xf34]
0x00036520  ldr      x0, [x21, x8]
0x00036524  mov      x2, x19
0x00036528  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0003652c  mov      x0, x19
0x00036530  bl       #0x55d78   ; CALL _objc_release
0x00036534  adrp     x0, #0x75000
0x00036538  add      x0, x0, #0x28   ; STR "com.anlai.omnicar"
0x0003653c  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x00036540  adrp     x0, #0x76000
0x00036544  add      x0, x0, #0x8a8   ; STR "splitScreenCarPlayApps"
0x00036548  bl       #0x36280
0x0003654c  mov      x29, x29
0x00036550  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036554  mov      x20, x0
0x00036558  adrp     x8, #0x8e000
0x0003655c  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00036560  bl       #0x55d48   ; CALL _objc_opt_class
0x00036564  mov      x1, x0
0x00036568  mov      x0, x20
0x0003656c  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00036570  tbz      w0, #0, #0x36588
0x00036574  mov      x0, x20
0x00036578  bl       #0x573c0   ; CALL objc_msgSend$count
0x0003657c  cmp      x0, #0
0x00036580  cset     w8, ne
0x00036584  b        #0x3658c
0x00036588  mov      w8, #0
0x0003658c  adrp     x9, #0x8e000
0x00036590  ldrsw    x19, [x9, #0xf38]
0x00036594  strb     w8, [x21, x19]
0x00036598  adrp     x8, #0x8e000
0x0003659c  ldr      x0, [x8, #0x9a0]   ; @CLASS NSMutableSet
0x000365a0  bl       #0x5a220   ; CALL objc_msgSend$set
0x000365a4  mov      x29, x29
0x000365a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000365ac  str      x0, [sp, #0x18]
0x000365b0  adrp     x23, #0x8e000
0x000365b4  ldr      x0, [x23, #0x988]   ; @CLASS NSMutableArray
0x000365b8  bl       #0x565c0   ; CALL objc_msgSend$array
0x000365bc  mov      x29, x29
0x000365c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000365c4  mov      x22, x0
0x000365c8  str      x21, [sp, #0x20]
0x000365cc  ldrb     w8, [x21, x19]
0x000365d0  cmp      w8, #1
0x000365d4  b.ne     #0x365e4
0x000365d8  mov      x0, x22
0x000365dc  mov      x2, x20
0x000365e0  bl       #0x56160   ; CALL objc_msgSend$addObjectsFromArray:
0x000365e4  stp      x20, x22, [sp, #8]
0x000365e8  adrp     x8, #0x8e000
0x000365ec  ldr      x0, [x8, #0x9b0]   ; @CLASS NSSet
0x000365f0  adrp     x2, #0x7f000
0x000365f4  add      x2, x2, #0xbe8
0x000365f8  bl       #0x5c900   ; CALL objc_msgSend$setWithArray:
0x000365fc  mov      x29, x29
0x00036600  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036604  mov      x1, x0
0x00036608  ldr      x0, [x23, #0x988]   ; @CLASS NSMutableArray
0x0003660c  mov      x23, x1
0x00036610  bl       #0x565c0   ; CALL objc_msgSend$array
0x00036614  mov      x29, x29
0x00036618  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003661c  mov      x21, x0
0x00036620  movi     v0.16b, #0
0x00036624  stp      q0, q0, [sp, #0x90]
0x00036628  stp      q0, q0, [sp, #0xb0]
0x0003662c  bl       #0x378b8
0x00036630  mov      x29, x29
0x00036634  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036638  mov      x24, x0
0x0003663c  add      x2, sp, #0x90
0x00036640  sub      x3, x29, #0xe0
0x00036644  mov      w4, #0x10
0x00036648  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0003664c  cbz      x0, #0x3681c
0x00036650  mov      x27, x0
0x00036654  ldr      x8, [sp, #0xa0]
0x00036658  ldr      x25, [x8]   ; @SEL "whatsNewNavigationController"
0x0003665c  adrp     x28, #0x79000
0x00036660  add      x28, x28, #0xd48   ; STR "bundleIdentifier"
0x00036664  adrp     x20, #0x79000
0x00036668  add      x20, x20, #0xe88   ; STR "com.apple.developer.carplay"
0x0003666c  stp      x23, x21, [sp, #0x28]
0x00036670  str      x24, [sp, #0x38]
0x00036674  mov      x26, #0
0x00036678  ldr      x8, [sp, #0xa0]
0x0003667c  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00036680  cmp      x8, x25
0x00036684  b.eq     #0x36690
0x00036688  mov      x0, x24
0x0003668c  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00036690  ldr      x8, [sp, #0x98]
0x00036694  ldr      x19, [x8, x26, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00036698  mov      x0, x28
0x0003669c  bl       #0x55b08   ; CALL _NSSelectorFromString
0x000366a0  mov      x1, x0
0x000366a4  mov      x0, x19
0x000366a8  bl       #0x55d30   ; CALL _objc_msgSend
0x000366ac  mov      x29, x29
0x000366b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000366b4  mov      x22, x0
0x000366b8  bl       #0x58c20   ; CALL objc_msgSend$length
0x000366bc  cbz      x0, #0x367ec
0x000366c0  mov      x0, x23
0x000366c4  mov      x2, x22
0x000366c8  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x000366cc  cbz      w0, #0x366e0
0x000366d0  mov      x0, x21
0x000366d4  mov      x2, x22
0x000366d8  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x000366dc  b        #0x367ec
0x000366e0  adrp     x0, #0x79000
0x000366e4  add      x0, x0, #0xe68   ; STR "entitlements"
0x000366e8  bl       #0x55b08   ; CALL _NSSelectorFromString
0x000366ec  mov      x1, x0
0x000366f0  mov      x0, x19
0x000366f4  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x000366f8  tbz      w0, #0, #0x367ec
0x000366fc  adrp     x0, #0x79000
0x00036700  add      x0, x0, #0xe68   ; STR "entitlements"
0x00036704  bl       #0x55b08   ; CALL _NSSelectorFromString
0x00036708  mov      x1, x0
0x0003670c  mov      x0, x19
0x00036710  bl       #0x55d30   ; CALL _objc_msgSend
0x00036714  mov      x29, x29
0x00036718  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003671c  mov      x19, x0
0x00036720  movi     v0.16b, #0
0x00036724  stp      q0, q0, [sp, #0x50]
0x00036728  stp      q0, q0, [sp, #0x70]
0x0003672c  add      x2, sp, #0x50
0x00036730  add      x3, sp, #0xd0
0x00036734  mov      w4, #0x10
0x00036738  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0003673c  cbz      x0, #0x367d8
0x00036740  mov      x28, x0
0x00036744  ldr      x8, [sp, #0x60]
0x00036748  ldr      x24, [x8]   ; @CSTR "whatsNewNavigationController"
0x0003674c  mov      x21, #0
0x00036750  ldr      x8, [sp, #0x60]
0x00036754  ldr      x8, [x8]   ; @CSTR "whatsNewNavigationController"
0x00036758  cmp      x8, x24
0x0003675c  b.eq     #0x36768
0x00036760  mov      x0, x19
0x00036764  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00036768  ldr      x8, [sp, #0x58]
0x0003676c  ldr      x23, [x8, x21, lsl #3]
0x00036770  mov      x0, x23
0x00036774  mov      x2, x20
0x00036778  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x0003677c  tbnz     w0, #0, #0x367c4
0x00036780  mov      x0, x23
0x00036784  adrp     x2, #0x79000
0x00036788  add      x2, x2, #0xea8   ; STR "com.apple.developer.playable-content"
0x0003678c  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00036790  cbnz     w0, #0x367c4
0x00036794  add      x21, x21, #1
0x00036798  cmp      x28, x21
0x0003679c  b.ne     #0x36750
0x000367a0  add      x2, sp, #0x50
0x000367a4  add      x3, sp, #0xd0
0x000367a8  mov      x0, x19
0x000367ac  mov      w4, #0x10
0x000367b0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000367b4  mov      x28, x0
0x000367b8  ldp      x23, x21, [sp, #0x28]
0x000367bc  cbnz     x0, #0x3674c
0x000367c0  b        #0x367d8
0x000367c4  ldr      x21, [sp, #0x30]
0x000367c8  mov      x0, x21
0x000367cc  mov      x2, x22
0x000367d0  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x000367d4  ldr      x23, [sp, #0x28]
0x000367d8  mov      x0, x19
0x000367dc  bl       #0x55d78   ; CALL _objc_release
0x000367e0  ldr      x24, [sp, #0x38]
0x000367e4  adrp     x28, #0x79000
0x000367e8  add      x28, x28, #0xd48   ; STR "bundleIdentifier"
0x000367ec  mov      x0, x22
0x000367f0  bl       #0x55d78   ; CALL _objc_release
0x000367f4  add      x26, x26, #1
0x000367f8  cmp      x26, x27
0x000367fc  b.ne     #0x36678
0x00036800  add      x2, sp, #0x90
0x00036804  sub      x3, x29, #0xe0
0x00036808  mov      x0, x24
0x0003680c  mov      w4, #0x10
0x00036810  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00036814  mov      x27, x0
0x00036818  cbnz     x0, #0x36674
0x0003681c  mov      x0, x24
0x00036820  bl       #0x55d78   ; CALL _objc_release
0x00036824  mov      x0, x23
0x00036828  bl       #0x55d78   ; CALL _objc_release
0x0003682c  ldr      x23, [sp, #0x10]
0x00036830  mov      x0, x23
0x00036834  mov      x2, x21
0x00036838  bl       #0x56160   ; CALL objc_msgSend$addObjectsFromArray:
0x0003683c  mov      x0, x21
0x00036840  bl       #0x55d78   ; CALL _objc_release
0x00036844  mov      x0, x23
0x00036848  ldr      x22, [sp, #0x18]
0x0003684c  mov      x1, x22
0x00036850  bl       #0x36a7c
0x00036854  mov      x29, x29
0x00036858  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003685c  adrp     x8, #0x8e000
0x00036860  ldrsw    x9, [x8, #0xf3c]
0x00036864  ldr      x19, [sp, #0x20]
0x00036868  ldr      x8, [x19, x9]
0x0003686c  str      x0, [x19, x9]
0x00036870  mov      x0, x8
0x00036874  bl       #0x55d78   ; CALL _objc_release
0x00036878  adrp     x0, #0x76000
0x0003687c  add      x0, x0, #0x928   ; STR "appBridgeApps"
0x00036880  bl       #0x36280
0x00036884  mov      x29, x29
0x00036888  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003688c  mov      x20, x0
0x00036890  adrp     x8, #0x8e000
0x00036894  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00036898  bl       #0x55d48   ; CALL _objc_opt_class
0x0003689c  mov      x1, x0
0x000368a0  mov      x0, x20
0x000368a4  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x000368a8  tbz      w0, #0, #0x369e4
0x000368ac  mov      x0, x20
0x000368b0  bl       #0x573c0   ; CALL objc_msgSend$count
0x000368b4  cbz      x0, #0x369e4
0x000368b8  adrp     x8, #0x8e000
0x000368bc  ldr      x0, [x8, #0x9b0]   ; @CLASS NSSet
0x000368c0  mov      x2, x20
0x000368c4  bl       #0x5c900   ; CALL objc_msgSend$setWithArray:
0x000368c8  mov      x29, x29
0x000368cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000368d0  mov      x22, x0
0x000368d4  adrp     x8, #0x8e000
0x000368d8  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x000368dc  bl       #0x565c0   ; CALL objc_msgSend$array
0x000368e0  mov      x29, x29
0x000368e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000368e8  mov      x21, x0
0x000368ec  movi     v0.16b, #0
0x000368f0  stp      q0, q0, [sp, #0xd0]
0x000368f4  stp      q0, q0, [sp, #0xf0]
0x000368f8  bl       #0x378b8
0x000368fc  mov      x29, x29
0x00036900  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036904  mov      x23, x0
0x00036908  add      x2, sp, #0xd0
0x0003690c  sub      x3, x29, #0xe0
0x00036910  mov      w4, #0x10
0x00036914  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00036918  cbz      x0, #0x369c8
0x0003691c  mov      x24, x0
0x00036920  ldr      x8, [sp, #0xe0]
0x00036924  ldr      x26, [x8]   ; @SEL "whatsNewNavigationController"
0x00036928  adrp     x19, #0x79000
0x0003692c  add      x19, x19, #0xd48   ; STR "bundleIdentifier"
0x00036930  mov      x27, #0
0x00036934  ldr      x8, [sp, #0xe0]
0x00036938  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0003693c  cmp      x8, x26
0x00036940  b.eq     #0x3694c
0x00036944  mov      x0, x23
0x00036948  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0003694c  ldr      x8, [sp, #0xd8]
0x00036950  ldr      x25, [x8, x27, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00036954  mov      x0, x19
0x00036958  bl       #0x55b08   ; CALL _NSSelectorFromString
0x0003695c  mov      x1, x0
0x00036960  mov      x0, x25
0x00036964  bl       #0x55d30   ; CALL _objc_msgSend
0x00036968  mov      x29, x29
0x0003696c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036970  mov      x25, x0
0x00036974  bl       #0x58c20   ; CALL objc_msgSend$length
0x00036978  cbz      x0, #0x36998
0x0003697c  mov      x0, x22
0x00036980  mov      x2, x25
0x00036984  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x00036988  cbz      w0, #0x36998
0x0003698c  mov      x0, x21
0x00036990  mov      x2, x25
0x00036994  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00036998  mov      x0, x25
0x0003699c  bl       #0x55d78   ; CALL _objc_release
0x000369a0  add      x27, x27, #1
0x000369a4  cmp      x24, x27
0x000369a8  b.ne     #0x36934
0x000369ac  add      x2, sp, #0xd0
0x000369b0  sub      x3, x29, #0xe0
0x000369b4  mov      x0, x23
0x000369b8  mov      w4, #0x10
0x000369bc  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000369c0  mov      x24, x0
0x000369c4  cbnz     x0, #0x36930
0x000369c8  mov      x0, x23
0x000369cc  bl       #0x55d78   ; CALL _objc_release
0x000369d0  mov      x0, x22
0x000369d4  bl       #0x55d78   ; CALL _objc_release
0x000369d8  ldp      x22, x19, [sp, #0x18]
0x000369dc  ldr      x23, [sp, #0x10]
0x000369e0  b        #0x369ec
0x000369e4  adrp     x21, #0x74000
0x000369e8  ldr      x21, [x21, #0x1a0]   ; @GOT ___NSArray0__struct
0x000369ec  mov      x0, x20
0x000369f0  bl       #0x55d78   ; CALL _objc_release
0x000369f4  mov      x0, x21
0x000369f8  mov      x1, x22
0x000369fc  bl       #0x36a7c
0x00036a00  mov      x29, x29
0x00036a04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036a08  adrp     x8, #0x8e000
0x00036a0c  ldrsw    x9, [x8, #0xf40]
0x00036a10  ldr      x8, [x19, x9]   ; @STR "bundleIdentifier"
0x00036a14  str      x0, [x19, x9]
0x00036a18  mov      x0, x8
0x00036a1c  bl       #0x55d78   ; CALL _objc_release
0x00036a20  mov      x0, x21
0x00036a24  bl       #0x55d78   ; CALL _objc_release
0x00036a28  mov      x0, x23
0x00036a2c  bl       #0x55d78   ; CALL _objc_release
0x00036a30  mov      x0, x22
0x00036a34  bl       #0x55d78   ; CALL _objc_release
0x00036a38  ldr      x0, [sp, #8]
0x00036a3c  bl       #0x55d78   ; CALL _objc_release
0x00036a40  ldur     x8, [x29, #-0x60]
0x00036a44  adrp     x9, #0x74000
0x00036a48  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00036a4c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00036a50  cmp      x9, x8
0x00036a54  b.ne     #0x36a78
0x00036a58  add      sp, sp, #0x1e0
0x00036a5c  ldp      x29, x30, [sp, #0x50]
0x00036a60  ldp      x20, x19, [sp, #0x40]
0x00036a64  ldp      x22, x21, [sp, #0x30]
0x00036a68  ldp      x24, x23, [sp, #0x20]
0x00036a6c  ldp      x26, x25, [sp, #0x10]
0x00036a70  ldp      x28, x27, [sp], #0x60
0x00036a74  ret      
0x00036a78  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00036a7c  sub      sp, sp, #0x160
0x00036a80  stp      x28, x27, [sp, #0x100]
0x00036a84  stp      x26, x25, [sp, #0x110]
0x00036a88  stp      x24, x23, [sp, #0x120]
0x00036a8c  stp      x22, x21, [sp, #0x130]
0x00036a90  stp      x20, x19, [sp, #0x140]
0x00036a94  stp      x29, x30, [sp, #0x150]
0x00036a98  add      x29, sp, #0x150
0x00036a9c  mov      x20, x1
0x00036aa0  mov      x19, x0
0x00036aa4  adrp     x8, #0x74000
0x00036aa8  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00036aac  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00036ab0  stur     x8, [x29, #-0x60]
0x00036ab4  bl       #0x55d84   ; CALL _objc_retain
0x00036ab8  mov      x0, x20
0x00036abc  bl       #0x55d84   ; CALL _objc_retain
0x00036ac0  adrp     x8, #0x8e000
0x00036ac4  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00036ac8  bl       #0x565c0   ; CALL objc_msgSend$array
0x00036acc  mov      x29, x29
0x00036ad0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036ad4  mov      x21, x0
0x00036ad8  movi     v0.16b, #0
0x00036adc  stp      q0, q0, [sp]
0x00036ae0  stp      q0, q0, [sp, #0x20]
0x00036ae4  mov      x0, x19
0x00036ae8  bl       #0x55d84   ; CALL _objc_retain
0x00036aec  mov      x2, sp
0x00036af0  add      x3, sp, #0x70
0x00036af4  mov      x0, x19
0x00036af8  mov      w4, #0x10
0x00036afc  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00036b00  cbz      x0, #0x36c04
0x00036b04  mov      x22, x0
0x00036b08  ldr      x8, [sp, #0x10]
0x00036b0c  ldr      x25, [x8]   ; @SEL "whatsNewNavigationController"
0x00036b10  adrp     x26, #0x8e000
0x00036b14  adrp     x27, #0x8e000
0x00036b18  mov      x28, #0
0x00036b1c  ldr      x8, [sp, #0x10]
0x00036b20  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00036b24  cmp      x8, x25
0x00036b28  b.eq     #0x36b34
0x00036b2c  mov      x0, x19
0x00036b30  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00036b34  ldr      x8, [sp, #8]
0x00036b38  ldr      x23, [x8, x28, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00036b3c  ldr      x0, [x26, #0x958]   ; @CLASS NSString
0x00036b40  bl       #0x55d48   ; CALL _objc_opt_class
0x00036b44  mov      x1, x0
0x00036b48  mov      x0, x23
0x00036b4c  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00036b50  tbz      w0, #0, #0x36bdc
0x00036b54  mov      x0, x20
0x00036b58  mov      x2, x23
0x00036b5c  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x00036b60  tbnz     w0, #0, #0x36bdc
0x00036b64  mov      x0, x20
0x00036b68  mov      x2, x23
0x00036b6c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00036b70  adrp     x8, #0x75000
0x00036b74  add      x8, x8, #0x3e8   ; STR "id"
0x00036b78  str      x8, [sp, #0x50]
0x00036b7c  adrp     x8, #0x75000
0x00036b80  add      x8, x8, #0x1e8   ; STR "name"
0x00036b84  stp      x8, x23, [sp, #0x58]
0x00036b88  mov      x0, x23
0x00036b8c  bl       #0x362e8
0x00036b90  mov      x29, x29
0x00036b94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036b98  mov      x23, x0
0x00036b9c  str      x0, [sp, #0x68]
0x00036ba0  ldr      x0, [x27, #0x970]   ; @CLASS NSDictionary
0x00036ba4  add      x2, sp, #0x60
0x00036ba8  add      x3, sp, #0x50
0x00036bac  mov      w4, #2
0x00036bb0  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00036bb4  mov      x29, x29
0x00036bb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036bbc  mov      x24, x0
0x00036bc0  mov      x0, x21
0x00036bc4  mov      x2, x24
0x00036bc8  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00036bcc  mov      x0, x24
0x00036bd0  bl       #0x55d78   ; CALL _objc_release
0x00036bd4  mov      x0, x23
0x00036bd8  bl       #0x55d78   ; CALL _objc_release
0x00036bdc  add      x28, x28, #1
0x00036be0  cmp      x22, x28
0x00036be4  b.ne     #0x36b1c
0x00036be8  mov      x2, sp
0x00036bec  add      x3, sp, #0x70
0x00036bf0  mov      x0, x19
0x00036bf4  mov      w4, #0x10
0x00036bf8  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00036bfc  mov      x22, x0
0x00036c00  cbnz     x0, #0x36b18
0x00036c04  mov      x0, x19
0x00036c08  bl       #0x55d78   ; CALL _objc_release
0x00036c0c  adrp     x8, #0x8e000
0x00036c10  ldr      x0, [x8, #0xb80]   ; @CLASS NSSortDescriptor
0x00036c14  adrp     x8, #0x8c000
0x00036c18  ldr      x4, [x8, #0xb10]   ; @SEL "localizedCaseInsensitiveCompare:"
0x00036c1c  adrp     x2, #0x75000
0x00036c20  add      x2, x2, #0x1e8   ; STR "name"
0x00036c24  mov      w3, #1
0x00036c28  bl       #0x5cc60   ; CALL objc_msgSend$sortDescriptorWithKey:ascending:selector:
0x00036c2c  mov      x29, x29
0x00036c30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036c34  mov      x22, x0
0x00036c38  str      x0, [sp, #0x48]
0x00036c3c  adrp     x8, #0x8e000
0x00036c40  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00036c44  add      x2, sp, #0x48
0x00036c48  mov      w3, #1
0x00036c4c  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00036c50  mov      x29, x29
0x00036c54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036c58  mov      x23, x0
0x00036c5c  mov      x0, x21
0x00036c60  mov      x2, x23
0x00036c64  bl       #0x5cca0   ; CALL objc_msgSend$sortUsingDescriptors:
0x00036c68  mov      x0, x23
0x00036c6c  bl       #0x55d78   ; CALL _objc_release
0x00036c70  mov      x0, x22
0x00036c74  bl       #0x55d78   ; CALL _objc_release
0x00036c78  mov      x0, x20
0x00036c7c  bl       #0x55d78   ; CALL _objc_release
0x00036c80  mov      x0, x19
0x00036c84  bl       #0x55d78   ; CALL _objc_release
0x00036c88  ldur     x8, [x29, #-0x60]
0x00036c8c  adrp     x9, #0x74000
0x00036c90  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00036c94  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00036c98  cmp      x9, x8
0x00036c9c  b.ne     #0x36cc4
0x00036ca0  mov      x0, x21
0x00036ca4  ldp      x29, x30, [sp, #0x150]
0x00036ca8  ldp      x20, x19, [sp, #0x140]
0x00036cac  ldp      x22, x21, [sp, #0x130]
0x00036cb0  ldp      x24, x23, [sp, #0x120]
0x00036cb4  ldp      x26, x25, [sp, #0x110]
0x00036cb8  ldp      x28, x27, [sp, #0x100]
0x00036cbc  add      sp, sp, #0x160
0x00036cc0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00036cc4  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCSplitScreenAppPickerController currentValue]  va=0x36cc8 size=156 types=@16@0:8
0x00036cc8  stp      x22, x21, [sp, #-0x30]!
0x00036ccc  stp      x20, x19, [sp, #0x10]
0x00036cd0  stp      x29, x30, [sp, #0x20]
0x00036cd4  add      x29, sp, #0x20
0x00036cd8  bl       #0x5cdc0   ; CALL objc_msgSend$specifier
0x00036cdc  mov      x29, x29
0x00036ce0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036ce4  mov      x19, x0
0x00036ce8  adrp     x2, #0x76000
0x00036cec  add      x2, x2, #0xfc8   ; STR "key"
0x00036cf0  bl       #0x59aa0   ; CALL objc_msgSend$propertyForKey:
0x00036cf4  mov      x29, x29
0x00036cf8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036cfc  mov      x20, x0
0x00036d00  bl       #0x36280
0x00036d04  mov      x29, x29
0x00036d08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036d0c  mov      x21, x0
0x00036d10  mov      x0, x20
0x00036d14  bl       #0x55d78   ; CALL _objc_release
0x00036d18  mov      x0, x19
0x00036d1c  bl       #0x55d78   ; CALL _objc_release
0x00036d20  adrp     x8, #0x8e000
0x00036d24  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00036d28  bl       #0x55d48   ; CALL _objc_opt_class
0x00036d2c  mov      x1, x0
0x00036d30  mov      x0, x21
0x00036d34  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00036d38  tst      w0, #1
0x00036d3c  csel     x19, x21, xzr, ne
0x00036d40  mov      x0, x19
0x00036d44  bl       #0x55d84   ; CALL _objc_retain
0x00036d48  mov      x0, x21
0x00036d4c  bl       #0x55d78   ; CALL _objc_release
0x00036d50  mov      x0, x19
0x00036d54  ldp      x29, x30, [sp, #0x20]
0x00036d58  ldp      x20, x19, [sp, #0x10]
0x00036d5c  ldp      x22, x21, [sp], #0x30
0x00036d60  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCSplitScreenAppPickerController rowsInSection:]  va=0x36d64 size=68 types=@24@0:8q16
0x00036d64  stp      x20, x19, [sp, #-0x20]!
0x00036d68  stp      x29, x30, [sp, #0x10]
0x00036d6c  add      x29, sp, #0x10
0x00036d70  adrp     x8, #0x8e000
0x00036d74  add      x8, x8, #0xf40
0x00036d78  adrp     x9, #0x8e000
0x00036d7c  add      x9, x9, #0xf3c
0x00036d80  cmp      x2, #1
0x00036d84  csel     x8, x9, x8, eq
0x00036d88  ldrsw    x8, [x8]
0x00036d8c  ldr      x19, [x0, x8]
0x00036d90  mov      x0, x19
0x00036d94  bl       #0x55d84   ; CALL _objc_retain
0x00036d98  mov      x0, x19
0x00036d9c  ldp      x29, x30, [sp, #0x10]
0x00036da0  ldp      x20, x19, [sp], #0x20
0x00036da4  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCSplitScreenAppPickerController numberOfSectionsInTableView:]  va=0x36da8 size=8 types=q24@0:8@16
0x00036da8  mov      w0, #3
0x00036dac  ret      

=== -[OMCSplitScreenAppPickerController tableView:numberOfRowsInSection:]  va=0x36db0 size=76 types=q32@0:8@16q24
0x00036db0  cbz      x3, #0x36df4
0x00036db4  stp      x20, x19, [sp, #-0x20]!
0x00036db8  stp      x29, x30, [sp, #0x10]
0x00036dbc  add      x29, sp, #0x10
0x00036dc0  mov      x2, x3
0x00036dc4  bl       #0x59fc0   ; CALL objc_msgSend$rowsInSection:
0x00036dc8  mov      x29, x29
0x00036dcc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036dd0  mov      x19, x0
0x00036dd4  bl       #0x573c0   ; CALL objc_msgSend$count
0x00036dd8  mov      x20, x0
0x00036ddc  mov      x0, x19
0x00036de0  bl       #0x55d78   ; CALL _objc_release
0x00036de4  mov      x0, x20
0x00036de8  ldp      x29, x30, [sp, #0x10]
0x00036dec  ldp      x20, x19, [sp], #0x20
0x00036df0  ret      
0x00036df4  mov      w0, #1
0x00036df8  ret      

=== -[OMCSplitScreenAppPickerController tableView:titleForHeaderInSection:]  va=0x36dfc size=112 types=@32@0:8@16q24
0x00036dfc  stp      x20, x19, [sp, #-0x20]!
0x00036e00  stp      x29, x30, [sp, #0x10]
0x00036e04  add      x29, sp, #0x10
0x00036e08  mov      x20, x3
0x00036e0c  mov      x19, x2
0x00036e10  mov      x0, x2
0x00036e14  bl       #0x55d84   ; CALL _objc_retain
0x00036e18  cmp      x20, #1
0x00036e1c  b.eq     #0x36e34
0x00036e20  cmp      x20, #2
0x00036e24  b.ne     #0x36e50
0x00036e28  adrp     x0, #0x7b000
0x00036e2c  add      x0, x0, #0x9a8   ; STR "SPLITSCREEN_PICKER_PHONE_APPS"
0x00036e30  b        #0x36e3c
0x00036e34  adrp     x0, #0x7b000
0x00036e38  add      x0, x0, #0x988   ; STR "SPLITSCREEN_PICKER_CARPLAY_APPS"
0x00036e3c  bl       #0x17e20   ; CALL _L
0x00036e40  mov      x29, x29
0x00036e44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036e48  mov      x20, x0
0x00036e4c  b        #0x36e54
0x00036e50  mov      x20, #0
0x00036e54  mov      x0, x19
0x00036e58  bl       #0x55d78   ; CALL _objc_release
0x00036e5c  mov      x0, x20
0x00036e60  ldp      x29, x30, [sp, #0x10]
0x00036e64  ldp      x20, x19, [sp], #0x20
0x00036e68  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCSplitScreenAppPickerController tableView:titleForFooterInSection:]  va=0x36e6c size=172 types=@32@0:8@16q24
0x00036e6c  stp      x22, x21, [sp, #-0x30]!
0x00036e70  stp      x20, x19, [sp, #0x10]
0x00036e74  stp      x29, x30, [sp, #0x20]
0x00036e78  add      x29, sp, #0x20
0x00036e7c  mov      x21, x3
0x00036e80  mov      x19, x2
0x00036e84  mov      x20, x0
0x00036e88  mov      x0, x2
0x00036e8c  bl       #0x55d84   ; CALL _objc_retain
0x00036e90  cmp      x21, #2
0x00036e94  b.eq     #0x36eb8
0x00036e98  cmp      x21, #1
0x00036e9c  b.ne     #0x36eb0
0x00036ea0  adrp     x8, #0x8e000
0x00036ea4  ldrsw    x8, [x8, #0xf38]
0x00036ea8  ldrb     w8, [x20, x8]
0x00036eac  tbz      w8, #0, #0x36ee4
0x00036eb0  mov      x20, #0
0x00036eb4  b        #0x36efc
0x00036eb8  adrp     x8, #0x8e000
0x00036ebc  ldrsw    x8, [x8, #0xf40]
0x00036ec0  ldr      x0, [x20, x8]
0x00036ec4  bl       #0x573c0   ; CALL objc_msgSend$count
0x00036ec8  adrp     x8, #0x7b000
0x00036ecc  add      x8, x8, #0x9e8   ; STR "SPLITSCREEN_PICKER_PHONE_FOOTER"
0x00036ed0  adrp     x9, #0x7b000
0x00036ed4  add      x9, x9, #0xa08   ; STR "SPLITSCREEN_PICKER_NO_PHONE_FOOTER"
0x00036ed8  cmp      x0, #0
0x00036edc  csel     x0, x9, x8, eq
0x00036ee0  b        #0x36eec
0x00036ee4  adrp     x0, #0x7b000
0x00036ee8  add      x0, x0, #0x9c8   ; STR "SPLITSCREEN_PICKER_GUESS_FOOTER"
0x00036eec  bl       #0x17e20   ; CALL _L
0x00036ef0  mov      x29, x29
0x00036ef4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036ef8  mov      x20, x0
0x00036efc  mov      x0, x19
0x00036f00  bl       #0x55d78   ; CALL _objc_release
0x00036f04  mov      x0, x20
0x00036f08  ldp      x29, x30, [sp, #0x20]
0x00036f0c  ldp      x20, x19, [sp, #0x10]
0x00036f10  ldp      x22, x21, [sp], #0x30
0x00036f14  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCSplitScreenAppPickerController tableView:cellForRowAtIndexPath:]  va=0x36f18 size=1324 types=@32@0:8@16@24
0x00036f18  sub      sp, sp, #0x80
0x00036f1c  stp      x26, x25, [sp, #0x30]
0x00036f20  stp      x24, x23, [sp, #0x40]
0x00036f24  stp      x22, x21, [sp, #0x50]
0x00036f28  stp      x20, x19, [sp, #0x60]
0x00036f2c  stp      x29, x30, [sp, #0x70]
0x00036f30  add      x29, sp, #0x70
0x00036f34  mov      x19, x3
0x00036f38  mov      x20, x2
0x00036f3c  mov      x22, x0
0x00036f40  mov      x0, x3
0x00036f44  bl       #0x55d84   ; CALL _objc_retain
0x00036f48  adrp     x2, #0x79000
0x00036f4c  add      x2, x2, #0x9a8   ; STR "app"
0x00036f50  mov      x0, x20
0x00036f54  bl       #0x576e0   ; CALL objc_msgSend$dequeueReusableCellWithIdentifier:
0x00036f58  mov      x29, x29
0x00036f5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036f60  mov      x20, x0
0x00036f64  cbnz     x0, #0x36f88
0x00036f68  adrp     x8, #0x8e000
0x00036f6c  ldr      x0, [x8, #0x908]   ; @CLASS UITableViewCell
0x00036f70  bl       #0x55c7c   ; CALL _objc_alloc
0x00036f74  adrp     x3, #0x79000
0x00036f78  add      x3, x3, #0x9a8   ; STR "app"
0x00036f7c  mov      w2, #3
0x00036f80  bl       #0x585c0   ; CALL objc_msgSend$initWithStyle:reuseIdentifier:
0x00036f84  mov      x20, x0
0x00036f88  bl       #0x17ff8   ; CALL _OMCCardColor
0x00036f8c  mov      x29, x29
0x00036f90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036f94  mov      x21, x0
0x00036f98  mov      x0, x20
0x00036f9c  mov      x2, x21
0x00036fa0  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x00036fa4  mov      x0, x21
0x00036fa8  bl       #0x55d78   ; CALL _objc_release
0x00036fac  mov      x0, x22
0x00036fb0  bl       #0x57520   ; CALL objc_msgSend$currentValue
0x00036fb4  mov      x29, x29
0x00036fb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036fbc  mov      x21, x0
0x00036fc0  mov      x0, x19
0x00036fc4  bl       #0x5a180   ; CALL objc_msgSend$section
0x00036fc8  cbz      x0, #0x37164
0x00036fcc  mov      x0, x19
0x00036fd0  bl       #0x5a180   ; CALL objc_msgSend$section
0x00036fd4  mov      x2, x0
0x00036fd8  mov      x0, x22
0x00036fdc  bl       #0x59fc0   ; CALL objc_msgSend$rowsInSection:
0x00036fe0  mov      x29, x29
0x00036fe4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036fe8  mov      x23, x0
0x00036fec  mov      x0, x19
0x00036ff0  bl       #0x59f60   ; CALL objc_msgSend$row
0x00036ff4  mov      x2, x0
0x00036ff8  mov      x0, x23
0x00036ffc  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00037000  mov      x29, x29
0x00037004  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037008  mov      x22, x0
0x0003700c  mov      x0, x23
0x00037010  bl       #0x55d78   ; CALL _objc_release
0x00037014  adrp     x2, #0x75000
0x00037018  add      x2, x2, #0x1e8   ; STR "name"
0x0003701c  mov      x0, x22
0x00037020  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00037024  mov      x29, x29
0x00037028  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003702c  mov      x23, x0
0x00037030  mov      x0, x20
0x00037034  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00037038  mov      x29, x29
0x0003703c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037040  mov      x24, x0
0x00037044  mov      x2, x23
0x00037048  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0003704c  mov      x0, x24
0x00037050  bl       #0x55d78   ; CALL _objc_release
0x00037054  mov      x0, x23
0x00037058  bl       #0x55d78   ; CALL _objc_release
0x0003705c  adrp     x23, #0x75000
0x00037060  add      x23, x23, #0x3e8   ; STR "id"
0x00037064  mov      x0, x22
0x00037068  mov      x2, x23
0x0003706c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00037070  mov      x29, x29
0x00037074  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037078  mov      x24, x0
0x0003707c  mov      x0, x20
0x00037080  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x00037084  mov      x29, x29
0x00037088  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003708c  mov      x25, x0
0x00037090  mov      x2, x24
0x00037094  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00037098  mov      x0, x25
0x0003709c  bl       #0x55d78   ; CALL _objc_release
0x000370a0  mov      x0, x24
0x000370a4  bl       #0x55d78   ; CALL _objc_release
0x000370a8  adrp     x8, #0x8e000
0x000370ac  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x000370b0  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x000370b4  mov      x29, x29
0x000370b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000370bc  mov      x24, x0
0x000370c0  mov      x0, x20
0x000370c4  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x000370c8  mov      x29, x29
0x000370cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000370d0  mov      x25, x0
0x000370d4  mov      x2, x24
0x000370d8  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x000370dc  mov      x0, x25
0x000370e0  bl       #0x55d78   ; CALL _objc_release
0x000370e4  mov      x0, x24
0x000370e8  bl       #0x55d78   ; CALL _objc_release
0x000370ec  mov      x0, x22
0x000370f0  mov      x2, x23
0x000370f4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000370f8  mov      x29, x29
0x000370fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037100  mov      x23, x0
0x00037104  adrp     x24, #0x8e000
0x00037108  ldr      x0, [x24, #0xa78]   ; @CLASS UIImage
0x0003710c  adrp     x8, #0x8b000
0x00037110  ldr      x1, [x8, #0xf88]   ; @SEL "_applicationIconImageForBundleIdentifier:format:scale:"
0x00037114  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x00037118  tbz      w0, #0, #0x37298
0x0003711c  ldr      x24, [x24, #0xa78]   ; @CLASS UIImage
0x00037120  adrp     x8, #0x8e000
0x00037124  ldr      x0, [x8, #0xb40]   ; @CLASS UIScreen
0x00037128  bl       #0x58f00   ; CALL objc_msgSend$mainScreen
0x0003712c  mov      x29, x29
0x00037130  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037134  mov      x25, x0
0x00037138  bl       #0x5a060   ; CALL objc_msgSend$scale
0x0003713c  mov      x0, x24
0x00037140  mov      x2, x23
0x00037144  mov      w3, #2
0x00037148  bl       #0x55f60   ; CALL objc_msgSend$_applicationIconImageForBundleIdentifier:format:scale:
0x0003714c  mov      x29, x29
0x00037150  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037154  mov      x24, x0
0x00037158  mov      x0, x25
0x0003715c  bl       #0x55d78   ; CALL _objc_release
0x00037160  b        #0x3729c
0x00037164  adrp     x0, #0x7b000
0x00037168  add      x0, x0, #0xa28   ; STR "SPLITSCREEN_PICKER_NONE"
0x0003716c  bl       #0x17e20   ; CALL _L
0x00037170  mov      x29, x29
0x00037174  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037178  mov      x22, x0
0x0003717c  mov      x0, x20
0x00037180  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00037184  mov      x29, x29
0x00037188  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003718c  mov      x23, x0
0x00037190  mov      x2, x22
0x00037194  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00037198  mov      x0, x23
0x0003719c  bl       #0x55d78   ; CALL _objc_release
0x000371a0  mov      x0, x22
0x000371a4  bl       #0x55d78   ; CALL _objc_release
0x000371a8  mov      x0, x20
0x000371ac  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x000371b0  mov      x29, x29
0x000371b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000371b8  mov      x22, x0
0x000371bc  mov      x2, #0
0x000371c0  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x000371c4  mov      x0, x22
0x000371c8  bl       #0x55d78   ; CALL _objc_release
0x000371cc  adrp     x8, #0x8e000
0x000371d0  ldr      x0, [x8, #0xa70]   ; @CLASS UIImageSymbolConfiguration
0x000371d4  fmov     d0, #22.00000000
0x000371d8  mov      w2, #4
0x000371dc  bl       #0x57100   ; CALL objc_msgSend$configurationWithPointSize:weight:
0x000371e0  mov      x29, x29
0x000371e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000371e8  mov      x22, x0
0x000371ec  adrp     x8, #0x8e000
0x000371f0  ldr      x0, [x8, #0xa78]   ; @CLASS UIImage
0x000371f4  adrp     x2, #0x7b000
0x000371f8  add      x2, x2, #0xa48   ; STR "nosign"
0x000371fc  mov      x3, x22
0x00037200  bl       #0x5d840   ; CALL objc_msgSend$systemImageNamed:withConfiguration:
0x00037204  mov      x29, x29
0x00037208  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003720c  mov      x23, x0
0x00037210  adrp     x8, #0x8e000
0x00037214  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00037218  bl       #0x5d960   ; CALL objc_msgSend$tertiaryLabelColor
0x0003721c  mov      x29, x29
0x00037220  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037224  mov      x24, x0
0x00037228  mov      x0, x23
0x0003722c  mov      x2, x24
0x00037230  mov      w3, #1
0x00037234  bl       #0x58200   ; CALL objc_msgSend$imageWithTintColor:renderingMode:
0x00037238  mov      x29, x29
0x0003723c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037240  mov      x25, x0
0x00037244  mov      x0, x20
0x00037248  bl       #0x58120   ; CALL objc_msgSend$imageView
0x0003724c  mov      x29, x29
0x00037250  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037254  mov      x26, x0
0x00037258  mov      x2, x25
0x0003725c  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00037260  mov      x0, x26
0x00037264  bl       #0x55d78   ; CALL _objc_release
0x00037268  mov      x0, x25
0x0003726c  bl       #0x55d78   ; CALL _objc_release
0x00037270  mov      x0, x24
0x00037274  bl       #0x55d78   ; CALL _objc_release
0x00037278  mov      x0, x23
0x0003727c  bl       #0x55d78   ; CALL _objc_release
0x00037280  cmp      x21, #0
0x00037284  mov      w8, #3
0x00037288  csel     x2, x8, xzr, eq
0x0003728c  mov      x0, x20
0x00037290  bl       #0x5a2a0   ; CALL objc_msgSend$setAccessoryType:
0x00037294  b        #0x37394
0x00037298  mov      x24, #0
0x0003729c  mov      x0, x23
0x000372a0  bl       #0x55d78   ; CALL _objc_release
0x000372a4  cbz      x24, #0x37320
0x000372a8  adrp     x8, #0x8e000
0x000372ac  ldr      x0, [x8, #0xb00]   ; @CLASS UIGraphicsImageRenderer
0x000372b0  bl       #0x55c7c   ; CALL _objc_alloc
0x000372b4  mov      x8, #0x4042000000000000
0x000372b8  fmov     d0, x8
0x000372bc  mov      v1.16b, v0.16b
0x000372c0  bl       #0x58540   ; CALL objc_msgSend$initWithSize:
0x000372c4  mov      x25, x0
0x000372c8  adrp     x8, #0x74000
0x000372cc  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x000372d0  str      x8, [sp, #8]
0x000372d4  adrp     x8, #0x65000
0x000372d8  ldr      d0, [x8, #0x600]
0x000372dc  adrp     x8, #0x37000
0x000372e0  add      x8, x8, #0x3cc
0x000372e4  str      d0, [sp, #0x10]
0x000372e8  adrp     x9, #0x74000
0x000372ec  add      x9, x9, #0xc30
0x000372f0  stp      x8, x9, [sp, #0x18]
0x000372f4  str      x24, [sp, #0x28]
0x000372f8  add      x2, sp, #8
0x000372fc  bl       #0x58140   ; CALL objc_msgSend$imageWithActions:
0x00037300  mov      x29, x29
0x00037304  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037308  mov      x23, x0
0x0003730c  ldr      x0, [sp, #0x28]
0x00037310  bl       #0x55d78   ; CALL _objc_release
0x00037314  mov      x0, x25
0x00037318  bl       #0x55d78   ; CALL _objc_release
0x0003731c  b        #0x37324
0x00037320  mov      x23, #0
0x00037324  mov      x0, x20
0x00037328  bl       #0x58120   ; CALL objc_msgSend$imageView
0x0003732c  mov      x29, x29
0x00037330  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037334  mov      x24, x0
0x00037338  mov      x2, x23
0x0003733c  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00037340  mov      x0, x24
0x00037344  bl       #0x55d78   ; CALL _objc_release
0x00037348  adrp     x2, #0x75000
0x0003734c  add      x2, x2, #0x3e8   ; STR "id"
0x00037350  mov      x0, x22
0x00037354  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00037358  mov      x29, x29
0x0003735c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037360  mov      x24, x0
0x00037364  mov      x0, x21
0x00037368  mov      x2, x24
0x0003736c  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00037370  cmp      w0, #0
0x00037374  mov      w8, #3
0x00037378  csel     x2, x8, xzr, ne
0x0003737c  mov      x0, x20
0x00037380  bl       #0x5a2a0   ; CALL objc_msgSend$setAccessoryType:
0x00037384  mov      x0, x24
0x00037388  bl       #0x55d78   ; CALL _objc_release
0x0003738c  mov      x0, x23
0x00037390  bl       #0x55d78   ; CALL _objc_release
0x00037394  mov      x0, x22
0x00037398  bl       #0x55d78   ; CALL _objc_release
0x0003739c  mov      x0, x21
0x000373a0  bl       #0x55d78   ; CALL _objc_release
0x000373a4  mov      x0, x19
0x000373a8  bl       #0x55d78   ; CALL _objc_release
0x000373ac  mov      x0, x20
0x000373b0  ldp      x29, x30, [sp, #0x70]
0x000373b4  ldp      x20, x19, [sp, #0x60]
0x000373b8  ldp      x22, x21, [sp, #0x50]
0x000373bc  ldp      x24, x23, [sp, #0x40]
0x000373c0  ldp      x26, x25, [sp, #0x30]
0x000373c4  add      sp, sp, #0x80
0x000373c8  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x000373cc  stp      d9, d8, [sp, #-0x30]!
0x000373d0  stp      x20, x19, [sp, #0x10]
0x000373d4  stp      x29, x30, [sp, #0x20]
0x000373d8  add      x29, sp, #0x20
0x000373dc  mov      x19, x0
0x000373e0  adrp     x8, #0x8e000
0x000373e4  ldr      x0, [x8, #0xac0]   ; @CLASS UIBezierPath
0x000373e8  mov      x8, #0x4042000000000000
0x000373ec  fmov     d8, x8
0x000373f0  fmov     d0, xzr
0x000373f4  fmov     d1, xzr
0x000373f8  fmov     d4, #9.00000000
0x000373fc  mov      v2.16b, v8.16b
0x00037400  mov      v3.16b, v8.16b
0x00037404  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x00037408  mov      x29, x29
0x0003740c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037410  mov      x20, x0
0x00037414  bl       #0x560a0   ; CALL objc_msgSend$addClip
0x00037418  mov      x0, x20
0x0003741c  bl       #0x55d78   ; CALL _objc_release
0x00037420  ldr      x0, [x19, #0x20]
0x00037424  fmov     d0, xzr
0x00037428  fmov     d1, xzr
0x0003742c  mov      v2.16b, v8.16b
0x00037430  mov      v3.16b, v8.16b
0x00037434  ldp      x29, x30, [sp, #0x20]
0x00037438  ldp      x20, x19, [sp, #0x10]
0x0003743c  ldp      d9, d8, [sp], #0x30
0x00037440  b        #0x578e0   ; CALL objc_msgSend$drawInRect:

=== -[OMCSplitScreenAppPickerController tableView:didSelectRowAtIndexPath:]  va=0x37444 size=784 types=v32@0:8@16@24
0x00037444  sub      sp, sp, #0x80
0x00037448  stp      x26, x25, [sp, #0x30]
0x0003744c  stp      x24, x23, [sp, #0x40]
0x00037450  stp      x22, x21, [sp, #0x50]
0x00037454  stp      x20, x19, [sp, #0x60]
0x00037458  stp      x29, x30, [sp, #0x70]
0x0003745c  add      x29, sp, #0x70
0x00037460  mov      x20, x3
0x00037464  mov      x19, x2
0x00037468  mov      x21, x0
0x0003746c  mov      x0, x2
0x00037470  bl       #0x55d84   ; CALL _objc_retain
0x00037474  mov      x0, x20
0x00037478  bl       #0x55d84   ; CALL _objc_retain
0x0003747c  mov      x0, x19
0x00037480  mov      x2, x20
0x00037484  mov      w3, #1
0x00037488  bl       #0x57740   ; CALL objc_msgSend$deselectRowAtIndexPath:animated:
0x0003748c  mov      x0, x21
0x00037490  bl       #0x5cdc0   ; CALL objc_msgSend$specifier
0x00037494  mov      x29, x29
0x00037498  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003749c  mov      x23, x0
0x000374a0  adrp     x2, #0x76000
0x000374a4  add      x2, x2, #0xfc8   ; STR "key"
0x000374a8  bl       #0x59aa0   ; CALL objc_msgSend$propertyForKey:
0x000374ac  mov      x29, x29
0x000374b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000374b4  mov      x22, x0
0x000374b8  mov      x0, x23
0x000374bc  bl       #0x55d78   ; CALL _objc_release
0x000374c0  adrp     x8, #0x8e000
0x000374c4  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x000374c8  bl       #0x55d48   ; CALL _objc_opt_class
0x000374cc  mov      x1, x0
0x000374d0  mov      x0, x22
0x000374d4  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x000374d8  tbz      w0, #0, #0x37664
0x000374dc  mov      x0, x20
0x000374e0  bl       #0x5a180   ; CALL objc_msgSend$section
0x000374e4  cbz      x0, #0x37568
0x000374e8  mov      x0, x20
0x000374ec  bl       #0x5a180   ; CALL objc_msgSend$section
0x000374f0  mov      x2, x0
0x000374f4  mov      x0, x21
0x000374f8  bl       #0x59fc0   ; CALL objc_msgSend$rowsInSection:
0x000374fc  mov      x29, x29
0x00037500  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037504  mov      x23, x0
0x00037508  mov      x0, x20
0x0003750c  bl       #0x59f60   ; CALL objc_msgSend$row
0x00037510  mov      x2, x0
0x00037514  mov      x0, x23
0x00037518  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0003751c  mov      x29, x29
0x00037520  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037524  mov      x24, x0
0x00037528  adrp     x2, #0x75000
0x0003752c  add      x2, x2, #0x3e8   ; STR "id"
0x00037530  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00037534  mov      x29, x29
0x00037538  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003753c  mov      x25, x0
0x00037540  mov      x0, x22
0x00037544  mov      x1, x25
0x00037548  bl       #0x37698
0x0003754c  mov      x0, x25
0x00037550  bl       #0x55d78   ; CALL _objc_release
0x00037554  mov      x0, x24
0x00037558  bl       #0x55d78   ; CALL _objc_release
0x0003755c  mov      x0, x23
0x00037560  bl       #0x55d78   ; CALL _objc_release
0x00037564  b        #0x37574
0x00037568  mov      x0, x22
0x0003756c  mov      x1, #0
0x00037570  bl       #0x37698
0x00037574  adrp     x0, #0x61000
0x00037578  add      x0, x0, #0x1b1   ; CSTR "com.anlai.omnicar/prefschanged"
0x0003757c  bl       #0x55c70   ; CALL _notify_post
0x00037580  mov      x0, x19
0x00037584  bl       #0x59ca0   ; CALL objc_msgSend$reloadData
0x00037588  adrp     x0, #0x7b000
0x0003758c  add      x0, x0, #0xa68   ; STR "parentController"
0x00037590  bl       #0x55b08   ; CALL _NSSelectorFromString
0x00037594  mov      x1, x0
0x00037598  mov      x0, x21
0x0003759c  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x000375a0  tbz      w0, #0, #0x375cc
0x000375a4  adrp     x0, #0x7b000
0x000375a8  add      x0, x0, #0xa68   ; STR "parentController"
0x000375ac  bl       #0x55b08   ; CALL _NSSelectorFromString
0x000375b0  mov      x1, x0
0x000375b4  mov      x0, x21
0x000375b8  bl       #0x55d30   ; CALL _objc_msgSend
0x000375bc  mov      x29, x29
0x000375c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000375c4  mov      x23, x0
0x000375c8  b        #0x375d0
0x000375cc  mov      x23, #0
0x000375d0  adrp     x8, #0x8c000
0x000375d4  ldr      x1, [x8, #0xef8]   ; @SEL "reloadSpecifier:"
0x000375d8  mov      x0, x23
0x000375dc  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x000375e0  tbz      w0, #0, #0x3760c
0x000375e4  mov      x0, x21
0x000375e8  bl       #0x5cdc0   ; CALL objc_msgSend$specifier
0x000375ec  mov      x29, x29
0x000375f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000375f4  mov      x24, x0
0x000375f8  mov      x0, x23
0x000375fc  mov      x2, x24
0x00037600  bl       #0x59d20   ; CALL objc_msgSend$reloadSpecifier:
0x00037604  mov      x0, x24
0x00037608  bl       #0x55d78   ; CALL _objc_release
0x0003760c  mov      x0, #0
0x00037610  mov      w1, #0xb280
0x00037614  movk     w1, #0xee6, lsl #16
0x00037618  bl       #0x55c28   ; CALL _dispatch_time
0x0003761c  adrp     x8, #0x74000
0x00037620  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00037624  str      x8, [sp, #8]
0x00037628  adrp     x8, #0x65000
0x0003762c  ldr      d0, [x8, #0x600]
0x00037630  adrp     x8, #0x37000
0x00037634  add      x8, x8, #0x714
0x00037638  str      d0, [sp, #0x10]
0x0003763c  adrp     x9, #0x74000
0x00037640  add      x9, x9, #0x6e0
0x00037644  stp      x8, x9, [sp, #0x18]
0x00037648  str      x21, [sp, #0x28]
0x0003764c  adrp     x1, #0x74000
0x00037650  ldr      x1, [x1, #0x3a0]   ; @GOT __dispatch_main_q
0x00037654  add      x2, sp, #8
0x00037658  bl       #0x55bd4   ; CALL _dispatch_after
0x0003765c  mov      x0, x23
0x00037660  bl       #0x55d78   ; CALL _objc_release
0x00037664  mov      x0, x22
0x00037668  bl       #0x55d78   ; CALL _objc_release
0x0003766c  mov      x0, x20
0x00037670  bl       #0x55d78   ; CALL _objc_release
0x00037674  mov      x0, x19
0x00037678  bl       #0x55d78   ; CALL _objc_release
0x0003767c  ldp      x29, x30, [sp, #0x70]
0x00037680  ldp      x20, x19, [sp, #0x60]
0x00037684  ldp      x22, x21, [sp, #0x50]
0x00037688  ldp      x24, x23, [sp, #0x40]
0x0003768c  ldp      x26, x25, [sp, #0x30]
0x00037690  add      sp, sp, #0x80
0x00037694  ret      
0x00037698  stp      x22, x21, [sp, #-0x30]!
0x0003769c  stp      x20, x19, [sp, #0x10]
0x000376a0  stp      x29, x30, [sp, #0x20]
0x000376a4  add      x29, sp, #0x20
0x000376a8  mov      x20, x1
0x000376ac  mov      x19, x0
0x000376b0  bl       #0x55d84   ; CALL _objc_retain
0x000376b4  mov      x0, x20
0x000376b8  bl       #0x55d84   ; CALL _objc_retain
0x000376bc  adrp     x8, #0x8e000
0x000376c0  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x000376c4  bl       #0x55d48   ; CALL _objc_opt_class
0x000376c8  mov      x1, x0
0x000376cc  mov      x0, x19
0x000376d0  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x000376d4  tbz      w0, #0, #0x376f8
0x000376d8  adrp     x21, #0x75000
0x000376dc  add      x21, x21, #0x28   ; STR "com.anlai.omnicar"
0x000376e0  mov      x0, x19
0x000376e4  mov      x1, x20
0x000376e8  mov      x2, x21
0x000376ec  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x000376f0  mov      x0, x21
0x000376f4  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x000376f8  mov      x0, x20
0x000376fc  bl       #0x55d78   ; CALL _objc_release
0x00037700  mov      x0, x19
0x00037704  ldp      x29, x30, [sp, #0x20]
0x00037708  ldp      x20, x19, [sp, #0x10]
0x0003770c  ldp      x22, x21, [sp], #0x30
0x00037710  b        #0x55d78   ; CALL _objc_release
0x00037714  stp      x20, x19, [sp, #-0x20]!
0x00037718  stp      x29, x30, [sp, #0x10]
0x0003771c  add      x29, sp, #0x10
0x00037720  ldr      x0, [x0, #0x20]   ; @STR "#2E9CF5"
0x00037724  bl       #0x59180   ; CALL objc_msgSend$navigationController
0x00037728  mov      x29, x29
0x0003772c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037730  mov      x19, x0
0x00037734  mov      w2, #1
0x00037738  bl       #0x59820   ; CALL objc_msgSend$popViewControllerAnimated:
0x0003773c  mov      x29, x29
0x00037740  bl       #0x55dfc   ; CALL _objc_unsafeClaimAutoreleasedReturnValue
0x00037744  mov      x0, x19
0x00037748  ldp      x29, x30, [sp, #0x10]
0x0003774c  ldp      x20, x19, [sp], #0x20
0x00037750  b        #0x55d78   ; CALL _objc_release

=== -[OMCSplitScreenAppPickerController table]  va=0x37754 size=16 types=@16@0:8
0x00037754  adrp     x8, #0x8e000
0x00037758  ldrsw    x8, [x8, #0xf34]
0x0003775c  ldr      x0, [x0, x8]
0x00037760  ret      

=== -[OMCSplitScreenAppPickerController setTable:]  va=0x37764 size=64 types=v24@0:8@16
0x00037764  stp      x22, x21, [sp, #-0x30]!
0x00037768  stp      x20, x19, [sp, #0x10]
0x0003776c  stp      x29, x30, [sp, #0x20]
0x00037770  add      x29, sp, #0x20
0x00037774  mov      x19, x2
0x00037778  mov      x20, x0
0x0003777c  adrp     x8, #0x8e000
0x00037780  ldrsw    x21, [x8, #0xf34]
0x00037784  mov      x0, x2
0x00037788  bl       #0x55d84   ; CALL _objc_retain
0x0003778c  ldr      x0, [x20, x21]
0x00037790  str      x19, [x20, x21]
0x00037794  ldp      x29, x30, [sp, #0x20]
0x00037798  ldp      x20, x19, [sp, #0x10]
0x0003779c  ldp      x22, x21, [sp], #0x30
0x000377a0  b        #0x55d78   ; CALL _objc_release

=== -[OMCSplitScreenAppPickerController carPlayApps]  va=0x377a4 size=16 types=@16@0:8
0x000377a4  adrp     x8, #0x8e000
0x000377a8  ldrsw    x8, [x8, #0xf3c]
0x000377ac  ldr      x0, [x0, x8]
0x000377b0  ret      

=== -[OMCSplitScreenAppPickerController setCarPlayApps:]  va=0x377b4 size=64 types=v24@0:8@16
0x000377b4  stp      x22, x21, [sp, #-0x30]!
0x000377b8  stp      x20, x19, [sp, #0x10]
0x000377bc  stp      x29, x30, [sp, #0x20]
0x000377c0  add      x29, sp, #0x20
0x000377c4  mov      x19, x2
0x000377c8  mov      x20, x0
0x000377cc  adrp     x8, #0x8e000
0x000377d0  ldrsw    x21, [x8, #0xf3c]
0x000377d4  mov      x0, x2
0x000377d8  bl       #0x55d84   ; CALL _objc_retain
0x000377dc  ldr      x0, [x20, x21]
0x000377e0  str      x19, [x20, x21]
0x000377e4  ldp      x29, x30, [sp, #0x20]
0x000377e8  ldp      x20, x19, [sp, #0x10]
0x000377ec  ldp      x22, x21, [sp], #0x30
0x000377f0  b        #0x55d78   ; CALL _objc_release

=== -[OMCSplitScreenAppPickerController phoneApps]  va=0x377f4 size=16 types=@16@0:8
0x000377f4  adrp     x8, #0x8e000
0x000377f8  ldrsw    x8, [x8, #0xf40]
0x000377fc  ldr      x0, [x0, x8]
0x00037800  ret      

=== -[OMCSplitScreenAppPickerController setPhoneApps:]  va=0x37804 size=64 types=v24@0:8@16
0x00037804  stp      x22, x21, [sp, #-0x30]!
0x00037808  stp      x20, x19, [sp, #0x10]
0x0003780c  stp      x29, x30, [sp, #0x20]
0x00037810  add      x29, sp, #0x20
0x00037814  mov      x19, x2
0x00037818  mov      x20, x0
0x0003781c  adrp     x8, #0x8e000
0x00037820  ldrsw    x21, [x8, #0xf40]
0x00037824  mov      x0, x2
0x00037828  bl       #0x55d84   ; CALL _objc_retain
0x0003782c  ldr      x0, [x20, x21]
0x00037830  str      x19, [x20, x21]
0x00037834  ldp      x29, x30, [sp, #0x20]
0x00037838  ldp      x20, x19, [sp, #0x10]
0x0003783c  ldp      x22, x21, [sp], #0x30
0x00037840  b        #0x55d78   ; CALL _objc_release

=== -[OMCSplitScreenAppPickerController fromCar]  va=0x37844 size=16 types=B16@0:8
0x00037844  adrp     x8, #0x8e000
0x00037848  ldrsw    x8, [x8, #0xf38]
0x0003784c  ldrb     w0, [x0, x8]
0x00037850  ret      

=== -[OMCSplitScreenAppPickerController setFromCar:]  va=0x37854 size=16 types=v20@0:8B16
0x00037854  adrp     x8, #0x8e000
0x00037858  ldrsw    x8, [x8, #0xf38]
0x0003785c  strb     w2, [x0, x8]
0x00037860  ret      

=== -[OMCSplitScreenAppPickerController .cxx_destruct]  va=0x37864 size=224 types=v16@0:8
0x00037864  stp      x20, x19, [sp, #-0x20]!
0x00037868  stp      x29, x30, [sp, #0x10]
0x0003786c  add      x29, sp, #0x10
0x00037870  mov      x19, x0
0x00037874  adrp     x8, #0x8e000
0x00037878  ldrsw    x8, [x8, #0xf40]
0x0003787c  add      x0, x0, x8
0x00037880  mov      x1, #0
0x00037884  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00037888  adrp     x8, #0x8e000
0x0003788c  ldrsw    x8, [x8, #0xf3c]
0x00037890  add      x0, x19, x8
0x00037894  mov      x1, #0
0x00037898  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0003789c  adrp     x8, #0x8e000
0x000378a0  ldrsw    x8, [x8, #0xf34]
0x000378a4  add      x0, x19, x8
0x000378a8  mov      x1, #0
0x000378ac  ldp      x29, x30, [sp, #0x10]
0x000378b0  ldp      x20, x19, [sp], #0x20
0x000378b4  b        #0x55dcc   ; CALL _objc_storeStrong
0x000378b8  stp      x20, x19, [sp, #-0x20]!
0x000378bc  stp      x29, x30, [sp, #0x10]
0x000378c0  add      x29, sp, #0x10
0x000378c4  adrp     x0, #0x62000
0x000378c8  add      x0, x0, #0x227   ; CSTR "LSApplicationWorkspace"
0x000378cc  bl       #0x55d0c   ; CALL _objc_getClass
0x000378d0  cbz      x0, #0x37930
0x000378d4  mov      x19, x0
0x000378d8  adrp     x0, #0x77000
0x000378dc  add      x0, x0, #0x7e8   ; STR "defaultWorkspace"
0x000378e0  bl       #0x55b08   ; CALL _NSSelectorFromString
0x000378e4  mov      x1, x0
0x000378e8  mov      x0, x19
0x000378ec  bl       #0x55d30   ; CALL _objc_msgSend
0x000378f0  mov      x29, x29
0x000378f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000378f8  cbz      x0, #0x37930
0x000378fc  mov      x19, x0
0x00037900  adrp     x0, #0x79000
0x00037904  add      x0, x0, #0xca8   ; STR "allInstalledApplications"
0x00037908  bl       #0x55b08   ; CALL _NSSelectorFromString
0x0003790c  mov      x1, x0
0x00037910  mov      x0, x19
0x00037914  bl       #0x55d30   ; CALL _objc_msgSend
0x00037918  mov      x29, x29
0x0003791c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00037920  mov      x20, x0
0x00037924  mov      x0, x19
0x00037928  bl       #0x55d78   ; CALL _objc_release
0x0003792c  b        #0x37934
0x00037930  mov      x20, #0
0x00037934  mov      x0, x20
0x00037938  ldp      x29, x30, [sp, #0x10]
0x0003793c  ldp      x20, x19, [sp], #0x20
0x00037940  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
