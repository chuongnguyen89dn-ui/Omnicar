// HL54 clock bubble: test the EXACT CarPlay placement functions.
#include "SCPVitalsPlacement.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdint.h>

static unsigned checks=0;
static void roundtrip(SCPVitalsRect r,SCPVitalsSafeInsets safe,
                      SCPVitalsPoint proposed) {
    SCPVitalsBubbleDockPosition placement;
    SCPVitalsPoint drop,reloaded;
    int ok=SCPVitalsBubbleSelectDockPosition(r,safe,258,38,3,38,
                                           proposed,&placement,&drop);
    if(ok){
        assert(SCPVitalsBubbleRestoreDockPosition(r,safe,258,38,3,
                                                  placement,&reloaded));
        assert(fabs(drop.x-reloaded.x)<1e-8 && fabs(drop.y-reloaded.y)<1e-8);
        assert(placement.normalizedX>=0 && placement.normalizedX<=1);
        assert(placement.normalizedY>=0 && placement.normalizedY<=1);
        double low=r.x+safe.left+3+129,high=r.x+r.w-safe.right-3-129;
        if(placement.docked)
            assert(fabs(drop.x-(placement.leftEdge?low:high))<1e-8);
        else
            assert(drop.x>low && drop.x<high);
    }
    checks++;
}
int main(void){
    SCPVitalsRect screen={0,0,640,360};
    SCPVitalsSafeInsets safe={20,10,12,10};
    SCPVitalsPoint destination;
    SCPVitalsBubbleDockPosition placement;

    // Safe center range x=142..498, y=42..326 for a 258x38 pill.
    assert(SCPVitalsBubbleSelectDockPosition(screen,safe,258,38,3,38,
        (SCPVitalsPoint){145,200},&placement,&destination));
    assert(placement.docked && placement.leftEdge && destination.x==142);
    checks++;
    assert(SCPVitalsBubbleSelectDockPosition(screen,safe,258,38,3,38,
        (SCPVitalsPoint){494,300},&placement,&destination));
    assert(placement.docked && !placement.leftEdge && destination.x==498);
    checks++;
    assert(SCPVitalsBubbleSelectDockPosition(screen,safe,258,38,3,38,
        (SCPVitalsPoint){307,216},&placement,&destination));
    assert(!placement.docked && destination.x==307 && destination.y==216);
    checks++;
    assert(SCPVitalsBubbleRestoreDockPosition(screen,safe,258,38,3,
        placement,&destination));
    assert(fabs(destination.x-307)<1e-9 && fabs(destination.y-216)<1e-9);
    checks++;
    assert(!SCPVitalsBubbleSelectDockPosition(screen,safe,258,38,3,-1,
        (SCPVitalsPoint){307,216},&placement,&destination));
    assert(!SCPVitalsBubbleSelectDockPosition(screen,safe,258,38,3,38,
        (SCPVitalsPoint){NAN,216},&placement,&destination));
    checks+=2;

    // Compact CarPlay 427x240 still has a real free middle region.
    screen=(SCPVitalsRect){0,0,427,240};
    safe=(SCPVitalsSafeInsets){0,0,0,0};
    assert(SCPVitalsBubbleSelectDockPosition(screen,safe,258,38,3,38,
        (SCPVitalsPoint){213.5,100},&placement,&destination));
    assert(!placement.docked);
    checks++;

    // Deterministic 30,000 size, inset, origin, and drag releases.
    uint32_t seed=0x12345678u;
    for(int i=0;i<30000;i++){
        seed=seed*1664525u+1013904223u;
        double w=280+(seed%1000u);
        seed=seed*1664525u+1013904223u;
        double h=90+(seed%500u);
        seed=seed*1664525u+1013904223u;
        double x=(double)((int)(seed%200u)-100);
        seed=seed*1664525u+1013904223u;
        double y=(double)((int)(seed%200u)-100);
        SCPVitalsRect box={x,y,w,h};
        SCPVitalsSafeInsets insets={5,10,5,5};
        seed=seed*1664525u+1013904223u;
        SCPVitalsPoint requested={x+(seed%1300u)-100,
                                  y+((seed>>8)%650u)-100};
        roundtrip(box,insets,requested);
    }
    printf("HL54_CLOCK_DOCK_GEOMETRY_PASS cases=%u\n",checks);
    return 0;
}
