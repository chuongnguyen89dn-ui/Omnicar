; block literal @0x34710 desc @0x34670 sig=v16@?0@"NSNotification"8 flags=0x50000000
; ==== sub_8fd4 @ 0x8fd4..0x90a8 (212 bytes) ====
0x00008fd4  sub      sp, sp, #0x50
0x00008fd8  stp      x24, x23, [sp, #0x10]
0x00008fdc  stp      x22, x21, [sp, #0x20]
0x00008fe0  stp      x20, x19, [sp, #0x30]
0x00008fe4  stp      x29, x30, [sp, #0x40]
0x00008fe8  add      x29, sp, #0x40
0x00008fec  mov      x19, x1
0x00008ff0  mov      x0, x1
0x00008ff4  bl       #0x24818   ; call _objc_retain
0x00008ff8  adrp     x8, #0x3e000
0x00008ffc  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x00009000  bl       #0x27b20   ; objc_msgSend: shared
0x00009004  mov      x29, x29
0x00009008  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000900c  mov      x20, x0
0x00009010  mov      x0, x19
0x00009014  bl       #0x280c0   ; objc_msgSend: userInfo
0x00009018  mov      x29, x29
0x0000901c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009020  mov      x22, x0
0x00009024  adrp     x2, #0x35000
0x00009028  add      x2, x2, #0x7d0   ; -> @"except"
0x0000902c  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00009030  mov      x29, x29
0x00009034  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009038  mov      x21, x0
0x0000903c  mov      x0, x20
0x00009040  mov      x2, x21
0x00009044  bl       #0x251c0   ; objc_msgSend: closeAllExcept:
0x00009048  mov      x0, x21
0x0000904c  bl       #0x2480c   ; call _objc_release
0x00009050  mov      x0, x22
0x00009054  bl       #0x2480c   ; call _objc_release
0x00009058  mov      x0, x20
0x0000905c  bl       #0x2480c   ; call _objc_release
0x00009060  mov      x0, x19
0x00009064  ldp      x29, x30, [sp, #0x40]
0x00009068  ldp      x20, x19, [sp, #0x30]
0x0000906c  ldp      x22, x21, [sp, #0x20]
0x00009070  ldp      x24, x23, [sp, #0x10]
0x00009074  add      sp, sp, #0x50
0x00009078  b        #0x2480c   ; call _objc_release
0x0000907c  mov      x23, x1
0x00009080  mov      x1, x21
0x00009084  mov      x21, x0
0x00009088  mov      x0, x1
0x0000908c  bl       #0x2480c   ; call _objc_release
0x00009090  b        #0x909c   ; call sub_909c
0x00009094  mov      x23, x1
0x00009098  mov      x21, x0
0x0000909c  mov      x0, x22
0x000090a0  bl       #0x2480c   ; call _objc_release
0x000090a4  b        #0x90b0   ; call sub_90b0

