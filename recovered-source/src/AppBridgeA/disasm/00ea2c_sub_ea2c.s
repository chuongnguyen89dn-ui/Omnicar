; ==== sub_ea2c @ 0xea2c..0xeaa0 (116 bytes) ====
0x0000ea2c  stp      q0, q0, [sp, #0x10]
0x0000ea30  stp      q0, q0, [sp, #0x30]
0x0000ea34  mov      x0, x21
0x0000ea38  bl       #0x26580   ; objc_msgSend: panes
0x0000ea3c  mov      x29, x29
0x0000ea40  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ea44  mov      x22, x0
0x0000ea48  bl       #0x253e0   ; objc_msgSend: copy
0x0000ea4c  mov      x20, x0
0x0000ea50  mov      x0, x22
0x0000ea54  bl       #0x2480c   ; call _objc_release
0x0000ea58  add      x2, sp, #0x10
0x0000ea5c  add      x3, sp, #0x58
0x0000ea60  mov      x0, x20
0x0000ea64  mov      w4, #0x10
0x0000ea68  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0000ea6c  mov      x23, x0
0x0000ea70  cbz      x0, #0xebac
0x0000ea74  ldr      x8, [sp, #0x20]
0x0000ea78  ldr      x24, [x8]
0x0000ea7c  mov      x25, #0
0x0000ea80  ldr      x8, [sp, #0x20]
0x0000ea84  ldr      x8, [x8]
0x0000ea88  cmp      x8, x24
0x0000ea8c  b.eq     #0xea98
0x0000ea90  mov      x0, x20
0x0000ea94  bl       #0x24770   ; call _objc_enumerationMutation
0x0000ea98  ldr      x8, [sp, #0x18]
0x0000ea9c  ldr      x22, [x8, x25, lsl #3]
