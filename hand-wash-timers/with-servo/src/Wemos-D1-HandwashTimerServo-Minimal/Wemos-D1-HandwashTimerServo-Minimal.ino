#include <Arduino.h>
#include <HCSR04.h>
#include <Servo.h>

/*
 * This is a mini Code reduced to the essentially needed parts
 * 
 * This is a Demo Code for a 20-seconds Hand Wash Timer.
 * If you get closer to the sonar distance sensor a timer starts 
 * and counts down from 20seconds to zero.
 * 
 * Displaing the timer is done with a standard Servo
 * 
 * 

 */


// The Distance Sensor is directly attached to the pins
// Initialize sensor that uses digital pins for trigger and echo.
UltraSonicDistanceSensor distanceSensor(D1,D2);

Servo myservo;  // create servo object to control a servo

void setup () {
    Serial.begin(115200);  // We initialize serial connection so that we could print values from sensor.

    myservo.attach(D3);  // attaches the servo to the servo object
    myservo.write(0);
    delay(400);
}

void loop () {
    // do a measurement using the sensor in centimeters.
    double dist= distanceSensor.measureDistanceCm();

    // Distance of a standerd HCSR04 Sensor can not be below 2.3 cm
    if ( dist > 2.0 && dist < 30){ 

      // Count for 20seconds
      for ( int i = 20  ; i>0 ; i-- ) {
          Serial.println(i);
          myservo.write(i*10);
          delay(1000);
      }

    }

    // Wait alittle bit 
    delay(200);
}
