=== -[SSCanvasView drawRect:]  va=0x461c0 size=92 types=v48@0:8{CGRect={CGPoint=dd}{CGSize=dd}}16
0x000461c0  stp      x22, x21, [sp, #-0x30]!
0x000461c4  stp      x20, x19, [sp, #0x10]
0x000461c8  stp      x29, x30, [sp, #0x20]
0x000461cc  add      x29, sp, #0x20
0x000461d0  mov      x19, x0
0x000461d4  bl       #0x59540   ; CALL objc_msgSend$owner
0x000461d8  mov      x29, x29
0x000461dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000461e0  mov      x20, x0
0x000461e4  bl       #0x55b20   ; CALL _UIGraphicsGetCurrentContext
0x000461e8  mov      x21, x0
0x000461ec  mov      x0, x19
0x000461f0  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x000461f4  mov      v0.16b, v2.16b
0x000461f8  mov      v1.16b, v3.16b
0x000461fc  mov      x0, x20
0x00046200  mov      x2, x21
0x00046204  bl       #0x5d100   ; CALL objc_msgSend$ss_drawCanvas:size:
0x00046208  mov      x0, x20
0x0004620c  ldp      x29, x30, [sp, #0x20]
0x00046210  ldp      x20, x19, [sp, #0x10]
0x00046214  ldp      x22, x21, [sp], #0x30
0x00046218  b        #0x55d78   ; CALL _objc_release

=== -[SSCanvasView owner]  va=0x4621c size=32 types=@16@0:8
0x0004621c  stp      x29, x30, [sp, #-0x10]!
0x00046220  mov      x29, sp
0x00046224  adrp     x8, #0x8e000
0x00046228  ldrsw    x8, [x8, #0xff0]
0x0004622c  add      x0, x0, x8
0x00046230  bl       #0x55d24   ; CALL _objc_loadWeakRetained
0x00046234  ldp      x29, x30, [sp], #0x10
0x00046238  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[SSCanvasView setOwner:]  va=0x4623c size=20 types=v24@0:8@16
0x0004623c  mov      x1, x2
0x00046240  adrp     x8, #0x8e000
0x00046244  ldrsw    x8, [x8, #0xff0]
0x00046248  add      x0, x0, x8
0x0004624c  b        #0x55dd8   ; CALL _objc_storeWeak

=== -[SSCanvasView .cxx_destruct]  va=0x46250 size=16 types=v16@0:8
0x00046250  adrp     x8, #0x8e000
0x00046254  ldrsw    x8, [x8, #0xff0]
0x00046258  add      x0, x0, x8
0x0004625c  b        #0x55cdc   ; CALL _objc_destroyWeak
