; ==== sub_15690 @ 0x15690..0x15868 (472 bytes) ====
0x00015690  mov      x29, x29
0x00015694  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015698  mov      x22, x0
0x0001569c  bl       #0x26840   ; objc_msgSend: removeFromSuperview
0x000156a0  mov      x0, x22
0x000156a4  bl       #0x2480c   ; call _objc_release
0x000156a8  adrp     x8, #0x3d000
0x000156ac  ldr      x1, [x8, #0x738]   ; -> [@selector(invalidate)]
0x000156b0  mov      x0, x21
0x000156b4  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x000156b8  tbz      w0, #0, #0x1570c
0x000156bc  mov      x0, x21
0x000156c0  bl       #0x24818   ; call _objc_retain
0x000156c4  adrp     x0, #0x36000
0x000156c8  add      x0, x0, #0x650   ; -> @"invalidate"
0x000156cc  bl       #0x2441c   ; call _NSSelectorFromString
0x000156d0  mov      x22, x0
0x000156d4  mov      x0, x21
0x000156d8  mov      x1, x22
0x000156dc  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x000156e0  tbz      w0, #0, #0x156f4
0x000156e4  mov      x0, x21
0x000156e8  mov      x1, x22
0x000156ec  bl       #0x247ac   ; call _objc_msgSend
0x000156f0  b        #0x15704   ; call sub_15704
0x000156f4  adrp     x1, #0x36000
0x000156f8  add      x1, x1, #0x650   ; -> @"invalidate"
0x000156fc  mov      x0, x21
0x00015700  bl       #0x9698   ; call _ABMissingSelector
0x00015704  mov      x0, x21
0x00015708  bl       #0x2480c   ; call _objc_release
0x0001570c  mov      x0, x21
0x00015710  bl       #0x24818   ; call _objc_retain
0x00015714  adrp     x0, #0x36000
0x00015718  add      x0, x0, #0x130   ; -> @"sceneHandle"
0x0001571c  bl       #0x2441c   ; call _NSSelectorFromString
0x00015720  mov      x22, x0
0x00015724  mov      x0, x21
0x00015728  mov      x1, x22
0x0001572c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00015730  tbz      w0, #0, #0x15750
0x00015734  mov      x0, x21
0x00015738  mov      x1, x22
0x0001573c  bl       #0x247ac   ; call _objc_msgSend
0x00015740  mov      x29, x29
0x00015744  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015748  mov      x24, x0
0x0001574c  b        #0x15764   ; call sub_15764
0x00015750  adrp     x1, #0x36000
0x00015754  add      x1, x1, #0x130   ; -> @"sceneHandle"
0x00015758  mov      x0, x21
0x0001575c  bl       #0x9698   ; call _ABMissingSelector
0x00015760  mov      x24, #0
0x00015764  mov      x0, x21
0x00015768  bl       #0x2480c   ; call _objc_release
0x0001576c  adrp     x0, #0x36000
0x00015770  add      x0, x0, #0x150   ; -> @"sceneIfExists"
0x00015774  bl       #0x2441c   ; call _NSSelectorFromString
0x00015778  mov      x22, x0
0x0001577c  mov      x0, x24
0x00015780  mov      x1, x22
0x00015784  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00015788  tbz      w0, #0, #0x157a8
0x0001578c  mov      x0, x24
0x00015790  mov      x1, x22
0x00015794  bl       #0x247ac   ; call _objc_msgSend
0x00015798  mov      x29, x29
0x0001579c  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000157a0  mov      x22, x0
0x000157a4  b        #0x157bc   ; call sub_157bc
0x000157a8  adrp     x1, #0x36000
0x000157ac  add      x1, x1, #0x150   ; -> @"sceneIfExists"
0x000157b0  mov      x0, x24
0x000157b4  bl       #0x9698   ; call _ABMissingSelector
0x000157b8  mov      x22, #0
0x000157bc  mov      x0, x24
0x000157c0  bl       #0x2480c   ; call _objc_release
0x000157c4  cbz      x22, #0x15918
0x000157c8  adrp     x8, #0x3e000
0x000157cc  ldr      x0, [x8, #0x2c0]   ; -> [class(UIApplication)]
0x000157d0  bl       #0x27b40   ; objc_msgSend: sharedApplication
0x000157d4  mov      x29, x29
0x000157d8  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x000157dc  mov      x26, x0
0x000157e0  adrp     x0, #0x36000
0x000157e4  add      x0, x0, #0x670   ; -> @"_accessibilityFrontMostApplication"
0x000157e8  bl       #0x2441c   ; call _NSSelectorFromString
0x000157ec  mov      x23, x0
0x000157f0  mov      x0, x26
0x000157f4  mov      x1, x23
0x000157f8  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x000157fc  tbz      w0, #0, #0x1581c
0x00015800  mov      x0, x26
0x00015804  mov      x1, x23
0x00015808  bl       #0x247ac   ; call _objc_msgSend
0x0001580c  mov      x29, x29
0x00015810  bl       #0x24830   ; call _objc_retainAutoreleasedReturnValue
0x00015814  mov      x24, x0
0x00015818  b        #0x15830   ; call sub_15830
0x0001581c  adrp     x1, #0x36000
0x00015820  add      x1, x1, #0x670   ; -> @"_accessibilityFrontMostApplication"
0x00015824  mov      x0, x26
0x00015828  bl       #0x9698   ; call _ABMissingSelector
0x0001582c  mov      x24, #0
0x00015830  mov      x0, x26
0x00015834  bl       #0x2480c   ; call _objc_release
0x00015838  cbz      x24, #0x158b8
0x0001583c  mov      x0, x24
0x00015840  bl       #0x24818   ; call _objc_retain
0x00015844  adrp     x0, #0x35000
0x00015848  add      x0, x0, #0x930   ; -> @"bundleIdentifier"
0x0001584c  bl       #0x2441c   ; call _NSSelectorFromString
0x00015850  mov      x23, x0
0x00015854  mov      x0, x24
0x00015858  mov      x1, x23
0x0001585c  bl       #0x247f4   ; call _objc_opt_respondsToSelector
0x00015860  tbz      w0, #0, #0x15880
0x00015864  mov      x0, x24
