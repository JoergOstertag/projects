#include <Arduino.h>
#include <HCSR04.h>
#include <Servo.h>

/*
 * This is a Demo Code for a 20-seconds Hand Wash Timer.
 * If you get closer to the sonar distance sensor a timer starts 
 * and counts down from 20seconds to zero.
 * 
 * Displaing the timer is done with a standard Servo
 * 
 * 
 * 
 * Used Hardware:
 *    the cost for the electronic parts is about 7€ 
 *    based on bying 10 sets
 * 
 * 
 * D1 mini - Mini NodeMcu 4M bytes Lua WIFI Internet of Things development board based ESP8266 WeMos
 *    https://www.aliexpress.com/item/32651256441.html
 *    price: 2.216€
 * 
 * HC-SR04 to world Ultrasonic Wave Detector Ranging Module for arduino Distance Sensor
 *    https://www.aliexpress.com/item/32786749709.html
 *    price: 0.782€ 
 *    
 * Micro Servo Motor For Robot or RC Airplane SG90 9G
 *    https://www.aliexpress.com/item/4000093416296.html   
 *    price: 1.090€
 *    
 * Mini Breadboard kit for Arduino
 *    https://www.aliexpress.com/item/32564367417.htm
 *    price: 0.270€
 *
 * Dupont Line (small connection Wired)
 *    https://www.aliexpress.com/item/32956301840.html
 *    price for 40pins: 1.52€
 *    Need 
 *      - one set Male - Male
 *      - one set Male - Female
 *      
 * First Try for a housing (Simple copy paste from others)
 *    https://github.com/JoergOstertag/openScad/tree/master/HandwashTimer
 *    printing takes about 3h
 *    Material Cost about 1.46€
 */

// The Distance Sensor is directly attached to the pins
#define SR04_TRIGGER D1
#define SR04_ECHO D2

#define SERVO_PIN D3


// THe Distance where the timer gets started normal
#define DISTANCE_TIMER_START 50.0

// The distance where you can trigger a timer Reset. 
// This starts the timer again each time you get nearer than this distance
#define DISTANCE_TIMER_RESET 10.0


// Initialize sensor that uses digital pins for trigger and echo.
UltraSonicDistanceSensor distanceSensor(SR04_TRIGGER, SR04_ECHO);

Servo myservo;  // create servo object to control a servo

#define DELAY 100.0
// #define WASH_TIME_SEC 20.0
#define WASH_TIME_SEC 20.0

#define SERVO_POSITION_MAX 200.0
#define SERVO_POSITION_MIN 0.0
#define SERVO_POSITION_INCREMENT (SERVO_POSITION_MAX - SERVO_POSITION_MIN) / -WASH_TIME_SEC * ( DELAY/1000.0 )

float servoPosition=SERVO_POSITION_MIN;

void setup () {
    Serial.begin(115200);  // We initialize serial connection so that we could print values from sensor.

    servoPosition= SERVO_POSITION_MIN;

    myservo.attach(SERVO_PIN);  // attaches the servo to the servo object
    servoSet(servoPosition);
    delay(400);
    myservo.detach();  // attaches the servo to the servo object
}

void servoSet(int servoPosition){
    myservo.write(servoPosition);
}



void loop () {
    // do a measurement using the sensor and print the distance in centimeters.
    double dist= distanceSensor.measureDistanceCm();

    if ( dist > 3.0 ){ // Distance of a standerd HCSR04 Sensor can not be below 2.3 cm

        // If Servo is not triggered yet and you are nearer than 1m
        if ( servoPosition <= SERVO_POSITION_MIN && dist < DISTANCE_TIMER_START ){
          Serial.println("Timer started");
          servoPosition=SERVO_POSITION_MAX;
          myservo.attach(SERVO_PIN);  // attaches the servo to the servo object
        }

        // This is a nice to have addition
        // If Servo is already triggered yet and you are nearer than 10cm
        if ( dist < DISTANCE_TIMER_RESET ){
          Serial.printf("Timer started nearer than %.0f cm\n",DISTANCE_TIMER_RESET);
          servoPosition=SERVO_POSITION_MAX;
          myservo.attach(SERVO_PIN);  // attaches the servo to the servo object
        }
    }

    // If timer is on ==> move the servoas
    if ( servoPosition > SERVO_POSITION_MIN){
        servoPosition += SERVO_POSITION_INCREMENT;
        servoSet(servoPosition);

        // Next Part is a nice to have 
        // detach Servo if currently not in use
        if ( servoPosition == SERVO_POSITION_MIN ){
          delay(400); // Wait a little bit to be sure it is in MIN position
          myservo.detach();  // attaches the servo to the servo object
        }
    }

    Serial.printf("Distance %5.1f cm   Servo position increment(%.1f) %.1f\n",dist,SERVO_POSITION_INCREMENT,servoPosition);

    // Wait alittle bit so we get a correct timing 
    delay(DELAY);
}
