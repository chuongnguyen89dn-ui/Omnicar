; === _OMCPrefsSync @ 0x6528 size=12 ===
0x00006528  adrp     x0, #0x14000
0x0000652c  add      x0, x0, #0xa28 ; -> CFSTR("com.anlai.omnicar")
0x00006530  b        #0xd0e0 ; call stub:_CFPreferencesAppSynchronize
