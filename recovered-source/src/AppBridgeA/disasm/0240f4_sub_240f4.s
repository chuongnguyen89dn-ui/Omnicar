; ==== sub_240f4 @ 0x240f4..0x24138 (68 bytes) ====
0x000240f4  bl       #0x27920   ; objc_msgSend: setTimeZone:
0x000240f8  mov      x0, x20
0x000240fc  bl       #0x2480c   ; call _objc_release
0x00024100  adrp     x2, #0x38000
0x00024104  add      x2, x2, #0xe10   ; -> @"yyyy-MM-dd"
0x00024108  mov      x0, x19
0x0002410c  bl       #0x26e60   ; objc_msgSend: setDateFormat:
0x00024110  adrp     x2, #0x38000
0x00024114  add      x2, x2, #0xdd0   ; -> @"2027-04-30"
0x00024118  mov      x0, x19
0x0002411c  bl       #0x254a0   ; objc_msgSend: dateFromString:
0x00024120  mov      x29, x29
0x00024124  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00024128  mov      x20, x0
0x0002412c  cbz      x0, #0x2414c
0x00024130  mov      x0, x20
0x00024134  bl       #0x27f40   ; objc_msgSend: timeIntervalSince1970
