#include "../../project/OmniCarSplitScreen/SCPThermalAlarm.h"
#include <assert.h>
#include <stdio.h>
int main(void){
    SCPThermalAlarmState s={0};s.armed=1;
    assert(!SCPThermalAlarmStep(&s,39,0,1)); // unavailable -> not a number
    assert(!SCPThermalAlarmStep(&s,39,1,2)); // first high
    assert(SCPThermalAlarmStep(&s,39,1,6)); // second high
    for(int i=0;i<200;i++) assert(!SCPThermalAlarmStep(&s,45,1,10+i*4));
    assert(!SCPThermalAlarmStep(&s,37.6,1,812)); // hysteresis
    assert(!SCPThermalAlarmStep(&s,37.4,1,816)); // rearm
    assert(!SCPThermalAlarmStep(&s,39,1,820));
    assert(SCPThermalAlarmStep(&s,39,1,824));
    assert(!SCPThermalAlarmStep(&s,NAN,1,828));
    assert(!SCPThermalAlarmStep(&s,100,1,832));
    assert(!SCPThermalAlarmStep(&s,39,1,836));
    assert(!SCPThermalAlarmStep(&s,39,1,876)); // first high (gap)
    assert(!SCPThermalAlarmStep(&s,39,1,880)); // still disarmed
    assert(!SCPThermalAlarmStep(&s,30,1,884)); // rearm
    assert(!SCPThermalAlarmStep(&s,39,1,888));
    assert(SCPThermalAlarmStep(&s,39,1,892));
    printf("HL55_THERMAL_39C_DEBOUNCE_PASS\n");
    return 0;
}
