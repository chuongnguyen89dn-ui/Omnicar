; ==== __mod_init_1 @ 0x6e08..0x783c (2612 bytes) ====
0x00006e08  stp      x22, x21, [sp, #-0x30]!
0x00006e0c  stp      x20, x19, [sp, #0x10]
0x00006e10  stp      x29, x30, [sp, #0x20]
0x00006e14  add      x29, sp, #0x20
0x00006e18  adrp     x8, #0x3e000
0x00006e1c  ldr      x0, [x8, #0x280]   ; -> [class(NSBundle)]
0x00006e20  bl       #0x26080   ; objc_msgSend: mainBundle
0x00006e24  mov      x29, x29
0x00006e28  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006e2c  mov      x19, x0
0x00006e30  bl       #0x25040   ; objc_msgSend: bundleIdentifier
0x00006e34  mov      x29, x29
0x00006e38  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006e3c  mov      x20, x0
0x00006e40  adrp     x2, #0x34000
0x00006e44  add      x2, x2, #0xdf0   ; -> @"com.apple.springboard"
0x00006e48  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00006e4c  mov      x21, x0
0x00006e50  mov      x0, x20
0x00006e54  bl       #0x2480c   ; call _objc_release
0x00006e58  mov      x0, x19
0x00006e5c  bl       #0x2480c   ; call _objc_release
0x00006e60  tbz      w21, #0, #0x6f84
0x00006e64  adrp     x20, #0x3e000
0x00006e68  ldr      x0, [x20, #0x290]   ; -> [class(NSString)]
0x00006e6c  adrp     x2, #0x35000
0x00006e70  add      x2, x2, #0x250   ; -> @"loaded into SpringBoard"
0x00006e74  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00006e78  mov      x29, x29
0x00006e7c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006e80  mov      x19, x0
0x00006e84  adrp     x0, #0x34000
0x00006e88  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00006e8c  mov      x1, x19
0x00006e90  bl       #0x1dd30   ; call _OMCLogWrite
0x00006e94  mov      x0, x19
0x00006e98  bl       #0x2480c   ; call _objc_release
0x00006e9c  adrp     x0, #0x29000
0x00006ea0  add      x0, x0, #0x2f6   ; -> "SpringBoard"
0x00006ea4  bl       #0x24788   ; call _objc_getClass
0x00006ea8  adrp     x8, #0x3d000
0x00006eac  ldr      x1, [x8, #0x230]   ; -> [@selector(applicationDidFinishLaunching:)]
0x00006eb0  adrp     x2, #0x7000
0x00006eb4  add      x2, x2, #4
0x00006eb8  adrp     x3, #0x3e000
0x00006ebc  add      x3, x3, #0x9f0
0x00006ec0  bl       #0x243ec   ; call _MSHookMessageEx
0x00006ec4  adrp     x0, #0x29000
0x00006ec8  add      x0, x0, #0x302   ; -> "SBSuspendedUnderLockManager"
0x00006ecc  bl       #0x24788   ; call _objc_getClass
0x00006ed0  adrp     x8, #0x3d000
0x00006ed4  ldr      x1, [x8, #0x238]   ; -> [@selector(_shouldBeBackgroundUnderLockForScene:withSettings:)]
0x00006ed8  adrp     x2, #0x7000
0x00006edc  add      x2, x2, #0x2bc
0x00006ee0  adrp     x3, #0x3e000
0x00006ee4  add      x3, x3, #0x9f8
0x00006ee8  bl       #0x243ec   ; call _MSHookMessageEx
0x00006eec  adrp     x0, #0x29000
0x00006ef0  add      x0, x0, #0x31e   ; -> "FBScene"
0x00006ef4  bl       #0x24788   ; call _objc_getClass
0x00006ef8  adrp     x8, #0x3d000
0x00006efc  ldr      x1, [x8, #0x240]   ; -> [@selector(updateSettings:withTransitionContext:completion:)]
0x00006f00  adrp     x2, #0x7000
0x00006f04  add      x2, x2, #0x4b4
0x00006f08  adrp     x3, #0x3e000
0x00006f0c  add      x3, x3, #0xa00
0x00006f10  bl       #0x243ec   ; call _MSHookMessageEx
0x00006f14  adrp     x0, #0x29000
0x00006f18  add      x0, x0, #0x326   ; -> "SBSceneView"
0x00006f1c  bl       #0x24788   ; call _objc_getClass
0x00006f20  adrp     x8, #0x3d000
0x00006f24  ldr      x1, [x8, #0x248]   ; -> [@selector(_updateReferenceSize:andOrientation:)]
0x00006f28  adrp     x2, #0x7000
0x00006f2c  add      x2, x2, #0x764
0x00006f30  adrp     x3, #0x3e000
0x00006f34  add      x3, x3, #0xa08
0x00006f38  bl       #0x243ec   ; call _MSHookMessageEx
0x00006f3c  adrp     x0, #0x34000
0x00006f40  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00006f44  adrp     x1, #0x39000
0x00006f48  add      x1, x1, #0x408
0x00006f4c  bl       #0x1e580   ; call _OMCCheckHooks
0x00006f50  adrp     x1, #0x29000
0x00006f54  add      x1, x1, #0x3ee   ; -> "BKSDisplayServicesSetScreenBlanked"
0x00006f58  mov      x0, #-2
0x00006f5c  bl       #0x245f0   ; call _dlsym
0x00006f60  cbz      x0, #0x6f94
0x00006f64  adrp     x1, #0x7000
0x00006f68  add      x1, x1, #0x77c
0x00006f6c  adrp     x2, #0x3e000
0x00006f70  add      x2, x2, #0xa10
0x00006f74  ldp      x29, x30, [sp, #0x20]
0x00006f78  ldp      x20, x19, [sp, #0x10]
0x00006f7c  ldp      x22, x21, [sp], #0x30
0x00006f80  b        #0x243e0   ; call _MSHookFunction
0x00006f84  ldp      x29, x30, [sp, #0x20]
0x00006f88  ldp      x20, x19, [sp, #0x10]
0x00006f8c  ldp      x22, x21, [sp], #0x30
0x00006f90  ret      
0x00006f94  ldr      x0, [x20, #0x290]   ; -> [class(NSString)]
0x00006f98  adrp     x2, #0x35000
0x00006f9c  add      x2, x2, #0x2d0   ; -> @"khong tim thay BKSDisplayServicesSetScreenBlanked"
0x00006fa0  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00006fa4  mov      x29, x29
0x00006fa8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00006fac  mov      x19, x0
0x00006fb0  adrp     x0, #0x34000
0x00006fb4  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00006fb8  mov      x1, x19
0x00006fbc  bl       #0x1dd30   ; call _OMCLogWrite
0x00006fc0  mov      x0, x19
0x00006fc4  ldp      x29, x30, [sp, #0x20]
0x00006fc8  ldp      x20, x19, [sp, #0x10]
0x00006fcc  ldp      x22, x21, [sp], #0x30
0x00006fd0  b        #0x2480c   ; call _objc_release
0x00006fd4  b        #0x6ff0   ; call sub_6ff0
0x00006fd8  b        #0x6ff0   ; call sub_6ff0
0x00006fdc  mov      x1, x20
0x00006fe0  mov      x20, x0
0x00006fe4  mov      x0, x1
0x00006fe8  bl       #0x2480c   ; call _objc_release
0x00006fec  b        #0x6ff4   ; call sub_6ff4
0x00006ff0  mov      x20, x0
0x00006ff4  mov      x0, x19
0x00006ff8  bl       #0x2480c   ; call _objc_release
0x00006ffc  mov      x0, x20
0x00007000  bl       #0x24470   ; call __Unwind_Resume
0x00007004  stp      x22, x21, [sp, #-0x30]!
0x00007008  stp      x20, x19, [sp, #0x10]
0x0000700c  stp      x29, x30, [sp, #0x20]
0x00007010  add      x29, sp, #0x20
0x00007014  mov      x19, x2
0x00007018  mov      x20, x1
0x0000701c  mov      x21, x0
0x00007020  mov      x0, x2
0x00007024  bl       #0x24818   ; call _objc_retain
0x00007028  adrp     x8, #0x3e000
0x0000702c  ldr      x8, [x8, #0x9f0]
0x00007030  mov      x0, x21
0x00007034  mov      x1, x20
0x00007038  mov      x2, x19
0x0000703c  blr      x8   ; indirect call
0x00007040  adrp     x8, #0x3e000
0x00007044  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x00007048  adrp     x2, #0x35000
0x0000704c  add      x2, x2, #0x2f0   ; -> @"SpringBoard ready"
0x00007050  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00007054  mov      x29, x29
0x00007058  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000705c  mov      x20, x0
0x00007060  adrp     x0, #0x34000
0x00007064  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00007068  mov      x1, x20
0x0000706c  bl       #0x1dd30   ; call _OMCLogWrite
0x00007070  mov      x0, x20
0x00007074  bl       #0x2480c   ; call _objc_release
0x00007078  adrp     x0, #0x28000
0x0000707c  add      x0, x0, #0xfc3   ; -> "NSDistributedNotificationCenter"
0x00007080  bl       #0x24788   ; call _objc_getClass
0x00007084  bl       #0x254c0   ; objc_msgSend: defaultCenter
0x00007088  mov      x29, x29
0x0000708c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007090  mov      x20, x0
0x00007094  adrp     x8, #0x3e000
0x00007098  ldr      x0, [x8, #0x288]   ; -> [class(NSOperationQueue)]
0x0000709c  bl       #0x260a0   ; objc_msgSend: mainQueue
0x000070a0  mov      x29, x29
0x000070a4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000070a8  mov      x21, x0
0x000070ac  adrp     x2, #0x35000
0x000070b0  add      x2, x2, #0x310   ; -> @"com.anlai.omnicar/appbridge.open"
0x000070b4  adrp     x5, #0x34000
0x000070b8  add      x5, x5, #0x690
0x000070bc  mov      x0, x20
0x000070c0  mov      x3, #0
0x000070c4  mov      x4, x21
0x000070c8  bl       #0x24b60   ; objc_msgSend: addObserverForName:object:queue:usingBlock:
0x000070cc  mov      x29, x29
0x000070d0  bl       #0x24890   ; call _objc_unsafeClaimAutoreleasedReturnValue
0x000070d4  adrp     x2, #0x35000
0x000070d8  add      x2, x2, #0x670   ; -> @"com.anlai.omnicar/appbridge.frame"
0x000070dc  adrp     x5, #0x34000
0x000070e0  add      x5, x5, #0x6b0
0x000070e4  mov      x0, x20
0x000070e8  mov      x3, #0
0x000070ec  mov      x4, x21
0x000070f0  bl       #0x24b60   ; objc_msgSend: addObserverForName:object:queue:usingBlock:
0x000070f4  mov      x29, x29
0x000070f8  bl       #0x24890   ; call _objc_unsafeClaimAutoreleasedReturnValue
0x000070fc  adrp     x2, #0x35000
0x00007100  add      x2, x2, #0x6f0   ; -> @"com.anlai.omnicar/appbridge.shield"
0x00007104  adrp     x5, #0x34000
0x00007108  add      x5, x5, #0x6d0
0x0000710c  mov      x0, x20
0x00007110  mov      x3, #0
0x00007114  mov      x4, x21
0x00007118  bl       #0x24b60   ; objc_msgSend: addObserverForName:object:queue:usingBlock:
0x0000711c  mov      x29, x29
0x00007120  bl       #0x24890   ; call _objc_unsafeClaimAutoreleasedReturnValue
0x00007124  adrp     x2, #0x35000
0x00007128  add      x2, x2, #0x750   ; -> @"com.anlai.omnicar/appbridge.close"
0x0000712c  adrp     x5, #0x34000
0x00007130  add      x5, x5, #0x6f0
0x00007134  mov      x0, x20
0x00007138  mov      x3, #0
0x0000713c  mov      x4, x21
0x00007140  bl       #0x24b60   ; objc_msgSend: addObserverForName:object:queue:usingBlock:
0x00007144  mov      x29, x29
0x00007148  bl       #0x24890   ; call _objc_unsafeClaimAutoreleasedReturnValue
0x0000714c  adrp     x2, #0x35000
0x00007150  add      x2, x2, #0x7b0   ; -> @"com.anlai.omnicar/appbridge.closeall"
0x00007154  adrp     x5, #0x34000
0x00007158  add      x5, x5, #0x710
0x0000715c  mov      x0, x20
0x00007160  mov      x3, #0
0x00007164  mov      x4, x21
0x00007168  bl       #0x24b60   ; objc_msgSend: addObserverForName:object:queue:usingBlock:
0x0000716c  mov      x29, x29
0x00007170  bl       #0x24890   ; call _objc_unsafeClaimAutoreleasedReturnValue
0x00007174  adrp     x2, #0x35000
0x00007178  add      x2, x2, #0x810   ; -> @"com.anlai.omnicar/appbridge.knobs"
0x0000717c  adrp     x5, #0x34000
0x00007180  add      x5, x5, #0x730
0x00007184  mov      x0, x20
0x00007188  mov      x3, #0
0x0000718c  mov      x4, x21
0x00007190  bl       #0x24b60   ; objc_msgSend: addObserverForName:object:queue:usingBlock:
0x00007194  mov      x29, x29
0x00007198  bl       #0x24890   ; call _objc_unsafeClaimAutoreleasedReturnValue
0x0000719c  adrp     x0, #0x29000
0x000071a0  add      x0, x0, #0x173   ; -> "com.anlai.omnicar/appbridge.apporient"
0x000071a4  adrp     x1, #0x3e000
0x000071a8  add      x1, x1, #0xa18
0x000071ac  adrp     x2, #0x34000
0x000071b0  ldr      x2, [x2, #0x290]   ; -> [got:__dispatch_main_q]
0x000071b4  adrp     x3, #0x34000
0x000071b8  add      x3, x3, #0x770
0x000071bc  bl       #0x24704   ; call _notify_register_dispatch
0x000071c0  adrp     x0, #0x29000
0x000071c4  add      x0, x0, #0x1bc   ; -> "com.anlai.omnicar/appbridge.keyboard"
0x000071c8  adrp     x1, #0x3e000
0x000071cc  add      x1, x1, #0xa1c
0x000071d0  adrp     x2, #0x34000
0x000071d4  ldr      x2, [x2, #0x290]   ; -> [got:__dispatch_main_q]
0x000071d8  adrp     x3, #0x34000
0x000071dc  add      x3, x3, #0x790
0x000071e0  bl       #0x24704   ; call _notify_register_dispatch
0x000071e4  adrp     x0, #0x34000
0x000071e8  ldr      x0, [x0, #0x290]   ; -> [got:__dispatch_main_q]
0x000071ec  bl       #0x2480c   ; call _objc_release
0x000071f0  adrp     x8, #0x3e000
0x000071f4  ldr      x0, [x8, #0x2b0]   ; -> [class(NSNotificationCenter)]
0x000071f8  bl       #0x254c0   ; objc_msgSend: defaultCenter
0x000071fc  mov      x29, x29
0x00007200  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007204  mov      x22, x0
0x00007208  adrp     x2, #0x35000
0x0000720c  add      x2, x2, #0x8d0   ; -> @"CarPlayIsConnectedDidChange"
0x00007210  adrp     x5, #0x34000
0x00007214  add      x5, x5, #0x7b0
0x00007218  mov      x3, #0
0x0000721c  mov      x4, x21
0x00007220  bl       #0x24b60   ; objc_msgSend: addObserverForName:object:queue:usingBlock:
0x00007224  mov      x29, x29
0x00007228  bl       #0x24890   ; call _objc_unsafeClaimAutoreleasedReturnValue
0x0000722c  mov      x0, x22
0x00007230  bl       #0x2480c   ; call _objc_release
0x00007234  mov      x0, x21
0x00007238  bl       #0x2480c   ; call _objc_release
0x0000723c  mov      x0, x20
0x00007240  bl       #0x2480c   ; call _objc_release
0x00007244  mov      x0, x19
0x00007248  ldp      x29, x30, [sp, #0x20]
0x0000724c  ldp      x20, x19, [sp, #0x10]
0x00007250  ldp      x22, x21, [sp], #0x30
0x00007254  b        #0x2480c   ; call _objc_release
0x00007258  mov      x1, x22
0x0000725c  mov      x22, x0
0x00007260  mov      x0, x1
0x00007264  b        #0x7274   ; call sub_7274
0x00007268  mov      x22, x0
0x0000726c  adrp     x0, #0x34000
0x00007270  ldr      x0, [x0, #0x290]   ; -> [got:__dispatch_main_q]
0x00007274  bl       #0x2480c   ; call _objc_release
0x00007278  b        #0x729c   ; call sub_729c
0x0000727c  b        #0x7298   ; call sub_7298
0x00007280  b        #0x7284   ; call sub_7284
0x00007284  mov      x22, x0
0x00007288  b        #0x72a4   ; call sub_72a4
0x0000728c  b        #0x7290   ; call sub_7290
0x00007290  mov      x22, x0
0x00007294  b        #0x72ac   ; call sub_72ac
0x00007298  mov      x22, x0
0x0000729c  mov      x0, x21
0x000072a0  bl       #0x2480c   ; call _objc_release
0x000072a4  mov      x0, x20
0x000072a8  bl       #0x2480c   ; call _objc_release
0x000072ac  mov      x0, x19
0x000072b0  bl       #0x2480c   ; call _objc_release
0x000072b4  mov      x0, x22
0x000072b8  bl       #0x24470   ; call __Unwind_Resume
0x000072bc  stp      x24, x23, [sp, #-0x40]!
0x000072c0  stp      x22, x21, [sp, #0x10]
0x000072c4  stp      x20, x19, [sp, #0x20]
0x000072c8  stp      x29, x30, [sp, #0x30]
0x000072cc  add      x29, sp, #0x30
0x000072d0  mov      x20, x3
0x000072d4  mov      x19, x2
0x000072d8  mov      x21, x1
0x000072dc  mov      x22, x0
0x000072e0  mov      x0, x2
0x000072e4  bl       #0x24818   ; call _objc_retain
0x000072e8  mov      x0, x20
0x000072ec  bl       #0x24818   ; call _objc_retain
0x000072f0  adrp     x8, #0x3e000
0x000072f4  ldr      x8, [x8, #0x9f8]
0x000072f8  mov      x0, x22
0x000072fc  mov      x1, x21
0x00007300  mov      x2, x19
0x00007304  mov      x3, x20
0x00007308  blr      x8   ; indirect call
0x0000730c  cbz      w0, #0x7354
0x00007310  mov      x0, x19
0x00007314  bl       #0x24818   ; call _objc_retain
0x00007318  adrp     x0, #0x35000
0x0000731c  add      x0, x0, #0x910   ; -> @"clientProcess"
0x00007320  bl       #0x2441c   ; call _NSSelectorFromString
0x00007324  mov      x21, x0
0x00007328  mov      x0, x19
0x0000732c  mov      x1, x21
0x00007330  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00007334  tbz      w0, #0, #0x735c
0x00007338  mov      x0, x19
0x0000733c  mov      x1, x21
0x00007340  bl       #0x247ac   ; call _objc_msgSend
0x00007344  mov      x29, x29
0x00007348  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000734c  mov      x21, x0
0x00007350  b        #0x7370   ; call sub_7370
0x00007354  mov      w21, #0
0x00007358  b        #0x7470   ; call sub_7470
0x0000735c  adrp     x1, #0x35000
0x00007360  add      x1, x1, #0x910   ; -> @"clientProcess"
0x00007364  mov      x0, x19
0x00007368  bl       #0x9698   ; call _ABMissingSelector
0x0000736c  mov      x21, #0
0x00007370  mov      x0, x19
0x00007374  bl       #0x2480c   ; call _objc_release
0x00007378  adrp     x0, #0x35000
0x0000737c  add      x0, x0, #0x930   ; -> @"bundleIdentifier"
0x00007380  bl       #0x2441c   ; call _NSSelectorFromString
0x00007384  mov      x22, x0
0x00007388  mov      x0, x21
0x0000738c  mov      x1, x22
0x00007390  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00007394  tbz      w0, #0, #0x73b4
0x00007398  mov      x0, x21
0x0000739c  mov      x1, x22
0x000073a0  bl       #0x247ac   ; call _objc_msgSend
0x000073a4  mov      x29, x29
0x000073a8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000073ac  mov      x23, x0
0x000073b0  b        #0x73c8   ; call sub_73c8
0x000073b4  adrp     x1, #0x35000
0x000073b8  add      x1, x1, #0x930   ; -> @"bundleIdentifier"
0x000073bc  mov      x0, x21
0x000073c0  bl       #0x9698   ; call _ABMissingSelector
0x000073c4  mov      x23, #0
0x000073c8  mov      x0, x21
0x000073cc  bl       #0x2480c   ; call _objc_release
0x000073d0  cbz      x23, #0x746c
0x000073d4  adrp     x8, #0x3e000
0x000073d8  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x000073dc  bl       #0x27b20   ; objc_msgSend: shared
0x000073e0  mov      x29, x29
0x000073e4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000073e8  mov      x21, x0
0x000073ec  mov      x2, x23
0x000073f0  bl       #0x25960   ; objc_msgSend: hostsApp:
0x000073f4  mov      x22, x0
0x000073f8  mov      x0, x21
0x000073fc  bl       #0x2480c   ; call _objc_release
0x00007400  eor      w21, w22, #1
0x00007404  mov      x0, x23
0x00007408  bl       #0x2480c   ; call _objc_release
0x0000740c  b        #0x7470   ; call sub_7470
0x00007410  mov      x22, x0
0x00007414  mov      x0, x21
0x00007418  bl       #0x2480c   ; call _objc_release
0x0000741c  b        #0x7424   ; call sub_7424
0x00007420  mov      x22, x0
0x00007424  mov      x0, x23
0x00007428  bl       #0x2480c   ; call _objc_release
0x0000742c  b        #0x749c   ; call sub_749c
0x00007430  b        #0x7438   ; call sub_7438
0x00007434  b        #0x7444   ; call sub_7444
0x00007438  mov      x23, x1
0x0000743c  mov      x22, x0
0x00007440  b        #0x7450   ; call sub_7450
0x00007444  mov      x23, x1
0x00007448  mov      x22, x0
0x0000744c  mov      x21, x19
0x00007450  mov      x0, x21
0x00007454  bl       #0x2480c   ; call _objc_release
0x00007458  cmp      w23, #1
0x0000745c  b.ne     #0x749c
0x00007460  mov      x0, x22
0x00007464  bl       #0x24740   ; call _objc_begin_catch
0x00007468  bl       #0x24764   ; call _objc_end_catch
0x0000746c  mov      w21, #1
0x00007470  mov      x0, x20
0x00007474  bl       #0x2480c   ; call _objc_release
0x00007478  mov      x0, x19
0x0000747c  bl       #0x2480c   ; call _objc_release
0x00007480  and      w0, w21, #1
0x00007484  ldp      x29, x30, [sp, #0x30]
0x00007488  ldp      x20, x19, [sp, #0x20]
0x0000748c  ldp      x22, x21, [sp, #0x10]
0x00007490  ldp      x24, x23, [sp], #0x40
0x00007494  ret      
0x00007498  mov      x22, x0
0x0000749c  mov      x0, x20
0x000074a0  bl       #0x2480c   ; call _objc_release
0x000074a4  mov      x0, x19
0x000074a8  bl       #0x2480c   ; call _objc_release
0x000074ac  mov      x0, x22
0x000074b0  bl       #0x24470   ; call __Unwind_Resume
0x000074b4  stp      x26, x25, [sp, #-0x50]!
0x000074b8  stp      x24, x23, [sp, #0x10]
0x000074bc  stp      x22, x21, [sp, #0x20]
0x000074c0  stp      x20, x19, [sp, #0x30]
0x000074c4  stp      x29, x30, [sp, #0x40]
0x000074c8  add      x29, sp, #0x40
0x000074cc  mov      x21, x4
0x000074d0  mov      x20, x3
0x000074d4  mov      x19, x2
0x000074d8  mov      x22, x1
0x000074dc  mov      x23, x0
0x000074e0  mov      x0, x2
0x000074e4  bl       #0x24818   ; call _objc_retain
0x000074e8  mov      x0, x20
0x000074ec  bl       #0x24818   ; call _objc_retain
0x000074f0  adrp     x26, #0x3e000
0x000074f4  ldr      x0, [x26, #0x2e0]   ; -> [class(ABHost)]
0x000074f8  bl       #0x27b20   ; objc_msgSend: shared
0x000074fc  mov      x29, x29
0x00007500  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007504  mov      x24, x0
0x00007508  bl       #0x25420   ; objc_msgSend: count
0x0000750c  mov      x25, x0
0x00007510  mov      x0, x24
0x00007514  bl       #0x2480c   ; call _objc_release
0x00007518  cbz      x25, #0x7660
0x0000751c  mov      x0, x23
0x00007520  bl       #0x24818   ; call _objc_retain
0x00007524  adrp     x0, #0x35000
0x00007528  add      x0, x0, #0x910   ; -> @"clientProcess"
0x0000752c  bl       #0x2441c   ; call _NSSelectorFromString
0x00007530  mov      x24, x0
0x00007534  mov      x0, x23
0x00007538  mov      x1, x24
0x0000753c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00007540  tbz      w0, #0, #0x7560
0x00007544  mov      x0, x23
0x00007548  mov      x1, x24
0x0000754c  bl       #0x247ac   ; call _objc_msgSend
0x00007550  mov      x29, x29
0x00007554  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00007558  mov      x25, x0
0x0000755c  b        #0x7574   ; call sub_7574
0x00007560  adrp     x1, #0x35000
0x00007564  add      x1, x1, #0x910   ; -> @"clientProcess"
0x00007568  mov      x0, x23
0x0000756c  bl       #0x9698   ; call _ABMissingSelector
0x00007570  mov      x25, #0
0x00007574  mov      x0, x23
0x00007578  bl       #0x2480c   ; call _objc_release
0x0000757c  adrp     x0, #0x35000
0x00007580  add      x0, x0, #0x930   ; -> @"bundleIdentifier"
0x00007584  bl       #0x2441c   ; call _NSSelectorFromString
0x00007588  mov      x24, x0
0x0000758c  mov      x0, x25
0x00007590  mov      x1, x24
0x00007594  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00007598  tbz      w0, #0, #0x75b8
0x0000759c  mov      x0, x25
0x000075a0  mov      x1, x24
0x000075a4  bl       #0x247ac   ; call _objc_msgSend
0x000075a8  mov      x29, x29
0x000075ac  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000075b0  mov      x24, x0
0x000075b4  b        #0x75cc   ; call sub_75cc
0x000075b8  adrp     x1, #0x35000
0x000075bc  add      x1, x1, #0x930   ; -> @"bundleIdentifier"
0x000075c0  mov      x0, x25
0x000075c4  bl       #0x9698   ; call _ABMissingSelector
0x000075c8  mov      x24, #0
0x000075cc  mov      x0, x25
0x000075d0  bl       #0x2480c   ; call _objc_release
0x000075d4  cbz      x24, #0x7660
0x000075d8  ldr      x0, [x26, #0x2e0]   ; -> [class(ABHost)]
0x000075dc  bl       #0x27b20   ; objc_msgSend: shared
0x000075e0  mov      x29, x29
0x000075e4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000075e8  mov      x25, x0
0x000075ec  mov      x2, x24
0x000075f0  bl       #0x25960   ; objc_msgSend: hostsApp:
0x000075f4  tbz      w0, #0, #0x7650
0x000075f8  mov      x0, x19
0x000075fc  bl       #0x24818   ; call _objc_retain
0x00007600  adrp     x0, #0x35000
0x00007604  add      x0, x0, #0x950   ; -> @"isForeground"
0x00007608  bl       #0x2441c   ; call _NSSelectorFromString
0x0000760c  mov      x26, x0
0x00007610  mov      x0, x19
0x00007614  mov      x1, x26
0x00007618  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000761c  tbz      w0, #0, #0x76a4
0x00007620  mov      x0, x19
0x00007624  mov      x1, x26
0x00007628  bl       #0x247ac   ; call _objc_msgSend
0x0000762c  mov      x26, x0
0x00007630  mov      x0, x19
0x00007634  bl       #0x2480c   ; call _objc_release
0x00007638  mov      x0, x25
0x0000763c  bl       #0x2480c   ; call _objc_release
0x00007640  mov      x0, x24
0x00007644  bl       #0x2480c   ; call _objc_release
0x00007648  tbnz     w26, #0, #0x7660
0x0000764c  b        #0x7680   ; call sub_7680
0x00007650  mov      x0, x25
0x00007654  bl       #0x2480c   ; call _objc_release
0x00007658  mov      x0, x24
0x0000765c  bl       #0x2480c   ; call _objc_release
0x00007660  adrp     x8, #0x3e000
0x00007664  ldr      x8, [x8, #0xa00]
0x00007668  mov      x0, x23
0x0000766c  mov      x1, x22
0x00007670  mov      x2, x19
0x00007674  mov      x3, x20
0x00007678  mov      x4, x21
0x0000767c  blr      x8   ; indirect call
0x00007680  mov      x0, x20
0x00007684  bl       #0x2480c   ; call _objc_release
0x00007688  mov      x0, x19
0x0000768c  ldp      x29, x30, [sp, #0x40]
0x00007690  ldp      x20, x19, [sp, #0x30]
0x00007694  ldp      x22, x21, [sp, #0x20]
0x00007698  ldp      x24, x23, [sp, #0x10]
0x0000769c  ldp      x26, x25, [sp], #0x50
0x000076a0  b        #0x2480c   ; call _objc_release
0x000076a4  adrp     x1, #0x35000
0x000076a8  add      x1, x1, #0x950   ; -> @"isForeground"
0x000076ac  mov      x0, x19
0x000076b0  bl       #0x9698   ; call _ABMissingSelector
0x000076b4  mov      x0, x19
0x000076b8  bl       #0x2480c   ; call _objc_release
0x000076bc  mov      x0, x25
0x000076c0  bl       #0x2480c   ; call _objc_release
0x000076c4  mov      x0, x24
0x000076c8  bl       #0x2480c   ; call _objc_release
0x000076cc  b        #0x7680   ; call sub_7680
0x000076d0  b        #0x76d4   ; call sub_76d4
0x000076d4  mov      x26, x0
0x000076d8  mov      x0, x19
0x000076dc  bl       #0x2480c   ; call _objc_release
0x000076e0  b        #0x76e8   ; call sub_76e8
0x000076e4  mov      x26, x0
0x000076e8  mov      x0, x25
0x000076ec  bl       #0x2480c   ; call _objc_release
0x000076f0  b        #0x7704   ; call sub_7704
0x000076f4  b        #0x7700   ; call sub_7700
0x000076f8  b        #0x7710   ; call sub_7710
0x000076fc  b        #0x771c   ; call sub_771c
0x00007700  mov      x26, x0
0x00007704  mov      x0, x24
0x00007708  bl       #0x2480c   ; call _objc_release
0x0000770c  b        #0x774c   ; call sub_774c
0x00007710  mov      x24, x1
0x00007714  mov      x26, x0
0x00007718  b        #0x7728   ; call sub_7728
0x0000771c  mov      x24, x1
0x00007720  mov      x26, x0
0x00007724  mov      x25, x23
0x00007728  mov      x0, x25
0x0000772c  bl       #0x2480c   ; call _objc_release
0x00007730  cmp      w24, #1
0x00007734  b.ne     #0x774c
0x00007738  mov      x0, x26
0x0000773c  bl       #0x24740   ; call _objc_begin_catch
0x00007740  bl       #0x24764   ; call _objc_end_catch
0x00007744  b        #0x7660   ; call sub_7660
0x00007748  mov      x26, x0
0x0000774c  mov      x0, x20
0x00007750  bl       #0x2480c   ; call _objc_release
0x00007754  mov      x0, x19
0x00007758  bl       #0x2480c   ; call _objc_release
0x0000775c  mov      x0, x26
0x00007760  bl       #0x24470   ; call __Unwind_Resume
0x00007764  adrp     x8, #0x3e000
0x00007768  ldr      x3, [x8, #0xa08]
0x0000776c  cmp      x2, #4
0x00007770  mov      w8, #3
0x00007774  csel     x2, x8, x2, gt
0x00007778  br       x3
0x0000777c  stp      x22, x21, [sp, #-0x30]!
0x00007780  stp      x20, x19, [sp, #0x10]
0x00007784  stp      x29, x30, [sp, #0x20]
0x00007788  add      x29, sp, #0x20
0x0000778c  mov      x19, x0
0x00007790  cmp      w0, #1
0x00007794  b.ne     #0x780c
0x00007798  adrp     x8, #0x3e000
0x0000779c  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x000077a0  bl       #0x27b20   ; objc_msgSend: shared
0x000077a4  mov      x29, x29
0x000077a8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000077ac  mov      x20, x0
0x000077b0  bl       #0x25420   ; objc_msgSend: count
0x000077b4  mov      x21, x0
0x000077b8  mov      x0, x20
0x000077bc  bl       #0x2480c   ; call _objc_release
0x000077c0  cbz      x21, #0x780c
0x000077c4  adrp     x8, #0x3e000
0x000077c8  ldr      x8, [x8, #0xa10]
0x000077cc  mov      w0, #1
0x000077d0  blr      x8   ; indirect call
0x000077d4  mov      x0, #0
0x000077d8  mov      w1, #0xca00
0x000077dc  movk     w1, #0x3b9a, lsl #16
0x000077e0  bl       #0x245cc   ; call _dispatch_time
0x000077e4  adrp     x1, #0x34000
0x000077e8  ldr      x1, [x1, #0x290]   ; -> [got:__dispatch_main_q]
0x000077ec  adrp     x2, #0x34000
0x000077f0  add      x2, x2, #0x7d0
0x000077f4  bl       #0x24548   ; call _dispatch_after
0x000077f8  mov      w0, #0
0x000077fc  ldp      x29, x30, [sp, #0x20]
0x00007800  ldp      x20, x19, [sp, #0x10]
0x00007804  ldp      x22, x21, [sp], #0x30
0x00007808  ret      
0x0000780c  adrp     x8, #0x3e000
0x00007810  ldr      x1, [x8, #0xa10]
0x00007814  mov      x0, x19
0x00007818  ldp      x29, x30, [sp, #0x20]
0x0000781c  ldp      x20, x19, [sp, #0x10]
0x00007820  ldp      x22, x21, [sp], #0x30
0x00007824  br       x1
0x00007828  mov      x19, x0
0x0000782c  mov      x0, x20
0x00007830  bl       #0x2480c   ; call _objc_release
0x00007834  mov      x0, x19
0x00007838  bl       #0x24470   ; call __Unwind_Resume

