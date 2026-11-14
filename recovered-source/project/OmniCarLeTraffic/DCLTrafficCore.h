#ifndef DCL_TRAFFIC_CORE_H
#define DCL_TRAFFIC_CORE_H

#include <stdint.h>
#include <stddef.h>

// The two Le traffic notify samples (speed and posted speed limit) are
// independent; correction must NEVER be applied to the posted limit.
typedef struct {
    int hasSpeed;
    int rawSpeedKph;
    int correctedSpeedKph;
    int hasLimit;
    int postedLimitKph;
    int overspeed;
} DCLTrafficReading;

int DCLTrafficClampGpsOffset(int requested);
int DCLTrafficDecodeLeSample(uint64_t packedState, int *valueKph);
DCLTrafficReading DCLTrafficComputeReading(int hasSpeed, int rawSpeedKph,
    int hasLimit, int postedLimitKph, int gpsOffsetKph);
// UI speed piece must contain ONLY digits, or "--" for an absent sample.
int DCLTrafficFormatSpeedNumber(const DCLTrafficReading *reading,
    char *text, size_t capacity);

typedef struct { double x, y, width, height; } DCLTrafficRect;
typedef struct { double top, right, bottom, left; } DCLTrafficInsets;
typedef struct { double x, y; } DCLTrafficPoint;
// Never force edge snapping. Store BOTH normalized X and normalized Y.
int DCLTrafficClampCenter(DCLTrafficRect screen, DCLTrafficInsets safe,
    double bubbleWidth, double bubbleHeight, double margin,
    DCLTrafficPoint proposed, DCLTrafficPoint *result);
int DCLTrafficNormalizeCenter(DCLTrafficRect screen, DCLTrafficInsets safe,
    double bubbleWidth, double bubbleHeight, double margin,
    DCLTrafficPoint center, DCLTrafficPoint *normalized);
// HL55 snap only if dropped close to the LEFT/RIGHT usable edge.
// Keeps absolute Y within the same hit-testing surface as Lề itself.
int DCLTrafficSnapWhenNearEdge(DCLTrafficRect screen, DCLTrafficInsets safe,
    double bubbleWidth, double bubbleHeight, double margin, double threshold,
    DCLTrafficPoint dropped, DCLTrafficPoint *target, int *snapped);
int DCLTrafficRestoreCenter(DCLTrafficRect screen, DCLTrafficInsets safe,
    double bubbleWidth, double bubbleHeight, double margin,
    DCLTrafficPoint normalized, DCLTrafficPoint *result);

#endif
