; ==== sub_10178 @ 0x10178..0x10270 (248 bytes) ====
0x00010178  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0001017c  mov      x29, x29
0x00010180  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00010184  mov      x23, x0
0x00010188  adrp     x0, #0x34000
0x0001018c  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00010190  mov      x1, x23
0x00010194  bl       #0x1dd30   ; call _OMCLogWrite
0x00010198  mov      x0, x23
0x0001019c  bl       #0x2480c   ; call _objc_release
0x000101a0  mov      x0, x22
0x000101a4  bl       #0x2480c   ; call _objc_release
0x000101a8  ldr      x0, [sp, #0x40]
0x000101ac  bl       #0x2480c   ; call _objc_release
0x000101b0  mov      x0, x20
0x000101b4  bl       #0x2480c   ; call _objc_release
0x000101b8  mov      x0, x19
0x000101bc  bl       #0x2480c   ; call _objc_release
0x000101c0  ldp      x29, x30, [sp, #0xf0]
0x000101c4  ldp      x20, x19, [sp, #0xe0]
0x000101c8  ldp      x22, x21, [sp, #0xd0]
0x000101cc  ldp      x24, x23, [sp, #0xc0]
0x000101d0  ldp      x26, x25, [sp, #0xb0]
0x000101d4  ldp      d9, d8, [sp, #0xa0]
0x000101d8  ldp      d11, d10, [sp, #0x90]
0x000101dc  ldp      d13, d12, [sp, #0x80]
0x000101e0  ldp      d15, d14, [sp, #0x70]
0x000101e4  add      sp, sp, #0x100
0x000101e8  ret      
0x000101ec  b        #0x101f0   ; call sub_101f0
0x000101f0  mov      x21, x0
0x000101f4  mov      x0, x23
0x000101f8  bl       #0x2480c   ; call _objc_release
0x000101fc  b        #0x10208   ; call sub_10208
0x00010200  b        #0x10204   ; call sub_10204
0x00010204  mov      x21, x0
0x00010208  mov      x0, x22
0x0001020c  bl       #0x2480c   ; call _objc_release
0x00010210  b        #0x10240   ; call sub_10240
0x00010214  mov      x21, x0
0x00010218  mov      x0, x23
0x0001021c  b        #0x10254   ; call sub_10254
0x00010220  b        #0x10268   ; call sub_10268
0x00010224  b        #0x1023c   ; call sub_1023c
0x00010228  b        #0x10230   ; call sub_10230
0x0001022c  b        #0x10268   ; call sub_10268
0x00010230  mov      x21, x0
0x00010234  mov      x0, x22
0x00010238  b        #0x10254   ; call sub_10254
0x0001023c  mov      x21, x0
0x00010240  ldr      x0, [sp, #0x40]
0x00010244  b        #0x10254   ; call sub_10254
0x00010248  b        #0x1024c   ; call sub_1024c
0x0001024c  mov      x21, x0
0x00010250  mov      x0, x25
0x00010254  bl       #0x2480c   ; call _objc_release
0x00010258  b        #0x1026c   ; call sub_1026c
0x0001025c  b        #0x10268   ; call sub_10268
0x00010260  mov      x21, x0
0x00010264  b        #0x10274   ; call sub_10274
0x00010268  mov      x21, x0
0x0001026c  mov      x0, x20
