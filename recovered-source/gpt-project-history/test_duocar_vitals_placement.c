// Portable regression harness for the exact first-party CarPlay placement C.
#include "SCPVitalsPlacement.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>

static int overlaps(SCPVitalsRect a, SCPVitalsRect b) {
    return a.x < b.x + b.w && b.x < a.x + a.w &&
           a.y < b.y + b.h && b.y < a.y + a.h;
}
static int inside(SCPVitalsRect a, SCPVitalsRect b) {
    return a.x >= b.x && a.y >= b.y &&
           a.x + a.w <= b.x + b.w && a.y + a.h <= b.y + b.h;
}
static void check(SCPVitalsLayoutInput in, int expected, int expectedRail) {
    static int cases;
    SCPVitalsLayoutResult got = SCPVitalsPlace(in);
    if (got.valid != expected || (expected && got.railIndex != expectedRail)) {
        fprintf(stderr, "case=%d expected=%d/%d actual=%d/%d\n",
                cases, expected, expectedRail, got.valid, got.railIndex);
        assert(0);
    }
    if (got.valid) {
        assert(inside(got.frame,in.root));
        assert(!overlaps(got.frame,in.app));
        assert(!overlaps(got.frame,in.dock));
        for (size_t i=0; i<in.exclusionCount; i++)
            assert(!overlaps(got.frame,in.exclusions[i]));
    }
    cases++;
}
int main(void) {
    SCPVitalsLayoutInput in={0};
    in.root=(SCPVitalsRect){0,0,640,360};
    in.app=(SCPVitalsRect){54,0,586,360};
    in.dock=(SCPVitalsRect){0,0,54,230};
    in.exclusions[0]=(SCPVitalsRect){0,310,54,50};
    in.exclusionCount=1;check(in,1,0);
    in.dock=(SCPVitalsRect){0,0,54,311};check(in,0,0);
    in.dock=(SCPVitalsRect){0,0,54,220};
    in.exclusions[0]=(SCPVitalsRect){0,270,54,90};check(in,0,0);
    in.dock=(SCPVitalsRect){0,0,54,190};
    in.exclusions[0]=(SCPVitalsRect){0,295,54,65};check(in,1,0);
    in.dock=(SCPVitalsRect){0,0,54,160};
    in.exclusions[0]=(SCPVitalsRect){0,250,54,70};check(in,1,0);
    in.app=(SCPVitalsRect){0,0,586,360};
    in.dock=(SCPVitalsRect){586,0,54,210};
    in.exclusions[0]=(SCPVitalsRect){586,310,54,50};check(in,1,1);
    in.app=(SCPVitalsRect){0,48,640,312};
    in.dock=(SCPVitalsRect){0,0,150,48};
    in.exclusions[0]=(SCPVitalsRect){580,0,60,48};check(in,1,2);
    in.app=(SCPVitalsRect){0,0,640,310};
    in.dock=(SCPVitalsRect){0,310,150,50};
    in.exclusions[0]=(SCPVitalsRect){585,310,55,50};check(in,1,3);
    in.app=in.root;check(in,0,0);
    in.app=(SCPVitalsRect){54,0,586,360};
    in.dock=(SCPVitalsRect){NAN,0,54,210};check(in,0,0);
    in.dock=(SCPVitalsRect){0,0,54,210};
    in.app=(SCPVitalsRect){-3,0,640,360};check(in,0,0);
    in.app=(SCPVitalsRect){54,0,586,360};
    in.exclusionCount=5;check(in,0,0);

    // 25,000 property checks. This does not prove CarPlay native geometry,
    // but proves that every valid result avoids the supplied obstacles.
    unsigned seed=0x1234beef;
    for (int i=0; i<25000; i++) {
        seed=seed*1664525u+1013904223u;
        int side=(int)(seed&3u);
        double gap=42.0+(seed%32u);
        SCPVitalsLayoutInput f={0};
        f.root=(SCPVitalsRect){0,0,640,360};
        if(side==0){f.app=(SCPVitalsRect){gap,0,640-gap,360};f.dock=(SCPVitalsRect){0,0,gap,(double)(100+(seed%260u))};}
        if(side==1){f.app=(SCPVitalsRect){0,0,640-gap,360};f.dock=(SCPVitalsRect){640-gap,0,gap,(double)(100+(seed%260u))};}
        if(side==2){f.app=(SCPVitalsRect){0,gap,640,360-gap};f.dock=(SCPVitalsRect){0,0,(double)(50+(seed%520u)),gap};}
        if(side==3){f.app=(SCPVitalsRect){0,0,640,360-gap};f.dock=(SCPVitalsRect){0,360-gap,(double)(50+(seed%520u)),gap};}
        seed=seed*1664525u+1013904223u;
        if(side<2)f.exclusions[0]=(SCPVitalsRect){f.dock.x,f.root.h-(seed%120u),gap,45};
        else f.exclusions[0]=(SCPVitalsRect){f.root.w-(seed%140u),f.dock.y,45,gap};
        f.exclusionCount=1;
        SCPVitalsLayoutResult got=SCPVitalsPlace(f);
        if(got.valid) {
            assert(inside(got.frame,f.root));
            assert(!overlaps(got.frame,f.app));
            assert(!overlaps(got.frame,f.dock));
            assert(!overlaps(got.frame,f.exclusions[0]));
        }
    }
    // [fs-vitals] Clock pill is forbidden unless a FULLSCREEN SETTLE is confirmed.
    SCPVitalsRect screen={0,0,640,360};
    SCPVitalsLayoutResult bubble=SCPVitalsFullscreenBubblePlace(screen,0,0,0);
    assert(!bubble.valid);
    bubble=SCPVitalsFullscreenBubblePlace(screen,0,0,1);
    assert(bubble.valid && bubble.railIndex==-1 && bubble.horizontal);
    assert(inside(bubble.frame,screen));
    assert(bubble.frame.w==258.0 && bubble.frame.h==38.0);
    assert(bubble.frame.x==373.0 && bubble.frame.y==9.0);
    screen=(SCPVitalsRect){-45,0,640,360};
    bubble=SCPVitalsFullscreenBubblePlace(screen,20,35,1);
    assert(bubble.valid && bubble.frame.x==293.0 && bubble.frame.y==29.0);
    assert(inside(bubble.frame,screen));
    assert(!SCPVitalsFullscreenBubblePlace((SCPVitalsRect){0,0,210,80},0,0,1).valid);
    assert(!SCPVitalsFullscreenBubblePlace((SCPVitalsRect){0,0,640,360},330,0,1).valid);
    assert(!SCPVitalsFullscreenBubblePlace((SCPVitalsRect){0,0,640,360},0,630,1).valid);
    assert(!SCPVitalsFullscreenBubblePlace((SCPVitalsRect){0,0,640,360},-1,0,1).valid);
    assert(!SCPVitalsFullscreenBubblePlace((SCPVitalsRect){0,0,640,360},NAN,0,1).valid);
    assert(!SCPVitalsFullscreenBubblePlace((SCPVitalsRect){0,0,NAN,360},0,0,1).valid);
    // Deterministic fuzz of window origins, display sizes and safe insets.
    for(int n=0;n<25000;n++){
        seed=seed*1664525u+1013904223u;
        double width=160.0+(double)(seed%1100u);
        seed=seed*1664525u+1013904223u;
        double height=40.0+(double)(seed%480u);
        seed=seed*1664525u+1013904223u;
        double origin=(double)((int)(seed%140u)-70);
        seed=seed*1664525u+1013904223u;
        double top=(double)(seed%130u);
        seed=seed*1664525u+1013904223u;
        double right=(double)(seed%160u);
        SCPVitalsRect root={origin,0,width,height};
        SCPVitalsLayoutResult visible=SCPVitalsFullscreenBubblePlace(root,top,right,1);
        SCPVitalsLayoutResult hidden=SCPVitalsFullscreenBubblePlace(root,top,right,0);
        assert(!hidden.valid);
        if(visible.valid){
            assert(inside(visible.frame,root));
            assert(visible.frame.w >= 198.0 && visible.frame.h == 38.0);
            assert(visible.frame.x + visible.frame.w <= root.x + root.w-right);
            assert(visible.frame.y >= root.y + top);
        }
    }
    puts("PASS: 12 rail cases + 25,000 rail checks; 9 fullscreen cases + 25,000 fullscreen checks");
    return 0;
}
