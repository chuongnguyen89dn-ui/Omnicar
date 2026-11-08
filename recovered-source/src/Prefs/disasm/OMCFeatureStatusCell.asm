=== -[OMCFeatureStatusCell initWithStyle:reuseIdentifier:specifier:]  va=0x1544c size=56 types=@40@0:8q16@24@32
0x0001544c  sub      sp, sp, #0x20
0x00015450  stp      x29, x30, [sp, #0x10]
0x00015454  add      x29, sp, #0x10
0x00015458  adrp     x8, #0x8e000
0x0001545c  ldr      x8, [x8, #0xd30]   ; @SUPER OMCFeatureStatusCell
0x00015460  stp      x0, x8, [sp]
0x00015464  adrp     x8, #0x8b000
0x00015468  ldr      x1, [x8, #0xe30]   ; @SEL "initWithStyle:reuseIdentifier:specifier:"
0x0001546c  mov      x0, sp
0x00015470  mov      w2, #1
0x00015474  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00015478  ldp      x29, x30, [sp, #0x10]
0x0001547c  add      sp, sp, #0x20
0x00015480  ret      

=== -[OMCFeatureStatusCell refreshCellContentsWithSpecifier:]  va=0x15484 size=332 types=v24@0:8@16
0x00015484  sub      sp, sp, #0x50
0x00015488  stp      x24, x23, [sp, #0x10]
0x0001548c  stp      x22, x21, [sp, #0x20]
0x00015490  stp      x20, x19, [sp, #0x30]
0x00015494  stp      x29, x30, [sp, #0x40]
0x00015498  add      x29, sp, #0x40
0x0001549c  mov      x19, x2
0x000154a0  mov      x20, x0
0x000154a4  mov      x0, x2
0x000154a8  bl       #0x55d84   ; CALL _objc_retain
0x000154ac  adrp     x8, #0x8e000
0x000154b0  ldr      x8, [x8, #0xd30]   ; @SUPER OMCFeatureStatusCell
0x000154b4  stp      x20, x8, [sp]
0x000154b8  adrp     x8, #0x8b000
0x000154bc  ldr      x1, [x8, #0xe38]   ; @SEL "refreshCellContentsWithSpecifier:"
0x000154c0  mov      x0, sp
0x000154c4  mov      x2, x19
0x000154c8  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x000154cc  adrp     x2, #0x78000
0x000154d0  add      x2, x2, #0x5a8   ; STR "featureKey"
0x000154d4  mov      x0, x19
0x000154d8  bl       #0x59aa0   ; CALL objc_msgSend$propertyForKey:
0x000154dc  mov      x29, x29
0x000154e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000154e4  mov      x21, x0
0x000154e8  cbz      x0, #0x1559c
0x000154ec  adrp     x1, #0x75000
0x000154f0  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x000154f4  mov      x0, x21
0x000154f8  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x000154fc  mov      x22, x0
0x00015500  cbz      x0, #0x15514
0x00015504  mov      x0, x22
0x00015508  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x0001550c  mov      x23, x0
0x00015510  b        #0x15540
0x00015514  adrp     x2, #0x78000
0x00015518  add      x2, x2, #0x5c8   ; STR "featureDefault"
0x0001551c  mov      x0, x19
0x00015520  bl       #0x59aa0   ; CALL objc_msgSend$propertyForKey:
0x00015524  mov      x29, x29
0x00015528  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001552c  mov      x24, x0
0x00015530  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00015534  mov      x23, x0
0x00015538  mov      x0, x24
0x0001553c  bl       #0x55d78   ; CALL _objc_release
0x00015540  adrp     x8, #0x75000
0x00015544  add      x8, x8, #0xa68   ; STR "FEATURE_OFF"
0x00015548  adrp     x9, #0x75000
0x0001554c  add      x9, x9, #0xa48   ; STR "FEATURE_ON"
0x00015550  cmp      w23, #0
0x00015554  csel     x0, x9, x8, ne
0x00015558  bl       #0x17e20   ; CALL _L
0x0001555c  mov      x29, x29
0x00015560  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015564  mov      x23, x0
0x00015568  mov      x0, x20
0x0001556c  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x00015570  mov      x29, x29
0x00015574  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00015578  mov      x24, x0
0x0001557c  mov      x2, x23
0x00015580  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00015584  mov      x0, x24
0x00015588  bl       #0x55d78   ; CALL _objc_release
0x0001558c  mov      x0, x23
0x00015590  bl       #0x55d78   ; CALL _objc_release
0x00015594  mov      x0, x22
0x00015598  bl       #0x55d78   ; CALL _objc_release
0x0001559c  mov      x0, x20
0x000155a0  mov      w2, #1
0x000155a4  bl       #0x5a2a0   ; CALL objc_msgSend$setAccessoryType:
0x000155a8  mov      x0, x21
0x000155ac  bl       #0x55d78   ; CALL _objc_release
0x000155b0  mov      x0, x19
0x000155b4  bl       #0x55d78   ; CALL _objc_release
0x000155b8  ldp      x29, x30, [sp, #0x40]
0x000155bc  ldp      x20, x19, [sp, #0x30]
0x000155c0  ldp      x22, x21, [sp, #0x20]
0x000155c4  ldp      x24, x23, [sp, #0x10]
0x000155c8  add      sp, sp, #0x50
0x000155cc  ret      
