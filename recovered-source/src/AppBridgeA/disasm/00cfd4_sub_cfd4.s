; ==== sub_cfd4 @ 0xcfd4..0xd144 (368 bytes) ====
0x0000cfd4  add      x0, x0, #0xc6a
0x0000cfd8  bl       #0x24788   ; call _objc_getClass
0x0000cfdc  mov      x1, x0
0x0000cfe0  mov      x0, x20
0x0000cfe4  bl       #0x247dc   ; call _objc_opt_isKindOfClass
0x0000cfe8  tbnz     w0, #0, #0xd050
0x0000cfec  adrp     x23, #0x29000
0x0000cff0  add      x23, x23, #0xc6a   ; -> "SBApplicationSceneUpdateTransaction"
0x0000cff4  ldr      x0, [x26, #0x290]
0x0000cff8  mov      w8, #0x1d9
0x0000cffc  stp      x25, x8, [sp, #0x10]
0x0000d000  stp      x23, x20, [sp]
0x0000d004  adrp     x2, #0x35000
0x0000d008  add      x2, x2, #0xc10   ; -> @"UNEXPECTED %s: got %@ (%s:%d)"
0x0000d00c  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0000d010  mov      x29, x29
0x0000d014  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000d018  mov      x19, x0
0x0000d01c  adrp     x0, #0x34000
0x0000d020  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x0000d024  mov      x1, x19
0x0000d028  bl       #0x1dd30   ; call _OMCLogWrite
0x0000d02c  mov      x0, x19
0x0000d030  bl       #0x2480c   ; call _objc_release
0x0000d034  ldr      x0, [x24, #0x338]
0x0000d038  adrp     x2, #0x34000
0x0000d03c  add      x2, x2, #0xef0   ; -> @"AppBridge"
0x0000d040  stp      x23, x20, [sp]
0x0000d044  adrp     x3, #0x35000
0x0000d048  add      x3, x3, #0xc30   ; -> @"expected %s got %@"
0x0000d04c  bl       #0x26700   ; objc_msgSend: raise:format:
0x0000d050  mov      x0, x20
0x0000d054  bl       #0x24818   ; call _objc_retain
0x0000d058  mov      x0, x20
0x0000d05c  bl       #0x2480c   ; call _objc_release
0x0000d060  mov      x0, x20
0x0000d064  bl       #0x2480c   ; call _objc_release
0x0000d068  adrp     x2, #0x35000
0x0000d06c  add      x2, x2, #0xe90   ; -> @"_activeTransitions"
0x0000d070  mov      x0, x22
0x0000d074  bl       #0x28100   ; objc_msgSend: valueForKey:
0x0000d078  mov      x29, x29
0x0000d07c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0000d080  mov      x24, x0
0x0000d084  sub      x0, x29, #0x60
0x0000d088  ldr      x1, [sp, #0x30]
0x0000d08c  bl       #0x24794   ; call _objc_initWeak
0x0000d090  sub      x0, x29, #0x68
0x0000d094  ldr      x1, [sp, #0x80]
0x0000d098  bl       #0x24794   ; call _objc_initWeak
0x0000d09c  mov      x0, x20
0x0000d0a0  bl       #0x24818   ; call _objc_retain
0x0000d0a4  adrp     x0, #0x35000
0x0000d0a8  add      x0, x0, #0xeb0   ; -> @"setCompletionBlock:"
0x0000d0ac  str      x24, [sp, #0x28]
0x0000d0b0  bl       #0x2441c   ; call _NSSelectorFromString
0x0000d0b4  mov      x19, x0
0x0000d0b8  mov      x0, x20
0x0000d0bc  mov      x1, x19
0x0000d0c0  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x0000d0c4  tbz      w0, #0, #0xd15c
0x0000d0c8  adrp     x8, #0x34000
0x0000d0cc  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x0000d0d0  str      x8, [sp, #0x88]
0x0000d0d4  adrp     x8, #0x2b000
0x0000d0d8  ldr      d0, [x8, #0x1d0]
0x0000d0dc  str      d0, [sp, #0x90]
0x0000d0e0  adrp     x8, #0xe000
0x0000d0e4  add      x8, x8, #0x2a0
0x0000d0e8  adrp     x9, #0x34000
0x0000d0ec  add      x9, x9, #0x8f0
0x0000d0f0  stp      x8, x9, [sp, #0x98]
0x0000d0f4  mov      x0, x24
0x0000d0f8  bl       #0x24818   ; call _objc_retain
0x0000d0fc  str      x24, [sp, #0xa8]
0x0000d100  mov      x0, x20
0x0000d104  bl       #0x24818   ; call _objc_retain
0x0000d108  str      x20, [sp, #0xb0]
0x0000d10c  add      x23, sp, #0x88
0x0000d110  add      x0, x23, #0x30
0x0000d114  sub      x1, x29, #0x68
0x0000d118  bl       #0x2474c   ; call _objc_copyWeak
0x0000d11c  add      x0, x23, #0x38
0x0000d120  sub      x1, x29, #0x60
0x0000d124  bl       #0x2474c   ; call _objc_copyWeak
0x0000d128  add      x2, sp, #0x88
0x0000d12c  mov      x0, x20
0x0000d130  mov      x1, x19
0x0000d134  bl       #0x247ac   ; call _objc_msgSend
0x0000d138  add      x0, x23, #0x38
0x0000d13c  bl       #0x24758   ; call _objc_destroyWeak
0x0000d140  add      x0, x23, #0x30
