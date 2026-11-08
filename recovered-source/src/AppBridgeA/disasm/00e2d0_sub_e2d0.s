; ==== sub_e2d0 @ 0xe2d0..0xe300 (48 bytes) ====
0x0000e2d0  adrp     x2, #0x35000
0x0000e2d4  add      x2, x2, #0xed0   ; -> @"_processLaunchTransaction"
0x0000e2d8  bl       #0x28100   ; objc_msgSend: valueForKey:
0x0000e2dc  mov      x29, x29
0x0000e2e0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000e2e4  mov      x19, x0
0x0000e2e8  cbz      x0, #0xe330
0x0000e2ec  mov      x0, x19
0x0000e2f0  bl       #0x24818   ; call _objc_retain
0x0000e2f4  adrp     x0, #0x35000
0x0000e2f8  add      x0, x0, #0xef0   ; -> @"process"
0x0000e2fc  bl       #0x2441c   ; call _NSSelectorFromString
