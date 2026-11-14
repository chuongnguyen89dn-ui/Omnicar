#include "../../project/OmniCarSplitScreen/SCPThermalAlarm.h"
#include <assert.h>
#include <stdio.h>
int main(void) {
    SCPThermalAlarmState s={0};
    assert(!SCPThermalAlarmStep(&s,36.99,1,0,1));
    assert( SCPThermalAlarmStep(&s,37.00,1,0,2)); // triggers at 37
    assert( SCPThermalAlarmStep(&s,40.00,1,0,5)); // persists
    assert( SCPThermalAlarmStep(&s,37.01,1,0,8));
    assert(!SCPThermalAlarmStep(&s,36.90,1,0,11)); // below threshold stops
    assert( SCPThermalAlarmStep(&s,NAN,0,1,12)); // test ON, no sensor
    assert(s.active && s.simulated && !s.realHot);
    assert(!SCPThermalAlarmStep(&s,NAN,0,0,13)); // test OFF stops
    assert( SCPThermalAlarmStep(&s,38.00,1,1,14)); // test + real
    assert( SCPThermalAlarmStep(&s,38.00,1,0,15)); // test OFF, real remains
    assert(!SCPThermalAlarmStep(&s,30.00,1,0,16));
    assert(!SCPThermalAlarmStep(&s,67.00,1,0,17)); // reject implausible
    assert( SCPThermalAlarmStep(&s,37.00,1,0,18)); // new high again
    puts("HL60_THERMAL_37C_PERSISTENT_AND_SIM_PASS");
    return 0;
}
