#include "config.h"

#include "getDistance.h"
#include "getDistanceVl53L0X.h"
#include "Adafruit_VL53L0X.h"

/*
  Example taken from
    http://www.esp8266learning.com/vl53l0x-time-of-flight-sensor-and-esp8266.php

  Datasheet:
    https://www.st.com/resource/en/datasheet/vl53l0x.pdf

  Features of sensor:
    Measuring Field of view covered (FOV = 25 degrees)
    Measuring Range: (normal 1.2m) (long distance 2m)
    Measuring Time:
      Total time including processing: 33ms(typical)
      Measuring only: 20ms(default Accurycy +/-5%) 300ms(High Accuracy +/-3%)
    Operating voltage 2.6 to 3.5 V
    940 nm laser
    I2C Up to 400 kHz (FAST mode) serial bus
    I2C Address: 0x52

  Buy:
    https://www.aliexpress.com/item/32842745623.html
    Price: 3.15€

*/
/**
   If the measured DISTANCE is more than this we return a nagive Error Result
*/
#define MAX_DISTANCE 3000

Adafruit_VL53L0X lox = Adafruit_VL53L0X();

void initDistanceVl53L0X() {
  Serial.println("Conneting Adafruit VL53L0X ...");
  if (!lox.begin()) {
    Serial.println(F("Failed to boot VL53L0X"));
    delay(5 * 1000);
    while (1);
  }
}

int getDistanceVl53L0X(boolean debugDistance) {

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
