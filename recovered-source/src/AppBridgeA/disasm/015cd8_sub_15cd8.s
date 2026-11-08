; ==== sub_15cd8 @ 0x15cd8..0x15f58 (640 bytes) ====
0x00015cd8  bl       #0x26520   ; objc_msgSend: paneFor:
0x00015cdc  mov      x29, x29
0x00015ce0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015ce4  mov      x20, x0
0x00015ce8  cbz      x0, #0x1600c
0x00015cec  adrp     x25, #0x3e000
0x00015cf0  ldr      x0, [x25, #0x290]   ; -> [class(NSString)]
0x00015cf4  adrp     x8, #0x36000
0x00015cf8  add      x8, x8, #0x6f0   ; -> @""
0x00015cfc  adrp     x9, #0x36000
0x00015d00  add      x9, x9, #0x6d0   ; -> @" (tat han)"
0x00015d04  cmp      w21, #0
0x00015d08  csel     x8, x9, x8, ne
0x00015d0c  stp      x19, x8, [sp]
0x00015d10  adrp     x2, #0x36000
0x00015d14  add      x2, x2, #0x6b0   ; -> @"dong %@%@"
0x00015d18  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00015d1c  mov      x29, x29
0x00015d20  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015d24  mov      x23, x0
0x00015d28  adrp     x0, #0x34000
0x00015d2c  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00015d30  mov      x1, x23
0x00015d34  bl       #0x1dd30   ; call _OMCLogWrite
0x00015d38  mov      x0, x23
0x00015d3c  bl       #0x2480c   ; call _objc_release
0x00015d40  adrp     x8, #0x3e000
0x00015d44  ldr      x0, [x8, #0x2e8]   ; -> [class(ABKeyboard)]
0x00015d48  bl       #0x27b20   ; objc_msgSend: shared
0x00015d4c  mov      x29, x29
0x00015d50  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015d54  mov      x23, x0
0x00015d58  mov      x2, x19
0x00015d5c  bl       #0x25900   ; objc_msgSend: hideForApp:
0x00015d60  mov      x0, x23
0x00015d64  bl       #0x2480c   ; call _objc_release
0x00015d68  mov      x0, x22
0x00015d6c  mov      x2, x20
0x00015d70  bl       #0x27ee0   ; objc_msgSend: teardownPane:
0x00015d74  mov      x0, x22
0x00015d78  bl       #0x26580   ; objc_msgSend: panes
0x00015d7c  mov      x29, x29
0x00015d80  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015d84  mov      x23, x0
0x00015d88  mov      x2, x20
0x00015d8c  bl       #0x268a0   ; objc_msgSend: removeObject:
0x00015d90  mov      x0, x23
0x00015d94  bl       #0x2480c   ; call _objc_release
0x00015d98  mov      x0, x22
0x00015d9c  bl       #0x25660   ; objc_msgSend: dropWindowIfEmpty
0x00015da0  cbz      w21, #0x1600c
0x00015da4  adrp     x8, #0x3e000
0x00015da8  ldr      x0, [x8, #0x2c0]   ; -> [class(UIApplication)]
0x00015dac  bl       #0x27b40   ; objc_msgSend: sharedApplication
0x00015db0  mov      x29, x29
0x00015db4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015db8  mov      x23, x0
0x00015dbc  adrp     x0, #0x36000
0x00015dc0  add      x0, x0, #0x670   ; -> @"_accessibilityFrontMostApplication"
0x00015dc4  bl       #0x2441c   ; call _NSSelectorFromString
0x00015dc8  mov      x21, x0
0x00015dcc  mov      x0, x23
0x00015dd0  mov      x1, x21
0x00015dd4  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00015dd8  tbz      w0, #0, #0x15df8
0x00015ddc  mov      x0, x23
0x00015de0  mov      x1, x21
0x00015de4  bl       #0x247ac   ; call _objc_msgSend
0x00015de8  mov      x29, x29
0x00015dec  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015df0  mov      x21, x0
0x00015df4  b        #0x15e0c   ; call sub_15e0c
0x00015df8  adrp     x1, #0x36000
0x00015dfc  add      x1, x1, #0x670   ; -> @"_accessibilityFrontMostApplication"
0x00015e00  mov      x0, x23
0x00015e04  bl       #0x9698   ; call _ABMissingSelector
0x00015e08  mov      x21, #0
0x00015e0c  mov      x0, x23
0x00015e10  bl       #0x2480c   ; call _objc_release
0x00015e14  cbz      x21, #0x15ec8
0x00015e18  mov      x0, x21
0x00015e1c  bl       #0x24818   ; call _objc_retain
0x00015e20  adrp     x0, #0x35000
0x00015e24  add      x0, x0, #0x930   ; -> @"bundleIdentifier"
0x00015e28  bl       #0x2441c   ; call _NSSelectorFromString
0x00015e2c  mov      x22, x0
0x00015e30  mov      x0, x21
0x00015e34  mov      x1, x22
0x00015e38  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00015e3c  tbz      w0, #0, #0x15e5c
0x00015e40  mov      x0, x21
0x00015e44  mov      x1, x22
0x00015e48  bl       #0x247ac   ; call _objc_msgSend
0x00015e4c  mov      x29, x29
0x00015e50  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015e54  mov      x23, x0
0x00015e58  b        #0x15e70   ; call sub_15e70
0x00015e5c  adrp     x1, #0x35000
0x00015e60  add      x1, x1, #0x930   ; -> @"bundleIdentifier"
0x00015e64  mov      x0, x21
0x00015e68  bl       #0x9698   ; call _ABMissingSelector
0x00015e6c  mov      x23, #0
0x00015e70  mov      x0, x21
0x00015e74  bl       #0x2480c   ; call _objc_release
0x00015e78  mov      x0, x23
0x00015e7c  mov      x2, x19
0x00015e80  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00015e84  mov      x22, x0
0x00015e88  mov      x0, x23
0x00015e8c  bl       #0x2480c   ; call _objc_release
0x00015e90  cbz      w22, #0x15ec8
0x00015e94  ldr      x0, [x25, #0x290]   ; -> [class(NSString)]
0x00015e98  str      x19, [sp]
0x00015e9c  adrp     x2, #0x36000
0x00015ea0  add      x2, x2, #0x710   ; -> @"%@ dang mo tren iPhone, khong tat"
0x00015ea4  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00015ea8  mov      x29, x29
0x00015eac  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015eb0  mov      x23, x0
0x00015eb4  adrp     x0, #0x34000
0x00015eb8  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00015ebc  mov      x1, x23
0x00015ec0  bl       #0x1dd30   ; call _OMCLogWrite
0x00015ec4  b        #0x15ffc   ; call sub_15ffc
0x00015ec8  mov      x0, x19
0x00015ecc  bl       #0x24818   ; call _objc_retain
0x00015ed0  adrp     x0, #0x2a000
0x00015ed4  add      x0, x0, #0x3e3   ; -> "FBSSystemService"
0x00015ed8  bl       #0x24788   ; call _objc_getClass
0x00015edc  mov      x29, x29
0x00015ee0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015ee4  mov      x24, x0
0x00015ee8  adrp     x0, #0x36000
0x00015eec  add      x0, x0, #0xaf0   ; -> @"sharedService"
0x00015ef0  bl       #0x2441c   ; call _NSSelectorFromString
0x00015ef4  mov      x22, x0
0x00015ef8  mov      x0, x24
0x00015efc  mov      x1, x22
0x00015f00  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00015f04  tbz      w0, #0, #0x15f24
0x00015f08  mov      x0, x24
0x00015f0c  mov      x1, x22
0x00015f10  bl       #0x247ac   ; call _objc_msgSend
0x00015f14  mov      x29, x29
0x00015f18  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015f1c  mov      x23, x0
0x00015f20  b        #0x15f38   ; call sub_15f38
0x00015f24  adrp     x1, #0x36000
0x00015f28  add      x1, x1, #0xaf0   ; -> @"sharedService"
0x00015f2c  mov      x0, x24
0x00015f30  bl       #0x9698   ; call _ABMissingSelector
0x00015f34  mov      x23, #0
0x00015f38  mov      x0, x24
0x00015f3c  bl       #0x2480c   ; call _objc_release
0x00015f40  adrp     x0, #0x36000
0x00015f44  add      x0, x0, #0xb10   ; -> @"terminateApplication:forReason:andReport:withDescription:"
0x00015f48  bl       #0x2441c   ; call _NSSelectorFromString
0x00015f4c  cbz      x23, #0x15fb8
0x00015f50  mov      x22, x0
0x00015f54  mov      x0, x23
