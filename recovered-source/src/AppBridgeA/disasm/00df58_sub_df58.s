; ==== sub_df58 @ 0xdf58..0xdf90 (56 bytes) ====
0x0000df58  bl       #0x2441c   ; call _NSSelectorFromString
0x0000df5c  mov      x21, x0
0x0000df60  mov      x0, x19
0x0000df64  mov      x2, x21
0x0000df68  bl       #0x26180   ; objc_msgSend: methodSignatureForSelector:
0x0000df6c  mov      x29, x29
0x0000df70  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000df74  mov      x24, x0
0x0000df78  cbz      x0, #0xe168
0x0000df7c  str      x25, [sp]
0x0000df80  str      x23, [sp, #0x10]
0x0000df84  adrp     x8, #0x3e000
0x0000df88  ldr      x0, [x8, #0x388]   ; -> [class(NSInvocation)]
0x0000df8c  mov      x2, x24
