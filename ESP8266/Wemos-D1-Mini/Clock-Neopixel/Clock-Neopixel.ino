/****************************************************************************************************************************

  Get the time with ntp and display the time on a neopixel Ring

  Wifi Setup is derived from Example AutoConnect.ino using library https://github.com/khoih-prog/ESP_WiFiManager

  To configure Wifi on the device:
   - connect to an AP called ESP_XXXXXXX
   - enter http://192.168.4.1/ into browser and configure the AP and pwd

 *****************************************************************************************************************************/

// Uncomment for continuous Debug Output
#define DEBUG

// Define Neo Pixel Ring
#define NUM_PIXELS    150
#define NEOPIXEL_PIN  D2



// -----------------------------------------------------------
// Libs for Wifi Connection
#include <ESP8266WiFi.h>          //https://github.com/esp8266/Arduino
//needed for library
#include <DNSServer.h>
#include <ESP8266WebServer.h>

#include <ESP_WiFiManager.h>              //https://github.com/khoih-prog/ESP_WiFiManager


// -----------------------------------------------------------
// Libraries for Time handling and NTP(Network time protocoll)
#include <time.h>                       // time() ctime()         1)
#include <sys/time.h>                   // struct timeval
#include <TZ.h>

// -----------------------------------------------------------
// Lib for Neopixel Ring
#include <Adafruit_NeoPixel.h>


#ifdef DEBUG
 #define DEBUG_PRINTF(...)  Serial.printf (__VA_ARGS__)
#else
 #define DEBUG_PRINTF(...)
#endif

// Define Wifimanager
ESP_WiFiManager ESP_wifiManager("ESP_Configuration");

Adafruit_NeoPixel pixels(NUM_PIXELS, NEOPIXEL_PIN, NEO_GRB | NEO_KHZ800);

// Define LED color for hour,minute,second
int intens = 100;
uint32_t colorBackground = pixels.Color(0, 0, 0);
uint32_t colorMinute   = pixels.Color(0, 0, intens);
uint32_t colorHour     = pixels.Color(0, intens, 0);
uint32_t colorSecond   = pixels.Color(intens, intens, 0);


// Define my Time Zone to Germany
#define MYTZ TZ_Europe_Berlin

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
int lastSec=0;
void showTime() {
  clearPixel();
  
  double pixel;

  // -----------------------------
  timeval tv;
  gettimeofday(&tv, NULL);
  
  time_t tnow = tv.tv_sec;
  struct tm *ti;
  ti = localtime(&tnow);

  // Hour
  double h = ti->tm_hour;
  if ( h > 12 ) h -= 12;
  pixel = h * NUM_PIXELS / 12;
  DEBUG_PRINTF("  Hour: %2.0f => %5.1f pixel ", h,pixel);
  pixels.setPixelColor(pixel, colorHour);

  // Minute
  double min= ti->tm_min;
  pixel = min * NUM_PIXELS / 60;
  DEBUG_PRINTF("  Min: %2.0f => %5.1f pixel ", min,pixel);
  pixels.setPixelColor(pixel, colorMinute);

  // Seconds
  double fractionSec=tv.tv_usec/1000000.0;
  DEBUG_PRINTF("  Usec: %5.2f ",fractionSec);

  double sec= ti->tm_sec + fractionSec;
  pixel = sec * NUM_PIXELS / 60;
  double fractionPixel=pixel-floor(pixel);
  DEBUG_PRINTF("  Sec: %5.2f => %5.1f pixel ", sec,pixel);
  
  double intens1 = intens*(1.0-fractionPixel);
  uint32_t colorSecond1   = pixels.Color(intens1, intens1, 0);
  pixels.setPixelColor(pixel, colorSecond1);
  DEBUG_PRINTF("  Intens1: %5.2f",intens1);
  
  double intens2 = intens*fractionPixel;
  uint32_t colorSecond2   = pixels.Color(intens2, intens2, 0);
  pixels.setPixelColor(pixel+1, colorSecond2);
  DEBUG_PRINTF("  Intens2: %5.2f",intens2);
  


  DEBUG_PRINTF("\n");

if ( lastSec != ti->tm_sec){
  DEBUG_PRINTF("\n");
  lastSec = ti->tm_sec;
}
  // Send pixels to display
  pixels.show();
  
  delay(20);
}


/**
 *  Check current WiFi Status and reconnect if necessary
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



void setup() {
  Serial.begin(115200);
  Serial.println("\n");
  Serial.println("Starting ESP Neo Pixel Clock ... ");

  ESP_wifiManager.setDebugOutput(true);

  // ESP_wifiManager.setMinimumSignalQuality(-1);

  // To reset the configuration simply diconnect from the current Wifi
  // WiFi.disconnect();

  ESP_wifiManager.autoConnect();

  // Set timezone to get the resulting time as local time (not as GMT)
  configTime(MYTZ, "pool.ntp.org");

  // Initialize Neopixel Ring
  pixels.begin();

}

void loop() {
  checkWifiStatus();


  // Get current Time and Print it on Serial
  time_t now = time(nullptr);
  String time = String(ctime(&now));
  //Serial.print( time);

  // SHow time on Neopixel Ring
  showTime();

  // Wait a little bit, so we do not flood the console
//  delay(1000.0 * 60.0/NUM_PIXELS/5.0);
  delay(10);

}
