#ifndef _GET_DISTANCE
#define _GET_DISTANCE

#include <Arduino.h>

extern int distanceMaxRetry;
extern int distanceRetryDelay;
extern bool debugDistance;
extern int distanceFov;
extern int preMeasureDelay;
extern int distanceNumAveraging;

void initDistance();
int getDistance(bool debugDistance);

enum SensorTypes {
  ULTRASONIC,
  LIDAR_LITE,
  TF_LUNA
};
extern SensorTypes sensorType;
String sensorType2String( SensorTypes sensorType );

#endif
