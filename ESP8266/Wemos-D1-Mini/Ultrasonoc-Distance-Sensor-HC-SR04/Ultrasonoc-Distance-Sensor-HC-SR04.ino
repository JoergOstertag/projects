#include <HCSR04.h>

UltraSonicDistanceSensor distanceSensor(D5, D6);  // Initialize sensor that uses digital pins 13 and 12.

void setup () {
  Serial.begin(115200);  // We initialize serial connection so that we could print values from sensor.
}

void loop () {
  // Every 500 miliseconds, do a measurement using the sensor and print the distance in centimeters.
  float dist = distanceSensor.measureDistanceCm();
  Serial.print(dist);

  Serial.print("\t");
  
  for ( int i = 190 ; i < dist; i++) {
    Serial.print(" ");
  }
  
  Serial.println("|");
  
  delay(10);
}
