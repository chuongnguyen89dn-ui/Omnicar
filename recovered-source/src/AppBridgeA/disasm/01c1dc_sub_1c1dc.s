; ==== sub_1c1dc @ 0x1c1dc..0x1c7d4 (1528 bytes) ====
0x0001c1dc  bl       #0x2480c   ; call _objc_release
0x0001c1e0  sub      x8, x22, #1
0x0001c1e4  ucvtf    d0, x8
0x0001c1e8  fmov     d1, #-5.00000000
0x0001c1ec  fmadd    d0, d0, d1, d9
0x0001c1f0  ucvtf    d1, x22
0x0001c1f4  fdiv     d0, d0, d1
0x0001c1f8  frintm   d9, d0
0x0001c1fc  adrp     x8, #0x3e000
0x0001c200  ldr      x0, [x8, #0x3e0]   ; -> [class(UIFont)]
0x0001c204  adrp     x8, #0x2b000
0x0001c208  ldr      d0, [x8, #0x3f0]
0x0001c20c  fmul     d0, d9, d0
0x0001c210  frintm   d0, d0
0x0001c214  fmov     d1, #14.00000000
0x0001c218  fmaxnm   d0, d0, d1
0x0001c21c  bl       #0x27e60   ; objc_msgSend: systemFontOfSize:
0x0001c220  mov      x29, x29
0x0001c224  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c228  mov      x20, x0
0x0001c22c  cbz      x22, #0x1c4ac
0x0001c230  mov      x23, #0
0x0001c234  adrp     x8, #0x2b000
0x0001c238  ldr      d0, [x8, #0x3e8]
0x0001c23c  fadd     d0, d8, d0
0x0001c240  fmov     d1, #10.00000000
0x0001c244  fdiv     d13, d0, d1
0x0001c248  sub      x27, x22, #2
0x0001c24c  fmov     d14, #5.00000000
0x0001c250  fadd     d15, d9, d14
0x0001c254  ldr      x0, [sp, #8]
0x0001c258  bl       #0x269e0   ; objc_msgSend: rows
0x0001c25c  mov      x29, x29
0x0001c260  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c264  mov      x24, x0
0x0001c268  mov      x2, x23
0x0001c26c  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x0001c270  mov      x29, x29
0x0001c274  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c278  mov      x21, x0
0x0001c27c  mov      x0, x24
0x0001c280  bl       #0x2480c   ; call _objc_release
0x0001c284  movi     v0.16b, #0
0x0001c288  stp      q0, q0, [sp, #0x70]
0x0001c28c  stp      q0, q0, [sp, #0x50]
0x0001c290  mov      x0, x21
0x0001c294  bl       #0x24818   ; call _objc_retain
0x0001c298  add      x2, sp, #0x50
0x0001c29c  add      x3, sp, #0x110
0x0001c2a0  mov      x0, x21
0x0001c2a4  mov      w4, #0x10
0x0001c2a8  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001c2ac  mov      x24, x0
0x0001c2b0  cbz      x0, #0x1c318
0x0001c2b4  ldr      x8, [sp, #0x60]
0x0001c2b8  ldr      x19, [x8]
0x0001c2bc  fmov     d10, xzr
0x0001c2c0  mov      x25, #0
0x0001c2c4  ldr      x8, [sp, #0x60]
0x0001c2c8  ldr      x8, [x8]
0x0001c2cc  cmp      x8, x19
0x0001c2d0  b.eq     #0x1c2dc
0x0001c2d4  mov      x0, x21
0x0001c2d8  bl       #0x24770   ; call _objc_enumerationMutation
0x0001c2dc  ldr      x8, [sp, #0x58]
0x0001c2e0  ldr      x0, [x8, x25, lsl #3]
0x0001c2e4  bl       #0x281a0   ; objc_msgSend: weight
0x0001c2e8  fadd     d10, d10, d0
0x0001c2ec  add      x25, x25, #1
0x0001c2f0  cmp      x24, x25
0x0001c2f4  b.ne     #0x1c2c4
0x0001c2f8  add      x2, sp, #0x50
0x0001c2fc  add      x3, sp, #0x110
0x0001c300  mov      x0, x21
0x0001c304  mov      w4, #0x10
0x0001c308  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001c30c  mov      x24, x0
0x0001c310  cbnz     x0, #0x1c2c0
0x0001c314  b        #0x1c31c   ; call sub_1c31c
0x0001c318  fmov     d10, xzr
0x0001c31c  mov      x0, x21
0x0001c320  bl       #0x2480c   ; call _objc_release
0x0001c324  mov      x0, x21
0x0001c328  bl       #0x25420   ; objc_msgSend: count
0x0001c32c  sub      x8, x0, #1
0x0001c330  ucvtf    d0, x8
0x0001c334  fmov     d1, #-5.00000000
0x0001c338  fmadd    d11, d0, d1, d8
0x0001c33c  cmp      x23, x27
0x0001c340  b.hs     #0x1c354
0x0001c344  mov      x0, x21
0x0001c348  bl       #0x25420   ; objc_msgSend: count
0x0001c34c  cmp      x0, #0xa
0x0001c350  b.lo     #0x1c35c
0x0001c354  fdiv     d12, d11, d10
0x0001c358  b        #0x1c368   ; call sub_1c368
0x0001c35c  fdiv     d0, d11, d10
0x0001c360  fcmp     d13, d0
0x0001c364  fcsel    d12, d13, d0, mi
0x0001c368  mov      x0, x21
0x0001c36c  bl       #0x25420   ; objc_msgSend: count
0x0001c370  mov      x25, x0
0x0001c374  movi     v0.16b, #0
0x0001c378  stp      q0, q0, [sp, #0x30]
0x0001c37c  stp      q0, q0, [sp, #0x10]
0x0001c380  mov      x0, x21
0x0001c384  bl       #0x24818   ; call _objc_retain
0x0001c388  add      x2, sp, #0x10
0x0001c38c  add      x3, sp, #0x90
0x0001c390  mov      x0, x21
0x0001c394  mov      w4, #0x10
0x0001c398  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001c39c  mov      x24, x0
0x0001c3a0  cbz      x0, #0x1c490
0x0001c3a4  sub      x8, x25, #1
0x0001c3a8  ucvtf    d0, x8
0x0001c3ac  fmul     d0, d0, d14
0x0001c3b0  fmadd    d0, d12, d10, d0
0x0001c3b4  fsub     d0, d8, d0
0x0001c3b8  fmov     d1, #0.50000000
0x0001c3bc  fmul     d10, d0, d1
0x0001c3c0  ldr      x8, [sp, #0x20]
0x0001c3c4  ldr      x28, [x8]
0x0001c3c8  ucvtf    d0, x23
0x0001c3cc  fmul     d11, d15, d0
0x0001c3d0  mov      x19, #0
0x0001c3d4  ldr      x8, [sp, #0x20]
0x0001c3d8  ldr      x8, [x8]
0x0001c3dc  cmp      x8, x28
0x0001c3e0  b.eq     #0x1c3ec
0x0001c3e4  mov      x0, x21
0x0001c3e8  bl       #0x24770   ; call _objc_enumerationMutation
0x0001c3ec  ldr      x8, [sp, #0x18]
0x0001c3f0  ldr      x25, [x8, x19, lsl #3]
0x0001c3f4  mov      x0, x25
0x0001c3f8  bl       #0x281a0   ; objc_msgSend: weight
0x0001c3fc  fmul     d2, d12, d0
0x0001c400  mov      x0, x25
0x0001c404  mov      v0.16b, v10.16b
0x0001c408  mov      v1.16b, v11.16b
0x0001c40c  mov      v3.16b, v9.16b
0x0001c410  bl       #0x26f80   ; objc_msgSend: setFrame:
0x0001c414  mov      x0, x25
0x0001c418  bl       #0x25260   ; objc_msgSend: command
0x0001c41c  mov      x29, x29
0x0001c420  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c424  cmp      x0, #0
0x0001c428  cset     w26, eq
0x0001c42c  bl       #0x2480c   ; call _objc_release
0x0001c430  cbz      w26, #0x1c458
0x0001c434  mov      x0, x25
0x0001c438  bl       #0x27fc0   ; objc_msgSend: titleLabel
0x0001c43c  mov      x29, x29
0x0001c440  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c444  mov      x26, x0
0x0001c448  mov      x2, x20
0x0001c44c  bl       #0x26f60   ; objc_msgSend: setFont:
0x0001c450  mov      x0, x26
0x0001c454  bl       #0x2480c   ; call _objc_release
0x0001c458  mov      x0, x25
0x0001c45c  bl       #0x281a0   ; objc_msgSend: weight
0x0001c460  fmadd    d0, d12, d0, d14
0x0001c464  fadd     d10, d10, d0
0x0001c468  add      x19, x19, #1
0x0001c46c  cmp      x24, x19
0x0001c470  b.ne     #0x1c3d4
0x0001c474  add      x2, sp, #0x10
0x0001c478  add      x3, sp, #0x90
0x0001c47c  mov      x0, x21
0x0001c480  mov      w4, #0x10
0x0001c484  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001c488  mov      x24, x0
0x0001c48c  cbnz     x0, #0x1c3d0
0x0001c490  mov      x0, x21
0x0001c494  bl       #0x2480c   ; call _objc_release
0x0001c498  mov      x0, x21
0x0001c49c  bl       #0x2480c   ; call _objc_release
0x0001c4a0  add      x23, x23, #1
0x0001c4a4  cmp      x23, x22
0x0001c4a8  b.ne     #0x1c254
0x0001c4ac  mov      x0, x20
0x0001c4b0  bl       #0x2480c   ; call _objc_release
0x0001c4b4  ldur     x8, [x29, #-0xa0]
0x0001c4b8  adrp     x9, #0x34000
0x0001c4bc  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x0001c4c0  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0001c4c4  cmp      x9, x8
0x0001c4c8  b.ne     #0x1c4fc
0x0001c4cc  add      sp, sp, #0x1a0
0x0001c4d0  ldp      x29, x30, [sp, #0x90]
0x0001c4d4  ldp      x20, x19, [sp, #0x80]
0x0001c4d8  ldp      x22, x21, [sp, #0x70]
0x0001c4dc  ldp      x24, x23, [sp, #0x60]
0x0001c4e0  ldp      x26, x25, [sp, #0x50]
0x0001c4e4  ldp      x28, x27, [sp, #0x40]
0x0001c4e8  ldp      d9, d8, [sp, #0x30]
0x0001c4ec  ldp      d11, d10, [sp, #0x20]
0x0001c4f0  ldp      d13, d12, [sp, #0x10]
0x0001c4f4  ldp      d15, d14, [sp], #0xa0
0x0001c4f8  ret      
0x0001c4fc  bl       #0x24488   ; call ___stack_chk_fail
0x0001c500  b        #0x1c534   ; call sub_1c534
0x0001c504  b        #0x1c534   ; call sub_1c534
0x0001c508  b        #0x1c534   ; call sub_1c534
0x0001c50c  b        #0x1c514   ; call sub_1c514
0x0001c510  b        #0x1c514   ; call sub_1c514
0x0001c514  mov      x19, x0
0x0001c518  mov      x0, x21
0x0001c51c  bl       #0x2480c   ; call _objc_release
0x0001c520  b        #0x1c538   ; call sub_1c538
0x0001c524  b        #0x1c534   ; call sub_1c534
0x0001c528  b        #0x1c534   ; call sub_1c534
0x0001c52c  b        #0x1c534   ; call sub_1c534
0x0001c530  b        #0x1c534   ; call sub_1c534
0x0001c534  mov      x19, x0
0x0001c538  mov      x0, x20
0x0001c53c  bl       #0x2480c   ; call _objc_release
0x0001c540  b        #0x1c5c0   ; call sub_1c5c0
0x0001c544  b        #0x1c550   ; call sub_1c550
0x0001c548  b        #0x1c550   ; call sub_1c550
0x0001c54c  b        #0x1c59c   ; call sub_1c59c
0x0001c550  mov      x19, x0
0x0001c554  b        #0x1c5a8   ; call sub_1c5a8
0x0001c558  mov      x19, x0
0x0001c55c  mov      x0, x24
0x0001c560  bl       #0x2480c   ; call _objc_release
0x0001c564  b        #0x1c5b0   ; call sub_1c5b0
0x0001c568  b        #0x1c58c   ; call sub_1c58c
0x0001c56c  mov      x19, x0
0x0001c570  b        #0x1c5b0   ; call sub_1c5b0
0x0001c574  b        #0x1c59c   ; call sub_1c59c
0x0001c578  b        #0x1c58c   ; call sub_1c58c
0x0001c57c  mov      x19, x0
0x0001c580  mov      x0, x26
0x0001c584  bl       #0x2480c   ; call _objc_release
0x0001c588  b        #0x1c5a0   ; call sub_1c5a0
0x0001c58c  mov      x19, x0
0x0001c590  mov      x0, x21
0x0001c594  bl       #0x2480c   ; call _objc_release
0x0001c598  b        #0x1c5a8   ; call sub_1c5a8
0x0001c59c  mov      x19, x0
0x0001c5a0  mov      x0, x21
0x0001c5a4  bl       #0x2480c   ; call _objc_release
0x0001c5a8  mov      x0, x21
0x0001c5ac  bl       #0x2480c   ; call _objc_release
0x0001c5b0  mov      x0, x20
0x0001c5b4  bl       #0x2480c   ; call _objc_release
0x0001c5b8  b        #0x1c5c0   ; call sub_1c5c0
0x0001c5bc  mov      x19, x0
0x0001c5c0  mov      x0, x19
0x0001c5c4  bl       #0x24470   ; call __Unwind_Resume
0x0001c5c8  stp      x22, x21, [sp, #-0x30]!
0x0001c5cc  stp      x20, x19, [sp, #0x10]
0x0001c5d0  stp      x29, x30, [sp, #0x20]
0x0001c5d4  add      x29, sp, #0x20
0x0001c5d8  mov      x20, x0
0x0001c5dc  bl       #0x28020   ; objc_msgSend: typed
0x0001c5e0  mov      x29, x29
0x0001c5e4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c5e8  mov      x19, x0
0x0001c5ec  bl       #0x25fa0   ; objc_msgSend: length
0x0001c5f0  mov      x21, x0
0x0001c5f4  mov      x0, x19
0x0001c5f8  bl       #0x2480c   ; call _objc_release
0x0001c5fc  mov      x0, x20
0x0001c600  cbz      x21, #0x1c694
0x0001c604  bl       #0x28020   ; objc_msgSend: typed
0x0001c608  mov      x29, x29
0x0001c60c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c610  mov      x19, x0
0x0001c614  mov      x0, x20
0x0001c618  bl       #0x266a0   ; objc_msgSend: preview
0x0001c61c  mov      x29, x29
0x0001c620  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c624  mov      x21, x0
0x0001c628  mov      x2, x19
0x0001c62c  bl       #0x278c0   ; objc_msgSend: setText:
0x0001c630  mov      x0, x21
0x0001c634  bl       #0x2480c   ; call _objc_release
0x0001c638  mov      x0, x19
0x0001c63c  bl       #0x2480c   ; call _objc_release
0x0001c640  adrp     x8, #0x3e000
0x0001c644  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x0001c648  adrp     x8, #0x2b000
0x0001c64c  ldr      d0, [x8, #0x218]
0x0001c650  adrp     x8, #0x2b000
0x0001c654  ldr      d1, [x8, #0x220]
0x0001c658  adrp     x8, #0x2b000
0x0001c65c  ldr      d2, [x8, #0x228]
0x0001c660  fmov     d3, #1.00000000
0x0001c664  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001c668  mov      x29, x29
0x0001c66c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c670  mov      x19, x0
0x0001c674  mov      x0, x20
0x0001c678  bl       #0x266a0   ; objc_msgSend: preview
0x0001c67c  mov      x29, x29
0x0001c680  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c684  mov      x20, x0
0x0001c688  mov      x2, x19
0x0001c68c  bl       #0x27900   ; objc_msgSend: setTextColor:
0x0001c690  b        #0x1c750   ; call sub_1c750
0x0001c694  bl       #0x28120   ; objc_msgSend: vietnamese
0x0001c698  cbz      w0, #0x1c6b0
0x0001c69c  adrp     x0, #0x36000
0x0001c6a0  add      x0, x0, #0xff0   ; -> @"G"
0x0001c6a4  adrp     x1, #0x37000
0x0001c6a8  add      x1, x1, #0x10   ; -> @"Vietnamese (Telex)"
0x0001c6ac  b        #0x1c6c0   ; call sub_1c6c0
0x0001c6b0  adrp     x0, #0x37000
0x0001c6b4  add      x0, x0, #0x30   ; -> @"G"
0x0001c6b8  adrp     x1, #0x37000
0x0001c6bc  add      x1, x1, #0x50   ; -> @"Type into the app"
0x0001c6c0  bl       #0x23a38   ; call _OMCTr
0x0001c6c4  mov      x29, x29
0x0001c6c8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c6cc  mov      x19, x0
0x0001c6d0  mov      x0, x20
0x0001c6d4  bl       #0x266a0   ; objc_msgSend: preview
0x0001c6d8  mov      x29, x29
0x0001c6dc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c6e0  mov      x21, x0
0x0001c6e4  mov      x2, x19
0x0001c6e8  bl       #0x278c0   ; objc_msgSend: setText:
0x0001c6ec  mov      x0, x21
0x0001c6f0  bl       #0x2480c   ; call _objc_release
0x0001c6f4  mov      x0, x19
0x0001c6f8  bl       #0x2480c   ; call _objc_release
0x0001c6fc  adrp     x8, #0x3e000
0x0001c700  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x0001c704  adrp     x8, #0x2b000
0x0001c708  ldr      d0, [x8, #0x218]
0x0001c70c  adrp     x8, #0x2b000
0x0001c710  ldr      d1, [x8, #0x220]
0x0001c714  adrp     x8, #0x2b000
0x0001c718  ldr      d2, [x8, #0x228]
0x0001c71c  adrp     x8, #0x2b000
0x0001c720  ldr      d3, [x8, #0x2d0]
0x0001c724  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001c728  mov      x29, x29
0x0001c72c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c730  mov      x19, x0
0x0001c734  mov      x0, x20
0x0001c738  bl       #0x266a0   ; objc_msgSend: preview
0x0001c73c  mov      x29, x29
0x0001c740  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001c744  mov      x20, x0
0x0001c748  mov      x2, x19
0x0001c74c  bl       #0x27900   ; objc_msgSend: setTextColor:
0x0001c750  mov      x0, x20
0x0001c754  bl       #0x2480c   ; call _objc_release
0x0001c758  mov      x0, x19
0x0001c75c  ldp      x29, x30, [sp, #0x20]
0x0001c760  ldp      x20, x19, [sp, #0x10]
0x0001c764  ldp      x22, x21, [sp], #0x30
0x0001c768  b        #0x2480c   ; call _objc_release
0x0001c76c  b        #0x1c77c   ; call sub_1c77c
0x0001c770  b        #0x1c7a4   ; call sub_1c7a4
0x0001c774  b        #0x1c790   ; call sub_1c790
0x0001c778  b        #0x1c7a4   ; call sub_1c7a4
0x0001c77c  mov      x1, x20
0x0001c780  mov      x20, x0
0x0001c784  mov      x0, x1
0x0001c788  b        #0x1c798   ; call sub_1c798
0x0001c78c  b        #0x1c7a4   ; call sub_1c7a4
0x0001c790  mov      x20, x0
0x0001c794  mov      x0, x21
0x0001c798  bl       #0x2480c   ; call _objc_release
0x0001c79c  b        #0x1c7a8   ; call sub_1c7a8
0x0001c7a0  b        #0x1c7a4   ; call sub_1c7a4
0x0001c7a4  mov      x20, x0
0x0001c7a8  mov      x0, x19
0x0001c7ac  bl       #0x2480c   ; call _objc_release
0x0001c7b0  mov      x0, x20
0x0001c7b4  bl       #0x24470   ; call __Unwind_Resume
0x0001c7b8  stp      x20, x19, [sp, #-0x20]!
0x0001c7bc  stp      x29, x30, [sp, #0x10]
0x0001c7c0  add      x29, sp, #0x10
0x0001c7c4  mov      x20, x0
0x0001c7c8  adrp     x4, #0x36000
0x0001c7cc  add      x4, x4, #0xf90   ; -> @"lang"
0x0001c7d0  fmov     d0, #1.00000000
