; === sub_bde0 @ 0xbde0 size=292 ===
0x0000bde0  sub      sp, sp, #0x40
0x0000bde4  stp      x22, x21, [sp, #0x10]
0x0000bde8  stp      x20, x19, [sp, #0x20]
0x0000bdec  stp      x29, x30, [sp, #0x30]
0x0000bdf0  add      x29, sp, #0x30
0x0000bdf4  mov      x19, x1
0x0000bdf8  mov      x20, x0
0x0000bdfc  mov      x0, x1
0x0000be00  bl       #0xd4c4 ; call stub:_objc_retain
0x0000be04  adrp     x8, #0x18000
0x0000be08  ldrb     w9, [x8, #0x6d0]
0x0000be0c  cmp      w9, w20
0x0000be10  b.eq     #0xbeec
0x0000be14  strb     w20, [x8, #0x6d0]
0x0000be18  bl       #0xb1e4 ; call sub_b1e4
0x0000be1c  adrp     x8, #0x18000
0x0000be20  str      d0, [x8, #0x6f0]
0x0000be24  tbz      w20, #0, #0xbe88
0x0000be28  adrp     x8, #0x18000
0x0000be2c  ldr      x9, [x8, #0x6c8] ; -> [__DATA,__bss+0x1c8]
0x0000be30  add      x9, x9, #1
0x0000be34  str      x9, [x8, #0x6c8]
0x0000be38  mov      x0, x19
0x0000be3c  bl       #0xd4c4 ; call stub:_objc_retain
0x0000be40  adrp     x8, #0x18000
0x0000be44  ldr      x0, [x8, #0x5b8] ; -> [__DATA,__bss+0xb8]
0x0000be48  str      x19, [x8, #0x5b8]
0x0000be4c  bl       #0xd4b8 ; call stub:_objc_release
0x0000be50  mov      w0, #1
0x0000be54  bl       #0xaee4 ; call sub_aee4
0x0000be58  adrp     x8, #0x18000
0x0000be5c  ldr      x22, [x8, #0x3f0] ; -> [classref(NSString)]
0x0000be60  adrp     x0, #0x16000
0x0000be64  add      x0, x0, #0x1c8 ; -> CFSTR(" vi ")
0x0000be68  mov      x2, x19
0x0000be6c  bl       #0xe3a0 ; call objc_stub[stringByAppendingString:]
0x0000be70  mov      x29, x29
0x0000be74  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000be78  mov      x21, x0
0x0000be7c  adrp     x8, #0x16000
0x0000be80  add      x8, x8, #0x188 ; -> CFSTR("BAT")
0x0000be84  b        #0xbea8
0x0000be88  mov      w0, #0
0x0000be8c  bl       #0xaee4 ; call sub_aee4
0x0000be90  adrp     x8, #0x18000
0x0000be94  ldr      x22, [x8, #0x3f0] ; -> [classref(NSString)]
0x0000be98  adrp     x21, #0x15000
0x0000be9c  add      x21, x21, #0x2a8 ; -> CFSTR("")
0x0000bea0  adrp     x8, #0x16000
0x0000bea4  add      x8, x8, #0x1a8 ; -> CFSTR("tat")
0x0000bea8  stp      x8, x21, [sp]
0x0000beac  adrp     x2, #0x16000
0x0000beb0  add      x2, x2, #0x168 ; -> CFSTR("che do nhe tu dong: %@%@")
0x0000beb4  mov      x0, x22
0x0000beb8  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x0000bebc  mov      x29, x29
0x0000bec0  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000bec4  mov      x22, x0
0x0000bec8  adrp     x0, #0x14000
0x0000becc  add      x0, x0, #0x8a8 ; -> CFSTR("Core")
0x0000bed0  mov      x1, x22
0x0000bed4  bl       #0x6be4 ; call _OMCLogWrite
0x0000bed8  mov      x0, x22
0x0000bedc  bl       #0xd4b8 ; call stub:_objc_release
0x0000bee0  cbz      w20, #0xbeec
0x0000bee4  mov      x0, x21
0x0000bee8  bl       #0xd4b8 ; call stub:_objc_release
0x0000beec  mov      x0, x19
0x0000bef0  ldp      x29, x30, [sp, #0x30]
0x0000bef4  ldp      x20, x19, [sp, #0x20]
0x0000bef8  ldp      x22, x21, [sp, #0x10]
0x0000befc  add      sp, sp, #0x40
0x0000bf00  b        #0xd4b8 ; call stub:_objc_release
