; ==== sub_22580 @ 0x22580..0x22c70 (1776 bytes) ====
0x00022580  b        #0x2480c   ; call _objc_release
0x00022584  sub      sp, sp, #0x80
0x00022588  stp      x26, x25, [sp, #0x30]
0x0002258c  stp      x24, x23, [sp, #0x40]
0x00022590  stp      x22, x21, [sp, #0x50]
0x00022594  stp      x20, x19, [sp, #0x60]
0x00022598  stp      x29, x30, [sp, #0x70]
0x0002259c  add      x29, sp, #0x70
0x000225a0  adrp     x24, #0x3e000
0x000225a4  ldr      x8, [x24, #0xac8]
0x000225a8  cbz      x8, #0x229c0
0x000225ac  ldp      d3, d2, [x0, #0x20]
0x000225b0  ldp      d1, d0, [x0, #0x30]
0x000225b4  adrp     x23, #0x3e000
0x000225b8  ldr      x8, [x23, #0xbc0]
0x000225bc  add      x8, x8, #1
0x000225c0  str      x8, [x23, #0xbc0]
0x000225c4  fcmp     d3, #0.0
0x000225c8  b.lt     #0x225f0
0x000225cc  adrp     x8, #0x3e000
0x000225d0  ldr      d4, [x8, #0xba8]
0x000225d4  fadd     d4, d3, d4
0x000225d8  str      d4, [x8, #0xba8]
0x000225dc  adrp     x8, #0x3e000
0x000225e0  ldr      d4, [x8, #0xba0]
0x000225e4  fcmp     d4, d3
0x000225e8  fcsel    d3, d3, d4, mi
0x000225ec  str      d3, [x8, #0xba0]
0x000225f0  fcmp     d2, #0.0
0x000225f4  b.lt     #0x22614
0x000225f8  adrp     x8, #0x3e000
0x000225fc  str      d2, [x8, #0xb98]
0x00022600  adrp     x8, #0x3e000
0x00022604  ldr      d3, [x8, #0xb90]
0x00022608  fcmp     d3, d2
0x0002260c  fcsel    d2, d2, d3, mi
0x00022610  str      d2, [x8, #0xb90]
0x00022614  fcmp     d1, #0.0
0x00022618  b.le     #0x22630
0x0002261c  adrp     x8, #0x3e000
0x00022620  ldr      d2, [x8, #0xbb8]
0x00022624  fcmp     d2, d1
0x00022628  fcsel    d1, d2, d1, mi
0x0002262c  str      d1, [x8, #0xbb8]
0x00022630  fcmp     d0, #0.0
0x00022634  b.lt     #0x2264c
0x00022638  adrp     x8, #0x3e000
0x0002263c  ldr      d1, [x8, #0xbb0]
0x00022640  fcmp     d1, d0
0x00022644  fcsel    d0, d1, d0, mi
0x00022648  str      d0, [x8, #0xbb0]
0x0002264c  adrp     x8, #0x3e000
0x00022650  ldr      x0, [x8, #0x408]   ; -> [class(NSProcessInfo)]
0x00022654  bl       #0x266c0   ; objc_msgSend: processInfo
0x00022658  mov      x29, x29
0x0002265c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022660  mov      x19, x0
0x00022664  adrp     x20, #0x3e000
0x00022668  ldr      x21, [x20, #0xbc8]
0x0002266c  bl       #0x27f20   ; objc_msgSend: thermalState
0x00022670  cmp      x21, x0
0x00022674  csel     x8, x21, x0, gt
0x00022678  str      x8, [x20, #0xbc8]
0x0002267c  mov      x0, x19
0x00022680  bl       #0x25d60   ; objc_msgSend: isLowPowerModeEnabled
0x00022684  cbz      w0, #0x22694
0x00022688  adrp     x8, #0x3e000
0x0002268c  mov      w9, #1
0x00022690  strb     w9, [x8, #0xbd0]
0x00022694  ldrb     w8, [x23, #0xbc0]
0x00022698  tbnz     w8, #0, #0x226a8
0x0002269c  adrp     x0, #0x37000
0x000226a0  add      x0, x0, #0x70   ; -> @"com.anlai.omnicar"
0x000226a4  bl       #0x242b4   ; call _CFPreferencesAppSynchronize
0x000226a8  mov      x0, x19
0x000226ac  bl       #0x27f20   ; objc_msgSend: thermalState
0x000226b0  mov      x20, x0
0x000226b4  bl       #0x1d6e8   ; call _OMCEnabled
0x000226b8  cbz      w0, #0x227a4
0x000226bc  adrp     x0, #0x37000
0x000226c0  add      x0, x0, #0x910   ; -> @"liteMode"
0x000226c4  adrp     x1, #0x39000
0x000226c8  add      x1, x1, #0x600
0x000226cc  bl       #0x1d680   ; call _OMCPref
0x000226d0  mov      x29, x29
0x000226d4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000226d8  mov      x21, x0
0x000226dc  bl       #0x25bc0   ; objc_msgSend: integerValue
0x000226e0  mov      x22, x0
0x000226e4  mov      x0, x21
0x000226e8  bl       #0x2480c   ; call _objc_release
0x000226ec  cmp      x22, #2
0x000226f0  b.ne     #0x227a4
0x000226f4  bl       #0x2235c   ; call sub_2235c
0x000226f8  cmp      x20, #1
0x000226fc  b.le     #0x2270c
0x00022700  adrp     x1, #0x38000
0x00022704  add      x1, x1, #0x310   ; -> @"heat"
0x00022708  b        #0x227b8   ; call sub_227b8
0x0002270c  adrp     x8, #0x3e000
0x00022710  ldr      d1, [x8, #0xbf0]
0x00022714  fcmp     d1, #0.0
0x00022718  b.le     #0x2273c
0x0002271c  fsub     d1, d0, d1
0x00022720  mov      x8, #0x405e000000000000
0x00022724  fmov     d2, x8
0x00022728  fcmp     d1, d2
0x0002272c  b.pl     #0x2273c
0x00022730  adrp     x1, #0x38000
0x00022734  add      x1, x1, #0x330   ; -> @"hangs"
0x00022738  b        #0x227b8   ; call sub_227b8
0x0002273c  adrp     x8, #0x3e000
0x00022740  ldr      d1, [x8, #0xbe8]
0x00022744  fmov     d2, #15.00000000
0x00022748  fcmp     d1, d2
0x0002274c  b.ge     #0x227b0
0x00022750  adrp     x8, #0x3e000
0x00022754  ldr      d2, [x8, #0xc00]
0x00022758  fcmp     d2, #0.0
0x0002275c  adrp     x8, #0x2b000
0x00022760  b.eq     #0x22774
0x00022764  fsub     d2, d0, d2
0x00022768  ldr      d3, [x8, #0x440]
0x0002276c  fcmp     d2, d3
0x00022770  b.le     #0x227c0
0x00022774  fmov     d2, #5.00000000
0x00022778  fcmp     d1, d2
0x0002277c  b.pl     #0x227c0
0x00022780  adrp     x9, #0x3e000
0x00022784  ldrb     w9, [x9, #0xc10]
0x00022788  tbz      w9, #0, #0x227c0
0x0002278c  adrp     x9, #0x3e000
0x00022790  ldr      d1, [x9, #0xc30]
0x00022794  fsub     d0, d0, d1
0x00022798  ldr      d1, [x8, #0x440]
0x0002279c  fcmp     d0, d1
0x000227a0  b.le     #0x227c0
0x000227a4  mov      w0, #0
0x000227a8  mov      x1, #0
0x000227ac  b        #0x227bc   ; call sub_227bc
0x000227b0  adrp     x1, #0x38000
0x000227b4  add      x1, x1, #0x350   ; -> @"frames"
0x000227b8  mov      w0, #1
0x000227bc  bl       #0x22f58   ; call sub_22f58
0x000227c0  ldr      x8, [x23, #0xbc0]
0x000227c4  sub      x9, x8, #4
0x000227c8  mov      x25, #-0x5555555555555556
0x000227cc  movk     x25, #0xaaab
0x000227d0  mul      x9, x9, x25
0x000227d4  ror      x9, x9, #2
0x000227d8  mov      x10, #0x5555555555555555
0x000227dc  and      x10, x10, #0x3ffffffffffffffc
0x000227e0  cmp      x9, x10
0x000227e4  b.hi     #0x2299c
0x000227e8  ldr      x20, [x24, #0xac8]
0x000227ec  cbz      x20, #0x2299c
0x000227f0  adrp     x24, #0x3e000
0x000227f4  ldr      x9, [x24, #0xad0]
0x000227f8  cbnz     x9, #0x2299c
0x000227fc  adrp     x26, #0x3e000
0x00022800  ldr      x21, [x26, #0xc38]
0x00022804  cbnz     x21, #0x22894
0x00022808  adrp     x0, #0x2a000
0x0002280c  add      x0, x0, #0xd8f   ; -> "OMCPerfTicker"
0x00022810  bl       #0x24788   ; call _objc_getClass
0x00022814  mov      x21, x0
0x00022818  cbnz     x0, #0x22878
0x0002281c  adrp     x8, #0x3e000
0x00022820  ldr      x0, [x8, #0x440]   ; -> [class(NSObject)]
0x00022824  bl       #0x247d0   ; call _objc_opt_class
0x00022828  adrp     x1, #0x2a000
0x0002282c  add      x1, x1, #0xd8f   ; -> "OMCPerfTicker"
0x00022830  mov      x2, #0
0x00022834  bl       #0x24728   ; call _objc_allocateClassPair
0x00022838  mov      x21, x0
0x0002283c  adrp     x0, #0x2a000
0x00022840  add      x0, x0, #0xd89   ; -> "tick:"
0x00022844  bl       #0x248f0   ; call _sel_registerName
0x00022848  mov      x22, x0
0x0002284c  adrp     x0, #0x34000
0x00022850  add      x0, x0, #0xd30
0x00022854  bl       #0x24680   ; call _imp_implementationWithBlock
0x00022858  mov      x2, x0
0x0002285c  adrp     x3, #0x2a000
0x00022860  add      x3, x3, #0xda9   ; -> "v@:@"
0x00022864  mov      x0, x21
0x00022868  mov      x1, x22
0x0002286c  bl       #0x244f4   ; call _class_addMethod
0x00022870  mov      x0, x21
0x00022874  bl       #0x24800   ; call _objc_registerClassPair
0x00022878  mov      x0, x21
0x0002287c  bl       #0x247e8   ; call _objc_opt_new
0x00022880  ldr      x8, [x26, #0xc38]
0x00022884  str      x0, [x26, #0xc38]
0x00022888  mov      x0, x8
0x0002288c  bl       #0x2480c   ; call _objc_release
0x00022890  ldr      x21, [x26, #0xc38]
0x00022894  mov      x0, x21
0x00022898  bl       #0x24818   ; call _objc_retain
0x0002289c  adrp     x0, #0x2a000
0x000228a0  add      x0, x0, #0xd89   ; -> "tick:"
0x000228a4  bl       #0x248f0   ; call _sel_registerName
0x000228a8  mov      x3, x0
0x000228ac  mov      x0, x20
0x000228b0  mov      x2, x21
0x000228b4  bl       #0x25600   ; objc_msgSend: displayLinkWithTarget:selector:
0x000228b8  mov      x29, x29
0x000228bc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000228c0  ldr      x8, [x24, #0xad0]
0x000228c4  str      x0, [x24, #0xad0]
0x000228c8  mov      x0, x8
0x000228cc  bl       #0x2480c   ; call _objc_release
0x000228d0  mov      x0, x21
0x000228d4  bl       #0x2480c   ; call _objc_release
0x000228d8  adrp     x8, #0x3e000
0x000228dc  str      xzr, [x8, #0xb70]
0x000228e0  adrp     x8, #0x3e000
0x000228e4  ldr      d0, [x8, #0xb68]
0x000228e8  adrp     x8, #0x3e000
0x000228ec  str      d0, [x8, #0xbe0]
0x000228f0  adrp     x8, #0x3e000
0x000228f4  ldr      d0, [x8, #0xb60]
0x000228f8  adrp     x8, #0x3e000
0x000228fc  str      d0, [x8, #0xbd8]
0x00022900  ldr      x20, [x24, #0xad0]
0x00022904  adrp     x8, #0x3e000
0x00022908  ldr      x0, [x8, #0x438]   ; -> [class(NSRunLoop)]
0x0002290c  bl       #0x260c0   ; objc_msgSend: mainRunLoop
0x00022910  mov      x29, x29
0x00022914  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022918  mov      x21, x0
0x0002291c  adrp     x8, #0x34000
0x00022920  ldr      x8, [x8, #0x1e0]   ; -> [got:_NSRunLoopCommonModes]
0x00022924  ldr      x3, [x8]   ; -> [got:___objc_personality_v0]
0x00022928  mov      x0, x20
0x0002292c  mov      x2, x21
0x00022930  bl       #0x24be0   ; objc_msgSend: addToRunLoop:forMode:
0x00022934  mov      x0, x21
0x00022938  bl       #0x2480c   ; call _objc_release
0x0002293c  adrp     x8, #0x3e000
0x00022940  ldr      x20, [x8, #0xb48]
0x00022944  mov      x1, #0xe400
0x00022948  movk     x1, #0x540b, lsl #16
0x0002294c  movk     x1, #2, lsl #32
0x00022950  mov      x0, #0
0x00022954  bl       #0x245cc   ; call _dispatch_time
0x00022958  adrp     x8, #0x34000
0x0002295c  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x00022960  str      x8, [sp, #8]
0x00022964  adrp     x8, #0x2b000
0x00022968  ldr      d0, [x8, #0x1e8]
0x0002296c  adrp     x8, #0x23000
0x00022970  add      x8, x8, #0x7c
0x00022974  str      d0, [sp, #0x10]
0x00022978  adrp     x9, #0x34000
0x0002297c  add      x9, x9, #0x650
0x00022980  stp      x8, x9, [sp, #0x18]
0x00022984  str      x20, [sp, #0x28]
0x00022988  adrp     x1, #0x34000
0x0002298c  ldr      x1, [x1, #0x290]   ; -> [got:__dispatch_main_q]
0x00022990  add      x2, sp, #8
0x00022994  bl       #0x24548   ; call _dispatch_after
0x00022998  ldr      x8, [x23, #0xbc0]
0x0002299c  mul      x8, x8, x25
0x000229a0  ror      x8, x8, #1
0x000229a4  mov      x9, #-0x5555555555555556
0x000229a8  movk     x9, #0x2aaa, lsl #48
0x000229ac  cmp      x8, x9
0x000229b0  b.hi     #0x229b8
0x000229b4  bl       #0x229dc   ; call sub_229dc
0x000229b8  mov      x0, x19
0x000229bc  bl       #0x2480c   ; call _objc_release
0x000229c0  ldp      x29, x30, [sp, #0x70]
0x000229c4  ldp      x20, x19, [sp, #0x60]
0x000229c8  ldp      x22, x21, [sp, #0x50]
0x000229cc  ldp      x24, x23, [sp, #0x40]
0x000229d0  ldp      x26, x25, [sp, #0x30]
0x000229d4  add      sp, sp, #0x80
0x000229d8  ret      
0x000229dc  stp      d9, d8, [sp, #-0x40]!
0x000229e0  stp      x22, x21, [sp, #0x10]
0x000229e4  stp      x20, x19, [sp, #0x20]
0x000229e8  stp      x29, x30, [sp, #0x30]
0x000229ec  add      x29, sp, #0x30
0x000229f0  adrp     x20, #0x3e000
0x000229f4  ldr      x0, [x20, #0xae0]
0x000229f8  cbz      x0, #0x22a0c
0x000229fc  bl       #0x27f60   ; objc_msgSend: timeIntervalSinceNow
0x00022a00  fmov     d1, #-30.00000000
0x00022a04  fcmp     d0, d1
0x00022a08  b.le     #0x22a20
0x00022a0c  ldp      x29, x30, [sp, #0x30]
0x00022a10  ldp      x20, x19, [sp, #0x20]
0x00022a14  ldp      x22, x21, [sp, #0x10]
0x00022a18  ldp      d9, d8, [sp], #0x40
0x00022a1c  ret      
0x00022a20  fneg     d8, d0
0x00022a24  adrp     x8, #0x3e000
0x00022a28  ldr      x0, [x8, #0x398]   ; -> [class(NSMutableDictionary)]
0x00022a2c  bl       #0x25580   ; objc_msgSend: dictionary
0x00022a30  mov      x29, x29
0x00022a34  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022a38  mov      x19, x0
0x00022a3c  ldr      x2, [x20, #0xae0]
0x00022a40  adrp     x3, #0x38000
0x00022a44  add      x3, x3, #0x3f0   ; -> @"start"
0x00022a48  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022a4c  adrp     x8, #0x3e000
0x00022a50  ldr      x0, [x8, #0x418]   ; -> [class(NSDate)]
0x00022a54  bl       #0x25480   ; objc_msgSend: date
0x00022a58  mov      x29, x29
0x00022a5c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022a60  mov      x20, x0
0x00022a64  adrp     x3, #0x38000
0x00022a68  add      x3, x3, #0x410   ; -> @"updated"
0x00022a6c  mov      x0, x19
0x00022a70  mov      x2, x20
0x00022a74  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022a78  mov      x0, x20
0x00022a7c  bl       #0x2480c   ; call _objc_release
0x00022a80  adrp     x21, #0x3e000
0x00022a84  ldr      x0, [x21, #0x2a0]   ; -> [class(NSNumber)]
0x00022a88  fcvtas   x2, d8
0x00022a8c  bl       #0x26360   ; objc_msgSend: numberWithLong:
0x00022a90  mov      x29, x29
0x00022a94  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022a98  mov      x20, x0
0x00022a9c  adrp     x3, #0x38000
0x00022aa0  add      x3, x3, #0x430   ; -> @"seconds"
0x00022aa4  mov      x0, x19
0x00022aa8  mov      x2, x20
0x00022aac  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022ab0  mov      x0, x20
0x00022ab4  bl       #0x2480c   ; call _objc_release
0x00022ab8  ldr      x0, [x21, #0x2a0]   ; -> [class(NSNumber)]
0x00022abc  adrp     x8, #0x3e000
0x00022ac0  ldr      d0, [x8, #0xb50]
0x00022ac4  fmov     d1, #1.00000000
0x00022ac8  fdiv     d0, d1, d0
0x00022acc  fcvtas   x2, d0
0x00022ad0  bl       #0x26360   ; objc_msgSend: numberWithLong:
0x00022ad4  mov      x29, x29
0x00022ad8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022adc  mov      x20, x0
0x00022ae0  adrp     x3, #0x34000
0x00022ae4  add      x3, x3, #0xf70   ; -> @"fps"
0x00022ae8  mov      x0, x19
0x00022aec  mov      x2, x20
0x00022af0  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022af4  mov      x0, x20
0x00022af8  bl       #0x2480c   ; call _objc_release
0x00022afc  ldr      x0, [x21, #0x2a0]   ; -> [class(NSNumber)]
0x00022b00  adrp     x8, #0x3e000
0x00022b04  ldr      d0, [x8, #0xb68]
0x00022b08  fcvtas   x2, d0
0x00022b0c  bl       #0x26360   ; objc_msgSend: numberWithLong:
0x00022b10  mov      x29, x29
0x00022b14  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022b18  mov      x20, x0
0x00022b1c  adrp     x3, #0x38000
0x00022b20  add      x3, x3, #0x350   ; -> @"frames"
0x00022b24  mov      x0, x19
0x00022b28  mov      x2, x20
0x00022b2c  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022b30  mov      x0, x20
0x00022b34  bl       #0x2480c   ; call _objc_release
0x00022b38  ldr      x0, [x21, #0x2a0]   ; -> [class(NSNumber)]
0x00022b3c  adrp     x8, #0x3e000
0x00022b40  ldr      d0, [x8, #0xb60]
0x00022b44  fcvtas   x2, d0
0x00022b48  bl       #0x26360   ; objc_msgSend: numberWithLong:
0x00022b4c  mov      x29, x29
0x00022b50  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022b54  mov      x20, x0
0x00022b58  adrp     x3, #0x38000
0x00022b5c  add      x3, x3, #0x450   ; -> @"late"
0x00022b60  mov      x0, x19
0x00022b64  mov      x2, x20
0x00022b68  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022b6c  mov      x0, x20
0x00022b70  bl       #0x2480c   ; call _objc_release
0x00022b74  ldr      x0, [x21, #0x2a0]   ; -> [class(NSNumber)]
0x00022b78  adrp     x8, #0x3e000
0x00022b7c  ldr      d0, [x8, #0xb58]
0x00022b80  fcvtas   x2, d0
0x00022b84  bl       #0x26360   ; objc_msgSend: numberWithLong:
0x00022b88  mov      x29, x29
0x00022b8c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022b90  mov      x20, x0
0x00022b94  adrp     x3, #0x38000
0x00022b98  add      x3, x3, #0x470   ; -> @"worstMs"
0x00022b9c  mov      x0, x19
0x00022ba0  mov      x2, x20
0x00022ba4  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022ba8  mov      x0, x20
0x00022bac  bl       #0x2480c   ; call _objc_release
0x00022bb0  ldr      x0, [x21, #0x2a0]   ; -> [class(NSNumber)]
0x00022bb4  adrp     x8, #0x3e000
0x00022bb8  ldr      d0, [x8, #0xb88]
0x00022bbc  fcvtas   x2, d0
0x00022bc0  bl       #0x26360   ; objc_msgSend: numberWithLong:
0x00022bc4  mov      x29, x29
0x00022bc8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022bcc  mov      x20, x0
0x00022bd0  adrp     x3, #0x38000
0x00022bd4  add      x3, x3, #0x330   ; -> @"hangs"
0x00022bd8  mov      x0, x19
0x00022bdc  mov      x2, x20
0x00022be0  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022be4  mov      x0, x20
0x00022be8  bl       #0x2480c   ; call _objc_release
0x00022bec  ldr      x0, [x21, #0x2a0]   ; -> [class(NSNumber)]
0x00022bf0  adrp     x8, #0x3e000
0x00022bf4  ldr      d0, [x8, #0xb80]
0x00022bf8  fcvtas   x2, d0
0x00022bfc  bl       #0x26360   ; objc_msgSend: numberWithLong:
0x00022c00  mov      x29, x29
0x00022c04  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022c08  mov      x20, x0
0x00022c0c  adrp     x3, #0x38000
0x00022c10  add      x3, x3, #0x490   ; -> @"freezes"
0x00022c14  mov      x0, x19
0x00022c18  mov      x2, x20
0x00022c1c  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022c20  mov      x0, x20
0x00022c24  bl       #0x2480c   ; call _objc_release
0x00022c28  ldr      x0, [x21, #0x2a0]   ; -> [class(NSNumber)]
0x00022c2c  adrp     x8, #0x3e000
0x00022c30  ldr      d0, [x8, #0xb78]
0x00022c34  fcvtas   x2, d0
0x00022c38  bl       #0x26360   ; objc_msgSend: numberWithLong:
0x00022c3c  mov      x29, x29
0x00022c40  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022c44  mov      x20, x0
0x00022c48  adrp     x3, #0x38000
0x00022c4c  add      x3, x3, #0x4b0   ; -> @"hangMaxMs"
0x00022c50  mov      x0, x19
0x00022c54  mov      x2, x20
0x00022c58  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022c5c  mov      x0, x20
0x00022c60  bl       #0x2480c   ; call _objc_release
0x00022c64  adrp     x20, #0x3e000
0x00022c68  ldr      x0, [x20, #0xaf0]
0x00022c6c  bl       #0x25420   ; objc_msgSend: count
