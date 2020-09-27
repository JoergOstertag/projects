#ifndef _GET_DISTANCE
#define _GET_DISTANCE

#include "Adafruit_VL53L0X.h"

extern int distanceMaxRetry;
extern int distanceRetryDelay;
extern boolean debugDistance;

void initDistance();
int getDistance(boolean debugDistance);


#endif
