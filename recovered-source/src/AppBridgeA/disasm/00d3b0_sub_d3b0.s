; ==== sub_d3b0 @ 0xd3b0..0xd58c (476 bytes) ====
0x0000d3b0  mov      x2, x27
0x0000d3b4  mov      x3, #0
0x0000d3b8  bl       #0x25b60   ; objc_msgSend: insertSubview:atIndex:
0x0000d3bc  mov      x0, x24
0x0000d3c0  bl       #0x2480c   ; call _objc_release
0x0000d3c4  adrp     x1, #0x39000
0x0000d3c8  add      x1, x1, #0x450
0x0000d3cc  adrp     x2, #0x36000
0x0000d3d0  add      x2, x2, #0x30   ; -> @"primarySceneIdentifierForBundleIdentifier"
0x0000d3d4  ldr      x0, [sp, #0x58]
0x0000d3d8  bl       #0xd9b0   ; call sub_d9b0
0x0000d3dc  mov      x29, x29
0x0000d3e0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000d3e4  mov      x24, x0
0x0000d3e8  ldr      x0, [sp, #0x80]
0x0000d3ec  bl       #0x24d80   ; objc_msgSend: application
0x0000d3f0  mov      x29, x29
0x0000d3f4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000d3f8  mov      x25, x0
0x0000d3fc  ldp      x0, x3, [sp, #0x58]
0x0000d400  mov      x1, x24
0x0000d404  mov      x2, x25
0x0000d408  ldr      x4, [sp, #0x50]
0x0000d40c  bl       #0xdef0   ; call sub_def0
0x0000d410  mov      x29, x29
0x0000d414  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000d418  mov      x28, x0
0x0000d41c  mov      x0, x25
0x0000d420  bl       #0x2480c   ; call _objc_release
0x0000d424  ldr      x0, [x26, #0x290]
0x0000d428  bl       #0x247d0   ; call _objc_opt_class
0x0000d42c  mov      x1, x0
0x0000d430  mov      x0, x28
0x0000d434  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0000d438  tbz      w0, #0, #0xd538
0x0000d43c  cbz      x28, #0xd540
0x0000d440  adrp     x0, #0x29000
0x0000d444  add      x0, x0, #0xe65   ; -> "FBSceneMonitor"
0x0000d448  bl       #0x24788   ; call _objc_getClass
0x0000d44c  bl       #0x2471c   ; call _objc_alloc
0x0000d450  mov      x26, x0
0x0000d454  adrp     x0, #0x36000
0x0000d458  add      x0, x0, #0x50   ; -> @"initWithSceneID:"
0x0000d45c  bl       #0x2441c   ; call _NSSelectorFromString
0x0000d460  mov      x25, x0
0x0000d464  mov      x0, x26
0x0000d468  mov      x1, x25
0x0000d46c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000d470  tbz      w0, #0, #0xd494
0x0000d474  mov      x0, x26
0x0000d478  mov      x1, x25
0x0000d47c  mov      x2, x28
0x0000d480  bl       #0x247ac   ; call _objc_msgSend
0x0000d484  mov      x29, x29
0x0000d488  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000d48c  mov      x25, x0
0x0000d490  b        #0xd4a8   ; call sub_d4a8
0x0000d494  adrp     x1, #0x36000
0x0000d498  add      x1, x1, #0x50   ; -> @"initWithSceneID:"
0x0000d49c  mov      x0, x26
0x0000d4a0  bl       #0x9698   ; call _ABMissingSelector
0x0000d4a4  mov      x25, #0
0x0000d4a8  mov      x0, x25
0x0000d4ac  bl       #0x24818   ; call _objc_retain
0x0000d4b0  mov      x0, x25
0x0000d4b4  bl       #0x2480c   ; call _objc_release
0x0000d4b8  mov      x0, x26
0x0000d4bc  bl       #0x2480c   ; call _objc_release
0x0000d4c0  ldr      x26, [sp, #0x80]
0x0000d4c4  mov      x0, x26
0x0000d4c8  mov      x2, x25
0x0000d4cc  bl       #0x276a0   ; objc_msgSend: setSceneMonitor:
0x0000d4d0  mov      x0, x25
0x0000d4d4  bl       #0x2480c   ; call _objc_release
0x0000d4d8  mov      x0, x26
0x0000d4dc  bl       #0x26a40   ; objc_msgSend: sceneMonitor
0x0000d4e0  mov      x29, x29
0x0000d4e4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000d4e8  mov      x26, x0
0x0000d4ec  adrp     x0, #0x36000
0x0000d4f0  add      x0, x0, #0x70   ; -> @"setDelegate:"
0x0000d4f4  bl       #0x2441c   ; call _NSSelectorFromString
0x0000d4f8  mov      x25, x0
0x0000d4fc  mov      x0, x26
0x0000d500  mov      x1, x25
0x0000d504  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000d508  tbz      w0, #0, #0xd520
0x0000d50c  mov      x0, x26
0x0000d510  mov      x1, x25
0x0000d514  ldr      x2, [sp, #0x30]
0x0000d518  bl       #0x247ac   ; call _objc_msgSend
0x0000d51c  b        #0xd530   ; call sub_d530
0x0000d520  adrp     x1, #0x36000
0x0000d524  add      x1, x1, #0x70   ; -> @"setDelegate:"
0x0000d528  mov      x0, x26
0x0000d52c  bl       #0x9698   ; call _ABMissingSelector
0x0000d530  mov      x0, x26
0x0000d534  bl       #0x2480c   ; call _objc_release
0x0000d538  mov      x0, x28
0x0000d53c  bl       #0x2480c   ; call _objc_release
0x0000d540  mov      x0, x24
0x0000d544  bl       #0x2480c   ; call _objc_release
0x0000d548  mov      x0, x27
0x0000d54c  bl       #0x2480c   ; call _objc_release
0x0000d550  mov      x0, x23
0x0000d554  bl       #0x2480c   ; call _objc_release
0x0000d558  mov      x0, x19
0x0000d55c  bl       #0x2480c   ; call _objc_release
0x0000d560  sub      x0, x29, #0x68
0x0000d564  bl       #0x24758   ; call _objc_destroyWeak
0x0000d568  sub      x0, x29, #0x60
0x0000d56c  bl       #0x24758   ; call _objc_destroyWeak
0x0000d570  ldr      x0, [sp, #0x28]
0x0000d574  bl       #0x2480c   ; call _objc_release
0x0000d578  mov      x0, x20
0x0000d57c  bl       #0x2480c   ; call _objc_release
0x0000d580  mov      x0, x22
0x0000d584  bl       #0x2480c   ; call _objc_release
0x0000d588  ldr      x0, [sp, #0x78]
