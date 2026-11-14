#ifndef DCL_LE_STORE_WIRE_H
#define DCL_LE_STORE_WIRE_H
#include <stdint.h>
#include <stddef.h>
#define DCL_LE_RAW_REQ "com.chuong.duocar/le024.raw.v1"
#define DCL_LE_RAW_ACK "com.chuong.duocar/le024.raw.ack.v1"
#define DCL_LE_RAW_INFO "com.chuong.duocar/le024.raw.info.v1"
#define DCL_LE_RAW_WORD "com.chuong.duocar/le024.raw.word.v1"
#define DCL_LE_RAW_CRC  "com.chuong.duocar/le024.raw.crc.v1"
#define DCL_LE_RAW_LIMIT 16384u
#define DCL_LE_MAGIC_REQ 0xd4u
#define DCL_LE_MAGIC_ACK 0xa4u
enum { DCL_LE_BEGIN=1, DCL_LE_DATA=2, DCL_LE_FINISH=3, DCL_LE_CANCEL=4,
       DCL_LE_READ_BEGIN=5, DCL_LE_READ_DATA=6, DCL_LE_READ_END=7 };
enum { DCL_LE_OK=0, DCL_LE_BUSY=1, DCL_LE_SEQUENCE=2, DCL_LE_SIZE=3,
       DCL_LE_CHECKSUM=4, DCL_LE_JSON=5, DCL_LE_OWNER=6,
       DCL_LE_IO=7, DCL_LE_EXPIRED=8 };
static inline uint64_t DCLLeFrame(uint8_t magic,uint8_t op,uint16_t seq,uint32_t payload) {
    return ((uint64_t)magic<<56)|((uint64_t)op<<48)|((uint64_t)seq<<32)|payload;
}
static inline uint8_t DCLLeMagic(uint64_t f){ return (uint8_t)(f>>56); }
static inline uint8_t DCLLeOp(uint64_t f){ return (uint8_t)(f>>48); }
static inline uint16_t DCLLeSeq(uint64_t f){ return (uint16_t)(f>>32); }
static inline uint32_t DCLLePayload(uint64_t f){ return (uint32_t)f; }
static inline uint32_t DCLLeWord(const uint8_t *data,size_t count) {
    uint32_t v=0;
    for(size_t i=0;i<4;i++)v=(v<<8)|(i<count?data[i]:0);
    return v;
}
static inline void DCLLeUnword(uint32_t v,uint8_t *out,size_t count) {
    for(size_t i=0;i<count;i++)out[i]=(uint8_t)(v>>(24-8*i));
}
static inline uint32_t DCLLeCRC32(const uint8_t *bytes,size_t len) {
    uint32_t crc=0xffffffffu;
    for(size_t i=0;i<len;i++) {
        crc^=bytes[i];
        for(unsigned bit=0;bit<8;bit++)crc=(crc>>1)^((crc&1u)?0xedb88320u:0u);
    }
    return ~crc;
}
#endif
