=== -[OMCSpeedBubbleController viewDidLoad]  va=0x25bd4 size=724 types=v16@0:8
0x00025bd4  sub      sp, sp, #0x50
0x00025bd8  stp      x24, x23, [sp, #0x10]
0x00025bdc  stp      x22, x21, [sp, #0x20]
0x00025be0  stp      x20, x19, [sp, #0x30]
0x00025be4  stp      x29, x30, [sp, #0x40]
0x00025be8  add      x29, sp, #0x40
0x00025bec  mov      x19, x0
0x00025bf0  adrp     x0, #0x75000
0x00025bf4  add      x0, x0, #0x28   ; STR "com.anlai.omnicar"
0x00025bf8  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x00025bfc  adrp     x2, #0x76000
0x00025c00  add      x2, x2, #0xae8   ; STR "speedBubbleSource"
0x00025c04  mov      x0, x19
0x00025c08  mov      x3, #0
0x00025c0c  bl       #0x598c0   ; CALL objc_msgSend$prefForKey:def:
0x00025c10  mov      x29, x29
0x00025c14  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025c18  mov      x20, x0
0x00025c1c  cbz      x0, #0x25ca0
0x00025c20  adrp     x2, #0x7a000
0x00025c24  add      x2, x2, #0x148   ; STR "speedBubbleSourceV2"
0x00025c28  adrp     x3, #0x74000
0x00025c2c  ldr      x3, [x3, #0x1b0]   ; @GOT ___kCFBooleanFalse
0x00025c30  mov      x0, x19
0x00025c34  bl       #0x598c0   ; CALL objc_msgSend$prefForKey:def:
0x00025c38  mov      x29, x29
0x00025c3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025c40  mov      x21, x0
0x00025c44  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00025c48  mov      x22, x0
0x00025c4c  mov      x0, x21
0x00025c50  bl       #0x55d78   ; CALL _objc_release
0x00025c54  tbnz     w22, #0, #0x25d44
0x00025c58  mov      x0, x20
0x00025c5c  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x00025c60  adrp     x8, #0x8e000
0x00025c64  ldr      x8, [x8, #0x928]   ; @CLASS NSNumber
0x00025c68  cmp      x0, #2
0x00025c6c  csel     x9, x0, xzr, lo
0x00025c70  cmp      x0, #4
0x00025c74  mov      w10, #2
0x00025c78  csel     x2, x10, x9, eq
0x00025c7c  mov      x0, x8
0x00025c80  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x00025c84  mov      x1, x0
0x00025c88  adrp     x0, #0x76000
0x00025c8c  add      x0, x0, #0xae8   ; STR "speedBubbleSource"
0x00025c90  adrp     x2, #0x75000
0x00025c94  add      x2, x2, #0x28   ; STR "com.anlai.omnicar"
0x00025c98  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x00025c9c  b        #0x25d44
0x00025ca0  adrp     x2, #0x7a000
0x00025ca4  add      x2, x2, #0x108   ; STR "speedBubbleAppVietmap"
0x00025ca8  mov      x0, x19
0x00025cac  mov      x3, #0
0x00025cb0  bl       #0x598c0   ; CALL objc_msgSend$prefForKey:def:
0x00025cb4  mov      x29, x29
0x00025cb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025cbc  mov      x21, x0
0x00025cc0  adrp     x2, #0x7a000
0x00025cc4  add      x2, x2, #0x128   ; STR "speedBubbleAppGOFA"
0x00025cc8  mov      x0, x19
0x00025ccc  mov      x3, #0
0x00025cd0  bl       #0x598c0   ; CALL objc_msgSend$prefForKey:def:
0x00025cd4  mov      x29, x29
0x00025cd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025cdc  mov      x22, x0
0x00025ce0  cbz      x21, #0x25cf0
0x00025ce4  mov      x0, x21
0x00025ce8  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00025cec  tbz      w0, #0, #0x25cf8
0x00025cf0  mov      w2, #0
0x00025cf4  b        #0x25d10
0x00025cf8  cbz      x22, #0x25d0c
0x00025cfc  mov      x0, x22
0x00025d00  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00025d04  mov      x2, x0
0x00025d08  b        #0x25d10
0x00025d0c  mov      w2, #1
0x00025d10  adrp     x8, #0x8e000
0x00025d14  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x00025d18  bl       #0x59300   ; CALL objc_msgSend$numberWithInt:
0x00025d1c  mov      x1, x0
0x00025d20  adrp     x0, #0x76000
0x00025d24  add      x0, x0, #0xae8   ; STR "speedBubbleSource"
0x00025d28  adrp     x2, #0x75000
0x00025d2c  add      x2, x2, #0x28   ; STR "com.anlai.omnicar"
0x00025d30  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x00025d34  mov      x0, x22
0x00025d38  bl       #0x55d78   ; CALL _objc_release
0x00025d3c  mov      x0, x21
0x00025d40  bl       #0x55d78   ; CALL _objc_release
0x00025d44  adrp     x8, #0x74000
0x00025d48  ldr      x8, [x8, #0x1c0]   ; @GOT _kCFBooleanTrue
0x00025d4c  ldr      x21, [x8]   ; @GOT ___objc_personality_v0
0x00025d50  adrp     x0, #0x7a000
0x00025d54  add      x0, x0, #0x148   ; STR "speedBubbleSourceV2"
0x00025d58  adrp     x2, #0x75000
0x00025d5c  add      x2, x2, #0x28   ; STR "com.anlai.omnicar"
0x00025d60  mov      x1, x21
0x00025d64  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x00025d68  adrp     x2, #0x7a000
0x00025d6c  add      x2, x2, #0x168   ; STR "speedBubbleWarnModeV2"
0x00025d70  adrp     x3, #0x74000
0x00025d74  ldr      x3, [x3, #0x1b0]   ; @GOT ___kCFBooleanFalse
0x00025d78  mov      x0, x19
0x00025d7c  bl       #0x598c0   ; CALL objc_msgSend$prefForKey:def:
0x00025d80  mov      x29, x29
0x00025d84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025d88  mov      x22, x0
0x00025d8c  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00025d90  mov      x23, x0
0x00025d94  mov      x0, x22
0x00025d98  bl       #0x55d78   ; CALL _objc_release
0x00025d9c  tbnz     w23, #0, #0x25e0c
0x00025da0  adrp     x2, #0x7a000
0x00025da4  add      x2, x2, #0x188   ; STR "speedBubbleWarnMode"
0x00025da8  mov      x0, x19
0x00025dac  mov      x3, #0
0x00025db0  bl       #0x598c0   ; CALL objc_msgSend$prefForKey:def:
0x00025db4  mov      x29, x29
0x00025db8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025dbc  mov      x22, x0
0x00025dc0  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x00025dc4  mov      x23, x0
0x00025dc8  mov      x0, x22
0x00025dcc  bl       #0x55d78   ; CALL _objc_release
0x00025dd0  cmp      x23, #2
0x00025dd4  b.ne     #0x25df4
0x00025dd8  adrp     x0, #0x7a000
0x00025ddc  add      x0, x0, #0x188   ; STR "speedBubbleWarnMode"
0x00025de0  adrp     x1, #0x80000
0x00025de4  add      x1, x1, #0x2b0
0x00025de8  adrp     x2, #0x75000
0x00025dec  add      x2, x2, #0x28   ; STR "com.anlai.omnicar"
0x00025df0  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x00025df4  adrp     x0, #0x7a000
0x00025df8  add      x0, x0, #0x168   ; STR "speedBubbleWarnModeV2"
0x00025dfc  adrp     x2, #0x75000
0x00025e00  add      x2, x2, #0x28   ; STR "com.anlai.omnicar"
0x00025e04  mov      x1, x21
0x00025e08  bl       #0x55874   ; CALL _CFPreferencesSetAppValue
0x00025e0c  adrp     x0, #0x75000
0x00025e10  add      x0, x0, #0x28   ; STR "com.anlai.omnicar"
0x00025e14  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x00025e18  adrp     x8, #0x8e000
0x00025e1c  ldr      x8, [x8, #0xd60]   ; @SUPER OMCSpeedBubbleController
0x00025e20  stp      x19, x8, [sp]
0x00025e24  adrp     x8, #0x8b000
0x00025e28  ldr      x1, [x8, #0xda0]   ; @SEL "viewDidLoad"
0x00025e2c  mov      x0, sp
0x00025e30  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00025e34  mov      x0, x19
0x00025e38  bl       #0x5db40   ; CALL objc_msgSend$title
0x00025e3c  mov      x29, x29
0x00025e40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025e44  mov      x21, x0
0x00025e48  bl       #0x58c20   ; CALL objc_msgSend$length
0x00025e4c  mov      x22, x0
0x00025e50  mov      x0, x21
0x00025e54  bl       #0x55d78   ; CALL _objc_release
0x00025e58  cbnz     x22, #0x25e88
0x00025e5c  adrp     x0, #0x7a000
0x00025e60  add      x0, x0, #0x1a8   ; STR "SPEEDBUBBLE"
0x00025e64  bl       #0x17e20   ; CALL _L
0x00025e68  mov      x29, x29
0x00025e6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025e70  mov      x21, x0
0x00025e74  mov      x0, x19
0x00025e78  mov      x2, x21
0x00025e7c  bl       #0x5c5e0   ; CALL objc_msgSend$setTitle:
0x00025e80  mov      x0, x21
0x00025e84  bl       #0x55d78   ; CALL _objc_release
0x00025e88  mov      x0, x20
0x00025e8c  bl       #0x55d78   ; CALL _objc_release
0x00025e90  ldp      x29, x30, [sp, #0x40]
0x00025e94  ldp      x20, x19, [sp, #0x30]
0x00025e98  ldp      x22, x21, [sp, #0x20]
0x00025e9c  ldp      x24, x23, [sp, #0x10]
0x00025ea0  add      sp, sp, #0x50
0x00025ea4  ret      

=== -[OMCSpeedBubbleController viewDidAppear:]  va=0x25ea8 size=340 types=v20@0:8B16
0x00025ea8  sub      sp, sp, #0x70
0x00025eac  stp      x22, x21, [sp, #0x40]
0x00025eb0  stp      x20, x19, [sp, #0x50]
0x00025eb4  stp      x29, x30, [sp, #0x60]
0x00025eb8  add      x29, sp, #0x60
0x00025ebc  mov      x19, x0
0x00025ec0  adrp     x8, #0x8e000
0x00025ec4  ldr      x8, [x8, #0xd60]   ; @SUPER OMCSpeedBubbleController
0x00025ec8  stp      x0, x8, [sp, #0x30]
0x00025ecc  adrp     x8, #0x8b000
0x00025ed0  ldr      x1, [x8, #0xe40]   ; @SEL "viewDidAppear:"
0x00025ed4  add      x0, sp, #0x30
0x00025ed8  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x00025edc  mov      x0, x19
0x00025ee0  bl       #0x58ce0   ; CALL objc_msgSend$liveTimer
0x00025ee4  mov      x29, x29
0x00025ee8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025eec  mov      x20, x0
0x00025ef0  bl       #0x58740   ; CALL objc_msgSend$invalidate
0x00025ef4  mov      x0, x20
0x00025ef8  bl       #0x55d78   ; CALL _objc_release
0x00025efc  bl       #0x55808   ; CALL _CACurrentMediaTime
0x00025f00  mov      x0, x19
0x00025f04  bl       #0x5b400   ; CALL objc_msgSend$setLiveStart:
0x00025f08  add      x0, sp, #0x28
0x00025f0c  mov      x1, x19
0x00025f10  bl       #0x55d18   ; CALL _objc_initWeak
0x00025f14  adrp     x8, #0x8e000
0x00025f18  adrp     x9, #0x74000
0x00025f1c  ldr      x9, [x9, #0x378]   ; @GOT __NSConcreteStackBlock
0x00025f20  ldr      x20, [x8, #0xb90]   ; @CLASS NSTimer
0x00025f24  str      x9, [sp]
0x00025f28  adrp     x8, #0x65000
0x00025f2c  ldr      d0, [x8, #0x600]
0x00025f30  adrp     x8, #0x25000
0x00025f34  add      x8, x8, #0xfd0
0x00025f38  str      d0, [sp, #8]
0x00025f3c  adrp     x9, #0x74000
0x00025f40  add      x9, x9, #0xb50
0x00025f44  stp      x8, x9, [sp, #0x10]
0x00025f48  mov      x21, sp
0x00025f4c  add      x0, x21, #0x20
0x00025f50  add      x1, sp, #0x28
0x00025f54  bl       #0x55cd0   ; CALL _objc_copyWeak
0x00025f58  adrp     x8, #0x65000
0x00025f5c  ldr      d0, [x8, #0x6d8]
0x00025f60  mov      x3, sp
0x00025f64  mov      x0, x20
0x00025f68  mov      w2, #1
0x00025f6c  bl       #0x5a0e0   ; CALL objc_msgSend$scheduledTimerWithTimeInterval:repeats:block:
0x00025f70  mov      x29, x29
0x00025f74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00025f78  mov      x20, x0
0x00025f7c  mov      x0, x19
0x00025f80  mov      x2, x20
0x00025f84  bl       #0x5b420   ; CALL objc_msgSend$setLiveTimer:
0x00025f88  mov      x0, x20
0x00025f8c  bl       #0x55d78   ; CALL _objc_release
0x00025f90  add      x0, x21, #0x20
0x00025f94  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00025f98  add      x0, sp, #0x28
0x00025f9c  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00025fa0  ldp      x29, x30, [sp, #0x60]
0x00025fa4  ldp      x20, x19, [sp, #0x50]
0x00025fa8  ldp      x22, x21, [sp, #0x40]
0x00025fac  add      sp, sp, #0x70
0x00025fb0  ret      
0x00025fb4  mov      x19, x0
0x00025fb8  add      x0, x21, #0x20
0x00025fbc  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00025fc0  add      x0, sp, #0x28
0x00025fc4  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00025fc8  mov      x0, x19
0x00025fcc  bl       #0x55b80   ; CALL __Unwind_Resume
0x00025fd0  stp      x20, x19, [sp, #-0x20]!
0x00025fd4  stp      x29, x30, [sp, #0x10]
0x00025fd8  add      x29, sp, #0x10
0x00025fdc  add      x0, x0, #0x20
0x00025fe0  bl       #0x55d24   ; CALL _objc_loadWeakRetained
0x00025fe4  mov      x19, x0
0x00025fe8  bl       #0x5da20   ; CALL objc_msgSend$tickLive
0x00025fec  mov      x0, x19
0x00025ff0  ldp      x29, x30, [sp, #0x10]
0x00025ff4  ldp      x20, x19, [sp], #0x20
0x00025ff8  b        #0x55d78   ; CALL _objc_release

=== -[OMCSpeedBubbleController viewWillDisappear:]  va=0x25ffc size=108 types=v20@0:8B16
0x00025ffc  sub      sp, sp, #0x30
0x00026000  stp      x20, x19, [sp, #0x10]
0x00026004  stp      x29, x30, [sp, #0x20]
0x00026008  add      x29, sp, #0x20
0x0002600c  mov      x19, x0
0x00026010  adrp     x8, #0x8e000
0x00026014  ldr      x8, [x8, #0xd60]   ; @SUPER OMCSpeedBubbleController
0x00026018  stp      x0, x8, [sp]
0x0002601c  adrp     x8, #0x8b000
0x00026020  ldr      x1, [x8, #0xe08]   ; @SEL "viewWillDisappear:"
0x00026024  mov      x0, sp
0x00026028  bl       #0x55d3c   ; CALL _objc_msgSendSuper2
0x0002602c  mov      x0, x19
0x00026030  bl       #0x58ce0   ; CALL objc_msgSend$liveTimer
0x00026034  mov      x29, x29
0x00026038  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002603c  mov      x20, x0
0x00026040  bl       #0x58740   ; CALL objc_msgSend$invalidate
0x00026044  mov      x0, x20
0x00026048  bl       #0x55d78   ; CALL _objc_release
0x0002604c  mov      x0, x19
0x00026050  mov      x2, #0
0x00026054  bl       #0x5b420   ; CALL objc_msgSend$setLiveTimer:
0x00026058  ldp      x29, x30, [sp, #0x20]
0x0002605c  ldp      x20, x19, [sp, #0x10]
0x00026060  add      sp, sp, #0x30
0x00026064  ret      

=== -[OMCSpeedBubbleController on]  va=0x26068 size=76 types=B16@0:8
0x00026068  stp      x20, x19, [sp, #-0x20]!
0x0002606c  stp      x29, x30, [sp, #0x10]
0x00026070  add      x29, sp, #0x10
0x00026074  adrp     x2, #0x78000
0x00026078  add      x2, x2, #0x3e8   ; STR "speedBubbleEnabled"
0x0002607c  adrp     x3, #0x74000
0x00026080  ldr      x3, [x3, #0x1b8]   ; @GOT ___kCFBooleanTrue
0x00026084  bl       #0x598c0   ; CALL objc_msgSend$prefForKey:def:
0x00026088  mov      x29, x29
0x0002608c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026090  mov      x19, x0
0x00026094  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00026098  mov      x20, x0
0x0002609c  mov      x0, x19
0x000260a0  bl       #0x55d78   ; CALL _objc_release
0x000260a4  mov      x0, x20
0x000260a8  ldp      x29, x30, [sp, #0x10]
0x000260ac  ldp      x20, x19, [sp], #0x20
0x000260b0  ret      

=== -[OMCSpeedBubbleController style]  va=0x260b4 size=40 types=q16@0:8
0x000260b4  stp      x29, x30, [sp, #-0x10]!
0x000260b8  mov      x29, sp
0x000260bc  adrp     x2, #0x7a000
0x000260c0  add      x2, x2, #0x1c8   ; STR "speedBubbleLook"
0x000260c4  mov      x3, #0
0x000260c8  bl       #0x58700   ; CALL objc_msgSend$intForKey:def:
0x000260cc  cmp      x0, #9
0x000260d0  csel     x0, x0, xzr, lo
0x000260d4  ldp      x29, x30, [sp], #0x10
0x000260d8  ret      

=== -[OMCSpeedBubbleController source]  va=0x260dc size=76 types=q16@0:8
0x000260dc  stp      x20, x19, [sp, #-0x20]!
0x000260e0  stp      x29, x30, [sp, #0x10]
0x000260e4  add      x29, sp, #0x10
0x000260e8  adrp     x2, #0x76000
0x000260ec  add      x2, x2, #0xae8   ; STR "speedBubbleSource"
0x000260f0  mov      x3, #0
0x000260f4  bl       #0x58700   ; CALL objc_msgSend$intForKey:def:
0x000260f8  tbnz     x0, #0x3f, #0x26118
0x000260fc  mov      x19, x0
0x00026100  adrp     x0, #0x7f000
0x00026104  add      x0, x0, #0xae0
0x00026108  bl       #0x573c0   ; CALL objc_msgSend$count
0x0002610c  cmp      x19, x0
0x00026110  csel     x0, x19, xzr, lt
0x00026114  b        #0x2611c
0x00026118  mov      x0, #0
0x0002611c  ldp      x29, x30, [sp, #0x10]
0x00026120  ldp      x20, x19, [sp], #0x20
0x00026124  ret      

=== -[OMCSpeedBubbleController showIcon]  va=0x26128 size=76 types=B16@0:8
0x00026128  stp      x20, x19, [sp, #-0x20]!
0x0002612c  stp      x29, x30, [sp, #0x10]
0x00026130  add      x29, sp, #0x10
0x00026134  adrp     x2, #0x7a000
0x00026138  add      x2, x2, #0x1e8   ; STR "speedBubbleShowAppIcon"
0x0002613c  adrp     x3, #0x74000
0x00026140  ldr      x3, [x3, #0x1b8]   ; @GOT ___kCFBooleanTrue
0x00026144  bl       #0x598c0   ; CALL objc_msgSend$prefForKey:def:
0x00026148  mov      x29, x29
0x0002614c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026150  mov      x19, x0
0x00026154  bl       #0x569c0   ; CALL objc_msgSend$boolValue
0x00026158  mov      x20, x0
0x0002615c  mov      x0, x19
0x00026160  bl       #0x55d78   ; CALL _objc_release
0x00026164  mov      x0, x20
0x00026168  ldp      x29, x30, [sp, #0x10]
0x0002616c  ldp      x20, x19, [sp], #0x20
0x00026170  ret      

=== -[OMCSpeedBubbleController warnMode]  va=0x26174 size=52 types=q16@0:8
0x00026174  stp      x20, x19, [sp, #-0x20]!
0x00026178  stp      x29, x30, [sp, #0x10]
0x0002617c  add      x29, sp, #0x10
0x00026180  adrp     x2, #0x7a000
0x00026184  add      x2, x2, #0x188   ; STR "speedBubbleWarnMode"
0x00026188  mov      w19, #3
0x0002618c  mov      w3, #3
0x00026190  bl       #0x58700   ; CALL objc_msgSend$intForKey:def:
0x00026194  cmp      x0, #3
0x00026198  csel     x0, x0, x19, lo
0x0002619c  ldp      x29, x30, [sp, #0x10]
0x000261a0  ldp      x20, x19, [sp], #0x20
0x000261a4  ret      

=== -[OMCSpeedBubbleController ranged:def:count:]  va=0x261a8 size=48 types=q40@0:8@16q24q32
0x000261a8  stp      x20, x19, [sp, #-0x20]!
0x000261ac  stp      x29, x30, [sp, #0x10]
0x000261b0  add      x29, sp, #0x10
0x000261b4  mov      x19, x4
0x000261b8  mov      x20, x3
0x000261bc  bl       #0x58700   ; CALL objc_msgSend$intForKey:def:
0x000261c0  cmp      x0, x19
0x000261c4  ccmn     x0, #1, #4, lt
0x000261c8  csel     x0, x0, x20, gt
0x000261cc  ldp      x29, x30, [sp, #0x10]
0x000261d0  ldp      x20, x19, [sp], #0x20
0x000261d4  ret      

=== -[OMCSpeedBubbleController color]  va=0x261d8 size=20 types=q16@0:8
0x000261d8  adrp     x2, #0x7a000
0x000261dc  add      x2, x2, #0x208   ; STR "speedBubbleColor"
0x000261e0  mov      x3, #0
0x000261e4  mov      w4, #7
0x000261e8  b        #0x59b80   ; CALL objc_msgSend$ranged:def:count:

=== -[OMCSpeedBubbleController warnFx]  va=0x261ec size=20 types=q16@0:8
0x000261ec  adrp     x2, #0x7a000
0x000261f0  add      x2, x2, #0x228   ; STR "speedBubbleWarnFx"
0x000261f4  mov      x3, #0
0x000261f8  mov      w4, #4
0x000261fc  b        #0x59b80   ; CALL objc_msgSend$ranged:def:count:

=== -[OMCSpeedBubbleController voiceSound]  va=0x26200 size=44 types=B16@0:8
0x00026200  stp      x29, x30, [sp, #-0x10]!
0x00026204  mov      x29, sp
0x00026208  adrp     x2, #0x7a000
0x0002620c  add      x2, x2, #0x248   ; STR "speedBubbleWarnSound"
0x00026210  mov      x3, #0
0x00026214  mov      w4, #2
0x00026218  bl       #0x59b80   ; CALL objc_msgSend$ranged:def:count:
0x0002621c  cmp      x0, #1
0x00026220  cset     w0, eq
0x00026224  ldp      x29, x30, [sp], #0x10
0x00026228  ret      

=== -[OMCSpeedBubbleController tone]  va=0x2622c size=20 types=q16@0:8
0x0002622c  adrp     x2, #0x7a000
0x00026230  add      x2, x2, #0x268   ; STR "speedBubbleWarnTone"
0x00026234  mov      x3, #0
0x00026238  mov      w4, #6
0x0002623c  b        #0x59b80   ; CALL objc_msgSend$ranged:def:count:

=== -[OMCSpeedBubbleController voiceLine]  va=0x26240 size=20 types=q16@0:8
0x00026240  adrp     x2, #0x7a000
0x00026244  add      x2, x2, #0x288   ; STR "speedBubbleWarnVoice"
0x00026248  mov      x3, #0
0x0002624c  mov      w4, #9
0x00026250  b        #0x59b80   ; CALL objc_msgSend$ranged:def:count:

=== -[OMCSpeedBubbleController voiceText]  va=0x26254 size=112 types=@16@0:8
0x00026254  stp      x20, x19, [sp, #-0x20]!
0x00026258  stp      x29, x30, [sp, #0x10]
0x0002625c  add      x29, sp, #0x10
0x00026260  adrp     x2, #0x7a000
0x00026264  add      x2, x2, #0x2a8   ; STR "speedBubbleWarnVoiceText"
0x00026268  adrp     x19, #0x75000
0x0002626c  add      x19, x19, #0xd28
0x00026270  mov      x3, x19
0x00026274  bl       #0x598c0   ; CALL objc_msgSend$prefForKey:def:
0x00026278  mov      x29, x29
0x0002627c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026280  mov      x20, x0
0x00026284  adrp     x8, #0x8e000
0x00026288  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0002628c  bl       #0x55d48   ; CALL _objc_opt_class
0x00026290  mov      x1, x0
0x00026294  mov      x0, x20
0x00026298  bl       #0x55d54   ; CALL _objc_opt_isKindOfClass
0x0002629c  tst      w0, #1
0x000262a0  csel     x19, x20, x19, ne
0x000262a4  mov      x0, x19
0x000262a8  bl       #0x55d84   ; CALL _objc_retain
0x000262ac  mov      x0, x20
0x000262b0  bl       #0x55d78   ; CALL _objc_release
0x000262b4  mov      x0, x19
0x000262b8  ldp      x29, x30, [sp, #0x10]
0x000262bc  ldp      x20, x19, [sp], #0x20
0x000262c0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCSpeedBubbleController shownLimit]  va=0x262c4 size=8 types=i16@0:8
0x000262c4  mov      w0, #0x3c
0x000262c8  ret      

=== -[OMCSpeedBubbleController sourceHint]  va=0x262cc size=148 types=@16@0:8
0x000262cc  sub      sp, sp, #0x40
0x000262d0  stp      x22, x21, [sp, #0x10]
0x000262d4  stp      x20, x19, [sp, #0x20]
0x000262d8  stp      x29, x30, [sp, #0x30]
0x000262dc  add      x29, sp, #0x30
0x000262e0  adrp     x8, #0x8e000
0x000262e4  ldr      x19, [x8, #0x958]   ; @CLASS NSString
0x000262e8  bl       #0x5cd40   ; CALL objc_msgSend$source
0x000262ec  str      x0, [sp]
0x000262f0  adrp     x2, #0x7a000
0x000262f4  add      x2, x2, #0x2e8   ; STR "SPEEDBUBBLE_SRC_HINT_%ld"
0x000262f8  mov      x0, x19
0x000262fc  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00026300  mov      x29, x29
0x00026304  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026308  mov      x19, x0
0x0002630c  bl       #0x17e20   ; CALL _L
0x00026310  mov      x29, x29
0x00026314  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026318  mov      x20, x0
0x0002631c  adrp     x0, #0x7a000
0x00026320  add      x0, x0, #0x2c8   ; STR "ⓘ  "
0x00026324  mov      x2, x20
0x00026328  bl       #0x5d440   ; CALL objc_msgSend$stringByAppendingString:
0x0002632c  mov      x29, x29
0x00026330  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026334  mov      x21, x0
0x00026338  mov      x0, x20
0x0002633c  bl       #0x55d78   ; CALL _objc_release
0x00026340  mov      x0, x19
0x00026344  bl       #0x55d78   ; CALL _objc_release
0x00026348  mov      x0, x21
0x0002634c  ldp      x29, x30, [sp, #0x30]
0x00026350  ldp      x20, x19, [sp, #0x20]
0x00026354  ldp      x22, x21, [sp, #0x10]
0x00026358  add      sp, sp, #0x40
0x0002635c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCSpeedBubbleController sourceName:]  va=0x26360 size=12 types=@24@0:8q16
0x00026360  adrp     x0, #0x7f000
0x00026364  add      x0, x0, #0xaf8
0x00026368  b        #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:

=== -[OMCSpeedBubbleController configure:style:speed:limit:]  va=0x2636c size=1132 types=v40@0:8@16q24i32i36
0x0002636c  stp      x24, x23, [sp, #-0x40]!
0x00026370  stp      x22, x21, [sp, #0x10]
0x00026374  stp      x20, x19, [sp, #0x20]
0x00026378  stp      x29, x30, [sp, #0x30]
0x0002637c  add      x29, sp, #0x30
0x00026380  mov      x20, x5
0x00026384  mov      x21, x4
0x00026388  mov      x22, x3
0x0002638c  mov      x19, x2
0x00026390  mov      x23, x0
0x00026394  mov      x0, x2
0x00026398  bl       #0x55d84   ; CALL _objc_retain
0x0002639c  mov      x0, x19
0x000263a0  mov      x2, x22
0x000263a4  bl       #0x5c3e0   ; CALL objc_msgSend$setStyle:
0x000263a8  mov      x0, x19
0x000263ac  mov      x2, x21
0x000263b0  bl       #0x5c280   ; CALL objc_msgSend$setSpeed:
0x000263b4  mov      x0, x19
0x000263b8  mov      x2, x20
0x000263bc  bl       #0x5b2e0   ; CALL objc_msgSend$setLimit:
0x000263c0  mov      x0, x23
0x000263c4  bl       #0x5ca20   ; CALL objc_msgSend$showIcon
0x000263c8  mov      x2, x0
0x000263cc  mov      x0, x19
0x000263d0  bl       #0x5c0e0   ; CALL objc_msgSend$setShowIcon:
0x000263d4  mov      x0, x23
0x000263d8  bl       #0x5cd40   ; CALL objc_msgSend$source
0x000263dc  bl       #0x2642c
0x000263e0  mov      x29, x29
0x000263e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000263e8  mov      x20, x0
0x000263ec  mov      x0, x19
0x000263f0  mov      x2, x20
0x000263f4  bl       #0x5b040   ; CALL objc_msgSend$setIconImage:
0x000263f8  mov      x0, x20
0x000263fc  bl       #0x55d78   ; CALL _objc_release
0x00026400  mov      x0, x23
0x00026404  bl       #0x56e60   ; CALL objc_msgSend$color
0x00026408  mov      x2, x0
0x0002640c  mov      x0, x19
0x00026410  bl       #0x5a8e0   ; CALL objc_msgSend$setColor:
0x00026414  mov      x0, x19
0x00026418  ldp      x29, x30, [sp, #0x30]
0x0002641c  ldp      x20, x19, [sp, #0x20]
0x00026420  ldp      x22, x21, [sp, #0x10]
0x00026424  ldp      x24, x23, [sp], #0x40
0x00026428  b        #0x55d78   ; CALL _objc_release
0x0002642c  sub      sp, sp, #0xc0
0x00026430  stp      x28, x27, [sp, #0x60]
0x00026434  stp      x26, x25, [sp, #0x70]
0x00026438  stp      x24, x23, [sp, #0x80]
0x0002643c  stp      x22, x21, [sp, #0x90]
0x00026440  stp      x20, x19, [sp, #0xa0]
0x00026444  stp      x29, x30, [sp, #0xb0]
0x00026448  add      x29, sp, #0xb0
0x0002644c  mov      x19, x0
0x00026450  adrp     x8, #0x74000
0x00026454  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00026458  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002645c  str      x8, [sp, #0x58]
0x00026460  adrp     x28, #0x90000
0x00026464  ldr      x20, [x28, #0x40]
0x00026468  cbnz     x20, #0x26494
0x0002646c  adrp     x8, #0x8e000
0x00026470  ldr      x0, [x8, #0x9d0]   ; @CLASS NSMutableDictionary
0x00026474  bl       #0x57780   ; CALL objc_msgSend$dictionary
0x00026478  mov      x29, x29
0x0002647c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026480  ldr      x8, [x28, #0x40]
0x00026484  str      x0, [x28, #0x40]
0x00026488  mov      x0, x8
0x0002648c  bl       #0x55d78   ; CALL _objc_release
0x00026490  ldr      x20, [x28, #0x40]
0x00026494  adrp     x24, #0x8e000
0x00026498  ldr      x0, [x24, #0x928]   ; @CLASS NSNumber
0x0002649c  mov      x2, x19
0x000264a0  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x000264a4  mov      x29, x29
0x000264a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000264ac  mov      x21, x0
0x000264b0  mov      x0, x20
0x000264b4  mov      x2, x21
0x000264b8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000264bc  mov      x29, x29
0x000264c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000264c4  mov      x20, x0
0x000264c8  bl       #0x55d78   ; CALL _objc_release
0x000264cc  mov      x0, x21
0x000264d0  bl       #0x55d78   ; CALL _objc_release
0x000264d4  cbz      x20, #0x26514
0x000264d8  ldr      x20, [x28, #0x40]
0x000264dc  ldr      x0, [x24, #0x928]   ; @CLASS NSNumber
0x000264e0  mov      x2, x19
0x000264e4  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x000264e8  mov      x29, x29
0x000264ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000264f0  mov      x19, x0
0x000264f4  mov      x0, x20
0x000264f8  mov      x2, x19
0x000264fc  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00026500  mov      x29, x29
0x00026504  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026508  mov      x22, x0
0x0002650c  mov      x0, x19
0x00026510  b        #0x26794
0x00026514  tbnz     x19, #0x3f, #0x2654c
0x00026518  adrp     x0, #0x7f000
0x0002651c  add      x0, x0, #0xb58
0x00026520  bl       #0x573c0   ; CALL objc_msgSend$count
0x00026524  cmp      x19, x0
0x00026528  b.ge     #0x2654c
0x0002652c  adrp     x0, #0x7f000
0x00026530  add      x0, x0, #0xb58
0x00026534  mov      x2, x19
0x00026538  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0002653c  mov      x29, x29
0x00026540  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026544  mov      x20, x0
0x00026548  b        #0x26554
0x0002654c  adrp     x20, #0x75000
0x00026550  add      x20, x20, #0xd28
0x00026554  mov      x0, x20
0x00026558  bl       #0x58c20   ; CALL objc_msgSend$length
0x0002655c  cbz      x0, #0x265c0
0x00026560  adrp     x21, #0x8e000
0x00026564  ldr      x0, [x21, #0xa78]   ; @CLASS UIImage
0x00026568  adrp     x8, #0x8b000
0x0002656c  ldr      x1, [x8, #0xf88]   ; @SEL "_applicationIconImageForBundleIdentifier:format:scale:"
0x00026570  bl       #0x55d6c   ; CALL _objc_opt_respondsToSelector
0x00026574  tbz      w0, #0, #0x265c0
0x00026578  ldr      x21, [x21, #0xa78]   ; @CLASS UIImage
0x0002657c  adrp     x8, #0x8e000
0x00026580  ldr      x0, [x8, #0xb40]   ; @CLASS UIScreen
0x00026584  bl       #0x58f00   ; CALL objc_msgSend$mainScreen
0x00026588  mov      x29, x29
0x0002658c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026590  mov      x23, x0
0x00026594  bl       #0x5a060   ; CALL objc_msgSend$scale
0x00026598  mov      x0, x21
0x0002659c  mov      x2, x20
0x000265a0  mov      w3, #2
0x000265a4  bl       #0x55f60   ; CALL objc_msgSend$_applicationIconImageForBundleIdentifier:format:scale:
0x000265a8  mov      x29, x29
0x000265ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000265b0  mov      x22, x0
0x000265b4  mov      x0, x23
0x000265b8  bl       #0x55d78   ; CALL _objc_release
0x000265bc  cbnz     x22, #0x2675c
0x000265c0  adrp     x0, #0x7a000
0x000265c4  add      x0, x0, #0xd88   ; STR "#F07A12"
0x000265c8  bl       #0x18080   ; CALL _OMCColorFromHex
0x000265cc  mov      x29, x29
0x000265d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000265d4  mov      x22, x0
0x000265d8  str      x0, [sp, #0x38]
0x000265dc  adrp     x0, #0x7a000
0x000265e0  add      x0, x0, #0xda8   ; STR "#1AA260"
0x000265e4  bl       #0x18080   ; CALL _OMCColorFromHex
0x000265e8  mov      x29, x29
0x000265ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000265f0  mov      x23, x0
0x000265f4  str      x0, [sp, #0x40]
0x000265f8  adrp     x0, #0x7a000
0x000265fc  add      x0, x0, #0xdc8   ; STR "#33CCFF"
0x00026600  bl       #0x18080   ; CALL _OMCColorFromHex
0x00026604  mov      x29, x29
0x00026608  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002660c  mov      x24, x0
0x00026610  str      x0, [sp, #0x48]
0x00026614  adrp     x0, #0x7a000
0x00026618  add      x0, x0, #0xde8   ; STR "#E5322D"
0x0002661c  bl       #0x18080   ; CALL _OMCColorFromHex
0x00026620  mov      x29, x29
0x00026624  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026628  mov      x25, x0
0x0002662c  str      x0, [sp, #0x50]
0x00026630  adrp     x8, #0x8e000
0x00026634  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00026638  add      x2, sp, #0x38
0x0002663c  mov      w3, #4
0x00026640  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00026644  mov      x29, x29
0x00026648  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002664c  mov      x26, x0
0x00026650  bic      x8, x19, x19, asr #63
0x00026654  cmp      x8, #3
0x00026658  mov      w9, #3
0x0002665c  csel     x27, x8, x9, lt
0x00026660  mov      x2, x27
0x00026664  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00026668  mov      x29, x29
0x0002666c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026670  mov      x21, x0
0x00026674  mov      x0, x26
0x00026678  bl       #0x55d78   ; CALL _objc_release
0x0002667c  mov      x0, x25
0x00026680  bl       #0x55d78   ; CALL _objc_release
0x00026684  mov      x0, x24
0x00026688  bl       #0x55d78   ; CALL _objc_release
0x0002668c  mov      x0, x23
0x00026690  bl       #0x55d78   ; CALL _objc_release
0x00026694  mov      x0, x22
0x00026698  bl       #0x55d78   ; CALL _objc_release
0x0002669c  adrp     x0, #0x7f000
0x000266a0  add      x0, x0, #0xb40
0x000266a4  mov      x2, x27
0x000266a8  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000266ac  mov      x29, x29
0x000266b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000266b4  mov      x23, x0
0x000266b8  adrp     x8, #0x8e000
0x000266bc  ldr      x0, [x8, #0xb00]   ; @CLASS UIGraphicsImageRenderer
0x000266c0  bl       #0x55c7c   ; CALL _objc_alloc
0x000266c4  mov      x8, #0x404e000000000000
0x000266c8  fmov     d0, x8
0x000266cc  mov      v1.16b, v0.16b
0x000266d0  bl       #0x58540   ; CALL objc_msgSend$initWithSize:
0x000266d4  mov      x24, x0
0x000266d8  adrp     x8, #0x74000
0x000266dc  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x000266e0  str      x8, [sp, #8]
0x000266e4  adrp     x8, #0x65000
0x000266e8  ldr      d0, [x8, #0x600]
0x000266ec  str      d0, [sp, #0x10]
0x000266f0  adrp     x8, #0x2c000
0x000266f4  add      x8, x8, #0x238
0x000266f8  adrp     x9, #0x74000
0x000266fc  add      x9, x9, #0x8c0
0x00026700  stp      x8, x9, [sp, #0x18]
0x00026704  stp      x21, x23, [sp, #0x28]
0x00026708  mov      x0, x23
0x0002670c  bl       #0x55d84   ; CALL _objc_retain
0x00026710  mov      x0, x21
0x00026714  bl       #0x55d84   ; CALL _objc_retain
0x00026718  add      x2, sp, #8
0x0002671c  mov      x0, x24
0x00026720  bl       #0x58140   ; CALL objc_msgSend$imageWithActions:
0x00026724  mov      x29, x29
0x00026728  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002672c  mov      x22, x0
0x00026730  mov      x0, x24
0x00026734  adrp     x24, #0x8e000
0x00026738  bl       #0x55d78   ; CALL _objc_release
0x0002673c  ldr      x0, [sp, #0x30]
0x00026740  bl       #0x55d78   ; CALL _objc_release
0x00026744  ldr      x0, [sp, #0x28]
0x00026748  bl       #0x55d78   ; CALL _objc_release
0x0002674c  mov      x0, x23
0x00026750  bl       #0x55d78   ; CALL _objc_release
0x00026754  mov      x0, x21
0x00026758  bl       #0x55d78   ; CALL _objc_release
0x0002675c  ldr      x21, [x28, #0x40]
0x00026760  ldr      x0, [x24, #0x928]   ; @CLASS NSNumber
0x00026764  mov      x2, x19
0x00026768  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x0002676c  mov      x29, x29
0x00026770  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026774  mov      x19, x0
0x00026778  mov      x0, x21
0x0002677c  mov      x2, x22
0x00026780  mov      x3, x19
0x00026784  bl       #0x5b8a0   ; CALL objc_msgSend$setObject:forKeyedSubscript:
0x00026788  mov      x0, x19
0x0002678c  bl       #0x55d78   ; CALL _objc_release
0x00026790  mov      x0, x20
0x00026794  bl       #0x55d78   ; CALL _objc_release
0x00026798  ldr      x8, [sp, #0x58]
0x0002679c  adrp     x9, #0x74000
0x000267a0  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000267a4  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000267a8  cmp      x9, x8
0x000267ac  b.ne     #0x267d4
0x000267b0  mov      x0, x22
0x000267b4  ldp      x29, x30, [sp, #0xb0]
0x000267b8  ldp      x20, x19, [sp, #0xa0]
0x000267bc  ldp      x22, x21, [sp, #0x90]
0x000267c0  ldp      x24, x23, [sp, #0x80]
0x000267c4  ldp      x26, x25, [sp, #0x70]
0x000267c8  ldp      x28, x27, [sp, #0x60]
0x000267cc  add      sp, sp, #0xc0
0x000267d0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x000267d4  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCSpeedBubbleController tickLive]  va=0x267d8 size=660 types=v16@0:8
0x000267d8  stp      d9, d8, [sp, #-0x40]!
0x000267dc  stp      x22, x21, [sp, #0x10]
0x000267e0  stp      x20, x19, [sp, #0x20]
0x000267e4  stp      x29, x30, [sp, #0x30]
0x000267e8  add      x29, sp, #0x30
0x000267ec  mov      x19, x0
0x000267f0  bl       #0x58c80   ; CALL objc_msgSend$live
0x000267f4  mov      x29, x29
0x000267f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000267fc  mov      x20, x0
0x00026800  bl       #0x5e1e0   ; CALL objc_msgSend$window
0x00026804  mov      x29, x29
0x00026808  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002680c  mov      x21, x0
0x00026810  bl       #0x55d78   ; CALL _objc_release
0x00026814  mov      x0, x20
0x00026818  bl       #0x55d78   ; CALL _objc_release
0x0002681c  cbz      x21, #0x2690c
0x00026820  bl       #0x55808   ; CALL _CACurrentMediaTime
0x00026824  mov      v8.16b, v0.16b
0x00026828  mov      x0, x19
0x0002682c  bl       #0x58cc0   ; CALL objc_msgSend$liveStart
0x00026830  fsub     d0, d8, d0
0x00026834  adrp     x8, #0x65000
0x00026838  ldr      d1, [x8, #0x6c0]
0x0002683c  fmul     d0, d0, d1
0x00026840  bl       #0x55bc8   ; CALL _cos
0x00026844  fmov     d1, #0.50000000
0x00026848  fmov     d2, #-0.50000000
0x0002684c  fmadd    d0, d0, d2, d1
0x00026850  adrp     x8, #0x65000
0x00026854  ldr      d1, [x8, #0x838]
0x00026858  adrp     x8, #0x65000
0x0002685c  ldr      d2, [x8, #0x998]
0x00026860  fmadd    d0, d0, d2, d1
0x00026864  mov      x8, #0x404e000000000000
0x00026868  fmov     d1, x8
0x0002686c  fmul     d0, d0, d1
0x00026870  fcvtas   x20, d0
0x00026874  mov      x0, x19
0x00026878  bl       #0x58c80   ; CALL objc_msgSend$live
0x0002687c  mov      x29, x29
0x00026880  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026884  mov      x21, x0
0x00026888  mov      x0, x19
0x0002688c  bl       #0x5d620   ; CALL objc_msgSend$style
0x00026890  mov      x3, x0
0x00026894  mov      x0, x19
0x00026898  mov      x2, x21
0x0002689c  mov      x4, x20
0x000268a0  mov      w5, #0x3c
0x000268a4  bl       #0x57120   ; CALL objc_msgSend$configure:style:speed:limit:
0x000268a8  mov      x0, x21
0x000268ac  bl       #0x55d78   ; CALL _objc_release
0x000268b0  mov      x0, x19
0x000268b4  bl       #0x58c80   ; CALL objc_msgSend$live
0x000268b8  mov      x29, x29
0x000268bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000268c0  mov      x20, x0
0x000268c4  mov      x0, x19
0x000268c8  bl       #0x58ca0   ; CALL objc_msgSend$liveMap
0x000268cc  mov      x29, x29
0x000268d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000268d4  mov      x19, x0
0x000268d8  bl       #0x57d00   ; CALL objc_msgSend$frame
0x000268dc  adrp     x8, #0x65000
0x000268e0  ldr      d4, [x8, #0x9a0]
0x000268e4  mov      x0, x20
0x000268e8  bl       #0x26920
0x000268ec  mov      x0, x19
0x000268f0  bl       #0x55d78   ; CALL _objc_release
0x000268f4  mov      x0, x20
0x000268f8  ldp      x29, x30, [sp, #0x30]
0x000268fc  ldp      x20, x19, [sp, #0x20]
0x00026900  ldp      x22, x21, [sp, #0x10]
0x00026904  ldp      d9, d8, [sp], #0x40
0x00026908  b        #0x55d78   ; CALL _objc_release
0x0002690c  ldp      x29, x30, [sp, #0x30]
0x00026910  ldp      x20, x19, [sp, #0x20]
0x00026914  ldp      x22, x21, [sp, #0x10]
0x00026918  ldp      d9, d8, [sp], #0x40
0x0002691c  ret      
0x00026920  sub      sp, sp, #0xc0
0x00026924  stp      d15, d14, [sp, #0x60]
0x00026928  stp      d13, d12, [sp, #0x70]
0x0002692c  stp      d11, d10, [sp, #0x80]
0x00026930  stp      d9, d8, [sp, #0x90]
0x00026934  stp      x20, x19, [sp, #0xa0]
0x00026938  stp      x29, x30, [sp, #0xb0]
0x0002693c  add      x29, sp, #0xb0
0x00026940  mov      v14.16b, v4.16b
0x00026944  mov      v8.16b, v3.16b
0x00026948  mov      v9.16b, v2.16b
0x0002694c  mov      v10.16b, v1.16b
0x00026950  mov      v11.16b, v0.16b
0x00026954  mov      x19, x0
0x00026958  bl       #0x55d84   ; CALL _objc_retain
0x0002695c  mov      x0, x19
0x00026960  bl       #0x59e80   ; CALL objc_msgSend$render
0x00026964  mov      v12.16b, v0.16b
0x00026968  fmov     d0, #1.00000000
0x0002696c  fcmp     d12, d0
0x00026970  fccmp    d1, d0, #8, pl
0x00026974  b.mi     #0x26a44
0x00026978  mov      v13.16b, v1.16b
0x0002697c  fmov     d0, #-12.00000000
0x00026980  fadd     d1, d9, d0
0x00026984  fdiv     d1, d1, d12
0x00026988  fadd     d0, d8, d0
0x0002698c  fdiv     d0, d0, d13
0x00026990  fcmp     d1, d0
0x00026994  fcsel    d0, d1, d0, mi
0x00026998  fcmp     d14, d0
0x0002699c  fcsel    d14, d14, d0, mi
0x000269a0  adrp     x8, #0x74000
0x000269a4  ldr      x8, [x8, #0x498]   ; @GOT _CGAffineTransformIdentity
0x000269a8  ldp      q0, q1, [x8]
0x000269ac  stp      q0, q1, [sp, #0x30]
0x000269b0  ldr      q0, [x8, #0x20]   ; @GOT _objc_autoreleasePoolPop
0x000269b4  str      q0, [sp, #0x50]
0x000269b8  add      x2, sp, #0x30
0x000269bc  mov      x0, x19
0x000269c0  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x000269c4  fmov     d0, xzr
0x000269c8  fmov     d1, xzr
0x000269cc  mov      x0, x19
0x000269d0  mov      v2.16b, v12.16b
0x000269d4  mov      v3.16b, v13.16b
0x000269d8  bl       #0x5a760   ; CALL objc_msgSend$setBounds:
0x000269dc  mov      v0.16b, v11.16b
0x000269e0  mov      v1.16b, v10.16b
0x000269e4  mov      v2.16b, v9.16b
0x000269e8  mov      v3.16b, v8.16b
0x000269ec  bl       #0x55a60   ; CALL _CGRectGetMidX
0x000269f0  mov      v12.16b, v0.16b
0x000269f4  mov      v0.16b, v11.16b
0x000269f8  mov      v1.16b, v10.16b
0x000269fc  mov      v2.16b, v9.16b
0x00026a00  mov      v3.16b, v8.16b
0x00026a04  bl       #0x55a6c   ; CALL _CGRectGetMidY
0x00026a08  mov      v1.16b, v0.16b
0x00026a0c  mov      x0, x19
0x00026a10  mov      v0.16b, v12.16b
0x00026a14  bl       #0x5a840   ; CALL objc_msgSend$setCenter:
0x00026a18  mov      x8, sp
0x00026a1c  mov      v0.16b, v14.16b
0x00026a20  mov      v1.16b, v14.16b
0x00026a24  bl       #0x5588c   ; CALL _CGAffineTransformMakeScale
0x00026a28  ldp      q0, q1, [sp]
0x00026a2c  stp      q0, q1, [sp, #0x30]
0x00026a30  ldr      q0, [sp, #0x20]
0x00026a34  str      q0, [sp, #0x50]
0x00026a38  add      x2, sp, #0x30
0x00026a3c  mov      x0, x19
0x00026a40  bl       #0x5c6a0   ; CALL objc_msgSend$setTransform:
0x00026a44  mov      x0, x19
0x00026a48  bl       #0x55d78   ; CALL _objc_release
0x00026a4c  ldp      x29, x30, [sp, #0xb0]
0x00026a50  ldp      x20, x19, [sp, #0xa0]
0x00026a54  ldp      d9, d8, [sp, #0x90]
0x00026a58  ldp      d11, d10, [sp, #0x80]
0x00026a5c  ldp      d13, d12, [sp, #0x70]
0x00026a60  ldp      d15, d14, [sp, #0x60]
0x00026a64  add      sp, sp, #0xc0
0x00026a68  ret      

=== -[OMCSpeedBubbleController prefChanged:]  va=0x26a6c size=324 types=v24@0:8@16
0x00026a6c  stp      x22, x21, [sp, #-0x30]!
0x00026a70  stp      x20, x19, [sp, #0x10]
0x00026a74  stp      x29, x30, [sp, #0x20]
0x00026a78  add      x29, sp, #0x20
0x00026a7c  mov      x19, x2
0x00026a80  mov      x20, x0
0x00026a84  mov      x0, x2
0x00026a88  bl       #0x55d84   ; CALL _objc_retain
0x00026a8c  adrp     x2, #0x78000
0x00026a90  add      x2, x2, #0x3e8   ; STR "speedBubbleEnabled"
0x00026a94  mov      x0, x19
0x00026a98  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00026a9c  cbz      w0, #0x26ac4
0x00026aa0  mov      x0, x20
0x00026aa4  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x00026aa8  mov      x29, x29
0x00026aac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026ab0  mov      x20, x0
0x00026ab4  bl       #0x59ca0   ; CALL objc_msgSend$reloadData
0x00026ab8  mov      x0, x20
0x00026abc  bl       #0x55d78   ; CALL _objc_release
0x00026ac0  b        #0x26b9c
0x00026ac4  adrp     x2, #0x7a000
0x00026ac8  add      x2, x2, #0x1e8   ; STR "speedBubbleShowAppIcon"
0x00026acc  mov      x0, x19
0x00026ad0  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00026ad4  cbz      w0, #0x26b0c
0x00026ad8  mov      x0, x20
0x00026adc  bl       #0x5d660   ; CALL objc_msgSend$styleStrip
0x00026ae0  mov      x29, x29
0x00026ae4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026ae8  mov      x21, x0
0x00026aec  bl       #0x57240   ; CALL objc_msgSend$contentOffset
0x00026af0  mov      x0, x20
0x00026af4  bl       #0x5c340   ; CALL objc_msgSend$setStripOffset:
0x00026af8  mov      x0, x21
0x00026afc  bl       #0x55d78   ; CALL _objc_release
0x00026b00  mov      x0, x20
0x00026b04  mov      w2, #2
0x00026b08  bl       #0x59ce0   ; CALL objc_msgSend$reloadSection:
0x00026b0c  adrp     x2, #0x7a000
0x00026b10  add      x2, x2, #0x208   ; STR "speedBubbleColor"
0x00026b14  mov      x0, x19
0x00026b18  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00026b1c  cbz      w0, #0x26b54
0x00026b20  mov      x0, x20
0x00026b24  bl       #0x5d660   ; CALL objc_msgSend$styleStrip
0x00026b28  mov      x29, x29
0x00026b2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026b30  mov      x21, x0
0x00026b34  bl       #0x57240   ; CALL objc_msgSend$contentOffset
0x00026b38  mov      x0, x20
0x00026b3c  bl       #0x5c340   ; CALL objc_msgSend$setStripOffset:
0x00026b40  mov      x0, x21
0x00026b44  bl       #0x55d78   ; CALL _objc_release
0x00026b48  mov      x0, x20
0x00026b4c  mov      w2, #2
0x00026b50  bl       #0x59ce0   ; CALL objc_msgSend$reloadSection:
0x00026b54  adrp     x0, #0x7f000
0x00026b58  add      x0, x0, #0xb10
0x00026b5c  mov      x2, x19
0x00026b60  bl       #0x571c0   ; CALL objc_msgSend$containsObject:
0x00026b64  cbz      w0, #0x26b74
0x00026b68  mov      x0, x20
0x00026b6c  mov      w2, #5
0x00026b70  bl       #0x59ce0   ; CALL objc_msgSend$reloadSection:
0x00026b74  adrp     x2, #0x7a000
0x00026b78  add      x2, x2, #0x308   ; STR "speedBubbleWarnOver"
0x00026b7c  mov      x0, x19
0x00026b80  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00026b84  cbz      w0, #0x26b94
0x00026b88  mov      x0, x20
0x00026b8c  mov      w2, #5
0x00026b90  bl       #0x59ce0   ; CALL objc_msgSend$reloadSection:
0x00026b94  mov      x0, x20
0x00026b98  bl       #0x5da20   ; CALL objc_msgSend$tickLive
0x00026b9c  mov      x0, x19
0x00026ba0  ldp      x29, x30, [sp, #0x20]
0x00026ba4  ldp      x20, x19, [sp, #0x10]
0x00026ba8  ldp      x22, x21, [sp], #0x30
0x00026bac  b        #0x55d78   ; CALL _objc_release

=== -[OMCSpeedBubbleController numberOfSectionsInTableView:]  va=0x26bb0 size=8 types=q24@0:8@16
0x00026bb0  mov      w0, #6
0x00026bb4  ret      

=== -[OMCSpeedBubbleController tableView:numberOfRowsInSection:]  va=0x26bb8 size=112 types=q32@0:8@16q24
0x00026bb8  sub      x8, x3, #2
0x00026bbc  cmp      x8, #2
0x00026bc0  b.lo     #0x26c10
0x00026bc4  cmp      x3, #4
0x00026bc8  b.eq     #0x26c18
0x00026bcc  cmp      x3, #5
0x00026bd0  b.ne     #0x26c20
0x00026bd4  stp      x20, x19, [sp, #-0x20]!
0x00026bd8  stp      x29, x30, [sp, #0x10]
0x00026bdc  add      x29, sp, #0x10
0x00026be0  bl       #0x56ae0   ; CALL objc_msgSend$buildWarnRows
0x00026be4  mov      x29, x29
0x00026be8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026bec  mov      x19, x0
0x00026bf0  bl       #0x573c0   ; CALL objc_msgSend$count
0x00026bf4  mov      x20, x0
0x00026bf8  mov      x0, x19
0x00026bfc  bl       #0x55d78   ; CALL _objc_release
0x00026c00  mov      x0, x20
0x00026c04  ldp      x29, x30, [sp, #0x10]
0x00026c08  ldp      x20, x19, [sp], #0x20
0x00026c0c  ret      
0x00026c10  mov      w0, #3
0x00026c14  ret      
0x00026c18  mov      w0, #2
0x00026c1c  ret      
0x00026c20  mov      w0, #1
0x00026c24  ret      

=== -[OMCSpeedBubbleController tableView:titleForHeaderInSection:]  va=0x26c28 size=100 types=@32@0:8@16q24
0x00026c28  stp      x20, x19, [sp, #-0x20]!
0x00026c2c  stp      x29, x30, [sp, #0x10]
0x00026c30  add      x29, sp, #0x10
0x00026c34  mov      x20, x3
0x00026c38  mov      x19, x2
0x00026c3c  mov      x0, x2
0x00026c40  bl       #0x55d84   ; CALL _objc_retain
0x00026c44  sub      x8, x20, #2
0x00026c48  cmp      x8, #3
0x00026c4c  b.hi     #0x26c70
0x00026c50  adrp     x9, #0x74000
0x00026c54  add      x9, x9, #0xba0
0x00026c58  ldr      x0, [x9, x8, lsl #3]
0x00026c5c  bl       #0x17e20   ; CALL _L
0x00026c60  mov      x29, x29
0x00026c64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026c68  mov      x20, x0
0x00026c6c  b        #0x26c74
0x00026c70  mov      x20, #0
0x00026c74  mov      x0, x19
0x00026c78  bl       #0x55d78   ; CALL _objc_release
0x00026c7c  mov      x0, x20
0x00026c80  ldp      x29, x30, [sp, #0x10]
0x00026c84  ldp      x20, x19, [sp], #0x20
0x00026c88  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCSpeedBubbleController tableView:titleForFooterInSection:]  va=0x26c8c size=880 types=@32@0:8@16q24
0x00026c8c  sub      sp, sp, #0x70
0x00026c90  stp      x28, x27, [sp, #0x10]
0x00026c94  stp      x26, x25, [sp, #0x20]
0x00026c98  stp      x24, x23, [sp, #0x30]
0x00026c9c  stp      x22, x21, [sp, #0x40]
0x00026ca0  stp      x20, x19, [sp, #0x50]
0x00026ca4  stp      x29, x30, [sp, #0x60]
0x00026ca8  add      x29, sp, #0x60
0x00026cac  mov      x20, x3
0x00026cb0  mov      x19, x2
0x00026cb4  mov      x22, x0
0x00026cb8  mov      x0, x2
0x00026cbc  bl       #0x55d84   ; CALL _objc_retain
0x00026cc0  cmp      x20, #5
0x00026cc4  b.eq     #0x26cf0
0x00026cc8  cmp      x20, #3
0x00026ccc  b.eq     #0x26ce4
0x00026cd0  cmp      x20, #2
0x00026cd4  b.ne     #0x26d90
0x00026cd8  adrp     x0, #0x7a000
0x00026cdc  add      x0, x0, #0x3a8   ; STR "SPEEDBUBBLE_COLOR_FOOTER"
0x00026ce0  b        #0x26da0
0x00026ce4  adrp     x0, #0x7a000
0x00026ce8  add      x0, x0, #0x508   ; STR "SPEEDBUBBLE_GESTURES_FOOTER"
0x00026cec  b        #0x26da0
0x00026cf0  mov      x0, x22
0x00026cf4  bl       #0x5e0c0   ; CALL objc_msgSend$warnMode
0x00026cf8  cbz      x0, #0x26d98
0x00026cfc  mov      x24, x0
0x00026d00  adrp     x2, #0x7a000
0x00026d04  add      x2, x2, #0x308   ; STR "speedBubbleWarnOver"
0x00026d08  mov      x0, x22
0x00026d0c  mov      w3, #5
0x00026d10  bl       #0x58700   ; CALL objc_msgSend$intForKey:def:
0x00026d14  mov      x21, x0
0x00026d18  adrp     x28, #0x8e000
0x00026d1c  ldr      x0, [x28, #0x958]   ; @CLASS NSString
0x00026d20  cmp      x21, #0
0x00026d24  cneg     x8, x21, mi
0x00026d28  str      x8, [sp]
0x00026d2c  adrp     x2, #0x7a000
0x00026d30  add      x2, x2, #0x3e8   ; STR "%ld km/h"
0x00026d34  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00026d38  mov      x29, x29
0x00026d3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026d40  mov      x20, x0
0x00026d44  cmp      x21, #0
0x00026d48  b.le     #0x26db4
0x00026d4c  ldr      x21, [x28, #0x958]   ; @CLASS NSString
0x00026d50  adrp     x0, #0x7a000
0x00026d54  add      x0, x0, #0x408   ; STR "SPEEDBUBBLE_WARN_TH_OVER"
0x00026d58  bl       #0x17e20   ; CALL _L
0x00026d5c  mov      x29, x29
0x00026d60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026d64  mov      x23, x0
0x00026d68  str      x20, [sp]
0x00026d6c  mov      x0, x21
0x00026d70  mov      x2, x23
0x00026d74  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00026d78  mov      x29, x29
0x00026d7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026d80  mov      x21, x0
0x00026d84  mov      x0, x23
0x00026d88  bl       #0x55d78   ; CALL _objc_release
0x00026d8c  b        #0x26dd0
0x00026d90  mov      x22, #0
0x00026d94  b        #0x26fc0
0x00026d98  adrp     x0, #0x7a000
0x00026d9c  add      x0, x0, #0x3c8   ; STR "SPEEDBUBBLE_WARN_OFF_FOOTER"
0x00026da0  bl       #0x17e20   ; CALL _L
0x00026da4  mov      x29, x29
0x00026da8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026dac  mov      x22, x0
0x00026db0  b        #0x26fc0
0x00026db4  tbnz     x21, #0x3f, #0x26fec
0x00026db8  adrp     x0, #0x7a000
0x00026dbc  add      x0, x0, #0x448   ; STR "SPEEDBUBBLE_WARN_TH_AT"
0x00026dc0  bl       #0x17e20   ; CALL _L
0x00026dc4  mov      x29, x29
0x00026dc8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026dcc  mov      x21, x0
0x00026dd0  adrp     x8, #0x8e000
0x00026dd4  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00026dd8  bl       #0x565c0   ; CALL objc_msgSend$array
0x00026ddc  mov      x29, x29
0x00026de0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026de4  mov      x23, x0
0x00026de8  tbz      w24, #0, #0x26e44
0x00026dec  ldr      x25, [x28, #0x958]   ; @CLASS NSString
0x00026df0  mov      x0, x22
0x00026df4  bl       #0x5e0a0   ; CALL objc_msgSend$warnFx
0x00026df8  str      x0, [sp]
0x00026dfc  adrp     x2, #0x7a000
0x00026e00  add      x2, x2, #0x468   ; STR "SPEEDBUBBLE_FX_DESC_%ld"
0x00026e04  mov      x0, x25
0x00026e08  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00026e0c  mov      x29, x29
0x00026e10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026e14  mov      x25, x0
0x00026e18  bl       #0x17e20   ; CALL _L
0x00026e1c  mov      x29, x29
0x00026e20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026e24  mov      x26, x0
0x00026e28  mov      x0, x23
0x00026e2c  mov      x2, x26
0x00026e30  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00026e34  mov      x0, x26
0x00026e38  bl       #0x55d78   ; CALL _objc_release
0x00026e3c  mov      x0, x25
0x00026e40  bl       #0x55d78   ; CALL _objc_release
0x00026e44  tbz      w24, #1, #0x26f44
0x00026e48  mov      x0, x22
0x00026e4c  bl       #0x5dfe0   ; CALL objc_msgSend$voiceSound
0x00026e50  ldr      x26, [x28, #0x958]   ; @CLASS NSString
0x00026e54  tbz      w0, #0, #0x26ef0
0x00026e58  adrp     x0, #0x7a000
0x00026e5c  add      x0, x0, #0x488   ; STR "SPEEDBUBBLE_VOICE_DESC"
0x00026e60  bl       #0x17e20   ; CALL _L
0x00026e64  mov      x29, x29
0x00026e68  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026e6c  mov      x24, x0
0x00026e70  mov      x0, x22
0x00026e74  bl       #0x5dfc0   ; CALL objc_msgSend$voiceLine
0x00026e78  mov      x27, x0
0x00026e7c  mov      x0, x22
0x00026e80  bl       #0x5e000   ; CALL objc_msgSend$voiceText
0x00026e84  mov      x29, x29
0x00026e88  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026e8c  mov      x25, x0
0x00026e90  mov      x0, x22
0x00026e94  bl       #0x5cb40   ; CALL objc_msgSend$shownLimit
0x00026e98  mov      x2, x0
0x00026e9c  mov      x0, x27
0x00026ea0  mov      x1, x25
0x00026ea4  bl       #0x353bc   ; CALL _SPPVoiceLine
0x00026ea8  mov      x29, x29
0x00026eac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026eb0  mov      x22, x0
0x00026eb4  str      x0, [sp]
0x00026eb8  mov      x0, x26
0x00026ebc  mov      x2, x24
0x00026ec0  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00026ec4  mov      x29, x29
0x00026ec8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026ecc  mov      x26, x0
0x00026ed0  mov      x0, x23
0x00026ed4  mov      x2, x26
0x00026ed8  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00026edc  mov      x0, x26
0x00026ee0  bl       #0x55d78   ; CALL _objc_release
0x00026ee4  mov      x0, x22
0x00026ee8  bl       #0x55d78   ; CALL _objc_release
0x00026eec  b        #0x26f34
0x00026ef0  mov      x0, x22
0x00026ef4  bl       #0x5dbe0   ; CALL objc_msgSend$tone
0x00026ef8  str      x0, [sp]
0x00026efc  adrp     x2, #0x7a000
0x00026f00  add      x2, x2, #0x4a8   ; STR "SPEEDBUBBLE_TONE_DESC_%ld"
0x00026f04  mov      x0, x26
0x00026f08  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00026f0c  mov      x29, x29
0x00026f10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026f14  mov      x24, x0
0x00026f18  bl       #0x17e20   ; CALL _L
0x00026f1c  mov      x29, x29
0x00026f20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026f24  mov      x25, x0
0x00026f28  mov      x0, x23
0x00026f2c  mov      x2, x25
0x00026f30  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00026f34  mov      x0, x25
0x00026f38  bl       #0x55d78   ; CALL _objc_release
0x00026f3c  mov      x0, x24
0x00026f40  bl       #0x55d78   ; CALL _objc_release
0x00026f44  ldr      x22, [x28, #0x958]   ; @CLASS NSString
0x00026f48  adrp     x0, #0x7a000
0x00026f4c  add      x0, x0, #0x4c8   ; STR "SPEEDBUBBLE_WARN_FOOTER"
0x00026f50  bl       #0x17e20   ; CALL _L
0x00026f54  mov      x29, x29
0x00026f58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026f5c  mov      x24, x0
0x00026f60  adrp     x2, #0x7a000
0x00026f64  add      x2, x2, #0x4e8   ; STR " + "
0x00026f68  mov      x0, x23
0x00026f6c  bl       #0x57000   ; CALL objc_msgSend$componentsJoinedByString:
0x00026f70  mov      x29, x29
0x00026f74  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026f78  mov      x25, x0
0x00026f7c  stp      x21, x0, [sp]
0x00026f80  mov      x0, x22
0x00026f84  mov      x2, x24
0x00026f88  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00026f8c  mov      x29, x29
0x00026f90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00026f94  mov      x22, x0
0x00026f98  mov      x0, x25
0x00026f9c  bl       #0x55d78   ; CALL _objc_release
0x00026fa0  mov      x0, x24
0x00026fa4  bl       #0x55d78   ; CALL _objc_release
0x00026fa8  mov      x0, x23
0x00026fac  bl       #0x55d78   ; CALL _objc_release
0x00026fb0  mov      x0, x21
0x00026fb4  bl       #0x55d78   ; CALL _objc_release
0x00026fb8  mov      x0, x20
0x00026fbc  bl       #0x55d78   ; CALL _objc_release
0x00026fc0  mov      x0, x19
0x00026fc4  bl       #0x55d78   ; CALL _objc_release
0x00026fc8  mov      x0, x22
0x00026fcc  ldp      x29, x30, [sp, #0x60]
0x00026fd0  ldp      x20, x19, [sp, #0x50]
0x00026fd4  ldp      x22, x21, [sp, #0x40]
0x00026fd8  ldp      x24, x23, [sp, #0x30]
0x00026fdc  ldp      x26, x25, [sp, #0x20]
0x00026fe0  ldp      x28, x27, [sp, #0x10]
0x00026fe4  add      sp, sp, #0x70
0x00026fe8  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00026fec  ldr      x21, [x28, #0x958]   ; @CLASS NSString
0x00026ff0  adrp     x0, #0x7a000
0x00026ff4  add      x0, x0, #0x428   ; STR "SPEEDBUBBLE_WARN_TH_UNDER"
0x00026ff8  b        #0x26d58

=== -[OMCSpeedBubbleController tableView:heightForRowAtIndexPath:]  va=0x26ffc size=1068 types=d32@0:8@16@24
0x00026ffc  sub      sp, sp, #0x80
0x00027000  stp      d9, d8, [sp, #0x30]
0x00027004  stp      x24, x23, [sp, #0x40]
0x00027008  stp      x22, x21, [sp, #0x50]
0x0002700c  stp      x20, x19, [sp, #0x60]
0x00027010  stp      x29, x30, [sp, #0x70]
0x00027014  add      x29, sp, #0x70
0x00027018  mov      x19, x3
0x0002701c  mov      x21, x2
0x00027020  mov      x20, x0
0x00027024  adrp     x8, #0x74000
0x00027028  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0002702c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00027030  str      x8, [sp, #0x28]
0x00027034  mov      x0, x3
0x00027038  bl       #0x55d84   ; CALL _objc_retain
0x0002703c  mov      x0, x21
0x00027040  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00027044  mov      x8, #-0x3fbc000000000000
0x00027048  fmov     d0, x8
0x0002704c  fadd     d9, d2, d0
0x00027050  mov      x0, x19
0x00027054  bl       #0x5a180   ; CALL objc_msgSend$section
0x00027058  cbz      x0, #0x27078
0x0002705c  mov      x0, x19
0x00027060  bl       #0x5a180   ; CALL objc_msgSend$section
0x00027064  cmp      x0, #1
0x00027068  b.ne     #0x270d4
0x0002706c  mov      x8, #0x404e000000000000
0x00027070  fmov     d8, x8
0x00027074  b        #0x27094
0x00027078  adrp     x8, #0x65000
0x0002707c  ldr      d0, [x8, #0x780]
0x00027080  fmul     d0, d9, d0
0x00027084  frinta   d0, d0
0x00027088  mov      x8, #0x4060000000000000
0x0002708c  fmov     d1, x8
0x00027090  fmaxnm   d8, d0, d1
0x00027094  mov      x0, x19
0x00027098  bl       #0x55d78   ; CALL _objc_release
0x0002709c  ldr      x8, [sp, #0x28]
0x000270a0  adrp     x9, #0x74000
0x000270a4  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000270a8  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000270ac  cmp      x9, x8
0x000270b0  b.ne     #0x27424
0x000270b4  mov      v0.16b, v8.16b
0x000270b8  ldp      x29, x30, [sp, #0x70]
0x000270bc  ldp      x20, x19, [sp, #0x60]
0x000270c0  ldp      x22, x21, [sp, #0x50]
0x000270c4  ldp      x24, x23, [sp, #0x40]
0x000270c8  ldp      d9, d8, [sp, #0x30]
0x000270cc  add      sp, sp, #0x80
0x000270d0  ret      
0x000270d4  mov      x0, x19
0x000270d8  bl       #0x5a180   ; CALL objc_msgSend$section
0x000270dc  cmp      x0, #2
0x000270e0  b.ne     #0x270f0
0x000270e4  mov      x0, x19
0x000270e8  bl       #0x59f60   ; CALL objc_msgSend$row
0x000270ec  cbz      x0, #0x27180
0x000270f0  mov      x0, x19
0x000270f4  bl       #0x5a180   ; CALL objc_msgSend$section
0x000270f8  cmp      x0, #2
0x000270fc  b.ne     #0x27118
0x00027100  mov      x0, x19
0x00027104  bl       #0x59f60   ; CALL objc_msgSend$row
0x00027108  cmp      x0, #1
0x0002710c  b.ne     #0x27118
0x00027110  mov      x8, #0x4056000000000000
0x00027114  b        #0x27070
0x00027118  mov      x0, x19
0x0002711c  bl       #0x5a180   ; CALL objc_msgSend$section
0x00027120  cmp      x0, #5
0x00027124  b.ne     #0x27314
0x00027128  mov      x0, x20
0x0002712c  bl       #0x5e0e0   ; CALL objc_msgSend$warnRows
0x00027130  mov      x29, x29
0x00027134  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027138  mov      x22, x0
0x0002713c  mov      x0, x19
0x00027140  bl       #0x59f60   ; CALL objc_msgSend$row
0x00027144  mov      x2, x0
0x00027148  mov      x0, x22
0x0002714c  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00027150  mov      x29, x29
0x00027154  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027158  mov      x21, x0
0x0002715c  mov      x0, x22
0x00027160  bl       #0x55d78   ; CALL _objc_release
0x00027164  adrp     x2, #0x7a000
0x00027168  add      x2, x2, #0x528   ; STR "fx"
0x0002716c  mov      x0, x21
0x00027170  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00027174  tbz      w0, #0, #0x27188
0x00027178  mov      x8, #0x4056000000000000
0x0002717c  b        #0x271a0
0x00027180  mov      x8, #0x405c000000000000
0x00027184  b        #0x27070
0x00027188  adrp     x2, #0x7a000
0x0002718c  add      x2, x2, #0x548   ; STR "kind"
0x00027190  mov      x0, x21
0x00027194  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00027198  tbz      w0, #0, #0x271b0
0x0002719c  mov      x8, #0x4046000000000000
0x000271a0  fmov     d8, x8
0x000271a4  mov      x0, x21
0x000271a8  bl       #0x55d78   ; CALL _objc_release
0x000271ac  b        #0x27094
0x000271b0  adrp     x2, #0x7a000
0x000271b4  add      x2, x2, #0x568   ; STR "h:"
0x000271b8  mov      x0, x21
0x000271bc  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x000271c0  fmov     d8, #28.00000000
0x000271c4  tbnz     w0, #0, #0x271a4
0x000271c8  adrp     x2, #0x7a000
0x000271cc  add      x2, x2, #0x588   ; STR "tone:"
0x000271d0  mov      x0, x21
0x000271d4  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x000271d8  tbnz     w0, #0, #0x271f0
0x000271dc  adrp     x2, #0x7a000
0x000271e0  add      x2, x2, #0x5a8   ; STR "voice:"
0x000271e4  mov      x0, x21
0x000271e8  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x000271ec  cbz      w0, #0x272d8
0x000271f0  mov      x0, x20
0x000271f4  mov      x2, x21
0x000271f8  bl       #0x594a0   ; CALL objc_msgSend$optionText:
0x000271fc  mov      x29, x29
0x00027200  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027204  mov      x20, x0
0x00027208  mov      x8, #-0x3fb2000000000000
0x0002720c  fmov     d0, x8
0x00027210  fadd     d0, d9, d0
0x00027214  mov      x8, #-0x3fb7000000000000
0x00027218  fmov     d1, x8
0x0002721c  fadd     d8, d0, d1
0x00027220  adrp     x8, #0x74000
0x00027224  ldr      x8, [x8, #0x1d8]   ; @GOT _NSFontAttributeName
0x00027228  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002722c  str      x8, [sp, #0x18]
0x00027230  adrp     x8, #0x8e000
0x00027234  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x00027238  adrp     x8, #0x74000
0x0002723c  ldr      x8, [x8, #0x260]   ; @GOT _UIFontWeightSemibold
0x00027240  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x00027244  fmov     d0, #14.00000000
0x00027248  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x0002724c  mov      x29, x29
0x00027250  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027254  mov      x22, x0
0x00027258  str      x0, [sp, #0x20]
0x0002725c  adrp     x8, #0x8e000
0x00027260  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00027264  add      x2, sp, #0x20
0x00027268  add      x3, sp, #0x18
0x0002726c  mov      w4, #1
0x00027270  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00027274  mov      x29, x29
0x00027278  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002727c  mov      x23, x0
0x00027280  mov      x8, #0x4079000000000000
0x00027284  fmov     d1, x8
0x00027288  mov      x0, x20
0x0002728c  mov      v0.16b, v8.16b
0x00027290  mov      w2, #1
0x00027294  mov      x3, x23
0x00027298  mov      x4, #0
0x0002729c  bl       #0x56a20   ; CALL objc_msgSend$boundingRectWithSize:options:attributes:context:
0x000272a0  mov      v8.16b, v3.16b
0x000272a4  mov      x0, x23
0x000272a8  bl       #0x55d78   ; CALL _objc_release
0x000272ac  mov      x0, x22
0x000272b0  bl       #0x55d78   ; CALL _objc_release
0x000272b4  mov      x0, x20
0x000272b8  bl       #0x55d78   ; CALL _objc_release
0x000272bc  frintp   d0, d8
0x000272c0  fmov     d1, #22.00000000
0x000272c4  fadd     d0, d0, d1
0x000272c8  mov      x8, #0x4045000000000000
0x000272cc  fmov     d1, x8
0x000272d0  fmaxnm   d8, d0, d1
0x000272d4  b        #0x271a4
0x000272d8  adrp     x2, #0x7a000
0x000272dc  add      x2, x2, #0x5c8   ; STR "custom"
0x000272e0  mov      x0, x21
0x000272e4  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x000272e8  cbz      w0, #0x272f4
0x000272ec  mov      x8, #0x4047000000000000
0x000272f0  b        #0x271a0
0x000272f4  adrp     x2, #0x7a000
0x000272f8  add      x2, x2, #0x5e8   ; STR "sound"
0x000272fc  mov      x0, x21
0x00027300  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00027304  mov      x22, x0
0x00027308  mov      x0, x21
0x0002730c  bl       #0x55d78   ; CALL _objc_release
0x00027310  tbnz     w22, #0, #0x2706c
0x00027314  mov      x0, x19
0x00027318  bl       #0x5a180   ; CALL objc_msgSend$section
0x0002731c  cmp      x0, #4
0x00027320  b.ne     #0x27330
0x00027324  mov      x0, x19
0x00027328  bl       #0x59f60   ; CALL objc_msgSend$row
0x0002732c  cbz      x0, #0x27418
0x00027330  mov      x0, x19
0x00027334  bl       #0x5a180   ; CALL objc_msgSend$section
0x00027338  cmp      x0, #4
0x0002733c  b.ne     #0x27410
0x00027340  mov      x0, x19
0x00027344  bl       #0x59f60   ; CALL objc_msgSend$row
0x00027348  cmp      x0, #1
0x0002734c  b.ne     #0x27410
0x00027350  mov      x0, x20
0x00027354  bl       #0x5cd60   ; CALL objc_msgSend$sourceHint
0x00027358  mov      x29, x29
0x0002735c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027360  mov      x20, x0
0x00027364  mov      x8, #-0x3fc0000000000000
0x00027368  fmov     d0, x8
0x0002736c  fadd     d8, d9, d0
0x00027370  adrp     x8, #0x74000
0x00027374  ldr      x8, [x8, #0x1d8]   ; @GOT _NSFontAttributeName
0x00027378  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002737c  str      x8, [sp, #8]
0x00027380  adrp     x8, #0x8e000
0x00027384  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x00027388  fmov     d0, #12.50000000
0x0002738c  bl       #0x5d7c0   ; CALL objc_msgSend$systemFontOfSize:
0x00027390  mov      x29, x29
0x00027394  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027398  mov      x21, x0
0x0002739c  str      x0, [sp, #0x10]
0x000273a0  adrp     x8, #0x8e000
0x000273a4  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x000273a8  add      x2, sp, #0x10
0x000273ac  add      x3, sp, #8
0x000273b0  mov      w4, #1
0x000273b4  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x000273b8  mov      x29, x29
0x000273bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000273c0  mov      x22, x0
0x000273c4  mov      x8, #0x4079000000000000
0x000273c8  fmov     d1, x8
0x000273cc  mov      x0, x20
0x000273d0  mov      v0.16b, v8.16b
0x000273d4  mov      w2, #1
0x000273d8  mov      x3, x22
0x000273dc  mov      x4, #0
0x000273e0  bl       #0x56a20   ; CALL objc_msgSend$boundingRectWithSize:options:attributes:context:
0x000273e4  mov      v8.16b, v3.16b
0x000273e8  mov      x0, x22
0x000273ec  bl       #0x55d78   ; CALL _objc_release
0x000273f0  mov      x0, x21
0x000273f4  bl       #0x55d78   ; CALL _objc_release
0x000273f8  mov      x0, x20
0x000273fc  bl       #0x55d78   ; CALL _objc_release
0x00027400  frintp   d0, d8
0x00027404  fmov     d1, #20.00000000
0x00027408  fadd     d8, d0, d1
0x0002740c  b        #0x27094
0x00027410  mov      x8, #0x404a000000000000
0x00027414  b        #0x27070
0x00027418  adrp     x8, #0x65000
0x0002741c  ldr      d8, [x8, #0x9a8]
0x00027420  b        #0x27094
0x00027424  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCSpeedBubbleController tableView:cellForRowAtIndexPath:]  va=0x27428 size=4336 types=@32@0:8@16@24
0x00027428  sub      sp, sp, #0x180
0x0002742c  stp      d11, d10, [sp, #0x100]
0x00027430  stp      d9, d8, [sp, #0x110]
0x00027434  stp      x28, x27, [sp, #0x120]
0x00027438  stp      x26, x25, [sp, #0x130]
0x0002743c  stp      x24, x23, [sp, #0x140]
0x00027440  stp      x22, x21, [sp, #0x150]
0x00027444  stp      x20, x19, [sp, #0x160]
0x00027448  stp      x29, x30, [sp, #0x170]
0x0002744c  add      x29, sp, #0x170
0x00027450  mov      x20, x3
0x00027454  mov      x19, x2
0x00027458  mov      x23, x0
0x0002745c  adrp     x8, #0x74000
0x00027460  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00027464  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00027468  stur     x8, [x29, #-0x80]
0x0002746c  mov      x0, x2
0x00027470  bl       #0x55d84   ; CALL _objc_retain
0x00027474  mov      x0, x20
0x00027478  bl       #0x55d84   ; CALL _objc_retain
0x0002747c  mov      x0, x19
0x00027480  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00027484  mov      x8, #-0x3fbc000000000000
0x00027488  fmov     d0, x8
0x0002748c  fadd     d8, d2, d0
0x00027490  mov      x0, x23
0x00027494  bl       #0x59440   ; CALL objc_msgSend$on
0x00027498  mov      x22, x0
0x0002749c  mov      x0, x20
0x000274a0  bl       #0x5a180   ; CALL objc_msgSend$section
0x000274a4  cmp      x0, #1
0x000274a8  b.le     #0x27518
0x000274ac  cmp      x0, #2
0x000274b0  b.eq     #0x2766c
0x000274b4  cmp      x0, #4
0x000274b8  b.eq     #0x276d0
0x000274bc  cmp      x0, #5
0x000274c0  b.ne     #0x27fb4
0x000274c4  mov      x0, x23
0x000274c8  bl       #0x5e0e0   ; CALL objc_msgSend$warnRows
0x000274cc  mov      x29, x29
0x000274d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000274d4  mov      x24, x0
0x000274d8  mov      x0, x20
0x000274dc  bl       #0x59f60   ; CALL objc_msgSend$row
0x000274e0  mov      x2, x0
0x000274e4  mov      x0, x24
0x000274e8  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000274ec  mov      x29, x29
0x000274f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000274f4  mov      x25, x0
0x000274f8  mov      x0, x23
0x000274fc  mov      x2, x25
0x00027500  mov      v0.16b, v8.16b
0x00027504  bl       #0x5e080   ; CALL objc_msgSend$warnCell:width:
0x00027508  mov      x29, x29
0x0002750c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027510  mov      x21, x0
0x00027514  b        #0x27814
0x00027518  cbz      x0, #0x27820
0x0002751c  cmp      x0, #1
0x00027520  b.ne     #0x27fb4
0x00027524  adrp     x2, #0x7a000
0x00027528  add      x2, x2, #0x668   ; STR "enable"
0x0002752c  mov      x0, x23
0x00027530  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x00027534  mov      x29, x29
0x00027538  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002753c  mov      x21, x0
0x00027540  adrp     x0, #0x7a000
0x00027544  add      x0, x0, #0x688   ; STR "SPEEDBUBBLE_ENABLE"
0x00027548  bl       #0x17e20   ; CALL _L
0x0002754c  mov      x29, x29
0x00027550  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027554  mov      x22, x0
0x00027558  mov      x0, x21
0x0002755c  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00027560  mov      x29, x29
0x00027564  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027568  mov      x24, x0
0x0002756c  mov      x2, x22
0x00027570  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00027574  mov      x0, x24
0x00027578  bl       #0x55d78   ; CALL _objc_release
0x0002757c  mov      x0, x22
0x00027580  bl       #0x55d78   ; CALL _objc_release
0x00027584  adrp     x0, #0x7a000
0x00027588  add      x0, x0, #0x6a8   ; STR "SPEEDBUBBLE_ENABLE_SUB"
0x0002758c  bl       #0x17e20   ; CALL _L
0x00027590  mov      x29, x29
0x00027594  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027598  mov      x22, x0
0x0002759c  mov      x0, x21
0x000275a0  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x000275a4  mov      x29, x29
0x000275a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000275ac  mov      x24, x0
0x000275b0  mov      x2, x22
0x000275b4  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x000275b8  mov      x0, x24
0x000275bc  bl       #0x55d78   ; CALL _objc_release
0x000275c0  mov      x0, x22
0x000275c4  bl       #0x55d78   ; CALL _objc_release
0x000275c8  adrp     x0, #0x78000
0x000275cc  add      x0, x0, #0xf28   ; STR "#8B7CFF"
0x000275d0  bl       #0x18080   ; CALL _OMCColorFromHex
0x000275d4  mov      x29, x29
0x000275d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000275dc  mov      x22, x0
0x000275e0  adrp     x0, #0x78000
0x000275e4  add      x0, x0, #0x3a8   ; STR "speedometer"
0x000275e8  mov      x1, x22
0x000275ec  bl       #0x18144   ; CALL _OMCIcon
0x000275f0  mov      x29, x29
0x000275f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000275f8  mov      x24, x0
0x000275fc  mov      x0, x21
0x00027600  bl       #0x58120   ; CALL objc_msgSend$imageView
0x00027604  mov      x29, x29
0x00027608  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002760c  mov      x25, x0
0x00027610  mov      x2, x24
0x00027614  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00027618  mov      x0, x25
0x0002761c  bl       #0x55d78   ; CALL _objc_release
0x00027620  mov      x0, x24
0x00027624  bl       #0x55d78   ; CALL _objc_release
0x00027628  mov      x0, x22
0x0002762c  bl       #0x55d78   ; CALL _objc_release
0x00027630  adrp     x2, #0x78000
0x00027634  add      x2, x2, #0x3e8   ; STR "speedBubbleEnabled"
0x00027638  mov      x0, x23
0x0002763c  mov      w3, #1
0x00027640  bl       #0x5d780   ; CALL objc_msgSend$switchForKey:def:
0x00027644  mov      x29, x29
0x00027648  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002764c  mov      x22, x0
0x00027650  mov      x0, x23
0x00027654  mov      x2, x22
0x00027658  mov      x3, x21
0x0002765c  bl       #0x5a280   ; CALL objc_msgSend$setAccessory:onCell:
0x00027660  mov      x0, x22
0x00027664  bl       #0x55d78   ; CALL _objc_release
0x00027668  b        #0x283e0
0x0002766c  mov      x0, x20
0x00027670  bl       #0x59f60   ; CALL objc_msgSend$row
0x00027674  cbz      x0, #0x281f0
0x00027678  mov      x0, x20
0x0002767c  bl       #0x59f60   ; CALL objc_msgSend$row
0x00027680  cmp      x0, #1
0x00027684  b.ne     #0x28280
0x00027688  adrp     x2, #0x7a000
0x0002768c  add      x2, x2, #0x6e8   ; STR "color"
0x00027690  mov      x0, x23
0x00027694  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x00027698  mov      x29, x29
0x0002769c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000276a0  mov      x21, x0
0x000276a4  mov      x0, x23
0x000276a8  mov      x2, x21
0x000276ac  bl       #0x56a80   ; CALL objc_msgSend$boxInCell:
0x000276b0  mov      x29, x29
0x000276b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000276b8  mov      x24, x0
0x000276bc  mov      x0, x23
0x000276c0  mov      x2, x24
0x000276c4  mov      v0.16b, v8.16b
0x000276c8  bl       #0x58ac0   ; CALL objc_msgSend$layoutColorsIn:width:
0x000276cc  b        #0x28378
0x000276d0  mov      x0, x20
0x000276d4  bl       #0x59f60   ; CALL objc_msgSend$row
0x000276d8  cbz      x0, #0x28238
0x000276dc  adrp     x2, #0x7a000
0x000276e0  add      x2, x2, #0x768   ; STR "hint"
0x000276e4  mov      x0, x23
0x000276e8  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x000276ec  mov      x29, x29
0x000276f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000276f4  mov      x21, x0
0x000276f8  mov      x0, x23
0x000276fc  mov      x2, x21
0x00027700  bl       #0x56a80   ; CALL objc_msgSend$boxInCell:
0x00027704  mov      x29, x29
0x00027708  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002770c  mov      x24, x0
0x00027710  mov      w2, #0x48
0x00027714  bl       #0x5df80   ; CALL objc_msgSend$viewWithTag:
0x00027718  mov      x29, x29
0x0002771c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027720  mov      x25, x0
0x00027724  cbnz     x0, #0x277b4
0x00027728  adrp     x8, #0x8e000
0x0002772c  ldr      x0, [x8, #0x940]   ; @CLASS UILabel
0x00027730  bl       #0x55d60   ; CALL _objc_opt_new
0x00027734  mov      x25, x0
0x00027738  mov      w2, #0x48
0x0002773c  bl       #0x5c480   ; CALL objc_msgSend$setTag:
0x00027740  mov      x0, x25
0x00027744  mov      x2, #0
0x00027748  bl       #0x5b820   ; CALL objc_msgSend$setNumberOfLines:
0x0002774c  adrp     x8, #0x8e000
0x00027750  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x00027754  fmov     d0, #12.50000000
0x00027758  bl       #0x5d7c0   ; CALL objc_msgSend$systemFontOfSize:
0x0002775c  mov      x29, x29
0x00027760  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027764  mov      x26, x0
0x00027768  mov      x0, x25
0x0002776c  mov      x2, x26
0x00027770  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00027774  mov      x0, x26
0x00027778  bl       #0x55d78   ; CALL _objc_release
0x0002777c  adrp     x8, #0x8e000
0x00027780  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00027784  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x00027788  mov      x29, x29
0x0002778c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027790  mov      x26, x0
0x00027794  mov      x0, x25
0x00027798  mov      x2, x26
0x0002779c  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x000277a0  mov      x0, x26
0x000277a4  bl       #0x55d78   ; CALL _objc_release
0x000277a8  mov      x0, x24
0x000277ac  mov      x2, x25
0x000277b0  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x000277b4  mov      x0, x23
0x000277b8  bl       #0x5cd60   ; CALL objc_msgSend$sourceHint
0x000277bc  mov      x29, x29
0x000277c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000277c4  mov      x26, x0
0x000277c8  mov      x0, x25
0x000277cc  mov      x2, x26
0x000277d0  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x000277d4  mov      x0, x26
0x000277d8  bl       #0x55d78   ; CALL _objc_release
0x000277dc  mov      x8, #-0x3fc0000000000000
0x000277e0  fmov     d0, x8
0x000277e4  fadd     d8, d8, d0
0x000277e8  mov      x0, x23
0x000277ec  mov      x2, x19
0x000277f0  mov      x3, x20
0x000277f4  bl       #0x5d8e0   ; CALL objc_msgSend$tableView:heightForRowAtIndexPath:
0x000277f8  fmov     d1, #-16.00000000
0x000277fc  fadd     d3, d0, d1
0x00027800  fmov     d0, #16.00000000
0x00027804  fmov     d1, #8.00000000
0x00027808  mov      x0, x25
0x0002780c  mov      v2.16b, v8.16b
0x00027810  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00027814  mov      x0, x25
0x00027818  bl       #0x55d78   ; CALL _objc_release
0x0002781c  b        #0x28378
0x00027820  str      w22, [sp, #0xc]
0x00027824  adrp     x2, #0x79000
0x00027828  add      x2, x2, #0x6e8   ; STR "preview"
0x0002782c  mov      x0, x23
0x00027830  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x00027834  mov      x29, x29
0x00027838  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002783c  mov      x21, x0
0x00027840  mov      x0, x23
0x00027844  mov      x2, x21
0x00027848  bl       #0x56a80   ; CALL objc_msgSend$boxInCell:
0x0002784c  mov      x29, x29
0x00027850  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027854  mov      x28, x0
0x00027858  mov      x0, x23
0x0002785c  mov      x2, x19
0x00027860  mov      x3, x20
0x00027864  bl       #0x5d8e0   ; CALL objc_msgSend$tableView:heightForRowAtIndexPath:
0x00027868  mov      v9.16b, v0.16b
0x0002786c  mov      x0, x23
0x00027870  bl       #0x58ca0   ; CALL objc_msgSend$liveMap
0x00027874  mov      x29, x29
0x00027878  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002787c  cbz      x0, #0x278c4
0x00027880  mov      x25, x0
0x00027884  mov      x0, x23
0x00027888  bl       #0x58ca0   ; CALL objc_msgSend$liveMap
0x0002788c  mov      x29, x29
0x00027890  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027894  mov      x26, x0
0x00027898  bl       #0x5d740   ; CALL objc_msgSend$superview
0x0002789c  mov      x29, x29
0x000278a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000278a4  mov      x27, x0
0x000278a8  bl       #0x55d78   ; CALL _objc_release
0x000278ac  mov      x0, x26
0x000278b0  bl       #0x55d78   ; CALL _objc_release
0x000278b4  mov      x0, x25
0x000278b8  bl       #0x55d78   ; CALL _objc_release
0x000278bc  cmp      x27, x28
0x000278c0  b.eq     #0x27cc0
0x000278c4  movi     v0.16b, #0
0x000278c8  stp      q0, q0, [sp, #0x30]
0x000278cc  stp      q0, q0, [sp, #0x10]
0x000278d0  mov      x0, x28
0x000278d4  bl       #0x5d700   ; CALL objc_msgSend$subviews
0x000278d8  mov      x29, x29
0x000278dc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000278e0  mov      x26, x0
0x000278e4  bl       #0x572e0   ; CALL objc_msgSend$copy
0x000278e8  mov      x25, x0
0x000278ec  mov      x0, x26
0x000278f0  bl       #0x55d78   ; CALL _objc_release
0x000278f4  add      x2, sp, #0x10
0x000278f8  add      x3, sp, #0x70
0x000278fc  mov      x0, x25
0x00027900  mov      w4, #0x10
0x00027904  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00027908  cbz      x0, #0x27968
0x0002790c  mov      x26, x0
0x00027910  ldr      x8, [sp, #0x20]
0x00027914  ldr      x24, [x8]   ; @SEL "whatsNewNavigationController"
0x00027918  mov      x27, #0
0x0002791c  ldr      x8, [sp, #0x20]
0x00027920  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00027924  cmp      x8, x24
0x00027928  b.eq     #0x27934
0x0002792c  mov      x0, x25
0x00027930  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00027934  ldr      x8, [sp, #0x18]
0x00027938  ldr      x0, [x8, x27, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0002793c  bl       #0x59e00   ; CALL objc_msgSend$removeFromSuperview
0x00027940  add      x27, x27, #1
0x00027944  cmp      x26, x27
0x00027948  b.ne     #0x2791c
0x0002794c  add      x2, sp, #0x10
0x00027950  add      x3, sp, #0x70
0x00027954  mov      x0, x25
0x00027958  mov      w4, #0x10
0x0002795c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00027960  mov      x26, x0
0x00027964  cbnz     x0, #0x27918
0x00027968  mov      x0, x25
0x0002796c  bl       #0x55d78   ; CALL _objc_release
0x00027970  adrp     x8, #0x8e000
0x00027974  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x00027978  bl       #0x55d60   ; CALL _objc_opt_new
0x0002797c  mov      x25, x0
0x00027980  mov      x0, x23
0x00027984  mov      x2, x25
0x00027988  bl       #0x5b3e0   ; CALL objc_msgSend$setLiveMap:
0x0002798c  mov      x0, x25
0x00027990  bl       #0x55d78   ; CALL _objc_release
0x00027994  mov      x0, x23
0x00027998  bl       #0x58ca0   ; CALL objc_msgSend$liveMap
0x0002799c  mov      x29, x29
0x000279a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000279a4  mov      x25, x0
0x000279a8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000279ac  mov      x29, x29
0x000279b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000279b4  mov      x26, x0
0x000279b8  fmov     d0, #14.00000000
0x000279bc  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x000279c0  mov      x0, x26
0x000279c4  bl       #0x55d78   ; CALL _objc_release
0x000279c8  mov      x0, x25
0x000279cc  bl       #0x55d78   ; CALL _objc_release
0x000279d0  adrp     x8, #0x74000
0x000279d4  ldr      x8, [x8, #0x648]   ; @GOT _kCACornerCurveContinuous
0x000279d8  ldr      x25, [x8]   ; @GOT ___objc_personality_v0
0x000279dc  mov      x0, x23
0x000279e0  bl       #0x58ca0   ; CALL objc_msgSend$liveMap
0x000279e4  mov      x29, x29
0x000279e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000279ec  mov      x26, x0
0x000279f0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000279f4  mov      x29, x29
0x000279f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000279fc  mov      x27, x0
0x00027a00  mov      x2, x25
0x00027a04  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x00027a08  mov      x0, x27
0x00027a0c  bl       #0x55d78   ; CALL _objc_release
0x00027a10  mov      x0, x26
0x00027a14  bl       #0x55d78   ; CALL _objc_release
0x00027a18  mov      x0, x23
0x00027a1c  bl       #0x58ca0   ; CALL objc_msgSend$liveMap
0x00027a20  mov      x29, x29
0x00027a24  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027a28  mov      x25, x0
0x00027a2c  mov      w2, #1
0x00027a30  bl       #0x5a8a0   ; CALL objc_msgSend$setClipsToBounds:
0x00027a34  mov      x0, x25
0x00027a38  bl       #0x55d78   ; CALL _objc_release
0x00027a3c  mov      x0, x23
0x00027a40  bl       #0x58ca0   ; CALL objc_msgSend$liveMap
0x00027a44  mov      x29, x29
0x00027a48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027a4c  mov      x25, x0
0x00027a50  mov      x0, x28
0x00027a54  mov      x2, x25
0x00027a58  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00027a5c  mov      x0, x25
0x00027a60  bl       #0x55d78   ; CALL _objc_release
0x00027a64  adrp     x8, #0x8e000
0x00027a68  ldr      x0, [x8, #0xb98]   ; @CLASS SPPBubbleView
0x00027a6c  bl       #0x55c7c   ; CALL _objc_alloc
0x00027a70  adrp     x8, #0x74000
0x00027a74  ldr      x8, [x8, #0x610]   ; @GOT _CGRectZero
0x00027a78  ldp      d0, d1, [x8]
0x00027a7c  ldp      d2, d3, [x8, #0x10]
0x00027a80  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x00027a84  mov      x25, x0
0x00027a88  mov      x0, x23
0x00027a8c  mov      x2, x25
0x00027a90  bl       #0x5b3c0   ; CALL objc_msgSend$setLive:
0x00027a94  mov      x0, x25
0x00027a98  bl       #0x55d78   ; CALL _objc_release
0x00027a9c  mov      x0, x23
0x00027aa0  bl       #0x58c80   ; CALL objc_msgSend$live
0x00027aa4  mov      x29, x29
0x00027aa8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027aac  mov      x25, x0
0x00027ab0  mov      x0, x28
0x00027ab4  mov      x2, x25
0x00027ab8  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00027abc  mov      x0, x25
0x00027ac0  bl       #0x55d78   ; CALL _objc_release
0x00027ac4  adrp     x8, #0x8e000
0x00027ac8  ldr      x0, [x8, #0xa50]   ; @CLASS UIButton
0x00027acc  mov      x2, #0
0x00027ad0  bl       #0x56b80   ; CALL objc_msgSend$buttonWithType:
0x00027ad4  mov      x29, x29
0x00027ad8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027adc  mov      x25, x0
0x00027ae0  mov      w2, #0x54
0x00027ae4  bl       #0x5c480   ; CALL objc_msgSend$setTag:
0x00027ae8  adrp     x8, #0x8e000
0x00027aec  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x00027af0  adrp     x8, #0x74000
0x00027af4  ldr      x8, [x8, #0x260]   ; @GOT _UIFontWeightSemibold
0x00027af8  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x00027afc  fmov     d0, #12.50000000
0x00027b00  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x00027b04  mov      x29, x29
0x00027b08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027b0c  mov      x26, x0
0x00027b10  mov      x0, x25
0x00027b14  bl       #0x5db80   ; CALL objc_msgSend$titleLabel
0x00027b18  mov      x29, x29
0x00027b1c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027b20  mov      x27, x0
0x00027b24  mov      x2, x26
0x00027b28  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00027b2c  mov      x0, x27
0x00027b30  bl       #0x55d78   ; CALL _objc_release
0x00027b34  mov      x0, x26
0x00027b38  bl       #0x55d78   ; CALL _objc_release
0x00027b3c  adrp     x8, #0x8e000
0x00027b40  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00027b44  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x00027b48  mov      x29, x29
0x00027b4c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027b50  mov      x26, x0
0x00027b54  mov      x0, x25
0x00027b58  mov      x2, x26
0x00027b5c  mov      x3, #0
0x00027b60  bl       #0x5c620   ; CALL objc_msgSend$setTitleColor:forState:
0x00027b64  mov      x0, x26
0x00027b68  bl       #0x55d78   ; CALL _objc_release
0x00027b6c  mov      x0, x25
0x00027b70  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00027b74  mov      x29, x29
0x00027b78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027b7c  mov      x26, x0
0x00027b80  fmov     d0, #13.00000000
0x00027b84  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x00027b88  mov      x0, x26
0x00027b8c  bl       #0x55d78   ; CALL _objc_release
0x00027b90  adrp     x8, #0x8e000
0x00027b94  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x00027b98  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00027b9c  mov      x29, x29
0x00027ba0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027ba4  mov      x26, x0
0x00027ba8  fmov     d0, xzr
0x00027bac  fmov     d1, xzr
0x00027bb0  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x00027bb4  fmov     d0, #1.00000000
0x00027bb8  fmov     d1, #1.00000000
0x00027bbc  mov      x0, x26
0x00027bc0  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x00027bc4  adrp     x0, #0x7a000
0x00027bc8  add      x0, x0, #0x608   ; STR "#9B87F8"
0x00027bcc  bl       #0x18080   ; CALL _OMCColorFromHex
0x00027bd0  mov      x29, x29
0x00027bd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027bd8  mov      x27, x0
0x00027bdc  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00027be0  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00027be4  str      x0, [sp, #0x60]
0x00027be8  adrp     x0, #0x7a000
0x00027bec  add      x0, x0, #0x628   ; STR "#5DB4F6"
0x00027bf0  bl       #0x18080   ; CALL _OMCColorFromHex
0x00027bf4  mov      x29, x29
0x00027bf8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027bfc  mov      x22, x28
0x00027c00  mov      x28, x0
0x00027c04  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00027c08  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00027c0c  str      x0, [sp, #0x68]
0x00027c10  adrp     x8, #0x8e000
0x00027c14  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00027c18  add      x2, sp, #0x60
0x00027c1c  mov      w3, #2
0x00027c20  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00027c24  mov      x29, x29
0x00027c28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027c2c  mov      x24, x0
0x00027c30  mov      x0, x26
0x00027c34  mov      x2, x24
0x00027c38  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x00027c3c  mov      x0, x24
0x00027c40  bl       #0x55d78   ; CALL _objc_release
0x00027c44  mov      x0, x28
0x00027c48  mov      x28, x22
0x00027c4c  bl       #0x55d78   ; CALL _objc_release
0x00027c50  mov      x0, x27
0x00027c54  bl       #0x55d78   ; CALL _objc_release
0x00027c58  fmov     d0, #13.00000000
0x00027c5c  mov      x0, x26
0x00027c60  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x00027c64  mov      x0, x25
0x00027c68  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00027c6c  mov      x29, x29
0x00027c70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027c74  mov      x24, x0
0x00027c78  mov      x2, x26
0x00027c7c  mov      w3, #0
0x00027c80  bl       #0x58680   ; CALL objc_msgSend$insertSublayer:atIndex:
0x00027c84  mov      x0, x24
0x00027c88  bl       #0x55d78   ; CALL _objc_release
0x00027c8c  adrp     x8, #0x8b000
0x00027c90  ldr      x3, [x8, #0xe98]   ; @SEL "tryOnCar"
0x00027c94  mov      x0, x25
0x00027c98  mov      x2, x23
0x00027c9c  mov      w4, #0x40
0x00027ca0  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x00027ca4  mov      x0, x22
0x00027ca8  mov      x2, x25
0x00027cac  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00027cb0  mov      x0, x26
0x00027cb4  bl       #0x55d78   ; CALL _objc_release
0x00027cb8  mov      x0, x25
0x00027cbc  bl       #0x55d78   ; CALL _objc_release
0x00027cc0  str      x28, [sp]
0x00027cc4  fmov     d0, #-16.00000000
0x00027cc8  fadd     d8, d8, d0
0x00027ccc  fadd     d9, d9, d0
0x00027cd0  mov      x0, x23
0x00027cd4  bl       #0x58ca0   ; CALL objc_msgSend$liveMap
0x00027cd8  mov      x29, x29
0x00027cdc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027ce0  mov      x24, x0
0x00027ce4  fmov     d0, #8.00000000
0x00027ce8  fmov     d1, #8.00000000
0x00027cec  mov      v2.16b, v8.16b
0x00027cf0  mov      v3.16b, v9.16b
0x00027cf4  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00027cf8  mov      x0, x24
0x00027cfc  bl       #0x55d78   ; CALL _objc_release
0x00027d00  mov      x0, x23
0x00027d04  bl       #0x58ca0   ; CALL objc_msgSend$liveMap
0x00027d08  mov      x29, x29
0x00027d0c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027d10  mov      x24, x0
0x00027d14  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00027d18  mov      v0.16b, v2.16b
0x00027d1c  mov      v1.16b, v3.16b
0x00027d20  bl       #0x28448
0x00027d24  mov      x29, x29
0x00027d28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027d2c  mov      x25, x0
0x00027d30  mov      x0, x23
0x00027d34  bl       #0x58ca0   ; CALL objc_msgSend$liveMap
0x00027d38  mov      x29, x29
0x00027d3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027d40  mov      x26, x0
0x00027d44  mov      x2, x25
0x00027d48  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00027d4c  mov      x0, x26
0x00027d50  bl       #0x55d78   ; CALL _objc_release
0x00027d54  mov      x0, x25
0x00027d58  bl       #0x55d78   ; CALL _objc_release
0x00027d5c  mov      x0, x24
0x00027d60  bl       #0x55d78   ; CALL _objc_release
0x00027d64  ldr      w22, [sp, #0xc]
0x00027d68  cmp      w22, #0
0x00027d6c  adrp     x8, #0x65000
0x00027d70  ldr      d0, [x8, #0x780]
0x00027d74  fmov     d1, #1.00000000
0x00027d78  fcsel    d8, d1, d0, ne
0x00027d7c  mov      x0, x23
0x00027d80  bl       #0x58ca0   ; CALL objc_msgSend$liveMap
0x00027d84  mov      x29, x29
0x00027d88  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027d8c  mov      x24, x0
0x00027d90  mov      v0.16b, v8.16b
0x00027d94  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x00027d98  mov      x0, x24
0x00027d9c  bl       #0x55d78   ; CALL _objc_release
0x00027da0  mov      x0, x23
0x00027da4  bl       #0x58c80   ; CALL objc_msgSend$live
0x00027da8  mov      x29, x29
0x00027dac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027db0  mov      x24, x0
0x00027db4  eor      w2, w22, #1
0x00027db8  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x00027dbc  mov      x0, x24
0x00027dc0  bl       #0x55d78   ; CALL _objc_release
0x00027dc4  mov      x0, x28
0x00027dc8  mov      w2, #0x54
0x00027dcc  bl       #0x5df80   ; CALL objc_msgSend$viewWithTag:
0x00027dd0  mov      x29, x29
0x00027dd4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027dd8  mov      x25, x0
0x00027ddc  adrp     x0, #0x7a000
0x00027de0  add      x0, x0, #0x648   ; STR "SPEEDBUBBLE_TRY"
0x00027de4  bl       #0x17e20   ; CALL _L
0x00027de8  mov      x29, x29
0x00027dec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027df0  mov      x26, x0
0x00027df4  mov      x0, x25
0x00027df8  mov      x2, x26
0x00027dfc  mov      x3, #0
0x00027e00  bl       #0x5c600   ; CALL objc_msgSend$setTitle:forState:
0x00027e04  adrp     x8, #0x74000
0x00027e08  ldr      x8, [x8, #0x1d8]   ; @GOT _NSFontAttributeName
0x00027e0c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00027e10  str      x8, [sp, #0x50]
0x00027e14  mov      x0, x25
0x00027e18  bl       #0x5db80   ; CALL objc_msgSend$titleLabel
0x00027e1c  mov      x29, x29
0x00027e20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027e24  mov      x24, x0
0x00027e28  bl       #0x57c60   ; CALL objc_msgSend$font
0x00027e2c  mov      x29, x29
0x00027e30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027e34  mov      x27, x0
0x00027e38  str      x0, [sp, #0x58]
0x00027e3c  adrp     x8, #0x8e000
0x00027e40  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x00027e44  add      x2, sp, #0x58
0x00027e48  add      x3, sp, #0x50
0x00027e4c  mov      w4, #1
0x00027e50  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x00027e54  mov      x29, x29
0x00027e58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027e5c  mov      x28, x0
0x00027e60  mov      x0, x26
0x00027e64  mov      x2, x28
0x00027e68  bl       #0x5cc00   ; CALL objc_msgSend$sizeWithAttributes:
0x00027e6c  frintp   d0, d0
0x00027e70  fmov     d1, #24.00000000
0x00027e74  fadd     d8, d0, d1
0x00027e78  mov      x0, x28
0x00027e7c  bl       #0x55d78   ; CALL _objc_release
0x00027e80  mov      x0, x27
0x00027e84  bl       #0x55d78   ; CALL _objc_release
0x00027e88  mov      x0, x24
0x00027e8c  bl       #0x55d78   ; CALL _objc_release
0x00027e90  mov      x0, x23
0x00027e94  bl       #0x58ca0   ; CALL objc_msgSend$liveMap
0x00027e98  mov      x29, x29
0x00027e9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027ea0  mov      x27, x0
0x00027ea4  bl       #0x57d00   ; CALL objc_msgSend$frame
0x00027ea8  bl       #0x55a48   ; CALL _CGRectGetMaxX
0x00027eac  fsub     d0, d0, d8
0x00027eb0  fmov     d10, #-8.00000000
0x00027eb4  fadd     d9, d0, d10
0x00027eb8  mov      x0, x23
0x00027ebc  bl       #0x58ca0   ; CALL objc_msgSend$liveMap
0x00027ec0  mov      x29, x29
0x00027ec4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027ec8  mov      x24, x0
0x00027ecc  bl       #0x57d00   ; CALL objc_msgSend$frame
0x00027ed0  bl       #0x55a54   ; CALL _CGRectGetMaxY
0x00027ed4  fmov     d1, #-26.00000000
0x00027ed8  fadd     d0, d0, d1
0x00027edc  fadd     d1, d0, d10
0x00027ee0  fmov     d3, #26.00000000
0x00027ee4  mov      x0, x25
0x00027ee8  mov      v0.16b, v9.16b
0x00027eec  mov      v2.16b, v8.16b
0x00027ef0  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00027ef4  mov      x0, x24
0x00027ef8  bl       #0x55d78   ; CALL _objc_release
0x00027efc  mov      x0, x27
0x00027f00  bl       #0x55d78   ; CALL _objc_release
0x00027f04  mov      x0, x25
0x00027f08  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x00027f0c  mov      v8.16b, v0.16b
0x00027f10  mov      v9.16b, v1.16b
0x00027f14  mov      v10.16b, v2.16b
0x00027f18  mov      v11.16b, v3.16b
0x00027f1c  mov      x0, x25
0x00027f20  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00027f24  mov      x29, x29
0x00027f28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027f2c  mov      x24, x0
0x00027f30  bl       #0x5d6a0   ; CALL objc_msgSend$sublayers
0x00027f34  mov      x29, x29
0x00027f38  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027f3c  mov      x27, x0
0x00027f40  bl       #0x57c20   ; CALL objc_msgSend$firstObject
0x00027f44  mov      x29, x29
0x00027f48  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027f4c  mov      x28, x0
0x00027f50  mov      v0.16b, v8.16b
0x00027f54  mov      v1.16b, v9.16b
0x00027f58  mov      v2.16b, v10.16b
0x00027f5c  mov      v3.16b, v11.16b
0x00027f60  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00027f64  mov      x0, x28
0x00027f68  bl       #0x55d78   ; CALL _objc_release
0x00027f6c  mov      x0, x27
0x00027f70  bl       #0x55d78   ; CALL _objc_release
0x00027f74  mov      x0, x24
0x00027f78  bl       #0x55d78   ; CALL _objc_release
0x00027f7c  eor      w2, w22, #1
0x00027f80  mov      x0, x25
0x00027f84  bl       #0x5afe0   ; CALL objc_msgSend$setHidden:
0x00027f88  mov      x0, x23
0x00027f8c  bl       #0x5da20   ; CALL objc_msgSend$tickLive
0x00027f90  mov      x0, x21
0x00027f94  bl       #0x55d84   ; CALL _objc_retain
0x00027f98  mov      x0, x26
0x00027f9c  bl       #0x55d78   ; CALL _objc_release
0x00027fa0  mov      x0, x25
0x00027fa4  bl       #0x55d78   ; CALL _objc_release
0x00027fa8  ldr      x0, [sp]
0x00027fac  bl       #0x55d78   ; CALL _objc_release
0x00027fb0  b        #0x283e8
0x00027fb4  mov      x0, x20
0x00027fb8  bl       #0x59f60   ; CALL objc_msgSend$row
0x00027fbc  cmp      x0, #2
0x00027fc0  b.ne     #0x28094
0x00027fc4  adrp     x2, #0x7a000
0x00027fc8  add      x2, x2, #0x788   ; STR "reset"
0x00027fcc  mov      x0, x23
0x00027fd0  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x00027fd4  mov      x29, x29
0x00027fd8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027fdc  mov      x21, x0
0x00027fe0  adrp     x0, #0x7a000
0x00027fe4  add      x0, x0, #0x7a8   ; STR "SPEEDBUBBLE_RESET_LAYOUT"
0x00027fe8  bl       #0x17e20   ; CALL _L
0x00027fec  mov      x29, x29
0x00027ff0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00027ff4  mov      x23, x0
0x00027ff8  mov      x0, x21
0x00027ffc  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00028000  mov      x29, x29
0x00028004  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028008  mov      x24, x0
0x0002800c  mov      x2, x23
0x00028010  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00028014  mov      x0, x24
0x00028018  bl       #0x55d78   ; CALL _objc_release
0x0002801c  mov      x0, x23
0x00028020  bl       #0x55d78   ; CALL _objc_release
0x00028024  bl       #0x17e8c   ; CALL _OMCAccentColor
0x00028028  mov      x29, x29
0x0002802c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028030  mov      x23, x0
0x00028034  mov      x0, x21
0x00028038  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x0002803c  mov      x29, x29
0x00028040  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028044  mov      x24, x0
0x00028048  mov      x2, x23
0x0002804c  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00028050  mov      x0, x24
0x00028054  bl       #0x55d78   ; CALL _objc_release
0x00028058  mov      x0, x23
0x0002805c  bl       #0x55d78   ; CALL _objc_release
0x00028060  mov      x0, x21
0x00028064  mov      w2, #3
0x00028068  bl       #0x5bfa0   ; CALL objc_msgSend$setSelectionStyle:
0x0002806c  tbnz     w22, #0, #0x28384
0x00028070  mov      x0, x20
0x00028074  bl       #0x5a180   ; CALL objc_msgSend$section
0x00028078  cmp      x0, #2
0x0002807c  cset     w22, lt
0x00028080  adrp     x8, #0x65000
0x00028084  ldr      d0, [x8, #0x780]
0x00028088  fmov     d1, #1.00000000
0x0002808c  fcsel    d8, d1, d0, lt
0x00028090  b        #0x2838c
0x00028094  mov      x0, x20
0x00028098  bl       #0x59f60   ; CALL objc_msgSend$row
0x0002809c  adrp     x8, #0x7a000
0x000280a0  add      x8, x8, #0x7e8   ; STR "sizephone"
0x000280a4  adrp     x9, #0x7a000
0x000280a8  add      x9, x9, #0x7c8   ; STR "sizecar"
0x000280ac  cmp      x0, #0
0x000280b0  csel     x2, x9, x8, eq
0x000280b4  adrp     x8, #0x7a000
0x000280b8  add      x8, x8, #0x828   ; STR "SPEEDBUBBLE_SIZE_PHONE_SHORT"
0x000280bc  adrp     x9, #0x7a000
0x000280c0  add      x9, x9, #0x808   ; STR "SPEEDBUBBLE_SIZE_CAR_SHORT"
0x000280c4  csel     x25, x9, x8, eq
0x000280c8  adrp     x8, #0x7a000
0x000280cc  add      x8, x8, #0x848   ; STR "iphone"
0x000280d0  adrp     x9, #0x75000
0x000280d4  add      x9, x9, #0x228   ; STR "car.fill"
0x000280d8  adrp     x10, #0x7a000
0x000280dc  add      x10, x10, #0x888   ; STR "speedBubbleSizePhone"
0x000280e0  csel     x26, x9, x8, eq
0x000280e4  adrp     x8, #0x7a000
0x000280e8  add      x8, x8, #0x868   ; STR "speedBubbleSizeCar"
0x000280ec  csel     x24, x8, x10, eq
0x000280f0  mov      x0, x23
0x000280f4  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x000280f8  mov      x29, x29
0x000280fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028100  mov      x21, x0
0x00028104  mov      x0, x25
0x00028108  bl       #0x17e20   ; CALL _L
0x0002810c  mov      x29, x29
0x00028110  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028114  mov      x25, x0
0x00028118  mov      x0, x21
0x0002811c  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00028120  mov      x29, x29
0x00028124  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028128  mov      x27, x0
0x0002812c  mov      x2, x25
0x00028130  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00028134  mov      x0, x27
0x00028138  bl       #0x55d78   ; CALL _objc_release
0x0002813c  mov      x0, x25
0x00028140  bl       #0x55d78   ; CALL _objc_release
0x00028144  adrp     x0, #0x78000
0x00028148  add      x0, x0, #0xee8   ; STR "#2BC79A"
0x0002814c  bl       #0x18080   ; CALL _OMCColorFromHex
0x00028150  mov      x29, x29
0x00028154  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028158  mov      x25, x0
0x0002815c  mov      x0, x26
0x00028160  mov      x1, x25
0x00028164  bl       #0x18144   ; CALL _OMCIcon
0x00028168  mov      x29, x29
0x0002816c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028170  mov      x26, x0
0x00028174  mov      x0, x21
0x00028178  bl       #0x58120   ; CALL objc_msgSend$imageView
0x0002817c  mov      x29, x29
0x00028180  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028184  mov      x27, x0
0x00028188  mov      x2, x26
0x0002818c  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00028190  mov      x0, x27
0x00028194  bl       #0x55d78   ; CALL _objc_release
0x00028198  mov      x0, x26
0x0002819c  bl       #0x55d78   ; CALL _objc_release
0x000281a0  mov      x0, x25
0x000281a4  bl       #0x55d78   ; CALL _objc_release
0x000281a8  adrp     x8, #0x65000
0x000281ac  ldr      d0, [x8, #0x9b0]
0x000281b0  fadd     d0, d8, d0
0x000281b4  adrp     x8, #0x65000
0x000281b8  ldr      d1, [x8, #0x9b8]
0x000281bc  fcmp     d0, d1
0x000281c0  fcsel    d0, d1, d0, gt
0x000281c4  adrp     x6, #0x7a000
0x000281c8  add      x6, x6, #0x8a8   ; STR "%ld%%"
0x000281cc  mov      x0, x23
0x000281d0  mov      x2, x24
0x000281d4  mov      w3, #0x3c
0x000281d8  mov      w4, #0xdc
0x000281dc  mov      w5, #0x64
0x000281e0  bl       #0x5cc40   ; CALL objc_msgSend$sliderForKey:min:max:def:format:width:
0x000281e4  mov      x29, x29
0x000281e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000281ec  b        #0x28364
0x000281f0  adrp     x2, #0x7a000
0x000281f4  add      x2, x2, #0x6c8   ; STR "styles"
0x000281f8  mov      x0, x23
0x000281fc  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x00028200  mov      x29, x29
0x00028204  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028208  mov      x21, x0
0x0002820c  mov      x0, x23
0x00028210  mov      x2, x21
0x00028214  bl       #0x56a80   ; CALL objc_msgSend$boxInCell:
0x00028218  mov      x29, x29
0x0002821c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028220  mov      x24, x0
0x00028224  mov      x0, x23
0x00028228  mov      x2, x24
0x0002822c  mov      v0.16b, v8.16b
0x00028230  bl       #0x58ba0   ; CALL objc_msgSend$layoutStylesIn:width:
0x00028234  b        #0x28378
0x00028238  adrp     x2, #0x7a000
0x0002823c  add      x2, x2, #0x748   ; STR "sources"
0x00028240  mov      x0, x23
0x00028244  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x00028248  mov      x29, x29
0x0002824c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028250  mov      x21, x0
0x00028254  mov      x0, x23
0x00028258  mov      x2, x21
0x0002825c  bl       #0x56a80   ; CALL objc_msgSend$boxInCell:
0x00028260  mov      x29, x29
0x00028264  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028268  mov      x24, x0
0x0002826c  mov      x0, x23
0x00028270  mov      x2, x24
0x00028274  mov      v0.16b, v8.16b
0x00028278  bl       #0x58b80   ; CALL objc_msgSend$layoutSourcesIn:width:
0x0002827c  b        #0x28378
0x00028280  adrp     x2, #0x78000
0x00028284  add      x2, x2, #0x808   ; STR "icon"
0x00028288  mov      x0, x23
0x0002828c  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x00028290  mov      x29, x29
0x00028294  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028298  mov      x21, x0
0x0002829c  adrp     x0, #0x7a000
0x000282a0  add      x0, x0, #0x708   ; STR "SPEEDBUBBLE_SHOW_APP_ICON"
0x000282a4  bl       #0x17e20   ; CALL _L
0x000282a8  mov      x29, x29
0x000282ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000282b0  mov      x24, x0
0x000282b4  mov      x0, x21
0x000282b8  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x000282bc  mov      x29, x29
0x000282c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000282c4  mov      x25, x0
0x000282c8  mov      x2, x24
0x000282cc  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x000282d0  mov      x0, x25
0x000282d4  bl       #0x55d78   ; CALL _objc_release
0x000282d8  mov      x0, x24
0x000282dc  bl       #0x55d78   ; CALL _objc_release
0x000282e0  adrp     x0, #0x78000
0x000282e4  add      x0, x0, #0xec8   ; STR "#FF7FA8"
0x000282e8  bl       #0x18080   ; CALL _OMCColorFromHex
0x000282ec  mov      x29, x29
0x000282f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000282f4  mov      x24, x0
0x000282f8  adrp     x0, #0x7a000
0x000282fc  add      x0, x0, #0x728   ; STR "app.badge.fill"
0x00028300  mov      x1, x24
0x00028304  bl       #0x18144   ; CALL _OMCIcon
0x00028308  mov      x29, x29
0x0002830c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028310  mov      x25, x0
0x00028314  mov      x0, x21
0x00028318  bl       #0x58120   ; CALL objc_msgSend$imageView
0x0002831c  mov      x29, x29
0x00028320  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028324  mov      x26, x0
0x00028328  mov      x2, x25
0x0002832c  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00028330  mov      x0, x26
0x00028334  bl       #0x55d78   ; CALL _objc_release
0x00028338  mov      x0, x25
0x0002833c  bl       #0x55d78   ; CALL _objc_release
0x00028340  mov      x0, x24
0x00028344  bl       #0x55d78   ; CALL _objc_release
0x00028348  adrp     x2, #0x7a000
0x0002834c  add      x2, x2, #0x1e8   ; STR "speedBubbleShowAppIcon"
0x00028350  mov      x0, x23
0x00028354  mov      w3, #1
0x00028358  bl       #0x5d780   ; CALL objc_msgSend$switchForKey:def:
0x0002835c  mov      x29, x29
0x00028360  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028364  mov      x24, x0
0x00028368  mov      x0, x23
0x0002836c  mov      x2, x24
0x00028370  mov      x3, x21
0x00028374  bl       #0x5a280   ; CALL objc_msgSend$setAccessory:onCell:
0x00028378  mov      x0, x24
0x0002837c  bl       #0x55d78   ; CALL _objc_release
0x00028380  tbz      w22, #0, #0x28070
0x00028384  fmov     d8, #1.00000000
0x00028388  mov      w22, #1
0x0002838c  mov      x0, x21
0x00028390  bl       #0x57280   ; CALL objc_msgSend$contentView
0x00028394  mov      x29, x29
0x00028398  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002839c  mov      x23, x0
0x000283a0  mov      v0.16b, v8.16b
0x000283a4  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x000283a8  mov      x0, x23
0x000283ac  bl       #0x55d78   ; CALL _objc_release
0x000283b0  mov      x0, x21
0x000283b4  bl       #0x55f80   ; CALL objc_msgSend$accessoryView
0x000283b8  mov      x29, x29
0x000283bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000283c0  mov      x23, x0
0x000283c4  mov      v0.16b, v8.16b
0x000283c8  bl       #0x5a3e0   ; CALL objc_msgSend$setAlpha:
0x000283cc  mov      x0, x23
0x000283d0  bl       #0x55d78   ; CALL _objc_release
0x000283d4  mov      x0, x21
0x000283d8  mov      x2, x22
0x000283dc  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x000283e0  mov      x0, x21
0x000283e4  bl       #0x55d84   ; CALL _objc_retain
0x000283e8  mov      x0, x21
0x000283ec  bl       #0x55d78   ; CALL _objc_release
0x000283f0  mov      x0, x20
0x000283f4  bl       #0x55d78   ; CALL _objc_release
0x000283f8  mov      x0, x19
0x000283fc  bl       #0x55d78   ; CALL _objc_release
0x00028400  ldur     x8, [x29, #-0x80]
0x00028404  adrp     x9, #0x74000
0x00028408  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0002840c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00028410  cmp      x9, x8
0x00028414  b.ne     #0x28444
0x00028418  mov      x0, x21
0x0002841c  ldp      x29, x30, [sp, #0x170]
0x00028420  ldp      x20, x19, [sp, #0x160]
0x00028424  ldp      x22, x21, [sp, #0x150]
0x00028428  ldp      x24, x23, [sp, #0x140]
0x0002842c  ldp      x26, x25, [sp, #0x130]
0x00028430  ldp      x28, x27, [sp, #0x120]
0x00028434  ldp      d9, d8, [sp, #0x110]
0x00028438  ldp      d11, d10, [sp, #0x100]
0x0002843c  add      sp, sp, #0x180
0x00028440  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00028444  bl       #0x55b98   ; CALL ___stack_chk_fail
0x00028448  sub      sp, sp, #0x70
0x0002844c  stp      d9, d8, [sp, #0x30]
0x00028450  stp      x22, x21, [sp, #0x40]
0x00028454  stp      x20, x19, [sp, #0x50]
0x00028458  stp      x29, x30, [sp, #0x60]
0x0002845c  add      x29, sp, #0x60
0x00028460  mov      v8.16b, v1.16b
0x00028464  mov      v9.16b, v0.16b
0x00028468  adrp     x8, #0x8e000
0x0002846c  ldr      x0, [x8, #0xb58]   ; @CLASS UIGraphicsImageRendererFormat
0x00028470  bl       #0x59920   ; CALL objc_msgSend$preferredFormat
0x00028474  mov      x29, x29
0x00028478  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002847c  mov      x19, x0
0x00028480  mov      w2, #1
0x00028484  bl       #0x5b960   ; CALL objc_msgSend$setOpaque:
0x00028488  adrp     x8, #0x8e000
0x0002848c  ldr      x0, [x8, #0xb00]   ; @CLASS UIGraphicsImageRenderer
0x00028490  bl       #0x55c7c   ; CALL _objc_alloc
0x00028494  mov      v0.16b, v9.16b
0x00028498  mov      v1.16b, v8.16b
0x0002849c  mov      x2, x19
0x000284a0  bl       #0x58560   ; CALL objc_msgSend$initWithSize:format:
0x000284a4  mov      x20, x0
0x000284a8  adrp     x8, #0x74000
0x000284ac  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x000284b0  str      x8, [sp]
0x000284b4  adrp     x8, #0x65000
0x000284b8  ldr      d0, [x8, #0x6f8]
0x000284bc  str      d0, [sp, #8]
0x000284c0  adrp     x8, #0x2c000
0x000284c4  add      x8, x8, #0x38c
0x000284c8  adrp     x9, #0x74000
0x000284cc  add      x9, x9, #0xb80
0x000284d0  stp      x8, x9, [sp, #0x10]
0x000284d4  stp      d9, d8, [sp, #0x20]
0x000284d8  mov      x2, sp
0x000284dc  bl       #0x58140   ; CALL objc_msgSend$imageWithActions:
0x000284e0  mov      x29, x29
0x000284e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000284e8  mov      x21, x0
0x000284ec  mov      x0, x20
0x000284f0  bl       #0x55d78   ; CALL _objc_release
0x000284f4  mov      x0, x19
0x000284f8  bl       #0x55d78   ; CALL _objc_release
0x000284fc  mov      x0, x21
0x00028500  ldp      x29, x30, [sp, #0x60]
0x00028504  ldp      x20, x19, [sp, #0x50]
0x00028508  ldp      x22, x21, [sp, #0x40]
0x0002850c  ldp      d9, d8, [sp, #0x30]
0x00028510  add      sp, sp, #0x70
0x00028514  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCSpeedBubbleController tableView:didSelectRowAtIndexPath:]  va=0x28518 size=356 types=v32@0:8@16@24
0x00028518  stp      x24, x23, [sp, #-0x40]!
0x0002851c  stp      x22, x21, [sp, #0x10]
0x00028520  stp      x20, x19, [sp, #0x20]
0x00028524  stp      x29, x30, [sp, #0x30]
0x00028528  add      x29, sp, #0x30
0x0002852c  mov      x20, x3
0x00028530  mov      x19, x2
0x00028534  mov      x21, x0
0x00028538  mov      x0, x2
0x0002853c  bl       #0x55d84   ; CALL _objc_retain
0x00028540  mov      x0, x20
0x00028544  bl       #0x55d84   ; CALL _objc_retain
0x00028548  mov      x0, x19
0x0002854c  mov      x2, x20
0x00028550  mov      w3, #1
0x00028554  bl       #0x57740   ; CALL objc_msgSend$deselectRowAtIndexPath:animated:
0x00028558  mov      x0, x20
0x0002855c  bl       #0x5a180   ; CALL objc_msgSend$section
0x00028560  cmp      x0, #3
0x00028564  b.ne     #0x28580
0x00028568  mov      x0, x20
0x0002856c  bl       #0x59f60   ; CALL objc_msgSend$row
0x00028570  cmp      x0, #2
0x00028574  b.ne     #0x28580
0x00028578  mov      x0, x21
0x0002857c  bl       #0x59ee0   ; CALL objc_msgSend$resetLayout
0x00028580  mov      x0, x20
0x00028584  bl       #0x5a180   ; CALL objc_msgSend$section
0x00028588  cmp      x0, #5
0x0002858c  b.ne     #0x2865c
0x00028590  mov      x0, x21
0x00028594  bl       #0x5e0e0   ; CALL objc_msgSend$warnRows
0x00028598  mov      x29, x29
0x0002859c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000285a0  mov      x23, x0
0x000285a4  mov      x0, x20
0x000285a8  bl       #0x59f60   ; CALL objc_msgSend$row
0x000285ac  mov      x2, x0
0x000285b0  mov      x0, x23
0x000285b4  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x000285b8  mov      x29, x29
0x000285bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000285c0  mov      x22, x0
0x000285c4  mov      x0, x23
0x000285c8  bl       #0x55d78   ; CALL _objc_release
0x000285cc  adrp     x2, #0x7a000
0x000285d0  add      x2, x2, #0x588   ; STR "tone:"
0x000285d4  mov      x0, x22
0x000285d8  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x000285dc  tbnz     w0, #0, #0x285f4
0x000285e0  adrp     x2, #0x7a000
0x000285e4  add      x2, x2, #0x5a8   ; STR "voice:"
0x000285e8  mov      x0, x22
0x000285ec  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x000285f0  cbz      w0, #0x28600
0x000285f4  mov      x0, x21
0x000285f8  mov      x2, x22
0x000285fc  bl       #0x59700   ; CALL objc_msgSend$pickOption:
0x00028600  adrp     x2, #0x7a000
0x00028604  add      x2, x2, #0x5c8   ; STR "custom"
0x00028608  mov      x0, x22
0x0002860c  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00028610  cbz      w0, #0x28654
0x00028614  mov      x0, x19
0x00028618  mov      x2, x20
0x0002861c  bl       #0x56cc0   ; CALL objc_msgSend$cellForRowAtIndexPath:
0x00028620  mov      x29, x29
0x00028624  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028628  mov      x21, x0
0x0002862c  mov      w2, #0x56
0x00028630  bl       #0x5df80   ; CALL objc_msgSend$viewWithTag:
0x00028634  mov      x29, x29
0x00028638  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002863c  mov      x23, x0
0x00028640  bl       #0x56780   ; CALL objc_msgSend$becomeFirstResponder
0x00028644  mov      x0, x23
0x00028648  bl       #0x55d78   ; CALL _objc_release
0x0002864c  mov      x0, x21
0x00028650  bl       #0x55d78   ; CALL _objc_release
0x00028654  mov      x0, x22
0x00028658  bl       #0x55d78   ; CALL _objc_release
0x0002865c  mov      x0, x20
0x00028660  bl       #0x55d78   ; CALL _objc_release
0x00028664  mov      x0, x19
0x00028668  ldp      x29, x30, [sp, #0x30]
0x0002866c  ldp      x20, x19, [sp, #0x20]
0x00028670  ldp      x22, x21, [sp, #0x10]
0x00028674  ldp      x24, x23, [sp], #0x40
0x00028678  b        #0x55d78   ; CALL _objc_release

=== -[OMCSpeedBubbleController warnSwitchChanged:]  va=0x2867c size=180 types=v24@0:8@16
0x0002867c  stp      x24, x23, [sp, #-0x40]!
0x00028680  stp      x22, x21, [sp, #0x10]
0x00028684  stp      x20, x19, [sp, #0x20]
0x00028688  stp      x29, x30, [sp, #0x30]
0x0002868c  add      x29, sp, #0x30
0x00028690  mov      x19, x2
0x00028694  mov      x20, x0
0x00028698  mov      x0, x2
0x0002869c  bl       #0x55d84   ; CALL _objc_retain
0x000286a0  mov      x0, x19
0x000286a4  bl       #0x588c0   ; CALL objc_msgSend$isOn
0x000286a8  mov      x21, x0
0x000286ac  mov      x0, x20
0x000286b0  bl       #0x5e0c0   ; CALL objc_msgSend$warnMode
0x000286b4  mov      x22, x0
0x000286b8  mov      x0, x19
0x000286bc  bl       #0x5d920   ; CALL objc_msgSend$tag
0x000286c0  mov      x23, x0
0x000286c4  mov      x0, x19
0x000286c8  bl       #0x55d78   ; CALL _objc_release
0x000286cc  orr      x8, x23, x22
0x000286d0  bic      x9, x22, x23
0x000286d4  cmp      w21, #0
0x000286d8  csel     x2, x8, x9, ne
0x000286dc  adrp     x8, #0x8e000
0x000286e0  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x000286e4  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x000286e8  mov      x29, x29
0x000286ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000286f0  mov      x19, x0
0x000286f4  adrp     x21, #0x7a000
0x000286f8  add      x21, x21, #0x188   ; STR "speedBubbleWarnMode"
0x000286fc  mov      x0, x20
0x00028700  mov      x2, x19
0x00028704  mov      x3, x21
0x00028708  bl       #0x5d3c0   ; CALL objc_msgSend$storeValue:forKey:
0x0002870c  mov      x0, x19
0x00028710  bl       #0x55d78   ; CALL _objc_release
0x00028714  mov      x0, x20
0x00028718  mov      x2, x21
0x0002871c  ldp      x29, x30, [sp, #0x30]
0x00028720  ldp      x20, x19, [sp, #0x20]
0x00028724  ldp      x22, x21, [sp, #0x10]
0x00028728  ldp      x24, x23, [sp], #0x40
0x0002872c  b        #0x59880   ; CALL objc_msgSend$prefChanged:

=== -[OMCSpeedBubbleController buildWarnRows]  va=0x28730 size=480 types=@16@0:8
0x00028730  sub      sp, sp, #0x70
0x00028734  stp      x28, x27, [sp, #0x10]
0x00028738  stp      x26, x25, [sp, #0x20]
0x0002873c  stp      x24, x23, [sp, #0x30]
0x00028740  stp      x22, x21, [sp, #0x40]
0x00028744  stp      x20, x19, [sp, #0x50]
0x00028748  stp      x29, x30, [sp, #0x60]
0x0002874c  add      x29, sp, #0x60
0x00028750  mov      x24, x0
0x00028754  bl       #0x5e0c0   ; CALL objc_msgSend$warnMode
0x00028758  mov      x21, x0
0x0002875c  adrp     x8, #0x8e000
0x00028760  ldr      x0, [x8, #0x988]   ; @CLASS NSMutableArray
0x00028764  adrp     x2, #0x7a000
0x00028768  add      x2, x2, #0x8c8   ; STR "rim"
0x0002876c  bl       #0x56620   ; CALL objc_msgSend$arrayWithObject:
0x00028770  mov      x29, x29
0x00028774  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028778  mov      x20, x0
0x0002877c  tbz      w21, #0, #0x28790
0x00028780  adrp     x2, #0x7a000
0x00028784  add      x2, x2, #0x528   ; STR "fx"
0x00028788  mov      x0, x20
0x0002878c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00028790  adrp     x2, #0x7a000
0x00028794  add      x2, x2, #0x5e8   ; STR "sound"
0x00028798  mov      x0, x20
0x0002879c  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x000287a0  tbz      w21, #1, #0x2887c
0x000287a4  adrp     x2, #0x7a000
0x000287a8  add      x2, x2, #0x548   ; STR "kind"
0x000287ac  mov      x0, x20
0x000287b0  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x000287b4  mov      x0, x24
0x000287b8  bl       #0x5dfe0   ; CALL objc_msgSend$voiceSound
0x000287bc  tbz      w0, #0, #0x28884
0x000287c0  str      x24, [sp, #8]
0x000287c4  mov      w25, #0
0x000287c8  adrp     x26, #0x7a000
0x000287cc  add      x26, x26, #0x908   ; STR "h:fun"
0x000287d0  mov      w8, #1
0x000287d4  adrp     x27, #0x7a000
0x000287d8  add      x27, x27, #0x928   ; STR "h:serious"
0x000287dc  adrp     x28, #0x8e000
0x000287e0  adrp     x22, #0x7a000
0x000287e4  add      x22, x22, #0x948   ; STR "voice:%ld"
0x000287e8  mov      x19, x8
0x000287ec  tst      w8, #1
0x000287f0  csel     x2, x27, x26, ne
0x000287f4  mov      x0, x20
0x000287f8  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x000287fc  mov      x23, #0
0x00028800  mov      x0, x23
0x00028804  bl       #0x353ac   ; CALL _SPPVoiceIsFun
0x00028808  cmp      w25, w0
0x0002880c  b.ne     #0x28840
0x00028810  ldr      x0, [x28, #0x958]   ; @CLASS NSString
0x00028814  str      x23, [sp]
0x00028818  mov      x2, x22
0x0002881c  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00028820  mov      x29, x29
0x00028824  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028828  mov      x24, x0
0x0002882c  mov      x0, x20
0x00028830  mov      x2, x24
0x00028834  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00028838  mov      x0, x24
0x0002883c  bl       #0x55d78   ; CALL _objc_release
0x00028840  add      x23, x23, #1
0x00028844  cmp      x23, #8
0x00028848  b.ne     #0x28800
0x0002884c  mov      w8, #0
0x00028850  mov      w25, #1
0x00028854  tbnz     w19, #0, #0x287e8
0x00028858  adrp     x2, #0x7a000
0x0002885c  add      x2, x2, #0x968   ; STR "h:custom"
0x00028860  mov      x0, x20
0x00028864  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00028868  adrp     x2, #0x7a000
0x0002886c  add      x2, x2, #0x5c8   ; STR "custom"
0x00028870  mov      x0, x20
0x00028874  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x00028878  ldr      x24, [sp, #8]
0x0002887c  cbnz     x21, #0x288d0
0x00028880  b        #0x288e0
0x00028884  mov      x19, #0
0x00028888  adrp     x23, #0x8e000
0x0002888c  adrp     x21, #0x7a000
0x00028890  add      x21, x21, #0x8e8   ; STR "tone:%ld"
0x00028894  ldr      x0, [x23, #0x958]   ; @CLASS NSString
0x00028898  str      x19, [sp]
0x0002889c  mov      x2, x21
0x000288a0  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x000288a4  mov      x29, x29
0x000288a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000288ac  mov      x22, x0
0x000288b0  mov      x0, x20
0x000288b4  mov      x2, x22
0x000288b8  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x000288bc  mov      x0, x22
0x000288c0  bl       #0x55d78   ; CALL _objc_release
0x000288c4  add      x19, x19, #1
0x000288c8  cmp      x19, #6
0x000288cc  b.ne     #0x28894
0x000288d0  adrp     x2, #0x7a000
0x000288d4  add      x2, x2, #0x988   ; STR "over"
0x000288d8  mov      x0, x20
0x000288dc  bl       #0x56140   ; CALL objc_msgSend$addObject:
0x000288e0  mov      x0, x24
0x000288e4  mov      x2, x20
0x000288e8  bl       #0x5c8c0   ; CALL objc_msgSend$setWarnRows:
0x000288ec  mov      x0, x20
0x000288f0  ldp      x29, x30, [sp, #0x60]
0x000288f4  ldp      x20, x19, [sp, #0x50]
0x000288f8  ldp      x22, x21, [sp, #0x40]
0x000288fc  ldp      x24, x23, [sp, #0x30]
0x00028900  ldp      x26, x25, [sp, #0x20]
0x00028904  ldp      x28, x27, [sp, #0x10]
0x00028908  add      sp, sp, #0x70
0x0002890c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCSpeedBubbleController optionIndex:]  va=0x28910 size=108 types=q24@0:8@16
0x00028910  stp      x20, x19, [sp, #-0x20]!
0x00028914  stp      x29, x30, [sp, #0x10]
0x00028918  add      x29, sp, #0x10
0x0002891c  mov      x19, x2
0x00028920  mov      x0, x2
0x00028924  bl       #0x55d84   ; CALL _objc_retain
0x00028928  adrp     x2, #0x7a000
0x0002892c  add      x2, x2, #0x9a8   ; STR ":"
0x00028930  mov      x0, x19
0x00028934  bl       #0x59b40   ; CALL objc_msgSend$rangeOfString:
0x00028938  add      x2, x0, #1
0x0002893c  mov      x0, x19
0x00028940  bl       #0x5d6c0   ; CALL objc_msgSend$substringFromIndex:
0x00028944  mov      x29, x29
0x00028948  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002894c  mov      x20, x0
0x00028950  mov      x0, x19
0x00028954  bl       #0x55d78   ; CALL _objc_release
0x00028958  mov      x0, x20
0x0002895c  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x00028960  mov      x19, x0
0x00028964  mov      x0, x20
0x00028968  bl       #0x55d78   ; CALL _objc_release
0x0002896c  mov      x0, x19
0x00028970  ldp      x29, x30, [sp, #0x10]
0x00028974  ldp      x20, x19, [sp], #0x20
0x00028978  ret      

=== -[OMCSpeedBubbleController optionText:]  va=0x2897c size=208 types=@24@0:8@16
0x0002897c  sub      sp, sp, #0x40
0x00028980  stp      x22, x21, [sp, #0x10]
0x00028984  stp      x20, x19, [sp, #0x20]
0x00028988  stp      x29, x30, [sp, #0x30]
0x0002898c  add      x29, sp, #0x30
0x00028990  mov      x21, x2
0x00028994  mov      x20, x0
0x00028998  mov      x0, x2
0x0002899c  bl       #0x55d84   ; CALL _objc_retain
0x000289a0  mov      x0, x20
0x000289a4  mov      x2, x21
0x000289a8  bl       #0x59480   ; CALL objc_msgSend$optionIndex:
0x000289ac  mov      x19, x0
0x000289b0  adrp     x2, #0x7a000
0x000289b4  add      x2, x2, #0x588   ; STR "tone:"
0x000289b8  mov      x0, x21
0x000289bc  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x000289c0  mov      x22, x0
0x000289c4  mov      x0, x21
0x000289c8  bl       #0x55d78   ; CALL _objc_release
0x000289cc  cbz      w22, #0x28a10
0x000289d0  adrp     x8, #0x8e000
0x000289d4  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x000289d8  str      x19, [sp]
0x000289dc  adrp     x2, #0x7a000
0x000289e0  add      x2, x2, #0x9c8   ; STR "SPEEDBUBBLE_TONE_%ld"
0x000289e4  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x000289e8  mov      x29, x29
0x000289ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000289f0  mov      x20, x0
0x000289f4  bl       #0x17e20   ; CALL _L
0x000289f8  mov      x29, x29
0x000289fc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028a00  mov      x19, x0
0x00028a04  mov      x0, x20
0x00028a08  bl       #0x55d78   ; CALL _objc_release
0x00028a0c  b        #0x28a34
0x00028a10  mov      x0, x20
0x00028a14  bl       #0x5cb40   ; CALL objc_msgSend$shownLimit
0x00028a18  mov      x2, x0
0x00028a1c  mov      x0, x19
0x00028a20  mov      x1, #0
0x00028a24  bl       #0x353bc   ; CALL _SPPVoiceLine
0x00028a28  mov      x29, x29
0x00028a2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028a30  mov      x19, x0
0x00028a34  mov      x0, x19
0x00028a38  ldp      x29, x30, [sp, #0x30]
0x00028a3c  ldp      x20, x19, [sp, #0x20]
0x00028a40  ldp      x22, x21, [sp, #0x10]
0x00028a44  add      sp, sp, #0x40
0x00028a48  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCSpeedBubbleController optionChosen:]  va=0x28a4c size=160 types=B24@0:8@16
0x00028a4c  stp      x22, x21, [sp, #-0x30]!
0x00028a50  stp      x20, x19, [sp, #0x10]
0x00028a54  stp      x29, x30, [sp, #0x20]
0x00028a58  add      x29, sp, #0x20
0x00028a5c  mov      x19, x2
0x00028a60  mov      x20, x0
0x00028a64  mov      x0, x2
0x00028a68  bl       #0x55d84   ; CALL _objc_retain
0x00028a6c  adrp     x2, #0x7a000
0x00028a70  add      x2, x2, #0x5c8   ; STR "custom"
0x00028a74  mov      x0, x19
0x00028a78  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00028a7c  cbz      w0, #0x28a90
0x00028a80  mov      x0, x20
0x00028a84  bl       #0x5dfc0   ; CALL objc_msgSend$voiceLine
0x00028a88  cmp      x0, #8
0x00028a8c  b        #0x28acc
0x00028a90  adrp     x2, #0x7a000
0x00028a94  add      x2, x2, #0x588   ; STR "tone:"
0x00028a98  mov      x0, x19
0x00028a9c  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x00028aa0  cbz      w0, #0x28ab0
0x00028aa4  mov      x0, x20
0x00028aa8  bl       #0x5dbe0   ; CALL objc_msgSend$tone
0x00028aac  b        #0x28ab8
0x00028ab0  mov      x0, x20
0x00028ab4  bl       #0x5dfc0   ; CALL objc_msgSend$voiceLine
0x00028ab8  mov      x21, x0
0x00028abc  mov      x0, x20
0x00028ac0  mov      x2, x19
0x00028ac4  bl       #0x59480   ; CALL objc_msgSend$optionIndex:
0x00028ac8  cmp      x21, x0
0x00028acc  cset     w20, eq
0x00028ad0  mov      x0, x19
0x00028ad4  bl       #0x55d78   ; CALL _objc_release
0x00028ad8  mov      x0, x20
0x00028adc  ldp      x29, x30, [sp, #0x20]
0x00028ae0  ldp      x20, x19, [sp, #0x10]
0x00028ae4  ldp      x22, x21, [sp], #0x30
0x00028ae8  ret      

=== -[OMCSpeedBubbleController playIcon:]  va=0x28aec size=264 types=@20@0:8B16
0x00028aec  stp      x22, x21, [sp, #-0x30]!
0x00028af0  stp      x20, x19, [sp, #0x10]
0x00028af4  stp      x29, x30, [sp, #0x20]
0x00028af8  add      x29, sp, #0x20
0x00028afc  mov      x22, x2
0x00028b00  adrp     x8, #0x8e000
0x00028b04  ldr      x0, [x8, #0xa70]   ; @CLASS UIImageSymbolConfiguration
0x00028b08  fmov     d0, #22.00000000
0x00028b0c  mov      w2, #4
0x00028b10  bl       #0x57100   ; CALL objc_msgSend$configurationWithPointSize:weight:
0x00028b14  mov      x29, x29
0x00028b18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028b1c  mov      x19, x0
0x00028b20  adrp     x8, #0x8e000
0x00028b24  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x00028b28  bl       #0x55c7c   ; CALL _objc_alloc
0x00028b2c  mov      x20, x0
0x00028b30  adrp     x8, #0x8e000
0x00028b34  ldr      x0, [x8, #0xa78]   ; @CLASS UIImage
0x00028b38  adrp     x8, #0x7a000
0x00028b3c  add      x8, x8, #0x9e8   ; STR "play.circle"
0x00028b40  adrp     x9, #0x79000
0x00028b44  add      x9, x9, #0xa68   ; STR "play.circle.fill"
0x00028b48  cmp      w22, #0
0x00028b4c  csel     x2, x9, x8, ne
0x00028b50  mov      x3, x19
0x00028b54  bl       #0x5d840   ; CALL objc_msgSend$systemImageNamed:withConfiguration:
0x00028b58  mov      x29, x29
0x00028b5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028b60  mov      x21, x0
0x00028b64  mov      x0, x20
0x00028b68  mov      x2, x21
0x00028b6c  bl       #0x584c0   ; CALL objc_msgSend$initWithImage:
0x00028b70  mov      x20, x0
0x00028b74  mov      x0, x21
0x00028b78  bl       #0x55d78   ; CALL _objc_release
0x00028b7c  bl       #0x17e8c   ; CALL _OMCAccentColor
0x00028b80  mov      x29, x29
0x00028b84  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028b88  mov      x21, x0
0x00028b8c  tbz      w22, #0, #0x28ba0
0x00028b90  mov      x0, x20
0x00028b94  mov      x2, x21
0x00028b98  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x00028b9c  b        #0x28bd0
0x00028ba0  adrp     x8, #0x65000
0x00028ba4  ldr      d0, [x8, #0x838]
0x00028ba8  mov      x0, x21
0x00028bac  bl       #0x56e80   ; CALL objc_msgSend$colorWithAlphaComponent:
0x00028bb0  mov      x29, x29
0x00028bb4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028bb8  mov      x22, x0
0x00028bbc  mov      x0, x20
0x00028bc0  mov      x2, x22
0x00028bc4  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x00028bc8  mov      x0, x22
0x00028bcc  bl       #0x55d78   ; CALL _objc_release
0x00028bd0  mov      x0, x21
0x00028bd4  bl       #0x55d78   ; CALL _objc_release
0x00028bd8  mov      x0, x19
0x00028bdc  bl       #0x55d78   ; CALL _objc_release
0x00028be0  mov      x0, x20
0x00028be4  ldp      x29, x30, [sp, #0x20]
0x00028be8  ldp      x20, x19, [sp, #0x10]
0x00028bec  ldp      x22, x21, [sp], #0x30
0x00028bf0  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== -[OMCSpeedBubbleController warnCell:width:]  va=0x28bf4 size=2980 types=@32@0:8@16d24
0x00028bf4  sub      sp, sp, #0x150
0x00028bf8  stp      d9, d8, [sp, #0xe0]
0x00028bfc  stp      x28, x27, [sp, #0xf0]
0x00028c00  stp      x26, x25, [sp, #0x100]
0x00028c04  stp      x24, x23, [sp, #0x110]
0x00028c08  stp      x22, x21, [sp, #0x120]
0x00028c0c  stp      x20, x19, [sp, #0x130]
0x00028c10  stp      x29, x30, [sp, #0x140]
0x00028c14  add      x29, sp, #0x140
0x00028c18  mov      v8.16b, v0.16b
0x00028c1c  mov      x19, x2
0x00028c20  mov      x21, x0
0x00028c24  adrp     x8, #0x74000
0x00028c28  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x00028c2c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00028c30  stur     x8, [x29, #-0x68]
0x00028c34  mov      x0, x2
0x00028c38  bl       #0x55d84   ; CALL _objc_retain
0x00028c3c  adrp     x2, #0x7a000
0x00028c40  add      x2, x2, #0x8c8   ; STR "rim"
0x00028c44  mov      x0, x19
0x00028c48  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00028c4c  tbnz     w0, #0, #0x28c64
0x00028c50  adrp     x2, #0x7a000
0x00028c54  add      x2, x2, #0x5e8   ; STR "sound"
0x00028c58  mov      x0, x19
0x00028c5c  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00028c60  cbz      w0, #0x28e48
0x00028c64  adrp     x2, #0x7a000
0x00028c68  add      x2, x2, #0x8c8   ; STR "rim"
0x00028c6c  mov      x0, x19
0x00028c70  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00028c74  mov      x22, x0
0x00028c78  mov      x0, x21
0x00028c7c  mov      x2, x19
0x00028c80  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x00028c84  mov      x29, x29
0x00028c88  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028c8c  mov      x20, x0
0x00028c90  adrp     x8, #0x7a000
0x00028c94  add      x8, x8, #0xa28   ; STR "SPEEDBUBBLE_WARN_SHORT_2"
0x00028c98  adrp     x9, #0x7a000
0x00028c9c  add      x9, x9, #0xa08   ; STR "SPEEDBUBBLE_WARN_SHORT_1"
0x00028ca0  cmp      w22, #0
0x00028ca4  csel     x0, x9, x8, ne
0x00028ca8  bl       #0x17e20   ; CALL _L
0x00028cac  mov      x29, x29
0x00028cb0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028cb4  mov      x23, x0
0x00028cb8  mov      x0, x20
0x00028cbc  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00028cc0  mov      x29, x29
0x00028cc4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028cc8  mov      x24, x0
0x00028ccc  mov      x2, x23
0x00028cd0  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00028cd4  mov      x0, x24
0x00028cd8  bl       #0x55d78   ; CALL _objc_release
0x00028cdc  mov      x0, x23
0x00028ce0  bl       #0x55d78   ; CALL _objc_release
0x00028ce4  tbz      w22, #0, #0x28d00
0x00028ce8  adrp     x23, #0x7a000
0x00028cec  add      x23, x23, #0xa68   ; STR "rectangle.dashed"
0x00028cf0  mov      w22, #1
0x00028cf4  adrp     x0, #0x7a000
0x00028cf8  add      x0, x0, #0xaa8   ; STR "#FF5A5F"
0x00028cfc  b        #0x28d58
0x00028d00  adrp     x0, #0x7a000
0x00028d04  add      x0, x0, #0xa48   ; STR "SPEEDBUBBLE_SOUND_SUB"
0x00028d08  bl       #0x17e20   ; CALL _L
0x00028d0c  mov      x29, x29
0x00028d10  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028d14  mov      x22, x0
0x00028d18  mov      x0, x20
0x00028d1c  bl       #0x57760   ; CALL objc_msgSend$detailTextLabel
0x00028d20  mov      x29, x29
0x00028d24  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028d28  mov      x23, x0
0x00028d2c  mov      x2, x22
0x00028d30  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00028d34  mov      x0, x23
0x00028d38  bl       #0x55d78   ; CALL _objc_release
0x00028d3c  mov      x0, x22
0x00028d40  bl       #0x55d78   ; CALL _objc_release
0x00028d44  adrp     x23, #0x7a000
0x00028d48  add      x23, x23, #0xa88   ; STR "speaker.wave.2.fill"
0x00028d4c  mov      w22, #2
0x00028d50  adrp     x0, #0x78000
0x00028d54  add      x0, x0, #0xf08   ; STR "#5AB8FF"
0x00028d58  bl       #0x18080   ; CALL _OMCColorFromHex
0x00028d5c  mov      x29, x29
0x00028d60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028d64  mov      x24, x0
0x00028d68  mov      x0, x23
0x00028d6c  mov      x1, x24
0x00028d70  bl       #0x18144   ; CALL _OMCIcon
0x00028d74  mov      x29, x29
0x00028d78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028d7c  mov      x23, x0
0x00028d80  mov      x0, x20
0x00028d84  bl       #0x58120   ; CALL objc_msgSend$imageView
0x00028d88  mov      x29, x29
0x00028d8c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028d90  mov      x25, x0
0x00028d94  mov      x2, x23
0x00028d98  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00028d9c  mov      x0, x25
0x00028da0  bl       #0x55d78   ; CALL _objc_release
0x00028da4  mov      x0, x23
0x00028da8  bl       #0x55d78   ; CALL _objc_release
0x00028dac  mov      x0, x24
0x00028db0  bl       #0x55d78   ; CALL _objc_release
0x00028db4  adrp     x8, #0x8e000
0x00028db8  ldr      x0, [x8, #0x920]   ; @CLASS UISwitch
0x00028dbc  bl       #0x55d60   ; CALL _objc_opt_new
0x00028dc0  mov      x23, x0
0x00028dc4  bl       #0x17fd8   ; CALL _OMCSwitchColor
0x00028dc8  mov      x29, x29
0x00028dcc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028dd0  mov      x24, x0
0x00028dd4  mov      x0, x23
0x00028dd8  mov      x2, x24
0x00028ddc  bl       #0x5b920   ; CALL objc_msgSend$setOnTintColor:
0x00028de0  mov      x0, x24
0x00028de4  bl       #0x55d78   ; CALL _objc_release
0x00028de8  mov      x0, x23
0x00028dec  mov      x2, x22
0x00028df0  bl       #0x5c480   ; CALL objc_msgSend$setTag:
0x00028df4  mov      x0, x21
0x00028df8  bl       #0x5e0c0   ; CALL objc_msgSend$warnMode
0x00028dfc  mov      x22, x0
0x00028e00  mov      x0, x23
0x00028e04  bl       #0x5d920   ; CALL objc_msgSend$tag
0x00028e08  tst      x0, x22
0x00028e0c  cset     w2, ne
0x00028e10  mov      x0, x23
0x00028e14  bl       #0x5b900   ; CALL objc_msgSend$setOn:
0x00028e18  adrp     x8, #0x8b000
0x00028e1c  ldr      x3, [x8, #0xea0]   ; @SEL "warnSwitchChanged:"
0x00028e20  mov      x0, x23
0x00028e24  mov      x2, x21
0x00028e28  mov      w4, #0x1000
0x00028e2c  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x00028e30  mov      x0, x21
0x00028e34  mov      x2, x23
0x00028e38  mov      x3, x20
0x00028e3c  bl       #0x5a280   ; CALL objc_msgSend$setAccessory:onCell:
0x00028e40  mov      x0, x23
0x00028e44  b        #0x293c8
0x00028e48  adrp     x2, #0x7a000
0x00028e4c  add      x2, x2, #0x528   ; STR "fx"
0x00028e50  mov      x0, x19
0x00028e54  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00028e58  cbz      w0, #0x28ea4
0x00028e5c  adrp     x2, #0x7a000
0x00028e60  add      x2, x2, #0x528   ; STR "fx"
0x00028e64  mov      x0, x21
0x00028e68  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x00028e6c  mov      x29, x29
0x00028e70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028e74  mov      x20, x0
0x00028e78  mov      x0, x21
0x00028e7c  mov      x2, x20
0x00028e80  bl       #0x56a80   ; CALL objc_msgSend$boxInCell:
0x00028e84  mov      x29, x29
0x00028e88  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028e8c  mov      x22, x0
0x00028e90  mov      x0, x21
0x00028e94  mov      x2, x22
0x00028e98  mov      v0.16b, v8.16b
0x00028e9c  bl       #0x58ae0   ; CALL objc_msgSend$layoutFxIn:width:
0x00028ea0  b        #0x293c4
0x00028ea4  adrp     x2, #0x7a000
0x00028ea8  add      x2, x2, #0x548   ; STR "kind"
0x00028eac  mov      x0, x19
0x00028eb0  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00028eb4  cbz      w0, #0x29070
0x00028eb8  adrp     x2, #0x7a000
0x00028ebc  add      x2, x2, #0x548   ; STR "kind"
0x00028ec0  mov      x0, x21
0x00028ec4  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x00028ec8  mov      x29, x29
0x00028ecc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028ed0  mov      x20, x0
0x00028ed4  mov      x0, x21
0x00028ed8  mov      x2, x20
0x00028edc  bl       #0x56a80   ; CALL objc_msgSend$boxInCell:
0x00028ee0  mov      x29, x29
0x00028ee4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028ee8  mov      x22, x0
0x00028eec  movi     v0.16b, #0
0x00028ef0  stp      q0, q0, [sp]
0x00028ef4  stp      q0, q0, [sp, #0x20]
0x00028ef8  bl       #0x5d700   ; CALL objc_msgSend$subviews
0x00028efc  mov      x29, x29
0x00028f00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028f04  mov      x24, x0
0x00028f08  bl       #0x572e0   ; CALL objc_msgSend$copy
0x00028f0c  mov      x23, x0
0x00028f10  mov      x0, x24
0x00028f14  bl       #0x55d78   ; CALL _objc_release
0x00028f18  mov      x2, sp
0x00028f1c  add      x3, sp, #0x58
0x00028f20  mov      x0, x23
0x00028f24  mov      w4, #0x10
0x00028f28  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00028f2c  cbz      x0, #0x28f8c
0x00028f30  mov      x24, x0
0x00028f34  ldr      x8, [sp, #0x10]
0x00028f38  ldr      x25, [x8]
0x00028f3c  mov      x26, #0
0x00028f40  ldr      x8, [sp, #0x10]
0x00028f44  ldr      x8, [x8]
0x00028f48  cmp      x8, x25
0x00028f4c  b.eq     #0x28f58
0x00028f50  mov      x0, x23
0x00028f54  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00028f58  ldr      x8, [sp, #8]
0x00028f5c  ldr      x0, [x8, x26, lsl #3]
0x00028f60  bl       #0x59e00   ; CALL objc_msgSend$removeFromSuperview
0x00028f64  add      x26, x26, #1
0x00028f68  cmp      x24, x26
0x00028f6c  b.ne     #0x28f40
0x00028f70  mov      x2, sp
0x00028f74  add      x3, sp, #0x58
0x00028f78  mov      x0, x23
0x00028f7c  mov      w4, #0x10
0x00028f80  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00028f84  mov      x24, x0
0x00028f88  cbnz     x0, #0x28f3c
0x00028f8c  mov      x0, x23
0x00028f90  bl       #0x55d78   ; CALL _objc_release
0x00028f94  adrp     x0, #0x7a000
0x00028f98  add      x0, x0, #0xac8   ; STR "SPEEDBUBBLE_SOUND_TONE"
0x00028f9c  bl       #0x17e20   ; CALL _L
0x00028fa0  mov      x29, x29
0x00028fa4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028fa8  mov      x23, x0
0x00028fac  str      x0, [sp, #0x48]
0x00028fb0  adrp     x0, #0x7a000
0x00028fb4  add      x0, x0, #0xae8   ; STR "SPEEDBUBBLE_SOUND_VOICE"
0x00028fb8  bl       #0x17e20   ; CALL _L
0x00028fbc  mov      x29, x29
0x00028fc0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028fc4  mov      x24, x0
0x00028fc8  str      x0, [sp, #0x50]
0x00028fcc  adrp     x8, #0x8e000
0x00028fd0  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x00028fd4  add      x2, sp, #0x48
0x00028fd8  mov      w3, #2
0x00028fdc  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x00028fe0  mov      x29, x29
0x00028fe4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00028fe8  mov      x25, x0
0x00028fec  adrp     x2, #0x7a000
0x00028ff0  add      x2, x2, #0x248   ; STR "speedBubbleWarnSound"
0x00028ff4  mov      x0, x21
0x00028ff8  mov      x3, x25
0x00028ffc  mov      x4, #0
0x00029000  bl       #0x5a1a0   ; CALL objc_msgSend$segmentForKey:titles:def:
0x00029004  mov      x29, x29
0x00029008  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002900c  mov      x21, x0
0x00029010  mov      x0, x25
0x00029014  bl       #0x55d78   ; CALL _objc_release
0x00029018  mov      x0, x24
0x0002901c  bl       #0x55d78   ; CALL _objc_release
0x00029020  mov      x0, x23
0x00029024  bl       #0x55d78   ; CALL _objc_release
0x00029028  mov      x8, #-0x3fb2000000000000
0x0002902c  fmov     d0, x8
0x00029030  fadd     d0, d8, d0
0x00029034  fmov     d1, #-16.00000000
0x00029038  fadd     d2, d0, d1
0x0002903c  mov      x8, #0x404e000000000000
0x00029040  fmov     d0, x8
0x00029044  mov      x8, #0x4040000000000000
0x00029048  fmov     d3, x8
0x0002904c  fmov     d1, #4.00000000
0x00029050  mov      x0, x21
0x00029054  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00029058  mov      x0, x22
0x0002905c  mov      x2, x21
0x00029060  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00029064  mov      x0, x21
0x00029068  bl       #0x55d78   ; CALL _objc_release
0x0002906c  b        #0x293c4
0x00029070  adrp     x2, #0x7a000
0x00029074  add      x2, x2, #0x568   ; STR "h:"
0x00029078  mov      x0, x19
0x0002907c  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x00029080  cbz      w0, #0x29200
0x00029084  adrp     x2, #0x79000
0x00029088  add      x2, x2, #0x4c8   ; STR "head"
0x0002908c  mov      x0, x21
0x00029090  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x00029094  mov      x29, x29
0x00029098  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002909c  mov      x20, x0
0x000290a0  mov      x8, #0x4046000000000000
0x000290a4  fmov     d0, x8
0x000290a8  bl       #0x5b160   ; CALL objc_msgSend$setIndentationWidth:
0x000290ac  mov      x0, x20
0x000290b0  mov      w2, #1
0x000290b4  bl       #0x5b140   ; CALL objc_msgSend$setIndentationLevel:
0x000290b8  mov      x0, x19
0x000290bc  mov      w2, #2
0x000290c0  bl       #0x5d6c0   ; CALL objc_msgSend$substringFromIndex:
0x000290c4  mov      x29, x29
0x000290c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000290cc  mov      x21, x0
0x000290d0  bl       #0x5ddc0   ; CALL objc_msgSend$uppercaseString
0x000290d4  mov      x29, x29
0x000290d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000290dc  mov      x22, x0
0x000290e0  adrp     x0, #0x7a000
0x000290e4  add      x0, x0, #0xb08   ; STR "SPEEDBUBBLE_VOICE_GROUP_"
0x000290e8  mov      x2, x22
0x000290ec  bl       #0x5d440   ; CALL objc_msgSend$stringByAppendingString:
0x000290f0  mov      x29, x29
0x000290f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000290f8  mov      x23, x0
0x000290fc  bl       #0x17e20   ; CALL _L
0x00029100  mov      x29, x29
0x00029104  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029108  mov      x24, x0
0x0002910c  bl       #0x5ddc0   ; CALL objc_msgSend$uppercaseString
0x00029110  mov      x29, x29
0x00029114  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029118  mov      x25, x0
0x0002911c  mov      x0, x20
0x00029120  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00029124  mov      x29, x29
0x00029128  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002912c  mov      x26, x0
0x00029130  mov      x2, x25
0x00029134  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00029138  mov      x0, x26
0x0002913c  bl       #0x55d78   ; CALL _objc_release
0x00029140  mov      x0, x25
0x00029144  bl       #0x55d78   ; CALL _objc_release
0x00029148  mov      x0, x24
0x0002914c  bl       #0x55d78   ; CALL _objc_release
0x00029150  mov      x0, x23
0x00029154  bl       #0x55d78   ; CALL _objc_release
0x00029158  mov      x0, x22
0x0002915c  bl       #0x55d78   ; CALL _objc_release
0x00029160  mov      x0, x21
0x00029164  bl       #0x55d78   ; CALL _objc_release
0x00029168  adrp     x8, #0x8e000
0x0002916c  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x00029170  adrp     x8, #0x74000
0x00029174  ldr      x8, [x8, #0x260]   ; @GOT _UIFontWeightSemibold
0x00029178  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x0002917c  fmov     d0, #11.50000000
0x00029180  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x00029184  mov      x29, x29
0x00029188  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002918c  mov      x21, x0
0x00029190  mov      x0, x20
0x00029194  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00029198  mov      x29, x29
0x0002919c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000291a0  mov      x22, x0
0x000291a4  mov      x2, x21
0x000291a8  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x000291ac  mov      x0, x22
0x000291b0  bl       #0x55d78   ; CALL _objc_release
0x000291b4  mov      x0, x21
0x000291b8  bl       #0x55d78   ; CALL _objc_release
0x000291bc  adrp     x8, #0x8e000
0x000291c0  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x000291c4  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x000291c8  mov      x29, x29
0x000291cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000291d0  mov      x21, x0
0x000291d4  mov      x0, x20
0x000291d8  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x000291dc  mov      x29, x29
0x000291e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000291e4  mov      x22, x0
0x000291e8  mov      x2, x21
0x000291ec  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x000291f0  mov      x0, x22
0x000291f4  bl       #0x55d78   ; CALL _objc_release
0x000291f8  mov      x0, x21
0x000291fc  b        #0x293c8
0x00029200  adrp     x2, #0x7a000
0x00029204  add      x2, x2, #0x588   ; STR "tone:"
0x00029208  mov      x0, x19
0x0002920c  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x00029210  tbnz     w0, #0, #0x29228
0x00029214  adrp     x2, #0x7a000
0x00029218  add      x2, x2, #0x5a8   ; STR "voice:"
0x0002921c  mov      x0, x19
0x00029220  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x00029224  cbz      w0, #0x29414
0x00029228  mov      x0, x21
0x0002922c  mov      x2, x19
0x00029230  bl       #0x59460   ; CALL objc_msgSend$optionChosen:
0x00029234  mov      x22, x0
0x00029238  adrp     x2, #0x7a000
0x0002923c  add      x2, x2, #0xb28   ; STR "opt"
0x00029240  mov      x0, x21
0x00029244  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x00029248  mov      x29, x29
0x0002924c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029250  mov      x20, x0
0x00029254  mov      x8, #0x4046000000000000
0x00029258  fmov     d0, x8
0x0002925c  bl       #0x5b160   ; CALL objc_msgSend$setIndentationWidth:
0x00029260  mov      x0, x20
0x00029264  mov      w2, #1
0x00029268  bl       #0x5b140   ; CALL objc_msgSend$setIndentationLevel:
0x0002926c  mov      x0, x21
0x00029270  mov      x2, x19
0x00029274  bl       #0x594a0   ; CALL objc_msgSend$optionText:
0x00029278  mov      x29, x29
0x0002927c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029280  mov      x23, x0
0x00029284  mov      x0, x20
0x00029288  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x0002928c  mov      x29, x29
0x00029290  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029294  mov      x24, x0
0x00029298  mov      x2, x23
0x0002929c  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x000292a0  mov      x0, x24
0x000292a4  bl       #0x55d78   ; CALL _objc_release
0x000292a8  mov      x0, x23
0x000292ac  bl       #0x55d78   ; CALL _objc_release
0x000292b0  mov      x0, x20
0x000292b4  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x000292b8  mov      x29, x29
0x000292bc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000292c0  mov      x23, x0
0x000292c4  mov      x2, #0
0x000292c8  bl       #0x5b820   ; CALL objc_msgSend$setNumberOfLines:
0x000292cc  mov      x0, x23
0x000292d0  bl       #0x55d78   ; CALL _objc_release
0x000292d4  adrp     x8, #0x8e000
0x000292d8  adrp     x9, #0x74000
0x000292dc  ldr      x9, [x9, #0x260]   ; @GOT _UIFontWeightSemibold
0x000292e0  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x000292e4  adrp     x8, #0x74000
0x000292e8  ldr      x8, [x8, #0x258]   ; @GOT _UIFontWeightRegular
0x000292ec  cmp      w22, #0
0x000292f0  csel     x8, x9, x8, ne
0x000292f4  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x000292f8  fmov     d0, #14.00000000
0x000292fc  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x00029300  mov      x29, x29
0x00029304  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029308  mov      x23, x0
0x0002930c  mov      x0, x20
0x00029310  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00029314  mov      x29, x29
0x00029318  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002931c  mov      x24, x0
0x00029320  mov      x2, x23
0x00029324  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00029328  mov      x0, x24
0x0002932c  bl       #0x55d78   ; CALL _objc_release
0x00029330  mov      x0, x23
0x00029334  bl       #0x55d78   ; CALL _objc_release
0x00029338  cbz      w22, #0x2934c
0x0002933c  bl       #0x17e8c   ; CALL _OMCAccentColor
0x00029340  mov      x29, x29
0x00029344  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029348  b        #0x29360
0x0002934c  adrp     x8, #0x8e000
0x00029350  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00029354  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x00029358  mov      x29, x29
0x0002935c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029360  mov      x23, x0
0x00029364  mov      x0, x20
0x00029368  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x0002936c  mov      x29, x29
0x00029370  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029374  mov      x24, x0
0x00029378  mov      x2, x23
0x0002937c  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00029380  mov      x0, x24
0x00029384  bl       #0x55d78   ; CALL _objc_release
0x00029388  mov      x0, x23
0x0002938c  bl       #0x55d78   ; CALL _objc_release
0x00029390  mov      x0, x20
0x00029394  mov      w2, #3
0x00029398  bl       #0x5bfa0   ; CALL objc_msgSend$setSelectionStyle:
0x0002939c  mov      x0, x21
0x000293a0  mov      x2, x22
0x000293a4  bl       #0x59780   ; CALL objc_msgSend$playIcon:
0x000293a8  mov      x29, x29
0x000293ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000293b0  mov      x22, x0
0x000293b4  mov      x0, x21
0x000293b8  mov      x2, x22
0x000293bc  mov      x3, x20
0x000293c0  bl       #0x5a280   ; CALL objc_msgSend$setAccessory:onCell:
0x000293c4  mov      x0, x22
0x000293c8  bl       #0x55d78   ; CALL _objc_release
0x000293cc  mov      x0, x19
0x000293d0  bl       #0x55d78   ; CALL _objc_release
0x000293d4  ldur     x8, [x29, #-0x68]
0x000293d8  adrp     x9, #0x74000
0x000293dc  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x000293e0  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x000293e4  cmp      x9, x8
0x000293e8  b.ne     #0x29794
0x000293ec  mov      x0, x20
0x000293f0  ldp      x29, x30, [sp, #0x140]
0x000293f4  ldp      x20, x19, [sp, #0x130]
0x000293f8  ldp      x22, x21, [sp, #0x120]
0x000293fc  ldp      x24, x23, [sp, #0x110]
0x00029400  ldp      x26, x25, [sp, #0x100]
0x00029404  ldp      x28, x27, [sp, #0xf0]
0x00029408  ldp      d9, d8, [sp, #0xe0]
0x0002940c  add      sp, sp, #0x150
0x00029410  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue
0x00029414  adrp     x2, #0x7a000
0x00029418  add      x2, x2, #0x5c8   ; STR "custom"
0x0002941c  mov      x0, x19
0x00029420  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x00029424  cbz      w0, #0x295d4
0x00029428  adrp     x2, #0x7a000
0x0002942c  add      x2, x2, #0x5c8   ; STR "custom"
0x00029430  mov      x0, x21
0x00029434  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x00029438  mov      x29, x29
0x0002943c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029440  mov      x20, x0
0x00029444  mov      x0, x21
0x00029448  mov      x2, x20
0x0002944c  bl       #0x56a80   ; CALL objc_msgSend$boxInCell:
0x00029450  mov      x29, x29
0x00029454  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029458  mov      x22, x0
0x0002945c  mov      w2, #0x56
0x00029460  bl       #0x5df80   ; CALL objc_msgSend$viewWithTag:
0x00029464  mov      x29, x29
0x00029468  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002946c  mov      x23, x0
0x00029470  cbnz     x0, #0x2951c
0x00029474  adrp     x8, #0x8e000
0x00029478  ldr      x0, [x8, #0xba0]   ; @CLASS UITextField
0x0002947c  bl       #0x55d60   ; CALL _objc_opt_new
0x00029480  mov      x23, x0
0x00029484  mov      w2, #0x56
0x00029488  bl       #0x5c480   ; CALL objc_msgSend$setTag:
0x0002948c  adrp     x8, #0x8e000
0x00029490  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x00029494  fmov     d0, #14.00000000
0x00029498  bl       #0x5d7c0   ; CALL objc_msgSend$systemFontOfSize:
0x0002949c  mov      x29, x29
0x000294a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000294a4  mov      x24, x0
0x000294a8  mov      x0, x23
0x000294ac  mov      x2, x24
0x000294b0  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x000294b4  mov      x0, x24
0x000294b8  bl       #0x55d78   ; CALL _objc_release
0x000294bc  mov      x0, x23
0x000294c0  mov      w2, #9
0x000294c4  bl       #0x5bde0   ; CALL objc_msgSend$setReturnKeyType:
0x000294c8  mov      x0, x23
0x000294cc  mov      w2, #1
0x000294d0  bl       #0x5a880   ; CALL objc_msgSend$setClearButtonMode:
0x000294d4  mov      x0, x23
0x000294d8  mov      x2, x21
0x000294dc  bl       #0x5aca0   ; CALL objc_msgSend$setDelegate:
0x000294e0  adrp     x8, #0x8b000
0x000294e4  ldr      x3, [x8, #0xea8]   ; @SEL "customBegan:"
0x000294e8  mov      x0, x23
0x000294ec  mov      x2, x21
0x000294f0  mov      w4, #0x10000
0x000294f4  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x000294f8  adrp     x8, #0x8b000
0x000294fc  ldr      x3, [x8, #0xeb0]   ; @SEL "customEnded:"
0x00029500  mov      x0, x23
0x00029504  mov      x2, x21
0x00029508  mov      w4, #0x40000
0x0002950c  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x00029510  mov      x0, x22
0x00029514  mov      x2, x23
0x00029518  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002951c  mov      x8, #-0x3fb2000000000000
0x00029520  fmov     d0, x8
0x00029524  fadd     d0, d8, d0
0x00029528  mov      x8, #-0x3fb7000000000000
0x0002952c  fmov     d1, x8
0x00029530  fadd     d2, d0, d1
0x00029534  mov      x8, #0x404e000000000000
0x00029538  fmov     d0, x8
0x0002953c  mov      x8, #0x4041000000000000
0x00029540  fmov     d3, x8
0x00029544  fmov     d1, #6.00000000
0x00029548  mov      x0, x23
0x0002954c  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x00029550  adrp     x0, #0x7a000
0x00029554  add      x0, x0, #0xb48   ; STR "SPEEDBUBBLE_VOICE_CUSTOM_PH"
0x00029558  bl       #0x17e20   ; CALL _L
0x0002955c  mov      x29, x29
0x00029560  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029564  mov      x24, x0
0x00029568  mov      x0, x23
0x0002956c  mov      x2, x24
0x00029570  bl       #0x5bbc0   ; CALL objc_msgSend$setPlaceholder:
0x00029574  mov      x0, x24
0x00029578  bl       #0x55d78   ; CALL _objc_release
0x0002957c  mov      x0, x23
0x00029580  bl       #0x58840   ; CALL objc_msgSend$isFirstResponder
0x00029584  tbnz     w0, #0, #0x295b0
0x00029588  mov      x0, x21
0x0002958c  bl       #0x5e000   ; CALL objc_msgSend$voiceText
0x00029590  mov      x29, x29
0x00029594  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029598  mov      x24, x0
0x0002959c  mov      x0, x23
0x000295a0  mov      x2, x24
0x000295a4  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x000295a8  mov      x0, x24
0x000295ac  bl       #0x55d78   ; CALL _objc_release
0x000295b0  mov      x0, x21
0x000295b4  mov      x2, x19
0x000295b8  bl       #0x59460   ; CALL objc_msgSend$optionChosen:
0x000295bc  mov      x24, x0
0x000295c0  tbz      w0, #0, #0x296e8
0x000295c4  bl       #0x17e8c   ; CALL _OMCAccentColor
0x000295c8  mov      x29, x29
0x000295cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000295d0  b        #0x296fc
0x000295d4  adrp     x2, #0x7a000
0x000295d8  add      x2, x2, #0xb68   ; STR "warnover"
0x000295dc  mov      x0, x21
0x000295e0  bl       #0x56d00   ; CALL objc_msgSend$cellWithId:
0x000295e4  mov      x29, x29
0x000295e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000295ec  mov      x20, x0
0x000295f0  adrp     x0, #0x7a000
0x000295f4  add      x0, x0, #0xb88   ; STR "SPEEDBUBBLE_WARN_WHEN"
0x000295f8  bl       #0x17e20   ; CALL _L
0x000295fc  mov      x29, x29
0x00029600  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029604  mov      x22, x0
0x00029608  mov      x0, x20
0x0002960c  bl       #0x5d9c0   ; CALL objc_msgSend$textLabel
0x00029610  mov      x29, x29
0x00029614  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029618  mov      x23, x0
0x0002961c  mov      x2, x22
0x00029620  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00029624  mov      x0, x23
0x00029628  bl       #0x55d78   ; CALL _objc_release
0x0002962c  mov      x0, x22
0x00029630  bl       #0x55d78   ; CALL _objc_release
0x00029634  adrp     x0, #0x7a000
0x00029638  add      x0, x0, #0xbc8   ; STR "#FFB340"
0x0002963c  bl       #0x18080   ; CALL _OMCColorFromHex
0x00029640  mov      x29, x29
0x00029644  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029648  mov      x22, x0
0x0002964c  adrp     x0, #0x7a000
0x00029650  add      x0, x0, #0xba8   ; STR "exclamationmark.triangle.fill"
0x00029654  mov      x1, x22
0x00029658  bl       #0x18144   ; CALL _OMCIcon
0x0002965c  mov      x29, x29
0x00029660  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029664  mov      x23, x0
0x00029668  mov      x0, x20
0x0002966c  bl       #0x58120   ; CALL objc_msgSend$imageView
0x00029670  mov      x29, x29
0x00029674  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029678  mov      x24, x0
0x0002967c  mov      x2, x23
0x00029680  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00029684  mov      x0, x24
0x00029688  bl       #0x55d78   ; CALL _objc_release
0x0002968c  mov      x0, x23
0x00029690  bl       #0x55d78   ; CALL _objc_release
0x00029694  mov      x0, x22
0x00029698  bl       #0x55d78   ; CALL _objc_release
0x0002969c  adrp     x8, #0x65000
0x000296a0  ldr      d0, [x8, #0x9b0]
0x000296a4  fadd     d0, d8, d0
0x000296a8  adrp     x8, #0x65000
0x000296ac  ldr      d1, [x8, #0x9b8]
0x000296b0  fcmp     d0, d1
0x000296b4  fcsel    d0, d1, d0, gt
0x000296b8  adrp     x2, #0x7a000
0x000296bc  add      x2, x2, #0x308   ; STR "speedBubbleWarnOver"
0x000296c0  adrp     x6, #0x7a000
0x000296c4  add      x6, x6, #0xbe8   ; STR "%+ld km/h"
0x000296c8  mov      x0, x21
0x000296cc  mov      x3, #-0xa
0x000296d0  mov      w4, #0xa
0x000296d4  mov      w5, #5
0x000296d8  bl       #0x5cc40   ; CALL objc_msgSend$sliderForKey:min:max:def:format:width:
0x000296dc  mov      x29, x29
0x000296e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000296e4  b        #0x293b0
0x000296e8  adrp     x8, #0x8e000
0x000296ec  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x000296f0  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x000296f4  mov      x29, x29
0x000296f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000296fc  mov      x25, x0
0x00029700  mov      x0, x23
0x00029704  mov      x2, x25
0x00029708  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0002970c  mov      x0, x25
0x00029710  bl       #0x55d78   ; CALL _objc_release
0x00029714  mov      x0, x20
0x00029718  mov      x2, #0
0x0002971c  bl       #0x5bfa0   ; CALL objc_msgSend$setSelectionStyle:
0x00029720  mov      x0, x21
0x00029724  mov      x2, x24
0x00029728  bl       #0x59780   ; CALL objc_msgSend$playIcon:
0x0002972c  mov      x29, x29
0x00029730  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029734  mov      x24, x0
0x00029738  mov      w2, #1
0x0002973c  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x00029740  adrp     x8, #0x8e000
0x00029744  ldr      x0, [x8, #0xba8]   ; @CLASS UITapGestureRecognizer
0x00029748  bl       #0x55c7c   ; CALL _objc_alloc
0x0002974c  adrp     x8, #0x8b000
0x00029750  ldr      x3, [x8, #0xeb8]   ; @SEL "customPlay"
0x00029754  mov      x2, x21
0x00029758  bl       #0x585e0   ; CALL objc_msgSend$initWithTarget:action:
0x0002975c  mov      x25, x0
0x00029760  mov      x0, x24
0x00029764  mov      x2, x25
0x00029768  bl       #0x560e0   ; CALL objc_msgSend$addGestureRecognizer:
0x0002976c  mov      x0, x25
0x00029770  bl       #0x55d78   ; CALL _objc_release
0x00029774  mov      x0, x21
0x00029778  mov      x2, x24
0x0002977c  mov      x3, x20
0x00029780  bl       #0x5a280   ; CALL objc_msgSend$setAccessory:onCell:
0x00029784  mov      x0, x24
0x00029788  bl       #0x55d78   ; CALL _objc_release
0x0002978c  mov      x0, x23
0x00029790  b        #0x29068
0x00029794  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCSpeedBubbleController layoutFxIn:width:]  va=0x29798 size=1620 types=v32@0:8@16d24
0x00029798  stp      d15, d14, [sp, #-0xa0]!
0x0002979c  stp      d13, d12, [sp, #0x10]
0x000297a0  stp      d11, d10, [sp, #0x20]
0x000297a4  stp      d9, d8, [sp, #0x30]
0x000297a8  stp      x28, x27, [sp, #0x40]
0x000297ac  stp      x26, x25, [sp, #0x50]
0x000297b0  stp      x24, x23, [sp, #0x60]
0x000297b4  stp      x22, x21, [sp, #0x70]
0x000297b8  stp      x20, x19, [sp, #0x80]
0x000297bc  stp      x29, x30, [sp, #0x90]
0x000297c0  add      x29, sp, #0x90
0x000297c4  sub      sp, sp, #0x1d0
0x000297c8  mov      v8.16b, v0.16b
0x000297cc  mov      x19, x2
0x000297d0  str      x0, [sp, #0x30]
0x000297d4  adrp     x8, #0x74000
0x000297d8  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000297dc  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000297e0  stur     x8, [x29, #-0xa0]
0x000297e4  mov      x0, x2
0x000297e8  bl       #0x55d84   ; CALL _objc_retain
0x000297ec  movi     v0.16b, #0
0x000297f0  stp      q0, q0, [sp, #0x80]
0x000297f4  stp      q0, q0, [sp, #0xa0]
0x000297f8  str      x19, [sp, #0x38]
0x000297fc  mov      x0, x19
0x00029800  bl       #0x5d700   ; CALL objc_msgSend$subviews
0x00029804  mov      x29, x29
0x00029808  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002980c  mov      x19, x0
0x00029810  bl       #0x572e0   ; CALL objc_msgSend$copy
0x00029814  mov      x21, x0
0x00029818  mov      x0, x19
0x0002981c  bl       #0x55d78   ; CALL _objc_release
0x00029820  add      x2, sp, #0x80
0x00029824  add      x3, sp, #0x140
0x00029828  mov      x0, x21
0x0002982c  mov      w4, #0x10
0x00029830  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00029834  cbz      x0, #0x29894
0x00029838  mov      x20, x0
0x0002983c  ldr      x8, [sp, #0x90]
0x00029840  ldr      x19, [x8]   ; @GOT ___objc_personality_v0
0x00029844  mov      x22, #0
0x00029848  ldr      x8, [sp, #0x90]
0x0002984c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x00029850  cmp      x8, x19
0x00029854  b.eq     #0x29860
0x00029858  mov      x0, x21
0x0002985c  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00029860  ldr      x8, [sp, #0x88]
0x00029864  ldr      x0, [x8, x22, lsl #3]   ; @GOT ___objc_personality_v0
0x00029868  bl       #0x59e00   ; CALL objc_msgSend$removeFromSuperview
0x0002986c  add      x22, x22, #1
0x00029870  cmp      x20, x22
0x00029874  b.ne     #0x29848
0x00029878  add      x2, sp, #0x80
0x0002987c  add      x3, sp, #0x140
0x00029880  mov      x0, x21
0x00029884  mov      w4, #0x10
0x00029888  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0002988c  mov      x20, x0
0x00029890  cbnz     x0, #0x29844
0x00029894  mov      x0, x21
0x00029898  bl       #0x55d78   ; CALL _objc_release
0x0002989c  mov      x8, #-0x3fb2000000000000
0x000298a0  fmov     d0, x8
0x000298a4  fadd     d0, d8, d0
0x000298a8  fmov     d1, #-16.00000000
0x000298ac  fadd     d0, d0, d1
0x000298b0  fmov     d1, #-6.00000000
0x000298b4  fadd     d0, d0, d1
0x000298b8  fmov     d1, #0.50000000
0x000298bc  fmul     d0, d0, d1
0x000298c0  frintm   d8, d0
0x000298c4  ldr      x0, [sp, #0x30]
0x000298c8  bl       #0x5e0a0   ; CALL objc_msgSend$warnFx
0x000298cc  mov      x21, x0
0x000298d0  mov      x22, #0
0x000298d4  fmov     d0, #6.00000000
0x000298d8  adrp     x8, #0x74000
0x000298dc  ldr      x8, [x8, #0x648]   ; @GOT _kCACornerCurveContinuous
0x000298e0  fadd     d0, d8, d0
0x000298e4  str      d0, [sp, #0x28]
0x000298e8  adrp     x9, #0x8b000
0x000298ec  mov      x10, #-0x3fbe000000000000
0x000298f0  fmov     d0, x10
0x000298f4  mov      x10, #0x4041000000000000
0x000298f8  fmov     d9, x10
0x000298fc  adrp     x10, #0x74000
0x00029900  ldr      x10, [x10, #0x260]   ; @GOT _UIFontWeightSemibold
0x00029904  ldr      x11, [x8]   ; @GOT ___objc_personality_v0
0x00029908  mov      x8, #0x404e000000000000
0x0002990c  fmov     d14, x8
0x00029910  ldr      x8, [x9, #0xec0]   ; @SEL "fxTapped:"
0x00029914  stp      x8, x11, [sp, #0x18]
0x00029918  mov      x8, #0x4044000000000000
0x0002991c  fmov     d13, x8
0x00029920  fadd     d10, d8, d0
0x00029924  ldr      d11, [x10]   ; @GOT ___objc_personality_v0
0x00029928  adrp     x8, #0x65000
0x0002992c  ldr      d12, [x8, #0x9c0]
0x00029930  adrp     x8, #0x65000
0x00029934  ldr      d0, [x8, #0x658]
0x00029938  str      d0, [sp, #0x10]
0x0002993c  adrp     x8, #0x65000
0x00029940  ldr      d0, [x8, #0x748]
0x00029944  str      d0, [sp, #8]
0x00029948  adrp     x8, #0x8e000
0x0002994c  ldr      x0, [x8, #0xbb0]   ; @CLASS UIControl
0x00029950  bl       #0x55c7c   ; CALL _objc_alloc
0x00029954  and      x8, x22, #1
0x00029958  ucvtf    d0, x8
0x0002995c  ldr      d1, [sp, #0x28]
0x00029960  fmadd    d0, d0, d1, d14
0x00029964  lsr      x8, x22, #1
0x00029968  ucvtf    d1, x8
0x0002996c  fmov     d2, #2.00000000
0x00029970  fmadd    d1, d1, d13, d2
0x00029974  mov      v2.16b, v8.16b
0x00029978  mov      v3.16b, v9.16b
0x0002997c  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x00029980  mov      x25, x0
0x00029984  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00029988  mov      x29, x29
0x0002998c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029990  mov      x19, x0
0x00029994  fmov     d0, #11.00000000
0x00029998  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0002999c  mov      x0, x19
0x000299a0  bl       #0x55d78   ; CALL _objc_release
0x000299a4  mov      x0, x25
0x000299a8  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x000299ac  mov      x29, x29
0x000299b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000299b4  mov      x19, x0
0x000299b8  ldr      x2, [sp, #0x20]
0x000299bc  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x000299c0  mov      x0, x19
0x000299c4  bl       #0x55d78   ; CALL _objc_release
0x000299c8  adrp     x8, #0x8e000
0x000299cc  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x000299d0  cmp      x22, x21
0x000299d4  b.ne     #0x299f0
0x000299d8  bl       #0x5d7a0   ; CALL objc_msgSend$systemBackgroundColor
0x000299dc  mov      x29, x29
0x000299e0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000299e4  mov      x19, x0
0x000299e8  fmov     d15, #1.50000000
0x000299ec  b        #0x29a10
0x000299f0  mov      v0.16b, v12.16b
0x000299f4  mov      v1.16b, v12.16b
0x000299f8  ldp      d3, d2, [sp, #8]
0x000299fc  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00029a00  mov      x29, x29
0x00029a04  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029a08  mov      x19, x0
0x00029a0c  fmov     d15, xzr
0x00029a10  mov      x0, x25
0x00029a14  mov      x2, x19
0x00029a18  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x00029a1c  mov      x0, x19
0x00029a20  bl       #0x55d78   ; CALL _objc_release
0x00029a24  mov      x0, x25
0x00029a28  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00029a2c  mov      x29, x29
0x00029a30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029a34  mov      x19, x0
0x00029a38  mov      v0.16b, v15.16b
0x00029a3c  bl       #0x5a740   ; CALL objc_msgSend$setBorderWidth:
0x00029a40  mov      x0, x19
0x00029a44  bl       #0x55d78   ; CALL _objc_release
0x00029a48  adrp     x0, #0x78000
0x00029a4c  add      x0, x0, #0xf28   ; STR "#8B7CFF"
0x00029a50  bl       #0x18080   ; CALL _OMCColorFromHex
0x00029a54  mov      x29, x29
0x00029a58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029a5c  mov      x19, x0
0x00029a60  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00029a64  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00029a68  mov      x20, x0
0x00029a6c  mov      x0, x25
0x00029a70  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x00029a74  mov      x29, x29
0x00029a78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029a7c  mov      x26, x0
0x00029a80  mov      x2, x20
0x00029a84  bl       #0x5a700   ; CALL objc_msgSend$setBorderColor:
0x00029a88  mov      x0, x26
0x00029a8c  bl       #0x55d78   ; CALL _objc_release
0x00029a90  mov      x0, x19
0x00029a94  bl       #0x55d78   ; CALL _objc_release
0x00029a98  adrp     x8, #0x8e000
0x00029a9c  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x00029aa0  mov      x2, x22
0x00029aa4  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x00029aa8  mov      x29, x29
0x00029aac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029ab0  mov      x19, x0
0x00029ab4  mov      x0, x25
0x00029ab8  adrp     x1, #0x90000
0x00029abc  add      x1, x1, #0x38
0x00029ac0  mov      x2, x19
0x00029ac4  mov      w3, #1
0x00029ac8  bl       #0x55db4   ; CALL _objc_setAssociatedObject
0x00029acc  mov      x0, x19
0x00029ad0  bl       #0x55d78   ; CALL _objc_release
0x00029ad4  mov      x0, x25
0x00029ad8  ldr      x2, [sp, #0x30]
0x00029adc  ldr      x3, [sp, #0x18]
0x00029ae0  mov      w4, #0x40
0x00029ae4  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x00029ae8  cmp      x22, x21
0x00029aec  b.ne     #0x29b08
0x00029af0  adrp     x0, #0x7a000
0x00029af4  add      x0, x0, #0xc08   ; STR "#4B3FD0"
0x00029af8  bl       #0x18080   ; CALL _OMCColorFromHex
0x00029afc  mov      x29, x29
0x00029b00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029b04  b        #0x29b1c
0x00029b08  adrp     x8, #0x8e000
0x00029b0c  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x00029b10  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x00029b14  mov      x29, x29
0x00029b18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029b1c  mov      x26, x0
0x00029b20  adrp     x8, #0x8e000
0x00029b24  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x00029b28  bl       #0x55c7c   ; CALL _objc_alloc
0x00029b2c  fmov     d0, #9.00000000
0x00029b30  fmov     d1, #9.00000000
0x00029b34  fmov     d2, #16.00000000
0x00029b38  fmov     d3, #16.00000000
0x00029b3c  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x00029b40  mov      x28, x0
0x00029b44  adrp     x8, #0x8e000
0x00029b48  ldr      x19, [x8, #0xa78]   ; @CLASS UIImage
0x00029b4c  adrp     x0, #0x7f000
0x00029b50  add      x0, x0, #0xb70
0x00029b54  mov      x2, x22
0x00029b58  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x00029b5c  mov      x29, x29
0x00029b60  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029b64  mov      x20, x0
0x00029b68  adrp     x8, #0x8e000
0x00029b6c  ldr      x0, [x8, #0xa70]   ; @CLASS UIImageSymbolConfiguration
0x00029b70  fmov     d0, #12.00000000
0x00029b74  mov      w2, #6
0x00029b78  bl       #0x57100   ; CALL objc_msgSend$configurationWithPointSize:weight:
0x00029b7c  mov      x29, x29
0x00029b80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029b84  mov      x27, x0
0x00029b88  mov      x0, x19
0x00029b8c  mov      x2, x20
0x00029b90  mov      x3, x27
0x00029b94  bl       #0x5d840   ; CALL objc_msgSend$systemImageNamed:withConfiguration:
0x00029b98  mov      x29, x29
0x00029b9c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029ba0  mov      x19, x0
0x00029ba4  mov      x0, x28
0x00029ba8  mov      x2, x19
0x00029bac  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x00029bb0  mov      x0, x19
0x00029bb4  bl       #0x55d78   ; CALL _objc_release
0x00029bb8  mov      x0, x27
0x00029bbc  bl       #0x55d78   ; CALL _objc_release
0x00029bc0  mov      x0, x20
0x00029bc4  bl       #0x55d78   ; CALL _objc_release
0x00029bc8  mov      x0, x28
0x00029bcc  mov      w2, #4
0x00029bd0  bl       #0x5aa40   ; CALL objc_msgSend$setContentMode:
0x00029bd4  mov      x0, x28
0x00029bd8  mov      x2, x26
0x00029bdc  bl       #0x5c5c0   ; CALL objc_msgSend$setTintColor:
0x00029be0  mov      x0, x25
0x00029be4  mov      x2, x28
0x00029be8  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00029bec  adrp     x8, #0x8e000
0x00029bf0  ldr      x0, [x8, #0x940]   ; @CLASS UILabel
0x00029bf4  bl       #0x55c7c   ; CALL _objc_alloc
0x00029bf8  fmov     d0, #31.00000000
0x00029bfc  fmov     d1, xzr
0x00029c00  mov      v2.16b, v10.16b
0x00029c04  mov      v3.16b, v9.16b
0x00029c08  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x00029c0c  mov      x27, x0
0x00029c10  adrp     x8, #0x8e000
0x00029c14  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x00029c18  str      x22, [sp]
0x00029c1c  adrp     x2, #0x7a000
0x00029c20  add      x2, x2, #0xc28   ; STR "SPEEDBUBBLE_FX_%ld"
0x00029c24  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x00029c28  mov      x29, x29
0x00029c2c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029c30  mov      x19, x0
0x00029c34  bl       #0x17e20   ; CALL _L
0x00029c38  mov      x29, x29
0x00029c3c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029c40  mov      x20, x0
0x00029c44  mov      x0, x27
0x00029c48  mov      x2, x20
0x00029c4c  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x00029c50  mov      x0, x20
0x00029c54  bl       #0x55d78   ; CALL _objc_release
0x00029c58  mov      x0, x19
0x00029c5c  bl       #0x55d78   ; CALL _objc_release
0x00029c60  adrp     x8, #0x8e000
0x00029c64  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x00029c68  fmov     d0, #12.50000000
0x00029c6c  mov      v1.16b, v11.16b
0x00029c70  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x00029c74  mov      x29, x29
0x00029c78  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029c7c  mov      x19, x0
0x00029c80  mov      x0, x27
0x00029c84  mov      x2, x19
0x00029c88  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x00029c8c  mov      x0, x19
0x00029c90  bl       #0x55d78   ; CALL _objc_release
0x00029c94  mov      x0, x27
0x00029c98  mov      x2, x26
0x00029c9c  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x00029ca0  mov      x0, x27
0x00029ca4  mov      w2, #1
0x00029ca8  bl       #0x5a380   ; CALL objc_msgSend$setAdjustsFontSizeToFitWidth:
0x00029cac  fmov     d0, #0.75000000
0x00029cb0  mov      x0, x27
0x00029cb4  bl       #0x5b660   ; CALL objc_msgSend$setMinimumScaleFactor:
0x00029cb8  mov      x0, x25
0x00029cbc  mov      x2, x27
0x00029cc0  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00029cc4  movi     v0.16b, #0
0x00029cc8  stp      q0, q0, [sp, #0x60]
0x00029ccc  stp      q0, q0, [sp, #0x40]
0x00029cd0  mov      x0, x25
0x00029cd4  bl       #0x5d700   ; CALL objc_msgSend$subviews
0x00029cd8  mov      x29, x29
0x00029cdc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029ce0  mov      x20, x0
0x00029ce4  add      x2, sp, #0x40
0x00029ce8  add      x3, sp, #0xc0
0x00029cec  mov      w4, #0x10
0x00029cf0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00029cf4  cbz      x0, #0x29d58
0x00029cf8  mov      x19, x0
0x00029cfc  ldr      x8, [sp, #0x50]
0x00029d00  ldr      x23, [x8]   ; @SEL "whatsNewNavigationController"
0x00029d04  mov      x24, #0
0x00029d08  ldr      x8, [sp, #0x50]
0x00029d0c  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x00029d10  cmp      x8, x23
0x00029d14  b.eq     #0x29d20
0x00029d18  mov      x0, x20
0x00029d1c  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x00029d20  ldr      x8, [sp, #0x48]
0x00029d24  ldr      x0, [x8, x24, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x00029d28  mov      w2, #0
0x00029d2c  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x00029d30  add      x24, x24, #1
0x00029d34  cmp      x19, x24
0x00029d38  b.ne     #0x29d08
0x00029d3c  add      x2, sp, #0x40
0x00029d40  add      x3, sp, #0xc0
0x00029d44  mov      x0, x20
0x00029d48  mov      w4, #0x10
0x00029d4c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x00029d50  mov      x19, x0
0x00029d54  cbnz     x0, #0x29d04
0x00029d58  mov      x0, x20
0x00029d5c  bl       #0x55d78   ; CALL _objc_release
0x00029d60  ldr      x0, [sp, #0x38]
0x00029d64  mov      x2, x25
0x00029d68  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x00029d6c  mov      x0, x27
0x00029d70  bl       #0x55d78   ; CALL _objc_release
0x00029d74  mov      x0, x28
0x00029d78  bl       #0x55d78   ; CALL _objc_release
0x00029d7c  mov      x0, x26
0x00029d80  bl       #0x55d78   ; CALL _objc_release
0x00029d84  mov      x0, x25
0x00029d88  bl       #0x55d78   ; CALL _objc_release
0x00029d8c  add      x22, x22, #1
0x00029d90  cmp      x22, #4
0x00029d94  b.ne     #0x29948
0x00029d98  ldr      x0, [sp, #0x38]
0x00029d9c  bl       #0x55d78   ; CALL _objc_release
0x00029da0  ldur     x8, [x29, #-0xa0]
0x00029da4  adrp     x9, #0x74000
0x00029da8  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00029dac  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00029db0  cmp      x9, x8
0x00029db4  b.ne     #0x29de8
0x00029db8  add      sp, sp, #0x1d0
0x00029dbc  ldp      x29, x30, [sp, #0x90]
0x00029dc0  ldp      x20, x19, [sp, #0x80]
0x00029dc4  ldp      x22, x21, [sp, #0x70]
0x00029dc8  ldp      x24, x23, [sp, #0x60]
0x00029dcc  ldp      x26, x25, [sp, #0x50]
0x00029dd0  ldp      x28, x27, [sp, #0x40]
0x00029dd4  ldp      d9, d8, [sp, #0x30]
0x00029dd8  ldp      d11, d10, [sp, #0x20]
0x00029ddc  ldp      d13, d12, [sp, #0x10]
0x00029de0  ldp      d15, d14, [sp], #0xa0
0x00029de4  ret      
0x00029de8  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCSpeedBubbleController fxTapped:]  va=0x29dec size=156 types=v24@0:8@16
0x00029dec  stp      x22, x21, [sp, #-0x30]!
0x00029df0  stp      x20, x19, [sp, #0x10]
0x00029df4  stp      x29, x30, [sp, #0x20]
0x00029df8  add      x29, sp, #0x20
0x00029dfc  mov      x19, x2
0x00029e00  mov      x20, x0
0x00029e04  adrp     x8, #0x8e000
0x00029e08  ldr      x21, [x8, #0x938]   ; @CLASS UISelectionFeedbackGenerator
0x00029e0c  mov      x0, x2
0x00029e10  bl       #0x55d84   ; CALL _objc_retain
0x00029e14  mov      x0, x21
0x00029e18  bl       #0x55d60   ; CALL _objc_opt_new
0x00029e1c  mov      x21, x0
0x00029e20  bl       #0x5a200   ; CALL objc_msgSend$selectionChanged
0x00029e24  mov      x0, x21
0x00029e28  bl       #0x55d78   ; CALL _objc_release
0x00029e2c  adrp     x1, #0x90000
0x00029e30  add      x1, x1, #0x38
0x00029e34  mov      x0, x19
0x00029e38  bl       #0x55d00   ; CALL _objc_getAssociatedObject
0x00029e3c  mov      x29, x29
0x00029e40  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029e44  mov      x21, x0
0x00029e48  mov      x0, x19
0x00029e4c  bl       #0x55d78   ; CALL _objc_release
0x00029e50  adrp     x19, #0x7a000
0x00029e54  add      x19, x19, #0x228   ; STR "speedBubbleWarnFx"
0x00029e58  mov      x0, x20
0x00029e5c  mov      x2, x21
0x00029e60  mov      x3, x19
0x00029e64  bl       #0x5d3c0   ; CALL objc_msgSend$storeValue:forKey:
0x00029e68  mov      x0, x21
0x00029e6c  bl       #0x55d78   ; CALL _objc_release
0x00029e70  mov      x0, x20
0x00029e74  mov      x2, x19
0x00029e78  ldp      x29, x30, [sp, #0x20]
0x00029e7c  ldp      x20, x19, [sp, #0x10]
0x00029e80  ldp      x22, x21, [sp], #0x30
0x00029e84  b        #0x59880   ; CALL objc_msgSend$prefChanged:

=== -[OMCSpeedBubbleController playPreview]  va=0x29e88 size=152 types=v16@0:8
0x00029e88  stp      x22, x21, [sp, #-0x30]!
0x00029e8c  stp      x20, x19, [sp, #0x10]
0x00029e90  stp      x29, x30, [sp, #0x20]
0x00029e94  add      x29, sp, #0x20
0x00029e98  mov      x19, x0
0x00029e9c  bl       #0x5dfe0   ; CALL objc_msgSend$voiceSound
0x00029ea0  cbz      w0, #0x29f08
0x00029ea4  mov      x0, x19
0x00029ea8  bl       #0x5dfc0   ; CALL objc_msgSend$voiceLine
0x00029eac  mov      x20, x0
0x00029eb0  mov      x0, x19
0x00029eb4  bl       #0x5e000   ; CALL objc_msgSend$voiceText
0x00029eb8  mov      x29, x29
0x00029ebc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029ec0  mov      x21, x0
0x00029ec4  mov      x0, x19
0x00029ec8  bl       #0x5cb40   ; CALL objc_msgSend$shownLimit
0x00029ecc  mov      x2, x0
0x00029ed0  mov      x0, x20
0x00029ed4  mov      x1, x21
0x00029ed8  bl       #0x353bc   ; CALL _SPPVoiceLine
0x00029edc  mov      x29, x29
0x00029ee0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029ee4  mov      x19, x0
0x00029ee8  bl       #0x35f30   ; CALL _SPPSpeak
0x00029eec  mov      x0, x19
0x00029ef0  bl       #0x55d78   ; CALL _objc_release
0x00029ef4  mov      x0, x21
0x00029ef8  ldp      x29, x30, [sp, #0x20]
0x00029efc  ldp      x20, x19, [sp, #0x10]
0x00029f00  ldp      x22, x21, [sp], #0x30
0x00029f04  b        #0x55d78   ; CALL _objc_release
0x00029f08  mov      x0, x19
0x00029f0c  bl       #0x5dbe0   ; CALL objc_msgSend$tone
0x00029f10  ldp      x29, x30, [sp, #0x20]
0x00029f14  ldp      x20, x19, [sp, #0x10]
0x00029f18  ldp      x22, x21, [sp], #0x30
0x00029f1c  b        #0x35600   ; CALL _SPPPlayTone

=== -[OMCSpeedBubbleController pickOption:]  va=0x29f20 size=224 types=v24@0:8@16
0x00029f20  stp      x24, x23, [sp, #-0x40]!
0x00029f24  stp      x22, x21, [sp, #0x10]
0x00029f28  stp      x20, x19, [sp, #0x20]
0x00029f2c  stp      x29, x30, [sp, #0x30]
0x00029f30  add      x29, sp, #0x30
0x00029f34  mov      x20, x2
0x00029f38  mov      x19, x0
0x00029f3c  mov      x0, x2
0x00029f40  bl       #0x55d84   ; CALL _objc_retain
0x00029f44  adrp     x2, #0x7a000
0x00029f48  add      x2, x2, #0x588   ; STR "tone:"
0x00029f4c  mov      x0, x20
0x00029f50  bl       #0x57ea0   ; CALL objc_msgSend$hasPrefix:
0x00029f54  mov      x21, x0
0x00029f58  adrp     x8, #0x8e000
0x00029f5c  ldr      x0, [x8, #0x938]   ; @CLASS UISelectionFeedbackGenerator
0x00029f60  bl       #0x55d60   ; CALL _objc_opt_new
0x00029f64  mov      x22, x0
0x00029f68  bl       #0x5a200   ; CALL objc_msgSend$selectionChanged
0x00029f6c  mov      x0, x22
0x00029f70  bl       #0x55d78   ; CALL _objc_release
0x00029f74  adrp     x8, #0x8e000
0x00029f78  ldr      x22, [x8, #0x928]   ; @CLASS NSNumber
0x00029f7c  mov      x0, x19
0x00029f80  mov      x2, x20
0x00029f84  bl       #0x59480   ; CALL objc_msgSend$optionIndex:
0x00029f88  mov      x23, x0
0x00029f8c  mov      x0, x20
0x00029f90  bl       #0x55d78   ; CALL _objc_release
0x00029f94  mov      x0, x22
0x00029f98  mov      x2, x23
0x00029f9c  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x00029fa0  mov      x29, x29
0x00029fa4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00029fa8  mov      x20, x0
0x00029fac  adrp     x8, #0x7a000
0x00029fb0  add      x8, x8, #0x288   ; STR "speedBubbleWarnVoice"
0x00029fb4  adrp     x9, #0x7a000
0x00029fb8  add      x9, x9, #0x268   ; STR "speedBubbleWarnTone"
0x00029fbc  cmp      w21, #0
0x00029fc0  csel     x21, x9, x8, ne
0x00029fc4  mov      x0, x19
0x00029fc8  mov      x2, x20
0x00029fcc  mov      x3, x21
0x00029fd0  bl       #0x5d3c0   ; CALL objc_msgSend$storeValue:forKey:
0x00029fd4  mov      x0, x20
0x00029fd8  bl       #0x55d78   ; CALL _objc_release
0x00029fdc  mov      x0, x19
0x00029fe0  bl       #0x597c0   ; CALL objc_msgSend$playPreview
0x00029fe4  mov      x0, x19
0x00029fe8  mov      x2, x21
0x00029fec  ldp      x29, x30, [sp, #0x30]
0x00029ff0  ldp      x20, x19, [sp, #0x20]
0x00029ff4  ldp      x22, x21, [sp, #0x10]
0x00029ff8  ldp      x24, x23, [sp], #0x40
0x00029ffc  b        #0x59880   ; CALL objc_msgSend$prefChanged:

=== -[OMCSpeedBubbleController customBegan:]  va=0x2a000 size=72 types=v24@0:8@16
0x0002a000  stp      x20, x19, [sp, #-0x20]!
0x0002a004  stp      x29, x30, [sp, #0x10]
0x0002a008  add      x29, sp, #0x10
0x0002a00c  mov      x19, x0
0x0002a010  bl       #0x5dfc0   ; CALL objc_msgSend$voiceLine
0x0002a014  cmp      x0, #8
0x0002a018  b.ne     #0x2a028
0x0002a01c  ldp      x29, x30, [sp, #0x10]
0x0002a020  ldp      x20, x19, [sp], #0x20
0x0002a024  ret      
0x0002a028  adrp     x2, #0x80000
0x0002a02c  add      x2, x2, #0x2c8
0x0002a030  adrp     x3, #0x7a000
0x0002a034  add      x3, x3, #0x288   ; STR "speedBubbleWarnVoice"
0x0002a038  mov      x0, x19
0x0002a03c  ldp      x29, x30, [sp, #0x10]
0x0002a040  ldp      x20, x19, [sp], #0x20
0x0002a044  b        #0x5d3c0   ; CALL objc_msgSend$storeValue:forKey:

=== -[OMCSpeedBubbleController customEnded:]  va=0x2a048 size=96 types=v24@0:8@16
0x0002a048  stp      x20, x19, [sp, #-0x20]!
0x0002a04c  stp      x29, x30, [sp, #0x10]
0x0002a050  add      x29, sp, #0x10
0x0002a054  mov      x19, x0
0x0002a058  mov      x0, x2
0x0002a05c  bl       #0x5d980   ; CALL objc_msgSend$text
0x0002a060  mov      x29, x29
0x0002a064  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a068  mov      x20, x0
0x0002a06c  adrp     x8, #0x75000
0x0002a070  add      x8, x8, #0xd28
0x0002a074  cmp      x0, #0
0x0002a078  csel     x2, x8, x0, eq
0x0002a07c  adrp     x3, #0x7a000
0x0002a080  add      x3, x3, #0x2a8   ; STR "speedBubbleWarnVoiceText"
0x0002a084  mov      x0, x19
0x0002a088  bl       #0x5d3c0   ; CALL objc_msgSend$storeValue:forKey:
0x0002a08c  mov      x0, x20
0x0002a090  bl       #0x55d78   ; CALL _objc_release
0x0002a094  mov      x0, x19
0x0002a098  mov      w2, #5
0x0002a09c  ldp      x29, x30, [sp, #0x10]
0x0002a0a0  ldp      x20, x19, [sp], #0x20
0x0002a0a4  b        #0x59ce0   ; CALL objc_msgSend$reloadSection:

=== -[OMCSpeedBubbleController textFieldShouldReturn:]  va=0x2a0a8 size=48 types=B24@0:8@16
0x0002a0a8  stp      x20, x19, [sp, #-0x20]!
0x0002a0ac  stp      x29, x30, [sp, #0x10]
0x0002a0b0  add      x29, sp, #0x10
0x0002a0b4  mov      x19, x0
0x0002a0b8  mov      x0, x2
0x0002a0bc  bl       #0x59f00   ; CALL objc_msgSend$resignFirstResponder
0x0002a0c0  mov      x0, x19
0x0002a0c4  bl       #0x597c0   ; CALL objc_msgSend$playPreview
0x0002a0c8  mov      w0, #0
0x0002a0cc  ldp      x29, x30, [sp, #0x10]
0x0002a0d0  ldp      x20, x19, [sp], #0x20
0x0002a0d4  ret      

=== -[OMCSpeedBubbleController textField:shouldChangeCharactersInRange:replacementString:]  va=0x2a0d8 size=124 types=B48@0:8@16{_NSRange=QQ}24@40
0x0002a0d8  stp      x22, x21, [sp, #-0x30]!
0x0002a0dc  stp      x20, x19, [sp, #0x10]
0x0002a0e0  stp      x29, x30, [sp, #0x20]
0x0002a0e4  add      x29, sp, #0x20
0x0002a0e8  mov      x19, x5
0x0002a0ec  mov      x20, x4
0x0002a0f0  mov      x21, x2
0x0002a0f4  mov      x0, x5
0x0002a0f8  bl       #0x55d84   ; CALL _objc_retain
0x0002a0fc  mov      x0, x21
0x0002a100  bl       #0x5d980   ; CALL objc_msgSend$text
0x0002a104  mov      x29, x29
0x0002a108  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a10c  mov      x21, x0
0x0002a110  bl       #0x58c20   ; CALL objc_msgSend$length
0x0002a114  sub      x22, x0, x20
0x0002a118  mov      x0, x19
0x0002a11c  bl       #0x58c20   ; CALL objc_msgSend$length
0x0002a120  mov      x20, x0
0x0002a124  mov      x0, x19
0x0002a128  bl       #0x55d78   ; CALL _objc_release
0x0002a12c  add      x8, x22, x20
0x0002a130  cmp      x8, #0x51
0x0002a134  cset     w19, lo
0x0002a138  mov      x0, x21
0x0002a13c  bl       #0x55d78   ; CALL _objc_release
0x0002a140  mov      x0, x19
0x0002a144  ldp      x29, x30, [sp, #0x20]
0x0002a148  ldp      x20, x19, [sp, #0x10]
0x0002a14c  ldp      x22, x21, [sp], #0x30
0x0002a150  ret      

=== -[OMCSpeedBubbleController customPlay]  va=0x2a154 size=172 types=v16@0:8
0x0002a154  stp      x22, x21, [sp, #-0x30]!
0x0002a158  stp      x20, x19, [sp, #0x10]
0x0002a15c  stp      x29, x30, [sp, #0x20]
0x0002a160  add      x29, sp, #0x20
0x0002a164  mov      x19, x0
0x0002a168  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x0002a16c  mov      x29, x29
0x0002a170  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a174  mov      x21, x0
0x0002a178  mov      w2, #0x56
0x0002a17c  bl       #0x5df80   ; CALL objc_msgSend$viewWithTag:
0x0002a180  mov      x29, x29
0x0002a184  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a188  mov      x20, x0
0x0002a18c  mov      x0, x21
0x0002a190  bl       #0x55d78   ; CALL _objc_release
0x0002a194  mov      x0, x20
0x0002a198  bl       #0x58840   ; CALL objc_msgSend$isFirstResponder
0x0002a19c  cbz      w0, #0x2a1ac
0x0002a1a0  mov      x0, x20
0x0002a1a4  bl       #0x59f00   ; CALL objc_msgSend$resignFirstResponder
0x0002a1a8  b        #0x2a1e4
0x0002a1ac  mov      x0, x19
0x0002a1b0  bl       #0x5dfc0   ; CALL objc_msgSend$voiceLine
0x0002a1b4  cmp      x0, #8
0x0002a1b8  b.eq     #0x2a1e4
0x0002a1bc  adrp     x2, #0x80000
0x0002a1c0  add      x2, x2, #0x2c8
0x0002a1c4  adrp     x21, #0x7a000
0x0002a1c8  add      x21, x21, #0x288   ; STR "speedBubbleWarnVoice"
0x0002a1cc  mov      x0, x19
0x0002a1d0  mov      x3, x21
0x0002a1d4  bl       #0x5d3c0   ; CALL objc_msgSend$storeValue:forKey:
0x0002a1d8  mov      x0, x19
0x0002a1dc  mov      x2, x21
0x0002a1e0  bl       #0x59880   ; CALL objc_msgSend$prefChanged:
0x0002a1e4  mov      x0, x19
0x0002a1e8  bl       #0x597c0   ; CALL objc_msgSend$playPreview
0x0002a1ec  mov      x0, x20
0x0002a1f0  ldp      x29, x30, [sp, #0x20]
0x0002a1f4  ldp      x20, x19, [sp, #0x10]
0x0002a1f8  ldp      x22, x21, [sp], #0x30
0x0002a1fc  b        #0x55d78   ; CALL _objc_release

=== -[OMCSpeedBubbleController layoutColorsIn:width:]  va=0x2a200 size=2196 types=v32@0:8@16d24
0x0002a200  sub      sp, sp, #0x1e0
0x0002a204  stp      d15, d14, [sp, #0x140]
0x0002a208  stp      d13, d12, [sp, #0x150]
0x0002a20c  stp      d11, d10, [sp, #0x160]
0x0002a210  stp      d9, d8, [sp, #0x170]
0x0002a214  stp      x28, x27, [sp, #0x180]
0x0002a218  stp      x26, x25, [sp, #0x190]
0x0002a21c  stp      x24, x23, [sp, #0x1a0]
0x0002a220  stp      x22, x21, [sp, #0x1b0]
0x0002a224  stp      x20, x19, [sp, #0x1c0]
0x0002a228  stp      x29, x30, [sp, #0x1d0]
0x0002a22c  add      x29, sp, #0x1d0
0x0002a230  mov      v9.16b, v0.16b
0x0002a234  mov      x19, x2
0x0002a238  str      x0, [sp, #0x30]
0x0002a23c  adrp     x8, #0x74000
0x0002a240  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0002a244  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002a248  stur     x8, [x29, #-0xa0]
0x0002a24c  mov      x0, x2
0x0002a250  bl       #0x55d84   ; CALL _objc_retain
0x0002a254  movi     v0.16b, #0
0x0002a258  stp      q0, q0, [sp, #0x40]
0x0002a25c  stp      q0, q0, [sp, #0x60]
0x0002a260  str      x19, [sp, #0x38]
0x0002a264  mov      x0, x19
0x0002a268  bl       #0x5d700   ; CALL objc_msgSend$subviews
0x0002a26c  mov      x29, x29
0x0002a270  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a274  mov      x20, x0
0x0002a278  bl       #0x572e0   ; CALL objc_msgSend$copy
0x0002a27c  mov      x21, x0
0x0002a280  mov      x0, x20
0x0002a284  bl       #0x55d78   ; CALL _objc_release
0x0002a288  add      x2, sp, #0x40
0x0002a28c  add      x3, sp, #0xb0
0x0002a290  mov      x0, x21
0x0002a294  mov      w4, #0x10
0x0002a298  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0002a29c  cbz      x0, #0x2a2fc
0x0002a2a0  mov      x20, x0
0x0002a2a4  ldr      x8, [sp, #0x50]
0x0002a2a8  ldr      x19, [x8]   ; @GOT ___objc_personality_v0
0x0002a2ac  mov      x22, #0
0x0002a2b0  ldr      x8, [sp, #0x50]
0x0002a2b4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002a2b8  cmp      x8, x19
0x0002a2bc  b.eq     #0x2a2c8
0x0002a2c0  mov      x0, x21
0x0002a2c4  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0002a2c8  ldr      x8, [sp, #0x48]
0x0002a2cc  ldr      x0, [x8, x22, lsl #3]   ; @GOT ___objc_personality_v0
0x0002a2d0  bl       #0x59e00   ; CALL objc_msgSend$removeFromSuperview
0x0002a2d4  add      x22, x22, #1
0x0002a2d8  cmp      x20, x22
0x0002a2dc  b.ne     #0x2a2b0
0x0002a2e0  add      x2, sp, #0x40
0x0002a2e4  add      x3, sp, #0xb0
0x0002a2e8  mov      x0, x21
0x0002a2ec  mov      w4, #0x10
0x0002a2f0  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0002a2f4  mov      x20, x0
0x0002a2f8  cbnz     x0, #0x2a2ac
0x0002a2fc  mov      x0, x21
0x0002a300  bl       #0x55d78   ; CALL _objc_release
0x0002a304  ldr      x0, [sp, #0x30]
0x0002a308  bl       #0x56e60   ; CALL objc_msgSend$color
0x0002a30c  mov      x24, x0
0x0002a310  adrp     x8, #0x8e000
0x0002a314  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x0002a318  bl       #0x55c7c   ; CALL _objc_alloc
0x0002a31c  fmov     d0, #16.00000000
0x0002a320  fmov     d1, #11.00000000
0x0002a324  fmov     d2, #29.00000000
0x0002a328  fmov     d3, #29.00000000
0x0002a32c  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0002a330  mov      x19, x0
0x0002a334  adrp     x0, #0x7a000
0x0002a338  add      x0, x0, #0xc68   ; STR "#A78BFA"
0x0002a33c  bl       #0x18080   ; CALL _OMCColorFromHex
0x0002a340  mov      x29, x29
0x0002a344  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a348  mov      x20, x0
0x0002a34c  adrp     x0, #0x7a000
0x0002a350  add      x0, x0, #0xc48   ; STR "paintpalette.fill"
0x0002a354  mov      x1, x20
0x0002a358  bl       #0x18144   ; CALL _OMCIcon
0x0002a35c  mov      x29, x29
0x0002a360  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a364  mov      x22, x0
0x0002a368  mov      x0, x19
0x0002a36c  mov      x2, x22
0x0002a370  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x0002a374  mov      x0, x22
0x0002a378  bl       #0x55d78   ; CALL _objc_release
0x0002a37c  mov      x0, x20
0x0002a380  bl       #0x55d78   ; CALL _objc_release
0x0002a384  ldr      x23, [sp, #0x38]
0x0002a388  mov      x0, x23
0x0002a38c  str      x19, [sp, #0x18]
0x0002a390  mov      x2, x19
0x0002a394  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002a398  adrp     x21, #0x8e000
0x0002a39c  ldr      x0, [x21, #0x940]   ; @CLASS UILabel
0x0002a3a0  bl       #0x55c7c   ; CALL _objc_alloc
0x0002a3a4  mov      x8, #-0x3fb2000000000000
0x0002a3a8  fmov     d0, x8
0x0002a3ac  fadd     d0, d9, d0
0x0002a3b0  mov      x8, #-0x3fa2000000000000
0x0002a3b4  fmov     d1, x8
0x0002a3b8  fadd     d2, d0, d1
0x0002a3bc  mov      x8, #0x404e000000000000
0x0002a3c0  fmov     d0, x8
0x0002a3c4  mov      x8, #0x4049000000000000
0x0002a3c8  fmov     d8, x8
0x0002a3cc  fmov     d1, xzr
0x0002a3d0  mov      v3.16b, v8.16b
0x0002a3d4  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0002a3d8  mov      x22, x0
0x0002a3dc  adrp     x0, #0x7a000
0x0002a3e0  add      x0, x0, #0xc88   ; STR "SPEEDBUBBLE_COLOR"
0x0002a3e4  bl       #0x17e20   ; CALL _L
0x0002a3e8  mov      x29, x29
0x0002a3ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a3f0  mov      x20, x0
0x0002a3f4  mov      x0, x22
0x0002a3f8  mov      x2, x20
0x0002a3fc  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0002a400  mov      x0, x20
0x0002a404  bl       #0x55d78   ; CALL _objc_release
0x0002a408  adrp     x19, #0x8e000
0x0002a40c  ldr      x0, [x19, #0x948]   ; @CLASS UIFont
0x0002a410  adrp     x8, #0x74000
0x0002a414  ldr      x8, [x8, #0x250]   ; @GOT _UIFontWeightMedium
0x0002a418  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x0002a41c  fmov     d0, #16.00000000
0x0002a420  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x0002a424  mov      x29, x29
0x0002a428  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a42c  mov      x20, x0
0x0002a430  mov      x0, x22
0x0002a434  mov      x2, x20
0x0002a438  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x0002a43c  mov      x0, x20
0x0002a440  bl       #0x55d78   ; CALL _objc_release
0x0002a444  mov      x0, x23
0x0002a448  str      x22, [sp, #0x10]
0x0002a44c  mov      x2, x22
0x0002a450  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002a454  ldr      x0, [x21, #0x940]   ; @CLASS UILabel
0x0002a458  bl       #0x55c7c   ; CALL _objc_alloc
0x0002a45c  fmov     d0, #-16.00000000
0x0002a460  fadd     d0, d9, d0
0x0002a464  mov      x8, #-0x3fa3000000000000
0x0002a468  fmov     d1, x8
0x0002a46c  fadd     d0, d0, d1
0x0002a470  mov      x8, #0x405d000000000000
0x0002a474  fmov     d2, x8
0x0002a478  fmov     d1, xzr
0x0002a47c  mov      v3.16b, v8.16b
0x0002a480  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0002a484  mov      x21, x0
0x0002a488  adrp     x8, #0x8e000
0x0002a48c  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0002a490  str      x24, [sp, #0x28]
0x0002a494  str      x24, [sp]
0x0002a498  adrp     x2, #0x7a000
0x0002a49c  add      x2, x2, #0xca8   ; STR "SPEEDBUBBLE_COLOR_%ld"
0x0002a4a0  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0002a4a4  mov      x29, x29
0x0002a4a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a4ac  mov      x20, x0
0x0002a4b0  bl       #0x17e20   ; CALL _L
0x0002a4b4  mov      x29, x29
0x0002a4b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a4bc  mov      x22, x0
0x0002a4c0  mov      x0, x21
0x0002a4c4  mov      x2, x22
0x0002a4c8  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0002a4cc  mov      x0, x22
0x0002a4d0  bl       #0x55d78   ; CALL _objc_release
0x0002a4d4  mov      x0, x20
0x0002a4d8  bl       #0x55d78   ; CALL _objc_release
0x0002a4dc  ldr      x0, [x19, #0x948]   ; @CLASS UIFont
0x0002a4e0  fmov     d0, #15.00000000
0x0002a4e4  bl       #0x5d7c0   ; CALL objc_msgSend$systemFontOfSize:
0x0002a4e8  mov      x29, x29
0x0002a4ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a4f0  mov      x20, x0
0x0002a4f4  mov      x0, x21
0x0002a4f8  mov      x2, x20
0x0002a4fc  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x0002a500  mov      x0, x20
0x0002a504  bl       #0x55d78   ; CALL _objc_release
0x0002a508  adrp     x8, #0x8e000
0x0002a50c  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0002a510  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x0002a514  mov      x29, x29
0x0002a518  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a51c  mov      x20, x0
0x0002a520  mov      x0, x21
0x0002a524  mov      x2, x20
0x0002a528  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0002a52c  mov      x0, x20
0x0002a530  bl       #0x55d78   ; CALL _objc_release
0x0002a534  mov      x0, x21
0x0002a538  mov      w2, #2
0x0002a53c  bl       #0x5c4e0   ; CALL objc_msgSend$setTextAlignment:
0x0002a540  mov      x0, x23
0x0002a544  str      x21, [sp, #8]
0x0002a548  mov      x2, x21
0x0002a54c  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002a550  mov      x27, #0
0x0002a554  mov      x8, #-0x3fb4000000000000
0x0002a558  fmov     d0, x8
0x0002a55c  fadd     d0, d9, d0
0x0002a560  fmov     d1, #-20.00000000
0x0002a564  fadd     d0, d0, d1
0x0002a568  fmov     d1, #-26.00000000
0x0002a56c  fadd     d0, d0, d1
0x0002a570  fmov     d1, #6.00000000
0x0002a574  adrp     x8, #0x74000
0x0002a578  ldr      x8, [x8, #0x668]   ; @GOT _kCAGradientLayerConic
0x0002a57c  adrp     x9, #0x8b000
0x0002a580  mov      x10, #0x404c000000000000
0x0002a584  fmov     d13, x10
0x0002a588  adrp     x10, #0x65000
0x0002a58c  adrp     x11, #0x65000
0x0002a590  adrp     x12, #0x65000
0x0002a594  adrp     x13, #0x65000
0x0002a598  fdiv     d14, d0, d1
0x0002a59c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002a5a0  str      x8, [sp, #0x20]
0x0002a5a4  ldr      x22, [x9, #0xec8]   ; @SEL "colorTapped:"
0x0002a5a8  ldr      d9, [x10, #0x9c8]
0x0002a5ac  ldr      d10, [x11, #0x9d0]
0x0002a5b0  ldr      d11, [x12, #0x728]
0x0002a5b4  ldr      d12, [x13, #0x758]
0x0002a5b8  adrp     x8, #0x8e000
0x0002a5bc  ldr      x0, [x8, #0xbb0]   ; @CLASS UIControl
0x0002a5c0  bl       #0x55c7c   ; CALL _objc_alloc
0x0002a5c4  ucvtf    d0, x27
0x0002a5c8  fmadd    d0, d0, d14, d13
0x0002a5cc  fmov     d2, #26.00000000
0x0002a5d0  fmov     d3, #26.00000000
0x0002a5d4  mov      v1.16b, v8.16b
0x0002a5d8  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0002a5dc  mov      x26, x0
0x0002a5e0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002a5e4  mov      x29, x29
0x0002a5e8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a5ec  mov      x20, x0
0x0002a5f0  fmov     d0, #13.00000000
0x0002a5f4  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0002a5f8  mov      x0, x20
0x0002a5fc  bl       #0x55d78   ; CALL _objc_release
0x0002a600  mov      x0, x26
0x0002a604  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002a608  mov      x29, x29
0x0002a60c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a610  mov      x20, x0
0x0002a614  fmov     d0, #1.00000000
0x0002a618  bl       #0x5a740   ; CALL objc_msgSend$setBorderWidth:
0x0002a61c  mov      x0, x20
0x0002a620  bl       #0x55d78   ; CALL _objc_release
0x0002a624  adrp     x8, #0x8e000
0x0002a628  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0002a62c  mov      v0.16b, v9.16b
0x0002a630  mov      v1.16b, v10.16b
0x0002a634  mov      v2.16b, v11.16b
0x0002a638  mov      v3.16b, v12.16b
0x0002a63c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x0002a640  mov      x29, x29
0x0002a644  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a648  mov      x20, x0
0x0002a64c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002a650  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002a654  mov      x23, x0
0x0002a658  mov      x0, x26
0x0002a65c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002a660  mov      x29, x29
0x0002a664  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a668  mov      x24, x0
0x0002a66c  mov      x2, x23
0x0002a670  bl       #0x5a700   ; CALL objc_msgSend$setBorderColor:
0x0002a674  mov      x0, x24
0x0002a678  bl       #0x55d78   ; CALL _objc_release
0x0002a67c  mov      x0, x20
0x0002a680  bl       #0x55d78   ; CALL _objc_release
0x0002a684  adrp     x8, #0x8e000
0x0002a688  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0002a68c  str      x27, [sp]
0x0002a690  adrp     x2, #0x7a000
0x0002a694  add      x2, x2, #0xca8   ; STR "SPEEDBUBBLE_COLOR_%ld"
0x0002a698  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0002a69c  mov      x29, x29
0x0002a6a0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a6a4  mov      x20, x0
0x0002a6a8  bl       #0x17e20   ; CALL _L
0x0002a6ac  mov      x29, x29
0x0002a6b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a6b4  mov      x23, x0
0x0002a6b8  mov      x0, x26
0x0002a6bc  mov      x2, x23
0x0002a6c0  bl       #0x5a240   ; CALL objc_msgSend$setAccessibilityLabel:
0x0002a6c4  mov      x0, x23
0x0002a6c8  bl       #0x55d78   ; CALL _objc_release
0x0002a6cc  mov      x0, x20
0x0002a6d0  bl       #0x55d78   ; CALL _objc_release
0x0002a6d4  cbz      x27, #0x2a734
0x0002a6d8  adrp     x0, #0x7f000
0x0002a6dc  add      x0, x0, #0xb88
0x0002a6e0  bl       #0x573c0   ; CALL objc_msgSend$count
0x0002a6e4  cmp      x27, x0
0x0002a6e8  b.ge     #0x2a734
0x0002a6ec  adrp     x0, #0x7f000
0x0002a6f0  add      x0, x0, #0xb88
0x0002a6f4  mov      x2, x27
0x0002a6f8  bl       #0x59380   ; CALL objc_msgSend$objectAtIndexedSubscript:
0x0002a6fc  mov      x29, x29
0x0002a700  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a704  mov      x20, x0
0x0002a708  bl       #0x18080   ; CALL _OMCColorFromHex
0x0002a70c  mov      x29, x29
0x0002a710  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a714  mov      x24, x0
0x0002a718  mov      x0, x20
0x0002a71c  bl       #0x55d78   ; CALL _objc_release
0x0002a720  cbz      x24, #0x2a734
0x0002a724  mov      x0, x26
0x0002a728  mov      x2, x24
0x0002a72c  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0002a730  b        #0x2a8c8
0x0002a734  adrp     x8, #0x8e000
0x0002a738  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x0002a73c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002a740  mov      x29, x29
0x0002a744  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a748  mov      x24, x0
0x0002a74c  ldr      x2, [sp, #0x20]
0x0002a750  bl       #0x5c6e0   ; CALL objc_msgSend$setType:
0x0002a754  mov      x0, x26
0x0002a758  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0002a75c  mov      x0, x24
0x0002a760  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0002a764  fmov     d0, #13.00000000
0x0002a768  mov      x0, x24
0x0002a76c  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0002a770  fmov     d0, #0.50000000
0x0002a774  fmov     d1, #0.50000000
0x0002a778  mov      x0, x24
0x0002a77c  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x0002a780  fmov     d0, xzr
0x0002a784  fmov     d1, #1.00000000
0x0002a788  mov      x0, x24
0x0002a78c  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x0002a790  adrp     x21, #0x7a000
0x0002a794  add      x21, x21, #0xc68   ; STR "#A78BFA"
0x0002a798  mov      x0, x21
0x0002a79c  bl       #0x18080   ; CALL _OMCColorFromHex
0x0002a7a0  mov      x29, x29
0x0002a7a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a7a8  mov      x25, x0
0x0002a7ac  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002a7b0  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002a7b4  str      x0, [sp, #0x88]
0x0002a7b8  adrp     x0, #0x7a000
0x0002a7bc  add      x0, x0, #0xcc8   ; STR "#60C5FA"
0x0002a7c0  bl       #0x18080   ; CALL _OMCColorFromHex
0x0002a7c4  mov      x29, x29
0x0002a7c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a7cc  mov      x23, x0
0x0002a7d0  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002a7d4  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002a7d8  str      x0, [sp, #0x90]
0x0002a7dc  adrp     x0, #0x7a000
0x0002a7e0  add      x0, x0, #0xce8   ; STR "#5EDDB6"
0x0002a7e4  bl       #0x18080   ; CALL _OMCColorFromHex
0x0002a7e8  mov      x29, x29
0x0002a7ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a7f0  mov      x20, x0
0x0002a7f4  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002a7f8  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002a7fc  str      x0, [sp, #0x98]
0x0002a800  adrp     x0, #0x7a000
0x0002a804  add      x0, x0, #0xd08   ; STR "#F59AC0"
0x0002a808  bl       #0x18080   ; CALL _OMCColorFromHex
0x0002a80c  mov      x29, x29
0x0002a810  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a814  mov      x19, x0
0x0002a818  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002a81c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002a820  str      x0, [sp, #0xa0]
0x0002a824  mov      x0, x21
0x0002a828  bl       #0x18080   ; CALL _OMCColorFromHex
0x0002a82c  mov      x29, x29
0x0002a830  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a834  mov      x21, x0
0x0002a838  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002a83c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002a840  str      x0, [sp, #0xa8]
0x0002a844  adrp     x8, #0x8e000
0x0002a848  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0002a84c  add      x2, sp, #0x88
0x0002a850  mov      w3, #5
0x0002a854  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0002a858  mov      x29, x29
0x0002a85c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a860  mov      x28, x0
0x0002a864  mov      x0, x24
0x0002a868  mov      x2, x28
0x0002a86c  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0002a870  mov      x0, x28
0x0002a874  bl       #0x55d78   ; CALL _objc_release
0x0002a878  mov      x0, x21
0x0002a87c  bl       #0x55d78   ; CALL _objc_release
0x0002a880  mov      x0, x19
0x0002a884  bl       #0x55d78   ; CALL _objc_release
0x0002a888  mov      x0, x20
0x0002a88c  bl       #0x55d78   ; CALL _objc_release
0x0002a890  mov      x0, x23
0x0002a894  bl       #0x55d78   ; CALL _objc_release
0x0002a898  mov      x0, x25
0x0002a89c  bl       #0x55d78   ; CALL _objc_release
0x0002a8a0  mov      x0, x26
0x0002a8a4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002a8a8  mov      x29, x29
0x0002a8ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a8b0  mov      x19, x0
0x0002a8b4  mov      x2, x24
0x0002a8b8  mov      w3, #0
0x0002a8bc  bl       #0x58680   ; CALL objc_msgSend$insertSublayer:atIndex:
0x0002a8c0  mov      x0, x19
0x0002a8c4  bl       #0x55d78   ; CALL _objc_release
0x0002a8c8  mov      x0, x24
0x0002a8cc  bl       #0x55d78   ; CALL _objc_release
0x0002a8d0  ldr      x8, [sp, #0x28]
0x0002a8d4  cmp      x8, x27
0x0002a8d8  b.ne     #0x2a9b8
0x0002a8dc  adrp     x8, #0x8e000
0x0002a8e0  ldr      x0, [x8, #0xb48]   ; @CLASS CAShapeLayer
0x0002a8e4  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002a8e8  mov      x29, x29
0x0002a8ec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a8f0  mov      x24, x0
0x0002a8f4  adrp     x8, #0x8e000
0x0002a8f8  ldr      x19, [x8, #0xac0]   ; @CLASS UIBezierPath
0x0002a8fc  mov      x0, x26
0x0002a900  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0002a904  fmov     d4, #-4.00000000
0x0002a908  fmov     d5, #-4.00000000
0x0002a90c  bl       #0x55a90   ; CALL _CGRectInset
0x0002a910  mov      x0, x19
0x0002a914  bl       #0x56820   ; CALL objc_msgSend$bezierPathWithOvalInRect:
0x0002a918  mov      x29, x29
0x0002a91c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a920  mov      x19, x0
0x0002a924  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002a928  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x0002a92c  mov      x2, x0
0x0002a930  mov      x0, x24
0x0002a934  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x0002a938  mov      x0, x19
0x0002a93c  bl       #0x55d78   ; CALL _objc_release
0x0002a940  mov      x0, x24
0x0002a944  mov      x2, #0
0x0002a948  bl       #0x5ae40   ; CALL objc_msgSend$setFillColor:
0x0002a94c  adrp     x0, #0x7a000
0x0002a950  add      x0, x0, #0xd28   ; STR "#6F62F2"
0x0002a954  bl       #0x18080   ; CALL _OMCColorFromHex
0x0002a958  mov      x29, x29
0x0002a95c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a960  mov      x19, x0
0x0002a964  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002a968  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002a96c  mov      x2, x0
0x0002a970  mov      x0, x24
0x0002a974  bl       #0x5c380   ; CALL objc_msgSend$setStrokeColor:
0x0002a978  mov      x0, x19
0x0002a97c  bl       #0x55d78   ; CALL _objc_release
0x0002a980  fmov     d0, #2.00000000
0x0002a984  mov      x0, x24
0x0002a988  bl       #0x5b3a0   ; CALL objc_msgSend$setLineWidth:
0x0002a98c  mov      x0, x26
0x0002a990  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002a994  mov      x29, x29
0x0002a998  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a99c  mov      x19, x0
0x0002a9a0  mov      x2, x24
0x0002a9a4  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0002a9a8  mov      x0, x19
0x0002a9ac  bl       #0x55d78   ; CALL _objc_release
0x0002a9b0  mov      x0, x24
0x0002a9b4  bl       #0x55d78   ; CALL _objc_release
0x0002a9b8  adrp     x8, #0x8e000
0x0002a9bc  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x0002a9c0  mov      x2, x27
0x0002a9c4  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x0002a9c8  mov      x29, x29
0x0002a9cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002a9d0  mov      x19, x0
0x0002a9d4  mov      x0, x26
0x0002a9d8  adrp     x1, #0x90000
0x0002a9dc  add      x1, x1, #0x38
0x0002a9e0  mov      x2, x19
0x0002a9e4  mov      w3, #1
0x0002a9e8  bl       #0x55db4   ; CALL _objc_setAssociatedObject
0x0002a9ec  mov      x0, x19
0x0002a9f0  bl       #0x55d78   ; CALL _objc_release
0x0002a9f4  mov      x0, x26
0x0002a9f8  ldr      x2, [sp, #0x30]
0x0002a9fc  mov      x3, x22
0x0002aa00  mov      w4, #0x40
0x0002aa04  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x0002aa08  ldr      x0, [sp, #0x38]
0x0002aa0c  mov      x2, x26
0x0002aa10  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002aa14  mov      x0, x26
0x0002aa18  bl       #0x55d78   ; CALL _objc_release
0x0002aa1c  add      x27, x27, #1
0x0002aa20  cmp      x27, #7
0x0002aa24  b.ne     #0x2a5b8
0x0002aa28  ldr      x0, [sp, #8]
0x0002aa2c  bl       #0x55d78   ; CALL _objc_release
0x0002aa30  ldr      x0, [sp, #0x10]
0x0002aa34  bl       #0x55d78   ; CALL _objc_release
0x0002aa38  ldr      x0, [sp, #0x18]
0x0002aa3c  bl       #0x55d78   ; CALL _objc_release
0x0002aa40  ldr      x0, [sp, #0x38]
0x0002aa44  bl       #0x55d78   ; CALL _objc_release
0x0002aa48  ldur     x8, [x29, #-0xa0]
0x0002aa4c  adrp     x9, #0x74000
0x0002aa50  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0002aa54  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0002aa58  cmp      x9, x8
0x0002aa5c  b.ne     #0x2aa90
0x0002aa60  ldp      x29, x30, [sp, #0x1d0]
0x0002aa64  ldp      x20, x19, [sp, #0x1c0]
0x0002aa68  ldp      x22, x21, [sp, #0x1b0]
0x0002aa6c  ldp      x24, x23, [sp, #0x1a0]
0x0002aa70  ldp      x26, x25, [sp, #0x190]
0x0002aa74  ldp      x28, x27, [sp, #0x180]
0x0002aa78  ldp      d9, d8, [sp, #0x170]
0x0002aa7c  ldp      d11, d10, [sp, #0x160]
0x0002aa80  ldp      d13, d12, [sp, #0x150]
0x0002aa84  ldp      d15, d14, [sp, #0x140]
0x0002aa88  add      sp, sp, #0x1e0
0x0002aa8c  ret      
0x0002aa90  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCSpeedBubbleController colorTapped:]  va=0x2aa94 size=156 types=v24@0:8@16
0x0002aa94  stp      x22, x21, [sp, #-0x30]!
0x0002aa98  stp      x20, x19, [sp, #0x10]
0x0002aa9c  stp      x29, x30, [sp, #0x20]
0x0002aaa0  add      x29, sp, #0x20
0x0002aaa4  mov      x19, x2
0x0002aaa8  mov      x20, x0
0x0002aaac  adrp     x8, #0x8e000
0x0002aab0  ldr      x21, [x8, #0x938]   ; @CLASS UISelectionFeedbackGenerator
0x0002aab4  mov      x0, x2
0x0002aab8  bl       #0x55d84   ; CALL _objc_retain
0x0002aabc  mov      x0, x21
0x0002aac0  bl       #0x55d60   ; CALL _objc_opt_new
0x0002aac4  mov      x21, x0
0x0002aac8  bl       #0x5a200   ; CALL objc_msgSend$selectionChanged
0x0002aacc  mov      x0, x21
0x0002aad0  bl       #0x55d78   ; CALL _objc_release
0x0002aad4  adrp     x1, #0x90000
0x0002aad8  add      x1, x1, #0x38
0x0002aadc  mov      x0, x19
0x0002aae0  bl       #0x55d00   ; CALL _objc_getAssociatedObject
0x0002aae4  mov      x29, x29
0x0002aae8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002aaec  mov      x21, x0
0x0002aaf0  mov      x0, x19
0x0002aaf4  bl       #0x55d78   ; CALL _objc_release
0x0002aaf8  adrp     x19, #0x7a000
0x0002aafc  add      x19, x19, #0x208   ; STR "speedBubbleColor"
0x0002ab00  mov      x0, x20
0x0002ab04  mov      x2, x21
0x0002ab08  mov      x3, x19
0x0002ab0c  bl       #0x5d3c0   ; CALL objc_msgSend$storeValue:forKey:
0x0002ab10  mov      x0, x21
0x0002ab14  bl       #0x55d78   ; CALL _objc_release
0x0002ab18  mov      x0, x20
0x0002ab1c  mov      x2, x19
0x0002ab20  ldp      x29, x30, [sp, #0x20]
0x0002ab24  ldp      x20, x19, [sp, #0x10]
0x0002ab28  ldp      x22, x21, [sp], #0x30
0x0002ab2c  b        #0x59880   ; CALL objc_msgSend$prefChanged:

=== -[OMCSpeedBubbleController layoutStylesIn:width:]  va=0x2ab30 size=3036 types=v32@0:8@16d24
0x0002ab30  stp      d15, d14, [sp, #-0xa0]!
0x0002ab34  stp      d13, d12, [sp, #0x10]
0x0002ab38  stp      d11, d10, [sp, #0x20]
0x0002ab3c  stp      d9, d8, [sp, #0x30]
0x0002ab40  stp      x28, x27, [sp, #0x40]
0x0002ab44  stp      x26, x25, [sp, #0x50]
0x0002ab48  stp      x24, x23, [sp, #0x60]
0x0002ab4c  stp      x22, x21, [sp, #0x70]
0x0002ab50  stp      x20, x19, [sp, #0x80]
0x0002ab54  stp      x29, x30, [sp, #0x90]
0x0002ab58  add      x29, sp, #0x90
0x0002ab5c  sub      sp, sp, #0x1e0
0x0002ab60  mov      v8.16b, v0.16b
0x0002ab64  mov      x24, x2
0x0002ab68  mov      x20, x0
0x0002ab6c  adrp     x8, #0x74000
0x0002ab70  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0002ab74  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002ab78  stur     x8, [x29, #-0xa0]
0x0002ab7c  mov      x0, x2
0x0002ab80  bl       #0x55d84   ; CALL _objc_retain
0x0002ab84  mov      x0, x20
0x0002ab88  bl       #0x5d660   ; CALL objc_msgSend$styleStrip
0x0002ab8c  mov      x29, x29
0x0002ab90  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ab94  cbz      x0, #0x2abdc
0x0002ab98  mov      x19, x0
0x0002ab9c  mov      x0, x20
0x0002aba0  bl       #0x5d660   ; CALL objc_msgSend$styleStrip
0x0002aba4  mov      x29, x29
0x0002aba8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002abac  mov      x21, x0
0x0002abb0  bl       #0x5d740   ; CALL objc_msgSend$superview
0x0002abb4  mov      x29, x29
0x0002abb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002abbc  mov      x22, x0
0x0002abc0  bl       #0x55d78   ; CALL _objc_release
0x0002abc4  mov      x0, x21
0x0002abc8  bl       #0x55d78   ; CALL _objc_release
0x0002abcc  mov      x0, x19
0x0002abd0  bl       #0x55d78   ; CALL _objc_release
0x0002abd4  cmp      x22, x24
0x0002abd8  b.eq     #0x2ad1c
0x0002abdc  movi     v0.16b, #0
0x0002abe0  stp      q0, q0, [sp, #0xb0]
0x0002abe4  stp      q0, q0, [sp, #0x90]
0x0002abe8  mov      x0, x24
0x0002abec  bl       #0x5d700   ; CALL objc_msgSend$subviews
0x0002abf0  mov      x29, x29
0x0002abf4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002abf8  mov      x21, x0
0x0002abfc  bl       #0x572e0   ; CALL objc_msgSend$copy
0x0002ac00  mov      x19, x0
0x0002ac04  mov      x0, x21
0x0002ac08  bl       #0x55d78   ; CALL _objc_release
0x0002ac0c  add      x2, sp, #0x90
0x0002ac10  add      x3, sp, #0x150
0x0002ac14  mov      x0, x19
0x0002ac18  mov      w4, #0x10
0x0002ac1c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0002ac20  cbz      x0, #0x2ac80
0x0002ac24  mov      x21, x0
0x0002ac28  ldr      x8, [sp, #0xa0]
0x0002ac2c  ldr      x22, [x8]   ; @GOT ___objc_personality_v0
0x0002ac30  mov      x23, #0
0x0002ac34  ldr      x8, [sp, #0xa0]
0x0002ac38  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002ac3c  cmp      x8, x22
0x0002ac40  b.eq     #0x2ac4c
0x0002ac44  mov      x0, x19
0x0002ac48  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0002ac4c  ldr      x8, [sp, #0x98]
0x0002ac50  ldr      x0, [x8, x23, lsl #3]   ; @GOT ___objc_personality_v0
0x0002ac54  bl       #0x59e00   ; CALL objc_msgSend$removeFromSuperview
0x0002ac58  add      x23, x23, #1
0x0002ac5c  cmp      x21, x23
0x0002ac60  b.ne     #0x2ac34
0x0002ac64  add      x2, sp, #0x90
0x0002ac68  add      x3, sp, #0x150
0x0002ac6c  mov      x0, x19
0x0002ac70  mov      w4, #0x10
0x0002ac74  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0002ac78  mov      x21, x0
0x0002ac7c  cbnz     x0, #0x2ac30
0x0002ac80  mov      x0, x19
0x0002ac84  bl       #0x55d78   ; CALL _objc_release
0x0002ac88  adrp     x8, #0x8e000
0x0002ac8c  ldr      x0, [x8, #0xa30]   ; @CLASS UIScrollView
0x0002ac90  bl       #0x55d60   ; CALL _objc_opt_new
0x0002ac94  mov      x19, x0
0x0002ac98  mov      x0, x20
0x0002ac9c  mov      x2, x19
0x0002aca0  bl       #0x5c420   ; CALL objc_msgSend$setStyleStrip:
0x0002aca4  mov      x0, x19
0x0002aca8  bl       #0x55d78   ; CALL _objc_release
0x0002acac  mov      x0, x20
0x0002acb0  bl       #0x5d660   ; CALL objc_msgSend$styleStrip
0x0002acb4  mov      x29, x29
0x0002acb8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002acbc  mov      x19, x0
0x0002acc0  mov      w2, #0
0x0002acc4  bl       #0x5c140   ; CALL objc_msgSend$setShowsHorizontalScrollIndicator:
0x0002acc8  mov      x0, x19
0x0002accc  bl       #0x55d78   ; CALL _objc_release
0x0002acd0  mov      x0, x20
0x0002acd4  bl       #0x5d660   ; CALL objc_msgSend$styleStrip
0x0002acd8  mov      x29, x29
0x0002acdc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ace0  mov      x19, x0
0x0002ace4  mov      w2, #1
0x0002ace8  bl       #0x5a400   ; CALL objc_msgSend$setAlwaysBounceHorizontal:
0x0002acec  mov      x0, x19
0x0002acf0  bl       #0x55d78   ; CALL _objc_release
0x0002acf4  mov      x0, x20
0x0002acf8  bl       #0x5d660   ; CALL objc_msgSend$styleStrip
0x0002acfc  mov      x29, x29
0x0002ad00  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ad04  mov      x19, x0
0x0002ad08  mov      x0, x24
0x0002ad0c  mov      x2, x19
0x0002ad10  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002ad14  mov      x0, x19
0x0002ad18  bl       #0x55d78   ; CALL _objc_release
0x0002ad1c  mov      x0, x20
0x0002ad20  bl       #0x5d660   ; CALL objc_msgSend$styleStrip
0x0002ad24  mov      x29, x29
0x0002ad28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ad2c  mov      x25, x0
0x0002ad30  movi     v0.16b, #0
0x0002ad34  stp      q0, q0, [sp, #0x50]
0x0002ad38  stp      q0, q0, [sp, #0x70]
0x0002ad3c  bl       #0x5d700   ; CALL objc_msgSend$subviews
0x0002ad40  mov      x29, x29
0x0002ad44  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ad48  mov      x21, x0
0x0002ad4c  bl       #0x572e0   ; CALL objc_msgSend$copy
0x0002ad50  mov      x19, x0
0x0002ad54  mov      x0, x21
0x0002ad58  bl       #0x55d78   ; CALL _objc_release
0x0002ad5c  add      x2, sp, #0x50
0x0002ad60  add      x3, sp, #0xd0
0x0002ad64  mov      x0, x19
0x0002ad68  mov      w4, #0x10
0x0002ad6c  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0002ad70  cbz      x0, #0x2add0
0x0002ad74  mov      x21, x0
0x0002ad78  ldr      x8, [sp, #0x60]
0x0002ad7c  ldr      x22, [x8]   ; @SEL "whatsNewNavigationController"
0x0002ad80  mov      x23, #0
0x0002ad84  ldr      x8, [sp, #0x60]
0x0002ad88  ldr      x8, [x8]   ; @SEL "whatsNewNavigationController"
0x0002ad8c  cmp      x8, x22
0x0002ad90  b.eq     #0x2ad9c
0x0002ad94  mov      x0, x19
0x0002ad98  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0002ad9c  ldr      x8, [sp, #0x58]
0x0002ada0  ldr      x0, [x8, x23, lsl #3]   ; @CSTR "whatsNewNavigationController"
0x0002ada4  bl       #0x59e00   ; CALL objc_msgSend$removeFromSuperview
0x0002ada8  add      x23, x23, #1
0x0002adac  cmp      x21, x23
0x0002adb0  b.ne     #0x2ad84
0x0002adb4  add      x2, sp, #0x50
0x0002adb8  add      x3, sp, #0xd0
0x0002adbc  mov      x0, x19
0x0002adc0  mov      w4, #0x10
0x0002adc4  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0002adc8  mov      x21, x0
0x0002adcc  cbnz     x0, #0x2ad80
0x0002add0  str      x24, [sp, #0x18]
0x0002add4  mov      x0, x19
0x0002add8  bl       #0x55d78   ; CALL _objc_release
0x0002addc  mov      x8, #0x405c000000000000
0x0002ade0  fmov     d3, x8
0x0002ade4  fmov     d0, xzr
0x0002ade8  fmov     d1, xzr
0x0002adec  str      x25, [sp, #0x48]
0x0002adf0  mov      x0, x25
0x0002adf4  str      d8, [sp, #0x10]
0x0002adf8  mov      v2.16b, v8.16b
0x0002adfc  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0002ae00  adrp     x8, #0x65000
0x0002ae04  ldr      d9, [x8, #0x9d8]
0x0002ae08  mov      x8, #0x4052000000000000
0x0002ae0c  fmov     d1, x8
0x0002ae10  mov      v0.16b, v9.16b
0x0002ae14  str      d1, [sp, #0x30]
0x0002ae18  bl       #0x28448
0x0002ae1c  mov      x29, x29
0x0002ae20  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ae24  str      x0, [sp, #0x40]
0x0002ae28  mov      x0, x20
0x0002ae2c  bl       #0x5d620   ; CALL objc_msgSend$style
0x0002ae30  str      x0, [sp, #0x38]
0x0002ae34  mov      x24, #0
0x0002ae38  adrp     x8, #0x8b000
0x0002ae3c  ldr      x25, [x8, #0xed0]   ; @SEL "styleTapped:"
0x0002ae40  adrp     x8, #0x74000
0x0002ae44  ldr      x8, [x8, #0x648]   ; @GOT _kCACornerCurveContinuous
0x0002ae48  ldr      x26, [x8]   ; @GOT ___objc_personality_v0
0x0002ae4c  adrp     x8, #0x74000
0x0002ae50  ldr      x8, [x8, #0x610]   ; @GOT _CGRectZero
0x0002ae54  ldp      d4, d0, [x8]
0x0002ae58  stp      d0, d4, [sp, #0x20]
0x0002ae5c  ldp      d14, d15, [x8, #0x10]
0x0002ae60  adrp     x8, #0x74000
0x0002ae64  ldr      x8, [x8, #0x260]   ; @GOT _UIFontWeightSemibold
0x0002ae68  ldr      d8, [x8]   ; @GOT ___objc_personality_v0
0x0002ae6c  fmov     d10, #12.00000000
0x0002ae70  adrp     x8, #0x65000
0x0002ae74  ldr      d11, [x8, #0x9e0]
0x0002ae78  adrp     x8, #0x65000
0x0002ae7c  ldr      d12, [x8, #0x708]
0x0002ae80  mov      x8, #0x4053000000000000
0x0002ae84  fmov     d13, x8
0x0002ae88  adrp     x8, #0x8e000
0x0002ae8c  ldr      x0, [x8, #0xbb0]   ; @CLASS UIControl
0x0002ae90  bl       #0x55c7c   ; CALL _objc_alloc
0x0002ae94  fmov     d1, #10.00000000
0x0002ae98  mov      v0.16b, v10.16b
0x0002ae9c  mov      v2.16b, v9.16b
0x0002aea0  mov      v3.16b, v11.16b
0x0002aea4  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0002aea8  mov      x19, x0
0x0002aeac  adrp     x8, #0x8e000
0x0002aeb0  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x0002aeb4  mov      x2, x24
0x0002aeb8  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x0002aebc  mov      x29, x29
0x0002aec0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002aec4  mov      x21, x0
0x0002aec8  mov      x0, x19
0x0002aecc  adrp     x1, #0x90000
0x0002aed0  add      x1, x1, #0x38
0x0002aed4  mov      x2, x21
0x0002aed8  mov      w3, #1
0x0002aedc  bl       #0x55db4   ; CALL _objc_setAssociatedObject
0x0002aee0  mov      x0, x21
0x0002aee4  bl       #0x55d78   ; CALL _objc_release
0x0002aee8  mov      x0, x19
0x0002aeec  mov      x2, x20
0x0002aef0  mov      x3, x25
0x0002aef4  mov      w4, #0x40
0x0002aef8  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x0002aefc  adrp     x8, #0x8e000
0x0002af00  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x0002af04  bl       #0x55c7c   ; CALL _objc_alloc
0x0002af08  fmov     d0, xzr
0x0002af0c  fmov     d1, xzr
0x0002af10  mov      v2.16b, v9.16b
0x0002af14  ldr      d3, [sp, #0x30]
0x0002af18  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0002af1c  mov      x27, x0
0x0002af20  ldr      x2, [sp, #0x40]
0x0002af24  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x0002af28  mov      x0, x27
0x0002af2c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002af30  mov      x29, x29
0x0002af34  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002af38  mov      x21, x0
0x0002af3c  fmov     d0, #14.00000000
0x0002af40  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0002af44  mov      x0, x21
0x0002af48  bl       #0x55d78   ; CALL _objc_release
0x0002af4c  mov      x0, x27
0x0002af50  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002af54  mov      x29, x29
0x0002af58  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002af5c  mov      x21, x0
0x0002af60  mov      x2, x26
0x0002af64  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x0002af68  mov      x0, x21
0x0002af6c  bl       #0x55d78   ; CALL _objc_release
0x0002af70  mov      x0, x27
0x0002af74  mov      w2, #1
0x0002af78  bl       #0x5a8a0   ; CALL objc_msgSend$setClipsToBounds:
0x0002af7c  mov      x0, x27
0x0002af80  mov      w2, #0
0x0002af84  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x0002af88  mov      x0, x19
0x0002af8c  mov      x2, x27
0x0002af90  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002af94  adrp     x8, #0x8e000
0x0002af98  ldr      x0, [x8, #0xb98]   ; @CLASS SPPBubbleView
0x0002af9c  bl       #0x55c7c   ; CALL _objc_alloc
0x0002afa0  ldp      d1, d0, [sp, #0x20]
0x0002afa4  mov      v2.16b, v14.16b
0x0002afa8  mov      v3.16b, v15.16b
0x0002afac  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0002afb0  mov      x28, x0
0x0002afb4  mov      x0, x20
0x0002afb8  mov      x2, x28
0x0002afbc  mov      x3, x24
0x0002afc0  mov      w4, #0x34
0x0002afc4  mov      w5, #0x3c
0x0002afc8  bl       #0x57120   ; CALL objc_msgSend$configure:style:speed:limit:
0x0002afcc  mov      x0, x19
0x0002afd0  mov      x2, x28
0x0002afd4  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002afd8  mov      x0, x27
0x0002afdc  bl       #0x57d00   ; CALL objc_msgSend$frame
0x0002afe0  mov      x0, x28
0x0002afe4  mov      v4.16b, v12.16b
0x0002afe8  bl       #0x26920
0x0002afec  adrp     x8, #0x8e000
0x0002aff0  ldr      x0, [x8, #0x940]   ; @CLASS UILabel
0x0002aff4  bl       #0x55c7c   ; CALL _objc_alloc
0x0002aff8  fmov     d0, #-4.00000000
0x0002affc  fmov     d3, #16.00000000
0x0002b000  mov      v1.16b, v13.16b
0x0002b004  mov      v2.16b, v11.16b
0x0002b008  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0002b00c  mov      x21, x0
0x0002b010  adrp     x8, #0x8e000
0x0002b014  ldr      x0, [x8, #0x958]   ; @CLASS NSString
0x0002b018  str      x24, [sp]
0x0002b01c  adrp     x2, #0x7a000
0x0002b020  add      x2, x2, #0xd48   ; STR "SPEEDBUBBLE_LOOK_%ld"
0x0002b024  bl       #0x5d580   ; CALL objc_msgSend$stringWithFormat:
0x0002b028  mov      x29, x29
0x0002b02c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b030  mov      x22, x0
0x0002b034  bl       #0x17e20   ; CALL _L
0x0002b038  mov      x29, x29
0x0002b03c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b040  mov      x23, x0
0x0002b044  mov      x0, x21
0x0002b048  mov      x2, x23
0x0002b04c  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0002b050  mov      x0, x23
0x0002b054  bl       #0x55d78   ; CALL _objc_release
0x0002b058  mov      x0, x22
0x0002b05c  bl       #0x55d78   ; CALL _objc_release
0x0002b060  adrp     x8, #0x8e000
0x0002b064  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x0002b068  fmov     d0, #11.50000000
0x0002b06c  mov      v1.16b, v8.16b
0x0002b070  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x0002b074  mov      x29, x29
0x0002b078  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b07c  mov      x22, x0
0x0002b080  mov      x0, x21
0x0002b084  mov      x2, x22
0x0002b088  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x0002b08c  mov      x0, x22
0x0002b090  bl       #0x55d78   ; CALL _objc_release
0x0002b094  adrp     x8, #0x8e000
0x0002b098  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0002b09c  ldr      x8, [sp, #0x38]
0x0002b0a0  cmp      x8, x24
0x0002b0a4  b.ne     #0x2b158
0x0002b0a8  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x0002b0ac  mov      x29, x29
0x0002b0b0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b0b4  mov      x22, x0
0x0002b0b8  mov      x0, x21
0x0002b0bc  mov      x2, x22
0x0002b0c0  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0002b0c4  mov      x0, x22
0x0002b0c8  bl       #0x55d78   ; CALL _objc_release
0x0002b0cc  mov      x0, x21
0x0002b0d0  mov      w2, #1
0x0002b0d4  bl       #0x5c4e0   ; CALL objc_msgSend$setTextAlignment:
0x0002b0d8  mov      x0, x21
0x0002b0dc  mov      w2, #1
0x0002b0e0  bl       #0x5a380   ; CALL objc_msgSend$setAdjustsFontSizeToFitWidth:
0x0002b0e4  fmov     d0, #0.75000000
0x0002b0e8  mov      x0, x21
0x0002b0ec  bl       #0x5b660   ; CALL objc_msgSend$setMinimumScaleFactor:
0x0002b0f0  mov      x0, x19
0x0002b0f4  mov      x2, x21
0x0002b0f8  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002b0fc  ldr      x0, [sp, #0x48]
0x0002b100  mov      x2, x19
0x0002b104  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002b108  adrp     x8, #0x8e000
0x0002b10c  ldr      x0, [x8, #0x918]   ; @CLASS UIView
0x0002b110  bl       #0x55c7c   ; CALL _objc_alloc
0x0002b114  mov      x22, x0
0x0002b118  mov      x0, x27
0x0002b11c  bl       #0x57d00   ; CALL objc_msgSend$frame
0x0002b120  mov      x0, x22
0x0002b124  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0002b128  mov      x22, x0
0x0002b12c  mov      w2, #0
0x0002b130  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x0002b134  mov      x0, x19
0x0002b138  mov      x2, x22
0x0002b13c  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002b140  mov      x0, x22
0x0002b144  mov      w1, #1
0x0002b148  bl       #0x2b2ec
0x0002b14c  mov      x0, x22
0x0002b150  bl       #0x55d78   ; CALL _objc_release
0x0002b154  b        #0x2b1b8
0x0002b158  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x0002b15c  mov      x29, x29
0x0002b160  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b164  mov      x22, x0
0x0002b168  mov      x0, x21
0x0002b16c  mov      x2, x22
0x0002b170  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0002b174  mov      x0, x22
0x0002b178  bl       #0x55d78   ; CALL _objc_release
0x0002b17c  mov      x0, x21
0x0002b180  mov      w2, #1
0x0002b184  bl       #0x5c4e0   ; CALL objc_msgSend$setTextAlignment:
0x0002b188  mov      x0, x21
0x0002b18c  mov      w2, #1
0x0002b190  bl       #0x5a380   ; CALL objc_msgSend$setAdjustsFontSizeToFitWidth:
0x0002b194  fmov     d0, #0.75000000
0x0002b198  mov      x0, x21
0x0002b19c  bl       #0x5b660   ; CALL objc_msgSend$setMinimumScaleFactor:
0x0002b1a0  mov      x0, x19
0x0002b1a4  mov      x2, x21
0x0002b1a8  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002b1ac  ldr      x0, [sp, #0x48]
0x0002b1b0  mov      x2, x19
0x0002b1b4  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002b1b8  fadd     d10, d10, d11
0x0002b1bc  mov      x0, x21
0x0002b1c0  bl       #0x55d78   ; CALL _objc_release
0x0002b1c4  mov      x0, x28
0x0002b1c8  bl       #0x55d78   ; CALL _objc_release
0x0002b1cc  mov      x0, x27
0x0002b1d0  bl       #0x55d78   ; CALL _objc_release
0x0002b1d4  mov      x0, x19
0x0002b1d8  bl       #0x55d78   ; CALL _objc_release
0x0002b1dc  add      x24, x24, #1
0x0002b1e0  cmp      x24, #9
0x0002b1e4  b.ne     #0x2ae88
0x0002b1e8  fmov     d0, #4.00000000
0x0002b1ec  fadd     d0, d10, d0
0x0002b1f0  mov      x8, #0x405c000000000000
0x0002b1f4  fmov     d1, x8
0x0002b1f8  ldr      x21, [sp, #0x48]
0x0002b1fc  mov      x0, x21
0x0002b200  bl       #0x5aac0   ; CALL objc_msgSend$setContentSize:
0x0002b204  mov      x0, x20
0x0002b208  bl       #0x5d5c0   ; CALL objc_msgSend$stripOffset
0x0002b20c  fcmp     d0, #0.0
0x0002b210  b.le     #0x2b22c
0x0002b214  mov      x0, x20
0x0002b218  bl       #0x5d5c0   ; CALL objc_msgSend$stripOffset
0x0002b21c  mov      v8.16b, v0.16b
0x0002b220  ldr      x19, [sp, #0x18]
0x0002b224  ldr      d9, [sp, #0x10]
0x0002b228  b        #0x2b264
0x0002b22c  ldr      x8, [sp, #0x38]
0x0002b230  cmp      x8, #3
0x0002b234  ldr      x19, [sp, #0x18]
0x0002b238  b.lt     #0x2b288
0x0002b23c  ucvtf    d0, x8
0x0002b240  fmov     d1, #12.00000000
0x0002b244  fmadd    d0, d0, d11, d1
0x0002b248  adrp     x8, #0x65000
0x0002b24c  ldr      d1, [x8, #0x9e8]
0x0002b250  ldr      d9, [sp, #0x10]
0x0002b254  fadd     d1, d9, d1
0x0002b258  fmov     d2, #-0.50000000
0x0002b25c  fmul     d1, d1, d2
0x0002b260  fadd     d8, d0, d1
0x0002b264  mov      x0, x21
0x0002b268  bl       #0x57260   ; CALL objc_msgSend$contentSize
0x0002b26c  fsub     d0, d0, d9
0x0002b270  fmov     d1, xzr
0x0002b274  fmaxnm   d0, d0, d1
0x0002b278  fcmp     d8, d0
0x0002b27c  fcsel    d0, d8, d0, mi
0x0002b280  mov      x0, x21
0x0002b284  bl       #0x5aa60   ; CALL objc_msgSend$setContentOffset:
0x0002b288  ldr      x0, [sp, #0x40]
0x0002b28c  bl       #0x55d78   ; CALL _objc_release
0x0002b290  mov      x0, x21
0x0002b294  bl       #0x55d78   ; CALL _objc_release
0x0002b298  mov      x0, x19
0x0002b29c  bl       #0x55d78   ; CALL _objc_release
0x0002b2a0  ldur     x8, [x29, #-0xa0]
0x0002b2a4  adrp     x9, #0x74000
0x0002b2a8  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0002b2ac  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0002b2b0  cmp      x9, x8
0x0002b2b4  b.ne     #0x2b2e8
0x0002b2b8  add      sp, sp, #0x1e0
0x0002b2bc  ldp      x29, x30, [sp, #0x90]
0x0002b2c0  ldp      x20, x19, [sp, #0x80]
0x0002b2c4  ldp      x22, x21, [sp, #0x70]
0x0002b2c8  ldp      x24, x23, [sp, #0x60]
0x0002b2cc  ldp      x26, x25, [sp, #0x50]
0x0002b2d0  ldp      x28, x27, [sp, #0x40]
0x0002b2d4  ldp      d9, d8, [sp, #0x30]
0x0002b2d8  ldp      d11, d10, [sp, #0x20]
0x0002b2dc  ldp      d13, d12, [sp, #0x10]
0x0002b2e0  ldp      d15, d14, [sp], #0xa0
0x0002b2e4  ret      
0x0002b2e8  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0002b2ec  sub      sp, sp, #0x170
0x0002b2f0  stp      x28, x27, [sp, #0x110]
0x0002b2f4  stp      x26, x25, [sp, #0x120]
0x0002b2f8  stp      x24, x23, [sp, #0x130]
0x0002b2fc  stp      x22, x21, [sp, #0x140]
0x0002b300  stp      x20, x19, [sp, #0x150]
0x0002b304  stp      x29, x30, [sp, #0x160]
0x0002b308  add      x29, sp, #0x160
0x0002b30c  str      w1, [sp, #0xc]
0x0002b310  mov      x19, x0
0x0002b314  adrp     x8, #0x74000
0x0002b318  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0002b31c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002b320  stur     x8, [x29, #-0x60]
0x0002b324  bl       #0x55d84   ; CALL _objc_retain
0x0002b328  movi     v0.16b, #0
0x0002b32c  stp      q0, q0, [sp, #0x10]
0x0002b330  stp      q0, q0, [sp, #0x30]
0x0002b334  mov      x21, x19
0x0002b338  mov      x0, x19
0x0002b33c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002b340  mov      x29, x29
0x0002b344  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b348  mov      x20, x0
0x0002b34c  bl       #0x5d6a0   ; CALL objc_msgSend$sublayers
0x0002b350  mov      x29, x29
0x0002b354  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b358  mov      x22, x0
0x0002b35c  mov      x0, x20
0x0002b360  bl       #0x55d78   ; CALL _objc_release
0x0002b364  add      x2, sp, #0x10
0x0002b368  add      x3, sp, #0x80
0x0002b36c  mov      x0, x22
0x0002b370  mov      w4, #0x10
0x0002b374  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0002b378  cbz      x0, #0x2b424
0x0002b37c  mov      x24, x0
0x0002b380  mov      x20, #0
0x0002b384  ldr      x8, [sp, #0x20]
0x0002b388  ldr      x28, [x8]   ; @GOT ___objc_personality_v0
0x0002b38c  adrp     x23, #0x7b000
0x0002b390  add      x23, x23, #0x68   ; STR "omcRing"
0x0002b394  mov      x19, #0
0x0002b398  ldr      x8, [sp, #0x20]
0x0002b39c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002b3a0  cmp      x8, x28
0x0002b3a4  b.eq     #0x2b3b0
0x0002b3a8  mov      x0, x22
0x0002b3ac  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0002b3b0  ldr      x8, [sp, #0x18]
0x0002b3b4  ldr      x25, [x8, x19, lsl #3]   ; @GOT ___objc_personality_v0
0x0002b3b8  mov      x0, x25
0x0002b3bc  bl       #0x590e0   ; CALL objc_msgSend$name
0x0002b3c0  mov      x29, x29
0x0002b3c4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b3c8  mov      x26, x0
0x0002b3cc  mov      x2, x23
0x0002b3d0  bl       #0x58800   ; CALL objc_msgSend$isEqualToString:
0x0002b3d4  mov      x27, x0
0x0002b3d8  mov      x0, x26
0x0002b3dc  bl       #0x55d78   ; CALL _objc_release
0x0002b3e0  cbz      w27, #0x2b3f8
0x0002b3e4  mov      x0, x25
0x0002b3e8  bl       #0x55d84   ; CALL _objc_retain
0x0002b3ec  mov      x0, x20
0x0002b3f0  bl       #0x55d78   ; CALL _objc_release
0x0002b3f4  mov      x20, x25
0x0002b3f8  add      x19, x19, #1
0x0002b3fc  cmp      x24, x19
0x0002b400  b.ne     #0x2b398
0x0002b404  add      x2, sp, #0x10
0x0002b408  add      x3, sp, #0x80
0x0002b40c  mov      x0, x22
0x0002b410  mov      w4, #0x10
0x0002b414  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0002b418  mov      x24, x0
0x0002b41c  cbnz     x0, #0x2b394
0x0002b420  b        #0x2b428
0x0002b424  mov      x20, #0
0x0002b428  mov      x0, x22
0x0002b42c  bl       #0x55d78   ; CALL _objc_release
0x0002b430  mov      x0, x20
0x0002b434  bl       #0x59de0   ; CALL objc_msgSend$removeFromSuperlayer
0x0002b438  mov      x19, x21
0x0002b43c  ldr      w8, [sp, #0xc]
0x0002b440  cbz      w8, #0x2b6c0
0x0002b444  adrp     x8, #0x8e000
0x0002b448  ldr      x0, [x8, #0xab0]   ; @CLASS CAGradientLayer
0x0002b44c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002b450  mov      x29, x29
0x0002b454  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b458  mov      x21, x0
0x0002b45c  adrp     x2, #0x7b000
0x0002b460  add      x2, x2, #0x68   ; STR "omcRing"
0x0002b464  bl       #0x5b700   ; CALL objc_msgSend$setName:
0x0002b468  adrp     x8, #0x74000
0x0002b46c  ldr      x8, [x8, #0x668]   ; @GOT _kCAGradientLayerConic
0x0002b470  ldr      x2, [x8]   ; @GOT ___objc_personality_v0
0x0002b474  mov      x0, x21
0x0002b478  bl       #0x5c6e0   ; CALL objc_msgSend$setType:
0x0002b47c  mov      x0, x19
0x0002b480  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0002b484  fmov     d4, #-2.50000000
0x0002b488  fmov     d5, #-2.50000000
0x0002b48c  bl       #0x55a90   ; CALL _CGRectInset
0x0002b490  mov      x0, x21
0x0002b494  bl       #0x5aec0   ; CALL objc_msgSend$setFrame:
0x0002b498  fmov     d0, #0.50000000
0x0002b49c  fmov     d1, #0.50000000
0x0002b4a0  mov      x0, x21
0x0002b4a4  bl       #0x5c2c0   ; CALL objc_msgSend$setStartPoint:
0x0002b4a8  fmov     d0, xzr
0x0002b4ac  fmov     d1, #1.00000000
0x0002b4b0  mov      x0, x21
0x0002b4b4  bl       #0x5adc0   ; CALL objc_msgSend$setEndPoint:
0x0002b4b8  adrp     x25, #0x7a000
0x0002b4bc  add      x25, x25, #0xc68   ; STR "#A78BFA"
0x0002b4c0  mov      x0, x25
0x0002b4c4  bl       #0x18080   ; CALL _OMCColorFromHex
0x0002b4c8  mov      x29, x29
0x0002b4cc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b4d0  mov      x22, x0
0x0002b4d4  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002b4d8  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002b4dc  str      x0, [sp, #0x58]
0x0002b4e0  adrp     x0, #0x7a000
0x0002b4e4  add      x0, x0, #0xcc8   ; STR "#60C5FA"
0x0002b4e8  bl       #0x18080   ; CALL _OMCColorFromHex
0x0002b4ec  mov      x29, x29
0x0002b4f0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b4f4  mov      x23, x0
0x0002b4f8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002b4fc  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002b500  str      x0, [sp, #0x60]
0x0002b504  adrp     x0, #0x7a000
0x0002b508  add      x0, x0, #0xce8   ; STR "#5EDDB6"
0x0002b50c  bl       #0x18080   ; CALL _OMCColorFromHex
0x0002b510  mov      x29, x29
0x0002b514  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b518  mov      x24, x0
0x0002b51c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002b520  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002b524  str      x0, [sp, #0x68]
0x0002b528  adrp     x0, #0x7a000
0x0002b52c  add      x0, x0, #0xd08   ; STR "#F59AC0"
0x0002b530  bl       #0x18080   ; CALL _OMCColorFromHex
0x0002b534  mov      x29, x29
0x0002b538  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b53c  mov      x26, x0
0x0002b540  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002b544  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002b548  str      x0, [sp, #0x70]
0x0002b54c  mov      x0, x25
0x0002b550  bl       #0x18080   ; CALL _OMCColorFromHex
0x0002b554  mov      x29, x29
0x0002b558  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b55c  mov      x25, x0
0x0002b560  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002b564  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002b568  str      x0, [sp, #0x78]
0x0002b56c  adrp     x8, #0x8e000
0x0002b570  ldr      x0, [x8, #0x960]   ; @CLASS NSArray
0x0002b574  add      x2, sp, #0x58
0x0002b578  mov      w3, #5
0x0002b57c  bl       #0x56640   ; CALL objc_msgSend$arrayWithObjects:count:
0x0002b580  mov      x29, x29
0x0002b584  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b588  mov      x27, x0
0x0002b58c  mov      x0, x21
0x0002b590  mov      x2, x27
0x0002b594  bl       #0x5a900   ; CALL objc_msgSend$setColors:
0x0002b598  mov      x0, x27
0x0002b59c  bl       #0x55d78   ; CALL _objc_release
0x0002b5a0  mov      x0, x25
0x0002b5a4  bl       #0x55d78   ; CALL _objc_release
0x0002b5a8  mov      x0, x26
0x0002b5ac  bl       #0x55d78   ; CALL _objc_release
0x0002b5b0  mov      x0, x24
0x0002b5b4  bl       #0x55d78   ; CALL _objc_release
0x0002b5b8  mov      x0, x23
0x0002b5bc  bl       #0x55d78   ; CALL _objc_release
0x0002b5c0  mov      x0, x22
0x0002b5c4  bl       #0x55d78   ; CALL _objc_release
0x0002b5c8  adrp     x8, #0x8e000
0x0002b5cc  ldr      x0, [x8, #0xb48]   ; @CLASS CAShapeLayer
0x0002b5d0  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002b5d4  mov      x29, x29
0x0002b5d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b5dc  mov      x22, x0
0x0002b5e0  adrp     x8, #0x8e000
0x0002b5e4  ldr      x23, [x8, #0xac0]   ; @CLASS UIBezierPath
0x0002b5e8  mov      x0, x21
0x0002b5ec  bl       #0x56a40   ; CALL objc_msgSend$bounds
0x0002b5f0  fmov     d4, #1.25000000
0x0002b5f4  fmov     d5, #1.25000000
0x0002b5f8  bl       #0x55a90   ; CALL _CGRectInset
0x0002b5fc  adrp     x8, #0x65000
0x0002b600  ldr      d4, [x8, #0x9f0]
0x0002b604  mov      x0, x23
0x0002b608  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x0002b60c  mov      x29, x29
0x0002b610  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b614  mov      x23, x0
0x0002b618  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002b61c  bl       #0x55ee0   ; CALL objc_msgSend$CGPath
0x0002b620  mov      x2, x0
0x0002b624  mov      x0, x22
0x0002b628  bl       #0x5bb60   ; CALL objc_msgSend$setPath:
0x0002b62c  mov      x0, x23
0x0002b630  bl       #0x55d78   ; CALL _objc_release
0x0002b634  mov      x0, x22
0x0002b638  mov      x2, #0
0x0002b63c  bl       #0x5ae40   ; CALL objc_msgSend$setFillColor:
0x0002b640  adrp     x8, #0x8e000
0x0002b644  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0002b648  bl       #0x56940   ; CALL objc_msgSend$blackColor
0x0002b64c  mov      x29, x29
0x0002b650  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b654  mov      x23, x0
0x0002b658  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x0002b65c  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x0002b660  mov      x2, x0
0x0002b664  mov      x0, x22
0x0002b668  bl       #0x5c380   ; CALL objc_msgSend$setStrokeColor:
0x0002b66c  mov      x0, x23
0x0002b670  bl       #0x55d78   ; CALL _objc_release
0x0002b674  fmov     d0, #2.50000000
0x0002b678  mov      x0, x22
0x0002b67c  bl       #0x5b3a0   ; CALL objc_msgSend$setLineWidth:
0x0002b680  mov      x0, x21
0x0002b684  mov      x2, x22
0x0002b688  bl       #0x5b4c0   ; CALL objc_msgSend$setMask:
0x0002b68c  mov      x0, x19
0x0002b690  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002b694  mov      x29, x29
0x0002b698  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b69c  mov      x23, x0
0x0002b6a0  mov      x2, x21
0x0002b6a4  bl       #0x561c0   ; CALL objc_msgSend$addSublayer:
0x0002b6a8  mov      x0, x23
0x0002b6ac  bl       #0x55d78   ; CALL _objc_release
0x0002b6b0  mov      x0, x22
0x0002b6b4  bl       #0x55d78   ; CALL _objc_release
0x0002b6b8  mov      x0, x21
0x0002b6bc  bl       #0x55d78   ; CALL _objc_release
0x0002b6c0  mov      x0, x20
0x0002b6c4  bl       #0x55d78   ; CALL _objc_release
0x0002b6c8  mov      x0, x19
0x0002b6cc  bl       #0x55d78   ; CALL _objc_release
0x0002b6d0  ldur     x8, [x29, #-0x60]
0x0002b6d4  adrp     x9, #0x74000
0x0002b6d8  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0002b6dc  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0002b6e0  cmp      x9, x8
0x0002b6e4  b.ne     #0x2b708
0x0002b6e8  ldp      x29, x30, [sp, #0x160]
0x0002b6ec  ldp      x20, x19, [sp, #0x150]
0x0002b6f0  ldp      x22, x21, [sp, #0x140]
0x0002b6f4  ldp      x24, x23, [sp, #0x130]
0x0002b6f8  ldp      x26, x25, [sp, #0x120]
0x0002b6fc  ldp      x28, x27, [sp, #0x110]
0x0002b700  add      sp, sp, #0x170
0x0002b704  ret      
0x0002b708  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCSpeedBubbleController styleTapped:]  va=0x2b70c size=220 types=v24@0:8@16
0x0002b70c  stp      x22, x21, [sp, #-0x30]!
0x0002b710  stp      x20, x19, [sp, #0x10]
0x0002b714  stp      x29, x30, [sp, #0x20]
0x0002b718  add      x29, sp, #0x20
0x0002b71c  mov      x19, x0
0x0002b720  adrp     x1, #0x90000
0x0002b724  add      x1, x1, #0x38
0x0002b728  mov      x0, x2
0x0002b72c  bl       #0x55d00   ; CALL _objc_getAssociatedObject
0x0002b730  mov      x29, x29
0x0002b734  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b738  mov      x20, x0
0x0002b73c  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0002b740  mov      x21, x0
0x0002b744  mov      x0, x20
0x0002b748  bl       #0x55d78   ; CALL _objc_release
0x0002b74c  adrp     x8, #0x8e000
0x0002b750  ldr      x0, [x8, #0x938]   ; @CLASS UISelectionFeedbackGenerator
0x0002b754  bl       #0x55d60   ; CALL _objc_opt_new
0x0002b758  mov      x20, x0
0x0002b75c  bl       #0x5a200   ; CALL objc_msgSend$selectionChanged
0x0002b760  mov      x0, x20
0x0002b764  bl       #0x55d78   ; CALL _objc_release
0x0002b768  mov      x0, x19
0x0002b76c  bl       #0x5d660   ; CALL objc_msgSend$styleStrip
0x0002b770  mov      x29, x29
0x0002b774  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b778  mov      x20, x0
0x0002b77c  bl       #0x57240   ; CALL objc_msgSend$contentOffset
0x0002b780  mov      x0, x19
0x0002b784  bl       #0x5c340   ; CALL objc_msgSend$setStripOffset:
0x0002b788  mov      x0, x20
0x0002b78c  bl       #0x55d78   ; CALL _objc_release
0x0002b790  adrp     x8, #0x8e000
0x0002b794  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x0002b798  mov      x2, x21
0x0002b79c  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x0002b7a0  mov      x29, x29
0x0002b7a4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b7a8  mov      x20, x0
0x0002b7ac  adrp     x3, #0x7a000
0x0002b7b0  add      x3, x3, #0x1c8   ; STR "speedBubbleLook"
0x0002b7b4  mov      x0, x19
0x0002b7b8  mov      x2, x20
0x0002b7bc  bl       #0x5d3c0   ; CALL objc_msgSend$storeValue:forKey:
0x0002b7c0  mov      x0, x20
0x0002b7c4  bl       #0x55d78   ; CALL _objc_release
0x0002b7c8  mov      x0, x19
0x0002b7cc  mov      w2, #2
0x0002b7d0  bl       #0x59ce0   ; CALL objc_msgSend$reloadSection:
0x0002b7d4  mov      x0, x19
0x0002b7d8  ldp      x29, x30, [sp, #0x20]
0x0002b7dc  ldp      x20, x19, [sp, #0x10]
0x0002b7e0  ldp      x22, x21, [sp], #0x30
0x0002b7e4  b        #0x5da20   ; CALL objc_msgSend$tickLive

=== -[OMCSpeedBubbleController layoutSourcesIn:width:]  va=0x2b7e8 size=1364 types=v32@0:8@16d24
0x0002b7e8  sub      sp, sp, #0x1f0
0x0002b7ec  stp      d15, d14, [sp, #0x150]
0x0002b7f0  stp      d13, d12, [sp, #0x160]
0x0002b7f4  stp      d11, d10, [sp, #0x170]
0x0002b7f8  stp      d9, d8, [sp, #0x180]
0x0002b7fc  stp      x28, x27, [sp, #0x190]
0x0002b800  stp      x26, x25, [sp, #0x1a0]
0x0002b804  stp      x24, x23, [sp, #0x1b0]
0x0002b808  stp      x22, x21, [sp, #0x1c0]
0x0002b80c  stp      x20, x19, [sp, #0x1d0]
0x0002b810  stp      x29, x30, [sp, #0x1e0]
0x0002b814  add      x29, sp, #0x1e0
0x0002b818  mov      v8.16b, v0.16b
0x0002b81c  mov      x19, x2
0x0002b820  mov      x20, x0
0x0002b824  adrp     x8, #0x74000
0x0002b828  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0002b82c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002b830  stur     x8, [x29, #-0xa0]
0x0002b834  mov      x0, x2
0x0002b838  bl       #0x55d84   ; CALL _objc_retain
0x0002b83c  movi     v0.16b, #0
0x0002b840  stp      q0, q0, [sp, #0x40]
0x0002b844  stp      q0, q0, [sp, #0x60]
0x0002b848  str      x19, [sp, #0x38]
0x0002b84c  mov      x0, x19
0x0002b850  bl       #0x5d700   ; CALL objc_msgSend$subviews
0x0002b854  mov      x29, x29
0x0002b858  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002b85c  mov      x19, x0
0x0002b860  bl       #0x572e0   ; CALL objc_msgSend$copy
0x0002b864  mov      x21, x0
0x0002b868  mov      x0, x19
0x0002b86c  bl       #0x55d78   ; CALL _objc_release
0x0002b870  add      x2, sp, #0x40
0x0002b874  add      x3, sp, #0xc0
0x0002b878  mov      x0, x21
0x0002b87c  mov      w4, #0x10
0x0002b880  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0002b884  cbz      x0, #0x2b8e4
0x0002b888  mov      x22, x0
0x0002b88c  ldr      x8, [sp, #0x50]
0x0002b890  ldr      x19, [x8]   ; @GOT ___objc_personality_v0
0x0002b894  mov      x23, #0
0x0002b898  ldr      x8, [sp, #0x50]
0x0002b89c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002b8a0  cmp      x8, x19
0x0002b8a4  b.eq     #0x2b8b0
0x0002b8a8  mov      x0, x21
0x0002b8ac  bl       #0x55cf4   ; CALL _objc_enumerationMutation
0x0002b8b0  ldr      x8, [sp, #0x48]
0x0002b8b4  ldr      x0, [x8, x23, lsl #3]   ; @GOT ___objc_personality_v0
0x0002b8b8  bl       #0x59e00   ; CALL objc_msgSend$removeFromSuperview
0x0002b8bc  add      x23, x23, #1
0x0002b8c0  cmp      x22, x23
0x0002b8c4  b.ne     #0x2b898
0x0002b8c8  add      x2, sp, #0x40
0x0002b8cc  add      x3, sp, #0xc0
0x0002b8d0  mov      x0, x21
0x0002b8d4  mov      w4, #0x10
0x0002b8d8  bl       #0x573e0   ; CALL objc_msgSend$countByEnumeratingWithState:objects:count:
0x0002b8dc  mov      x22, x0
0x0002b8e0  cbnz     x0, #0x2b894
0x0002b8e4  mov      x0, x21
0x0002b8e8  bl       #0x55d78   ; CALL _objc_release
0x0002b8ec  adrp     x0, #0x7f000
0x0002b8f0  add      x0, x0, #0xb28
0x0002b8f4  bl       #0x573c0   ; CALL objc_msgSend$count
0x0002b8f8  mov      x21, x0
0x0002b8fc  mov      x0, x20
0x0002b900  bl       #0x5cd40   ; CALL objc_msgSend$source
0x0002b904  subs     x8, x21, #1
0x0002b908  b.lt     #0x2bce8
0x0002b90c  mov      x22, x0
0x0002b910  mov      x23, #0
0x0002b914  fmov     d0, #-24.00000000
0x0002b918  fadd     d0, d8, d0
0x0002b91c  scvtf    d1, x8
0x0002b920  fmov     d2, #-8.00000000
0x0002b924  scvtf    d3, x21
0x0002b928  fmadd    d0, d1, d2, d0
0x0002b92c  fdiv     d0, d0, d3
0x0002b930  frintm   d8, d0
0x0002b934  fmov     d0, #8.00000000
0x0002b938  adrp     x8, #0x74000
0x0002b93c  ldr      x8, [x8, #0x648]   ; @GOT _kCACornerCurveContinuous
0x0002b940  fadd     d0, d8, d0
0x0002b944  str      d0, [sp, #0x30]
0x0002b948  ldr      x9, [x8]   ; @GOT ___objc_personality_v0
0x0002b94c  adrp     x8, #0x8b000
0x0002b950  ldr      x8, [x8, #0xed8]   ; @SEL "sourceTapped:"
0x0002b954  stp      x8, x9, [sp, #0x20]
0x0002b958  fmov     d0, #-30.00000000
0x0002b95c  fadd     d0, d8, d0
0x0002b960  fmov     d1, #0.50000000
0x0002b964  fmul     d0, d0, d1
0x0002b968  str      d0, [sp, #0x18]
0x0002b96c  mov      x8, #0x4046000000000000
0x0002b970  str      x8, [sp, #0x10]
0x0002b974  adrp     x8, #0x74000
0x0002b978  ldr      x8, [x8, #0x260]   ; @GOT _UIFontWeightSemibold
0x0002b97c  fadd     d11, d8, d2
0x0002b980  ldr      d12, [x8]   ; @GOT ___objc_personality_v0
0x0002b984  adrp     x8, #0x65000
0x0002b988  ldr      d9, [x8, #0x9f8]
0x0002b98c  adrp     x8, #0x65000
0x0002b990  ldr      d13, [x8, #0xa00]
0x0002b994  adrp     x25, #0x8e000
0x0002b998  adrp     x8, #0x65000
0x0002b99c  ldr      d14, [x8, #0x748]
0x0002b9a0  adrp     x8, #0x65000
0x0002b9a4  ldr      d10, [x8, #0x600]
0x0002b9a8  adrp     x8, #0x65000
0x0002b9ac  ldr      q0, [x8, #0xa50]
0x0002b9b0  str      q0, [sp]
0x0002b9b4  adrp     x8, #0x65000
0x0002b9b8  ldr      d15, [x8, #0x700]
0x0002b9bc  adrp     x8, #0x8e000
0x0002b9c0  ldr      x0, [x8, #0xbb0]   ; @CLASS UIControl
0x0002b9c4  bl       #0x55c7c   ; CALL _objc_alloc
0x0002b9c8  ucvtf    d0, x23
0x0002b9cc  ldr      d1, [sp, #0x30]
0x0002b9d0  fmov     d2, #12.00000000
0x0002b9d4  fmadd    d0, d0, d1, d2
0x0002b9d8  udiv     x8, x23, x21
0x0002b9dc  ucvtf    d1, x8
0x0002b9e0  fmadd    d1, d1, d9, d2
0x0002b9e4  mov      v2.16b, v8.16b
0x0002b9e8  mov      v3.16b, v13.16b
0x0002b9ec  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0002b9f0  mov      x27, x0
0x0002b9f4  ldr      x0, [x25, #0x910]   ; @CLASS UIColor
0x0002b9f8  fmov     d0, #0.50000000
0x0002b9fc  mov      v1.16b, v14.16b
0x0002ba00  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x0002ba04  mov      x29, x29
0x0002ba08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ba0c  mov      x19, x0
0x0002ba10  mov      x0, x27
0x0002ba14  mov      x2, x19
0x0002ba18  bl       #0x5a560   ; CALL objc_msgSend$setBackgroundColor:
0x0002ba1c  mov      x0, x19
0x0002ba20  bl       #0x55d78   ; CALL _objc_release
0x0002ba24  mov      x0, x27
0x0002ba28  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002ba2c  mov      x29, x29
0x0002ba30  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ba34  mov      x19, x0
0x0002ba38  fmov     d0, #14.00000000
0x0002ba3c  bl       #0x5ab60   ; CALL objc_msgSend$setCornerRadius:
0x0002ba40  mov      x0, x19
0x0002ba44  bl       #0x55d78   ; CALL _objc_release
0x0002ba48  mov      x0, x27
0x0002ba4c  bl       #0x58aa0   ; CALL objc_msgSend$layer
0x0002ba50  mov      x29, x29
0x0002ba54  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ba58  mov      x19, x0
0x0002ba5c  ldr      x2, [sp, #0x28]
0x0002ba60  bl       #0x5ab40   ; CALL objc_msgSend$setCornerCurve:
0x0002ba64  mov      x0, x19
0x0002ba68  bl       #0x55d78   ; CALL _objc_release
0x0002ba6c  adrp     x8, #0x8e000
0x0002ba70  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x0002ba74  mov      x2, x23
0x0002ba78  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x0002ba7c  mov      x29, x29
0x0002ba80  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002ba84  mov      x19, x0
0x0002ba88  mov      x0, x27
0x0002ba8c  adrp     x1, #0x90000
0x0002ba90  add      x1, x1, #0x38
0x0002ba94  mov      x2, x19
0x0002ba98  mov      w3, #1
0x0002ba9c  bl       #0x55db4   ; CALL _objc_setAssociatedObject
0x0002baa0  mov      x0, x19
0x0002baa4  bl       #0x55d78   ; CALL _objc_release
0x0002baa8  mov      x0, x27
0x0002baac  mov      x2, x20
0x0002bab0  ldr      x3, [sp, #0x20]
0x0002bab4  mov      w4, #0x40
0x0002bab8  bl       #0x56200   ; CALL objc_msgSend$addTarget:action:forControlEvents:
0x0002babc  adrp     x8, #0x8e000
0x0002bac0  ldr      x0, [x8, #0xa80]   ; @CLASS UIImageView
0x0002bac4  bl       #0x55c7c   ; CALL _objc_alloc
0x0002bac8  fmov     d1, #10.00000000
0x0002bacc  fmov     d2, #30.00000000
0x0002bad0  fmov     d3, #30.00000000
0x0002bad4  ldr      d0, [sp, #0x18]
0x0002bad8  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0002badc  mov      x28, x0
0x0002bae0  mov      x0, x23
0x0002bae4  bl       #0x2642c
0x0002bae8  mov      x29, x29
0x0002baec  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002baf0  mov      x26, x0
0x0002baf4  bl       #0x55d84   ; CALL _objc_retain
0x0002baf8  adrp     x8, #0x8e000
0x0002bafc  ldr      x0, [x8, #0xb00]   ; @CLASS UIGraphicsImageRenderer
0x0002bb00  bl       #0x55c7c   ; CALL _objc_alloc
0x0002bb04  fmov     d0, #30.00000000
0x0002bb08  fmov     d1, #30.00000000
0x0002bb0c  bl       #0x58540   ; CALL objc_msgSend$initWithSize:
0x0002bb10  mov      x19, x0
0x0002bb14  adrp     x8, #0x74000
0x0002bb18  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x0002bb1c  str      x8, [sp, #0x88]
0x0002bb20  str      d10, [sp, #0x90]
0x0002bb24  adrp     x8, #0x2c000
0x0002bb28  add      x9, x8, #0x698
0x0002bb2c  adrp     x8, #0x74000
0x0002bb30  add      x8, x8, #0xa40
0x0002bb34  stp      x9, x8, [sp, #0x98]
0x0002bb38  ldr      q0, [sp]
0x0002bb3c  stur     q0, [sp, #0xb0]
0x0002bb40  str      x26, [sp, #0xa8]
0x0002bb44  mov      x0, x26
0x0002bb48  bl       #0x55d84   ; CALL _objc_retain
0x0002bb4c  add      x2, sp, #0x88
0x0002bb50  mov      x0, x19
0x0002bb54  bl       #0x58140   ; CALL objc_msgSend$imageWithActions:
0x0002bb58  mov      x29, x29
0x0002bb5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002bb60  mov      x24, x0
0x0002bb64  ldr      x0, [sp, #0xa8]
0x0002bb68  bl       #0x55d78   ; CALL _objc_release
0x0002bb6c  mov      x0, x26
0x0002bb70  bl       #0x55d78   ; CALL _objc_release
0x0002bb74  mov      x0, x19
0x0002bb78  bl       #0x55d78   ; CALL _objc_release
0x0002bb7c  mov      x0, x28
0x0002bb80  mov      x2, x24
0x0002bb84  bl       #0x5b080   ; CALL objc_msgSend$setImage:
0x0002bb88  mov      x0, x24
0x0002bb8c  bl       #0x55d78   ; CALL _objc_release
0x0002bb90  mov      x0, x26
0x0002bb94  bl       #0x55d78   ; CALL _objc_release
0x0002bb98  mov      x0, x28
0x0002bb9c  mov      w2, #0
0x0002bba0  bl       #0x5c740   ; CALL objc_msgSend$setUserInteractionEnabled:
0x0002bba4  mov      x0, x27
0x0002bba8  mov      x2, x28
0x0002bbac  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002bbb0  adrp     x8, #0x8e000
0x0002bbb4  ldr      x0, [x8, #0x940]   ; @CLASS UILabel
0x0002bbb8  bl       #0x55c7c   ; CALL _objc_alloc
0x0002bbbc  fmov     d0, #4.00000000
0x0002bbc0  fmov     d3, #18.00000000
0x0002bbc4  ldr      d1, [sp, #0x10]
0x0002bbc8  mov      v2.16b, v11.16b
0x0002bbcc  bl       #0x58460   ; CALL objc_msgSend$initWithFrame:
0x0002bbd0  mov      x26, x0
0x0002bbd4  mov      x0, x20
0x0002bbd8  mov      x2, x23
0x0002bbdc  bl       #0x5cd80   ; CALL objc_msgSend$sourceName:
0x0002bbe0  mov      x29, x29
0x0002bbe4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002bbe8  mov      x19, x0
0x0002bbec  mov      x0, x26
0x0002bbf0  mov      x2, x19
0x0002bbf4  bl       #0x5c4c0   ; CALL objc_msgSend$setText:
0x0002bbf8  mov      x0, x19
0x0002bbfc  bl       #0x55d78   ; CALL _objc_release
0x0002bc00  adrp     x8, #0x8e000
0x0002bc04  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x0002bc08  fmov     d0, #11.50000000
0x0002bc0c  mov      v1.16b, v12.16b
0x0002bc10  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x0002bc14  mov      x29, x29
0x0002bc18  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002bc1c  mov      x19, x0
0x0002bc20  mov      x0, x26
0x0002bc24  mov      x2, x19
0x0002bc28  bl       #0x5aea0   ; CALL objc_msgSend$setFont:
0x0002bc2c  mov      x0, x19
0x0002bc30  bl       #0x55d78   ; CALL _objc_release
0x0002bc34  mov      x0, x26
0x0002bc38  mov      w2, #1
0x0002bc3c  bl       #0x5c4e0   ; CALL objc_msgSend$setTextAlignment:
0x0002bc40  mov      x0, x26
0x0002bc44  mov      w2, #1
0x0002bc48  bl       #0x5a380   ; CALL objc_msgSend$setAdjustsFontSizeToFitWidth:
0x0002bc4c  mov      x0, x26
0x0002bc50  mov      v0.16b, v15.16b
0x0002bc54  bl       #0x5b660   ; CALL objc_msgSend$setMinimumScaleFactor:
0x0002bc58  ldr      x0, [x25, #0x910]   ; @CLASS UIColor
0x0002bc5c  cmp      x22, x23
0x0002bc60  b.ne     #0x2bc74
0x0002bc64  bl       #0x589e0   ; CALL objc_msgSend$labelColor
0x0002bc68  mov      x29, x29
0x0002bc6c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002bc70  b        #0x2bc80
0x0002bc74  bl       #0x5a160   ; CALL objc_msgSend$secondaryLabelColor
0x0002bc78  mov      x29, x29
0x0002bc7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002bc80  mov      x19, x0
0x0002bc84  cmp      x22, x23
0x0002bc88  cset     w24, eq
0x0002bc8c  mov      x0, x26
0x0002bc90  mov      x2, x19
0x0002bc94  bl       #0x5c500   ; CALL objc_msgSend$setTextColor:
0x0002bc98  mov      x0, x19
0x0002bc9c  bl       #0x55d78   ; CALL _objc_release
0x0002bca0  mov      x0, x27
0x0002bca4  mov      x2, x26
0x0002bca8  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002bcac  ldr      x0, [sp, #0x38]
0x0002bcb0  mov      x2, x27
0x0002bcb4  bl       #0x561e0   ; CALL objc_msgSend$addSubview:
0x0002bcb8  mov      x0, x27
0x0002bcbc  mov      x1, x24
0x0002bcc0  bl       #0x2b2ec
0x0002bcc4  mov      x0, x26
0x0002bcc8  bl       #0x55d78   ; CALL _objc_release
0x0002bccc  mov      x0, x28
0x0002bcd0  bl       #0x55d78   ; CALL _objc_release
0x0002bcd4  mov      x0, x27
0x0002bcd8  bl       #0x55d78   ; CALL _objc_release
0x0002bcdc  add      x23, x23, #1
0x0002bce0  cmp      x21, x23
0x0002bce4  b.ne     #0x2b9bc
0x0002bce8  ldr      x0, [sp, #0x38]
0x0002bcec  bl       #0x55d78   ; CALL _objc_release
0x0002bcf0  ldur     x8, [x29, #-0xa0]
0x0002bcf4  adrp     x9, #0x74000
0x0002bcf8  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0002bcfc  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0002bd00  cmp      x9, x8
0x0002bd04  b.ne     #0x2bd38
0x0002bd08  ldp      x29, x30, [sp, #0x1e0]
0x0002bd0c  ldp      x20, x19, [sp, #0x1d0]
0x0002bd10  ldp      x22, x21, [sp, #0x1c0]
0x0002bd14  ldp      x24, x23, [sp, #0x1b0]
0x0002bd18  ldp      x26, x25, [sp, #0x1a0]
0x0002bd1c  ldp      x28, x27, [sp, #0x190]
0x0002bd20  ldp      d9, d8, [sp, #0x180]
0x0002bd24  ldp      d11, d10, [sp, #0x170]
0x0002bd28  ldp      d13, d12, [sp, #0x160]
0x0002bd2c  ldp      d15, d14, [sp, #0x150]
0x0002bd30  add      sp, sp, #0x1f0
0x0002bd34  ret      
0x0002bd38  bl       #0x55b98   ; CALL ___stack_chk_fail

=== -[OMCSpeedBubbleController sourceTapped:]  va=0x2bd3c size=296 types=v24@0:8@16
0x0002bd3c  stp      x22, x21, [sp, #-0x30]!
0x0002bd40  stp      x20, x19, [sp, #0x10]
0x0002bd44  stp      x29, x30, [sp, #0x20]
0x0002bd48  add      x29, sp, #0x20
0x0002bd4c  mov      x19, x0
0x0002bd50  adrp     x1, #0x90000
0x0002bd54  add      x1, x1, #0x38
0x0002bd58  mov      x0, x2
0x0002bd5c  bl       #0x55d00   ; CALL _objc_getAssociatedObject
0x0002bd60  mov      x29, x29
0x0002bd64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002bd68  mov      x20, x0
0x0002bd6c  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x0002bd70  mov      x21, x0
0x0002bd74  mov      x0, x20
0x0002bd78  bl       #0x55d78   ; CALL _objc_release
0x0002bd7c  adrp     x8, #0x8e000
0x0002bd80  ldr      x0, [x8, #0x938]   ; @CLASS UISelectionFeedbackGenerator
0x0002bd84  bl       #0x55d60   ; CALL _objc_opt_new
0x0002bd88  mov      x20, x0
0x0002bd8c  bl       #0x5a200   ; CALL objc_msgSend$selectionChanged
0x0002bd90  mov      x0, x20
0x0002bd94  bl       #0x55d78   ; CALL _objc_release
0x0002bd98  adrp     x8, #0x8e000
0x0002bd9c  ldr      x0, [x8, #0x928]   ; @CLASS NSNumber
0x0002bda0  mov      x2, x21
0x0002bda4  bl       #0x59320   ; CALL objc_msgSend$numberWithInteger:
0x0002bda8  mov      x29, x29
0x0002bdac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002bdb0  mov      x20, x0
0x0002bdb4  adrp     x3, #0x76000
0x0002bdb8  add      x3, x3, #0xae8   ; STR "speedBubbleSource"
0x0002bdbc  mov      x0, x19
0x0002bdc0  mov      x2, x20
0x0002bdc4  bl       #0x5d3c0   ; CALL objc_msgSend$storeValue:forKey:
0x0002bdc8  mov      x0, x20
0x0002bdcc  bl       #0x55d78   ; CALL _objc_release
0x0002bdd0  mov      x0, x19
0x0002bdd4  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x0002bdd8  mov      x29, x29
0x0002bddc  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002bde0  mov      x20, x0
0x0002bde4  bl       #0x567c0   ; CALL objc_msgSend$beginUpdates
0x0002bde8  mov      x0, x20
0x0002bdec  bl       #0x55d78   ; CALL _objc_release
0x0002bdf0  mov      x0, x19
0x0002bdf4  mov      w2, #4
0x0002bdf8  bl       #0x59ce0   ; CALL objc_msgSend$reloadSection:
0x0002bdfc  mov      x0, x19
0x0002be00  bl       #0x5d8c0   ; CALL objc_msgSend$table
0x0002be04  mov      x29, x29
0x0002be08  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002be0c  mov      x20, x0
0x0002be10  bl       #0x579c0   ; CALL objc_msgSend$endUpdates
0x0002be14  mov      x0, x20
0x0002be18  bl       #0x55d78   ; CALL _objc_release
0x0002be1c  mov      x0, x19
0x0002be20  bl       #0x5d660   ; CALL objc_msgSend$styleStrip
0x0002be24  mov      x29, x29
0x0002be28  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002be2c  mov      x20, x0
0x0002be30  bl       #0x57240   ; CALL objc_msgSend$contentOffset
0x0002be34  mov      x0, x19
0x0002be38  bl       #0x5c340   ; CALL objc_msgSend$setStripOffset:
0x0002be3c  mov      x0, x20
0x0002be40  bl       #0x55d78   ; CALL _objc_release
0x0002be44  mov      x0, x19
0x0002be48  mov      w2, #2
0x0002be4c  bl       #0x59ce0   ; CALL objc_msgSend$reloadSection:
0x0002be50  mov      x0, x19
0x0002be54  ldp      x29, x30, [sp, #0x20]
0x0002be58  ldp      x20, x19, [sp, #0x10]
0x0002be5c  ldp      x22, x21, [sp], #0x30
0x0002be60  b        #0x5da20   ; CALL objc_msgSend$tickLive

=== -[OMCSpeedBubbleController tryOnCar]  va=0x2be64 size=116 types=v16@0:8
0x0002be64  stp      x20, x19, [sp, #-0x20]!
0x0002be68  stp      x29, x30, [sp, #0x10]
0x0002be6c  add      x29, sp, #0x10
0x0002be70  mov      x19, x0
0x0002be74  adrp     x0, #0x63000
0x0002be78  add      x0, x0, #0xaa0   ; CSTR "com.anlai.omnicar/speedbubble.demo"
0x0002be7c  bl       #0x55c70   ; CALL _notify_post
0x0002be80  adrp     x8, #0x8e000
0x0002be84  ldr      x0, [x8, #0xbb8]   ; @CLASS UIImpactFeedbackGenerator
0x0002be88  bl       #0x55c7c   ; CALL _objc_alloc
0x0002be8c  mov      x2, #0
0x0002be90  bl       #0x585a0   ; CALL objc_msgSend$initWithStyle:
0x0002be94  mov      x20, x0
0x0002be98  bl       #0x58220   ; CALL objc_msgSend$impactOccurred
0x0002be9c  mov      x0, x20
0x0002bea0  bl       #0x55d78   ; CALL _objc_release
0x0002bea4  adrp     x0, #0x7a000
0x0002bea8  add      x0, x0, #0xd68   ; STR "SPEEDBUBBLE_TRY_SENT"
0x0002beac  bl       #0x17e20   ; CALL _L
0x0002beb0  mov      x29, x29
0x0002beb4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002beb8  mov      x20, x0
0x0002bebc  mov      x0, x19
0x0002bec0  mov      x2, x20
0x0002bec4  bl       #0x5dba0   ; CALL objc_msgSend$toast:
0x0002bec8  mov      x0, x20
0x0002becc  ldp      x29, x30, [sp, #0x10]
0x0002bed0  ldp      x20, x19, [sp], #0x20
0x0002bed4  b        #0x55d78   ; CALL _objc_release

=== -[OMCSpeedBubbleController resetLayout]  va=0x2bed8 size=276 types=v16@0:8
0x0002bed8  sub      sp, sp, #0x50
0x0002bedc  stp      x20, x19, [sp, #0x30]
0x0002bee0  stp      x29, x30, [sp, #0x40]
0x0002bee4  add      x29, sp, #0x40
0x0002bee8  mov      x19, x0
0x0002beec  adrp     x0, #0x63000
0x0002bef0  add      x0, x0, #0xad8   ; CSTR "com.anlai.omnicar/speedbubble.resetlayout"
0x0002bef4  bl       #0x55c70   ; CALL _notify_post
0x0002bef8  adrp     x8, #0x8e000
0x0002befc  ldr      x0, [x8, #0xbb8]   ; @CLASS UIImpactFeedbackGenerator
0x0002bf00  bl       #0x55c7c   ; CALL _objc_alloc
0x0002bf04  mov      x2, #0
0x0002bf08  bl       #0x585a0   ; CALL objc_msgSend$initWithStyle:
0x0002bf0c  mov      x20, x0
0x0002bf10  bl       #0x58220   ; CALL objc_msgSend$impactOccurred
0x0002bf14  mov      x0, x20
0x0002bf18  bl       #0x55d78   ; CALL _objc_release
0x0002bf1c  sub      x0, x29, #0x18
0x0002bf20  mov      x1, x19
0x0002bf24  bl       #0x55d18   ; CALL _objc_initWeak
0x0002bf28  mov      x0, #0
0x0002bf2c  mov      w1, #0x8400
0x0002bf30  movk     w1, #0x17d7, lsl #16
0x0002bf34  bl       #0x55c28   ; CALL _dispatch_time
0x0002bf38  mov      x19, x0
0x0002bf3c  adrp     x8, #0x74000
0x0002bf40  ldr      x8, [x8, #0x378]   ; @GOT __NSConcreteStackBlock
0x0002bf44  str      x8, [sp]
0x0002bf48  adrp     x8, #0x65000
0x0002bf4c  ldr      d0, [x8, #0x600]
0x0002bf50  adrp     x8, #0x2b000
0x0002bf54  add      x8, x8, #0xfac
0x0002bf58  str      d0, [sp, #8]
0x0002bf5c  adrp     x9, #0x74000
0x0002bf60  add      x9, x9, #0x820
0x0002bf64  stp      x8, x9, [sp, #0x10]
0x0002bf68  mov      x20, sp
0x0002bf6c  add      x0, x20, #0x20
0x0002bf70  sub      x1, x29, #0x18
0x0002bf74  bl       #0x55cd0   ; CALL _objc_copyWeak
0x0002bf78  adrp     x1, #0x74000
0x0002bf7c  ldr      x1, [x1, #0x3a0]   ; @GOT __dispatch_main_q
0x0002bf80  mov      x2, sp
0x0002bf84  mov      x0, x19
0x0002bf88  bl       #0x55bd4   ; CALL _dispatch_after
0x0002bf8c  add      x0, x20, #0x20
0x0002bf90  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x0002bf94  sub      x0, x29, #0x18
0x0002bf98  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x0002bf9c  ldp      x29, x30, [sp, #0x40]
0x0002bfa0  ldp      x20, x19, [sp, #0x30]
0x0002bfa4  add      sp, sp, #0x50
0x0002bfa8  ret      
0x0002bfac  stp      x20, x19, [sp, #-0x20]!
0x0002bfb0  stp      x29, x30, [sp, #0x10]
0x0002bfb4  add      x29, sp, #0x10
0x0002bfb8  mov      x19, x0
0x0002bfbc  adrp     x0, #0x75000
0x0002bfc0  add      x0, x0, #0x28   ; STR "com.anlai.omnicar"
0x0002bfc4  bl       #0x55850   ; CALL _CFPreferencesAppSynchronize
0x0002bfc8  add      x0, x19, #0x20
0x0002bfcc  bl       #0x55d24   ; CALL _objc_loadWeakRetained
0x0002bfd0  mov      x19, x0
0x0002bfd4  mov      w2, #3
0x0002bfd8  bl       #0x59ce0   ; CALL objc_msgSend$reloadSection:
0x0002bfdc  mov      x0, x19
0x0002bfe0  ldp      x29, x30, [sp, #0x10]
0x0002bfe4  ldp      x20, x19, [sp], #0x20
0x0002bfe8  b        #0x55d78   ; CALL _objc_release

=== -[OMCSpeedBubbleController live]  va=0x2bfec size=16 types=@16@0:8
0x0002bfec  adrp     x8, #0x8e000
0x0002bff0  ldrsw    x8, [x8, #0xea0]
0x0002bff4  ldr      x0, [x0, x8]
0x0002bff8  ret      

=== -[OMCSpeedBubbleController setLive:]  va=0x2bffc size=64 types=v24@0:8@16
0x0002bffc  stp      x22, x21, [sp, #-0x30]!
0x0002c000  stp      x20, x19, [sp, #0x10]
0x0002c004  stp      x29, x30, [sp, #0x20]
0x0002c008  add      x29, sp, #0x20
0x0002c00c  mov      x19, x2
0x0002c010  mov      x20, x0
0x0002c014  adrp     x8, #0x8e000
0x0002c018  ldrsw    x21, [x8, #0xea0]
0x0002c01c  mov      x0, x2
0x0002c020  bl       #0x55d84   ; CALL _objc_retain
0x0002c024  ldr      x0, [x20, x21]
0x0002c028  str      x19, [x20, x21]
0x0002c02c  ldp      x29, x30, [sp, #0x20]
0x0002c030  ldp      x20, x19, [sp, #0x10]
0x0002c034  ldp      x22, x21, [sp], #0x30
0x0002c038  b        #0x55d78   ; CALL _objc_release

=== -[OMCSpeedBubbleController liveMap]  va=0x2c03c size=16 types=@16@0:8
0x0002c03c  adrp     x8, #0x8e000
0x0002c040  ldrsw    x8, [x8, #0xea4]
0x0002c044  ldr      x0, [x0, x8]
0x0002c048  ret      

=== -[OMCSpeedBubbleController setLiveMap:]  va=0x2c04c size=64 types=v24@0:8@16
0x0002c04c  stp      x22, x21, [sp, #-0x30]!
0x0002c050  stp      x20, x19, [sp, #0x10]
0x0002c054  stp      x29, x30, [sp, #0x20]
0x0002c058  add      x29, sp, #0x20
0x0002c05c  mov      x19, x2
0x0002c060  mov      x20, x0
0x0002c064  adrp     x8, #0x8e000
0x0002c068  ldrsw    x21, [x8, #0xea4]
0x0002c06c  mov      x0, x2
0x0002c070  bl       #0x55d84   ; CALL _objc_retain
0x0002c074  ldr      x0, [x20, x21]
0x0002c078  str      x19, [x20, x21]
0x0002c07c  ldp      x29, x30, [sp, #0x20]
0x0002c080  ldp      x20, x19, [sp, #0x10]
0x0002c084  ldp      x22, x21, [sp], #0x30
0x0002c088  b        #0x55d78   ; CALL _objc_release

=== -[OMCSpeedBubbleController liveTimer]  va=0x2c08c size=16 types=@16@0:8
0x0002c08c  adrp     x8, #0x8e000
0x0002c090  ldrsw    x8, [x8, #0xea8]
0x0002c094  ldr      x0, [x0, x8]
0x0002c098  ret      

=== -[OMCSpeedBubbleController setLiveTimer:]  va=0x2c09c size=64 types=v24@0:8@16
0x0002c09c  stp      x22, x21, [sp, #-0x30]!
0x0002c0a0  stp      x20, x19, [sp, #0x10]
0x0002c0a4  stp      x29, x30, [sp, #0x20]
0x0002c0a8  add      x29, sp, #0x20
0x0002c0ac  mov      x19, x2
0x0002c0b0  mov      x20, x0
0x0002c0b4  adrp     x8, #0x8e000
0x0002c0b8  ldrsw    x21, [x8, #0xea8]
0x0002c0bc  mov      x0, x2
0x0002c0c0  bl       #0x55d84   ; CALL _objc_retain
0x0002c0c4  ldr      x0, [x20, x21]
0x0002c0c8  str      x19, [x20, x21]
0x0002c0cc  ldp      x29, x30, [sp, #0x20]
0x0002c0d0  ldp      x20, x19, [sp, #0x10]
0x0002c0d4  ldp      x22, x21, [sp], #0x30
0x0002c0d8  b        #0x55d78   ; CALL _objc_release

=== -[OMCSpeedBubbleController liveStart]  va=0x2c0dc size=16 types=d16@0:8
0x0002c0dc  adrp     x8, #0x8e000
0x0002c0e0  ldrsw    x8, [x8, #0xeac]
0x0002c0e4  ldr      d0, [x0, x8]
0x0002c0e8  ret      

=== -[OMCSpeedBubbleController setLiveStart:]  va=0x2c0ec size=16 types=v24@0:8d16
0x0002c0ec  adrp     x8, #0x8e000
0x0002c0f0  ldrsw    x8, [x8, #0xeac]
0x0002c0f4  str      d0, [x0, x8]
0x0002c0f8  ret      

=== -[OMCSpeedBubbleController styleStrip]  va=0x2c0fc size=16 types=@16@0:8
0x0002c0fc  adrp     x8, #0x8e000
0x0002c100  ldrsw    x8, [x8, #0xeb0]
0x0002c104  ldr      x0, [x0, x8]
0x0002c108  ret      

=== -[OMCSpeedBubbleController setStyleStrip:]  va=0x2c10c size=64 types=v24@0:8@16
0x0002c10c  stp      x22, x21, [sp, #-0x30]!
0x0002c110  stp      x20, x19, [sp, #0x10]
0x0002c114  stp      x29, x30, [sp, #0x20]
0x0002c118  add      x29, sp, #0x20
0x0002c11c  mov      x19, x2
0x0002c120  mov      x20, x0
0x0002c124  adrp     x8, #0x8e000
0x0002c128  ldrsw    x21, [x8, #0xeb0]
0x0002c12c  mov      x0, x2
0x0002c130  bl       #0x55d84   ; CALL _objc_retain
0x0002c134  ldr      x0, [x20, x21]
0x0002c138  str      x19, [x20, x21]
0x0002c13c  ldp      x29, x30, [sp, #0x20]
0x0002c140  ldp      x20, x19, [sp, #0x10]
0x0002c144  ldp      x22, x21, [sp], #0x30
0x0002c148  b        #0x55d78   ; CALL _objc_release

=== -[OMCSpeedBubbleController stripOffset]  va=0x2c14c size=16 types=d16@0:8
0x0002c14c  adrp     x8, #0x8e000
0x0002c150  ldrsw    x8, [x8, #0xeb4]
0x0002c154  ldr      d0, [x0, x8]
0x0002c158  ret      

=== -[OMCSpeedBubbleController setStripOffset:]  va=0x2c15c size=16 types=v24@0:8d16
0x0002c15c  adrp     x8, #0x8e000
0x0002c160  ldrsw    x8, [x8, #0xeb4]
0x0002c164  str      d0, [x0, x8]
0x0002c168  ret      

=== -[OMCSpeedBubbleController warnRows]  va=0x2c16c size=16 types=@16@0:8
0x0002c16c  adrp     x8, #0x8e000
0x0002c170  ldrsw    x8, [x8, #0xeb8]
0x0002c174  ldr      x0, [x0, x8]
0x0002c178  ret      

=== -[OMCSpeedBubbleController setWarnRows:]  va=0x2c17c size=64 types=v24@0:8@16
0x0002c17c  stp      x22, x21, [sp, #-0x30]!
0x0002c180  stp      x20, x19, [sp, #0x10]
0x0002c184  stp      x29, x30, [sp, #0x20]
0x0002c188  add      x29, sp, #0x20
0x0002c18c  mov      x19, x2
0x0002c190  mov      x20, x0
0x0002c194  adrp     x8, #0x8e000
0x0002c198  ldrsw    x21, [x8, #0xeb8]
0x0002c19c  mov      x0, x2
0x0002c1a0  bl       #0x55d84   ; CALL _objc_retain
0x0002c1a4  ldr      x0, [x20, x21]
0x0002c1a8  str      x19, [x20, x21]
0x0002c1ac  ldp      x29, x30, [sp, #0x20]
0x0002c1b0  ldp      x20, x19, [sp, #0x10]
0x0002c1b4  ldp      x22, x21, [sp], #0x30
0x0002c1b8  b        #0x55d78   ; CALL _objc_release

=== -[OMCSpeedBubbleController .cxx_destruct]  va=0x2c1bc size=1344 types=v16@0:8
0x0002c1bc  stp      x20, x19, [sp, #-0x20]!
0x0002c1c0  stp      x29, x30, [sp, #0x10]
0x0002c1c4  add      x29, sp, #0x10
0x0002c1c8  mov      x19, x0
0x0002c1cc  adrp     x8, #0x8e000
0x0002c1d0  ldrsw    x8, [x8, #0xeb8]
0x0002c1d4  add      x0, x0, x8
0x0002c1d8  mov      x1, #0
0x0002c1dc  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0002c1e0  adrp     x8, #0x8e000
0x0002c1e4  ldrsw    x8, [x8, #0xeb0]
0x0002c1e8  add      x0, x19, x8
0x0002c1ec  mov      x1, #0
0x0002c1f0  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0002c1f4  adrp     x8, #0x8e000
0x0002c1f8  ldrsw    x8, [x8, #0xea8]
0x0002c1fc  add      x0, x19, x8
0x0002c200  mov      x1, #0
0x0002c204  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0002c208  adrp     x8, #0x8e000
0x0002c20c  ldrsw    x8, [x8, #0xea4]
0x0002c210  add      x0, x19, x8
0x0002c214  mov      x1, #0
0x0002c218  bl       #0x55dcc   ; CALL _objc_storeStrong
0x0002c21c  adrp     x8, #0x8e000
0x0002c220  ldrsw    x8, [x8, #0xea0]
0x0002c224  add      x0, x19, x8
0x0002c228  mov      x1, #0
0x0002c22c  ldp      x29, x30, [sp, #0x10]
0x0002c230  ldp      x20, x19, [sp], #0x20
0x0002c234  b        #0x55dcc   ; CALL _objc_storeStrong
0x0002c238  sub      sp, sp, #0x70
0x0002c23c  stp      d9, d8, [sp, #0x30]
0x0002c240  stp      x22, x21, [sp, #0x40]
0x0002c244  stp      x20, x19, [sp, #0x50]
0x0002c248  stp      x29, x30, [sp, #0x60]
0x0002c24c  add      x29, sp, #0x60
0x0002c250  mov      x19, x0
0x0002c254  adrp     x8, #0x74000
0x0002c258  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x0002c25c  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002c260  str      x8, [sp, #0x28]
0x0002c264  ldr      x0, [x0, #0x20]
0x0002c268  bl       #0x5ae00   ; CALL objc_msgSend$setFill
0x0002c26c  mov      x8, #0x404e000000000000
0x0002c270  fmov     d8, x8
0x0002c274  fmov     d0, xzr
0x0002c278  fmov     d1, xzr
0x0002c27c  mov      v2.16b, v8.16b
0x0002c280  mov      v3.16b, v8.16b
0x0002c284  bl       #0x55b5c   ; CALL _UIRectFill
0x0002c288  adrp     x8, #0x74000
0x0002c28c  ldr      x8, [x8, #0x1d8]   ; @GOT _NSFontAttributeName
0x0002c290  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002c294  str      x8, [sp, #8]
0x0002c298  adrp     x8, #0x8e000
0x0002c29c  ldr      x0, [x8, #0x948]   ; @CLASS UIFont
0x0002c2a0  adrp     x8, #0x74000
0x0002c2a4  ldr      x8, [x8, #0x240]   ; @GOT _UIFontWeightHeavy
0x0002c2a8  ldr      d1, [x8]   ; @GOT ___objc_personality_v0
0x0002c2ac  fmov     d0, #28.00000000
0x0002c2b0  bl       #0x5d7e0   ; CALL objc_msgSend$systemFontOfSize:weight:
0x0002c2b4  mov      x29, x29
0x0002c2b8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c2bc  mov      x20, x0
0x0002c2c0  str      x0, [sp, #0x18]
0x0002c2c4  adrp     x8, #0x74000
0x0002c2c8  ldr      x8, [x8, #0x1e0]   ; @GOT _NSForegroundColorAttributeName
0x0002c2cc  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x0002c2d0  str      x8, [sp, #0x10]
0x0002c2d4  adrp     x8, #0x8e000
0x0002c2d8  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0002c2dc  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0002c2e0  mov      x29, x29
0x0002c2e4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c2e8  mov      x21, x0
0x0002c2ec  str      x0, [sp, #0x20]
0x0002c2f0  adrp     x8, #0x8e000
0x0002c2f4  ldr      x0, [x8, #0x970]   ; @CLASS NSDictionary
0x0002c2f8  add      x2, sp, #0x18
0x0002c2fc  add      x3, sp, #8
0x0002c300  mov      w4, #2
0x0002c304  bl       #0x577e0   ; CALL objc_msgSend$dictionaryWithObjects:forKeys:count:
0x0002c308  mov      x29, x29
0x0002c30c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c310  mov      x22, x0
0x0002c314  mov      x0, x21
0x0002c318  bl       #0x55d78   ; CALL _objc_release
0x0002c31c  mov      x0, x20
0x0002c320  bl       #0x55d78   ; CALL _objc_release
0x0002c324  ldr      x0, [x19, #0x28]
0x0002c328  mov      x2, x22
0x0002c32c  bl       #0x5cc00   ; CALL objc_msgSend$sizeWithAttributes:
0x0002c330  ldr      x0, [x19, #0x28]
0x0002c334  fsub     d0, d8, d0
0x0002c338  fmov     d2, #0.50000000
0x0002c33c  fmul     d0, d0, d2
0x0002c340  fsub     d1, d8, d1
0x0002c344  fmul     d1, d1, d2
0x0002c348  mov      x2, x22
0x0002c34c  bl       #0x578a0   ; CALL objc_msgSend$drawAtPoint:withAttributes:
0x0002c350  mov      x0, x22
0x0002c354  bl       #0x55d78   ; CALL _objc_release
0x0002c358  ldr      x8, [sp, #0x28]
0x0002c35c  adrp     x9, #0x74000
0x0002c360  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x0002c364  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x0002c368  cmp      x9, x8
0x0002c36c  b.ne     #0x2c388
0x0002c370  ldp      x29, x30, [sp, #0x60]
0x0002c374  ldp      x20, x19, [sp, #0x50]
0x0002c378  ldp      x22, x21, [sp, #0x40]
0x0002c37c  ldp      d9, d8, [sp, #0x30]
0x0002c380  add      sp, sp, #0x70
0x0002c384  ret      
0x0002c388  bl       #0x55b98   ; CALL ___stack_chk_fail
0x0002c38c  stp      d9, d8, [sp, #-0x40]!
0x0002c390  stp      x22, x21, [sp, #0x10]
0x0002c394  stp      x20, x19, [sp, #0x20]
0x0002c398  stp      x29, x30, [sp, #0x30]
0x0002c39c  add      x29, sp, #0x30
0x0002c3a0  mov      x19, x0
0x0002c3a4  mov      x0, x1
0x0002c3a8  bl       #0x55ea0   ; CALL objc_msgSend$CGContext
0x0002c3ac  mov      x20, x0
0x0002c3b0  adrp     x0, #0x7a000
0x0002c3b4  add      x0, x0, #0xe88   ; STR "#EEF0EA"
0x0002c3b8  bl       #0x18080   ; CALL _OMCColorFromHex
0x0002c3bc  mov      x29, x29
0x0002c3c0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c3c4  mov      x21, x0
0x0002c3c8  bl       #0x5ae00   ; CALL objc_msgSend$setFill
0x0002c3cc  mov      x0, x21
0x0002c3d0  bl       #0x55d78   ; CALL _objc_release
0x0002c3d4  ldp      d2, d3, [x19, #0x20]
0x0002c3d8  fmov     d0, xzr
0x0002c3dc  fmov     d1, xzr
0x0002c3e0  bl       #0x55b5c   ; CALL _UIRectFill
0x0002c3e4  adrp     x0, #0x7a000
0x0002c3e8  add      x0, x0, #0xea8   ; STR "#CDECCF"
0x0002c3ec  bl       #0x18080   ; CALL _OMCColorFromHex
0x0002c3f0  mov      x29, x29
0x0002c3f4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c3f8  mov      x21, x0
0x0002c3fc  bl       #0x5ae00   ; CALL objc_msgSend$setFill
0x0002c400  mov      x0, x21
0x0002c404  bl       #0x55d78   ; CALL _objc_release
0x0002c408  adrp     x22, #0x8e000
0x0002c40c  ldr      x0, [x22, #0xac0]   ; @CLASS UIBezierPath
0x0002c410  adrp     x8, #0x65000
0x0002c414  ldr      d0, [x8, #0xa08]
0x0002c418  ldp      d1, d2, [x19, #0x20]
0x0002c41c  fmul     d0, d1, d0
0x0002c420  adrp     x8, #0x65000
0x0002c424  ldr      d1, [x8, #0xa10]
0x0002c428  fmul     d1, d2, d1
0x0002c42c  adrp     x8, #0x65000
0x0002c430  ldr      d3, [x8, #0x708]
0x0002c434  fmul     d2, d2, d3
0x0002c438  mov      v3.16b, v2.16b
0x0002c43c  bl       #0x56820   ; CALL objc_msgSend$bezierPathWithOvalInRect:
0x0002c440  mov      x29, x29
0x0002c444  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c448  mov      x21, x0
0x0002c44c  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0002c450  mov      x0, x21
0x0002c454  bl       #0x55d78   ; CALL _objc_release
0x0002c458  adrp     x0, #0x7a000
0x0002c45c  add      x0, x0, #0xec8   ; STR "#C8E4F7"
0x0002c460  bl       #0x18080   ; CALL _OMCColorFromHex
0x0002c464  mov      x29, x29
0x0002c468  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c46c  mov      x21, x0
0x0002c470  bl       #0x5ae00   ; CALL objc_msgSend$setFill
0x0002c474  mov      x0, x21
0x0002c478  bl       #0x55d78   ; CALL _objc_release
0x0002c47c  ldr      x0, [x22, #0xac0]   ; @CLASS UIBezierPath
0x0002c480  ldr      d2, [x19, #0x28]
0x0002c484  adrp     x8, #0x65000
0x0002c488  ldr      d0, [x8, #0xa18]
0x0002c48c  fmul     d0, d2, d0
0x0002c490  adrp     x8, #0x65000
0x0002c494  ldr      d1, [x8, #0x6c0]
0x0002c498  fmul     d1, d2, d1
0x0002c49c  mov      v3.16b, v2.16b
0x0002c4a0  bl       #0x56820   ; CALL objc_msgSend$bezierPathWithOvalInRect:
0x0002c4a4  mov      x29, x29
0x0002c4a8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c4ac  mov      x21, x0
0x0002c4b0  bl       #0x57bc0   ; CALL objc_msgSend$fill
0x0002c4b4  mov      x0, x21
0x0002c4b8  bl       #0x55d78   ; CALL _objc_release
0x0002c4bc  mov      x0, x20
0x0002c4c0  mov      w1, #1
0x0002c4c4  bl       #0x559a0   ; CALL _CGContextSetLineCap
0x0002c4c8  adrp     x0, #0x7a000
0x0002c4cc  add      x0, x0, #0xee8   ; STR "#FFE9A8"
0x0002c4d0  bl       #0x18080   ; CALL _OMCColorFromHex
0x0002c4d4  mov      x29, x29
0x0002c4d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c4dc  mov      x20, x0
0x0002c4e0  bl       #0x5c360   ; CALL objc_msgSend$setStroke
0x0002c4e4  mov      x0, x20
0x0002c4e8  bl       #0x55d78   ; CALL _objc_release
0x0002c4ec  ldr      x0, [x22, #0xac0]   ; @CLASS UIBezierPath
0x0002c4f0  bl       #0x567e0   ; CALL objc_msgSend$bezierPath
0x0002c4f4  mov      x29, x29
0x0002c4f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c4fc  mov      x21, x0
0x0002c500  ldr      d0, [x19, #0x28]
0x0002c504  adrp     x8, #0x65000
0x0002c508  ldr      d1, [x8, #0x768]
0x0002c50c  fmul     d0, d0, d1
0x0002c510  bl       #0x5b3a0   ; CALL objc_msgSend$setLineWidth:
0x0002c514  ldr      d0, [x19, #0x28]
0x0002c518  adrp     x8, #0x65000
0x0002c51c  ldr      d9, [x8, #0xa20]
0x0002c520  fmul     d1, d0, d9
0x0002c524  fmov     d0, #-10.00000000
0x0002c528  mov      x0, x21
0x0002c52c  bl       #0x59060   ; CALL objc_msgSend$moveToPoint:
0x0002c530  fmov     d8, #10.00000000
0x0002c534  ldp      d0, d1, [x19, #0x20]
0x0002c538  fadd     d0, d0, d8
0x0002c53c  adrp     x8, #0x65000
0x0002c540  ldr      d2, [x8, #0x728]
0x0002c544  fmul     d1, d1, d2
0x0002c548  mov      x0, x21
0x0002c54c  bl       #0x56100   ; CALL objc_msgSend$addLineToPoint:
0x0002c550  mov      x0, x21
0x0002c554  bl       #0x5d5e0   ; CALL objc_msgSend$stroke
0x0002c558  adrp     x8, #0x8e000
0x0002c55c  ldr      x0, [x8, #0x910]   ; @CLASS UIColor
0x0002c560  bl       #0x5e160   ; CALL objc_msgSend$whiteColor
0x0002c564  mov      x29, x29
0x0002c568  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c56c  mov      x20, x0
0x0002c570  bl       #0x5c360   ; CALL objc_msgSend$setStroke
0x0002c574  mov      x0, x20
0x0002c578  bl       #0x55d78   ; CALL _objc_release
0x0002c57c  ldr      x0, [x22, #0xac0]   ; @CLASS UIBezierPath
0x0002c580  bl       #0x567e0   ; CALL objc_msgSend$bezierPath
0x0002c584  mov      x29, x29
0x0002c588  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c58c  mov      x20, x0
0x0002c590  mov      x0, x21
0x0002c594  bl       #0x55d78   ; CALL _objc_release
0x0002c598  ldr      d0, [x19, #0x28]
0x0002c59c  adrp     x8, #0x65000
0x0002c5a0  ldr      d1, [x8, #0x748]
0x0002c5a4  fmul     d0, d0, d1
0x0002c5a8  mov      x0, x20
0x0002c5ac  bl       #0x5b3a0   ; CALL objc_msgSend$setLineWidth:
0x0002c5b0  adrp     x8, #0x65000
0x0002c5b4  ldr      d0, [x8, #0xa28]
0x0002c5b8  ldp      d1, d2, [x19, #0x20]
0x0002c5bc  fmul     d0, d1, d0
0x0002c5c0  fadd     d1, d2, d8
0x0002c5c4  mov      x0, x20
0x0002c5c8  bl       #0x59060   ; CALL objc_msgSend$moveToPoint:
0x0002c5cc  ldr      d0, [x19, #0x20]
0x0002c5d0  fmul     d0, d0, d9
0x0002c5d4  fmov     d1, #-10.00000000
0x0002c5d8  mov      x0, x20
0x0002c5dc  bl       #0x56100   ; CALL objc_msgSend$addLineToPoint:
0x0002c5e0  mov      x0, x20
0x0002c5e4  bl       #0x5d5e0   ; CALL objc_msgSend$stroke
0x0002c5e8  adrp     x0, #0x7a000
0x0002c5ec  add      x0, x0, #0xf08   ; STR "#3D8BFF"
0x0002c5f0  bl       #0x18080   ; CALL _OMCColorFromHex
0x0002c5f4  mov      x29, x29
0x0002c5f8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c5fc  mov      x21, x0
0x0002c600  bl       #0x5c360   ; CALL objc_msgSend$setStroke
0x0002c604  mov      x0, x21
0x0002c608  bl       #0x55d78   ; CALL _objc_release
0x0002c60c  ldr      x0, [x22, #0xac0]   ; @CLASS UIBezierPath
0x0002c610  bl       #0x567e0   ; CALL objc_msgSend$bezierPath
0x0002c614  mov      x29, x29
0x0002c618  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c61c  mov      x21, x0
0x0002c620  mov      x0, x20
0x0002c624  bl       #0x55d78   ; CALL _objc_release
0x0002c628  ldr      d0, [x19, #0x28]
0x0002c62c  adrp     x8, #0x65000
0x0002c630  ldr      d1, [x8, #0xa30]
0x0002c634  fmul     d0, d0, d1
0x0002c638  mov      x0, x21
0x0002c63c  bl       #0x5b3a0   ; CALL objc_msgSend$setLineWidth:
0x0002c640  adrp     x8, #0x65000
0x0002c644  ldr      d0, [x8, #0xa38]
0x0002c648  ldp      d1, d2, [x19, #0x20]
0x0002c64c  fmul     d0, d1, d0
0x0002c650  fadd     d1, d2, d8
0x0002c654  mov      x0, x21
0x0002c658  bl       #0x59060   ; CALL objc_msgSend$moveToPoint:
0x0002c65c  ldr      d0, [x19, #0x20]
0x0002c660  adrp     x8, #0x65000
0x0002c664  ldr      d1, [x8, #0xa40]
0x0002c668  fmul     d0, d0, d1
0x0002c66c  fmov     d1, #-10.00000000
0x0002c670  mov      x0, x21
0x0002c674  bl       #0x56100   ; CALL objc_msgSend$addLineToPoint:
0x0002c678  mov      x0, x21
0x0002c67c  bl       #0x5d5e0   ; CALL objc_msgSend$stroke
0x0002c680  mov      x0, x21
0x0002c684  ldp      x29, x30, [sp, #0x30]
0x0002c688  ldp      x20, x19, [sp, #0x20]
0x0002c68c  ldp      x22, x21, [sp, #0x10]
0x0002c690  ldp      d9, d8, [sp], #0x40
0x0002c694  b        #0x55d78   ; CALL _objc_release
0x0002c698  stp      x20, x19, [sp, #-0x20]!
0x0002c69c  stp      x29, x30, [sp, #0x10]
0x0002c6a0  add      x29, sp, #0x10
0x0002c6a4  mov      x19, x0
0x0002c6a8  adrp     x8, #0x8e000
0x0002c6ac  ldr      x0, [x8, #0xac0]   ; @CLASS UIBezierPath
0x0002c6b0  ldp      d2, d4, [x19, #0x28]
0x0002c6b4  fmov     d0, xzr
0x0002c6b8  fmov     d1, xzr
0x0002c6bc  mov      v3.16b, v2.16b
0x0002c6c0  bl       #0x56840   ; CALL objc_msgSend$bezierPathWithRoundedRect:cornerRadius:
0x0002c6c4  mov      x29, x29
0x0002c6c8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0002c6cc  mov      x20, x0
0x0002c6d0  bl       #0x560a0   ; CALL objc_msgSend$addClip
0x0002c6d4  mov      x0, x20
0x0002c6d8  bl       #0x55d78   ; CALL _objc_release
0x0002c6dc  ldr      x0, [x19, #0x20]
0x0002c6e0  ldr      d2, [x19, #0x28]
0x0002c6e4  fmov     d0, xzr
0x0002c6e8  fmov     d1, xzr
0x0002c6ec  mov      v3.16b, v2.16b
0x0002c6f0  ldp      x29, x30, [sp, #0x10]
0x0002c6f4  ldp      x20, x19, [sp], #0x20
0x0002c6f8  b        #0x578e0   ; CALL objc_msgSend$drawInRect:
