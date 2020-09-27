#ifndef _GET_DISTANCE
#define _GET_DISTANCE

#include "Adafruit_VL53L0X.h"

extern int distanceMaxRetry;
extern int distanceRetryDelay;
extern boolean debugDistance;
extern int distanceFov;
extern int preMeasureDelay;

void initDistance();
int getDistance(boolean debugDistance);


#endif
