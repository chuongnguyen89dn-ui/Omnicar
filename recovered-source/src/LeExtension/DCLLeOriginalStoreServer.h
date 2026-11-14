#ifndef DCL_LE_ORIGINAL_STORE_SERVER_H
#define DCL_LE_ORIGINAL_STORE_SERVER_H
#import <dispatch/dispatch.h>
void DCLLeOriginalStoreStart(void);
// Both Lề bridges share ONE serial queue. No main-thread transfer of raw
// notification frames and no competing JSON read/write transactions.
dispatch_queue_t DCLLeStoreSerialQueue(void);
#endif
