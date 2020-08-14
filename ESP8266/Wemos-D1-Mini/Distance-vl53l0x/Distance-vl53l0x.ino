#include "Adafruit_VL53L0X.h"

/**
  Example taken from
    http://www.esp8266learning.com/vl53l0x-time-of-flight-sensor-and-esp8266.php
  Library:
    https://github.com/adafruit/Adafruit_VL53L0X

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

Wiring:
  VCC 3.3V
  GND GND
  SDA D2
  SCÖ D1



  VL53L1X
  
**/

Adafruit_VL53L0X lox = Adafruit_VL53L0X();

void setup() {
  Serial.begin(115200);

  // wait until serial port opens for native USB devices
  while (! Serial) {
    delay(1);
  }

  Serial.println("Adafruit VL53L0X test");
  if (!lox.begin()) {
    Serial.println(F("Failed to boot VL53L0X"));
    while (1);
  }
  // power
  Serial.println(F("VL53L0X API Simple Ranging example\n\n"));
}


void loop() {
  VL53L0X_RangingMeasurementData_t measure;

  Serial.print("Reading a measurement... ");
  lox.rangingTest(&measure, false); // pass in 'true' to get debug data printout!

  if (measure.RangeStatus != 4) {  // phase failures have incorrect data
    Serial.print("Distance (cm): "); Serial.println(measure.RangeMilliMeter / 10.0);
  } else {
    Serial.println(" out of range ");
  }

  delay(100);
}
