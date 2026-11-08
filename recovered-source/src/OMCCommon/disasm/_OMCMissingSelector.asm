; === _OMCMissingSelector @ 0x7af8 size=428 ===
0x00007af8  sub      sp, sp, #0x60
0x00007afc  stp      x26, x25, [sp, #0x10]
0x00007b00  stp      x24, x23, [sp, #0x20]
0x00007b04  stp      x22, x21, [sp, #0x30]
0x00007b08  stp      x20, x19, [sp, #0x40]
0x00007b0c  stp      x29, x30, [sp, #0x50]
0x00007b10  add      x29, sp, #0x50
0x00007b14  mov      x21, x2
0x00007b18  mov      x20, x1
0x00007b1c  mov      x19, x0
0x00007b20  bl       #0xd4c4 ; call stub:_objc_retain
0x00007b24  mov      x0, x20
0x00007b28  bl       #0xd4c4 ; call stub:_objc_retain
0x00007b2c  mov      x0, x21
0x00007b30  bl       #0xd4c4 ; call stub:_objc_retain
0x00007b34  cbz      x20, #0x7c58
0x00007b38  adrp     x8, #0x18000
0x00007b3c  ldr      x8, [x8, #0x580] ; -> [__DATA,__bss+0x80]
0x00007b40  cmn      x8, #1
0x00007b44  b.ne     #0x7c88
0x00007b48  adrp     x24, #0x18000
0x00007b4c  ldr      x22, [x24, #0x3f0] ; -> [classref(NSString)]
0x00007b50  mov      x0, x20
0x00007b54  bl       #0xd47c ; call stub:_objc_opt_class
0x00007b58  bl       #0xd188 ; call stub:_NSStringFromClass
0x00007b5c  mov      x29, x29
0x00007b60  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007b64  mov      x23, x0
0x00007b68  stp      x0, x21, [sp]
0x00007b6c  adrp     x2, #0x15000
0x00007b70  add      x2, x2, #0xa48 ; -> CFSTR("%@ %@")
0x00007b74  mov      x0, x22
0x00007b78  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00007b7c  mov      x29, x29
0x00007b80  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007b84  mov      x22, x0
0x00007b88  mov      x0, x23
0x00007b8c  bl       #0xd4b8 ; call stub:_objc_release
0x00007b90  adrp     x25, #0x18000
0x00007b94  ldr      x23, [x25, #0x578] ; -> [__DATA,__bss+0x78]
0x00007b98  mov      x0, x23
0x00007b9c  bl       #0xd4c4 ; call stub:_objc_retain
0x00007ba0  mov      x0, x23
0x00007ba4  bl       #0xd4e8 ; call stub:_objc_sync_enter
0x00007ba8  ldr      x0, [x25, #0x578] ; -> [__DATA,__bss+0x78]
0x00007bac  mov      x2, x22
0x00007bb0  bl       #0xd900 ; call objc_stub[containsObject:]
0x00007bb4  tbz      w0, #0, #0x7bc4
0x00007bb8  mov      x0, x23
0x00007bbc  bl       #0xd4f4 ; call stub:_objc_sync_exit
0x00007bc0  b        #0x7c48
0x00007bc4  ldr      x0, [x25, #0x578] ; -> [__DATA,__bss+0x78]
0x00007bc8  mov      x2, x22
0x00007bcc  bl       #0xd6a0 ; call objc_stub[addObject:]
0x00007bd0  mov      x0, x23
0x00007bd4  bl       #0xd4f4 ; call stub:_objc_sync_exit
0x00007bd8  mov      x0, x23
0x00007bdc  bl       #0xd4b8 ; call stub:_objc_release
0x00007be0  ldr      x24, [x24, #0x3f0] ; -> [classref(NSString)]
0x00007be4  adrp     x8, #0x18000
0x00007be8  ldr      x0, [x8, #0x498] ; -> [classref(UIDevice)]
0x00007bec  bl       #0xd9a0 ; call objc_stub[currentDevice]
0x00007bf0  mov      x29, x29
0x00007bf4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007bf8  mov      x23, x0
0x00007bfc  bl       #0xe4a0 ; call objc_stub[systemVersion]
0x00007c00  mov      x29, x29
0x00007c04  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007c08  mov      x25, x0
0x00007c0c  stp      x0, x22, [sp]
0x00007c10  adrp     x2, #0x15000
0x00007c14  add      x2, x2, #0xa68 ; -> CFSTR("THIEU METHOD (iOS %@): %@ -> bo qua")
0x00007c18  mov      x0, x24
0x00007c1c  bl       #0xe420 ; call objc_stub[stringWithFormat:]
0x00007c20  mov      x29, x29
0x00007c24  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00007c28  mov      x24, x0
0x00007c2c  mov      x0, x19
0x00007c30  mov      x1, x24
0x00007c34  bl       #0x6be4 ; call _OMCLogWrite
0x00007c38  mov      x0, x24
0x00007c3c  bl       #0xd4b8 ; call stub:_objc_release
0x00007c40  mov      x0, x25
0x00007c44  bl       #0xd4b8 ; call stub:_objc_release
0x00007c48  mov      x0, x23
0x00007c4c  bl       #0xd4b8 ; call stub:_objc_release
0x00007c50  mov      x0, x22
0x00007c54  bl       #0xd4b8 ; call stub:_objc_release
0x00007c58  mov      x0, x21
0x00007c5c  bl       #0xd4b8 ; call stub:_objc_release
0x00007c60  mov      x0, x20
0x00007c64  bl       #0xd4b8 ; call stub:_objc_release
0x00007c68  mov      x0, x19
0x00007c6c  ldp      x29, x30, [sp, #0x50]
0x00007c70  ldp      x20, x19, [sp, #0x40]
0x00007c74  ldp      x22, x21, [sp, #0x30]
0x00007c78  ldp      x24, x23, [sp, #0x20]
0x00007c7c  ldp      x26, x25, [sp, #0x10]
0x00007c80  add      sp, sp, #0x60
0x00007c84  b        #0xd4b8 ; call stub:_objc_release
0x00007c88  bl       #0xd084 ; call sub_d084
0x00007c8c  b        #0x7b48
0x00007c90  mov      x19, x0
0x00007c94  mov      x0, x23
0x00007c98  bl       #0xd4f4 ; call stub:_objc_sync_exit
0x00007c9c  mov      x0, x19
0x00007ca0  bl       #0xd1a0 ; call stub:__Unwind_Resume
