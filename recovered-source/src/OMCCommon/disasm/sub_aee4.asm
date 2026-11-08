; === sub_aee4 @ 0xaee4 size=112 ===
0x0000aee4  stp      x20, x19, [sp, #-0x20]!
0x0000aee8  stp      x29, x30, [sp, #0x10]
0x0000aeec  add      x29, sp, #0x10
0x0000aef0  mov      x19, x0
0x0000aef4  adrp     x20, #0x18000
0x0000aef8  ldr      w0, [x20, #0x4f4] ; -> [__DATA,__data+0x4]
0x0000aefc  cmn      w0, #1
0x0000af00  b.eq     #0xaf10
0x0000af04  mov      w1, w19
0x0000af08  bl       #0xd3f8 ; call stub:_notify_set_state
0x0000af0c  b        #0xaf30
0x0000af10  adrp     x0, #0xe000
0x0000af14  add      x0, x0, #0xf84 ; -> "com.anlai.omnicar/lite"
0x0000af18  adrp     x1, #0x18000
0x0000af1c  add      x1, x1, #0x4f4 ; -> __DATA,__data+0x4
0x0000af20  bl       #0xd3e0 ; call stub:_notify_register_check
0x0000af24  cbz      w0, #0xaf44
0x0000af28  mov      w8, #-1
0x0000af2c  str      w8, [x20, #0x4f4]
0x0000af30  adrp     x0, #0xe000
0x0000af34  add      x0, x0, #0xf84 ; -> "com.anlai.omnicar/lite"
0x0000af38  ldp      x29, x30, [sp, #0x10]
0x0000af3c  ldp      x20, x19, [sp], #0x20
0x0000af40  b        #0xd3d4 ; call stub:_notify_post
0x0000af44  ldr      w0, [x20, #0x4f4] ; -> [__DATA,__data+0x4]
0x0000af48  cmn      w0, #1
0x0000af4c  b.ne     #0xaf04
0x0000af50  b        #0xaf30
