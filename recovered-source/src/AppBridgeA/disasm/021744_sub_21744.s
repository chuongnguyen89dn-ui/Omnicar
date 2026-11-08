; ==== sub_21744 @ 0x21744..0x217d4 (144 bytes) ====
0x00021744  sub      x3, x29, #0xf0
0x00021748  mov      x0, x22
0x0002174c  mov      w4, #0x10
0x00021750  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00021754  mov      x20, x0
0x00021758  cbnz     x0, #0x21694
0x0002175c  mov      x0, x22
0x00021760  bl       #0x2480c   ; call _objc_release
0x00021764  adrp     x0, #0x38000
0x00021768  add      x0, x0, #0x8f0   ; -> @"carProfileCurrent"
0x0002176c  mov      x1, #0
0x00021770  bl       #0x1d680   ; call _OMCPref
0x00021774  mov      x29, x29
0x00021778  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0002177c  str      x0, [sp, #0x40]
0x00021780  adrp     x8, #0x3e000
0x00021784  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x00021788  bl       #0x247d0   ; call _objc_opt_class
0x0002178c  mov      x1, x0
0x00021790  ldr      x0, [sp, #0x40]
0x00021794  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x00021798  tbz      w0, #0, #0x2181c
0x0002179c  mov      x0, x19
0x000217a0  ldr      x2, [sp, #0x40]
0x000217a4  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000217a8  mov      x29, x29
0x000217ac  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000217b0  mov      x20, x0
0x000217b4  cbz      x0, #0x2181c
0x000217b8  ldr      x0, [sp, #0x40]
0x000217bc  ldr      x2, [sp, #0x58]
0x000217c0  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x000217c4  mov      x21, x0
0x000217c8  mov      x0, x20
0x000217cc  bl       #0x2480c   ; call _objc_release
0x000217d0  tbnz     w21, #0, #0x2181c
