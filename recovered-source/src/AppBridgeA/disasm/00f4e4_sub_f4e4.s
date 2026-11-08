; ==== sub_f4e4 @ 0xf4e4..0xf89c (952 bytes) ====
0x0000f4e4  movk     w27, #0x811c, lsl #16
0x0000f4e8  cbz      w8, #0xf508
0x0000f4ec  add      x9, x0, #1
0x0000f4f0  mov      w27, #0x9dc5
0x0000f4f4  movk     w27, #0x811c, lsl #16
0x0000f4f8  eor      w8, w27, w8
0x0000f4fc  mul      w27, w8, w25
0x0000f500  ldrb     w8, [x9], #1
0x0000f504  cbnz     w8, #0xf4f8
0x0000f508  mov      x0, x23
0x0000f50c  bl       #0x2480c   ; call _objc_release
0x0000f510  cmp      x27, x20
0x0000f514  cset     w27, eq
0x0000f518  mov      x0, x23
0x0000f51c  bl       #0x2480c   ; call _objc_release
0x0000f520  cbnz     w27, #0xf554
0x0000f524  add      x26, x26, #1
0x0000f528  cmp      x26, x21
0x0000f52c  b.ne     #0xf488
0x0000f530  mov      x2, sp
0x0000f534  add      x3, sp, #0x48
0x0000f538  mov      x0, x19
0x0000f53c  mov      w4, #0x10
0x0000f540  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0000f544  mov      x21, x0
0x0000f548  cbnz     x0, #0xf484
0x0000f54c  mov      x20, #0
0x0000f550  b        #0xf568   ; call sub_f568
0x0000f554  mov      x0, x22
0x0000f558  bl       #0x25020   ; objc_msgSend: bundleID
0x0000f55c  mov      x29, x29
0x0000f560  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000f564  mov      x20, x0
0x0000f568  mov      x0, x19
0x0000f56c  bl       #0x2480c   ; call _objc_release
0x0000f570  ldur     x8, [x29, #-0x58]
0x0000f574  adrp     x9, #0x34000
0x0000f578  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x0000f57c  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0000f580  cmp      x9, x8
0x0000f584  b.ne     #0xf5ac
0x0000f588  mov      x0, x20
0x0000f58c  ldp      x29, x30, [sp, #0x120]
0x0000f590  ldp      x20, x19, [sp, #0x110]
0x0000f594  ldp      x22, x21, [sp, #0x100]
0x0000f598  ldp      x24, x23, [sp, #0xf0]
0x0000f59c  ldp      x26, x25, [sp, #0xe0]
0x0000f5a0  ldp      x28, x27, [sp, #0xd0]
0x0000f5a4  add      sp, sp, #0x130
0x0000f5a8  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x0000f5ac  bl       #0x24488   ; call ___stack_chk_fail
0x0000f5b0  b        #0xf5d0   ; call sub_f5d0
0x0000f5b4  b        #0xf5d0   ; call sub_f5d0
0x0000f5b8  mov      x20, x0
0x0000f5bc  mov      x0, x23
0x0000f5c0  bl       #0x2480c   ; call _objc_release
0x0000f5c4  mov      x0, x23
0x0000f5c8  bl       #0x2480c   ; call _objc_release
0x0000f5cc  b        #0xf5d4   ; call sub_f5d4
0x0000f5d0  mov      x20, x0
0x0000f5d4  mov      x0, x19
0x0000f5d8  bl       #0x2480c   ; call _objc_release
0x0000f5dc  b        #0xf5e4   ; call sub_f5e4
0x0000f5e0  mov      x20, x0
0x0000f5e4  mov      x0, x20
0x0000f5e8  bl       #0x24470   ; call __Unwind_Resume
0x0000f5ec  stp      d11, d10, [sp, #-0x50]!
0x0000f5f0  stp      d9, d8, [sp, #0x10]
0x0000f5f4  stp      x22, x21, [sp, #0x20]
0x0000f5f8  stp      x20, x19, [sp, #0x30]
0x0000f5fc  stp      x29, x30, [sp, #0x40]
0x0000f600  add      x29, sp, #0x40
0x0000f604  bl       #0x26520   ; objc_msgSend: paneFor:
0x0000f608  mov      x29, x29
0x0000f60c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000f610  mov      x19, x0
0x0000f614  cbz      x0, #0xf64c
0x0000f618  mov      x0, x19
0x0000f61c  bl       #0x24f60   ; objc_msgSend: box
0x0000f620  mov      x29, x29
0x0000f624  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000f628  mov      x20, x0
0x0000f62c  bl       #0x257c0   ; objc_msgSend: frame
0x0000f630  mov      v8.16b, v0.16b
0x0000f634  mov      v9.16b, v1.16b
0x0000f638  mov      v10.16b, v2.16b
0x0000f63c  mov      v11.16b, v3.16b
0x0000f640  mov      x0, x20
0x0000f644  bl       #0x2480c   ; call _objc_release
0x0000f648  b        #0xf65c   ; call sub_f65c
0x0000f64c  adrp     x8, #0x34000
0x0000f650  ldr      x8, [x8, #0x560]   ; -> [got:_CGRectNull]
0x0000f654  ldp      d8, d9, [x8]
0x0000f658  ldp      d10, d11, [x8, #0x10]
0x0000f65c  mov      x0, x19
0x0000f660  bl       #0x2480c   ; call _objc_release
0x0000f664  mov      v0.16b, v8.16b
0x0000f668  mov      v1.16b, v9.16b
0x0000f66c  mov      v2.16b, v10.16b
0x0000f670  mov      v3.16b, v11.16b
0x0000f674  ldp      x29, x30, [sp, #0x40]
0x0000f678  ldp      x20, x19, [sp, #0x30]
0x0000f67c  ldp      x22, x21, [sp, #0x20]
0x0000f680  ldp      d9, d8, [sp, #0x10]
0x0000f684  ldp      d11, d10, [sp], #0x50
0x0000f688  ret      
0x0000f68c  mov      x21, x0
0x0000f690  mov      x0, x20
0x0000f694  bl       #0x2480c   ; call _objc_release
0x0000f698  b        #0xf6a0   ; call sub_f6a0
0x0000f69c  mov      x21, x0
0x0000f6a0  mov      x0, x19
0x0000f6a4  bl       #0x2480c   ; call _objc_release
0x0000f6a8  mov      x0, x21
0x0000f6ac  bl       #0x24470   ; call __Unwind_Resume
0x0000f6b0  sub      sp, sp, #0x160
0x0000f6b4  stp      x28, x27, [sp, #0x100]
0x0000f6b8  stp      x26, x25, [sp, #0x110]
0x0000f6bc  stp      x24, x23, [sp, #0x120]
0x0000f6c0  stp      x22, x21, [sp, #0x130]
0x0000f6c4  stp      x20, x19, [sp, #0x140]
0x0000f6c8  stp      x29, x30, [sp, #0x150]
0x0000f6cc  add      x29, sp, #0x150
0x0000f6d0  mov      x21, x4
0x0000f6d4  str      x3, [sp, #0x20]
0x0000f6d8  mov      x23, x2
0x0000f6dc  adrp     x8, #0x34000
0x0000f6e0  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0000f6e4  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0000f6e8  stur     x8, [x29, #-0x60]
0x0000f6ec  movi     v0.16b, #0
0x0000f6f0  stp      q0, q0, [sp, #0x30]
0x0000f6f4  stp      q0, q0, [sp, #0x50]
0x0000f6f8  str      x0, [sp, #0x28]
0x0000f6fc  bl       #0x26580   ; objc_msgSend: panes
0x0000f700  mov      x29, x29
0x0000f704  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000f708  mov      x19, x0
0x0000f70c  add      x2, sp, #0x30
0x0000f710  add      x3, sp, #0x70
0x0000f714  mov      w4, #0x10
0x0000f718  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0000f71c  mov      x25, x0
0x0000f720  cbz      x0, #0xf7fc
0x0000f724  ldr      x8, [sp, #0x40]
0x0000f728  ldr      x27, [x8]   ; -> [got:___objc_personality_v0]
0x0000f72c  mov      w28, #0x193
0x0000f730  movk     w28, #0x100, lsl #16
0x0000f734  mov      x20, #0
0x0000f738  ldr      x8, [sp, #0x40]
0x0000f73c  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0000f740  cmp      x8, x27
0x0000f744  b.eq     #0xf750
0x0000f748  mov      x0, x19
0x0000f74c  bl       #0x24770   ; call _objc_enumerationMutation
0x0000f750  ldr      x8, [sp, #0x38]
0x0000f754  ldr      x24, [x8, x20, lsl #3]   ; -> [got:___objc_personality_v0]
0x0000f758  mov      x0, x24
0x0000f75c  bl       #0x25020   ; objc_msgSend: bundleID
0x0000f760  mov      x29, x29
0x0000f764  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000f768  mov      x26, x0
0x0000f76c  bl       #0x24818   ; call _objc_retain
0x0000f770  mov      x0, x26
0x0000f774  bl       #0x24824   ; call _objc_retainAutorelease
0x0000f778  mov      x0, x26
0x0000f77c  bl       #0x24a40   ; objc_msgSend: UTF8String
0x0000f780  mov      w22, #0x9dc5
0x0000f784  movk     w22, #0x811c, lsl #16
0x0000f788  cbz      x0, #0xf7b8
0x0000f78c  ldrb     w8, [x0]
0x0000f790  mov      w22, #0x9dc5
0x0000f794  movk     w22, #0x811c, lsl #16
0x0000f798  cbz      w8, #0xf7b8
0x0000f79c  add      x9, x0, #1
0x0000f7a0  mov      w22, #0x9dc5
0x0000f7a4  movk     w22, #0x811c, lsl #16
0x0000f7a8  eor      w8, w22, w8
0x0000f7ac  mul      w22, w8, w28
0x0000f7b0  ldrb     w8, [x9], #1
0x0000f7b4  cbnz     w8, #0xf7a8
0x0000f7b8  mov      x0, x26
0x0000f7bc  bl       #0x2480c   ; call _objc_release
0x0000f7c0  cmp      x22, x23
0x0000f7c4  cset     w22, eq
0x0000f7c8  mov      x0, x26
0x0000f7cc  bl       #0x2480c   ; call _objc_release
0x0000f7d0  tbnz     w22, #0, #0xf83c
0x0000f7d4  add      x20, x20, #1
0x0000f7d8  cmp      x20, x25
0x0000f7dc  b.ne     #0xf738
0x0000f7e0  add      x2, sp, #0x30
0x0000f7e4  add      x3, sp, #0x70
0x0000f7e8  mov      x0, x19
0x0000f7ec  mov      w4, #0x10
0x0000f7f0  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0000f7f4  mov      x25, x0
0x0000f7f8  cbnz     x0, #0xf734
0x0000f7fc  mov      x0, x19
0x0000f800  bl       #0x2480c   ; call _objc_release
0x0000f804  adrp     x8, #0x3e000
0x0000f808  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x0000f80c  str      x23, [sp]
0x0000f810  adrp     x2, #0x36000
0x0000f814  add      x2, x2, #0x250   ; -> @"apporient: khong co o cho hash %llu"
0x0000f818  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000f81c  mov      x29, x29
0x0000f820  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000f824  mov      x19, x0
0x0000f828  adrp     x0, #0x34000
0x0000f82c  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000f830  mov      x1, x19
0x0000f834  bl       #0x1dd30   ; call _OMCLogWrite
0x0000f838  b        #0xf904   ; call sub_f904
0x0000f83c  and      x8, x21, #2
0x0000f840  mov      w9, #4
0x0000f844  mov      w10, #3
0x0000f848  lsr      x11, x21, #1
0x0000f84c  and      x11, x11, #2
0x0000f850  tst      w21, #8
0x0000f854  csel     x10, x10, x11, ne
0x0000f858  tst      w21, #0x10
0x0000f85c  csel     x9, x9, x10, ne
0x0000f860  cmp      x8, #0
0x0000f864  csel     x8, xzr, x9, ne
0x0000f868  cmp      x21, #0
0x0000f86c  csel     x8, xzr, x8, eq
0x0000f870  ldr      x20, [sp, #0x20]
0x0000f874  sxtw     x9, w20
0x0000f878  cmp      w20, #0xff
0x0000f87c  csel     x2, x8, x9, eq
0x0000f880  mov      x0, x24
0x0000f884  bl       #0x275c0   ; objc_msgSend: setRequestedOrientation:
0x0000f888  adrp     x8, #0x3e000
0x0000f88c  ldr      x25, [x8, #0x290]   ; -> [class(NSString)]
0x0000f890  mov      x0, x24
0x0000f894  bl       #0x25020   ; objc_msgSend: bundleID
0x0000f898  mov      x29, x29
