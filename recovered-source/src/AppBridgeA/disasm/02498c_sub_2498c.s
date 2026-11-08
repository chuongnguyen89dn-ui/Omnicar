; ==== sub_2498c @ 0x2498c..0x24bcc (576 bytes) ====
0x0002498c  adrp     x16, #0x34000
0x00024990  ldr      x16, [x16, #0x478]   ; -> [got:_task_info]
0x00024994  br       x16
0x00024998  adrp     x16, #0x34000
0x0002499c  ldr      x16, [x16, #0x480]   ; -> [got:_task_threads]
0x000249a0  br       x16
0x000249a4  adrp     x16, #0x34000
0x000249a8  ldr      x16, [x16, #0x488]   ; -> [got:_thread_info]
0x000249ac  br       x16
0x000249b0  adrp     x16, #0x34000
0x000249b4  ldr      x16, [x16, #0x490]   ; -> [got:_time]
0x000249b8  br       x16
0x000249bc  adrp     x16, #0x34000
0x000249c0  ldr      x16, [x16, #0x498]   ; -> [got:_unlink]
0x000249c4  br       x16
0x000249c8  adrp     x16, #0x34000
0x000249cc  ldr      x16, [x16, #0x4a0]   ; -> [got:_vm_deallocate]
0x000249d0  br       x16
0x000249d4  udf      #0
0x000249d8  udf      #0
0x000249dc  udf      #0
0x000249e0  adrp     x1, #0x3d000
0x000249e4  ldr      x1, [x1, #0x2b8]   ; -> [@selector(CGColor)]
0x000249e8  adrp     x16, #0x34000
0x000249ec  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x000249f0  br       x16
0x000249f4  brk      #1
0x000249f8  brk      #1
0x000249fc  brk      #1
0x00024a00  adrp     x1, #0x3d000
0x00024a04  ldr      x1, [x1, #0x2c0]   ; -> [@selector(CGContext)]
0x00024a08  adrp     x16, #0x34000
0x00024a0c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00024a10  br       x16
0x00024a14  brk      #1
0x00024a18  brk      #1
0x00024a1c  brk      #1
0x00024a20  adrp     x1, #0x3d000
0x00024a24  ldr      x1, [x1, #0x2c8]   ; -> [@selector(CGPath)]
0x00024a28  adrp     x16, #0x34000
0x00024a2c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00024a30  br       x16
0x00024a34  brk      #1
0x00024a38  brk      #1
0x00024a3c  brk      #1
0x00024a40  adrp     x1, #0x3d000
0x00024a44  ldr      x1, [x1, #0x2d0]   ; -> [@selector(UTF8String)]
0x00024a48  adrp     x16, #0x34000
0x00024a4c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00024a50  br       x16
0x00024a54  brk      #1
0x00024a58  brk      #1
0x00024a5c  brk      #1
0x00024a60  adrp     x1, #0x3d000
0x00024a64  ldr      x1, [x1, #0x2d8]   ; -> [@selector(accent)]
0x00024a68  adrp     x16, #0x34000
0x00024a6c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00024a70  br       x16
0x00024a74  brk      #1
0x00024a78  brk      #1
0x00024a7c  brk      #1
0x00024a80  adrp     x1, #0x3d000
0x00024a84  ldr      x1, [x1, #0x2e0]   ; -> [@selector(addAnimations:)]
0x00024a88  adrp     x16, #0x34000
0x00024a8c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00024a90  br       x16
0x00024a94  brk      #1
0x00024a98  brk      #1
0x00024a9c  brk      #1
0x00024aa0  adrp     x1, #0x3d000
0x00024aa4  ldr      x1, [x1, #0x2e8]   ; -> [@selector(addArcWithCenter:radius:startAngle:endAngle:clockwise:)]
0x00024aa8  adrp     x16, #0x34000
0x00024aac  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00024ab0  br       x16
0x00024ab4  brk      #1
0x00024ab8  brk      #1
0x00024abc  brk      #1
0x00024ac0  adrp     x1, #0x3d000
0x00024ac4  ldr      x1, [x1, #0x2f0]   ; -> [@selector(addCompletion:)]
0x00024ac8  adrp     x16, #0x34000
0x00024acc  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00024ad0  br       x16
0x00024ad4  brk      #1
0x00024ad8  brk      #1
0x00024adc  brk      #1
0x00024ae0  adrp     x1, #0x3d000
0x00024ae4  ldr      x1, [x1, #0x2f8]   ; -> [@selector(addGestureRecognizer:)]
0x00024ae8  adrp     x16, #0x34000
0x00024aec  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00024af0  br       x16
0x00024af4  brk      #1
0x00024af8  brk      #1
0x00024afc  brk      #1
0x00024b00  adrp     x1, #0x3d000
0x00024b04  ldr      x1, [x1, #0x300]   ; -> [@selector(addLineToPoint:)]
0x00024b08  adrp     x16, #0x34000
0x00024b0c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00024b10  br       x16
0x00024b14  brk      #1
0x00024b18  brk      #1
0x00024b1c  brk      #1
0x00024b20  adrp     x1, #0x3d000
0x00024b24  ldr      x1, [x1, #0x308]   ; -> [@selector(addObject:)]
0x00024b28  adrp     x16, #0x34000
0x00024b2c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00024b30  br       x16
0x00024b34  brk      #1
0x00024b38  brk      #1
0x00024b3c  brk      #1
0x00024b40  adrp     x1, #0x3d000
0x00024b44  ldr      x1, [x1, #0x310]   ; -> [@selector(addObjectsFromArray:)]
0x00024b48  adrp     x16, #0x34000
0x00024b4c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00024b50  br       x16
0x00024b54  brk      #1
0x00024b58  brk      #1
0x00024b5c  brk      #1
0x00024b60  adrp     x1, #0x3d000
0x00024b64  ldr      x1, [x1, #0x318]   ; -> [@selector(addObserverForName:object:queue:usingBlock:)]
0x00024b68  adrp     x16, #0x34000
0x00024b6c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00024b70  br       x16
0x00024b74  brk      #1
0x00024b78  brk      #1
0x00024b7c  brk      #1
0x00024b80  adrp     x1, #0x3d000
0x00024b84  ldr      x1, [x1, #0x320]   ; -> [@selector(addSublayer:)]
0x00024b88  adrp     x16, #0x34000
0x00024b8c  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00024b90  br       x16
0x00024b94  brk      #1
0x00024b98  brk      #1
0x00024b9c  brk      #1
0x00024ba0  adrp     x1, #0x3d000
0x00024ba4  ldr      x1, [x1, #0x328]   ; -> [@selector(addSubview:)]
0x00024ba8  adrp     x16, #0x34000
0x00024bac  ldr      x16, [x16, #0xb0]   ; -> [got:_objc_msgSend]
0x00024bb0  br       x16
0x00024bb4  brk      #1
0x00024bb8  brk      #1
0x00024bbc  brk      #1
0x00024bc0  adrp     x1, #0x3d000
0x00024bc4  ldr      x1, [x1, #0x330]   ; -> [@selector(addTarget:action:forControlEvents:)]
0x00024bc8  adrp     x16, #0x34000
