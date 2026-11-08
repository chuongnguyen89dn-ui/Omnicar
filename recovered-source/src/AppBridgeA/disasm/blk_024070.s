; block literal @0x34d90 desc @0x34610 sig=v8@?0 flags=0x50000000
; ==== sub_24070 @ 0x24070..0x240f4 (132 bytes) ====
0x00024070  stp      x20, x19, [sp, #-0x20]!
0x00024074  stp      x29, x30, [sp, #0x10]
0x00024078  add      x29, sp, #0x10
0x0002407c  adrp     x0, #0x38000
0x00024080  add      x0, x0, #0xdd0   ; -> @"2027-04-30"
0x00024084  bl       #0x25fa0   ; objc_msgSend: length
0x00024088  cbz      x0, #0x24164
0x0002408c  adrp     x8, #0x3e000
0x00024090  ldr      x0, [x8, #0x410]   ; -> [class(NSDateFormatter)]
0x00024094  bl       #0x247e8   ; call _objc_opt_new
0x00024098  mov      x19, x0
0x0002409c  adrp     x8, #0x3e000
0x000240a0  ldr      x0, [x8, #0x448]   ; -> [class(NSLocale)]
0x000240a4  adrp     x2, #0x38000
0x000240a8  add      x2, x2, #0xdf0   ; -> @"en_US_POSIX"
0x000240ac  bl       #0x26000   ; objc_msgSend: localeWithLocaleIdentifier:
0x000240b0  mov      x29, x29
0x000240b4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000240b8  mov      x20, x0
0x000240bc  mov      x0, x19
0x000240c0  mov      x2, x20
0x000240c4  bl       #0x27300   ; objc_msgSend: setLocale:
0x000240c8  mov      x0, x20
0x000240cc  bl       #0x2480c   ; call _objc_release
0x000240d0  adrp     x8, #0x3e000
0x000240d4  ldr      x0, [x8, #0x458]   ; -> [class(NSTimeZone)]
0x000240d8  mov      w2, #0x6270
0x000240dc  bl       #0x27f80   ; objc_msgSend: timeZoneForSecondsFromGMT:
0x000240e0  mov      x29, x29
0x000240e4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000240e8  mov      x20, x0
0x000240ec  mov      x0, x19
0x000240f0  mov      x2, x20

