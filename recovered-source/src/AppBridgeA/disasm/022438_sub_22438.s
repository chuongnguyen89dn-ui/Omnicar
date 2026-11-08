; ==== sub_22438 @ 0x22438..0x22580 (328 bytes) ====
0x00022438  adrp     x8, #0x3e000
0x0002243c  ldr      d1, [x8, #0xb80]
0x00022440  fadd     d0, d1, d0
0x00022444  str      d0, [x8, #0xb80]
0x00022448  adrp     x8, #0x3e000
0x0002244c  ldr      d0, [x8, #0xb78]
0x00022450  adrp     x9, #0x2b000
0x00022454  ldr      d1, [x9, #0x438]
0x00022458  fmul     d1, d8, d1
0x0002245c  fcmp     d0, d1
0x00022460  fcsel    d0, d1, d0, mi
0x00022464  str      d0, [x8, #0xb78]
0x00022468  bl       #0x200f4   ; call sub_200f4
0x0002246c  cbz      x0, #0x2249c
0x00022470  ldrb     w8, [x0, #0x400]
0x00022474  cbz      w8, #0x2249c
0x00022478  adrp     x8, #0x3e000
0x0002247c  ldr      x8, [x8, #0x290]   ; -> [class(NSString)]
0x00022480  add      x2, x0, #0x400
0x00022484  mov      x0, x8
0x00022488  bl       #0x27d40   ; objc_msgSend: stringWithUTF8String:
0x0002248c  mov      x29, x29
0x00022490  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022494  mov      x19, x0
0x00022498  b        #0x224a4   ; call sub_224a4
0x0002249c  adrp     x19, #0x35000
0x000224a0  add      x19, x19, #0x90   ; -> @"-"
0x000224a4  adrp     x8, #0x3e000
0x000224a8  ldr      x20, [x8, #0x2a0]   ; -> [class(NSNumber)]
0x000224ac  adrp     x22, #0x3e000
0x000224b0  ldr      x0, [x22, #0xaf0]
0x000224b4  mov      x2, x19
0x000224b8  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000224bc  mov      x29, x29
0x000224c0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000224c4  mov      x21, x0
0x000224c8  bl       #0x25bc0   ; objc_msgSend: integerValue
0x000224cc  add      x2, x0, #1
0x000224d0  mov      x0, x20
0x000224d4  bl       #0x26340   ; objc_msgSend: numberWithInteger:
0x000224d8  mov      x29, x29
0x000224dc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000224e0  mov      x20, x0
0x000224e4  ldr      x0, [x22, #0xaf0]
0x000224e8  mov      x2, x20
0x000224ec  mov      x3, x19
0x000224f0  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x000224f4  mov      x0, x20
0x000224f8  bl       #0x2480c   ; call _objc_release
0x000224fc  mov      x0, x21
0x00022500  bl       #0x2480c   ; call _objc_release
0x00022504  adrp     x20, #0x3e000
0x00022508  add      x20, x20, #0xbf0
0x0002250c  ldur     q0, [x20, #8]
0x00022510  str      q0, [x20]
0x00022514  bl       #0x2235c   ; call sub_2235c
0x00022518  str      d0, [x20, #0x10]
0x0002251c  fmov     d0, #2.00000000
0x00022520  fcmp     d8, d0
0x00022524  b.lt     #0x22568
0x00022528  adrp     x8, #0x3e000
0x0002252c  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x00022530  str      x19, [sp, #8]
0x00022534  str      d8, [sp]
0x00022538  adrp     x2, #0x38000
0x0002253c  add      x2, x2, #0x2f0   ; -> @"CarPlay do %.1fs (OmniCar gan nhat: %@)"
0x00022540  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00022544  mov      x29, x29
0x00022548  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0002254c  mov      x20, x0
0x00022550  adrp     x0, #0x37000
0x00022554  add      x0, x0, #0xd50   ; -> @"Core"
0x00022558  mov      x1, x20
0x0002255c  bl       #0x1dd30   ; call _OMCLogWrite
0x00022560  mov      x0, x20
0x00022564  bl       #0x2480c   ; call _objc_release
0x00022568  mov      x0, x19
0x0002256c  ldp      x29, x30, [sp, #0x40]
0x00022570  ldp      x20, x19, [sp, #0x30]
0x00022574  ldp      x22, x21, [sp, #0x20]
0x00022578  ldp      d9, d8, [sp, #0x10]
0x0002257c  add      sp, sp, #0x50
