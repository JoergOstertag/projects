#include <Arduino.h>
#include <HCSR04.h>

/*
   This is a Demo Code for a 20-seconds Hand Wash Timer.
   If you get closer to the sonar distance sensor a timer starts
   and counts down from 20seconds to zero.

   Displaing the timer is done with a standard Neopixel Ring equiped with WS2812-LEDs

  Normally a Clock is Displayed on the Neopixel Ring
  If you get closer than 30cm the timer starts counting down
  If you get closer than 10cm the timer restarts even if already started
  if  you get nearer MAX_DIST the clock stops and the distance os shown on the Ring
    The Distance has blue LEDs. the range where the counter is started is shown as green area

  The start position of the counter is the maximum number of pixel defined (24) and is relatively adapted to the time
  Allowing retriggering while timer is active might interfer with too much power usage when both (SR04 and Neopixel) are active; which leads to distance flaws

   place for improvement:
    - use real time/timer (instead of delay) to check how much time is left
    - switch off leds after some time
*/


#define NUM_PIXELS    24
#define NEOPIXEL_PIN  D4



// The Distance Sensor is directly attached to the pins
#define SR04_TRIGGER  D2
#define SR04_ECHO     D1

// The Distance where the timer gets started normal in cm
#define DISTANCE_TIMER_START 35.0

// The distance where you can trigger a timer Reset.
// This starts the timer again each time you get nearer than this distance  in cm
#define DISTANCE_TIMER_RESET 10.0

#define DISTANCE_MAX 50.0

// Define my Time Zone to Germany
#define MYTZ TZ_Europe_Berlin

// Time for complete countdown in seconds
#define WASH_TIME_SEC 20.0

// -----------------------------------------------------------
// Libs for Wifi Connection
#include <ESP8266WiFi.h>          //https://github.com/esp8266/Arduino
//needed for library
#include <DNSServer.h>
#include <ESP8266WebServer.h>

#include <ESP_WiFiManager.h>              //https://github.com/khoih-prog/ESP_WiFiManager

// Define Wifimanager
ESP_WiFiManager ESP_wifiManager("ESP_Configuration");



// -----------------------------------------------------------
// Libraries for Time handling and NTP(Network time protocoll)
#include <time.h>                       // time() ctime()         1)
#include <sys/time.h>                   // struct timeval
#include <TZ.h>

#include <Adafruit_NeoPixel.h>

Adafruit_NeoPixel pixels(NUM_PIXELS, D4, NEO_GRB | NEO_KHZ800);
// Define LED color for hour,minute,second
int intens = 100;
uint32_t colorBackground = pixels.Color(0, 0, 0);
uint32_t colorMinute   = pixels.Color(0, 0, intens);
uint32_t colorHour     = pixels.Color(0, intens, 0);
uint32_t colorSecond   = pixels.Color(intens, intens, 0);


// Initialize sensor that uses digital pins for trigger and echo.
UltraSonicDistanceSensor distanceSensor(SR04_TRIGGER, SR04_ECHO);

// Time for each loop in seconds
#define TIMER_STEPS    0.3

// Time needed to measure distance in seconds
#define TIME_FOR_MEASURING_DISTANCE 0.1

// Delay for each loop
#define DELAY 1000.0 * (TIMER_STEPS - TIME_FOR_MEASURING_DISTANCE)

// Global variable for time left in seconds
double timeLeft     = 0.0;

/**
   set all Neopixels to Background Color
*/
void clearPixel() {
  for (int i = 0; i < NUM_PIXELS; i++) {
    pixels.setPixelColor(i, colorBackground);
  }
}

/**
   Shows the time on the Neo Pixel Ring
*/
void showTime() {
  clearPixel();
  int i;

  time_t tnow;
  struct tm *ti;

  tnow = time(nullptr) + 1;
  ti = localtime(&tnow);

  // Hour
  int h = ti->tm_hour;
  if ( h > 12 ) h -= 12;
  i = h * NUM_PIXELS / 12;
  Serial.printf("Hour=%i ", i);
  pixels.setPixelColor(i, colorHour);

  // Minute
  i = ti->tm_min * NUM_PIXELS / 60;
  Serial.printf("Min=%i ", i);
  pixels.setPixelColor(i, colorMinute);

  // Seconds
  i = ti->tm_sec * NUM_PIXELS / 60;
  Serial.printf("Sec=%i ", i);
  pixels.setPixelColor(i, colorSecond);

  Serial.println();

  // Send pixels to display
  pixels.show();

  delay(20);
}


