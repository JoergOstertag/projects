#include "getDistance.h"

Adafruit_VL53L0X lox = Adafruit_VL53L0X();

#define MAX_DISTANCE 1990

boolean debugDistance = true;

void initDistance(){
  // VL53L0X

  Serial.println("Conneting Adafruit VL53L0X ...");
  if (!lox.begin()) {
    Serial.println(F("Failed to boot VL53L0X"));
    delay(5 * 1000);
    while (1);
  }
}

int getDistance(boolean debugDistance) {
 
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
      if ( retryCount > 0 ) {
        Serial.println("Retry succeded");
      }
    } else if ( retryCount++ < 2 ) {
      // Serial.println("EL: " + String(servoPosEl) + " AZ: " + String(servoPosAz) + ": Retry " + String(retryCount));
      delay(100);
    } else {
      doRetry = false;
    }
  } while ( doRetry );

  if (measure.RangeStatus != 4) {  // phase failures have incorrect data
    boolean debugDistance = false;
    if ( dist_mm > MAX_DISTANCE) {
      dist_mm = -1;
    } else {
    }
  } else {
    dist_mm = -1;
  }
  if ( debugDistance) {
    Serial.print( " Distance: " + String(dist_mm));
    if ( retryCount > 0) {
      Serial.print( " : Retry " + String(retryCount) + " " );
    }
  }
  return dist_mm;
}
