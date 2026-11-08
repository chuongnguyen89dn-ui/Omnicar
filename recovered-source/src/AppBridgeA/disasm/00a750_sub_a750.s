; ==== sub_a750 @ 0xa750..0xa7fc (172 bytes) ====
0x0000a750  mov      x23, x0
0x0000a754  str      x0, [sp, #0x40]
0x0000a758  adrp     x8, #0x35000
0x0000a75c  add      x8, x8, #0x330   ; -> @"x"
0x0000a760  str      x8, [sp, #0x28]
0x0000a764  ldr      x0, [x25, #0x2a0]
0x0000a768  mov      v0.16b, v9.16b
0x0000a76c  bl       #0x262e0   ; objc_msgSend: numberWithDouble:
0x0000a770  mov      x29, x29
0x0000a774  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000a778  mov      x24, x0
0x0000a77c  str      x0, [sp, #0x48]
0x0000a780  adrp     x8, #0x35000
0x0000a784  add      x8, x8, #0x350   ; -> @"y"
0x0000a788  str      x8, [sp, #0x30]
0x0000a78c  ldr      x0, [x25, #0x2a0]
0x0000a790  mov      v0.16b, v8.16b
0x0000a794  bl       #0x262e0   ; objc_msgSend: numberWithDouble:
0x0000a798  mov      x29, x29
0x0000a79c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000a7a0  mov      x25, x0
0x0000a7a4  str      x0, [sp, #0x50]
0x0000a7a8  adrp     x8, #0x3e000
0x0000a7ac  ldr      x0, [x8, #0x310]   ; -> [class(NSDictionary)]
0x0000a7b0  add      x2, sp, #0x38
0x0000a7b4  add      x3, sp, #0x18
0x0000a7b8  mov      w4, #4
0x0000a7bc  bl       #0x255c0   ; objc_msgSend: dictionaryWithObjects:forKeys:count:
0x0000a7c0  mov      x29, x29
0x0000a7c4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000a7c8  mov      x21, x0
0x0000a7cc  adrp     x2, #0x35000
0x0000a7d0  add      x2, x2, #0xa10   ; -> @"com.anlai.omnicar/appbridge.knobtouch"
0x0000a7d4  mov      x0, x20
0x0000a7d8  mov      x3, #0
0x0000a7dc  mov      x4, x21
0x0000a7e0  bl       #0x26620   ; objc_msgSend: postNotificationName:object:userInfo:
0x0000a7e4  mov      x0, x21
0x0000a7e8  bl       #0x2480c   ; call _objc_release
0x0000a7ec  mov      x0, x25
0x0000a7f0  bl       #0x2480c   ; call _objc_release
0x0000a7f4  mov      x0, x24
0x0000a7f8  bl       #0x2480c   ; call _objc_release
