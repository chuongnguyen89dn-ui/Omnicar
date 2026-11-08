; === sub_cef8 @ 0xcef8 size=256 ===
0x0000cef8  stp      x20, x19, [sp, #-0x20]!
0x0000cefc  stp      x29, x30, [sp, #0x10]
0x0000cf00  add      x29, sp, #0x10
0x0000cf04  adrp     x0, #0x16000
0x0000cf08  add      x0, x0, #0xc48 ; -> CFSTR("2027-04-30")
0x0000cf0c  bl       #0xdce0 ; call objc_stub[length]
0x0000cf10  cbz      x0, #0xcfec
0x0000cf14  adrp     x8, #0x18000
0x0000cf18  ldr      x0, [x8, #0x430] ; -> [classref(NSDateFormatter)]
0x0000cf1c  bl       #0xd494 ; call stub:_objc_opt_new
0x0000cf20  mov      x19, x0
0x0000cf24  adrp     x8, #0x18000
0x0000cf28  ldr      x0, [x8, #0x438] ; -> [classref(NSLocale)]
0x0000cf2c  adrp     x2, #0x14000
0x0000cf30  add      x2, x2, #0x9c8 ; -> CFSTR("en_US_POSIX")
0x0000cf34  bl       #0xdd00 ; call objc_stub[localeWithLocaleIdentifier:]
0x0000cf38  mov      x29, x29
0x0000cf3c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000cf40  mov      x20, x0
0x0000cf44  mov      x0, x19
0x0000cf48  mov      x2, x20
0x0000cf4c  bl       #0xe280 ; call objc_stub[setLocale:]
0x0000cf50  mov      x0, x20
0x0000cf54  bl       #0xd4b8 ; call stub:_objc_release
0x0000cf58  adrp     x8, #0x18000
0x0000cf5c  ldr      x0, [x8, #0x440] ; -> [classref(NSTimeZone)]
0x0000cf60  mov      w2, #0x6270
0x0000cf64  bl       #0xe520 ; call objc_stub[timeZoneForSecondsFromGMT:]
0x0000cf68  mov      x29, x29
0x0000cf6c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000cf70  mov      x20, x0
0x0000cf74  mov      x0, x19
0x0000cf78  mov      x2, x20
0x0000cf7c  bl       #0xe300 ; call objc_stub[setTimeZone:]
0x0000cf80  mov      x0, x20
0x0000cf84  bl       #0xd4b8 ; call stub:_objc_release
0x0000cf88  adrp     x2, #0x16000
0x0000cf8c  add      x2, x2, #0xc68 ; -> CFSTR("yyyy-MM-dd")
0x0000cf90  mov      x0, x19
0x0000cf94  bl       #0xe220 ; call objc_stub[setDateFormat:]
0x0000cf98  adrp     x2, #0x16000
0x0000cf9c  add      x2, x2, #0xc48 ; -> CFSTR("2027-04-30")
0x0000cfa0  mov      x0, x19
0x0000cfa4  bl       #0xda00 ; call objc_stub[dateFromString:]
0x0000cfa8  mov      x29, x29
0x0000cfac  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000cfb0  mov      x20, x0
0x0000cfb4  cbz      x0, #0xcfd4
0x0000cfb8  mov      x0, x20
0x0000cfbc  bl       #0xe4e0 ; call objc_stub[timeIntervalSince1970]
0x0000cfc0  adrp     x8, #0xf000
0x0000cfc4  ldr      d1, [x8, #0xb58] ; -> [__TEXT,__const+0xa8 [u64=0x40f5180000000000 f64=86400.0]]
0x0000cfc8  fadd     d0, d0, d1
0x0000cfcc  adrp     x8, #0x18000
0x0000cfd0  str      d0, [x8, #0x728]
0x0000cfd4  mov      x0, x20
0x0000cfd8  bl       #0xd4b8 ; call stub:_objc_release
0x0000cfdc  mov      x0, x19
0x0000cfe0  ldp      x29, x30, [sp, #0x10]
0x0000cfe4  ldp      x20, x19, [sp], #0x20
0x0000cfe8  b        #0xd4b8 ; call stub:_objc_release
0x0000cfec  ldp      x29, x30, [sp, #0x10]
0x0000cff0  ldp      x20, x19, [sp], #0x20
0x0000cff4  ret      
