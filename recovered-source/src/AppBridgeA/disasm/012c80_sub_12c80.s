; ==== sub_12c80 @ 0x12c80..0x13210 (1424 bytes) ====
0x00012c80  mov      x1, x20
0x00012c84  mov      x20, x0
0x00012c88  mov      x0, x1
0x00012c8c  b        #0x12cc8   ; call sub_12cc8
0x00012c90  b        #0x12cd0   ; call sub_12cd0
0x00012c94  b        #0x12ca4   ; call sub_12ca4
0x00012c98  b        #0x12cc0   ; call sub_12cc0
0x00012c9c  b        #0x12ca4   ; call sub_12ca4
0x00012ca0  b        #0x12cc0   ; call sub_12cc0
0x00012ca4  mov      x1, x20
0x00012ca8  mov      x20, x0
0x00012cac  mov      x0, x1
0x00012cb0  bl       #0x2480c   ; call _objc_release
0x00012cb4  b        #0x12cc4   ; call sub_12cc4
0x00012cb8  b        #0x12cc0   ; call sub_12cc0
0x00012cbc  b        #0x12cc0   ; call sub_12cc0
0x00012cc0  mov      x20, x0
0x00012cc4  mov      x0, x21
0x00012cc8  bl       #0x2480c   ; call _objc_release
0x00012ccc  b        #0x12cd4   ; call sub_12cd4
0x00012cd0  mov      x20, x0
0x00012cd4  mov      x0, x19
0x00012cd8  bl       #0x2480c   ; call _objc_release
0x00012cdc  mov      x0, x20
0x00012ce0  bl       #0x24470   ; call __Unwind_Resume
0x00012ce4  stp      d13, d12, [sp, #-0x50]!
0x00012ce8  stp      d11, d10, [sp, #0x10]
0x00012cec  stp      d9, d8, [sp, #0x20]
0x00012cf0  stp      x20, x19, [sp, #0x30]
0x00012cf4  stp      x29, x30, [sp, #0x40]
0x00012cf8  add      x29, sp, #0x40
0x00012cfc  mov      v8.16b, v3.16b
0x00012d00  mov      v9.16b, v2.16b
0x00012d04  mov      v10.16b, v1.16b
0x00012d08  mov      v11.16b, v0.16b
0x00012d0c  bl       #0x26520   ; objc_msgSend: paneFor:
0x00012d10  mov      x29, x29
0x00012d14  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012d18  mov      x19, x0
0x00012d1c  cbz      x0, #0x12dbc
0x00012d20  mov      v0.16b, v11.16b
0x00012d24  mov      v1.16b, v10.16b
0x00012d28  mov      v2.16b, v9.16b
0x00012d2c  mov      v3.16b, v8.16b
0x00012d30  bl       #0x243c8   ; call _CGRectIsEmpty
0x00012d34  cbz      w0, #0x12d4c
0x00012d38  adrp     x8, #0x34000
0x00012d3c  ldr      x8, [x8, #0x570]   ; -> [got:_CGRectZero]
0x00012d40  ldp      d8, d9, [x8]
0x00012d44  ldp      d10, d11, [x8, #0x10]
0x00012d48  b        #0x12d8c   ; call sub_12d8c
0x00012d4c  mov      x0, x19
0x00012d50  bl       #0x257c0   ; objc_msgSend: frame
0x00012d54  mov      v12.16b, v0.16b
0x00012d58  mov      x0, x19
0x00012d5c  bl       #0x257c0   ; objc_msgSend: frame
0x00012d60  fneg     d4, d12
0x00012d64  fneg     d5, d1
0x00012d68  mov      v0.16b, v11.16b
0x00012d6c  mov      v1.16b, v10.16b
0x00012d70  mov      v2.16b, v9.16b
0x00012d74  mov      v3.16b, v8.16b
0x00012d78  bl       #0x243d4   ; call _CGRectOffset
0x00012d7c  mov      v8.16b, v0.16b
0x00012d80  mov      v9.16b, v1.16b
0x00012d84  mov      v10.16b, v2.16b
0x00012d88  mov      v11.16b, v3.16b
0x00012d8c  mov      x0, x19
0x00012d90  bl       #0x24f60   ; objc_msgSend: box
0x00012d94  mov      x29, x29
0x00012d98  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012d9c  mov      x20, x0
0x00012da0  mov      v0.16b, v8.16b
0x00012da4  mov      v1.16b, v9.16b
0x00012da8  mov      v2.16b, v10.16b
0x00012dac  mov      v3.16b, v11.16b
0x00012db0  bl       #0x27100   ; objc_msgSend: setHole:
0x00012db4  mov      x0, x20
0x00012db8  bl       #0x2480c   ; call _objc_release
0x00012dbc  mov      x0, x19
0x00012dc0  ldp      x29, x30, [sp, #0x40]
0x00012dc4  ldp      x20, x19, [sp, #0x30]
0x00012dc8  ldp      d9, d8, [sp, #0x20]
0x00012dcc  ldp      d11, d10, [sp, #0x10]
0x00012dd0  ldp      d13, d12, [sp], #0x50
0x00012dd4  b        #0x2480c   ; call _objc_release
0x00012dd8  b        #0x12df4   ; call sub_12df4
0x00012ddc  mov      x1, x20
0x00012de0  mov      x20, x0
0x00012de4  mov      x0, x1
0x00012de8  bl       #0x2480c   ; call _objc_release
0x00012dec  b        #0x12df8   ; call sub_12df8
0x00012df0  b        #0x12df4   ; call sub_12df4
0x00012df4  mov      x20, x0
0x00012df8  mov      x0, x19
0x00012dfc  bl       #0x2480c   ; call _objc_release
0x00012e00  mov      x0, x20
0x00012e04  bl       #0x24470   ; call __Unwind_Resume
0x00012e08  sub      sp, sp, #0x120
0x00012e0c  stp      x26, x25, [sp, #0xd0]
0x00012e10  stp      x24, x23, [sp, #0xe0]
0x00012e14  stp      x22, x21, [sp, #0xf0]
0x00012e18  stp      x20, x19, [sp, #0x100]
0x00012e1c  stp      x29, x30, [sp, #0x110]
0x00012e20  add      x29, sp, #0x110
0x00012e24  mov      x20, x0
0x00012e28  adrp     x8, #0x34000
0x00012e2c  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00012e30  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00012e34  stur     x8, [x29, #-0x48]
0x00012e38  mov      w2, #0
0x00012e3c  bl       #0x277e0   ; objc_msgSend: setShieldOn:
0x00012e40  movi     v0.16b, #0
0x00012e44  stp      q0, q0, [sp, #0x20]
0x00012e48  stp      q0, q0, [sp]
0x00012e4c  mov      x0, x20
0x00012e50  bl       #0x26580   ; objc_msgSend: panes
0x00012e54  mov      x29, x29
0x00012e58  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012e5c  mov      x19, x0
0x00012e60  mov      x2, sp
0x00012e64  add      x3, sp, #0x48
0x00012e68  mov      w4, #0x10
0x00012e6c  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00012e70  mov      x21, x0
0x00012e74  cbz      x0, #0x12f04
0x00012e78  ldr      x8, [sp, #0x10]
0x00012e7c  ldr      x24, [x8]   ; -> [got:___objc_personality_v0]
0x00012e80  mov      x25, #0
0x00012e84  ldr      x8, [sp, #0x10]
0x00012e88  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00012e8c  cmp      x8, x24
0x00012e90  b.eq     #0x12e9c
0x00012e94  mov      x0, x19
0x00012e98  bl       #0x24770   ; call _objc_enumerationMutation
0x00012e9c  ldr      x8, [sp, #8]
0x00012ea0  ldr      x22, [x8, x25, lsl #3]   ; -> [got:___objc_personality_v0]
0x00012ea4  mov      x0, x20
0x00012ea8  mov      x2, x22
0x00012eac  bl       #0x258c0   ; objc_msgSend: hideBarForPane:
0x00012eb0  mov      x0, x22
0x00012eb4  bl       #0x27b60   ; objc_msgSend: shield
0x00012eb8  mov      x29, x29
0x00012ebc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012ec0  mov      x23, x0
0x00012ec4  bl       #0x26840   ; objc_msgSend: removeFromSuperview
0x00012ec8  mov      x0, x23
0x00012ecc  bl       #0x2480c   ; call _objc_release
0x00012ed0  mov      x0, x22
0x00012ed4  mov      x2, #0
0x00012ed8  bl       #0x27780   ; objc_msgSend: setShield:
0x00012edc  add      x25, x25, #1
0x00012ee0  cmp      x21, x25
0x00012ee4  b.ne     #0x12e84
0x00012ee8  mov      x2, sp
0x00012eec  add      x3, sp, #0x48
0x00012ef0  mov      x0, x19
0x00012ef4  mov      w4, #0x10
0x00012ef8  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00012efc  mov      x21, x0
0x00012f00  cbnz     x0, #0x12e80
0x00012f04  mov      x0, x19
0x00012f08  bl       #0x2480c   ; call _objc_release
0x00012f0c  ldur     x8, [x29, #-0x48]
0x00012f10  adrp     x9, #0x34000
0x00012f14  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00012f18  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x00012f1c  cmp      x9, x8
0x00012f20  b.ne     #0x12f40
0x00012f24  ldp      x29, x30, [sp, #0x110]
0x00012f28  ldp      x20, x19, [sp, #0x100]
0x00012f2c  ldp      x22, x21, [sp, #0xf0]
0x00012f30  ldp      x24, x23, [sp, #0xe0]
0x00012f34  ldp      x26, x25, [sp, #0xd0]
0x00012f38  add      sp, sp, #0x120
0x00012f3c  ret      
0x00012f40  bl       #0x24488   ; call ___stack_chk_fail
0x00012f44  b        #0x12f5c   ; call sub_12f5c
0x00012f48  b        #0x12f5c   ; call sub_12f5c
0x00012f4c  mov      x20, x0
0x00012f50  mov      x0, x23
0x00012f54  bl       #0x2480c   ; call _objc_release
0x00012f58  b        #0x12f60   ; call sub_12f60
0x00012f5c  mov      x20, x0
0x00012f60  mov      x0, x19
0x00012f64  bl       #0x2480c   ; call _objc_release
0x00012f68  b        #0x12f70   ; call sub_12f70
0x00012f6c  mov      x20, x0
0x00012f70  mov      x0, x20
0x00012f74  bl       #0x24470   ; call __Unwind_Resume
0x00012f78  sub      sp, sp, #0x130
0x00012f7c  stp      x28, x27, [sp, #0xd0]
0x00012f80  stp      x26, x25, [sp, #0xe0]
0x00012f84  stp      x24, x23, [sp, #0xf0]
0x00012f88  stp      x22, x21, [sp, #0x100]
0x00012f8c  stp      x20, x19, [sp, #0x110]
0x00012f90  stp      x29, x30, [sp, #0x120]
0x00012f94  add      x29, sp, #0x120
0x00012f98  mov      x19, x2
0x00012f9c  mov      x20, x0
0x00012fa0  adrp     x8, #0x34000
0x00012fa4  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00012fa8  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00012fac  stur     x8, [x29, #-0x58]
0x00012fb0  mov      x0, x2
0x00012fb4  bl       #0x24818   ; call _objc_retain
0x00012fb8  movi     v0.16b, #0
0x00012fbc  stp      q0, q0, [sp]
0x00012fc0  stp      q0, q0, [sp, #0x20]
0x00012fc4  mov      x0, x20
0x00012fc8  bl       #0x26580   ; objc_msgSend: panes
0x00012fcc  mov      x29, x29
0x00012fd0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00012fd4  mov      x20, x0
0x00012fd8  mov      x2, sp
0x00012fdc  add      x3, sp, #0x48
0x00012fe0  mov      w4, #0x10
0x00012fe4  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00012fe8  mov      x21, x0
0x00012fec  cbz      x0, #0x13094
0x00012ff0  ldr      x8, [sp, #0x10]
0x00012ff4  ldr      x26, [x8]   ; -> [got:___objc_personality_v0]
0x00012ff8  mov      x27, #0
0x00012ffc  ldr      x8, [sp, #0x10]
0x00013000  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00013004  cmp      x8, x26
0x00013008  b.eq     #0x13014
0x0001300c  mov      x0, x20
0x00013010  bl       #0x24770   ; call _objc_enumerationMutation
0x00013014  ldr      x8, [sp, #8]
0x00013018  ldr      x22, [x8, x27, lsl #3]   ; -> [got:___objc_personality_v0]
0x0001301c  mov      x0, x22
0x00013020  bl       #0x24e60   ; objc_msgSend: bar
0x00013024  mov      x29, x29
0x00013028  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001302c  mov      x23, x0
0x00013030  cbz      x0, #0x1306c
0x00013034  mov      x0, x22
0x00013038  bl       #0x24e60   ; objc_msgSend: bar
0x0001303c  mov      x29, x29
0x00013040  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013044  mov      x24, x0
0x00013048  mov      x0, x19
0x0001304c  mov      x2, x24
0x00013050  bl       #0x25c60   ; objc_msgSend: isDescendantOfView:
0x00013054  mov      x25, x0
0x00013058  mov      x0, x24
0x0001305c  bl       #0x2480c   ; call _objc_release
0x00013060  mov      x0, x23
0x00013064  bl       #0x2480c   ; call _objc_release
0x00013068  tbnz     w25, #0, #0x1309c
0x0001306c  add      x27, x27, #1
0x00013070  cmp      x21, x27
0x00013074  b.ne     #0x12ffc
0x00013078  mov      x2, sp
0x0001307c  add      x3, sp, #0x48
0x00013080  mov      x0, x20
0x00013084  mov      w4, #0x10
0x00013088  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001308c  mov      x21, x0
0x00013090  cbnz     x0, #0x12ff8
0x00013094  mov      x22, #0
0x00013098  b        #0x130a4   ; call sub_130a4
0x0001309c  mov      x0, x22
0x000130a0  bl       #0x24818   ; call _objc_retain
0x000130a4  mov      x0, x20
0x000130a8  bl       #0x2480c   ; call _objc_release
0x000130ac  mov      x0, x19
0x000130b0  bl       #0x2480c   ; call _objc_release
0x000130b4  ldur     x8, [x29, #-0x58]
0x000130b8  adrp     x9, #0x34000
0x000130bc  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x000130c0  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x000130c4  cmp      x9, x8
0x000130c8  b.ne     #0x130f0
0x000130cc  mov      x0, x22
0x000130d0  ldp      x29, x30, [sp, #0x120]
0x000130d4  ldp      x20, x19, [sp, #0x110]
0x000130d8  ldp      x22, x21, [sp, #0x100]
0x000130dc  ldp      x24, x23, [sp, #0xf0]
0x000130e0  ldp      x26, x25, [sp, #0xe0]
0x000130e4  ldp      x28, x27, [sp, #0xd0]
0x000130e8  add      sp, sp, #0x130
0x000130ec  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x000130f0  bl       #0x24488   ; call ___stack_chk_fail
0x000130f4  b        #0x13124   ; call sub_13124
0x000130f8  b        #0x13124   ; call sub_13124
0x000130fc  mov      x21, x0
0x00013100  b        #0x13130   ; call sub_13130
0x00013104  mov      x21, x0
0x00013108  mov      x0, x24
0x0001310c  bl       #0x2480c   ; call _objc_release
0x00013110  b        #0x13118   ; call sub_13118
0x00013114  mov      x21, x0
0x00013118  mov      x0, x23
0x0001311c  bl       #0x2480c   ; call _objc_release
0x00013120  b        #0x13128   ; call sub_13128
0x00013124  mov      x21, x0
0x00013128  mov      x0, x20
0x0001312c  bl       #0x2480c   ; call _objc_release
0x00013130  mov      x0, x19
0x00013134  bl       #0x2480c   ; call _objc_release
0x00013138  b        #0x13140   ; call sub_13140
0x0001313c  mov      x21, x0
0x00013140  mov      x0, x21
0x00013144  bl       #0x24470   ; call __Unwind_Resume
0x00013148  sub      sp, sp, #0x80
0x0001314c  stp      x24, x23, [sp, #0x40]
0x00013150  stp      x22, x21, [sp, #0x50]
0x00013154  stp      x20, x19, [sp, #0x60]
0x00013158  stp      x29, x30, [sp, #0x70]
0x0001315c  add      x29, sp, #0x70
0x00013160  mov      x20, x3
0x00013164  mov      x19, x2
0x00013168  mov      x21, x0
0x0001316c  adrp     x8, #0x34000
0x00013170  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00013174  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00013178  str      x8, [sp, #0x38]
0x0001317c  mov      x0, x2
0x00013180  bl       #0x24818   ; call _objc_retain
0x00013184  mov      x0, x20
0x00013188  bl       #0x24818   ; call _objc_retain
0x0001318c  mov      x0, x21
0x00013190  mov      x2, x20
0x00013194  bl       #0x26540   ; objc_msgSend: paneOfBarButton:
0x00013198  mov      x29, x29
0x0001319c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000131a0  mov      x21, x0
0x000131a4  cbz      x0, #0x132a4
0x000131a8  adrp     x8, #0x3e000
0x000131ac  ldr      x23, [x8, #0x290]   ; -> [class(NSString)]
0x000131b0  mov      x0, x21
0x000131b4  bl       #0x25020   ; objc_msgSend: bundleID
0x000131b8  mov      x29, x29
0x000131bc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000131c0  mov      x22, x0
0x000131c4  stp      x0, x19, [sp]
0x000131c8  adrp     x2, #0x36000
0x000131cc  add      x2, x2, #0x4f0   ; -> @"thanh nut %@: %@"
0x000131d0  mov      x0, x23
0x000131d4  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x000131d8  mov      x29, x29
0x000131dc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000131e0  mov      x24, x0
0x000131e4  adrp     x0, #0x34000
0x000131e8  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x000131ec  mov      x1, x24
0x000131f0  bl       #0x1dd30   ; call _OMCLogWrite
0x000131f4  mov      x0, x24
0x000131f8  bl       #0x2480c   ; call _objc_release
0x000131fc  mov      x0, x22
0x00013200  bl       #0x2480c   ; call _objc_release
0x00013204  adrp     x0, #0x28000
0x00013208  add      x0, x0, #0xfc3   ; -> "NSDistributedNotificationCenter"
0x0001320c  bl       #0x24788   ; call _objc_getClass
