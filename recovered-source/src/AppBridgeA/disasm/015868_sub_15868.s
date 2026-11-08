; ==== sub_15868 @ 0x15868..0x15cd8 (1136 bytes) ====
0x00015868  mov      x1, x23
0x0001586c  bl       #0x247ac   ; call _objc_msgSend
0x00015870  mov      x29, x29
0x00015874  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015878  mov      x26, x0
0x0001587c  b        #0x15894   ; call sub_15894
0x00015880  adrp     x1, #0x35000
0x00015884  add      x1, x1, #0x930   ; -> @"bundleIdentifier"
0x00015888  mov      x0, x24
0x0001588c  bl       #0x9698   ; call _ABMissingSelector
0x00015890  mov      x26, #0
0x00015894  mov      x0, x24
0x00015898  bl       #0x2480c   ; call _objc_release
0x0001589c  mov      x0, x26
0x000158a0  mov      x2, x20
0x000158a4  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x000158a8  mov      x23, x0
0x000158ac  mov      x0, x26
0x000158b0  bl       #0x2480c   ; call _objc_release
0x000158b4  tbnz     w23, #0, #0x15910
0x000158b8  mov      x0, x22
0x000158bc  bl       #0x24818   ; call _objc_retain
0x000158c0  adrp     x0, #0x36000
0x000158c4  add      x0, x0, #0x170   ; -> @"updateSettingsWithBlock:"
0x000158c8  bl       #0x2441c   ; call _NSSelectorFromString
0x000158cc  mov      x23, x0
0x000158d0  mov      x0, x22
0x000158d4  mov      x1, x23
0x000158d8  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x000158dc  tbz      w0, #0, #0x158f8
0x000158e0  adrp     x2, #0x34000
0x000158e4  add      x2, x2, #0xa10
0x000158e8  mov      x0, x22
0x000158ec  mov      x1, x23
0x000158f0  bl       #0x247ac   ; call _objc_msgSend
0x000158f4  b        #0x15908   ; call sub_15908
0x000158f8  adrp     x1, #0x36000
0x000158fc  add      x1, x1, #0x170   ; -> @"updateSettingsWithBlock:"
0x00015900  mov      x0, x22
0x00015904  bl       #0x9698   ; call _ABMissingSelector
0x00015908  mov      x0, x22
0x0001590c  bl       #0x2480c   ; call _objc_release
0x00015910  mov      x0, x24
0x00015914  bl       #0x2480c   ; call _objc_release
0x00015918  mov      x0, x22
0x0001591c  bl       #0x2480c   ; call _objc_release
0x00015920  mov      x0, x19
0x00015924  mov      x2, #0
0x00015928  bl       #0x26ba0   ; objc_msgSend: setAppViewController:
0x0001592c  mov      x0, x19
0x00015930  bl       #0x24f60   ; objc_msgSend: box
0x00015934  mov      x29, x29
0x00015938  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001593c  mov      x22, x0
0x00015940  mov      w2, #0
0x00015944  bl       #0x279e0   ; objc_msgSend: setUserInteractionEnabled:
0x00015948  adrp     x8, #0x3e000
0x0001594c  ldr      x23, [x8, #0x2d0]   ; -> [class(UIView)]
0x00015950  adrp     x24, #0x34000
0x00015954  ldr      x24, [x24, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x00015958  str      x24, [sp, #0x38]
0x0001595c  adrp     x8, #0x2b000
0x00015960  ldr      d8, [x8, #0x1d0]
0x00015964  str      d8, [sp, #0x40]
0x00015968  adrp     x8, #0x15000
0x0001596c  add      x8, x8, #0xc8c
0x00015970  adrp     x9, #0x34000
0x00015974  add      x9, x9, #0x890
0x00015978  stp      x8, x9, [sp, #0x48]
0x0001597c  mov      x0, x22
0x00015980  bl       #0x24818   ; call _objc_retain
0x00015984  str      x22, [sp, #0x58]
0x00015988  str      x24, [sp, #0x10]
0x0001598c  str      d8, [sp, #0x18]
0x00015990  adrp     x8, #0x15000
0x00015994  add      x8, x8, #0xc98
0x00015998  adrp     x9, #0x34000
0x0001599c  add      x9, x9, #0xa30
0x000159a0  stp      x8, x9, [sp, #0x20]
0x000159a4  mov      x0, x22
0x000159a8  bl       #0x24818   ; call _objc_retain
0x000159ac  str      x22, [sp, #0x30]
0x000159b0  adrp     x8, #0x2b000
0x000159b4  ldr      d0, [x8, #0x2f0]
0x000159b8  add      x2, sp, #0x38
0x000159bc  add      x3, sp, #0x10
0x000159c0  mov      x0, x23
0x000159c4  bl       #0x24c60   ; objc_msgSend: animateWithDuration:animations:completion:
0x000159c8  ldr      x0, [sp, #0x30]
0x000159cc  bl       #0x2480c   ; call _objc_release
0x000159d0  ldr      x0, [sp, #0x58]
0x000159d4  bl       #0x2480c   ; call _objc_release
0x000159d8  mov      x0, x22
0x000159dc  bl       #0x2480c   ; call _objc_release
0x000159e0  mov      x0, x21
0x000159e4  bl       #0x2480c   ; call _objc_release
0x000159e8  mov      x0, x20
0x000159ec  bl       #0x2480c   ; call _objc_release
0x000159f0  mov      x0, x19
0x000159f4  bl       #0x2480c   ; call _objc_release
0x000159f8  ldp      x29, x30, [sp, #0xb0]
0x000159fc  ldp      x20, x19, [sp, #0xa0]
0x00015a00  ldp      x22, x21, [sp, #0x90]
0x00015a04  ldp      x24, x23, [sp, #0x80]
0x00015a08  ldp      x26, x25, [sp, #0x70]
0x00015a0c  ldp      d9, d8, [sp, #0x60]
0x00015a10  add      sp, sp, #0xc0
0x00015a14  ret      
0x00015a18  mov      x25, x1
0x00015a1c  mov      x23, x0
0x00015a20  b        #0x15ac8   ; call sub_15ac8
0x00015a24  b        #0x15a30   ; call sub_15a30
0x00015a28  b        #0x15aac   ; call sub_15aac
0x00015a2c  b        #0x15a48   ; call sub_15a48
0x00015a30  mov      x25, x1
0x00015a34  mov      x23, x0
0x00015a38  mov      x26, x24
0x00015a3c  b        #0x15ac8   ; call sub_15ac8
0x00015a40  b        #0x15ae4   ; call sub_15ae4
0x00015a44  b        #0x15b18   ; call sub_15b18
0x00015a48  mov      x25, x1
0x00015a4c  mov      x23, x0
0x00015a50  b        #0x15ad8   ; call sub_15ad8
0x00015a54  mov      x23, x0
0x00015a58  ldr      x0, [sp, #0x30]
0x00015a5c  bl       #0x2480c   ; call _objc_release
0x00015a60  ldr      x0, [sp, #0x58]
0x00015a64  bl       #0x2480c   ; call _objc_release
0x00015a68  b        #0x15a70   ; call sub_15a70
0x00015a6c  mov      x23, x0
0x00015a70  mov      x0, x22
0x00015a74  bl       #0x2480c   ; call _objc_release
0x00015a78  b        #0x15a84   ; call sub_15a84
0x00015a7c  b        #0x15a80   ; call sub_15a80
0x00015a80  mov      x23, x0
0x00015a84  mov      x0, x21
0x00015a88  bl       #0x2480c   ; call _objc_release
0x00015a8c  b        #0x15aa0   ; call sub_15aa0
0x00015a90  b        #0x15a9c   ; call sub_15a9c
0x00015a94  b        #0x15a9c   ; call sub_15a9c
0x00015a98  b        #0x15b04   ; call sub_15b04
0x00015a9c  mov      x23, x0
0x00015aa0  mov      x0, x20
0x00015aa4  bl       #0x2480c   ; call _objc_release
0x00015aa8  b        #0x15b08   ; call sub_15b08
0x00015aac  mov      x25, x1
0x00015ab0  mov      x23, x0
0x00015ab4  mov      x0, x26
0x00015ab8  b        #0x15ad4   ; call sub_15ad4
0x00015abc  mov      x25, x1
0x00015ac0  mov      x23, x0
0x00015ac4  mov      x26, x22
0x00015ac8  mov      x0, x26
0x00015acc  bl       #0x2480c   ; call _objc_release
0x00015ad0  mov      x0, x24
0x00015ad4  bl       #0x2480c   ; call _objc_release
0x00015ad8  mov      x0, x22
0x00015adc  b        #0x15b24   ; call sub_15b24
0x00015ae0  b        #0x15b18   ; call sub_15b18
0x00015ae4  mov      x25, x1
0x00015ae8  mov      x23, x0
0x00015aec  mov      x0, x24
0x00015af0  b        #0x15b24   ; call sub_15b24
0x00015af4  b        #0x15b18   ; call sub_15b18
0x00015af8  mov      x25, x1
0x00015afc  mov      x23, x0
0x00015b00  b        #0x15b28   ; call sub_15b28
0x00015b04  mov      x23, x0
0x00015b08  mov      x0, x19
0x00015b0c  bl       #0x2480c   ; call _objc_release
0x00015b10  mov      x0, x23
0x00015b14  bl       #0x24470   ; call __Unwind_Resume
0x00015b18  mov      x25, x1
0x00015b1c  mov      x23, x0
0x00015b20  mov      x0, x21
0x00015b24  bl       #0x2480c   ; call _objc_release
0x00015b28  cmp      w25, #1
0x00015b2c  b.ne     #0x15a84
0x00015b30  mov      x0, x23
0x00015b34  bl       #0x24740   ; call _objc_begin_catch
0x00015b38  adrp     x8, #0x3e000
0x00015b3c  ldr      x8, [x8, #0x290]   ; -> [class(NSString)]
0x00015b40  stp      x20, x0, [sp]
0x00015b44  adrp     x2, #0x36000
0x00015b48  add      x2, x2, #0x690   ; -> @"teardown %@ loi %@"
0x00015b4c  mov      x0, x8
0x00015b50  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00015b54  mov      x29, x29
0x00015b58  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015b5c  mov      x22, x0
0x00015b60  adrp     x0, #0x34000
0x00015b64  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00015b68  mov      x1, x22
0x00015b6c  bl       #0x1dd30   ; call _OMCLogWrite
0x00015b70  mov      x0, x22
0x00015b74  bl       #0x2480c   ; call _objc_release
0x00015b78  bl       #0x24764   ; call _objc_end_catch
0x00015b7c  b        #0x15920   ; call sub_15920
0x00015b80  mov      x23, x0
0x00015b84  mov      x0, x22
0x00015b88  bl       #0x2480c   ; call _objc_release
0x00015b8c  b        #0x15b94   ; call sub_15b94
0x00015b90  mov      x23, x0
0x00015b94  bl       #0x24764   ; call _objc_end_catch
0x00015b98  b        #0x15a84   ; call sub_15a84
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
0x00015ca0  sub      sp, sp, #0x60
0x00015ca4  stp      x26, x25, [sp, #0x10]
0x00015ca8  stp      x24, x23, [sp, #0x20]
0x00015cac  stp      x22, x21, [sp, #0x30]
0x00015cb0  stp      x20, x19, [sp, #0x40]
0x00015cb4  stp      x29, x30, [sp, #0x50]
0x00015cb8  add      x29, sp, #0x50
0x00015cbc  mov      x21, x3
0x00015cc0  mov      x19, x2
0x00015cc4  mov      x22, x0
0x00015cc8  mov      x0, x2
0x00015ccc  bl       #0x24818   ; call _objc_retain
0x00015cd0  mov      x0, x22
0x00015cd4  mov      x2, x19
