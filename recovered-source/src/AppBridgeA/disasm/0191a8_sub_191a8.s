; ==== sub_191a8 @ 0x191a8..0x192d4 (300 bytes) ====
0x000191a8  str      x23, [sp, #0x38]
0x000191ac  add      x2, sp, #0x18
0x000191b0  mov      x0, x24
0x000191b4  bl       #0x24a80   ; objc_msgSend: addAnimations:
0x000191b8  mov      x0, x24
0x000191bc  bl       #0x27c00   ; objc_msgSend: startAnimation
0x000191c0  mov      x0, x24
0x000191c4  bl       #0x2480c   ; call _objc_release
0x000191c8  adrp     x8, #0x3e000
0x000191cc  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x000191d0  stp      x21, x22, [sp, #8]
0x000191d4  str      x19, [sp]
0x000191d8  adrp     x2, #0x36000
0x000191dc  add      x2, x2, #0xc90   ; -> @"ban phim xe: hien cho %@ (kieu %ld, phim enter %ld)"
0x000191e0  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x000191e4  mov      x29, x29
0x000191e8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000191ec  mov      x22, x0
0x000191f0  adrp     x0, #0x34000
0x000191f4  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x000191f8  mov      x1, x22
0x000191fc  bl       #0x1dd30   ; call _OMCLogWrite
0x00019200  mov      x0, x22
0x00019204  bl       #0x2480c   ; call _objc_release
0x00019208  mov      x0, x20
0x0001920c  bl       #0x2480c   ; call _objc_release
0x00019210  mov      x0, x19
0x00019214  bl       #0x2480c   ; call _objc_release
0x00019218  ldp      x29, x30, [sp, #0x120]
0x0001921c  ldp      x20, x19, [sp, #0x110]
0x00019220  ldp      x22, x21, [sp, #0x100]
0x00019224  ldp      x24, x23, [sp, #0xf0]
0x00019228  ldp      x26, x25, [sp, #0xe0]
0x0001922c  ldp      x28, x27, [sp, #0xd0]
0x00019230  add      sp, sp, #0x130
0x00019234  ret      
0x00019238  b        #0x192ac   ; call sub_192ac
0x0001923c  b        #0x192ac   ; call sub_192ac
0x00019240  mov      x21, x0
0x00019244  mov      x0, x25
0x00019248  b        #0x192b4   ; call sub_192b4
0x0001924c  b        #0x19274   ; call sub_19274
0x00019250  b        #0x192d0   ; call sub_192d0
0x00019254  b        #0x192ac   ; call sub_192ac
0x00019258  b        #0x192ac   ; call sub_192ac
0x0001925c  b        #0x19274   ; call sub_19274
0x00019260  b        #0x192ac   ; call sub_192ac
0x00019264  b        #0x1927c   ; call sub_1927c
0x00019268  b        #0x192ac   ; call sub_192ac
0x0001926c  b        #0x192ac   ; call sub_192ac
0x00019270  b        #0x192ac   ; call sub_192ac
0x00019274  mov      x21, x0
0x00019278  b        #0x192a0   ; call sub_192a0
0x0001927c  mov      x21, x0
0x00019280  mov      x0, x22
0x00019284  b        #0x192b4   ; call sub_192b4
0x00019288  b        #0x192d0   ; call sub_192d0
0x0001928c  b        #0x192d0   ; call sub_192d0
0x00019290  b        #0x192ac   ; call sub_192ac
0x00019294  mov      x21, x0
0x00019298  mov      x0, x26
0x0001929c  bl       #0x2480c   ; call _objc_release
0x000192a0  mov      x0, x25
0x000192a4  bl       #0x2480c   ; call _objc_release
0x000192a8  b        #0x192b0   ; call sub_192b0
0x000192ac  mov      x21, x0
0x000192b0  mov      x0, x24
0x000192b4  bl       #0x2480c   ; call _objc_release
0x000192b8  b        #0x192d4   ; call sub_192d4
0x000192bc  mov      x21, x0
0x000192c0  mov      x0, x24
0x000192c4  b        #0x192d8   ; call sub_192d8
0x000192c8  mov      x21, x0
0x000192cc  b        #0x192dc   ; call sub_192dc
0x000192d0  mov      x21, x0
