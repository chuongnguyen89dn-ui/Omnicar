; block literal @0x34b80 desc @0x34610 sig=v8@?0 flags=0x50000000
; ==== sub_1def4 @ 0x1def4..0x1e178 (644 bytes) ====
0x0001def4  stp      x20, x19, [sp, #-0x20]!
0x0001def8  stp      x29, x30, [sp, #0x10]
0x0001defc  add      x29, sp, #0x10
0x0001df00  adrp     x8, #0x3e000
0x0001df04  ldr      x0, [x8, #0x410]   ; -> [class(NSDateFormatter)]
0x0001df08  bl       #0x247e8   ; call _objc_opt_new
0x0001df0c  adrp     x19, #0x3e000
0x0001df10  ldr      x8, [x19, #0xaa0]
0x0001df14  str      x0, [x19, #0xaa0]
0x0001df18  mov      x0, x8
0x0001df1c  bl       #0x2480c   ; call _objc_release
0x0001df20  ldr      x0, [x19, #0xaa0]
0x0001df24  adrp     x2, #0x37000
0x0001df28  add      x2, x2, #0xad0   ; -> @"yyyy-MM-dd HH:mm:ss.SSS"
0x0001df2c  ldp      x29, x30, [sp, #0x10]
0x0001df30  ldp      x20, x19, [sp], #0x20
0x0001df34  b        #0x26e60   ; objc_msgSend: setDateFormat:
0x0001df38  stp      x20, x19, [sp, #-0x20]!
0x0001df3c  stp      x29, x30, [sp, #0x10]
0x0001df40  add      x29, sp, #0x10
0x0001df44  adrp     x8, #0x3e000
0x0001df48  ldr      x8, [x8, #0xb08]
0x0001df4c  cmn      x8, #1
0x0001df50  b.ne     #0x1df74
0x0001df54  adrp     x8, #0x3e000
0x0001df58  ldr      x19, [x8, #0xb00]
0x0001df5c  mov      x0, x19
0x0001df60  bl       #0x24818   ; call _objc_retain
0x0001df64  mov      x0, x19
0x0001df68  ldp      x29, x30, [sp, #0x10]
0x0001df6c  ldp      x20, x19, [sp], #0x20
0x0001df70  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x0001df74  bl       #0x2422c   ; call sub_2422c
0x0001df78  b        #0x1df54   ; call sub_1df54
0x0001df7c  sub      sp, sp, #0x50
0x0001df80  stp      x22, x21, [sp, #0x20]
0x0001df84  stp      x20, x19, [sp, #0x30]
0x0001df88  stp      x29, x30, [sp, #0x40]
0x0001df8c  add      x29, sp, #0x40
0x0001df90  mov      x19, x0
0x0001df94  adrp     x8, #0x34000
0x0001df98  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0001df9c  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0001dfa0  str      x8, [sp, #0x18]
0x0001dfa4  adrp     x20, #0x3e000
0x0001dfa8  ldr      x8, [x20, #0xb18]
0x0001dfac  cmn      x8, #1
0x0001dfb0  b.ne     #0x1e080
0x0001dfb4  adrp     x21, #0x3e000
0x0001dfb8  ldrb     w8, [x21, #0xb10]
0x0001dfbc  cmp      w8, #1
0x0001dfc0  b.ne     #0x1dfc8
0x0001dfc4  bl       #0x1e094   ; call sub_1e094
0x0001dfc8  ldr      x0, [x19, #0x20]   ; -> [@selector(timeZoneForSecondsFromGMT:)]
0x0001dfcc  bl       #0x1e154   ; call sub_1e154
0x0001dfd0  tbnz     w0, #0, #0x1e054
0x0001dfd4  ldr      x8, [x20, #0xb18]
0x0001dfd8  cmn      x8, #1
0x0001dfdc  b.ne     #0x1e088
0x0001dfe0  ldrb     w8, [x21, #0xb10]
0x0001dfe4  tbnz     w8, #0, #0x1e054
0x0001dfe8  bl       #0x1e1c4   ; call sub_1e1c4
0x0001dfec  mov      x29, x29
0x0001dff0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001dff4  mov      x20, x0
0x0001dff8  adrp     x8, #0x37000
0x0001dffc  add      x9, x8, #0xb30   ; -> @"line"
0x0001e000  ldr      x8, [x19, #0x20]   ; -> [@selector(timeZoneForSecondsFromGMT:)]
0x0001e004  stp      x9, x8, [sp, #8]
0x0001e008  adrp     x8, #0x3e000
0x0001e00c  ldr      x0, [x8, #0x310]   ; -> [class(NSDictionary)]
0x0001e010  add      x2, sp, #0x10
0x0001e014  add      x3, sp, #8
0x0001e018  mov      w4, #1
0x0001e01c  bl       #0x255c0   ; objc_msgSend: dictionaryWithObjects:forKeys:count:
0x0001e020  mov      x29, x29
0x0001e024  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e028  mov      x19, x0
0x0001e02c  adrp     x2, #0x37000
0x0001e030  add      x2, x2, #0xb10   ; -> @"com.anlai.omnicar/log"
0x0001e034  mov      x0, x20
0x0001e038  mov      x3, #0
0x0001e03c  mov      x4, x19
0x0001e040  bl       #0x26620   ; objc_msgSend: postNotificationName:object:userInfo:
0x0001e044  mov      x0, x19
0x0001e048  bl       #0x2480c   ; call _objc_release
0x0001e04c  mov      x0, x20
0x0001e050  bl       #0x2480c   ; call _objc_release
0x0001e054  ldr      x8, [sp, #0x18]
0x0001e058  adrp     x9, #0x34000
0x0001e05c  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x0001e060  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0001e064  cmp      x9, x8
0x0001e068  b.ne     #0x1e090
0x0001e06c  ldp      x29, x30, [sp, #0x40]
0x0001e070  ldp      x20, x19, [sp, #0x30]
0x0001e074  ldp      x22, x21, [sp, #0x20]
0x0001e078  add      sp, sp, #0x50
0x0001e07c  ret      
0x0001e080  bl       #0x24240   ; call sub_24240
0x0001e084  b        #0x1dfb4   ; call sub_1dfb4
0x0001e088  bl       #0x24244   ; call sub_24244
0x0001e08c  b        #0x1dfe0   ; call sub_1dfe0
0x0001e090  bl       #0x24488   ; call ___stack_chk_fail
0x0001e094  stp      x22, x21, [sp, #-0x30]!
0x0001e098  stp      x20, x19, [sp, #0x10]
0x0001e09c  stp      x29, x30, [sp, #0x20]
0x0001e0a0  add      x29, sp, #0x20
0x0001e0a4  adrp     x8, #0x3e000
0x0001e0a8  ldr      x0, [x8, #0x428]   ; -> [class(NSFileManager)]
0x0001e0ac  bl       #0x254e0   ; objc_msgSend: defaultManager
0x0001e0b0  mov      x29, x29
0x0001e0b4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e0b8  mov      x19, x0
0x0001e0bc  adrp     x2, #0x37000
0x0001e0c0  add      x2, x2, #0xa90   ; -> @"/var/mobile/Documents/OmniCar.log"
0x0001e0c4  mov      x3, #0
0x0001e0c8  bl       #0x24e40   ; objc_msgSend: attributesOfItemAtPath:error:
0x0001e0cc  mov      x29, x29
0x0001e0d0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e0d4  mov      x20, x0
0x0001e0d8  bl       #0x25720   ; objc_msgSend: fileSize
0x0001e0dc  mov      x21, x0
0x0001e0e0  mov      x0, x20
0x0001e0e4  bl       #0x2480c   ; call _objc_release
0x0001e0e8  cmp      x21, #0x200, lsl #12
0x0001e0ec  b.lo     #0x1e140
0x0001e0f0  adrp     x20, #0x37000
0x0001e0f4  add      x20, x20, #0xa90   ; -> @"/var/mobile/Documents/OmniCar.log"
0x0001e0f8  adrp     x2, #0x37000
0x0001e0fc  add      x2, x2, #0xf70   ; -> @".old"
0x0001e100  mov      x0, x20
0x0001e104  bl       #0x27c80   ; objc_msgSend: stringByAppendingString:
0x0001e108  mov      x29, x29
0x0001e10c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001e110  mov      x21, x0
0x0001e114  mov      x0, x19
0x0001e118  mov      x2, x21
0x0001e11c  mov      x3, #0
0x0001e120  bl       #0x26860   ; objc_msgSend: removeItemAtPath:error:
0x0001e124  mov      x0, x19
0x0001e128  mov      x2, x20
0x0001e12c  mov      x3, x21
0x0001e130  mov      x4, #0
0x0001e134  bl       #0x261a0   ; objc_msgSend: moveItemAtPath:toPath:error:
0x0001e138  mov      x0, x21
0x0001e13c  bl       #0x2480c   ; call _objc_release
0x0001e140  mov      x0, x19
0x0001e144  ldp      x29, x30, [sp, #0x20]
0x0001e148  ldp      x20, x19, [sp, #0x10]
0x0001e14c  ldp      x22, x21, [sp], #0x30
0x0001e150  b        #0x2480c   ; call _objc_release
0x0001e154  stp      x20, x19, [sp, #-0x20]!
0x0001e158  stp      x29, x30, [sp, #0x10]
0x0001e15c  add      x29, sp, #0x10
0x0001e160  mov      x19, x0
0x0001e164  bl       #0x24818   ; call _objc_retain
0x0001e168  adrp     x0, #0x37000
0x0001e16c  add      x0, x0, #0xa90   ; -> @"/var/mobile/Documents/OmniCar.log"
0x0001e170  bl       #0x25740   ; objc_msgSend: fileSystemRepresentation
0x0001e174  adrp     x1, #0x2a000

