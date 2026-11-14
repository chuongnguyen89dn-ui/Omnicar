#ifndef SCP_THERMAL_ALARM_H
#define SCP_THERMAL_ALARM_H
#include <math.h>

// HL60: sustained warning, not a one-time pulse. A demo switch forces
// warning rendering only; it never changes the real sensor's temperature.
typedef struct {
    int active;
    int simulated;
    int realHot;
    double lastSampleTime;
} SCPThermalAlarmState;
static inline int SCPThermalAlarmStep(SCPThermalAlarmState *state,
                                     double tempC,int validSample,
                                     int simulate,double now) {
    if(!state || !isfinite(now))return 0;
    const int valid=validSample && isfinite(tempC) &&
                    tempC>=15.0 && tempC<=65.0;
    state->realHot=valid && tempC>=37.0;
    state->simulated=!!simulate;
    state->active=state->realHot || state->simulated;
    state->lastSampleTime=now;
    return state->active;
}
#endif
