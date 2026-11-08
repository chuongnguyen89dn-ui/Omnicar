; ==== sub_1b538 @ 0x1b538..0x1becc (2452 bytes) ====
0x0001b538  mov      x29, x29
0x0001b53c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b540  mov      x19, x0
0x0001b544  mov      x0, x20
0x0001b548  mov      x2, x19
0x0001b54c  bl       #0x27640   ; objc_msgSend: setRows:
0x0001b550  mov      x0, x19
0x0001b554  bl       #0x2480c   ; call _objc_release
0x0001b558  mov      x0, x20
0x0001b55c  bl       #0x25e80   ; objc_msgSend: langButton
0x0001b560  mov      x29, x29
0x0001b564  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b568  mov      x19, x0
0x0001b56c  mov      x0, x20
0x0001b570  bl       #0x28120   ; objc_msgSend: vietnamese
0x0001b574  adrp     x8, #0x36000
0x0001b578  add      x8, x8, #0xdb0   ; -> @"EN"
0x0001b57c  adrp     x9, #0x36000
0x0001b580  add      x9, x9, #0xd90   ; -> @"VI"
0x0001b584  cmp      w0, #0
0x0001b588  csel     x2, x9, x8, ne
0x0001b58c  mov      x0, x19
0x0001b590  mov      x3, #0
0x0001b594  bl       #0x27960   ; objc_msgSend: setTitle:forState:
0x0001b598  mov      x0, x19
0x0001b59c  bl       #0x2480c   ; call _objc_release
0x0001b5a0  mov      x0, x20
0x0001b5a4  bl       #0x263c0   ; objc_msgSend: numbers
0x0001b5a8  adrp     x8, #0x39000
0x0001b5ac  add      x8, x8, #0x480
0x0001b5b0  adrp     x9, #0x39000
0x0001b5b4  add      x9, x9, #0x468
0x0001b5b8  cmp      w0, #0
0x0001b5bc  csel     x0, x9, x8, ne
0x0001b5c0  str      x0, [sp, #0x10]
0x0001b5c4  bl       #0x24818   ; call _objc_retain
0x0001b5c8  str      xzr, [sp, #0x18]
0x0001b5cc  adrp     x8, #0x2b000
0x0001b5d0  ldr      d8, [x8, #0x218]
0x0001b5d4  adrp     x8, #0x2b000
0x0001b5d8  ldr      d9, [x8, #0x220]
0x0001b5dc  adrp     x8, #0x2b000
0x0001b5e0  ldr      d10, [x8, #0x228]
0x0001b5e4  adrp     x8, #0x2b000
0x0001b5e8  ldr      d11, [x8, #0x2d0]
0x0001b5ec  ldr      x0, [sp, #0x10]
0x0001b5f0  bl       #0x25420   ; objc_msgSend: count
0x0001b5f4  ldr      x8, [sp, #0x18]
0x0001b5f8  cmp      x8, x0
0x0001b5fc  b.hs     #0x1b98c
0x0001b600  adrp     x8, #0x3e000
0x0001b604  ldr      x0, [x8, #0x318]   ; -> [class(NSMutableArray)]
0x0001b608  bl       #0x24dc0   ; objc_msgSend: array
0x0001b60c  mov      x29, x29
0x0001b610  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b614  mov      x22, x0
0x0001b618  mov      x0, x20
0x0001b61c  bl       #0x263c0   ; objc_msgSend: numbers
0x0001b620  ldr      x2, [sp, #0x18]
0x0001b624  cmp      x2, #0
0x0001b628  csinc    w21, w0, wzr, ne
0x0001b62c  ldr      x0, [sp, #0x10]
0x0001b630  bl       #0x26400   ; objc_msgSend: objectAtIndexedSubscript:
0x0001b634  mov      x29, x29
0x0001b638  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b63c  str      x0, [sp, #0x28]
0x0001b640  mov      x28, #0
0x0001b644  str      x22, [sp, #0x20]
0x0001b648  ldr      x0, [sp, #0x28]
0x0001b64c  bl       #0x25fa0   ; objc_msgSend: length
0x0001b650  cmp      x28, x0
0x0001b654  b.hs     #0x1b84c
0x0001b658  ldr      x0, [sp, #0x28]
0x0001b65c  mov      x2, x28
0x0001b660  mov      w3, #1
0x0001b664  bl       #0x27de0   ; objc_msgSend: substringWithRange:
0x0001b668  mov      x29, x29
0x0001b66c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b670  mov      x25, x0
0x0001b674  tbnz     w21, #0, #0x1b69c
0x0001b678  mov      x0, x20
0x0001b67c  bl       #0x27ba0   ; objc_msgSend: shift
0x0001b680  cbz      w0, #0x1b69c
0x0001b684  mov      x0, x25
0x0001b688  bl       #0x280a0   ; objc_msgSend: uppercaseString
0x0001b68c  mov      x29, x29
0x0001b690  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b694  mov      x26, x0
0x0001b698  b        #0x1b6a8   ; call sub_1b6a8
0x0001b69c  mov      x0, x25
0x0001b6a0  bl       #0x24818   ; call _objc_retain
0x0001b6a4  mov      x26, x25
0x0001b6a8  fmov     d0, #1.00000000
0x0001b6ac  mov      x0, x20
0x0001b6b0  mov      x2, x26
0x0001b6b4  mov      x3, x26
0x0001b6b8  mov      x4, #0
0x0001b6bc  bl       #0x25de0   ; objc_msgSend: key:value:command:weight:
0x0001b6c0  mov      x29, x29
0x0001b6c4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b6c8  mov      x27, x0
0x0001b6cc  tbz      w21, #0, #0x1b6d8
0x0001b6d0  mov      x24, #0
0x0001b6d4  b        #0x1b810   ; call sub_1b810
0x0001b6d8  mov      x0, x20
0x0001b6dc  bl       #0x28120   ; objc_msgSend: vietnamese
0x0001b6e0  mov      x19, x0
0x0001b6e4  mov      x0, x25
0x0001b6e8  bl       #0x24818   ; call _objc_retain
0x0001b6ec  adrp     x8, #0x3e000
0x0001b6f0  ldr      x8, [x8, #0xa80]
0x0001b6f4  cmn      x8, #1
0x0001b6f8  b.ne     #0x1b844
0x0001b6fc  adrp     x8, #0x3e000
0x0001b700  ldr      x24, [x8, #0xa70]
0x0001b704  adrp     x8, #0x3e000
0x0001b708  ldr      x22, [x8, #0xa78]
0x0001b70c  mov      x0, x25
0x0001b710  bl       #0x26060   ; objc_msgSend: lowercaseString
0x0001b714  mov      x29, x29
0x0001b718  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b71c  mov      x23, x0
0x0001b720  cmp      w19, #0
0x0001b724  csel     x0, x24, x22, ne
0x0001b728  mov      x2, x23
0x0001b72c  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0001b730  mov      x29, x29
0x0001b734  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b738  mov      x24, x0
0x0001b73c  mov      x0, x23
0x0001b740  bl       #0x2480c   ; call _objc_release
0x0001b744  ldr      x22, [sp, #0x20]
0x0001b748  mov      x0, x25
0x0001b74c  bl       #0x2480c   ; call _objc_release
0x0001b750  cbz      x24, #0x1b810
0x0001b754  adrp     x8, #0x3e000
0x0001b758  ldr      x0, [x8, #0x3d8]   ; -> [class(UILabel)]
0x0001b75c  bl       #0x247e8   ; call _objc_opt_new
0x0001b760  mov      x19, x0
0x0001b764  mov      x2, x24
0x0001b768  bl       #0x278c0   ; objc_msgSend: setText:
0x0001b76c  adrp     x8, #0x3e000
0x0001b770  ldr      x0, [x8, #0x3e0]   ; -> [class(UIFont)]
0x0001b774  fmov     d0, #8.00000000
0x0001b778  bl       #0x27e60   ; objc_msgSend: systemFontOfSize:
0x0001b77c  mov      x29, x29
0x0001b780  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b784  mov      x23, x0
0x0001b788  mov      x0, x19
0x0001b78c  mov      x2, x23
0x0001b790  bl       #0x26f60   ; objc_msgSend: setFont:
0x0001b794  mov      x0, x23
0x0001b798  bl       #0x2480c   ; call _objc_release
0x0001b79c  adrp     x8, #0x3e000
0x0001b7a0  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x0001b7a4  mov      v0.16b, v8.16b
0x0001b7a8  mov      v1.16b, v9.16b
0x0001b7ac  mov      v2.16b, v10.16b
0x0001b7b0  mov      v3.16b, v11.16b
0x0001b7b4  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001b7b8  mov      x29, x29
0x0001b7bc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b7c0  mov      x23, x0
0x0001b7c4  mov      x0, x19
0x0001b7c8  mov      x2, x23
0x0001b7cc  bl       #0x27900   ; objc_msgSend: setTextColor:
0x0001b7d0  mov      x0, x23
0x0001b7d4  bl       #0x2480c   ; call _objc_release
0x0001b7d8  mov      x0, x19
0x0001b7dc  mov      w2, #1
0x0001b7e0  bl       #0x278e0   ; objc_msgSend: setTextAlignment:
0x0001b7e4  mov      x0, x19
0x0001b7e8  mov      w2, #0
0x0001b7ec  bl       #0x279e0   ; objc_msgSend: setUserInteractionEnabled:
0x0001b7f0  mov      x0, x27
0x0001b7f4  mov      x2, x19
0x0001b7f8  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x0001b7fc  mov      x0, x27
0x0001b800  mov      x2, x19
0x0001b804  bl       #0x270e0   ; objc_msgSend: setHint:
0x0001b808  mov      x0, x19
0x0001b80c  bl       #0x2480c   ; call _objc_release
0x0001b810  mov      x0, x22
0x0001b814  mov      x2, x27
0x0001b818  bl       #0x24b20   ; objc_msgSend: addObject:
0x0001b81c  mov      x0, x24
0x0001b820  bl       #0x2480c   ; call _objc_release
0x0001b824  mov      x0, x27
0x0001b828  bl       #0x2480c   ; call _objc_release
0x0001b82c  mov      x0, x26
0x0001b830  bl       #0x2480c   ; call _objc_release
0x0001b834  mov      x0, x25
0x0001b838  bl       #0x2480c   ; call _objc_release
0x0001b83c  add      x28, x28, #1
0x0001b840  b        #0x1b648   ; call sub_1b648
0x0001b844  bl       #0x241e0   ; call sub_241e0
0x0001b848  b        #0x1b6fc   ; call sub_1b6fc
0x0001b84c  ldr      x0, [sp, #0x10]
0x0001b850  bl       #0x25420   ; objc_msgSend: count
0x0001b854  sub      x8, x0, #1
0x0001b858  ldr      x9, [sp, #0x18]
0x0001b85c  cmp      x9, x8
0x0001b860  b.ne     #0x1b948
0x0001b864  mov      x0, x20
0x0001b868  bl       #0x263c0   ; objc_msgSend: numbers
0x0001b86c  mov      x19, x0
0x0001b870  cbz      w0, #0x1b8a4
0x0001b874  fmov     d0, #1.50000000
0x0001b878  mov      x0, x20
0x0001b87c  adrp     x2, #0x36000
0x0001b880  add      x2, x2, #0xeb0   ; -> @"#"
0x0001b884  mov      x3, x2
0x0001b888  mov      x4, #0
0x0001b88c  bl       #0x25de0   ; objc_msgSend: key:value:command:weight:
0x0001b890  mov      x29, x29
0x0001b894  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b898  mov      x2, x0
0x0001b89c  str      x0, [sp, #8]
0x0001b8a0  b        #0x1b8e8   ; call sub_1b8e8
0x0001b8a4  mov      x0, x20
0x0001b8a8  bl       #0x27ba0   ; objc_msgSend: shift
0x0001b8ac  cmp      w0, #0
0x0001b8b0  adrp     x5, #0x36000
0x0001b8b4  add      x5, x5, #0xd70   ; -> @"shift"
0x0001b8b8  adrp     x8, #0x36000
0x0001b8bc  add      x8, x8, #0xed0   ; -> @"shift.fill"
0x0001b8c0  csel     x3, x8, x5, ne
0x0001b8c4  fmov     d0, #1.50000000
0x0001b8c8  mov      x0, x20
0x0001b8cc  mov      x2, #0
0x0001b8d0  mov      x4, #0
0x0001b8d4  bl       #0x25dc0   ; objc_msgSend: key:symbol:value:command:weight:
0x0001b8d8  mov      x29, x29
0x0001b8dc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b8e0  mov      x2, x0
0x0001b8e4  str      x0, [sp]
0x0001b8e8  mov      x0, x22
0x0001b8ec  mov      x3, #0
0x0001b8f0  bl       #0x25b00   ; objc_msgSend: insertObject:atIndex:
0x0001b8f4  cmp      w19, #0
0x0001b8f8  ldp      x9, x8, [sp]
0x0001b8fc  csel     x0, x8, x9, ne
0x0001b900  bl       #0x2480c   ; call _objc_release
0x0001b904  fmov     d0, #1.50000000
0x0001b908  mov      x0, x20
0x0001b90c  mov      x2, #0
0x0001b910  adrp     x3, #0x36000
0x0001b914  add      x3, x3, #0xef0   ; -> @"delete.left"
0x0001b918  mov      x4, #0
0x0001b91c  adrp     x5, #0x35000
0x0001b920  add      x5, x5, #0x1b0   ; -> @"del"
0x0001b924  bl       #0x25dc0   ; objc_msgSend: key:symbol:value:command:weight:
0x0001b928  mov      x29, x29
0x0001b92c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b930  mov      x19, x0
0x0001b934  mov      x0, x22
0x0001b938  mov      x2, x19
0x0001b93c  bl       #0x24b20   ; objc_msgSend: addObject:
0x0001b940  mov      x0, x19
0x0001b944  bl       #0x2480c   ; call _objc_release
0x0001b948  mov      x0, x20
0x0001b94c  bl       #0x269e0   ; objc_msgSend: rows
0x0001b950  mov      x29, x29
0x0001b954  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b958  mov      x19, x0
0x0001b95c  mov      x2, x22
0x0001b960  bl       #0x24b20   ; objc_msgSend: addObject:
0x0001b964  mov      x0, x19
0x0001b968  bl       #0x2480c   ; call _objc_release
0x0001b96c  ldr      x0, [sp, #0x28]
0x0001b970  bl       #0x2480c   ; call _objc_release
0x0001b974  mov      x0, x22
0x0001b978  bl       #0x2480c   ; call _objc_release
0x0001b97c  ldr      x8, [sp, #0x18]
0x0001b980  add      x8, x8, #1
0x0001b984  str      x8, [sp, #0x18]
0x0001b988  b        #0x1b5ec   ; call sub_1b5ec
0x0001b98c  mov      x0, x20
0x0001b990  bl       #0x269e0   ; objc_msgSend: rows
0x0001b994  mov      x29, x29
0x0001b998  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b99c  mov      x21, x0
0x0001b9a0  mov      x0, x20
0x0001b9a4  bl       #0x263c0   ; objc_msgSend: numbers
0x0001b9a8  adrp     x8, #0x36000
0x0001b9ac  add      x8, x8, #0xf30   ; -> @"#+="
0x0001b9b0  adrp     x9, #0x36000
0x0001b9b4  add      x9, x9, #0xf10   ; -> @"ABC"
0x0001b9b8  cmp      w0, #0
0x0001b9bc  csel     x2, x9, x8, ne
0x0001b9c0  adrp     x4, #0x36000
0x0001b9c4  add      x4, x4, #0xf50   ; -> @"mode"
0x0001b9c8  adrp     x8, #0x2b000
0x0001b9cc  ldr      d0, [x8, #0x368]
0x0001b9d0  mov      x0, x20
0x0001b9d4  mov      x3, #0
0x0001b9d8  bl       #0x25de0   ; objc_msgSend: key:value:command:weight:
0x0001b9dc  mov      x29, x29
0x0001b9e0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b9e4  mov      x22, x0
0x0001b9e8  str      x0, [sp, #0x1f0]
0x0001b9ec  adrp     x3, #0x36000
0x0001b9f0  add      x3, x3, #0xf70   ; -> @"globe"
0x0001b9f4  adrp     x5, #0x36000
0x0001b9f8  add      x5, x5, #0xf90   ; -> @"lang"
0x0001b9fc  adrp     x8, #0x2b000
0x0001ba00  ldr      d0, [x8, #0x3d0]
0x0001ba04  mov      x0, x20
0x0001ba08  mov      x2, #0
0x0001ba0c  mov      x4, #0
0x0001ba10  bl       #0x25dc0   ; objc_msgSend: key:symbol:value:command:weight:
0x0001ba14  mov      x29, x29
0x0001ba18  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ba1c  mov      x23, x0
0x0001ba20  str      x0, [sp, #0x1f8]
0x0001ba24  adrp     x2, #0x36000
0x0001ba28  add      x2, x2, #0xd30   ; -> @","
0x0001ba2c  fmov     d0, #1.00000000
0x0001ba30  mov      x0, x20
0x0001ba34  mov      x3, x2
0x0001ba38  mov      x4, #0
0x0001ba3c  bl       #0x25de0   ; objc_msgSend: key:value:command:weight:
0x0001ba40  mov      x29, x29
0x0001ba44  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ba48  mov      x24, x0
0x0001ba4c  str      x0, [sp, #0x200]
0x0001ba50  mov      x0, x20
0x0001ba54  bl       #0x28120   ; objc_msgSend: vietnamese
0x0001ba58  adrp     x4, #0x36000
0x0001ba5c  add      x4, x4, #0xcf0   ; -> @"space"
0x0001ba60  adrp     x8, #0x36000
0x0001ba64  add      x8, x8, #0xfb0   ; -> @"T"
0x0001ba68  cmp      w0, #0
0x0001ba6c  csel     x2, x8, x4, ne
0x0001ba70  adrp     x3, #0x36000
0x0001ba74  add      x3, x3, #0xfd0   ; -> @" "
0x0001ba78  adrp     x8, #0x2b000
0x0001ba7c  ldr      d0, [x8, #0x3d8]
0x0001ba80  mov      x0, x20
0x0001ba84  bl       #0x25de0   ; objc_msgSend: key:value:command:weight:
0x0001ba88  mov      x29, x29
0x0001ba8c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ba90  mov      x25, x0
0x0001ba94  str      x0, [sp, #0x208]
0x0001ba98  adrp     x2, #0x36000
0x0001ba9c  add      x2, x2, #0xd50   ; -> @"."
0x0001baa0  fmov     d0, #1.00000000
0x0001baa4  mov      x0, x20
0x0001baa8  mov      x3, x2
0x0001baac  mov      x4, #0
0x0001bab0  bl       #0x25de0   ; objc_msgSend: key:value:command:weight:
0x0001bab4  mov      x29, x29
0x0001bab8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001babc  mov      x19, x0
0x0001bac0  str      x0, [sp, #0x210]
0x0001bac4  adrp     x3, #0x35000
0x0001bac8  add      x3, x3, #0x1f0   ; -> @"return"
0x0001bacc  adrp     x5, #0x36000
0x0001bad0  add      x5, x5, #0xd10   ; -> @"ret"
0x0001bad4  adrp     x8, #0x2b000
0x0001bad8  ldr      d0, [x8, #0x2f8]
0x0001badc  mov      x0, x20
0x0001bae0  mov      x2, #0
0x0001bae4  mov      x4, #0
0x0001bae8  bl       #0x25dc0   ; objc_msgSend: key:symbol:value:command:weight:
0x0001baec  mov      x29, x29
0x0001baf0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001baf4  mov      x26, x0
0x0001baf8  str      x0, [sp, #0x218]
0x0001bafc  adrp     x8, #0x3e000
0x0001bb00  ldr      x0, [x8, #0x2a8]   ; -> [class(NSArray)]
0x0001bb04  add      x2, sp, #0x1f0
0x0001bb08  mov      w3, #6
0x0001bb0c  bl       #0x24e20   ; objc_msgSend: arrayWithObjects:count:
0x0001bb10  mov      x29, x29
0x0001bb14  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001bb18  mov      x27, x0
0x0001bb1c  mov      x0, x21
0x0001bb20  mov      x2, x27
0x0001bb24  bl       #0x24b20   ; objc_msgSend: addObject:
0x0001bb28  mov      x0, x27
0x0001bb2c  bl       #0x2480c   ; call _objc_release
0x0001bb30  mov      x0, x26
0x0001bb34  bl       #0x2480c   ; call _objc_release
0x0001bb38  mov      x0, x19
0x0001bb3c  bl       #0x2480c   ; call _objc_release
0x0001bb40  mov      x0, x25
0x0001bb44  bl       #0x2480c   ; call _objc_release
0x0001bb48  mov      x0, x24
0x0001bb4c  bl       #0x2480c   ; call _objc_release
0x0001bb50  mov      x0, x23
0x0001bb54  bl       #0x2480c   ; call _objc_release
0x0001bb58  mov      x0, x22
0x0001bb5c  bl       #0x2480c   ; call _objc_release
0x0001bb60  mov      x0, x21
0x0001bb64  bl       #0x2480c   ; call _objc_release
0x0001bb68  movi     v0.16b, #0
0x0001bb6c  stp      q0, q0, [sp, #0x90]
0x0001bb70  stp      q0, q0, [sp, #0x70]
0x0001bb74  mov      x0, x20
0x0001bb78  bl       #0x269e0   ; objc_msgSend: rows
0x0001bb7c  mov      x29, x29
0x0001bb80  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001bb84  mov      x19, x0
0x0001bb88  add      x2, sp, #0x70
0x0001bb8c  add      x3, sp, #0x170
0x0001bb90  mov      w4, #0x10
0x0001bb94  str      x0, [sp, #0x28]
0x0001bb98  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001bb9c  mov      x22, x0
0x0001bba0  cbz      x0, #0x1bcac
0x0001bba4  ldr      x8, [sp, #0x80]
0x0001bba8  ldr      x26, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x0001bbac  mov      x27, #0
0x0001bbb0  ldr      x8, [sp, #0x80]
0x0001bbb4  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x0001bbb8  cmp      x8, x26
0x0001bbbc  b.eq     #0x1bbc8
0x0001bbc0  ldr      x0, [sp, #0x28]
0x0001bbc4  bl       #0x24770   ; call _objc_enumerationMutation
0x0001bbc8  ldr      x8, [sp, #0x78]
0x0001bbcc  ldr      x19, [x8, x27, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x0001bbd0  movi     v0.16b, #0
0x0001bbd4  stp      q0, q0, [sp, #0x30]
0x0001bbd8  stp      q0, q0, [sp, #0x50]
0x0001bbdc  mov      x0, x19
0x0001bbe0  bl       #0x24818   ; call _objc_retain
0x0001bbe4  add      x2, sp, #0x30
0x0001bbe8  add      x3, sp, #0xf0
0x0001bbec  mov      x0, x19
0x0001bbf0  mov      w4, #0x10
0x0001bbf4  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001bbf8  mov      x23, x0
0x0001bbfc  cbz      x0, #0x1bc78
0x0001bc00  ldr      x8, [sp, #0x40]
0x0001bc04  ldr      x28, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x0001bc08  mov      x21, #0
0x0001bc0c  ldr      x8, [sp, #0x40]
0x0001bc10  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x0001bc14  cmp      x8, x28
0x0001bc18  b.eq     #0x1bc24
0x0001bc1c  mov      x0, x19
0x0001bc20  bl       #0x24770   ; call _objc_enumerationMutation
0x0001bc24  ldr      x8, [sp, #0x38]
0x0001bc28  ldr      x25, [x8, x21, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x0001bc2c  mov      x0, x20
0x0001bc30  bl       #0x25e40   ; objc_msgSend: keysView
0x0001bc34  mov      x29, x29
0x0001bc38  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001bc3c  mov      x24, x0
0x0001bc40  mov      x2, x25
0x0001bc44  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x0001bc48  mov      x0, x24
0x0001bc4c  bl       #0x2480c   ; call _objc_release
0x0001bc50  add      x21, x21, #1
0x0001bc54  cmp      x23, x21
0x0001bc58  b.ne     #0x1bc0c
0x0001bc5c  add      x2, sp, #0x30
0x0001bc60  add      x3, sp, #0xf0
0x0001bc64  mov      x0, x19
0x0001bc68  mov      w4, #0x10
0x0001bc6c  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001bc70  mov      x23, x0
0x0001bc74  cbnz     x0, #0x1bc08
0x0001bc78  mov      x0, x19
0x0001bc7c  bl       #0x2480c   ; call _objc_release
0x0001bc80  add      x27, x27, #1
0x0001bc84  cmp      x27, x22
0x0001bc88  b.ne     #0x1bbb0
0x0001bc8c  add      x2, sp, #0x70
0x0001bc90  add      x3, sp, #0x170
0x0001bc94  ldr      x19, [sp, #0x28]
0x0001bc98  mov      x0, x19
0x0001bc9c  mov      w4, #0x10
0x0001bca0  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001bca4  mov      x22, x0
0x0001bca8  cbnz     x0, #0x1bbac
0x0001bcac  mov      x0, x19
0x0001bcb0  bl       #0x2480c   ; call _objc_release
0x0001bcb4  mov      x0, x20
0x0001bcb8  bl       #0x25f40   ; objc_msgSend: layoutKeys
0x0001bcbc  ldr      x0, [sp, #0x10]
0x0001bcc0  bl       #0x2480c   ; call _objc_release
0x0001bcc4  ldur     x8, [x29, #-0x80]
0x0001bcc8  adrp     x9, #0x34000
0x0001bccc  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x0001bcd0  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0001bcd4  cmp      x9, x8
0x0001bcd8  b.ne     #0x1bd04
0x0001bcdc  add      sp, sp, #0x2b0
0x0001bce0  ldp      x29, x30, [sp, #0x70]
0x0001bce4  ldp      x20, x19, [sp, #0x60]
0x0001bce8  ldp      x22, x21, [sp, #0x50]
0x0001bcec  ldp      x24, x23, [sp, #0x40]
0x0001bcf0  ldp      x26, x25, [sp, #0x30]
0x0001bcf4  ldp      x28, x27, [sp, #0x20]
0x0001bcf8  ldp      d9, d8, [sp, #0x10]
0x0001bcfc  ldp      d11, d10, [sp], #0x80
0x0001bd00  ret      
0x0001bd04  bl       #0x24488   ; call ___stack_chk_fail
0x0001bd08  b        #0x1be44   ; call sub_1be44
0x0001bd0c  b        #0x1be3c   ; call sub_1be3c
0x0001bd10  mov      x20, x0
0x0001bd14  mov      x0, x27
0x0001bd18  bl       #0x2480c   ; call _objc_release
0x0001bd1c  b        #0x1bd24   ; call sub_1bd24
0x0001bd20  mov      x20, x0
0x0001bd24  mov      x0, x26
0x0001bd28  bl       #0x2480c   ; call _objc_release
0x0001bd2c  b        #0x1bd34   ; call sub_1bd34
0x0001bd30  mov      x20, x0
0x0001bd34  mov      x0, x19
0x0001bd38  bl       #0x2480c   ; call _objc_release
0x0001bd3c  b        #0x1bd44   ; call sub_1bd44
0x0001bd40  mov      x20, x0
0x0001bd44  mov      x0, x25
0x0001bd48  bl       #0x2480c   ; call _objc_release
0x0001bd4c  b        #0x1bd9c   ; call sub_1bd9c
0x0001bd50  mov      x20, x0
0x0001bd54  b        #0x1bda4   ; call sub_1bda4
0x0001bd58  mov      x20, x0
0x0001bd5c  b        #0x1bdac   ; call sub_1bdac
0x0001bd60  mov      x20, x0
0x0001bd64  mov      x0, x19
0x0001bd68  bl       #0x2480c   ; call _objc_release
0x0001bd6c  b        #0x1bf54   ; call sub_1bf54
0x0001bd70  b        #0x1bec4   ; call sub_1bec4
0x0001bd74  mov      x20, x0
0x0001bd78  mov      x0, x22
0x0001bd7c  bl       #0x2480c   ; call _objc_release
0x0001bd80  b        #0x1bd88   ; call sub_1bd88
0x0001bd84  mov      x20, x0
0x0001bd88  mov      x0, x21
0x0001bd8c  bl       #0x2480c   ; call _objc_release
0x0001bd90  b        #0x1bf54   ; call sub_1bf54
0x0001bd94  b        #0x1be3c   ; call sub_1be3c
0x0001bd98  mov      x20, x0
0x0001bd9c  mov      x0, x24
0x0001bda0  bl       #0x2480c   ; call _objc_release
0x0001bda4  mov      x0, x23
0x0001bda8  bl       #0x2480c   ; call _objc_release
0x0001bdac  mov      x0, x22
0x0001bdb0  bl       #0x2480c   ; call _objc_release
0x0001bdb4  b        #0x1bdbc   ; call sub_1bdbc
0x0001bdb8  mov      x20, x0
0x0001bdbc  mov      x0, x21
0x0001bdc0  bl       #0x2480c   ; call _objc_release
0x0001bdc4  b        #0x1bf44   ; call sub_1bf44
0x0001bdc8  mov      x20, x0
0x0001bdcc  mov      x0, x19
0x0001bdd0  bl       #0x2480c   ; call _objc_release
0x0001bdd4  b        #0x1bf54   ; call sub_1bf54
0x0001bdd8  b        #0x1be44   ; call sub_1be44
0x0001bddc  mov      x20, x0
0x0001bde0  mov      x0, x19
0x0001bde4  bl       #0x2480c   ; call _objc_release
0x0001bde8  b        #0x1bf08   ; call sub_1bf08
0x0001bdec  mov      x20, x0
0x0001bdf0  tbz      w19, #0, #0x1be04
0x0001bdf4  ldr      x0, [sp, #8]
0x0001bdf8  bl       #0x2480c   ; call _objc_release
0x0001bdfc  ldr      x22, [sp, #0x20]
0x0001be00  b        #0x1bf08   ; call sub_1bf08
0x0001be04  ldr      x0, [sp]
0x0001be08  bl       #0x2480c   ; call _objc_release
0x0001be0c  ldr      x22, [sp, #0x20]
0x0001be10  b        #0x1bf08   ; call sub_1bf08
0x0001be14  b        #0x1bed4   ; call sub_1bed4
0x0001be18  b        #0x1bec4   ; call sub_1bec4
0x0001be1c  mov      x20, x0
0x0001be20  mov      x0, x19
0x0001be24  bl       #0x2480c   ; call _objc_release
0x0001be28  b        #0x1bf08   ; call sub_1bf08
0x0001be2c  b        #0x1be30   ; call sub_1be30
0x0001be30  mov      x20, x0
0x0001be34  b        #0x1bf10   ; call sub_1bf10
0x0001be38  b        #0x1be3c   ; call sub_1be3c
0x0001be3c  mov      x20, x0
0x0001be40  b        #0x1bf44   ; call sub_1bf44
0x0001be44  mov      x20, x0
0x0001be48  b        #0x1bf3c   ; call sub_1bf3c
0x0001be4c  b        #0x1bed4   ; call sub_1bed4
0x0001be50  b        #0x1bf30   ; call sub_1bf30
0x0001be54  mov      x20, x0
0x0001be58  mov      x0, x23
0x0001be5c  bl       #0x2480c   ; call _objc_release
0x0001be60  b        #0x1bee0   ; call sub_1bee0
0x0001be64  b        #0x1beb0   ; call sub_1beb0
0x0001be68  mov      x20, x0
0x0001be6c  mov      x0, x23
0x0001be70  bl       #0x2480c   ; call _objc_release
0x0001be74  b        #0x1bee0   ; call sub_1bee0
0x0001be78  mov      x20, x0
0x0001be7c  mov      x0, x23
0x0001be80  bl       #0x2480c   ; call _objc_release
0x0001be84  ldr      x22, [sp, #0x20]
0x0001be88  b        #0x1be94   ; call sub_1be94
0x0001be8c  mov      x20, x0
0x0001be90  ldr      x22, [sp, #0x20]
0x0001be94  mov      x0, x25
0x0001be98  bl       #0x2480c   ; call _objc_release
0x0001be9c  b        #0x1bef0   ; call sub_1bef0
0x0001bea0  mov      x20, x0
0x0001bea4  b        #0x1bef0   ; call sub_1bef0
0x0001bea8  mov      x20, x0
0x0001beac  b        #0x1bf00   ; call sub_1bf00
0x0001beb0  mov      x20, x0
0x0001beb4  b        #0x1bee8   ; call sub_1bee8
0x0001beb8  mov      x20, x0
0x0001bebc  b        #0x1bef8   ; call sub_1bef8
0x0001bec0  b        #0x1bed4   ; call sub_1bed4
0x0001bec4  mov      x20, x0
0x0001bec8  mov      x0, x19
