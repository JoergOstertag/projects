#include "config.h"

#include "getDistance.h"

#ifdef USE_DISTANCE_VL53L0X
#include "getDistanceVl53L0X.h"
#else
#include "getDistanceLidarLite.h"
#endif


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
boolean debugDistance = true;


/**
   delay before measuring
*/
int preMeasureDelay = 0;

void initDistance() {

#ifdef _GET_DISTANCE_VL53L0X
  initDistanceVl53L0X();
#endif
#ifdef _DISTANCE_LIDAR_LITE
  initDistanceLidarLite();
#endif

}

int getDistance(boolean debugDistance) {

  delay(preMeasureDelay);

#ifdef _GET_DISTANCE_VL53L0X
  int dist_mm = getDistanceVl53L0X(debugDistance);
#endif
#ifdef _DISTANCE_LIDAR_LITE
  int dist_mm = getDistanceLidarLite(debugDistance);
#endif

  return dist_mm;

}
