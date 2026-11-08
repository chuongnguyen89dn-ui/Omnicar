; ==== sub_21534 @ 0x21534..0x215dc (168 bytes) ====
0x00021534  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021538  mov      x19, x0
0x0002153c  bl       #0x24f20   ; objc_msgSend: boolValue
0x00021540  mov      x20, x0
0x00021544  mov      x0, x19
0x00021548  bl       #0x2480c   ; call _objc_release
0x0002154c  cbz      w20, #0x21b68
0x00021550  ldr      x0, [sp, #0x78]
0x00021554  adrp     x1, #0x39000
0x00021558  add      x1, x1, #0x4f8
0x0002155c  bl       #0x231b0   ; call sub_231b0
0x00021560  mov      x29, x29
0x00021564  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021568  str      x0, [sp, #0x38]
0x0002156c  ldr      x0, [sp, #0x78]
0x00021570  adrp     x1, #0x39000
0x00021574  add      x1, x1, #0x510
0x00021578  bl       #0x231b0   ; call sub_231b0
0x0002157c  mov      x29, x29
0x00021580  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00021584  str      x0, [sp, #0x30]
0x00021588  ldr      x19, [sp, #0x30]
0x0002158c  cbz      x19, #0x215a0
0x00021590  mov      x0, x19
0x00021594  bl       #0x24818   ; call _objc_retain
0x00021598  str      x19, [sp, #0x58]
0x0002159c  b        #0x21610   ; call sub_21610
0x000215a0  adrp     x8, #0x3e000
0x000215a4  ldr      x20, [x8, #0x290]   ; -> [class(NSString)]
0x000215a8  ldr      x9, [sp, #0x38]
0x000215ac  cmp      x9, #0
0x000215b0  adrp     x8, #0x37000
0x000215b4  add      x8, x8, #0x310   ; -> @"?"
0x000215b8  csel     x21, x8, x9, eq
0x000215bc  ldr      x0, [sp, #0x78]
0x000215c0  adrp     x2, #0x38000
0x000215c4  add      x2, x2, #0x1d0   ; -> @"pixels"
0x000215c8  bl       #0x26420   ; objc_msgSend: objectForKeyedSubscript:
0x000215cc  mov      x29, x29
0x000215d0  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000215d4  mov      x19, x0
0x000215d8  cmp      x0, #0
