; ==== sub_167cc @ 0x167cc..0x16844 (120 bytes) ====
0x000167cc  mov      x1, #0
0x000167d0  ldp      x29, x30, [sp, #0x10]
0x000167d4  ldp      x20, x19, [sp], #0x20
0x000167d8  b        #0x24860   ; call _objc_storeStrong
0x000167dc  sub      sp, sp, #0x50
0x000167e0  stp      d9, d8, [sp, #0x10]
0x000167e4  stp      x22, x21, [sp, #0x20]
0x000167e8  stp      x20, x19, [sp, #0x30]
0x000167ec  stp      x29, x30, [sp, #0x40]
0x000167f0  add      x29, sp, #0x40
0x000167f4  mov      x20, x2
0x000167f8  mov      v8.16b, v1.16b
0x000167fc  mov      v9.16b, v0.16b
0x00016800  mov      x21, x1
0x00016804  mov      x19, x0
0x00016808  bl       #0x24818   ; call _objc_retain
0x0001680c  mov      x0, x20
0x00016810  bl       #0x24818   ; call _objc_retain
0x00016814  str      x19, [sp]
0x00016818  mov      x0, x19
0x0001681c  bl       #0x2489c   ; call _object_getClass
0x00016820  bl       #0x24530   ; call _class_getSuperclass
0x00016824  str      x0, [sp, #8]
0x00016828  mov      x0, sp
0x0001682c  mov      x1, x21
0x00016830  mov      v0.16b, v9.16b
0x00016834  mov      v1.16b, v8.16b
0x00016838  mov      x2, x20
0x0001683c  bl       #0x247b8   ; call _objc_msgSendSuper
0x00016840  mov      x29, x29
