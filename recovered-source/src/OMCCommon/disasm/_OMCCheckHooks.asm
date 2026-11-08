; === _OMCCheckHooks @ 0x7408 size=1776 ===
0x00007408  sub      sp, sp, #0x190
0x0000740c  stp      x28, x27, [sp, #0x130]
0x00007410  stp      x26, x25, [sp, #0x140]
0x00007414  stp      x24, x23, [sp, #0x150]
0x00007418  stp      x22, x21, [sp, #0x160]
0x0000741c  stp      x20, x19, [sp, #0x170]
0x00007420  stp      x29, x30, [sp, #0x180]
0x00007424  add      x29, sp, #0x180
0x00007428  mov      x26, x1
0x0000742c  adrp     x8, #0x14000
0x00007430  ldr      x8, [x8, #0x1c0] ; -> [got(___stack_chk_guard)]
0x00007434  ldr      x8, [x8] ; -> [got(___objc_personality_v0)]
0x00007438  stur     x8, [x29, #-0x60]
0x0000743c  str      x0, [sp, #0x20]
0x00007440  bl       #0xd4c4 ; call stub:_objc_retain
0x00007444  mov      x0, x26
0x00007448  bl       #0xd4c4 ; call stub:_objc_retain
0x0000744c  adrp     x8, #0x18000
0x00007450  ldr      x0, [x8, #0x458] ; -> [classref(NSMutableArray)]
0x00007454  bl       #0xd740 ; call objc_stub[array]
0x00007458  mov      x29, x29
0x0000745c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007460  str      x0, [sp, #0x30]
0x00007464  adrp     x8, #0x18000
0x00007468  ldr      x0, [x8, #0x490] ; -> [classref(NSMutableOrderedSet)]
0x0000746c  bl       #0xdf80 ; call objc_stub[orderedSet]
0x00007470  mov      x29, x29
0x00007474  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007478  str      x0, [sp, #0x28]
0x0000747c  movi     v0.16b, #0
0x00007480  stp      q0, q0, [sp, #0x40]
0x00007484  stp      q0, q0, [sp, #0x60]
0x00007488  mov      x0, x26
0x0000748c  bl       #0xd4c4 ; call stub:_objc_retain
0x00007490  add      x2, sp, #0x40
0x00007494  add      x3, sp, #0xa0
0x00007498  mov      x0, x26
0x0000749c  mov      w4, #0x10
0x000074a0  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x000074a4  str      x26, [sp, #0x38]
0x000074a8  cbz      x0, #0x76d0
0x000074ac  mov      x24, x0
0x000074b0  ldr      x8, [sp, #0x50]
0x000074b4  ldr      x20, [x8] ; -> [selref(CGContext)]
0x000074b8  adrp     x23, #0x15000
0x000074bc  add      x23, x23, #0x8e8 ; -> CFSTR(" ")
0x000074c0  mov      x25, #0
0x000074c4  ldr      x8, [sp, #0x50]
0x000074c8  ldr      x8, [x8] ; -> [selref(CGContext)]
0x000074cc  cmp      x8, x20
0x000074d0  b.eq     #0x74dc
0x000074d4  mov      x0, x26
0x000074d8  bl       #0xd458 ; call stub:_objc_enumerationMutation
0x000074dc  ldr      x8, [sp, #0x48]
0x000074e0  ldr      x28, [x8, x25, lsl #3] ; -> [selref(CGContext)]
0x000074e4  mov      x0, x28
0x000074e8  mov      x2, x23
0x000074ec  bl       #0xd8c0 ; call objc_stub[componentsSeparatedByString:]
0x000074f0  mov      x29, x29
0x000074f4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000074f8  mov      x27, x0
0x000074fc  bl       #0xd960 ; call objc_stub[count]
0x00007500  cmp      x0, #2
0x00007504  b.ne     #0x76a0
0x00007508  mov      x0, x27
0x0000750c  mov      x2, #0
0x00007510  bl       #0xdf40 ; call objc_stub[objectAtIndexedSubscript:]
0x00007514  mov      x29, x29
0x00007518  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000751c  mov      x22, x0
0x00007520  bl       #0xd4d0 ; call stub:_objc_retainAutorelease
0x00007524  bl       #0xd680 ; call objc_stub[UTF8String]
0x00007528  bl       #0x72c0 ; call _OMCCarClass
0x0000752c  mov      x19, x0
0x00007530  mov      x0, x22
0x00007534  bl       #0xd4b8 ; call stub:_objc_release
0x00007538  cbz      x19, #0x7608
0x0000753c  mov      x0, x19
0x00007540  bl       #0xd188 ; call stub:_NSStringFromClass
0x00007544  mov      x29, x29
0x00007548  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000754c  mov      x22, x0
0x00007550  mov      x0, x27
0x00007554  mov      x2, #0
0x00007558  bl       #0xdf40 ; call objc_stub[objectAtIndexedSubscript:]
0x0000755c  mov      x29, x29
0x00007560  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007564  mov      x26, x0
0x00007568  mov      x0, x22
0x0000756c  mov      x2, x26
0x00007570  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x00007574  mov      x21, x0
0x00007578  mov      x0, x26
0x0000757c  ldr      x26, [sp, #0x38]
0x00007580  bl       #0xd4b8 ; call stub:_objc_release
0x00007584  mov      x0, x22
0x00007588  bl       #0xd4b8 ; call stub:_objc_release
0x0000758c  tbnz     w21, #0, #0x7608
0x00007590  adrp     x8, #0x18000
0x00007594  ldr      x21, [x8, #0x3f0] ; -> [classref(NSString)]
0x00007598  mov      x0, x27
0x0000759c  mov      x2, #0
0x000075a0  bl       #0xdf40 ; call objc_stub[objectAtIndexedSubscript:]
0x000075a4  mov      x29, x29
0x000075a8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000075ac  mov      x22, x0
0x000075b0  mov      x0, x19
0x000075b4  bl       #0xd188 ; call stub:_NSStringFromClass
0x000075b8  mov      x29, x29
0x000075bc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000075c0  mov      x19, x0
0x000075c4  stp      x22, x0, [sp]
0x000075c8  mov      x0, x21
0x000075cc  adrp     x2, #0x15000
0x000075d0  add      x2, x2, #0x908 ; -> CFSTR("%@=%@")
0x000075d4  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x000075d8  mov      x29, x29
0x000075dc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000075e0  mov      x21, x0
0x000075e4  ldr      x0, [sp, #0x28]
0x000075e8  mov      x2, x21
0x000075ec  bl       #0xd6a0 ; call objc_stub[addObject:]
0x000075f0  mov      x0, x21
0x000075f4  bl       #0xd4b8 ; call stub:_objc_release
0x000075f8  mov      x0, x19
0x000075fc  bl       #0xd4b8 ; call stub:_objc_release
0x00007600  mov      x0, x22
0x00007604  bl       #0xd4b8 ; call stub:_objc_release
0x00007608  mov      x0, x27
0x0000760c  mov      w2, #1
0x00007610  bl       #0xdf40 ; call objc_stub[objectAtIndexedSubscript:]
0x00007614  mov      x29, x29
0x00007618  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000761c  mov      x19, x0
0x00007620  adrp     x2, #0x15000
0x00007624  add      x2, x2, #0x928 ; -> CFSTR("-")
0x00007628  bl       #0xdba0 ; call objc_stub[hasPrefix:]
0x0000762c  cbz      w0, #0x7654
0x00007630  mov      x0, x19
0x00007634  mov      w2, #1
0x00007638  bl       #0xe460 ; call objc_stub[substringFromIndex:]
0x0000763c  mov      x29, x29
0x00007640  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007644  mov      x21, x0
0x00007648  mov      x0, x19
0x0000764c  bl       #0xd4b8 ; call stub:_objc_release
0x00007650  mov      x19, x21
0x00007654  mov      x0, x27
0x00007658  mov      x2, #0
0x0000765c  bl       #0xdf40 ; call objc_stub[objectAtIndexedSubscript:]
0x00007660  mov      x29, x29
0x00007664  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007668  mov      x21, x0
0x0000766c  bl       #0xd4d0 ; call stub:_objc_retainAutorelease
0x00007670  bl       #0xd680 ; call objc_stub[UTF8String]
0x00007674  mov      x1, x19
0x00007678  bl       #0x720c ; call _OMCHasMethod
0x0000767c  mov      x22, x0
0x00007680  mov      x0, x21
0x00007684  bl       #0xd4b8 ; call stub:_objc_release
0x00007688  tbnz     w22, #0, #0x7698
0x0000768c  ldr      x0, [sp, #0x30]
0x00007690  mov      x2, x28
0x00007694  bl       #0xd6a0 ; call objc_stub[addObject:]
0x00007698  mov      x0, x19
0x0000769c  bl       #0xd4b8 ; call stub:_objc_release
0x000076a0  mov      x0, x27
0x000076a4  bl       #0xd4b8 ; call stub:_objc_release
0x000076a8  add      x25, x25, #1
0x000076ac  cmp      x24, x25
0x000076b0  b.ne     #0x74c4
0x000076b4  add      x2, sp, #0x40
0x000076b8  add      x3, sp, #0xa0
0x000076bc  mov      x0, x26
0x000076c0  mov      w4, #0x10
0x000076c4  bl       #0xd980 ; call objc_stub[countByEnumeratingWithState:objects:count:]
0x000076c8  mov      x24, x0
0x000076cc  cbnz     x0, #0x74c0
0x000076d0  mov      x0, x26
0x000076d4  bl       #0xd4b8 ; call stub:_objc_release
0x000076d8  adrp     x8, #0x18000
0x000076dc  ldr      x0, [x8, #0x498] ; -> [classref(UIDevice)]
0x000076e0  bl       #0xd9a0 ; call objc_stub[currentDevice]
0x000076e4  mov      x29, x29
0x000076e8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000076ec  mov      x19, x0
0x000076f0  bl       #0xe4a0 ; call objc_stub[systemVersion]
0x000076f4  mov      x29, x29
0x000076f8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000076fc  mov      x23, x0
0x00007700  mov      x0, x19
0x00007704  bl       #0xd4b8 ; call stub:_objc_release
0x00007708  adrp     x20, #0x18000
0x0000770c  ldr      x8, [x20, #0x570] ; -> [__DATA,__bss+0x70]
0x00007710  cbnz     x8, #0x7738
0x00007714  adrp     x8, #0x18000
0x00007718  ldr      x0, [x8, #0x470] ; -> [classref(NSMutableDictionary)]
0x0000771c  bl       #0xda80 ; call objc_stub[dictionary]
0x00007720  mov      x29, x29
0x00007724  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007728  ldr      x8, [x20, #0x570] ; -> [__DATA,__bss+0x70]
0x0000772c  str      x0, [x20, #0x570]
0x00007730  mov      x0, x8
0x00007734  bl       #0xd4b8 ; call stub:_objc_release
0x00007738  adrp     x8, #0x18000
0x0000773c  ldr      x19, [x8, #0x3f0] ; -> [classref(NSString)]
0x00007740  adrp     x8, #0x18000
0x00007744  ldr      x0, [x8, #0x488] ; -> [classref(NSProcessInfo)]
0x00007748  bl       #0xe040 ; call objc_stub[processInfo]
0x0000774c  mov      x29, x29
0x00007750  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007754  mov      x21, x0
0x00007758  bl       #0xe060 ; call objc_stub[processName]
0x0000775c  mov      x29, x29
0x00007760  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007764  mov      x22, x0
0x00007768  adrp     x8, #0x15000
0x0000776c  add      x8, x8, #0x968 ; -> CFSTR("diagHooks.")
0x00007770  ldr      x27, [sp, #0x20]
0x00007774  stp      x27, x0, [sp, #8]
0x00007778  str      x8, [sp]
0x0000777c  adrp     x2, #0x15000
0x00007780  add      x2, x2, #0x948 ; -> CFSTR("%@%@@%@")
0x00007784  mov      x0, x19
0x00007788  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x0000778c  mov      x29, x29
0x00007790  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007794  mov      x24, x0
0x00007798  mov      x0, x22
0x0000779c  bl       #0xd4b8 ; call stub:_objc_release
0x000077a0  mov      x0, x21
0x000077a4  bl       #0xd4b8 ; call stub:_objc_release
0x000077a8  ldr      x0, [x20, #0x570] ; -> [__DATA,__bss+0x70]
0x000077ac  mov      x2, x24
0x000077b0  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x000077b4  mov      x29, x29
0x000077b8  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000077bc  mov      x26, x0
0x000077c0  ldr      x28, [sp, #0x30]
0x000077c4  cbz      x0, #0x77d8
0x000077c8  mov      x0, x26
0x000077cc  bl       #0xd4c4 ; call stub:_objc_retain
0x000077d0  mov      x25, x26
0x000077d4  b        #0x7860
0x000077d8  adrp     x8, #0x15000
0x000077dc  add      x8, x8, #0x988 ; -> CFSTR("total")
0x000077e0  adrp     x9, #0x15000
0x000077e4  add      x9, x9, #0x9a8 ; -> CFSTR("missing")
0x000077e8  adrp     x10, #0x16000
0x000077ec  add      x10, x10, #0xd48 ; -> __DATA_CONST,__objc_intobj+0x78 [NSNumber int=0]
0x000077f0  stp      x9, x10, [sp, #0x88]
0x000077f4  str      x8, [sp, #0x80]
0x000077f8  adrp     x8, #0x18000
0x000077fc  ldr      x0, [x8, #0x458] ; -> [classref(NSMutableArray)]
0x00007800  bl       #0xd740 ; call objc_stub[array]
0x00007804  mov      x29, x29
0x00007808  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000780c  mov      x19, x0
0x00007810  str      x0, [sp, #0x98]
0x00007814  adrp     x8, #0x18000
0x00007818  ldr      x0, [x8, #0x468] ; -> [classref(NSDictionary)]
0x0000781c  add      x2, sp, #0x90
0x00007820  add      x3, sp, #0x80
0x00007824  mov      w4, #2
0x00007828  bl       #0xdac0 ; call objc_stub[dictionaryWithObjects:forKeys:count:]
0x0000782c  mov      x29, x29
0x00007830  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007834  mov      x21, x0
0x00007838  bl       #0xde00 ; call objc_stub[mutableCopy]
0x0000783c  mov      x25, x0
0x00007840  ldr      x0, [x20, #0x570] ; -> [__DATA,__bss+0x70]
0x00007844  mov      x2, x25
0x00007848  mov      x3, x24
0x0000784c  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x00007850  mov      x0, x21
0x00007854  bl       #0xd4b8 ; call stub:_objc_release
0x00007858  mov      x0, x19
0x0000785c  bl       #0xd4b8 ; call stub:_objc_release
0x00007860  mov      x0, x26
0x00007864  bl       #0xd4b8 ; call stub:_objc_release
0x00007868  adrp     x3, #0x15000
0x0000786c  add      x3, x3, #0x9c8 ; -> CFSTR("ios")
0x00007870  mov      x0, x25
0x00007874  mov      x2, x23
0x00007878  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000787c  adrp     x8, #0x18000
0x00007880  ldr      x19, [x8, #0x448] ; -> [classref(NSNumber)]
0x00007884  adrp     x21, #0x15000
0x00007888  add      x21, x21, #0x988 ; -> CFSTR("total")
0x0000788c  mov      x0, x25
0x00007890  mov      x2, x21
0x00007894  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x00007898  mov      x29, x29
0x0000789c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000078a0  mov      x22, x0
0x000078a4  bl       #0xe540 ; call objc_stub[unsignedIntegerValue]
0x000078a8  mov      x26, x0
0x000078ac  ldr      x0, [sp, #0x38]
0x000078b0  bl       #0xd960 ; call objc_stub[count]
0x000078b4  add      x2, x0, x26
0x000078b8  mov      x0, x19
0x000078bc  bl       #0xdf00 ; call objc_stub[numberWithUnsignedInteger:]
0x000078c0  mov      x29, x29
0x000078c4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x000078c8  mov      x19, x0
0x000078cc  mov      x0, x25
0x000078d0  mov      x2, x19
0x000078d4  mov      x3, x21
0x000078d8  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x000078dc  mov      x0, x19
0x000078e0  bl       #0xd4b8 ; call stub:_objc_release
0x000078e4  mov      x0, x22
0x000078e8  bl       #0xd4b8 ; call stub:_objc_release
0x000078ec  adrp     x2, #0x15000
0x000078f0  add      x2, x2, #0x9a8 ; -> CFSTR("missing")
0x000078f4  mov      x0, x25
0x000078f8  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x000078fc  mov      x29, x29
0x00007900  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007904  mov      x19, x0
0x00007908  mov      x2, x28
0x0000790c  bl       #0xd6c0 ; call objc_stub[addObjectsFromArray:]
0x00007910  mov      x0, x19
0x00007914  bl       #0xd4b8 ; call stub:_objc_release
0x00007918  adrp     x19, #0x14000
0x0000791c  add      x19, x19, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x00007920  mov      x0, x24
0x00007924  mov      x1, x25
0x00007928  mov      x2, x19
0x0000792c  bl       #0xd0f8 ; call stub:_CFPreferencesSetAppValue
0x00007930  mov      x0, x19
0x00007934  bl       #0xd0e0 ; call stub:_CFPreferencesAppSynchronize
0x00007938  ldr      x20, [sp, #0x28]
0x0000793c  mov      x0, x20
0x00007940  bl       #0xd960 ; call objc_stub[count]
0x00007944  adrp     x26, #0x18000
0x00007948  cbz      x0, #0x79c0
0x0000794c  ldr      x19, [x26, #0x3f0] ; -> [classref(NSString)]
0x00007950  mov      x0, x20
0x00007954  bl       #0xd740 ; call objc_stub[array]
0x00007958  mov      x29, x29
0x0000795c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007960  mov      x21, x0
0x00007964  adrp     x2, #0x14000
0x00007968  add      x2, x2, #0xa68 ; -> CFSTR(", ")
0x0000796c  bl       #0xd880 ; call objc_stub[componentsJoinedByString:]
0x00007970  mov      x29, x29
0x00007974  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007978  mov      x22, x0
0x0000797c  stp      x23, x0, [sp]
0x00007980  adrp     x2, #0x15000
0x00007984  add      x2, x2, #0x9e8 ; -> CFSTR("iOS %@: lop CarPlay %@")
0x00007988  mov      x0, x19
0x0000798c  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00007990  mov      x29, x29
0x00007994  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007998  mov      x19, x0
0x0000799c  mov      x0, x27
0x000079a0  mov      x1, x19
0x000079a4  bl       #0x6be4 ; call _OMCLogWrite
0x000079a8  mov      x0, x19
0x000079ac  bl       #0xd4b8 ; call stub:_objc_release
0x000079b0  mov      x0, x22
0x000079b4  bl       #0xd4b8 ; call stub:_objc_release
0x000079b8  mov      x0, x21
0x000079bc  bl       #0xd4b8 ; call stub:_objc_release
0x000079c0  mov      x0, x28
0x000079c4  bl       #0xd960 ; call objc_stub[count]
0x000079c8  ldr      x19, [x26, #0x3f0] ; -> [classref(NSString)]
0x000079cc  cbz      x0, #0x7a44
0x000079d0  mov      x0, x28
0x000079d4  bl       #0xd960 ; call objc_stub[count]
0x000079d8  mov      x21, x0
0x000079dc  ldr      x20, [sp, #0x38]
0x000079e0  mov      x0, x20
0x000079e4  bl       #0xd960 ; call objc_stub[count]
0x000079e8  mov      x22, x0
0x000079ec  adrp     x2, #0x14000
0x000079f0  add      x2, x2, #0xa68 ; -> CFSTR(", ")
0x000079f4  mov      x0, x28
0x000079f8  bl       #0xd880 ; call objc_stub[componentsJoinedByString:]
0x000079fc  mov      x29, x29
0x00007a00  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007a04  mov      x26, x0
0x00007a08  stp      x22, x0, [sp, #0x10]
0x00007a0c  stp      x23, x21, [sp]
0x00007a10  adrp     x2, #0x15000
0x00007a14  add      x2, x2, #0xa08 ; -> CFSTR("iOS %@: %lu/%lu hook KHONG co tren iOS nay (tinh nang lien quan se khong chay): %@")
0x00007a18  mov      x0, x19
0x00007a1c  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00007a20  mov      x29, x29
0x00007a24  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007a28  mov      x19, x0
0x00007a2c  mov      x0, x27
0x00007a30  mov      x1, x19
0x00007a34  bl       #0x6be4 ; call _OMCLogWrite
0x00007a38  mov      x0, x19
0x00007a3c  bl       #0xd4b8 ; call stub:_objc_release
0x00007a40  b        #0x7a7c
0x00007a44  ldr      x20, [sp, #0x38]
0x00007a48  mov      x0, x20
0x00007a4c  bl       #0xd960 ; call objc_stub[count]
0x00007a50  stp      x23, x0, [sp]
0x00007a54  adrp     x2, #0x15000
0x00007a58  add      x2, x2, #0xa28 ; -> CFSTR("iOS %@: du %lu hook")
0x00007a5c  mov      x0, x19
0x00007a60  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00007a64  mov      x29, x29
0x00007a68  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007a6c  mov      x26, x0
0x00007a70  mov      x0, x27
0x00007a74  mov      x1, x26
0x00007a78  bl       #0x6be4 ; call _OMCLogWrite
0x00007a7c  mov      x0, x26
0x00007a80  bl       #0xd4b8 ; call stub:_objc_release
0x00007a84  mov      x0, x25
0x00007a88  bl       #0xd4b8 ; call stub:_objc_release
0x00007a8c  mov      x0, x24
0x00007a90  bl       #0xd4b8 ; call stub:_objc_release
0x00007a94  mov      x0, x23
0x00007a98  bl       #0xd4b8 ; call stub:_objc_release
0x00007a9c  ldr      x0, [sp, #0x28]
0x00007aa0  bl       #0xd4b8 ; call stub:_objc_release
0x00007aa4  mov      x0, x28
0x00007aa8  bl       #0xd4b8 ; call stub:_objc_release
0x00007aac  mov      x0, x20
0x00007ab0  bl       #0xd4b8 ; call stub:_objc_release
0x00007ab4  mov      x0, x27
0x00007ab8  bl       #0xd4b8 ; call stub:_objc_release
0x00007abc  ldur     x8, [x29, #-0x60]
0x00007ac0  adrp     x9, #0x14000
0x00007ac4  ldr      x9, [x9, #0x1c0] ; -> [got(___stack_chk_guard)]
0x00007ac8  ldr      x9, [x9] ; -> [got(___objc_personality_v0)]
0x00007acc  cmp      x9, x8
0x00007ad0  b.ne     #0x7af4
0x00007ad4  ldp      x29, x30, [sp, #0x180]
0x00007ad8  ldp      x20, x19, [sp, #0x170]
0x00007adc  ldp      x22, x21, [sp, #0x160]
0x00007ae0  ldp      x24, x23, [sp, #0x150]
0x00007ae4  ldp      x26, x25, [sp, #0x140]
0x00007ae8  ldp      x28, x27, [sp, #0x130]
0x00007aec  add      sp, sp, #0x190
0x00007af0  ret      
0x00007af4  bl       #0xd1b8 ; call stub:___stack_chk_fail
