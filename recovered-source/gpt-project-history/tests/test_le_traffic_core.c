#include "DCLTrafficCore.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>
int main(void) {
    int checks = 0;
    for (int offset = -15; offset <= 15; ++offset) {
        int c = DCLTrafficClampGpsOffset(offset);
        assert(c >= -10 && c <= 10);
        assert(c == (offset < -10 ? -10 : (offset > 10 ? 10 : offset)));
        ++checks;
    }
    DCLTrafficReading r = DCLTrafficComputeReading(1,60,1,80,3);
    assert(r.correctedSpeedKph == 63 && r.postedLimitKph == 80 && !r.overspeed);++checks;
    r = DCLTrafficComputeReading(1,60,1,80,10);
    assert(r.correctedSpeedKph == 70 && r.postedLimitKph == 80 && !r.overspeed);++checks;
    r = DCLTrafficComputeReading(1,60,1,80,-10);
    assert(r.correctedSpeedKph == 50 && r.postedLimitKph == 80 && !r.overspeed);++checks;
    r = DCLTrafficComputeReading(1,398,1,400,20);
    assert(r.correctedSpeedKph == 400 && r.postedLimitKph == 400);++checks;
    r = DCLTrafficComputeReading(1,1,1,30,-20);
    assert(r.correctedSpeedKph == 0 && r.postedLimitKph == 30);++checks;
    r = DCLTrafficComputeReading(1,60,1,80,-2);
    assert(r.correctedSpeedKph == 58 && r.postedLimitKph == 80);++checks;
    r = DCLTrafficComputeReading(1,81,1,80,-2);
    assert(r.correctedSpeedKph == 79 && !r.overspeed);++checks;
    r = DCLTrafficComputeReading(1,81,1,80,0);
    assert(r.overspeed);++checks;
    r = DCLTrafficComputeReading(0,0,1,80,5);
    assert(!r.hasSpeed && !r.overspeed);++checks;
    char s[16] = {0};
    assert(DCLTrafficFormatSpeedNumber(&r,s,sizeof(s)) && !strcmp(s,"--"));++checks;
    r = DCLTrafficComputeReading(1,88,1,80,5);
    assert(DCLTrafficFormatSpeedNumber(&r,s,sizeof(s)) && !strcmp(s,"93"));++checks;
    int val = -17;
    for(int v = 0;v <= 400;++v) {
        uint64_t encoded = (UINT64_C(1938471)<<10) | UINT64_C(512) | (uint64_t)v;
        assert(DCLTrafficDecodeLeSample(encoded,&val) && val == v);++checks;
    }
    assert(!DCLTrafficDecodeLeSample(0,&val));++checks;
    assert(!DCLTrafficDecodeLeSample(UINT64_C(512)|401,&val));++checks;
    assert(!DCLTrafficDecodeLeSample(UINT64_C(512)|200,NULL));++checks;
    DCLTrafficRect rect={0,0,640,360};
    DCLTrafficInsets insets={10,10,15,50};
    DCLTrafficPoint p,rel,back;
    for(int x = -50;x<=720;x+=13)for(int y=-50;y<=460;y+=17){
        assert(DCLTrafficClampCenter(rect,insets,112,52,6,(DCLTrafficPoint){x,y},&p));
        assert(DCLTrafficNormalizeCenter(rect,insets,112,52,6,p,&rel));
        assert(DCLTrafficRestoreCenter(rect,insets,112,52,6,rel,&back));
        assert(fabs(p.x-back.x)<1e-8 && fabs(p.y-back.y)<1e-8);checks+=3;
    }
    // [hl55-le-edge] both modes: free in middle, snap at physical safe side.
    DCLTrafficPoint snappedCenter;
    int snap=0;
    DCLTrafficInsets noInset={0,0,0,0};
    assert(DCLTrafficSnapWhenNearEdge(rect,noInset,112,52,0,32,
         (DCLTrafficPoint){317,200},&snappedCenter,&snap));
    assert(!snap && fabs(snappedCenter.x-317)<1e-9);++checks;
    assert(DCLTrafficSnapWhenNearEdge(rect,noInset,112,52,0,32,
         (DCLTrafficPoint){58,220},&snappedCenter,&snap));
    assert(snap && fabs(snappedCenter.x-56)<1e-9);++checks;
    assert(DCLTrafficSnapWhenNearEdge(rect,noInset,112,52,0,32,
         (DCLTrafficPoint){581,140},&snappedCenter,&snap));
    assert(snap && fabs(snappedCenter.x-584)<1e-9);++checks;
    assert(!DCLTrafficSnapWhenNearEdge(rect,noInset,112,52,0,-10,
         (DCLTrafficPoint){58,140},&snappedCenter,&snap));++checks;
    assert(DCLTrafficRestoreCenter(rect,insets,112,52,6,(DCLTrafficPoint){0.5,0.5},&p));
    assert(p.x > 200 && p.x < 450);++checks; // must NOT snap to an edge
    assert(!DCLTrafficClampCenter((DCLTrafficRect){0,0,20,20},insets,112,52,6,(DCLTrafficPoint){0,0},&p));++checks;
    assert(!DCLTrafficRestoreCenter(rect,insets,112,52,6,(DCLTrafficPoint){NAN,0},&p));++checks;
    puts("LE_TRAFFIC_CORE_PASS");printf("assertions=%d\n",checks);
    return 0;
}
