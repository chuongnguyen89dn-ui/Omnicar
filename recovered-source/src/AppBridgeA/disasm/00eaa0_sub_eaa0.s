; ==== sub_eaa0 @ 0xeaa0..0xeaf0 (80 bytes) ====
0x0000eaa0  mov      x0, x22
0x0000eaa4  bl       #0x26a40   ; objc_msgSend: sceneMonitor
0x0000eaa8  mov      x29, x29
0x0000eaac  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000eab0  cmp      x0, x19
0x0000eab4  cset     w26, eq
0x0000eab8  bl       #0x2480c   ; call _objc_release
0x0000eabc  tbnz     w26, #0, #0xeaec
0x0000eac0  add      x25, x25, #1
0x0000eac4  cmp      x23, x25
0x0000eac8  b.ne     #0xea80
0x0000eacc  add      x2, sp, #0x10
0x0000ead0  add      x3, sp, #0x58
0x0000ead4  mov      x0, x20
0x0000ead8  mov      w4, #0x10
0x0000eadc  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0000eae0  mov      x23, x0
0x0000eae4  cbnz     x0, #0xea7c
0x0000eae8  b        #0xebac   ; call sub_ebac
0x0000eaec  adrp     x8, #0x3e000
