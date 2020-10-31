#include "config.h"

#include "getDistance.h"

#include "getDistanceVl53L0X.h"
#include "getDistanceLidarLite.h"
#include <HCSR04.h>

UltraSonicDistanceSensor distanceSensor(D3, D4);


/**
   The Maximum Number of retries
*/
int distanceMaxRetry = 2;

/**
   If we need a retry we wait for this long
*/
int distanceRetryDelay = 20;

/**
   Field of View of the Distance Sensor
*/
int distanceFov = 20;

/**
   Print Debugging output for Distance on Serial Console
*/
bool debugDistance = false;


/**
   delay before measuring
*/
int preMeasureDelay = 10;

/**
   Number of Measurements to take for everagint
*/
int distanceNumAveraging = 3;




SensorTypes sensorType = LIDAR_LITE;

void initDistance() {
  switch ( sensorType ) {
    case ULTRASONIC:
      break;
    case LIDAR_LITE:
      initDistanceLidarLite();
      break;
    case TF_LUNA:
      initDistanceVl53L0X();
      break;
  };
}

String sensorType2String( SensorTypes sensorType ) {
  switch ( sensorType ) {
    case ULTRASONIC:
      return (F("Ultrasonic HC-SR04"));
      break;
    case LIDAR_LITE:
      return (F("Garmin Lidar Lite"));
      break;
    case TF_LUNA:
      return (F("TF Lnua"));
      break;
  };
  return "Unknown Sensor";
}

#define numAvgBuffer 10
short avgBuffer[numAvgBuffer];
int addAvgBuffer(int value) {
  int result = avgBuffer[numAvgBuffer - 1];
  for (int i = 0; i < numAvgBuffer - 1; i++) {
    avgBuffer[i] = avgBuffer[i + 1];
  }
  avgBuffer[numAvgBuffer ] = value;
  
  for (int i = 0; i < numAvgBuffer ; i++) {
    avgBuffer[i] ;
  }

  return result;
}

int getDistance(bool debugDistance) {

  delay(preMeasureDelay);

  int dist_mm_avg = 0;
  int avgCount = 0;
  for (int i = 0; i < distanceNumAveraging ; i++) {
    int dist_mm = -1;
    switch ( sensorType ) {
      case ULTRASONIC:
        dist_mm = 10.0 * distanceSensor.measureDistanceCm();
        break;
      case LIDAR_LITE:
        dist_mm = getDistanceLidarLite(debugDistance);
        break;
      case TF_LUNA:
        dist_mm = getDistanceVl53L0X(debugDistance);
        break;
    };


    if (dist_mm > 0) {
      dist_mm_avg += dist_mm;
    int result=    addAvgBuffer(dist_mm);
      avgCount++;
    }
  }

  return dist_mm_avg / avgCount;
}
