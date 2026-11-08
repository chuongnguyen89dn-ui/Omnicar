; ==== sub_22e50 @ 0x22e50..0x22f60 (272 bytes) ====
0x00022e50  add      x3, x3, #0x5b0
0x00022e54  mov      x0, x19
0x00022e58  mov      x2, x20
0x00022e5c  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022e60  mov      x0, x20
0x00022e64  bl       #0x2480c   ; call _objc_release
0x00022e68  ldr      x0, [x21, #0x2a0]
0x00022e6c  adrp     x8, #0x3e000
0x00022e70  ldrb     w2, [x8, #0xbd0]
0x00022e74  bl       #0x262c0   ; objc_msgSend: numberWithBool:
0x00022e78  mov      x29, x29
0x00022e7c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022e80  mov      x20, x0
0x00022e84  adrp     x3, #0x38000
0x00022e88  add      x3, x3, #0x5d0   ; -> @"lowPower"
0x00022e8c  mov      x0, x19
0x00022e90  mov      x2, x20
0x00022e94  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022e98  mov      x0, x20
0x00022e9c  bl       #0x2480c   ; call _objc_release
0x00022ea0  adrp     x8, #0x3e000
0x00022ea4  ldr      x8, [x8, #0xae8]
0x00022ea8  adrp     x9, #0x34000
0x00022eac  ldr      x9, [x9, #0x1f0]   ; -> [got:___NSArray0__struct]
0x00022eb0  cmp      x8, #0
0x00022eb4  csel     x2, x9, x8, eq
0x00022eb8  adrp     x3, #0x38000
0x00022ebc  add      x3, x3, #0x5f0   ; -> @"tweaks"
0x00022ec0  mov      x0, x19
0x00022ec4  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022ec8  ldr      x0, [x21, #0x2a0]
0x00022ecc  adrp     x8, #0x3e000
0x00022ed0  ldr      x2, [x8, #0xc08]
0x00022ed4  bl       #0x263a0   ; objc_msgSend: numberWithUnsignedInteger:
0x00022ed8  mov      x29, x29
0x00022edc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00022ee0  mov      x20, x0
0x00022ee4  adrp     x3, #0x38000
0x00022ee8  add      x3, x3, #0x610   ; -> @"liteCount"
0x00022eec  mov      x0, x19
0x00022ef0  mov      x2, x20
0x00022ef4  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022ef8  mov      x0, x20
0x00022efc  bl       #0x2480c   ; call _objc_release
0x00022f00  adrp     x8, #0x3e000
0x00022f04  ldr      x2, [x8, #0xaf8]
0x00022f08  cbz      x2, #0x22f1c
0x00022f0c  adrp     x3, #0x38000
0x00022f10  add      x3, x3, #0x630   ; -> @"liteReason"
0x00022f14  mov      x0, x19
0x00022f18  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00022f1c  adrp     x0, #0x38000
0x00022f20  add      x0, x0, #0x650   ; -> @"diagPerf"
0x00022f24  adrp     x20, #0x37000
0x00022f28  add      x20, x20, #0x70   ; -> @"com.anlai.omnicar"
0x00022f2c  mov      x1, x19
0x00022f30  mov      x2, x20
0x00022f34  bl       #0x242cc   ; call _CFPreferencesSetAppValue
0x00022f38  mov      x0, x20
0x00022f3c  bl       #0x242b4   ; call _CFPreferencesAppSynchronize
0x00022f40  mov      x0, x19
0x00022f44  ldp      x29, x30, [sp, #0x30]
0x00022f48  ldp      x20, x19, [sp, #0x20]
0x00022f4c  ldp      x22, x21, [sp, #0x10]
0x00022f50  ldp      d9, d8, [sp], #0x40
0x00022f54  b        #0x2480c   ; call _objc_release
0x00022f58  sub      sp, sp, #0x40
0x00022f5c  stp      x22, x21, [sp, #0x10]
