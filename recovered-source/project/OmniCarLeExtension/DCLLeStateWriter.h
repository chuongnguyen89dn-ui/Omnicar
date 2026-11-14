#ifndef DCL_LE_STATE_WRITER_H
#define DCL_LE_STATE_WRITER_H
#include <stddef.h>
#include <stdint.h>
// Owner-checked atomic writer; only the server supplies the fixed trusted directory/name.
// Never chown/chmod/remove old user data. On first replacement, hard-link a read-only
// rollback image named <name>.duocar54-previous.bak in the same directory.
int DCLLeWriteStateAtomically(const char *directory,const char *name,
                              const uint8_t *bytes,size_t count,
                              int *stage,int *savedErrno);
#endif
