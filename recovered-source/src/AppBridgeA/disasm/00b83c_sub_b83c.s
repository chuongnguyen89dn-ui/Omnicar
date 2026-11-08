; ==== sub_b83c @ 0xb83c..0xc274 (2616 bytes) ====
0x0000b83c  mov      x0, x20
0x0000b840  bl       #0x2480c   ; call _objc_release
0x0000b844  b        #0xb894   ; call sub_b894
0x0000b848  mov      x23, x0
0x0000b84c  mov      x22, x26
0x0000b850  b        #0xb864   ; call sub_b864
0x0000b854  b        #0xb860   ; call sub_b860
0x0000b858  mov      x23, x0
0x0000b85c  b        #0xb874   ; call sub_b874
0x0000b860  mov      x23, x0
0x0000b864  mov      x0, x22
0x0000b868  bl       #0x2480c   ; call _objc_release
0x0000b86c  mov      x0, x25
0x0000b870  bl       #0x2480c   ; call _objc_release
0x0000b874  mov      x0, x21
0x0000b878  bl       #0x2480c   ; call _objc_release
0x0000b87c  mov      x0, x20
0x0000b880  bl       #0x2480c   ; call _objc_release
0x0000b884  ldr      x0, [sp, #8]
0x0000b888  bl       #0x2480c   ; call _objc_release
0x0000b88c  b        #0xb894   ; call sub_b894
0x0000b890  mov      x23, x0
0x0000b894  mov      x0, x23
0x0000b898  bl       #0x24470   ; call __Unwind_Resume
0x0000b89c  ret      
0x0000b8a0  sub      sp, sp, #0xd0
0x0000b8a4  stp      d11, d10, [sp, #0x60]
0x0000b8a8  stp      d9, d8, [sp, #0x70]
0x0000b8ac  stp      x26, x25, [sp, #0x80]
0x0000b8b0  stp      x24, x23, [sp, #0x90]
0x0000b8b4  stp      x22, x21, [sp, #0xa0]
0x0000b8b8  stp      x20, x19, [sp, #0xb0]
0x0000b8bc  stp      x29, x30, [sp, #0xc0]
0x0000b8c0  add      x29, sp, #0xc0
0x0000b8c4  mov      v8.16b, v3.16b
0x0000b8c8  mov      v9.16b, v2.16b
0x0000b8cc  mov      v10.16b, v1.16b
0x0000b8d0  mov      v11.16b, v0.16b
0x0000b8d4  mov      x19, x2
0x0000b8d8  mov      x22, x0
0x0000b8dc  mov      x0, x2
0x0000b8e0  bl       #0x24818   ; call _objc_retain
0x0000b8e4  mov      x0, x19
0x0000b8e8  bl       #0x25fa0   ; objc_msgSend: length
0x0000b8ec  cbz      x0, #0xbccc
0x0000b8f0  adrp     x0, #0x35000
0x0000b8f4  add      x0, x0, #0xad0   ; -> @"appBridge"
0x0000b8f8  bl       #0x1d744   ; call _OMCFeatureEnabled
0x0000b8fc  tbz      w0, #0, #0xb96c
0x0000b900  mov      x0, x22
0x0000b904  mov      x2, x19
0x0000b908  bl       #0x26520   ; objc_msgSend: paneFor:
0x0000b90c  mov      x29, x29
0x0000b910  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b914  mov      x20, x0
0x0000b918  cbz      x0, #0xb9bc
0x0000b91c  mov      x0, x20
0x0000b920  bl       #0x24f60   ; objc_msgSend: box
0x0000b924  mov      x29, x29
0x0000b928  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b92c  mov      x21, x0
0x0000b930  bl       #0x265a0   ; objc_msgSend: passInsets
0x0000b934  mov      v4.16b, v0.16b
0x0000b938  mov      v5.16b, v1.16b
0x0000b93c  mov      v6.16b, v2.16b
0x0000b940  mov      v7.16b, v3.16b
0x0000b944  mov      v0.16b, v11.16b
0x0000b948  mov      x0, x22
0x0000b94c  mov      v1.16b, v10.16b
0x0000b950  mov      v2.16b, v9.16b
0x0000b954  mov      v3.16b, v8.16b
0x0000b958  mov      x2, x19
0x0000b95c  mov      w3, #0
0x0000b960  mov      w4, #1
0x0000b964  bl       #0x26fa0   ; objc_msgSend: setFrame:forApp:live:handle:passInsets:
0x0000b968  b        #0xbcbc   ; call sub_bcbc
0x0000b96c  adrp     x8, #0x3e000
0x0000b970  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x0000b974  str      x19, [sp]
0x0000b978  adrp     x2, #0x35000
0x0000b97c  add      x2, x2, #0xaf0   ; -> @"tat trong Cai dat -> khong host %@"
0x0000b980  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000b984  mov      x29, x29
0x0000b988  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000b98c  mov      x20, x0
0x0000b990  adrp     x0, #0x34000
0x0000b994  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000b998  mov      x1, x20
0x0000b99c  bl       #0x1dd30   ; call _OMCLogWrite
0x0000b9a0  mov      x0, x20
0x0000b9a4  bl       #0x2480c   ; call _objc_release
0x0000b9a8  adrp     x1, #0x35000
0x0000b9ac  add      x1, x1, #0xb10   ; -> @"failed"
0x0000b9b0  mov      x0, x19
0x0000b9b4  bl       #0xbed4   ; call sub_bed4
0x0000b9b8  b        #0xbccc   ; call sub_bccc
0x0000b9bc  mov      x0, x22
0x0000b9c0  bl       #0x256c0   ; objc_msgSend: ensureWindow
0x0000b9c4  tbz      w0, #0, #0xbcf8
0x0000b9c8  adrp     x8, #0x3e000
0x0000b9cc  ldr      x0, [x8, #0x328]   ; -> [class(ABPane)]
0x0000b9d0  bl       #0x247e8   ; call _objc_opt_new
0x0000b9d4  mov      x21, x0
0x0000b9d8  mov      x2, x19
0x0000b9dc  bl       #0x26d20   ; objc_msgSend: setBundleID:
0x0000b9e0  mov      x0, x21
0x0000b9e4  mov      v0.16b, v11.16b
0x0000b9e8  mov      v1.16b, v10.16b
0x0000b9ec  mov      v2.16b, v9.16b
0x0000b9f0  mov      v3.16b, v8.16b
0x0000b9f4  bl       #0x26f80   ; objc_msgSend: setFrame:
0x0000b9f8  bl       #0x1d674   ; call _OMCPrefsSync
0x0000b9fc  adrp     x0, #0x35000
0x0000ba00  add      x0, x0, #0xb50   ; -> @"appBridgeOrientation"
0x0000ba04  adrp     x1, #0x39000
0x0000ba08  add      x1, x1, #0x5b8
0x0000ba0c  bl       #0x1d680   ; call _OMCPref
0x0000ba10  mov      x29, x29
0x0000ba14  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ba18  mov      x24, x0
0x0000ba1c  bl       #0x26040   ; objc_msgSend: longLongValue
0x0000ba20  mov      x23, x0
0x0000ba24  mov      x0, x24
0x0000ba28  bl       #0x2480c   ; call _objc_release
0x0000ba2c  sub      x8, x23, #3
0x0000ba30  cmp      x8, #2
0x0000ba34  csinc    x2, x23, xzr, lo
0x0000ba38  mov      x0, x21
0x0000ba3c  bl       #0x27460   ; objc_msgSend: setOrientation:
0x0000ba40  adrp     x8, #0x3e000
0x0000ba44  ldr      x0, [x8, #0x330]   ; -> [class(ABBoxView)]
0x0000ba48  bl       #0x2471c   ; call _objc_alloc
0x0000ba4c  mov      v0.16b, v11.16b
0x0000ba50  mov      v1.16b, v10.16b
0x0000ba54  mov      v2.16b, v9.16b
0x0000ba58  mov      v3.16b, v8.16b
0x0000ba5c  bl       #0x25a40   ; objc_msgSend: initWithFrame:
0x0000ba60  mov      x24, x0
0x0000ba64  mov      x0, x21
0x0000ba68  mov      x2, x24
0x0000ba6c  bl       #0x26ce0   ; objc_msgSend: setBox:
0x0000ba70  mov      x0, x24
0x0000ba74  bl       #0x2480c   ; call _objc_release
0x0000ba78  adrp     x8, #0x3e000
0x0000ba7c  ldr      x0, [x8, #0x320]   ; -> [class(UIColor)]
0x0000ba80  bl       #0x24f00   ; objc_msgSend: blackColor
0x0000ba84  mov      x29, x29
0x0000ba88  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000ba8c  mov      x24, x0
0x0000ba90  mov      x0, x21
0x0000ba94  bl       #0x24f60   ; objc_msgSend: box
0x0000ba98  mov      x29, x29
0x0000ba9c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000baa0  mov      x25, x0
0x0000baa4  mov      x2, x24
0x0000baa8  bl       #0x26c20   ; objc_msgSend: setBackgroundColor:
0x0000baac  mov      x0, x25
0x0000bab0  bl       #0x2480c   ; call _objc_release
0x0000bab4  mov      x0, x24
0x0000bab8  bl       #0x2480c   ; call _objc_release
0x0000babc  mov      x0, x21
0x0000bac0  bl       #0x24f60   ; objc_msgSend: box
0x0000bac4  mov      x29, x29
0x0000bac8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000bacc  mov      x24, x0
0x0000bad0  mov      w2, #1
0x0000bad4  bl       #0x26d80   ; objc_msgSend: setClipsToBounds:
0x0000bad8  mov      x0, x24
0x0000badc  bl       #0x2480c   ; call _objc_release
0x0000bae0  mov      x0, x21
0x0000bae4  bl       #0x24f60   ; objc_msgSend: box
0x0000bae8  mov      x29, x29
0x0000baec  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000baf0  mov      x24, x0
0x0000baf4  fmov     d0, xzr
0x0000baf8  bl       #0x26b40   ; objc_msgSend: setAlpha:
0x0000bafc  mov      x0, x24
0x0000bb00  bl       #0x2480c   ; call _objc_release
0x0000bb04  mov      x0, x22
0x0000bb08  bl       #0x281e0   ; objc_msgSend: window
0x0000bb0c  mov      x29, x29
0x0000bb10  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000bb14  mov      x24, x0
0x0000bb18  mov      x0, x21
0x0000bb1c  bl       #0x24f60   ; objc_msgSend: box
0x0000bb20  mov      x29, x29
0x0000bb24  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000bb28  mov      x25, x0
0x0000bb2c  mov      x0, x24
0x0000bb30  mov      x2, x25
0x0000bb34  bl       #0x24ba0   ; objc_msgSend: addSubview:
0x0000bb38  mov      x0, x25
0x0000bb3c  bl       #0x2480c   ; call _objc_release
0x0000bb40  mov      x0, x24
0x0000bb44  bl       #0x2480c   ; call _objc_release
0x0000bb48  mov      x0, x22
0x0000bb4c  bl       #0x27b80   ; objc_msgSend: shieldOn
0x0000bb50  cbz      w0, #0xbb64
0x0000bb54  mov      x0, x22
0x0000bb58  mov      w2, #1
0x0000bb5c  mov      x3, x21
0x0000bb60  bl       #0x277a0   ; objc_msgSend: setShield:forPane:
0x0000bb64  mov      x0, x22
0x0000bb68  bl       #0x26720   ; objc_msgSend: raiseKnobs
0x0000bb6c  mov      x0, x22
0x0000bb70  mov      x2, x21
0x0000bb74  bl       #0x27ae0   ; objc_msgSend: setupHandleForPane:
0x0000bb78  mov      x0, x22
0x0000bb7c  bl       #0x26580   ; objc_msgSend: panes
0x0000bb80  mov      x29, x29
0x0000bb84  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000bb88  mov      x24, x0
0x0000bb8c  mov      x2, x21
0x0000bb90  bl       #0x24b20   ; objc_msgSend: addObject:
0x0000bb94  mov      x0, x24
0x0000bb98  bl       #0x2480c   ; call _objc_release
0x0000bb9c  mov      x0, x22
0x0000bba0  mov      x2, x21
0x0000bba4  bl       #0x27b00   ; objc_msgSend: setupLiveAppViewForPane:
0x0000bba8  mov      x0, x22
0x0000bbac  mov      x2, x21
0x0000bbb0  bl       #0x25f60   ; objc_msgSend: layoutPane:
0x0000bbb4  adrp     x8, #0x3e000
0x0000bbb8  ldr      x23, [x8, #0x290]   ; -> [class(NSString)]
0x0000bbbc  mov      v0.16b, v11.16b
0x0000bbc0  mov      v1.16b, v10.16b
0x0000bbc4  mov      v2.16b, v9.16b
0x0000bbc8  mov      v3.16b, v8.16b
0x0000bbcc  bl       #0x24440   ; call _NSStringFromCGRect
0x0000bbd0  mov      x29, x29
0x0000bbd4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000bbd8  mov      x24, x0
0x0000bbdc  mov      x0, x21
0x0000bbe0  bl       #0x264c0   ; objc_msgSend: orientation
0x0000bbe4  mov      x25, x0
0x0000bbe8  mov      x0, x22
0x0000bbec  bl       #0x28260   ; objc_msgSend: zoom
0x0000bbf0  str      d0, [sp, #0x18]
0x0000bbf4  stp      x24, x25, [sp, #8]
0x0000bbf8  str      x19, [sp]
0x0000bbfc  adrp     x2, #0x35000
0x0000bc00  add      x2, x2, #0xb90   ; -> @"host %@ tai %@ (huong %lld, zoom %.2f)"
0x0000bc04  mov      x0, x23
0x0000bc08  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000bc0c  mov      x29, x29
0x0000bc10  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000bc14  mov      x23, x0
0x0000bc18  adrp     x0, #0x34000
0x0000bc1c  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000bc20  mov      x1, x23
0x0000bc24  bl       #0x1dd30   ; call _OMCLogWrite
0x0000bc28  mov      x0, x23
0x0000bc2c  bl       #0x2480c   ; call _objc_release
0x0000bc30  mov      x0, x24
0x0000bc34  bl       #0x2480c   ; call _objc_release
0x0000bc38  add      x0, sp, #0x58
0x0000bc3c  mov      x1, x21
0x0000bc40  bl       #0x24794   ; call _objc_initWeak
0x0000bc44  mov      x0, #0
0x0000bc48  mov      w1, #0xf900
0x0000bc4c  movk     w1, #0x9502, lsl #16
0x0000bc50  bl       #0x245cc   ; call _dispatch_time
0x0000bc54  mov      x23, x0
0x0000bc58  adrp     x8, #0x34000
0x0000bc5c  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x0000bc60  str      x8, [sp, #0x28]
0x0000bc64  adrp     x8, #0x2b000
0x0000bc68  ldr      d0, [x8, #0x1d0]
0x0000bc6c  adrp     x8, #0xc000
0x0000bc70  add      x8, x8, #0x18
0x0000bc74  str      d0, [sp, #0x30]
0x0000bc78  adrp     x9, #0x34000
0x0000bc7c  add      x9, x9, #0x860
0x0000bc80  stp      x8, x9, [sp, #0x38]
0x0000bc84  add      x24, sp, #0x28
0x0000bc88  add      x0, x24, #0x28
0x0000bc8c  add      x1, sp, #0x58
0x0000bc90  bl       #0x2474c   ; call _objc_copyWeak
0x0000bc94  str      x22, [sp, #0x48]
0x0000bc98  adrp     x1, #0x34000
0x0000bc9c  ldr      x1, [x1, #0x290]   ; -> [got:__dispatch_main_q]
0x0000bca0  add      x2, sp, #0x28
0x0000bca4  mov      x0, x23
0x0000bca8  bl       #0x24548   ; call _dispatch_after
0x0000bcac  add      x0, x24, #0x28
0x0000bcb0  bl       #0x24758   ; call _objc_destroyWeak
0x0000bcb4  add      x0, sp, #0x58
0x0000bcb8  bl       #0x24758   ; call _objc_destroyWeak
0x0000bcbc  mov      x0, x21
0x0000bcc0  bl       #0x2480c   ; call _objc_release
0x0000bcc4  mov      x0, x20
0x0000bcc8  bl       #0x2480c   ; call _objc_release
0x0000bccc  mov      x0, x19
0x0000bcd0  bl       #0x2480c   ; call _objc_release
0x0000bcd4  ldp      x29, x30, [sp, #0xc0]
0x0000bcd8  ldp      x20, x19, [sp, #0xb0]
0x0000bcdc  ldp      x22, x21, [sp, #0xa0]
0x0000bce0  ldp      x24, x23, [sp, #0x90]
0x0000bce4  ldp      x26, x25, [sp, #0x80]
0x0000bce8  ldp      d9, d8, [sp, #0x70]
0x0000bcec  ldp      d11, d10, [sp, #0x60]
0x0000bcf0  add      sp, sp, #0xd0
0x0000bcf4  ret      
0x0000bcf8  adrp     x8, #0x3e000
0x0000bcfc  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x0000bd00  str      x19, [sp]
0x0000bd04  adrp     x2, #0x35000
0x0000bd08  add      x2, x2, #0xb30   ; -> @"xe chua ket noi -> khong host %@"
0x0000bd0c  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000bd10  mov      x29, x29
0x0000bd14  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000bd18  mov      x21, x0
0x0000bd1c  adrp     x0, #0x34000
0x0000bd20  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000bd24  mov      x1, x21
0x0000bd28  bl       #0x1dd30   ; call _OMCLogWrite
0x0000bd2c  mov      x0, x21
0x0000bd30  bl       #0x2480c   ; call _objc_release
0x0000bd34  adrp     x1, #0x35000
0x0000bd38  add      x1, x1, #0xb10   ; -> @"failed"
0x0000bd3c  mov      x0, x19
0x0000bd40  bl       #0xbed4   ; call sub_bed4
0x0000bd44  b        #0xbcc4   ; call sub_bcc4
0x0000bd48  mov      x1, x23
0x0000bd4c  mov      x23, x0
0x0000bd50  mov      x0, x1
0x0000bd54  b        #0xbe64   ; call sub_be64
0x0000bd58  mov      x23, x0
0x0000bd5c  cmp      w1, #1
0x0000bd60  b.ne     #0xbeac
0x0000bd64  mov      x0, x23
0x0000bd68  bl       #0x24740   ; call _objc_begin_catch
0x0000bd6c  mov      x24, x0
0x0000bd70  bl       #0x24818   ; call _objc_retain
0x0000bd74  adrp     x8, #0x3e000
0x0000bd78  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x0000bd7c  stp      x19, x24, [sp]
0x0000bd80  adrp     x2, #0x35000
0x0000bd84  add      x2, x2, #0xb70   ; -> @"host %@ that bai: %@"
0x0000bd88  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000bd8c  mov      x29, x29
0x0000bd90  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000bd94  mov      x25, x0
0x0000bd98  adrp     x0, #0x34000
0x0000bd9c  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000bda0  mov      x1, x25
0x0000bda4  bl       #0x1dd30   ; call _OMCLogWrite
0x0000bda8  mov      x0, x25
0x0000bdac  bl       #0x2480c   ; call _objc_release
0x0000bdb0  mov      x0, x22
0x0000bdb4  bl       #0x26580   ; objc_msgSend: panes
0x0000bdb8  mov      x29, x29
0x0000bdbc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000bdc0  mov      x25, x0
0x0000bdc4  mov      x2, x21
0x0000bdc8  bl       #0x268a0   ; objc_msgSend: removeObject:
0x0000bdcc  mov      x0, x25
0x0000bdd0  bl       #0x2480c   ; call _objc_release
0x0000bdd4  mov      x0, x21
0x0000bdd8  bl       #0x24f60   ; objc_msgSend: box
0x0000bddc  mov      x29, x29
0x0000bde0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000bde4  mov      x25, x0
0x0000bde8  bl       #0x26840   ; objc_msgSend: removeFromSuperview
0x0000bdec  mov      x0, x25
0x0000bdf0  bl       #0x2480c   ; call _objc_release
0x0000bdf4  mov      x0, x22
0x0000bdf8  bl       #0x25660   ; objc_msgSend: dropWindowIfEmpty
0x0000bdfc  adrp     x1, #0x35000
0x0000be00  add      x1, x1, #0xb10   ; -> @"failed"
0x0000be04  mov      x0, x19
0x0000be08  bl       #0xbed4   ; call sub_bed4
0x0000be0c  mov      x0, x24
0x0000be10  bl       #0x2480c   ; call _objc_release
0x0000be14  bl       #0x24764   ; call _objc_end_catch
0x0000be18  b        #0xbcbc   ; call sub_bcbc
0x0000be1c  b        #0xbe24   ; call sub_be24
0x0000be20  b        #0xbe24   ; call sub_be24
0x0000be24  mov      x23, x0
0x0000be28  mov      x0, x25
0x0000be2c  bl       #0x2480c   ; call _objc_release
0x0000be30  b        #0xbe38   ; call sub_be38
0x0000be34  mov      x23, x0
0x0000be38  mov      x0, x24
0x0000be3c  bl       #0x2480c   ; call _objc_release
0x0000be40  bl       #0x24764   ; call _objc_end_catch
0x0000be44  b        #0xbeac   ; call sub_beac
0x0000be48  b        #0xbe80   ; call sub_be80
0x0000be4c  b        #0xbe5c   ; call sub_be5c
0x0000be50  b        #0xbe80   ; call sub_be80
0x0000be54  b        #0xbe80   ; call sub_be80
0x0000be58  b        #0xbe80   ; call sub_be80
0x0000be5c  mov      x23, x0
0x0000be60  mov      x0, x25
0x0000be64  bl       #0x2480c   ; call _objc_release
0x0000be68  b        #0xbe84   ; call sub_be84
0x0000be6c  b        #0xbe80   ; call sub_be80
0x0000be70  b        #0xbe80   ; call sub_be80
0x0000be74  b        #0xbe80   ; call sub_be80
0x0000be78  b        #0xbea8   ; call sub_bea8
0x0000be7c  b        #0xbea0   ; call sub_bea0
0x0000be80  mov      x23, x0
0x0000be84  mov      x0, x24
0x0000be88  bl       #0x2480c   ; call _objc_release
0x0000be8c  b        #0xbeac   ; call sub_beac
0x0000be90  b        #0xbea8   ; call sub_bea8
0x0000be94  b        #0xbea0   ; call sub_bea0
0x0000be98  b        #0xbec0   ; call sub_bec0
0x0000be9c  b        #0xbea8   ; call sub_bea8
0x0000bea0  mov      x23, x0
0x0000bea4  b        #0xbeb4   ; call sub_beb4
0x0000bea8  mov      x23, x0
0x0000beac  mov      x0, x21
0x0000beb0  bl       #0x2480c   ; call _objc_release
0x0000beb4  mov      x0, x20
0x0000beb8  bl       #0x2480c   ; call _objc_release
0x0000bebc  b        #0xbec4   ; call sub_bec4
0x0000bec0  mov      x23, x0
0x0000bec4  mov      x0, x19
0x0000bec8  bl       #0x2480c   ; call _objc_release
0x0000becc  mov      x0, x23
0x0000bed0  bl       #0x24470   ; call __Unwind_Resume
0x0000bed4  sub      sp, sp, #0x60
0x0000bed8  stp      x22, x21, [sp, #0x30]
0x0000bedc  stp      x20, x19, [sp, #0x40]
0x0000bee0  stp      x29, x30, [sp, #0x50]
0x0000bee4  add      x29, sp, #0x50
0x0000bee8  mov      x20, x1
0x0000beec  mov      x19, x0
0x0000bef0  adrp     x8, #0x34000
0x0000bef4  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0000bef8  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x0000befc  str      x8, [sp, #0x28]
0x0000bf00  bl       #0x24818   ; call _objc_retain
0x0000bf04  mov      x0, x20
0x0000bf08  bl       #0x24818   ; call _objc_retain
0x0000bf0c  cbz      x19, #0xbf90
0x0000bf10  adrp     x0, #0x28000
0x0000bf14  add      x0, x0, #0xfc3   ; -> "NSDistributedNotificationCenter"
0x0000bf18  bl       #0x24788   ; call _objc_getClass
0x0000bf1c  bl       #0x254c0   ; objc_msgSend: defaultCenter
0x0000bf20  mov      x29, x29
0x0000bf24  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000bf28  mov      x21, x0
0x0000bf2c  adrp     x8, #0x35000
0x0000bf30  add      x8, x8, #0x3b0   ; -> @"identifier"
0x0000bf34  adrp     x9, #0x36000
0x0000bf38  add      x9, x9, #0x8b0   ; -> @"state"
0x0000bf3c  stp      x8, x9, [sp, #8]
0x0000bf40  stp      x19, x20, [sp, #0x18]
0x0000bf44  adrp     x8, #0x3e000
0x0000bf48  ldr      x0, [x8, #0x310]   ; -> [class(NSDictionary)]
0x0000bf4c  add      x2, sp, #0x18
0x0000bf50  add      x3, sp, #8
0x0000bf54  mov      w4, #2
0x0000bf58  bl       #0x255c0   ; objc_msgSend: dictionaryWithObjects:forKeys:count:
0x0000bf5c  mov      x29, x29
0x0000bf60  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000bf64  mov      x22, x0
0x0000bf68  adrp     x2, #0x36000
0x0000bf6c  add      x2, x2, #0x890   ; -> @"com.anlai.omnicar/appbridge.state"
0x0000bf70  mov      x0, x21
0x0000bf74  mov      x3, #0
0x0000bf78  mov      x4, x22
0x0000bf7c  bl       #0x26620   ; objc_msgSend: postNotificationName:object:userInfo:
0x0000bf80  mov      x0, x22
0x0000bf84  bl       #0x2480c   ; call _objc_release
0x0000bf88  mov      x0, x21
0x0000bf8c  bl       #0x2480c   ; call _objc_release
0x0000bf90  mov      x0, x20
0x0000bf94  bl       #0x2480c   ; call _objc_release
0x0000bf98  mov      x0, x19
0x0000bf9c  bl       #0x2480c   ; call _objc_release
0x0000bfa0  ldr      x8, [sp, #0x28]
0x0000bfa4  adrp     x9, #0x34000
0x0000bfa8  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x0000bfac  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0000bfb0  cmp      x9, x8
0x0000bfb4  b.ne     #0xbfcc
0x0000bfb8  ldp      x29, x30, [sp, #0x50]
0x0000bfbc  ldp      x20, x19, [sp, #0x40]
0x0000bfc0  ldp      x22, x21, [sp, #0x30]
0x0000bfc4  add      sp, sp, #0x60
0x0000bfc8  ret      
0x0000bfcc  bl       #0x24488   ; call ___stack_chk_fail
0x0000bfd0  mov      x1, x22
0x0000bfd4  mov      x22, x0
0x0000bfd8  mov      x0, x1
0x0000bfdc  bl       #0x2480c   ; call _objc_release
0x0000bfe0  b        #0xbfe8   ; call sub_bfe8
0x0000bfe4  mov      x22, x0
0x0000bfe8  mov      x0, x21
0x0000bfec  bl       #0x2480c   ; call _objc_release
0x0000bff0  b        #0xbff8   ; call sub_bff8
0x0000bff4  mov      x22, x0
0x0000bff8  mov      x0, x20
0x0000bffc  bl       #0x2480c   ; call _objc_release
0x0000c000  mov      x0, x19
0x0000c004  bl       #0x2480c   ; call _objc_release
0x0000c008  b        #0xc010   ; call sub_c010
0x0000c00c  mov      x22, x0
0x0000c010  mov      x0, x22
0x0000c014  bl       #0x24470   ; call __Unwind_Resume
0x0000c018  stp      x22, x21, [sp, #-0x30]!
0x0000c01c  stp      x20, x19, [sp, #0x10]
0x0000c020  stp      x29, x30, [sp, #0x20]
0x0000c024  add      x29, sp, #0x20
0x0000c028  mov      x20, x0
0x0000c02c  add      x0, x0, #0x28
0x0000c030  bl       #0x247a0   ; call _objc_loadWeakRetained
0x0000c034  mov      x19, x0
0x0000c038  cbz      x0, #0xc0e0
0x0000c03c  ldr      x0, [x20, #0x20]
0x0000c040  bl       #0x26580   ; objc_msgSend: panes
0x0000c044  mov      x29, x29
0x0000c048  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c04c  mov      x21, x0
0x0000c050  mov      x2, x19
0x0000c054  bl       #0x25360   ; objc_msgSend: containsObject:
0x0000c058  mov      x22, x0
0x0000c05c  mov      x0, x21
0x0000c060  bl       #0x2480c   ; call _objc_release
0x0000c064  cbz      w22, #0xc074
0x0000c068  ldr      x0, [x20, #0x20]
0x0000c06c  mov      x2, x19
0x0000c070  bl       #0x269a0   ; objc_msgSend: revealPane:
0x0000c074  mov      x0, x19
0x0000c078  bl       #0x26780   ; objc_msgSend: ready
0x0000c07c  tbnz     w0, #0, #0xc0e0
0x0000c080  ldr      x0, [x20, #0x20]
0x0000c084  bl       #0x26580   ; objc_msgSend: panes
0x0000c088  mov      x29, x29
0x0000c08c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c090  mov      x21, x0
0x0000c094  mov      x2, x19
0x0000c098  bl       #0x25360   ; objc_msgSend: containsObject:
0x0000c09c  mov      x20, x0
0x0000c0a0  mov      x0, x21
0x0000c0a4  bl       #0x2480c   ; call _objc_release
0x0000c0a8  cbz      w20, #0xc0e0
0x0000c0ac  mov      x0, x19
0x0000c0b0  mov      w2, #1
0x0000c0b4  bl       #0x275a0   ; objc_msgSend: setReady:
0x0000c0b8  mov      x0, x19
0x0000c0bc  bl       #0x25020   ; objc_msgSend: bundleID
0x0000c0c0  mov      x29, x29
0x0000c0c4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c0c8  mov      x21, x0
0x0000c0cc  adrp     x1, #0x35000
0x0000c0d0  add      x1, x1, #0xbb0   ; -> @"ready"
0x0000c0d4  bl       #0xbed4   ; call sub_bed4
0x0000c0d8  mov      x0, x21
0x0000c0dc  bl       #0x2480c   ; call _objc_release
0x0000c0e0  mov      x0, x19
0x0000c0e4  ldp      x29, x30, [sp, #0x20]
0x0000c0e8  ldp      x20, x19, [sp, #0x10]
0x0000c0ec  ldp      x22, x21, [sp], #0x30
0x0000c0f0  b        #0x2480c   ; call _objc_release
0x0000c0f4  b        #0xc0fc   ; call sub_c0fc
0x0000c0f8  b        #0xc0fc   ; call sub_c0fc
0x0000c0fc  mov      x20, x0
0x0000c100  mov      x0, x21
0x0000c104  bl       #0x2480c   ; call _objc_release
0x0000c108  b        #0xc110   ; call sub_c110
0x0000c10c  mov      x20, x0
0x0000c110  mov      x0, x19
0x0000c114  bl       #0x2480c   ; call _objc_release
0x0000c118  mov      x0, x20
0x0000c11c  bl       #0x24470   ; call __Unwind_Resume
0x0000c120  stp      x20, x19, [sp, #-0x20]!
0x0000c124  stp      x29, x30, [sp, #0x10]
0x0000c128  add      x29, sp, #0x10
0x0000c12c  mov      x19, x1
0x0000c130  mov      x20, x0
0x0000c134  ldr      x0, [x1, #0x20]
0x0000c138  bl       #0x24818   ; call _objc_retain
0x0000c13c  add      x0, x20, #0x28
0x0000c140  add      x1, x19, #0x28
0x0000c144  ldp      x29, x30, [sp, #0x10]
0x0000c148  ldp      x20, x19, [sp], #0x20
0x0000c14c  b        #0x2474c   ; call _objc_copyWeak
0x0000c150  stp      x20, x19, [sp, #-0x20]!
0x0000c154  stp      x29, x30, [sp, #0x10]
0x0000c158  add      x29, sp, #0x10
0x0000c15c  mov      x19, x0
0x0000c160  add      x0, x0, #0x28
0x0000c164  bl       #0x24758   ; call _objc_destroyWeak
0x0000c168  ldr      x0, [x19, #0x20]
0x0000c16c  ldp      x29, x30, [sp, #0x10]
0x0000c170  ldp      x20, x19, [sp], #0x20
0x0000c174  b        #0x2480c   ; call _objc_release
0x0000c178  sub      sp, sp, #0x60
0x0000c17c  stp      d9, d8, [sp, #0x30]
0x0000c180  stp      x20, x19, [sp, #0x40]
0x0000c184  stp      x29, x30, [sp, #0x50]
0x0000c188  add      x29, sp, #0x50
0x0000c18c  mov      x19, x2
0x0000c190  mov      x0, x2
0x0000c194  bl       #0x24818   ; call _objc_retain
0x0000c198  mov      x0, x19
0x0000c19c  bl       #0x24f60   ; objc_msgSend: box
0x0000c1a0  mov      x29, x29
0x0000c1a4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000c1a8  mov      x20, x0
0x0000c1ac  bl       #0x24c20   ; objc_msgSend: alpha
0x0000c1b0  mov      v8.16b, v0.16b
0x0000c1b4  mov      x0, x20
0x0000c1b8  bl       #0x2480c   ; call _objc_release
0x0000c1bc  fmov     d0, #1.00000000
0x0000c1c0  fcmp     d8, d0
0x0000c1c4  b.ge     #0xc220
0x0000c1c8  adrp     x8, #0x3e000
0x0000c1cc  ldr      x20, [x8, #0x2d0]   ; -> [class(UIView)]
0x0000c1d0  adrp     x8, #0x34000
0x0000c1d4  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x0000c1d8  str      x8, [sp, #8]
0x0000c1dc  adrp     x8, #0x2b000
0x0000c1e0  ldr      d0, [x8, #0x1d0]
0x0000c1e4  str      d0, [sp, #0x10]
0x0000c1e8  adrp     x8, #0xc000
0x0000c1ec  add      x8, x8, #0x270
0x0000c1f0  adrp     x9, #0x34000
0x0000c1f4  add      x9, x9, #0x890
0x0000c1f8  stp      x8, x9, [sp, #0x18]
0x0000c1fc  mov      x0, x19
0x0000c200  bl       #0x24818   ; call _objc_retain
0x0000c204  str      x19, [sp, #0x28]
0x0000c208  fmov     d0, #0.25000000
0x0000c20c  add      x2, sp, #8
0x0000c210  mov      x0, x20
0x0000c214  bl       #0x24c40   ; objc_msgSend: animateWithDuration:animations:
0x0000c218  ldr      x0, [sp, #0x28]
0x0000c21c  bl       #0x2480c   ; call _objc_release
0x0000c220  mov      x0, x19
0x0000c224  bl       #0x2480c   ; call _objc_release
0x0000c228  ldp      x29, x30, [sp, #0x50]
0x0000c22c  ldp      x20, x19, [sp, #0x40]
0x0000c230  ldp      d9, d8, [sp, #0x30]
0x0000c234  add      sp, sp, #0x60
0x0000c238  ret      
0x0000c23c  mov      x20, x0
0x0000c240  ldr      x0, [sp, #0x28]
0x0000c244  b        #0xc254   ; call sub_c254
0x0000c248  mov      x1, x20
0x0000c24c  mov      x20, x0
0x0000c250  mov      x0, x1
0x0000c254  bl       #0x2480c   ; call _objc_release
0x0000c258  b        #0xc260   ; call sub_c260
0x0000c25c  mov      x20, x0
0x0000c260  mov      x0, x19
0x0000c264  bl       #0x2480c   ; call _objc_release
0x0000c268  mov      x0, x20
0x0000c26c  bl       #0x24470   ; call __Unwind_Resume
0x0000c270  stp      x20, x19, [sp, #-0x20]!
