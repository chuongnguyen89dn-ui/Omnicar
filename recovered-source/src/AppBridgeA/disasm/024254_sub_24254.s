; ==== sub_24254 @ 0x24254..0x243e4 (400 bytes) ====
0x00024254  adrp     x1, #0x34000
0x00024258  add      x1, x1, #0xbf0
0x0002425c  b        #0x24578   ; call _dispatch_once
0x00024260  adrp     x0, #0x3e000
0x00024264  add      x0, x0, #0xb28
0x00024268  adrp     x1, #0x34000
0x0002426c  add      x1, x1, #0xc50
0x00024270  b        #0x24578   ; call _dispatch_once
0x00024274  adrp     x0, #0x3e000
0x00024278  add      x0, x0, #0xc70
0x0002427c  adrp     x1, #0x34000
0x00024280  add      x1, x1, #0xd90
0x00024284  b        #0x24578   ; call _dispatch_once
0x00024288  adrp     x0, #0x3e000
0x0002428c  add      x0, x0, #0xc80
0x00024290  adrp     x1, #0x34000
0x00024294  add      x1, x1, #0xdb0
0x00024298  b        #0x24578   ; call _dispatch_once
0x0002429c  adrp     x16, #0x34000
0x000242a0  ldr      x16, [x16, #0x578]   ; -> [got:_CAFrameRateRangeMake]
0x000242a4  br       x16
0x000242a8  adrp     x16, #0x34000
0x000242ac  ldr      x16, [x16, #0x1c0]   ; -> [got:_CFAbsoluteTimeGetCurrent]
0x000242b0  br       x16
0x000242b4  adrp     x16, #0x34000
0x000242b8  ldr      x16, [x16, #0x1c8]   ; -> [got:_CFPreferencesAppSynchronize]
0x000242bc  br       x16
0x000242c0  adrp     x16, #0x34000
0x000242c4  ldr      x16, [x16, #0x1d0]   ; -> [got:_CFPreferencesCopyAppValue]
0x000242c8  br       x16
0x000242cc  adrp     x16, #0x34000
0x000242d0  ldr      x16, [x16, #0x1d8]   ; -> [got:_CFPreferencesSetAppValue]
0x000242d4  br       x16
0x000242d8  adrp     x16, #0x34000
0x000242dc  ldr      x16, [x16, #0x4a8]   ; -> [got:_CGAffineTransformConcat]
0x000242e0  br       x16
0x000242e4  adrp     x16, #0x34000
0x000242e8  ldr      x16, [x16, #0x4b8]   ; -> [got:_CGAffineTransformMakeScale]
0x000242ec  br       x16
0x000242f0  adrp     x16, #0x34000
0x000242f4  ldr      x16, [x16, #0x4c0]   ; -> [got:_CGAffineTransformMakeTranslation]
0x000242f8  br       x16
0x000242fc  adrp     x16, #0x34000
0x00024300  ldr      x16, [x16, #0x4c8]   ; -> [got:_CGAffineTransformScale]
0x00024304  br       x16
0x00024308  adrp     x16, #0x34000
0x0002430c  ldr      x16, [x16, #0x4d0]   ; -> [got:_CGColorSpaceCreateDeviceRGB]
0x00024310  br       x16
0x00024314  adrp     x16, #0x34000
0x00024318  ldr      x16, [x16, #0x4d8]   ; -> [got:_CGColorSpaceRelease]
0x0002431c  br       x16
0x00024320  adrp     x16, #0x34000
0x00024324  ldr      x16, [x16, #0x4e0]   ; -> [got:_CGContextDrawRadialGradient]
0x00024328  br       x16
0x0002432c  adrp     x16, #0x34000
0x00024330  ldr      x16, [x16, #0x4e8]   ; -> [got:_CGContextFillRect]
0x00024334  br       x16
0x00024338  adrp     x16, #0x34000
0x0002433c  ldr      x16, [x16, #0x4f0]   ; -> [got:_CGContextScaleCTM]
0x00024340  br       x16
0x00024344  adrp     x16, #0x34000
0x00024348  ldr      x16, [x16, #0x4f8]   ; -> [got:_CGGradientCreateWithColorComponents]
0x0002434c  br       x16
0x00024350  adrp     x16, #0x34000
0x00024354  ldr      x16, [x16, #0x500]   ; -> [got:_CGGradientRelease]
0x00024358  br       x16
0x0002435c  adrp     x16, #0x34000
0x00024360  ldr      x16, [x16, #0x510]   ; -> [got:_CGRectContainsPoint]
0x00024364  br       x16
0x00024368  adrp     x16, #0x34000
0x0002436c  ldr      x16, [x16, #0x518]   ; -> [got:_CGRectEqualToRect]
0x00024370  br       x16
0x00024374  adrp     x16, #0x34000
0x00024378  ldr      x16, [x16, #0x520]   ; -> [got:_CGRectGetMaxY]
0x0002437c  br       x16
0x00024380  adrp     x16, #0x34000
0x00024384  ldr      x16, [x16, #0x528]   ; -> [got:_CGRectGetMidX]
0x00024388  br       x16
0x0002438c  adrp     x16, #0x34000
0x00024390  ldr      x16, [x16, #0x530]   ; -> [got:_CGRectGetMidY]
0x00024394  br       x16
0x00024398  adrp     x16, #0x34000
0x0002439c  ldr      x16, [x16, #0x538]   ; -> [got:_CGRectGetMinX]
0x000243a0  br       x16
0x000243a4  adrp     x16, #0x34000
0x000243a8  ldr      x16, [x16, #0x540]   ; -> [got:_CGRectGetMinY]
0x000243ac  br       x16
0x000243b0  adrp     x16, #0x34000
0x000243b4  ldr      x16, [x16, #0x548]   ; -> [got:_CGRectInset]
0x000243b8  br       x16
0x000243bc  adrp     x16, #0x34000
0x000243c0  ldr      x16, [x16, #0x550]   ; -> [got:_CGRectIntersection]
0x000243c4  br       x16
0x000243c8  adrp     x16, #0x34000
0x000243cc  ldr      x16, [x16, #0x558]   ; -> [got:_CGRectIsEmpty]
0x000243d0  br       x16
0x000243d4  adrp     x16, #0x34000
0x000243d8  ldr      x16, [x16, #0x568]   ; -> [got:_CGRectOffset]
0x000243dc  br       x16
0x000243e0  adrp     x16, #0x34000
