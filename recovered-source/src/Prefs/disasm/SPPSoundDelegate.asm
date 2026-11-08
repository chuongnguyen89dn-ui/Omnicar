=== -[SPPSoundDelegate audioPlayerDidFinishPlaying:successfully:]  va=0x35538 size=152 types=v28@0:8@16B24
0x00035538  b        #0x3553c
0x0003553c  adrp     x8, #0x90000
0x00035540  ldr      w9, [x8, #0xa8]
0x00035544  subs     w9, w9, #1
0x00035548  b.lt     #0x355b0
0x0003554c  str      w9, [x8, #0xa8]
0x00035550  b.ne     #0x355b0
0x00035554  stp      x20, x19, [sp, #-0x20]!
0x00035558  stp      x29, x30, [sp, #0x10]
0x0003555c  add      x29, sp, #0x10
0x00035560  adrp     x8, #0x8e000
0x00035564  ldr      x0, [x8, #0xc08]   ; @CLASS AVAudioSession
0x00035568  bl       #0x5c980   ; CALL objc_msgSend$sharedInstance
0x0003556c  mov      x29, x29
0x00035570  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00035574  mov      x19, x0
0x00035578  mov      w2, #0
0x0003557c  mov      w3, #1
0x00035580  mov      x4, #0
0x00035584  bl       #0x5a320   ; CALL objc_msgSend$setActive:withOptions:error:
0x00035588  adrp     x20, #0x90000
0x0003558c  ldr      x2, [x20, #0xa0]
0x00035590  cbz      x2, #0x355b4
0x00035594  adrp     x8, #0x90000
0x00035598  ldr      x3, [x8, #0xb0]
0x0003559c  mov      x0, x19
0x000355a0  mov      x4, #0
0x000355a4  bl       #0x5a820   ; CALL objc_msgSend$setCategory:withOptions:error:
0x000355a8  ldr      x0, [x20, #0xa0]
0x000355ac  b        #0x355b8
0x000355b0  ret      
0x000355b4  mov      x0, #0
0x000355b8  str      xzr, [x20, #0xa0]
0x000355bc  bl       #0x55d78   ; CALL _objc_release
0x000355c0  mov      x0, x19
0x000355c4  ldp      x29, x30, [sp, #0x10]
0x000355c8  ldp      x20, x19, [sp], #0x20
0x000355cc  b        #0x55d78   ; CALL _objc_release

=== -[SPPSoundDelegate audioPlayerDecodeErrorDidOccur:error:]  va=0x355d0 size=40 types=v32@0:8@16@24
0x000355d0  sub      sp, sp, #0x20
0x000355d4  stp      x29, x30, [sp, #0x10]
0x000355d8  add      x29, sp, #0x10
0x000355dc  str      x3, [sp]
0x000355e0  adrp     x0, #0x7b000
0x000355e4  add      x0, x0, #0x6c8   ; STR "OmniCar SpeedBubble: am thanh: loi giai ma %@"
0x000355e8  bl       #0x55afc   ; CALL _NSLog
0x000355ec  ldp      x29, x30, [sp, #0x10]
0x000355f0  add      sp, sp, #0x20
0x000355f4  b        #0x3553c

=== -[SPPSoundDelegate speechSynthesizer:didFinishSpeechUtterance:]  va=0x355f8 size=4 types=v32@0:8@16@24
0x000355f8  b        #0x3553c

=== -[SPPSoundDelegate speechSynthesizer:didCancelSpeechUtterance:]  va=0x355fc size=4 types=v32@0:8@16@24
0x000355fc  b        #0x3553c
