#include <Arduino.h>
#include <HCSR04.h>

/*
 * This is a Demo Code for a 20-seconds Hand Wash Timer.
 * If you get closer to the sonar distance sensor a timer starts 
 * and counts down from 20seconds to zero.
 * 
 * Displaing the timer is done with a standard Neopixel ring WS2812
 * 
 * place for improvement:
 *  - use real time/timer (instead of delay) to check how much time is left
 *  - adapt start position to max number of pixel defined
 *  - switch off leds after some time
 *  - Allow retriggering while timer is active. This might interfer with too much power usage when both are active; which leads to distance flaws
 *  - Advanced: Display normal clock unless triggered
*/

#include <Adafruit_NeoPixel.h>

#define NUM_PIXELS    24
#define NEOPIXEL_PIN  D4

Adafruit_NeoPixel pixels(NUM_PIXELS, D4, NEO_GRB | NEO_KHZ800);


// The Distance Sensor is directly attached to the pins
#define SR04_TRIGGER  D2
#define SR04_ECHO     D1

// The Distance where the timer gets started normal in cm
#define DISTANCE_TIMER_START 30.0

// The distance where you can trigger a timer Reset. 
// This starts the timer again each time you get nearer than this distance  in cm
#define DISTANCE_TIMER_RESET 10.0

// Initialize sensor that uses digital pins for trigger and echo.
UltraSonicDistanceSensor distanceSensor(SR04_TRIGGER, SR04_ECHO);


// Time for complete countdown in seconds
#define WASH_TIME_SEC 20.0

// Time for each loop in seconds
#define TIMER_STEPS    0.3

// Time needed to measure distance in seconds
#define TIME_FOR_MEASURING_DISTANCE 0.1

// Delay for each loop
#define DELAY 1000.0 * (TIMER_STEPS - TIME_FOR_MEASURING_DISTANCE)

// Global variable for time left in seconds
double timeLeft     = 0.0;


void setup () {
    Serial.begin(115200);  // We initialize serial connection so that we could print values from sensor.

    pixels.begin();
    initColors(  pixels.Color(0, 10, 0));
    initColors(  pixels.Color(0, 1, 1));
}

void setTimeLeft(double newTimeLeft ){
  timeLeft = newTimeLeft;
}


void initColors(uint32_t color) {
  for (int i = 0; i < NUM_PIXELS; i++) {
    pixels.setPixelColor(i, color);
    pixels.show();
    delay(20);
  }
}

void showDistance(double distance) {

  // Only show Distance if not in Timer mode
  if ( timeLeft > 0.0){
    return;
  }
  uint32_t color1 = pixels.Color(0, 1, 0);
  uint32_t color2 = pixels.Color(0, 0, 20);
  
  int pixelNumMin = (int)(DISTANCE_TIMER_START-DISTANCE_TIMER_RESET)/3;
  int pixelNumMax = (int)(distance-DISTANCE_TIMER_RESET)/3;
  for (int i = 0; i < NUM_PIXELS; i++) {
    if ( i >= pixelNumMin && i <= pixelNumMax ){
      pixels.setPixelColor(i, color2);
    } else {
      pixels.setPixelColor(i, color1);
    }
  }

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
       int numLeds = (int)( timeLeft/WASH_TIME_SEC*       NUM_PIXELS);
       setColors( numLeds , pixels.Color(10, 0, 0) , pixels.Color(0, 10, 0));

       delay(1000*TIMER_STEPS);
       
       timeLeft -= TIMER_STEPS;

      if ( timeLeft <=0){
        // Flash LEDs when ready
        for ( int i=0; i<3; i++) {
          setColors(NUM_PIXELS, pixels.Color(0, 100, 0) , pixels.Color(0, 0, 0));
          delay(80);
          setColors(NUM_PIXELS, pixels.Color(0, 0, 0) , pixels.Color(0, 0, 0));
          delay(80);
        }
      }
    }
}

void loop () {
    // do a measurement using the sensor and print the distance in centimeters.
    double dist= distanceSensor.measureDistanceCm();

    if ( dist > 3.0 ){ // Distance of a standerd HCSR04 Sensor can not be below 2.3 cm

        // If Timer is not triggered yet and you are nearer than 1m
        if ( isTimerActive() && dist < DISTANCE_TIMER_RESET ){
          Serial.println("Timer started");
          setTimeLeft(WASH_TIME_SEC);
        }

        // This is a nice to have addition
        // If Timer is already triggered yet and you are nearer than 10cm
        if ( dist < DISTANCE_TIMER_START ){
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
