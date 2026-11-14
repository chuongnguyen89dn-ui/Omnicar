#ifndef SCP_THERMAL_ALARM_H
#define SCP_THERMAL_ALARM_H
#include <math.h>

// HL55 thermal warning is driven only by a plausible numeric SAMPLE.
// This is a red, time-limited safety overlay, never a fullscreen scene owner.
// Do not reinterpret NSProcessInfo.thermalState as degrees Celsius.
typedef struct {
    unsigned int consecutiveHot;
    int armed;
    double lastSampleTime;
} SCPThermalAlarmState;
static inline int SCPThermalAlarmStep(SCPThermalAlarmState *s,
                                     double tempC, int validSample,
                                     double now) {
    if (!s || !isfinite(now)) return 0;
    if (!isfinite(tempC) || !validSample ||
        tempC < 15.0 || tempC > 65.0) {
        s->consecutiveHot=0;
        return 0;
    }
    if (s->lastSampleTime > now || now-s->lastSampleTime > 35.0)
        s->consecutiveHot=0;
    s->lastSampleTime=now;
    if (tempC <= 37.5) {
        s->armed=1;
        s->consecutiveHot=0;
        return 0;
    }
    if (tempC < 39.0) {
        s->consecutiveHot=0;
        return 0;
    }
    if (s->consecutiveHot<2)s->consecutiveHot++;
    if (s->consecutiveHot>=2 && s->armed) {
        s->armed=0; // one warning per thermal excursion, no driving distraction loop
        return 1;
    }
    return 0;
}
#endif
