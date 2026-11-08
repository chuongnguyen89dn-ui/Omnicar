=== -[OMCAppBridgeAppsLinkCell initWithStyle:reuseIdentifier:specifier:]  va=0x1b384 size=56 types=@40@0:8q16@24@32
0x0001b384  sub      sp, sp, #0x20
0x0001b388  stp      x29, x30, [sp, #0x10]
0x0001b38c  add      x29, sp, #0x10
0x0001b390  adrp     x8, #0x8e000
0x0001b394  ldr      x8, [x8, #0xd48]   ; @SUPER OMCAppBridgeAppsLinkCell
0x0001b398  stp      x0, x8, [sp]
0x0001b39c  adrp     x8, #0x8b000
0x0001b3a0  ldr      x1, [x8, #0xe30]   ; @SEL "initWithStyle:reuseIdentifier:specifier:"
0x0001b3a4  mov      x0, sp
0x0001b3a8  mov      w2, #1
0x0001b3ac  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0001b3b0  ldp      x29, x30, [sp, #0x10]
0x0001b3b4  add      sp, sp, #0x20
0x0001b3b8  ret      

=== -[OMCAppBridgeAppsLinkCell refreshCellContentsWithSpecifier:]  va=0x1b3bc size=460 types=v24@0:8@16
0x0001b3bc  sub      sp, sp, #0x60
0x0001b3c0  stp      x26, x25, [sp, #0x10]
0x0001b3c4  stp      x24, x23, [sp, #0x20]
0x0001b3c8  stp      x22, x21, [sp, #0x30]
0x0001b3cc  stp      x20, x19, [sp, #0x40]
0x0001b3d0  stp      x29, x30, [sp, #0x50]
0x0001b3d4  add      x29, sp, #0x50
0x0001b3d8  mov      x19, x0
0x0001b3dc  adrp     x8, #0x8e000
0x0001b3e0  ldr      x8, [x8, #0xd48]   ; @SUPER OMCAppBridgeAppsLinkCell
0x0001b3e4  stp      x0, x8, [sp]
0x0001b3e8  adrp     x8, #0x8b000
0x0001b3ec  ldr      x1, [x8, #0xe38]   ; @SEL "refreshCellContentsWithSpecifier:"
0x0001b3f0  mov      x0, sp
0x0001b3f4  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0001b3f8  bl       #0x1b510
0x0001b3fc  mov      x29, x29
0x0001b400  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b404  mov      x21, x0
0x0001b408  bl       #0x573c0   ; CALL objc_msgSend$count
0x0001b40c  mov      x20, x0
0x0001b410  mov      x0, x21
0x0001b414  bl       #0x55d78   ; CALL _objc_release
0x0001b418  cbz      x20, #0x1b484
0x0001b41c  adrp     x0, #0x79000
0x0001b420  add      x0, x0, #0x68   ; STR "APPBRIDGE_APPS_COUNT"
0x0001b424  bl       #0x17e20   ; CALL _L
0x0001b428  mov      x29, x29
0x0001b42c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b430  mov      x21, x0
0x0001b434  adrp     x8, #0x8e000
0x0001b438  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x0001b43c  mov      x2, x20
0x0001b440  bl       #0x59360   ; CALL objc_msgSend$numberWithUnsignedInteger:
0x0001b444  mov      x29, x29
0x0001b448  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b44c  mov      x22, x0
0x0001b450  bl       #0x5d540   ; CALL objc_msgSend$stringValue
0x0001b454  mov      x29, x29
0x0001b458  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b45c  mov      x23, x0
0x0001b460  adrp     x2, #0x79000
0x0001b464  add      x2, x2, #0x88   ; STR "%ld"
0x0001b468  mov      x0, x21
0x0001b46c  mov      x3, x23
0x0001b470  bl       #0x5d4a0   ; CALL objc_msgSend$stringByReplacingOccurrencesOfString:withString:
0x0001b474  mov      x29, x29
0x0001b478  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b47c  mov      x24, x0
0x0001b480  b        #0x1b49c
0x0001b484  adrp     x0, #0x79000
0x0001b488  add      x0, x0, #0xa8   ; STR "APPBRIDGE_APPS_NONE"
0x0001b48c  bl       #0x17e20   ; CALL _L
0x0001b490  mov      x29, x29
0x0001b494  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b498  mov      x24, x0
0x0001b49c  mov      x0, x19
0x0001b4a0  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x0001b4a4  mov      x29, x29
0x0001b4a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b4ac  mov      x25, x0
0x0001b4b0  mov      x2, x24
0x0001b4b4  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0001b4b8  mov      x0, x25
0x0001b4bc  bl       #0x55d78   ; CALL _objc_release
0x0001b4c0  cbz      x20, #0x1b4e0
0x0001b4c4  mov      x0, x24
0x0001b4c8  bl       #0x55d78   ; CALL _objc_release
0x0001b4cc  mov      x0, x23
0x0001b4d0  bl       #0x55d78   ; CALL _objc_release
0x0001b4d4  mov      x0, x22
0x0001b4d8  bl       #0x55d78   ; CALL _objc_release
0x0001b4dc  mov      x24, x21
0x0001b4e0  mov      x0, x24
0x0001b4e4  bl       #0x55d78   ; CALL _objc_release
0x0001b4e8  mov      x0, x19
0x0001b4ec  mov      w2, #1
0x0001b4f0  bl       #0x5a2a0   ; CALL objc_msgSend$setAccessoryType:
0x0001b4f4  ldp      x29, x30, [sp, #0x50]
0x0001b4f8  ldp      x20, x19, [sp, #0x40]
0x0001b4fc  ldp      x22, x21, [sp, #0x30]
0x0001b500  ldp      x24, x23, [sp, #0x20]
0x0001b504  ldp      x26, x25, [sp, #0x10]
0x0001b508  add      sp, sp, #0x60
0x0001b50c  ret      
0x0001b510  stp      x20, x19, [sp, #-0x20]!
0x0001b514  stp      x29, x30, [sp, #0x10]
0x0001b518  add      x29, sp, #0x10
0x0001b51c  adrp     x0, #0x75000
0x0001b520  add      x0, x0, #0x28   ; STR "com.anlai.omnicar"
0x0001b524  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x0001b528  adrp     x0, #0x76000
0x0001b52c  add      x0, x0, #0x928   ; STR "appBridgeApps"
0x0001b530  bl       #0x1cd84
0x0001b534  mov      x29, x29
0x0001b538  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001b53c  mov      x19, x0
0x0001b540  adrp     x8, #0x8e000
0x0001b544  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0001b548  bl       #0x55d48   ; CALL _objc_opt_class
0x0001b54c  mov      x1, x0
0x0001b550  mov      x0, x19
0x0001b554  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0001b558  adrp     x8, #0x74000
0x0001b55c  ldr      x8, [x8, #0x1a0]   ; @GOT ___NSArray0__struct
0x0001b560  tst      w0, #1
0x0001b564  csel     x20, x19, x8, ne
0x0001b568  mov      x0, x20
0x0001b56c  bl       #0x55d84   ; CALL _objc_retain
0x0001b570  mov      x0, x19
0x0001b574  bl       #0x55d78   ; CALL _objc_release
0x0001b578  mov      x0, x20
0x0001b57c  ldp      x29, x30, [sp, #0x10]
0x0001b580  ldp      x20, x19, [sp], #0x20
0x0001b584  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
