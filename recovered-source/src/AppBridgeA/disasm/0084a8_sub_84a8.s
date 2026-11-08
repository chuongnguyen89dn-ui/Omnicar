; ==== sub_84a8 @ 0x84a8..0x8728 (640 bytes) ====
0x000084a8  mov      v1.16b, v9.16b
0x000084ac  mov      v2.16b, v10.16b
0x000084b0  mov      v3.16b, v11.16b
0x000084b4  mov      x2, x24
0x000084b8  mov      x3, x21
0x000084bc  mov      v4.16b, v12.16b
0x000084c0  mov      v5.16b, v13.16b
0x000084c4  mov      v6.16b, v14.16b
0x000084c8  mov      v7.16b, v15.16b
0x000084cc  bl       #0x26fa0   ; objc_msgSend: setFrame:forApp:live:handle:passInsets:
0x000084d0  mov      x0, x26
0x000084d4  bl       #0x2480c   ; call _objc_release
0x000084d8  mov      x0, x25
0x000084dc  bl       #0x2480c   ; call _objc_release
0x000084e0  mov      x0, x24
0x000084e4  bl       #0x2480c   ; call _objc_release
0x000084e8  mov      x0, x23
0x000084ec  bl       #0x2480c   ; call _objc_release
0x000084f0  adrp     x8, #0x3e000
0x000084f4  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x000084f8  bl       #0x27b20   ; objc_msgSend: shared
0x000084fc  mov      x29, x29
0x00008500  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008504  mov      x19, x0
0x00008508  adrp     x2, #0x35000
0x0000850c  add      x2, x2, #0x450   ; -> @"bar"
0x00008510  mov      x0, x20
0x00008514  str      x19, [sp, #0x10]
0x00008518  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0000851c  mov      x29, x29
0x00008520  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008524  str      x0, [sp, #8]
0x00008528  bl       #0x24f20   ; objc_msgSend: boolValue
0x0000852c  mov      x21, x0
0x00008530  adrp     x2, #0x35000
0x00008534  add      x2, x2, #0x470   ; -> @"pop"
0x00008538  mov      x0, x20
0x0000853c  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008540  mov      x29, x29
0x00008544  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008548  mov      x25, x0
0x0000854c  bl       #0x25ba0   ; objc_msgSend: intValue
0x00008550  mov      x22, x0
0x00008554  adrp     x2, #0x35000
0x00008558  add      x2, x2, #0x490   ; -> @"popDim"
0x0000855c  mov      x0, x20
0x00008560  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008564  mov      x29, x29
0x00008568  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000856c  mov      x26, x0
0x00008570  bl       #0x24f20   ; objc_msgSend: boolValue
0x00008574  mov      x28, x0
0x00008578  adrp     x2, #0x35000
0x0000857c  add      x2, x2, #0x4b0   ; -> @"single"
0x00008580  mov      x0, x20
0x00008584  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008588  mov      x29, x29
0x0000858c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008590  mov      x27, x0
0x00008594  bl       #0x24f20   ; objc_msgSend: boolValue
0x00008598  mov      x23, x0
0x0000859c  adrp     x2, #0x35000
0x000085a0  add      x2, x2, #0x3b0   ; -> @"identifier"
0x000085a4  mov      x0, x20
0x000085a8  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000085ac  mov      x29, x29
0x000085b0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000085b4  mov      x19, x0
0x000085b8  ldr      x24, [sp, #0x10]
0x000085bc  mov      x0, x24
0x000085c0  mov      x2, x21
0x000085c4  mov      x3, x22
0x000085c8  mov      x4, x28
0x000085cc  mov      x5, x23
0x000085d0  mov      x6, x19
0x000085d4  bl       #0x26c60   ; objc_msgSend: setBarVisible:pop:dim:single:forApp:
0x000085d8  mov      x0, x19
0x000085dc  bl       #0x2480c   ; call _objc_release
0x000085e0  mov      x0, x27
0x000085e4  bl       #0x2480c   ; call _objc_release
0x000085e8  mov      x0, x26
0x000085ec  bl       #0x2480c   ; call _objc_release
0x000085f0  mov      x0, x25
0x000085f4  bl       #0x2480c   ; call _objc_release
0x000085f8  ldr      x0, [sp, #8]
0x000085fc  bl       #0x2480c   ; call _objc_release
0x00008600  mov      x0, x24
0x00008604  bl       #0x2480c   ; call _objc_release
0x00008608  adrp     x8, #0x3e000
0x0000860c  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x00008610  bl       #0x27b20   ; objc_msgSend: shared
0x00008614  mov      x29, x29
0x00008618  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000861c  mov      x23, x0
0x00008620  adrp     x2, #0x35000
0x00008624  add      x2, x2, #0x4d0   ; -> @"ox"
0x00008628  mov      x0, x20
0x0000862c  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008630  mov      x29, x29
0x00008634  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008638  mov      x24, x0
0x0000863c  bl       #0x25640   ; objc_msgSend: doubleValue
0x00008640  mov      v8.16b, v0.16b
0x00008644  adrp     x2, #0x35000
0x00008648  add      x2, x2, #0x4f0   ; -> @"oy"
0x0000864c  mov      x0, x20
0x00008650  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008654  mov      x29, x29
0x00008658  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000865c  mov      x25, x0
0x00008660  bl       #0x25640   ; objc_msgSend: doubleValue
0x00008664  mov      v9.16b, v0.16b
0x00008668  adrp     x2, #0x35000
0x0000866c  add      x2, x2, #0x510   ; -> @"ow"
0x00008670  mov      x0, x20
0x00008674  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008678  mov      x29, x29
0x0000867c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008680  mov      x26, x0
0x00008684  bl       #0x25640   ; objc_msgSend: doubleValue
0x00008688  mov      v10.16b, v0.16b
0x0000868c  adrp     x2, #0x35000
0x00008690  add      x2, x2, #0x530   ; -> @"oh"
0x00008694  mov      x0, x20
0x00008698  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0000869c  mov      x29, x29
0x000086a0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000086a4  mov      x27, x0
0x000086a8  bl       #0x25640   ; objc_msgSend: doubleValue
0x000086ac  mov      v11.16b, v0.16b
0x000086b0  adrp     x2, #0x35000
0x000086b4  add      x2, x2, #0x3b0   ; -> @"identifier"
0x000086b8  mov      x0, x20
0x000086bc  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000086c0  mov      x29, x29
0x000086c4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000086c8  mov      x19, x0
0x000086cc  mov      x0, x23
0x000086d0  mov      v0.16b, v8.16b
0x000086d4  mov      v1.16b, v9.16b
0x000086d8  mov      v2.16b, v10.16b
0x000086dc  mov      v3.16b, v11.16b
0x000086e0  mov      x2, x19
0x000086e4  bl       #0x27120   ; objc_msgSend: setHole:forApp:
0x000086e8  mov      x0, x19
0x000086ec  bl       #0x2480c   ; call _objc_release
0x000086f0  mov      x0, x27
0x000086f4  bl       #0x2480c   ; call _objc_release
0x000086f8  mov      x0, x26
0x000086fc  bl       #0x2480c   ; call _objc_release
0x00008700  mov      x0, x25
0x00008704  bl       #0x2480c   ; call _objc_release
0x00008708  mov      x0, x24
0x0000870c  bl       #0x2480c   ; call _objc_release
0x00008710  mov      x0, x23
0x00008714  bl       #0x2480c   ; call _objc_release
0x00008718  adrp     x8, #0x3e000
0x0000871c  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x00008720  bl       #0x27b20   ; objc_msgSend: shared
0x00008724  mov      x29, x29
