; ==== sub_1a764 @ 0x1a764..0x1a794 (48 bytes) ====
0x0001a764  mov      x2, x26
0x0001a768  bl       #0x26f60   ; objc_msgSend: setFont:
0x0001a76c  mov      x0, x27
0x0001a770  bl       #0x2480c   ; call _objc_release
0x0001a774  mov      x0, x26
0x0001a778  bl       #0x2480c   ; call _objc_release
0x0001a77c  adrp     x8, #0x3e000
0x0001a780  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x0001a784  adrp     x8, #0x2b000
0x0001a788  ldr      d8, [x8, #0x218]
0x0001a78c  adrp     x8, #0x2b000
0x0001a790  ldr      d9, [x8, #0x220]
