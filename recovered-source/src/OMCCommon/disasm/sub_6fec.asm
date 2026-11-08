; === sub_6fec @ 0x6fec size=112 ===
0x00006fec  stp      x20, x19, [sp, #-0x20]!
0x00006ff0  stp      x29, x30, [sp, #0x10]
0x00006ff4  add      x29, sp, #0x10
0x00006ff8  mov      x19, x0
0x00006ffc  bl       #0xd4c4 ; call stub:_objc_retain
0x00007000  adrp     x0, #0x15000
0x00007004  add      x0, x0, #0x808 ; -> CFSTR("/var/mobile/Documents/OmniCar.log")
0x00007008  bl       #0xdb60 ; call objc_stub[fileSystemRepresentation]
0x0000700c  adrp     x1, #0xf000
0x00007010  add      x1, x1, #0x2ea ; -> "a"
0x00007014  bl       #0xd320 ; call stub:_fopen
0x00007018  mov      x20, x0
0x0000701c  cbz      x0, #0x703c
0x00007020  mov      x0, x19
0x00007024  bl       #0xd4d0 ; call stub:_objc_retainAutorelease
0x00007028  bl       #0xd680 ; call objc_stub[UTF8String]
0x0000702c  mov      x1, x20
0x00007030  bl       #0xd32c ; call stub:_fputs
0x00007034  mov      x0, x20
0x00007038  bl       #0xd314 ; call stub:_fclose
0x0000703c  cmp      x20, #0
0x00007040  cset     w20, ne
0x00007044  mov      x0, x19
0x00007048  bl       #0xd4b8 ; call stub:_objc_release
0x0000704c  mov      x0, x20
0x00007050  ldp      x29, x30, [sp, #0x10]
0x00007054  ldp      x20, x19, [sp], #0x20
0x00007058  ret      
