; ==== sub_d2b4 @ 0xd2b4..0xd3b0 (252 bytes) ====
0x0000d2b4  mov      x23, x0
0x0000d2b8  mov      x0, x22
0x0000d2bc  mov      x1, x23
0x0000d2c0  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000d2c4  tbz      w0, #0, #0xd2e4
0x0000d2c8  mov      x0, x22
0x0000d2cc  mov      x1, x23
0x0000d2d0  bl       #0x247ac   ; call _objc_msgSend
0x0000d2d4  mov      x29, x29
0x0000d2d8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000d2dc  mov      x23, x0
0x0000d2e0  b        #0xd2f8   ; call sub_d2f8
0x0000d2e4  adrp     x1, #0x35000
0x0000d2e8  add      x1, x1, #0xfb0   ; -> @"appView"
0x0000d2ec  mov      x0, x22
0x0000d2f0  bl       #0x9698   ; call _ABMissingSelector
0x0000d2f4  mov      x23, #0
0x0000d2f8  mov      x0, x23
0x0000d2fc  bl       #0x24818   ; call _objc_retain
0x0000d300  mov      x0, x23
0x0000d304  bl       #0x2480c   ; call _objc_release
0x0000d308  mov      x0, x22
0x0000d30c  bl       #0x2480c   ; call _objc_release
0x0000d310  adrp     x0, #0x35000
0x0000d314  add      x0, x0, #0xfd0   ; -> @"setDisplayMode:animationFactory:completion:"
0x0000d318  bl       #0x2441c   ; call _NSSelectorFromString
0x0000d31c  mov      x24, x0
0x0000d320  mov      x0, x23
0x0000d324  mov      x1, x24
0x0000d328  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000d32c  tbz      w0, #0, #0xd34c
0x0000d330  mov      x0, x23
0x0000d334  mov      x1, x24
0x0000d338  mov      w2, #4
0x0000d33c  mov      x3, x19
0x0000d340  mov      x4, #0
0x0000d344  bl       #0x247ac   ; call _objc_msgSend
0x0000d348  b        #0xd35c   ; call sub_d35c
0x0000d34c  adrp     x1, #0x35000
0x0000d350  add      x1, x1, #0xfd0   ; -> @"setDisplayMode:animationFactory:completion:"
0x0000d354  mov      x0, x23
0x0000d358  bl       #0x9698   ; call _ABMissingSelector
0x0000d35c  mov      x0, x22
0x0000d360  bl       #0x28140   ; objc_msgSend: view
0x0000d364  mov      x29, x29
0x0000d368  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000d36c  mov      x27, x0
0x0000d370  adrp     x8, #0x3e000
0x0000d374  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x0000d378  bl       #0x251a0   ; objc_msgSend: clearColor
0x0000d37c  mov      x29, x29
0x0000d380  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000d384  mov      x24, x0
0x0000d388  mov      x0, x27
0x0000d38c  mov      x2, x24
0x0000d390  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x0000d394  mov      x0, x24
0x0000d398  bl       #0x2480c   ; call _objc_release
0x0000d39c  ldr      x0, [sp, #0x80]
0x0000d3a0  bl       #0x24f60   ; objc_msgSend: box
0x0000d3a4  mov      x29, x29
0x0000d3a8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000d3ac  mov      x24, x0
