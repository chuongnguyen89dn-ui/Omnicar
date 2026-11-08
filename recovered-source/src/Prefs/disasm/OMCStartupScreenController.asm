=== -[OMCStartupScreenController currentStyle]  va=0x3cf7c size=120 types=q16@0:8
0x0003cf7c  stp      x20, x19, [sp, #-0x20]!
0x0003cf80  stp      x29, x30, [sp, #0x10]
0x0003cf84  add      x29, sp, #0x10
0x0003cf88  adrp     x0, #0x7c000
0x0003cf8c  add      x0, x0, #0x268   ; STR "startupScreenStyle"
0x0003cf90  adrp     x1, #0x75000
0x0003cf94  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x0003cf98  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x0003cf9c  mov      x19, x0
0x0003cfa0  cbz      x0, #0x3cfb8
0x0003cfa4  mov      x0, x19
0x0003cfa8  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0003cfac  cmp      x0, #0xb
0x0003cfb0  csel     x20, x0, xzr, lo
0x0003cfb4  b        #0x3cfbc
0x0003cfb8  mov      x20, #0
0x0003cfbc  mov      x0, x19
0x0003cfc0  bl       #0x55d78   ; CALL _objc_release
0x0003cfc4  mov      x0, x20
0x0003cfc8  ldp      x29, x30, [sp, #0x10]
0x0003cfcc  ldp      x20, x19, [sp], #0x20
0x0003cfd0  ret      
0x0003cfd4  cbz      x0, #0x3cff0
0x0003cfd8  stp      x29, x30, [sp, #-0x10]!
0x0003cfdc  mov      x29, sp
0x0003cfe0  adrp     x1, #0x75000
0x0003cfe4  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x0003cfe8  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x0003cfec  ldp      x29, x30, [sp], #0x10
0x0003cff0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCStartupScreenController currentSound]  va=0x3cff4 size=396 types=@16@0:8
0x0003cff4  stp      x24, x23, [sp, #-0x40]!
0x0003cff8  stp      x22, x21, [sp, #0x10]
0x0003cffc  stp      x20, x19, [sp, #0x20]
0x0003d000  stp      x29, x30, [sp, #0x30]
0x0003d004  add      x29, sp, #0x30
0x0003d008  sub      sp, sp, #0x410
0x0003d00c  adrp     x8, #0x74000
0x0003d010  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0003d014  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003d018  stur     x8, [x29, #-0x38]
0x0003d01c  adrp     x0, #0x7c000
0x0003d020  add      x0, x0, #0x288   ; STR "startupScreenSoundFile"
0x0003d024  bl       #0x3d124
0x0003d028  mov      x29, x29
0x0003d02c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d030  mov      x19, x0
0x0003d034  bl       #0x58c20   ; CALL objc_msgSend$length
0x0003d038  cbz      x0, #0x3d08c
0x0003d03c  adrp     x8, #0x8e000
0x0003d040  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x0003d044  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x0003d048  mov      x29, x29
0x0003d04c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d050  mov      x20, x0
0x0003d054  adrp     x0, #0x7c000
0x0003d058  add      x0, x0, #0x2a8   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Sounds"
0x0003d05c  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0003d060  add      x1, sp, #8
0x0003d064  bl       #0x4118
0x0003d068  cbz      x0, #0x3d094
0x0003d06c  mov      x2, x0
0x0003d070  adrp     x8, #0x8e000
0x0003d074  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0003d078  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0003d07c  mov      x29, x29
0x0003d080  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d084  mov      x22, x0
0x0003d088  b        #0x3d098
0x0003d08c  mov      x21, #0
0x0003d090  b        #0x3d0e4
0x0003d094  mov      x22, #0
0x0003d098  mov      x0, x22
0x0003d09c  mov      x2, x19
0x0003d0a0  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x0003d0a4  mov      x29, x29
0x0003d0a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d0ac  mov      x23, x0
0x0003d0b0  mov      x0, x20
0x0003d0b4  mov      x2, x23
0x0003d0b8  bl       #0x57b40   ; CALL objc_msgSend$fileExistsAtPath:
0x0003d0bc  cmp      w0, #0
0x0003d0c0  csel     x21, x19, xzr, ne
0x0003d0c4  mov      x0, x21
0x0003d0c8  bl       #0x55d84   ; CALL _objc_retain
0x0003d0cc  mov      x0, x23
0x0003d0d0  bl       #0x55d78   ; CALL _objc_release
0x0003d0d4  mov      x0, x22
0x0003d0d8  bl       #0x55d78   ; CALL _objc_release
0x0003d0dc  mov      x0, x20
0x0003d0e0  bl       #0x55d78   ; CALL _objc_release
0x0003d0e4  mov      x0, x19
0x0003d0e8  bl       #0x55d78   ; CALL _objc_release
0x0003d0ec  ldur     x8, [x29, #-0x38]
0x0003d0f0  adrp     x9, #0x74000
0x0003d0f4  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0003d0f8  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0003d0fc  cmp      x9, x8
0x0003d100  b.ne     #0x3d120
0x0003d104  mov      x0, x21
0x0003d108  add      sp, sp, #0x410
0x0003d10c  ldp      x29, x30, [sp, #0x30]
0x0003d110  ldp      x20, x19, [sp, #0x20]
0x0003d114  ldp      x22, x21, [sp, #0x10]
0x0003d118  ldp      x24, x23, [sp], #0x40
0x0003d11c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0003d120  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0003d124  stp      x20, x19, [sp, #-0x20]!
0x0003d128  stp      x29, x30, [sp, #0x10]
0x0003d12c  add      x29, sp, #0x10
0x0003d130  bl       #0x3cfd4
0x0003d134  mov      x29, x29
0x0003d138  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d13c  mov      x19, x0
0x0003d140  adrp     x8, #0x8e000
0x0003d144  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0003d148  bl       #0x55d48   ; CALL _objc_opt_class
0x0003d14c  mov      x1, x0
0x0003d150  mov      x0, x19
0x0003d154  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0003d158  tst      w0, #1
0x0003d15c  csel     x20, x19, xzr, ne
0x0003d160  mov      x0, x20
0x0003d164  bl       #0x55d84   ; CALL _objc_retain
0x0003d168  mov      x0, x19
0x0003d16c  bl       #0x55d78   ; CALL _objc_release
0x0003d170  mov      x0, x20
0x0003d174  ldp      x29, x30, [sp, #0x10]
0x0003d178  ldp      x20, x19, [sp], #0x20
0x0003d17c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCStartupScreenController randomSet]  va=0x3d180 size=556 types=@16@0:8
0x0003d180  sub      sp, sp, #0x130
0x0003d184  stp      x28, x27, [sp, #0xd0]
0x0003d188  stp      x26, x25, [sp, #0xe0]
0x0003d18c  stp      x24, x23, [sp, #0xf0]
0x0003d190  stp      x22, x21, [sp, #0x100]
0x0003d194  stp      x20, x19, [sp, #0x110]
0x0003d198  stp      x29, x30, [sp, #0x120]
0x0003d19c  add      x29, sp, #0x120
0x0003d1a0  adrp     x8, #0x74000
0x0003d1a4  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0003d1a8  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003d1ac  stur     x8, [x29, #-0x58]
0x0003d1b0  adrp     x8, #0x8e000
0x0003d1b4  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x0003d1b8  bl       #0x565c0   ; CALL objc_msgSend$array
0x0003d1bc  mov      x29, x29
0x0003d1c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d1c4  mov      x19, x0
0x0003d1c8  adrp     x0, #0x7c000
0x0003d1cc  add      x0, x0, #0x2c8   ; STR "startupScreenRandomSet"
0x0003d1d0  adrp     x1, #0x75000
0x0003d1d4  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x0003d1d8  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x0003d1dc  mov      x20, x0
0x0003d1e0  adrp     x8, #0x8e000
0x0003d1e4  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0003d1e8  bl       #0x55d48   ; CALL _objc_opt_class
0x0003d1ec  mov      x1, x0
0x0003d1f0  mov      x0, x20
0x0003d1f4  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0003d1f8  tbz      w0, #0, #0x3d318
0x0003d1fc  movi     v0.16b, #0
0x0003d200  stp      q0, q0, [sp, #0x20]
0x0003d204  stp      q0, q0, [sp]
0x0003d208  mov      x0, x20
0x0003d20c  bl       #0x55d84   ; CALL _objc_retain
0x0003d210  mov      x2, sp
0x0003d214  add      x3, sp, #0x48
0x0003d218  mov      x0, x20
0x0003d21c  mov      w4, #0x10
0x0003d220  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0003d224  cbz      x0, #0x3d310
0x0003d228  mov      x21, x0
0x0003d22c  ldr      x8, [sp, #0x10]
0x0003d230  ldr      x25, [x8]   ; @SEL "whatsNewNavigationController"
0x0003d234  adrp     x26, #0x8e000
0x0003d238  mov      x27, #0
0x0003d23c  ldr      x8, [sp, #0x10]
0x0003d240  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0003d244  cmp      x8, x25
0x0003d248  b.eq     #0x3d254
0x0003d24c  mov      x0, x20
0x0003d250  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0003d254  ldr      x8, [sp, #8]
0x0003d258  ldr      x22, [x8, x27, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0003d25c  ldr      x0, [x26, #0x928]   ; @CLASS NSNumber
0x0003d260  bl       #0x55d48   ; CALL _objc_opt_class
0x0003d264  mov      x1, x0
0x0003d268  mov      x0, x22
0x0003d26c  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0003d270  tbz      w0, #0, #0x3d2e8
0x0003d274  mov      x0, x22
0x0003d278  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0003d27c  cmp      x0, #9
0x0003d280  b.hi     #0x3d2e8
0x0003d284  mov      x22, x0
0x0003d288  ldr      x0, [x26, #0x928]   ; @CLASS NSNumber
0x0003d28c  mov      x2, x22
0x0003d290  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x0003d294  mov      x29, x29
0x0003d298  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d29c  mov      x23, x0
0x0003d2a0  mov      x0, x19
0x0003d2a4  mov      x2, x23
0x0003d2a8  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0003d2ac  mov      x24, x0
0x0003d2b0  mov      x0, x23
0x0003d2b4  bl       #0x55d78   ; CALL _objc_release
0x0003d2b8  tbnz     w24, #0, #0x3d2e8
0x0003d2bc  ldr      x0, [x26, #0x928]   ; @CLASS NSNumber
0x0003d2c0  mov      x2, x22
0x0003d2c4  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x0003d2c8  mov      x29, x29
0x0003d2cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d2d0  mov      x22, x0
0x0003d2d4  mov      x0, x19
0x0003d2d8  mov      x2, x22
0x0003d2dc  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0003d2e0  mov      x0, x22
0x0003d2e4  bl       #0x55d78   ; CALL _objc_release
0x0003d2e8  add      x27, x27, #1
0x0003d2ec  cmp      x21, x27
0x0003d2f0  b.ne     #0x3d23c
0x0003d2f4  mov      x2, sp
0x0003d2f8  add      x3, sp, #0x48
0x0003d2fc  mov      x0, x20
0x0003d300  mov      w4, #0x10
0x0003d304  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0003d308  mov      x21, x0
0x0003d30c  cbnz     x0, #0x3d238
0x0003d310  mov      x0, x20
0x0003d314  bl       #0x55d78   ; CALL _objc_release
0x0003d318  mov      x0, x19
0x0003d31c  bl       #0x573c0   ; CALL objc_msgSend$count
0x0003d320  cbnz     x0, #0x3d364
0x0003d324  mov      x21, #0
0x0003d328  adrp     x23, #0x8e000
0x0003d32c  ldr      x0, [x23, #0x928]   ; @CLASS NSNumber
0x0003d330  mov      x2, x21
0x0003d334  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x0003d338  mov      x29, x29
0x0003d33c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d340  mov      x22, x0
0x0003d344  mov      x0, x19
0x0003d348  mov      x2, x22
0x0003d34c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0003d350  mov      x0, x22
0x0003d354  bl       #0x55d78   ; CALL _objc_release
0x0003d358  add      x21, x21, #1
0x0003d35c  cmp      x21, #0xa
0x0003d360  b.ne     #0x3d32c
0x0003d364  mov      x0, x20
0x0003d368  bl       #0x55d78   ; CALL _objc_release
0x0003d36c  ldur     x8, [x29, #-0x58]
0x0003d370  adrp     x9, #0x74000
0x0003d374  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0003d378  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0003d37c  cmp      x9, x8
0x0003d380  b.ne     #0x3d3a8
0x0003d384  mov      x0, x19
0x0003d388  ldp      x29, x30, [sp, #0x120]
0x0003d38c  ldp      x20, x19, [sp, #0x110]
0x0003d390  ldp      x22, x21, [sp, #0x100]
0x0003d394  ldp      x24, x23, [sp, #0xf0]
0x0003d398  ldp      x26, x25, [sp, #0xe0]
0x0003d39c  ldp      x28, x27, [sp, #0xd0]
0x0003d3a0  add      sp, sp, #0x130
0x0003d3a4  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0003d3a8  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController occasionPreviewTitle]  va=0x3d3ac size=1092 types=@16@0:8
0x0003d3ac  sub      sp, sp, #0x40
0x0003d3b0  stp      x22, x21, [sp, #0x10]
0x0003d3b4  stp      x20, x19, [sp, #0x20]
0x0003d3b8  stp      x29, x30, [sp, #0x30]
0x0003d3bc  add      x29, sp, #0x30
0x0003d3c0  adrp     x8, #0x8e000
0x0003d3c4  ldr      x20, [x8, #0x958]   ; @CLASS NSString
0x0003d3c8  adrp     x0, #0x7c000
0x0003d3cc  add      x0, x0, #0x2e8   ; STR "STARTUPSCREEN_OCCASION_PREVIEW"
0x0003d3d0  bl       #0x17e20   ; CALL _L
0x0003d3d4  mov      x29, x29
0x0003d3d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d3dc  mov      x19, x0
0x0003d3e0  adrp     x0, #0x7c000
0x0003d3e4  add      x0, x0, #0x308   ; STR "startupScreenBirthday"
0x0003d3e8  bl       #0x3d124
0x0003d3ec  mov      x29, x29
0x0003d3f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d3f4  mov      x21, x0
0x0003d3f8  bl       #0x3d47c
0x0003d3fc  sub      x8, x0, #2
0x0003d400  cmp      x8, #3
0x0003d404  b.hi     #0x3d418
0x0003d408  adrp     x9, #0x74000
0x0003d40c  add      x9, x9, #0xe28
0x0003d410  ldr      x0, [x9, x8, lsl #3]
0x0003d414  b        #0x3d420
0x0003d418  adrp     x0, #0x7d000
0x0003d41c  add      x0, x0, #0xe8   ; STR "STARTUPSCREEN_OCC_TET"
0x0003d420  bl       #0x17e20   ; CALL _L
0x0003d424  mov      x29, x29
0x0003d428  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d42c  mov      x22, x0
0x0003d430  str      x0, [sp]
0x0003d434  mov      x0, x20
0x0003d438  mov      x2, x19
0x0003d43c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0003d440  mov      x29, x29
0x0003d444  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d448  mov      x20, x0
0x0003d44c  mov      x0, x22
0x0003d450  bl       #0x55d78   ; CALL _objc_release
0x0003d454  mov      x0, x21
0x0003d458  bl       #0x55d78   ; CALL _objc_release
0x0003d45c  mov      x0, x19
0x0003d460  bl       #0x55d78   ; CALL _objc_release
0x0003d464  mov      x0, x20
0x0003d468  ldp      x29, x30, [sp, #0x30]
0x0003d46c  ldp      x20, x19, [sp, #0x20]
0x0003d470  ldp      x22, x21, [sp, #0x10]
0x0003d474  add      sp, sp, #0x40
0x0003d478  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0003d47c  sub      sp, sp, #0x80
0x0003d480  stp      x28, x27, [sp, #0x20]
0x0003d484  stp      x26, x25, [sp, #0x30]
0x0003d488  stp      x24, x23, [sp, #0x40]
0x0003d48c  stp      x22, x21, [sp, #0x50]
0x0003d490  stp      x20, x19, [sp, #0x60]
0x0003d494  stp      x29, x30, [sp, #0x70]
0x0003d498  add      x29, sp, #0x70
0x0003d49c  mov      x25, x0
0x0003d4a0  bl       #0x55d84   ; CALL _objc_retain
0x0003d4a4  adrp     x19, #0x8e000
0x0003d4a8  ldr      x0, [x19, #0x9f8]   ; @CLASS NSCalendar
0x0003d4ac  adrp     x8, #0x74000
0x0003d4b0  ldr      x8, [x8, #0x188]   ; @GOT _NSCalendarIdentifierGregorian
0x0003d4b4  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0003d4b8  bl       #0x56bc0   ; CALL objc_msgSend$calendarWithIdentifier:
0x0003d4bc  mov      x29, x29
0x0003d4c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d4c4  mov      x20, x0
0x0003d4c8  ldr      x0, [x19, #0x9f8]   ; @CLASS NSCalendar
0x0003d4cc  adrp     x8, #0x74000
0x0003d4d0  ldr      x8, [x8, #0x180]   ; @GOT _NSCalendarIdentifierChinese
0x0003d4d4  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0003d4d8  bl       #0x56bc0   ; CALL objc_msgSend$calendarWithIdentifier:
0x0003d4dc  mov      x29, x29
0x0003d4e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d4e4  mov      x21, x0
0x0003d4e8  adrp     x8, #0x8e000
0x0003d4ec  ldr      x0, [x8, #0xca8]   ; @CLASS NSTimeZone
0x0003d4f0  mov      w2, #0x6270
0x0003d4f4  bl       #0x5db00   ; CALL objc_msgSend$timeZoneForSecondsFromGMT:
0x0003d4f8  mov      x29, x29
0x0003d4fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d500  mov      x22, x0
0x0003d504  mov      x0, x21
0x0003d508  mov      x2, x22
0x0003d50c  bl       #0x5c580   ; CALL objc_msgSend$setTimeZone:
0x0003d510  mov      x0, x22
0x0003d514  bl       #0x55d78   ; CALL _objc_release
0x0003d518  adrp     x19, #0x8e000
0x0003d51c  ldr      x0, [x19, #0x978]   ; @CLASS NSDate
0x0003d520  bl       #0x575a0   ; CALL objc_msgSend$date
0x0003d524  mov      x29, x29
0x0003d528  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d52c  mov      x23, x0
0x0003d530  mov      x0, x20
0x0003d534  mov      w2, #0xc
0x0003d538  mov      x3, #0
0x0003d53c  mov      x4, #0
0x0003d540  mov      x5, x23
0x0003d544  mov      x6, #0
0x0003d548  bl       #0x575e0   ; CALL objc_msgSend$dateBySettingHour:minute:second:ofDate:options:
0x0003d54c  mov      x29, x29
0x0003d550  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d554  mov      x24, x0
0x0003d558  cbz      x0, #0x3d56c
0x0003d55c  mov      x0, x24
0x0003d560  bl       #0x55d84   ; CALL _objc_retain
0x0003d564  mov      x22, x24
0x0003d568  b        #0x3d580
0x0003d56c  ldr      x0, [x19, #0x978]   ; @CLASS NSDate
0x0003d570  bl       #0x575a0   ; CALL objc_msgSend$date
0x0003d574  mov      x29, x29
0x0003d578  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d57c  mov      x22, x0
0x0003d580  mov      x0, x24
0x0003d584  bl       #0x55d78   ; CALL _objc_release
0x0003d588  mov      x0, x23
0x0003d58c  bl       #0x55d78   ; CALL _objc_release
0x0003d590  adrp     x8, #0x8e000
0x0003d594  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0003d598  bl       #0x55d48   ; CALL _objc_opt_class
0x0003d59c  mov      x1, x0
0x0003d5a0  mov      x0, x25
0x0003d5a4  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0003d5a8  str      x25, [sp, #0x18]
0x0003d5ac  tbz      w0, #0, #0x3d5c4
0x0003d5b0  mov      x0, x25
0x0003d5b4  bl       #0x58c20   ; CALL objc_msgSend$length
0x0003d5b8  cmp      x0, #5
0x0003d5bc  csel     x23, x25, xzr, eq
0x0003d5c0  b        #0x3d5c8
0x0003d5c4  mov      x23, #0
0x0003d5c8  mov      x0, x23
0x0003d5cc  bl       #0x55d84   ; CALL _objc_retain
0x0003d5d0  mov      x26, #0
0x0003d5d4  mov      x0, x20
0x0003d5d8  mov      w2, #0x10
0x0003d5dc  mov      x3, x26
0x0003d5e0  mov      x4, x22
0x0003d5e4  mov      x5, #0
0x0003d5e8  bl       #0x575c0   ; CALL objc_msgSend$dateByAddingUnit:value:toDate:options:
0x0003d5ec  mov      x29, x29
0x0003d5f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d5f4  cbz      x0, #0x3d758
0x0003d5f8  mov      x25, x0
0x0003d5fc  mov      x0, x20
0x0003d600  mov      w2, #0x18
0x0003d604  mov      x3, x25
0x0003d608  bl       #0x56fe0   ; CALL objc_msgSend$components:fromDate:
0x0003d60c  mov      x29, x29
0x0003d610  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d614  mov      x28, x0
0x0003d618  mov      x0, x21
0x0003d61c  mov      w2, #0x18
0x0003d620  mov      x3, x25
0x0003d624  bl       #0x56fe0   ; CALL objc_msgSend$components:fromDate:
0x0003d628  mov      x29, x29
0x0003d62c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d630  mov      x24, x0
0x0003d634  bl       #0x58880   ; CALL objc_msgSend$isLeapMonth
0x0003d638  tbnz     w0, #0, #0x3d65c
0x0003d63c  mov      x0, x24
0x0003d640  bl       #0x59020   ; CALL objc_msgSend$month
0x0003d644  cmp      x0, #1
0x0003d648  b.ne     #0x3d65c
0x0003d64c  mov      x0, x24
0x0003d650  bl       #0x57640   ; CALL objc_msgSend$day
0x0003d654  cmp      x0, #4
0x0003d658  b.lt     #0x3d77c
0x0003d65c  cbz      x23, #0x3d6b8
0x0003d660  adrp     x8, #0x8e000
0x0003d664  ldr      x19, [x8, #0x958]   ; @CLASS NSString
0x0003d668  mov      x0, x28
0x0003d66c  bl       #0x59020   ; CALL objc_msgSend$month
0x0003d670  mov      x27, x0
0x0003d674  mov      x0, x28
0x0003d678  bl       #0x57640   ; CALL objc_msgSend$day
0x0003d67c  stp      x27, x0, [sp]
0x0003d680  mov      x0, x19
0x0003d684  adrp     x2, #0x7d000
0x0003d688  add      x2, x2, #0x108   ; STR "%02ld-%02ld"
0x0003d68c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0003d690  mov      x29, x29
0x0003d694  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d698  mov      x19, x0
0x0003d69c  mov      x0, x23
0x0003d6a0  mov      x2, x19
0x0003d6a4  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0003d6a8  mov      x27, x0
0x0003d6ac  mov      x0, x19
0x0003d6b0  bl       #0x55d78   ; CALL _objc_release
0x0003d6b4  tbnz     w27, #0, #0x3d76c
0x0003d6b8  mov      x0, x28
0x0003d6bc  bl       #0x59020   ; CALL objc_msgSend$month
0x0003d6c0  cmp      x0, #1
0x0003d6c4  b.ne     #0x3d6d8
0x0003d6c8  mov      x0, x28
0x0003d6cc  bl       #0x57640   ; CALL objc_msgSend$day
0x0003d6d0  cmp      x0, #1
0x0003d6d4  b.eq     #0x3d774
0x0003d6d8  mov      x0, x28
0x0003d6dc  bl       #0x59020   ; CALL objc_msgSend$month
0x0003d6e0  cmp      x0, #0xc
0x0003d6e4  b.ne     #0x3d708
0x0003d6e8  mov      x0, x28
0x0003d6ec  bl       #0x57640   ; CALL objc_msgSend$day
0x0003d6f0  cmp      x0, #0x18
0x0003d6f4  b.eq     #0x3d764
0x0003d6f8  mov      x0, x28
0x0003d6fc  bl       #0x57640   ; CALL objc_msgSend$day
0x0003d700  cmp      x0, #0x19
0x0003d704  b.eq     #0x3d764
0x0003d708  mov      x0, x24
0x0003d70c  bl       #0x58880   ; CALL objc_msgSend$isLeapMonth
0x0003d710  tbnz     w0, #0, #0x3d734
0x0003d714  mov      x0, x24
0x0003d718  bl       #0x59020   ; CALL objc_msgSend$month
0x0003d71c  cmp      x0, #8
0x0003d720  b.ne     #0x3d734
0x0003d724  mov      x0, x24
0x0003d728  bl       #0x57640   ; CALL objc_msgSend$day
0x0003d72c  cmp      x0, #0xf
0x0003d730  b.eq     #0x3d784
0x0003d734  mov      x0, x24
0x0003d738  bl       #0x55d78   ; CALL _objc_release
0x0003d73c  mov      x0, x28
0x0003d740  bl       #0x55d78   ; CALL _objc_release
0x0003d744  mov      x0, x25
0x0003d748  bl       #0x55d78   ; CALL _objc_release
0x0003d74c  add      x26, x26, #1
0x0003d750  cmp      x26, #0x190
0x0003d754  b.ne     #0x3d5d4
0x0003d758  ldr      x19, [sp, #0x18]
0x0003d75c  mov      w26, #1
0x0003d760  b        #0x3d7a4
0x0003d764  mov      w26, #3
0x0003d768  b        #0x3d788
0x0003d76c  mov      w26, #2
0x0003d770  b        #0x3d788
0x0003d774  mov      w26, #5
0x0003d778  b        #0x3d788
0x0003d77c  mov      w26, #1
0x0003d780  b        #0x3d788
0x0003d784  mov      w26, #4
0x0003d788  mov      x0, x24
0x0003d78c  bl       #0x55d78   ; CALL _objc_release
0x0003d790  mov      x0, x28
0x0003d794  bl       #0x55d78   ; CALL _objc_release
0x0003d798  mov      x0, x25
0x0003d79c  bl       #0x55d78   ; CALL _objc_release
0x0003d7a0  ldr      x19, [sp, #0x18]
0x0003d7a4  mov      x0, x23
0x0003d7a8  bl       #0x55d78   ; CALL _objc_release
0x0003d7ac  mov      x0, x22
0x0003d7b0  bl       #0x55d78   ; CALL _objc_release
0x0003d7b4  mov      x0, x21
0x0003d7b8  bl       #0x55d78   ; CALL _objc_release
0x0003d7bc  mov      x0, x20
0x0003d7c0  bl       #0x55d78   ; CALL _objc_release
0x0003d7c4  mov      x0, x19
0x0003d7c8  bl       #0x55d78   ; CALL _objc_release
0x0003d7cc  mov      x0, x26
0x0003d7d0  ldp      x29, x30, [sp, #0x70]
0x0003d7d4  ldp      x20, x19, [sp, #0x60]
0x0003d7d8  ldp      x22, x21, [sp, #0x50]
0x0003d7dc  ldp      x24, x23, [sp, #0x40]
0x0003d7e0  ldp      x26, x25, [sp, #0x30]
0x0003d7e4  ldp      x28, x27, [sp, #0x20]
0x0003d7e8  add      sp, sp, #0x80
0x0003d7ec  ret      

=== -[OMCStartupScreenController specifiers]  va=0x3d7f0 size=1992 types=@16@0:8
0x0003d7f0  sub      sp, sp, #0x1a0
0x0003d7f4  stp      x28, x27, [sp, #0x140]
0x0003d7f8  stp      x26, x25, [sp, #0x150]
0x0003d7fc  stp      x24, x23, [sp, #0x160]
0x0003d800  stp      x22, x21, [sp, #0x170]
0x0003d804  stp      x20, x19, [sp, #0x180]
0x0003d808  stp      x29, x30, [sp, #0x190]
0x0003d80c  add      x29, sp, #0x190
0x0003d810  adrp     x8, #0x74000
0x0003d814  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0003d818  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003d81c  stur     x8, [x29, #-0x60]
0x0003d820  adrp     x8, #0x74000
0x0003d824  ldr      x8, [x8, #0x368]   ; @GOT _OBJC_IVAR_$_PSListController._specifiers
0x0003d828  ldrsw    x19, [x8]   ; @GOT ___objc_personality_v0
0x0003d82c  ldr      x20, [x0, x19]
0x0003d830  cbnz     x20, #0x3dce8
0x0003d834  mov      x23, x0
0x0003d838  adrp     x8, #0x8e000
0x0003d83c  ldr      x8, [x8, #0xdb0]   ; @SUPER OMCStartupScreenController
0x0003d840  stp      x0, x8, [sp, #0xa0]
0x0003d844  adrp     x8, #0x8b000
0x0003d848  ldr      x1, [x8, #0xf10]   ; @SEL "specifiers"
0x0003d84c  add      x0, sp, #0xa0
0x0003d850  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0003d854  mov      x29, x29
0x0003d858  bl       #0x55dfc   ; CALL _objc_unsafeClaimAutoreleasedReturnValue
0x0003d85c  mov      x0, x23
0x0003d860  bl       #0x574e0   ; CALL objc_msgSend$currentStyle
0x0003d864  mov      x24, x0
0x0003d868  movi     v0.16b, #0
0x0003d86c  stp      q0, q0, [sp, #0x60]
0x0003d870  stp      q0, q0, [sp, #0x80]
0x0003d874  str      x19, [sp, #0x28]
0x0003d878  ldr      x0, [x23, x19]
0x0003d87c  bl       #0x572e0   ; CALL objc_msgSend$copy
0x0003d880  add      x2, sp, #0x60
0x0003d884  add      x3, sp, #0xb0
0x0003d888  str      x0, [sp, #0x40]
0x0003d88c  mov      w4, #0x10
0x0003d890  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0003d894  str      x0, [sp, #0x58]
0x0003d898  cbz      x0, #0x3dcd0
0x0003d89c  ldr      x8, [sp, #0x70]
0x0003d8a0  ldr      x8, [x8]
0x0003d8a4  str      x8, [sp, #0x50]
0x0003d8a8  adrp     x20, #0x7c000
0x0003d8ac  add      x20, x20, #0x348   ; STR "placeholder"
0x0003d8b0  stp      x24, x23, [sp, #0x30]
0x0003d8b4  mov      x26, #0
0x0003d8b8  ldr      x8, [sp, #0x70]
0x0003d8bc  ldr      x8, [x8]
0x0003d8c0  ldr      x9, [sp, #0x50]
0x0003d8c4  cmp      x8, x9
0x0003d8c8  b.eq     #0x3d8d4
0x0003d8cc  ldr      x0, [sp, #0x40]
0x0003d8d0  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0003d8d4  ldr      x8, [sp, #0x68]
0x0003d8d8  ldr      x28, [x8, x26, lsl #3]
0x0003d8dc  mov      x0, x28
0x0003d8e0  adrp     x2, #0x7c000
0x0003d8e4  add      x2, x2, #0x328   ; STR "ssStyles"
0x0003d8e8  bl       #0x59aa0   ; CALL objc_msgSend$propertyForKey:
0x0003d8ec  mov      x29, x29
0x0003d8f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d8f4  mov      x27, x0
0x0003d8f8  adrp     x8, #0x8e000
0x0003d8fc  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0003d900  bl       #0x55d48   ; CALL _objc_opt_class
0x0003d904  mov      x1, x0
0x0003d908  mov      x0, x27
0x0003d90c  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0003d910  tbz      w0, #0, #0x3d94c
0x0003d914  adrp     x8, #0x8e000
0x0003d918  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x0003d91c  mov      x2, x24
0x0003d920  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x0003d924  mov      x29, x29
0x0003d928  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d92c  mov      x21, x0
0x0003d930  mov      x0, x27
0x0003d934  mov      x2, x21
0x0003d938  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0003d93c  mov      x22, x0
0x0003d940  mov      x0, x21
0x0003d944  bl       #0x55d78   ; CALL _objc_release
0x0003d948  tbz      w22, #0, #0x3dab0
0x0003d94c  mov      x0, x28
0x0003d950  mov      x2, x20
0x0003d954  bl       #0x59aa0   ; CALL objc_msgSend$propertyForKey:
0x0003d958  mov      x29, x29
0x0003d95c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d960  mov      x19, x0
0x0003d964  cbz      x0, #0x3d994
0x0003d968  mov      x0, x19
0x0003d96c  bl       #0x17e20   ; CALL _L
0x0003d970  mov      x29, x29
0x0003d974  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d978  mov      x21, x0
0x0003d97c  mov      x0, x28
0x0003d980  mov      x2, x21
0x0003d984  mov      x3, x20
0x0003d988  bl       #0x5bd60   ; CALL objc_msgSend$setProperty:forKey:
0x0003d98c  mov      x0, x21
0x0003d990  bl       #0x55d78   ; CALL _objc_release
0x0003d994  mov      x0, x28
0x0003d998  bl       #0x58060   ; CALL objc_msgSend$identifier
0x0003d99c  mov      x29, x29
0x0003d9a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d9a4  mov      x25, x0
0x0003d9a8  adrp     x2, #0x7c000
0x0003d9ac  add      x2, x2, #0x368   ; STR "soundGroup"
0x0003d9b0  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0003d9b4  cbz      w0, #0x3da1c
0x0003d9b8  str      x19, [sp, #0x48]
0x0003d9bc  mov      x0, x23
0x0003d9c0  bl       #0x574c0   ; CALL objc_msgSend$currentSound
0x0003d9c4  mov      x29, x29
0x0003d9c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d9cc  mov      x22, x0
0x0003d9d0  cbz      x0, #0x3db30
0x0003d9d4  adrp     x19, #0x8e000
0x0003d9d8  ldr      x21, [x19, #0x958]   ; @CLASS NSString
0x0003d9dc  adrp     x0, #0x7c000
0x0003d9e0  add      x0, x0, #0x388   ; STR "STARTUPSCREEN_SOUND_CURRENT"
0x0003d9e4  bl       #0x17e20   ; CALL _L
0x0003d9e8  mov      x29, x29
0x0003d9ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003d9f0  mov      x24, x0
0x0003d9f4  str      x22, [sp]
0x0003d9f8  mov      x0, x21
0x0003d9fc  mov      x2, x24
0x0003da00  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0003da04  mov      x29, x29
0x0003da08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003da0c  mov      x21, x0
0x0003da10  mov      x0, x24
0x0003da14  bl       #0x55d78   ; CALL _objc_release
0x0003da18  b        #0x3db4c
0x0003da1c  mov      x0, x25
0x0003da20  adrp     x2, #0x7c000
0x0003da24  add      x2, x2, #0x448   ; STR "nameGroup"
0x0003da28  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0003da2c  cbz      w0, #0x3dac4
0x0003da30  mov      x0, x24
0x0003da34  bl       #0x3c7f0
0x0003da38  mov      x29, x29
0x0003da3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003da40  mov      x21, x19
0x0003da44  mov      x19, x0
0x0003da48  bl       #0x17e20   ; CALL _L
0x0003da4c  mov      x29, x29
0x0003da50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003da54  mov      x20, x0
0x0003da58  mov      x0, x28
0x0003da5c  mov      x2, x20
0x0003da60  bl       #0x5b700   ; CALL objc_msgSend$setName:
0x0003da64  mov      x0, x20
0x0003da68  adrp     x20, #0x7c000
0x0003da6c  add      x20, x20, #0x348   ; STR "placeholder"
0x0003da70  bl       #0x55d78   ; CALL _objc_release
0x0003da74  mov      x0, x19
0x0003da78  mov      x19, x21
0x0003da7c  bl       #0x55d78   ; CALL _objc_release
0x0003da80  mov      x0, x23
0x0003da84  mov      x2, x24
0x0003da88  bl       #0x59100   ; CALL objc_msgSend$nameFooterForStyle:
0x0003da8c  mov      x29, x29
0x0003da90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003da94  mov      x22, x0
0x0003da98  mov      x0, x28
0x0003da9c  mov      x2, x22
0x0003daa0  adrp     x3, #0x78000
0x0003daa4  add      x3, x3, #0x6e8   ; STR "footerText"
0x0003daa8  bl       #0x5bd60   ; CALL objc_msgSend$setProperty:forKey:
0x0003daac  b        #0x3dc08
0x0003dab0  ldr      x8, [sp, #0x28]
0x0003dab4  ldr      x0, [x23, x8]
0x0003dab8  mov      x2, x28
0x0003dabc  bl       #0x59e40   ; CALL objc_msgSend$removeObject:
0x0003dac0  b        #0x3dc20
0x0003dac4  mov      x0, x25
0x0003dac8  adrp     x2, #0x7c000
0x0003dacc  add      x2, x2, #0x468   ; STR "carGroup"
0x0003dad0  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0003dad4  tbnz     w0, #0, #0x3daec
0x0003dad8  mov      x0, x25
0x0003dadc  adrp     x2, #0x7c000
0x0003dae0  add      x2, x2, #0x488   ; STR "tempoGroup"
0x0003dae4  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0003dae8  cbz      w0, #0x3dc3c
0x0003daec  mov      x0, x24
0x0003daf0  bl       #0x3c7f0
0x0003daf4  mov      x29, x29
0x0003daf8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003dafc  mov      x22, x0
0x0003db00  bl       #0x17e20   ; CALL _L
0x0003db04  mov      x29, x29
0x0003db08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003db0c  mov      x21, x19
0x0003db10  mov      x19, x0
0x0003db14  mov      x0, x28
0x0003db18  mov      x2, x19
0x0003db1c  bl       #0x5b700   ; CALL objc_msgSend$setName:
0x0003db20  mov      x0, x19
0x0003db24  mov      x19, x21
0x0003db28  bl       #0x55d78   ; CALL _objc_release
0x0003db2c  b        #0x3dc08
0x0003db30  adrp     x0, #0x7c000
0x0003db34  add      x0, x0, #0x3a8   ; STR "STARTUPSCREEN_SOUND_NONE"
0x0003db38  bl       #0x17e20   ; CALL _L
0x0003db3c  mov      x29, x29
0x0003db40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003db44  mov      x21, x0
0x0003db48  adrp     x19, #0x8e000
0x0003db4c  ldr      x24, [x19, #0x958]   ; @CLASS NSString
0x0003db50  adrp     x0, #0x7c000
0x0003db54  add      x0, x0, #0x3e8   ; STR "STARTUPSCREEN_STARTUP_SOUND_FOOTER"
0x0003db58  bl       #0x17e20   ; CALL _L
0x0003db5c  mov      x29, x29
0x0003db60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003db64  mov      x19, x0
0x0003db68  adrp     x0, #0x7c000
0x0003db6c  add      x0, x0, #0x408   ; STR "STARTUPSCREEN_VOLUME_GROUP"
0x0003db70  bl       #0x17e20   ; CALL _L
0x0003db74  mov      x29, x29
0x0003db78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003db7c  mov      x20, x0
0x0003db80  adrp     x0, #0x7c000
0x0003db84  add      x0, x0, #0x428   ; STR "STARTUPSCREEN_VOLUME_FOOTER"
0x0003db88  bl       #0x17e20   ; CALL _L
0x0003db8c  mov      x29, x29
0x0003db90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003db94  mov      x23, x0
0x0003db98  stp      x20, x0, [sp, #0x10]
0x0003db9c  stp      x21, x19, [sp]
0x0003dba0  mov      x0, x24
0x0003dba4  adrp     x2, #0x7c000
0x0003dba8  add      x2, x2, #0x3c8   ; STR "%@\n%@\n%@: %@"
0x0003dbac  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0003dbb0  mov      x29, x29
0x0003dbb4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003dbb8  mov      x24, x0
0x0003dbbc  mov      x0, x28
0x0003dbc0  mov      x2, x24
0x0003dbc4  adrp     x3, #0x78000
0x0003dbc8  add      x3, x3, #0x6e8   ; STR "footerText"
0x0003dbcc  bl       #0x5bd60   ; CALL objc_msgSend$setProperty:forKey:
0x0003dbd0  mov      x0, x24
0x0003dbd4  bl       #0x55d78   ; CALL _objc_release
0x0003dbd8  mov      x0, x23
0x0003dbdc  bl       #0x55d78   ; CALL _objc_release
0x0003dbe0  mov      x0, x20
0x0003dbe4  bl       #0x55d78   ; CALL _objc_release
0x0003dbe8  mov      x0, x19
0x0003dbec  bl       #0x55d78   ; CALL _objc_release
0x0003dbf0  mov      x0, x21
0x0003dbf4  bl       #0x55d78   ; CALL _objc_release
0x0003dbf8  ldp      x24, x23, [sp, #0x30]
0x0003dbfc  adrp     x20, #0x7c000
0x0003dc00  add      x20, x20, #0x348   ; STR "placeholder"
0x0003dc04  ldr      x19, [sp, #0x48]
0x0003dc08  mov      x0, x22
0x0003dc0c  bl       #0x55d78   ; CALL _objc_release
0x0003dc10  mov      x0, x25
0x0003dc14  bl       #0x55d78   ; CALL _objc_release
0x0003dc18  mov      x0, x19
0x0003dc1c  bl       #0x55d78   ; CALL _objc_release
0x0003dc20  mov      x0, x27
0x0003dc24  bl       #0x55d78   ; CALL _objc_release
0x0003dc28  add      x26, x26, #1
0x0003dc2c  ldr      x8, [sp, #0x58]
0x0003dc30  cmp      x8, x26
0x0003dc34  b.ne     #0x3d8b8
0x0003dc38  b        #0x3dcb4
0x0003dc3c  mov      x0, x25
0x0003dc40  adrp     x2, #0x7c000
0x0003dc44  add      x2, x2, #0x4a8   ; STR "carName"
0x0003dc48  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0003dc4c  cbz      w0, #0x3dc7c
0x0003dc50  bl       #0x3dd30
0x0003dc54  mov      x29, x29
0x0003dc58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003dc5c  mov      x22, x0
0x0003dc60  cmp      x0, #0
0x0003dc64  adrp     x8, #0x75000
0x0003dc68  add      x8, x8, #0x508   ; STR "OmniCar"
0x0003dc6c  csel     x2, x8, x0, eq
0x0003dc70  mov      x0, x28
0x0003dc74  mov      x3, x20
0x0003dc78  b        #0x3daa8
0x0003dc7c  mov      x0, x25
0x0003dc80  adrp     x2, #0x7c000
0x0003dc84  add      x2, x2, #0x4c8   ; STR "occasionPreview"
0x0003dc88  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0003dc8c  cbz      w0, #0x3dc10
0x0003dc90  mov      x0, x23
0x0003dc94  bl       #0x59400   ; CALL objc_msgSend$occasionPreviewTitle
0x0003dc98  mov      x29, x29
0x0003dc9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003dca0  mov      x22, x0
0x0003dca4  mov      x0, x28
0x0003dca8  mov      x2, x22
0x0003dcac  bl       #0x5b700   ; CALL objc_msgSend$setName:
0x0003dcb0  b        #0x3dc08
0x0003dcb4  add      x2, sp, #0x60
0x0003dcb8  add      x3, sp, #0xb0
0x0003dcbc  ldr      x0, [sp, #0x40]
0x0003dcc0  mov      w4, #0x10
0x0003dcc4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0003dcc8  str      x0, [sp, #0x58]
0x0003dccc  cbnz     x0, #0x3d8b4
0x0003dcd0  ldr      x0, [sp, #0x40]
0x0003dcd4  bl       #0x55d78   ; CALL _objc_release
0x0003dcd8  mov      x0, x23
0x0003dcdc  bl       #0x59c20   ; CALL objc_msgSend$refreshVideoList
0x0003dce0  ldr      x8, [sp, #0x28]
0x0003dce4  ldr      x20, [x23, x8]
0x0003dce8  mov      x0, x20
0x0003dcec  bl       #0x55d84   ; CALL _objc_retain
0x0003dcf0  ldur     x8, [x29, #-0x60]
0x0003dcf4  adrp     x9, #0x74000
0x0003dcf8  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0003dcfc  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0003dd00  cmp      x9, x8
0x0003dd04  b.ne     #0x3dd2c
0x0003dd08  mov      x0, x20
0x0003dd0c  ldp      x29, x30, [sp, #0x190]
0x0003dd10  ldp      x20, x19, [sp, #0x180]
0x0003dd14  ldp      x22, x21, [sp, #0x170]
0x0003dd18  ldp      x24, x23, [sp, #0x160]
0x0003dd1c  ldp      x26, x25, [sp, #0x150]
0x0003dd20  ldp      x28, x27, [sp, #0x140]
0x0003dd24  add      sp, sp, #0x1a0
0x0003dd28  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0003dd2c  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0003dd30  stp      x28, x27, [sp, #-0x60]!
0x0003dd34  stp      x26, x25, [sp, #0x10]
0x0003dd38  stp      x24, x23, [sp, #0x20]
0x0003dd3c  stp      x22, x21, [sp, #0x30]
0x0003dd40  stp      x20, x19, [sp, #0x40]
0x0003dd44  stp      x29, x30, [sp, #0x50]
0x0003dd48  add      x29, sp, #0x50
0x0003dd4c  sub      sp, sp, #0x1b0
0x0003dd50  adrp     x8, #0x74000
0x0003dd54  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0003dd58  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003dd5c  stur     x8, [x29, #-0x60]
0x0003dd60  adrp     x0, #0x75000
0x0003dd64  add      x0, x0, #0x5e8   ; STR "diagCar"
0x0003dd68  adrp     x1, #0x75000
0x0003dd6c  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x0003dd70  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x0003dd74  mov      x19, x0
0x0003dd78  adrp     x21, #0x8e000
0x0003dd7c  ldr      x0, [x21, #0x970]   ; @CLASS NSDictionary
0x0003dd80  bl       #0x55d48   ; CALL _objc_opt_class
0x0003dd84  mov      x1, x0
0x0003dd88  mov      x0, x19
0x0003dd8c  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0003dd90  tbz      w0, #0, #0x3df5c
0x0003dd94  movi     v0.16b, #0
0x0003dd98  stp      q0, q0, [sp, #0x80]
0x0003dd9c  stp      q0, q0, [sp, #0x60]
0x0003dda0  adrp     x0, #0x7f000
0x0003dda4  add      x0, x0, #0xde0
0x0003dda8  add      x2, sp, #0x60
0x0003ddac  sub      x3, x29, #0xe0
0x0003ddb0  mov      w4, #0x10
0x0003ddb4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0003ddb8  str      x0, [sp, #8]
0x0003ddbc  cbz      x0, #0x3df5c
0x0003ddc0  ldr      x8, [sp, #0x70]
0x0003ddc4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003ddc8  stp      x8, x19, [sp, #0x10]
0x0003ddcc  adrp     x20, #0x7f000
0x0003ddd0  add      x20, x20, #0xdf8
0x0003ddd4  adrp     x28, #0x8e000
0x0003ddd8  adrp     x22, #0x77000
0x0003dddc  add      x22, x22, #0x3a8   ; STR "nil"
0x0003dde0  adrp     x23, #0x77000
0x0003dde4  add      x23, x23, #0x3c8   ; STR "(null)"
0x0003dde8  mov      x24, #0
0x0003ddec  ldr      x8, [sp, #0x70]
0x0003ddf0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003ddf4  ldr      x9, [sp, #0x10]
0x0003ddf8  cmp      x8, x9
0x0003ddfc  b.eq     #0x3de0c
0x0003de00  adrp     x0, #0x7f000
0x0003de04  add      x0, x0, #0xde0
0x0003de08  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0003de0c  ldr      x8, [sp, #0x68]
0x0003de10  ldr      x2, [x8, x24, lsl #3]   ; @GOT ___objc_personality_v0
0x0003de14  mov      x0, x19
0x0003de18  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0003de1c  mov      x29, x29
0x0003de20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003de24  mov      x25, x0
0x0003de28  ldr      x0, [x21, #0x970]   ; @CLASS NSDictionary
0x0003de2c  bl       #0x55d48   ; CALL _objc_opt_class
0x0003de30  mov      x1, x0
0x0003de34  mov      x0, x25
0x0003de38  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0003de3c  tbz      w0, #0, #0x3df1c
0x0003de40  movi     v0.16b, #0
0x0003de44  stp      q0, q0, [sp, #0x40]
0x0003de48  stp      q0, q0, [sp, #0x20]
0x0003de4c  add      x2, sp, #0x20
0x0003de50  add      x3, sp, #0xa0
0x0003de54  mov      x0, x20
0x0003de58  mov      w4, #0x10
0x0003de5c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0003de60  cbz      x0, #0x3df1c
0x0003de64  mov      x26, x0
0x0003de68  ldr      x8, [sp, #0x30]
0x0003de6c  ldr      x21, [x8]   ; @GOT ___objc_personality_v0
0x0003de70  mov      x19, #0
0x0003de74  ldr      x8, [sp, #0x30]
0x0003de78  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003de7c  cmp      x8, x21
0x0003de80  b.eq     #0x3de8c
0x0003de84  mov      x0, x20
0x0003de88  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0003de8c  ldr      x8, [sp, #0x28]
0x0003de90  ldr      x2, [x8, x19, lsl #3]   ; @GOT ___objc_personality_v0
0x0003de94  mov      x0, x25
0x0003de98  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0003de9c  mov      x29, x29
0x0003dea0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003dea4  mov      x27, x0
0x0003dea8  ldr      x0, [x28, #0x958]   ; @CLASS NSString
0x0003deac  bl       #0x55d48   ; CALL _objc_opt_class
0x0003deb0  mov      x1, x0
0x0003deb4  mov      x0, x27
0x0003deb8  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0003debc  tbz      w0, #0, #0x3deec
0x0003dec0  mov      x0, x27
0x0003dec4  bl       #0x58c20   ; CALL objc_msgSend$length
0x0003dec8  cbz      x0, #0x3deec
0x0003decc  mov      x0, x27
0x0003ded0  mov      x2, x22
0x0003ded4  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0003ded8  tbnz     w0, #0, #0x3deec
0x0003dedc  mov      x0, x27
0x0003dee0  mov      x2, x23
0x0003dee4  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0003dee8  cbz      w0, #0x3df64
0x0003deec  mov      x0, x27
0x0003def0  bl       #0x55d78   ; CALL _objc_release
0x0003def4  add      x19, x19, #1
0x0003def8  cmp      x26, x19
0x0003defc  b.ne     #0x3de74
0x0003df00  add      x2, sp, #0x20
0x0003df04  add      x3, sp, #0xa0
0x0003df08  mov      x0, x20
0x0003df0c  mov      w4, #0x10
0x0003df10  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0003df14  mov      x26, x0
0x0003df18  cbnz     x0, #0x3de70
0x0003df1c  mov      x0, x25
0x0003df20  bl       #0x55d78   ; CALL _objc_release
0x0003df24  add      x24, x24, #1
0x0003df28  ldr      x8, [sp, #8]
0x0003df2c  cmp      x24, x8
0x0003df30  ldr      x19, [sp, #0x18]
0x0003df34  adrp     x21, #0x8e000
0x0003df38  b.ne     #0x3ddec
0x0003df3c  add      x2, sp, #0x60
0x0003df40  sub      x3, x29, #0xe0
0x0003df44  adrp     x0, #0x7f000
0x0003df48  add      x0, x0, #0xde0
0x0003df4c  mov      w4, #0x10
0x0003df50  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0003df54  str      x0, [sp, #8]
0x0003df58  cbnz     x0, #0x3dde8
0x0003df5c  mov      x27, #0
0x0003df60  b        #0x3df70
0x0003df64  mov      x0, x25
0x0003df68  bl       #0x55d78   ; CALL _objc_release
0x0003df6c  ldr      x19, [sp, #0x18]
0x0003df70  mov      x0, x19
0x0003df74  bl       #0x55d78   ; CALL _objc_release
0x0003df78  ldur     x8, [x29, #-0x60]
0x0003df7c  adrp     x9, #0x74000
0x0003df80  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0003df84  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0003df88  cmp      x9, x8
0x0003df8c  b.ne     #0x3dfb4
0x0003df90  mov      x0, x27
0x0003df94  add      sp, sp, #0x1b0
0x0003df98  ldp      x29, x30, [sp, #0x50]
0x0003df9c  ldp      x20, x19, [sp, #0x40]
0x0003dfa0  ldp      x22, x21, [sp, #0x30]
0x0003dfa4  ldp      x24, x23, [sp, #0x20]
0x0003dfa8  ldp      x26, x25, [sp, #0x10]
0x0003dfac  ldp      x28, x27, [sp], #0x60
0x0003dfb0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0003dfb4  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController nameFooterForStyle:]  va=0x3dfb8 size=452 types=@24@0:8q16
0x0003dfb8  sub      sp, sp, #0x60
0x0003dfbc  stp      x26, x25, [sp, #0x10]
0x0003dfc0  stp      x24, x23, [sp, #0x20]
0x0003dfc4  stp      x22, x21, [sp, #0x30]
0x0003dfc8  stp      x20, x19, [sp, #0x40]
0x0003dfcc  stp      x29, x30, [sp, #0x50]
0x0003dfd0  add      x29, sp, #0x50
0x0003dfd4  cmp      x2, #8
0x0003dfd8  b.eq     #0x3e138
0x0003dfdc  cmp      x2, #6
0x0003dfe0  b.eq     #0x3e12c
0x0003dfe4  cmp      x2, #3
0x0003dfe8  b.ne     #0x3e144
0x0003dfec  fmov     d0, xzr
0x0003dff0  bl       #0x4572c   ; CALL _SSWeatherLoadCache
0x0003dff4  mov      x29, x29
0x0003dff8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003dffc  mov      x19, x0
0x0003e000  adrp     x0, #0x7c000
0x0003e004  add      x0, x0, #0x4e8   ; STR "STARTUPSCREEN_WEATHER_NONE"
0x0003e008  bl       #0x17e20   ; CALL _L
0x0003e00c  mov      x29, x29
0x0003e010  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e014  mov      x20, x0
0x0003e018  adrp     x2, #0x75000
0x0003e01c  add      x2, x2, #0x968   ; STR "date"
0x0003e020  mov      x0, x19
0x0003e024  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0003e028  mov      x29, x29
0x0003e02c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e030  mov      x21, x0
0x0003e034  adrp     x8, #0x8e000
0x0003e038  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x0003e03c  bl       #0x55d48   ; CALL _objc_opt_class
0x0003e040  mov      x1, x0
0x0003e044  mov      x0, x21
0x0003e048  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0003e04c  adrp     x25, #0x8e000
0x0003e050  tbz      w0, #0, #0x3e0cc
0x0003e054  ldr      x22, [x25, #0x958]   ; @CLASS NSString
0x0003e058  adrp     x0, #0x7c000
0x0003e05c  add      x0, x0, #0x508   ; STR "STARTUPSCREEN_WEATHER_LAST"
0x0003e060  bl       #0x17e20   ; CALL _L
0x0003e064  mov      x29, x29
0x0003e068  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e06c  mov      x23, x0
0x0003e070  adrp     x8, #0x8e000
0x0003e074  ldr      x0, [x8, #0x980]   ; @CLASS NSDateFormatter
0x0003e078  mov      x2, x21
0x0003e07c  mov      w3, #1
0x0003e080  mov      w4, #1
0x0003e084  bl       #0x58de0   ; CALL objc_msgSend$localizedStringFromDate:dateStyle:timeStyle:
0x0003e088  mov      x29, x29
0x0003e08c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e090  mov      x24, x0
0x0003e094  str      x0, [sp]
0x0003e098  mov      x0, x22
0x0003e09c  mov      x2, x23
0x0003e0a0  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0003e0a4  mov      x29, x29
0x0003e0a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e0ac  mov      x22, x0
0x0003e0b0  mov      x0, x20
0x0003e0b4  bl       #0x55d78   ; CALL _objc_release
0x0003e0b8  mov      x0, x24
0x0003e0bc  bl       #0x55d78   ; CALL _objc_release
0x0003e0c0  mov      x0, x23
0x0003e0c4  bl       #0x55d78   ; CALL _objc_release
0x0003e0c8  mov      x20, x22
0x0003e0cc  ldr      x22, [x25, #0x958]   ; @CLASS NSString
0x0003e0d0  adrp     x0, #0x7c000
0x0003e0d4  add      x0, x0, #0x528   ; STR "STARTUPSCREEN_WEATHER_FOOTER"
0x0003e0d8  bl       #0x17e20   ; CALL _L
0x0003e0dc  mov      x29, x29
0x0003e0e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e0e4  mov      x23, x0
0x0003e0e8  stp      x0, x20, [sp]
0x0003e0ec  adrp     x2, #0x75000
0x0003e0f0  add      x2, x2, #0xba8   ; STR "%@\n%@"
0x0003e0f4  mov      x0, x22
0x0003e0f8  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0003e0fc  mov      x29, x29
0x0003e100  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e104  mov      x22, x0
0x0003e108  mov      x0, x23
0x0003e10c  bl       #0x55d78   ; CALL _objc_release
0x0003e110  mov      x0, x21
0x0003e114  bl       #0x55d78   ; CALL _objc_release
0x0003e118  mov      x0, x20
0x0003e11c  bl       #0x55d78   ; CALL _objc_release
0x0003e120  mov      x0, x19
0x0003e124  bl       #0x55d78   ; CALL _objc_release
0x0003e128  b        #0x3e15c
0x0003e12c  adrp     x0, #0x7c000
0x0003e130  add      x0, x0, #0x548   ; STR "STARTUPSCREEN_PARTICLES_FOOTER"
0x0003e134  b        #0x3e14c
0x0003e138  adrp     x0, #0x7c000
0x0003e13c  add      x0, x0, #0x568   ; STR "STARTUPSCREEN_BRIEFING_FOOTER"
0x0003e140  b        #0x3e14c
0x0003e144  adrp     x0, #0x7c000
0x0003e148  add      x0, x0, #0x588   ; STR "STARTUPSCREEN_GREETING_FOOTER"
0x0003e14c  bl       #0x17e20   ; CALL _L
0x0003e150  mov      x29, x29
0x0003e154  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e158  mov      x22, x0
0x0003e15c  mov      x0, x22
0x0003e160  ldp      x29, x30, [sp, #0x50]
0x0003e164  ldp      x20, x19, [sp, #0x40]
0x0003e168  ldp      x22, x21, [sp, #0x30]
0x0003e16c  ldp      x24, x23, [sp, #0x20]
0x0003e170  ldp      x26, x25, [sp, #0x10]
0x0003e174  add      sp, sp, #0x60
0x0003e178  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCStartupScreenController setPreferenceValue:specifier:]  va=0x3e17c size=224 types=v32@0:8@16@24
0x0003e17c  sub      sp, sp, #0x40
0x0003e180  stp      x22, x21, [sp, #0x10]
0x0003e184  stp      x20, x19, [sp, #0x20]
0x0003e188  stp      x29, x30, [sp, #0x30]
0x0003e18c  add      x29, sp, #0x30
0x0003e190  mov      x22, x3
0x0003e194  mov      x19, x2
0x0003e198  mov      x20, x0
0x0003e19c  mov      x0, x2
0x0003e1a0  bl       #0x55d84   ; CALL _objc_retain
0x0003e1a4  adrp     x8, #0x8e000
0x0003e1a8  ldr      x8, [x8, #0xdb0]   ; @SUPER OMCStartupScreenController
0x0003e1ac  stp      x20, x8, [sp]
0x0003e1b0  adrp     x8, #0x8b000
0x0003e1b4  ldr      x21, [x8, #0xf18]   ; @SEL "setPreferenceValue:specifier:"
0x0003e1b8  mov      x0, x22
0x0003e1bc  bl       #0x55d84   ; CALL _objc_retain
0x0003e1c0  mov      x0, sp
0x0003e1c4  mov      x1, x21
0x0003e1c8  mov      x2, x19
0x0003e1cc  mov      x3, x22
0x0003e1d0  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0003e1d4  adrp     x2, #0x76000
0x0003e1d8  add      x2, x2, #0xfc8   ; STR "key"
0x0003e1dc  mov      x0, x22
0x0003e1e0  bl       #0x59aa0   ; CALL objc_msgSend$propertyForKey:
0x0003e1e4  mov      x29, x29
0x0003e1e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e1ec  mov      x21, x0
0x0003e1f0  mov      x0, x22
0x0003e1f4  bl       #0x55d78   ; CALL _objc_release
0x0003e1f8  cbz      x21, #0x3e238
0x0003e1fc  adrp     x0, #0x7f000
0x0003e200  add      x0, x0, #0xc60
0x0003e204  mov      x2, x21
0x0003e208  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0003e20c  cbz      w0, #0x3e238
0x0003e210  adrp     x22, #0x75000
0x0003e214  add      x22, x22, #0x28   ; STR "com.anlai.omnicar"
0x0003e218  mov      x0, x21
0x0003e21c  mov      x1, x19
0x0003e220  mov      x2, x22
0x0003e224  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x0003e228  mov      x0, x22
0x0003e22c  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x0003e230  mov      x0, x20
0x0003e234  bl       #0x5dd80   ; CALL objc_msgSend$updatePreview
0x0003e238  mov      x0, x21
0x0003e23c  bl       #0x55d78   ; CALL _objc_release
0x0003e240  mov      x0, x19
0x0003e244  bl       #0x55d78   ; CALL _objc_release
0x0003e248  ldp      x29, x30, [sp, #0x30]
0x0003e24c  ldp      x20, x19, [sp, #0x20]
0x0003e250  ldp      x22, x21, [sp, #0x10]
0x0003e254  add      sp, sp, #0x40
0x0003e258  ret      

=== -[OMCStartupScreenController tableView:cellForRowAtIndexPath:]  va=0x3e25c size=92 types=@32@0:8@16@24
0x0003e25c  sub      sp, sp, #0x30
0x0003e260  stp      x20, x19, [sp, #0x10]
0x0003e264  stp      x29, x30, [sp, #0x20]
0x0003e268  add      x29, sp, #0x20
0x0003e26c  mov      x19, x0
0x0003e270  adrp     x8, #0x8e000
0x0003e274  ldr      x8, [x8, #0xdb0]   ; @SUPER OMCStartupScreenController
0x0003e278  stp      x0, x8, [sp]
0x0003e27c  adrp     x8, #0x8b000
0x0003e280  ldr      x1, [x8, #0xde0]   ; @SEL "tableView:cellForRowAtIndexPath:"
0x0003e284  mov      x0, sp
0x0003e288  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0003e28c  mov      x29, x29
0x0003e290  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e294  mov      x20, x0
0x0003e298  mov      x0, x19
0x0003e29c  mov      x2, x20
0x0003e2a0  bl       #0x57680   ; CALL objc_msgSend$decorateCell:
0x0003e2a4  mov      x0, x20
0x0003e2a8  ldp      x29, x30, [sp, #0x20]
0x0003e2ac  ldp      x20, x19, [sp, #0x10]
0x0003e2b0  add      sp, sp, #0x30
0x0003e2b4  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCStartupScreenController decorateCell:]  va=0x3e2b8 size=736 types=v24@0:8@16
0x0003e2b8  stp      x26, x25, [sp, #-0x50]!
0x0003e2bc  stp      x24, x23, [sp, #0x10]
0x0003e2c0  stp      x22, x21, [sp, #0x20]
0x0003e2c4  stp      x20, x19, [sp, #0x30]
0x0003e2c8  stp      x29, x30, [sp, #0x40]
0x0003e2cc  add      x29, sp, #0x40
0x0003e2d0  mov      x19, x2
0x0003e2d4  mov      x22, x0
0x0003e2d8  mov      x0, x2
0x0003e2dc  bl       #0x55d84   ; CALL _objc_retain
0x0003e2e0  adrp     x8, #0x8e000
0x0003e2e4  ldr      x0, [x8, #0xb08]   ; @CLASS PSTableCell
0x0003e2e8  bl       #0x55d48   ; CALL _objc_opt_class
0x0003e2ec  mov      x1, x0
0x0003e2f0  mov      x0, x19
0x0003e2f4  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0003e2f8  tbz      w0, #0, #0x3e314
0x0003e2fc  mov      x0, x19
0x0003e300  bl       #0x5cdc0   ; CALL objc_msgSend$specifier
0x0003e304  mov      x29, x29
0x0003e308  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e30c  mov      x20, x0
0x0003e310  b        #0x3e318
0x0003e314  mov      x20, #0
0x0003e318  mov      x0, x20
0x0003e31c  bl       #0x58060   ; CALL objc_msgSend$identifier
0x0003e320  mov      x29, x29
0x0003e324  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e328  mov      x21, x0
0x0003e32c  adrp     x2, #0x7c000
0x0003e330  add      x2, x2, #0x648   ; STR "birthday"
0x0003e334  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0003e338  mov      x23, x0
0x0003e33c  mov      x0, x21
0x0003e340  bl       #0x55d78   ; CALL _objc_release
0x0003e344  tbnz     w23, #0, #0x3e3b0
0x0003e348  mov      x0, x22
0x0003e34c  bl       #0x568e0   ; CALL objc_msgSend$birthdayView
0x0003e350  mov      x29, x29
0x0003e354  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e358  cbz      x0, #0x3e3b0
0x0003e35c  mov      x21, x0
0x0003e360  mov      x0, x19
0x0003e364  bl       #0x55f80   ; CALL objc_msgSend$accessoryView
0x0003e368  mov      x29, x29
0x0003e36c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e370  mov      x24, x0
0x0003e374  mov      x0, x22
0x0003e378  bl       #0x568e0   ; CALL objc_msgSend$birthdayView
0x0003e37c  mov      x29, x29
0x0003e380  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e384  mov      x25, x0
0x0003e388  bl       #0x55d78   ; CALL _objc_release
0x0003e38c  mov      x0, x24
0x0003e390  bl       #0x55d78   ; CALL _objc_release
0x0003e394  mov      x0, x21
0x0003e398  bl       #0x55d78   ; CALL _objc_release
0x0003e39c  cmp      x24, x25
0x0003e3a0  b.ne     #0x3e3b0
0x0003e3a4  mov      x0, x19
0x0003e3a8  mov      x2, #0
0x0003e3ac  bl       #0x5a2c0   ; CALL objc_msgSend$setAccessoryView:
0x0003e3b0  adrp     x2, #0x7c000
0x0003e3b4  add      x2, x2, #0x668   ; STR "ssRandomStyle"
0x0003e3b8  mov      x0, x20
0x0003e3bc  bl       #0x59aa0   ; CALL objc_msgSend$propertyForKey:
0x0003e3c0  mov      x29, x29
0x0003e3c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e3c8  mov      x21, x0
0x0003e3cc  adrp     x24, #0x8e000
0x0003e3d0  ldr      x0, [x24, #0x928]   ; @CLASS NSNumber
0x0003e3d4  bl       #0x55d48   ; CALL _objc_opt_class
0x0003e3d8  mov      x1, x0
0x0003e3dc  mov      x0, x21
0x0003e3e0  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0003e3e4  tbz      w0, #0, #0x3e498
0x0003e3e8  mov      x0, x22
0x0003e3ec  bl       #0x59b20   ; CALL objc_msgSend$randomSet
0x0003e3f0  mov      x29, x29
0x0003e3f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e3f8  mov      x22, x0
0x0003e3fc  ldr      x23, [x24, #0x928]   ; @CLASS NSNumber
0x0003e400  mov      x0, x21
0x0003e404  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0003e408  mov      x2, x0
0x0003e40c  mov      x0, x23
0x0003e410  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x0003e414  mov      x29, x29
0x0003e418  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e41c  mov      x23, x0
0x0003e420  mov      x0, x22
0x0003e424  mov      x2, x23
0x0003e428  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0003e42c  mov      x24, x0
0x0003e430  mov      x0, x23
0x0003e434  bl       #0x55d78   ; CALL _objc_release
0x0003e438  mov      x0, x22
0x0003e43c  bl       #0x55d78   ; CALL _objc_release
0x0003e440  adrp     x23, #0x8e000
0x0003e444  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0003e448  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x0003e44c  mov      x29, x29
0x0003e450  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e454  mov      x22, x0
0x0003e458  mov      x0, x19
0x0003e45c  mov      x2, x22
0x0003e460  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x0003e464  mov      x0, x22
0x0003e468  bl       #0x55d78   ; CALL _objc_release
0x0003e46c  cmp      w24, #0
0x0003e470  mov      w8, #3
0x0003e474  csel     x2, x8, xzr, ne
0x0003e478  mov      x0, x19
0x0003e47c  bl       #0x5a2a0   ; CALL objc_msgSend$setAccessoryType:
0x0003e480  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0003e484  cbz      w24, #0x3e4cc
0x0003e488  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x0003e48c  mov      x29, x29
0x0003e490  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e494  b        #0x3e4d8
0x0003e498  cbz      w23, #0x3e534
0x0003e49c  mov      x0, x19
0x0003e4a0  mov      x2, #0
0x0003e4a4  bl       #0x5bfa0   ; CALL objc_msgSend$setSelectionStyle:
0x0003e4a8  mov      x0, x22
0x0003e4ac  bl       #0x56860   ; CALL objc_msgSend$birthdayAccessory
0x0003e4b0  mov      x29, x29
0x0003e4b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e4b8  mov      x22, x0
0x0003e4bc  mov      x0, x19
0x0003e4c0  mov      x2, x22
0x0003e4c4  bl       #0x5a2c0   ; CALL objc_msgSend$setAccessoryView:
0x0003e4c8  b        #0x3e500
0x0003e4cc  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x0003e4d0  mov      x29, x29
0x0003e4d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e4d8  mov      x22, x0
0x0003e4dc  mov      x0, x19
0x0003e4e0  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x0003e4e4  mov      x29, x29
0x0003e4e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e4ec  mov      x23, x0
0x0003e4f0  mov      x2, x22
0x0003e4f4  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0003e4f8  mov      x0, x23
0x0003e4fc  bl       #0x55d78   ; CALL _objc_release
0x0003e500  mov      x0, x22
0x0003e504  bl       #0x55d78   ; CALL _objc_release
0x0003e508  mov      x0, x21
0x0003e50c  bl       #0x55d78   ; CALL _objc_release
0x0003e510  mov      x0, x20
0x0003e514  bl       #0x55d78   ; CALL _objc_release
0x0003e518  mov      x0, x19
0x0003e51c  ldp      x29, x30, [sp, #0x40]
0x0003e520  ldp      x20, x19, [sp, #0x30]
0x0003e524  ldp      x22, x21, [sp, #0x20]
0x0003e528  ldp      x24, x23, [sp, #0x10]
0x0003e52c  ldp      x26, x25, [sp], #0x50
0x0003e530  b        #0x55d78   ; CALL _objc_release
0x0003e534  mov      x0, x20
0x0003e538  bl       #0x58060   ; CALL objc_msgSend$identifier
0x0003e53c  mov      x29, x29
0x0003e540  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e544  mov      x22, x0
0x0003e548  adrp     x2, #0x7c000
0x0003e54c  add      x2, x2, #0x4c8   ; STR "occasionPreview"
0x0003e550  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0003e554  mov      x23, x0
0x0003e558  mov      x0, x22
0x0003e55c  bl       #0x55d78   ; CALL _objc_release
0x0003e560  cbz      w23, #0x3e508
0x0003e564  mov      x0, x20
0x0003e568  bl       #0x590e0   ; CALL objc_msgSend$name
0x0003e56c  mov      x29, x29
0x0003e570  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e574  mov      x22, x0
0x0003e578  mov      x0, x19
0x0003e57c  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x0003e580  mov      x29, x29
0x0003e584  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e588  mov      x23, x0
0x0003e58c  mov      x2, x22
0x0003e590  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0003e594  b        #0x3e4f8

=== -[OMCStartupScreenController redecorateVisibleCells]  va=0x3e598 size=276 types=v16@0:8
0x0003e598  sub      sp, sp, #0x110
0x0003e59c  stp      x24, x23, [sp, #0xd0]
0x0003e5a0  stp      x22, x21, [sp, #0xe0]
0x0003e5a4  stp      x20, x19, [sp, #0xf0]
0x0003e5a8  stp      x29, x30, [sp, #0x100]
0x0003e5ac  add      x29, sp, #0x100
0x0003e5b0  mov      x19, x0
0x0003e5b4  adrp     x8, #0x74000
0x0003e5b8  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0003e5bc  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003e5c0  stur     x8, [x29, #-0x38]
0x0003e5c4  movi     v0.16b, #0
0x0003e5c8  stp      q0, q0, [sp]
0x0003e5cc  stp      q0, q0, [sp, #0x20]
0x0003e5d0  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x0003e5d4  mov      x29, x29
0x0003e5d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e5dc  mov      x21, x0
0x0003e5e0  bl       #0x5dfa0   ; CALL objc_msgSend$visibleCells
0x0003e5e4  mov      x29, x29
0x0003e5e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e5ec  mov      x20, x0
0x0003e5f0  mov      x0, x21
0x0003e5f4  bl       #0x55d78   ; CALL _objc_release
0x0003e5f8  mov      x2, sp
0x0003e5fc  add      x3, sp, #0x48
0x0003e600  mov      x0, x20
0x0003e604  mov      w4, #0x10
0x0003e608  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0003e60c  cbz      x0, #0x3e670
0x0003e610  mov      x21, x0
0x0003e614  ldr      x8, [sp, #0x10]
0x0003e618  ldr      x22, [x8]   ; @GOT ___objc_personality_v0
0x0003e61c  mov      x23, #0
0x0003e620  ldr      x8, [sp, #0x10]
0x0003e624  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003e628  cmp      x8, x22
0x0003e62c  b.eq     #0x3e638
0x0003e630  mov      x0, x20
0x0003e634  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0003e638  ldr      x8, [sp, #8]
0x0003e63c  ldr      x2, [x8, x23, lsl #3]   ; @GOT ___objc_personality_v0
0x0003e640  mov      x0, x19
0x0003e644  bl       #0x57680   ; CALL objc_msgSend$decorateCell:
0x0003e648  add      x23, x23, #1
0x0003e64c  cmp      x21, x23
0x0003e650  b.ne     #0x3e620
0x0003e654  mov      x2, sp
0x0003e658  add      x3, sp, #0x48
0x0003e65c  mov      x0, x20
0x0003e660  mov      w4, #0x10
0x0003e664  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0003e668  mov      x21, x0
0x0003e66c  cbnz     x0, #0x3e61c
0x0003e670  mov      x0, x20
0x0003e674  bl       #0x55d78   ; CALL _objc_release
0x0003e678  ldur     x8, [x29, #-0x38]
0x0003e67c  adrp     x9, #0x74000
0x0003e680  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0003e684  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0003e688  cmp      x9, x8
0x0003e68c  b.ne     #0x3e6a8
0x0003e690  ldp      x29, x30, [sp, #0x100]
0x0003e694  ldp      x20, x19, [sp, #0xf0]
0x0003e698  ldp      x22, x21, [sp, #0xe0]
0x0003e69c  ldp      x24, x23, [sp, #0xd0]
0x0003e6a0  add      sp, sp, #0x110
0x0003e6a4  ret      
0x0003e6a8  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController viewDidLoad]  va=0x3e6ac size=2268 types=v16@0:8
0x0003e6ac  sub      sp, sp, #0x60
0x0003e6b0  stp      d9, d8, [sp, #0x10]
0x0003e6b4  stp      x24, x23, [sp, #0x20]
0x0003e6b8  stp      x22, x21, [sp, #0x30]
0x0003e6bc  stp      x20, x19, [sp, #0x40]
0x0003e6c0  stp      x29, x30, [sp, #0x50]
0x0003e6c4  add      x29, sp, #0x50
0x0003e6c8  mov      x19, x0
0x0003e6cc  adrp     x8, #0x8e000
0x0003e6d0  ldr      x8, [x8, #0xdb0]   ; @SUPER OMCStartupScreenController
0x0003e6d4  stp      x0, x8, [sp]
0x0003e6d8  adrp     x8, #0x8b000
0x0003e6dc  ldr      x1, [x8, #0xda0]   ; @SEL "viewDidLoad"
0x0003e6e0  mov      x0, sp
0x0003e6e4  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0003e6e8  adrp     x21, #0x8e000
0x0003e6ec  ldr      x0, [x21, #0x918]   ; @CLASS UIView
0x0003e6f0  bl       #0x55c7c   ; CALL _objc_alloc
0x0003e6f4  mov      x8, #0x4074000000000000
0x0003e6f8  fmov     d8, x8
0x0003e6fc  adrp     x8, #0x65000
0x0003e700  ldr      d3, [x8, #0xe90]
0x0003e704  fmov     d0, xzr
0x0003e708  fmov     d1, xzr
0x0003e70c  mov      v2.16b, v8.16b
0x0003e710  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0003e714  mov      x20, x0
0x0003e718  mov      x0, x19
0x0003e71c  mov      x2, x20
0x0003e720  bl       #0x5bce0   ; CALL objc_msgSend$setPreviewHeader:
0x0003e724  mov      x0, x20
0x0003e728  bl       #0x55d78   ; CALL _objc_release
0x0003e72c  ldr      x0, [x21, #0x918]   ; @CLASS UIView
0x0003e730  bl       #0x55d60   ; CALL _objc_opt_new
0x0003e734  mov      x20, x0
0x0003e738  mov      x0, x19
0x0003e73c  mov      x2, x20
0x0003e740  bl       #0x5bd00   ; CALL objc_msgSend$setPreviewShadow:
0x0003e744  mov      x0, x20
0x0003e748  bl       #0x55d78   ; CALL _objc_release
0x0003e74c  adrp     x24, #0x8e000
0x0003e750  ldr      x0, [x24, #0x910]   ; @CLASS UIColor
0x0003e754  bl       #0x56940   ; CALL objc_msgSend$blackColor
0x0003e758  mov      x29, x29
0x0003e75c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e760  mov      x20, x0
0x0003e764  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0003e768  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0003e76c  mov      x21, x0
0x0003e770  mov      x0, x19
0x0003e774  bl       #0x59a20   ; CALL objc_msgSend$previewShadow
0x0003e778  mov      x29, x29
0x0003e77c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e780  mov      x22, x0
0x0003e784  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003e788  mov      x29, x29
0x0003e78c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e790  mov      x23, x0
0x0003e794  mov      x2, x21
0x0003e798  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x0003e79c  mov      x0, x23
0x0003e7a0  bl       #0x55d78   ; CALL _objc_release
0x0003e7a4  mov      x0, x22
0x0003e7a8  bl       #0x55d78   ; CALL _objc_release
0x0003e7ac  mov      x0, x20
0x0003e7b0  bl       #0x55d78   ; CALL _objc_release
0x0003e7b4  mov      x0, x19
0x0003e7b8  bl       #0x59a20   ; CALL objc_msgSend$previewShadow
0x0003e7bc  mov      x29, x29
0x0003e7c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e7c4  mov      x20, x0
0x0003e7c8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003e7cc  mov      x29, x29
0x0003e7d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e7d4  mov      x21, x0
0x0003e7d8  adrp     x8, #0x65000
0x0003e7dc  ldr      s0, [x8, #0xd00]
0x0003e7e0  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x0003e7e4  mov      x0, x21
0x0003e7e8  bl       #0x55d78   ; CALL _objc_release
0x0003e7ec  mov      x0, x20
0x0003e7f0  bl       #0x55d78   ; CALL _objc_release
0x0003e7f4  mov      x0, x19
0x0003e7f8  bl       #0x59a20   ; CALL objc_msgSend$previewShadow
0x0003e7fc  mov      x29, x29
0x0003e800  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e804  mov      x20, x0
0x0003e808  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003e80c  mov      x29, x29
0x0003e810  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e814  mov      x21, x0
0x0003e818  fmov     d0, #12.00000000
0x0003e81c  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x0003e820  mov      x0, x21
0x0003e824  bl       #0x55d78   ; CALL _objc_release
0x0003e828  mov      x0, x20
0x0003e82c  bl       #0x55d78   ; CALL _objc_release
0x0003e830  mov      x0, x19
0x0003e834  bl       #0x59a20   ; CALL objc_msgSend$previewShadow
0x0003e838  mov      x29, x29
0x0003e83c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e840  mov      x20, x0
0x0003e844  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003e848  mov      x29, x29
0x0003e84c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e850  mov      x21, x0
0x0003e854  fmov     d0, xzr
0x0003e858  fmov     d1, #6.00000000
0x0003e85c  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x0003e860  mov      x0, x21
0x0003e864  bl       #0x55d78   ; CALL _objc_release
0x0003e868  mov      x0, x20
0x0003e86c  bl       #0x55d78   ; CALL _objc_release
0x0003e870  mov      x0, x19
0x0003e874  bl       #0x59a00   ; CALL objc_msgSend$previewHeader
0x0003e878  mov      x29, x29
0x0003e87c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e880  mov      x20, x0
0x0003e884  mov      x0, x19
0x0003e888  bl       #0x59a20   ; CALL objc_msgSend$previewShadow
0x0003e88c  mov      x29, x29
0x0003e890  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e894  mov      x21, x0
0x0003e898  mov      x0, x20
0x0003e89c  mov      x2, x21
0x0003e8a0  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0003e8a4  mov      x0, x21
0x0003e8a8  bl       #0x55d78   ; CALL _objc_release
0x0003e8ac  mov      x0, x20
0x0003e8b0  bl       #0x55d78   ; CALL _objc_release
0x0003e8b4  adrp     x8, #0x8e000
0x0003e8b8  ldr      x0, [x8, #0xc48]   ; @CLASS SSStartupView
0x0003e8bc  bl       #0x55c7c   ; CALL _objc_alloc
0x0003e8c0  mov      x8, #0x405e000000000000
0x0003e8c4  fmov     d3, x8
0x0003e8c8  fmov     d0, xzr
0x0003e8cc  fmov     d1, xzr
0x0003e8d0  mov      v2.16b, v8.16b
0x0003e8d4  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0003e8d8  mov      x20, x0
0x0003e8dc  mov      x0, x19
0x0003e8e0  mov      x2, x20
0x0003e8e4  bl       #0x5bcc0   ; CALL objc_msgSend$setPreview:
0x0003e8e8  mov      x0, x20
0x0003e8ec  bl       #0x55d78   ; CALL _objc_release
0x0003e8f0  mov      x0, x19
0x0003e8f4  bl       #0x599e0   ; CALL objc_msgSend$preview
0x0003e8f8  mov      x29, x29
0x0003e8fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e900  mov      x20, x0
0x0003e904  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003e908  mov      x29, x29
0x0003e90c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e910  mov      x21, x0
0x0003e914  fmov     d0, #20.00000000
0x0003e918  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0003e91c  mov      x0, x21
0x0003e920  bl       #0x55d78   ; CALL _objc_release
0x0003e924  mov      x0, x20
0x0003e928  bl       #0x55d78   ; CALL _objc_release
0x0003e92c  adrp     x8, #0x74000
0x0003e930  ldr      x8, [x8, #0x648]   ; @GOT _kCACornerCurveContinuous
0x0003e934  ldr      x20, [x8]   ; @GOT ___objc_personality_v0
0x0003e938  mov      x0, x19
0x0003e93c  bl       #0x599e0   ; CALL objc_msgSend$preview
0x0003e940  mov      x29, x29
0x0003e944  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e948  mov      x21, x0
0x0003e94c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003e950  mov      x29, x29
0x0003e954  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e958  mov      x22, x0
0x0003e95c  mov      x2, x20
0x0003e960  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x0003e964  mov      x0, x22
0x0003e968  bl       #0x55d78   ; CALL _objc_release
0x0003e96c  mov      x0, x21
0x0003e970  bl       #0x55d78   ; CALL _objc_release
0x0003e974  mov      x0, x19
0x0003e978  bl       #0x599e0   ; CALL objc_msgSend$preview
0x0003e97c  mov      x29, x29
0x0003e980  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e984  mov      x20, x0
0x0003e988  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003e98c  mov      x29, x29
0x0003e990  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e994  mov      x21, x0
0x0003e998  fmov     d0, #0.50000000
0x0003e99c  bl       #0x5a740   ; CALL objc_msgSend$setBorderWidth:
0x0003e9a0  mov      x0, x21
0x0003e9a4  bl       #0x55d78   ; CALL _objc_release
0x0003e9a8  mov      x0, x20
0x0003e9ac  bl       #0x55d78   ; CALL _objc_release
0x0003e9b0  ldr      x0, [x24, #0x910]   ; @CLASS UIColor
0x0003e9b4  adrp     x8, #0x65000
0x0003e9b8  ldr      d1, [x8, #0xe50]
0x0003e9bc  fmov     d0, #1.00000000
0x0003e9c0  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0003e9c4  mov      x29, x29
0x0003e9c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e9cc  mov      x20, x0
0x0003e9d0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0003e9d4  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0003e9d8  mov      x21, x0
0x0003e9dc  mov      x0, x19
0x0003e9e0  bl       #0x599e0   ; CALL objc_msgSend$preview
0x0003e9e4  mov      x29, x29
0x0003e9e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e9ec  mov      x22, x0
0x0003e9f0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003e9f4  mov      x29, x29
0x0003e9f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003e9fc  mov      x23, x0
0x0003ea00  mov      x2, x21
0x0003ea04  bl       #0x5a700   ; CALL objc_msgSend$setBorderColor:
0x0003ea08  mov      x0, x23
0x0003ea0c  bl       #0x55d78   ; CALL _objc_release
0x0003ea10  mov      x0, x22
0x0003ea14  bl       #0x55d78   ; CALL _objc_release
0x0003ea18  mov      x0, x20
0x0003ea1c  bl       #0x55d78   ; CALL _objc_release
0x0003ea20  mov      x0, x19
0x0003ea24  bl       #0x599e0   ; CALL objc_msgSend$preview
0x0003ea28  mov      x29, x29
0x0003ea2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ea30  mov      x20, x0
0x0003ea34  mov      w2, #0x12
0x0003ea38  bl       #0x5a500   ; CALL objc_msgSend$setAutoresizingMask:
0x0003ea3c  mov      x0, x20
0x0003ea40  bl       #0x55d78   ; CALL _objc_release
0x0003ea44  mov      x0, x19
0x0003ea48  bl       #0x599e0   ; CALL objc_msgSend$preview
0x0003ea4c  mov      x29, x29
0x0003ea50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ea54  mov      x20, x0
0x0003ea58  adrp     x8, #0x8e000
0x0003ea5c  ldr      x0, [x8, #0xba8]   ; @CLASS UITapGestureRecognizer
0x0003ea60  bl       #0x55c7c   ; CALL _objc_alloc
0x0003ea64  mov      x21, x0
0x0003ea68  mov      x0, x19
0x0003ea6c  bl       #0x599e0   ; CALL objc_msgSend$preview
0x0003ea70  mov      x29, x29
0x0003ea74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ea78  mov      x22, x0
0x0003ea7c  adrp     x8, #0x8c000
0x0003ea80  ldr      x3, [x8, #0xd98]   ; @SEL "playIntro"
0x0003ea84  mov      x0, x21
0x0003ea88  mov      x2, x22
0x0003ea8c  bl       #0x585e0   ; CALL objc_msgSend$initWithTarget:action:
0x0003ea90  mov      x21, x0
0x0003ea94  mov      x0, x20
0x0003ea98  mov      x2, x21
0x0003ea9c  bl       #0x560e0   ; CALL objc_msgSend$addGestureRecognizer:
0x0003eaa0  mov      x0, x21
0x0003eaa4  bl       #0x55d78   ; CALL _objc_release
0x0003eaa8  mov      x0, x22
0x0003eaac  bl       #0x55d78   ; CALL _objc_release
0x0003eab0  mov      x0, x20
0x0003eab4  bl       #0x55d78   ; CALL _objc_release
0x0003eab8  mov      x0, x19
0x0003eabc  bl       #0x59a20   ; CALL objc_msgSend$previewShadow
0x0003eac0  mov      x29, x29
0x0003eac4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003eac8  mov      x20, x0
0x0003eacc  mov      x0, x19
0x0003ead0  bl       #0x599e0   ; CALL objc_msgSend$preview
0x0003ead4  mov      x29, x29
0x0003ead8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003eadc  mov      x21, x0
0x0003eae0  mov      x0, x20
0x0003eae4  mov      x2, x21
0x0003eae8  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0003eaec  mov      x0, x21
0x0003eaf0  bl       #0x55d78   ; CALL _objc_release
0x0003eaf4  mov      x0, x20
0x0003eaf8  bl       #0x55d78   ; CALL _objc_release
0x0003eafc  adrp     x22, #0x8e000
0x0003eb00  ldr      x0, [x22, #0x940]   ; @CLASS UILabel
0x0003eb04  bl       #0x55d60   ; CALL _objc_opt_new
0x0003eb08  mov      x20, x0
0x0003eb0c  mov      x0, x19
0x0003eb10  mov      x2, x20
0x0003eb14  bl       #0x5af40   ; CALL objc_msgSend$setGalleryTitle:
0x0003eb18  mov      x0, x20
0x0003eb1c  bl       #0x55d78   ; CALL _objc_release
0x0003eb20  adrp     x23, #0x8e000
0x0003eb24  ldr      x0, [x23, #0x948]   ; @CLASS UIFont
0x0003eb28  adrp     x8, #0x74000
0x0003eb2c  ldr      x8, [x8, #0x250]   ; @GOT _UIFontWeightMedium
0x0003eb30  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x0003eb34  fmov     d0, #14.00000000
0x0003eb38  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x0003eb3c  mov      x29, x29
0x0003eb40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003eb44  mov      x20, x0
0x0003eb48  mov      x0, x19
0x0003eb4c  bl       #0x57dc0   ; CALL objc_msgSend$galleryTitle
0x0003eb50  mov      x29, x29
0x0003eb54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003eb58  mov      x21, x0
0x0003eb5c  mov      x2, x20
0x0003eb60  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x0003eb64  mov      x0, x21
0x0003eb68  bl       #0x55d78   ; CALL _objc_release
0x0003eb6c  mov      x0, x20
0x0003eb70  bl       #0x55d78   ; CALL _objc_release
0x0003eb74  ldr      x0, [x24, #0x910]   ; @CLASS UIColor
0x0003eb78  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x0003eb7c  mov      x29, x29
0x0003eb80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003eb84  mov      x20, x0
0x0003eb88  mov      x0, x19
0x0003eb8c  bl       #0x57dc0   ; CALL objc_msgSend$galleryTitle
0x0003eb90  mov      x29, x29
0x0003eb94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003eb98  mov      x21, x0
0x0003eb9c  mov      x2, x20
0x0003eba0  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0003eba4  mov      x0, x21
0x0003eba8  bl       #0x55d78   ; CALL _objc_release
0x0003ebac  mov      x0, x20
0x0003ebb0  bl       #0x55d78   ; CALL _objc_release
0x0003ebb4  mov      x0, x19
0x0003ebb8  bl       #0x59a00   ; CALL objc_msgSend$previewHeader
0x0003ebbc  mov      x29, x29
0x0003ebc0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ebc4  mov      x20, x0
0x0003ebc8  mov      x0, x19
0x0003ebcc  bl       #0x57dc0   ; CALL objc_msgSend$galleryTitle
0x0003ebd0  mov      x29, x29
0x0003ebd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ebd8  mov      x21, x0
0x0003ebdc  mov      x0, x20
0x0003ebe0  mov      x2, x21
0x0003ebe4  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0003ebe8  mov      x0, x21
0x0003ebec  bl       #0x55d78   ; CALL _objc_release
0x0003ebf0  mov      x0, x20
0x0003ebf4  bl       #0x55d78   ; CALL _objc_release
0x0003ebf8  ldr      x0, [x22, #0x940]   ; @CLASS UILabel
0x0003ebfc  bl       #0x55d60   ; CALL _objc_opt_new
0x0003ec00  mov      x20, x0
0x0003ec04  mov      x0, x19
0x0003ec08  mov      x2, x20
0x0003ec0c  bl       #0x5af20   ; CALL objc_msgSend$setGalleryHint:
0x0003ec10  mov      x0, x20
0x0003ec14  bl       #0x55d78   ; CALL _objc_release
0x0003ec18  ldr      x0, [x23, #0x948]   ; @CLASS UIFont
0x0003ec1c  fmov     d0, #12.00000000
0x0003ec20  bl       #0x5d7c0   ; CALL objc_msgSend$systemFontOfSize:
0x0003ec24  mov      x29, x29
0x0003ec28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ec2c  mov      x20, x0
0x0003ec30  mov      x0, x19
0x0003ec34  bl       #0x57da0   ; CALL objc_msgSend$galleryHint
0x0003ec38  mov      x29, x29
0x0003ec3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ec40  mov      x21, x0
0x0003ec44  mov      x2, x20
0x0003ec48  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x0003ec4c  mov      x0, x21
0x0003ec50  bl       #0x55d78   ; CALL _objc_release
0x0003ec54  mov      x0, x20
0x0003ec58  bl       #0x55d78   ; CALL _objc_release
0x0003ec5c  ldr      x0, [x24, #0x910]   ; @CLASS UIColor
0x0003ec60  bl       #0x5d960   ; CALL objc_msgSend$tertiaryLabelColor
0x0003ec64  mov      x29, x29
0x0003ec68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ec6c  mov      x20, x0
0x0003ec70  mov      x0, x19
0x0003ec74  bl       #0x57da0   ; CALL objc_msgSend$galleryHint
0x0003ec78  mov      x29, x29
0x0003ec7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ec80  mov      x21, x0
0x0003ec84  mov      x2, x20
0x0003ec88  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0003ec8c  mov      x0, x21
0x0003ec90  bl       #0x55d78   ; CALL _objc_release
0x0003ec94  mov      x0, x20
0x0003ec98  bl       #0x55d78   ; CALL _objc_release
0x0003ec9c  mov      x0, x19
0x0003eca0  bl       #0x57da0   ; CALL objc_msgSend$galleryHint
0x0003eca4  mov      x29, x29
0x0003eca8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ecac  mov      x20, x0
0x0003ecb0  mov      w2, #2
0x0003ecb4  bl       #0x5c4e0   ; CALL objc_msgSend$setTextAlignment:
0x0003ecb8  mov      x0, x20
0x0003ecbc  bl       #0x55d78   ; CALL _objc_release
0x0003ecc0  mov      x0, x19
0x0003ecc4  bl       #0x57da0   ; CALL objc_msgSend$galleryHint
0x0003ecc8  mov      x29, x29
0x0003eccc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ecd0  mov      x20, x0
0x0003ecd4  mov      w2, #1
0x0003ecd8  bl       #0x5a380   ; CALL objc_msgSend$setAdjustsFontSizeToFitWidth:
0x0003ecdc  mov      x0, x20
0x0003ece0  bl       #0x55d78   ; CALL _objc_release
0x0003ece4  mov      x0, x19
0x0003ece8  bl       #0x57da0   ; CALL objc_msgSend$galleryHint
0x0003ecec  mov      x29, x29
0x0003ecf0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ecf4  mov      x20, x0
0x0003ecf8  adrp     x8, #0x65000
0x0003ecfc  ldr      d0, [x8, #0x670]
0x0003ed00  bl       #0x5b660   ; CALL objc_msgSend$setMinimumScaleFactor:
0x0003ed04  mov      x0, x20
0x0003ed08  bl       #0x55d78   ; CALL _objc_release
0x0003ed0c  mov      x0, x19
0x0003ed10  bl       #0x59a00   ; CALL objc_msgSend$previewHeader
0x0003ed14  mov      x29, x29
0x0003ed18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ed1c  mov      x20, x0
0x0003ed20  mov      x0, x19
0x0003ed24  bl       #0x57da0   ; CALL objc_msgSend$galleryHint
0x0003ed28  mov      x29, x29
0x0003ed2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ed30  mov      x21, x0
0x0003ed34  mov      x0, x20
0x0003ed38  mov      x2, x21
0x0003ed3c  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0003ed40  mov      x0, x21
0x0003ed44  bl       #0x55d78   ; CALL _objc_release
0x0003ed48  mov      x0, x20
0x0003ed4c  bl       #0x55d78   ; CALL _objc_release
0x0003ed50  adrp     x8, #0x8e000
0x0003ed54  ldr      x0, [x8, #0xc50]   ; @CLASS UICollectionViewFlowLayout
0x0003ed58  bl       #0x55d60   ; CALL _objc_opt_new
0x0003ed5c  mov      x20, x0
0x0003ed60  mov      w2, #1
0x0003ed64  bl       #0x5bf00   ; CALL objc_msgSend$setScrollDirection:
0x0003ed68  adrp     x8, #0x65000
0x0003ed6c  ldr      d0, [x8, #0x9f8]
0x0003ed70  mov      x8, #0x405b000000000000
0x0003ed74  fmov     d9, x8
0x0003ed78  mov      x0, x20
0x0003ed7c  mov      v1.16b, v9.16b
0x0003ed80  bl       #0x5b1a0   ; CALL objc_msgSend$setItemSize:
0x0003ed84  fmov     d0, #4.00000000
0x0003ed88  mov      x0, x20
0x0003ed8c  bl       #0x5b640   ; CALL objc_msgSend$setMinimumLineSpacing:
0x0003ed90  fmov     d0, xzr
0x0003ed94  mov      x0, x20
0x0003ed98  bl       #0x5b620   ; CALL objc_msgSend$setMinimumInteritemSpacing:
0x0003ed9c  fmov     d0, xzr
0x0003eda0  fmov     d1, #14.00000000
0x0003eda4  fmov     d2, xzr
0x0003eda8  fmov     d3, #14.00000000
0x0003edac  mov      x0, x20
0x0003edb0  bl       #0x5bf40   ; CALL objc_msgSend$setSectionInset:
0x0003edb4  adrp     x8, #0x8e000
0x0003edb8  ldr      x0, [x8, #0xc58]   ; @CLASS UICollectionView
0x0003edbc  bl       #0x55c7c   ; CALL _objc_alloc
0x0003edc0  fmov     d0, xzr
0x0003edc4  fmov     d1, xzr
0x0003edc8  mov      v2.16b, v8.16b
0x0003edcc  mov      v3.16b, v9.16b
0x0003edd0  mov      x2, x20
0x0003edd4  bl       #0x58480   ; CALL objc_msgSend$initWithFrame:collectionViewLayout:
0x0003edd8  mov      x21, x0
0x0003eddc  mov      x0, x19
0x0003ede0  mov      x2, x21
0x0003ede4  bl       #0x5af00   ; CALL objc_msgSend$setGallery:
0x0003ede8  mov      x0, x21
0x0003edec  bl       #0x55d78   ; CALL _objc_release
0x0003edf0  ldr      x0, [x24, #0x910]   ; @CLASS UIColor
0x0003edf4  bl       #0x56de0   ; CALL objc_msgSend$clearColor
0x0003edf8  mov      x29, x29
0x0003edfc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ee00  mov      x21, x0
0x0003ee04  mov      x0, x19
0x0003ee08  bl       #0x57d80   ; CALL objc_msgSend$gallery
0x0003ee0c  mov      x29, x29
0x0003ee10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ee14  mov      x22, x0
0x0003ee18  mov      x2, x21
0x0003ee1c  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0003ee20  mov      x0, x22
0x0003ee24  bl       #0x55d78   ; CALL _objc_release
0x0003ee28  mov      x0, x21
0x0003ee2c  bl       #0x55d78   ; CALL _objc_release
0x0003ee30  mov      x0, x19
0x0003ee34  bl       #0x57d80   ; CALL objc_msgSend$gallery
0x0003ee38  mov      x29, x29
0x0003ee3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ee40  mov      x21, x0
0x0003ee44  mov      w2, #0
0x0003ee48  bl       #0x5c140   ; CALL objc_msgSend$setShowsHorizontalScrollIndicator:
0x0003ee4c  mov      x0, x21
0x0003ee50  bl       #0x55d78   ; CALL _objc_release
0x0003ee54  mov      x0, x19
0x0003ee58  bl       #0x57d80   ; CALL objc_msgSend$gallery
0x0003ee5c  mov      x29, x29
0x0003ee60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ee64  mov      x21, x0
0x0003ee68  mov      w2, #1
0x0003ee6c  bl       #0x5a400   ; CALL objc_msgSend$setAlwaysBounceHorizontal:
0x0003ee70  mov      x0, x21
0x0003ee74  bl       #0x55d78   ; CALL _objc_release
0x0003ee78  mov      x0, x19
0x0003ee7c  bl       #0x57d80   ; CALL objc_msgSend$gallery
0x0003ee80  mov      x29, x29
0x0003ee84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ee88  mov      x21, x0
0x0003ee8c  mov      w2, #0
0x0003ee90  bl       #0x5a8a0   ; CALL objc_msgSend$setClipsToBounds:
0x0003ee94  mov      x0, x21
0x0003ee98  bl       #0x55d78   ; CALL _objc_release
0x0003ee9c  mov      x0, x19
0x0003eea0  bl       #0x57d80   ; CALL objc_msgSend$gallery
0x0003eea4  mov      x29, x29
0x0003eea8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003eeac  mov      x21, x0
0x0003eeb0  mov      x2, x19
0x0003eeb4  bl       #0x5ac00   ; CALL objc_msgSend$setDataSource:
0x0003eeb8  mov      x0, x21
0x0003eebc  bl       #0x55d78   ; CALL _objc_release
0x0003eec0  mov      x0, x19
0x0003eec4  bl       #0x57d80   ; CALL objc_msgSend$gallery
0x0003eec8  mov      x29, x29
0x0003eecc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003eed0  mov      x21, x0
0x0003eed4  mov      x2, x19
0x0003eed8  bl       #0x5aca0   ; CALL objc_msgSend$setDelegate:
0x0003eedc  mov      x0, x21
0x0003eee0  bl       #0x55d78   ; CALL _objc_release
0x0003eee4  mov      x0, x19
0x0003eee8  bl       #0x57d80   ; CALL objc_msgSend$gallery
0x0003eeec  mov      x29, x29
0x0003eef0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003eef4  mov      x21, x0
0x0003eef8  adrp     x8, #0x8e000
0x0003eefc  ldr      x0, [x8, #0xc60]   ; @CLASS OMCSSStyleTileCell
0x0003ef00  bl       #0x55d48   ; CALL _objc_opt_class
0x0003ef04  mov      x2, x0
0x0003ef08  adrp     x3, #0x7c000
0x0003ef0c  add      x3, x3, #0x688   ; STR "tile"
0x0003ef10  mov      x0, x21
0x0003ef14  bl       #0x59c40   ; CALL objc_msgSend$registerClass:forCellWithReuseIdentifier:
0x0003ef18  mov      x0, x21
0x0003ef1c  bl       #0x55d78   ; CALL _objc_release
0x0003ef20  mov      x0, x19
0x0003ef24  bl       #0x59a00   ; CALL objc_msgSend$previewHeader
0x0003ef28  mov      x29, x29
0x0003ef2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ef30  mov      x21, x0
0x0003ef34  mov      x0, x19
0x0003ef38  bl       #0x57d80   ; CALL objc_msgSend$gallery
0x0003ef3c  mov      x29, x29
0x0003ef40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ef44  mov      x19, x0
0x0003ef48  mov      x0, x21
0x0003ef4c  mov      x2, x19
0x0003ef50  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0003ef54  mov      x0, x19
0x0003ef58  bl       #0x55d78   ; CALL _objc_release
0x0003ef5c  mov      x0, x21
0x0003ef60  bl       #0x55d78   ; CALL _objc_release
0x0003ef64  mov      x0, x20
0x0003ef68  bl       #0x55d78   ; CALL _objc_release
0x0003ef6c  ldp      x29, x30, [sp, #0x50]
0x0003ef70  ldp      x20, x19, [sp, #0x40]
0x0003ef74  ldp      x22, x21, [sp, #0x30]
0x0003ef78  ldp      x24, x23, [sp, #0x20]
0x0003ef7c  ldp      d9, d8, [sp, #0x10]
0x0003ef80  add      sp, sp, #0x60
0x0003ef84  ret      

=== -[OMCStartupScreenController viewWillAppear:]  va=0x3ef88 size=248 types=v20@0:8B16
0x0003ef88  sub      sp, sp, #0x40
0x0003ef8c  stp      x22, x21, [sp, #0x10]
0x0003ef90  stp      x20, x19, [sp, #0x20]
0x0003ef94  stp      x29, x30, [sp, #0x30]
0x0003ef98  add      x29, sp, #0x30
0x0003ef9c  mov      x19, x0
0x0003efa0  adrp     x8, #0x8e000
0x0003efa4  ldr      x8, [x8, #0xdb0]   ; @SUPER OMCStartupScreenController
0x0003efa8  stp      x0, x8, [sp]
0x0003efac  adrp     x8, #0x8b000
0x0003efb0  ldr      x1, [x8, #0xda8]   ; @SEL "viewWillAppear:"
0x0003efb4  mov      x0, sp
0x0003efb8  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0003efbc  adrp     x0, #0x7c000
0x0003efc0  add      x0, x0, #0x6a8   ; STR "STARTUPSCREEN_STYLE_GROUP"
0x0003efc4  bl       #0x17e20   ; CALL _L
0x0003efc8  mov      x29, x29
0x0003efcc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003efd0  mov      x20, x0
0x0003efd4  mov      x0, x19
0x0003efd8  bl       #0x57dc0   ; CALL objc_msgSend$galleryTitle
0x0003efdc  mov      x29, x29
0x0003efe0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003efe4  mov      x21, x0
0x0003efe8  mov      x2, x20
0x0003efec  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0003eff0  mov      x0, x21
0x0003eff4  bl       #0x55d78   ; CALL _objc_release
0x0003eff8  mov      x0, x20
0x0003effc  bl       #0x55d78   ; CALL _objc_release
0x0003f000  adrp     x0, #0x7c000
0x0003f004  add      x0, x0, #0x6c8   ; STR "STARTUPSCREEN_REPLAY_HINT"
0x0003f008  bl       #0x17e20   ; CALL _L
0x0003f00c  mov      x29, x29
0x0003f010  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f014  mov      x20, x0
0x0003f018  mov      x0, x19
0x0003f01c  bl       #0x57da0   ; CALL objc_msgSend$galleryHint
0x0003f020  mov      x29, x29
0x0003f024  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f028  mov      x21, x0
0x0003f02c  mov      x2, x20
0x0003f030  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0003f034  mov      x0, x21
0x0003f038  bl       #0x55d78   ; CALL _objc_release
0x0003f03c  mov      x0, x20
0x0003f040  bl       #0x55d78   ; CALL _objc_release
0x0003f044  mov      x0, x19
0x0003f048  bl       #0x57d80   ; CALL objc_msgSend$gallery
0x0003f04c  mov      x29, x29
0x0003f050  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f054  mov      x20, x0
0x0003f058  bl       #0x59ca0   ; CALL objc_msgSend$reloadData
0x0003f05c  mov      x0, x20
0x0003f060  bl       #0x55d78   ; CALL _objc_release
0x0003f064  mov      x0, x19
0x0003f068  bl       #0x5dd80   ; CALL objc_msgSend$updatePreview
0x0003f06c  ldp      x29, x30, [sp, #0x30]
0x0003f070  ldp      x20, x19, [sp, #0x20]
0x0003f074  ldp      x22, x21, [sp, #0x10]
0x0003f078  add      sp, sp, #0x40
0x0003f07c  ret      

=== -[OMCStartupScreenController viewWillDisappear:]  va=0x3f080 size=108 types=v20@0:8B16
0x0003f080  sub      sp, sp, #0x30
0x0003f084  stp      x20, x19, [sp, #0x10]
0x0003f088  stp      x29, x30, [sp, #0x20]
0x0003f08c  add      x29, sp, #0x20
0x0003f090  mov      x19, x0
0x0003f094  adrp     x8, #0x8e000
0x0003f098  ldr      x8, [x8, #0xdb0]   ; @SUPER OMCStartupScreenController
0x0003f09c  stp      x0, x8, [sp]
0x0003f0a0  adrp     x8, #0x8b000
0x0003f0a4  ldr      x1, [x8, #0xe08]   ; @SEL "viewWillDisappear:"
0x0003f0a8  mov      x0, sp
0x0003f0ac  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0003f0b0  mov      x0, x19
0x0003f0b4  bl       #0x5cd20   ; CALL objc_msgSend$soundPlayer
0x0003f0b8  mov      x29, x29
0x0003f0bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f0c0  mov      x20, x0
0x0003f0c4  bl       #0x5d360   ; CALL objc_msgSend$stop
0x0003f0c8  mov      x0, x20
0x0003f0cc  bl       #0x55d78   ; CALL _objc_release
0x0003f0d0  mov      x0, x19
0x0003f0d4  mov      x2, #0
0x0003f0d8  bl       #0x5c1c0   ; CALL objc_msgSend$setSoundPlayer:
0x0003f0dc  ldp      x29, x30, [sp, #0x20]
0x0003f0e0  ldp      x20, x19, [sp, #0x10]
0x0003f0e4  add      sp, sp, #0x30
0x0003f0e8  ret      

=== -[OMCStartupScreenController viewDidLayoutSubviews]  va=0x3f0ec size=896 types=v16@0:8
0x0003f0ec  sub      sp, sp, #0x90
0x0003f0f0  stp      d15, d14, [sp, #0x10]
0x0003f0f4  stp      d13, d12, [sp, #0x20]
0x0003f0f8  stp      d11, d10, [sp, #0x30]
0x0003f0fc  stp      d9, d8, [sp, #0x40]
0x0003f100  stp      x24, x23, [sp, #0x50]
0x0003f104  stp      x22, x21, [sp, #0x60]
0x0003f108  stp      x20, x19, [sp, #0x70]
0x0003f10c  stp      x29, x30, [sp, #0x80]
0x0003f110  add      x29, sp, #0x80
0x0003f114  mov      x19, x0
0x0003f118  adrp     x8, #0x8e000
0x0003f11c  ldr      x8, [x8, #0xdb0]   ; @SUPER OMCStartupScreenController
0x0003f120  stp      x0, x8, [sp]
0x0003f124  adrp     x8, #0x8b000
0x0003f128  ldr      x1, [x8, #0xe10]   ; @SEL "viewDidLayoutSubviews"
0x0003f12c  mov      x0, sp
0x0003f130  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0003f134  mov      x0, x19
0x0003f138  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x0003f13c  mov      x29, x29
0x0003f140  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f144  mov      x20, x0
0x0003f148  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0003f14c  mov      v8.16b, v2.16b
0x0003f150  mov      x0, x20
0x0003f154  bl       #0x55d78   ; CALL _objc_release
0x0003f158  fcmp     d8, #0.0
0x0003f15c  b.ls     #0x3f444
0x0003f160  mov      x0, x19
0x0003f164  bl       #0x59a40   ; CALL objc_msgSend$previewWidth
0x0003f168  fabd     d0, d8, d0
0x0003f16c  fmov     d14, #0.50000000
0x0003f170  fcmp     d0, d14
0x0003f174  b.mi     #0x3f444
0x0003f178  mov      x0, x19
0x0003f17c  mov      v0.16b, v8.16b
0x0003f180  bl       #0x5bd20   ; CALL objc_msgSend$setPreviewWidth:
0x0003f184  mov      x8, #-0x3fbc000000000000
0x0003f188  fmov     d0, x8
0x0003f18c  fadd     d13, d8, d0
0x0003f190  adrp     x8, #0x65000
0x0003f194  ldr      d0, [x8, #0xe98]
0x0003f198  fcmp     d13, d0
0x0003f19c  fcsel    d9, d0, d13, gt
0x0003f1a0  fmov     d0, #0.37500000
0x0003f1a4  fmul     d0, d9, d0
0x0003f1a8  frinta   d10, d0
0x0003f1ac  fsub     d0, d8, d9
0x0003f1b0  fmul     d0, d0, d14
0x0003f1b4  frinta   d11, d0
0x0003f1b8  mov      x0, x19
0x0003f1bc  bl       #0x59a20   ; CALL objc_msgSend$previewShadow
0x0003f1c0  mov      x29, x29
0x0003f1c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f1c8  mov      x20, x0
0x0003f1cc  fmov     d1, #18.00000000
0x0003f1d0  mov      v0.16b, v11.16b
0x0003f1d4  mov      v2.16b, v9.16b
0x0003f1d8  mov      v3.16b, v10.16b
0x0003f1dc  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0003f1e0  mov      x0, x20
0x0003f1e4  bl       #0x55d78   ; CALL _objc_release
0x0003f1e8  mov      x0, x19
0x0003f1ec  bl       #0x59a20   ; CALL objc_msgSend$previewShadow
0x0003f1f0  mov      x29, x29
0x0003f1f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f1f8  mov      x20, x0
0x0003f1fc  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0003f200  mov      v9.16b, v0.16b
0x0003f204  mov      v10.16b, v1.16b
0x0003f208  mov      v11.16b, v2.16b
0x0003f20c  mov      v12.16b, v3.16b
0x0003f210  mov      x0, x19
0x0003f214  bl       #0x599e0   ; CALL objc_msgSend$preview
0x0003f218  mov      x29, x29
0x0003f21c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f220  mov      x21, x0
0x0003f224  mov      v0.16b, v9.16b
0x0003f228  mov      v1.16b, v10.16b
0x0003f22c  mov      v2.16b, v11.16b
0x0003f230  mov      v3.16b, v12.16b
0x0003f234  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0003f238  mov      x0, x21
0x0003f23c  bl       #0x55d78   ; CALL _objc_release
0x0003f240  mov      x0, x20
0x0003f244  bl       #0x55d78   ; CALL _objc_release
0x0003f248  adrp     x8, #0x8e000
0x0003f24c  ldr      x21, [x8, #0xac0]   ; @CLASS UIBezierPath
0x0003f250  mov      x0, x19
0x0003f254  bl       #0x59a20   ; CALL objc_msgSend$previewShadow
0x0003f258  mov      x29, x29
0x0003f25c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f260  mov      x20, x0
0x0003f264  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0003f268  fmov     d12, #20.00000000
0x0003f26c  fmov     d4, #20.00000000
0x0003f270  mov      x0, x21
0x0003f274  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x0003f278  mov      x29, x29
0x0003f27c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f280  mov      x21, x0
0x0003f284  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0003f288  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x0003f28c  mov      x22, x0
0x0003f290  mov      x0, x19
0x0003f294  bl       #0x59a20   ; CALL objc_msgSend$previewShadow
0x0003f298  mov      x29, x29
0x0003f29c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f2a0  mov      x23, x0
0x0003f2a4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0003f2a8  mov      x29, x29
0x0003f2ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f2b0  mov      x24, x0
0x0003f2b4  mov      x2, x22
0x0003f2b8  bl       #0x5c020   ; CALL objc_msgSend$setShadowPath:
0x0003f2bc  mov      x0, x24
0x0003f2c0  bl       #0x55d78   ; CALL _objc_release
0x0003f2c4  mov      x0, x23
0x0003f2c8  bl       #0x55d78   ; CALL _objc_release
0x0003f2cc  mov      x0, x21
0x0003f2d0  bl       #0x55d78   ; CALL _objc_release
0x0003f2d4  mov      x0, x20
0x0003f2d8  bl       #0x55d78   ; CALL _objc_release
0x0003f2dc  mov      x0, x19
0x0003f2e0  bl       #0x59a20   ; CALL objc_msgSend$previewShadow
0x0003f2e4  mov      x29, x29
0x0003f2e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f2ec  mov      x20, x0
0x0003f2f0  bl       #0x57d00   ; CALL objc_msgSend$frame
0x0003f2f4  bl       #0x55a54   ; CALL _CGRectGetMaxY
0x0003f2f8  fadd     d9, d0, d12
0x0003f2fc  mov      x0, x20
0x0003f300  bl       #0x55d78   ; CALL _objc_release
0x0003f304  fmul     d0, d13, d14
0x0003f308  frintm   d10, d0
0x0003f30c  mov      x0, x19
0x0003f310  bl       #0x57dc0   ; CALL objc_msgSend$galleryTitle
0x0003f314  mov      x29, x29
0x0003f318  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f31c  mov      x20, x0
0x0003f320  fmov     d0, #20.00000000
0x0003f324  fmov     d3, #18.00000000
0x0003f328  mov      v1.16b, v9.16b
0x0003f32c  mov      v2.16b, v10.16b
0x0003f330  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0003f334  mov      x0, x20
0x0003f338  bl       #0x55d78   ; CALL _objc_release
0x0003f33c  fadd     d11, d10, d12
0x0003f340  fsub     d10, d13, d10
0x0003f344  mov      x0, x19
0x0003f348  bl       #0x57da0   ; CALL objc_msgSend$galleryHint
0x0003f34c  mov      x29, x29
0x0003f350  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f354  mov      x20, x0
0x0003f358  fmov     d3, #18.00000000
0x0003f35c  mov      v0.16b, v11.16b
0x0003f360  mov      v1.16b, v9.16b
0x0003f364  mov      v2.16b, v10.16b
0x0003f368  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0003f36c  mov      x0, x20
0x0003f370  bl       #0x55d78   ; CALL _objc_release
0x0003f374  fadd     d9, d9, d12
0x0003f378  mov      x0, x19
0x0003f37c  bl       #0x57d80   ; CALL objc_msgSend$gallery
0x0003f380  mov      x29, x29
0x0003f384  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f388  mov      x20, x0
0x0003f38c  mov      x8, #0x405b000000000000
0x0003f390  fmov     d10, x8
0x0003f394  fmov     d0, xzr
0x0003f398  mov      v1.16b, v9.16b
0x0003f39c  mov      v2.16b, v8.16b
0x0003f3a0  mov      v3.16b, v10.16b
0x0003f3a4  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0003f3a8  mov      x0, x20
0x0003f3ac  bl       #0x55d78   ; CALL _objc_release
0x0003f3b0  fadd     d0, d9, d10
0x0003f3b4  fmov     d1, #2.00000000
0x0003f3b8  fadd     d9, d0, d1
0x0003f3bc  mov      x0, x19
0x0003f3c0  bl       #0x59a00   ; CALL objc_msgSend$previewHeader
0x0003f3c4  mov      x29, x29
0x0003f3c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f3cc  mov      x20, x0
0x0003f3d0  fmov     d0, xzr
0x0003f3d4  fmov     d1, xzr
0x0003f3d8  mov      v2.16b, v8.16b
0x0003f3dc  mov      v3.16b, v9.16b
0x0003f3e0  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0003f3e4  mov      x0, x20
0x0003f3e8  bl       #0x55d78   ; CALL _objc_release
0x0003f3ec  mov      x0, x19
0x0003f3f0  bl       #0x59a00   ; CALL objc_msgSend$previewHeader
0x0003f3f4  mov      x29, x29
0x0003f3f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f3fc  mov      x20, x0
0x0003f400  mov      x0, x19
0x0003f404  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x0003f408  mov      x29, x29
0x0003f40c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f410  mov      x21, x0
0x0003f414  mov      x2, x20
0x0003f418  bl       #0x5c460   ; CALL objc_msgSend$setTableHeaderView:
0x0003f41c  mov      x0, x21
0x0003f420  bl       #0x55d78   ; CALL _objc_release
0x0003f424  mov      x0, x20
0x0003f428  bl       #0x55d78   ; CALL _objc_release
0x0003f42c  mov      x0, x19
0x0003f430  bl       #0x574e0   ; CALL objc_msgSend$currentStyle
0x0003f434  mov      x2, x0
0x0003f438  mov      x0, x19
0x0003f43c  mov      w3, #0
0x0003f440  bl       #0x5a120   ; CALL objc_msgSend$scrollGalleryToStyle:animated:
0x0003f444  ldp      x29, x30, [sp, #0x80]
0x0003f448  ldp      x20, x19, [sp, #0x70]
0x0003f44c  ldp      x22, x21, [sp, #0x60]
0x0003f450  ldp      x24, x23, [sp, #0x50]
0x0003f454  ldp      d9, d8, [sp, #0x40]
0x0003f458  ldp      d11, d10, [sp, #0x30]
0x0003f45c  ldp      d13, d12, [sp, #0x20]
0x0003f460  ldp      d15, d14, [sp, #0x10]
0x0003f464  add      sp, sp, #0x90
0x0003f468  ret      

=== -[OMCStartupScreenController scrollGalleryToStyle:animated:]  va=0x3f46c size=228 types=v28@0:8q16B24
0x0003f46c  stp      d9, d8, [sp, #-0x40]!
0x0003f470  stp      x22, x21, [sp, #0x10]
0x0003f474  stp      x20, x19, [sp, #0x20]
0x0003f478  stp      x29, x30, [sp, #0x30]
0x0003f47c  add      x29, sp, #0x30
0x0003f480  mov      x19, x3
0x0003f484  mov      x20, x2
0x0003f488  mov      x21, x0
0x0003f48c  bl       #0x57d80   ; CALL objc_msgSend$gallery
0x0003f490  mov      x29, x29
0x0003f494  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f498  mov      x22, x0
0x0003f49c  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0003f4a0  mov      v8.16b, v2.16b
0x0003f4a4  mov      x0, x22
0x0003f4a8  bl       #0x55d78   ; CALL _objc_release
0x0003f4ac  fcmp     d8, #0.0
0x0003f4b0  b.ls     #0x3f53c
0x0003f4b4  mov      x0, x21
0x0003f4b8  bl       #0x57d80   ; CALL objc_msgSend$gallery
0x0003f4bc  mov      x29, x29
0x0003f4c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f4c4  mov      x22, x0
0x0003f4c8  bl       #0x58b00   ; CALL objc_msgSend$layoutIfNeeded
0x0003f4cc  mov      x0, x22
0x0003f4d0  bl       #0x55d78   ; CALL _objc_release
0x0003f4d4  mov      x0, x21
0x0003f4d8  bl       #0x57d80   ; CALL objc_msgSend$gallery
0x0003f4dc  mov      x29, x29
0x0003f4e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f4e4  mov      x21, x0
0x0003f4e8  adrp     x8, #0x8e000
0x0003f4ec  ldr      x0, [x8, #0xb20]   ; @CLASS NSIndexPath
0x0003f4f0  mov      x2, x20
0x0003f4f4  mov      x3, #0
0x0003f4f8  bl       #0x582e0   ; CALL objc_msgSend$indexPathForItem:inSection:
0x0003f4fc  mov      x29, x29
0x0003f500  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f504  mov      x20, x0
0x0003f508  mov      x0, x21
0x0003f50c  mov      x2, x20
0x0003f510  mov      w3, #0x10
0x0003f514  mov      x4, x19
0x0003f518  bl       #0x5a140   ; CALL objc_msgSend$scrollToItemAtIndexPath:atScrollPosition:animated:
0x0003f51c  mov      x0, x20
0x0003f520  bl       #0x55d78   ; CALL _objc_release
0x0003f524  mov      x0, x21
0x0003f528  ldp      x29, x30, [sp, #0x30]
0x0003f52c  ldp      x20, x19, [sp, #0x20]
0x0003f530  ldp      x22, x21, [sp, #0x10]
0x0003f534  ldp      d9, d8, [sp], #0x40
0x0003f538  b        #0x55d78   ; CALL _objc_release
0x0003f53c  ldp      x29, x30, [sp, #0x30]
0x0003f540  ldp      x20, x19, [sp, #0x20]
0x0003f544  ldp      x22, x21, [sp, #0x10]
0x0003f548  ldp      d9, d8, [sp], #0x40
0x0003f54c  ret      

=== -[OMCStartupScreenController pageIsDark]  va=0x3f550 size=64 types=B16@0:8
0x0003f550  stp      x20, x19, [sp, #-0x20]!
0x0003f554  stp      x29, x30, [sp, #0x10]
0x0003f558  add      x29, sp, #0x10
0x0003f55c  bl       #0x5dc60   ; CALL objc_msgSend$traitCollection
0x0003f560  mov      x29, x29
0x0003f564  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f568  mov      x19, x0
0x0003f56c  bl       #0x5de60   ; CALL objc_msgSend$userInterfaceStyle
0x0003f570  cmp      x0, #2
0x0003f574  cset     w20, eq
0x0003f578  mov      x0, x19
0x0003f57c  bl       #0x55d78   ; CALL _objc_release
0x0003f580  mov      x0, x20
0x0003f584  ldp      x29, x30, [sp, #0x10]
0x0003f588  ldp      x20, x19, [sp], #0x20
0x0003f58c  ret      

=== -[OMCStartupScreenController collectionView:numberOfItemsInSection:]  va=0x3f590 size=8 types=q32@0:8@16q24
0x0003f590  mov      w0, #0xb
0x0003f594  ret      

=== -[OMCStartupScreenController collectionView:cellForItemAtIndexPath:]  va=0x3f598 size=172 types=@32@0:8@16@24
0x0003f598  stp      x24, x23, [sp, #-0x40]!
0x0003f59c  stp      x22, x21, [sp, #0x10]
0x0003f5a0  stp      x20, x19, [sp, #0x20]
0x0003f5a4  stp      x29, x30, [sp, #0x30]
0x0003f5a8  add      x29, sp, #0x30
0x0003f5ac  mov      x19, x3
0x0003f5b0  mov      x20, x2
0x0003f5b4  mov      x21, x0
0x0003f5b8  mov      x0, x3
0x0003f5bc  bl       #0x55d84   ; CALL _objc_retain
0x0003f5c0  adrp     x2, #0x7c000
0x0003f5c4  add      x2, x2, #0x688   ; STR "tile"
0x0003f5c8  mov      x0, x20
0x0003f5cc  mov      x3, x19
0x0003f5d0  bl       #0x57700   ; CALL objc_msgSend$dequeueReusableCellWithReuseIdentifier:forIndexPath:
0x0003f5d4  mov      x29, x29
0x0003f5d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f5dc  mov      x20, x0
0x0003f5e0  mov      x0, x19
0x0003f5e4  bl       #0x58960   ; CALL objc_msgSend$item
0x0003f5e8  mov      x22, x0
0x0003f5ec  mov      x0, x19
0x0003f5f0  bl       #0x58960   ; CALL objc_msgSend$item
0x0003f5f4  mov      x23, x0
0x0003f5f8  mov      x0, x19
0x0003f5fc  bl       #0x55d78   ; CALL _objc_release
0x0003f600  mov      x0, x21
0x0003f604  bl       #0x574e0   ; CALL objc_msgSend$currentStyle
0x0003f608  cmp      x23, x0
0x0003f60c  cset     w19, eq
0x0003f610  mov      x0, x21
0x0003f614  bl       #0x595a0   ; CALL objc_msgSend$pageIsDark
0x0003f618  mov      x4, x0
0x0003f61c  mov      x0, x20
0x0003f620  mov      x2, x22
0x0003f624  mov      x3, x19
0x0003f628  bl       #0x5cae0   ; CALL objc_msgSend$showStyle:chosen:dark:
0x0003f62c  mov      x0, x20
0x0003f630  ldp      x29, x30, [sp, #0x30]
0x0003f634  ldp      x20, x19, [sp, #0x20]
0x0003f638  ldp      x22, x21, [sp, #0x10]
0x0003f63c  ldp      x24, x23, [sp], #0x40
0x0003f640  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCStartupScreenController collectionView:didSelectItemAtIndexPath:]  va=0x3f644 size=808 types=v32@0:8@16@24
0x0003f644  sub      sp, sp, #0x80
0x0003f648  stp      x24, x23, [sp, #0x40]
0x0003f64c  stp      x22, x21, [sp, #0x50]
0x0003f650  stp      x20, x19, [sp, #0x60]
0x0003f654  stp      x29, x30, [sp, #0x70]
0x0003f658  add      x29, sp, #0x70
0x0003f65c  mov      x21, x3
0x0003f660  mov      x19, x2
0x0003f664  mov      x20, x0
0x0003f668  mov      x0, x2
0x0003f66c  bl       #0x55d84   ; CALL _objc_retain
0x0003f670  mov      x0, x21
0x0003f674  bl       #0x58960   ; CALL objc_msgSend$item
0x0003f678  mov      x21, x0
0x0003f67c  mov      x0, x20
0x0003f680  bl       #0x574e0   ; CALL objc_msgSend$currentStyle
0x0003f684  cmp      x21, x0
0x0003f688  b.ne     #0x3f698
0x0003f68c  mov      x0, x20
0x0003f690  bl       #0x5dd80   ; CALL objc_msgSend$updatePreview
0x0003f694  b        #0x3f7a4
0x0003f698  adrp     x8, #0x8e000
0x0003f69c  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x0003f6a0  mov      x2, x21
0x0003f6a4  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x0003f6a8  mov      x29, x29
0x0003f6ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f6b0  mov      x22, x0
0x0003f6b4  adrp     x0, #0x7c000
0x0003f6b8  add      x0, x0, #0x268   ; STR "startupScreenStyle"
0x0003f6bc  mov      x1, x22
0x0003f6c0  bl       #0x3f7c4
0x0003f6c4  mov      x0, x22
0x0003f6c8  bl       #0x55d78   ; CALL _objc_release
0x0003f6cc  adrp     x8, #0x8e000
0x0003f6d0  ldr      x0, [x8, #0x938]   ; @CLASS UISelectionFeedbackGenerator
0x0003f6d4  bl       #0x55d60   ; CALL _objc_opt_new
0x0003f6d8  mov      x22, x0
0x0003f6dc  bl       #0x5a200   ; CALL objc_msgSend$selectionChanged
0x0003f6e0  mov      x0, x22
0x0003f6e4  bl       #0x55d78   ; CALL _objc_release
0x0003f6e8  mov      x0, x20
0x0003f6ec  bl       #0x595a0   ; CALL objc_msgSend$pageIsDark
0x0003f6f0  mov      x22, x0
0x0003f6f4  adrp     x8, #0x8e000
0x0003f6f8  ldr      x23, [x8, #0x918]   ; @CLASS UIView
0x0003f6fc  adrp     x8, #0x74000
0x0003f700  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x0003f704  str      x8, [sp, #8]
0x0003f708  adrp     x8, #0x65000
0x0003f70c  ldr      d0, [x8, #0x600]
0x0003f710  str      d0, [sp, #0x10]
0x0003f714  adrp     x8, #0x3f000
0x0003f718  add      x8, x8, #0x80c
0x0003f71c  adrp     x9, #0x74000
0x0003f720  add      x9, x9, #0xca8
0x0003f724  stp      x8, x9, [sp, #0x18]
0x0003f728  mov      x0, x19
0x0003f72c  bl       #0x55d84   ; CALL _objc_retain
0x0003f730  stp      x19, x21, [sp, #0x28]
0x0003f734  strb     w22, [sp, #0x38]
0x0003f738  adrp     x8, #0x65000
0x0003f73c  ldr      d0, [x8, #0x660]
0x0003f740  adrp     x8, #0x65000
0x0003f744  ldr      d2, [x8, #0x6b0]
0x0003f748  fmov     d1, xzr
0x0003f74c  fmov     d3, xzr
0x0003f750  add      x3, sp, #8
0x0003f754  mov      x0, x23
0x0003f758  mov      w2, #2
0x0003f75c  mov      x4, #0
0x0003f760  bl       #0x56360   ; CALL objc_msgSend$animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
0x0003f764  mov      x0, x20
0x0003f768  mov      x2, x21
0x0003f76c  mov      w3, #1
0x0003f770  bl       #0x5a120   ; CALL objc_msgSend$scrollGalleryToStyle:animated:
0x0003f774  adrp     x8, #0x74000
0x0003f778  ldr      x8, [x8, #0x368]   ; @GOT _OBJC_IVAR_$_PSListController._specifiers
0x0003f77c  ldrsw    x8, [x8]   ; @GOT ___objc_personality_v0
0x0003f780  ldr      x0, [x20, x8]
0x0003f784  str      xzr, [x20, x8]
0x0003f788  bl       #0x55d78   ; CALL _objc_release
0x0003f78c  mov      x0, x20
0x0003f790  bl       #0x59d40   ; CALL objc_msgSend$reloadSpecifiers
0x0003f794  mov      x0, x20
0x0003f798  bl       #0x5dd80   ; CALL objc_msgSend$updatePreview
0x0003f79c  ldr      x0, [sp, #0x28]
0x0003f7a0  bl       #0x55d78   ; CALL _objc_release
0x0003f7a4  mov      x0, x19
0x0003f7a8  bl       #0x55d78   ; CALL _objc_release
0x0003f7ac  ldp      x29, x30, [sp, #0x70]
0x0003f7b0  ldp      x20, x19, [sp, #0x60]
0x0003f7b4  ldp      x22, x21, [sp, #0x50]
0x0003f7b8  ldp      x24, x23, [sp, #0x40]
0x0003f7bc  add      sp, sp, #0x80
0x0003f7c0  ret      
0x0003f7c4  stp      x20, x19, [sp, #-0x20]!
0x0003f7c8  stp      x29, x30, [sp, #0x10]
0x0003f7cc  add      x29, sp, #0x10
0x0003f7d0  adrp     x19, #0x75000
0x0003f7d4  add      x19, x19, #0x28   ; STR "com.anlai.omnicar"
0x0003f7d8  mov      x2, x19
0x0003f7dc  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x0003f7e0  mov      x0, x19
0x0003f7e4  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x0003f7e8  bl       #0x55838   ; CALL _CFNotificationCenterGetDarwinNotifyCenter
0x0003f7ec  adrp     x1, #0x7d000
0x0003f7f0  add      x1, x1, #0x128   ; STR "com.anlai.omnicar/prefschanged"
0x0003f7f4  mov      x2, #0
0x0003f7f8  mov      x3, #0
0x0003f7fc  mov      w4, #1
0x0003f800  ldp      x29, x30, [sp, #0x10]
0x0003f804  ldp      x20, x19, [sp], #0x20
0x0003f808  b        #0x55844   ; CALL _CFNotificationCenterPostNotification
0x0003f80c  sub      sp, sp, #0x130
0x0003f810  stp      x28, x27, [sp, #0xd0]
0x0003f814  stp      x26, x25, [sp, #0xe0]
0x0003f818  stp      x24, x23, [sp, #0xf0]
0x0003f81c  stp      x22, x21, [sp, #0x100]
0x0003f820  stp      x20, x19, [sp, #0x110]
0x0003f824  stp      x29, x30, [sp, #0x120]
0x0003f828  add      x29, sp, #0x120
0x0003f82c  mov      x19, x0
0x0003f830  adrp     x8, #0x74000
0x0003f834  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0003f838  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003f83c  stur     x8, [x29, #-0x58]
0x0003f840  movi     v0.16b, #0
0x0003f844  stp      q0, q0, [sp]
0x0003f848  stp      q0, q0, [sp, #0x20]
0x0003f84c  ldr      x0, [x0, #0x20]   ; @STR "startupScreenSoundFile"
0x0003f850  bl       #0x58320   ; CALL objc_msgSend$indexPathsForVisibleItems
0x0003f854  mov      x29, x29
0x0003f858  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f85c  mov      x20, x0
0x0003f860  mov      x2, sp
0x0003f864  add      x3, sp, #0x48
0x0003f868  mov      w4, #0x10
0x0003f86c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0003f870  cbz      x0, #0x3f928
0x0003f874  mov      x21, x0
0x0003f878  ldr      x8, [sp, #0x10]
0x0003f87c  ldr      x24, [x8]   ; @GOT ___objc_personality_v0
0x0003f880  adrp     x25, #0x8e000
0x0003f884  mov      x26, #0
0x0003f888  ldr      x8, [sp, #0x10]
0x0003f88c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003f890  cmp      x8, x24
0x0003f894  b.eq     #0x3f8a0
0x0003f898  mov      x0, x20
0x0003f89c  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0003f8a0  ldr      x8, [sp, #8]
0x0003f8a4  ldr      x23, [x8, x26, lsl #3]   ; @GOT ___objc_personality_v0
0x0003f8a8  ldr      x0, [x19, #0x20]   ; @STR "empty"
0x0003f8ac  mov      x2, x23
0x0003f8b0  bl       #0x56ca0   ; CALL objc_msgSend$cellForItemAtIndexPath:
0x0003f8b4  mov      x29, x29
0x0003f8b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f8bc  mov      x22, x0
0x0003f8c0  ldr      x0, [x25, #0xc60]   ; @CLASS OMCSSStyleTileCell
0x0003f8c4  bl       #0x55d48   ; CALL _objc_opt_class
0x0003f8c8  mov      x1, x0
0x0003f8cc  mov      x0, x22
0x0003f8d0  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0003f8d4  tbz      w0, #0, #0x3f8f8
0x0003f8d8  mov      x0, x23
0x0003f8dc  bl       #0x58960   ; CALL objc_msgSend$item
0x0003f8e0  ldr      x8, [x19, #0x28]
0x0003f8e4  cmp      x0, x8
0x0003f8e8  cset     w2, eq
0x0003f8ec  ldrb     w3, [x19, #0x30]
0x0003f8f0  mov      x0, x22
0x0003f8f4  bl       #0x5a860   ; CALL objc_msgSend$setChosen:dark:
0x0003f8f8  mov      x0, x22
0x0003f8fc  bl       #0x55d78   ; CALL _objc_release
0x0003f900  add      x26, x26, #1
0x0003f904  cmp      x21, x26
0x0003f908  b.ne     #0x3f888
0x0003f90c  mov      x2, sp
0x0003f910  add      x3, sp, #0x48
0x0003f914  mov      x0, x20
0x0003f918  mov      w4, #0x10
0x0003f91c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0003f920  mov      x21, x0
0x0003f924  cbnz     x0, #0x3f884
0x0003f928  mov      x0, x20
0x0003f92c  bl       #0x55d78   ; CALL _objc_release
0x0003f930  ldur     x8, [x29, #-0x58]
0x0003f934  adrp     x9, #0x74000
0x0003f938  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0003f93c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0003f940  cmp      x9, x8
0x0003f944  b.ne     #0x3f968
0x0003f948  ldp      x29, x30, [sp, #0x120]
0x0003f94c  ldp      x20, x19, [sp, #0x110]
0x0003f950  ldp      x22, x21, [sp, #0x100]
0x0003f954  ldp      x24, x23, [sp, #0xf0]
0x0003f958  ldp      x26, x25, [sp, #0xe0]
0x0003f95c  ldp      x28, x27, [sp, #0xd0]
0x0003f960  add      sp, sp, #0x130
0x0003f964  ret      
0x0003f968  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController randomPreviewStyle]  va=0x3f96c size=196 types=q16@0:8
0x0003f96c  stp      x22, x21, [sp, #-0x30]!
0x0003f970  stp      x20, x19, [sp, #0x10]
0x0003f974  stp      x29, x30, [sp, #0x20]
0x0003f978  add      x29, sp, #0x20
0x0003f97c  mov      x20, x0
0x0003f980  bl       #0x59b20   ; CALL objc_msgSend$randomSet
0x0003f984  mov      x29, x29
0x0003f988  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f98c  mov      x21, x0
0x0003f990  bl       #0x590a0   ; CALL objc_msgSend$mutableCopy
0x0003f994  mov      x19, x0
0x0003f998  mov      x0, x21
0x0003f99c  bl       #0x55d78   ; CALL _objc_release
0x0003f9a0  mov      x0, x20
0x0003f9a4  bl       #0x5a1e0   ; CALL objc_msgSend$selectedVideo
0x0003f9a8  mov      x29, x29
0x0003f9ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f9b0  mov      x20, x0
0x0003f9b4  bl       #0x55d78   ; CALL _objc_release
0x0003f9b8  cbnz     x20, #0x3f9cc
0x0003f9bc  adrp     x2, #0x80000
0x0003f9c0  add      x2, x2, #0x388
0x0003f9c4  mov      x0, x19
0x0003f9c8  bl       #0x59e40   ; CALL objc_msgSend$removeObject:
0x0003f9cc  mov      x0, x19
0x0003f9d0  bl       #0x573c0   ; CALL objc_msgSend$count
0x0003f9d4  cbz      x0, #0x3fa10
0x0003f9d8  mov      x0, x19
0x0003f9dc  bl       #0x573c0   ; CALL objc_msgSend$count
0x0003f9e0  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0003f9e4  mov      w2, w0
0x0003f9e8  mov      x0, x19
0x0003f9ec  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0003f9f0  mov      x29, x29
0x0003f9f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003f9f8  mov      x21, x0
0x0003f9fc  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0003fa00  mov      x20, x0
0x0003fa04  mov      x0, x21
0x0003fa08  bl       #0x55d78   ; CALL _objc_release
0x0003fa0c  b        #0x3fa14
0x0003fa10  mov      w20, #2
0x0003fa14  mov      x0, x19
0x0003fa18  bl       #0x55d78   ; CALL _objc_release
0x0003fa1c  mov      x0, x20
0x0003fa20  ldp      x29, x30, [sp, #0x20]
0x0003fa24  ldp      x20, x19, [sp, #0x10]
0x0003fa28  ldp      x22, x21, [sp], #0x30
0x0003fa2c  ret      

=== -[OMCStartupScreenController updatePreview]  va=0x3fa30 size=44 types=v16@0:8
0x0003fa30  stp      x20, x19, [sp, #-0x20]!
0x0003fa34  stp      x29, x30, [sp, #0x10]
0x0003fa38  add      x29, sp, #0x10
0x0003fa3c  mov      x19, x0
0x0003fa40  bl       #0x574e0   ; CALL objc_msgSend$currentStyle
0x0003fa44  mov      x2, x0
0x0003fa48  mov      x0, x19
0x0003fa4c  mov      x3, #0
0x0003fa50  ldp      x29, x30, [sp, #0x10]
0x0003fa54  ldp      x20, x19, [sp], #0x20
0x0003fa58  b        #0x5ca80   ; CALL objc_msgSend$showPreviewStyle:occasion:

=== -[OMCStartupScreenController showPreviewStyle:occasion:]  va=0x3fa5c size=1204 types=v32@0:8q16q24
0x0003fa5c  stp      x28, x27, [sp, #-0x60]!
0x0003fa60  stp      x26, x25, [sp, #0x10]
0x0003fa64  stp      x24, x23, [sp, #0x20]
0x0003fa68  stp      x22, x21, [sp, #0x30]
0x0003fa6c  stp      x20, x19, [sp, #0x40]
0x0003fa70  stp      x29, x30, [sp, #0x50]
0x0003fa74  add      x29, sp, #0x50
0x0003fa78  sub      sp, sp, #0x410
0x0003fa7c  mov      x20, x3
0x0003fa80  mov      x24, x2
0x0003fa84  mov      x23, x0
0x0003fa88  adrp     x8, #0x74000
0x0003fa8c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0003fa90  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0003fa94  stur     x8, [x29, #-0x60]
0x0003fa98  bl       #0x599e0   ; CALL objc_msgSend$preview
0x0003fa9c  mov      x29, x29
0x0003faa0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003faa4  mov      x19, x0
0x0003faa8  cbz      x0, #0x3fecc
0x0003faac  cmp      x24, #0xa
0x0003fab0  b.ne     #0x3fac0
0x0003fab4  mov      x0, x23
0x0003fab8  bl       #0x59b00   ; CALL objc_msgSend$randomPreviewStyle
0x0003fabc  mov      x24, x0
0x0003fac0  mov      x0, x19
0x0003fac4  mov      x2, #0
0x0003fac8  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x0003facc  mov      x0, x19
0x0003fad0  mov      x2, #0
0x0003fad4  bl       #0x5c8e0   ; CALL objc_msgSend$setWeather:
0x0003fad8  mov      x0, x19
0x0003fadc  mov      x2, #0
0x0003fae0  bl       #0x5b020   ; CALL objc_msgSend$setHud:
0x0003fae4  mov      x0, x19
0x0003fae8  mov      x2, #0
0x0003faec  bl       #0x5b7c0   ; CALL objc_msgSend$setNextEvent:
0x0003faf0  mov      x0, x19
0x0003faf4  mov      x2, x24
0x0003faf8  bl       #0x5c3e0   ; CALL objc_msgSend$setStyle:
0x0003fafc  mov      x0, x19
0x0003fb00  mov      x2, x20
0x0003fb04  bl       #0x5b8c0   ; CALL objc_msgSend$setOccasion:
0x0003fb08  mov      x0, x19
0x0003fb0c  bl       #0x545b0   ; CALL _SSApplySampleData
0x0003fb10  mov      x0, x19
0x0003fb14  mov      x2, x20
0x0003fb18  bl       #0x5b8c0   ; CALL objc_msgSend$setOccasion:
0x0003fb1c  adrp     x0, #0x7c000
0x0003fb20  add      x0, x0, #0x5a8   ; STR "startupScreenGreetingName"
0x0003fb24  bl       #0x3d124
0x0003fb28  mov      x29, x29
0x0003fb2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003fb30  mov      x20, x0
0x0003fb34  mov      x0, x19
0x0003fb38  mov      x2, x20
0x0003fb3c  bl       #0x5b700   ; CALL objc_msgSend$setName:
0x0003fb40  mov      x0, x20
0x0003fb44  bl       #0x55d78   ; CALL _objc_release
0x0003fb48  adrp     x0, #0x7c000
0x0003fb4c  add      x0, x0, #0x5c8   ; STR "startupScreenCarName"
0x0003fb50  bl       #0x3d124
0x0003fb54  mov      x29, x29
0x0003fb58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003fb5c  mov      x20, x0
0x0003fb60  bl       #0x58c20   ; CALL objc_msgSend$length
0x0003fb64  cbz      x0, #0x3fb78
0x0003fb68  mov      x0, x19
0x0003fb6c  mov      x2, x20
0x0003fb70  bl       #0x5a7c0   ; CALL objc_msgSend$setCarName:
0x0003fb74  b        #0x3fb9c
0x0003fb78  bl       #0x3dd30
0x0003fb7c  mov      x29, x29
0x0003fb80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003fb84  mov      x21, x0
0x0003fb88  mov      x0, x19
0x0003fb8c  mov      x2, x21
0x0003fb90  bl       #0x5a7c0   ; CALL objc_msgSend$setCarName:
0x0003fb94  mov      x0, x21
0x0003fb98  bl       #0x55d78   ; CALL _objc_release
0x0003fb9c  adrp     x0, #0x7c000
0x0003fba0  add      x0, x0, #0x5e8   ; STR "startupScreenTempo"
0x0003fba4  adrp     x1, #0x75000
0x0003fba8  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x0003fbac  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x0003fbb0  mov      x21, x0
0x0003fbb4  cbz      x0, #0x3fbd4
0x0003fbb8  mov      x0, x21
0x0003fbbc  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0003fbc0  bic      x8, x0, x0, asr #63
0x0003fbc4  cmp      x8, #2
0x0003fbc8  mov      w9, #2
0x0003fbcc  csel     x2, x8, x9, lt
0x0003fbd0  b        #0x3fbd8
0x0003fbd4  mov      w2, #1
0x0003fbd8  mov      x0, x19
0x0003fbdc  bl       #0x5c4a0   ; CALL objc_msgSend$setTempo:
0x0003fbe0  adrp     x0, #0x7c000
0x0003fbe4  add      x0, x0, #0x608   ; STR "startupScreenLogoEffect"
0x0003fbe8  adrp     x22, #0x75000
0x0003fbec  add      x22, x22, #0x28   ; STR "com.anlai.omnicar"
0x0003fbf0  mov      x1, x22
0x0003fbf4  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x0003fbf8  mov      x25, x0
0x0003fbfc  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0003fc00  mov      x2, x0
0x0003fc04  mov      x0, x19
0x0003fc08  bl       #0x5b4a0   ; CALL objc_msgSend$setLogoEffect:
0x0003fc0c  mov      x0, x25
0x0003fc10  bl       #0x55d78   ; CALL _objc_release
0x0003fc14  adrp     x0, #0x7c000
0x0003fc18  add      x0, x0, #0x6e8   ; STR "startupScreenDuration"
0x0003fc1c  mov      x1, x22
0x0003fc20  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x0003fc24  mov      x22, x0
0x0003fc28  cbz      x0, #0x3fc4c
0x0003fc2c  mov      x0, x22
0x0003fc30  bl       #0x57880   ; CALL objc_msgSend$doubleValue
0x0003fc34  fmov     d1, #30.00000000
0x0003fc38  fcmp     d0, d1
0x0003fc3c  fcsel    d0, d1, d0, gt
0x0003fc40  fmov     d1, #1.00000000
0x0003fc44  fmaxnm   d0, d0, d1
0x0003fc48  b        #0x3fc50
0x0003fc4c  fmov     d0, #5.00000000
0x0003fc50  mov      x0, x19
0x0003fc54  bl       #0x5ad40   ; CALL objc_msgSend$setDuration:
0x0003fc58  adrp     x8, #0x8e000
0x0003fc5c  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x0003fc60  bl       #0x575a0   ; CALL objc_msgSend$date
0x0003fc64  mov      x29, x29
0x0003fc68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003fc6c  mov      x25, x0
0x0003fc70  mov      x0, x19
0x0003fc74  mov      x2, x25
0x0003fc78  bl       #0x5ac20   ; CALL objc_msgSend$setDate:
0x0003fc7c  mov      x0, x25
0x0003fc80  bl       #0x55d78   ; CALL _objc_release
0x0003fc84  cmp      x24, #2
0x0003fc88  b.gt     #0x3fcd8
0x0003fc8c  cbz      x24, #0x3fd10
0x0003fc90  cmp      x24, #1
0x0003fc94  b.ne     #0x3fea4
0x0003fc98  adrp     x8, #0x8e000
0x0003fc9c  ldr      x23, [x8, #0xa78]   ; @CLASS UIImage
0x0003fca0  adrp     x0, #0x7c000
0x0003fca4  add      x0, x0, #0x708   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Logo/logo.png"
0x0003fca8  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0003fcac  mov      x1, sp
0x0003fcb0  bl       #0x4118
0x0003fcb4  cbz      x0, #0x3fd98
0x0003fcb8  mov      x2, x0
0x0003fcbc  adrp     x8, #0x8e000
0x0003fcc0  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0003fcc4  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0003fcc8  mov      x29, x29
0x0003fccc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003fcd0  mov      x24, x0
0x0003fcd4  b        #0x3fd9c
0x0003fcd8  cmp      x24, #3
0x0003fcdc  b.eq     #0x3fce8
0x0003fce0  cmp      x24, #8
0x0003fce4  b.ne     #0x3fea4
0x0003fce8  fmov     d0, xzr
0x0003fcec  bl       #0x4572c   ; CALL _SSWeatherLoadCache
0x0003fcf0  mov      x29, x29
0x0003fcf4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003fcf8  mov      x23, x0
0x0003fcfc  cbz      x0, #0x3fd68
0x0003fd00  mov      x0, x19
0x0003fd04  mov      x2, x23
0x0003fd08  bl       #0x5c8e0   ; CALL objc_msgSend$setWeather:
0x0003fd0c  b        #0x3fe9c
0x0003fd10  mov      x0, x23
0x0003fd14  bl       #0x5a1e0   ; CALL objc_msgSend$selectedVideo
0x0003fd18  mov      x29, x29
0x0003fd1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003fd20  mov      x23, x0
0x0003fd24  cbz      x0, #0x3fe68
0x0003fd28  adrp     x8, #0x8e000
0x0003fd2c  ldr      x24, [x8, #0xa78]   ; @CLASS UIImage
0x0003fd30  adrp     x0, #0x76000
0x0003fd34  add      x0, x0, #0xb68   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Videos"
0x0003fd38  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0003fd3c  mov      x1, sp
0x0003fd40  bl       #0x4118
0x0003fd44  cbz      x0, #0x3fdd0
0x0003fd48  mov      x2, x0
0x0003fd4c  adrp     x8, #0x8e000
0x0003fd50  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0003fd54  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0003fd58  mov      x29, x29
0x0003fd5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003fd60  mov      x25, x0
0x0003fd64  b        #0x3fdd4
0x0003fd68  mov      x0, x19
0x0003fd6c  bl       #0x5e100   ; CALL objc_msgSend$weather
0x0003fd70  mov      x29, x29
0x0003fd74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003fd78  mov      x24, x0
0x0003fd7c  adrp     x8, #0x80000
0x0003fd80  add      x8, x8, #0xa8
0x0003fd84  cmp      x0, #0
0x0003fd88  csel     x2, x8, x0, eq
0x0003fd8c  mov      x0, x19
0x0003fd90  bl       #0x5c8e0   ; CALL objc_msgSend$setWeather:
0x0003fd94  b        #0x3fe94
0x0003fd98  mov      x24, #0
0x0003fd9c  mov      x0, x23
0x0003fda0  mov      x2, x24
0x0003fda4  bl       #0x581c0   ; CALL objc_msgSend$imageWithContentsOfFile:
0x0003fda8  mov      x29, x29
0x0003fdac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003fdb0  mov      x23, x0
0x0003fdb4  mov      x0, x19
0x0003fdb8  mov      x2, x23
0x0003fdbc  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x0003fdc0  mov      x0, x23
0x0003fdc4  bl       #0x55d78   ; CALL _objc_release
0x0003fdc8  mov      x0, x24
0x0003fdcc  b        #0x3fea0
0x0003fdd0  mov      x25, #0
0x0003fdd4  adrp     x2, #0x76000
0x0003fdd8  add      x2, x2, #0xb88   ; STR ".frames"
0x0003fddc  mov      x0, x25
0x0003fde0  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x0003fde4  mov      x29, x29
0x0003fde8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003fdec  mov      x26, x0
0x0003fdf0  mov      x2, x23
0x0003fdf4  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x0003fdf8  mov      x29, x29
0x0003fdfc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003fe00  mov      x27, x0
0x0003fe04  adrp     x2, #0x7c000
0x0003fe08  add      x2, x2, #0x728   ; STR "00000.jpg"
0x0003fe0c  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x0003fe10  mov      x29, x29
0x0003fe14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003fe18  mov      x28, x0
0x0003fe1c  mov      x0, x24
0x0003fe20  mov      x2, x28
0x0003fe24  bl       #0x581c0   ; CALL objc_msgSend$imageWithContentsOfFile:
0x0003fe28  mov      x29, x29
0x0003fe2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003fe30  mov      x24, x0
0x0003fe34  mov      x0, x19
0x0003fe38  mov      x2, x24
0x0003fe3c  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x0003fe40  mov      x0, x24
0x0003fe44  bl       #0x55d78   ; CALL _objc_release
0x0003fe48  mov      x0, x28
0x0003fe4c  bl       #0x55d78   ; CALL _objc_release
0x0003fe50  mov      x0, x27
0x0003fe54  bl       #0x55d78   ; CALL _objc_release
0x0003fe58  mov      x0, x26
0x0003fe5c  bl       #0x55d78   ; CALL _objc_release
0x0003fe60  mov      x0, x25
0x0003fe64  bl       #0x55d78   ; CALL _objc_release
0x0003fe68  adrp     x0, #0x7c000
0x0003fe6c  add      x0, x0, #0x628   ; STR "startupScreenScaleMode"
0x0003fe70  adrp     x1, #0x75000
0x0003fe74  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x0003fe78  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x0003fe7c  mov      x24, x0
0x0003fe80  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0003fe84  cmp      x0, #1
0x0003fe88  cset     w2, eq
0x0003fe8c  mov      x0, x19
0x0003fe90  bl       #0x5b0c0   ; CALL objc_msgSend$setImageFits:
0x0003fe94  mov      x0, x24
0x0003fe98  bl       #0x55d78   ; CALL _objc_release
0x0003fe9c  mov      x0, x23
0x0003fea0  bl       #0x55d78   ; CALL _objc_release
0x0003fea4  mov      x0, x19
0x0003fea8  bl       #0x59c60   ; CALL objc_msgSend$reload
0x0003feac  mov      x0, x19
0x0003feb0  bl       #0x597a0   ; CALL objc_msgSend$playIntro
0x0003feb4  mov      x0, x22
0x0003feb8  bl       #0x55d78   ; CALL _objc_release
0x0003febc  mov      x0, x21
0x0003fec0  bl       #0x55d78   ; CALL _objc_release
0x0003fec4  mov      x0, x20
0x0003fec8  bl       #0x55d78   ; CALL _objc_release
0x0003fecc  mov      x0, x19
0x0003fed0  bl       #0x55d78   ; CALL _objc_release
0x0003fed4  ldur     x8, [x29, #-0x60]
0x0003fed8  adrp     x9, #0x74000
0x0003fedc  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0003fee0  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0003fee4  cmp      x9, x8
0x0003fee8  b.ne     #0x3ff0c
0x0003feec  add      sp, sp, #0x410
0x0003fef0  ldp      x29, x30, [sp, #0x50]
0x0003fef4  ldp      x20, x19, [sp, #0x40]
0x0003fef8  ldp      x22, x21, [sp, #0x30]
0x0003fefc  ldp      x24, x23, [sp, #0x20]
0x0003ff00  ldp      x26, x25, [sp, #0x10]
0x0003ff04  ldp      x28, x27, [sp], #0x60
0x0003ff08  ret      
0x0003ff0c  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController toggleRandomStyle:]  va=0x3ff10 size=372 types=v24@0:8@16
0x0003ff10  stp      x24, x23, [sp, #-0x40]!
0x0003ff14  stp      x22, x21, [sp, #0x10]
0x0003ff18  stp      x20, x19, [sp, #0x20]
0x0003ff1c  stp      x29, x30, [sp, #0x30]
0x0003ff20  add      x29, sp, #0x30
0x0003ff24  mov      x8, x2
0x0003ff28  mov      x20, x0
0x0003ff2c  adrp     x2, #0x7c000
0x0003ff30  add      x2, x2, #0x668   ; STR "ssRandomStyle"
0x0003ff34  mov      x0, x8
0x0003ff38  bl       #0x59aa0   ; CALL objc_msgSend$propertyForKey:
0x0003ff3c  mov      x29, x29
0x0003ff40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ff44  mov      x19, x0
0x0003ff48  adrp     x21, #0x8e000
0x0003ff4c  ldr      x0, [x21, #0x928]   ; @CLASS NSNumber
0x0003ff50  bl       #0x55d48   ; CALL _objc_opt_class
0x0003ff54  mov      x1, x0
0x0003ff58  mov      x0, x19
0x0003ff5c  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0003ff60  tbz      w0, #0, #0x4006c
0x0003ff64  ldr      x21, [x21, #0x928]   ; @CLASS NSNumber
0x0003ff68  mov      x0, x19
0x0003ff6c  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0003ff70  mov      x2, x0
0x0003ff74  mov      x0, x21
0x0003ff78  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x0003ff7c  mov      x29, x29
0x0003ff80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ff84  mov      x21, x0
0x0003ff88  mov      x0, x20
0x0003ff8c  bl       #0x59b20   ; CALL objc_msgSend$randomSet
0x0003ff90  mov      x29, x29
0x0003ff94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ff98  mov      x23, x0
0x0003ff9c  bl       #0x590a0   ; CALL objc_msgSend$mutableCopy
0x0003ffa0  mov      x22, x0
0x0003ffa4  mov      x0, x23
0x0003ffa8  bl       #0x55d78   ; CALL _objc_release
0x0003ffac  mov      x0, x22
0x0003ffb0  mov      x2, x21
0x0003ffb4  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x0003ffb8  cbz      w0, #0x3fffc
0x0003ffbc  mov      x0, x22
0x0003ffc0  bl       #0x573c0   ; CALL objc_msgSend$count
0x0003ffc4  cmp      x0, #1
0x0003ffc8  b.hi     #0x4000c
0x0003ffcc  adrp     x0, #0x7c000
0x0003ffd0  add      x0, x0, #0x808   ; STR "STARTUPSCREEN_RANDOM_KEEP_ONE"
0x0003ffd4  bl       #0x17e20   ; CALL _L
0x0003ffd8  mov      x29, x29
0x0003ffdc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003ffe0  mov      x23, x0
0x0003ffe4  mov      x0, x20
0x0003ffe8  mov      x2, x23
0x0003ffec  bl       #0x5ca40   ; CALL objc_msgSend$showMessage:
0x0003fff0  mov      x0, x23
0x0003fff4  bl       #0x55d78   ; CALL _objc_release
0x0003fff8  b        #0x4005c
0x0003fffc  mov      x0, x22
0x00040000  mov      x2, x21
0x00040004  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00040008  b        #0x40018
0x0004000c  mov      x0, x22
0x00040010  mov      x2, x21
0x00040014  bl       #0x59e40   ; CALL objc_msgSend$removeObject:
0x00040018  adrp     x8, #0x8c000
0x0004001c  ldr      x2, [x8, #0x388]   ; @SEL "compare:"
0x00040020  mov      x0, x22
0x00040024  bl       #0x5ccc0   ; CALL objc_msgSend$sortUsingSelector:
0x00040028  adrp     x0, #0x7c000
0x0004002c  add      x0, x0, #0x2c8   ; STR "startupScreenRandomSet"
0x00040030  mov      x1, x22
0x00040034  bl       #0x3f7c4
0x00040038  adrp     x8, #0x8e000
0x0004003c  ldr      x0, [x8, #0x938]   ; @CLASS UISelectionFeedbackGenerator
0x00040040  bl       #0x55d60   ; CALL _objc_opt_new
0x00040044  mov      x23, x0
0x00040048  bl       #0x5a200   ; CALL objc_msgSend$selectionChanged
0x0004004c  mov      x0, x23
0x00040050  bl       #0x55d78   ; CALL _objc_release
0x00040054  mov      x0, x20
0x00040058  bl       #0x59c00   ; CALL objc_msgSend$redecorateVisibleCells
0x0004005c  mov      x0, x22
0x00040060  bl       #0x55d78   ; CALL _objc_release
0x00040064  mov      x0, x21
0x00040068  bl       #0x55d78   ; CALL _objc_release
0x0004006c  mov      x0, x19
0x00040070  ldp      x29, x30, [sp, #0x30]
0x00040074  ldp      x20, x19, [sp, #0x20]
0x00040078  ldp      x22, x21, [sp, #0x10]
0x0004007c  ldp      x24, x23, [sp], #0x40
0x00040080  b        #0x55d78   ; CALL _objc_release

=== -[OMCStartupScreenController birthdayAccessory]  va=0x40084 size=756 types=@16@0:8
0x00040084  sub      sp, sp, #0x60
0x00040088  stp      x24, x23, [sp, #0x20]
0x0004008c  stp      x22, x21, [sp, #0x30]
0x00040090  stp      x20, x19, [sp, #0x40]
0x00040094  stp      x29, x30, [sp, #0x50]
0x00040098  add      x29, sp, #0x50
0x0004009c  mov      x19, x0
0x000400a0  adrp     x8, #0x74000
0x000400a4  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000400a8  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000400ac  str      x8, [sp, #0x18]
0x000400b0  bl       #0x568e0   ; CALL objc_msgSend$birthdayView
0x000400b4  mov      x29, x29
0x000400b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000400bc  mov      x20, x0
0x000400c0  bl       #0x55d78   ; CALL _objc_release
0x000400c4  cbnz     x20, #0x4032c
0x000400c8  adrp     x8, #0x8e000
0x000400cc  ldr      x0, [x8, #0xc68]   ; @CLASS UIDatePicker
0x000400d0  bl       #0x55d60   ; CALL _objc_opt_new
0x000400d4  mov      x20, x0
0x000400d8  mov      w2, #1
0x000400dc  bl       #0x5ac60   ; CALL objc_msgSend$setDatePickerMode:
0x000400e0  mov      x0, x20
0x000400e4  mov      w2, #2
0x000400e8  bl       #0x5bc20   ; CALL objc_msgSend$setPreferredDatePickerStyle:
0x000400ec  adrp     x8, #0x8e000
0x000400f0  ldr      x21, [x8, #0xa08]   ; @CLASS NSLocale
0x000400f4  bl       #0x17a40   ; CALL _OMCLanguage
0x000400f8  mov      x29, x29
0x000400fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040100  mov      x22, x0
0x00040104  mov      x0, x21
0x00040108  mov      x2, x22
0x0004010c  bl       #0x58d60   ; CALL objc_msgSend$localeWithLocaleIdentifier:
0x00040110  mov      x29, x29
0x00040114  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040118  mov      x21, x0
0x0004011c  mov      x0, x20
0x00040120  mov      x2, x21
0x00040124  bl       #0x5b440   ; CALL objc_msgSend$setLocale:
0x00040128  mov      x0, x21
0x0004012c  bl       #0x55d78   ; CALL _objc_release
0x00040130  mov      x0, x22
0x00040134  bl       #0x55d78   ; CALL _objc_release
0x00040138  adrp     x8, #0x8e000
0x0004013c  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00040140  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x00040144  mov      x29, x29
0x00040148  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004014c  mov      x21, x0
0x00040150  mov      x0, x20
0x00040154  mov      x2, x21
0x00040158  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x0004015c  mov      x0, x21
0x00040160  bl       #0x55d78   ; CALL _objc_release
0x00040164  adrp     x8, #0x8b000
0x00040168  ldr      x3, [x8, #0xf20]   ; @SEL "birthdayChanged:"
0x0004016c  mov      x0, x20
0x00040170  mov      x2, x19
0x00040174  mov      w4, #0x1000
0x00040178  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x0004017c  adrp     x8, #0x8e000
0x00040180  ldr      x0, [x8, #0xa50]   ; @CLASS UIButton
0x00040184  mov      w2, #1
0x00040188  bl       #0x56b80   ; CALL objc_msgSend$buttonWithType:
0x0004018c  mov      x29, x29
0x00040190  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040194  mov      x21, x0
0x00040198  adrp     x8, #0x8e000
0x0004019c  ldr      x0, [x8, #0xa78]   ; @CLASS UIImage
0x000401a0  adrp     x2, #0x7c000
0x000401a4  add      x2, x2, #0x828   ; STR "xmark.circle.fill"
0x000401a8  bl       #0x5d820   ; CALL objc_msgSend$systemImageNamed:
0x000401ac  mov      x29, x29
0x000401b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000401b4  mov      x22, x0
0x000401b8  mov      x0, x21
0x000401bc  mov      x2, x22
0x000401c0  mov      x3, #0
0x000401c4  bl       #0x5b0a0   ; CALL objc_msgSend$setImage:forState:
0x000401c8  mov      x0, x22
0x000401cc  bl       #0x55d78   ; CALL _objc_release
0x000401d0  adrp     x0, #0x7c000
0x000401d4  add      x0, x0, #0x848   ; STR "#FF5C54"
0x000401d8  bl       #0x18080   ; CALL _OMCColorFromHex
0x000401dc  mov      x29, x29
0x000401e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000401e4  mov      x22, x0
0x000401e8  mov      x0, x21
0x000401ec  mov      x2, x22
0x000401f0  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x000401f4  mov      x0, x22
0x000401f8  bl       #0x55d78   ; CALL _objc_release
0x000401fc  adrp     x0, #0x7c000
0x00040200  add      x0, x0, #0x868   ; STR "STARTUPSCREEN_BIRTHDAY_CLEAR"
0x00040204  bl       #0x17e20   ; CALL _L
0x00040208  mov      x29, x29
0x0004020c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040210  mov      x22, x0
0x00040214  mov      x0, x21
0x00040218  mov      x2, x22
0x0004021c  bl       #0x5a240   ; CALL objc_msgSend$setAccessibilityLabel:
0x00040220  mov      x0, x22
0x00040224  bl       #0x55d78   ; CALL _objc_release
0x00040228  adrp     x8, #0x8b000
0x0004022c  ldr      x3, [x8, #0xf28]   ; @SEL "clearBirthday"
0x00040230  mov      x0, x21
0x00040234  mov      x2, x19
0x00040238  mov      w4, #0x40
0x0004023c  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x00040240  mov      x0, x21
0x00040244  bl       #0x5e1c0   ; CALL objc_msgSend$widthAnchor
0x00040248  mov      x29, x29
0x0004024c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040250  mov      x22, x0
0x00040254  fmov     d0, #28.00000000
0x00040258  bl       #0x57180   ; CALL objc_msgSend$constraintEqualToConstant:
0x0004025c  mov      x29, x29
0x00040260  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040264  mov      x23, x0
0x00040268  mov      w2, #1
0x0004026c  bl       #0x5a2e0   ; CALL objc_msgSend$setActive:
0x00040270  mov      x0, x23
0x00040274  bl       #0x55d78   ; CALL _objc_release
0x00040278  mov      x0, x22
0x0004027c  bl       #0x55d78   ; CALL _objc_release
0x00040280  adrp     x8, #0x8e000
0x00040284  ldr      x0, [x8, #0xa38]   ; @CLASS UIStackView
0x00040288  bl       #0x55c7c   ; CALL _objc_alloc
0x0004028c  mov      x22, x0
0x00040290  stp      x20, x21, [sp, #8]
0x00040294  adrp     x8, #0x8e000
0x00040298  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0004029c  add      x2, sp, #8
0x000402a0  mov      w3, #2
0x000402a4  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000402a8  mov      x29, x29
0x000402ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000402b0  mov      x23, x0
0x000402b4  mov      x0, x22
0x000402b8  mov      x2, x23
0x000402bc  bl       #0x583a0   ; CALL objc_msgSend$initWithArrangedSubviews:
0x000402c0  mov      x22, x0
0x000402c4  mov      x0, x23
0x000402c8  bl       #0x55d78   ; CALL _objc_release
0x000402cc  mov      x0, x22
0x000402d0  mov      x2, #0
0x000402d4  bl       #0x5a540   ; CALL objc_msgSend$setAxis:
0x000402d8  mov      x0, x22
0x000402dc  mov      w2, #3
0x000402e0  bl       #0x5a3a0   ; CALL objc_msgSend$setAlignment:
0x000402e4  fmov     d0, #4.00000000
0x000402e8  mov      x0, x22
0x000402ec  bl       #0x5c240   ; CALL objc_msgSend$setSpacing:
0x000402f0  mov      x0, x19
0x000402f4  mov      x2, x20
0x000402f8  bl       #0x5a680   ; CALL objc_msgSend$setBirthdayPicker:
0x000402fc  mov      x0, x19
0x00040300  mov      x2, x21
0x00040304  bl       #0x5a660   ; CALL objc_msgSend$setBirthdayClear:
0x00040308  mov      x0, x19
0x0004030c  mov      x2, x22
0x00040310  bl       #0x5a6a0   ; CALL objc_msgSend$setBirthdayView:
0x00040314  mov      x0, x22
0x00040318  bl       #0x55d78   ; CALL _objc_release
0x0004031c  mov      x0, x21
0x00040320  bl       #0x55d78   ; CALL _objc_release
0x00040324  mov      x0, x20
0x00040328  bl       #0x55d78   ; CALL _objc_release
0x0004032c  mov      x0, x19
0x00040330  bl       #0x5dd00   ; CALL objc_msgSend$updateBirthdayAccessory
0x00040334  mov      x0, x19
0x00040338  bl       #0x568e0   ; CALL objc_msgSend$birthdayView
0x0004033c  mov      x29, x29
0x00040340  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040344  ldr      x8, [sp, #0x18]
0x00040348  adrp     x9, #0x74000
0x0004034c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00040350  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00040354  cmp      x9, x8
0x00040358  b.ne     #0x40374
0x0004035c  ldp      x29, x30, [sp, #0x50]
0x00040360  ldp      x20, x19, [sp, #0x40]
0x00040364  ldp      x22, x21, [sp, #0x30]
0x00040368  ldp      x24, x23, [sp, #0x20]
0x0004036c  add      sp, sp, #0x60
0x00040370  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00040374  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController updateBirthdayAccessory]  va=0x40378 size=704 types=v16@0:8
0x00040378  stp      d9, d8, [sp, #-0x50]!
0x0004037c  stp      x24, x23, [sp, #0x10]
0x00040380  stp      x22, x21, [sp, #0x20]
0x00040384  stp      x20, x19, [sp, #0x30]
0x00040388  stp      x29, x30, [sp, #0x40]
0x0004038c  add      x29, sp, #0x40
0x00040390  mov      x20, x0
0x00040394  adrp     x0, #0x7c000
0x00040398  add      x0, x0, #0x308   ; STR "startupScreenBirthday"
0x0004039c  bl       #0x3d124
0x000403a0  mov      x29, x29
0x000403a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000403a8  mov      x21, x0
0x000403ac  bl       #0x40574
0x000403b0  mov      x29, x29
0x000403b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000403b8  mov      x19, x0
0x000403bc  mov      x0, x21
0x000403c0  bl       #0x55d78   ; CALL _objc_release
0x000403c4  cbz      x19, #0x403d4
0x000403c8  mov      w24, #0
0x000403cc  mov      x22, x19
0x000403d0  b        #0x40418
0x000403d4  adrp     x0, #0x7c000
0x000403d8  add      x0, x0, #0x888   ; STR "01-01"
0x000403dc  bl       #0x40574
0x000403e0  mov      x29, x29
0x000403e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000403e8  mov      x21, x0
0x000403ec  cbz      x0, #0x403fc
0x000403f0  mov      w24, #0
0x000403f4  mov      x22, x21
0x000403f8  b        #0x40418
0x000403fc  adrp     x8, #0x8e000
0x00040400  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x00040404  bl       #0x575a0   ; CALL objc_msgSend$date
0x00040408  mov      x29, x29
0x0004040c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040410  mov      x22, x0
0x00040414  mov      w24, #1
0x00040418  mov      x0, x20
0x0004041c  bl       #0x568c0   ; CALL objc_msgSend$birthdayPicker
0x00040420  mov      x29, x29
0x00040424  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040428  mov      x23, x0
0x0004042c  mov      x2, x22
0x00040430  bl       #0x5ac20   ; CALL objc_msgSend$setDate:
0x00040434  mov      x0, x23
0x00040438  bl       #0x55d78   ; CALL _objc_release
0x0004043c  cbz      w24, #0x40448
0x00040440  mov      x0, x22
0x00040444  bl       #0x55d78   ; CALL _objc_release
0x00040448  fmov     d9, #1.00000000
0x0004044c  fmov     d8, #1.00000000
0x00040450  cbnz     x19, #0x40464
0x00040454  mov      x0, x21
0x00040458  bl       #0x55d78   ; CALL _objc_release
0x0004045c  adrp     x8, #0x65000
0x00040460  ldr      d8, [x8, #0x780]
0x00040464  mov      x0, x20
0x00040468  bl       #0x568c0   ; CALL objc_msgSend$birthdayPicker
0x0004046c  mov      x29, x29
0x00040470  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040474  mov      x21, x0
0x00040478  mov      v0.16b, v8.16b
0x0004047c  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x00040480  mov      x0, x21
0x00040484  bl       #0x55d78   ; CALL _objc_release
0x00040488  cmp      x19, #0
0x0004048c  cset     w21, ne
0x00040490  fmov     d0, xzr
0x00040494  fcsel    d8, d9, d0, ne
0x00040498  mov      x0, x20
0x0004049c  bl       #0x56880   ; CALL objc_msgSend$birthdayClear
0x000404a0  mov      x29, x29
0x000404a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000404a8  mov      x22, x0
0x000404ac  mov      v0.16b, v8.16b
0x000404b0  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x000404b4  mov      x0, x22
0x000404b8  bl       #0x55d78   ; CALL _objc_release
0x000404bc  mov      x0, x20
0x000404c0  bl       #0x56880   ; CALL objc_msgSend$birthdayClear
0x000404c4  mov      x29, x29
0x000404c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000404cc  mov      x22, x0
0x000404d0  mov      x2, x21
0x000404d4  bl       #0x5ada0   ; CALL objc_msgSend$setEnabled:
0x000404d8  mov      x0, x22
0x000404dc  bl       #0x55d78   ; CALL _objc_release
0x000404e0  mov      x0, x20
0x000404e4  bl       #0x568e0   ; CALL objc_msgSend$birthdayView
0x000404e8  mov      x29, x29
0x000404ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000404f0  mov      x21, x0
0x000404f4  adrp     x8, #0x74000
0x000404f8  ldr      x8, [x8, #0x2a8]   ; @GOT _UILayoutFittingCompressedSize
0x000404fc  ldp      d0, d1, [x8]
0x00040500  bl       #0x5d860   ; CALL objc_msgSend$systemLayoutSizeFittingSize:
0x00040504  mov      v8.16b, v0.16b
0x00040508  mov      v9.16b, v1.16b
0x0004050c  mov      x0, x21
0x00040510  bl       #0x55d78   ; CALL _objc_release
0x00040514  frintp   d8, d8
0x00040518  frintp   d0, d9
0x0004051c  mov      x8, #0x4042000000000000
0x00040520  fmov     d1, x8
0x00040524  fmaxnm   d9, d0, d1
0x00040528  mov      x0, x20
0x0004052c  bl       #0x568e0   ; CALL objc_msgSend$birthdayView
0x00040530  mov      x29, x29
0x00040534  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040538  mov      x20, x0
0x0004053c  fmov     d0, xzr
0x00040540  fmov     d1, xzr
0x00040544  mov      v2.16b, v8.16b
0x00040548  mov      v3.16b, v9.16b
0x0004054c  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00040550  mov      x0, x20
0x00040554  bl       #0x55d78   ; CALL _objc_release
0x00040558  mov      x0, x19
0x0004055c  ldp      x29, x30, [sp, #0x40]
0x00040560  ldp      x20, x19, [sp, #0x30]
0x00040564  ldp      x22, x21, [sp, #0x20]
0x00040568  ldp      x24, x23, [sp, #0x10]
0x0004056c  ldp      d9, d8, [sp], #0x50
0x00040570  b        #0x55d78   ; CALL _objc_release
0x00040574  stp      x22, x21, [sp, #-0x30]!
0x00040578  stp      x20, x19, [sp, #0x10]
0x0004057c  stp      x29, x30, [sp, #0x20]
0x00040580  add      x29, sp, #0x20
0x00040584  mov      x19, x0
0x00040588  bl       #0x55d84   ; CALL _objc_retain
0x0004058c  adrp     x8, #0x8e000
0x00040590  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00040594  bl       #0x55d48   ; CALL _objc_opt_class
0x00040598  mov      x1, x0
0x0004059c  mov      x0, x19
0x000405a0  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x000405a4  tbz      w0, #0, #0x40618
0x000405a8  mov      x0, x19
0x000405ac  bl       #0x58c20   ; CALL objc_msgSend$length
0x000405b0  cmp      x0, #5
0x000405b4  b.ne     #0x40618
0x000405b8  adrp     x0, #0x7d000
0x000405bc  add      x0, x0, #0x148   ; STR "yyyy-MM-dd"
0x000405c0  bl       #0x406e0
0x000405c4  mov      x29, x29
0x000405c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000405cc  mov      x21, x0
0x000405d0  adrp     x0, #0x7d000
0x000405d4  add      x0, x0, #0x168   ; STR "2000-"
0x000405d8  mov      x2, x19
0x000405dc  bl       #0x5d440   ; CALL objc_msgSend$stringByAppendingString:
0x000405e0  mov      x29, x29
0x000405e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000405e8  mov      x22, x0
0x000405ec  mov      x0, x21
0x000405f0  mov      x2, x22
0x000405f4  bl       #0x57600   ; CALL objc_msgSend$dateFromString:
0x000405f8  mov      x29, x29
0x000405fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040600  mov      x20, x0
0x00040604  mov      x0, x22
0x00040608  bl       #0x55d78   ; CALL _objc_release
0x0004060c  mov      x0, x21
0x00040610  bl       #0x55d78   ; CALL _objc_release
0x00040614  b        #0x4061c
0x00040618  mov      x20, #0
0x0004061c  mov      x0, x19
0x00040620  bl       #0x55d78   ; CALL _objc_release
0x00040624  mov      x0, x20
0x00040628  ldp      x29, x30, [sp, #0x20]
0x0004062c  ldp      x20, x19, [sp, #0x10]
0x00040630  ldp      x22, x21, [sp], #0x30
0x00040634  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCStartupScreenController birthdayChanged:]  va=0x40638 size=404 types=v24@0:8@16
0x00040638  stp      x22, x21, [sp, #-0x30]!
0x0004063c  stp      x20, x19, [sp, #0x10]
0x00040640  stp      x29, x30, [sp, #0x20]
0x00040644  add      x29, sp, #0x20
0x00040648  mov      x19, x2
0x0004064c  mov      x20, x0
0x00040650  mov      x0, x2
0x00040654  bl       #0x55d84   ; CALL _objc_retain
0x00040658  adrp     x0, #0x7c000
0x0004065c  add      x0, x0, #0x8a8   ; STR "MM-dd"
0x00040660  bl       #0x406e0
0x00040664  mov      x29, x29
0x00040668  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004066c  mov      x21, x0
0x00040670  mov      x0, x19
0x00040674  bl       #0x575a0   ; CALL objc_msgSend$date
0x00040678  mov      x29, x29
0x0004067c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040680  mov      x22, x0
0x00040684  mov      x0, x19
0x00040688  bl       #0x55d78   ; CALL _objc_release
0x0004068c  mov      x0, x21
0x00040690  mov      x2, x22
0x00040694  bl       #0x5d500   ; CALL objc_msgSend$stringFromDate:
0x00040698  mov      x29, x29
0x0004069c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000406a0  mov      x19, x0
0x000406a4  adrp     x0, #0x7c000
0x000406a8  add      x0, x0, #0x308   ; STR "startupScreenBirthday"
0x000406ac  mov      x1, x19
0x000406b0  bl       #0x3f7c4
0x000406b4  mov      x0, x19
0x000406b8  bl       #0x55d78   ; CALL _objc_release
0x000406bc  mov      x0, x22
0x000406c0  bl       #0x55d78   ; CALL _objc_release
0x000406c4  mov      x0, x21
0x000406c8  bl       #0x55d78   ; CALL _objc_release
0x000406cc  mov      x0, x20
0x000406d0  ldp      x29, x30, [sp, #0x20]
0x000406d4  ldp      x20, x19, [sp, #0x10]
0x000406d8  ldp      x22, x21, [sp], #0x30
0x000406dc  b        #0x568a0   ; CALL objc_msgSend$birthdayDidChange
0x000406e0  stp      x22, x21, [sp, #-0x30]!
0x000406e4  stp      x20, x19, [sp, #0x10]
0x000406e8  stp      x29, x30, [sp, #0x20]
0x000406ec  add      x29, sp, #0x20
0x000406f0  mov      x19, x0
0x000406f4  adrp     x8, #0x8e000
0x000406f8  ldr      x20, [x8, #0x980]   ; @CLASS NSDateFormatter
0x000406fc  bl       #0x55d84   ; CALL _objc_retain
0x00040700  mov      x0, x20
0x00040704  bl       #0x55d60   ; CALL _objc_opt_new
0x00040708  mov      x20, x0
0x0004070c  adrp     x8, #0x8e000
0x00040710  ldr      x0, [x8, #0xa08]   ; @CLASS NSLocale
0x00040714  adrp     x2, #0x77000
0x00040718  add      x2, x2, #0xea8   ; STR "en_US_POSIX"
0x0004071c  bl       #0x58d60   ; CALL objc_msgSend$localeWithLocaleIdentifier:
0x00040720  mov      x29, x29
0x00040724  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040728  mov      x21, x0
0x0004072c  mov      x0, x20
0x00040730  mov      x2, x21
0x00040734  bl       #0x5b440   ; CALL objc_msgSend$setLocale:
0x00040738  mov      x0, x21
0x0004073c  bl       #0x55d78   ; CALL _objc_release
0x00040740  adrp     x8, #0x8e000
0x00040744  ldr      x0, [x8, #0x9f8]   ; @CLASS NSCalendar
0x00040748  adrp     x8, #0x74000
0x0004074c  ldr      x8, [x8, #0x188]   ; @GOT _NSCalendarIdentifierGregorian
0x00040750  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x00040754  bl       #0x56bc0   ; CALL objc_msgSend$calendarWithIdentifier:
0x00040758  mov      x29, x29
0x0004075c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040760  mov      x21, x0
0x00040764  mov      x0, x20
0x00040768  mov      x2, x21
0x0004076c  bl       #0x5a7a0   ; CALL objc_msgSend$setCalendar:
0x00040770  mov      x0, x21
0x00040774  bl       #0x55d78   ; CALL _objc_release
0x00040778  adrp     x8, #0x8e000
0x0004077c  ldr      x0, [x8, #0xca8]   ; @CLASS NSTimeZone
0x00040780  bl       #0x58d40   ; CALL objc_msgSend$localTimeZone
0x00040784  mov      x29, x29
0x00040788  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004078c  mov      x21, x0
0x00040790  mov      x0, x20
0x00040794  mov      x2, x21
0x00040798  bl       #0x5c580   ; CALL objc_msgSend$setTimeZone:
0x0004079c  mov      x0, x21
0x000407a0  bl       #0x55d78   ; CALL _objc_release
0x000407a4  mov      x0, x20
0x000407a8  mov      x2, x19
0x000407ac  bl       #0x5ac40   ; CALL objc_msgSend$setDateFormat:
0x000407b0  mov      x0, x19
0x000407b4  bl       #0x55d78   ; CALL _objc_release
0x000407b8  mov      x0, x20
0x000407bc  ldp      x29, x30, [sp, #0x20]
0x000407c0  ldp      x20, x19, [sp, #0x10]
0x000407c4  ldp      x22, x21, [sp], #0x30
0x000407c8  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCStartupScreenController clearBirthday]  va=0x407cc size=52 types=v16@0:8
0x000407cc  stp      x20, x19, [sp, #-0x20]!
0x000407d0  stp      x29, x30, [sp, #0x10]
0x000407d4  add      x29, sp, #0x10
0x000407d8  mov      x19, x0
0x000407dc  adrp     x0, #0x7c000
0x000407e0  add      x0, x0, #0x308   ; STR "startupScreenBirthday"
0x000407e4  adrp     x1, #0x75000
0x000407e8  add      x1, x1, #0xd28
0x000407ec  bl       #0x3f7c4
0x000407f0  mov      x0, x19
0x000407f4  ldp      x29, x30, [sp, #0x10]
0x000407f8  ldp      x20, x19, [sp], #0x20
0x000407fc  b        #0x568a0   ; CALL objc_msgSend$birthdayDidChange

=== -[OMCStartupScreenController birthdayDidChange]  va=0x40800 size=372 types=v16@0:8
0x00040800  sub      sp, sp, #0x130
0x00040804  stp      x28, x27, [sp, #0xd0]
0x00040808  stp      x26, x25, [sp, #0xe0]
0x0004080c  stp      x24, x23, [sp, #0xf0]
0x00040810  stp      x22, x21, [sp, #0x100]
0x00040814  stp      x20, x19, [sp, #0x110]
0x00040818  stp      x29, x30, [sp, #0x120]
0x0004081c  add      x29, sp, #0x120
0x00040820  mov      x19, x0
0x00040824  adrp     x8, #0x74000
0x00040828  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0004082c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00040830  stur     x8, [x29, #-0x58]
0x00040834  bl       #0x5dd00   ; CALL objc_msgSend$updateBirthdayAccessory
0x00040838  movi     v0.16b, #0
0x0004083c  stp      q0, q0, [sp, #0x20]
0x00040840  stp      q0, q0, [sp]
0x00040844  adrp     x8, #0x74000
0x00040848  ldr      x8, [x8, #0x368]   ; @GOT _OBJC_IVAR_$_PSListController._specifiers
0x0004084c  ldrsw    x8, [x8]   ; @GOT ___objc_personality_v0
0x00040850  ldr      x20, [x19, x8]
0x00040854  mov      x0, x20
0x00040858  bl       #0x55d84   ; CALL _objc_retain
0x0004085c  mov      x2, sp
0x00040860  add      x3, sp, #0x48
0x00040864  mov      x0, x20
0x00040868  mov      w4, #0x10
0x0004086c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00040870  cbz      x0, #0x40928
0x00040874  mov      x22, x0
0x00040878  ldr      x8, [sp, #0x10]
0x0004087c  ldr      x26, [x8]   ; @GOT ___objc_personality_v0
0x00040880  adrp     x21, #0x7c000
0x00040884  add      x21, x21, #0x4c8   ; STR "occasionPreview"
0x00040888  mov      x27, #0
0x0004088c  ldr      x8, [sp, #0x10]
0x00040890  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00040894  cmp      x8, x26
0x00040898  b.eq     #0x408a4
0x0004089c  mov      x0, x20
0x000408a0  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x000408a4  ldr      x8, [sp, #8]
0x000408a8  ldr      x23, [x8, x27, lsl #3]   ; @GOT ___objc_personality_v0
0x000408ac  mov      x0, x23
0x000408b0  bl       #0x58060   ; CALL objc_msgSend$identifier
0x000408b4  mov      x29, x29
0x000408b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000408bc  mov      x24, x0
0x000408c0  mov      x2, x21
0x000408c4  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x000408c8  mov      x25, x0
0x000408cc  mov      x0, x24
0x000408d0  bl       #0x55d78   ; CALL _objc_release
0x000408d4  cbz      w25, #0x40900
0x000408d8  mov      x0, x19
0x000408dc  bl       #0x59400   ; CALL objc_msgSend$occasionPreviewTitle
0x000408e0  mov      x29, x29
0x000408e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000408e8  mov      x24, x0
0x000408ec  mov      x0, x23
0x000408f0  mov      x2, x24
0x000408f4  bl       #0x5b700   ; CALL objc_msgSend$setName:
0x000408f8  mov      x0, x24
0x000408fc  bl       #0x55d78   ; CALL _objc_release
0x00040900  add      x27, x27, #1
0x00040904  cmp      x22, x27
0x00040908  b.ne     #0x4088c
0x0004090c  mov      x2, sp
0x00040910  add      x3, sp, #0x48
0x00040914  mov      x0, x20
0x00040918  mov      w4, #0x10
0x0004091c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00040920  mov      x22, x0
0x00040924  cbnz     x0, #0x40888
0x00040928  mov      x0, x20
0x0004092c  bl       #0x55d78   ; CALL _objc_release
0x00040930  mov      x0, x19
0x00040934  bl       #0x59c00   ; CALL objc_msgSend$redecorateVisibleCells
0x00040938  ldur     x8, [x29, #-0x58]
0x0004093c  adrp     x9, #0x74000
0x00040940  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00040944  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00040948  cmp      x9, x8
0x0004094c  b.ne     #0x40970
0x00040950  ldp      x29, x30, [sp, #0x120]
0x00040954  ldp      x20, x19, [sp, #0x110]
0x00040958  ldp      x22, x21, [sp, #0x100]
0x0004095c  ldp      x24, x23, [sp, #0xf0]
0x00040960  ldp      x26, x25, [sp, #0xe0]
0x00040964  ldp      x28, x27, [sp, #0xd0]
0x00040968  add      sp, sp, #0x130
0x0004096c  ret      
0x00040970  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController previewOccasion]  va=0x40974 size=160 types=v16@0:8
0x00040974  stp      x22, x21, [sp, #-0x30]!
0x00040978  stp      x20, x19, [sp, #0x10]
0x0004097c  stp      x29, x30, [sp, #0x20]
0x00040980  add      x29, sp, #0x20
0x00040984  mov      x19, x0
0x00040988  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x0004098c  mov      x29, x29
0x00040990  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040994  mov      x20, x0
0x00040998  mov      x0, x19
0x0004099c  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x000409a0  mov      x29, x29
0x000409a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000409a8  mov      x21, x0
0x000409ac  bl       #0x56240   ; CALL objc_msgSend$adjustedContentInset
0x000409b0  fneg     d1, d0
0x000409b4  fmov     d0, xzr
0x000409b8  mov      x0, x20
0x000409bc  mov      w2, #1
0x000409c0  bl       #0x5aa80   ; CALL objc_msgSend$setContentOffset:animated:
0x000409c4  mov      x0, x21
0x000409c8  bl       #0x55d78   ; CALL _objc_release
0x000409cc  mov      x0, x20
0x000409d0  bl       #0x55d78   ; CALL _objc_release
0x000409d4  adrp     x0, #0x7c000
0x000409d8  add      x0, x0, #0x308   ; STR "startupScreenBirthday"
0x000409dc  bl       #0x3d124
0x000409e0  mov      x29, x29
0x000409e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000409e8  mov      x20, x0
0x000409ec  bl       #0x3d47c
0x000409f0  mov      x3, x0
0x000409f4  mov      x0, x19
0x000409f8  mov      w2, #0xb
0x000409fc  bl       #0x5ca80   ; CALL objc_msgSend$showPreviewStyle:occasion:
0x00040a00  mov      x0, x20
0x00040a04  ldp      x29, x30, [sp, #0x20]
0x00040a08  ldp      x20, x19, [sp, #0x10]
0x00040a0c  ldp      x22, x21, [sp], #0x30
0x00040a10  b        #0x55d78   ; CALL _objc_release

=== -[OMCStartupScreenController viewDidAppear:]  va=0x40a14 size=356 types=v20@0:8B16
0x00040a14  sub      sp, sp, #0x130
0x00040a18  stp      x26, x25, [sp, #0xe0]
0x00040a1c  stp      x24, x23, [sp, #0xf0]
0x00040a20  stp      x22, x21, [sp, #0x100]
0x00040a24  stp      x20, x19, [sp, #0x110]
0x00040a28  stp      x29, x30, [sp, #0x120]
0x00040a2c  add      x29, sp, #0x120
0x00040a30  mov      x19, x0
0x00040a34  adrp     x8, #0x74000
0x00040a38  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00040a3c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00040a40  stur     x8, [x29, #-0x48]
0x00040a44  adrp     x8, #0x8e000
0x00040a48  ldr      x8, [x8, #0xdb0]   ; @SUPER OMCStartupScreenController
0x00040a4c  stp      x0, x8, [sp, #0x48]
0x00040a50  adrp     x8, #0x8b000
0x00040a54  ldr      x1, [x8, #0xe40]   ; @SEL "viewDidAppear:"
0x00040a58  add      x0, sp, #0x48
0x00040a5c  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00040a60  adrp     x8, #0x8e000
0x00040a64  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00040a68  bl       #0x565c0   ; CALL objc_msgSend$array
0x00040a6c  mov      x29, x29
0x00040a70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040a74  mov      x20, x0
0x00040a78  movi     v0.16b, #0
0x00040a7c  stp      q0, q0, [sp]
0x00040a80  stp      q0, q0, [sp, #0x20]
0x00040a84  mov      x0, x19
0x00040a88  bl       #0x5df40   ; CALL objc_msgSend$videoFiles
0x00040a8c  mov      x29, x29
0x00040a90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040a94  mov      x21, x0
0x00040a98  mov      x2, sp
0x00040a9c  add      x3, sp, #0x58
0x00040aa0  mov      w4, #0x10
0x00040aa4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00040aa8  cbz      x0, #0x40b20
0x00040aac  mov      x22, x0
0x00040ab0  ldr      x8, [sp, #0x10]
0x00040ab4  ldr      x24, [x8]   ; @SEL "whatsNewNavigationController"
0x00040ab8  mov      x25, #0
0x00040abc  ldr      x8, [sp, #0x10]
0x00040ac0  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00040ac4  cmp      x8, x24
0x00040ac8  b.eq     #0x40ad4
0x00040acc  mov      x0, x21
0x00040ad0  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00040ad4  ldr      x8, [sp, #8]
0x00040ad8  ldr      x23, [x8, x25, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00040adc  mov      x0, x19
0x00040ae0  mov      x2, x23
0x00040ae4  bl       #0x57e80   ; CALL objc_msgSend$hasFramesForVideo:
0x00040ae8  tbnz     w0, #0, #0x40af8
0x00040aec  mov      x0, x20
0x00040af0  mov      x2, x23
0x00040af4  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00040af8  add      x25, x25, #1
0x00040afc  cmp      x22, x25
0x00040b00  b.ne     #0x40abc
0x00040b04  mov      x2, sp
0x00040b08  add      x3, sp, #0x58
0x00040b0c  mov      x0, x21
0x00040b10  mov      w4, #0x10
0x00040b14  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00040b18  mov      x22, x0
0x00040b1c  cbnz     x0, #0x40ab8
0x00040b20  mov      x0, x21
0x00040b24  bl       #0x55d78   ; CALL _objc_release
0x00040b28  mov      x0, x19
0x00040b2c  mov      x2, x20
0x00040b30  mov      x3, #0
0x00040b34  bl       #0x57ae0   ; CALL objc_msgSend$extractFramesForVideos:completion:
0x00040b38  mov      x0, x20
0x00040b3c  bl       #0x55d78   ; CALL _objc_release
0x00040b40  ldur     x8, [x29, #-0x48]
0x00040b44  adrp     x9, #0x74000
0x00040b48  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00040b4c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00040b50  cmp      x9, x8
0x00040b54  b.ne     #0x40b74
0x00040b58  ldp      x29, x30, [sp, #0x120]
0x00040b5c  ldp      x20, x19, [sp, #0x110]
0x00040b60  ldp      x22, x21, [sp, #0x100]
0x00040b64  ldp      x24, x23, [sp, #0xf0]
0x00040b68  ldp      x26, x25, [sp, #0xe0]
0x00040b6c  add      sp, sp, #0x130
0x00040b70  ret      
0x00040b74  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController videoFiles]  va=0x40b78 size=556 types=@16@0:8
0x00040b78  stp      x28, x27, [sp, #-0x60]!
0x00040b7c  stp      x26, x25, [sp, #0x10]
0x00040b80  stp      x24, x23, [sp, #0x20]
0x00040b84  stp      x22, x21, [sp, #0x30]
0x00040b88  stp      x20, x19, [sp, #0x40]
0x00040b8c  stp      x29, x30, [sp, #0x50]
0x00040b90  add      x29, sp, #0x50
0x00040b94  sub      sp, sp, #0x4d0
0x00040b98  adrp     x8, #0x74000
0x00040b9c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00040ba0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00040ba4  stur     x8, [x29, #-0x58]
0x00040ba8  adrp     x8, #0x8e000
0x00040bac  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x00040bb0  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x00040bb4  mov      x29, x29
0x00040bb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040bbc  mov      x19, x0
0x00040bc0  adrp     x0, #0x76000
0x00040bc4  add      x0, x0, #0xb68   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Videos"
0x00040bc8  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00040bcc  add      x1, sp, #0xc8
0x00040bd0  bl       #0x4118
0x00040bd4  adrp     x21, #0x8e000
0x00040bd8  cbz      x0, #0x40bf8
0x00040bdc  mov      x2, x0
0x00040be0  ldr      x0, [x21, #0x958]   ; @CLASS NSString
0x00040be4  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00040be8  mov      x29, x29
0x00040bec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040bf0  mov      x20, x0
0x00040bf4  b        #0x40bfc
0x00040bf8  mov      x20, #0
0x00040bfc  mov      x0, x19
0x00040c00  mov      x2, x20
0x00040c04  mov      w3, #1
0x00040c08  mov      x4, #0
0x00040c0c  mov      x5, #0
0x00040c10  bl       #0x57400   ; CALL objc_msgSend$createDirectoryAtPath:withIntermediateDirectories:attributes:error:
0x00040c14  mov      x0, x20
0x00040c18  bl       #0x55d78   ; CALL _objc_release
0x00040c1c  adrp     x8, #0x8e000
0x00040c20  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00040c24  bl       #0x565c0   ; CALL objc_msgSend$array
0x00040c28  mov      x29, x29
0x00040c2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040c30  mov      x20, x0
0x00040c34  movi     v0.16b, #0
0x00040c38  stp      q0, q0, [sp]
0x00040c3c  stp      q0, q0, [sp, #0x20]
0x00040c40  adrp     x0, #0x76000
0x00040c44  add      x0, x0, #0xb68   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Videos"
0x00040c48  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00040c4c  add      x1, sp, #0xc8
0x00040c50  bl       #0x4118
0x00040c54  cbz      x0, #0x40c74
0x00040c58  mov      x2, x0
0x00040c5c  ldr      x0, [x21, #0x958]   ; @CLASS NSString
0x00040c60  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00040c64  mov      x29, x29
0x00040c68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040c6c  mov      x22, x0
0x00040c70  b        #0x40c78
0x00040c74  mov      x22, #0
0x00040c78  mov      x0, x19
0x00040c7c  mov      x2, x22
0x00040c80  mov      x3, #0
0x00040c84  bl       #0x572a0   ; CALL objc_msgSend$contentsOfDirectoryAtPath:error:
0x00040c88  mov      x29, x29
0x00040c8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040c90  mov      x21, x0
0x00040c94  mov      x0, x22
0x00040c98  bl       #0x55d78   ; CALL _objc_release
0x00040c9c  mov      x2, sp
0x00040ca0  add      x3, sp, #0x48
0x00040ca4  mov      x0, x21
0x00040ca8  mov      w4, #0x10
0x00040cac  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00040cb0  cbz      x0, #0x40d30
0x00040cb4  mov      x23, x0
0x00040cb8  ldr      x8, [sp, #0x10]
0x00040cbc  ldr      x25, [x8]   ; @SEL "whatsNewNavigationController"
0x00040cc0  adrp     x22, #0x77000
0x00040cc4  add      x22, x22, #0x848   ; STR "."
0x00040cc8  mov      x26, #0
0x00040ccc  ldr      x8, [sp, #0x10]
0x00040cd0  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00040cd4  cmp      x8, x25
0x00040cd8  b.eq     #0x40ce4
0x00040cdc  mov      x0, x21
0x00040ce0  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00040ce4  ldr      x8, [sp, #8]
0x00040ce8  ldr      x24, [x8, x26, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00040cec  mov      x0, x24
0x00040cf0  mov      x2, x22
0x00040cf4  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x00040cf8  tbnz     w0, #0, #0x40d08
0x00040cfc  mov      x0, x20
0x00040d00  mov      x2, x24
0x00040d04  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00040d08  add      x26, x26, #1
0x00040d0c  cmp      x23, x26
0x00040d10  b.ne     #0x40ccc
0x00040d14  mov      x2, sp
0x00040d18  add      x3, sp, #0x48
0x00040d1c  mov      x0, x21
0x00040d20  mov      w4, #0x10
0x00040d24  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00040d28  mov      x23, x0
0x00040d2c  cbnz     x0, #0x40cc8
0x00040d30  mov      x0, x21
0x00040d34  bl       #0x55d78   ; CALL _objc_release
0x00040d38  adrp     x8, #0x8b000
0x00040d3c  ldr      x2, [x8, #0xf30]   ; @SEL "localizedStandardCompare:"
0x00040d40  mov      x0, x20
0x00040d44  bl       #0x5cd00   ; CALL objc_msgSend$sortedArrayUsingSelector:
0x00040d48  mov      x29, x29
0x00040d4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040d50  mov      x21, x0
0x00040d54  mov      x0, x20
0x00040d58  bl       #0x55d78   ; CALL _objc_release
0x00040d5c  mov      x0, x19
0x00040d60  bl       #0x55d78   ; CALL _objc_release
0x00040d64  ldur     x8, [x29, #-0x58]
0x00040d68  adrp     x9, #0x74000
0x00040d6c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00040d70  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00040d74  cmp      x9, x8
0x00040d78  b.ne     #0x40da0
0x00040d7c  mov      x0, x21
0x00040d80  add      sp, sp, #0x4d0
0x00040d84  ldp      x29, x30, [sp, #0x50]
0x00040d88  ldp      x20, x19, [sp, #0x40]
0x00040d8c  ldp      x22, x21, [sp, #0x30]
0x00040d90  ldp      x24, x23, [sp, #0x20]
0x00040d94  ldp      x26, x25, [sp, #0x10]
0x00040d98  ldp      x28, x27, [sp], #0x60
0x00040d9c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00040da0  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController refreshVideoList]  va=0x40da4 size=700 types=v16@0:8
0x00040da4  sub      sp, sp, #0x1f0
0x00040da8  stp      x28, x27, [sp, #0x190]
0x00040dac  stp      x26, x25, [sp, #0x1a0]
0x00040db0  stp      x24, x23, [sp, #0x1b0]
0x00040db4  stp      x22, x21, [sp, #0x1c0]
0x00040db8  stp      x20, x19, [sp, #0x1d0]
0x00040dbc  stp      x29, x30, [sp, #0x1e0]
0x00040dc0  add      x29, sp, #0x1e0
0x00040dc4  mov      x20, x0
0x00040dc8  adrp     x8, #0x74000
0x00040dcc  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00040dd0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00040dd4  stur     x8, [x29, #-0x58]
0x00040dd8  movi     v0.16b, #0
0x00040ddc  stp      q0, q0, [sp, #0x40]
0x00040de0  stp      q0, q0, [sp, #0x60]
0x00040de4  adrp     x8, #0x74000
0x00040de8  ldr      x8, [x8, #0x368]   ; @GOT _OBJC_IVAR_$_PSListController._specifiers
0x00040dec  ldrsw    x8, [x8]   ; @GOT ___objc_personality_v0
0x00040df0  ldr      x21, [x0, x8]
0x00040df4  mov      x0, x21
0x00040df8  bl       #0x55d84   ; CALL _objc_retain
0x00040dfc  add      x2, sp, #0x40
0x00040e00  sub      x3, x29, #0xd8
0x00040e04  mov      x0, x21
0x00040e08  mov      w4, #0x10
0x00040e0c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00040e10  cbz      x0, #0x40ea0
0x00040e14  mov      x23, x0
0x00040e18  ldr      x8, [sp, #0x50]
0x00040e1c  ldr      x26, [x8]   ; @GOT ___objc_personality_v0
0x00040e20  adrp     x22, #0x7c000
0x00040e24  add      x22, x22, #0x8c8   ; STR "videoName"
0x00040e28  mov      x27, #0
0x00040e2c  ldr      x8, [sp, #0x50]
0x00040e30  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00040e34  cmp      x8, x26
0x00040e38  b.eq     #0x40e44
0x00040e3c  mov      x0, x21
0x00040e40  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00040e44  ldr      x8, [sp, #0x48]
0x00040e48  ldr      x19, [x8, x27, lsl #3]   ; @GOT ___objc_personality_v0
0x00040e4c  mov      x0, x19
0x00040e50  bl       #0x58060   ; CALL objc_msgSend$identifier
0x00040e54  mov      x29, x29
0x00040e58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040e5c  mov      x24, x0
0x00040e60  mov      x2, x22
0x00040e64  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00040e68  mov      x25, x0
0x00040e6c  mov      x0, x24
0x00040e70  bl       #0x55d78   ; CALL _objc_release
0x00040e74  tbnz     w25, #0, #0x40ea8
0x00040e78  add      x27, x27, #1
0x00040e7c  cmp      x23, x27
0x00040e80  b.ne     #0x40e2c
0x00040e84  add      x2, sp, #0x40
0x00040e88  sub      x3, x29, #0xd8
0x00040e8c  mov      x0, x21
0x00040e90  mov      w4, #0x10
0x00040e94  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00040e98  mov      x23, x0
0x00040e9c  cbnz     x0, #0x40e28
0x00040ea0  mov      x19, x21
0x00040ea4  b        #0x4101c
0x00040ea8  mov      x0, x19
0x00040eac  bl       #0x55d84   ; CALL _objc_retain
0x00040eb0  mov      x0, x21
0x00040eb4  bl       #0x55d78   ; CALL _objc_release
0x00040eb8  cbz      x19, #0x41024
0x00040ebc  mov      x0, x20
0x00040ec0  bl       #0x5df40   ; CALL objc_msgSend$videoFiles
0x00040ec4  mov      x29, x29
0x00040ec8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040ecc  mov      x20, x0
0x00040ed0  bl       #0x573c0   ; CALL objc_msgSend$count
0x00040ed4  cbz      x0, #0x40fb4
0x00040ed8  adrp     x8, #0x8e000
0x00040edc  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00040ee0  bl       #0x565c0   ; CALL objc_msgSend$array
0x00040ee4  mov      x29, x29
0x00040ee8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040eec  mov      x21, x0
0x00040ef0  movi     v0.16b, #0
0x00040ef4  stp      q0, q0, [sp]
0x00040ef8  stp      q0, q0, [sp, #0x20]
0x00040efc  mov      x0, x20
0x00040f00  bl       #0x55d84   ; CALL _objc_retain
0x00040f04  mov      x2, sp
0x00040f08  add      x3, sp, #0x88
0x00040f0c  mov      x0, x20
0x00040f10  mov      w4, #0x10
0x00040f14  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00040f18  cbz      x0, #0x40f98
0x00040f1c  mov      x22, x0
0x00040f20  ldr      x8, [sp, #0x10]
0x00040f24  ldr      x24, [x8]   ; @SEL "whatsNewNavigationController"
0x00040f28  mov      x25, #0
0x00040f2c  ldr      x8, [sp, #0x10]
0x00040f30  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00040f34  cmp      x8, x24
0x00040f38  b.eq     #0x40f44
0x00040f3c  mov      x0, x20
0x00040f40  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00040f44  ldr      x8, [sp, #8]
0x00040f48  ldr      x0, [x8, x25, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00040f4c  bl       #0x5d480   ; CALL objc_msgSend$stringByDeletingPathExtension
0x00040f50  mov      x29, x29
0x00040f54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040f58  mov      x23, x0
0x00040f5c  mov      x0, x21
0x00040f60  mov      x2, x23
0x00040f64  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00040f68  mov      x0, x23
0x00040f6c  bl       #0x55d78   ; CALL _objc_release
0x00040f70  add      x25, x25, #1
0x00040f74  cmp      x22, x25
0x00040f78  b.ne     #0x40f2c
0x00040f7c  mov      x2, sp
0x00040f80  add      x3, sp, #0x88
0x00040f84  mov      x0, x20
0x00040f88  mov      w4, #0x10
0x00040f8c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00040f90  mov      x22, x0
0x00040f94  cbnz     x0, #0x40f28
0x00040f98  mov      x0, x20
0x00040f9c  bl       #0x55d78   ; CALL _objc_release
0x00040fa0  mov      x0, x19
0x00040fa4  mov      x2, x20
0x00040fa8  mov      x3, x21
0x00040fac  bl       #0x5c7a0   ; CALL objc_msgSend$setValues:titles:
0x00040fb0  b        #0x4100c
0x00040fb4  adrp     x0, #0x7c000
0x00040fb8  add      x0, x0, #0x8e8   ; STR "STARTUPSCREEN_NO_VIDEO"
0x00040fbc  bl       #0x17e20   ; CALL _L
0x00040fc0  mov      x29, x29
0x00040fc4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040fc8  mov      x21, x0
0x00040fcc  str      x0, [sp, #0x80]
0x00040fd0  adrp     x8, #0x8e000
0x00040fd4  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00040fd8  add      x2, sp, #0x80
0x00040fdc  mov      w3, #1
0x00040fe0  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00040fe4  mov      x29, x29
0x00040fe8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00040fec  mov      x22, x0
0x00040ff0  adrp     x2, #0x7f000
0x00040ff4  add      x2, x2, #0xc78
0x00040ff8  mov      x0, x19
0x00040ffc  mov      x3, x22
0x00041000  bl       #0x5c7a0   ; CALL objc_msgSend$setValues:titles:
0x00041004  mov      x0, x22
0x00041008  bl       #0x55d78   ; CALL _objc_release
0x0004100c  mov      x0, x21
0x00041010  bl       #0x55d78   ; CALL _objc_release
0x00041014  mov      x0, x20
0x00041018  bl       #0x55d78   ; CALL _objc_release
0x0004101c  mov      x0, x19
0x00041020  bl       #0x55d78   ; CALL _objc_release
0x00041024  ldur     x8, [x29, #-0x58]
0x00041028  adrp     x9, #0x74000
0x0004102c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00041030  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00041034  cmp      x9, x8
0x00041038  b.ne     #0x4105c
0x0004103c  ldp      x29, x30, [sp, #0x1e0]
0x00041040  ldp      x20, x19, [sp, #0x1d0]
0x00041044  ldp      x22, x21, [sp, #0x1c0]
0x00041048  ldp      x24, x23, [sp, #0x1b0]
0x0004104c  ldp      x26, x25, [sp, #0x1a0]
0x00041050  ldp      x28, x27, [sp, #0x190]
0x00041054  add      sp, sp, #0x1f0
0x00041058  ret      
0x0004105c  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController selectedVideo]  va=0x41060 size=164 types=@16@0:8
0x00041060  stp      x22, x21, [sp, #-0x30]!
0x00041064  stp      x20, x19, [sp, #0x10]
0x00041068  stp      x29, x30, [sp, #0x20]
0x0004106c  add      x29, sp, #0x20
0x00041070  mov      x20, x0
0x00041074  adrp     x0, #0x77000
0x00041078  add      x0, x0, #0x828   ; STR "startupScreenVideoName"
0x0004107c  adrp     x1, #0x75000
0x00041080  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x00041084  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x00041088  mov      x19, x0
0x0004108c  mov      x0, x20
0x00041090  bl       #0x5df40   ; CALL objc_msgSend$videoFiles
0x00041094  mov      x29, x29
0x00041098  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004109c  mov      x20, x0
0x000410a0  mov      x0, x19
0x000410a4  bl       #0x58c20   ; CALL objc_msgSend$length
0x000410a8  cbz      x0, #0x410cc
0x000410ac  mov      x0, x20
0x000410b0  mov      x2, x19
0x000410b4  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x000410b8  cbz      w0, #0x410cc
0x000410bc  mov      x0, x19
0x000410c0  bl       #0x55d84   ; CALL _objc_retain
0x000410c4  mov      x21, x19
0x000410c8  b        #0x410e0
0x000410cc  mov      x0, x20
0x000410d0  bl       #0x57c20   ; CALL objc_msgSend$firstObject
0x000410d4  mov      x29, x29
0x000410d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000410dc  mov      x21, x0
0x000410e0  mov      x0, x20
0x000410e4  bl       #0x55d78   ; CALL _objc_release
0x000410e8  mov      x0, x19
0x000410ec  bl       #0x55d78   ; CALL _objc_release
0x000410f0  mov      x0, x21
0x000410f4  ldp      x29, x30, [sp, #0x20]
0x000410f8  ldp      x20, x19, [sp, #0x10]
0x000410fc  ldp      x22, x21, [sp], #0x30
0x00041100  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCStartupScreenController setSelectedVideo:]  va=0x41104 size=68 types=v24@0:8@16
0x00041104  stp      x20, x19, [sp, #-0x20]!
0x00041108  stp      x29, x30, [sp, #0x10]
0x0004110c  add      x29, sp, #0x10
0x00041110  mov      x1, x2
0x00041114  mov      x19, x0
0x00041118  adrp     x0, #0x77000
0x0004111c  add      x0, x0, #0x828   ; STR "startupScreenVideoName"
0x00041120  adrp     x20, #0x75000
0x00041124  add      x20, x20, #0x28   ; STR "com.anlai.omnicar"
0x00041128  mov      x2, x20
0x0004112c  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x00041130  mov      x0, x20
0x00041134  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x00041138  mov      x0, x19
0x0004113c  ldp      x29, x30, [sp, #0x10]
0x00041140  ldp      x20, x19, [sp], #0x20
0x00041144  b        #0x59d40   ; CALL objc_msgSend$reloadSpecifiers

=== -[OMCStartupScreenController hasFramesForVideo:]  va=0x41148 size=364 types=B24@0:8@16
0x00041148  stp      x24, x23, [sp, #-0x40]!
0x0004114c  stp      x22, x21, [sp, #0x10]
0x00041150  stp      x20, x19, [sp, #0x20]
0x00041154  stp      x29, x30, [sp, #0x30]
0x00041158  add      x29, sp, #0x30
0x0004115c  sub      sp, sp, #0x410
0x00041160  mov      x19, x2
0x00041164  adrp     x8, #0x74000
0x00041168  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0004116c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00041170  stur     x8, [x29, #-0x38]
0x00041174  mov      x0, x2
0x00041178  bl       #0x55d84   ; CALL _objc_retain
0x0004117c  adrp     x0, #0x76000
0x00041180  add      x0, x0, #0xb68   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Videos"
0x00041184  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00041188  add      x1, sp, #8
0x0004118c  bl       #0x4118
0x00041190  cbz      x0, #0x411b4
0x00041194  mov      x2, x0
0x00041198  adrp     x8, #0x8e000
0x0004119c  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x000411a0  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x000411a4  mov      x29, x29
0x000411a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000411ac  mov      x20, x0
0x000411b0  b        #0x411b8
0x000411b4  mov      x20, #0
0x000411b8  adrp     x2, #0x76000
0x000411bc  add      x2, x2, #0xb88   ; STR ".frames"
0x000411c0  mov      x0, x20
0x000411c4  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x000411c8  mov      x29, x29
0x000411cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000411d0  mov      x21, x0
0x000411d4  mov      x2, x19
0x000411d8  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x000411dc  mov      x29, x29
0x000411e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000411e4  mov      x22, x0
0x000411e8  mov      x0, x19
0x000411ec  bl       #0x55d78   ; CALL _objc_release
0x000411f0  adrp     x2, #0x76000
0x000411f4  add      x2, x2, #0xba8   ; STR "info.plist"
0x000411f8  mov      x0, x22
0x000411fc  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00041200  mov      x29, x29
0x00041204  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041208  mov      x23, x0
0x0004120c  mov      x0, x22
0x00041210  bl       #0x55d78   ; CALL _objc_release
0x00041214  mov      x0, x21
0x00041218  bl       #0x55d78   ; CALL _objc_release
0x0004121c  mov      x0, x20
0x00041220  bl       #0x55d78   ; CALL _objc_release
0x00041224  adrp     x8, #0x8e000
0x00041228  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x0004122c  mov      x2, x23
0x00041230  bl       #0x577a0   ; CALL objc_msgSend$dictionaryWithContentsOfFile:
0x00041234  mov      x29, x29
0x00041238  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004123c  mov      x20, x0
0x00041240  adrp     x2, #0x77000
0x00041244  add      x2, x2, #0x128   ; STR "version"
0x00041248  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0004124c  mov      x29, x29
0x00041250  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041254  mov      x21, x0
0x00041258  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0004125c  cmp      x0, #1
0x00041260  cset     w19, gt
0x00041264  mov      x0, x21
0x00041268  bl       #0x55d78   ; CALL _objc_release
0x0004126c  mov      x0, x20
0x00041270  bl       #0x55d78   ; CALL _objc_release
0x00041274  mov      x0, x23
0x00041278  bl       #0x55d78   ; CALL _objc_release
0x0004127c  ldur     x8, [x29, #-0x38]
0x00041280  adrp     x9, #0x74000
0x00041284  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00041288  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0004128c  cmp      x9, x8
0x00041290  b.ne     #0x412b0
0x00041294  mov      x0, x19
0x00041298  add      sp, sp, #0x410
0x0004129c  ldp      x29, x30, [sp, #0x30]
0x000412a0  ldp      x20, x19, [sp, #0x20]
0x000412a4  ldp      x22, x21, [sp, #0x10]
0x000412a8  ldp      x24, x23, [sp], #0x40
0x000412ac  ret      
0x000412b0  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController extractAudioFromAsset:seconds:toDir:]  va=0x412b4 size=556 types=B40@0:8@16d24@32
0x000412b4  sub      sp, sp, #0x110
0x000412b8  stp      d9, d8, [sp, #0xb0]
0x000412bc  stp      x28, x27, [sp, #0xc0]
0x000412c0  stp      x24, x23, [sp, #0xd0]
0x000412c4  stp      x22, x21, [sp, #0xe0]
0x000412c8  stp      x20, x19, [sp, #0xf0]
0x000412cc  stp      x29, x30, [sp, #0x100]
0x000412d0  add      x29, sp, #0x100
0x000412d4  mov      x20, x3
0x000412d8  mov      v8.16b, v0.16b
0x000412dc  mov      x19, x2
0x000412e0  mov      x0, x2
0x000412e4  bl       #0x55d84   ; CALL _objc_retain
0x000412e8  mov      x0, x20
0x000412ec  bl       #0x55d84   ; CALL _objc_retain
0x000412f0  adrp     x8, #0x74000
0x000412f4  ldr      x8, [x8, #0x2f8]   ; @GOT _AVMediaTypeAudio
0x000412f8  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x000412fc  mov      x0, x19
0x00041300  bl       #0x5dc20   ; CALL objc_msgSend$tracksWithMediaType:
0x00041304  mov      x29, x29
0x00041308  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004130c  mov      x21, x0
0x00041310  bl       #0x573c0   ; CALL objc_msgSend$count
0x00041314  mov      x22, x0
0x00041318  mov      x0, x21
0x0004131c  bl       #0x55d78   ; CALL _objc_release
0x00041320  cbz      x22, #0x41490
0x00041324  adrp     x8, #0x8e000
0x00041328  ldr      x0, [x8, #0xb70]   ; @CLASS AVAssetExportSession
0x0004132c  adrp     x8, #0x74000
0x00041330  ldr      x8, [x8, #0x2d0]   ; @GOT _AVAssetExportPresetAppleM4A
0x00041334  ldr      x3, [x8]   ; @GOT ___objc_personality_v0
0x00041338  mov      x2, x19
0x0004133c  bl       #0x57a60   ; CALL objc_msgSend$exportSessionWithAsset:presetName:
0x00041340  mov      x29, x29
0x00041344  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041348  mov      x21, x0
0x0004134c  cbz      x0, #0x41498
0x00041350  add      x24, sp, #0x80
0x00041354  adrp     x8, #0x8e000
0x00041358  ldr      x22, [x8, #0xa10]   ; @CLASS NSURL
0x0004135c  adrp     x2, #0x7c000
0x00041360  add      x2, x2, #0x908   ; STR "audio.m4a"
0x00041364  mov      x0, x20
0x00041368  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x0004136c  mov      x29, x29
0x00041370  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041374  mov      x23, x0
0x00041378  mov      x0, x22
0x0004137c  mov      x2, x23
0x00041380  bl       #0x57ba0   ; CALL objc_msgSend$fileURLWithPath:
0x00041384  mov      x29, x29
0x00041388  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004138c  mov      x22, x0
0x00041390  mov      x0, x21
0x00041394  mov      x2, x22
0x00041398  bl       #0x5ba40   ; CALL objc_msgSend$setOutputURL:
0x0004139c  mov      x0, x22
0x000413a0  bl       #0x55d78   ; CALL _objc_release
0x000413a4  mov      x0, x23
0x000413a8  bl       #0x55d78   ; CALL _objc_release
0x000413ac  adrp     x8, #0x74000
0x000413b0  ldr      x8, [x8, #0x2e0]   ; @GOT _AVFileTypeAppleM4A
0x000413b4  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x000413b8  mov      x0, x21
0x000413bc  bl       #0x5ba20   ; CALL objc_msgSend$setOutputFileType:
0x000413c0  add      x8, sp, #0x30
0x000413c4  mov      v0.16b, v8.16b
0x000413c8  mov      w0, #0x258
0x000413cc  bl       #0x55acc   ; CALL _CMTimeMakeWithSeconds
0x000413d0  adrp     x8, #0x74000
0x000413d4  ldr      x8, [x8, #0x350]   ; @GOT _kCMTimeZero
0x000413d8  ldr      q0, [x8]   ; @GOT ___objc_personality_v0
0x000413dc  str      q0, [sp, #0x60]
0x000413e0  ldr      x8, [x8, #0x10]   ; @GOT _objc_alloc_init
0x000413e4  str      x8, [sp, #0x70]
0x000413e8  add      x8, sp, #0x80
0x000413ec  add      x0, sp, #0x60
0x000413f0  add      x1, sp, #0x30
0x000413f4  bl       #0x55ae4   ; CALL _CMTimeRangeMake
0x000413f8  ldr      q0, [sp, #0x80]
0x000413fc  ldp      q1, q2, [x24, #0x10]
0x00041400  stp      q0, q1, [sp, #0x30]
0x00041404  str      q2, [sp, #0x50]
0x00041408  add      x2, sp, #0x30
0x0004140c  mov      x0, x21
0x00041410  bl       #0x5c560   ; CALL objc_msgSend$setTimeRange:
0x00041414  mov      x0, #0
0x00041418  bl       #0x55c04   ; CALL _dispatch_semaphore_create
0x0004141c  mov      x23, x0
0x00041420  adrp     x8, #0x74000
0x00041424  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00041428  str      x8, [sp, #8]
0x0004142c  adrp     x8, #0x65000
0x00041430  ldr      d0, [x8, #0x600]
0x00041434  adrp     x8, #0x41000
0x00041438  add      x8, x8, #0x4d8
0x0004143c  str      d0, [sp, #0x10]
0x00041440  adrp     x9, #0x74000
0x00041444  add      x9, x9, #0x6e0
0x00041448  stp      x8, x9, [sp, #0x18]
0x0004144c  str      x0, [sp, #0x28]
0x00041450  bl       #0x55d84   ; CALL _objc_retain
0x00041454  add      x2, sp, #8
0x00041458  mov      x0, x21
0x0004145c  bl       #0x57a40   ; CALL objc_msgSend$exportAsynchronouslyWithCompletionHandler:
0x00041460  mov      x0, x23
0x00041464  mov      x1, #-1
0x00041468  bl       #0x55c1c   ; CALL _dispatch_semaphore_wait
0x0004146c  mov      x0, x21
0x00041470  bl       #0x5d320   ; CALL objc_msgSend$status
0x00041474  cmp      x0, #3
0x00041478  cset     w22, eq
0x0004147c  ldr      x0, [sp, #0x28]
0x00041480  bl       #0x55d78   ; CALL _objc_release
0x00041484  mov      x0, x23
0x00041488  bl       #0x55d78   ; CALL _objc_release
0x0004148c  b        #0x4149c
0x00041490  mov      w22, #1
0x00041494  b        #0x414a4
0x00041498  mov      w22, #0
0x0004149c  mov      x0, x21
0x000414a0  bl       #0x55d78   ; CALL _objc_release
0x000414a4  mov      x0, x20
0x000414a8  bl       #0x55d78   ; CALL _objc_release
0x000414ac  mov      x0, x19
0x000414b0  bl       #0x55d78   ; CALL _objc_release
0x000414b4  mov      x0, x22
0x000414b8  ldp      x29, x30, [sp, #0x100]
0x000414bc  ldp      x20, x19, [sp, #0xf0]
0x000414c0  ldp      x22, x21, [sp, #0xe0]
0x000414c4  ldp      x24, x23, [sp, #0xd0]
0x000414c8  ldp      x28, x27, [sp, #0xc0]
0x000414cc  ldp      d9, d8, [sp, #0xb0]
0x000414d0  add      sp, sp, #0x110
0x000414d4  ret      
0x000414d8  ldr      x0, [x0, #0x20]
0x000414dc  b        #0x55c10   ; CALL _dispatch_semaphore_signal

=== -[OMCStartupScreenController extractFramesForVideos:completion:]  va=0x414e0 size=1892 types=v32@0:8@16@?24
0x000414e0  sub      sp, sp, #0x80
0x000414e4  stp      x24, x23, [sp, #0x40]
0x000414e8  stp      x22, x21, [sp, #0x50]
0x000414ec  stp      x20, x19, [sp, #0x60]
0x000414f0  stp      x29, x30, [sp, #0x70]
0x000414f4  add      x29, sp, #0x70
0x000414f8  mov      x20, x3
0x000414fc  mov      x19, x2
0x00041500  mov      x21, x0
0x00041504  mov      x0, x2
0x00041508  bl       #0x55d84   ; CALL _objc_retain
0x0004150c  mov      x0, x20
0x00041510  bl       #0x55d84   ; CALL _objc_retain
0x00041514  mov      x0, x19
0x00041518  bl       #0x573c0   ; CALL objc_msgSend$count
0x0004151c  cbz      x0, #0x4152c
0x00041520  mov      x0, x21
0x00041524  bl       #0x57b00   ; CALL objc_msgSend$extracting
0x00041528  cbz      w0, #0x41540
0x0004152c  cbz      x20, #0x41668
0x00041530  ldr      x8, [x20, #0x10]
0x00041534  mov      x0, x20
0x00041538  blr      x8
0x0004153c  b        #0x41668
0x00041540  mov      x0, x21
0x00041544  mov      w2, #1
0x00041548  bl       #0x5ade0   ; CALL objc_msgSend$setExtracting:
0x0004154c  adrp     x8, #0x8e000
0x00041550  ldr      x22, [x8, #0x9b8]   ; @CLASS UIAlertController
0x00041554  adrp     x0, #0x7c000
0x00041558  add      x0, x0, #0x928   ; STR "STARTUPSCREEN_PREPARING"
0x0004155c  bl       #0x17e20   ; CALL _L
0x00041560  mov      x29, x29
0x00041564  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041568  mov      x23, x0
0x0004156c  adrp     x2, #0x7c000
0x00041570  add      x2, x2, #0x948   ; STR "…"
0x00041574  bl       #0x5d440   ; CALL objc_msgSend$stringByAppendingString:
0x00041578  mov      x29, x29
0x0004157c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041580  mov      x24, x0
0x00041584  adrp     x2, #0x75000
0x00041588  add      x2, x2, #0x508   ; STR "OmniCar"
0x0004158c  mov      x0, x22
0x00041590  mov      x3, x24
0x00041594  mov      w4, #1
0x00041598  bl       #0x56280   ; CALL objc_msgSend$alertControllerWithTitle:message:preferredStyle:
0x0004159c  mov      x29, x29
0x000415a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000415a4  mov      x22, x0
0x000415a8  mov      x0, x24
0x000415ac  bl       #0x55d78   ; CALL _objc_release
0x000415b0  mov      x0, x23
0x000415b4  bl       #0x55d78   ; CALL _objc_release
0x000415b8  mov      x0, x21
0x000415bc  mov      x2, x22
0x000415c0  mov      w3, #1
0x000415c4  mov      x4, #0
0x000415c8  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x000415cc  mov      w0, #0x19
0x000415d0  mov      x1, #0
0x000415d4  bl       #0x55bec   ; CALL _dispatch_get_global_queue
0x000415d8  mov      x29, x29
0x000415dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000415e0  mov      x23, x0
0x000415e4  adrp     x8, #0x74000
0x000415e8  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x000415ec  str      x8, [sp]
0x000415f0  adrp     x8, #0x65000
0x000415f4  ldr      d0, [x8, #0x600]
0x000415f8  str      d0, [sp, #8]
0x000415fc  adrp     x8, #0x41000
0x00041600  add      x8, x8, #0x690
0x00041604  adrp     x9, #0x74000
0x00041608  add      x9, x9, #0xd98
0x0004160c  stp      x8, x9, [sp, #0x10]
0x00041610  mov      x0, x19
0x00041614  bl       #0x55d84   ; CALL _objc_retain
0x00041618  stp      x19, x21, [sp, #0x20]
0x0004161c  str      x22, [sp, #0x30]
0x00041620  mov      x0, x20
0x00041624  bl       #0x55d84   ; CALL _objc_retain
0x00041628  str      x20, [sp, #0x38]
0x0004162c  mov      x0, x22
0x00041630  bl       #0x55d84   ; CALL _objc_retain
0x00041634  mov      x1, sp
0x00041638  mov      x0, x23
0x0004163c  bl       #0x55be0   ; CALL _dispatch_async
0x00041640  mov      x0, x23
0x00041644  bl       #0x55d78   ; CALL _objc_release
0x00041648  ldr      x0, [sp, #0x38]
0x0004164c  bl       #0x55d78   ; CALL _objc_release
0x00041650  ldr      x0, [sp, #0x30]
0x00041654  bl       #0x55d78   ; CALL _objc_release
0x00041658  ldr      x0, [sp, #0x20]
0x0004165c  bl       #0x55d78   ; CALL _objc_release
0x00041660  mov      x0, x22
0x00041664  bl       #0x55d78   ; CALL _objc_release
0x00041668  mov      x0, x20
0x0004166c  bl       #0x55d78   ; CALL _objc_release
0x00041670  mov      x0, x19
0x00041674  bl       #0x55d78   ; CALL _objc_release
0x00041678  ldp      x29, x30, [sp, #0x70]
0x0004167c  ldp      x20, x19, [sp, #0x60]
0x00041680  ldp      x22, x21, [sp, #0x50]
0x00041684  ldp      x24, x23, [sp, #0x40]
0x00041688  add      sp, sp, #0x80
0x0004168c  ret      
0x00041690  sub      sp, sp, #0xd0
0x00041694  stp      d9, d8, [sp, #0x90]
0x00041698  stp      x22, x21, [sp, #0xa0]
0x0004169c  stp      x20, x19, [sp, #0xb0]
0x000416a0  stp      x29, x30, [sp, #0xc0]
0x000416a4  add      x29, sp, #0xc0
0x000416a8  mov      x20, x0
0x000416ac  adrp     x8, #0x8e000
0x000416b0  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x000416b4  bl       #0x565c0   ; CALL objc_msgSend$array
0x000416b8  mov      x29, x29
0x000416bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000416c0  mov      x19, x0
0x000416c4  ldr      x21, [x20, #0x20]
0x000416c8  adrp     x22, #0x74000
0x000416cc  ldr      x22, [x22, #0x378]   ; @GOT __NSConcreteStackBlock
0x000416d0  str      x22, [sp, #0x50]
0x000416d4  adrp     x8, #0x65000
0x000416d8  ldr      d8, [x8, #0x600]
0x000416dc  str      d8, [sp, #0x58]
0x000416e0  adrp     x8, #0x41000
0x000416e4  add      x8, x8, #0x7e0
0x000416e8  adrp     x9, #0x74000
0x000416ec  add      x9, x9, #0xd38
0x000416f0  stp      x8, x9, [sp, #0x60]
0x000416f4  mov      x0, x21
0x000416f8  bl       #0x55d84   ; CALL _objc_retain
0x000416fc  str      x21, [sp, #0x70]
0x00041700  ldr      x0, [x20, #0x30]
0x00041704  ldur     q0, [x20, #0x28]
0x00041708  str      q0, [sp]
0x0004170c  bl       #0x55d84   ; CALL _objc_retain
0x00041710  ldr      q0, [sp]
0x00041714  stur     q0, [sp, #0x78]
0x00041718  mov      x0, x19
0x0004171c  bl       #0x55d84   ; CALL _objc_retain
0x00041720  str      x19, [sp, #0x88]
0x00041724  add      x2, sp, #0x50
0x00041728  mov      x0, x21
0x0004172c  bl       #0x57a00   ; CALL objc_msgSend$enumerateObjectsUsingBlock:
0x00041730  str      x22, [sp, #0x10]
0x00041734  str      d8, [sp, #0x18]
0x00041738  adrp     x8, #0x41000
0x0004173c  add      x8, x8, #0xab8
0x00041740  adrp     x9, #0x74000
0x00041744  add      x9, x9, #0xd98
0x00041748  stp      x8, x9, [sp, #0x20]
0x0004174c  ldr      x0, [x20, #0x30]
0x00041750  ldur     q0, [x20, #0x28]
0x00041754  str      q0, [sp]
0x00041758  bl       #0x55d84   ; CALL _objc_retain
0x0004175c  ldr      q0, [sp]
0x00041760  str      q0, [sp, #0x30]
0x00041764  str      x19, [sp, #0x40]
0x00041768  ldr      x20, [x20, #0x38]
0x0004176c  mov      x0, x20
0x00041770  bl       #0x55d84   ; CALL _objc_retain
0x00041774  str      x20, [sp, #0x48]
0x00041778  mov      x0, x19
0x0004177c  bl       #0x55d84   ; CALL _objc_retain
0x00041780  adrp     x0, #0x74000
0x00041784  ldr      x0, [x0, #0x3a0]   ; @GOT __dispatch_main_q
0x00041788  add      x1, sp, #0x10
0x0004178c  bl       #0x55be0   ; CALL _dispatch_async
0x00041790  ldr      x0, [sp, #0x48]
0x00041794  bl       #0x55d78   ; CALL _objc_release
0x00041798  ldr      x0, [sp, #0x40]
0x0004179c  bl       #0x55d78   ; CALL _objc_release
0x000417a0  ldr      x0, [sp, #0x38]
0x000417a4  bl       #0x55d78   ; CALL _objc_release
0x000417a8  ldr      x0, [sp, #0x88]
0x000417ac  bl       #0x55d78   ; CALL _objc_release
0x000417b0  ldr      x0, [sp, #0x80]
0x000417b4  bl       #0x55d78   ; CALL _objc_release
0x000417b8  ldr      x0, [sp, #0x70]
0x000417bc  bl       #0x55d78   ; CALL _objc_release
0x000417c0  mov      x0, x19
0x000417c4  bl       #0x55d78   ; CALL _objc_release
0x000417c8  ldp      x29, x30, [sp, #0xc0]
0x000417cc  ldp      x20, x19, [sp, #0xb0]
0x000417d0  ldp      x22, x21, [sp, #0xa0]
0x000417d4  ldp      d9, d8, [sp, #0x90]
0x000417d8  add      sp, sp, #0xd0
0x000417dc  ret      
0x000417e0  sub      sp, sp, #0x90
0x000417e4  stp      x24, x23, [sp, #0x50]
0x000417e8  stp      x22, x21, [sp, #0x60]
0x000417ec  stp      x20, x19, [sp, #0x70]
0x000417f0  stp      x29, x30, [sp, #0x80]
0x000417f4  add      x29, sp, #0x80
0x000417f8  mov      x20, x2
0x000417fc  mov      x19, x1
0x00041800  mov      x21, x0
0x00041804  mov      x0, x1
0x00041808  bl       #0x55d84   ; CALL _objc_retain
0x0004180c  ldr      x0, [x21, #0x20]
0x00041810  bl       #0x573c0   ; CALL objc_msgSend$count
0x00041814  adrp     x24, #0x8e000
0x00041818  cmp      x0, #2
0x0004181c  b.lo     #0x41854
0x00041820  ldr      x22, [x24, #0x958]   ; @CLASS NSString
0x00041824  add      x20, x20, #1
0x00041828  ldr      x0, [x21, #0x20]
0x0004182c  bl       #0x573c0   ; CALL objc_msgSend$count
0x00041830  stp      x20, x0, [sp]
0x00041834  adrp     x2, #0x7c000
0x00041838  add      x2, x2, #0x968   ; STR " (%lu/%lu)"
0x0004183c  mov      x0, x22
0x00041840  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00041844  mov      x29, x29
0x00041848  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004184c  mov      x20, x0
0x00041850  b        #0x4185c
0x00041854  adrp     x20, #0x75000
0x00041858  add      x20, x20, #0xd28
0x0004185c  stur     xzr, [x29, #-0x38]
0x00041860  adrp     x8, #0x74000
0x00041864  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00041868  str      x8, [sp, #0x18]
0x0004186c  adrp     x8, #0x65000
0x00041870  ldr      d0, [x8, #0x600]
0x00041874  str      d0, [sp, #0x20]
0x00041878  adrp     x8, #0x41000
0x0004187c  add      x8, x8, #0x978
0x00041880  adrp     x9, #0x74000
0x00041884  add      x9, x9, #0xd08
0x00041888  stp      x8, x9, [sp, #0x28]
0x0004188c  ldp      x22, x23, [x21, #0x28]
0x00041890  mov      x0, x23
0x00041894  bl       #0x55d84   ; CALL _objc_retain
0x00041898  str      x23, [sp, #0x38]
0x0004189c  mov      x0, x20
0x000418a0  bl       #0x55d84   ; CALL _objc_retain
0x000418a4  str      x20, [sp, #0x40]
0x000418a8  sub      x3, x29, #0x38
0x000418ac  add      x4, sp, #0x18
0x000418b0  mov      x0, x22
0x000418b4  mov      x2, x19
0x000418b8  bl       #0x57ac0   ; CALL objc_msgSend$extractFramesForVideo:error:progress:
0x000418bc  mov      x23, x0
0x000418c0  ldur     x22, [x29, #-0x38]
0x000418c4  mov      x0, x22
0x000418c8  bl       #0x55d84   ; CALL _objc_retain
0x000418cc  tbnz     w23, #0, #0x41938
0x000418d0  ldr      x21, [x21, #0x38]
0x000418d4  ldr      x23, [x24, #0x958]   ; @CLASS NSString
0x000418d8  mov      x0, x22
0x000418dc  bl       #0x58dc0   ; CALL objc_msgSend$localizedDescription
0x000418e0  mov      x29, x29
0x000418e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000418e8  mov      x24, x0
0x000418ec  adrp     x8, #0x75000
0x000418f0  add      x8, x8, #0x868   ; STR "?"
0x000418f4  cmp      x0, #0
0x000418f8  csel     x8, x8, x0, eq
0x000418fc  stp      x19, x8, [sp]
0x00041900  adrp     x2, #0x7c000
0x00041904  add      x2, x2, #0x9a8   ; STR "%@: %@"
0x00041908  mov      x0, x23
0x0004190c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00041910  mov      x29, x29
0x00041914  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041918  mov      x23, x0
0x0004191c  mov      x0, x21
0x00041920  mov      x2, x23
0x00041924  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00041928  mov      x0, x23
0x0004192c  bl       #0x55d78   ; CALL _objc_release
0x00041930  mov      x0, x24
0x00041934  bl       #0x55d78   ; CALL _objc_release
0x00041938  ldr      x0, [sp, #0x40]
0x0004193c  bl       #0x55d78   ; CALL _objc_release
0x00041940  ldr      x0, [sp, #0x38]
0x00041944  bl       #0x55d78   ; CALL _objc_release
0x00041948  mov      x0, x22
0x0004194c  bl       #0x55d78   ; CALL _objc_release
0x00041950  mov      x0, x20
0x00041954  bl       #0x55d78   ; CALL _objc_release
0x00041958  mov      x0, x19
0x0004195c  bl       #0x55d78   ; CALL _objc_release
0x00041960  ldp      x29, x30, [sp, #0x80]
0x00041964  ldp      x20, x19, [sp, #0x70]
0x00041968  ldp      x22, x21, [sp, #0x60]
0x0004196c  ldp      x24, x23, [sp, #0x50]
0x00041970  add      sp, sp, #0x90
0x00041974  ret      
0x00041978  sub      sp, sp, #0x70
0x0004197c  stp      d9, d8, [sp, #0x40]
0x00041980  stp      x20, x19, [sp, #0x50]
0x00041984  stp      x29, x30, [sp, #0x60]
0x00041988  add      x29, sp, #0x60
0x0004198c  mov      v8.16b, v0.16b
0x00041990  mov      x19, x0
0x00041994  adrp     x8, #0x74000
0x00041998  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x0004199c  str      x8, [sp, #8]
0x000419a0  adrp     x8, #0x65000
0x000419a4  ldr      d0, [x8, #0x600]
0x000419a8  adrp     x8, #0x41000
0x000419ac  add      x8, x8, #0xa18
0x000419b0  str      d0, [sp, #0x10]
0x000419b4  adrp     x9, #0x74000
0x000419b8  add      x9, x9, #0xcd8
0x000419bc  stp      x8, x9, [sp, #0x18]
0x000419c0  ldr      x20, [x0, #0x20]   ; @GOT _objc_autoreleasePoolPop
0x000419c4  mov      x0, x20
0x000419c8  bl       #0x55d84   ; CALL _objc_retain
0x000419cc  str      x20, [sp, #0x28]
0x000419d0  ldr      x19, [x19, #0x28]
0x000419d4  mov      x0, x19
0x000419d8  bl       #0x55d84   ; CALL _objc_retain
0x000419dc  str      x19, [sp, #0x30]
0x000419e0  str      d8, [sp, #0x38]
0x000419e4  adrp     x0, #0x74000
0x000419e8  ldr      x0, [x0, #0x3a0]   ; @GOT __dispatch_main_q
0x000419ec  add      x1, sp, #8
0x000419f0  bl       #0x55be0   ; CALL _dispatch_async
0x000419f4  ldr      x0, [sp, #0x30]
0x000419f8  bl       #0x55d78   ; CALL _objc_release
0x000419fc  ldr      x0, [sp, #0x28]
0x00041a00  bl       #0x55d78   ; CALL _objc_release
0x00041a04  ldp      x29, x30, [sp, #0x60]
0x00041a08  ldp      x20, x19, [sp, #0x50]
0x00041a0c  ldp      d9, d8, [sp, #0x40]
0x00041a10  add      sp, sp, #0x70
0x00041a14  ret      
0x00041a18  sub      sp, sp, #0x50
0x00041a1c  stp      x22, x21, [sp, #0x20]
0x00041a20  stp      x20, x19, [sp, #0x30]
0x00041a24  stp      x29, x30, [sp, #0x40]
0x00041a28  add      x29, sp, #0x40
0x00041a2c  mov      x19, x0
0x00041a30  adrp     x8, #0x8e000
0x00041a34  ldr      x20, [x8, #0x958]   ; @CLASS NSString
0x00041a38  adrp     x0, #0x7c000
0x00041a3c  add      x0, x0, #0x928   ; STR "STARTUPSCREEN_PREPARING"
0x00041a40  bl       #0x17e20   ; CALL _L
0x00041a44  mov      x29, x29
0x00041a48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041a4c  mov      x21, x0
0x00041a50  ldr      x8, [x19, #0x28]
0x00041a54  ldr      d0, [x19, #0x30]
0x00041a58  mov      x9, #0x4059000000000000
0x00041a5c  fmov     d1, x9
0x00041a60  fmul     d0, d0, d1
0x00041a64  fcvtzs   w9, d0
0x00041a68  stp      x0, x8, [sp]
0x00041a6c  str      x9, [sp, #0x10]
0x00041a70  adrp     x2, #0x7c000
0x00041a74  add      x2, x2, #0x988   ; STR "%@%@… %d%%"
0x00041a78  mov      x0, x20
0x00041a7c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00041a80  mov      x29, x29
0x00041a84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041a88  mov      x20, x0
0x00041a8c  ldr      x0, [x19, #0x20]
0x00041a90  mov      x2, x20
0x00041a94  bl       #0x5b5e0   ; CALL objc_msgSend$setMessage:
0x00041a98  mov      x0, x20
0x00041a9c  bl       #0x55d78   ; CALL _objc_release
0x00041aa0  mov      x0, x21
0x00041aa4  ldp      x29, x30, [sp, #0x40]
0x00041aa8  ldp      x20, x19, [sp, #0x30]
0x00041aac  ldp      x22, x21, [sp, #0x20]
0x00041ab0  add      sp, sp, #0x50
0x00041ab4  b        #0x55d78   ; CALL _objc_release
0x00041ab8  sub      sp, sp, #0x70
0x00041abc  stp      x22, x21, [sp, #0x40]
0x00041ac0  stp      x20, x19, [sp, #0x50]
0x00041ac4  stp      x29, x30, [sp, #0x60]
0x00041ac8  add      x29, sp, #0x60
0x00041acc  mov      x19, x0
0x00041ad0  ldr      x0, [x0, #0x20]   ; @STR "…"
0x00041ad4  mov      w2, #0
0x00041ad8  bl       #0x5ade0   ; CALL objc_msgSend$setExtracting:
0x00041adc  adrp     x8, #0x74000
0x00041ae0  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00041ae4  str      x8, [sp, #8]
0x00041ae8  adrp     x8, #0x65000
0x00041aec  ldr      d0, [x8, #0x600]
0x00041af0  str      d0, [sp, #0x10]
0x00041af4  adrp     x8, #0x41000
0x00041af8  add      x8, x8, #0xb60
0x00041afc  adrp     x9, #0x74000
0x00041b00  add      x9, x9, #0xd68
0x00041b04  stp      x8, x9, [sp, #0x18]
0x00041b08  ldp      x20, x21, [x19, #0x28]
0x00041b0c  mov      x0, x21
0x00041b10  bl       #0x55d84   ; CALL _objc_retain
0x00041b14  ldr      x8, [x19, #0x20]
0x00041b18  stp      x21, x8, [sp, #0x28]
0x00041b1c  ldr      x19, [x19, #0x38]
0x00041b20  mov      x0, x19
0x00041b24  bl       #0x55d84   ; CALL _objc_retain
0x00041b28  str      x19, [sp, #0x38]
0x00041b2c  add      x3, sp, #8
0x00041b30  mov      x0, x20
0x00041b34  mov      w2, #1
0x00041b38  bl       #0x57820   ; CALL objc_msgSend$dismissViewControllerAnimated:completion:
0x00041b3c  ldr      x0, [sp, #0x38]
0x00041b40  bl       #0x55d78   ; CALL _objc_release
0x00041b44  ldr      x0, [sp, #0x28]
0x00041b48  bl       #0x55d78   ; CALL _objc_release
0x00041b4c  ldp      x29, x30, [sp, #0x60]
0x00041b50  ldp      x20, x19, [sp, #0x50]
0x00041b54  ldp      x22, x21, [sp, #0x40]
0x00041b58  add      sp, sp, #0x70
0x00041b5c  ret      
0x00041b60  sub      sp, sp, #0x50
0x00041b64  stp      x24, x23, [sp, #0x10]
0x00041b68  stp      x22, x21, [sp, #0x20]
0x00041b6c  stp      x20, x19, [sp, #0x30]
0x00041b70  stp      x29, x30, [sp, #0x40]
0x00041b74  add      x29, sp, #0x40
0x00041b78  mov      x19, x0
0x00041b7c  ldr      x0, [x0, #0x20]   ; @STR "…"
0x00041b80  bl       #0x573c0   ; CALL objc_msgSend$count
0x00041b84  cbz      x0, #0x41c08
0x00041b88  ldr      x20, [x19, #0x28]
0x00041b8c  adrp     x8, #0x8e000
0x00041b90  ldr      x21, [x8, #0x958]   ; @CLASS NSString
0x00041b94  adrp     x0, #0x7c000
0x00041b98  add      x0, x0, #0x9c8   ; STR "STARTUPSCREEN_PROCESS_FAILED"
0x00041b9c  bl       #0x17e20   ; CALL _L
0x00041ba0  mov      x29, x29
0x00041ba4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041ba8  mov      x22, x0
0x00041bac  ldr      x0, [x19, #0x20]
0x00041bb0  adrp     x2, #0x75000
0x00041bb4  add      x2, x2, #0xbe8   ; STR "\n"
0x00041bb8  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x00041bbc  mov      x29, x29
0x00041bc0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041bc4  mov      x23, x0
0x00041bc8  str      x0, [sp]
0x00041bcc  mov      x0, x21
0x00041bd0  mov      x2, x22
0x00041bd4  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00041bd8  mov      x29, x29
0x00041bdc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041be0  mov      x21, x0
0x00041be4  mov      x0, x20
0x00041be8  mov      x2, x21
0x00041bec  bl       #0x5ca40   ; CALL objc_msgSend$showMessage:
0x00041bf0  mov      x0, x21
0x00041bf4  bl       #0x55d78   ; CALL _objc_release
0x00041bf8  mov      x0, x23
0x00041bfc  bl       #0x55d78   ; CALL _objc_release
0x00041c00  mov      x0, x22
0x00041c04  bl       #0x55d78   ; CALL _objc_release
0x00041c08  ldr      x0, [x19, #0x30]
0x00041c0c  cbz      x0, #0x41c2c
0x00041c10  ldr      x1, [x0, #0x10]
0x00041c14  ldp      x29, x30, [sp, #0x40]
0x00041c18  ldp      x20, x19, [sp, #0x30]
0x00041c1c  ldp      x22, x21, [sp, #0x20]
0x00041c20  ldp      x24, x23, [sp, #0x10]
0x00041c24  add      sp, sp, #0x50
0x00041c28  br       x1
0x00041c2c  ldp      x29, x30, [sp, #0x40]
0x00041c30  ldp      x20, x19, [sp, #0x30]
0x00041c34  ldp      x22, x21, [sp, #0x20]
0x00041c38  ldp      x24, x23, [sp, #0x10]
0x00041c3c  add      sp, sp, #0x50
0x00041c40  ret      

=== -[OMCStartupScreenController extractFramesForVideo:error:progress:]  va=0x41cc4 size=2196 types=B40@0:8@16^@24@?32
0x00041cc4  stp      d15, d14, [sp, #-0xa0]!
0x00041cc8  stp      d13, d12, [sp, #0x10]
0x00041ccc  stp      d11, d10, [sp, #0x20]
0x00041cd0  stp      d9, d8, [sp, #0x30]
0x00041cd4  stp      x28, x27, [sp, #0x40]
0x00041cd8  stp      x26, x25, [sp, #0x50]
0x00041cdc  stp      x24, x23, [sp, #0x60]
0x00041ce0  stp      x22, x21, [sp, #0x70]
0x00041ce4  stp      x20, x19, [sp, #0x80]
0x00041ce8  stp      x29, x30, [sp, #0x90]
0x00041cec  add      x29, sp, #0x90
0x00041cf0  sub      sp, sp, #0x520
0x00041cf4  mov      x26, x4
0x00041cf8  mov      x24, x3
0x00041cfc  mov      x19, x2
0x00041d00  mov      x25, x0
0x00041d04  adrp     x8, #0x74000
0x00041d08  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00041d0c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00041d10  stur     x8, [x29, #-0xa0]
0x00041d14  mov      x0, x2
0x00041d18  bl       #0x55d84   ; CALL _objc_retain
0x00041d1c  mov      x0, x26
0x00041d20  bl       #0x55d84   ; CALL _objc_retain
0x00041d24  adrp     x8, #0x8e000
0x00041d28  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x00041d2c  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x00041d30  mov      x29, x29
0x00041d34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041d38  mov      x21, x0
0x00041d3c  adrp     x0, #0x76000
0x00041d40  add      x0, x0, #0xb68   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Videos"
0x00041d44  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00041d48  add      x1, sp, #0x110
0x00041d4c  bl       #0x4118
0x00041d50  cbz      x0, #0x41d74
0x00041d54  mov      x2, x0
0x00041d58  adrp     x8, #0x8e000
0x00041d5c  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00041d60  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00041d64  mov      x29, x29
0x00041d68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041d6c  mov      x20, x0
0x00041d70  b        #0x41d78
0x00041d74  mov      x20, #0
0x00041d78  adrp     x2, #0x76000
0x00041d7c  add      x2, x2, #0xb88   ; STR ".frames"
0x00041d80  mov      x0, x20
0x00041d84  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00041d88  mov      x29, x29
0x00041d8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041d90  mov      x23, x0
0x00041d94  mov      x2, x19
0x00041d98  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00041d9c  mov      x29, x29
0x00041da0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041da4  mov      x22, x0
0x00041da8  mov      x0, x23
0x00041dac  bl       #0x55d78   ; CALL _objc_release
0x00041db0  mov      x0, x20
0x00041db4  bl       #0x55d78   ; CALL _objc_release
0x00041db8  mov      x0, x21
0x00041dbc  mov      x2, x22
0x00041dc0  mov      x3, #0
0x00041dc4  bl       #0x59e20   ; CALL objc_msgSend$removeItemAtPath:error:
0x00041dc8  mov      x0, x21
0x00041dcc  mov      x2, x22
0x00041dd0  mov      w3, #1
0x00041dd4  mov      x4, #0
0x00041dd8  mov      x5, x24
0x00041ddc  bl       #0x57400   ; CALL objc_msgSend$createDirectoryAtPath:withIntermediateDirectories:attributes:error:
0x00041de0  cbz      w0, #0x41e34
0x00041de4  str      x25, [sp, #0x38]
0x00041de8  str      x24, [sp, #0x50]
0x00041dec  adrp     x8, #0x8e000
0x00041df0  ldr      x23, [x8, #0xb60]   ; @CLASS AVURLAsset
0x00041df4  adrp     x8, #0x8e000
0x00041df8  ldr      x24, [x8, #0xa10]   ; @CLASS NSURL
0x00041dfc  adrp     x0, #0x76000
0x00041e00  add      x0, x0, #0xb68   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Videos"
0x00041e04  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00041e08  add      x1, sp, #0x110
0x00041e0c  bl       #0x4118
0x00041e10  cbz      x0, #0x41e3c
0x00041e14  mov      x2, x0
0x00041e18  adrp     x8, #0x8e000
0x00041e1c  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00041e20  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00041e24  mov      x29, x29
0x00041e28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041e2c  mov      x25, x0
0x00041e30  b        #0x41e40
0x00041e34  mov      w23, #0
0x00041e38  b        #0x424e8
0x00041e3c  mov      x25, #0
0x00041e40  mov      x0, x25
0x00041e44  mov      x2, x19
0x00041e48  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00041e4c  mov      x29, x29
0x00041e50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041e54  mov      x20, x0
0x00041e58  mov      x0, x24
0x00041e5c  mov      x2, x20
0x00041e60  bl       #0x57ba0   ; CALL objc_msgSend$fileURLWithPath:
0x00041e64  mov      x29, x29
0x00041e68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041e6c  mov      x24, x0
0x00041e70  mov      x0, x23
0x00041e74  mov      x2, x24
0x00041e78  mov      x3, #0
0x00041e7c  bl       #0x55f40   ; CALL objc_msgSend$URLAssetWithURL:options:
0x00041e80  mov      x29, x29
0x00041e84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041e88  mov      x23, x0
0x00041e8c  mov      x0, x24
0x00041e90  bl       #0x55d78   ; CALL _objc_release
0x00041e94  mov      x0, x20
0x00041e98  bl       #0x55d78   ; CALL _objc_release
0x00041e9c  mov      x0, x25
0x00041ea0  mov      x24, x23
0x00041ea4  bl       #0x55d78   ; CALL _objc_release
0x00041ea8  adrp     x8, #0x74000
0x00041eac  ldr      x8, [x8, #0x300]   ; @GOT _AVMediaTypeVideo
0x00041eb0  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x00041eb4  mov      x0, x23
0x00041eb8  bl       #0x5dc20   ; CALL objc_msgSend$tracksWithMediaType:
0x00041ebc  mov      x29, x29
0x00041ec0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041ec4  mov      x20, x0
0x00041ec8  bl       #0x57c20   ; CALL objc_msgSend$firstObject
0x00041ecc  mov      x29, x29
0x00041ed0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041ed4  mov      x25, x0
0x00041ed8  mov      x0, x20
0x00041edc  bl       #0x55d78   ; CALL _objc_release
0x00041ee0  ldr      x20, [sp, #0x50]
0x00041ee4  cbz      x25, #0x41f94
0x00041ee8  adrp     x8, #0x8e000
0x00041eec  ldr      x0, [x8, #0xc70]   ; @CLASS AVAssetReader
0x00041ef0  mov      x2, x24
0x00041ef4  mov      x3, x20
0x00041ef8  bl       #0x566c0   ; CALL objc_msgSend$assetReaderWithAsset:error:
0x00041efc  mov      x29, x29
0x00041f00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041f04  cbz      x0, #0x41f94
0x00041f08  mov      x27, x0
0x00041f0c  str      x19, [sp, #0x30]
0x00041f10  adrp     x8, #0x74000
0x00041f14  ldr      x8, [x8, #0x358]   ; @GOT _kCVPixelBufferPixelFormatTypeKey
0x00041f18  ldr      x9, [x8]   ; @GOT ___objc_personality_v0
0x00041f1c  adrp     x8, #0x80000
0x00041f20  add      x8, x8, #0x418
0x00041f24  stp      x9, x8, [sp, #0x100]
0x00041f28  adrp     x8, #0x8e000
0x00041f2c  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00041f30  add      x2, sp, #0x108
0x00041f34  add      x3, sp, #0x100
0x00041f38  mov      w4, #1
0x00041f3c  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00041f40  mov      x29, x29
0x00041f44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041f48  mov      x3, x0
0x00041f4c  adrp     x8, #0x8e000
0x00041f50  ldr      x0, [x8, #0xc78]   ; @CLASS AVAssetReaderTrackOutput
0x00041f54  mov      x2, x25
0x00041f58  str      x3, [sp, #0x28]
0x00041f5c  bl       #0x566a0   ; CALL objc_msgSend$assetReaderTrackOutputWithTrack:outputSettings:
0x00041f60  mov      x29, x29
0x00041f64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00041f68  mov      x19, x0
0x00041f6c  mov      w2, #0
0x00041f70  bl       #0x5a420   ; CALL objc_msgSend$setAlwaysCopiesSampleData:
0x00041f74  mov      x0, x27
0x00041f78  mov      x2, x19
0x00041f7c  bl       #0x56180   ; CALL objc_msgSend$addOutput:
0x00041f80  cbz      x24, #0x41fac
0x00041f84  add      x8, sp, #0x110
0x00041f88  mov      x0, x24
0x00041f8c  bl       #0x57920   ; CALL objc_msgSend$duration
0x00041f90  b        #0x41fb4
0x00041f94  mov      x0, x21
0x00041f98  mov      x2, x22
0x00041f9c  mov      x3, #0
0x00041fa0  bl       #0x59e20   ; CALL objc_msgSend$removeItemAtPath:error:
0x00041fa4  mov      w23, #0
0x00041fa8  b        #0x424d8
0x00041fac  stp      xzr, xzr, [sp, #0x110]
0x00041fb0  str      xzr, [sp, #0x120]
0x00041fb4  add      x0, sp, #0x110
0x00041fb8  bl       #0x55ac0   ; CALL _CMTimeGetSeconds
0x00041fbc  mov      x8, #0x404e000000000000
0x00041fc0  fmov     d1, x8
0x00041fc4  fminnm   d8, d0, d1
0x00041fc8  add      x8, sp, #0x110
0x00041fcc  mov      v0.16b, v8.16b
0x00041fd0  mov      w0, #0x258
0x00041fd4  bl       #0x55acc   ; CALL _CMTimeMakeWithSeconds
0x00041fd8  adrp     x8, #0x74000
0x00041fdc  ldr      x8, [x8, #0x350]   ; @GOT _kCMTimeZero
0x00041fe0  ldr      q0, [x8]   ; @GOT ___objc_personality_v0
0x00041fe4  str      q0, [sp, #0x70]
0x00041fe8  ldr      x8, [x8, #0x10]   ; @GOT _objc_alloc_init
0x00041fec  str      x8, [sp, #0x80]
0x00041ff0  add      x8, sp, #0x90
0x00041ff4  add      x0, sp, #0x70
0x00041ff8  add      x1, sp, #0x110
0x00041ffc  bl       #0x55ae4   ; CALL _CMTimeRangeMake
0x00042000  ldp      q0, q1, [sp, #0x90]
0x00042004  stp      q0, q1, [sp, #0x110]
0x00042008  ldr      q0, [sp, #0xb0]
0x0004200c  str      q0, [sp, #0x130]
0x00042010  add      x2, sp, #0x110
0x00042014  mov      x0, x27
0x00042018  bl       #0x5c560   ; CALL objc_msgSend$setTimeRange:
0x0004201c  mov      x0, x27
0x00042020  bl       #0x5d2e0   ; CALL objc_msgSend$startReading
0x00042024  tbz      w0, #0, #0x420a8
0x00042028  adrp     x8, #0x8e000
0x0004202c  ldr      x0, [x8, #0xc80]   ; @CLASS CIContext
0x00042030  mov      x2, #0
0x00042034  bl       #0x572c0   ; CALL objc_msgSend$contextWithOptions:
0x00042038  mov      x29, x29
0x0004203c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042040  str      x0, [sp, #0x68]
0x00042044  adrp     x8, #0x74000
0x00042048  ldr      x8, [x8, #0x620]   ; @GOT _kCGColorSpaceSRGB
0x0004204c  ldr      x0, [x8]   ; @GOT ___objc_personality_v0
0x00042050  bl       #0x558e0   ; CALL _CGColorSpaceCreateWithName
0x00042054  str      x0, [sp, #0x58]
0x00042058  add      x8, sp, #0x110
0x0004205c  mov      x0, x25
0x00042060  bl       #0x59960   ; CALL objc_msgSend$preferredTransform
0x00042064  ldr      d0, [sp, #0x110]
0x00042068  fcmp     d0, #0.0
0x0004206c  str      x26, [sp, #0x40]
0x00042070  str      x27, [sp, #0x10]
0x00042074  b.ne     #0x420dc
0x00042078  ldp      d3, d2, [sp, #0x118]
0x0004207c  ldr      d1, [sp, #0x128]
0x00042080  fmov     d4, #1.00000000
0x00042084  fcmp     d3, d4
0x00042088  b.ne     #0x420f8
0x0004208c  fmov     d4, #-1.00000000
0x00042090  fcmp     d2, d4
0x00042094  b.ne     #0x420f8
0x00042098  fcmp     d1, #0.0
0x0004209c  b.ne     #0x420f8
0x000420a0  mov      w8, #6
0x000420a4  b        #0x4211c
0x000420a8  cbz      x20, #0x420c4
0x000420ac  mov      x0, x27
0x000420b0  bl       #0x57a20   ; CALL objc_msgSend$error
0x000420b4  mov      x29, x29
0x000420b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000420bc  bl       #0x55c94   ; CALL _objc_autorelease
0x000420c0  str      x0, [x20]
0x000420c4  mov      x0, x21
0x000420c8  mov      x2, x22
0x000420cc  mov      x3, #0
0x000420d0  bl       #0x59e20   ; CALL objc_msgSend$removeItemAtPath:error:
0x000420d4  mov      w23, #0
0x000420d8  b        #0x424bc
0x000420dc  ldr      d1, [sp, #0x128]
0x000420e0  fmov     d2, #-1.00000000
0x000420e4  fcmp     d1, d2
0x000420e8  fccmp    d0, d2, #0, eq
0x000420ec  mov      w8, #3
0x000420f0  csinc    w8, w8, wzr, eq
0x000420f4  b        #0x4211c
0x000420f8  fmov     d4, #-1.00000000
0x000420fc  fcmp     d3, d4
0x00042100  b.ne     #0x420e0
0x00042104  fmov     d3, #1.00000000
0x00042108  fcmp     d2, d3
0x0004210c  b.ne     #0x420e0
0x00042110  fcmp     d1, #0.0
0x00042114  b.ne     #0x420e0
0x00042118  mov      w8, #8
0x0004211c  str      w8, [sp, #0x4c]
0x00042120  stp      x25, x24, [sp, #0x18]
0x00042124  adrp     x8, #0x74000
0x00042128  ldr      x8, [x8, #0x360]   ; @GOT _kCGImageDestinationLossyCompressionQuality
0x0004212c  ldr      x9, [x8]   ; @GOT ___objc_personality_v0
0x00042130  adrp     x8, #0x80000
0x00042134  add      x8, x8, #0x728
0x00042138  stp      x9, x8, [sp, #0xf0]
0x0004213c  adrp     x8, #0x8e000
0x00042140  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00042144  add      x2, sp, #0xf8
0x00042148  add      x3, sp, #0xf0
0x0004214c  mov      w4, #1
0x00042150  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00042154  mov      x29, x29
0x00042158  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004215c  str      x0, [sp, #0x60]
0x00042160  mov      x0, x19
0x00042164  bl       #0x57340   ; CALL objc_msgSend$copyNextSampleBuffer
0x00042168  cbz      x0, #0x42330
0x0004216c  mov      x26, x0
0x00042170  mov      x25, #0
0x00042174  fmov     d11, xzr
0x00042178  adrp     x8, #0x65000
0x0004217c  ldr      d12, [x8, #0xea0]
0x00042180  fmov     d13, #1.00000000
0x00042184  adrp     x8, #0x65000
0x00042188  ldr      d14, [x8, #0xea8]
0x0004218c  bl       #0x55cac   ; CALL _objc_autoreleasePoolPush
0x00042190  mov      x23, x0
0x00042194  add      x8, sp, #0x110
0x00042198  mov      x0, x26
0x0004219c  bl       #0x55ab4   ; CALL _CMSampleBufferGetPresentationTimeStamp
0x000421a0  add      x0, sp, #0x110
0x000421a4  bl       #0x55ac0   ; CALL _CMTimeGetSeconds
0x000421a8  mov      v9.16b, v0.16b
0x000421ac  mov      x0, x26
0x000421b0  bl       #0x55aa8   ; CALL _CMSampleBufferGetImageBuffer
0x000421b4  cbz      x0, #0x4230c
0x000421b8  fadd     d0, d9, d12
0x000421bc  fcmp     d0, d11
0x000421c0  b.lt     #0x4230c
0x000421c4  mov      x2, x0
0x000421c8  adrp     x8, #0x8e000
0x000421cc  ldr      x0, [x8, #0xc88]   ; @CLASS CIImage
0x000421d0  bl       #0x58180   ; CALL objc_msgSend$imageWithCVPixelBuffer:
0x000421d4  mov      x29, x29
0x000421d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000421dc  mov      x20, x0
0x000421e0  ldr      w2, [sp, #0x4c]
0x000421e4  bl       #0x580a0   ; CALL objc_msgSend$imageByApplyingCGOrientation:
0x000421e8  mov      x29, x29
0x000421ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000421f0  mov      x24, x0
0x000421f4  mov      x0, x20
0x000421f8  bl       #0x55d78   ; CALL _objc_release
0x000421fc  mov      x0, x24
0x00042200  bl       #0x57a80   ; CALL objc_msgSend$extent
0x00042204  mov      v10.16b, v2.16b
0x00042208  mov      x0, x24
0x0004220c  bl       #0x57a80   ; CALL objc_msgSend$extent
0x00042210  fcmp     d10, d3
0x00042214  fcsel    d0, d3, d10, mi
0x00042218  mov      x8, #0x409e000000000000
0x0004221c  fmov     d1, x8
0x00042220  fdiv     d0, d1, d0
0x00042224  fcmp     d0, d13
0x00042228  fcsel    d0, d13, d0, gt
0x0004222c  add      x8, sp, #0x110
0x00042230  mov      v1.16b, v0.16b
0x00042234  bl       #0x5588c   ; CALL _CGAffineTransformMakeScale
0x00042238  add      x2, sp, #0x110
0x0004223c  mov      x0, x24
0x00042240  bl       #0x580c0   ; CALL objc_msgSend$imageByApplyingTransform:
0x00042244  mov      x29, x29
0x00042248  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004224c  mov      x27, x0
0x00042250  mov      x0, x24
0x00042254  bl       #0x55d78   ; CALL _objc_release
0x00042258  ldp      x4, x0, [sp, #0x60]
0x0004225c  mov      x2, x27
0x00042260  ldr      x3, [sp, #0x58]
0x00042264  bl       #0x55f20   ; CALL objc_msgSend$JPEGRepresentationOfImage:colorSpace:options:
0x00042268  mov      x29, x29
0x0004226c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042270  mov      x24, x0
0x00042274  adrp     x8, #0x8e000
0x00042278  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0004227c  str      x25, [sp]
0x00042280  adrp     x2, #0x7c000
0x00042284  add      x2, x2, #0x9e8   ; STR "%05lu.jpg"
0x00042288  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0004228c  mov      x29, x29
0x00042290  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042294  mov      x28, x0
0x00042298  mov      x0, x22
0x0004229c  mov      x2, x28
0x000422a0  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x000422a4  mov      x29, x29
0x000422a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000422ac  mov      x20, x0
0x000422b0  mov      x0, x28
0x000422b4  bl       #0x55d78   ; CALL _objc_release
0x000422b8  mov      x0, x24
0x000422bc  mov      x2, x20
0x000422c0  mov      w3, #0
0x000422c4  bl       #0x5e220   ; CALL objc_msgSend$writeToFile:atomically:
0x000422c8  mov      x28, x0
0x000422cc  fcmp     d8, #0.0
0x000422d0  b.le     #0x422ec
0x000422d4  fdiv     d0, d9, d8
0x000422d8  fcmp     d0, d13
0x000422dc  fcsel    d0, d13, d0, gt
0x000422e0  ldr      x0, [sp, #0x40]
0x000422e4  ldr      x8, [x0, #0x10]
0x000422e8  blr      x8
0x000422ec  add      x25, x25, w28, uxtw
0x000422f0  fadd     d11, d11, d14
0x000422f4  mov      x0, x20
0x000422f8  bl       #0x55d78   ; CALL _objc_release
0x000422fc  mov      x0, x24
0x00042300  bl       #0x55d78   ; CALL _objc_release
0x00042304  mov      x0, x27
0x00042308  bl       #0x55d78   ; CALL _objc_release
0x0004230c  mov      x0, x26
0x00042310  bl       #0x55880   ; CALL _CFRelease
0x00042314  mov      x0, x23
0x00042318  bl       #0x55ca0   ; CALL _objc_autoreleasePoolPop
0x0004231c  mov      x0, x19
0x00042320  bl       #0x57340   ; CALL objc_msgSend$copyNextSampleBuffer
0x00042324  mov      x26, x0
0x00042328  cbnz     x0, #0x4218c
0x0004232c  b        #0x42334
0x00042330  mov      x25, #0
0x00042334  ldr      x0, [sp, #0x58]
0x00042338  bl       #0x558ec   ; CALL _CGColorSpaceRelease
0x0004233c  ldr      x27, [sp, #0x10]
0x00042340  mov      x0, x27
0x00042344  bl       #0x5d320   ; CALL objc_msgSend$status
0x00042348  cmp      x0, #3
0x0004234c  b.eq     #0x42470
0x00042350  cbz      x25, #0x42470
0x00042354  ldr      x0, [sp, #0x38]
0x00042358  ldr      x2, [sp, #0x20]
0x0004235c  mov      v0.16b, v8.16b
0x00042360  mov      x3, x22
0x00042364  bl       #0x57aa0   ; CALL objc_msgSend$extractAudioFromAsset:seconds:toDir:
0x00042368  ldr      x26, [sp, #0x40]
0x0004236c  tbnz     w0, #0, #0x42384
0x00042370  ldr      x8, [sp, #0x30]
0x00042374  str      x8, [sp]
0x00042378  adrp     x0, #0x7c000
0x0004237c  add      x0, x0, #0xa08   ; STR "[OmniCar/StartupScreen] audio export failed for %@"
0x00042380  bl       #0x55afc   ; CALL _NSLog
0x00042384  adrp     x8, #0x76000
0x00042388  add      x8, x8, #0xc68   ; STR "fps"
0x0004238c  adrp     x9, #0x80000
0x00042390  add      x9, x9, #0x430
0x00042394  str      x9, [sp, #0xd8]
0x00042398  adrp     x9, #0x76000
0x0004239c  add      x9, x9, #0xc08   ; STR "count"
0x000423a0  stp      x8, x9, [sp, #0xc0]
0x000423a4  adrp     x8, #0x8e000
0x000423a8  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x000423ac  mov      x2, x25
0x000423b0  bl       #0x59360   ; CALL objc_msgSend$numberWithUnsignedInteger:
0x000423b4  mov      x29, x29
0x000423b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000423bc  mov      x20, x0
0x000423c0  adrp     x8, #0x77000
0x000423c4  add      x8, x8, #0x128   ; STR "version"
0x000423c8  str      x8, [sp, #0xd0]
0x000423cc  adrp     x8, #0x80000
0x000423d0  add      x8, x8, #0x448
0x000423d4  stp      x0, x8, [sp, #0xe0]
0x000423d8  adrp     x8, #0x8e000
0x000423dc  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x000423e0  add      x2, sp, #0xd8
0x000423e4  add      x3, sp, #0xc0
0x000423e8  mov      w4, #3
0x000423ec  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x000423f0  mov      x29, x29
0x000423f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000423f8  mov      x24, x0
0x000423fc  mov      x0, x20
0x00042400  bl       #0x55d78   ; CALL _objc_release
0x00042404  adrp     x8, #0x8e000
0x00042408  ldr      x20, [x8, #0xa10]   ; @CLASS NSURL
0x0004240c  adrp     x2, #0x76000
0x00042410  add      x2, x2, #0xba8   ; STR "info.plist"
0x00042414  mov      x0, x22
0x00042418  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x0004241c  mov      x29, x29
0x00042420  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042424  mov      x25, x0
0x00042428  mov      x0, x20
0x0004242c  mov      x2, x25
0x00042430  bl       #0x57ba0   ; CALL objc_msgSend$fileURLWithPath:
0x00042434  mov      x29, x29
0x00042438  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004243c  mov      x20, x0
0x00042440  mov      x0, x24
0x00042444  mov      x2, x20
0x00042448  ldr      x3, [sp, #0x50]
0x0004244c  bl       #0x5e280   ; CALL objc_msgSend$writeToURL:error:
0x00042450  mov      x23, x0
0x00042454  mov      x0, x20
0x00042458  bl       #0x55d78   ; CALL _objc_release
0x0004245c  mov      x0, x25
0x00042460  bl       #0x55d78   ; CALL _objc_release
0x00042464  mov      x0, x24
0x00042468  bl       #0x55d78   ; CALL _objc_release
0x0004246c  b        #0x424a8
0x00042470  ldr      x26, [sp, #0x40]
0x00042474  ldr      x20, [sp, #0x50]
0x00042478  cbz      x20, #0x42494
0x0004247c  mov      x0, x27
0x00042480  bl       #0x57a20   ; CALL objc_msgSend$error
0x00042484  mov      x29, x29
0x00042488  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004248c  bl       #0x55c94   ; CALL _objc_autorelease
0x00042490  str      x0, [x20]
0x00042494  mov      x0, x21
0x00042498  mov      x2, x22
0x0004249c  mov      x3, #0
0x000424a0  bl       #0x59e20   ; CALL objc_msgSend$removeItemAtPath:error:
0x000424a4  mov      w23, #0
0x000424a8  ldp      x25, x24, [sp, #0x18]
0x000424ac  ldr      x0, [sp, #0x60]
0x000424b0  bl       #0x55d78   ; CALL _objc_release
0x000424b4  ldr      x0, [sp, #0x68]
0x000424b8  bl       #0x55d78   ; CALL _objc_release
0x000424bc  mov      x0, x19
0x000424c0  bl       #0x55d78   ; CALL _objc_release
0x000424c4  ldr      x0, [sp, #0x28]
0x000424c8  bl       #0x55d78   ; CALL _objc_release
0x000424cc  mov      x0, x27
0x000424d0  bl       #0x55d78   ; CALL _objc_release
0x000424d4  ldr      x19, [sp, #0x30]
0x000424d8  mov      x0, x25
0x000424dc  bl       #0x55d78   ; CALL _objc_release
0x000424e0  mov      x0, x24
0x000424e4  bl       #0x55d78   ; CALL _objc_release
0x000424e8  mov      x0, x22
0x000424ec  bl       #0x55d78   ; CALL _objc_release
0x000424f0  mov      x0, x21
0x000424f4  bl       #0x55d78   ; CALL _objc_release
0x000424f8  mov      x0, x26
0x000424fc  bl       #0x55d78   ; CALL _objc_release
0x00042500  mov      x0, x19
0x00042504  bl       #0x55d78   ; CALL _objc_release
0x00042508  ldur     x8, [x29, #-0xa0]
0x0004250c  adrp     x9, #0x74000
0x00042510  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00042514  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00042518  cmp      x9, x8
0x0004251c  b.ne     #0x42554
0x00042520  mov      x0, x23
0x00042524  add      sp, sp, #0x520
0x00042528  ldp      x29, x30, [sp, #0x90]
0x0004252c  ldp      x20, x19, [sp, #0x80]
0x00042530  ldp      x22, x21, [sp, #0x70]
0x00042534  ldp      x24, x23, [sp, #0x60]
0x00042538  ldp      x26, x25, [sp, #0x50]
0x0004253c  ldp      x28, x27, [sp, #0x40]
0x00042540  ldp      d9, d8, [sp, #0x30]
0x00042544  ldp      d11, d10, [sp, #0x20]
0x00042548  ldp      d13, d12, [sp, #0x10]
0x0004254c  ldp      d15, d14, [sp], #0xa0
0x00042550  ret      
0x00042554  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController importFromPhotos]  va=0x42558 size=272 types=v16@0:8
0x00042558  sub      sp, sp, #0x40
0x0004255c  stp      x22, x21, [sp, #0x10]
0x00042560  stp      x20, x19, [sp, #0x20]
0x00042564  stp      x29, x30, [sp, #0x30]
0x00042568  add      x29, sp, #0x30
0x0004256c  mov      x19, x0
0x00042570  adrp     x8, #0x74000
0x00042574  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00042578  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0004257c  str      x8, [sp, #8]
0x00042580  mov      x2, #0
0x00042584  bl       #0x5bb80   ; CALL objc_msgSend$setPickKind:
0x00042588  adrp     x8, #0x8e000
0x0004258c  ldr      x0, [x8, #0xb50]   ; @CLASS UIImagePickerController
0x00042590  bl       #0x55d60   ; CALL _objc_opt_new
0x00042594  mov      x20, x0
0x00042598  mov      x2, #0
0x0004259c  bl       #0x5c200   ; CALL objc_msgSend$setSourceType:
0x000425a0  adrp     x8, #0x74000
0x000425a4  ldr      x8, [x8, #0x318]   ; @GOT _UTTypeMovie
0x000425a8  ldr      x0, [x8]   ; @GOT ___objc_personality_v0
0x000425ac  bl       #0x58060   ; CALL objc_msgSend$identifier
0x000425b0  mov      x29, x29
0x000425b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000425b8  mov      x21, x0
0x000425bc  str      x0, [sp]
0x000425c0  adrp     x8, #0x8e000
0x000425c4  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000425c8  mov      x2, sp
0x000425cc  mov      w3, #1
0x000425d0  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000425d4  mov      x29, x29
0x000425d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000425dc  mov      x22, x0
0x000425e0  mov      x0, x20
0x000425e4  mov      x2, x22
0x000425e8  bl       #0x5b5a0   ; CALL objc_msgSend$setMediaTypes:
0x000425ec  mov      x0, x22
0x000425f0  bl       #0x55d78   ; CALL _objc_release
0x000425f4  mov      x0, x21
0x000425f8  bl       #0x55d78   ; CALL _objc_release
0x000425fc  adrp     x8, #0x74000
0x00042600  ldr      x8, [x8, #0x2d8]   ; @GOT _AVAssetExportPresetPassthrough
0x00042604  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x00042608  mov      x0, x20
0x0004260c  bl       #0x5c800   ; CALL objc_msgSend$setVideoExportPreset:
0x00042610  mov      x0, x20
0x00042614  mov      x2, x19
0x00042618  bl       #0x5aca0   ; CALL objc_msgSend$setDelegate:
0x0004261c  mov      x0, x19
0x00042620  mov      x2, x20
0x00042624  mov      w3, #1
0x00042628  mov      x4, #0
0x0004262c  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x00042630  mov      x0, x20
0x00042634  bl       #0x55d78   ; CALL _objc_release
0x00042638  ldr      x8, [sp, #8]
0x0004263c  adrp     x9, #0x74000
0x00042640  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00042644  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00042648  cmp      x9, x8
0x0004264c  b.ne     #0x42664
0x00042650  ldp      x29, x30, [sp, #0x30]
0x00042654  ldp      x20, x19, [sp, #0x20]
0x00042658  ldp      x22, x21, [sp, #0x10]
0x0004265c  add      sp, sp, #0x40
0x00042660  ret      
0x00042664  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController imagePickerController:didFinishPickingMediaWithInfo:]  va=0x42668 size=752 types=v32@0:8@16@24
0x00042668  sub      sp, sp, #0xa0
0x0004266c  stp      x24, x23, [sp, #0x60]
0x00042670  stp      x22, x21, [sp, #0x70]
0x00042674  stp      x20, x19, [sp, #0x80]
0x00042678  stp      x29, x30, [sp, #0x90]
0x0004267c  add      x29, sp, #0x90
0x00042680  mov      x20, x3
0x00042684  mov      x19, x2
0x00042688  mov      x22, x0
0x0004268c  mov      x0, x2
0x00042690  bl       #0x55d84   ; CALL _objc_retain
0x00042694  mov      x0, x20
0x00042698  bl       #0x55d84   ; CALL _objc_retain
0x0004269c  mov      x0, x22
0x000426a0  bl       #0x596e0   ; CALL objc_msgSend$pickKind
0x000426a4  cmp      x0, #1
0x000426a8  b.ne     #0x42784
0x000426ac  adrp     x8, #0x74000
0x000426b0  ldr      x8, [x8, #0x290]   ; @GOT _UIImagePickerControllerImageURL
0x000426b4  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x000426b8  mov      x0, x20
0x000426bc  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000426c0  mov      x29, x29
0x000426c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000426c8  mov      x21, x0
0x000426cc  cbz      x0, #0x42710
0x000426d0  adrp     x8, #0x8e000
0x000426d4  ldr      x23, [x8, #0xa78]   ; @CLASS UIImage
0x000426d8  mov      x0, x21
0x000426dc  bl       #0x59600   ; CALL objc_msgSend$path
0x000426e0  mov      x29, x29
0x000426e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000426e8  mov      x24, x0
0x000426ec  mov      x0, x23
0x000426f0  mov      x2, x24
0x000426f4  bl       #0x581c0   ; CALL objc_msgSend$imageWithContentsOfFile:
0x000426f8  mov      x29, x29
0x000426fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042700  mov      x23, x0
0x00042704  mov      x0, x24
0x00042708  bl       #0x55d78   ; CALL _objc_release
0x0004270c  cbnz     x23, #0x42730
0x00042710  adrp     x8, #0x74000
0x00042714  ldr      x8, [x8, #0x2a0]   ; @GOT _UIImagePickerControllerOriginalImage
0x00042718  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0004271c  mov      x0, x20
0x00042720  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00042724  mov      x29, x29
0x00042728  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004272c  mov      x23, x0
0x00042730  adrp     x8, #0x74000
0x00042734  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00042738  str      x8, [sp, #0x30]
0x0004273c  adrp     x8, #0x65000
0x00042740  ldr      d0, [x8, #0x600]
0x00042744  str      d0, [sp, #0x38]
0x00042748  adrp     x8, #0x42000
0x0004274c  add      x8, x8, #0x824
0x00042750  adrp     x9, #0x74000
0x00042754  add      x9, x9, #0xdc8
0x00042758  stp      x8, x9, [sp, #0x40]
0x0004275c  stp      x22, x23, [sp, #0x50]
0x00042760  mov      x0, x23
0x00042764  bl       #0x55d84   ; CALL _objc_retain
0x00042768  add      x3, sp, #0x30
0x0004276c  mov      x0, x19
0x00042770  mov      w2, #1
0x00042774  bl       #0x57820   ; CALL objc_msgSend$dismissViewControllerAnimated:completion:
0x00042778  ldr      x0, [sp, #0x58]
0x0004277c  bl       #0x55d78   ; CALL _objc_release
0x00042780  b        #0x427ec
0x00042784  adrp     x8, #0x74000
0x00042788  ldr      x8, [x8, #0x298]   ; @GOT _UIImagePickerControllerMediaURL
0x0004278c  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x00042790  mov      x0, x20
0x00042794  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00042798  mov      x29, x29
0x0004279c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000427a0  mov      x21, x0
0x000427a4  adrp     x8, #0x74000
0x000427a8  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x000427ac  str      x8, [sp]
0x000427b0  adrp     x8, #0x65000
0x000427b4  ldr      d0, [x8, #0x600]
0x000427b8  str      d0, [sp, #8]
0x000427bc  adrp     x8, #0x42000
0x000427c0  add      x8, x8, #0x830
0x000427c4  adrp     x9, #0x74000
0x000427c8  add      x9, x9, #0xdc8
0x000427cc  stp      x8, x9, [sp, #0x10]
0x000427d0  stp      x0, x22, [sp, #0x20]
0x000427d4  bl       #0x55d84   ; CALL _objc_retain
0x000427d8  mov      x3, sp
0x000427dc  mov      x0, x19
0x000427e0  mov      w2, #1
0x000427e4  bl       #0x57820   ; CALL objc_msgSend$dismissViewControllerAnimated:completion:
0x000427e8  ldr      x23, [sp, #0x20]
0x000427ec  mov      x0, x23
0x000427f0  bl       #0x55d78   ; CALL _objc_release
0x000427f4  mov      x0, x21
0x000427f8  bl       #0x55d78   ; CALL _objc_release
0x000427fc  mov      x0, x20
0x00042800  bl       #0x55d78   ; CALL _objc_release
0x00042804  mov      x0, x19
0x00042808  bl       #0x55d78   ; CALL _objc_release
0x0004280c  ldp      x29, x30, [sp, #0x90]
0x00042810  ldp      x20, x19, [sp, #0x80]
0x00042814  ldp      x22, x21, [sp, #0x70]
0x00042818  ldp      x24, x23, [sp, #0x60]
0x0004281c  add      sp, sp, #0xa0
0x00042820  ret      
0x00042824  ldp      x8, x2, [x0, #0x20]
0x00042828  mov      x0, x8
0x0004282c  b        #0x5a040   ; CALL objc_msgSend$saveLogoImage:
0x00042830  ldr      x8, [x0, #0x20]
0x00042834  cbz      x8, #0x428a4
0x00042838  sub      sp, sp, #0x50
0x0004283c  stp      x24, x23, [sp, #0x10]
0x00042840  stp      x22, x21, [sp, #0x20]
0x00042844  stp      x20, x19, [sp, #0x30]
0x00042848  stp      x29, x30, [sp, #0x40]
0x0004284c  add      x29, sp, #0x40
0x00042850  mov      x20, x0
0x00042854  adrp     x8, #0x8e000
0x00042858  ldr      x0, [x8, #0x980]   ; @CLASS NSDateFormatter
0x0004285c  bl       #0x55d60   ; CALL _objc_opt_new
0x00042860  mov      x19, x0
0x00042864  adrp     x2, #0x7c000
0x00042868  add      x2, x2, #0xa28   ; STR "yyyyMMdd-HHmmss"
0x0004286c  bl       #0x5ac40   ; CALL objc_msgSend$setDateFormat:
0x00042870  ldr      x0, [x20, #0x20]
0x00042874  bl       #0x59620   ; CALL objc_msgSend$pathExtension
0x00042878  mov      x29, x29
0x0004287c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042880  mov      x22, x0
0x00042884  bl       #0x58c20   ; CALL objc_msgSend$length
0x00042888  cbz      x0, #0x428a8
0x0004288c  ldr      x0, [x20, #0x20]
0x00042890  bl       #0x59620   ; CALL objc_msgSend$pathExtension
0x00042894  mov      x29, x29
0x00042898  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004289c  mov      x21, x0
0x000428a0  b        #0x428b0
0x000428a4  ret      
0x000428a8  adrp     x21, #0x7c000
0x000428ac  add      x21, x21, #0xa48   ; STR "mov"
0x000428b0  mov      x0, x22
0x000428b4  bl       #0x55d78   ; CALL _objc_release
0x000428b8  adrp     x8, #0x8e000
0x000428bc  ldr      x22, [x8, #0x958]   ; @CLASS NSString
0x000428c0  adrp     x8, #0x8e000
0x000428c4  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x000428c8  bl       #0x575a0   ; CALL objc_msgSend$date
0x000428cc  mov      x29, x29
0x000428d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000428d4  mov      x23, x0
0x000428d8  mov      x0, x19
0x000428dc  mov      x2, x23
0x000428e0  bl       #0x5d500   ; CALL objc_msgSend$stringFromDate:
0x000428e4  mov      x29, x29
0x000428e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000428ec  mov      x24, x0
0x000428f0  stp      x0, x21, [sp]
0x000428f4  adrp     x2, #0x7c000
0x000428f8  add      x2, x2, #0xa68   ; STR "Video %@.%@"
0x000428fc  mov      x0, x22
0x00042900  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00042904  mov      x29, x29
0x00042908  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004290c  mov      x22, x0
0x00042910  mov      x0, x24
0x00042914  bl       #0x55d78   ; CALL _objc_release
0x00042918  mov      x0, x23
0x0004291c  bl       #0x55d78   ; CALL _objc_release
0x00042920  ldp      x2, x0, [x20, #0x20]
0x00042924  mov      x3, x22
0x00042928  bl       #0x57380   ; CALL objc_msgSend$copyVideoAtURL:name:
0x0004292c  mov      x0, x22
0x00042930  bl       #0x55d78   ; CALL _objc_release
0x00042934  mov      x0, x21
0x00042938  bl       #0x55d78   ; CALL _objc_release
0x0004293c  mov      x0, x19
0x00042940  ldp      x29, x30, [sp, #0x40]
0x00042944  ldp      x20, x19, [sp, #0x30]
0x00042948  ldp      x22, x21, [sp, #0x20]
0x0004294c  ldp      x24, x23, [sp, #0x10]
0x00042950  add      sp, sp, #0x50
0x00042954  b        #0x55d78   ; CALL _objc_release

=== -[OMCStartupScreenController imagePickerControllerDidCancel:]  va=0x42958 size=16 types=v24@0:8@16
0x00042958  mov      x0, x2
0x0004295c  mov      w2, #1
0x00042960  mov      x3, #0
0x00042964  b        #0x57820   ; CALL objc_msgSend$dismissViewControllerAnimated:completion:

=== -[OMCStartupScreenController importFromFiles]  va=0x42968 size=228 types=v16@0:8
0x00042968  sub      sp, sp, #0x40
0x0004296c  stp      x22, x21, [sp, #0x10]
0x00042970  stp      x20, x19, [sp, #0x20]
0x00042974  stp      x29, x30, [sp, #0x30]
0x00042978  add      x29, sp, #0x30
0x0004297c  mov      x19, x0
0x00042980  adrp     x8, #0x74000
0x00042984  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00042988  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0004298c  str      x8, [sp, #8]
0x00042990  mov      x2, #0
0x00042994  bl       #0x5bb80   ; CALL objc_msgSend$setPickKind:
0x00042998  adrp     x8, #0x8e000
0x0004299c  ldr      x0, [x8, #0xc90]   ; @CLASS UIDocumentPickerViewController
0x000429a0  bl       #0x55c7c   ; CALL _objc_alloc
0x000429a4  mov      x20, x0
0x000429a8  adrp     x8, #0x74000
0x000429ac  ldr      x8, [x8, #0x318]   ; @GOT _UTTypeMovie
0x000429b0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000429b4  str      x8, [sp]
0x000429b8  adrp     x8, #0x8e000
0x000429bc  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000429c0  mov      x2, sp
0x000429c4  mov      w3, #1
0x000429c8  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000429cc  mov      x29, x29
0x000429d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000429d4  mov      x21, x0
0x000429d8  mov      x0, x20
0x000429dc  mov      x2, x21
0x000429e0  mov      w3, #1
0x000429e4  bl       #0x58360   ; CALL objc_msgSend$initForOpeningContentTypes:asCopy:
0x000429e8  mov      x20, x0
0x000429ec  mov      x0, x21
0x000429f0  bl       #0x55d78   ; CALL _objc_release
0x000429f4  mov      x0, x20
0x000429f8  mov      x2, x19
0x000429fc  bl       #0x5aca0   ; CALL objc_msgSend$setDelegate:
0x00042a00  mov      x0, x19
0x00042a04  mov      x2, x20
0x00042a08  mov      w3, #1
0x00042a0c  mov      x4, #0
0x00042a10  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x00042a14  mov      x0, x20
0x00042a18  bl       #0x55d78   ; CALL _objc_release
0x00042a1c  ldr      x8, [sp, #8]
0x00042a20  adrp     x9, #0x74000
0x00042a24  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00042a28  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00042a2c  cmp      x9, x8
0x00042a30  b.ne     #0x42a48
0x00042a34  ldp      x29, x30, [sp, #0x30]
0x00042a38  ldp      x20, x19, [sp, #0x20]
0x00042a3c  ldp      x22, x21, [sp, #0x10]
0x00042a40  add      sp, sp, #0x40
0x00042a44  ret      
0x00042a48  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController documentPicker:didPickDocumentsAtURLs:]  va=0x42a4c size=232 types=v32@0:8@16@24
0x00042a4c  stp      x22, x21, [sp, #-0x30]!
0x00042a50  stp      x20, x19, [sp, #0x10]
0x00042a54  stp      x29, x30, [sp, #0x20]
0x00042a58  add      x29, sp, #0x20
0x00042a5c  mov      x20, x0
0x00042a60  mov      x0, x3
0x00042a64  bl       #0x57c20   ; CALL objc_msgSend$firstObject
0x00042a68  mov      x29, x29
0x00042a6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042a70  mov      x19, x0
0x00042a74  cbz      x0, #0x42b20
0x00042a78  mov      x0, x20
0x00042a7c  bl       #0x596e0   ; CALL objc_msgSend$pickKind
0x00042a80  cbz      x0, #0x42af4
0x00042a84  cmp      x0, #2
0x00042a88  b.eq     #0x42ae4
0x00042a8c  cmp      x0, #1
0x00042a90  b.ne     #0x42b20
0x00042a94  adrp     x8, #0x8e000
0x00042a98  ldr      x21, [x8, #0xa78]   ; @CLASS UIImage
0x00042a9c  mov      x0, x19
0x00042aa0  bl       #0x59600   ; CALL objc_msgSend$path
0x00042aa4  mov      x29, x29
0x00042aa8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042aac  mov      x22, x0
0x00042ab0  mov      x0, x21
0x00042ab4  mov      x2, x22
0x00042ab8  bl       #0x581c0   ; CALL objc_msgSend$imageWithContentsOfFile:
0x00042abc  mov      x29, x29
0x00042ac0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042ac4  mov      x21, x0
0x00042ac8  mov      x0, x20
0x00042acc  mov      x2, x21
0x00042ad0  bl       #0x5a040   ; CALL objc_msgSend$saveLogoImage:
0x00042ad4  mov      x0, x21
0x00042ad8  bl       #0x55d78   ; CALL _objc_release
0x00042adc  mov      x0, x22
0x00042ae0  b        #0x42b1c
0x00042ae4  mov      x0, x20
0x00042ae8  mov      x2, x19
0x00042aec  bl       #0x57360   ; CALL objc_msgSend$copySoundAtURL:
0x00042af0  b        #0x42b20
0x00042af4  mov      x0, x19
0x00042af8  bl       #0x58a80   ; CALL objc_msgSend$lastPathComponent
0x00042afc  mov      x29, x29
0x00042b00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042b04  mov      x21, x0
0x00042b08  mov      x0, x20
0x00042b0c  mov      x2, x19
0x00042b10  mov      x3, x21
0x00042b14  bl       #0x57380   ; CALL objc_msgSend$copyVideoAtURL:name:
0x00042b18  mov      x0, x21
0x00042b1c  bl       #0x55d78   ; CALL _objc_release
0x00042b20  mov      x0, x19
0x00042b24  ldp      x29, x30, [sp, #0x20]
0x00042b28  ldp      x20, x19, [sp, #0x10]
0x00042b2c  ldp      x22, x21, [sp], #0x30
0x00042b30  b        #0x55d78   ; CALL _objc_release

=== -[OMCStartupScreenController copyVideoAtURL:name:]  va=0x42b34 size=1224 types=v32@0:8@16@24
0x00042b34  stp      x28, x27, [sp, #-0x60]!
0x00042b38  stp      x26, x25, [sp, #0x10]
0x00042b3c  stp      x24, x23, [sp, #0x20]
0x00042b40  stp      x22, x21, [sp, #0x30]
0x00042b44  stp      x20, x19, [sp, #0x40]
0x00042b48  stp      x29, x30, [sp, #0x50]
0x00042b4c  add      x29, sp, #0x50
0x00042b50  sub      sp, sp, #0x490
0x00042b54  mov      x19, x3
0x00042b58  str      x0, [sp, #0x20]
0x00042b5c  adrp     x8, #0x74000
0x00042b60  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00042b64  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00042b68  stur     x8, [x29, #-0x60]
0x00042b6c  str      x2, [sp, #0x18]
0x00042b70  mov      x0, x2
0x00042b74  bl       #0x55d84   ; CALL _objc_retain
0x00042b78  str      x19, [sp, #0x28]
0x00042b7c  mov      x0, x19
0x00042b80  bl       #0x55d84   ; CALL _objc_retain
0x00042b84  adrp     x8, #0x8e000
0x00042b88  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x00042b8c  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x00042b90  mov      x29, x29
0x00042b94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042b98  mov      x21, x0
0x00042b9c  adrp     x0, #0x76000
0x00042ba0  add      x0, x0, #0xb68   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Videos"
0x00042ba4  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00042ba8  add      x1, sp, #0x80
0x00042bac  bl       #0x4118
0x00042bb0  mov      x2, x0
0x00042bb4  adrp     x20, #0x8e000
0x00042bb8  cbz      x0, #0x42bd4
0x00042bbc  ldr      x0, [x20, #0x958]   ; @CLASS NSString
0x00042bc0  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00042bc4  mov      x29, x29
0x00042bc8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042bcc  mov      x22, x0
0x00042bd0  b        #0x42bd8
0x00042bd4  mov      x22, #0
0x00042bd8  mov      x0, x21
0x00042bdc  mov      x2, x22
0x00042be0  mov      w3, #1
0x00042be4  mov      x4, #0
0x00042be8  mov      x5, #0
0x00042bec  bl       #0x57400   ; CALL objc_msgSend$createDirectoryAtPath:withIntermediateDirectories:attributes:error:
0x00042bf0  mov      x0, x22
0x00042bf4  bl       #0x55d78   ; CALL _objc_release
0x00042bf8  ldr      x0, [sp, #0x28]
0x00042bfc  bl       #0x5d480   ; CALL objc_msgSend$stringByDeletingPathExtension
0x00042c00  mov      x29, x29
0x00042c04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042c08  str      x0, [sp, #0x30]
0x00042c0c  ldr      x0, [sp, #0x28]
0x00042c10  bl       #0x59620   ; CALL objc_msgSend$pathExtension
0x00042c14  mov      x29, x29
0x00042c18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042c1c  mov      x24, x0
0x00042c20  adrp     x0, #0x76000
0x00042c24  add      x0, x0, #0xb68   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Videos"
0x00042c28  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00042c2c  add      x1, sp, #0x80
0x00042c30  bl       #0x4118
0x00042c34  mov      x2, x0
0x00042c38  cbz      x0, #0x42c54
0x00042c3c  ldr      x0, [x20, #0x958]   ; @CLASS NSString
0x00042c40  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00042c44  mov      x29, x29
0x00042c48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042c4c  mov      x19, x0
0x00042c50  b        #0x42c58
0x00042c54  mov      x19, #0
0x00042c58  mov      x0, x19
0x00042c5c  ldr      x2, [sp, #0x28]
0x00042c60  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00042c64  mov      x29, x29
0x00042c68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042c6c  mov      x28, x0
0x00042c70  mov      x0, x19
0x00042c74  bl       #0x55d78   ; CALL _objc_release
0x00042c78  mov      x0, x21
0x00042c7c  mov      x2, x28
0x00042c80  bl       #0x57b40   ; CALL objc_msgSend$fileExistsAtPath:
0x00042c84  cbz      w0, #0x42d40
0x00042c88  mov      w22, #2
0x00042c8c  adrp     x26, #0x76000
0x00042c90  add      x26, x26, #0xb68   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Videos"
0x00042c94  adrp     x27, #0x7c000
0x00042c98  add      x27, x27, #0xa88   ; STR "%@ %d.%@"
0x00042c9c  mov      x0, x26
0x00042ca0  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00042ca4  add      x1, sp, #0x80
0x00042ca8  bl       #0x4118
0x00042cac  mov      x2, x0
0x00042cb0  cbz      x0, #0x42ccc
0x00042cb4  ldr      x0, [x20, #0x958]   ; @CLASS NSString
0x00042cb8  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00042cbc  mov      x29, x29
0x00042cc0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042cc4  mov      x23, x0
0x00042cc8  b        #0x42cd0
0x00042ccc  mov      x23, #0
0x00042cd0  ldr      x0, [x20, #0x958]   ; @CLASS NSString
0x00042cd4  stp      x22, x24, [sp, #8]
0x00042cd8  ldr      x8, [sp, #0x30]
0x00042cdc  str      x8, [sp]
0x00042ce0  mov      x2, x27
0x00042ce4  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00042ce8  mov      x29, x29
0x00042cec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042cf0  mov      x19, x0
0x00042cf4  mov      x0, x23
0x00042cf8  mov      x2, x19
0x00042cfc  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00042d00  mov      x29, x29
0x00042d04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042d08  mov      x25, x0
0x00042d0c  mov      x0, x28
0x00042d10  bl       #0x55d78   ; CALL _objc_release
0x00042d14  mov      x0, x19
0x00042d18  bl       #0x55d78   ; CALL _objc_release
0x00042d1c  mov      x0, x23
0x00042d20  bl       #0x55d78   ; CALL _objc_release
0x00042d24  mov      x0, x21
0x00042d28  mov      x2, x25
0x00042d2c  bl       #0x57b40   ; CALL objc_msgSend$fileExistsAtPath:
0x00042d30  add      w22, w22, #1
0x00042d34  mov      x28, x25
0x00042d38  tbz      w0, #0, #0x42d44
0x00042d3c  b        #0x42c9c
0x00042d40  mov      x25, x28
0x00042d44  ldr      x0, [sp, #0x18]
0x00042d48  bl       #0x59600   ; CALL objc_msgSend$path
0x00042d4c  mov      x29, x29
0x00042d50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042d54  mov      x23, x0
0x00042d58  str      xzr, [sp, #0x60]
0x00042d5c  add      x4, sp, #0x60
0x00042d60  mov      x0, x21
0x00042d64  mov      x2, x23
0x00042d68  mov      x3, x25
0x00042d6c  bl       #0x57320   ; CALL objc_msgSend$copyItemAtPath:toPath:error:
0x00042d70  mov      x19, x0
0x00042d74  ldr      x26, [sp, #0x60]
0x00042d78  mov      x0, x26
0x00042d7c  bl       #0x55d84   ; CALL _objc_retain
0x00042d80  mov      x0, x23
0x00042d84  bl       #0x55d78   ; CALL _objc_release
0x00042d88  tbz      w19, #0, #0x42ec0
0x00042d8c  adrp     x8, #0x74000
0x00042d90  ldr      x8, [x8, #0x120]   ; @GOT _NSFilePosixPermissions
0x00042d94  ldr      x9, [x8]   ; @GOT ___objc_personality_v0
0x00042d98  adrp     x8, #0x80000
0x00042d9c  add      x8, x8, #0x460
0x00042da0  stp      x9, x8, [sp, #0x70]
0x00042da4  adrp     x8, #0x8e000
0x00042da8  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00042dac  add      x2, sp, #0x78
0x00042db0  add      x3, sp, #0x70
0x00042db4  mov      w4, #1
0x00042db8  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00042dbc  mov      x29, x29
0x00042dc0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042dc4  mov      x19, x0
0x00042dc8  mov      x0, x21
0x00042dcc  mov      x2, x19
0x00042dd0  mov      x3, x25
0x00042dd4  mov      x4, #0
0x00042dd8  bl       #0x5a4e0   ; CALL objc_msgSend$setAttributes:ofItemAtPath:error:
0x00042ddc  mov      x0, x19
0x00042de0  bl       #0x55d78   ; CALL _objc_release
0x00042de4  mov      x0, x25
0x00042de8  bl       #0x58a80   ; CALL objc_msgSend$lastPathComponent
0x00042dec  mov      x29, x29
0x00042df0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042df4  mov      x19, x0
0x00042df8  ldr      x0, [sp, #0x20]
0x00042dfc  mov      x2, x19
0x00042e00  bl       #0x5bf80   ; CALL objc_msgSend$setSelectedVideo:
0x00042e04  mov      x0, x19
0x00042e08  bl       #0x55d78   ; CALL _objc_release
0x00042e0c  add      x0, sp, #0x80
0x00042e10  ldr      x1, [sp, #0x20]
0x00042e14  bl       #0x55d18   ; CALL _objc_initWeak
0x00042e18  mov      x0, x25
0x00042e1c  bl       #0x58a80   ; CALL objc_msgSend$lastPathComponent
0x00042e20  mov      x29, x29
0x00042e24  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042e28  mov      x27, x0
0x00042e2c  str      x0, [sp, #0x68]
0x00042e30  adrp     x8, #0x8e000
0x00042e34  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00042e38  add      x2, sp, #0x68
0x00042e3c  mov      w3, #1
0x00042e40  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00042e44  mov      x29, x29
0x00042e48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042e4c  mov      x23, x0
0x00042e50  adrp     x8, #0x74000
0x00042e54  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00042e58  str      x8, [sp, #0x38]
0x00042e5c  adrp     x8, #0x65000
0x00042e60  ldr      d0, [x8, #0x600]
0x00042e64  adrp     x8, #0x42000
0x00042e68  add      x8, x8, #0xfd0
0x00042e6c  str      d0, [sp, #0x40]
0x00042e70  adrp     x9, #0x74000
0x00042e74  add      x9, x9, #0x820
0x00042e78  stp      x8, x9, [sp, #0x48]
0x00042e7c  add      x20, sp, #0x38
0x00042e80  add      x0, x20, #0x20   ; SEL "widthAnchor"
0x00042e84  add      x1, sp, #0x80
0x00042e88  bl       #0x55cd0   ; CALL _objc_copyWeak
0x00042e8c  add      x3, sp, #0x38
0x00042e90  ldr      x0, [sp, #0x20]
0x00042e94  mov      x2, x23
0x00042e98  bl       #0x57ae0   ; CALL objc_msgSend$extractFramesForVideos:completion:
0x00042e9c  mov      x0, x23
0x00042ea0  bl       #0x55d78   ; CALL _objc_release
0x00042ea4  mov      x0, x27
0x00042ea8  bl       #0x55d78   ; CALL _objc_release
0x00042eac  add      x0, x20, #0x20   ; SEL "widthAnchor"
0x00042eb0  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00042eb4  add      x0, sp, #0x80
0x00042eb8  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00042ebc  b        #0x42f30
0x00042ec0  ldr      x28, [x20, #0x958]   ; @CLASS NSString
0x00042ec4  adrp     x0, #0x7c000
0x00042ec8  add      x0, x0, #0xaa8   ; STR "STARTUPSCREEN_SAVE_FAILED"
0x00042ecc  bl       #0x17e20   ; CALL _L
0x00042ed0  mov      x29, x29
0x00042ed4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042ed8  mov      x27, x0
0x00042edc  mov      x0, x26
0x00042ee0  bl       #0x58dc0   ; CALL objc_msgSend$localizedDescription
0x00042ee4  mov      x29, x29
0x00042ee8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042eec  mov      x23, x0
0x00042ef0  str      x0, [sp]
0x00042ef4  mov      x0, x28
0x00042ef8  mov      x2, x27
0x00042efc  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00042f00  mov      x29, x29
0x00042f04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00042f08  mov      x19, x0
0x00042f0c  ldr      x0, [sp, #0x20]
0x00042f10  mov      x2, x19
0x00042f14  bl       #0x5ca40   ; CALL objc_msgSend$showMessage:
0x00042f18  mov      x0, x19
0x00042f1c  bl       #0x55d78   ; CALL _objc_release
0x00042f20  mov      x0, x23
0x00042f24  bl       #0x55d78   ; CALL _objc_release
0x00042f28  mov      x0, x27
0x00042f2c  bl       #0x55d78   ; CALL _objc_release
0x00042f30  mov      x0, x26
0x00042f34  bl       #0x55d78   ; CALL _objc_release
0x00042f38  mov      x0, x25
0x00042f3c  bl       #0x55d78   ; CALL _objc_release
0x00042f40  mov      x0, x24
0x00042f44  bl       #0x55d78   ; CALL _objc_release
0x00042f48  ldr      x0, [sp, #0x30]
0x00042f4c  bl       #0x55d78   ; CALL _objc_release
0x00042f50  mov      x0, x21
0x00042f54  bl       #0x55d78   ; CALL _objc_release
0x00042f58  ldr      x0, [sp, #0x28]
0x00042f5c  bl       #0x55d78   ; CALL _objc_release
0x00042f60  ldr      x0, [sp, #0x18]
0x00042f64  bl       #0x55d78   ; CALL _objc_release
0x00042f68  ldur     x8, [x29, #-0x60]
0x00042f6c  adrp     x9, #0x74000
0x00042f70  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00042f74  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00042f78  cmp      x9, x8
0x00042f7c  b.ne     #0x42fa0
0x00042f80  add      sp, sp, #0x490
0x00042f84  ldp      x29, x30, [sp, #0x50]
0x00042f88  ldp      x20, x19, [sp, #0x40]
0x00042f8c  ldp      x22, x21, [sp, #0x30]
0x00042f90  ldp      x24, x23, [sp, #0x20]
0x00042f94  ldp      x26, x25, [sp, #0x10]
0x00042f98  ldp      x28, x27, [sp], #0x60
0x00042f9c  ret      
0x00042fa0  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00042fa4  mov      x19, x0
0x00042fa8  add      x0, x20, #0x20   ; SEL "widthAnchor"
0x00042fac  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00042fb0  b        #0x42fb8
0x00042fb4  mov      x19, x0
0x00042fb8  add      x0, sp, #0x80
0x00042fbc  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00042fc0  b        #0x42fc8
0x00042fc4  mov      x19, x0
0x00042fc8  mov      x0, x19
0x00042fcc  bl       #0x55b80   ; CALL __Unwind_Resume
0x00042fd0  stp      x20, x19, [sp, #-0x20]!
0x00042fd4  stp      x29, x30, [sp, #0x10]
0x00042fd8  add      x29, sp, #0x10
0x00042fdc  add      x0, x0, #0x20   ; SEL "writeToFile:atomically:encoding:error:"
0x00042fe0  bl       #0x55d24   ; CALL _objc_loadWeakRetained
0x00042fe4  mov      x19, x0
0x00042fe8  bl       #0x5dd80   ; CALL objc_msgSend$updatePreview
0x00042fec  mov      x0, x19
0x00042ff0  ldp      x29, x30, [sp, #0x10]
0x00042ff4  ldp      x20, x19, [sp], #0x20
0x00042ff8  b        #0x55d78   ; CALL _objc_release

=== -[OMCStartupScreenController addVideo]  va=0x42ffc size=872 types=v16@0:8
0x00042ffc  sub      sp, sp, #0xc0
0x00043000  stp      d9, d8, [sp, #0x60]
0x00043004  stp      x26, x25, [sp, #0x70]
0x00043008  stp      x24, x23, [sp, #0x80]
0x0004300c  stp      x22, x21, [sp, #0x90]
0x00043010  stp      x20, x19, [sp, #0xa0]
0x00043014  stp      x29, x30, [sp, #0xb0]
0x00043018  add      x29, sp, #0xb0
0x0004301c  mov      x20, x0
0x00043020  adrp     x8, #0x8e000
0x00043024  ldr      x0, [x8, #0x9b8]   ; @CLASS UIAlertController
0x00043028  mov      x2, #0
0x0004302c  mov      x3, #0
0x00043030  mov      x4, #0
0x00043034  bl       #0x56280   ; CALL objc_msgSend$alertControllerWithTitle:message:preferredStyle:
0x00043038  mov      x29, x29
0x0004303c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043040  mov      x19, x0
0x00043044  add      x0, sp, #0x58
0x00043048  mov      x1, x20
0x0004304c  bl       #0x55d18   ; CALL _objc_initWeak
0x00043050  adrp     x23, #0x8e000
0x00043054  ldr      x22, [x23, #0x9c0]   ; @CLASS UIAlertAction
0x00043058  adrp     x0, #0x7c000
0x0004305c  add      x0, x0, #0xac8   ; STR "STARTUPSCREEN_FROM_PHOTOS"
0x00043060  bl       #0x17e20   ; CALL _L
0x00043064  mov      x29, x29
0x00043068  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004306c  mov      x21, x0
0x00043070  adrp     x25, #0x74000
0x00043074  ldr      x25, [x25, #0x378]   ; @GOT __NSConcreteStackBlock
0x00043078  str      x25, [sp, #0x30]
0x0004307c  adrp     x8, #0x65000
0x00043080  ldr      d8, [x8, #0x600]
0x00043084  adrp     x8, #0x43000
0x00043088  add      x8, x8, #0x30c
0x0004308c  str      d8, [sp, #0x38]
0x00043090  adrp     x26, #0x74000
0x00043094  add      x26, x26, #0x850
0x00043098  stp      x8, x26, [sp, #0x40]
0x0004309c  add      x24, sp, #0x30
0x000430a0  add      x0, x24, #0x20
0x000430a4  add      x1, sp, #0x58
0x000430a8  bl       #0x55cd0   ; CALL _objc_copyWeak
0x000430ac  add      x4, sp, #0x30
0x000430b0  mov      x0, x22
0x000430b4  mov      x2, x21
0x000430b8  mov      x3, #0
0x000430bc  bl       #0x55fc0   ; CALL objc_msgSend$actionWithTitle:style:handler:
0x000430c0  mov      x29, x29
0x000430c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000430c8  mov      x22, x0
0x000430cc  mov      x0, x19
0x000430d0  mov      x2, x22
0x000430d4  bl       #0x56000   ; CALL objc_msgSend$addAction:
0x000430d8  mov      x0, x22
0x000430dc  bl       #0x55d78   ; CALL _objc_release
0x000430e0  mov      x0, x21
0x000430e4  bl       #0x55d78   ; CALL _objc_release
0x000430e8  ldr      x22, [x23, #0x9c0]   ; @CLASS UIAlertAction
0x000430ec  adrp     x0, #0x7c000
0x000430f0  add      x0, x0, #0xae8   ; STR "STARTUPSCREEN_FROM_FILES"
0x000430f4  bl       #0x17e20   ; CALL _L
0x000430f8  mov      x29, x29
0x000430fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043100  mov      x21, x0
0x00043104  str      x25, [sp, #8]
0x00043108  str      d8, [sp, #0x10]
0x0004310c  adrp     x8, #0x43000
0x00043110  add      x8, x8, #0x338
0x00043114  stp      x8, x26, [sp, #0x18]
0x00043118  add      x25, sp, #8
0x0004311c  add      x0, x25, #0x20   ; GOT _objc_autoreleasePoolPop
0x00043120  add      x1, sp, #0x58
0x00043124  bl       #0x55cd0   ; CALL _objc_copyWeak
0x00043128  add      x4, sp, #8
0x0004312c  mov      x0, x22
0x00043130  mov      x2, x21
0x00043134  mov      x3, #0
0x00043138  bl       #0x55fc0   ; CALL objc_msgSend$actionWithTitle:style:handler:
0x0004313c  mov      x29, x29
0x00043140  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043144  mov      x22, x0
0x00043148  mov      x0, x19
0x0004314c  mov      x2, x22
0x00043150  bl       #0x56000   ; CALL objc_msgSend$addAction:
0x00043154  mov      x0, x22
0x00043158  bl       #0x55d78   ; CALL _objc_release
0x0004315c  mov      x0, x21
0x00043160  bl       #0x55d78   ; CALL _objc_release
0x00043164  ldr      x22, [x23, #0x9c0]   ; @CLASS UIAlertAction
0x00043168  adrp     x0, #0x78000
0x0004316c  add      x0, x0, #0x9e8   ; STR "CANCEL"
0x00043170  bl       #0x17e20   ; CALL _L
0x00043174  mov      x29, x29
0x00043178  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004317c  mov      x21, x0
0x00043180  mov      x0, x22
0x00043184  mov      x2, x21
0x00043188  mov      w3, #1
0x0004318c  mov      x4, #0
0x00043190  bl       #0x55fc0   ; CALL objc_msgSend$actionWithTitle:style:handler:
0x00043194  mov      x29, x29
0x00043198  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004319c  mov      x22, x0
0x000431a0  mov      x0, x19
0x000431a4  mov      x2, x22
0x000431a8  bl       #0x56000   ; CALL objc_msgSend$addAction:
0x000431ac  mov      x0, x22
0x000431b0  bl       #0x55d78   ; CALL _objc_release
0x000431b4  mov      x0, x21
0x000431b8  bl       #0x55d78   ; CALL _objc_release
0x000431bc  mov      x0, x20
0x000431c0  bl       #0x5df60   ; CALL objc_msgSend$view
0x000431c4  mov      x29, x29
0x000431c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000431cc  mov      x21, x0
0x000431d0  mov      x0, x19
0x000431d4  bl       #0x59840   ; CALL objc_msgSend$popoverPresentationController
0x000431d8  mov      x29, x29
0x000431dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000431e0  mov      x22, x0
0x000431e4  mov      x2, x21
0x000431e8  bl       #0x5c220   ; CALL objc_msgSend$setSourceView:
0x000431ec  mov      x0, x22
0x000431f0  bl       #0x55d78   ; CALL _objc_release
0x000431f4  mov      x0, x21
0x000431f8  bl       #0x55d78   ; CALL _objc_release
0x000431fc  mov      x0, x20
0x00043200  bl       #0x5df60   ; CALL objc_msgSend$view
0x00043204  mov      x29, x29
0x00043208  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004320c  mov      x21, x0
0x00043210  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00043214  bl       #0x55a60   ; CALL _CGRectGetMidX
0x00043218  mov      v8.16b, v0.16b
0x0004321c  mov      x0, x20
0x00043220  bl       #0x5df60   ; CALL objc_msgSend$view
0x00043224  mov      x29, x29
0x00043228  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004322c  mov      x22, x0
0x00043230  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00043234  bl       #0x55a6c   ; CALL _CGRectGetMidY
0x00043238  mov      v9.16b, v0.16b
0x0004323c  mov      x0, x19
0x00043240  bl       #0x59840   ; CALL objc_msgSend$popoverPresentationController
0x00043244  mov      x29, x29
0x00043248  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004324c  mov      x23, x0
0x00043250  fmov     d2, #1.00000000
0x00043254  fmov     d3, #1.00000000
0x00043258  mov      v0.16b, v8.16b
0x0004325c  mov      v1.16b, v9.16b
0x00043260  bl       #0x5c1e0   ; CALL objc_msgSend$setSourceRect:
0x00043264  mov      x0, x23
0x00043268  bl       #0x55d78   ; CALL _objc_release
0x0004326c  mov      x0, x22
0x00043270  bl       #0x55d78   ; CALL _objc_release
0x00043274  mov      x0, x21
0x00043278  bl       #0x55d78   ; CALL _objc_release
0x0004327c  mov      x0, x20
0x00043280  mov      x2, x19
0x00043284  mov      w3, #1
0x00043288  mov      x4, #0
0x0004328c  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x00043290  add      x0, x25, #0x20   ; GOT _objc_autoreleasePoolPop
0x00043294  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00043298  add      x0, x24, #0x20
0x0004329c  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x000432a0  add      x0, sp, #0x58
0x000432a4  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x000432a8  mov      x0, x19
0x000432ac  bl       #0x55d78   ; CALL _objc_release
0x000432b0  ldp      x29, x30, [sp, #0xb0]
0x000432b4  ldp      x20, x19, [sp, #0xa0]
0x000432b8  ldp      x22, x21, [sp, #0x90]
0x000432bc  ldp      x24, x23, [sp, #0x80]
0x000432c0  ldp      x26, x25, [sp, #0x70]
0x000432c4  ldp      d9, d8, [sp, #0x60]
0x000432c8  add      sp, sp, #0xc0
0x000432cc  ret      
0x000432d0  b        #0x432e0
0x000432d4  mov      x19, x0
0x000432d8  b        #0x432fc
0x000432dc  b        #0x432e8
0x000432e0  mov      x19, x0
0x000432e4  b        #0x432f4
0x000432e8  mov      x19, x0
0x000432ec  add      x0, x25, #0x20   ; GOT _objc_autoreleasePoolPop
0x000432f0  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x000432f4  add      x0, x24, #0x20
0x000432f8  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x000432fc  add      x0, sp, #0x58
0x00043300  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00043304  mov      x0, x19
0x00043308  bl       #0x55b80   ; CALL __Unwind_Resume
0x0004330c  stp      x20, x19, [sp, #-0x20]!
0x00043310  stp      x29, x30, [sp, #0x10]
0x00043314  add      x29, sp, #0x10
0x00043318  add      x0, x0, #0x20   ; GOT _objc_copyWeak
0x0004331c  bl       #0x55d24   ; CALL _objc_loadWeakRetained
0x00043320  mov      x19, x0
0x00043324  bl       #0x58260   ; CALL objc_msgSend$importFromPhotos
0x00043328  mov      x0, x19
0x0004332c  ldp      x29, x30, [sp, #0x10]
0x00043330  ldp      x20, x19, [sp], #0x20
0x00043334  b        #0x55d78   ; CALL _objc_release
0x00043338  stp      x20, x19, [sp, #-0x20]!
0x0004333c  stp      x29, x30, [sp, #0x10]
0x00043340  add      x29, sp, #0x10
0x00043344  add      x0, x0, #0x20   ; GOT _objc_getAssociatedObject
0x00043348  bl       #0x55d24   ; CALL _objc_loadWeakRetained
0x0004334c  mov      x19, x0
0x00043350  bl       #0x58240   ; CALL objc_msgSend$importFromFiles
0x00043354  mov      x0, x19
0x00043358  ldp      x29, x30, [sp, #0x10]
0x0004335c  ldp      x20, x19, [sp], #0x20
0x00043360  b        #0x55d78   ; CALL _objc_release

=== -[OMCStartupScreenController previewVideo]  va=0x43364 size=524 types=v16@0:8
0x00043364  stp      x26, x25, [sp, #-0x50]!
0x00043368  stp      x24, x23, [sp, #0x10]
0x0004336c  stp      x22, x21, [sp, #0x20]
0x00043370  stp      x20, x19, [sp, #0x30]
0x00043374  stp      x29, x30, [sp, #0x40]
0x00043378  add      x29, sp, #0x40
0x0004337c  sub      sp, sp, #0x430
0x00043380  mov      x20, x0
0x00043384  adrp     x8, #0x74000
0x00043388  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0004338c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00043390  stur     x8, [x29, #-0x48]
0x00043394  bl       #0x5a1e0   ; CALL objc_msgSend$selectedVideo
0x00043398  mov      x29, x29
0x0004339c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000433a0  mov      x19, x0
0x000433a4  cbz      x0, #0x43400
0x000433a8  adrp     x8, #0x8e000
0x000433ac  ldr      x0, [x8, #0xc98]   ; @CLASS AVPlayerViewController
0x000433b0  bl       #0x55d60   ; CALL _objc_opt_new
0x000433b4  mov      x21, x0
0x000433b8  adrp     x8, #0x8e000
0x000433bc  ldr      x22, [x8, #0xca0]   ; @CLASS AVPlayer
0x000433c0  adrp     x8, #0x8e000
0x000433c4  ldr      x23, [x8, #0xa10]   ; @CLASS NSURL
0x000433c8  adrp     x0, #0x76000
0x000433cc  add      x0, x0, #0xb68   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Videos"
0x000433d0  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x000433d4  add      x1, sp, #0x28
0x000433d8  bl       #0x4118
0x000433dc  cbz      x0, #0x43428
0x000433e0  mov      x2, x0
0x000433e4  adrp     x8, #0x8e000
0x000433e8  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x000433ec  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x000433f0  mov      x29, x29
0x000433f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000433f8  mov      x24, x0
0x000433fc  b        #0x4342c
0x00043400  adrp     x0, #0x7c000
0x00043404  add      x0, x0, #0xb08   ; STR "STARTUPSCREEN_NO_VIDEO_PREVIEW"
0x00043408  bl       #0x17e20   ; CALL _L
0x0004340c  mov      x29, x29
0x00043410  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043414  mov      x21, x0
0x00043418  mov      x0, x20
0x0004341c  mov      x2, x21
0x00043420  bl       #0x5ca40   ; CALL objc_msgSend$showMessage:
0x00043424  b        #0x434f4
0x00043428  mov      x24, #0
0x0004342c  mov      x0, x24
0x00043430  mov      x2, x19
0x00043434  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00043438  mov      x29, x29
0x0004343c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043440  mov      x25, x0
0x00043444  mov      x0, x23
0x00043448  mov      x2, x25
0x0004344c  bl       #0x57ba0   ; CALL objc_msgSend$fileURLWithPath:
0x00043450  mov      x29, x29
0x00043454  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043458  mov      x23, x0
0x0004345c  mov      x0, x22
0x00043460  mov      x2, x23
0x00043464  bl       #0x59800   ; CALL objc_msgSend$playerWithURL:
0x00043468  mov      x29, x29
0x0004346c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043470  mov      x22, x0
0x00043474  mov      x0, x21
0x00043478  mov      x2, x22
0x0004347c  bl       #0x5bbe0   ; CALL objc_msgSend$setPlayer:
0x00043480  mov      x0, x22
0x00043484  bl       #0x55d78   ; CALL _objc_release
0x00043488  mov      x0, x23
0x0004348c  bl       #0x55d78   ; CALL _objc_release
0x00043490  mov      x0, x25
0x00043494  bl       #0x55d78   ; CALL _objc_release
0x00043498  mov      x0, x24
0x0004349c  bl       #0x55d78   ; CALL _objc_release
0x000434a0  adrp     x8, #0x74000
0x000434a4  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x000434a8  str      x8, [sp]
0x000434ac  adrp     x8, #0x65000
0x000434b0  ldr      d0, [x8, #0x600]
0x000434b4  adrp     x8, #0x43000
0x000434b8  add      x8, x8, #0x53c
0x000434bc  str      d0, [sp, #8]
0x000434c0  adrp     x9, #0x74000
0x000434c4  add      x9, x9, #0x6e0
0x000434c8  stp      x8, x9, [sp, #0x10]
0x000434cc  str      x21, [sp, #0x20]
0x000434d0  mov      x0, x21
0x000434d4  bl       #0x55d84   ; CALL _objc_retain
0x000434d8  mov      x4, sp
0x000434dc  mov      x0, x20
0x000434e0  mov      x2, x21
0x000434e4  mov      w3, #1
0x000434e8  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x000434ec  ldr      x0, [sp, #0x20]
0x000434f0  bl       #0x55d78   ; CALL _objc_release
0x000434f4  mov      x0, x21
0x000434f8  bl       #0x55d78   ; CALL _objc_release
0x000434fc  mov      x0, x19
0x00043500  bl       #0x55d78   ; CALL _objc_release
0x00043504  ldur     x8, [x29, #-0x48]
0x00043508  adrp     x9, #0x74000
0x0004350c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00043510  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00043514  cmp      x9, x8
0x00043518  b.ne     #0x43538
0x0004351c  add      sp, sp, #0x430
0x00043520  ldp      x29, x30, [sp, #0x40]
0x00043524  ldp      x20, x19, [sp, #0x30]
0x00043528  ldp      x22, x21, [sp, #0x20]
0x0004352c  ldp      x24, x23, [sp, #0x10]
0x00043530  ldp      x26, x25, [sp], #0x50
0x00043534  ret      
0x00043538  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0004353c  stp      x20, x19, [sp, #-0x20]!
0x00043540  stp      x29, x30, [sp, #0x10]
0x00043544  add      x29, sp, #0x10
0x00043548  ldr      x0, [x0, #0x20]   ; @STR "STARTUPSCREEN_NO_VIDEO_DELETE"
0x0004354c  bl       #0x597e0   ; CALL objc_msgSend$player
0x00043550  mov      x29, x29
0x00043554  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043558  mov      x19, x0
0x0004355c  bl       #0x59760   ; CALL objc_msgSend$play
0x00043560  mov      x0, x19
0x00043564  ldp      x29, x30, [sp, #0x10]
0x00043568  ldp      x20, x19, [sp], #0x20
0x0004356c  b        #0x55d78   ; CALL _objc_release

=== -[OMCStartupScreenController deleteVideo]  va=0x43570 size=1076 types=v16@0:8
0x00043570  sub      sp, sp, #0x90
0x00043574  stp      x26, x25, [sp, #0x40]
0x00043578  stp      x24, x23, [sp, #0x50]
0x0004357c  stp      x22, x21, [sp, #0x60]
0x00043580  stp      x20, x19, [sp, #0x70]
0x00043584  stp      x29, x30, [sp, #0x80]
0x00043588  add      x29, sp, #0x80
0x0004358c  mov      x20, x0
0x00043590  bl       #0x5a1e0   ; CALL objc_msgSend$selectedVideo
0x00043594  mov      x29, x29
0x00043598  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004359c  mov      x19, x0
0x000435a0  cbz      x0, #0x43760
0x000435a4  adrp     x8, #0x8e000
0x000435a8  ldr      x21, [x8, #0x958]   ; @CLASS NSString
0x000435ac  adrp     x0, #0x7c000
0x000435b0  add      x0, x0, #0xb48   ; STR "STARTUPSCREEN_DELETE_CONFIRM"
0x000435b4  bl       #0x17e20   ; CALL _L
0x000435b8  mov      x29, x29
0x000435bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000435c0  mov      x22, x0
0x000435c4  mov      x0, x19
0x000435c8  bl       #0x5d480   ; CALL objc_msgSend$stringByDeletingPathExtension
0x000435cc  mov      x29, x29
0x000435d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000435d4  mov      x23, x0
0x000435d8  str      x0, [sp]
0x000435dc  mov      x0, x21
0x000435e0  mov      x2, x22
0x000435e4  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x000435e8  mov      x29, x29
0x000435ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000435f0  mov      x21, x0
0x000435f4  mov      x0, x23
0x000435f8  bl       #0x55d78   ; CALL _objc_release
0x000435fc  mov      x0, x22
0x00043600  bl       #0x55d78   ; CALL _objc_release
0x00043604  adrp     x8, #0x8e000
0x00043608  ldr      x22, [x8, #0x9b8]   ; @CLASS UIAlertController
0x0004360c  adrp     x0, #0x7c000
0x00043610  add      x0, x0, #0xb68   ; STR "STARTUPSCREEN_DELETE_TITLE"
0x00043614  bl       #0x17e20   ; CALL _L
0x00043618  mov      x29, x29
0x0004361c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043620  mov      x23, x0
0x00043624  mov      x0, x22
0x00043628  mov      x2, x23
0x0004362c  mov      x3, x21
0x00043630  mov      w4, #1
0x00043634  bl       #0x56280   ; CALL objc_msgSend$alertControllerWithTitle:message:preferredStyle:
0x00043638  mov      x29, x29
0x0004363c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043640  mov      x22, x0
0x00043644  mov      x0, x23
0x00043648  bl       #0x55d78   ; CALL _objc_release
0x0004364c  adrp     x25, #0x8e000
0x00043650  ldr      x23, [x25, #0x9c0]   ; @CLASS UIAlertAction
0x00043654  adrp     x0, #0x78000
0x00043658  add      x0, x0, #0x9e8   ; STR "CANCEL"
0x0004365c  bl       #0x17e20   ; CALL _L
0x00043660  mov      x29, x29
0x00043664  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043668  mov      x24, x0
0x0004366c  mov      x0, x23
0x00043670  mov      x2, x24
0x00043674  mov      w3, #1
0x00043678  mov      x4, #0
0x0004367c  bl       #0x55fc0   ; CALL objc_msgSend$actionWithTitle:style:handler:
0x00043680  mov      x29, x29
0x00043684  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043688  mov      x23, x0
0x0004368c  mov      x0, x22
0x00043690  mov      x2, x23
0x00043694  bl       #0x56000   ; CALL objc_msgSend$addAction:
0x00043698  mov      x0, x23
0x0004369c  bl       #0x55d78   ; CALL _objc_release
0x000436a0  mov      x0, x24
0x000436a4  bl       #0x55d78   ; CALL _objc_release
0x000436a8  ldr      x23, [x25, #0x9c0]   ; @CLASS UIAlertAction
0x000436ac  adrp     x0, #0x7c000
0x000436b0  add      x0, x0, #0xb88   ; STR "STARTUPSCREEN_DELETE_ACTION"
0x000436b4  bl       #0x17e20   ; CALL _L
0x000436b8  mov      x29, x29
0x000436bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000436c0  mov      x24, x0
0x000436c4  adrp     x8, #0x74000
0x000436c8  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x000436cc  str      x8, [sp, #0x10]
0x000436d0  adrp     x8, #0x65000
0x000436d4  ldr      d0, [x8, #0x600]
0x000436d8  str      d0, [sp, #0x18]
0x000436dc  adrp     x8, #0x43000
0x000436e0  add      x8, x8, #0x7b0
0x000436e4  adrp     x9, #0x74000
0x000436e8  add      x9, x9, #0xdf8
0x000436ec  stp      x8, x9, [sp, #0x20]
0x000436f0  mov      x0, x19
0x000436f4  bl       #0x55d84   ; CALL _objc_retain
0x000436f8  stp      x19, x20, [sp, #0x30]
0x000436fc  add      x4, sp, #0x10
0x00043700  mov      x0, x23
0x00043704  mov      x2, x24
0x00043708  mov      w3, #2
0x0004370c  bl       #0x55fc0   ; CALL objc_msgSend$actionWithTitle:style:handler:
0x00043710  mov      x29, x29
0x00043714  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043718  mov      x23, x0
0x0004371c  mov      x0, x22
0x00043720  mov      x2, x23
0x00043724  bl       #0x56000   ; CALL objc_msgSend$addAction:
0x00043728  mov      x0, x23
0x0004372c  bl       #0x55d78   ; CALL _objc_release
0x00043730  mov      x0, x24
0x00043734  bl       #0x55d78   ; CALL _objc_release
0x00043738  mov      x0, x20
0x0004373c  mov      x2, x22
0x00043740  mov      w3, #1
0x00043744  mov      x4, #0
0x00043748  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x0004374c  ldr      x0, [sp, #0x30]
0x00043750  bl       #0x55d78   ; CALL _objc_release
0x00043754  mov      x0, x22
0x00043758  bl       #0x55d78   ; CALL _objc_release
0x0004375c  b        #0x43784
0x00043760  adrp     x0, #0x7c000
0x00043764  add      x0, x0, #0xb28   ; STR "STARTUPSCREEN_NO_VIDEO_DELETE"
0x00043768  bl       #0x17e20   ; CALL _L
0x0004376c  mov      x29, x29
0x00043770  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043774  mov      x21, x0
0x00043778  mov      x0, x20
0x0004377c  mov      x2, x21
0x00043780  bl       #0x5ca40   ; CALL objc_msgSend$showMessage:
0x00043784  mov      x0, x21
0x00043788  bl       #0x55d78   ; CALL _objc_release
0x0004378c  mov      x0, x19
0x00043790  bl       #0x55d78   ; CALL _objc_release
0x00043794  ldp      x29, x30, [sp, #0x80]
0x00043798  ldp      x20, x19, [sp, #0x70]
0x0004379c  ldp      x22, x21, [sp, #0x60]
0x000437a0  ldp      x24, x23, [sp, #0x50]
0x000437a4  ldp      x26, x25, [sp, #0x40]
0x000437a8  add      sp, sp, #0x90
0x000437ac  ret      
0x000437b0  stp      x28, x27, [sp, #-0x50]!
0x000437b4  stp      x24, x23, [sp, #0x10]
0x000437b8  stp      x22, x21, [sp, #0x20]
0x000437bc  stp      x20, x19, [sp, #0x30]
0x000437c0  stp      x29, x30, [sp, #0x40]
0x000437c4  add      x29, sp, #0x40
0x000437c8  sub      sp, sp, #0x410
0x000437cc  mov      x19, x0
0x000437d0  adrp     x8, #0x74000
0x000437d4  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000437d8  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000437dc  stur     x8, [x29, #-0x48]
0x000437e0  adrp     x24, #0x8e000
0x000437e4  ldr      x0, [x24, #0x990]   ; @CLASS NSFileManager
0x000437e8  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x000437ec  mov      x29, x29
0x000437f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000437f4  mov      x20, x0
0x000437f8  adrp     x0, #0x76000
0x000437fc  add      x0, x0, #0xb68   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Videos"
0x00043800  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00043804  add      x1, sp, #8
0x00043808  bl       #0x4118
0x0004380c  adrp     x23, #0x8e000
0x00043810  cbz      x0, #0x43830
0x00043814  mov      x2, x0
0x00043818  ldr      x0, [x23, #0x958]   ; @CLASS NSString
0x0004381c  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00043820  mov      x29, x29
0x00043824  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043828  mov      x21, x0
0x0004382c  b        #0x43834
0x00043830  mov      x21, #0
0x00043834  ldr      x2, [x19, #0x20]
0x00043838  mov      x0, x21
0x0004383c  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00043840  mov      x29, x29
0x00043844  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043848  mov      x22, x0
0x0004384c  mov      x0, x20
0x00043850  mov      x2, x22
0x00043854  mov      x3, #0
0x00043858  bl       #0x59e20   ; CALL objc_msgSend$removeItemAtPath:error:
0x0004385c  mov      x0, x22
0x00043860  bl       #0x55d78   ; CALL _objc_release
0x00043864  mov      x0, x21
0x00043868  bl       #0x55d78   ; CALL _objc_release
0x0004386c  mov      x0, x20
0x00043870  bl       #0x55d78   ; CALL _objc_release
0x00043874  ldr      x0, [x24, #0x990]   ; @CLASS NSFileManager
0x00043878  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x0004387c  mov      x29, x29
0x00043880  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043884  mov      x20, x0
0x00043888  adrp     x0, #0x76000
0x0004388c  add      x0, x0, #0xb68   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Videos"
0x00043890  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00043894  add      x1, sp, #8
0x00043898  bl       #0x4118
0x0004389c  cbz      x0, #0x438bc
0x000438a0  mov      x2, x0
0x000438a4  ldr      x0, [x23, #0x958]   ; @CLASS NSString
0x000438a8  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x000438ac  mov      x29, x29
0x000438b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000438b4  mov      x21, x0
0x000438b8  b        #0x438c0
0x000438bc  mov      x21, #0
0x000438c0  adrp     x2, #0x76000
0x000438c4  add      x2, x2, #0xb88   ; STR ".frames"
0x000438c8  mov      x0, x21
0x000438cc  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x000438d0  mov      x29, x29
0x000438d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000438d8  mov      x22, x0
0x000438dc  ldr      x2, [x19, #0x20]
0x000438e0  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x000438e4  mov      x29, x29
0x000438e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000438ec  mov      x23, x0
0x000438f0  mov      x0, x20
0x000438f4  mov      x2, x23
0x000438f8  mov      x3, #0
0x000438fc  bl       #0x59e20   ; CALL objc_msgSend$removeItemAtPath:error:
0x00043900  mov      x0, x23
0x00043904  bl       #0x55d78   ; CALL _objc_release
0x00043908  mov      x0, x22
0x0004390c  bl       #0x55d78   ; CALL _objc_release
0x00043910  mov      x0, x21
0x00043914  bl       #0x55d78   ; CALL _objc_release
0x00043918  mov      x0, x20
0x0004391c  bl       #0x55d78   ; CALL _objc_release
0x00043920  ldr      x20, [x19, #0x28]
0x00043924  mov      x0, x20
0x00043928  bl       #0x5df40   ; CALL objc_msgSend$videoFiles
0x0004392c  mov      x29, x29
0x00043930  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043934  mov      x21, x0
0x00043938  bl       #0x57c20   ; CALL objc_msgSend$firstObject
0x0004393c  mov      x29, x29
0x00043940  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043944  mov      x22, x0
0x00043948  mov      x0, x20
0x0004394c  mov      x2, x22
0x00043950  bl       #0x5bf80   ; CALL objc_msgSend$setSelectedVideo:
0x00043954  mov      x0, x22
0x00043958  bl       #0x55d78   ; CALL _objc_release
0x0004395c  mov      x0, x21
0x00043960  bl       #0x55d78   ; CALL _objc_release
0x00043964  ldr      x0, [x19, #0x28]
0x00043968  bl       #0x5dd80   ; CALL objc_msgSend$updatePreview
0x0004396c  ldur     x8, [x29, #-0x48]
0x00043970  adrp     x9, #0x74000
0x00043974  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00043978  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0004397c  cmp      x9, x8
0x00043980  b.ne     #0x439a0
0x00043984  add      sp, sp, #0x410
0x00043988  ldp      x29, x30, [sp, #0x40]
0x0004398c  ldp      x20, x19, [sp, #0x30]
0x00043990  ldp      x22, x21, [sp, #0x20]
0x00043994  ldp      x24, x23, [sp, #0x10]
0x00043998  ldp      x28, x27, [sp], #0x50
0x0004399c  ret      
0x000439a0  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController chooseLogo]  va=0x439a4 size=872 types=v16@0:8
0x000439a4  sub      sp, sp, #0xc0
0x000439a8  stp      d9, d8, [sp, #0x60]
0x000439ac  stp      x26, x25, [sp, #0x70]
0x000439b0  stp      x24, x23, [sp, #0x80]
0x000439b4  stp      x22, x21, [sp, #0x90]
0x000439b8  stp      x20, x19, [sp, #0xa0]
0x000439bc  stp      x29, x30, [sp, #0xb0]
0x000439c0  add      x29, sp, #0xb0
0x000439c4  mov      x20, x0
0x000439c8  adrp     x8, #0x8e000
0x000439cc  ldr      x0, [x8, #0x9b8]   ; @CLASS UIAlertController
0x000439d0  mov      x2, #0
0x000439d4  mov      x3, #0
0x000439d8  mov      x4, #0
0x000439dc  bl       #0x56280   ; CALL objc_msgSend$alertControllerWithTitle:message:preferredStyle:
0x000439e0  mov      x29, x29
0x000439e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000439e8  mov      x19, x0
0x000439ec  add      x0, sp, #0x58
0x000439f0  mov      x1, x20
0x000439f4  bl       #0x55d18   ; CALL _objc_initWeak
0x000439f8  adrp     x23, #0x8e000
0x000439fc  ldr      x22, [x23, #0x9c0]   ; @CLASS UIAlertAction
0x00043a00  adrp     x0, #0x7c000
0x00043a04  add      x0, x0, #0xac8   ; STR "STARTUPSCREEN_FROM_PHOTOS"
0x00043a08  bl       #0x17e20   ; CALL _L
0x00043a0c  mov      x29, x29
0x00043a10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043a14  mov      x21, x0
0x00043a18  adrp     x25, #0x74000
0x00043a1c  ldr      x25, [x25, #0x378]   ; @GOT __NSConcreteStackBlock
0x00043a20  str      x25, [sp, #0x30]
0x00043a24  adrp     x8, #0x65000
0x00043a28  ldr      d8, [x8, #0x600]
0x00043a2c  adrp     x8, #0x43000
0x00043a30  add      x8, x8, #0xcb4
0x00043a34  str      d8, [sp, #0x38]
0x00043a38  adrp     x26, #0x74000
0x00043a3c  add      x26, x26, #0x850
0x00043a40  stp      x8, x26, [sp, #0x40]
0x00043a44  add      x24, sp, #0x30
0x00043a48  add      x0, x24, #0x20
0x00043a4c  add      x1, sp, #0x58
0x00043a50  bl       #0x55cd0   ; CALL _objc_copyWeak
0x00043a54  add      x4, sp, #0x30
0x00043a58  mov      x0, x22
0x00043a5c  mov      x2, x21
0x00043a60  mov      x3, #0
0x00043a64  bl       #0x55fc0   ; CALL objc_msgSend$actionWithTitle:style:handler:
0x00043a68  mov      x29, x29
0x00043a6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043a70  mov      x22, x0
0x00043a74  mov      x0, x19
0x00043a78  mov      x2, x22
0x00043a7c  bl       #0x56000   ; CALL objc_msgSend$addAction:
0x00043a80  mov      x0, x22
0x00043a84  bl       #0x55d78   ; CALL _objc_release
0x00043a88  mov      x0, x21
0x00043a8c  bl       #0x55d78   ; CALL _objc_release
0x00043a90  ldr      x22, [x23, #0x9c0]   ; @CLASS UIAlertAction
0x00043a94  adrp     x0, #0x7c000
0x00043a98  add      x0, x0, #0xae8   ; STR "STARTUPSCREEN_FROM_FILES"
0x00043a9c  bl       #0x17e20   ; CALL _L
0x00043aa0  mov      x29, x29
0x00043aa4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043aa8  mov      x21, x0
0x00043aac  str      x25, [sp, #8]
0x00043ab0  str      d8, [sp, #0x10]
0x00043ab4  adrp     x8, #0x43000
0x00043ab8  add      x8, x8, #0xce0
0x00043abc  stp      x8, x26, [sp, #0x18]
0x00043ac0  add      x25, sp, #8
0x00043ac4  add      x0, x25, #0x20   ; GOT _objc_autoreleasePoolPop
0x00043ac8  add      x1, sp, #0x58
0x00043acc  bl       #0x55cd0   ; CALL _objc_copyWeak
0x00043ad0  add      x4, sp, #8
0x00043ad4  mov      x0, x22
0x00043ad8  mov      x2, x21
0x00043adc  mov      x3, #0
0x00043ae0  bl       #0x55fc0   ; CALL objc_msgSend$actionWithTitle:style:handler:
0x00043ae4  mov      x29, x29
0x00043ae8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043aec  mov      x22, x0
0x00043af0  mov      x0, x19
0x00043af4  mov      x2, x22
0x00043af8  bl       #0x56000   ; CALL objc_msgSend$addAction:
0x00043afc  mov      x0, x22
0x00043b00  bl       #0x55d78   ; CALL _objc_release
0x00043b04  mov      x0, x21
0x00043b08  bl       #0x55d78   ; CALL _objc_release
0x00043b0c  ldr      x22, [x23, #0x9c0]   ; @CLASS UIAlertAction
0x00043b10  adrp     x0, #0x78000
0x00043b14  add      x0, x0, #0x9e8   ; STR "CANCEL"
0x00043b18  bl       #0x17e20   ; CALL _L
0x00043b1c  mov      x29, x29
0x00043b20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043b24  mov      x21, x0
0x00043b28  mov      x0, x22
0x00043b2c  mov      x2, x21
0x00043b30  mov      w3, #1
0x00043b34  mov      x4, #0
0x00043b38  bl       #0x55fc0   ; CALL objc_msgSend$actionWithTitle:style:handler:
0x00043b3c  mov      x29, x29
0x00043b40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043b44  mov      x22, x0
0x00043b48  mov      x0, x19
0x00043b4c  mov      x2, x22
0x00043b50  bl       #0x56000   ; CALL objc_msgSend$addAction:
0x00043b54  mov      x0, x22
0x00043b58  bl       #0x55d78   ; CALL _objc_release
0x00043b5c  mov      x0, x21
0x00043b60  bl       #0x55d78   ; CALL _objc_release
0x00043b64  mov      x0, x20
0x00043b68  bl       #0x5df60   ; CALL objc_msgSend$view
0x00043b6c  mov      x29, x29
0x00043b70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043b74  mov      x21, x0
0x00043b78  mov      x0, x19
0x00043b7c  bl       #0x59840   ; CALL objc_msgSend$popoverPresentationController
0x00043b80  mov      x29, x29
0x00043b84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043b88  mov      x22, x0
0x00043b8c  mov      x2, x21
0x00043b90  bl       #0x5c220   ; CALL objc_msgSend$setSourceView:
0x00043b94  mov      x0, x22
0x00043b98  bl       #0x55d78   ; CALL _objc_release
0x00043b9c  mov      x0, x21
0x00043ba0  bl       #0x55d78   ; CALL _objc_release
0x00043ba4  mov      x0, x20
0x00043ba8  bl       #0x5df60   ; CALL objc_msgSend$view
0x00043bac  mov      x29, x29
0x00043bb0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043bb4  mov      x21, x0
0x00043bb8  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00043bbc  bl       #0x55a60   ; CALL _CGRectGetMidX
0x00043bc0  mov      v8.16b, v0.16b
0x00043bc4  mov      x0, x20
0x00043bc8  bl       #0x5df60   ; CALL objc_msgSend$view
0x00043bcc  mov      x29, x29
0x00043bd0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043bd4  mov      x22, x0
0x00043bd8  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00043bdc  bl       #0x55a6c   ; CALL _CGRectGetMidY
0x00043be0  mov      v9.16b, v0.16b
0x00043be4  mov      x0, x19
0x00043be8  bl       #0x59840   ; CALL objc_msgSend$popoverPresentationController
0x00043bec  mov      x29, x29
0x00043bf0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043bf4  mov      x23, x0
0x00043bf8  fmov     d2, #1.00000000
0x00043bfc  fmov     d3, #1.00000000
0x00043c00  mov      v0.16b, v8.16b
0x00043c04  mov      v1.16b, v9.16b
0x00043c08  bl       #0x5c1e0   ; CALL objc_msgSend$setSourceRect:
0x00043c0c  mov      x0, x23
0x00043c10  bl       #0x55d78   ; CALL _objc_release
0x00043c14  mov      x0, x22
0x00043c18  bl       #0x55d78   ; CALL _objc_release
0x00043c1c  mov      x0, x21
0x00043c20  bl       #0x55d78   ; CALL _objc_release
0x00043c24  mov      x0, x20
0x00043c28  mov      x2, x19
0x00043c2c  mov      w3, #1
0x00043c30  mov      x4, #0
0x00043c34  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x00043c38  add      x0, x25, #0x20   ; GOT _objc_autoreleasePoolPop
0x00043c3c  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00043c40  add      x0, x24, #0x20
0x00043c44  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00043c48  add      x0, sp, #0x58
0x00043c4c  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00043c50  mov      x0, x19
0x00043c54  bl       #0x55d78   ; CALL _objc_release
0x00043c58  ldp      x29, x30, [sp, #0xb0]
0x00043c5c  ldp      x20, x19, [sp, #0xa0]
0x00043c60  ldp      x22, x21, [sp, #0x90]
0x00043c64  ldp      x24, x23, [sp, #0x80]
0x00043c68  ldp      x26, x25, [sp, #0x70]
0x00043c6c  ldp      d9, d8, [sp, #0x60]
0x00043c70  add      sp, sp, #0xc0
0x00043c74  ret      
0x00043c78  b        #0x43c88
0x00043c7c  mov      x19, x0
0x00043c80  b        #0x43ca4
0x00043c84  b        #0x43c90
0x00043c88  mov      x19, x0
0x00043c8c  b        #0x43c9c
0x00043c90  mov      x19, x0
0x00043c94  add      x0, x25, #0x20   ; GOT _objc_autoreleasePoolPop
0x00043c98  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00043c9c  add      x0, x24, #0x20
0x00043ca0  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00043ca4  add      x0, sp, #0x58
0x00043ca8  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00043cac  mov      x0, x19
0x00043cb0  bl       #0x55b80   ; CALL __Unwind_Resume
0x00043cb4  stp      x20, x19, [sp, #-0x20]!
0x00043cb8  stp      x29, x30, [sp, #0x10]
0x00043cbc  add      x29, sp, #0x10
0x00043cc0  add      x0, x0, #0x20   ; GOT _objc_copyWeak
0x00043cc4  bl       #0x55d24   ; CALL _objc_loadWeakRetained
0x00043cc8  mov      x19, x0
0x00043ccc  bl       #0x58e80   ; CALL objc_msgSend$logoFromPhotos
0x00043cd0  mov      x0, x19
0x00043cd4  ldp      x29, x30, [sp, #0x10]
0x00043cd8  ldp      x20, x19, [sp], #0x20
0x00043cdc  b        #0x55d78   ; CALL _objc_release
0x00043ce0  stp      x20, x19, [sp, #-0x20]!
0x00043ce4  stp      x29, x30, [sp, #0x10]
0x00043ce8  add      x29, sp, #0x10
0x00043cec  add      x0, x0, #0x20   ; GOT _objc_getAssociatedObject
0x00043cf0  bl       #0x55d24   ; CALL _objc_loadWeakRetained
0x00043cf4  mov      x19, x0
0x00043cf8  bl       #0x58e60   ; CALL objc_msgSend$logoFromFiles
0x00043cfc  mov      x0, x19
0x00043d00  ldp      x29, x30, [sp, #0x10]
0x00043d04  ldp      x20, x19, [sp], #0x20
0x00043d08  b        #0x55d78   ; CALL _objc_release

=== -[OMCStartupScreenController logoFromPhotos]  va=0x43d0c size=252 types=v16@0:8
0x00043d0c  sub      sp, sp, #0x40
0x00043d10  stp      x22, x21, [sp, #0x10]
0x00043d14  stp      x20, x19, [sp, #0x20]
0x00043d18  stp      x29, x30, [sp, #0x30]
0x00043d1c  add      x29, sp, #0x30
0x00043d20  mov      x19, x0
0x00043d24  adrp     x8, #0x74000
0x00043d28  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00043d2c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00043d30  str      x8, [sp, #8]
0x00043d34  mov      w2, #1
0x00043d38  bl       #0x5bb80   ; CALL objc_msgSend$setPickKind:
0x00043d3c  adrp     x8, #0x8e000
0x00043d40  ldr      x0, [x8, #0xb50]   ; @CLASS UIImagePickerController
0x00043d44  bl       #0x55d60   ; CALL _objc_opt_new
0x00043d48  mov      x20, x0
0x00043d4c  mov      x2, #0
0x00043d50  bl       #0x5c200   ; CALL objc_msgSend$setSourceType:
0x00043d54  adrp     x8, #0x74000
0x00043d58  ldr      x8, [x8, #0x310]   ; @GOT _UTTypeImage
0x00043d5c  ldr      x0, [x8]   ; @GOT ___objc_personality_v0
0x00043d60  bl       #0x58060   ; CALL objc_msgSend$identifier
0x00043d64  mov      x29, x29
0x00043d68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043d6c  mov      x21, x0
0x00043d70  str      x0, [sp]
0x00043d74  adrp     x8, #0x8e000
0x00043d78  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00043d7c  mov      x2, sp
0x00043d80  mov      w3, #1
0x00043d84  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00043d88  mov      x29, x29
0x00043d8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043d90  mov      x22, x0
0x00043d94  mov      x0, x20
0x00043d98  mov      x2, x22
0x00043d9c  bl       #0x5b5a0   ; CALL objc_msgSend$setMediaTypes:
0x00043da0  mov      x0, x22
0x00043da4  bl       #0x55d78   ; CALL _objc_release
0x00043da8  mov      x0, x21
0x00043dac  bl       #0x55d78   ; CALL _objc_release
0x00043db0  mov      x0, x20
0x00043db4  mov      x2, x19
0x00043db8  bl       #0x5aca0   ; CALL objc_msgSend$setDelegate:
0x00043dbc  mov      x0, x19
0x00043dc0  mov      x2, x20
0x00043dc4  mov      w3, #1
0x00043dc8  mov      x4, #0
0x00043dcc  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x00043dd0  mov      x0, x20
0x00043dd4  bl       #0x55d78   ; CALL _objc_release
0x00043dd8  ldr      x8, [sp, #8]
0x00043ddc  adrp     x9, #0x74000
0x00043de0  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00043de4  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00043de8  cmp      x9, x8
0x00043dec  b.ne     #0x43e04
0x00043df0  ldp      x29, x30, [sp, #0x30]
0x00043df4  ldp      x20, x19, [sp, #0x20]
0x00043df8  ldp      x22, x21, [sp, #0x10]
0x00043dfc  add      sp, sp, #0x40
0x00043e00  ret      
0x00043e04  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController logoFromFiles]  va=0x43e08 size=228 types=v16@0:8
0x00043e08  sub      sp, sp, #0x40
0x00043e0c  stp      x22, x21, [sp, #0x10]
0x00043e10  stp      x20, x19, [sp, #0x20]
0x00043e14  stp      x29, x30, [sp, #0x30]
0x00043e18  add      x29, sp, #0x30
0x00043e1c  mov      x19, x0
0x00043e20  adrp     x8, #0x74000
0x00043e24  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00043e28  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00043e2c  str      x8, [sp, #8]
0x00043e30  mov      w2, #1
0x00043e34  bl       #0x5bb80   ; CALL objc_msgSend$setPickKind:
0x00043e38  adrp     x8, #0x8e000
0x00043e3c  ldr      x0, [x8, #0xc90]   ; @CLASS UIDocumentPickerViewController
0x00043e40  bl       #0x55c7c   ; CALL _objc_alloc
0x00043e44  mov      x20, x0
0x00043e48  adrp     x8, #0x74000
0x00043e4c  ldr      x8, [x8, #0x310]   ; @GOT _UTTypeImage
0x00043e50  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00043e54  str      x8, [sp]
0x00043e58  adrp     x8, #0x8e000
0x00043e5c  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00043e60  mov      x2, sp
0x00043e64  mov      w3, #1
0x00043e68  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00043e6c  mov      x29, x29
0x00043e70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043e74  mov      x21, x0
0x00043e78  mov      x0, x20
0x00043e7c  mov      x2, x21
0x00043e80  mov      w3, #1
0x00043e84  bl       #0x58360   ; CALL objc_msgSend$initForOpeningContentTypes:asCopy:
0x00043e88  mov      x20, x0
0x00043e8c  mov      x0, x21
0x00043e90  bl       #0x55d78   ; CALL _objc_release
0x00043e94  mov      x0, x20
0x00043e98  mov      x2, x19
0x00043e9c  bl       #0x5aca0   ; CALL objc_msgSend$setDelegate:
0x00043ea0  mov      x0, x19
0x00043ea4  mov      x2, x20
0x00043ea8  mov      w3, #1
0x00043eac  mov      x4, #0
0x00043eb0  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x00043eb4  mov      x0, x20
0x00043eb8  bl       #0x55d78   ; CALL _objc_release
0x00043ebc  ldr      x8, [sp, #8]
0x00043ec0  adrp     x9, #0x74000
0x00043ec4  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00043ec8  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00043ecc  cmp      x9, x8
0x00043ed0  b.ne     #0x43ee8
0x00043ed4  ldp      x29, x30, [sp, #0x30]
0x00043ed8  ldp      x20, x19, [sp, #0x20]
0x00043edc  ldp      x22, x21, [sp, #0x10]
0x00043ee0  add      sp, sp, #0x40
0x00043ee4  ret      
0x00043ee8  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController saveLogoImage:]  va=0x43eec size=1148 types=v24@0:8@16
0x00043eec  stp      d9, d8, [sp, #-0x70]!
0x00043ef0  stp      x28, x27, [sp, #0x10]
0x00043ef4  stp      x26, x25, [sp, #0x20]
0x00043ef8  stp      x24, x23, [sp, #0x30]
0x00043efc  stp      x22, x21, [sp, #0x40]
0x00043f00  stp      x20, x19, [sp, #0x50]
0x00043f04  stp      x29, x30, [sp, #0x60]
0x00043f08  add      x29, sp, #0x60
0x00043f0c  sub      sp, sp, #0x470
0x00043f10  mov      x19, x2
0x00043f14  mov      x20, x0
0x00043f18  adrp     x8, #0x74000
0x00043f1c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00043f20  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00043f24  stur     x8, [x29, #-0x70]
0x00043f28  mov      x0, x2
0x00043f2c  bl       #0x55d84   ; CALL _objc_retain
0x00043f30  cbz      x19, #0x440d4
0x00043f34  mov      x0, x19
0x00043f38  bl       #0x5cba0   ; CALL objc_msgSend$size
0x00043f3c  fcmp     d0, #0.0
0x00043f40  b.ls     #0x440d4
0x00043f44  mov      x0, x19
0x00043f48  bl       #0x5cba0   ; CALL objc_msgSend$size
0x00043f4c  fcmp     d1, #0.0
0x00043f50  b.ls     #0x440d4
0x00043f54  mov      x0, x19
0x00043f58  bl       #0x5cba0   ; CALL objc_msgSend$size
0x00043f5c  mov      v8.16b, v0.16b
0x00043f60  mov      x0, x19
0x00043f64  bl       #0x5a060   ; CALL objc_msgSend$scale
0x00043f68  fmul     d9, d8, d0
0x00043f6c  mov      x0, x19
0x00043f70  bl       #0x5cba0   ; CALL objc_msgSend$size
0x00043f74  mov      v8.16b, v1.16b
0x00043f78  mov      x0, x19
0x00043f7c  bl       #0x5a060   ; CALL objc_msgSend$scale
0x00043f80  fmul     d0, d8, d0
0x00043f84  fcmp     d9, d0
0x00043f88  fcsel    d1, d0, d9, mi
0x00043f8c  mov      x8, #0x4090000000000000
0x00043f90  fmov     d2, x8
0x00043f94  fdiv     d1, d2, d1
0x00043f98  fmov     d2, #1.00000000
0x00043f9c  fcmp     d1, d2
0x00043fa0  fcsel    d1, d2, d1, gt
0x00043fa4  fmul     d3, d9, d1
0x00043fa8  frinta   d3, d3
0x00043fac  fmaxnm   d8, d3, d2
0x00043fb0  fmul     d0, d0, d1
0x00043fb4  frinta   d0, d0
0x00043fb8  fmaxnm   d9, d0, d2
0x00043fbc  adrp     x8, #0x8e000
0x00043fc0  ldr      x0, [x8, #0xb58]   ; @CLASS UIGraphicsImageRendererFormat
0x00043fc4  bl       #0x59920   ; CALL objc_msgSend$preferredFormat
0x00043fc8  mov      x29, x29
0x00043fcc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00043fd0  mov      x21, x0
0x00043fd4  fmov     d0, #1.00000000
0x00043fd8  bl       #0x5bee0   ; CALL objc_msgSend$setScale:
0x00043fdc  mov      x0, x21
0x00043fe0  mov      w2, #0
0x00043fe4  bl       #0x5b960   ; CALL objc_msgSend$setOpaque:
0x00043fe8  mov      x0, x21
0x00043fec  mov      w2, #2
0x00043ff0  bl       #0x5bc60   ; CALL objc_msgSend$setPreferredRange:
0x00043ff4  adrp     x8, #0x8e000
0x00043ff8  ldr      x0, [x8, #0xb00]   ; @CLASS UIGraphicsImageRenderer
0x00043ffc  bl       #0x55c7c   ; CALL _objc_alloc
0x00044000  mov      v0.16b, v8.16b
0x00044004  mov      v1.16b, v9.16b
0x00044008  mov      x2, x21
0x0004400c  bl       #0x58560   ; CALL objc_msgSend$initWithSize:format:
0x00044010  mov      x23, x0
0x00044014  adrp     x8, #0x74000
0x00044018  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x0004401c  str      x8, [sp, #0x18]
0x00044020  adrp     x8, #0x65000
0x00044024  ldr      d0, [x8, #0x600]
0x00044028  str      d0, [sp, #0x20]
0x0004402c  adrp     x8, #0x44000
0x00044030  add      x8, x8, #0x350
0x00044034  adrp     x9, #0x74000
0x00044038  add      x9, x9, #0xa40
0x0004403c  stp      x8, x9, [sp, #0x28]
0x00044040  mov      x0, x19
0x00044044  bl       #0x55d84   ; CALL _objc_retain
0x00044048  str      x19, [sp, #0x38]
0x0004404c  stp      d8, d9, [sp, #0x40]
0x00044050  add      x2, sp, #0x18
0x00044054  mov      x0, x23
0x00044058  bl       #0x58140   ; CALL objc_msgSend$imageWithActions:
0x0004405c  mov      x29, x29
0x00044060  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044064  mov      x22, x0
0x00044068  mov      x0, x23
0x0004406c  bl       #0x55d78   ; CALL _objc_release
0x00044070  mov      x0, x22
0x00044074  bl       #0x55b50   ; CALL _UIImagePNGRepresentation
0x00044078  mov      x29, x29
0x0004407c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044080  mov      x23, x0
0x00044084  adrp     x8, #0x8e000
0x00044088  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x0004408c  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x00044090  mov      x29, x29
0x00044094  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044098  mov      x24, x0
0x0004409c  adrp     x0, #0x7c000
0x000440a0  add      x0, x0, #0x708   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Logo/logo.png"
0x000440a4  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x000440a8  add      x1, sp, #0x60
0x000440ac  bl       #0x4118
0x000440b0  adrp     x28, #0x8e000
0x000440b4  cbz      x0, #0x44144
0x000440b8  mov      x2, x0
0x000440bc  ldr      x0, [x28, #0x958]   ; @CLASS NSString
0x000440c0  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x000440c4  mov      x29, x29
0x000440c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000440cc  mov      x25, x0
0x000440d0  b        #0x44148
0x000440d4  adrp     x0, #0x7c000
0x000440d8  add      x0, x0, #0xba8   ; STR "STARTUPSCREEN_LOGO_FAILED"
0x000440dc  bl       #0x17e20   ; CALL _L
0x000440e0  mov      x29, x29
0x000440e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000440e8  mov      x21, x0
0x000440ec  mov      x0, x20
0x000440f0  mov      x2, x21
0x000440f4  bl       #0x5ca40   ; CALL objc_msgSend$showMessage:
0x000440f8  mov      x0, x21
0x000440fc  bl       #0x55d78   ; CALL _objc_release
0x00044100  mov      x0, x19
0x00044104  bl       #0x55d78   ; CALL _objc_release
0x00044108  ldur     x8, [x29, #-0x70]
0x0004410c  adrp     x9, #0x74000
0x00044110  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00044114  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00044118  cmp      x9, x8
0x0004411c  b.ne     #0x4434c
0x00044120  add      sp, sp, #0x470
0x00044124  ldp      x29, x30, [sp, #0x60]
0x00044128  ldp      x20, x19, [sp, #0x50]
0x0004412c  ldp      x22, x21, [sp, #0x40]
0x00044130  ldp      x24, x23, [sp, #0x30]
0x00044134  ldp      x26, x25, [sp, #0x20]
0x00044138  ldp      x28, x27, [sp, #0x10]
0x0004413c  ldp      d9, d8, [sp], #0x70
0x00044140  ret      
0x00044144  mov      x25, #0
0x00044148  mov      x0, x25
0x0004414c  bl       #0x5d460   ; CALL objc_msgSend$stringByDeletingLastPathComponent
0x00044150  mov      x29, x29
0x00044154  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044158  mov      x26, x0
0x0004415c  mov      x0, x24
0x00044160  mov      x2, x26
0x00044164  mov      w3, #1
0x00044168  mov      x4, #0
0x0004416c  mov      x5, #0
0x00044170  bl       #0x57400   ; CALL objc_msgSend$createDirectoryAtPath:withIntermediateDirectories:attributes:error:
0x00044174  mov      x0, x26
0x00044178  bl       #0x55d78   ; CALL _objc_release
0x0004417c  mov      x0, x25
0x00044180  bl       #0x55d78   ; CALL _objc_release
0x00044184  cbz      x23, #0x441bc
0x00044188  adrp     x0, #0x7c000
0x0004418c  add      x0, x0, #0x708   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Logo/logo.png"
0x00044190  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00044194  add      x1, sp, #0x60
0x00044198  bl       #0x4118
0x0004419c  cbz      x0, #0x441c4
0x000441a0  mov      x2, x0
0x000441a4  ldr      x0, [x28, #0x958]   ; @CLASS NSString
0x000441a8  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x000441ac  mov      x29, x29
0x000441b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000441b4  mov      x26, x0
0x000441b8  b        #0x441c8
0x000441bc  mov      x25, #0
0x000441c0  b        #0x4426c
0x000441c4  mov      x26, #0
0x000441c8  str      xzr, [sp, #0x10]
0x000441cc  add      x4, sp, #0x10
0x000441d0  mov      x0, x23
0x000441d4  mov      x2, x26
0x000441d8  mov      w3, #1
0x000441dc  bl       #0x5e260   ; CALL objc_msgSend$writeToFile:options:error:
0x000441e0  mov      x27, x0
0x000441e4  ldr      x25, [sp, #0x10]
0x000441e8  mov      x0, x25
0x000441ec  bl       #0x55d84   ; CALL _objc_retain
0x000441f0  mov      x0, x26
0x000441f4  bl       #0x55d78   ; CALL _objc_release
0x000441f8  tbz      w27, #0, #0x4426c
0x000441fc  adrp     x8, #0x74000
0x00044200  ldr      x8, [x8, #0x120]   ; @GOT _NSFilePosixPermissions
0x00044204  ldr      x9, [x8]   ; @GOT ___objc_personality_v0
0x00044208  adrp     x8, #0x80000
0x0004420c  add      x8, x8, #0x460
0x00044210  stp      x9, x8, [sp, #0x50]
0x00044214  adrp     x8, #0x8e000
0x00044218  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x0004421c  add      x2, sp, #0x58
0x00044220  add      x3, sp, #0x50
0x00044224  mov      w4, #1
0x00044228  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0004422c  mov      x29, x29
0x00044230  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044234  mov      x26, x0
0x00044238  adrp     x0, #0x7c000
0x0004423c  add      x0, x0, #0x708   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Logo/logo.png"
0x00044240  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00044244  add      x1, sp, #0x60
0x00044248  bl       #0x4118
0x0004424c  cbz      x0, #0x442f0
0x00044250  mov      x2, x0
0x00044254  ldr      x0, [x28, #0x958]   ; @CLASS NSString
0x00044258  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0004425c  mov      x29, x29
0x00044260  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044264  mov      x27, x0
0x00044268  b        #0x442f4
0x0004426c  ldr      x26, [x28, #0x958]   ; @CLASS NSString
0x00044270  adrp     x0, #0x7c000
0x00044274  add      x0, x0, #0xaa8   ; STR "STARTUPSCREEN_SAVE_FAILED"
0x00044278  bl       #0x17e20   ; CALL _L
0x0004427c  mov      x29, x29
0x00044280  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044284  mov      x27, x0
0x00044288  mov      x0, x25
0x0004428c  bl       #0x58dc0   ; CALL objc_msgSend$localizedDescription
0x00044290  mov      x29, x29
0x00044294  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044298  mov      x28, x0
0x0004429c  adrp     x8, #0x7c000
0x000442a0  add      x8, x8, #0xbc8   ; STR "PNG"
0x000442a4  cmp      x0, #0
0x000442a8  csel     x8, x8, x0, eq
0x000442ac  str      x8, [sp]
0x000442b0  mov      x0, x26
0x000442b4  mov      x2, x27
0x000442b8  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x000442bc  mov      x29, x29
0x000442c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000442c4  mov      x26, x0
0x000442c8  mov      x0, x20
0x000442cc  mov      x2, x26
0x000442d0  bl       #0x5ca40   ; CALL objc_msgSend$showMessage:
0x000442d4  mov      x0, x26
0x000442d8  bl       #0x55d78   ; CALL _objc_release
0x000442dc  mov      x0, x28
0x000442e0  bl       #0x55d78   ; CALL _objc_release
0x000442e4  mov      x0, x27
0x000442e8  bl       #0x55d78   ; CALL _objc_release
0x000442ec  b        #0x44320
0x000442f0  mov      x27, #0
0x000442f4  mov      x0, x24
0x000442f8  mov      x2, x26
0x000442fc  mov      x3, x27
0x00044300  mov      x4, #0
0x00044304  bl       #0x5a4e0   ; CALL objc_msgSend$setAttributes:ofItemAtPath:error:
0x00044308  mov      x0, x27
0x0004430c  bl       #0x55d78   ; CALL _objc_release
0x00044310  mov      x0, x26
0x00044314  bl       #0x55d78   ; CALL _objc_release
0x00044318  mov      x0, x20
0x0004431c  bl       #0x5dd80   ; CALL objc_msgSend$updatePreview
0x00044320  mov      x0, x25
0x00044324  bl       #0x55d78   ; CALL _objc_release
0x00044328  mov      x0, x24
0x0004432c  bl       #0x55d78   ; CALL _objc_release
0x00044330  mov      x0, x23
0x00044334  bl       #0x55d78   ; CALL _objc_release
0x00044338  mov      x0, x22
0x0004433c  bl       #0x55d78   ; CALL _objc_release
0x00044340  ldr      x0, [sp, #0x38]
0x00044344  bl       #0x55d78   ; CALL _objc_release
0x00044348  b        #0x440f8
0x0004434c  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00044350  ldr      x8, [x0, #0x20]   ; @STR "STARTUPSCREEN_FROM_PHOTOS"
0x00044354  ldp      d2, d3, [x0, #0x28]
0x00044358  fmov     d0, xzr
0x0004435c  fmov     d1, xzr
0x00044360  mov      x0, x8
0x00044364  b        #0x578e0   ; CALL objc_msgSend$drawInRect:

=== -[OMCStartupScreenController deleteLogo]  va=0x44368 size=384 types=v16@0:8
0x00044368  stp      x24, x23, [sp, #-0x40]!
0x0004436c  stp      x22, x21, [sp, #0x10]
0x00044370  stp      x20, x19, [sp, #0x20]
0x00044374  stp      x29, x30, [sp, #0x30]
0x00044378  add      x29, sp, #0x30
0x0004437c  sub      sp, sp, #0x410
0x00044380  mov      x19, x0
0x00044384  adrp     x8, #0x74000
0x00044388  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0004438c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00044390  stur     x8, [x29, #-0x38]
0x00044394  adrp     x23, #0x8e000
0x00044398  ldr      x0, [x23, #0x990]   ; @CLASS NSFileManager
0x0004439c  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x000443a0  mov      x29, x29
0x000443a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000443a8  mov      x20, x0
0x000443ac  adrp     x0, #0x7c000
0x000443b0  add      x0, x0, #0x708   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Logo/logo.png"
0x000443b4  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x000443b8  add      x1, sp, #8
0x000443bc  bl       #0x4118
0x000443c0  cbz      x0, #0x443e4
0x000443c4  mov      x2, x0
0x000443c8  adrp     x8, #0x8e000
0x000443cc  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x000443d0  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x000443d4  mov      x29, x29
0x000443d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000443dc  mov      x21, x0
0x000443e0  b        #0x443e8
0x000443e4  mov      x21, #0
0x000443e8  mov      x0, x20
0x000443ec  mov      x2, x21
0x000443f0  bl       #0x57b40   ; CALL objc_msgSend$fileExistsAtPath:
0x000443f4  mov      x22, x0
0x000443f8  mov      x0, x21
0x000443fc  bl       #0x55d78   ; CALL _objc_release
0x00044400  mov      x0, x20
0x00044404  bl       #0x55d78   ; CALL _objc_release
0x00044408  tbz      w22, #0, #0x44458
0x0004440c  ldr      x0, [x23, #0x990]   ; @CLASS NSFileManager
0x00044410  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x00044414  mov      x29, x29
0x00044418  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004441c  mov      x20, x0
0x00044420  adrp     x0, #0x7c000
0x00044424  add      x0, x0, #0x708   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Logo/logo.png"
0x00044428  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0004442c  add      x1, sp, #8
0x00044430  bl       #0x4118
0x00044434  cbz      x0, #0x44488
0x00044438  mov      x2, x0
0x0004443c  adrp     x8, #0x8e000
0x00044440  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00044444  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00044448  mov      x29, x29
0x0004444c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044450  mov      x21, x0
0x00044454  b        #0x4448c
0x00044458  adrp     x0, #0x7c000
0x0004445c  add      x0, x0, #0xbe8   ; STR "STARTUPSCREEN_LOGO_NONE"
0x00044460  bl       #0x17e20   ; CALL _L
0x00044464  mov      x29, x29
0x00044468  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004446c  mov      x20, x0
0x00044470  mov      x0, x19
0x00044474  mov      x2, x20
0x00044478  bl       #0x5ca40   ; CALL objc_msgSend$showMessage:
0x0004447c  mov      x0, x20
0x00044480  bl       #0x55d78   ; CALL _objc_release
0x00044484  b        #0x444b4
0x00044488  mov      x21, #0
0x0004448c  mov      x0, x20
0x00044490  mov      x2, x21
0x00044494  mov      x3, #0
0x00044498  bl       #0x59e20   ; CALL objc_msgSend$removeItemAtPath:error:
0x0004449c  mov      x0, x21
0x000444a0  bl       #0x55d78   ; CALL _objc_release
0x000444a4  mov      x0, x20
0x000444a8  bl       #0x55d78   ; CALL _objc_release
0x000444ac  mov      x0, x19
0x000444b0  bl       #0x5dd80   ; CALL objc_msgSend$updatePreview
0x000444b4  ldur     x8, [x29, #-0x38]
0x000444b8  adrp     x9, #0x74000
0x000444bc  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000444c0  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000444c4  cmp      x9, x8
0x000444c8  b.ne     #0x444e4
0x000444cc  add      sp, sp, #0x410
0x000444d0  ldp      x29, x30, [sp, #0x30]
0x000444d4  ldp      x20, x19, [sp, #0x20]
0x000444d8  ldp      x22, x21, [sp, #0x10]
0x000444dc  ldp      x24, x23, [sp], #0x40
0x000444e0  ret      
0x000444e4  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController chooseSound]  va=0x444e8 size=228 types=v16@0:8
0x000444e8  sub      sp, sp, #0x40
0x000444ec  stp      x22, x21, [sp, #0x10]
0x000444f0  stp      x20, x19, [sp, #0x20]
0x000444f4  stp      x29, x30, [sp, #0x30]
0x000444f8  add      x29, sp, #0x30
0x000444fc  mov      x19, x0
0x00044500  adrp     x8, #0x74000
0x00044504  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00044508  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0004450c  str      x8, [sp, #8]
0x00044510  mov      w2, #2
0x00044514  bl       #0x5bb80   ; CALL objc_msgSend$setPickKind:
0x00044518  adrp     x8, #0x8e000
0x0004451c  ldr      x0, [x8, #0xc90]   ; @CLASS UIDocumentPickerViewController
0x00044520  bl       #0x55c7c   ; CALL _objc_alloc
0x00044524  mov      x20, x0
0x00044528  adrp     x8, #0x74000
0x0004452c  ldr      x8, [x8, #0x308]   ; @GOT _UTTypeAudio
0x00044530  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00044534  str      x8, [sp]
0x00044538  adrp     x8, #0x8e000
0x0004453c  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00044540  mov      x2, sp
0x00044544  mov      w3, #1
0x00044548  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0004454c  mov      x29, x29
0x00044550  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044554  mov      x21, x0
0x00044558  mov      x0, x20
0x0004455c  mov      x2, x21
0x00044560  mov      w3, #1
0x00044564  bl       #0x58360   ; CALL objc_msgSend$initForOpeningContentTypes:asCopy:
0x00044568  mov      x20, x0
0x0004456c  mov      x0, x21
0x00044570  bl       #0x55d78   ; CALL _objc_release
0x00044574  mov      x0, x20
0x00044578  mov      x2, x19
0x0004457c  bl       #0x5aca0   ; CALL objc_msgSend$setDelegate:
0x00044580  mov      x0, x19
0x00044584  mov      x2, x20
0x00044588  mov      w3, #1
0x0004458c  mov      x4, #0
0x00044590  bl       #0x59980   ; CALL objc_msgSend$presentViewController:animated:completion:
0x00044594  mov      x0, x20
0x00044598  bl       #0x55d78   ; CALL _objc_release
0x0004459c  ldr      x8, [sp, #8]
0x000445a0  adrp     x9, #0x74000
0x000445a4  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000445a8  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000445ac  cmp      x9, x8
0x000445b0  b.ne     #0x445c8
0x000445b4  ldp      x29, x30, [sp, #0x30]
0x000445b8  ldp      x20, x19, [sp, #0x20]
0x000445bc  ldp      x22, x21, [sp, #0x10]
0x000445c0  add      sp, sp, #0x40
0x000445c4  ret      
0x000445c8  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController copySoundAtURL:]  va=0x445cc size=1012 types=v24@0:8@16
0x000445cc  stp      x28, x27, [sp, #-0x60]!
0x000445d0  stp      x26, x25, [sp, #0x10]
0x000445d4  stp      x24, x23, [sp, #0x20]
0x000445d8  stp      x22, x21, [sp, #0x30]
0x000445dc  stp      x20, x19, [sp, #0x40]
0x000445e0  stp      x29, x30, [sp, #0x50]
0x000445e4  add      x29, sp, #0x50
0x000445e8  sub      sp, sp, #0x440
0x000445ec  mov      x19, x2
0x000445f0  mov      x22, x0
0x000445f4  adrp     x8, #0x74000
0x000445f8  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000445fc  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00044600  stur     x8, [x29, #-0x60]
0x00044604  mov      x0, x2
0x00044608  bl       #0x55d84   ; CALL _objc_retain
0x0004460c  adrp     x8, #0x8e000
0x00044610  ldr      x0, [x8, #0xbe8]   ; @CLASS AVAudioPlayer
0x00044614  bl       #0x55c7c   ; CALL _objc_alloc
0x00044618  str      xzr, [sp, #0x18]
0x0004461c  add      x3, sp, #0x18
0x00044620  mov      x2, x19
0x00044624  bl       #0x583c0   ; CALL objc_msgSend$initWithContentsOfURL:error:
0x00044628  mov      x20, x0
0x0004462c  ldr      x23, [sp, #0x18]
0x00044630  mov      x0, x23
0x00044634  bl       #0x55d84   ; CALL _objc_retain
0x00044638  cbz      x20, #0x4468c
0x0004463c  adrp     x8, #0x8e000
0x00044640  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x00044644  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x00044648  mov      x29, x29
0x0004464c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044650  mov      x21, x0
0x00044654  adrp     x0, #0x7c000
0x00044658  add      x0, x0, #0x2a8   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Sounds"
0x0004465c  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00044660  add      x1, sp, #0x30
0x00044664  bl       #0x4118
0x00044668  adrp     x25, #0x8e000
0x0004466c  cbz      x0, #0x44714
0x00044670  mov      x2, x0
0x00044674  ldr      x0, [x25, #0x958]   ; @CLASS NSString
0x00044678  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x0004467c  mov      x29, x29
0x00044680  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044684  mov      x24, x0
0x00044688  b        #0x44718
0x0004468c  adrp     x8, #0x8e000
0x00044690  ldr      x26, [x8, #0x958]   ; @CLASS NSString
0x00044694  adrp     x0, #0x7c000
0x00044698  add      x0, x0, #0xc08   ; STR "STARTUPSCREEN_SOUND_FAILED"
0x0004469c  bl       #0x17e20   ; CALL _L
0x000446a0  mov      x29, x29
0x000446a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000446a8  mov      x21, x0
0x000446ac  mov      x0, x23
0x000446b0  bl       #0x58dc0   ; CALL objc_msgSend$localizedDescription
0x000446b4  mov      x29, x29
0x000446b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000446bc  mov      x24, x0
0x000446c0  mov      x25, x0
0x000446c4  cbnz     x0, #0x446dc
0x000446c8  mov      x0, x19
0x000446cc  bl       #0x58a80   ; CALL objc_msgSend$lastPathComponent
0x000446d0  mov      x29, x29
0x000446d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000446d8  mov      x25, x0
0x000446dc  str      x25, [sp]
0x000446e0  mov      x0, x26
0x000446e4  mov      x2, x21
0x000446e8  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x000446ec  mov      x29, x29
0x000446f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000446f4  mov      x26, x0
0x000446f8  mov      x0, x22
0x000446fc  mov      x2, x26
0x00044700  bl       #0x5ca40   ; CALL objc_msgSend$showMessage:
0x00044704  mov      x0, x26
0x00044708  bl       #0x55d78   ; CALL _objc_release
0x0004470c  cbz      x24, #0x44954
0x00044710  b        #0x4495c
0x00044714  mov      x24, #0
0x00044718  mov      x0, x21
0x0004471c  mov      x2, x24
0x00044720  mov      x3, #0
0x00044724  bl       #0x59e20   ; CALL objc_msgSend$removeItemAtPath:error:
0x00044728  mov      x0, x24
0x0004472c  bl       #0x55d78   ; CALL _objc_release
0x00044730  adrp     x0, #0x7c000
0x00044734  add      x0, x0, #0x2a8   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Sounds"
0x00044738  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x0004473c  add      x1, sp, #0x30
0x00044740  bl       #0x4118
0x00044744  cbz      x0, #0x44764
0x00044748  mov      x2, x0
0x0004474c  ldr      x0, [x25, #0x958]   ; @CLASS NSString
0x00044750  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00044754  mov      x29, x29
0x00044758  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004475c  mov      x24, x0
0x00044760  b        #0x44768
0x00044764  mov      x24, #0
0x00044768  str      x22, [sp, #8]
0x0004476c  mov      x0, x21
0x00044770  mov      x2, x24
0x00044774  mov      w3, #1
0x00044778  mov      x4, #0
0x0004477c  mov      x5, #0
0x00044780  bl       #0x57400   ; CALL objc_msgSend$createDirectoryAtPath:withIntermediateDirectories:attributes:error:
0x00044784  mov      x0, x24
0x00044788  bl       #0x55d78   ; CALL _objc_release
0x0004478c  mov      x0, x19
0x00044790  bl       #0x58a80   ; CALL objc_msgSend$lastPathComponent
0x00044794  mov      x29, x29
0x00044798  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004479c  mov      x24, x0
0x000447a0  adrp     x0, #0x7c000
0x000447a4  add      x0, x0, #0x2a8   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Sounds"
0x000447a8  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x000447ac  add      x1, sp, #0x30
0x000447b0  bl       #0x4118
0x000447b4  cbz      x0, #0x447d8
0x000447b8  mov      x2, x0
0x000447bc  mov      x22, x25
0x000447c0  ldr      x0, [x25, #0x958]   ; @CLASS NSString
0x000447c4  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x000447c8  mov      x29, x29
0x000447cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000447d0  mov      x26, x0
0x000447d4  b        #0x447e0
0x000447d8  mov      x22, x25
0x000447dc  mov      x26, #0
0x000447e0  mov      x0, x26
0x000447e4  mov      x2, x24
0x000447e8  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x000447ec  mov      x29, x29
0x000447f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000447f4  mov      x25, x0
0x000447f8  mov      x0, x26
0x000447fc  bl       #0x55d78   ; CALL _objc_release
0x00044800  mov      x0, x19
0x00044804  bl       #0x59600   ; CALL objc_msgSend$path
0x00044808  mov      x29, x29
0x0004480c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044810  mov      x27, x0
0x00044814  str      x23, [sp, #0x10]
0x00044818  add      x4, sp, #0x10
0x0004481c  mov      x0, x21
0x00044820  mov      x2, x27
0x00044824  mov      x3, x25
0x00044828  bl       #0x57320   ; CALL objc_msgSend$copyItemAtPath:toPath:error:
0x0004482c  mov      x28, x0
0x00044830  ldr      x26, [sp, #0x10]
0x00044834  mov      x0, x26
0x00044838  bl       #0x55d84   ; CALL _objc_retain
0x0004483c  mov      x0, x23
0x00044840  bl       #0x55d78   ; CALL _objc_release
0x00044844  mov      x0, x27
0x00044848  bl       #0x55d78   ; CALL _objc_release
0x0004484c  tbz      w28, #0, #0x448e0
0x00044850  adrp     x8, #0x74000
0x00044854  ldr      x8, [x8, #0x120]   ; @GOT _NSFilePosixPermissions
0x00044858  ldr      x9, [x8]   ; @GOT ___objc_personality_v0
0x0004485c  adrp     x8, #0x80000
0x00044860  add      x8, x8, #0x460
0x00044864  stp      x9, x8, [sp, #0x20]
0x00044868  adrp     x8, #0x8e000
0x0004486c  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00044870  add      x2, sp, #0x28
0x00044874  add      x3, sp, #0x20
0x00044878  mov      w4, #1
0x0004487c  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00044880  mov      x29, x29
0x00044884  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044888  mov      x23, x0
0x0004488c  mov      x0, x21
0x00044890  mov      x2, x23
0x00044894  mov      x3, x25
0x00044898  mov      x4, #0
0x0004489c  bl       #0x5a4e0   ; CALL objc_msgSend$setAttributes:ofItemAtPath:error:
0x000448a0  mov      x0, x23
0x000448a4  bl       #0x55d78   ; CALL _objc_release
0x000448a8  adrp     x0, #0x7c000
0x000448ac  add      x0, x0, #0x288   ; STR "startupScreenSoundFile"
0x000448b0  mov      x1, x24
0x000448b4  bl       #0x3f7c4
0x000448b8  adrp     x8, #0x74000
0x000448bc  ldr      x8, [x8, #0x368]   ; @GOT _OBJC_IVAR_$_PSListController._specifiers
0x000448c0  ldrsw    x8, [x8]   ; @GOT ___objc_personality_v0
0x000448c4  ldr      x22, [sp, #8]
0x000448c8  ldr      x0, [x22, x8]
0x000448cc  str      xzr, [x22, x8]
0x000448d0  bl       #0x55d78   ; CALL _objc_release
0x000448d4  mov      x0, x22
0x000448d8  bl       #0x59d40   ; CALL objc_msgSend$reloadSpecifiers
0x000448dc  b        #0x44950
0x000448e0  ldr      x23, [x22, #0x958]
0x000448e4  adrp     x0, #0x7c000
0x000448e8  add      x0, x0, #0xaa8   ; STR "STARTUPSCREEN_SAVE_FAILED"
0x000448ec  bl       #0x17e20   ; CALL _L
0x000448f0  mov      x29, x29
0x000448f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000448f8  mov      x27, x0
0x000448fc  mov      x0, x26
0x00044900  bl       #0x58dc0   ; CALL objc_msgSend$localizedDescription
0x00044904  mov      x29, x29
0x00044908  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004490c  mov      x28, x0
0x00044910  str      x0, [sp]
0x00044914  mov      x0, x23
0x00044918  mov      x2, x27
0x0004491c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00044920  mov      x29, x29
0x00044924  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044928  mov      x23, x0
0x0004492c  ldr      x0, [sp, #8]
0x00044930  mov      x2, x23
0x00044934  bl       #0x5ca40   ; CALL objc_msgSend$showMessage:
0x00044938  mov      x0, x23
0x0004493c  bl       #0x55d78   ; CALL _objc_release
0x00044940  mov      x0, x28
0x00044944  bl       #0x55d78   ; CALL _objc_release
0x00044948  mov      x0, x27
0x0004494c  bl       #0x55d78   ; CALL _objc_release
0x00044950  mov      x23, x26
0x00044954  mov      x0, x25
0x00044958  bl       #0x55d78   ; CALL _objc_release
0x0004495c  mov      x0, x24
0x00044960  bl       #0x55d78   ; CALL _objc_release
0x00044964  mov      x0, x21
0x00044968  bl       #0x55d78   ; CALL _objc_release
0x0004496c  mov      x0, x20
0x00044970  bl       #0x55d78   ; CALL _objc_release
0x00044974  mov      x0, x23
0x00044978  bl       #0x55d78   ; CALL _objc_release
0x0004497c  mov      x0, x19
0x00044980  bl       #0x55d78   ; CALL _objc_release
0x00044984  ldur     x8, [x29, #-0x60]
0x00044988  adrp     x9, #0x74000
0x0004498c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00044990  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00044994  cmp      x9, x8
0x00044998  b.ne     #0x449bc
0x0004499c  add      sp, sp, #0x440
0x000449a0  ldp      x29, x30, [sp, #0x50]
0x000449a4  ldp      x20, x19, [sp, #0x40]
0x000449a8  ldp      x22, x21, [sp, #0x30]
0x000449ac  ldp      x24, x23, [sp, #0x20]
0x000449b0  ldp      x26, x25, [sp, #0x10]
0x000449b4  ldp      x28, x27, [sp], #0x60
0x000449b8  ret      
0x000449bc  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController previewSound]  va=0x449c0 size=824 types=v16@0:8
0x000449c0  stp      d9, d8, [sp, #-0x70]!
0x000449c4  stp      x28, x27, [sp, #0x10]
0x000449c8  stp      x26, x25, [sp, #0x20]
0x000449cc  stp      x24, x23, [sp, #0x30]
0x000449d0  stp      x22, x21, [sp, #0x40]
0x000449d4  stp      x20, x19, [sp, #0x50]
0x000449d8  stp      x29, x30, [sp, #0x60]
0x000449dc  add      x29, sp, #0x60
0x000449e0  sub      sp, sp, #0x420
0x000449e4  mov      x20, x0
0x000449e8  adrp     x8, #0x74000
0x000449ec  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000449f0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000449f4  stur     x8, [x29, #-0x68]
0x000449f8  bl       #0x574c0   ; CALL objc_msgSend$currentSound
0x000449fc  mov      x29, x29
0x00044a00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044a04  mov      x19, x0
0x00044a08  cbz      x0, #0x44ad8
0x00044a0c  mov      x0, x20
0x00044a10  bl       #0x5cd20   ; CALL objc_msgSend$soundPlayer
0x00044a14  mov      x29, x29
0x00044a18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044a1c  mov      x21, x0
0x00044a20  bl       #0x5d360   ; CALL objc_msgSend$stop
0x00044a24  mov      x0, x21
0x00044a28  bl       #0x55d78   ; CALL _objc_release
0x00044a2c  adrp     x22, #0x8e000
0x00044a30  ldr      x0, [x22, #0xc08]   ; @CLASS AVAudioSession
0x00044a34  bl       #0x5c980   ; CALL objc_msgSend$sharedInstance
0x00044a38  mov      x29, x29
0x00044a3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044a40  mov      x21, x0
0x00044a44  adrp     x8, #0x74000
0x00044a48  ldr      x8, [x8, #0x480]   ; @GOT _AVAudioSessionCategoryPlayback
0x00044a4c  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x00044a50  mov      x3, #0
0x00044a54  bl       #0x5a800   ; CALL objc_msgSend$setCategory:error:
0x00044a58  mov      x0, x21
0x00044a5c  bl       #0x55d78   ; CALL _objc_release
0x00044a60  ldr      x0, [x22, #0xc08]   ; @CLASS AVAudioSession
0x00044a64  bl       #0x5c980   ; CALL objc_msgSend$sharedInstance
0x00044a68  mov      x29, x29
0x00044a6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044a70  mov      x21, x0
0x00044a74  mov      w2, #1
0x00044a78  mov      x3, #0
0x00044a7c  bl       #0x5a300   ; CALL objc_msgSend$setActive:error:
0x00044a80  mov      x0, x21
0x00044a84  bl       #0x55d78   ; CALL _objc_release
0x00044a88  adrp     x8, #0x8e000
0x00044a8c  ldr      x0, [x8, #0xbe8]   ; @CLASS AVAudioPlayer
0x00044a90  bl       #0x55c7c   ; CALL _objc_alloc
0x00044a94  mov      x21, x0
0x00044a98  adrp     x8, #0x8e000
0x00044a9c  ldr      x23, [x8, #0xa10]   ; @CLASS NSURL
0x00044aa0  adrp     x0, #0x7c000
0x00044aa4  add      x0, x0, #0x2a8   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Sounds"
0x00044aa8  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00044aac  add      x1, sp, #0x18
0x00044ab0  bl       #0x4118
0x00044ab4  adrp     x26, #0x8e000
0x00044ab8  cbz      x0, #0x44b00
0x00044abc  mov      x2, x0
0x00044ac0  ldr      x0, [x26, #0x958]   ; @CLASS NSString
0x00044ac4  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00044ac8  mov      x29, x29
0x00044acc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044ad0  mov      x22, x0
0x00044ad4  b        #0x44b04
0x00044ad8  adrp     x0, #0x7c000
0x00044adc  add      x0, x0, #0x3a8   ; STR "STARTUPSCREEN_SOUND_NONE"
0x00044ae0  bl       #0x17e20   ; CALL _L
0x00044ae4  mov      x29, x29
0x00044ae8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044aec  mov      x21, x0
0x00044af0  mov      x0, x20
0x00044af4  mov      x2, x21
0x00044af8  bl       #0x5ca40   ; CALL objc_msgSend$showMessage:
0x00044afc  b        #0x44ca8
0x00044b00  mov      x22, #0
0x00044b04  mov      x0, x22
0x00044b08  mov      x2, x19
0x00044b0c  bl       #0x5d420   ; CALL objc_msgSend$stringByAppendingPathComponent:
0x00044b10  mov      x29, x29
0x00044b14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044b18  mov      x24, x0
0x00044b1c  mov      x0, x23
0x00044b20  mov      x2, x24
0x00044b24  bl       #0x57ba0   ; CALL objc_msgSend$fileURLWithPath:
0x00044b28  mov      x29, x29
0x00044b2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044b30  mov      x23, x0
0x00044b34  str      xzr, [sp, #0x10]
0x00044b38  add      x3, sp, #0x10
0x00044b3c  mov      x0, x21
0x00044b40  mov      x2, x23
0x00044b44  bl       #0x583c0   ; CALL objc_msgSend$initWithContentsOfURL:error:
0x00044b48  mov      x25, x0
0x00044b4c  ldr      x21, [sp, #0x10]
0x00044b50  mov      x0, x21
0x00044b54  bl       #0x55d84   ; CALL _objc_retain
0x00044b58  mov      x0, x20
0x00044b5c  mov      x2, x25
0x00044b60  bl       #0x5c1c0   ; CALL objc_msgSend$setSoundPlayer:
0x00044b64  mov      x0, x25
0x00044b68  bl       #0x55d78   ; CALL _objc_release
0x00044b6c  mov      x0, x23
0x00044b70  bl       #0x55d78   ; CALL _objc_release
0x00044b74  mov      x0, x24
0x00044b78  bl       #0x55d78   ; CALL _objc_release
0x00044b7c  mov      x0, x22
0x00044b80  bl       #0x55d78   ; CALL _objc_release
0x00044b84  mov      x0, x20
0x00044b88  bl       #0x5cd20   ; CALL objc_msgSend$soundPlayer
0x00044b8c  mov      x29, x29
0x00044b90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044b94  mov      x22, x0
0x00044b98  bl       #0x55d78   ; CALL _objc_release
0x00044b9c  cbz      x22, #0x44bc8
0x00044ba0  adrp     x0, #0x7c000
0x00044ba4  add      x0, x0, #0xc28   ; STR "startupScreenSoundVolume"
0x00044ba8  adrp     x1, #0x75000
0x00044bac  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x00044bb0  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x00044bb4  mov      x22, x0
0x00044bb8  cbz      x0, #0x44c34
0x00044bbc  mov      x0, x22
0x00044bc0  bl       #0x57880   ; CALL objc_msgSend$doubleValue
0x00044bc4  b        #0x44c3c
0x00044bc8  ldr      x24, [x26, #0x958]   ; @CLASS NSString
0x00044bcc  adrp     x0, #0x7c000
0x00044bd0  add      x0, x0, #0xc08   ; STR "STARTUPSCREEN_SOUND_FAILED"
0x00044bd4  bl       #0x17e20   ; CALL _L
0x00044bd8  mov      x29, x29
0x00044bdc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044be0  mov      x22, x0
0x00044be4  mov      x0, x21
0x00044be8  bl       #0x58dc0   ; CALL objc_msgSend$localizedDescription
0x00044bec  mov      x29, x29
0x00044bf0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044bf4  mov      x23, x0
0x00044bf8  cmp      x0, #0
0x00044bfc  csel     x8, x19, x0, eq
0x00044c00  str      x8, [sp]
0x00044c04  mov      x0, x24
0x00044c08  mov      x2, x22
0x00044c0c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00044c10  mov      x29, x29
0x00044c14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044c18  mov      x24, x0
0x00044c1c  mov      x0, x20
0x00044c20  mov      x2, x24
0x00044c24  bl       #0x5ca40   ; CALL objc_msgSend$showMessage:
0x00044c28  mov      x0, x24
0x00044c2c  bl       #0x55d78   ; CALL _objc_release
0x00044c30  b        #0x44c98
0x00044c34  mov      x8, #0x4059000000000000
0x00044c38  fmov     d0, x8
0x00044c3c  mov      x8, #0x4059000000000000
0x00044c40  fmov     d1, x8
0x00044c44  fcmp     d0, d1
0x00044c48  fcsel    d0, d1, d0, gt
0x00044c4c  fmov     d2, xzr
0x00044c50  fmaxnm   d0, d0, d2
0x00044c54  fdiv     d0, d0, d1
0x00044c58  fcvt     s8, d0
0x00044c5c  mov      x0, x20
0x00044c60  bl       #0x5cd20   ; CALL objc_msgSend$soundPlayer
0x00044c64  mov      x29, x29
0x00044c68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044c6c  mov      x23, x0
0x00044c70  mov      v0.16b, v8.16b
0x00044c74  bl       #0x5c880   ; CALL objc_msgSend$setVolume:
0x00044c78  mov      x0, x23
0x00044c7c  bl       #0x55d78   ; CALL _objc_release
0x00044c80  mov      x0, x20
0x00044c84  bl       #0x5cd20   ; CALL objc_msgSend$soundPlayer
0x00044c88  mov      x29, x29
0x00044c8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044c90  mov      x23, x0
0x00044c94  bl       #0x59760   ; CALL objc_msgSend$play
0x00044c98  mov      x0, x23
0x00044c9c  bl       #0x55d78   ; CALL _objc_release
0x00044ca0  mov      x0, x22
0x00044ca4  bl       #0x55d78   ; CALL _objc_release
0x00044ca8  mov      x0, x21
0x00044cac  bl       #0x55d78   ; CALL _objc_release
0x00044cb0  mov      x0, x19
0x00044cb4  bl       #0x55d78   ; CALL _objc_release
0x00044cb8  ldur     x8, [x29, #-0x68]
0x00044cbc  adrp     x9, #0x74000
0x00044cc0  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00044cc4  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00044cc8  cmp      x9, x8
0x00044ccc  b.ne     #0x44cf4
0x00044cd0  add      sp, sp, #0x420
0x00044cd4  ldp      x29, x30, [sp, #0x60]
0x00044cd8  ldp      x20, x19, [sp, #0x50]
0x00044cdc  ldp      x22, x21, [sp, #0x40]
0x00044ce0  ldp      x24, x23, [sp, #0x30]
0x00044ce4  ldp      x26, x25, [sp, #0x20]
0x00044ce8  ldp      x28, x27, [sp, #0x10]
0x00044cec  ldp      d9, d8, [sp], #0x70
0x00044cf0  ret      
0x00044cf4  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController deleteSound]  va=0x44cf8 size=404 types=v16@0:8
0x00044cf8  stp      x22, x21, [sp, #-0x30]!
0x00044cfc  stp      x20, x19, [sp, #0x10]
0x00044d00  stp      x29, x30, [sp, #0x20]
0x00044d04  add      x29, sp, #0x20
0x00044d08  sub      sp, sp, #0x410
0x00044d0c  mov      x19, x0
0x00044d10  adrp     x8, #0x74000
0x00044d14  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00044d18  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00044d1c  stur     x8, [x29, #-0x28]
0x00044d20  bl       #0x574c0   ; CALL objc_msgSend$currentSound
0x00044d24  mov      x29, x29
0x00044d28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044d2c  mov      x20, x0
0x00044d30  bl       #0x55d78   ; CALL _objc_release
0x00044d34  cbz      x20, #0x44db4
0x00044d38  mov      x0, x19
0x00044d3c  bl       #0x5cd20   ; CALL objc_msgSend$soundPlayer
0x00044d40  mov      x29, x29
0x00044d44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044d48  mov      x20, x0
0x00044d4c  bl       #0x5d360   ; CALL objc_msgSend$stop
0x00044d50  mov      x0, x20
0x00044d54  bl       #0x55d78   ; CALL _objc_release
0x00044d58  mov      x0, x19
0x00044d5c  mov      x2, #0
0x00044d60  bl       #0x5c1c0   ; CALL objc_msgSend$setSoundPlayer:
0x00044d64  adrp     x8, #0x8e000
0x00044d68  ldr      x0, [x8, #0x990]   ; @CLASS NSFileManager
0x00044d6c  bl       #0x576a0   ; CALL objc_msgSend$defaultManager
0x00044d70  mov      x29, x29
0x00044d74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044d78  mov      x20, x0
0x00044d7c  adrp     x0, #0x7c000
0x00044d80  add      x0, x0, #0x2a8   ; STR "/var/mobile/Library/OmniCar/StartupScreen/Sounds"
0x00044d84  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00044d88  add      x1, sp, #8
0x00044d8c  bl       #0x4118
0x00044d90  cbz      x0, #0x44e08
0x00044d94  mov      x2, x0
0x00044d98  adrp     x8, #0x8e000
0x00044d9c  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00044da0  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00044da4  mov      x29, x29
0x00044da8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044dac  mov      x21, x0
0x00044db0  b        #0x44e0c
0x00044db4  adrp     x0, #0x7c000
0x00044db8  add      x0, x0, #0x3a8   ; STR "STARTUPSCREEN_SOUND_NONE"
0x00044dbc  bl       #0x17e20   ; CALL _L
0x00044dc0  mov      x29, x29
0x00044dc4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00044dc8  mov      x20, x0
0x00044dcc  mov      x0, x19
0x00044dd0  mov      x2, x20
0x00044dd4  bl       #0x5ca40   ; CALL objc_msgSend$showMessage:
0x00044dd8  ldur     x8, [x29, #-0x28]
0x00044ddc  adrp     x9, #0x74000
0x00044de0  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00044de4  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00044de8  cmp      x9, x8
0x00044dec  b.ne     #0x44e88
0x00044df0  mov      x0, x20
0x00044df4  add      sp, sp, #0x410
0x00044df8  ldp      x29, x30, [sp, #0x20]
0x00044dfc  ldp      x20, x19, [sp, #0x10]
0x00044e00  ldp      x22, x21, [sp], #0x30
0x00044e04  b        #0x55d78   ; CALL _objc_release
0x00044e08  mov      x21, #0
0x00044e0c  mov      x0, x20
0x00044e10  mov      x2, x21
0x00044e14  mov      x3, #0
0x00044e18  bl       #0x59e20   ; CALL objc_msgSend$removeItemAtPath:error:
0x00044e1c  mov      x0, x21
0x00044e20  bl       #0x55d78   ; CALL _objc_release
0x00044e24  mov      x0, x20
0x00044e28  bl       #0x55d78   ; CALL _objc_release
0x00044e2c  adrp     x0, #0x7c000
0x00044e30  add      x0, x0, #0x288   ; STR "startupScreenSoundFile"
0x00044e34  mov      x1, #0
0x00044e38  bl       #0x3f7c4
0x00044e3c  adrp     x8, #0x74000
0x00044e40  ldr      x8, [x8, #0x368]   ; @GOT _OBJC_IVAR_$_PSListController._specifiers
0x00044e44  ldrsw    x8, [x8]   ; @GOT ___objc_personality_v0
0x00044e48  ldr      x0, [x19, x8]
0x00044e4c  str      xzr, [x19, x8]
0x00044e50  bl       #0x55d78   ; CALL _objc_release
0x00044e54  mov      x0, x19
0x00044e58  bl       #0x59d40   ; CALL objc_msgSend$reloadSpecifiers
0x00044e5c  ldur     x8, [x29, #-0x28]
0x00044e60  adrp     x9, #0x74000
0x00044e64  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00044e68  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00044e6c  cmp      x9, x8
0x00044e70  b.ne     #0x44e88
0x00044e74  add      sp, sp, #0x410
0x00044e78  ldp      x29, x30, [sp, #0x20]
0x00044e7c  ldp      x20, x19, [sp, #0x10]
0x00044e80  ldp      x22, x21, [sp], #0x30
0x00044e84  ret      
0x00044e88  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCStartupScreenController extracting]  va=0x44e8c size=16 types=B16@0:8
0x00044e8c  adrp     x8, #0x8e000
0x00044e90  ldrsw    x8, [x8, #0xf78]
0x00044e94  ldrb     w0, [x0, x8]
0x00044e98  ret      

=== -[OMCStartupScreenController setExtracting:]  va=0x44e9c size=16 types=v20@0:8B16
0x00044e9c  adrp     x8, #0x8e000
0x00044ea0  ldrsw    x8, [x8, #0xf78]
0x00044ea4  strb     w2, [x0, x8]
0x00044ea8  ret      

=== -[OMCStartupScreenController pickKind]  va=0x44eac size=16 types=q16@0:8
0x00044eac  adrp     x8, #0x8e000
0x00044eb0  ldrsw    x8, [x8, #0xf7c]
0x00044eb4  ldr      x0, [x0, x8]
0x00044eb8  ret      

=== -[OMCStartupScreenController setPickKind:]  va=0x44ebc size=16 types=v24@0:8q16
0x00044ebc  adrp     x8, #0x8e000
0x00044ec0  ldrsw    x8, [x8, #0xf7c]
0x00044ec4  str      x2, [x0, x8]
0x00044ec8  ret      

=== -[OMCStartupScreenController previewHeader]  va=0x44ecc size=16 types=@16@0:8
0x00044ecc  adrp     x8, #0x8e000
0x00044ed0  ldrsw    x8, [x8, #0xf80]
0x00044ed4  ldr      x0, [x0, x8]
0x00044ed8  ret      

=== -[OMCStartupScreenController setPreviewHeader:]  va=0x44edc size=64 types=v24@0:8@16
0x00044edc  stp      x22, x21, [sp, #-0x30]!
0x00044ee0  stp      x20, x19, [sp, #0x10]
0x00044ee4  stp      x29, x30, [sp, #0x20]
0x00044ee8  add      x29, sp, #0x20
0x00044eec  mov      x19, x2
0x00044ef0  mov      x20, x0
0x00044ef4  adrp     x8, #0x8e000
0x00044ef8  ldrsw    x21, [x8, #0xf80]
0x00044efc  mov      x0, x2
0x00044f00  bl       #0x55d84   ; CALL _objc_retain
0x00044f04  ldr      x0, [x20, x21]
0x00044f08  str      x19, [x20, x21]
0x00044f0c  ldp      x29, x30, [sp, #0x20]
0x00044f10  ldp      x20, x19, [sp, #0x10]
0x00044f14  ldp      x22, x21, [sp], #0x30
0x00044f18  b        #0x55d78   ; CALL _objc_release

=== -[OMCStartupScreenController previewShadow]  va=0x44f1c size=16 types=@16@0:8
0x00044f1c  adrp     x8, #0x8e000
0x00044f20  ldrsw    x8, [x8, #0xf84]
0x00044f24  ldr      x0, [x0, x8]
0x00044f28  ret      

=== -[OMCStartupScreenController setPreviewShadow:]  va=0x44f2c size=64 types=v24@0:8@16
0x00044f2c  stp      x22, x21, [sp, #-0x30]!
0x00044f30  stp      x20, x19, [sp, #0x10]
0x00044f34  stp      x29, x30, [sp, #0x20]
0x00044f38  add      x29, sp, #0x20
0x00044f3c  mov      x19, x2
0x00044f40  mov      x20, x0
0x00044f44  adrp     x8, #0x8e000
0x00044f48  ldrsw    x21, [x8, #0xf84]
0x00044f4c  mov      x0, x2
0x00044f50  bl       #0x55d84   ; CALL _objc_retain
0x00044f54  ldr      x0, [x20, x21]
0x00044f58  str      x19, [x20, x21]
0x00044f5c  ldp      x29, x30, [sp, #0x20]
0x00044f60  ldp      x20, x19, [sp, #0x10]
0x00044f64  ldp      x22, x21, [sp], #0x30
0x00044f68  b        #0x55d78   ; CALL _objc_release

=== -[OMCStartupScreenController preview]  va=0x44f6c size=16 types=@16@0:8
0x00044f6c  adrp     x8, #0x8e000
0x00044f70  ldrsw    x8, [x8, #0xf88]
0x00044f74  ldr      x0, [x0, x8]
0x00044f78  ret      

=== -[OMCStartupScreenController setPreview:]  va=0x44f7c size=64 types=v24@0:8@16
0x00044f7c  stp      x22, x21, [sp, #-0x30]!
0x00044f80  stp      x20, x19, [sp, #0x10]
0x00044f84  stp      x29, x30, [sp, #0x20]
0x00044f88  add      x29, sp, #0x20
0x00044f8c  mov      x19, x2
0x00044f90  mov      x20, x0
0x00044f94  adrp     x8, #0x8e000
0x00044f98  ldrsw    x21, [x8, #0xf88]
0x00044f9c  mov      x0, x2
0x00044fa0  bl       #0x55d84   ; CALL _objc_retain
0x00044fa4  ldr      x0, [x20, x21]
0x00044fa8  str      x19, [x20, x21]
0x00044fac  ldp      x29, x30, [sp, #0x20]
0x00044fb0  ldp      x20, x19, [sp, #0x10]
0x00044fb4  ldp      x22, x21, [sp], #0x30
0x00044fb8  b        #0x55d78   ; CALL _objc_release

=== -[OMCStartupScreenController previewWidth]  va=0x44fbc size=16 types=d16@0:8
0x00044fbc  adrp     x8, #0x8e000
0x00044fc0  ldrsw    x8, [x8, #0xf8c]
0x00044fc4  ldr      d0, [x0, x8]
0x00044fc8  ret      

=== -[OMCStartupScreenController setPreviewWidth:]  va=0x44fcc size=16 types=v24@0:8d16
0x00044fcc  adrp     x8, #0x8e000
0x00044fd0  ldrsw    x8, [x8, #0xf8c]
0x00044fd4  str      d0, [x0, x8]
0x00044fd8  ret      

=== -[OMCStartupScreenController galleryTitle]  va=0x44fdc size=16 types=@16@0:8
0x00044fdc  adrp     x8, #0x8e000
0x00044fe0  ldrsw    x8, [x8, #0xf90]
0x00044fe4  ldr      x0, [x0, x8]
0x00044fe8  ret      

=== -[OMCStartupScreenController setGalleryTitle:]  va=0x44fec size=64 types=v24@0:8@16
0x00044fec  stp      x22, x21, [sp, #-0x30]!
0x00044ff0  stp      x20, x19, [sp, #0x10]
0x00044ff4  stp      x29, x30, [sp, #0x20]
0x00044ff8  add      x29, sp, #0x20
0x00044ffc  mov      x19, x2
0x00045000  mov      x20, x0
0x00045004  adrp     x8, #0x8e000
0x00045008  ldrsw    x21, [x8, #0xf90]
0x0004500c  mov      x0, x2
0x00045010  bl       #0x55d84   ; CALL _objc_retain
0x00045014  ldr      x0, [x20, x21]
0x00045018  str      x19, [x20, x21]
0x0004501c  ldp      x29, x30, [sp, #0x20]
0x00045020  ldp      x20, x19, [sp, #0x10]
0x00045024  ldp      x22, x21, [sp], #0x30
0x00045028  b        #0x55d78   ; CALL _objc_release

=== -[OMCStartupScreenController galleryHint]  va=0x4502c size=16 types=@16@0:8
0x0004502c  adrp     x8, #0x8e000
0x00045030  ldrsw    x8, [x8, #0xf94]
0x00045034  ldr      x0, [x0, x8]
0x00045038  ret      

=== -[OMCStartupScreenController setGalleryHint:]  va=0x4503c size=64 types=v24@0:8@16
0x0004503c  stp      x22, x21, [sp, #-0x30]!
0x00045040  stp      x20, x19, [sp, #0x10]
0x00045044  stp      x29, x30, [sp, #0x20]
0x00045048  add      x29, sp, #0x20
0x0004504c  mov      x19, x2
0x00045050  mov      x20, x0
0x00045054  adrp     x8, #0x8e000
0x00045058  ldrsw    x21, [x8, #0xf94]
0x0004505c  mov      x0, x2
0x00045060  bl       #0x55d84   ; CALL _objc_retain
0x00045064  ldr      x0, [x20, x21]
0x00045068  str      x19, [x20, x21]
0x0004506c  ldp      x29, x30, [sp, #0x20]
0x00045070  ldp      x20, x19, [sp, #0x10]
0x00045074  ldp      x22, x21, [sp], #0x30
0x00045078  b        #0x55d78   ; CALL _objc_release

=== -[OMCStartupScreenController gallery]  va=0x4507c size=16 types=@16@0:8
0x0004507c  adrp     x8, #0x8e000
0x00045080  ldrsw    x8, [x8, #0xf98]
0x00045084  ldr      x0, [x0, x8]
0x00045088  ret      

=== -[OMCStartupScreenController setGallery:]  va=0x4508c size=64 types=v24@0:8@16
0x0004508c  stp      x22, x21, [sp, #-0x30]!
0x00045090  stp      x20, x19, [sp, #0x10]
0x00045094  stp      x29, x30, [sp, #0x20]
0x00045098  add      x29, sp, #0x20
0x0004509c  mov      x19, x2
0x000450a0  mov      x20, x0
0x000450a4  adrp     x8, #0x8e000
0x000450a8  ldrsw    x21, [x8, #0xf98]
0x000450ac  mov      x0, x2
0x000450b0  bl       #0x55d84   ; CALL _objc_retain
0x000450b4  ldr      x0, [x20, x21]
0x000450b8  str      x19, [x20, x21]
0x000450bc  ldp      x29, x30, [sp, #0x20]
0x000450c0  ldp      x20, x19, [sp, #0x10]
0x000450c4  ldp      x22, x21, [sp], #0x30
0x000450c8  b        #0x55d78   ; CALL _objc_release

=== -[OMCStartupScreenController birthdayView]  va=0x450cc size=16 types=@16@0:8
0x000450cc  adrp     x8, #0x8e000
0x000450d0  ldrsw    x8, [x8, #0xf9c]
0x000450d4  ldr      x0, [x0, x8]
0x000450d8  ret      

=== -[OMCStartupScreenController setBirthdayView:]  va=0x450dc size=64 types=v24@0:8@16
0x000450dc  stp      x22, x21, [sp, #-0x30]!
0x000450e0  stp      x20, x19, [sp, #0x10]
0x000450e4  stp      x29, x30, [sp, #0x20]
0x000450e8  add      x29, sp, #0x20
0x000450ec  mov      x19, x2
0x000450f0  mov      x20, x0
0x000450f4  adrp     x8, #0x8e000
0x000450f8  ldrsw    x21, [x8, #0xf9c]
0x000450fc  mov      x0, x2
0x00045100  bl       #0x55d84   ; CALL _objc_retain
0x00045104  ldr      x0, [x20, x21]
0x00045108  str      x19, [x20, x21]
0x0004510c  ldp      x29, x30, [sp, #0x20]
0x00045110  ldp      x20, x19, [sp, #0x10]
0x00045114  ldp      x22, x21, [sp], #0x30
0x00045118  b        #0x55d78   ; CALL _objc_release

=== -[OMCStartupScreenController birthdayPicker]  va=0x4511c size=16 types=@16@0:8
0x0004511c  adrp     x8, #0x8e000
0x00045120  ldrsw    x8, [x8, #0xfa0]
0x00045124  ldr      x0, [x0, x8]
0x00045128  ret      

=== -[OMCStartupScreenController setBirthdayPicker:]  va=0x4512c size=64 types=v24@0:8@16
0x0004512c  stp      x22, x21, [sp, #-0x30]!
0x00045130  stp      x20, x19, [sp, #0x10]
0x00045134  stp      x29, x30, [sp, #0x20]
0x00045138  add      x29, sp, #0x20
0x0004513c  mov      x19, x2
0x00045140  mov      x20, x0
0x00045144  adrp     x8, #0x8e000
0x00045148  ldrsw    x21, [x8, #0xfa0]
0x0004514c  mov      x0, x2
0x00045150  bl       #0x55d84   ; CALL _objc_retain
0x00045154  ldr      x0, [x20, x21]
0x00045158  str      x19, [x20, x21]
0x0004515c  ldp      x29, x30, [sp, #0x20]
0x00045160  ldp      x20, x19, [sp, #0x10]
0x00045164  ldp      x22, x21, [sp], #0x30
0x00045168  b        #0x55d78   ; CALL _objc_release

=== -[OMCStartupScreenController birthdayClear]  va=0x4516c size=16 types=@16@0:8
0x0004516c  adrp     x8, #0x8e000
0x00045170  ldrsw    x8, [x8, #0xfa4]
0x00045174  ldr      x0, [x0, x8]
0x00045178  ret      

=== -[OMCStartupScreenController setBirthdayClear:]  va=0x4517c size=64 types=v24@0:8@16
0x0004517c  stp      x22, x21, [sp, #-0x30]!
0x00045180  stp      x20, x19, [sp, #0x10]
0x00045184  stp      x29, x30, [sp, #0x20]
0x00045188  add      x29, sp, #0x20
0x0004518c  mov      x19, x2
0x00045190  mov      x20, x0
0x00045194  adrp     x8, #0x8e000
0x00045198  ldrsw    x21, [x8, #0xfa4]
0x0004519c  mov      x0, x2
0x000451a0  bl       #0x55d84   ; CALL _objc_retain
0x000451a4  ldr      x0, [x20, x21]
0x000451a8  str      x19, [x20, x21]
0x000451ac  ldp      x29, x30, [sp, #0x20]
0x000451b0  ldp      x20, x19, [sp, #0x10]
0x000451b4  ldp      x22, x21, [sp], #0x30
0x000451b8  b        #0x55d78   ; CALL _objc_release

=== -[OMCStartupScreenController soundPlayer]  va=0x451bc size=16 types=@16@0:8
0x000451bc  adrp     x8, #0x8e000
0x000451c0  ldrsw    x8, [x8, #0xfa8]
0x000451c4  ldr      x0, [x0, x8]
0x000451c8  ret      

=== -[OMCStartupScreenController setSoundPlayer:]  va=0x451cc size=64 types=v24@0:8@16
0x000451cc  stp      x22, x21, [sp, #-0x30]!
0x000451d0  stp      x20, x19, [sp, #0x10]
0x000451d4  stp      x29, x30, [sp, #0x20]
0x000451d8  add      x29, sp, #0x20
0x000451dc  mov      x19, x2
0x000451e0  mov      x20, x0
0x000451e4  adrp     x8, #0x8e000
0x000451e8  ldrsw    x21, [x8, #0xfa8]
0x000451ec  mov      x0, x2
0x000451f0  bl       #0x55d84   ; CALL _objc_retain
0x000451f4  ldr      x0, [x20, x21]
0x000451f8  str      x19, [x20, x21]
0x000451fc  ldp      x29, x30, [sp, #0x20]
0x00045200  ldp      x20, x19, [sp, #0x10]
0x00045204  ldp      x22, x21, [sp], #0x30
0x00045208  b        #0x55d78   ; CALL _objc_release

=== -[OMCStartupScreenController .cxx_destruct]  va=0x4520c size=224 types=v16@0:8
0x0004520c  stp      x20, x19, [sp, #-0x20]!
0x00045210  stp      x29, x30, [sp, #0x10]
0x00045214  add      x29, sp, #0x10
0x00045218  mov      x19, x0
0x0004521c  adrp     x8, #0x8e000
0x00045220  ldrsw    x8, [x8, #0xfa8]
0x00045224  add      x0, x0, x8
0x00045228  mov      x1, #0
0x0004522c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00045230  adrp     x8, #0x8e000
0x00045234  ldrsw    x8, [x8, #0xfa4]
0x00045238  add      x0, x19, x8
0x0004523c  mov      x1, #0
0x00045240  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00045244  adrp     x8, #0x8e000
0x00045248  ldrsw    x8, [x8, #0xfa0]
0x0004524c  add      x0, x19, x8
0x00045250  mov      x1, #0
0x00045254  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00045258  adrp     x8, #0x8e000
0x0004525c  ldrsw    x8, [x8, #0xf9c]
0x00045260  add      x0, x19, x8
0x00045264  mov      x1, #0
0x00045268  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0004526c  adrp     x8, #0x8e000
0x00045270  ldrsw    x8, [x8, #0xf98]
0x00045274  add      x0, x19, x8
0x00045278  mov      x1, #0
0x0004527c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00045280  adrp     x8, #0x8e000
0x00045284  ldrsw    x8, [x8, #0xf94]
0x00045288  add      x0, x19, x8
0x0004528c  mov      x1, #0
0x00045290  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00045294  adrp     x8, #0x8e000
0x00045298  ldrsw    x8, [x8, #0xf90]
0x0004529c  add      x0, x19, x8
0x000452a0  mov      x1, #0
0x000452a4  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000452a8  adrp     x8, #0x8e000
0x000452ac  ldrsw    x8, [x8, #0xf88]
0x000452b0  add      x0, x19, x8
0x000452b4  mov      x1, #0
0x000452b8  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000452bc  adrp     x8, #0x8e000
0x000452c0  ldrsw    x8, [x8, #0xf84]
0x000452c4  add      x0, x19, x8
0x000452c8  mov      x1, #0
0x000452cc  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000452d0  adrp     x8, #0x8e000
0x000452d4  ldrsw    x8, [x8, #0xf80]
0x000452d8  add      x0, x19, x8
0x000452dc  mov      x1, #0
0x000452e0  ldp      x29, x30, [sp, #0x10]
0x000452e4  ldp      x20, x19, [sp], #0x20
0x000452e8  b        #0x55dcc   ; CALL _objc_storeStrong
