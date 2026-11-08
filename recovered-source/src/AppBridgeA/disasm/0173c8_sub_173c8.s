; ==== sub_173c8 @ 0x173c8..0x177cc (1028 bytes) ====
0x000173c8  bl       #0x2480c   ; call _objc_release
0x000173cc  ldrb     w8, [x19, #0x38]
0x000173d0  cmp      w8, #0
0x000173d4  adrp     x8, #0x2b000
0x000173d8  ldr      s0, [x8, #0x390]
0x000173dc  fmov     s1, #0.50000000
0x000173e0  fcsel    s8, s1, s0, ne
0x000173e4  ldr      x0, [x19, #0x20]
0x000173e8  bl       #0x25f00   ; objc_msgSend: layer
0x000173ec  mov      x29, x29
0x000173f0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000173f4  mov      x20, x0
0x000173f8  mov      v0.16b, v8.16b
0x000173fc  bl       #0x27720   ; objc_msgSend: setShadowOpacity:
0x00017400  mov      x0, x20
0x00017404  bl       #0x2480c   ; call _objc_release
0x00017408  ldrb     w8, [x19, #0x38]
0x0001740c  cmp      w8, #0
0x00017410  fmov     d0, #3.00000000
0x00017414  fmov     d1, #7.00000000
0x00017418  fcsel    d8, d1, d0, ne
0x0001741c  ldr      x0, [x19, #0x20]
0x00017420  bl       #0x25f00   ; objc_msgSend: layer
0x00017424  mov      x29, x29
0x00017428  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001742c  mov      x20, x0
0x00017430  mov      v0.16b, v8.16b
0x00017434  bl       #0x27760   ; objc_msgSend: setShadowRadius:
0x00017438  mov      x0, x20
0x0001743c  bl       #0x2480c   ; call _objc_release
0x00017440  ldp      x29, x30, [sp, #0xa0]
0x00017444  ldp      x20, x19, [sp, #0x90]
0x00017448  ldp      x22, x21, [sp, #0x80]
0x0001744c  ldp      x24, x23, [sp, #0x70]
0x00017450  ldp      d9, d8, [sp, #0x60]
0x00017454  add      sp, sp, #0xb0
0x00017458  ret      
0x0001745c  b        #0x17480   ; call sub_17480
0x00017460  b        #0x17480   ; call sub_17480
0x00017464  b        #0x17468   ; call sub_17468
0x00017468  mov      x19, x0
0x0001746c  mov      x0, x21
0x00017470  bl       #0x2480c   ; call _objc_release
0x00017474  b        #0x17484   ; call sub_17484
0x00017478  b        #0x17480   ; call sub_17480
0x0001747c  b        #0x17480   ; call sub_17480
0x00017480  mov      x19, x0
0x00017484  mov      x0, x20
0x00017488  bl       #0x2480c   ; call _objc_release
0x0001748c  mov      x0, x19
0x00017490  bl       #0x24470   ; call __Unwind_Resume
0x00017494  stp      x20, x19, [sp, #-0x20]!
0x00017498  stp      x29, x30, [sp, #0x10]
0x0001749c  add      x29, sp, #0x10
0x000174a0  mov      x19, x1
0x000174a4  ldr      x0, [x1, #0x20]
0x000174a8  bl       #0x24818   ; call _objc_retain
0x000174ac  ldr      x0, [x19, #0x28]
0x000174b0  bl       #0x24818   ; call _objc_retain
0x000174b4  ldr      x0, [x19, #0x30]
0x000174b8  ldp      x29, x30, [sp, #0x10]
0x000174bc  ldp      x20, x19, [sp], #0x20
0x000174c0  b        #0x24818   ; call _objc_retain
0x000174c4  stp      x20, x19, [sp, #-0x20]!
0x000174c8  stp      x29, x30, [sp, #0x10]
0x000174cc  add      x29, sp, #0x10
0x000174d0  mov      x19, x0
0x000174d4  ldr      x0, [x0, #0x30]
0x000174d8  bl       #0x2480c   ; call _objc_release
0x000174dc  ldr      x0, [x19, #0x28]
0x000174e0  bl       #0x2480c   ; call _objc_release
0x000174e4  ldr      x0, [x19, #0x20]
0x000174e8  ldp      x29, x30, [sp, #0x10]
0x000174ec  ldp      x20, x19, [sp], #0x20
0x000174f0  b        #0x2480c   ; call _objc_release
0x000174f4  stp      x20, x19, [sp, #-0x20]!
0x000174f8  stp      x29, x30, [sp, #0x10]
0x000174fc  add      x29, sp, #0x10
0x00017500  ldrb     w8, [x0, #0x28]
0x00017504  tbnz     w8, #0, #0x1752c
0x00017508  mov      x19, x0
0x0001750c  ldr      x0, [x0, #0x20]
0x00017510  bl       #0x26440   ; objc_msgSend: opacity
0x00017514  fcmp     s0, #0.0
0x00017518  b.ne     #0x1752c
0x0001751c  ldr      x0, [x19, #0x20]
0x00017520  ldp      x29, x30, [sp, #0x10]
0x00017524  ldp      x20, x19, [sp], #0x20
0x00017528  b        #0x26820   ; objc_msgSend: removeFromSuperlayer
0x0001752c  ldp      x29, x30, [sp, #0x10]
0x00017530  ldp      x20, x19, [sp], #0x20
0x00017534  ret      
0x00017538  sub      sp, sp, #0xa0
0x0001753c  stp      x28, x27, [sp, #0x40]
0x00017540  stp      x26, x25, [sp, #0x50]
0x00017544  stp      x24, x23, [sp, #0x60]
0x00017548  stp      x22, x21, [sp, #0x70]
0x0001754c  stp      x20, x19, [sp, #0x80]
0x00017550  stp      x29, x30, [sp, #0x90]
0x00017554  add      x29, sp, #0x90
0x00017558  mov      x20, x1
0x0001755c  mov      x19, x0
0x00017560  bl       #0x24818   ; call _objc_retain
0x00017564  mov      x0, x20
0x00017568  bl       #0x24818   ; call _objc_retain
0x0001756c  mov      x0, x20
0x00017570  bl       #0x25fa0   ; objc_msgSend: length
0x00017574  cmp      x0, #1
0x00017578  b.ne     #0x17690
0x0001757c  mov      x0, x20
0x00017580  mov      x2, #0
0x00017584  bl       #0x25140   ; objc_msgSend: characterAtIndex:
0x00017588  mov      x25, x0
0x0001758c  mov      x0, x20
0x00017590  bl       #0x26060   ; objc_msgSend: lowercaseString
0x00017594  mov      x29, x29
0x00017598  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001759c  mov      x2, #0
0x000175a0  str      x0, [sp, #0x20]
0x000175a4  bl       #0x25140   ; objc_msgSend: characterAtIndex:
0x000175a8  mov      x27, x0
0x000175ac  mov      x0, x19
0x000175b0  bl       #0x261e0   ; objc_msgSend: mutableCopy
0x000175b4  mov      x22, x0
0x000175b8  bl       #0x25fa0   ; objc_msgSend: length
0x000175bc  mov      x24, x0
0x000175c0  mov      x26, #-1
0x000175c4  mov      x23, #-1
0x000175c8  cmp      x24, #0
0x000175cc  b.le     #0x1761c
0x000175d0  sub      x24, x24, #1
0x000175d4  mov      x0, x22
0x000175d8  mov      x2, x24
0x000175dc  bl       #0x25140   ; objc_msgSend: characterAtIndex:
0x000175e0  mov      x1, #0
0x000175e4  mov      x2, #0
0x000175e8  mov      x3, #0
0x000175ec  bl       #0x17ecc   ; call sub_17ecc
0x000175f0  cmp      x23, #0
0x000175f4  cset     w8, lt
0x000175f8  tst      w8, w0
0x000175fc  csinc    x23, x23, x24, eq
0x00017600  cmn      x23, #1
0x00017604  cset     w8, gt
0x00017608  tst      w0, w8
0x0001760c  csel     x26, x24, x26, ne
0x00017610  cmp      x23, #0
0x00017614  csinc    w8, w0, wzr, ge
0x00017618  tbnz     w8, #0, #0x175c8
0x0001761c  tbnz     x26, #0x3f, #0x17698
0x00017620  mov      x24, x26
0x00017624  cbz      x26, #0x176c4
0x00017628  sub      x8, x23, x26
0x0001762c  mov      x24, x26
0x00017630  cmp      x8, #2
0x00017634  b.lt     #0x176c4
0x00017638  sub      x2, x26, #1
0x0001763c  mov      x0, x22
0x00017640  bl       #0x25140   ; objc_msgSend: characterAtIndex:
0x00017644  bl       #0x244a0   ; call ___tolower
0x00017648  mov      x24, x0
0x0001764c  str      wzr, [sp, #0x3c]
0x00017650  mov      x0, x22
0x00017654  mov      x2, x26
0x00017658  bl       #0x25140   ; objc_msgSend: characterAtIndex:
0x0001765c  add      x1, sp, #0x3c
0x00017660  mov      x2, #0
0x00017664  mov      x3, #0
0x00017668  bl       #0x17ecc   ; call sub_17ecc
0x0001766c  and      w8, w24, #0xffff
0x00017670  cmp      w8, #0x71
0x00017674  b.ne     #0x176a4
0x00017678  ldr      w8, [sp, #0x3c]
0x0001767c  sub      w8, w8, #9
0x00017680  mov      x24, x26
0x00017684  cmp      w8, #2
0x00017688  b.lo     #0x176c0
0x0001768c  b        #0x176c4   ; call sub_176c4
0x00017690  mov      x28, #0
0x00017694  b        #0x17cb4   ; call sub_17cb4
0x00017698  mov      w8, #0
0x0001769c  mov      x24, #-1
0x000176a0  b        #0x176d4   ; call sub_176d4
0x000176a4  mov      x24, x26
0x000176a8  cmp      w8, #0x67
0x000176ac  b.ne     #0x176c4
0x000176b0  ldr      w8, [sp, #0x3c]
0x000176b4  mov      x24, x26
0x000176b8  cmp      w8, #5
0x000176bc  b.ne     #0x176c4
0x000176c0  add      x24, x26, #1
0x000176c4  mov      x0, x22
0x000176c8  bl       #0x25fa0   ; objc_msgSend: length
0x000176cc  cmp      x23, x0
0x000176d0  cset     w8, lt
0x000176d4  cmp      w27, #0x72
0x000176d8  b.gt     #0x17708
0x000176dc  cmp      w27, #0x66
0x000176e0  b.eq     #0x17734
0x000176e4  cmp      w27, #0x6a
0x000176e8  b.eq     #0x17860
0x000176ec  cmp      w27, #0x72
0x000176f0  b.ne     #0x17838
0x000176f4  str      x19, [sp, #0x18]
0x000176f8  mov      w21, #0
0x000176fc  mov      w19, #3
0x00017700  tbnz     x26, #0x3f, #0x1782c
0x00017704  b        #0x17744   ; call sub_17744
0x00017708  cmp      w27, #0x73
0x0001770c  b.eq     #0x1781c
0x00017710  cmp      w27, #0x78
0x00017714  b.eq     #0x17874
0x00017718  cmp      w27, #0x7a
0x0001771c  b.ne     #0x17838
0x00017720  str      x19, [sp, #0x18]
0x00017724  mov      w19, #0
0x00017728  mov      w21, #1
0x0001772c  tbnz     x26, #0x3f, #0x1782c
0x00017730  b        #0x17744   ; call sub_17744
0x00017734  str      x19, [sp, #0x18]
0x00017738  mov      w21, #0
0x0001773c  mov      w19, #2
0x00017740  tbnz     x26, #0x3f, #0x1782c
0x00017744  str      w8, [sp, #0x14]
0x00017748  cmp      x23, x24
0x0001774c  b.le     #0x177f8
0x00017750  mov      w28, #0
0x00017754  adrp     x25, #0x3e000
0x00017758  mov      x26, x24
0x0001775c  str      xzr, [sp, #0x38]
0x00017760  strb     wzr, [sp, #0x30]
0x00017764  mov      x0, x22
0x00017768  mov      x2, x26
0x0001776c  bl       #0x25140   ; objc_msgSend: characterAtIndex:
0x00017770  add      x1, sp, #0x3c
0x00017774  add      x2, sp, #0x38
0x00017778  add      x3, sp, #0x30
0x0001777c  bl       #0x17ecc   ; call sub_17ecc
0x00017780  ldp      w8, w0, [sp, #0x38]
0x00017784  cmp      w8, #0
0x00017788  csel     w28, w28, w8, eq
0x0001778c  ldrb     w2, [sp, #0x30]
0x00017790  mov      w1, #0
0x00017794  bl       #0x180c0   ; call sub_180c0
0x00017798  strh     w0, [sp, #0x34]
0x0001779c  ldr      x0, [x25, #0x290]   ; -> [class(NSString)]
0x000177a0  add      x2, sp, #0x34
0x000177a4  mov      w3, #1
0x000177a8  bl       #0x27ce0   ; objc_msgSend: stringWithCharacters:length:
0x000177ac  mov      x29, x29
0x000177b0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000177b4  mov      x27, x0
0x000177b8  mov      x0, x22
0x000177bc  mov      x2, x26
0x000177c0  mov      w3, #1
0x000177c4  mov      x4, x27
0x000177c8  bl       #0x268c0   ; objc_msgSend: replaceCharactersInRange:withString:
