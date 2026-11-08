=== -[OMCRootListController specifiers]  va=0x155d0 size=144 types=@16@0:8
0x000155d0  stp      x22, x21, [sp, #-0x30]!
0x000155d4  stp      x20, x19, [sp, #0x10]
0x000155d8  stp      x29, x30, [sp, #0x20]
0x000155dc  add      x29, sp, #0x20
0x000155e0  adrp     x8, #0x74000
0x000155e4  ldr      x8, [x8, #0x368]   ; @GOT _OBJC_IVAR_$_PSListController._specifiers
0x000155e8  ldrsw    x21, [x8]   ; @GOT ___objc_personality_v0
0x000155ec  ldr      x20, [x0, x21]
0x000155f0  cbnz     x20, #0x15644
0x000155f4  mov      x19, x0
0x000155f8  bl       #0x17a44   ; CALL _OMCLoadStrings
0x000155fc  adrp     x2, #0x78000
0x00015600  add      x2, x2, #0x5e8   ; STR "Root"
0x00015604  mov      x0, x19
0x00015608  mov      x3, x19
0x0001560c  bl       #0x58d00   ; CALL objc_msgSend$loadSpecifiersFromPlistName:target:
0x00015610  mov      x29, x29
0x00015614  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015618  ldr      x8, [x19, x21]
0x0001561c  str      x0, [x19, x21]
0x00015620  mov      x0, x8
0x00015624  bl       #0x55d78   ; CALL _objc_release
0x00015628  mov      x0, x19
0x0001562c  bl       #0x58620   ; CALL objc_msgSend$insertFeatureSpecifiers
0x00015630  ldr      x0, [x19, x21]
0x00015634  bl       #0x18cb4   ; CALL _OMCLocalizeSpecifiers
0x00015638  mov      x0, x19
0x0001563c  bl       #0x56520   ; CALL objc_msgSend$applySupportState
0x00015640  ldr      x20, [x19, x21]
0x00015644  mov      x0, x20
0x00015648  bl       #0x55d84   ; CALL _objc_retain
0x0001564c  mov      x0, x20
0x00015650  ldp      x29, x30, [sp, #0x20]
0x00015654  ldp      x20, x19, [sp, #0x10]
0x00015658  ldp      x22, x21, [sp], #0x30
0x0001565c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCRootListController currentSupportState]  va=0x15660 size=524 types=@16@0:8
0x00015660  sub      sp, sp, #0x140
0x00015664  stp      x28, x27, [sp, #0xe0]
0x00015668  stp      x26, x25, [sp, #0xf0]
0x0001566c  stp      x24, x23, [sp, #0x100]
0x00015670  stp      x22, x21, [sp, #0x110]
0x00015674  stp      x20, x19, [sp, #0x120]
0x00015678  stp      x29, x30, [sp, #0x130]
0x0001567c  add      x29, sp, #0x130
0x00015680  adrp     x8, #0x74000
0x00015684  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00015688  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001568c  stur     x8, [x29, #-0x60]
0x00015690  adrp     x8, #0x8e000
0x00015694  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00015698  bl       #0x565c0   ; CALL objc_msgSend$array
0x0001569c  mov      x29, x29
0x000156a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000156a4  mov      x19, x0
0x000156a8  movi     v0.16b, #0
0x000156ac  stp      q0, q0, [sp, #0x10]
0x000156b0  stp      q0, q0, [sp, #0x30]
0x000156b4  bl       #0x6c70   ; CALL _OMCConflictingTweaks
0x000156b8  mov      x29, x29
0x000156bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000156c0  mov      x20, x0
0x000156c4  add      x2, sp, #0x10
0x000156c8  add      x3, sp, #0x50
0x000156cc  mov      w4, #0x10
0x000156d0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000156d4  cbz      x0, #0x15798
0x000156d8  mov      x23, x0
0x000156dc  ldr      x8, [sp, #0x20]
0x000156e0  ldr      x27, [x8]   ; @SEL "whatsNewNavigationController"
0x000156e4  adrp     x21, #0x75000
0x000156e8  add      x21, x21, #0x428   ; STR "active"
0x000156ec  adrp     x22, #0x75000
0x000156f0  add      x22, x22, #0x1e8   ; STR "name"
0x000156f4  mov      x28, #0
0x000156f8  ldr      x8, [sp, #0x20]
0x000156fc  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00015700  cmp      x8, x27
0x00015704  b.eq     #0x15710
0x00015708  mov      x0, x20
0x0001570c  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00015710  ldr      x8, [sp, #0x18]
0x00015714  ldr      x24, [x8, x28, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00015718  mov      x0, x24
0x0001571c  mov      x2, x21
0x00015720  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00015724  mov      x29, x29
0x00015728  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001572c  mov      x25, x0
0x00015730  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00015734  mov      x26, x0
0x00015738  mov      x0, x25
0x0001573c  bl       #0x55d78   ; CALL _objc_release
0x00015740  cbz      w26, #0x15770
0x00015744  mov      x0, x24
0x00015748  mov      x2, x22
0x0001574c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00015750  mov      x29, x29
0x00015754  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015758  mov      x24, x0
0x0001575c  mov      x0, x19
0x00015760  mov      x2, x24
0x00015764  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00015768  mov      x0, x24
0x0001576c  bl       #0x55d78   ; CALL _objc_release
0x00015770  add      x28, x28, #1
0x00015774  cmp      x23, x28
0x00015778  b.ne     #0x156f8
0x0001577c  add      x2, sp, #0x10
0x00015780  add      x3, sp, #0x50
0x00015784  mov      x0, x20
0x00015788  mov      w4, #0x10
0x0001578c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00015790  mov      x23, x0
0x00015794  cbnz     x0, #0x156f4
0x00015798  mov      x0, x20
0x0001579c  bl       #0x55d78   ; CALL _objc_release
0x000157a0  adrp     x8, #0x8e000
0x000157a4  ldr      x20, [x8, #0x958]   ; @CLASS NSString
0x000157a8  bl       #0x78e8   ; CALL _OMCRescueFeatures
0x000157ac  mov      x29, x29
0x000157b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000157b4  mov      x21, x0
0x000157b8  adrp     x2, #0x78000
0x000157bc  add      x2, x2, #0x628   ; STR ","
0x000157c0  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x000157c4  mov      x29, x29
0x000157c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000157cc  mov      x22, x0
0x000157d0  adrp     x2, #0x75000
0x000157d4  add      x2, x2, #0xb28   ; STR ", "
0x000157d8  mov      x0, x19
0x000157dc  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x000157e0  mov      x29, x29
0x000157e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000157e8  mov      x23, x0
0x000157ec  stp      x22, x0, [sp]
0x000157f0  adrp     x2, #0x78000
0x000157f4  add      x2, x2, #0x608   ; STR "%@|%@"
0x000157f8  mov      x0, x20
0x000157fc  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00015800  mov      x29, x29
0x00015804  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015808  mov      x20, x0
0x0001580c  mov      x0, x23
0x00015810  bl       #0x55d78   ; CALL _objc_release
0x00015814  mov      x0, x22
0x00015818  bl       #0x55d78   ; CALL _objc_release
0x0001581c  mov      x0, x21
0x00015820  bl       #0x55d78   ; CALL _objc_release
0x00015824  mov      x0, x19
0x00015828  bl       #0x55d78   ; CALL _objc_release
0x0001582c  ldur     x8, [x29, #-0x60]
0x00015830  adrp     x9, #0x74000
0x00015834  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00015838  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0001583c  cmp      x9, x8
0x00015840  b.ne     #0x15868
0x00015844  mov      x0, x20
0x00015848  ldp      x29, x30, [sp, #0x130]
0x0001584c  ldp      x20, x19, [sp, #0x120]
0x00015850  ldp      x22, x21, [sp, #0x110]
0x00015854  ldp      x24, x23, [sp, #0x100]
0x00015858  ldp      x26, x25, [sp, #0xf0]
0x0001585c  ldp      x28, x27, [sp, #0xe0]
0x00015860  add      sp, sp, #0x140
0x00015864  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00015868  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCRootListController applySupportState]  va=0x1586c size=1228 types=v16@0:8
0x0001586c  stp      x28, x27, [sp, #-0x60]!
0x00015870  stp      x26, x25, [sp, #0x10]
0x00015874  stp      x24, x23, [sp, #0x20]
0x00015878  stp      x22, x21, [sp, #0x30]
0x0001587c  stp      x20, x19, [sp, #0x40]
0x00015880  stp      x29, x30, [sp, #0x50]
0x00015884  add      x29, sp, #0x50
0x00015888  sub      sp, sp, #0x1d0
0x0001588c  mov      x20, x0
0x00015890  adrp     x8, #0x74000
0x00015894  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00015898  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001589c  stur     x8, [x29, #-0x60]
0x000158a0  bl       #0x57500   ; CALL objc_msgSend$currentSupportState
0x000158a4  mov      x29, x29
0x000158a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000158ac  mov      x19, x0
0x000158b0  mov      x0, x20
0x000158b4  mov      x2, x19
0x000158b8  bl       #0x5c440   ; CALL objc_msgSend$setSupportState:
0x000158bc  mov      x0, x19
0x000158c0  bl       #0x55d78   ; CALL _objc_release
0x000158c4  str      x20, [sp, #0x20]
0x000158c8  mov      x0, x20
0x000158cc  bl       #0x5d760   ; CALL objc_msgSend$supportState
0x000158d0  mov      x29, x29
0x000158d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000158d8  mov      x19, x0
0x000158dc  adrp     x2, #0x78000
0x000158e0  add      x2, x2, #0x648   ; STR "|"
0x000158e4  bl       #0x57040   ; CALL objc_msgSend$componentsSeparatedByString:
0x000158e8  mov      x29, x29
0x000158ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000158f0  mov      x20, x0
0x000158f4  mov      x0, x19
0x000158f8  bl       #0x55d78   ; CALL _objc_release
0x000158fc  mov      x0, x20
0x00015900  mov      x2, #0
0x00015904  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00015908  mov      x29, x29
0x0001590c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015910  mov      x19, x0
0x00015914  str      x20, [sp, #0x10]
0x00015918  mov      x0, x20
0x0001591c  mov      w2, #1
0x00015920  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00015924  mov      x29, x29
0x00015928  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001592c  str      x0, [sp, #0x30]
0x00015930  adrp     x8, #0x8e000
0x00015934  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00015938  bl       #0x565c0   ; CALL objc_msgSend$array
0x0001593c  mov      x29, x29
0x00015940  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015944  mov      x23, x0
0x00015948  movi     v0.16b, #0
0x0001594c  stp      q0, q0, [sp, #0x80]
0x00015950  stp      q0, q0, [sp, #0xa0]
0x00015954  mov      x0, x19
0x00015958  bl       #0x58c20   ; CALL objc_msgSend$length
0x0001595c  str      x19, [sp, #8]
0x00015960  cbz      x0, #0x15984
0x00015964  adrp     x2, #0x78000
0x00015968  add      x2, x2, #0x628   ; STR ","
0x0001596c  mov      x0, x19
0x00015970  bl       #0x57040   ; CALL objc_msgSend$componentsSeparatedByString:
0x00015974  mov      x29, x29
0x00015978  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001597c  mov      x19, x0
0x00015980  b        #0x1598c
0x00015984  adrp     x19, #0x74000
0x00015988  ldr      x19, [x19, #0x1a0]   ; @GOT ___NSArray0__struct
0x0001598c  add      x2, sp, #0x80
0x00015990  sub      x3, x29, #0xe0
0x00015994  mov      x0, x19
0x00015998  mov      w4, #0x10
0x0001599c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000159a0  cbz      x0, #0x15a20
0x000159a4  mov      x20, x0
0x000159a8  ldr      x8, [sp, #0x90]
0x000159ac  ldr      x22, [x8]   ; @SEL "whatsNewNavigationController"
0x000159b0  mov      x24, #0
0x000159b4  ldr      x8, [sp, #0x90]
0x000159b8  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x000159bc  cmp      x8, x22
0x000159c0  b.eq     #0x159cc
0x000159c4  mov      x0, x19
0x000159c8  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x000159cc  ldr      x8, [sp, #0x88]
0x000159d0  ldr      x0, [x8, x24, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x000159d4  bl       #0x6804   ; CALL _OMCFeatureDisplayName
0x000159d8  mov      x29, x29
0x000159dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000159e0  mov      x21, x0
0x000159e4  mov      x0, x23
0x000159e8  mov      x2, x21
0x000159ec  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x000159f0  mov      x0, x21
0x000159f4  bl       #0x55d78   ; CALL _objc_release
0x000159f8  add      x24, x24, #1
0x000159fc  cmp      x20, x24
0x00015a00  b.ne     #0x159b4
0x00015a04  add      x2, sp, #0x80
0x00015a08  sub      x3, x29, #0xe0
0x00015a0c  mov      x0, x19
0x00015a10  mov      w4, #0x10
0x00015a14  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00015a18  mov      x20, x0
0x00015a1c  cbnz     x0, #0x159b0
0x00015a20  mov      x0, x19
0x00015a24  bl       #0x55d78   ; CALL _objc_release
0x00015a28  movi     v0.16b, #0
0x00015a2c  stp      q0, q0, [sp, #0x60]
0x00015a30  stp      q0, q0, [sp, #0x40]
0x00015a34  adrp     x8, #0x74000
0x00015a38  ldr      x8, [x8, #0x368]   ; @GOT _OBJC_IVAR_$_PSListController._specifiers
0x00015a3c  ldrsw    x9, [x8]   ; @GOT ___objc_personality_v0
0x00015a40  ldr      x8, [sp, #0x20]
0x00015a44  str      x9, [sp, #0x18]
0x00015a48  ldr      x0, [x8, x9]   ; @GOT ___objc_personality_v0
0x00015a4c  bl       #0x572e0   ; CALL objc_msgSend$copy
0x00015a50  mov      x28, x0
0x00015a54  add      x2, sp, #0x40
0x00015a58  add      x3, sp, #0xc0
0x00015a5c  mov      w4, #0x10
0x00015a60  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00015a64  cbz      x0, #0x15cd4
0x00015a68  mov      x26, x0
0x00015a6c  adrp     x25, #0x78000
0x00015a70  add      x25, x25, #0x668   ; STR "omcGroup"
0x00015a74  ldr      x8, [sp, #0x50]
0x00015a78  adrp     x27, #0x76000
0x00015a7c  add      x27, x27, #0x828   ; STR "rescue"
0x00015a80  ldr      x21, [x8]   ; @GOT ___objc_personality_v0
0x00015a84  str      x21, [sp, #0x38]
0x00015a88  mov      x24, #0
0x00015a8c  str      x26, [sp, #0x28]
0x00015a90  ldr      x8, [sp, #0x50]
0x00015a94  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00015a98  cmp      x8, x21
0x00015a9c  b.eq     #0x15aa8
0x00015aa0  mov      x0, x28
0x00015aa4  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00015aa8  ldr      x8, [sp, #0x48]
0x00015aac  ldr      x20, [x8, x24, lsl #3]   ; @GOT ___objc_personality_v0
0x00015ab0  mov      x0, x20
0x00015ab4  mov      x2, x25
0x00015ab8  bl       #0x59aa0   ; CALL objc_msgSend$propertyForKey:
0x00015abc  mov      x29, x29
0x00015ac0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015ac4  mov      x19, x0
0x00015ac8  cbz      x0, #0x15c5c
0x00015acc  mov      x0, x19
0x00015ad0  mov      x2, x27
0x00015ad4  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00015ad8  cbz      w0, #0x15ae8
0x00015adc  mov      x0, x23
0x00015ae0  bl       #0x573c0   ; CALL objc_msgSend$count
0x00015ae4  cbz      x0, #0x15be0
0x00015ae8  mov      x0, x19
0x00015aec  adrp     x2, #0x78000
0x00015af0  add      x2, x2, #0x688   ; STR "conflicts"
0x00015af4  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00015af8  cbz      w0, #0x15b08
0x00015afc  ldr      x0, [sp, #0x30]
0x00015b00  bl       #0x58c20   ; CALL objc_msgSend$length
0x00015b04  cbz      x0, #0x15be0
0x00015b08  mov      x0, x20
0x00015b0c  bl       #0x58060   ; CALL objc_msgSend$identifier
0x00015b10  mov      x29, x29
0x00015b14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015b18  mov      x22, x0
0x00015b1c  adrp     x2, #0x78000
0x00015b20  add      x2, x2, #0x6a8   ; STR "rescueGroup"
0x00015b24  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00015b28  mov      x21, x0
0x00015b2c  mov      x0, x22
0x00015b30  bl       #0x55d78   ; CALL _objc_release
0x00015b34  cbz      w21, #0x15bf4
0x00015b38  adrp     x8, #0x8e000
0x00015b3c  ldr      x21, [x8, #0x958]   ; @CLASS NSString
0x00015b40  adrp     x0, #0x78000
0x00015b44  add      x0, x0, #0x6c8   ; STR "RESCUE_FOOTER"
0x00015b48  bl       #0x17e20   ; CALL _L
0x00015b4c  mov      x29, x29
0x00015b50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015b54  mov      x22, x0
0x00015b58  mov      x0, x23
0x00015b5c  adrp     x2, #0x75000
0x00015b60  add      x2, x2, #0xb28   ; STR ", "
0x00015b64  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x00015b68  mov      x29, x29
0x00015b6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015b70  mov      x26, x27
0x00015b74  mov      x27, x23
0x00015b78  mov      x23, x25
0x00015b7c  mov      x25, x28
0x00015b80  mov      x28, x0
0x00015b84  str      x0, [sp]
0x00015b88  mov      x0, x21
0x00015b8c  mov      x2, x22
0x00015b90  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00015b94  mov      x29, x29
0x00015b98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015b9c  mov      x21, x0
0x00015ba0  mov      x0, x20
0x00015ba4  mov      x2, x21
0x00015ba8  adrp     x3, #0x78000
0x00015bac  add      x3, x3, #0x6e8   ; STR "footerText"
0x00015bb0  bl       #0x5bd60   ; CALL objc_msgSend$setProperty:forKey:
0x00015bb4  mov      x0, x21
0x00015bb8  bl       #0x55d78   ; CALL _objc_release
0x00015bbc  mov      x0, x28
0x00015bc0  mov      x28, x25
0x00015bc4  mov      x25, x23
0x00015bc8  mov      x23, x27
0x00015bcc  mov      x27, x26
0x00015bd0  ldr      x26, [sp, #0x28]
0x00015bd4  bl       #0x55d78   ; CALL _objc_release
0x00015bd8  mov      x0, x22
0x00015bdc  b        #0x15c54
0x00015be0  ldp      x9, x8, [sp, #0x18]
0x00015be4  ldr      x0, [x8, x9]   ; @SEL "whatsNewNavigationController"
0x00015be8  mov      x2, x20
0x00015bec  bl       #0x59e40   ; CALL objc_msgSend$removeObject:
0x00015bf0  b        #0x15c5c
0x00015bf4  mov      x0, x20
0x00015bf8  bl       #0x58060   ; CALL objc_msgSend$identifier
0x00015bfc  mov      x29, x29
0x00015c00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015c04  mov      x21, x0
0x00015c08  adrp     x2, #0x78000
0x00015c0c  add      x2, x2, #0x708   ; STR "conflictsGroup"
0x00015c10  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00015c14  mov      x22, x0
0x00015c18  mov      x0, x21
0x00015c1c  bl       #0x55d78   ; CALL _objc_release
0x00015c20  cbz      w22, #0x15c74
0x00015c24  adrp     x0, #0x76000
0x00015c28  add      x0, x0, #0x448   ; STR "CONFLICTS_FOOTER"
0x00015c2c  bl       #0x17e20   ; CALL _L
0x00015c30  mov      x29, x29
0x00015c34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015c38  mov      x21, x0
0x00015c3c  mov      x0, x20
0x00015c40  mov      x2, x21
0x00015c44  adrp     x3, #0x78000
0x00015c48  add      x3, x3, #0x6e8   ; STR "footerText"
0x00015c4c  bl       #0x5bd60   ; CALL objc_msgSend$setProperty:forKey:
0x00015c50  mov      x0, x21
0x00015c54  bl       #0x55d78   ; CALL _objc_release
0x00015c58  ldr      x21, [sp, #0x38]
0x00015c5c  mov      x0, x19
0x00015c60  bl       #0x55d78   ; CALL _objc_release
0x00015c64  add      x24, x24, #1
0x00015c68  cmp      x26, x24
0x00015c6c  b.ne     #0x15a90
0x00015c70  b        #0x15cb8
0x00015c74  mov      x0, x20
0x00015c78  bl       #0x58060   ; CALL objc_msgSend$identifier
0x00015c7c  mov      x29, x29
0x00015c80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015c84  mov      x21, x0
0x00015c88  adrp     x2, #0x78000
0x00015c8c  add      x2, x2, #0x728   ; STR "conflictsRow"
0x00015c90  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00015c94  mov      x22, x0
0x00015c98  mov      x0, x21
0x00015c9c  bl       #0x55d78   ; CALL _objc_release
0x00015ca0  ldr      x21, [sp, #0x38]
0x00015ca4  cbz      w22, #0x15c5c
0x00015ca8  mov      x0, x20
0x00015cac  ldr      x2, [sp, #0x30]
0x00015cb0  bl       #0x5b700   ; CALL objc_msgSend$setName:
0x00015cb4  b        #0x15c5c
0x00015cb8  add      x2, sp, #0x40
0x00015cbc  add      x3, sp, #0xc0
0x00015cc0  mov      x0, x28
0x00015cc4  mov      w4, #0x10
0x00015cc8  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00015ccc  mov      x26, x0
0x00015cd0  cbnz     x0, #0x15a88
0x00015cd4  mov      x0, x28
0x00015cd8  bl       #0x55d78   ; CALL _objc_release
0x00015cdc  mov      x0, x23
0x00015ce0  bl       #0x55d78   ; CALL _objc_release
0x00015ce4  ldr      x0, [sp, #0x30]
0x00015ce8  bl       #0x55d78   ; CALL _objc_release
0x00015cec  ldr      x0, [sp, #8]
0x00015cf0  bl       #0x55d78   ; CALL _objc_release
0x00015cf4  ldr      x0, [sp, #0x10]
0x00015cf8  bl       #0x55d78   ; CALL _objc_release
0x00015cfc  ldur     x8, [x29, #-0x60]
0x00015d00  adrp     x9, #0x74000
0x00015d04  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00015d08  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00015d0c  cmp      x9, x8
0x00015d10  b.ne     #0x15d34
0x00015d14  add      sp, sp, #0x1d0
0x00015d18  ldp      x29, x30, [sp, #0x50]
0x00015d1c  ldp      x20, x19, [sp, #0x40]
0x00015d20  ldp      x22, x21, [sp, #0x30]
0x00015d24  ldp      x24, x23, [sp, #0x20]
0x00015d28  ldp      x26, x25, [sp, #0x10]
0x00015d2c  ldp      x28, x27, [sp], #0x60
0x00015d30  ret      
0x00015d34  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCRootListController insertFeatureSpecifiers]  va=0x15d38 size=1844 types=v16@0:8
0x00015d38  stp      x28, x27, [sp, #-0x60]!
0x00015d3c  stp      x26, x25, [sp, #0x10]
0x00015d40  stp      x24, x23, [sp, #0x20]
0x00015d44  stp      x22, x21, [sp, #0x30]
0x00015d48  stp      x20, x19, [sp, #0x40]
0x00015d4c  stp      x29, x30, [sp, #0x50]
0x00015d50  add      x29, sp, #0x50
0x00015d54  sub      sp, sp, #0x2c0
0x00015d58  adrp     x8, #0x74000
0x00015d5c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00015d60  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00015d64  stur     x8, [x29, #-0x60]
0x00015d68  adrp     x8, #0x8e000
0x00015d6c  ldr      x19, [x8, #0x9d8]   ; @CLASS NSBundle
0x00015d70  str      x0, [sp, #0x28]
0x00015d74  bl       #0x55d48   ; CALL _objc_opt_class
0x00015d78  mov      x2, x0
0x00015d7c  mov      x0, x19
0x00015d80  bl       #0x56b40   ; CALL objc_msgSend$bundleForClass:
0x00015d84  mov      x29, x29
0x00015d88  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015d8c  mov      x19, x0
0x00015d90  adrp     x8, #0x8e000
0x00015d94  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00015d98  bl       #0x565c0   ; CALL objc_msgSend$array
0x00015d9c  mov      x29, x29
0x00015da0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015da4  stp      x19, x0, [sp, #8]
0x00015da8  movi     v0.16b, #0
0x00015dac  stp      q0, q0, [sp, #0xd0]
0x00015db0  stp      q0, q0, [sp, #0xf0]
0x00015db4  adrp     x2, #0x76000
0x00015db8  add      x2, x2, #0xf48   ; STR "plist"
0x00015dbc  mov      x0, x19
0x00015dc0  mov      x3, #0
0x00015dc4  bl       #0x59660   ; CALL objc_msgSend$pathsForResourcesOfType:inDirectory:
0x00015dc8  mov      x29, x29
0x00015dcc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015dd0  mov      x21, x0
0x00015dd4  add      x2, sp, #0xd0
0x00015dd8  sub      x3, x29, #0xe0
0x00015ddc  mov      w4, #0x10
0x00015de0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00015de4  cbz      x0, #0x15f20
0x00015de8  mov      x23, x0
0x00015dec  ldr      x8, [sp, #0xe0]
0x00015df0  adrp     x22, #0x76000
0x00015df4  add      x22, x22, #0xf68   ; STR "Feature"
0x00015df8  ldr      x27, [x8]   ; @SEL "whatsNewNavigationController"
0x00015dfc  adrp     x28, #0x8e000
0x00015e00  adrp     x24, #0x76000
0x00015e04  add      x24, x24, #0xf88   ; STR "featureLabel"
0x00015e08  mov      x20, #0
0x00015e0c  ldr      x8, [sp, #0xe0]
0x00015e10  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00015e14  cmp      x8, x27
0x00015e18  b.eq     #0x15e24
0x00015e1c  mov      x0, x21
0x00015e20  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00015e24  ldr      x8, [sp, #0xd8]
0x00015e28  ldr      x26, [x8, x20, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00015e2c  mov      x0, x26
0x00015e30  bl       #0x58a80   ; CALL objc_msgSend$lastPathComponent
0x00015e34  mov      x29, x29
0x00015e38  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015e3c  mov      x19, x0
0x00015e40  bl       #0x5d480   ; CALL objc_msgSend$stringByDeletingPathExtension
0x00015e44  mov      x29, x29
0x00015e48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015e4c  mov      x25, x0
0x00015e50  mov      x0, x19
0x00015e54  bl       #0x55d78   ; CALL _objc_release
0x00015e58  mov      x0, x25
0x00015e5c  mov      x2, x22
0x00015e60  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x00015e64  cbz      w0, #0x15ef0
0x00015e68  ldr      x0, [x28, #0x970]   ; @CLASS NSDictionary
0x00015e6c  mov      x2, x26
0x00015e70  bl       #0x577a0   ; CALL objc_msgSend$dictionaryWithContentsOfFile:
0x00015e74  mov      x29, x29
0x00015e78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015e7c  mov      x26, x0
0x00015e80  mov      x2, x24
0x00015e84  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00015e88  mov      x29, x29
0x00015e8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015e90  mov      x19, x0
0x00015e94  bl       #0x55d78   ; CALL _objc_release
0x00015e98  cbz      x19, #0x15ee8
0x00015e9c  adrp     x8, #0x76000
0x00015ea0  add      x9, x8, #0xf48   ; STR "plist"
0x00015ea4  adrp     x8, #0x76000
0x00015ea8  add      x8, x8, #0x548   ; STR "info"
0x00015eac  stp      x9, x8, [x29, #-0x100]
0x00015eb0  stp      x25, x26, [x29, #-0xf0]
0x00015eb4  ldr      x0, [x28, #0x970]   ; @CLASS NSDictionary
0x00015eb8  sub      x2, x29, #0xf0
0x00015ebc  sub      x3, x29, #0x100
0x00015ec0  mov      w4, #2
0x00015ec4  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00015ec8  mov      x29, x29
0x00015ecc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015ed0  mov      x19, x0
0x00015ed4  ldr      x0, [sp, #0x10]
0x00015ed8  mov      x2, x19
0x00015edc  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00015ee0  mov      x0, x19
0x00015ee4  bl       #0x55d78   ; CALL _objc_release
0x00015ee8  mov      x0, x26
0x00015eec  bl       #0x55d78   ; CALL _objc_release
0x00015ef0  mov      x0, x25
0x00015ef4  bl       #0x55d78   ; CALL _objc_release
0x00015ef8  add      x20, x20, #1
0x00015efc  cmp      x23, x20
0x00015f00  b.ne     #0x15e0c
0x00015f04  add      x2, sp, #0xd0
0x00015f08  sub      x3, x29, #0xe0
0x00015f0c  mov      x0, x21
0x00015f10  mov      w4, #0x10
0x00015f14  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00015f18  mov      x23, x0
0x00015f1c  cbnz     x0, #0x15e08
0x00015f20  mov      x0, x21
0x00015f24  bl       #0x55d78   ; CALL _objc_release
0x00015f28  adrp     x2, #0x74000
0x00015f2c  add      x2, x2, #0x7d0
0x00015f30  ldr      x0, [sp, #0x10]
0x00015f34  bl       #0x5cc80   ; CALL objc_msgSend$sortUsingComparator:
0x00015f38  adrp     x8, #0x74000
0x00015f3c  ldr      x8, [x8, #0x368]   ; @GOT _OBJC_IVAR_$_PSListController._specifiers
0x00015f40  ldrsw    x24, [x8]   ; @GOT ___objc_personality_v0
0x00015f44  ldr      x25, [sp, #0x28]
0x00015f48  ldr      x0, [x25, x24]
0x00015f4c  bl       #0x573c0   ; CALL objc_msgSend$count
0x00015f50  cbz      x0, #0x15fd0
0x00015f54  mov      x21, #0
0x00015f58  adrp     x20, #0x78000
0x00015f5c  add      x20, x20, #0x768   ; STR "features"
0x00015f60  ldr      x0, [x25, x24]
0x00015f64  mov      x2, x21
0x00015f68  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00015f6c  mov      x29, x29
0x00015f70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015f74  mov      x19, x0
0x00015f78  bl       #0x58060   ; CALL objc_msgSend$identifier
0x00015f7c  mov      x29, x29
0x00015f80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015f84  mov      x22, x0
0x00015f88  mov      x2, x20
0x00015f8c  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00015f90  mov      x23, x0
0x00015f94  mov      x0, x22
0x00015f98  bl       #0x55d78   ; CALL _objc_release
0x00015f9c  mov      x0, x19
0x00015fa0  bl       #0x55d78   ; CALL _objc_release
0x00015fa4  add      x22, x21, #1
0x00015fa8  tbnz     w23, #0, #0x15fc4
0x00015fac  ldr      x0, [x25, x24]
0x00015fb0  bl       #0x573c0   ; CALL objc_msgSend$count
0x00015fb4  mov      x21, x22
0x00015fb8  cmp      x22, x0
0x00015fbc  b.lo     #0x15f60
0x00015fc0  b        #0x15fd0
0x00015fc4  mov      x8, #0x7ffffffffffffffe
0x00015fc8  cmp      x21, x8
0x00015fcc  b.ne     #0x15fdc
0x00015fd0  ldr      x0, [x25, x24]
0x00015fd4  bl       #0x573c0   ; CALL objc_msgSend$count
0x00015fd8  mov      x22, x0
0x00015fdc  movi     v0.16b, #0
0x00015fe0  stp      q0, q0, [sp, #0xb0]
0x00015fe4  stp      q0, q0, [sp, #0x90]
0x00015fe8  ldr      x19, [sp, #0x10]
0x00015fec  mov      x0, x19
0x00015ff0  bl       #0x55d84   ; CALL _objc_retain
0x00015ff4  add      x2, sp, #0x90
0x00015ff8  add      x3, sp, #0x190
0x00015ffc  mov      x0, x19
0x00016000  mov      w4, #0x10
0x00016004  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00016008  str      x0, [sp, #0x30]
0x0001600c  cbz      x0, #0x16414
0x00016010  ldr      x8, [sp, #0xa0]
0x00016014  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00016018  stp      x8, x24, [sp, #0x18]
0x0001601c  adrp     x23, #0x78000
0x00016020  add      x23, x23, #0x7e8   ; STR "featureIcon"
0x00016024  adrp     x27, #0x78000
0x00016028  add      x27, x27, #0x828   ; STR "featureSymbol"
0x0001602c  adrp     x21, #0x76000
0x00016030  add      x21, x21, #0xfe8   ; STR "cell"
0x00016034  adrp     x26, #0x77000
0x00016038  add      x26, x26, #8   ; STR "PSSwitchCell"
0x0001603c  mov      x19, #0
0x00016040  str      x22, [sp, #0x40]
0x00016044  ldr      x8, [sp, #0xa0]
0x00016048  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0001604c  ldr      x9, [sp, #0x18]
0x00016050  cmp      x8, x9
0x00016054  b.eq     #0x16060
0x00016058  ldr      x0, [sp, #0x10]
0x0001605c  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00016060  ldr      x8, [sp, #0x98]
0x00016064  str      x19, [sp, #0x48]
0x00016068  ldr      x22, [x8, x19, lsl #3]   ; @GOT ___objc_personality_v0
0x0001606c  mov      x0, x22
0x00016070  adrp     x2, #0x76000
0x00016074  add      x2, x2, #0x548   ; STR "info"
0x00016078  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0001607c  mov      x29, x29
0x00016080  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016084  mov      x28, x0
0x00016088  adrp     x2, #0x78000
0x0001608c  add      x2, x2, #0x788   ; STR "featureController"
0x00016090  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00016094  mov      x29, x29
0x00016098  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001609c  mov      x24, x0
0x000160a0  cmp      x0, #0
0x000160a4  adrp     x8, #0x78000
0x000160a8  add      x8, x8, #0x7a8   ; STR "OMCFeatureListController"
0x000160ac  csel     x0, x8, x0, eq
0x000160b0  bl       #0x55af0   ; CALL _NSClassFromString
0x000160b4  mov      x20, x0
0x000160b8  cbnz     x0, #0x160cc
0x000160bc  adrp     x0, #0x78000
0x000160c0  add      x0, x0, #0x7a8   ; STR "OMCFeatureListController"
0x000160c4  bl       #0x55af0   ; CALL _NSClassFromString
0x000160c8  mov      x20, x0
0x000160cc  mov      x0, x24
0x000160d0  bl       #0x55d78   ; CALL _objc_release
0x000160d4  adrp     x8, #0x8e000
0x000160d8  ldr      x19, [x8, #0xa98]   ; @CLASS PSSpecifier
0x000160dc  mov      x0, x28
0x000160e0  adrp     x2, #0x76000
0x000160e4  add      x2, x2, #0xf88   ; STR "featureLabel"
0x000160e8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000160ec  mov      x29, x29
0x000160f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000160f4  mov      x24, x0
0x000160f8  str      xzr, [sp]
0x000160fc  mov      x0, x19
0x00016100  mov      x2, x24
0x00016104  mov      x3, x25
0x00016108  mov      x4, #0
0x0001610c  mov      x5, #0
0x00016110  mov      x6, x20
0x00016114  mov      w7, #1
0x00016118  bl       #0x598e0   ; CALL objc_msgSend$preferenceSpecifierNamed:target:set:get:detail:cell:edit:
0x0001611c  mov      x29, x29
0x00016120  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016124  mov      x20, x0
0x00016128  mov      x0, x24
0x0001612c  bl       #0x55d78   ; CALL _objc_release
0x00016130  mov      x0, x22
0x00016134  adrp     x22, #0x76000
0x00016138  add      x22, x22, #0xf48   ; STR "plist"
0x0001613c  mov      x2, x22
0x00016140  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00016144  mov      x29, x29
0x00016148  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001614c  mov      x19, x0
0x00016150  mov      x0, x20
0x00016154  mov      x2, x19
0x00016158  mov      x3, x22
0x0001615c  bl       #0x5bd60   ; CALL objc_msgSend$setProperty:forKey:
0x00016160  mov      x0, x19
0x00016164  bl       #0x55d78   ; CALL _objc_release
0x00016168  adrp     x8, #0x8e000
0x0001616c  ldr      x0, [x8, #0xac8]   ; @CLASS OMCFeatureStatusCell
0x00016170  bl       #0x55d48   ; CALL _objc_opt_class
0x00016174  mov      x2, x0
0x00016178  mov      x0, x20
0x0001617c  adrp     x3, #0x78000
0x00016180  add      x3, x3, #0x7c8   ; STR "cellClass"
0x00016184  bl       #0x5bd60   ; CALL objc_msgSend$setProperty:forKey:
0x00016188  mov      x0, x28
0x0001618c  mov      x2, x23
0x00016190  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00016194  mov      x29, x29
0x00016198  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001619c  mov      x19, x0
0x000161a0  bl       #0x55d78   ; CALL _objc_release
0x000161a4  cbz      x19, #0x161dc
0x000161a8  mov      x0, x28
0x000161ac  mov      x2, x23
0x000161b0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000161b4  mov      x29, x29
0x000161b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000161bc  mov      x19, x0
0x000161c0  mov      x0, x20
0x000161c4  mov      x2, x19
0x000161c8  adrp     x3, #0x78000
0x000161cc  add      x3, x3, #0x808   ; STR "icon"
0x000161d0  bl       #0x5bd60   ; CALL objc_msgSend$setProperty:forKey:
0x000161d4  mov      x0, x19
0x000161d8  bl       #0x55d78   ; CALL _objc_release
0x000161dc  mov      x0, x28
0x000161e0  mov      x2, x27
0x000161e4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000161e8  mov      x29, x29
0x000161ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000161f0  mov      x19, x0
0x000161f4  bl       #0x55d78   ; CALL _objc_release
0x000161f8  cbz      x19, #0x16230
0x000161fc  mov      x0, x28
0x00016200  mov      x2, x27
0x00016204  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00016208  mov      x29, x29
0x0001620c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016210  mov      x19, x0
0x00016214  mov      x0, x20
0x00016218  mov      x2, x19
0x0001621c  adrp     x3, #0x78000
0x00016220  add      x3, x3, #0x848   ; STR "symbol"
0x00016224  bl       #0x5bd60   ; CALL objc_msgSend$setProperty:forKey:
0x00016228  mov      x0, x19
0x0001622c  bl       #0x55d78   ; CALL _objc_release
0x00016230  movi     v0.16b, #0
0x00016234  stp      q0, q0, [sp, #0x70]
0x00016238  stp      q0, q0, [sp, #0x50]
0x0001623c  str      x28, [sp, #0x38]
0x00016240  mov      x0, x28
0x00016244  adrp     x2, #0x76000
0x00016248  add      x2, x2, #0xfa8   ; STR "items"
0x0001624c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00016250  mov      x29, x29
0x00016254  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016258  mov      x22, x0
0x0001625c  add      x2, sp, #0x50
0x00016260  add      x3, sp, #0x110
0x00016264  mov      w4, #0x10
0x00016268  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001626c  cbz      x0, #0x163a4
0x00016270  mov      x27, x0
0x00016274  ldr      x8, [sp, #0x60]
0x00016278  ldr      x28, [x8]   ; @SEL "whatsNewNavigationController"
0x0001627c  mov      x25, #0
0x00016280  ldr      x8, [sp, #0x60]
0x00016284  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00016288  cmp      x8, x28
0x0001628c  b.eq     #0x16298
0x00016290  mov      x0, x22
0x00016294  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00016298  ldr      x8, [sp, #0x58]
0x0001629c  ldr      x24, [x8, x25, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x000162a0  mov      x0, x24
0x000162a4  mov      x2, x21
0x000162a8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000162ac  mov      x29, x29
0x000162b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000162b4  mov      x19, x0
0x000162b8  mov      x2, x26
0x000162bc  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x000162c0  tbz      w0, #0, #0x162f4
0x000162c4  mov      x0, x24
0x000162c8  adrp     x2, #0x76000
0x000162cc  add      x2, x2, #0xfc8   ; STR "key"
0x000162d0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000162d4  mov      x29, x29
0x000162d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000162dc  mov      x23, x0
0x000162e0  bl       #0x55d78   ; CALL _objc_release
0x000162e4  mov      x0, x19
0x000162e8  bl       #0x55d78   ; CALL _objc_release
0x000162ec  cbnz     x23, #0x16328
0x000162f0  b        #0x162fc
0x000162f4  mov      x0, x19
0x000162f8  bl       #0x55d78   ; CALL _objc_release
0x000162fc  add      x25, x25, #1
0x00016300  cmp      x27, x25
0x00016304  b.ne     #0x16280
0x00016308  add      x2, sp, #0x50
0x0001630c  add      x3, sp, #0x110
0x00016310  mov      x0, x22
0x00016314  mov      w4, #0x10
0x00016318  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001631c  mov      x27, x0
0x00016320  cbnz     x0, #0x1627c
0x00016324  b        #0x163a4
0x00016328  mov      x0, x24
0x0001632c  adrp     x2, #0x76000
0x00016330  add      x2, x2, #0xfc8   ; STR "key"
0x00016334  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00016338  mov      x29, x29
0x0001633c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016340  mov      x19, x0
0x00016344  mov      x0, x20
0x00016348  mov      x2, x19
0x0001634c  adrp     x3, #0x78000
0x00016350  add      x3, x3, #0x5a8   ; STR "featureKey"
0x00016354  bl       #0x5bd60   ; CALL objc_msgSend$setProperty:forKey:
0x00016358  mov      x0, x19
0x0001635c  bl       #0x55d78   ; CALL _objc_release
0x00016360  mov      x0, x24
0x00016364  adrp     x2, #0x78000
0x00016368  add      x2, x2, #0x868   ; STR "default"
0x0001636c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00016370  mov      x29, x29
0x00016374  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016378  mov      x19, x0
0x0001637c  cmp      x0, #0
0x00016380  adrp     x8, #0x74000
0x00016384  ldr      x8, [x8, #0x1b8]   ; @GOT ___kCFBooleanTrue
0x00016388  csel     x2, x8, x0, eq
0x0001638c  mov      x0, x20
0x00016390  adrp     x3, #0x78000
0x00016394  add      x3, x3, #0x5c8   ; STR "featureDefault"
0x00016398  bl       #0x5bd60   ; CALL objc_msgSend$setProperty:forKey:
0x0001639c  mov      x0, x19
0x000163a0  bl       #0x55d78   ; CALL _objc_release
0x000163a4  mov      x0, x22
0x000163a8  bl       #0x55d78   ; CALL _objc_release
0x000163ac  ldp      x24, x25, [sp, #0x20]
0x000163b0  ldr      x0, [x25, x24]
0x000163b4  ldr      x3, [sp, #0x40]
0x000163b8  add      x22, x3, #1
0x000163bc  mov      x2, x20
0x000163c0  bl       #0x58640   ; CALL objc_msgSend$insertObject:atIndex:
0x000163c4  mov      x0, x20
0x000163c8  bl       #0x55d78   ; CALL _objc_release
0x000163cc  ldr      x0, [sp, #0x38]
0x000163d0  bl       #0x55d78   ; CALL _objc_release
0x000163d4  ldr      x19, [sp, #0x48]
0x000163d8  add      x19, x19, #1
0x000163dc  ldr      x8, [sp, #0x30]
0x000163e0  cmp      x19, x8
0x000163e4  adrp     x23, #0x78000
0x000163e8  add      x23, x23, #0x7e8   ; STR "featureIcon"
0x000163ec  adrp     x27, #0x78000
0x000163f0  add      x27, x27, #0x828   ; STR "featureSymbol"
0x000163f4  b.ne     #0x16040
0x000163f8  add      x2, sp, #0x90
0x000163fc  add      x3, sp, #0x190
0x00016400  ldr      x0, [sp, #0x10]
0x00016404  mov      w4, #0x10
0x00016408  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0001640c  str      x0, [sp, #0x30]
0x00016410  cbnz     x0, #0x1603c
0x00016414  ldr      x19, [sp, #0x10]
0x00016418  mov      x0, x19
0x0001641c  bl       #0x55d78   ; CALL _objc_release
0x00016420  mov      x0, x19
0x00016424  bl       #0x55d78   ; CALL _objc_release
0x00016428  ldr      x0, [sp, #8]
0x0001642c  bl       #0x55d78   ; CALL _objc_release
0x00016430  ldur     x8, [x29, #-0x60]
0x00016434  adrp     x9, #0x74000
0x00016438  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0001643c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00016440  cmp      x9, x8
0x00016444  b.ne     #0x16468
0x00016448  add      sp, sp, #0x2c0
0x0001644c  ldp      x29, x30, [sp, #0x50]
0x00016450  ldp      x20, x19, [sp, #0x40]
0x00016454  ldp      x22, x21, [sp, #0x30]
0x00016458  ldp      x24, x23, [sp, #0x20]
0x0001645c  ldp      x26, x25, [sp, #0x10]
0x00016460  ldp      x28, x27, [sp], #0x60
0x00016464  ret      
0x00016468  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCRootListController viewDidLoad]  va=0x165cc size=376 types=v16@0:8
0x000165cc  sub      sp, sp, #0x70
0x000165d0  stp      x24, x23, [sp, #0x30]
0x000165d4  stp      x22, x21, [sp, #0x40]
0x000165d8  stp      x20, x19, [sp, #0x50]
0x000165dc  stp      x29, x30, [sp, #0x60]
0x000165e0  add      x29, sp, #0x60
0x000165e4  mov      x19, x0
0x000165e8  adrp     x8, #0x74000
0x000165ec  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000165f0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000165f4  str      x8, [sp, #0x28]
0x000165f8  adrp     x8, #0x8e000
0x000165fc  ldr      x8, [x8, #0xd38]   ; @SUPER OMCRootListController
0x00016600  stp      x0, x8, [sp, #8]
0x00016604  adrp     x8, #0x8b000
0x00016608  ldr      x1, [x8, #0xda0]   ; @SEL "viewDidLoad"
0x0001660c  add      x0, sp, #8
0x00016610  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00016614  bl       #0x17fd8   ; CALL _OMCSwitchColor
0x00016618  mov      x29, x29
0x0001661c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016620  mov      x20, x0
0x00016624  adrp     x8, #0x8e000
0x00016628  ldr      x21, [x8, #0x920]   ; @CLASS UISwitch
0x0001662c  mov      x0, x19
0x00016630  bl       #0x55d48   ; CALL _objc_opt_class
0x00016634  str      x0, [sp, #0x20]
0x00016638  adrp     x23, #0x8e000
0x0001663c  ldr      x0, [x23, #0x960]   ; @CLASS NSArray
0x00016640  add      x2, sp, #0x20
0x00016644  mov      w3, #1
0x00016648  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0001664c  mov      x29, x29
0x00016650  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016654  mov      x22, x0
0x00016658  mov      x0, x21
0x0001665c  mov      x2, x22
0x00016660  bl       #0x56400   ; CALL objc_msgSend$appearanceWhenContainedInInstancesOfClasses:
0x00016664  mov      x29, x29
0x00016668  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001666c  mov      x21, x0
0x00016670  mov      x2, x20
0x00016674  bl       #0x5b920   ; CALL objc_msgSend$setOnTintColor:
0x00016678  mov      x0, x21
0x0001667c  bl       #0x55d78   ; CALL _objc_release
0x00016680  mov      x0, x22
0x00016684  bl       #0x55d78   ; CALL _objc_release
0x00016688  mov      x0, x20
0x0001668c  bl       #0x55d78   ; CALL _objc_release
0x00016690  bl       #0x17e8c   ; CALL _OMCAccentColor
0x00016694  mov      x29, x29
0x00016698  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001669c  mov      x20, x0
0x000166a0  adrp     x8, #0x8e000
0x000166a4  ldr      x21, [x8, #0x950]   ; @CLASS UISlider
0x000166a8  mov      x0, x19
0x000166ac  bl       #0x55d48   ; CALL _objc_opt_class
0x000166b0  str      x0, [sp, #0x18]
0x000166b4  ldr      x0, [x23, #0x960]   ; @CLASS NSArray
0x000166b8  add      x2, sp, #0x18
0x000166bc  mov      w3, #1
0x000166c0  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000166c4  mov      x29, x29
0x000166c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000166cc  mov      x22, x0
0x000166d0  mov      x0, x21
0x000166d4  mov      x2, x22
0x000166d8  bl       #0x56400   ; CALL objc_msgSend$appearanceWhenContainedInInstancesOfClasses:
0x000166dc  mov      x29, x29
0x000166e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000166e4  mov      x21, x0
0x000166e8  mov      x2, x20
0x000166ec  bl       #0x5b680   ; CALL objc_msgSend$setMinimumTrackTintColor:
0x000166f0  mov      x0, x21
0x000166f4  bl       #0x55d78   ; CALL _objc_release
0x000166f8  mov      x0, x22
0x000166fc  bl       #0x55d78   ; CALL _objc_release
0x00016700  mov      x0, x20
0x00016704  bl       #0x55d78   ; CALL _objc_release
0x00016708  mov      x0, x19
0x0001670c  bl       #0x56500   ; CALL objc_msgSend$applyLanguage
0x00016710  ldr      x8, [sp, #0x28]
0x00016714  adrp     x9, #0x74000
0x00016718  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0001671c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00016720  cmp      x9, x8
0x00016724  b.ne     #0x16740
0x00016728  ldp      x29, x30, [sp, #0x60]
0x0001672c  ldp      x20, x19, [sp, #0x50]
0x00016730  ldp      x22, x21, [sp, #0x40]
0x00016734  ldp      x24, x23, [sp, #0x30]
0x00016738  add      sp, sp, #0x70
0x0001673c  ret      
0x00016740  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCRootListController viewWillAppear:]  va=0x16744 size=244 types=v20@0:8B16
0x00016744  sub      sp, sp, #0x40
0x00016748  stp      x22, x21, [sp, #0x10]
0x0001674c  stp      x20, x19, [sp, #0x20]
0x00016750  stp      x29, x30, [sp, #0x30]
0x00016754  add      x29, sp, #0x30
0x00016758  mov      x19, x0
0x0001675c  adrp     x8, #0x8e000
0x00016760  ldr      x8, [x8, #0xd38]   ; @SUPER OMCRootListController
0x00016764  stp      x0, x8, [sp]
0x00016768  adrp     x8, #0x8b000
0x0001676c  ldr      x1, [x8, #0xda8]   ; @SEL "viewWillAppear:"
0x00016770  mov      x0, sp
0x00016774  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00016778  adrp     x0, #0x75000
0x0001677c  add      x0, x0, #0x28   ; STR "com.anlai.omnicar"
0x00016780  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x00016784  mov      x0, x19
0x00016788  bl       #0x57500   ; CALL objc_msgSend$currentSupportState
0x0001678c  mov      x29, x29
0x00016790  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016794  mov      x20, x0
0x00016798  mov      x0, x19
0x0001679c  bl       #0x5d760   ; CALL objc_msgSend$supportState
0x000167a0  mov      x29, x29
0x000167a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000167a8  mov      x21, x0
0x000167ac  adrp     x8, #0x75000
0x000167b0  add      x8, x8, #0xd28
0x000167b4  cmp      x0, #0
0x000167b8  csel     x2, x8, x0, eq
0x000167bc  mov      x0, x20
0x000167c0  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x000167c4  mov      x22, x0
0x000167c8  mov      x0, x21
0x000167cc  bl       #0x55d78   ; CALL _objc_release
0x000167d0  mov      x0, x20
0x000167d4  bl       #0x55d78   ; CALL _objc_release
0x000167d8  tbnz     w22, #0, #0x167f4
0x000167dc  adrp     x8, #0x74000
0x000167e0  ldr      x8, [x8, #0x368]   ; @GOT _OBJC_IVAR_$_PSListController._specifiers
0x000167e4  ldrsw    x8, [x8]   ; @GOT ___objc_personality_v0
0x000167e8  ldr      x0, [x19, x8]
0x000167ec  str      xzr, [x19, x8]
0x000167f0  bl       #0x55d78   ; CALL _objc_release
0x000167f4  mov      x0, x19
0x000167f8  bl       #0x59d40   ; CALL objc_msgSend$reloadSpecifiers
0x000167fc  mov      x0, x19
0x00016800  bl       #0x5dd40   ; CALL objc_msgSend$updateHeaderStatus
0x00016804  mov      x0, x19
0x00016808  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x0001680c  mov      x29, x29
0x00016810  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016814  mov      x19, x0
0x00016818  bl       #0x18828   ; CALL _OMCStyleTable
0x0001681c  mov      x0, x19
0x00016820  bl       #0x55d78   ; CALL _objc_release
0x00016824  ldp      x29, x30, [sp, #0x30]
0x00016828  ldp      x20, x19, [sp, #0x20]
0x0001682c  ldp      x22, x21, [sp, #0x10]
0x00016830  add      sp, sp, #0x40
0x00016834  ret      

=== -[OMCRootListController traitCollectionDidChange:]  va=0x16838 size=196 types=v24@0:8@16
0x00016838  sub      sp, sp, #0x50
0x0001683c  stp      x24, x23, [sp, #0x10]
0x00016840  stp      x22, x21, [sp, #0x20]
0x00016844  stp      x20, x19, [sp, #0x30]
0x00016848  stp      x29, x30, [sp, #0x40]
0x0001684c  add      x29, sp, #0x40
0x00016850  mov      x20, x2
0x00016854  mov      x19, x0
0x00016858  adrp     x8, #0x8e000
0x0001685c  ldr      x8, [x8, #0xd38]   ; @SUPER OMCRootListController
0x00016860  stp      x0, x8, [sp]
0x00016864  adrp     x8, #0x8b000
0x00016868  ldr      x21, [x8, #0xdb0]   ; @SEL "traitCollectionDidChange:"
0x0001686c  mov      x0, x2
0x00016870  bl       #0x55d84   ; CALL _objc_retain
0x00016874  mov      x0, sp
0x00016878  mov      x1, x21
0x0001687c  mov      x2, x20
0x00016880  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00016884  mov      x0, x19
0x00016888  bl       #0x5dc60   ; CALL objc_msgSend$traitCollection
0x0001688c  mov      x29, x29
0x00016890  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016894  mov      x21, x0
0x00016898  bl       #0x5de60   ; CALL objc_msgSend$userInterfaceStyle
0x0001689c  mov      x22, x0
0x000168a0  mov      x0, x20
0x000168a4  bl       #0x5de60   ; CALL objc_msgSend$userInterfaceStyle
0x000168a8  mov      x23, x0
0x000168ac  mov      x0, x20
0x000168b0  bl       #0x55d78   ; CALL _objc_release
0x000168b4  mov      x0, x21
0x000168b8  bl       #0x55d78   ; CALL _objc_release
0x000168bc  cmp      x22, x23
0x000168c0  b.eq     #0x168e4
0x000168c4  mov      x0, x19
0x000168c8  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x000168cc  mov      x29, x29
0x000168d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000168d4  mov      x19, x0
0x000168d8  bl       #0x18828   ; CALL _OMCStyleTable
0x000168dc  mov      x0, x19
0x000168e0  bl       #0x55d78   ; CALL _objc_release
0x000168e4  ldp      x29, x30, [sp, #0x40]
0x000168e8  ldp      x20, x19, [sp, #0x30]
0x000168ec  ldp      x22, x21, [sp, #0x20]
0x000168f0  ldp      x24, x23, [sp, #0x10]
0x000168f4  add      sp, sp, #0x50
0x000168f8  ret      

=== -[OMCRootListController viewDidAppear:]  va=0x168fc size=192 types=v20@0:8B16
0x000168fc  sub      sp, sp, #0x40
0x00016900  stp      x22, x21, [sp, #0x10]
0x00016904  stp      x20, x19, [sp, #0x20]
0x00016908  stp      x29, x30, [sp, #0x30]
0x0001690c  add      x29, sp, #0x30
0x00016910  mov      x19, x0
0x00016914  adrp     x8, #0x8e000
0x00016918  ldr      x8, [x8, #0xd38]   ; @SUPER OMCRootListController
0x0001691c  stp      x0, x8, [sp]
0x00016920  adrp     x8, #0x8b000
0x00016924  ldr      x1, [x8, #0xe40]   ; @SEL "viewDidAppear:"
0x00016928  mov      x0, sp
0x0001692c  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00016930  adrp     x21, #0x8f000
0x00016934  ldrb     w8, [x21, #0xff9]
0x00016938  tbnz     w8, #0, #0x169a8
0x0001693c  mov      x0, x19
0x00016940  bl       #0x599c0   ; CALL objc_msgSend$presentedViewController
0x00016944  mov      x29, x29
0x00016948  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001694c  mov      x20, x0
0x00016950  bl       #0x55d78   ; CALL _objc_release
0x00016954  cbnz     x20, #0x169a8
0x00016958  adrp     x8, #0x8e000
0x0001695c  ldr      x0, [x8, #0xa20]   ; @CLASS OMCOnboardingController
0x00016960  bl       #0x5c9c0   ; CALL objc_msgSend$shouldShow
0x00016964  cbz      w0, #0x16988
0x00016968  mov      w8, #1
0x0001696c  strb     w8, [x21, #0xff9]
0x00016970  adrp     x8, #0x8e000
0x00016974  ldr      x0, [x8, #0xad0]   ; @CLASS OMCWhatsNewController
0x00016978  bl       #0x58f40   ; CALL objc_msgSend$markSeen
0x0001697c  mov      x0, x19
0x00016980  bl       #0x5ca00   ; CALL objc_msgSend$showGuide
0x00016984  b        #0x169a8
0x00016988  adrp     x8, #0x8e000
0x0001698c  ldr      x0, [x8, #0xad0]   ; @CLASS OMCWhatsNewController
0x00016990  bl       #0x5c9c0   ; CALL objc_msgSend$shouldShow
0x00016994  cbz      w0, #0x169a8
0x00016998  mov      w8, #1
0x0001699c  strb     w8, [x21, #0xff9]
0x000169a0  mov      x0, x19
0x000169a4  bl       #0x5cb00   ; CALL objc_msgSend$showWhatsNew
0x000169a8  ldp      x29, x30, [sp, #0x30]
0x000169ac  ldp      x20, x19, [sp, #0x20]
0x000169b0  ldp      x22, x21, [sp, #0x10]
0x000169b4  add      sp, sp, #0x40
0x000169b8  ret      

=== -[OMCRootListController applyLanguage]  va=0x169bc size=468 types=v16@0:8
0x000169bc  sub      sp, sp, #0x50
0x000169c0  stp      x22, x21, [sp, #0x20]
0x000169c4  stp      x20, x19, [sp, #0x30]
0x000169c8  stp      x29, x30, [sp, #0x40]
0x000169cc  add      x29, sp, #0x40
0x000169d0  mov      x19, x0
0x000169d4  adrp     x8, #0x74000
0x000169d8  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000169dc  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000169e0  str      x8, [sp, #0x18]
0x000169e4  bl       #0x17a44   ; CALL _OMCLoadStrings
0x000169e8  adrp     x2, #0x75000
0x000169ec  add      x2, x2, #0x508   ; STR "OmniCar"
0x000169f0  mov      x0, x19
0x000169f4  bl       #0x5c5e0   ; CALL objc_msgSend$setTitle:
0x000169f8  mov      x0, x19
0x000169fc  bl       #0x57f20   ; CALL objc_msgSend$headerView
0x00016a00  mov      x29, x29
0x00016a04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016a08  mov      x20, x0
0x00016a0c  mov      x0, x19
0x00016a10  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x00016a14  mov      x29, x29
0x00016a18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016a1c  mov      x21, x0
0x00016a20  mov      x2, x20
0x00016a24  bl       #0x5c460   ; CALL objc_msgSend$setTableHeaderView:
0x00016a28  mov      x0, x21
0x00016a2c  bl       #0x55d78   ; CALL _objc_release
0x00016a30  mov      x0, x20
0x00016a34  bl       #0x55d78   ; CALL _objc_release
0x00016a38  adrp     x8, #0x8e000
0x00016a3c  ldr      x0, [x8, #0xad8]   ; @CLASS UIBarButtonItem
0x00016a40  bl       #0x55c7c   ; CALL _objc_alloc
0x00016a44  mov      x20, x0
0x00016a48  adrp     x8, #0x8e000
0x00016a4c  ldr      x0, [x8, #0xa78]   ; @CLASS UIImage
0x00016a50  adrp     x2, #0x78000
0x00016a54  add      x2, x2, #0x888   ; STR "arrow.clockwise"
0x00016a58  bl       #0x5d820   ; CALL objc_msgSend$systemImageNamed:
0x00016a5c  mov      x29, x29
0x00016a60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016a64  mov      x21, x0
0x00016a68  adrp     x8, #0x8b000
0x00016a6c  ldr      x5, [x8, #0xe48]   ; @SEL "respring"
0x00016a70  mov      x0, x20
0x00016a74  mov      x2, x21
0x00016a78  mov      x3, #0
0x00016a7c  mov      x4, x19
0x00016a80  bl       #0x584e0   ; CALL objc_msgSend$initWithImage:style:target:action:
0x00016a84  mov      x20, x0
0x00016a88  mov      x0, x21
0x00016a8c  bl       #0x55d78   ; CALL _objc_release
0x00016a90  adrp     x8, #0x8e000
0x00016a94  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00016a98  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x00016a9c  mov      x29, x29
0x00016aa0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016aa4  mov      x21, x0
0x00016aa8  mov      x0, x20
0x00016aac  mov      x2, x21
0x00016ab0  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x00016ab4  mov      x0, x21
0x00016ab8  bl       #0x55d78   ; CALL _objc_release
0x00016abc  adrp     x0, #0x78000
0x00016ac0  add      x0, x0, #0x8a8   ; STR "RESPRING"
0x00016ac4  bl       #0x17e20   ; CALL _L
0x00016ac8  mov      x29, x29
0x00016acc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016ad0  mov      x21, x0
0x00016ad4  mov      x0, x20
0x00016ad8  mov      x2, x21
0x00016adc  bl       #0x5a240   ; CALL objc_msgSend$setAccessibilityLabel:
0x00016ae0  mov      x0, x21
0x00016ae4  bl       #0x55d78   ; CALL _objc_release
0x00016ae8  str      x20, [sp, #8]
0x00016aec  mov      x0, x19
0x00016af0  bl       #0x58a60   ; CALL objc_msgSend$languageButton
0x00016af4  mov      x29, x29
0x00016af8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016afc  mov      x21, x0
0x00016b00  str      x0, [sp, #0x10]
0x00016b04  adrp     x8, #0x8e000
0x00016b08  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00016b0c  add      x2, sp, #8
0x00016b10  mov      w3, #2
0x00016b14  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00016b18  mov      x29, x29
0x00016b1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016b20  mov      x22, x0
0x00016b24  mov      x0, x19
0x00016b28  bl       #0x591a0   ; CALL objc_msgSend$navigationItem
0x00016b2c  mov      x29, x29
0x00016b30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016b34  mov      x19, x0
0x00016b38  mov      x2, x22
0x00016b3c  bl       #0x5be20   ; CALL objc_msgSend$setRightBarButtonItems:
0x00016b40  mov      x0, x19
0x00016b44  bl       #0x55d78   ; CALL _objc_release
0x00016b48  mov      x0, x22
0x00016b4c  bl       #0x55d78   ; CALL _objc_release
0x00016b50  mov      x0, x21
0x00016b54  bl       #0x55d78   ; CALL _objc_release
0x00016b58  mov      x0, x20
0x00016b5c  bl       #0x55d78   ; CALL _objc_release
0x00016b60  ldr      x8, [sp, #0x18]
0x00016b64  adrp     x9, #0x74000
0x00016b68  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00016b6c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00016b70  cmp      x9, x8
0x00016b74  b.ne     #0x16b8c
0x00016b78  ldp      x29, x30, [sp, #0x40]
0x00016b7c  ldp      x20, x19, [sp, #0x30]
0x00016b80  ldp      x22, x21, [sp, #0x20]
0x00016b84  add      sp, sp, #0x50
0x00016b88  ret      
0x00016b8c  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCRootListController languageButton]  va=0x16b90 size=876 types=@16@0:8
0x00016b90  sub      sp, sp, #0x190
0x00016b94  stp      d9, d8, [sp, #0x120]
0x00016b98  stp      x28, x27, [sp, #0x130]
0x00016b9c  stp      x26, x25, [sp, #0x140]
0x00016ba0  stp      x24, x23, [sp, #0x150]
0x00016ba4  stp      x22, x21, [sp, #0x160]
0x00016ba8  stp      x20, x19, [sp, #0x170]
0x00016bac  stp      x29, x30, [sp, #0x180]
0x00016bb0  add      x29, sp, #0x180
0x00016bb4  mov      x21, x0
0x00016bb8  adrp     x8, #0x74000
0x00016bbc  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00016bc0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00016bc4  stur     x8, [x29, #-0x70]
0x00016bc8  bl       #0x17a40   ; CALL _OMCLanguage
0x00016bcc  mov      x29, x29
0x00016bd0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016bd4  str      x0, [sp]
0x00016bd8  adrp     x8, #0x8e000
0x00016bdc  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00016be0  bl       #0x565c0   ; CALL objc_msgSend$array
0x00016be4  mov      x29, x29
0x00016be8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016bec  str      x0, [sp, #8]
0x00016bf0  add      x0, sp, #0x88
0x00016bf4  mov      x1, x21
0x00016bf8  bl       #0x55d18   ; CALL _objc_initWeak
0x00016bfc  movi     v0.16b, #0
0x00016c00  stp      q0, q0, [sp, #0x60]
0x00016c04  stp      q0, q0, [sp, #0x40]
0x00016c08  bl       #0x179d4   ; CALL _OMCLanguages
0x00016c0c  mov      x29, x29
0x00016c10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016c14  mov      x21, x0
0x00016c18  add      x2, sp, #0x40
0x00016c1c  add      x3, sp, #0x90
0x00016c20  mov      w4, #0x10
0x00016c24  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00016c28  mov      x22, x0
0x00016c2c  cbz      x0, #0x16d40
0x00016c30  ldr      x8, [sp, #0x50]
0x00016c34  ldr      x27, [x8]   ; @SEL "whatsNewNavigationController"
0x00016c38  add      x26, sp, #0x10
0x00016c3c  adrp     x8, #0x65000
0x00016c40  ldr      d8, [x8, #0x600]
0x00016c44  adrp     x19, #0x16000
0x00016c48  add      x19, x19, #0xec8
0x00016c4c  adrp     x20, #0x74000
0x00016c50  add      x20, x20, #0x7f0
0x00016c54  mov      x28, #0
0x00016c58  ldr      x8, [sp, #0x50]
0x00016c5c  ldr      x8, [x8]   ; @CSTR "m.fill"
0x00016c60  cmp      x8, x27
0x00016c64  b.eq     #0x16c70
0x00016c68  mov      x0, x21
0x00016c6c  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00016c70  ldr      x8, [sp, #0x48]
0x00016c74  ldr      x23, [x8, x28, lsl #3]
0x00016c78  adrp     x8, #0x8e000
0x00016c7c  ldr      x24, [x8, #0xae0]   ; @CLASS UIAction
0x00016c80  mov      x0, x23
0x00016c84  bl       #0x179d8   ; CALL _OMCLanguageName
0x00016c88  mov      x29, x29
0x00016c8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016c90  mov      x25, x0
0x00016c94  adrp     x8, #0x74000
0x00016c98  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00016c9c  str      x8, [sp, #0x10]
0x00016ca0  str      d8, [sp, #0x18]
0x00016ca4  stp      x19, x20, [sp, #0x20]
0x00016ca8  add      x0, x26, #0x28
0x00016cac  add      x1, sp, #0x88
0x00016cb0  bl       #0x55cd0   ; CALL _objc_copyWeak
0x00016cb4  str      x23, [sp, #0x30]
0x00016cb8  add      x5, sp, #0x10
0x00016cbc  mov      x0, x24
0x00016cc0  mov      x2, x25
0x00016cc4  mov      x3, #0
0x00016cc8  mov      x4, #0
0x00016ccc  bl       #0x55fa0   ; CALL objc_msgSend$actionWithTitle:image:identifier:handler:
0x00016cd0  mov      x29, x29
0x00016cd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016cd8  mov      x24, x0
0x00016cdc  mov      x0, x25
0x00016ce0  bl       #0x55d78   ; CALL _objc_release
0x00016ce4  mov      x0, x23
0x00016ce8  ldr      x2, [sp]
0x00016cec  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00016cf0  mov      w2, w0
0x00016cf4  mov      x0, x24
0x00016cf8  bl       #0x5c2e0   ; CALL objc_msgSend$setState:
0x00016cfc  ldr      x0, [sp, #8]
0x00016d00  mov      x2, x24
0x00016d04  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00016d08  mov      x0, x24
0x00016d0c  bl       #0x55d78   ; CALL _objc_release
0x00016d10  add      x0, x26, #0x28
0x00016d14  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00016d18  add      x28, x28, #1
0x00016d1c  cmp      x22, x28
0x00016d20  b.ne     #0x16c58
0x00016d24  add      x2, sp, #0x40
0x00016d28  add      x3, sp, #0x90
0x00016d2c  mov      x0, x21
0x00016d30  mov      w4, #0x10
0x00016d34  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00016d38  mov      x22, x0
0x00016d3c  cbnz     x0, #0x16c54
0x00016d40  mov      x0, x21
0x00016d44  bl       #0x55d78   ; CALL _objc_release
0x00016d48  adrp     x8, #0x8e000
0x00016d4c  ldr      x0, [x8, #0xad8]   ; @CLASS UIBarButtonItem
0x00016d50  bl       #0x55c7c   ; CALL _objc_alloc
0x00016d54  mov      x21, x0
0x00016d58  adrp     x8, #0x8e000
0x00016d5c  ldr      x0, [x8, #0xa78]   ; @CLASS UIImage
0x00016d60  adrp     x2, #0x78000
0x00016d64  add      x2, x2, #0x8c8   ; STR "globe"
0x00016d68  bl       #0x5d820   ; CALL objc_msgSend$systemImageNamed:
0x00016d6c  mov      x29, x29
0x00016d70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016d74  mov      x22, x0
0x00016d78  mov      x0, x21
0x00016d7c  mov      x2, x22
0x00016d80  mov      x3, #0
0x00016d84  mov      x4, #0
0x00016d88  mov      x5, #0
0x00016d8c  bl       #0x584e0   ; CALL objc_msgSend$initWithImage:style:target:action:
0x00016d90  mov      x21, x0
0x00016d94  mov      x0, x22
0x00016d98  bl       #0x55d78   ; CALL _objc_release
0x00016d9c  adrp     x8, #0x8e000
0x00016da0  ldr      x23, [x8, #0xae8]   ; @CLASS UIMenu
0x00016da4  adrp     x0, #0x78000
0x00016da8  add      x0, x0, #0x8e8   ; STR "LANGUAGE"
0x00016dac  bl       #0x17e20   ; CALL _L
0x00016db0  mov      x29, x29
0x00016db4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016db8  mov      x22, x0
0x00016dbc  mov      x0, x23
0x00016dc0  mov      x2, x22
0x00016dc4  ldr      x3, [sp, #8]
0x00016dc8  bl       #0x58fa0   ; CALL objc_msgSend$menuWithTitle:children:
0x00016dcc  mov      x29, x29
0x00016dd0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016dd4  mov      x23, x0
0x00016dd8  mov      x0, x21
0x00016ddc  mov      x2, x23
0x00016de0  bl       #0x5b5c0   ; CALL objc_msgSend$setMenu:
0x00016de4  mov      x0, x23
0x00016de8  bl       #0x55d78   ; CALL _objc_release
0x00016dec  mov      x0, x22
0x00016df0  bl       #0x55d78   ; CALL _objc_release
0x00016df4  adrp     x8, #0x8e000
0x00016df8  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00016dfc  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x00016e00  mov      x29, x29
0x00016e04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016e08  mov      x22, x0
0x00016e0c  mov      x0, x21
0x00016e10  mov      x2, x22
0x00016e14  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x00016e18  mov      x0, x22
0x00016e1c  bl       #0x55d78   ; CALL _objc_release
0x00016e20  add      x0, sp, #0x88
0x00016e24  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00016e28  ldr      x0, [sp, #8]
0x00016e2c  bl       #0x55d78   ; CALL _objc_release
0x00016e30  ldr      x0, [sp]
0x00016e34  bl       #0x55d78   ; CALL _objc_release
0x00016e38  ldur     x8, [x29, #-0x70]
0x00016e3c  adrp     x9, #0x74000
0x00016e40  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00016e44  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00016e48  cmp      x9, x8
0x00016e4c  b.ne     #0x16e78
0x00016e50  mov      x0, x21
0x00016e54  ldp      x29, x30, [sp, #0x180]
0x00016e58  ldp      x20, x19, [sp, #0x170]
0x00016e5c  ldp      x22, x21, [sp, #0x160]
0x00016e60  ldp      x24, x23, [sp, #0x150]
0x00016e64  ldp      x26, x25, [sp, #0x140]
0x00016e68  ldp      x28, x27, [sp, #0x130]
0x00016e6c  ldp      d9, d8, [sp, #0x120]
0x00016e70  add      sp, sp, #0x190
0x00016e74  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00016e78  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00016e7c  b        #0x16e8c
0x00016e80  b        #0x16e8c
0x00016e84  b        #0x16e8c
0x00016e88  b        #0x16e8c
0x00016e8c  mov      x19, x0
0x00016e90  b        #0x16eb0
0x00016e94  mov      x19, x0
0x00016e98  add      x0, x26, #0x28
0x00016e9c  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00016ea0  b        #0x16eb0
0x00016ea4  mov      x19, x0
0x00016ea8  add      x0, x26, #0x28
0x00016eac  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00016eb0  add      x0, sp, #0x88
0x00016eb4  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00016eb8  b        #0x16ec0
0x00016ebc  mov      x19, x0
0x00016ec0  mov      x0, x19
0x00016ec4  bl       #0x55b80   ; CALL __Unwind_Resume
0x00016ec8  stp      x20, x19, [sp, #-0x20]!
0x00016ecc  stp      x29, x30, [sp, #0x10]
0x00016ed0  add      x29, sp, #0x10
0x00016ed4  mov      x19, x0
0x00016ed8  add      x0, x0, #0x28
0x00016edc  bl       #0x55d24   ; CALL _objc_loadWeakRetained
0x00016ee0  mov      x20, x0
0x00016ee4  ldr      x2, [x19, #0x20]
0x00016ee8  bl       #0x5b240   ; CALL objc_msgSend$setLanguage:
0x00016eec  mov      x0, x20
0x00016ef0  ldp      x29, x30, [sp, #0x10]
0x00016ef4  ldp      x20, x19, [sp], #0x20
0x00016ef8  b        #0x55d78   ; CALL _objc_release

=== -[OMCRootListController setLanguage:]  va=0x16f54 size=100 types=v24@0:8@16
0x00016f54  stp      x20, x19, [sp, #-0x20]!
0x00016f58  stp      x29, x30, [sp, #0x10]
0x00016f5c  add      x29, sp, #0x10
0x00016f60  mov      x1, x2
0x00016f64  mov      x19, x0
0x00016f68  adrp     x0, #0x78000
0x00016f6c  add      x0, x0, #0x908   ; STR "language"
0x00016f70  adrp     x20, #0x75000
0x00016f74  add      x20, x20, #0x28   ; STR "com.anlai.omnicar"
0x00016f78  mov      x2, x20
0x00016f7c  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x00016f80  mov      x0, x20
0x00016f84  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x00016f88  mov      x0, x19
0x00016f8c  bl       #0x56500   ; CALL objc_msgSend$applyLanguage
0x00016f90  adrp     x8, #0x74000
0x00016f94  ldr      x8, [x8, #0x368]   ; @GOT _OBJC_IVAR_$_PSListController._specifiers
0x00016f98  ldrsw    x8, [x8]   ; @GOT ___objc_personality_v0
0x00016f9c  ldr      x0, [x19, x8]
0x00016fa0  str      xzr, [x19, x8]
0x00016fa4  bl       #0x55d78   ; CALL _objc_release
0x00016fa8  mov      x0, x19
0x00016fac  ldp      x29, x30, [sp, #0x10]
0x00016fb0  ldp      x20, x19, [sp], #0x20
0x00016fb4  b        #0x59d40   ; CALL objc_msgSend$reloadSpecifiers

=== -[OMCRootListController headerView]  va=0x16fb8 size=276 types=@16@0:8
0x00016fb8  stp      x22, x21, [sp, #-0x30]!
0x00016fbc  stp      x20, x19, [sp, #0x10]
0x00016fc0  stp      x29, x30, [sp, #0x20]
0x00016fc4  add      x29, sp, #0x20
0x00016fc8  mov      x19, x0
0x00016fcc  bl       #0x57ee0   ; CALL objc_msgSend$headerCard
0x00016fd0  mov      x29, x29
0x00016fd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016fd8  mov      x20, x0
0x00016fdc  bl       #0x55d78   ; CALL _objc_release
0x00016fe0  cbnz     x20, #0x170b0
0x00016fe4  adrp     x8, #0x8e000
0x00016fe8  ldr      x0, [x8, #0xaf0]   ; @CLASS OMCHeaderCard
0x00016fec  bl       #0x55c7c   ; CALL _objc_alloc
0x00016ff0  mov      x20, x0
0x00016ff4  mov      x0, x19
0x00016ff8  bl       #0x5df60   ; CALL objc_msgSend$view
0x00016ffc  mov      x29, x29
0x00017000  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017004  mov      x21, x0
0x00017008  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0001700c  adrp     x8, #0x65000
0x00017010  ldr      d3, [x8, #0x678]
0x00017014  fmov     d0, xzr
0x00017018  fmov     d1, xzr
0x0001701c  mov      x0, x20
0x00017020  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x00017024  mov      x20, x0
0x00017028  mov      x0, x19
0x0001702c  mov      x2, x20
0x00017030  bl       #0x5afc0   ; CALL objc_msgSend$setHeaderCard:
0x00017034  mov      x0, x20
0x00017038  bl       #0x55d78   ; CALL _objc_release
0x0001703c  mov      x0, x21
0x00017040  bl       #0x55d78   ; CALL _objc_release
0x00017044  mov      x0, x19
0x00017048  bl       #0x57ee0   ; CALL objc_msgSend$headerCard
0x0001704c  mov      x29, x29
0x00017050  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017054  mov      x20, x0
0x00017058  mov      w2, #2
0x0001705c  bl       #0x5a500   ; CALL objc_msgSend$setAutoresizingMask:
0x00017060  mov      x0, x20
0x00017064  bl       #0x55d78   ; CALL _objc_release
0x00017068  mov      x0, x19
0x0001706c  bl       #0x57ee0   ; CALL objc_msgSend$headerCard
0x00017070  mov      x29, x29
0x00017074  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017078  mov      x20, x0
0x0001707c  bl       #0x5dbc0   ; CALL objc_msgSend$toggle
0x00017080  mov      x29, x29
0x00017084  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017088  mov      x21, x0
0x0001708c  adrp     x8, #0x8b000
0x00017090  ldr      x3, [x8, #0xe50]   ; @SEL "masterToggled:"
0x00017094  mov      x2, x19
0x00017098  mov      w4, #0x1000
0x0001709c  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x000170a0  mov      x0, x21
0x000170a4  bl       #0x55d78   ; CALL _objc_release
0x000170a8  mov      x0, x20
0x000170ac  bl       #0x55d78   ; CALL _objc_release
0x000170b0  mov      x0, x19
0x000170b4  bl       #0x5dd40   ; CALL objc_msgSend$updateHeaderStatus
0x000170b8  mov      x0, x19
0x000170bc  ldp      x29, x30, [sp, #0x20]
0x000170c0  ldp      x20, x19, [sp, #0x10]
0x000170c4  ldp      x22, x21, [sp], #0x30
0x000170c8  b        #0x57ee0   ; CALL objc_msgSend$headerCard

=== -[OMCRootListController updateHeaderStatus]  va=0x170cc size=40 types=v16@0:8
0x000170cc  stp      x20, x19, [sp, #-0x20]!
0x000170d0  stp      x29, x30, [sp, #0x10]
0x000170d4  add      x29, sp, #0x10
0x000170d8  mov      x19, x0
0x000170dc  bl       #0x18c50   ; CALL _OMCEnabled
0x000170e0  mov      x2, x0
0x000170e4  mov      x0, x19
0x000170e8  ldp      x29, x30, [sp, #0x10]
0x000170ec  ldp      x20, x19, [sp], #0x20
0x000170f0  b        #0x5dd60   ; CALL objc_msgSend$updateHeaderStatusEnabled:

=== -[OMCRootListController updateHeaderStatusEnabled:]  va=0x170f4 size=260 types=v20@0:8B16
0x000170f4  stp      x24, x23, [sp, #-0x40]!
0x000170f8  stp      x22, x21, [sp, #0x10]
0x000170fc  stp      x20, x19, [sp, #0x20]
0x00017100  stp      x29, x30, [sp, #0x30]
0x00017104  add      x29, sp, #0x30
0x00017108  mov      x19, x2
0x0001710c  mov      x20, x0
0x00017110  bl       #0x54bb0   ; CALL _OMCExpired
0x00017114  mov      x21, x0
0x00017118  mov      x0, x20
0x0001711c  bl       #0x57ee0   ; CALL objc_msgSend$headerCard
0x00017120  mov      x29, x29
0x00017124  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017128  mov      x22, x0
0x0001712c  adrp     x0, #0x78000
0x00017130  add      x0, x0, #0x928   ; STR "HEADER_TAGLINE"
0x00017134  bl       #0x17e20   ; CALL _L
0x00017138  mov      x29, x29
0x0001713c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017140  mov      x23, x0
0x00017144  adrp     x8, #0x76000
0x00017148  add      x8, x8, #0x268   ; STR "STATUS_OFF"
0x0001714c  adrp     x9, #0x78000
0x00017150  add      x9, x9, #0x968   ; STR "STATUS_ON"
0x00017154  cmp      w19, #0
0x00017158  csel     x8, x9, x8, ne
0x0001715c  adrp     x9, #0x78000
0x00017160  add      x9, x9, #0x948   ; STR "STATUS_EXPIRED"
0x00017164  cmp      w21, #0
0x00017168  csel     x0, x9, x8, ne
0x0001716c  bl       #0x17e20   ; CALL _L
0x00017170  mov      x29, x29
0x00017174  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017178  mov      x24, x0
0x0001717c  eor      w21, w21, #1
0x00017180  and      w4, w19, w21
0x00017184  mov      x0, x22
0x00017188  mov      x2, x23
0x0001718c  mov      x3, x24
0x00017190  bl       #0x5dda0   ; CALL objc_msgSend$updateWithTagline:status:enabled:
0x00017194  mov      x0, x24
0x00017198  bl       #0x55d78   ; CALL _objc_release
0x0001719c  mov      x0, x23
0x000171a0  bl       #0x55d78   ; CALL _objc_release
0x000171a4  mov      x0, x22
0x000171a8  bl       #0x55d78   ; CALL _objc_release
0x000171ac  mov      x0, x20
0x000171b0  bl       #0x57ee0   ; CALL objc_msgSend$headerCard
0x000171b4  mov      x29, x29
0x000171b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000171bc  mov      x19, x0
0x000171c0  bl       #0x5dbc0   ; CALL objc_msgSend$toggle
0x000171c4  mov      x29, x29
0x000171c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000171cc  mov      x20, x0
0x000171d0  mov      x2, x21
0x000171d4  bl       #0x5ada0   ; CALL objc_msgSend$setEnabled:
0x000171d8  mov      x0, x20
0x000171dc  bl       #0x55d78   ; CALL _objc_release
0x000171e0  mov      x0, x19
0x000171e4  ldp      x29, x30, [sp, #0x30]
0x000171e8  ldp      x20, x19, [sp, #0x20]
0x000171ec  ldp      x22, x21, [sp, #0x10]
0x000171f0  ldp      x24, x23, [sp], #0x40
0x000171f4  b        #0x55d78   ; CALL _objc_release

=== -[OMCRootListController masterToggled:]  va=0x171f8 size=152 types=v24@0:8@16
0x000171f8  stp      x22, x21, [sp, #-0x30]!
0x000171fc  stp      x20, x19, [sp, #0x10]
0x00017200  stp      x29, x30, [sp, #0x20]
0x00017204  add      x29, sp, #0x20
0x00017208  mov      x19, x2
0x0001720c  mov      x20, x0
0x00017210  adrp     x8, #0x8e000
0x00017214  ldr      x21, [x8, #0x928]   ; @CLASS NSNumber
0x00017218  mov      x0, x2
0x0001721c  bl       #0x55d84   ; CALL _objc_retain
0x00017220  mov      x0, x19
0x00017224  bl       #0x588c0   ; CALL objc_msgSend$isOn
0x00017228  mov      x2, x0
0x0001722c  mov      x0, x21
0x00017230  bl       #0x592c0   ; CALL objc_msgSend$numberWithBool:
0x00017234  mov      x1, x0
0x00017238  adrp     x0, #0x78000
0x0001723c  add      x0, x0, #0x988   ; STR "enabled"
0x00017240  adrp     x21, #0x75000
0x00017244  add      x21, x21, #0x28   ; STR "com.anlai.omnicar"
0x00017248  mov      x2, x21
0x0001724c  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x00017250  mov      x0, x21
0x00017254  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x00017258  adrp     x0, #0x61000
0x0001725c  add      x0, x0, #0x1b1   ; CSTR "com.anlai.omnicar/prefschanged"
0x00017260  bl       #0x55c70   ; CALL _notify_post
0x00017264  mov      x0, x19
0x00017268  bl       #0x588c0   ; CALL objc_msgSend$isOn
0x0001726c  mov      x21, x0
0x00017270  mov      x0, x19
0x00017274  bl       #0x55d78   ; CALL _objc_release
0x00017278  mov      x0, x20
0x0001727c  mov      x2, x21
0x00017280  ldp      x29, x30, [sp, #0x20]
0x00017284  ldp      x20, x19, [sp, #0x10]
0x00017288  ldp      x22, x21, [sp], #0x30
0x0001728c  b        #0x5dd60   ; CALL objc_msgSend$updateHeaderStatusEnabled:

=== -[OMCRootListController tableView:cellForRowAtIndexPath:]  va=0x17290 size=80 types=@32@0:8@16@24
0x00017290  sub      sp, sp, #0x30
0x00017294  stp      x20, x19, [sp, #0x10]
0x00017298  stp      x29, x30, [sp, #0x20]
0x0001729c  add      x29, sp, #0x20
0x000172a0  adrp     x8, #0x8e000
0x000172a4  ldr      x8, [x8, #0xd38]   ; @SUPER OMCRootListController
0x000172a8  stp      x0, x8, [sp]
0x000172ac  adrp     x8, #0x8b000
0x000172b0  ldr      x1, [x8, #0xde0]   ; @SEL "tableView:cellForRowAtIndexPath:"
0x000172b4  mov      x0, sp
0x000172b8  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x000172bc  mov      x29, x29
0x000172c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000172c4  mov      x19, x0
0x000172c8  bl       #0x19168   ; CALL _OMCStyleCell
0x000172cc  mov      x0, x19
0x000172d0  ldp      x29, x30, [sp, #0x20]
0x000172d4  ldp      x20, x19, [sp, #0x10]
0x000172d8  add      sp, sp, #0x30
0x000172dc  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCRootListController tableView:willDisplayHeaderView:forSection:]  va=0x172e0 size=172 types=v40@0:8@16@24q32
0x000172e0  sub      sp, sp, #0x50
0x000172e4  stp      x24, x23, [sp, #0x10]
0x000172e8  stp      x22, x21, [sp, #0x20]
0x000172ec  stp      x20, x19, [sp, #0x30]
0x000172f0  stp      x29, x30, [sp, #0x40]
0x000172f4  add      x29, sp, #0x40
0x000172f8  mov      x21, x4
0x000172fc  mov      x20, x3
0x00017300  mov      x19, x2
0x00017304  mov      x23, x1
0x00017308  mov      x22, x0
0x0001730c  mov      x0, x2
0x00017310  bl       #0x55d84   ; CALL _objc_retain
0x00017314  mov      x0, x20
0x00017318  bl       #0x55d84   ; CALL _objc_retain
0x0001731c  adrp     x8, #0x8e000
0x00017320  ldr      x0, [x8, #0xa18]   ; @CLASS PSListController
0x00017324  mov      x2, x23
0x00017328  bl       #0x586e0   ; CALL objc_msgSend$instancesRespondToSelector:
0x0001732c  cbz      w0, #0x17358
0x00017330  adrp     x8, #0x8e000
0x00017334  ldr      x8, [x8, #0xd38]   ; @SUPER OMCRootListController
0x00017338  stp      x22, x8, [sp]
0x0001733c  adrp     x8, #0x8b000
0x00017340  ldr      x1, [x8, #0xde8]   ; @SEL "tableView:willDisplayHeaderView:forSection:"
0x00017344  mov      x0, sp
0x00017348  mov      x2, x19
0x0001734c  mov      x3, x20
0x00017350  mov      x4, x21
0x00017354  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00017358  mov      x0, x20
0x0001735c  mov      w1, #1
0x00017360  bl       #0x19300   ; CALL _OMCStyleHeaderFooter
0x00017364  mov      x0, x20
0x00017368  bl       #0x55d78   ; CALL _objc_release
0x0001736c  mov      x0, x19
0x00017370  bl       #0x55d78   ; CALL _objc_release
0x00017374  ldp      x29, x30, [sp, #0x40]
0x00017378  ldp      x20, x19, [sp, #0x30]
0x0001737c  ldp      x22, x21, [sp, #0x20]
0x00017380  ldp      x24, x23, [sp, #0x10]
0x00017384  add      sp, sp, #0x50
0x00017388  ret      

=== -[OMCRootListController tableView:willDisplayFooterView:forSection:]  va=0x1738c size=172 types=v40@0:8@16@24q32
0x0001738c  sub      sp, sp, #0x50
0x00017390  stp      x24, x23, [sp, #0x10]
0x00017394  stp      x22, x21, [sp, #0x20]
0x00017398  stp      x20, x19, [sp, #0x30]
0x0001739c  stp      x29, x30, [sp, #0x40]
0x000173a0  add      x29, sp, #0x40
0x000173a4  mov      x21, x4
0x000173a8  mov      x20, x3
0x000173ac  mov      x19, x2
0x000173b0  mov      x23, x1
0x000173b4  mov      x22, x0
0x000173b8  mov      x0, x2
0x000173bc  bl       #0x55d84   ; CALL _objc_retain
0x000173c0  mov      x0, x20
0x000173c4  bl       #0x55d84   ; CALL _objc_retain
0x000173c8  adrp     x8, #0x8e000
0x000173cc  ldr      x0, [x8, #0xa18]   ; @CLASS PSListController
0x000173d0  mov      x2, x23
0x000173d4  bl       #0x586e0   ; CALL objc_msgSend$instancesRespondToSelector:
0x000173d8  cbz      w0, #0x17404
0x000173dc  adrp     x8, #0x8e000
0x000173e0  ldr      x8, [x8, #0xd38]   ; @SUPER OMCRootListController
0x000173e4  stp      x22, x8, [sp]
0x000173e8  adrp     x8, #0x8b000
0x000173ec  ldr      x1, [x8, #0xdf0]   ; @SEL "tableView:willDisplayFooterView:forSection:"
0x000173f0  mov      x0, sp
0x000173f4  mov      x2, x19
0x000173f8  mov      x3, x20
0x000173fc  mov      x4, x21
0x00017400  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00017404  mov      x0, x20
0x00017408  mov      w1, #0
0x0001740c  bl       #0x19300   ; CALL _OMCStyleHeaderFooter
0x00017410  mov      x0, x20
0x00017414  bl       #0x55d78   ; CALL _objc_release
0x00017418  mov      x0, x19
0x0001741c  bl       #0x55d78   ; CALL _objc_release
0x00017420  ldp      x29, x30, [sp, #0x40]
0x00017424  ldp      x20, x19, [sp, #0x30]
0x00017428  ldp      x22, x21, [sp, #0x20]
0x0001742c  ldp      x24, x23, [sp, #0x10]
0x00017430  add      sp, sp, #0x50
0x00017434  ret      

=== -[OMCRootListController showMessage:]  va=0x17438 size=192 types=v24@0:8@16
0x00017438  stp      x22, x21, [sp, #-0x30]!
0x0001743c  stp      x20, x19, [sp, #0x10]
0x00017440  stp      x29, x30, [sp, #0x20]
0x00017444  add      x29, sp, #0x20
0x00017448  mov      x3, x2
0x0001744c  mov      x19, x0
0x00017450  adrp     x8, #0x8e000
0x00017454  ldr      x0, [x8, #0x9b8]   ; @CLASS UIAlertController
0x00017458  adrp     x2, #0x75000
0x0001745c  add      x2, x2, #0x508   ; STR "OmniCar"
0x00017460  mov      w4, #1
0x00017464  bl       #0x56280   ; CALL objc_msgSend$alertControllerWithTitle:message:preferredStyle:
0x00017468  mov      x29, x29
0x0001746c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017470  mov      x20, x0
0x00017474  adrp     x8, #0x8e000
0x00017478  ldr      x21, [x8, #0x9c0]   ; @CLASS UIAlertAction
0x0001747c  adrp     x0, #0x76000
0x00017480  add      x0, x0, #0xea8   ; STR "OK"
0x00017484  bl       #0x17e20   ; CALL _L
0x00017488  mov      x29, x29
0x0001748c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017490  mov      x22, x0
0x00017494  mov      x0, x21
0x00017498  mov      x2, x22
0x0001749c  mov      x3, #0
0x000174a0  mov      x4, #0
0x000174a4  bl       #0x55fc0   ; CALL objc_msgSend$actionWithTitle:style:handler:
0x000174a8  mov      x29, x29
0x000174ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000174b0  mov      x21, x0
0x000174b4  mov      x0, x20
0x000174b8  mov      x2, x21
0x000174bc  bl       #0x56000   ; CALL objc_msgSend$addAction:
0x000174c0  mov      x0, x21
0x000174c4  bl       #0x55d78   ; CALL _objc_release
0x000174c8  mov      x0, x22
0x000174cc  bl       #0x55d78   ; CALL _objc_release
0x000174d0  mov      x0, x19
0x000174d4  mov      x2, x20
0x000174d8  mov      w3, #1
0x000174dc  mov      x4, #0
0x000174e0  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x000174e4  mov      x0, x20
0x000174e8  ldp      x29, x30, [sp, #0x20]
0x000174ec  ldp      x20, x19, [sp, #0x10]
0x000174f0  ldp      x22, x21, [sp], #0x30
0x000174f4  b        #0x55d78   ; CALL _objc_release

=== -[OMCRootListController sendLog]  va=0x174f8 size=8 types=v16@0:8
0x000174f8  mov      x1, #0
0x000174fc  b        #0xff10   ; CALL _OMCShareReport

=== -[OMCRootListController showGuide]  va=0x17500 size=320 types=v16@0:8
0x00017500  sub      sp, sp, #0x60
0x00017504  stp      x22, x21, [sp, #0x30]
0x00017508  stp      x20, x19, [sp, #0x40]
0x0001750c  stp      x29, x30, [sp, #0x50]
0x00017510  add      x29, sp, #0x50
0x00017514  mov      x19, x0
0x00017518  bl       #0x599c0   ; CALL objc_msgSend$presentedViewController
0x0001751c  mov      x29, x29
0x00017520  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017524  mov      x20, x0
0x00017528  bl       #0x55d78   ; CALL _objc_release
0x0001752c  cbnz     x20, #0x175c4
0x00017530  add      x0, sp, #0x28
0x00017534  mov      x1, x19
0x00017538  bl       #0x55d18   ; CALL _objc_initWeak
0x0001753c  adrp     x8, #0x8e000
0x00017540  adrp     x9, #0x74000
0x00017544  ldr      x9, [x9, #0x378]   ; @GOT __NSConcreteStackBlock
0x00017548  ldr      x20, [x8, #0xa20]   ; @CLASS OMCOnboardingController
0x0001754c  str      x9, [sp]
0x00017550  adrp     x8, #0x65000
0x00017554  ldr      d0, [x8, #0x600]
0x00017558  adrp     x8, #0x17000
0x0001755c  add      x8, x8, #0x5f8
0x00017560  str      d0, [sp, #8]
0x00017564  adrp     x9, #0x74000
0x00017568  add      x9, x9, #0x820
0x0001756c  stp      x8, x9, [sp, #0x10]
0x00017570  mov      x21, sp
0x00017574  add      x0, x21, #0x20
0x00017578  add      x1, sp, #0x28
0x0001757c  bl       #0x55cd0   ; CALL _objc_copyWeak
0x00017580  mov      x2, sp
0x00017584  mov      x0, x20
0x00017588  bl       #0x57e60   ; CALL objc_msgSend$guideNavigationControllerWithCompletion:
0x0001758c  mov      x29, x29
0x00017590  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017594  mov      x20, x0
0x00017598  mov      x0, x19
0x0001759c  mov      x2, x20
0x000175a0  mov      w3, #1
0x000175a4  mov      x4, #0
0x000175a8  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x000175ac  mov      x0, x20
0x000175b0  bl       #0x55d78   ; CALL _objc_release
0x000175b4  add      x0, x21, #0x20
0x000175b8  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x000175bc  add      x0, sp, #0x28
0x000175c0  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x000175c4  ldp      x29, x30, [sp, #0x50]
0x000175c8  ldp      x20, x19, [sp, #0x40]
0x000175cc  ldp      x22, x21, [sp, #0x30]
0x000175d0  add      sp, sp, #0x60
0x000175d4  ret      
0x000175d8  b        #0x175dc
0x000175dc  mov      x19, x0
0x000175e0  add      x0, x21, #0x20
0x000175e4  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x000175e8  add      x0, sp, #0x28
0x000175ec  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x000175f0  mov      x0, x19
0x000175f4  bl       #0x55b80   ; CALL __Unwind_Resume
0x000175f8  stp      x20, x19, [sp, #-0x20]!
0x000175fc  stp      x29, x30, [sp, #0x10]
0x00017600  add      x29, sp, #0x10
0x00017604  mov      x19, x0
0x00017608  add      x0, x0, #0x20
0x0001760c  bl       #0x55d24   ; CALL _objc_loadWeakRetained
0x00017610  mov      x20, x0
0x00017614  bl       #0x59d40   ; CALL objc_msgSend$reloadSpecifiers
0x00017618  mov      x0, x20
0x0001761c  bl       #0x55d78   ; CALL _objc_release
0x00017620  add      x0, x19, #0x20
0x00017624  bl       #0x55d24   ; CALL _objc_loadWeakRetained
0x00017628  mov      x19, x0
0x0001762c  bl       #0x5dd40   ; CALL objc_msgSend$updateHeaderStatus
0x00017630  mov      x0, x19
0x00017634  ldp      x29, x30, [sp, #0x10]
0x00017638  ldp      x20, x19, [sp], #0x20
0x0001763c  b        #0x55d78   ; CALL _objc_release

=== -[OMCRootListController showWhatsNew]  va=0x17654 size=112 types=v16@0:8
0x00017654  stp      x20, x19, [sp, #-0x20]!
0x00017658  stp      x29, x30, [sp, #0x10]
0x0001765c  add      x29, sp, #0x10
0x00017660  mov      x19, x0
0x00017664  bl       #0x599c0   ; CALL objc_msgSend$presentedViewController
0x00017668  mov      x29, x29
0x0001766c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017670  mov      x20, x0
0x00017674  bl       #0x55d78   ; CALL _objc_release
0x00017678  cbz      x20, #0x17688
0x0001767c  ldp      x29, x30, [sp, #0x10]
0x00017680  ldp      x20, x19, [sp], #0x20
0x00017684  ret      
0x00017688  adrp     x8, #0x8e000
0x0001768c  ldr      x0, [x8, #0xad0]   ; @CLASS OMCWhatsNewController
0x00017690  bl       #0x5e140   ; CALL objc_msgSend$whatsNewNavigationController
0x00017694  mov      x29, x29
0x00017698  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001769c  mov      x20, x0
0x000176a0  mov      x0, x19
0x000176a4  mov      x2, x20
0x000176a8  mov      w3, #1
0x000176ac  mov      x4, #0
0x000176b0  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x000176b4  mov      x0, x20
0x000176b8  ldp      x29, x30, [sp, #0x10]
0x000176bc  ldp      x20, x19, [sp], #0x20
0x000176c0  b        #0x55d78   ; CALL _objc_release

=== -[OMCRootListController rescueRestore]  va=0x176c4 size=104 types=v16@0:8
0x000176c4  stp      x20, x19, [sp, #-0x20]!
0x000176c8  stp      x29, x30, [sp, #0x10]
0x000176cc  add      x29, sp, #0x10
0x000176d0  mov      x19, x0
0x000176d4  bl       #0x7af8   ; CALL _OMCRescueRestore
0x000176d8  adrp     x8, #0x74000
0x000176dc  ldr      x8, [x8, #0x368]   ; @GOT _OBJC_IVAR_$_PSListController._specifiers
0x000176e0  ldrsw    x8, [x8]   ; @GOT ___objc_personality_v0
0x000176e4  ldr      x0, [x19, x8]
0x000176e8  str      xzr, [x19, x8]
0x000176ec  bl       #0x55d78   ; CALL _objc_release
0x000176f0  mov      x0, x19
0x000176f4  bl       #0x59d40   ; CALL objc_msgSend$reloadSpecifiers
0x000176f8  adrp     x0, #0x78000
0x000176fc  add      x0, x0, #0x9a8   ; STR "RESCUE_RESTORED"
0x00017700  bl       #0x17e20   ; CALL _L
0x00017704  mov      x29, x29
0x00017708  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001770c  mov      x20, x0
0x00017710  mov      x0, x19
0x00017714  mov      x2, x20
0x00017718  bl       #0x5ca40   ; CALL objc_msgSend$showMessage:
0x0001771c  mov      x0, x20
0x00017720  ldp      x29, x30, [sp, #0x10]
0x00017724  ldp      x20, x19, [sp], #0x20
0x00017728  b        #0x55d78   ; CALL _objc_release

=== -[OMCRootListController respring]  va=0x1772c size=504 types=v16@0:8
0x0001772c  sub      sp, sp, #0x70
0x00017730  stp      x24, x23, [sp, #0x30]
0x00017734  stp      x22, x21, [sp, #0x40]
0x00017738  stp      x20, x19, [sp, #0x50]
0x0001773c  stp      x29, x30, [sp, #0x60]
0x00017740  add      x29, sp, #0x60
0x00017744  mov      x20, x0
0x00017748  adrp     x8, #0x8e000
0x0001774c  ldr      x19, [x8, #0x9b8]   ; @CLASS UIAlertController
0x00017750  adrp     x0, #0x78000
0x00017754  add      x0, x0, #0x9c8   ; STR "RESPRING_CONFIRM"
0x00017758  bl       #0x17e20   ; CALL _L
0x0001775c  mov      x29, x29
0x00017760  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017764  mov      x21, x0
0x00017768  mov      x0, x19
0x0001776c  mov      x2, x21
0x00017770  mov      x3, #0
0x00017774  mov      w4, #1
0x00017778  bl       #0x56280   ; CALL objc_msgSend$alertControllerWithTitle:message:preferredStyle:
0x0001777c  mov      x29, x29
0x00017780  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017784  mov      x19, x0
0x00017788  mov      x0, x21
0x0001778c  bl       #0x55d78   ; CALL _objc_release
0x00017790  adrp     x23, #0x8e000
0x00017794  ldr      x21, [x23, #0x9c0]   ; @CLASS UIAlertAction
0x00017798  adrp     x0, #0x78000
0x0001779c  add      x0, x0, #0x9e8   ; STR "CANCEL"
0x000177a0  bl       #0x17e20   ; CALL _L
0x000177a4  mov      x29, x29
0x000177a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000177ac  mov      x22, x0
0x000177b0  mov      x0, x21
0x000177b4  mov      x2, x22
0x000177b8  mov      w3, #1
0x000177bc  mov      x4, #0
0x000177c0  bl       #0x55fc0   ; CALL objc_msgSend$actionWithTitle:style:handler:
0x000177c4  mov      x29, x29
0x000177c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000177cc  mov      x21, x0
0x000177d0  mov      x0, x19
0x000177d4  mov      x2, x21
0x000177d8  bl       #0x56000   ; CALL objc_msgSend$addAction:
0x000177dc  mov      x0, x21
0x000177e0  bl       #0x55d78   ; CALL _objc_release
0x000177e4  mov      x0, x22
0x000177e8  bl       #0x55d78   ; CALL _objc_release
0x000177ec  add      x0, sp, #0x28
0x000177f0  mov      x1, x20
0x000177f4  bl       #0x55d18   ; CALL _objc_initWeak
0x000177f8  ldr      x22, [x23, #0x9c0]   ; @CLASS UIAlertAction
0x000177fc  adrp     x0, #0x78000
0x00017800  add      x0, x0, #0x8a8   ; STR "RESPRING"
0x00017804  bl       #0x17e20   ; CALL _L
0x00017808  mov      x29, x29
0x0001780c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00017810  mov      x21, x0
0x00017814  adrp     x8, #0x74000
0x00017818  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x0001781c  str      x8, [sp]
0x00017820  adrp     x8, #0x65000
0x00017824  ldr      d0, [x8, #0x600]
0x00017828  adrp     x8, #0x17000
0x0001782c  add      x8, x8, #0x8f8
0x00017830  str      d0, [sp, #8]
0x00017834  adrp     x9, #0x74000
0x00017838  add      x9, x9, #0x850
0x0001783c  stp      x8, x9, [sp, #0x10]
0x00017840  mov      x23, sp
0x00017844  add      x0, x23, #0x20   ; SEL "widthAnchor"
0x00017848  add      x1, sp, #0x28
0x0001784c  bl       #0x55cd0   ; CALL _objc_copyWeak
0x00017850  mov      x4, sp
0x00017854  mov      x0, x22
0x00017858  mov      x2, x21
0x0001785c  mov      w3, #2
0x00017860  bl       #0x55fc0   ; CALL objc_msgSend$actionWithTitle:style:handler:
0x00017864  mov      x29, x29
0x00017868  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001786c  mov      x22, x0
0x00017870  mov      x0, x19
0x00017874  mov      x2, x22
0x00017878  bl       #0x56000   ; CALL objc_msgSend$addAction:
0x0001787c  mov      x0, x22
0x00017880  bl       #0x55d78   ; CALL _objc_release
0x00017884  mov      x0, x21
0x00017888  bl       #0x55d78   ; CALL _objc_release
0x0001788c  mov      x0, x20
0x00017890  mov      x2, x19
0x00017894  mov      w3, #1
0x00017898  mov      x4, #0
0x0001789c  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x000178a0  add      x0, x23, #0x20   ; SEL "widthAnchor"
0x000178a4  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x000178a8  add      x0, sp, #0x28
0x000178ac  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x000178b0  mov      x0, x19
0x000178b4  bl       #0x55d78   ; CALL _objc_release
0x000178b8  ldp      x29, x30, [sp, #0x60]
0x000178bc  ldp      x20, x19, [sp, #0x50]
0x000178c0  ldp      x22, x21, [sp, #0x40]
0x000178c4  ldp      x24, x23, [sp, #0x30]
0x000178c8  add      sp, sp, #0x70
0x000178cc  ret      
0x000178d0  b        #0x178dc
0x000178d4  mov      x19, x0
0x000178d8  b        #0x178e8
0x000178dc  mov      x19, x0
0x000178e0  add      x0, x23, #0x20   ; SEL "widthAnchor"
0x000178e4  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x000178e8  add      x0, sp, #0x28
0x000178ec  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x000178f0  mov      x0, x19
0x000178f4  bl       #0x55b80   ; CALL __Unwind_Resume
0x000178f8  stp      x20, x19, [sp, #-0x20]!
0x000178fc  stp      x29, x30, [sp, #0x10]
0x00017900  add      x29, sp, #0x10
0x00017904  add      x0, x0, #0x20   ; SEL "writeToFile:atomically:encoding:error:"
0x00017908  bl       #0x55d24   ; CALL _objc_loadWeakRetained
0x0001790c  mov      x19, x0
0x00017910  bl       #0x596a0   ; CALL objc_msgSend$performRespring
0x00017914  mov      x0, x19
0x00017918  ldp      x29, x30, [sp, #0x10]
0x0001791c  ldp      x20, x19, [sp], #0x20
0x00017920  b        #0x55d78   ; CALL _objc_release

=== -[OMCRootListController performRespring]  va=0x17924 size=4 types=v16@0:8
0x00017924  b        #0xfc64   ; CALL _OMCRespring

=== -[OMCRootListController headerCard]  va=0x17928 size=16 types=@16@0:8
0x00017928  adrp     x8, #0x8e000
0x0001792c  ldrsw    x8, [x8, #0xe24]
0x00017930  ldr      x0, [x0, x8]
0x00017934  ret      

=== -[OMCRootListController setHeaderCard:]  va=0x17938 size=64 types=v24@0:8@16
0x00017938  stp      x22, x21, [sp, #-0x30]!
0x0001793c  stp      x20, x19, [sp, #0x10]
0x00017940  stp      x29, x30, [sp, #0x20]
0x00017944  add      x29, sp, #0x20
0x00017948  mov      x19, x2
0x0001794c  mov      x20, x0
0x00017950  adrp     x8, #0x8e000
0x00017954  ldrsw    x21, [x8, #0xe24]
0x00017958  mov      x0, x2
0x0001795c  bl       #0x55d84   ; CALL _objc_retain
0x00017960  ldr      x0, [x20, x21]
0x00017964  str      x19, [x20, x21]
0x00017968  ldp      x29, x30, [sp, #0x20]
0x0001796c  ldp      x20, x19, [sp, #0x10]
0x00017970  ldp      x22, x21, [sp], #0x30
0x00017974  b        #0x55d78   ; CALL _objc_release

=== -[OMCRootListController supportState]  va=0x17978 size=16 types=@16@0:8
0x00017978  adrp     x8, #0x8e000
0x0001797c  ldrsw    x8, [x8, #0xe28]
0x00017980  ldr      x0, [x0, x8]
0x00017984  ret      

=== -[OMCRootListController setSupportState:]  va=0x17988 size=12 types=v24@0:8@16
0x00017988  adrp     x8, #0x8e000
0x0001798c  ldrsw    x3, [x8, #0xe28]
0x00017990  b        #0x55dc0   ; CALL _objc_setProperty_nonatomic_copy

=== -[OMCRootListController .cxx_destruct]  va=0x17994 size=64 types=v16@0:8
0x00017994  stp      x20, x19, [sp, #-0x20]!
0x00017998  stp      x29, x30, [sp, #0x10]
0x0001799c  add      x29, sp, #0x10
0x000179a0  mov      x19, x0
0x000179a4  adrp     x8, #0x8e000
0x000179a8  ldrsw    x8, [x8, #0xe28]
0x000179ac  add      x0, x0, x8
0x000179b0  mov      x1, #0
0x000179b4  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000179b8  adrp     x8, #0x8e000
0x000179bc  ldrsw    x8, [x8, #0xe24]
0x000179c0  add      x0, x19, x8
0x000179c4  mov      x1, #0
0x000179c8  ldp      x29, x30, [sp, #0x10]
0x000179cc  ldp      x20, x19, [sp], #0x20
0x000179d0  b        #0x55dcc   ; CALL _objc_storeStrong
