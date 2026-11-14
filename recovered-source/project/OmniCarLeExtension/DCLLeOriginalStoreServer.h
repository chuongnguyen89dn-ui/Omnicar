#import <dispatch/dispatch.h>
#ifndef DCL_LE_ORIGINAL_STORE_SERVER_H
#define DCL_LE_ORIGINAL_STORE_SERVER_H
void DCLLeOriginalStoreStart(void);
#endif
// Both Lề bridges share ONE serial owner queue. No main-thread
// work for 4-byte raw IPC, no concurrent JSON read/overwrite.
dispatch_queue_t DCLLeStoreSerialQueue(void);
