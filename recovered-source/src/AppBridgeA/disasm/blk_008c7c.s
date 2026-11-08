; block literal @0x346d0 desc @0x34670 sig=v16@?0@"NSNotification"8 flags=0x50000000
; ==== sub_8c7c @ 0x8c7c..0x8df0 (372 bytes) ====
0x00008c7c  sub      sp, sp, #0x50
0x00008c80  stp      x24, x23, [sp, #0x10]
0x00008c84  stp      x22, x21, [sp, #0x20]
0x00008c88  stp      x20, x19, [sp, #0x30]
0x00008c8c  stp      x29, x30, [sp, #0x40]
0x00008c90  add      x29, sp, #0x40
0x00008c94  mov      x19, x1
0x00008c98  mov      x0, x1
0x00008c9c  bl       #0x24818   ; call _objc_retain
0x00008ca0  adrp     x8, #0x3e000
0x00008ca4  ldr      x0, [x8, #0x2e0]   ; -> [class(ABHost)]
0x00008ca8  bl       #0x27b20   ; objc_msgSend: shared
0x00008cac  mov      x29, x29
0x00008cb0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008cb4  mov      x20, x0
0x00008cb8  mov      x0, x19
0x00008cbc  bl       #0x280c0   ; objc_msgSend: userInfo
0x00008cc0  mov      x29, x29
0x00008cc4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008cc8  mov      x22, x0
0x00008ccc  adrp     x2, #0x35000
0x00008cd0  add      x2, x2, #0x710   ; -> @"on"
0x00008cd4  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x00008cd8  mov      x29, x29
0x00008cdc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008ce0  mov      x21, x0
0x00008ce4  bl       #0x24f20   ; objc_msgSend: boolValue
0x00008ce8  mov      x2, x0
0x00008cec  mov      x0, x20
0x00008cf0  bl       #0x277c0   ; objc_msgSend: setShieldAll:
0x00008cf4  mov      x0, x21
0x00008cf8  bl       #0x2480c   ; call _objc_release
0x00008cfc  mov      x0, x22
0x00008d00  bl       #0x2480c   ; call _objc_release
0x00008d04  mov      x0, x20
0x00008d08  bl       #0x2480c   ; call _objc_release
0x00008d0c  mov      x0, x19
0x00008d10  ldp      x29, x30, [sp, #0x40]
0x00008d14  ldp      x20, x19, [sp, #0x30]
0x00008d18  ldp      x22, x21, [sp, #0x20]
0x00008d1c  ldp      x24, x23, [sp, #0x10]
0x00008d20  add      sp, sp, #0x50
0x00008d24  b        #0x2480c   ; call _objc_release
0x00008d28  mov      x23, x1
0x00008d2c  mov      x21, x0
0x00008d30  b        #0x8d60   ; call sub_8d60
0x00008d34  mov      x23, x1
0x00008d38  mov      x21, x0
0x00008d3c  b        #0x8d68   ; call sub_8d68
0x00008d40  mov      x23, x1
0x00008d44  mov      x21, x0
0x00008d48  b        #0x8d70   ; call sub_8d70
0x00008d4c  mov      x23, x1
0x00008d50  mov      x1, x21
0x00008d54  mov      x21, x0
0x00008d58  mov      x0, x1
0x00008d5c  bl       #0x2480c   ; call _objc_release
0x00008d60  mov      x0, x22
0x00008d64  bl       #0x2480c   ; call _objc_release
0x00008d68  mov      x0, x20
0x00008d6c  bl       #0x2480c   ; call _objc_release
0x00008d70  cmp      w23, #1
0x00008d74  b.ne     #0x8de0
0x00008d78  mov      x0, x21
0x00008d7c  bl       #0x24740   ; call _objc_begin_catch
0x00008d80  adrp     x8, #0x3e000
0x00008d84  ldr      x8, [x8, #0x290]   ; -> [class(NSString)]
0x00008d88  str      x0, [sp]
0x00008d8c  adrp     x2, #0x35000
0x00008d90  add      x2, x2, #0x730   ; -> @"shield loi %@"
0x00008d94  mov      x0, x8
0x00008d98  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00008d9c  mov      x29, x29
0x00008da0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00008da4  mov      x20, x0
0x00008da8  adrp     x0, #0x34000
0x00008dac  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00008db0  mov      x1, x20
0x00008db4  bl       #0x1dd30   ; call _OMCLogWrite
0x00008db8  mov      x0, x20
0x00008dbc  bl       #0x2480c   ; call _objc_release
0x00008dc0  bl       #0x24764   ; call _objc_end_catch
0x00008dc4  b        #0x8d0c   ; call sub_8d0c
0x00008dc8  mov      x21, x0
0x00008dcc  mov      x0, x20
0x00008dd0  bl       #0x2480c   ; call _objc_release
0x00008dd4  b        #0x8ddc   ; call sub_8ddc
0x00008dd8  mov      x21, x0
0x00008ddc  bl       #0x24764   ; call _objc_end_catch
0x00008de0  mov      x0, x19
0x00008de4  bl       #0x2480c   ; call _objc_release
0x00008de8  mov      x0, x21
0x00008dec  bl       #0x24470   ; call __Unwind_Resume

