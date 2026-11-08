; ==== sub_e104 @ 0xe104..0xe180 (124 bytes) ====
0x0000e104  add      x2, sp, #0x18
0x0000e108  mov      x0, x25
0x0000e10c  mov      x3, x21
0x0000e110  bl       #0x26be0   ; objc_msgSend: setArgument:atIndex:
0x0000e114  ldr      x0, [sp, #0x18]
0x0000e118  bl       #0x2480c   ; call _objc_release
0x0000e11c  mov      x0, x23
0x0000e120  bl       #0x2480c   ; call _objc_release
0x0000e124  add      x28, x28, #1
0x0000e128  b        #0xdfe8   ; call sub_dfe8
0x0000e12c  mov      x0, x25
0x0000e130  bl       #0x26960   ; objc_msgSend: retainArguments
0x0000e134  mov      x0, x25
0x0000e138  bl       #0x25c20   ; objc_msgSend: invoke
0x0000e13c  mov      x0, x24
0x0000e140  bl       #0x26160   ; objc_msgSend: methodReturnLength
0x0000e144  cbz      x0, #0xe170
0x0000e148  str      xzr, [sp, #0x18]
0x0000e14c  add      x2, sp, #0x18
0x0000e150  mov      x0, x25
0x0000e154  bl       #0x25800   ; objc_msgSend: getReturnValue:
0x0000e158  ldr      x21, [sp, #0x18]
0x0000e15c  mov      x0, x21
0x0000e160  bl       #0x24818   ; call _objc_retain
0x0000e164  b        #0xe174   ; call sub_e174
0x0000e168  mov      x21, #0
0x0000e16c  b        #0xe194   ; call sub_e194
0x0000e170  mov      x21, #0
0x0000e174  ldr      x0, [sp, #8]
0x0000e178  bl       #0x2480c   ; call _objc_release
0x0000e17c  mov      x0, x26
