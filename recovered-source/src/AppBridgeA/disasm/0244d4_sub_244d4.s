; ==== sub_244d4 @ 0x244d4..0x24734 (608 bytes) ====
0x000244d4  ldr      x16, [x16, #0x2b8]
0x000244d8  br       x16
0x000244dc  adrp     x16, #0x34000
0x000244e0  ldr      x16, [x16, #0x2c0]   ; -> [got:_backtrace_symbols_fd]
0x000244e4  br       x16
0x000244e8  adrp     x16, #0x34000
0x000244ec  ldr      x16, [x16, #0x2c8]   ; -> [got:_calloc]
0x000244f0  br       x16
0x000244f4  adrp     x16, #0x34000
0x000244f8  ldr      x16, [x16, #8]   ; -> [got:_class_addMethod]
0x000244fc  br       x16
0x00024500  adrp     x16, #0x34000
0x00024504  ldr      x16, [x16, #0x10]   ; -> [got:_class_copyMethodList]
0x00024508  br       x16
0x0002450c  adrp     x16, #0x34000
0x00024510  ldr      x16, [x16, #0x18]   ; -> [got:_class_copyPropertyList]
0x00024514  br       x16
0x00024518  adrp     x16, #0x34000
0x0002451c  ldr      x16, [x16, #0x20]   ; -> [got:_class_getClassMethod]
0x00024520  br       x16
0x00024524  adrp     x16, #0x34000
0x00024528  ldr      x16, [x16, #0x28]   ; -> [got:_class_getInstanceMethod]
0x0002452c  br       x16
0x00024530  adrp     x16, #0x34000
0x00024534  ldr      x16, [x16, #0x30]   ; -> [got:_class_getSuperclass]
0x00024538  br       x16
0x0002453c  adrp     x16, #0x34000
0x00024540  ldr      x16, [x16, #0x2d0]   ; -> [got:_close]
0x00024544  br       x16
0x00024548  adrp     x16, #0x34000
0x0002454c  ldr      x16, [x16, #0x2d8]   ; -> [got:_dispatch_after]
0x00024550  br       x16
0x00024554  adrp     x16, #0x34000
0x00024558  ldr      x16, [x16, #0x2e0]   ; -> [got:_dispatch_async]
0x0002455c  br       x16
0x00024560  adrp     x16, #0x34000
0x00024564  ldr      x16, [x16, #0x2e8]   ; -> [got:_dispatch_block_cancel]
0x00024568  br       x16
0x0002456c  adrp     x16, #0x34000
0x00024570  ldr      x16, [x16, #0x2f0]   ; -> [got:_dispatch_block_create]
0x00024574  br       x16
0x00024578  adrp     x16, #0x34000
0x0002457c  ldr      x16, [x16, #0x2f8]   ; -> [got:_dispatch_once]
0x00024580  br       x16
0x00024584  adrp     x16, #0x34000
0x00024588  ldr      x16, [x16, #0x300]   ; -> [got:_dispatch_queue_create]
0x0002458c  br       x16
0x00024590  adrp     x16, #0x34000
0x00024594  ldr      x16, [x16, #0x308]   ; -> [got:_dispatch_resume]
0x00024598  br       x16
0x0002459c  adrp     x16, #0x34000
0x000245a0  ldr      x16, [x16, #0x310]   ; -> [got:_dispatch_source_cancel]
0x000245a4  br       x16
0x000245a8  adrp     x16, #0x34000
0x000245ac  ldr      x16, [x16, #0x318]   ; -> [got:_dispatch_source_create]
0x000245b0  br       x16
0x000245b4  adrp     x16, #0x34000
0x000245b8  ldr      x16, [x16, #0x320]   ; -> [got:_dispatch_source_set_event_handler]
0x000245bc  br       x16
0x000245c0  adrp     x16, #0x34000
0x000245c4  ldr      x16, [x16, #0x328]   ; -> [got:_dispatch_source_set_timer]
0x000245c8  br       x16
0x000245cc  adrp     x16, #0x34000
0x000245d0  ldr      x16, [x16, #0x330]   ; -> [got:_dispatch_time]
0x000245d4  br       x16
0x000245d8  adrp     x16, #0x34000
0x000245dc  ldr      x16, [x16, #0x338]   ; -> [got:_dladdr]
0x000245e0  br       x16
0x000245e4  adrp     x16, #0x34000
0x000245e8  ldr      x16, [x16, #0x340]   ; -> [got:_dlopen]
0x000245ec  br       x16
0x000245f0  adrp     x16, #0x34000
0x000245f4  ldr      x16, [x16, #0x348]   ; -> [got:_dlsym]
0x000245f8  br       x16
0x000245fc  adrp     x16, #0x34000
0x00024600  ldr      x16, [x16, #0x350]   ; -> [got:_dprintf]
0x00024604  br       x16
0x00024608  adrp     x16, #0x34000
0x0002460c  ldr      x16, [x16, #0x358]   ; -> [got:_fclose]
0x00024610  br       x16
0x00024614  adrp     x16, #0x34000
0x00024618  ldr      x16, [x16, #0x360]   ; -> [got:_fopen]
0x0002461c  br       x16
0x00024620  adrp     x16, #0x34000
0x00024624  ldr      x16, [x16, #0x368]   ; -> [got:_fputs]
0x00024628  br       x16
0x0002462c  adrp     x16, #0x34000
0x00024630  ldr      x16, [x16, #0x370]   ; -> [got:_free]
0x00024634  br       x16
0x00024638  adrp     x16, #0x34000
0x0002463c  ldr      x16, [x16, #0x378]   ; -> [got:_getenv]
0x00024640  br       x16
0x00024644  adrp     x16, #0x34000
0x00024648  ldr      x16, [x16, #0x380]   ; -> [got:_getpid]
0x0002464c  br       x16
0x00024650  adrp     x16, #0x34000
0x00024654  ldr      x16, [x16, #0x388]   ; -> [got:_getsectiondata]
0x00024658  br       x16
0x0002465c  adrp     x16, #0x34000
0x00024660  ldr      x16, [x16, #0x390]   ; -> [got:_host_page_size]
0x00024664  br       x16
0x00024668  adrp     x16, #0x34000
0x0002466c  ldr      x16, [x16, #0x398]   ; -> [got:_host_statistics64]
0x00024670  br       x16
0x00024674  adrp     x16, #0x34000
0x00024678  ldr      x16, [x16, #0x3a0]   ; -> [got:_hypot]
0x0002467c  br       x16
0x00024680  adrp     x16, #0x34000
0x00024684  ldr      x16, [x16, #0x38]   ; -> [got:_imp_implementationWithBlock]
0x00024688  br       x16
0x0002468c  adrp     x16, #0x34000
0x00024690  ldr      x16, [x16, #0x3a8]   ; -> [got:_mach_absolute_time]
0x00024694  br       x16
0x00024698  adrp     x16, #0x34000
0x0002469c  ldr      x16, [x16, #0x3b0]   ; -> [got:_mach_host_self]
0x000246a0  br       x16
0x000246a4  adrp     x16, #0x34000
0x000246a8  ldr      x16, [x16, #0x3b8]   ; -> [got:_mach_port_deallocate]
0x000246ac  br       x16
0x000246b0  adrp     x16, #0x34000
0x000246b4  ldr      x16, [x16, #0x3c8]   ; -> [got:_mach_timebase_info]
0x000246b8  br       x16
0x000246bc  adrp     x16, #0x34000
0x000246c0  ldr      x16, [x16, #0x3d0]   ; -> [got:_malloc]
0x000246c4  br       x16
0x000246c8  adrp     x16, #0x34000
0x000246cc  ldr      x16, [x16, #0x40]   ; -> [got:_method_getName]
0x000246d0  br       x16
0x000246d4  adrp     x16, #0x34000
0x000246d8  ldr      x16, [x16, #0x48]   ; -> [got:_method_getTypeEncoding]
0x000246dc  br       x16
0x000246e0  adrp     x16, #0x34000
0x000246e4  ldr      x16, [x16, #0x3d8]   ; -> [got:_notify_get_state]
0x000246e8  br       x16
0x000246ec  adrp     x16, #0x34000
0x000246f0  ldr      x16, [x16, #0x3e0]   ; -> [got:_notify_post]
0x000246f4  br       x16
0x000246f8  adrp     x16, #0x34000
0x000246fc  ldr      x16, [x16, #0x3e8]   ; -> [got:_notify_register_check]
0x00024700  br       x16
0x00024704  adrp     x16, #0x34000
0x00024708  ldr      x16, [x16, #0x3f0]   ; -> [got:_notify_register_dispatch]
0x0002470c  br       x16
0x00024710  adrp     x16, #0x34000
0x00024714  ldr      x16, [x16, #0x3f8]   ; -> [got:_notify_set_state]
0x00024718  br       x16
0x0002471c  adrp     x16, #0x34000
0x00024720  ldr      x16, [x16, #0x50]   ; -> [got:_objc_alloc]
0x00024724  br       x16
0x00024728  adrp     x16, #0x34000
0x0002472c  ldr      x16, [x16, #0x58]   ; -> [got:_objc_allocateClassPair]
0x00024730  br       x16
