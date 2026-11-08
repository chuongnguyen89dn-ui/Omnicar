; ==== sub_b004 @ 0xb004..0xb2bc (696 bytes) ====
0x0000b004  mov      x0, x22
0x0000b008  ldp      x29, x30, [sp, #0x60]
0x0000b00c  ldp      x20, x19, [sp, #0x50]
0x0000b010  ldp      x22, x21, [sp, #0x40]
0x0000b014  ldp      x24, x23, [sp, #0x30]
0x0000b018  ldp      x26, x25, [sp, #0x20]
0x0000b01c  ldp      x28, x27, [sp, #0x10]
0x0000b020  add      sp, sp, #0x70
0x0000b024  ret      
0x0000b028  bl       #0xb4e4   ; call sub_b4e4
0x0000b02c  mov      x29, x29
0x0000b030  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b034  mov      x22, x0
0x0000b038  adrp     x28, #0x3e000
0x0000b03c  cbz      x0, #0xb0f4
0x0000b040  adrp     x0, #0x2a000
0x0000b044  add      x0, x0, #0x217   ; -> "FBSDisplayConfiguration"
0x0000b048  bl       #0x24788   ; call _objc_getClass
0x0000b04c  bl       #0x2471c   ; call _objc_alloc
0x0000b050  mov      x23, x0
0x0000b054  adrp     x0, #0x36000
0x0000b058  add      x0, x0, #0x7f0   ; -> @"initWithCADisplay:isMainDisplay:"
0x0000b05c  bl       #0x2441c   ; call _NSSelectorFromString
0x0000b060  mov      x24, x0
0x0000b064  mov      x0, x23
0x0000b068  mov      x1, x24
0x0000b06c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000b070  tbz      w0, #0, #0xb128
0x0000b074  mov      x0, x23
0x0000b078  mov      x1, x24
0x0000b07c  mov      x2, x22
0x0000b080  mov      w3, #0
0x0000b084  bl       #0x247ac   ; call _objc_msgSend
0x0000b088  mov      x29, x29
0x0000b08c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b090  mov      x24, x0
0x0000b094  mov      x0, x23
0x0000b098  bl       #0x2480c   ; call _objc_release
0x0000b09c  cbz      x24, #0xb140
0x0000b0a0  adrp     x0, #0x2a000
0x0000b0a4  add      x0, x0, #0x277   ; -> "UIRootSceneWindow"
0x0000b0a8  bl       #0x24788   ; call _objc_getClass
0x0000b0ac  bl       #0x2471c   ; call _objc_alloc
0x0000b0b0  mov      x23, x0
0x0000b0b4  adrp     x0, #0x36000
0x0000b0b8  add      x0, x0, #0x830   ; -> @"initWithDisplayConfiguration:"
0x0000b0bc  bl       #0x2441c   ; call _NSSelectorFromString
0x0000b0c0  mov      x25, x0
0x0000b0c4  mov      x0, x23
0x0000b0c8  mov      x1, x25
0x0000b0cc  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000b0d0  tbz      w0, #0, #0xb34c
0x0000b0d4  mov      x0, x23
0x0000b0d8  mov      x1, x25
0x0000b0dc  mov      x2, x24
0x0000b0e0  bl       #0x247ac   ; call _objc_msgSend
0x0000b0e4  mov      x29, x29
0x0000b0e8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b0ec  mov      x25, x0
0x0000b0f0  b        #0xb360   ; call sub_b360
0x0000b0f4  ldr      x0, [x28, #0x290]   ; -> [class(NSString)]
0x0000b0f8  adrp     x2, #0x36000
0x0000b0fc  add      x2, x2, #0x7d0   ; -> @"khong tim thay CADisplay cua CarPlay"
0x0000b100  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000b104  mov      x29, x29
0x0000b108  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b10c  mov      x24, x0
0x0000b110  adrp     x0, #0x34000
0x0000b114  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000b118  mov      x1, x24
0x0000b11c  bl       #0x1dd30   ; call _OMCLogWrite
0x0000b120  mov      x23, #0
0x0000b124  b        #0xb17c   ; call sub_b17c
0x0000b128  adrp     x1, #0x36000
0x0000b12c  add      x1, x1, #0x7f0   ; -> @"initWithCADisplay:isMainDisplay:"
0x0000b130  mov      x0, x23
0x0000b134  bl       #0x9698   ; call _ABMissingSelector
0x0000b138  mov      x0, x23
0x0000b13c  bl       #0x2480c   ; call _objc_release
0x0000b140  ldr      x0, [x28, #0x290]   ; -> [class(NSString)]
0x0000b144  adrp     x2, #0x36000
0x0000b148  add      x2, x2, #0x810   ; -> @"khong tao duoc FBSDisplayConfiguration"
0x0000b14c  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000b150  mov      x29, x29
0x0000b154  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b158  mov      x25, x0
0x0000b15c  adrp     x0, #0x34000
0x0000b160  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000b164  mov      x1, x25
0x0000b168  bl       #0x1dd30   ; call _OMCLogWrite
0x0000b16c  mov      x24, #0
0x0000b170  mov      x23, #0
0x0000b174  mov      x0, x25
0x0000b178  bl       #0x2480c   ; call _objc_release
0x0000b17c  mov      x0, x24
0x0000b180  bl       #0x2480c   ; call _objc_release
0x0000b184  mov      x0, x22
0x0000b188  bl       #0x2480c   ; call _objc_release
0x0000b18c  cmp      x23, #0
0x0000b190  cset     w22, ne
0x0000b194  cbz      x23, #0xb340
0x0000b198  mov      x0, x23
0x0000b19c  bl       #0x24818   ; call _objc_retain
0x0000b1a0  mov      x0, x23
0x0000b1a4  bl       #0x2489c   ; call _object_getClass
0x0000b1a8  mov      x25, x0
0x0000b1ac  ldr      x24, [x28, #0x290]   ; -> [class(NSString)]
0x0000b1b0  bl       #0x2444c   ; call _NSStringFromClass
0x0000b1b4  mov      x29, x29
0x0000b1b8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b1bc  mov      x26, x0
0x0000b1c0  str      x0, [sp]
0x0000b1c4  adrp     x2, #0x36000
0x0000b1c8  add      x2, x2, #0x870   ; -> @"ABPassThrough_%@"
0x0000b1cc  mov      x0, x24
0x0000b1d0  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000b1d4  mov      x29, x29
0x0000b1d8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b1dc  mov      x24, x0
0x0000b1e0  mov      x0, x26
0x0000b1e4  bl       #0x2480c   ; call _objc_release
0x0000b1e8  mov      x0, x24
0x0000b1ec  bl       #0x24824   ; call _objc_retainAutorelease
0x0000b1f0  bl       #0x24a40   ; objc_msgSend: UTF8String
0x0000b1f4  bl       #0x24788   ; call _objc_getClass
0x0000b1f8  mov      x26, x0
0x0000b1fc  cbnz     x0, #0xb258
0x0000b200  mov      x0, x24
0x0000b204  bl       #0x24824   ; call _objc_retainAutorelease
0x0000b208  bl       #0x24a40   ; objc_msgSend: UTF8String
0x0000b20c  mov      x1, x0
0x0000b210  mov      x0, x25
0x0000b214  mov      x2, #0
0x0000b218  bl       #0x24728   ; call _objc_allocateClassPair
0x0000b21c  mov      x26, x0
0x0000b220  adrp     x8, #0x3d000
0x0000b224  ldr      x27, [x8, #0x2a0]   ; -> [@selector(hitTest:withEvent:)]
0x0000b228  mov      x0, x25
0x0000b22c  mov      x1, x27
0x0000b230  bl       #0x24524   ; call _class_getInstanceMethod
0x0000b234  bl       #0x246d4   ; call _method_getTypeEncoding
0x0000b238  mov      x3, x0
0x0000b23c  adrp     x2, #0x16000
0x0000b240  add      x2, x2, #0x7dc
0x0000b244  mov      x0, x26
0x0000b248  mov      x1, x27
0x0000b24c  bl       #0x244f4   ; call _class_addMethod
0x0000b250  mov      x0, x26
0x0000b254  bl       #0x24800   ; call _objc_registerClassPair
0x0000b258  mov      x0, x23
0x0000b25c  mov      x1, x26
0x0000b260  bl       #0x248a8   ; call _object_setClass
0x0000b264  mov      x0, x24
0x0000b268  bl       #0x2480c   ; call _objc_release
0x0000b26c  mov      x0, x23
0x0000b270  bl       #0x2480c   ; call _objc_release
0x0000b274  adrp     x8, #0x34000
0x0000b278  ldr      x8, [x8, #0x248]   ; -> [got:_UIWindowLevelStatusBar]
0x0000b27c  ldr      d0, [x8]   ; -> [got:___objc_personality_v0]
0x0000b280  mov      x8, #0x404e000000000000
0x0000b284  fmov     d1, x8
0x0000b288  fadd     d0, d0, d1
0x0000b28c  mov      x0, x23
0x0000b290  bl       #0x27aa0   ; objc_msgSend: setWindowLevel:
0x0000b294  adrp     x8, #0x3e000
0x0000b298  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x0000b29c  bl       #0x251a0   ; objc_msgSend: clearColor
0x0000b2a0  mov      x29, x29
0x0000b2a4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b2a8  mov      x24, x0
0x0000b2ac  mov      x0, x23
0x0000b2b0  mov      x2, x24
0x0000b2b4  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x0000b2b8  mov      x0, x24
