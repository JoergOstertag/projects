#include "getDistance.h"

Adafruit_VL53L0X lox = Adafruit_VL53L0X();

/**
 * If the measured DISTANCE is more than this we return a nagive Error Result
 */
#define MAX_DISTANCE 3000

/**
 * The Maximum Number of retries
 */
int distanceMaxRetry = 2;

/**
 * If we need a retry we wait for this long
 */
int distanceRetryDelay = 20;

/**
 * Field of View of the Distance Sensor
 */
int distanceFov = 20;

/**
 * Print Debugging output for Distance on Serial Console
 */
boolean debugDistance = true;


/**
 * delay before measuring
 */
int preMeasureDelay=0;
 
void initDistance() {
  Serial.println("Conneting Adafruit VL53L0X ...");
  if (!lox.begin()) {
    Serial.println(F("Failed to boot VL53L0X"));
    delay(5 * 1000);
    while (1);
  }
}

int getDistance(boolean debugDistance) {

  delay(preMeasureDelay);

  VL53L0X_RangingMeasurementData_t measure;

  int retryCount = 0;
  int dist_mm = -1;
  boolean doRetry = true;
  do {
    // Serial.print("Reading a measurement... ");
    lox.rangingTest(&measure, false); // pass in 'true' to get debug data printout!
    dist_mm = measure.RangeMilliMeter;
    if ( dist_mm > 1 && dist_mm < MAX_DISTANCE && measure.RangeStatus != 4) {
      doRetry = false;
    } else if ( retryCount++ < distanceMaxRetry ) {
      delay(distanceRetryDelay);
    } else {
      doRetry = false;
    }
  } while ( doRetry );

  if (measure.RangeStatus != 4) {  // phase failures have incorrect data
    if ( dist_mm > MAX_DISTANCE) {
      dist_mm = -3;
    }
  } else {
    dist_mm = -2;
  }
  
  if ( debugDistance) {
    Serial.print( " Distance: " + String(dist_mm));
    if ( dist_mm > 0 && retryCount > 0) {
      Serial.print( " : Retry " + String(retryCount) + " " );
    }
  }
  return dist_mm;
}
