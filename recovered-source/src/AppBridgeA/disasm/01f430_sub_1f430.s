; ==== sub_1f430 @ 0x1f430..0x1ff5c (2860 bytes) ====
0x0001f430  b        #0x1f44c   ; call sub_1f44c
0x0001f434  mov      x0, x25
0x0001f438  mov      w2, #8
0x0001f43c  bl       #0x27da0   ; objc_msgSend: substringFromIndex:
0x0001f440  mov      x29, x29
0x0001f444  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f448  mov      x26, x0
0x0001f44c  add      x22, x22, #1
0x0001f450  cmp      x24, x22
0x0001f454  b.ne     #0x1f364
0x0001f458  add      x2, sp, #0x80
0x0001f45c  add      x3, sp, #0x1d0
0x0001f460  mov      x0, x20
0x0001f464  mov      w4, #0x10
0x0001f468  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001f46c  mov      x24, x0
0x0001f470  cbnz     x0, #0x1f360
0x0001f474  mov      x0, x20
0x0001f478  bl       #0x2480c   ; call _objc_release
0x0001f47c  ldp      x22, x23, [sp, #0x58]
0x0001f480  adrp     x24, #0x38000
0x0001f484  add      x24, x24, #0x30   ; -> @"omc-crash "
0x0001f488  ldr      x25, [sp, #0x70]
0x0001f48c  add      x25, x25, #1
0x0001f490  cmp      x25, x23
0x0001f494  b.ne     #0x1f2e4
0x0001f498  add      x2, sp, #0xc0
0x0001f49c  add      x3, sp, #0x250
0x0001f4a0  ldr      x0, [sp, #0x68]
0x0001f4a4  mov      w4, #0x10
0x0001f4a8  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001f4ac  mov      x23, x0
0x0001f4b0  cbnz     x0, #0x1f2dc
0x0001f4b4  b        #0x1f4c4   ; call sub_1f4c4
0x0001f4b8  mov      x26, #0
0x0001f4bc  str      xzr, [sp, #0x78]
0x0001f4c0  mov      x27, #0x7fffffffffffffff
0x0001f4c4  ldr      x0, [sp, #0x68]
0x0001f4c8  bl       #0x2480c   ; call _objc_release
0x0001f4cc  cmp      x26, #0
0x0001f4d0  ldr      x8, [sp, #0x78]
0x0001f4d4  csel     x20, x8, x26, eq
0x0001f4d8  mov      x0, x20
0x0001f4dc  bl       #0x24818   ; call _objc_retain
0x0001f4e0  mov      x0, x20
0x0001f4e4  bl       #0x25fa0   ; objc_msgSend: length
0x0001f4e8  cbz      x0, #0x1f560
0x0001f4ec  mov      x0, x20
0x0001f4f0  mov      w2, #1
0x0001f4f4  bl       #0x27dc0   ; objc_msgSend: substringToIndex:
0x0001f4f8  mov      x29, x29
0x0001f4fc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f500  mov      x21, x0
0x0001f504  bl       #0x26060   ; objc_msgSend: lowercaseString
0x0001f508  mov      x29, x29
0x0001f50c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f510  mov      x22, x0
0x0001f514  mov      x0, x20
0x0001f518  mov      w2, #1
0x0001f51c  bl       #0x27da0   ; objc_msgSend: substringFromIndex:
0x0001f520  mov      x29, x29
0x0001f524  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f528  mov      x23, x0
0x0001f52c  mov      x0, x22
0x0001f530  mov      x2, x23
0x0001f534  bl       #0x27c80   ; objc_msgSend: stringByAppendingString:
0x0001f538  mov      x29, x29
0x0001f53c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f540  mov      x19, x0
0x0001f544  mov      x0, x23
0x0001f548  bl       #0x2480c   ; call _objc_release
0x0001f54c  mov      x0, x22
0x0001f550  bl       #0x2480c   ; call _objc_release
0x0001f554  mov      x0, x21
0x0001f558  bl       #0x2480c   ; call _objc_release
0x0001f55c  b        #0x1f564   ; call sub_1f564
0x0001f560  mov      x19, #0
0x0001f564  mov      x0, x20
0x0001f568  bl       #0x2480c   ; call _objc_release
0x0001f56c  adrp     x8, #0x37000
0x0001f570  add      x8, x8, #0xf50   ; -> @"date"
0x0001f574  ldr      x22, [sp, #0x28]
0x0001f578  stp      x8, x22, [sp, #0x1c0]
0x0001f57c  adrp     x8, #0x3e000
0x0001f580  ldr      x0, [x8, #0x310]   ; -> [class(NSDictionary)]
0x0001f584  add      x2, sp, #0x1c8
0x0001f588  add      x3, sp, #0x1c0
0x0001f58c  mov      w4, #1
0x0001f590  bl       #0x255c0   ; objc_msgSend: dictionaryWithObjects:forKeys:count:
0x0001f594  mov      x29, x29
0x0001f598  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f59c  mov      x21, x0
0x0001f5a0  bl       #0x261e0   ; objc_msgSend: mutableCopy
0x0001f5a4  mov      x20, x0
0x0001f5a8  mov      x0, x21
0x0001f5ac  bl       #0x2480c   ; call _objc_release
0x0001f5b0  mov      x8, #0x7fffffffffffffff
0x0001f5b4  cmp      x27, x8
0x0001f5b8  b.eq     #0x1f5f4
0x0001f5bc  adrp     x8, #0x3e000
0x0001f5c0  ldr      x0, [x8, #0x2a0]   ; -> [class(NSNumber)]
0x0001f5c4  mov      x2, x27
0x0001f5c8  bl       #0x26360   ; objc_msgSend: numberWithLong:
0x0001f5cc  mov      x29, x29
0x0001f5d0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f5d4  mov      x21, x0
0x0001f5d8  adrp     x3, #0x38000
0x0001f5dc  add      x3, x3, #0xb0   ; -> @"age"
0x0001f5e0  mov      x0, x20
0x0001f5e4  mov      x2, x21
0x0001f5e8  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x0001f5ec  mov      x0, x21
0x0001f5f0  bl       #0x2480c   ; call _objc_release
0x0001f5f4  cbz      x19, #0x1f650
0x0001f5f8  adrp     x3, #0x38000
0x0001f5fc  add      x3, x3, #0xd0   ; -> @"suspect"
0x0001f600  mov      x0, x20
0x0001f604  mov      x2, x19
0x0001f608  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x0001f60c  adrp     x0, #0x38000
0x0001f610  add      x0, x0, #0xf0   ; -> @"diagLastCrash"
0x0001f614  adrp     x2, #0x37000
0x0001f618  add      x2, x2, #0x70   ; -> @"com.anlai.omnicar"
0x0001f61c  mov      x1, x20
0x0001f620  bl       #0x242cc   ; call _CFPreferencesSetAppValue
0x0001f624  cmp      x27, #0x3b
0x0001f628  ldr      x21, [sp, #0x38]
0x0001f62c  b.gt     #0x1fb88
0x0001f630  ldr      x0, [sp, #0x50]
0x0001f634  mov      x2, x19
0x0001f638  bl       #0x25360   ; objc_msgSend: containsObject:
0x0001f63c  tbnz     w0, #0, #0x1f66c
0x0001f640  ldr      x0, [sp, #0x50]
0x0001f644  mov      x2, x19
0x0001f648  bl       #0x24b20   ; objc_msgSend: addObject:
0x0001f64c  b        #0x1f66c   ; call sub_1f66c
0x0001f650  adrp     x0, #0x38000
0x0001f654  add      x0, x0, #0xf0   ; -> @"diagLastCrash"
0x0001f658  adrp     x2, #0x37000
0x0001f65c  add      x2, x2, #0x70   ; -> @"com.anlai.omnicar"
0x0001f660  mov      x1, x20
0x0001f664  bl       #0x242cc   ; call _CFPreferencesSetAppValue
0x0001f668  ldr      x21, [sp, #0x38]
0x0001f66c  mov      x0, x20
0x0001f670  bl       #0x2480c   ; call _objc_release
0x0001f674  mov      x0, x19
0x0001f678  bl       #0x2480c   ; call _objc_release
0x0001f67c  ldr      x0, [sp, #0x78]
0x0001f680  bl       #0x2480c   ; call _objc_release
0x0001f684  mov      x0, x26
0x0001f688  bl       #0x2480c   ; call _objc_release
0x0001f68c  mov      x0, x22
0x0001f690  bl       #0x2480c   ; call _objc_release
0x0001f694  cmp      x27, #0x3c
0x0001f698  ldr      x26, [sp, #0x30]
0x0001f69c  ldr      x27, [sp, #0x50]
0x0001f6a0  adrp     x20, #0x3e000
0x0001f6a4  b.ge     #0x1fbbc
0x0001f6a8  ldr      x8, [sp, #0x20]
0x0001f6ac  cmp      x8, #1
0x0001f6b0  b.lt     #0x20068
0x0001f6b4  adrp     x2, #0x37000
0x0001f6b8  add      x2, x2, #0xd90   ; -> @"features"
0x0001f6bc  mov      x0, x21
0x0001f6c0  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0001f6c4  mov      x29, x29
0x0001f6c8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f6cc  cmp      x0, #0
0x0001f6d0  adrp     x8, #0x34000
0x0001f6d4  ldr      x8, [x8, #0x1f0]   ; -> [got:___NSArray0__struct]
0x0001f6d8  str      x0, [sp, #0x78]
0x0001f6dc  csel     x24, x8, x0, eq
0x0001f6e0  mov      x0, x27
0x0001f6e4  bl       #0x24818   ; call _objc_retain
0x0001f6e8  mov      x0, x24
0x0001f6ec  bl       #0x24818   ; call _objc_retain
0x0001f6f0  adrp     x0, #0x37000
0x0001f6f4  add      x0, x0, #0x70   ; -> @"com.anlai.omnicar"
0x0001f6f8  bl       #0x242b4   ; call _CFPreferencesAppSynchronize
0x0001f6fc  adrp     x28, #0x3e000
0x0001f700  ldr      x0, [x28, #0x420]   ; -> [class(NSMutableOrderedSet)]
0x0001f704  bl       #0x26480   ; objc_msgSend: orderedSet
0x0001f708  mov      x29, x29
0x0001f70c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f710  mov      x23, x0
0x0001f714  movi     v0.16b, #0
0x0001f718  stp      q0, q0, [sp, #0x180]
0x0001f71c  stp      q0, q0, [sp, #0x1a0]
0x0001f720  mov      x0, x27
0x0001f724  bl       #0x24818   ; call _objc_retain
0x0001f728  add      x2, sp, #0x180
0x0001f72c  sub      x3, x29, #0xe0
0x0001f730  mov      x0, x27
0x0001f734  mov      w4, #0x10
0x0001f738  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001f73c  cbz      x0, #0x1f7b4
0x0001f740  mov      x19, x0
0x0001f744  ldr      x8, [sp, #0x190]
0x0001f748  ldr      x21, [x8]   ; -> [got:___objc_personality_v0]
0x0001f74c  mov      x22, #0
0x0001f750  ldr      x8, [sp, #0x190]
0x0001f754  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0001f758  cmp      x8, x21
0x0001f75c  b.eq     #0x1f768
0x0001f760  mov      x0, x27
0x0001f764  bl       #0x24770   ; call _objc_enumerationMutation
0x0001f768  ldr      x8, [sp, #0x188]
0x0001f76c  ldr      x20, [x8, x22, lsl #3]   ; -> [got:___objc_personality_v0]
0x0001f770  mov      x0, x24
0x0001f774  mov      x2, x20
0x0001f778  bl       #0x25360   ; objc_msgSend: containsObject:
0x0001f77c  cbz      w0, #0x1f78c
0x0001f780  mov      x0, x23
0x0001f784  mov      x2, x20
0x0001f788  bl       #0x24b20   ; objc_msgSend: addObject:
0x0001f78c  add      x22, x22, #1
0x0001f790  cmp      x19, x22
0x0001f794  b.ne     #0x1f750
0x0001f798  add      x2, sp, #0x180
0x0001f79c  sub      x3, x29, #0xe0
0x0001f7a0  mov      x0, x27
0x0001f7a4  mov      w4, #0x10
0x0001f7a8  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001f7ac  mov      x19, x0
0x0001f7b0  cbnz     x0, #0x1f74c
0x0001f7b4  mov      x0, x27
0x0001f7b8  bl       #0x2480c   ; call _objc_release
0x0001f7bc  mov      x0, x23
0x0001f7c0  bl       #0x25420   ; objc_msgSend: count
0x0001f7c4  mov      x25, x23
0x0001f7c8  cbnz     x0, #0x1f8d0
0x0001f7cc  movi     v0.16b, #0
0x0001f7d0  stp      q0, q0, [sp, #0x160]
0x0001f7d4  stp      q0, q0, [sp, #0x140]
0x0001f7d8  mov      x0, x24
0x0001f7dc  bl       #0x24818   ; call _objc_retain
0x0001f7e0  add      x2, sp, #0x140
0x0001f7e4  add      x3, sp, #0x370
0x0001f7e8  mov      x26, x24
0x0001f7ec  mov      x0, x24
0x0001f7f0  mov      w4, #0x10
0x0001f7f4  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001f7f8  cbz      x0, #0x1f8bc
0x0001f7fc  mov      x21, x0
0x0001f800  ldr      x8, [sp, #0x150]
0x0001f804  ldr      x24, [x8]   ; -> [got:___objc_personality_v0]
0x0001f808  adrp     x20, #0x34000
0x0001f80c  ldr      x20, [x20, #0x208]   ; -> [got:___kCFBooleanTrue]
0x0001f810  mov      x19, #0
0x0001f814  ldr      x8, [sp, #0x150]
0x0001f818  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0001f81c  cmp      x8, x24
0x0001f820  b.eq     #0x1f82c
0x0001f824  mov      x0, x26
0x0001f828  bl       #0x24770   ; call _objc_enumerationMutation
0x0001f82c  ldr      x8, [sp, #0x148]
0x0001f830  ldr      x22, [x8, x19, lsl #3]   ; -> [got:___objc_personality_v0]
0x0001f834  mov      x0, x22
0x0001f838  adrp     x2, #0x37000
0x0001f83c  add      x2, x2, #0x8f0   ; -> @"Enabled"
0x0001f840  bl       #0x27c80   ; objc_msgSend: stringByAppendingString:
0x0001f844  mov      x29, x29
0x0001f848  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f84c  mov      x23, x0
0x0001f850  mov      x1, x20
0x0001f854  bl       #0x1d680   ; call _OMCPref
0x0001f858  mov      x29, x29
0x0001f85c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f860  mov      x27, x0
0x0001f864  bl       #0x24f20   ; objc_msgSend: boolValue
0x0001f868  mov      x28, x0
0x0001f86c  mov      x0, x27
0x0001f870  bl       #0x2480c   ; call _objc_release
0x0001f874  mov      x0, x23
0x0001f878  bl       #0x2480c   ; call _objc_release
0x0001f87c  mov      x23, x25
0x0001f880  cbz      w28, #0x1f890
0x0001f884  mov      x0, x23
0x0001f888  mov      x2, x22
0x0001f88c  bl       #0x24b20   ; objc_msgSend: addObject:
0x0001f890  add      x19, x19, #1
0x0001f894  cmp      x21, x19
0x0001f898  ldr      x27, [sp, #0x50]
0x0001f89c  b.ne     #0x1f814
0x0001f8a0  add      x2, sp, #0x140
0x0001f8a4  add      x3, sp, #0x370
0x0001f8a8  mov      x0, x26
0x0001f8ac  mov      w4, #0x10
0x0001f8b0  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001f8b4  mov      x21, x0
0x0001f8b8  cbnz     x0, #0x1f810
0x0001f8bc  mov      x24, x26
0x0001f8c0  mov      x0, x26
0x0001f8c4  bl       #0x2480c   ; call _objc_release
0x0001f8c8  ldr      x26, [sp, #0x30]
0x0001f8cc  adrp     x28, #0x3e000
0x0001f8d0  mov      x0, x23
0x0001f8d4  bl       #0x25420   ; objc_msgSend: count
0x0001f8d8  cbz      x0, #0x1fb50
0x0001f8dc  str      x24, [sp, #0x70]
0x0001f8e0  adrp     x0, #0x37000
0x0001f8e4  add      x0, x0, #0xdb0   ; -> @"rescueFeatures"
0x0001f8e8  mov      x1, #0
0x0001f8ec  bl       #0x1d680   ; call _OMCPref
0x0001f8f0  mov      x29, x29
0x0001f8f4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f8f8  mov      x19, x0
0x0001f8fc  ldr      x20, [x28, #0x420]   ; -> [class(NSMutableOrderedSet)]
0x0001f900  adrp     x8, #0x3e000
0x0001f904  ldr      x0, [x8, #0x2a8]   ; -> [class(NSArray)]
0x0001f908  bl       #0x247d0   ; call _objc_opt_class
0x0001f90c  mov      x1, x0
0x0001f910  mov      x0, x19
0x0001f914  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0001f918  tst      w0, #1
0x0001f91c  adrp     x8, #0x34000
0x0001f920  ldr      x8, [x8, #0x1f0]   ; -> [got:___NSArray0__struct]
0x0001f924  str      x19, [sp, #0x68]
0x0001f928  csel     x2, x19, x8, ne
0x0001f92c  mov      x0, x20
0x0001f930  bl       #0x264a0   ; objc_msgSend: orderedSetWithArray:
0x0001f934  mov      x29, x29
0x0001f938  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f93c  mov      x20, x0
0x0001f940  movi     v0.16b, #0
0x0001f944  stp      q0, q0, [sp, #0x100]
0x0001f948  stp      q0, q0, [sp, #0x120]
0x0001f94c  mov      x0, x23
0x0001f950  bl       #0x24818   ; call _objc_retain
0x0001f954  add      x2, sp, #0x100
0x0001f958  add      x3, sp, #0x2f0
0x0001f95c  mov      x0, x23
0x0001f960  mov      w4, #0x10
0x0001f964  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001f968  cbz      x0, #0x1fa14
0x0001f96c  mov      x27, x0
0x0001f970  ldr      x8, [sp, #0x110]
0x0001f974  ldr      x19, [x8]   ; -> [got:___objc_personality_v0]
0x0001f978  adrp     x21, #0x37000
0x0001f97c  add      x21, x21, #0x8f0   ; -> @"Enabled"
0x0001f980  adrp     x22, #0x34000
0x0001f984  ldr      x22, [x22, #0x200]   ; -> [got:___kCFBooleanFalse]
0x0001f988  adrp     x23, #0x37000
0x0001f98c  add      x23, x23, #0x70   ; -> @"com.anlai.omnicar"
0x0001f990  mov      x26, #0
0x0001f994  ldr      x8, [sp, #0x110]
0x0001f998  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0001f99c  cmp      x8, x19
0x0001f9a0  b.eq     #0x1f9ac
0x0001f9a4  mov      x0, x25
0x0001f9a8  bl       #0x24770   ; call _objc_enumerationMutation
0x0001f9ac  ldr      x8, [sp, #0x108]
0x0001f9b0  ldr      x28, [x8, x26, lsl #3]   ; -> [got:___objc_personality_v0]
0x0001f9b4  mov      x0, x28
0x0001f9b8  mov      x2, x21
0x0001f9bc  bl       #0x27c80   ; objc_msgSend: stringByAppendingString:
0x0001f9c0  mov      x29, x29
0x0001f9c4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001f9c8  mov      x24, x0
0x0001f9cc  mov      x1, x22
0x0001f9d0  mov      x2, x23
0x0001f9d4  bl       #0x242cc   ; call _CFPreferencesSetAppValue
0x0001f9d8  mov      x0, x24
0x0001f9dc  bl       #0x2480c   ; call _objc_release
0x0001f9e0  mov      x0, x20
0x0001f9e4  mov      x2, x28
0x0001f9e8  bl       #0x24b20   ; objc_msgSend: addObject:
0x0001f9ec  add      x26, x26, #1
0x0001f9f0  cmp      x27, x26
0x0001f9f4  b.ne     #0x1f994
0x0001f9f8  add      x2, sp, #0x100
0x0001f9fc  add      x3, sp, #0x2f0
0x0001fa00  mov      x0, x25
0x0001fa04  mov      w4, #0x10
0x0001fa08  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001fa0c  mov      x27, x0
0x0001fa10  cbnz     x0, #0x1f990
0x0001fa14  mov      x0, x25
0x0001fa18  bl       #0x2480c   ; call _objc_release
0x0001fa1c  mov      x0, x20
0x0001fa20  bl       #0x24dc0   ; objc_msgSend: array
0x0001fa24  mov      x29, x29
0x0001fa28  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001fa2c  mov      x21, x0
0x0001fa30  adrp     x0, #0x37000
0x0001fa34  add      x0, x0, #0xdb0   ; -> @"rescueFeatures"
0x0001fa38  adrp     x22, #0x37000
0x0001fa3c  add      x22, x22, #0x70   ; -> @"com.anlai.omnicar"
0x0001fa40  mov      x1, x21
0x0001fa44  mov      x2, x22
0x0001fa48  bl       #0x242cc   ; call _CFPreferencesSetAppValue
0x0001fa4c  mov      x0, x21
0x0001fa50  bl       #0x2480c   ; call _objc_release
0x0001fa54  adrp     x8, #0x3e000
0x0001fa58  ldr      x0, [x8, #0x418]   ; -> [class(NSDate)]
0x0001fa5c  bl       #0x25480   ; objc_msgSend: date
0x0001fa60  mov      x29, x29
0x0001fa64  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001fa68  mov      x21, x0
0x0001fa6c  adrp     x0, #0x37000
0x0001fa70  add      x0, x0, #0xdf0   ; -> @"rescueDate"
0x0001fa74  mov      x1, x21
0x0001fa78  mov      x2, x22
0x0001fa7c  bl       #0x242cc   ; call _CFPreferencesSetAppValue
0x0001fa80  mov      x0, x21
0x0001fa84  bl       #0x2480c   ; call _objc_release
0x0001fa88  mov      x0, x22
0x0001fa8c  bl       #0x242b4   ; call _CFPreferencesAppSynchronize
0x0001fa90  adrp     x8, #0x3e000
0x0001fa94  ldr      x21, [x8, #0x290]   ; -> [class(NSString)]
0x0001fa98  mov      x0, x25
0x0001fa9c  bl       #0x24dc0   ; objc_msgSend: array
0x0001faa0  mov      x29, x29
0x0001faa4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001faa8  mov      x22, x0
0x0001faac  adrp     x2, #0x36000
0x0001fab0  add      x2, x2, #0x930   ; -> @", "
0x0001fab4  bl       #0x252a0   ; objc_msgSend: componentsJoinedByString:
0x0001fab8  mov      x29, x29
0x0001fabc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001fac0  mov      x23, x0
0x0001fac4  mov      w8, #0x3c
0x0001fac8  mov      w9, #2
0x0001facc  stp      x8, x0, [sp, #8]
0x0001fad0  str      x9, [sp]
0x0001fad4  adrp     x2, #0x38000
0x0001fad8  add      x2, x2, #0x170   ; -> @"CHE DO CUU: CarPlay sap %d lan lien trong %ds dau -> tat %@"
0x0001fadc  mov      x0, x21
0x0001fae0  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0001fae4  mov      x29, x29
0x0001fae8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001faec  mov      x21, x0
0x0001faf0  adrp     x0, #0x37000
0x0001faf4  add      x0, x0, #0xd50   ; -> @"Core"
0x0001faf8  mov      x1, x21
0x0001fafc  bl       #0x1dd30   ; call _OMCLogWrite
0x0001fb00  mov      x0, x21
0x0001fb04  bl       #0x2480c   ; call _objc_release
0x0001fb08  mov      x0, x23
0x0001fb0c  mov      x23, x25
0x0001fb10  bl       #0x2480c   ; call _objc_release
0x0001fb14  mov      x0, x22
0x0001fb18  bl       #0x2480c   ; call _objc_release
0x0001fb1c  adrp     x0, #0x2a000
0x0001fb20  add      x0, x0, #0xaf4   ; -> "com.anlai.omnicar/rescue"
0x0001fb24  bl       #0x246ec   ; call _notify_post
0x0001fb28  adrp     x0, #0x2a000
0x0001fb2c  add      x0, x0, #0xb0d   ; -> "com.anlai.omnicar/prefschanged"
0x0001fb30  bl       #0x246ec   ; call _notify_post
0x0001fb34  mov      x0, x20
0x0001fb38  bl       #0x2480c   ; call _objc_release
0x0001fb3c  ldr      x0, [sp, #0x68]
0x0001fb40  bl       #0x2480c   ; call _objc_release
0x0001fb44  ldr      x26, [sp, #0x30]
0x0001fb48  ldr      x27, [sp, #0x50]
0x0001fb4c  ldr      x24, [sp, #0x70]
0x0001fb50  mov      x0, x23
0x0001fb54  bl       #0x2480c   ; call _objc_release
0x0001fb58  mov      x0, x24
0x0001fb5c  bl       #0x2480c   ; call _objc_release
0x0001fb60  mov      x0, x27
0x0001fb64  bl       #0x2480c   ; call _objc_release
0x0001fb68  ldr      x0, [sp, #0x78]
0x0001fb6c  bl       #0x2480c   ; call _objc_release
0x0001fb70  mov      x0, x27
0x0001fb74  bl       #0x26800   ; objc_msgSend: removeAllObjects
0x0001fb78  mov      x19, #0
0x0001fb7c  ldr      x21, [sp, #0x38]
0x0001fb80  adrp     x20, #0x3e000
0x0001fb84  b        #0x1fbc8   ; call sub_1fbc8
0x0001fb88  mov      x0, x20
0x0001fb8c  bl       #0x2480c   ; call _objc_release
0x0001fb90  mov      x0, x19
0x0001fb94  bl       #0x2480c   ; call _objc_release
0x0001fb98  ldr      x0, [sp, #0x78]
0x0001fb9c  bl       #0x2480c   ; call _objc_release
0x0001fba0  mov      x0, x26
0x0001fba4  bl       #0x2480c   ; call _objc_release
0x0001fba8  mov      x0, x22
0x0001fbac  bl       #0x2480c   ; call _objc_release
0x0001fbb0  ldr      x26, [sp, #0x30]
0x0001fbb4  ldr      x27, [sp, #0x50]
0x0001fbb8  adrp     x20, #0x3e000
0x0001fbbc  mov      x0, x27
0x0001fbc0  bl       #0x26800   ; objc_msgSend: removeAllObjects
0x0001fbc4  mov      x19, #0
0x0001fbc8  ldr      x0, [x20, #0x2a0]   ; -> [class(NSNumber)]
0x0001fbcc  mov      x2, x19
0x0001fbd0  bl       #0x26340   ; objc_msgSend: numberWithInteger:
0x0001fbd4  mov      x29, x29
0x0001fbd8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001fbdc  mov      x19, x0
0x0001fbe0  adrp     x3, #0x37000
0x0001fbe4  add      x3, x3, #0xfd0   ; -> @"early"
0x0001fbe8  mov      x0, x21
0x0001fbec  mov      x2, x19
0x0001fbf0  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x0001fbf4  mov      x0, x19
0x0001fbf8  bl       #0x2480c   ; call _objc_release
0x0001fbfc  adrp     x3, #0x37000
0x0001fc00  add      x3, x3, #0xff0   ; -> @"suspects"
0x0001fc04  mov      x0, x21
0x0001fc08  mov      x2, x27
0x0001fc0c  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x0001fc10  bl       #0x20138   ; call sub_20138
0x0001fc14  mov      x29, x29
0x0001fc18  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001fc1c  mov      x19, x0
0x0001fc20  mov      x0, x21
0x0001fc24  mov      x2, x19
0x0001fc28  mov      w3, #1
0x0001fc2c  bl       #0x28240   ; objc_msgSend: writeToFile:atomically:
0x0001fc30  mov      x0, x19
0x0001fc34  bl       #0x2480c   ; call _objc_release
0x0001fc38  bl       #0x24404   ; call _NSGetUncaughtExceptionHandler
0x0001fc3c  adrp     x8, #0x3e000
0x0001fc40  str      x0, [x8, #0xb38]
0x0001fc44  adrp     x0, #0x20000
0x0001fc48  add      x0, x0, #0x4d4
0x0001fc4c  bl       #0x24428   ; call _NSSetUncaughtExceptionHandler
0x0001fc50  mov      x19, #0
0x0001fc54  adrp     x8, #0x20000
0x0001fc58  add      x8, x8, #0x734
0x0001fc5c  stur     x8, [x29, #-0xe0]
0x0001fc60  adrp     x8, #0x2b000
0x0001fc64  ldr      d0, [x8, #0x430]
0x0001fc68  stur     d0, [x29, #-0xd8]
0x0001fc6c  adrp     x20, #0x2b000
0x0001fc70  add      x20, x20, #0x448
0x0001fc74  ldr      w0, [x20, x19]
0x0001fc78  sub      x1, x29, #0xe0
0x0001fc7c  mov      x2, #0
0x0001fc80  bl       #0x24908   ; call _sigaction
0x0001fc84  add      x19, x19, #4
0x0001fc88  cmp      x19, #0x18
0x0001fc8c  b.ne     #0x1fc74
0x0001fc90  adrp     x22, #0x3e000
0x0001fc94  ldr      x0, [x22, #0x2b0]   ; -> [class(NSNotificationCenter)]
0x0001fc98  bl       #0x254c0   ; objc_msgSend: defaultCenter
0x0001fc9c  mov      x29, x29
0x0001fca0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001fca4  mov      x19, x0
0x0001fca8  adrp     x8, #0x34000
0x0001fcac  ldr      x8, [x8, #0x238]   ; -> [got:_UIScreenDidConnectNotification]
0x0001fcb0  ldr      x20, [x8]   ; -> [got:___objc_personality_v0]
0x0001fcb4  adrp     x23, #0x3e000
0x0001fcb8  ldr      x0, [x23, #0x288]   ; -> [class(NSOperationQueue)]
0x0001fcbc  bl       #0x260a0   ; objc_msgSend: mainQueue
0x0001fcc0  mov      x29, x29
0x0001fcc4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001fcc8  mov      x21, x0
0x0001fccc  adrp     x5, #0x34000
0x0001fcd0  add      x5, x5, #0xc70
0x0001fcd4  mov      x0, x19
0x0001fcd8  mov      x2, x20
0x0001fcdc  mov      x3, #0
0x0001fce0  mov      x4, x21
0x0001fce4  bl       #0x24b60   ; objc_msgSend: addObserverForName:object:queue:usingBlock:
0x0001fce8  mov      x29, x29
0x0001fcec  bl       #0x24890   ; call _objc_unsafeClaimAutoreleasedReturnValue
0x0001fcf0  mov      x0, x21
0x0001fcf4  bl       #0x2480c   ; call _objc_release
0x0001fcf8  mov      x0, x19
0x0001fcfc  bl       #0x2480c   ; call _objc_release
0x0001fd00  ldr      x0, [x22, #0x2b0]   ; -> [class(NSNotificationCenter)]
0x0001fd04  bl       #0x254c0   ; objc_msgSend: defaultCenter
0x0001fd08  mov      x29, x29
0x0001fd0c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001fd10  mov      x19, x0
0x0001fd14  adrp     x8, #0x34000
0x0001fd18  ldr      x8, [x8, #0x240]   ; -> [got:_UIScreenDidDisconnectNotification]
0x0001fd1c  ldr      x20, [x8]   ; -> [got:___objc_personality_v0]
0x0001fd20  ldr      x0, [x23, #0x288]   ; -> [class(NSOperationQueue)]
0x0001fd24  bl       #0x260a0   ; objc_msgSend: mainQueue
0x0001fd28  mov      x29, x29
0x0001fd2c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001fd30  mov      x21, x0
0x0001fd34  adrp     x5, #0x34000
0x0001fd38  add      x5, x5, #0xc90
0x0001fd3c  mov      x0, x19
0x0001fd40  mov      x2, x20
0x0001fd44  mov      x3, #0
0x0001fd48  mov      x4, x21
0x0001fd4c  bl       #0x24b60   ; objc_msgSend: addObserverForName:object:queue:usingBlock:
0x0001fd50  mov      x29, x29
0x0001fd54  bl       #0x24890   ; call _objc_unsafeClaimAutoreleasedReturnValue
0x0001fd58  mov      x0, x21
0x0001fd5c  bl       #0x2480c   ; call _objc_release
0x0001fd60  mov      x0, x19
0x0001fd64  bl       #0x2480c   ; call _objc_release
0x0001fd68  bl       #0x2095c   ; call sub_2095c
0x0001fd6c  ldr      x0, [sp, #0x40]
0x0001fd70  bl       #0x2480c   ; call _objc_release
0x0001fd74  mov      x0, x27
0x0001fd78  bl       #0x2480c   ; call _objc_release
0x0001fd7c  ldr      x0, [sp, #0x38]
0x0001fd80  bl       #0x2480c   ; call _objc_release
0x0001fd84  ldr      x0, [sp, #0x48]
0x0001fd88  bl       #0x2480c   ; call _objc_release
0x0001fd8c  adrp     x22, #0x3e000
0x0001fd90  adrp     x20, #0x3e000
0x0001fd94  ldr      x19, [x20, #0x398]   ; -> [class(NSMutableDictionary)]
0x0001fd98  bl       #0x20138   ; call sub_20138
0x0001fd9c  mov      x29, x29
0x0001fda0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001fda4  mov      x23, x20
0x0001fda8  mov      x20, x0
0x0001fdac  mov      x0, x19
0x0001fdb0  mov      x2, x20
0x0001fdb4  bl       #0x255a0   ; objc_msgSend: dictionaryWithContentsOfFile:
0x0001fdb8  mov      x29, x29
0x0001fdbc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001fdc0  mov      x21, x0
0x0001fdc4  cbz      x0, #0x1fdd8
0x0001fdc8  mov      x0, x21
0x0001fdcc  bl       #0x24818   ; call _objc_retain
0x0001fdd0  mov      x19, x21
0x0001fdd4  b        #0x1fdec   ; call sub_1fdec
0x0001fdd8  ldr      x0, [x23, #0x398]   ; -> [class(NSMutableDictionary)]
0x0001fddc  bl       #0x25580   ; objc_msgSend: dictionary
0x0001fde0  mov      x29, x29
0x0001fde4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001fde8  mov      x19, x0
0x0001fdec  mov      x0, x21
0x0001fdf0  bl       #0x2480c   ; call _objc_release
0x0001fdf4  mov      x0, x20
0x0001fdf8  bl       #0x2480c   ; call _objc_release
0x0001fdfc  adrp     x2, #0x37000
0x0001fe00  add      x2, x2, #0xd90   ; -> @"features"
0x0001fe04  mov      x0, x19
0x0001fe08  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0001fe0c  mov      x29, x29
0x0001fe10  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001fe14  mov      x21, x0
0x0001fe18  cmp      x0, #0
0x0001fe1c  adrp     x8, #0x34000
0x0001fe20  ldr      x8, [x8, #0x1f0]   ; -> [got:___NSArray0__struct]
0x0001fe24  csel     x20, x8, x0, eq
0x0001fe28  mov      x0, x20
0x0001fe2c  bl       #0x24818   ; call _objc_retain
0x0001fe30  mov      x0, x21
0x0001fe34  bl       #0x2480c   ; call _objc_release
0x0001fe38  mov      x0, x20
0x0001fe3c  mov      x2, x26
0x0001fe40  bl       #0x25360   ; objc_msgSend: containsObject:
0x0001fe44  tbnz     w0, #0, #0x1fea4
0x0001fe48  mov      x0, x20
0x0001fe4c  mov      x2, x26
0x0001fe50  bl       #0x24de0   ; objc_msgSend: arrayByAddingObject:
0x0001fe54  mov      x29, x29
0x0001fe58  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001fe5c  mov      x21, x0
0x0001fe60  adrp     x3, #0x37000
0x0001fe64  add      x3, x3, #0xd90   ; -> @"features"
0x0001fe68  mov      x0, x19
0x0001fe6c  mov      x2, x21
0x0001fe70  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x0001fe74  mov      x0, x21
0x0001fe78  bl       #0x2480c   ; call _objc_release
0x0001fe7c  bl       #0x20138   ; call sub_20138
0x0001fe80  mov      x29, x29
0x0001fe84  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001fe88  mov      x21, x0
0x0001fe8c  mov      x0, x19
0x0001fe90  mov      x2, x21
0x0001fe94  mov      w3, #1
0x0001fe98  bl       #0x28240   ; objc_msgSend: writeToFile:atomically:
0x0001fe9c  mov      x0, x21
0x0001fea0  bl       #0x2480c   ; call _objc_release
0x0001fea4  adrp     x0, #0x37000
0x0001fea8  add      x0, x0, #0x70   ; -> @"com.anlai.omnicar"
0x0001feac  bl       #0x242b4   ; call _CFPreferencesAppSynchronize
0x0001feb0  adrp     x0, #0x37000
0x0001feb4  add      x0, x0, #0xdb0   ; -> @"rescueFeatures"
0x0001feb8  mov      x1, #0
0x0001febc  bl       #0x1d680   ; call _OMCPref
0x0001fec0  mov      x29, x29
0x0001fec4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001fec8  mov      x21, x0
0x0001fecc  ldr      x0, [x22, #0x2a8]   ; -> [class(NSArray)]
0x0001fed0  bl       #0x247d0   ; call _objc_opt_class
0x0001fed4  mov      x1, x0
0x0001fed8  mov      x0, x21
0x0001fedc  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0001fee0  tbz      w0, #0, #0x1ffa0
0x0001fee4  mov      x0, x21
0x0001fee8  mov      x2, x26
0x0001feec  bl       #0x25360   ; objc_msgSend: containsObject:
0x0001fef0  cbz      w0, #0x1ffa0
0x0001fef4  adrp     x2, #0x37000
0x0001fef8  add      x2, x2, #0x8f0   ; -> @"Enabled"
0x0001fefc  mov      x0, x26
0x0001ff00  bl       #0x27c80   ; objc_msgSend: stringByAppendingString:
0x0001ff04  mov      x29, x29
0x0001ff08  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ff0c  mov      x23, x0
0x0001ff10  adrp     x1, #0x34000
0x0001ff14  ldr      x1, [x1, #0x208]   ; -> [got:___kCFBooleanTrue]
0x0001ff18  bl       #0x1d680   ; call _OMCPref
0x0001ff1c  mov      x29, x29
0x0001ff20  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ff24  mov      x24, x0
0x0001ff28  bl       #0x24f20   ; objc_msgSend: boolValue
0x0001ff2c  mov      x22, x0
0x0001ff30  mov      x0, x24
0x0001ff34  bl       #0x2480c   ; call _objc_release
0x0001ff38  mov      x0, x23
0x0001ff3c  bl       #0x2480c   ; call _objc_release
0x0001ff40  tbz      w22, #0, #0x1ffa8
0x0001ff44  mov      x0, x21
0x0001ff48  bl       #0x261e0   ; objc_msgSend: mutableCopy
0x0001ff4c  mov      x23, x0
0x0001ff50  mov      x2, x26
0x0001ff54  bl       #0x268a0   ; objc_msgSend: removeObject:
0x0001ff58  mov      x0, x23
