; ==== sub_22154 @ 0x22154..0x221c4 (112 bytes) ====
0x00022154  adrp     x8, #0x3e000
0x00022158  ldr      w9, [x8, #0xc14]
0x0002215c  add      w9, w9, #1
0x00022160  str      w9, [x8, #0xc14]
0x00022164  mov      w8, #0xcccd
0x00022168  movk     w8, #0xcccc, lsl #16
0x0002216c  mul      w8, w9, w8
0x00022170  ror      w8, w8, #2
0x00022174  mov      w9, #0xcccc
0x00022178  movk     w9, #0xccc, lsl #16
0x0002217c  cmp      w8, w9
0x00022180  b.hi     #0x2233c
0x00022184  str      wzr, [sp, #0x2c]
0x00022188  adrp     x19, #0x34000
0x0002218c  ldr      x19, [x19, #0x3c0]   ; -> [got:_mach_task_self_]
0x00022190  ldr      w0, [x19]   ; -> [got:___objc_personality_v0]
0x00022194  add      x1, sp, #0x30
0x00022198  add      x2, sp, #0x2c
0x0002219c  bl       #0x24998   ; call _task_threads
0x000221a0  fmov     d9, #-1.00000000
0x000221a4  fmov     d8, #-1.00000000
0x000221a8  cbnz     w0, #0x22248
0x000221ac  ldr      w8, [sp, #0x2c]
0x000221b0  cbz      w8, #0x22234
0x000221b4  mov      x20, #0
0x000221b8  fmov     d8, xzr
0x000221bc  mov      w21, #0xa
0x000221c0  mov      x22, #0x4059000000000000
