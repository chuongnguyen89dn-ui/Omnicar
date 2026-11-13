// Independent input/output cases for DuoCar HL53's shared pinch detector.
// Compile as portable C (no UIKit, no Theos) before building ARM slices.
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include "../../project/OmniCarPinchCommon/DCPinchDirection.h"
static void expect(double start,double end,double drift,DCPinchDirection want) {
    DCPinchDirection got=DCPinchDirectionForMotion(start,end,drift);
    if(got!=want) {
        fprintf(stderr,"pinch case d0=%.2f d1=%.2f drift=%.2f got=%d want=%d\n",
                start,end,drift,got,want);
    }
    assert(got==want);
}
// Derive both distances from actual 2D finger coordinates, exactly as
// CarPlay SCPHostPinchDistance() and hosted ABInApp's hypot(dx,dy).
static void expectPoints(double ax,double ay,double bx,double by,
                         double nextAx,double nextAy,double nextBx,double nextBy,
                         DCPinchDirection want) {
    double d0=hypot(bx-ax,by-ay),d1=hypot(nextBx-nextAx,nextBy-nextAy);
    double midX=(ax+bx)*0.5,midY=(ay+by)*0.5;
    double nextMidX=(nextAx+nextBx)*0.5;
    double nextMidY=(nextAy+nextBy)*0.5;
    double drift=hypot(nextMidX-midX,nextMidY-midY);
    expect(d0,d1,drift,want);
}
int main(void) {
    // Stationary two fingers, taps and small jitter must never toggle.
    expect(100,100,0,DCPinchNone);
    expect(100,104,0,DCPinchNone);
    expect(100,96,0,DCPinchNone);
    expect(25,60,0,DCPinchNone);
    // Physical opening of two fingers is always OUT regardless of state.
    expect(100,120,0,DCPinchOut);
    expect(100,155,10,DCPinchOut);
    expect(120,132,0,DCPinchOut); // 10% and >=12 points exactly
    // Closing is always IN.
    expect(100,80,0,DCPinchIn);
    expect(160,130,8,DCPinchIn);
    expect(120,108,0,DCPinchIn);
    // A two-finger slide across the pane is not a scale gesture.
    expect(100,130,55,DCPinchNone);
    expect(100,72,60,DCPinchNone);
    expect(50,60,0,DCPinchNone);  // <12 pt though >=10%
    expect(200,212,0,DCPinchNone); // 12 pt but <10%
    expect(200,188,0,DCPinchNone);
    // Invalid or degenerate touch geometry cannot fire.
    expect(NAN,120,0,DCPinchNone);
    expect(100,INFINITY,0,DCPinchNone);
    expect(100,120,NAN,DCPinchNone);
    expect(100,120,-1,DCPinchNone);
    expect(0,20,0,DCPinchNone);
    // Test the full 360 degrees: left/right, up/down, diagonals and
    // rotations of the physical CarPlay display. Identical rules apply
    // when two finger identities are swapped.
    const double pi=acos(-1.0);
    for(int k=0;k<8;k++) {
        double a=(double)k*pi/4.0;
        double ux=cos(a),uy=sin(a);
        double cx=213.5,cy=120.0;
        double ax=cx-50*ux,ay=cy-50*uy;
        double bx=cx+50*ux,by=cy+50*uy;
        expectPoints(ax,ay,bx,by,
                     cx-70*ux,cy-70*uy,cx+70*ux,cy+70*uy,
                     DCPinchOut);
        expectPoints(ax,ay,bx,by,
                     cx-30*ux,cy-30*uy,cx+30*ux,cy+30*uy,
                     DCPinchIn);
        // Swapping the physical left/right or upper/lower finger
        // cannot change the direction of the gesture.
        expectPoints(bx,by,ax,ay,
                     cx+70*ux,cy+70*uy,cx-70*ux,cy-70*uy,
                     DCPinchOut);
        expectPoints(bx,by,ax,ay,
                     cx+30*ux,cy+30*uy,cx-30*ux,cy-30*uy,
                     DCPinchIn);
        // Parallel two-finger pan, at any angle, is NOT pinch.
        expectPoints(ax,ay,bx,by,
                     ax+18*ux-27*uy,ay+18*uy+27*ux,
                     bx+18*ux-27*uy,by+18*uy+27*ux,
                     DCPinchNone);
    }
    printf("HL53_DIRECTIONAL_PINCH_MATH_PASS 60 cases incl all 8 compass directions, swapped fingers and parallel slides\n");
    return 0;
}
