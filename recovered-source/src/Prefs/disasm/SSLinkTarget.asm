=== -[SSLinkTarget step:]  va=0x46134 size=96 types=v24@0:8@16
0x00046134  stp      x20, x19, [sp, #-0x20]!
0x00046138  stp      x29, x30, [sp, #0x10]
0x0004613c  add      x29, sp, #0x10
0x00046140  mov      x19, x2
0x00046144  mov      x20, x0
0x00046148  mov      x0, x2
0x0004614c  bl       #0x55d84   ; CALL _objc_retain
0x00046150  mov      x0, x20
0x00046154  bl       #0x59540   ; CALL objc_msgSend$owner
0x00046158  mov      x29, x29
0x0004615c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00046160  mov      x20, x0
0x00046164  cbz      x0, #0x46174
0x00046168  mov      x0, x20
0x0004616c  bl       #0x5d260   ; CALL objc_msgSend$ss_step
0x00046170  b        #0x4617c
0x00046174  mov      x0, x19
0x00046178  bl       #0x58740   ; CALL objc_msgSend$invalidate
0x0004617c  mov      x0, x20
0x00046180  bl       #0x55d78   ; CALL _objc_release
0x00046184  mov      x0, x19
0x00046188  ldp      x29, x30, [sp, #0x10]
0x0004618c  ldp      x20, x19, [sp], #0x20
0x00046190  b        #0x55d78   ; CALL _objc_release

=== -[SSLinkTarget owner]  va=0x46194 size=24 types=@16@0:8
0x00046194  stp      x29, x30, [sp, #-0x10]!
0x00046198  mov      x29, sp
0x0004619c  add      x0, x0, #8
0x000461a0  bl       #0x55d24   ; CALL _objc_loadWeakRetained
0x000461a4  ldp      x29, x30, [sp], #0x10
0x000461a8  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[SSLinkTarget setOwner:]  va=0x461ac size=12 types=v24@0:8@16
0x000461ac  mov      x1, x2
0x000461b0  add      x0, x0, #8
0x000461b4  b        #0x55dd8   ; CALL _objc_storeWeak

=== -[SSLinkTarget .cxx_destruct]  va=0x461b8 size=8 types=v16@0:8
0x000461b8  add      x0, x0, #8
0x000461bc  b        #0x55cdc   ; CALL _objc_destroyWeak
