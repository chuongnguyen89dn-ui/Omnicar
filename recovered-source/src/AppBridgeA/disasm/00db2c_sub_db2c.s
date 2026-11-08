; ==== sub_db2c @ 0xdb2c..0xdc10 (228 bytes) ====
0x0000db2c  mov      x2, x26
0x0000db30  bl       #0x24b20   ; objc_msgSend: addObject:
0x0000db34  cbz      x23, #0xdb54
0x0000db38  mov      x0, x26
0x0000db3c  bl       #0x25fa0   ; objc_msgSend: length
0x0000db40  mov      x27, x0
0x0000db44  mov      x0, x23
0x0000db48  bl       #0x25fa0   ; objc_msgSend: length
0x0000db4c  cmp      x27, x0
0x0000db50  b.hs     #0xdb68
0x0000db54  mov      x0, x26
0x0000db58  bl       #0x24818   ; call _objc_retain
0x0000db5c  mov      x0, x23
0x0000db60  bl       #0x2480c   ; call _objc_release
0x0000db64  mov      x23, x26
0x0000db68  mov      x0, x26
0x0000db6c  bl       #0x2480c   ; call _objc_release
0x0000db70  add      x20, x20, #1
0x0000db74  ldr      w8, [sp, #0x4c]
0x0000db78  cmp      x20, x8
0x0000db7c  b.lo     #0xdafc
0x0000db80  mov      x0, x25
0x0000db84  bl       #0x2462c   ; call _free
0x0000db88  mov      x0, x24
0x0000db8c  bl       #0x24530   ; call _class_getSuperclass
0x0000db90  mov      x24, x0
0x0000db94  b        #0xdad8   ; call sub_dad8
0x0000db98  mov      x0, x22
0x0000db9c  bl       #0x24818   ; call _objc_retain
0x0000dba0  ldr      x23, [sp, #0x40]
0x0000dba4  b        #0xdd80   ; call sub_dd80
0x0000dba8  mov      x22, #0
0x0000dbac  b        #0xdd88   ; call sub_dd88
0x0000dbb0  adrp     x20, #0x3e000
0x0000dbb4  ldr      x8, [x20, #0xa40]
0x0000dbb8  cbnz     x8, #0xdbe0
0x0000dbbc  adrp     x8, #0x3e000
0x0000dbc0  ldr      x0, [x8, #0x2f0]   ; -> [class(NSMutableSet)]
0x0000dbc4  bl       #0x26ac0   ; objc_msgSend: set
0x0000dbc8  mov      x29, x29
0x0000dbcc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000dbd0  ldr      x8, [x20, #0xa40]
0x0000dbd4  str      x0, [x20, #0xa40]
0x0000dbd8  mov      x0, x8
0x0000dbdc  bl       #0x2480c   ; call _objc_release
0x0000dbe0  adrp     x26, #0x3e000
0x0000dbe4  ldr      x24, [x26, #0x290]   ; -> [class(NSString)]
0x0000dbe8  mov      x0, x19
0x0000dbec  bl       #0x247d0   ; call _objc_opt_class
0x0000dbf0  bl       #0x2444c   ; call _NSStringFromClass
0x0000dbf4  mov      x29, x29
0x0000dbf8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000dbfc  mov      x25, x0
0x0000dc00  stp      x0, x21, [sp]
0x0000dc04  adrp     x2, #0x35000
0x0000dc08  add      x2, x2, #0x970   ; -> @"%@ %@"
0x0000dc0c  mov      x0, x24
