; ==== sub_1ccb4 @ 0x1ccb4..0x1cd44 (144 bytes) ====
0x0001ccb4  bl       #0x28220   ; objc_msgSend: word
0x0001ccb8  mov      x29, x29
0x0001ccbc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ccc0  mov      x22, x0
0x0001ccc4  mov      x2, x19
0x0001ccc8  bl       #0x24d60   ; objc_msgSend: appendString:
0x0001cccc  b        #0x1ccf0   ; call sub_1ccf0
0x0001ccd0  mov      x0, x21
0x0001ccd4  bl       #0x28220   ; objc_msgSend: word
0x0001ccd8  mov      x29, x29
0x0001ccdc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001cce0  mov      x22, x0
0x0001cce4  adrp     x2, #0x36000
0x0001cce8  add      x2, x2, #0x6f0   ; -> @""
0x0001ccec  bl       #0x27860   ; objc_msgSend: setString:
0x0001ccf0  mov      x0, x22
0x0001ccf4  bl       #0x2480c   ; call _objc_release
0x0001ccf8  mov      x0, x20
0x0001ccfc  bl       #0x2480c   ; call _objc_release
0x0001cd00  mov      x0, x19
0x0001cd04  ldp      x29, x30, [sp, #0x50]
0x0001cd08  ldp      x20, x19, [sp, #0x40]
0x0001cd0c  ldp      x22, x21, [sp, #0x30]
0x0001cd10  ldp      x24, x23, [sp, #0x20]
0x0001cd14  ldp      x26, x25, [sp, #0x10]
0x0001cd18  ldp      x28, x27, [sp], #0x60
0x0001cd1c  b        #0x2480c   ; call _objc_release
0x0001cd20  b        #0x1cd94   ; call sub_1cd94
0x0001cd24  b        #0x1cd94   ; call sub_1cd94
0x0001cd28  mov      x21, x0
0x0001cd2c  mov      x0, x23
0x0001cd30  bl       #0x2480c   ; call _objc_release
0x0001cd34  b        #0x1cd88   ; call sub_1cd88
0x0001cd38  b        #0x1cd94   ; call sub_1cd94
0x0001cd3c  b        #0x1cda8   ; call sub_1cda8
0x0001cd40  b        #0x1cd94   ; call sub_1cd94
