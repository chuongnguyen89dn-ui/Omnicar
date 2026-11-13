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
    printf("HL53_DIRECTIONAL_PINCH_MATH_PASS 20 independent cases\n");
    return 0;
}
