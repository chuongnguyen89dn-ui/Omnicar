; ==== sub_9734 @ 0x9734..0x9888 (340 bytes) ====
0x00009734  bl       #0x24878   ; call _objc_sync_enter
0x00009738  ldr      x0, [x24, #0xa20]
0x0000973c  mov      x2, x21
0x00009740  bl       #0x25360   ; objc_msgSend: containsObject:
0x00009744  tbz      w0, #0, #0x9754
0x00009748  mov      x0, x22
0x0000974c  bl       #0x24884   ; call _objc_sync_exit
0x00009750  b        #0x97c4   ; call sub_97c4
0x00009754  ldr      x0, [x24, #0xa20]
0x00009758  mov      x2, x21
0x0000975c  bl       #0x24b20   ; objc_msgSend: addObject:
0x00009760  mov      x0, x22
0x00009764  bl       #0x24884   ; call _objc_sync_exit
0x00009768  mov      x0, x22
0x0000976c  bl       #0x2480c   ; call _objc_release
0x00009770  ldr      x23, [x23, #0x290]
0x00009774  mov      x0, x19
0x00009778  bl       #0x247d0   ; call _objc_opt_class
0x0000977c  bl       #0x2444c   ; call _NSStringFromClass
0x00009780  mov      x29, x29
0x00009784  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00009788  mov      x22, x0
0x0000978c  stp      x0, x20, [sp]
0x00009790  adrp     x2, #0x35000
0x00009794  add      x2, x2, #0x990   ; -> @"THIEU METHOD: %@ khong co %@ -> bo qua"
0x00009798  mov      x0, x23
0x0000979c  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x000097a0  mov      x29, x29
0x000097a4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000097a8  mov      x23, x0
0x000097ac  adrp     x0, #0x34000
0x000097b0  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x000097b4  mov      x1, x23
0x000097b8  bl       #0x1dd30   ; call _OMCLogWrite
0x000097bc  mov      x0, x23
0x000097c0  bl       #0x2480c   ; call _objc_release
0x000097c4  mov      x0, x22
0x000097c8  bl       #0x2480c   ; call _objc_release
0x000097cc  mov      x0, x21
0x000097d0  bl       #0x2480c   ; call _objc_release
0x000097d4  mov      x0, x20
0x000097d8  bl       #0x2480c   ; call _objc_release
0x000097dc  mov      x0, x19
0x000097e0  ldp      x29, x30, [sp, #0x40]
0x000097e4  ldp      x20, x19, [sp, #0x30]
0x000097e8  ldp      x22, x21, [sp, #0x20]
0x000097ec  ldp      x24, x23, [sp, #0x10]
0x000097f0  add      sp, sp, #0x50
0x000097f4  b        #0x2480c   ; call _objc_release
0x000097f8  bl       #0x241a4   ; call sub_241a4
0x000097fc  b        #0x96d8   ; call sub_96d8
0x00009800  mov      x1, x23
0x00009804  mov      x23, x0
0x00009808  mov      x0, x1
0x0000980c  bl       #0x2480c   ; call _objc_release
0x00009810  b        #0x983c   ; call sub_983c
0x00009814  mov      x23, x0
0x00009818  b        #0x983c   ; call sub_983c
0x0000981c  mov      x23, x0
0x00009820  b        #0x9844   ; call sub_9844
0x00009824  mov      x23, x0
0x00009828  mov      x0, x22
0x0000982c  b        #0x9848   ; call sub_9848
0x00009830  mov      x23, x0
0x00009834  mov      x0, x22
0x00009838  bl       #0x24884   ; call _objc_sync_exit
0x0000983c  mov      x0, x22
0x00009840  bl       #0x2480c   ; call _objc_release
0x00009844  mov      x0, x21
0x00009848  bl       #0x2480c   ; call _objc_release
0x0000984c  b        #0x9854   ; call sub_9854
0x00009850  mov      x23, x0
0x00009854  mov      x0, x20
0x00009858  bl       #0x2480c   ; call _objc_release
0x0000985c  mov      x0, x19
0x00009860  bl       #0x2480c   ; call _objc_release
0x00009864  mov      x0, x23
0x00009868  bl       #0x24470   ; call __Unwind_Resume
0x0000986c  stp      x29, x30, [sp, #-0x10]!
0x00009870  mov      x29, sp
0x00009874  adrp     x8, #0x3e000
0x00009878  ldr      x0, [x8, #0x2f0]   ; -> [class(NSMutableSet)]
0x0000987c  bl       #0x26ac0   ; objc_msgSend: set
0x00009880  mov      x29, x29
0x00009884  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
