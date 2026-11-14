#include "DCLLeStoreWire.h"
#include "DCLLeStateWriter.h"
#include <assert.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

int main(void){
    assert(DCLLeFrame(DCL_LE_MAGIC_REQ,DCL_LE_BEGIN,0x1234,0x56789abc)==UINT64_C(0xd401123456789abc));
    assert(DCLLeMagic(UINT64_C(0xd401123456789abc))==DCL_LE_MAGIC_REQ);
    assert(DCLLeOp(UINT64_C(0xd401123456789abc))==DCL_LE_BEGIN);
    assert(DCLLeSeq(UINT64_C(0xd401123456789abc))==0x1234);
    assert(DCLLePayload(UINT64_C(0xd401123456789abc))==0x56789abc);
    assert(DCLLeCRC32((const uint8_t *)"123456789",9)==0xcbf43926u);
    for(size_t n=1;n<=4;n++){
        const uint8_t a[4]={0,0xff,0x13,0x55};uint8_t b[4]={0};
        DCLLeUnword(DCLLeWord(a,n),b,n);assert(memcmp(a,b,n)==0);
    }
    char tmpl[]="/tmp/hl54-save-XXXXXX";
    char *base=mkdtemp(tmpl);assert(base);
    char dir[256],target[300],backup[330];
    snprintf(dir,sizeof(dir),"%s/prefs",base);
    snprintf(target,sizeof(target),"%s/layout-v1.json",dir);
    snprintf(backup,sizeof(backup),"%s/layout-v1.json.duocar54-previous.bak",dir);
    int stage=0,err=0;
    const uint8_t v1[]="{\"schemaVersion\":1,\"bubble\":{}}";
    const uint8_t v2[]="{\"schemaVersion\":1,\"bubble\":{\"scale\":1.1}}";
    assert(DCLLeWriteStateAtomically(dir,"layout-v1.json",v1,sizeof(v1)-1,&stage,&err)==1);
    assert(stage==0);
    assert(access(backup,F_OK)!=0);
    assert(DCLLeWriteStateAtomically(dir,"layout-v1.json",v2,sizeof(v2)-1,&stage,&err)==1);
    struct stat s1,s2;assert(stat(target,&s1)==0 && stat(backup,&s2)==0);
    assert(s1.st_ino!=s2.st_ino);
    char buf[256]={0};int fd=open(backup,O_RDONLY);assert(fd>=0);
    ssize_t n=read(fd,buf,sizeof(buf));close(fd);
    assert(n==(ssize_t)sizeof(v1)-1 && memcmp(buf,v1,n)==0);
    fd=open(target,O_RDONLY);assert(fd>=0);memset(buf,0,sizeof(buf));
    n=read(fd,buf,sizeof(buf));close(fd);
    assert(n==(ssize_t)sizeof(v2)-1 && memcmp(buf,v2,n)==0);
    // Read canonical bytes; never return fabricated default source.
    uint8_t retrieved[512]={0};size_t actual=0;
    assert(DCLLeReadState(dir,"layout-v1.json",retrieved,sizeof(retrieved),&actual,&stage,&err));
    assert(stage==0 && actual==sizeof(v2)-1 && memcmp(retrieved,v2,actual)==0);
    assert(!DCLLeReadState(dir,"other.json",retrieved,sizeof(retrieved),&actual,&stage,&err));
    assert(!DCLLeReadState(dir,"layout-v1.json",retrieved,4,&actual,&stage,&err));
    assert(actual==0);
    // Rejected malicious filename, unsafe mode, and symbolic directory.
    assert(!DCLLeWriteStateAtomically(dir,"other.json",v1,sizeof(v1)-1,&stage,&err));
    assert(chmod(dir,0777)==0);
    assert(!DCLLeWriteStateAtomically(dir,"layout-v1.json",v1,sizeof(v1)-1,&stage,&err));
    assert(!DCLLeReadState(dir,"layout-v1.json",retrieved,sizeof(retrieved),&actual,&stage,&err));
    assert(chmod(dir,0700)==0);
    char linkPath[256];snprintf(linkPath,sizeof(linkPath),"%s/symlink",base);
    assert(symlink(dir,linkPath)==0);
    assert(!DCLLeWriteStateAtomically(linkPath,"layout-v1.json",v1,sizeof(v1)-1,&stage,&err));
    assert(!DCLLeReadState(linkPath,"layout-v1.json",retrieved,sizeof(retrieved),&actual,&stage,&err));
    // The old file is still original after all failed writes.
    fd=open(target,O_RDONLY);assert(fd>=0);memset(buf,0,sizeof(buf));
    n=read(fd,buf,sizeof(buf));close(fd);assert(n==(ssize_t)sizeof(v2)-1 && memcmp(buf,v2,n)==0);
    assert(unlink(linkPath)==0);assert(unlink(target)==0);assert(unlink(backup)==0);
    assert(rmdir(dir)==0);assert(rmdir(base)==0);
    puts("HL54 C wire + owner-safe writer: PASS");
}
