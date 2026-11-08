; ==== sub_ee20 @ 0xee20..0xeea8 (136 bytes) ====
0x0000ee20  mov      x28, #0
0x0000ee24  adrp     x2, #0x36000
0x0000ee28  add      x2, x2, #0xf0   ; -> @"sceneView"
0x0000ee2c  mov      x0, x21
0x0000ee30  bl       #0x28100   ; objc_msgSend: valueForKey:
0x0000ee34  mov      x29, x29
0x0000ee38  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ee3c  mov      x22, x0
0x0000ee40  cbz      x0, #0xeecc
0x0000ee44  adrp     x2, #0x36000
0x0000ee48  add      x2, x2, #0x110   ; -> @"_sceneContentContainerView"
0x0000ee4c  mov      x28, x22
0x0000ee50  mov      x0, x22
0x0000ee54  bl       #0x28100   ; objc_msgSend: valueForKey:
0x0000ee58  mov      x29, x29
0x0000ee5c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ee60  mov      x23, x0
0x0000ee64  b        #0xeed0   ; call sub_eed0
0x0000ee68  mov      x23, #0
0x0000ee6c  mov      x22, #0
0x0000ee70  b        #0xeed0   ; call sub_eed0
0x0000ee74  mov      x23, x1
0x0000ee78  mov      x26, x0
0x0000ee7c  mov      x0, x22
0x0000ee80  bl       #0x2480c   ; call _objc_release
0x0000ee84  mov      x22, #0
0x0000ee88  mov      x21, #0
0x0000ee8c  b        #0xeeb8   ; call sub_eeb8
0x0000ee90  mov      x26, x0
0x0000ee94  mov      x0, x21
0x0000ee98  b        #0xf1fc   ; call sub_f1fc
0x0000ee9c  b        #0xf1ec   ; call sub_f1ec
0x0000eea0  b        #0xf1ec   ; call sub_f1ec
0x0000eea4  b        #0xf1f4   ; call sub_f1f4
