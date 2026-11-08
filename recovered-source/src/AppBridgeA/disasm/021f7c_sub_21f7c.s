; ==== sub_21f7c @ 0x21f7c..0x22094 (280 bytes) ====
0x00021f7c  mov      x22, x0
0x00021f80  str      x0, [sp, #0x10]
0x00021f84  adrp     x2, #0x38000
0x00021f88  add      x2, x2, #0x730   ; -> @"..."
0x00021f8c  bl       #0x27c80   ; objc_msgSend: stringByAppendingString:
0x00021f90  mov      x29, x29
0x00021f94  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021f98  mov      x2, x0
0x00021f9c  stp      x0, x22, [sp, #8]
0x00021fa0  b        #0x21fa8   ; call sub_21fa8
0x00021fa4  mov      x2, x26
0x00021fa8  mov      x0, x20
0x00021fac  mov      x3, x25
0x00021fb0  bl       #0x27400   ; objc_msgSend: setObject:forKeyedSubscript:
0x00021fb4  cmp      x23, #0xa1
0x00021fb8  b.lo     #0x21fcc
0x00021fbc  ldr      x0, [sp, #8]
0x00021fc0  bl       #0x2480c   ; call _objc_release
0x00021fc4  ldr      x0, [sp, #0x10]
0x00021fc8  bl       #0x2480c   ; call _objc_release
0x00021fcc  mov      x0, x26
0x00021fd0  bl       #0x2480c   ; call _objc_release
0x00021fd4  ldr      x0, [sp, #0x18]
0x00021fd8  bl       #0x2480c   ; call _objc_release
0x00021fdc  adrp     x23, #0x3e000
0x00021fe0  mov      x0, x25
0x00021fe4  bl       #0x2480c   ; call _objc_release
0x00021fe8  add      x24, x24, #1
0x00021fec  ldr      w8, [sp, #0x2c]
0x00021ff0  cmp      x24, x8
0x00021ff4  b.lo     #0x21e08
0x00021ff8  b        #0x22014   ; call sub_22014
0x00021ffc  b        #0x22000   ; call sub_22000
0x00022000  cmp      w1, #1
0x00022004  b.ne     #0x22058
0x00022008  bl       #0x24740   ; call _objc_begin_catch
0x0002200c  bl       #0x24764   ; call _objc_end_catch
0x00022010  b        #0x21fdc   ; call sub_21fdc
0x00022014  mov      x0, x28
0x00022018  bl       #0x2462c   ; call _free
0x0002201c  mov      x0, x21
0x00022020  bl       #0x24530   ; call _class_getSuperclass
0x00022024  mov      x21, x0
0x00022028  cbnz     x0, #0x21dc8
0x0002202c  ldr      x0, [sp, #0x20]
0x00022030  bl       #0x2480c   ; call _objc_release
0x00022034  mov      x0, x20
0x00022038  ldp      x29, x30, [sp, #0x80]
0x0002203c  ldp      x20, x19, [sp, #0x70]
0x00022040  ldp      x22, x21, [sp, #0x60]
0x00022044  ldp      x24, x23, [sp, #0x50]
0x00022048  ldp      x26, x25, [sp, #0x40]
0x0002204c  ldp      x28, x27, [sp, #0x30]
0x00022050  add      sp, sp, #0x90
0x00022054  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x00022058  bl       #0x24470   ; call __Unwind_Resume
0x0002205c  stp      x20, x19, [sp, #-0x20]!
0x00022060  stp      x29, x30, [sp, #0x10]
0x00022064  add      x29, sp, #0x10
0x00022068  mov      x19, x0
0x0002206c  adrp     x20, #0x3e000
0x00022070  ldr      w0, [x20, #0x8fc]
0x00022074  cmn      w0, #1
0x00022078  b.eq     #0x22088
0x0002207c  mov      w1, w19
0x00022080  bl       #0x24710   ; call _notify_set_state
0x00022084  b        #0x220a8   ; call sub_220a8
0x00022088  adrp     x0, #0x2a000
0x0002208c  add      x0, x0, #0x695   ; -> "com.anlai.omnicar/lite"
0x00022090  adrp     x1, #0x3e000
