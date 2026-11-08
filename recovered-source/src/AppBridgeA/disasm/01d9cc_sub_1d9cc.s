; ==== sub_1d9cc @ 0x1d9cc..0x1e178 (1964 bytes) ====
0x0001d9cc  ldr      x26, [x8]
0x0001d9d0  adrp     x22, #0x39000
0x0001d9d4  add      x22, x22, #0x4c8
0x0001d9d8  str      x19, [sp, #0x18]
0x0001d9dc  str      x26, [sp, #8]
0x0001d9e0  mov      x25, #0
0x0001d9e4  ldr      x8, [sp, #0x70]
0x0001d9e8  ldr      x8, [x8]
0x0001d9ec  cmp      x8, x26
0x0001d9f0  b.eq     #0x1d9fc
0x0001d9f4  mov      x0, x22
0x0001d9f8  bl       #0x24770   ; call _objc_enumerationMutation
0x0001d9fc  ldr      x8, [sp, #0x68]
0x0001da00  ldr      x2, [x8, x25, lsl #3]
0x0001da04  mov      x0, x19
0x0001da08  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0001da0c  mov      x29, x29
0x0001da10  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001da14  mov      x20, x0
0x0001da18  ldr      x0, [x21, #0x310]
0x0001da1c  bl       #0x247d0   ; call _objc_opt_class
0x0001da20  mov      x1, x0
0x0001da24  mov      x0, x20
0x0001da28  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0001da2c  tbz      w0, #0, #0x1dc50
0x0001da30  movi     v0.16b, #0
0x0001da34  stp      q0, q0, [sp, #0x40]
0x0001da38  stp      q0, q0, [sp, #0x20]
0x0001da3c  mov      x0, x20
0x0001da40  bl       #0x24818   ; call _objc_retain
0x0001da44  add      x2, sp, #0x20
0x0001da48  add      x3, sp, #0xa0
0x0001da4c  mov      x0, x20
0x0001da50  mov      w4, #0x10
0x0001da54  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001da58  cbz      x0, #0x1dc40
0x0001da5c  mov      x28, x0
0x0001da60  ldr      x8, [sp, #0x30]
0x0001da64  ldr      x22, [x8]
0x0001da68  str      x23, [sp, #0x10]
0x0001da6c  mov      x21, #0
0x0001da70  ldr      x8, [sp, #0x30]
0x0001da74  ldr      x8, [x8]
0x0001da78  cmp      x8, x22
0x0001da7c  b.eq     #0x1da88
0x0001da80  mov      x0, x20
0x0001da84  bl       #0x24770   ; call _objc_enumerationMutation
0x0001da88  ldr      x8, [sp, #0x28]
0x0001da8c  ldr      x26, [x8, x21, lsl #3]
0x0001da90  ldr      x0, [x24, #0x290]
0x0001da94  bl       #0x247d0   ; call _objc_opt_class
0x0001da98  mov      x1, x0
0x0001da9c  mov      x0, x26
0x0001daa0  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0001daa4  tbz      w0, #0, #0x1dc0c
0x0001daa8  mov      x19, x24
0x0001daac  mov      x0, x26
0x0001dab0  bl       #0x26060   ; objc_msgSend: lowercaseString
0x0001dab4  mov      x29, x29
0x0001dab8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001dabc  mov      x27, x0
0x0001dac0  mov      x0, x20
0x0001dac4  mov      x2, x26
0x0001dac8  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0001dacc  mov      x29, x29
0x0001dad0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001dad4  mov      x24, x0
0x0001dad8  bl       #0x25560   ; objc_msgSend: description
0x0001dadc  mov      x29, x29
0x0001dae0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001dae4  mov      x23, x0
0x0001dae8  bl       #0x26060   ; objc_msgSend: lowercaseString
0x0001daec  mov      x29, x29
0x0001daf0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001daf4  mov      x26, x0
0x0001daf8  mov      x0, x23
0x0001dafc  bl       #0x2480c   ; call _objc_release
0x0001db00  mov      x0, x24
0x0001db04  bl       #0x2480c   ; call _objc_release
0x0001db08  mov      x0, x27
0x0001db0c  adrp     x2, #0x37000
0x0001db10  add      x2, x2, #0x990   ; -> @"wireless"
0x0001db14  bl       #0x25380   ; objc_msgSend: containsString:
0x0001db18  cbz      w0, #0x1db44
0x0001db1c  mov      x0, x26
0x0001db20  adrp     x2, #0x37000
0x0001db24  add      x2, x2, #0x9b0   ; -> @"1"
0x0001db28  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001db2c  tbnz     w0, #0, #0x1dc90
0x0001db30  mov      x0, x26
0x0001db34  adrp     x2, #0x37000
0x0001db38  add      x2, x2, #0x9d0   ; -> @"0"
0x0001db3c  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001db40  cbnz     w0, #0x1dc90
0x0001db44  mov      x0, x27
0x0001db48  adrp     x2, #0x37000
0x0001db4c  add      x2, x2, #0x9f0   ; -> @"wired"
0x0001db50  bl       #0x25380   ; objc_msgSend: containsString:
0x0001db54  cbz      w0, #0x1db80
0x0001db58  mov      x0, x26
0x0001db5c  adrp     x2, #0x37000
0x0001db60  add      x2, x2, #0x9b0   ; -> @"1"
0x0001db64  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001db68  tbnz     w0, #0, #0x1dca8
0x0001db6c  mov      x0, x26
0x0001db70  adrp     x2, #0x37000
0x0001db74  add      x2, x2, #0x9d0   ; -> @"0"
0x0001db78  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001db7c  cbnz     w0, #0x1dca8
0x0001db80  mov      x0, x27
0x0001db84  adrp     x2, #0x37000
0x0001db88  add      x2, x2, #0xa10   ; -> @"transport"
0x0001db8c  bl       #0x25380   ; objc_msgSend: containsString:
0x0001db90  cbz      w0, #0x1dbf8
0x0001db94  mov      x0, x26
0x0001db98  adrp     x2, #0x37000
0x0001db9c  add      x2, x2, #0xa30   ; -> @"wifi"
0x0001dba0  bl       #0x25380   ; objc_msgSend: containsString:
0x0001dba4  tbnz     w0, #0, #0x1dc88
0x0001dba8  mov      x0, x26
0x0001dbac  adrp     x2, #0x37000
0x0001dbb0  add      x2, x2, #0x990   ; -> @"wireless"
0x0001dbb4  bl       #0x25380   ; objc_msgSend: containsString:
0x0001dbb8  tbnz     w0, #0, #0x1dc88
0x0001dbbc  mov      x0, x26
0x0001dbc0  adrp     x2, #0x37000
0x0001dbc4  add      x2, x2, #0xa50   ; -> @"wi-fi"
0x0001dbc8  bl       #0x25380   ; objc_msgSend: containsString:
0x0001dbcc  tbnz     w0, #0, #0x1dc88
0x0001dbd0  mov      x0, x26
0x0001dbd4  adrp     x2, #0x37000
0x0001dbd8  add      x2, x2, #0xa70   ; -> @"usb"
0x0001dbdc  bl       #0x25380   ; objc_msgSend: containsString:
0x0001dbe0  tbnz     w0, #0, #0x1dcc0
0x0001dbe4  mov      x0, x26
0x0001dbe8  adrp     x2, #0x37000
0x0001dbec  add      x2, x2, #0x9f0   ; -> @"wired"
0x0001dbf0  bl       #0x25380   ; objc_msgSend: containsString:
0x0001dbf4  tbnz     w0, #0, #0x1dcc0
0x0001dbf8  mov      x0, x26
0x0001dbfc  bl       #0x2480c   ; call _objc_release
0x0001dc00  mov      x0, x27
0x0001dc04  bl       #0x2480c   ; call _objc_release
0x0001dc08  mov      x24, x19
0x0001dc0c  add      x21, x21, #1
0x0001dc10  cmp      x28, x21
0x0001dc14  b.ne     #0x1da70
0x0001dc18  add      x2, sp, #0x20
0x0001dc1c  add      x3, sp, #0xa0
0x0001dc20  mov      x0, x20
0x0001dc24  mov      w4, #0x10
0x0001dc28  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001dc2c  mov      x28, x0
0x0001dc30  adrp     x21, #0x3e000
0x0001dc34  ldp      x23, x19, [sp, #0x10]
0x0001dc38  ldr      x26, [sp, #8]
0x0001dc3c  cbnz     x0, #0x1da6c
0x0001dc40  mov      x0, x20
0x0001dc44  bl       #0x2480c   ; call _objc_release
0x0001dc48  adrp     x22, #0x39000
0x0001dc4c  add      x22, x22, #0x4c8
0x0001dc50  mov      x0, x20
0x0001dc54  bl       #0x2480c   ; call _objc_release
0x0001dc58  add      x25, x25, #1
0x0001dc5c  cmp      x25, x23
0x0001dc60  b.ne     #0x1d9e4
0x0001dc64  add      x2, sp, #0x60
0x0001dc68  sub      x3, x29, #0xe0
0x0001dc6c  mov      x0, x22
0x0001dc70  mov      w4, #0x10
0x0001dc74  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001dc78  mov      x23, x0
0x0001dc7c  cbnz     x0, #0x1d9e0
0x0001dc80  mov      w21, #-1
0x0001dc84  b        #0x1dce8   ; call sub_1dce8
0x0001dc88  mov      w21, #1
0x0001dc8c  b        #0x1dcc4   ; call sub_1dcc4
0x0001dc90  adrp     x2, #0x37000
0x0001dc94  add      x2, x2, #0x9b0   ; -> @"1"
0x0001dc98  mov      x0, x26
0x0001dc9c  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001dca0  mov      x21, x0
0x0001dca4  b        #0x1dcc4   ; call sub_1dcc4
0x0001dca8  adrp     x2, #0x37000
0x0001dcac  add      x2, x2, #0x9b0   ; -> @"1"
0x0001dcb0  mov      x0, x26
0x0001dcb4  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001dcb8  eor      w21, w0, #1
0x0001dcbc  b        #0x1dcc4   ; call sub_1dcc4
0x0001dcc0  mov      w21, #0
0x0001dcc4  mov      x0, x26
0x0001dcc8  bl       #0x2480c   ; call _objc_release
0x0001dccc  mov      x0, x27
0x0001dcd0  bl       #0x2480c   ; call _objc_release
0x0001dcd4  mov      x0, x20
0x0001dcd8  bl       #0x2480c   ; call _objc_release
0x0001dcdc  mov      x0, x20
0x0001dce0  bl       #0x2480c   ; call _objc_release
0x0001dce4  ldr      x19, [sp, #0x18]
0x0001dce8  mov      x0, x19
0x0001dcec  bl       #0x2480c   ; call _objc_release
0x0001dcf0  ldur     x8, [x29, #-0x60]
0x0001dcf4  adrp     x9, #0x34000
0x0001dcf8  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x0001dcfc  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0001dd00  cmp      x9, x8
0x0001dd04  b.ne     #0x1dd2c
0x0001dd08  mov      x0, x21
0x0001dd0c  add      sp, sp, #0x1b0
0x0001dd10  ldp      x29, x30, [sp, #0x50]
0x0001dd14  ldp      x20, x19, [sp, #0x40]
0x0001dd18  ldp      x22, x21, [sp, #0x30]
0x0001dd1c  ldp      x24, x23, [sp, #0x20]
0x0001dd20  ldp      x26, x25, [sp, #0x10]
0x0001dd24  ldp      x28, x27, [sp], #0x60
0x0001dd28  ret      
0x0001dd2c  bl       #0x24488   ; call ___stack_chk_fail
0x0001dd30  sub      sp, sp, #0xa0
0x0001dd34  stp      x26, x25, [sp, #0x50]
0x0001dd38  stp      x24, x23, [sp, #0x60]
0x0001dd3c  stp      x22, x21, [sp, #0x70]
0x0001dd40  stp      x20, x19, [sp, #0x80]
0x0001dd44  stp      x29, x30, [sp, #0x90]
0x0001dd48  add      x29, sp, #0x90
0x0001dd4c  mov      x20, x1
0x0001dd50  mov      x19, x0
0x0001dd54  bl       #0x24818   ; call _objc_retain
0x0001dd58  mov      x0, x20
0x0001dd5c  bl       #0x24818   ; call _objc_retain
0x0001dd60  bl       #0x200f4   ; call sub_200f4
0x0001dd64  cbz      x0, #0x1dd80
0x0001dd68  adrp     x1, #0x29000
0x0001dd6c  add      x1, x1, #0x94   ; -> "AppBridge"
0x0001dd70  add      x0, x0, #0x400
0x0001dd74  mov      w2, #0x40
0x0001dd78  mov      w3, #0x40
0x0001dd7c  bl       #0x24494   ; call ___strlcpy_chk
0x0001dd80  stp      x19, x20, [sp]
0x0001dd84  adrp     x0, #0x37000
0x0001dd88  add      x0, x0, #0xab0   ; -> @"[OmniCar/%@] %@"
0x0001dd8c  bl       #0x24410   ; call _NSLog
0x0001dd90  adrp     x8, #0x3e000
0x0001dd94  ldr      x8, [x8, #0xaa8]
0x0001dd98  cmn      x8, #1
0x0001dd9c  b.ne     #0x1deec
0x0001dda0  adrp     x8, #0x3e000
0x0001dda4  ldr      x21, [x8, #0x290]   ; -> [class(NSString)]
0x0001dda8  adrp     x8, #0x3e000
0x0001ddac  ldr      x22, [x8, #0xaa0]
0x0001ddb0  adrp     x8, #0x3e000
0x0001ddb4  ldr      x0, [x8, #0x418]   ; -> [class(NSDate)]
0x0001ddb8  bl       #0x25480   ; objc_msgSend: date
0x0001ddbc  mov      x29, x29
0x0001ddc0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ddc4  mov      x23, x0
0x0001ddc8  mov      x0, x22
0x0001ddcc  mov      x2, x23
0x0001ddd0  bl       #0x27cc0   ; objc_msgSend: stringFromDate:
0x0001ddd4  mov      x29, x29
0x0001ddd8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001dddc  mov      x22, x0
0x0001dde0  adrp     x8, #0x3e000
0x0001dde4  ldr      x0, [x8, #0x408]   ; -> [class(NSProcessInfo)]
0x0001dde8  bl       #0x266c0   ; objc_msgSend: processInfo
0x0001ddec  mov      x29, x29
0x0001ddf0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ddf4  mov      x24, x0
0x0001ddf8  bl       #0x266e0   ; objc_msgSend: processName
0x0001ddfc  mov      x29, x29
0x0001de00  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001de04  mov      x25, x0
0x0001de08  bl       #0x24644   ; call _getpid
0x0001de0c  stp      x19, x20, [sp, #0x18]
0x0001de10  stp      x25, x0, [sp, #8]
0x0001de14  str      x22, [sp]
0x0001de18  adrp     x2, #0x37000
0x0001de1c  add      x2, x2, #0xaf0   ; -> @"%@ [%@:%d] %@: %@
"
0x0001de20  mov      x0, x21
0x0001de24  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0001de28  mov      x29, x29
0x0001de2c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001de30  mov      x21, x0
0x0001de34  mov      x0, x25
0x0001de38  bl       #0x2480c   ; call _objc_release
0x0001de3c  mov      x0, x24
0x0001de40  bl       #0x2480c   ; call _objc_release
0x0001de44  mov      x0, x22
0x0001de48  bl       #0x2480c   ; call _objc_release
0x0001de4c  mov      x0, x23
0x0001de50  bl       #0x2480c   ; call _objc_release
0x0001de54  bl       #0x1df38   ; call sub_1df38
0x0001de58  mov      x29, x29
0x0001de5c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001de60  mov      x22, x0
0x0001de64  adrp     x8, #0x34000
0x0001de68  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x0001de6c  str      x8, [sp, #0x28]
0x0001de70  adrp     x8, #0x2b000
0x0001de74  ldr      d0, [x8, #0x1d0]
0x0001de78  adrp     x8, #0x1d000
0x0001de7c  add      x8, x8, #0xf7c
0x0001de80  str      d0, [sp, #0x30]
0x0001de84  adrp     x9, #0x34000
0x0001de88  add      x9, x9, #0xba0
0x0001de8c  stp      x8, x9, [sp, #0x38]
0x0001de90  str      x21, [sp, #0x48]
0x0001de94  mov      x0, x21
0x0001de98  bl       #0x24818   ; call _objc_retain
0x0001de9c  add      x1, sp, #0x28
0x0001dea0  mov      x0, x22
0x0001dea4  bl       #0x24554   ; call _dispatch_async
0x0001dea8  mov      x0, x22
0x0001deac  bl       #0x2480c   ; call _objc_release
0x0001deb0  ldr      x0, [sp, #0x48]
0x0001deb4  bl       #0x2480c   ; call _objc_release
0x0001deb8  mov      x0, x21
0x0001debc  bl       #0x2480c   ; call _objc_release
0x0001dec0  mov      x0, x20
0x0001dec4  bl       #0x2480c   ; call _objc_release
0x0001dec8  mov      x0, x19
0x0001decc  bl       #0x2480c   ; call _objc_release
0x0001ded0  ldp      x29, x30, [sp, #0x90]
0x0001ded4  ldp      x20, x19, [sp, #0x80]
0x0001ded8  ldp      x22, x21, [sp, #0x70]
0x0001dedc  ldp      x24, x23, [sp, #0x60]
0x0001dee0  ldp      x26, x25, [sp, #0x50]
0x0001dee4  add      sp, sp, #0xa0
0x0001dee8  ret      
0x0001deec  bl       #0x24218   ; call sub_24218
0x0001def0  b        #0x1dda0   ; call sub_1dda0
0x0001def4  stp      x20, x19, [sp, #-0x20]!
0x0001def8  stp      x29, x30, [sp, #0x10]
0x0001defc  add      x29, sp, #0x10
0x0001df00  adrp     x8, #0x3e000
0x0001df04  ldr      x0, [x8, #0x410]   ; -> [class(NSDateFormatter)]
0x0001df08  bl       #0x247e8   ; call _objc_opt_new
0x0001df0c  adrp     x19, #0x3e000
0x0001df10  ldr      x8, [x19, #0xaa0]
0x0001df14  str      x0, [x19, #0xaa0]
0x0001df18  mov      x0, x8
0x0001df1c  bl       #0x2480c   ; call _objc_release
0x0001df20  ldr      x0, [x19, #0xaa0]
0x0001df24  adrp     x2, #0x37000
0x0001df28  add      x2, x2, #0xad0   ; -> @"yyyy-MM-dd HH:mm:ss.SSS"
0x0001df2c  ldp      x29, x30, [sp, #0x10]
0x0001df30  ldp      x20, x19, [sp], #0x20
0x0001df34  b        #0x26e60   ; objc_msgSend: setDateFormat:
0x0001df38  stp      x20, x19, [sp, #-0x20]!
0x0001df3c  stp      x29, x30, [sp, #0x10]
0x0001df40  add      x29, sp, #0x10
0x0001df44  adrp     x8, #0x3e000
0x0001df48  ldr      x8, [x8, #0xb08]
0x0001df4c  cmn      x8, #1
0x0001df50  b.ne     #0x1df74
0x0001df54  adrp     x8, #0x3e000
0x0001df58  ldr      x19, [x8, #0xb00]
0x0001df5c  mov      x0, x19
0x0001df60  bl       #0x24818   ; call _objc_retain
0x0001df64  mov      x0, x19
0x0001df68  ldp      x29, x30, [sp, #0x10]
0x0001df6c  ldp      x20, x19, [sp], #0x20
0x0001df70  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x0001df74  bl       #0x2422c   ; call sub_2422c
0x0001df78  b        #0x1df54   ; call sub_1df54
0x0001df7c  sub      sp, sp, #0x50
0x0001df80  stp      x22, x21, [sp, #0x20]
0x0001df84  stp      x20, x19, [sp, #0x30]
0x0001df88  stp      x29, x30, [sp, #0x40]
0x0001df8c  add      x29, sp, #0x40
0x0001df90  mov      x19, x0
0x0001df94  adrp     x8, #0x34000
0x0001df98  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0001df9c  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0001dfa0  str      x8, [sp, #0x18]
0x0001dfa4  adrp     x20, #0x3e000
0x0001dfa8  ldr      x8, [x20, #0xb18]
0x0001dfac  cmn      x8, #1
0x0001dfb0  b.ne     #0x1e080
0x0001dfb4  adrp     x21, #0x3e000
0x0001dfb8  ldrb     w8, [x21, #0xb10]
0x0001dfbc  cmp      w8, #1
0x0001dfc0  b.ne     #0x1dfc8
0x0001dfc4  bl       #0x1e094   ; call sub_1e094
0x0001dfc8  ldr      x0, [x19, #0x20]   ; -> [@selector(timeZoneForSecondsFromGMT:)]
0x0001dfcc  bl       #0x1e154   ; call sub_1e154
0x0001dfd0  tbnz     w0, #0, #0x1e054
0x0001dfd4  ldr      x8, [x20, #0xb18]
0x0001dfd8  cmn      x8, #1
0x0001dfdc  b.ne     #0x1e088
0x0001dfe0  ldrb     w8, [x21, #0xb10]
0x0001dfe4  tbnz     w8, #0, #0x1e054
0x0001dfe8  bl       #0x1e1c4   ; call sub_1e1c4
0x0001dfec  mov      x29, x29
0x0001dff0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001dff4  mov      x20, x0
0x0001dff8  adrp     x8, #0x37000
0x0001dffc  add      x9, x8, #0xb30   ; -> @"line"
0x0001e000  ldr      x8, [x19, #0x20]   ; -> [@selector(timeZoneForSecondsFromGMT:)]
0x0001e004  stp      x9, x8, [sp, #8]
0x0001e008  adrp     x8, #0x3e000
0x0001e00c  ldr      x0, [x8, #0x310]   ; -> [class(NSDictionary)]
0x0001e010  add      x2, sp, #0x10
0x0001e014  add      x3, sp, #8
0x0001e018  mov      w4, #1
0x0001e01c  bl       #0x255c0   ; objc_msgSend: dictionaryWithObjects:forKeys:count:
0x0001e020  mov      x29, x29
0x0001e024  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e028  mov      x19, x0
0x0001e02c  adrp     x2, #0x37000
0x0001e030  add      x2, x2, #0xb10   ; -> @"com.anlai.omnicar/log"
0x0001e034  mov      x0, x20
0x0001e038  mov      x3, #0
0x0001e03c  mov      x4, x19
0x0001e040  bl       #0x26620   ; objc_msgSend: postNotificationName:object:userInfo:
0x0001e044  mov      x0, x19
0x0001e048  bl       #0x2480c   ; call _objc_release
0x0001e04c  mov      x0, x20
0x0001e050  bl       #0x2480c   ; call _objc_release
0x0001e054  ldr      x8, [sp, #0x18]
0x0001e058  adrp     x9, #0x34000
0x0001e05c  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x0001e060  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0001e064  cmp      x9, x8
0x0001e068  b.ne     #0x1e090
0x0001e06c  ldp      x29, x30, [sp, #0x40]
0x0001e070  ldp      x20, x19, [sp, #0x30]
0x0001e074  ldp      x22, x21, [sp, #0x20]
0x0001e078  add      sp, sp, #0x50
0x0001e07c  ret      
0x0001e080  bl       #0x24240   ; call sub_24240
0x0001e084  b        #0x1dfb4   ; call sub_1dfb4
0x0001e088  bl       #0x24244   ; call sub_24244
0x0001e08c  b        #0x1dfe0   ; call sub_1dfe0
0x0001e090  bl       #0x24488   ; call ___stack_chk_fail
0x0001e094  stp      x22, x21, [sp, #-0x30]!
0x0001e098  stp      x20, x19, [sp, #0x10]
0x0001e09c  stp      x29, x30, [sp, #0x20]
0x0001e0a0  add      x29, sp, #0x20
0x0001e0a4  adrp     x8, #0x3e000
0x0001e0a8  ldr      x0, [x8, #0x428]   ; -> [class(NSFileManager)]
0x0001e0ac  bl       #0x254e0   ; objc_msgSend: defaultManager
0x0001e0b0  mov      x29, x29
0x0001e0b4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e0b8  mov      x19, x0
0x0001e0bc  adrp     x2, #0x37000
0x0001e0c0  add      x2, x2, #0xa90   ; -> @"/var/mobile/Documents/OmniCar.log"
0x0001e0c4  mov      x3, #0
0x0001e0c8  bl       #0x24e40   ; objc_msgSend: attributesOfItemAtPath:error:
0x0001e0cc  mov      x29, x29
0x0001e0d0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e0d4  mov      x20, x0
0x0001e0d8  bl       #0x25720   ; objc_msgSend: fileSize
0x0001e0dc  mov      x21, x0
0x0001e0e0  mov      x0, x20
0x0001e0e4  bl       #0x2480c   ; call _objc_release
0x0001e0e8  cmp      x21, #0x200, lsl #12
0x0001e0ec  b.lo     #0x1e140
0x0001e0f0  adrp     x20, #0x37000
0x0001e0f4  add      x20, x20, #0xa90   ; -> @"/var/mobile/Documents/OmniCar.log"
0x0001e0f8  adrp     x2, #0x37000
0x0001e0fc  add      x2, x2, #0xf70   ; -> @".old"
0x0001e100  mov      x0, x20
0x0001e104  bl       #0x27c80   ; objc_msgSend: stringByAppendingString:
0x0001e108  mov      x29, x29
0x0001e10c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e110  mov      x21, x0
0x0001e114  mov      x0, x19
0x0001e118  mov      x2, x21
0x0001e11c  mov      x3, #0
0x0001e120  bl       #0x26860   ; objc_msgSend: removeItemAtPath:error:
0x0001e124  mov      x0, x19
0x0001e128  mov      x2, x20
0x0001e12c  mov      x3, x21
0x0001e130  mov      x4, #0
0x0001e134  bl       #0x261a0   ; objc_msgSend: moveItemAtPath:toPath:error:
0x0001e138  mov      x0, x21
0x0001e13c  bl       #0x2480c   ; call _objc_release
0x0001e140  mov      x0, x19
0x0001e144  ldp      x29, x30, [sp, #0x20]
0x0001e148  ldp      x20, x19, [sp, #0x10]
0x0001e14c  ldp      x22, x21, [sp], #0x30
0x0001e150  b        #0x2480c   ; call _objc_release
0x0001e154  stp      x20, x19, [sp, #-0x20]!
0x0001e158  stp      x29, x30, [sp, #0x10]
0x0001e15c  add      x29, sp, #0x10
0x0001e160  mov      x19, x0
0x0001e164  bl       #0x24818   ; call _objc_retain
0x0001e168  adrp     x0, #0x37000
0x0001e16c  add      x0, x0, #0xa90   ; -> @"/var/mobile/Documents/OmniCar.log"
0x0001e170  bl       #0x25740   ; objc_msgSend: fileSystemRepresentation
0x0001e174  adrp     x1, #0x2a000
