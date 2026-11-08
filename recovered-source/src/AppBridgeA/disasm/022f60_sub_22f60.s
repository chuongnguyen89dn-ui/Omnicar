; ==== sub_22f60 @ 0x22f60..0x240f4 (4500 bytes) ====
0x00022f60  stp      x20, x19, [sp, #0x20]
0x00022f64  stp      x29, x30, [sp, #0x30]
0x00022f68  add      x29, sp, #0x30
0x00022f6c  mov      x19, x1
0x00022f70  mov      x20, x0
0x00022f74  mov      x0, x1
0x00022f78  bl       #0x24818   ; call _objc_retain
0x00022f7c  adrp     x8, #0x3e000
0x00022f80  ldrb     w9, [x8, #0xc10]
0x00022f84  cmp      w9, w20
0x00022f88  b.eq     #0x23064
0x00022f8c  strb     w20, [x8, #0xc10]
0x00022f90  bl       #0x2235c   ; call sub_2235c
0x00022f94  adrp     x8, #0x3e000
0x00022f98  str      d0, [x8, #0xc30]
0x00022f9c  tbz      w20, #0, #0x23000
0x00022fa0  adrp     x8, #0x3e000
0x00022fa4  ldr      x9, [x8, #0xc08]
0x00022fa8  add      x9, x9, #1
0x00022fac  str      x9, [x8, #0xc08]
0x00022fb0  mov      x0, x19
0x00022fb4  bl       #0x24818   ; call _objc_retain
0x00022fb8  adrp     x8, #0x3e000
0x00022fbc  ldr      x0, [x8, #0xaf8]
0x00022fc0  str      x19, [x8, #0xaf8]
0x00022fc4  bl       #0x2480c   ; call _objc_release
0x00022fc8  mov      w0, #1
0x00022fcc  bl       #0x2205c   ; call sub_2205c
0x00022fd0  adrp     x8, #0x3e000
0x00022fd4  ldr      x22, [x8, #0x290]   ; -> [class(NSString)]
0x00022fd8  adrp     x0, #0x38000
0x00022fdc  add      x0, x0, #0x3d0   ; -> @" vi "
0x00022fe0  mov      x2, x19
0x00022fe4  bl       #0x27c80   ; objc_msgSend: stringByAppendingString:
0x00022fe8  mov      x29, x29
0x00022fec  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022ff0  mov      x21, x0
0x00022ff4  adrp     x8, #0x38000
0x00022ff8  add      x8, x8, #0x390   ; -> @"BAT"
0x00022ffc  b        #0x23020   ; call sub_23020
0x00023000  mov      w0, #0
0x00023004  bl       #0x2205c   ; call sub_2205c
0x00023008  adrp     x8, #0x3e000
0x0002300c  ldr      x22, [x8, #0x290]   ; -> [class(NSString)]
0x00023010  adrp     x21, #0x36000
0x00023014  add      x21, x21, #0x6f0   ; -> @""
0x00023018  adrp     x8, #0x38000
0x0002301c  add      x8, x8, #0x3b0   ; -> @"tat"
0x00023020  stp      x8, x21, [sp]
0x00023024  adrp     x2, #0x38000
0x00023028  add      x2, x2, #0x370   ; -> @"che do nhe tu dong: %@%@"
0x0002302c  mov      x0, x22
0x00023030  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00023034  mov      x29, x29
0x00023038  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0002303c  mov      x22, x0
0x00023040  adrp     x0, #0x37000
0x00023044  add      x0, x0, #0xd50   ; -> @"Core"
0x00023048  mov      x1, x22
0x0002304c  bl       #0x1dd30   ; call _OMCLogWrite
0x00023050  mov      x0, x22
0x00023054  bl       #0x2480c   ; call _objc_release
0x00023058  cbz      w20, #0x23064
0x0002305c  mov      x0, x21
0x00023060  bl       #0x2480c   ; call _objc_release
0x00023064  mov      x0, x19
0x00023068  ldp      x29, x30, [sp, #0x30]
0x0002306c  ldp      x20, x19, [sp, #0x20]
0x00023070  ldp      x22, x21, [sp, #0x10]
0x00023074  add      sp, sp, #0x40
0x00023078  b        #0x2480c   ; call _objc_release
0x0002307c  ldr      x8, [x0, #0x20]
0x00023080  adrp     x9, #0x3e000
0x00023084  ldr      x9, [x9, #0xb48]
0x00023088  cmp      x8, x9
0x0002308c  b.ne     #0x2310c
0x00023090  stp      x20, x19, [sp, #-0x20]!
0x00023094  stp      x29, x30, [sp, #0x10]
0x00023098  add      x29, sp, #0x10
0x0002309c  adrp     x19, #0x3e000
0x000230a0  ldr      x0, [x19, #0xad0]
0x000230a4  bl       #0x25be0   ; objc_msgSend: invalidate
0x000230a8  ldr      x0, [x19, #0xad0]
0x000230ac  str      xzr, [x19, #0xad0]
0x000230b0  bl       #0x2480c   ; call _objc_release
0x000230b4  adrp     x8, #0x3e000
0x000230b8  ldr      d0, [x8, #0xb68]
0x000230bc  adrp     x8, #0x3e000
0x000230c0  ldr      d1, [x8, #0xbe0]
0x000230c4  fsub     d0, d0, d1
0x000230c8  mov      x8, #0x4059000000000000
0x000230cc  fmov     d1, x8
0x000230d0  fcmp     d0, d1
0x000230d4  ldp      x29, x30, [sp, #0x10]
0x000230d8  ldp      x20, x19, [sp], #0x20
0x000230dc  b.lt     #0x2310c
0x000230e0  adrp     x8, #0x3e000
0x000230e4  ldr      d1, [x8, #0xb60]
0x000230e8  adrp     x8, #0x3e000
0x000230ec  ldr      d2, [x8, #0xbd8]
0x000230f0  fsub     d1, d1, d2
0x000230f4  mov      x8, #0x4059000000000000
0x000230f8  fmov     d2, x8
0x000230fc  fmul     d1, d1, d2
0x00023100  fdiv     d0, d1, d0
0x00023104  adrp     x8, #0x3e000
0x00023108  str      d0, [x8, #0xbe8]
0x0002310c  ret      
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
0x0002358c  stp      d9, d8, [sp, #-0x40]!
0x00023590  stp      x22, x21, [sp, #0x10]
0x00023594  stp      x20, x19, [sp, #0x20]
0x00023598  stp      x29, x30, [sp, #0x30]
0x0002359c  add      x29, sp, #0x30
0x000235a0  adrp     x21, #0x3e000
0x000235a4  ldrb     w8, [x21, #0xc40]
0x000235a8  tbz      w8, #0, #0x235b4
0x000235ac  mov      w20, #1
0x000235b0  b        #0x23668   ; call sub_23668
0x000235b4  adrp     x8, #0x3e000
0x000235b8  ldr      x8, [x8, #0xc70]
0x000235bc  cmn      x8, #1
0x000235c0  b.ne     #0x23680
0x000235c4  adrp     x8, #0x3e000
0x000235c8  ldr      d9, [x8, #0xc68]
0x000235cc  fcmp     d9, #0.0
0x000235d0  b.ls     #0x23650
0x000235d4  adrp     x8, #0x3e000
0x000235d8  ldr      x0, [x8, #0x418]   ; -> [class(NSDate)]
0x000235dc  bl       #0x25480   ; objc_msgSend: date
0x000235e0  mov      x29, x29
0x000235e4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000235e8  mov      x19, x0
0x000235ec  bl       #0x27f40   ; objc_msgSend: timeIntervalSince1970
0x000235f0  mov      v8.16b, v0.16b
0x000235f4  mov      x0, x19
0x000235f8  bl       #0x2480c   ; call _objc_release
0x000235fc  adrp     x0, #0x38000
0x00023600  add      x0, x0, #0xa30   ; -> @"trustedTime"
0x00023604  adrp     x1, #0x37000
0x00023608  add      x1, x1, #0x70   ; -> @"com.anlai.omnicar"
0x0002360c  bl       #0x242c0   ; call _CFPreferencesCopyAppValue
0x00023610  mov      x19, x0
0x00023614  adrp     x8, #0x3e000
0x00023618  ldr      x0, [x8, #0x2a0]   ; -> [class(NSNumber)]
0x0002361c  bl       #0x247d0   ; call _objc_opt_class
0x00023620  mov      x1, x0
0x00023624  mov      x0, x19
0x00023628  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0002362c  tbz      w0, #0, #0x23640
0x00023630  mov      x0, x19
0x00023634  bl       #0x25640   ; objc_msgSend: doubleValue
0x00023638  fcmp     d8, d0
0x0002363c  fcsel    d8, d0, d8, mi
0x00023640  fcmp     d8, d9
0x00023644  b.ge     #0x23658
0x00023648  ldrb     w20, [x21, #0xc40]
0x0002364c  b        #0x23660   ; call sub_23660
0x00023650  mov      w20, #0
0x00023654  b        #0x23668   ; call sub_23668
0x00023658  mov      w20, #1
0x0002365c  strb     w20, [x21, #0xc40]
0x00023660  mov      x0, x19
0x00023664  bl       #0x2480c   ; call _objc_release
0x00023668  mov      x0, x20
0x0002366c  ldp      x29, x30, [sp, #0x30]
0x00023670  ldp      x20, x19, [sp, #0x20]
0x00023674  ldp      x22, x21, [sp, #0x10]
0x00023678  ldp      d9, d8, [sp], #0x40
0x0002367c  ret      
0x00023680  bl       #0x24274   ; call sub_24274
0x00023684  b        #0x235c4   ; call sub_235c4
0x00023688  adrp     x0, #0x39000
0x0002368c  add      x0, x0, #0x540
0x00023690  ret      
0x00023694  adrp     x0, #0x39000
0x00023698  add      x0, x0, #0x558
0x0002369c  ret      
0x000236a0  stp      x28, x27, [sp, #-0x60]!
0x000236a4  stp      x26, x25, [sp, #0x10]
0x000236a8  stp      x24, x23, [sp, #0x20]
0x000236ac  stp      x22, x21, [sp, #0x30]
0x000236b0  stp      x20, x19, [sp, #0x40]
0x000236b4  stp      x29, x30, [sp, #0x50]
0x000236b8  add      x29, sp, #0x50
0x000236bc  sub      sp, sp, #0x280
0x000236c0  adrp     x8, #0x34000
0x000236c4  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x000236c8  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x000236cc  stur     x8, [x29, #-0x60]
0x000236d0  adrp     x0, #0x38000
0x000236d4  add      x0, x0, #0xd90   ; -> @"language"
0x000236d8  adrp     x1, #0x37000
0x000236dc  add      x1, x1, #0x70   ; -> @"com.anlai.omnicar"
0x000236e0  bl       #0x242c0   ; call _CFPreferencesCopyAppValue
0x000236e4  mov      x19, x0
0x000236e8  adrp     x8, #0x3e000
0x000236ec  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x000236f0  bl       #0x247d0   ; call _objc_opt_class
0x000236f4  mov      x1, x0
0x000236f8  mov      x0, x19
0x000236fc  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x00023700  tbz      w0, #0, #0x23728
0x00023704  adrp     x0, #0x39000
0x00023708  add      x0, x0, #0x558
0x0002370c  mov      x2, x19
0x00023710  bl       #0x25360   ; objc_msgSend: containsObject:
0x00023714  cbz      w0, #0x23728
0x00023718  mov      x0, x19
0x0002371c  bl       #0x24818   ; call _objc_retain
0x00023720  mov      x26, x19
0x00023724  b        #0x239d8   ; call sub_239d8
0x00023728  movi     v0.16b, #0
0x0002372c  stp      q0, q0, [sp, #0xd0]
0x00023730  stp      q0, q0, [sp, #0xb0]
0x00023734  adrp     x8, #0x3e000
0x00023738  ldr      x0, [x8, #0x448]   ; -> [class(NSLocale)]
0x0002373c  bl       #0x26660   ; objc_msgSend: preferredLanguages
0x00023740  mov      x29, x29
0x00023744  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00023748  mov      x20, x0
0x0002374c  add      x2, sp, #0xb0
0x00023750  sub      x3, x29, #0xe0
0x00023754  mov      w4, #0x10
0x00023758  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0002375c  cbz      x0, #0x239b4
0x00023760  ldr      x8, [sp, #0xc0]
0x00023764  ldr      x22, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00023768  adrp     x21, #0x39000
0x0002376c  add      x21, x21, #0x558
0x00023770  adrp     x23, #0x35000
0x00023774  add      x23, x23, #0x90   ; -> @"-"
0x00023778  str      x20, [sp, #0x28]
0x0002377c  str      x22, [sp, #0x10]
0x00023780  mov      x24, #0
0x00023784  str      x0, [sp, #0x18]
0x00023788  ldr      x8, [sp, #0xc0]
0x0002378c  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00023790  cmp      x8, x22
0x00023794  b.eq     #0x237a0
0x00023798  mov      x0, x20
0x0002379c  bl       #0x24770   ; call _objc_enumerationMutation
0x000237a0  ldr      x8, [sp, #0xb8]
0x000237a4  str      x24, [sp, #0x20]
0x000237a8  ldr      x25, [x8, x24, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x000237ac  movi     v0.16b, #0
0x000237b0  stp      q0, q0, [sp, #0x70]
0x000237b4  stp      q0, q0, [sp, #0x90]
0x000237b8  add      x2, sp, #0x70
0x000237bc  add      x3, sp, #0x170
0x000237c0  mov      x0, x21
0x000237c4  mov      w4, #0x10
0x000237c8  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x000237cc  cbz      x0, #0x2386c
0x000237d0  mov      x27, x0
0x000237d4  ldr      x8, [sp, #0x80]
0x000237d8  ldr      x22, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x000237dc  mov      x20, #0
0x000237e0  ldr      x8, [sp, #0x80]
0x000237e4  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x000237e8  cmp      x8, x22
0x000237ec  b.eq     #0x237f8
0x000237f0  mov      x0, x21
0x000237f4  bl       #0x24770   ; call _objc_enumerationMutation
0x000237f8  ldr      x8, [sp, #0x78]
0x000237fc  ldr      x26, [x8, x20, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x00023800  mov      x0, x25
0x00023804  mov      x2, x26
0x00023808  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0002380c  tbnz     w0, #0, #0x239c8
0x00023810  mov      x0, x26
0x00023814  mov      x2, x23
0x00023818  bl       #0x27c80   ; objc_msgSend: stringByAppendingString:
0x0002381c  mov      x29, x29
0x00023820  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00023824  mov      x28, x0
0x00023828  mov      x0, x25
0x0002382c  mov      x2, x28
0x00023830  bl       #0x258a0   ; objc_msgSend: hasPrefix:
0x00023834  mov      x24, x0
0x00023838  mov      x0, x28
0x0002383c  bl       #0x2480c   ; call _objc_release
0x00023840  tbnz     w24, #0, #0x239c8
0x00023844  add      x20, x20, #1
0x00023848  cmp      x27, x20
0x0002384c  b.ne     #0x237e0
0x00023850  add      x2, sp, #0x70
0x00023854  add      x3, sp, #0x170
0x00023858  mov      x0, x21
0x0002385c  mov      w4, #0x10
0x00023860  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00023864  mov      x27, x0
0x00023868  cbnz     x0, #0x237dc
0x0002386c  mov      x0, x25
0x00023870  mov      x2, x23
0x00023874  bl       #0x252e0   ; objc_msgSend: componentsSeparatedByString:
0x00023878  mov      x29, x29
0x0002387c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00023880  mov      x24, x0
0x00023884  bl       #0x25780   ; objc_msgSend: firstObject
0x00023888  mov      x29, x29
0x0002388c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00023890  mov      x25, x0
0x00023894  mov      x0, x24
0x00023898  bl       #0x2480c   ; call _objc_release
0x0002389c  mov      x0, x25
0x000238a0  adrp     x2, #0x38000
0x000238a4  add      x2, x2, #0xdb0   ; -> @"zh"
0x000238a8  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x000238ac  tbnz     w0, #0, #0x2397c
0x000238b0  movi     v0.16b, #0
0x000238b4  stp      q0, q0, [sp, #0x50]
0x000238b8  stp      q0, q0, [sp, #0x30]
0x000238bc  add      x2, sp, #0x30
0x000238c0  add      x3, sp, #0xf0
0x000238c4  mov      x0, x21
0x000238c8  mov      w4, #0x10
0x000238cc  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x000238d0  cbz      x0, #0x2397c
0x000238d4  mov      x27, x0
0x000238d8  ldr      x8, [sp, #0x40]
0x000238dc  ldr      x20, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x000238e0  str      x19, [sp, #8]
0x000238e4  mov      x19, #0
0x000238e8  ldr      x8, [sp, #0x40]
0x000238ec  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x000238f0  cmp      x8, x20
0x000238f4  b.eq     #0x23900
0x000238f8  mov      x0, x21
0x000238fc  bl       #0x24770   ; call _objc_enumerationMutation
0x00023900  ldr      x8, [sp, #0x38]
0x00023904  ldr      x26, [x8, x19, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x00023908  mov      x0, x26
0x0002390c  mov      x2, x23
0x00023910  bl       #0x252e0   ; objc_msgSend: componentsSeparatedByString:
0x00023914  mov      x29, x29
0x00023918  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0002391c  mov      x24, x0
0x00023920  bl       #0x25780   ; objc_msgSend: firstObject
0x00023924  mov      x29, x29
0x00023928  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0002392c  mov      x28, x0
0x00023930  mov      x2, x25
0x00023934  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00023938  mov      x22, x0
0x0002393c  mov      x0, x28
0x00023940  bl       #0x2480c   ; call _objc_release
0x00023944  mov      x0, x24
0x00023948  bl       #0x2480c   ; call _objc_release
0x0002394c  tbnz     w22, #0, #0x23a1c
0x00023950  add      x19, x19, #1
0x00023954  cmp      x27, x19
0x00023958  b.ne     #0x238e8
0x0002395c  add      x2, sp, #0x30
0x00023960  add      x3, sp, #0xf0
0x00023964  mov      x0, x21
0x00023968  mov      w4, #0x10
0x0002396c  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00023970  mov      x27, x0
0x00023974  ldr      x19, [sp, #8]
0x00023978  cbnz     x0, #0x238e4
0x0002397c  mov      x0, x25
0x00023980  bl       #0x2480c   ; call _objc_release
0x00023984  ldp      x0, x24, [sp, #0x18]
0x00023988  add      x24, x24, #1
0x0002398c  cmp      x24, x0
0x00023990  ldr      x20, [sp, #0x28]
0x00023994  ldr      x22, [sp, #0x10]
0x00023998  b.ne     #0x23788
0x0002399c  add      x2, sp, #0xb0
0x000239a0  sub      x3, x29, #0xe0
0x000239a4  mov      x0, x20
0x000239a8  mov      w4, #0x10
0x000239ac  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x000239b0  cbnz     x0, #0x23780
0x000239b4  mov      x0, x20
0x000239b8  bl       #0x2480c   ; call _objc_release
0x000239bc  adrp     x26, #0x38000
0x000239c0  add      x26, x26, #0xbf0   ; -> @"en"
0x000239c4  b        #0x239d8   ; call sub_239d8
0x000239c8  mov      x0, x26
0x000239cc  bl       #0x24818   ; call _objc_retain
0x000239d0  ldr      x0, [sp, #0x28]
0x000239d4  bl       #0x2480c   ; call _objc_release
0x000239d8  mov      x0, x19
0x000239dc  bl       #0x2480c   ; call _objc_release
0x000239e0  ldur     x8, [x29, #-0x60]
0x000239e4  adrp     x9, #0x34000
0x000239e8  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x000239ec  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x000239f0  cmp      x9, x8
0x000239f4  b.ne     #0x23a34
0x000239f8  mov      x0, x26
0x000239fc  add      sp, sp, #0x280
0x00023a00  ldp      x29, x30, [sp, #0x50]
0x00023a04  ldp      x20, x19, [sp, #0x40]
0x00023a08  ldp      x22, x21, [sp, #0x30]
0x00023a0c  ldp      x24, x23, [sp, #0x20]
0x00023a10  ldp      x26, x25, [sp, #0x10]
0x00023a14  ldp      x28, x27, [sp], #0x60
0x00023a18  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x00023a1c  mov      x0, x26
0x00023a20  bl       #0x24818   ; call _objc_retain
0x00023a24  mov      x0, x25
0x00023a28  bl       #0x2480c   ; call _objc_release
0x00023a2c  ldr      x19, [sp, #8]
0x00023a30  b        #0x239d0   ; call sub_239d0
0x00023a34  bl       #0x24488   ; call ___stack_chk_fail
0x00023a38  stp      x28, x27, [sp, #-0x60]!
0x00023a3c  stp      x26, x25, [sp, #0x10]
0x00023a40  stp      x24, x23, [sp, #0x20]
0x00023a44  stp      x22, x21, [sp, #0x30]
0x00023a48  stp      x20, x19, [sp, #0x40]
0x00023a4c  stp      x29, x30, [sp, #0x50]
0x00023a50  add      x29, sp, #0x50
0x00023a54  sub      sp, sp, #0x420
0x00023a58  mov      x20, x1
0x00023a5c  mov      x19, x0
0x00023a60  adrp     x8, #0x34000
0x00023a64  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00023a68  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00023a6c  stur     x8, [x29, #-0x58]
0x00023a70  bl       #0x24818   ; call _objc_retain
0x00023a74  mov      x0, x20
0x00023a78  bl       #0x24818   ; call _objc_retain
0x00023a7c  bl       #0x236a0   ; call _OMCCurrentLanguage
0x00023a80  mov      x29, x29
0x00023a84  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00023a88  mov      x21, x0
0x00023a8c  adrp     x2, #0x36000
0x00023a90  add      x2, x2, #0xc70   ; -> @"vi"
0x00023a94  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00023a98  cbz      w0, #0x23aac
0x00023a9c  mov      x0, x19
0x00023aa0  bl       #0x24818   ; call _objc_retain
0x00023aa4  mov      x22, x19
0x00023aa8  b        #0x23c2c   ; call sub_23c2c
0x00023aac  adrp     x2, #0x38000
0x00023ab0  add      x2, x2, #0xbf0   ; -> @"en"
0x00023ab4  mov      x0, x21
0x00023ab8  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00023abc  cbz      x20, #0x23b4c
0x00023ac0  cbnz     w0, #0x23b4c
0x00023ac4  mov      x0, x21
0x00023ac8  bl       #0x24818   ; call _objc_retain
0x00023acc  adrp     x8, #0x3e000
0x00023ad0  ldr      x8, [x8, #0xc80]
0x00023ad4  cmn      x8, #1
0x00023ad8  b.ne     #0x23c80
0x00023adc  adrp     x26, #0x3e000
0x00023ae0  ldr      x22, [x26, #0xc78]
0x00023ae4  mov      x0, x22
0x00023ae8  bl       #0x24818   ; call _objc_retain
0x00023aec  mov      x0, x22
0x00023af0  bl       #0x24878   ; call _objc_sync_enter
0x00023af4  ldr      x0, [x26, #0xc78]
0x00023af8  mov      x2, x21
0x00023afc  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00023b00  mov      x29, x29
0x00023b04  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00023b08  mov      x23, x0
0x00023b0c  cbnz     x0, #0x23bdc
0x00023b10  adrp     x24, #0x3e000
0x00023b14  ldr      x23, [x24, #0x290]   ; -> [class(NSString)]
0x00023b18  adrp     x0, #0x38000
0x00023b1c  add      x0, x0, #0xe50   ; -> @"/Library/PreferenceBundles/OmniCarPrefs.bundle"
0x00023b20  bl       #0x25740   ; objc_msgSend: fileSystemRepresentation
0x00023b24  add      x1, sp, #0x18
0x00023b28  bl       #0x4118   ; call sub_4118
0x00023b2c  mov      x2, x0
0x00023b30  cbz      x0, #0x23b5c
0x00023b34  ldr      x0, [x24, #0x290]   ; -> [class(NSString)]
0x00023b38  bl       #0x27d40   ; objc_msgSend: stringWithUTF8String:
0x00023b3c  mov      x29, x29
0x00023b40  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00023b44  mov      x25, x0
0x00023b48  b        #0x23b60   ; call sub_23b60
0x00023b4c  mov      x0, x20
0x00023b50  bl       #0x24818   ; call _objc_retain
0x00023b54  mov      x22, x20
0x00023b58  b        #0x23c2c   ; call sub_23c2c
0x00023b5c  mov      x25, #0
0x00023b60  stp      x25, x21, [sp]
0x00023b64  adrp     x2, #0x38000
0x00023b68  add      x2, x2, #0xe30   ; -> @"%@/%@.lproj/Car.strings"
0x00023b6c  mov      x0, x23
0x00023b70  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00023b74  mov      x29, x29
0x00023b78  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00023b7c  mov      x24, x0
0x00023b80  mov      x0, x25
0x00023b84  bl       #0x2480c   ; call _objc_release
0x00023b88  adrp     x8, #0x3e000
0x00023b8c  ldr      x0, [x8, #0x310]   ; -> [class(NSDictionary)]
0x00023b90  mov      x2, x24
0x00023b94  bl       #0x255a0   ; objc_msgSend: dictionaryWithContentsOfFile:
0x00023b98  mov      x29, x29
0x00023b9c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00023ba0  mov      x25, x0
0x00023ba4  adrp     x8, #0x34000
0x00023ba8  ldr      x8, [x8, #0x1f8]   ; -> [got:___NSDictionary0__struct]
0x00023bac  cmp      x0, #0
0x00023bb0  csel     x23, x8, x0, eq
0x00023bb4  mov      x0, x23
0x00023bb8  bl       #0x24818   ; call _objc_retain
0x00023bbc  mov      x0, x25
0x00023bc0  bl       #0x2480c   ; call _objc_release
0x00023bc4  ldr      x0, [x26, #0xc78]
0x00023bc8  mov      x2, x23
0x00023bcc  mov      x3, x21
0x00023bd0  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00023bd4  mov      x0, x24
0x00023bd8  bl       #0x2480c   ; call _objc_release
0x00023bdc  mov      x0, x22
0x00023be0  bl       #0x24884   ; call _objc_sync_exit
0x00023be4  mov      x0, x22
0x00023be8  bl       #0x2480c   ; call _objc_release
0x00023bec  mov      x0, x21
0x00023bf0  bl       #0x2480c   ; call _objc_release
0x00023bf4  mov      x0, x23
0x00023bf8  mov      x2, x20
0x00023bfc  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00023c00  mov      x29, x29
0x00023c04  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00023c08  mov      x24, x0
0x00023c0c  cmp      x0, #0
0x00023c10  csel     x22, x20, x0, eq
0x00023c14  mov      x0, x22
0x00023c18  bl       #0x24818   ; call _objc_retain
0x00023c1c  mov      x0, x24
0x00023c20  bl       #0x2480c   ; call _objc_release
0x00023c24  mov      x0, x23
0x00023c28  bl       #0x2480c   ; call _objc_release
0x00023c2c  mov      x0, x21
0x00023c30  bl       #0x2480c   ; call _objc_release
0x00023c34  mov      x0, x20
0x00023c38  bl       #0x2480c   ; call _objc_release
0x00023c3c  mov      x0, x19
0x00023c40  bl       #0x2480c   ; call _objc_release
0x00023c44  ldur     x8, [x29, #-0x58]
0x00023c48  adrp     x9, #0x34000
0x00023c4c  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00023c50  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x00023c54  cmp      x9, x8
0x00023c58  b.ne     #0x23c88
0x00023c5c  mov      x0, x22
0x00023c60  add      sp, sp, #0x420
0x00023c64  ldp      x29, x30, [sp, #0x50]
0x00023c68  ldp      x20, x19, [sp, #0x40]
0x00023c6c  ldp      x22, x21, [sp, #0x30]
0x00023c70  ldp      x24, x23, [sp, #0x20]
0x00023c74  ldp      x26, x25, [sp, #0x10]
0x00023c78  ldp      x28, x27, [sp], #0x60
0x00023c7c  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x00023c80  bl       #0x24288   ; call sub_24288
0x00023c84  b        #0x23adc   ; call sub_23adc
0x00023c88  bl       #0x24488   ; call ___stack_chk_fail
0x00023c8c  b        #0x23c94   ; call sub_23c94
0x00023c90  b        #0x23c94   ; call sub_23c94
0x00023c94  mov      x19, x0
0x00023c98  mov      x0, x22
0x00023c9c  bl       #0x24884   ; call _objc_sync_exit
0x00023ca0  b        #0x23ca8   ; call sub_23ca8
0x00023ca4  mov      x19, x0
0x00023ca8  mov      x0, x19
0x00023cac  bl       #0x24470   ; call __Unwind_Resume
0x00023cb0  sub      sp, sp, #0x50
0x00023cb4  stp      x20, x19, [sp, #0x30]
0x00023cb8  stp      x29, x30, [sp, #0x40]
0x00023cbc  add      x29, sp, #0x40
0x00023cc0  mov      x19, x0
0x00023cc4  adrp     x8, #0x3e000
0x00023cc8  add      x8, x8, #0xc58
0x00023ccc  add      x0, x8, w0, uxtw #3
0x00023cd0  adrp     x8, #0x34000
0x00023cd4  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x00023cd8  str      x8, [sp, #8]
0x00023cdc  adrp     x8, #0x2b000
0x00023ce0  ldr      d0, [x8, #0x1e8]
0x00023ce4  str      d0, [sp, #0x10]
0x00023ce8  adrp     x8, #0x23000
0x00023cec  add      x8, x8, #0xd44
0x00023cf0  adrp     x9, #0x34000
0x00023cf4  add      x9, x9, #0xd70
0x00023cf8  stp      x8, x9, [sp, #0x18]
0x00023cfc  strb     w19, [sp, #0x2c]
0x00023d00  str      w19, [sp, #0x28]
0x00023d04  ldr      x8, [x0]
0x00023d08  cmn      x8, #1
0x00023d0c  b.ne     #0x23d38
0x00023d10  adrp     x8, #0x3e000
0x00023d14  add      x8, x8, #0xc48
0x00023d18  ldr      x19, [x8, w19, uxtw #3]   ; -> [@selector(textFieldShouldReturn:)]
0x00023d1c  mov      x0, x19
0x00023d20  bl       #0x24818   ; call _objc_retain
0x00023d24  mov      x0, x19
0x00023d28  ldp      x29, x30, [sp, #0x40]
0x00023d2c  ldp      x20, x19, [sp, #0x30]
0x00023d30  add      sp, sp, #0x50
0x00023d34  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x00023d38  add      x1, sp, #8
0x00023d3c  bl       #0x24578   ; call _dispatch_once
0x00023d40  b        #0x23d10   ; call sub_23d10
0x00023d44  sub      sp, sp, #0x70
0x00023d48  stp      d9, d8, [sp, #0x30]
0x00023d4c  stp      x22, x21, [sp, #0x40]
0x00023d50  stp      x20, x19, [sp, #0x50]
0x00023d54  stp      x29, x30, [sp, #0x60]
0x00023d58  add      x29, sp, #0x60
0x00023d5c  mov      x19, x0
0x00023d60  ldrb     w8, [x0, #0x24]
0x00023d64  cmp      w8, #0
0x00023d68  adrp     x8, #0x2b000
0x00023d6c  ldr      d0, [x8, #0x260]
0x00023d70  fmov     d1, #1.00000000
0x00023d74  fcsel    d8, d1, d0, ne
0x00023d78  adrp     x8, #0x3e000
0x00023d7c  ldr      x0, [x8, #0x450]   ; -> [class(UIGraphicsImageRendererFormat)]
0x00023d80  bl       #0x26640   ; objc_msgSend: preferredFormat
0x00023d84  mov      x29, x29
0x00023d88  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00023d8c  mov      x20, x0
0x00023d90  fmov     d0, #1.00000000
0x00023d94  bl       #0x27660   ; objc_msgSend: setScale:
0x00023d98  ldrb     w2, [x19, #0x24]
0x00023d9c  mov      x0, x20
0x00023da0  bl       #0x27440   ; objc_msgSend: setOpaque:
0x00023da4  adrp     x8, #0x3e000
0x00023da8  ldr      x0, [x8, #0x3a0]   ; -> [class(UIGraphicsImageRenderer)]
0x00023dac  bl       #0x2471c   ; call _objc_alloc
0x00023db0  mov      x8, #0x4058000000000000
0x00023db4  fmov     d0, x8
0x00023db8  mov      v1.16b, v0.16b
0x00023dbc  mov      x2, x20
0x00023dc0  bl       #0x25aa0   ; objc_msgSend: initWithSize:format:
0x00023dc4  mov      x21, x0
0x00023dc8  adrp     x8, #0x34000
0x00023dcc  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x00023dd0  str      x8, [sp]
0x00023dd4  adrp     x8, #0x2b000
0x00023dd8  ldr      d0, [x8, #0x1e8]
0x00023ddc  adrp     x8, #0x23000
0x00023de0  add      x8, x8, #0xe50
0x00023de4  adrp     x9, #0x34000
0x00023de8  add      x9, x9, #0xd50
0x00023dec  str      d0, [sp, #8]
0x00023df0  stp      x8, x9, [sp, #0x10]
0x00023df4  ldrb     w8, [x19, #0x24]
0x00023df8  strb     w8, [sp, #0x28]
0x00023dfc  str      d8, [sp, #0x20]
0x00023e00  mov      x2, sp
0x00023e04  bl       #0x25980   ; objc_msgSend: imageWithActions:
0x00023e08  mov      x29, x29
0x00023e0c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00023e10  ldrsw    x9, [x19, #0x20]
0x00023e14  adrp     x10, #0x3e000
0x00023e18  add      x10, x10, #0xc48
0x00023e1c  ldr      x8, [x10, x9, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x00023e20  str      x0, [x10, x9, lsl #3]
0x00023e24  mov      x0, x8
0x00023e28  bl       #0x2480c   ; call _objc_release
0x00023e2c  mov      x0, x21
0x00023e30  bl       #0x2480c   ; call _objc_release
0x00023e34  mov      x0, x20
0x00023e38  ldp      x29, x30, [sp, #0x60]
0x00023e3c  ldp      x20, x19, [sp, #0x50]
0x00023e40  ldp      x22, x21, [sp, #0x40]
0x00023e44  ldp      d9, d8, [sp, #0x30]
0x00023e48  add      sp, sp, #0x70
0x00023e4c  b        #0x2480c   ; call _objc_release
0x00023e50  sub      sp, sp, #0x140
0x00023e54  stp      d11, d10, [sp, #0xc0]
0x00023e58  stp      d9, d8, [sp, #0xd0]
0x00023e5c  stp      x28, x27, [sp, #0xe0]
0x00023e60  stp      x26, x25, [sp, #0xf0]
0x00023e64  stp      x24, x23, [sp, #0x100]
0x00023e68  stp      x22, x21, [sp, #0x110]
0x00023e6c  stp      x20, x19, [sp, #0x120]
0x00023e70  stp      x29, x30, [sp, #0x130]
0x00023e74  add      x29, sp, #0x130
0x00023e78  mov      x19, x0
0x00023e7c  adrp     x8, #0x34000
0x00023e80  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00023e84  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00023e88  stur     x8, [x29, #-0x78]
0x00023e8c  mov      x0, x1
0x00023e90  bl       #0x24a00   ; objc_msgSend: CGContext
0x00023e94  mov      x20, x0
0x00023e98  movi     v0.16b, #0
0x00023e9c  stp      q0, q0, [sp, #0x90]
0x00023ea0  mov      x8, #0x4058000000000000
0x00023ea4  dup      v1.2d, x8
0x00023ea8  stp      q1, q0, [sp, #0x70]
0x00023eac  stur     q1, [sp, #0x88]
0x00023eb0  ldrb     w8, [x19, #0x28]
0x00023eb4  adrp     x9, #0x3e000
0x00023eb8  ldr      x0, [x9, #0x320]   ; -> [class(UIColor)]
0x00023ebc  tbz      w8, #0, #0x23ee0
0x00023ec0  adrp     x8, #0x2b000
0x00023ec4  ldr      d0, [x8, #0x480]
0x00023ec8  adrp     x8, #0x2b000
0x00023ecc  ldr      d1, [x8, #0x488]
0x00023ed0  adrp     x8, #0x2b000
0x00023ed4  ldr      d2, [x8, #0x2b0]
0x00023ed8  fmov     d3, #1.00000000
0x00023edc  b        #0x23f00   ; call sub_23f00
0x00023ee0  adrp     x8, #0x2b000
0x00023ee4  ldr      d0, [x8, #0x460]
0x00023ee8  adrp     x8, #0x2b000
0x00023eec  ldr      d1, [x8, #0x468]
0x00023ef0  adrp     x8, #0x2b000
0x00023ef4  ldr      d2, [x8, #0x470]
0x00023ef8  adrp     x8, #0x2b000
0x00023efc  ldr      d3, [x8, #0x478]
0x00023f00  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x00023f04  mov      x29, x29
0x00023f08  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00023f0c  mov      x21, x0
0x00023f10  bl       #0x26f20   ; objc_msgSend: setFill
0x00023f14  mov      x8, #0x4058000000000000
0x00023f18  fmov     d2, x8
0x00023f1c  fmov     d0, xzr
0x00023f20  fmov     d1, xzr
0x00023f24  mov      x0, x20
0x00023f28  mov      v3.16b, v2.16b
0x00023f2c  bl       #0x2432c   ; call _CGContextFillRect
0x00023f30  adrp     x24, #0x2b000
0x00023f34  add      x24, x24, #0x4b0
0x00023f38  bl       #0x24308   ; call _CGColorSpaceCreateDeviceRGB
0x00023f3c  mov      x22, x0
0x00023f40  mov      x25, #0
0x00023f44  adrp     x8, #0x2b000
0x00023f48  ldr      d9, [x8, #0x490]
0x00023f4c  adrp     x8, #0x2b000
0x00023f50  ldr      d10, [x8, #0x498]
0x00023f54  movi     d11, #0x0000ff000000ff
0x00023f58  mov      x8, #0xe00000000000
0x00023f5c  movk     x8, #0x406f, lsl #48
0x00023f60  dup      v4.2d, x8
0x00023f64  adrp     x8, #0x2b000
0x00023f68  add      x8, x8, #0x4c0
0x00023f6c  ldr      q0, [x8]
0x00023f70  stp      q0, q4, [sp]
0x00023f74  add      x26, sp, #0x70
0x00023f78  adrp     x8, #0x2b000
0x00023f7c  ldr      d8, [x8, #0x4a0]
0x00023f80  ldr      w8, [x24], #4
0x00023f84  and      w9, w8, #0xff
0x00023f88  ucvtf    d0, w9
0x00023f8c  dup      v1.2s, w8
0x00023f90  ushl     v1.2s, v1.2s, v10.2s
0x00023f94  and      v1.8b, v1.8b, v11.8b
0x00023f98  ushll    v1.2d, v1.2s, #0
0x00023f9c  ucvtf    v1.2d, v1.2d
0x00023fa0  ldr      q2, [sp, #0x10]
0x00023fa4  fdiv     v1.2d, v1.2d, v2.2d
0x00023fa8  ldr      d2, [x19, #0x20]   ; -> [@selector(timeZoneForSecondsFromGMT:)]
0x00023fac  fdiv     d0, d0, d9
0x00023fb0  stp      d0, d2, [sp, #0x40]
0x00023fb4  str      q1, [sp, #0x50]
0x00023fb8  str      d0, [sp, #0x60]
0x00023fbc  str      xzr, [sp, #0x68]
0x00023fc0  ldr      q0, [sp]
0x00023fc4  stp      q0, q1, [sp, #0x20]
0x00023fc8  add      x1, sp, #0x30
0x00023fcc  add      x2, sp, #0x20
0x00023fd0  mov      x0, x22
0x00023fd4  mov      w3, #2
0x00023fd8  bl       #0x24344   ; call _CGGradientCreateWithColorComponents
0x00023fdc  mov      x23, x0
0x00023fe0  add      x8, x26, x25
0x00023fe4  ldp      d0, d1, [x8]
0x00023fe8  fmov     d2, xzr
0x00023fec  mov      x0, x20
0x00023ff0  mov      x1, x23
0x00023ff4  mov      v3.16b, v0.16b
0x00023ff8  mov      v4.16b, v1.16b
0x00023ffc  mov      v5.16b, v8.16b
0x00024000  mov      w2, #0
0x00024004  bl       #0x24320   ; call _CGContextDrawRadialGradient
0x00024008  mov      x0, x23
0x0002400c  bl       #0x24350   ; call _CGGradientRelease
0x00024010  add      x25, x25, #0x10
0x00024014  cmp      x25, #0x40
0x00024018  b.ne     #0x23f80
0x0002401c  mov      x0, x22
0x00024020  bl       #0x24314   ; call _CGColorSpaceRelease
0x00024024  mov      x0, x21
0x00024028  bl       #0x2480c   ; call _objc_release
0x0002402c  ldur     x8, [x29, #-0x78]
0x00024030  adrp     x9, #0x34000
0x00024034  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00024038  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0002403c  cmp      x9, x8
0x00024040  b.ne     #0x2406c
0x00024044  ldp      x29, x30, [sp, #0x130]
0x00024048  ldp      x20, x19, [sp, #0x120]
0x0002404c  ldp      x22, x21, [sp, #0x110]
0x00024050  ldp      x24, x23, [sp, #0x100]
0x00024054  ldp      x26, x25, [sp, #0xf0]
0x00024058  ldp      x28, x27, [sp, #0xe0]
0x0002405c  ldp      d9, d8, [sp, #0xd0]
0x00024060  ldp      d11, d10, [sp, #0xc0]
0x00024064  add      sp, sp, #0x140
0x00024068  ret      
0x0002406c  bl       #0x24488   ; call ___stack_chk_fail
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
