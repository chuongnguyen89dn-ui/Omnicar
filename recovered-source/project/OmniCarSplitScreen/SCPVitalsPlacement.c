#include "SCPVitalsPlacement.h"
#include <math.h>

static int ok(SCPVitalsRect r) {
    return isfinite(r.x) && isfinite(r.y) && isfinite(r.w) && isfinite(r.h) &&
           r.w > 0 && r.h > 0;
}
static int inside(SCPVitalsRect a, SCPVitalsRect outer) {
    return ok(a) && ok(outer) && a.x >= outer.x && a.y >= outer.y &&
           a.x + a.w <= outer.x + outer.w &&
           a.y + a.h <= outer.y + outer.h;
}
static int intersects(SCPVitalsRect a, SCPVitalsRect b) {
    return ok(a) && ok(b) && a.x < b.x + b.w && b.x < a.x + a.w &&
           a.y < b.y + b.h && b.y < a.y + a.h;
}
static SCPVitalsRect padded(SCPVitalsRect r, double p) {
    if (!ok(r)) return r;
    return (SCPVitalsRect){r.x-p,r.y-p,r.w+2*p,r.h+2*p};
}

// Search the complete free rail; never assume the Dock is unshifted, and
// never draw through the native Home button / launcher reserved rectangles.
SCPVitalsLayoutResult SCPVitalsPlace(SCPVitalsLayoutInput in) {
    SCPVitalsLayoutResult none = {0};
    if (!inside(in.app,in.root) || !inside(in.dock,in.root) ||
        in.exclusionCount > SCP_VITALS_MAX_EXCLUSIONS) return none;
    double left = in.app.x - in.root.x;
    double right = in.root.x + in.root.w - in.app.x - in.app.w;
    double top = in.app.y - in.root.y;
    double bottom = in.root.y + in.root.h - in.app.y - in.app.h;
    SCPVitalsRect rails[4] = {
        {in.root.x,in.root.y,left,in.root.h},
        {in.app.x+in.app.w,in.root.y,right,in.root.h},
        {in.root.x,in.root.y,in.root.w,top},
        {in.root.x,in.app.y+in.app.h,in.root.w,bottom}
    };
    SCPVitalsRect obstacles[1+SCP_VITALS_MAX_EXCLUSIONS];
    obstacles[0] = in.dock;
    for (size_t j=0;j<in.exclusionCount;j++) obstacles[j+1]=in.exclusions[j];
    const double margin=6.0, gap=5.0;
    for (int railIndex=0;railIndex<4;railIndex++) {
        SCPVitalsRect rail=rails[railIndex];
        if (!ok(rail) || !intersects(rail,in.dock)) continue;
        int horizontal=railIndex>=2;
        double badgeW=horizontal?124.0:fmin(rail.w-2*margin,64.0);
        double badgeH=horizontal?fmin(rail.h-2*margin,26.0):43.0;
        if (badgeW < (horizontal?105.0:39.0) || badgeH < (horizontal?22.0:40.0)) continue;
        double shortStart=horizontal ? rail.y+(rail.h-badgeH)/2.0
                                     : rail.x+(rail.w-badgeW)/2.0;
        double start=horizontal ? rail.x+margin : rail.y+margin;
        double maxStart=horizontal ? rail.x+rail.w-margin-badgeW
                                   : rail.y+rail.h-margin-badgeH;
        // Every failed position advances past an actual obstacle. The fixed
        // bound exceeds the number of obstacles, so no infinite relayout.
        for (int attempt=0;attempt<2+SCP_VITALS_MAX_EXCLUSIONS && start<=maxStart;attempt++) {
            SCPVitalsRect candidate=horizontal
                ? (SCPVitalsRect){start,shortStart,badgeW,badgeH}
                : (SCPVitalsRect){shortStart,start,badgeW,badgeH};
            double next=start;
            int collision=0;
            for (size_t j=0;j<1+in.exclusionCount;j++) {
                SCPVitalsRect obstacle=padded(obstacles[j],gap);
                if (!intersects(candidate,obstacle)) continue;
                collision=1;
                double after=horizontal?obstacle.x+obstacle.w:obstacle.y+obstacle.h;
                if (after>next) next=after;
            }
            if (!collision && !intersects(candidate,in.app))
                return (SCPVitalsLayoutResult){candidate,1,horizontal,railIndex};
            if (!collision || next<=start) break;
            start=next;
        }
    }
    return none;
}

// Standalone fullscreen pill in the parent's own coordinates, away from the
// upper/outer edge. It is NOT a Dock rail badge. A caller must pass a trusted
// fullscreen state (not merely a pinch begin or an inferred hidden icon).
SCPVitalsLayoutResult SCPVitalsFullscreenBubblePlace(SCPVitalsRect root,
                                                    double safeTop,
                                                    double safeRight,
                                                    int fullscreenConfirmed) {
    SCPVitalsLayoutResult none = {0};
    if (!fullscreenConfirmed || !ok(root) ||
        !isfinite(safeTop) || !isfinite(safeRight) ||
        safeTop < 0.0 || safeRight < 0.0) return none;
    const double margin = 9.0;
    const double height = 38.0;
    double available = root.w - 2.0 * margin - safeRight;
    if (available < 198.0 || root.h - safeTop < height + 2.0*margin)
        return none;
    double width = fmin(258.0,available);
    SCPVitalsRect r = {
        root.x + root.w - safeRight - margin - width,
        root.y + safeTop + margin,
        width,
        height
    };
    if (!inside(r,root)) return none;
    SCPVitalsLayoutResult result = {0};
    result.frame = r;
    result.valid = 1;
    result.horizontal = 1;
    result.railIndex = -1; // no native dock rail is used in fullscreen
    return result;
}
