; ==== sub_24474 @ 0x24474..0x244d4 (96 bytes) ====
0x00024474  ldr      x16, [x16, #0x260]
0x00024478  br       x16
0x0002447c  adrp     x16, #0x34000
0x00024480  ldr      x16, [x16, #0x268]   ; -> [got:___memcpy_chk]
0x00024484  br       x16
0x00024488  adrp     x16, #0x34000
0x0002448c  ldr      x16, [x16, #0x270]   ; -> [got:___stack_chk_fail]
0x00024490  br       x16
0x00024494  adrp     x16, #0x34000
0x00024498  ldr      x16, [x16, #0x280]   ; -> [got:___strlcpy_chk]
0x0002449c  br       x16
0x000244a0  adrp     x16, #0x34000
0x000244a4  ldr      x16, [x16, #0x288]   ; -> [got:___tolower]
0x000244a8  br       x16
0x000244ac  adrp     x16, #0x34000
0x000244b0  ldr      x16, [x16, #0x2a0]   ; -> [got:__dyld_get_image_header]
0x000244b4  br       x16
0x000244b8  adrp     x16, #0x34000
0x000244bc  ldr      x16, [x16, #0x2a8]   ; -> [got:__dyld_get_image_name]
0x000244c0  br       x16
0x000244c4  adrp     x16, #0x34000
0x000244c8  ldr      x16, [x16, #0x2b0]   ; -> [got:__dyld_image_count]
0x000244cc  br       x16
0x000244d0  adrp     x16, #0x34000
