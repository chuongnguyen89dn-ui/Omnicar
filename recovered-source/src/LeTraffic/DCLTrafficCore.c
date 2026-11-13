#include "DCLTrafficCore.h"
#include <math.h>
#include <stdio.h>

static double clamped(double n, double a, double b) {
    return fmin(b, fmax(a, n));
}
int DCLTrafficClampGpsOffset(int requested) {
    if (requested < -5) return -5;
    if (requested > 5) return 5;
    return requested;
}

// Matches the measured Le 0.2.4 GVMEncodeSample bit layout. This does NOT
// assert sample freshness; timestamp-base decoding is not yet verified.
int DCLTrafficDecodeLeSample(uint64_t packedState, int *valueKph) {
    if (!valueKph || !(packedState & (UINT64_C(1) << 9))) return 0;
    int n = (int)(packedState & UINT64_C(0x1ff));
    if (n < 0 || n > 400) return 0;
    *valueKph = n;
    return 1;
}

DCLTrafficReading DCLTrafficComputeReading(int hasSpeed, int rawSpeedKph,
    int hasLimit, int postedLimitKph, int gpsOffsetKph) {
    DCLTrafficReading result = {0};
    if (hasSpeed && rawSpeedKph >= 0 && rawSpeedKph <= 400) {
        result.hasSpeed = 1;
        result.rawSpeedKph = rawSpeedKph;
        int corrected = rawSpeedKph + DCLTrafficClampGpsOffset(gpsOffsetKph);
        result.correctedSpeedKph = corrected < 0 ? 0 : (corrected > 400 ? 400 : corrected);
    }
    if (hasLimit && postedLimitKph >= 0 && postedLimitKph <= 400) {
        result.hasLimit = 1;
        result.postedLimitKph = postedLimitKph;
    }
    result.overspeed = result.hasSpeed && result.hasLimit &&
        result.correctedSpeedKph > result.postedLimitKph;
    return result;
}

int DCLTrafficFormatSpeedNumber(const DCLTrafficReading *reading,
    char *text, size_t capacity) {
    if (!reading || !text || capacity == 0) return 0;
    int chars = reading->hasSpeed
        ? snprintf(text, capacity, "%d", reading->correctedSpeedKph)
        : snprintf(text, capacity, "--");
    return chars >= 0 && (size_t)chars < capacity;
}

static int bounds(DCLTrafficRect r, DCLTrafficInsets s,
    double w, double h, double margin,
    double *minX, double *maxX, double *minY, double *maxY) {
    if (!isfinite(r.x) || !isfinite(r.y) || !isfinite(r.width) || !isfinite(r.height) ||
        !isfinite(w) || !isfinite(h) || !isfinite(margin) ||
        !isfinite(s.top) || !isfinite(s.right) ||
        !isfinite(s.bottom) || !isfinite(s.left) ||
        r.width <= 0 || r.height <= 0 || w <= 0 || h <= 0 || margin < 0 ||
        s.top < 0 || s.right < 0 || s.bottom < 0 || s.left < 0) return 0;
    *minX = r.x + s.left + margin + w/2.;
    *maxX = r.x + r.width - s.right - margin - w/2.;
    *minY = r.y + s.top + margin + h/2.;
    *maxY = r.y + r.height - s.bottom - margin - h/2.;
    return *minX <= *maxX && *minY <= *maxY &&
        isfinite(*minX) && isfinite(*maxX) &&
        isfinite(*minY) && isfinite(*maxY);
}

int DCLTrafficClampCenter(DCLTrafficRect r, DCLTrafficInsets s,
    double w, double h, double margin,
    DCLTrafficPoint proposed, DCLTrafficPoint *out) {
    double minX, maxX, minY, maxY;
    if (!out || !isfinite(proposed.x) || !isfinite(proposed.y) ||
        !bounds(r,s,w,h,margin,&minX,&maxX,&minY,&maxY)) return 0;
    *out = (DCLTrafficPoint){clamped(proposed.x,minX,maxX),
                             clamped(proposed.y,minY,maxY)};
    return 1;
}
int DCLTrafficNormalizeCenter(DCLTrafficRect r, DCLTrafficInsets s,
    double w, double h, double margin,
    DCLTrafficPoint point, DCLTrafficPoint *out) {
    double minX, maxX, minY, maxY;
    if (!out || !isfinite(point.x) || !isfinite(point.y) ||
        !bounds(r,s,w,h,margin,&minX,&maxX,&minY,&maxY)) return 0;
    *out = (DCLTrafficPoint){maxX == minX ? 0.5 :
        clamped((point.x-minX)/(maxX-minX),0,1),
        maxY == minY ? 0.5 :
        clamped((point.y-minY)/(maxY-minY),0,1)};
    return 1;
}
int DCLTrafficRestoreCenter(DCLTrafficRect r, DCLTrafficInsets s,
    double w, double h, double margin,
    DCLTrafficPoint normalized, DCLTrafficPoint *out) {
    double minX, maxX, minY, maxY;
    if (!out || !isfinite(normalized.x) || !isfinite(normalized.y) ||
        !bounds(r,s,w,h,margin,&minX,&maxX,&minY,&maxY)) return 0;
    *out = (DCLTrafficPoint){minX + clamped(normalized.x,0,1) * (maxX-minX),
                             minY + clamped(normalized.y,0,1) * (maxY-minY)};
    return 1;
}
