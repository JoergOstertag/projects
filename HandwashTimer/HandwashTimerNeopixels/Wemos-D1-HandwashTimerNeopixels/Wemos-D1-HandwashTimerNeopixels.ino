#include <Arduino.h>
#include <HCSR04.h>

/*
 * This is a Demo Code for a 20-seconds Hand Wash Timer.
 * If you get closer to the sonar distance sensor a timer starts 
 * and counts down from 20seconds to zero.
 * 
 * Displaing the timer is done with a standard Neopixel ring WS2812
 * 
 */

#include <Adafruit_NeoPixel.h>

#define NUM_PIXELS    24
#define NEOPIXEL_PIN  D4

Adafruit_NeoPixel pixels(NUM_PIXELS, D4, NEO_GRB | NEO_KHZ800);


// The Distance Sensor is directly attached to the pins
#define SR04_TRIGGER  D1
#define SR04_ECHO     D2

// The Distance where the timer gets started normal
#define DISTANCE_TIMER_START 30.0

// The distance where you can trigger a timer Reset. 
// This starts the timer again each time you get nearer than this distance
#define DISTANCE_TIMER_RESET 10.0

// Initialize sensor that uses digital pins for trigger and echo.
UltraSonicDistanceSensor distanceSensor(SR04_TRIGGER, SR04_ECHO);


#define DELAY 100.0


double timeLeft     = 0.0;

#define WASH_TIME_SEC 20.0
#define TIMER_STEPS    0.1


void setup () {
    Serial.begin(115200);  // We initialize serial connection so that we could print values from sensor.

    pixels.begin();
    initColors(  pixels.Color(0, 10, 0));
}

void setTimeLeft(double newTimeLeft ){
  timeLeft = newTimeLeft;
}


void initColors(uint32_t color) {
  for (int i = 0; i < NUM_PIXELS; i++) {
    pixels.setPixelColor(i, color);
    pixels.show();
    delay(50);
  }
}

void showDistance(double distance) {

  if ( timeLeft > 0.0){
    return;
  }
  uint32_t color1 = pixels.Color(0, 10, 0);
  uint32_t color2 = pixels.Color(0, 0, 10);
  
  for (int i = 0; i < NUM_PIXELS; i++) {
    pixels.setPixelColor(i, color1);
  }

  int pixelNum = (int)(distance-DISTANCE_TIMER_RESET)/3;
  pixels.setPixelColor(pixelNum, color2);
  pixels.show();
}

void setColors(int num, uint32_t color1,uint32_t color2) {
  for (int i = 0; i < num; i++) {
    pixels.setPixelColor(i, color1);
  }
  for (int i = num; i < NUM_PIXELS; i++) {
    pixels.setPixelColor(i, color2);
  }

  pixels.show();
}

boolean isTimerActive(){
  return timeLeft > 0.0;
}
  
void decrementTimeLeft(){
  
    if ( timeLeft > 0.0 ){
       setColors( (int)timeLeft-1 , pixels.Color(10, 0, 0) , pixels.Color(0, 10, 0));

       delay(1000*TIMER_STEPS);
       
       timeLeft -= TIMER_STEPS;

    }
}

void loop () {
    // do a measurement using the sensor and print the distance in centimeters.
    double dist= distanceSensor.measureDistanceCm();

    if ( dist > 3.0 ){ // Distance of a standerd HCSR04 Sensor can not be below 2.3 cm

        // If Timer is not triggered yet and you are nearer than 1m
        if ( isTimerActive() && dist < DISTANCE_TIMER_START ){
          Serial.println("Timer started");
          setTimeLeft(WASH_TIME_SEC);
        }

        // This is a nice to have addition
        // If Timer is already triggered yet and you are nearer than 10cm
        if ( dist < DISTANCE_TIMER_RESET ){
          Serial.printf("Timer started nearer than %.0f cm\n",DISTANCE_TIMER_RESET);
          setTimeLeft(WASH_TIME_SEC);
        }
    }

    showDistance(dist);

    decrementTimeLeft();

    Serial.printf("Distance %5.1f cm   Time left %.1f\n",dist,timeLeft);

    // Wait alittle bit so we use less power
    delay(DELAY);
}
