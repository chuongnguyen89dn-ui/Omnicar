=== sub_4170  va=0x4170 size=824 types=
; data refs: __DATA_CONST,__const@0x746d0
0x00004170  stp      x24, x23, [sp, #-0x40]!
0x00004174  stp      x22, x21, [sp, #0x10]
0x00004178  stp      x20, x19, [sp, #0x20]
0x0000417c  stp      x29, x30, [sp, #0x30]
0x00004180  add      x29, sp, #0x30
0x00004184  adrp     x0, #0x61000
0x00004188  add      x0, x0, #0xee   ; CSTR "@rpath/libroot.dylib"
0x0000418c  mov      w1, #2
0x00004190  bl       #0x55c34   ; CALL _dlopen
0x00004194  adrp     x24, #0x8f000
0x00004198  adrp     x23, #0x8f000
0x0000419c  adrp     x22, #0x8f000
0x000041a0  adrp     x21, #0x8f000
0x000041a4  adrp     x20, #0x8f000
0x000041a8  cbz      x0, #0x4210
0x000041ac  mov      x19, x0
0x000041b0  adrp     x1, #0x61000
0x000041b4  add      x1, x1, #0x103   ; CSTR "libroot_get_root_prefix"
0x000041b8  bl       #0x55c40   ; CALL _dlsym
0x000041bc  str      x0, [x24, #0xfc8]
0x000041c0  adrp     x1, #0x61000
0x000041c4  add      x1, x1, #0x11b   ; CSTR "libroot_get_jbroot_prefix"
0x000041c8  mov      x0, x19
0x000041cc  bl       #0x55c40   ; CALL _dlsym
0x000041d0  str      x0, [x23, #0xfd0]
0x000041d4  adrp     x1, #0x61000
0x000041d8  add      x1, x1, #0x135   ; CSTR "libroot_get_boot_uuid"
0x000041dc  mov      x0, x19
0x000041e0  bl       #0x55c40   ; CALL _dlsym
0x000041e4  str      x0, [x22, #0xfd8]
0x000041e8  adrp     x1, #0x61000
0x000041ec  add      x1, x1, #0x14b   ; CSTR "libroot_jbrootpath"
0x000041f0  mov      x0, x19
0x000041f4  bl       #0x55c40   ; CALL _dlsym
0x000041f8  str      x0, [x21, #0xfe8]
0x000041fc  adrp     x1, #0x61000
0x00004200  add      x1, x1, #0x15e   ; CSTR "libroot_rootfspath"
0x00004204  mov      x0, x19
0x00004208  bl       #0x55c40   ; CALL _dlsym
0x0000420c  str      x0, [x20, #0xfe0]
0x00004210  ldr      x8, [x24, #0xfc8]
0x00004214  cbz      x8, #0x424c
0x00004218  ldr      x8, [x23, #0xfd0]
0x0000421c  cbz      x8, #0x4260
0x00004220  ldr      x8, [x22, #0xfd8]
0x00004224  cbz      x8, #0x4274
0x00004228  ldr      x8, [x21, #0xfe8]
0x0000422c  cbz      x8, #0x4288
0x00004230  ldr      x8, [x20, #0xfe0]
0x00004234  cbz      x8, #0x429c
0x00004238  ldp      x29, x30, [sp, #0x30]
0x0000423c  ldp      x20, x19, [sp, #0x20]
0x00004240  ldp      x22, x21, [sp, #0x10]
0x00004244  ldp      x24, x23, [sp], #0x40
0x00004248  ret      
0x0000424c  adrp     x8, #0x4000
0x00004250  add      x8, x8, #0x2ac
0x00004254  str      x8, [x24, #0xfc8]
0x00004258  ldr      x8, [x23, #0xfd0]
0x0000425c  cbnz     x8, #0x4220
0x00004260  adrp     x8, #0x4000
0x00004264  add      x8, x8, #0x2b8
0x00004268  str      x8, [x23, #0xfd0]
0x0000426c  ldr      x8, [x22, #0xfd8]
0x00004270  cbnz     x8, #0x4228
0x00004274  adrp     x8, #0x4000
0x00004278  add      x8, x8, #0x2c4
0x0000427c  str      x8, [x22, #0xfd8]
0x00004280  ldr      x8, [x21, #0xfe8]
0x00004284  cbnz     x8, #0x4230
0x00004288  adrp     x8, #0x4000
0x0000428c  add      x8, x8, #0x2d0
0x00004290  str      x8, [x21, #0xfe8]
0x00004294  ldr      x8, [x20, #0xfe0]
0x00004298  cbnz     x8, #0x4238
0x0000429c  adrp     x8, #0x4000
0x000042a0  add      x8, x8, #0x384
0x000042a4  str      x8, [x20, #0xfe0]
0x000042a8  b        #0x4238
0x000042ac  adrp     x0, #0x61000
0x000042b0  add      x0, x0, #0x171
0x000042b4  ret      
0x000042b8  adrp     x0, #0x61000
0x000042bc  add      x0, x0, #0x172   ; CSTR "/var/jb"
0x000042c0  ret      
0x000042c4  adrp     x0, #0x61000
0x000042c8  add      x0, x0, #0x17a   ; CSTR "00000000-0000-0000-0000-000000000000"
0x000042cc  ret      
0x000042d0  stp      x20, x19, [sp, #-0x20]!
0x000042d4  stp      x29, x30, [sp, #0x10]
0x000042d8  add      x29, sp, #0x10
0x000042dc  cbz      x0, #0x4344
0x000042e0  mov      x19, x1
0x000042e4  mov      x20, x0
0x000042e8  cbnz     x1, #0x42f8
0x000042ec  mov      w0, #0x400
0x000042f0  bl       #0x55c64   ; CALL _malloc
0x000042f4  mov      x19, x0
0x000042f8  adrp     x8, #0x8f000
0x000042fc  ldr      x8, [x8, #0xff0]
0x00004300  cmn      x8, #1
0x00004304  b.ne     #0x436c
0x00004308  adrp     x8, #0x8f000
0x0000430c  ldr      x8, [x8, #0xfd0]
0x00004310  blr      x8
0x00004314  ldrb     w8, [x20]
0x00004318  cmp      w8, #0x2f
0x0000431c  b.ne     #0x434c
0x00004320  mov      x1, x0
0x00004324  mov      x0, x19
0x00004328  mov      w2, #0x400
0x0000432c  bl       #0x55e38   ; CALL _strlcpy
0x00004330  mov      x0, x19
0x00004334  mov      x1, x20
0x00004338  mov      w2, #0x400
0x0000433c  bl       #0x55e2c   ; CALL _strlcat
0x00004340  b        #0x435c
0x00004344  mov      x19, #0
0x00004348  b        #0x435c
0x0000434c  mov      x0, x19
0x00004350  mov      x1, x20
0x00004354  mov      w2, #0x400
0x00004358  bl       #0x55e38   ; CALL _strlcpy
0x0000435c  mov      x0, x19
0x00004360  ldp      x29, x30, [sp, #0x10]
0x00004364  ldp      x20, x19, [sp], #0x20
0x00004368  ret      
0x0000436c  adrp     x0, #0x8f000
0x00004370  add      x0, x0, #0xff0
0x00004374  adrp     x1, #0x74000
0x00004378  add      x1, x1, #0x6c0
0x0000437c  bl       #0x55bf8   ; CALL _dispatch_once
0x00004380  b        #0x4308
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
0x000043ac  bl       #0x55c64   ; CALL _malloc
0x000043b0  mov      x19, x0
0x000043b4  adrp     x22, #0x8f000
0x000043b8  ldr      x8, [x22, #0xff0]
0x000043bc  cmn      x8, #1
0x000043c0  b.ne     #0x4478
0x000043c4  adrp     x8, #0x8f000
0x000043c8  ldr      x8, [x8, #0xfc8]
0x000043cc  blr      x8
0x000043d0  mov      x21, x0
0x000043d4  ldr      x8, [x22, #0xff0]
0x000043d8  cmn      x8, #1
0x000043dc  b.ne     #0x4490
0x000043e0  adrp     x8, #0x8f000
0x000043e4  ldr      x8, [x8, #0xfd0]
0x000043e8  blr      x8
0x000043ec  mov      x23, x0
0x000043f0  bl       #0x55e44   ; CALL _strlen
0x000043f4  ldrb     w8, [x20]
0x000043f8  cmp      w8, #0x2f
0x000043fc  b.ne     #0x4444
0x00004400  mov      x22, x0
0x00004404  mov      x0, x20
0x00004408  mov      x1, x23
0x0000440c  mov      x2, x22
0x00004410  bl       #0x55e50   ; CALL _strncmp
0x00004414  cbz      w0, #0x4450
0x00004418  mov      x0, x19
0x0000441c  mov      x1, x21
0x00004420  mov      w2, #0x400
0x00004424  bl       #0x55e38   ; CALL _strlcpy
0x00004428  mov      x0, x19
0x0000442c  mov      x1, x20
0x00004430  mov      w2, #0x400
0x00004434  bl       #0x55e2c   ; CALL _strlcat
0x00004438  b        #0x4460
0x0000443c  mov      x19, #0
0x00004440  b        #0x4460
0x00004444  mov      x0, x19
0x00004448  mov      x1, x20
0x0000444c  b        #0x4458
0x00004450  add      x1, x20, x22
0x00004454  mov      x0, x19
0x00004458  mov      w2, #0x400
0x0000445c  bl       #0x55e38   ; CALL _strlcpy
0x00004460  mov      x0, x19
0x00004464  ldp      x29, x30, [sp, #0x30]
0x00004468  ldp      x20, x19, [sp, #0x20]
0x0000446c  ldp      x22, x21, [sp, #0x10]
0x00004470  ldp      x24, x23, [sp], #0x40
0x00004474  ret      
0x00004478  adrp     x0, #0x8f000
0x0000447c  add      x0, x0, #0xff0
0x00004480  adrp     x1, #0x74000
0x00004484  add      x1, x1, #0x6c0
0x00004488  bl       #0x55bf8   ; CALL _dispatch_once
0x0000448c  b        #0x43c4
0x00004490  adrp     x0, #0x8f000
0x00004494  add      x0, x0, #0xff0
0x00004498  adrp     x1, #0x74000
0x0000449c  add      x1, x1, #0x6c0
0x000044a0  bl       #0x55bf8   ; CALL _dispatch_once
0x000044a4  b        #0x43e0

=== sub_5718  va=0x5718 size=8 types=
; data refs: __DATA_CONST,__const@0x746f0, __DATA_CONST,__const@0x74720, __DATA_CONST,__const@0x74750, __DATA_CONST,__const@0x74900, __DATA_CONST,__const@0x749c0, __DATA_CONST,__const@0x74a20, __DATA_CONST,__const@0x74a50, __DATA_CONST,__const@0x74b10, __DATA_CONST,__const@0x74c10, __DATA_CONST,__const@0x74c40, __DATA_CONST,__const@0x74cb8, __DATA_CONST,__const@0x74e58, __DATA_CONST,__const@0x74e88
0x00005718  ldr      x0, [x1, #0x20]
0x0000571c  b        #0x55d84   ; CALL _objc_retain

=== sub_5720  va=0x5720 size=16 types=
; data refs: __DATA_CONST,__const@0x746f8, __DATA_CONST,__const@0x74728, __DATA_CONST,__const@0x74758, __DATA_CONST,__const@0x74908, __DATA_CONST,__const@0x749c8, __DATA_CONST,__const@0x74a28, __DATA_CONST,__const@0x74a58, __DATA_CONST,__const@0x74b18, __DATA_CONST,__const@0x74c18, __DATA_CONST,__const@0x74c48, __DATA_CONST,__const@0x74cc0, __DATA_CONST,__const@0x74e60, __DATA_CONST,__const@0x74e90, __DATA_CONST,__const@0x74ec0
0x00005720  ldr      x0, [x0, #0x20]
0x00005724  b        #0x55d78   ; CALL _objc_release
0x00005728  ldr      x0, [x0, #0x20]
0x0000572c  b        #0x59e00   ; CALL objc_msgSend$removeFromSuperview

=== sub_10b60  va=0x10b60 size=420 types=
; data refs: __DATA_CONST,__const@0x747a0
0x00010b60  stp      x22, x21, [sp, #-0x30]!
0x00010b64  stp      x20, x19, [sp, #0x10]
0x00010b68  stp      x29, x30, [sp, #0x20]
0x00010b6c  add      x29, sp, #0x20
0x00010b70  mov      x19, x2
0x00010b74  mov      x20, x1
0x00010b78  mov      x0, x2
0x00010b7c  bl       #0x55d84   ; CALL _objc_retain
0x00010b80  adrp     x21, #0x75000
0x00010b84  add      x21, x21, #0x3e8   ; STR "id"
0x00010b88  mov      x0, x20
0x00010b8c  mov      x2, x21
0x00010b90  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00010b94  mov      x29, x29
0x00010b98  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010b9c  mov      x20, x0
0x00010ba0  mov      x0, x19
0x00010ba4  mov      x2, x21
0x00010ba8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00010bac  mov      x29, x29
0x00010bb0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010bb4  mov      x21, x0
0x00010bb8  mov      x0, x19
0x00010bbc  bl       #0x55d78   ; CALL _objc_release
0x00010bc0  mov      x0, x20
0x00010bc4  mov      x2, x21
0x00010bc8  bl       #0x56f60   ; CALL objc_msgSend$compare:
0x00010bcc  mov      x19, x0
0x00010bd0  mov      x0, x21
0x00010bd4  bl       #0x55d78   ; CALL _objc_release
0x00010bd8  mov      x0, x20
0x00010bdc  bl       #0x55d78   ; CALL _objc_release
0x00010be0  mov      x0, x19
0x00010be4  ldp      x29, x30, [sp, #0x20]
0x00010be8  ldp      x20, x19, [sp, #0x10]
0x00010bec  ldp      x22, x21, [sp], #0x30
0x00010bf0  ret      
0x00010bf4  sub      sp, sp, #0x60
0x00010bf8  stp      x24, x23, [sp, #0x20]
0x00010bfc  stp      x22, x21, [sp, #0x30]
0x00010c00  stp      x20, x19, [sp, #0x40]
0x00010c04  stp      x29, x30, [sp, #0x50]
0x00010c08  add      x29, sp, #0x50
0x00010c0c  mov      x19, x2
0x00010c10  mov      x21, x1
0x00010c14  mov      x20, x0
0x00010c18  mov      x0, x2
0x00010c1c  bl       #0x55d84   ; CALL _objc_retain
0x00010c20  adrp     x23, #0x8e000
0x00010c24  ldr      x22, [x23, #0x958]   ; @CLASS NSString
0x00010c28  mov      x0, x21
0x00010c2c  bl       #0x55d84   ; CALL _objc_retain
0x00010c30  mov      x0, x20
0x00010c34  bl       #0x55d84   ; CALL _objc_retain
0x00010c38  mov      x0, x22
0x00010c3c  mov      x2, x19
0x00010c40  mov      w3, #4
0x00010c44  mov      x4, #0
0x00010c48  bl       #0x5d560   ; CALL objc_msgSend$stringWithContentsOfFile:encoding:error:
0x00010c4c  mov      x29, x29
0x00010c50  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010c54  mov      x22, x0
0x00010c58  cbnz     x0, #0x10ca0
0x00010c5c  ldr      x0, [x23, #0x958]   ; @CLASS NSString
0x00010c60  bl       #0x55c7c   ; CALL _objc_alloc
0x00010c64  mov      x22, x0
0x00010c68  adrp     x8, #0x8e000
0x00010c6c  ldr      x0, [x8, #0x9e8]   ; @CLASS NSData
0x00010c70  mov      x2, x19
0x00010c74  bl       #0x57560   ; CALL objc_msgSend$dataWithContentsOfFile:
0x00010c78  mov      x29, x29
0x00010c7c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00010c80  mov      x23, x0
0x00010c84  mov      x0, x22
0x00010c88  mov      x2, x23
0x00010c8c  mov      w3, #5
0x00010c90  bl       #0x583e0   ; CALL objc_msgSend$initWithData:encoding:
0x00010c94  mov      x22, x0
0x00010c98  mov      x0, x23
0x00010c9c  bl       #0x55d78   ; CALL _objc_release
0x00010ca0  mov      x0, x22
0x00010ca4  bl       #0x58c20   ; CALL objc_msgSend$length
0x00010ca8  adrp     x8, #0x78000
0x00010cac  add      x8, x8, #0x1e8   ; STR "(empty / not found)"
0x00010cb0  cmp      x0, #0
0x00010cb4  csel     x8, x8, x22, eq
0x00010cb8  stp      x19, x8, [sp, #8]
0x00010cbc  str      x21, [sp]
0x00010cc0  adrp     x2, #0x78000
0x00010cc4  add      x2, x2, #0x1c8   ; STR "\n==== %@ (%@) ====\n%@\n"
0x00010cc8  mov      x0, x20
0x00010ccc  bl       #0x56460   ; CALL objc_msgSend$appendFormat:
0x00010cd0  mov      x0, x21
0x00010cd4  bl       #0x55d78   ; CALL _objc_release
0x00010cd8  mov      x0, x20
0x00010cdc  bl       #0x55d78   ; CALL _objc_release
0x00010ce0  mov      x0, x22
0x00010ce4  bl       #0x55d78   ; CALL _objc_release
0x00010ce8  mov      x0, x19
0x00010cec  ldp      x29, x30, [sp, #0x50]
0x00010cf0  ldp      x20, x19, [sp, #0x40]
0x00010cf4  ldp      x22, x21, [sp, #0x30]
0x00010cf8  ldp      x24, x23, [sp, #0x20]
0x00010cfc  add      sp, sp, #0x60
0x00010d00  b        #0x55d78   ; CALL _objc_release

=== sub_1646c  va=0x1646c size=352 types=
; data refs: __DATA_CONST,__const@0x747e0
0x0001646c  stp      x26, x25, [sp, #-0x50]!
0x00016470  stp      x24, x23, [sp, #0x10]
0x00016474  stp      x22, x21, [sp, #0x20]
0x00016478  stp      x20, x19, [sp, #0x30]
0x0001647c  stp      x29, x30, [sp, #0x40]
0x00016480  add      x29, sp, #0x40
0x00016484  mov      x20, x2
0x00016488  mov      x19, x1
0x0001648c  mov      x0, x1
0x00016490  bl       #0x55d84   ; CALL _objc_retain
0x00016494  mov      x0, x20
0x00016498  bl       #0x55d84   ; CALL _objc_retain
0x0001649c  adrp     x21, #0x76000
0x000164a0  add      x21, x21, #0x548   ; STR "info"
0x000164a4  mov      x0, x19
0x000164a8  mov      x2, x21
0x000164ac  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000164b0  mov      x29, x29
0x000164b4  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000164b8  mov      x22, x0
0x000164bc  adrp     x23, #0x78000
0x000164c0  add      x23, x23, #0x748   ; STR "featureOrder"
0x000164c4  mov      x2, x23
0x000164c8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000164cc  mov      x29, x29
0x000164d0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000164d4  mov      x24, x0
0x000164d8  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x000164dc  mov      x25, x0
0x000164e0  mov      x0, x24
0x000164e4  bl       #0x55d78   ; CALL _objc_release
0x000164e8  mov      x0, x22
0x000164ec  bl       #0x55d78   ; CALL _objc_release
0x000164f0  mov      x0, x20
0x000164f4  mov      x2, x21
0x000164f8  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x000164fc  mov      x29, x29
0x00016500  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016504  mov      x21, x0
0x00016508  mov      x2, x23
0x0001650c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00016510  mov      x29, x29
0x00016514  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016518  mov      x22, x0
0x0001651c  bl       #0x58720   ; CALL objc_msgSend$integerValue
0x00016520  mov      x23, x0
0x00016524  mov      x0, x22
0x00016528  bl       #0x55d78   ; CALL _objc_release
0x0001652c  mov      x0, x21
0x00016530  bl       #0x55d78   ; CALL _objc_release
0x00016534  cmp      x25, x23
0x00016538  b.ne     #0x16598
0x0001653c  adrp     x21, #0x76000
0x00016540  add      x21, x21, #0xf48   ; STR "plist"
0x00016544  mov      x0, x19
0x00016548  mov      x2, x21
0x0001654c  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00016550  mov      x29, x29
0x00016554  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016558  mov      x22, x0
0x0001655c  mov      x0, x20
0x00016560  mov      x2, x21
0x00016564  bl       #0x593c0   ; CALL objc_msgSend$objectForKeyedSubscript:
0x00016568  mov      x29, x29
0x0001656c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00016570  mov      x23, x0
0x00016574  mov      x0, x22
0x00016578  mov      x2, x23
0x0001657c  bl       #0x56f60   ; CALL objc_msgSend$compare:
0x00016580  mov      x21, x0
0x00016584  mov      x0, x23
0x00016588  bl       #0x55d78   ; CALL _objc_release
0x0001658c  mov      x0, x22
0x00016590  bl       #0x55d78   ; CALL _objc_release
0x00016594  b        #0x165a0
0x00016598  mov      x8, #-1
0x0001659c  cneg     x21, x8, ge
0x000165a0  mov      x0, x20
0x000165a4  bl       #0x55d78   ; CALL _objc_release
0x000165a8  mov      x0, x19
0x000165ac  bl       #0x55d78   ; CALL _objc_release
0x000165b0  mov      x0, x21
0x000165b4  ldp      x29, x30, [sp, #0x40]
0x000165b8  ldp      x20, x19, [sp, #0x30]
0x000165bc  ldp      x22, x21, [sp, #0x20]
0x000165c0  ldp      x24, x23, [sp, #0x10]
0x000165c4  ldp      x26, x25, [sp], #0x50
0x000165c8  ret      

=== sub_16efc  va=0x16efc size=48 types=
; data refs: __DATA_CONST,__const@0x74800
0x00016efc  stp      x20, x19, [sp, #-0x20]!
0x00016f00  stp      x29, x30, [sp, #0x10]
0x00016f04  add      x29, sp, #0x10
0x00016f08  mov      x19, x1
0x00016f0c  mov      x20, x0
0x00016f10  ldr      x0, [x1, #0x20]
0x00016f14  bl       #0x55d84   ; CALL _objc_retain
0x00016f18  add      x0, x20, #0x28
0x00016f1c  add      x1, x19, #0x28
0x00016f20  ldp      x29, x30, [sp, #0x10]
0x00016f24  ldp      x20, x19, [sp], #0x20
0x00016f28  b        #0x55cd0   ; CALL _objc_copyWeak

=== sub_16f2c  va=0x16f2c size=40 types=
; data refs: __DATA_CONST,__const@0x74808
0x00016f2c  stp      x20, x19, [sp, #-0x20]!
0x00016f30  stp      x29, x30, [sp, #0x10]
0x00016f34  add      x29, sp, #0x10
0x00016f38  mov      x19, x0
0x00016f3c  add      x0, x0, #0x28
0x00016f40  bl       #0x55cdc   ; CALL _objc_destroyWeak
0x00016f44  ldr      x0, [x19, #0x20]
0x00016f48  ldp      x29, x30, [sp, #0x10]
0x00016f4c  ldp      x20, x19, [sp], #0x20
0x00016f50  b        #0x55d78   ; CALL _objc_release

=== sub_17640  va=0x17640 size=12 types=
; data refs: __DATA_CONST,__const@0x74830, __DATA_CONST,__const@0x74860, __DATA_CONST,__const@0x74b60
0x00017640  add      x0, x0, #0x20
0x00017644  add      x1, x1, #0x20
0x00017648  b        #0x55cd0   ; CALL _objc_copyWeak

=== sub_1764c  va=0x1764c size=8 types=
; data refs: __DATA_CONST,__const@0x74838, __DATA_CONST,__const@0x74868, __DATA_CONST,__const@0x74b68
0x0001764c  add      x0, x0, #0x20
0x00017650  b        #0x55cdc   ; CALL _objc_destroyWeak

=== sub_1800c  va=0x1800c size=116 types=
; data refs: __DATA_CONST,__const@0x748b0
0x0001800c  stp      x29, x30, [sp, #-0x10]!
0x00018010  mov      x29, sp
0x00018014  mov      x0, x1
0x00018018  bl       #0x5de60   ; CALL objc_msgSend$userInterfaceStyle
0x0001801c  mov      x8, x0
0x00018020  adrp     x9, #0x8e000
0x00018024  ldr      x0, [x9, #0x910]   ; @CLASS UIColor
0x00018028  cmp      x8, #2
0x0001802c  b.ne     #0x18060
0x00018030  adrp     x8, #0x65000
0x00018034  ldr      d0, [x8, #0x698]
0x00018038  adrp     x8, #0x65000
0x0001803c  ldr      d1, [x8, #0x6a0]
0x00018040  adrp     x8, #0x65000
0x00018044  ldr      d2, [x8, #0x6a8]
0x00018048  adrp     x8, #0x65000
0x0001804c  ldr      d3, [x8, #0x6b0]
0x00018050  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00018054  mov      x29, x29
0x00018058  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001805c  b        #0x18078
0x00018060  adrp     x8, #0x65000
0x00018064  ldr      d1, [x8, #0x690]
0x00018068  fmov     d0, #1.00000000
0x0001806c  bl       #0x56f00   ; CALL objc_msgSend$colorWithWhite:alpha:
0x00018070  mov      x29, x29
0x00018074  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00018078  ldp      x29, x30, [sp], #0x10
0x0001807c  b        #0x55cb8   ; CALL _objc_autoreleaseReturnValue

=== sub_187d8  va=0x187d8 size=40 types=
; data refs: __DATA_CONST,__const@0x748d0, __DATA_CONST,__const@0x74930, __DATA_CONST,__const@0x74c70, __DATA_CONST,__const@0x74ce8, __DATA_CONST,__const@0x74d18, __DATA_CONST,__const@0x74dd8, __DATA_CONST,__const@0x74e08
0x000187d8  stp      x20, x19, [sp, #-0x20]!
0x000187dc  stp      x29, x30, [sp, #0x10]
0x000187e0  add      x29, sp, #0x10
0x000187e4  mov      x19, x1
0x000187e8  ldr      x0, [x1, #0x20]
0x000187ec  bl       #0x55d84   ; CALL _objc_retain
0x000187f0  ldr      x0, [x19, #0x28]
0x000187f4  ldp      x29, x30, [sp, #0x10]
0x000187f8  ldp      x20, x19, [sp], #0x20
0x000187fc  b        #0x55d84   ; CALL _objc_retain

=== sub_18800  va=0x18800 size=40 types=
; data refs: __DATA_CONST,__const@0x748d8, __DATA_CONST,__const@0x74938, __DATA_CONST,__const@0x74c78, __DATA_CONST,__const@0x74cf0, __DATA_CONST,__const@0x74d20, __DATA_CONST,__const@0x74de0, __DATA_CONST,__const@0x74e10
0x00018800  stp      x20, x19, [sp, #-0x20]!
0x00018804  stp      x29, x30, [sp, #0x10]
0x00018808  add      x29, sp, #0x10
0x0001880c  mov      x19, x0
0x00018810  ldr      x0, [x0, #0x28]
0x00018814  bl       #0x55d78   ; CALL _objc_release
0x00018818  ldr      x0, [x19, #0x20]
0x0001881c  ldp      x29, x30, [sp, #0x10]
0x00018820  ldp      x20, x19, [sp], #0x20
0x00018824  b        #0x55d78   ; CALL _objc_release

=== sub_1df30  va=0x1df30 size=132 types=
; data refs: __DATA_CONST,__const@0x749a0
0x0001df30  stp      x22, x21, [sp, #-0x30]!
0x0001df34  stp      x20, x19, [sp, #0x10]
0x0001df38  stp      x29, x30, [sp, #0x20]
0x0001df3c  add      x29, sp, #0x20
0x0001df40  mov      x19, x2
0x0001df44  mov      x20, x1
0x0001df48  mov      x0, x2
0x0001df4c  bl       #0x55d84   ; CALL _objc_retain
0x0001df50  mov      x0, x20
0x0001df54  bl       #0x1c620
0x0001df58  mov      x29, x29
0x0001df5c  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001df60  mov      x20, x0
0x0001df64  mov      x0, x19
0x0001df68  bl       #0x1c620
0x0001df6c  mov      x29, x29
0x0001df70  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0001df74  mov      x21, x0
0x0001df78  mov      x0, x19
0x0001df7c  bl       #0x55d78   ; CALL _objc_release
0x0001df80  mov      x0, x20
0x0001df84  mov      x2, x21
0x0001df88  bl       #0x58d80   ; CALL objc_msgSend$localizedCaseInsensitiveCompare:
0x0001df8c  mov      x19, x0
0x0001df90  mov      x0, x21
0x0001df94  bl       #0x55d78   ; CALL _objc_release
0x0001df98  mov      x0, x20
0x0001df9c  bl       #0x55d78   ; CALL _objc_release
0x0001dfa0  mov      x0, x19
0x0001dfa4  ldp      x29, x30, [sp, #0x20]
0x0001dfa8  ldp      x20, x19, [sp, #0x10]
0x0001dfac  ldp      x22, x21, [sp], #0x30
0x0001dfb0  ret      

=== sub_1ee14  va=0x1ee14 size=48 types=
; data refs: __DATA_CONST,__const@0x749f0, __DATA_CONST,__const@0x74a80, __DATA_CONST,__const@0x74ae0
0x0001ee14  stp      x20, x19, [sp, #-0x20]!
0x0001ee18  stp      x29, x30, [sp, #0x10]
0x0001ee1c  add      x29, sp, #0x10
0x0001ee20  mov      x19, x1
0x0001ee24  ldr      x0, [x1, #0x20]
0x0001ee28  bl       #0x55d84   ; CALL _objc_retain
0x0001ee2c  ldr      x0, [x19, #0x28]
0x0001ee30  bl       #0x55d84   ; CALL _objc_retain
0x0001ee34  ldr      x0, [x19, #0x30]
0x0001ee38  ldp      x29, x30, [sp, #0x10]
0x0001ee3c  ldp      x20, x19, [sp], #0x20
0x0001ee40  b        #0x55d84   ; CALL _objc_retain

=== sub_1ee44  va=0x1ee44 size=48 types=
; data refs: __DATA_CONST,__const@0x749f8, __DATA_CONST,__const@0x74a88, __DATA_CONST,__const@0x74ae8, __DATA_CONST,__const@0x74d80
0x0001ee44  stp      x20, x19, [sp, #-0x20]!
0x0001ee48  stp      x29, x30, [sp, #0x10]
0x0001ee4c  add      x29, sp, #0x10
0x0001ee50  mov      x19, x0
0x0001ee54  ldr      x0, [x0, #0x30]
0x0001ee58  bl       #0x55d78   ; CALL _objc_release
0x0001ee5c  ldr      x0, [x19, #0x28]
0x0001ee60  bl       #0x55d78   ; CALL _objc_release
0x0001ee64  ldr      x0, [x19, #0x20]
0x0001ee68  ldp      x29, x30, [sp, #0x10]
0x0001ee6c  ldp      x20, x19, [sp], #0x20
0x0001ee70  b        #0x55d78   ; CALL _objc_release

=== sub_242ec  va=0x242ec size=56 types=
; data refs: __DATA_CONST,__const@0x74ab0, __DATA_CONST,__const@0x74d48
0x000242ec  stp      x20, x19, [sp, #-0x20]!
0x000242f0  stp      x29, x30, [sp, #0x10]
0x000242f4  add      x29, sp, #0x10
0x000242f8  mov      x19, x1
0x000242fc  ldr      x0, [x1, #0x20]
0x00024300  bl       #0x55d84   ; CALL _objc_retain
0x00024304  ldr      x0, [x19, #0x28]
0x00024308  bl       #0x55d84   ; CALL _objc_retain
0x0002430c  ldr      x0, [x19, #0x30]
0x00024310  bl       #0x55d84   ; CALL _objc_retain
0x00024314  ldr      x0, [x19, #0x38]
0x00024318  ldp      x29, x30, [sp, #0x10]
0x0002431c  ldp      x20, x19, [sp], #0x20
0x00024320  b        #0x55d84   ; CALL _objc_retain

=== sub_24324  va=0x24324 size=56 types=
; data refs: __DATA_CONST,__const@0x74ab8, __DATA_CONST,__const@0x74d50, __DATA_CONST,__const@0x74db0
0x00024324  stp      x20, x19, [sp, #-0x20]!
0x00024328  stp      x29, x30, [sp, #0x10]
0x0002432c  add      x29, sp, #0x10
0x00024330  mov      x19, x0
0x00024334  ldr      x0, [x0, #0x38]
0x00024338  bl       #0x55d78   ; CALL _objc_release
0x0002433c  ldr      x0, [x19, #0x30]
0x00024340  bl       #0x55d78   ; CALL _objc_release
0x00024344  ldr      x0, [x19, #0x28]
0x00024348  bl       #0x55d78   ; CALL _objc_release
0x0002434c  ldr      x0, [x19, #0x20]
0x00024350  ldp      x29, x30, [sp, #0x10]
0x00024354  ldp      x20, x19, [sp], #0x20
0x00024358  b        #0x55d78   ; CALL _objc_release

=== sub_41c44  va=0x41c44 size=60 types=
; data refs: __DATA_CONST,__const@0x74d78
0x00041c44  stp      x20, x19, [sp, #-0x20]!
0x00041c48  stp      x29, x30, [sp, #0x10]
0x00041c4c  add      x29, sp, #0x10
0x00041c50  mov      x19, x1
0x00041c54  mov      x20, x0
0x00041c58  ldr      x0, [x1, #0x20]
0x00041c5c  bl       #0x55d84   ; CALL _objc_retain
0x00041c60  ldr      x0, [x19, #0x28]
0x00041c64  bl       #0x55d84   ; CALL _objc_retain
0x00041c68  ldr      x1, [x19, #0x30]
0x00041c6c  add      x0, x20, #0x30
0x00041c70  mov      w2, #7
0x00041c74  ldp      x29, x30, [sp, #0x10]
0x00041c78  ldp      x20, x19, [sp], #0x20
0x00041c7c  b        #0x55b74   ; CALL __Block_object_assign

=== sub_41c80  va=0x41c80 size=68 types=
; data refs: __DATA_CONST,__const@0x74da8
0x00041c80  stp      x20, x19, [sp, #-0x20]!
0x00041c84  stp      x29, x30, [sp, #0x10]
0x00041c88  add      x29, sp, #0x10
0x00041c8c  mov      x19, x1
0x00041c90  mov      x20, x0
0x00041c94  ldr      x0, [x1, #0x20]
0x00041c98  bl       #0x55d84   ; CALL _objc_retain
0x00041c9c  ldr      x0, [x19, #0x28]
0x00041ca0  bl       #0x55d84   ; CALL _objc_retain
0x00041ca4  ldr      x0, [x19, #0x30]
0x00041ca8  bl       #0x55d84   ; CALL _objc_retain
0x00041cac  ldr      x1, [x19, #0x38]
0x00041cb0  add      x0, x20, #0x38
0x00041cb4  mov      w2, #7
0x00041cb8  ldp      x29, x30, [sp, #0x10]
0x00041cbc  ldp      x20, x19, [sp], #0x20
0x00041cc0  b        #0x55b74   ; CALL __Block_object_assign

=== sub_54984  va=0x54984 size=16 types=
; data refs: __DATA_CONST,__const@0x74eb8
0x00054984  ldr      x1, [x1, #0x20]
0x00054988  add      x0, x0, #0x20
0x0005498c  mov      w2, #7
0x00054990  b        #0x55b74   ; CALL __Block_object_assign

=== sub_54994  va=0x54994 size=252 types=
; data refs: __DATA_CONST,__const@0x74f08
0x00054994  sub      sp, sp, #0x90
0x00054998  stp      x22, x21, [sp, #0x60]
0x0005499c  stp      x20, x19, [sp, #0x70]
0x000549a0  stp      x29, x30, [sp, #0x80]
0x000549a4  add      x29, sp, #0x80
0x000549a8  mov      x19, x1
0x000549ac  adrp     x8, #0x74000
0x000549b0  ldr      x8, [x8, #0x398]   ; @GOT ___stack_chk_guard
0x000549b4  ldr      x8, [x8]   ; @GOT ___objc_personality_v0
0x000549b8  stur     x8, [x29, #-0x28]
0x000549bc  mov      x8, #0x4040000000000000
0x000549c0  fmov     d2, x8
0x000549c4  mov      x8, #0x4044000000000000
0x000549c8  fmov     d3, x8
0x000549cc  fmov     d0, xzr
0x000549d0  fmov     d1, xzr
0x000549d4  mov      x0, x1
0x000549d8  bl       #0x558f8   ; CALL _CGContextAddEllipseInRect
0x000549dc  mov      x0, x19
0x000549e0  bl       #0x55904   ; CALL _CGContextClip
0x000549e4  bl       #0x558d4   ; CALL _CGColorSpaceCreateDeviceRGB
0x000549e8  mov      x20, x0
0x000549ec  adrp     x8, #0x66000
0x000549f0  add      x8, x8, #0x430
0x000549f4  ldp      q0, q1, [x8]
0x000549f8  stp      q0, q1, [sp, #0x10]
0x000549fc  ldp      q0, q1, [x8, #0x20]
0x00054a00  stp      q0, q1, [sp, #0x30]
0x00054a04  adrp     x8, #0x65000
0x00054a08  add      x8, x8, #0x940
0x00054a0c  ldr      q0, [x8]
0x00054a10  str      q0, [sp]
0x00054a14  add      x1, sp, #0x10
0x00054a18  mov      x2, sp
0x00054a1c  mov      w3, #2
0x00054a20  bl       #0x559d0   ; CALL _CGGradientCreateWithColorComponents
0x00054a24  mov      x21, x0
0x00054a28  fmov     d0, #11.00000000
0x00054a2c  fmov     d1, #14.00000000
0x00054a30  fmov     d2, xzr
0x00054a34  fmov     d3, #16.00000000
0x00054a38  fmov     d4, #20.00000000
0x00054a3c  fmov     d5, #22.00000000
0x00054a40  mov      x0, x19
0x00054a44  mov      x1, x21
0x00054a48  mov      w2, #2
0x00054a4c  bl       #0x55928   ; CALL _CGContextDrawRadialGradient
0x00054a50  mov      x0, x21
0x00054a54  bl       #0x559e8   ; CALL _CGGradientRelease
0x00054a58  mov      x0, x20
0x00054a5c  bl       #0x558ec   ; CALL _CGColorSpaceRelease
0x00054a60  ldur     x8, [x29, #-0x28]
0x00054a64  adrp     x9, #0x74000
0x00054a68  ldr      x9, [x9, #0x398]   ; @GOT ___stack_chk_guard
0x00054a6c  ldr      x9, [x9]   ; @GOT ___objc_personality_v0
0x00054a70  cmp      x9, x8
0x00054a74  b.ne     #0x54a8c
0x00054a78  ldp      x29, x30, [sp, #0x80]
0x00054a7c  ldp      x20, x19, [sp, #0x70]
0x00054a80  ldp      x22, x21, [sp, #0x60]
0x00054a84  add      sp, sp, #0x90
0x00054a88  ret      
0x00054a8c  bl       #0x55b98   ; CALL ___stack_chk_fail

=== sub_54a90  va=0x54a90 size=288 types=
; data refs: __DATA_CONST,__const@0x74f28
0x00054a90  stp      d9, d8, [sp, #-0x40]!
0x00054a94  stp      x22, x21, [sp, #0x10]
0x00054a98  stp      x20, x19, [sp, #0x20]
0x00054a9c  stp      x29, x30, [sp, #0x30]
0x00054aa0  add      x29, sp, #0x30
0x00054aa4  mov      x19, x1
0x00054aa8  fmov     d0, #24.00000000
0x00054aac  fmov     d1, #24.00000000
0x00054ab0  mov      x0, x1
0x00054ab4  bl       #0x559c4   ; CALL _CGContextTranslateCTM
0x00054ab8  adrp     x21, #0x8e000
0x00054abc  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00054ac0  adrp     x8, #0x66000
0x00054ac4  ldr      d1, [x8, #0x298]
0x00054ac8  adrp     x8, #0x66000
0x00054acc  ldr      d2, [x8, #0x1b0]
0x00054ad0  fmov     d0, #1.00000000
0x00054ad4  fmov     d3, #1.00000000
0x00054ad8  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00054adc  mov      x29, x29
0x00054ae0  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00054ae4  mov      x20, x0
0x00054ae8  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00054aec  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00054af0  mov      x1, x0
0x00054af4  mov      x0, x19
0x00054af8  bl       #0x55994   ; CALL _CGContextSetFillColorWithColor
0x00054afc  mov      x0, x20
0x00054b00  bl       #0x55d78   ; CALL _objc_release
0x00054b04  mov      w20, #5
0x00054b08  adrp     x8, #0x66000
0x00054b0c  ldr      d8, [x8, #0x2a0]
0x00054b10  mov      x0, x19
0x00054b14  mov      v0.16b, v8.16b
0x00054b18  bl       #0x55964   ; CALL _CGContextRotateCTM
0x00054b1c  fmov     d0, #-7.00000000
0x00054b20  fmov     d1, #-22.00000000
0x00054b24  fmov     d2, #14.00000000
0x00054b28  fmov     d3, #22.00000000
0x00054b2c  mov      x0, x19
0x00054b30  bl       #0x55934   ; CALL _CGContextFillEllipseInRect
0x00054b34  subs     w20, w20, #1
0x00054b38  b.ne     #0x54b10
0x00054b3c  ldr      x0, [x21, #0x910]   ; @CLASS UIColor
0x00054b40  adrp     x8, #0x66000
0x00054b44  ldr      d0, [x8, #0x2a8]
0x00054b48  adrp     x8, #0x66000
0x00054b4c  ldr      d1, [x8, #0x2b0]
0x00054b50  adrp     x8, #0x65000
0x00054b54  ldr      d2, [x8, #0xae8]
0x00054b58  fmov     d3, #1.00000000
0x00054b5c  bl       #0x56ee0   ; CALL objc_msgSend$colorWithRed:green:blue:alpha:
0x00054b60  mov      x29, x29
0x00054b64  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x00054b68  mov      x20, x0
0x00054b6c  bl       #0x55d90   ; CALL _objc_retainAutorelease
0x00054b70  bl       #0x55e80   ; CALL objc_msgSend$CGColor
0x00054b74  mov      x1, x0
0x00054b78  mov      x0, x19
0x00054b7c  bl       #0x55994   ; CALL _CGContextSetFillColorWithColor
0x00054b80  mov      x0, x20
0x00054b84  bl       #0x55d78   ; CALL _objc_release
0x00054b88  fmov     d0, #-4.50000000
0x00054b8c  fmov     d1, #-4.50000000
0x00054b90  fmov     d2, #9.00000000
0x00054b94  fmov     d3, #9.00000000
0x00054b98  mov      x0, x19
0x00054b9c  ldp      x29, x30, [sp, #0x30]
0x00054ba0  ldp      x20, x19, [sp, #0x20]
0x00054ba4  ldp      x22, x21, [sp, #0x10]
0x00054ba8  ldp      d9, d8, [sp], #0x40
0x00054bac  b        #0x55934   ; CALL _CGContextFillEllipseInRect

=== sub_55694  va=0x55694 size=256 types=
; data refs: __DATA_CONST,__const@0x74ff8
0x00055694  stp      x20, x19, [sp, #-0x20]!
0x00055698  stp      x29, x30, [sp, #0x10]
0x0005569c  add      x29, sp, #0x10
0x000556a0  adrp     x0, #0x7e000
0x000556a4  add      x0, x0, #0x828   ; STR "2027-04-30"
0x000556a8  bl       #0x58c20   ; CALL objc_msgSend$length
0x000556ac  cbz      x0, #0x55788
0x000556b0  adrp     x8, #0x8e000
0x000556b4  ldr      x0, [x8, #0x980]   ; @CLASS NSDateFormatter
0x000556b8  bl       #0x55d60   ; CALL _objc_opt_new
0x000556bc  mov      x19, x0
0x000556c0  adrp     x8, #0x8e000
0x000556c4  ldr      x0, [x8, #0xa08]   ; @CLASS NSLocale
0x000556c8  adrp     x2, #0x77000
0x000556cc  add      x2, x2, #0xea8   ; STR "en_US_POSIX"
0x000556d0  bl       #0x58d60   ; CALL objc_msgSend$localeWithLocaleIdentifier:
0x000556d4  mov      x29, x29
0x000556d8  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000556dc  mov      x20, x0
0x000556e0  mov      x0, x19
0x000556e4  mov      x2, x20
0x000556e8  bl       #0x5b440   ; CALL objc_msgSend$setLocale:
0x000556ec  mov      x0, x20
0x000556f0  bl       #0x55d78   ; CALL _objc_release
0x000556f4  adrp     x8, #0x8e000
0x000556f8  ldr      x0, [x8, #0xca8]   ; @CLASS NSTimeZone
0x000556fc  mov      w2, #0x6270
0x00055700  bl       #0x5db00   ; CALL objc_msgSend$timeZoneForSecondsFromGMT:
0x00055704  mov      x29, x29
0x00055708  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005570c  mov      x20, x0
0x00055710  mov      x0, x19
0x00055714  mov      x2, x20
0x00055718  bl       #0x5c580   ; CALL objc_msgSend$setTimeZone:
0x0005571c  mov      x0, x20
0x00055720  bl       #0x55d78   ; CALL _objc_release
0x00055724  adrp     x2, #0x7d000
0x00055728  add      x2, x2, #0x148   ; STR "yyyy-MM-dd"
0x0005572c  mov      x0, x19
0x00055730  bl       #0x5ac40   ; CALL objc_msgSend$setDateFormat:
0x00055734  adrp     x2, #0x7e000
0x00055738  add      x2, x2, #0x828   ; STR "2027-04-30"
0x0005573c  mov      x0, x19
0x00055740  bl       #0x57600   ; CALL objc_msgSend$dateFromString:
0x00055744  mov      x29, x29
0x00055748  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x0005574c  mov      x20, x0
0x00055750  cbz      x0, #0x55770
0x00055754  mov      x0, x20
0x00055758  bl       #0x5daa0   ; CALL objc_msgSend$timeIntervalSince1970
0x0005575c  adrp     x8, #0x66000
0x00055760  ldr      d1, [x8, #0x560]
0x00055764  fadd     d0, d0, d1
0x00055768  adrp     x8, #0x90000
0x0005576c  str      d0, [x8, #0xf0]
0x00055770  mov      x0, x20
0x00055774  bl       #0x55d78   ; CALL _objc_release
0x00055778  mov      x0, x19
0x0005577c  ldp      x29, x30, [sp, #0x10]
0x00055780  ldp      x20, x19, [sp], #0x20
0x00055784  b        #0x55d78   ; CALL _objc_release
0x00055788  ldp      x29, x30, [sp, #0x10]
0x0005578c  ldp      x20, x19, [sp], #0x20
0x00055790  ret      

=== sub_55794  va=0x55794 size=92 types=
; data refs: __DATA_CONST,__const@0x75018
0x00055794  stp      x29, x30, [sp, #-0x10]!
0x00055798  mov      x29, sp
0x0005579c  adrp     x8, #0x8e000
0x000557a0  ldr      x0, [x8, #0x9d0]   ; @CLASS NSMutableDictionary
0x000557a4  bl       #0x57780   ; CALL objc_msgSend$dictionary
0x000557a8  mov      x29, x29
0x000557ac  bl       #0x55d9c   ; CALL _objc_retainAutoreleasedReturnValue
0x000557b0  adrp     x9, #0x90000
0x000557b4  ldr      x8, [x9, #0x100]
0x000557b8  str      x0, [x9, #0x100]
0x000557bc  mov      x0, x8
0x000557c0  ldp      x29, x30, [sp], #0x10
0x000557c4  b        #0x55d78   ; CALL _objc_release
0x000557c8  adrp     x0, #0x90000
0x000557cc  add      x0, x0, #0xf8
0x000557d0  adrp     x1, #0x74000
0x000557d4  add      x1, x1, #0xfe8
0x000557d8  b        #0x55bf8   ; CALL _dispatch_once
0x000557dc  adrp     x0, #0x90000
0x000557e0  add      x0, x0, #0x108
0x000557e4  adrp     x1, #0x75000
0x000557e8  add      x1, x1, #8
0x000557ec  b        #0x55bf8   ; CALL _dispatch_once
