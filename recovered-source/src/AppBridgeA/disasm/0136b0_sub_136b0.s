; ==== sub_136b0 @ 0x136b0..0x139ac (764 bytes) ====
0x000136b0  mov      x24, x0
0x000136b4  mov      x2, x20
0x000136b8  bl       #0x27020   ; objc_msgSend: setHandleHit:
0x000136bc  mov      x0, x24
0x000136c0  bl       #0x2480c   ; call _objc_release
0x000136c4  mov      x0, x19
0x000136c8  bl       #0x24f60   ; objc_msgSend: box
0x000136cc  mov      x29, x29
0x000136d0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000136d4  mov      x24, x0
0x000136d8  mov      x2, x20
0x000136dc  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x000136e0  mov      x0, x24
0x000136e4  bl       #0x2480c   ; call _objc_release
0x000136e8  mov      x0, x22
0x000136ec  mov      w2, #1
0x000136f0  mov      x3, x19
0x000136f4  bl       #0x27080   ; objc_msgSend: setHandleVisible:forPane:
0x000136f8  mov      x0, x23
0x000136fc  bl       #0x2480c   ; call _objc_release
0x00013700  mov      x0, x21
0x00013704  bl       #0x2480c   ; call _objc_release
0x00013708  mov      x0, x20
0x0001370c  bl       #0x2480c   ; call _objc_release
0x00013710  mov      x0, x19
0x00013714  ldp      x29, x30, [sp, #0x70]
0x00013718  ldp      x20, x19, [sp, #0x60]
0x0001371c  ldp      x22, x21, [sp, #0x50]
0x00013720  ldp      x24, x23, [sp, #0x40]
0x00013724  ldp      x26, x25, [sp, #0x30]
0x00013728  ldp      x28, x27, [sp, #0x20]
0x0001372c  ldp      d9, d8, [sp, #0x10]
0x00013730  ldp      d11, d10, [sp], #0x80
0x00013734  b        #0x2480c   ; call _objc_release
0x00013738  b        #0x13788   ; call sub_13788
0x0001373c  b        #0x13788   ; call sub_13788
0x00013740  b        #0x137a0   ; call sub_137a0
0x00013744  b        #0x13788   ; call sub_13788
0x00013748  b        #0x137a0   ; call sub_137a0
0x0001374c  b        #0x137a0   ; call sub_137a0
0x00013750  b        #0x137a0   ; call sub_137a0
0x00013754  b        #0x13798   ; call sub_13798
0x00013758  b        #0x137a0   ; call sub_137a0
0x0001375c  mov      x22, x0
0x00013760  b        #0x137b4   ; call sub_137b4
0x00013764  mov      x22, x0
0x00013768  b        #0x137bc   ; call sub_137bc
0x0001376c  b        #0x137a0   ; call sub_137a0
0x00013770  b        #0x13798   ; call sub_13798
0x00013774  b        #0x13788   ; call sub_13788
0x00013778  mov      x22, x0
0x0001377c  mov      x0, x25
0x00013780  bl       #0x2480c   ; call _objc_release
0x00013784  b        #0x1378c   ; call sub_1378c
0x00013788  mov      x22, x0
0x0001378c  mov      x0, x24
0x00013790  bl       #0x2480c   ; call _objc_release
0x00013794  b        #0x137a4   ; call sub_137a4
0x00013798  mov      x22, x0
0x0001379c  b        #0x137ac   ; call sub_137ac
0x000137a0  mov      x22, x0
0x000137a4  mov      x0, x23
0x000137a8  bl       #0x2480c   ; call _objc_release
0x000137ac  mov      x0, x21
0x000137b0  bl       #0x2480c   ; call _objc_release
0x000137b4  mov      x0, x20
0x000137b8  bl       #0x2480c   ; call _objc_release
0x000137bc  mov      x0, x19
0x000137c0  bl       #0x2480c   ; call _objc_release
0x000137c4  mov      x0, x22
0x000137c8  bl       #0x24470   ; call __Unwind_Resume
0x000137cc  stp      d9, d8, [sp, #-0x40]!
0x000137d0  stp      x22, x21, [sp, #0x10]
0x000137d4  stp      x20, x19, [sp, #0x20]
0x000137d8  stp      x29, x30, [sp, #0x30]
0x000137dc  add      x29, sp, #0x30
0x000137e0  mov      x19, x3
0x000137e4  mov      x21, x2
0x000137e8  mov      x0, x3
0x000137ec  bl       #0x24818   ; call _objc_retain
0x000137f0  mov      x0, x19
0x000137f4  bl       #0x25860   ; objc_msgSend: handleHit
0x000137f8  mov      x29, x29
0x000137fc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013800  mov      x20, x0
0x00013804  eor      w2, w21, #1
0x00013808  bl       #0x270a0   ; objc_msgSend: setHidden:
0x0001380c  mov      x0, x20
0x00013810  bl       #0x2480c   ; call _objc_release
0x00013814  mov      x0, x19
0x00013818  bl       #0x24f60   ; objc_msgSend: box
0x0001381c  mov      x29, x29
0x00013820  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013824  mov      x20, x0
0x00013828  bl       #0x24f40   ; objc_msgSend: bounds
0x0001382c  mov      v8.16b, v2.16b
0x00013830  mov      x0, x19
0x00013834  bl       #0x25880   ; objc_msgSend: handleOffset
0x00013838  mov      v9.16b, v0.16b
0x0001383c  mov      x0, x19
0x00013840  bl       #0x25860   ; objc_msgSend: handleHit
0x00013844  mov      x29, x29
0x00013848  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001384c  mov      x21, x0
0x00013850  fmov     d0, #0.50000000
0x00013854  fmul     d0, d8, d0
0x00013858  fadd     d0, d0, d9
0x0001385c  fmov     d1, #12.00000000
0x00013860  bl       #0x26d60   ; objc_msgSend: setCenter:
0x00013864  mov      x0, x21
0x00013868  bl       #0x2480c   ; call _objc_release
0x0001386c  mov      x0, x20
0x00013870  bl       #0x2480c   ; call _objc_release
0x00013874  mov      x0, x19
0x00013878  bl       #0x24f60   ; objc_msgSend: box
0x0001387c  mov      x29, x29
0x00013880  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013884  mov      x20, x0
0x00013888  mov      x0, x19
0x0001388c  bl       #0x25860   ; objc_msgSend: handleHit
0x00013890  mov      x29, x29
0x00013894  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013898  mov      x21, x0
0x0001389c  mov      x0, x20
0x000138a0  mov      x2, x21
0x000138a4  bl       #0x24f80   ; objc_msgSend: bringSubviewToFront:
0x000138a8  mov      x0, x21
0x000138ac  bl       #0x2480c   ; call _objc_release
0x000138b0  mov      x0, x20
0x000138b4  bl       #0x2480c   ; call _objc_release
0x000138b8  mov      x0, x19
0x000138bc  ldp      x29, x30, [sp, #0x30]
0x000138c0  ldp      x20, x19, [sp, #0x20]
0x000138c4  ldp      x22, x21, [sp, #0x10]
0x000138c8  ldp      d9, d8, [sp], #0x40
0x000138cc  b        #0x2480c   ; call _objc_release
0x000138d0  b        #0x138d8   ; call sub_138d8
0x000138d4  b        #0x138fc   ; call sub_138fc
0x000138d8  mov      x1, x21
0x000138dc  mov      x21, x0
0x000138e0  mov      x0, x1
0x000138e4  bl       #0x2480c   ; call _objc_release
0x000138e8  b        #0x13900   ; call sub_13900
0x000138ec  b        #0x138f4   ; call sub_138f4
0x000138f0  b        #0x138fc   ; call sub_138fc
0x000138f4  mov      x21, x0
0x000138f8  b        #0x13908   ; call sub_13908
0x000138fc  mov      x21, x0
0x00013900  mov      x0, x20
0x00013904  bl       #0x2480c   ; call _objc_release
0x00013908  mov      x0, x19
0x0001390c  bl       #0x2480c   ; call _objc_release
0x00013910  mov      x0, x21
0x00013914  bl       #0x24470   ; call __Unwind_Resume
0x00013918  sub      sp, sp, #0x130
0x0001391c  stp      x28, x27, [sp, #0xd0]
0x00013920  stp      x26, x25, [sp, #0xe0]
0x00013924  stp      x24, x23, [sp, #0xf0]
0x00013928  stp      x22, x21, [sp, #0x100]
0x0001392c  stp      x20, x19, [sp, #0x110]
0x00013930  stp      x29, x30, [sp, #0x120]
0x00013934  add      x29, sp, #0x120
0x00013938  mov      x20, x0
0x0001393c  adrp     x8, #0x34000
0x00013940  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00013944  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00013948  stur     x8, [x29, #-0x58]
0x0001394c  movi     v0.16b, #0
0x00013950  stp      q0, q0, [sp]
0x00013954  stp      q0, q0, [sp, #0x20]
0x00013958  bl       #0x25e60   ; objc_msgSend: knobViews
0x0001395c  mov      x29, x29
0x00013960  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00013964  mov      x19, x0
0x00013968  mov      x2, sp
0x0001396c  add      x3, sp, #0x48
0x00013970  mov      w4, #0x10
0x00013974  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00013978  mov      x21, x0
0x0001397c  cbz      x0, #0x13a34
0x00013980  ldr      x8, [sp, #0x10]
0x00013984  ldr      x24, [x8]   ; -> [got:___objc_personality_v0]
0x00013988  mov      x25, #0
0x0001398c  ldr      x8, [sp, #0x10]
0x00013990  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00013994  cmp      x8, x24
0x00013998  b.eq     #0x139a4
0x0001399c  mov      x0, x19
0x000139a0  bl       #0x24770   ; call _objc_enumerationMutation
0x000139a4  ldr      x8, [sp, #8]
0x000139a8  ldr      x22, [x8, x25, lsl #3]   ; -> [got:___objc_personality_v0]
