; ==== sub_9cbc @ 0x9cbc..0x9ec0 (516 bytes) ====
0x00009cbc  b        #0x9cd4   ; call sub_9cd4
0x00009cc0  ldr      x0, [x20, #0x2f8]
0x00009cc4  bl       #0x25f00   ; objc_msgSend: layer
0x00009cc8  mov      x29, x29
0x00009ccc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009cd0  mov      x20, x0
0x00009cd4  mov      x0, x22
0x00009cd8  bl       #0x2480c   ; call _objc_release
0x00009cdc  mov      x0, x21
0x00009ce0  bl       #0x2480c   ; call _objc_release
0x00009ce4  adrp     x8, #0x34000
0x00009ce8  ldr      x8, [x8, #0x588]   ; -> [got:_kCAFillRuleEvenOdd]
0x00009cec  ldr      x2, [x8]   ; -> [got:___objc_personality_v0]
0x00009cf0  mov      x0, x20
0x00009cf4  bl       #0x26f40   ; objc_msgSend: setFillRule:
0x00009cf8  mov      x0, x19
0x00009cfc  bl       #0x24f40   ; objc_msgSend: bounds
0x00009d00  mov      x0, x20
0x00009d04  bl       #0x26f80   ; objc_msgSend: setFrame:
0x00009d08  adrp     x22, #0x3e000
0x00009d0c  ldr      x21, [x22, #0x300]   ; -> [class(UIBezierPath)]
0x00009d10  mov      x0, x19
0x00009d14  bl       #0x24f40   ; objc_msgSend: bounds
0x00009d18  mov      x0, x21
0x00009d1c  bl       #0x24ec0   ; objc_msgSend: bezierPathWithRect:
0x00009d20  mov      x29, x29
0x00009d24  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009d28  mov      x21, x0
0x00009d2c  ldr      x22, [x22, #0x300]   ; -> [class(UIBezierPath)]
0x00009d30  mov      x0, x19
0x00009d34  bl       #0x25940   ; objc_msgSend: hole
0x00009d38  fmov     d4, #12.00000000
0x00009d3c  mov      x0, x22
0x00009d40  bl       #0x24ee0   ; objc_msgSend: bezierPathWithRoundedRect:cornerRadius:
0x00009d44  mov      x29, x29
0x00009d48  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009d4c  mov      x22, x0
0x00009d50  mov      x0, x21
0x00009d54  mov      x2, x22
0x00009d58  bl       #0x24d40   ; objc_msgSend: appendPath:
0x00009d5c  mov      x0, x22
0x00009d60  bl       #0x2480c   ; call _objc_release
0x00009d64  adrp     x23, #0x3e000
0x00009d68  ldr      x0, [x23, #0x308]   ; -> [class(CATransaction)]
0x00009d6c  bl       #0x24e80   ; objc_msgSend: begin
0x00009d70  ldr      x0, [x23, #0x308]   ; -> [class(CATransaction)]
0x00009d74  mov      w2, #1
0x00009d78  bl       #0x26e80   ; objc_msgSend: setDisableActions:
0x00009d7c  mov      x0, x21
0x00009d80  bl       #0x24824   ; call _objc_retainAutorelease
0x00009d84  bl       #0x24a20   ; objc_msgSend: CGPath
0x00009d88  mov      x2, x0
0x00009d8c  mov      x0, x20
0x00009d90  bl       #0x27500   ; objc_msgSend: setPath:
0x00009d94  mov      x0, x19
0x00009d98  bl       #0x25f00   ; objc_msgSend: layer
0x00009d9c  mov      x29, x29
0x00009da0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009da4  mov      x22, x0
0x00009da8  mov      x2, x20
0x00009dac  bl       #0x27320   ; objc_msgSend: setMask:
0x00009db0  mov      x0, x22
0x00009db4  bl       #0x2480c   ; call _objc_release
0x00009db8  ldr      x0, [x23, #0x308]   ; -> [class(CATransaction)]
0x00009dbc  bl       #0x25280   ; objc_msgSend: commit
0x00009dc0  mov      x0, x21
0x00009dc4  bl       #0x2480c   ; call _objc_release
0x00009dc8  mov      x0, x20
0x00009dcc  ldp      x29, x30, [sp, #0x30]
0x00009dd0  ldp      x20, x19, [sp, #0x20]
0x00009dd4  ldp      x22, x21, [sp, #0x10]
0x00009dd8  ldp      x24, x23, [sp], #0x40
0x00009ddc  b        #0x2480c   ; call _objc_release
0x00009de0  mov      x19, x0
0x00009de4  mov      x0, x23
0x00009de8  bl       #0x2480c   ; call _objc_release
0x00009dec  b        #0x9e1c   ; call sub_9e1c
0x00009df0  b        #0x9e18   ; call sub_9e18
0x00009df4  b        #0x9df8   ; call sub_9df8
0x00009df8  mov      x19, x0
0x00009dfc  mov      x0, x22
0x00009e00  bl       #0x2480c   ; call _objc_release
0x00009e04  b        #0x9e34   ; call sub_9e34
0x00009e08  b        #0x9e0c   ; call sub_9e0c
0x00009e0c  mov      x19, x0
0x00009e10  b        #0x9e40   ; call sub_9e40
0x00009e14  b        #0x9e28   ; call sub_9e28
0x00009e18  mov      x19, x0
0x00009e1c  mov      x0, x22
0x00009e20  bl       #0x2480c   ; call _objc_release
0x00009e24  b        #0x9e40   ; call sub_9e40
0x00009e28  mov      x19, x0
0x00009e2c  b        #0x9e3c   ; call sub_9e3c
0x00009e30  mov      x19, x0
0x00009e34  mov      x0, x21
0x00009e38  bl       #0x2480c   ; call _objc_release
0x00009e3c  mov      x21, x20
0x00009e40  mov      x0, x21
0x00009e44  bl       #0x2480c   ; call _objc_release
0x00009e48  mov      x0, x19
0x00009e4c  bl       #0x24470   ; call __Unwind_Resume
0x00009e50  sub      sp, sp, #0x30
0x00009e54  stp      x20, x19, [sp, #0x10]
0x00009e58  stp      x29, x30, [sp, #0x20]
0x00009e5c  add      x29, sp, #0x20
0x00009e60  mov      x19, x0
0x00009e64  adrp     x8, #0x3e000
0x00009e68  ldr      x8, [x8, #0x460]
0x00009e6c  stp      x0, x8, [sp]
0x00009e70  adrp     x8, #0x3d000
0x00009e74  ldr      x1, [x8, #0x258]   ; -> [@selector(layoutSubviews)]
0x00009e78  mov      x0, sp
0x00009e7c  bl       #0x247c4   ; call _objc_msgSendSuper2
0x00009e80  mov      x0, x19
0x00009e84  bl       #0x25940   ; objc_msgSend: hole
0x00009e88  bl       #0x243c8   ; call _CGRectIsEmpty
0x00009e8c  tbnz     w0, #0, #0x9e98
0x00009e90  mov      x0, x19
0x00009e94  bl       #0x24da0   ; objc_msgSend: applyHole
0x00009e98  ldp      x29, x30, [sp, #0x20]
0x00009e9c  ldp      x20, x19, [sp, #0x10]
0x00009ea0  add      sp, sp, #0x30
0x00009ea4  ret      
0x00009ea8  adrp     x8, #0x3e000
0x00009eac  ldrsw    x8, [x8, #0x47c]
0x00009eb0  add      x8, x0, x8
0x00009eb4  ldp      d0, d1, [x8]
0x00009eb8  ldp      d2, d3, [x8, #0x10]
0x00009ebc  ret      
