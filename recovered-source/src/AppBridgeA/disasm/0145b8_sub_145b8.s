; ==== sub_145b8 @ 0x145b8..0x152b0 (3320 bytes) ====
0x000145b8  ldr      x0, [x8, #0x2a8]
0x000145bc  add      x2, sp, #0x150
0x000145c0  mov      w3, #2
0x000145c4  bl       #0x24e20   ; objc_msgSend: arrayWithObjects:count:
0x000145c8  mov      x29, x29
0x000145cc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000145d0  mov      x19, x0
0x000145d4  mov      x0, x23
0x000145d8  mov      x2, x19
0x000145dc  bl       #0x26da0   ; objc_msgSend: setColors:
0x000145e0  mov      x0, x19
0x000145e4  bl       #0x2480c   ; call _objc_release
0x000145e8  mov      x0, x20
0x000145ec  bl       #0x2480c   ; call _objc_release
0x000145f0  mov      x0, x21
0x000145f4  bl       #0x2480c   ; call _objc_release
0x000145f8  adrp     x8, #0x34000
0x000145fc  ldr      x8, [x8, #0x508]   ; -> [got:_CGPointZero]
0x00014600  ldp      d0, d1, [x8]
0x00014604  mov      x22, x28
0x00014608  mov      x20, x23
0x0001460c  mov      x0, x23
0x00014610  ldr      x19, [sp, #0x78]
0x00014614  bl       #0x27840   ; objc_msgSend: setStartPoint:
0x00014618  fmov     d0, #1.00000000
0x0001461c  fmov     d1, #1.00000000
0x00014620  mov      x22, x28
0x00014624  mov      x20, x23
0x00014628  mov      x0, x23
0x0001462c  bl       #0x26ee0   ; objc_msgSend: setEndPoint:
0x00014630  mov      x22, x28
0x00014634  mov      x20, x23
0x00014638  mov      x0, x19
0x0001463c  bl       #0x24f40   ; objc_msgSend: bounds
0x00014640  mov      x22, x28
0x00014644  mov      x20, x23
0x00014648  mov      x0, x23
0x0001464c  bl       #0x26f80   ; objc_msgSend: setFrame:
0x00014650  mov      x0, x19
0x00014654  bl       #0x24f40   ; objc_msgSend: bounds
0x00014658  fmov     d0, #0.50000000
0x0001465c  fmul     d0, d2, d0
0x00014660  mov      x0, x23
0x00014664  bl       #0x26e20   ; objc_msgSend: setCornerRadius:
0x00014668  fmov     s0, wzr
0x0001466c  mov      x22, x28
0x00014670  mov      x20, x23
0x00014674  mov      x0, x23
0x00014678  bl       #0x27420   ; objc_msgSend: setOpacity:
0x0001467c  cbz      x28, #0x146ac
0x00014680  mov      x22, x28
0x00014684  mov      x20, x23
0x00014688  mov      x0, x19
0x0001468c  bl       #0x25f00   ; objc_msgSend: layer
0x00014690  mov      x29, x29
0x00014694  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014698  mov      x21, x0
0x0001469c  mov      x2, x23
0x000146a0  mov      x3, x28
0x000146a4  bl       #0x25b40   ; objc_msgSend: insertSublayer:below:
0x000146a8  b        #0x146d0   ; call sub_146d0
0x000146ac  mov      x22, #0
0x000146b0  mov      x20, x23
0x000146b4  mov      x0, x19
0x000146b8  bl       #0x25f00   ; objc_msgSend: layer
0x000146bc  mov      x29, x29
0x000146c0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000146c4  mov      x21, x0
0x000146c8  mov      x2, x23
0x000146cc  bl       #0x24b80   ; objc_msgSend: addSublayer:
0x000146d0  mov      x0, x21
0x000146d4  bl       #0x2480c   ; call _objc_release
0x000146d8  ldr      w22, [sp, #0x6c]
0x000146dc  adrp     x8, #0x3e000
0x000146e0  ldr      x19, [x8, #0x2d0]   ; -> [class(UIView)]
0x000146e4  cmp      w22, #0
0x000146e8  adrp     x8, #0x2b000
0x000146ec  ldr      d0, [x8, #0x1f0]
0x000146f0  adrp     x8, #0x2b000
0x000146f4  ldr      d1, [x8, #0x2f0]
0x000146f8  fcsel    d13, d1, d0, ne
0x000146fc  adrp     x20, #0x34000
0x00014700  ldr      x20, [x20, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x00014704  str      x20, [sp, #0xd0]
0x00014708  adrp     x8, #0x2b000
0x0001470c  ldr      d14, [x8, #0x1d0]
0x00014710  str      d14, [sp, #0xd8]
0x00014714  adrp     x8, #0x17000
0x00014718  add      x9, x8, #0x1e4
0x0001471c  adrp     x8, #0x34000
0x00014720  add      x8, x8, #0xa90
0x00014724  stp      x9, x8, [sp, #0xe0]
0x00014728  ldr      x21, [sp, #0x78]
0x0001472c  mov      x0, x21
0x00014730  bl       #0x24818   ; call _objc_retain
0x00014734  str      x21, [sp, #0xf0]
0x00014738  strb     w22, [sp, #0x108]
0x0001473c  mov      x0, x23
0x00014740  bl       #0x24818   ; call _objc_retain
0x00014744  stp      x23, x28, [sp, #0xf8]
0x00014748  str      x20, [sp, #0xa0]
0x0001474c  str      d14, [sp, #0xa8]
0x00014750  adrp     x8, #0x17000
0x00014754  add      x9, x8, #0x4f4
0x00014758  adrp     x8, #0x34000
0x0001475c  add      x8, x8, #0xac0
0x00014760  stp      x9, x8, [sp, #0xb0]
0x00014764  strb     w22, [sp, #0xc8]
0x00014768  str      x23, [sp, #0xc0]
0x0001476c  mov      x0, x23
0x00014770  bl       #0x24818   ; call _objc_retain
0x00014774  mov      x0, x28
0x00014778  bl       #0x24818   ; call _objc_retain
0x0001477c  adrp     x8, #0x2b000
0x00014780  ldr      d2, [x8, #0x200]
0x00014784  fmov     d1, xzr
0x00014788  fmov     d3, xzr
0x0001478c  add      x3, sp, #0xd0
0x00014790  add      x4, sp, #0xa0
0x00014794  mov      x0, x19
0x00014798  mov      v0.16b, v13.16b
0x0001479c  mov      w2, #4
0x000147a0  bl       #0x24ca0   ; objc_msgSend: animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:
0x000147a4  ldr      x0, [sp, #0xc0]
0x000147a8  bl       #0x2480c   ; call _objc_release
0x000147ac  ldr      x0, [sp, #0x100]
0x000147b0  bl       #0x2480c   ; call _objc_release
0x000147b4  ldr      x0, [sp, #0xf8]
0x000147b8  bl       #0x2480c   ; call _objc_release
0x000147bc  ldr      x0, [sp, #0xf0]
0x000147c0  bl       #0x2480c   ; call _objc_release
0x000147c4  mov      x0, x23
0x000147c8  bl       #0x2480c   ; call _objc_release
0x000147cc  mov      x0, x28
0x000147d0  bl       #0x2480c   ; call _objc_release
0x000147d4  ldr      x0, [sp, #0x78]
0x000147d8  bl       #0x2480c   ; call _objc_release
0x000147dc  ldr      x0, [sp, #0x78]
0x000147e0  bl       #0x2480c   ; call _objc_release
0x000147e4  ldr      x0, [sp, #0x80]
0x000147e8  bl       #0x2480c   ; call _objc_release
0x000147ec  ldr      x19, [sp, #0x90]
0x000147f0  mov      x0, x19
0x000147f4  bl       #0x2480c   ; call _objc_release
0x000147f8  ldr      x24, [sp, #0x98]
0x000147fc  add      x24, x24, #1
0x00014800  ldr      x22, [sp, #0x70]
0x00014804  ldr      x23, [sp, #0x88]
0x00014808  b        #0x13cf8   ; call sub_13cf8
0x0001480c  mov      x0, x22
0x00014810  bl       #0x2480c   ; call _objc_release
0x00014814  ldur     x8, [x29, #-0xa0]
0x00014818  adrp     x9, #0x34000
0x0001481c  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00014820  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x00014824  cmp      x9, x8
0x00014828  b.ne     #0x1485c
0x0001482c  add      sp, sp, #0x1f0
0x00014830  ldp      x29, x30, [sp, #0x90]
0x00014834  ldp      x20, x19, [sp, #0x80]
0x00014838  ldp      x22, x21, [sp, #0x70]
0x0001483c  ldp      x24, x23, [sp, #0x60]
0x00014840  ldp      x26, x25, [sp, #0x50]
0x00014844  ldp      x28, x27, [sp, #0x40]
0x00014848  ldp      d9, d8, [sp, #0x30]
0x0001484c  ldp      d11, d10, [sp, #0x20]
0x00014850  ldp      d13, d12, [sp, #0x10]
0x00014854  ldp      d15, d14, [sp], #0xa0
0x00014858  ret      
0x0001485c  bl       #0x24488   ; call ___stack_chk_fail
0x00014860  b        #0x14b58   ; call sub_14b58
0x00014864  mov      x24, x0
0x00014868  mov      x0, x21
0x0001486c  bl       #0x2480c   ; call _objc_release
0x00014870  mov      x0, x23
0x00014874  bl       #0x2480c   ; call _objc_release
0x00014878  b        #0x14c3c   ; call sub_14c3c
0x0001487c  mov      x24, x0
0x00014880  mov      x0, x21
0x00014884  bl       #0x2480c   ; call _objc_release
0x00014888  mov      x0, x23
0x0001488c  bl       #0x2480c   ; call _objc_release
0x00014890  mov      x0, x28
0x00014894  bl       #0x2480c   ; call _objc_release
0x00014898  b        #0x14c3c   ; call sub_14c3c
0x0001489c  mov      x24, x0
0x000148a0  mov      x0, x19
0x000148a4  bl       #0x2480c   ; call _objc_release
0x000148a8  b        #0x149e8   ; call sub_149e8
0x000148ac  mov      x24, x0
0x000148b0  mov      x0, x21
0x000148b4  bl       #0x2480c   ; call _objc_release
0x000148b8  b        #0x14b14   ; call sub_14b14
0x000148bc  mov      x24, x0
0x000148c0  b        #0x14ac8   ; call sub_14ac8
0x000148c4  mov      x24, x0
0x000148c8  mov      x0, x19
0x000148cc  bl       #0x2480c   ; call _objc_release
0x000148d0  b        #0x14c4c   ; call sub_14c4c
0x000148d4  mov      x24, x0
0x000148d8  mov      x0, x20
0x000148dc  bl       #0x2480c   ; call _objc_release
0x000148e0  b        #0x14bcc   ; call sub_14bcc
0x000148e4  mov      x24, x0
0x000148e8  mov      x0, x21
0x000148ec  bl       #0x2480c   ; call _objc_release
0x000148f0  b        #0x14adc   ; call sub_14adc
0x000148f4  b        #0x14b84   ; call sub_14b84
0x000148f8  mov      x24, x0
0x000148fc  mov      x0, x19
0x00014900  bl       #0x2480c   ; call _objc_release
0x00014904  mov      x22, x27
0x00014908  b        #0x14c50   ; call sub_14c50
0x0001490c  b        #0x14bc8   ; call sub_14bc8
0x00014910  mov      x24, x0
0x00014914  mov      x0, x21
0x00014918  bl       #0x2480c   ; call _objc_release
0x0001491c  b        #0x14aec   ; call sub_14aec
0x00014920  mov      x24, x0
0x00014924  mov      x0, x19
0x00014928  bl       #0x2480c   ; call _objc_release
0x0001492c  b        #0x14bdc   ; call sub_14bdc
0x00014930  mov      x24, x0
0x00014934  mov      x0, x19
0x00014938  bl       #0x2480c   ; call _objc_release
0x0001493c  b        #0x14bcc   ; call sub_14bcc
0x00014940  mov      x24, x0
0x00014944  mov      x0, x20
0x00014948  bl       #0x2480c   ; call _objc_release
0x0001494c  b        #0x14bcc   ; call sub_14bcc
0x00014950  mov      x24, x0
0x00014954  mov      x0, x20
0x00014958  bl       #0x2480c   ; call _objc_release
0x0001495c  b        #0x14bd4   ; call sub_14bd4
0x00014960  mov      x24, x0
0x00014964  mov      x0, x19
0x00014968  bl       #0x2480c   ; call _objc_release
0x0001496c  b        #0x149c4   ; call sub_149c4
0x00014970  mov      x24, x0
0x00014974  mov      x0, x19
0x00014978  bl       #0x2480c   ; call _objc_release
0x0001497c  b        #0x14bd4   ; call sub_14bd4
0x00014980  mov      x24, x0
0x00014984  mov      x0, x20
0x00014988  bl       #0x2480c   ; call _objc_release
0x0001498c  b        #0x14bd4   ; call sub_14bd4
0x00014990  mov      x24, x0
0x00014994  mov      x0, x20
0x00014998  bl       #0x2480c   ; call _objc_release
0x0001499c  b        #0x14bcc   ; call sub_14bcc
0x000149a0  mov      x24, x0
0x000149a4  mov      x0, x19
0x000149a8  bl       #0x2480c   ; call _objc_release
0x000149ac  b        #0x14b88   ; call sub_14b88
0x000149b0  mov      x24, x0
0x000149b4  mov      x0, x19
0x000149b8  bl       #0x2480c   ; call _objc_release
0x000149bc  b        #0x14bdc   ; call sub_14bdc
0x000149c0  mov      x24, x0
0x000149c4  mov      x0, x20
0x000149c8  bl       #0x2480c   ; call _objc_release
0x000149cc  b        #0x14bcc   ; call sub_14bcc
0x000149d0  mov      x24, x0
0x000149d4  mov      x0, x20
0x000149d8  bl       #0x2480c   ; call _objc_release
0x000149dc  b        #0x14bcc   ; call sub_14bcc
0x000149e0  b        #0x14bf4   ; call sub_14bf4
0x000149e4  mov      x24, x0
0x000149e8  mov      x0, x20
0x000149ec  bl       #0x2480c   ; call _objc_release
0x000149f0  b        #0x14a48   ; call sub_14a48
0x000149f4  mov      x24, x0
0x000149f8  mov      x0, x23
0x000149fc  bl       #0x2480c   ; call _objc_release
0x00014a00  mov      x0, x28
0x00014a04  bl       #0x2480c   ; call _objc_release
0x00014a08  b        #0x14c3c   ; call sub_14c3c
0x00014a0c  mov      x24, x0
0x00014a10  ldr      x0, [sp, #0xc0]
0x00014a14  bl       #0x2480c   ; call _objc_release
0x00014a18  ldr      x0, [sp, #0x100]
0x00014a1c  bl       #0x2480c   ; call _objc_release
0x00014a20  ldr      x0, [sp, #0xf8]
0x00014a24  bl       #0x2480c   ; call _objc_release
0x00014a28  ldr      x0, [sp, #0xf0]
0x00014a2c  bl       #0x2480c   ; call _objc_release
0x00014a30  mov      x0, x23
0x00014a34  bl       #0x2480c   ; call _objc_release
0x00014a38  mov      x0, x28
0x00014a3c  bl       #0x2480c   ; call _objc_release
0x00014a40  b        #0x14c3c   ; call sub_14c3c
0x00014a44  mov      x24, x0
0x00014a48  mov      x0, x21
0x00014a4c  bl       #0x2480c   ; call _objc_release
0x00014a50  mov      x0, x23
0x00014a54  bl       #0x2480c   ; call _objc_release
0x00014a58  mov      x0, x28
0x00014a5c  bl       #0x2480c   ; call _objc_release
0x00014a60  b        #0x14c3c   ; call sub_14c3c
0x00014a64  mov      x24, x0
0x00014a68  mov      x0, x19
0x00014a6c  bl       #0x2480c   ; call _objc_release
0x00014a70  b        #0x14c4c   ; call sub_14c4c
0x00014a74  mov      x24, x0
0x00014a78  mov      x0, x19
0x00014a7c  bl       #0x2480c   ; call _objc_release
0x00014a80  b        #0x14c3c   ; call sub_14c3c
0x00014a84  mov      x24, x0
0x00014a88  mov      x0, x20
0x00014a8c  bl       #0x2480c   ; call _objc_release
0x00014a90  b        #0x14c4c   ; call sub_14c4c
0x00014a94  mov      x24, x0
0x00014a98  b        #0x14c3c   ; call sub_14c3c
0x00014a9c  mov      x24, x0
0x00014aa0  mov      x0, x19
0x00014aa4  bl       #0x2480c   ; call _objc_release
0x00014aa8  b        #0x14c4c   ; call sub_14c4c
0x00014aac  mov      x24, x0
0x00014ab0  mov      x23, #0
0x00014ab4  mov      x28, #0
0x00014ab8  b        #0x14c24   ; call sub_14c24
0x00014abc  mov      x24, x0
0x00014ac0  cmp      x20, #4
0x00014ac4  b.lo     #0x14c4c
0x00014ac8  ldr      x0, [sp, #0x60]
0x00014acc  bl       #0x2480c   ; call _objc_release
0x00014ad0  b        #0x14c4c   ; call sub_14c4c
0x00014ad4  b        #0x14bec   ; call sub_14bec
0x00014ad8  mov      x24, x0
0x00014adc  mov      x0, x20
0x00014ae0  bl       #0x2480c   ; call _objc_release
0x00014ae4  b        #0x14bcc   ; call sub_14bcc
0x00014ae8  mov      x24, x0
0x00014aec  mov      x0, x20
0x00014af0  bl       #0x2480c   ; call _objc_release
0x00014af4  b        #0x14bcc   ; call sub_14bcc
0x00014af8  mov      x24, x0
0x00014afc  mov      x0, x20
0x00014b00  bl       #0x2480c   ; call _objc_release
0x00014b04  b        #0x14b88   ; call sub_14b88
0x00014b08  b        #0x14b48   ; call sub_14b48
0x00014b0c  b        #0x14b40   ; call sub_14b40
0x00014b10  mov      x24, x0
0x00014b14  mov      x0, x20
0x00014b18  bl       #0x2480c   ; call _objc_release
0x00014b1c  b        #0x14c58   ; call sub_14c58
0x00014b20  mov      x24, x0
0x00014b24  mov      x0, x21
0x00014b28  bl       #0x2480c   ; call _objc_release
0x00014b2c  b        #0x14b34   ; call sub_14b34
0x00014b30  mov      x24, x0
0x00014b34  mov      x0, x20
0x00014b38  bl       #0x2480c   ; call _objc_release
0x00014b3c  b        #0x14c4c   ; call sub_14c4c
0x00014b40  mov      x24, x0
0x00014b44  b        #0x14bd4   ; call sub_14bd4
0x00014b48  mov      x24, x0
0x00014b4c  b        #0x14bdc   ; call sub_14bdc
0x00014b50  b        #0x14bb0   ; call sub_14bb0
0x00014b54  b        #0x14bf4   ; call sub_14bf4
0x00014b58  mov      x24, x0
0x00014b5c  mov      x0, x19
0x00014b60  b        #0x14bc0   ; call sub_14bc0
0x00014b64  mov      x24, x0
0x00014b68  mov      x0, x19
0x00014b6c  bl       #0x2480c   ; call _objc_release
0x00014b70  b        #0x14b78   ; call sub_14b78
0x00014b74  mov      x24, x0
0x00014b78  mov      x0, x20
0x00014b7c  bl       #0x2480c   ; call _objc_release
0x00014b80  b        #0x14c60   ; call sub_14c60
0x00014b84  mov      x24, x0
0x00014b88  mov      x0, x21
0x00014b8c  bl       #0x2480c   ; call _objc_release
0x00014b90  b        #0x14bcc   ; call sub_14bcc
0x00014b94  b        #0x14bf4   ; call sub_14bf4
0x00014b98  mov      x24, x0
0x00014b9c  mov      x0, x20
0x00014ba0  bl       #0x2480c   ; call _objc_release
0x00014ba4  mov      x0, x22
0x00014ba8  bl       #0x2480c   ; call _objc_release
0x00014bac  b        #0x14c3c   ; call sub_14c3c
0x00014bb0  mov      x24, x0
0x00014bb4  b        #0x14c50   ; call sub_14c50
0x00014bb8  mov      x24, x0
0x00014bbc  mov      x0, x20
0x00014bc0  bl       #0x2480c   ; call _objc_release
0x00014bc4  b        #0x14c64   ; call sub_14c64
0x00014bc8  mov      x24, x0
0x00014bcc  mov      x0, x28
0x00014bd0  bl       #0x2480c   ; call _objc_release
0x00014bd4  mov      x0, x26
0x00014bd8  bl       #0x2480c   ; call _objc_release
0x00014bdc  mov      x0, x27
0x00014be0  bl       #0x2480c   ; call _objc_release
0x00014be4  mov      x22, #0
0x00014be8  b        #0x14c50   ; call sub_14c50
0x00014bec  mov      x24, x0
0x00014bf0  b        #0x14c58   ; call sub_14c58
0x00014bf4  mov      x24, x0
0x00014bf8  b        #0x14c64   ; call sub_14c64
0x00014bfc  b        #0x14c20   ; call sub_14c20
0x00014c00  mov      x24, x0
0x00014c04  mov      x0, x19
0x00014c08  bl       #0x2480c   ; call _objc_release
0x00014c0c  b        #0x14c24   ; call sub_14c24
0x00014c10  mov      x24, x0
0x00014c14  mov      x0, x19
0x00014c18  bl       #0x2480c   ; call _objc_release
0x00014c1c  b        #0x14c24   ; call sub_14c24
0x00014c20  mov      x24, x0
0x00014c24  mov      x0, x21
0x00014c28  bl       #0x2480c   ; call _objc_release
0x00014c2c  mov      x0, x23
0x00014c30  bl       #0x2480c   ; call _objc_release
0x00014c34  mov      x0, x28
0x00014c38  bl       #0x2480c   ; call _objc_release
0x00014c3c  ldr      x0, [sp, #0x78]
0x00014c40  bl       #0x2480c   ; call _objc_release
0x00014c44  ldr      x0, [sp, #0x78]
0x00014c48  bl       #0x2480c   ; call _objc_release
0x00014c4c  ldr      x22, [sp, #0x80]
0x00014c50  mov      x0, x22
0x00014c54  bl       #0x2480c   ; call _objc_release
0x00014c58  ldr      x0, [sp, #0x90]
0x00014c5c  bl       #0x2480c   ; call _objc_release
0x00014c60  ldr      x22, [sp, #0x70]
0x00014c64  mov      x0, x22
0x00014c68  bl       #0x2480c   ; call _objc_release
0x00014c6c  b        #0x14c74   ; call sub_14c74
0x00014c70  mov      x24, x0
0x00014c74  mov      x0, x24
0x00014c78  bl       #0x24470   ; call __Unwind_Resume
0x00014c7c  stp      d9, d8, [sp, #-0x40]!
0x00014c80  stp      x22, x21, [sp, #0x10]
0x00014c84  stp      x20, x19, [sp, #0x20]
0x00014c88  stp      x29, x30, [sp, #0x30]
0x00014c8c  add      x29, sp, #0x30
0x00014c90  mov      v8.16b, v0.16b
0x00014c94  mov      x20, x0
0x00014c98  bl       #0x26520   ; objc_msgSend: paneFor:
0x00014c9c  mov      x29, x29
0x00014ca0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014ca4  mov      x19, x0
0x00014ca8  cbz      x0, #0x14cf8
0x00014cac  mov      x0, x19
0x00014cb0  bl       #0x25880   ; objc_msgSend: handleOffset
0x00014cb4  fcmp     d0, d8
0x00014cb8  b.eq     #0x14cf8
0x00014cbc  mov      x0, x19
0x00014cc0  mov      v0.16b, v8.16b
0x00014cc4  bl       #0x27040   ; objc_msgSend: setHandleOffset:
0x00014cc8  mov      x0, x19
0x00014ccc  bl       #0x25860   ; objc_msgSend: handleHit
0x00014cd0  mov      x29, x29
0x00014cd4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014cd8  mov      x21, x0
0x00014cdc  bl       #0x25d00   ; objc_msgSend: isHidden
0x00014ce0  eor      w2, w0, #1
0x00014ce4  mov      x0, x20
0x00014ce8  mov      x3, x19
0x00014cec  bl       #0x27080   ; objc_msgSend: setHandleVisible:forPane:
0x00014cf0  mov      x0, x21
0x00014cf4  bl       #0x2480c   ; call _objc_release
0x00014cf8  mov      x0, x19
0x00014cfc  ldp      x29, x30, [sp, #0x30]
0x00014d00  ldp      x20, x19, [sp, #0x20]
0x00014d04  ldp      x22, x21, [sp, #0x10]
0x00014d08  ldp      d9, d8, [sp], #0x40
0x00014d0c  b        #0x2480c   ; call _objc_release
0x00014d10  mov      x20, x0
0x00014d14  mov      x0, x21
0x00014d18  bl       #0x2480c   ; call _objc_release
0x00014d1c  b        #0x14d24   ; call sub_14d24
0x00014d20  mov      x20, x0
0x00014d24  mov      x0, x19
0x00014d28  bl       #0x2480c   ; call _objc_release
0x00014d2c  mov      x0, x20
0x00014d30  bl       #0x24470   ; call __Unwind_Resume
0x00014d34  sub      sp, sp, #0x1a0
0x00014d38  stp      d9, d8, [sp, #0x130]
0x00014d3c  stp      x28, x27, [sp, #0x140]
0x00014d40  stp      x26, x25, [sp, #0x150]
0x00014d44  stp      x24, x23, [sp, #0x160]
0x00014d48  stp      x22, x21, [sp, #0x170]
0x00014d4c  stp      x20, x19, [sp, #0x180]
0x00014d50  stp      x29, x30, [sp, #0x190]
0x00014d54  add      x29, sp, #0x190
0x00014d58  mov      x19, x2
0x00014d5c  mov      x21, x0
0x00014d60  adrp     x8, #0x34000
0x00014d64  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00014d68  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00014d6c  stur     x8, [x29, #-0x68]
0x00014d70  mov      x0, x2
0x00014d74  bl       #0x24818   ; call _objc_retain
0x00014d78  movi     v0.16b, #0
0x00014d7c  stp      q0, q0, [sp, #0x20]
0x00014d80  stp      q0, q0, [sp, #0x40]
0x00014d84  mov      x0, x21
0x00014d88  bl       #0x26580   ; objc_msgSend: panes
0x00014d8c  mov      x29, x29
0x00014d90  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014d94  mov      x20, x0
0x00014d98  add      x2, sp, #0x20
0x00014d9c  add      x3, sp, #0xa8
0x00014da0  mov      w4, #0x10
0x00014da4  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00014da8  mov      x23, x0
0x00014dac  cbz      x0, #0x15068
0x00014db0  ldr      x8, [sp, #0x30]
0x00014db4  ldr      x25, [x8]   ; -> [got:___objc_personality_v0]
0x00014db8  mov      x26, #0
0x00014dbc  ldr      x8, [sp, #0x30]
0x00014dc0  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00014dc4  cmp      x8, x25
0x00014dc8  b.eq     #0x14dd4
0x00014dcc  mov      x0, x20
0x00014dd0  bl       #0x24770   ; call _objc_enumerationMutation
0x00014dd4  ldr      x8, [sp, #0x28]
0x00014dd8  ldr      x22, [x8, x26, lsl #3]   ; -> [got:___objc_personality_v0]
0x00014ddc  mov      x0, x22
0x00014de0  bl       #0x25860   ; objc_msgSend: handleHit
0x00014de4  mov      x29, x29
0x00014de8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014dec  mov      x24, x0
0x00014df0  mov      x0, x19
0x00014df4  bl       #0x28140   ; objc_msgSend: view
0x00014df8  mov      x29, x29
0x00014dfc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014e00  cmp      x24, x0
0x00014e04  cset     w27, eq
0x00014e08  bl       #0x2480c   ; call _objc_release
0x00014e0c  mov      x0, x24
0x00014e10  bl       #0x2480c   ; call _objc_release
0x00014e14  tbnz     w27, #0, #0x14e44
0x00014e18  add      x26, x26, #1
0x00014e1c  cmp      x23, x26
0x00014e20  b.ne     #0x14dbc
0x00014e24  add      x2, sp, #0x20
0x00014e28  add      x3, sp, #0xa8
0x00014e2c  mov      x0, x20
0x00014e30  mov      w4, #0x10
0x00014e34  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00014e38  mov      x23, x0
0x00014e3c  cbnz     x0, #0x14db8
0x00014e40  b        #0x15068   ; call sub_15068
0x00014e44  mov      x0, x19
0x00014e48  bl       #0x27c20   ; objc_msgSend: state
0x00014e4c  cmp      x0, #1
0x00014e50  b.ne     #0x14e5c
0x00014e54  mov      w24, #0
0x00014e58  b        #0x14e88   ; call sub_14e88
0x00014e5c  mov      x0, x19
0x00014e60  bl       #0x27c20   ; objc_msgSend: state
0x00014e64  cmp      x0, #2
0x00014e68  b.ne     #0x14e74
0x00014e6c  mov      w24, #1
0x00014e70  b        #0x14e88   ; call sub_14e88
0x00014e74  mov      x0, x19
0x00014e78  bl       #0x27c20   ; objc_msgSend: state
0x00014e7c  cmp      x0, #3
0x00014e80  mov      w8, #2
0x00014e84  cinc     w24, w8, ne
0x00014e88  mov      x0, x21
0x00014e8c  bl       #0x281e0   ; objc_msgSend: window
0x00014e90  mov      x29, x29
0x00014e94  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014e98  mov      x21, x0
0x00014e9c  mov      x0, x19
0x00014ea0  mov      x2, x21
0x00014ea4  bl       #0x26020   ; objc_msgSend: locationInView:
0x00014ea8  mov      v9.16b, v0.16b
0x00014eac  mov      v8.16b, v1.16b
0x00014eb0  mov      x0, x21
0x00014eb4  bl       #0x2480c   ; call _objc_release
0x00014eb8  cmp      w24, #1
0x00014ebc  b.eq     #0x14f40
0x00014ec0  adrp     x8, #0x3e000
0x00014ec4  ldr      x25, [x8, #0x290]   ; -> [class(NSString)]
0x00014ec8  mov      x0, x22
0x00014ecc  bl       #0x25020   ; objc_msgSend: bundleID
0x00014ed0  mov      x29, x29
0x00014ed4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014ed8  mov      x21, x0
0x00014edc  mov      v0.16b, v9.16b
0x00014ee0  mov      v1.16b, v8.16b
0x00014ee4  bl       #0x24434   ; call _NSStringFromCGPoint
0x00014ee8  mov      x29, x29
0x00014eec  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014ef0  mov      x23, x0
0x00014ef4  stp      x24, x0, [sp, #8]
0x00014ef8  str      x21, [sp]
0x00014efc  adrp     x2, #0x36000
0x00014f00  add      x2, x2, #0x5b0   ; -> @"k"
0x00014f04  mov      x0, x25
0x00014f08  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00014f0c  mov      x29, x29
0x00014f10  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014f14  mov      x25, x0
0x00014f18  adrp     x0, #0x34000
0x00014f1c  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00014f20  mov      x1, x25
0x00014f24  bl       #0x1dd30   ; call _OMCLogWrite
0x00014f28  mov      x0, x25
0x00014f2c  bl       #0x2480c   ; call _objc_release
0x00014f30  mov      x0, x23
0x00014f34  bl       #0x2480c   ; call _objc_release
0x00014f38  mov      x0, x21
0x00014f3c  bl       #0x2480c   ; call _objc_release
0x00014f40  adrp     x0, #0x28000
0x00014f44  add      x0, x0, #0xfc3   ; -> "NSDistributedNotificationCenter"
0x00014f48  bl       #0x24788   ; call _objc_getClass
0x00014f4c  bl       #0x254c0   ; objc_msgSend: defaultCenter
0x00014f50  mov      x29, x29
0x00014f54  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014f58  mov      x21, x0
0x00014f5c  adrp     x8, #0x35000
0x00014f60  add      x8, x8, #0x3b0   ; -> @"identifier"
0x00014f64  str      x8, [sp, #0x68]
0x00014f68  mov      x0, x22
0x00014f6c  bl       #0x25020   ; objc_msgSend: bundleID
0x00014f70  mov      x29, x29
0x00014f74  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014f78  mov      x23, x0
0x00014f7c  str      x0, [sp, #0x88]
0x00014f80  adrp     x8, #0x35000
0x00014f84  add      x8, x8, #0xa50   ; -> @"phase"
0x00014f88  str      x8, [sp, #0x70]
0x00014f8c  adrp     x22, #0x3e000
0x00014f90  ldr      x0, [x22, #0x2a0]   ; -> [class(NSNumber)]
0x00014f94  mov      x2, x24
0x00014f98  bl       #0x26320   ; objc_msgSend: numberWithInt:
0x00014f9c  mov      x29, x29
0x00014fa0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014fa4  mov      x24, x0
0x00014fa8  str      x0, [sp, #0x90]
0x00014fac  adrp     x8, #0x35000
0x00014fb0  add      x8, x8, #0x330   ; -> @"x"
0x00014fb4  str      x8, [sp, #0x78]
0x00014fb8  ldr      x0, [x22, #0x2a0]   ; -> [class(NSNumber)]
0x00014fbc  mov      v0.16b, v9.16b
0x00014fc0  bl       #0x262e0   ; objc_msgSend: numberWithDouble:
0x00014fc4  mov      x29, x29
0x00014fc8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014fcc  mov      x25, x0
0x00014fd0  str      x0, [sp, #0x98]
0x00014fd4  adrp     x8, #0x35000
0x00014fd8  add      x8, x8, #0x350   ; -> @"y"
0x00014fdc  str      x8, [sp, #0x80]
0x00014fe0  ldr      x0, [x22, #0x2a0]   ; -> [class(NSNumber)]
0x00014fe4  mov      v0.16b, v8.16b
0x00014fe8  bl       #0x262e0   ; objc_msgSend: numberWithDouble:
0x00014fec  mov      x29, x29
0x00014ff0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00014ff4  mov      x26, x0
0x00014ff8  str      x0, [sp, #0xa0]
0x00014ffc  adrp     x8, #0x3e000
0x00015000  ldr      x0, [x8, #0x310]   ; -> [class(NSDictionary)]
0x00015004  add      x2, sp, #0x88
0x00015008  add      x3, sp, #0x68
0x0001500c  mov      w4, #4
0x00015010  bl       #0x255c0   ; objc_msgSend: dictionaryWithObjects:forKeys:count:
0x00015014  mov      x29, x29
0x00015018  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001501c  mov      x22, x0
0x00015020  adrp     x2, #0x36000
0x00015024  add      x2, x2, #0x5d0   ; -> @"com.anlai.omnicar/appbridge.handledrag"
0x00015028  mov      x0, x21
0x0001502c  mov      x3, #0
0x00015030  mov      x4, x22
0x00015034  bl       #0x26620   ; objc_msgSend: postNotificationName:object:userInfo:
0x00015038  mov      x0, x22
0x0001503c  bl       #0x2480c   ; call _objc_release
0x00015040  mov      x0, x26
0x00015044  bl       #0x2480c   ; call _objc_release
0x00015048  mov      x0, x25
0x0001504c  bl       #0x2480c   ; call _objc_release
0x00015050  mov      x0, x24
0x00015054  bl       #0x2480c   ; call _objc_release
0x00015058  mov      x0, x23
0x0001505c  bl       #0x2480c   ; call _objc_release
0x00015060  mov      x0, x21
0x00015064  bl       #0x2480c   ; call _objc_release
0x00015068  mov      x0, x20
0x0001506c  bl       #0x2480c   ; call _objc_release
0x00015070  mov      x0, x19
0x00015074  bl       #0x2480c   ; call _objc_release
0x00015078  ldur     x8, [x29, #-0x68]
0x0001507c  adrp     x9, #0x34000
0x00015080  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00015084  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x00015088  cmp      x9, x8
0x0001508c  b.ne     #0x150b4
0x00015090  ldp      x29, x30, [sp, #0x190]
0x00015094  ldp      x20, x19, [sp, #0x180]
0x00015098  ldp      x22, x21, [sp, #0x170]
0x0001509c  ldp      x24, x23, [sp, #0x160]
0x000150a0  ldp      x26, x25, [sp, #0x150]
0x000150a4  ldp      x28, x27, [sp, #0x140]
0x000150a8  ldp      d9, d8, [sp, #0x130]
0x000150ac  add      sp, sp, #0x1a0
0x000150b0  ret      
0x000150b4  bl       #0x24488   ; call ___stack_chk_fail
0x000150b8  mov      x22, x0
0x000150bc  mov      x0, x25
0x000150c0  bl       #0x2480c   ; call _objc_release
0x000150c4  b        #0x150cc   ; call sub_150cc
0x000150c8  mov      x22, x0
0x000150cc  mov      x0, x23
0x000150d0  bl       #0x2480c   ; call _objc_release
0x000150d4  b        #0x150dc   ; call sub_150dc
0x000150d8  mov      x22, x0
0x000150dc  mov      x0, x21
0x000150e0  bl       #0x2480c   ; call _objc_release
0x000150e4  b        #0x15188   ; call sub_15188
0x000150e8  b        #0x15184   ; call sub_15184
0x000150ec  mov      x1, x22
0x000150f0  mov      x22, x0
0x000150f4  mov      x0, x1
0x000150f8  bl       #0x2480c   ; call _objc_release
0x000150fc  b        #0x15104   ; call sub_15104
0x00015100  mov      x22, x0
0x00015104  mov      x0, x26
0x00015108  bl       #0x2480c   ; call _objc_release
0x0001510c  b        #0x15114   ; call sub_15114
0x00015110  mov      x22, x0
0x00015114  mov      x0, x25
0x00015118  bl       #0x2480c   ; call _objc_release
0x0001511c  b        #0x15124   ; call sub_15124
0x00015120  mov      x22, x0
0x00015124  mov      x0, x24
0x00015128  bl       #0x2480c   ; call _objc_release
0x0001512c  b        #0x15134   ; call sub_15134
0x00015130  mov      x22, x0
0x00015134  mov      x0, x23
0x00015138  bl       #0x2480c   ; call _objc_release
0x0001513c  b        #0x15144   ; call sub_15144
0x00015140  mov      x22, x0
0x00015144  mov      x0, x21
0x00015148  bl       #0x2480c   ; call _objc_release
0x0001514c  b        #0x15188   ; call sub_15188
0x00015150  mov      x22, x0
0x00015154  mov      x0, x21
0x00015158  bl       #0x2480c   ; call _objc_release
0x0001515c  b        #0x15188   ; call sub_15188
0x00015160  b        #0x15184   ; call sub_15184
0x00015164  mov      x22, x0
0x00015168  b        #0x15190   ; call sub_15190
0x0001516c  b        #0x15184   ; call sub_15184
0x00015170  b        #0x15184   ; call sub_15184
0x00015174  mov      x22, x0
0x00015178  mov      x0, x24
0x0001517c  bl       #0x2480c   ; call _objc_release
0x00015180  b        #0x15188   ; call sub_15188
0x00015184  mov      x22, x0
0x00015188  mov      x0, x20
0x0001518c  bl       #0x2480c   ; call _objc_release
0x00015190  mov      x0, x19
0x00015194  bl       #0x2480c   ; call _objc_release
0x00015198  b        #0x151a0   ; call sub_151a0
0x0001519c  mov      x22, x0
0x000151a0  mov      x0, x22
0x000151a4  bl       #0x24470   ; call __Unwind_Resume
0x000151a8  stp      x24, x23, [sp, #-0x40]!
0x000151ac  stp      x22, x21, [sp, #0x10]
0x000151b0  stp      x20, x19, [sp, #0x20]
0x000151b4  stp      x29, x30, [sp, #0x30]
0x000151b8  add      x29, sp, #0x30
0x000151bc  mov      x21, x2
0x000151c0  mov      x20, x0
0x000151c4  mov      x2, x3
0x000151c8  bl       #0x26520   ; objc_msgSend: paneFor:
0x000151cc  mov      x29, x29
0x000151d0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000151d4  mov      x19, x0
0x000151d8  cbz      w21, #0x15280
0x000151dc  cbz      x19, #0x15280
0x000151e0  mov      x0, x19
0x000151e4  bl       #0x24f60   ; objc_msgSend: box
0x000151e8  mov      x29, x29
0x000151ec  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000151f0  mov      x21, x0
0x000151f4  bl       #0x27e20   ; objc_msgSend: superview
0x000151f8  mov      x29, x29
0x000151fc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015200  mov      x22, x0
0x00015204  mov      x0, x20
0x00015208  bl       #0x281e0   ; objc_msgSend: window
0x0001520c  mov      x29, x29
0x00015210  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015214  mov      x23, x0
0x00015218  bl       #0x2480c   ; call _objc_release
0x0001521c  mov      x0, x22
0x00015220  bl       #0x2480c   ; call _objc_release
0x00015224  mov      x0, x21
0x00015228  bl       #0x2480c   ; call _objc_release
0x0001522c  cmp      x22, x23
0x00015230  b.ne     #0x15280
0x00015234  mov      x0, x20
0x00015238  bl       #0x281e0   ; objc_msgSend: window
0x0001523c  mov      x29, x29
0x00015240  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015244  mov      x21, x0
0x00015248  mov      x0, x19
0x0001524c  bl       #0x24f60   ; objc_msgSend: box
0x00015250  mov      x29, x29
0x00015254  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015258  mov      x22, x0
0x0001525c  mov      x0, x21
0x00015260  mov      x2, x22
0x00015264  bl       #0x24f80   ; objc_msgSend: bringSubviewToFront:
0x00015268  mov      x0, x22
0x0001526c  bl       #0x2480c   ; call _objc_release
0x00015270  mov      x0, x21
0x00015274  bl       #0x2480c   ; call _objc_release
0x00015278  mov      x0, x20
0x0001527c  bl       #0x26720   ; objc_msgSend: raiseKnobs
0x00015280  mov      x0, x19
0x00015284  ldp      x29, x30, [sp, #0x30]
0x00015288  ldp      x20, x19, [sp, #0x20]
0x0001528c  ldp      x22, x21, [sp, #0x10]
0x00015290  ldp      x24, x23, [sp], #0x40
0x00015294  b        #0x2480c   ; call _objc_release
0x00015298  b        #0x152a0   ; call sub_152a0
0x0001529c  b        #0x152b0   ; call sub_152b0
0x000152a0  mov      x20, x0
0x000152a4  mov      x0, x22
0x000152a8  bl       #0x2480c   ; call _objc_release
0x000152ac  b        #0x152b4   ; call sub_152b4
