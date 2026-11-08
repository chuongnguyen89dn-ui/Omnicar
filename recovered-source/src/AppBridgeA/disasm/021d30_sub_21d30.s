; ==== sub_21d30 @ 0x21d30..0x21ef4 (452 bytes) ====
0x00021d30  ldp      x29, x30, [sp, #0x60]
0x00021d34  ldp      x20, x19, [sp, #0x50]
0x00021d38  ldp      x22, x21, [sp, #0x40]
0x00021d3c  ldp      x24, x23, [sp, #0x30]
0x00021d40  ldp      x26, x25, [sp, #0x20]
0x00021d44  ldp      x28, x27, [sp, #0x10]
0x00021d48  ldp      d9, d8, [sp], #0x70
0x00021d4c  ret      
0x00021d50  bl       #0x24488   ; call ___stack_chk_fail
0x00021d54  mov      x19, x0
0x00021d58  bl       #0x24764   ; call _objc_end_catch
0x00021d5c  b        #0x21d64   ; call sub_21d64
0x00021d60  mov      x19, x0
0x00021d64  mov      x0, x19
0x00021d68  bl       #0x24470   ; call __Unwind_Resume
0x00021d6c  sub      sp, sp, #0x90
0x00021d70  stp      x28, x27, [sp, #0x30]
0x00021d74  stp      x26, x25, [sp, #0x40]
0x00021d78  stp      x24, x23, [sp, #0x50]
0x00021d7c  stp      x22, x21, [sp, #0x60]
0x00021d80  stp      x20, x19, [sp, #0x70]
0x00021d84  stp      x29, x30, [sp, #0x80]
0x00021d88  add      x29, sp, #0x80
0x00021d8c  mov      x19, x0
0x00021d90  bl       #0x24818   ; call _objc_retain
0x00021d94  adrp     x8, #0x3e000
0x00021d98  ldr      x0, [x8, #0x398]   ; -> [class(NSMutableDictionary)]
0x00021d9c  bl       #0x25580   ; objc_msgSend: dictionary
0x00021da0  mov      x29, x29
0x00021da4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021da8  mov      x20, x0
0x00021dac  str      x19, [sp, #0x20]
0x00021db0  mov      x0, x19
0x00021db4  bl       #0x247d0   ; call _objc_opt_class
0x00021db8  cbz      x0, #0x2202c
0x00021dbc  mov      x21, x0
0x00021dc0  adrp     x23, #0x3e000
0x00021dc4  adrp     x19, #0x3e000
0x00021dc8  ldr      x0, [x23, #0x440]   ; -> [class(NSObject)]
0x00021dcc  bl       #0x247d0   ; call _objc_opt_class
0x00021dd0  cmp      x21, x0
0x00021dd4  b.eq     #0x2202c
0x00021dd8  mov      x0, x20
0x00021ddc  bl       #0x25420   ; objc_msgSend: count
0x00021de0  cmp      x0, #0x50
0x00021de4  b.hs     #0x2202c
0x00021de8  str      wzr, [sp, #0x2c]
0x00021dec  add      x1, sp, #0x2c
0x00021df0  mov      x0, x21
0x00021df4  bl       #0x2450c   ; call _class_copyPropertyList
0x00021df8  mov      x28, x0
0x00021dfc  ldr      w8, [sp, #0x2c]
0x00021e00  cbz      w8, #0x22014
0x00021e04  mov      x24, #0
0x00021e08  ldr      x22, [x19, #0x290]   ; -> [class(NSString)]
0x00021e0c  ldr      x0, [x28, x24, lsl #3]
0x00021e10  bl       #0x248d8   ; call _property_getName
0x00021e14  mov      x2, x0
0x00021e18  mov      x0, x22
0x00021e1c  bl       #0x27d40   ; objc_msgSend: stringWithUTF8String:
0x00021e20  mov      x29, x29
0x00021e24  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021e28  mov      x25, x0
0x00021e2c  ldr      x0, [x28, x24, lsl #3]
0x00021e30  bl       #0x248cc   ; call _property_getAttributes
0x00021e34  cbz      x0, #0x21fe0
0x00021e38  ldrb     w8, [x0]
0x00021e3c  cmp      w8, #0x54
0x00021e40  b.ne     #0x21fe0
0x00021e44  ldrb     w8, [x0, #1]
0x00021e48  cmp      w8, #0x5e
0x00021e4c  b.eq     #0x21fe0
0x00021e50  cmp      w8, #0x40
0x00021e54  b.ne     #0x21e64
0x00021e58  ldrb     w8, [x0, #2]
0x00021e5c  cmp      w8, #0x3f
0x00021e60  b.eq     #0x21fe0
0x00021e64  mov      x0, x20
0x00021e68  mov      x2, x25
0x00021e6c  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00021e70  mov      x29, x29
0x00021e74  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021e78  mov      x22, x0
0x00021e7c  bl       #0x2480c   ; call _objc_release
0x00021e80  cbnz     x22, #0x21fe0
0x00021e84  mov      x0, x25
0x00021e88  adrp     x2, #0x37000
0x00021e8c  add      x2, x2, #0x790   ; -> @"_"
0x00021e90  bl       #0x258a0   ; objc_msgSend: hasPrefix:
0x00021e94  tbnz     w0, #0, #0x21fe0
0x00021e98  adrp     x0, #0x39000
0x00021e9c  add      x0, x0, #0x4e0
0x00021ea0  mov      x2, x25
0x00021ea4  bl       #0x25360   ; objc_msgSend: containsObject:
0x00021ea8  tbnz     w0, #0, #0x21fe0
0x00021eac  ldr      x0, [sp, #0x20]
0x00021eb0  mov      x2, x25
0x00021eb4  bl       #0x28100   ; objc_msgSend: valueForKey:
0x00021eb8  mov      x29, x29
0x00021ebc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021ec0  str      x0, [sp, #0x18]
0x00021ec4  bl       #0x25560   ; objc_msgSend: description
0x00021ec8  mov      x29, x29
0x00021ecc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021ed0  mov      x22, x0
0x00021ed4  cmp      x0, #0
0x00021ed8  adrp     x8, #0x38000
0x00021edc  add      x8, x8, #0x710   ; -> @"nil"
0x00021ee0  csel     x23, x8, x0, eq
0x00021ee4  mov      x0, x23
0x00021ee8  bl       #0x24818   ; call _objc_retain
0x00021eec  mov      x0, x22
0x00021ef0  bl       #0x2480c   ; call _objc_release
