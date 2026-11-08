; ==== sub_1a7dc @ 0x1a7dc..0x1a8b0 (212 bytes) ====
0x0001a7dc  mov      x29, x29
0x0001a7e0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a7e4  mov      x26, x0
0x0001a7e8  fmov     d0, #1.00000000
0x0001a7ec  bl       #0x26ca0   ; objc_msgSend: setBorderWidth:
0x0001a7f0  mov      x0, x26
0x0001a7f4  bl       #0x2480c   ; call _objc_release
0x0001a7f8  adrp     x8, #0x3e000
0x0001a7fc  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x0001a800  fmov     d3, #1.00000000
0x0001a804  mov      v0.16b, v8.16b
0x0001a808  mov      v1.16b, v9.16b
0x0001a80c  mov      v2.16b, v10.16b
0x0001a810  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001a814  mov      x29, x29
0x0001a818  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a81c  mov      x26, x0
0x0001a820  fmov     d0, #0.25000000
0x0001a824  bl       #0x25200   ; objc_msgSend: colorWithAlphaComponent:
0x0001a828  mov      x29, x29
0x0001a82c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a830  mov      x27, x0
0x0001a834  bl       #0x24824   ; call _objc_retainAutorelease
0x0001a838  bl       #0x249e0   ; objc_msgSend: CGColor
0x0001a83c  mov      x21, x0
0x0001a840  mov      x0, x25
0x0001a844  bl       #0x25f00   ; objc_msgSend: layer
0x0001a848  mov      x29, x29
0x0001a84c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a850  mov      x28, x0
0x0001a854  mov      x2, x21
0x0001a858  bl       #0x26c80   ; objc_msgSend: setBorderColor:
0x0001a85c  mov      x0, x28
0x0001a860  bl       #0x2480c   ; call _objc_release
0x0001a864  mov      x0, x27
0x0001a868  bl       #0x2480c   ; call _objc_release
0x0001a86c  mov      x0, x26
0x0001a870  bl       #0x2480c   ; call _objc_release
0x0001a874  mov      x0, x25
0x0001a878  bl       #0x25f00   ; objc_msgSend: layer
0x0001a87c  mov      x29, x29
0x0001a880  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a884  mov      x26, x0
0x0001a888  fmov     d0, #6.00000000
0x0001a88c  bl       #0x26e20   ; objc_msgSend: setCornerRadius:
0x0001a890  mov      x0, x26
0x0001a894  bl       #0x2480c   ; call _objc_release
0x0001a898  adrp     x8, #0x3d000
0x0001a89c  ldr      x3, [x8, #0x2a8]   ; -> [@selector(langTapped)]
0x0001a8a0  mov      x0, x25
0x0001a8a4  mov      x2, x22
0x0001a8a8  mov      w4, #0x40
0x0001a8ac  bl       #0x24bc0   ; objc_msgSend: addTarget:action:forControlEvents:
