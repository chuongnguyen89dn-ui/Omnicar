; block literal @0x34a10 desc @0x349f0 sig=v16@?0@8 flags=0x50000000
; ==== sub_15b9c @ 0x15b9c..0x15ca0 (260 bytes) ====
0x00015b9c  stp      x20, x19, [sp, #-0x20]!
0x00015ba0  stp      x29, x30, [sp, #0x10]
0x00015ba4  add      x29, sp, #0x10
0x00015ba8  mov      x19, x1
0x00015bac  mov      x0, x1
0x00015bb0  bl       #0x24818   ; call _objc_retain
0x00015bb4  mov      x0, x19
0x00015bb8  bl       #0x24818   ; call _objc_retain
0x00015bbc  adrp     x0, #0x36000
0x00015bc0  add      x0, x0, #0x1d0   ; -> @"setBackgrounded:"
0x00015bc4  bl       #0x2441c   ; call _NSSelectorFromString
0x00015bc8  mov      x20, x0
0x00015bcc  mov      x0, x19
0x00015bd0  mov      x1, x20
0x00015bd4  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00015bd8  tbz      w0, #0, #0x15bf0
0x00015bdc  mov      x0, x19
0x00015be0  mov      x1, x20
0x00015be4  mov      w2, #1
0x00015be8  bl       #0x247ac   ; call _objc_msgSend
0x00015bec  b        #0x15c00   ; call sub_15c00
0x00015bf0  adrp     x1, #0x36000
0x00015bf4  add      x1, x1, #0x1d0   ; -> @"setBackgrounded:"
0x00015bf8  mov      x0, x19
0x00015bfc  bl       #0x9698   ; call _ABMissingSelector
0x00015c00  mov      x0, x19
0x00015c04  bl       #0x2480c   ; call _objc_release
0x00015c08  mov      x0, x19
0x00015c0c  bl       #0x24818   ; call _objc_retain
0x00015c10  adrp     x0, #0x36000
0x00015c14  add      x0, x0, #0x1f0   ; -> @"setForeground:"
0x00015c18  bl       #0x2441c   ; call _NSSelectorFromString
0x00015c1c  mov      x20, x0
0x00015c20  mov      x0, x19
0x00015c24  mov      x1, x20
0x00015c28  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00015c2c  tbz      w0, #0, #0x15c44
0x00015c30  mov      x0, x19
0x00015c34  mov      x1, x20
0x00015c38  mov      w2, #0
0x00015c3c  bl       #0x247ac   ; call _objc_msgSend
0x00015c40  b        #0x15c54   ; call sub_15c54
0x00015c44  adrp     x1, #0x36000
0x00015c48  add      x1, x1, #0x1f0   ; -> @"setForeground:"
0x00015c4c  mov      x0, x19
0x00015c50  bl       #0x9698   ; call _ABMissingSelector
0x00015c54  mov      x0, x19
0x00015c58  bl       #0x2480c   ; call _objc_release
0x00015c5c  mov      x0, x19
0x00015c60  ldp      x29, x30, [sp, #0x10]
0x00015c64  ldp      x20, x19, [sp], #0x20
0x00015c68  b        #0x2480c   ; call _objc_release
0x00015c6c  b        #0x15c70   ; call sub_15c70
0x00015c70  mov      x20, x0
0x00015c74  mov      x0, x19
0x00015c78  bl       #0x2480c   ; call _objc_release
0x00015c7c  mov      x0, x19
0x00015c80  bl       #0x2480c   ; call _objc_release
0x00015c84  mov      x0, x20
0x00015c88  bl       #0x24470   ; call __Unwind_Resume
0x00015c8c  ldr      x0, [x0, #0x20]
0x00015c90  fmov     d0, xzr
0x00015c94  b        #0x26b40   ; objc_msgSend: setAlpha:
0x00015c98  ldr      x0, [x0, #0x20]
0x00015c9c  b        #0x26840   ; objc_msgSend: removeFromSuperview

