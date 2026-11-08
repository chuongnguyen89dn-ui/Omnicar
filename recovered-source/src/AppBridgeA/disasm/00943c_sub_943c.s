; ==== sub_943c @ 0x943c..0x94c8 (140 bytes) ====
0x0000943c  adrp     x8, #0x3e000
0x00009440  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x00009444  ldr      x8, [sp, #8]
0x00009448  lsr      x8, x8, #0x18
0x0000944c  str      x8, [sp]
0x00009450  adrp     x2, #0x35000
0x00009454  add      x2, x2, #0x890   ; -> @"ban phim: khong co o cho hash %llu"
0x00009458  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000945c  mov      x29, x29
0x00009460  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009464  mov      x20, x0
0x00009468  adrp     x0, #0x34000
0x0000946c  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00009470  mov      x1, x20
0x00009474  bl       #0x1dd30   ; call _OMCLogWrite
0x00009478  b        #0x94a0   ; call sub_94a0
0x0000947c  bl       #0x27b20   ; objc_msgSend: shared
0x00009480  mov      x29, x29
0x00009484  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009488  mov      x20, x0
0x0000948c  ldr      x8, [sp, #8]
0x00009490  ubfx     x3, x8, #1, #7
0x00009494  ubfx     x4, x8, #8, #8
0x00009498  mov      x2, x19
0x0000949c  bl       #0x27bc0   ; objc_msgSend: showForApp:keyboardType:returnType:
0x000094a0  mov      x0, x20
0x000094a4  bl       #0x2480c   ; call _objc_release
0x000094a8  mov      x0, x19
0x000094ac  bl       #0x2480c   ; call _objc_release
0x000094b0  ldp      x29, x30, [sp, #0x30]
0x000094b4  ldp      x20, x19, [sp, #0x20]
0x000094b8  ldp      x22, x21, [sp, #0x10]
0x000094bc  add      sp, sp, #0x40
0x000094c0  ret      
0x000094c4  b        #0x94cc   ; call sub_94cc
