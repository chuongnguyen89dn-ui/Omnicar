; ==== sub_1a8b0 @ 0x1a8b0..0x1b1e4 (2356 bytes) ====
0x0001a8b0  mov      x0, x19
0x0001a8b4  mov      x2, x25
0x0001a8b8  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x0001a8bc  mov      x0, x22
0x0001a8c0  mov      x2, x25
0x0001a8c4  bl       #0x27220   ; objc_msgSend: setLangButton:
0x0001a8c8  adrp     x8, #0x3e000
0x0001a8cc  ldr      x0, [x8, #0x348]   ; -> [class(UIButton)]
0x0001a8d0  mov      x2, #0
0x0001a8d4  bl       #0x25080   ; objc_msgSend: buttonWithType:
0x0001a8d8  mov      x29, x29
0x0001a8dc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a8e0  mov      x26, x0
0x0001a8e4  adrp     x8, #0x3e000
0x0001a8e8  ldr      x0, [x8, #0x3e8]   ; -> [class(UIImageSymbolConfiguration)]
0x0001a8ec  fmov     d0, #16.00000000
0x0001a8f0  mov      w2, #5
0x0001a8f4  bl       #0x25300   ; objc_msgSend: configurationWithPointSize:weight:
0x0001a8f8  mov      x29, x29
0x0001a8fc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a900  mov      x27, x0
0x0001a904  adrp     x8, #0x3e000
0x0001a908  ldr      x0, [x8, #0x3f0]   ; -> [class(UIImage)]
0x0001a90c  adrp     x2, #0x36000
0x0001a910  add      x2, x2, #0xcd0   ; -> @"keyboard.chevron.compact.down"
0x0001a914  mov      x3, x27
0x0001a918  bl       #0x27ea0   ; objc_msgSend: systemImageNamed:withConfiguration:
0x0001a91c  mov      x29, x29
0x0001a920  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a924  mov      x28, x0
0x0001a928  mov      x0, x26
0x0001a92c  mov      x2, x28
0x0001a930  mov      x3, #0
0x0001a934  bl       #0x27160   ; objc_msgSend: setImage:forState:
0x0001a938  mov      x0, x28
0x0001a93c  bl       #0x2480c   ; call _objc_release
0x0001a940  adrp     x8, #0x3e000
0x0001a944  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x0001a948  fmov     d3, #1.00000000
0x0001a94c  mov      v0.16b, v8.16b
0x0001a950  mov      v1.16b, v9.16b
0x0001a954  mov      v2.16b, v10.16b
0x0001a958  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001a95c  mov      x29, x29
0x0001a960  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001a964  mov      x28, x0
0x0001a968  mov      x0, x26
0x0001a96c  mov      x2, x28
0x0001a970  bl       #0x27940   ; objc_msgSend: setTintColor:
0x0001a974  mov      x0, x28
0x0001a978  bl       #0x2480c   ; call _objc_release
0x0001a97c  adrp     x8, #0x3d000
0x0001a980  ldr      x3, [x8, #0x2b0]   ; -> [@selector(hideTapped)]
0x0001a984  mov      x0, x26
0x0001a988  mov      x2, x22
0x0001a98c  mov      w4, #0x40
0x0001a990  bl       #0x24bc0   ; objc_msgSend: addTarget:action:forControlEvents:
0x0001a994  mov      x0, x19
0x0001a998  mov      x2, x26
0x0001a99c  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x0001a9a0  mov      x0, x22
0x0001a9a4  mov      x2, x26
0x0001a9a8  bl       #0x270c0   ; objc_msgSend: setHideButton:
0x0001a9ac  adrp     x8, #0x3e000
0x0001a9b0  ldr      x0, [x8, #0x2d0]   ; -> [class(UIView)]
0x0001a9b4  bl       #0x247e8   ; call _objc_opt_new
0x0001a9b8  mov      x28, x0
0x0001a9bc  mov      x0, x19
0x0001a9c0  mov      x2, x28
0x0001a9c4  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x0001a9c8  mov      x0, x22
0x0001a9cc  mov      x2, x28
0x0001a9d0  bl       #0x271c0   ; objc_msgSend: setKeysView:
0x0001a9d4  mov      x0, x22
0x0001a9d8  mov      x2, x19
0x0001a9dc  bl       #0x27480   ; objc_msgSend: setPanel:
0x0001a9e0  mov      x0, x28
0x0001a9e4  bl       #0x2480c   ; call _objc_release
0x0001a9e8  mov      x0, x27
0x0001a9ec  bl       #0x2480c   ; call _objc_release
0x0001a9f0  mov      x0, x26
0x0001a9f4  bl       #0x2480c   ; call _objc_release
0x0001a9f8  mov      x0, x25
0x0001a9fc  bl       #0x2480c   ; call _objc_release
0x0001aa00  mov      x0, x24
0x0001aa04  bl       #0x2480c   ; call _objc_release
0x0001aa08  mov      x0, x23
0x0001aa0c  bl       #0x2480c   ; call _objc_release
0x0001aa10  ldr      x0, [sp, #8]
0x0001aa14  bl       #0x2480c   ; call _objc_release
0x0001aa18  mov      x0, x20
0x0001aa1c  bl       #0x2480c   ; call _objc_release
0x0001aa20  mov      x0, x19
0x0001aa24  ldp      x29, x30, [sp, #0x80]
0x0001aa28  ldp      x20, x19, [sp, #0x70]
0x0001aa2c  ldp      x22, x21, [sp, #0x60]
0x0001aa30  ldp      x24, x23, [sp, #0x50]
0x0001aa34  ldp      x26, x25, [sp, #0x40]
0x0001aa38  ldp      x28, x27, [sp, #0x30]
0x0001aa3c  ldp      d9, d8, [sp, #0x20]
0x0001aa40  ldp      d11, d10, [sp, #0x10]
0x0001aa44  add      sp, sp, #0x90
0x0001aa48  b        #0x2480c   ; call _objc_release
0x0001aa4c  b        #0x1ab44   ; call sub_1ab44
0x0001aa50  b        #0x1ab2c   ; call sub_1ab2c
0x0001aa54  b        #0x1ab2c   ; call sub_1ab2c
0x0001aa58  b        #0x1aa78   ; call sub_1aa78
0x0001aa5c  b        #0x1ab6c   ; call sub_1ab6c
0x0001aa60  b        #0x1aa78   ; call sub_1aa78
0x0001aa64  b        #0x1ab2c   ; call sub_1ab2c
0x0001aa68  b        #0x1aa78   ; call sub_1aa78
0x0001aa6c  b        #0x1aa78   ; call sub_1aa78
0x0001aa70  b        #0x1aa78   ; call sub_1aa78
0x0001aa74  b        #0x1ab44   ; call sub_1ab44
0x0001aa78  mov      x22, x0
0x0001aa7c  b        #0x1ab50   ; call sub_1ab50
0x0001aa80  b        #0x1ab3c   ; call sub_1ab3c
0x0001aa84  b        #0x1ab6c   ; call sub_1ab6c
0x0001aa88  b        #0x1ab64   ; call sub_1ab64
0x0001aa8c  b        #0x1ab6c   ; call sub_1ab6c
0x0001aa90  b        #0x1ab3c   ; call sub_1ab3c
0x0001aa94  b        #0x1aaa4   ; call sub_1aaa4
0x0001aa98  b        #0x1aaa4   ; call sub_1aaa4
0x0001aa9c  b        #0x1aaa4   ; call sub_1aaa4
0x0001aaa0  b        #0x1aba8   ; call sub_1aba8
0x0001aaa4  mov      x22, x0
0x0001aaa8  mov      x0, x25
0x0001aaac  b        #0x1ab7c   ; call sub_1ab7c
0x0001aab0  b        #0x1ab64   ; call sub_1ab64
0x0001aab4  b        #0x1ab64   ; call sub_1ab64
0x0001aab8  b        #0x1ab64   ; call sub_1ab64
0x0001aabc  b        #0x1ab64   ; call sub_1ab64
0x0001aac0  mov      x22, x0
0x0001aac4  mov      x0, x23
0x0001aac8  b        #0x1ab8c   ; call sub_1ab8c
0x0001aacc  mov      x22, x0
0x0001aad0  mov      x0, x23
0x0001aad4  bl       #0x2480c   ; call _objc_release
0x0001aad8  b        #0x1ab00   ; call sub_1ab00
0x0001aadc  b        #0x1aafc   ; call sub_1aafc
0x0001aae0  b        #0x1ab24   ; call sub_1ab24
0x0001aae4  mov      x22, x0
0x0001aae8  mov      x0, x21
0x0001aaec  b        #0x1ab94   ; call sub_1ab94
0x0001aaf0  b        #0x1ab24   ; call sub_1ab24
0x0001aaf4  b        #0x1ab24   ; call sub_1ab24
0x0001aaf8  b        #0x1ab24   ; call sub_1ab24
0x0001aafc  mov      x22, x0
0x0001ab00  mov      x0, x21
0x0001ab04  b        #0x1ab8c   ; call sub_1ab8c
0x0001ab08  b        #0x1ab24   ; call sub_1ab24
0x0001ab0c  b        #0x1ab44   ; call sub_1ab44
0x0001ab10  b        #0x1ab3c   ; call sub_1ab3c
0x0001ab14  b        #0x1ab64   ; call sub_1ab64
0x0001ab18  b        #0x1ab64   ; call sub_1ab64
0x0001ab1c  b        #0x1ab24   ; call sub_1ab24
0x0001ab20  b        #0x1ab5c   ; call sub_1ab5c
0x0001ab24  mov      x22, x0
0x0001ab28  b        #0x1ab90   ; call sub_1ab90
0x0001ab2c  mov      x22, x0
0x0001ab30  mov      x0, x28
0x0001ab34  bl       #0x2480c   ; call _objc_release
0x0001ab38  b        #0x1ab48   ; call sub_1ab48
0x0001ab3c  mov      x22, x0
0x0001ab40  b        #0x1ab78   ; call sub_1ab78
0x0001ab44  mov      x22, x0
0x0001ab48  mov      x0, x27
0x0001ab4c  bl       #0x2480c   ; call _objc_release
0x0001ab50  mov      x0, x26
0x0001ab54  bl       #0x2480c   ; call _objc_release
0x0001ab58  b        #0x1ab70   ; call sub_1ab70
0x0001ab5c  mov      x22, x0
0x0001ab60  b        #0x1ab98   ; call sub_1ab98
0x0001ab64  mov      x22, x0
0x0001ab68  b        #0x1ab80   ; call sub_1ab80
0x0001ab6c  mov      x22, x0
0x0001ab70  mov      x0, x25
0x0001ab74  bl       #0x2480c   ; call _objc_release
0x0001ab78  mov      x0, x24
0x0001ab7c  bl       #0x2480c   ; call _objc_release
0x0001ab80  mov      x0, x23
0x0001ab84  bl       #0x2480c   ; call _objc_release
0x0001ab88  ldr      x0, [sp, #8]
0x0001ab8c  bl       #0x2480c   ; call _objc_release
0x0001ab90  mov      x0, x20
0x0001ab94  bl       #0x2480c   ; call _objc_release
0x0001ab98  mov      x0, x19
0x0001ab9c  bl       #0x2480c   ; call _objc_release
0x0001aba0  mov      x0, x22
0x0001aba4  bl       #0x24470   ; call __Unwind_Resume
0x0001aba8  mov      x22, x0
0x0001abac  b        #0x1ab88   ; call sub_1ab88
0x0001abb0  sub      sp, sp, #0x90
0x0001abb4  stp      d9, d8, [sp, #0x20]
0x0001abb8  stp      x28, x27, [sp, #0x30]
0x0001abbc  stp      x26, x25, [sp, #0x40]
0x0001abc0  stp      x24, x23, [sp, #0x50]
0x0001abc4  stp      x22, x21, [sp, #0x60]
0x0001abc8  stp      x20, x19, [sp, #0x70]
0x0001abcc  stp      x29, x30, [sp, #0x80]
0x0001abd0  add      x29, sp, #0x80
0x0001abd4  mov      v8.16b, v0.16b
0x0001abd8  mov      x22, x5
0x0001abdc  mov      x20, x4
0x0001abe0  mov      x19, x3
0x0001abe4  str      x2, [sp]
0x0001abe8  str      x0, [sp, #0x10]
0x0001abec  mov      x0, x2
0x0001abf0  bl       #0x24818   ; call _objc_retain
0x0001abf4  str      x19, [sp, #0x18]
0x0001abf8  mov      x0, x19
0x0001abfc  bl       #0x24818   ; call _objc_retain
0x0001ac00  mov      x0, x20
0x0001ac04  bl       #0x24818   ; call _objc_retain
0x0001ac08  mov      x0, x22
0x0001ac0c  bl       #0x24818   ; call _objc_retain
0x0001ac10  adrp     x8, #0x3e000
0x0001ac14  ldr      x0, [x8, #0x3f8]   ; -> [class(ABKey)]
0x0001ac18  mov      x2, #0
0x0001ac1c  str      x20, [sp, #8]
0x0001ac20  bl       #0x25080   ; objc_msgSend: buttonWithType:
0x0001ac24  mov      x29, x29
0x0001ac28  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ac2c  mov      x23, x0
0x0001ac30  mov      x2, x20
0x0001ac34  bl       #0x27a00   ; objc_msgSend: setValue:
0x0001ac38  mov      x0, x23
0x0001ac3c  mov      x2, x22
0x0001ac40  bl       #0x26dc0   ; objc_msgSend: setCommand:
0x0001ac44  mov      x0, x23
0x0001ac48  mov      v0.16b, v8.16b
0x0001ac4c  bl       #0x27a60   ; objc_msgSend: setWeight:
0x0001ac50  adrp     x2, #0x36000
0x0001ac54  add      x2, x2, #0xcf0   ; -> @"space"
0x0001ac58  mov      x0, x22
0x0001ac5c  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001ac60  mov      x25, x0
0x0001ac64  adrp     x2, #0x36000
0x0001ac68  add      x2, x2, #0xd10   ; -> @"ret"
0x0001ac6c  mov      x0, x22
0x0001ac70  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001ac74  mov      x27, x0
0x0001ac78  cmp      x22, #0
0x0001ac7c  cset     w8, eq
0x0001ac80  orr      w8, w8, w25
0x0001ac84  orr      w24, w8, w0
0x0001ac88  adrp     x19, #0x3e000
0x0001ac8c  cbz      x22, #0x1accc
0x0001ac90  tbz      w24, #0, #0x1acec
0x0001ac94  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x0001ac98  adrp     x8, #0x2b000
0x0001ac9c  ldr      d3, [x8, #0x208]
0x0001aca0  fmov     d0, #1.00000000
0x0001aca4  fmov     d1, #1.00000000
0x0001aca8  fmov     d2, #1.00000000
0x0001acac  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001acb0  mov      x29, x29
0x0001acb4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001acb8  mov      x28, x0
0x0001acbc  mov      w26, #0
0x0001acc0  mov      w21, #0
0x0001acc4  mov      w20, #1
0x0001acc8  b        #0x1ad70   ; call sub_1ad70
0x0001accc  adrp     x2, #0x36000
0x0001acd0  add      x2, x2, #0xd30   ; -> @","
0x0001acd4  mov      x0, x20
0x0001acd8  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001acdc  tbz      w0, #0, #0x1acf4
0x0001ace0  tbnz     w24, #0, #0x1ad10
0x0001ace4  mov      w26, #1
0x0001ace8  b        #0x1ad44   ; call sub_1ad44
0x0001acec  mov      w26, #0
0x0001acf0  b        #0x1ad44   ; call sub_1ad44
0x0001acf4  adrp     x2, #0x36000
0x0001acf8  add      x2, x2, #0xd50   ; -> @"."
0x0001acfc  ldr      x0, [sp, #8]
0x0001ad00  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001ad04  mov      x26, x0
0x0001ad08  tbz      w24, #0, #0x1ad44
0x0001ad0c  cbz      w26, #0x1ac94
0x0001ad10  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x0001ad14  fmov     d0, #1.00000000
0x0001ad18  fmov     d1, #1.00000000
0x0001ad1c  fmov     d2, #1.00000000
0x0001ad20  fmov     d3, #0.50000000
0x0001ad24  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001ad28  mov      x29, x29
0x0001ad2c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ad30  mov      x28, x0
0x0001ad34  mov      w20, #0
0x0001ad38  mov      w26, #1
0x0001ad3c  mov      w21, #1
0x0001ad40  b        #0x1ad70   ; call sub_1ad70
0x0001ad44  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x0001ad48  fmov     d0, #1.00000000
0x0001ad4c  fmov     d1, #1.00000000
0x0001ad50  fmov     d2, #1.00000000
0x0001ad54  fmov     d3, #0.50000000
0x0001ad58  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001ad5c  mov      x29, x29
0x0001ad60  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ad64  mov      x28, x0
0x0001ad68  mov      w20, #0
0x0001ad6c  mov      w21, #0
0x0001ad70  mov      x0, x23
0x0001ad74  mov      x2, x28
0x0001ad78  bl       #0x275e0   ; objc_msgSend: setRestColor:
0x0001ad7c  cbz      w20, #0x1ada8
0x0001ad80  mov      x0, x28
0x0001ad84  bl       #0x2480c   ; call _objc_release
0x0001ad88  cbnz     w21, #0x1adac
0x0001ad8c  tbnz     w24, #0, #0x1ad98
0x0001ad90  mov      x0, x28
0x0001ad94  bl       #0x2480c   ; call _objc_release
0x0001ad98  ldr      x21, [sp]
0x0001ad9c  tbz      w27, #0, #0x1adbc
0x0001ada0  mov      w2, #1
0x0001ada4  b        #0x1ade4   ; call sub_1ade4
0x0001ada8  cbz      w21, #0x1ad8c
0x0001adac  mov      x0, x28
0x0001adb0  bl       #0x2480c   ; call _objc_release
0x0001adb4  tbz      w24, #0, #0x1ad90
0x0001adb8  b        #0x1ad98   ; call sub_1ad98
0x0001adbc  adrp     x2, #0x36000
0x0001adc0  add      x2, x2, #0xd70   ; -> @"shift"
0x0001adc4  mov      x0, x22
0x0001adc8  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x0001adcc  cbz      w0, #0x1ade0
0x0001add0  ldr      x0, [sp, #0x10]
0x0001add4  bl       #0x27ba0   ; objc_msgSend: shift
0x0001add8  mov      x2, x0
0x0001addc  b        #0x1ade4   ; call sub_1ade4
0x0001ade0  mov      w2, #0
0x0001ade4  mov      x0, x23
0x0001ade8  bl       #0x272e0   ; objc_msgSend: setLit:
0x0001adec  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x0001adf0  tbz      w24, #0, #0x1ae20
0x0001adf4  adrp     x8, #0x2b000
0x0001adf8  ldr      d0, [x8, #0x218]
0x0001adfc  adrp     x8, #0x2b000
0x0001ae00  ldr      d1, [x8, #0x220]
0x0001ae04  adrp     x8, #0x2b000
0x0001ae08  ldr      d2, [x8, #0x228]
0x0001ae0c  fmov     d3, #1.00000000
0x0001ae10  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001ae14  mov      x29, x29
0x0001ae18  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ae1c  b        #0x1ae48   ; call sub_1ae48
0x0001ae20  adrp     x8, #0x2b000
0x0001ae24  ldr      d0, [x8, #0x218]
0x0001ae28  adrp     x8, #0x2b000
0x0001ae2c  ldr      d1, [x8, #0x220]
0x0001ae30  adrp     x8, #0x2b000
0x0001ae34  ldr      d2, [x8, #0x228]
0x0001ae38  fmov     d3, #1.00000000
0x0001ae3c  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001ae40  mov      x29, x29
0x0001ae44  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ae48  mov      x27, x0
0x0001ae4c  mov      x0, x23
0x0001ae50  mov      x2, x27
0x0001ae54  bl       #0x27600   ; objc_msgSend: setRestTint:
0x0001ae58  tst      w24, #1
0x0001ae5c  csel     x0, x27, x27, ne
0x0001ae60  bl       #0x2480c   ; call _objc_release
0x0001ae64  mov      x0, x23
0x0001ae68  bl       #0x25f00   ; objc_msgSend: layer
0x0001ae6c  mov      x29, x29
0x0001ae70  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ae74  mov      x27, x0
0x0001ae78  fmov     d0, #7.00000000
0x0001ae7c  bl       #0x26e20   ; objc_msgSend: setCornerRadius:
0x0001ae80  mov      x0, x27
0x0001ae84  bl       #0x2480c   ; call _objc_release
0x0001ae88  mov      x0, x23
0x0001ae8c  bl       #0x25f00   ; objc_msgSend: layer
0x0001ae90  mov      x29, x29
0x0001ae94  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ae98  mov      x27, x0
0x0001ae9c  adrp     x8, #0x34000
0x0001aea0  ldr      x8, [x8, #0x580]   ; -> [got:_kCACornerCurveContinuous]
0x0001aea4  ldr      x2, [x8]   ; -> [got:___objc_personality_v0]
0x0001aea8  bl       #0x26e00   ; objc_msgSend: setCornerCurve:
0x0001aeac  mov      x0, x27
0x0001aeb0  bl       #0x2480c   ; call _objc_release
0x0001aeb4  mov      x0, x23
0x0001aeb8  bl       #0x25fe0   ; objc_msgSend: lit
0x0001aebc  tbnz     w0, #0, #0x1b024
0x0001aec0  mov      x0, x23
0x0001aec4  bl       #0x25f00   ; objc_msgSend: layer
0x0001aec8  mov      x29, x29
0x0001aecc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001aed0  mov      x27, x0
0x0001aed4  eor      w8, w24, #1
0x0001aed8  orr      w8, w8, w26
0x0001aedc  and      w8, w8, #1
0x0001aee0  ucvtf    d0, w8
0x0001aee4  bl       #0x26ca0   ; objc_msgSend: setBorderWidth:
0x0001aee8  mov      x0, x27
0x0001aeec  bl       #0x2480c   ; call _objc_release
0x0001aef0  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x0001aef4  adrp     x8, #0x2b000
0x0001aef8  ldr      d1, [x8, #0x208]
0x0001aefc  fmov     d0, #1.00000000
0x0001af00  bl       #0x25240   ; objc_msgSend: colorWithWhite:alpha:
0x0001af04  mov      x29, x29
0x0001af08  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001af0c  mov      x26, x0
0x0001af10  bl       #0x24824   ; call _objc_retainAutorelease
0x0001af14  bl       #0x249e0   ; objc_msgSend: CGColor
0x0001af18  mov      x28, x0
0x0001af1c  mov      x0, x23
0x0001af20  bl       #0x25f00   ; objc_msgSend: layer
0x0001af24  mov      x29, x29
0x0001af28  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001af2c  mov      x27, x0
0x0001af30  mov      x2, x28
0x0001af34  bl       #0x26c80   ; objc_msgSend: setBorderColor:
0x0001af38  mov      x0, x27
0x0001af3c  bl       #0x2480c   ; call _objc_release
0x0001af40  mov      x0, x26
0x0001af44  bl       #0x2480c   ; call _objc_release
0x0001af48  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x0001af4c  adrp     x8, #0x2b000
0x0001af50  ldr      d0, [x8, #0x240]
0x0001af54  adrp     x8, #0x2b000
0x0001af58  ldr      d1, [x8, #0x248]
0x0001af5c  adrp     x8, #0x2b000
0x0001af60  ldr      d2, [x8, #0x250]
0x0001af64  fmov     d3, #1.00000000
0x0001af68  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001af6c  mov      x29, x29
0x0001af70  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001af74  mov      x26, x0
0x0001af78  bl       #0x24824   ; call _objc_retainAutorelease
0x0001af7c  bl       #0x249e0   ; objc_msgSend: CGColor
0x0001af80  mov      x28, x0
0x0001af84  mov      x0, x23
0x0001af88  bl       #0x25f00   ; objc_msgSend: layer
0x0001af8c  mov      x29, x29
0x0001af90  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001af94  mov      x27, x0
0x0001af98  mov      x2, x28
0x0001af9c  bl       #0x276e0   ; objc_msgSend: setShadowColor:
0x0001afa0  mov      x0, x27
0x0001afa4  bl       #0x2480c   ; call _objc_release
0x0001afa8  mov      x0, x26
0x0001afac  bl       #0x2480c   ; call _objc_release
0x0001afb0  mov      x0, x23
0x0001afb4  bl       #0x25f00   ; objc_msgSend: layer
0x0001afb8  mov      x29, x29
0x0001afbc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001afc0  mov      x26, x0
0x0001afc4  adrp     x8, #0x2b000
0x0001afc8  ldr      s0, [x8, #0x400]
0x0001afcc  bl       #0x27720   ; objc_msgSend: setShadowOpacity:
0x0001afd0  mov      x0, x26
0x0001afd4  bl       #0x2480c   ; call _objc_release
0x0001afd8  mov      x0, x23
0x0001afdc  bl       #0x25f00   ; objc_msgSend: layer
0x0001afe0  mov      x29, x29
0x0001afe4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001afe8  mov      x26, x0
0x0001afec  fmov     d0, #1.00000000
0x0001aff0  bl       #0x27760   ; objc_msgSend: setShadowRadius:
0x0001aff4  mov      x0, x26
0x0001aff8  bl       #0x2480c   ; call _objc_release
0x0001affc  mov      x0, x23
0x0001b000  bl       #0x25f00   ; objc_msgSend: layer
0x0001b004  mov      x29, x29
0x0001b008  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b00c  mov      x26, x0
0x0001b010  fmov     d0, xzr
0x0001b014  fmov     d1, #1.00000000
0x0001b018  bl       #0x27700   ; objc_msgSend: setShadowOffset:
0x0001b01c  mov      x0, x26
0x0001b020  bl       #0x2480c   ; call _objc_release
0x0001b024  ldr      x8, [sp, #0x18]
0x0001b028  cbz      x8, #0x1b090
0x0001b02c  adrp     x8, #0x3e000
0x0001b030  ldr      x0, [x8, #0x3e8]   ; -> [class(UIImageSymbolConfiguration)]
0x0001b034  fmov     d0, #15.00000000
0x0001b038  mov      w2, #5
0x0001b03c  bl       #0x25300   ; objc_msgSend: configurationWithPointSize:weight:
0x0001b040  mov      x29, x29
0x0001b044  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b048  mov      x26, x0
0x0001b04c  adrp     x8, #0x3e000
0x0001b050  ldr      x0, [x8, #0x3f0]   ; -> [class(UIImage)]
0x0001b054  ldr      x2, [sp, #0x18]
0x0001b058  mov      x3, x26
0x0001b05c  bl       #0x27ea0   ; objc_msgSend: systemImageNamed:withConfiguration:
0x0001b060  mov      x29, x29
0x0001b064  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b068  mov      x27, x0
0x0001b06c  mov      x0, x23
0x0001b070  mov      x2, x27
0x0001b074  mov      x3, #0
0x0001b078  bl       #0x27160   ; objc_msgSend: setImage:forState:
0x0001b07c  mov      x0, x27
0x0001b080  bl       #0x2480c   ; call _objc_release
0x0001b084  mov      x0, x26
0x0001b088  bl       #0x2480c   ; call _objc_release
0x0001b08c  b        #0x1b0a0   ; call sub_1b0a0
0x0001b090  mov      x0, x23
0x0001b094  mov      x2, x21
0x0001b098  mov      x3, #0
0x0001b09c  bl       #0x27960   ; objc_msgSend: setTitle:forState:
0x0001b0a0  cbz      w25, #0x1b0e4
0x0001b0a4  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x0001b0a8  adrp     x8, #0x2b000
0x0001b0ac  ldr      d0, [x8, #0x218]
0x0001b0b0  adrp     x8, #0x2b000
0x0001b0b4  ldr      d1, [x8, #0x220]
0x0001b0b8  adrp     x8, #0x2b000
0x0001b0bc  ldr      d2, [x8, #0x228]
0x0001b0c0  adrp     x8, #0x2b000
0x0001b0c4  ldr      d3, [x8, #0x2d0]
0x0001b0c8  bl       #0x25220   ; objc_msgSend: colorWithRed:green:blue:alpha:
0x0001b0cc  mov      x29, x29
0x0001b0d0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b0d4  mov      x26, x0
0x0001b0d8  mov      w19, #0
0x0001b0dc  mov      w20, #0
0x0001b0e0  b        #0x1b12c   ; call sub_1b12c
0x0001b0e4  mov      x0, x23
0x0001b0e8  bl       #0x25fe0   ; objc_msgSend: lit
0x0001b0ec  cbz      w0, #0x1b110
0x0001b0f0  ldr      x0, [x19, #0x320]   ; -> [class(UIColor)]
0x0001b0f4  bl       #0x281c0   ; objc_msgSend: whiteColor
0x0001b0f8  mov      x29, x29
0x0001b0fc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b100  mov      x26, x0
0x0001b104  mov      w20, #0
0x0001b108  mov      w19, #1
0x0001b10c  b        #0x1b12c   ; call sub_1b12c
0x0001b110  mov      x0, x23
0x0001b114  bl       #0x26940   ; objc_msgSend: restTint
0x0001b118  mov      x29, x29
0x0001b11c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b120  mov      x26, x0
0x0001b124  mov      w19, #0
0x0001b128  mov      w20, #1
0x0001b12c  mov      x0, x23
0x0001b130  mov      x2, x26
0x0001b134  mov      x3, #0
0x0001b138  bl       #0x27980   ; objc_msgSend: setTitleColor:forState:
0x0001b13c  cbz      w20, #0x1b180
0x0001b140  mov      x0, x26
0x0001b144  bl       #0x2480c   ; call _objc_release
0x0001b148  cbnz     w19, #0x1b184
0x0001b14c  cbz      w25, #0x1b190
0x0001b150  mov      x0, x26
0x0001b154  bl       #0x2480c   ; call _objc_release
0x0001b158  adrp     x8, #0x3e000
0x0001b15c  ldr      x0, [x8, #0x3e0]   ; -> [class(UIFont)]
0x0001b160  fmov     d0, #10.00000000
0x0001b164  bl       #0x27e60   ; objc_msgSend: systemFontOfSize:
0x0001b168  mov      x29, x29
0x0001b16c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b170  mov      x26, x0
0x0001b174  mov      w19, #0
0x0001b178  mov      w24, #0
0x0001b17c  b        #0x1b1e4   ; call sub_1b1e4
0x0001b180  cbz      w19, #0x1b14c
0x0001b184  mov      x0, x26
0x0001b188  bl       #0x2480c   ; call _objc_release
0x0001b18c  cbnz     w25, #0x1b150
0x0001b190  adrp     x8, #0x3e000
0x0001b194  ldr      x0, [x8, #0x3e0]   ; -> [class(UIFont)]
0x0001b198  tbz      w24, #0, #0x1b1bc
0x0001b19c  fmov     d0, #17.00000000
0x0001b1a0  bl       #0x27e60   ; objc_msgSend: systemFontOfSize:
0x0001b1a4  mov      x29, x29
0x0001b1a8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b1ac  mov      x26, x0
0x0001b1b0  mov      w19, #0
0x0001b1b4  mov      w24, #1
0x0001b1b8  b        #0x1b1e4   ; call sub_1b1e4
0x0001b1bc  adrp     x8, #0x34000
0x0001b1c0  ldr      x8, [x8, #0x230]   ; -> [got:_UIFontWeightSemibold]
0x0001b1c4  ldr      d1, [x8]   ; -> [got:___objc_personality_v0]
0x0001b1c8  fmov     d0, #11.00000000
0x0001b1cc  bl       #0x27e80   ; objc_msgSend: systemFontOfSize:weight:
0x0001b1d0  mov      x29, x29
0x0001b1d4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001b1d8  mov      x26, x0
0x0001b1dc  mov      w24, #0
0x0001b1e0  mov      w19, #1
