=== -[SPPSignView initWithFrame:]  va=0x2d3e4 size=1116 types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
0x0002d3e4  sub      sp, sp, #0x50
0x0002d3e8  stp      x24, x23, [sp, #0x10]
0x0002d3ec  stp      x22, x21, [sp, #0x20]
0x0002d3f0  stp      x20, x19, [sp, #0x30]
0x0002d3f4  stp      x29, x30, [sp, #0x40]
0x0002d3f8  add      x29, sp, #0x40
0x0002d3fc  adrp     x8, #0x8e000
0x0002d400  ldr      x8, [x8, #0xd78]   ; @SUPER SPPSignView
0x0002d404  stp      x0, x8, [sp]
0x0002d408  adrp     x8, #0x8c000
0x0002d40c  ldr      x1, [x8, #0x8c8]   ; @SEL "initWithFrame:"
0x0002d410  mov      x0, sp
0x0002d414  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0002d418  mov      x19, x0
0x0002d41c  cbz      x0, #0x2d604
0x0002d420  mov      x0, x19
0x0002d424  mov      w2, #0
0x0002d428  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x0002d42c  adrp     x23, #0x8e000
0x0002d430  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0002d434  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0002d438  mov      x29, x29
0x0002d43c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d440  mov      x20, x0
0x0002d444  mov      x0, x19
0x0002d448  mov      x2, x20
0x0002d44c  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0002d450  mov      x0, x20
0x0002d454  bl       #0x55d78   ; CALL _objc_release
0x0002d458  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0002d45c  adrp     x8, #0x65000
0x0002d460  ldr      d0, [x8, #0xa78]
0x0002d464  adrp     x8, #0x65000
0x0002d468  ldr      d1, [x8, #0x6a8]
0x0002d46c  adrp     x8, #0x65000
0x0002d470  ldr      d2, [x8, #0xa80]
0x0002d474  fmov     d3, #1.00000000
0x0002d478  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002d47c  mov      x29, x29
0x0002d480  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d484  mov      x20, x0
0x0002d488  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002d48c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002d490  mov      x21, x0
0x0002d494  mov      x0, x19
0x0002d498  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002d49c  mov      x29, x29
0x0002d4a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d4a4  mov      x22, x0
0x0002d4a8  mov      x2, x21
0x0002d4ac  bl       #0x5a700   ; CALL objc_msgSend$setBorderColor:
0x0002d4b0  mov      x0, x22
0x0002d4b4  bl       #0x55d78   ; CALL _objc_release
0x0002d4b8  mov      x0, x20
0x0002d4bc  bl       #0x55d78   ; CALL _objc_release
0x0002d4c0  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0002d4c4  bl       #0x56940   ; CALL objc_msgSend$blackColor
0x0002d4c8  mov      x29, x29
0x0002d4cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d4d0  mov      x20, x0
0x0002d4d4  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002d4d8  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002d4dc  mov      x21, x0
0x0002d4e0  mov      x0, x19
0x0002d4e4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002d4e8  mov      x29, x29
0x0002d4ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d4f0  mov      x22, x0
0x0002d4f4  mov      x2, x21
0x0002d4f8  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x0002d4fc  mov      x0, x22
0x0002d500  bl       #0x55d78   ; CALL _objc_release
0x0002d504  mov      x0, x20
0x0002d508  bl       #0x55d78   ; CALL _objc_release
0x0002d50c  mov      x0, x19
0x0002d510  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002d514  mov      x29, x29
0x0002d518  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d51c  mov      x20, x0
0x0002d520  adrp     x8, #0x65000
0x0002d524  ldr      s0, [x8, #0xd04]
0x0002d528  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x0002d52c  mov      x0, x20
0x0002d530  bl       #0x55d78   ; CALL _objc_release
0x0002d534  mov      x0, x19
0x0002d538  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002d53c  mov      x29, x29
0x0002d540  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d544  mov      x20, x0
0x0002d548  fmov     d0, #3.00000000
0x0002d54c  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x0002d550  mov      x0, x20
0x0002d554  bl       #0x55d78   ; CALL _objc_release
0x0002d558  mov      x0, x19
0x0002d55c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002d560  mov      x29, x29
0x0002d564  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d568  mov      x20, x0
0x0002d56c  fmov     d0, xzr
0x0002d570  fmov     d1, #1.50000000
0x0002d574  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x0002d578  mov      x0, x20
0x0002d57c  bl       #0x55d78   ; CALL _objc_release
0x0002d580  fmov     d0, #20.00000000
0x0002d584  bl       #0x2d6bc
0x0002d588  mov      x29, x29
0x0002d58c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d590  mov      x20, x0
0x0002d594  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0002d598  adrp     x8, #0x65000
0x0002d59c  ldr      d0, [x8, #0xa88]
0x0002d5a0  fmov     d3, #1.00000000
0x0002d5a4  mov      v1.16b, v0.16b
0x0002d5a8  mov      v2.16b, v0.16b
0x0002d5ac  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002d5b0  mov      x29, x29
0x0002d5b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d5b8  mov      x21, x0
0x0002d5bc  mov      x0, x20
0x0002d5c0  mov      x1, x21
0x0002d5c4  bl       #0x2d620
0x0002d5c8  mov      x29, x29
0x0002d5cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d5d0  adrp     x8, #0x8e000
0x0002d5d4  ldrsw    x22, [x8, #0xed8]
0x0002d5d8  ldr      x8, [x19, x22]
0x0002d5dc  str      x0, [x19, x22]
0x0002d5e0  mov      x0, x8
0x0002d5e4  bl       #0x55d78   ; CALL _objc_release
0x0002d5e8  mov      x0, x21
0x0002d5ec  bl       #0x55d78   ; CALL _objc_release
0x0002d5f0  mov      x0, x20
0x0002d5f4  bl       #0x55d78   ; CALL _objc_release
0x0002d5f8  ldr      x2, [x19, x22]
0x0002d5fc  mov      x0, x19
0x0002d600  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002d604  mov      x0, x19
0x0002d608  ldp      x29, x30, [sp, #0x40]
0x0002d60c  ldp      x20, x19, [sp, #0x30]
0x0002d610  ldp      x22, x21, [sp, #0x20]
0x0002d614  ldp      x24, x23, [sp, #0x10]
0x0002d618  add      sp, sp, #0x50
0x0002d61c  ret      
0x0002d620  stp      x22, x21, [sp, #-0x30]!
0x0002d624  stp      x20, x19, [sp, #0x10]
0x0002d628  stp      x29, x30, [sp, #0x20]
0x0002d62c  add      x29, sp, #0x20
0x0002d630  mov      x19, x1
0x0002d634  mov      x20, x0
0x0002d638  adrp     x8, #0x8e000
0x0002d63c  ldr      x21, [x8, #0x940]   ; @CLASS UILabel
0x0002d640  mov      x0, x1
0x0002d644  bl       #0x55d84   ; CALL _objc_retain
0x0002d648  mov      x0, x20
0x0002d64c  bl       #0x55d84   ; CALL _objc_retain
0x0002d650  mov      x0, x21
0x0002d654  bl       #0x55c88   ; CALL _objc_alloc_init
0x0002d658  mov      x21, x0
0x0002d65c  mov      x2, x20
0x0002d660  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x0002d664  mov      x0, x20
0x0002d668  bl       #0x55d78   ; CALL _objc_release
0x0002d66c  mov      x0, x21
0x0002d670  mov      x2, x19
0x0002d674  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0002d678  mov      x0, x19
0x0002d67c  bl       #0x55d78   ; CALL _objc_release
0x0002d680  mov      x0, x21
0x0002d684  mov      w2, #1
0x0002d688  bl       #0x5c4e0   ; CALL objc_msgSend$setTextAlignment:
0x0002d68c  mov      x0, x21
0x0002d690  mov      w2, #1
0x0002d694  bl       #0x5a380   ; CALL objc_msgSend$setAdjustsFontSizeToFitWidth:
0x0002d698  adrp     x8, #0x65000
0x0002d69c  ldr      d0, [x8, #0x6e8]
0x0002d6a0  mov      x0, x21
0x0002d6a4  bl       #0x5b660   ; CALL objc_msgSend$setMinimumScaleFactor:
0x0002d6a8  mov      x0, x21
0x0002d6ac  ldp      x29, x30, [sp, #0x20]
0x0002d6b0  ldp      x20, x19, [sp, #0x10]
0x0002d6b4  ldp      x22, x21, [sp], #0x30
0x0002d6b8  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0002d6bc  sub      sp, sp, #0x70
0x0002d6c0  stp      d9, d8, [sp, #0x20]
0x0002d6c4  stp      x24, x23, [sp, #0x30]
0x0002d6c8  stp      x22, x21, [sp, #0x40]
0x0002d6cc  stp      x20, x19, [sp, #0x50]
0x0002d6d0  stp      x29, x30, [sp, #0x60]
0x0002d6d4  add      x29, sp, #0x60
0x0002d6d8  mov      v8.16b, v0.16b
0x0002d6dc  adrp     x8, #0x74000
0x0002d6e0  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0002d6e4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002d6e8  str      x8, [sp, #0x18]
0x0002d6ec  adrp     x23, #0x8e000
0x0002d6f0  ldr      x0, [x23, #0x948]   ; @CLASS UIFont
0x0002d6f4  adrp     x8, #0x74000
0x0002d6f8  ldr      x8, [x8, #0x240]   ; @GOT _UIFontWeightHeavy
0x0002d6fc  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x0002d700  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x0002d704  mov      x29, x29
0x0002d708  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d70c  mov      x19, x0
0x0002d710  bl       #0x57c80   ; CALL objc_msgSend$fontDescriptor
0x0002d714  mov      x29, x29
0x0002d718  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d71c  mov      x21, x0
0x0002d720  adrp     x8, #0x74000
0x0002d724  ldr      x8, [x8, #0x208]   ; @GOT _UIFontDescriptorSystemDesignRounded
0x0002d728  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0002d72c  bl       #0x57cc0   ; CALL objc_msgSend$fontDescriptorWithDesign:
0x0002d730  mov      x29, x29
0x0002d734  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d738  mov      x22, x0
0x0002d73c  cbz      x0, #0x2d750
0x0002d740  mov      x0, x22
0x0002d744  bl       #0x55d84   ; CALL _objc_retain
0x0002d748  mov      x20, x22
0x0002d74c  b        #0x2d764
0x0002d750  mov      x0, x19
0x0002d754  bl       #0x57c80   ; CALL objc_msgSend$fontDescriptor
0x0002d758  mov      x29, x29
0x0002d75c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d760  mov      x20, x0
0x0002d764  mov      x0, x22
0x0002d768  bl       #0x55d78   ; CALL _objc_release
0x0002d76c  mov      x0, x21
0x0002d770  bl       #0x55d78   ; CALL _objc_release
0x0002d774  adrp     x8, #0x74000
0x0002d778  ldr      x8, [x8, #0x200]   ; @GOT _UIFontDescriptorFeatureSettingsAttribute
0x0002d77c  ldr      x9, [x8]   ; @GOT ___objc_personality_v0
0x0002d780  adrp     x8, #0x7f000
0x0002d784  add      x8, x8, #0xbd0
0x0002d788  stp      x9, x8, [sp, #8]
0x0002d78c  adrp     x8, #0x8e000
0x0002d790  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x0002d794  add      x2, sp, #0x10
0x0002d798  add      x3, sp, #8
0x0002d79c  mov      w4, #1
0x0002d7a0  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0002d7a4  mov      x29, x29
0x0002d7a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d7ac  mov      x21, x0
0x0002d7b0  mov      x0, x20
0x0002d7b4  mov      x2, x21
0x0002d7b8  bl       #0x57ca0   ; CALL objc_msgSend$fontDescriptorByAddingAttributes:
0x0002d7bc  mov      x29, x29
0x0002d7c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d7c4  mov      x22, x0
0x0002d7c8  mov      x0, x20
0x0002d7cc  bl       #0x55d78   ; CALL _objc_release
0x0002d7d0  mov      x0, x21
0x0002d7d4  bl       #0x55d78   ; CALL _objc_release
0x0002d7d8  ldr      x0, [x23, #0x948]   ; @CLASS UIFont
0x0002d7dc  mov      x2, x22
0x0002d7e0  mov      v0.16b, v8.16b
0x0002d7e4  bl       #0x57ce0   ; CALL objc_msgSend$fontWithDescriptor:size:
0x0002d7e8  mov      x29, x29
0x0002d7ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d7f0  mov      x20, x0
0x0002d7f4  mov      x0, x22
0x0002d7f8  bl       #0x55d78   ; CALL _objc_release
0x0002d7fc  mov      x0, x19
0x0002d800  bl       #0x55d78   ; CALL _objc_release
0x0002d804  ldr      x8, [sp, #0x18]
0x0002d808  adrp     x9, #0x74000
0x0002d80c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0002d810  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0002d814  cmp      x9, x8
0x0002d818  b.ne     #0x2d83c
0x0002d81c  mov      x0, x20
0x0002d820  ldp      x29, x30, [sp, #0x60]
0x0002d824  ldp      x20, x19, [sp, #0x50]
0x0002d828  ldp      x22, x21, [sp, #0x40]
0x0002d82c  ldp      x24, x23, [sp, #0x30]
0x0002d830  ldp      d9, d8, [sp, #0x20]
0x0002d834  add      sp, sp, #0x70
0x0002d838  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0002d83c  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[SPPSignView applyColors]  va=0x2d840 size=320 types=v16@0:8
0x0002d840  stp      x24, x23, [sp, #-0x40]!
0x0002d844  stp      x22, x21, [sp, #0x10]
0x0002d848  stp      x20, x19, [sp, #0x20]
0x0002d84c  stp      x29, x30, [sp, #0x30]
0x0002d850  add      x29, sp, #0x30
0x0002d854  mov      x19, x0
0x0002d858  bl       #0x590c0   ; CALL objc_msgSend$muted
0x0002d85c  mov      x8, x0
0x0002d860  adrp     x21, #0x8e000
0x0002d864  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x0002d868  tbz      w8, #0, #0x2d88c
0x0002d86c  adrp     x8, #0x65000
0x0002d870  ldr      d0, [x8, #0x9c0]
0x0002d874  adrp     x8, #0x65000
0x0002d878  ldr      d1, [x8, #0xa90]
0x0002d87c  adrp     x8, #0x65000
0x0002d880  ldr      d2, [x8, #0xa98]
0x0002d884  fmov     d3, #1.00000000
0x0002d888  b        #0x2d8a0
0x0002d88c  adrp     x8, #0x65000
0x0002d890  ldr      d0, [x8, #0xa88]
0x0002d894  fmov     d3, #1.00000000
0x0002d898  mov      v1.16b, v0.16b
0x0002d89c  mov      v2.16b, v0.16b
0x0002d8a0  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002d8a4  mov      x29, x29
0x0002d8a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d8ac  mov      x20, x0
0x0002d8b0  mov      x0, x19
0x0002d8b4  bl       #0x590c0   ; CALL objc_msgSend$muted
0x0002d8b8  mov      x8, x0
0x0002d8bc  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x0002d8c0  cbz      w8, #0x2d8e0
0x0002d8c4  adrp     x8, #0x65000
0x0002d8c8  ldr      d0, [x8, #0xaa0]
0x0002d8cc  adrp     x8, #0x65000
0x0002d8d0  ldr      d1, [x8, #0x920]
0x0002d8d4  adrp     x8, #0x65000
0x0002d8d8  ldr      d2, [x8, #0xaa8]
0x0002d8dc  b        #0x2d8f8
0x0002d8e0  adrp     x8, #0x65000
0x0002d8e4  ldr      d0, [x8, #0xa78]
0x0002d8e8  adrp     x8, #0x65000
0x0002d8ec  ldr      d1, [x8, #0x6a8]
0x0002d8f0  adrp     x8, #0x65000
0x0002d8f4  ldr      d2, [x8, #0xa80]
0x0002d8f8  fmov     d3, #1.00000000
0x0002d8fc  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002d900  mov      x29, x29
0x0002d904  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d908  mov      x21, x0
0x0002d90c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002d910  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002d914  mov      x22, x0
0x0002d918  mov      x0, x19
0x0002d91c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002d920  mov      x29, x29
0x0002d924  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d928  mov      x23, x0
0x0002d92c  mov      x2, x22
0x0002d930  bl       #0x5a700   ; CALL objc_msgSend$setBorderColor:
0x0002d934  mov      x0, x23
0x0002d938  bl       #0x55d78   ; CALL _objc_release
0x0002d93c  mov      x0, x21
0x0002d940  bl       #0x55d78   ; CALL _objc_release
0x0002d944  mov      x0, x19
0x0002d948  bl       #0x589c0   ; CALL objc_msgSend$label
0x0002d94c  mov      x29, x29
0x0002d950  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d954  mov      x19, x0
0x0002d958  mov      x2, x20
0x0002d95c  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0002d960  mov      x0, x19
0x0002d964  bl       #0x55d78   ; CALL _objc_release
0x0002d968  mov      x0, x20
0x0002d96c  ldp      x29, x30, [sp, #0x30]
0x0002d970  ldp      x20, x19, [sp, #0x20]
0x0002d974  ldp      x22, x21, [sp, #0x10]
0x0002d978  ldp      x24, x23, [sp], #0x40
0x0002d97c  b        #0x55d78   ; CALL _objc_release

=== -[SPPSignView setMuted:]  va=0x2d980 size=136 types=v20@0:8B16
0x0002d980  stp      x24, x23, [sp, #-0x40]!
0x0002d984  stp      x22, x21, [sp, #0x10]
0x0002d988  stp      x20, x19, [sp, #0x20]
0x0002d98c  stp      x29, x30, [sp, #0x30]
0x0002d990  add      x29, sp, #0x30
0x0002d994  mov      x19, x2
0x0002d998  mov      x20, x0
0x0002d99c  adrp     x8, #0x8e000
0x0002d9a0  ldrsw    x23, [x8, #0xedc]
0x0002d9a4  ldrb     w8, [x0, x23]
0x0002d9a8  cmp      w8, w2
0x0002d9ac  b.ne     #0x2d9ec
0x0002d9b0  mov      x0, x20
0x0002d9b4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002d9b8  mov      x29, x29
0x0002d9bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002d9c0  mov      x21, x0
0x0002d9c4  bl       #0x569e0   ; CALL objc_msgSend$borderColor
0x0002d9c8  mov      x22, x0
0x0002d9cc  mov      x0, x21
0x0002d9d0  bl       #0x55d78   ; CALL _objc_release
0x0002d9d4  cbz      x22, #0x2d9ec
0x0002d9d8  ldp      x29, x30, [sp, #0x30]
0x0002d9dc  ldp      x20, x19, [sp, #0x20]
0x0002d9e0  ldp      x22, x21, [sp, #0x10]
0x0002d9e4  ldp      x24, x23, [sp], #0x40
0x0002d9e8  ret      
0x0002d9ec  strb     w19, [x20, x23]
0x0002d9f0  mov      x0, x20
0x0002d9f4  ldp      x29, x30, [sp, #0x30]
0x0002d9f8  ldp      x20, x19, [sp, #0x20]
0x0002d9fc  ldp      x22, x21, [sp, #0x10]
0x0002da00  ldp      x24, x23, [sp], #0x40
0x0002da04  b        #0x564e0   ; CALL objc_msgSend$applyColors

=== -[SPPSignView layoutSubviews]  va=0x2da08 size=436 types=v16@0:8
0x0002da08  sub      sp, sp, #0x70
0x0002da0c  stp      d11, d10, [sp, #0x10]
0x0002da10  stp      d9, d8, [sp, #0x20]
0x0002da14  stp      x24, x23, [sp, #0x30]
0x0002da18  stp      x22, x21, [sp, #0x40]
0x0002da1c  stp      x20, x19, [sp, #0x50]
0x0002da20  stp      x29, x30, [sp, #0x60]
0x0002da24  add      x29, sp, #0x60
0x0002da28  mov      x19, x0
0x0002da2c  adrp     x8, #0x8e000
0x0002da30  ldr      x8, [x8, #0xd78]   ; @SUPER SPPSignView
0x0002da34  stp      x0, x8, [sp]
0x0002da38  adrp     x8, #0x8b000
0x0002da3c  ldr      x1, [x8, #0xe28]   ; @SEL "layoutSubviews"
0x0002da40  mov      x0, sp
0x0002da44  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0002da48  mov      x0, x19
0x0002da4c  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0002da50  mov      v9.16b, v2.16b
0x0002da54  adrp     x8, #0x65000
0x0002da58  ldr      d0, [x8, #0x5f0]
0x0002da5c  fmul     d8, d2, d0
0x0002da60  fmov     d0, #0.50000000
0x0002da64  fmul     d10, d2, d0
0x0002da68  mov      x0, x19
0x0002da6c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002da70  mov      x29, x29
0x0002da74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002da78  mov      x20, x0
0x0002da7c  mov      v0.16b, v10.16b
0x0002da80  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0002da84  mov      x0, x20
0x0002da88  bl       #0x55d78   ; CALL _objc_release
0x0002da8c  mov      x0, x19
0x0002da90  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002da94  mov      x29, x29
0x0002da98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002da9c  mov      x20, x0
0x0002daa0  mov      v0.16b, v8.16b
0x0002daa4  bl       #0x5a740   ; CALL objc_msgSend$setBorderWidth:
0x0002daa8  mov      x0, x20
0x0002daac  bl       #0x55d78   ; CALL _objc_release
0x0002dab0  mov      x0, x19
0x0002dab4  bl       #0x589c0   ; CALL objc_msgSend$label
0x0002dab8  mov      x29, x29
0x0002dabc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002dac0  mov      x20, x0
0x0002dac4  bl       #0x5d980   ; CALL objc_msgSend$text
0x0002dac8  mov      x29, x29
0x0002dacc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002dad0  mov      x21, x0
0x0002dad4  bl       #0x58c20   ; CALL objc_msgSend$length
0x0002dad8  cmp      x0, #2
0x0002dadc  mov      w8, #8
0x0002dae0  csel     x8, x8, xzr, hi
0x0002dae4  adrp     x9, #0x65000
0x0002dae8  add      x9, x9, #0xd20
0x0002daec  ldr      d0, [x9, x8]
0x0002daf0  fmul     d0, d9, d0
0x0002daf4  bl       #0x2d6bc
0x0002daf8  mov      x29, x29
0x0002dafc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002db00  mov      x22, x0
0x0002db04  mov      x0, x19
0x0002db08  bl       #0x589c0   ; CALL objc_msgSend$label
0x0002db0c  mov      x29, x29
0x0002db10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002db14  mov      x23, x0
0x0002db18  mov      x2, x22
0x0002db1c  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x0002db20  mov      x0, x23
0x0002db24  bl       #0x55d78   ; CALL _objc_release
0x0002db28  mov      x0, x22
0x0002db2c  bl       #0x55d78   ; CALL _objc_release
0x0002db30  mov      x0, x21
0x0002db34  bl       #0x55d78   ; CALL _objc_release
0x0002db38  mov      x0, x20
0x0002db3c  bl       #0x55d78   ; CALL _objc_release
0x0002db40  mov      x0, x19
0x0002db44  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0002db48  adrp     x8, #0x65000
0x0002db4c  ldr      d4, [x8, #0x708]
0x0002db50  fmul     d4, d8, d4
0x0002db54  mov      v5.16b, v8.16b
0x0002db58  bl       #0x55a90   ; CALL _CGRectInset
0x0002db5c  mov      v8.16b, v0.16b
0x0002db60  mov      v9.16b, v1.16b
0x0002db64  mov      v10.16b, v2.16b
0x0002db68  mov      v11.16b, v3.16b
0x0002db6c  mov      x0, x19
0x0002db70  bl       #0x589c0   ; CALL objc_msgSend$label
0x0002db74  mov      x29, x29
0x0002db78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002db7c  mov      x19, x0
0x0002db80  mov      v0.16b, v8.16b
0x0002db84  mov      v1.16b, v9.16b
0x0002db88  mov      v2.16b, v10.16b
0x0002db8c  mov      v3.16b, v11.16b
0x0002db90  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0002db94  mov      x0, x19
0x0002db98  bl       #0x55d78   ; CALL _objc_release
0x0002db9c  ldp      x29, x30, [sp, #0x60]
0x0002dba0  ldp      x20, x19, [sp, #0x50]
0x0002dba4  ldp      x22, x21, [sp, #0x40]
0x0002dba8  ldp      x24, x23, [sp, #0x30]
0x0002dbac  ldp      d9, d8, [sp, #0x20]
0x0002dbb0  ldp      d11, d10, [sp, #0x10]
0x0002dbb4  add      sp, sp, #0x70
0x0002dbb8  ret      

=== -[SPPSignView label]  va=0x2dbbc size=16 types=@16@0:8
0x0002dbbc  adrp     x8, #0x8e000
0x0002dbc0  ldrsw    x8, [x8, #0xed8]
0x0002dbc4  ldr      x0, [x0, x8]
0x0002dbc8  ret      

=== -[SPPSignView setLabel:]  va=0x2dbcc size=64 types=v24@0:8@16
0x0002dbcc  stp      x22, x21, [sp, #-0x30]!
0x0002dbd0  stp      x20, x19, [sp, #0x10]
0x0002dbd4  stp      x29, x30, [sp, #0x20]
0x0002dbd8  add      x29, sp, #0x20
0x0002dbdc  mov      x19, x2
0x0002dbe0  mov      x20, x0
0x0002dbe4  adrp     x8, #0x8e000
0x0002dbe8  ldrsw    x21, [x8, #0xed8]
0x0002dbec  mov      x0, x2
0x0002dbf0  bl       #0x55d84   ; CALL _objc_retain
0x0002dbf4  ldr      x0, [x20, x21]
0x0002dbf8  str      x19, [x20, x21]
0x0002dbfc  ldp      x29, x30, [sp, #0x20]
0x0002dc00  ldp      x20, x19, [sp, #0x10]
0x0002dc04  ldp      x22, x21, [sp], #0x30
0x0002dc08  b        #0x55d78   ; CALL _objc_release

=== -[SPPSignView muted]  va=0x2dc0c size=16 types=B16@0:8
0x0002dc0c  adrp     x8, #0x8e000
0x0002dc10  ldrsw    x8, [x8, #0xedc]
0x0002dc14  ldrb     w0, [x0, x8]
0x0002dc18  ret      

=== -[SPPSignView .cxx_destruct]  va=0x2dc1c size=20 types=v16@0:8
0x0002dc1c  adrp     x8, #0x8e000
0x0002dc20  ldrsw    x8, [x8, #0xed8]
0x0002dc24  add      x0, x0, x8
0x0002dc28  mov      x1, #0
0x0002dc2c  b        #0x55dcc   ; CALL _objc_storeStrong
