; === sub_900c @ 0x900c size=208 ===
0x0000900c  sub      sp, sp, #0x50
0x00009010  stp      x20, x19, [sp, #0x30]
0x00009014  stp      x29, x30, [sp, #0x40]
0x00009018  add      x29, sp, #0x40
0x0000901c  adrp     x8, #0x18000
0x00009020  ldr      x0, [x8, #0x488] ; -> [classref(NSProcessInfo)]
0x00009024  bl       #0xe040 ; call objc_stub[processInfo]
0x00009028  mov      x29, x29
0x0000902c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00009030  mov      x20, x0
0x00009034  bl       #0xe060 ; call objc_stub[processName]
0x00009038  mov      x29, x29
0x0000903c  bl       #0xd4dc ; call stub:_objc_retainAutoreleasedReturnValue
0x00009040  mov      x19, x0
0x00009044  mov      x0, x20
0x00009048  bl       #0xd4b8 ; call stub:_objc_release
0x0000904c  adrp     x2, #0x15000
0x00009050  add      x2, x2, #0xbe8 ; -> CFSTR("SpringBoard")
0x00009054  mov      x0, x19
0x00009058  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x0000905c  tbnz     w0, #0, #0x9074
0x00009060  adrp     x2, #0x15000
0x00009064  add      x2, x2, #0xc08 ; -> CFSTR("CarPlay")
0x00009068  mov      x0, x19
0x0000906c  bl       #0xdc80 ; call objc_stub[isEqualToString:]
0x00009070  cbz      w0, #0x90c4
0x00009074  adrp     x8, #0x14000
0x00009078  ldr      x8, [x8, #0x1a0] ; -> [got(__NSConcreteStackBlock)]
0x0000907c  str      x8, [sp, #8]
0x00009080  adrp     x8, #0xf000
0x00009084  ldr      d0, [x8, #0xab8] ; -> [__TEXT,__const+0x8 [u64=0xc2000000 f64=1.6080749353e-314]]
0x00009088  str      d0, [sp, #0x10]
0x0000908c  adrp     x8, #0x9000
0x00009090  add      x8, x8, #0xdc ; -> __TEXT,__text+0x50dc
0x00009094  adrp     x9, #0x14000
0x00009098  add      x9, x9, #0x5e8 ; -> __DATA_CONST,__const+0x1e0 [u64=0x0 f64=0.0]
0x0000909c  stp      x8, x9, [sp, #0x18]
0x000090a0  mov      x0, x19
0x000090a4  bl       #0xd4c4 ; call stub:_objc_retain
0x000090a8  str      x19, [sp, #0x28]
0x000090ac  adrp     x0, #0x14000
0x000090b0  ldr      x0, [x0, #0x1d0] ; -> [got(__dispatch_main_q)]
0x000090b4  add      x1, sp, #8
0x000090b8  bl       #0xd26c ; call stub:_dispatch_async
0x000090bc  ldr      x0, [sp, #0x28]
0x000090c0  bl       #0xd4b8 ; call stub:_objc_release
0x000090c4  mov      x0, x19
0x000090c8  bl       #0xd4b8 ; call stub:_objc_release
0x000090cc  ldp      x29, x30, [sp, #0x40]
0x000090d0  ldp      x20, x19, [sp, #0x30]
0x000090d4  add      sp, sp, #0x50
0x000090d8  ret      
