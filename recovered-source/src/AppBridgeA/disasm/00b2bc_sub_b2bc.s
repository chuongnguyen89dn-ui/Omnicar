; ==== sub_b2bc @ 0xb2bc..0xb4b4 (504 bytes) ====
0x0000b2bc  bl       #0x2480c   ; call _objc_release
0x0000b2c0  mov      x0, x23
0x0000b2c4  mov      w2, #0
0x0000b2c8  bl       #0x270a0   ; objc_msgSend: setHidden:
0x0000b2cc  mov      x0, x21
0x0000b2d0  mov      x2, x23
0x0000b2d4  bl       #0x27a80   ; objc_msgSend: setWindow:
0x0000b2d8  mov      x0, x21
0x0000b2dc  mov      x2, x20
0x0000b2e0  bl       #0x26ea0   ; objc_msgSend: setDisplayID:
0x0000b2e4  ldr      x21, [x28, #0x290]
0x0000b2e8  mov      x0, x23
0x0000b2ec  bl       #0x24f40   ; objc_msgSend: bounds
0x0000b2f0  bl       #0x24440   ; call _NSStringFromCGRect
0x0000b2f4  mov      x29, x29
0x0000b2f8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b2fc  mov      x24, x0
0x0000b300  stp      x0, x20, [sp]
0x0000b304  adrp     x2, #0x35000
0x0000b308  add      x2, x2, #0xab0   ; -> @"cua so tren man xe %@ (%@)"
0x0000b30c  mov      x0, x21
0x0000b310  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000b314  mov      x29, x29
0x0000b318  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b31c  mov      x25, x0
0x0000b320  adrp     x0, #0x34000
0x0000b324  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000b328  mov      x1, x25
0x0000b32c  bl       #0x1dd30   ; call _OMCLogWrite
0x0000b330  mov      x0, x25
0x0000b334  bl       #0x2480c   ; call _objc_release
0x0000b338  mov      x0, x24
0x0000b33c  bl       #0x2480c   ; call _objc_release
0x0000b340  mov      x0, x23
0x0000b344  bl       #0x2480c   ; call _objc_release
0x0000b348  b        #0xaff4   ; call sub_aff4
0x0000b34c  adrp     x1, #0x36000
0x0000b350  add      x1, x1, #0x830   ; -> @"initWithDisplayConfiguration:"
0x0000b354  mov      x0, x23
0x0000b358  bl       #0x9698   ; call _ABMissingSelector
0x0000b35c  mov      x25, #0
0x0000b360  mov      x0, x23
0x0000b364  bl       #0x2480c   ; call _objc_release
0x0000b368  adrp     x8, #0x3e000
0x0000b36c  ldr      x0, [x8, #0x380]   ; -> [class(UIWindow)]
0x0000b370  bl       #0x247d0   ; call _objc_opt_class
0x0000b374  mov      x1, x0
0x0000b378  mov      x0, x25
0x0000b37c  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0000b380  tbz      w0, #0, #0xb394
0x0000b384  mov      x0, x25
0x0000b388  bl       #0x24818   ; call _objc_retain
0x0000b38c  mov      x23, x25
0x0000b390  b        #0xb174   ; call sub_b174
0x0000b394  ldr      x0, [x28, #0x290]
0x0000b398  str      x25, [sp]
0x0000b39c  adrp     x2, #0x36000
0x0000b3a0  add      x2, x2, #0x850   ; -> @"khong tao duoc UIRootSceneWindow: %@"
0x0000b3a4  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000b3a8  mov      x29, x29
0x0000b3ac  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b3b0  mov      x23, x0
0x0000b3b4  adrp     x0, #0x34000
0x0000b3b8  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000b3bc  mov      x1, x23
0x0000b3c0  bl       #0x1dd30   ; call _OMCLogWrite
0x0000b3c4  mov      x0, x23
0x0000b3c8  bl       #0x2480c   ; call _objc_release
0x0000b3cc  b        #0xb170   ; call sub_b170
0x0000b3d0  mov      x21, x0
0x0000b3d4  mov      x0, x23
0x0000b3d8  bl       #0x2480c   ; call _objc_release
0x0000b3dc  b        #0xb414   ; call sub_b414
0x0000b3e0  b        #0xb3ec   ; call sub_b3ec
0x0000b3e4  b        #0xb3f8   ; call sub_b3f8
0x0000b3e8  b        #0xb484   ; call sub_b484
0x0000b3ec  mov      x21, x0
0x0000b3f0  mov      x0, x23
0x0000b3f4  b        #0xb418   ; call sub_b418
0x0000b3f8  mov      x21, x0
0x0000b3fc  b        #0xb41c   ; call sub_b41c
0x0000b400  mov      x21, x0
0x0000b404  mov      x0, x25
0x0000b408  b        #0xb47c   ; call sub_b47c
0x0000b40c  b        #0xb484   ; call sub_b484
0x0000b410  mov      x21, x0
0x0000b414  mov      x0, x25
0x0000b418  bl       #0x2480c   ; call _objc_release
0x0000b41c  mov      x0, x24
0x0000b420  b        #0xb47c   ; call sub_b47c
0x0000b424  mov      x21, x0
0x0000b428  mov      x0, x25
0x0000b42c  bl       #0x2480c   ; call _objc_release
0x0000b430  b        #0xb43c   ; call sub_b43c
0x0000b434  b        #0xb438   ; call sub_b438
0x0000b438  mov      x21, x0
0x0000b43c  mov      x0, x24
0x0000b440  b        #0xb4a0   ; call sub_b4a0
0x0000b444  mov      x21, x0
0x0000b448  mov      x0, x26
0x0000b44c  b        #0xb498   ; call sub_b498
0x0000b450  b        #0xb454   ; call sub_b454
0x0000b454  mov      x21, x0
0x0000b458  b        #0xb49c   ; call sub_b49c
0x0000b45c  b        #0xb474   ; call sub_b474
0x0000b460  b        #0xb484   ; call sub_b484
0x0000b464  b        #0xb490   ; call sub_b490
0x0000b468  b        #0xb4bc   ; call sub_b4bc
0x0000b46c  b        #0xb474   ; call sub_b474
0x0000b470  b        #0xb484   ; call sub_b484
0x0000b474  mov      x21, x0
0x0000b478  mov      x0, x23
0x0000b47c  bl       #0x2480c   ; call _objc_release
0x0000b480  b        #0xb488   ; call sub_b488
0x0000b484  mov      x21, x0
0x0000b488  mov      x0, x22
0x0000b48c  b        #0xb4b4   ; call sub_b4b4
0x0000b490  mov      x21, x0
0x0000b494  mov      x0, x24
0x0000b498  bl       #0x2480c   ; call _objc_release
0x0000b49c  mov      x0, x23
0x0000b4a0  bl       #0x2480c   ; call _objc_release
0x0000b4a4  b        #0xb4b0   ; call sub_b4b0
0x0000b4a8  b        #0xb4c4   ; call sub_b4c4
0x0000b4ac  mov      x21, x0
0x0000b4b0  mov      x0, x23
