; ==== sub_24734 @ 0x24734..0x24958 (548 bytes) ====
0x00024734  adrp     x16, #0x34000
0x00024738  ldr      x16, [x16, #0x60]   ; -> [got:_objc_autoreleaseReturnValue]
0x0002473c  br       x16
0x00024740  adrp     x16, #0x34000
0x00024744  ldr      x16, [x16, #0x68]   ; -> [got:_objc_begin_catch]
0x00024748  br       x16
0x0002474c  adrp     x16, #0x34000
0x00024750  ldr      x16, [x16, #0x70]   ; -> [got:_objc_copyWeak]
0x00024754  br       x16
0x00024758  adrp     x16, #0x34000
0x0002475c  ldr      x16, [x16, #0x78]   ; -> [got:_objc_destroyWeak]
0x00024760  br       x16
0x00024764  adrp     x16, #0x34000
0x00024768  ldr      x16, [x16, #0x80]   ; -> [got:_objc_end_catch]
0x0002476c  br       x16
0x00024770  adrp     x16, #0x34000
0x00024774  ldr      x16, [x16, #0x88]   ; -> [got:_objc_enumerationMutation]
0x00024778  br       x16
0x0002477c  adrp     x16, #0x34000
0x00024780  ldr      x16, [x16, #0x90]   ; -> [got:_objc_getAssociatedObject]
0x00024784  br       x16
0x00024788  adrp     x16, #0x34000
0x0002478c  ldr      x16, [x16, #0x98]   ; -> [got:_objc_getClass]
0x00024790  br       x16
0x00024794  adrp     x16, #0x34000
0x00024798  ldr      x16, [x16, #0xa0]   ; -> [got:_objc_initWeak]
0x0002479c  br       x16
0x000247a0  adrp     x16, #0x34000
0x000247a4  ldr      x16, [x16, #0xa8]   ; -> [got:_objc_loadWeakRetained]
0x000247a8  br       x16
0x000247ac  adrp     x16, #0x34000
0x000247b0  ldr      x16, [x16, #0xb8]   ; -> [got:_objc_msgSend]
0x000247b4  br       x16
0x000247b8  adrp     x16, #0x34000
0x000247bc  ldr      x16, [x16, #0xc0]   ; -> [got:_objc_msgSendSuper]
0x000247c0  br       x16
0x000247c4  adrp     x16, #0x34000
0x000247c8  ldr      x16, [x16, #0xc8]   ; -> [got:_objc_msgSendSuper2]
0x000247cc  br       x16
0x000247d0  adrp     x16, #0x34000
0x000247d4  ldr      x16, [x16, #0xd0]   ; -> [got:_objc_opt_class]
0x000247d8  br       x16
0x000247dc  adrp     x16, #0x34000
0x000247e0  ldr      x16, [x16, #0xd8]   ; -> [got:_objc_opt_isKindOfClass]
0x000247e4  br       x16
0x000247e8  adrp     x16, #0x34000
0x000247ec  ldr      x16, [x16, #0xe0]   ; -> [got:_objc_opt_new]
0x000247f0  br       x16
0x000247f4  adrp     x16, #0x34000
0x000247f8  ldr      x16, [x16, #0xe8]   ; -> [got:_objc_opt_respondsToSelector]
0x000247fc  br       x16
0x00024800  adrp     x16, #0x34000
0x00024804  ldr      x16, [x16, #0xf0]   ; -> [got:_objc_registerClassPair]
0x00024808  br       x16
0x0002480c  adrp     x16, #0x34000
0x00024810  ldr      x16, [x16, #0xf8]   ; -> [got:_objc_release]
0x00024814  br       x16
0x00024818  adrp     x16, #0x34000
0x0002481c  ldr      x16, [x16, #0x100]   ; -> [got:_objc_retain]
0x00024820  br       x16
0x00024824  adrp     x16, #0x34000
0x00024828  ldr      x16, [x16, #0x108]   ; -> [got:_objc_retainAutorelease]
0x0002482c  br       x16
0x00024830  adrp     x16, #0x34000
0x00024834  ldr      x16, [x16, #0x110]   ; -> [got:_objc_retainAutoreleasedReturnValue]
0x00024838  br       x16
0x0002483c  adrp     x16, #0x34000
0x00024840  ldr      x16, [x16, #0x118]   ; -> [got:_objc_retainBlock]
0x00024844  br       x16
0x00024848  adrp     x16, #0x34000
0x0002484c  ldr      x16, [x16, #0x120]   ; -> [got:_objc_setAssociatedObject]
0x00024850  br       x16
0x00024854  adrp     x16, #0x34000
0x00024858  ldr      x16, [x16, #0x128]   ; -> [got:_objc_setProperty_nonatomic_copy]
0x0002485c  br       x16
0x00024860  adrp     x16, #0x34000
0x00024864  ldr      x16, [x16, #0x130]   ; -> [got:_objc_storeStrong]
0x00024868  br       x16
0x0002486c  adrp     x16, #0x34000
0x00024870  ldr      x16, [x16, #0x138]   ; -> [got:_objc_storeWeak]
0x00024874  br       x16
0x00024878  adrp     x16, #0x34000
0x0002487c  ldr      x16, [x16, #0x140]   ; -> [got:_objc_sync_enter]
0x00024880  br       x16
0x00024884  adrp     x16, #0x34000
0x00024888  ldr      x16, [x16, #0x148]   ; -> [got:_objc_sync_exit]
0x0002488c  br       x16
0x00024890  adrp     x16, #0x34000
0x00024894  ldr      x16, [x16, #0x150]   ; -> [got:_objc_unsafeClaimAutoreleasedReturnValue]
0x00024898  br       x16
0x0002489c  adrp     x16, #0x34000
0x000248a0  ldr      x16, [x16, #0x158]   ; -> [got:_object_getClass]
0x000248a4  br       x16
0x000248a8  adrp     x16, #0x34000
0x000248ac  ldr      x16, [x16, #0x160]   ; -> [got:_object_setClass]
0x000248b0  br       x16
0x000248b4  adrp     x16, #0x34000
0x000248b8  ldr      x16, [x16, #0x400]   ; -> [got:_open]
0x000248bc  br       x16
0x000248c0  adrp     x16, #0x34000
0x000248c4  ldr      x16, [x16, #0x408]   ; -> [got:_os_proc_available_memory]
0x000248c8  br       x16
0x000248cc  adrp     x16, #0x34000
0x000248d0  ldr      x16, [x16, #0x168]   ; -> [got:_property_getAttributes]
0x000248d4  br       x16
0x000248d8  adrp     x16, #0x34000
0x000248dc  ldr      x16, [x16, #0x170]   ; -> [got:_property_getName]
0x000248e0  br       x16
0x000248e4  adrp     x16, #0x34000
0x000248e8  ldr      x16, [x16, #0x410]   ; -> [got:_raise]
0x000248ec  br       x16
0x000248f0  adrp     x16, #0x34000
0x000248f4  ldr      x16, [x16, #0x178]   ; -> [got:_sel_registerName]
0x000248f8  br       x16
0x000248fc  adrp     x16, #0x34000
0x00024900  ldr      x16, [x16, #0x418]   ; -> [got:_setenv]
0x00024904  br       x16
0x00024908  adrp     x16, #0x34000
0x0002490c  ldr      x16, [x16, #0x420]   ; -> [got:_sigaction]
0x00024910  br       x16
0x00024914  adrp     x16, #0x34000
0x00024918  ldr      x16, [x16, #0x428]   ; -> [got:_signal]
0x0002491c  br       x16
0x00024920  adrp     x16, #0x34000
0x00024924  ldr      x16, [x16, #0x430]   ; -> [got:_snprintf]
0x00024928  br       x16
0x0002492c  adrp     x16, #0x34000
0x00024930  ldr      x16, [x16, #0x438]   ; -> [got:_strcmp]
0x00024934  br       x16
0x00024938  adrp     x16, #0x34000
0x0002493c  ldr      x16, [x16, #0x440]   ; -> [got:_strlcat]
0x00024940  br       x16
0x00024944  adrp     x16, #0x34000
0x00024948  ldr      x16, [x16, #0x448]   ; -> [got:_strlcpy]
0x0002494c  br       x16
0x00024950  adrp     x16, #0x34000
0x00024954  ldr      x16, [x16, #0x450]   ; -> [got:_strlen]
