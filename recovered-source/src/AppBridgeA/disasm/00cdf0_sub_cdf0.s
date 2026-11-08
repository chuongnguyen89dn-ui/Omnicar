; ==== sub_cdf0 @ 0xcdf0..0xcfd4 (484 bytes) ====
0x0000cdf0  mov      x0, x22
0x0000cdf4  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0000cdf8  tbnz     w0, #0, #0xce58
0x0000cdfc  ldr      x0, [x26, #0x290]
0x0000ce00  mov      w8, #0x1d1
0x0000ce04  stp      x25, x8, [sp, #0x10]
0x0000ce08  stp      x19, x22, [sp]
0x0000ce0c  adrp     x2, #0x35000
0x0000ce10  add      x2, x2, #0xc10   ; -> @"UNEXPECTED %s: got %@ (%s:%d)"
0x0000ce14  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000ce18  mov      x29, x29
0x0000ce1c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ce20  mov      x20, x0
0x0000ce24  adrp     x0, #0x34000
0x0000ce28  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000ce2c  mov      x1, x20
0x0000ce30  bl       #0x1dd30   ; call _OMCLogWrite
0x0000ce34  mov      x0, x20
0x0000ce38  bl       #0x2480c   ; call _objc_release
0x0000ce3c  ldr      x0, [x24, #0x338]
0x0000ce40  adrp     x2, #0x34000
0x0000ce44  add      x2, x2, #0xef0   ; -> @"AppBridge"
0x0000ce48  stp      x19, x22, [sp]
0x0000ce4c  adrp     x3, #0x35000
0x0000ce50  add      x3, x3, #0xc30   ; -> @"expected %s got %@"
0x0000ce54  bl       #0x26700   ; objc_msgSend: raise:format:
0x0000ce58  mov      x0, x22
0x0000ce5c  bl       #0x24818   ; call _objc_retain
0x0000ce60  mov      x0, x22
0x0000ce64  bl       #0x2480c   ; call _objc_release
0x0000ce68  mov      x0, x22
0x0000ce6c  bl       #0x2480c   ; call _objc_release
0x0000ce70  ldr      x0, [sp, #0x80]
0x0000ce74  mov      x2, x22
0x0000ce78  bl       #0x26ba0   ; objc_msgSend: setAppViewController:
0x0000ce7c  mov      x0, x22
0x0000ce80  bl       #0x24818   ; call _objc_retain
0x0000ce84  adrp     x0, #0x35000
0x0000ce88  add      x0, x0, #0xdf0   ; -> @"setIgnoresOcclusions:"
0x0000ce8c  bl       #0x2441c   ; call _NSSelectorFromString
0x0000ce90  mov      x19, x0
0x0000ce94  mov      x0, x22
0x0000ce98  mov      x1, x19
0x0000ce9c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000cea0  tbz      w0, #0, #0xceb8
0x0000cea4  mov      x0, x22
0x0000cea8  mov      x1, x19
0x0000ceac  mov      w2, #0
0x0000ceb0  bl       #0x247ac   ; call _objc_msgSend
0x0000ceb4  b        #0xcec8   ; call sub_cec8
0x0000ceb8  adrp     x1, #0x35000
0x0000cebc  add      x1, x1, #0xdf0   ; -> @"setIgnoresOcclusions:"
0x0000cec0  mov      x0, x22
0x0000cec4  bl       #0x9698   ; call _ABMissingSelector
0x0000cec8  mov      x0, x22
0x0000cecc  bl       #0x2480c   ; call _objc_release
0x0000ced0  adrp     x2, #0x39000
0x0000ced4  add      x2, x2, #0x5d0
0x0000ced8  adrp     x3, #0x35000
0x0000cedc  add      x3, x3, #0xe10   ; -> @"_currentMode"
0x0000cee0  mov      x0, x22
0x0000cee4  bl       #0x27a20   ; objc_msgSend: setValue:forKey:
0x0000cee8  adrp     x2, #0x35000
0x0000ceec  add      x2, x2, #0xe30   ; -> @"_activationSettings"
0x0000cef0  mov      x0, x22
0x0000cef4  bl       #0x28100   ; objc_msgSend: valueForKey:
0x0000cef8  mov      x29, x29
0x0000cefc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000cf00  mov      x19, x0
0x0000cf04  adrp     x0, #0x35000
0x0000cf08  add      x0, x0, #0xe50   ; -> @"clearActivationSettings"
0x0000cf0c  bl       #0x2441c   ; call _NSSelectorFromString
0x0000cf10  mov      x20, x0
0x0000cf14  mov      x0, x19
0x0000cf18  mov      x1, x20
0x0000cf1c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000cf20  tbz      w0, #0, #0xcf34
0x0000cf24  mov      x0, x19
0x0000cf28  mov      x1, x20
0x0000cf2c  bl       #0x247ac   ; call _objc_msgSend
0x0000cf30  b        #0xcf44   ; call sub_cf44
0x0000cf34  adrp     x1, #0x35000
0x0000cf38  add      x1, x1, #0xe50   ; -> @"clearActivationSettings"
0x0000cf3c  mov      x0, x19
0x0000cf40  bl       #0x9698   ; call _ABMissingSelector
0x0000cf44  mov      x0, x19
0x0000cf48  bl       #0x2480c   ; call _objc_release
0x0000cf4c  mov      x0, x22
0x0000cf50  bl       #0x24818   ; call _objc_retain
0x0000cf54  adrp     x0, #0x35000
0x0000cf58  add      x0, x0, #0xe70   ; -> @"_createSceneUpdateTransactionForApplicationSceneEntity:deliveringActions:"
0x0000cf5c  bl       #0x2441c   ; call _NSSelectorFromString
0x0000cf60  mov      x19, x0
0x0000cf64  mov      x0, x22
0x0000cf68  mov      x1, x19
0x0000cf6c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000cf70  tbz      w0, #0, #0xcf98
0x0000cf74  mov      x0, x22
0x0000cf78  mov      x1, x19
0x0000cf7c  ldr      x2, [sp, #0x78]
0x0000cf80  mov      w3, #1
0x0000cf84  bl       #0x247ac   ; call _objc_msgSend
0x0000cf88  mov      x29, x29
0x0000cf8c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000cf90  mov      x20, x0
0x0000cf94  b        #0xcfac   ; call sub_cfac
0x0000cf98  adrp     x1, #0x35000
0x0000cf9c  add      x1, x1, #0xe70   ; -> @"_createSceneUpdateTransactionForApplicationSceneEntity:deliveringActions:"
0x0000cfa0  mov      x0, x22
0x0000cfa4  bl       #0x9698   ; call _ABMissingSelector
0x0000cfa8  mov      x20, #0
0x0000cfac  mov      x0, x20
0x0000cfb0  bl       #0x24818   ; call _objc_retain
0x0000cfb4  mov      x0, x20
0x0000cfb8  bl       #0x2480c   ; call _objc_release
0x0000cfbc  mov      x0, x22
0x0000cfc0  bl       #0x2480c   ; call _objc_release
0x0000cfc4  mov      x0, x20
0x0000cfc8  bl       #0x24818   ; call _objc_retain
0x0000cfcc  cbz      x20, #0xcfec
0x0000cfd0  adrp     x0, #0x29000