/**
    Check current WiFi Status and reconnect if necessary
*/
wl_status_t prevStatus;
void checkWifiStatus(void) {

  if (WiFi.status() != prevStatus) {
    Serial.print("Wifi State changed to ");
    Serial.println(ESP_wifiManager.getStatus(WiFi.status()));
    prevStatus = WiFi.status();
    if ( WiFi.isConnected() ) {
      Serial.print("Local IP: ");  Serial.println(WiFi.localIP());
      Serial.print("SSID: ");      Serial.println(WiFi.SSID());
    }
  }

  if (!WiFi.isConnected()) {
    ESP_wifiManager.autoConnect();
  }
}



void setup () {
  pixels.begin();

  Serial.begin(115200);  // We initialize serial connection so that we could print values from sensor.

  Serial.println("\n");
  Serial.println("Starting ESP Neo Pixel Clock ... ");

  // Setup Wifi Manager
  ESP_wifiManager.setDebugOutput(true);
  // ESP_wifiManager.setMinimumSignalQuality(-1);
  // To reset the configuration simply diconnect from the current Wifi
  // WiFi.disconnect();
  ESP_wifiManager.autoConnect();

  // Set timezone to get the resulting time as local time (not as GMT)
  configTime(MYTZ, "pool.ntp.org");

  // Initialize Neopixel Ring
  initColors(  pixels.Color(0, 10, 0));
  initColors(  pixels.Color(0, 1, 1));
}

void setTimeLeft(double newTimeLeft ) {
  timeLeft = newTimeLeft;
}

/**
   Set all Color to given color
*/
void initColors(uint32_t color) {
  for (int i = 0; i < NUM_PIXELS; i++) {
    pixels.setPixelColor(i, color);
    pixels.show();
    delay(10);
  }
}

void showDistance(double distance) {


  uint32_t color1 = pixels.Color(0, 1, 0);
  uint32_t color2 = pixels.Color(0, 0, 20);

  // DISTANCE_MAX
  int pixelNumMin = (int)(DISTANCE_TIMER_START - DISTANCE_TIMER_RESET) / 2;
  int pixelNumMax = (int)(distance - DISTANCE_TIMER_RESET) / 2;
  for (int i = 0; i < NUM_PIXELS; i++) {
    if ( i >= pixelNumMin && i <= pixelNumMax ) {
      pixels.setPixelColor(i, color2);
    } else {
      pixels.setPixelColor(i, color1);
    }
  }

  pixels.show();
}

void setColors(int num, uint32_t color1, uint32_t color2) {
  for (int i = 0; i < num; i++) {
    pixels.setPixelColor(i, color1);
  }
  for (int i = num; i < NUM_PIXELS; i++) {
    pixels.setPixelColor(i, color2);
  }

  pixels.show();
}

boolean isTimerActive() {
  return timeLeft > 0.0;
}

void decrementTimeLeft() {

  if ( timeLeft > 0.0 ) {
    int numLeds = (int)( timeLeft / WASH_TIME_SEC *       NUM_PIXELS);
    setColors( numLeds , pixels.Color(10, 0, 0) , pixels.Color(0, 10, 0));

    delay(1000 * TIMER_STEPS);

    timeLeft -= TIMER_STEPS;

    if ( timeLeft <= 0) {
      // Flash LEDs when ready
      for ( int i = 0; i < 3; i++) {
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
  double dist = distanceSensor.measureDistanceCm();

  if ( dist > 3.0 ) { // Distance of a standerd HCSR04 Sensor can not be below 2.3 cm

    // If Timer is not triggered yet and you are nearer than 1m
    if ( isTimerActive() && dist < DISTANCE_TIMER_RESET ) {
      Serial.println("Timer started");
      setTimeLeft(WASH_TIME_SEC);
    }

    // This is a nice to have addition
    // If Timer is already triggered yet and you are nearer than 10cm
    if ( dist < DISTANCE_TIMER_START ) {
      Serial.printf("Timer started nearer than %.0f cm\n", DISTANCE_TIMER_RESET);
      setTimeLeft(WASH_TIME_SEC);
    }
  }

  // Display Clock if noting is seen by SR04
  if ( ! isTimerActive() ) {
      // Get current Time and Print it on Serial
      time_t now = time(nullptr);
      String time = String(ctime(&now));
      Serial.print( time);

      // Show time on Neopixel Ring
      showTime();
  }


  decrementTimeLeft();

  Serial.printf("Distance %5.1f cm   Time left %.1f\n", dist, timeLeft);

  checkWifiStatus();


  // Wait alittle bit so we use less power
  delay(DELAY);
}
