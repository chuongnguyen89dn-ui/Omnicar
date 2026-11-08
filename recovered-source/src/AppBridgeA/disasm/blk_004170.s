; block literal @0x345c0 desc @0x345a0 sig=v8@?0 flags=0x50000000
; ==== sub_4170 @ 0x4170..0x44a8 (824 bytes) ====
0x00004170  stp      x24, x23, [sp, #-0x40]!
0x00004174  stp      x22, x21, [sp, #0x10]
0x00004178  stp      x20, x19, [sp, #0x20]
0x0000417c  stp      x29, x30, [sp, #0x30]
0x00004180  add      x29, sp, #0x30
0x00004184  adrp     x0, #0x28000
0x00004188  add      x0, x0, #0xe7a   ; -> "@rpath/libroot.dylib"
0x0000418c  mov      w1, #2
0x00004190  bl       #0x245e4   ; call _dlopen
0x00004194  adrp     x24, #0x3e000
0x00004198  adrp     x23, #0x3e000
0x0000419c  adrp     x22, #0x3e000
0x000041a0  adrp     x21, #0x3e000
0x000041a4  adrp     x20, #0x3e000
0x000041a8  cbz      x0, #0x4210
0x000041ac  mov      x19, x0
0x000041b0  adrp     x1, #0x28000
0x000041b4  add      x1, x1, #0xe8f   ; -> "libroot_get_root_prefix"
0x000041b8  bl       #0x245f0   ; call _dlsym
0x000041bc  str      x0, [x24, #0x900]
0x000041c0  adrp     x1, #0x28000
0x000041c4  add      x1, x1, #0xea7   ; -> "libroot_get_jbroot_prefix"
0x000041c8  mov      x0, x19
0x000041cc  bl       #0x245f0   ; call _dlsym
0x000041d0  str      x0, [x23, #0x908]
0x000041d4  adrp     x1, #0x28000
0x000041d8  add      x1, x1, #0xec1   ; -> "libroot_get_boot_uuid"
0x000041dc  mov      x0, x19
0x000041e0  bl       #0x245f0   ; call _dlsym
0x000041e4  str      x0, [x22, #0x910]
0x000041e8  adrp     x1, #0x28000
0x000041ec  add      x1, x1, #0xed7   ; -> "libroot_jbrootpath"
0x000041f0  mov      x0, x19
0x000041f4  bl       #0x245f0   ; call _dlsym
0x000041f8  str      x0, [x21, #0x920]
0x000041fc  adrp     x1, #0x28000
0x00004200  add      x1, x1, #0xeea   ; -> "libroot_rootfspath"
0x00004204  mov      x0, x19
0x00004208  bl       #0x245f0   ; call _dlsym
0x0000420c  str      x0, [x20, #0x918]
0x00004210  ldr      x8, [x24, #0x900]
0x00004214  cbz      x8, #0x424c
0x00004218  ldr      x8, [x23, #0x908]
0x0000421c  cbz      x8, #0x4260
0x00004220  ldr      x8, [x22, #0x910]
0x00004224  cbz      x8, #0x4274
0x00004228  ldr      x8, [x21, #0x920]
0x0000422c  cbz      x8, #0x4288
0x00004230  ldr      x8, [x20, #0x918]
0x00004234  cbz      x8, #0x429c
0x00004238  ldp      x29, x30, [sp, #0x30]
0x0000423c  ldp      x20, x19, [sp, #0x20]
0x00004240  ldp      x22, x21, [sp, #0x10]
0x00004244  ldp      x24, x23, [sp], #0x40
0x00004248  ret      
0x0000424c  adrp     x8, #0x4000
0x00004250  add      x8, x8, #0x2ac
0x00004254  str      x8, [x24, #0x900]
0x00004258  ldr      x8, [x23, #0x908]
0x0000425c  cbnz     x8, #0x4220
0x00004260  adrp     x8, #0x4000
0x00004264  add      x8, x8, #0x2b8
0x00004268  str      x8, [x23, #0x908]
0x0000426c  ldr      x8, [x22, #0x910]
0x00004270  cbnz     x8, #0x4228
0x00004274  adrp     x8, #0x4000
0x00004278  add      x8, x8, #0x2c4
0x0000427c  str      x8, [x22, #0x910]
0x00004280  ldr      x8, [x21, #0x920]
0x00004284  cbnz     x8, #0x4230
0x00004288  adrp     x8, #0x4000
0x0000428c  add      x8, x8, #0x2d0
0x00004290  str      x8, [x21, #0x920]
0x00004294  ldr      x8, [x20, #0x918]
0x00004298  cbnz     x8, #0x4238
0x0000429c  adrp     x8, #0x4000
0x000042a0  add      x8, x8, #0x384
0x000042a4  str      x8, [x20, #0x918]
0x000042a8  b        #0x4238   ; call sub_4238
0x000042ac  adrp     x0, #0x28000
0x000042b0  add      x0, x0, #0xefd
0x000042b4  ret      
0x000042b8  adrp     x0, #0x28000
0x000042bc  add      x0, x0, #0xefe   ; -> "/var/jb"
0x000042c0  ret      
0x000042c4  adrp     x0, #0x28000
0x000042c8  add      x0, x0, #0xf06   ; -> "00000000-0000-0000-0000-000000000000"
0x000042cc  ret      
0x000042d0  stp      x20, x19, [sp, #-0x20]!
0x000042d4  stp      x29, x30, [sp, #0x10]
0x000042d8  add      x29, sp, #0x10
0x000042dc  cbz      x0, #0x4344
0x000042e0  mov      x19, x1
0x000042e4  mov      x20, x0
0x000042e8  cbnz     x1, #0x42f8
0x000042ec  mov      w0, #0x400
0x000042f0  bl       #0x246bc   ; call _malloc
0x000042f4  mov      x19, x0
0x000042f8  adrp     x8, #0x3e000
0x000042fc  ldr      x8, [x8, #0x928]
0x00004300  cmn      x8, #1
0x00004304  b.ne     #0x436c
0x00004308  adrp     x8, #0x3e000
0x0000430c  ldr      x8, [x8, #0x908]
0x00004310  blr      x8   ; indirect call
0x00004314  ldrb     w8, [x20]
0x00004318  cmp      w8, #0x2f
0x0000431c  b.ne     #0x434c
0x00004320  mov      x1, x0
0x00004324  mov      x0, x19
0x00004328  mov      w2, #0x400
0x0000432c  bl       #0x24944   ; call _strlcpy
0x00004330  mov      x0, x19
0x00004334  mov      x1, x20
0x00004338  mov      w2, #0x400
0x0000433c  bl       #0x24938   ; call _strlcat
0x00004340  b        #0x435c   ; call sub_435c
0x00004344  mov      x19, #0
0x00004348  b        #0x435c   ; call sub_435c
0x0000434c  mov      x0, x19
0x00004350  mov      x1, x20
0x00004354  mov      w2, #0x400
0x00004358  bl       #0x24944   ; call _strlcpy
0x0000435c  mov      x0, x19
0x00004360  ldp      x29, x30, [sp, #0x10]
0x00004364  ldp      x20, x19, [sp], #0x20
0x00004368  ret      
0x0000436c  adrp     x0, #0x3e000
0x00004370  add      x0, x0, #0x928
0x00004374  adrp     x1, #0x34000
0x00004378  add      x1, x1, #0x5c0
0x0000437c  bl       #0x24578   ; call _dispatch_once
0x00004380  b        #0x4308   ; call sub_4308
0x00004384  stp      x24, x23, [sp, #-0x40]!
0x00004388  stp      x22, x21, [sp, #0x10]
0x0000438c  stp      x20, x19, [sp, #0x20]
0x00004390  stp      x29, x30, [sp, #0x30]
0x00004394  add      x29, sp, #0x30
0x00004398  cbz      x0, #0x443c
0x0000439c  mov      x19, x1
0x000043a0  mov      x20, x0
0x000043a4  cbnz     x1, #0x43b4
0x000043a8  mov      w0, #0x400
0x000043ac  bl       #0x246bc   ; call _malloc
0x000043b0  mov      x19, x0
0x000043b4  adrp     x22, #0x3e000
0x000043b8  ldr      x8, [x22, #0x928]
0x000043bc  cmn      x8, #1
0x000043c0  b.ne     #0x4478
0x000043c4  adrp     x8, #0x3e000
0x000043c8  ldr      x8, [x8, #0x900]
0x000043cc  blr      x8   ; indirect call
0x000043d0  mov      x21, x0
0x000043d4  ldr      x8, [x22, #0x928]
0x000043d8  cmn      x8, #1
0x000043dc  b.ne     #0x4490
0x000043e0  adrp     x8, #0x3e000
0x000043e4  ldr      x8, [x8, #0x908]
0x000043e8  blr      x8   ; indirect call
0x000043ec  mov      x23, x0
0x000043f0  bl       #0x24950   ; call _strlen
0x000043f4  ldrb     w8, [x20]
0x000043f8  cmp      w8, #0x2f
0x000043fc  b.ne     #0x4444
0x00004400  mov      x22, x0
0x00004404  mov      x0, x20
0x00004408  mov      x1, x23
0x0000440c  mov      x2, x22
0x00004410  bl       #0x2495c   ; call _strncmp
0x00004414  cbz      w0, #0x4450
0x00004418  mov      x0, x19
0x0000441c  mov      x1, x21
0x00004420  mov      w2, #0x400
0x00004424  bl       #0x24944   ; call _strlcpy
0x00004428  mov      x0, x19
0x0000442c  mov      x1, x20
0x00004430  mov      w2, #0x400
0x00004434  bl       #0x24938   ; call _strlcat
0x00004438  b        #0x4460   ; call sub_4460
0x0000443c  mov      x19, #0
0x00004440  b        #0x4460   ; call sub_4460
0x00004444  mov      x0, x19
0x00004448  mov      x1, x20
0x0000444c  b        #0x4458   ; call sub_4458
0x00004450  add      x1, x20, x22
0x00004454  mov      x0, x19
0x00004458  mov      w2, #0x400
0x0000445c  bl       #0x24944   ; call _strlcpy
0x00004460  mov      x0, x19
0x00004464  ldp      x29, x30, [sp, #0x30]
0x00004468  ldp      x20, x19, [sp, #0x20]
0x0000446c  ldp      x22, x21, [sp, #0x10]
0x00004470  ldp      x24, x23, [sp], #0x40
0x00004474  ret      
0x00004478  adrp     x0, #0x3e000
0x0000447c  add      x0, x0, #0x928
0x00004480  adrp     x1, #0x34000
0x00004484  add      x1, x1, #0x5c0
0x00004488  bl       #0x24578   ; call _dispatch_once
0x0000448c  b        #0x43c4   ; call sub_43c4
0x00004490  adrp     x0, #0x3e000
0x00004494  add      x0, x0, #0x928
0x00004498  adrp     x1, #0x34000
0x0000449c  add      x1, x1, #0x5c0
0x000044a0  bl       #0x24578   ; call _dispatch_once
0x000044a4  b        #0x43e0   ; call sub_43e0

