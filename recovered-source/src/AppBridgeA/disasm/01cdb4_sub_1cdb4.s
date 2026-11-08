; ==== sub_1cdb4 @ 0x1cdb4..0x1d2ec (1336 bytes) ====
0x0001cdb4  b        #0x1cdbc   ; call sub_1cdbc
0x0001cdb8  mov      x21, x0
0x0001cdbc  mov      x0, x20
0x0001cdc0  bl       #0x2480c   ; call _objc_release
0x0001cdc4  mov      x0, x19
0x0001cdc8  bl       #0x2480c   ; call _objc_release
0x0001cdcc  mov      x0, x21
0x0001cdd0  bl       #0x24470   ; call __Unwind_Resume
0x0001cdd4  sub      sp, sp, #0x50
0x0001cdd8  stp      x24, x23, [sp, #0x10]
0x0001cddc  stp      x22, x21, [sp, #0x20]
0x0001cde0  stp      x20, x19, [sp, #0x30]
0x0001cde4  stp      x29, x30, [sp, #0x40]
0x0001cde8  add      x29, sp, #0x40
0x0001cdec  mov      x19, x2
0x0001cdf0  mov      x21, x0
0x0001cdf4  mov      x0, x2
0x0001cdf8  bl       #0x24818   ; call _objc_retain
0x0001cdfc  mov      x0, x19
0x0001ce00  bl       #0x25260   ; objc_msgSend: command
0x0001ce04  mov      x29, x29
0x0001ce08  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ce0c  mov      x20, x0
0x0001ce10  cbz      x0, #0x1ce28
0x0001ce14  adrp     x2, #0x36000
0x0001ce18  add      x2, x2, #0xcf0   ; -> @"space"
0x0001ce1c  mov      x0, x20
0x0001ce20  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001ce24  cbz      w0, #0x1cef8
0x0001ce28  mov      x0, x19
0x0001ce2c  bl       #0x280e0   ; objc_msgSend: value
0x0001ce30  mov      x29, x29
0x0001ce34  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ce38  mov      x23, x0
0x0001ce3c  mov      x0, x21
0x0001ce40  mov      x2, x23
0x0001ce44  bl       #0x28000   ; objc_msgSend: typeCharacter:
0x0001ce48  mov      x0, x23
0x0001ce4c  bl       #0x2480c   ; call _objc_release
0x0001ce50  mov      x0, x21
0x0001ce54  bl       #0x27ba0   ; objc_msgSend: shift
0x0001ce58  tbz      w0, #0, #0x1ce70
0x0001ce5c  mov      w2, #0
0x0001ce60  mov      x0, x21
0x0001ce64  bl       #0x27800   ; objc_msgSend: setShift:
0x0001ce68  mov      x0, x21
0x0001ce6c  bl       #0x267c0   ; objc_msgSend: rebuildKeys
0x0001ce70  mov      x0, x21
0x0001ce74  bl       #0x28080   ; objc_msgSend: updatePreview
0x0001ce78  mov      x0, x21
0x0001ce7c  bl       #0x26560   ; objc_msgSend: panel
0x0001ce80  mov      x29, x29
0x0001ce84  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ce88  mov      x23, x0
0x0001ce8c  bl       #0x27e20   ; objc_msgSend: superview
0x0001ce90  mov      x29, x29
0x0001ce94  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ce98  mov      x24, x0
0x0001ce9c  mov      x0, x21
0x0001cea0  bl       #0x26560   ; objc_msgSend: panel
0x0001cea4  mov      x29, x29
0x0001cea8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ceac  mov      x21, x0
0x0001ceb0  mov      x0, x24
0x0001ceb4  mov      x2, x21
0x0001ceb8  bl       #0x24f80   ; objc_msgSend: bringSubviewToFront:
0x0001cebc  mov      x0, x21
0x0001cec0  bl       #0x2480c   ; call _objc_release
0x0001cec4  mov      x0, x24
0x0001cec8  bl       #0x2480c   ; call _objc_release
0x0001cecc  mov      x0, x23
0x0001ced0  bl       #0x2480c   ; call _objc_release
0x0001ced4  mov      x0, x20
0x0001ced8  bl       #0x2480c   ; call _objc_release
0x0001cedc  mov      x0, x19
0x0001cee0  ldp      x29, x30, [sp, #0x40]
0x0001cee4  ldp      x20, x19, [sp, #0x30]
0x0001cee8  ldp      x22, x21, [sp, #0x20]
0x0001ceec  ldp      x24, x23, [sp, #0x10]
0x0001cef0  add      sp, sp, #0x50
0x0001cef4  b        #0x2480c   ; call _objc_release
0x0001cef8  adrp     x2, #0x35000
0x0001cefc  add      x2, x2, #0x1b0   ; -> @"del"
0x0001cf00  mov      x0, x20
0x0001cf04  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001cf08  cbz      w0, #0x1d010
0x0001cf0c  adrp     x2, #0x35000
0x0001cf10  add      x2, x2, #0x190   ; -> @"type"
0x0001cf14  mov      x0, x21
0x0001cf18  mov      w3, #1
0x0001cf1c  mov      x4, #0
0x0001cf20  bl       #0x26a80   ; objc_msgSend: send:del:text:
0x0001cf24  mov      x0, x21
0x0001cf28  bl       #0x28020   ; objc_msgSend: typed
0x0001cf2c  mov      x29, x29
0x0001cf30  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001cf34  mov      x23, x0
0x0001cf38  bl       #0x25fa0   ; objc_msgSend: length
0x0001cf3c  mov      x22, x0
0x0001cf40  mov      x0, x23
0x0001cf44  bl       #0x2480c   ; call _objc_release
0x0001cf48  cbz      x22, #0x1cf98
0x0001cf4c  mov      x0, x21
0x0001cf50  bl       #0x28020   ; objc_msgSend: typed
0x0001cf54  mov      x29, x29
0x0001cf58  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001cf5c  mov      x23, x0
0x0001cf60  mov      x0, x21
0x0001cf64  bl       #0x28020   ; objc_msgSend: typed
0x0001cf68  mov      x29, x29
0x0001cf6c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001cf70  mov      x24, x0
0x0001cf74  bl       #0x25fa0   ; objc_msgSend: length
0x0001cf78  sub      x2, x0, #1
0x0001cf7c  mov      x0, x23
0x0001cf80  mov      w3, #1
0x0001cf84  bl       #0x25540   ; objc_msgSend: deleteCharactersInRange:
0x0001cf88  mov      x0, x24
0x0001cf8c  bl       #0x2480c   ; call _objc_release
0x0001cf90  mov      x0, x23
0x0001cf94  bl       #0x2480c   ; call _objc_release
0x0001cf98  mov      x0, x21
0x0001cf9c  bl       #0x28220   ; objc_msgSend: word
0x0001cfa0  mov      x29, x29
0x0001cfa4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001cfa8  mov      x23, x0
0x0001cfac  bl       #0x25fa0   ; objc_msgSend: length
0x0001cfb0  mov      x22, x0
0x0001cfb4  mov      x0, x23
0x0001cfb8  bl       #0x2480c   ; call _objc_release
0x0001cfbc  cbz      x22, #0x1ce70
0x0001cfc0  mov      x0, x21
0x0001cfc4  bl       #0x28220   ; objc_msgSend: word
0x0001cfc8  mov      x29, x29
0x0001cfcc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001cfd0  mov      x23, x0
0x0001cfd4  mov      x0, x21
0x0001cfd8  bl       #0x28220   ; objc_msgSend: word
0x0001cfdc  mov      x29, x29
0x0001cfe0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001cfe4  mov      x24, x0
0x0001cfe8  bl       #0x25fa0   ; objc_msgSend: length
0x0001cfec  sub      x2, x0, #1
0x0001cff0  mov      x0, x23
0x0001cff4  mov      w3, #1
0x0001cff8  bl       #0x25540   ; objc_msgSend: deleteCharactersInRange:
0x0001cffc  mov      x0, x24
0x0001d000  bl       #0x2480c   ; call _objc_release
0x0001d004  mov      x0, x23
0x0001d008  bl       #0x2480c   ; call _objc_release
0x0001d00c  b        #0x1ce70   ; call sub_1ce70
0x0001d010  adrp     x2, #0x36000
0x0001d014  add      x2, x2, #0xd70   ; -> @"shift"
0x0001d018  mov      x0, x20
0x0001d01c  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001d020  cbz      w0, #0x1d034
0x0001d024  mov      x0, x21
0x0001d028  bl       #0x27ba0   ; objc_msgSend: shift
0x0001d02c  eor      w2, w0, #1
0x0001d030  b        #0x1ce60   ; call sub_1ce60
0x0001d034  adrp     x2, #0x36000
0x0001d038  add      x2, x2, #0xf50   ; -> @"mode"
0x0001d03c  mov      x0, x20
0x0001d040  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001d044  cbz      w0, #0x1d060
0x0001d048  mov      x0, x21
0x0001d04c  bl       #0x263c0   ; objc_msgSend: numbers
0x0001d050  eor      w2, w0, #1
0x0001d054  mov      x0, x21
0x0001d058  bl       #0x273e0   ; objc_msgSend: setNumbers:
0x0001d05c  b        #0x1ce5c   ; call sub_1ce5c
0x0001d060  adrp     x2, #0x36000
0x0001d064  add      x2, x2, #0xf90   ; -> @"lang"
0x0001d068  mov      x0, x20
0x0001d06c  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001d070  cbz      w0, #0x1d0ec
0x0001d074  mov      x0, x21
0x0001d078  bl       #0x28120   ; objc_msgSend: vietnamese
0x0001d07c  eor      w2, w0, #1
0x0001d080  mov      x0, x21
0x0001d084  bl       #0x27a40   ; objc_msgSend: setVietnamese:
0x0001d088  mov      x0, x21
0x0001d08c  bl       #0x28220   ; objc_msgSend: word
0x0001d090  mov      x29, x29
0x0001d094  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001d098  mov      x23, x0
0x0001d09c  adrp     x2, #0x36000
0x0001d0a0  add      x2, x2, #0x6f0   ; -> @""
0x0001d0a4  bl       #0x27860   ; objc_msgSend: setString:
0x0001d0a8  mov      x0, x23
0x0001d0ac  bl       #0x2480c   ; call _objc_release
0x0001d0b0  adrp     x8, #0x3e000
0x0001d0b4  ldr      x22, [x8, #0x2a0]   ; -> [class(NSNumber)]
0x0001d0b8  mov      x0, x21
0x0001d0bc  bl       #0x28120   ; objc_msgSend: vietnamese
0x0001d0c0  mov      x2, x0
0x0001d0c4  mov      x0, x22
0x0001d0c8  bl       #0x26320   ; objc_msgSend: numberWithInt:
0x0001d0cc  mov      x1, x0
0x0001d0d0  adrp     x0, #0x36000
0x0001d0d4  add      x0, x0, #0xc50   ; -> @"appBridgeKeyboardLang"
0x0001d0d8  adrp     x2, #0x37000
0x0001d0dc  add      x2, x2, #0x70   ; -> @"com.anlai.omnicar"
0x0001d0e0  bl       #0x242cc   ; call _CFPreferencesSetAppValue
0x0001d0e4  bl       #0x1d674   ; call _OMCPrefsSync
0x0001d0e8  b        #0x1ce68   ; call sub_1ce68
0x0001d0ec  adrp     x2, #0x36000
0x0001d0f0  add      x2, x2, #0xd10   ; -> @"ret"
0x0001d0f4  mov      x0, x20
0x0001d0f8  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001d0fc  cbz      w0, #0x1ce70
0x0001d100  mov      x0, x21
0x0001d104  bl       #0x28220   ; objc_msgSend: word
0x0001d108  mov      x29, x29
0x0001d10c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001d110  mov      x23, x0
0x0001d114  adrp     x2, #0x36000
0x0001d118  add      x2, x2, #0x6f0   ; -> @""
0x0001d11c  bl       #0x27860   ; objc_msgSend: setString:
0x0001d120  mov      x0, x23
0x0001d124  bl       #0x2480c   ; call _objc_release
0x0001d128  adrp     x2, #0x35000
0x0001d12c  add      x2, x2, #0x1f0   ; -> @"return"
0x0001d130  mov      x0, x21
0x0001d134  mov      x3, #0
0x0001d138  mov      x4, #0
0x0001d13c  bl       #0x26a80   ; objc_msgSend: send:del:text:
0x0001d140  b        #0x1ce70   ; call sub_1ce70
0x0001d144  b        #0x1d194   ; call sub_1d194
0x0001d148  b        #0x1d194   ; call sub_1d194
0x0001d14c  b        #0x1d194   ; call sub_1d194
0x0001d150  b        #0x1d194   ; call sub_1d194
0x0001d154  b        #0x1d194   ; call sub_1d194
0x0001d158  b        #0x1d194   ; call sub_1d194
0x0001d15c  b        #0x1d180   ; call sub_1d180
0x0001d160  b        #0x1d180   ; call sub_1d180
0x0001d164  b        #0x1d194   ; call sub_1d194
0x0001d168  mov      x22, x1
0x0001d16c  mov      x1, x21
0x0001d170  mov      x21, x0
0x0001d174  mov      x0, x1
0x0001d178  bl       #0x2480c   ; call _objc_release
0x0001d17c  b        #0x1d188   ; call sub_1d188
0x0001d180  mov      x22, x1
0x0001d184  mov      x21, x0
0x0001d188  mov      x0, x24
0x0001d18c  bl       #0x2480c   ; call _objc_release
0x0001d190  b        #0x1d19c   ; call sub_1d19c
0x0001d194  mov      x22, x1
0x0001d198  mov      x21, x0
0x0001d19c  mov      x0, x23
0x0001d1a0  bl       #0x2480c   ; call _objc_release
0x0001d1a4  b        #0x1d1bc   ; call sub_1d1bc
0x0001d1a8  mov      x22, x1
0x0001d1ac  mov      x21, x0
0x0001d1b0  b        #0x1d1c4   ; call sub_1d1c4
0x0001d1b4  mov      x22, x1
0x0001d1b8  mov      x21, x0
0x0001d1bc  mov      x0, x20
0x0001d1c0  bl       #0x2480c   ; call _objc_release
0x0001d1c4  cmp      w22, #1
0x0001d1c8  b.ne     #0x1d234
0x0001d1cc  mov      x0, x21
0x0001d1d0  bl       #0x24740   ; call _objc_begin_catch
0x0001d1d4  adrp     x8, #0x3e000
0x0001d1d8  ldr      x8, [x8, #0x290]   ; -> [class(NSString)]
0x0001d1dc  str      x0, [sp]
0x0001d1e0  adrp     x2, #0x37000
0x0001d1e4  add      x2, x2, #0x90   ; -> @"ban phim xe: loi phim %@"
0x0001d1e8  mov      x0, x8
0x0001d1ec  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0001d1f0  mov      x29, x29
0x0001d1f4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001d1f8  mov      x20, x0
0x0001d1fc  adrp     x0, #0x34000
0x0001d200  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0001d204  mov      x1, x20
0x0001d208  bl       #0x1dd30   ; call _OMCLogWrite
0x0001d20c  mov      x0, x20
0x0001d210  bl       #0x2480c   ; call _objc_release
0x0001d214  bl       #0x24764   ; call _objc_end_catch
0x0001d218  b        #0x1cedc   ; call sub_1cedc
0x0001d21c  mov      x21, x0
0x0001d220  mov      x0, x20
0x0001d224  bl       #0x2480c   ; call _objc_release
0x0001d228  b        #0x1d230   ; call sub_1d230
0x0001d22c  mov      x21, x0
0x0001d230  bl       #0x24764   ; call _objc_end_catch
0x0001d234  mov      x0, x19
0x0001d238  bl       #0x2480c   ; call _objc_release
0x0001d23c  mov      x0, x21
0x0001d240  bl       #0x24470   ; call __Unwind_Resume
0x0001d244  stp      x20, x19, [sp, #-0x20]!
0x0001d248  stp      x29, x30, [sp, #0x10]
0x0001d24c  add      x29, sp, #0x10
0x0001d250  mov      x19, x0
0x0001d254  adrp     x2, #0x35000
0x0001d258  add      x2, x2, #0x230   ; -> @"dismiss"
0x0001d25c  mov      x3, #0
0x0001d260  mov      x4, #0
0x0001d264  bl       #0x26a80   ; objc_msgSend: send:del:text:
0x0001d268  mov      x0, x19
0x0001d26c  mov      x2, #0
0x0001d270  ldp      x29, x30, [sp, #0x10]
0x0001d274  ldp      x20, x19, [sp], #0x20
0x0001d278  b        #0x25900   ; objc_msgSend: hideForApp:
0x0001d27c  ldr      x0, [x0, #0x10]   ; -> [got:_class_copyMethodList]
0x0001d280  ret      
0x0001d284  mov      w3, #0x10
0x0001d288  b        #0x24854   ; call _objc_setProperty_nonatomic_copy
0x0001d28c  ldr      x0, [x0, #0x18]   ; -> [got:_class_copyPropertyList]
0x0001d290  ret      
0x0001d294  stp      x20, x19, [sp, #-0x20]!
0x0001d298  stp      x29, x30, [sp, #0x10]
0x0001d29c  add      x29, sp, #0x10
0x0001d2a0  mov      x19, x2
0x0001d2a4  mov      x20, x0
0x0001d2a8  mov      x0, x2
0x0001d2ac  bl       #0x24818   ; call _objc_retain
0x0001d2b0  ldr      x0, [x20, #0x18]
0x0001d2b4  str      x19, [x20, #0x18]
0x0001d2b8  ldp      x29, x30, [sp, #0x10]
0x0001d2bc  ldp      x20, x19, [sp], #0x20
0x0001d2c0  b        #0x2480c   ; call _objc_release
0x0001d2c4  ldr      x0, [x0, #0x20]   ; -> [got:_class_getClassMethod]
0x0001d2c8  ret      
0x0001d2cc  stp      x20, x19, [sp, #-0x20]!
0x0001d2d0  stp      x29, x30, [sp, #0x10]
0x0001d2d4  add      x29, sp, #0x10
0x0001d2d8  mov      x19, x2
0x0001d2dc  mov      x20, x0
0x0001d2e0  mov      x0, x2
0x0001d2e4  bl       #0x24818   ; call _objc_retain
0x0001d2e8  ldr      x0, [x20, #0x20]
