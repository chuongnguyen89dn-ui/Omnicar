; ==== sub_de50 @ 0xde50..0xdea8 (88 bytes) ====
0x0000de50  bl       #0x2480c   ; call _objc_release
0x0000de54  b        #0xdeb8   ; call sub_deb8
0x0000de58  mov      x20, x0
0x0000de5c  mov      x23, #0
0x0000de60  b        #0xdeb8   ; call sub_deb8
0x0000de64  mov      x20, x0
0x0000de68  b        #0xdec8   ; call sub_dec8
0x0000de6c  b        #0xde90   ; call sub_de90
0x0000de70  mov      x20, x0
0x0000de74  mov      x0, x24
0x0000de78  bl       #0x2480c   ; call _objc_release
0x0000de7c  b        #0xdeb8   ; call sub_deb8
0x0000de80  b        #0xdeb4   ; call sub_deb4
0x0000de84  b        #0xde90   ; call sub_de90
0x0000de88  b        #0xdeb4   ; call sub_deb4
0x0000de8c  b        #0xdeb4   ; call sub_deb4
0x0000de90  mov      x20, x0
0x0000de94  ldr      x0, [sp, #0x40]
0x0000de98  bl       #0x2480c   ; call _objc_release
0x0000de9c  b        #0xdec8   ; call sub_dec8
0x0000dea0  b        #0xdea4   ; call sub_dea4
0x0000dea4  mov      x20, x0
