; ==== sub_d144 @ 0xd144..0xd2b4 (368 bytes) ====
0x0000d144  bl       #0x24758   ; call _objc_destroyWeak
0x0000d148  ldr      x0, [sp, #0xb0]
0x0000d14c  bl       #0x2480c   ; call _objc_release
0x0000d150  ldr      x0, [sp, #0xa8]
0x0000d154  bl       #0x2480c   ; call _objc_release
0x0000d158  b        #0xd16c   ; call sub_d16c
0x0000d15c  adrp     x1, #0x35000
0x0000d160  add      x1, x1, #0xeb0   ; -> @"setCompletionBlock:"
0x0000d164  mov      x0, x20
0x0000d168  bl       #0x9698   ; call _ABMissingSelector
0x0000d16c  mov      x0, x20
0x0000d170  bl       #0x2480c   ; call _objc_release
0x0000d174  mov      x0, x24
0x0000d178  mov      x2, x20
0x0000d17c  bl       #0x24b20   ; objc_msgSend: addObject:
0x0000d180  mov      x0, x20
0x0000d184  bl       #0x24818   ; call _objc_retain
0x0000d188  adrp     x0, #0x35000
0x0000d18c  add      x0, x0, #0xf50   ; -> @"begin"
0x0000d190  bl       #0x2441c   ; call _NSSelectorFromString
0x0000d194  mov      x19, x0
0x0000d198  mov      x0, x20
0x0000d19c  mov      x1, x19
0x0000d1a0  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000d1a4  tbz      w0, #0, #0xd1b8
0x0000d1a8  mov      x0, x20
0x0000d1ac  mov      x1, x19
0x0000d1b0  bl       #0x247ac   ; call _objc_msgSend
0x0000d1b4  b        #0xd1c8   ; call sub_d1c8
0x0000d1b8  adrp     x1, #0x35000
0x0000d1bc  add      x1, x1, #0xf50   ; -> @"begin"
0x0000d1c0  mov      x0, x20
0x0000d1c4  bl       #0x9698   ; call _ABMissingSelector
0x0000d1c8  mov      x0, x20
0x0000d1cc  bl       #0x2480c   ; call _objc_release
0x0000d1d0  mov      x0, x22
0x0000d1d4  bl       #0x24818   ; call _objc_retain
0x0000d1d8  adrp     x0, #0x35000
0x0000d1dc  add      x0, x0, #0xf70   ; -> @"_createSceneViewController"
0x0000d1e0  bl       #0x2441c   ; call _NSSelectorFromString
0x0000d1e4  mov      x19, x0
0x0000d1e8  mov      x0, x22
0x0000d1ec  mov      x1, x19
0x0000d1f0  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000d1f4  tbz      w0, #0, #0xd208
0x0000d1f8  mov      x0, x22
0x0000d1fc  mov      x1, x19
0x0000d200  bl       #0x247ac   ; call _objc_msgSend
0x0000d204  b        #0xd218   ; call sub_d218
0x0000d208  adrp     x1, #0x35000
0x0000d20c  add      x1, x1, #0xf70   ; -> @"_createSceneViewController"
0x0000d210  mov      x0, x22
0x0000d214  bl       #0x9698   ; call _ABMissingSelector
0x0000d218  mov      x0, x22
0x0000d21c  bl       #0x2480c   ; call _objc_release
0x0000d220  adrp     x0, #0x29000
0x0000d224  add      x0, x0, #0xd56   ; -> "SBApplicationSceneView"
0x0000d228  bl       #0x24788   ; call _objc_getClass
0x0000d22c  mov      x29, x29
0x0000d230  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000d234  mov      x23, x0
0x0000d238  adrp     x0, #0x35000
0x0000d23c  add      x0, x0, #0xf90   ; -> @"defaultDisplayModeAnimationFactory"
0x0000d240  bl       #0x2441c   ; call _NSSelectorFromString
0x0000d244  mov      x19, x0
0x0000d248  mov      x0, x23
0x0000d24c  mov      x1, x19
0x0000d250  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000d254  tbz      w0, #0, #0xd274
0x0000d258  mov      x0, x23
0x0000d25c  mov      x1, x19
0x0000d260  bl       #0x247ac   ; call _objc_msgSend
0x0000d264  mov      x29, x29
0x0000d268  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000d26c  mov      x19, x0
0x0000d270  b        #0xd288   ; call sub_d288
0x0000d274  adrp     x1, #0x35000
0x0000d278  add      x1, x1, #0xf90   ; -> @"defaultDisplayModeAnimationFactory"
0x0000d27c  mov      x0, x23
0x0000d280  bl       #0x9698   ; call _ABMissingSelector
0x0000d284  mov      x19, #0
0x0000d288  mov      x0, x19
0x0000d28c  bl       #0x24818   ; call _objc_retain
0x0000d290  mov      x0, x19
0x0000d294  bl       #0x2480c   ; call _objc_release
0x0000d298  mov      x0, x23
0x0000d29c  bl       #0x2480c   ; call _objc_release
0x0000d2a0  mov      x0, x22
0x0000d2a4  bl       #0x24818   ; call _objc_retain
0x0000d2a8  adrp     x0, #0x35000
0x0000d2ac  add      x0, x0, #0xfb0   ; -> @"appView"
0x0000d2b0  bl       #0x2441c   ; call _NSSelectorFromString
