; ==== sub_1c9c8 @ 0x1c9c8..0x1cafc (308 bytes) ====
0x0001c9c8  mov      x0, x23
0x0001c9cc  bl       #0x2480c   ; call _objc_release
0x0001c9d0  b        #0x1ca04   ; call sub_1ca04
0x0001c9d4  mov      x22, x0
0x0001c9d8  mov      x0, x24
0x0001c9dc  bl       #0x2480c   ; call _objc_release
0x0001c9e0  b        #0x1c9e8   ; call sub_1c9e8
0x0001c9e4  mov      x22, x0
0x0001c9e8  mov      x0, x23
0x0001c9ec  bl       #0x2480c   ; call _objc_release
0x0001c9f0  b        #0x1ca0c   ; call sub_1ca0c
0x0001c9f4  b        #0x1c9f8   ; call sub_1c9f8
0x0001c9f8  mov      x22, x0
0x0001c9fc  b        #0x1ca0c   ; call sub_1ca0c
0x0001ca00  mov      x22, x0
0x0001ca04  mov      x0, x21
0x0001ca08  bl       #0x2480c   ; call _objc_release
0x0001ca0c  mov      x0, x20
0x0001ca10  bl       #0x2480c   ; call _objc_release
0x0001ca14  mov      x0, x19
0x0001ca18  bl       #0x2480c   ; call _objc_release
0x0001ca1c  b        #0x1ca24   ; call sub_1ca24
0x0001ca20  mov      x22, x0
0x0001ca24  mov      x0, x22
0x0001ca28  bl       #0x24470   ; call __Unwind_Resume
0x0001ca2c  stp      x28, x27, [sp, #-0x60]!
0x0001ca30  stp      x26, x25, [sp, #0x10]
0x0001ca34  stp      x24, x23, [sp, #0x20]
0x0001ca38  stp      x22, x21, [sp, #0x30]
0x0001ca3c  stp      x20, x19, [sp, #0x40]
0x0001ca40  stp      x29, x30, [sp, #0x50]
0x0001ca44  add      x29, sp, #0x50
0x0001ca48  mov      x19, x2
0x0001ca4c  mov      x21, x0
0x0001ca50  mov      x0, x2
0x0001ca54  bl       #0x24818   ; call _objc_retain
0x0001ca58  mov      x0, x21
0x0001ca5c  bl       #0x28120   ; objc_msgSend: vietnamese
0x0001ca60  cbz      w0, #0x1cabc
0x0001ca64  mov      x0, x21
0x0001ca68  bl       #0x28220   ; objc_msgSend: word
0x0001ca6c  mov      x29, x29
0x0001ca70  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ca74  mov      x22, x0
0x0001ca78  bl       #0x25fa0   ; objc_msgSend: length
0x0001ca7c  add      x8, x0, #1
0x0001ca80  cmp      x8, #0xb
0x0001ca84  b.hi     #0x1cac4
0x0001ca88  mov      x0, x21
0x0001ca8c  bl       #0x28220   ; objc_msgSend: word
0x0001ca90  mov      x29, x29
0x0001ca94  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ca98  mov      x23, x0
0x0001ca9c  mov      x1, x19
0x0001caa0  bl       #0x17538   ; call _ABTelexApply
0x0001caa4  mov      x29, x29
0x0001caa8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001caac  mov      x20, x0
0x0001cab0  mov      x0, x23
0x0001cab4  bl       #0x2480c   ; call _objc_release
0x0001cab8  b        #0x1cac8   ; call sub_1cac8
0x0001cabc  mov      x20, #0
0x0001cac0  b        #0x1cad0   ; call sub_1cad0
0x0001cac4  mov      x20, #0
0x0001cac8  mov      x0, x22
0x0001cacc  bl       #0x2480c   ; call _objc_release
0x0001cad0  adrp     x8, #0x3e000
0x0001cad4  ldr      x0, [x8, #0x400]   ; -> [class(NSCharacterSet)]
0x0001cad8  bl       #0x25fc0   ; objc_msgSend: letterCharacterSet
0x0001cadc  mov      x29, x29
0x0001cae0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001cae4  mov      x23, x0
0x0001cae8  mov      x0, x19
0x0001caec  mov      x2, #0
0x0001caf0  bl       #0x25140   ; objc_msgSend: characterAtIndex:
0x0001caf4  mov      x2, x0
0x0001caf8  mov      x0, x23
