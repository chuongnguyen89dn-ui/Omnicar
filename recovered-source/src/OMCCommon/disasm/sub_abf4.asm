; === sub_abf4 @ 0xabf4 size=752 ===
0x0000abf4  sub      sp, sp, #0x90
0x0000abf8  stp      x28, x27, [sp, #0x30]
0x0000abfc  stp      x26, x25, [sp, #0x40]
0x0000ac00  stp      x24, x23, [sp, #0x50]
0x0000ac04  stp      x22, x21, [sp, #0x60]
0x0000ac08  stp      x20, x19, [sp, #0x70]
0x0000ac0c  stp      x29, x30, [sp, #0x80]
0x0000ac10  add      x29, sp, #0x80
0x0000ac14  mov      x19, x0
0x0000ac18  bl       #0xd4c4 ; call stub:_objc_retain
0x0000ac1c  adrp     x8, #0x18000
0x0000ac20  ldr      x0, [x8, #0x470] ; -> [classref(NSMutableDictionary)]
0x0000ac24  bl       #0xda80 ; call objc_stub[dictionary]
0x0000ac28  mov      x29, x29
0x0000ac2c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000ac30  mov      x20, x0
0x0000ac34  str      x19, [sp, #0x20]
0x0000ac38  mov      x0, x19
0x0000ac3c  bl       #0xd47c ; call stub:_objc_opt_class
0x0000ac40  cbz      x0, #0xaeb4
0x0000ac44  mov      x21, x0
0x0000ac48  adrp     x23, #0x18000
0x0000ac4c  adrp     x19, #0x18000
0x0000ac50  ldr      x0, [x23, #0x4c8] ; -> [classref(NSObject)]
0x0000ac54  bl       #0xd47c ; call stub:_objc_opt_class
0x0000ac58  cmp      x21, x0
0x0000ac5c  b.eq     #0xaeb4
0x0000ac60  mov      x0, x20
0x0000ac64  bl       #0xd960 ; call objc_stub[count]
0x0000ac68  cmp      x0, #0x50
0x0000ac6c  b.hs     #0xaeb4
0x0000ac70  str      wzr, [sp, #0x2c]
0x0000ac74  add      x1, sp, #0x2c
0x0000ac78  mov      x0, x21
0x0000ac7c  bl       #0xd224 ; call stub:_class_copyPropertyList
0x0000ac80  mov      x28, x0
0x0000ac84  ldr      w8, [sp, #0x2c]
0x0000ac88  cbz      w8, #0xae9c
0x0000ac8c  mov      x24, #0
0x0000ac90  ldr      x22, [x19, #0x3f0] ; -> [classref(NSString)]
0x0000ac94  ldr      x0, [x28, x24, lsl #3]
0x0000ac98  bl       #0xd530 ; call stub:_property_getName
0x0000ac9c  mov      x2, x0
0x0000aca0  mov      x0, x22
0x0000aca4  bl       #0xe440 ; call objc_stub[stringWithUTF8String:]
0x0000aca8  mov      x29, x29
0x0000acac  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000acb0  mov      x25, x0
0x0000acb4  ldr      x0, [x28, x24, lsl #3]
0x0000acb8  bl       #0xd524 ; call stub:_property_getAttributes
0x0000acbc  cbz      x0, #0xae68
0x0000acc0  ldrb     w8, [x0]
0x0000acc4  cmp      w8, #0x54
0x0000acc8  b.ne     #0xae68
0x0000accc  ldrb     w8, [x0, #1]
0x0000acd0  cmp      w8, #0x5e
0x0000acd4  b.eq     #0xae68
0x0000acd8  cmp      w8, #0x40
0x0000acdc  b.ne     #0xacec
0x0000ace0  ldrb     w8, [x0, #2]
0x0000ace4  cmp      w8, #0x3f
0x0000ace8  b.eq     #0xae68
0x0000acec  mov      x0, x20
0x0000acf0  mov      x2, x25
0x0000acf4  bl       #0xdf60 ; call objc_stub[objectForKeyedSubscript:]
0x0000acf8  mov      x29, x29
0x0000acfc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000ad00  mov      x22, x0
0x0000ad04  bl       #0xd4b8 ; call stub:_objc_release
0x0000ad08  cbnz     x22, #0xae68
0x0000ad0c  mov      x0, x25
0x0000ad10  adrp     x2, #0x16000
0x0000ad14  add      x2, x2, #0x4a8 ; -> CFSTR("_")
0x0000ad18  bl       #0xdba0 ; call objc_stub[hasPrefix:]
0x0000ad1c  tbnz     w0, #0, #0xae68
0x0000ad20  adrp     x0, #0x17000
0x0000ad24  add      x0, x0, #0x78 ; -> __DATA_CONST,__objc_arrayobj+0x60 (const collection)
0x0000ad28  mov      x2, x25
0x0000ad2c  bl       #0xd900 ; call objc_stub[containsObject:]
0x0000ad30  tbnz     w0, #0, #0xae68
0x0000ad34  ldr      x0, [sp, #0x20]
0x0000ad38  mov      x2, x25
0x0000ad3c  bl       #0xe5c0 ; call objc_stub[valueForKey:]
0x0000ad40  mov      x29, x29
0x0000ad44  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000ad48  str      x0, [sp, #0x18]
0x0000ad4c  bl       #0xda60 ; call objc_stub[description]
0x0000ad50  mov      x29, x29
0x0000ad54  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000ad58  mov      x22, x0
0x0000ad5c  cmp      x0, #0
0x0000ad60  adrp     x8, #0x16000
0x0000ad64  add      x8, x8, #0x548 ; -> CFSTR("nil")
0x0000ad68  csel     x23, x8, x0, eq
0x0000ad6c  mov      x0, x23
0x0000ad70  bl       #0xd4c4 ; call stub:_objc_retain
0x0000ad74  mov      x0, x22
0x0000ad78  bl       #0xd4b8 ; call stub:_objc_release
0x0000ad7c  adrp     x8, #0x18000
0x0000ad80  ldr      x0, [x8, #0x4d0] ; -> [classref(NSCharacterSet)]
0x0000ad84  bl       #0xde60 ; call objc_stub[newlineCharacterSet]
0x0000ad88  mov      x29, x29
0x0000ad8c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000ad90  mov      x27, x0
0x0000ad94  mov      x0, x23
0x0000ad98  mov      x2, x27
0x0000ad9c  bl       #0xd8a0 ; call objc_stub[componentsSeparatedByCharactersInSet:]
0x0000ada0  mov      x29, x29
0x0000ada4  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000ada8  mov      x22, x0
0x0000adac  adrp     x2, #0x15000
0x0000adb0  add      x2, x2, #0x8e8 ; -> CFSTR(" ")
0x0000adb4  bl       #0xd880 ; call objc_stub[componentsJoinedByString:]
0x0000adb8  mov      x29, x29
0x0000adbc  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000adc0  mov      x26, x0
0x0000adc4  mov      x0, x23
0x0000adc8  bl       #0xd4b8 ; call stub:_objc_release
0x0000adcc  mov      x0, x22
0x0000add0  bl       #0xd4b8 ; call stub:_objc_release
0x0000add4  mov      x0, x27
0x0000add8  bl       #0xd4b8 ; call stub:_objc_release
0x0000addc  mov      x0, x26
0x0000ade0  bl       #0xdce0 ; call objc_stub[length]
0x0000ade4  mov      x23, x0
0x0000ade8  cmp      x0, #0xa1
0x0000adec  b.lo     #0xae2c
0x0000adf0  mov      x0, x26
0x0000adf4  mov      w2, #0xa0
0x0000adf8  bl       #0xe480 ; call objc_stub[substringToIndex:]
0x0000adfc  mov      x29, x29
0x0000ae00  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000ae04  mov      x22, x0
0x0000ae08  str      x0, [sp, #0x10]
0x0000ae0c  adrp     x2, #0x16000
0x0000ae10  add      x2, x2, #0x568 ; -> CFSTR("...")
0x0000ae14  bl       #0xe3a0 ; call objc_stub[stringByAppendingString:]
0x0000ae18  mov      x29, x29
0x0000ae1c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x0000ae20  mov      x2, x0
0x0000ae24  stp      x0, x22, [sp, #8]
0x0000ae28  b        #0xae30
0x0000ae2c  mov      x2, x26
0x0000ae30  mov      x0, x20
0x0000ae34  mov      x3, x25
0x0000ae38  bl       #0xe2a0 ; call objc_stub[setObject:forKeyedSubscript:]
0x0000ae3c  cmp      x23, #0xa1
0x0000ae40  b.lo     #0xae54
0x0000ae44  ldr      x0, [sp, #8]
0x0000ae48  bl       #0xd4b8 ; call stub:_objc_release
0x0000ae4c  ldr      x0, [sp, #0x10]
0x0000ae50  bl       #0xd4b8 ; call stub:_objc_release
0x0000ae54  mov      x0, x26
0x0000ae58  bl       #0xd4b8 ; call stub:_objc_release
0x0000ae5c  ldr      x0, [sp, #0x18]
0x0000ae60  bl       #0xd4b8 ; call stub:_objc_release
0x0000ae64  adrp     x23, #0x18000
0x0000ae68  mov      x0, x25
0x0000ae6c  bl       #0xd4b8 ; call stub:_objc_release
0x0000ae70  add      x24, x24, #1
0x0000ae74  ldr      w8, [sp, #0x2c]
0x0000ae78  cmp      x24, x8
0x0000ae7c  b.lo     #0xac90
0x0000ae80  b        #0xae9c
0x0000ae84  b        #0xae88
0x0000ae88  cmp      w1, #1
0x0000ae8c  b.ne     #0xaee0
0x0000ae90  bl       #0xd440 ; call stub:_objc_begin_catch
0x0000ae94  bl       #0xd44c ; call stub:_objc_end_catch
0x0000ae98  b        #0xae64
0x0000ae9c  mov      x0, x28
0x0000aea0  bl       #0xd338 ; call stub:_free
0x0000aea4  mov      x0, x21
0x0000aea8  bl       #0xd248 ; call stub:_class_getSuperclass
0x0000aeac  mov      x21, x0
0x0000aeb0  cbnz     x0, #0xac50
0x0000aeb4  ldr      x0, [sp, #0x20]
0x0000aeb8  bl       #0xd4b8 ; call stub:_objc_release
0x0000aebc  mov      x0, x20
0x0000aec0  ldp      x29, x30, [sp, #0x80]
0x0000aec4  ldp      x20, x19, [sp, #0x70]
0x0000aec8  ldp      x22, x21, [sp, #0x60]
0x0000aecc  ldp      x24, x23, [sp, #0x50]
0x0000aed0  ldp      x26, x25, [sp, #0x40]
0x0000aed4  ldp      x28, x27, [sp, #0x30]
0x0000aed8  add      sp, sp, #0x90
0x0000aedc  b        #0xd434 ; call stub:_objc_autoreleaseReturnValue
0x0000aee0  bl       #0xd1a0 ; call stub:__Unwind_Resume
