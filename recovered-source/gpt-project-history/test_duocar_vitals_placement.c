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
    // HL31 gesture semantics adapted to a fullscreen information pill:
    // bounded free travel while dragging, side snap only when released,
    // normalized-Y persistence and safe-inset clamping.
    SCPVitalsSafeInsets safe={20,10,12,10};
    screen=(SCPVitalsRect){0,0,640,360};
    SCPVitalsPoint pos=SCPVitalsBubbleEdgeCenter(screen,safe,258,38,9,0,0.0);
    assert(pos.x==492 && pos.y==48);
    pos=SCPVitalsBubbleEdgeCenter(screen,safe,258,38,9,1,1.0);
    assert(pos.x==148 && pos.y==320);
    pos=SCPVitalsBubbleEdgeCenter(screen,safe,258,38,9,0,0.5);
    assert(pos.x==492 && pos.y==184);
    assert(SCPVitalsBubbleNearestLeft(screen,319.9));
    assert(!SCPVitalsBubbleNearestLeft(screen,320.0));
    pos=SCPVitalsBubbleBoundCenter(screen,safe,258,38,9,
                                   (SCPVitalsPoint){-400,999});
    assert(pos.x==148 && pos.y==320);
    pos=SCPVitalsBubbleBoundCenter(screen,safe,258,38,9,
                                   (SCPVitalsPoint){280,140});
    assert(pos.x==280 && pos.y==140);
    assert(SCPVitalsBubbleRelativeY(screen,safe,258,38,9,184)==0.5);
    assert(SCPVitalsBubbleRelativeY(screen,safe,258,38,9,-400)==0.0);
    assert(SCPVitalsBubbleRelativeY(screen,safe,258,38,9,1000)==1.0);
    pos=SCPVitalsBubbleEdgeCenter((SCPVitalsRect){0,0,200,360},
                                  safe,258,38,9,1,0.5);
    assert(!isfinite(pos.x) && !isfinite(pos.y));
    pos=SCPVitalsBubbleBoundCenter(screen,
                                  (SCPVitalsSafeInsets){NAN,0,0,0},
                                  258,38,9,(SCPVitalsPoint){100,100});
    assert(!isfinite(pos.x) && !isfinite(pos.y));
    // 25,000 reproducible randomized CarPlay bounds/insets/drags; this
    // exercise is geometry only, not actual UIKit touch routing.
    for(int n=0;n<25000;n++){
        seed=seed*1664525u+1013904223u;
        double w=210.0+(double)(seed%1000u);
        seed=seed*1664525u+1013904223u;
        double h=60.0+(double)(seed%700u);
        seed=seed*1664525u+1013904223u;
        double ox=(double)((int)(seed%180u)-90);
        seed=seed*1664525u+1013904223u;
        double oy=(double)((int)(seed%80u)-40);
        seed=seed*1664525u+1013904223u;
        SCPVitalsSafeInsets s={(double)(seed%110u),(double)((seed>>8)%100u),
                                (double)((seed>>16)%80u),(double)((seed>>24)%80u)};
        SCPVitalsRect box={ox,oy,w,h};
        seed=seed*1664525u+1013904223u;
        double pillW=198.0+(double)(seed%61u);
        seed=seed*1664525u+1013904223u;
        double fy=(double)(seed%1001u)/1000.0;
        SCPVitalsPoint right=SCPVitalsBubbleEdgeCenter(box,s,pillW,38,9,0,fy);
        SCPVitalsPoint left=SCPVitalsBubbleEdgeCenter(box,s,pillW,38,9,1,fy);
        SCPVitalsPoint center=SCPVitalsBubbleBoundCenter(
            box,s,pillW,38,9,
            (SCPVitalsPoint){box.x-500,box.y+box.h+500});
        int valid=isfinite(left.x) && isfinite(left.y);
        assert(valid==(isfinite(right.x) && isfinite(right.y)));
        assert(valid==(isfinite(center.x) && isfinite(center.y)));
        if(valid){
            double minX=box.x+s.left+9+pillW/2;
            double maxX=box.x+box.w-s.right-9-pillW/2;
            double minY=box.y+s.top+9+19;
            double maxY=box.y+box.h-s.bottom-9-19;
            assert(left.x==minX && right.x==maxX);
            assert(left.y>=minY && left.y<=maxY);
            assert(right.y>=minY && right.y<=maxY);
            assert(center.x>=minX && center.x<=maxX);
            assert(center.y>=minY && center.y<=maxY);
            double normalized=SCPVitalsBubbleRelativeY(box,s,pillW,38,9,left.y);
            assert(normalized>=0.0 && normalized<=1.0);
            assert(fabs(normalized-fy)<1e-9 || maxY==minY);
        }
    }
    puts("PASS: 12 rail cases + 25,000 rail; 9 fullscreen cases + 25,000 fullscreen; 12 drag cases + 25,000 drag");
    return 0;
}
