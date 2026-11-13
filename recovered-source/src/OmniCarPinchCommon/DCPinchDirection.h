// DuoCar directional pinch contract (HL53, 2026-11-14).
// Shared between the CarPlay host and hosted-app relay. This is a
// pure-C calculation: no UIKit events, windows or fullscreen ownership.
#ifndef DCPINCH_DIRECTION_H
#define DCPINCH_DIRECTION_H
#include <math.h>
typedef enum {
    DCPinchNone = 0,
    DCPinchOut = 1,  // increase distance = zoom IN / expand fullscreen
    DCPinchIn = 2    // decrease distance = zoom OUT / restore split
} DCPinchDirection;
static inline DCPinchDirection DCPinchDirectionForMotion(
    double initialDistance, double currentDistance, double midpointDrift)
{
    if (!isfinite(initialDistance) || !isfinite(currentDistance) ||
        !isfinite(midpointDrift) || initialDistance < 26.0 ||
        currentDistance <= 0.0 || midpointDrift < 0.0)
        return DCPinchNone;
    double delta = fabs(currentDistance - initialDistance);
    if (delta < 12.0 || midpointDrift > 0.6 * delta + 10.0)
        return DCPinchNone;
    double ratio = currentDistance / initialDistance;
    if (ratio >= 1.10) return DCPinchOut;
    if (ratio <= 0.90) return DCPinchIn;
    return DCPinchNone;
}
#endif
