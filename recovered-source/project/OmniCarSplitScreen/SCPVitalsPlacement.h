// Independent, host-testable layout logic for the CarPlay vitals badge.
// All inputs are expressed in the same parent-view coordinate system.
#ifndef SCP_VITALS_PLACEMENT_H
#define SCP_VITALS_PLACEMENT_H
#include <stddef.h>
#define SCP_VITALS_MAX_EXCLUSIONS 4

typedef struct { double x, y, w, h; } SCPVitalsRect;
typedef struct {
    SCPVitalsRect root;
    SCPVitalsRect app;
    SCPVitalsRect dock;
    SCPVitalsRect exclusions[SCP_VITALS_MAX_EXCLUSIONS];
    size_t exclusionCount;
} SCPVitalsLayoutInput;
typedef struct {
    SCPVitalsRect frame;
    int valid;
    int horizontal;
    int railIndex;  // 0 left, 1 right, 2 top, 3 bottom
} SCPVitalsLayoutResult;
SCPVitalsLayoutResult SCPVitalsPlace(SCPVitalsLayoutInput input);

// Fullscreen bubble: place only in confirmed, full-host presentation.
// Returns valid=0 otherwise; the old Dock rail layout is not used here.
SCPVitalsLayoutResult SCPVitalsFullscreenBubblePlace(SCPVitalsRect parentBounds,
                                                    double safeTop,
                                                    double safeRight,
                                                    int fullscreenConfirmed);

// Single fullscreen bubble interaction geometry (no UIKit dependency).
// Point coordinates and safe insets are in one CarPlay overlay window.
typedef struct { double x, y; } SCPVitalsPoint;
typedef struct { double top, right, bottom, left; } SCPVitalsSafeInsets;
// An invalid/too-small bounds returns {NAN,NAN}, never a spill outside screen.
SCPVitalsPoint SCPVitalsBubbleBoundCenter(SCPVitalsRect bounds,
    SCPVitalsSafeInsets safe, double width, double height, double margin,
    SCPVitalsPoint proposed);
SCPVitalsPoint SCPVitalsBubbleEdgeCenter(SCPVitalsRect bounds,
    SCPVitalsSafeInsets safe, double width, double height, double margin,
    int leftEdge, double normalizedY);
double SCPVitalsBubbleRelativeY(SCPVitalsRect bounds,
    SCPVitalsSafeInsets safe, double width, double height, double margin,
    double centerY);
int SCPVitalsBubbleNearestLeft(SCPVitalsRect bounds, double centerX);
#endif
