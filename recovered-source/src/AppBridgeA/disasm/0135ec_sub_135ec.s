; ==== sub_135ec @ 0x135ec..0x136b0 (196 bytes) ====
0x000135ec  mov      x2, x23
0x000135f0  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x000135f4  mov      x0, x23
0x000135f8  bl       #0x2480c   ; call _objc_release
0x000135fc  add      w28, w28, #7
0x00013600  cmp      w28, #0x1e
0x00013604  b.ne     #0x13550
0x00013608  mov      x0, x20
0x0001360c  mov      x2, x21
0x00013610  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x00013614  adrp     x8, #0x3e000
0x00013618  ldr      x0, [x8, #0x370]   ; -> [class(UITapGestureRecognizer)]
0x0001361c  bl       #0x2471c   ; call _objc_alloc
0x00013620  adrp     x8, #0x3d000
0x00013624  ldr      x3, [x8, #0x290]   ; -> [@selector(handleTapped:)]
0x00013628  mov      x2, x22
0x0001362c  bl       #0x25ac0   ; objc_msgSend: initWithTarget:action:
0x00013630  mov      x23, x0
0x00013634  mov      x0, x20
0x00013638  mov      x2, x23
0x0001363c  bl       #0x24ae0   ; objc_msgSend: addGestureRecognizer:
0x00013640  mov      x0, x23
0x00013644  bl       #0x2480c   ; call _objc_release
0x00013648  adrp     x8, #0x3e000
0x0001364c  ldr      x0, [x8, #0x378]   ; -> [class(UIPanGestureRecognizer)]
0x00013650  bl       #0x2471c   ; call _objc_alloc
0x00013654  adrp     x8, #0x3d000
0x00013658  ldr      x3, [x8, #0x298]   ; -> [@selector(handlePanned:)]
0x0001365c  mov      x2, x22
0x00013660  bl       #0x25ac0   ; objc_msgSend: initWithTarget:action:
0x00013664  mov      x23, x0
0x00013668  mov      w2, #1
0x0001366c  bl       #0x27380   ; objc_msgSend: setMaximumNumberOfTouches:
0x00013670  mov      x0, x20
0x00013674  mov      x2, x23
0x00013678  bl       #0x24ae0   ; objc_msgSend: addGestureRecognizer:
0x0001367c  mov      x0, x20
0x00013680  mov      w2, #5
0x00013684  bl       #0x26c00   ; objc_msgSend: setAutoresizingMask:
0x00013688  mov      x0, x19
0x0001368c  mov      x2, x21
0x00013690  bl       #0x27000   ; objc_msgSend: setHandle:
0x00013694  mov      x0, x19
0x00013698  mov      x2, x20
0x0001369c  bl       #0x27020   ; objc_msgSend: setHandleHit:
0x000136a0  mov      x0, x19
0x000136a4  bl       #0x24f60   ; objc_msgSend: box
0x000136a8  mov      x29, x29
0x000136ac  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
