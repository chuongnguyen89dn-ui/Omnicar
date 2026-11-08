; ==== sub_c274 @ 0xc274..0xcc7c (2568 bytes) ====
0x0000c274  stp      x29, x30, [sp, #0x10]
0x0000c278  add      x29, sp, #0x10
0x0000c27c  ldr      x0, [x0, #0x20]
0x0000c280  bl       #0x24f60   ; objc_msgSend: box
0x0000c284  mov      x29, x29
0x0000c288  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c28c  mov      x19, x0
0x0000c290  fmov     d0, #1.00000000
0x0000c294  bl       #0x26b40   ; objc_msgSend: setAlpha:
0x0000c298  mov      x0, x19
0x0000c29c  ldp      x29, x30, [sp, #0x10]
0x0000c2a0  ldp      x20, x19, [sp], #0x20
0x0000c2a4  b        #0x2480c   ; call _objc_release
0x0000c2a8  mov      x20, x0
0x0000c2ac  mov      x0, x19
0x0000c2b0  bl       #0x2480c   ; call _objc_release
0x0000c2b4  mov      x0, x20
0x0000c2b8  bl       #0x24470   ; call __Unwind_Resume
0x0000c2bc  sub      sp, sp, #0x140
0x0000c2c0  stp      x28, x27, [sp, #0xe0]
0x0000c2c4  stp      x26, x25, [sp, #0xf0]
0x0000c2c8  stp      x24, x23, [sp, #0x100]
0x0000c2cc  stp      x22, x21, [sp, #0x110]
0x0000c2d0  stp      x20, x19, [sp, #0x120]
0x0000c2d4  stp      x29, x30, [sp, #0x130]
0x0000c2d8  add      x29, sp, #0x130
0x0000c2dc  mov      x19, x2
0x0000c2e0  str      x0, [sp, #0x30]
0x0000c2e4  mov      x0, x2
0x0000c2e8  bl       #0x24818   ; call _objc_retain
0x0000c2ec  str      x19, [sp, #0x80]
0x0000c2f0  mov      x0, x19
0x0000c2f4  bl       #0x25020   ; objc_msgSend: bundleID
0x0000c2f8  mov      x29, x29
0x0000c2fc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c300  str      x0, [sp, #0x60]
0x0000c304  adrp     x0, #0x29000
0x0000c308  add      x0, x0, #0x878   ; -> "SBApplicationController"
0x0000c30c  bl       #0x24788   ; call _objc_getClass
0x0000c310  mov      x29, x29
0x0000c314  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c318  mov      x20, x0
0x0000c31c  adrp     x0, #0x35000
0x0000c320  add      x0, x0, #0xbd0   ; -> @"sharedInstance"
0x0000c324  bl       #0x2441c   ; call _NSSelectorFromString
0x0000c328  mov      x19, x0
0x0000c32c  mov      x0, x20
0x0000c330  mov      x1, x19
0x0000c334  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000c338  tbz      w0, #0, #0xc358
0x0000c33c  mov      x0, x20
0x0000c340  mov      x1, x19
0x0000c344  bl       #0x247ac   ; call _objc_msgSend
0x0000c348  mov      x29, x29
0x0000c34c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c350  mov      x19, x0
0x0000c354  b        #0xc36c   ; call sub_c36c
0x0000c358  adrp     x1, #0x35000
0x0000c35c  add      x1, x1, #0xbd0   ; -> @"sharedInstance"
0x0000c360  mov      x0, x20
0x0000c364  bl       #0x9698   ; call _ABMissingSelector
0x0000c368  mov      x19, #0
0x0000c36c  mov      x0, x19
0x0000c370  bl       #0x24818   ; call _objc_retain
0x0000c374  mov      x0, x19
0x0000c378  bl       #0x2480c   ; call _objc_release
0x0000c37c  mov      x0, x20
0x0000c380  bl       #0x2480c   ; call _objc_release
0x0000c384  adrp     x0, #0x35000
0x0000c388  add      x0, x0, #0xbf0   ; -> @"applicationWithBundleIdentifier:"
0x0000c38c  bl       #0x2441c   ; call _NSSelectorFromString
0x0000c390  mov      x20, x0
0x0000c394  mov      x0, x19
0x0000c398  mov      x1, x20
0x0000c39c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000c3a0  tbz      w0, #0, #0xc3c4
0x0000c3a4  mov      x0, x19
0x0000c3a8  mov      x1, x20
0x0000c3ac  ldr      x2, [sp, #0x60]
0x0000c3b0  bl       #0x247ac   ; call _objc_msgSend
0x0000c3b4  mov      x29, x29
0x0000c3b8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c3bc  mov      x20, x0
0x0000c3c0  b        #0xc3d8   ; call sub_c3d8
0x0000c3c4  adrp     x1, #0x35000
0x0000c3c8  add      x1, x1, #0xbf0   ; -> @"applicationWithBundleIdentifier:"
0x0000c3cc  mov      x0, x19
0x0000c3d0  bl       #0x9698   ; call _ABMissingSelector
0x0000c3d4  mov      x20, #0
0x0000c3d8  mov      x0, x20
0x0000c3dc  bl       #0x24818   ; call _objc_retain
0x0000c3e0  mov      x0, x20
0x0000c3e4  bl       #0x2480c   ; call _objc_release
0x0000c3e8  mov      x0, x19
0x0000c3ec  bl       #0x2480c   ; call _objc_release
0x0000c3f0  ldr      x19, [sp, #0x80]
0x0000c3f4  mov      x0, x19
0x0000c3f8  mov      x2, x20
0x0000c3fc  bl       #0x26bc0   ; objc_msgSend: setApplication:
0x0000c400  mov      x0, x20
0x0000c404  bl       #0x2480c   ; call _objc_release
0x0000c408  mov      x0, x19
0x0000c40c  bl       #0x24d80   ; objc_msgSend: application
0x0000c410  mov      x29, x29
0x0000c414  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c418  mov      x19, x0
0x0000c41c  adrp     x26, #0x3e000
0x0000c420  adrp     x25, #0x29000
0x0000c424  add      x25, x25, #0x8ec   ; -> "Features/AppBridge/ABHost.mm"
0x0000c428  adrp     x24, #0x3e000
0x0000c42c  cbz      x0, #0xc44c
0x0000c430  adrp     x0, #0x29000
0x0000c434  add      x0, x0, #0x8c0   ; -> "SBApplication"
0x0000c438  bl       #0x24788   ; call _objc_getClass
0x0000c43c  mov      x1, x0
0x0000c440  mov      x0, x19
0x0000c444  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0000c448  tbnz     w0, #0, #0xc4b0
0x0000c44c  adrp     x21, #0x29000
0x0000c450  add      x21, x21, #0x8c0   ; -> "SBApplication"
0x0000c454  ldr      x0, [x26, #0x290]   ; -> [class(NSString)]
0x0000c458  mov      w8, #0x1b5
0x0000c45c  stp      x25, x8, [sp, #0x10]
0x0000c460  stp      x21, x19, [sp]
0x0000c464  adrp     x2, #0x35000
0x0000c468  add      x2, x2, #0xc10   ; -> @"UNEXPECTED %s: got %@ (%s:%d)"
0x0000c46c  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000c470  mov      x29, x29
0x0000c474  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c478  mov      x20, x0
0x0000c47c  adrp     x0, #0x34000
0x0000c480  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000c484  mov      x1, x20
0x0000c488  bl       #0x1dd30   ; call _OMCLogWrite
0x0000c48c  mov      x0, x20
0x0000c490  bl       #0x2480c   ; call _objc_release
0x0000c494  ldr      x0, [x24, #0x338]   ; -> [class(NSException)]
0x0000c498  adrp     x2, #0x34000
0x0000c49c  add      x2, x2, #0xef0   ; -> @"AppBridge"
0x0000c4a0  stp      x21, x19, [sp]
0x0000c4a4  adrp     x3, #0x35000
0x0000c4a8  add      x3, x3, #0xc30   ; -> @"expected %s got %@"
0x0000c4ac  bl       #0x26700   ; objc_msgSend: raise:format:
0x0000c4b0  mov      x0, x19
0x0000c4b4  bl       #0x24818   ; call _objc_retain
0x0000c4b8  mov      x0, x19
0x0000c4bc  bl       #0x2480c   ; call _objc_release
0x0000c4c0  mov      x0, x19
0x0000c4c4  bl       #0x2480c   ; call _objc_release
0x0000c4c8  adrp     x0, #0x29000
0x0000c4cc  add      x0, x0, #0x91c   ; -> "SBSceneManagerCoordinator"
0x0000c4d0  bl       #0x24788   ; call _objc_getClass
0x0000c4d4  mov      x29, x29
0x0000c4d8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c4dc  mov      x19, x0
0x0000c4e0  adrp     x0, #0x35000
0x0000c4e4  add      x0, x0, #0xc50   ; -> @"mainDisplaySceneManager"
0x0000c4e8  bl       #0x2441c   ; call _NSSelectorFromString
0x0000c4ec  mov      x20, x0
0x0000c4f0  mov      x0, x19
0x0000c4f4  mov      x1, x20
0x0000c4f8  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000c4fc  tbz      w0, #0, #0xc51c
0x0000c500  mov      x0, x19
0x0000c504  mov      x1, x20
0x0000c508  bl       #0x247ac   ; call _objc_msgSend
0x0000c50c  mov      x29, x29
0x0000c510  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c514  mov      x21, x0
0x0000c518  b        #0xc530   ; call sub_c530
0x0000c51c  adrp     x1, #0x35000
0x0000c520  add      x1, x1, #0xc50   ; -> @"mainDisplaySceneManager"
0x0000c524  mov      x0, x19
0x0000c528  bl       #0x9698   ; call _ABMissingSelector
0x0000c52c  mov      x21, #0
0x0000c530  mov      x0, x21
0x0000c534  bl       #0x24818   ; call _objc_retain
0x0000c538  mov      x0, x21
0x0000c53c  bl       #0x2480c   ; call _objc_release
0x0000c540  mov      x0, x19
0x0000c544  bl       #0x2480c   ; call _objc_release
0x0000c548  mov      x0, x21
0x0000c54c  bl       #0x24818   ; call _objc_retain
0x0000c550  cbz      x21, #0xc570
0x0000c554  adrp     x0, #0x29000
0x0000c558  add      x0, x0, #0x94e   ; -> "SBMainDisplaySceneManager"
0x0000c55c  bl       #0x24788   ; call _objc_getClass
0x0000c560  mov      x1, x0
0x0000c564  mov      x0, x21
0x0000c568  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0000c56c  tbnz     w0, #0, #0xc5d4
0x0000c570  adrp     x20, #0x29000
0x0000c574  add      x20, x20, #0x94e   ; -> "SBMainDisplaySceneManager"
0x0000c578  ldr      x0, [x26, #0x290]   ; -> [class(NSString)]
0x0000c57c  mov      w8, #0x1b8
0x0000c580  stp      x25, x8, [sp, #0x10]
0x0000c584  stp      x20, x21, [sp]
0x0000c588  adrp     x2, #0x35000
0x0000c58c  add      x2, x2, #0xc10   ; -> @"UNEXPECTED %s: got %@ (%s:%d)"
0x0000c590  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000c594  mov      x29, x29
0x0000c598  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c59c  mov      x19, x0
0x0000c5a0  adrp     x0, #0x34000
0x0000c5a4  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000c5a8  mov      x1, x19
0x0000c5ac  bl       #0x1dd30   ; call _OMCLogWrite
0x0000c5b0  mov      x0, x19
0x0000c5b4  bl       #0x2480c   ; call _objc_release
0x0000c5b8  ldr      x0, [x24, #0x338]   ; -> [class(NSException)]
0x0000c5bc  adrp     x2, #0x34000
0x0000c5c0  add      x2, x2, #0xef0   ; -> @"AppBridge"
0x0000c5c4  stp      x20, x21, [sp]
0x0000c5c8  adrp     x3, #0x35000
0x0000c5cc  add      x3, x3, #0xc30   ; -> @"expected %s got %@"
0x0000c5d0  bl       #0x26700   ; objc_msgSend: raise:format:
0x0000c5d4  mov      x0, x21
0x0000c5d8  bl       #0x24818   ; call _objc_retain
0x0000c5dc  mov      x0, x21
0x0000c5e0  bl       #0x2480c   ; call _objc_release
0x0000c5e4  mov      x0, x21
0x0000c5e8  bl       #0x2480c   ; call _objc_release
0x0000c5ec  adrp     x1, #0x39000
0x0000c5f0  add      x1, x1, #0x420
0x0000c5f4  adrp     x2, #0x35000
0x0000c5f8  add      x2, x2, #0xc70   ; -> @"layoutStateManager"
0x0000c5fc  mov      x0, x21
0x0000c600  bl       #0xd9b0   ; call sub_d9b0
0x0000c604  mov      x29, x29
0x0000c608  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c60c  str      x0, [sp, #0x38]
0x0000c610  cbz      x0, #0xc658
0x0000c614  mov      x19, x0
0x0000c618  mov      x0, x21
0x0000c61c  bl       #0x24818   ; call _objc_retain
0x0000c620  mov      x0, x19
0x0000c624  bl       #0x2441c   ; call _NSSelectorFromString
0x0000c628  mov      x19, x0
0x0000c62c  mov      x0, x21
0x0000c630  mov      x1, x19
0x0000c634  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000c638  tbz      w0, #0, #0xc660
0x0000c63c  mov      x0, x21
0x0000c640  mov      x1, x19
0x0000c644  bl       #0x247ac   ; call _objc_msgSend
0x0000c648  mov      x29, x29
0x0000c64c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c650  mov      x19, x0
0x0000c654  b        #0xc670   ; call sub_c670
0x0000c658  str      xzr, [sp, #0x58]
0x0000c65c  b        #0xc69c   ; call sub_c69c
0x0000c660  mov      x0, x21
0x0000c664  ldr      x1, [sp, #0x38]
0x0000c668  bl       #0x9698   ; call _ABMissingSelector
0x0000c66c  mov      x19, #0
0x0000c670  mov      x0, x19
0x0000c674  bl       #0x24818   ; call _objc_retain
0x0000c678  mov      x0, x19
0x0000c67c  bl       #0x2480c   ; call _objc_release
0x0000c680  mov      x0, x21
0x0000c684  bl       #0x2480c   ; call _objc_release
0x0000c688  mov      x0, x19
0x0000c68c  bl       #0x24818   ; call _objc_retain
0x0000c690  str      x19, [sp, #0x58]
0x0000c694  mov      x0, x19
0x0000c698  bl       #0x2480c   ; call _objc_release
0x0000c69c  mov      x0, x21
0x0000c6a0  bl       #0x24818   ; call _objc_retain
0x0000c6a4  adrp     x0, #0x35000
0x0000c6a8  add      x0, x0, #0xcb0   ; -> @"displayIdentity"
0x0000c6ac  bl       #0x2441c   ; call _NSSelectorFromString
0x0000c6b0  mov      x19, x0
0x0000c6b4  mov      x0, x21
0x0000c6b8  mov      x1, x19
0x0000c6bc  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000c6c0  tbz      w0, #0, #0xc6e0
0x0000c6c4  mov      x0, x21
0x0000c6c8  mov      x1, x19
0x0000c6cc  bl       #0x247ac   ; call _objc_msgSend
0x0000c6d0  mov      x29, x29
0x0000c6d4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c6d8  mov      x22, x0
0x0000c6dc  b        #0xc6f4   ; call sub_c6f4
0x0000c6e0  adrp     x1, #0x35000
0x0000c6e4  add      x1, x1, #0xcb0   ; -> @"displayIdentity"
0x0000c6e8  mov      x0, x21
0x0000c6ec  bl       #0x9698   ; call _ABMissingSelector
0x0000c6f0  mov      x22, #0
0x0000c6f4  mov      x0, x22
0x0000c6f8  bl       #0x24818   ; call _objc_retain
0x0000c6fc  mov      x0, x22
0x0000c700  bl       #0x2480c   ; call _objc_release
0x0000c704  mov      x0, x21
0x0000c708  bl       #0x2480c   ; call _objc_release
0x0000c70c  mov      x0, x22
0x0000c710  bl       #0x24818   ; call _objc_retain
0x0000c714  str      x22, [sp, #0x50]
0x0000c718  cbz      x22, #0xc738
0x0000c71c  adrp     x0, #0x29000
0x0000c720  add      x0, x0, #0x99f   ; -> "FBSDisplayIdentity"
0x0000c724  bl       #0x24788   ; call _objc_getClass
0x0000c728  mov      x1, x0
0x0000c72c  mov      x0, x22
0x0000c730  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0000c734  tbnz     w0, #0, #0xc79c
0x0000c738  adrp     x20, #0x29000
0x0000c73c  add      x20, x20, #0x99f   ; -> "FBSDisplayIdentity"
0x0000c740  ldr      x0, [x26, #0x290]   ; -> [class(NSString)]
0x0000c744  mov      w8, #0x1bf
0x0000c748  stp      x25, x8, [sp, #0x10]
0x0000c74c  stp      x20, x22, [sp]
0x0000c750  adrp     x2, #0x35000
0x0000c754  add      x2, x2, #0xc10   ; -> @"UNEXPECTED %s: got %@ (%s:%d)"
0x0000c758  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000c75c  mov      x29, x29
0x0000c760  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c764  mov      x19, x0
0x0000c768  adrp     x0, #0x34000
0x0000c76c  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000c770  mov      x1, x19
0x0000c774  bl       #0x1dd30   ; call _OMCLogWrite
0x0000c778  mov      x0, x19
0x0000c77c  bl       #0x2480c   ; call _objc_release
0x0000c780  ldr      x0, [x24, #0x338]   ; -> [class(NSException)]
0x0000c784  adrp     x2, #0x34000
0x0000c788  add      x2, x2, #0xef0   ; -> @"AppBridge"
0x0000c78c  stp      x20, x22, [sp]
0x0000c790  adrp     x3, #0x35000
0x0000c794  add      x3, x3, #0xc30   ; -> @"expected %s got %@"
0x0000c798  bl       #0x26700   ; objc_msgSend: raise:format:
0x0000c79c  mov      x0, x22
0x0000c7a0  bl       #0x24818   ; call _objc_retain
0x0000c7a4  mov      x0, x22
0x0000c7a8  bl       #0x2480c   ; call _objc_release
0x0000c7ac  mov      x0, x22
0x0000c7b0  bl       #0x2480c   ; call _objc_release
0x0000c7b4  adrp     x1, #0x39000
0x0000c7b8  add      x1, x1, #0x438
0x0000c7bc  adrp     x2, #0x35000
0x0000c7c0  add      x2, x2, #0xd30   ; -> @"sceneIdentityForApplication"
0x0000c7c4  mov      x0, x21
0x0000c7c8  bl       #0xd9b0   ; call sub_d9b0
0x0000c7cc  mov      x29, x29
0x0000c7d0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c7d4  str      x0, [sp, #0x48]
0x0000c7d8  ldr      x0, [sp, #0x80]
0x0000c7dc  bl       #0x24d80   ; objc_msgSend: application
0x0000c7e0  mov      x29, x29
0x0000c7e4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c7e8  mov      x19, x0
0x0000c7ec  mov      x0, x21
0x0000c7f0  ldr      x1, [sp, #0x48]
0x0000c7f4  mov      x2, x19
0x0000c7f8  ldr      x3, [sp, #0x60]
0x0000c7fc  mov      x4, x22
0x0000c800  bl       #0xdef0   ; call sub_def0
0x0000c804  mov      x29, x29
0x0000c808  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c80c  mov      x23, x0
0x0000c810  mov      x0, x19
0x0000c814  bl       #0x2480c   ; call _objc_release
0x0000c818  cbz      x23, #0xc844
0x0000c81c  mov      x0, x23
0x0000c820  bl       #0x24818   ; call _objc_retain
0x0000c824  adrp     x0, #0x29000
0x0000c828  add      x0, x0, #0xa95   ; -> "FBSSceneIdentity"
0x0000c82c  bl       #0x24788   ; call _objc_getClass
0x0000c830  mov      x1, x0
0x0000c834  mov      x0, x23
0x0000c838  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0000c83c  tbz      w0, #0, #0xc91c
0x0000c840  b        #0xc980   ; call sub_c980
0x0000c844  ldr      x0, [sp, #0x80]
0x0000c848  bl       #0x24d80   ; objc_msgSend: application
0x0000c84c  mov      x29, x29
0x0000c850  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c854  mov      x19, x0
0x0000c858  adrp     x0, #0x35000
0x0000c85c  add      x0, x0, #0xd50   ; -> @"sceneIdentityForRole:"
0x0000c860  bl       #0x2441c   ; call _NSSelectorFromString
0x0000c864  mov      x1, x0
0x0000c868  mov      x0, x19
0x0000c86c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000c870  mov      x20, x0
0x0000c874  mov      x0, x19
0x0000c878  bl       #0x2480c   ; call _objc_release
0x0000c87c  tbz      w20, #0, #0xc8dc
0x0000c880  ldr      x0, [sp, #0x80]
0x0000c884  bl       #0x24d80   ; objc_msgSend: application
0x0000c888  mov      x29, x29
0x0000c88c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c890  mov      x19, x0
0x0000c894  adrp     x0, #0x35000
0x0000c898  add      x0, x0, #0xd50   ; -> @"sceneIdentityForRole:"
0x0000c89c  bl       #0x2441c   ; call _NSSelectorFromString
0x0000c8a0  mov      x20, x0
0x0000c8a4  mov      x0, x19
0x0000c8a8  mov      x1, x20
0x0000c8ac  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000c8b0  tbz      w0, #0, #0xc8e4
0x0000c8b4  adrp     x8, #0x34000
0x0000c8b8  ldr      x8, [x8, #0x250]   ; -> [got:_UIWindowSceneSessionRoleApplication]
0x0000c8bc  ldr      x2, [x8]   ; -> [got:___objc_personality_v0]
0x0000c8c0  mov      x0, x19
0x0000c8c4  mov      x1, x20
0x0000c8c8  bl       #0x247ac   ; call _objc_msgSend
0x0000c8cc  mov      x29, x29
0x0000c8d0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c8d4  mov      x23, x0
0x0000c8d8  b        #0xc8f8   ; call sub_c8f8
0x0000c8dc  mov      x23, #0
0x0000c8e0  b        #0xc91c   ; call sub_c91c
0x0000c8e4  adrp     x1, #0x35000
0x0000c8e8  add      x1, x1, #0xd50   ; -> @"sceneIdentityForRole:"
0x0000c8ec  mov      x0, x19
0x0000c8f0  bl       #0x9698   ; call _ABMissingSelector
0x0000c8f4  mov      x23, #0
0x0000c8f8  mov      x0, x23
0x0000c8fc  bl       #0x24818   ; call _objc_retain
0x0000c900  mov      x0, x23
0x0000c904  bl       #0x2480c   ; call _objc_release
0x0000c908  mov      x0, x19
0x0000c90c  bl       #0x2480c   ; call _objc_release
0x0000c910  mov      x0, x23
0x0000c914  bl       #0x24818   ; call _objc_retain
0x0000c918  cbnz     x23, #0xc824
0x0000c91c  adrp     x20, #0x29000
0x0000c920  add      x20, x20, #0xa95   ; -> "FBSSceneIdentity"
0x0000c924  ldr      x0, [x26, #0x290]   ; -> [class(NSString)]
0x0000c928  mov      w8, #0x1c7
0x0000c92c  stp      x25, x8, [sp, #0x10]
0x0000c930  stp      x20, x23, [sp]
0x0000c934  adrp     x2, #0x35000
0x0000c938  add      x2, x2, #0xc10   ; -> @"UNEXPECTED %s: got %@ (%s:%d)"
0x0000c93c  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000c940  mov      x29, x29
0x0000c944  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c948  mov      x19, x0
0x0000c94c  adrp     x0, #0x34000
0x0000c950  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000c954  mov      x1, x19
0x0000c958  bl       #0x1dd30   ; call _OMCLogWrite
0x0000c95c  mov      x0, x19
0x0000c960  bl       #0x2480c   ; call _objc_release
0x0000c964  ldr      x0, [x24, #0x338]   ; -> [class(NSException)]
0x0000c968  adrp     x2, #0x34000
0x0000c96c  add      x2, x2, #0xef0   ; -> @"AppBridge"
0x0000c970  stp      x20, x23, [sp]
0x0000c974  adrp     x3, #0x35000
0x0000c978  add      x3, x3, #0xc30   ; -> @"expected %s got %@"
0x0000c97c  bl       #0x26700   ; objc_msgSend: raise:format:
0x0000c980  mov      x0, x23
0x0000c984  bl       #0x24818   ; call _objc_retain
0x0000c988  mov      x0, x23
0x0000c98c  bl       #0x2480c   ; call _objc_release
0x0000c990  mov      x0, x23
0x0000c994  bl       #0x2480c   ; call _objc_release
0x0000c998  adrp     x19, #0x29000
0x0000c99c  add      x19, x19, #0xaa6   ; -> "SBApplicationSceneHandleRequest"
0x0000c9a0  mov      x0, x19
0x0000c9a4  bl       #0x24788   ; call _objc_getClass
0x0000c9a8  mov      x29, x29
0x0000c9ac  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c9b0  mov      x20, x0
0x0000c9b4  str      x23, [sp, #0x40]
0x0000c9b8  adrp     x0, #0x35000
0x0000c9bc  add      x0, x0, #0xd70   ; -> @"defaultRequestForApplication:sceneIdentity:displayIdentity:"
0x0000c9c0  bl       #0x2441c   ; call _NSSelectorFromString
0x0000c9c4  mov      x22, x0
0x0000c9c8  mov      x0, x20
0x0000c9cc  mov      x1, x22
0x0000c9d0  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000c9d4  tbz      w0, #0, #0xca1c
0x0000c9d8  ldr      x0, [sp, #0x80]
0x0000c9dc  bl       #0x24d80   ; objc_msgSend: application
0x0000c9e0  mov      x29, x29
0x0000c9e4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c9e8  mov      x23, x0
0x0000c9ec  mov      x0, x20
0x0000c9f0  mov      x1, x22
0x0000c9f4  mov      x2, x23
0x0000c9f8  ldr      x3, [sp, #0x40]
0x0000c9fc  ldr      x4, [sp, #0x50]
0x0000ca00  bl       #0x247ac   ; call _objc_msgSend
0x0000ca04  mov      x29, x29
0x0000ca08  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ca0c  mov      x22, x0
0x0000ca10  mov      x0, x23
0x0000ca14  bl       #0x2480c   ; call _objc_release
0x0000ca18  b        #0xca30   ; call sub_ca30
0x0000ca1c  adrp     x1, #0x35000
0x0000ca20  add      x1, x1, #0xd70   ; -> @"defaultRequestForApplication:sceneIdentity:displayIdentity:"
0x0000ca24  mov      x0, x20
0x0000ca28  bl       #0x9698   ; call _ABMissingSelector
0x0000ca2c  mov      x22, #0
0x0000ca30  mov      x0, x22
0x0000ca34  bl       #0x24818   ; call _objc_retain
0x0000ca38  mov      x0, x22
0x0000ca3c  bl       #0x2480c   ; call _objc_release
0x0000ca40  mov      x0, x20
0x0000ca44  bl       #0x2480c   ; call _objc_release
0x0000ca48  mov      x0, x22
0x0000ca4c  bl       #0x24818   ; call _objc_retain
0x0000ca50  str      x22, [sp, #0x70]
0x0000ca54  cbz      x22, #0xca74
0x0000ca58  adrp     x0, #0x29000
0x0000ca5c  add      x0, x0, #0xaa6   ; -> "SBApplicationSceneHandleRequest"
0x0000ca60  bl       #0x24788   ; call _objc_getClass
0x0000ca64  mov      x1, x0
0x0000ca68  ldr      x0, [sp, #0x70]
0x0000ca6c  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0000ca70  tbnz     w0, #0, #0xcad8
0x0000ca74  ldr      x0, [x26, #0x290]   ; -> [class(NSString)]
0x0000ca78  mov      w8, #0x1cb
0x0000ca7c  stp      x25, x8, [sp, #0x10]
0x0000ca80  ldr      x8, [sp, #0x70]
0x0000ca84  stp      x19, x8, [sp]
0x0000ca88  adrp     x2, #0x35000
0x0000ca8c  add      x2, x2, #0xc10   ; -> @"UNEXPECTED %s: got %@ (%s:%d)"
0x0000ca90  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000ca94  mov      x29, x29
0x0000ca98  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ca9c  mov      x20, x0
0x0000caa0  adrp     x0, #0x34000
0x0000caa4  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000caa8  mov      x1, x20
0x0000caac  bl       #0x1dd30   ; call _OMCLogWrite
0x0000cab0  mov      x0, x20
0x0000cab4  bl       #0x2480c   ; call _objc_release
0x0000cab8  ldr      x0, [x24, #0x338]   ; -> [class(NSException)]
0x0000cabc  adrp     x2, #0x34000
0x0000cac0  add      x2, x2, #0xef0   ; -> @"AppBridge"
0x0000cac4  ldr      x8, [sp, #0x70]
0x0000cac8  stp      x19, x8, [sp]
0x0000cacc  adrp     x3, #0x35000
0x0000cad0  add      x3, x3, #0xc30   ; -> @"expected %s got %@"
0x0000cad4  bl       #0x26700   ; objc_msgSend: raise:format:
0x0000cad8  ldr      x19, [sp, #0x70]
0x0000cadc  mov      x0, x19
0x0000cae0  bl       #0x24818   ; call _objc_retain
0x0000cae4  mov      x0, x19
0x0000cae8  bl       #0x2480c   ; call _objc_release
0x0000caec  mov      x0, x19
0x0000caf0  bl       #0x2480c   ; call _objc_release
0x0000caf4  mov      x0, x21
0x0000caf8  bl       #0x24818   ; call _objc_retain
0x0000cafc  adrp     x0, #0x35000
0x0000cb00  add      x0, x0, #0xd90   ; -> @"fetchOrCreateApplicationSceneHandleForRequest:"
0x0000cb04  bl       #0x2441c   ; call _NSSelectorFromString
0x0000cb08  mov      x19, x0
0x0000cb0c  mov      x0, x21
0x0000cb10  mov      x1, x19
0x0000cb14  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000cb18  tbz      w0, #0, #0xcb3c
0x0000cb1c  mov      x0, x21
0x0000cb20  mov      x1, x19
0x0000cb24  ldr      x2, [sp, #0x70]
0x0000cb28  bl       #0x247ac   ; call _objc_msgSend
0x0000cb2c  mov      x29, x29
0x0000cb30  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000cb34  mov      x19, x0
0x0000cb38  b        #0xcb50   ; call sub_cb50
0x0000cb3c  adrp     x1, #0x35000
0x0000cb40  add      x1, x1, #0xd90   ; -> @"fetchOrCreateApplicationSceneHandleForRequest:"
0x0000cb44  mov      x0, x21
0x0000cb48  bl       #0x9698   ; call _ABMissingSelector
0x0000cb4c  mov      x19, #0
0x0000cb50  mov      x0, x19
0x0000cb54  bl       #0x24818   ; call _objc_retain
0x0000cb58  mov      x0, x19
0x0000cb5c  bl       #0x2480c   ; call _objc_release
0x0000cb60  mov      x0, x21
0x0000cb64  bl       #0x2480c   ; call _objc_release
0x0000cb68  mov      x0, x19
0x0000cb6c  bl       #0x24818   ; call _objc_retain
0x0000cb70  str      x19, [sp, #0x68]
0x0000cb74  cbz      x19, #0xcb94
0x0000cb78  adrp     x0, #0x29000
0x0000cb7c  add      x0, x0, #0xb31   ; -> "SBDeviceApplicationSceneHandle"
0x0000cb80  bl       #0x24788   ; call _objc_getClass
0x0000cb84  mov      x1, x0
0x0000cb88  ldr      x0, [sp, #0x68]
0x0000cb8c  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0000cb90  tbnz     w0, #0, #0xcc00
0x0000cb94  adrp     x20, #0x29000
0x0000cb98  add      x20, x20, #0xb31   ; -> "SBDeviceApplicationSceneHandle"
0x0000cb9c  ldr      x0, [x26, #0x290]   ; -> [class(NSString)]
0x0000cba0  mov      w8, #0x1cd
0x0000cba4  stp      x25, x8, [sp, #0x10]
0x0000cba8  ldr      x8, [sp, #0x68]
0x0000cbac  stp      x20, x8, [sp]
0x0000cbb0  adrp     x2, #0x35000
0x0000cbb4  add      x2, x2, #0xc10   ; -> @"UNEXPECTED %s: got %@ (%s:%d)"
0x0000cbb8  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000cbbc  mov      x29, x29
0x0000cbc0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000cbc4  mov      x19, x0
0x0000cbc8  adrp     x0, #0x34000
0x0000cbcc  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000cbd0  mov      x1, x19
0x0000cbd4  bl       #0x1dd30   ; call _OMCLogWrite
0x0000cbd8  mov      x0, x19
0x0000cbdc  bl       #0x2480c   ; call _objc_release
0x0000cbe0  ldr      x0, [x24, #0x338]   ; -> [class(NSException)]
0x0000cbe4  adrp     x2, #0x34000
0x0000cbe8  add      x2, x2, #0xef0   ; -> @"AppBridge"
0x0000cbec  ldr      x8, [sp, #0x68]
0x0000cbf0  stp      x20, x8, [sp]
0x0000cbf4  adrp     x3, #0x35000
0x0000cbf8  add      x3, x3, #0xc30   ; -> @"expected %s got %@"
0x0000cbfc  bl       #0x26700   ; objc_msgSend: raise:format:
0x0000cc00  ldr      x19, [sp, #0x68]
0x0000cc04  mov      x0, x19
0x0000cc08  bl       #0x24818   ; call _objc_retain
0x0000cc0c  mov      x0, x19
0x0000cc10  bl       #0x2480c   ; call _objc_release
0x0000cc14  mov      x0, x19
0x0000cc18  bl       #0x2480c   ; call _objc_release
0x0000cc1c  adrp     x19, #0x29000
0x0000cc20  add      x19, x19, #0xb50   ; -> "SBDeviceApplicationSceneEntity"
0x0000cc24  mov      x0, x19
0x0000cc28  bl       #0x24788   ; call _objc_getClass
0x0000cc2c  bl       #0x2471c   ; call _objc_alloc
0x0000cc30  mov      x20, x0
0x0000cc34  adrp     x0, #0x35000
0x0000cc38  add      x0, x0, #0xdb0   ; -> @"initWithApplicationSceneHandle:"
0x0000cc3c  bl       #0x2441c   ; call _NSSelectorFromString
0x0000cc40  mov      x22, x0
0x0000cc44  mov      x0, x20
0x0000cc48  mov      x1, x22
0x0000cc4c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000cc50  tbz      w0, #0, #0xcc74
0x0000cc54  mov      x0, x20
0x0000cc58  mov      x1, x22
0x0000cc5c  ldr      x2, [sp, #0x68]
0x0000cc60  bl       #0x247ac   ; call _objc_msgSend
0x0000cc64  mov      x29, x29
0x0000cc68  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000cc6c  mov      x22, x0
0x0000cc70  b        #0xcc88   ; call sub_cc88
0x0000cc74  adrp     x1, #0x35000
0x0000cc78  add      x1, x1, #0xdb0   ; -> @"initWithApplicationSceneHandle:"
