; ==== sub_2081c @ 0x2081c..0x20a2c (528 bytes) ====
0x0002081c  adrp     x22, #0x2a000
0x00020820  add      x22, x22, #0xbb7   ; -> "__DATA"
0x00020824  adrp     x23, #0x2a000
0x00020828  add      x23, x23, #0xbbe   ; -> "__crash_info"
0x0002082c  adrp     x27, #0x2a000
0x00020830  add      x27, x27, #0x62a   ; -> "?"
0x00020834  adrp     x25, #0x2a000
0x00020838  add      x25, x25, #0xbd8   ; -> "crash_info [%s]: %s
"
0x0002083c  mov      x0, x21
0x00020840  bl       #0x244ac   ; call __dyld_get_image_header
0x00020844  cbz      x0, #0x208ec
0x00020848  mov      x26, x0
0x0002084c  str      xzr, [sp, #0x28]
0x00020850  add      x3, sp, #0x28
0x00020854  mov      x1, x22
0x00020858  mov      x2, x23
0x0002085c  bl       #0x24650   ; call _getsectiondata
0x00020860  cbnz     x0, #0x2087c
0x00020864  add      x3, sp, #0x28
0x00020868  mov      x0, x26
0x0002086c  adrp     x1, #0x2a000
0x00020870  add      x1, x1, #0xbcb   ; -> "__DATA_DIRTY"
0x00020874  mov      x2, x23
0x00020878  bl       #0x24650   ; call _getsectiondata
0x0002087c  cbz      x0, #0x208ec
0x00020880  ldr      x8, [sp, #0x28]
0x00020884  cmp      x8, #0x28
0x00020888  b.lo     #0x208ec
0x0002088c  ldr      x28, [x0, #8]
0x00020890  ldr      x24, [x0, #0x20]
0x00020894  mov      w8, #1
0x00020898  mov      x19, x8
0x0002089c  cbz      x28, #0x208e0
0x000208a0  ldrb     w8, [x28]
0x000208a4  cbz      w8, #0x208e0
0x000208a8  mov      x0, x21
0x000208ac  bl       #0x244b8   ; call __dyld_get_image_name
0x000208b0  cbz      x0, #0x208c4
0x000208b4  mov      x26, x0
0x000208b8  mov      w1, #0x2f
0x000208bc  bl       #0x24968   ; call _strrchr
0x000208c0  b        #0x208c8   ; call sub_208c8
0x000208c4  mov      x26, x27
0x000208c8  cmp      x0, #0
0x000208cc  csinc    x8, x26, x0, eq
0x000208d0  stp      x8, x28, [sp]
0x000208d4  mov      x0, x20
0x000208d8  mov      x1, x25
0x000208dc  bl       #0x245fc   ; call _dprintf
0x000208e0  mov      w8, #0
0x000208e4  mov      x28, x24
0x000208e8  tbnz     w19, #0, #0x20898
0x000208ec  add      w21, w21, #1
0x000208f0  bl       #0x244c4   ; call __dyld_image_count
0x000208f4  cmp      w21, w0
0x000208f8  b.lo     #0x2083c
0x000208fc  mov      x0, x20
0x00020900  bl       #0x2453c   ; call _close
0x00020904  ldr      x23, [sp, #0x20]
0x00020908  mov      x0, x23
0x0002090c  mov      x1, #0
0x00020910  bl       #0x24914   ; call _signal
0x00020914  mov      x0, x23
0x00020918  bl       #0x248e4   ; call _raise
0x0002091c  ldur     x8, [x29, #-0x60]
0x00020920  adrp     x9, #0x34000
0x00020924  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00020928  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0002092c  cmp      x9, x8
0x00020930  b.ne     #0x20954
0x00020934  add      sp, sp, #0x270
0x00020938  ldp      x29, x30, [sp, #0x50]
0x0002093c  ldp      x20, x19, [sp, #0x40]
0x00020940  ldp      x22, x21, [sp, #0x30]
0x00020944  ldp      x24, x23, [sp, #0x20]
0x00020948  ldp      x26, x25, [sp, #0x10]
0x0002094c  ldp      x28, x27, [sp], #0x60
0x00020950  ret      
0x00020954  bl       #0x24488   ; call ___stack_chk_fail
0x00020958  b        #0x2095c   ; call sub_2095c
0x0002095c  stp      x29, x30, [sp, #-0x10]!
0x00020960  mov      x29, sp
0x00020964  mov      x0, #0
0x00020968  mov      w1, #0x2800
0x0002096c  movk     w1, #0xee6b, lsl #16
0x00020970  bl       #0x245cc   ; call _dispatch_time
0x00020974  adrp     x1, #0x34000
0x00020978  ldr      x1, [x1, #0x290]   ; -> [got:__dispatch_main_q]
0x0002097c  adrp     x2, #0x34000
0x00020980  add      x2, x2, #0xcb0
0x00020984  ldp      x29, x30, [sp], #0x10
0x00020988  b        #0x24548   ; call _dispatch_after
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
