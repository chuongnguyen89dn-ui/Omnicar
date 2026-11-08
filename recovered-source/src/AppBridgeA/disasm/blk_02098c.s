; block literal @0x34c90 desc @0x34670 sig=v16@?0@"NSNotification"8 flags=0x50000000
; ==== sub_2098c @ 0x2098c..0x20a2c (160 bytes) ====
0x0002098c  sub      sp, sp, #0x60
0x00020990  stp      x20, x19, [sp, #0x40]
0x00020994  stp      x29, x30, [sp, #0x50]
0x00020998  add      x29, sp, #0x50
0x0002099c  mov      x0, x1
0x000209a0  bl       #0x263e0   ; objc_msgSend: object
0x000209a4  mov      x29, x29
0x000209a8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000209ac  mov      x19, x0
0x000209b0  adrp     x8, #0x3e000
0x000209b4  ldr      x0, [x8, #0x430]   ; -> [class(UIScreen)]
0x000209b8  bl       #0x260e0   ; objc_msgSend: mainScreen
0x000209bc  mov      x29, x29
0x000209c0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000209c4  mov      x20, x0
0x000209c8  bl       #0x2480c   ; call _objc_release
0x000209cc  mov      x0, x19
0x000209d0  bl       #0x2480c   ; call _objc_release
0x000209d4  cmp      x19, x20
0x000209d8  b.eq     #0x20a88
0x000209dc  adrp     x20, #0x3e000
0x000209e0  ldr      x8, [x20, #0xac8]
0x000209e4  cbz      x8, #0x20b00
0x000209e8  adrp     x19, #0x3e000
0x000209ec  ldr      x0, [x19, #0xad8]
0x000209f0  cbz      x0, #0x209fc
0x000209f4  bl       #0x2459c   ; call _dispatch_source_cancel
0x000209f8  ldr      x0, [x19, #0xad8]
0x000209fc  str      xzr, [x19, #0xad8]
0x00020a00  bl       #0x2480c   ; call _objc_release
0x00020a04  adrp     x19, #0x3e000
0x00020a08  ldr      x0, [x19, #0xad0]
0x00020a0c  bl       #0x25be0   ; objc_msgSend: invalidate
0x00020a10  ldr      x0, [x19, #0xad0]
0x00020a14  str      xzr, [x19, #0xad0]
0x00020a18  bl       #0x2480c   ; call _objc_release
0x00020a1c  adrp     x8, #0x3e000
0x00020a20  ldr      x9, [x8, #0xb48]
0x00020a24  add      x9, x9, #1
0x00020a28  str      x9, [x8, #0xb48]

