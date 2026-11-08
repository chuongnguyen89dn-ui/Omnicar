=== +[SSStartupView layerClass]  va=0x46260 size=12 types=#16@0:8
0x00046260  adrp     x8, #0x8e000
0x00046264  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x00046268  b        #0x55d48   ; CALL _objc_opt_class

=== -[SSStartupView initWithFrame:]  va=0x4626c size=180 types=@48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
0x0004626c  sub      sp, sp, #0x40
0x00046270  stp      x22, x21, [sp, #0x10]
0x00046274  stp      x20, x19, [sp, #0x20]
0x00046278  stp      x29, x30, [sp, #0x30]
0x0004627c  add      x29, sp, #0x30
0x00046280  adrp     x8, #0x8e000
0x00046284  ldr      x8, [x8, #0xdb8]   ; @SUPER SSStartupView
0x00046288  stp      x0, x8, [sp]
0x0004628c  adrp     x8, #0x8c000
0x00046290  ldr      x1, [x8, #0x8c8]   ; @SEL "initWithFrame:"
0x00046294  mov      x0, sp
0x00046298  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0004629c  mov      x19, x0
0x000462a0  cbz      x0, #0x46308
0x000462a4  mov      w21, #1
0x000462a8  mov      x0, x19
0x000462ac  mov      w2, #1
0x000462b0  bl       #0x5a8a0   ; CALL objc_msgSend$setClipsToBounds:
0x000462b4  adrp     x8, #0x8e000
0x000462b8  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x000462bc  bl       #0x56940   ; CALL objc_msgSend$blackColor
0x000462c0  mov      x29, x29
0x000462c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000462c8  mov      x20, x0
0x000462cc  mov      x0, x19
0x000462d0  mov      x2, x20
0x000462d4  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x000462d8  mov      x0, x20
0x000462dc  bl       #0x55d78   ; CALL _objc_release
0x000462e0  adrp     x8, #0x8e000
0x000462e4  ldrsw    x8, [x8, #0xff4]
0x000462e8  mov      x9, #-1
0x000462ec  str      x9, [x19, x8]
0x000462f0  adrp     x8, #0x8e000
0x000462f4  ldrsw    x8, [x8, #0xff8]
0x000462f8  str      x21, [x19, x8]
0x000462fc  adrp     x8, #0x8e000
0x00046300  ldrsw    x8, [x8, #0xffc]
0x00046304  str      x9, [x19, x8]
0x00046308  mov      x0, x19
0x0004630c  ldp      x29, x30, [sp, #0x30]
0x00046310  ldp      x20, x19, [sp, #0x20]
0x00046314  ldp      x22, x21, [sp, #0x10]
0x00046318  add      sp, sp, #0x40
0x0004631c  ret      

=== -[SSStartupView dealloc]  va=0x46320 size=80 types=v16@0:8
0x00046320  sub      sp, sp, #0x30
0x00046324  stp      x20, x19, [sp, #0x10]
0x00046328  stp      x29, x30, [sp, #0x20]
0x0004632c  add      x29, sp, #0x20
0x00046330  mov      x19, x0
0x00046334  adrp     x8, #0x8f000
0x00046338  ldrsw    x8, [x8]
0x0004633c  ldr      x0, [x0, x8]
0x00046340  bl       #0x58740   ; CALL objc_msgSend$invalidate
0x00046344  adrp     x8, #0x8e000
0x00046348  ldr      x8, [x8, #0xdb8]   ; @SUPER SSStartupView
0x0004634c  stp      x19, x8, [sp]
0x00046350  adrp     x8, #0x8b000
0x00046354  ldr      x1, [x8, #0xf38]   ; @SEL "dealloc"
0x00046358  mov      x0, sp
0x0004635c  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00046360  ldp      x29, x30, [sp, #0x20]
0x00046364  ldp      x20, x19, [sp, #0x10]
0x00046368  add      sp, sp, #0x30
0x0004636c  ret      

=== -[SSStartupView clearContent]  va=0x46370 size=704 types=v16@0:8
0x00046370  sub      sp, sp, #0x110
0x00046374  stp      x24, x23, [sp, #0xd0]
0x00046378  stp      x22, x21, [sp, #0xe0]
0x0004637c  stp      x20, x19, [sp, #0xf0]
0x00046380  stp      x29, x30, [sp, #0x100]
0x00046384  add      x29, sp, #0x100
0x00046388  mov      x19, x0
0x0004638c  adrp     x8, #0x74000
0x00046390  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00046394  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00046398  stur     x8, [x29, #-0x38]
0x0004639c  movi     v0.16b, #0
0x000463a0  stp      q0, q0, [sp]
0x000463a4  stp      q0, q0, [sp, #0x20]
0x000463a8  bl       #0x5d700   ; CALL objc_msgSend$subviews
0x000463ac  mov      x29, x29
0x000463b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000463b4  mov      x21, x0
0x000463b8  bl       #0x572e0   ; CALL objc_msgSend$copy
0x000463bc  mov      x20, x0
0x000463c0  mov      x0, x21
0x000463c4  bl       #0x55d78   ; CALL _objc_release
0x000463c8  mov      x2, sp
0x000463cc  add      x3, sp, #0x48
0x000463d0  mov      x0, x20
0x000463d4  mov      w4, #0x10
0x000463d8  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x000463dc  cbz      x0, #0x4643c
0x000463e0  mov      x21, x0
0x000463e4  ldr      x8, [sp, #0x10]
0x000463e8  ldr      x22, [x8]   ; @GOT ___objc_personality_v0
0x000463ec  mov      x23, #0
0x000463f0  ldr      x8, [sp, #0x10]
0x000463f4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000463f8  cmp      x8, x22
0x000463fc  b.eq     #0x46408
0x00046400  mov      x0, x20
0x00046404  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00046408  ldr      x8, [sp, #8]
0x0004640c  ldr      x0, [x8, x23, lsl #3]   ; @GOT ___objc_personality_v0
0x00046410  bl       #0x59e00   ; CALL objc_msgSend$removeFromSuperview
0x00046414  add      x23, x23, #1
0x00046418  cmp      x21, x23
0x0004641c  b.ne     #0x463f0
0x00046420  mov      x2, sp
0x00046424  add      x3, sp, #0x48
0x00046428  mov      x0, x20
0x0004642c  mov      w4, #0x10
0x00046430  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00046434  mov      x21, x0
0x00046438  cbnz     x0, #0x463ec
0x0004643c  mov      x0, x20
0x00046440  bl       #0x55d78   ; CALL _objc_release
0x00046444  adrp     x8, #0x8f000
0x00046448  ldrsw    x8, [x8, #4]
0x0004644c  ldr      x0, [x19, x8]
0x00046450  str      xzr, [x19, x8]
0x00046454  bl       #0x55d78   ; CALL _objc_release
0x00046458  adrp     x8, #0x8f000
0x0004645c  ldrsw    x8, [x8, #8]
0x00046460  ldr      x0, [x19, x8]
0x00046464  str      xzr, [x19, x8]
0x00046468  bl       #0x55d78   ; CALL _objc_release
0x0004646c  adrp     x8, #0x8f000
0x00046470  ldrsw    x8, [x8, #0xc]
0x00046474  ldr      x0, [x19, x8]
0x00046478  str      xzr, [x19, x8]
0x0004647c  bl       #0x55d78   ; CALL _objc_release
0x00046480  adrp     x8, #0x8f000
0x00046484  ldrsw    x8, [x8, #0x10]
0x00046488  ldr      x0, [x19, x8]
0x0004648c  str      xzr, [x19, x8]
0x00046490  bl       #0x55d78   ; CALL _objc_release
0x00046494  adrp     x8, #0x8f000
0x00046498  ldrsw    x8, [x8, #0x14]
0x0004649c  ldr      x0, [x19, x8]
0x000464a0  str      xzr, [x19, x8]
0x000464a4  bl       #0x55d78   ; CALL _objc_release
0x000464a8  adrp     x8, #0x8f000
0x000464ac  ldrsw    x8, [x8, #0x18]
0x000464b0  ldr      x0, [x19, x8]
0x000464b4  str      xzr, [x19, x8]
0x000464b8  bl       #0x55d78   ; CALL _objc_release
0x000464bc  adrp     x8, #0x8f000
0x000464c0  ldrsw    x8, [x8, #0x1c]
0x000464c4  ldr      x0, [x19, x8]
0x000464c8  str      xzr, [x19, x8]
0x000464cc  bl       #0x55d78   ; CALL _objc_release
0x000464d0  adrp     x8, #0x8f000
0x000464d4  ldrsw    x8, [x8, #0x20]
0x000464d8  ldr      x0, [x19, x8]
0x000464dc  str      xzr, [x19, x8]
0x000464e0  bl       #0x55d78   ; CALL _objc_release
0x000464e4  adrp     x8, #0x8f000
0x000464e8  ldrsw    x8, [x8, #0x24]
0x000464ec  ldr      x0, [x19, x8]
0x000464f0  str      xzr, [x19, x8]
0x000464f4  bl       #0x55d78   ; CALL _objc_release
0x000464f8  adrp     x8, #0x8f000
0x000464fc  ldrsw    x8, [x8, #0x28]
0x00046500  ldr      x0, [x19, x8]
0x00046504  str      xzr, [x19, x8]
0x00046508  bl       #0x55d78   ; CALL _objc_release
0x0004650c  adrp     x8, #0x8f000
0x00046510  ldrsw    x8, [x8, #0x2c]
0x00046514  ldr      x0, [x19, x8]
0x00046518  str      xzr, [x19, x8]
0x0004651c  bl       #0x55d78   ; CALL _objc_release
0x00046520  adrp     x8, #0x8f000
0x00046524  ldrsw    x8, [x8, #0x30]
0x00046528  ldr      x0, [x19, x8]
0x0004652c  str      xzr, [x19, x8]
0x00046530  bl       #0x55d78   ; CALL _objc_release
0x00046534  adrp     x8, #0x8f000
0x00046538  ldrsw    x8, [x8, #0x34]
0x0004653c  ldr      x0, [x19, x8]
0x00046540  str      xzr, [x19, x8]
0x00046544  bl       #0x55d78   ; CALL _objc_release
0x00046548  adrp     x8, #0x8f000
0x0004654c  ldrsw    x8, [x8, #0x38]
0x00046550  ldr      x0, [x19, x8]
0x00046554  str      xzr, [x19, x8]
0x00046558  bl       #0x55d78   ; CALL _objc_release
0x0004655c  adrp     x8, #0x8f000
0x00046560  ldrsw    x8, [x8, #0x3c]
0x00046564  ldr      x0, [x19, x8]
0x00046568  str      xzr, [x19, x8]
0x0004656c  bl       #0x55d78   ; CALL _objc_release
0x00046570  adrp     x8, #0x8f000
0x00046574  ldrsw    x8, [x8, #0x40]
0x00046578  ldr      x0, [x19, x8]
0x0004657c  str      xzr, [x19, x8]
0x00046580  bl       #0x55d78   ; CALL _objc_release
0x00046584  adrp     x8, #0x8f000
0x00046588  ldrsw    x8, [x8, #0x44]
0x0004658c  ldr      x0, [x19, x8]
0x00046590  str      xzr, [x19, x8]
0x00046594  bl       #0x55d78   ; CALL _objc_release
0x00046598  adrp     x8, #0x8f000
0x0004659c  ldrsw    x8, [x8, #0x48]
0x000465a0  ldr      x0, [x19, x8]
0x000465a4  str      xzr, [x19, x8]
0x000465a8  bl       #0x55d78   ; CALL _objc_release
0x000465ac  adrp     x8, #0x8f000
0x000465b0  ldrsw    x8, [x8, #0x4c]
0x000465b4  ldr      x0, [x19, x8]
0x000465b8  str      xzr, [x19, x8]
0x000465bc  bl       #0x55d78   ; CALL _objc_release
0x000465c0  adrp     x8, #0x8f000
0x000465c4  ldrsw    x8, [x8, #0x50]
0x000465c8  str      xzr, [x19, x8]
0x000465cc  mov      x0, x19
0x000465d0  bl       #0x5d0e0   ; CALL objc_msgSend$ss_clearScene
0x000465d4  adrp     x8, #0x8e000
0x000465d8  ldrsw    x8, [x8, #0xffc]
0x000465dc  mov      x9, #-1
0x000465e0  str      x9, [x19, x8]
0x000465e4  adrp     x8, #0x8f000
0x000465e8  ldrsw    x8, [x8, #0x54]
0x000465ec  adrp     x9, #0x74000
0x000465f0  ldr      x9, [x9, #0x618]   ; @GOT _CGSizeZero
0x000465f4  ldr      q0, [x9]   ; @GOT ___objc_personality_v0
0x000465f8  str      q0, [x19, x8]
0x000465fc  ldur     x8, [x29, #-0x38]
0x00046600  adrp     x9, #0x74000
0x00046604  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00046608  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0004660c  cmp      x9, x8
0x00046610  b.ne     #0x4662c
0x00046614  ldp      x29, x30, [sp, #0x100]
0x00046618  ldp      x20, x19, [sp, #0xf0]
0x0004661c  ldp      x22, x21, [sp, #0xe0]
0x00046620  ldp      x24, x23, [sp, #0xd0]
0x00046624  add      sp, sp, #0x110
0x00046628  ret      
0x0004662c  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[SSStartupView reload]  va=0x46630 size=2956 types=v16@0:8
0x00046630  sub      sp, sp, #0xb0
0x00046634  stp      x28, x27, [sp, #0x50]
0x00046638  stp      x26, x25, [sp, #0x60]
0x0004663c  stp      x24, x23, [sp, #0x70]
0x00046640  stp      x22, x21, [sp, #0x80]
0x00046644  stp      x20, x19, [sp, #0x90]
0x00046648  stp      x29, x30, [sp, #0xa0]
0x0004664c  add      x29, sp, #0xa0
0x00046650  mov      x19, x0
0x00046654  adrp     x8, #0x74000
0x00046658  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0004665c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00046660  str      x8, [sp, #0x48]
0x00046664  bl       #0x56e00   ; CALL objc_msgSend$clearContent
0x00046668  mov      x0, x19
0x0004666c  bl       #0x575a0   ; CALL objc_msgSend$date
0x00046670  mov      x29, x29
0x00046674  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046678  mov      x21, x0
0x0004667c  cbz      x0, #0x46690
0x00046680  mov      x0, x21
0x00046684  bl       #0x55d84   ; CALL _objc_retain
0x00046688  mov      x25, x21
0x0004668c  b        #0x466a8
0x00046690  adrp     x8, #0x8e000
0x00046694  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x00046698  bl       #0x575a0   ; CALL objc_msgSend$date
0x0004669c  mov      x29, x29
0x000466a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000466a4  mov      x25, x0
0x000466a8  mov      x0, x21
0x000466ac  bl       #0x55d78   ; CALL _objc_release
0x000466b0  mov      x0, x25
0x000466b4  bl       #0x45c90   ; CALL _SSPeriodForDate
0x000466b8  mov      x22, x0
0x000466bc  mov      x0, x19
0x000466c0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000466c4  mov      x29, x29
0x000466c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000466cc  mov      x21, x0
0x000466d0  adrp     x8, #0x74000
0x000466d4  ldr      x8, [x8, #0x660]   ; @GOT _kCAGradientLayerAxial
0x000466d8  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x000466dc  bl       #0x5c6e0   ; CALL objc_msgSend$setType:
0x000466e0  fmov     d0, xzr
0x000466e4  fmov     d1, xzr
0x000466e8  mov      x0, x21
0x000466ec  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x000466f0  fmov     d0, #1.00000000
0x000466f4  fmov     d1, #1.00000000
0x000466f8  mov      x0, x21
0x000466fc  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x00046700  mov      x0, x19
0x00046704  bl       #0x5d620   ; CALL objc_msgSend$style
0x00046708  cmp      x0, #0xb
0x0004670c  b.eq     #0x46740
0x00046710  cmp      x0, #3
0x00046714  b.ne     #0x4676c
0x00046718  mov      x0, x19
0x0004671c  bl       #0x5e100   ; CALL objc_msgSend$weather
0x00046720  mov      x29, x29
0x00046724  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046728  mov      x23, x0
0x0004672c  bl       #0x55d78   ; CALL _objc_release
0x00046730  cmp      x23, #0
0x00046734  mov      w8, #2
0x00046738  cinc     x0, x8, ne
0x0004673c  b        #0x4676c
0x00046740  mov      x0, x19
0x00046744  bl       #0x593e0   ; CALL objc_msgSend$occasion
0x00046748  cmp      x0, #1
0x0004674c  b.lt     #0x46760
0x00046750  mov      x0, x19
0x00046754  bl       #0x593e0   ; CALL objc_msgSend$occasion
0x00046758  cmp      x0, #6
0x0004675c  b.lt     #0x46768
0x00046760  mov      w0, #2
0x00046764  b        #0x4676c
0x00046768  mov      w0, #0xb
0x0004676c  cmp      x0, #0xa
0x00046770  ccmp     x0, #0xb, #2, ne
0x00046774  mov      w8, #2
0x00046778  csel     x20, x8, x0, hi
0x0004677c  mov      x0, x19
0x00046780  bl       #0x5d940   ; CALL objc_msgSend$tempo
0x00046784  cmp      x0, #1
0x00046788  b.lt     #0x467ac
0x0004678c  mov      x0, x19
0x00046790  bl       #0x5d940   ; CALL objc_msgSend$tempo
0x00046794  cmp      x0, #1
0x00046798  adrp     x8, #0x65000
0x0004679c  ldr      d0, [x8, #0x700]
0x000467a0  fmov     d1, #1.00000000
0x000467a4  fcsel    d0, d0, d1, gt
0x000467a8  b        #0x467b4
0x000467ac  adrp     x8, #0x65000
0x000467b0  ldr      d0, [x8, #0xeb8]
0x000467b4  adrp     x8, #0x8f000
0x000467b8  ldrsw    x9, [x8, #0x58]
0x000467bc  str      d0, [x19, x9]
0x000467c0  adrp     x8, #0x8f000
0x000467c4  ldrsw    x8, [x8, #0x5c]
0x000467c8  mov      x10, #0x7ff0000000000000
0x000467cc  str      x10, [x19, x8]
0x000467d0  cmp      x20, #5
0x000467d4  b.le     #0x46804
0x000467d8  cmp      x20, #7
0x000467dc  b.gt     #0x4684c
0x000467e0  cmp      x20, #6
0x000467e4  b.eq     #0x469f4
0x000467e8  cmp      x20, #7
0x000467ec  b.ne     #0x468b0
0x000467f0  adrp     x8, #0x8f000
0x000467f4  ldrsw    x8, [x8, #0x60]
0x000467f8  mov      x9, #0x3333333333333333
0x000467fc  movk     x9, #0x400b, lsl #48
0x00046800  b        #0x46a3c
0x00046804  cmp      x20, #3
0x00046808  b.eq     #0x46880
0x0004680c  cmp      x20, #4
0x00046810  b.eq     #0x46a24
0x00046814  cmp      x20, #5
0x00046818  b.ne     #0x468b0
0x0004681c  ldr      d0, [x19, x9]
0x00046820  fmov     d1, #4.00000000
0x00046824  fmul     d0, d0, d1
0x00046828  adrp     x10, #0x8f000
0x0004682c  ldrsw    x10, [x10, #0x60]
0x00046830  str      d0, [x19, x10]
0x00046834  ldr      d0, [x19, x9]
0x00046838  adrp     x9, #0x65000
0x0004683c  ldr      d1, [x9, #0xec0]
0x00046840  fmul     d0, d0, d1
0x00046844  str      d0, [x19, x8]
0x00046848  b        #0x46a40
0x0004684c  cmp      x20, #8
0x00046850  b.eq     #0x46a04
0x00046854  cmp      x20, #9
0x00046858  b.ne     #0x468b0
0x0004685c  adrp     x9, #0x8f000
0x00046860  ldrsw    x9, [x9, #0x60]
0x00046864  mov      x10, #0x6666666666666666
0x00046868  movk     x10, #0x4006, lsl #48
0x0004686c  str      x10, [x19, x9]
0x00046870  mov      x9, #-0x3333333333333334
0x00046874  movk     x9, #0xcccd
0x00046878  movk     x9, #0x4004, lsl #48
0x0004687c  b        #0x46a3c
0x00046880  adrp     x8, #0x8f000
0x00046884  ldrsw    x8, [x8, #0x60]
0x00046888  mov      x9, #0x4008000000000000
0x0004688c  str      x9, [x19, x8]
0x00046890  cmp      x22, #1
0x00046894  b.gt     #0x46ae4
0x00046898  cbnz     x22, #0x46c5c
0x0004689c  mov      w0, #0xb36b
0x000468a0  movk     w0, #0xff, lsl #16
0x000468a4  mov      w1, #0x665e
0x000468a8  movk     w1, #0xf2, lsl #16
0x000468ac  b        #0x46c80
0x000468b0  adrp     x8, #0x8f000
0x000468b4  ldrsw    x8, [x8, #0x60]
0x000468b8  mov      x9, #0x4004000000000000
0x000468bc  str      x9, [x19, x8]
0x000468c0  cmp      x20, #1
0x000468c4  b.eq     #0x46b00
0x000468c8  cbnz     x20, #0x46c4c
0x000468cc  adrp     x20, #0x8e000
0x000468d0  ldr      x0, [x20, #0x910]   ; @CLASS UIColor
0x000468d4  bl       #0x56940   ; CALL objc_msgSend$blackColor
0x000468d8  mov      x29, x29
0x000468dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000468e0  mov      x22, x0
0x000468e4  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000468e8  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000468ec  str      x0, [sp, #0x38]
0x000468f0  ldr      x0, [x20, #0x910]   ; @CLASS UIColor
0x000468f4  bl       #0x56940   ; CALL objc_msgSend$blackColor
0x000468f8  mov      x29, x29
0x000468fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046900  mov      x23, x0
0x00046904  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00046908  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004690c  str      x0, [sp, #0x40]
0x00046910  adrp     x8, #0x8e000
0x00046914  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00046918  add      x2, sp, #0x38
0x0004691c  mov      w3, #2
0x00046920  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00046924  mov      x29, x29
0x00046928  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004692c  mov      x24, x0
0x00046930  mov      x0, x21
0x00046934  mov      x2, x24
0x00046938  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0004693c  mov      x0, x24
0x00046940  bl       #0x55d78   ; CALL _objc_release
0x00046944  mov      x0, x23
0x00046948  bl       #0x55d78   ; CALL _objc_release
0x0004694c  mov      x0, x22
0x00046950  bl       #0x55d78   ; CALL _objc_release
0x00046954  adrp     x8, #0x8e000
0x00046958  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x0004695c  bl       #0x55c7c   ; CALL _objc_alloc
0x00046960  mov      x22, x0
0x00046964  mov      x0, x19
0x00046968  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0004696c  mov      x0, x22
0x00046970  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x00046974  adrp     x8, #0x8f000
0x00046978  ldrsw    x23, [x8, #0x14]
0x0004697c  ldr      x8, [x19, x23]
0x00046980  str      x0, [x19, x23]
0x00046984  mov      x0, x8
0x00046988  bl       #0x55d78   ; CALL _objc_release
0x0004698c  ldr      x0, [x19, x23]
0x00046990  mov      w2, #1
0x00046994  bl       #0x5a8a0   ; CALL objc_msgSend$setClipsToBounds:
0x00046998  mov      x0, x19
0x0004699c  bl       #0x58080   ; CALL objc_msgSend$image
0x000469a0  mov      x29, x29
0x000469a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000469a8  mov      x22, x0
0x000469ac  bl       #0x55d78   ; CALL _objc_release
0x000469b0  cbz      x22, #0x46de8
0x000469b4  mov      x0, x19
0x000469b8  bl       #0x58080   ; CALL objc_msgSend$image
0x000469bc  mov      x29, x29
0x000469c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000469c4  mov      x22, x0
0x000469c8  ldr      x0, [x19, x23]
0x000469cc  mov      x2, x22
0x000469d0  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x000469d4  mov      x0, x22
0x000469d8  bl       #0x55d78   ; CALL _objc_release
0x000469dc  mov      x0, x19
0x000469e0  bl       #0x580e0   ; CALL objc_msgSend$imageFits
0x000469e4  cmp      w0, #0
0x000469e8  mov      w8, #1
0x000469ec  cinc     x2, x8, eq
0x000469f0  b        #0x46e54
0x000469f4  adrp     x8, #0x8f000
0x000469f8  ldrsw    x8, [x8, #0x60]
0x000469fc  mov      x9, #0x4008000000000000
0x00046a00  b        #0x46a3c
0x00046a04  adrp     x9, #0x8f000
0x00046a08  ldrsw    x9, [x9, #0x60]
0x00046a0c  mov      x10, #-0x3333333333333334
0x00046a10  movk     x10, #0xcccd
0x00046a14  movk     x10, #0x4004, lsl #48
0x00046a18  str      x10, [x19, x9]
0x00046a1c  mov      x9, #0x4004000000000000
0x00046a20  b        #0x46a3c
0x00046a24  adrp     x9, #0x8f000
0x00046a28  ldrsw    x9, [x9, #0x60]
0x00046a2c  mov      x10, #0x4010000000000000
0x00046a30  str      x10, [x19, x9]
0x00046a34  mov      x9, #0x6666666666666666
0x00046a38  movk     x9, #0x400e, lsl #48
0x00046a3c  str      x9, [x19, x8]
0x00046a40  adrp     x8, #0x8e000
0x00046a44  ldrsw    x8, [x8, #0xffc]
0x00046a48  str      x20, [x19, x8]
0x00046a4c  fmov     d0, #0.50000000
0x00046a50  fmov     d1, xzr
0x00046a54  mov      x0, x21
0x00046a58  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x00046a5c  fmov     d0, #0.50000000
0x00046a60  fmov     d1, #1.00000000
0x00046a64  mov      x0, x21
0x00046a68  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x00046a6c  mov      x0, x19
0x00046a70  bl       #0x5d200   ; CALL objc_msgSend$ss_sceneColors
0x00046a74  mov      x29, x29
0x00046a78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046a7c  mov      x20, x0
0x00046a80  mov      x0, x21
0x00046a84  mov      x2, x20
0x00046a88  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x00046a8c  mov      x0, x20
0x00046a90  bl       #0x55d78   ; CALL _objc_release
0x00046a94  mov      x0, x19
0x00046a98  bl       #0x5b7a0   ; CALL objc_msgSend$setNeedsLayout
0x00046a9c  mov      x0, x21
0x00046aa0  bl       #0x55d78   ; CALL _objc_release
0x00046aa4  mov      x0, x25
0x00046aa8  bl       #0x55d78   ; CALL _objc_release
0x00046aac  ldr      x8, [sp, #0x48]
0x00046ab0  adrp     x9, #0x74000
0x00046ab4  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00046ab8  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00046abc  cmp      x9, x8
0x00046ac0  b.ne     #0x47128
0x00046ac4  ldp      x29, x30, [sp, #0xa0]
0x00046ac8  ldp      x20, x19, [sp, #0x90]
0x00046acc  ldp      x22, x21, [sp, #0x80]
0x00046ad0  ldp      x24, x23, [sp, #0x70]
0x00046ad4  ldp      x26, x25, [sp, #0x60]
0x00046ad8  ldp      x28, x27, [sp, #0x50]
0x00046adc  add      sp, sp, #0xb0
0x00046ae0  ret      
0x00046ae4  cmp      x22, #2
0x00046ae8  b.ne     #0x46c70
0x00046aec  mov      w0, #0x8a66
0x00046af0  movk     w0, #0xf0, lsl #16
0x00046af4  mov      w1, #0x3a92
0x00046af8  movk     w1, #0x5c, lsl #16
0x00046afc  b        #0x46c80
0x00046b00  adrp     x8, #0x74000
0x00046b04  ldr      x8, [x8, #0x670]   ; @GOT _kCAGradientLayerRadial
0x00046b08  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x00046b0c  mov      x0, x21
0x00046b10  bl       #0x5c6e0   ; CALL objc_msgSend$setType:
0x00046b14  fmov     d0, #0.50000000
0x00046b18  fmov     d1, #0.50000000
0x00046b1c  mov      x0, x21
0x00046b20  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x00046b24  fmov     d0, #1.00000000
0x00046b28  fmov     d1, #1.00000000
0x00046b2c  mov      x0, x21
0x00046b30  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x00046b34  adrp     x20, #0x8e000
0x00046b38  ldr      x0, [x20, #0x910]   ; @CLASS UIColor
0x00046b3c  adrp     x8, #0x65000
0x00046b40  ldr      d0, [x8, #0x8d0]
0x00046b44  adrp     x8, #0x65000
0x00046b48  ldr      d1, [x8, #0x6a8]
0x00046b4c  adrp     x8, #0x65000
0x00046b50  ldr      d2, [x8, #0x648]
0x00046b54  fmov     d3, #1.00000000
0x00046b58  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00046b5c  mov      x29, x29
0x00046b60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046b64  mov      x22, x0
0x00046b68  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00046b6c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00046b70  str      x0, [sp, #0x28]
0x00046b74  ldr      x0, [x20, #0x910]   ; @CLASS UIColor
0x00046b78  adrp     x8, #0x65000
0x00046b7c  ldr      d0, [x8, #0xec8]
0x00046b80  adrp     x8, #0x65000
0x00046b84  ldr      d1, [x8, #0xed0]
0x00046b88  adrp     x8, #0x65000
0x00046b8c  ldr      d2, [x8, #0x800]
0x00046b90  fmov     d3, #1.00000000
0x00046b94  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00046b98  mov      x29, x29
0x00046b9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046ba0  mov      x23, x0
0x00046ba4  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00046ba8  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00046bac  str      x0, [sp, #0x30]
0x00046bb0  adrp     x8, #0x8e000
0x00046bb4  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00046bb8  add      x2, sp, #0x28
0x00046bbc  mov      w3, #2
0x00046bc0  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00046bc4  mov      x29, x29
0x00046bc8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046bcc  mov      x24, x0
0x00046bd0  mov      x0, x21
0x00046bd4  mov      x2, x24
0x00046bd8  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x00046bdc  mov      x0, x24
0x00046be0  bl       #0x55d78   ; CALL _objc_release
0x00046be4  mov      x0, x23
0x00046be8  bl       #0x55d78   ; CALL _objc_release
0x00046bec  mov      x0, x22
0x00046bf0  bl       #0x55d78   ; CALL _objc_release
0x00046bf4  adrp     x8, #0x8e000
0x00046bf8  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x00046bfc  bl       #0x55d60   ; CALL _objc_opt_new
0x00046c00  adrp     x8, #0x8f000
0x00046c04  ldrsw    x24, [x8, #0x18]
0x00046c08  ldr      x8, [x19, x24]
0x00046c0c  str      x0, [x19, x24]
0x00046c10  mov      x0, x8
0x00046c14  bl       #0x55d78   ; CALL _objc_release
0x00046c18  ldr      x0, [x19, x24]
0x00046c1c  mov      w2, #1
0x00046c20  bl       #0x5aa40   ; CALL objc_msgSend$setContentMode:
0x00046c24  mov      x0, x19
0x00046c28  bl       #0x58080   ; CALL objc_msgSend$image
0x00046c2c  mov      x29, x29
0x00046c30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046c34  mov      x22, x0
0x00046c38  cbz      x0, #0x46e64
0x00046c3c  ldr      x0, [x19, x24]
0x00046c40  mov      x2, x22
0x00046c44  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00046c48  b        #0x46e98
0x00046c4c  and      x8, x20, #0xe
0x00046c50  cmp      x8, #2
0x00046c54  b.eq     #0x46890
0x00046c58  b        #0x46a40
0x00046c5c  mov      w0, #0xb4a4
0x00046c60  movk     w0, #0x27, lsl #16
0x00046c64  mov      w1, #0x5f8e
0x00046c68  movk     w1, #0x1f, lsl #16
0x00046c6c  b        #0x46c80
0x00046c70  mov      w0, #0x2547
0x00046c74  movk     w0, #0x1d, lsl #16
0x00046c78  mov      w1, #0x50b
0x00046c7c  movk     w1, #4, lsl #16
0x00046c80  bl       #0x4732c
0x00046c84  mov      x29, x29
0x00046c88  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046c8c  mov      x23, x0
0x00046c90  mov      x0, x21
0x00046c94  mov      x2, x23
0x00046c98  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x00046c9c  mov      x0, x23
0x00046ca0  bl       #0x55d78   ; CALL _objc_release
0x00046ca4  cmp      x20, #3
0x00046ca8  str      x25, [sp, #8]
0x00046cac  mov      x0, x19
0x00046cb0  b.ne     #0x46d74
0x00046cb4  bl       #0x5e100   ; CALL objc_msgSend$weather
0x00046cb8  mov      x29, x29
0x00046cbc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046cc0  mov      x24, x0
0x00046cc4  adrp     x2, #0x7c000
0x00046cc8  add      x2, x2, #0x7e8   ; STR "isDay"
0x00046ccc  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00046cd0  mov      x29, x29
0x00046cd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046cd8  mov      x25, x0
0x00046cdc  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00046ce0  mov      x23, x0
0x00046ce4  mov      x0, x25
0x00046ce8  bl       #0x55d78   ; CALL _objc_release
0x00046cec  mov      x0, x24
0x00046cf0  bl       #0x55d78   ; CALL _objc_release
0x00046cf4  mov      x0, x19
0x00046cf8  bl       #0x5e100   ; CALL objc_msgSend$weather
0x00046cfc  mov      x29, x29
0x00046d00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046d04  mov      x24, x0
0x00046d08  adrp     x2, #0x7c000
0x00046d0c  add      x2, x2, #0x7c8   ; STR "code"
0x00046d10  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00046d14  mov      x29, x29
0x00046d18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046d1c  mov      x25, x0
0x00046d20  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x00046d24  mov      x1, x23
0x00046d28  bl       #0x4712c
0x00046d2c  adrp     x8, #0x8f000
0x00046d30  ldrsw    x20, [x8, #0x64]
0x00046d34  str      x0, [x19, x20]
0x00046d38  mov      x0, x25
0x00046d3c  bl       #0x55d78   ; CALL _objc_release
0x00046d40  mov      x0, x24
0x00046d44  bl       #0x55d78   ; CALL _objc_release
0x00046d48  ldr      x8, [x19, x20]
0x00046d4c  cmp      x8, #4
0x00046d50  b.le     #0x46d84
0x00046d54  sub      x9, x8, #6
0x00046d58  cmp      x9, #3
0x00046d5c  b.hs     #0x46d9c
0x00046d60  mov      w0, #0x2633
0x00046d64  movk     w0, #0x1c, lsl #16
0x00046d68  mov      w1, #0x404f
0x00046d6c  movk     w1, #0x33, lsl #16
0x00046d70  b        #0x46f3c
0x00046d74  mov      x2, x25
0x00046d78  mov      x3, x22
0x00046d7c  bl       #0x56aa0   ; CALL objc_msgSend$buildGreetingWithDate:period:
0x00046d80  b        #0x46f9c
0x00046d84  cmp      x8, #1
0x00046d88  b.gt     #0x46dc4
0x00046d8c  cbz      x8, #0x46ed8
0x00046d90  cmp      x8, #1
0x00046d94  b.eq     #0x46dd4
0x00046d98  b        #0x46f00
0x00046d9c  cmp      x8, #5
0x00046da0  b.eq     #0x46eec
0x00046da4  cmp      x8, #9
0x00046da8  b.ne     #0x46f00
0x00046dac  tbz      w23, #0, #0x46f18
0x00046db0  mov      w0, #0x6e86
0x00046db4  movk     w0, #0x5d, lsl #16
0x00046db8  mov      w1, #0xc2d3
0x00046dbc  movk     w1, #0xb4, lsl #16
0x00046dc0  b        #0x46f3c
0x00046dc4  cmp      x8, #2
0x00046dc8  b.eq     #0x46ed8
0x00046dcc  cmp      x8, #3
0x00046dd0  b.ne     #0x46f00
0x00046dd4  mov      w0, #0x30a
0x00046dd8  movk     w0, #2, lsl #16
0x00046ddc  mov      w1, #0x1230
0x00046de0  movk     w1, #0xb, lsl #16
0x00046de4  b        #0x46f3c
0x00046de8  adrp     x8, #0x8e000
0x00046dec  ldr      x0, [x8, #0xa78]   ; @CLASS UIImage
0x00046df0  adrp     x2, #0x7d000
0x00046df4  add      x2, x2, #0x2a8   ; STR "play.rectangle.fill"
0x00046df8  bl       #0x5d820   ; CALL objc_msgSend$systemImageNamed:
0x00046dfc  mov      x29, x29
0x00046e00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046e04  mov      x22, x0
0x00046e08  ldr      x0, [x19, x23]
0x00046e0c  mov      x2, x22
0x00046e10  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00046e14  mov      x0, x22
0x00046e18  bl       #0x55d78   ; CALL _objc_release
0x00046e1c  ldr      x0, [x20, #0x910]
0x00046e20  adrp     x8, #0x65000
0x00046e24  ldr      d1, [x8, #0x660]
0x00046e28  fmov     d0, #1.00000000
0x00046e2c  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x00046e30  mov      x29, x29
0x00046e34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046e38  mov      x22, x0
0x00046e3c  ldr      x0, [x19, x23]
0x00046e40  mov      x2, x22
0x00046e44  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x00046e48  mov      x0, x22
0x00046e4c  bl       #0x55d78   ; CALL _objc_release
0x00046e50  mov      w2, #4
0x00046e54  ldr      x0, [x19, x23]
0x00046e58  bl       #0x5aa40   ; CALL objc_msgSend$setContentMode:
0x00046e5c  ldr      x2, [x19, x23]
0x00046e60  b        #0x46ecc
0x00046e64  adrp     x8, #0x8e000
0x00046e68  ldr      x0, [x8, #0xa78]   ; @CLASS UIImage
0x00046e6c  adrp     x2, #0x75000
0x00046e70  add      x2, x2, #0x228   ; STR "car.fill"
0x00046e74  bl       #0x5d820   ; CALL objc_msgSend$systemImageNamed:
0x00046e78  mov      x29, x29
0x00046e7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046e80  mov      x23, x0
0x00046e84  ldr      x0, [x19, x24]
0x00046e88  mov      x2, x23
0x00046e8c  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00046e90  mov      x0, x23
0x00046e94  bl       #0x55d78   ; CALL _objc_release
0x00046e98  mov      x0, x22
0x00046e9c  bl       #0x55d78   ; CALL _objc_release
0x00046ea0  ldr      x0, [x20, #0x910]
0x00046ea4  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x00046ea8  mov      x29, x29
0x00046eac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046eb0  mov      x22, x0
0x00046eb4  ldr      x0, [x19, x24]
0x00046eb8  mov      x2, x22
0x00046ebc  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x00046ec0  mov      x0, x22
0x00046ec4  bl       #0x55d78   ; CALL _objc_release
0x00046ec8  ldr      x2, [x19, x24]
0x00046ecc  mov      x0, x19
0x00046ed0  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00046ed4  b        #0x46a94
0x00046ed8  mov      w0, #0x7fd8
0x00046edc  movk     w0, #0x2a, lsl #16
0x00046ee0  mov      w1, #0xd3ff
0x00046ee4  movk     w1, #0x9f, lsl #16
0x00046ee8  b        #0x46f3c
0x00046eec  mov      w0, #0x6670
0x00046ef0  movk     w0, #0x5f, lsl #16
0x00046ef4  mov      w1, #0xa1aa
0x00046ef8  movk     w1, #0x9a, lsl #16
0x00046efc  b        #0x46f3c
0x00046f00  tbz      w23, #0, #0x46f2c
0x00046f04  mov      w0, #0x5b70
0x00046f08  movk     w0, #0x4a, lsl #16
0x00046f0c  mov      w1, #0x9bad
0x00046f10  movk     w1, #0x8d, lsl #16
0x00046f14  b        #0x46f3c
0x00046f18  mov      w0, #0x1b2a
0x00046f1c  movk     w0, #0x14, lsl #16
0x00046f20  mov      w1, #0x445a
0x00046f24  movk     w1, #0x38, lsl #16
0x00046f28  b        #0x46f3c
0x00046f2c  mov      w0, #0x141f
0x00046f30  movk     w0, #0x10, lsl #16
0x00046f34  mov      w1, #0x3243
0x00046f38  movk     w1, #0x2a, lsl #16
0x00046f3c  bl       #0x4732c
0x00046f40  mov      x29, x29
0x00046f44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046f48  mov      x23, x0
0x00046f4c  mov      x0, x21
0x00046f50  mov      x2, x23
0x00046f54  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x00046f58  mov      x0, x23
0x00046f5c  bl       #0x55d78   ; CALL _objc_release
0x00046f60  fmov     d0, #0.50000000
0x00046f64  fmov     d1, xzr
0x00046f68  mov      x0, x21
0x00046f6c  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x00046f70  fmov     d0, #0.50000000
0x00046f74  fmov     d1, #1.00000000
0x00046f78  mov      x0, x21
0x00046f7c  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x00046f80  adrp     x8, #0x8e000
0x00046f84  ldrsw    x8, [x8, #0xffc]
0x00046f88  mov      w9, #3
0x00046f8c  str      x9, [x19, x8]
0x00046f90  mov      x0, x19
0x00046f94  mov      x2, x22
0x00046f98  bl       #0x56b00   ; CALL objc_msgSend$buildWeatherWithPeriod:
0x00046f9c  adrp     x8, #0x8f000
0x00046fa0  ldrsw    x20, [x8, #0xc]
0x00046fa4  ldr      x0, [x19, x20]
0x00046fa8  mov      w2, #0
0x00046fac  bl       #0x5c6c0   ; CALL objc_msgSend$setTranslatesAutoresizingMaskIntoConstraints:
0x00046fb0  ldr      x2, [x19, x20]
0x00046fb4  mov      x0, x19
0x00046fb8  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00046fbc  ldr      x0, [x19, x20]
0x00046fc0  bl       #0x5e1c0   ; CALL objc_msgSend$widthAnchor
0x00046fc4  mov      x29, x29
0x00046fc8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046fcc  mov      x22, x0
0x00046fd0  mov      x0, x19
0x00046fd4  bl       #0x5e1c0   ; CALL objc_msgSend$widthAnchor
0x00046fd8  mov      x29, x29
0x00046fdc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046fe0  mov      x23, x0
0x00046fe4  fmov     d0, #-16.00000000
0x00046fe8  mov      x0, x22
0x00046fec  mov      x2, x23
0x00046ff0  bl       #0x571a0   ; CALL objc_msgSend$constraintLessThanOrEqualToAnchor:constant:
0x00046ff4  mov      x29, x29
0x00046ff8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046ffc  adrp     x8, #0x8f000
0x00047000  ldrsw    x24, [x8, #0x40]
0x00047004  ldr      x8, [x19, x24]
0x00047008  str      x0, [x19, x24]
0x0004700c  mov      x0, x8
0x00047010  bl       #0x55d78   ; CALL _objc_release
0x00047014  mov      x0, x23
0x00047018  bl       #0x55d78   ; CALL _objc_release
0x0004701c  mov      x0, x22
0x00047020  bl       #0x55d78   ; CALL _objc_release
0x00047024  adrp     x8, #0x8e000
0x00047028  ldr      x8, [x8, #0xa58]   ; @CLASS NSLayoutConstraint
0x0004702c  str      x8, [sp]
0x00047030  ldr      x0, [x19, x20]
0x00047034  bl       #0x56d60   ; CALL objc_msgSend$centerXAnchor
0x00047038  mov      x29, x29
0x0004703c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047040  mov      x22, x0
0x00047044  mov      x0, x19
0x00047048  bl       #0x56d60   ; CALL objc_msgSend$centerXAnchor
0x0004704c  mov      x29, x29
0x00047050  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047054  mov      x23, x0
0x00047058  mov      x0, x22
0x0004705c  mov      x2, x23
0x00047060  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x00047064  mov      x29, x29
0x00047068  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004706c  mov      x25, x0
0x00047070  str      x0, [sp, #0x10]
0x00047074  ldr      x0, [x19, x20]
0x00047078  bl       #0x56d80   ; CALL objc_msgSend$centerYAnchor
0x0004707c  mov      x29, x29
0x00047080  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047084  mov      x26, x0
0x00047088  mov      x0, x19
0x0004708c  bl       #0x56d80   ; CALL objc_msgSend$centerYAnchor
0x00047090  mov      x29, x29
0x00047094  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047098  mov      x27, x0
0x0004709c  mov      x0, x26
0x000470a0  mov      x2, x27
0x000470a4  bl       #0x57140   ; CALL objc_msgSend$constraintEqualToAnchor:
0x000470a8  mov      x29, x29
0x000470ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000470b0  mov      x28, x0
0x000470b4  ldr      x8, [x19, x24]
0x000470b8  stp      x0, x8, [sp, #0x18]
0x000470bc  adrp     x8, #0x8e000
0x000470c0  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000470c4  add      x2, sp, #0x10
0x000470c8  mov      w3, #3
0x000470cc  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000470d0  mov      x29, x29
0x000470d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000470d8  mov      x20, x0
0x000470dc  ldr      x0, [sp]
0x000470e0  mov      x2, x20
0x000470e4  bl       #0x55fe0   ; CALL objc_msgSend$activateConstraints:
0x000470e8  mov      x0, x20
0x000470ec  bl       #0x55d78   ; CALL _objc_release
0x000470f0  mov      x0, x28
0x000470f4  bl       #0x55d78   ; CALL _objc_release
0x000470f8  mov      x0, x27
0x000470fc  bl       #0x55d78   ; CALL _objc_release
0x00047100  mov      x0, x26
0x00047104  bl       #0x55d78   ; CALL _objc_release
0x00047108  mov      x0, x25
0x0004710c  bl       #0x55d78   ; CALL _objc_release
0x00047110  mov      x0, x23
0x00047114  bl       #0x55d78   ; CALL _objc_release
0x00047118  mov      x0, x22
0x0004711c  bl       #0x55d78   ; CALL _objc_release
0x00047120  ldr      x25, [sp, #8]
0x00047124  b        #0x46a94
0x00047128  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0004712c  cbz      x0, #0x47148
0x00047130  cmp      x0, #2
0x00047134  b.gt     #0x47150
0x00047138  cmp      w1, #0
0x0004713c  mov      w8, #2
0x00047140  cinc     x8, x8, eq
0x00047144  b        #0x471b4
0x00047148  eor      w8, w1, #1
0x0004714c  b        #0x471b4
0x00047150  mov      w8, #5
0x00047154  cmp      x0, #0x2d
0x00047158  b.eq     #0x471b4
0x0004715c  cmp      x0, #0x30
0x00047160  b.eq     #0x471b4
0x00047164  sub      x8, x0, #0x33
0x00047168  cmp      x8, #7
0x0004716c  b.hs     #0x47178
0x00047170  mov      w8, #6
0x00047174  b        #0x471b4
0x00047178  sub      x8, x0, #0x3d
0x0004717c  cmp      x8, #0x19
0x00047180  b.hi     #0x471a4
0x00047184  mov      w9, #0xfc7f
0x00047188  movk     w9, #0x339, lsl #16
0x0004718c  lsr      w9, w9, w8
0x00047190  tbz      w9, #0, #0x471a4
0x00047194  adrp     x9, #0x66000
0x00047198  add      x9, x9, #0x470
0x0004719c  ldr      x8, [x9, x8, lsl #3]
0x000471a0  b        #0x471b4
0x000471a4  cmp      x0, #0x5e
0x000471a8  mov      w8, #4
0x000471ac  mov      w9, #8
0x000471b0  csel     x8, x9, x8, hi
0x000471b4  mov      x0, x8
0x000471b8  ret      

=== -[SSStartupView ss_sceneColors]  va=0x471bc size=676 types=@16@0:8
0x000471bc  stp      x29, x30, [sp, #-0x10]!
0x000471c0  mov      x29, sp
0x000471c4  adrp     x8, #0x8e000
0x000471c8  ldrsw    x8, [x8, #0xffc]
0x000471cc  ldr      x8, [x0, x8]
0x000471d0  cmp      x8, #6
0x000471d4  b.gt     #0x47208
0x000471d8  cmp      x8, #4
0x000471dc  b.eq     #0x47234
0x000471e0  cmp      x8, #5
0x000471e4  b.eq     #0x47288
0x000471e8  cmp      x8, #6
0x000471ec  b.ne     #0x47258
0x000471f0  mov      w8, #0x308
0x000471f4  movk     w8, #2, lsl #16
0x000471f8  orr      w0, w8, #1
0x000471fc  mov      w1, #0xa18
0x00047200  movk     w1, #7, lsl #16
0x00047204  b        #0x472ac
0x00047208  cmp      x8, #7
0x0004720c  b.eq     #0x47244
0x00047210  cmp      x8, #8
0x00047214  b.eq     #0x4729c
0x00047218  cmp      x8, #9
0x0004721c  b.ne     #0x47258
0x00047220  mov      w0, #0xf0fb
0x00047224  movk     w0, #0xee, lsl #16
0x00047228  mov      w1, #0xf5fb
0x0004722c  movk     w1, #0xf4, lsl #16
0x00047230  b        #0x472ac
0x00047234  mov      w0, #0x70c
0x00047238  movk     w0, #5, lsl #16
0x0004723c  mov      w1, #0
0x00047240  b        #0x472ac
0x00047244  mov      w0, #0x50c
0x00047248  movk     w0, #1, lsl #16
0x0004724c  mov      w1, #0x121e
0x00047250  movk     w1, #4, lsl #16
0x00047254  b        #0x472ac
0x00047258  bl       #0x593e0   ; CALL objc_msgSend$occasion
0x0004725c  cmp      x0, #2
0x00047260  b.gt     #0x472c0
0x00047264  cmp      x0, #1
0x00047268  b.eq     #0x472fc
0x0004726c  cmp      x0, #2
0x00047270  b.ne     #0x472e4
0x00047274  mov      w0, #0xb3a
0x00047278  movk     w0, #0x1b, lsl #16
0x0004727c  mov      w1, #0x1a78
0x00047280  movk     w1, #0x3b, lsl #16
0x00047284  b        #0x472ac
0x00047288  mov      w0, #0x308
0x0004728c  movk     w0, #2, lsl #16
0x00047290  mov      w1, #0x70d
0x00047294  movk     w1, #6, lsl #16
0x00047298  b        #0x472ac
0x0004729c  mov      w0, #0x1a33
0x000472a0  movk     w0, #0xc, lsl #16
0x000472a4  mov      w1, #0x3a66
0x000472a8  movk     w1, #0x1f, lsl #16
0x000472ac  bl       #0x4732c
0x000472b0  mov      x29, x29
0x000472b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000472b8  ldp      x29, x30, [sp], #0x10
0x000472bc  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x000472c0  cmp      x0, #3
0x000472c4  b.eq     #0x47310
0x000472c8  cmp      x0, #4
0x000472cc  b.ne     #0x472e4
0x000472d0  mov      w0, #0xa24
0x000472d4  movk     w0, #0xa, lsl #16
0x000472d8  mov      w1, #0x1446
0x000472dc  movk     w1, #0x1d, lsl #16
0x000472e0  b        #0x472ac
0x000472e4  mov      w8, #0x308
0x000472e8  movk     w8, #2, lsl #16
0x000472ec  add      w0, w8, #0x71c
0x000472f0  mov      w1, #0x1d4a
0x000472f4  movk     w1, #0xb, lsl #16
0x000472f8  b        #0x472ac
0x000472fc  mov      w0, #6
0x00047300  movk     w0, #0x5a, lsl #16
0x00047304  mov      w1, #0xf
0x00047308  movk     w1, #0xa3, lsl #16
0x0004730c  b        #0x472ac
0x00047310  mov      w8, #0x121e
0x00047314  movk     w8, #4, lsl #16
0x00047318  mov      w9, #0x1d4a
0x0004731c  movk     w9, #0xb, lsl #16
0x00047320  orr      w0, w8, #1
0x00047324  add      w1, w9, #0xcf3
0x00047328  b        #0x472ac
0x0004732c  sub      sp, sp, #0x60
0x00047330  stp      d9, d8, [sp, #0x20]
0x00047334  stp      x22, x21, [sp, #0x30]
0x00047338  stp      x20, x19, [sp, #0x40]
0x0004733c  stp      x29, x30, [sp, #0x50]
0x00047340  add      x29, sp, #0x50
0x00047344  mov      x20, x1
0x00047348  adrp     x8, #0x74000
0x0004734c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00047350  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00047354  str      x8, [sp, #0x18]
0x00047358  adrp     x21, #0x8e000
0x0004735c  lsr      w8, w0, #0x10
0x00047360  ucvtf    d0, w8
0x00047364  ldr      x8, [x21, #0x910]   ; @CLASS UIColor
0x00047368  adrp     x9, #0x65000
0x0004736c  ldr      d8, [x9, #0x688]
0x00047370  ubfx     w9, w0, #8, #8
0x00047374  ucvtf    d1, w9
0x00047378  fdiv     d0, d0, d8
0x0004737c  fdiv     d1, d1, d8
0x00047380  and      w9, w0, #0xff
0x00047384  ucvtf    d2, w9
0x00047388  fdiv     d2, d2, d8
0x0004738c  fmov     d3, #1.00000000
0x00047390  mov      x0, x8
0x00047394  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00047398  mov      x29, x29
0x0004739c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000473a0  mov      x19, x0
0x000473a4  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000473a8  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000473ac  str      x0, [sp, #8]
0x000473b0  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x000473b4  lsr      w8, w20, #0x10
0x000473b8  ucvtf    d0, w8
0x000473bc  ubfx     w8, w20, #8, #8
0x000473c0  ucvtf    d1, w8
0x000473c4  fdiv     d0, d0, d8
0x000473c8  fdiv     d1, d1, d8
0x000473cc  and      w8, w20, #0xff
0x000473d0  ucvtf    d2, w8
0x000473d4  fdiv     d2, d2, d8
0x000473d8  fmov     d3, #1.00000000
0x000473dc  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000473e0  mov      x29, x29
0x000473e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000473e8  mov      x21, x0
0x000473ec  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000473f0  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000473f4  str      x0, [sp, #0x10]
0x000473f8  adrp     x8, #0x8e000
0x000473fc  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00047400  add      x2, sp, #8
0x00047404  mov      w3, #2
0x00047408  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0004740c  mov      x29, x29
0x00047410  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047414  mov      x20, x0
0x00047418  mov      x0, x21
0x0004741c  bl       #0x55d78   ; CALL _objc_release
0x00047420  mov      x0, x19
0x00047424  bl       #0x55d78   ; CALL _objc_release
0x00047428  ldr      x8, [sp, #0x18]
0x0004742c  adrp     x9, #0x74000
0x00047430  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00047434  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00047438  cmp      x9, x8
0x0004743c  b.ne     #0x4745c
0x00047440  mov      x0, x20
0x00047444  ldp      x29, x30, [sp, #0x50]
0x00047448  ldp      x20, x19, [sp, #0x40]
0x0004744c  ldp      x22, x21, [sp, #0x30]
0x00047450  ldp      d9, d8, [sp, #0x20]
0x00047454  add      sp, sp, #0x60
0x00047458  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0004745c  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[SSStartupView buildGreetingWithDate:period:]  va=0x47460 size=1208 types=v32@0:8@16q24
0x00047460  sub      sp, sp, #0x60
0x00047464  stp      x24, x23, [sp, #0x20]
0x00047468  stp      x22, x21, [sp, #0x30]
0x0004746c  stp      x20, x19, [sp, #0x40]
0x00047470  stp      x29, x30, [sp, #0x50]
0x00047474  add      x29, sp, #0x50
0x00047478  mov      x21, x3
0x0004747c  mov      x20, x2
0x00047480  mov      x19, x0
0x00047484  adrp     x8, #0x74000
0x00047488  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0004748c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00047490  str      x8, [sp, #0x18]
0x00047494  adrp     x8, #0x8e000
0x00047498  ldr      x22, [x8, #0x980]   ; @CLASS NSDateFormatter
0x0004749c  mov      x0, x2
0x000474a0  bl       #0x55d84   ; CALL _objc_retain
0x000474a4  mov      x0, x22
0x000474a8  mov      x2, x20
0x000474ac  mov      x3, #0
0x000474b0  mov      w4, #1
0x000474b4  bl       #0x58de0   ; CALL objc_msgSend$localizedStringFromDate:dateStyle:timeStyle:
0x000474b8  mov      x29, x29
0x000474bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000474c0  mov      x22, x0
0x000474c4  bl       #0x47664
0x000474c8  mov      x29, x29
0x000474cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000474d0  adrp     x8, #0x8f000
0x000474d4  ldrsw    x23, [x8, #0x24]
0x000474d8  ldr      x8, [x19, x23]
0x000474dc  str      x0, [x19, x23]
0x000474e0  mov      x0, x8
0x000474e4  bl       #0x55d78   ; CALL _objc_release
0x000474e8  mov      x0, x22
0x000474ec  bl       #0x55d78   ; CALL _objc_release
0x000474f0  mov      x0, x19
0x000474f4  bl       #0x590e0   ; CALL objc_msgSend$name
0x000474f8  mov      x29, x29
0x000474fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047500  mov      x22, x0
0x00047504  mov      x1, x21
0x00047508  bl       #0x4779c
0x0004750c  mov      x29, x29
0x00047510  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047514  mov      x21, x0
0x00047518  bl       #0x47664
0x0004751c  mov      x29, x29
0x00047520  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047524  adrp     x8, #0x8f000
0x00047528  ldrsw    x24, [x8, #0x20]
0x0004752c  ldr      x8, [x19, x24]
0x00047530  str      x0, [x19, x24]
0x00047534  mov      x0, x8
0x00047538  bl       #0x55d78   ; CALL _objc_release
0x0004753c  mov      x0, x21
0x00047540  bl       #0x55d78   ; CALL _objc_release
0x00047544  mov      x0, x22
0x00047548  bl       #0x55d78   ; CALL _objc_release
0x0004754c  mov      x0, x20
0x00047550  bl       #0x47854
0x00047554  mov      x29, x29
0x00047558  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004755c  mov      x21, x0
0x00047560  mov      x0, x20
0x00047564  bl       #0x55d78   ; CALL _objc_release
0x00047568  mov      x0, x21
0x0004756c  bl       #0x47664
0x00047570  mov      x29, x29
0x00047574  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047578  adrp     x8, #0x8f000
0x0004757c  ldrsw    x22, [x8, #0x1c]
0x00047580  ldr      x8, [x19, x22]
0x00047584  str      x0, [x19, x22]
0x00047588  mov      x0, x8
0x0004758c  bl       #0x55d78   ; CALL _objc_release
0x00047590  mov      x0, x21
0x00047594  bl       #0x55d78   ; CALL _objc_release
0x00047598  ldr      x0, [x19, x22]
0x0004759c  adrp     x8, #0x65000
0x000475a0  ldr      d0, [x8, #0x6d0]
0x000475a4  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x000475a8  adrp     x8, #0x8e000
0x000475ac  ldr      x0, [x8, #0xa38]   ; @CLASS UIStackView
0x000475b0  bl       #0x55c7c   ; CALL _objc_alloc
0x000475b4  mov      x20, x0
0x000475b8  ldr      x8, [x19, x23]
0x000475bc  ldr      x9, [x19, x24]
0x000475c0  stp      x8, x9, [sp]
0x000475c4  ldr      x8, [x19, x22]
0x000475c8  str      x8, [sp, #0x10]
0x000475cc  adrp     x8, #0x8e000
0x000475d0  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000475d4  mov      x2, sp
0x000475d8  mov      w3, #3
0x000475dc  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000475e0  mov      x29, x29
0x000475e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000475e8  mov      x21, x0
0x000475ec  mov      x0, x20
0x000475f0  mov      x2, x21
0x000475f4  bl       #0x583a0   ; CALL objc_msgSend$initWithArrangedSubviews:
0x000475f8  adrp     x8, #0x8f000
0x000475fc  ldrsw    x20, [x8, #0xc]
0x00047600  ldr      x8, [x19, x20]
0x00047604  str      x0, [x19, x20]
0x00047608  mov      x0, x8
0x0004760c  bl       #0x55d78   ; CALL _objc_release
0x00047610  mov      x0, x21
0x00047614  bl       #0x55d78   ; CALL _objc_release
0x00047618  ldr      x0, [x19, x20]
0x0004761c  mov      w2, #1
0x00047620  bl       #0x5a540   ; CALL objc_msgSend$setAxis:
0x00047624  ldr      x0, [x19, x20]
0x00047628  mov      w2, #3
0x0004762c  bl       #0x5a3a0   ; CALL objc_msgSend$setAlignment:
0x00047630  ldr      x8, [sp, #0x18]
0x00047634  adrp     x9, #0x74000
0x00047638  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0004763c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00047640  cmp      x9, x8
0x00047644  b.ne     #0x47660
0x00047648  ldp      x29, x30, [sp, #0x50]
0x0004764c  ldp      x20, x19, [sp, #0x40]
0x00047650  ldp      x22, x21, [sp, #0x30]
0x00047654  ldp      x24, x23, [sp, #0x20]
0x00047658  add      sp, sp, #0x60
0x0004765c  ret      
0x00047660  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00047664  stp      x22, x21, [sp, #-0x30]!
0x00047668  stp      x20, x19, [sp, #0x10]
0x0004766c  stp      x29, x30, [sp, #0x20]
0x00047670  add      x29, sp, #0x20
0x00047674  mov      x20, x0
0x00047678  adrp     x8, #0x8e000
0x0004767c  ldr      x19, [x8, #0x940]   ; @CLASS UILabel
0x00047680  bl       #0x55d84   ; CALL _objc_retain
0x00047684  mov      x0, x19
0x00047688  bl       #0x55d60   ; CALL _objc_opt_new
0x0004768c  mov      x19, x0
0x00047690  mov      x2, x20
0x00047694  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00047698  mov      x0, x20
0x0004769c  bl       #0x55d78   ; CALL _objc_release
0x000476a0  adrp     x21, #0x8e000
0x000476a4  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x000476a8  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x000476ac  mov      x29, x29
0x000476b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000476b4  mov      x20, x0
0x000476b8  mov      x0, x19
0x000476bc  mov      x2, x20
0x000476c0  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x000476c4  mov      x0, x20
0x000476c8  bl       #0x55d78   ; CALL _objc_release
0x000476cc  mov      x0, x19
0x000476d0  mov      w2, #1
0x000476d4  bl       #0x5c4e0   ; CALL objc_msgSend$setTextAlignment:
0x000476d8  mov      x0, x19
0x000476dc  mov      w2, #1
0x000476e0  bl       #0x5b820   ; CALL objc_msgSend$setNumberOfLines:
0x000476e4  mov      x0, x19
0x000476e8  mov      w2, #1
0x000476ec  bl       #0x5a380   ; CALL objc_msgSend$setAdjustsFontSizeToFitWidth:
0x000476f0  adrp     x8, #0x65000
0x000476f4  ldr      d0, [x8, #0x6c0]
0x000476f8  mov      x0, x19
0x000476fc  bl       #0x5b660   ; CALL objc_msgSend$setMinimumScaleFactor:
0x00047700  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00047704  bl       #0x56940   ; CALL objc_msgSend$blackColor
0x00047708  mov      x29, x29
0x0004770c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047710  mov      x20, x0
0x00047714  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00047718  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004771c  mov      x21, x0
0x00047720  mov      x0, x19
0x00047724  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00047728  mov      x29, x29
0x0004772c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047730  mov      x22, x0
0x00047734  mov      x2, x21
0x00047738  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x0004773c  mov      x0, x22
0x00047740  bl       #0x55d78   ; CALL _objc_release
0x00047744  mov      x0, x20
0x00047748  bl       #0x55d78   ; CALL _objc_release
0x0004774c  mov      x0, x19
0x00047750  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00047754  mov      x29, x29
0x00047758  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004775c  mov      x20, x0
0x00047760  adrp     x8, #0x65000
0x00047764  ldr      s0, [x8, #0xd00]
0x00047768  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x0004776c  mov      x0, x20
0x00047770  bl       #0x55d78   ; CALL _objc_release
0x00047774  mov      w8, #0x437a0000
0x00047778  fmov     s0, w8
0x0004777c  mov      x0, x19
0x00047780  mov      x2, #0
0x00047784  bl       #0x5a9a0   ; CALL objc_msgSend$setContentCompressionResistancePriority:forAxis:
0x00047788  mov      x0, x19
0x0004778c  ldp      x29, x30, [sp, #0x20]
0x00047790  ldp      x20, x19, [sp, #0x10]
0x00047794  ldp      x22, x21, [sp], #0x30
0x00047798  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0004779c  sub      sp, sp, #0x40
0x000477a0  stp      x22, x21, [sp, #0x10]
0x000477a4  stp      x20, x19, [sp, #0x20]
0x000477a8  stp      x29, x30, [sp, #0x30]
0x000477ac  add      x29, sp, #0x30
0x000477b0  mov      x19, x1
0x000477b4  mov      x21, x0
0x000477b8  bl       #0x55d84   ; CALL _objc_retain
0x000477bc  mov      x0, x19
0x000477c0  bl       #0x4f204
0x000477c4  mov      x29, x29
0x000477c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000477cc  mov      x19, x0
0x000477d0  mov      x0, x21
0x000477d4  bl       #0x4da60
0x000477d8  mov      x29, x29
0x000477dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000477e0  mov      x20, x0
0x000477e4  mov      x0, x21
0x000477e8  bl       #0x55d78   ; CALL _objc_release
0x000477ec  mov      x0, x20
0x000477f0  bl       #0x58c20   ; CALL objc_msgSend$length
0x000477f4  cbz      x0, #0x47820
0x000477f8  adrp     x8, #0x8e000
0x000477fc  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00047800  stp      x19, x20, [sp]
0x00047804  adrp     x2, #0x7e000
0x00047808  add      x2, x2, #0x88   ; STR "%@, %@"
0x0004780c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00047810  mov      x29, x29
0x00047814  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047818  mov      x21, x0
0x0004781c  b        #0x4782c
0x00047820  mov      x0, x19
0x00047824  bl       #0x55d84   ; CALL _objc_retain
0x00047828  mov      x21, x19
0x0004782c  mov      x0, x20
0x00047830  bl       #0x55d78   ; CALL _objc_release
0x00047834  mov      x0, x19
0x00047838  bl       #0x55d78   ; CALL _objc_release
0x0004783c  mov      x0, x21
0x00047840  ldp      x29, x30, [sp, #0x30]
0x00047844  ldp      x20, x19, [sp, #0x20]
0x00047848  ldp      x22, x21, [sp, #0x10]
0x0004784c  add      sp, sp, #0x40
0x00047850  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00047854  stp      x22, x21, [sp, #-0x30]!
0x00047858  stp      x20, x19, [sp, #0x10]
0x0004785c  stp      x29, x30, [sp, #0x20]
0x00047860  add      x29, sp, #0x20
0x00047864  mov      x19, x0
0x00047868  adrp     x8, #0x8e000
0x0004786c  ldr      x20, [x8, #0x980]   ; @CLASS NSDateFormatter
0x00047870  bl       #0x55d84   ; CALL _objc_retain
0x00047874  mov      x0, x20
0x00047878  bl       #0x55d60   ; CALL _objc_opt_new
0x0004787c  mov      x20, x0
0x00047880  adrp     x8, #0x8e000
0x00047884  ldr      x21, [x8, #0xa08]   ; @CLASS NSLocale
0x00047888  bl       #0x54cc4   ; CALL _OMCCurrentLanguage
0x0004788c  mov      x29, x29
0x00047890  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047894  mov      x22, x0
0x00047898  mov      x0, x21
0x0004789c  mov      x2, x22
0x000478a0  bl       #0x58d60   ; CALL objc_msgSend$localeWithLocaleIdentifier:
0x000478a4  mov      x29, x29
0x000478a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000478ac  mov      x21, x0
0x000478b0  mov      x0, x22
0x000478b4  bl       #0x55d78   ; CALL _objc_release
0x000478b8  mov      x0, x20
0x000478bc  mov      x2, x21
0x000478c0  bl       #0x5b440   ; CALL objc_msgSend$setLocale:
0x000478c4  mov      x0, x21
0x000478c8  bl       #0x55d78   ; CALL _objc_release
0x000478cc  adrp     x2, #0x7e000
0x000478d0  add      x2, x2, #0xa8   ; STR "EEEEdMMMM"
0x000478d4  mov      x0, x20
0x000478d8  bl       #0x5b460   ; CALL objc_msgSend$setLocalizedDateFormatFromTemplate:
0x000478dc  mov      x0, x20
0x000478e0  mov      x2, x19
0x000478e4  bl       #0x5d500   ; CALL objc_msgSend$stringFromDate:
0x000478e8  mov      x29, x29
0x000478ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000478f0  mov      x21, x0
0x000478f4  mov      x0, x19
0x000478f8  bl       #0x55d78   ; CALL _objc_release
0x000478fc  mov      x0, x20
0x00047900  bl       #0x55d78   ; CALL _objc_release
0x00047904  mov      x0, x21
0x00047908  ldp      x29, x30, [sp, #0x20]
0x0004790c  ldp      x20, x19, [sp, #0x10]
0x00047910  ldp      x22, x21, [sp], #0x30
0x00047914  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[SSStartupView buildWeatherWithPeriod:]  va=0x47918 size=4640 types=v24@0:8q16
0x00047918  stp      x28, x27, [sp, #-0x60]!
0x0004791c  stp      x26, x25, [sp, #0x10]
0x00047920  stp      x24, x23, [sp, #0x20]
0x00047924  stp      x22, x21, [sp, #0x30]
0x00047928  stp      x20, x19, [sp, #0x40]
0x0004792c  stp      x29, x30, [sp, #0x50]
0x00047930  add      x29, sp, #0x50
0x00047934  sub      sp, sp, #0x210
0x00047938  mov      x19, x2
0x0004793c  mov      x20, x0
0x00047940  adrp     x8, #0x74000
0x00047944  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00047948  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0004794c  stur     x8, [x29, #-0x60]
0x00047950  bl       #0x5e100   ; CALL objc_msgSend$weather
0x00047954  mov      x29, x29
0x00047958  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004795c  mov      x28, x0
0x00047960  adrp     x2, #0x7c000
0x00047964  add      x2, x2, #0x7c8   ; STR "code"
0x00047968  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0004796c  mov      x29, x29
0x00047970  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047974  mov      x21, x0
0x00047978  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0004797c  mov      x22, x0
0x00047980  adrp     x2, #0x7c000
0x00047984  add      x2, x2, #0x7e8   ; STR "isDay"
0x00047988  mov      x0, x28
0x0004798c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00047990  mov      x29, x29
0x00047994  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047998  mov      x23, x0
0x0004799c  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x000479a0  mov      x1, x0
0x000479a4  str      xzr, [sp, #0xe8]
0x000479a8  add      x2, sp, #0xe8
0x000479ac  add      x3, sp, #0xe0
0x000479b0  mov      x0, x22
0x000479b4  bl       #0x487a4
0x000479b8  ldr      x24, [sp, #0xe8]
0x000479bc  mov      x0, x24
0x000479c0  bl       #0x55d84   ; CALL _objc_retain
0x000479c4  ldr      x25, [sp, #0xe0]
0x000479c8  mov      x0, x25
0x000479cc  bl       #0x55d84   ; CALL _objc_retain
0x000479d0  mov      x0, x23
0x000479d4  bl       #0x55d78   ; CALL _objc_release
0x000479d8  mov      x0, x21
0x000479dc  bl       #0x55d78   ; CALL _objc_release
0x000479e0  mov      x0, x20
0x000479e4  bl       #0x590e0   ; CALL objc_msgSend$name
0x000479e8  mov      x29, x29
0x000479ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000479f0  mov      x21, x0
0x000479f4  mov      x1, x19
0x000479f8  bl       #0x4779c
0x000479fc  mov      x29, x29
0x00047a00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047a04  mov      x19, x0
0x00047a08  bl       #0x47664
0x00047a0c  mov      x29, x29
0x00047a10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047a14  adrp     x8, #0x8f000
0x00047a18  ldrsw    x22, [x8, #0x20]
0x00047a1c  ldr      x8, [x20, x22]
0x00047a20  str      x0, [x20, x22]
0x00047a24  mov      x0, x8
0x00047a28  bl       #0x55d78   ; CALL _objc_release
0x00047a2c  mov      x0, x19
0x00047a30  bl       #0x55d78   ; CALL _objc_release
0x00047a34  mov      x0, x21
0x00047a38  bl       #0x55d78   ; CALL _objc_release
0x00047a3c  str      x22, [sp, #0x78]
0x00047a40  ldr      x0, [x20, x22]
0x00047a44  adrp     x8, #0x65000
0x00047a48  ldr      d0, [x8, #0x5f8]
0x00047a4c  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x00047a50  adrp     x21, #0x8e000
0x00047a54  ldr      x0, [x21, #0xa70]   ; @CLASS UIImageSymbolConfiguration
0x00047a58  mov      x8, #0x4064000000000000
0x00047a5c  fmov     d0, x8
0x00047a60  mov      w2, #4
0x00047a64  bl       #0x57100   ; CALL objc_msgSend$configurationWithPointSize:weight:
0x00047a68  mov      x29, x29
0x00047a6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047a70  mov      x19, x0
0x00047a74  ldr      x0, [x21, #0xa70]   ; @CLASS UIImageSymbolConfiguration
0x00047a78  bl       #0x570c0   ; CALL objc_msgSend$configurationPreferringMulticolor
0x00047a7c  mov      x29, x29
0x00047a80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047a84  mov      x21, x0
0x00047a88  mov      x0, x19
0x00047a8c  mov      x2, x21
0x00047a90  bl       #0x570a0   ; CALL objc_msgSend$configurationByApplyingConfiguration:
0x00047a94  mov      x29, x29
0x00047a98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047a9c  mov      x26, x0
0x00047aa0  mov      x0, x19
0x00047aa4  bl       #0x55d78   ; CALL _objc_release
0x00047aa8  mov      x0, x21
0x00047aac  bl       #0x55d78   ; CALL _objc_release
0x00047ab0  adrp     x8, #0x8e000
0x00047ab4  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x00047ab8  bl       #0x55c7c   ; CALL _objc_alloc
0x00047abc  mov      x21, x0
0x00047ac0  adrp     x23, #0x8e000
0x00047ac4  ldr      x0, [x23, #0xa78]   ; @CLASS UIImage
0x00047ac8  mov      x2, x24
0x00047acc  mov      x3, x26
0x00047ad0  bl       #0x5d840   ; CALL objc_msgSend$systemImageNamed:withConfiguration:
0x00047ad4  mov      x29, x29
0x00047ad8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047adc  mov      x19, x0
0x00047ae0  mov      x22, x0
0x00047ae4  cbnz     x0, #0x47b08
0x00047ae8  ldr      x0, [x23, #0xa78]   ; @CLASS UIImage
0x00047aec  adrp     x2, #0x7d000
0x00047af0  add      x2, x2, #0x2c8   ; STR "cloud.fill"
0x00047af4  mov      x3, x26
0x00047af8  bl       #0x5d840   ; CALL objc_msgSend$systemImageNamed:withConfiguration:
0x00047afc  mov      x29, x29
0x00047b00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047b04  mov      x22, x0
0x00047b08  str      x26, [sp, #0x80]
0x00047b0c  str      x24, [sp, #0x90]
0x00047b10  mov      x0, x21
0x00047b14  mov      x2, x22
0x00047b18  bl       #0x584c0   ; CALL objc_msgSend$initWithImage:
0x00047b1c  adrp     x8, #0x8f000
0x00047b20  ldrsw    x23, [x8, #0x10]
0x00047b24  ldr      x8, [x20, x23]
0x00047b28  str      x0, [x20, x23]
0x00047b2c  mov      x0, x8
0x00047b30  bl       #0x55d78   ; CALL _objc_release
0x00047b34  cbnz     x19, #0x47b40
0x00047b38  mov      x0, x22
0x00047b3c  bl       #0x55d78   ; CALL _objc_release
0x00047b40  mov      x0, x19
0x00047b44  bl       #0x55d78   ; CALL _objc_release
0x00047b48  ldr      x0, [x20, x23]
0x00047b4c  mov      w2, #1
0x00047b50  bl       #0x5aa40   ; CALL objc_msgSend$setContentMode:
0x00047b54  adrp     x26, #0x8e000
0x00047b58  ldr      x0, [x26, #0x910]   ; @CLASS UIColor
0x00047b5c  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x00047b60  mov      x29, x29
0x00047b64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047b68  mov      x19, x0
0x00047b6c  ldr      x0, [x20, x23]
0x00047b70  mov      x2, x19
0x00047b74  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x00047b78  mov      x0, x19
0x00047b7c  bl       #0x55d78   ; CALL _objc_release
0x00047b80  ldr      x0, [x20, x23]
0x00047b84  mov      w2, #0
0x00047b88  bl       #0x5c6c0   ; CALL objc_msgSend$setTranslatesAutoresizingMaskIntoConstraints:
0x00047b8c  ldr      x0, [x20, x23]
0x00047b90  bl       #0x5e1c0   ; CALL objc_msgSend$widthAnchor
0x00047b94  mov      x29, x29
0x00047b98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047b9c  mov      x19, x0
0x00047ba0  fmov     d0, #30.00000000
0x00047ba4  bl       #0x57180   ; CALL objc_msgSend$constraintEqualToConstant:
0x00047ba8  mov      x29, x29
0x00047bac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047bb0  adrp     x8, #0x8f000
0x00047bb4  ldrsw    x21, [x8, #0x48]
0x00047bb8  ldr      x8, [x20, x21]
0x00047bbc  str      x0, [x20, x21]
0x00047bc0  mov      x0, x8
0x00047bc4  bl       #0x55d78   ; CALL _objc_release
0x00047bc8  mov      x0, x19
0x00047bcc  bl       #0x55d78   ; CALL _objc_release
0x00047bd0  str      x23, [sp, #0x68]
0x00047bd4  ldr      x0, [x20, x23]
0x00047bd8  bl       #0x57f40   ; CALL objc_msgSend$heightAnchor
0x00047bdc  mov      x29, x29
0x00047be0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047be4  mov      x19, x0
0x00047be8  fmov     d0, #30.00000000
0x00047bec  bl       #0x57180   ; CALL objc_msgSend$constraintEqualToConstant:
0x00047bf0  mov      x29, x29
0x00047bf4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047bf8  adrp     x8, #0x8f000
0x00047bfc  ldrsw    x22, [x8, #0x44]
0x00047c00  ldr      x8, [x20, x22]
0x00047c04  str      x0, [x20, x22]
0x00047c08  mov      x0, x8
0x00047c0c  bl       #0x55d78   ; CALL _objc_release
0x00047c10  mov      x0, x19
0x00047c14  bl       #0x55d78   ; CALL _objc_release
0x00047c18  adrp     x8, #0x8e000
0x00047c1c  ldr      x19, [x8, #0xa58]   ; @CLASS NSLayoutConstraint
0x00047c20  ldr      x8, [x20, x21]
0x00047c24  ldr      x9, [x20, x22]
0x00047c28  stp      x8, x9, [x29, #-0x70]
0x00047c2c  adrp     x8, #0x8e000
0x00047c30  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00047c34  sub      x2, x29, #0x70
0x00047c38  mov      w3, #2
0x00047c3c  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00047c40  mov      x29, x29
0x00047c44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047c48  mov      x21, x0
0x00047c4c  mov      x0, x19
0x00047c50  mov      x2, x21
0x00047c54  bl       #0x55fe0   ; CALL objc_msgSend$activateConstraints:
0x00047c58  mov      x0, x21
0x00047c5c  bl       #0x55d78   ; CALL _objc_release
0x00047c60  adrp     x2, #0x7c000
0x00047c64  add      x2, x2, #0x748   ; STR "temp"
0x00047c68  mov      x0, x28
0x00047c6c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00047c70  mov      x29, x29
0x00047c74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047c78  mov      x19, x0
0x00047c7c  bl       #0x48a2c
0x00047c80  mov      x29, x29
0x00047c84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047c88  mov      x21, x0
0x00047c8c  bl       #0x47664
0x00047c90  mov      x29, x29
0x00047c94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047c98  adrp     x8, #0x8f000
0x00047c9c  ldrsw    x22, [x8, #0x38]
0x00047ca0  ldr      x8, [x20, x22]
0x00047ca4  str      x0, [x20, x22]
0x00047ca8  mov      x0, x8
0x00047cac  bl       #0x55d78   ; CALL _objc_release
0x00047cb0  mov      x0, x21
0x00047cb4  bl       #0x55d78   ; CALL _objc_release
0x00047cb8  mov      x0, x19
0x00047cbc  bl       #0x55d78   ; CALL _objc_release
0x00047cc0  str      x22, [sp, #0x60]
0x00047cc4  ldr      x0, [x20, x22]
0x00047cc8  mov      w8, #0x447a0000
0x00047ccc  fmov     s0, w8
0x00047cd0  mov      x2, #0
0x00047cd4  bl       #0x5a9a0   ; CALL objc_msgSend$setContentCompressionResistancePriority:forAxis:
0x00047cd8  str      x25, [sp, #0x88]
0x00047cdc  mov      x0, x25
0x00047ce0  bl       #0x47664
0x00047ce4  mov      x29, x29
0x00047ce8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047cec  adrp     x8, #0x8f000
0x00047cf0  ldrsw    x25, [x8, #0x34]
0x00047cf4  ldr      x8, [x20, x25]
0x00047cf8  str      x0, [x20, x25]
0x00047cfc  mov      x0, x8
0x00047d00  bl       #0x55d78   ; CALL _objc_release
0x00047d04  adrp     x8, #0x8e000
0x00047d08  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00047d0c  bl       #0x565c0   ; CALL objc_msgSend$array
0x00047d10  mov      x29, x29
0x00047d14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047d18  mov      x23, x0
0x00047d1c  adrp     x2, #0x7c000
0x00047d20  add      x2, x2, #0x768   ; STR "high"
0x00047d24  mov      x0, x28
0x00047d28  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00047d2c  mov      x29, x29
0x00047d30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047d34  mov      x19, x0
0x00047d38  bl       #0x55d78   ; CALL _objc_release
0x00047d3c  cbz      x19, #0x47dac
0x00047d40  adrp     x2, #0x7c000
0x00047d44  add      x2, x2, #0x768   ; STR "high"
0x00047d48  mov      x0, x28
0x00047d4c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00047d50  mov      x29, x29
0x00047d54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047d58  mov      x19, x0
0x00047d5c  bl       #0x48a2c
0x00047d60  mov      x29, x29
0x00047d64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047d68  mov      x21, x0
0x00047d6c  adrp     x0, #0x7d000
0x00047d70  add      x0, x0, #0x2e8   ; STR "↑ "
0x00047d74  mov      x2, x21
0x00047d78  bl       #0x5d440   ; CALL objc_msgSend$stringByAppendingString:
0x00047d7c  mov      x29, x29
0x00047d80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047d84  mov      x22, x0
0x00047d88  mov      x0, x23
0x00047d8c  mov      x2, x22
0x00047d90  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00047d94  mov      x0, x22
0x00047d98  bl       #0x55d78   ; CALL _objc_release
0x00047d9c  mov      x0, x21
0x00047da0  bl       #0x55d78   ; CALL _objc_release
0x00047da4  mov      x0, x19
0x00047da8  bl       #0x55d78   ; CALL _objc_release
0x00047dac  adrp     x2, #0x7c000
0x00047db0  add      x2, x2, #0x788   ; STR "low"
0x00047db4  mov      x0, x28
0x00047db8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00047dbc  mov      x29, x29
0x00047dc0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047dc4  mov      x19, x0
0x00047dc8  bl       #0x55d78   ; CALL _objc_release
0x00047dcc  cbz      x19, #0x47e3c
0x00047dd0  adrp     x2, #0x7c000
0x00047dd4  add      x2, x2, #0x788   ; STR "low"
0x00047dd8  mov      x0, x28
0x00047ddc  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00047de0  mov      x29, x29
0x00047de4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047de8  mov      x19, x0
0x00047dec  bl       #0x48a2c
0x00047df0  mov      x29, x29
0x00047df4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047df8  mov      x21, x0
0x00047dfc  adrp     x0, #0x7d000
0x00047e00  add      x0, x0, #0x308   ; STR "↓ "
0x00047e04  mov      x2, x21
0x00047e08  bl       #0x5d440   ; CALL objc_msgSend$stringByAppendingString:
0x00047e0c  mov      x29, x29
0x00047e10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047e14  mov      x22, x0
0x00047e18  mov      x0, x23
0x00047e1c  mov      x2, x22
0x00047e20  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00047e24  mov      x0, x22
0x00047e28  bl       #0x55d78   ; CALL _objc_release
0x00047e2c  mov      x0, x21
0x00047e30  bl       #0x55d78   ; CALL _objc_release
0x00047e34  mov      x0, x19
0x00047e38  bl       #0x55d78   ; CALL _objc_release
0x00047e3c  adrp     x2, #0x7d000
0x00047e40  add      x2, x2, #0x328   ; STR "   "
0x00047e44  mov      x0, x23
0x00047e48  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x00047e4c  mov      x29, x29
0x00047e50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047e54  mov      x19, x0
0x00047e58  bl       #0x47664
0x00047e5c  mov      x29, x29
0x00047e60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047e64  adrp     x8, #0x8f000
0x00047e68  ldrsw    x24, [x8, #0x30]
0x00047e6c  ldr      x8, [x20, x24]
0x00047e70  str      x0, [x20, x24]
0x00047e74  mov      x0, x8
0x00047e78  bl       #0x55d78   ; CALL _objc_release
0x00047e7c  mov      x0, x19
0x00047e80  bl       #0x55d78   ; CALL _objc_release
0x00047e84  str      x23, [sp, #0x70]
0x00047e88  mov      x0, x23
0x00047e8c  bl       #0x573c0   ; CALL objc_msgSend$count
0x00047e90  cmp      x0, #0
0x00047e94  cset     w2, eq
0x00047e98  ldr      x0, [x20, x24]
0x00047e9c  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x00047ea0  adrp     x2, #0x7c000
0x00047ea4  add      x2, x2, #0x7a8   ; STR "rain"
0x00047ea8  mov      x0, x28
0x00047eac  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00047eb0  mov      x29, x29
0x00047eb4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047eb8  mov      x19, x0
0x00047ebc  cbz      x0, #0x47f2c
0x00047ec0  adrp     x8, #0x8e000
0x00047ec4  ldr      x23, [x8, #0x958]   ; @CLASS NSString
0x00047ec8  adrp     x0, #0x7d000
0x00047ecc  add      x0, x0, #0x368   ; STR "Khả năng mưa"
0x00047ed0  adrp     x1, #0x7d000
0x00047ed4  add      x1, x1, #0x388   ; STR "Chance of rain"
0x00047ed8  bl       #0x5505c   ; CALL _OMCTr
0x00047edc  mov      x29, x29
0x00047ee0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047ee4  mov      x21, x0
0x00047ee8  adrp     x2, #0x7c000
0x00047eec  add      x2, x2, #0x7a8   ; STR "rain"
0x00047ef0  mov      x0, x28
0x00047ef4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00047ef8  mov      x29, x29
0x00047efc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047f00  mov      x22, x0
0x00047f04  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x00047f08  stp      x21, x0, [sp]
0x00047f0c  adrp     x2, #0x7d000
0x00047f10  add      x2, x2, #0x348   ; STR "%@ %ld%%"
0x00047f14  mov      x0, x23
0x00047f18  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00047f1c  mov      x29, x29
0x00047f20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047f24  mov      x23, x0
0x00047f28  b        #0x47f30
0x00047f2c  mov      x23, #0
0x00047f30  mov      x0, x23
0x00047f34  bl       #0x47664
0x00047f38  mov      x29, x29
0x00047f3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047f40  adrp     x8, #0x8f000
0x00047f44  ldrsw    x27, [x8, #0x2c]
0x00047f48  ldr      x8, [x20, x27]
0x00047f4c  str      x0, [x20, x27]
0x00047f50  mov      x0, x8
0x00047f54  bl       #0x55d78   ; CALL _objc_release
0x00047f58  cbz      x19, #0x47f74
0x00047f5c  mov      x0, x23
0x00047f60  bl       #0x55d78   ; CALL _objc_release
0x00047f64  mov      x0, x22
0x00047f68  bl       #0x55d78   ; CALL _objc_release
0x00047f6c  mov      x0, x21
0x00047f70  bl       #0x55d78   ; CALL _objc_release
0x00047f74  mov      x0, x19
0x00047f78  bl       #0x55d78   ; CALL _objc_release
0x00047f7c  adrp     x2, #0x7c000
0x00047f80  add      x2, x2, #0x7a8   ; STR "rain"
0x00047f84  str      x28, [sp, #0x98]
0x00047f88  mov      x0, x28
0x00047f8c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00047f90  mov      x29, x29
0x00047f94  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00047f98  mov      x19, x0
0x00047f9c  cmp      x0, #0
0x00047fa0  cset     w2, eq
0x00047fa4  ldr      x0, [x20, x27]
0x00047fa8  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x00047fac  mov      x0, x19
0x00047fb0  bl       #0x55d78   ; CALL _objc_release
0x00047fb4  ldr      x0, [x20, x27]
0x00047fb8  adrp     x8, #0x65000
0x00047fbc  ldr      d0, [x8, #0x708]
0x00047fc0  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x00047fc4  movi     v0.16b, #0
0x00047fc8  stp      q0, q0, [sp, #0xc0]
0x00047fcc  stp      q0, q0, [sp, #0xa0]
0x00047fd0  ldr      x8, [x20, x25]
0x00047fd4  ldr      x9, [x20, x24]
0x00047fd8  stp      x8, x9, [sp, #0x158]
0x00047fdc  ldr      x8, [x20, x27]
0x00047fe0  str      x8, [sp, #0x168]
0x00047fe4  adrp     x8, #0x8e000
0x00047fe8  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00047fec  add      x2, sp, #0x158
0x00047ff0  mov      w3, #3
0x00047ff4  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00047ff8  mov      x29, x29
0x00047ffc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048000  mov      x19, x0
0x00048004  add      x2, sp, #0xa0
0x00048008  sub      x3, x29, #0xf0
0x0004800c  mov      w4, #0x10
0x00048010  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00048014  cbz      x0, #0x48078
0x00048018  mov      x21, x0
0x0004801c  ldr      x8, [sp, #0xb0]
0x00048020  ldr      x22, [x8]   ; @SEL "whatsNewNavigationController"
0x00048024  mov      x23, #0
0x00048028  ldr      x8, [sp, #0xb0]
0x0004802c  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00048030  cmp      x8, x22
0x00048034  b.eq     #0x48040
0x00048038  mov      x0, x19
0x0004803c  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00048040  ldr      x8, [sp, #0xa8]
0x00048044  ldr      x0, [x8, x23, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00048048  mov      w2, #4
0x0004804c  bl       #0x5c4e0   ; CALL objc_msgSend$setTextAlignment:
0x00048050  add      x23, x23, #1
0x00048054  cmp      x21, x23
0x00048058  b.ne     #0x48028
0x0004805c  add      x2, sp, #0xa0
0x00048060  sub      x3, x29, #0xf0
0x00048064  mov      x0, x19
0x00048068  mov      w4, #0x10
0x0004806c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00048070  mov      x21, x0
0x00048074  cbnz     x0, #0x48024
0x00048078  mov      x0, x19
0x0004807c  bl       #0x55d78   ; CALL _objc_release
0x00048080  adrp     x8, #0x8e000
0x00048084  ldr      x0, [x8, #0xa38]   ; @CLASS UIStackView
0x00048088  bl       #0x55c7c   ; CALL _objc_alloc
0x0004808c  mov      x19, x0
0x00048090  ldr      x8, [x20, x25]
0x00048094  ldr      x9, [x20, x24]
0x00048098  stp      x8, x9, [sp, #0x140]
0x0004809c  ldr      x8, [x20, x27]
0x000480a0  str      x8, [sp, #0x150]
0x000480a4  adrp     x8, #0x8e000
0x000480a8  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000480ac  add      x2, sp, #0x140
0x000480b0  mov      w3, #3
0x000480b4  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000480b8  mov      x29, x29
0x000480bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000480c0  mov      x21, x0
0x000480c4  mov      x0, x19
0x000480c8  mov      x2, x21
0x000480cc  bl       #0x583a0   ; CALL objc_msgSend$initWithArrangedSubviews:
0x000480d0  adrp     x8, #0x8f000
0x000480d4  ldrsw    x24, [x8, #4]
0x000480d8  ldr      x8, [x20, x24]
0x000480dc  str      x0, [x20, x24]
0x000480e0  mov      x0, x8
0x000480e4  bl       #0x55d78   ; CALL _objc_release
0x000480e8  mov      x0, x21
0x000480ec  bl       #0x55d78   ; CALL _objc_release
0x000480f0  ldr      x0, [x20, x24]
0x000480f4  mov      w2, #1
0x000480f8  bl       #0x5a540   ; CALL objc_msgSend$setAxis:
0x000480fc  ldr      x0, [x20, x24]
0x00048100  mov      w2, #1
0x00048104  bl       #0x5a3a0   ; CALL objc_msgSend$setAlignment:
0x00048108  ldr      x0, [x20, x24]
0x0004810c  mov      w2, #0
0x00048110  bl       #0x5c6c0   ; CALL objc_msgSend$setTranslatesAutoresizingMaskIntoConstraints:
0x00048114  adrp     x8, #0x8e000
0x00048118  ldr      x0, [x8, #0xaa0]   ; @CLASS UIVisualEffectView
0x0004811c  bl       #0x55c7c   ; CALL _objc_alloc
0x00048120  mov      x19, x0
0x00048124  adrp     x8, #0x8e000
0x00048128  ldr      x0, [x8, #0xaa8]   ; @CLASS UIBlurEffect
0x0004812c  mov      w2, #0x10
0x00048130  bl       #0x57980   ; CALL objc_msgSend$effectWithStyle:
0x00048134  mov      x29, x29
0x00048138  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004813c  mov      x21, x0
0x00048140  mov      x0, x19
0x00048144  mov      x2, x21
0x00048148  bl       #0x58440   ; CALL objc_msgSend$initWithEffect:
0x0004814c  adrp     x8, #0x8f000
0x00048150  ldrsw    x25, [x8, #0x3c]
0x00048154  ldr      x8, [x20, x25]
0x00048158  str      x0, [x20, x25]
0x0004815c  mov      x0, x8
0x00048160  bl       #0x55d78   ; CALL _objc_release
0x00048164  mov      x0, x21
0x00048168  bl       #0x55d78   ; CALL _objc_release
0x0004816c  ldr      x0, [x20, x25]
0x00048170  mov      w2, #1
0x00048174  bl       #0x5a8a0   ; CALL objc_msgSend$setClipsToBounds:
0x00048178  adrp     x8, #0x74000
0x0004817c  ldr      x8, [x8, #0x648]   ; @GOT _kCACornerCurveContinuous
0x00048180  ldr      x19, [x8]   ; @GOT ___objc_personality_v0
0x00048184  ldr      x0, [x20, x25]
0x00048188  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004818c  mov      x29, x29
0x00048190  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048194  mov      x21, x0
0x00048198  mov      x2, x19
0x0004819c  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x000481a0  mov      x0, x21
0x000481a4  bl       #0x55d78   ; CALL _objc_release
0x000481a8  ldr      x0, [x20, x25]
0x000481ac  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000481b0  mov      x29, x29
0x000481b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000481b8  mov      x19, x0
0x000481bc  fmov     d0, #0.50000000
0x000481c0  bl       #0x5a740   ; CALL objc_msgSend$setBorderWidth:
0x000481c4  mov      x0, x19
0x000481c8  bl       #0x55d78   ; CALL _objc_release
0x000481cc  ldr      x0, [x26, #0x910]   ; @CLASS UIColor
0x000481d0  adrp     x8, #0x65000
0x000481d4  ldr      d1, [x8, #0xe50]
0x000481d8  fmov     d0, #1.00000000
0x000481dc  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x000481e0  mov      x29, x29
0x000481e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000481e8  mov      x19, x0
0x000481ec  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000481f0  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000481f4  mov      x21, x0
0x000481f8  ldr      x0, [x20, x25]
0x000481fc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00048200  mov      x29, x29
0x00048204  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048208  mov      x22, x0
0x0004820c  mov      x2, x21
0x00048210  bl       #0x5a700   ; CALL objc_msgSend$setBorderColor:
0x00048214  mov      x0, x22
0x00048218  bl       #0x55d78   ; CALL _objc_release
0x0004821c  mov      x0, x19
0x00048220  bl       #0x55d78   ; CALL _objc_release
0x00048224  ldr      x0, [x26, #0x910]   ; @CLASS UIColor
0x00048228  adrp     x8, #0x65000
0x0004822c  ldr      d1, [x8, #0xb60]
0x00048230  fmov     d0, xzr
0x00048234  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x00048238  mov      x29, x29
0x0004823c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048240  mov      x19, x0
0x00048244  ldr      x0, [x20, x25]
0x00048248  bl       #0x57280   ; CALL objc_msgSend$contentView
0x0004824c  mov      x29, x29
0x00048250  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048254  mov      x21, x0
0x00048258  mov      x2, x19
0x0004825c  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x00048260  mov      x0, x21
0x00048264  bl       #0x55d78   ; CALL _objc_release
0x00048268  mov      x0, x19
0x0004826c  bl       #0x55d78   ; CALL _objc_release
0x00048270  ldr      x0, [x20, x25]
0x00048274  bl       #0x57280   ; CALL objc_msgSend$contentView
0x00048278  mov      x29, x29
0x0004827c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048280  mov      x19, x0
0x00048284  ldr      x2, [x20, x24]
0x00048288  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0004828c  mov      x0, x19
0x00048290  bl       #0x55d78   ; CALL _objc_release
0x00048294  ldr      x0, [x20, x24]
0x00048298  bl       #0x58be0   ; CALL objc_msgSend$leadingAnchor
0x0004829c  mov      x29, x29
0x000482a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000482a4  mov      x19, x0
0x000482a8  str      x0, [sp, #0x50]
0x000482ac  ldr      x0, [x20, x25]
0x000482b0  bl       #0x57280   ; CALL objc_msgSend$contentView
0x000482b4  mov      x29, x29
0x000482b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000482bc  str      x0, [sp, #0x58]
0x000482c0  bl       #0x58be0   ; CALL objc_msgSend$leadingAnchor
0x000482c4  mov      x29, x29
0x000482c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000482cc  mov      x2, x0
0x000482d0  str      x0, [sp, #0x48]
0x000482d4  fmov     d0, #12.00000000
0x000482d8  mov      x0, x19
0x000482dc  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x000482e0  mov      x29, x29
0x000482e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000482e8  str      x0, [sp, #0x40]
0x000482ec  str      x0, [sp, #0x120]
0x000482f0  ldr      x0, [x20, x25]
0x000482f4  bl       #0x57280   ; CALL objc_msgSend$contentView
0x000482f8  mov      x29, x29
0x000482fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048300  str      x0, [sp, #0x38]
0x00048304  bl       #0x5dc40   ; CALL objc_msgSend$trailingAnchor
0x00048308  mov      x29, x29
0x0004830c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048310  mov      x19, x0
0x00048314  str      x0, [sp, #0x30]
0x00048318  ldr      x0, [x20, x24]
0x0004831c  bl       #0x5dc40   ; CALL objc_msgSend$trailingAnchor
0x00048320  mov      x29, x29
0x00048324  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048328  mov      x2, x0
0x0004832c  str      x0, [sp, #0x28]
0x00048330  fmov     d0, #12.00000000
0x00048334  mov      x0, x19
0x00048338  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x0004833c  mov      x29, x29
0x00048340  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048344  str      x0, [sp, #0x20]
0x00048348  str      x0, [sp, #0x128]
0x0004834c  ldr      x0, [x20, x24]
0x00048350  bl       #0x5dc00   ; CALL objc_msgSend$topAnchor
0x00048354  mov      x29, x29
0x00048358  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004835c  mov      x19, x0
0x00048360  str      x0, [sp, #0x18]
0x00048364  ldr      x0, [x20, x25]
0x00048368  bl       #0x57280   ; CALL objc_msgSend$contentView
0x0004836c  mov      x29, x29
0x00048370  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048374  mov      x26, x0
0x00048378  bl       #0x5dc00   ; CALL objc_msgSend$topAnchor
0x0004837c  mov      x29, x29
0x00048380  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048384  mov      x27, x0
0x00048388  fmov     d0, #8.00000000
0x0004838c  mov      x0, x19
0x00048390  mov      x2, x27
0x00048394  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x00048398  mov      x29, x29
0x0004839c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000483a0  mov      x28, x0
0x000483a4  str      x0, [sp, #0x130]
0x000483a8  ldr      x0, [x20, x25]
0x000483ac  bl       #0x57280   ; CALL objc_msgSend$contentView
0x000483b0  mov      x29, x29
0x000483b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000483b8  mov      x23, x0
0x000483bc  bl       #0x56a00   ; CALL objc_msgSend$bottomAnchor
0x000483c0  mov      x29, x29
0x000483c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000483c8  mov      x21, x0
0x000483cc  ldr      x0, [x20, x24]
0x000483d0  bl       #0x56a00   ; CALL objc_msgSend$bottomAnchor
0x000483d4  mov      x29, x29
0x000483d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000483dc  mov      x22, x0
0x000483e0  fmov     d0, #8.00000000
0x000483e4  mov      x0, x21
0x000483e8  mov      x2, x22
0x000483ec  bl       #0x57160   ; CALL objc_msgSend$constraintEqualToAnchor:constant:
0x000483f0  mov      x29, x29
0x000483f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000483f8  mov      x24, x0
0x000483fc  str      x0, [sp, #0x138]
0x00048400  adrp     x8, #0x8e000
0x00048404  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00048408  add      x2, sp, #0x120
0x0004840c  mov      w3, #4
0x00048410  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00048414  mov      x29, x29
0x00048418  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004841c  adrp     x8, #0x8f000
0x00048420  ldrsw    x19, [x8, #0x4c]
0x00048424  ldr      x8, [x20, x19]
0x00048428  str      x0, [x20, x19]
0x0004842c  mov      x0, x8
0x00048430  bl       #0x55d78   ; CALL _objc_release
0x00048434  mov      x0, x24
0x00048438  bl       #0x55d78   ; CALL _objc_release
0x0004843c  mov      x0, x22
0x00048440  bl       #0x55d78   ; CALL _objc_release
0x00048444  mov      x0, x21
0x00048448  bl       #0x55d78   ; CALL _objc_release
0x0004844c  mov      x0, x23
0x00048450  bl       #0x55d78   ; CALL _objc_release
0x00048454  mov      x0, x28
0x00048458  bl       #0x55d78   ; CALL _objc_release
0x0004845c  mov      x0, x27
0x00048460  bl       #0x55d78   ; CALL _objc_release
0x00048464  mov      x0, x26
0x00048468  bl       #0x55d78   ; CALL _objc_release
0x0004846c  ldr      x0, [sp, #0x18]
0x00048470  bl       #0x55d78   ; CALL _objc_release
0x00048474  ldr      x0, [sp, #0x20]
0x00048478  bl       #0x55d78   ; CALL _objc_release
0x0004847c  ldr      x0, [sp, #0x28]
0x00048480  bl       #0x55d78   ; CALL _objc_release
0x00048484  ldr      x0, [sp, #0x30]
0x00048488  bl       #0x55d78   ; CALL _objc_release
0x0004848c  ldr      x0, [sp, #0x38]
0x00048490  bl       #0x55d78   ; CALL _objc_release
0x00048494  ldr      x0, [sp, #0x40]
0x00048498  bl       #0x55d78   ; CALL _objc_release
0x0004849c  ldr      x0, [sp, #0x48]
0x000484a0  bl       #0x55d78   ; CALL _objc_release
0x000484a4  ldr      x0, [sp, #0x58]
0x000484a8  bl       #0x55d78   ; CALL _objc_release
0x000484ac  ldr      x0, [sp, #0x50]
0x000484b0  bl       #0x55d78   ; CALL _objc_release
0x000484b4  adrp     x8, #0x8e000
0x000484b8  ldr      x0, [x8, #0xa58]   ; @CLASS NSLayoutConstraint
0x000484bc  ldr      x2, [x20, x19]
0x000484c0  bl       #0x55fe0   ; CALL objc_msgSend$activateConstraints:
0x000484c4  adrp     x8, #0x8e000
0x000484c8  ldr      x0, [x8, #0xa38]   ; @CLASS UIStackView
0x000484cc  bl       #0x55c7c   ; CALL _objc_alloc
0x000484d0  mov      x19, x0
0x000484d4  ldp      x9, x8, [sp, #0x60]
0x000484d8  ldr      x8, [x20, x8]
0x000484dc  ldr      x9, [x20, x9]
0x000484e0  stp      x8, x9, [sp, #0x108]
0x000484e4  ldr      x8, [x20, x25]
0x000484e8  str      x8, [sp, #0x118]
0x000484ec  adrp     x8, #0x8e000
0x000484f0  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000484f4  add      x2, sp, #0x108
0x000484f8  mov      w3, #3
0x000484fc  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00048500  mov      x29, x29
0x00048504  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048508  mov      x21, x0
0x0004850c  mov      x0, x19
0x00048510  mov      x2, x21
0x00048514  bl       #0x583a0   ; CALL objc_msgSend$initWithArrangedSubviews:
0x00048518  adrp     x8, #0x8f000
0x0004851c  ldrsw    x22, [x8, #8]
0x00048520  ldr      x8, [x20, x22]
0x00048524  str      x0, [x20, x22]
0x00048528  mov      x0, x8
0x0004852c  bl       #0x55d78   ; CALL _objc_release
0x00048530  mov      x0, x21
0x00048534  bl       #0x55d78   ; CALL _objc_release
0x00048538  ldr      x0, [x20, x22]
0x0004853c  mov      x2, #0
0x00048540  bl       #0x5a540   ; CALL objc_msgSend$setAxis:
0x00048544  ldr      x0, [x20, x22]
0x00048548  mov      w2, #3
0x0004854c  bl       #0x5a3a0   ; CALL objc_msgSend$setAlignment:
0x00048550  adrp     x2, #0x75000
0x00048554  add      x2, x2, #0x968   ; STR "date"
0x00048558  ldr      x0, [sp, #0x98]
0x0004855c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00048560  mov      x29, x29
0x00048564  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048568  mov      x26, x0
0x0004856c  adrp     x8, #0x8e000
0x00048570  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x00048574  bl       #0x55d48   ; CALL _objc_opt_class
0x00048578  mov      x1, x0
0x0004857c  mov      x0, x26
0x00048580  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00048584  tbz      w0, #0, #0x48630
0x00048588  adrp     x8, #0x8e000
0x0004858c  ldr      x0, [x8, #0x9f8]   ; @CLASS NSCalendar
0x00048590  bl       #0x57420   ; CALL objc_msgSend$currentCalendar
0x00048594  mov      x29, x29
0x00048598  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004859c  mov      x19, x0
0x000485a0  mov      x2, x26
0x000485a4  bl       #0x58780   ; CALL objc_msgSend$isDateInToday:
0x000485a8  adrp     x8, #0x8e000
0x000485ac  ldr      x8, [x8, #0x980]   ; @CLASS NSDateFormatter
0x000485b0  eor      w3, w0, #1
0x000485b4  mov      w23, #1
0x000485b8  mov      x0, x8
0x000485bc  mov      x2, x26
0x000485c0  mov      w4, #1
0x000485c4  bl       #0x58de0   ; CALL objc_msgSend$localizedStringFromDate:dateStyle:timeStyle:
0x000485c8  mov      x29, x29
0x000485cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000485d0  mov      x27, x0
0x000485d4  mov      x0, x19
0x000485d8  bl       #0x55d78   ; CALL _objc_release
0x000485dc  ldr      x28, [sp, #0x78]
0x000485e0  cbz      x27, #0x48644
0x000485e4  adrp     x8, #0x8e000
0x000485e8  ldr      x21, [x8, #0x958]   ; @CLASS NSString
0x000485ec  adrp     x0, #0x7d000
0x000485f0  add      x0, x0, #0x3a8   ; STR "Cập nhật lúc %@"
0x000485f4  adrp     x1, #0x7d000
0x000485f8  add      x1, x1, #0x3c8   ; STR "Updated %@"
0x000485fc  bl       #0x5505c   ; CALL _OMCTr
0x00048600  mov      x29, x29
0x00048604  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048608  mov      x19, x0
0x0004860c  str      x27, [sp]
0x00048610  mov      x0, x21
0x00048614  mov      x2, x19
0x00048618  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0004861c  mov      x29, x29
0x00048620  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048624  mov      x21, x0
0x00048628  mov      w25, #0
0x0004862c  b        #0x4864c
0x00048630  mov      x27, #0
0x00048634  mov      x21, #0
0x00048638  ldr      x28, [sp, #0x78]
0x0004863c  mov      w25, #1
0x00048640  b        #0x4864c
0x00048644  mov      x21, #0
0x00048648  mov      x25, x23
0x0004864c  mov      x0, x21
0x00048650  bl       #0x47664
0x00048654  mov      x29, x29
0x00048658  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004865c  adrp     x8, #0x8f000
0x00048660  ldrsw    x23, [x8, #0x28]
0x00048664  ldr      x8, [x20, x23]
0x00048668  str      x0, [x20, x23]
0x0004866c  mov      x0, x8
0x00048670  bl       #0x55d78   ; CALL _objc_release
0x00048674  mov      x24, x25
0x00048678  tbnz     w25, #0, #0x4868c
0x0004867c  mov      x0, x21
0x00048680  bl       #0x55d78   ; CALL _objc_release
0x00048684  mov      x0, x19
0x00048688  bl       #0x55d78   ; CALL _objc_release
0x0004868c  ldr      x0, [x20, x23]
0x00048690  adrp     x8, #0x65000
0x00048694  ldr      d0, [x8, #0x998]
0x00048698  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x0004869c  ldr      x0, [x20, x23]
0x000486a0  mov      x2, x24
0x000486a4  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x000486a8  adrp     x8, #0x8e000
0x000486ac  ldr      x0, [x8, #0xa38]   ; @CLASS UIStackView
0x000486b0  bl       #0x55c7c   ; CALL _objc_alloc
0x000486b4  mov      x19, x0
0x000486b8  ldr      x8, [x20, x28]
0x000486bc  ldr      x9, [x20, x22]
0x000486c0  stp      x8, x9, [sp, #0xf0]
0x000486c4  ldr      x8, [x20, x23]
0x000486c8  str      x8, [sp, #0x100]
0x000486cc  adrp     x8, #0x8e000
0x000486d0  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000486d4  add      x2, sp, #0xf0
0x000486d8  mov      w3, #3
0x000486dc  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000486e0  mov      x29, x29
0x000486e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000486e8  mov      x21, x0
0x000486ec  mov      x0, x19
0x000486f0  mov      x2, x21
0x000486f4  bl       #0x583a0   ; CALL objc_msgSend$initWithArrangedSubviews:
0x000486f8  adrp     x8, #0x8f000
0x000486fc  ldrsw    x19, [x8, #0xc]
0x00048700  ldr      x8, [x20, x19]
0x00048704  str      x0, [x20, x19]
0x00048708  mov      x0, x8
0x0004870c  bl       #0x55d78   ; CALL _objc_release
0x00048710  mov      x0, x21
0x00048714  bl       #0x55d78   ; CALL _objc_release
0x00048718  ldr      x0, [x20, x19]
0x0004871c  mov      w2, #1
0x00048720  bl       #0x5a540   ; CALL objc_msgSend$setAxis:
0x00048724  ldr      x0, [x20, x19]
0x00048728  mov      w2, #3
0x0004872c  bl       #0x5a3a0   ; CALL objc_msgSend$setAlignment:
0x00048730  mov      x0, x27
0x00048734  bl       #0x55d78   ; CALL _objc_release
0x00048738  mov      x0, x26
0x0004873c  bl       #0x55d78   ; CALL _objc_release
0x00048740  ldr      x0, [sp, #0x70]
0x00048744  bl       #0x55d78   ; CALL _objc_release
0x00048748  ldr      x0, [sp, #0x80]
0x0004874c  bl       #0x55d78   ; CALL _objc_release
0x00048750  ldr      x0, [sp, #0x88]
0x00048754  bl       #0x55d78   ; CALL _objc_release
0x00048758  ldr      x0, [sp, #0x90]
0x0004875c  bl       #0x55d78   ; CALL _objc_release
0x00048760  ldr      x0, [sp, #0x98]
0x00048764  bl       #0x55d78   ; CALL _objc_release
0x00048768  ldur     x8, [x29, #-0x60]
0x0004876c  adrp     x9, #0x74000
0x00048770  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00048774  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00048778  cmp      x9, x8
0x0004877c  b.ne     #0x487a0
0x00048780  add      sp, sp, #0x210
0x00048784  ldp      x29, x30, [sp, #0x50]
0x00048788  ldp      x20, x19, [sp, #0x40]
0x0004878c  ldp      x22, x21, [sp, #0x30]
0x00048790  ldp      x24, x23, [sp, #0x20]
0x00048794  ldp      x26, x25, [sp, #0x10]
0x00048798  ldp      x28, x27, [sp], #0x60
0x0004879c  ret      
0x000487a0  bl       #0x55b98   ; CALL ___stack_chk_fail
0x000487a4  stp      x22, x21, [sp, #-0x30]!
0x000487a8  stp      x20, x19, [sp, #0x10]
0x000487ac  stp      x29, x30, [sp, #0x20]
0x000487b0  add      x29, sp, #0x20
0x000487b4  mov      x19, x3
0x000487b8  mov      x20, x2
0x000487bc  cbz      x0, #0x487fc
0x000487c0  cmp      x0, #2
0x000487c4  b.gt     #0x48870
0x000487c8  adrp     x8, #0x7e000
0x000487cc  add      x8, x8, #0x148   ; STR "cloud.moon.fill"
0x000487d0  adrp     x9, #0x7e000
0x000487d4  add      x9, x9, #0x128   ; STR "cloud.sun.fill"
0x000487d8  cmp      w1, #0
0x000487dc  csel     x21, x9, x8, ne
0x000487e0  mov      x0, x21
0x000487e4  bl       #0x55d84   ; CALL _objc_retain
0x000487e8  adrp     x0, #0x7e000
0x000487ec  add      x0, x0, #0x168   ; STR "Ít mây"
0x000487f0  adrp     x1, #0x7e000
0x000487f4  add      x1, x1, #0x188   ; STR "Partly cloudy"
0x000487f8  b        #0x4882c
0x000487fc  adrp     x8, #0x7e000
0x00048800  add      x8, x8, #0xc8   ; STR "moon.stars.fill"
0x00048804  adrp     x9, #0x7a000
0x00048808  add      x9, x9, #0xf48   ; STR "sun.max.fill"
0x0004880c  cmp      w1, #0
0x00048810  csel     x21, x9, x8, ne
0x00048814  mov      x0, x21
0x00048818  bl       #0x55d84   ; CALL _objc_retain
0x0004881c  adrp     x0, #0x7e000
0x00048820  add      x0, x0, #0xe8   ; STR "Trời quang"
0x00048824  adrp     x1, #0x7e000
0x00048828  add      x1, x1, #0x108   ; STR "Clear"
0x0004882c  bl       #0x5505c   ; CALL _OMCTr
0x00048830  mov      x29, x29
0x00048834  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048838  mov      x22, x0
0x0004883c  cbz      x20, #0x4884c
0x00048840  mov      x0, x21
0x00048844  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00048848  str      x21, [x20]
0x0004884c  mov      x0, x22
0x00048850  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00048854  str      x22, [x19]
0x00048858  bl       #0x55d78   ; CALL _objc_release
0x0004885c  mov      x0, x21
0x00048860  ldp      x29, x30, [sp, #0x20]
0x00048864  ldp      x20, x19, [sp, #0x10]
0x00048868  ldp      x22, x21, [sp], #0x30
0x0004886c  b        #0x55d78   ; CALL _objc_release
0x00048870  cmp      x0, #0x30
0x00048874  b.eq     #0x488b4
0x00048878  cmp      x0, #0x2d
0x0004887c  b.eq     #0x488b4
0x00048880  cmp      x0, #3
0x00048884  b.ne     #0x488e0
0x00048888  adrp     x0, #0x7e000
0x0004888c  add      x0, x0, #0x1a8   ; STR "Nhiều mây"
0x00048890  adrp     x1, #0x7e000
0x00048894  add      x1, x1, #0x1c8   ; STR "Cloudy"
0x00048898  bl       #0x5505c   ; CALL _OMCTr
0x0004889c  mov      x29, x29
0x000488a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000488a4  mov      x22, x0
0x000488a8  adrp     x21, #0x7d000
0x000488ac  add      x21, x21, #0x2c8   ; STR "cloud.fill"
0x000488b0  b        #0x4883c
0x000488b4  adrp     x0, #0x7e000
0x000488b8  add      x0, x0, #0x208   ; STR "Sương mù"
0x000488bc  adrp     x1, #0x7e000
0x000488c0  add      x1, x1, #0x228   ; STR "Fog"
0x000488c4  bl       #0x5505c   ; CALL _OMCTr
0x000488c8  mov      x29, x29
0x000488cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000488d0  mov      x22, x0
0x000488d4  adrp     x21, #0x7e000
0x000488d8  add      x21, x21, #0x1e8   ; STR "cloud.fog.fill"
0x000488dc  b        #0x4883c
0x000488e0  sub      x8, x0, #0x33
0x000488e4  cmp      x8, #6
0x000488e8  b.hi     #0x48918
0x000488ec  adrp     x0, #0x7e000
0x000488f0  add      x0, x0, #0x268   ; STR "Mưa phùn"
0x000488f4  adrp     x1, #0x7e000
0x000488f8  add      x1, x1, #0x288   ; STR "Drizzle"
0x000488fc  bl       #0x5505c   ; CALL _OMCTr
0x00048900  mov      x29, x29
0x00048904  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048908  mov      x22, x0
0x0004890c  adrp     x21, #0x7e000
0x00048910  add      x21, x21, #0x248   ; STR "cloud.drizzle.fill"
0x00048914  b        #0x4883c
0x00048918  cmp      x0, #0x52
0x0004891c  b.eq     #0x48988
0x00048920  and      x8, x0, #0x7fffffffffffffff
0x00048924  and      x8, x8, #0xfffffffffffffffd
0x00048928  cmp      x8, #0x41
0x0004892c  b.eq     #0x48988
0x00048930  sub      x8, x0, #0x3d
0x00048934  cmp      x8, #0x19
0x00048938  b.hi     #0x489f8
0x0004893c  mov      w9, #1
0x00048940  lsl      x9, x9, x8
0x00048944  mov      w10, #0x7f
0x00048948  movk     w10, #0x38, lsl #16
0x0004894c  tst      x9, x10
0x00048950  b.eq     #0x489b4
0x00048954  adrp     x8, #0x7e000
0x00048958  add      x8, x8, #0x308   ; STR "cloud.rain.fill"
0x0004895c  adrp     x9, #0x7c000
0x00048960  add      x9, x9, #0xe28   ; STR "cloud.sun.rain.fill"
0x00048964  cmp      w1, #0
0x00048968  csel     x21, x9, x8, ne
0x0004896c  mov      x0, x21
0x00048970  bl       #0x55d84   ; CALL _objc_retain
0x00048974  adrp     x0, #0x7e000
0x00048978  add      x0, x0, #0x328   ; STR "Có mưa"
0x0004897c  adrp     x1, #0x7e000
0x00048980  add      x1, x1, #0x348   ; STR "Rain"
0x00048984  b        #0x4882c
0x00048988  adrp     x0, #0x7e000
0x0004898c  add      x0, x0, #0x2c8   ; STR "Mưa to"
0x00048990  adrp     x1, #0x7e000
0x00048994  add      x1, x1, #0x2e8   ; STR "Heavy rain"
0x00048998  bl       #0x5505c   ; CALL _OMCTr
0x0004899c  mov      x29, x29
0x000489a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000489a4  mov      x22, x0
0x000489a8  adrp     x21, #0x7e000
0x000489ac  add      x21, x21, #0x2a8   ; STR "cloud.heavyrain.fill"
0x000489b0  b        #0x4883c
0x000489b4  mov      w9, #1
0x000489b8  lsl      x8, x9, x8
0x000489bc  mov      w9, #0xfc00
0x000489c0  movk     w9, #0x301, lsl #16
0x000489c4  tst      x8, x9
0x000489c8  b.eq     #0x489f8
0x000489cc  adrp     x0, #0x7e000
0x000489d0  add      x0, x0, #0x388   ; STR "Có tuyết"
0x000489d4  adrp     x1, #0x7e000
0x000489d8  add      x1, x1, #0x3a8   ; STR "Snow"
0x000489dc  bl       #0x5505c   ; CALL _OMCTr
0x000489e0  mov      x29, x29
0x000489e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000489e8  mov      x22, x0
0x000489ec  adrp     x21, #0x7e000
0x000489f0  add      x21, x21, #0x368   ; STR "cloud.snow.fill"
0x000489f4  b        #0x4883c
0x000489f8  cmp      x0, #0x5f
0x000489fc  b.lo     #0x48888
0x00048a00  adrp     x0, #0x7e000
0x00048a04  add      x0, x0, #0x3e8   ; STR "Dông"
0x00048a08  adrp     x1, #0x7e000
0x00048a0c  add      x1, x1, #0x408   ; STR "Thunderstorm"
0x00048a10  bl       #0x5505c   ; CALL _OMCTr
0x00048a14  mov      x29, x29
0x00048a18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048a1c  mov      x22, x0
0x00048a20  adrp     x21, #0x7e000
0x00048a24  add      x21, x21, #0x3c8   ; STR "cloud.bolt.rain.fill"
0x00048a28  b        #0x4883c
0x00048a2c  stp      d9, d8, [sp, #-0x40]!
0x00048a30  stp      x22, x21, [sp, #0x10]
0x00048a34  stp      x20, x19, [sp, #0x20]
0x00048a38  stp      x29, x30, [sp, #0x30]
0x00048a3c  add      x29, sp, #0x30
0x00048a40  cbz      x0, #0x48b18
0x00048a44  mov      x20, x0
0x00048a48  adrp     x8, #0x8e000
0x00048a4c  ldr      x19, [x8, #0xce8]   ; @CLASS NSMeasurementFormatter
0x00048a50  bl       #0x55d84   ; CALL _objc_retain
0x00048a54  mov      x0, x19
0x00048a58  bl       #0x55d60   ; CALL _objc_opt_new
0x00048a5c  mov      x19, x0
0x00048a60  mov      w2, #1
0x00048a64  bl       #0x5c720   ; CALL objc_msgSend$setUnitStyle:
0x00048a68  adrp     x8, #0x8e000
0x00048a6c  ldr      x0, [x8, #0xcf0]   ; @CLASS NSNumberFormatter
0x00048a70  bl       #0x55d60   ; CALL _objc_opt_new
0x00048a74  mov      x21, x0
0x00048a78  mov      x2, #0
0x00048a7c  bl       #0x5b560   ; CALL objc_msgSend$setMaximumFractionDigits:
0x00048a80  mov      x0, x19
0x00048a84  mov      x2, x21
0x00048a88  bl       #0x5b800   ; CALL objc_msgSend$setNumberFormatter:
0x00048a8c  adrp     x8, #0x8e000
0x00048a90  ldr      x0, [x8, #0xcf8]   ; @CLASS NSMeasurement
0x00048a94  bl       #0x55c7c   ; CALL _objc_alloc
0x00048a98  mov      x22, x0
0x00048a9c  mov      x0, x20
0x00048aa0  bl       #0x57880   ; CALL objc_msgSend$doubleValue
0x00048aa4  mov      v8.16b, v0.16b
0x00048aa8  mov      x0, x20
0x00048aac  bl       #0x55d78   ; CALL _objc_release
0x00048ab0  adrp     x8, #0x8e000
0x00048ab4  ldr      x0, [x8, #0xd00]   ; @CLASS NSUnitTemperature
0x00048ab8  bl       #0x56d40   ; CALL objc_msgSend$celsius
0x00048abc  mov      x29, x29
0x00048ac0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048ac4  mov      x20, x0
0x00048ac8  mov      x0, x22
0x00048acc  mov      v0.16b, v8.16b
0x00048ad0  mov      x2, x20
0x00048ad4  bl       #0x58420   ; CALL objc_msgSend$initWithDoubleValue:unit:
0x00048ad8  mov      x22, x0
0x00048adc  mov      x0, x20
0x00048ae0  bl       #0x55d78   ; CALL _objc_release
0x00048ae4  mov      x0, x19
0x00048ae8  mov      x2, x22
0x00048aec  bl       #0x5d520   ; CALL objc_msgSend$stringFromMeasurement:
0x00048af0  mov      x29, x29
0x00048af4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048af8  mov      x20, x0
0x00048afc  mov      x0, x22
0x00048b00  bl       #0x55d78   ; CALL _objc_release
0x00048b04  mov      x0, x21
0x00048b08  bl       #0x55d78   ; CALL _objc_release
0x00048b0c  mov      x0, x19
0x00048b10  bl       #0x55d78   ; CALL _objc_release
0x00048b14  b        #0x48b20
0x00048b18  adrp     x20, #0x7b000
0x00048b1c  add      x20, x20, #0x408   ; STR "--"
0x00048b20  mov      x0, x20
0x00048b24  ldp      x29, x30, [sp, #0x30]
0x00048b28  ldp      x20, x19, [sp, #0x20]
0x00048b2c  ldp      x22, x21, [sp, #0x10]
0x00048b30  ldp      d9, d8, [sp], #0x40
0x00048b34  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[SSStartupView layoutSubviews]  va=0x48b38 size=532 types=v16@0:8
0x00048b38  sub      sp, sp, #0x70
0x00048b3c  stp      d11, d10, [sp, #0x10]
0x00048b40  stp      d9, d8, [sp, #0x20]
0x00048b44  stp      x24, x23, [sp, #0x30]
0x00048b48  stp      x22, x21, [sp, #0x40]
0x00048b4c  stp      x20, x19, [sp, #0x50]
0x00048b50  stp      x29, x30, [sp, #0x60]
0x00048b54  add      x29, sp, #0x60
0x00048b58  mov      x19, x0
0x00048b5c  adrp     x8, #0x8e000
0x00048b60  ldr      x8, [x8, #0xdb8]   ; @SUPER SSStartupView
0x00048b64  stp      x0, x8, [sp]
0x00048b68  adrp     x8, #0x8b000
0x00048b6c  ldr      x1, [x8, #0xe28]   ; @SEL "layoutSubviews"
0x00048b70  mov      x0, sp
0x00048b74  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00048b78  mov      x0, x19
0x00048b7c  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00048b80  mov      x8, #0x4059000000000000
0x00048b84  fmov     d0, x8
0x00048b88  fdiv     d0, d3, d0
0x00048b8c  adrp     x8, #0x65000
0x00048b90  ldr      d1, [x8, #0xed8]
0x00048b94  fdiv     d1, d2, d1
0x00048b98  fcmp     d0, d1
0x00048b9c  fcsel    d8, d0, d1, mi
0x00048ba0  fcmp     d8, #0.0
0x00048ba4  b.ls     #0x48d2c
0x00048ba8  mov      v10.16b, v2.16b
0x00048bac  mov      v9.16b, v3.16b
0x00048bb0  adrp     x8, #0x8e000
0x00048bb4  ldrsw    x8, [x8, #0xffc]
0x00048bb8  ldr      x8, [x19, x8]
0x00048bbc  tbnz     x8, #0x3f, #0x48bec
0x00048bc0  adrp     x8, #0x8f000
0x00048bc4  ldrsw    x8, [x8, #0x54]
0x00048bc8  add      x8, x19, x8
0x00048bcc  ldr      d0, [x8]
0x00048bd0  fcmp     d10, d0
0x00048bd4  b.ne     #0x48be4
0x00048bd8  ldr      d0, [x8, #8]
0x00048bdc  fcmp     d9, d0
0x00048be0  b.eq     #0x48bec
0x00048be4  mov      x0, x19
0x00048be8  bl       #0x5d080   ; CALL objc_msgSend$ss_buildScene
0x00048bec  mov      x0, x19
0x00048bf0  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00048bf4  adrp     x8, #0x8f000
0x00048bf8  ldrsw    x23, [x8, #0x14]
0x00048bfc  ldr      x0, [x19, x23]
0x00048c00  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00048c04  ldr      x0, [x19, x23]
0x00048c08  bl       #0x57220   ; CALL objc_msgSend$contentMode
0x00048c0c  cmp      x0, #4
0x00048c10  b.ne     #0x48c84
0x00048c14  ldr      x0, [x19, x23]
0x00048c18  bl       #0x58080   ; CALL objc_msgSend$image
0x00048c1c  mov      x29, x29
0x00048c20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048c24  mov      x20, x0
0x00048c28  adrp     x8, #0x8e000
0x00048c2c  ldr      x0, [x8, #0xa70]   ; @CLASS UIImageSymbolConfiguration
0x00048c30  fmov     d0, #28.00000000
0x00048c34  fmul     d0, d8, d0
0x00048c38  bl       #0x570e0   ; CALL objc_msgSend$configurationWithPointSize:
0x00048c3c  mov      x29, x29
0x00048c40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048c44  mov      x21, x0
0x00048c48  mov      x0, x20
0x00048c4c  mov      x2, x21
0x00048c50  bl       #0x581a0   ; CALL objc_msgSend$imageWithConfiguration:
0x00048c54  mov      x29, x29
0x00048c58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048c5c  mov      x22, x0
0x00048c60  ldr      x0, [x19, x23]
0x00048c64  mov      x2, x22
0x00048c68  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00048c6c  mov      x0, x22
0x00048c70  bl       #0x55d78   ; CALL _objc_release
0x00048c74  mov      x0, x21
0x00048c78  bl       #0x55d78   ; CALL _objc_release
0x00048c7c  mov      x0, x20
0x00048c80  bl       #0x55d78   ; CALL _objc_release
0x00048c84  adrp     x8, #0x8f000
0x00048c88  ldrsw    x20, [x8, #0x18]
0x00048c8c  ldr      x0, [x19, x20]
0x00048c90  cbz      x0, #0x48cfc
0x00048c94  fmov     d11, #0.50000000
0x00048c98  fmul     d10, d10, d11
0x00048c9c  adrp     x8, #0x65000
0x00048ca0  ldr      d0, [x8, #0xa20]
0x00048ca4  fmul     d0, d9, d0
0x00048ca8  fcmp     d10, d0
0x00048cac  fcsel    d2, d10, d0, mi
0x00048cb0  fmov     d0, xzr
0x00048cb4  fmov     d1, xzr
0x00048cb8  mov      v3.16b, v2.16b
0x00048cbc  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x00048cc0  fmul     d1, d9, d11
0x00048cc4  ldr      x0, [x19, x20]
0x00048cc8  mov      v0.16b, v10.16b
0x00048ccc  bl       #0x5a840   ; CALL objc_msgSend$setCenter:
0x00048cd0  fmov     d0, #7.00000000
0x00048cd4  fmul     d9, d8, d0
0x00048cd8  ldr      x0, [x19, x20]
0x00048cdc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00048ce0  mov      x29, x29
0x00048ce4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048ce8  mov      x20, x0
0x00048cec  mov      v0.16b, v9.16b
0x00048cf0  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x00048cf4  mov      x0, x20
0x00048cf8  bl       #0x55d78   ; CALL _objc_release
0x00048cfc  adrp     x8, #0x8f000
0x00048d00  ldrsw    x8, [x8, #0x50]
0x00048d04  ldr      d0, [x19, x8]
0x00048d08  fabd     d0, d8, d0
0x00048d0c  adrp     x9, #0x65000
0x00048d10  ldr      d1, [x9, #0xee0]
0x00048d14  fcmp     d0, d1
0x00048d18  b.mi     #0x48d2c
0x00048d1c  str      d8, [x19, x8]
0x00048d20  mov      x0, x19
0x00048d24  mov      v0.16b, v8.16b
0x00048d28  bl       #0x56560   ; CALL objc_msgSend$applyUnit:
0x00048d2c  ldp      x29, x30, [sp, #0x60]
0x00048d30  ldp      x20, x19, [sp, #0x50]
0x00048d34  ldp      x22, x21, [sp, #0x40]
0x00048d38  ldp      x24, x23, [sp, #0x30]
0x00048d3c  ldp      d9, d8, [sp, #0x20]
0x00048d40  ldp      d11, d10, [sp, #0x10]
0x00048d44  add      sp, sp, #0x70
0x00048d48  ret      

=== -[SSStartupView applyUnit:]  va=0x48d4c size=1624 types=v24@0:8d16
0x00048d4c  sub      sp, sp, #0xe0
0x00048d50  stp      d11, d10, [sp, #0x60]
0x00048d54  stp      d9, d8, [sp, #0x70]
0x00048d58  stp      x28, x27, [sp, #0x80]
0x00048d5c  stp      x26, x25, [sp, #0x90]
0x00048d60  stp      x24, x23, [sp, #0xa0]
0x00048d64  stp      x22, x21, [sp, #0xb0]
0x00048d68  stp      x20, x19, [sp, #0xc0]
0x00048d6c  stp      x29, x30, [sp, #0xd0]
0x00048d70  add      x29, sp, #0xd0
0x00048d74  mov      v8.16b, v0.16b
0x00048d78  mov      x19, x0
0x00048d7c  adrp     x8, #0x74000
0x00048d80  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00048d84  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00048d88  str      x8, [sp, #0x58]
0x00048d8c  adrp     x8, #0x8f000
0x00048d90  ldrsw    x22, [x8, #0x24]
0x00048d94  ldr      x20, [x0, x22]
0x00048d98  mov      x0, x20
0x00048d9c  bl       #0x55d84   ; CALL _objc_retain
0x00048da0  str      x20, [sp, #0x18]
0x00048da4  adrp     x8, #0x8f000
0x00048da8  ldrsw    x24, [x8, #0x20]
0x00048dac  ldr      x20, [x19, x24]
0x00048db0  mov      x0, x20
0x00048db4  bl       #0x55d84   ; CALL _objc_retain
0x00048db8  str      x20, [sp, #0x20]
0x00048dbc  adrp     x8, #0x8f000
0x00048dc0  ldrsw    x26, [x8, #0x1c]
0x00048dc4  ldr      x20, [x19, x26]
0x00048dc8  mov      x0, x20
0x00048dcc  bl       #0x55d84   ; CALL _objc_retain
0x00048dd0  str      x20, [sp, #0x28]
0x00048dd4  adrp     x8, #0x8f000
0x00048dd8  ldrsw    x8, [x8, #0x38]
0x00048ddc  str      x8, [sp, #0x10]
0x00048de0  ldr      x20, [x19, x8]
0x00048de4  mov      x0, x20
0x00048de8  bl       #0x55d84   ; CALL _objc_retain
0x00048dec  str      x20, [sp, #0x30]
0x00048df0  adrp     x8, #0x8f000
0x00048df4  ldrsw    x28, [x8, #0x34]
0x00048df8  ldr      x20, [x19, x28]
0x00048dfc  mov      x0, x20
0x00048e00  bl       #0x55d84   ; CALL _objc_retain
0x00048e04  str      x20, [sp, #0x38]
0x00048e08  adrp     x8, #0x8f000
0x00048e0c  ldrsw    x27, [x8, #0x30]
0x00048e10  ldr      x20, [x19, x27]
0x00048e14  mov      x0, x20
0x00048e18  bl       #0x55d84   ; CALL _objc_retain
0x00048e1c  str      x20, [sp, #0x40]
0x00048e20  adrp     x8, #0x8f000
0x00048e24  ldrsw    x8, [x8, #0x2c]
0x00048e28  str      x8, [sp]
0x00048e2c  ldr      x20, [x19, x8]
0x00048e30  mov      x0, x20
0x00048e34  bl       #0x55d84   ; CALL _objc_retain
0x00048e38  str      x20, [sp, #0x48]
0x00048e3c  adrp     x8, #0x8f000
0x00048e40  ldrsw    x8, [x8, #0x28]
0x00048e44  str      x8, [sp, #8]
0x00048e48  ldr      x20, [x19, x8]
0x00048e4c  mov      x0, x20
0x00048e50  bl       #0x55d84   ; CALL _objc_retain
0x00048e54  mov      x23, #0
0x00048e58  str      x20, [sp, #0x50]
0x00048e5c  fmov     d0, #1.50000000
0x00048e60  fmul     d9, d8, d0
0x00048e64  fmov     d0, #0.50000000
0x00048e68  fmul     d10, d8, d0
0x00048e6c  add      x25, sp, #0x18
0x00048e70  ldr      x20, [x25, x23]
0x00048e74  cbz      x20, #0x48ed8
0x00048e78  mov      x0, x20
0x00048e7c  bl       #0x55d84   ; CALL _objc_retain
0x00048e80  mov      x0, x20
0x00048e84  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00048e88  mov      x29, x29
0x00048e8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048e90  mov      x21, x0
0x00048e94  mov      v0.16b, v9.16b
0x00048e98  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x00048e9c  mov      x0, x21
0x00048ea0  bl       #0x55d78   ; CALL _objc_release
0x00048ea4  mov      x0, x20
0x00048ea8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00048eac  mov      x29, x29
0x00048eb0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048eb4  mov      x21, x0
0x00048eb8  mov      x0, x20
0x00048ebc  bl       #0x55d78   ; CALL _objc_release
0x00048ec0  fmov     d0, xzr
0x00048ec4  mov      x0, x21
0x00048ec8  mov      v1.16b, v10.16b
0x00048ecc  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x00048ed0  mov      x0, x21
0x00048ed4  bl       #0x55d78   ; CALL _objc_release
0x00048ed8  add      x23, x23, #8
0x00048edc  cmp      x23, #0x40
0x00048ee0  b.ne     #0x48e70
0x00048ee4  fmov     d0, #-12.00000000
0x00048ee8  fmul     d0, d8, d0
0x00048eec  adrp     x8, #0x8f000
0x00048ef0  ldrsw    x8, [x8, #0x40]
0x00048ef4  ldr      x0, [x19, x8]
0x00048ef8  bl       #0x5a980   ; CALL objc_msgSend$setConstant:
0x00048efc  ldr      x8, [x19, x22]
0x00048f00  cbz      x8, #0x48fb0
0x00048f04  fmov     d0, #30.00000000
0x00048f08  fmul     d0, d8, d0
0x00048f0c  adrp     x8, #0x74000
0x00048f10  ldr      x8, [x8, #0x248]   ; @GOT _UIFontWeightLight
0x00048f14  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x00048f18  bl       #0x492e8
0x00048f1c  mov      x29, x29
0x00048f20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048f24  mov      x20, x0
0x00048f28  ldr      x0, [x19, x22]
0x00048f2c  mov      x2, x20
0x00048f30  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00048f34  mov      x0, x20
0x00048f38  bl       #0x55d78   ; CALL _objc_release
0x00048f3c  fmov     d0, #10.00000000
0x00048f40  fmul     d0, d8, d0
0x00048f44  adrp     x8, #0x74000
0x00048f48  ldr      x8, [x8, #0x260]   ; @GOT _UIFontWeightSemibold
0x00048f4c  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x00048f50  bl       #0x492e8
0x00048f54  mov      x29, x29
0x00048f58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048f5c  mov      x20, x0
0x00048f60  ldr      x0, [x19, x24]
0x00048f64  mov      x2, x20
0x00048f68  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00048f6c  mov      x0, x20
0x00048f70  bl       #0x55d78   ; CALL _objc_release
0x00048f74  fmov     d0, #6.00000000
0x00048f78  fmul     d0, d8, d0
0x00048f7c  adrp     x8, #0x74000
0x00048f80  ldr      x8, [x8, #0x250]   ; @GOT _UIFontWeightMedium
0x00048f84  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x00048f88  bl       #0x492e8
0x00048f8c  mov      x29, x29
0x00048f90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048f94  mov      x20, x0
0x00048f98  ldr      x0, [x19, x26]
0x00048f9c  mov      x2, x20
0x00048fa0  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00048fa4  mov      x0, x20
0x00048fa8  bl       #0x55d78   ; CALL _objc_release
0x00048fac  b        #0x49274
0x00048fb0  ldr      x21, [sp, #0x10]
0x00048fb4  ldr      x8, [x19, x21]
0x00048fb8  cbz      x8, #0x49288
0x00048fbc  fmov     d0, #7.00000000
0x00048fc0  fmul     d0, d8, d0
0x00048fc4  adrp     x8, #0x74000
0x00048fc8  ldr      x8, [x8, #0x260]   ; @GOT _UIFontWeightSemibold
0x00048fcc  ldr      d9, [x8]   ; @GOT ___objc_personality_v0
0x00048fd0  mov      v1.16b, v9.16b
0x00048fd4  bl       #0x492e8
0x00048fd8  mov      x29, x29
0x00048fdc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00048fe0  mov      x20, x0
0x00048fe4  ldr      x0, [x19, x24]
0x00048fe8  mov      x2, x20
0x00048fec  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00048ff0  mov      x0, x20
0x00048ff4  bl       #0x55d78   ; CALL _objc_release
0x00048ff8  fmov     d0, #30.00000000
0x00048ffc  fmul     d0, d8, d0
0x00049000  adrp     x8, #0x74000
0x00049004  ldr      x8, [x8, #0x250]   ; @GOT _UIFontWeightMedium
0x00049008  ldr      d11, [x8]   ; @GOT ___objc_personality_v0
0x0004900c  mov      v1.16b, v11.16b
0x00049010  bl       #0x492e8
0x00049014  mov      x29, x29
0x00049018  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004901c  mov      x20, x0
0x00049020  ldr      x0, [x19, x21]
0x00049024  mov      x2, x20
0x00049028  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x0004902c  mov      x0, x20
0x00049030  bl       #0x55d78   ; CALL _objc_release
0x00049034  fmov     d0, #7.50000000
0x00049038  fmul     d0, d8, d0
0x0004903c  mov      v1.16b, v9.16b
0x00049040  bl       #0x492e8
0x00049044  mov      x29, x29
0x00049048  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004904c  mov      x20, x0
0x00049050  ldr      x0, [x19, x28]
0x00049054  mov      x2, x20
0x00049058  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x0004905c  mov      x0, x20
0x00049060  bl       #0x55d78   ; CALL _objc_release
0x00049064  fmov     d0, #6.00000000
0x00049068  fmul     d10, d8, d0
0x0004906c  mov      v0.16b, v10.16b
0x00049070  mov      v1.16b, v11.16b
0x00049074  bl       #0x492e8
0x00049078  mov      x29, x29
0x0004907c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049080  mov      x20, x0
0x00049084  ldr      x0, [x19, x27]
0x00049088  mov      x2, x20
0x0004908c  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00049090  mov      x0, x20
0x00049094  bl       #0x55d78   ; CALL _objc_release
0x00049098  fmov     d0, #5.50000000
0x0004909c  fmul     d9, d8, d0
0x000490a0  mov      v0.16b, v9.16b
0x000490a4  mov      v1.16b, v11.16b
0x000490a8  bl       #0x492e8
0x000490ac  mov      x29, x29
0x000490b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000490b4  mov      x20, x0
0x000490b8  ldr      x8, [sp]
0x000490bc  ldr      x0, [x19, x8]
0x000490c0  mov      x2, x20
0x000490c4  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x000490c8  mov      x0, x20
0x000490cc  bl       #0x55d78   ; CALL _objc_release
0x000490d0  adrp     x8, #0x65000
0x000490d4  ldr      d0, [x8, #0xee8]
0x000490d8  fmul     d0, d8, d0
0x000490dc  adrp     x8, #0x74000
0x000490e0  ldr      x8, [x8, #0x258]   ; @GOT _UIFontWeightRegular
0x000490e4  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x000490e8  bl       #0x492e8
0x000490ec  mov      x29, x29
0x000490f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000490f4  mov      x20, x0
0x000490f8  ldr      x8, [sp, #8]
0x000490fc  ldr      x0, [x19, x8]
0x00049100  mov      x2, x20
0x00049104  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00049108  mov      x0, x20
0x0004910c  bl       #0x55d78   ; CALL _objc_release
0x00049110  mov      x8, #0x4040000000000000
0x00049114  fmov     d0, x8
0x00049118  fmul     d11, d8, d0
0x0004911c  adrp     x8, #0x8f000
0x00049120  ldrsw    x8, [x8, #0x44]
0x00049124  ldr      x0, [x19, x8]
0x00049128  mov      v0.16b, v11.16b
0x0004912c  bl       #0x5a980   ; CALL objc_msgSend$setConstant:
0x00049130  adrp     x8, #0x8f000
0x00049134  ldrsw    x8, [x8, #0x48]
0x00049138  ldr      x0, [x19, x8]
0x0004913c  mov      v0.16b, v11.16b
0x00049140  bl       #0x5a980   ; CALL objc_msgSend$setConstant:
0x00049144  fmov     d0, #4.00000000
0x00049148  fmul     d0, d8, d0
0x0004914c  adrp     x8, #0x8f000
0x00049150  ldrsw    x20, [x8, #8]
0x00049154  ldr      x0, [x19, x20]
0x00049158  bl       #0x5c240   ; CALL objc_msgSend$setSpacing:
0x0004915c  ldr      x0, [x19, x20]
0x00049160  ldr      x2, [x19, x21]
0x00049164  mov      v0.16b, v10.16b
0x00049168  bl       #0x5abe0   ; CALL objc_msgSend$setCustomSpacing:afterView:
0x0004916c  adrp     x8, #0x65000
0x00049170  ldr      d0, [x8, #0x830]
0x00049174  fmul     d0, d8, d0
0x00049178  adrp     x8, #0x8f000
0x0004917c  ldrsw    x8, [x8, #4]
0x00049180  ldr      x0, [x19, x8]
0x00049184  bl       #0x5c240   ; CALL objc_msgSend$setSpacing:
0x00049188  adrp     x8, #0x8f000
0x0004918c  ldrsw    x8, [x8, #0x3c]
0x00049190  ldr      x0, [x19, x8]
0x00049194  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00049198  mov      x29, x29
0x0004919c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000491a0  mov      x20, x0
0x000491a4  mov      v0.16b, v9.16b
0x000491a8  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x000491ac  mov      x0, x20
0x000491b0  bl       #0x55d78   ; CALL _objc_release
0x000491b4  fmov     d0, #5.00000000
0x000491b8  fmul     d9, d8, d0
0x000491bc  adrp     x8, #0x8f000
0x000491c0  ldrsw    x22, [x8, #0x4c]
0x000491c4  ldr      x0, [x19, x22]
0x000491c8  mov      w2, #1
0x000491cc  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000491d0  mov      x29, x29
0x000491d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000491d8  mov      x20, x0
0x000491dc  mov      v0.16b, v9.16b
0x000491e0  bl       #0x5a980   ; CALL objc_msgSend$setConstant:
0x000491e4  ldr      x0, [x19, x22]
0x000491e8  mov      x2, #0
0x000491ec  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000491f0  mov      x29, x29
0x000491f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000491f8  mov      x21, x0
0x000491fc  mov      v0.16b, v9.16b
0x00049200  bl       #0x5a980   ; CALL objc_msgSend$setConstant:
0x00049204  mov      x0, x21
0x00049208  bl       #0x55d78   ; CALL _objc_release
0x0004920c  mov      x0, x20
0x00049210  bl       #0x55d78   ; CALL _objc_release
0x00049214  fmov     d0, #3.50000000
0x00049218  fmul     d9, d8, d0
0x0004921c  ldr      x0, [x19, x22]
0x00049220  mov      w2, #3
0x00049224  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00049228  mov      x29, x29
0x0004922c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049230  mov      x20, x0
0x00049234  mov      v0.16b, v9.16b
0x00049238  bl       #0x5a980   ; CALL objc_msgSend$setConstant:
0x0004923c  ldr      x0, [x19, x22]
0x00049240  mov      w2, #2
0x00049244  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00049248  mov      x29, x29
0x0004924c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049250  mov      x21, x0
0x00049254  mov      v0.16b, v9.16b
0x00049258  bl       #0x5a980   ; CALL objc_msgSend$setConstant:
0x0004925c  mov      x0, x21
0x00049260  bl       #0x55d78   ; CALL _objc_release
0x00049264  mov      x0, x20
0x00049268  bl       #0x55d78   ; CALL _objc_release
0x0004926c  fmov     d0, #3.00000000
0x00049270  fmul     d9, d8, d0
0x00049274  adrp     x8, #0x8f000
0x00049278  ldrsw    x8, [x8, #0xc]
0x0004927c  ldr      x0, [x19, x8]
0x00049280  mov      v0.16b, v9.16b
0x00049284  bl       #0x5c240   ; CALL objc_msgSend$setSpacing:
0x00049288  mov      w19, #0x38
0x0004928c  add      x20, sp, #0x18
0x00049290  ldr      x0, [x20, x19]
0x00049294  bl       #0x55d78   ; CALL _objc_release
0x00049298  sub      x19, x19, #8
0x0004929c  cmn      x19, #8
0x000492a0  b.ne     #0x49290
0x000492a4  ldr      x8, [sp, #0x58]
0x000492a8  adrp     x9, #0x74000
0x000492ac  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000492b0  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000492b4  cmp      x9, x8
0x000492b8  b.ne     #0x492e4
0x000492bc  ldp      x29, x30, [sp, #0xd0]
0x000492c0  ldp      x20, x19, [sp, #0xc0]
0x000492c4  ldp      x22, x21, [sp, #0xb0]
0x000492c8  ldp      x24, x23, [sp, #0xa0]
0x000492cc  ldp      x26, x25, [sp, #0x90]
0x000492d0  ldp      x28, x27, [sp, #0x80]
0x000492d4  ldp      d9, d8, [sp, #0x70]
0x000492d8  ldp      d11, d10, [sp, #0x60]
0x000492dc  add      sp, sp, #0xe0
0x000492e0  ret      
0x000492e4  bl       #0x55b98   ; CALL ___stack_chk_fail
0x000492e8  stp      d9, d8, [sp, #-0x40]!
0x000492ec  stp      x22, x21, [sp, #0x10]
0x000492f0  stp      x20, x19, [sp, #0x20]
0x000492f4  stp      x29, x30, [sp, #0x30]
0x000492f8  add      x29, sp, #0x30
0x000492fc  mov      v8.16b, v0.16b
0x00049300  adrp     x22, #0x8e000
0x00049304  ldr      x0, [x22, #0x948]   ; @CLASS UIFont
0x00049308  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x0004930c  mov      x29, x29
0x00049310  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049314  mov      x19, x0
0x00049318  bl       #0x57c80   ; CALL objc_msgSend$fontDescriptor
0x0004931c  mov      x29, x29
0x00049320  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049324  mov      x21, x0
0x00049328  adrp     x8, #0x74000
0x0004932c  ldr      x8, [x8, #0x208]   ; @GOT _UIFontDescriptorSystemDesignRounded
0x00049330  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x00049334  bl       #0x57cc0   ; CALL objc_msgSend$fontDescriptorWithDesign:
0x00049338  mov      x29, x29
0x0004933c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049340  mov      x20, x0
0x00049344  mov      x0, x21
0x00049348  bl       #0x55d78   ; CALL _objc_release
0x0004934c  cbz      x20, #0x49370
0x00049350  ldr      x0, [x22, #0x948]   ; @CLASS UIFont
0x00049354  mov      x2, x20
0x00049358  mov      v0.16b, v8.16b
0x0004935c  bl       #0x57ce0   ; CALL objc_msgSend$fontWithDescriptor:size:
0x00049360  mov      x29, x29
0x00049364  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049368  mov      x21, x0
0x0004936c  b        #0x4937c
0x00049370  mov      x0, x19
0x00049374  bl       #0x55d84   ; CALL _objc_retain
0x00049378  mov      x21, x19
0x0004937c  mov      x0, x20
0x00049380  bl       #0x55d78   ; CALL _objc_release
0x00049384  mov      x0, x19
0x00049388  bl       #0x55d78   ; CALL _objc_release
0x0004938c  mov      x0, x21
0x00049390  ldp      x29, x30, [sp, #0x30]
0x00049394  ldp      x20, x19, [sp, #0x20]
0x00049398  ldp      x22, x21, [sp, #0x10]
0x0004939c  ldp      d9, d8, [sp], #0x40
0x000493a0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[SSStartupView playIntro]  va=0x493a4 size=1740 types=v16@0:8
0x000493a4  sub      sp, sp, #0x1c0
0x000493a8  stp      d11, d10, [sp, #0x160]
0x000493ac  stp      d9, d8, [sp, #0x170]
0x000493b0  stp      x28, x27, [sp, #0x180]
0x000493b4  stp      x22, x21, [sp, #0x190]
0x000493b8  stp      x20, x19, [sp, #0x1a0]
0x000493bc  stp      x29, x30, [sp, #0x1b0]
0x000493c0  add      x29, sp, #0x1b0
0x000493c4  mov      x20, x0
0x000493c8  bl       #0x58b00   ; CALL objc_msgSend$layoutIfNeeded
0x000493cc  adrp     x8, #0x8f000
0x000493d0  ldrsw    x8, [x8, #0x50]
0x000493d4  ldr      d0, [x20, x8]
0x000493d8  fmov     d1, #1.00000000
0x000493dc  fcmp     d0, d1
0x000493e0  fcsel    d10, d1, d0, mi
0x000493e4  adrp     x8, #0x8f000
0x000493e8  ldrsw    x8, [x8, #0x18]
0x000493ec  ldr      x19, [x20, x8]
0x000493f0  cbz      x19, #0x49500
0x000493f4  mov      x0, x19
0x000493f8  bl       #0x55d84   ; CALL _objc_retain
0x000493fc  mov      x0, x19
0x00049400  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00049404  mov      x29, x29
0x00049408  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004940c  mov      x21, x0
0x00049410  bl       #0x59d80   ; CALL objc_msgSend$removeAllAnimations
0x00049414  mov      x0, x21
0x00049418  bl       #0x55d78   ; CALL _objc_release
0x0004941c  mov      x0, x19
0x00049420  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00049424  mov      x29, x29
0x00049428  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004942c  mov      x21, x0
0x00049430  fmov     s0, wzr
0x00049434  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x00049438  mov      x0, x21
0x0004943c  bl       #0x55d78   ; CALL _objc_release
0x00049440  fmov     d0, xzr
0x00049444  mov      x0, x19
0x00049448  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x0004944c  mov      x0, x20
0x00049450  bl       #0x58e40   ; CALL objc_msgSend$logoEffect
0x00049454  cmp      x0, #1
0x00049458  b.ne     #0x49560
0x0004945c  sub      x8, x29, #0x80
0x00049460  fmov     d0, #0.50000000
0x00049464  fmov     d1, #0.50000000
0x00049468  bl       #0x5588c   ; CALL _CGAffineTransformMakeScale
0x0004946c  ldp      q0, q1, [x29, #-0x80]
0x00049470  stp      q0, q1, [x29, #-0xb0]
0x00049474  ldur     q0, [x29, #-0x60]
0x00049478  stur     q0, [x29, #-0x90]
0x0004947c  sub      x2, x29, #0xb0
0x00049480  mov      x0, x19
0x00049484  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x00049488  adrp     x8, #0x8e000
0x0004948c  ldr      x20, [x8, #0x918]   ; @CLASS UIView
0x00049490  adrp     x8, #0x74000
0x00049494  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00049498  str      x8, [sp, #0xd8]
0x0004949c  adrp     x8, #0x65000
0x000494a0  ldr      d0, [x8, #0x600]
0x000494a4  str      d0, [sp, #0xe0]
0x000494a8  adrp     x8, #0x49000
0x000494ac  add      x8, x8, #0x968
0x000494b0  adrp     x9, #0x74000
0x000494b4  add      x9, x9, #0x6e0
0x000494b8  stp      x8, x9, [sp, #0xe8]
0x000494bc  mov      x0, x19
0x000494c0  bl       #0x55d84   ; CALL _objc_retain
0x000494c4  str      x19, [sp, #0xf8]
0x000494c8  adrp     x8, #0x65000
0x000494cc  ldr      d0, [x8, #0xba0]
0x000494d0  adrp     x8, #0x65000
0x000494d4  ldr      d1, [x8, #0x748]
0x000494d8  adrp     x8, #0x65000
0x000494dc  ldr      d2, [x8, #0x700]
0x000494e0  fmov     d3, xzr
0x000494e4  add      x3, sp, #0xd8
0x000494e8  mov      x0, x20
0x000494ec  mov      x2, #0
0x000494f0  mov      x4, #0
0x000494f4  bl       #0x56360   ; CALL objc_msgSend$animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
0x000494f8  ldr      x20, [sp, #0xf8]
0x000494fc  b        #0x49938
0x00049500  bl       #0x55808   ; CALL _CACurrentMediaTime
0x00049504  adrp     x8, #0x8f000
0x00049508  ldrsw    x8, [x8, #0x68]
0x0004950c  str      d0, [x20, x8]
0x00049510  adrp     x8, #0x8f000
0x00049514  ldrsw    x8, [x8, #0x6c]
0x00049518  mov      w9, #1
0x0004951c  strb     w9, [x20, x8]
0x00049520  adrp     x8, #0x8e000
0x00049524  ldrsw    x8, [x8, #0xffc]
0x00049528  ldr      x8, [x20, x8]
0x0004952c  tbnz     x8, #0x3f, #0x49544
0x00049530  fmov     d0, xzr
0x00049534  mov      x0, x20
0x00049538  bl       #0x5cf80   ; CALL objc_msgSend$ss_applyTime:
0x0004953c  mov      x0, x20
0x00049540  bl       #0x5d240   ; CALL objc_msgSend$ss_startLink
0x00049544  adrp     x8, #0x8f000
0x00049548  ldrsw    x8, [x8, #0xc]
0x0004954c  ldr      x19, [x20, x8]
0x00049550  cbz      x19, #0x49834
0x00049554  mov      x0, x19
0x00049558  bl       #0x55d84   ; CALL _objc_retain
0x0004955c  b        #0x4984c
0x00049560  mov      x0, x20
0x00049564  bl       #0x58e40   ; CALL objc_msgSend$logoEffect
0x00049568  cmp      x0, #2
0x0004956c  b.ne     #0x49798
0x00049570  adrp     x8, #0x74000
0x00049574  ldr      x8, [x8, #0x498]   ; @GOT _CGAffineTransformIdentity
0x00049578  ldp      q0, q1, [x8]
0x0004957c  stp      q0, q1, [x29, #-0xb0]
0x00049580  ldr      q0, [x8, #0x20]   ; @GOT _objc_autoreleasePoolPop
0x00049584  stur     q0, [x29, #-0x90]
0x00049588  sub      x2, x29, #0xb0
0x0004958c  mov      x0, x19
0x00049590  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x00049594  adrp     x8, #0x8e000
0x00049598  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0004959c  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x000495a0  mov      x29, x29
0x000495a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000495a8  mov      x20, x0
0x000495ac  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000495b0  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000495b4  mov      x21, x0
0x000495b8  mov      x0, x19
0x000495bc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000495c0  mov      x29, x29
0x000495c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000495c8  mov      x22, x0
0x000495cc  mov      x2, x21
0x000495d0  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x000495d4  mov      x0, x22
0x000495d8  bl       #0x55d78   ; CALL _objc_release
0x000495dc  mov      x0, x20
0x000495e0  bl       #0x55d78   ; CALL _objc_release
0x000495e4  adrp     x8, #0x74000
0x000495e8  ldr      x8, [x8, #0x618]   ; @GOT _CGSizeZero
0x000495ec  ldp      d8, d9, [x8]
0x000495f0  mov      x0, x19
0x000495f4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000495f8  mov      x29, x29
0x000495fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049600  mov      x20, x0
0x00049604  mov      v0.16b, v8.16b
0x00049608  mov      v1.16b, v9.16b
0x0004960c  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x00049610  mov      x0, x20
0x00049614  bl       #0x55d78   ; CALL _objc_release
0x00049618  fmov     d0, #7.00000000
0x0004961c  fmul     d8, d10, d0
0x00049620  mov      x0, x19
0x00049624  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00049628  mov      x29, x29
0x0004962c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049630  mov      x20, x0
0x00049634  mov      v0.16b, v8.16b
0x00049638  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x0004963c  mov      x0, x20
0x00049640  bl       #0x55d78   ; CALL _objc_release
0x00049644  mov      x0, x19
0x00049648  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004964c  mov      x29, x29
0x00049650  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049654  mov      x20, x0
0x00049658  adrp     x8, #0x66000
0x0004965c  ldr      s0, [x8, #0x2b8]
0x00049660  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x00049664  mov      x0, x20
0x00049668  bl       #0x55d78   ; CALL _objc_release
0x0004966c  adrp     x8, #0x8e000
0x00049670  ldr      x0, [x8, #0xbd8]   ; @CLASS CABasicAnimation
0x00049674  adrp     x2, #0x7d000
0x00049678  add      x2, x2, #0x3e8   ; STR "shadowOpacity"
0x0004967c  bl       #0x563a0   ; CALL objc_msgSend$animationWithKeyPath:
0x00049680  mov      x29, x29
0x00049684  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049688  mov      x20, x0
0x0004968c  adrp     x2, #0x80000
0x00049690  add      x2, x2, #0x738
0x00049694  bl       #0x5aee0   ; CALL objc_msgSend$setFromValue:
0x00049698  adrp     x2, #0x80000
0x0004969c  add      x2, x2, #0x748
0x000496a0  mov      x0, x20
0x000496a4  bl       #0x5c660   ; CALL objc_msgSend$setToValue:
0x000496a8  adrp     x8, #0x65000
0x000496ac  ldr      d0, [x8, #0x830]
0x000496b0  mov      x0, x20
0x000496b4  bl       #0x5ad40   ; CALL objc_msgSend$setDuration:
0x000496b8  mov      x0, x20
0x000496bc  mov      w2, #1
0x000496c0  bl       #0x5a520   ; CALL objc_msgSend$setAutoreverses:
0x000496c4  mov      w8, #0x7f800000
0x000496c8  fmov     s0, w8
0x000496cc  mov      x0, x20
0x000496d0  bl       #0x5bdc0   ; CALL objc_msgSend$setRepeatCount:
0x000496d4  adrp     x8, #0x8e000
0x000496d8  ldr      x0, [x8, #0xbe0]   ; @CLASS CAMediaTimingFunction
0x000496dc  adrp     x8, #0x74000
0x000496e0  ldr      x8, [x8, #0x698]   ; @GOT _kCAMediaTimingFunctionEaseInEaseOut
0x000496e4  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x000496e8  bl       #0x57d60   ; CALL objc_msgSend$functionWithName:
0x000496ec  mov      x29, x29
0x000496f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000496f4  mov      x21, x0
0x000496f8  mov      x0, x20
0x000496fc  mov      x2, x21
0x00049700  bl       #0x5c5a0   ; CALL objc_msgSend$setTimingFunction:
0x00049704  mov      x0, x21
0x00049708  bl       #0x55d78   ; CALL _objc_release
0x0004970c  mov      x0, x19
0x00049710  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00049714  mov      x29, x29
0x00049718  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004971c  mov      x21, x0
0x00049720  adrp     x3, #0x7d000
0x00049724  add      x3, x3, #0x408   ; STR "ssGlow"
0x00049728  mov      x2, x20
0x0004972c  bl       #0x56020   ; CALL objc_msgSend$addAnimation:forKey:
0x00049730  mov      x0, x21
0x00049734  bl       #0x55d78   ; CALL _objc_release
0x00049738  adrp     x8, #0x8e000
0x0004973c  ldr      x21, [x8, #0x918]   ; @CLASS UIView
0x00049740  adrp     x8, #0x74000
0x00049744  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x00049748  str      x8, [sp, #0xb0]
0x0004974c  adrp     x8, #0x65000
0x00049750  ldr      d0, [x8, #0x600]
0x00049754  str      d0, [sp, #0xb8]
0x00049758  adrp     x8, #0x49000
0x0004975c  add      x8, x8, #0x9bc
0x00049760  adrp     x9, #0x74000
0x00049764  add      x9, x9, #0x6e0
0x00049768  stp      x8, x9, [sp, #0xc0]
0x0004976c  mov      x0, x19
0x00049770  bl       #0x55d84   ; CALL _objc_retain
0x00049774  str      x19, [sp, #0xd0]
0x00049778  adrp     x8, #0x65000
0x0004977c  ldr      d0, [x8, #0x708]
0x00049780  add      x2, sp, #0xb0
0x00049784  mov      x0, x21
0x00049788  bl       #0x56320   ; CALL objc_msgSend$animateWithDuration:animations:
0x0004978c  ldr      x0, [sp, #0xd0]
0x00049790  bl       #0x55d78   ; CALL _objc_release
0x00049794  b        #0x49938
0x00049798  adrp     x8, #0x65000
0x0004979c  ldr      d0, [x8, #0xef0]
0x000497a0  add      x8, sp, #0x80
0x000497a4  mov      v1.16b, v0.16b
0x000497a8  bl       #0x5588c   ; CALL _CGAffineTransformMakeScale
0x000497ac  ldp      q0, q1, [sp, #0x80]
0x000497b0  stp      q0, q1, [x29, #-0xb0]
0x000497b4  ldr      q0, [sp, #0xa0]
0x000497b8  stur     q0, [x29, #-0x90]
0x000497bc  sub      x2, x29, #0xb0
0x000497c0  mov      x0, x19
0x000497c4  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x000497c8  adrp     x8, #0x8e000
0x000497cc  ldr      x20, [x8, #0x918]   ; @CLASS UIView
0x000497d0  adrp     x8, #0x74000
0x000497d4  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x000497d8  str      x8, [sp, #0x58]
0x000497dc  adrp     x8, #0x65000
0x000497e0  ldr      d0, [x8, #0x600]
0x000497e4  str      d0, [sp, #0x60]
0x000497e8  adrp     x8, #0x49000
0x000497ec  add      x8, x8, #0x9c8
0x000497f0  adrp     x9, #0x74000
0x000497f4  add      x9, x9, #0x6e0
0x000497f8  stp      x8, x9, [sp, #0x68]
0x000497fc  mov      x0, x19
0x00049800  bl       #0x55d84   ; CALL _objc_retain
0x00049804  str      x19, [sp, #0x78]
0x00049808  adrp     x8, #0x65000
0x0004980c  ldr      d0, [x8, #0x830]
0x00049810  adrp     x8, #0x65000
0x00049814  ldr      d1, [x8, #0xda0]
0x00049818  add      x3, sp, #0x58
0x0004981c  mov      x0, x20
0x00049820  mov      x2, #0
0x00049824  mov      x4, #0
0x00049828  bl       #0x56340   ; CALL objc_msgSend$animateWithDuration:delay:options:animations:completion:
0x0004982c  ldr      x20, [sp, #0x78]
0x00049830  b        #0x49938
0x00049834  adrp     x8, #0x8f000
0x00049838  ldrsw    x8, [x8, #0x14]
0x0004983c  ldr      x19, [x20, x8]
0x00049840  mov      x0, x19
0x00049844  bl       #0x55d84   ; CALL _objc_retain
0x00049848  cbz      x19, #0x49948
0x0004984c  mov      x0, x19
0x00049850  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00049854  mov      x29, x29
0x00049858  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004985c  mov      x20, x0
0x00049860  bl       #0x59d80   ; CALL objc_msgSend$removeAllAnimations
0x00049864  mov      x0, x20
0x00049868  bl       #0x55d78   ; CALL _objc_release
0x0004986c  fmov     d0, xzr
0x00049870  mov      x0, x19
0x00049874  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x00049878  fmov     d0, #6.00000000
0x0004987c  fmul     d1, d10, d0
0x00049880  sub      x8, x29, #0xb0
0x00049884  fmov     d0, xzr
0x00049888  bl       #0x55898   ; CALL _CGAffineTransformMakeTranslation
0x0004988c  adrp     x8, #0x65000
0x00049890  ldr      d0, [x8, #0x5f8]
0x00049894  add      x8, sp, #0x28
0x00049898  sub      x0, x29, #0xb0
0x0004989c  mov      v1.16b, v0.16b
0x000498a0  bl       #0x558a4   ; CALL _CGAffineTransformScale
0x000498a4  ldur     q0, [sp, #0x28]
0x000498a8  ldur     q1, [sp, #0x38]
0x000498ac  stp      q0, q1, [x29, #-0xb0]
0x000498b0  ldur     q0, [sp, #0x48]
0x000498b4  stur     q0, [x29, #-0x90]
0x000498b8  sub      x2, x29, #0xb0
0x000498bc  mov      x0, x19
0x000498c0  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x000498c4  adrp     x8, #0x8e000
0x000498c8  adrp     x9, #0x74000
0x000498cc  ldr      x9, [x9, #0x378]   ; @GOT __NSConcreteStackBlock
0x000498d0  ldr      x20, [x8, #0x918]   ; @CLASS UIView
0x000498d4  str      x9, [sp]
0x000498d8  adrp     x8, #0x65000
0x000498dc  ldr      d0, [x8, #0x600]
0x000498e0  adrp     x8, #0x49000
0x000498e4  add      x8, x8, #0xa1c
0x000498e8  str      d0, [sp, #8]
0x000498ec  adrp     x9, #0x74000
0x000498f0  add      x9, x9, #0x6e0
0x000498f4  stp      x8, x9, [sp, #0x10]
0x000498f8  str      x19, [sp, #0x20]
0x000498fc  mov      x0, x19
0x00049900  bl       #0x55d84   ; CALL _objc_retain
0x00049904  adrp     x8, #0x65000
0x00049908  ldr      d0, [x8, #0x708]
0x0004990c  adrp     x8, #0x65000
0x00049910  ldr      d1, [x8, #0xda0]
0x00049914  adrp     x8, #0x65000
0x00049918  ldr      d2, [x8, #0x6b0]
0x0004991c  fmov     d3, xzr
0x00049920  mov      x3, sp
0x00049924  mov      x0, x20
0x00049928  mov      x2, #0
0x0004992c  mov      x4, #0
0x00049930  bl       #0x56360   ; CALL objc_msgSend$animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
0x00049934  ldr      x20, [sp, #0x20]
0x00049938  mov      x0, x20
0x0004993c  bl       #0x55d78   ; CALL _objc_release
0x00049940  mov      x0, x19
0x00049944  bl       #0x55d78   ; CALL _objc_release
0x00049948  ldp      x29, x30, [sp, #0x1b0]
0x0004994c  ldp      x20, x19, [sp, #0x1a0]
0x00049950  ldp      x22, x21, [sp, #0x190]
0x00049954  ldp      x28, x27, [sp, #0x180]
0x00049958  ldp      d9, d8, [sp, #0x170]
0x0004995c  ldp      d11, d10, [sp, #0x160]
0x00049960  add      sp, sp, #0x1c0
0x00049964  ret      
0x00049968  sub      sp, sp, #0x50
0x0004996c  stp      x20, x19, [sp, #0x30]
0x00049970  stp      x29, x30, [sp, #0x40]
0x00049974  add      x29, sp, #0x40
0x00049978  mov      x19, x0
0x0004997c  ldr      x0, [x0, #0x20]
0x00049980  fmov     d0, #1.00000000
0x00049984  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x00049988  ldr      x0, [x19, #0x20]
0x0004998c  adrp     x8, #0x74000
0x00049990  ldr      x8, [x8, #0x498]   ; @GOT _CGAffineTransformIdentity
0x00049994  ldp      q0, q1, [x8]
0x00049998  stp      q0, q1, [sp]
0x0004999c  ldr      q0, [x8, #0x20]   ; @GOT _objc_autoreleasePoolPop
0x000499a0  str      q0, [sp, #0x20]
0x000499a4  mov      x2, sp
0x000499a8  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x000499ac  ldp      x29, x30, [sp, #0x40]
0x000499b0  ldp      x20, x19, [sp, #0x30]
0x000499b4  add      sp, sp, #0x50
0x000499b8  ret      
0x000499bc  ldr      x0, [x0, #0x20]
0x000499c0  fmov     d0, #1.00000000
0x000499c4  b        #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x000499c8  sub      sp, sp, #0x50
0x000499cc  stp      x20, x19, [sp, #0x30]
0x000499d0  stp      x29, x30, [sp, #0x40]
0x000499d4  add      x29, sp, #0x40
0x000499d8  mov      x19, x0
0x000499dc  ldr      x0, [x0, #0x20]
0x000499e0  fmov     d0, #1.00000000
0x000499e4  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x000499e8  ldr      x0, [x19, #0x20]
0x000499ec  adrp     x8, #0x74000
0x000499f0  ldr      x8, [x8, #0x498]   ; @GOT _CGAffineTransformIdentity
0x000499f4  ldp      q0, q1, [x8]
0x000499f8  stp      q0, q1, [sp]
0x000499fc  ldr      q0, [x8, #0x20]   ; @GOT _objc_autoreleasePoolPop
0x00049a00  str      q0, [sp, #0x20]
0x00049a04  mov      x2, sp
0x00049a08  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x00049a0c  ldp      x29, x30, [sp, #0x40]
0x00049a10  ldp      x20, x19, [sp, #0x30]
0x00049a14  add      sp, sp, #0x50
0x00049a18  ret      
0x00049a1c  sub      sp, sp, #0x50
0x00049a20  stp      x20, x19, [sp, #0x30]
0x00049a24  stp      x29, x30, [sp, #0x40]
0x00049a28  add      x29, sp, #0x40
0x00049a2c  mov      x19, x0
0x00049a30  ldr      x0, [x0, #0x20]
0x00049a34  fmov     d0, #1.00000000
0x00049a38  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x00049a3c  ldr      x0, [x19, #0x20]
0x00049a40  adrp     x8, #0x74000
0x00049a44  ldr      x8, [x8, #0x498]   ; @GOT _CGAffineTransformIdentity
0x00049a48  ldp      q0, q1, [x8]
0x00049a4c  stp      q0, q1, [sp]
0x00049a50  ldr      q0, [x8, #0x20]   ; @GOT _objc_autoreleasePoolPop
0x00049a54  str      q0, [sp, #0x20]
0x00049a58  mov      x2, sp
0x00049a5c  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x00049a60  ldp      x29, x30, [sp, #0x40]
0x00049a64  ldp      x20, x19, [sp, #0x30]
0x00049a68  add      sp, sp, #0x50
0x00049a6c  ret      

=== -[SSStartupView ss_now]  va=0x49a70 size=84 types=d16@0:8
0x00049a70  stp      x20, x19, [sp, #-0x20]!
0x00049a74  stp      x29, x30, [sp, #0x10]
0x00049a78  add      x29, sp, #0x10
0x00049a7c  mov      x19, x0
0x00049a80  adrp     x8, #0x8f000
0x00049a84  ldrsw    x8, [x8, #0x6c]
0x00049a88  ldrb     w8, [x0, x8]
0x00049a8c  cmp      w8, #1
0x00049a90  b.ne     #0x49aac
0x00049a94  bl       #0x55808   ; CALL _CACurrentMediaTime
0x00049a98  adrp     x8, #0x8f000
0x00049a9c  ldrsw    x8, [x8, #0x68]
0x00049aa0  ldr      d1, [x19, x8]
0x00049aa4  fsub     d0, d0, d1
0x00049aa8  b        #0x49ab8
0x00049aac  adrp     x8, #0x8f000
0x00049ab0  ldrsw    x8, [x8, #0x60]
0x00049ab4  ldr      d0, [x19, x8]
0x00049ab8  ldp      x29, x30, [sp, #0x10]
0x00049abc  ldp      x20, x19, [sp], #0x20
0x00049ac0  ret      

=== -[SSStartupView didMoveToWindow]  va=0x49ac4 size=108 types=v16@0:8
0x00049ac4  sub      sp, sp, #0x30
0x00049ac8  stp      x20, x19, [sp, #0x10]
0x00049acc  stp      x29, x30, [sp, #0x20]
0x00049ad0  add      x29, sp, #0x20
0x00049ad4  mov      x19, x0
0x00049ad8  adrp     x8, #0x8e000
0x00049adc  ldr      x8, [x8, #0xdb8]   ; @SUPER SSStartupView
0x00049ae0  stp      x0, x8, [sp]
0x00049ae4  adrp     x8, #0x8b000
0x00049ae8  ldr      x1, [x8, #0xf40]   ; @SEL "didMoveToWindow"
0x00049aec  mov      x0, sp
0x00049af0  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00049af4  mov      x0, x19
0x00049af8  bl       #0x5e1e0   ; CALL objc_msgSend$window
0x00049afc  mov      x29, x29
0x00049b00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049b04  mov      x20, x0
0x00049b08  bl       #0x55d78   ; CALL _objc_release
0x00049b0c  mov      x0, x19
0x00049b10  cbz      x20, #0x49b1c
0x00049b14  bl       #0x5d240   ; CALL objc_msgSend$ss_startLink
0x00049b18  b        #0x49b20
0x00049b1c  bl       #0x5d280   ; CALL objc_msgSend$ss_stopLink
0x00049b20  ldp      x29, x30, [sp, #0x20]
0x00049b24  ldp      x20, x19, [sp, #0x10]
0x00049b28  add      sp, sp, #0x30
0x00049b2c  ret      

=== -[SSStartupView ss_startLink]  va=0x49b30 size=392 types=v16@0:8
0x00049b30  stp      x24, x23, [sp, #-0x40]!
0x00049b34  stp      x22, x21, [sp, #0x10]
0x00049b38  stp      x20, x19, [sp, #0x20]
0x00049b3c  stp      x29, x30, [sp, #0x30]
0x00049b40  add      x29, sp, #0x30
0x00049b44  adrp     x8, #0x8f000
0x00049b48  ldrsw    x23, [x8]
0x00049b4c  ldr      x8, [x0, x23]
0x00049b50  cbnz     x8, #0x49bb0
0x00049b54  mov      x19, x0
0x00049b58  adrp     x8, #0x8f000
0x00049b5c  ldrsw    x8, [x8, #0x6c]
0x00049b60  ldrb     w8, [x0, x8]
0x00049b64  cmp      w8, #1
0x00049b68  b.ne     #0x49bb0
0x00049b6c  mov      x0, x19
0x00049b70  bl       #0x5e1e0   ; CALL objc_msgSend$window
0x00049b74  mov      x29, x29
0x00049b78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049b7c  cbz      x0, #0x49bb0
0x00049b80  adrp     x8, #0x8e000
0x00049b84  ldrsw    x8, [x8, #0xffc]
0x00049b88  ldr      x20, [x19, x8]
0x00049b8c  bl       #0x55d78   ; CALL _objc_release
0x00049b90  tbnz     x20, #0x3f, #0x49bb0
0x00049b94  mov      x0, x19
0x00049b98  bl       #0x5d1e0   ; CALL objc_msgSend$ss_now
0x00049b9c  adrp     x8, #0x8f000
0x00049ba0  ldrsw    x8, [x8, #0x5c]
0x00049ba4  ldr      d1, [x19, x8]
0x00049ba8  fcmp     d0, d1
0x00049bac  b.le     #0x49bc4
0x00049bb0  ldp      x29, x30, [sp, #0x30]
0x00049bb4  ldp      x20, x19, [sp, #0x20]
0x00049bb8  ldp      x22, x21, [sp, #0x10]
0x00049bbc  ldp      x24, x23, [sp], #0x40
0x00049bc0  ret      
0x00049bc4  adrp     x8, #0x8e000
0x00049bc8  ldr      x0, [x8, #0xcb0]   ; @CLASS SSLinkTarget
0x00049bcc  bl       #0x55d60   ; CALL _objc_opt_new
0x00049bd0  mov      x20, x0
0x00049bd4  mov      x2, x19
0x00049bd8  bl       #0x5ba80   ; CALL objc_msgSend$setOwner:
0x00049bdc  mov      x0, x19
0x00049be0  bl       #0x5e1e0   ; CALL objc_msgSend$window
0x00049be4  mov      x29, x29
0x00049be8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049bec  mov      x22, x0
0x00049bf0  bl       #0x5a100   ; CALL objc_msgSend$screen
0x00049bf4  mov      x29, x29
0x00049bf8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049bfc  mov      x21, x0
0x00049c00  mov      x0, x22
0x00049c04  bl       #0x55d78   ; CALL _objc_release
0x00049c08  adrp     x8, #0x8e000
0x00049c0c  ldr      x8, [x8, #0xcb8]   ; @CLASS CADisplayLink
0x00049c10  cmp      x21, #0
0x00049c14  csel     x0, x8, x21, eq
0x00049c18  adrp     x8, #0x8b000
0x00049c1c  ldr      x3, [x8, #0xf48]   ; @SEL "step:"
0x00049c20  mov      x2, x20
0x00049c24  bl       #0x57840   ; CALL objc_msgSend$displayLinkWithTarget:selector:
0x00049c28  mov      x29, x29
0x00049c2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049c30  ldr      x8, [x19, x23]
0x00049c34  str      x0, [x19, x23]
0x00049c38  mov      x0, x8
0x00049c3c  bl       #0x55d78   ; CALL _objc_release
0x00049c40  mov      w8, #0x42700000
0x00049c44  fmov     s1, w8
0x00049c48  fmov     s0, #30.00000000
0x00049c4c  mov      v2.16b, v1.16b
0x00049c50  bl       #0x55814   ; CALL _CAFrameRateRangeMake
0x00049c54  ldr      x0, [x19, x23]
0x00049c58  bl       #0x5bc40   ; CALL objc_msgSend$setPreferredFrameRateRange:
0x00049c5c  ldr      x19, [x19, x23]
0x00049c60  adrp     x8, #0x8e000
0x00049c64  ldr      x0, [x8, #0xcc0]   ; @CLASS NSRunLoop
0x00049c68  bl       #0x58ee0   ; CALL objc_msgSend$mainRunLoop
0x00049c6c  mov      x29, x29
0x00049c70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049c74  mov      x22, x0
0x00049c78  adrp     x8, #0x74000
0x00049c7c  ldr      x8, [x8, #0x190]   ; @GOT _NSRunLoopCommonModes
0x00049c80  ldr      x3, [x8]   ; @GOT ___objc_personality_v0
0x00049c84  mov      x0, x19
0x00049c88  mov      x2, x22
0x00049c8c  bl       #0x56220   ; CALL objc_msgSend$addToRunLoop:forMode:
0x00049c90  mov      x0, x22
0x00049c94  bl       #0x55d78   ; CALL _objc_release
0x00049c98  mov      x0, x21
0x00049c9c  bl       #0x55d78   ; CALL _objc_release
0x00049ca0  mov      x0, x20
0x00049ca4  ldp      x29, x30, [sp, #0x30]
0x00049ca8  ldp      x20, x19, [sp, #0x20]
0x00049cac  ldp      x22, x21, [sp, #0x10]
0x00049cb0  ldp      x24, x23, [sp], #0x40
0x00049cb4  b        #0x55d78   ; CALL _objc_release

=== -[SSStartupView ss_stopLink]  va=0x49cb8 size=52 types=v16@0:8
0x00049cb8  stp      x20, x19, [sp, #-0x20]!
0x00049cbc  stp      x29, x30, [sp, #0x10]
0x00049cc0  add      x29, sp, #0x10
0x00049cc4  mov      x19, x0
0x00049cc8  adrp     x8, #0x8f000
0x00049ccc  ldrsw    x20, [x8]
0x00049cd0  ldr      x0, [x0, x20]
0x00049cd4  bl       #0x58740   ; CALL objc_msgSend$invalidate
0x00049cd8  ldr      x0, [x19, x20]
0x00049cdc  str      xzr, [x19, x20]
0x00049ce0  ldp      x29, x30, [sp, #0x10]
0x00049ce4  ldp      x20, x19, [sp], #0x20
0x00049ce8  b        #0x55d78   ; CALL _objc_release

=== -[SSStartupView ss_step]  va=0x49cec size=140 types=v16@0:8
0x00049cec  stp      d9, d8, [sp, #-0x30]!
0x00049cf0  stp      x20, x19, [sp, #0x10]
0x00049cf4  stp      x29, x30, [sp, #0x20]
0x00049cf8  add      x29, sp, #0x20
0x00049cfc  mov      x19, x0
0x00049d00  bl       #0x5d1e0   ; CALL objc_msgSend$ss_now
0x00049d04  adrp     x8, #0x8e000
0x00049d08  ldrsw    x8, [x8, #0xffc]
0x00049d0c  ldr      x8, [x19, x8]
0x00049d10  tbnz     x8, #0x3f, #0x49d54
0x00049d14  mov      v8.16b, v0.16b
0x00049d18  mov      x0, x19
0x00049d1c  bl       #0x5e1e0   ; CALL objc_msgSend$window
0x00049d20  mov      x29, x29
0x00049d24  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049d28  mov      x20, x0
0x00049d2c  bl       #0x55d78   ; CALL _objc_release
0x00049d30  cbz      x20, #0x49d54
0x00049d34  mov      x0, x19
0x00049d38  mov      v0.16b, v8.16b
0x00049d3c  bl       #0x5cf80   ; CALL objc_msgSend$ss_applyTime:
0x00049d40  adrp     x8, #0x8f000
0x00049d44  ldrsw    x8, [x8, #0x5c]
0x00049d48  ldr      d0, [x19, x8]
0x00049d4c  fcmp     d8, d0
0x00049d50  b.le     #0x49d68
0x00049d54  mov      x0, x19
0x00049d58  ldp      x29, x30, [sp, #0x20]
0x00049d5c  ldp      x20, x19, [sp, #0x10]
0x00049d60  ldp      d9, d8, [sp], #0x30
0x00049d64  b        #0x5d280   ; CALL objc_msgSend$ss_stopLink
0x00049d68  ldp      x29, x30, [sp, #0x20]
0x00049d6c  ldp      x20, x19, [sp, #0x10]
0x00049d70  ldp      d9, d8, [sp], #0x30
0x00049d74  ret      

=== -[SSStartupView ss_applyTime:]  va=0x49d78 size=468 types=v24@0:8d16
0x00049d78  sub      sp, sp, #0x130
0x00049d7c  stp      d9, d8, [sp, #0xd0]
0x00049d80  stp      x28, x27, [sp, #0xe0]
0x00049d84  stp      x24, x23, [sp, #0xf0]
0x00049d88  stp      x22, x21, [sp, #0x100]
0x00049d8c  stp      x20, x19, [sp, #0x110]
0x00049d90  stp      x29, x30, [sp, #0x120]
0x00049d94  add      x29, sp, #0x120
0x00049d98  adrp     x8, #0x74000
0x00049d9c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00049da0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00049da4  stur     x8, [x29, #-0x58]
0x00049da8  adrp     x8, #0x8f000
0x00049dac  ldrsw    x8, [x8, #0x70]
0x00049db0  ldrb     w8, [x0, x8]
0x00049db4  cmp      w8, #1
0x00049db8  b.ne     #0x49f10
0x00049dbc  mov      v8.16b, v0.16b
0x00049dc0  mov      x19, x0
0x00049dc4  adrp     x22, #0x8e000
0x00049dc8  ldr      x0, [x22, #0xab8]   ; @CLASS CATransaction
0x00049dcc  bl       #0x567a0   ; CALL objc_msgSend$begin
0x00049dd0  ldr      x0, [x22, #0xab8]   ; @CLASS CATransaction
0x00049dd4  mov      w2, #1
0x00049dd8  bl       #0x5ad00   ; CALL objc_msgSend$setDisableActions:
0x00049ddc  movi     v0.16b, #0
0x00049de0  stp      q0, q0, [sp, #0x20]
0x00049de4  stp      q0, q0, [sp]
0x00049de8  adrp     x8, #0x8f000
0x00049dec  ldrsw    x8, [x8, #0x74]
0x00049df0  ldr      x20, [x19, x8]
0x00049df4  mov      x0, x20
0x00049df8  bl       #0x55d84   ; CALL _objc_retain
0x00049dfc  mov      x2, sp
0x00049e00  add      x3, sp, #0x48
0x00049e04  mov      x0, x20
0x00049e08  mov      w4, #0x10
0x00049e0c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00049e10  cbz      x0, #0x49e74
0x00049e14  mov      x21, x0
0x00049e18  ldr      x8, [sp, #0x10]
0x00049e1c  ldr      x23, [x8]
0x00049e20  mov      x24, #0
0x00049e24  ldr      x8, [sp, #0x10]
0x00049e28  ldr      x8, [x8]
0x00049e2c  cmp      x8, x23
0x00049e30  b.eq     #0x49e3c
0x00049e34  mov      x0, x20
0x00049e38  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00049e3c  ldr      x8, [sp, #8]
0x00049e40  ldr      x0, [x8, x24, lsl #3]
0x00049e44  mov      v0.16b, v8.16b
0x00049e48  bl       #0x56540   ; CALL objc_msgSend$applyTime:
0x00049e4c  add      x24, x24, #1
0x00049e50  cmp      x21, x24
0x00049e54  b.ne     #0x49e24
0x00049e58  mov      x2, sp
0x00049e5c  add      x3, sp, #0x48
0x00049e60  mov      x0, x20
0x00049e64  mov      w4, #0x10
0x00049e68  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00049e6c  mov      x21, x0
0x00049e70  cbnz     x0, #0x49e20
0x00049e74  mov      x0, x20
0x00049e78  bl       #0x55d78   ; CALL _objc_release
0x00049e7c  mov      x0, x19
0x00049e80  mov      v0.16b, v8.16b
0x00049e84  bl       #0x5cf40   ; CALL objc_msgSend$ss_applyMotes:
0x00049e88  adrp     x8, #0x8e000
0x00049e8c  ldrsw    x8, [x8, #0xffc]
0x00049e90  ldr      x8, [x19, x8]
0x00049e94  cmp      x8, #4
0x00049e98  b.gt     #0x49ebc
0x00049e9c  cmp      x8, #3
0x00049ea0  b.eq     #0x49edc
0x00049ea4  cmp      x8, #4
0x00049ea8  b.ne     #0x49ef8
0x00049eac  mov      x0, x19
0x00049eb0  mov      v0.16b, v8.16b
0x00049eb4  bl       #0x5cf00   ; CALL objc_msgSend$ss_applyEngine:
0x00049eb8  b        #0x49ef8
0x00049ebc  cmp      x8, #5
0x00049ec0  b.eq     #0x49eec
0x00049ec4  cmp      x8, #7
0x00049ec8  b.ne     #0x49ef8
0x00049ecc  mov      x0, x19
0x00049ed0  mov      v0.16b, v8.16b
0x00049ed4  bl       #0x5cf20   ; CALL objc_msgSend$ss_applyHud:
0x00049ed8  b        #0x49ef8
0x00049edc  mov      x0, x19
0x00049ee0  mov      v0.16b, v8.16b
0x00049ee4  bl       #0x5cf60   ; CALL objc_msgSend$ss_applySky:
0x00049ee8  b        #0x49ef8
0x00049eec  mov      x0, x19
0x00049ef0  mov      v0.16b, v8.16b
0x00049ef4  bl       #0x5cfa0   ; CALL objc_msgSend$ss_applyWelcome:
0x00049ef8  adrp     x8, #0x8f000
0x00049efc  ldrsw    x8, [x8, #0x78]
0x00049f00  ldr      x0, [x19, x8]
0x00049f04  bl       #0x5b780   ; CALL objc_msgSend$setNeedsDisplay
0x00049f08  ldr      x0, [x22, #0xab8]   ; @CLASS CATransaction
0x00049f0c  bl       #0x56f40   ; CALL objc_msgSend$commit
0x00049f10  ldur     x8, [x29, #-0x58]
0x00049f14  adrp     x9, #0x74000
0x00049f18  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00049f1c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00049f20  cmp      x9, x8
0x00049f24  b.ne     #0x49f48
0x00049f28  ldp      x29, x30, [sp, #0x120]
0x00049f2c  ldp      x20, x19, [sp, #0x110]
0x00049f30  ldp      x22, x21, [sp, #0x100]
0x00049f34  ldp      x24, x23, [sp, #0xf0]
0x00049f38  ldp      x28, x27, [sp, #0xe0]
0x00049f3c  ldp      d9, d8, [sp, #0xd0]
0x00049f40  add      sp, sp, #0x130
0x00049f44  ret      
0x00049f48  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[SSStartupView ss_clearScene]  va=0x49f4c size=608 types=v16@0:8
0x00049f4c  stp      x22, x21, [sp, #-0x30]!
0x00049f50  stp      x20, x19, [sp, #0x10]
0x00049f54  stp      x29, x30, [sp, #0x20]
0x00049f58  add      x29, sp, #0x20
0x00049f5c  mov      x19, x0
0x00049f60  bl       #0x5d280   ; CALL objc_msgSend$ss_stopLink
0x00049f64  adrp     x8, #0x8f000
0x00049f68  ldrsw    x20, [x8, #0x7c]
0x00049f6c  ldr      x0, [x19, x20]
0x00049f70  bl       #0x59e00   ; CALL objc_msgSend$removeFromSuperview
0x00049f74  adrp     x8, #0x8f000
0x00049f78  ldrsw    x21, [x8, #0x80]
0x00049f7c  ldr      x0, [x19, x21]
0x00049f80  bl       #0x59e00   ; CALL objc_msgSend$removeFromSuperview
0x00049f84  ldr      x0, [x19, x21]
0x00049f88  str      xzr, [x19, x21]
0x00049f8c  bl       #0x55d78   ; CALL _objc_release
0x00049f90  ldr      x0, [x19, x20]
0x00049f94  str      xzr, [x19, x20]
0x00049f98  bl       #0x55d78   ; CALL _objc_release
0x00049f9c  adrp     x8, #0x8f000
0x00049fa0  ldrsw    x8, [x8, #0x78]
0x00049fa4  ldr      x0, [x19, x8]
0x00049fa8  str      xzr, [x19, x8]
0x00049fac  bl       #0x55d78   ; CALL _objc_release
0x00049fb0  adrp     x20, #0x8e000
0x00049fb4  ldr      x0, [x20, #0x988]   ; @CLASS NSMutableArray
0x00049fb8  bl       #0x565c0   ; CALL objc_msgSend$array
0x00049fbc  mov      x29, x29
0x00049fc0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049fc4  adrp     x8, #0x8f000
0x00049fc8  ldrsw    x9, [x8, #0x74]
0x00049fcc  ldr      x8, [x19, x9]
0x00049fd0  str      x0, [x19, x9]
0x00049fd4  mov      x0, x8
0x00049fd8  bl       #0x55d78   ; CALL _objc_release
0x00049fdc  adrp     x8, #0x8e000
0x00049fe0  ldr      x0, [x8, #0xc10]   ; @CLASS NSMutableData
0x00049fe4  bl       #0x57540   ; CALL objc_msgSend$data
0x00049fe8  mov      x29, x29
0x00049fec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00049ff0  adrp     x8, #0x8f000
0x00049ff4  ldrsw    x9, [x8, #0x84]
0x00049ff8  ldr      x8, [x19, x9]
0x00049ffc  str      x0, [x19, x9]
0x0004a000  mov      x0, x8
0x0004a004  bl       #0x55d78   ; CALL _objc_release
0x0004a008  ldr      x0, [x20, #0x988]   ; @CLASS NSMutableArray
0x0004a00c  bl       #0x565c0   ; CALL objc_msgSend$array
0x0004a010  mov      x29, x29
0x0004a014  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004a018  adrp     x8, #0x8f000
0x0004a01c  ldrsw    x9, [x8, #0x88]
0x0004a020  ldr      x8, [x19, x9]
0x0004a024  str      x0, [x19, x9]
0x0004a028  mov      x0, x8
0x0004a02c  bl       #0x55d78   ; CALL _objc_release
0x0004a030  ldr      x0, [x20, #0x988]   ; @CLASS NSMutableArray
0x0004a034  bl       #0x565c0   ; CALL objc_msgSend$array
0x0004a038  mov      x29, x29
0x0004a03c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004a040  adrp     x8, #0x8f000
0x0004a044  ldrsw    x9, [x8, #0x8c]
0x0004a048  ldr      x8, [x19, x9]
0x0004a04c  str      x0, [x19, x9]
0x0004a050  mov      x0, x8
0x0004a054  bl       #0x55d78   ; CALL _objc_release
0x0004a058  ldr      x0, [x20, #0x988]   ; @CLASS NSMutableArray
0x0004a05c  bl       #0x565c0   ; CALL objc_msgSend$array
0x0004a060  mov      x29, x29
0x0004a064  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004a068  adrp     x8, #0x8f000
0x0004a06c  ldrsw    x9, [x8, #0x90]
0x0004a070  ldr      x8, [x19, x9]
0x0004a074  str      x0, [x19, x9]
0x0004a078  mov      x0, x8
0x0004a07c  bl       #0x55d78   ; CALL _objc_release
0x0004a080  adrp     x8, #0x8f000
0x0004a084  ldrsw    x8, [x8, #0x94]
0x0004a088  ldr      x0, [x19, x8]
0x0004a08c  str      xzr, [x19, x8]
0x0004a090  bl       #0x55d78   ; CALL _objc_release
0x0004a094  adrp     x8, #0x8f000
0x0004a098  ldrsw    x8, [x8, #0x98]
0x0004a09c  ldr      x0, [x19, x8]
0x0004a0a0  str      xzr, [x19, x8]
0x0004a0a4  bl       #0x55d78   ; CALL _objc_release
0x0004a0a8  adrp     x8, #0x8f000
0x0004a0ac  ldrsw    x8, [x8, #0x9c]
0x0004a0b0  ldr      x0, [x19, x8]
0x0004a0b4  str      xzr, [x19, x8]
0x0004a0b8  bl       #0x55d78   ; CALL _objc_release
0x0004a0bc  adrp     x8, #0x8f000
0x0004a0c0  ldrsw    x8, [x8, #0xa0]
0x0004a0c4  ldr      x0, [x19, x8]
0x0004a0c8  str      xzr, [x19, x8]
0x0004a0cc  bl       #0x55d78   ; CALL _objc_release
0x0004a0d0  adrp     x8, #0x8f000
0x0004a0d4  ldrsw    x8, [x8, #0xa4]
0x0004a0d8  ldr      x0, [x19, x8]
0x0004a0dc  str      xzr, [x19, x8]
0x0004a0e0  bl       #0x55d78   ; CALL _objc_release
0x0004a0e4  adrp     x8, #0x8f000
0x0004a0e8  ldrsw    x8, [x8, #0xa8]
0x0004a0ec  ldr      x0, [x19, x8]
0x0004a0f0  str      xzr, [x19, x8]
0x0004a0f4  bl       #0x55d78   ; CALL _objc_release
0x0004a0f8  adrp     x8, #0x8f000
0x0004a0fc  ldrsw    x8, [x8, #0xac]
0x0004a100  ldr      x0, [x19, x8]
0x0004a104  str      xzr, [x19, x8]
0x0004a108  bl       #0x55d78   ; CALL _objc_release
0x0004a10c  adrp     x8, #0x8f000
0x0004a110  ldrsw    x8, [x8, #0xb0]
0x0004a114  ldr      x0, [x19, x8]
0x0004a118  str      xzr, [x19, x8]
0x0004a11c  bl       #0x55d78   ; CALL _objc_release
0x0004a120  adrp     x8, #0x8f000
0x0004a124  ldrsw    x8, [x8, #0xb4]
0x0004a128  ldr      x0, [x19, x8]
0x0004a12c  str      xzr, [x19, x8]
0x0004a130  bl       #0x55d78   ; CALL _objc_release
0x0004a134  adrp     x8, #0x8f000
0x0004a138  ldrsw    x8, [x8, #0xb8]
0x0004a13c  ldr      x0, [x19, x8]
0x0004a140  str      xzr, [x19, x8]
0x0004a144  bl       #0x55d78   ; CALL _objc_release
0x0004a148  adrp     x8, #0x8f000
0x0004a14c  ldrsw    x8, [x8, #0xbc]
0x0004a150  ldr      x0, [x19, x8]
0x0004a154  str      xzr, [x19, x8]
0x0004a158  bl       #0x55d78   ; CALL _objc_release
0x0004a15c  adrp     x8, #0x8f000
0x0004a160  ldrsw    x8, [x8, #0xc0]
0x0004a164  mov      x9, #-0x4010000000000000
0x0004a168  str      x9, [x19, x8]
0x0004a16c  adrp     x8, #0x8f000
0x0004a170  ldrsw    x8, [x8, #0xc4]
0x0004a174  ldr      x0, [x19, x8]
0x0004a178  str      xzr, [x19, x8]
0x0004a17c  bl       #0x55d78   ; CALL _objc_release
0x0004a180  adrp     x8, #0x8f000
0x0004a184  ldrsw    x8, [x8, #0xc8]
0x0004a188  mov      x9, #-1
0x0004a18c  str      x9, [x19, x8]
0x0004a190  adrp     x8, #0x8f000
0x0004a194  ldrsw    x8, [x8, #0x70]
0x0004a198  strb     wzr, [x19, x8]
0x0004a19c  ldp      x29, x30, [sp, #0x20]
0x0004a1a0  ldp      x20, x19, [sp, #0x10]
0x0004a1a4  ldp      x22, x21, [sp], #0x30
0x0004a1a8  ret      

=== -[SSStartupView ss_buildScene]  va=0x4a1ac size=540 types=v16@0:8
0x0004a1ac  stp      x22, x21, [sp, #-0x30]!
0x0004a1b0  stp      x20, x19, [sp, #0x10]
0x0004a1b4  stp      x29, x30, [sp, #0x20]
0x0004a1b8  add      x29, sp, #0x20
0x0004a1bc  mov      x19, x0
0x0004a1c0  adrp     x8, #0x8f000
0x0004a1c4  ldrsw    x8, [x8, #0x6c]
0x0004a1c8  ldrb     w21, [x0, x8]
0x0004a1cc  bl       #0x5d0e0   ; CALL objc_msgSend$ss_clearScene
0x0004a1d0  mov      x0, x19
0x0004a1d4  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0004a1d8  adrp     x8, #0x8f000
0x0004a1dc  ldrsw    x8, [x8, #0x54]
0x0004a1e0  add      x8, x19, x8
0x0004a1e4  stp      d2, d3, [x8]
0x0004a1e8  mov      x8, #0x4059000000000000
0x0004a1ec  fmov     d0, x8
0x0004a1f0  fdiv     d0, d3, d0
0x0004a1f4  adrp     x8, #0x65000
0x0004a1f8  ldr      d1, [x8, #0xed8]
0x0004a1fc  fdiv     d1, d2, d1
0x0004a200  fcmp     d0, d1
0x0004a204  fcsel    d0, d0, d1, mi
0x0004a208  adrp     x8, #0x8e000
0x0004a20c  ldrsw    x22, [x8, #0xffc]
0x0004a210  ldr      x8, [x19, x22]
0x0004a214  tbnz     x8, #0x3f, #0x4a3b8
0x0004a218  fcmp     d0, #0.0
0x0004a21c  b.ls     #0x4a3b8
0x0004a220  fmov     d1, #6.00000000
0x0004a224  fdiv     d0, d0, d1
0x0004a228  adrp     x8, #0x8f000
0x0004a22c  ldrsw    x8, [x8, #0xcc]
0x0004a230  str      d0, [x19, x8]
0x0004a234  mov      x9, #-0x3f67000000000000
0x0004a238  fmov     d1, x9
0x0004a23c  fmadd    d0, d0, d1, d2
0x0004a240  fmov     d1, #0.50000000
0x0004a244  fmul     d0, d0, d1
0x0004a248  adrp     x9, #0x8f000
0x0004a24c  ldrsw    x9, [x9, #0xd0]
0x0004a250  str      d0, [x19, x9]
0x0004a254  ldr      d0, [x19, x8]
0x0004a258  adrp     x8, #0x65000
0x0004a25c  ldr      d2, [x8, #0xef8]
0x0004a260  fmadd    d0, d0, d2, d3
0x0004a264  fmul     d0, d0, d1
0x0004a268  adrp     x8, #0x8f000
0x0004a26c  ldrsw    x8, [x8, #0xd4]
0x0004a270  str      d0, [x19, x8]
0x0004a274  adrp     x8, #0x8e000
0x0004a278  ldr      x0, [x8, #0x918]   ; @CLASS UIView
0x0004a27c  bl       #0x55c7c   ; CALL _objc_alloc
0x0004a280  mov      x20, x0
0x0004a284  mov      x0, x19
0x0004a288  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0004a28c  mov      x0, x20
0x0004a290  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0004a294  adrp     x8, #0x8f000
0x0004a298  ldrsw    x20, [x8, #0x7c]
0x0004a29c  ldr      x8, [x19, x20]
0x0004a2a0  str      x0, [x19, x20]
0x0004a2a4  mov      x0, x8
0x0004a2a8  bl       #0x55d78   ; CALL _objc_release
0x0004a2ac  ldr      x0, [x19, x20]
0x0004a2b0  mov      w2, #0
0x0004a2b4  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x0004a2b8  ldr      x2, [x19, x20]
0x0004a2bc  mov      x0, x19
0x0004a2c0  mov      x3, #0
0x0004a2c4  bl       #0x586a0   ; CALL objc_msgSend$insertSubview:atIndex:
0x0004a2c8  ldr      x8, [x19, x22]
0x0004a2cc  cmp      x8, #6
0x0004a2d0  b.gt     #0x4a2f8
0x0004a2d4  cmp      x8, #4
0x0004a2d8  b.gt     #0x4a31c
0x0004a2dc  cmp      x8, #3
0x0004a2e0  b.eq     #0x4a354
0x0004a2e4  cmp      x8, #4
0x0004a2e8  b.ne     #0x4a380
0x0004a2ec  mov      x0, x19
0x0004a2f0  bl       #0x5cfe0   ; CALL objc_msgSend$ss_buildEngine
0x0004a2f4  b        #0x4a380
0x0004a2f8  cmp      x8, #8
0x0004a2fc  b.gt     #0x4a338
0x0004a300  cmp      x8, #7
0x0004a304  b.eq     #0x4a360
0x0004a308  cmp      x8, #8
0x0004a30c  b.ne     #0x4a380
0x0004a310  mov      x0, x19
0x0004a314  bl       #0x5cfc0   ; CALL objc_msgSend$ss_buildBriefing
0x0004a318  b        #0x4a380
0x0004a31c  cmp      x8, #5
0x0004a320  b.eq     #0x4a36c
0x0004a324  cmp      x8, #6
0x0004a328  b.ne     #0x4a380
0x0004a32c  mov      x0, x19
0x0004a330  bl       #0x5d060   ; CALL objc_msgSend$ss_buildParticles
0x0004a334  b        #0x4a380
0x0004a338  cmp      x8, #9
0x0004a33c  b.eq     #0x4a378
0x0004a340  cmp      x8, #0xb
0x0004a344  b.ne     #0x4a380
0x0004a348  mov      x0, x19
0x0004a34c  bl       #0x5d000   ; CALL objc_msgSend$ss_buildFestive
0x0004a350  b        #0x4a380
0x0004a354  mov      x0, x19
0x0004a358  bl       #0x5d0a0   ; CALL objc_msgSend$ss_buildSky
0x0004a35c  b        #0x4a380
0x0004a360  mov      x0, x19
0x0004a364  bl       #0x5d020   ; CALL objc_msgSend$ss_buildHud
0x0004a368  b        #0x4a380
0x0004a36c  mov      x0, x19
0x0004a370  bl       #0x5d0c0   ; CALL objc_msgSend$ss_buildWelcome
0x0004a374  b        #0x4a380
0x0004a378  mov      x0, x19
0x0004a37c  bl       #0x5d040   ; CALL objc_msgSend$ss_buildLiquid
0x0004a380  adrp     x8, #0x8f000
0x0004a384  ldrsw    x8, [x8, #0x70]
0x0004a388  mov      w9, #1
0x0004a38c  strb     w9, [x19, x8]
0x0004a390  mov      x0, x19
0x0004a394  bl       #0x5d1e0   ; CALL objc_msgSend$ss_now
0x0004a398  mov      x0, x19
0x0004a39c  bl       #0x5cf80   ; CALL objc_msgSend$ss_applyTime:
0x0004a3a0  cbz      w21, #0x4a3b8
0x0004a3a4  mov      x0, x19
0x0004a3a8  ldp      x29, x30, [sp, #0x20]
0x0004a3ac  ldp      x20, x19, [sp, #0x10]
0x0004a3b0  ldp      x22, x21, [sp], #0x30
0x0004a3b4  b        #0x5d240   ; CALL objc_msgSend$ss_startLink
0x0004a3b8  ldp      x29, x30, [sp, #0x20]
0x0004a3bc  ldp      x20, x19, [sp, #0x10]
0x0004a3c0  ldp      x22, x21, [sp], #0x30
0x0004a3c4  ret      

=== -[SSStartupView ss_host]  va=0x4a3c8 size=104 types=@16@0:8
0x0004a3c8  stp      x22, x21, [sp, #-0x30]!
0x0004a3cc  stp      x20, x19, [sp, #0x10]
0x0004a3d0  stp      x29, x30, [sp, #0x20]
0x0004a3d4  add      x29, sp, #0x20
0x0004a3d8  mov      x19, x0
0x0004a3dc  adrp     x8, #0x8e000
0x0004a3e0  ldr      x0, [x8, #0x918]   ; @CLASS UIView
0x0004a3e4  bl       #0x55c7c   ; CALL _objc_alloc
0x0004a3e8  mov      x20, x0
0x0004a3ec  adrp     x8, #0x8f000
0x0004a3f0  ldrsw    x21, [x8, #0x7c]
0x0004a3f4  ldr      x0, [x19, x21]
0x0004a3f8  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0004a3fc  mov      x0, x20
0x0004a400  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0004a404  mov      x20, x0
0x0004a408  mov      w2, #0
0x0004a40c  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x0004a410  ldr      x0, [x19, x21]
0x0004a414  mov      x2, x20
0x0004a418  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0004a41c  mov      x0, x20
0x0004a420  ldp      x29, x30, [sp, #0x20]
0x0004a424  ldp      x20, x19, [sp, #0x10]
0x0004a428  ldp      x22, x21, [sp], #0x30
0x0004a42c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[SSStartupView ss_addCanvas]  va=0x4a430 size=212 types=v16@0:8
0x0004a430  stp      x22, x21, [sp, #-0x30]!
0x0004a434  stp      x20, x19, [sp, #0x10]
0x0004a438  stp      x29, x30, [sp, #0x20]
0x0004a43c  add      x29, sp, #0x20
0x0004a440  mov      x19, x0
0x0004a444  adrp     x8, #0x8e000
0x0004a448  ldr      x0, [x8, #0xcc8]   ; @CLASS SSCanvasView
0x0004a44c  bl       #0x55c7c   ; CALL _objc_alloc
0x0004a450  mov      x20, x0
0x0004a454  adrp     x8, #0x8f000
0x0004a458  ldrsw    x21, [x8, #0x7c]
0x0004a45c  ldr      x0, [x19, x21]
0x0004a460  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0004a464  mov      x0, x20
0x0004a468  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0004a46c  adrp     x8, #0x8f000
0x0004a470  ldrsw    x22, [x8, #0x78]
0x0004a474  ldr      x8, [x19, x22]
0x0004a478  str      x0, [x19, x22]
0x0004a47c  mov      x0, x8
0x0004a480  bl       #0x55d78   ; CALL _objc_release
0x0004a484  ldr      x0, [x19, x22]
0x0004a488  mov      x2, x19
0x0004a48c  bl       #0x5ba80   ; CALL objc_msgSend$setOwner:
0x0004a490  ldr      x0, [x19, x22]
0x0004a494  mov      w2, #0
0x0004a498  bl       #0x5b960   ; CALL objc_msgSend$setOpaque:
0x0004a49c  adrp     x8, #0x8e000
0x0004a4a0  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0004a4a4  bl       #0x56de0   ; CALL objc_msgSend$clearColor
0x0004a4a8  mov      x29, x29
0x0004a4ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004a4b0  mov      x20, x0
0x0004a4b4  ldr      x0, [x19, x22]
0x0004a4b8  mov      x2, x20
0x0004a4bc  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0004a4c0  mov      x0, x20
0x0004a4c4  bl       #0x55d78   ; CALL _objc_release
0x0004a4c8  ldr      x0, [x19, x22]
0x0004a4cc  mov      w2, #0
0x0004a4d0  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x0004a4d4  ldr      x0, [x19, x22]
0x0004a4d8  fmov     d0, #1.00000000
0x0004a4dc  bl       #0x5aaa0   ; CALL objc_msgSend$setContentScaleFactor:
0x0004a4e0  ldr      x0, [x19, x22]
0x0004a4e4  mov      w2, #3
0x0004a4e8  bl       #0x5aa40   ; CALL objc_msgSend$setContentMode:
0x0004a4ec  ldr      x0, [x19, x21]
0x0004a4f0  ldr      x2, [x19, x22]
0x0004a4f4  ldp      x29, x30, [sp, #0x20]
0x0004a4f8  ldp      x20, x19, [sp, #0x10]
0x0004a4fc  ldp      x22, x21, [sp], #0x30
0x0004a500  b        #0x561e0   ; CALL objc_msgSend$addSubview:

=== -[SSStartupView ss_label:at:size:weight:color:left:in:maxWidth:]  va=0x4a504 size=748 types=@84@0:8@16{CGPoint=dd}24d40d48@56B64@68d76
0x0004a504  stp      d13, d12, [sp, #-0x80]!
0x0004a508  stp      d11, d10, [sp, #0x10]
0x0004a50c  stp      d9, d8, [sp, #0x20]
0x0004a510  stp      x26, x25, [sp, #0x30]
0x0004a514  stp      x24, x23, [sp, #0x40]
0x0004a518  stp      x22, x21, [sp, #0x50]
0x0004a51c  stp      x20, x19, [sp, #0x60]
0x0004a520  stp      x29, x30, [sp, #0x70]
0x0004a524  add      x29, sp, #0x70
0x0004a528  mov      v10.16b, v4.16b
0x0004a52c  mov      x20, x5
0x0004a530  mov      x22, x4
0x0004a534  mov      x19, x3
0x0004a538  mov      v11.16b, v3.16b
0x0004a53c  mov      v12.16b, v2.16b
0x0004a540  mov      v8.16b, v1.16b
0x0004a544  mov      v9.16b, v0.16b
0x0004a548  mov      x21, x2
0x0004a54c  mov      x23, x0
0x0004a550  mov      x0, x3
0x0004a554  bl       #0x55d84   ; CALL _objc_retain
0x0004a558  mov      x0, x20
0x0004a55c  bl       #0x55d84   ; CALL _objc_retain
0x0004a560  mov      x0, x21
0x0004a564  bl       #0x47664
0x0004a568  mov      x29, x29
0x0004a56c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004a570  mov      x21, x0
0x0004a574  adrp     x8, #0x8f000
0x0004a578  ldrsw    x25, [x8, #0xcc]
0x0004a57c  ldr      d0, [x23, x25]
0x0004a580  fmul     d0, d12, d0
0x0004a584  fmov     d1, #1.00000000
0x0004a588  fmaxnm   d0, d0, d1
0x0004a58c  mov      v1.16b, v11.16b
0x0004a590  bl       #0x492e8
0x0004a594  mov      x29, x29
0x0004a598  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004a59c  mov      x24, x0
0x0004a5a0  mov      x0, x21
0x0004a5a4  mov      x2, x24
0x0004a5a8  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x0004a5ac  mov      x0, x24
0x0004a5b0  bl       #0x55d78   ; CALL _objc_release
0x0004a5b4  cbz      x19, #0x4a5c8
0x0004a5b8  mov      x0, x21
0x0004a5bc  mov      x2, x19
0x0004a5c0  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0004a5c4  b        #0x4a5f4
0x0004a5c8  adrp     x8, #0x8e000
0x0004a5cc  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0004a5d0  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0004a5d4  mov      x29, x29
0x0004a5d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004a5dc  mov      x24, x0
0x0004a5e0  mov      x0, x21
0x0004a5e4  mov      x2, x24
0x0004a5e8  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0004a5ec  mov      x0, x24
0x0004a5f0  bl       #0x55d78   ; CALL _objc_release
0x0004a5f4  eor      w2, w22, #1
0x0004a5f8  mov      x0, x21
0x0004a5fc  bl       #0x5c4e0   ; CALL objc_msgSend$setTextAlignment:
0x0004a600  mov      x0, x21
0x0004a604  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004a608  mov      x29, x29
0x0004a60c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004a610  mov      x24, x0
0x0004a614  adrp     x8, #0x65000
0x0004a618  ldr      s0, [x8, #0xd04]
0x0004a61c  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x0004a620  mov      x0, x24
0x0004a624  bl       #0x55d78   ; CALL _objc_release
0x0004a628  ldr      d0, [x23, x25]
0x0004a62c  fmov     d1, #7.00000000
0x0004a630  fmul     d0, d0, d1
0x0004a634  fmov     d1, #1.00000000
0x0004a638  fmaxnm   d11, d0, d1
0x0004a63c  mov      x0, x21
0x0004a640  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004a644  mov      x29, x29
0x0004a648  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004a64c  mov      x24, x0
0x0004a650  mov      v0.16b, v11.16b
0x0004a654  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x0004a658  mov      x0, x24
0x0004a65c  bl       #0x55d78   ; CALL _objc_release
0x0004a660  adrp     x8, #0x74000
0x0004a664  ldr      x8, [x8, #0x618]   ; @GOT _CGSizeZero
0x0004a668  ldp      d11, d12, [x8]
0x0004a66c  mov      x0, x21
0x0004a670  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004a674  mov      x29, x29
0x0004a678  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004a67c  mov      x24, x0
0x0004a680  mov      v0.16b, v11.16b
0x0004a684  mov      v1.16b, v12.16b
0x0004a688  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x0004a68c  mov      x0, x24
0x0004a690  bl       #0x55d78   ; CALL _objc_release
0x0004a694  mov      x0, x23
0x0004a698  bl       #0x5dc60   ; CALL objc_msgSend$traitCollection
0x0004a69c  mov      x29, x29
0x0004a6a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004a6a4  mov      x24, x0
0x0004a6a8  bl       #0x57860   ; CALL objc_msgSend$displayScale
0x0004a6ac  mov      v11.16b, v0.16b
0x0004a6b0  mov      x0, x24
0x0004a6b4  bl       #0x55d78   ; CALL _objc_release
0x0004a6b8  mov      x0, x21
0x0004a6bc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004a6c0  mov      x29, x29
0x0004a6c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004a6c8  mov      x24, x0
0x0004a6cc  mov      w2, #1
0x0004a6d0  bl       #0x5c0a0   ; CALL objc_msgSend$setShouldRasterize:
0x0004a6d4  mov      x0, x24
0x0004a6d8  bl       #0x55d78   ; CALL _objc_release
0x0004a6dc  fcmp     d11, #0.0
0x0004a6e0  fmov     d0, #2.00000000
0x0004a6e4  fcsel    d11, d11, d0, gt
0x0004a6e8  mov      x0, x21
0x0004a6ec  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004a6f0  mov      x29, x29
0x0004a6f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004a6f8  mov      x24, x0
0x0004a6fc  mov      v0.16b, v11.16b
0x0004a700  bl       #0x5bd80   ; CALL objc_msgSend$setRasterizationScale:
0x0004a704  mov      x0, x24
0x0004a708  bl       #0x55d78   ; CALL _objc_release
0x0004a70c  mov      x8, #0x7fefffffffffffff
0x0004a710  fmov     d0, x8
0x0004a714  mov      x0, x21
0x0004a718  mov      v1.16b, v0.16b
0x0004a71c  bl       #0x5cbc0   ; CALL objc_msgSend$sizeThatFits:
0x0004a720  mov      v12.16b, v0.16b
0x0004a724  mov      v11.16b, v1.16b
0x0004a728  fcmp     d10, #0.0
0x0004a72c  b.gt     #0x4a75c
0x0004a730  mov      x0, x20
0x0004a734  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0004a738  cbz      w22, #0x4a750
0x0004a73c  fsub     d0, d2, d9
0x0004a740  ldr      d1, [x23, x25]
0x0004a744  fmov     d2, #-6.00000000
0x0004a748  fmadd    d10, d1, d2, d0
0x0004a74c  b        #0x4a75c
0x0004a750  ldr      d0, [x23, x25]
0x0004a754  fmov     d1, #-12.00000000
0x0004a758  fmadd    d10, d0, d1, d2
0x0004a75c  frintp   d0, d12
0x0004a760  fmov     d1, #10.00000000
0x0004a764  fcmp     d10, d1
0x0004a768  fcsel    d1, d1, d10, mi
0x0004a76c  fcmp     d0, d1
0x0004a770  fcsel    d10, d0, d1, mi
0x0004a774  frintp   d3, d11
0x0004a778  fmov     d0, xzr
0x0004a77c  fmov     d1, xzr
0x0004a780  mov      x0, x21
0x0004a784  mov      v2.16b, v10.16b
0x0004a788  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x0004a78c  fmov     d0, #0.50000000
0x0004a790  fmul     d0, d10, d0
0x0004a794  fadd     d0, d9, d0
0x0004a798  cmp      w22, #0
0x0004a79c  fcsel    d0, d0, d9, ne
0x0004a7a0  mov      x0, x21
0x0004a7a4  mov      v1.16b, v8.16b
0x0004a7a8  bl       #0x5a840   ; CALL objc_msgSend$setCenter:
0x0004a7ac  mov      x0, x20
0x0004a7b0  mov      x2, x21
0x0004a7b4  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0004a7b8  mov      x0, x20
0x0004a7bc  bl       #0x55d78   ; CALL _objc_release
0x0004a7c0  mov      x0, x19
0x0004a7c4  bl       #0x55d78   ; CALL _objc_release
0x0004a7c8  mov      x0, x21
0x0004a7cc  ldp      x29, x30, [sp, #0x70]
0x0004a7d0  ldp      x20, x19, [sp, #0x60]
0x0004a7d4  ldp      x22, x21, [sp, #0x50]
0x0004a7d8  ldp      x24, x23, [sp, #0x40]
0x0004a7dc  ldp      x26, x25, [sp, #0x30]
0x0004a7e0  ldp      d9, d8, [sp, #0x20]
0x0004a7e4  ldp      d11, d10, [sp, #0x10]
0x0004a7e8  ldp      d13, d12, [sp], #0x80
0x0004a7ec  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[SSStartupView ss_fade:from:to:alpha:]  va=0x4a7f0 size=172 types=@48@0:8@16d24d32d40
0x0004a7f0  stp      d11, d10, [sp, #-0x50]!
0x0004a7f4  stp      d9, d8, [sp, #0x10]
0x0004a7f8  stp      x22, x21, [sp, #0x20]
0x0004a7fc  stp      x20, x19, [sp, #0x30]
0x0004a800  stp      x29, x30, [sp, #0x40]
0x0004a804  add      x29, sp, #0x40
0x0004a808  mov      v8.16b, v2.16b
0x0004a80c  mov      v9.16b, v1.16b
0x0004a810  mov      v10.16b, v0.16b
0x0004a814  mov      x19, x2
0x0004a818  mov      x20, x0
0x0004a81c  adrp     x8, #0x8e000
0x0004a820  ldr      x21, [x8, #0xcd0]   ; @CLASS SSFade
0x0004a824  mov      x0, x2
0x0004a828  bl       #0x55d84   ; CALL _objc_retain
0x0004a82c  mov      x0, x21
0x0004a830  bl       #0x55d60   ; CALL _objc_opt_new
0x0004a834  mov      x21, x0
0x0004a838  mov      x2, x19
0x0004a83c  bl       #0x5c840   ; CALL objc_msgSend$setView:
0x0004a840  mov      x0, x19
0x0004a844  bl       #0x55d78   ; CALL _objc_release
0x0004a848  mov      x0, x21
0x0004a84c  mov      v0.16b, v10.16b
0x0004a850  bl       #0x5b100   ; CALL objc_msgSend$setInA:
0x0004a854  mov      x0, x21
0x0004a858  mov      v0.16b, v9.16b
0x0004a85c  bl       #0x5b120   ; CALL objc_msgSend$setInB:
0x0004a860  mov      x0, x21
0x0004a864  mov      v0.16b, v8.16b
0x0004a868  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x0004a86c  adrp     x8, #0x8f000
0x0004a870  ldrsw    x8, [x8, #0x74]
0x0004a874  ldr      x0, [x20, x8]
0x0004a878  mov      x2, x21
0x0004a87c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0004a880  mov      x0, x21
0x0004a884  ldp      x29, x30, [sp, #0x40]
0x0004a888  ldp      x20, x19, [sp, #0x30]
0x0004a88c  ldp      x22, x21, [sp, #0x20]
0x0004a890  ldp      d9, d8, [sp, #0x10]
0x0004a894  ldp      d11, d10, [sp], #0x50
0x0004a898  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[SSStartupView ss_addMote:layer:to:]  va=0x4a89c size=144 types=v88@0:8{?=qdddddd}16@72@80
0x0004a89c  stp      x24, x23, [sp, #-0x40]!
0x0004a8a0  stp      x22, x21, [sp, #0x10]
0x0004a8a4  stp      x20, x19, [sp, #0x20]
0x0004a8a8  stp      x29, x30, [sp, #0x30]
0x0004a8ac  add      x29, sp, #0x30
0x0004a8b0  mov      x19, x4
0x0004a8b4  mov      x20, x3
0x0004a8b8  mov      x21, x2
0x0004a8bc  mov      x22, x0
0x0004a8c0  adrp     x8, #0x8f000
0x0004a8c4  ldrsw    x8, [x8, #0x84]
0x0004a8c8  ldr      x23, [x0, x8]
0x0004a8cc  mov      x0, x4
0x0004a8d0  bl       #0x55d84   ; CALL _objc_retain
0x0004a8d4  mov      x0, x20
0x0004a8d8  bl       #0x55d84   ; CALL _objc_retain
0x0004a8dc  mov      x0, x23
0x0004a8e0  mov      x2, x21
0x0004a8e4  mov      w3, #0x38
0x0004a8e8  bl       #0x56440   ; CALL objc_msgSend$appendBytes:length:
0x0004a8ec  adrp     x8, #0x8f000
0x0004a8f0  ldrsw    x8, [x8, #0x88]
0x0004a8f4  ldr      x0, [x22, x8]
0x0004a8f8  mov      x2, x20
0x0004a8fc  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0004a900  mov      x0, x19
0x0004a904  mov      x2, x20
0x0004a908  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004a90c  mov      x0, x19
0x0004a910  bl       #0x55d78   ; CALL _objc_release
0x0004a914  mov      x0, x20
0x0004a918  ldp      x29, x30, [sp, #0x30]
0x0004a91c  ldp      x20, x19, [sp, #0x20]
0x0004a920  ldp      x22, x21, [sp, #0x10]
0x0004a924  ldp      x24, x23, [sp], #0x40
0x0004a928  b        #0x55d78   ; CALL _objc_release

=== -[SSStartupView ss_applyMotes:]  va=0x4a92c size=1076 types=v24@0:8d16
0x0004a92c  stp      d15, d14, [sp, #-0xa0]!
0x0004a930  stp      d13, d12, [sp, #0x10]
0x0004a934  stp      d11, d10, [sp, #0x20]
0x0004a938  stp      d9, d8, [sp, #0x30]
0x0004a93c  stp      x28, x27, [sp, #0x40]
0x0004a940  stp      x26, x25, [sp, #0x50]
0x0004a944  stp      x24, x23, [sp, #0x60]
0x0004a948  stp      x22, x21, [sp, #0x70]
0x0004a94c  stp      x20, x19, [sp, #0x80]
0x0004a950  stp      x29, x30, [sp, #0x90]
0x0004a954  add      x29, sp, #0x90
0x0004a958  sub      sp, sp, #0x200
0x0004a95c  mov      v8.16b, v0.16b
0x0004a960  mov      x19, x0
0x0004a964  adrp     x8, #0x8f000
0x0004a968  ldrsw    x23, [x8, #0x88]
0x0004a96c  ldr      x0, [x0, x23]
0x0004a970  bl       #0x573c0   ; CALL objc_msgSend$count
0x0004a974  cbz      x0, #0x4ad30
0x0004a978  mov      x20, x0
0x0004a97c  adrp     x8, #0x8f000
0x0004a980  ldrsw    x8, [x8, #0x84]
0x0004a984  ldr      x0, [x19, x8]
0x0004a988  bl       #0x56ba0   ; CALL objc_msgSend$bytes
0x0004a98c  mov      x21, #0
0x0004a990  adrp     x8, #0x8f000
0x0004a994  ldrsw    x8, [x8, #0xcc]
0x0004a998  ldr      d11, [x19, x8]
0x0004a99c  adrp     x8, #0x8f000
0x0004a9a0  ldrsw    x8, [x8, #0x54]
0x0004a9a4  add      x8, x19, x8
0x0004a9a8  ldp      d1, d2, [x8]
0x0004a9ac  mov      x8, #0x4049000000000000
0x0004a9b0  fmov     d0, x8
0x0004a9b4  fmul     d4, d8, d0
0x0004a9b8  mov      x8, #0x405e000000000000
0x0004a9bc  fmov     d0, x8
0x0004a9c0  fmadd    d3, d11, d0, d2
0x0004a9c4  stp      d3, d4, [sp, #0x60]
0x0004a9c8  fnmadd   d4, d11, d0, d2
0x0004a9cc  fmov     d0, #30.00000000
0x0004a9d0  fmadd    d5, d11, d0, d2
0x0004a9d4  fnmadd   d0, d11, d0, d2
0x0004a9d8  stp      d0, d4, [sp, #0x18]
0x0004a9dc  mov      x8, #0x4044000000000000
0x0004a9e0  fmov     d0, x8
0x0004a9e4  fmadd    d3, d11, d0, d2
0x0004a9e8  stp      d3, d5, [sp, #0x50]
0x0004a9ec  fnmadd   d0, d11, d0, d2
0x0004a9f0  str      d0, [sp, #0x10]
0x0004a9f4  adrp     x8, #0x65000
0x0004a9f8  ldr      d0, [x8, #0xf00]
0x0004a9fc  fmadd    d3, d11, d0, d1
0x0004aa00  str      d3, [sp, #0x48]
0x0004aa04  str      d1, [sp, #0x70]
0x0004aa08  fnmadd   d0, d11, d0, d1
0x0004aa0c  str      d0, [sp, #8]
0x0004aa10  adrp     x8, #0x65000
0x0004aa14  ldr      d0, [x8, #0x780]
0x0004aa18  str      d0, [sp, #0x40]
0x0004aa1c  adrp     x8, #0x65000
0x0004aa20  ldr      d0, [x8, #0x6e8]
0x0004aa24  str      d0, [sp, #0x38]
0x0004aa28  adrp     x8, #0x65000
0x0004aa2c  ldr      d1, [x8, #0xf08]
0x0004aa30  mov      x24, #0x404e000000000000
0x0004aa34  fmov     d0, x24
0x0004aa38  fmul     d0, d8, d0
0x0004aa3c  stp      d0, d1, [sp, #0x28]
0x0004aa40  str      d2, [sp, #0x78]
0x0004aa44  fneg     d0, d2
0x0004aa48  str      d0, [sp]
0x0004aa4c  add      x25, x0, #0x18
0x0004aa50  ldur     x26, [x25, #-0x18]
0x0004aa54  ldp      d9, d10, [x25, #-0x10]
0x0004aa58  ldp      d12, d13, [x25]
0x0004aa5c  ldp      d14, d15, [x25, #0x10]
0x0004aa60  ldr      x0, [x19, x23]
0x0004aa64  mov      x2, x21
0x0004aa68  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0004aa6c  mov      x29, x29
0x0004aa70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004aa74  mov      x22, x0
0x0004aa78  cmp      x26, #3
0x0004aa7c  b.gt     #0x4aabc
0x0004aa80  cmp      x26, #1
0x0004aa84  b.gt     #0x4ab50
0x0004aa88  cbz      x26, #0x4abd4
0x0004aa8c  cmp      x26, #1
0x0004aa90  b.ne     #0x4ad18
0x0004aa94  fmov     d0, #2.00000000
0x0004aa98  fmadd    d0, d8, d0, d15
0x0004aa9c  bl       #0x55e20   ; CALL _sin
0x0004aaa0  fabs     d0, d0
0x0004aaa4  ldp      d2, d1, [sp, #0x38]
0x0004aaa8  fmadd    d0, d0, d2, d1
0x0004aaac  fcvt     s0, d0
0x0004aab0  mov      x0, x22
0x0004aab4  bl       #0x5b940   ; CALL objc_msgSend$setOpacity:
0x0004aab8  b        #0x4ad18
0x0004aabc  cmp      x26, #5
0x0004aac0  b.gt     #0x4ab90
0x0004aac4  cmp      x26, #4
0x0004aac8  b.eq     #0x4ac08
0x0004aacc  cmp      x26, #5
0x0004aad0  b.ne     #0x4ad18
0x0004aad4  fmadd    d0, d8, d14, d15
0x0004aad8  bl       #0x55e20   ; CALL _sin
0x0004aadc  fmadd    d1, d8, d12, d10
0x0004aae0  ldr      d2, [sp, #0x50]
0x0004aae4  fcmp     d2, #0.0
0x0004aae8  b.le     #0x4aafc
0x0004aaec  fdiv     d2, d1, d2
0x0004aaf0  frintm   d2, d2
0x0004aaf4  ldr      d3, [sp, #0x10]
0x0004aaf8  fmadd    d1, d3, d2, d1
0x0004aafc  fmov     d2, #30.00000000
0x0004ab00  fmul     d0, d0, d2
0x0004ab04  fmadd    d0, d0, d11, d9
0x0004ab08  fmov     d2, #-20.00000000
0x0004ab0c  fmadd    d1, d11, d2, d1
0x0004ab10  mov      x0, x22
0x0004ab14  bl       #0x5bc00   ; CALL objc_msgSend$setPosition:
0x0004ab18  fadd     d0, d8, d15
0x0004ab1c  add      x8, sp, #0x180
0x0004ab20  fmov     d1, xzr
0x0004ab24  fmov     d2, xzr
0x0004ab28  fmov     d3, #1.00000000
0x0004ab2c  bl       #0x55820   ; CALL _CATransform3DMakeRotation
0x0004ab30  ldp      q0, q1, [sp, #0x1c0]
0x0004ab34  stp      q0, q1, [sp, #0x140]
0x0004ab38  ldp      q0, q1, [sp, #0x1e0]
0x0004ab3c  stp      q0, q1, [sp, #0x160]
0x0004ab40  ldp      q0, q1, [sp, #0x180]
0x0004ab44  stp      q0, q1, [sp, #0x100]
0x0004ab48  ldp      q0, q1, [sp, #0x1a0]
0x0004ab4c  b        #0x4ad08
0x0004ab50  cmp      x26, #2
0x0004ab54  b.eq     #0x4ac50
0x0004ab58  cmp      x26, #3
0x0004ab5c  b.ne     #0x4ad18
0x0004ab60  fmadd    d0, d8, d12, d9
0x0004ab64  ldr      d1, [sp, #0x70]
0x0004ab68  fadd     d1, d1, d14
0x0004ab6c  fcmp     d1, #0.0
0x0004ab70  b.le     #0x4ab80
0x0004ab74  fdiv     d2, d0, d1
0x0004ab78  frintm   d2, d2
0x0004ab7c  fmsub    d0, d1, d2, d0
0x0004ab80  fmov     d1, #-0.50000000
0x0004ab84  fmul     d1, d14, d1
0x0004ab88  fadd     d0, d0, d1
0x0004ab8c  b        #0x4ac78
0x0004ab90  cmp      x26, #6
0x0004ab94  b.eq     #0x4ac88
0x0004ab98  cmp      x26, #7
0x0004ab9c  b.ne     #0x4ad18
0x0004aba0  ldp      d1, d0, [sp, #0x60]
0x0004aba4  fmadd    d0, d0, d11, d15
0x0004aba8  fcmp     d1, #0.0
0x0004abac  b.le     #0x4abc0
0x0004abb0  fdiv     d1, d0, d1
0x0004abb4  frintm   d1, d1
0x0004abb8  ldr      d2, [sp, #0x20]
0x0004abbc  fmadd    d0, d2, d1, d0
0x0004abc0  ldr      d1, [sp, #0x78]
0x0004abc4  fsub     d0, d1, d0
0x0004abc8  fmov     d1, x24
0x0004abcc  fmadd    d1, d11, d1, d0
0x0004abd0  b        #0x4abfc
0x0004abd4  ldr      d0, [sp, #0x28]
0x0004abd8  fmul     d0, d0, d12
0x0004abdc  fmadd    d1, d0, d11, d10
0x0004abe0  ldr      d0, [sp, #0x78]
0x0004abe4  fcmp     d0, #0.0
0x0004abe8  b.le     #0x4abfc
0x0004abec  fdiv     d0, d1, d0
0x0004abf0  frintm   d0, d0
0x0004abf4  ldr      d2, [sp]
0x0004abf8  fmadd    d1, d2, d0, d1
0x0004abfc  mov      x0, x22
0x0004ac00  mov      v0.16b, v9.16b
0x0004ac04  b        #0x4ac80
0x0004ac08  fadd     d0, d8, d15
0x0004ac0c  bl       #0x55e20   ; CALL _sin
0x0004ac10  fmadd    d1, d8, d12, d10
0x0004ac14  ldr      d2, [sp, #0x78]
0x0004ac18  fmov     d3, #4.00000000
0x0004ac1c  fmadd    d2, d13, d3, d2
0x0004ac20  fcmp     d2, #0.0
0x0004ac24  b.le     #0x4ac34
0x0004ac28  fdiv     d3, d1, d2
0x0004ac2c  frintm   d3, d3
0x0004ac30  fmsub    d1, d2, d3, d1
0x0004ac34  fmov     d2, #10.00000000
0x0004ac38  fmul     d0, d0, d2
0x0004ac3c  fmadd    d0, d0, d11, d9
0x0004ac40  fmov     d2, #-2.00000000
0x0004ac44  fmadd    d1, d13, d2, d1
0x0004ac48  mov      x0, x22
0x0004ac4c  b        #0x4ac80
0x0004ac50  fmadd    d0, d8, d12, d9
0x0004ac54  ldr      d1, [sp, #0x48]
0x0004ac58  fcmp     d1, #0.0
0x0004ac5c  b.le     #0x4ac70
0x0004ac60  fdiv     d1, d0, d1
0x0004ac64  frintm   d1, d1
0x0004ac68  ldr      d2, [sp, #8]
0x0004ac6c  fmadd    d0, d2, d1, d0
0x0004ac70  ldr      d1, [sp, #0x30]
0x0004ac74  fmadd    d0, d11, d1, d0
0x0004ac78  mov      x0, x22
0x0004ac7c  mov      v1.16b, v10.16b
0x0004ac80  bl       #0x5bc00   ; CALL objc_msgSend$setPosition:
0x0004ac84  b        #0x4ad18
0x0004ac88  fmov     d0, #2.00000000
0x0004ac8c  fmadd    d0, d8, d0, d15
0x0004ac90  bl       #0x55e20   ; CALL _sin
0x0004ac94  fmadd    d1, d8, d12, d10
0x0004ac98  ldr      d2, [sp, #0x58]
0x0004ac9c  fcmp     d2, #0.0
0x0004aca0  b.le     #0x4acb4
0x0004aca4  fdiv     d2, d1, d2
0x0004aca8  frintm   d2, d2
0x0004acac  ldr      d3, [sp, #0x18]
0x0004acb0  fmadd    d1, d3, d2, d1
0x0004acb4  fmov     d2, #20.00000000
0x0004acb8  fmul     d0, d0, d2
0x0004acbc  fmadd    d0, d0, d11, d9
0x0004acc0  fmov     d2, #-15.00000000
0x0004acc4  fmadd    d1, d11, d2, d1
0x0004acc8  mov      x0, x22
0x0004accc  bl       #0x5bc00   ; CALL objc_msgSend$setPosition:
0x0004acd0  fmov     d0, #3.00000000
0x0004acd4  fmadd    d0, d8, d0, d15
0x0004acd8  add      x8, sp, #0x80
0x0004acdc  fmov     d1, xzr
0x0004ace0  fmov     d2, xzr
0x0004ace4  fmov     d3, #1.00000000
0x0004ace8  bl       #0x55820   ; CALL _CATransform3DMakeRotation
0x0004acec  ldp      q0, q1, [sp, #0xc0]
0x0004acf0  stp      q0, q1, [sp, #0x140]
0x0004acf4  ldp      q0, q1, [sp, #0xe0]
0x0004acf8  stp      q0, q1, [sp, #0x160]
0x0004acfc  ldp      q0, q1, [sp, #0x80]
0x0004ad00  stp      q0, q1, [sp, #0x100]
0x0004ad04  ldp      q0, q1, [sp, #0xa0]
0x0004ad08  stp      q0, q1, [sp, #0x120]
0x0004ad0c  add      x2, sp, #0x100
0x0004ad10  mov      x0, x22
0x0004ad14  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x0004ad18  add      x25, x25, #0x38
0x0004ad1c  mov      x0, x22
0x0004ad20  bl       #0x55d78   ; CALL _objc_release
0x0004ad24  add      x21, x21, #1
0x0004ad28  cmp      x20, x21
0x0004ad2c  b.ne     #0x4aa50
0x0004ad30  add      sp, sp, #0x200
0x0004ad34  ldp      x29, x30, [sp, #0x90]
0x0004ad38  ldp      x20, x19, [sp, #0x80]
0x0004ad3c  ldp      x22, x21, [sp, #0x70]
0x0004ad40  ldp      x24, x23, [sp, #0x60]
0x0004ad44  ldp      x26, x25, [sp, #0x50]
0x0004ad48  ldp      x28, x27, [sp, #0x40]
0x0004ad4c  ldp      d9, d8, [sp, #0x30]
0x0004ad50  ldp      d11, d10, [sp, #0x20]
0x0004ad54  ldp      d13, d12, [sp, #0x10]
0x0004ad58  ldp      d15, d14, [sp], #0xa0
0x0004ad5c  ret      

=== -[SSStartupView ss_buildSky]  va=0x4ad60 size=5516 types=v16@0:8
0x0004ad60  stp      d15, d14, [sp, #-0xa0]!
0x0004ad64  stp      d13, d12, [sp, #0x10]
0x0004ad68  stp      d11, d10, [sp, #0x20]
0x0004ad6c  stp      d9, d8, [sp, #0x30]
0x0004ad70  stp      x28, x27, [sp, #0x40]
0x0004ad74  stp      x26, x25, [sp, #0x50]
0x0004ad78  stp      x24, x23, [sp, #0x60]
0x0004ad7c  stp      x22, x21, [sp, #0x70]
0x0004ad80  stp      x20, x19, [sp, #0x80]
0x0004ad84  stp      x29, x30, [sp, #0x90]
0x0004ad88  add      x29, sp, #0x90
0x0004ad8c  sub      sp, sp, #0x170
0x0004ad90  mov      x19, x0
0x0004ad94  adrp     x8, #0x74000
0x0004ad98  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0004ad9c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0004ada0  stur     x8, [x29, #-0xa0]
0x0004ada4  adrp     x8, #0x8f000
0x0004ada8  ldrsw    x21, [x8, #0xcc]
0x0004adac  ldr      d9, [x0, x21]
0x0004adb0  adrp     x8, #0x8f000
0x0004adb4  ldrsw    x8, [x8, #0x54]
0x0004adb8  add      x8, x0, x8
0x0004adbc  ldp      d14, d15, [x8]
0x0004adc0  adrp     x8, #0x8f000
0x0004adc4  ldrsw    x8, [x8, #0x64]
0x0004adc8  ldr      x25, [x0, x8]
0x0004adcc  bl       #0x5e100   ; CALL objc_msgSend$weather
0x0004add0  mov      x29, x29
0x0004add4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004add8  mov      x20, x0
0x0004addc  adrp     x2, #0x7c000
0x0004ade0  add      x2, x2, #0x7e8   ; STR "isDay"
0x0004ade4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0004ade8  mov      x29, x29
0x0004adec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004adf0  mov      x22, x0
0x0004adf4  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x0004adf8  mov      x23, x0
0x0004adfc  mov      x0, x22
0x0004ae00  bl       #0x55d78   ; CALL _objc_release
0x0004ae04  mov      x0, x20
0x0004ae08  bl       #0x55d78   ; CALL _objc_release
0x0004ae0c  mov      x0, x19
0x0004ae10  bl       #0x5d1a0   ; CALL objc_msgSend$ss_host
0x0004ae14  mov      x29, x29
0x0004ae18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ae1c  mov      x22, x0
0x0004ae20  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004ae24  mov      x29, x29
0x0004ae28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ae2c  mov      x28, x0
0x0004ae30  mov      x0, x22
0x0004ae34  bl       #0x55d78   ; CALL _objc_release
0x0004ae38  ands     x8, x25, #-3
0x0004ae3c  stp      d15, d9, [sp, #0x30]
0x0004ae40  str      d14, [sp, #0x28]
0x0004ae44  b.eq     #0x4b090
0x0004ae48  cmp      x8, #1
0x0004ae4c  b.ne     #0x4b344
0x0004ae50  str      w23, [sp, #0x20]
0x0004ae54  str      x21, [sp, #0x18]
0x0004ae58  adrp     x8, #0x65000
0x0004ae5c  ldr      d0, [x8, #0x700]
0x0004ae60  fmul     d10, d15, d0
0x0004ae64  add      x24, sp, #0x40
0x0004ae68  mov      w26, #0x6e
0x0004ae6c  adrp     x8, #0x65000
0x0004ae70  ldr      d11, [x8, #0xeb8]
0x0004ae74  adrp     x8, #0x65000
0x0004ae78  ldr      d12, [x8, #0xf10]
0x0004ae7c  adrp     x8, #0x65000
0x0004ae80  ldr      d13, [x8, #0x6e8]
0x0004ae84  adrp     x27, #0x8e000
0x0004ae88  adrp     x20, #0x8e000
0x0004ae8c  fmov     d15, xzr
0x0004ae90  mov      w21, #1
0x0004ae94  mov      w0, #0x4241
0x0004ae98  movk     w0, #0xf, lsl #16
0x0004ae9c  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004aea0  ucvtf    d0, w0
0x0004aea4  fmul     d0, d0, d11
0x0004aea8  fdiv     d0, d0, d12
0x0004aeac  fadd     d0, d0, d13
0x0004aeb0  ldr      d1, [sp, #0x38]
0x0004aeb4  fmul     d0, d1, d0
0x0004aeb8  fmov     d1, #0.50000000
0x0004aebc  fmaxnm   d8, d0, d1
0x0004aec0  ldr      x0, [x27, #0xcd8]   ; @CLASS CALayer
0x0004aec4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004aec8  mov      x29, x29
0x0004aecc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004aed0  mov      x22, x0
0x0004aed4  ldr      x0, [x20, #0x910]   ; @CLASS UIColor
0x0004aed8  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0004aedc  mov      x29, x29
0x0004aee0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004aee4  mov      x23, x0
0x0004aee8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004aeec  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004aef0  mov      x2, x0
0x0004aef4  mov      x0, x22
0x0004aef8  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0004aefc  mov      x0, x23
0x0004af00  bl       #0x55d78   ; CALL _objc_release
0x0004af04  fadd     d2, d8, d8
0x0004af08  fmov     d0, xzr
0x0004af0c  fmov     d1, xzr
0x0004af10  mov      x0, x22
0x0004af14  mov      v3.16b, v2.16b
0x0004af18  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x0004af1c  mov      x0, x22
0x0004af20  mov      v0.16b, v8.16b
0x0004af24  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0004af28  mov      w0, #0x4241
0x0004af2c  movk     w0, #0xf, lsl #16
0x0004af30  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004af34  ucvtf    d0, w0
0x0004af38  fmul     d0, d14, d0
0x0004af3c  fdiv     d0, d0, d12
0x0004af40  fadd     d9, d0, d15
0x0004af44  mov      w0, #0x4241
0x0004af48  movk     w0, #0xf, lsl #16
0x0004af4c  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004af50  ucvtf    d0, w0
0x0004af54  fmul     d0, d10, d0
0x0004af58  fdiv     d0, d0, d12
0x0004af5c  fadd     d1, d0, d15
0x0004af60  mov      x0, x22
0x0004af64  mov      v0.16b, v9.16b
0x0004af68  bl       #0x5bc00   ; CALL objc_msgSend$setPosition:
0x0004af6c  mov      w0, #0x4241
0x0004af70  movk     w0, #0xf, lsl #16
0x0004af74  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004af78  ucvtf    d0, w0
0x0004af7c  fmov     d1, #6.00000000
0x0004af80  fmul     d0, d0, d1
0x0004af84  fdiv     d0, d0, d12
0x0004af88  str      x21, [sp, #0x40]
0x0004af8c  stp      xzr, xzr, [x24, #0x10]
0x0004af90  stur     xzr, [x24, #8]
0x0004af94  str      d8, [sp, #0x60]
0x0004af98  fadd     d0, d0, d15
0x0004af9c  str      xzr, [sp, #0x68]
0x0004afa0  str      d0, [sp, #0x70]
0x0004afa4  add      x2, sp, #0x40
0x0004afa8  mov      x0, x19
0x0004afac  mov      x3, x22
0x0004afb0  mov      x4, x28
0x0004afb4  bl       #0x5cee0   ; CALL objc_msgSend$ss_addMote:layer:to:
0x0004afb8  mov      x0, x22
0x0004afbc  bl       #0x55d78   ; CALL _objc_release
0x0004afc0  subs     w26, w26, #1
0x0004afc4  b.ne     #0x4ae94
0x0004afc8  adrp     x8, #0x8f000
0x0004afcc  ldrsw    x8, [x8, #0xd0]
0x0004afd0  ldr      d0, [x19, x8]
0x0004afd4  ldr      x21, [sp, #0x18]
0x0004afd8  ldr      d1, [x19, x21]
0x0004afdc  adrp     x8, #0x65000
0x0004afe0  ldr      d2, [x8, #0xf18]
0x0004afe4  fmadd    d8, d1, d2, d0
0x0004afe8  adrp     x8, #0x8f000
0x0004afec  ldrsw    x8, [x8, #0xd4]
0x0004aff0  ldr      d0, [x19, x8]
0x0004aff4  adrp     x8, #0x65000
0x0004aff8  ldr      d2, [x8, #0xb90]
0x0004affc  fmadd    d9, d1, d2, d0
0x0004b000  mov      x8, #0x405e000000000000
0x0004b004  fmov     d0, x8
0x0004b008  ldr      d12, [sp, #0x38]
0x0004b00c  fmul     d10, d12, d0
0x0004b010  ldr      x0, [x20, #0x910]   ; @CLASS UIColor
0x0004b014  adrp     x8, #0x65000
0x0004b018  ldr      d11, [x8, #0xf20]
0x0004b01c  adrp     x8, #0x65000
0x0004b020  ldr      d3, [x8, #0x9a0]
0x0004b024  fmov     d0, #1.00000000
0x0004b028  fmov     d1, #1.00000000
0x0004b02c  mov      v2.16b, v11.16b
0x0004b030  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004b034  mov      x29, x29
0x0004b038  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b03c  mov      x22, x0
0x0004b040  ldr      x0, [x20, #0x910]   ; @CLASS UIColor
0x0004b044  fmov     d0, #1.00000000
0x0004b048  fmov     d1, #1.00000000
0x0004b04c  fmov     d3, xzr
0x0004b050  mov      v2.16b, v11.16b
0x0004b054  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004b058  mov      x29, x29
0x0004b05c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b060  mov      x23, x0
0x0004b064  mov      v0.16b, v8.16b
0x0004b068  mov      v1.16b, v9.16b
0x0004b06c  mov      v2.16b, v10.16b
0x0004b070  mov      x0, x22
0x0004b074  mov      x1, x23
0x0004b078  bl       #0x4c190
0x0004b07c  mov      x29, x29
0x0004b080  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b084  mov      x24, x0
0x0004b088  mov      v9.16b, v12.16b
0x0004b08c  b        #0x4b318
0x0004b090  str      w23, [sp, #0x20]
0x0004b094  adrp     x8, #0x8f000
0x0004b098  ldrsw    x8, [x8, #0xd0]
0x0004b09c  ldr      d0, [x19, x8]
0x0004b0a0  ldr      d1, [x19, x21]
0x0004b0a4  adrp     x8, #0x65000
0x0004b0a8  ldr      d2, [x8, #0xf18]
0x0004b0ac  adrp     x8, #0x8f000
0x0004b0b0  ldrsw    x8, [x8, #0xd4]
0x0004b0b4  ldr      d3, [x19, x8]
0x0004b0b8  fmadd    d8, d1, d2, d0
0x0004b0bc  adrp     x8, #0x65000
0x0004b0c0  ldr      d0, [x8, #0x788]
0x0004b0c4  fmadd    d10, d1, d0, d3
0x0004b0c8  adrp     x20, #0x8e000
0x0004b0cc  ldr      x0, [x20, #0xcd8]   ; @CLASS CALayer
0x0004b0d0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004b0d4  mov      x29, x29
0x0004b0d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b0dc  adrp     x8, #0x8f000
0x0004b0e0  ldrsw    x24, [x8, #0xb0]
0x0004b0e4  ldr      x8, [x19, x24]
0x0004b0e8  str      x0, [x19, x24]
0x0004b0ec  mov      x0, x8
0x0004b0f0  bl       #0x55d78   ; CALL _objc_release
0x0004b0f4  adrp     x8, #0x74000
0x0004b0f8  ldr      x8, [x8, #0x610]   ; @GOT _CGRectZero
0x0004b0fc  ldp      d0, d1, [x8]
0x0004b100  ldp      d2, d3, [x8, #0x10]
0x0004b104  ldr      x0, [x19, x24]
0x0004b108  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x0004b10c  ldr      x0, [x19, x24]
0x0004b110  stp      d10, d8, [sp]
0x0004b114  mov      v0.16b, v8.16b
0x0004b118  mov      v1.16b, v10.16b
0x0004b11c  bl       #0x5bc00   ; CALL objc_msgSend$setPosition:
0x0004b120  adrp     x8, #0x65000
0x0004b124  ldr      d0, [x8, #0xf28]
0x0004b128  fmul     d10, d9, d0
0x0004b12c  fmov     d0, #28.00000000
0x0004b130  fmul     d11, d9, d0
0x0004b134  adrp     x8, #0x74000
0x0004b138  ldr      x8, [x8, #0x5c8]   ; @GOT _CGPointZero
0x0004b13c  ldp      d12, d13, [x8]
0x0004b140  mov      w27, #1
0x0004b144  adrp     x26, #0x8e000
0x0004b148  adrp     x8, #0x65000
0x0004b14c  ldr      d14, [x8, #0xa68]
0x0004b150  adrp     x8, #0x65000
0x0004b154  ldr      d15, [x8, #0xb50]
0x0004b158  adrp     x8, #0x65000
0x0004b15c  ldr      d8, [x8, #0xb60]
0x0004b160  adrp     x8, #0x65000
0x0004b164  ldr      d9, [x8, #0x930]
0x0004b168  ldr      x0, [x20, #0xcd8]   ; @CLASS CALayer
0x0004b16c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004b170  mov      x29, x29
0x0004b174  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b178  mov      x22, x0
0x0004b17c  ldr      x0, [x26, #0x910]   ; @CLASS UIColor
0x0004b180  fmov     d0, #1.00000000
0x0004b184  mov      v1.16b, v14.16b
0x0004b188  mov      v2.16b, v15.16b
0x0004b18c  mov      v3.16b, v8.16b
0x0004b190  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004b194  mov      x29, x29
0x0004b198  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b19c  mov      x23, x0
0x0004b1a0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004b1a4  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004b1a8  mov      x2, x0
0x0004b1ac  mov      x0, x22
0x0004b1b0  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0004b1b4  mov      x0, x23
0x0004b1b8  bl       #0x55d78   ; CALL _objc_release
0x0004b1bc  fmov     d0, xzr
0x0004b1c0  fmov     d1, #0.50000000
0x0004b1c4  mov      x0, x22
0x0004b1c8  bl       #0x5a440   ; CALL objc_msgSend$setAnchorPoint:
0x0004b1cc  fmov     d0, xzr
0x0004b1d0  fmov     d1, xzr
0x0004b1d4  mov      x0, x22
0x0004b1d8  mov      v2.16b, v10.16b
0x0004b1dc  mov      v3.16b, v11.16b
0x0004b1e0  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x0004b1e4  mov      x0, x22
0x0004b1e8  mov      v0.16b, v12.16b
0x0004b1ec  mov      v1.16b, v13.16b
0x0004b1f0  bl       #0x5bc00   ; CALL objc_msgSend$setPosition:
0x0004b1f4  ucvtf    d0, w27
0x0004b1f8  fmul     d0, d0, d9
0x0004b1fc  fmov     d1, #6.00000000
0x0004b200  fdiv     d0, d0, d1
0x0004b204  add      x8, sp, #0xc8
0x0004b208  fmov     d1, xzr
0x0004b20c  fmov     d2, xzr
0x0004b210  fmov     d3, #1.00000000
0x0004b214  bl       #0x55820   ; CALL _CATransform3DMakeRotation
0x0004b218  add      x8, sp, #9
0x0004b21c  ldur     q0, [x8, #0xff]
0x0004b220  add      x8, sp, #0x19
0x0004b224  ldur     q1, [x8, #0xff]
0x0004b228  stp      q0, q1, [sp, #0x80]
0x0004b22c  add      x8, sp, #0x29
0x0004b230  ldur     q0, [x8, #0xff]
0x0004b234  add      x8, sp, #0x39
0x0004b238  ldur     q1, [x8, #0xff]
0x0004b23c  stp      q0, q1, [sp, #0xa0]
0x0004b240  ldur     q0, [sp, #0xc8]
0x0004b244  ldur     q1, [sp, #0xd8]
0x0004b248  stp      q0, q1, [sp, #0x40]
0x0004b24c  ldur     q0, [sp, #0xe8]
0x0004b250  ldur     q1, [sp, #0xf8]
0x0004b254  stp      q0, q1, [sp, #0x60]
0x0004b258  add      x2, sp, #0x40
0x0004b25c  mov      x0, x22
0x0004b260  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x0004b264  ldr      x0, [x19, x24]
0x0004b268  mov      x2, x22
0x0004b26c  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004b270  mov      x0, x22
0x0004b274  bl       #0x55d78   ; CALL _objc_release
0x0004b278  add      w27, w27, #1
0x0004b27c  cmp      w27, #0xd
0x0004b280  b.ne     #0x4b168
0x0004b284  ldr      x2, [x19, x24]
0x0004b288  mov      x0, x28
0x0004b28c  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004b290  adrp     x8, #0x65000
0x0004b294  ldr      d0, [x8, #0x828]
0x0004b298  ldr      d9, [sp, #0x38]
0x0004b29c  fmul     d8, d9, d0
0x0004b2a0  ldr      x0, [x26, #0x910]   ; @CLASS UIColor
0x0004b2a4  adrp     x8, #0x65000
0x0004b2a8  ldr      d1, [x8, #0x7b0]
0x0004b2ac  adrp     x8, #0x65000
0x0004b2b0  ldr      d10, [x8, #0xf30]
0x0004b2b4  fmov     d0, #1.00000000
0x0004b2b8  fmov     d3, #1.00000000
0x0004b2bc  mov      v2.16b, v10.16b
0x0004b2c0  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004b2c4  mov      x29, x29
0x0004b2c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b2cc  mov      x22, x0
0x0004b2d0  ldr      x0, [x26, #0x910]   ; @CLASS UIColor
0x0004b2d4  adrp     x8, #0x65000
0x0004b2d8  ldr      d2, [x8, #0x9c0]
0x0004b2dc  fmov     d0, #1.00000000
0x0004b2e0  fmov     d3, xzr
0x0004b2e4  mov      v1.16b, v10.16b
0x0004b2e8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004b2ec  mov      x29, x29
0x0004b2f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b2f4  mov      x23, x0
0x0004b2f8  ldp      d1, d0, [sp]
0x0004b2fc  mov      v2.16b, v8.16b
0x0004b300  mov      x0, x22
0x0004b304  mov      x1, x23
0x0004b308  bl       #0x4c190
0x0004b30c  mov      x29, x29
0x0004b310  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b314  mov      x24, x0
0x0004b318  mov      x0, x28
0x0004b31c  mov      x2, x24
0x0004b320  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004b324  mov      x0, x24
0x0004b328  bl       #0x55d78   ; CALL _objc_release
0x0004b32c  mov      x0, x23
0x0004b330  bl       #0x55d78   ; CALL _objc_release
0x0004b334  mov      x0, x22
0x0004b338  bl       #0x55d78   ; CALL _objc_release
0x0004b33c  ldp      d14, d15, [sp, #0x28]
0x0004b340  ldr      w23, [sp, #0x20]
0x0004b344  cmp      x25, #5
0x0004b348  b.gt     #0x4b36c
0x0004b34c  sub      x8, x25, #2
0x0004b350  cmp      x8, #3
0x0004b354  b.lo     #0x4b388
0x0004b358  mov      v8.16b, v9.16b
0x0004b35c  mov      v9.16b, v14.16b
0x0004b360  cmp      x25, #5
0x0004b364  b.eq     #0x4b6ec
0x0004b368  b        #0x4c13c
0x0004b36c  sub      x8, x25, #6
0x0004b370  cmp      x8, #2
0x0004b374  b.lo     #0x4bb78
0x0004b378  cmp      x25, #8
0x0004b37c  b.eq     #0x4bad0
0x0004b380  cmp      x25, #9
0x0004b384  b.ne     #0x4c13c
0x0004b388  str      x21, [sp, #0x18]
0x0004b38c  adrp     x26, #0x8e000
0x0004b390  ldr      x0, [x26, #0x910]   ; @CLASS UIColor
0x0004b394  cbz      w23, #0x4b3a8
0x0004b398  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0004b39c  mov      x29, x29
0x0004b3a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b3a4  b        #0x4b3d0
0x0004b3a8  adrp     x8, #0x65000
0x0004b3ac  ldr      d0, [x8, #0xb50]
0x0004b3b0  adrp     x8, #0x65000
0x0004b3b4  ldr      d1, [x8, #0xb68]
0x0004b3b8  adrp     x8, #0x65000
0x0004b3bc  ldr      d2, [x8, #0xf38]
0x0004b3c0  fmov     d3, #1.00000000
0x0004b3c4  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004b3c8  mov      x29, x29
0x0004b3cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b3d0  mov      x22, x0
0x0004b3d4  ldr      d13, [sp, #0x38]
0x0004b3d8  adrp     x8, #0x8e000
0x0004b3dc  ldr      x21, [x8, #0xa78]   ; @CLASS UIImage
0x0004b3e0  adrp     x8, #0x8e000
0x0004b3e4  ldr      x23, [x8, #0xa70]   ; @CLASS UIImageSymbolConfiguration
0x0004b3e8  bl       #0x55d84   ; CALL _objc_retain
0x0004b3ec  mov      x8, #0x405e000000000000
0x0004b3f0  fmov     d0, x8
0x0004b3f4  mov      x0, x23
0x0004b3f8  bl       #0x570e0   ; CALL objc_msgSend$configurationWithPointSize:
0x0004b3fc  mov      x29, x29
0x0004b400  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b404  mov      x24, x0
0x0004b408  adrp     x2, #0x7d000
0x0004b40c  add      x2, x2, #0x2c8   ; STR "cloud.fill"
0x0004b410  mov      x0, x21
0x0004b414  mov      x3, x24
0x0004b418  bl       #0x5d840   ; CALL objc_msgSend$systemImageNamed:withConfiguration:
0x0004b41c  mov      x29, x29
0x0004b420  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b424  mov      x21, x0
0x0004b428  mov      x2, x22
0x0004b42c  mov      w3, #1
0x0004b430  bl       #0x58200   ; CALL objc_msgSend$imageWithTintColor:renderingMode:
0x0004b434  mov      x29, x29
0x0004b438  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b43c  mov      x23, x0
0x0004b440  mov      x0, x22
0x0004b444  bl       #0x55d78   ; CALL _objc_release
0x0004b448  mov      x0, x21
0x0004b44c  bl       #0x55d78   ; CALL _objc_release
0x0004b450  mov      x0, x24
0x0004b454  bl       #0x55d78   ; CALL _objc_release
0x0004b458  cbz      x23, #0x4b4d0
0x0004b45c  mov      x0, x23
0x0004b460  bl       #0x5cba0   ; CALL objc_msgSend$size
0x0004b464  mov      v8.16b, v0.16b
0x0004b468  mov      v9.16b, v1.16b
0x0004b46c  adrp     x8, #0x74000
0x0004b470  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x0004b474  str      x8, [sp, #0x40]
0x0004b478  adrp     x8, #0x65000
0x0004b47c  ldr      d0, [x8, #0x600]
0x0004b480  str      d0, [sp, #0x48]
0x0004b484  adrp     x8, #0x54000
0x0004b488  add      x8, x8, #0x93c
0x0004b48c  adrp     x9, #0x74000
0x0004b490  add      x9, x9, #0xe78
0x0004b494  stp      x8, x9, [sp, #0x50]
0x0004b498  mov      x0, x23
0x0004b49c  bl       #0x55d84   ; CALL _objc_retain
0x0004b4a0  str      x23, [sp, #0x60]
0x0004b4a4  stp      d8, d9, [sp, #0x68]
0x0004b4a8  add      x0, sp, #0x40
0x0004b4ac  mov      v0.16b, v8.16b
0x0004b4b0  mov      v1.16b, v9.16b
0x0004b4b4  bl       #0x54848
0x0004b4b8  mov      x29, x29
0x0004b4bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b4c0  mov      x21, x0
0x0004b4c4  ldr      x0, [sp, #0x60]
0x0004b4c8  bl       #0x55d78   ; CALL _objc_release
0x0004b4cc  b        #0x4b4d4
0x0004b4d0  mov      x21, #0
0x0004b4d4  mov      x0, x23
0x0004b4d8  bl       #0x55d78   ; CALL _objc_release
0x0004b4dc  mov      x0, x22
0x0004b4e0  bl       #0x55d78   ; CALL _objc_release
0x0004b4e4  cmp      x25, #4
0x0004b4e8  mov      w8, #3
0x0004b4ec  mov      w9, #5
0x0004b4f0  csel     x20, x9, x8, eq
0x0004b4f4  cbz      x21, #0x4b6b8
0x0004b4f8  adrp     x8, #0x74000
0x0004b4fc  ldr      x8, [x8, #0x678]   ; @GOT _kCAGravityResizeAspect
0x0004b500  ldr      x22, [x8]   ; @GOT ___objc_personality_v0
0x0004b504  mov      x8, #0x4064000000000000
0x0004b508  str      x8, [sp, #0x20]
0x0004b50c  adrp     x8, #0x65000
0x0004b510  ldr      d11, [x8, #0xf10]
0x0004b514  adrp     x8, #0x65000
0x0004b518  ldr      d12, [x8, #0xed8]
0x0004b51c  adrp     x24, #0x8e000
0x0004b520  adrp     x8, #0x65000
0x0004b524  ldr      d15, [x8, #0x660]
0x0004b528  adrp     x8, #0x65000
0x0004b52c  ldr      d14, [x8, #0x780]
0x0004b530  adrp     x8, #0x65000
0x0004b534  ldr      d10, [x8, #0x748]
0x0004b538  mov      w27, #3
0x0004b53c  mov      w0, #0x4241
0x0004b540  movk     w0, #0xf, lsl #16
0x0004b544  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004b548  ucvtf    d0, w0
0x0004b54c  ldr      d1, [sp, #0x20]
0x0004b550  fmul     d0, d0, d1
0x0004b554  fdiv     d0, d0, d11
0x0004b558  fadd     d0, d0, d12
0x0004b55c  fmul     d8, d13, d0
0x0004b560  ldr      x0, [x24, #0xcd8]   ; @CLASS CALayer
0x0004b564  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004b568  mov      x29, x29
0x0004b56c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b570  mov      x23, x0
0x0004b574  mov      x0, x21
0x0004b578  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004b57c  bl       #0x55ec0   ; CALL objc_msgSend$CGImage
0x0004b580  mov      x2, x0
0x0004b584  mov      x0, x23
0x0004b588  bl       #0x5aae0   ; CALL objc_msgSend$setContents:
0x0004b58c  mov      x0, x23
0x0004b590  mov      x2, x22
0x0004b594  bl       #0x5ab00   ; CALL objc_msgSend$setContentsGravity:
0x0004b598  mov      x0, x21
0x0004b59c  bl       #0x5cba0   ; CALL objc_msgSend$size
0x0004b5a0  fmul     d9, d8, d1
0x0004b5a4  mov      x0, x21
0x0004b5a8  bl       #0x5cba0   ; CALL objc_msgSend$size
0x0004b5ac  fmov     d1, #1.00000000
0x0004b5b0  fcmp     d0, d1
0x0004b5b4  fcsel    d0, d1, d0, mi
0x0004b5b8  fdiv     d3, d9, d0
0x0004b5bc  fmov     d0, xzr
0x0004b5c0  fmov     d1, xzr
0x0004b5c4  mov      x0, x23
0x0004b5c8  mov      v2.16b, v8.16b
0x0004b5cc  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x0004b5d0  mov      w0, #0x4241
0x0004b5d4  movk     w0, #0xf, lsl #16
0x0004b5d8  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004b5dc  ucvtf    d0, w0, #2
0x0004b5e0  fdiv     d0, d0, d11
0x0004b5e4  fadd     d0, d0, d15
0x0004b5e8  fcvt     s0, d0
0x0004b5ec  mov      x0, x23
0x0004b5f0  bl       #0x5b940   ; CALL objc_msgSend$setOpacity:
0x0004b5f4  mov      w0, #0x4241
0x0004b5f8  movk     w0, #0xf, lsl #16
0x0004b5fc  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004b600  ucvtf    d0, w0
0x0004b604  fmul     d0, d0, d14
0x0004b608  fdiv     d0, d0, d11
0x0004b60c  fadd     d0, d0, d10
0x0004b610  ldr      d1, [sp, #0x30]
0x0004b614  fmul     d9, d1, d0
0x0004b618  fmov     d0, xzr
0x0004b61c  mov      x0, x23
0x0004b620  mov      v1.16b, v9.16b
0x0004b624  bl       #0x5bc00   ; CALL objc_msgSend$setPosition:
0x0004b628  ldr      d0, [sp, #0x28]
0x0004b62c  fadd     d13, d0, d8
0x0004b630  mov      w0, #0x4241
0x0004b634  movk     w0, #0xf, lsl #16
0x0004b638  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004b63c  ucvtf    d0, w0
0x0004b640  fmul     d0, d13, d0
0x0004b644  fdiv     d0, d0, d11
0x0004b648  fmov     d1, xzr
0x0004b64c  fadd     d13, d0, d1
0x0004b650  mov      w0, #0x4241
0x0004b654  movk     w0, #0xf, lsl #16
0x0004b658  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004b65c  ucvtf    d0, w0
0x0004b660  fmov     d1, #14.00000000
0x0004b664  fmul     d0, d0, d1
0x0004b668  fdiv     d0, d0, d11
0x0004b66c  fmov     d1, #8.00000000
0x0004b670  fadd     d0, d0, d1
0x0004b674  str      x27, [sp, #0x40]
0x0004b678  stp      d13, d9, [sp, #0x48]
0x0004b67c  ldr      d13, [sp, #0x38]
0x0004b680  fmul     d0, d13, d0
0x0004b684  str      d0, [sp, #0x58]
0x0004b688  str      xzr, [sp, #0x60]
0x0004b68c  str      d8, [sp, #0x68]
0x0004b690  str      xzr, [sp, #0x70]
0x0004b694  add      x2, sp, #0x40
0x0004b698  mov      x0, x19
0x0004b69c  mov      x3, x23
0x0004b6a0  mov      x4, x28
0x0004b6a4  bl       #0x5cee0   ; CALL objc_msgSend$ss_addMote:layer:to:
0x0004b6a8  mov      x0, x23
0x0004b6ac  bl       #0x55d78   ; CALL _objc_release
0x0004b6b0  subs     x20, x20, #1
0x0004b6b4  b.ne     #0x4b53c
0x0004b6b8  mov      x0, x21
0x0004b6bc  bl       #0x55d78   ; CALL _objc_release
0x0004b6c0  cmp      x25, #7
0x0004b6c4  b.gt     #0x4b930
0x0004b6c8  sub      x8, x25, #6
0x0004b6cc  cmp      x8, #2
0x0004b6d0  ldp      d14, d15, [sp, #0x28]
0x0004b6d4  ldr      x21, [sp, #0x18]
0x0004b6d8  b.lo     #0x4bb78
0x0004b6dc  cmp      x25, #5
0x0004b6e0  mov      v8.16b, v13.16b
0x0004b6e4  mov      v9.16b, v14.16b
0x0004b6e8  b.ne     #0x4c13c
0x0004b6ec  adrp     x8, #0x74000
0x0004b6f0  ldr      x8, [x8, #0x670]   ; @GOT _kCAGradientLayerRadial
0x0004b6f4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0004b6f8  str      x8, [sp, #0x30]
0x0004b6fc  adrp     x8, #0x65000
0x0004b700  ldr      d0, [x8, #0xf60]
0x0004b704  fmul     d0, d8, d0
0x0004b708  str      d0, [sp, #0x28]
0x0004b70c  adrp     x8, #0x65000
0x0004b710  ldr      d0, [x8, #0xf68]
0x0004b714  fmul     d0, d8, d0
0x0004b718  str      d0, [sp, #0x20]
0x0004b71c  mov      w22, #0x78
0x0004b720  adrp     x20, #0x8e000
0x0004b724  adrp     x8, #0x65000
0x0004b728  ldr      d10, [x8, #0x608]
0x0004b72c  adrp     x8, #0x65000
0x0004b730  ldr      d11, [x8, #0x758]
0x0004b734  adrp     x8, #0x65000
0x0004b738  ldr      d13, [x8, #0xf10]
0x0004b73c  mov      x8, #0x4044000000000000
0x0004b740  fmov     d14, x8
0x0004b744  adrp     x8, #0x8e000
0x0004b748  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x0004b74c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004b750  mov      x29, x29
0x0004b754  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b758  mov      x23, x0
0x0004b75c  ldr      x2, [sp, #0x30]
0x0004b760  bl       #0x5c6e0   ; CALL objc_msgSend$setType:
0x0004b764  ldr      x0, [x20, #0x910]   ; @CLASS UIColor
0x0004b768  fmov     d0, #1.00000000
0x0004b76c  fmov     d1, #1.00000000
0x0004b770  fmov     d2, #1.00000000
0x0004b774  mov      v3.16b, v10.16b
0x0004b778  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004b77c  mov      x29, x29
0x0004b780  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b784  mov      x24, x0
0x0004b788  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004b78c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004b790  stur     x0, [x29, #-0xb8]
0x0004b794  ldr      x0, [x20, #0x910]   ; @CLASS UIColor
0x0004b798  fmov     d0, #1.00000000
0x0004b79c  fmov     d1, #1.00000000
0x0004b7a0  fmov     d2, #1.00000000
0x0004b7a4  mov      v3.16b, v11.16b
0x0004b7a8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004b7ac  mov      x29, x29
0x0004b7b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b7b4  mov      x25, x0
0x0004b7b8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004b7bc  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004b7c0  stur     x0, [x29, #-0xb0]
0x0004b7c4  ldr      x0, [x20, #0x910]   ; @CLASS UIColor
0x0004b7c8  fmov     d0, #1.00000000
0x0004b7cc  fmov     d1, #1.00000000
0x0004b7d0  fmov     d2, #1.00000000
0x0004b7d4  fmov     d3, xzr
0x0004b7d8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004b7dc  mov      x29, x29
0x0004b7e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b7e4  mov      x26, x0
0x0004b7e8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004b7ec  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004b7f0  stur     x0, [x29, #-0xa8]
0x0004b7f4  adrp     x8, #0x8e000
0x0004b7f8  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0004b7fc  sub      x2, x29, #0xb8
0x0004b800  mov      w3, #3
0x0004b804  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0004b808  mov      x29, x29
0x0004b80c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b810  mov      x27, x0
0x0004b814  mov      x0, x23
0x0004b818  mov      x2, x27
0x0004b81c  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0004b820  mov      x0, x27
0x0004b824  bl       #0x55d78   ; CALL _objc_release
0x0004b828  mov      x0, x26
0x0004b82c  bl       #0x55d78   ; CALL _objc_release
0x0004b830  mov      x0, x25
0x0004b834  bl       #0x55d78   ; CALL _objc_release
0x0004b838  mov      x0, x24
0x0004b83c  bl       #0x55d78   ; CALL _objc_release
0x0004b840  mov      x0, x23
0x0004b844  adrp     x2, #0x7f000
0x0004b848  add      x2, x2, #0xe10
0x0004b84c  bl       #0x5b480   ; CALL objc_msgSend$setLocations:
0x0004b850  fmov     d0, #0.50000000
0x0004b854  fmov     d1, #0.50000000
0x0004b858  mov      x0, x23
0x0004b85c  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x0004b860  fmov     d0, #1.00000000
0x0004b864  fmov     d1, #1.00000000
0x0004b868  mov      x0, x23
0x0004b86c  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x0004b870  fmov     d0, xzr
0x0004b874  fmov     d1, xzr
0x0004b878  mov      x0, x23
0x0004b87c  ldp      d3, d2, [sp, #0x20]
0x0004b880  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x0004b884  ldr      d0, [x19, x21]
0x0004b888  adrp     x8, #0x8f000
0x0004b88c  ldrsw    x8, [x8, #0xd4]
0x0004b890  ldr      d1, [x19, x8]
0x0004b894  ucvtf    d2, w22
0x0004b898  fmadd    d15, d2, d0, d1
0x0004b89c  mov      w0, #0x4241
0x0004b8a0  movk     w0, #0xf, lsl #16
0x0004b8a4  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004b8a8  ucvtf    d0, w0
0x0004b8ac  fmul     d0, d9, d0
0x0004b8b0  fdiv     d0, d0, d13
0x0004b8b4  fmov     d1, xzr
0x0004b8b8  fadd     d12, d0, d1
0x0004b8bc  mov      w0, #0x4241
0x0004b8c0  movk     w0, #0xf, lsl #16
0x0004b8c4  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004b8c8  ucvtf    d0, w0
0x0004b8cc  fmul     d0, d0, d14
0x0004b8d0  fdiv     d0, d0, d13
0x0004b8d4  fmov     d1, #20.00000000
0x0004b8d8  fadd     d0, d0, d1
0x0004b8dc  fmov     d1, #3.00000000
0x0004b8e0  fmul     d0, d0, d1
0x0004b8e4  mov      w8, #2
0x0004b8e8  str      x8, [sp, #0x40]
0x0004b8ec  stp      d12, d15, [sp, #0x48]
0x0004b8f0  fmul     d0, d8, d0
0x0004b8f4  str      d0, [sp, #0x58]
0x0004b8f8  add      x8, sp, #0x40
0x0004b8fc  stp      xzr, xzr, [x8, #0x28]
0x0004b900  stur     xzr, [x8, #0x20]
0x0004b904  add      x2, sp, #0x40
0x0004b908  mov      x0, x19
0x0004b90c  mov      x3, x23
0x0004b910  mov      x4, x28
0x0004b914  bl       #0x5cee0   ; CALL objc_msgSend$ss_addMote:layer:to:
0x0004b918  mov      x0, x23
0x0004b91c  bl       #0x55d78   ; CALL _objc_release
0x0004b920  add      w22, w22, #0x50
0x0004b924  cmp      w22, #0x258
0x0004b928  b.ne     #0x4b744
0x0004b92c  b        #0x4c13c
0x0004b930  cmp      x25, #8
0x0004b934  ldp      d14, d15, [sp, #0x28]
0x0004b938  b.eq     #0x4bad0
0x0004b93c  cmp      x25, #9
0x0004b940  b.ne     #0x4c13c
0x0004b944  mov      w20, #0x64
0x0004b948  adrp     x8, #0x65000
0x0004b94c  ldr      d11, [x8, #0xf10]
0x0004b950  adrp     x23, #0x8e000
0x0004b954  adrp     x8, #0x65000
0x0004b958  ldr      d0, [x8, #0x6d0]
0x0004b95c  str      d0, [sp, #0x20]
0x0004b960  fmov     d8, xzr
0x0004b964  mov      x8, #0x4044000000000000
0x0004b968  str      x8, [sp, #0x18]
0x0004b96c  mov      w24, #4
0x0004b970  mov      w0, #0x4241
0x0004b974  movk     w0, #0xf, lsl #16
0x0004b978  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004b97c  ucvtf    d0, w0
0x0004b980  fmov     d1, #3.00000000
0x0004b984  fmul     d0, d0, d1
0x0004b988  fdiv     d0, d0, d11
0x0004b98c  fmov     d1, #1.50000000
0x0004b990  fadd     d0, d0, d1
0x0004b994  fmul     d9, d13, d0
0x0004b998  ldr      x0, [x23, #0xcd8]   ; @CLASS CALayer
0x0004b99c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004b9a0  mov      x29, x29
0x0004b9a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b9a8  mov      x21, x0
0x0004b9ac  ldr      x0, [x26, #0x910]   ; @CLASS UIColor
0x0004b9b0  fmov     d0, #1.00000000
0x0004b9b4  fmov     d1, #1.00000000
0x0004b9b8  fmov     d2, #1.00000000
0x0004b9bc  ldr      d3, [sp, #0x20]
0x0004b9c0  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004b9c4  mov      x29, x29
0x0004b9c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004b9cc  mov      x22, x0
0x0004b9d0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004b9d4  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004b9d8  mov      x2, x0
0x0004b9dc  mov      x0, x21
0x0004b9e0  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0004b9e4  mov      x0, x22
0x0004b9e8  bl       #0x55d78   ; CALL _objc_release
0x0004b9ec  fadd     d2, d9, d9
0x0004b9f0  fmov     d0, xzr
0x0004b9f4  fmov     d1, xzr
0x0004b9f8  mov      x0, x21
0x0004b9fc  mov      v3.16b, v2.16b
0x0004ba00  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x0004ba04  mov      x0, x21
0x0004ba08  mov      v0.16b, v9.16b
0x0004ba0c  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0004ba10  mov      w0, #0x4241
0x0004ba14  movk     w0, #0xf, lsl #16
0x0004ba18  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004ba1c  ucvtf    d0, w0
0x0004ba20  fmul     d0, d14, d0
0x0004ba24  fdiv     d0, d0, d11
0x0004ba28  fadd     d12, d0, d8
0x0004ba2c  mov      w0, #0x4241
0x0004ba30  movk     w0, #0xf, lsl #16
0x0004ba34  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004ba38  ucvtf    d0, w0
0x0004ba3c  fmul     d0, d15, d0
0x0004ba40  fdiv     d0, d0, d11
0x0004ba44  fadd     d15, d0, d8
0x0004ba48  mov      w0, #0x4241
0x0004ba4c  movk     w0, #0xf, lsl #16
0x0004ba50  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004ba54  ucvtf    d0, w0
0x0004ba58  ldr      d1, [sp, #0x18]
0x0004ba5c  fmul     d0, d0, d1
0x0004ba60  fdiv     d0, d0, d11
0x0004ba64  fmov     d1, #30.00000000
0x0004ba68  fadd     d0, d0, d1
0x0004ba6c  fmul     d10, d13, d0
0x0004ba70  mov      w0, #0x4241
0x0004ba74  movk     w0, #0xf, lsl #16
0x0004ba78  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004ba7c  ucvtf    d0, w0
0x0004ba80  fmov     d1, #6.00000000
0x0004ba84  fmul     d0, d0, d1
0x0004ba88  fdiv     d0, d0, d11
0x0004ba8c  str      x24, [sp, #0x40]
0x0004ba90  stp      d12, d15, [sp, #0x48]
0x0004ba94  ldr      d15, [sp, #0x30]
0x0004ba98  stp      d10, d9, [sp, #0x58]
0x0004ba9c  fadd     d0, d0, d8
0x0004baa0  str      xzr, [sp, #0x68]
0x0004baa4  str      d0, [sp, #0x70]
0x0004baa8  add      x2, sp, #0x40
0x0004baac  mov      x0, x19
0x0004bab0  mov      x3, x21
0x0004bab4  mov      x4, x28
0x0004bab8  bl       #0x5cee0   ; CALL objc_msgSend$ss_addMote:layer:to:
0x0004babc  mov      x0, x21
0x0004bac0  bl       #0x55d78   ; CALL _objc_release
0x0004bac4  subs     w20, w20, #1
0x0004bac8  b.ne     #0x4b970
0x0004bacc  b        #0x4c13c
0x0004bad0  adrp     x8, #0x8e000
0x0004bad4  ldr      x0, [x8, #0xcd8]   ; @CLASS CALayer
0x0004bad8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004badc  mov      x29, x29
0x0004bae0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004bae4  adrp     x8, #0x8f000
0x0004bae8  ldrsw    x20, [x8, #0xa8]
0x0004baec  ldr      x8, [x19, x20]
0x0004baf0  str      x0, [x19, x20]
0x0004baf4  mov      x0, x8
0x0004baf8  bl       #0x55d78   ; CALL _objc_release
0x0004bafc  adrp     x8, #0x8f000
0x0004bb00  ldrsw    x8, [x8, #0x7c]
0x0004bb04  ldr      x0, [x19, x8]
0x0004bb08  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0004bb0c  ldr      x0, [x19, x20]
0x0004bb10  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0004bb14  adrp     x8, #0x8e000
0x0004bb18  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0004bb1c  adrp     x8, #0x65000
0x0004bb20  ldr      d0, [x8, #0x7d0]
0x0004bb24  adrp     x8, #0x65000
0x0004bb28  ldr      d1, [x8, #0xf20]
0x0004bb2c  fmov     d2, #1.00000000
0x0004bb30  fmov     d3, #1.00000000
0x0004bb34  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004bb38  mov      x29, x29
0x0004bb3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004bb40  mov      x21, x0
0x0004bb44  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004bb48  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004bb4c  mov      x2, x0
0x0004bb50  ldr      x0, [x19, x20]
0x0004bb54  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0004bb58  mov      x0, x21
0x0004bb5c  bl       #0x55d78   ; CALL _objc_release
0x0004bb60  ldr      x0, [x19, x20]
0x0004bb64  fmov     s0, wzr
0x0004bb68  bl       #0x5b940   ; CALL objc_msgSend$setOpacity:
0x0004bb6c  ldr      x2, [x19, x20]
0x0004bb70  mov      x0, x28
0x0004bb74  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004bb78  str      x28, [sp, #0x10]
0x0004bb7c  adrp     x8, #0x8e000
0x0004bb80  ldr      x0, [x8, #0x918]   ; @CLASS UIView
0x0004bb84  bl       #0x55c7c   ; CALL _objc_alloc
0x0004bb88  mov      x21, x0
0x0004bb8c  mov      x0, x19
0x0004bb90  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0004bb94  mov      x0, x21
0x0004bb98  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0004bb9c  adrp     x8, #0x8f000
0x0004bba0  ldrsw    x28, [x8, #0x80]
0x0004bba4  ldr      x8, [x19, x28]
0x0004bba8  str      x0, [x19, x28]
0x0004bbac  mov      x0, x8
0x0004bbb0  bl       #0x55d78   ; CALL _objc_release
0x0004bbb4  ldr      x0, [x19, x28]
0x0004bbb8  mov      w2, #0
0x0004bbbc  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x0004bbc0  ldr      x2, [x19, x28]
0x0004bbc4  mov      x0, x19
0x0004bbc8  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0004bbcc  adrp     x26, #0x8e000
0x0004bbd0  ldr      x0, [x26, #0xcd8]   ; @CLASS CALayer
0x0004bbd4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004bbd8  mov      x29, x29
0x0004bbdc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004bbe0  mov      x21, x0
0x0004bbe4  ldr      x0, [x19, x28]
0x0004bbe8  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0004bbec  mov      x0, x21
0x0004bbf0  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0004bbf4  ldr      x0, [x26, #0xcd8]   ; @CLASS CALayer
0x0004bbf8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004bbfc  mov      x29, x29
0x0004bc00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004bc04  mov      x20, x0
0x0004bc08  mov      x0, x21
0x0004bc0c  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0004bc10  mov      x0, x20
0x0004bc14  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0004bc18  adrp     x8, #0x8e000
0x0004bc1c  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0004bc20  adrp     x8, #0x65000
0x0004bc24  ldr      d0, [x8, #0x8d0]
0x0004bc28  adrp     x8, #0x65000
0x0004bc2c  ldr      d1, [x8, #0xf40]
0x0004bc30  adrp     x8, #0x65000
0x0004bc34  ldr      d2, [x8, #0xf48]
0x0004bc38  adrp     x8, #0x65000
0x0004bc3c  ldr      d3, [x8, #0x838]
0x0004bc40  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004bc44  mov      x29, x29
0x0004bc48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004bc4c  mov      x23, x0
0x0004bc50  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004bc54  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004bc58  mov      x2, x0
0x0004bc5c  mov      x0, x20
0x0004bc60  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0004bc64  mov      x0, x23
0x0004bc68  bl       #0x55d78   ; CALL _objc_release
0x0004bc6c  mov      x0, x21
0x0004bc70  str      x20, [sp, #0x20]
0x0004bc74  mov      x2, x20
0x0004bc78  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004bc7c  adrp     x0, #0x74000
0x0004bc80  add      x0, x0, #0xef8
0x0004bc84  mov      x8, #0x4040000000000000
0x0004bc88  fmov     d0, x8
0x0004bc8c  mov      x8, #0x4044000000000000
0x0004bc90  fmov     d1, x8
0x0004bc94  bl       #0x54848
0x0004bc98  mov      x29, x29
0x0004bc9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004bca0  mov      x23, x0
0x0004bca4  cmp      x25, #6
0x0004bca8  mov      w8, #0x78
0x0004bcac  mov      w9, #0x46
0x0004bcb0  csel     x20, x9, x8, eq
0x0004bcb4  add      x22, sp, #0x40
0x0004bcb8  fmov     d8, #6.00000000
0x0004bcbc  adrp     x8, #0x65000
0x0004bcc0  ldr      d9, [x8, #0xf10]
0x0004bcc4  fmov     d10, #3.00000000
0x0004bcc8  adrp     x8, #0x65000
0x0004bccc  ldr      d11, [x8, #0x610]
0x0004bcd0  fmov     d12, xzr
0x0004bcd4  mov      w0, #0x4241
0x0004bcd8  movk     w0, #0xf, lsl #16
0x0004bcdc  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004bce0  ucvtf    d0, w0
0x0004bce4  fmul     d0, d0, d8
0x0004bce8  fdiv     d0, d0, d9
0x0004bcec  fadd     d0, d0, d10
0x0004bcf0  ldr      d1, [sp, #0x38]
0x0004bcf4  fmul     d13, d1, d0
0x0004bcf8  ldr      x0, [x26, #0xcd8]   ; @CLASS CALayer
0x0004bcfc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004bd00  mov      x29, x29
0x0004bd04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004bd08  mov      x24, x0
0x0004bd0c  mov      x0, x23
0x0004bd10  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004bd14  bl       #0x55ec0   ; CALL objc_msgSend$CGImage
0x0004bd18  mov      x2, x0
0x0004bd1c  mov      x0, x24
0x0004bd20  bl       #0x5aae0   ; CALL objc_msgSend$setContents:
0x0004bd24  fmul     d2, d13, d11
0x0004bd28  fadd     d3, d13, d13
0x0004bd2c  fmov     d0, xzr
0x0004bd30  fmov     d1, xzr
0x0004bd34  mov      x0, x24
0x0004bd38  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x0004bd3c  mov      w0, #0x4241
0x0004bd40  movk     w0, #0xf, lsl #16
0x0004bd44  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004bd48  ucvtf    d0, w0
0x0004bd4c  fmul     d0, d14, d0
0x0004bd50  fdiv     d0, d0, d9
0x0004bd54  fadd     d14, d0, d12
0x0004bd58  mov      w0, #0x4241
0x0004bd5c  movk     w0, #0xf, lsl #16
0x0004bd60  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004bd64  ucvtf    d0, w0
0x0004bd68  fmul     d0, d15, d0
0x0004bd6c  fdiv     d0, d0, d9
0x0004bd70  fadd     d15, d0, d12
0x0004bd74  mov      w0, #0x4241
0x0004bd78  movk     w0, #0xf, lsl #16
0x0004bd7c  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004bd80  ucvtf    d0, w0
0x0004bd84  str      xzr, [sp, #0x40]
0x0004bd88  stp      d14, d15, [sp, #0x48]
0x0004bd8c  ldp      d14, d15, [sp, #0x28]
0x0004bd90  fdiv     d0, d0, d9
0x0004bd94  stp      d0, d13, [sp, #0x58]
0x0004bd98  ldr      d13, [sp, #0x38]
0x0004bd9c  stp      xzr, xzr, [x22, #0x28]
0x0004bda0  add      x2, sp, #0x40
0x0004bda4  mov      x0, x19
0x0004bda8  mov      x3, x24
0x0004bdac  mov      x4, x21
0x0004bdb0  bl       #0x5cee0   ; CALL objc_msgSend$ss_addMote:layer:to:
0x0004bdb4  mov      x0, x24
0x0004bdb8  bl       #0x55d78   ; CALL _objc_release
0x0004bdbc  subs     x20, x20, #1
0x0004bdc0  b.ne     #0x4bcd4
0x0004bdc4  adrp     x25, #0x8e000
0x0004bdc8  ldr      x0, [x25, #0xb48]   ; @CLASS CAShapeLayer
0x0004bdcc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004bdd0  mov      x29, x29
0x0004bdd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004bdd8  adrp     x8, #0x8f000
0x0004bddc  ldrsw    x20, [x8, #0xbc]
0x0004bde0  ldr      x8, [x19, x20]
0x0004bde4  str      x0, [x19, x20]
0x0004bde8  mov      x0, x8
0x0004bdec  bl       #0x55d78   ; CALL _objc_release
0x0004bdf0  mov      x0, x21
0x0004bdf4  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0004bdf8  ldr      x0, [x19, x20]
0x0004bdfc  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0004be00  adrp     x8, #0x74000
0x0004be04  ldr      x8, [x8, #0x650]   ; @GOT _kCAFillRuleEvenOdd
0x0004be08  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0004be0c  ldr      x0, [x19, x20]
0x0004be10  bl       #0x5ae60   ; CALL objc_msgSend$setFillRule:
0x0004be14  adrp     x8, #0x8e000
0x0004be18  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0004be1c  bl       #0x56940   ; CALL objc_msgSend$blackColor
0x0004be20  mov      x29, x29
0x0004be24  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004be28  mov      x24, x0
0x0004be2c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004be30  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004be34  mov      x2, x0
0x0004be38  ldr      x0, [x19, x20]
0x0004be3c  bl       #0x5ae40   ; CALL objc_msgSend$setFillColor:
0x0004be40  mov      x0, x24
0x0004be44  bl       #0x55d78   ; CALL _objc_release
0x0004be48  ldr      x2, [x19, x20]
0x0004be4c  mov      x0, x21
0x0004be50  bl       #0x5b4c0   ; CALL objc_msgSend$setMask:
0x0004be54  ldr      x0, [x19, x28]
0x0004be58  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004be5c  mov      x29, x29
0x0004be60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004be64  mov      x24, x0
0x0004be68  mov      x2, x21
0x0004be6c  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004be70  mov      x0, x24
0x0004be74  bl       #0x55d78   ; CALL _objc_release
0x0004be78  adrp     x8, #0x8f000
0x0004be7c  ldrsw    x8, [x8, #0xd8]
0x0004be80  add      x24, x19, x8
0x0004be84  fmov     d0, #0.50000000
0x0004be88  fmul     d0, d14, d0
0x0004be8c  mov      x8, #0x4054000000000000
0x0004be90  fmov     d1, x8
0x0004be94  fmadd    d1, d13, d1, d15
0x0004be98  stp      d0, d1, [x24]
0x0004be9c  adrp     x8, #0x65000
0x0004bea0  ldr      d0, [x8, #0xf50]
0x0004bea4  fmul     d0, d13, d0
0x0004bea8  adrp     x8, #0x65000
0x0004beac  ldr      d1, [x8, #0xf58]
0x0004beb0  fmul     d1, d14, d1
0x0004beb4  fcmp     d0, d1
0x0004beb8  fcsel    d0, d1, d0, mi
0x0004bebc  adrp     x8, #0x8f000
0x0004bec0  ldrsw    x20, [x8, #0xdc]
0x0004bec4  str      d0, [x19, x20]
0x0004bec8  ldr      x0, [x26, #0xcd8]   ; @CLASS CALayer
0x0004becc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004bed0  mov      x29, x29
0x0004bed4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004bed8  adrp     x8, #0x8f000
0x0004bedc  ldrsw    x22, [x8, #0xac]
0x0004bee0  ldr      x8, [x19, x22]
0x0004bee4  str      x0, [x19, x22]
0x0004bee8  mov      x0, x8
0x0004beec  bl       #0x55d78   ; CALL _objc_release
0x0004bef0  adrp     x8, #0x74000
0x0004bef4  ldr      x8, [x8, #0x610]   ; @GOT _CGRectZero
0x0004bef8  ldp      d0, d1, [x8]
0x0004befc  ldp      d2, d3, [x8, #0x10]
0x0004bf00  ldr      x0, [x19, x22]
0x0004bf04  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x0004bf08  ldp      d0, d1, [x24]
0x0004bf0c  ldr      x0, [x19, x22]
0x0004bf10  bl       #0x5bc00   ; CALL objc_msgSend$setPosition:
0x0004bf14  ldr      x0, [x25, #0xb48]   ; @CLASS CAShapeLayer
0x0004bf18  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004bf1c  mov      x29, x29
0x0004bf20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004bf24  mov      x24, x0
0x0004bf28  str      x28, [sp, #0x30]
0x0004bf2c  adrp     x27, #0x8e000
0x0004bf30  ldr      x0, [x27, #0xac0]   ; @CLASS UIBezierPath
0x0004bf34  bl       #0x567e0   ; CALL objc_msgSend$bezierPath
0x0004bf38  mov      x29, x29
0x0004bf3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004bf40  mov      x25, x0
0x0004bf44  adrp     x8, #0x74000
0x0004bf48  ldr      x8, [x8, #0x5c8]   ; @GOT _CGPointZero
0x0004bf4c  ldp      d0, d1, [x8]
0x0004bf50  bl       #0x59060   ; CALL objc_msgSend$moveToPoint:
0x0004bf54  ldr      d0, [x19, x20]
0x0004bf58  fmov     d1, xzr
0x0004bf5c  mov      x0, x25
0x0004bf60  bl       #0x56100   ; CALL objc_msgSend$addLineToPoint:
0x0004bf64  mov      x0, x25
0x0004bf68  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004bf6c  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x0004bf70  mov      x2, x0
0x0004bf74  mov      x0, x24
0x0004bf78  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x0004bf7c  adrp     x28, #0x8e000
0x0004bf80  ldr      x0, [x28, #0x910]   ; @CLASS UIColor
0x0004bf84  adrp     x8, #0x65000
0x0004bf88  ldr      d0, [x8, #0x800]
0x0004bf8c  adrp     x8, #0x65000
0x0004bf90  ldr      d2, [x8, #0xaf0]
0x0004bf94  fmov     d9, #1.00000000
0x0004bf98  fmov     d3, #1.00000000
0x0004bf9c  mov      v1.16b, v0.16b
0x0004bfa0  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004bfa4  mov      x29, x29
0x0004bfa8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004bfac  mov      x26, x0
0x0004bfb0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004bfb4  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004bfb8  mov      x2, x0
0x0004bfbc  mov      x0, x24
0x0004bfc0  bl       #0x5c380   ; CALL objc_msgSend$setStrokeColor:
0x0004bfc4  mov      x0, x26
0x0004bfc8  bl       #0x55d78   ; CALL _objc_release
0x0004bfcc  fmov     d0, #16.00000000
0x0004bfd0  fmul     d0, d13, d0
0x0004bfd4  fmov     d1, #2.00000000
0x0004bfd8  fmaxnm   d0, d0, d1
0x0004bfdc  mov      x0, x24
0x0004bfe0  bl       #0x5b3a0   ; CALL objc_msgSend$setLineWidth:
0x0004bfe4  adrp     x8, #0x74000
0x0004bfe8  ldr      x8, [x8, #0x688]   ; @GOT _kCALineCapRound
0x0004bfec  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0004bff0  mov      x0, x24
0x0004bff4  bl       #0x5b320   ; CALL objc_msgSend$setLineCap:
0x0004bff8  ldr      x0, [x19, x22]
0x0004bffc  mov      x2, x24
0x0004c000  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004c004  adrp     x8, #0x8e000
0x0004c008  ldr      x0, [x8, #0xb48]   ; @CLASS CAShapeLayer
0x0004c00c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004c010  mov      x29, x29
0x0004c014  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004c018  mov      x26, x0
0x0004c01c  ldr      x0, [x27, #0xac0]   ; @CLASS UIBezierPath
0x0004c020  bl       #0x567e0   ; CALL objc_msgSend$bezierPath
0x0004c024  mov      x29, x29
0x0004c028  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004c02c  mov      x27, x0
0x0004c030  mov      x8, #0x404e000000000000
0x0004c034  fmov     d0, x8
0x0004c038  fmul     d0, d13, d0
0x0004c03c  fmov     d1, #-6.00000000
0x0004c040  fmul     d8, d13, d1
0x0004c044  mov      v1.16b, v8.16b
0x0004c048  bl       #0x59060   ; CALL objc_msgSend$moveToPoint:
0x0004c04c  ldr      d0, [x19, x20]
0x0004c050  mov      x0, x27
0x0004c054  mov      v1.16b, v8.16b
0x0004c058  bl       #0x56100   ; CALL objc_msgSend$addLineToPoint:
0x0004c05c  mov      x0, x27
0x0004c060  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004c064  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x0004c068  mov      x2, x0
0x0004c06c  mov      x0, x26
0x0004c070  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x0004c074  ldr      x0, [x28, #0x910]   ; @CLASS UIColor
0x0004c078  adrp     x8, #0x65000
0x0004c07c  ldr      d3, [x8, #0x6d8]
0x0004c080  fmov     d0, #1.00000000
0x0004c084  fmov     d1, #1.00000000
0x0004c088  fmov     d2, #1.00000000
0x0004c08c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004c090  mov      x29, x29
0x0004c094  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004c098  mov      x28, x0
0x0004c09c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004c0a0  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004c0a4  mov      x2, x0
0x0004c0a8  mov      x0, x26
0x0004c0ac  bl       #0x5c380   ; CALL objc_msgSend$setStrokeColor:
0x0004c0b0  mov      x0, x28
0x0004c0b4  bl       #0x55d78   ; CALL _objc_release
0x0004c0b8  fmov     d0, #3.00000000
0x0004c0bc  fmul     d0, d13, d0
0x0004c0c0  fmaxnm   d0, d0, d9
0x0004c0c4  mov      x0, x26
0x0004c0c8  bl       #0x5b3a0   ; CALL objc_msgSend$setLineWidth:
0x0004c0cc  ldr      x0, [x19, x22]
0x0004c0d0  mov      x2, x26
0x0004c0d4  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004c0d8  ldr      x8, [sp, #0x30]
0x0004c0dc  ldr      x0, [x19, x8]
0x0004c0e0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004c0e4  mov      x29, x29
0x0004c0e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004c0ec  mov      x28, x0
0x0004c0f0  ldr      x2, [x19, x22]
0x0004c0f4  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004c0f8  mov      x0, x28
0x0004c0fc  bl       #0x55d78   ; CALL _objc_release
0x0004c100  mov      x0, x27
0x0004c104  bl       #0x55d78   ; CALL _objc_release
0x0004c108  mov      x0, x26
0x0004c10c  bl       #0x55d78   ; CALL _objc_release
0x0004c110  mov      x0, x25
0x0004c114  bl       #0x55d78   ; CALL _objc_release
0x0004c118  mov      x0, x24
0x0004c11c  bl       #0x55d78   ; CALL _objc_release
0x0004c120  mov      x0, x23
0x0004c124  bl       #0x55d78   ; CALL _objc_release
0x0004c128  ldr      x0, [sp, #0x20]
0x0004c12c  bl       #0x55d78   ; CALL _objc_release
0x0004c130  mov      x0, x21
0x0004c134  bl       #0x55d78   ; CALL _objc_release
0x0004c138  ldr      x28, [sp, #0x10]
0x0004c13c  mov      x0, x28
0x0004c140  bl       #0x55d78   ; CALL _objc_release
0x0004c144  ldur     x8, [x29, #-0xa0]
0x0004c148  adrp     x9, #0x74000
0x0004c14c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0004c150  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0004c154  cmp      x9, x8
0x0004c158  b.ne     #0x4c18c
0x0004c15c  add      sp, sp, #0x170
0x0004c160  ldp      x29, x30, [sp, #0x90]
0x0004c164  ldp      x20, x19, [sp, #0x80]
0x0004c168  ldp      x22, x21, [sp, #0x70]
0x0004c16c  ldp      x24, x23, [sp, #0x60]
0x0004c170  ldp      x26, x25, [sp, #0x50]
0x0004c174  ldp      x28, x27, [sp, #0x40]
0x0004c178  ldp      d9, d8, [sp, #0x30]
0x0004c17c  ldp      d11, d10, [sp, #0x20]
0x0004c180  ldp      d13, d12, [sp, #0x10]
0x0004c184  ldp      d15, d14, [sp], #0xa0
0x0004c188  ret      
0x0004c18c  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0004c190  sub      sp, sp, #0x70
0x0004c194  stp      d11, d10, [sp, #0x20]
0x0004c198  stp      d9, d8, [sp, #0x30]
0x0004c19c  stp      x22, x21, [sp, #0x40]
0x0004c1a0  stp      x20, x19, [sp, #0x50]
0x0004c1a4  stp      x29, x30, [sp, #0x60]
0x0004c1a8  add      x29, sp, #0x60
0x0004c1ac  mov      x20, x1
0x0004c1b0  mov      x21, x0
0x0004c1b4  mov      v8.16b, v2.16b
0x0004c1b8  mov      v9.16b, v1.16b
0x0004c1bc  mov      v10.16b, v0.16b
0x0004c1c0  adrp     x8, #0x74000
0x0004c1c4  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0004c1c8  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0004c1cc  str      x8, [sp, #0x18]
0x0004c1d0  adrp     x8, #0x8e000
0x0004c1d4  ldr      x19, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x0004c1d8  mov      x0, x1
0x0004c1dc  bl       #0x55d84   ; CALL _objc_retain
0x0004c1e0  mov      x0, x21
0x0004c1e4  bl       #0x55d84   ; CALL _objc_retain
0x0004c1e8  mov      x0, x19
0x0004c1ec  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004c1f0  mov      x29, x29
0x0004c1f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004c1f8  mov      x19, x0
0x0004c1fc  adrp     x8, #0x74000
0x0004c200  ldr      x8, [x8, #0x670]   ; @GOT _kCAGradientLayerRadial
0x0004c204  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0004c208  bl       #0x5c6e0   ; CALL objc_msgSend$setType:
0x0004c20c  mov      x0, x21
0x0004c210  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004c214  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004c218  mov      x22, x0
0x0004c21c  mov      x0, x21
0x0004c220  bl       #0x55d78   ; CALL _objc_release
0x0004c224  str      x22, [sp, #8]
0x0004c228  mov      x0, x20
0x0004c22c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004c230  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004c234  mov      x21, x0
0x0004c238  mov      x0, x20
0x0004c23c  bl       #0x55d78   ; CALL _objc_release
0x0004c240  str      x21, [sp, #0x10]
0x0004c244  adrp     x8, #0x8e000
0x0004c248  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0004c24c  add      x2, sp, #8
0x0004c250  mov      w3, #2
0x0004c254  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0004c258  mov      x29, x29
0x0004c25c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004c260  mov      x20, x0
0x0004c264  mov      x0, x19
0x0004c268  mov      x2, x20
0x0004c26c  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0004c270  mov      x0, x20
0x0004c274  bl       #0x55d78   ; CALL _objc_release
0x0004c278  fmov     d0, #0.50000000
0x0004c27c  fmov     d1, #0.50000000
0x0004c280  mov      x0, x19
0x0004c284  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x0004c288  fmov     d0, #1.00000000
0x0004c28c  fmov     d1, #1.00000000
0x0004c290  mov      x0, x19
0x0004c294  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x0004c298  fsub     d0, d10, d8
0x0004c29c  fsub     d1, d9, d8
0x0004c2a0  fadd     d2, d8, d8
0x0004c2a4  mov      x0, x19
0x0004c2a8  mov      v3.16b, v2.16b
0x0004c2ac  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0004c2b0  ldr      x8, [sp, #0x18]
0x0004c2b4  adrp     x9, #0x74000
0x0004c2b8  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0004c2bc  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0004c2c0  cmp      x9, x8
0x0004c2c4  b.ne     #0x4c2e8
0x0004c2c8  mov      x0, x19
0x0004c2cc  ldp      x29, x30, [sp, #0x60]
0x0004c2d0  ldp      x20, x19, [sp, #0x50]
0x0004c2d4  ldp      x22, x21, [sp, #0x40]
0x0004c2d8  ldp      d9, d8, [sp, #0x30]
0x0004c2dc  ldp      d11, d10, [sp, #0x20]
0x0004c2e0  add      sp, sp, #0x70
0x0004c2e4  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0004c2e8  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[SSStartupView ss_applySky:]  va=0x4c2ec size=1000 types=v24@0:8d16
0x0004c2ec  sub      sp, sp, #0x1e0
0x0004c2f0  stp      d11, d10, [sp, #0x180]
0x0004c2f4  stp      d9, d8, [sp, #0x190]
0x0004c2f8  stp      x28, x27, [sp, #0x1a0]
0x0004c2fc  stp      x22, x21, [sp, #0x1b0]
0x0004c300  stp      x20, x19, [sp, #0x1c0]
0x0004c304  stp      x29, x30, [sp, #0x1d0]
0x0004c308  add      x29, sp, #0x1d0
0x0004c30c  mov      v8.16b, v0.16b
0x0004c310  mov      x19, x0
0x0004c314  adrp     x8, #0x8f000
0x0004c318  ldrsw    x20, [x8, #0xb0]
0x0004c31c  ldr      x8, [x0, x20]
0x0004c320  cbz      x8, #0x4c36c
0x0004c324  fmov     d0, #0.25000000
0x0004c328  fmul     d0, d8, d0
0x0004c32c  sub      x8, x29, #0xd0
0x0004c330  fmov     d1, xzr
0x0004c334  fmov     d2, xzr
0x0004c338  fmov     d3, #1.00000000
0x0004c33c  bl       #0x55820   ; CALL _CATransform3DMakeRotation
0x0004c340  ldr      x0, [x19, x20]
0x0004c344  ldp      q0, q1, [x29, #-0x90]
0x0004c348  stp      q0, q1, [sp, #0xc0]
0x0004c34c  ldp      q0, q1, [x29, #-0x70]
0x0004c350  stp      q0, q1, [sp, #0xe0]
0x0004c354  ldp      q0, q1, [x29, #-0xd0]
0x0004c358  stp      q0, q1, [sp, #0x80]
0x0004c35c  ldp      q0, q1, [x29, #-0xb0]
0x0004c360  stp      q0, q1, [sp, #0xa0]
0x0004c364  add      x2, sp, #0x80
0x0004c368  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x0004c36c  adrp     x8, #0x8f000
0x0004c370  ldrsw    x8, [x8, #0xa8]
0x0004c374  ldr      x0, [x19, x8]
0x0004c378  cbz      x0, #0x4c458
0x0004c37c  fmov     d0, #7.00000000
0x0004c380  fdiv     d0, d8, d0
0x0004c384  frintm   d0, d0
0x0004c388  fmov     d1, #-7.00000000
0x0004c38c  fmadd    d0, d0, d1, d8
0x0004c390  adrp     x8, #0x65000
0x0004c394  ldr      d1, [x8, #0xf70]
0x0004c398  fadd     d1, d0, d1
0x0004c39c  fabs     d1, d1
0x0004c3a0  adrp     x8, #0x65000
0x0004c3a4  ldr      d2, [x8, #0xf78]
0x0004c3a8  fdiv     d1, d1, d2
0x0004c3ac  fmov     d2, #1.00000000
0x0004c3b0  fadd     d1, d1, d2
0x0004c3b4  fcmp     d1, d2
0x0004c3b8  fcsel    d3, d2, d1, gt
0x0004c3bc  fcmp     d1, #0.0
0x0004c3c0  fmov     d1, xzr
0x0004c3c4  fcsel    d3, d1, d3, mi
0x0004c3c8  adrp     x8, #0x65000
0x0004c3cc  ldr      d4, [x8, #0xf80]
0x0004c3d0  fadd     d4, d0, d4
0x0004c3d4  fabs     d4, d4
0x0004c3d8  adrp     x8, #0x65000
0x0004c3dc  ldr      d5, [x8, #0xf88]
0x0004c3e0  fdiv     d4, d4, d5
0x0004c3e4  fadd     d4, d4, d2
0x0004c3e8  fcmp     d4, d2
0x0004c3ec  fcsel    d5, d2, d4, gt
0x0004c3f0  adrp     x8, #0x65000
0x0004c3f4  ldr      d6, [x8, #0x6e8]
0x0004c3f8  fmul     d5, d5, d6
0x0004c3fc  fcmp     d4, #0.0
0x0004c400  fcsel    d4, d1, d5, mi
0x0004c404  adrp     x8, #0x65000
0x0004c408  ldr      d5, [x8, #0xf90]
0x0004c40c  fadd     d0, d0, d5
0x0004c410  fabs     d0, d0
0x0004c414  adrp     x8, #0x65000
0x0004c418  ldr      d5, [x8, #0xf98]
0x0004c41c  fdiv     d0, d0, d5
0x0004c420  fadd     d0, d0, d2
0x0004c424  fcmp     d0, d2
0x0004c428  fcsel    d2, d2, d0, gt
0x0004c42c  fcmp     d0, #0.0
0x0004c430  fcsel    d0, d1, d2, mi
0x0004c434  fcmp     d4, d0
0x0004c438  fcsel    d0, d0, d4, mi
0x0004c43c  fcmp     d3, d0
0x0004c440  fcsel    d0, d0, d3, mi
0x0004c444  adrp     x8, #0x65000
0x0004c448  ldr      d1, [x8, #0x838]
0x0004c44c  fmul     d0, d0, d1
0x0004c450  fcvt     s0, d0
0x0004c454  bl       #0x5b940   ; CALL objc_msgSend$setOpacity:
0x0004c458  adrp     x8, #0x8f000
0x0004c45c  ldrsw    x20, [x8, #0xac]
0x0004c460  ldr      x8, [x19, x20]
0x0004c464  cbz      x8, #0x4c598
0x0004c468  fmov     d9, xzr
0x0004c46c  fmov     d10, #1.00000000
0x0004c470  fcmp     d8, d10
0x0004c474  adrp     x21, #0x65000
0x0004c478  fmov     d0, xzr
0x0004c47c  b.pl     #0x4c5b8
0x0004c480  ldr      d1, [x21, #0xfa0]
0x0004c484  fcmp     d8, d1
0x0004c488  fcsel    d1, d0, d10, mi
0x0004c48c  fcmp     d8, d10
0x0004c490  fcsel    d9, d9, d1, mi
0x0004c494  adrp     x8, #0x65000
0x0004c498  ldr      d1, [x8, #0xfc8]
0x0004c49c  adrp     x8, #0x65000
0x0004c4a0  ldr      d8, [x8, #0x930]
0x0004c4a4  fmadd    d0, d0, d8, d1
0x0004c4a8  mov      x8, sp
0x0004c4ac  fmov     d1, xzr
0x0004c4b0  fmov     d2, xzr
0x0004c4b4  fmov     d3, #1.00000000
0x0004c4b8  bl       #0x55820   ; CALL _CATransform3DMakeRotation
0x0004c4bc  ldr      x0, [x19, x20]
0x0004c4c0  ldp      q0, q1, [sp, #0x40]
0x0004c4c4  stp      q0, q1, [sp, #0xc0]
0x0004c4c8  ldp      q0, q1, [sp, #0x60]
0x0004c4cc  stp      q0, q1, [sp, #0xe0]
0x0004c4d0  ldp      q0, q1, [sp]
0x0004c4d4  stp      q0, q1, [sp, #0x80]
0x0004c4d8  ldp      q0, q1, [sp, #0x20]
0x0004c4dc  stp      q0, q1, [sp, #0xa0]
0x0004c4e0  add      x2, sp, #0x80
0x0004c4e4  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x0004c4e8  adrp     x8, #0x8f000
0x0004c4ec  ldrsw    x8, [x8, #0xc0]
0x0004c4f0  ldr      d0, [x19, x8]
0x0004c4f4  fabd     d0, d9, d0
0x0004c4f8  adrp     x9, #0x65000
0x0004c4fc  ldr      d1, [x9, #0xfd0]
0x0004c500  fcmp     d0, d1
0x0004c504  b.le     #0x4c598
0x0004c508  str      d9, [x19, x8]
0x0004c50c  bl       #0x55a24   ; CALL _CGPathCreateMutable
0x0004c510  mov      x20, x0
0x0004c514  adrp     x8, #0x8f000
0x0004c518  ldrsw    x21, [x8, #0xbc]
0x0004c51c  ldr      x0, [x19, x21]
0x0004c520  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0004c524  mov      x0, x20
0x0004c528  mov      x1, #0
0x0004c52c  bl       #0x55a0c   ; CALL _CGPathAddRect
0x0004c530  fcmp     d9, #0.0
0x0004c534  b.le     #0x4c584
0x0004c538  adrp     x8, #0x8f000
0x0004c53c  ldrsw    x8, [x8, #0xd8]
0x0004c540  add      x22, x19, x8
0x0004c544  ldp      d0, d1, [x22]
0x0004c548  mov      x0, x20
0x0004c54c  mov      x1, #0
0x0004c550  bl       #0x55a30   ; CALL _CGPathMoveToPoint
0x0004c554  ldp      d0, d1, [x22]
0x0004c558  adrp     x8, #0x8f000
0x0004c55c  ldrsw    x8, [x8, #0xdc]
0x0004c560  ldr      d2, [x19, x8]
0x0004c564  fmadd    d4, d9, d8, d8
0x0004c568  mov      x0, x20
0x0004c56c  mov      x1, #0
0x0004c570  mov      v3.16b, v8.16b
0x0004c574  mov      w2, #0
0x0004c578  bl       #0x55a00   ; CALL _CGPathAddArc
0x0004c57c  mov      x0, x20
0x0004c580  bl       #0x55a18   ; CALL _CGPathCloseSubpath
0x0004c584  ldr      x0, [x19, x21]
0x0004c588  mov      x2, x20
0x0004c58c  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x0004c590  mov      x0, x20
0x0004c594  bl       #0x55a3c   ; CALL _CGPathRelease
0x0004c598  ldp      x29, x30, [sp, #0x1d0]
0x0004c59c  ldp      x20, x19, [sp, #0x1c0]
0x0004c5a0  ldp      x22, x21, [sp, #0x1b0]
0x0004c5a4  ldp      x28, x27, [sp, #0x1a0]
0x0004c5a8  ldp      d9, d8, [sp, #0x190]
0x0004c5ac  ldp      d11, d10, [sp, #0x180]
0x0004c5b0  add      sp, sp, #0x1e0
0x0004c5b4  ret      
0x0004c5b8  ldr      d0, [x21, #0xfa0]
0x0004c5bc  fcmp     d8, d0
0x0004c5c0  b.pl     #0x4c618
0x0004c5c4  fmov     d0, #-1.00000000
0x0004c5c8  fadd     d0, d8, d0
0x0004c5cc  adrp     x8, #0x65000
0x0004c5d0  ldr      d1, [x8, #0xfc0]
0x0004c5d4  fdiv     d0, d0, d1
0x0004c5d8  fmov     d11, #1.00000000
0x0004c5dc  fcmp     d0, d11
0x0004c5e0  fcsel    d1, d11, d0, gt
0x0004c5e4  fcmp     d0, #0.0
0x0004c5e8  fmov     d0, xzr
0x0004c5ec  fcsel    d1, d0, d1, mi
0x0004c5f0  fcmp     d1, #0.0
0x0004c5f4  fcsel    d0, d0, d1, mi
0x0004c5f8  fmov     d1, #0.50000000
0x0004c5fc  fcmp     d0, d1
0x0004c600  b.pl     #0x4c684
0x0004c604  fmov     d1, #4.00000000
0x0004c608  fmul     d1, d0, d1
0x0004c60c  fmul     d1, d0, d1
0x0004c610  fmul     d0, d0, d1
0x0004c614  b        #0x4c480
0x0004c618  adrp     x8, #0x65000
0x0004c61c  ldr      d0, [x8, #0xfa8]
0x0004c620  fcmp     d8, d0
0x0004c624  fmov     d0, xzr
0x0004c628  b.pl     #0x4c480
0x0004c62c  adrp     x8, #0x65000
0x0004c630  ldr      d0, [x8, #0xfb0]
0x0004c634  fadd     d0, d8, d0
0x0004c638  adrp     x8, #0x65000
0x0004c63c  ldr      d1, [x8, #0xfb8]
0x0004c640  fdiv     d0, d0, d1
0x0004c644  fmov     d11, #1.00000000
0x0004c648  fcmp     d0, d11
0x0004c64c  fcsel    d1, d11, d0, gt
0x0004c650  fcmp     d0, #0.0
0x0004c654  fmov     d0, xzr
0x0004c658  fcsel    d1, d0, d1, mi
0x0004c65c  fcmp     d1, #0.0
0x0004c660  fcsel    d0, d0, d1, mi
0x0004c664  fmov     d1, #0.50000000
0x0004c668  fcmp     d0, d1
0x0004c66c  b.pl     #0x4c6a8
0x0004c670  fmov     d1, #4.00000000
0x0004c674  fmul     d1, d0, d1
0x0004c678  fmul     d1, d0, d1
0x0004c67c  fmul     d0, d0, d1
0x0004c680  b        #0x4c6c8
0x0004c684  fmov     d1, #2.00000000
0x0004c688  fmov     d2, #-2.00000000
0x0004c68c  fmadd    d0, d0, d2, d1
0x0004c690  fmov     d1, #3.00000000
0x0004c694  bl       #0x55e14   ; CALL _pow
0x0004c698  fmov     d1, #-0.50000000
0x0004c69c  fmul     d0, d0, d1
0x0004c6a0  fadd     d0, d0, d11
0x0004c6a4  b        #0x4c480
0x0004c6a8  fmov     d1, #2.00000000
0x0004c6ac  fmov     d2, #-2.00000000
0x0004c6b0  fmadd    d0, d0, d2, d1
0x0004c6b4  fmov     d1, #3.00000000
0x0004c6b8  bl       #0x55e14   ; CALL _pow
0x0004c6bc  fmov     d1, #-0.50000000
0x0004c6c0  fmul     d0, d0, d1
0x0004c6c4  fadd     d0, d0, d11
0x0004c6c8  fmov     d1, #1.00000000
0x0004c6cc  fsub     d0, d1, d0
0x0004c6d0  b        #0x4c480

=== -[SSStartupView ss_gaugeAt:radius:label:unit:max:red:in:]  va=0x4c6d4 size=2592 types=@80@0:8{CGPoint=dd}16d32@40@48d56d64@72
0x0004c6d4  sub      sp, sp, #0x170
0x0004c6d8  stp      d15, d14, [sp, #0xd0]
0x0004c6dc  stp      d13, d12, [sp, #0xe0]
0x0004c6e0  stp      d11, d10, [sp, #0xf0]
0x0004c6e4  stp      d9, d8, [sp, #0x100]
0x0004c6e8  stp      x28, x27, [sp, #0x110]
0x0004c6ec  stp      x26, x25, [sp, #0x120]
0x0004c6f0  stp      x24, x23, [sp, #0x130]
0x0004c6f4  stp      x22, x21, [sp, #0x140]
0x0004c6f8  stp      x20, x19, [sp, #0x150]
0x0004c6fc  stp      x29, x30, [sp, #0x160]
0x0004c700  add      x29, sp, #0x160
0x0004c704  mov      x20, x4
0x0004c708  mov      v10.16b, v4.16b
0x0004c70c  mov      v9.16b, v3.16b
0x0004c710  mov      x19, x3
0x0004c714  mov      v11.16b, v2.16b
0x0004c718  mov      v12.16b, v1.16b
0x0004c71c  mov      v8.16b, v0.16b
0x0004c720  mov      x21, x0
0x0004c724  str      x2, [sp, #0x98]
0x0004c728  mov      x0, x2
0x0004c72c  bl       #0x55d84   ; CALL _objc_retain
0x0004c730  str      x19, [sp, #0x90]
0x0004c734  mov      x0, x19
0x0004c738  bl       #0x55d84   ; CALL _objc_retain
0x0004c73c  mov      x0, x20
0x0004c740  bl       #0x55d84   ; CALL _objc_retain
0x0004c744  adrp     x8, #0x8f000
0x0004c748  ldrsw    x8, [x8, #0xcc]
0x0004c74c  str      x21, [sp, #0x78]
0x0004c750  ldr      d13, [x21, x8]
0x0004c754  fmov     d0, #10.00000000
0x0004c758  fmul     d0, d13, d0
0x0004c75c  fmov     d1, #2.00000000
0x0004c760  fmaxnm   d15, d0, d1
0x0004c764  fmov     d0, #4.00000000
0x0004c768  fmul     d0, d15, d0
0x0004c76c  fmadd    d14, d11, d1, d0
0x0004c770  fmov     d0, #0.50000000
0x0004c774  fmul     d0, d14, d0
0x0004c778  str      d8, [sp, #0x70]
0x0004c77c  fsub     d8, d8, d0
0x0004c780  str      d12, [sp, #0x60]
0x0004c784  fsub     d12, d12, d0
0x0004c788  adrp     x8, #0x8e000
0x0004c78c  ldr      x0, [x8, #0xac0]   ; @CLASS UIBezierPath
0x0004c790  adrp     x8, #0x65000
0x0004c794  ldr      d3, [x8, #0xcb0]
0x0004c798  adrp     x8, #0x65000
0x0004c79c  ldr      d4, [x8, #0xfd8]
0x0004c7a0  stur     d0, [x29, #-0xa8]
0x0004c7a4  mov      v1.16b, v0.16b
0x0004c7a8  mov      v2.16b, v11.16b
0x0004c7ac  str      d3, [sp, #0xb0]
0x0004c7b0  mov      w2, #1
0x0004c7b4  bl       #0x56800   ; CALL objc_msgSend$bezierPathWithArcCenter:radius:startAngle:endAngle:clockwise:
0x0004c7b8  mov      x29, x29
0x0004c7bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004c7c0  mov      x22, x0
0x0004c7c4  str      x20, [sp, #0x88]
0x0004c7c8  mov      x0, x20
0x0004c7cc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004c7d0  mov      x29, x29
0x0004c7d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004c7d8  mov      x24, x0
0x0004c7dc  adrp     x8, #0x8e000
0x0004c7e0  ldr      x0, [x8, #0xce0]   ; @CLASS SSGauge
0x0004c7e4  bl       #0x55d60   ; CALL _objc_opt_new
0x0004c7e8  mov      x21, x0
0x0004c7ec  mov      v0.16b, v9.16b
0x0004c7f0  bl       #0x5b540   ; CALL objc_msgSend$setMax:
0x0004c7f4  mov      x0, x21
0x0004c7f8  mov      v0.16b, v10.16b
0x0004c7fc  bl       #0x5bda0   ; CALL objc_msgSend$setRed:
0x0004c800  mov      x0, x21
0x0004c804  mov      x2, #-1
0x0004c808  bl       #0x5c120   ; CALL objc_msgSend$setShown:
0x0004c80c  adrp     x26, #0x8e000
0x0004c810  ldr      x0, [x26, #0xb48]   ; @CLASS CAShapeLayer
0x0004c814  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004c818  mov      x29, x29
0x0004c81c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004c820  mov      x20, x0
0x0004c824  mov      v0.16b, v8.16b
0x0004c828  mov      v1.16b, v12.16b
0x0004c82c  mov      v2.16b, v14.16b
0x0004c830  mov      v3.16b, v14.16b
0x0004c834  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0004c838  mov      x0, x22
0x0004c83c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004c840  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x0004c844  mov      x2, x0
0x0004c848  mov      x0, x20
0x0004c84c  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x0004c850  mov      x0, x20
0x0004c854  mov      x2, #0
0x0004c858  bl       #0x5ae40   ; CALL objc_msgSend$setFillColor:
0x0004c85c  adrp     x28, #0x8e000
0x0004c860  ldr      x0, [x28, #0x910]   ; @CLASS UIColor
0x0004c864  adrp     x8, #0x65000
0x0004c868  ldr      d3, [x8, #0x748]
0x0004c86c  fmov     d0, #1.00000000
0x0004c870  fmov     d1, #1.00000000
0x0004c874  fmov     d2, #1.00000000
0x0004c878  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004c87c  mov      x29, x29
0x0004c880  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004c884  mov      x19, x0
0x0004c888  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004c88c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004c890  mov      x2, x0
0x0004c894  mov      x0, x20
0x0004c898  bl       #0x5c380   ; CALL objc_msgSend$setStrokeColor:
0x0004c89c  mov      x0, x19
0x0004c8a0  bl       #0x55d78   ; CALL _objc_release
0x0004c8a4  mov      x0, x20
0x0004c8a8  mov      v0.16b, v15.16b
0x0004c8ac  bl       #0x5b3a0   ; CALL objc_msgSend$setLineWidth:
0x0004c8b0  adrp     x8, #0x74000
0x0004c8b4  ldr      x8, [x8, #0x688]   ; @GOT _kCALineCapRound
0x0004c8b8  ldr      x27, [x8]   ; @GOT ___objc_personality_v0
0x0004c8bc  mov      x0, x20
0x0004c8c0  mov      x2, x27
0x0004c8c4  bl       #0x5b320   ; CALL objc_msgSend$setLineCap:
0x0004c8c8  mov      x0, x24
0x0004c8cc  str      x20, [sp, #0x58]
0x0004c8d0  mov      x2, x20
0x0004c8d4  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004c8d8  adrp     x8, #0x8e000
0x0004c8dc  ldr      x0, [x8, #0xcd8]   ; @CLASS CALayer
0x0004c8e0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004c8e4  mov      x29, x29
0x0004c8e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004c8ec  mov      x23, x0
0x0004c8f0  str      d8, [sp, #0x30]
0x0004c8f4  mov      v0.16b, v8.16b
0x0004c8f8  stur     d12, [x29, #-0xa0]
0x0004c8fc  mov      v1.16b, v12.16b
0x0004c900  mov      v2.16b, v14.16b
0x0004c904  str      d14, [sp, #0x38]
0x0004c908  mov      v3.16b, v14.16b
0x0004c90c  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0004c910  ldr      x0, [x28, #0x910]   ; @CLASS UIColor
0x0004c914  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0004c918  mov      x29, x29
0x0004c91c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004c920  mov      x19, x0
0x0004c924  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004c928  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004c92c  mov      x2, x0
0x0004c930  mov      x0, x23
0x0004c934  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x0004c938  mov      x0, x19
0x0004c93c  bl       #0x55d78   ; CALL _objc_release
0x0004c940  adrp     x8, #0x66000
0x0004c944  ldr      s0, [x8, #0x2b8]
0x0004c948  mov      x0, x23
0x0004c94c  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x0004c950  fmov     d0, #8.00000000
0x0004c954  fmul     d0, d13, d0
0x0004c958  mov      x0, x23
0x0004c95c  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x0004c960  adrp     x8, #0x74000
0x0004c964  ldr      x8, [x8, #0x618]   ; @GOT _CGSizeZero
0x0004c968  ldp      d0, d1, [x8]
0x0004c96c  mov      x0, x23
0x0004c970  stp      d1, d0, [sp, #0x10]
0x0004c974  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x0004c978  adrp     x8, #0x8e000
0x0004c97c  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x0004c980  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004c984  mov      x29, x29
0x0004c988  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004c98c  mov      x25, x0
0x0004c990  mov      x0, x23
0x0004c994  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0004c998  mov      x0, x25
0x0004c99c  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0004c9a0  fmov     d14, xzr
0x0004c9a4  fmov     d0, xzr
0x0004c9a8  fmov     d1, #0.50000000
0x0004c9ac  mov      x0, x25
0x0004c9b0  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x0004c9b4  fmov     d0, #1.00000000
0x0004c9b8  fmov     d1, #0.50000000
0x0004c9bc  mov      x0, x25
0x0004c9c0  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x0004c9c4  mov      w0, #0xd3ff
0x0004c9c8  movk     w0, #0x7f, lsl #16
0x0004c9cc  mov      w1, #0xffffff
0x0004c9d0  bl       #0x4732c
0x0004c9d4  mov      x29, x29
0x0004c9d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004c9dc  mov      x19, x0
0x0004c9e0  mov      x0, x25
0x0004c9e4  mov      x2, x19
0x0004c9e8  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0004c9ec  mov      x0, x19
0x0004c9f0  bl       #0x55d78   ; CALL _objc_release
0x0004c9f4  ldr      x0, [x26, #0xb48]   ; @CLASS CAShapeLayer
0x0004c9f8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004c9fc  mov      x29, x29
0x0004ca00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ca04  mov      x19, x0
0x0004ca08  mov      x0, x25
0x0004ca0c  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0004ca10  mov      x0, x19
0x0004ca14  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0004ca18  mov      x0, x22
0x0004ca1c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004ca20  str      x22, [sp, #0x80]
0x0004ca24  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x0004ca28  mov      x2, x0
0x0004ca2c  mov      x0, x19
0x0004ca30  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x0004ca34  mov      x0, x19
0x0004ca38  mov      x2, #0
0x0004ca3c  bl       #0x5ae40   ; CALL objc_msgSend$setFillColor:
0x0004ca40  ldr      x0, [x28, #0x910]   ; @CLASS UIColor
0x0004ca44  bl       #0x56940   ; CALL objc_msgSend$blackColor
0x0004ca48  mov      x29, x29
0x0004ca4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ca50  mov      x20, x0
0x0004ca54  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004ca58  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004ca5c  mov      x2, x0
0x0004ca60  mov      x0, x19
0x0004ca64  bl       #0x5c380   ; CALL objc_msgSend$setStrokeColor:
0x0004ca68  mov      x0, x20
0x0004ca6c  bl       #0x55d78   ; CALL _objc_release
0x0004ca70  mov      x0, x19
0x0004ca74  mov      v0.16b, v15.16b
0x0004ca78  bl       #0x5b3a0   ; CALL objc_msgSend$setLineWidth:
0x0004ca7c  mov      x0, x19
0x0004ca80  str      x27, [sp, #0x20]
0x0004ca84  mov      x2, x27
0x0004ca88  adrp     x27, #0x8e000
0x0004ca8c  bl       #0x5b320   ; CALL objc_msgSend$setLineCap:
0x0004ca90  fmov     d0, xzr
0x0004ca94  mov      x0, x19
0x0004ca98  bl       #0x5c3a0   ; CALL objc_msgSend$setStrokeEnd:
0x0004ca9c  mov      x0, x25
0x0004caa0  mov      x2, x19
0x0004caa4  bl       #0x5b4c0   ; CALL objc_msgSend$setMask:
0x0004caa8  mov      x0, x23
0x0004caac  mov      x2, x25
0x0004cab0  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004cab4  mov      x0, x24
0x0004cab8  str      x23, [sp, #0x48]
0x0004cabc  mov      x2, x23
0x0004cac0  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004cac4  mov      x0, x21
0x0004cac8  str      x19, [sp, #0x28]
0x0004cacc  mov      x2, x19
0x0004cad0  bl       #0x5a4a0   ; CALL objc_msgSend$setArc:
0x0004cad4  mov      x19, x21
0x0004cad8  mov      x0, x21
0x0004cadc  str      x25, [sp, #0x40]
0x0004cae0  mov      x2, x25
0x0004cae4  bl       #0x5ae20   ; CALL objc_msgSend$setFill:
0x0004cae8  ldr      x0, [x27, #0xac0]   ; @CLASS UIBezierPath
0x0004caec  bl       #0x567e0   ; CALL objc_msgSend$bezierPath
0x0004caf0  mov      x29, x29
0x0004caf4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004caf8  mov      x20, x0
0x0004cafc  ldr      x0, [x27, #0xac0]   ; @CLASS UIBezierPath
0x0004cb00  bl       #0x567e0   ; CALL objc_msgSend$bezierPath
0x0004cb04  mov      x29, x29
0x0004cb08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004cb0c  mov      x23, x0
0x0004cb10  fmov     d0, #-26.00000000
0x0004cb14  fmadd    d8, d13, d0, d11
0x0004cb18  fmov     d0, #-14.00000000
0x0004cb1c  str      d11, [sp, #0x68]
0x0004cb20  str      d13, [sp, #0x50]
0x0004cb24  fmadd    d12, d13, d0, d11
0x0004cb28  adrp     x8, #0x65000
0x0004cb2c  ldr      d0, [x8, #0xfe0]
0x0004cb30  fadd     d0, d10, d0
0x0004cb34  str      d0, [sp, #0xa8]
0x0004cb38  mov      w22, #0xb
0x0004cb3c  adrp     x8, #0x65000
0x0004cb40  ldr      d0, [x8, #0xfe8]
0x0004cb44  str      d0, [sp, #0xa0]
0x0004cb48  ldr      d0, [sp, #0xa0]
0x0004cb4c  fmul     d0, d14, d0
0x0004cb50  fmov     d1, #10.00000000
0x0004cb54  fdiv     d0, d0, d1
0x0004cb58  ldp      d2, d3, [sp, #0xa8]
0x0004cb5c  fadd     d0, d0, d3
0x0004cb60  fdiv     d1, d14, d1
0x0004cb64  fcmp     d1, d2
0x0004cb68  csel     x21, x23, x20, ge
0x0004cb6c  bl       #0x55b8c   ; CALL ___sincos_stret
0x0004cb70  mov      v9.16b, v0.16b
0x0004cb74  mov      v10.16b, v1.16b
0x0004cb78  ldur     d11, [x29, #-0xa8]
0x0004cb7c  fmadd    d15, d1, d8, d11
0x0004cb80  fmadd    d13, d0, d8, d11
0x0004cb84  mov      x0, x21
0x0004cb88  bl       #0x55d84   ; CALL _objc_retain
0x0004cb8c  mov      x0, x21
0x0004cb90  mov      v0.16b, v15.16b
0x0004cb94  mov      v1.16b, v13.16b
0x0004cb98  bl       #0x59060   ; CALL objc_msgSend$moveToPoint:
0x0004cb9c  fmadd    d0, d10, d12, d11
0x0004cba0  fmadd    d1, d9, d12, d11
0x0004cba4  mov      x0, x21
0x0004cba8  bl       #0x56100   ; CALL objc_msgSend$addLineToPoint:
0x0004cbac  mov      x0, x21
0x0004cbb0  bl       #0x55d78   ; CALL _objc_release
0x0004cbb4  fmov     d0, #1.00000000
0x0004cbb8  fadd     d14, d14, d0
0x0004cbbc  subs     w22, w22, #1
0x0004cbc0  b.ne     #0x4cb48
0x0004cbc4  fmov     d0, #3.00000000
0x0004cbc8  ldr      d14, [sp, #0x50]
0x0004cbcc  fmul     d0, d14, d0
0x0004cbd0  fmov     d1, #1.00000000
0x0004cbd4  fmaxnm   d9, d0, d1
0x0004cbd8  mov      w8, #1
0x0004cbdc  adrp     x9, #0x65000
0x0004cbe0  ldr      d0, [x9, #0x838]
0x0004cbe4  str      d0, [sp, #0xb0]
0x0004cbe8  adrp     x9, #0x65000
0x0004cbec  ldr      d10, [x9, #0xff0]
0x0004cbf0  adrp     x9, #0x65000
0x0004cbf4  ldr      d15, [x9, #0xff8]
0x0004cbf8  adrp     x9, #0x65000
0x0004cbfc  ldr      d8, [x9, #0x708]
0x0004cc00  ldur     d11, [x29, #-0xa8]
0x0004cc04  ldp      d12, d13, [sp, #0x30]
0x0004cc08  mov      x25, x8
0x0004cc0c  ldr      x0, [x26, #0xb48]   ; @CLASS CAShapeLayer
0x0004cc10  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004cc14  mov      x29, x29
0x0004cc18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004cc1c  mov      x21, x0
0x0004cc20  mov      v0.16b, v12.16b
0x0004cc24  ldur     d1, [x29, #-0xa0]
0x0004cc28  mov      v2.16b, v13.16b
0x0004cc2c  mov      v3.16b, v13.16b
0x0004cc30  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0004cc34  ands     w22, w25, #1
0x0004cc38  csel     x0, x20, x23, ne
0x0004cc3c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004cc40  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x0004cc44  mov      x2, x0
0x0004cc48  mov      x0, x21
0x0004cc4c  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x0004cc50  ldr      x0, [x28, #0x910]   ; @CLASS UIColor
0x0004cc54  fmov     d0, #1.00000000
0x0004cc58  cbz      w22, #0x4cc6c
0x0004cc5c  fmov     d1, #1.00000000
0x0004cc60  fmov     d2, #1.00000000
0x0004cc64  ldr      d3, [sp, #0xb0]
0x0004cc68  b        #0x4cc78
0x0004cc6c  mov      v1.16b, v10.16b
0x0004cc70  mov      v2.16b, v15.16b
0x0004cc74  mov      v3.16b, v8.16b
0x0004cc78  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004cc7c  mov      x29, x29
0x0004cc80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004cc84  mov      x22, x0
0x0004cc88  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004cc8c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004cc90  mov      x2, x0
0x0004cc94  mov      x0, x21
0x0004cc98  bl       #0x5c380   ; CALL objc_msgSend$setStrokeColor:
0x0004cc9c  mov      x0, x22
0x0004cca0  bl       #0x55d78   ; CALL _objc_release
0x0004cca4  mov      x0, x21
0x0004cca8  mov      v0.16b, v9.16b
0x0004ccac  bl       #0x5b3a0   ; CALL objc_msgSend$setLineWidth:
0x0004ccb0  mov      x0, x24
0x0004ccb4  mov      x2, x21
0x0004ccb8  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004ccbc  mov      x0, x21
0x0004ccc0  bl       #0x55d78   ; CALL _objc_release
0x0004ccc4  mov      w8, #0
0x0004ccc8  tbnz     w25, #0, #0x4cc08
0x0004cccc  ldr      x0, [x26, #0xb48]   ; @CLASS CAShapeLayer
0x0004ccd0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004ccd4  mov      x29, x29
0x0004ccd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ccdc  mov      x21, x0
0x0004cce0  mov      v0.16b, v12.16b
0x0004cce4  ldur     d9, [x29, #-0xa0]
0x0004cce8  mov      v1.16b, v9.16b
0x0004ccec  mov      v2.16b, v13.16b
0x0004ccf0  mov      v3.16b, v13.16b
0x0004ccf4  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0004ccf8  adrp     x25, #0x8e000
0x0004ccfc  ldr      x0, [x25, #0xac0]   ; @CLASS UIBezierPath
0x0004cd00  bl       #0x567e0   ; CALL objc_msgSend$bezierPath
0x0004cd04  mov      x29, x29
0x0004cd08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004cd0c  mov      x22, x0
0x0004cd10  str      x0, [sp, #0xa8]
0x0004cd14  mov      v0.16b, v11.16b
0x0004cd18  mov      v1.16b, v11.16b
0x0004cd1c  bl       #0x59060   ; CALL objc_msgSend$moveToPoint:
0x0004cd20  mov      v8.16b, v12.16b
0x0004cd24  ldr      d12, [sp, #0x68]
0x0004cd28  fadd     d0, d12, d11
0x0004cd2c  fmov     d1, #-30.00000000
0x0004cd30  fmadd    d0, d14, d1, d0
0x0004cd34  mov      x0, x22
0x0004cd38  mov      v1.16b, v11.16b
0x0004cd3c  bl       #0x56100   ; CALL objc_msgSend$addLineToPoint:
0x0004cd40  mov      x0, x22
0x0004cd44  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004cd48  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x0004cd4c  mov      x2, x0
0x0004cd50  mov      x0, x21
0x0004cd54  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x0004cd58  ldr      x0, [x28, #0x910]   ; @CLASS UIColor
0x0004cd5c  fmov     d0, #1.00000000
0x0004cd60  fmov     d3, #1.00000000
0x0004cd64  mov      v1.16b, v10.16b
0x0004cd68  mov      v2.16b, v15.16b
0x0004cd6c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004cd70  mov      x29, x29
0x0004cd74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004cd78  mov      x22, x0
0x0004cd7c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004cd80  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004cd84  mov      x2, x0
0x0004cd88  mov      x0, x21
0x0004cd8c  bl       #0x5c380   ; CALL objc_msgSend$setStrokeColor:
0x0004cd90  mov      x0, x22
0x0004cd94  bl       #0x55d78   ; CALL _objc_release
0x0004cd98  fmov     d0, #5.00000000
0x0004cd9c  fmul     d0, d14, d0
0x0004cda0  fmov     d1, #1.50000000
0x0004cda4  fmaxnm   d0, d0, d1
0x0004cda8  mov      x0, x21
0x0004cdac  bl       #0x5b3a0   ; CALL objc_msgSend$setLineWidth:
0x0004cdb0  mov      x0, x21
0x0004cdb4  ldr      x2, [sp, #0x20]
0x0004cdb8  bl       #0x5b320   ; CALL objc_msgSend$setLineCap:
0x0004cdbc  ldr      x0, [x28, #0x910]   ; @CLASS UIColor
0x0004cdc0  fmov     d0, #1.00000000
0x0004cdc4  fmov     d3, #1.00000000
0x0004cdc8  mov      v1.16b, v10.16b
0x0004cdcc  mov      v2.16b, v15.16b
0x0004cdd0  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004cdd4  mov      x29, x29
0x0004cdd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004cddc  mov      x22, x0
0x0004cde0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004cde4  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004cde8  mov      x2, x0
0x0004cdec  mov      x0, x21
0x0004cdf0  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x0004cdf4  mov      x0, x22
0x0004cdf8  bl       #0x55d78   ; CALL _objc_release
0x0004cdfc  fmov     s0, #1.00000000
0x0004ce00  mov      x0, x21
0x0004ce04  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x0004ce08  fmov     d0, #6.00000000
0x0004ce0c  fmul     d0, d14, d0
0x0004ce10  mov      x0, x21
0x0004ce14  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x0004ce18  mov      x0, x21
0x0004ce1c  ldp      d1, d0, [sp, #0x10]
0x0004ce20  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x0004ce24  mov      x0, x24
0x0004ce28  mov      x2, x21
0x0004ce2c  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004ce30  mov      x27, x19
0x0004ce34  mov      x0, x19
0x0004ce38  str      x19, [sp, #8]
0x0004ce3c  mov      x2, x21
0x0004ce40  bl       #0x5b760   ; CALL objc_msgSend$setNeedle:
0x0004ce44  ldr      x0, [x26, #0xb48]   ; @CLASS CAShapeLayer
0x0004ce48  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004ce4c  mov      x29, x29
0x0004ce50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ce54  mov      x26, x0
0x0004ce58  mov      v0.16b, v8.16b
0x0004ce5c  mov      v1.16b, v9.16b
0x0004ce60  mov      v2.16b, v13.16b
0x0004ce64  mov      v3.16b, v13.16b
0x0004ce68  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0004ce6c  ldr      x0, [x25, #0xac0]   ; @CLASS UIBezierPath
0x0004ce70  fmov     d0, #-14.00000000
0x0004ce74  fmadd    d0, d14, d0, d11
0x0004ce78  fmov     d1, #28.00000000
0x0004ce7c  fmul     d2, d14, d1
0x0004ce80  mov      v1.16b, v0.16b
0x0004ce84  mov      v3.16b, v2.16b
0x0004ce88  bl       #0x56820   ; CALL objc_msgSend$bezierPathWithOvalInRect:
0x0004ce8c  mov      x29, x29
0x0004ce90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ce94  mov      x22, x0
0x0004ce98  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004ce9c  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x0004cea0  mov      x2, x0
0x0004cea4  mov      x0, x26
0x0004cea8  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x0004ceac  mov      x0, x22
0x0004ceb0  bl       #0x55d78   ; CALL _objc_release
0x0004ceb4  ldr      x0, [x28, #0x910]   ; @CLASS UIColor
0x0004ceb8  adrp     x8, #0x66000
0x0004cebc  ldr      d0, [x8]
0x0004cec0  fmov     d3, #1.00000000
0x0004cec4  mov      v1.16b, v0.16b
0x0004cec8  mov      v2.16b, v0.16b
0x0004cecc  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004ced0  mov      x29, x29
0x0004ced4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ced8  mov      x22, x0
0x0004cedc  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004cee0  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004cee4  mov      x2, x0
0x0004cee8  mov      x0, x26
0x0004ceec  bl       #0x5ae40   ; CALL objc_msgSend$setFillColor:
0x0004cef0  mov      x0, x22
0x0004cef4  bl       #0x55d78   ; CALL _objc_release
0x0004cef8  mov      x0, x24
0x0004cefc  mov      x2, x26
0x0004cf00  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004cf04  adrp     x8, #0x65000
0x0004cf08  ldr      d8, [x8, #0x6c0]
0x0004cf0c  ldr      d13, [sp, #0x60]
0x0004cf10  fmadd    d9, d12, d8, d13
0x0004cf14  adrp     x8, #0x74000
0x0004cf18  ldr      x8, [x8, #0x238]   ; @GOT _UIFontWeightBold
0x0004cf1c  ldr      d3, [x8]   ; @GOT ___objc_personality_v0
0x0004cf20  adrp     x2, #0x7d000
0x0004cf24  add      x2, x2, #0x428   ; STR "888"
0x0004cf28  mov      x8, #0x4047000000000000
0x0004cf2c  fmov     d2, x8
0x0004cf30  fmov     d4, xzr
0x0004cf34  ldr      x19, [sp, #0x78]
0x0004cf38  mov      x0, x19
0x0004cf3c  ldr      d11, [sp, #0x70]
0x0004cf40  mov      v0.16b, v11.16b
0x0004cf44  mov      v1.16b, v9.16b
0x0004cf48  mov      x3, #0
0x0004cf4c  mov      w4, #0
0x0004cf50  ldr      x25, [sp, #0x88]
0x0004cf54  mov      x5, x25
0x0004cf58  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x0004cf5c  mov      x29, x29
0x0004cf60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004cf64  mov      x22, x0
0x0004cf68  adrp     x2, #0x77000
0x0004cf6c  add      x2, x2, #0x428   ; STR "0"
0x0004cf70  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0004cf74  mov      x0, x27
0x0004cf78  mov      x2, x22
0x0004cf7c  bl       #0x5b7e0   ; CALL objc_msgSend$setNumber:
0x0004cf80  mov      x8, #0x4043000000000000
0x0004cf84  fmov     d0, x8
0x0004cf88  fmadd    d1, d14, d0, d9
0x0004cf8c  adrp     x8, #0x74000
0x0004cf90  ldr      x8, [x8, #0x260]   ; @GOT _UIFontWeightSemibold
0x0004cf94  ldr      d9, [x8]   ; @GOT ___objc_personality_v0
0x0004cf98  fadd     d10, d12, d12
0x0004cf9c  fmov     d2, #20.00000000
0x0004cfa0  mov      x0, x19
0x0004cfa4  ldr      x2, [sp, #0x90]
0x0004cfa8  mov      v0.16b, v11.16b
0x0004cfac  mov      v3.16b, v9.16b
0x0004cfb0  mov      x3, #0
0x0004cfb4  mov      w4, #0
0x0004cfb8  mov      x5, x25
0x0004cfbc  mov      v4.16b, v10.16b
0x0004cfc0  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x0004cfc4  mov      x29, x29
0x0004cfc8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004cfcc  mov      x27, x0
0x0004cfd0  ldr      d0, [sp, #0xb0]
0x0004cfd4  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x0004cfd8  adrp     x8, #0x65000
0x0004cfdc  ldr      d0, [x8, #0xf70]
0x0004cfe0  fmadd    d1, d12, d0, d13
0x0004cfe4  fmov     d2, #18.00000000
0x0004cfe8  mov      x0, x19
0x0004cfec  ldr      x2, [sp, #0x98]
0x0004cff0  mov      v0.16b, v11.16b
0x0004cff4  mov      v3.16b, v9.16b
0x0004cff8  mov      x3, #0
0x0004cffc  mov      w4, #0
0x0004d000  mov      x5, x25
0x0004d004  mov      v4.16b, v10.16b
0x0004d008  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x0004d00c  mov      x29, x29
0x0004d010  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d014  mov      x28, x0
0x0004d018  mov      v0.16b, v8.16b
0x0004d01c  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x0004d020  adrp     x8, #0x8f000
0x0004d024  ldrsw    x8, [x8, #0x8c]
0x0004d028  ldr      x0, [x19, x8]
0x0004d02c  ldr      x19, [sp, #8]
0x0004d030  mov      x2, x19
0x0004d034  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0004d038  mov      x0, x28
0x0004d03c  bl       #0x55d78   ; CALL _objc_release
0x0004d040  mov      x0, x27
0x0004d044  bl       #0x55d78   ; CALL _objc_release
0x0004d048  mov      x0, x22
0x0004d04c  bl       #0x55d78   ; CALL _objc_release
0x0004d050  mov      x0, x26
0x0004d054  bl       #0x55d78   ; CALL _objc_release
0x0004d058  ldr      x0, [sp, #0xa8]
0x0004d05c  bl       #0x55d78   ; CALL _objc_release
0x0004d060  mov      x0, x21
0x0004d064  bl       #0x55d78   ; CALL _objc_release
0x0004d068  mov      x0, x23
0x0004d06c  bl       #0x55d78   ; CALL _objc_release
0x0004d070  mov      x0, x20
0x0004d074  bl       #0x55d78   ; CALL _objc_release
0x0004d078  ldr      x0, [sp, #0x28]
0x0004d07c  bl       #0x55d78   ; CALL _objc_release
0x0004d080  ldr      x0, [sp, #0x40]
0x0004d084  bl       #0x55d78   ; CALL _objc_release
0x0004d088  ldr      x0, [sp, #0x48]
0x0004d08c  bl       #0x55d78   ; CALL _objc_release
0x0004d090  ldr      x0, [sp, #0x58]
0x0004d094  bl       #0x55d78   ; CALL _objc_release
0x0004d098  mov      x0, x24
0x0004d09c  bl       #0x55d78   ; CALL _objc_release
0x0004d0a0  ldr      x0, [sp, #0x80]
0x0004d0a4  bl       #0x55d78   ; CALL _objc_release
0x0004d0a8  mov      x0, x25
0x0004d0ac  bl       #0x55d78   ; CALL _objc_release
0x0004d0b0  ldr      x0, [sp, #0x90]
0x0004d0b4  bl       #0x55d78   ; CALL _objc_release
0x0004d0b8  ldr      x0, [sp, #0x98]
0x0004d0bc  bl       #0x55d78   ; CALL _objc_release
0x0004d0c0  mov      x0, x19
0x0004d0c4  ldp      x29, x30, [sp, #0x160]
0x0004d0c8  ldp      x20, x19, [sp, #0x150]
0x0004d0cc  ldp      x22, x21, [sp, #0x140]
0x0004d0d0  ldp      x24, x23, [sp, #0x130]
0x0004d0d4  ldp      x26, x25, [sp, #0x120]
0x0004d0d8  ldp      x28, x27, [sp, #0x110]
0x0004d0dc  ldp      d9, d8, [sp, #0x100]
0x0004d0e0  ldp      d11, d10, [sp, #0xf0]
0x0004d0e4  ldp      d13, d12, [sp, #0xe0]
0x0004d0e8  ldp      d15, d14, [sp, #0xd0]
0x0004d0ec  add      sp, sp, #0x170
0x0004d0f0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[SSStartupView ss_buildEngine]  va=0x4d0f4 size=2728 types=v16@0:8
0x0004d0f4  sub      sp, sp, #0x1d0
0x0004d0f8  stp      d15, d14, [sp, #0x130]
0x0004d0fc  stp      d13, d12, [sp, #0x140]
0x0004d100  stp      d11, d10, [sp, #0x150]
0x0004d104  stp      d9, d8, [sp, #0x160]
0x0004d108  stp      x28, x27, [sp, #0x170]
0x0004d10c  stp      x26, x25, [sp, #0x180]
0x0004d110  stp      x24, x23, [sp, #0x190]
0x0004d114  stp      x22, x21, [sp, #0x1a0]
0x0004d118  stp      x20, x19, [sp, #0x1b0]
0x0004d11c  stp      x29, x30, [sp, #0x1c0]
0x0004d120  add      x29, sp, #0x1c0
0x0004d124  mov      x20, x0
0x0004d128  adrp     x8, #0x74000
0x0004d12c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0004d130  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0004d134  stur     x8, [x29, #-0xa0]
0x0004d138  adrp     x8, #0x8f000
0x0004d13c  ldrsw    x25, [x8, #0xcc]
0x0004d140  ldr      d12, [x0, x25]
0x0004d144  bl       #0x5d1a0   ; CALL objc_msgSend$ss_host
0x0004d148  mov      x29, x29
0x0004d14c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d150  mov      x19, x0
0x0004d154  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004d158  mov      x29, x29
0x0004d15c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d160  mov      x21, x0
0x0004d164  adrp     x8, #0x8f000
0x0004d168  ldrsw    x8, [x8, #0x54]
0x0004d16c  ldr      q0, [x20, x8]
0x0004d170  fmov     v1.2d, #0.50000000
0x0004d174  fmul     v0.2d, v0.2d, v1.2d
0x0004d178  str      q0, [sp, #0x50]
0x0004d17c  adrp     x23, #0x8e000
0x0004d180  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0004d184  adrp     x8, #0x65000
0x0004d188  ldr      d0, [x8, #0xf40]
0x0004d18c  adrp     x8, #0x65000
0x0004d190  ldr      d1, [x8, #0x650]
0x0004d194  adrp     x8, #0x66000
0x0004d198  ldr      d2, [x8, #8]
0x0004d19c  adrp     x8, #0x65000
0x0004d1a0  ldr      d3, [x8, #0x660]
0x0004d1a4  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004d1a8  mov      x29, x29
0x0004d1ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d1b0  mov      x22, x0
0x0004d1b4  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x0004d1b8  fmov     d0, xzr
0x0004d1bc  fmov     d1, xzr
0x0004d1c0  fmov     d2, xzr
0x0004d1c4  fmov     d3, xzr
0x0004d1c8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004d1cc  mov      x29, x29
0x0004d1d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d1d4  mov      x23, x0
0x0004d1d8  ldr      q0, [sp, #0x50]
0x0004d1dc  mov      d1, v0.d[1]
0x0004d1e0  mov      v2.16b, v0.16b
0x0004d1e4  mov      x0, x22
0x0004d1e8  mov      x1, x23
0x0004d1ec  bl       #0x4c190
0x0004d1f0  mov      x29, x29
0x0004d1f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d1f8  mov      x24, x0
0x0004d1fc  mov      x0, x21
0x0004d200  mov      x2, x24
0x0004d204  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004d208  mov      x0, x24
0x0004d20c  bl       #0x55d78   ; CALL _objc_release
0x0004d210  mov      x0, x23
0x0004d214  bl       #0x55d78   ; CALL _objc_release
0x0004d218  mov      x0, x22
0x0004d21c  bl       #0x55d78   ; CALL _objc_release
0x0004d220  mov      x0, x21
0x0004d224  bl       #0x55d78   ; CALL _objc_release
0x0004d228  adrp     x8, #0x8e000
0x0004d22c  ldr      x0, [x8, #0xa08]   ; @CLASS NSLocale
0x0004d230  bl       #0x57460   ; CALL objc_msgSend$currentLocale
0x0004d234  mov      x29, x29
0x0004d238  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d23c  mov      x22, x0
0x0004d240  bl       #0x5de80   ; CALL objc_msgSend$usesMetricSystem
0x0004d244  mov      x21, x0
0x0004d248  mov      x0, x22
0x0004d24c  bl       #0x55d78   ; CALL _objc_release
0x0004d250  adrp     x8, #0x8f000
0x0004d254  ldrsw    x23, [x8, #0xd0]
0x0004d258  ldr      d0, [x20, x23]
0x0004d25c  ldr      d1, [x20, x25]
0x0004d260  adrp     x8, #0x66000
0x0004d264  ldr      d2, [x8, #0x10]
0x0004d268  fmadd    d8, d1, d2, d0
0x0004d26c  adrp     x8, #0x8f000
0x0004d270  ldrsw    x24, [x8, #0xd4]
0x0004d274  ldr      d0, [x20, x24]
0x0004d278  mov      x8, #0x4074000000000000
0x0004d27c  fmov     d11, x8
0x0004d280  fmadd    d9, d1, d11, d0
0x0004d284  adrp     x8, #0x65000
0x0004d288  ldr      d0, [x8, #0x9b8]
0x0004d28c  fmul     d10, d12, d0
0x0004d290  adrp     x0, #0x7d000
0x0004d294  add      x0, x0, #0x448   ; STR "VÒNG TUA"
0x0004d298  adrp     x1, #0x7d000
0x0004d29c  add      x1, x1, #0x468   ; STR "RPM"
0x0004d2a0  bl       #0x5505c   ; CALL _OMCTr
0x0004d2a4  mov      x29, x29
0x0004d2a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d2ac  mov      x22, x0
0x0004d2b0  adrp     x3, #0x7d000
0x0004d2b4  add      x3, x3, #0x488   ; STR "x1000 rpm"
0x0004d2b8  adrp     x8, #0x65000
0x0004d2bc  ldr      d4, [x8, #0x670]
0x0004d2c0  fmov     d3, #8.00000000
0x0004d2c4  mov      x0, x20
0x0004d2c8  mov      v0.16b, v8.16b
0x0004d2cc  mov      v1.16b, v9.16b
0x0004d2d0  mov      v2.16b, v10.16b
0x0004d2d4  mov      x2, x22
0x0004d2d8  mov      x4, x19
0x0004d2dc  bl       #0x5d180   ; CALL objc_msgSend$ss_gaugeAt:radius:label:unit:max:red:in:
0x0004d2e0  mov      x29, x29
0x0004d2e4  bl       #0x55dfc   ; CALL _objc_unsafeClaimAutoreleasedReturnValue
0x0004d2e8  mov      x0, x22
0x0004d2ec  bl       #0x55d78   ; CALL _objc_release
0x0004d2f0  stp      x23, x25, [sp, #0x40]
0x0004d2f4  ldr      d0, [x20, x23]
0x0004d2f8  ldr      d1, [x20, x25]
0x0004d2fc  adrp     x8, #0x66000
0x0004d300  ldr      d2, [x8, #0x18]
0x0004d304  fmadd    d8, d1, d2, d0
0x0004d308  str      x24, [sp, #0x38]
0x0004d30c  ldr      d0, [x20, x24]
0x0004d310  fmadd    d9, d1, d11, d0
0x0004d314  adrp     x0, #0x7d000
0x0004d318  add      x0, x0, #0x4a8   ; STR "TỐC ĐỘ"
0x0004d31c  adrp     x1, #0x7d000
0x0004d320  add      x1, x1, #0x4c8   ; STR "SPEED"
0x0004d324  bl       #0x5505c   ; CALL _OMCTr
0x0004d328  mov      x29, x29
0x0004d32c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d330  mov      x22, x0
0x0004d334  adrp     x8, #0x7d000
0x0004d338  add      x8, x8, #0x4e8   ; STR "mph"
0x0004d33c  adrp     x9, #0x7b000
0x0004d340  add      x9, x9, #0x428   ; STR "km/h"
0x0004d344  cmp      w21, #0
0x0004d348  csel     x3, x9, x8, ne
0x0004d34c  adrp     x8, #0x65000
0x0004d350  ldr      d0, [x8, #0xb90]
0x0004d354  adrp     x8, #0x65000
0x0004d358  ldr      d1, [x8, #0xc78]
0x0004d35c  fcsel    d3, d1, d0, ne
0x0004d360  adrp     x8, #0x65000
0x0004d364  ldr      d4, [x8, #0x708]
0x0004d368  mov      x0, x20
0x0004d36c  mov      v0.16b, v8.16b
0x0004d370  mov      v1.16b, v9.16b
0x0004d374  mov      v2.16b, v10.16b
0x0004d378  mov      x2, x22
0x0004d37c  str      x19, [sp, #0x50]
0x0004d380  mov      x4, x19
0x0004d384  bl       #0x5d180   ; CALL objc_msgSend$ss_gaugeAt:radius:label:unit:max:red:in:
0x0004d388  mov      x29, x29
0x0004d38c  bl       #0x55dfc   ; CALL _objc_unsafeClaimAutoreleasedReturnValue
0x0004d390  mov      x0, x22
0x0004d394  bl       #0x55d78   ; CALL _objc_release
0x0004d398  adrp     x8, #0x8e000
0x0004d39c  ldr      x0, [x8, #0xa70]   ; @CLASS UIImageSymbolConfiguration
0x0004d3a0  fmov     d0, #30.00000000
0x0004d3a4  str      d12, [sp]
0x0004d3a8  fmul     d0, d12, d0
0x0004d3ac  fmov     d1, #6.00000000
0x0004d3b0  fmaxnm   d0, d0, d1
0x0004d3b4  mov      w2, #7
0x0004d3b8  bl       #0x57100   ; CALL objc_msgSend$configurationWithPointSize:weight:
0x0004d3bc  mov      x29, x29
0x0004d3c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d3c4  mov      x21, x0
0x0004d3c8  adrp     x0, #0x7f000
0x0004d3cc  add      x0, x0, #0xf30
0x0004d3d0  bl       #0x573c0   ; CALL objc_msgSend$count
0x0004d3d4  cbz      x0, #0x4d7a8
0x0004d3d8  mov      x22, #0
0x0004d3dc  adrp     x8, #0x74000
0x0004d3e0  ldr      x8, [x8, #0x618]   ; @GOT _CGSizeZero
0x0004d3e4  fmov     d0, #5.00000000
0x0004d3e8  ldr      d1, [sp]
0x0004d3ec  fmul     d2, d1, d0
0x0004d3f0  ldp      d1, d0, [x8]
0x0004d3f4  stp      d1, d2, [sp, #0x20]
0x0004d3f8  str      d0, [sp, #0x18]
0x0004d3fc  adrp     x19, #0x7f000
0x0004d400  add      x19, x19, #0xf30
0x0004d404  adrp     x8, #0x74000
0x0004d408  ldr      x8, [x8, #0x240]   ; @GOT _UIFontWeightHeavy
0x0004d40c  ldr      d0, [x8]   ; @GOT ___objc_personality_v0
0x0004d410  str      d0, [sp, #8]
0x0004d414  adrp     x8, #0x65000
0x0004d418  ldr      d8, [x8, #0x688]
0x0004d41c  mov      x8, #0x405e000000000000
0x0004d420  str      x8, [sp, #0x30]
0x0004d424  adrp     x8, #0x65000
0x0004d428  ldr      d12, [x8, #0x608]
0x0004d42c  adrp     x8, #0x65000
0x0004d430  ldr      d13, [x8, #0x9a0]
0x0004d434  adrp     x8, #0x65000
0x0004d438  ldr      d10, [x8, #0xeb8]
0x0004d43c  adrp     x8, #0x65000
0x0004d440  ldr      d14, [x8, #0x5f0]
0x0004d444  adrp     x8, #0x66000
0x0004d448  ldr      d9, [x8, #0x20]
0x0004d44c  adrp     x23, #0x8e000
0x0004d450  adrp     x8, #0x66000
0x0004d454  ldr      s0, [x8, #0x2bc]
0x0004d458  str      s0, [sp, #0x14]
0x0004d45c  mov      x0, x19
0x0004d460  mov      x2, x22
0x0004d464  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0004d468  mov      x29, x29
0x0004d46c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d470  mov      x26, x0
0x0004d474  mov      x2, #0
0x0004d478  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0004d47c  mov      x29, x29
0x0004d480  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d484  mov      x25, x0
0x0004d488  mov      x0, x26
0x0004d48c  bl       #0x55d78   ; CALL _objc_release
0x0004d490  mov      x0, x19
0x0004d494  mov      x2, x22
0x0004d498  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0004d49c  mov      x29, x29
0x0004d4a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d4a4  mov      x27, x0
0x0004d4a8  mov      w2, #1
0x0004d4ac  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0004d4b0  mov      x29, x29
0x0004d4b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d4b8  mov      x28, x0
0x0004d4bc  bl       #0x5dca0   ; CALL objc_msgSend$unsignedIntValue
0x0004d4c0  adrp     x8, #0x8e000
0x0004d4c4  ldr      x8, [x8, #0x910]   ; @CLASS UIColor
0x0004d4c8  ubfx     w9, w0, #0x10, #8
0x0004d4cc  ucvtf    d0, w9
0x0004d4d0  ubfx     w9, w0, #8, #8
0x0004d4d4  ucvtf    d1, w9
0x0004d4d8  fdiv     d0, d0, d8
0x0004d4dc  fdiv     d1, d1, d8
0x0004d4e0  and      w9, w0, #0xff
0x0004d4e4  ucvtf    d2, w9
0x0004d4e8  fdiv     d2, d2, d8
0x0004d4ec  fmov     d3, #1.00000000
0x0004d4f0  mov      x0, x8
0x0004d4f4  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004d4f8  mov      x29, x29
0x0004d4fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d500  mov      x26, x0
0x0004d504  mov      x0, x28
0x0004d508  bl       #0x55d78   ; CALL _objc_release
0x0004d50c  mov      x0, x27
0x0004d510  bl       #0x55d78   ; CALL _objc_release
0x0004d514  ldr      x8, [sp, #0x40]
0x0004d518  ldr      d0, [x20, x8]
0x0004d51c  mov      w8, #0x50
0x0004d520  mov      x9, #0x258
0x0004d524  madd     x8, x22, x8, x9
0x0004d528  ucvtf    d1, x8
0x0004d52c  ldr      x8, [sp, #0x48]
0x0004d530  ldr      d2, [x20, x8]
0x0004d534  ldr      x8, [sp, #0x38]
0x0004d538  ldr      d3, [x20, x8]
0x0004d53c  fmadd    d11, d1, d2, d0
0x0004d540  ldr      d0, [sp, #0x30]
0x0004d544  fmadd    d15, d2, d0, d3
0x0004d548  movi     v0.16b, #0
0x0004d54c  stp      q0, q0, [sp, #0x60]
0x0004d550  stp      q0, q0, [sp, #0x80]
0x0004d554  mov      x0, x25
0x0004d558  bl       #0x55d84   ; CALL _objc_retain
0x0004d55c  add      x2, sp, #0x60
0x0004d560  add      x3, sp, #0xa0
0x0004d564  mov      x0, x25
0x0004d568  mov      w4, #0x10
0x0004d56c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0004d570  cbz      x0, #0x4d5e4
0x0004d574  mov      x27, x0
0x0004d578  ldr      x8, [sp, #0x70]
0x0004d57c  ldr      x19, [x8]   ; @SEL "whatsNewNavigationController"
0x0004d580  mov      x24, #0
0x0004d584  ldr      x8, [sp, #0x70]
0x0004d588  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0004d58c  cmp      x8, x19
0x0004d590  b.eq     #0x4d59c
0x0004d594  mov      x0, x25
0x0004d598  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0004d59c  ldr      x8, [sp, #0x68]
0x0004d5a0  ldr      x2, [x8, x24, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0004d5a4  ldr      x0, [x23, #0xa78]   ; @CLASS UIImage
0x0004d5a8  mov      x3, x21
0x0004d5ac  bl       #0x5d840   ; CALL objc_msgSend$systemImageNamed:withConfiguration:
0x0004d5b0  mov      x29, x29
0x0004d5b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d5b8  cbnz     x0, #0x4d62c
0x0004d5bc  add      x24, x24, #1
0x0004d5c0  cmp      x27, x24
0x0004d5c4  b.ne     #0x4d584
0x0004d5c8  add      x2, sp, #0x60
0x0004d5cc  add      x3, sp, #0xa0
0x0004d5d0  mov      x0, x25
0x0004d5d4  mov      w4, #0x10
0x0004d5d8  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0004d5dc  mov      x27, x0
0x0004d5e0  cbnz     x0, #0x4d580
0x0004d5e4  mov      x0, x25
0x0004d5e8  bl       #0x55d78   ; CALL _objc_release
0x0004d5ec  fmov     d2, #26.00000000
0x0004d5f0  fmov     d4, xzr
0x0004d5f4  mov      x0, x20
0x0004d5f8  adrp     x2, #0x7d000
0x0004d5fc  add      x2, x2, #0x5e8   ; STR "ABS"
0x0004d600  mov      v0.16b, v11.16b
0x0004d604  mov      v1.16b, v15.16b
0x0004d608  ldr      d3, [sp, #8]
0x0004d60c  mov      x3, x26
0x0004d610  mov      w4, #0
0x0004d614  ldr      x5, [sp, #0x50]
0x0004d618  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x0004d61c  mov      x29, x29
0x0004d620  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d624  mov      x27, x0
0x0004d628  b        #0x4d730
0x0004d62c  mov      x28, x0
0x0004d630  mov      x0, x25
0x0004d634  bl       #0x55d78   ; CALL _objc_release
0x0004d638  adrp     x8, #0x8e000
0x0004d63c  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x0004d640  bl       #0x55c7c   ; CALL _objc_alloc
0x0004d644  mov      x2, x28
0x0004d648  bl       #0x584c0   ; CALL objc_msgSend$initWithImage:
0x0004d64c  mov      x27, x0
0x0004d650  mov      x2, x26
0x0004d654  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x0004d658  mov      x0, x27
0x0004d65c  mov      w2, #1
0x0004d660  bl       #0x5aa40   ; CALL objc_msgSend$setContentMode:
0x0004d664  mov      x0, x27
0x0004d668  bl       #0x5cbe0   ; CALL objc_msgSend$sizeToFit
0x0004d66c  mov      x0, x27
0x0004d670  mov      v0.16b, v11.16b
0x0004d674  mov      v1.16b, v15.16b
0x0004d678  bl       #0x5a840   ; CALL objc_msgSend$setCenter:
0x0004d67c  mov      x0, x26
0x0004d680  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004d684  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004d688  mov      x24, x0
0x0004d68c  mov      x0, x27
0x0004d690  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004d694  mov      x29, x29
0x0004d698  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d69c  mov      x19, x0
0x0004d6a0  mov      x2, x24
0x0004d6a4  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x0004d6a8  mov      x0, x19
0x0004d6ac  bl       #0x55d78   ; CALL _objc_release
0x0004d6b0  mov      x0, x27
0x0004d6b4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004d6b8  mov      x29, x29
0x0004d6bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d6c0  mov      x19, x0
0x0004d6c4  ldr      s0, [sp, #0x14]
0x0004d6c8  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x0004d6cc  mov      x0, x19
0x0004d6d0  bl       #0x55d78   ; CALL _objc_release
0x0004d6d4  mov      x0, x27
0x0004d6d8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004d6dc  mov      x29, x29
0x0004d6e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d6e4  mov      x19, x0
0x0004d6e8  ldr      d0, [sp, #0x28]
0x0004d6ec  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x0004d6f0  mov      x0, x19
0x0004d6f4  bl       #0x55d78   ; CALL _objc_release
0x0004d6f8  mov      x0, x27
0x0004d6fc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004d700  mov      x29, x29
0x0004d704  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d708  mov      x19, x0
0x0004d70c  ldp      d1, d0, [sp, #0x18]
0x0004d710  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x0004d714  mov      x0, x19
0x0004d718  bl       #0x55d78   ; CALL _objc_release
0x0004d71c  ldr      x0, [sp, #0x50]
0x0004d720  mov      x2, x27
0x0004d724  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0004d728  mov      x0, x28
0x0004d72c  bl       #0x55d78   ; CALL _objc_release
0x0004d730  fmov     d0, xzr
0x0004d734  mov      x0, x20
0x0004d738  mov      x2, x27
0x0004d73c  mov      v1.16b, v12.16b
0x0004d740  mov      v2.16b, v13.16b
0x0004d744  bl       #0x5d160   ; CALL objc_msgSend$ss_fade:from:to:alpha:
0x0004d748  mov      x29, x29
0x0004d74c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d750  mov      x19, x0
0x0004d754  ucvtf    d11, x22
0x0004d758  fmadd    d0, d11, d14, d10
0x0004d75c  bl       #0x5b980   ; CALL objc_msgSend$setOutA:
0x0004d760  fmadd    d0, d11, d14, d9
0x0004d764  mov      x0, x19
0x0004d768  bl       #0x5b9a0   ; CALL objc_msgSend$setOutB:
0x0004d76c  mov      x0, x19
0x0004d770  bl       #0x55d78   ; CALL _objc_release
0x0004d774  mov      x0, x27
0x0004d778  bl       #0x55d78   ; CALL _objc_release
0x0004d77c  mov      x0, x26
0x0004d780  bl       #0x55d78   ; CALL _objc_release
0x0004d784  mov      x0, x25
0x0004d788  bl       #0x55d78   ; CALL _objc_release
0x0004d78c  add      x22, x22, #1
0x0004d790  adrp     x19, #0x7f000
0x0004d794  add      x19, x19, #0xf30
0x0004d798  mov      x0, x19
0x0004d79c  bl       #0x573c0   ; CALL objc_msgSend$count
0x0004d7a0  cmp      x22, x0
0x0004d7a4  b.lo     #0x4d45c
0x0004d7a8  mov      x0, x20
0x0004d7ac  bl       #0x56be0   ; CALL objc_msgSend$carName
0x0004d7b0  mov      x29, x29
0x0004d7b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d7b8  mov      x23, x0
0x0004d7bc  bl       #0x4da60
0x0004d7c0  mov      x29, x29
0x0004d7c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d7c8  mov      x24, x0
0x0004d7cc  bl       #0x58c20   ; CALL objc_msgSend$length
0x0004d7d0  cbz      x0, #0x4d804
0x0004d7d4  mov      x0, x20
0x0004d7d8  bl       #0x56be0   ; CALL objc_msgSend$carName
0x0004d7dc  mov      x29, x29
0x0004d7e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d7e4  mov      x19, x0
0x0004d7e8  bl       #0x4da60
0x0004d7ec  mov      x29, x29
0x0004d7f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d7f4  mov      x25, x0
0x0004d7f8  mov      x0, x19
0x0004d7fc  bl       #0x55d78   ; CALL _objc_release
0x0004d800  b        #0x4d80c
0x0004d804  adrp     x25, #0x75000
0x0004d808  add      x25, x25, #0x508   ; STR "OmniCar"
0x0004d80c  str      x25, [sp, #0x28]
0x0004d810  mov      x0, x24
0x0004d814  bl       #0x55d78   ; CALL _objc_release
0x0004d818  mov      x0, x23
0x0004d81c  bl       #0x55d78   ; CALL _objc_release
0x0004d820  mov      x8, #0x4084000000000000
0x0004d824  fmov     d0, x8
0x0004d828  ldp      x22, x27, [sp, #0x40]
0x0004d82c  ldr      d1, [x20, x22]
0x0004d830  ldr      d9, [sp]
0x0004d834  fmul     d8, d9, d0
0x0004d838  ldr      d2, [x20, x27]
0x0004d83c  mov      x8, #0x4089000000000000
0x0004d840  fmov     d10, x8
0x0004d844  fmadd    d0, d2, d10, d1
0x0004d848  ldr      x23, [sp, #0x38]
0x0004d84c  ldr      d1, [x20, x23]
0x0004d850  adrp     x8, #0x65000
0x0004d854  ldr      d3, [x8, #0x638]
0x0004d858  fmadd    d1, d2, d3, d1
0x0004d85c  adrp     x8, #0x74000
0x0004d860  ldr      x8, [x8, #0x240]   ; @GOT _UIFontWeightHeavy
0x0004d864  ldr      d3, [x8]   ; @GOT ___objc_personality_v0
0x0004d868  adrp     x8, #0x65000
0x0004d86c  ldr      d2, [x8, #0xa00]
0x0004d870  mov      x0, x20
0x0004d874  mov      x2, x25
0x0004d878  mov      x3, #0
0x0004d87c  mov      w4, #0
0x0004d880  ldr      x28, [sp, #0x50]
0x0004d884  mov      x5, x28
0x0004d888  mov      v4.16b, v8.16b
0x0004d88c  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x0004d890  mov      x29, x29
0x0004d894  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d898  mov      x2, x0
0x0004d89c  str      x0, [sp, #0x30]
0x0004d8a0  fmov     d0, #-10.00000000
0x0004d8a4  fmul     d9, d9, d0
0x0004d8a8  adrp     x8, #0x66000
0x0004d8ac  ldr      d0, [x8, #0x28]
0x0004d8b0  adrp     x8, #0x66000
0x0004d8b4  ldr      d1, [x8, #0x30]
0x0004d8b8  fmov     d2, #1.00000000
0x0004d8bc  mov      x0, x20
0x0004d8c0  bl       #0x5d160   ; CALL objc_msgSend$ss_fade:from:to:alpha:
0x0004d8c4  mov      x29, x29
0x0004d8c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d8cc  mov      x19, x0
0x0004d8d0  mov      v0.16b, v9.16b
0x0004d8d4  bl       #0x5be80   ; CALL objc_msgSend$setRise:
0x0004d8d8  mov      x0, x19
0x0004d8dc  bl       #0x55d78   ; CALL _objc_release
0x0004d8e0  adrp     x0, #0x7d000
0x0004d8e4  add      x0, x0, #0x608   ; STR "Xe của bạn đã sẵn sàng, %@"
0x0004d8e8  adrp     x1, #0x7d000
0x0004d8ec  add      x1, x1, #0x628   ; STR "Your car is ready, %@"
0x0004d8f0  bl       #0x5505c   ; CALL _OMCTr
0x0004d8f4  mov      x29, x29
0x0004d8f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d8fc  mov      x24, x0
0x0004d900  adrp     x0, #0x7d000
0x0004d904  add      x0, x0, #0x648   ; STR "Xe của bạn đã sẵn sàng"
0x0004d908  adrp     x1, #0x7d000
0x0004d90c  add      x1, x1, #0x668   ; STR "Your car is ready"
0x0004d910  bl       #0x5505c   ; CALL _OMCTr
0x0004d914  mov      x29, x29
0x0004d918  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d91c  mov      x19, x0
0x0004d920  mov      x0, x20
0x0004d924  bl       #0x590e0   ; CALL objc_msgSend$name
0x0004d928  mov      x29, x29
0x0004d92c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d930  mov      x25, x0
0x0004d934  mov      x0, x24
0x0004d938  mov      x1, x19
0x0004d93c  mov      x2, x25
0x0004d940  bl       #0x4daf4
0x0004d944  mov      x29, x29
0x0004d948  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d94c  mov      x26, x0
0x0004d950  ldr      d0, [x20, x22]
0x0004d954  ldr      d1, [x20, x27]
0x0004d958  fmadd    d0, d1, d10, d0
0x0004d95c  ldr      d2, [x20, x23]
0x0004d960  adrp     x8, #0x66000
0x0004d964  ldr      d3, [x8, #0x38]
0x0004d968  fmadd    d1, d1, d3, d2
0x0004d96c  adrp     x8, #0x74000
0x0004d970  ldr      x8, [x8, #0x260]   ; @GOT _UIFontWeightSemibold
0x0004d974  ldr      d3, [x8]   ; @GOT ___objc_personality_v0
0x0004d978  fmov     d2, #30.00000000
0x0004d97c  mov      x0, x20
0x0004d980  mov      x2, x26
0x0004d984  mov      x3, #0
0x0004d988  mov      w4, #0
0x0004d98c  mov      x5, x28
0x0004d990  mov      v4.16b, v8.16b
0x0004d994  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x0004d998  mov      x29, x29
0x0004d99c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004d9a0  mov      x27, x0
0x0004d9a4  mov      x0, x26
0x0004d9a8  bl       #0x55d78   ; CALL _objc_release
0x0004d9ac  mov      x0, x25
0x0004d9b0  bl       #0x55d78   ; CALL _objc_release
0x0004d9b4  mov      x0, x19
0x0004d9b8  bl       #0x55d78   ; CALL _objc_release
0x0004d9bc  mov      x0, x24
0x0004d9c0  bl       #0x55d78   ; CALL _objc_release
0x0004d9c4  adrp     x8, #0x65000
0x0004d9c8  ldr      d0, [x8, #0xfa8]
0x0004d9cc  adrp     x8, #0x66000
0x0004d9d0  ldr      d1, [x8, #0x40]
0x0004d9d4  fmov     d2, #1.00000000
0x0004d9d8  mov      x0, x20
0x0004d9dc  mov      x2, x27
0x0004d9e0  bl       #0x5d160   ; CALL objc_msgSend$ss_fade:from:to:alpha:
0x0004d9e4  mov      x29, x29
0x0004d9e8  bl       #0x55dfc   ; CALL _objc_unsafeClaimAutoreleasedReturnValue
0x0004d9ec  mov      x0, x27
0x0004d9f0  bl       #0x55d78   ; CALL _objc_release
0x0004d9f4  ldr      x0, [sp, #0x30]
0x0004d9f8  bl       #0x55d78   ; CALL _objc_release
0x0004d9fc  ldr      x0, [sp, #0x28]
0x0004da00  bl       #0x55d78   ; CALL _objc_release
0x0004da04  mov      x0, x21
0x0004da08  bl       #0x55d78   ; CALL _objc_release
0x0004da0c  mov      x0, x28
0x0004da10  bl       #0x55d78   ; CALL _objc_release
0x0004da14  ldur     x8, [x29, #-0xa0]
0x0004da18  adrp     x9, #0x74000
0x0004da1c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0004da20  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0004da24  cmp      x9, x8
0x0004da28  b.ne     #0x4da5c
0x0004da2c  ldp      x29, x30, [sp, #0x1c0]
0x0004da30  ldp      x20, x19, [sp, #0x1b0]
0x0004da34  ldp      x22, x21, [sp, #0x1a0]
0x0004da38  ldp      x24, x23, [sp, #0x190]
0x0004da3c  ldp      x26, x25, [sp, #0x180]
0x0004da40  ldp      x28, x27, [sp, #0x170]
0x0004da44  ldp      d9, d8, [sp, #0x160]
0x0004da48  ldp      d11, d10, [sp, #0x150]
0x0004da4c  ldp      d13, d12, [sp, #0x140]
0x0004da50  ldp      d15, d14, [sp, #0x130]
0x0004da54  add      sp, sp, #0x1d0
0x0004da58  ret      
0x0004da5c  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0004da60  stp      x22, x21, [sp, #-0x30]!
0x0004da64  stp      x20, x19, [sp, #0x10]
0x0004da68  stp      x29, x30, [sp, #0x20]
0x0004da6c  add      x29, sp, #0x20
0x0004da70  mov      x19, x0
0x0004da74  bl       #0x55d84   ; CALL _objc_retain
0x0004da78  adrp     x8, #0x8e000
0x0004da7c  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0004da80  bl       #0x55d48   ; CALL _objc_opt_class
0x0004da84  mov      x1, x0
0x0004da88  mov      x0, x19
0x0004da8c  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0004da90  tbz      w0, #0, #0x4dad0
0x0004da94  adrp     x8, #0x8e000
0x0004da98  ldr      x0, [x8, #0x9e0]   ; @CLASS NSCharacterSet
0x0004da9c  bl       #0x5e180   ; CALL objc_msgSend$whitespaceAndNewlineCharacterSet
0x0004daa0  mov      x29, x29
0x0004daa4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004daa8  mov      x21, x0
0x0004daac  mov      x0, x19
0x0004dab0  mov      x2, x21
0x0004dab4  bl       #0x5d4c0   ; CALL objc_msgSend$stringByTrimmingCharactersInSet:
0x0004dab8  mov      x29, x29
0x0004dabc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004dac0  mov      x20, x0
0x0004dac4  mov      x0, x21
0x0004dac8  bl       #0x55d78   ; CALL _objc_release
0x0004dacc  b        #0x4dad8
0x0004dad0  adrp     x20, #0x75000
0x0004dad4  add      x20, x20, #0xd28
0x0004dad8  mov      x0, x19
0x0004dadc  bl       #0x55d78   ; CALL _objc_release
0x0004dae0  mov      x0, x20
0x0004dae4  ldp      x29, x30, [sp, #0x20]
0x0004dae8  ldp      x20, x19, [sp, #0x10]
0x0004daec  ldp      x22, x21, [sp], #0x30
0x0004daf0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x0004daf4  sub      sp, sp, #0x40
0x0004daf8  stp      x22, x21, [sp, #0x10]
0x0004dafc  stp      x20, x19, [sp, #0x20]
0x0004db00  stp      x29, x30, [sp, #0x30]
0x0004db04  add      x29, sp, #0x30
0x0004db08  mov      x21, x2
0x0004db0c  mov      x20, x1
0x0004db10  mov      x19, x0
0x0004db14  bl       #0x55d84   ; CALL _objc_retain
0x0004db18  mov      x0, x20
0x0004db1c  bl       #0x55d84   ; CALL _objc_retain
0x0004db20  mov      x0, x21
0x0004db24  bl       #0x4da60
0x0004db28  mov      x29, x29
0x0004db2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004db30  mov      x21, x0
0x0004db34  bl       #0x58c20   ; CALL objc_msgSend$length
0x0004db38  cbz      x0, #0x4db60
0x0004db3c  adrp     x8, #0x8e000
0x0004db40  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0004db44  str      x21, [sp]
0x0004db48  mov      x2, x19
0x0004db4c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0004db50  mov      x29, x29
0x0004db54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004db58  mov      x22, x0
0x0004db5c  b        #0x4db6c
0x0004db60  mov      x0, x20
0x0004db64  bl       #0x55d84   ; CALL _objc_retain
0x0004db68  mov      x22, x20
0x0004db6c  mov      x0, x21
0x0004db70  bl       #0x55d78   ; CALL _objc_release
0x0004db74  mov      x0, x20
0x0004db78  bl       #0x55d78   ; CALL _objc_release
0x0004db7c  mov      x0, x19
0x0004db80  bl       #0x55d78   ; CALL _objc_release
0x0004db84  mov      x0, x22
0x0004db88  ldp      x29, x30, [sp, #0x30]
0x0004db8c  ldp      x20, x19, [sp, #0x20]
0x0004db90  ldp      x22, x21, [sp, #0x10]
0x0004db94  add      sp, sp, #0x40
0x0004db98  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[SSStartupView ss_setGauge:value:]  va=0x4db9c size=504 types=v32@0:8@16d24
0x0004db9c  sub      sp, sp, #0x150
0x0004dba0  stp      d9, d8, [sp, #0x110]
0x0004dba4  stp      x22, x21, [sp, #0x120]
0x0004dba8  stp      x20, x19, [sp, #0x130]
0x0004dbac  stp      x29, x30, [sp, #0x140]
0x0004dbb0  add      x29, sp, #0x140
0x0004dbb4  mov      v8.16b, v0.16b
0x0004dbb8  mov      x19, x2
0x0004dbbc  mov      x0, x2
0x0004dbc0  bl       #0x55d84   ; CALL _objc_retain
0x0004dbc4  fmov     d0, #1.00000000
0x0004dbc8  fcmp     d8, d0
0x0004dbcc  fcsel    d0, d0, d8, gt
0x0004dbd0  fcmp     d8, #0.0
0x0004dbd4  fmov     d1, xzr
0x0004dbd8  fcsel    d9, d1, d0, mi
0x0004dbdc  mov      x0, x19
0x0004dbe0  bl       #0x565a0   ; CALL objc_msgSend$arc
0x0004dbe4  mov      x29, x29
0x0004dbe8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004dbec  mov      x20, x0
0x0004dbf0  mov      v0.16b, v9.16b
0x0004dbf4  bl       #0x5c3a0   ; CALL objc_msgSend$setStrokeEnd:
0x0004dbf8  mov      x0, x20
0x0004dbfc  bl       #0x55d78   ; CALL _objc_release
0x0004dc00  adrp     x8, #0x65000
0x0004dc04  ldr      d0, [x8, #0xcb0]
0x0004dc08  adrp     x8, #0x65000
0x0004dc0c  ldr      d1, [x8, #0xfe8]
0x0004dc10  fmadd    d0, d8, d1, d0
0x0004dc14  add      x8, sp, #0x90
0x0004dc18  fmov     d1, xzr
0x0004dc1c  fmov     d2, xzr
0x0004dc20  fmov     d3, #1.00000000
0x0004dc24  bl       #0x55820   ; CALL _CATransform3DMakeRotation
0x0004dc28  mov      x0, x19
0x0004dc2c  bl       #0x591c0   ; CALL objc_msgSend$needle
0x0004dc30  mov      x29, x29
0x0004dc34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004dc38  mov      x20, x0
0x0004dc3c  ldp      q0, q1, [sp, #0xd0]
0x0004dc40  stp      q0, q1, [sp, #0x50]
0x0004dc44  ldp      q0, q1, [sp, #0xf0]
0x0004dc48  stp      q0, q1, [sp, #0x70]
0x0004dc4c  ldp      q0, q1, [sp, #0x90]
0x0004dc50  stp      q0, q1, [sp, #0x10]
0x0004dc54  ldp      q0, q1, [sp, #0xb0]
0x0004dc58  stp      q0, q1, [sp, #0x30]
0x0004dc5c  add      x2, sp, #0x10
0x0004dc60  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x0004dc64  mov      x0, x20
0x0004dc68  bl       #0x55d78   ; CALL _objc_release
0x0004dc6c  mov      x0, x19
0x0004dc70  bl       #0x59be0   ; CALL objc_msgSend$red
0x0004dc74  mov      v9.16b, v0.16b
0x0004dc78  fcmp     d8, d0
0x0004dc7c  cset     w20, gt
0x0004dc80  mov      x0, x19
0x0004dc84  bl       #0x57fc0   ; CALL objc_msgSend$hot
0x0004dc88  cmp      w20, w0
0x0004dc8c  b.eq     #0x4dcf8
0x0004dc90  fcmp     d8, d9
0x0004dc94  cset     w2, gt
0x0004dc98  mov      w8, #0xffffff
0x0004dc9c  mov      w9, #0x5c54
0x0004dca0  movk     w9, #0xff, lsl #16
0x0004dca4  csel     w20, w9, w8, gt
0x0004dca8  mov      x0, x19
0x0004dcac  bl       #0x5b000   ; CALL objc_msgSend$setHot:
0x0004dcb0  mov      w0, #0xd3ff
0x0004dcb4  movk     w0, #0x7f, lsl #16
0x0004dcb8  mov      x1, x20
0x0004dcbc  bl       #0x4732c
0x0004dcc0  mov      x29, x29
0x0004dcc4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004dcc8  mov      x20, x0
0x0004dccc  mov      x0, x19
0x0004dcd0  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0004dcd4  mov      x29, x29
0x0004dcd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004dcdc  mov      x21, x0
0x0004dce0  mov      x2, x20
0x0004dce4  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0004dce8  mov      x0, x21
0x0004dcec  bl       #0x55d78   ; CALL _objc_release
0x0004dcf0  mov      x0, x20
0x0004dcf4  bl       #0x55d78   ; CALL _objc_release
0x0004dcf8  mov      x0, x19
0x0004dcfc  bl       #0x58f80   ; CALL objc_msgSend$max
0x0004dd00  fmul     d0, d8, d0
0x0004dd04  fcvtas   x20, d0
0x0004dd08  mov      x0, x19
0x0004dd0c  bl       #0x5cb20   ; CALL objc_msgSend$shown
0x0004dd10  cmp      x20, x0
0x0004dd14  b.eq     #0x4dd74
0x0004dd18  mov      x0, x19
0x0004dd1c  mov      x2, x20
0x0004dd20  bl       #0x5c120   ; CALL objc_msgSend$setShown:
0x0004dd24  adrp     x8, #0x8e000
0x0004dd28  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0004dd2c  str      x20, [sp]
0x0004dd30  adrp     x2, #0x79000
0x0004dd34  add      x2, x2, #0x88   ; STR "%ld"
0x0004dd38  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0004dd3c  mov      x29, x29
0x0004dd40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004dd44  mov      x20, x0
0x0004dd48  mov      x0, x19
0x0004dd4c  bl       #0x59240   ; CALL objc_msgSend$number
0x0004dd50  mov      x29, x29
0x0004dd54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004dd58  mov      x21, x0
0x0004dd5c  mov      x2, x20
0x0004dd60  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0004dd64  mov      x0, x21
0x0004dd68  bl       #0x55d78   ; CALL _objc_release
0x0004dd6c  mov      x0, x20
0x0004dd70  bl       #0x55d78   ; CALL _objc_release
0x0004dd74  mov      x0, x19
0x0004dd78  bl       #0x55d78   ; CALL _objc_release
0x0004dd7c  ldp      x29, x30, [sp, #0x140]
0x0004dd80  ldp      x20, x19, [sp, #0x130]
0x0004dd84  ldp      x22, x21, [sp, #0x120]
0x0004dd88  ldp      d9, d8, [sp, #0x110]
0x0004dd8c  add      sp, sp, #0x150
0x0004dd90  ret      

=== -[SSStartupView ss_applyEngine:]  va=0x4dd94 size=556 types=v24@0:8d16
0x0004dd94  stp      d11, d10, [sp, #-0x50]!
0x0004dd98  stp      d9, d8, [sp, #0x10]
0x0004dd9c  stp      x22, x21, [sp, #0x20]
0x0004dda0  stp      x20, x19, [sp, #0x30]
0x0004dda4  stp      x29, x30, [sp, #0x40]
0x0004dda8  add      x29, sp, #0x40
0x0004ddac  mov      v8.16b, v0.16b
0x0004ddb0  mov      x19, x0
0x0004ddb4  adrp     x8, #0x8f000
0x0004ddb8  ldrsw    x21, [x8, #0x8c]
0x0004ddbc  ldr      x0, [x0, x21]
0x0004ddc0  bl       #0x573c0   ; CALL objc_msgSend$count
0x0004ddc4  cmp      x0, #2
0x0004ddc8  b.hs     #0x4dde4
0x0004ddcc  ldp      x29, x30, [sp, #0x40]
0x0004ddd0  ldp      x20, x19, [sp, #0x30]
0x0004ddd4  ldp      x22, x21, [sp, #0x20]
0x0004ddd8  ldp      d9, d8, [sp, #0x10]
0x0004dddc  ldp      d11, d10, [sp], #0x50
0x0004dde0  ret      
0x0004dde4  fmov     d10, xzr
0x0004dde8  adrp     x8, #0x65000
0x0004ddec  ldr      d0, [x8, #0x780]
0x0004ddf0  fcmp     d8, d0
0x0004ddf4  adrp     x20, #0x66000
0x0004ddf8  fmov     d9, xzr
0x0004ddfc  b.pl     #0x4dea4
0x0004de00  ldr      d0, [x20, #0x50]
0x0004de04  fcmp     d8, d0
0x0004de08  b.le     #0x4de2c
0x0004de0c  fmov     d0, #9.00000000
0x0004de10  fmul     d0, d8, d0
0x0004de14  bl       #0x55e20   ; CALL _sin
0x0004de18  adrp     x8, #0x65000
0x0004de1c  ldr      d1, [x8, #0x770]
0x0004de20  adrp     x8, #0x66000
0x0004de24  ldr      d2, [x8, #0x70]
0x0004de28  fmadd    d10, d0, d2, d1
0x0004de2c  ldr      x0, [x19, x21]
0x0004de30  mov      x2, #0
0x0004de34  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0004de38  mov      x29, x29
0x0004de3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004de40  mov      x20, x0
0x0004de44  fcmp     d9, d10
0x0004de48  fcsel    d0, d10, d9, mi
0x0004de4c  mov      x0, x19
0x0004de50  mov      x2, x20
0x0004de54  bl       #0x5d220   ; CALL objc_msgSend$ss_setGauge:value:
0x0004de58  mov      x0, x20
0x0004de5c  bl       #0x55d78   ; CALL _objc_release
0x0004de60  ldr      x0, [x19, x21]
0x0004de64  mov      w2, #1
0x0004de68  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0004de6c  mov      x29, x29
0x0004de70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004de74  mov      x20, x0
0x0004de78  mov      x0, x19
0x0004de7c  mov      x2, x20
0x0004de80  mov      v0.16b, v9.16b
0x0004de84  bl       #0x5d220   ; CALL objc_msgSend$ss_setGauge:value:
0x0004de88  mov      x0, x20
0x0004de8c  ldp      x29, x30, [sp, #0x40]
0x0004de90  ldp      x20, x19, [sp, #0x30]
0x0004de94  ldp      x22, x21, [sp, #0x20]
0x0004de98  ldp      d9, d8, [sp, #0x10]
0x0004de9c  ldp      d11, d10, [sp], #0x50
0x0004dea0  b        #0x55d78   ; CALL _objc_release
0x0004dea4  adrp     x8, #0x66000
0x0004dea8  ldr      d0, [x8, #0x48]
0x0004deac  fcmp     d8, d0
0x0004deb0  b.pl     #0x4df0c
0x0004deb4  adrp     x8, #0x66000
0x0004deb8  ldr      d0, [x8, #0x68]
0x0004debc  fadd     d0, d8, d0
0x0004dec0  adrp     x8, #0x65000
0x0004dec4  ldr      d1, [x8, #0x708]
0x0004dec8  fdiv     d0, d0, d1
0x0004decc  fmov     d9, #1.00000000
0x0004ded0  fcmp     d0, d9
0x0004ded4  fcsel    d1, d9, d0, gt
0x0004ded8  fcmp     d0, #0.0
0x0004dedc  fmov     d0, xzr
0x0004dee0  fcsel    d1, d0, d1, mi
0x0004dee4  fcmp     d1, #0.0
0x0004dee8  fcsel    d0, d0, d1, mi
0x0004deec  fmov     d1, #0.50000000
0x0004def0  fcmp     d0, d1
0x0004def4  b.pl     #0x4df70
0x0004def8  fmov     d1, #4.00000000
0x0004defc  fmul     d1, d0, d1
0x0004df00  fmul     d1, d0, d1
0x0004df04  fmul     d9, d0, d1
0x0004df08  b        #0x4de00
0x0004df0c  ldr      d0, [x20, #0x50]
0x0004df10  fcmp     d8, d0
0x0004df14  b.pl     #0x4de00
0x0004df18  adrp     x8, #0x66000
0x0004df1c  ldr      d0, [x8, #0x58]
0x0004df20  fadd     d0, d8, d0
0x0004df24  adrp     x8, #0x66000
0x0004df28  ldr      d1, [x8, #0x60]
0x0004df2c  fdiv     d0, d0, d1
0x0004df30  fmov     d9, #1.00000000
0x0004df34  fcmp     d0, d9
0x0004df38  fcsel    d1, d9, d0, gt
0x0004df3c  fcmp     d0, #0.0
0x0004df40  fmov     d0, xzr
0x0004df44  fcsel    d1, d0, d1, mi
0x0004df48  fcmp     d1, #0.0
0x0004df4c  fcsel    d0, d0, d1, mi
0x0004df50  fmov     d1, #0.50000000
0x0004df54  fcmp     d0, d1
0x0004df58  b.pl     #0x4df94
0x0004df5c  fmov     d1, #4.00000000
0x0004df60  fmul     d1, d0, d1
0x0004df64  fmul     d1, d0, d1
0x0004df68  fmul     d0, d0, d1
0x0004df6c  b        #0x4dfb4
0x0004df70  fmov     d1, #2.00000000
0x0004df74  fmov     d2, #-2.00000000
0x0004df78  fmadd    d0, d0, d2, d1
0x0004df7c  fmov     d1, #3.00000000
0x0004df80  bl       #0x55e14   ; CALL _pow
0x0004df84  fmov     d1, #-0.50000000
0x0004df88  fmul     d0, d0, d1
0x0004df8c  fadd     d9, d0, d9
0x0004df90  b        #0x4de00
0x0004df94  fmov     d1, #2.00000000
0x0004df98  fmov     d2, #-2.00000000
0x0004df9c  fmadd    d0, d0, d2, d1
0x0004dfa0  fmov     d1, #3.00000000
0x0004dfa4  bl       #0x55e14   ; CALL _pow
0x0004dfa8  fmov     d1, #-0.50000000
0x0004dfac  fmul     d0, d0, d1
0x0004dfb0  fadd     d0, d0, d9
0x0004dfb4  fmov     d1, #1.00000000
0x0004dfb8  fsub     d9, d1, d0
0x0004dfbc  b        #0x4de00

=== -[SSStartupView ss_buildWelcome]  va=0x4dfc0 size=2036 types=v16@0:8
0x0004dfc0  sub      sp, sp, #0x1d0
0x0004dfc4  stp      d15, d14, [sp, #0x130]
0x0004dfc8  stp      d13, d12, [sp, #0x140]
0x0004dfcc  stp      d11, d10, [sp, #0x150]
0x0004dfd0  stp      d9, d8, [sp, #0x160]
0x0004dfd4  stp      x28, x27, [sp, #0x170]
0x0004dfd8  stp      x26, x25, [sp, #0x180]
0x0004dfdc  stp      x24, x23, [sp, #0x190]
0x0004dfe0  stp      x22, x21, [sp, #0x1a0]
0x0004dfe4  stp      x20, x19, [sp, #0x1b0]
0x0004dfe8  stp      x29, x30, [sp, #0x1c0]
0x0004dfec  add      x29, sp, #0x1c0
0x0004dff0  mov      x19, x0
0x0004dff4  mov      x8, #0
0x0004dff8  adrp     x9, #0x74000
0x0004dffc  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0004e000  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0004e004  stur     x9, [x29, #-0xa0]
0x0004e008  adrp     x9, #0x8f000
0x0004e00c  ldrsw    x27, [x9, #0xcc]
0x0004e010  ldr      d5, [x0, x27]
0x0004e014  adrp     x9, #0x8f000
0x0004e018  ldrsw    x9, [x9, #0x58]
0x0004e01c  ldr      d0, [x0, x9]
0x0004e020  str      d0, [sp, #8]
0x0004e024  adrp     x9, #0x8f000
0x0004e028  ldrsw    x21, [x9, #0xd0]
0x0004e02c  adrp     x9, #0x8f000
0x0004e030  ldrsw    x28, [x9, #0xd4]
0x0004e034  add      x9, x0, x28
0x0004e038  ldr      d0, [x0, x21]
0x0004e03c  ld1      {v0.d}[1], [x9]
0x0004e040  adrp     x9, #0x66000
0x0004e044  add      x9, x9, #0x330
0x0004e048  adrp     x10, #0x66000
0x0004e04c  ldr      q1, [x10, #0x2d0]
0x0004e050  adrp     x10, #0x66000
0x0004e054  ldr      q2, [x10, #0x2e0]
0x0004e058  add      x10, sp, #0x70
0x0004e05c  ldr      q3, [x9, x8]
0x0004e060  mov      v4.16b, v2.16b
0x0004e064  fmla     v4.2d, v1.2d, v3.2d
0x0004e068  mov      v3.16b, v0.16b
0x0004e06c  fmla     v3.2d, v4.2d, v5.d[0]
0x0004e070  str      q3, [x10, x8]
0x0004e074  add      x8, x8, #0x10
0x0004e078  cmp      x8, #0xb0
0x0004e07c  b.ne     #0x4e05c
0x0004e080  str      q5, [sp, #0x20]
0x0004e084  adrp     x23, #0x8e000
0x0004e088  ldr      x0, [x23, #0xac0]   ; @CLASS UIBezierPath
0x0004e08c  bl       #0x567e0   ; CALL objc_msgSend$bezierPath
0x0004e090  mov      x29, x29
0x0004e094  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e098  mov      x20, x0
0x0004e09c  ldp      d0, d1, [sp, #0x70]
0x0004e0a0  bl       #0x59060   ; CALL objc_msgSend$moveToPoint:
0x0004e0a4  mov      w22, #0x20
0x0004e0a8  ldr      q2, [sp, #0x80]
0x0004e0ac  add      x24, sp, #0x70
0x0004e0b0  fmov     v0.2d, #0.50000000
0x0004e0b4  str      q0, [sp, #0x10]
0x0004e0b8  ldr      q0, [x24, x22]
0x0004e0bc  str      q0, [sp, #0x30]
0x0004e0c0  fadd     v0.2d, v2.2d, v0.2d
0x0004e0c4  ldr      q1, [sp, #0x10]
0x0004e0c8  fmul     v0.2d, v0.2d, v1.2d
0x0004e0cc  mov      d1, v0.d[1]
0x0004e0d0  mov      d3, v2.d[1]
0x0004e0d4  mov      x0, x20
0x0004e0d8  bl       #0x561a0   ; CALL objc_msgSend$addQuadCurveToPoint:controlPoint:
0x0004e0dc  add      x22, x22, #0x10
0x0004e0e0  ldr      q2, [sp, #0x30]
0x0004e0e4  cmp      x22, #0xb0
0x0004e0e8  b.ne     #0x4e0b8
0x0004e0ec  ldp      d0, d1, [sp, #0x110]
0x0004e0f0  mov      x0, x20
0x0004e0f4  bl       #0x56100   ; CALL objc_msgSend$addLineToPoint:
0x0004e0f8  mov      x0, x19
0x0004e0fc  bl       #0x5d1a0   ; CALL objc_msgSend$ss_host
0x0004e100  mov      x29, x29
0x0004e104  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e108  mov      x26, x0
0x0004e10c  ldr      d0, [x19, x27]
0x0004e110  ldr      d1, [x19, x28]
0x0004e114  adrp     x8, #0x66000
0x0004e118  ldr      d2, [x8, #0x78]
0x0004e11c  fmadd    d8, d0, d2, d1
0x0004e120  adrp     x8, #0x8e000
0x0004e124  ldr      x0, [x8, #0xcd8]   ; @CLASS CALayer
0x0004e128  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004e12c  mov      x29, x29
0x0004e130  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e134  adrp     x8, #0x8f000
0x0004e138  ldrsw    x24, [x8, #0xb4]
0x0004e13c  ldr      x8, [x19, x24]
0x0004e140  str      x0, [x19, x24]
0x0004e144  mov      x0, x8
0x0004e148  bl       #0x55d78   ; CALL _objc_release
0x0004e14c  adrp     x8, #0x8f000
0x0004e150  ldrsw    x8, [x8, #0x54]
0x0004e154  ldr      d2, [x19, x8]
0x0004e158  ldr      q0, [sp, #0x20]
0x0004e15c  fadd     d0, d0, d0
0x0004e160  fmov     d1, #1.00000000
0x0004e164  fmaxnm   d3, d0, d1
0x0004e168  ldr      x0, [x19, x24]
0x0004e16c  fmov     d0, xzr
0x0004e170  mov      v1.16b, v8.16b
0x0004e174  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0004e178  adrp     x25, #0x8e000
0x0004e17c  ldr      x0, [x25, #0x910]   ; @CLASS UIColor
0x0004e180  adrp     x8, #0x65000
0x0004e184  ldr      d0, [x8, #0xb28]
0x0004e188  adrp     x8, #0x65000
0x0004e18c  ldr      d1, [x8, #0xf38]
0x0004e190  fmov     d2, #1.00000000
0x0004e194  fmov     d3, #1.00000000
0x0004e198  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004e19c  mov      x29, x29
0x0004e1a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e1a4  mov      x22, x0
0x0004e1a8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004e1ac  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004e1b0  mov      x2, x0
0x0004e1b4  ldr      x0, [x19, x24]
0x0004e1b8  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0004e1bc  mov      x0, x22
0x0004e1c0  bl       #0x55d78   ; CALL _objc_release
0x0004e1c4  ldr      x0, [x19, x24]
0x0004e1c8  fmov     s0, wzr
0x0004e1cc  bl       #0x5b940   ; CALL objc_msgSend$setOpacity:
0x0004e1d0  mov      x0, x26
0x0004e1d4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004e1d8  mov      x29, x29
0x0004e1dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e1e0  mov      x22, x0
0x0004e1e4  ldr      x2, [x19, x24]
0x0004e1e8  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004e1ec  mov      x0, x22
0x0004e1f0  bl       #0x55d78   ; CALL _objc_release
0x0004e1f4  adrp     x8, #0x74000
0x0004e1f8  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x0004e1fc  str      x8, [sp, #0x40]
0x0004e200  adrp     x8, #0x65000
0x0004e204  ldr      d0, [x8, #0x600]
0x0004e208  str      d0, [sp, #0x48]
0x0004e20c  adrp     x8, #0x4e000
0x0004e210  add      x8, x8, #0x608
0x0004e214  adrp     x9, #0x74000
0x0004e218  add      x9, x9, #0xe48
0x0004e21c  stp      x8, x9, [sp, #0x50]
0x0004e220  mov      x0, x26
0x0004e224  bl       #0x55d84   ; CALL _objc_retain
0x0004e228  str      x26, [sp, #0x30]
0x0004e22c  str      x26, [sp, #0x60]
0x0004e230  ldr      q0, [sp, #0x20]
0x0004e234  str      d0, [sp, #0x68]
0x0004e238  add      x0, sp, #0x40
0x0004e23c  bl       #0x55da8   ; CALL _objc_retainBlock
0x0004e240  mov      x22, x0
0x0004e244  ldr      x8, [x0, #0x10]
0x0004e248  mov      x1, x20
0x0004e24c  blr      x8
0x0004e250  mov      x29, x29
0x0004e254  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e258  adrp     x8, #0x8f000
0x0004e25c  ldrsw    x24, [x8, #0xa0]
0x0004e260  ldr      x8, [x19, x24]
0x0004e264  str      x0, [x19, x24]
0x0004e268  mov      x0, x8
0x0004e26c  bl       #0x55d78   ; CALL _objc_release
0x0004e270  ldr      x0, [x19, x24]
0x0004e274  fmov     d0, #0.50000000
0x0004e278  bl       #0x5c3a0   ; CALL objc_msgSend$setStrokeEnd:
0x0004e27c  ldr      x0, [x19, x24]
0x0004e280  fmov     d0, #0.50000000
0x0004e284  bl       #0x5c3c0   ; CALL objc_msgSend$setStrokeStart:
0x0004e288  ldr      x0, [x23, #0xac0]   ; @CLASS UIBezierPath
0x0004e28c  bl       #0x567e0   ; CALL objc_msgSend$bezierPath
0x0004e290  mov      x29, x29
0x0004e294  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e298  mov      x23, x0
0x0004e29c  adrp     x8, #0x66000
0x0004e2a0  ldr      d0, [x8, #0x80]
0x0004e2a4  ldr      q1, [sp, #0x20]
0x0004e2a8  fmul     d8, d1, d0
0x0004e2ac  mov      w8, #1
0x0004e2b0  adrp     x9, #0x66000
0x0004e2b4  ldr      d13, [x9, #0x88]
0x0004e2b8  adrp     x9, #0x66000
0x0004e2bc  ldr      d14, [x9, #0x90]
0x0004e2c0  adrp     x9, #0x66000
0x0004e2c4  ldr      d15, [x9, #0x98]
0x0004e2c8  adrp     x9, #0x66000
0x0004e2cc  ldr      d12, [x9, #0xa0]
0x0004e2d0  adrp     x9, #0x65000
0x0004e2d4  ldr      d9, [x9, #0x930]
0x0004e2d8  ldr      d0, [x19, x21]
0x0004e2dc  ands     w24, w8, #1
0x0004e2e0  ldr      d1, [x19, x27]
0x0004e2e4  fcsel    d2, d14, d13, ne
0x0004e2e8  fmadd    d10, d2, d1, d0
0x0004e2ec  ldr      d0, [x19, x28]
0x0004e2f0  fmadd    d11, d1, d15, d0
0x0004e2f4  ldr      q0, [sp, #0x20]
0x0004e2f8  fmadd    d0, d0, d12, d10
0x0004e2fc  mov      x0, x23
0x0004e300  mov      v1.16b, v11.16b
0x0004e304  bl       #0x59060   ; CALL objc_msgSend$moveToPoint:
0x0004e308  fmov     d4, xzr
0x0004e30c  mov      x0, x23
0x0004e310  mov      v0.16b, v10.16b
0x0004e314  mov      v1.16b, v11.16b
0x0004e318  mov      v2.16b, v8.16b
0x0004e31c  mov      v3.16b, v9.16b
0x0004e320  mov      w2, #1
0x0004e324  bl       #0x56040   ; CALL objc_msgSend$addArcWithCenter:radius:startAngle:endAngle:clockwise:
0x0004e328  mov      w8, #0
0x0004e32c  cbnz     w24, #0x4e2d8
0x0004e330  ldr      x8, [x22, #0x10]
0x0004e334  mov      x0, x22
0x0004e338  mov      x1, x23
0x0004e33c  blr      x8
0x0004e340  mov      x29, x29
0x0004e344  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e348  adrp     x8, #0x8f000
0x0004e34c  ldrsw    x24, [x8, #0x9c]
0x0004e350  ldr      x8, [x19, x24]
0x0004e354  str      x0, [x19, x24]
0x0004e358  mov      x0, x8
0x0004e35c  bl       #0x55d78   ; CALL _objc_release
0x0004e360  ldr      x0, [x19, x24]
0x0004e364  fmov     s0, wzr
0x0004e368  bl       #0x5b940   ; CALL objc_msgSend$setOpacity:
0x0004e36c  ldr      d0, [x19, x21]
0x0004e370  ldr      d1, [x19, x27]
0x0004e374  adrp     x8, #0x66000
0x0004e378  ldr      d2, [x8, #0xa8]
0x0004e37c  fmadd    d8, d1, d2, d0
0x0004e380  ldr      d0, [x19, x28]
0x0004e384  adrp     x8, #0x66000
0x0004e388  ldr      d2, [x8, #0xb0]
0x0004e38c  fmadd    d9, d1, d2, d0
0x0004e390  adrp     x8, #0x65000
0x0004e394  ldr      d0, [x8, #0xed8]
0x0004e398  ldr      q1, [sp, #0x20]
0x0004e39c  fmul     d10, d1, d0
0x0004e3a0  ldr      x0, [x25, #0x910]   ; @CLASS UIColor
0x0004e3a4  adrp     x8, #0x65000
0x0004e3a8  ldr      d3, [x8, #0x9a0]
0x0004e3ac  fmov     d0, #1.00000000
0x0004e3b0  fmov     d1, #1.00000000
0x0004e3b4  fmov     d2, #1.00000000
0x0004e3b8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004e3bc  mov      x29, x29
0x0004e3c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e3c4  mov      x24, x0
0x0004e3c8  ldr      x0, [x25, #0x910]   ; @CLASS UIColor
0x0004e3cc  fmov     d0, #1.00000000
0x0004e3d0  fmov     d1, #1.00000000
0x0004e3d4  fmov     d2, #1.00000000
0x0004e3d8  fmov     d3, xzr
0x0004e3dc  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004e3e0  mov      x29, x29
0x0004e3e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e3e8  mov      x25, x0
0x0004e3ec  mov      v0.16b, v8.16b
0x0004e3f0  mov      v1.16b, v9.16b
0x0004e3f4  mov      v2.16b, v10.16b
0x0004e3f8  mov      x0, x24
0x0004e3fc  mov      x1, x25
0x0004e400  bl       #0x4c190
0x0004e404  mov      x29, x29
0x0004e408  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e40c  adrp     x8, #0x8f000
0x0004e410  ldrsw    x26, [x8, #0xb8]
0x0004e414  ldr      x8, [x19, x26]
0x0004e418  str      x0, [x19, x26]
0x0004e41c  mov      x0, x8
0x0004e420  bl       #0x55d78   ; CALL _objc_release
0x0004e424  mov      x0, x25
0x0004e428  bl       #0x55d78   ; CALL _objc_release
0x0004e42c  mov      x0, x24
0x0004e430  bl       #0x55d78   ; CALL _objc_release
0x0004e434  ldr      x0, [x19, x26]
0x0004e438  fmov     s0, wzr
0x0004e43c  bl       #0x5b940   ; CALL objc_msgSend$setOpacity:
0x0004e440  ldr      x0, [sp, #0x30]
0x0004e444  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004e448  mov      x29, x29
0x0004e44c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e450  mov      x24, x0
0x0004e454  ldr      x2, [x19, x26]
0x0004e458  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004e45c  mov      x0, x24
0x0004e460  bl       #0x55d78   ; CALL _objc_release
0x0004e464  mov      x0, x19
0x0004e468  bl       #0x575a0   ; CALL objc_msgSend$date
0x0004e46c  mov      x29, x29
0x0004e470  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e474  mov      x24, x0
0x0004e478  cbz      x0, #0x4e48c
0x0004e47c  mov      x0, x24
0x0004e480  bl       #0x45c90   ; CALL _SSPeriodForDate
0x0004e484  mov      x25, x0
0x0004e488  b        #0x4e4b4
0x0004e48c  adrp     x8, #0x8e000
0x0004e490  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x0004e494  bl       #0x575a0   ; CALL objc_msgSend$date
0x0004e498  mov      x29, x29
0x0004e49c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e4a0  mov      x26, x0
0x0004e4a4  bl       #0x45c90   ; CALL _SSPeriodForDate
0x0004e4a8  mov      x25, x0
0x0004e4ac  mov      x0, x26
0x0004e4b0  bl       #0x55d78   ; CALL _objc_release
0x0004e4b4  mov      x0, x24
0x0004e4b8  bl       #0x55d78   ; CALL _objc_release
0x0004e4bc  mov      x0, x19
0x0004e4c0  bl       #0x590e0   ; CALL objc_msgSend$name
0x0004e4c4  mov      x29, x29
0x0004e4c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e4cc  mov      x24, x0
0x0004e4d0  mov      x1, x25
0x0004e4d4  bl       #0x4779c
0x0004e4d8  mov      x29, x29
0x0004e4dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e4e0  mov      x25, x0
0x0004e4e4  ldr      d0, [x19, x21]
0x0004e4e8  ldr      d1, [x19, x27]
0x0004e4ec  mov      x8, #0x4089000000000000
0x0004e4f0  fmov     d2, x8
0x0004e4f4  fmadd    d0, d1, d2, d0
0x0004e4f8  ldr      d2, [x19, x28]
0x0004e4fc  adrp     x8, #0x66000
0x0004e500  ldr      d3, [x8, #0xb8]
0x0004e504  fmadd    d1, d1, d3, d2
0x0004e508  adrp     x8, #0x74000
0x0004e50c  ldr      x8, [x8, #0x238]   ; @GOT _UIFontWeightBold
0x0004e510  ldr      d3, [x8]   ; @GOT ___objc_personality_v0
0x0004e514  mov      x8, #0x4046000000000000
0x0004e518  fmov     d2, x8
0x0004e51c  fmov     d4, xzr
0x0004e520  mov      x0, x19
0x0004e524  mov      x2, x25
0x0004e528  mov      x3, #0
0x0004e52c  mov      w4, #0
0x0004e530  ldr      x21, [sp, #0x30]
0x0004e534  mov      x5, x21
0x0004e538  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x0004e53c  mov      x29, x29
0x0004e540  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e544  mov      x26, x0
0x0004e548  mov      x0, x25
0x0004e54c  bl       #0x55d78   ; CALL _objc_release
0x0004e550  mov      x0, x24
0x0004e554  bl       #0x55d78   ; CALL _objc_release
0x0004e558  adrp     x8, #0x66000
0x0004e55c  ldr      d0, [x8, #0xc0]
0x0004e560  ldr      d2, [sp, #8]
0x0004e564  fmul     d0, d2, d0
0x0004e568  adrp     x8, #0x66000
0x0004e56c  ldr      d1, [x8, #0xc8]
0x0004e570  fmul     d1, d2, d1
0x0004e574  fmov     d2, #1.00000000
0x0004e578  mov      x0, x19
0x0004e57c  mov      x2, x26
0x0004e580  bl       #0x5d160   ; CALL objc_msgSend$ss_fade:from:to:alpha:
0x0004e584  mov      x29, x29
0x0004e588  bl       #0x55dfc   ; CALL _objc_unsafeClaimAutoreleasedReturnValue
0x0004e58c  mov      x0, x26
0x0004e590  bl       #0x55d78   ; CALL _objc_release
0x0004e594  mov      x0, x23
0x0004e598  bl       #0x55d78   ; CALL _objc_release
0x0004e59c  mov      x0, x22
0x0004e5a0  bl       #0x55d78   ; CALL _objc_release
0x0004e5a4  ldr      x0, [sp, #0x60]
0x0004e5a8  bl       #0x55d78   ; CALL _objc_release
0x0004e5ac  mov      x0, x21
0x0004e5b0  bl       #0x55d78   ; CALL _objc_release
0x0004e5b4  mov      x0, x20
0x0004e5b8  bl       #0x55d78   ; CALL _objc_release
0x0004e5bc  ldur     x8, [x29, #-0xa0]
0x0004e5c0  adrp     x9, #0x74000
0x0004e5c4  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0004e5c8  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0004e5cc  cmp      x9, x8
0x0004e5d0  b.ne     #0x4e604
0x0004e5d4  ldp      x29, x30, [sp, #0x1c0]
0x0004e5d8  ldp      x20, x19, [sp, #0x1b0]
0x0004e5dc  ldp      x22, x21, [sp, #0x1a0]
0x0004e5e0  ldp      x24, x23, [sp, #0x190]
0x0004e5e4  ldp      x26, x25, [sp, #0x180]
0x0004e5e8  ldp      x28, x27, [sp, #0x170]
0x0004e5ec  ldp      d9, d8, [sp, #0x160]
0x0004e5f0  ldp      d11, d10, [sp, #0x150]
0x0004e5f4  ldp      d13, d12, [sp, #0x140]
0x0004e5f8  ldp      d15, d14, [sp, #0x130]
0x0004e5fc  add      sp, sp, #0x1d0
0x0004e600  ret      
0x0004e604  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0004e608  stp      x22, x21, [sp, #-0x30]!
0x0004e60c  stp      x20, x19, [sp, #0x10]
0x0004e610  stp      x29, x30, [sp, #0x20]
0x0004e614  add      x29, sp, #0x20
0x0004e618  mov      x21, x1
0x0004e61c  mov      x20, x0
0x0004e620  adrp     x8, #0x8e000
0x0004e624  ldr      x19, [x8, #0xb48]   ; @CLASS CAShapeLayer
0x0004e628  mov      x0, x1
0x0004e62c  bl       #0x55d84   ; CALL _objc_retain
0x0004e630  mov      x0, x19
0x0004e634  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004e638  mov      x29, x29
0x0004e63c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e640  mov      x19, x0
0x0004e644  ldr      x0, [x20, #0x20]
0x0004e648  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0004e64c  mov      x0, x19
0x0004e650  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0004e654  mov      x0, x21
0x0004e658  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004e65c  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x0004e660  mov      x22, x0
0x0004e664  mov      x0, x21
0x0004e668  bl       #0x55d78   ; CALL _objc_release
0x0004e66c  mov      x0, x19
0x0004e670  mov      x2, x22
0x0004e674  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x0004e678  mov      x0, x19
0x0004e67c  mov      x2, #0
0x0004e680  bl       #0x5ae40   ; CALL objc_msgSend$setFillColor:
0x0004e684  adrp     x22, #0x8e000
0x0004e688  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0004e68c  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0004e690  mov      x29, x29
0x0004e694  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e698  mov      x21, x0
0x0004e69c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004e6a0  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004e6a4  mov      x2, x0
0x0004e6a8  mov      x0, x19
0x0004e6ac  bl       #0x5c380   ; CALL objc_msgSend$setStrokeColor:
0x0004e6b0  mov      x0, x21
0x0004e6b4  bl       #0x55d78   ; CALL _objc_release
0x0004e6b8  ldr      d0, [x20, #0x28]
0x0004e6bc  fmov     d1, #6.00000000
0x0004e6c0  fmul     d0, d0, d1
0x0004e6c4  fmov     d1, #1.50000000
0x0004e6c8  fmaxnm   d0, d0, d1
0x0004e6cc  mov      x0, x19
0x0004e6d0  bl       #0x5b3a0   ; CALL objc_msgSend$setLineWidth:
0x0004e6d4  adrp     x8, #0x74000
0x0004e6d8  ldr      x8, [x8, #0x688]   ; @GOT _kCALineCapRound
0x0004e6dc  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0004e6e0  mov      x0, x19
0x0004e6e4  bl       #0x5b320   ; CALL objc_msgSend$setLineCap:
0x0004e6e8  adrp     x8, #0x74000
0x0004e6ec  ldr      x8, [x8, #0x690]   ; @GOT _kCALineJoinRound
0x0004e6f0  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0004e6f4  mov      x0, x19
0x0004e6f8  bl       #0x5b360   ; CALL objc_msgSend$setLineJoin:
0x0004e6fc  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0004e700  adrp     x8, #0x65000
0x0004e704  ldr      d0, [x8, #0xb28]
0x0004e708  adrp     x8, #0x65000
0x0004e70c  ldr      d1, [x8, #0xf38]
0x0004e710  fmov     d2, #1.00000000
0x0004e714  fmov     d3, #1.00000000
0x0004e718  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004e71c  mov      x29, x29
0x0004e720  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e724  mov      x21, x0
0x0004e728  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004e72c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004e730  mov      x2, x0
0x0004e734  mov      x0, x19
0x0004e738  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x0004e73c  mov      x0, x21
0x0004e740  bl       #0x55d78   ; CALL _objc_release
0x0004e744  adrp     x8, #0x66000
0x0004e748  ldr      s0, [x8, #0x2c0]
0x0004e74c  mov      x0, x19
0x0004e750  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x0004e754  ldr      d0, [x20, #0x28]
0x0004e758  fmov     d1, #15.00000000
0x0004e75c  fmul     d0, d0, d1
0x0004e760  mov      x0, x19
0x0004e764  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x0004e768  adrp     x8, #0x74000
0x0004e76c  ldr      x8, [x8, #0x618]   ; @GOT _CGSizeZero
0x0004e770  ldp      d0, d1, [x8]
0x0004e774  mov      x0, x19
0x0004e778  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x0004e77c  ldr      x0, [x20, #0x20]
0x0004e780  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004e784  mov      x29, x29
0x0004e788  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e78c  mov      x20, x0
0x0004e790  mov      x2, x19
0x0004e794  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004e798  mov      x0, x20
0x0004e79c  bl       #0x55d78   ; CALL _objc_release
0x0004e7a0  mov      x0, x19
0x0004e7a4  ldp      x29, x30, [sp, #0x20]
0x0004e7a8  ldp      x20, x19, [sp, #0x10]
0x0004e7ac  ldp      x22, x21, [sp], #0x30
0x0004e7b0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[SSStartupView ss_applyWelcome:]  va=0x4e7b4 size=472 types=v24@0:8d16
0x0004e7b4  stp      d13, d12, [sp, #-0x50]!
0x0004e7b8  stp      d11, d10, [sp, #0x10]
0x0004e7bc  stp      d9, d8, [sp, #0x20]
0x0004e7c0  stp      x20, x19, [sp, #0x30]
0x0004e7c4  stp      x29, x30, [sp, #0x40]
0x0004e7c8  add      x29, sp, #0x40
0x0004e7cc  mov      v8.16b, v0.16b
0x0004e7d0  mov      x19, x0
0x0004e7d4  adrp     x8, #0x8f000
0x0004e7d8  ldrsw    x8, [x8, #0x58]
0x0004e7dc  ldr      d9, [x0, x8]
0x0004e7e0  adrp     x8, #0x65000
0x0004e7e4  ldr      d0, [x8, #0x728]
0x0004e7e8  fmul     d0, d9, d0
0x0004e7ec  adrp     x8, #0x66000
0x0004e7f0  ldr      d1, [x8, #0xd0]
0x0004e7f4  fmul     d1, d9, d1
0x0004e7f8  fsub     d2, d8, d0
0x0004e7fc  fsub     d0, d1, d0
0x0004e800  fdiv     d0, d2, d0
0x0004e804  fmov     d10, #1.00000000
0x0004e808  fcmp     d0, d10
0x0004e80c  fcsel    d1, d10, d0, gt
0x0004e810  fcmp     d0, #0.0
0x0004e814  fmov     d0, xzr
0x0004e818  fcsel    d1, d0, d1, mi
0x0004e81c  fcmp     d1, #0.0
0x0004e820  fcsel    d0, d0, d1, mi
0x0004e824  fmov     d1, #0.50000000
0x0004e828  fcmp     d0, d1
0x0004e82c  b.pl     #0x4e844
0x0004e830  fmov     d1, #4.00000000
0x0004e834  fmul     d1, d0, d1
0x0004e838  fmul     d1, d0, d1
0x0004e83c  fmul     d0, d0, d1
0x0004e840  b        #0x4e864
0x0004e844  fmov     d1, #2.00000000
0x0004e848  fmov     d2, #-2.00000000
0x0004e84c  fmadd    d0, d0, d2, d1
0x0004e850  fmov     d1, #3.00000000
0x0004e854  bl       #0x55e14   ; CALL _pow
0x0004e858  fmov     d1, #-0.50000000
0x0004e85c  fmul     d0, d0, d1
0x0004e860  fadd     d0, d0, d10
0x0004e864  fmov     d10, #0.50000000
0x0004e868  fmul     d11, d0, d10
0x0004e86c  fsub     d0, d10, d11
0x0004e870  adrp     x8, #0x8f000
0x0004e874  ldrsw    x20, [x8, #0xa0]
0x0004e878  ldr      x0, [x19, x20]
0x0004e87c  bl       #0x5c3c0   ; CALL objc_msgSend$setStrokeStart:
0x0004e880  fadd     d0, d11, d10
0x0004e884  ldr      x0, [x19, x20]
0x0004e888  bl       #0x5c3a0   ; CALL objc_msgSend$setStrokeEnd:
0x0004e88c  adrp     x8, #0x65000
0x0004e890  ldr      d0, [x8, #0x610]
0x0004e894  fmul     d0, d9, d0
0x0004e898  adrp     x8, #0x66000
0x0004e89c  ldr      d1, [x8, #0x28]
0x0004e8a0  fmul     d12, d9, d1
0x0004e8a4  fsub     d1, d8, d0
0x0004e8a8  fsub     d0, d12, d0
0x0004e8ac  fdiv     d0, d1, d0
0x0004e8b0  fmov     d10, #1.00000000
0x0004e8b4  fcmp     d0, d10
0x0004e8b8  fcsel    d1, d10, d0, gt
0x0004e8bc  fcmp     d0, #0.0
0x0004e8c0  fmov     d11, xzr
0x0004e8c4  fcsel    d0, d11, d1, mi
0x0004e8c8  fcvt     s0, d0
0x0004e8cc  adrp     x8, #0x8f000
0x0004e8d0  ldrsw    x8, [x8, #0x9c]
0x0004e8d4  ldr      x0, [x19, x8]
0x0004e8d8  bl       #0x5b940   ; CALL objc_msgSend$setOpacity:
0x0004e8dc  adrp     x8, #0x66000
0x0004e8e0  ldr      d0, [x8, #0xd8]
0x0004e8e4  fmul     d1, d9, d0
0x0004e8e8  fmov     s0, #1.00000000
0x0004e8ec  fcmp     d8, d12
0x0004e8f0  fccmp    d8, d1, #0, gt
0x0004e8f4  b.mi     #0x4e920
0x0004e8f8  fmov     d0, #2.50000000
0x0004e8fc  fmul     d0, d9, d0
0x0004e900  fcmp     d8, d0
0x0004e904  cset     w8, gt
0x0004e908  adrp     x9, #0x66000
0x0004e90c  ldr      d0, [x9, #0xe0]
0x0004e910  fmul     d0, d9, d0
0x0004e914  fcmp     d8, d0
0x0004e918  csel     w8, wzr, w8, pl
0x0004e91c  ucvtf    s0, w8
0x0004e920  adrp     x8, #0x8f000
0x0004e924  ldrsw    x8, [x8, #0xb8]
0x0004e928  ldr      x0, [x19, x8]
0x0004e92c  bl       #0x5b940   ; CALL objc_msgSend$setOpacity:
0x0004e930  adrp     x8, #0x65000
0x0004e934  ldr      d0, [x8, #0x830]
0x0004e938  fmul     d0, d9, d0
0x0004e93c  fadd     d1, d9, d9
0x0004e940  fsub     d2, d8, d0
0x0004e944  fsub     d0, d1, d0
0x0004e948  fdiv     d0, d2, d0
0x0004e94c  fcmp     d0, d10
0x0004e950  fcsel    d1, d10, d0, gt
0x0004e954  fmov     d2, #0.25000000
0x0004e958  fmul     d1, d1, d2
0x0004e95c  fcmp     d0, #0.0
0x0004e960  fcsel    d0, d11, d1, mi
0x0004e964  fcvt     s0, d0
0x0004e968  adrp     x8, #0x8f000
0x0004e96c  ldrsw    x8, [x8, #0xb4]
0x0004e970  ldr      x0, [x19, x8]
0x0004e974  ldp      x29, x30, [sp, #0x40]
0x0004e978  ldp      x20, x19, [sp, #0x30]
0x0004e97c  ldp      d9, d8, [sp, #0x20]
0x0004e980  ldp      d11, d10, [sp, #0x10]
0x0004e984  ldp      d13, d12, [sp], #0x50
0x0004e988  b        #0x5b940   ; CALL objc_msgSend$setOpacity:

=== -[SSStartupView ss_buildParticles]  va=0x4e98c size=2264 types=v16@0:8
0x0004e98c  sub      sp, sp, #0x170
0x0004e990  stp      d15, d14, [sp, #0xd0]
0x0004e994  stp      d13, d12, [sp, #0xe0]
0x0004e998  stp      d11, d10, [sp, #0xf0]
0x0004e99c  stp      d9, d8, [sp, #0x100]
0x0004e9a0  stp      x28, x27, [sp, #0x110]
0x0004e9a4  stp      x26, x25, [sp, #0x120]
0x0004e9a8  stp      x24, x23, [sp, #0x130]
0x0004e9ac  stp      x22, x21, [sp, #0x140]
0x0004e9b0  stp      x20, x19, [sp, #0x150]
0x0004e9b4  stp      x29, x30, [sp, #0x160]
0x0004e9b8  add      x29, sp, #0x160
0x0004e9bc  mov      x20, x0
0x0004e9c0  adrp     x8, #0x74000
0x0004e9c4  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0004e9c8  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0004e9cc  stur     x8, [x29, #-0xa0]
0x0004e9d0  adrp     x8, #0x8f000
0x0004e9d4  ldrsw    x25, [x8, #0xcc]
0x0004e9d8  ldr      d14, [x0, x25]
0x0004e9dc  adrp     x8, #0x8f000
0x0004e9e0  ldrsw    x8, [x8, #0x54]
0x0004e9e4  add      x8, x0, x8
0x0004e9e8  ldp      d15, d8, [x8]
0x0004e9ec  bl       #0x5d1a0   ; CALL objc_msgSend$ss_host
0x0004e9f0  mov      x29, x29
0x0004e9f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004e9f8  mov      x19, x0
0x0004e9fc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004ea00  mov      x29, x29
0x0004ea04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ea08  mov      x21, x0
0x0004ea0c  fmov     d0, #0.50000000
0x0004ea10  fmul     d11, d15, d0
0x0004ea14  fmul     d9, d8, d0
0x0004ea18  adrp     x8, #0x65000
0x0004ea1c  ldr      d0, [x8, #0x6c0]
0x0004ea20  fmul     d10, d15, d0
0x0004ea24  adrp     x26, #0x8e000
0x0004ea28  ldr      x0, [x26, #0x910]   ; @CLASS UIColor
0x0004ea2c  adrp     x8, #0x65000
0x0004ea30  ldr      d0, [x8, #0x650]
0x0004ea34  adrp     x8, #0x65000
0x0004ea38  ldr      d1, [x8, #0xac0]
0x0004ea3c  adrp     x8, #0x66000
0x0004ea40  ldr      d2, [x8, #0xe8]
0x0004ea44  fmov     d3, #0.25000000
0x0004ea48  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004ea4c  mov      x29, x29
0x0004ea50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ea54  mov      x22, x0
0x0004ea58  ldr      x0, [x26, #0x910]   ; @CLASS UIColor
0x0004ea5c  fmov     d0, xzr
0x0004ea60  fmov     d1, xzr
0x0004ea64  fmov     d2, xzr
0x0004ea68  fmov     d3, xzr
0x0004ea6c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004ea70  mov      x29, x29
0x0004ea74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ea78  mov      x23, x0
0x0004ea7c  str      d11, [sp, #0x68]
0x0004ea80  mov      v0.16b, v11.16b
0x0004ea84  mov      v1.16b, v9.16b
0x0004ea88  mov      v2.16b, v10.16b
0x0004ea8c  mov      x0, x22
0x0004ea90  mov      x1, x23
0x0004ea94  bl       #0x4c190
0x0004ea98  mov      x29, x29
0x0004ea9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004eaa0  mov      x24, x0
0x0004eaa4  mov      x0, x21
0x0004eaa8  mov      x2, x24
0x0004eaac  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004eab0  mov      x0, x24
0x0004eab4  bl       #0x55d78   ; CALL _objc_release
0x0004eab8  mov      x0, x23
0x0004eabc  bl       #0x55d78   ; CALL _objc_release
0x0004eac0  mov      x0, x22
0x0004eac4  bl       #0x55d78   ; CALL _objc_release
0x0004eac8  mov      x0, x21
0x0004eacc  bl       #0x55d78   ; CALL _objc_release
0x0004ead0  mov      x0, x20
0x0004ead4  bl       #0x5cec0   ; CALL objc_msgSend$ss_addCanvas
0x0004ead8  mov      x0, x20
0x0004eadc  bl       #0x590e0   ; CALL objc_msgSend$name
0x0004eae0  mov      x29, x29
0x0004eae4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004eae8  mov      x22, x0
0x0004eaec  bl       #0x4da60
0x0004eaf0  mov      x29, x29
0x0004eaf4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004eaf8  mov      x23, x0
0x0004eafc  bl       #0x58c20   ; CALL objc_msgSend$length
0x0004eb00  cbz      x0, #0x4eb34
0x0004eb04  mov      x0, x20
0x0004eb08  bl       #0x590e0   ; CALL objc_msgSend$name
0x0004eb0c  mov      x29, x29
0x0004eb10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004eb14  mov      x24, x0
0x0004eb18  bl       #0x4da60
0x0004eb1c  mov      x29, x29
0x0004eb20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004eb24  mov      x21, x0
0x0004eb28  mov      x0, x24
0x0004eb2c  bl       #0x55d78   ; CALL _objc_release
0x0004eb30  b        #0x4eb3c
0x0004eb34  adrp     x21, #0x75000
0x0004eb38  add      x21, x21, #0x508   ; STR "OmniCar"
0x0004eb3c  mov      x0, x23
0x0004eb40  bl       #0x55d78   ; CALL _objc_release
0x0004eb44  mov      x0, x22
0x0004eb48  bl       #0x55d78   ; CALL _objc_release
0x0004eb4c  adrp     x8, #0x65000
0x0004eb50  ldr      d0, [x8, #0x828]
0x0004eb54  fmul     d11, d14, d0
0x0004eb58  adrp     x8, #0x74000
0x0004eb5c  ldr      x8, [x8, #0x240]   ; @GOT _UIFontWeightHeavy
0x0004eb60  ldr      d10, [x8]   ; @GOT ___objc_personality_v0
0x0004eb64  mov      v0.16b, v11.16b
0x0004eb68  mov      v1.16b, v10.16b
0x0004eb6c  bl       #0x492e8
0x0004eb70  mov      x29, x29
0x0004eb74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004eb78  mov      x22, x0
0x0004eb7c  adrp     x8, #0x74000
0x0004eb80  ldr      x8, [x8, #0x1d8]   ; @GOT _NSFontAttributeName
0x0004eb84  ldr      x28, [x8]   ; @GOT ___objc_personality_v0
0x0004eb88  str      x28, [sp, #0xb0]
0x0004eb8c  stur     x0, [x29, #-0xa8]
0x0004eb90  adrp     x27, #0x8e000
0x0004eb94  ldr      x0, [x27, #0x970]   ; @CLASS NSDictionary
0x0004eb98  sub      x2, x29, #0xa8
0x0004eb9c  add      x3, sp, #0xb0
0x0004eba0  mov      w4, #1
0x0004eba4  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0004eba8  mov      x29, x29
0x0004ebac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ebb0  mov      x23, x0
0x0004ebb4  mov      x0, x21
0x0004ebb8  mov      x2, x23
0x0004ebbc  bl       #0x5cc00   ; CALL objc_msgSend$sizeWithAttributes:
0x0004ebc0  mov      v13.16b, v0.16b
0x0004ebc4  mov      v12.16b, v1.16b
0x0004ebc8  mov      x0, x23
0x0004ebcc  bl       #0x55d78   ; CALL _objc_release
0x0004ebd0  adrp     x8, #0x65000
0x0004ebd4  ldr      d0, [x8, #0x708]
0x0004ebd8  fmul     d1, d15, d0
0x0004ebdc  fcmp     d13, d1
0x0004ebe0  str      x25, [sp, #0x18]
0x0004ebe4  b.le     #0x4ec5c
0x0004ebe8  fcmp     d13, #0.0
0x0004ebec  b.le     #0x4ec5c
0x0004ebf0  fmul     d1, d11, d15
0x0004ebf4  fmul     d0, d1, d0
0x0004ebf8  fdiv     d0, d0, d13
0x0004ebfc  mov      v1.16b, v10.16b
0x0004ec00  bl       #0x492e8
0x0004ec04  mov      x29, x29
0x0004ec08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ec0c  mov      x23, x0
0x0004ec10  mov      x0, x22
0x0004ec14  bl       #0x55d78   ; CALL _objc_release
0x0004ec18  stp      x28, x23, [sp, #0xa0]
0x0004ec1c  ldr      x0, [x27, #0x970]   ; @CLASS NSDictionary
0x0004ec20  add      x2, sp, #0xa8
0x0004ec24  add      x3, sp, #0xa0
0x0004ec28  mov      w4, #1
0x0004ec2c  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0004ec30  mov      x29, x29
0x0004ec34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ec38  mov      x22, x0
0x0004ec3c  mov      x0, x21
0x0004ec40  mov      x2, x22
0x0004ec44  bl       #0x5cc00   ; CALL objc_msgSend$sizeWithAttributes:
0x0004ec48  mov      v13.16b, v0.16b
0x0004ec4c  mov      v12.16b, v1.16b
0x0004ec50  mov      x0, x22
0x0004ec54  bl       #0x55d78   ; CALL _objc_release
0x0004ec58  mov      x22, x23
0x0004ec5c  fcvtpu   x25, d13
0x0004ec60  mov      x8, #-0x1001
0x0004ec64  add      x9, x25, x8
0x0004ec68  cmn      x9, #0xfff
0x0004ec6c  b.lo     #0x4f1a0
0x0004ec70  fcvtpu   x23, d12
0x0004ec74  add      x8, x23, x8
0x0004ec78  cmn      x8, #0xfff
0x0004ec7c  b.lo     #0x4f1a0
0x0004ec80  mov      x0, #0
0x0004ec84  mov      x1, x25
0x0004ec88  mov      x2, x23
0x0004ec8c  mov      w3, #8
0x0004ec90  mov      x4, #0
0x0004ec94  mov      x5, #0
0x0004ec98  mov      w6, #7
0x0004ec9c  bl       #0x558b0   ; CALL _CGBitmapContextCreate
0x0004eca0  cbz      x0, #0x4f1a0
0x0004eca4  mov      x24, x0
0x0004eca8  str      d9, [sp, #0x60]
0x0004ecac  ucvtf    d10, x23
0x0004ecb0  fmov     d12, xzr
0x0004ecb4  fmov     d0, xzr
0x0004ecb8  mov      v1.16b, v10.16b
0x0004ecbc  bl       #0x559c4   ; CALL _CGContextTranslateCTM
0x0004ecc0  fmov     d11, #1.00000000
0x0004ecc4  fmov     d0, #1.00000000
0x0004ecc8  fmov     d1, #-1.00000000
0x0004eccc  mov      x0, x24
0x0004ecd0  bl       #0x5597c   ; CALL _CGContextScaleCTM
0x0004ecd4  mov      x0, x24
0x0004ecd8  bl       #0x55b38   ; CALL _UIGraphicsPushContext
0x0004ecdc  str      x22, [sp, #0x90]
0x0004ece0  adrp     x8, #0x74000
0x0004ece4  ldr      x8, [x8, #0x1e0]   ; @GOT _NSForegroundColorAttributeName
0x0004ece8  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0004ecec  stp      x28, x8, [sp, #0x80]
0x0004ecf0  ldr      x0, [x26, #0x910]   ; @CLASS UIColor
0x0004ecf4  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0004ecf8  mov      x29, x29
0x0004ecfc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ed00  mov      x26, x0
0x0004ed04  str      x0, [sp, #0x98]
0x0004ed08  ldr      x0, [x27, #0x970]   ; @CLASS NSDictionary
0x0004ed0c  add      x2, sp, #0x90
0x0004ed10  add      x3, sp, #0x80
0x0004ed14  mov      w4, #2
0x0004ed18  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0004ed1c  mov      x29, x29
0x0004ed20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ed24  mov      x27, x0
0x0004ed28  adrp     x8, #0x74000
0x0004ed2c  ldr      x8, [x8, #0x5c8]   ; @GOT _CGPointZero
0x0004ed30  ldp      d0, d1, [x8]
0x0004ed34  mov      x0, x21
0x0004ed38  mov      x2, x27
0x0004ed3c  bl       #0x578a0   ; CALL objc_msgSend$drawAtPoint:withAttributes:
0x0004ed40  mov      x0, x27
0x0004ed44  bl       #0x55d78   ; CALL _objc_release
0x0004ed48  mov      x0, x26
0x0004ed4c  bl       #0x55d78   ; CALL _objc_release
0x0004ed50  bl       #0x55b2c   ; CALL _UIGraphicsPopContext
0x0004ed54  mov      x0, x24
0x0004ed58  bl       #0x558c8   ; CALL _CGBitmapContextGetData
0x0004ed5c  mov      x26, x0
0x0004ed60  mov      x0, x24
0x0004ed64  bl       #0x558bc   ; CALL _CGBitmapContextGetBytesPerRow
0x0004ed68  mov      x27, x0
0x0004ed6c  cbz      x26, #0x4edac
0x0004ed70  mov      x8, #0
0x0004ed74  mov      x9, #0
0x0004ed78  mov      x10, x26
0x0004ed7c  mov      x11, x10
0x0004ed80  mov      x12, x25
0x0004ed84  ldrb     w13, [x11], #1
0x0004ed88  cmp      w13, #0x80
0x0004ed8c  cinc     x8, x8, hi
0x0004ed90  subs     x12, x12, #1
0x0004ed94  b.ne     #0x4ed84
0x0004ed98  add      x9, x9, #1
0x0004ed9c  add      x10, x10, x27
0x0004eda0  cmp      x9, x23
0x0004eda4  b.lo     #0x4ed7c
0x0004eda8  ucvtf    d12, x8
0x0004edac  str      d8, [sp, #0x40]
0x0004edb0  str      x19, [sp, #0x10]
0x0004edb4  mov      x8, #0x4089000000000000
0x0004edb8  fmov     d0, x8
0x0004edbc  fdiv     d0, d12, d0
0x0004edc0  fsqrt    d0, d0
0x0004edc4  fmaxnm   d11, d0, d11
0x0004edc8  adrp     x28, #0x8e000
0x0004edcc  ldr      x0, [x28, #0xc10]   ; @CLASS NSMutableData
0x0004edd0  bl       #0x57540   ; CALL objc_msgSend$data
0x0004edd4  mov      x29, x29
0x0004edd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004eddc  mov      x23, x0
0x0004ede0  fmov     d0, #0.50000000
0x0004ede4  ucvtf    d13, x25
0x0004ede8  cbz      x26, #0x4ee4c
0x0004edec  fmul     d9, d11, d0
0x0004edf0  fcmp     d9, d10
0x0004edf4  b.pl     #0x4ee4c
0x0004edf8  mov      v12.16b, v9.16b
0x0004edfc  fcmp     d9, d13
0x0004ee00  b.pl     #0x4ee40
0x0004ee04  fcvtzu   x8, d12
0x0004ee08  madd     x19, x27, x8, x26
0x0004ee0c  mov      v8.16b, v9.16b
0x0004ee10  fcvtzu   x8, d8
0x0004ee14  ldrb     w8, [x19, x8]
0x0004ee18  cmp      w8, #0x81
0x0004ee1c  b.lo     #0x4ee34
0x0004ee20  stp      d8, d12, [sp, #0x70]
0x0004ee24  add      x2, sp, #0x70
0x0004ee28  mov      x0, x23
0x0004ee2c  mov      w3, #0x10
0x0004ee30  bl       #0x56440   ; CALL objc_msgSend$appendBytes:length:
0x0004ee34  fadd     d8, d11, d8
0x0004ee38  fcmp     d8, d13
0x0004ee3c  b.mi     #0x4ee10
0x0004ee40  fadd     d12, d11, d12
0x0004ee44  fcmp     d12, d10
0x0004ee48  b.mi     #0x4edfc
0x0004ee4c  str      x21, [sp, #8]
0x0004ee50  mov      x0, x24
0x0004ee54  bl       #0x5594c   ; CALL _CGContextRelease
0x0004ee58  mov      x0, x23
0x0004ee5c  bl       #0x58c20   ; CALL objc_msgSend$length
0x0004ee60  mov      x25, x0
0x0004ee64  lsr      x26, x0, #4
0x0004ee68  cmp      x26, #0x384
0x0004ee6c  mov      w8, #0x384
0x0004ee70  csel     x21, x26, x8, lo
0x0004ee74  mov      x0, x23
0x0004ee78  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004ee7c  bl       #0x56ba0   ; CALL objc_msgSend$bytes
0x0004ee80  mov      x24, x0
0x0004ee84  ldr      x0, [x28, #0xc10]   ; @CLASS NSMutableData
0x0004ee88  add      x8, x21, x21, lsl #1
0x0004ee8c  lsl      x2, x8, #4
0x0004ee90  bl       #0x57580   ; CALL objc_msgSend$dataWithLength:
0x0004ee94  mov      x29, x29
0x0004ee98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ee9c  adrp     x8, #0x8f000
0x0004eea0  ldrsw    x19, [x8, #0x94]
0x0004eea4  ldr      x8, [x20, x19]
0x0004eea8  str      x0, [x20, x19]
0x0004eeac  mov      x0, x8
0x0004eeb0  bl       #0x55d78   ; CALL _objc_release
0x0004eeb4  ldr      x0, [x20, x19]
0x0004eeb8  bl       #0x59080   ; CALL objc_msgSend$mutableBytes
0x0004eebc  cmp      x25, #0x10
0x0004eec0  b.lo     #0x4f000
0x0004eec4  mov      x28, #0
0x0004eec8  fmov     d2, #0.50000000
0x0004eecc  fmul     d0, d13, d2
0x0004eed0  ldp      d1, d3, [sp, #0x60]
0x0004eed4  fsub     d4, d3, d0
0x0004eed8  fmov     d0, #-20.00000000
0x0004eedc  fmadd    d0, d14, d0, d1
0x0004eee0  fmul     d1, d10, d2
0x0004eee4  fsub     d0, d0, d1
0x0004eee8  stp      d0, d4, [sp, #0x60]
0x0004eeec  mov      x8, #-0x3f97000000000000
0x0004eef0  fmov     d0, x8
0x0004eef4  fmul     d10, d14, d0
0x0004eef8  mov      x8, #0x4069000000000000
0x0004eefc  fmov     d0, x8
0x0004ef00  fmadd    d1, d14, d0, d15
0x0004ef04  fsub     d1, d1, d10
0x0004ef08  str      d1, [sp, #0x58]
0x0004ef0c  ldr      d1, [sp, #0x40]
0x0004ef10  fmadd    d0, d14, d0, d1
0x0004ef14  fsub     d13, d0, d10
0x0004ef18  add      x19, x0, #0x10
0x0004ef1c  adrp     x8, #0x65000
0x0004ef20  ldr      d14, [x8, #0xf10]
0x0004ef24  adrp     x8, #0x66000
0x0004ef28  ldr      q1, [x8, #0x2f0]
0x0004ef2c  mov      x8, #0x848000000000
0x0004ef30  movk     x8, #0x412e, lsl #48
0x0004ef34  dup      v0.2d, x8
0x0004ef38  stp      q0, q1, [sp, #0x30]
0x0004ef3c  adrp     x8, #0x66000
0x0004ef40  ldr      q0, [x8, #0x300]
0x0004ef44  str      q0, [sp, #0x20]
0x0004ef48  mov      x27, x21
0x0004ef4c  udiv     x8, x28, x21
0x0004ef50  add      x8, x24, x8, lsl #4
0x0004ef54  ldp      d0, d1, [x8]
0x0004ef58  ldr      d2, [sp, #0x68]
0x0004ef5c  fadd     d15, d2, d0
0x0004ef60  ldr      d0, [sp, #0x60]
0x0004ef64  fadd     d9, d0, d1
0x0004ef68  mov      w0, #0x4241
0x0004ef6c  movk     w0, #0xf, lsl #16
0x0004ef70  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004ef74  ucvtf    d0, w0
0x0004ef78  ldr      d1, [sp, #0x58]
0x0004ef7c  fmul     d0, d1, d0
0x0004ef80  fdiv     d0, d0, d14
0x0004ef84  fadd     d8, d10, d0
0x0004ef88  mov      w0, #0x4241
0x0004ef8c  movk     w0, #0xf, lsl #16
0x0004ef90  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004ef94  ucvtf    d0, w0
0x0004ef98  fmul     d0, d13, d0
0x0004ef9c  fdiv     d0, d0, d14
0x0004efa0  fadd     d12, d10, d0
0x0004efa4  mov      w0, #0x4241
0x0004efa8  movk     w0, #0xf, lsl #16
0x0004efac  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004efb0  mov      x25, x0
0x0004efb4  mov      w0, #0x4241
0x0004efb8  movk     w0, #0xf, lsl #16
0x0004efbc  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0004efc0  stp      d15, d9, [x19, #-0x10]
0x0004efc4  stp      d8, d12, [x19]
0x0004efc8  fmov     s0, w25
0x0004efcc  mov      v0.s[1], w0
0x0004efd0  ushll    v0.2d, v0.2s, #0
0x0004efd4  ucvtf    v0.2d, v0.2d
0x0004efd8  ldp      q1, q2, [sp, #0x30]
0x0004efdc  fmul     v0.2d, v0.2d, v2.2d
0x0004efe0  fdiv     v0.2d, v0.2d, v1.2d
0x0004efe4  ldr      q1, [sp, #0x20]
0x0004efe8  fadd     v0.2d, v0.2d, v1.2d
0x0004efec  str      q0, [x19, #0x10]
0x0004eff0  add      x19, x19, #0x30
0x0004eff4  add      x28, x28, x26
0x0004eff8  subs     x27, x27, #1
0x0004effc  b.ne     #0x4ef4c
0x0004f000  adrp     x8, #0x65000
0x0004f004  ldr      d0, [x8, #0x838]
0x0004f008  fmul     d0, d11, d0
0x0004f00c  fmov     d1, #1.50000000
0x0004f010  fmaxnm   d0, d0, d1
0x0004f014  adrp     x8, #0x8f000
0x0004f018  ldrsw    x8, [x8, #0xe0]
0x0004f01c  str      d0, [x20, x8]
0x0004f020  mov      x0, x20
0x0004f024  bl       #0x575a0   ; CALL objc_msgSend$date
0x0004f028  mov      x29, x29
0x0004f02c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004f030  mov      x24, x0
0x0004f034  cbz      x0, #0x4f048
0x0004f038  mov      x0, x24
0x0004f03c  bl       #0x45c90   ; CALL _SSPeriodForDate
0x0004f040  mov      x25, x0
0x0004f044  b        #0x4f070
0x0004f048  adrp     x8, #0x8e000
0x0004f04c  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x0004f050  bl       #0x575a0   ; CALL objc_msgSend$date
0x0004f054  mov      x29, x29
0x0004f058  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004f05c  mov      x26, x0
0x0004f060  bl       #0x45c90   ; CALL _SSPeriodForDate
0x0004f064  mov      x25, x0
0x0004f068  mov      x0, x26
0x0004f06c  bl       #0x55d78   ; CALL _objc_release
0x0004f070  ldp      x21, x19, [sp, #8]
0x0004f074  mov      x0, x24
0x0004f078  bl       #0x55d78   ; CALL _objc_release
0x0004f07c  mov      x0, x25
0x0004f080  bl       #0x4f204
0x0004f084  mov      x29, x29
0x0004f088  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004f08c  mov      x25, x0
0x0004f090  adrp     x8, #0x8f000
0x0004f094  ldrsw    x8, [x8, #0xd0]
0x0004f098  ldr      d0, [x20, x8]
0x0004f09c  ldr      x8, [sp, #0x18]
0x0004f0a0  ldr      d1, [x20, x8]
0x0004f0a4  mov      x8, #0x4089000000000000
0x0004f0a8  fmov     d2, x8
0x0004f0ac  fmadd    d0, d1, d2, d0
0x0004f0b0  adrp     x8, #0x8f000
0x0004f0b4  ldrsw    x8, [x8, #0xd4]
0x0004f0b8  ldr      d2, [x20, x8]
0x0004f0bc  adrp     x8, #0x66000
0x0004f0c0  ldr      d3, [x8, #0xf0]
0x0004f0c4  adrp     x8, #0x74000
0x0004f0c8  ldr      x8, [x8, #0x260]   ; @GOT _UIFontWeightSemibold
0x0004f0cc  fmadd    d1, d1, d3, d2
0x0004f0d0  ldr      d3, [x8]   ; @GOT ___objc_personality_v0
0x0004f0d4  adrp     x8, #0x8f000
0x0004f0d8  ldrsw    x8, [x8, #0x7c]
0x0004f0dc  ldr      x5, [x20, x8]
0x0004f0e0  mov      x8, #0x4040000000000000
0x0004f0e4  fmov     d2, x8
0x0004f0e8  fmov     d4, xzr
0x0004f0ec  mov      x0, x20
0x0004f0f0  mov      x2, x25
0x0004f0f4  mov      x3, #0
0x0004f0f8  mov      w4, #0
0x0004f0fc  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x0004f100  mov      x29, x29
0x0004f104  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004f108  mov      x24, x0
0x0004f10c  mov      x0, x25
0x0004f110  bl       #0x55d78   ; CALL _objc_release
0x0004f114  adrp     x8, #0x65000
0x0004f118  ldr      d1, [x8, #0xfa8]
0x0004f11c  fmov     d0, #2.00000000
0x0004f120  fmov     d2, #1.00000000
0x0004f124  mov      x0, x20
0x0004f128  mov      x2, x24
0x0004f12c  bl       #0x5d160   ; CALL objc_msgSend$ss_fade:from:to:alpha:
0x0004f130  mov      x29, x29
0x0004f134  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004f138  mov      x25, x0
0x0004f13c  mov      x0, x20
0x0004f140  bl       #0x57920   ; CALL objc_msgSend$duration
0x0004f144  fmov     d1, #1.50000000
0x0004f148  fcmp     d0, d1
0x0004f14c  b.le     #0x4f188
0x0004f150  mov      x0, x20
0x0004f154  bl       #0x57920   ; CALL objc_msgSend$duration
0x0004f158  adrp     x8, #0x66000
0x0004f15c  ldr      d1, [x8, #0xf8]
0x0004f160  fadd     d0, d0, d1
0x0004f164  mov      x0, x25
0x0004f168  bl       #0x5b980   ; CALL objc_msgSend$setOutA:
0x0004f16c  mov      x0, x20
0x0004f170  bl       #0x57920   ; CALL objc_msgSend$duration
0x0004f174  adrp     x8, #0x66000
0x0004f178  ldr      d1, [x8, #0x68]
0x0004f17c  fadd     d0, d0, d1
0x0004f180  mov      x0, x25
0x0004f184  bl       #0x5b9a0   ; CALL objc_msgSend$setOutB:
0x0004f188  mov      x0, x25
0x0004f18c  bl       #0x55d78   ; CALL _objc_release
0x0004f190  mov      x0, x24
0x0004f194  bl       #0x55d78   ; CALL _objc_release
0x0004f198  mov      x0, x23
0x0004f19c  bl       #0x55d78   ; CALL _objc_release
0x0004f1a0  mov      x0, x22
0x0004f1a4  bl       #0x55d78   ; CALL _objc_release
0x0004f1a8  mov      x0, x21
0x0004f1ac  bl       #0x55d78   ; CALL _objc_release
0x0004f1b0  mov      x0, x19
0x0004f1b4  bl       #0x55d78   ; CALL _objc_release
0x0004f1b8  ldur     x8, [x29, #-0xa0]
0x0004f1bc  adrp     x9, #0x74000
0x0004f1c0  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0004f1c4  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0004f1c8  cmp      x9, x8
0x0004f1cc  b.ne     #0x4f200
0x0004f1d0  ldp      x29, x30, [sp, #0x160]
0x0004f1d4  ldp      x20, x19, [sp, #0x150]
0x0004f1d8  ldp      x22, x21, [sp, #0x140]
0x0004f1dc  ldp      x24, x23, [sp, #0x130]
0x0004f1e0  ldp      x26, x25, [sp, #0x120]
0x0004f1e4  ldp      x28, x27, [sp, #0x110]
0x0004f1e8  ldp      d9, d8, [sp, #0x100]
0x0004f1ec  ldp      d11, d10, [sp, #0xf0]
0x0004f1f0  ldp      d13, d12, [sp, #0xe0]
0x0004f1f4  ldp      d15, d14, [sp, #0xd0]
0x0004f1f8  add      sp, sp, #0x170
0x0004f1fc  ret      
0x0004f200  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0004f204  stp      x29, x30, [sp, #-0x10]!
0x0004f208  mov      x29, sp
0x0004f20c  cmp      x0, #1
0x0004f210  b.eq     #0x4f22c
0x0004f214  cbnz     x0, #0x4f240
0x0004f218  adrp     x0, #0x7e000
0x0004f21c  add      x0, x0, #0x428   ; STR "Chào buổi sáng"
0x0004f220  adrp     x1, #0x7e000
0x0004f224  add      x1, x1, #0x448   ; STR "Good morning"
0x0004f228  b        #0x4f250
0x0004f22c  adrp     x0, #0x7e000
0x0004f230  add      x0, x0, #0x468   ; STR "Chào buổi chiều"
0x0004f234  adrp     x1, #0x7e000
0x0004f238  add      x1, x1, #0x488   ; STR "Good afternoon"
0x0004f23c  b        #0x4f250
0x0004f240  adrp     x0, #0x7e000
0x0004f244  add      x0, x0, #0x4a8   ; STR "Chào buổi tối"
0x0004f248  adrp     x1, #0x7e000
0x0004f24c  add      x1, x1, #0x4c8   ; STR "Good evening"
0x0004f250  bl       #0x5505c   ; CALL _OMCTr
0x0004f254  mov      x29, x29
0x0004f258  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004f25c  ldp      x29, x30, [sp], #0x10
0x0004f260  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[SSStartupView ss_drawParticles:t:]  va=0x4f264 size=1192 types=v32@0:8^{CGContext=}16d24
0x0004f264  sub      sp, sp, #0x120
0x0004f268  stp      d15, d14, [sp, #0xa0]
0x0004f26c  stp      d13, d12, [sp, #0xb0]
0x0004f270  stp      d11, d10, [sp, #0xc0]
0x0004f274  stp      d9, d8, [sp, #0xd0]
0x0004f278  stp      x28, x27, [sp, #0xe0]
0x0004f27c  stp      x22, x21, [sp, #0xf0]
0x0004f280  stp      x20, x19, [sp, #0x100]
0x0004f284  stp      x29, x30, [sp, #0x110]
0x0004f288  add      x29, sp, #0x110
0x0004f28c  mov      v8.16b, v0.16b
0x0004f290  mov      x19, x2
0x0004f294  mov      x22, x0
0x0004f298  adrp     x8, #0x74000
0x0004f29c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0004f2a0  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0004f2a4  stur     x8, [x29, #-0x78]
0x0004f2a8  adrp     x8, #0x8f000
0x0004f2ac  ldrsw    x20, [x8, #0x94]
0x0004f2b0  ldr      x0, [x0, x20]
0x0004f2b4  bl       #0x58c20   ; CALL objc_msgSend$length
0x0004f2b8  cmp      x0, #0x30
0x0004f2bc  b.lo     #0x4f5a0
0x0004f2c0  mov      x21, x0
0x0004f2c4  ldr      x0, [x22, x20]
0x0004f2c8  bl       #0x56ba0   ; CALL objc_msgSend$bytes
0x0004f2cc  mov      x20, x0
0x0004f2d0  adrp     x8, #0x8f000
0x0004f2d4  ldrsw    x8, [x8, #0xcc]
0x0004f2d8  ldr      d9, [x22, x8]
0x0004f2dc  adrp     x8, #0x8f000
0x0004f2e0  ldrsw    x8, [x8, #0x54]
0x0004f2e4  add      x8, x22, x8
0x0004f2e8  ldr      d10, [x8, #8]
0x0004f2ec  adrp     x8, #0x8f000
0x0004f2f0  ldrsw    x8, [x8, #0xe0]
0x0004f2f4  ldr      d12, [x22, x8]
0x0004f2f8  mov      x0, x22
0x0004f2fc  bl       #0x57920   ; CALL objc_msgSend$duration
0x0004f300  fmov     d1, #1.50000000
0x0004f304  fcmp     d0, d1
0x0004f308  fmov     d0, xzr
0x0004f30c  str      d0, [sp, #0x70]
0x0004f310  b.le     #0x4f3bc
0x0004f314  mov      x0, x22
0x0004f318  bl       #0x57920   ; CALL objc_msgSend$duration
0x0004f31c  adrp     x8, #0x66000
0x0004f320  ldr      d1, [x8, #0xf8]
0x0004f324  fadd     d11, d0, d1
0x0004f328  mov      x0, x22
0x0004f32c  bl       #0x57920   ; CALL objc_msgSend$duration
0x0004f330  adrp     x8, #0x65000
0x0004f334  ldr      d1, [x8, #0xf98]
0x0004f338  fadd     d0, d0, d1
0x0004f33c  fsub     d1, d8, d11
0x0004f340  fsub     d0, d0, d11
0x0004f344  fdiv     d0, d1, d0
0x0004f348  fmov     d11, #1.00000000
0x0004f34c  fcmp     d0, d11
0x0004f350  fcsel    d1, d11, d0, gt
0x0004f354  fcmp     d0, #0.0
0x0004f358  fmov     d0, xzr
0x0004f35c  fcsel    d1, d0, d1, mi
0x0004f360  fcmp     d1, #0.0
0x0004f364  fcsel    d0, d0, d1, mi
0x0004f368  fmov     d1, #0.50000000
0x0004f36c  fcmp     d0, d1
0x0004f370  b.pl     #0x4f388
0x0004f374  fmov     d1, #4.00000000
0x0004f378  fmul     d1, d0, d1
0x0004f37c  fmul     d1, d0, d1
0x0004f380  fmul     d0, d0, d1
0x0004f384  b        #0x4f3a8
0x0004f388  fmov     d1, #2.00000000
0x0004f38c  fmov     d2, #-2.00000000
0x0004f390  fmadd    d0, d0, d2, d1
0x0004f394  fmov     d1, #3.00000000
0x0004f398  bl       #0x55e14   ; CALL _pow
0x0004f39c  fmov     d1, #-0.50000000
0x0004f3a0  fmul     d0, d0, d1
0x0004f3a4  fadd     d0, d0, d11
0x0004f3a8  str      d0, [sp, #0x70]
0x0004f3ac  fmov     d0, #1.00000000
0x0004f3b0  ldr      d1, [sp, #0x70]
0x0004f3b4  fcmp     d1, d0
0x0004f3b8  b.ge     #0x4f5a0
0x0004f3bc  mov      x8, #-0x5555555555555556
0x0004f3c0  movk     x8, #0xaaab
0x0004f3c4  umulh    x8, x21, x8
0x0004f3c8  lsr      x21, x8, #5
0x0004f3cc  mov      x0, x19
0x0004f3d0  mov      w1, #0x1b
0x0004f3d4  bl       #0x55988   ; CALL _CGContextSetBlendMode
0x0004f3d8  fmov     d0, #0.50000000
0x0004f3dc  fmul     d0, d10, d0
0x0004f3e0  str      d0, [sp, #0x68]
0x0004f3e4  adrp     x8, #0x65000
0x0004f3e8  ldr      d0, [x8, #0x9b0]
0x0004f3ec  ldr      d1, [sp, #0x70]
0x0004f3f0  fmul     d0, d1, d0
0x0004f3f4  fmul     d0, d0, d9
0x0004f3f8  str      d0, [sp, #0x60]
0x0004f3fc  fmov     d0, #1.00000000
0x0004f400  fsub     d0, d0, d1
0x0004f404  str      d0, [sp, #0x50]
0x0004f408  cmp      x21, #1
0x0004f40c  csinc    x21, x21, xzr, hi
0x0004f410  add      x20, x20, #0x18
0x0004f414  adrp     x8, #0x65000
0x0004f418  ldr      d0, [x8, #0x728]
0x0004f41c  str      d0, [sp, #0x48]
0x0004f420  adrp     x8, #0x66000
0x0004f424  ldr      d0, [x8, #0xd0]
0x0004f428  str      d0, [sp, #0x40]
0x0004f42c  adrp     x8, #0x66000
0x0004f430  ldr      d0, [x8, #0x100]
0x0004f434  str      d0, [sp, #0x38]
0x0004f438  adrp     x8, #0x65000
0x0004f43c  ldr      d0, [x8, #0x6e8]
0x0004f440  str      d0, [sp, #0x30]
0x0004f444  adrp     x8, #0x65000
0x0004f448  ldr      d0, [x8, #0x660]
0x0004f44c  str      d0, [sp, #0x28]
0x0004f450  adrp     x8, #0x65000
0x0004f454  ldr      d0, [x8, #0x998]
0x0004f458  str      d0, [sp, #0x20]
0x0004f45c  adrp     x8, #0x65000
0x0004f460  ldr      d0, [x8, #0x700]
0x0004f464  str      d0, [sp, #0x18]
0x0004f468  adrp     x8, #0x65000
0x0004f46c  ldr      d0, [x8, #0x608]
0x0004f470  stp      d9, d0, [sp, #8]
0x0004f474  str      d8, [sp]
0x0004f478  str      d12, [sp, #0x58]
0x0004f47c  ldp      d14, d12, [x20, #-0x18]
0x0004f480  ldp      d11, d13, [x20, #-8]
0x0004f484  ldp      d0, d1, [x20, #8]
0x0004f488  str      d1, [sp, #0x78]
0x0004f48c  ldp      d2, d1, [sp, #0x40]
0x0004f490  fadd     d1, d0, d1
0x0004f494  fadd     d0, d0, d2
0x0004f498  ldr      d8, [sp]
0x0004f49c  fsub     d2, d8, d1
0x0004f4a0  fsub     d0, d0, d1
0x0004f4a4  fdiv     d0, d2, d0
0x0004f4a8  fmov     d15, #1.00000000
0x0004f4ac  fcmp     d0, d15
0x0004f4b0  fcsel    d1, d15, d0, gt
0x0004f4b4  fcmp     d0, #0.0
0x0004f4b8  fmov     d10, xzr
0x0004f4bc  fcsel    d9, d10, d1, mi
0x0004f4c0  fsub     d0, d15, d9
0x0004f4c4  fmov     d1, #3.00000000
0x0004f4c8  bl       #0x55e14   ; CALL _pow
0x0004f4cc  fsub     d0, d15, d0
0x0004f4d0  fcmp     d9, #0.0
0x0004f4d4  fcsel    d9, d10, d0, mi
0x0004f4d8  fsub     d0, d14, d11
0x0004f4dc  fmadd    d11, d0, d9, d11
0x0004f4e0  fsub     d0, d12, d13
0x0004f4e4  fmadd    d13, d0, d9, d13
0x0004f4e8  ldr      d15, [sp, #8]
0x0004f4ec  fdiv     d0, d14, d15
0x0004f4f0  ldr      d1, [sp, #0x38]
0x0004f4f4  fmul     d0, d0, d1
0x0004f4f8  fmov     d1, #3.00000000
0x0004f4fc  fmadd    d0, d8, d1, d0
0x0004f500  bl       #0x55e20   ; CALL _sin
0x0004f504  fmov     d1, #1.50000000
0x0004f508  fmul     d0, d0, d1
0x0004f50c  fmul     d0, d15, d0
0x0004f510  fmadd    d11, d0, d9, d11
0x0004f514  ldp      d0, d1, [sp, #0x68]
0x0004f518  fsub     d0, d12, d0
0x0004f51c  fmul     d0, d1, d0
0x0004f520  ldr      d1, [sp, #0x60]
0x0004f524  ldr      d2, [sp, #0x30]
0x0004f528  fmadd    d0, d0, d2, d1
0x0004f52c  fadd     d12, d0, d13
0x0004f530  ldp      d1, d0, [sp, #0x20]
0x0004f534  fmadd    d0, d9, d1, d0
0x0004f538  ldr      d1, [sp, #0x50]
0x0004f53c  fmul     d13, d1, d0
0x0004f540  fmov     d0, #4.00000000
0x0004f544  fmadd    d0, d8, d0, d14
0x0004f548  bl       #0x55e20   ; CALL _sin
0x0004f54c  ldp      d2, d1, [sp, #0x10]
0x0004f550  fmadd    d2, d0, d2, d1
0x0004f554  fmov     d1, #1.00000000
0x0004f558  add      x0, sp, #0x80
0x0004f55c  ldr      d0, [sp, #0x78]
0x0004f560  bl       #0x4f5e4
0x0004f564  ldp      d0, d1, [sp, #0x80]
0x0004f568  ldr      d2, [sp, #0x90]
0x0004f56c  mov      x0, x19
0x0004f570  mov      v3.16b, v13.16b
0x0004f574  bl       #0x559ac   ; CALL _CGContextSetRGBFillColor
0x0004f578  mov      x0, x19
0x0004f57c  mov      v0.16b, v11.16b
0x0004f580  mov      v1.16b, v12.16b
0x0004f584  ldr      d12, [sp, #0x58]
0x0004f588  mov      v2.16b, v12.16b
0x0004f58c  mov      v3.16b, v12.16b
0x0004f590  bl       #0x55940   ; CALL _CGContextFillRect
0x0004f594  add      x20, x20, #0x30
0x0004f598  subs     x21, x21, #1
0x0004f59c  b.ne     #0x4f47c
0x0004f5a0  ldur     x8, [x29, #-0x78]
0x0004f5a4  adrp     x9, #0x74000
0x0004f5a8  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0004f5ac  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0004f5b0  cmp      x9, x8
0x0004f5b4  b.ne     #0x4f5e0
0x0004f5b8  ldp      x29, x30, [sp, #0x110]
0x0004f5bc  ldp      x20, x19, [sp, #0x100]
0x0004f5c0  ldp      x22, x21, [sp, #0xf0]
0x0004f5c4  ldp      x28, x27, [sp, #0xe0]
0x0004f5c8  ldp      d9, d8, [sp, #0xd0]
0x0004f5cc  ldp      d11, d10, [sp, #0xc0]
0x0004f5d0  ldp      d13, d12, [sp, #0xb0]
0x0004f5d4  ldp      d15, d14, [sp, #0xa0]
0x0004f5d8  add      sp, sp, #0x120
0x0004f5dc  ret      
0x0004f5e0  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0004f5e4  fmov     d5, #-1.00000000
0x0004f5e8  fmov     d4, #2.00000000
0x0004f5ec  fmadd    d3, d2, d4, d5
0x0004f5f0  fabs     d6, d3
0x0004f5f4  fmov     d3, #1.00000000
0x0004f5f8  fsub     d6, d3, d6
0x0004f5fc  fmul     d1, d1, d6
0x0004f600  adrp     x8, #0x66000
0x0004f604  ldr      d6, [x8, #0x108]
0x0004f608  fdiv     d6, d0, d6
0x0004f60c  frintm   d6, d6
0x0004f610  adrp     x8, #0x66000
0x0004f614  ldr      d7, [x8, #0x110]
0x0004f618  fmadd    d0, d6, d7, d0
0x0004f61c  mov      x8, #0x404e000000000000
0x0004f620  fmov     d6, x8
0x0004f624  fdiv     d6, d0, d6
0x0004f628  fmov     d0, #0.50000000
0x0004f62c  fmul     d0, d6, d0
0x0004f630  frintz   d0, d0
0x0004f634  fmsub    d0, d0, d4, d6
0x0004f638  movi     v7.2d, #0xffffffffffffffff
0x0004f63c  fneg     v7.2d, v7.2d
0x0004f640  bif      v0.16b, v6.16b, v7.16b
0x0004f644  fadd     d0, d0, d5
0x0004f648  fabs     d0, d0
0x0004f64c  fsub     d0, d3, d0
0x0004f650  fmul     d5, d1, d0
0x0004f654  fmov     d0, xzr
0x0004f658  fcmp     d6, d3
0x0004f65c  b.pl     #0x4f66c
0x0004f660  fmov     d4, xzr
0x0004f664  mov      v6.16b, v1.16b
0x0004f668  b        #0x4f6b8
0x0004f66c  fmov     d7, xzr
0x0004f670  fmov     d16, #3.00000000
0x0004f674  fmov     d17, #4.00000000
0x0004f678  fmov     d18, #5.00000000
0x0004f67c  fcmp     d6, d18
0x0004f680  fcsel    d18, d1, d5, mi
0x0004f684  fcsel    d19, d5, d1, mi
0x0004f688  fcmp     d6, d17
0x0004f68c  fcsel    d17, d5, d7, mi
0x0004f690  fcsel    d18, d1, d18, mi
0x0004f694  fcsel    d19, d7, d19, mi
0x0004f698  fcmp     d6, d16
0x0004f69c  fcsel    d16, d1, d17, mi
0x0004f6a0  fcsel    d17, d5, d18, mi
0x0004f6a4  fcsel    d18, d7, d19, mi
0x0004f6a8  fcmp     d6, d4
0x0004f6ac  fcsel    d6, d5, d18, mi
0x0004f6b0  fcsel    d5, d1, d16, mi
0x0004f6b4  fcsel    d4, d7, d17, mi
0x0004f6b8  fmov     d7, #-0.50000000
0x0004f6bc  fmul     d1, d1, d7
0x0004f6c0  fadd     d1, d2, d1
0x0004f6c4  fadd     d2, d1, d6
0x0004f6c8  fcmp     d2, d3
0x0004f6cc  fcsel    d6, d3, d2, gt
0x0004f6d0  fcmp     d2, #0.0
0x0004f6d4  fcsel    d2, d0, d6, mi
0x0004f6d8  fadd     d5, d1, d5
0x0004f6dc  fcmp     d5, d3
0x0004f6e0  fcsel    d6, d3, d5, gt
0x0004f6e4  fcmp     d5, #0.0
0x0004f6e8  fcsel    d5, d0, d6, mi
0x0004f6ec  stp      d2, d5, [x0]
0x0004f6f0  fadd     d1, d1, d4
0x0004f6f4  fcmp     d1, d3
0x0004f6f8  fcsel    d2, d3, d1, gt
0x0004f6fc  fcmp     d1, #0.0
0x0004f700  fcsel    d0, d0, d2, mi
0x0004f704  str      d0, [x0, #0x10]
0x0004f708  ret      

=== -[SSStartupView ss_buildHud]  va=0x4f70c size=3472 types=v16@0:8
0x0004f70c  sub      sp, sp, #0x160
0x0004f710  stp      d15, d14, [sp, #0xc0]
0x0004f714  stp      d13, d12, [sp, #0xd0]
0x0004f718  stp      d11, d10, [sp, #0xe0]
0x0004f71c  stp      d9, d8, [sp, #0xf0]
0x0004f720  stp      x28, x27, [sp, #0x100]
0x0004f724  stp      x26, x25, [sp, #0x110]
0x0004f728  stp      x24, x23, [sp, #0x120]
0x0004f72c  stp      x22, x21, [sp, #0x130]
0x0004f730  stp      x20, x19, [sp, #0x140]
0x0004f734  stp      x29, x30, [sp, #0x150]
0x0004f738  add      x29, sp, #0x150
0x0004f73c  mov      x20, x0
0x0004f740  adrp     x8, #0x74000
0x0004f744  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0004f748  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0004f74c  stur     x8, [x29, #-0xa0]
0x0004f750  adrp     x8, #0x8f000
0x0004f754  ldrsw    x21, [x8, #0xcc]
0x0004f758  ldr      d12, [x0, x21]
0x0004f75c  bl       #0x5d1a0   ; CALL objc_msgSend$ss_host
0x0004f760  mov      x29, x29
0x0004f764  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004f768  mov      x19, x0
0x0004f76c  adrp     x8, #0x8f000
0x0004f770  ldrsw    x8, [x8, #0xd0]
0x0004f774  stp      x8, x21, [sp, #0x68]
0x0004f778  ldr      d0, [x20, x8]
0x0004f77c  ldr      d1, [x20, x21]
0x0004f780  mov      x8, #0x4079000000000000
0x0004f784  fmov     d2, x8
0x0004f788  adrp     x8, #0x8f000
0x0004f78c  ldrsw    x8, [x8, #0xd4]
0x0004f790  str      x8, [sp, #0x60]
0x0004f794  ldr      d3, [x20, x8]
0x0004f798  fmadd    d10, d1, d2, d0
0x0004f79c  adrp     x8, #0x65000
0x0004f7a0  ldr      d0, [x8, #0x638]
0x0004f7a4  fmadd    d11, d1, d0, d3
0x0004f7a8  adrp     x8, #0x8e000
0x0004f7ac  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0004f7b0  adrp     x8, #0x65000
0x0004f7b4  ldr      d0, [x8, #0x9c0]
0x0004f7b8  adrp     x8, #0x65000
0x0004f7bc  ldr      d1, [x8, #0xf30]
0x0004f7c0  adrp     x8, #0x65000
0x0004f7c4  ldr      d3, [x8, #0x838]
0x0004f7c8  fmov     d13, #1.00000000
0x0004f7cc  fmov     d2, #1.00000000
0x0004f7d0  str      d0, [sp, #0x20]
0x0004f7d4  str      d1, [sp, #0x50]
0x0004f7d8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004f7dc  mov      x29, x29
0x0004f7e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004f7e4  str      x0, [sp, #0x58]
0x0004f7e8  mov      x21, #0
0x0004f7ec  mov      x8, #0x4044000000000000
0x0004f7f0  fmov     d0, x8
0x0004f7f4  fmul     d4, d12, d0
0x0004f7f8  fmov     d0, #16.00000000
0x0004f7fc  fmul     d0, d12, d0
0x0004f800  stp      d0, d4, [sp, #0x40]
0x0004f804  fmov     d0, #6.00000000
0x0004f808  fmul     d4, d12, d0
0x0004f80c  fmov     d0, #10.00000000
0x0004f810  fmul     d0, d12, d0
0x0004f814  stp      d0, d4, [sp, #0x30]
0x0004f818  adrp     x26, #0x8e000
0x0004f81c  adrp     x8, #0x65000
0x0004f820  ldr      d8, [x8, #0xb98]
0x0004f824  fmov     d14, #2.00000000
0x0004f828  fmov     d15, #3.00000000
0x0004f82c  adrp     x27, #0x8e000
0x0004f830  adrp     x28, #0x8f000
0x0004f834  adrp     x8, #0x66000
0x0004f838  add      x8, x8, #0x3e0
0x0004f83c  ldr      d0, [x8, x21, lsl #3]
0x0004f840  fmul     d9, d12, d0
0x0004f844  adrp     x8, #0x8e000
0x0004f848  ldr      x0, [x8, #0xb48]   ; @CLASS CAShapeLayer
0x0004f84c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004f850  mov      x29, x29
0x0004f854  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004f858  mov      x22, x0
0x0004f85c  fadd     d2, d9, d9
0x0004f860  fmov     d0, xzr
0x0004f864  fmov     d1, xzr
0x0004f868  mov      v3.16b, v2.16b
0x0004f86c  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x0004f870  mov      x0, x22
0x0004f874  mov      v0.16b, v10.16b
0x0004f878  mov      v1.16b, v11.16b
0x0004f87c  bl       #0x5bc00   ; CALL objc_msgSend$setPosition:
0x0004f880  ldr      x0, [x26, #0xac0]   ; @CLASS UIBezierPath
0x0004f884  fmov     d3, xzr
0x0004f888  mov      v0.16b, v9.16b
0x0004f88c  mov      v1.16b, v9.16b
0x0004f890  mov      v2.16b, v9.16b
0x0004f894  mov      v4.16b, v8.16b
0x0004f898  mov      w2, #1
0x0004f89c  bl       #0x56800   ; CALL objc_msgSend$bezierPathWithArcCenter:radius:startAngle:endAngle:clockwise:
0x0004f8a0  mov      x29, x29
0x0004f8a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004f8a8  mov      x23, x0
0x0004f8ac  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004f8b0  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x0004f8b4  mov      x2, x0
0x0004f8b8  mov      x0, x22
0x0004f8bc  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x0004f8c0  mov      x0, x23
0x0004f8c4  bl       #0x55d78   ; CALL _objc_release
0x0004f8c8  mov      x0, x22
0x0004f8cc  mov      x2, #0
0x0004f8d0  bl       #0x5ae40   ; CALL objc_msgSend$setFillColor:
0x0004f8d4  ldr      x0, [sp, #0x58]
0x0004f8d8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004f8dc  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004f8e0  mov      x2, x0
0x0004f8e4  mov      x0, x22
0x0004f8e8  bl       #0x5c380   ; CALL objc_msgSend$setStrokeColor:
0x0004f8ec  cmp      x21, #0
0x0004f8f0  fcsel    d0, d15, d14, eq
0x0004f8f4  fmul     d0, d12, d0
0x0004f8f8  fmaxnm   d0, d0, d13
0x0004f8fc  mov      x0, x22
0x0004f900  bl       #0x5b3a0   ; CALL objc_msgSend$setLineWidth:
0x0004f904  cmp      w21, #2
0x0004f908  b.eq     #0x4f95c
0x0004f90c  cmp      w21, #1
0x0004f910  b.ne     #0x4f9d8
0x0004f914  ldr      x0, [x27, #0x928]   ; @CLASS NSNumber
0x0004f918  ldr      d0, [sp, #0x38]
0x0004f91c  bl       #0x592e0   ; CALL objc_msgSend$numberWithDouble:
0x0004f920  mov      x29, x29
0x0004f924  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004f928  mov      x23, x0
0x0004f92c  str      x0, [sp, #0xa0]
0x0004f930  ldr      x0, [x27, #0x928]   ; @CLASS NSNumber
0x0004f934  ldr      d0, [sp, #0x30]
0x0004f938  bl       #0x592e0   ; CALL objc_msgSend$numberWithDouble:
0x0004f93c  mov      x29, x29
0x0004f940  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004f944  mov      x24, x0
0x0004f948  str      x0, [sp, #0xa8]
0x0004f94c  adrp     x8, #0x8e000
0x0004f950  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0004f954  add      x2, sp, #0xa0
0x0004f958  b        #0x4f9a0
0x0004f95c  ldr      x0, [x27, #0x928]   ; @CLASS NSNumber
0x0004f960  ldr      d0, [sp, #0x48]
0x0004f964  bl       #0x592e0   ; CALL objc_msgSend$numberWithDouble:
0x0004f968  mov      x29, x29
0x0004f96c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004f970  mov      x23, x0
0x0004f974  str      x0, [sp, #0x90]
0x0004f978  ldr      x0, [x27, #0x928]   ; @CLASS NSNumber
0x0004f97c  ldr      d0, [sp, #0x40]
0x0004f980  bl       #0x592e0   ; CALL objc_msgSend$numberWithDouble:
0x0004f984  mov      x29, x29
0x0004f988  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004f98c  mov      x24, x0
0x0004f990  str      x0, [sp, #0x98]
0x0004f994  adrp     x8, #0x8e000
0x0004f998  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0004f99c  add      x2, sp, #0x90
0x0004f9a0  mov      w3, #2
0x0004f9a4  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0004f9a8  mov      x29, x29
0x0004f9ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004f9b0  mov      x25, x0
0x0004f9b4  mov      x0, x22
0x0004f9b8  mov      x2, x25
0x0004f9bc  bl       #0x5b340   ; CALL objc_msgSend$setLineDashPattern:
0x0004f9c0  mov      x0, x25
0x0004f9c4  bl       #0x55d78   ; CALL _objc_release
0x0004f9c8  mov      x0, x24
0x0004f9cc  bl       #0x55d78   ; CALL _objc_release
0x0004f9d0  mov      x0, x23
0x0004f9d4  bl       #0x55d78   ; CALL _objc_release
0x0004f9d8  mov      x0, x19
0x0004f9dc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004f9e0  mov      x29, x29
0x0004f9e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004f9e8  mov      x23, x0
0x0004f9ec  mov      x2, x22
0x0004f9f0  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004f9f4  mov      x0, x23
0x0004f9f8  bl       #0x55d78   ; CALL _objc_release
0x0004f9fc  ldrsw    x8, [x28, #0x90]
0x0004fa00  ldr      x0, [x20, x8]
0x0004fa04  mov      x2, x22
0x0004fa08  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x0004fa0c  mov      x0, x22
0x0004fa10  bl       #0x55d78   ; CALL _objc_release
0x0004fa14  add      x21, x21, #1
0x0004fa18  cmp      x21, #3
0x0004fa1c  b.ne     #0x4f834
0x0004fa20  adrp     x8, #0x66000
0x0004fa24  ldr      d0, [x8, #0x118]
0x0004fa28  fmul     d8, d12, d0
0x0004fa2c  adrp     x8, #0x8e000
0x0004fa30  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x0004fa34  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004fa38  mov      x29, x29
0x0004fa3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fa40  mov      x27, x0
0x0004fa44  adrp     x8, #0x74000
0x0004fa48  ldr      x8, [x8, #0x668]   ; @GOT _kCAGradientLayerConic
0x0004fa4c  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0004fa50  bl       #0x5c6e0   ; CALL objc_msgSend$setType:
0x0004fa54  fadd     d2, d8, d8
0x0004fa58  fmov     d0, xzr
0x0004fa5c  fmov     d1, xzr
0x0004fa60  mov      x0, x27
0x0004fa64  mov      v3.16b, v2.16b
0x0004fa68  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x0004fa6c  mov      x0, x27
0x0004fa70  mov      v0.16b, v10.16b
0x0004fa74  mov      v1.16b, v11.16b
0x0004fa78  bl       #0x5bc00   ; CALL objc_msgSend$setPosition:
0x0004fa7c  mov      x0, x27
0x0004fa80  mov      v0.16b, v8.16b
0x0004fa84  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0004fa88  mov      x0, x27
0x0004fa8c  mov      w2, #1
0x0004fa90  bl       #0x5b520   ; CALL objc_msgSend$setMasksToBounds:
0x0004fa94  fmov     d0, #0.50000000
0x0004fa98  fmov     d1, #0.50000000
0x0004fa9c  mov      x0, x27
0x0004faa0  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x0004faa4  fmov     d0, #1.00000000
0x0004faa8  fmov     d1, #0.50000000
0x0004faac  mov      x0, x27
0x0004fab0  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x0004fab4  adrp     x26, #0x8e000
0x0004fab8  ldr      x0, [x26, #0x910]   ; @CLASS UIColor
0x0004fabc  fmov     d2, #1.00000000
0x0004fac0  fmov     d3, xzr
0x0004fac4  ldr      d8, [sp, #0x20]
0x0004fac8  mov      v0.16b, v8.16b
0x0004facc  ldr      d9, [sp, #0x50]
0x0004fad0  mov      v1.16b, v9.16b
0x0004fad4  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004fad8  mov      x29, x29
0x0004fadc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fae0  mov      x23, x0
0x0004fae4  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004fae8  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004faec  str      x0, [sp, #0x78]
0x0004faf0  ldr      x0, [x26, #0x910]   ; @CLASS UIColor
0x0004faf4  fmov     d2, #1.00000000
0x0004faf8  fmov     d3, xzr
0x0004fafc  mov      v0.16b, v8.16b
0x0004fb00  mov      v1.16b, v9.16b
0x0004fb04  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004fb08  mov      x29, x29
0x0004fb0c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fb10  mov      x22, x0
0x0004fb14  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004fb18  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004fb1c  str      x0, [sp, #0x80]
0x0004fb20  ldr      x0, [x26, #0x910]   ; @CLASS UIColor
0x0004fb24  adrp     x8, #0x65000
0x0004fb28  ldr      d3, [x8, #0x6c0]
0x0004fb2c  fmov     d2, #1.00000000
0x0004fb30  mov      v0.16b, v8.16b
0x0004fb34  mov      v1.16b, v9.16b
0x0004fb38  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004fb3c  mov      x29, x29
0x0004fb40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fb44  mov      x24, x0
0x0004fb48  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0004fb4c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0004fb50  str      x0, [sp, #0x88]
0x0004fb54  adrp     x8, #0x8e000
0x0004fb58  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0004fb5c  add      x2, sp, #0x78
0x0004fb60  mov      w3, #3
0x0004fb64  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0004fb68  mov      x29, x29
0x0004fb6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fb70  mov      x25, x0
0x0004fb74  mov      x0, x27
0x0004fb78  mov      x2, x25
0x0004fb7c  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0004fb80  mov      x0, x25
0x0004fb84  bl       #0x55d78   ; CALL _objc_release
0x0004fb88  mov      x0, x24
0x0004fb8c  bl       #0x55d78   ; CALL _objc_release
0x0004fb90  mov      x0, x22
0x0004fb94  bl       #0x55d78   ; CALL _objc_release
0x0004fb98  mov      x0, x23
0x0004fb9c  bl       #0x55d78   ; CALL _objc_release
0x0004fba0  adrp     x2, #0x7f000
0x0004fba4  add      x2, x2, #0xf48
0x0004fba8  mov      x0, x27
0x0004fbac  bl       #0x5b480   ; CALL objc_msgSend$setLocations:
0x0004fbb0  mov      x0, x19
0x0004fbb4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0004fbb8  mov      x29, x29
0x0004fbbc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fbc0  mov      x22, x0
0x0004fbc4  mov      x2, x27
0x0004fbc8  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0004fbcc  mov      x0, x22
0x0004fbd0  bl       #0x55d78   ; CALL _objc_release
0x0004fbd4  adrp     x8, #0x8f000
0x0004fbd8  ldrsw    x21, [x8, #0xa4]
0x0004fbdc  mov      x0, x27
0x0004fbe0  bl       #0x55d84   ; CALL _objc_retain
0x0004fbe4  ldr      x0, [x20, x21]
0x0004fbe8  str      x27, [sp, #0x10]
0x0004fbec  str      x27, [x20, x21]
0x0004fbf0  bl       #0x55d78   ; CALL _objc_release
0x0004fbf4  ldr      x0, [x26, #0x910]   ; @CLASS UIColor
0x0004fbf8  adrp     x8, #0x66000
0x0004fbfc  ldr      d0, [x8, #0x120]
0x0004fc00  adrp     x8, #0x66000
0x0004fc04  ldr      d1, [x8, #0x128]
0x0004fc08  fmov     d2, #1.00000000
0x0004fc0c  fmov     d3, #1.00000000
0x0004fc10  str      d0, [sp, #0x38]
0x0004fc14  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004fc18  mov      x29, x29
0x0004fc1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fc20  mov      x3, x0
0x0004fc24  adrp     x8, #0x74000
0x0004fc28  ldr      x8, [x8, #0x240]   ; @GOT _UIFontWeightHeavy
0x0004fc2c  ldr      d3, [x8]   ; @GOT ___objc_personality_v0
0x0004fc30  adrp     x2, #0x7d000
0x0004fc34  add      x2, x2, #0x688   ; STR "100%"
0x0004fc38  mov      x8, #0x4050000000000000
0x0004fc3c  fmov     d2, x8
0x0004fc40  fmov     d4, xzr
0x0004fc44  mov      x0, x20
0x0004fc48  mov      v0.16b, v10.16b
0x0004fc4c  mov      v1.16b, v11.16b
0x0004fc50  str      d3, [sp, #0x48]
0x0004fc54  str      x3, [sp, #8]
0x0004fc58  mov      w4, #0
0x0004fc5c  mov      x5, x19
0x0004fc60  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x0004fc64  mov      x29, x29
0x0004fc68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fc6c  adrp     x8, #0x8f000
0x0004fc70  ldrsw    x21, [x8, #0xc4]
0x0004fc74  ldr      x8, [x20, x21]
0x0004fc78  str      x0, [x20, x21]
0x0004fc7c  mov      x0, x8
0x0004fc80  bl       #0x55d78   ; CALL _objc_release
0x0004fc84  ldr      x0, [x20, x21]
0x0004fc88  adrp     x2, #0x7d000
0x0004fc8c  add      x2, x2, #0x6a8   ; STR "0%"
0x0004fc90  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0004fc94  mov      x0, x20
0x0004fc98  bl       #0x57fe0   ; CALL objc_msgSend$hud
0x0004fc9c  mov      x29, x29
0x0004fca0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fca4  mov      x22, x0
0x0004fca8  bl       #0x573c0   ; CALL objc_msgSend$count
0x0004fcac  cbz      x0, #0x4fcc8
0x0004fcb0  mov      x0, x20
0x0004fcb4  bl       #0x57fe0   ; CALL objc_msgSend$hud
0x0004fcb8  mov      x29, x29
0x0004fcbc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fcc0  mov      x24, x0
0x0004fcc4  b        #0x4fcf4
0x0004fcc8  mov      x0, x20
0x0004fccc  bl       #0x56be0   ; CALL objc_msgSend$carName
0x0004fcd0  mov      x29, x29
0x0004fcd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fcd8  mov      x23, x0
0x0004fcdc  bl       #0x50180
0x0004fce0  mov      x29, x29
0x0004fce4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fce8  mov      x24, x0
0x0004fcec  mov      x0, x23
0x0004fcf0  bl       #0x55d78   ; CALL _objc_release
0x0004fcf4  mov      x0, x22
0x0004fcf8  bl       #0x55d78   ; CALL _objc_release
0x0004fcfc  mov      x0, x24
0x0004fd00  bl       #0x573c0   ; CALL objc_msgSend$count
0x0004fd04  cmp      x0, #5
0x0004fd08  mov      w8, #5
0x0004fd0c  csel     x8, x0, x8, lo
0x0004fd10  str      x8, [sp, #0x40]
0x0004fd14  cbz      x0, #0x50050
0x0004fd18  mov      x25, #0
0x0004fd1c  adrp     x8, #0x74000
0x0004fd20  ldr      x8, [x8, #0x250]   ; @GOT _UIFontWeightMedium
0x0004fd24  ldr      d0, [x8]   ; @GOT ___objc_personality_v0
0x0004fd28  str      d0, [sp, #0x30]
0x0004fd2c  ldr      x8, [sp, #0x40]
0x0004fd30  sub      x8, x8, x8, lsl #5
0x0004fd34  add      x21, x8, #0x131
0x0004fd38  adrp     x23, #0x75000
0x0004fd3c  add      x23, x23, #0xe08   ; STR "ok"
0x0004fd40  mov      x8, #0x4089000000000000
0x0004fd44  str      x8, [sp, #0x28]
0x0004fd48  adrp     x8, #0x65000
0x0004fd4c  ldr      d0, [x8, #0x650]
0x0004fd50  str      d0, [sp, #0x18]
0x0004fd54  adrp     x8, #0x66000
0x0004fd58  ldr      d11, [x8, #0x130]
0x0004fd5c  adrp     x8, #0x65000
0x0004fd60  ldr      d14, [x8, #0xa68]
0x0004fd64  adrp     x8, #0x65000
0x0004fd68  ldr      d12, [x8, #0xa28]
0x0004fd6c  adrp     x8, #0x65000
0x0004fd70  ldr      d13, [x8, #0x670]
0x0004fd74  mov      x0, x24
0x0004fd78  mov      x2, x25
0x0004fd7c  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0004fd80  mov      x29, x29
0x0004fd84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fd88  mov      x22, x0
0x0004fd8c  adrp     x8, #0x8e000
0x0004fd90  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x0004fd94  bl       #0x55d48   ; CALL _objc_opt_class
0x0004fd98  mov      x1, x0
0x0004fd9c  mov      x0, x22
0x0004fda0  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0004fda4  adrp     x28, #0x74000
0x0004fda8  ldr      x28, [x28, #0x1a8]   ; @GOT ___NSDictionary0__struct
0x0004fdac  tbz      w0, #0, #0x4fdc8
0x0004fdb0  mov      x0, x24
0x0004fdb4  mov      x2, x25
0x0004fdb8  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0004fdbc  mov      x29, x29
0x0004fdc0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fdc4  mov      x28, x0
0x0004fdc8  mov      x0, x22
0x0004fdcc  bl       #0x55d78   ; CALL _objc_release
0x0004fdd0  mov      x0, x28
0x0004fdd4  mov      x2, x23
0x0004fdd8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0004fddc  mov      x29, x29
0x0004fde0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fde4  mov      x22, x0
0x0004fde8  cbz      x0, #0x4fe18
0x0004fdec  mov      x0, x28
0x0004fdf0  mov      x2, x23
0x0004fdf4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0004fdf8  mov      x29, x29
0x0004fdfc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fe00  mov      x23, x0
0x0004fe04  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x0004fe08  eor      w26, w0, #1
0x0004fe0c  mov      x0, x23
0x0004fe10  bl       #0x55d78   ; CALL _objc_release
0x0004fe14  b        #0x4fe1c
0x0004fe18  mov      w26, #0
0x0004fe1c  mov      x0, x22
0x0004fe20  bl       #0x55d78   ; CALL _objc_release
0x0004fe24  mov      x0, x28
0x0004fe28  adrp     x2, #0x7d000
0x0004fe2c  add      x2, x2, #0x6c8   ; STR "text"
0x0004fe30  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0004fe34  mov      x29, x29
0x0004fe38  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fe3c  mov      x22, x0
0x0004fe40  adrp     x8, #0x8e000
0x0004fe44  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0004fe48  bl       #0x55d48   ; CALL _objc_opt_class
0x0004fe4c  mov      x1, x0
0x0004fe50  mov      x0, x22
0x0004fe54  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0004fe58  adrp     x23, #0x75000
0x0004fe5c  add      x23, x23, #0xd28
0x0004fe60  tbz      w0, #0, #0x4fe80
0x0004fe64  mov      x0, x28
0x0004fe68  adrp     x2, #0x7d000
0x0004fe6c  add      x2, x2, #0x6c8   ; STR "text"
0x0004fe70  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x0004fe74  mov      x29, x29
0x0004fe78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fe7c  mov      x23, x0
0x0004fe80  mov      x0, x22
0x0004fe84  bl       #0x55d78   ; CALL _objc_release
0x0004fe88  cmp      w26, #0
0x0004fe8c  ldr      x8, [sp, #0x68]
0x0004fe90  ldr      d8, [x20, x8]
0x0004fe94  adrp     x8, #0x7d000
0x0004fe98  add      x8, x8, #0x6e8   ; STR "✓"
0x0004fe9c  adrp     x9, #0x7d000
0x0004fea0  add      x9, x9, #0x708   ; STR "!"
0x0004fea4  csel     x22, x9, x8, ne
0x0004fea8  ldr      x8, [sp, #0x70]
0x0004feac  ldr      d9, [x20, x8]
0x0004feb0  ldr      x8, [sp, #0x60]
0x0004feb4  ldr      d10, [x20, x8]
0x0004feb8  adrp     x8, #0x8e000
0x0004febc  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0004fec0  tbz      w26, #0, #0x4fed8
0x0004fec4  fmov     d0, #1.00000000
0x0004fec8  fmov     d3, #1.00000000
0x0004fecc  ldr      d1, [sp, #0x38]
0x0004fed0  ldr      d2, [sp, #0x18]
0x0004fed4  b        #0x4fee8
0x0004fed8  fmov     d1, #1.00000000
0x0004fedc  fmov     d3, #1.00000000
0x0004fee0  ldr      d0, [sp, #0x20]
0x0004fee4  ldr      d2, [sp, #0x38]
0x0004fee8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004feec  mov      x29, x29
0x0004fef0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004fef4  mov      x27, x0
0x0004fef8  ucvtf    d15, x21
0x0004fefc  ldr      d0, [sp, #0x28]
0x0004ff00  fmadd    d0, d9, d0, d8
0x0004ff04  fmadd    d1, d15, d9, d10
0x0004ff08  fmov     d2, #30.00000000
0x0004ff0c  fmov     d4, xzr
0x0004ff10  mov      x0, x20
0x0004ff14  mov      x2, x22
0x0004ff18  ldr      d3, [sp, #0x48]
0x0004ff1c  mov      x3, x27
0x0004ff20  mov      w4, #1
0x0004ff24  mov      x5, x19
0x0004ff28  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x0004ff2c  mov      x29, x29
0x0004ff30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ff34  mov      x22, x0
0x0004ff38  mov      x0, x27
0x0004ff3c  bl       #0x55d78   ; CALL _objc_release
0x0004ff40  ldp      x9, x8, [sp, #0x68]
0x0004ff44  ldr      d0, [x20, x9]
0x0004ff48  ldr      d1, [x20, x8]
0x0004ff4c  fmadd    d8, d1, d11, d0
0x0004ff50  ldr      x8, [sp, #0x60]
0x0004ff54  ldr      d0, [x20, x8]
0x0004ff58  fmadd    d9, d15, d1, d0
0x0004ff5c  adrp     x8, #0x8e000
0x0004ff60  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0004ff64  fmov     d2, #1.00000000
0x0004ff68  fmov     d3, #1.00000000
0x0004ff6c  ldr      d0, [sp, #0x50]
0x0004ff70  mov      v1.16b, v14.16b
0x0004ff74  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0004ff78  mov      x29, x29
0x0004ff7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ff80  mov      x27, x0
0x0004ff84  fmov     d2, #30.00000000
0x0004ff88  fmov     d4, xzr
0x0004ff8c  mov      x0, x20
0x0004ff90  mov      x2, x23
0x0004ff94  mov      v0.16b, v8.16b
0x0004ff98  mov      v1.16b, v9.16b
0x0004ff9c  ldr      d3, [sp, #0x30]
0x0004ffa0  mov      x3, x27
0x0004ffa4  mov      w4, #1
0x0004ffa8  mov      x5, x19
0x0004ffac  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x0004ffb0  mov      x29, x29
0x0004ffb4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0004ffb8  mov      x26, x0
0x0004ffbc  mov      x0, x27
0x0004ffc0  bl       #0x55d78   ; CALL _objc_release
0x0004ffc4  ucvtf    d0, x25
0x0004ffc8  fmov     d1, #0.50000000
0x0004ffcc  fmadd    d8, d0, d12, d1
0x0004ffd0  fmadd    d9, d0, d12, d13
0x0004ffd4  fmov     d2, #1.00000000
0x0004ffd8  mov      x0, x20
0x0004ffdc  mov      x2, x22
0x0004ffe0  mov      v0.16b, v8.16b
0x0004ffe4  mov      v1.16b, v9.16b
0x0004ffe8  bl       #0x5d160   ; CALL objc_msgSend$ss_fade:from:to:alpha:
0x0004ffec  mov      x29, x29
0x0004fff0  bl       #0x55dfc   ; CALL _objc_unsafeClaimAutoreleasedReturnValue
0x0004fff4  fmov     d2, #1.00000000
0x0004fff8  mov      x0, x20
0x0004fffc  mov      x2, x26
0x00050000  mov      v0.16b, v8.16b
0x00050004  mov      v1.16b, v9.16b
0x00050008  bl       #0x5d160   ; CALL objc_msgSend$ss_fade:from:to:alpha:
0x0005000c  mov      x29, x29
0x00050010  bl       #0x55dfc   ; CALL _objc_unsafeClaimAutoreleasedReturnValue
0x00050014  mov      x0, x26
0x00050018  bl       #0x55d78   ; CALL _objc_release
0x0005001c  mov      x0, x22
0x00050020  bl       #0x55d78   ; CALL _objc_release
0x00050024  mov      x0, x23
0x00050028  bl       #0x55d78   ; CALL _objc_release
0x0005002c  mov      x0, x28
0x00050030  bl       #0x55d78   ; CALL _objc_release
0x00050034  add      x25, x25, #1
0x00050038  add      x21, x21, #0x3e
0x0005003c  ldr      x8, [sp, #0x40]
0x00050040  cmp      x8, x25
0x00050044  adrp     x23, #0x75000
0x00050048  add      x23, x23, #0xe08   ; STR "ok"
0x0005004c  b.ne     #0x4fd74
0x00050050  adrp     x0, #0x7d000
0x00050054  add      x0, x0, #0x728   ; STR "SẴN SÀNG"
0x00050058  adrp     x1, #0x7d000
0x0005005c  add      x1, x1, #0x748   ; STR "READY"
0x00050060  bl       #0x5505c   ; CALL _OMCTr
0x00050064  mov      x29, x29
0x00050068  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005006c  mov      x22, x0
0x00050070  ldp      x9, x8, [sp, #0x68]
0x00050074  ldr      d0, [x20, x9]
0x00050078  ldr      d1, [x20, x8]
0x0005007c  adrp     x8, #0x66000
0x00050080  ldr      d2, [x8, #0x138]
0x00050084  fmadd    d0, d1, d2, d0
0x00050088  ldr      x8, [sp, #0x60]
0x0005008c  ldr      d2, [x20, x8]
0x00050090  adrp     x8, #0x66000
0x00050094  ldr      d3, [x8, #0xf0]
0x00050098  fmadd    d1, d1, d3, d2
0x0005009c  mov      x8, #0x404c000000000000
0x000500a0  fmov     d2, x8
0x000500a4  fmov     d4, xzr
0x000500a8  mov      x0, x20
0x000500ac  mov      x2, x22
0x000500b0  ldr      d3, [sp, #0x48]
0x000500b4  ldr      x21, [sp, #8]
0x000500b8  mov      x3, x21
0x000500bc  mov      w4, #0
0x000500c0  mov      x5, x19
0x000500c4  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x000500c8  mov      x29, x29
0x000500cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000500d0  mov      x23, x0
0x000500d4  mov      x0, x22
0x000500d8  bl       #0x55d78   ; CALL _objc_release
0x000500dc  adrp     x8, #0x65000
0x000500e0  ldr      d0, [x8, #0xfa8]
0x000500e4  adrp     x8, #0x66000
0x000500e8  ldr      d1, [x8, #0x140]
0x000500ec  fmov     d2, #1.00000000
0x000500f0  mov      x0, x20
0x000500f4  mov      x2, x23
0x000500f8  bl       #0x5d160   ; CALL objc_msgSend$ss_fade:from:to:alpha:
0x000500fc  mov      x29, x29
0x00050100  bl       #0x55dfc   ; CALL _objc_unsafeClaimAutoreleasedReturnValue
0x00050104  mov      x0, x23
0x00050108  bl       #0x55d78   ; CALL _objc_release
0x0005010c  mov      x0, x24
0x00050110  bl       #0x55d78   ; CALL _objc_release
0x00050114  mov      x0, x21
0x00050118  bl       #0x55d78   ; CALL _objc_release
0x0005011c  ldr      x0, [sp, #0x10]
0x00050120  bl       #0x55d78   ; CALL _objc_release
0x00050124  ldr      x0, [sp, #0x58]
0x00050128  bl       #0x55d78   ; CALL _objc_release
0x0005012c  mov      x0, x19
0x00050130  bl       #0x55d78   ; CALL _objc_release
0x00050134  ldur     x8, [x29, #-0xa0]
0x00050138  adrp     x9, #0x74000
0x0005013c  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00050140  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00050144  cmp      x9, x8
0x00050148  b.ne     #0x5017c
0x0005014c  ldp      x29, x30, [sp, #0x150]
0x00050150  ldp      x20, x19, [sp, #0x140]
0x00050154  ldp      x22, x21, [sp, #0x130]
0x00050158  ldp      x24, x23, [sp, #0x120]
0x0005015c  ldp      x26, x25, [sp, #0x110]
0x00050160  ldp      x28, x27, [sp, #0x100]
0x00050164  ldp      d9, d8, [sp, #0xf0]
0x00050168  ldp      d11, d10, [sp, #0xe0]
0x0005016c  ldp      d13, d12, [sp, #0xd0]
0x00050170  ldp      d15, d14, [sp, #0xc0]
0x00050174  add      sp, sp, #0x160
0x00050178  ret      
0x0005017c  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00050180  sub      sp, sp, #0x170
0x00050184  stp      x28, x27, [sp, #0x110]
0x00050188  stp      x26, x25, [sp, #0x120]
0x0005018c  stp      x24, x23, [sp, #0x130]
0x00050190  stp      x22, x21, [sp, #0x140]
0x00050194  stp      x20, x19, [sp, #0x150]
0x00050198  stp      x29, x30, [sp, #0x160]
0x0005019c  add      x29, sp, #0x160
0x000501a0  mov      x19, x0
0x000501a4  adrp     x8, #0x74000
0x000501a8  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000501ac  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000501b0  stur     x8, [x29, #-0x60]
0x000501b4  bl       #0x55d84   ; CALL _objc_retain
0x000501b8  mov      x0, x19
0x000501bc  bl       #0x4da60
0x000501c0  mov      x29, x29
0x000501c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000501c8  mov      x20, x0
0x000501cc  bl       #0x58c20   ; CALL objc_msgSend$length
0x000501d0  str      x19, [sp, #0x30]
0x000501d4  cbz      x0, #0x501f0
0x000501d8  mov      x0, x19
0x000501dc  bl       #0x4da60
0x000501e0  mov      x29, x29
0x000501e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000501e8  mov      x22, x0
0x000501ec  b        #0x501f8
0x000501f0  adrp     x22, #0x75000
0x000501f4  add      x22, x22, #0x508   ; STR "OmniCar"
0x000501f8  str      x22, [sp, #8]
0x000501fc  mov      x0, x20
0x00050200  bl       #0x55d78   ; CALL _objc_release
0x00050204  adrp     x20, #0x7d000
0x00050208  add      x20, x20, #0x6c8   ; STR "text"
0x0005020c  stur     x20, [x29, #-0xa8]
0x00050210  adrp     x0, #0x7e000
0x00050214  add      x0, x0, #0x4e8   ; STR "Kết nối CarPlay"
0x00050218  adrp     x1, #0x7e000
0x0005021c  add      x1, x1, #0x508   ; STR "CarPlay connected"
0x00050220  bl       #0x5505c   ; CALL _OMCTr
0x00050224  mov      x29, x29
0x00050228  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005022c  str      x0, [sp, #0x28]
0x00050230  adrp     x23, #0x75000
0x00050234  add      x23, x23, #0xe08   ; STR "ok"
0x00050238  stur     x23, [x29, #-0xa0]
0x0005023c  adrp     x19, #0x74000
0x00050240  ldr      x19, [x19, #0x1b8]   ; @GOT ___kCFBooleanTrue
0x00050244  stp      x0, x19, [x29, #-0x98]
0x00050248  adrp     x24, #0x8e000
0x0005024c  ldr      x0, [x24, #0x970]   ; @CLASS NSDictionary
0x00050250  sub      x2, x29, #0x98
0x00050254  sub      x3, x29, #0xa8
0x00050258  mov      w4, #2
0x0005025c  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00050260  mov      x29, x29
0x00050264  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050268  str      x0, [sp, #0x20]
0x0005026c  stur     x0, [x29, #-0x88]
0x00050270  str      x20, [sp, #0x98]
0x00050274  adrp     x0, #0x7e000
0x00050278  add      x0, x0, #0x528   ; STR "Pin iPhone 82% · đang sạc"
0x0005027c  adrp     x1, #0x7e000
0x00050280  add      x1, x1, #0x548   ; STR "iPhone battery 82% · charging"
0x00050284  bl       #0x5505c   ; CALL _OMCTr
0x00050288  mov      x29, x29
0x0005028c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050290  str      x0, [sp, #0x18]
0x00050294  stp      x23, x0, [sp, #0xa0]
0x00050298  str      x19, [sp, #0xb0]
0x0005029c  ldr      x0, [x24, #0x970]   ; @CLASS NSDictionary
0x000502a0  add      x2, sp, #0xa8
0x000502a4  add      x3, sp, #0x98
0x000502a8  mov      w4, #2
0x000502ac  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x000502b0  mov      x29, x29
0x000502b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000502b8  str      x0, [sp, #0x10]
0x000502bc  stur     x0, [x29, #-0x80]
0x000502c0  str      x20, [sp, #0x78]
0x000502c4  adrp     x0, #0x7e000
0x000502c8  add      x0, x0, #0x568   ; STR "Nhiệt độ máy: ổn"
0x000502cc  adrp     x1, #0x7e000
0x000502d0  add      x1, x1, #0x588   ; STR "Phone temperature: OK"
0x000502d4  bl       #0x5505c   ; CALL _OMCTr
0x000502d8  mov      x29, x29
0x000502dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000502e0  mov      x25, x0
0x000502e4  stp      x23, x0, [sp, #0x80]
0x000502e8  str      x19, [sp, #0x90]
0x000502ec  ldr      x0, [x24, #0x970]   ; @CLASS NSDictionary
0x000502f0  add      x2, sp, #0x88
0x000502f4  add      x3, sp, #0x78
0x000502f8  mov      w4, #2
0x000502fc  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00050300  mov      x29, x29
0x00050304  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050308  mov      x26, x0
0x0005030c  stur     x0, [x29, #-0x78]
0x00050310  str      x20, [sp, #0x58]
0x00050314  adrp     x0, #0x7e000
0x00050318  add      x0, x0, #0x5a8   ; STR "Chế độ nhẹ: tự động"
0x0005031c  adrp     x1, #0x7e000
0x00050320  add      x1, x1, #0x5c8   ; STR "Lite mode: auto"
0x00050324  bl       #0x5505c   ; CALL _OMCTr
0x00050328  mov      x29, x29
0x0005032c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050330  mov      x27, x0
0x00050334  stp      x23, x0, [sp, #0x60]
0x00050338  str      x19, [sp, #0x70]
0x0005033c  ldr      x0, [x24, #0x970]   ; @CLASS NSDictionary
0x00050340  add      x2, sp, #0x68
0x00050344  add      x3, sp, #0x58
0x00050348  mov      w4, #2
0x0005034c  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00050350  mov      x29, x29
0x00050354  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050358  mov      x28, x0
0x0005035c  stur     x0, [x29, #-0x70]
0x00050360  str      x20, [sp, #0x38]
0x00050364  adrp     x8, #0x8e000
0x00050368  ldr      x20, [x8, #0x958]   ; @CLASS NSString
0x0005036c  adrp     x0, #0x7e000
0x00050370  add      x0, x0, #0x5e8   ; STR "Hồ sơ xe: %@"
0x00050374  adrp     x1, #0x7e000
0x00050378  add      x1, x1, #0x608   ; STR "Car profile: %@"
0x0005037c  bl       #0x5505c   ; CALL _OMCTr
0x00050380  mov      x29, x29
0x00050384  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050388  mov      x21, x0
0x0005038c  str      x22, [sp]
0x00050390  mov      x0, x20
0x00050394  mov      x2, x21
0x00050398  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0005039c  mov      x29, x29
0x000503a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000503a4  mov      x22, x0
0x000503a8  stp      x23, x0, [sp, #0x40]
0x000503ac  str      x19, [sp, #0x50]
0x000503b0  ldr      x0, [x24, #0x970]   ; @CLASS NSDictionary
0x000503b4  add      x2, sp, #0x48
0x000503b8  add      x3, sp, #0x38
0x000503bc  mov      w4, #2
0x000503c0  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x000503c4  mov      x29, x29
0x000503c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000503cc  mov      x23, x0
0x000503d0  stur     x0, [x29, #-0x68]
0x000503d4  adrp     x8, #0x8e000
0x000503d8  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000503dc  sub      x2, x29, #0x88
0x000503e0  mov      w3, #5
0x000503e4  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000503e8  mov      x29, x29
0x000503ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000503f0  mov      x20, x0
0x000503f4  mov      x0, x23
0x000503f8  bl       #0x55d78   ; CALL _objc_release
0x000503fc  mov      x0, x22
0x00050400  bl       #0x55d78   ; CALL _objc_release
0x00050404  mov      x0, x21
0x00050408  bl       #0x55d78   ; CALL _objc_release
0x0005040c  mov      x0, x28
0x00050410  bl       #0x55d78   ; CALL _objc_release
0x00050414  mov      x0, x27
0x00050418  bl       #0x55d78   ; CALL _objc_release
0x0005041c  mov      x0, x26
0x00050420  bl       #0x55d78   ; CALL _objc_release
0x00050424  mov      x0, x25
0x00050428  bl       #0x55d78   ; CALL _objc_release
0x0005042c  ldr      x0, [sp, #0x10]
0x00050430  bl       #0x55d78   ; CALL _objc_release
0x00050434  ldr      x0, [sp, #0x18]
0x00050438  bl       #0x55d78   ; CALL _objc_release
0x0005043c  ldr      x0, [sp, #0x20]
0x00050440  bl       #0x55d78   ; CALL _objc_release
0x00050444  ldr      x0, [sp, #0x28]
0x00050448  bl       #0x55d78   ; CALL _objc_release
0x0005044c  ldr      x0, [sp, #8]
0x00050450  bl       #0x55d78   ; CALL _objc_release
0x00050454  ldr      x0, [sp, #0x30]
0x00050458  bl       #0x55d78   ; CALL _objc_release
0x0005045c  ldur     x8, [x29, #-0x60]
0x00050460  adrp     x9, #0x74000
0x00050464  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00050468  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0005046c  cmp      x9, x8
0x00050470  b.ne     #0x50498
0x00050474  mov      x0, x20
0x00050478  ldp      x29, x30, [sp, #0x160]
0x0005047c  ldp      x20, x19, [sp, #0x150]
0x00050480  ldp      x22, x21, [sp, #0x140]
0x00050484  ldp      x24, x23, [sp, #0x130]
0x00050488  ldp      x26, x25, [sp, #0x120]
0x0005048c  ldp      x28, x27, [sp, #0x110]
0x00050490  add      sp, sp, #0x170
0x00050494  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00050498  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[SSStartupView ss_applyHud:]  va=0x5049c size=664 types=v24@0:8d16
0x0005049c  stp      d15, d14, [sp, #-0x80]!
0x000504a0  stp      d13, d12, [sp, #0x10]
0x000504a4  stp      d11, d10, [sp, #0x20]
0x000504a8  stp      d9, d8, [sp, #0x30]
0x000504ac  stp      x28, x27, [sp, #0x40]
0x000504b0  stp      x22, x21, [sp, #0x50]
0x000504b4  stp      x20, x19, [sp, #0x60]
0x000504b8  stp      x29, x30, [sp, #0x70]
0x000504bc  add      x29, sp, #0x70
0x000504c0  sub      sp, sp, #0x190
0x000504c4  mov      v8.16b, v0.16b
0x000504c8  mov      x19, x0
0x000504cc  adrp     x8, #0x65000
0x000504d0  ldr      d0, [x8, #0x670]
0x000504d4  fdiv     d0, d8, d0
0x000504d8  fmov     d12, #1.00000000
0x000504dc  fcmp     d0, d12
0x000504e0  fcsel    d1, d12, d0, gt
0x000504e4  fcmp     d0, #0.0
0x000504e8  fmov     d11, xzr
0x000504ec  fcsel    d9, d11, d1, mi
0x000504f0  fsub     d0, d12, d9
0x000504f4  fmov     d1, #3.00000000
0x000504f8  bl       #0x55e14   ; CALL _pow
0x000504fc  fsub     d0, d12, d0
0x00050500  fcmp     d9, #0.0
0x00050504  fcsel    d9, d11, d0, mi
0x00050508  adrp     x8, #0x8f000
0x0005050c  ldrsw    x22, [x8, #0x90]
0x00050510  ldr      x0, [x19, x22]
0x00050514  bl       #0x573c0   ; CALL objc_msgSend$count
0x00050518  cbz      x0, #0x50614
0x0005051c  adrp     x8, #0x65000
0x00050520  ldr      d0, [x8, #0xea0]
0x00050524  fmaxnm   d9, d9, d0
0x00050528  fneg     d14, d8
0x0005052c  fcmp     d8, d12
0x00050530  fcsel    d0, d12, d8, gt
0x00050534  fcmp     d8, #0.0
0x00050538  fcsel    d10, d11, d0, mi
0x0005053c  fsub     d0, d12, d10
0x00050540  fmov     d1, #3.00000000
0x00050544  bl       #0x55e14   ; CALL _pow
0x00050548  mov      x20, #0
0x0005054c  fsub     d0, d12, d0
0x00050550  fcmp     d10, #0.0
0x00050554  fcsel    d10, d11, d0, mi
0x00050558  adrp     x8, #0x65000
0x0005055c  ldr      d15, [x8, #0x6e8]
0x00050560  adrp     x8, #0x65000
0x00050564  ldr      d13, [x8, #0x608]
0x00050568  ldr      x0, [x19, x22]
0x0005056c  mov      x2, x20
0x00050570  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00050574  mov      x29, x29
0x00050578  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005057c  mov      x21, x0
0x00050580  tst      x20, #1
0x00050584  fcsel    d0, d8, d14, eq
0x00050588  ucvtf    d1, x20
0x0005058c  fmadd    d1, d1, d13, d15
0x00050590  fmul     d0, d1, d0
0x00050594  add      x8, sp, #0x90
0x00050598  fmov     d1, xzr
0x0005059c  fmov     d2, xzr
0x000505a0  fmov     d3, #1.00000000
0x000505a4  bl       #0x55820   ; CALL _CATransform3DMakeRotation
0x000505a8  sub      x8, x29, #0xf0
0x000505ac  add      x0, sp, #0x90
0x000505b0  fmov     d2, #1.00000000
0x000505b4  mov      v0.16b, v9.16b
0x000505b8  mov      v1.16b, v9.16b
0x000505bc  bl       #0x5582c   ; CALL _CATransform3DScale
0x000505c0  ldp      q0, q1, [x29, #-0xb0]
0x000505c4  stp      q0, q1, [sp, #0xd0]
0x000505c8  ldp      q0, q1, [x29, #-0x90]
0x000505cc  stp      q0, q1, [sp, #0xf0]
0x000505d0  ldp      q0, q1, [x29, #-0xf0]
0x000505d4  stp      q0, q1, [sp, #0x90]
0x000505d8  ldp      q0, q1, [x29, #-0xd0]
0x000505dc  stp      q0, q1, [sp, #0xb0]
0x000505e0  add      x2, sp, #0x90
0x000505e4  mov      x0, x21
0x000505e8  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x000505ec  mov      x0, x21
0x000505f0  mov      v0.16b, v10.16b
0x000505f4  bl       #0x5c3a0   ; CALL objc_msgSend$setStrokeEnd:
0x000505f8  mov      x0, x21
0x000505fc  bl       #0x55d78   ; CALL _objc_release
0x00050600  add      x20, x20, #1
0x00050604  ldr      x0, [x19, x22]
0x00050608  bl       #0x573c0   ; CALL objc_msgSend$count
0x0005060c  cmp      x20, x0
0x00050610  b.lo     #0x50568
0x00050614  fmov     d0, #3.00000000
0x00050618  fmul     d0, d8, d0
0x0005061c  add      x8, sp, #0x10
0x00050620  fmov     d1, xzr
0x00050624  fmov     d2, xzr
0x00050628  fmov     d3, #1.00000000
0x0005062c  bl       #0x55820   ; CALL _CATransform3DMakeRotation
0x00050630  adrp     x8, #0x8f000
0x00050634  ldrsw    x8, [x8, #0xa4]
0x00050638  ldr      x0, [x19, x8]
0x0005063c  ldp      q0, q1, [sp, #0x50]
0x00050640  stp      q0, q1, [sp, #0xd0]
0x00050644  ldp      q0, q1, [sp, #0x70]
0x00050648  stp      q0, q1, [sp, #0xf0]
0x0005064c  ldp      q0, q1, [sp, #0x10]
0x00050650  stp      q0, q1, [sp, #0x90]
0x00050654  ldp      q0, q1, [sp, #0x30]
0x00050658  stp      q0, q1, [sp, #0xb0]
0x0005065c  add      x2, sp, #0x90
0x00050660  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x00050664  adrp     x8, #0x66000
0x00050668  ldr      d0, [x8, #0x148]
0x0005066c  fadd     d0, d8, d0
0x00050670  adrp     x8, #0x66000
0x00050674  ldr      d1, [x8, #0x150]
0x00050678  fdiv     d0, d0, d1
0x0005067c  fcmp     d0, d12
0x00050680  fcsel    d1, d12, d0, gt
0x00050684  fcmp     d0, #0.0
0x00050688  fcsel    d8, d11, d1, mi
0x0005068c  fsub     d0, d12, d8
0x00050690  fmov     d1, #3.00000000
0x00050694  bl       #0x55e14   ; CALL _pow
0x00050698  fsub     d0, d12, d0
0x0005069c  mov      x8, #0x4059000000000000
0x000506a0  fmov     d1, x8
0x000506a4  fmul     d0, d0, d1
0x000506a8  fcmp     d8, #0.0
0x000506ac  fcsel    d0, d11, d0, mi
0x000506b0  fcvtas   x8, d0
0x000506b4  adrp     x9, #0x8f000
0x000506b8  ldrsw    x9, [x9, #0xc8]
0x000506bc  ldr      x10, [x19, x9]
0x000506c0  cmp      x8, x10
0x000506c4  b.eq     #0x5070c
0x000506c8  str      x8, [x19, x9]
0x000506cc  adrp     x9, #0x8e000
0x000506d0  ldr      x0, [x9, #0x958]   ; @CLASS NSString
0x000506d4  str      x8, [sp]
0x000506d8  adrp     x2, #0x7a000
0x000506dc  add      x2, x2, #0x8a8   ; STR "%ld%%"
0x000506e0  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x000506e4  mov      x29, x29
0x000506e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000506ec  mov      x20, x0
0x000506f0  adrp     x8, #0x8f000
0x000506f4  ldrsw    x8, [x8, #0xc4]
0x000506f8  ldr      x0, [x19, x8]
0x000506fc  mov      x2, x20
0x00050700  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00050704  mov      x0, x20
0x00050708  bl       #0x55d78   ; CALL _objc_release
0x0005070c  add      sp, sp, #0x190
0x00050710  ldp      x29, x30, [sp, #0x70]
0x00050714  ldp      x20, x19, [sp, #0x60]
0x00050718  ldp      x22, x21, [sp, #0x50]
0x0005071c  ldp      x28, x27, [sp, #0x40]
0x00050720  ldp      d9, d8, [sp, #0x30]
0x00050724  ldp      d11, d10, [sp, #0x20]
0x00050728  ldp      d13, d12, [sp, #0x10]
0x0005072c  ldp      d15, d14, [sp], #0x80
0x00050730  ret      

=== -[SSStartupView ss_buildBriefing]  va=0x50734 size=4284 types=v16@0:8
0x00050734  stp      d15, d14, [sp, #-0xa0]!
0x00050738  stp      d13, d12, [sp, #0x10]
0x0005073c  stp      d11, d10, [sp, #0x20]
0x00050740  stp      d9, d8, [sp, #0x30]
0x00050744  stp      x28, x27, [sp, #0x40]
0x00050748  stp      x26, x25, [sp, #0x50]
0x0005074c  stp      x24, x23, [sp, #0x60]
0x00050750  stp      x22, x21, [sp, #0x70]
0x00050754  stp      x20, x19, [sp, #0x80]
0x00050758  stp      x29, x30, [sp, #0x90]
0x0005075c  add      x29, sp, #0x90
0x00050760  sub      sp, sp, #0x1a0
0x00050764  mov      x20, x0
0x00050768  adrp     x8, #0x74000
0x0005076c  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00050770  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00050774  stur     x8, [x29, #-0xa0]
0x00050778  adrp     x8, #0x8f000
0x0005077c  ldrsw    x19, [x8, #0xcc]
0x00050780  ldr      d10, [x0, x19]
0x00050784  bl       #0x5d1a0   ; CALL objc_msgSend$ss_host
0x00050788  mov      x29, x29
0x0005078c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050790  mov      x25, x0
0x00050794  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00050798  mov      x29, x29
0x0005079c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000507a0  mov      x21, x0
0x000507a4  adrp     x8, #0x8f000
0x000507a8  ldrsw    x26, [x8, #0xd0]
0x000507ac  ldr      d0, [x20, x26]
0x000507b0  ldr      d1, [x20, x19]
0x000507b4  mov      x8, #0x4069000000000000
0x000507b8  fmov     d2, x8
0x000507bc  fmadd    d8, d1, d2, d0
0x000507c0  adrp     x8, #0x8f000
0x000507c4  ldrsw    x19, [x8, #0xd4]
0x000507c8  ldr      d0, [x20, x19]
0x000507cc  mov      x8, #0x4054000000000000
0x000507d0  fmov     d2, x8
0x000507d4  fmadd    d9, d1, d2, d0
0x000507d8  adrp     x8, #0x65000
0x000507dc  ldr      d0, [x8, #0xf00]
0x000507e0  str      d10, [sp, #0x108]
0x000507e4  fmul     d10, d10, d0
0x000507e8  adrp     x23, #0x8e000
0x000507ec  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x000507f0  adrp     x8, #0x65000
0x000507f4  ldr      d11, [x8, #0xb68]
0x000507f8  adrp     x8, #0x65000
0x000507fc  ldr      d12, [x8, #0x9c0]
0x00050800  fmov     d0, #1.00000000
0x00050804  fmov     d3, #0.25000000
0x00050808  mov      v1.16b, v11.16b
0x0005080c  mov      v2.16b, v12.16b
0x00050810  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00050814  mov      x29, x29
0x00050818  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005081c  mov      x22, x0
0x00050820  ldr      x0, [x23, #0x910]   ; @CLASS UIColor
0x00050824  fmov     d0, #1.00000000
0x00050828  fmov     d3, xzr
0x0005082c  mov      v1.16b, v11.16b
0x00050830  mov      v2.16b, v12.16b
0x00050834  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00050838  mov      x29, x29
0x0005083c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050840  mov      x23, x0
0x00050844  mov      v0.16b, v8.16b
0x00050848  mov      v1.16b, v9.16b
0x0005084c  mov      v2.16b, v10.16b
0x00050850  mov      x0, x22
0x00050854  mov      x1, x23
0x00050858  bl       #0x4c190
0x0005085c  mov      x29, x29
0x00050860  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050864  mov      x24, x0
0x00050868  mov      x0, x21
0x0005086c  mov      x2, x24
0x00050870  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x00050874  mov      x0, x24
0x00050878  bl       #0x55d78   ; CALL _objc_release
0x0005087c  mov      x0, x23
0x00050880  bl       #0x55d78   ; CALL _objc_release
0x00050884  mov      x0, x22
0x00050888  bl       #0x55d78   ; CALL _objc_release
0x0005088c  mov      x0, x21
0x00050890  bl       #0x55d78   ; CALL _objc_release
0x00050894  mov      x0, x20
0x00050898  bl       #0x575a0   ; CALL objc_msgSend$date
0x0005089c  mov      x29, x29
0x000508a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000508a4  mov      x21, x0
0x000508a8  adrp     x8, #0x8e000
0x000508ac  str      x25, [sp, #0x100]
0x000508b0  stp      x19, x26, [sp, #0x30]
0x000508b4  cbz      x0, #0x508c8
0x000508b8  mov      x0, x21
0x000508bc  bl       #0x55d84   ; CALL _objc_retain
0x000508c0  mov      x22, x21
0x000508c4  b        #0x508dc
0x000508c8  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x000508cc  bl       #0x575a0   ; CALL objc_msgSend$date
0x000508d0  mov      x29, x29
0x000508d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000508d8  mov      x22, x0
0x000508dc  mov      x0, x21
0x000508e0  bl       #0x55d78   ; CALL _objc_release
0x000508e4  mov      x0, x22
0x000508e8  bl       #0x45c90   ; CALL _SSPeriodForDate
0x000508ec  mov      x23, x0
0x000508f0  adrp     x19, #0x8e000
0x000508f4  ldr      x0, [x19, #0x988]   ; @CLASS NSMutableArray
0x000508f8  bl       #0x565c0   ; CALL objc_msgSend$array
0x000508fc  mov      x29, x29
0x00050900  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050904  mov      x26, x0
0x00050908  mov      x0, x20
0x0005090c  bl       #0x590e0   ; CALL objc_msgSend$name
0x00050910  mov      x29, x29
0x00050914  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050918  mov      x21, x0
0x0005091c  mov      x1, x23
0x00050920  bl       #0x4779c
0x00050924  mov      x29, x29
0x00050928  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005092c  mov      x23, x0
0x00050930  stur     x0, [x29, #-0xb8]
0x00050934  adrp     x8, #0x8e000
0x00050938  ldr      x24, [x8, #0x958]   ; @CLASS NSString
0x0005093c  adrp     x8, #0x8e000
0x00050940  ldr      x0, [x8, #0x980]   ; @CLASS NSDateFormatter
0x00050944  mov      x2, x22
0x00050948  mov      x3, #0
0x0005094c  mov      w4, #1
0x00050950  bl       #0x58de0   ; CALL objc_msgSend$localizedStringFromDate:dateStyle:timeStyle:
0x00050954  mov      x29, x29
0x00050958  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005095c  mov      x25, x0
0x00050960  str      x22, [sp, #0x48]
0x00050964  mov      x0, x22
0x00050968  mov      x22, x26
0x0005096c  bl       #0x47854
0x00050970  mov      x29, x29
0x00050974  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050978  mov      x26, x0
0x0005097c  stp      x25, x0, [sp]
0x00050980  adrp     x2, #0x76000
0x00050984  add      x2, x2, #0x4a8   ; STR "%@ · %@"
0x00050988  mov      x0, x24
0x0005098c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00050990  mov      x29, x29
0x00050994  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050998  mov      x24, x0
0x0005099c  adrp     x8, #0x7d000
0x000509a0  add      x8, x8, #0x768   ; STR "👋"
0x000509a4  stp      x0, x8, [x29, #-0xb0]
0x000509a8  adrp     x8, #0x8e000
0x000509ac  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000509b0  sub      x2, x29, #0xb8
0x000509b4  mov      w3, #3
0x000509b8  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000509bc  mov      x29, x29
0x000509c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000509c4  mov      x27, x0
0x000509c8  mov      x0, x22
0x000509cc  mov      x2, x27
0x000509d0  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x000509d4  mov      x0, x27
0x000509d8  bl       #0x55d78   ; CALL _objc_release
0x000509dc  mov      x0, x24
0x000509e0  bl       #0x55d78   ; CALL _objc_release
0x000509e4  mov      x0, x26
0x000509e8  bl       #0x55d78   ; CALL _objc_release
0x000509ec  mov      x0, x25
0x000509f0  bl       #0x55d78   ; CALL _objc_release
0x000509f4  mov      x0, x23
0x000509f8  bl       #0x55d78   ; CALL _objc_release
0x000509fc  mov      x0, x21
0x00050a00  bl       #0x55d78   ; CALL _objc_release
0x00050a04  mov      x0, x20
0x00050a08  bl       #0x5e100   ; CALL objc_msgSend$weather
0x00050a0c  mov      x29, x29
0x00050a10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050a14  ldr      d9, [sp, #0x108]
0x00050a18  str      x0, [sp, #0x40]
0x00050a1c  cbz      x0, #0x50ce4
0x00050a20  mov      x28, x0
0x00050a24  adrp     x2, #0x7c000
0x00050a28  add      x2, x2, #0x7c8   ; STR "code"
0x00050a2c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00050a30  mov      x29, x29
0x00050a34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050a38  mov      x21, x0
0x00050a3c  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x00050a40  mov      x23, x0
0x00050a44  mov      x0, x21
0x00050a48  bl       #0x55d78   ; CALL _objc_release
0x00050a4c  adrp     x2, #0x7c000
0x00050a50  add      x2, x2, #0x7e8   ; STR "isDay"
0x00050a54  mov      x0, x28
0x00050a58  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00050a5c  mov      x29, x29
0x00050a60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050a64  mov      x21, x0
0x00050a68  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00050a6c  mov      x24, x0
0x00050a70  mov      x0, x21
0x00050a74  bl       #0x55d78   ; CALL _objc_release
0x00050a78  add      x3, sp, #0x110
0x00050a7c  str      x23, [sp, #0xf0]
0x00050a80  mov      x0, x23
0x00050a84  str      w24, [sp, #0xe8]
0x00050a88  mov      x1, x24
0x00050a8c  mov      x2, #0
0x00050a90  bl       #0x487a4
0x00050a94  ldr      x24, [sp, #0x110]
0x00050a98  mov      x0, x24
0x00050a9c  bl       #0x55d84   ; CALL _objc_retain
0x00050aa0  ldr      x0, [x19, #0x988]   ; @CLASS NSMutableArray
0x00050aa4  bl       #0x565c0   ; CALL objc_msgSend$array
0x00050aa8  mov      x29, x29
0x00050aac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050ab0  mov      x25, x0
0x00050ab4  adrp     x2, #0x7c000
0x00050ab8  add      x2, x2, #0x768   ; STR "high"
0x00050abc  mov      x0, x28
0x00050ac0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00050ac4  mov      x29, x29
0x00050ac8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050acc  cbz      x0, #0x50bb8
0x00050ad0  mov      x21, x0
0x00050ad4  adrp     x2, #0x7c000
0x00050ad8  add      x2, x2, #0x788   ; STR "low"
0x00050adc  mov      x0, x28
0x00050ae0  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00050ae4  mov      x29, x29
0x00050ae8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050aec  mov      x23, x0
0x00050af0  bl       #0x55d78   ; CALL _objc_release
0x00050af4  mov      x0, x21
0x00050af8  bl       #0x55d78   ; CALL _objc_release
0x00050afc  cbz      x23, #0x50bb8
0x00050b00  adrp     x8, #0x8e000
0x00050b04  ldr      x21, [x8, #0x958]   ; @CLASS NSString
0x00050b08  adrp     x2, #0x7c000
0x00050b0c  add      x2, x2, #0x768   ; STR "high"
0x00050b10  mov      x0, x28
0x00050b14  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00050b18  mov      x29, x29
0x00050b1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050b20  mov      x23, x0
0x00050b24  bl       #0x48a2c
0x00050b28  mov      x29, x29
0x00050b2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050b30  mov      x27, x0
0x00050b34  adrp     x2, #0x7c000
0x00050b38  add      x2, x2, #0x788   ; STR "low"
0x00050b3c  mov      x0, x28
0x00050b40  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00050b44  mov      x29, x29
0x00050b48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050b4c  mov      x28, x0
0x00050b50  bl       #0x48a2c
0x00050b54  mov      x29, x29
0x00050b58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050b5c  mov      x26, x0
0x00050b60  stp      x27, x0, [sp]
0x00050b64  adrp     x2, #0x7d000
0x00050b68  add      x2, x2, #0x788   ; STR "↑ %@  ↓ %@"
0x00050b6c  mov      x0, x21
0x00050b70  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00050b74  mov      x29, x29
0x00050b78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050b7c  mov      x21, x0
0x00050b80  mov      x0, x25
0x00050b84  mov      x2, x21
0x00050b88  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00050b8c  mov      x0, x21
0x00050b90  bl       #0x55d78   ; CALL _objc_release
0x00050b94  mov      x0, x26
0x00050b98  bl       #0x55d78   ; CALL _objc_release
0x00050b9c  mov      x0, x28
0x00050ba0  ldr      x28, [sp, #0x40]
0x00050ba4  bl       #0x55d78   ; CALL _objc_release
0x00050ba8  mov      x0, x27
0x00050bac  bl       #0x55d78   ; CALL _objc_release
0x00050bb0  mov      x0, x23
0x00050bb4  bl       #0x55d78   ; CALL _objc_release
0x00050bb8  adrp     x2, #0x7c000
0x00050bbc  add      x2, x2, #0x7a8   ; STR "rain"
0x00050bc0  mov      x0, x28
0x00050bc4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00050bc8  mov      x29, x29
0x00050bcc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050bd0  mov      x21, x0
0x00050bd4  bl       #0x55d78   ; CALL _objc_release
0x00050bd8  adrp     x19, #0x8e000
0x00050bdc  adrp     x27, #0x8e000
0x00050be0  cbz      x21, #0x50c68
0x00050be4  ldr      x21, [x27, #0x958]   ; @CLASS NSString
0x00050be8  adrp     x0, #0x7d000
0x00050bec  add      x0, x0, #0x7a8   ; STR "%ld%% khả năng mưa"
0x00050bf0  adrp     x1, #0x7d000
0x00050bf4  add      x1, x1, #0x7c8   ; STR "%ld%% chance of rain"
0x00050bf8  bl       #0x5505c   ; CALL _OMCTr
0x00050bfc  mov      x29, x29
0x00050c00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050c04  mov      x23, x0
0x00050c08  adrp     x2, #0x7c000
0x00050c0c  add      x2, x2, #0x7a8   ; STR "rain"
0x00050c10  mov      x0, x28
0x00050c14  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00050c18  mov      x29, x29
0x00050c1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050c20  mov      x26, x0
0x00050c24  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x00050c28  str      x0, [sp]
0x00050c2c  mov      x0, x21
0x00050c30  mov      x2, x23
0x00050c34  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00050c38  mov      x29, x29
0x00050c3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050c40  mov      x21, x0
0x00050c44  mov      x0, x25
0x00050c48  mov      x2, x21
0x00050c4c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00050c50  mov      x0, x21
0x00050c54  bl       #0x55d78   ; CALL _objc_release
0x00050c58  mov      x0, x26
0x00050c5c  bl       #0x55d78   ; CALL _objc_release
0x00050c60  mov      x0, x23
0x00050c64  bl       #0x55d78   ; CALL _objc_release
0x00050c68  ldr      x21, [x27, #0x958]   ; @CLASS NSString
0x00050c6c  adrp     x2, #0x7c000
0x00050c70  add      x2, x2, #0x748   ; STR "temp"
0x00050c74  mov      x0, x28
0x00050c78  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00050c7c  mov      x29, x29
0x00050c80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050c84  mov      x27, x0
0x00050c88  bl       #0x48a2c
0x00050c8c  mov      x29, x29
0x00050c90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050c94  mov      x28, x0
0x00050c98  stp      x0, x24, [sp]
0x00050c9c  adrp     x2, #0x76000
0x00050ca0  add      x2, x2, #0x4a8   ; STR "%@ · %@"
0x00050ca4  mov      x0, x21
0x00050ca8  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00050cac  mov      x29, x29
0x00050cb0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050cb4  mov      x23, x0
0x00050cb8  stur     x0, [x29, #-0xd0]
0x00050cbc  mov      x0, x25
0x00050cc0  bl       #0x573c0   ; CALL objc_msgSend$count
0x00050cc4  cbz      x0, #0x50d84
0x00050cc8  adrp     x2, #0x75000
0x00050ccc  add      x2, x2, #0xb88   ; STR " · "
0x00050cd0  mov      x0, x25
0x00050cd4  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x00050cd8  mov      x29, x29
0x00050cdc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050ce0  b        #0x50da0
0x00050ce4  mov      x0, x20
0x00050ce8  bl       #0x56740   ; CALL objc_msgSend$batteryPercent
0x00050cec  adrp     x19, #0x8e000
0x00050cf0  tbnz     x0, #0x3f, #0x50e7c
0x00050cf4  mov      x0, x20
0x00050cf8  bl       #0x56740   ; CALL objc_msgSend$batteryPercent
0x00050cfc  mov      x21, x0
0x00050d00  adrp     x8, #0x8e000
0x00050d04  ldr      x23, [x8, #0x958]   ; @CLASS NSString
0x00050d08  adrp     x0, #0x7d000
0x00050d0c  add      x0, x0, #0x828   ; STR "Pin iPhone %ld%%"
0x00050d10  adrp     x1, #0x7d000
0x00050d14  add      x1, x1, #0x848   ; STR "iPhone battery %ld%%"
0x00050d18  bl       #0x5505c   ; CALL _OMCTr
0x00050d1c  mov      x29, x29
0x00050d20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050d24  mov      x24, x0
0x00050d28  mov      x0, x20
0x00050d2c  bl       #0x56740   ; CALL objc_msgSend$batteryPercent
0x00050d30  str      x0, [sp]
0x00050d34  mov      x0, x23
0x00050d38  mov      x2, x24
0x00050d3c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00050d40  mov      x29, x29
0x00050d44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050d48  mov      x25, x0
0x00050d4c  stur     x0, [x29, #-0xe8]
0x00050d50  cmp      x21, #0x13
0x00050d54  b.gt     #0x50e08
0x00050d58  adrp     x0, #0x7d000
0x00050d5c  add      x0, x0, #0x868   ; STR "Nhớ cắm sạc trên xe"
0x00050d60  adrp     x1, #0x7d000
0x00050d64  add      x1, x1, #0x888   ; STR "Plug it in on the way"
0x00050d68  bl       #0x5505c   ; CALL _OMCTr
0x00050d6c  mov      x29, x29
0x00050d70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050d74  mov      x27, x0
0x00050d78  adrp     x8, #0x7d000
0x00050d7c  add      x8, x8, #0x8e8   ; STR "🪫"
0x00050d80  b        #0x50e30
0x00050d84  adrp     x0, #0x7d000
0x00050d88  add      x0, x0, #0x7e8   ; STR "Thời tiết hôm nay"
0x00050d8c  adrp     x1, #0x7d000
0x00050d90  add      x1, x1, #0x808   ; STR "Today's weather"
0x00050d94  bl       #0x5505c   ; CALL _OMCTr
0x00050d98  mov      x29, x29
0x00050d9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050da0  mov      x21, x0
0x00050da4  stur     x0, [x29, #-0xc8]
0x00050da8  ldr      x0, [sp, #0xf0]
0x00050dac  ldr      w1, [sp, #0xe8]
0x00050db0  bl       #0x4712c
0x00050db4  adrp     x8, #0x74000
0x00050db8  add      x8, x8, #0xf38
0x00050dbc  ldr      x8, [x8, x0, lsl #3]
0x00050dc0  stur     x8, [x29, #-0xc0]
0x00050dc4  ldr      x0, [x19, #0x960]   ; @CLASS NSArray
0x00050dc8  sub      x2, x29, #0xd0
0x00050dcc  mov      w3, #3
0x00050dd0  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00050dd4  mov      x29, x29
0x00050dd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050ddc  mov      x26, x0
0x00050de0  mov      x0, x22
0x00050de4  mov      x2, x26
0x00050de8  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00050dec  mov      x0, x26
0x00050df0  bl       #0x55d78   ; CALL _objc_release
0x00050df4  mov      x0, x21
0x00050df8  bl       #0x55d78   ; CALL _objc_release
0x00050dfc  mov      x0, x23
0x00050e00  bl       #0x55d78   ; CALL _objc_release
0x00050e04  b        #0x50e5c
0x00050e08  adrp     x0, #0x7d000
0x00050e0c  add      x0, x0, #0x8a8   ; STR "Đủ pin cho chuyến đi"
0x00050e10  adrp     x1, #0x7d000
0x00050e14  add      x1, x1, #0x8c8   ; STR "Enough for the trip"
0x00050e18  bl       #0x5505c   ; CALL _OMCTr
0x00050e1c  mov      x29, x29
0x00050e20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050e24  mov      x27, x0
0x00050e28  adrp     x8, #0x7d000
0x00050e2c  add      x8, x8, #0x908   ; STR "🔋"
0x00050e30  stp      x27, x8, [x29, #-0xe0]
0x00050e34  ldr      x0, [x19, #0x960]   ; @CLASS NSArray
0x00050e38  sub      x2, x29, #0xe8
0x00050e3c  mov      w3, #3
0x00050e40  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00050e44  mov      x29, x29
0x00050e48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050e4c  mov      x28, x0
0x00050e50  mov      x0, x22
0x00050e54  mov      x2, x28
0x00050e58  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00050e5c  mov      x0, x28
0x00050e60  bl       #0x55d78   ; CALL _objc_release
0x00050e64  mov      x0, x27
0x00050e68  bl       #0x55d78   ; CALL _objc_release
0x00050e6c  mov      x0, x25
0x00050e70  bl       #0x55d78   ; CALL _objc_release
0x00050e74  mov      x0, x24
0x00050e78  bl       #0x55d78   ; CALL _objc_release
0x00050e7c  mov      x23, x19
0x00050e80  mov      x0, x20
0x00050e84  bl       #0x591e0   ; CALL objc_msgSend$nextEvent
0x00050e88  mov      x29, x29
0x00050e8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050e90  mov      x25, x0
0x00050e94  adrp     x2, #0x75000
0x00050e98  add      x2, x2, #0x4a8   ; STR "title"
0x00050e9c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00050ea0  mov      x29, x29
0x00050ea4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050ea8  mov      x21, x0
0x00050eac  adrp     x26, #0x8e000
0x00050eb0  ldr      x0, [x26, #0x958]   ; @CLASS NSString
0x00050eb4  bl       #0x55d48   ; CALL _objc_opt_class
0x00050eb8  mov      x1, x0
0x00050ebc  mov      x0, x21
0x00050ec0  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00050ec4  tbz      w0, #0, #0x50ee8
0x00050ec8  adrp     x2, #0x75000
0x00050ecc  add      x2, x2, #0x4a8   ; STR "title"
0x00050ed0  mov      x0, x25
0x00050ed4  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00050ed8  mov      x29, x29
0x00050edc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050ee0  mov      x28, x0
0x00050ee4  b        #0x50eec
0x00050ee8  mov      x28, #0
0x00050eec  adrp     x19, #0x8e000
0x00050ef0  mov      x0, x21
0x00050ef4  bl       #0x55d78   ; CALL _objc_release
0x00050ef8  adrp     x2, #0x75000
0x00050efc  add      x2, x2, #0x968   ; STR "date"
0x00050f00  mov      x0, x25
0x00050f04  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00050f08  mov      x29, x29
0x00050f0c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050f10  mov      x21, x0
0x00050f14  ldr      x0, [x19, #0x978]   ; @CLASS NSDate
0x00050f18  bl       #0x55d48   ; CALL _objc_opt_class
0x00050f1c  mov      x1, x0
0x00050f20  mov      x0, x21
0x00050f24  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x00050f28  tbz      w0, #0, #0x50f4c
0x00050f2c  adrp     x2, #0x75000
0x00050f30  add      x2, x2, #0x968   ; STR "date"
0x00050f34  mov      x0, x25
0x00050f38  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00050f3c  mov      x29, x29
0x00050f40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050f44  mov      x24, x0
0x00050f48  b        #0x50f50
0x00050f4c  mov      x24, #0
0x00050f50  mov      x19, x23
0x00050f54  mov      x0, x21
0x00050f58  bl       #0x55d78   ; CALL _objc_release
0x00050f5c  mov      x0, x28
0x00050f60  bl       #0x58c20   ; CALL objc_msgSend$length
0x00050f64  stp      x28, x25, [sp, #0x20]
0x00050f68  cbz      x0, #0x51224
0x00050f6c  cbz      x24, #0x51038
0x00050f70  ldr      x21, [x26, #0x958]   ; @CLASS NSString
0x00050f74  adrp     x8, #0x8e000
0x00050f78  ldr      x0, [x8, #0x980]   ; @CLASS NSDateFormatter
0x00050f7c  mov      x2, x24
0x00050f80  mov      x3, #0
0x00050f84  mov      w4, #1
0x00050f88  bl       #0x58de0   ; CALL objc_msgSend$localizedStringFromDate:dateStyle:timeStyle:
0x00050f8c  mov      x29, x29
0x00050f90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050f94  mov      x23, x0
0x00050f98  stp      x28, x0, [sp]
0x00050f9c  adrp     x2, #0x75000
0x00050fa0  add      x2, x2, #0x728   ; STR "%@ %@"
0x00050fa4  mov      x0, x21
0x00050fa8  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00050fac  mov      x29, x29
0x00050fb0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050fb4  mov      x21, x0
0x00050fb8  mov      x0, x23
0x00050fbc  bl       #0x55d78   ; CALL _objc_release
0x00050fc0  adrp     x0, #0x7d000
0x00050fc4  add      x0, x0, #0x928   ; STR "Lịch hẹn kế tiếp"
0x00050fc8  adrp     x1, #0x7d000
0x00050fcc  add      x1, x1, #0x948   ; STR "Next on your calendar"
0x00050fd0  bl       #0x5505c   ; CALL _OMCTr
0x00050fd4  mov      x29, x29
0x00050fd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00050fdc  mov      x27, x0
0x00050fe0  mov      x0, x24
0x00050fe4  ldr      x2, [sp, #0x48]
0x00050fe8  bl       #0x5dac0   ; CALL objc_msgSend$timeIntervalSinceDate:
0x00050fec  mov      x8, #0x404e000000000000
0x00050ff0  fmov     d1, x8
0x00050ff4  fdiv     d0, d0, d1
0x00050ff8  fcvtps   x19, d0
0x00050ffc  cmp      x19, #0
0x00051000  b.le     #0x51068
0x00051004  ldr      x23, [x26, #0x958]   ; @CLASS NSString
0x00051008  cmp      x19, #0x3b
0x0005100c  b.hi     #0x51090
0x00051010  adrp     x0, #0x7d000
0x00051014  add      x0, x0, #0x9a8   ; STR "Còn %ld phút"
0x00051018  adrp     x1, #0x7d000
0x0005101c  add      x1, x1, #0x9c8   ; STR "In %ld min"
0x00051020  bl       #0x5505c   ; CALL _OMCTr
0x00051024  mov      x29, x29
0x00051028  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005102c  mov      x28, x0
0x00051030  str      x19, [sp]
0x00051034  b        #0x510cc
0x00051038  mov      x0, x28
0x0005103c  bl       #0x55d84   ; CALL _objc_retain
0x00051040  adrp     x0, #0x7d000
0x00051044  add      x0, x0, #0x928   ; STR "Lịch hẹn kế tiếp"
0x00051048  adrp     x1, #0x7d000
0x0005104c  add      x1, x1, #0x948   ; STR "Next on your calendar"
0x00051050  bl       #0x5505c   ; CALL _OMCTr
0x00051054  mov      x29, x29
0x00051058  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005105c  mov      x26, x0
0x00051060  mov      x21, x28
0x00051064  b        #0x510f8
0x00051068  adrp     x0, #0x7d000
0x0005106c  add      x0, x0, #0x968   ; STR "Đang diễn ra"
0x00051070  adrp     x1, #0x7d000
0x00051074  add      x1, x1, #0x988   ; STR "Happening now"
0x00051078  bl       #0x5505c   ; CALL _OMCTr
0x0005107c  mov      x29, x29
0x00051080  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051084  mov      x26, x0
0x00051088  mov      x0, x27
0x0005108c  b        #0x510f0
0x00051090  adrp     x0, #0x7d000
0x00051094  add      x0, x0, #0x9e8   ; STR "Còn %ld giờ %ld phút"
0x00051098  adrp     x1, #0x7d000
0x0005109c  add      x1, x1, #0xa08   ; STR "In %ld h %ld min"
0x000510a0  bl       #0x5505c   ; CALL _OMCTr
0x000510a4  mov      x29, x29
0x000510a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000510ac  mov      x28, x0
0x000510b0  mov      x8, #-0x7777777777777778
0x000510b4  movk     x8, #0x8889
0x000510b8  umulh    x8, x19, x8
0x000510bc  lsr      x8, x8, #5
0x000510c0  mov      w9, #0x3c
0x000510c4  msub     x9, x8, x9, x19
0x000510c8  stp      x8, x9, [sp]
0x000510cc  mov      x0, x23
0x000510d0  mov      x2, x28
0x000510d4  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x000510d8  mov      x29, x29
0x000510dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000510e0  mov      x26, x0
0x000510e4  mov      x0, x27
0x000510e8  bl       #0x55d78   ; CALL _objc_release
0x000510ec  mov      x0, x28
0x000510f0  bl       #0x55d78   ; CALL _objc_release
0x000510f4  adrp     x19, #0x8e000
0x000510f8  adrp     x2, #0x7d000
0x000510fc  add      x2, x2, #0xa28   ; STR "location"
0x00051100  mov      x0, x25
0x00051104  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00051108  mov      x29, x29
0x0005110c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051110  mov      x27, x0
0x00051114  adrp     x8, #0x8e000
0x00051118  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0005111c  bl       #0x55d48   ; CALL _objc_opt_class
0x00051120  mov      x1, x0
0x00051124  mov      x0, x27
0x00051128  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0005112c  tbz      w0, #0, #0x51180
0x00051130  adrp     x2, #0x7d000
0x00051134  add      x2, x2, #0xa28   ; STR "location"
0x00051138  mov      x0, x25
0x0005113c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00051140  mov      x29, x29
0x00051144  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051148  mov      x25, x20
0x0005114c  mov      x20, x21
0x00051150  mov      x21, x19
0x00051154  mov      x28, x0
0x00051158  bl       #0x4da60
0x0005115c  mov      x29, x29
0x00051160  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051164  mov      x23, x0
0x00051168  mov      x0, x28
0x0005116c  mov      x19, x21
0x00051170  mov      x21, x20
0x00051174  mov      x20, x25
0x00051178  bl       #0x55d78   ; CALL _objc_release
0x0005117c  b        #0x51188
0x00051180  adrp     x23, #0x75000
0x00051184  add      x23, x23, #0xd28
0x00051188  mov      x0, x27
0x0005118c  bl       #0x55d78   ; CALL _objc_release
0x00051190  mov      x0, x23
0x00051194  bl       #0x58c20   ; CALL objc_msgSend$length
0x00051198  cbz      x0, #0x511cc
0x0005119c  adrp     x8, #0x8e000
0x000511a0  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x000511a4  stp      x26, x23, [sp]
0x000511a8  adrp     x2, #0x76000
0x000511ac  add      x2, x2, #0x4a8   ; STR "%@ · %@"
0x000511b0  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x000511b4  mov      x29, x29
0x000511b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000511bc  mov      x27, x0
0x000511c0  mov      x0, x26
0x000511c4  bl       #0x55d78   ; CALL _objc_release
0x000511c8  mov      x26, x27
0x000511cc  stp      x21, x26, [x29, #-0x100]
0x000511d0  adrp     x8, #0x7d000
0x000511d4  add      x8, x8, #0xa48   ; STR "📅"
0x000511d8  stur     x8, [x29, #-0xf0]
0x000511dc  ldr      x0, [x19, #0x960]   ; @CLASS NSArray
0x000511e0  sub      x2, x29, #0x100
0x000511e4  mov      w3, #3
0x000511e8  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000511ec  mov      x29, x29
0x000511f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000511f4  mov      x27, x0
0x000511f8  mov      x0, x22
0x000511fc  mov      x2, x27
0x00051200  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00051204  mov      x0, x27
0x00051208  bl       #0x55d78   ; CALL _objc_release
0x0005120c  mov      x0, x23
0x00051210  bl       #0x55d78   ; CALL _objc_release
0x00051214  mov      x0, x26
0x00051218  bl       #0x55d78   ; CALL _objc_release
0x0005121c  mov      x0, x21
0x00051220  bl       #0x55d78   ; CALL _objc_release
0x00051224  str      x22, [sp, #0xf8]
0x00051228  str      x24, [sp, #0x18]
0x0005122c  adrp     x0, #0x7d000
0x00051230  add      x0, x0, #0xa68   ; STR "Thắt dây an toàn"
0x00051234  adrp     x1, #0x7d000
0x00051238  add      x1, x1, #0xa88   ; STR "Buckle up"
0x0005123c  bl       #0x5505c   ; CALL _OMCTr
0x00051240  mov      x29, x29
0x00051244  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051248  mov      x21, x0
0x0005124c  str      x0, [sp, #0x118]
0x00051250  adrp     x0, #0x7d000
0x00051254  add      x0, x0, #0xaa8   ; STR "Chúc bạn thượng lộ bình an"
0x00051258  adrp     x1, #0x7d000
0x0005125c  add      x1, x1, #0xac8   ; STR "Have a safe trip"
0x00051260  bl       #0x5505c   ; CALL _OMCTr
0x00051264  mov      x29, x29
0x00051268  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005126c  mov      x23, x0
0x00051270  adrp     x8, #0x7d000
0x00051274  add      x8, x8, #0xae8   ; STR "🛡"
0x00051278  stp      x0, x8, [sp, #0x120]
0x0005127c  ldr      x0, [x19, #0x960]   ; @CLASS NSArray
0x00051280  add      x2, sp, #0x118
0x00051284  mov      w3, #3
0x00051288  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0005128c  mov      x29, x29
0x00051290  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051294  mov      x26, x0
0x00051298  mov      x0, x22
0x0005129c  mov      x2, x26
0x000512a0  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x000512a4  mov      x0, x26
0x000512a8  bl       #0x55d78   ; CALL _objc_release
0x000512ac  mov      x0, x23
0x000512b0  bl       #0x55d78   ; CALL _objc_release
0x000512b4  mov      x0, x21
0x000512b8  bl       #0x55d78   ; CALL _objc_release
0x000512bc  mov      x0, x22
0x000512c0  bl       #0x573c0   ; CALL objc_msgSend$count
0x000512c4  mov      x19, x20
0x000512c8  ldp      x20, x21, [sp, #0x30]
0x000512cc  adrp     x22, #0x8e000
0x000512d0  cbz      x0, #0x5176c
0x000512d4  mov      x27, x0
0x000512d8  mov      x28, #0
0x000512dc  adrp     x8, #0x66000
0x000512e0  ldr      d0, [x8, #0x158]
0x000512e4  adrp     x8, #0x65000
0x000512e8  ldr      d1, [x8, #0x9b8]
0x000512ec  fmul     d0, d9, d0
0x000512f0  str      d0, [sp, #0xf0]
0x000512f4  adrp     x8, #0x74000
0x000512f8  ldr      x8, [x8, #0x648]   ; @GOT _kCACornerCurveContinuous
0x000512fc  fmul     d0, d9, d1
0x00051300  str      d0, [sp, #0xe8]
0x00051304  adrp     x9, #0x65000
0x00051308  ldr      d0, [x9, #0x830]
0x0005130c  mov      x9, #0x4041000000000000
0x00051310  adrp     x10, #0x66000
0x00051314  ldr      d1, [x10, #0x160]
0x00051318  fmov     d2, x9
0x0005131c  adrp     x9, #0x66000
0x00051320  ldr      d3, [x9, #0x168]
0x00051324  fmul     d2, d9, d2
0x00051328  str      d2, [sp, #0xe0]
0x0005132c  adrp     x9, #0x74000
0x00051330  ldr      x9, [x9, #0x258]   ; @GOT _UIFontWeightRegular
0x00051334  fmul     d0, d9, d0
0x00051338  fmov     d2, #0.50000000
0x0005133c  ldr      d4, [x9]   ; @GOT ___objc_personality_v0
0x00051340  fmaxnm   d0, d0, d2
0x00051344  stp      d0, d4, [sp, #0xd0]
0x00051348  fmul     d2, d9, d1
0x0005134c  fmul     d0, d9, d3
0x00051350  stp      d0, d2, [sp, #0xc0]
0x00051354  adrp     x9, #0x65000
0x00051358  ldr      d0, [x9, #0x788]
0x0005135c  fmul     d0, d9, d0
0x00051360  str      d0, [sp, #0xb8]
0x00051364  adrp     x9, #0x65000
0x00051368  ldr      d0, [x9, #0x798]
0x0005136c  fmul     d8, d9, d0
0x00051370  adrp     x9, #0x66000
0x00051374  ldr      d0, [x9, #0x170]
0x00051378  fmul     d0, d9, d0
0x0005137c  str      d0, [sp, #0xb0]
0x00051380  adrp     x9, #0x74000
0x00051384  ldr      x9, [x9, #0x238]   ; @GOT _UIFontWeightBold
0x00051388  ldr      d0, [x9]   ; @GOT ___objc_personality_v0
0x0005138c  str      d0, [sp, #0xa8]
0x00051390  adrp     x9, #0x66000
0x00051394  ldr      d0, [x9, #0xf0]
0x00051398  fmul     d11, d9, d0
0x0005139c  adrp     x9, #0x65000
0x000513a0  ldr      d0, [x9, #0xb90]
0x000513a4  fmul     d0, d9, d0
0x000513a8  str      d0, [sp, #0xa0]
0x000513ac  adrp     x9, #0x74000
0x000513b0  ldr      x9, [x9, #0x250]   ; @GOT _UIFontWeightMedium
0x000513b4  ldr      d1, [x9]   ; @GOT ___objc_personality_v0
0x000513b8  mov      x9, #0x4044000000000000
0x000513bc  fmov     d0, x9
0x000513c0  stp      d0, d1, [sp, #0x90]
0x000513c4  fmul     d0, d9, d0
0x000513c8  str      d0, [sp, #0x88]
0x000513cc  adrp     x9, #0x65000
0x000513d0  ldr      d9, [x9, #0xa00]
0x000513d4  adrp     x9, #0x66000
0x000513d8  ldr      d0, [x9, #0x178]
0x000513dc  str      d0, [sp, #0x80]
0x000513e0  adrp     x9, #0x66000
0x000513e4  ldr      d0, [x9, #0x180]
0x000513e8  str      d0, [sp, #0x78]
0x000513ec  adrp     x9, #0x66000
0x000513f0  ldr      d0, [x9, #0x188]
0x000513f4  str      d0, [sp, #0x70]
0x000513f8  adrp     x9, #0x65000
0x000513fc  ldr      d0, [x9, #0x770]
0x00051400  str      d0, [sp, #0x68]
0x00051404  adrp     x9, #0x65000
0x00051408  ldr      d0, [x9, #0xe50]
0x0005140c  str      d0, [sp, #0x60]
0x00051410  adrp     x9, #0x65000
0x00051414  ldr      d13, [x9, #0x700]
0x00051418  adrp     x9, #0x65000
0x0005141c  ldr      d0, [x9, #0x608]
0x00051420  str      d0, [sp, #0x58]
0x00051424  adrp     x9, #0x65000
0x00051428  ldr      d15, [x9, #0x6c0]
0x0005142c  adrp     x9, #0x65000
0x00051430  ldr      d10, [x9, #0x708]
0x00051434  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00051438  str      x8, [sp, #0x50]
0x0005143c  tst      w28, #1
0x00051440  ldp      d2, d0, [sp, #0x78]
0x00051444  fcsel    d0, d0, d9, ne
0x00051448  cmp      x28, #2
0x0005144c  ccmp     x27, #3, #0, eq
0x00051450  lsr      x8, x28, #1
0x00051454  mov      w9, #0xf0
0x00051458  mov      x10, #0x46
0x0005145c  madd     x8, x8, x9, x10
0x00051460  ucvtf    d1, x8
0x00051464  fcsel    d12, d2, d0, eq
0x00051468  cmp      x27, #2
0x0005146c  ldr      d0, [sp, #0x70]
0x00051470  fcsel    d14, d0, d1, eq
0x00051474  adrp     x8, #0x8e000
0x00051478  ldr      x0, [x8, #0x918]   ; @CLASS UIView
0x0005147c  bl       #0x55c7c   ; CALL _objc_alloc
0x00051480  ldr      d0, [x19, x21]   ; @SEL "whatsNewNavigationController"
0x00051484  ldr      d1, [sp, #0x108]
0x00051488  fmadd    d0, d12, d1, d0
0x0005148c  ldr      d1, [x19, x20]   ; @SEL "whatsNewNavigationController"
0x00051490  ldr      d2, [sp, #0x108]
0x00051494  fmadd    d1, d14, d2, d1
0x00051498  ldp      d3, d2, [sp, #0xe8]
0x0005149c  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x000514a0  mov      x26, x0
0x000514a4  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x000514a8  fmov     d0, #1.00000000
0x000514ac  fmov     d1, #1.00000000
0x000514b0  fmov     d2, #1.00000000
0x000514b4  ldr      d3, [sp, #0x68]
0x000514b8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000514bc  mov      x29, x29
0x000514c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000514c4  mov      x23, x0
0x000514c8  mov      x0, x26
0x000514cc  mov      x2, x23
0x000514d0  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x000514d4  mov      x0, x23
0x000514d8  bl       #0x55d78   ; CALL _objc_release
0x000514dc  mov      x0, x26
0x000514e0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000514e4  mov      x29, x29
0x000514e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000514ec  mov      x23, x0
0x000514f0  ldr      d0, [sp, #0xe0]
0x000514f4  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x000514f8  mov      x0, x23
0x000514fc  bl       #0x55d78   ; CALL _objc_release
0x00051500  mov      x0, x26
0x00051504  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00051508  mov      x29, x29
0x0005150c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051510  mov      x23, x0
0x00051514  ldr      x2, [sp, #0x50]
0x00051518  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x0005151c  mov      x0, x23
0x00051520  bl       #0x55d78   ; CALL _objc_release
0x00051524  mov      x0, x26
0x00051528  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0005152c  mov      x29, x29
0x00051530  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051534  mov      x23, x0
0x00051538  ldr      d0, [sp, #0xd0]
0x0005153c  bl       #0x5a740   ; CALL objc_msgSend$setBorderWidth:
0x00051540  mov      x0, x23
0x00051544  bl       #0x55d78   ; CALL _objc_release
0x00051548  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x0005154c  fmov     d0, #1.00000000
0x00051550  fmov     d1, #1.00000000
0x00051554  fmov     d2, #1.00000000
0x00051558  ldr      d3, [sp, #0x60]
0x0005155c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00051560  mov      x29, x29
0x00051564  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051568  mov      x23, x0
0x0005156c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00051570  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00051574  mov      x25, x0
0x00051578  mov      x0, x26
0x0005157c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00051580  mov      x29, x29
0x00051584  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051588  mov      x24, x0
0x0005158c  mov      x2, x25
0x00051590  bl       #0x5a700   ; CALL objc_msgSend$setBorderColor:
0x00051594  mov      x0, x24
0x00051598  bl       #0x55d78   ; CALL _objc_release
0x0005159c  mov      x0, x23
0x000515a0  bl       #0x55d78   ; CALL _objc_release
0x000515a4  ldr      x0, [sp, #0x100]
0x000515a8  mov      x2, x26
0x000515ac  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x000515b0  ldr      x25, [sp, #0xf8]
0x000515b4  mov      x0, x25
0x000515b8  mov      x2, x28
0x000515bc  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000515c0  mov      x29, x29
0x000515c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000515c8  mov      x23, x0
0x000515cc  mov      w2, #2
0x000515d0  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000515d4  mov      x29, x29
0x000515d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000515dc  mov      x24, x0
0x000515e0  mov      x0, x19
0x000515e4  mov      x2, x24
0x000515e8  ldp      d1, d0, [sp, #0xc0]
0x000515ec  mov      v2.16b, v9.16b
0x000515f0  ldr      d3, [sp, #0xd8]
0x000515f4  mov      x3, #0
0x000515f8  mov      w4, #0
0x000515fc  mov      x5, x26
0x00051600  ldr      d4, [sp, #0xb8]
0x00051604  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x00051608  mov      x29, x29
0x0005160c  bl       #0x55dfc   ; CALL _objc_unsafeClaimAutoreleasedReturnValue
0x00051610  mov      x0, x24
0x00051614  bl       #0x55d78   ; CALL _objc_release
0x00051618  mov      x0, x23
0x0005161c  bl       #0x55d78   ; CALL _objc_release
0x00051620  mov      x0, x25
0x00051624  mov      x2, x28
0x00051628  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0005162c  mov      x29, x29
0x00051630  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051634  mov      x23, x0
0x00051638  mov      x2, #0
0x0005163c  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00051640  mov      x29, x29
0x00051644  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051648  mov      x24, x0
0x0005164c  mov      x0, x19
0x00051650  mov      x2, x24
0x00051654  mov      v0.16b, v8.16b
0x00051658  ldp      d3, d1, [sp, #0xa8]
0x0005165c  ldr      d2, [sp, #0x90]
0x00051660  mov      x3, #0
0x00051664  mov      w4, #1
0x00051668  mov      x5, x26
0x0005166c  mov      v4.16b, v11.16b
0x00051670  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x00051674  mov      x29, x29
0x00051678  bl       #0x55dfc   ; CALL _objc_unsafeClaimAutoreleasedReturnValue
0x0005167c  mov      x0, x24
0x00051680  bl       #0x55d78   ; CALL _objc_release
0x00051684  mov      x0, x23
0x00051688  bl       #0x55d78   ; CALL _objc_release
0x0005168c  mov      x0, x25
0x00051690  mov      x2, x28
0x00051694  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00051698  mov      x29, x29
0x0005169c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000516a0  mov      x23, x0
0x000516a4  mov      w2, #1
0x000516a8  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000516ac  mov      x29, x29
0x000516b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000516b4  mov      x24, x0
0x000516b8  fmov     d2, #26.00000000
0x000516bc  mov      x0, x19
0x000516c0  mov      x2, x24
0x000516c4  mov      v0.16b, v8.16b
0x000516c8  ldp      d3, d1, [sp, #0x98]
0x000516cc  mov      x3, #0
0x000516d0  mov      w4, #1
0x000516d4  mov      x5, x26
0x000516d8  mov      v4.16b, v11.16b
0x000516dc  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x000516e0  mov      x29, x29
0x000516e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000516e8  mov      x25, x0
0x000516ec  mov      x0, x24
0x000516f0  bl       #0x55d78   ; CALL _objc_release
0x000516f4  mov      x0, x23
0x000516f8  bl       #0x55d78   ; CALL _objc_release
0x000516fc  mov      x0, x25
0x00051700  mov      v0.16b, v13.16b
0x00051704  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x00051708  ucvtf    d1, x28
0x0005170c  ldr      d0, [sp, #0x58]
0x00051710  fmadd    d0, d1, d15, d0
0x00051714  fmadd    d1, d1, d15, d10
0x00051718  fmov     d2, #1.00000000
0x0005171c  mov      x0, x19
0x00051720  mov      x2, x26
0x00051724  bl       #0x5d160   ; CALL objc_msgSend$ss_fade:from:to:alpha:
0x00051728  mov      x29, x29
0x0005172c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051730  mov      x23, x0
0x00051734  mov      w2, #1
0x00051738  bl       #0x5b9c0   ; CALL objc_msgSend$setOutEase:
0x0005173c  mov      x0, x23
0x00051740  ldr      d0, [sp, #0x88]
0x00051744  bl       #0x5be80   ; CALL objc_msgSend$setRise:
0x00051748  mov      x0, x23
0x0005174c  bl       #0x55d78   ; CALL _objc_release
0x00051750  mov      x0, x25
0x00051754  bl       #0x55d78   ; CALL _objc_release
0x00051758  mov      x0, x26
0x0005175c  bl       #0x55d78   ; CALL _objc_release
0x00051760  add      x28, x28, #1
0x00051764  cmp      x27, x28
0x00051768  b.ne     #0x5143c
0x0005176c  ldr      x0, [sp, #0x18]
0x00051770  bl       #0x55d78   ; CALL _objc_release
0x00051774  ldr      x0, [sp, #0x20]
0x00051778  bl       #0x55d78   ; CALL _objc_release
0x0005177c  ldr      x0, [sp, #0x28]
0x00051780  bl       #0x55d78   ; CALL _objc_release
0x00051784  ldr      x0, [sp, #0x40]
0x00051788  bl       #0x55d78   ; CALL _objc_release
0x0005178c  ldr      x0, [sp, #0xf8]
0x00051790  bl       #0x55d78   ; CALL _objc_release
0x00051794  ldr      x0, [sp, #0x48]
0x00051798  bl       #0x55d78   ; CALL _objc_release
0x0005179c  ldr      x0, [sp, #0x100]
0x000517a0  bl       #0x55d78   ; CALL _objc_release
0x000517a4  ldur     x8, [x29, #-0xa0]
0x000517a8  adrp     x9, #0x74000
0x000517ac  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000517b0  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000517b4  cmp      x9, x8
0x000517b8  b.ne     #0x517ec
0x000517bc  add      sp, sp, #0x1a0
0x000517c0  ldp      x29, x30, [sp, #0x90]
0x000517c4  ldp      x20, x19, [sp, #0x80]
0x000517c8  ldp      x22, x21, [sp, #0x70]
0x000517cc  ldp      x24, x23, [sp, #0x60]
0x000517d0  ldp      x26, x25, [sp, #0x50]
0x000517d4  ldp      x28, x27, [sp, #0x40]
0x000517d8  ldp      d9, d8, [sp, #0x30]
0x000517dc  ldp      d11, d10, [sp, #0x20]
0x000517e0  ldp      d13, d12, [sp, #0x10]
0x000517e4  ldp      d15, d14, [sp], #0xa0
0x000517e8  ret      
0x000517ec  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[SSStartupView ss_buildLiquid]  va=0x517f0 size=3900 types=v16@0:8
0x000517f0  stp      d15, d14, [sp, #-0xa0]!
0x000517f4  stp      d13, d12, [sp, #0x10]
0x000517f8  stp      d11, d10, [sp, #0x20]
0x000517fc  stp      d9, d8, [sp, #0x30]
0x00051800  stp      x28, x27, [sp, #0x40]
0x00051804  stp      x26, x25, [sp, #0x50]
0x00051808  stp      x24, x23, [sp, #0x60]
0x0005180c  stp      x22, x21, [sp, #0x70]
0x00051810  stp      x20, x19, [sp, #0x80]
0x00051814  stp      x29, x30, [sp, #0x90]
0x00051818  add      x29, sp, #0x90
0x0005181c  sub      sp, sp, #0x540
0x00051820  adrp     x8, #0x74000
0x00051824  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00051828  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0005182c  stur     x8, [x29, #-0xa0]
0x00051830  adrp     x8, #0x8f000
0x00051834  ldrsw    x8, [x8, #0xcc]
0x00051838  ldr      d8, [x0, x8]
0x0005183c  str      x0, [sp, #0x40]
0x00051840  bl       #0x5d1a0   ; CALL objc_msgSend$ss_host
0x00051844  mov      x29, x29
0x00051848  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005184c  str      x0, [sp, #0x48]
0x00051850  movi     v0.16b, #0
0x00051854  stp      q0, q0, [sp, #0x50]
0x00051858  stp      q0, q0, [sp, #0x70]
0x0005185c  adrp     x0, #0x7f000
0x00051860  add      x0, x0, #0xfc0
0x00051864  add      x2, sp, #0x50
0x00051868  add      x3, sp, #0x4b0
0x0005186c  mov      w4, #0x10
0x00051870  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00051874  cbz      x0, #0x51bcc
0x00051878  mov      x21, x0
0x0005187c  mov      x25, #0
0x00051880  ldr      x8, [sp, #0x60]
0x00051884  ldr      x20, [x8]
0x00051888  adrp     x8, #0x74000
0x0005188c  ldr      x8, [x8, #0x698]   ; @GOT _kCAMediaTimingFunctionEaseInEaseOut
0x00051890  ldr      x22, [x8]   ; @GOT ___objc_personality_v0
0x00051894  adrp     x8, #0x65000
0x00051898  ldr      d9, [x8, #0x688]
0x0005189c  adrp     x8, #0x65000
0x000518a0  adrp     x23, #0x8e000
0x000518a4  mov      x10, #-0x3fb2000000000000
0x000518a8  mov      x9, #0x404e000000000000
0x000518ac  stp      x9, x10, [sp, #0x30]
0x000518b0  ldr      d0, [x8, #0x6d0]
0x000518b4  str      d0, [sp, #0x28]
0x000518b8  mov      x9, #-0x3fbc000000000000
0x000518bc  mov      x8, #0x4044000000000000
0x000518c0  stp      x8, x9, [sp, #0x18]
0x000518c4  mov      w8, #0x7f800000
0x000518c8  str      w8, [sp, #0x10]
0x000518cc  mov      x24, #0
0x000518d0  ldr      x8, [sp, #0x60]
0x000518d4  ldr      x8, [x8]   ; @CSTR "m.fill"
0x000518d8  cmp      x8, x20
0x000518dc  b.eq     #0x518ec
0x000518e0  adrp     x0, #0x7f000
0x000518e4  add      x0, x0, #0xfc0
0x000518e8  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x000518ec  ldr      x8, [sp, #0x58]
0x000518f0  ldr      x27, [x8, x24, lsl #3]
0x000518f4  mov      x0, x27
0x000518f8  mov      x2, #0
0x000518fc  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00051900  mov      x29, x29
0x00051904  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051908  mov      x28, x0
0x0005190c  bl       #0x5dca0   ; CALL objc_msgSend$unsignedIntValue
0x00051910  mov      x26, x0
0x00051914  mov      x0, x28
0x00051918  bl       #0x55d78   ; CALL _objc_release
0x0005191c  adrp     x8, #0x8f000
0x00051920  ldrsw    x8, [x8, #0xd0]
0x00051924  ldr      x19, [sp, #0x40]
0x00051928  ldr      d10, [x19, x8]
0x0005192c  mov      x0, x27
0x00051930  mov      w2, #1
0x00051934  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00051938  mov      x29, x29
0x0005193c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051940  mov      x28, x0
0x00051944  bl       #0x57880   ; CALL objc_msgSend$doubleValue
0x00051948  fmadd    d10, d0, d8, d10
0x0005194c  adrp     x8, #0x8f000
0x00051950  ldrsw    x8, [x8, #0xd4]
0x00051954  ldr      d11, [x19, x8]
0x00051958  mov      x0, x27
0x0005195c  mov      w2, #2
0x00051960  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00051964  mov      x29, x29
0x00051968  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005196c  mov      x19, x0
0x00051970  bl       #0x57880   ; CALL objc_msgSend$doubleValue
0x00051974  fmadd    d11, d0, d8, d11
0x00051978  mov      x0, x19
0x0005197c  bl       #0x55d78   ; CALL _objc_release
0x00051980  mov      x0, x28
0x00051984  bl       #0x55d78   ; CALL _objc_release
0x00051988  mov      x0, x27
0x0005198c  mov      w2, #3
0x00051990  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00051994  mov      x29, x29
0x00051998  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005199c  mov      x27, x0
0x000519a0  bl       #0x57880   ; CALL objc_msgSend$doubleValue
0x000519a4  fmul     d12, d8, d0
0x000519a8  adrp     x28, #0x8e000
0x000519ac  ldr      x0, [x28, #0x910]   ; @CLASS UIColor
0x000519b0  ubfx     w8, w26, #0x10, #8
0x000519b4  ucvtf    d0, w8
0x000519b8  ubfx     w8, w26, #8, #8
0x000519bc  ucvtf    d1, w8
0x000519c0  fdiv     d13, d0, d9
0x000519c4  fdiv     d14, d1, d9
0x000519c8  and      w8, w26, #0xff
0x000519cc  ucvtf    d0, w8
0x000519d0  fdiv     d15, d0, d9
0x000519d4  mov      v0.16b, v13.16b
0x000519d8  mov      v1.16b, v14.16b
0x000519dc  mov      v2.16b, v15.16b
0x000519e0  ldr      d3, [sp, #0x28]
0x000519e4  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000519e8  mov      x29, x29
0x000519ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000519f0  mov      x19, x0
0x000519f4  ldr      x0, [x28, #0x910]   ; @CLASS UIColor
0x000519f8  fmov     d3, xzr
0x000519fc  mov      v0.16b, v13.16b
0x00051a00  mov      v1.16b, v14.16b
0x00051a04  mov      v2.16b, v15.16b
0x00051a08  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00051a0c  mov      x29, x29
0x00051a10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051a14  mov      x28, x0
0x00051a18  mov      v0.16b, v10.16b
0x00051a1c  mov      v1.16b, v11.16b
0x00051a20  mov      v2.16b, v12.16b
0x00051a24  mov      x0, x19
0x00051a28  mov      x1, x28
0x00051a2c  bl       #0x4c190
0x00051a30  mov      x29, x29
0x00051a34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051a38  mov      x26, x0
0x00051a3c  mov      x0, x28
0x00051a40  bl       #0x55d78   ; CALL _objc_release
0x00051a44  mov      x0, x19
0x00051a48  bl       #0x55d78   ; CALL _objc_release
0x00051a4c  mov      x0, x27
0x00051a50  bl       #0x55d78   ; CALL _objc_release
0x00051a54  ldr      x0, [sp, #0x48]
0x00051a58  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00051a5c  mov      x29, x29
0x00051a60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051a64  mov      x19, x0
0x00051a68  mov      x2, x26
0x00051a6c  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x00051a70  mov      x0, x19
0x00051a74  bl       #0x55d78   ; CALL _objc_release
0x00051a78  adrp     x8, #0x8e000
0x00051a7c  ldr      x0, [x8, #0xbd8]   ; @CLASS CABasicAnimation
0x00051a80  adrp     x2, #0x7d000
0x00051a84  add      x2, x2, #0xb08   ; STR "position"
0x00051a88  bl       #0x563a0   ; CALL objc_msgSend$animationWithKeyPath:
0x00051a8c  mov      x29, x29
0x00051a90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051a94  mov      x27, x0
0x00051a98  ldr      x0, [x23, #0xc40]   ; @CLASS NSValue
0x00051a9c  mov      v0.16b, v10.16b
0x00051aa0  mov      v1.16b, v11.16b
0x00051aa4  bl       #0x5dec0   ; CALL objc_msgSend$valueWithCGPoint:
0x00051aa8  mov      x29, x29
0x00051aac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051ab0  mov      x19, x0
0x00051ab4  mov      x0, x27
0x00051ab8  mov      x2, x19
0x00051abc  bl       #0x5aee0   ; CALL objc_msgSend$setFromValue:
0x00051ac0  mov      x0, x19
0x00051ac4  bl       #0x55d78   ; CALL _objc_release
0x00051ac8  ldr      x0, [x23, #0xc40]   ; @CLASS NSValue
0x00051acc  tst      x25, #1
0x00051ad0  ldp      d1, d0, [sp, #0x30]
0x00051ad4  fcsel    d0, d1, d0, eq
0x00051ad8  fmadd    d0, d0, d8, d10
0x00051adc  cmp      x25, #2
0x00051ae0  ldp      d2, d1, [sp, #0x18]
0x00051ae4  fcsel    d1, d2, d1, lt
0x00051ae8  fmadd    d1, d1, d8, d11
0x00051aec  bl       #0x5dec0   ; CALL objc_msgSend$valueWithCGPoint:
0x00051af0  mov      x29, x29
0x00051af4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051af8  mov      x19, x0
0x00051afc  mov      x0, x27
0x00051b00  mov      x2, x19
0x00051b04  bl       #0x5c660   ; CALL objc_msgSend$setToValue:
0x00051b08  mov      x0, x19
0x00051b0c  bl       #0x55d78   ; CALL _objc_release
0x00051b10  fmov     d0, #14.00000000
0x00051b14  mov      x0, x27
0x00051b18  bl       #0x5ad40   ; CALL objc_msgSend$setDuration:
0x00051b1c  mov      x0, x27
0x00051b20  mov      w2, #1
0x00051b24  bl       #0x5a520   ; CALL objc_msgSend$setAutoreverses:
0x00051b28  mov      x0, x27
0x00051b2c  ldr      s0, [sp, #0x10]
0x00051b30  bl       #0x5bdc0   ; CALL objc_msgSend$setRepeatCount:
0x00051b34  scvtf    d0, x25
0x00051b38  fmov     d1, #3.50000000
0x00051b3c  fmul     d0, d0, d1
0x00051b40  mov      x0, x27
0x00051b44  bl       #0x5c540   ; CALL objc_msgSend$setTimeOffset:
0x00051b48  adrp     x8, #0x8e000
0x00051b4c  ldr      x0, [x8, #0xbe0]   ; @CLASS CAMediaTimingFunction
0x00051b50  mov      x2, x22
0x00051b54  bl       #0x57d60   ; CALL objc_msgSend$functionWithName:
0x00051b58  mov      x29, x29
0x00051b5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051b60  mov      x19, x0
0x00051b64  mov      x0, x27
0x00051b68  mov      x2, x19
0x00051b6c  bl       #0x5c5a0   ; CALL objc_msgSend$setTimingFunction:
0x00051b70  mov      x0, x19
0x00051b74  bl       #0x55d78   ; CALL _objc_release
0x00051b78  mov      x0, x26
0x00051b7c  mov      x2, x27
0x00051b80  adrp     x3, #0x7d000
0x00051b84  add      x3, x3, #0xb28   ; STR "ssDrift"
0x00051b88  bl       #0x56020   ; CALL objc_msgSend$addAnimation:forKey:
0x00051b8c  add      x25, x25, #1
0x00051b90  mov      x0, x27
0x00051b94  bl       #0x55d78   ; CALL _objc_release
0x00051b98  mov      x0, x26
0x00051b9c  bl       #0x55d78   ; CALL _objc_release
0x00051ba0  add      x24, x24, #1
0x00051ba4  cmp      x21, x24
0x00051ba8  b.ne     #0x518d0
0x00051bac  add      x2, sp, #0x50
0x00051bb0  add      x3, sp, #0x4b0
0x00051bb4  adrp     x0, #0x7f000
0x00051bb8  add      x0, x0, #0xfc0
0x00051bbc  mov      w4, #0x10
0x00051bc0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00051bc4  mov      x21, x0
0x00051bc8  cbnz     x0, #0x518cc
0x00051bcc  adrp     x19, #0x8e000
0x00051bd0  ldr      x22, [x19, #0xa78]   ; @CLASS UIImage
0x00051bd4  adrp     x0, #0x7d000
0x00051bd8  add      x0, x0, #0xb48   ; STR "/Library/PreferenceBundles/OmniCarPrefs.bundle/PackageIcon.png"
0x00051bdc  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00051be0  add      x1, sp, #0xb0
0x00051be4  bl       #0x4118
0x00051be8  cbz      x0, #0x51c0c
0x00051bec  mov      x2, x0
0x00051bf0  adrp     x8, #0x8e000
0x00051bf4  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00051bf8  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00051bfc  mov      x29, x29
0x00051c00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051c04  mov      x21, x0
0x00051c08  b        #0x51c10
0x00051c0c  mov      x21, #0
0x00051c10  mov      x0, x22
0x00051c14  mov      x2, x21
0x00051c18  bl       #0x581c0   ; CALL objc_msgSend$imageWithContentsOfFile:
0x00051c1c  mov      x29, x29
0x00051c20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051c24  mov      x22, x0
0x00051c28  cbz      x0, #0x51c3c
0x00051c2c  mov      x0, x22
0x00051c30  bl       #0x55d84   ; CALL _objc_retain
0x00051c34  mov      x19, x22
0x00051c38  b        #0x51c9c
0x00051c3c  ldr      x23, [x19, #0xa78]   ; @CLASS UIImage
0x00051c40  adrp     x0, #0x7d000
0x00051c44  add      x0, x0, #0xb68   ; STR "/Library/PreferenceBundles/OmniCarPrefs.bundle/logo@3x.png"
0x00051c48  bl       #0x57b80   ; CALL objc_msgSend$fileSystemRepresentation
0x00051c4c  add      x1, sp, #0xb0
0x00051c50  bl       #0x4118
0x00051c54  cbz      x0, #0x51c78
0x00051c58  mov      x2, x0
0x00051c5c  adrp     x8, #0x8e000
0x00051c60  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00051c64  bl       #0x5d5a0   ; CALL objc_msgSend$stringWithUTF8String:
0x00051c68  mov      x29, x29
0x00051c6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051c70  mov      x24, x0
0x00051c74  b        #0x51c7c
0x00051c78  mov      x24, #0
0x00051c7c  mov      x0, x23
0x00051c80  mov      x2, x24
0x00051c84  bl       #0x581c0   ; CALL objc_msgSend$imageWithContentsOfFile:
0x00051c88  mov      x29, x29
0x00051c8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051c90  mov      x19, x0
0x00051c94  mov      x0, x24
0x00051c98  bl       #0x55d78   ; CALL _objc_release
0x00051c9c  str      x19, [sp, #0x38]
0x00051ca0  mov      x0, x22
0x00051ca4  bl       #0x55d78   ; CALL _objc_release
0x00051ca8  mov      x0, x21
0x00051cac  bl       #0x55d78   ; CALL _objc_release
0x00051cb0  adrp     x8, #0x65000
0x00051cb4  ldr      d10, [x8, #0x638]
0x00051cb8  fmul     d9, d8, d10
0x00051cbc  adrp     x8, #0x8e000
0x00051cc0  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x00051cc4  bl       #0x55c7c   ; CALL _objc_alloc
0x00051cc8  mov      x2, x19
0x00051ccc  bl       #0x584c0   ; CALL objc_msgSend$initWithImage:
0x00051cd0  mov      x22, x0
0x00051cd4  mov      w2, #1
0x00051cd8  bl       #0x5aa40   ; CALL objc_msgSend$setContentMode:
0x00051cdc  fmov     d0, xzr
0x00051ce0  fmov     d1, xzr
0x00051ce4  mov      x0, x22
0x00051ce8  mov      v2.16b, v9.16b
0x00051cec  mov      v3.16b, v9.16b
0x00051cf0  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x00051cf4  adrp     x8, #0x8f000
0x00051cf8  ldrsw    x26, [x8, #0xd0]
0x00051cfc  ldr      x20, [sp, #0x40]
0x00051d00  ldr      d0, [x20, x26]
0x00051d04  adrp     x8, #0x65000
0x00051d08  ldr      d1, [x8, #0xe98]
0x00051d0c  fmadd    d0, d8, d1, d0
0x00051d10  adrp     x8, #0x8f000
0x00051d14  ldrsw    x27, [x8, #0xd4]
0x00051d18  ldr      d1, [x20, x27]
0x00051d1c  str      x27, [sp]
0x00051d20  fmadd    d1, d8, d10, d1
0x00051d24  mov      x0, x22
0x00051d28  bl       #0x5a840   ; CALL objc_msgSend$setCenter:
0x00051d2c  adrp     x28, #0x8e000
0x00051d30  ldr      x0, [x28, #0x910]   ; @CLASS UIColor
0x00051d34  adrp     x8, #0x65000
0x00051d38  ldr      d0, [x8, #0xac0]
0x00051d3c  str      d0, [sp, #0x28]
0x00051d40  adrp     x8, #0x65000
0x00051d44  ldr      d1, [x8, #0xb20]
0x00051d48  adrp     x8, #0x66000
0x00051d4c  ldr      d2, [x8, #0x120]
0x00051d50  fmov     d3, #1.00000000
0x00051d54  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00051d58  mov      x29, x29
0x00051d5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051d60  mov      x19, x0
0x00051d64  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00051d68  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00051d6c  mov      x21, x0
0x00051d70  mov      x0, x22
0x00051d74  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00051d78  mov      x29, x29
0x00051d7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051d80  mov      x23, x0
0x00051d84  mov      x2, x21
0x00051d88  bl       #0x5bfc0   ; CALL objc_msgSend$setShadowColor:
0x00051d8c  mov      x0, x23
0x00051d90  bl       #0x55d78   ; CALL _objc_release
0x00051d94  mov      x0, x19
0x00051d98  bl       #0x55d78   ; CALL _objc_release
0x00051d9c  mov      x0, x22
0x00051da0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00051da4  mov      x29, x29
0x00051da8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051dac  mov      x19, x0
0x00051db0  adrp     x8, #0x65000
0x00051db4  ldr      s0, [x8, #0xd08]
0x00051db8  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x00051dbc  mov      x0, x19
0x00051dc0  bl       #0x55d78   ; CALL _objc_release
0x00051dc4  fmov     d0, #26.00000000
0x00051dc8  fmul     d9, d8, d0
0x00051dcc  mov      x0, x22
0x00051dd0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00051dd4  mov      x29, x29
0x00051dd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051ddc  mov      x19, x0
0x00051de0  mov      v0.16b, v9.16b
0x00051de4  bl       #0x5c040   ; CALL objc_msgSend$setShadowRadius:
0x00051de8  mov      x0, x19
0x00051dec  bl       #0x55d78   ; CALL _objc_release
0x00051df0  fmov     d0, #14.00000000
0x00051df4  fmul     d9, d8, d0
0x00051df8  mov      x0, x22
0x00051dfc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00051e00  mov      x29, x29
0x00051e04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051e08  mov      x19, x0
0x00051e0c  fmov     d0, xzr
0x00051e10  mov      v1.16b, v9.16b
0x00051e14  bl       #0x5bfe0   ; CALL objc_msgSend$setShadowOffset:
0x00051e18  mov      x0, x19
0x00051e1c  bl       #0x55d78   ; CALL _objc_release
0x00051e20  ldr      x0, [sp, #0x48]
0x00051e24  mov      x2, x22
0x00051e28  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00051e2c  adrp     x8, #0x65000
0x00051e30  ldr      d10, [x8, #0x748]
0x00051e34  adrp     x8, #0x65000
0x00051e38  ldr      d1, [x8, #0x708]
0x00051e3c  fmov     d2, #1.00000000
0x00051e40  mov      x0, x20
0x00051e44  mov      x2, x22
0x00051e48  mov      v0.16b, v10.16b
0x00051e4c  bl       #0x5d160   ; CALL objc_msgSend$ss_fade:from:to:alpha:
0x00051e50  mov      x29, x29
0x00051e54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051e58  str      x0, [sp, #0x30]
0x00051e5c  mov      x8, #0x4044000000000000
0x00051e60  fmov     d11, x8
0x00051e64  fmul     d0, d8, d11
0x00051e68  bl       #0x5be80   ; CALL objc_msgSend$setRise:
0x00051e6c  adrp     x8, #0x8e000
0x00051e70  ldr      x0, [x8, #0xbd8]   ; @CLASS CABasicAnimation
0x00051e74  adrp     x2, #0x7d000
0x00051e78  add      x2, x2, #0xb88   ; STR "transform.translation.y"
0x00051e7c  bl       #0x563a0   ; CALL objc_msgSend$animationWithKeyPath:
0x00051e80  mov      x29, x29
0x00051e84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051e88  mov      x24, x0
0x00051e8c  adrp     x21, #0x8e000
0x00051e90  ldr      x0, [x21, #0x928]   ; @CLASS NSNumber
0x00051e94  fmov     d0, #4.00000000
0x00051e98  fmul     d0, d8, d0
0x00051e9c  bl       #0x592e0   ; CALL objc_msgSend$numberWithDouble:
0x00051ea0  mov      x29, x29
0x00051ea4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051ea8  mov      x19, x0
0x00051eac  mov      x0, x24
0x00051eb0  mov      x2, x19
0x00051eb4  bl       #0x5aee0   ; CALL objc_msgSend$setFromValue:
0x00051eb8  mov      x0, x19
0x00051ebc  bl       #0x55d78   ; CALL _objc_release
0x00051ec0  ldr      x0, [x21, #0x928]   ; @CLASS NSNumber
0x00051ec4  fmov     d0, #-4.00000000
0x00051ec8  fmul     d0, d8, d0
0x00051ecc  bl       #0x592e0   ; CALL objc_msgSend$numberWithDouble:
0x00051ed0  mov      x29, x29
0x00051ed4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051ed8  mov      x19, x0
0x00051edc  mov      x0, x24
0x00051ee0  mov      x2, x19
0x00051ee4  bl       #0x5c660   ; CALL objc_msgSend$setToValue:
0x00051ee8  mov      x0, x19
0x00051eec  bl       #0x55d78   ; CALL _objc_release
0x00051ef0  adrp     x8, #0x66000
0x00051ef4  ldr      d0, [x8, #0x190]
0x00051ef8  mov      x0, x24
0x00051efc  bl       #0x5ad40   ; CALL objc_msgSend$setDuration:
0x00051f00  mov      x0, x24
0x00051f04  mov      w2, #1
0x00051f08  bl       #0x5a520   ; CALL objc_msgSend$setAutoreverses:
0x00051f0c  mov      w8, #0x7f800000
0x00051f10  fmov     s9, w8
0x00051f14  mov      x0, x24
0x00051f18  mov      v0.16b, v9.16b
0x00051f1c  bl       #0x5bdc0   ; CALL objc_msgSend$setRepeatCount:
0x00051f20  mov      x0, x24
0x00051f24  mov      w2, #1
0x00051f28  bl       #0x5a340   ; CALL objc_msgSend$setAdditive:
0x00051f2c  adrp     x8, #0x8e000
0x00051f30  ldr      x0, [x8, #0xbe0]   ; @CLASS CAMediaTimingFunction
0x00051f34  adrp     x8, #0x74000
0x00051f38  ldr      x8, [x8, #0x698]   ; @GOT _kCAMediaTimingFunctionEaseInEaseOut
0x00051f3c  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x00051f40  bl       #0x57d60   ; CALL objc_msgSend$functionWithName:
0x00051f44  mov      x29, x29
0x00051f48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051f4c  mov      x19, x0
0x00051f50  mov      x0, x24
0x00051f54  mov      x2, x19
0x00051f58  bl       #0x5c5a0   ; CALL objc_msgSend$setTimingFunction:
0x00051f5c  mov      x0, x19
0x00051f60  bl       #0x55d78   ; CALL _objc_release
0x00051f64  mov      x0, x22
0x00051f68  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00051f6c  mov      x29, x29
0x00051f70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051f74  mov      x19, x0
0x00051f78  adrp     x3, #0x7d000
0x00051f7c  add      x3, x3, #0xba8   ; STR "ssBreathe"
0x00051f80  mov      x2, x24
0x00051f84  bl       #0x56020   ; CALL objc_msgSend$addAnimation:forKey:
0x00051f88  mov      x0, x19
0x00051f8c  bl       #0x55d78   ; CALL _objc_release
0x00051f90  adrp     x0, #0x75000
0x00051f94  add      x0, x0, #0x508   ; STR "OmniCar"
0x00051f98  bl       #0x47664
0x00051f9c  mov      x29, x29
0x00051fa0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051fa4  mov      x25, x0
0x00051fa8  adrp     x8, #0x65000
0x00051fac  ldr      d0, [x8, #0xf68]
0x00051fb0  fmul     d0, d8, d0
0x00051fb4  adrp     x8, #0x74000
0x00051fb8  ldr      x8, [x8, #0x240]   ; @GOT _UIFontWeightHeavy
0x00051fbc  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x00051fc0  bl       #0x492e8
0x00051fc4  mov      x29, x29
0x00051fc8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051fcc  mov      x19, x0
0x00051fd0  mov      x0, x25
0x00051fd4  mov      x2, x19
0x00051fd8  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00051fdc  mov      x0, x19
0x00051fe0  bl       #0x55d78   ; CALL _objc_release
0x00051fe4  mov      x21, x28
0x00051fe8  ldr      x0, [x28, #0x910]   ; @CLASS UIColor
0x00051fec  bl       #0x56940   ; CALL objc_msgSend$blackColor
0x00051ff0  mov      x29, x29
0x00051ff4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00051ff8  mov      x19, x0
0x00051ffc  mov      x0, x25
0x00052000  mov      x2, x19
0x00052004  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00052008  mov      x0, x19
0x0005200c  bl       #0x55d78   ; CALL _objc_release
0x00052010  mov      x8, #0x7fefffffffffffff
0x00052014  fmov     d0, x8
0x00052018  mov      x0, x25
0x0005201c  mov      v1.16b, v0.16b
0x00052020  bl       #0x5cbc0   ; CALL objc_msgSend$sizeThatFits:
0x00052024  mov      v12.16b, v0.16b
0x00052028  mov      v13.16b, v1.16b
0x0005202c  adrp     x8, #0x8e000
0x00052030  ldr      x0, [x8, #0x918]   ; @CLASS UIView
0x00052034  bl       #0x55c7c   ; CALL _objc_alloc
0x00052038  ldr      d0, [x20, x26]
0x0005203c  mov      x28, x26
0x00052040  adrp     x8, #0x66000
0x00052044  ldr      d1, [x8, #0x198]
0x00052048  ldr      d2, [x20, x27]
0x0005204c  fmadd    d0, d8, d1, d0
0x00052050  adrp     x8, #0x66000
0x00052054  ldr      d1, [x8, #0x1a0]
0x00052058  fmadd    d1, d8, d1, d2
0x0005205c  frintp   d2, d12
0x00052060  frintp   d3, d13
0x00052064  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x00052068  mov      x26, x0
0x0005206c  adrp     x8, #0x8e000
0x00052070  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x00052074  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00052078  mov      x29, x29
0x0005207c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052080  mov      x27, x0
0x00052084  mov      x0, x26
0x00052088  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0005208c  mov      x0, x27
0x00052090  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00052094  mov      x19, x21
0x00052098  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x0005209c  adrp     x8, #0x66000
0x000520a0  ldr      d0, [x8, #0x1a8]
0x000520a4  adrp     x8, #0x65000
0x000520a8  ldr      d1, [x8, #0xff0]
0x000520ac  adrp     x8, #0x65000
0x000520b0  ldr      d2, [x8, #0xb58]
0x000520b4  fmov     d3, #1.00000000
0x000520b8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000520bc  mov      x29, x29
0x000520c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000520c4  mov      x21, x0
0x000520c8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000520cc  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000520d0  str      x0, [sp, #0xa0]
0x000520d4  ldr      x0, [x19, #0x910]   ; @CLASS UIColor
0x000520d8  adrp     x8, #0x66000
0x000520dc  ldr      d0, [x8, #0x1b0]
0x000520e0  adrp     x8, #0x66000
0x000520e4  ldr      d1, [x8, #0x1b8]
0x000520e8  adrp     x8, #0x65000
0x000520ec  ldr      d2, [x8, #0xa68]
0x000520f0  fmov     d3, #1.00000000
0x000520f4  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000520f8  mov      x29, x29
0x000520fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052100  mov      x19, x0
0x00052104  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00052108  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0005210c  str      x0, [sp, #0xa8]
0x00052110  adrp     x8, #0x8e000
0x00052114  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00052118  add      x2, sp, #0xa0
0x0005211c  mov      w3, #2
0x00052120  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00052124  mov      x29, x29
0x00052128  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005212c  mov      x23, x0
0x00052130  mov      x0, x27
0x00052134  mov      x2, x23
0x00052138  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0005213c  mov      x0, x23
0x00052140  bl       #0x55d78   ; CALL _objc_release
0x00052144  mov      x0, x19
0x00052148  bl       #0x55d78   ; CALL _objc_release
0x0005214c  mov      x0, x21
0x00052150  bl       #0x55d78   ; CALL _objc_release
0x00052154  fmov     d0, xzr
0x00052158  fmov     d1, #0.50000000
0x0005215c  mov      x0, x27
0x00052160  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x00052164  fmov     d0, #1.00000000
0x00052168  fmov     d1, #0.50000000
0x0005216c  mov      x0, x27
0x00052170  str      x27, [sp, #0x10]
0x00052174  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x00052178  mov      x0, x26
0x0005217c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00052180  mov      x29, x29
0x00052184  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052188  mov      x19, x0
0x0005218c  mov      x2, x27
0x00052190  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x00052194  mov      x0, x19
0x00052198  bl       #0x55d78   ; CALL _objc_release
0x0005219c  mov      x0, x26
0x000521a0  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x000521a4  str      x25, [sp, #0x20]
0x000521a8  mov      x0, x25
0x000521ac  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x000521b0  mov      x0, x26
0x000521b4  mov      x2, x25
0x000521b8  bl       #0x5b4e0   ; CALL objc_msgSend$setMaskView:
0x000521bc  ldr      x25, [sp, #0x48]
0x000521c0  mov      x0, x25
0x000521c4  mov      x2, x26
0x000521c8  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x000521cc  adrp     x8, #0x65000
0x000521d0  ldr      d0, [x8, #0x6c0]
0x000521d4  adrp     x8, #0x65000
0x000521d8  ldr      d1, [x8, #0xe80]
0x000521dc  fmov     d2, #1.00000000
0x000521e0  mov      x0, x20
0x000521e4  mov      x2, x26
0x000521e8  bl       #0x5d160   ; CALL objc_msgSend$ss_fade:from:to:alpha:
0x000521ec  mov      x29, x29
0x000521f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000521f4  str      x0, [sp, #0x18]
0x000521f8  fmov     d0, #30.00000000
0x000521fc  fmul     d12, d8, d0
0x00052200  mov      v0.16b, v12.16b
0x00052204  bl       #0x5be80   ; CALL objc_msgSend$setRise:
0x00052208  adrp     x0, #0x7d000
0x0005220c  add      x0, x0, #0xbc8   ; STR "Sức mạnh của CarPlay"
0x00052210  adrp     x1, #0x7d000
0x00052214  add      x1, x1, #0xbe8   ; STR "The power of CarPlay"
0x00052218  bl       #0x5505c   ; CALL _OMCTr
0x0005221c  mov      x29, x29
0x00052220  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052224  mov      x19, x0
0x00052228  mov      x21, x28
0x0005222c  ldr      d0, [x20, x28]
0x00052230  adrp     x8, #0x66000
0x00052234  ldr      d1, [x8, #0x1c0]
0x00052238  fmadd    d13, d8, d1, d0
0x0005223c  ldr      x28, [sp]
0x00052240  ldr      d0, [x20, x28]
0x00052244  adrp     x8, #0x66000
0x00052248  ldr      d1, [x8, #0x1c8]
0x0005224c  fmadd    d14, d8, d1, d0
0x00052250  adrp     x8, #0x74000
0x00052254  ldr      x8, [x8, #0x250]   ; @GOT _UIFontWeightMedium
0x00052258  ldr      d15, [x8]   ; @GOT ___objc_personality_v0
0x0005225c  adrp     x8, #0x8e000
0x00052260  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00052264  adrp     x8, #0x66000
0x00052268  ldr      d0, [x8, #0x1d0]
0x0005226c  adrp     x8, #0x66000
0x00052270  ldr      d1, [x8, #0x1d8]
0x00052274  adrp     x8, #0x66000
0x00052278  ldr      d2, [x8, #0x1e0]
0x0005227c  fmov     d3, #1.00000000
0x00052280  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00052284  mov      x29, x29
0x00052288  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005228c  mov      x23, x0
0x00052290  adrp     x8, #0x66000
0x00052294  ldr      d0, [x8, #0x158]
0x00052298  fmul     d4, d8, d0
0x0005229c  mov      x0, x20
0x000522a0  mov      x2, x19
0x000522a4  mov      v0.16b, v13.16b
0x000522a8  mov      v1.16b, v14.16b
0x000522ac  mov      v2.16b, v11.16b
0x000522b0  mov      v3.16b, v15.16b
0x000522b4  mov      x3, x23
0x000522b8  mov      w4, #1
0x000522bc  mov      x5, x25
0x000522c0  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x000522c4  mov      x29, x29
0x000522c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000522cc  mov      x27, x0
0x000522d0  mov      x0, x23
0x000522d4  bl       #0x55d78   ; CALL _objc_release
0x000522d8  mov      x0, x19
0x000522dc  bl       #0x55d78   ; CALL _objc_release
0x000522e0  str      x27, [sp, #8]
0x000522e4  mov      x0, x27
0x000522e8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000522ec  mov      x29, x29
0x000522f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000522f4  mov      x19, x0
0x000522f8  fmov     s0, wzr
0x000522fc  bl       #0x5c000   ; CALL objc_msgSend$setShadowOpacity:
0x00052300  mov      x0, x19
0x00052304  bl       #0x55d78   ; CALL _objc_release
0x00052308  adrp     x8, #0x65000
0x0005230c  ldr      d0, [x8, #0x700]
0x00052310  adrp     x8, #0x65000
0x00052314  ldr      d1, [x8, #0xeb8]
0x00052318  fmov     d2, #1.00000000
0x0005231c  mov      x0, x20
0x00052320  mov      x2, x27
0x00052324  bl       #0x5d160   ; CALL objc_msgSend$ss_fade:from:to:alpha:
0x00052328  mov      x29, x29
0x0005232c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052330  mov      x27, x0
0x00052334  mov      v0.16b, v12.16b
0x00052338  bl       #0x5be80   ; CALL objc_msgSend$setRise:
0x0005233c  mov      x8, #0x406e000000000000
0x00052340  fmov     d0, x8
0x00052344  fmul     d11, d8, d0
0x00052348  fmov     d0, #8.00000000
0x0005234c  fmul     d0, d8, d0
0x00052350  fmov     d1, #2.00000000
0x00052354  fmaxnm   d12, d0, d1
0x00052358  adrp     x8, #0x8e000
0x0005235c  ldr      x0, [x8, #0x918]   ; @CLASS UIView
0x00052360  bl       #0x55c7c   ; CALL _objc_alloc
0x00052364  ldr      d0, [x20, x21]
0x00052368  adrp     x8, #0x66000
0x0005236c  ldr      d1, [x8, #0x1e8]
0x00052370  fmadd    d0, d8, d1, d0
0x00052374  ldr      d1, [x20, x28]
0x00052378  adrp     x8, #0x66000
0x0005237c  ldr      d2, [x8, #0x1f0]
0x00052380  fmadd    d1, d8, d2, d1
0x00052384  mov      v2.16b, v11.16b
0x00052388  mov      v3.16b, v12.16b
0x0005238c  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x00052390  mov      x28, x0
0x00052394  adrp     x21, #0x8e000
0x00052398  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x0005239c  adrp     x8, #0x65000
0x000523a0  ldr      d0, [x8, #0x9c8]
0x000523a4  adrp     x8, #0x65000
0x000523a8  ldr      d1, [x8, #0x9d0]
0x000523ac  adrp     x8, #0x65000
0x000523b0  ldr      d2, [x8, #0x728]
0x000523b4  mov      v3.16b, v10.16b
0x000523b8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000523bc  mov      x29, x29
0x000523c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000523c4  mov      x19, x0
0x000523c8  mov      x0, x28
0x000523cc  mov      x2, x19
0x000523d0  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x000523d4  mov      x0, x19
0x000523d8  bl       #0x55d78   ; CALL _objc_release
0x000523dc  fmov     d0, #0.50000000
0x000523e0  fmul     d10, d12, d0
0x000523e4  mov      x0, x28
0x000523e8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000523ec  mov      x29, x29
0x000523f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000523f4  mov      x19, x0
0x000523f8  mov      v0.16b, v10.16b
0x000523fc  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x00052400  mov      x0, x19
0x00052404  bl       #0x55d78   ; CALL _objc_release
0x00052408  mov      x0, x28
0x0005240c  mov      w2, #1
0x00052410  bl       #0x5a8a0   ; CALL objc_msgSend$setClipsToBounds:
0x00052414  mov      x0, x25
0x00052418  mov      x2, x28
0x0005241c  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00052420  adrp     x8, #0x8e000
0x00052424  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x00052428  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0005242c  mov      x29, x29
0x00052430  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052434  mov      x23, x0
0x00052438  adrp     x8, #0x65000
0x0005243c  ldr      d0, [x8, #0x780]
0x00052440  fmul     d2, d11, d0
0x00052444  fmov     d0, xzr
0x00052448  fmov     d1, xzr
0x0005244c  mov      v3.16b, v12.16b
0x00052450  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00052454  mov      x0, x23
0x00052458  mov      v0.16b, v10.16b
0x0005245c  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x00052460  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00052464  adrp     x8, #0x65000
0x00052468  ldr      d0, [x8, #0x7a8]
0x0005246c  adrp     x8, #0x65000
0x00052470  ldr      d1, [x8, #0xa90]
0x00052474  fmov     d2, #1.00000000
0x00052478  fmov     d3, #1.00000000
0x0005247c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00052480  mov      x29, x29
0x00052484  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052488  mov      x25, x0
0x0005248c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00052490  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00052494  str      x0, [sp, #0x90]
0x00052498  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x0005249c  adrp     x8, #0x66000
0x000524a0  ldr      d1, [x8, #0x1f8]
0x000524a4  fmov     d2, #1.00000000
0x000524a8  fmov     d3, #1.00000000
0x000524ac  ldr      d0, [sp, #0x28]
0x000524b0  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000524b4  mov      x29, x29
0x000524b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000524bc  mov      x19, x0
0x000524c0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x000524c4  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x000524c8  str      x0, [sp, #0x98]
0x000524cc  adrp     x8, #0x8e000
0x000524d0  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x000524d4  add      x2, sp, #0x90
0x000524d8  mov      w3, #2
0x000524dc  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x000524e0  mov      x29, x29
0x000524e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000524e8  mov      x21, x0
0x000524ec  mov      x0, x23
0x000524f0  mov      x2, x21
0x000524f4  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x000524f8  mov      x0, x21
0x000524fc  bl       #0x55d78   ; CALL _objc_release
0x00052500  mov      x0, x19
0x00052504  bl       #0x55d78   ; CALL _objc_release
0x00052508  mov      x0, x25
0x0005250c  bl       #0x55d78   ; CALL _objc_release
0x00052510  fmov     d0, xzr
0x00052514  fmov     d1, #0.50000000
0x00052518  mov      x0, x23
0x0005251c  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x00052520  fmov     d0, #1.00000000
0x00052524  fmov     d1, #0.50000000
0x00052528  mov      x0, x23
0x0005252c  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x00052530  mov      x0, x28
0x00052534  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00052538  mov      x29, x29
0x0005253c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052540  mov      x19, x0
0x00052544  mov      x2, x23
0x00052548  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0005254c  mov      x0, x19
0x00052550  bl       #0x55d78   ; CALL _objc_release
0x00052554  adrp     x8, #0x8e000
0x00052558  ldr      x0, [x8, #0xbd8]   ; @CLASS CABasicAnimation
0x0005255c  adrp     x2, #0x7d000
0x00052560  add      x2, x2, #0xc08   ; STR "transform.translation.x"
0x00052564  bl       #0x563a0   ; CALL objc_msgSend$animationWithKeyPath:
0x00052568  mov      x29, x29
0x0005256c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052570  mov      x25, x0
0x00052574  adrp     x21, #0x8e000
0x00052578  ldr      x0, [x21, #0x928]   ; @CLASS NSNumber
0x0005257c  adrp     x8, #0x66000
0x00052580  ldr      d0, [x8, #0x68]
0x00052584  fmul     d0, d11, d0
0x00052588  bl       #0x592e0   ; CALL objc_msgSend$numberWithDouble:
0x0005258c  mov      x29, x29
0x00052590  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052594  mov      x19, x0
0x00052598  mov      x0, x25
0x0005259c  mov      x2, x19
0x000525a0  bl       #0x5aee0   ; CALL objc_msgSend$setFromValue:
0x000525a4  mov      x0, x19
0x000525a8  bl       #0x55d78   ; CALL _objc_release
0x000525ac  ldr      x0, [x21, #0x928]   ; @CLASS NSNumber
0x000525b0  adrp     x8, #0x65000
0x000525b4  ldr      d0, [x8, #0xcf8]
0x000525b8  fmul     d0, d11, d0
0x000525bc  bl       #0x592e0   ; CALL objc_msgSend$numberWithDouble:
0x000525c0  mov      x29, x29
0x000525c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000525c8  mov      x19, x0
0x000525cc  mov      x0, x25
0x000525d0  mov      x2, x19
0x000525d4  bl       #0x5c660   ; CALL objc_msgSend$setToValue:
0x000525d8  mov      x0, x19
0x000525dc  bl       #0x55d78   ; CALL _objc_release
0x000525e0  adrp     x8, #0x65000
0x000525e4  ldr      d0, [x8, #0x610]
0x000525e8  mov      x0, x25
0x000525ec  bl       #0x5ad40   ; CALL objc_msgSend$setDuration:
0x000525f0  mov      x0, x25
0x000525f4  mov      v0.16b, v9.16b
0x000525f8  bl       #0x5bdc0   ; CALL objc_msgSend$setRepeatCount:
0x000525fc  adrp     x8, #0x8e000
0x00052600  ldr      x0, [x8, #0xbe0]   ; @CLASS CAMediaTimingFunction
0x00052604  adrp     x8, #0x65000
0x00052608  ldr      s0, [x8, #0x680]
0x0005260c  fmov     s1, wzr
0x00052610  fmov     s3, #1.00000000
0x00052614  mov      v2.16b, v0.16b
0x00052618  bl       #0x57d40   ; CALL objc_msgSend$functionWithControlPoints::::
0x0005261c  mov      x29, x29
0x00052620  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052624  mov      x19, x0
0x00052628  mov      x0, x25
0x0005262c  mov      x2, x19
0x00052630  bl       #0x5c5a0   ; CALL objc_msgSend$setTimingFunction:
0x00052634  mov      x0, x19
0x00052638  bl       #0x55d78   ; CALL _objc_release
0x0005263c  adrp     x3, #0x7d000
0x00052640  add      x3, x3, #0xc28   ; STR "ssSweep"
0x00052644  mov      x0, x23
0x00052648  mov      x2, x25
0x0005264c  bl       #0x56020   ; CALL objc_msgSend$addAnimation:forKey:
0x00052650  fmov     d0, #1.00000000
0x00052654  fmov     d1, #1.50000000
0x00052658  fmov     d2, #1.00000000
0x0005265c  mov      x0, x20
0x00052660  mov      x2, x28
0x00052664  bl       #0x5d160   ; CALL objc_msgSend$ss_fade:from:to:alpha:
0x00052668  mov      x29, x29
0x0005266c  bl       #0x55dfc   ; CALL _objc_unsafeClaimAutoreleasedReturnValue
0x00052670  mov      x0, x25
0x00052674  bl       #0x55d78   ; CALL _objc_release
0x00052678  mov      x0, x23
0x0005267c  bl       #0x55d78   ; CALL _objc_release
0x00052680  mov      x0, x28
0x00052684  bl       #0x55d78   ; CALL _objc_release
0x00052688  mov      x0, x27
0x0005268c  bl       #0x55d78   ; CALL _objc_release
0x00052690  ldr      x0, [sp, #8]
0x00052694  bl       #0x55d78   ; CALL _objc_release
0x00052698  ldr      x0, [sp, #0x18]
0x0005269c  bl       #0x55d78   ; CALL _objc_release
0x000526a0  ldr      x0, [sp, #0x10]
0x000526a4  bl       #0x55d78   ; CALL _objc_release
0x000526a8  mov      x0, x26
0x000526ac  bl       #0x55d78   ; CALL _objc_release
0x000526b0  ldr      x0, [sp, #0x20]
0x000526b4  bl       #0x55d78   ; CALL _objc_release
0x000526b8  mov      x0, x24
0x000526bc  bl       #0x55d78   ; CALL _objc_release
0x000526c0  ldr      x0, [sp, #0x30]
0x000526c4  bl       #0x55d78   ; CALL _objc_release
0x000526c8  mov      x0, x22
0x000526cc  bl       #0x55d78   ; CALL _objc_release
0x000526d0  ldr      x0, [sp, #0x38]
0x000526d4  bl       #0x55d78   ; CALL _objc_release
0x000526d8  ldr      x0, [sp, #0x48]
0x000526dc  bl       #0x55d78   ; CALL _objc_release
0x000526e0  ldur     x8, [x29, #-0xa0]
0x000526e4  adrp     x9, #0x74000
0x000526e8  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000526ec  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000526f0  cmp      x9, x8
0x000526f4  b.ne     #0x52728
0x000526f8  add      sp, sp, #0x540
0x000526fc  ldp      x29, x30, [sp, #0x90]
0x00052700  ldp      x20, x19, [sp, #0x80]
0x00052704  ldp      x22, x21, [sp, #0x70]
0x00052708  ldp      x24, x23, [sp, #0x60]
0x0005270c  ldp      x26, x25, [sp, #0x50]
0x00052710  ldp      x28, x27, [sp, #0x40]
0x00052714  ldp      d9, d8, [sp, #0x30]
0x00052718  ldp      d11, d10, [sp, #0x20]
0x0005271c  ldp      d13, d12, [sp, #0x10]
0x00052720  ldp      d15, d14, [sp], #0xa0
0x00052724  ret      
0x00052728  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[SSStartupView ss_buildFestive]  va=0x5272c size=5212 types=v16@0:8
0x0005272c  sub      sp, sp, #0x190
0x00052730  stp      d15, d14, [sp, #0xf0]
0x00052734  stp      d13, d12, [sp, #0x100]
0x00052738  stp      d11, d10, [sp, #0x110]
0x0005273c  stp      d9, d8, [sp, #0x120]
0x00052740  stp      x28, x27, [sp, #0x130]
0x00052744  stp      x26, x25, [sp, #0x140]
0x00052748  stp      x24, x23, [sp, #0x150]
0x0005274c  stp      x22, x21, [sp, #0x160]
0x00052750  stp      x20, x19, [sp, #0x170]
0x00052754  stp      x29, x30, [sp, #0x180]
0x00052758  add      x29, sp, #0x180
0x0005275c  mov      x21, x0
0x00052760  adrp     x8, #0x74000
0x00052764  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00052768  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0005276c  stur     x8, [x29, #-0xa0]
0x00052770  adrp     x8, #0x8f000
0x00052774  ldrsw    x22, [x8, #0xcc]
0x00052778  ldr      d14, [x0, x22]
0x0005277c  adrp     x8, #0x8f000
0x00052780  ldrsw    x8, [x8, #0x54]
0x00052784  add      x8, x0, x8
0x00052788  ldp      d11, d10, [x8]
0x0005278c  bl       #0x593e0   ; CALL objc_msgSend$occasion
0x00052790  mov      x19, x0
0x00052794  mov      x0, x21
0x00052798  bl       #0x590e0   ; CALL objc_msgSend$name
0x0005279c  mov      x29, x29
0x000527a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000527a4  mov      x27, x0
0x000527a8  mov      x0, x21
0x000527ac  bl       #0x5d1a0   ; CALL objc_msgSend$ss_host
0x000527b0  mov      x29, x29
0x000527b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000527b8  mov      x28, x0
0x000527bc  cmp      x19, #2
0x000527c0  stp      d10, d11, [sp, #0x80]
0x000527c4  stp      x19, x27, [sp, #0x10]
0x000527c8  str      x0, [sp, #8]
0x000527cc  str      x22, [sp, #0x78]
0x000527d0  b.le     #0x527f0
0x000527d4  cmp      x19, #3
0x000527d8  b.eq     #0x53180
0x000527dc  cmp      x19, #4
0x000527e0  b.eq     #0x52d24
0x000527e4  cmp      x19, #5
0x000527e8  b.eq     #0x527f8
0x000527ec  b        #0x534e8
0x000527f0  cmp      x19, #1
0x000527f4  b.ne     #0x52a38
0x000527f8  mov      x0, x28
0x000527fc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00052800  mov      x29, x29
0x00052804  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052808  mov      x23, x0
0x0005280c  fmov     d0, #0.50000000
0x00052810  fmul     d8, d11, d0
0x00052814  adrp     x20, #0x8e000
0x00052818  ldr      x0, [x20, #0x910]   ; @CLASS UIColor
0x0005281c  cmp      x19, #1
0x00052820  str      d14, [sp, #0x70]
0x00052824  b.ne     #0x52870
0x00052828  fmul     d9, d10, d0
0x0005282c  adrp     x8, #0x66000
0x00052830  ldr      d10, [x8, #0xe8]
0x00052834  adrp     x8, #0x65000
0x00052838  ldr      d12, [x8, #0x650]
0x0005283c  fmov     d0, #1.00000000
0x00052840  fmov     d3, #0.25000000
0x00052844  mov      v1.16b, v10.16b
0x00052848  mov      v2.16b, v12.16b
0x0005284c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00052850  mov      x29, x29
0x00052854  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052858  mov      x24, x0
0x0005285c  ldr      x0, [x20, #0x910]   ; @CLASS UIColor
0x00052860  fmov     d0, #1.00000000
0x00052864  fmov     d3, xzr
0x00052868  mov      v1.16b, v10.16b
0x0005286c  b        #0x528c8
0x00052870  adrp     x8, #0x65000
0x00052874  ldr      d0, [x8, #0x660]
0x00052878  fmul     d9, d10, d0
0x0005287c  adrp     x8, #0x65000
0x00052880  ldr      d10, [x8, #0x650]
0x00052884  adrp     x8, #0x65000
0x00052888  ldr      d13, [x8, #0xac0]
0x0005288c  adrp     x8, #0x66000
0x00052890  ldr      d12, [x8, #0xe8]
0x00052894  adrp     x8, #0x65000
0x00052898  ldr      d3, [x8, #0x608]
0x0005289c  mov      v0.16b, v10.16b
0x000528a0  mov      v1.16b, v13.16b
0x000528a4  mov      v2.16b, v12.16b
0x000528a8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000528ac  mov      x29, x29
0x000528b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000528b4  mov      x24, x0
0x000528b8  ldr      x0, [x20, #0x910]   ; @CLASS UIColor
0x000528bc  fmov     d3, xzr
0x000528c0  mov      v0.16b, v10.16b
0x000528c4  mov      v1.16b, v13.16b
0x000528c8  mov      v2.16b, v12.16b
0x000528cc  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000528d0  mov      x29, x29
0x000528d4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000528d8  mov      x25, x0
0x000528dc  mov      v0.16b, v8.16b
0x000528e0  mov      v1.16b, v9.16b
0x000528e4  mov      v2.16b, v8.16b
0x000528e8  mov      x0, x24
0x000528ec  mov      x1, x25
0x000528f0  bl       #0x4c190
0x000528f4  mov      x29, x29
0x000528f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000528fc  mov      x26, x0
0x00052900  mov      x0, x23
0x00052904  mov      x2, x26
0x00052908  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0005290c  mov      x0, x26
0x00052910  bl       #0x55d78   ; CALL _objc_release
0x00052914  mov      x0, x25
0x00052918  bl       #0x55d78   ; CALL _objc_release
0x0005291c  mov      x0, x24
0x00052920  bl       #0x55d78   ; CALL _objc_release
0x00052924  mov      x0, x23
0x00052928  bl       #0x55d78   ; CALL _objc_release
0x0005292c  mov      x0, x21
0x00052930  bl       #0x5cec0   ; CALL objc_msgSend$ss_addCanvas
0x00052934  adrp     x8, #0x8e000
0x00052938  ldr      x0, [x8, #0xc10]   ; @CLASS NSMutableData
0x0005293c  mov      w2, #0xe0
0x00052940  bl       #0x57580   ; CALL objc_msgSend$dataWithLength:
0x00052944  mov      x29, x29
0x00052948  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005294c  adrp     x8, #0x8f000
0x00052950  ldrsw    x19, [x8, #0x98]
0x00052954  ldr      x8, [x21, x19]
0x00052958  str      x0, [x21, x19]
0x0005295c  mov      x0, x8
0x00052960  bl       #0x55d78   ; CALL _objc_release
0x00052964  ldr      x0, [x21, x19]
0x00052968  bl       #0x59080   ; CALL objc_msgSend$mutableBytes
0x0005296c  mov      x19, #0
0x00052970  add      x20, x0, #0x10
0x00052974  adrp     x8, #0x65000
0x00052978  ldr      d8, [x8, #0xf10]
0x0005297c  fmov     d10, #0.12500000
0x00052980  adrp     x8, #0x66000
0x00052984  ldr      d12, [x8, #0x200]
0x00052988  adrp     x8, #0x65000
0x0005298c  ldr      d13, [x8, #0x6b8]
0x00052990  adrp     x8, #0x65000
0x00052994  ldr      d14, [x8, #0x608]
0x00052998  adrp     x8, #0x65000
0x0005299c  ldr      d15, [x8, #0x838]
0x000529a0  adrp     x22, #0x66000
0x000529a4  add      x22, x22, #0x3f8
0x000529a8  ldr      d9, [sp, #0x80]
0x000529ac  mov      w0, #0x4241
0x000529b0  movk     w0, #0xf, lsl #16
0x000529b4  bl       #0x55ba4   ; CALL _arc4random_uniform
0x000529b8  ucvtf    d0, w0
0x000529bc  fmov     d1, #0.75000000
0x000529c0  fmul     d0, d0, d1
0x000529c4  fdiv     d0, d0, d8
0x000529c8  fadd     d0, d0, d10
0x000529cc  ldr      d1, [sp, #0x88]
0x000529d0  fmul     d11, d1, d0
0x000529d4  mov      w0, #0x4241
0x000529d8  movk     w0, #0xf, lsl #16
0x000529dc  bl       #0x55ba4   ; CALL _arc4random_uniform
0x000529e0  ucvtf    d0, w0
0x000529e4  fmul     d0, d0, d12
0x000529e8  fdiv     d0, d0, d8
0x000529ec  fadd     d0, d0, d13
0x000529f0  fmul     d0, d9, d0
0x000529f4  ucvtf    d1, x19
0x000529f8  ldr      d2, [x22, x19, lsl #3]
0x000529fc  fmadd    d1, d1, d15, d14
0x00052a00  stp      d11, d0, [x20, #-0x10]
0x00052a04  ldr      d11, [sp, #0x88]
0x00052a08  stp      d1, d2, [x20], #0x20
0x00052a0c  add      x19, x19, #1
0x00052a10  cmp      x19, #7
0x00052a14  b.ne     #0x529ac
0x00052a18  ldr      x19, [sp, #0x10]
0x00052a1c  cmp      x19, #2
0x00052a20  ldr      x22, [sp, #0x78]
0x00052a24  ldr      d14, [sp, #0x70]
0x00052a28  b.gt     #0x52d10
0x00052a2c  cmp      x19, #1
0x00052a30  ldr      d10, [sp, #0x80]
0x00052a34  b.eq     #0x536c0
0x00052a38  cmp      x19, #2
0x00052a3c  b.ne     #0x534e8
0x00052a40  fmov     d0, #6.00000000
0x00052a44  fmul     d1, d14, d0
0x00052a48  fmov     d13, xzr
0x00052a4c  fadd     d0, d10, d13
0x00052a50  stp      d0, d1, [sp, #0x68]
0x00052a54  add      x19, sp, #0x90
0x00052a58  mov      w20, #0x64
0x00052a5c  adrp     x8, #0x66000
0x00052a60  ldr      d0, [x8, #0x108]
0x00052a64  str      d0, [sp, #0x60]
0x00052a68  adrp     x8, #0x65000
0x00052a6c  ldr      d15, [x8, #0xf10]
0x00052a70  adrp     x8, #0x65000
0x00052a74  ldr      d0, [x8, #0x708]
0x00052a78  str      d0, [sp, #0x58]
0x00052a7c  adrp     x8, #0x65000
0x00052a80  ldr      d0, [x8, #0x6e8]
0x00052a84  str      d0, [sp, #0x50]
0x00052a88  adrp     x25, #0x8e000
0x00052a8c  adrp     x22, #0x8e000
0x00052a90  adrp     x8, #0x65000
0x00052a94  ldr      d0, [x8, #0xb90]
0x00052a98  str      d0, [sp, #0x48]
0x00052a9c  mov      x8, #0x405e000000000000
0x00052aa0  fmov     d8, x8
0x00052aa4  mov      w26, #6
0x00052aa8  mov      w0, #0x4241
0x00052aac  movk     w0, #0xf, lsl #16
0x00052ab0  bl       #0x55ba4   ; CALL _arc4random_uniform
0x00052ab4  ucvtf    d0, w0
0x00052ab8  ldp      d1, d2, [sp, #0x58]
0x00052abc  fmul     d0, d0, d2
0x00052ac0  fdiv     d0, d0, d15
0x00052ac4  fadd     d0, d0, d13
0x00052ac8  sub      x0, x29, #0xb8
0x00052acc  ldr      d2, [sp, #0x50]
0x00052ad0  bl       #0x4f5e4
0x00052ad4  ldr      x0, [x25, #0xcd8]   ; @CLASS CALayer
0x00052ad8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00052adc  mov      x29, x29
0x00052ae0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052ae4  mov      x23, x0
0x00052ae8  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x00052aec  ldp      d0, d1, [x29, #-0xb8]
0x00052af0  ldur     d2, [x29, #-0xa8]
0x00052af4  fmov     d3, #1.00000000
0x00052af8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00052afc  mov      x29, x29
0x00052b00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052b04  mov      x24, x0
0x00052b08  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00052b0c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00052b10  mov      x2, x0
0x00052b14  mov      x0, x23
0x00052b18  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x00052b1c  mov      x0, x24
0x00052b20  bl       #0x55d78   ; CALL _objc_release
0x00052b24  mov      w0, #0x4241
0x00052b28  movk     w0, #0xf, lsl #16
0x00052b2c  bl       #0x55ba4   ; CALL _arc4random_uniform
0x00052b30  ucvtf    d0, w0
0x00052b34  fmov     d1, #8.00000000
0x00052b38  fmul     d0, d0, d1
0x00052b3c  fdiv     d0, d0, d15
0x00052b40  fadd     d0, d0, d1
0x00052b44  fmul     d2, d14, d0
0x00052b48  fmov     d0, xzr
0x00052b4c  fmov     d1, xzr
0x00052b50  mov      x0, x23
0x00052b54  ldr      d3, [sp, #0x70]
0x00052b58  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x00052b5c  mov      w0, #0x4241
0x00052b60  movk     w0, #0xf, lsl #16
0x00052b64  bl       #0x55ba4   ; CALL _arc4random_uniform
0x00052b68  ucvtf    d0, w0
0x00052b6c  fmul     d0, d11, d0
0x00052b70  fdiv     d0, d0, d15
0x00052b74  fadd     d11, d0, d13
0x00052b78  mov      w0, #0x4241
0x00052b7c  movk     w0, #0xf, lsl #16
0x00052b80  bl       #0x55ba4   ; CALL _arc4random_uniform
0x00052b84  ucvtf    d0, w0
0x00052b88  ldr      d1, [sp, #0x68]
0x00052b8c  fmul     d0, d1, d0
0x00052b90  fdiv     d0, d0, d15
0x00052b94  fsub     d9, d0, d10
0x00052b98  mov      w0, #0x4241
0x00052b9c  movk     w0, #0xf, lsl #16
0x00052ba0  bl       #0x55ba4   ; CALL _arc4random_uniform
0x00052ba4  ucvtf    d0, w0
0x00052ba8  ldr      d1, [sp, #0x48]
0x00052bac  fmul     d0, d0, d1
0x00052bb0  fdiv     d0, d0, d15
0x00052bb4  fadd     d0, d0, d8
0x00052bb8  fmul     d12, d14, d0
0x00052bbc  mov      w0, #0x4241
0x00052bc0  movk     w0, #0xf, lsl #16
0x00052bc4  bl       #0x55ba4   ; CALL _arc4random_uniform
0x00052bc8  ucvtf    d0, w0
0x00052bcc  fmov     d1, #6.00000000
0x00052bd0  fmul     d0, d0, d1
0x00052bd4  fdiv     d0, d0, d15
0x00052bd8  fadd     d10, d0, d13
0x00052bdc  mov      x0, x28
0x00052be0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00052be4  mov      x29, x29
0x00052be8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052bec  mov      x24, x0
0x00052bf0  str      x26, [sp, #0x90]
0x00052bf4  stp      d11, d9, [sp, #0x98]
0x00052bf8  stp      xzr, xzr, [x19, #0x20]
0x00052bfc  str      d12, [sp, #0xa8]
0x00052c00  str      d10, [sp, #0xc0]
0x00052c04  ldp      d10, d11, [sp, #0x80]
0x00052c08  add      x2, sp, #0x90
0x00052c0c  mov      x0, x21
0x00052c10  mov      x3, x23
0x00052c14  mov      x4, x24
0x00052c18  bl       #0x5cee0   ; CALL objc_msgSend$ss_addMote:layer:to:
0x00052c1c  mov      x0, x24
0x00052c20  bl       #0x55d78   ; CALL _objc_release
0x00052c24  mov      x0, x23
0x00052c28  bl       #0x55d78   ; CALL _objc_release
0x00052c2c  subs     w20, w20, #1
0x00052c30  b.ne     #0x52aa8
0x00052c34  adrp     x0, #0x7d000
0x00052c38  add      x0, x0, #0xd28   ; STR "Chúc mừng sinh nhật, %@!"
0x00052c3c  adrp     x1, #0x7d000
0x00052c40  add      x1, x1, #0xd48   ; STR "Happy birthday, %@!"
0x00052c44  bl       #0x5505c   ; CALL _OMCTr
0x00052c48  mov      x29, x29
0x00052c4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052c50  mov      x24, x0
0x00052c54  adrp     x0, #0x7d000
0x00052c58  add      x0, x0, #0xd68   ; STR "Chúc mừng sinh nhật!"
0x00052c5c  adrp     x1, #0x7d000
0x00052c60  add      x1, x1, #0xd88   ; STR "Happy birthday!"
0x00052c64  bl       #0x5505c   ; CALL _OMCTr
0x00052c68  mov      x29, x29
0x00052c6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052c70  mov      x25, x0
0x00052c74  mov      x0, x24
0x00052c78  mov      x1, x25
0x00052c7c  mov      x2, x27
0x00052c80  bl       #0x4daf4
0x00052c84  mov      x29, x29
0x00052c88  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052c8c  str      x0, [sp, #0x88]
0x00052c90  mov      x0, x25
0x00052c94  bl       #0x55d78   ; CALL _objc_release
0x00052c98  mov      x0, x24
0x00052c9c  bl       #0x55d78   ; CALL _objc_release
0x00052ca0  adrp     x0, #0x7d000
0x00052ca4  add      x0, x0, #0xda8   ; STR "Hôm nay lái xe vui nhé"
0x00052ca8  adrp     x1, #0x7d000
0x00052cac  add      x1, x1, #0xdc8   ; STR "Enjoy the drive today"
0x00052cb0  bl       #0x5505c   ; CALL _OMCTr
0x00052cb4  mov      x29, x29
0x00052cb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052cbc  str      x0, [sp, #0x80]
0x00052cc0  ldr      x0, [x22, #0x910]   ; @CLASS UIColor
0x00052cc4  adrp     x8, #0x65000
0x00052cc8  ldr      d0, [x8, #0xf20]
0x00052ccc  adrp     x8, #0x65000
0x00052cd0  ldr      d1, [x8, #0xf30]
0x00052cd4  fmov     d2, #1.00000000
0x00052cd8  fmov     d3, #1.00000000
0x00052cdc  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00052ce0  mov      x29, x29
0x00052ce4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052ce8  mov      x25, x0
0x00052cec  adrp     x26, #0x7d000
0x00052cf0  add      x26, x26, #0xd08   ; STR "🎂"
0x00052cf4  adrp     x8, #0x66000
0x00052cf8  ldr      d11, [x8, #0x10]
0x00052cfc  mov      x8, #0x4052000000000000
0x00052d00  fmov     d8, x8
0x00052d04  adrp     x8, #0x66000
0x00052d08  ldr      d10, [x8, #0x220]
0x00052d0c  b        #0x53400
0x00052d10  cmp      x19, #3
0x00052d14  ldr      d10, [sp, #0x80]
0x00052d18  b.eq     #0x53180
0x00052d1c  cmp      x19, #4
0x00052d20  b.ne     #0x534e8
0x00052d24  mov      x0, x28
0x00052d28  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00052d2c  mov      x29, x29
0x00052d30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052d34  mov      x23, x0
0x00052d38  adrp     x8, #0x8f000
0x00052d3c  ldrsw    x8, [x8, #0xd0]
0x00052d40  str      x8, [sp, #0x88]
0x00052d44  ldr      d0, [x21, x8]
0x00052d48  ldr      d1, [x21, x22]
0x00052d4c  adrp     x8, #0x66000
0x00052d50  ldr      d2, [x8, #0x208]
0x00052d54  fmadd    d8, d1, d2, d0
0x00052d58  adrp     x8, #0x8f000
0x00052d5c  ldrsw    x8, [x8, #0xd4]
0x00052d60  ldr      d0, [x21, x8]
0x00052d64  mov      x8, #0x4064000000000000
0x00052d68  fmov     d2, x8
0x00052d6c  fmadd    d9, d1, d2, d0
0x00052d70  fmul     d10, d14, d2
0x00052d74  adrp     x27, #0x8e000
0x00052d78  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x00052d7c  adrp     x8, #0x65000
0x00052d80  ldr      d1, [x8, #0xa68]
0x00052d84  adrp     x8, #0x65000
0x00052d88  ldr      d2, [x8, #0xb68]
0x00052d8c  fmov     d0, #1.00000000
0x00052d90  fmov     d3, #1.00000000
0x00052d94  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00052d98  mov      x29, x29
0x00052d9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052da0  mov      x24, x0
0x00052da4  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x00052da8  adrp     x8, #0x65000
0x00052dac  ldr      d1, [x8, #0xf30]
0x00052db0  adrp     x8, #0x65000
0x00052db4  ldr      d2, [x8, #0x9c0]
0x00052db8  fmov     d0, #1.00000000
0x00052dbc  fmov     d3, xzr
0x00052dc0  str      d2, [sp, #0x80]
0x00052dc4  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00052dc8  mov      x29, x29
0x00052dcc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052dd0  mov      x25, x0
0x00052dd4  mov      v0.16b, v8.16b
0x00052dd8  mov      v1.16b, v9.16b
0x00052ddc  mov      v2.16b, v10.16b
0x00052de0  mov      x0, x24
0x00052de4  mov      x1, x25
0x00052de8  bl       #0x4c190
0x00052dec  mov      x29, x29
0x00052df0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052df4  mov      x26, x0
0x00052df8  mov      x0, x23
0x00052dfc  mov      x2, x26
0x00052e00  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x00052e04  mov      x0, x26
0x00052e08  bl       #0x55d78   ; CALL _objc_release
0x00052e0c  mov      x0, x25
0x00052e10  bl       #0x55d78   ; CALL _objc_release
0x00052e14  mov      x0, x24
0x00052e18  bl       #0x55d78   ; CALL _objc_release
0x00052e1c  mov      x0, x23
0x00052e20  bl       #0x55d78   ; CALL _objc_release
0x00052e24  mov      w22, #0
0x00052e28  adrp     x8, #0x74000
0x00052e2c  ldr      x8, [x8, #0x610]   ; @GOT _CGRectZero
0x00052e30  ldp      d4, d0, [x8]
0x00052e34  stp      d0, d4, [sp, #0x68]
0x00052e38  ldp      d4, d0, [x8, #0x10]
0x00052e3c  stp      d0, d4, [sp, #0x58]
0x00052e40  adrp     x8, #0x66000
0x00052e44  ldr      d0, [x8, #0x160]
0x00052e48  fmul     d0, d14, d0
0x00052e4c  str      d0, [sp, #0x50]
0x00052e50  adrp     x8, #0x74000
0x00052e54  ldr      x8, [x8, #0x5c8]   ; @GOT _CGPointZero
0x00052e58  ldp      d4, d0, [x8]
0x00052e5c  stp      d0, d4, [sp, #0x40]
0x00052e60  mov      x8, #-0x3fbf000000000000
0x00052e64  fmov     d0, x8
0x00052e68  fmul     d4, d14, d0
0x00052e6c  mov      x8, #-0x3fba000000000000
0x00052e70  fmov     d0, x8
0x00052e74  fmul     d0, d14, d0
0x00052e78  stp      d0, d4, [sp, #0x30]
0x00052e7c  mov      x8, #0x4051000000000000
0x00052e80  fmov     d0, x8
0x00052e84  fmul     d4, d14, d0
0x00052e88  mov      x8, #0x4056000000000000
0x00052e8c  fmov     d0, x8
0x00052e90  fmul     d0, d14, d0
0x00052e94  stp      d0, d4, [sp, #0x20]
0x00052e98  add      x19, sp, #0x90
0x00052e9c  mov      w20, #0xc8
0x00052ea0  adrp     x8, #0x66000
0x00052ea4  ldr      d12, [x8, #0x120]
0x00052ea8  adrp     x8, #0x65000
0x00052eac  ldr      d13, [x8, #0xb20]
0x00052eb0  adrp     x8, #0x65000
0x00052eb4  mov      v9.16b, v14.16b
0x00052eb8  ldr      d14, [x8, #0x660]
0x00052ebc  adrp     x8, #0x65000
0x00052ec0  ldr      d15, [x8, #0xf40]
0x00052ec4  adrp     x8, #0x65000
0x00052ec8  ldr      d8, [x8, #0x708]
0x00052ecc  adrp     x8, #0x8e000
0x00052ed0  ldr      x0, [x8, #0xcd8]   ; @CLASS CALayer
0x00052ed4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00052ed8  mov      x29, x29
0x00052edc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052ee0  mov      x23, x0
0x00052ee4  ldp      d1, d0, [sp, #0x68]
0x00052ee8  ldp      d3, d2, [sp, #0x58]
0x00052eec  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x00052ef0  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x00052ef4  fmov     d0, #1.00000000
0x00052ef8  mov      v1.16b, v12.16b
0x00052efc  mov      v2.16b, v13.16b
0x00052f00  mov      v3.16b, v14.16b
0x00052f04  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00052f08  mov      x29, x29
0x00052f0c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052f10  mov      x25, x0
0x00052f14  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x00052f18  fmov     d0, #1.00000000
0x00052f1c  fmov     d3, xzr
0x00052f20  mov      v1.16b, v12.16b
0x00052f24  mov      v2.16b, v13.16b
0x00052f28  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00052f2c  mov      x29, x29
0x00052f30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052f34  mov      x26, x0
0x00052f38  ldp      d1, d0, [sp, #0x40]
0x00052f3c  ldr      d2, [sp, #0x50]
0x00052f40  mov      x0, x25
0x00052f44  mov      x1, x26
0x00052f48  bl       #0x4c190
0x00052f4c  mov      x29, x29
0x00052f50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052f54  mov      x24, x0
0x00052f58  mov      x0, x26
0x00052f5c  bl       #0x55d78   ; CALL _objc_release
0x00052f60  mov      x0, x25
0x00052f64  bl       #0x55d78   ; CALL _objc_release
0x00052f68  mov      x0, x23
0x00052f6c  mov      x2, x24
0x00052f70  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x00052f74  adrp     x8, #0x8e000
0x00052f78  ldr      x0, [x8, #0xb48]   ; @CLASS CAShapeLayer
0x00052f7c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00052f80  mov      x29, x29
0x00052f84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052f88  mov      x25, x0
0x00052f8c  adrp     x8, #0x8e000
0x00052f90  ldr      x0, [x8, #0xac0]   ; @CLASS UIBezierPath
0x00052f94  ldp      d1, d0, [sp, #0x30]
0x00052f98  ldp      d3, d2, [sp, #0x20]
0x00052f9c  bl       #0x56820   ; CALL objc_msgSend$bezierPathWithOvalInRect:
0x00052fa0  mov      x29, x29
0x00052fa4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052fa8  mov      x26, x0
0x00052fac  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00052fb0  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x00052fb4  mov      x2, x0
0x00052fb8  mov      x0, x25
0x00052fbc  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x00052fc0  mov      x0, x26
0x00052fc4  bl       #0x55d78   ; CALL _objc_release
0x00052fc8  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x00052fcc  fmov     d0, #1.00000000
0x00052fd0  ldr      d1, [sp, #0x80]
0x00052fd4  mov      v2.16b, v15.16b
0x00052fd8  mov      v3.16b, v8.16b
0x00052fdc  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00052fe0  mov      x29, x29
0x00052fe4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00052fe8  mov      x26, x0
0x00052fec  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00052ff0  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00052ff4  mov      x2, x0
0x00052ff8  mov      x0, x25
0x00052ffc  bl       #0x5ae40   ; CALL objc_msgSend$setFillColor:
0x00053000  mov      x0, x26
0x00053004  bl       #0x55d78   ; CALL _objc_release
0x00053008  mov      x0, x23
0x0005300c  mov      x2, x25
0x00053010  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x00053014  ldr      x8, [sp, #0x88]
0x00053018  ldr      d0, [x21, x8]
0x0005301c  ucvtf    d1, w20
0x00053020  ldr      x8, [sp, #0x78]
0x00053024  ldr      d2, [x21, x8]
0x00053028  fmadd    d11, d1, d2, d0
0x0005302c  ucvtf    d0, w22
0x00053030  fmul     d10, d9, d0
0x00053034  mov      x0, x28
0x00053038  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0005303c  mov      x29, x29
0x00053040  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053044  mov      x26, x0
0x00053048  mov      w8, #7
0x0005304c  str      x8, [sp, #0x90]
0x00053050  movi     v0.16b, #0
0x00053054  stp      q0, q0, [x19, #0x10]
0x00053058  str      d11, [sp, #0x98]
0x0005305c  str      d10, [sp, #0xc0]
0x00053060  add      x2, sp, #0x90
0x00053064  mov      x0, x21
0x00053068  mov      x3, x23
0x0005306c  mov      x4, x26
0x00053070  bl       #0x5cee0   ; CALL objc_msgSend$ss_addMote:layer:to:
0x00053074  mov      x0, x26
0x00053078  bl       #0x55d78   ; CALL _objc_release
0x0005307c  mov      x0, x25
0x00053080  bl       #0x55d78   ; CALL _objc_release
0x00053084  mov      x0, x24
0x00053088  bl       #0x55d78   ; CALL _objc_release
0x0005308c  mov      x0, x23
0x00053090  bl       #0x55d78   ; CALL _objc_release
0x00053094  add      w20, w20, #0xe6
0x00053098  add      w22, w22, #0x5a
0x0005309c  cmp      w20, #0x62c
0x000530a0  b.ne     #0x52ecc
0x000530a4  adrp     x0, #0x7d000
0x000530a8  add      x0, x0, #0xea8   ; STR "Trung Thu Vui Vẻ"
0x000530ac  adrp     x1, #0x7d000
0x000530b0  add      x1, x1, #0xec8   ; STR "Happy Mid-Autumn Festival"
0x000530b4  bl       #0x5505c   ; CALL _OMCTr
0x000530b8  mov      x29, x29
0x000530bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000530c0  str      x0, [sp, #0x88]
0x000530c4  adrp     x0, #0x7d000
0x000530c8  add      x0, x0, #0xee8   ; STR "Trăng tròn, đường thông, %@ nhé"
0x000530cc  adrp     x1, #0x7d000
0x000530d0  add      x1, x1, #0xf08   ; STR "Full moon and clear roads, %@"
0x000530d4  bl       #0x5505c   ; CALL _OMCTr
0x000530d8  mov      x29, x29
0x000530dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000530e0  mov      x25, x0
0x000530e4  adrp     x0, #0x7d000
0x000530e8  add      x0, x0, #0xf28   ; STR "Trăng tròn, đường thông"
0x000530ec  adrp     x1, #0x7d000
0x000530f0  add      x1, x1, #0xf48   ; STR "Full moon and clear roads"
0x000530f4  bl       #0x5505c   ; CALL _OMCTr
0x000530f8  mov      x29, x29
0x000530fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053100  mov      x26, x0
0x00053104  mov      x0, x25
0x00053108  mov      x1, x26
0x0005310c  ldr      x2, [sp, #0x18]
0x00053110  bl       #0x4daf4
0x00053114  mov      x29, x29
0x00053118  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005311c  str      x0, [sp, #0x80]
0x00053120  mov      x0, x26
0x00053124  bl       #0x55d78   ; CALL _objc_release
0x00053128  mov      x0, x25
0x0005312c  bl       #0x55d78   ; CALL _objc_release
0x00053130  ldr      x0, [x27, #0x910]   ; @CLASS UIColor
0x00053134  adrp     x8, #0x66000
0x00053138  ldr      d1, [x8, #0x210]
0x0005313c  adrp     x8, #0x65000
0x00053140  ldr      d2, [x8, #0xb28]
0x00053144  fmov     d0, #1.00000000
0x00053148  fmov     d3, #1.00000000
0x0005314c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00053150  mov      x29, x29
0x00053154  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053158  mov      x26, x0
0x0005315c  mov      x25, #0
0x00053160  fmov     d9, #30.00000000
0x00053164  adrp     x8, #0x65000
0x00053168  ldr      d11, [x8, #0x638]
0x0005316c  mov      x8, #0x4055000000000000
0x00053170  fmov     d8, x8
0x00053174  mov      x8, #0x4079000000000000
0x00053178  fmov     d10, x8
0x0005317c  b        #0x539a8
0x00053180  mov      w20, #0x78
0x00053184  adrp     x8, #0x65000
0x00053188  ldr      d12, [x8, #0xf10]
0x0005318c  adrp     x22, #0x8e000
0x00053190  adrp     x19, #0x8e000
0x00053194  adrp     x8, #0x65000
0x00053198  ldr      d0, [x8, #0x6d0]
0x0005319c  str      d0, [sp, #0x70]
0x000531a0  fmov     d15, xzr
0x000531a4  mov      x8, #0x4044000000000000
0x000531a8  str      x8, [sp, #0x68]
0x000531ac  mov      w25, #4
0x000531b0  mov      w0, #0x4241
0x000531b4  movk     w0, #0xf, lsl #16
0x000531b8  bl       #0x55ba4   ; CALL _arc4random_uniform
0x000531bc  ucvtf    d0, w0
0x000531c0  fmov     d1, #3.00000000
0x000531c4  fmul     d0, d0, d1
0x000531c8  fdiv     d0, d0, d12
0x000531cc  fmov     d1, #1.50000000
0x000531d0  fadd     d0, d0, d1
0x000531d4  fmul     d9, d14, d0
0x000531d8  ldr      x0, [x22, #0xcd8]   ; @CLASS CALayer
0x000531dc  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000531e0  mov      x29, x29
0x000531e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000531e8  mov      x23, x0
0x000531ec  ldr      x0, [x19, #0x910]   ; @CLASS UIColor
0x000531f0  fmov     d0, #1.00000000
0x000531f4  fmov     d1, #1.00000000
0x000531f8  fmov     d2, #1.00000000
0x000531fc  ldr      d3, [sp, #0x70]
0x00053200  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00053204  mov      x29, x29
0x00053208  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005320c  mov      x24, x0
0x00053210  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00053214  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00053218  mov      x2, x0
0x0005321c  mov      x0, x23
0x00053220  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x00053224  mov      x0, x24
0x00053228  bl       #0x55d78   ; CALL _objc_release
0x0005322c  fadd     d2, d9, d9
0x00053230  fmov     d0, xzr
0x00053234  fmov     d1, xzr
0x00053238  mov      x0, x23
0x0005323c  mov      v3.16b, v2.16b
0x00053240  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x00053244  mov      x0, x23
0x00053248  mov      v0.16b, v9.16b
0x0005324c  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x00053250  mov      w0, #0x4241
0x00053254  movk     w0, #0xf, lsl #16
0x00053258  bl       #0x55ba4   ; CALL _arc4random_uniform
0x0005325c  ucvtf    d0, w0
0x00053260  fmul     d0, d11, d0
0x00053264  fdiv     d0, d0, d12
0x00053268  fadd     d11, d0, d15
0x0005326c  mov      w0, #0x4241
0x00053270  movk     w0, #0xf, lsl #16
0x00053274  bl       #0x55ba4   ; CALL _arc4random_uniform
0x00053278  ucvtf    d0, w0
0x0005327c  fmul     d0, d10, d0
0x00053280  fdiv     d0, d0, d12
0x00053284  fadd     d10, d0, d15
0x00053288  mov      w0, #0x4241
0x0005328c  movk     w0, #0xf, lsl #16
0x00053290  bl       #0x55ba4   ; CALL _arc4random_uniform
0x00053294  ucvtf    d0, w0
0x00053298  ldr      d1, [sp, #0x68]
0x0005329c  fmul     d0, d0, d1
0x000532a0  fdiv     d0, d0, d12
0x000532a4  fmov     d1, #30.00000000
0x000532a8  fadd     d0, d0, d1
0x000532ac  fmul     d13, d14, d0
0x000532b0  mov      w0, #0x4241
0x000532b4  movk     w0, #0xf, lsl #16
0x000532b8  bl       #0x55ba4   ; CALL _arc4random_uniform
0x000532bc  ucvtf    d0, w0
0x000532c0  fmov     d1, #6.00000000
0x000532c4  fmul     d0, d0, d1
0x000532c8  fdiv     d0, d0, d12
0x000532cc  fadd     d8, d0, d15
0x000532d0  mov      x0, x28
0x000532d4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000532d8  mov      x29, x29
0x000532dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000532e0  mov      x24, x0
0x000532e4  str      x25, [sp, #0x90]
0x000532e8  stp      d11, d10, [sp, #0x98]
0x000532ec  ldp      d10, d11, [sp, #0x80]
0x000532f0  stp      d13, d9, [sp, #0xa8]
0x000532f4  str      xzr, [sp, #0xb8]
0x000532f8  str      d8, [sp, #0xc0]
0x000532fc  add      x2, sp, #0x90
0x00053300  mov      x0, x21
0x00053304  mov      x3, x23
0x00053308  mov      x4, x24
0x0005330c  bl       #0x5cee0   ; CALL objc_msgSend$ss_addMote:layer:to:
0x00053310  mov      x0, x24
0x00053314  bl       #0x55d78   ; CALL _objc_release
0x00053318  mov      x0, x23
0x0005331c  bl       #0x55d78   ; CALL _objc_release
0x00053320  subs     w20, w20, #1
0x00053324  b.ne     #0x531b0
0x00053328  adrp     x0, #0x7d000
0x0005332c  add      x0, x0, #0xe08   ; STR "Giáng Sinh An Lành"
0x00053330  adrp     x24, #0x7d000
0x00053334  add      x24, x24, #0xe28   ; STR "Merry Christmas"
0x00053338  mov      x1, x24
0x0005333c  bl       #0x5505c   ; CALL _OMCTr
0x00053340  mov      x29, x29
0x00053344  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053348  str      x0, [sp, #0x88]
0x0005334c  adrp     x0, #0x7d000
0x00053350  add      x0, x0, #0xe48   ; STR "Merry Christmas, %@"
0x00053354  adrp     x1, #0x7d000
0x00053358  add      x1, x1, #0xe68   ; STR "Happy holidays, %@"
0x0005335c  bl       #0x5505c   ; CALL _OMCTr
0x00053360  mov      x29, x29
0x00053364  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053368  mov      x25, x0
0x0005336c  adrp     x1, #0x7d000
0x00053370  add      x1, x1, #0xe88   ; STR "Happy holidays"
0x00053374  mov      x0, x24
0x00053378  bl       #0x5505c   ; CALL _OMCTr
0x0005337c  mov      x29, x29
0x00053380  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053384  mov      x26, x0
0x00053388  mov      x0, x25
0x0005338c  mov      x1, x26
0x00053390  mov      x2, x27
0x00053394  bl       #0x4daf4
0x00053398  mov      x29, x29
0x0005339c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000533a0  str      x0, [sp, #0x80]
0x000533a4  mov      x0, x26
0x000533a8  bl       #0x55d78   ; CALL _objc_release
0x000533ac  mov      x0, x25
0x000533b0  bl       #0x55d78   ; CALL _objc_release
0x000533b4  ldr      x0, [x19, #0x910]   ; @CLASS UIColor
0x000533b8  adrp     x8, #0x66000
0x000533bc  ldr      d0, [x8, #0xe8]
0x000533c0  adrp     x8, #0x65000
0x000533c4  ldr      d1, [x8, #0xf20]
0x000533c8  fmov     d2, #1.00000000
0x000533cc  fmov     d3, #1.00000000
0x000533d0  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x000533d4  mov      x29, x29
0x000533d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000533dc  mov      x25, x0
0x000533e0  adrp     x26, #0x7d000
0x000533e4  add      x26, x26, #0xde8   ; STR "🎄"
0x000533e8  adrp     x8, #0x65000
0x000533ec  ldr      d11, [x8, #0x6f0]
0x000533f0  mov      x8, #0x4054000000000000
0x000533f4  fmov     d8, x8
0x000533f8  adrp     x8, #0x66000
0x000533fc  ldr      d10, [x8, #0x218]
0x00053400  mov      x0, x21
0x00053404  bl       #0x5d1a0   ; CALL objc_msgSend$ss_host
0x00053408  mov      x29, x29
0x0005340c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053410  mov      x27, x0
0x00053414  adrp     x8, #0x8f000
0x00053418  ldrsw    x19, [x8, #0xd0]
0x0005341c  ldr      d0, [x21, x19]
0x00053420  ldr      x22, [sp, #0x78]
0x00053424  ldr      d1, [x21, x22]
0x00053428  mov      x8, #0x4089000000000000
0x0005342c  fmov     d2, x8
0x00053430  adrp     x8, #0x8f000
0x00053434  ldrsw    x20, [x8, #0xd4]
0x00053438  ldr      d3, [x21, x20]
0x0005343c  fmadd    d0, d1, d2, d0
0x00053440  ldr      x23, [sp, #0x10]
0x00053444  cmp      x23, #3
0x00053448  mov      w8, #8
0x0005344c  csel     x8, x8, xzr, eq
0x00053450  adrp     x9, #0x66000
0x00053454  add      x9, x9, #0x310
0x00053458  ldr      d2, [x9, x8]
0x0005345c  fmadd    d1, d2, d1, d3
0x00053460  adrp     x8, #0x74000
0x00053464  ldr      x8, [x8, #0x258]   ; @GOT _UIFontWeightRegular
0x00053468  ldr      d3, [x8]   ; @GOT ___objc_personality_v0
0x0005346c  mov      x8, #0x405e000000000000
0x00053470  fmov     d2, x8
0x00053474  fmov     d4, xzr
0x00053478  mov      x0, x21
0x0005347c  mov      x2, x26
0x00053480  mov      x3, #0
0x00053484  mov      w4, #0
0x00053488  mov      x5, x27
0x0005348c  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x00053490  mov      x29, x29
0x00053494  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053498  mov      x26, x0
0x0005349c  adrp     x8, #0x65000
0x000534a0  ldr      d0, [x8, #0x608]
0x000534a4  fmov     d1, #1.00000000
0x000534a8  fmov     d2, #1.00000000
0x000534ac  mov      x0, x21
0x000534b0  mov      x2, x26
0x000534b4  bl       #0x5d160   ; CALL objc_msgSend$ss_fade:from:to:alpha:
0x000534b8  mov      x29, x29
0x000534bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000534c0  mov      x28, x0
0x000534c4  mov      w2, #1
0x000534c8  bl       #0x5b9c0   ; CALL objc_msgSend$setOutEase:
0x000534cc  mov      x0, x28
0x000534d0  bl       #0x55d78   ; CALL _objc_release
0x000534d4  mov      x0, x26
0x000534d8  bl       #0x55d78   ; CALL _objc_release
0x000534dc  mov      x26, #0
0x000534e0  fmov     d9, #30.00000000
0x000534e4  b        #0x539d4
0x000534e8  mov      x20, x19
0x000534ec  adrp     x8, #0x8e000
0x000534f0  ldr      x0, [x8, #0x9f8]   ; @CLASS NSCalendar
0x000534f4  adrp     x8, #0x74000
0x000534f8  ldr      x8, [x8, #0x188]   ; @GOT _NSCalendarIdentifierGregorian
0x000534fc  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x00053500  bl       #0x56bc0   ; CALL objc_msgSend$calendarWithIdentifier:
0x00053504  mov      x29, x29
0x00053508  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005350c  mov      x23, x0
0x00053510  mov      x0, x21
0x00053514  bl       #0x575a0   ; CALL objc_msgSend$date
0x00053518  mov      x29, x29
0x0005351c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053520  mov      x24, x0
0x00053524  cbz      x0, #0x53540
0x00053528  mov      x0, x23
0x0005352c  mov      w2, #4
0x00053530  mov      x3, x24
0x00053534  bl       #0x56fc0   ; CALL objc_msgSend$component:fromDate:
0x00053538  mov      x25, x0
0x0005353c  b        #0x53574
0x00053540  adrp     x8, #0x8e000
0x00053544  ldr      x0, [x8, #0x978]   ; @CLASS NSDate
0x00053548  bl       #0x575a0   ; CALL objc_msgSend$date
0x0005354c  mov      x29, x29
0x00053550  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053554  mov      x26, x0
0x00053558  mov      x0, x23
0x0005355c  mov      w2, #4
0x00053560  mov      x3, x26
0x00053564  bl       #0x56fc0   ; CALL objc_msgSend$component:fromDate:
0x00053568  mov      x25, x0
0x0005356c  mov      x0, x26
0x00053570  bl       #0x55d78   ; CALL _objc_release
0x00053574  mov      x0, x24
0x00053578  bl       #0x55d78   ; CALL _objc_release
0x0005357c  mov      x0, x23
0x00053580  bl       #0x55d78   ; CALL _objc_release
0x00053584  adrp     x8, #0x8e000
0x00053588  ldr      x23, [x8, #0x958]   ; @CLASS NSString
0x0005358c  adrp     x0, #0x7d000
0x00053590  add      x0, x0, #0xf68   ; STR "Chúc mừng năm mới %ld"
0x00053594  adrp     x1, #0x7d000
0x00053598  add      x1, x1, #0xf88   ; STR "Happy New Year %ld"
0x0005359c  bl       #0x5505c   ; CALL _OMCTr
0x000535a0  mov      x29, x29
0x000535a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000535a8  mov      x24, x0
0x000535ac  str      x25, [sp]
0x000535b0  mov      x0, x23
0x000535b4  mov      x2, x24
0x000535b8  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x000535bc  mov      x29, x29
0x000535c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000535c4  str      x0, [sp, #0x88]
0x000535c8  mov      x0, x24
0x000535cc  bl       #0x55d78   ; CALL _objc_release
0x000535d0  adrp     x0, #0x7d000
0x000535d4  add      x0, x0, #0xfa8   ; STR "Thượng lộ bình an, %@"
0x000535d8  adrp     x1, #0x7d000
0x000535dc  add      x1, x1, #0xfc8   ; STR "Safe travels, %@"
0x000535e0  bl       #0x5505c   ; CALL _OMCTr
0x000535e4  mov      x29, x29
0x000535e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000535ec  mov      x25, x0
0x000535f0  adrp     x0, #0x7d000
0x000535f4  add      x0, x0, #0xfe8   ; STR "Thượng lộ bình an"
0x000535f8  adrp     x1, #0x7e000
0x000535fc  add      x1, x1, #8   ; STR "Safe travels"
0x00053600  bl       #0x5505c   ; CALL _OMCTr
0x00053604  mov      x29, x29
0x00053608  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005360c  mov      x26, x0
0x00053610  mov      x0, x25
0x00053614  mov      x1, x26
0x00053618  mov      x2, x27
0x0005361c  bl       #0x4daf4
0x00053620  mov      x29, x29
0x00053624  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053628  str      x0, [sp, #0x80]
0x0005362c  mov      x0, x26
0x00053630  bl       #0x55d78   ; CALL _objc_release
0x00053634  mov      x0, x25
0x00053638  bl       #0x55d78   ; CALL _objc_release
0x0005363c  adrp     x19, #0x8e000
0x00053640  ldr      x0, [x19, #0x910]   ; @CLASS UIColor
0x00053644  adrp     x8, #0x66000
0x00053648  ldr      d1, [x8, #0x240]
0x0005364c  adrp     x8, #0x65000
0x00053650  ldr      d2, [x8, #0x658]
0x00053654  fmov     d0, #1.00000000
0x00053658  fmov     d3, #1.00000000
0x0005365c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00053660  mov      x29, x29
0x00053664  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053668  mov      x26, x0
0x0005366c  ldr      x0, [x19, #0x910]   ; @CLASS UIColor
0x00053670  adrp     x8, #0x65000
0x00053674  ldr      d0, [x8, #0xf30]
0x00053678  adrp     x8, #0x65000
0x0005367c  ldr      d1, [x8, #0xf20]
0x00053680  fmov     d2, #1.00000000
0x00053684  fmov     d3, #1.00000000
0x00053688  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0005368c  mov      x29, x29
0x00053690  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053694  mov      x25, x0
0x00053698  adrp     x8, #0x66000
0x0005369c  ldr      d11, [x8, #0x248]
0x000536a0  adrp     x8, #0x66000
0x000536a4  ldr      d8, [x8, #0x160]
0x000536a8  adrp     x8, #0x66000
0x000536ac  ldr      d10, [x8, #0x250]
0x000536b0  mov      x8, #0x4040000000000000
0x000536b4  fmov     d9, x8
0x000536b8  mov      x23, x20
0x000536bc  b        #0x539b0
0x000536c0  mov      x0, x21
0x000536c4  bl       #0x5d1a0   ; CALL objc_msgSend$ss_host
0x000536c8  mov      x29, x29
0x000536cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000536d0  mov      x27, x0
0x000536d4  adrp     x0, #0x74000
0x000536d8  add      x0, x0, #0xf18
0x000536dc  mov      x8, #0x4048000000000000
0x000536e0  fmov     d0, x8
0x000536e4  mov      v1.16b, v0.16b
0x000536e8  bl       #0x54848
0x000536ec  mov      x29, x29
0x000536f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000536f4  mov      x28, x0
0x000536f8  fmov     d0, xzr
0x000536fc  fadd     d0, d10, d0
0x00053700  str      d0, [sp, #0x68]
0x00053704  mov      w19, #0x24
0x00053708  adrp     x20, #0x8e000
0x0005370c  adrp     x8, #0x66000
0x00053710  ldr      d0, [x8, #0x28]
0x00053714  str      d0, [sp, #0x60]
0x00053718  mov      x8, #0x404e000000000000
0x0005371c  str      x8, [sp, #0x58]
0x00053720  mov      w22, #5
0x00053724  mov      w0, #0x4241
0x00053728  movk     w0, #0xf, lsl #16
0x0005372c  bl       #0x55ba4   ; CALL _arc4random_uniform
0x00053730  ucvtf    d0, w0
0x00053734  fmov     d1, #8.00000000
0x00053738  fmul     d0, d0, d1
0x0005373c  fdiv     d0, d0, d8
0x00053740  fmov     d1, #10.00000000
0x00053744  fadd     d0, d0, d1
0x00053748  fmul     d12, d14, d0
0x0005374c  ldr      x0, [x20, #0xcd8]   ; @CLASS CALayer
0x00053750  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00053754  mov      x29, x29
0x00053758  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005375c  mov      x23, x0
0x00053760  mov      x0, x28
0x00053764  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00053768  bl       #0x55ec0   ; CALL objc_msgSend$CGImage
0x0005376c  mov      x2, x0
0x00053770  mov      x0, x23
0x00053774  bl       #0x5aae0   ; CALL objc_msgSend$setContents:
0x00053778  ldr      d0, [sp, #0x60]
0x0005377c  fmul     d2, d12, d0
0x00053780  fmov     d0, xzr
0x00053784  fmov     d1, xzr
0x00053788  mov      x0, x23
0x0005378c  mov      v3.16b, v2.16b
0x00053790  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x00053794  mov      w0, #0x4241
0x00053798  movk     w0, #0xf, lsl #16
0x0005379c  bl       #0x55ba4   ; CALL _arc4random_uniform
0x000537a0  ucvtf    d0, w0
0x000537a4  fmul     d0, d11, d0
0x000537a8  fdiv     d0, d0, d8
0x000537ac  fmov     d15, xzr
0x000537b0  fadd     d11, d0, d15
0x000537b4  mov      w0, #0x4241
0x000537b8  movk     w0, #0xf, lsl #16
0x000537bc  bl       #0x55ba4   ; CALL _arc4random_uniform
0x000537c0  ucvtf    d0, w0
0x000537c4  ldr      d1, [sp, #0x68]
0x000537c8  fmul     d0, d1, d0
0x000537cc  fdiv     d0, d0, d8
0x000537d0  fsub     d13, d0, d10
0x000537d4  mov      w0, #0x4241
0x000537d8  movk     w0, #0xf, lsl #16
0x000537dc  bl       #0x55ba4   ; CALL _arc4random_uniform
0x000537e0  ucvtf    d0, w0
0x000537e4  ldr      d1, [sp, #0x58]
0x000537e8  fmul     d0, d0, d1
0x000537ec  fdiv     d0, d0, d8
0x000537f0  fadd     d0, d0, d1
0x000537f4  fmul     d9, d14, d0
0x000537f8  mov      w0, #0x4241
0x000537fc  movk     w0, #0xf, lsl #16
0x00053800  bl       #0x55ba4   ; CALL _arc4random_uniform
0x00053804  ucvtf    d0, w0
0x00053808  fadd     d0, d0, d0
0x0005380c  fdiv     d0, d0, d8
0x00053810  fmov     d1, #1.00000000
0x00053814  fadd     d10, d0, d1
0x00053818  mov      w0, #0x4241
0x0005381c  movk     w0, #0xf, lsl #16
0x00053820  bl       #0x55ba4   ; CALL _arc4random_uniform
0x00053824  ucvtf    d0, w0
0x00053828  fmov     d1, #6.00000000
0x0005382c  fmul     d0, d0, d1
0x00053830  fdiv     d0, d0, d8
0x00053834  fadd     d14, d0, d15
0x00053838  mov      x0, x27
0x0005383c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00053840  mov      x29, x29
0x00053844  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053848  mov      x24, x0
0x0005384c  str      x22, [sp, #0x90]
0x00053850  stp      d11, d13, [sp, #0x98]
0x00053854  stp      d9, d12, [sp, #0xa8]
0x00053858  stp      d10, d14, [sp, #0xb8]
0x0005385c  ldp      d10, d11, [sp, #0x80]
0x00053860  ldr      d14, [sp, #0x70]
0x00053864  add      x2, sp, #0x90
0x00053868  mov      x0, x21
0x0005386c  mov      x3, x23
0x00053870  mov      x4, x24
0x00053874  bl       #0x5cee0   ; CALL objc_msgSend$ss_addMote:layer:to:
0x00053878  mov      x0, x24
0x0005387c  bl       #0x55d78   ; CALL _objc_release
0x00053880  mov      x0, x23
0x00053884  bl       #0x55d78   ; CALL _objc_release
0x00053888  subs     w19, w19, #1
0x0005388c  b.ne     #0x53724
0x00053890  adrp     x0, #0x7d000
0x00053894  add      x0, x0, #0xc48   ; STR "Chúc Mừng Năm Mới"
0x00053898  adrp     x1, #0x7d000
0x0005389c  add      x1, x1, #0xc68   ; STR "Happy Lunar New Year"
0x000538a0  bl       #0x5505c   ; CALL _OMCTr
0x000538a4  mov      x29, x29
0x000538a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000538ac  str      x0, [sp, #0x88]
0x000538b0  adrp     x0, #0x7d000
0x000538b4  add      x0, x0, #0xc88   ; STR "An khang thịnh vượng · thượng lộ bình an, %@"
0x000538b8  adrp     x1, #0x7d000
0x000538bc  add      x1, x1, #0xca8   ; STR "Health, luck and safe travels, %@"
0x000538c0  bl       #0x5505c   ; CALL _OMCTr
0x000538c4  mov      x29, x29
0x000538c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000538cc  mov      x25, x0
0x000538d0  adrp     x0, #0x7d000
0x000538d4  add      x0, x0, #0xcc8   ; STR "An khang thịnh vượng · thượng lộ bình an"
0x000538d8  adrp     x1, #0x7d000
0x000538dc  add      x1, x1, #0xce8   ; STR "Health, luck and safe travels"
0x000538e0  bl       #0x5505c   ; CALL _OMCTr
0x000538e4  mov      x29, x29
0x000538e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000538ec  mov      x26, x0
0x000538f0  mov      x0, x25
0x000538f4  mov      x1, x26
0x000538f8  ldr      x2, [sp, #0x18]
0x000538fc  bl       #0x4daf4
0x00053900  mov      x29, x29
0x00053904  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053908  str      x0, [sp, #0x80]
0x0005390c  mov      x0, x26
0x00053910  bl       #0x55d78   ; CALL _objc_release
0x00053914  mov      x0, x25
0x00053918  bl       #0x55d78   ; CALL _objc_release
0x0005391c  adrp     x19, #0x8e000
0x00053920  ldr      x0, [x19, #0x910]   ; @CLASS UIColor
0x00053924  adrp     x8, #0x66000
0x00053928  ldr      d1, [x8, #0x228]
0x0005392c  adrp     x8, #0x65000
0x00053930  ldr      d2, [x8, #0xff0]
0x00053934  fmov     d0, #1.00000000
0x00053938  fmov     d3, #1.00000000
0x0005393c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00053940  mov      x29, x29
0x00053944  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053948  mov      x26, x0
0x0005394c  ldr      x0, [x19, #0x910]   ; @CLASS UIColor
0x00053950  adrp     x8, #0x66000
0x00053954  ldr      d1, [x8, #0x230]
0x00053958  adrp     x8, #0x65000
0x0005395c  ldr      d2, [x8, #0xb68]
0x00053960  fmov     d0, #1.00000000
0x00053964  fmov     d3, #1.00000000
0x00053968  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0005396c  mov      x29, x29
0x00053970  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053974  mov      x25, x0
0x00053978  mov      x0, x28
0x0005397c  bl       #0x55d78   ; CALL _objc_release
0x00053980  mov      x0, x27
0x00053984  bl       #0x55d78   ; CALL _objc_release
0x00053988  adrp     x8, #0x66000
0x0005398c  ldr      d11, [x8, #0x238]
0x00053990  mov      x8, #0x4058000000000000
0x00053994  fmov     d8, x8
0x00053998  adrp     x8, #0x66000
0x0005399c  ldr      d10, [x8, #0x108]
0x000539a0  mov      x8, #0x4040000000000000
0x000539a4  fmov     d9, x8
0x000539a8  ldr      x22, [sp, #0x78]
0x000539ac  ldr      x23, [sp, #0x10]
0x000539b0  mov      x0, x21
0x000539b4  bl       #0x5d1a0   ; CALL objc_msgSend$ss_host
0x000539b8  mov      x29, x29
0x000539bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000539c0  mov      x27, x0
0x000539c4  adrp     x8, #0x8f000
0x000539c8  ldrsw    x19, [x8, #0xd0]
0x000539cc  adrp     x8, #0x8f000
0x000539d0  ldrsw    x20, [x8, #0xd4]
0x000539d4  ldr      d0, [x21, x19]
0x000539d8  ldr      d1, [x21, x22]
0x000539dc  mov      x8, #0x4089000000000000
0x000539e0  fmov     d12, x8
0x000539e4  fmadd    d0, d1, d12, d0
0x000539e8  ldr      d2, [x21, x20]
0x000539ec  fmadd    d1, d11, d1, d2
0x000539f0  adrp     x8, #0x74000
0x000539f4  ldr      x8, [x8, #0x240]   ; @GOT _UIFontWeightHeavy
0x000539f8  ldr      d3, [x8]   ; @GOT ___objc_personality_v0
0x000539fc  fmov     d4, xzr
0x00053a00  mov      x0, x21
0x00053a04  ldr      x24, [sp, #0x88]
0x00053a08  mov      x2, x24
0x00053a0c  mov      v2.16b, v8.16b
0x00053a10  mov      x3, x26
0x00053a14  mov      w4, #0
0x00053a18  mov      x5, x27
0x00053a1c  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x00053a20  mov      x29, x29
0x00053a24  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053a28  mov      x28, x0
0x00053a2c  cmp      x23, #1
0x00053a30  adrp     x8, #0x65000
0x00053a34  ldr      d0, [x8, #0x610]
0x00053a38  fmov     d1, #1.50000000
0x00053a3c  fcsel    d1, d0, d1, eq
0x00053a40  mov      w8, #8
0x00053a44  csel     x23, x8, xzr, eq
0x00053a48  adrp     x8, #0x66000
0x00053a4c  ldr      d0, [x8, #0x258]
0x00053a50  fmov     d2, #2.00000000
0x00053a54  fcsel    d8, d0, d2, eq
0x00053a58  adrp     x8, #0x65000
0x00053a5c  ldr      d0, [x8, #0x670]
0x00053a60  fmov     d2, #1.00000000
0x00053a64  mov      x0, x21
0x00053a68  mov      x2, x28
0x00053a6c  bl       #0x5d160   ; CALL objc_msgSend$ss_fade:from:to:alpha:
0x00053a70  mov      x29, x29
0x00053a74  bl       #0x55dfc   ; CALL _objc_unsafeClaimAutoreleasedReturnValue
0x00053a78  ldr      d0, [x21, x19]
0x00053a7c  ldr      d1, [x21, x22]
0x00053a80  fmadd    d0, d1, d12, d0
0x00053a84  ldr      d2, [x21, x20]
0x00053a88  fmadd    d1, d10, d1, d2
0x00053a8c  adrp     x8, #0x74000
0x00053a90  ldr      x8, [x8, #0x260]   ; @GOT _UIFontWeightSemibold
0x00053a94  ldr      d3, [x8]   ; @GOT ___objc_personality_v0
0x00053a98  adrp     x8, #0x66000
0x00053a9c  add      x8, x8, #0x320
0x00053aa0  ldr      d10, [x8, x23]
0x00053aa4  fmov     d4, xzr
0x00053aa8  mov      x0, x21
0x00053aac  ldr      x19, [sp, #0x80]
0x00053ab0  mov      x2, x19
0x00053ab4  mov      v2.16b, v9.16b
0x00053ab8  mov      x3, x25
0x00053abc  mov      w4, #0
0x00053ac0  mov      x5, x27
0x00053ac4  bl       #0x5d1c0   ; CALL objc_msgSend$ss_label:at:size:weight:color:left:in:maxWidth:
0x00053ac8  mov      x29, x29
0x00053acc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00053ad0  mov      x22, x0
0x00053ad4  fmov     d2, #1.00000000
0x00053ad8  mov      x0, x21
0x00053adc  mov      x2, x22
0x00053ae0  mov      v0.16b, v10.16b
0x00053ae4  mov      v1.16b, v8.16b
0x00053ae8  bl       #0x5d160   ; CALL objc_msgSend$ss_fade:from:to:alpha:
0x00053aec  mov      x29, x29
0x00053af0  bl       #0x55dfc   ; CALL _objc_unsafeClaimAutoreleasedReturnValue
0x00053af4  mov      x0, x22
0x00053af8  bl       #0x55d78   ; CALL _objc_release
0x00053afc  mov      x0, x28
0x00053b00  bl       #0x55d78   ; CALL _objc_release
0x00053b04  mov      x0, x27
0x00053b08  bl       #0x55d78   ; CALL _objc_release
0x00053b0c  mov      x0, x25
0x00053b10  bl       #0x55d78   ; CALL _objc_release
0x00053b14  mov      x0, x26
0x00053b18  bl       #0x55d78   ; CALL _objc_release
0x00053b1c  mov      x0, x19
0x00053b20  bl       #0x55d78   ; CALL _objc_release
0x00053b24  mov      x0, x24
0x00053b28  bl       #0x55d78   ; CALL _objc_release
0x00053b2c  ldr      x0, [sp, #8]
0x00053b30  bl       #0x55d78   ; CALL _objc_release
0x00053b34  ldr      x0, [sp, #0x18]
0x00053b38  bl       #0x55d78   ; CALL _objc_release
0x00053b3c  ldur     x8, [x29, #-0xa0]
0x00053b40  adrp     x9, #0x74000
0x00053b44  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00053b48  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00053b4c  cmp      x9, x8
0x00053b50  b.ne     #0x53b84
0x00053b54  ldp      x29, x30, [sp, #0x180]
0x00053b58  ldp      x20, x19, [sp, #0x170]
0x00053b5c  ldp      x22, x21, [sp, #0x160]
0x00053b60  ldp      x24, x23, [sp, #0x150]
0x00053b64  ldp      x26, x25, [sp, #0x140]
0x00053b68  ldp      x28, x27, [sp, #0x130]
0x00053b6c  ldp      d9, d8, [sp, #0x120]
0x00053b70  ldp      d11, d10, [sp, #0x110]
0x00053b74  ldp      d13, d12, [sp, #0x100]
0x00053b78  ldp      d15, d14, [sp, #0xf0]
0x00053b7c  add      sp, sp, #0x190
0x00053b80  ret      
0x00053b84  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[SSStartupView ss_drawFireworks:t:]  va=0x53b88 size=960 types=v32@0:8^{CGContext=}16d24
0x00053b88  sub      sp, sp, #0x150
0x00053b8c  stp      d15, d14, [sp, #0xb0]
0x00053b90  stp      d13, d12, [sp, #0xc0]
0x00053b94  stp      d11, d10, [sp, #0xd0]
0x00053b98  stp      d9, d8, [sp, #0xe0]
0x00053b9c  stp      x28, x27, [sp, #0xf0]
0x00053ba0  stp      x26, x25, [sp, #0x100]
0x00053ba4  stp      x24, x23, [sp, #0x110]
0x00053ba8  stp      x22, x21, [sp, #0x120]
0x00053bac  stp      x20, x19, [sp, #0x130]
0x00053bb0  stp      x29, x30, [sp, #0x140]
0x00053bb4  add      x29, sp, #0x140
0x00053bb8  str      d0, [sp, #0x80]
0x00053bbc  mov      x19, x2
0x00053bc0  mov      x21, x0
0x00053bc4  adrp     x8, #0x74000
0x00053bc8  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00053bcc  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00053bd0  str      x8, [sp, #0xa0]
0x00053bd4  adrp     x8, #0x8f000
0x00053bd8  ldrsw    x20, [x8, #0x98]
0x00053bdc  ldr      x0, [x0, x20]
0x00053be0  bl       #0x58c20   ; CALL objc_msgSend$length
0x00053be4  cmp      x0, #0x20
0x00053be8  b.lo     #0x53efc
0x00053bec  lsr      x22, x0, #5
0x00053bf0  ldr      x0, [x21, x20]
0x00053bf4  bl       #0x56ba0   ; CALL objc_msgSend$bytes
0x00053bf8  mov      x20, x0
0x00053bfc  adrp     x8, #0x8f000
0x00053c00  ldrsw    x8, [x8, #0xcc]
0x00053c04  ldr      d10, [x21, x8]
0x00053c08  adrp     x8, #0x8f000
0x00053c0c  ldrsw    x8, [x8, #0x54]
0x00053c10  add      x8, x21, x8
0x00053c14  ldp      d1, d0, [x8]
0x00053c18  str      d1, [sp, #0x58]
0x00053c1c  str      d0, [sp, #0x70]
0x00053c20  adrp     x8, #0x66000
0x00053c24  ldr      d0, [x8, #0xc8]
0x00053c28  fmul     d0, d10, d0
0x00053c2c  fmov     d1, #1.50000000
0x00053c30  fmaxnm   d12, d0, d1
0x00053c34  mov      x0, x19
0x00053c38  mov      w1, #0x1b
0x00053c3c  bl       #0x55988   ; CALL _CGContextSetBlendMode
0x00053c40  mov      x21, #0
0x00053c44  fadd     d9, d12, d12
0x00053c48  fmov     d0, #4.00000000
0x00053c4c  fmul     d1, d10, d0
0x00053c50  fmov     d0, #14.00000000
0x00053c54  fmul     d0, d10, d0
0x00053c58  stp      d0, d1, [sp, #0x48]
0x00053c5c  adrp     x8, #0x66000
0x00053c60  ldr      d0, [x8, #0x260]
0x00053c64  str      d0, [sp, #0x78]
0x00053c68  adrp     x8, #0x66000
0x00053c6c  ldr      d0, [x8, #0x268]
0x00053c70  str      d0, [sp, #0x40]
0x00053c74  adrp     x8, #0x66000
0x00053c78  ldr      d0, [x8, #0x270]
0x00053c7c  str      d0, [sp, #0x38]
0x00053c80  adrp     x8, #0x66000
0x00053c84  ldr      d0, [x8, #0x278]
0x00053c88  str      d0, [sp, #0x30]
0x00053c8c  adrp     x8, #0x66000
0x00053c90  ldr      d0, [x8, #0x280]
0x00053c94  str      d0, [sp, #0x28]
0x00053c98  adrp     x8, #0x65000
0x00053c9c  ldr      d0, [x8, #0x6b8]
0x00053ca0  str      d0, [sp, #0x20]
0x00053ca4  adrp     x8, #0x66000
0x00053ca8  ldr      d0, [x8, #0x200]
0x00053cac  str      d0, [sp, #0x18]
0x00053cb0  adrp     x8, #0x65000
0x00053cb4  ldr      d0, [x8, #0x780]
0x00053cb8  str      d0, [sp, #0x68]
0x00053cbc  fmov     d3, #1.00000000
0x00053cc0  adrp     x8, #0x65000
0x00053cc4  ldr      d0, [x8, #0xa68]
0x00053cc8  str      d0, [sp, #0x10]
0x00053ccc  adrp     x8, #0x66000
0x00053cd0  ldr      d0, [x8, #0xe8]
0x00053cd4  str      d0, [sp, #8]
0x00053cd8  adrp     x8, #0x65000
0x00053cdc  ldr      d0, [x8, #0x708]
0x00053ce0  str      d0, [sp]
0x00053ce4  adrp     x25, #0x66000
0x00053ce8  adrp     x26, #0x65000
0x00053cec  mov      x27, #0x404e000000000000
0x00053cf0  adrp     x28, #0x65000
0x00053cf4  adrp     x23, #0x65000
0x00053cf8  add      x8, x20, x21, lsl #5
0x00053cfc  ldr      d0, [x8, #0x10]
0x00053d00  ldr      d1, [sp, #0x80]
0x00053d04  fcmp     d1, d0
0x00053d08  b.mi     #0x53ef0
0x00053d0c  ldp      d2, d1, [sp, #0x78]
0x00053d10  fsub     d1, d1, d0
0x00053d14  fdiv     d0, d1, d2
0x00053d18  frintm   d0, d0
0x00053d1c  fmsub    d8, d0, d2, d1
0x00053d20  fmov     d1, #2.00000000
0x00053d24  fcmp     d8, d1
0x00053d28  b.gt     #0x53ef0
0x00053d2c  ldr      d11, [x8, #0x18]   ; @CSTR "r car is ready, %@"
0x00053d30  fcmp     d0, #0.0
0x00053d34  b.le     #0x53d9c
0x00053d38  add      x8, x21, #1
0x00053d3c  ucvtf    d1, x8
0x00053d40  ldp      d2, d3, [sp, #0x38]
0x00053d44  fmul     d0, d0, d3
0x00053d48  fmadd    d0, d1, d2, d0
0x00053d4c  bl       #0x55e20   ; CALL _sin
0x00053d50  fmov     d3, #1.00000000
0x00053d54  ldr      d1, [sp, #0x30]
0x00053d58  fmul     d0, d0, d1
0x00053d5c  frintm   d1, d0
0x00053d60  fsub     d0, d0, d1
0x00053d64  fmov     d1, #0.12500000
0x00053d68  fmov     d2, #0.75000000
0x00053d6c  fmadd    d1, d0, d2, d1
0x00053d70  ldr      d2, [sp, #0x58]
0x00053d74  fmul     d14, d2, d1
0x00053d78  ldr      d1, [sp, #0x28]
0x00053d7c  fmul     d0, d0, d1
0x00053d80  frintm   d1, d0
0x00053d84  fsub     d0, d0, d1
0x00053d88  ldp      d2, d1, [sp, #0x18]
0x00053d8c  fmadd    d0, d0, d2, d1
0x00053d90  ldr      d1, [sp, #0x70]
0x00053d94  fmul     d15, d1, d0
0x00053d98  b        #0x53da0
0x00053d9c  ldp      d14, d15, [x8]
0x00053da0  ldr      d0, [sp, #0x68]
0x00053da4  fcmp     d8, d0
0x00053da8  b.pl     #0x53e18
0x00053dac  ldr      d13, [sp, #0x70]
0x00053db0  fsub     d11, d13, d15
0x00053db4  fdiv     d8, d8, d0
0x00053db8  fcmp     d8, d3
0x00053dbc  fcsel    d0, d3, d8, gt
0x00053dc0  fsub     d0, d3, d0
0x00053dc4  fmov     d1, #3.00000000
0x00053dc8  fmov     d15, #1.00000000
0x00053dcc  bl       #0x55e14   ; CALL _pow
0x00053dd0  fsub     d0, d15, d0
0x00053dd4  fcmp     d8, #0.0
0x00053dd8  fmov     d1, xzr
0x00053ddc  fcsel    d0, d1, d0, mi
0x00053de0  fmsub    d15, d11, d0, d13
0x00053de4  fmov     d0, #1.00000000
0x00053de8  mov      x0, x19
0x00053dec  ldp      d2, d1, [sp, #8]
0x00053df0  ldr      d3, [sp]
0x00053df4  bl       #0x559ac   ; CALL _CGContextSetRGBFillColor
0x00053df8  fmov     d0, #-2.00000000
0x00053dfc  fmadd    d0, d10, d0, d14
0x00053e00  mov      x0, x19
0x00053e04  mov      v1.16b, v15.16b
0x00053e08  ldp      d3, d2, [sp, #0x48]
0x00053e0c  bl       #0x55940   ; CALL _CGContextFillRect
0x00053e10  fmov     d3, #1.00000000
0x00053e14  b        #0x53ef0
0x00053e18  adrp     x8, #0x66000
0x00053e1c  ldr      d0, [x8, #0x68]
0x00053e20  fadd     d0, d8, d0
0x00053e24  adrp     x8, #0x65000
0x00053e28  ldr      d1, [x8, #0x610]
0x00053e2c  str      d11, [sp, #0x60]
0x00053e30  fdiv     d11, d0, d1
0x00053e34  fcmp     d11, d3
0x00053e38  fcsel    d0, d3, d11, gt
0x00053e3c  fsub     d0, d3, d0
0x00053e40  fmov     d1, #3.00000000
0x00053e44  bl       #0x55e14   ; CALL _pow
0x00053e48  fmov     d1, #1.00000000
0x00053e4c  fsub     d0, d1, d0
0x00053e50  ldr      d1, [x25, #0x288]
0x00053e54  fmul     d0, d0, d1
0x00053e58  fcmp     d11, #0.0
0x00053e5c  fmov     d13, xzr
0x00053e60  fcsel    d0, d13, d0, mi
0x00053e64  fmul     d8, d10, d0
0x00053e68  ldr      d2, [x26, #0x998]
0x00053e6c  fmov     d1, #1.00000000
0x00053e70  add      x0, sp, #0x88
0x00053e74  ldr      d0, [sp, #0x60]
0x00053e78  bl       #0x4f5e4
0x00053e7c  ldp      d0, d1, [sp, #0x88]
0x00053e80  fmov     d2, #1.00000000
0x00053e84  fsub     d3, d2, d11
0x00053e88  ldr      d2, [sp, #0x98]
0x00053e8c  mov      x0, x19
0x00053e90  bl       #0x559ac   ; CALL _CGContextSetRGBFillColor
0x00053e94  fmul     d0, d11, d11
0x00053e98  fmov     d1, x27
0x00053e9c  fmul     d11, d0, d1
0x00053ea0  mov      w24, #0x46
0x00053ea4  ldr      d0, [x28, #0xa00]
0x00053ea8  fdiv     d0, d13, d0
0x00053eac  ldr      d1, [x23, #0x930]
0x00053eb0  fmul     d0, d0, d1
0x00053eb4  fadd     d0, d0, d0
0x00053eb8  bl       #0x55b8c   ; CALL ___sincos_stret
0x00053ebc  fmadd    d1, d1, d8, d14
0x00053ec0  fmadd    d0, d0, d8, d15
0x00053ec4  fmadd    d2, d11, d10, d0
0x00053ec8  fsub     d0, d1, d12
0x00053ecc  fsub     d1, d2, d12
0x00053ed0  mov      x0, x19
0x00053ed4  mov      v2.16b, v9.16b
0x00053ed8  mov      v3.16b, v9.16b
0x00053edc  bl       #0x55934   ; CALL _CGContextFillEllipseInRect
0x00053ee0  fmov     d3, #1.00000000
0x00053ee4  fadd     d13, d13, d3
0x00053ee8  subs     w24, w24, #1
0x00053eec  b.ne     #0x53ea4
0x00053ef0  add      x21, x21, #1
0x00053ef4  cmp      x21, x22
0x00053ef8  b.ne     #0x53cf8
0x00053efc  ldr      x8, [sp, #0xa0]
0x00053f00  adrp     x9, #0x74000
0x00053f04  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00053f08  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00053f0c  cmp      x9, x8
0x00053f10  b.ne     #0x53f44
0x00053f14  ldp      x29, x30, [sp, #0x140]
0x00053f18  ldp      x20, x19, [sp, #0x130]
0x00053f1c  ldp      x22, x21, [sp, #0x120]
0x00053f20  ldp      x24, x23, [sp, #0x110]
0x00053f24  ldp      x26, x25, [sp, #0x100]
0x00053f28  ldp      x28, x27, [sp, #0xf0]
0x00053f2c  ldp      d9, d8, [sp, #0xe0]
0x00053f30  ldp      d11, d10, [sp, #0xd0]
0x00053f34  ldp      d13, d12, [sp, #0xc0]
0x00053f38  ldp      d15, d14, [sp, #0xb0]
0x00053f3c  add      sp, sp, #0x150
0x00053f40  ret      
0x00053f44  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[SSStartupView ss_drawCanvas:size:]  va=0x53f48 size=152 types=v40@0:8^{CGContext=}16{CGSize=dd}24
0x00053f48  stp      d9, d8, [sp, #-0x30]!
0x00053f4c  stp      x20, x19, [sp, #0x10]
0x00053f50  stp      x29, x30, [sp, #0x20]
0x00053f54  add      x29, sp, #0x20
0x00053f58  cbz      x2, #0x53fd0
0x00053f5c  mov      x20, x0
0x00053f60  adrp     x8, #0x8f000
0x00053f64  ldrsw    x8, [x8, #0x70]
0x00053f68  ldrb     w8, [x0, x8]
0x00053f6c  cmp      w8, #1
0x00053f70  b.ne     #0x53fd0
0x00053f74  mov      x19, x2
0x00053f78  mov      x0, x20
0x00053f7c  bl       #0x5d1e0   ; CALL objc_msgSend$ss_now
0x00053f80  mov      v8.16b, v0.16b
0x00053f84  adrp     x8, #0x8f000
0x00053f88  ldrsw    x8, [x8, #0x94]
0x00053f8c  ldr      x8, [x20, x8]
0x00053f90  cbz      x8, #0x53fa4
0x00053f94  mov      x0, x20
0x00053f98  mov      x2, x19
0x00053f9c  mov      v0.16b, v8.16b
0x00053fa0  bl       #0x5d140   ; CALL objc_msgSend$ss_drawParticles:t:
0x00053fa4  adrp     x8, #0x8f000
0x00053fa8  ldrsw    x8, [x8, #0x98]
0x00053fac  ldr      x8, [x20, x8]
0x00053fb0  cbz      x8, #0x53fd0
0x00053fb4  mov      x0, x20
0x00053fb8  mov      x2, x19
0x00053fbc  mov      v0.16b, v8.16b
0x00053fc0  ldp      x29, x30, [sp, #0x20]
0x00053fc4  ldp      x20, x19, [sp, #0x10]
0x00053fc8  ldp      d9, d8, [sp], #0x30
0x00053fcc  b        #0x5d120   ; CALL objc_msgSend$ss_drawFireworks:t:
0x00053fd0  ldp      x29, x30, [sp, #0x20]
0x00053fd4  ldp      x20, x19, [sp, #0x10]
0x00053fd8  ldp      d9, d8, [sp], #0x30
0x00053fdc  ret      

=== -[SSStartupView style]  va=0x53fe0 size=16 types=q16@0:8
0x00053fe0  adrp     x8, #0x8f000
0x00053fe4  ldrsw    x8, [x8, #0xe4]
0x00053fe8  ldr      x0, [x0, x8]
0x00053fec  ret      

=== -[SSStartupView setStyle:]  va=0x53ff0 size=16 types=v24@0:8q16
0x00053ff0  adrp     x8, #0x8f000
0x00053ff4  ldrsw    x8, [x8, #0xe4]
0x00053ff8  str      x2, [x0, x8]
0x00053ffc  ret      

=== -[SSStartupView image]  va=0x54000 size=16 types=@16@0:8
0x00054000  adrp     x8, #0x8f000
0x00054004  ldrsw    x8, [x8, #0xe8]
0x00054008  ldr      x0, [x0, x8]
0x0005400c  ret      

=== -[SSStartupView setImage:]  va=0x54010 size=64 types=v24@0:8@16
0x00054010  stp      x22, x21, [sp, #-0x30]!
0x00054014  stp      x20, x19, [sp, #0x10]
0x00054018  stp      x29, x30, [sp, #0x20]
0x0005401c  add      x29, sp, #0x20
0x00054020  mov      x19, x2
0x00054024  mov      x20, x0
0x00054028  adrp     x8, #0x8f000
0x0005402c  ldrsw    x21, [x8, #0xe8]
0x00054030  mov      x0, x2
0x00054034  bl       #0x55d84   ; CALL _objc_retain
0x00054038  ldr      x0, [x20, x21]
0x0005403c  str      x19, [x20, x21]
0x00054040  ldp      x29, x30, [sp, #0x20]
0x00054044  ldp      x20, x19, [sp, #0x10]
0x00054048  ldp      x22, x21, [sp], #0x30
0x0005404c  b        #0x55d78   ; CALL _objc_release

=== -[SSStartupView imageFits]  va=0x54050 size=16 types=B16@0:8
0x00054050  adrp     x8, #0x8f000
0x00054054  ldrsw    x8, [x8, #0xec]
0x00054058  ldrb     w0, [x0, x8]
0x0005405c  ret      

=== -[SSStartupView setImageFits:]  va=0x54060 size=16 types=v20@0:8B16
0x00054060  adrp     x8, #0x8f000
0x00054064  ldrsw    x8, [x8, #0xec]
0x00054068  strb     w2, [x0, x8]
0x0005406c  ret      

=== -[SSStartupView logoEffect]  va=0x54070 size=16 types=q16@0:8
0x00054070  adrp     x8, #0x8f000
0x00054074  ldrsw    x8, [x8, #0xf0]
0x00054078  ldr      x0, [x0, x8]
0x0005407c  ret      

=== -[SSStartupView setLogoEffect:]  va=0x54080 size=16 types=v24@0:8q16
0x00054080  adrp     x8, #0x8f000
0x00054084  ldrsw    x8, [x8, #0xf0]
0x00054088  str      x2, [x0, x8]
0x0005408c  ret      

=== -[SSStartupView name]  va=0x54090 size=16 types=@16@0:8
0x00054090  adrp     x8, #0x8f000
0x00054094  ldrsw    x8, [x8, #0xf4]
0x00054098  ldr      x0, [x0, x8]
0x0005409c  ret      

=== -[SSStartupView setName:]  va=0x540a0 size=12 types=v24@0:8@16
0x000540a0  adrp     x8, #0x8f000
0x000540a4  ldrsw    x3, [x8, #0xf4]
0x000540a8  b        #0x55dc0   ; CALL _objc_setProperty_nonatomic_copy

=== -[SSStartupView weather]  va=0x540ac size=16 types=@16@0:8
0x000540ac  adrp     x8, #0x8f000
0x000540b0  ldrsw    x8, [x8, #0xf8]
0x000540b4  ldr      x0, [x0, x8]
0x000540b8  ret      

=== -[SSStartupView setWeather:]  va=0x540bc size=12 types=v24@0:8@16
0x000540bc  adrp     x8, #0x8f000
0x000540c0  ldrsw    x3, [x8, #0xf8]
0x000540c4  b        #0x55dc0   ; CALL _objc_setProperty_nonatomic_copy

=== -[SSStartupView date]  va=0x540c8 size=16 types=@16@0:8
0x000540c8  adrp     x8, #0x8f000
0x000540cc  ldrsw    x8, [x8, #0xfc]
0x000540d0  ldr      x0, [x0, x8]
0x000540d4  ret      

=== -[SSStartupView setDate:]  va=0x540d8 size=64 types=v24@0:8@16
0x000540d8  stp      x22, x21, [sp, #-0x30]!
0x000540dc  stp      x20, x19, [sp, #0x10]
0x000540e0  stp      x29, x30, [sp, #0x20]
0x000540e4  add      x29, sp, #0x20
0x000540e8  mov      x19, x2
0x000540ec  mov      x20, x0
0x000540f0  adrp     x8, #0x8f000
0x000540f4  ldrsw    x21, [x8, #0xfc]
0x000540f8  mov      x0, x2
0x000540fc  bl       #0x55d84   ; CALL _objc_retain
0x00054100  ldr      x0, [x20, x21]
0x00054104  str      x19, [x20, x21]
0x00054108  ldp      x29, x30, [sp, #0x20]
0x0005410c  ldp      x20, x19, [sp, #0x10]
0x00054110  ldp      x22, x21, [sp], #0x30
0x00054114  b        #0x55d78   ; CALL _objc_release

=== -[SSStartupView carName]  va=0x54118 size=16 types=@16@0:8
0x00054118  adrp     x8, #0x8f000
0x0005411c  ldrsw    x8, [x8, #0x100]
0x00054120  ldr      x0, [x0, x8]
0x00054124  ret      

=== -[SSStartupView setCarName:]  va=0x54128 size=12 types=v24@0:8@16
0x00054128  adrp     x8, #0x8f000
0x0005412c  ldrsw    x3, [x8, #0x100]
0x00054130  b        #0x55dc0   ; CALL _objc_setProperty_nonatomic_copy

=== -[SSStartupView tempo]  va=0x54134 size=16 types=q16@0:8
0x00054134  adrp     x8, #0x8e000
0x00054138  ldrsw    x8, [x8, #0xff8]
0x0005413c  ldr      x0, [x0, x8]
0x00054140  ret      

=== -[SSStartupView setTempo:]  va=0x54144 size=16 types=v24@0:8q16
0x00054144  adrp     x8, #0x8e000
0x00054148  ldrsw    x8, [x8, #0xff8]
0x0005414c  str      x2, [x0, x8]
0x00054150  ret      

=== -[SSStartupView occasion]  va=0x54154 size=16 types=q16@0:8
0x00054154  adrp     x8, #0x8f000
0x00054158  ldrsw    x8, [x8, #0x104]
0x0005415c  ldr      x0, [x0, x8]
0x00054160  ret      

=== -[SSStartupView setOccasion:]  va=0x54164 size=16 types=v24@0:8q16
0x00054164  adrp     x8, #0x8f000
0x00054168  ldrsw    x8, [x8, #0x104]
0x0005416c  str      x2, [x0, x8]
0x00054170  ret      

=== -[SSStartupView hud]  va=0x54174 size=16 types=@16@0:8
0x00054174  adrp     x8, #0x8f000
0x00054178  ldrsw    x8, [x8, #0x108]
0x0005417c  ldr      x0, [x0, x8]
0x00054180  ret      

=== -[SSStartupView setHud:]  va=0x54184 size=12 types=v24@0:8@16
0x00054184  adrp     x8, #0x8f000
0x00054188  ldrsw    x3, [x8, #0x108]
0x0005418c  b        #0x55dc0   ; CALL _objc_setProperty_nonatomic_copy

=== -[SSStartupView nextEvent]  va=0x54190 size=16 types=@16@0:8
0x00054190  adrp     x8, #0x8f000
0x00054194  ldrsw    x8, [x8, #0x10c]
0x00054198  ldr      x0, [x0, x8]
0x0005419c  ret      

=== -[SSStartupView setNextEvent:]  va=0x541a0 size=12 types=v24@0:8@16
0x000541a0  adrp     x8, #0x8f000
0x000541a4  ldrsw    x3, [x8, #0x10c]
0x000541a8  b        #0x55dc0   ; CALL _objc_setProperty_nonatomic_copy

=== -[SSStartupView batteryPercent]  va=0x541ac size=16 types=q16@0:8
0x000541ac  adrp     x8, #0x8e000
0x000541b0  ldrsw    x8, [x8, #0xff4]
0x000541b4  ldr      x0, [x0, x8]
0x000541b8  ret      

=== -[SSStartupView setBatteryPercent:]  va=0x541bc size=16 types=v24@0:8q16
0x000541bc  adrp     x8, #0x8e000
0x000541c0  ldrsw    x8, [x8, #0xff4]
0x000541c4  str      x2, [x0, x8]
0x000541c8  ret      

=== -[SSStartupView duration]  va=0x541cc size=16 types=d16@0:8
0x000541cc  adrp     x8, #0x8f000
0x000541d0  ldrsw    x8, [x8, #0x110]
0x000541d4  ldr      d0, [x0, x8]
0x000541d8  ret      

=== -[SSStartupView setDuration:]  va=0x541dc size=16 types=v24@0:8d16
0x000541dc  adrp     x8, #0x8f000
0x000541e0  ldrsw    x8, [x8, #0x110]
0x000541e4  str      d0, [x0, x8]
0x000541e8  ret      

=== -[SSStartupView .cxx_destruct]  va=0x541ec size=964 types=v16@0:8
0x000541ec  stp      x20, x19, [sp, #-0x20]!
0x000541f0  stp      x29, x30, [sp, #0x10]
0x000541f4  add      x29, sp, #0x10
0x000541f8  mov      x19, x0
0x000541fc  adrp     x8, #0x8f000
0x00054200  ldrsw    x8, [x8, #0x10c]
0x00054204  add      x0, x0, x8
0x00054208  mov      x1, #0
0x0005420c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054210  adrp     x8, #0x8f000
0x00054214  ldrsw    x8, [x8, #0x108]
0x00054218  add      x0, x19, x8
0x0005421c  mov      x1, #0
0x00054220  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054224  adrp     x8, #0x8f000
0x00054228  ldrsw    x8, [x8, #0x100]
0x0005422c  add      x0, x19, x8
0x00054230  mov      x1, #0
0x00054234  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054238  adrp     x8, #0x8f000
0x0005423c  ldrsw    x8, [x8, #0xfc]
0x00054240  add      x0, x19, x8
0x00054244  mov      x1, #0
0x00054248  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0005424c  adrp     x8, #0x8f000
0x00054250  ldrsw    x8, [x8, #0xf8]
0x00054254  add      x0, x19, x8
0x00054258  mov      x1, #0
0x0005425c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054260  adrp     x8, #0x8f000
0x00054264  ldrsw    x8, [x8, #0xf4]
0x00054268  add      x0, x19, x8
0x0005426c  mov      x1, #0
0x00054270  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054274  adrp     x8, #0x8f000
0x00054278  ldrsw    x8, [x8, #0xe8]
0x0005427c  add      x0, x19, x8
0x00054280  mov      x1, #0
0x00054284  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054288  adrp     x8, #0x8f000
0x0005428c  ldrsw    x8, [x8, #0xc4]
0x00054290  add      x0, x19, x8
0x00054294  mov      x1, #0
0x00054298  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0005429c  adrp     x8, #0x8f000
0x000542a0  ldrsw    x8, [x8, #0x90]
0x000542a4  add      x0, x19, x8
0x000542a8  mov      x1, #0
0x000542ac  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000542b0  adrp     x8, #0x8f000
0x000542b4  ldrsw    x8, [x8, #0xbc]
0x000542b8  add      x0, x19, x8
0x000542bc  mov      x1, #0
0x000542c0  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000542c4  adrp     x8, #0x8f000
0x000542c8  ldrsw    x8, [x8, #0xa4]
0x000542cc  add      x0, x19, x8
0x000542d0  mov      x1, #0
0x000542d4  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000542d8  adrp     x8, #0x8f000
0x000542dc  ldrsw    x8, [x8, #0xa8]
0x000542e0  add      x0, x19, x8
0x000542e4  mov      x1, #0
0x000542e8  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000542ec  adrp     x8, #0x8f000
0x000542f0  ldrsw    x8, [x8, #0xac]
0x000542f4  add      x0, x19, x8
0x000542f8  mov      x1, #0
0x000542fc  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054300  adrp     x8, #0x8f000
0x00054304  ldrsw    x8, [x8, #0xb0]
0x00054308  add      x0, x19, x8
0x0005430c  mov      x1, #0
0x00054310  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054314  adrp     x8, #0x8f000
0x00054318  ldrsw    x8, [x8, #0xb4]
0x0005431c  add      x0, x19, x8
0x00054320  mov      x1, #0
0x00054324  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054328  adrp     x8, #0x8f000
0x0005432c  ldrsw    x8, [x8, #0xb8]
0x00054330  add      x0, x19, x8
0x00054334  mov      x1, #0
0x00054338  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0005433c  adrp     x8, #0x8f000
0x00054340  ldrsw    x8, [x8, #0x9c]
0x00054344  add      x0, x19, x8
0x00054348  mov      x1, #0
0x0005434c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054350  adrp     x8, #0x8f000
0x00054354  ldrsw    x8, [x8, #0xa0]
0x00054358  add      x0, x19, x8
0x0005435c  mov      x1, #0
0x00054360  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054364  adrp     x8, #0x8f000
0x00054368  ldrsw    x8, [x8, #0x98]
0x0005436c  add      x0, x19, x8
0x00054370  mov      x1, #0
0x00054374  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054378  adrp     x8, #0x8f000
0x0005437c  ldrsw    x8, [x8, #0x94]
0x00054380  add      x0, x19, x8
0x00054384  mov      x1, #0
0x00054388  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0005438c  adrp     x8, #0x8f000
0x00054390  ldrsw    x8, [x8, #0x8c]
0x00054394  add      x0, x19, x8
0x00054398  mov      x1, #0
0x0005439c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000543a0  adrp     x8, #0x8f000
0x000543a4  ldrsw    x8, [x8, #0x88]
0x000543a8  add      x0, x19, x8
0x000543ac  mov      x1, #0
0x000543b0  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000543b4  adrp     x8, #0x8f000
0x000543b8  ldrsw    x8, [x8, #0x84]
0x000543bc  add      x0, x19, x8
0x000543c0  mov      x1, #0
0x000543c4  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000543c8  adrp     x8, #0x8f000
0x000543cc  ldrsw    x8, [x8, #0x74]
0x000543d0  add      x0, x19, x8
0x000543d4  mov      x1, #0
0x000543d8  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000543dc  adrp     x8, #0x8f000
0x000543e0  ldrsw    x8, [x8, #0x78]
0x000543e4  add      x0, x19, x8
0x000543e8  mov      x1, #0
0x000543ec  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000543f0  adrp     x8, #0x8f000
0x000543f4  ldrsw    x8, [x8, #0x80]
0x000543f8  add      x0, x19, x8
0x000543fc  mov      x1, #0
0x00054400  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054404  adrp     x8, #0x8f000
0x00054408  ldrsw    x8, [x8, #0x7c]
0x0005440c  add      x0, x19, x8
0x00054410  mov      x1, #0
0x00054414  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054418  adrp     x8, #0x8f000
0x0005441c  ldrsw    x8, [x8]
0x00054420  add      x0, x19, x8
0x00054424  mov      x1, #0
0x00054428  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0005442c  adrp     x8, #0x8f000
0x00054430  ldrsw    x8, [x8, #0x4c]
0x00054434  add      x0, x19, x8
0x00054438  mov      x1, #0
0x0005443c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054440  adrp     x8, #0x8f000
0x00054444  ldrsw    x8, [x8, #0x40]
0x00054448  add      x0, x19, x8
0x0005444c  mov      x1, #0
0x00054450  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054454  adrp     x8, #0x8f000
0x00054458  ldrsw    x8, [x8, #0x44]
0x0005445c  add      x0, x19, x8
0x00054460  mov      x1, #0
0x00054464  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054468  adrp     x8, #0x8f000
0x0005446c  ldrsw    x8, [x8, #0x48]
0x00054470  add      x0, x19, x8
0x00054474  mov      x1, #0
0x00054478  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0005447c  adrp     x8, #0x8f000
0x00054480  ldrsw    x8, [x8, #0x3c]
0x00054484  add      x0, x19, x8
0x00054488  mov      x1, #0
0x0005448c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054490  adrp     x8, #0x8f000
0x00054494  ldrsw    x8, [x8, #4]
0x00054498  add      x0, x19, x8
0x0005449c  mov      x1, #0
0x000544a0  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000544a4  adrp     x8, #0x8f000
0x000544a8  ldrsw    x8, [x8, #8]
0x000544ac  add      x0, x19, x8
0x000544b0  mov      x1, #0
0x000544b4  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000544b8  adrp     x8, #0x8f000
0x000544bc  ldrsw    x8, [x8, #0x10]
0x000544c0  add      x0, x19, x8
0x000544c4  mov      x1, #0
0x000544c8  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000544cc  adrp     x8, #0x8f000
0x000544d0  ldrsw    x8, [x8, #0x28]
0x000544d4  add      x0, x19, x8
0x000544d8  mov      x1, #0
0x000544dc  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000544e0  adrp     x8, #0x8f000
0x000544e4  ldrsw    x8, [x8, #0x2c]
0x000544e8  add      x0, x19, x8
0x000544ec  mov      x1, #0
0x000544f0  bl       #0x55dcc   ; CALL _objc_storeStrong
0x000544f4  adrp     x8, #0x8f000
0x000544f8  ldrsw    x8, [x8, #0x30]
0x000544fc  add      x0, x19, x8
0x00054500  mov      x1, #0
0x00054504  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054508  adrp     x8, #0x8f000
0x0005450c  ldrsw    x8, [x8, #0x34]
0x00054510  add      x0, x19, x8
0x00054514  mov      x1, #0
0x00054518  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0005451c  adrp     x8, #0x8f000
0x00054520  ldrsw    x8, [x8, #0x38]
0x00054524  add      x0, x19, x8
0x00054528  mov      x1, #0
0x0005452c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054530  adrp     x8, #0x8f000
0x00054534  ldrsw    x8, [x8, #0x1c]
0x00054538  add      x0, x19, x8
0x0005453c  mov      x1, #0
0x00054540  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054544  adrp     x8, #0x8f000
0x00054548  ldrsw    x8, [x8, #0x20]
0x0005454c  add      x0, x19, x8
0x00054550  mov      x1, #0
0x00054554  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054558  adrp     x8, #0x8f000
0x0005455c  ldrsw    x8, [x8, #0x24]
0x00054560  add      x0, x19, x8
0x00054564  mov      x1, #0
0x00054568  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0005456c  adrp     x8, #0x8f000
0x00054570  ldrsw    x8, [x8, #0x14]
0x00054574  add      x0, x19, x8
0x00054578  mov      x1, #0
0x0005457c  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054580  adrp     x8, #0x8f000
0x00054584  ldrsw    x8, [x8, #0x18]
0x00054588  add      x0, x19, x8
0x0005458c  mov      x1, #0
0x00054590  bl       #0x55dcc   ; CALL _objc_storeStrong
0x00054594  adrp     x8, #0x8f000
0x00054598  ldrsw    x8, [x8, #0xc]
0x0005459c  add      x0, x19, x8
0x000545a0  mov      x1, #0
0x000545a4  ldp      x29, x30, [sp, #0x10]
0x000545a8  ldp      x20, x19, [sp], #0x20
0x000545ac  b        #0x55dcc   ; CALL _objc_storeStrong
