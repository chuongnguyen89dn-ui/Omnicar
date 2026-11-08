; ==== sub_102bc @ 0x102bc..0x119b0 (5876 bytes) ====
0x000102bc  mov      v0.16b, v8.16b
0x000102c0  mov      v1.16b, v9.16b
0x000102c4  mov      v2.16b, v10.16b
0x000102c8  mov      v3.16b, v11.16b
0x000102cc  bl       #0x26f80   ; objc_msgSend: setFrame:
0x000102d0  mov      x0, x19
0x000102d4  bl       #0x2480c   ; call _objc_release
0x000102d8  ldp      x2, x0, [x20, #0x20]
0x000102dc  bl       #0x25f20   ; objc_msgSend: layoutBarForPane:
0x000102e0  ldp      x0, x21, [x20, #0x20]
0x000102e4  bl       #0x25860   ; objc_msgSend: handleHit
0x000102e8  mov      x29, x29
0x000102ec  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000102f0  mov      x19, x0
0x000102f4  bl       #0x25d00   ; objc_msgSend: isHidden
0x000102f8  ldr      x3, [x20, #0x20]
0x000102fc  eor      w2, w0, #1
0x00010300  mov      x0, x21
0x00010304  bl       #0x27080   ; objc_msgSend: setHandleVisible:forPane:
0x00010308  mov      x0, x19
0x0001030c  ldp      x29, x30, [sp, #0x40]
0x00010310  ldp      x20, x19, [sp, #0x30]
0x00010314  ldp      x22, x21, [sp, #0x20]
0x00010318  ldp      d9, d8, [sp, #0x10]
0x0001031c  ldp      d11, d10, [sp], #0x50
0x00010320  b        #0x2480c   ; call _objc_release
0x00010324  b        #0x10328   ; call sub_10328
0x00010328  mov      x20, x0
0x0001032c  mov      x0, x19
0x00010330  bl       #0x2480c   ; call _objc_release
0x00010334  mov      x0, x20
0x00010338  bl       #0x24470   ; call __Unwind_Resume
0x0001033c  stp      x20, x19, [sp, #-0x20]!
0x00010340  stp      x29, x30, [sp, #0x10]
0x00010344  add      x29, sp, #0x10
0x00010348  mov      x19, x1
0x0001034c  ldr      x0, [x1, #0x20]
0x00010350  bl       #0x24818   ; call _objc_retain
0x00010354  ldr      x0, [x19, #0x28]
0x00010358  ldp      x29, x30, [sp, #0x10]
0x0001035c  ldp      x20, x19, [sp], #0x20
0x00010360  b        #0x24818   ; call _objc_retain
0x00010364  stp      x20, x19, [sp, #-0x20]!
0x00010368  stp      x29, x30, [sp, #0x10]
0x0001036c  add      x29, sp, #0x10
0x00010370  mov      x19, x0
0x00010374  ldr      x0, [x0, #0x28]
0x00010378  bl       #0x2480c   ; call _objc_release
0x0001037c  ldr      x0, [x19, #0x20]
0x00010380  ldp      x29, x30, [sp, #0x10]
0x00010384  ldp      x20, x19, [sp], #0x20
0x00010388  b        #0x2480c   ; call _objc_release
0x0001038c  stp      d11, d10, [sp, #-0x50]!
0x00010390  stp      d9, d8, [sp, #0x10]
0x00010394  stp      x22, x21, [sp, #0x20]
0x00010398  stp      x20, x19, [sp, #0x30]
0x0001039c  stp      x29, x30, [sp, #0x40]
0x000103a0  add      x29, sp, #0x40
0x000103a4  mov      v8.16b, v3.16b
0x000103a8  mov      v9.16b, v2.16b
0x000103ac  mov      v10.16b, v1.16b
0x000103b0  mov      v11.16b, v0.16b
0x000103b4  bl       #0x26520   ; objc_msgSend: paneFor:
0x000103b8  mov      x29, x29
0x000103bc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000103c0  mov      x19, x0
0x000103c4  cbz      x0, #0x103f8
0x000103c8  mov      x0, x19
0x000103cc  bl       #0x24f60   ; objc_msgSend: box
0x000103d0  mov      x29, x29
0x000103d4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000103d8  mov      x20, x0
0x000103dc  mov      v0.16b, v11.16b
0x000103e0  mov      v1.16b, v10.16b
0x000103e4  mov      v2.16b, v9.16b
0x000103e8  mov      v3.16b, v8.16b
0x000103ec  bl       #0x274c0   ; objc_msgSend: setPassInsets:
0x000103f0  mov      x0, x20
0x000103f4  bl       #0x2480c   ; call _objc_release
0x000103f8  mov      x0, x19
0x000103fc  ldp      x29, x30, [sp, #0x40]
0x00010400  ldp      x20, x19, [sp, #0x30]
0x00010404  ldp      x22, x21, [sp, #0x20]
0x00010408  ldp      d9, d8, [sp, #0x10]
0x0001040c  ldp      d11, d10, [sp], #0x50
0x00010410  b        #0x2480c   ; call _objc_release
0x00010414  mov      x21, x0
0x00010418  mov      x0, x20
0x0001041c  bl       #0x2480c   ; call _objc_release
0x00010420  b        #0x10428   ; call sub_10428
0x00010424  mov      x21, x0
0x00010428  mov      x0, x19
0x0001042c  bl       #0x2480c   ; call _objc_release
0x00010430  mov      x0, x21
0x00010434  bl       #0x24470   ; call __Unwind_Resume
0x00010438  stp      d9, d8, [sp, #-0x40]!
0x0001043c  stp      x22, x21, [sp, #0x10]
0x00010440  stp      x20, x19, [sp, #0x20]
0x00010444  stp      x29, x30, [sp, #0x30]
0x00010448  add      x29, sp, #0x30
0x0001044c  mov      x20, x2
0x00010450  mov      v8.16b, v0.16b
0x00010454  mov      x2, x3
0x00010458  bl       #0x26520   ; objc_msgSend: paneFor:
0x0001045c  mov      x29, x29
0x00010460  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010464  mov      x19, x0
0x00010468  cbz      x0, #0x1054c
0x0001046c  mov      x0, x19
0x00010470  bl       #0x24f60   ; objc_msgSend: box
0x00010474  mov      x29, x29
0x00010478  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001047c  mov      x21, x0
0x00010480  bl       #0x25f00   ; objc_msgSend: layer
0x00010484  mov      x29, x29
0x00010488  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001048c  mov      x22, x0
0x00010490  mov      v0.16b, v8.16b
0x00010494  bl       #0x26e20   ; objc_msgSend: setCornerRadius:
0x00010498  mov      x0, x22
0x0001049c  bl       #0x2480c   ; call _objc_release
0x000104a0  mov      x0, x21
0x000104a4  bl       #0x2480c   ; call _objc_release
0x000104a8  mov      x0, x19
0x000104ac  bl       #0x24f60   ; objc_msgSend: box
0x000104b0  mov      x29, x29
0x000104b4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000104b8  mov      x21, x0
0x000104bc  bl       #0x25f00   ; objc_msgSend: layer
0x000104c0  mov      x29, x29
0x000104c4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000104c8  mov      x22, x0
0x000104cc  mov      x2, x20
0x000104d0  bl       #0x27340   ; objc_msgSend: setMaskedCorners:
0x000104d4  mov      x0, x22
0x000104d8  bl       #0x2480c   ; call _objc_release
0x000104dc  mov      x0, x21
0x000104e0  bl       #0x2480c   ; call _objc_release
0x000104e4  mov      x0, x19
0x000104e8  bl       #0x24f60   ; objc_msgSend: box
0x000104ec  mov      x29, x29
0x000104f0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000104f4  mov      x21, x0
0x000104f8  bl       #0x25f00   ; objc_msgSend: layer
0x000104fc  mov      x29, x29
0x00010500  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010504  mov      x20, x0
0x00010508  adrp     x8, #0x34000
0x0001050c  ldr      x8, [x8, #0x580]   ; -> [got:_kCACornerCurveContinuous]
0x00010510  ldr      x2, [x8]   ; -> [got:___objc_personality_v0]
0x00010514  bl       #0x26e00   ; objc_msgSend: setCornerCurve:
0x00010518  mov      x0, x20
0x0001051c  bl       #0x2480c   ; call _objc_release
0x00010520  mov      x0, x21
0x00010524  bl       #0x2480c   ; call _objc_release
0x00010528  mov      x0, x19
0x0001052c  bl       #0x24f60   ; objc_msgSend: box
0x00010530  mov      x29, x29
0x00010534  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010538  mov      x21, x0
0x0001053c  mov      w2, #1
0x00010540  bl       #0x26d80   ; objc_msgSend: setClipsToBounds:
0x00010544  mov      x0, x21
0x00010548  bl       #0x2480c   ; call _objc_release
0x0001054c  mov      x0, x19
0x00010550  ldp      x29, x30, [sp, #0x30]
0x00010554  ldp      x20, x19, [sp, #0x20]
0x00010558  ldp      x22, x21, [sp, #0x10]
0x0001055c  ldp      d9, d8, [sp], #0x40
0x00010560  b        #0x2480c   ; call _objc_release
0x00010564  b        #0x10594   ; call sub_10594
0x00010568  mov      x1, x20
0x0001056c  mov      x20, x0
0x00010570  mov      x0, x1
0x00010574  b        #0x1058c   ; call sub_1058c
0x00010578  b        #0x10594   ; call sub_10594
0x0001057c  b        #0x10584   ; call sub_10584
0x00010580  b        #0x10594   ; call sub_10594
0x00010584  mov      x20, x0
0x00010588  mov      x0, x22
0x0001058c  bl       #0x2480c   ; call _objc_release
0x00010590  b        #0x10598   ; call sub_10598
0x00010594  mov      x20, x0
0x00010598  mov      x0, x21
0x0001059c  bl       #0x2480c   ; call _objc_release
0x000105a0  b        #0x105a8   ; call sub_105a8
0x000105a4  mov      x20, x0
0x000105a8  mov      x0, x19
0x000105ac  bl       #0x2480c   ; call _objc_release
0x000105b0  mov      x0, x20
0x000105b4  bl       #0x24470   ; call __Unwind_Resume
0x000105b8  stp      d13, d12, [sp, #-0x90]!
0x000105bc  stp      d11, d10, [sp, #0x10]
0x000105c0  stp      d9, d8, [sp, #0x20]
0x000105c4  stp      x28, x27, [sp, #0x30]
0x000105c8  stp      x26, x25, [sp, #0x40]
0x000105cc  stp      x24, x23, [sp, #0x50]
0x000105d0  stp      x22, x21, [sp, #0x60]
0x000105d4  stp      x20, x19, [sp, #0x70]
0x000105d8  stp      x29, x30, [sp, #0x80]
0x000105dc  add      x29, sp, #0x80
0x000105e0  sub      sp, sp, #0x200
0x000105e4  mov      x26, x2
0x000105e8  mov      x20, x0
0x000105ec  adrp     x8, #0x34000
0x000105f0  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x000105f4  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x000105f8  stur     x8, [x29, #-0x90]
0x000105fc  mov      x0, x2
0x00010600  bl       #0x24818   ; call _objc_retain
0x00010604  adrp     x0, #0x36000
0x00010608  add      x0, x0, #0x2d0   ; -> @"�i"
0x0001060c  adrp     x1, #0x36000
0x00010610  add      x1, x1, #0x2f0   ; -> @"Change app"
0x00010614  str      x26, [sp, #0x28]
0x00010618  bl       #0x23a38   ; call _OMCTr
0x0001061c  mov      x29, x29
0x00010620  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010624  mov      x21, x0
0x00010628  adrp     x19, #0x3e000
0x0001062c  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x00010630  adrp     x8, #0x2b000
0x00010634  ldr      d8, [x8, #0x218]
0x00010638  adrp     x8, #0x2b000
0x0001063c  ldr      d9, [x8, #0x220]
0x00010640  adrp     x8, #0x2b000
0x00010644  ldr      d10, [x8, #0x228]
0x00010648  fmov     d3, #1.00000000
0x0001064c  mov      v0.16b, v8.16b
0x00010650  mov      v1.16b, v9.16b
0x00010654  mov      v2.16b, v10.16b
0x00010658  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001065c  mov      x29, x29
0x00010660  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010664  mov      x22, x0
0x00010668  adrp     x8, #0x3d000
0x0001066c  ldr      x4, [x8, #0x268]   ; -> [@selector(barReplace:)]
0x00010670  adrp     x0, #0x36000
0x00010674  add      x0, x0, #0x2b0   ; -> @"hm_apps"
0x00010678  mov      x1, x21
0x0001067c  mov      x2, x22
0x00010680  mov      x3, x20
0x00010684  bl       #0x112b0   ; call sub_112b0
0x00010688  mov      x29, x29
0x0001068c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010690  str      x0, [sp]
0x00010694  mov      x0, x22
0x00010698  bl       #0x2480c   ; call _objc_release
0x0001069c  mov      x0, x21
0x000106a0  bl       #0x2480c   ; call _objc_release
0x000106a4  adrp     x0, #0x36000
0x000106a8  add      x0, x0, #0x330   ; -> @"T"
0x000106ac  adrp     x1, #0x36000
0x000106b0  add      x1, x1, #0x350   ; -> @"Full screen"
0x000106b4  bl       #0x23a38   ; call _OMCTr
0x000106b8  mov      x29, x29
0x000106bc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000106c0  mov      x22, x0
0x000106c4  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x000106c8  fmov     d3, #1.00000000
0x000106cc  mov      v0.16b, v8.16b
0x000106d0  mov      v1.16b, v9.16b
0x000106d4  mov      v2.16b, v10.16b
0x000106d8  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x000106dc  mov      x29, x29
0x000106e0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000106e4  mov      x23, x0
0x000106e8  adrp     x8, #0x3d000
0x000106ec  ldr      x4, [x8, #0x270]   ; -> [@selector(barFull:)]
0x000106f0  adrp     x0, #0x36000
0x000106f4  add      x0, x0, #0x310   ; -> @"hm_full"
0x000106f8  mov      x1, x22
0x000106fc  mov      x2, x23
0x00010700  mov      x3, x20
0x00010704  bl       #0x112b0   ; call sub_112b0
0x00010708  mov      x29, x29
0x0001070c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010710  str      x0, [sp, #8]
0x00010714  mov      x0, x23
0x00010718  bl       #0x2480c   ; call _objc_release
0x0001071c  mov      x0, x22
0x00010720  bl       #0x2480c   ; call _objc_release
0x00010724  adrp     x0, #0x36000
0x00010728  add      x0, x0, #0x390   ; -> @"C"
0x0001072c  adrp     x1, #0x36000
0x00010730  add      x1, x1, #0x3b0   ; -> @"Float"
0x00010734  bl       #0x23a38   ; call _OMCTr
0x00010738  mov      x29, x29
0x0001073c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010740  mov      x23, x0
0x00010744  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x00010748  fmov     d3, #1.00000000
0x0001074c  mov      v0.16b, v8.16b
0x00010750  mov      v1.16b, v9.16b
0x00010754  mov      v2.16b, v10.16b
0x00010758  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001075c  mov      x29, x29
0x00010760  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010764  mov      x24, x0
0x00010768  adrp     x8, #0x3d000
0x0001076c  ldr      x4, [x8, #0x278]   ; -> [@selector(barPop:)]
0x00010770  adrp     x0, #0x36000
0x00010774  add      x0, x0, #0x370   ; -> @"hm_float"
0x00010778  mov      x1, x23
0x0001077c  mov      x2, x24
0x00010780  mov      x3, x20
0x00010784  bl       #0x112b0   ; call sub_112b0
0x00010788  mov      x29, x29
0x0001078c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010790  str      x0, [sp, #0x20]
0x00010794  mov      x0, x24
0x00010798  bl       #0x2480c   ; call _objc_release
0x0001079c  mov      x0, x23
0x000107a0  bl       #0x2480c   ; call _objc_release
0x000107a4  adrp     x0, #0x36000
0x000107a8  add      x0, x0, #0x3f0   ; -> @"C"
0x000107ac  adrp     x1, #0x36000
0x000107b0  add      x1, x1, #0x410   ; -> @"Background"
0x000107b4  bl       #0x23a38   ; call _OMCTr
0x000107b8  mov      x29, x29
0x000107bc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000107c0  mov      x23, x0
0x000107c4  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x000107c8  fmov     d3, #1.00000000
0x000107cc  mov      v0.16b, v8.16b
0x000107d0  mov      v1.16b, v9.16b
0x000107d4  mov      v2.16b, v10.16b
0x000107d8  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x000107dc  mov      x29, x29
0x000107e0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000107e4  mov      x24, x0
0x000107e8  adrp     x8, #0x3d000
0x000107ec  ldr      x4, [x8, #0x280]   ; -> [@selector(barBackground:)]
0x000107f0  adrp     x0, #0x36000
0x000107f4  add      x0, x0, #0x3d0   ; -> @"hm_min"
0x000107f8  mov      x1, x23
0x000107fc  mov      x2, x24
0x00010800  mov      x3, x20
0x00010804  bl       #0x112b0   ; call sub_112b0
0x00010808  mov      x29, x29
0x0001080c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010810  str      x0, [sp, #0x10]
0x00010814  mov      x0, x24
0x00010818  bl       #0x2480c   ; call _objc_release
0x0001081c  mov      x0, x23
0x00010820  bl       #0x2480c   ; call _objc_release
0x00010824  adrp     x0, #0x36000
0x00010828  add      x0, x0, #0x450   ; -> @"T"
0x0001082c  adrp     x1, #0x36000
0x00010830  add      x1, x1, #0x470   ; -> @"Quit app"
0x00010834  bl       #0x23a38   ; call _OMCTr
0x00010838  mov      x29, x29
0x0001083c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010840  mov      x23, x0
0x00010844  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x00010848  adrp     x8, #0x2b000
0x0001084c  ldr      d1, [x8, #0x230]
0x00010850  adrp     x8, #0x2b000
0x00010854  ldr      d2, [x8, #0x238]
0x00010858  fmov     d0, #1.00000000
0x0001085c  fmov     d3, #1.00000000
0x00010860  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x00010864  mov      x29, x29
0x00010868  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001086c  mov      x25, x0
0x00010870  adrp     x8, #0x3d000
0x00010874  ldr      x4, [x8, #0x288]   ; -> [@selector(barClose:)]
0x00010878  adrp     x0, #0x36000
0x0001087c  add      x0, x0, #0x430   ; -> @"hm_close"
0x00010880  mov      x1, x23
0x00010884  mov      x2, x25
0x00010888  mov      x3, x20
0x0001088c  bl       #0x112b0   ; call sub_112b0
0x00010890  mov      x29, x29
0x00010894  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010898  str      x0, [sp, #0x18]
0x0001089c  mov      x0, x25
0x000108a0  bl       #0x2480c   ; call _objc_release
0x000108a4  mov      x0, x23
0x000108a8  bl       #0x2480c   ; call _objc_release
0x000108ac  mov      x0, x26
0x000108b0  ldr      x2, [sp, #0x20]
0x000108b4  ldr      x20, [sp, #8]
0x000108b8  bl       #0x27520   ; objc_msgSend: setPopButton:
0x000108bc  mov      x0, x26
0x000108c0  mov      x2, x20
0x000108c4  bl       #0x27820   ; objc_msgSend: setSoloButton:
0x000108c8  ldr      x8, [sp]
0x000108cc  stp      x8, x20, [x29, #-0xc0]
0x000108d0  ldr      x9, [sp, #0x20]
0x000108d4  ldr      x8, [sp, #0x10]
0x000108d8  stp      x9, x8, [x29, #-0xb0]
0x000108dc  adrp     x8, #0x3e000
0x000108e0  ldr      x0, [x8, #0x340]   ; -> [class(NSNull)]
0x000108e4  bl       #0x26280   ; objc_msgSend: null
0x000108e8  mov      x29, x29
0x000108ec  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000108f0  mov      x20, x0
0x000108f4  ldr      x8, [sp, #0x18]
0x000108f8  stp      x0, x8, [x29, #-0xa0]
0x000108fc  adrp     x8, #0x3e000
0x00010900  ldr      x0, [x8, #0x2a8]   ; -> [class(NSArray)]
0x00010904  sub      x2, x29, #0xc0
0x00010908  mov      w3, #6
0x0001090c  bl       #0x24e20   ; objc_msgSend: arrayWithObjects:count:
0x00010910  mov      x29, x29
0x00010914  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010918  mov      x25, x0
0x0001091c  mov      x0, x20
0x00010920  bl       #0x2480c   ; call _objc_release
0x00010924  movi     v0.16b, #0
0x00010928  stp      q0, q0, [sp, #0xa0]
0x0001092c  stp      q0, q0, [sp, #0x80]
0x00010930  mov      x0, x25
0x00010934  bl       #0x24818   ; call _objc_retain
0x00010938  add      x2, sp, #0x80
0x0001093c  add      x3, sp, #0x140
0x00010940  mov      x0, x25
0x00010944  mov      w4, #0x10
0x00010948  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001094c  mov      x20, x0
0x00010950  adrp     x21, #0x3e000
0x00010954  cbz      x0, #0x109e0
0x00010958  ldr      x8, [sp, #0x90]
0x0001095c  ldr      x22, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00010960  fmov     d8, #12.00000000
0x00010964  mov      x24, #0x4048000000000000
0x00010968  fmov     d9, #7.00000000
0x0001096c  mov      x26, #0
0x00010970  ldr      x8, [sp, #0x90]
0x00010974  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00010978  cmp      x8, x22
0x0001097c  b.eq     #0x10988
0x00010980  mov      x0, x25
0x00010984  bl       #0x24770   ; call _objc_enumerationMutation
0x00010988  ldr      x8, [sp, #0x88]
0x0001098c  ldr      x23, [x8, x26, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x00010990  ldr      x0, [x21, #0x348]   ; -> [class(UIButton)]
0x00010994  bl       #0x247d0   ; call _objc_opt_class
0x00010998  mov      x1, x0
0x0001099c  mov      x0, x23
0x000109a0  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x000109a4  tst      w0, #1
0x000109a8  fmov     d0, x24
0x000109ac  fcsel    d0, d0, d9, ne
0x000109b0  fadd     d8, d8, d0
0x000109b4  add      x26, x26, #1
0x000109b8  cmp      x20, x26
0x000109bc  b.ne     #0x10970
0x000109c0  add      x2, sp, #0x80
0x000109c4  add      x3, sp, #0x140
0x000109c8  mov      x0, x25
0x000109cc  mov      w4, #0x10
0x000109d0  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x000109d4  mov      x20, x0
0x000109d8  cbnz     x0, #0x1096c
0x000109dc  b        #0x109e4   ; call sub_109e4
0x000109e0  fmov     d8, #12.00000000
0x000109e4  mov      x0, x25
0x000109e8  bl       #0x2480c   ; call _objc_release
0x000109ec  adrp     x22, #0x3e000
0x000109f0  ldr      x0, [x22, #0x2d0]   ; -> [class(UIView)]
0x000109f4  bl       #0x2471c   ; call _objc_alloc
0x000109f8  mov      x8, #0x404a000000000000
0x000109fc  fmov     d3, x8
0x00010a00  fmov     d0, xzr
0x00010a04  fmov     d1, xzr
0x00010a08  mov      v2.16b, v8.16b
0x00010a0c  bl       #0x25a40   ; objc_msgSend: initWithFrame:
0x00010a10  mov      x26, x0
0x00010a14  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x00010a18  bl       #0x251a0   ; objc_msgSend: clearColor
0x00010a1c  mov      x29, x29
0x00010a20  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010a24  mov      x20, x0
0x00010a28  mov      x0, x26
0x00010a2c  mov      x2, x20
0x00010a30  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x00010a34  mov      x0, x20
0x00010a38  bl       #0x2480c   ; call _objc_release
0x00010a3c  mov      x0, x26
0x00010a40  bl       #0x25f00   ; objc_msgSend: layer
0x00010a44  mov      x29, x29
0x00010a48  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010a4c  mov      x20, x0
0x00010a50  fmov     d0, #22.00000000
0x00010a54  bl       #0x26e20   ; objc_msgSend: setCornerRadius:
0x00010a58  mov      x0, x20
0x00010a5c  bl       #0x2480c   ; call _objc_release
0x00010a60  mov      x0, x26
0x00010a64  bl       #0x25f00   ; objc_msgSend: layer
0x00010a68  mov      x29, x29
0x00010a6c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010a70  mov      x23, x0
0x00010a74  adrp     x8, #0x34000
0x00010a78  ldr      x8, [x8, #0x580]   ; -> [got:_kCACornerCurveContinuous]
0x00010a7c  ldr      x20, [x8]   ; -> [got:___objc_personality_v0]
0x00010a80  mov      x2, x20
0x00010a84  bl       #0x26e00   ; objc_msgSend: setCornerCurve:
0x00010a88  mov      x0, x23
0x00010a8c  bl       #0x2480c   ; call _objc_release
0x00010a90  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x00010a94  adrp     x8, #0x2b000
0x00010a98  ldr      d0, [x8, #0x240]
0x00010a9c  adrp     x8, #0x2b000
0x00010aa0  ldr      d1, [x8, #0x248]
0x00010aa4  adrp     x8, #0x2b000
0x00010aa8  ldr      d2, [x8, #0x250]
0x00010aac  fmov     d3, #1.00000000
0x00010ab0  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x00010ab4  mov      x29, x29
0x00010ab8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010abc  mov      x23, x0
0x00010ac0  bl       #0x24824   ; call _objc_retainAutorelease
0x00010ac4  mov      x0, x23
0x00010ac8  bl       #0x249e0   ; objc_msgSend: CGColor
0x00010acc  mov      x24, x0
0x00010ad0  mov      x0, x26
0x00010ad4  bl       #0x25f00   ; objc_msgSend: layer
0x00010ad8  mov      x29, x29
0x00010adc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010ae0  mov      x27, x0
0x00010ae4  mov      x2, x24
0x00010ae8  bl       #0x276e0   ; objc_msgSend: setShadowColor:
0x00010aec  mov      x0, x27
0x00010af0  bl       #0x2480c   ; call _objc_release
0x00010af4  mov      x0, x23
0x00010af8  bl       #0x2480c   ; call _objc_release
0x00010afc  mov      x0, x26
0x00010b00  bl       #0x25f00   ; objc_msgSend: layer
0x00010b04  mov      x29, x29
0x00010b08  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010b0c  mov      x23, x0
0x00010b10  adrp     x8, #0x2b000
0x00010b14  ldr      s0, [x8, #0x388]
0x00010b18  bl       #0x27720   ; objc_msgSend: setShadowOpacity:
0x00010b1c  mov      x0, x23
0x00010b20  bl       #0x2480c   ; call _objc_release
0x00010b24  mov      x0, x26
0x00010b28  bl       #0x25f00   ; objc_msgSend: layer
0x00010b2c  mov      x29, x29
0x00010b30  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010b34  mov      x23, x0
0x00010b38  fmov     d0, #14.00000000
0x00010b3c  bl       #0x27760   ; objc_msgSend: setShadowRadius:
0x00010b40  mov      x0, x23
0x00010b44  bl       #0x2480c   ; call _objc_release
0x00010b48  mov      x0, x26
0x00010b4c  bl       #0x25f00   ; objc_msgSend: layer
0x00010b50  mov      x29, x29
0x00010b54  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010b58  mov      x23, x0
0x00010b5c  fmov     d0, xzr
0x00010b60  fmov     d1, #6.00000000
0x00010b64  bl       #0x27700   ; objc_msgSend: setShadowOffset:
0x00010b68  mov      x0, x23
0x00010b6c  bl       #0x2480c   ; call _objc_release
0x00010b70  adrp     x8, #0x3e000
0x00010b74  ldr      x0, [x8, #0x350]   ; -> [class(UIVisualEffectView)]
0x00010b78  bl       #0x2471c   ; call _objc_alloc
0x00010b7c  mov      x27, x0
0x00010b80  adrp     x8, #0x3e000
0x00010b84  ldr      x0, [x8, #0x358]   ; -> [class(UIBlurEffect)]
0x00010b88  mov      w2, #0xb
0x00010b8c  bl       #0x25680   ; objc_msgSend: effectWithStyle:
0x00010b90  mov      x29, x29
0x00010b94  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010b98  mov      x23, x0
0x00010b9c  mov      x0, x27
0x00010ba0  mov      x2, x23
0x00010ba4  bl       #0x25a20   ; objc_msgSend: initWithEffect:
0x00010ba8  str      x0, [sp, #0x38]
0x00010bac  mov      x0, x23
0x00010bb0  bl       #0x2480c   ; call _objc_release
0x00010bb4  mov      x0, x26
0x00010bb8  bl       #0x24f40   ; objc_msgSend: bounds
0x00010bbc  ldr      x0, [sp, #0x38]
0x00010bc0  bl       #0x26f80   ; objc_msgSend: setFrame:
0x00010bc4  adrp     x8, #0x3e000
0x00010bc8  ldr      x0, [x8, #0x360]   ; -> [class(UIImageView)]
0x00010bcc  bl       #0x2471c   ; call _objc_alloc
0x00010bd0  mov      x24, x0
0x00010bd4  mov      w0, #0
0x00010bd8  bl       #0x23cb0   ; call _OMCLogoMeshImage
0x00010bdc  mov      x29, x29
0x00010be0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010be4  mov      x23, x0
0x00010be8  mov      x0, x24
0x00010bec  mov      x2, x23
0x00010bf0  bl       #0x25a60   ; objc_msgSend: initWithImage:
0x00010bf4  str      x0, [sp, #0x30]
0x00010bf8  mov      x0, x23
0x00010bfc  bl       #0x2480c   ; call _objc_release
0x00010c00  ldr      x0, [sp, #0x38]
0x00010c04  bl       #0x253a0   ; objc_msgSend: contentView
0x00010c08  mov      x29, x29
0x00010c0c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010c10  mov      x23, x0
0x00010c14  bl       #0x24f40   ; objc_msgSend: bounds
0x00010c18  ldr      x0, [sp, #0x30]
0x00010c1c  bl       #0x26f80   ; objc_msgSend: setFrame:
0x00010c20  mov      x0, x23
0x00010c24  bl       #0x2480c   ; call _objc_release
0x00010c28  ldr      x0, [sp, #0x30]
0x00010c2c  mov      x2, #0
0x00010c30  bl       #0x26de0   ; objc_msgSend: setContentMode:
0x00010c34  ldr      x0, [sp, #0x30]
0x00010c38  mov      w2, #0x12
0x00010c3c  bl       #0x26c00   ; objc_msgSend: setAutoresizingMask:
0x00010c40  ldr      x0, [sp, #0x38]
0x00010c44  bl       #0x253a0   ; objc_msgSend: contentView
0x00010c48  mov      x29, x29
0x00010c4c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010c50  mov      x23, x0
0x00010c54  ldr      x2, [sp, #0x30]
0x00010c58  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x00010c5c  mov      x0, x23
0x00010c60  bl       #0x2480c   ; call _objc_release
0x00010c64  ldr      x0, [sp, #0x38]
0x00010c68  bl       #0x25f00   ; objc_msgSend: layer
0x00010c6c  mov      x29, x29
0x00010c70  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010c74  mov      x23, x0
0x00010c78  fmov     d0, #22.00000000
0x00010c7c  bl       #0x26e20   ; objc_msgSend: setCornerRadius:
0x00010c80  mov      x0, x23
0x00010c84  bl       #0x2480c   ; call _objc_release
0x00010c88  ldr      x0, [sp, #0x38]
0x00010c8c  bl       #0x25f00   ; objc_msgSend: layer
0x00010c90  mov      x29, x29
0x00010c94  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010c98  mov      x23, x0
0x00010c9c  mov      x2, x20
0x00010ca0  bl       #0x26e00   ; objc_msgSend: setCornerCurve:
0x00010ca4  mov      x0, x23
0x00010ca8  bl       #0x2480c   ; call _objc_release
0x00010cac  ldr      x0, [sp, #0x38]
0x00010cb0  bl       #0x25f00   ; objc_msgSend: layer
0x00010cb4  mov      x29, x29
0x00010cb8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010cbc  mov      x20, x0
0x00010cc0  fmov     d0, #1.00000000
0x00010cc4  bl       #0x26ca0   ; objc_msgSend: setBorderWidth:
0x00010cc8  mov      x0, x20
0x00010ccc  bl       #0x2480c   ; call _objc_release
0x00010cd0  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x00010cd4  adrp     x8, #0x2b000
0x00010cd8  ldr      d1, [x8, #0x258]
0x00010cdc  fmov     d0, #1.00000000
0x00010ce0  bl       #0x25240   ; objc_msgSend: colorWithWhite:alpha:
0x00010ce4  mov      x29, x29
0x00010ce8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010cec  mov      x20, x0
0x00010cf0  bl       #0x24824   ; call _objc_retainAutorelease
0x00010cf4  mov      x0, x20
0x00010cf8  bl       #0x249e0   ; objc_msgSend: CGColor
0x00010cfc  mov      x24, x0
0x00010d00  ldr      x0, [sp, #0x38]
0x00010d04  bl       #0x25f00   ; objc_msgSend: layer
0x00010d08  mov      x29, x29
0x00010d0c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010d10  mov      x23, x0
0x00010d14  mov      x2, x24
0x00010d18  bl       #0x26c80   ; objc_msgSend: setBorderColor:
0x00010d1c  mov      x0, x23
0x00010d20  bl       #0x2480c   ; call _objc_release
0x00010d24  mov      x0, x20
0x00010d28  bl       #0x2480c   ; call _objc_release
0x00010d2c  ldr      x0, [sp, #0x38]
0x00010d30  mov      w2, #1
0x00010d34  bl       #0x26d80   ; objc_msgSend: setClipsToBounds:
0x00010d38  ldr      x0, [sp, #0x38]
0x00010d3c  mov      w2, #0
0x00010d40  bl       #0x279e0   ; objc_msgSend: setUserInteractionEnabled:
0x00010d44  mov      x0, x26
0x00010d48  ldr      x2, [sp, #0x38]
0x00010d4c  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x00010d50  movi     v0.16b, #0
0x00010d54  stp      q0, q0, [sp, #0x60]
0x00010d58  stp      q0, q0, [sp, #0x40]
0x00010d5c  mov      x0, x25
0x00010d60  bl       #0x24818   ; call _objc_retain
0x00010d64  add      x2, sp, #0x40
0x00010d68  add      x3, sp, #0xc0
0x00010d6c  mov      x0, x25
0x00010d70  mov      w4, #0x10
0x00010d74  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00010d78  mov      x20, x0
0x00010d7c  cbz      x0, #0x10ea8
0x00010d80  ldr      x8, [sp, #0x50]
0x00010d84  ldr      x28, [x8]
0x00010d88  fmov     d9, #6.00000000
0x00010d8c  fmov     d10, #24.00000000
0x00010d90  fmov     d11, #3.00000000
0x00010d94  adrp     x8, #0x2b000
0x00010d98  ldr      d8, [x8, #0x260]
0x00010d9c  mov      x27, #0
0x00010da0  ldr      x8, [sp, #0x50]
0x00010da4  ldr      x8, [x8]
0x00010da8  cmp      x8, x28
0x00010dac  b.eq     #0x10db8
0x00010db0  mov      x0, x25
0x00010db4  bl       #0x24770   ; call _objc_enumerationMutation
0x00010db8  ldr      x8, [sp, #0x48]
0x00010dbc  ldr      x23, [x8, x27, lsl #3]
0x00010dc0  ldr      x0, [x21, #0x348]   ; -> [class(UIButton)]
0x00010dc4  bl       #0x247d0   ; call _objc_opt_class
0x00010dc8  mov      x1, x0
0x00010dcc  mov      x0, x23
0x00010dd0  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x00010dd4  tbz      w0, #0, #0x10e08
0x00010dd8  mov      x0, x23
0x00010ddc  bl       #0x24818   ; call _objc_retain
0x00010de0  fadd     d0, d9, d10
0x00010de4  fmov     d1, #26.00000000
0x00010de8  mov      x0, x23
0x00010dec  bl       #0x26d60   ; objc_msgSend: setCenter:
0x00010df0  mov      x0, x26
0x00010df4  mov      x2, x23
0x00010df8  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x00010dfc  mov      x8, #0x4048000000000000
0x00010e00  fmov     d12, x8
0x00010e04  b        #0x10e74   ; call sub_10e74
0x00010e08  ldr      x0, [x22, #0x2d0]   ; -> [class(UIView)]
0x00010e0c  bl       #0x2471c   ; call _objc_alloc
0x00010e10  fadd     d0, d9, d11
0x00010e14  fmov     d1, #11.00000000
0x00010e18  fmov     d2, #1.00000000
0x00010e1c  fmov     d3, #30.00000000
0x00010e20  bl       #0x25a40   ; objc_msgSend: initWithFrame:
0x00010e24  mov      x23, x0
0x00010e28  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x00010e2c  fmov     d0, #1.00000000
0x00010e30  mov      v1.16b, v8.16b
0x00010e34  bl       #0x25240   ; objc_msgSend: colorWithWhite:alpha:
0x00010e38  mov      x29, x29
0x00010e3c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010e40  mov      x24, x0
0x00010e44  mov      x0, x23
0x00010e48  mov      x2, x24
0x00010e4c  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x00010e50  mov      x0, x24
0x00010e54  bl       #0x2480c   ; call _objc_release
0x00010e58  mov      x0, x23
0x00010e5c  mov      w2, #0
0x00010e60  bl       #0x279e0   ; objc_msgSend: setUserInteractionEnabled:
0x00010e64  fmov     d12, #7.00000000
0x00010e68  mov      x0, x26
0x00010e6c  mov      x2, x23
0x00010e70  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x00010e74  mov      x0, x23
0x00010e78  bl       #0x2480c   ; call _objc_release
0x00010e7c  fadd     d9, d9, d12
0x00010e80  add      x27, x27, #1
0x00010e84  cmp      x20, x27
0x00010e88  b.ne     #0x10da0
0x00010e8c  add      x2, sp, #0x40
0x00010e90  add      x3, sp, #0xc0
0x00010e94  mov      x0, x25
0x00010e98  mov      w4, #0x10
0x00010e9c  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00010ea0  mov      x20, x0
0x00010ea4  cbnz     x0, #0x10d9c
0x00010ea8  mov      x0, x25
0x00010eac  bl       #0x2480c   ; call _objc_release
0x00010eb0  mov      x0, x26
0x00010eb4  mov      w2, #1
0x00010eb8  bl       #0x270a0   ; objc_msgSend: setHidden:
0x00010ebc  fmov     d0, xzr
0x00010ec0  mov      x0, x26
0x00010ec4  bl       #0x26b40   ; objc_msgSend: setAlpha:
0x00010ec8  ldr      x0, [sp, #0x28]
0x00010ecc  mov      x2, x26
0x00010ed0  bl       #0x26c40   ; objc_msgSend: setBar:
0x00010ed4  ldr      x0, [sp, #0x28]
0x00010ed8  bl       #0x24f60   ; objc_msgSend: box
0x00010edc  mov      x29, x29
0x00010ee0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010ee4  mov      x20, x0
0x00010ee8  mov      x2, x26
0x00010eec  bl       #0x26c40   ; objc_msgSend: setBar:
0x00010ef0  mov      x0, x20
0x00010ef4  bl       #0x2480c   ; call _objc_release
0x00010ef8  ldr      x0, [sp, #0x28]
0x00010efc  bl       #0x24f60   ; objc_msgSend: box
0x00010f00  mov      x29, x29
0x00010f04  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010f08  mov      x20, x0
0x00010f0c  mov      x2, x26
0x00010f10  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x00010f14  mov      x0, x20
0x00010f18  bl       #0x2480c   ; call _objc_release
0x00010f1c  ldr      x0, [sp, #0x30]
0x00010f20  bl       #0x2480c   ; call _objc_release
0x00010f24  ldr      x0, [sp, #0x38]
0x00010f28  bl       #0x2480c   ; call _objc_release
0x00010f2c  mov      x0, x25
0x00010f30  bl       #0x2480c   ; call _objc_release
0x00010f34  ldr      x0, [sp, #0x18]
0x00010f38  bl       #0x2480c   ; call _objc_release
0x00010f3c  ldr      x0, [sp, #0x10]
0x00010f40  bl       #0x2480c   ; call _objc_release
0x00010f44  ldr      x0, [sp, #0x20]
0x00010f48  bl       #0x2480c   ; call _objc_release
0x00010f4c  ldr      x0, [sp, #8]
0x00010f50  bl       #0x2480c   ; call _objc_release
0x00010f54  ldr      x0, [sp]
0x00010f58  bl       #0x2480c   ; call _objc_release
0x00010f5c  ldr      x0, [sp, #0x28]
0x00010f60  bl       #0x2480c   ; call _objc_release
0x00010f64  ldur     x8, [x29, #-0x90]
0x00010f68  adrp     x9, #0x34000
0x00010f6c  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00010f70  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x00010f74  cmp      x9, x8
0x00010f78  b.ne     #0x10fac
0x00010f7c  mov      x0, x26
0x00010f80  add      sp, sp, #0x200
0x00010f84  ldp      x29, x30, [sp, #0x80]
0x00010f88  ldp      x20, x19, [sp, #0x70]
0x00010f8c  ldp      x22, x21, [sp, #0x60]
0x00010f90  ldp      x24, x23, [sp, #0x50]
0x00010f94  ldp      x26, x25, [sp, #0x40]
0x00010f98  ldp      x28, x27, [sp, #0x30]
0x00010f9c  ldp      d9, d8, [sp, #0x20]
0x00010fa0  ldp      d11, d10, [sp, #0x10]
0x00010fa4  ldp      d13, d12, [sp], #0x90
0x00010fa8  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x00010fac  bl       #0x24488   ; call ___stack_chk_fail
0x00010fb0  mov      x19, x0
0x00010fb4  mov      x0, x20
0x00010fb8  bl       #0x2480c   ; call _objc_release
0x00010fbc  b        #0x11240   ; call sub_11240
0x00010fc0  mov      x19, x0
0x00010fc4  mov      x0, x20
0x00010fc8  bl       #0x2480c   ; call _objc_release
0x00010fcc  b        #0x11240   ; call sub_11240
0x00010fd0  b        #0x11234   ; call sub_11234
0x00010fd4  mov      x19, x0
0x00010fd8  mov      x0, x23
0x00010fdc  bl       #0x2480c   ; call _objc_release
0x00010fe0  b        #0x11198   ; call sub_11198
0x00010fe4  mov      x19, x0
0x00010fe8  mov      x0, x20
0x00010fec  bl       #0x2480c   ; call _objc_release
0x00010ff0  b        #0x11240   ; call sub_11240
0x00010ff4  mov      x19, x0
0x00010ff8  mov      x0, x23
0x00010ffc  bl       #0x2480c   ; call _objc_release
0x00011000  b        #0x11240   ; call sub_11240
0x00011004  mov      x19, x0
0x00011008  mov      x0, x23
0x0001100c  bl       #0x2480c   ; call _objc_release
0x00011010  b        #0x11240   ; call sub_11240
0x00011014  mov      x19, x0
0x00011018  mov      x0, x23
0x0001101c  bl       #0x2480c   ; call _objc_release
0x00011020  b        #0x11240   ; call sub_11240
0x00011024  mov      x19, x0
0x00011028  mov      x0, x23
0x0001102c  bl       #0x2480c   ; call _objc_release
0x00011030  b        #0x11248   ; call sub_11248
0x00011034  mov      x19, x0
0x00011038  mov      x0, x23
0x0001103c  bl       #0x2480c   ; call _objc_release
0x00011040  b        #0x11250   ; call sub_11250
0x00011044  mov      x19, x0
0x00011048  mov      x0, x23
0x0001104c  bl       #0x2480c   ; call _objc_release
0x00011050  b        #0x11250   ; call sub_11250
0x00011054  mov      x19, x0
0x00011058  mov      x0, x23
0x0001105c  bl       #0x2480c   ; call _objc_release
0x00011060  b        #0x11250   ; call sub_11250
0x00011064  mov      x19, x0
0x00011068  mov      x0, x23
0x0001106c  bl       #0x2480c   ; call _objc_release
0x00011070  b        #0x11250   ; call sub_11250
0x00011074  mov      x19, x0
0x00011078  mov      x0, x27
0x0001107c  bl       #0x2480c   ; call _objc_release
0x00011080  b        #0x111c8   ; call sub_111c8
0x00011084  mov      x19, x0
0x00011088  mov      x0, x23
0x0001108c  bl       #0x2480c   ; call _objc_release
0x00011090  b        #0x11250   ; call sub_11250
0x00011094  mov      x19, x0
0x00011098  mov      x0, x20
0x0001109c  bl       #0x2480c   ; call _objc_release
0x000110a0  b        #0x11250   ; call sub_11250
0x000110a4  mov      x19, x0
0x000110a8  mov      x0, x20
0x000110ac  bl       #0x2480c   ; call _objc_release
0x000110b0  b        #0x11250   ; call sub_11250
0x000110b4  b        #0x1125c   ; call sub_1125c
0x000110b8  mov      x19, x0
0x000110bc  mov      x0, x20
0x000110c0  bl       #0x2480c   ; call _objc_release
0x000110c4  b        #0x11270   ; call sub_11270
0x000110c8  b        #0x111dc   ; call sub_111dc
0x000110cc  mov      x19, x0
0x000110d0  mov      x0, x25
0x000110d4  bl       #0x2480c   ; call _objc_release
0x000110d8  b        #0x110e0   ; call sub_110e0
0x000110dc  mov      x19, x0
0x000110e0  mov      x0, x23
0x000110e4  bl       #0x2480c   ; call _objc_release
0x000110e8  b        #0x11278   ; call sub_11278
0x000110ec  mov      x19, x0
0x000110f0  b        #0x11278   ; call sub_11278
0x000110f4  mov      x19, x0
0x000110f8  mov      x0, x24
0x000110fc  bl       #0x2480c   ; call _objc_release
0x00011100  b        #0x11108   ; call sub_11108
0x00011104  mov      x19, x0
0x00011108  mov      x0, x23
0x0001110c  bl       #0x2480c   ; call _objc_release
0x00011110  b        #0x11280   ; call sub_11280
0x00011114  mov      x19, x0
0x00011118  b        #0x11280   ; call sub_11280
0x0001111c  mov      x19, x0
0x00011120  mov      x0, x24
0x00011124  bl       #0x2480c   ; call _objc_release
0x00011128  b        #0x11130   ; call sub_11130
0x0001112c  mov      x19, x0
0x00011130  mov      x0, x23
0x00011134  bl       #0x2480c   ; call _objc_release
0x00011138  b        #0x11288   ; call sub_11288
0x0001113c  mov      x19, x0
0x00011140  b        #0x11288   ; call sub_11288
0x00011144  mov      x19, x0
0x00011148  mov      x0, x23
0x0001114c  bl       #0x2480c   ; call _objc_release
0x00011150  b        #0x11158   ; call sub_11158
0x00011154  mov      x19, x0
0x00011158  mov      x0, x22
0x0001115c  bl       #0x2480c   ; call _objc_release
0x00011160  b        #0x11290   ; call sub_11290
0x00011164  mov      x19, x0
0x00011168  b        #0x11290   ; call sub_11290
0x0001116c  mov      x19, x0
0x00011170  mov      x0, x22
0x00011174  bl       #0x2480c   ; call _objc_release
0x00011178  b        #0x11180   ; call sub_11180
0x0001117c  mov      x19, x0
0x00011180  mov      x0, x21
0x00011184  bl       #0x2480c   ; call _objc_release
0x00011188  b        #0x11298   ; call sub_11298
0x0001118c  mov      x19, x0
0x00011190  b        #0x11298   ; call sub_11298
0x00011194  mov      x19, x0
0x00011198  mov      x0, x20
0x0001119c  bl       #0x2480c   ; call _objc_release
0x000111a0  b        #0x11240   ; call sub_11240
0x000111a4  mov      x19, x0
0x000111a8  mov      x0, x23
0x000111ac  bl       #0x2480c   ; call _objc_release
0x000111b0  b        #0x11240   ; call sub_11240
0x000111b4  b        #0x111b8   ; call sub_111b8
0x000111b8  mov      x19, x0
0x000111bc  b        #0x11248   ; call sub_11248
0x000111c0  b        #0x111e8   ; call sub_111e8
0x000111c4  mov      x19, x0
0x000111c8  mov      x0, x23
0x000111cc  bl       #0x2480c   ; call _objc_release
0x000111d0  b        #0x11250   ; call sub_11250
0x000111d4  mov      x19, x0
0x000111d8  b        #0x11268   ; call sub_11268
0x000111dc  mov      x19, x0
0x000111e0  b        #0x11270   ; call sub_11270
0x000111e4  b        #0x111f0   ; call sub_111f0
0x000111e8  mov      x19, x0
0x000111ec  b        #0x11250   ; call sub_11250
0x000111f0  mov      x19, x0
0x000111f4  b        #0x11240   ; call sub_11240
0x000111f8  b        #0x11234   ; call sub_11234
0x000111fc  b        #0x1125c   ; call sub_1125c
0x00011200  mov      x19, x0
0x00011204  mov      x0, x24
0x00011208  bl       #0x2480c   ; call _objc_release
0x0001120c  b        #0x11228   ; call sub_11228
0x00011210  b        #0x11234   ; call sub_11234
0x00011214  mov      x19, x0
0x00011218  mov      x0, x23
0x0001121c  bl       #0x2480c   ; call _objc_release
0x00011220  b        #0x11238   ; call sub_11238
0x00011224  mov      x19, x0
0x00011228  mov      x0, x23
0x0001122c  bl       #0x2480c   ; call _objc_release
0x00011230  b        #0x11238   ; call sub_11238
0x00011234  mov      x19, x0
0x00011238  mov      x0, x25
0x0001123c  bl       #0x2480c   ; call _objc_release
0x00011240  ldr      x0, [sp, #0x30]
0x00011244  bl       #0x2480c   ; call _objc_release
0x00011248  ldr      x0, [sp, #0x38]
0x0001124c  bl       #0x2480c   ; call _objc_release
0x00011250  mov      x0, x26
0x00011254  bl       #0x2480c   ; call _objc_release
0x00011258  b        #0x11268   ; call sub_11268
0x0001125c  mov      x19, x0
0x00011260  mov      x0, x25
0x00011264  bl       #0x2480c   ; call _objc_release
0x00011268  mov      x0, x25
0x0001126c  bl       #0x2480c   ; call _objc_release
0x00011270  ldr      x0, [sp, #0x18]
0x00011274  bl       #0x2480c   ; call _objc_release
0x00011278  ldr      x0, [sp, #0x10]
0x0001127c  bl       #0x2480c   ; call _objc_release
0x00011280  ldr      x0, [sp, #0x20]
0x00011284  bl       #0x2480c   ; call _objc_release
0x00011288  ldr      x0, [sp, #8]
0x0001128c  bl       #0x2480c   ; call _objc_release
0x00011290  ldr      x0, [sp]
0x00011294  bl       #0x2480c   ; call _objc_release
0x00011298  ldr      x0, [sp, #0x28]
0x0001129c  bl       #0x2480c   ; call _objc_release
0x000112a0  b        #0x112a8   ; call sub_112a8
0x000112a4  mov      x19, x0
0x000112a8  mov      x0, x19
0x000112ac  bl       #0x24470   ; call __Unwind_Resume
0x000112b0  sub      sp, sp, #0x70
0x000112b4  stp      x28, x27, [sp, #0x10]
0x000112b8  stp      x26, x25, [sp, #0x20]
0x000112bc  stp      x24, x23, [sp, #0x30]
0x000112c0  stp      x22, x21, [sp, #0x40]
0x000112c4  stp      x20, x19, [sp, #0x50]
0x000112c8  stp      x29, x30, [sp, #0x60]
0x000112cc  add      x29, sp, #0x60
0x000112d0  str      x4, [sp, #8]
0x000112d4  mov      x22, x3
0x000112d8  mov      x21, x2
0x000112dc  mov      x20, x1
0x000112e0  mov      x19, x0
0x000112e4  bl       #0x24818   ; call _objc_retain
0x000112e8  mov      x0, x20
0x000112ec  bl       #0x24818   ; call _objc_retain
0x000112f0  mov      x0, x21
0x000112f4  bl       #0x24818   ; call _objc_retain
0x000112f8  mov      x0, x22
0x000112fc  bl       #0x24818   ; call _objc_retain
0x00011300  adrp     x8, #0x3e000
0x00011304  ldr      x0, [x8, #0x390]   ; -> [class(ABBarButton)]
0x00011308  mov      x2, #0
0x0001130c  bl       #0x25080   ; objc_msgSend: buttonWithType:
0x00011310  mov      x29, x29
0x00011314  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011318  mov      x23, x0
0x0001131c  mov      x8, #0x4048000000000000
0x00011320  fmov     d2, x8
0x00011324  mov      x8, #0x4044000000000000
0x00011328  fmov     d3, x8
0x0001132c  fmov     d0, xzr
0x00011330  fmov     d1, xzr
0x00011334  bl       #0x26cc0   ; objc_msgSend: setBounds:
0x00011338  mov      x0, x23
0x0001133c  mov      x2, x21
0x00011340  bl       #0x27940   ; objc_msgSend: setTintColor:
0x00011344  adrp     x8, #0x3e000
0x00011348  ldr      x0, [x8, #0x2d0]   ; -> [class(UIView)]
0x0001134c  bl       #0x2471c   ; call _objc_alloc
0x00011350  mov      x8, #0x4044000000000000
0x00011354  fmov     d2, x8
0x00011358  fmov     d0, #4.00000000
0x0001135c  fmov     d1, xzr
0x00011360  mov      v3.16b, v2.16b
0x00011364  bl       #0x25a40   ; objc_msgSend: initWithFrame:
0x00011368  mov      x24, x0
0x0001136c  mov      w2, #0
0x00011370  bl       #0x279e0   ; objc_msgSend: setUserInteractionEnabled:
0x00011374  adrp     x25, #0x3e000
0x00011378  ldr      x0, [x25, #0x320]   ; -> [class(UIColor)]
0x0001137c  fmov     d0, #1.00000000
0x00011380  fmov     d1, #0.50000000
0x00011384  bl       #0x25240   ; objc_msgSend: colorWithWhite:alpha:
0x00011388  mov      x29, x29
0x0001138c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011390  mov      x26, x0
0x00011394  mov      x0, x24
0x00011398  mov      x2, x26
0x0001139c  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x000113a0  mov      x0, x26
0x000113a4  bl       #0x2480c   ; call _objc_release
0x000113a8  mov      x0, x24
0x000113ac  bl       #0x25f00   ; objc_msgSend: layer
0x000113b0  mov      x29, x29
0x000113b4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000113b8  mov      x26, x0
0x000113bc  fmov     d0, #20.00000000
0x000113c0  bl       #0x26e20   ; objc_msgSend: setCornerRadius:
0x000113c4  mov      x0, x26
0x000113c8  bl       #0x2480c   ; call _objc_release
0x000113cc  mov      x0, x24
0x000113d0  bl       #0x25f00   ; objc_msgSend: layer
0x000113d4  mov      x29, x29
0x000113d8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000113dc  mov      x26, x0
0x000113e0  fmov     d0, #1.00000000
0x000113e4  bl       #0x26ca0   ; objc_msgSend: setBorderWidth:
0x000113e8  mov      x0, x26
0x000113ec  bl       #0x2480c   ; call _objc_release
0x000113f0  ldr      x0, [x25, #0x320]   ; -> [class(UIColor)]
0x000113f4  adrp     x8, #0x2b000
0x000113f8  ldr      d1, [x8, #0x208]
0x000113fc  fmov     d0, #1.00000000
0x00011400  bl       #0x25240   ; objc_msgSend: colorWithWhite:alpha:
0x00011404  mov      x29, x29
0x00011408  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001140c  mov      x26, x0
0x00011410  bl       #0x24824   ; call _objc_retainAutorelease
0x00011414  bl       #0x249e0   ; objc_msgSend: CGColor
0x00011418  mov      x28, x0
0x0001141c  mov      x0, x24
0x00011420  bl       #0x25f00   ; objc_msgSend: layer
0x00011424  mov      x29, x29
0x00011428  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001142c  mov      x27, x0
0x00011430  mov      x2, x28
0x00011434  bl       #0x26c80   ; objc_msgSend: setBorderColor:
0x00011438  mov      x0, x27
0x0001143c  bl       #0x2480c   ; call _objc_release
0x00011440  mov      x0, x26
0x00011444  bl       #0x2480c   ; call _objc_release
0x00011448  ldr      x0, [x25, #0x320]   ; -> [class(UIColor)]
0x0001144c  adrp     x8, #0x2b000
0x00011450  ldr      d0, [x8, #0x240]
0x00011454  adrp     x8, #0x2b000
0x00011458  ldr      d1, [x8, #0x248]
0x0001145c  adrp     x8, #0x2b000
0x00011460  ldr      d2, [x8, #0x250]
0x00011464  fmov     d3, #1.00000000
0x00011468  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001146c  mov      x29, x29
0x00011470  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011474  mov      x26, x0
0x00011478  bl       #0x24824   ; call _objc_retainAutorelease
0x0001147c  bl       #0x249e0   ; objc_msgSend: CGColor
0x00011480  mov      x28, x0
0x00011484  mov      x0, x24
0x00011488  bl       #0x25f00   ; objc_msgSend: layer
0x0001148c  mov      x29, x29
0x00011490  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011494  mov      x27, x0
0x00011498  mov      x2, x28
0x0001149c  bl       #0x276e0   ; objc_msgSend: setShadowColor:
0x000114a0  mov      x0, x27
0x000114a4  bl       #0x2480c   ; call _objc_release
0x000114a8  mov      x0, x26
0x000114ac  bl       #0x2480c   ; call _objc_release
0x000114b0  mov      x0, x24
0x000114b4  bl       #0x25f00   ; objc_msgSend: layer
0x000114b8  mov      x29, x29
0x000114bc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000114c0  mov      x26, x0
0x000114c4  adrp     x8, #0x2b000
0x000114c8  ldr      s0, [x8, #0x38c]
0x000114cc  bl       #0x27720   ; objc_msgSend: setShadowOpacity:
0x000114d0  mov      x0, x26
0x000114d4  bl       #0x2480c   ; call _objc_release
0x000114d8  mov      x0, x24
0x000114dc  bl       #0x25f00   ; objc_msgSend: layer
0x000114e0  mov      x29, x29
0x000114e4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000114e8  mov      x26, x0
0x000114ec  fmov     d0, #3.00000000
0x000114f0  bl       #0x27760   ; objc_msgSend: setShadowRadius:
0x000114f4  mov      x0, x26
0x000114f8  bl       #0x2480c   ; call _objc_release
0x000114fc  mov      x0, x24
0x00011500  bl       #0x25f00   ; objc_msgSend: layer
0x00011504  mov      x29, x29
0x00011508  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001150c  mov      x26, x0
0x00011510  fmov     d0, xzr
0x00011514  fmov     d1, #2.00000000
0x00011518  bl       #0x27700   ; objc_msgSend: setShadowOffset:
0x0001151c  mov      x0, x26
0x00011520  bl       #0x2480c   ; call _objc_release
0x00011524  adrp     x8, #0x3e000
0x00011528  ldr      x0, [x8, #0x360]   ; -> [class(UIImageView)]
0x0001152c  bl       #0x2471c   ; call _objc_alloc
0x00011530  mov      x26, x0
0x00011534  mov      x0, x24
0x00011538  bl       #0x24f40   ; objc_msgSend: bounds
0x0001153c  fmov     d4, #6.00000000
0x00011540  fmov     d5, #6.00000000
0x00011544  bl       #0x243b0   ; call _CGRectInset
0x00011548  mov      x0, x26
0x0001154c  bl       #0x25a40   ; objc_msgSend: initWithFrame:
0x00011550  mov      x26, x0
0x00011554  mov      w2, #0x1c86
0x00011558  bl       #0x27880   ; objc_msgSend: setTag:
0x0001155c  mov      x0, x26
0x00011560  mov      w2, #4
0x00011564  bl       #0x26de0   ; objc_msgSend: setContentMode:
0x00011568  mov      x0, x24
0x0001156c  mov      x2, x26
0x00011570  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x00011574  mov      x0, x23
0x00011578  mov      x2, x24
0x0001157c  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x00011580  mov      x0, x23
0x00011584  mov      x1, x19
0x00011588  mov      x2, x20
0x0001158c  bl       #0x11cd8   ; call sub_11cd8
0x00011590  mov      x0, x23
0x00011594  mov      x2, x22
0x00011598  ldr      x3, [sp, #8]
0x0001159c  mov      w4, #0x40
0x000115a0  bl       #0x24bc0   ; objc_msgSend: addTarget:action:forControlEvents:
0x000115a4  mov      x0, x26
0x000115a8  bl       #0x2480c   ; call _objc_release
0x000115ac  mov      x0, x24
0x000115b0  bl       #0x2480c   ; call _objc_release
0x000115b4  mov      x0, x22
0x000115b8  bl       #0x2480c   ; call _objc_release
0x000115bc  mov      x0, x21
0x000115c0  bl       #0x2480c   ; call _objc_release
0x000115c4  mov      x0, x20
0x000115c8  bl       #0x2480c   ; call _objc_release
0x000115cc  mov      x0, x19
0x000115d0  bl       #0x2480c   ; call _objc_release
0x000115d4  mov      x0, x23
0x000115d8  ldp      x29, x30, [sp, #0x60]
0x000115dc  ldp      x20, x19, [sp, #0x50]
0x000115e0  ldp      x22, x21, [sp, #0x40]
0x000115e4  ldp      x24, x23, [sp, #0x30]
0x000115e8  ldp      x26, x25, [sp, #0x20]
0x000115ec  ldp      x28, x27, [sp, #0x10]
0x000115f0  add      sp, sp, #0x70
0x000115f4  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x000115f8  b        #0x11644   ; call sub_11644
0x000115fc  b        #0x11644   ; call sub_11644
0x00011600  b        #0x11644   ; call sub_11644
0x00011604  b        #0x11608   ; call sub_11608
0x00011608  mov      x25, x0
0x0001160c  mov      x0, x27
0x00011610  bl       #0x2480c   ; call _objc_release
0x00011614  b        #0x11648   ; call sub_11648
0x00011618  b        #0x11644   ; call sub_11644
0x0001161c  b        #0x11644   ; call sub_11644
0x00011620  b        #0x11644   ; call sub_11644
0x00011624  mov      x25, x0
0x00011628  b        #0x11668   ; call sub_11668
0x0001162c  b        #0x11644   ; call sub_11644
0x00011630  b        #0x11644   ; call sub_11644
0x00011634  b        #0x11638   ; call sub_11638
0x00011638  mov      x25, x0
0x0001163c  b        #0x11660   ; call sub_11660
0x00011640  b        #0x11654   ; call sub_11654
0x00011644  mov      x25, x0
0x00011648  mov      x0, x26
0x0001164c  bl       #0x2480c   ; call _objc_release
0x00011650  b        #0x11658   ; call sub_11658
0x00011654  mov      x25, x0
0x00011658  mov      x0, x24
0x0001165c  bl       #0x2480c   ; call _objc_release
0x00011660  mov      x0, x23
0x00011664  bl       #0x2480c   ; call _objc_release
0x00011668  mov      x0, x22
0x0001166c  bl       #0x2480c   ; call _objc_release
0x00011670  mov      x0, x21
0x00011674  bl       #0x2480c   ; call _objc_release
0x00011678  mov      x0, x20
0x0001167c  bl       #0x2480c   ; call _objc_release
0x00011680  mov      x0, x19
0x00011684  bl       #0x2480c   ; call _objc_release
0x00011688  mov      x0, x25
0x0001168c  bl       #0x24470   ; call __Unwind_Resume
0x00011690  sub      sp, sp, #0xb0
0x00011694  stp      d11, d10, [sp, #0x60]
0x00011698  stp      d9, d8, [sp, #0x70]
0x0001169c  stp      x22, x21, [sp, #0x80]
0x000116a0  stp      x20, x19, [sp, #0x90]
0x000116a4  stp      x29, x30, [sp, #0xa0]
0x000116a8  add      x29, sp, #0xa0
0x000116ac  mov      x19, x2
0x000116b0  mov      x0, x2
0x000116b4  bl       #0x24818   ; call _objc_retain
0x000116b8  mov      x0, x19
0x000116bc  bl       #0x24e60   ; objc_msgSend: bar
0x000116c0  mov      x29, x29
0x000116c4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000116c8  mov      x20, x0
0x000116cc  cbz      x0, #0x117e4
0x000116d0  mov      x0, x19
0x000116d4  bl       #0x24f60   ; objc_msgSend: box
0x000116d8  mov      x29, x29
0x000116dc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000116e0  mov      x22, x0
0x000116e4  bl       #0x24f40   ; objc_msgSend: bounds
0x000116e8  mov      v8.16b, v2.16b
0x000116ec  mov      x0, x22
0x000116f0  bl       #0x2480c   ; call _objc_release
0x000116f4  mov      x0, x20
0x000116f8  bl       #0x24f40   ; objc_msgSend: bounds
0x000116fc  fmov     d0, #-10.00000000
0x00011700  fadd     d0, d8, d0
0x00011704  fcmp     d2, d0
0x00011708  mov      x8, #0x4044000000000000
0x0001170c  fmov     d1, x8
0x00011710  fccmp    d0, d1, #4, gt
0x00011714  fdiv     d0, d0, d2
0x00011718  fmov     d10, #1.00000000
0x0001171c  fcsel    d9, d0, d10, gt
0x00011720  add      x8, sp, #0x30
0x00011724  mov      v0.16b, v9.16b
0x00011728  mov      v1.16b, v9.16b
0x0001172c  bl       #0x242e4   ; call _CGAffineTransformMakeScale
0x00011730  ldp      q0, q1, [sp, #0x30]
0x00011734  stp      q0, q1, [sp]
0x00011738  ldr      q0, [sp, #0x50]
0x0001173c  str      q0, [sp, #0x20]
0x00011740  mov      x2, sp
0x00011744  mov      x0, x20
0x00011748  bl       #0x279a0   ; objc_msgSend: setTransform:
0x0001174c  fmov     d1, #0.50000000
0x00011750  fmul     d0, d8, d1
0x00011754  fsub     d2, d10, d9
0x00011758  mov      x8, #-0x3fb6000000000000
0x0001175c  fmov     d3, x8
0x00011760  fmul     d2, d2, d3
0x00011764  fmul     d1, d2, d1
0x00011768  mov      x8, #0x4049000000000000
0x0001176c  fmov     d2, x8
0x00011770  fadd     d1, d1, d2
0x00011774  mov      x0, x20
0x00011778  bl       #0x26d60   ; objc_msgSend: setCenter:
0x0001177c  mov      x0, x19
0x00011780  bl       #0x24f60   ; objc_msgSend: box
0x00011784  mov      x29, x29
0x00011788  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001178c  mov      x22, x0
0x00011790  mov      x2, x20
0x00011794  bl       #0x24f80   ; objc_msgSend: bringSubviewToFront:
0x00011798  mov      x0, x22
0x0001179c  bl       #0x2480c   ; call _objc_release
0x000117a0  mov      x0, x19
0x000117a4  bl       #0x24f60   ; objc_msgSend: box
0x000117a8  mov      x29, x29
0x000117ac  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000117b0  mov      x22, x0
0x000117b4  mov      x0, x19
0x000117b8  bl       #0x25860   ; objc_msgSend: handleHit
0x000117bc  mov      x29, x29
0x000117c0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000117c4  mov      x21, x0
0x000117c8  mov      x0, x22
0x000117cc  mov      x2, x21
0x000117d0  bl       #0x24f80   ; objc_msgSend: bringSubviewToFront:
0x000117d4  mov      x0, x21
0x000117d8  bl       #0x2480c   ; call _objc_release
0x000117dc  mov      x0, x22
0x000117e0  bl       #0x2480c   ; call _objc_release
0x000117e4  mov      x0, x20
0x000117e8  bl       #0x2480c   ; call _objc_release
0x000117ec  mov      x0, x19
0x000117f0  bl       #0x2480c   ; call _objc_release
0x000117f4  ldp      x29, x30, [sp, #0xa0]
0x000117f8  ldp      x20, x19, [sp, #0x90]
0x000117fc  ldp      x22, x21, [sp, #0x80]
0x00011800  ldp      d9, d8, [sp, #0x70]
0x00011804  ldp      d11, d10, [sp, #0x60]
0x00011808  add      sp, sp, #0xb0
0x0001180c  ret      
0x00011810  mov      x1, x21
0x00011814  mov      x21, x0
0x00011818  mov      x0, x1
0x0001181c  bl       #0x2480c   ; call _objc_release
0x00011820  b        #0x11834   ; call sub_11834
0x00011824  b        #0x11830   ; call sub_11830
0x00011828  b        #0x11830   ; call sub_11830
0x0001182c  b        #0x1184c   ; call sub_1184c
0x00011830  mov      x21, x0
0x00011834  mov      x0, x22
0x00011838  bl       #0x2480c   ; call _objc_release
0x0001183c  b        #0x11850   ; call sub_11850
0x00011840  b        #0x1184c   ; call sub_1184c
0x00011844  mov      x21, x0
0x00011848  b        #0x11858   ; call sub_11858
0x0001184c  mov      x21, x0
0x00011850  mov      x0, x20
0x00011854  bl       #0x2480c   ; call _objc_release
0x00011858  mov      x0, x19
0x0001185c  bl       #0x2480c   ; call _objc_release
0x00011860  mov      x0, x21
0x00011864  bl       #0x24470   ; call __Unwind_Resume
0x00011868  sub      sp, sp, #0x190
0x0001186c  stp      x28, x27, [sp, #0x130]
0x00011870  stp      x26, x25, [sp, #0x140]
0x00011874  stp      x24, x23, [sp, #0x150]
0x00011878  stp      x22, x21, [sp, #0x160]
0x0001187c  stp      x20, x19, [sp, #0x170]
0x00011880  stp      x29, x30, [sp, #0x180]
0x00011884  add      x29, sp, #0x180
0x00011888  mov      x19, x6
0x0001188c  mov      x24, x5
0x00011890  mov      x25, x4
0x00011894  mov      x26, x3
0x00011898  mov      x23, x2
0x0001189c  mov      x22, x0
0x000118a0  mov      x0, x6
0x000118a4  bl       #0x24818   ; call _objc_retain
0x000118a8  mov      x0, x22
0x000118ac  mov      x2, x19
0x000118b0  bl       #0x26520   ; objc_msgSend: paneFor:
0x000118b4  mov      x29, x29
0x000118b8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000118bc  mov      x20, x0
0x000118c0  cbz      x0, #0x11c04
0x000118c4  mov      x0, x20
0x000118c8  bl       #0x24e60   ; objc_msgSend: bar
0x000118cc  mov      x29, x29
0x000118d0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000118d4  mov      x21, x0
0x000118d8  bl       #0x2480c   ; call _objc_release
0x000118dc  tbnz     w23, #0, #0x118e4
0x000118e0  cbz      x21, #0x11c04
0x000118e4  mov      x0, x20
0x000118e8  bl       #0x24e60   ; objc_msgSend: bar
0x000118ec  mov      x29, x29
0x000118f0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000118f4  mov      x21, x0
0x000118f8  cbz      x0, #0x1190c
0x000118fc  mov      x0, x21
0x00011900  bl       #0x24818   ; call _objc_retain
0x00011904  str      x21, [sp]
0x00011908  b        #0x11924   ; call sub_11924
0x0001190c  mov      x0, x22
0x00011910  mov      x2, x20
0x00011914  bl       #0x24fc0   ; objc_msgSend: buildBarForPane:
0x00011918  mov      x29, x29
0x0001191c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011920  str      x0, [sp]
0x00011924  mov      x0, x21
0x00011928  bl       #0x2480c   ; call _objc_release
0x0001192c  mov      x0, x20
0x00011930  bl       #0x265c0   ; objc_msgSend: popButton
0x00011934  mov      x29, x29
0x00011938  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001193c  mov      x27, x0
0x00011940  adrp     x8, #0x36000
0x00011944  add      x8, x8, #0x370   ; -> @"hm_float"
0x00011948  adrp     x9, #0x36000
0x0001194c  add      x9, x9, #0x490   ; -> @"hm_split"
0x00011950  cmp      w26, #2
0x00011954  csel     x28, x9, x8, eq
0x00011958  b.ne     #0x1197c
0x0001195c  adrp     x0, #0x36000
0x00011960  add      x0, x0, #0x4b0   ; -> @"C"
0x00011964  adrp     x1, #0x36000
0x00011968  add      x1, x1, #0x4d0   ; -> @"Split"
0x0001196c  bl       #0x23a38   ; call _OMCTr
0x00011970  mov      x29, x29
0x00011974  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011978  b        #0x11998   ; call sub_11998
0x0001197c  adrp     x0, #0x36000
0x00011980  add      x0, x0, #0x390   ; -> @"C"
0x00011984  adrp     x1, #0x36000
0x00011988  add      x1, x1, #0x3b0   ; -> @"Float"
0x0001198c  bl       #0x23a38   ; call _OMCTr
0x00011990  mov      x29, x29
0x00011994  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00011998  mov      x21, x0
0x0001199c  mov      x0, x27
0x000119a0  mov      x1, x28
0x000119a4  mov      x2, x21
0x000119a8  bl       #0x11cd8   ; call sub_11cd8
0x000119ac  cmp      w26, #2
