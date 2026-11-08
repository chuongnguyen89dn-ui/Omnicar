; ==== sub_15f58 @ 0x15f58..0x165c0 (1640 bytes) ====
0x00015f58  mov      x1, x22
0x00015f5c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00015f60  tbz      w0, #0, #0x15fb8
0x00015f64  adrp     x5, #0x36000
0x00015f68  add      x5, x5, #0xb30   ; -> @"OmniCar App Bridge: closed"
0x00015f6c  mov      x0, x23
0x00015f70  mov      x1, x22
0x00015f74  mov      x2, x19
0x00015f78  mov      w3, #1
0x00015f7c  mov      w4, #0
0x00015f80  bl       #0x247ac   ; call _objc_msgSend
0x00015f84  ldr      x0, [x25, #0x290]
0x00015f88  str      x19, [sp]
0x00015f8c  adrp     x2, #0x36000
0x00015f90  add      x2, x2, #0xb50   ; -> @"tat han %@"
0x00015f94  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00015f98  mov      x29, x29
0x00015f9c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015fa0  mov      x24, x0
0x00015fa4  adrp     x0, #0x34000
0x00015fa8  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00015fac  mov      x1, x24
0x00015fb0  bl       #0x1dd30   ; call _OMCLogWrite
0x00015fb4  b        #0x15fe8   ; call sub_15fe8
0x00015fb8  ldr      x0, [x25, #0x290]
0x00015fbc  str      x19, [sp]
0x00015fc0  adrp     x2, #0x36000
0x00015fc4  add      x2, x2, #0xb70   ; -> @"khong tim thay API terminate cho %@"
0x00015fc8  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x00015fcc  mov      x29, x29
0x00015fd0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015fd4  mov      x24, x0
0x00015fd8  adrp     x0, #0x34000
0x00015fdc  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x00015fe0  mov      x1, x24
0x00015fe4  bl       #0x1dd30   ; call _OMCLogWrite
0x00015fe8  mov      x0, x24
0x00015fec  bl       #0x2480c   ; call _objc_release
0x00015ff0  mov      x0, x23
0x00015ff4  bl       #0x2480c   ; call _objc_release
0x00015ff8  mov      x23, x19
0x00015ffc  mov      x0, x23
0x00016000  bl       #0x2480c   ; call _objc_release
0x00016004  mov      x0, x21
0x00016008  bl       #0x2480c   ; call _objc_release
0x0001600c  mov      x0, x20
0x00016010  bl       #0x2480c   ; call _objc_release
0x00016014  mov      x0, x19
0x00016018  ldp      x29, x30, [sp, #0x50]
0x0001601c  ldp      x20, x19, [sp, #0x40]
0x00016020  ldp      x22, x21, [sp, #0x30]
0x00016024  ldp      x24, x23, [sp, #0x20]
0x00016028  ldp      x26, x25, [sp, #0x10]
0x0001602c  add      sp, sp, #0x60
0x00016030  b        #0x2480c   ; call _objc_release
0x00016034  b        #0x16044   ; call sub_16044
0x00016038  b        #0x16054   ; call sub_16054
0x0001603c  mov      x22, x0
0x00016040  b        #0x160bc   ; call sub_160bc
0x00016044  mov      x22, x0
0x00016048  mov      x0, x24
0x0001604c  bl       #0x2480c   ; call _objc_release
0x00016050  b        #0x160ac   ; call sub_160ac
0x00016054  mov      x22, x0
0x00016058  mov      x0, x23
0x0001605c  b        #0x160b8   ; call sub_160b8
0x00016060  b        #0x16078   ; call sub_16078
0x00016064  b        #0x16084   ; call sub_16084
0x00016068  mov      x22, x0
0x0001606c  b        #0x160b4   ; call sub_160b4
0x00016070  b        #0x1609c   ; call sub_1609c
0x00016074  b        #0x160d0   ; call sub_160d0
0x00016078  mov      x22, x0
0x0001607c  mov      x0, x21
0x00016080  b        #0x160b8   ; call sub_160b8
0x00016084  mov      x22, x0
0x00016088  mov      x0, x24
0x0001608c  b        #0x160b0   ; call sub_160b0
0x00016090  b        #0x1609c   ; call sub_1609c
0x00016094  b        #0x1609c   ; call sub_1609c
0x00016098  b        #0x1609c   ; call sub_1609c
0x0001609c  mov      x22, x0
0x000160a0  mov      x0, x23
0x000160a4  b        #0x160c0   ; call sub_160c0
0x000160a8  mov      x22, x0
0x000160ac  mov      x0, x23
0x000160b0  bl       #0x2480c   ; call _objc_release
0x000160b4  mov      x0, x19
0x000160b8  bl       #0x2480c   ; call _objc_release
0x000160bc  mov      x0, x21
0x000160c0  bl       #0x2480c   ; call _objc_release
0x000160c4  b        #0x160d4   ; call sub_160d4
0x000160c8  mov      x22, x0
0x000160cc  b        #0x160dc   ; call sub_160dc
0x000160d0  mov      x22, x0
0x000160d4  mov      x0, x20
0x000160d8  bl       #0x2480c   ; call _objc_release
0x000160dc  mov      x0, x19
0x000160e0  bl       #0x2480c   ; call _objc_release
0x000160e4  mov      x0, x22
0x000160e8  bl       #0x24470   ; call __Unwind_Resume
0x000160ec  mov      x2, #0
0x000160f0  b        #0x251c0   ; objc_msgSend: closeAllExcept:
0x000160f4  sub      sp, sp, #0x140
0x000160f8  stp      x28, x27, [sp, #0xe0]
0x000160fc  stp      x26, x25, [sp, #0xf0]
0x00016100  stp      x24, x23, [sp, #0x100]
0x00016104  stp      x22, x21, [sp, #0x110]
0x00016108  stp      x20, x19, [sp, #0x120]
0x0001610c  stp      x29, x30, [sp, #0x130]
0x00016110  add      x29, sp, #0x130
0x00016114  mov      x19, x2
0x00016118  mov      x20, x0
0x0001611c  adrp     x8, #0x34000
0x00016120  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00016124  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00016128  stur     x8, [x29, #-0x58]
0x0001612c  mov      x0, x2
0x00016130  bl       #0x24818   ; call _objc_retain
0x00016134  mov      x0, x20
0x00016138  bl       #0x26580   ; objc_msgSend: panes
0x0001613c  mov      x29, x29
0x00016140  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016144  mov      x21, x0
0x00016148  bl       #0x25420   ; objc_msgSend: count
0x0001614c  mov      x22, x0
0x00016150  mov      x0, x21
0x00016154  bl       #0x2480c   ; call _objc_release
0x00016158  cbz      x22, #0x16308
0x0001615c  adrp     x8, #0x3e000
0x00016160  ldr      x23, [x8, #0x290]   ; -> [class(NSString)]
0x00016164  mov      x0, x20
0x00016168  bl       #0x26580   ; objc_msgSend: panes
0x0001616c  mov      x29, x29
0x00016170  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016174  mov      x21, x0
0x00016178  bl       #0x25420   ; objc_msgSend: count
0x0001617c  mov      x24, x0
0x00016180  cbz      x19, #0x161a4
0x00016184  adrp     x0, #0x36000
0x00016188  add      x0, x0, #0x750   ; -> @", giu "
0x0001618c  mov      x2, x19
0x00016190  bl       #0x27c80   ; objc_msgSend: stringByAppendingString:
0x00016194  mov      x29, x29
0x00016198  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001619c  mov      x22, x0
0x000161a0  b        #0x161ac   ; call sub_161ac
0x000161a4  adrp     x22, #0x36000
0x000161a8  add      x22, x22, #0x6f0   ; -> @""
0x000161ac  stp      x24, x22, [sp]
0x000161b0  adrp     x2, #0x36000
0x000161b4  add      x2, x2, #0x730   ; -> @"dong tat ca (%lu app%@)"
0x000161b8  mov      x0, x23
0x000161bc  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x000161c0  mov      x29, x29
0x000161c4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000161c8  mov      x23, x0
0x000161cc  adrp     x0, #0x34000
0x000161d0  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x000161d4  mov      x1, x23
0x000161d8  bl       #0x1dd30   ; call _OMCLogWrite
0x000161dc  mov      x0, x23
0x000161e0  bl       #0x2480c   ; call _objc_release
0x000161e4  cbz      x19, #0x161f0
0x000161e8  mov      x0, x22
0x000161ec  bl       #0x2480c   ; call _objc_release
0x000161f0  mov      x0, x21
0x000161f4  bl       #0x2480c   ; call _objc_release
0x000161f8  movi     v0.16b, #0
0x000161fc  stp      q0, q0, [sp, #0x30]
0x00016200  stp      q0, q0, [sp, #0x10]
0x00016204  mov      x0, x20
0x00016208  bl       #0x26580   ; objc_msgSend: panes
0x0001620c  mov      x29, x29
0x00016210  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016214  mov      x22, x0
0x00016218  bl       #0x253e0   ; objc_msgSend: copy
0x0001621c  mov      x21, x0
0x00016220  mov      x0, x22
0x00016224  bl       #0x2480c   ; call _objc_release
0x00016228  add      x2, sp, #0x10
0x0001622c  add      x3, sp, #0x58
0x00016230  mov      x0, x21
0x00016234  mov      w4, #0x10
0x00016238  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0001623c  mov      x22, x0
0x00016240  cbz      x0, #0x162f8
0x00016244  ldr      x8, [sp, #0x20]
0x00016248  ldr      x26, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x0001624c  mov      x27, #0
0x00016250  ldr      x8, [sp, #0x20]
0x00016254  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00016258  cmp      x8, x26
0x0001625c  b.eq     #0x16268
0x00016260  mov      x0, x21
0x00016264  bl       #0x24770   ; call _objc_enumerationMutation
0x00016268  ldr      x8, [sp, #0x18]
0x0001626c  ldr      x23, [x8, x27, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x00016270  cbz      x19, #0x162a0
0x00016274  mov      x0, x23
0x00016278  bl       #0x25020   ; objc_msgSend: bundleID
0x0001627c  mov      x29, x29
0x00016280  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016284  mov      x24, x0
0x00016288  mov      x2, x19
0x0001628c  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00016290  mov      x25, x0
0x00016294  mov      x0, x24
0x00016298  bl       #0x2480c   ; call _objc_release
0x0001629c  tbnz     w25, #0, #0x162d0
0x000162a0  mov      x0, x20
0x000162a4  mov      x2, x23
0x000162a8  bl       #0x27ee0   ; objc_msgSend: teardownPane:
0x000162ac  mov      x0, x20
0x000162b0  bl       #0x26580   ; objc_msgSend: panes
0x000162b4  mov      x29, x29
0x000162b8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000162bc  mov      x24, x0
0x000162c0  mov      x2, x23
0x000162c4  bl       #0x268a0   ; objc_msgSend: removeObject:
0x000162c8  mov      x0, x24
0x000162cc  bl       #0x2480c   ; call _objc_release
0x000162d0  add      x27, x27, #1
0x000162d4  cmp      x22, x27
0x000162d8  b.ne     #0x16250
0x000162dc  add      x2, sp, #0x10
0x000162e0  add      x3, sp, #0x58
0x000162e4  mov      x0, x21
0x000162e8  mov      w4, #0x10
0x000162ec  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x000162f0  mov      x22, x0
0x000162f4  cbnz     x0, #0x1624c
0x000162f8  mov      x0, x21
0x000162fc  bl       #0x2480c   ; call _objc_release
0x00016300  mov      x0, x20
0x00016304  bl       #0x25660   ; objc_msgSend: dropWindowIfEmpty
0x00016308  mov      x0, x19
0x0001630c  bl       #0x2480c   ; call _objc_release
0x00016310  ldur     x8, [x29, #-0x58]
0x00016314  adrp     x9, #0x34000
0x00016318  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x0001631c  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x00016320  cmp      x9, x8
0x00016324  b.ne     #0x16348
0x00016328  ldp      x29, x30, [sp, #0x130]
0x0001632c  ldp      x20, x19, [sp, #0x120]
0x00016330  ldp      x22, x21, [sp, #0x110]
0x00016334  ldp      x24, x23, [sp, #0x100]
0x00016338  ldp      x26, x25, [sp, #0xf0]
0x0001633c  ldp      x28, x27, [sp, #0xe0]
0x00016340  add      sp, sp, #0x140
0x00016344  ret      
0x00016348  bl       #0x24488   ; call ___stack_chk_fail
0x0001634c  b        #0x163c4   ; call sub_163c4
0x00016350  mov      x20, x0
0x00016354  mov      x0, x22
0x00016358  b        #0x16390   ; call sub_16390
0x0001635c  b        #0x16398   ; call sub_16398
0x00016360  mov      x20, x0
0x00016364  mov      x0, x23
0x00016368  bl       #0x2480c   ; call _objc_release
0x0001636c  b        #0x16374   ; call sub_16374
0x00016370  mov      x20, x0
0x00016374  cbz      x19, #0x1638c
0x00016378  mov      x0, x22
0x0001637c  bl       #0x2480c   ; call _objc_release
0x00016380  b        #0x1638c   ; call sub_1638c
0x00016384  b        #0x16388   ; call sub_16388
0x00016388  mov      x20, x0
0x0001638c  mov      x0, x21
0x00016390  bl       #0x2480c   ; call _objc_release
0x00016394  b        #0x163d0   ; call sub_163d0
0x00016398  mov      x20, x0
0x0001639c  b        #0x163d0   ; call sub_163d0
0x000163a0  b        #0x163c4   ; call sub_163c4
0x000163a4  mov      x20, x0
0x000163a8  mov      x0, x24
0x000163ac  bl       #0x2480c   ; call _objc_release
0x000163b0  b        #0x163c8   ; call sub_163c8
0x000163b4  mov      x20, x0
0x000163b8  mov      x0, x24
0x000163bc  bl       #0x2480c   ; call _objc_release
0x000163c0  b        #0x163c8   ; call sub_163c8
0x000163c4  mov      x20, x0
0x000163c8  mov      x0, x21
0x000163cc  bl       #0x2480c   ; call _objc_release
0x000163d0  mov      x0, x19
0x000163d4  bl       #0x2480c   ; call _objc_release
0x000163d8  b        #0x163e0   ; call sub_163e0
0x000163dc  mov      x20, x0
0x000163e0  mov      x0, x20
0x000163e4  bl       #0x24470   ; call __Unwind_Resume
0x000163e8  sub      sp, sp, #0x120
0x000163ec  stp      x24, x23, [sp, #0xe0]
0x000163f0  stp      x22, x21, [sp, #0xf0]
0x000163f4  stp      x20, x19, [sp, #0x100]
0x000163f8  stp      x29, x30, [sp, #0x110]
0x000163fc  add      x29, sp, #0x110
0x00016400  mov      x19, x0
0x00016404  adrp     x8, #0x34000
0x00016408  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x0001640c  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00016410  stur     x8, [x29, #-0x38]
0x00016414  bl       #0x25e60   ; objc_msgSend: knobViews
0x00016418  mov      x29, x29
0x0001641c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016420  mov      x20, x0
0x00016424  adrp     x8, #0x3d000
0x00016428  ldr      x2, [x8, #0xa50]   ; -> [@selector(removeFromSuperview)]
0x0001642c  bl       #0x26100   ; objc_msgSend: makeObjectsPerformSelector:
0x00016430  mov      x0, x20
0x00016434  bl       #0x2480c   ; call _objc_release
0x00016438  mov      x0, x19
0x0001643c  bl       #0x25e60   ; objc_msgSend: knobViews
0x00016440  mov      x29, x29
0x00016444  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016448  mov      x20, x0
0x0001644c  bl       #0x26800   ; objc_msgSend: removeAllObjects
0x00016450  mov      x0, x20
0x00016454  bl       #0x2480c   ; call _objc_release
0x00016458  mov      x0, x19
0x0001645c  bl       #0x26580   ; objc_msgSend: panes
0x00016460  mov      x29, x29
0x00016464  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016468  mov      x20, x0
0x0001646c  bl       #0x25420   ; objc_msgSend: count
0x00016470  cbz      x0, #0x16480
0x00016474  mov      x0, x20
0x00016478  bl       #0x2480c   ; call _objc_release
0x0001647c  b        #0x164a4   ; call sub_164a4
0x00016480  mov      x0, x19
0x00016484  bl       #0x281e0   ; objc_msgSend: window
0x00016488  mov      x29, x29
0x0001648c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016490  mov      x21, x0
0x00016494  bl       #0x2480c   ; call _objc_release
0x00016498  mov      x0, x20
0x0001649c  bl       #0x2480c   ; call _objc_release
0x000164a0  cbz      x21, #0x16604
0x000164a4  adrp     x8, #0x3e000
0x000164a8  ldr      x21, [x8, #0x290]   ; -> [class(NSString)]
0x000164ac  mov      x0, x19
0x000164b0  bl       #0x26580   ; objc_msgSend: panes
0x000164b4  mov      x29, x29
0x000164b8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000164bc  mov      x20, x0
0x000164c0  bl       #0x25420   ; objc_msgSend: count
0x000164c4  str      x0, [sp]
0x000164c8  adrp     x2, #0x36000
0x000164cc  add      x2, x2, #0x770   ; -> @"xe ngat -> bo %lu o"
0x000164d0  mov      x0, x21
0x000164d4  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x000164d8  mov      x29, x29
0x000164dc  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000164e0  mov      x21, x0
0x000164e4  adrp     x0, #0x34000
0x000164e8  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x000164ec  mov      x1, x21
0x000164f0  bl       #0x1dd30   ; call _OMCLogWrite
0x000164f4  mov      x0, x21
0x000164f8  bl       #0x2480c   ; call _objc_release
0x000164fc  mov      x0, x20
0x00016500  bl       #0x2480c   ; call _objc_release
0x00016504  movi     v0.16b, #0
0x00016508  stp      q0, q0, [sp, #0x30]
0x0001650c  stp      q0, q0, [sp, #0x10]
0x00016510  mov      x0, x19
0x00016514  bl       #0x26580   ; objc_msgSend: panes
0x00016518  mov      x29, x29
0x0001651c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00016520  mov      x21, x0
0x00016524  bl       #0x253e0   ; objc_msgSend: copy
0x00016528  mov      x20, x0
0x0001652c  mov      x0, x21
0x00016530  bl       #0x2480c   ; call _objc_release
0x00016534  add      x2, sp, #0x10
0x00016538  add      x3, sp, #0x58
0x0001653c  mov      x0, x20
0x00016540  mov      w4, #0x10
0x00016544  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x00016548  mov      x21, x0
0x0001654c  cbz      x0, #0x165ac
0x00016550  ldr      x8, [sp, #0x20]
0x00016554  ldr      x22, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00016558  mov      x23, #0
0x0001655c  ldr      x8, [sp, #0x20]
0x00016560  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00016564  cmp      x8, x22
0x00016568  b.eq     #0x16574
0x0001656c  mov      x0, x20
0x00016570  bl       #0x24770   ; call _objc_enumerationMutation
0x00016574  ldr      x8, [sp, #0x18]
0x00016578  ldr      x2, [x8, x23, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x0001657c  mov      x0, x19
0x00016580  bl       #0x27ee0   ; objc_msgSend: teardownPane:
0x00016584  add      x23, x23, #1
0x00016588  cmp      x21, x23
0x0001658c  b.ne     #0x1655c
0x00016590  add      x2, sp, #0x10
0x00016594  add      x3, sp, #0x58
0x00016598  mov      x0, x20
0x0001659c  mov      w4, #0x10
0x000165a0  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x000165a4  mov      x21, x0
0x000165a8  cbnz     x0, #0x16558
0x000165ac  mov      x0, x20
0x000165b0  bl       #0x2480c   ; call _objc_release
0x000165b4  mov      x0, x19
0x000165b8  bl       #0x26580   ; objc_msgSend: panes
0x000165bc  mov      x29, x29
