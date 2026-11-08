; ==== sub_217d4 @ 0x217d4..0x21930 (348 bytes) ====
0x000217d4  bl       #0x23434   ; call sub_23434
0x000217d8  mov      x29, x29
0x000217dc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000217e0  mov      x20, x0
0x000217e4  mov      x0, x19
0x000217e8  ldr      x2, [sp, #0x40]
0x000217ec  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000217f0  mov      x29, x29
0x000217f4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000217f8  mov      x21, x0
0x000217fc  mov      x2, x20
0x00021800  adrp     x3, #0x38000
0x00021804  add      x3, x3, #0x910   ; -> @"values"
0x00021808  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x0002180c  mov      x0, x21
0x00021810  bl       #0x2480c   ; call _objc_release
0x00021814  mov      x0, x20
0x00021818  bl       #0x2480c   ; call _objc_release
0x0002181c  mov      x0, x19
0x00021820  ldr      x2, [sp, #0x58]
0x00021824  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00021828  mov      x29, x29
0x0002182c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021830  str      x0, [sp, #0x60]
0x00021834  ldr      x8, [sp, #0x60]
0x00021838  cbz      x8, #0x219a4
0x0002183c  ldr      x0, [sp, #0x40]
0x00021840  ldr      x2, [sp, #0x58]
0x00021844  bl       #0x25ca0   ; objc_msgSend: isEqual:
0x00021848  tbnz     w0, #0, #0x21a5c
0x0002184c  ldr      x0, [sp, #0x60]
0x00021850  adrp     x2, #0x38000
0x00021854  add      x2, x2, #0x910   ; -> @"values"
0x00021858  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0002185c  mov      x29, x29
0x00021860  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021864  mov      x25, x0
0x00021868  movi     v0.16b, #0
0x0002186c  stp      q0, q0, [sp, #0x220]
0x00021870  stp      q0, q0, [sp, #0x200]
0x00021874  bl       #0x23688   ; call _OMCProfileKeys
0x00021878  mov      x29, x29
0x0002187c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021880  mov      x26, x0
0x00021884  add      x2, sp, #0x200
0x00021888  add      x3, sp, #0x180
0x0002188c  mov      w4, #0x10
0x00021890  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00021894  mov      x23, x0
0x00021898  cbz      x0, #0x21944
0x0002189c  ldr      x8, [sp, #0x210]
0x000218a0  ldr      x20, [x8]
0x000218a4  mov      x27, #0
0x000218a8  ldr      x8, [sp, #0x210]
0x000218ac  ldr      x8, [x8]
0x000218b0  cmp      x8, x20
0x000218b4  b.eq     #0x218c0
0x000218b8  mov      x0, x26
0x000218bc  bl       #0x24770   ; call _objc_enumerationMutation
0x000218c0  ldr      x8, [sp, #0x208]
0x000218c4  ldr      x28, [x8, x27, lsl #3]
0x000218c8  ldr      x0, [x24, #0x310]
0x000218cc  bl       #0x247d0   ; call _objc_opt_class
0x000218d0  mov      x1, x0
0x000218d4  mov      x0, x25
0x000218d8  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x000218dc  tbz      w0, #0, #0x218fc
0x000218e0  mov      x0, x25
0x000218e4  mov      x2, x28
0x000218e8  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000218ec  mov      x29, x29
0x000218f0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000218f4  mov      x21, x0
0x000218f8  b        #0x21900   ; call sub_21900
0x000218fc  mov      x21, #0
0x00021900  mov      x0, x28
0x00021904  mov      x1, x21
0x00021908  adrp     x2, #0x37000
0x0002190c  add      x2, x2, #0x70   ; -> @"com.anlai.omnicar"
0x00021910  bl       #0x242cc   ; call _CFPreferencesSetAppValue
0x00021914  mov      x0, x21
0x00021918  bl       #0x2480c   ; call _objc_release
0x0002191c  add      x27, x27, #1
0x00021920  cmp      x23, x27
0x00021924  b.ne     #0x218a8
0x00021928  add      x2, sp, #0x200
0x0002192c  add      x3, sp, #0x180
