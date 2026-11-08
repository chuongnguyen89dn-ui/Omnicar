; ==== sub_a7fc @ 0xa7fc..0xa98c (400 bytes) ====
0x0000a7fc  mov      x0, x23
0x0000a800  bl       #0x2480c   ; call _objc_release
0x0000a804  mov      x0, x22
0x0000a808  bl       #0x2480c   ; call _objc_release
0x0000a80c  mov      x0, x20
0x0000a810  bl       #0x2480c   ; call _objc_release
0x0000a814  mov      x0, x19
0x0000a818  bl       #0x2480c   ; call _objc_release
0x0000a81c  ldr      x8, [sp, #0x58]
0x0000a820  adrp     x9, #0x34000
0x0000a824  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x0000a828  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0000a82c  cmp      x9, x8
0x0000a830  b.ne     #0xa858
0x0000a834  ldp      x29, x30, [sp, #0xc0]
0x0000a838  ldp      x20, x19, [sp, #0xb0]
0x0000a83c  ldp      x22, x21, [sp, #0xa0]
0x0000a840  ldp      x24, x23, [sp, #0x90]
0x0000a844  ldp      x26, x25, [sp, #0x80]
0x0000a848  ldp      d9, d8, [sp, #0x70]
0x0000a84c  ldp      d11, d10, [sp, #0x60]
0x0000a850  add      sp, sp, #0xd0
0x0000a854  ret      
0x0000a858  bl       #0x24488   ; call ___stack_chk_fail
0x0000a85c  b        #0xa8c0   ; call sub_a8c0
0x0000a860  b        #0xa8d0   ; call sub_a8d0
0x0000a864  b        #0xa8f0   ; call sub_a8f0
0x0000a868  b        #0xa8f0   ; call sub_a8f0
0x0000a86c  mov      x1, x21
0x0000a870  mov      x21, x0
0x0000a874  mov      x0, x1
0x0000a878  bl       #0x2480c   ; call _objc_release
0x0000a87c  b        #0xa884   ; call sub_a884
0x0000a880  mov      x21, x0
0x0000a884  mov      x0, x25
0x0000a888  bl       #0x2480c   ; call _objc_release
0x0000a88c  b        #0xa894   ; call sub_a894
0x0000a890  mov      x21, x0
0x0000a894  mov      x0, x24
0x0000a898  bl       #0x2480c   ; call _objc_release
0x0000a89c  b        #0xa8a4   ; call sub_a8a4
0x0000a8a0  mov      x21, x0
0x0000a8a4  mov      x0, x23
0x0000a8a8  bl       #0x2480c   ; call _objc_release
0x0000a8ac  b        #0xa8b4   ; call sub_a8b4
0x0000a8b0  mov      x21, x0
0x0000a8b4  mov      x0, x22
0x0000a8b8  bl       #0x2480c   ; call _objc_release
0x0000a8bc  b        #0xa8e4   ; call sub_a8e4
0x0000a8c0  mov      x21, x0
0x0000a8c4  mov      x0, x23
0x0000a8c8  bl       #0x2480c   ; call _objc_release
0x0000a8cc  b        #0xa8d4   ; call sub_a8d4
0x0000a8d0  mov      x21, x0
0x0000a8d4  mov      x0, x20
0x0000a8d8  bl       #0x2480c   ; call _objc_release
0x0000a8dc  b        #0xa8f4   ; call sub_a8f4
0x0000a8e0  mov      x21, x0
0x0000a8e4  mov      x0, x20
0x0000a8e8  bl       #0x2480c   ; call _objc_release
0x0000a8ec  b        #0xa8f4   ; call sub_a8f4
0x0000a8f0  mov      x21, x0
0x0000a8f4  mov      x0, x19
0x0000a8f8  bl       #0x2480c   ; call _objc_release
0x0000a8fc  b        #0xa904   ; call sub_a904
0x0000a900  mov      x21, x0
0x0000a904  mov      x0, x21
0x0000a908  bl       #0x24470   ; call __Unwind_Resume
0x0000a90c  mov      x3, x2
0x0000a910  mov      w2, #0
0x0000a914  b        #0x267e0   ; objc_msgSend: relay:touches:
0x0000a918  mov      x3, x2
0x0000a91c  mov      w2, #1
0x0000a920  b        #0x267e0   ; objc_msgSend: relay:touches:
0x0000a924  mov      x3, x2
0x0000a928  mov      w2, #2
0x0000a92c  b        #0x267e0   ; objc_msgSend: relay:touches:
0x0000a930  mov      x3, x2
0x0000a934  mov      w2, #3
0x0000a938  b        #0x267e0   ; objc_msgSend: relay:touches:
0x0000a93c  adrp     x8, #0x3e000
0x0000a940  ldrsw    x8, [x8, #0x4cc]
0x0000a944  ldr      w0, [x0, x8]
0x0000a948  ret      
0x0000a94c  adrp     x8, #0x3e000
0x0000a950  ldrsw    x8, [x8, #0x4cc]
0x0000a954  str      w2, [x0, x8]
0x0000a958  ret      
0x0000a95c  adrp     x8, #0x3e000
0x0000a960  ldrsw    x8, [x8, #0x4d0]
0x0000a964  add      x8, x0, x8
0x0000a968  ldp      d0, d1, [x8]
0x0000a96c  ret      
0x0000a970  adrp     x8, #0x3e000
0x0000a974  ldrsw    x8, [x8, #0x4d0]
0x0000a978  add      x8, x0, x8
0x0000a97c  stp      d0, d1, [x8]
0x0000a980  ret      
0x0000a984  adrp     x8, #0x3e000
0x0000a988  ldrsw    x8, [x8, #0x4d4]
