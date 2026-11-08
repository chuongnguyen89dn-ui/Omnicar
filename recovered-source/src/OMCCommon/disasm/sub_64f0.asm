; === sub_64f0 @ 0x64f0 size=56 ===
0x000064f0  stp      x29, x30, [sp, #-0x10]!
0x000064f4  mov      x29, sp
0x000064f8  adrp     x0, #0xe000
0x000064fc  add      x0, x0, #0xd24 ; -> "/System/Library/PrivateFrameworks/BackBoardServices.framework/BackBoardServices"
0x00006500  mov      w1, #1
0x00006504  bl       #0xd2f0 ; call stub:_dlopen
0x00006508  adrp     x1, #0xe000
0x0000650c  add      x1, x1, #0xd74 ; -> "BKSTerminateApplicationForReasonAndReportWithDescription"
0x00006510  mov      x0, #-2
0x00006514  bl       #0xd2fc ; call stub:_dlsym
0x00006518  adrp     x8, #0x18000
0x0000651c  str      x0, [x8, #0x540]
0x00006520  ldp      x29, x30, [sp], #0x10
0x00006524  ret      
