; block literal @0x34c30 desc @0x34610 sig=v8@?0 flags=0x50000000
; ==== sub_20414 @ 0x20414..0x20474 (96 bytes) ====
0x00020414  stp      x20, x19, [sp, #-0x20]!
0x00020418  stp      x29, x30, [sp, #0x10]
0x0002041c  add      x29, sp, #0x10
0x00020420  adrp     x8, #0x3e000
0x00020424  ldr      x0, [x8, #0x280]   ; -> [class(NSBundle)]
0x00020428  bl       #0x26080   ; objc_msgSend: mainBundle
0x0002042c  mov      x29, x29
0x00020430  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020434  mov      x19, x0
0x00020438  bl       #0x25040   ; objc_msgSend: bundleIdentifier
0x0002043c  mov      x29, x29
0x00020440  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020444  mov      x20, x0
0x00020448  adrp     x2, #0x34000
0x0002044c  add      x2, x2, #0xdf0   ; -> @"com.apple.springboard"
0x00020450  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00020454  adrp     x8, #0x3e000
0x00020458  strb     w0, [x8, #0xb10]
0x0002045c  mov      x0, x20
0x00020460  bl       #0x2480c   ; call _objc_release
0x00020464  mov      x0, x19
0x00020468  ldp      x29, x30, [sp, #0x10]
0x0002046c  ldp      x20, x19, [sp], #0x20
0x00020470  b        #0x2480c   ; call _objc_release

