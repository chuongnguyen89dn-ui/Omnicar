=== -[OMCSplitScreenAppLinkCell initWithStyle:reuseIdentifier:specifier:]  va=0x36118 size=56 types=@40@0:8q16@24@32
0x00036118  sub      sp, sp, #0x20
0x0003611c  stp      x29, x30, [sp, #0x10]
0x00036120  add      x29, sp, #0x10
0x00036124  adrp     x8, #0x8e000
0x00036128  ldr      x8, [x8, #0xd88]   ; @SUPER OMCSplitScreenAppLinkCell
0x0003612c  stp      x0, x8, [sp]
0x00036130  adrp     x8, #0x8b000
0x00036134  ldr      x1, [x8, #0xe30]   ; @SEL "initWithStyle:reuseIdentifier:specifier:"
0x00036138  mov      x0, sp
0x0003613c  mov      w2, #1
0x00036140  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00036144  ldp      x29, x30, [sp, #0x10]
0x00036148  add      sp, sp, #0x20
0x0003614c  ret      

=== -[OMCSplitScreenAppLinkCell refreshCellContentsWithSpecifier:]  va=0x36150 size=608 types=v24@0:8@16
0x00036150  sub      sp, sp, #0x40
0x00036154  stp      x22, x21, [sp, #0x10]
0x00036158  stp      x20, x19, [sp, #0x20]
0x0003615c  stp      x29, x30, [sp, #0x30]
0x00036160  add      x29, sp, #0x30
0x00036164  mov      x20, x2
0x00036168  mov      x19, x0
0x0003616c  adrp     x8, #0x8e000
0x00036170  ldr      x8, [x8, #0xd88]   ; @SUPER OMCSplitScreenAppLinkCell
0x00036174  stp      x0, x8, [sp]
0x00036178  adrp     x8, #0x8b000
0x0003617c  ldr      x21, [x8, #0xe38]   ; @SEL "refreshCellContentsWithSpecifier:"
0x00036180  mov      x0, x2
0x00036184  bl       #0x55d84   ; CALL _objc_retain
0x00036188  mov      x0, sp
0x0003618c  mov      x1, x21
0x00036190  mov      x2, x20
0x00036194  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00036198  adrp     x2, #0x76000
0x0003619c  add      x2, x2, #0xfc8   ; STR "key"
0x000361a0  mov      x0, x20
0x000361a4  bl       #0x59aa0   ; CALL objc_msgSend$propertyForKey:
0x000361a8  mov      x29, x29
0x000361ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000361b0  mov      x21, x0
0x000361b4  mov      x0, x20
0x000361b8  bl       #0x55d78   ; CALL _objc_release
0x000361bc  mov      x0, x21
0x000361c0  bl       #0x36280
0x000361c4  mov      x29, x29
0x000361c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000361cc  mov      x20, x0
0x000361d0  mov      x0, x21
0x000361d4  bl       #0x55d78   ; CALL _objc_release
0x000361d8  adrp     x8, #0x8e000
0x000361dc  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x000361e0  bl       #0x55d48   ; CALL _objc_opt_class
0x000361e4  mov      x1, x0
0x000361e8  mov      x0, x20
0x000361ec  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x000361f0  tbz      w0, #0, #0x36214
0x000361f4  mov      x0, x20
0x000361f8  bl       #0x58c20   ; CALL objc_msgSend$length
0x000361fc  cbz      x0, #0x36214
0x00036200  mov      x0, x20
0x00036204  bl       #0x362e8
0x00036208  mov      x29, x29
0x0003620c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036210  b        #0x36228
0x00036214  adrp     x0, #0x7b000
0x00036218  add      x0, x0, #0x968   ; STR "SPLITSCREEN_APP_NOT_SET"
0x0003621c  bl       #0x17e20   ; CALL _L
0x00036220  mov      x29, x29
0x00036224  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036228  mov      x21, x0
0x0003622c  mov      x0, x19
0x00036230  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x00036234  mov      x29, x29
0x00036238  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0003623c  mov      x22, x0
0x00036240  mov      x2, x21
0x00036244  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00036248  mov      x0, x22
0x0003624c  bl       #0x55d78   ; CALL _objc_release
0x00036250  mov      x0, x21
0x00036254  bl       #0x55d78   ; CALL _objc_release
0x00036258  mov      x0, x19
0x0003625c  mov      w2, #1
0x00036260  bl       #0x5a2a0   ; CALL objc_msgSend$setAccessoryType:
0x00036264  mov      x0, x20
0x00036268  bl       #0x55d78   ; CALL _objc_release
0x0003626c  ldp      x29, x30, [sp, #0x30]
0x00036270  ldp      x20, x19, [sp, #0x20]
0x00036274  ldp      x22, x21, [sp, #0x10]
0x00036278  add      sp, sp, #0x40
0x0003627c  ret      
0x00036280  stp      x20, x19, [sp, #-0x20]!
0x00036284  stp      x29, x30, [sp, #0x10]
0x00036288  add      x29, sp, #0x10
0x0003628c  mov      x19, x0
0x00036290  bl       #0x55d84   ; CALL _objc_retain
0x00036294  adrp     x8, #0x8e000
0x00036298  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0003629c  bl       #0x55d48   ; CALL _objc_opt_class
0x000362a0  mov      x1, x0
0x000362a4  mov      x0, x19
0x000362a8  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x000362ac  tbz      w0, #0, #0x362cc
0x000362b0  adrp     x1, #0x75000
0x000362b4  add      x1, x1, #0x28   ; STR "com.anlai.omnicar"
0x000362b8  mov      x0, x19
0x000362bc  bl       #0x5585c   ; CALL _CFPreferencesCopyAppValue
0x000362c0  cmp      x0, #0
0x000362c4  csel     x20, xzr, x0, eq
0x000362c8  b        #0x362d0
0x000362cc  mov      x20, #0
0x000362d0  mov      x0, x19
0x000362d4  bl       #0x55d78   ; CALL _objc_release
0x000362d8  mov      x0, x20
0x000362dc  ldp      x29, x30, [sp, #0x10]
0x000362e0  ldp      x20, x19, [sp], #0x20
0x000362e4  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x000362e8  stp      x22, x21, [sp, #-0x30]!
0x000362ec  stp      x20, x19, [sp, #0x10]
0x000362f0  stp      x29, x30, [sp, #0x20]
0x000362f4  add      x29, sp, #0x20
0x000362f8  mov      x19, x0
0x000362fc  bl       #0x55d84   ; CALL _objc_retain
0x00036300  adrp     x0, #0x63000
0x00036304  add      x0, x0, #0xf6   ; CSTR "LSApplicationProxy"
0x00036308  bl       #0x55d0c   ; CALL _objc_getClass
0x0003630c  mov      x20, x0
0x00036310  cbz      x0, #0x36368
0x00036314  adrp     x0, #0x79000
0x00036318  add      x0, x0, #0xc68   ; STR "applicationProxyForIdentifier:"
0x0003631c  bl       #0x55b08   ; CALL _NSSelectorFromString
0x00036320  mov      x1, x0
0x00036324  mov      x0, x20
0x00036328  mov      x2, x19
0x0003632c  bl       #0x55d30   ; CALL _objc_msgSend
0x00036330  mov      x29, x29
0x00036334  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036338  mov      x20, x0
0x0003633c  cbz      x0, #0x36368
0x00036340  adrp     x0, #0x79000
0x00036344  add      x0, x0, #0xc88   ; STR "localizedName"
0x00036348  bl       #0x55b08   ; CALL _NSSelectorFromString
0x0003634c  mov      x1, x0
0x00036350  mov      x0, x20
0x00036354  bl       #0x55d30   ; CALL _objc_msgSend
0x00036358  mov      x29, x29
0x0003635c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00036360  mov      x21, x0
0x00036364  b        #0x3636c
0x00036368  mov      x21, #0
0x0003636c  mov      x0, x21
0x00036370  bl       #0x58c20   ; CALL objc_msgSend$length
0x00036374  cmp      x0, #0
0x00036378  csel     x22, x19, x21, eq
0x0003637c  mov      x0, x22
0x00036380  bl       #0x55d84   ; CALL _objc_retain
0x00036384  mov      x0, x21
0x00036388  bl       #0x55d78   ; CALL _objc_release
0x0003638c  mov      x0, x20
0x00036390  bl       #0x55d78   ; CALL _objc_release
0x00036394  mov      x0, x19
0x00036398  bl       #0x55d78   ; CALL _objc_release
0x0003639c  mov      x0, x22
0x000363a0  ldp      x29, x30, [sp, #0x20]
0x000363a4  ldp      x20, x19, [sp, #0x10]
0x000363a8  ldp      x22, x21, [sp], #0x30
0x000363ac  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
