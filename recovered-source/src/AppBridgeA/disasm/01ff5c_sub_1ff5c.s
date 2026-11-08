; ==== sub_1ff5c @ 0x1ff5c..0x205c8 (1644 bytes) ====
0x0001ff5c  bl       #0x25420   ; objc_msgSend: count
0x0001ff60  cmp      x0, #0
0x0001ff64  csel     x1, xzr, x23, eq
0x0001ff68  adrp     x0, #0x37000
0x0001ff6c  add      x0, x0, #0xdb0   ; -> @"rescueFeatures"
0x0001ff70  adrp     x24, #0x37000
0x0001ff74  add      x24, x24, #0x70   ; -> @"com.anlai.omnicar"
0x0001ff78  mov      x2, x24
0x0001ff7c  bl       #0x242cc   ; call _CFPreferencesSetAppValue
0x0001ff80  mov      x0, x24
0x0001ff84  bl       #0x242b4   ; call _CFPreferencesAppSynchronize
0x0001ff88  adrp     x8, #0x3e000
0x0001ff8c  ldr      x0, [x8, #0x290]   ; -> [class(NSString)]
0x0001ff90  str      x26, [sp]
0x0001ff94  adrp     x2, #0x37000
0x0001ff98  add      x2, x2, #0xe10   ; -> @"%@ bat lai sau che do cuu"
0x0001ff9c  b        #0x1ffdc   ; call sub_1ffdc
0x0001ffa0  mov      w22, #1
0x0001ffa4  b        #0x2000c   ; call sub_2000c
0x0001ffa8  adrp     x8, #0x3e000
0x0001ffac  ldr      x24, [x8, #0x290]   ; -> [class(NSString)]
0x0001ffb0  adrp     x0, #0x37000
0x0001ffb4  add      x0, x0, #0xdf0   ; -> @"rescueDate"
0x0001ffb8  mov      x1, #0
0x0001ffbc  bl       #0x1d680   ; call _OMCPref
0x0001ffc0  mov      x29, x29
0x0001ffc4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ffc8  mov      x23, x0
0x0001ffcc  stp      x26, x0, [sp]
0x0001ffd0  adrp     x2, #0x37000
0x0001ffd4  add      x2, x2, #0xdd0   ; -> @"%@ dang tat boi che do cuu (tu %@): khong cai hook trong CarPlay"
0x0001ffd8  mov      x0, x24
0x0001ffdc  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x0001ffe0  mov      x29, x29
0x0001ffe4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x0001ffe8  mov      x24, x0
0x0001ffec  adrp     x0, #0x37000
0x0001fff0  add      x0, x0, #0xd50   ; -> @"Core"
0x0001fff4  mov      x1, x24
0x0001fff8  bl       #0x1dd30   ; call _OMCLogWrite
0x0001fffc  mov      x0, x24
0x00020000  bl       #0x2480c   ; call _objc_release
0x00020004  mov      x0, x23
0x00020008  bl       #0x2480c   ; call _objc_release
0x0002000c  mov      x0, x21
0x00020010  bl       #0x2480c   ; call _objc_release
0x00020014  mov      x0, x20
0x00020018  bl       #0x2480c   ; call _objc_release
0x0002001c  mov      x0, x19
0x00020020  bl       #0x2480c   ; call _objc_release
0x00020024  mov      x0, x26
0x00020028  bl       #0x2480c   ; call _objc_release
0x0002002c  ldur     x8, [x29, #-0x60]
0x00020030  adrp     x9, #0x34000
0x00020034  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x00020038  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x0002003c  cmp      x9, x8
0x00020040  b.ne     #0x200f0
0x00020044  mov      x0, x22
0x00020048  add      sp, sp, #0x480
0x0002004c  ldp      x29, x30, [sp, #0x50]
0x00020050  ldp      x20, x19, [sp, #0x40]
0x00020054  ldp      x22, x21, [sp, #0x30]
0x00020058  ldp      x24, x23, [sp, #0x20]
0x0002005c  ldp      x26, x25, [sp, #0x10]
0x00020060  ldp      x28, x27, [sp], #0x60
0x00020064  ret      
0x00020068  add      x19, x8, #1
0x0002006c  cbz      x19, #0x1fbc8
0x00020070  adrp     x8, #0x3e000
0x00020074  ldr      x20, [x8, #0x290]   ; -> [class(NSString)]
0x00020078  adrp     x2, #0x36000
0x0002007c  add      x2, x2, #0x930   ; -> @", "
0x00020080  mov      x0, x27
0x00020084  bl       #0x252a0   ; objc_msgSend: componentsJoinedByString:
0x00020088  mov      x29, x29
0x0002008c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020090  mov      x21, x0
0x00020094  mov      w8, #2
0x00020098  stp      x8, x0, [sp, #8]
0x0002009c  str      x19, [sp]
0x000200a0  adrp     x2, #0x38000
0x000200a4  add      x2, x2, #0x110   ; -> @"CarPlay sap som %ld/%d lan lien (nghi: %@)"
0x000200a8  mov      x0, x20
0x000200ac  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x000200b0  mov      x29, x29
0x000200b4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000200b8  mov      x20, x0
0x000200bc  adrp     x0, #0x37000
0x000200c0  add      x0, x0, #0xd50   ; -> @"Core"
0x000200c4  mov      x1, x20
0x000200c8  bl       #0x1dd30   ; call _OMCLogWrite
0x000200cc  mov      x0, x20
0x000200d0  adrp     x20, #0x3e000
0x000200d4  bl       #0x2480c   ; call _objc_release
0x000200d8  mov      x0, x21
0x000200dc  ldr      x21, [sp, #0x38]
0x000200e0  bl       #0x2480c   ; call _objc_release
0x000200e4  b        #0x1fbc8   ; call sub_1fbc8
0x000200e8  bl       #0x24260   ; call sub_24260
0x000200ec  b        #0x1efa8   ; call sub_1efa8
0x000200f0  bl       #0x24488   ; call ___stack_chk_fail
0x000200f4  stp      x20, x19, [sp, #-0x20]!
0x000200f8  stp      x29, x30, [sp, #0x10]
0x000200fc  add      x29, sp, #0x10
0x00020100  adrp     x19, #0x3e000
0x00020104  ldr      x0, [x19, #0xb30]
0x00020108  cbnz     x0, #0x2012c
0x0002010c  adrp     x0, #0x2a000
0x00020110  add      x0, x0, #0x9e6   ; -> "OMC_CRASHGUARD"
0x00020114  bl       #0x24638   ; call _getenv
0x00020118  cbz      x0, #0x2012c
0x0002011c  mov      x1, #0
0x00020120  mov      w2, #0x10
0x00020124  bl       #0x24980   ; call _strtoull
0x00020128  str      x0, [x19, #0xb30]
0x0002012c  ldp      x29, x30, [sp, #0x10]
0x00020130  ldp      x20, x19, [sp], #0x20
0x00020134  ret      
0x00020138  stp      x20, x19, [sp, #-0x20]!
0x0002013c  stp      x29, x30, [sp, #0x10]
0x00020140  add      x29, sp, #0x10
0x00020144  bl       #0x24464   ; call _NSTemporaryDirectory
0x00020148  mov      x29, x29
0x0002014c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020150  mov      x19, x0
0x00020154  adrp     x2, #0x38000
0x00020158  add      x2, x2, #0xa10   ; -> @"OmniCar-crashguard.plist"
0x0002015c  bl       #0x27c60   ; objc_msgSend: stringByAppendingPathComponent:
0x00020160  mov      x29, x29
0x00020164  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020168  mov      x20, x0
0x0002016c  mov      x0, x19
0x00020170  bl       #0x2480c   ; call _objc_release
0x00020174  mov      x0, x20
0x00020178  ldp      x29, x30, [sp, #0x10]
0x0002017c  ldp      x20, x19, [sp], #0x20
0x00020180  b        #0x24734   ; call _objc_autoreleaseReturnValue
0x00020184  sub      sp, sp, #0x50
0x00020188  stp      x20, x19, [sp, #0x30]
0x0002018c  stp      x29, x30, [sp, #0x40]
0x00020190  add      x29, sp, #0x40
0x00020194  adrp     x8, #0x3e000
0x00020198  ldr      x0, [x8, #0x408]   ; -> [class(NSProcessInfo)]
0x0002019c  bl       #0x266c0   ; objc_msgSend: processInfo
0x000201a0  mov      x29, x29
0x000201a4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000201a8  mov      x20, x0
0x000201ac  bl       #0x266e0   ; objc_msgSend: processName
0x000201b0  mov      x29, x29
0x000201b4  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000201b8  mov      x19, x0
0x000201bc  mov      x0, x20
0x000201c0  bl       #0x2480c   ; call _objc_release
0x000201c4  adrp     x2, #0x37000
0x000201c8  add      x2, x2, #0xe30   ; -> @"SpringBoard"
0x000201cc  mov      x0, x19
0x000201d0  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x000201d4  tbnz     w0, #0, #0x201ec
0x000201d8  adrp     x2, #0x37000
0x000201dc  add      x2, x2, #0xe50   ; -> @"CarPlay"
0x000201e0  mov      x0, x19
0x000201e4  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x000201e8  cbz      w0, #0x2023c
0x000201ec  adrp     x8, #0x34000
0x000201f0  ldr      x8, [x8, #0x258]   ; -> [got:__NSConcreteStackBlock]
0x000201f4  str      x8, [sp, #8]
0x000201f8  adrp     x8, #0x2b000
0x000201fc  ldr      d0, [x8, #0x1d0]
0x00020200  str      d0, [sp, #0x10]
0x00020204  adrp     x8, #0x20000
0x00020208  add      x8, x8, #0x254
0x0002020c  adrp     x9, #0x34000
0x00020210  add      x9, x9, #0xba0
0x00020214  stp      x8, x9, [sp, #0x18]
0x00020218  mov      x0, x19
0x0002021c  bl       #0x24818   ; call _objc_retain
0x00020220  str      x19, [sp, #0x28]
0x00020224  adrp     x0, #0x34000
0x00020228  ldr      x0, [x0, #0x290]   ; -> [got:__dispatch_main_q]
0x0002022c  add      x1, sp, #8
0x00020230  bl       #0x24554   ; call _dispatch_async
0x00020234  ldr      x0, [sp, #0x28]
0x00020238  bl       #0x2480c   ; call _objc_release
0x0002023c  mov      x0, x19
0x00020240  bl       #0x2480c   ; call _objc_release
0x00020244  ldp      x29, x30, [sp, #0x40]
0x00020248  ldp      x20, x19, [sp, #0x30]
0x0002024c  add      sp, sp, #0x50
0x00020250  ret      
0x00020254  sub      sp, sp, #0x80
0x00020258  stp      x22, x21, [sp, #0x50]
0x0002025c  stp      x20, x19, [sp, #0x60]
0x00020260  stp      x29, x30, [sp, #0x70]
0x00020264  add      x29, sp, #0x70
0x00020268  mov      x19, x0
0x0002026c  adrp     x8, #0x34000
0x00020270  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00020274  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00020278  stur     x8, [x29, #-0x28]
0x0002027c  adrp     x21, #0x3e000
0x00020280  ldr      x0, [x21, #0x290]   ; -> [class(NSString)]
0x00020284  ldr      x10, [x19, #0x20]   ; -> [@selector(timeZoneForSecondsFromGMT:)]
0x00020288  adrp     x8, #0x2a000
0x0002028c  add      x8, x8, #0x99e   ; -> "1.0.3"
0x00020290  adrp     x9, #0x2a000
0x00020294  add      x9, x9, #0x996   ; -> "fbebb21"
0x00020298  stp      x8, x10, [sp, #8]
0x0002029c  str      x9, [sp]
0x000202a0  adrp     x2, #0x37000
0x000202a4  add      x2, x2, #0xe70   ; -> @"build %s (%s) loaded into %@"
0x000202a8  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x000202ac  mov      x29, x29
0x000202b0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000202b4  mov      x20, x0
0x000202b8  adrp     x0, #0x34000
0x000202bc  add      x0, x0, #0xef0   ; -> @"AppBridge"
0x000202c0  mov      x1, x20
0x000202c4  bl       #0x1dd30   ; call _OMCLogWrite
0x000202c8  mov      x0, x20
0x000202cc  bl       #0x2480c   ; call _objc_release
0x000202d0  ldr      x0, [x21, #0x290]   ; -> [class(NSString)]
0x000202d4  ldr      x10, [x19, #0x20]   ; -> [@selector(timeZoneForSecondsFromGMT:)]
0x000202d8  adrp     x8, #0x29000
0x000202dc  add      x8, x8, #0x94   ; -> "AppBridge"
0x000202e0  adrp     x9, #0x37000
0x000202e4  add      x9, x9, #0xeb0   ; -> @"diagLoaded."
0x000202e8  stp      x8, x10, [sp, #8]
0x000202ec  str      x9, [sp]
0x000202f0  adrp     x2, #0x37000
0x000202f4  add      x2, x2, #0xe90   ; -> @"%@%s@%@"
0x000202f8  bl       #0x27d20   ; objc_msgSend: stringWithFormat:
0x000202fc  mov      x29, x29
0x00020300  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020304  mov      x19, x0
0x00020308  adrp     x8, #0x37000
0x0002030c  add      x8, x8, #0xed0   ; -> @"version"
0x00020310  adrp     x9, #0x37000
0x00020314  add      x9, x9, #0xef0   ; -> @"1.0.3"
0x00020318  adrp     x10, #0x37000
0x0002031c  add      x10, x10, #0xf10   ; -> @"build"
0x00020320  stp      x8, x10, [sp, #0x18]
0x00020324  adrp     x8, #0x37000
0x00020328  add      x8, x8, #0xf30   ; -> @"fbebb21"
0x0002032c  stp      x9, x8, [sp, #0x30]
0x00020330  adrp     x8, #0x37000
0x00020334  add      x8, x8, #0xf50   ; -> @"date"
0x00020338  str      x8, [sp, #0x28]
0x0002033c  adrp     x8, #0x3e000
0x00020340  ldr      x0, [x8, #0x418]   ; -> [class(NSDate)]
0x00020344  bl       #0x25480   ; objc_msgSend: date
0x00020348  mov      x29, x29
0x0002034c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020350  mov      x20, x0
0x00020354  str      x0, [sp, #0x40]
0x00020358  adrp     x8, #0x3e000
0x0002035c  ldr      x0, [x8, #0x310]   ; -> [class(NSDictionary)]
0x00020360  add      x2, sp, #0x30
0x00020364  add      x3, sp, #0x18
0x00020368  mov      w4, #3
0x0002036c  bl       #0x255c0   ; objc_msgSend: dictionaryWithObjects:forKeys:count:
0x00020370  mov      x29, x29
0x00020374  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020378  mov      x21, x0
0x0002037c  mov      x0, x20
0x00020380  bl       #0x2480c   ; call _objc_release
0x00020384  adrp     x20, #0x37000
0x00020388  add      x20, x20, #0x70   ; -> @"com.anlai.omnicar"
0x0002038c  mov      x0, x19
0x00020390  mov      x1, x21
0x00020394  mov      x2, x20
0x00020398  bl       #0x242cc   ; call _CFPreferencesSetAppValue
0x0002039c  mov      x0, x20
0x000203a0  bl       #0x242b4   ; call _CFPreferencesAppSynchronize
0x000203a4  mov      x0, x21
0x000203a8  bl       #0x2480c   ; call _objc_release
0x000203ac  mov      x0, x19
0x000203b0  bl       #0x2480c   ; call _objc_release
0x000203b4  ldur     x8, [x29, #-0x28]
0x000203b8  adrp     x9, #0x34000
0x000203bc  ldr      x9, [x9, #0x278]   ; -> [got:___stack_chk_guard]
0x000203c0  ldr      x9, [x9]   ; -> [got:___objc_personality_v0]
0x000203c4  cmp      x9, x8
0x000203c8  b.ne     #0x203e0
0x000203cc  ldp      x29, x30, [sp, #0x70]
0x000203d0  ldp      x20, x19, [sp, #0x60]
0x000203d4  ldp      x22, x21, [sp, #0x50]
0x000203d8  add      sp, sp, #0x80
0x000203dc  ret      
0x000203e0  bl       #0x24488   ; call ___stack_chk_fail
0x000203e4  stp      x29, x30, [sp, #-0x10]!
0x000203e8  mov      x29, sp
0x000203ec  adrp     x0, #0x2a000
0x000203f0  add      x0, x0, #0x9cb   ; -> "com.anlai.omnicar.log"
0x000203f4  mov      x1, #0
0x000203f8  bl       #0x24584   ; call _dispatch_queue_create
0x000203fc  adrp     x9, #0x3e000
0x00020400  ldr      x8, [x9, #0xb00]
0x00020404  str      x0, [x9, #0xb00]
0x00020408  mov      x0, x8
0x0002040c  ldp      x29, x30, [sp], #0x10
0x00020410  b        #0x2480c   ; call _objc_release
0x00020414  stp      x20, x19, [sp, #-0x20]!
0x00020418  stp      x29, x30, [sp, #0x10]
0x0002041c  add      x29, sp, #0x10
0x00020420  adrp     x8, #0x3e000
0x00020424  ldr      x0, [x8, #0x280]   ; -> [class(NSBundle)]
0x00020428  bl       #0x26080   ; objc_msgSend: mainBundle
0x0002042c  mov      x29, x29
0x00020430  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020434  mov      x19, x0
0x00020438  bl       #0x25040   ; objc_msgSend: bundleIdentifier
0x0002043c  mov      x29, x29
0x00020440  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020444  mov      x20, x0
0x00020448  adrp     x2, #0x34000
0x0002044c  add      x2, x2, #0xdf0   ; -> @"com.apple.springboard"
0x00020450  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x00020454  adrp     x8, #0x3e000
0x00020458  strb     w0, [x8, #0xb10]
0x0002045c  mov      x0, x20
0x00020460  bl       #0x2480c   ; call _objc_release
0x00020464  mov      x0, x19
0x00020468  ldp      x29, x30, [sp, #0x10]
0x0002046c  ldp      x20, x19, [sp], #0x20
0x00020470  b        #0x2480c   ; call _objc_release
0x00020474  stp      x20, x19, [sp, #-0x20]!
0x00020478  stp      x29, x30, [sp, #0x10]
0x0002047c  add      x29, sp, #0x10
0x00020480  adrp     x8, #0x3e000
0x00020484  ldr      x0, [x8, #0x280]   ; -> [class(NSBundle)]
0x00020488  bl       #0x26080   ; objc_msgSend: mainBundle
0x0002048c  mov      x29, x29
0x00020490  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020494  mov      x19, x0
0x00020498  bl       #0x25040   ; objc_msgSend: bundleIdentifier
0x0002049c  mov      x29, x29
0x000204a0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000204a4  mov      x20, x0
0x000204a8  adrp     x2, #0x34000
0x000204ac  add      x2, x2, #0xe10   ; -> @"com.apple.CarPlayApp"
0x000204b0  bl       #0x25cc0   ; objc_msgSend: isEqualToString:
0x000204b4  adrp     x8, #0x3e000
0x000204b8  strb     w0, [x8, #0xb20]
0x000204bc  mov      x0, x20
0x000204c0  bl       #0x2480c   ; call _objc_release
0x000204c4  mov      x0, x19
0x000204c8  ldp      x29, x30, [sp, #0x10]
0x000204cc  ldp      x20, x19, [sp], #0x20
0x000204d0  b        #0x2480c   ; call _objc_release
0x000204d4  stp      x28, x27, [sp, #-0x60]!
0x000204d8  stp      x26, x25, [sp, #0x10]
0x000204dc  stp      x24, x23, [sp, #0x20]
0x000204e0  stp      x22, x21, [sp, #0x30]
0x000204e4  stp      x20, x19, [sp, #0x40]
0x000204e8  stp      x29, x30, [sp, #0x50]
0x000204ec  add      x29, sp, #0x50
0x000204f0  sub      sp, sp, #0x2f0
0x000204f4  mov      x19, x0
0x000204f8  adrp     x8, #0x34000
0x000204fc  ldr      x8, [x8, #0x278]   ; -> [got:___stack_chk_guard]
0x00020500  ldr      x8, [x8]   ; -> [got:___objc_personality_v0]
0x00020504  stur     x8, [x29, #-0x58]
0x00020508  bl       #0x24818   ; call _objc_retain
0x0002050c  adrp     x8, #0x3e000
0x00020510  ldr      x0, [x8, #0xb30]
0x00020514  mov      w8, #0x1a4
0x00020518  str      x8, [sp]
0x0002051c  mov      w1, #0x209
0x00020520  bl       #0x248b4   ; call _open
0x00020524  tbnz     w0, #0x1f, #0x206dc
0x00020528  mov      x20, x0
0x0002052c  movi     v0.16b, #0
0x00020530  stp      q0, q0, [sp, #0x20]
0x00020534  stp      q0, q0, [sp, #0x40]
0x00020538  mov      x0, x19
0x0002053c  bl       #0x250a0   ; objc_msgSend: callStackReturnAddresses
0x00020540  mov      x29, x29
0x00020544  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00020548  mov      x21, x0
0x0002054c  add      x2, sp, #0x20
0x00020550  add      x3, sp, #0x68
0x00020554  mov      w4, #0x10
0x00020558  bl       #0x25440   ; objc_msgSend: countByEnumeratingWithState:objects:count:
0x0002055c  cbz      x0, #0x205e8
0x00020560  mov      x22, x0
0x00020564  mov      x23, #0
0x00020568  ldr      x8, [sp, #0x30]
0x0002056c  ldr      x24, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00020570  add      x25, sp, #0xe8
0x00020574  mov      x26, #0
0x00020578  sxtw     x27, w23
0x0002057c  ldr      x8, [sp, #0x30]
0x00020580  ldr      x8, [x8]   ; -> [@selector(textFieldShouldReturn:)]
0x00020584  cmp      x8, x24
0x00020588  b.eq     #0x20594
0x0002058c  mov      x0, x21
0x00020590  bl       #0x24770   ; call _objc_enumerationMutation
0x00020594  cmp      x27, #0x40
0x00020598  b.eq     #0x205e0
0x0002059c  ldr      x8, [sp, #0x28]
0x000205a0  ldr      x0, [x8, x26, lsl #3]   ; -> [@selector(textFieldShouldReturn:)]
0x000205a4  bl       #0x28060   ; objc_msgSend: unsignedLongLongValue
0x000205a8  add      x23, x27, #1
0x000205ac  str      x0, [x25, x27, lsl #3]
0x000205b0  add      x26, x26, #1
0x000205b4  mov      x27, x23
0x000205b8  cmp      x22, x26
0x000205bc  b.ne     #0x2057c
0x000205c0  add      x2, sp, #0x20
0x000205c4  add      x3, sp, #0x68
