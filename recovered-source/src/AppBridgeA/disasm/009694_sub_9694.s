; ==== sub_9694 @ 0x9694..0x96f8 (100 bytes) ====
0x00009694  br       x1
0x00009698  sub      sp, sp, #0x50
0x0000969c  stp      x24, x23, [sp, #0x10]
0x000096a0  stp      x22, x21, [sp, #0x20]
0x000096a4  stp      x20, x19, [sp, #0x30]
0x000096a8  stp      x29, x30, [sp, #0x40]
0x000096ac  add      x29, sp, #0x40
0x000096b0  mov      x20, x1
0x000096b4  mov      x19, x0
0x000096b8  bl       #0x24818   ; call _objc_retain
0x000096bc  mov      x0, x20
0x000096c0  bl       #0x24818   ; call _objc_retain
0x000096c4  cbz      x19, #0x97d4
0x000096c8  adrp     x8, #0x3e000
0x000096cc  ldr      x8, [x8, #0xa28]
0x000096d0  cmn      x8, #1
0x000096d4  b.ne     #0x97f8
0x000096d8  adrp     x23, #0x3e000
0x000096dc  ldr      x21, [x23, #0x290]   ; -> [class(NSString)]
0x000096e0  mov      x0, x19
0x000096e4  bl       #0x247d0   ; call _objc_opt_class
0x000096e8  bl       #0x2444c   ; call _NSStringFromClass
0x000096ec  mov      x29, x29
0x000096f0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000096f4  mov      x22, x0
