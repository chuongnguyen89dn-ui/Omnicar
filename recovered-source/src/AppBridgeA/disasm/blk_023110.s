; block literal @0x34d30 desc @0x34d10 sig=v24@?0@8@16 flags=0x50000000
; ==== sub_23110 @ 0x23110..0x2358c (1148 bytes) ====
0x00023110  stp      x29, x30, [sp, #-0x10]!
0x00023114  mov      x29, sp
0x00023118  bl       #0x2235c   ; call sub_2235c
0x0002311c  adrp     x8, #0x3e000
0x00023120  ldr      d1, [x8, #0xb70]
0x00023124  fcmp     d1, #0.0
0x00023128  b.le     #0x231a4
0x0002312c  fsub     d1, d0, d1
0x00023130  adrp     x9, #0x3e000
0x00023134  ldr      d3, [x9, #0xb50]
0x00023138  fmov     d2, #1.50000000
0x0002313c  fmul     d4, d3, d2
0x00023140  fmov     d2, xzr
0x00023144  fcmp     d1, d4
0x00023148  b.le     #0x2315c
0x0002314c  fdiv     d2, d1, d3
0x00023150  frinta   d2, d2
0x00023154  fmov     d3, #-1.00000000
0x00023158  fadd     d2, d2, d3
0x0002315c  fmov     d3, #1.00000000
0x00023160  fadd     d3, d2, d3
0x00023164  adrp     x9, #0x3e000
0x00023168  ldr      d4, [x9, #0xb68]
0x0002316c  fadd     d3, d4, d3
0x00023170  str      d3, [x9, #0xb68]
0x00023174  adrp     x9, #0x3e000
0x00023178  ldr      d3, [x9, #0xb60]
0x0002317c  fadd     d2, d2, d3
0x00023180  str      d2, [x9, #0xb60]
0x00023184  adrp     x9, #0x3e000
0x00023188  ldr      d2, [x9, #0xb58]
0x0002318c  adrp     x10, #0x2b000
0x00023190  ldr      d3, [x10, #0x438]
0x00023194  fmul     d1, d1, d3
0x00023198  fcmp     d2, d1
0x0002319c  fcsel    d1, d1, d2, mi
0x000231a0  str      d1, [x9, #0xb58]
0x000231a4  str      d0, [x8, #0xb70]
0x000231a8  ldp      x29, x30, [sp], #0x10
0x000231ac  ret      
0x000231b0  stp      x28, x27, [sp, #-0x60]!
0x000231b4  stp      x26, x25, [sp, #0x10]
0x000231b8  stp      x24, x23, [sp, #0x20]
0x000231bc  stp      x22, x21, [sp, #0x30]
0x000231c0  stp      x20, x19, [sp, #0x40]
0x000231c4  stp      x29, x30, [sp, #0x50]
0x000231c8  add      x29, sp, #0x50
0x000231cc  sub      sp, sp, #0x1b0
0x000231d0  mov      x20, x1
0x000231d4  mov      x19, x0
0x000231d8  adrp     x8, #0x34000
0x000231dc  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x000231e0  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x000231e4  stur     x8, [x29, #-0x60]
0x000231e8  bl       #0x24818   ; call _objc_retain
0x000231ec  mov      x0, x20
0x000231f0  bl       #0x24818   ; call _objc_retain
0x000231f4  movi     v0.16b, #0
0x000231f8  stp      q0, q0, [sp, #0x60]
0x000231fc  stp      q0, q0, [sp, #0x80]
0x00023200  adrp     x0, #0x39000
0x00023204  add      x0, x0, #0x528
0x00023208  add      x2, sp, #0x60
0x0002320c  sub      x3, x29, #0xe0
0x00023210  mov      w4, #0x10
0x00023214  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00023218  mov      x27, x0
0x0002321c  cbz      x0, #0x233e4
0x00023220  ldr      x8, [sp, #0x70]
0x00023224  ldr      x21, [x8]   ; -> [got:___objc_personality_v0]
0x00023228  adrp     x26, #0x3e000
0x0002322c  adrp     x24, #0x3e000
0x00023230  adrp     x22, #0x38000
0x00023234  add      x22, x22, #0x710   ; -> @"nil"
0x00023238  adrp     x23, #0x38000
0x0002323c  add      x23, x23, #0x9d0   ; -> @"(null)"
0x00023240  str      x19, [sp, #0x18]
0x00023244  str      x21, [sp, #8]
0x00023248  mov      x28, #0
0x0002324c  str      x27, [sp, #0x10]
0x00023250  ldr      x8, [sp, #0x70]
0x00023254  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00023258  cmp      x8, x21
0x0002325c  b.eq     #0x2326c
0x00023260  adrp     x0, #0x39000
0x00023264  add      x0, x0, #0x528
0x00023268  bl       #0x24770   ; call _objc_enumerationMutation
0x0002326c  ldr      x8, [sp, #0x68]
0x00023270  ldr      x2, [x8, x28, lsl #3]   ; -> [got:___objc_personality_v0]
0x00023274  mov      x0, x19
0x00023278  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x0002327c  mov      x29, x29
0x00023280  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00023284  mov      x25, x0
0x00023288  ldr      x0, [x26, #0x310]   ; -> [class(NSDictionary)]
0x0002328c  bl       #0x247d0   ; call _objc_opt_class
0x00023290  mov      x1, x0
0x00023294  mov      x0, x25
0x00023298  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0002329c  tbz      w0, #0, #0x23398
0x000232a0  movi     v0.16b, #0
0x000232a4  stp      q0, q0, [sp, #0x40]
0x000232a8  stp      q0, q0, [sp, #0x20]
0x000232ac  mov      x0, x20
0x000232b0  bl       #0x24818   ; call _objc_retain
0x000232b4  add      x2, sp, #0x20
0x000232b8  add      x3, sp, #0xa0
0x000232bc  mov      x0, x20
0x000232c0  mov      w4, #0x10
0x000232c4  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x000232c8  cbz      x0, #0x23384
0x000232cc  mov      x26, x0
0x000232d0  ldr      x8, [sp, #0x30]
0x000232d4  ldr      x21, [x8]   ; -> [got:___objc_personality_v0]
0x000232d8  mov      x19, #0
0x000232dc  ldr      x8, [sp, #0x30]
0x000232e0  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x000232e4  cmp      x8, x21
0x000232e8  b.eq     #0x232f4
0x000232ec  mov      x0, x20
0x000232f0  bl       #0x24770   ; call _objc_enumerationMutation
0x000232f4  ldr      x8, [sp, #0x28]
0x000232f8  ldr      x2, [x8, x19, lsl #3]   ; -> [got:___objc_personality_v0]
0x000232fc  mov      x0, x25
0x00023300  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00023304  mov      x29, x29
0x00023308  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0002330c  mov      x27, x0
0x00023310  ldr      x0, [x24, #0x290]   ; -> [class(NSString)]
0x00023314  bl       #0x247d0   ; call _objc_opt_class
0x00023318  mov      x1, x0
0x0002331c  mov      x0, x27
0x00023320  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x00023324  tbz      w0, #0, #0x23354
0x00023328  mov      x0, x27
0x0002332c  bl       #0x25fa0   ; objc_msgSend: length
0x00023330  cbz      x0, #0x23354
0x00023334  mov      x0, x27
0x00023338  mov      x2, x22
0x0002333c  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00023340  tbnz     w0, #0, #0x23354
0x00023344  mov      x0, x27
0x00023348  mov      x2, x23
0x0002334c  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00023350  cbz      w0, #0x233d0
0x00023354  mov      x0, x27
0x00023358  bl       #0x2480c   ; call _objc_release
0x0002335c  add      x19, x19, #1
0x00023360  cmp      x26, x19
0x00023364  b.ne     #0x232dc
0x00023368  add      x2, sp, #0x20
0x0002336c  add      x3, sp, #0xa0
0x00023370  mov      x0, x20
0x00023374  mov      w4, #0x10
0x00023378  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0002337c  mov      x26, x0
0x00023380  cbnz     x0, #0x232d8
0x00023384  mov      x0, x20
0x00023388  bl       #0x2480c   ; call _objc_release
0x0002338c  ldp      x27, x19, [sp, #0x10]
0x00023390  ldr      x21, [sp, #8]
0x00023394  adrp     x26, #0x3e000
0x00023398  mov      x0, x25
0x0002339c  bl       #0x2480c   ; call _objc_release
0x000233a0  add      x28, x28, #1
0x000233a4  cmp      x28, x27
0x000233a8  b.ne     #0x23250
0x000233ac  add      x2, sp, #0x60
0x000233b0  sub      x3, x29, #0xe0
0x000233b4  adrp     x0, #0x39000
0x000233b8  add      x0, x0, #0x528
0x000233bc  mov      w4, #0x10
0x000233c0  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x000233c4  mov      x27, x0
0x000233c8  cbnz     x0, #0x23248
0x000233cc  b        #0x233e4   ; call sub_233e4
0x000233d0  mov      x0, x20
0x000233d4  bl       #0x2480c   ; call _objc_release
0x000233d8  mov      x0, x25
0x000233dc  bl       #0x2480c   ; call _objc_release
0x000233e0  ldr      x19, [sp, #0x18]
0x000233e4  mov      x0, x20
0x000233e8  bl       #0x2480c   ; call _objc_release
0x000233ec  mov      x0, x19
0x000233f0  bl       #0x2480c   ; call _objc_release
0x000233f4  ldur     x8, [x29, #-0x60]
0x000233f8  adrp     x9, #0x34000
0x000233fc  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00023400  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x00023404  cmp      x9, x8
0x00023408  b.ne     #0x23430
0x0002340c  mov      x0, x27
0x00023410  add      sp, sp, #0x1b0
0x00023414  ldp      x29, x30, [sp, #0x50]
0x00023418  ldp      x20, x19, [sp, #0x40]
0x0002341c  ldp      x22, x21, [sp, #0x30]
0x00023420  ldp      x24, x23, [sp, #0x20]
0x00023424  ldp      x26, x25, [sp, #0x10]
0x00023428  ldp      x28, x27, [sp], #0x60
0x0002342c  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x00023430  bl       #0x24488   ; call ___stack_chk_fail
0x00023434  sub      sp, sp, #0x120
0x00023438  stp      x26, x25, [sp, #0xd0]
0x0002343c  stp      x24, x23, [sp, #0xe0]
0x00023440  stp      x22, x21, [sp, #0xf0]
0x00023444  stp      x20, x19, [sp, #0x100]
0x00023448  stp      x29, x30, [sp, #0x110]
0x0002344c  add      x29, sp, #0x110
0x00023450  adrp     x8, #0x34000
0x00023454  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00023458  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0002345c  stur     x8, [x29, #-0x48]
0x00023460  adrp     x8, #0x3e000
0x00023464  ldr      x0, [x8, #0x398]   ; -> [class(NSMutableDictionary)]
0x00023468  bl       #0x25580   ; objc_msgSend: dictionary
0x0002346c  mov      x29, x29
0x00023470  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00023474  mov      x19, x0
0x00023478  movi     v0.16b, #0
0x0002347c  stp      q0, q0, [sp]
0x00023480  stp      q0, q0, [sp, #0x20]
0x00023484  bl       #0x23688   ; call _OMCProfileKeys
0x00023488  mov      x29, x29
0x0002348c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00023490  mov      x20, x0
0x00023494  mov      x2, sp
0x00023498  add      x3, sp, #0x48
0x0002349c  mov      w4, #0x10
0x000234a0  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x000234a4  cbz      x0, #0x23534
0x000234a8  mov      x21, x0
0x000234ac  ldr      x8, [sp, #0x10]
0x000234b0  ldr      x24, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x000234b4  mov      x25, #0
0x000234b8  ldr      x8, [sp, #0x10]
0x000234bc  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x000234c0  cmp      x8, x24
0x000234c4  b.eq     #0x234d0
0x000234c8  mov      x0, x20
0x000234cc  bl       #0x24770   ; call _objc_enumerationMutation
0x000234d0  ldr      x8, [sp, #8]
0x000234d4  ldr      x22, [x8, x25, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x000234d8  mov      x0, x22
0x000234dc  mov      x1, #0
0x000234e0  bl       #0x1d680   ; call _OMCPref
0x000234e4  mov      x29, x29
0x000234e8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000234ec  mov      x23, x0
0x000234f0  cbz      x0, #0x23504
0x000234f4  mov      x0, x19
0x000234f8  mov      x2, x23
0x000234fc  mov      x3, x22
0x00023500  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00023504  mov      x0, x23
0x00023508  bl       #0x2480c   ; call _objc_release
0x0002350c  add      x25, x25, #1
0x00023510  cmp      x21, x25
0x00023514  b.ne     #0x234b8
0x00023518  mov      x2, sp
0x0002351c  add      x3, sp, #0x48
0x00023520  mov      x0, x20
0x00023524  mov      w4, #0x10
0x00023528  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0002352c  mov      x21, x0
0x00023530  cbnz     x0, #0x234b4
0x00023534  mov      x0, x20
0x00023538  bl       #0x2480c   ; call _objc_release
0x0002353c  ldur     x8, [x29, #-0x48]
0x00023540  adrp     x9, #0x34000
0x00023544  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00023548  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0002354c  cmp      x9, x8
0x00023550  b.ne     #0x23574
0x00023554  mov      x0, x19
0x00023558  ldp      x29, x30, [sp, #0x110]
0x0002355c  ldp      x20, x19, [sp, #0x100]
0x00023560  ldp      x22, x21, [sp, #0xf0]
0x00023564  ldp      x24, x23, [sp, #0xe0]
0x00023568  ldp      x26, x25, [sp, #0xd0]
0x0002356c  add      sp, sp, #0x120
0x00023570  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x00023574  bl       #0x24488   ; call ___stack_chk_fail
0x00023578  adrp     x0, #0x3e000
0x0002357c  add      x0, x0, #0xb18
0x00023580  adrp     x1, #0x34000
0x00023584  add      x1, x1, #0xc30
0x00023588  b        #0x24578   ; call _dispatch_once

