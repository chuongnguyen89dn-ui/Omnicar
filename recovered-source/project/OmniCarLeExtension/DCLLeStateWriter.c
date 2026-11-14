#include "DCLLeStateWriter.h"
#include "DCLLeStoreWire.h"
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

#ifndef O_NOFOLLOW
#define O_NOFOLLOW 0
#endif
#ifndef O_DIRECTORY
#define O_DIRECTORY 0
#endif
#ifndef O_CLOEXEC
#define O_CLOEXEC 0
#endif
#ifndef AT_SYMLINK_NOFOLLOW
#define AT_SYMLINK_NOFOLLOW 0
#endif

static int DCLCheckOwner(const struct stat *st,int isDirectory) {
    return st->st_uid==geteuid() && !(st->st_mode&022) &&
         (isDirectory?S_ISDIR(st->st_mode):S_ISREG(st->st_mode));
}
static int DCLWriteAll(int fd,const uint8_t *bytes,size_t count) {
    size_t off=0;
    while(off<count) {
        ssize_t n=write(fd,bytes+off,count-off);
        if(n<0 && errno==EINTR)continue;
        if(n<=0)return -1;
        off+=(size_t)n;
    }
    return 0;
}
static int DCLVerify(int dirfd,const char *name,const uint8_t *expected,size_t len) {
    int fd=openat(dirfd,name,O_RDONLY|O_NOFOLLOW|O_CLOEXEC);
    if(fd<0)return -1;
    struct stat st;
    if(fstat(fd,&st)!=0 || !DCLCheckOwner(&st,0) || st.st_size!=(off_t)len) {
        close(fd);errno=EIO;return -1;
    }
    uint8_t buf[1024];size_t at=0;
    while(at<len) {
        size_t need=len-at<sizeof(buf)?len-at:sizeof(buf);
        ssize_t n=read(fd,buf,need);
        if(n<0 && errno==EINTR)continue;
        if(n<=0 || memcmp(buf,expected+at,(size_t)n)!=0){close(fd);errno=EIO;return -1;}
        at+=(size_t)n;
    }
    close(fd);
    return 0;
}
int DCLLeWriteStateAtomically(const char *directory,const char *name,
                              const uint8_t *bytes,size_t count,
                              int *stage,int *savedErrno) {
    int phase=1, err=0, dirfd=-1,fd=-1,committed=0;
    char temp[128]={0},backup[128]={0};
    struct stat st;
    if(stage)*stage=phase;if(savedErrno)*savedErrno=0;
    if(!directory||!name||strcmp(name,"layout-v1.json")!=0||!bytes||
       count<2||count>DCL_LE_RAW_LIMIT){err=EINVAL;goto failed;}
    phase=2;
    if(mkdir(directory,0700)<0 && errno!=EEXIST){err=errno;goto failed;}
    if(lstat(directory,&st)!=0){err=errno;goto failed;}
    if(!DCLCheckOwner(&st,1)){err=EPERM;goto failed;}
    dirfd=open(directory,O_RDONLY|O_DIRECTORY|O_NOFOLLOW|O_CLOEXEC);
    if(dirfd<0){err=errno;goto failed;}
    if(fstat(dirfd,&st)!=0 || !DCLCheckOwner(&st,1)){err=EPERM;goto failed;}
    phase=3;
    int existed=fstatat(dirfd,name,&st,AT_SYMLINK_NOFOLLOW)==0;
    if(existed && !DCLCheckOwner(&st,0)){err=EPERM;goto failed;}
    if(!existed && errno!=ENOENT){err=errno;goto failed;}
    // Preserve first known-good pre-DuoCar54 state, never overwrite that backup.
    if(existed) {
        snprintf(backup,sizeof(backup),"%s.duocar54-previous.bak",name);
        if(fstatat(dirfd,backup,&st,AT_SYMLINK_NOFOLLOW)==0) {
            if(!DCLCheckOwner(&st,0)){err=EPERM;goto failed;}
        } else if(errno==ENOENT) {
            if(linkat(dirfd,name,dirfd,backup,0)!=0){err=errno;goto failed;}
        } else {err=errno;goto failed;}
    }
    phase=4;
    struct timespec tick={0,0};clock_gettime(CLOCK_REALTIME,&tick);
    for(int attempt=0;attempt<8;attempt++) {
        snprintf(temp,sizeof(temp),".layout-v1.json.dc54.%ld.%ld.%d",
                 (long)getpid(),(long)tick.tv_nsec,attempt);
        fd=openat(dirfd,temp,O_WRONLY|O_CREAT|O_EXCL|O_NOFOLLOW|O_CLOEXEC,0600);
        if(fd>=0)break;
        if(errno!=EEXIST){err=errno;goto failed;}
    }
    if(fd<0){err=EEXIST;goto failed;}
    if(DCLWriteAll(fd,bytes,count)!=0){err=errno?errno:EIO;goto failed;}
    if(fsync(fd)!=0){err=errno;goto failed;}
    if(close(fd)!=0){fd=-1;err=errno;goto failed;}
    fd=-1;
    phase=5;
    if(renameat(dirfd,temp,dirfd,name)!=0){err=errno;goto failed;}
    committed=1;
    // APFS may not support syncing directory descriptors; the file itself
    // was fsync'ed before rename. Verify the exact bytes regardless.
    int dirsync=fsync(dirfd);
    int dirsyncError=dirsync<0?errno:0;
    phase=6;
    if(DCLVerify(dirfd,name,bytes,count)!=0){err=errno?errno:EIO;goto failed;}
    if(dirsyncError && dirsyncError!=EINVAL && dirsyncError!=ENOTSUP) {
        // The data was committed and read back. Caller logs durability warning.
        if(savedErrno)*savedErrno=dirsyncError;
    }
    if(stage)*stage=0;
    close(dirfd);
    return 1;
failed:
    if(fd>=0)close(fd);
    if(dirfd>=0){if(!committed && temp[0])unlinkat(dirfd,temp,0);close(dirfd);}
    if(stage)*stage=phase;
    if(savedErrno)*savedErrno=err?err:EIO;
    return 0;
}
