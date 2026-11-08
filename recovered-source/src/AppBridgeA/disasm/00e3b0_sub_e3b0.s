; ==== sub_e3b0 @ 0xe3b0..0xe3e0 (48 bytes) ====
0x0000e3b0  bl       #0x24818   ; call _objc_retain
0x0000e3b4  adrp     x0, #0x35000
0x0000e3b8  add      x0, x0, #0xf10   ; -> @"_executeBlockAfterLaunchCompletes:"
0x0000e3bc  bl       #0x2441c   ; call _NSSelectorFromString
0x0000e3c0  mov      x22, x0
0x0000e3c4  mov      x0, x20
0x0000e3c8  mov      x1, x22
0x0000e3cc  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000e3d0  tbz      w0, #0, #0xe434
0x0000e3d4  mov      x0, x20
0x0000e3d8  mov      x1, x22
0x0000e3dc  mov      x2, x21
